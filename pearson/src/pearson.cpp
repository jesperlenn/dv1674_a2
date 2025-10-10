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
#ifdef MULTI

  if (argc != 3 && argc != 4)
    {
      std::cerr << "Usage: " << argv[0] << " [dataset] [outfile] {threads}" << std::endl;
      std::exit (1);
    }

#endif // MULTI
#ifndef MULTI

  if (argc != 3)
    {
      std::cerr << "Usage: " << argv[0] << " [dataset] [outfile]" << std::endl;
      std::exit (1);
    }

#endif // !MULTI

  std::vector<Vector> datasets{ Dataset::read (argv[1]) };

#ifdef MULTI

  std::vector<double> corrs{ Analysis::correlation_coefficients (
      datasets, (argc == 4) ? atoi (argv[3]) : 1) };

#endif // MULTI
#ifndef MULTI

  std::vector<double> corrs{ Analysis::correlation_coefficients (datasets) };

#endif // !MULTI

  Dataset::write (corrs, argv[2]);

  return 0;
}
