#include "filters.hpp"
#include "matrix.hpp"
#include "ppm.hpp"
#include <cmath>

namespace Filter {

namespace Gauss {

void get_weights(int n, double *weights_out) {
    for (auto i{0}; i <= n; i++) {
        double x{static_cast<double>(i) * max_x / n};
        weights_out[i] = exp(-x * x * pi);
    }
}

} // namespace Gauss

Matrix blur(Matrix m, const int radius) {

    auto dst{m};

    double w[Gauss::max_radius]{};
    Gauss::get_weights(radius, w);

    const int W = dst.get_x_size();
    const int H = dst.get_y_size();
    const int size = W * H;

    unsigned char *R = dst.get_R();
    unsigned char *G = dst.get_G();
    unsigned char *B = dst.get_B();

    unsigned char *R_Scratch = new unsigned char[size];
    unsigned char *G_Scratch = new unsigned char[size];
    unsigned char *B_Scratch = new unsigned char[size];

    for (int x = 0; x < W; ++x) {

        for (int y = 0; y < H; ++y) {
            int index = y * W + x;
            double r = w[0] * R[index];
            double g = w[0] * G[index];
            double b = w[0] * B[index];
            double n = w[0];

            for (int wi = 1; wi <= radius; ++wi) {
                double wc = w[wi];
                int x2 = x - wi;
                if (x2 >= 0) {
                    int index2 = y * W + x2;
                    r += wc * R[index2];
                    g += wc * G[index2];
                    b += wc * B[index2];
                    n += wc;
                }

                x2 = x + wi;
                if (x2 < W) {
                    int index2 = y * W + x2;
                    r += wc * R[index2];
                    g += wc * G[index2];
                    b += wc * B[index2];
                    n += wc;
                }
            }
            R_Scratch[index] = r / n;
            G_Scratch[index] = g / n;
            B_Scratch[index] = b / n;
        }
    }

    for (int x = 0; x < W; ++x) {
        for (int y = 0; y < H; ++y) {
            int index = y * W + x;
            double r = w[0] * R_Scratch[index];
            double g = w[0] * G_Scratch[index];
            double b = w[0] * B_Scratch[index];
            double n = w[0];

            for (int wi = 1; wi <= radius; ++wi) {
                double wc = w[wi];
                int y2 = y - wi;
                if (y2 >= 0) {
                    int index2 = y2 * W + x;
                    r += wc * R_Scratch[index2];
                    g += wc * G_Scratch[index2];
                    b += wc * B_Scratch[index2];
                    n += wc;
                }

                y2 = y + wi;
                if (y2 < H) {
                    int index2 = y2 * W + x;
                    r += wc * R_Scratch[index2];
                    g += wc * G_Scratch[index2];
                    b += wc * B_Scratch[index2];
                    n += wc;
                }
            }

            R[index] = r / n;
            G[index] = g / n;
            B[index] = b / n;
        }
    }
    return dst;
}

} // namespace Filter