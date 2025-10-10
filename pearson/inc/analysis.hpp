/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "vector.hpp"
#include <vector>

#if !defined(ANALYSIS_HPP)
#define ANALYSIS_HPP

namespace Analysis
{

typedef struct
{
  int index;
  Vector *sample1;
  Vector *sample2;
} pair;

typedef struct
{
  std::vector<pair> *data;
  std::vector<double> *result;
} worker_args;

void *worker_thread (void *args);
std::vector<double> correlation_coefficients (std::vector<Vector> datasets, unsigned thread_count);
double pearson (Vector vec1, Vector vec2);
};

#endif
