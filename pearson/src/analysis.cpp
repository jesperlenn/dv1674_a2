/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "../inc/analysis.hpp"
#include <algorithm>
#include <iostream>
#include <pthread.h>
#include <vector>

namespace Analysis
{

std::vector<double>
correlation_coefficients (std::vector<Vector> &datasets, unsigned thread_count)
{
  pthread_t threads[thread_count];
  worker_args *args;
  unsigned v_size = datasets.size ();
  unsigned size = v_size * (v_size - 1) / 2;
  unsigned per_size = size / thread_count;
  pair *work_pairs[thread_count];
  std::vector<double> result;

  result.reserve (size);

  for (int i = 0; i < thread_count; i++)
    {
      work_pairs[i] = new pair[per_size];
    }

  int counter = 0;
  int t_counter = 0;

  for (int sample1{ 0 }; sample1 < v_size - 1; sample1++)
    {
      for (int sample2{ sample1 + 1 }; sample2 < v_size; sample2++)
        {
          int index = counter + t_counter * per_size;
          result.push_back (0);
          work_pairs[t_counter][counter] = { index, &datasets[sample1], &datasets[sample2] };

          counter++;

          if (counter >= per_size)
            {
              t_counter++;
              counter = 0;
            }
        }
    }

  for (int i = 0; i < thread_count; i++)
    {
      args = new worker_args{ per_size, 0, work_pairs[i], result, i };
      if (pthread_create (&threads[i], nullptr, worker_thread, (void *)args) == -1)
        {
          std::cerr << "Could not create threads\n";
          return std::vector<double> ();
        }
    }

  for (int i = 0; i < thread_count; i++)
    {
      pthread_join (threads[i], nullptr);
    }

  return result;
}

void *
worker_thread (void *_args)
{
  worker_args *args = (worker_args *)_args;
  pair *data = args->data;
  pair work_pair;
  double result;

  while (args->size > args->done)
    {
      work_pair = data[args->done];
      args->done++;
      result = pearson (work_pair.sample1, work_pair.sample2);
      args->result[work_pair.index] = result;
    }

  return nullptr;
}

double
pearson (Vector *vec1, Vector *vec2)
{
  double x_mean{ vec1->mean () };
  double y_mean{ vec2->mean () };

  Vector x_mm{ *vec1 - x_mean };
  Vector y_mm{ *vec2 - y_mean };

  double x_mag{ x_mm.magnitude () };
  double y_mag{ y_mm.magnitude () };

  Vector x_mm_over_x_mag{ x_mm / x_mag };
  Vector y_mm_over_y_mag{ y_mm / y_mag };

  double r{ x_mm_over_x_mag.dot (y_mm_over_y_mag) };

  return std::max (std::min (r, 1.0), -1.0);
}
}; // namespace Analysis
