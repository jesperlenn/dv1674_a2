/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "../inc/analysis.hpp"
#include <algorithm>
#include <pthread.h>
#include <vector>

#ifdef MULTI

#include <iostream>

#endif // MULTI

namespace Analysis
{

pthread_mutex_t pair_mutex;

#ifdef MULTI

std::vector<double>
correlation_coefficients (std::vector<Vector> datasets, unsigned thread_count)
{
  std::vector<double> result{};
  std::vector<pair> work_pairs;
  pthread_t threads[thread_count];
  worker_args args;

  pthread_mutex_init (&pair_mutex, nullptr);
  unsigned size = (datasets.size ()) * (datasets.size () - 1) / 2;

  result.reserve (size);

  for (int i = 0; i < size; i++)
    result.push_back (0);

  args = worker_args{ &work_pairs, &result };
  int counter = 0;

  work_pairs.push_back (pair{ -1, nullptr, nullptr });

  for (int sample1{ 0 }; sample1 < datasets.size () - 1; sample1++)
    {
      for (int sample2{ sample1 + 1 }; sample2 < datasets.size (); sample2++)
        {
          work_pairs.push_back (pair{ counter, &datasets[sample1], &datasets[sample2] });
          counter++;
        }
    }

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
worker_thread (void *args)
{
  std::vector<pair> *data = ((worker_args *)args)->data;
  std::vector<double> *result = ((worker_args *)args)->result;
  pair work_pair;

  while (true)
    {
      pthread_mutex_lock (&pair_mutex);
      work_pair = (*data)[data->size () - 1];
      if (work_pair.index == -1)
        {
          pthread_mutex_unlock (&pair_mutex);
          break;
        }
      data->pop_back ();
      pthread_mutex_unlock (&pair_mutex);

      (*result)[work_pair.index] = pearson (*work_pair.sample1, *work_pair.sample2);
    }

  return nullptr;
}

#endif // MULTI

#ifndef MULTI

std::vector<double>
correlation_coefficients (std::vector<Vector> datasets)
{
  std::vector<double> result{};

  for (auto sample1{ 0 }; sample1 < datasets.size () - 1; sample1++)
    {
      for (auto sample2{ sample1 + 1 }; sample2 < datasets.size (); sample2++)
        {
          auto corr{ pearson (datasets[sample1], datasets[sample2]) };
          result.push_back (corr);
        }
    }

  return result;
}

#endif // !MULTI

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
