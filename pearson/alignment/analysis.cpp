/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "analysis.hpp"
#include "vector.hpp"
#include <algorithm>
#include <vector>

namespace Analysis
{
std::vector<double>
correlation_coefficients (std::vector<Vector> datasets)
{
  std::vector<double> result{};
  Vector temp;
  unsigned size;
  Vector vec1, vec2;

  size = datasets.size ();
  for (int i = 0; i < size; i++)
    {
      datasets[i].prepeare ();
    }

  for (auto sample1{ 0 }; sample1 < size - 1; sample1++)
    {
      for (auto sample2{ sample1 + 1 }; sample2 < size; sample2++)
        {
          auto r{ datasets[sample1].dot (datasets[sample2]) };
          result.push_back (std::max (std::min (r, 1.0), -1.0));
        }
    }

  return result;
}
}; // namespace Analysis
