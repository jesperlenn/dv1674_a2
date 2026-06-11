/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "matrix.hpp"
#include "ppm.hpp"
#include "filters.hpp"
#include <cstdlib>
#include <iostream>

int main(int argc, char const* argv[])
{
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0] << " [radius] [infile] [outfile] [threads]\n";
        std::exit(1);
    }

    PPM::Reader reader {};
    PPM::Writer writer {};

    Matrix m { reader(argv[2]) };
    unsigned int radius { static_cast<unsigned>(std::stoul(argv[1])) };
    unsigned int threads = std::stoi(argv[4]);

    Matrix blurred { Filter::blur(m, radius, threads) };
    writer(blurred, argv[3]);

    return 0;
}
