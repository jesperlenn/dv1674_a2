/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "vector.hpp"
#include <cmath>

Vector::Vector () : size{ 0 }, data{ nullptr } {}

Vector::~Vector ()
{
  if (data)
    {
      delete[] data;
    }

  size = 0;
}

Vector::Vector (unsigned size) : size{ size }, data{ new double[size] } {}

Vector::Vector (unsigned size, double *data) : size{ size }, data{ data } {}

Vector::Vector (const Vector &other) : Vector{ other.size }
{
  for (unsigned i = 0; i < size; i += 4)
    {
      data[i] = other.data[i];
      data[i + 1] = other.data[i + 1];
      data[i + 2] = other.data[i + 2];
      data[i + 3] = other.data[i + 3];
    }
}

unsigned
Vector::get_size () const
{
  return size;
}

double *
Vector::get_data ()
{
  return data;
}

double
Vector::operator[] (unsigned i) const
{
  return data[i];
}

double &
Vector::operator[] (unsigned i)
{
  return data[i];
}

double
Vector::mean () const
{
  double sum1 = 0;
  double sum2 = 0;
  double sum3 = 0;
  double sum4 = 0;

  for (unsigned i = 0; i < size; i += 4)
    {
      sum1 += data[i];
      sum2 += data[i + 1];
      sum3 += data[i + 2];
      sum4 += data[i + 3];
    }

  return (sum1 + sum2 + sum3 + sum4) / static_cast<double> (size);
}

double
Vector::magnitude () const
{
  auto dot_prod{ dot (*this) };
  return std::sqrt (dot_prod);
}

void
Vector::sub (const double &sub)
{
  for (unsigned i{ 0 }; i < size; i += 4)
    {
      data[i] -= sub;
      data[i + 1] -= sub;
      data[i + 2] -= sub;
      data[i + 3] -= sub;
    }
}

void
Vector::div (const double &div)
{
  for (unsigned i = 0; i < size; i += 4)
    {
      data[i] /= div;
      data[i + 1] /= div;
      data[i + 2] /= div;
      data[i + 3] /= div;
    }
}

void
Vector::prepeare ()
{
  // Doing all the needed calculations internally saving them on itself
  double mean = this->mean ();
  this->sub (mean);
  double mag = this->magnitude ();
  this->div (mag);
}

double
Vector::dot (const Vector &rhs) const
{
  double res1 = 0;
  double res2 = 0;
  double res3 = 0;
  double res4 = 0;

  for (unsigned i = 0; i < size; i += 4)
    {
      res1 += data[i] * rhs[i];
      res2 += data[i + 1] * rhs[i + 1];
      res3 += data[i + 2] * rhs[i + 2];
      res4 += data[i + 3] * rhs[i + 3];
    }

  return (res1 + res2 + res3 + res4);
}
