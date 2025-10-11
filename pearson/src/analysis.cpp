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

pthread_mutex_t pair_mutex;

std::vector<double>
correlation_coefficients (std::vector<Vector> &datasets, unsigned thread_count)
{
  std::vector<double> result{};
  pthread_t threads[thread_count];
  worker_args args;
  unsigned v_size = datasets.size ();
  pair work_pairs[v_size + 1];
  unsigned size = v_size * (v_size - 1) / 2;

  pthread_mutex_init (&pair_mutex, nullptr);

  result.reserve (size);

  for (int i = 0; i < size; i++)
    result.push_back (0);

  args = worker_args{ v_size + 1, 0, work_pairs, &result };
  int counter = 0;

  for (int sample1{ 0 }; sample1 < v_size - 1; sample1++)
    {
      for (int sample2{ sample1 + 1 }; sample2 < v_size; sample2++)
        {
          work_pairs[counter] = pair{ counter, &datasets[sample1], &datasets[sample2] };
          counter++;
        }
    }

  work_pairs[counter] = pair{ -1, nullptr, nullptr };

  for (int i = 0; i < thread_count; i++)
    {
      if (pthread_create (&threads[i], nullptr, worker_thread, (void *)&args) == -1)
        {
          std::cerr << "Could not create threads\n";
          return result;
        }
    }

  for (int i = 0; i < thread_count; i++)
    {
      pthread_join (threads[i], nullptr);
    }

  pthread_mutex_destroy (&pair_mutex);
  return result;
}

void *
worker_thread (void *_args)
{
  worker_args *args = (worker_args *)_args;
  pair *data = args->data;
  std::vector<double> *result = args->result;
  pair work_pair;

  while (true)
    {
      pthread_mutex_lock (&pair_mutex);
      work_pair = data[args->done];
      if (work_pair.index == -1)
        {
          pthread_mutex_unlock (&pair_mutex);
          break;
        }
      args->done++;
      pthread_mutex_unlock (&pair_mutex);

      (*result)[work_pair.index] = pearson (*work_pair.sample1, *work_pair.sample2);
    }

  return nullptr;
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
