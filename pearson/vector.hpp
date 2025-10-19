/*
Author: David Holmqvist <daae19@student.bth.se>
*/

#if !defined(VECTOR_HPP)
#define VECTOR_HPP

class alignas (double) Vector
{
private:
  unsigned size;
  double *data;

public:
  Vector ();
  Vector (unsigned size);
  Vector (unsigned size, double *data);
  Vector (const Vector &other);
  ~Vector ();

  // Get magnitude
  double magnitude () const;
  // Get mean
  double mean () const;
  // calculate dot
  double dot (const Vector &rhs) const;

  unsigned get_size () const;
  double *get_data ();

  // Perform subtraction on all elements
  void sub (const double &sub);
  // Perform division on all elements
  void div (const double &div);
  // prepeare vector for further calculations
  void prepeare ();

  double operator[] (unsigned i) const;
  double &operator[] (unsigned i);
};

#endif
