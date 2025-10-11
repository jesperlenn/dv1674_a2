/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "vector.hpp"
#include <cmath>
#include <iostream>
#include <vector>

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
  for (auto i{ 0 }; i < size; i++)
    {
      data[i] = other.data[i];
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
  double sum{ 0 };

  for (auto i{ 0 }; i < size; i++)
    {
      sum += data[i];
    }

  return sum / static_cast<double> (size);
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
  for (auto i{ 0 }; i < size; i++)
    {
      data[i] -= sub;
    }
}

void
Vector::div (const double &div)
{
  for (auto i{ 0 }; i < size; i++)
    {
      data[i] /= div;
    }
}

void
Vector::prepeare ()
{
  double mean = this->mean ();
  this->sub (mean);
  double mag = this->magnitude ();
  this->div (mag);
}

double
Vector::dot (const Vector &rhs) const
{
  double result{ 0 };

  for (auto i{ 0 }; i < size; i++)
    {
      result += data[i] * rhs[i];
    }

  return result;
}
