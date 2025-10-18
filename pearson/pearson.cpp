/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "analysis.hpp"
#include "dataset.hpp"
#include <cstdlib>
#include <iostream>

int
main (int argc, char const *argv[])
{
#ifdef PAR
  if (argc != 3 && argc != 4)
    {
      std::cerr << "Usage: " << argv[0] << " [dataset] [outfile] [threads]"
                << std::endl;
      std::exit (1);
    }
#endif // PAR
#ifndef PAR
  if (argc != 3)
    {
      std::cerr << "Usage: " << argv[0] << " [dataset] [outfile]" << std::endl;
      std::exit (1);
    }
#endif // !PAR

  auto datasets{ Dataset::read (argv[1]) };

#ifdef PAR
  auto corrs = Analysis::correlation_coefficients (
      datasets, ((argc == 4) ? atoi (argv[3]) : 1));
#endif // PAR
#ifndef PAR
  auto corrs = Analysis::correlation_coefficients (datasets);
#endif // !PAR
  Dataset::write (corrs, argv[2]);

  return 0;
}
