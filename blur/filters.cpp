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

    // hor
    for (int index = 0; index < W * H; ++index) {
        int x = index % W;

        double r = w[0] * R[index];
        double g = w[0] * G[index];
        double b = w[0] * B[index];
        double n = w[0];

        for (int wi = 1; wi <= radius; ++wi) {
            double wc = w[wi];

            int xL = x - wi;
            if (xL >= 0) {
                int indexL = index - wi;
                r += wc * R[indexL];
                g += wc * G[indexL];
                b += wc * B[indexL];
                n += wc;
            }

            int xR = x + wi;
            if (xR < W) {
                int indexR = index + wi;
                r += wc * R[indexR];
                g += wc * G[indexR];
                b += wc * B[indexR];
                n += wc;
            }
        }

        R_Scratch[index] = r / n;
        G_Scratch[index] = g / n;
        B_Scratch[index] = b / n;
    }

    // ver
    for (int index = 0; index < W * H; ++index) {
        int y = index / W;

        double r = w[0] * R_Scratch[index];
        double g = w[0] * G_Scratch[index];
        double b = w[0] * B_Scratch[index];
        double n = w[0];

        for (int wi = 1; wi <= radius; ++wi) {
            double wc = w[wi];

            int yU = y - wi;
            if (yU >= 0) {
                int indexU = index - wi * W;
                r += wc * R_Scratch[indexU];
                g += wc * G_Scratch[indexU];
                b += wc * B_Scratch[indexU];
                n += wc;
            }

            int yD = y + wi;
            if (yD < H) {
                int indexD = index + wi * W;
                r += wc * R_Scratch[indexD];
                g += wc * G_Scratch[indexD];
                b += wc * B_Scratch[indexD];
                n += wc;
            }
        }

        R[index] = r / n;
        G[index] = g / n;
        B[index] = b / n;
    }

    delete[] R_Scratch;
    delete[] G_Scratch;
    delete[] B_Scratch;

    return dst;
}

} // namespace Filter