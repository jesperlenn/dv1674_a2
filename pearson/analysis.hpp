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
  unsigned index;
  Vector *vec_1;
  Vector *vec_2;
} Pair;

typedef struct
{
  unsigned prep_start;
  unsigned prep_end;
  unsigned pair_start;
  unsigned pair_end;

  std::vector<Vector> *preps;
  std::vector<double> *result;
  std::vector<Pair> *pairs;
} Argument;

std::vector<double> correlation_coefficients (std::vector<Vector> datasets,
                                              unsigned threads);
void *worker_thread (void *args);
};

#endif
