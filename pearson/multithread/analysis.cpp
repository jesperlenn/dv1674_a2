/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "analysis.hpp"
#include "vector.hpp"
#include <vector>

#ifdef PAR
#include <pthread.h>
#endif // PAR

namespace Analysis
{

#ifdef PAR
// Barrier used to sync all the threads and wait for the
// pairs to be created.
pthread_barrier_t prep_barrier;

std::vector<double>
correlation_coefficients (std::vector<Vector> datasets, unsigned threads)
{
  Vector temp;
  unsigned size, segment_size, result_size, prep_size;
  unsigned i, j, index;
  std::vector<pthread_t> workers;

  std::vector<Pair> pairs;
  std::vector<double> results;

  // Calculate all the sizes
  size = datasets.size ();
  prep_size = size / threads;
  result_size = size * (size - 1) / 2;
  segment_size = result_size / threads;

  // Reserve the needed space
  pairs.reserve (result_size);
  results.reserve (result_size);

  Argument *arg;

  // Init the barrier
  pthread_barrier_init (&prep_barrier, nullptr, threads + 1);

  // loop through the thread count creating threads with the needed
  // sizes and starting points.
  for (i = 0; i < threads; i++)
    {
      arg = new Argument;
      arg->prep_start = i * prep_size;
      arg->prep_end = arg->prep_start + prep_size;
      arg->pair_start = i * segment_size;
      arg->pair_end = arg->pair_start + segment_size;

      arg->pairs = &pairs;
      arg->preps = &datasets;
      arg->result = &results;

      pthread_t thread;
      // create thread
      pthread_create (&thread, nullptr, worker_thread, (void *)arg);
      // place it in the thread vector
      workers.push_back (thread);
    }

  index = 0;

  // create the pairs
  for (i = 0; i < size - 1; i++)
    {
      for (j = i + 1; j < size; j++)
        {
          // add pair to pairs with the index it'll have in results
          pairs.push_back (Pair{ index, &datasets[i], &datasets[j] });
          results.push_back (0);
          index++;
        }
    }

  // wait till other threads are ready
  pthread_barrier_wait (&prep_barrier);

  // join the threads
  for (i = 0; i < threads; i++)
    {
      pthread_join (workers[i], nullptr);
    }

  return results;
}

void *
worker_thread (void *args)
{
  Argument *arg = (Argument *)args;
  Vector *vec_1, *vec_2;
  unsigned i, index;
  double r;

  // loop through all the vectors in the segment
  // and prepeare them
  for (i = arg->prep_start; i < arg->prep_end; i++)
    {
      (*arg->preps)[i].prepeare ();
    }

  // wait till main thread is done with the pairs.
  pthread_barrier_wait (&prep_barrier);

  // preform the final calculations on the vectors and
  // place them in a preallocated vector. (safe from race conditions)
  for (unsigned i = arg->pair_start; i < arg->pair_end; i++)
    {
      vec_1 = (*arg->pairs)[i].vec_1;
      vec_2 = (*arg->pairs)[i].vec_2;
      index = (*arg->pairs)[i].index;

      r = vec_1->dot (*vec_2);
      (*arg->result)[index] = std::max (std::min (r, 1.0), -1.0);
    }

  delete arg;
  return nullptr;
}
#endif // PAR
#ifndef PAR
std::vector<double>
correlation_coefficients (std::vector<Vector> datasets)
{
  std::vector<double> result{};
  double r;
  Vector temp;
  unsigned size;
  Vector vec1, vec2;

  // prepeare the vectors
  size = datasets.size ();
  for (unsigned i = 0; i < size; i++)
    {
      datasets[i].prepeare ();
    }

  // preform final calculations
  for (unsigned sample_1 = 0; sample_1 < size - 1; sample_1++)
    {
      for (unsigned sample_2 = sample_1 + 1; sample_2 < size; sample_2++)
        {
          r = datasets[sample_1].dot (datasets[sample_2]);
          result.push_back (std::max (std::min (r, 1.0), -1.0));
        }
    }

  return result;
}
#endif // !PAR
}; // namespace Analysis
