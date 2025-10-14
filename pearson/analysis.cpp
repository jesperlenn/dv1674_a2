/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "analysis.hpp"
#include "vector.hpp"
#include <algorithm>
#include <cfloat>
#include <cmath>
#include <iostream>
#include <iterator>
#include <list>
#include <pthread.h>
#include <vector>

namespace Analysis
{
std::vector<double>
correlation_coefficients (std::vector<Vector> datasets, unsigned threads)
{
  Vector temp;
  unsigned size, segment_size, result_size;
  unsigned i, j, index, counter, t_counter;
  pthread_t *workers;
  Pair *segment;
  double *results;

  size = datasets.size ();
  result_size = size * (size - 1) / 2;
  segment_size = result_size / threads;
  results = new double[result_size];
  workers = new pthread_t[threads];
  segment = new Pair[segment_size];
  Argument *arg;

  for (i = 0; i < size; i++)
    {
      datasets[i].prepeare ();
    }

  index = 0;
  t_counter = 0;
  counter = 0;

  for (i = 0; i < size - 1; i++)
    {
      for (j = i + 1; j < size; j++)
        {
          segment[counter] = Pair{ index, &datasets[i], &datasets[j] };

          counter++;
          index++;

          if (counter >= segment_size)
            {
              arg = new Argument{ segment_size, results, segment };
              if (pthread_create (&workers[t_counter], nullptr, worker_thread,
                                  (void *)arg)
                  == -1)
                {
                  std::cerr << "Could not create thread\n";
                  return std::vector<double> ();
                }
              segment = new Pair[segment_size];
              counter = 0;
              t_counter++;
            }
        }
    }

  for (i = 0; i < threads; i++)
    {
      pthread_join (workers[i], nullptr);
    }

  return std::vector<double> (results, results + result_size);
}

void *
worker_thread (void *args)
{
  Argument arg = *(Argument *)args;
  Vector *vec_1, *vec_2;
  double r, *results;
  unsigned index;

  results = arg.result;

  for (int i = 0; i < arg.segment_size; i++)
    {
      vec_1 = arg.pairs[i].vec_1;
      vec_2 = arg.pairs[i].vec_2;
      index = arg.pairs[i].index;

      r = vec_1->dot (*vec_2);
      results[index] = std::max (std::min (r, 1.0), -1.0);
    }

  delete[] arg.pairs;
  return nullptr;
}
}; // namespace Analysis
