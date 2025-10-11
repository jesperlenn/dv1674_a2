/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "analysis.hpp"
#include <algorithm>
#include <cfloat>
#include <cmath>
#include <iostream>
#include <list>
#include <vector>

namespace Analysis
{
double *mean_cache;
double *magnitude_cache;

std::vector<double>
correlation_coefficients (std::vector<Vector> datasets)
{
  std::vector<double> result{};
  unsigned size;

  size = datasets.size ();

  mean_cache = new double[size];
  magnitude_cache = new double[size];

  for (int i = 0; i < size; i += 4)
    {
      mean_cache[i + 0] = DBL_MAX;
      mean_cache[i + 1] = DBL_MAX;
      mean_cache[i + 2] = DBL_MAX;
      mean_cache[i + 3] = DBL_MAX;
      magnitude_cache[i + 0] = DBL_MAX;
      magnitude_cache[i + 1] = DBL_MAX;
      magnitude_cache[i + 2] = DBL_MAX;
      magnitude_cache[i + 3] = DBL_MAX;
    }

  for (auto sample1{ 0 }; sample1 < size - 1; sample1++)
    {
      for (auto sample2{ sample1 + 1 }; sample2 < size; sample2++)
        {
          auto corr{ pearson (datasets[sample1], datasets[sample2], sample1,
                              sample2) };
          result.push_back (corr);
        }
    }

  return result;
}

double
pearson (Vector vec1, Vector vec2, unsigned x, unsigned y)
{
  double x_mean = mean_cache[x];
  double y_mean = mean_cache[y];
  double x_mag = magnitude_cache[x];
  double y_mag = magnitude_cache[y];

  if (x_mean == DBL_MAX)
    {
      x_mean = vec1.mean ();
      mean_cache[x] = x_mean;
    }
  else
    {
      if (x_mean != vec1.mean ())
        {
          std::cerr << "non matching\n";
        }
    }

  if (y_mean == DBL_MAX)
    {
      y_mean = vec2.mean ();
      mean_cache[y] = y_mean;
    }
  else
    {
      if (y_mean != vec2.mean ())
        {
          std::cerr << "non matching\n";
        }
    }

  if (x_mag == DBL_MAX)
    {
      x_mag = vec1.magnitude ();
      magnitude_cache[x] = x_mag;
    }
  else
    {
      if (x_mag != vec1.magnitude ())
        {
          std::cerr << "non matching\n";
        }
    }

  if (y_mag == DBL_MAX)
    {
      y_mag = vec2.magnitude ();
      magnitude_cache[y] = y_mag;
    }
  else
    {
      if (x_mag != vec2.magnitude ())
        {
          std::cerr << "non matching\n";
        }
    }
  auto x_mm{ vec1 - x_mean };
  auto y_mm{ vec2 - y_mean };

  auto x_mm_over_x_mag{ x_mm / x_mag };
  auto y_mm_over_y_mag{ y_mm / y_mag };

  auto r{ x_mm_over_x_mag.dot (y_mm_over_y_mag) };

  return std::max (std::min (r, 1.0), -1.0);
}
}; // namespace Analysis
