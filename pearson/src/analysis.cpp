/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "../inc/analysis.hpp"
#include <algorithm>
#include <vector>

namespace Analysis
{

std::vector<double>
correlation_coefficients (std::vector<Vector> datasets)
{
  std::vector<double> result{};

  for (int sample1{ 0 }; sample1 < datasets.size () - 1; sample1++)
    {
      for (int sample2{ sample1 + 1 }; sample2 < datasets.size (); sample2++)
        {
          double corr{ pearson (datasets[sample1], datasets[sample2]) };
          result.push_back (corr);
        }
    }

  return result;
}

double
pearson (Vector vec1, Vector vec2)
{
  double x_mean{ vec1.mean () };
  double y_mean{ vec2.mean () };

  Vector x_mm{ vec1 - x_mean };
  Vector y_mm{ vec2 - y_mean };

  double x_mag{ x_mm.magnitude () };
  double y_mag{ y_mm.magnitude () };

  Vector x_mm_over_x_mag{ x_mm / x_mag };
  Vector y_mm_over_y_mag{ y_mm / y_mag };

  double r{ x_mm_over_x_mag.dot (y_mm_over_y_mag) };

  return std::max (std::min (r, 1.0), -1.0);
}
}; // namespace Analysis
