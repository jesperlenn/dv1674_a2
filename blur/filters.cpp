/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "filters.hpp"
#include "matrix.hpp"
#include "ppm.hpp"
#include <cmath>

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

    Matrix blur(Matrix m, const int radius)
    {
        Matrix scratch{PPM::max_dimension};
        auto dst{m};

        const int W = dst.get_x_size();
        const int H = dst.get_y_size();

        // Compute weights once
        double w[Filter::Gauss::max_radius]{};
        Gauss::get_weights(radius, w);

        // -------- HORIZONTAL PASS (contiguous in memory) --------
        for (int y = 0; y < H; ++y)
        {
            for (int x = 0; x < W; ++x)
            {
                double r = w[0] * dst.r(x, y);
                double g = w[0] * dst.g(x, y);
                double b = w[0] * dst.b(x, y);
                double n = w[0];

                for (int wi = 1; wi <= radius; ++wi)
                {
                    const double wc = w[wi];

                    int xL = x - wi;
                    if (xL >= 0)
                    {
                        r += wc * dst.r(xL, y);
                        g += wc * dst.g(xL, y);
                        b += wc * dst.b(xL, y);
                        n += wc;
                    }

                    int xR = x + wi;
                    if (xR < W)
                    {
                        r += wc * dst.r(xR, y);
                        g += wc * dst.g(xR, y);
                        b += wc * dst.b(xR, y);
                        n += wc;
                    }
                }

                scratch.r(x, y) = r / n;
                scratch.g(x, y) = g / n;
                scratch.b(x, y) = b / n;
            }
        }

        // -------- VERTICAL PASS --------
        // (vertical access is strided; still benefit from hoisted weights & locals)
        for (int y = 0; y < H; ++y)
        {
            for (int x = 0; x < W; ++x)
            {
                double r = w[0] * scratch.r(x, y);
                double g = w[0] * scratch.g(x, y);
                double b = w[0] * scratch.b(x, y);
                double n = w[0];

                for (int wi = 1; wi <= radius; ++wi)
                {
                    const double wc = w[wi];

                    int yT = y - wi;
                    if (yT >= 0)
                    {
                        r += wc * scratch.r(x, yT);
                        g += wc * scratch.g(x, yT);
                        b += wc * scratch.b(x, yT);
                        n += wc;
                    }

                    int yB = y + wi;
                    if (yB < H)
                    {
                        r += wc * scratch.r(x, yB);
                        g += wc * scratch.g(x, yB);
                        b += wc * scratch.b(x, yB);
                        n += wc;
                    }
                }

                dst.r(x, y) = r / n;
                dst.g(x, y) = g / n;
                dst.b(x, y) = b / n;
            }
        }

        return dst;
    }
}
