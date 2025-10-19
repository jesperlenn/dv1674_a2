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
    if (argc != 4) {
        std::cerr << "Usage: " << argv[0] << " [radius] [infile] [outfile]\n";
        std::exit(1);
    }

    PPM::Reader reader {};
    PPM::Writer writer {};

    Matrix m { reader(argv[2]) };
    unsigned int radius { static_cast<unsigned>(std::stoul(argv[1])) };

    Matrix blurred { Filter::blur(m, radius) };
    writer(blurred, argv[3]);

    return 0;
}
