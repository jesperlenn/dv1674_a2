/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "../inc/analysis.hpp"
#include "../inc/dataset.hpp"
#include <cstdlib>
#include <iostream>
#include <vector>

int
main (int argc, char const *argv[])
{
  if (argc != 3 && argc != 4)
    {
      std::cerr << "Usage: " << argv[0] << " [dataset] [outfile] {threads}" << std::endl;
      std::exit (1);
    }

  std::vector<Vector> datasets{ Dataset::read (argv[1]) };
  std::vector<double> corrs{ Analysis::correlation_coefficients (
      datasets, (argc == 4) ? atoi (argv[3]) : 1) };
  Dataset::write (corrs, argv[2]);

  return 0;
}
