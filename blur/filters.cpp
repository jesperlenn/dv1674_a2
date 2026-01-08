/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "filters.hpp"
#include "matrix.hpp"
#include "ppm.hpp"
#include <cmath>

#include <pthread.h>
#include <algorithm> // std::min

namespace Filter
{
    namespace Gauss
    {
        void get_weights(int n, double *weights_out)
        {
            for (auto i{0}; i <= n; i++)
            {
                double x{static_cast<double>(i) * max_x / n};
                weights_out[i] = exp(-x * x * pi);
            }
        }
    }

    struct BlurTask
    {
        int W, H;
        int radius;
        const double *w;

        unsigned char *R;
        unsigned char *G;
        unsigned char *B;

        unsigned char *R_S;
        unsigned char *G_S;
        unsigned char *B_S;

        int row_begin; // inclusive
        int row_end;   // exclusive

        pthread_barrier_t *barrier;
    };

    static void *blur_worker(void *arg)
    {
        BlurTask *t = static_cast<BlurTask *>(arg);

        const int W = t->W;
        const int H = t->H;
        const int radius = t->radius;
        const double *w = t->w;

        unsigned char *R = t->R;
        unsigned char *G = t->G;
        unsigned char *B = t->B;

        unsigned char *R_S = t->R_S;
        unsigned char *G_S = t->G_S;
        unsigned char *B_S = t->B_S;

        // -------- HORIZONTAL PASS (row-partitioned, contiguous in memory) --------
        for (int y = t->row_begin; y < t->row_end; ++y)
        {
            const int row_base = y * W;
            for (int x = 0; x < W; ++x)
            {
                const int index = row_base + x;

                double r = w[0] * R[index];
                double g = w[0] * G[index];
                double b = w[0] * B[index];
                double n = w[0];

                for (int wi = 1; wi <= radius; ++wi)
                {
                    const double wc = w[wi];

                    int xL = x - wi;
                    if (xL >= 0)
                    {
                        const int indexL = index - wi;
                        r += wc * R[indexL];
                        g += wc * G[indexL];
                        b += wc * B[indexL];
                        n += wc;
                    }

                    int xR = x + wi;
                    if (xR < W)
                    {
                        const int indexR = index + wi;
                        r += wc * R[indexR];
                        g += wc * G[indexR];
                        b += wc * B[indexR];
                        n += wc;
                    }
                }

                R_S[index] = static_cast<unsigned char>(r / n);
                G_S[index] = static_cast<unsigned char>(g / n);
                B_S[index] = static_cast<unsigned char>(b / n);
            }
        }

        // Ensure scratch is fully written before vertical pass starts
        pthread_barrier_wait(t->barrier);

        // -------- VERTICAL PASS (row-partitioned; reads scratch, writes output) --------
        for (int y = t->row_begin; y < t->row_end; ++y)
        {
            const int row_base = y * W;
            for (int x = 0; x < W; ++x)
            {
                const int index = row_base + x;

                double r = w[0] * R_S[index];
                double g = w[0] * G_S[index];
                double b = w[0] * B_S[index];
                double n = w[0];

                for (int wi = 1; wi <= radius; ++wi)
                {
                    const double wc = w[wi];

                    int yU = y - wi;
                    if (yU >= 0)
                    {
                        const int indexU = index - wi * W;
                        r += wc * R_S[indexU];
                        g += wc * G_S[indexU];
                        b += wc * B_S[indexU];
                        n += wc;
                    }

                    int yD = y + wi;
                    if (yD < H)
                    {
                        const int indexD = index + wi * W;
                        r += wc * R_S[indexD];
                        g += wc * G_S[indexD];
                        b += wc * B_S[indexD];
                        n += wc;
                    }
                }

                R[index] = static_cast<unsigned char>(r / n);
                G[index] = static_cast<unsigned char>(g / n);
                B[index] = static_cast<unsigned char>(b / n);
            }
        }

        return nullptr;
    }

    Matrix blur(Matrix m, const int radius, unsigned int threads)
    {
        auto dst{m};
        const int W = dst.get_x_size();
        const int H = dst.get_y_size();

        // Sanitize thread count
        if (threads < 1)
            threads = 1;
        if (threads > H)
            threads = H; // no point having more threads than rows

        // Compute weights once
        double w[Filter::Gauss::max_radius]{};
        Gauss::get_weights(radius, w);

        // Pointers to planar channels
        unsigned char *R = dst.get_R();
        unsigned char *G = dst.get_G();
        unsigned char *B = dst.get_B();

        const int size = W * H;
        unsigned char *R_Scratch = new unsigned char[size];
        unsigned char *G_Scratch = new unsigned char[size];
        unsigned char *B_Scratch = new unsigned char[size];

        pthread_barrier_t barrier;
        pthread_barrier_init(&barrier, nullptr, static_cast<unsigned>(threads));

        pthread_t *tids = new pthread_t[threads];
        BlurTask *tasks = new BlurTask[threads];

        const int rows_per = (H + threads - 1) / threads;

        for (int t = 0; t < threads; ++t)
        {
            const int row_begin = t * rows_per;
            const int row_end = std::min(H, row_begin + rows_per);

            tasks[t] = BlurTask{
                W, H,
                radius,
                w,
                R, G, B,
                R_Scratch, G_Scratch, B_Scratch,
                row_begin, row_end,
                &barrier};

            pthread_create(&tids[t], nullptr, blur_worker, &tasks[t]);
        }

        for (int t = 0; t < threads; ++t)
        {
            pthread_join(tids[t], nullptr);
        }

        pthread_barrier_destroy(&barrier);

        delete[] tids;
        delete[] tasks;

        delete[] R_Scratch;
        delete[] G_Scratch;
        delete[] B_Scratch;

        return dst;
    }
}
