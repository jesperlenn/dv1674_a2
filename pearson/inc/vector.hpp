/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#if !defined(VECTOR_HPP)
#define VECTOR_HPP

class Vector
{
private:
  double cached_mean;
  double cached_magnitude;
  unsigned size;
  double *data;

public:
  Vector ();
  Vector (unsigned size);
  Vector (unsigned size, double cached_mean, double cached_mangitude);
  Vector (unsigned size, double *data, double cached_mean, double cached_mangitude);
  Vector (const Vector &other);
  ~Vector ();

  double magnitude ();
  double mean ();
  double normalize () const;
  double dot (const Vector &rhs) const;

  unsigned get_size () const;
  double *get_data ();

  Vector operator/ (const double &div);
  Vector operator- (const double &sub);
  double operator[] (unsigned i) const;
  double &operator[] (unsigned i);
};

#endif
