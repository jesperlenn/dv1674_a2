/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#include "../inc/vector.hpp"
#include <cfloat>
#include <cmath>

Vector::Vector () : cached_magnitude (DBL_MAX), cached_mean (DBL_MAX), size{ 0 }, data{ nullptr } {}

Vector::~Vector ()
{
  if (data)
    {
      delete[] data;
    }

  size = 0;
}
Vector::Vector (unsigned size)
    : size{ size }, data{ new double[size] }, cached_mean (DBL_MAX), cached_magnitude (DBL_MAX)
{
}

Vector::Vector (unsigned size, double cached_mean, double cached_mangitude)
    : size{ size }, data{ new double[size] }, cached_mean (cached_mean),
      cached_magnitude (cached_mangitude)
{
}

Vector::Vector (unsigned size, double *data, double cached_mean, double cached_mangitude)
    : size{ size }, data{ data }, cached_mean (cached_mean), cached_magnitude (cached_mangitude)
{
}

Vector::Vector (const Vector &other)
    : Vector{ other.size, other.cached_mean, other.cached_magnitude }
{
  for (int i{ 0 }; i < size; i++)
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
Vector::mean ()
{
  if (this->cached_mean == DBL_MAX)
    {
      double sum{ 0 };

      for (int i{ 0 }; i < size; i++)
        {
          sum += data[i];
        }

      this->cached_mean = sum / static_cast<double> (size);
    }

  return this->cached_mean;
}

double
Vector::magnitude ()
{
  if (this->cached_magnitude == DBL_MAX)
    {
      double dot_prod{ dot (*this) };
      this->cached_magnitude = std::sqrt (dot_prod);
    }

  return this->cached_magnitude;
}

Vector
Vector::operator/ (const double &div)
{
  Vector result{ *this };

  for (int i{ 0 }; i < size; i++)
    {
      result[i] /= div;
    }

  return result;
}

Vector
Vector::operator- (const double &sub)
{
  Vector result{ *this };

  for (int i{ 0 }; i < size; i++)
    {
      result[i] -= sub;
    }

  return result;
}

double
Vector::dot (const Vector &rhs) const
{
  double result{ 0 };

  for (int i{ 0 }; i < size; i++)
    {
      result += data[i] * rhs[i];
    }

  return result;
}
