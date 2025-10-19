#import "../import/graphs.typ": graph_128, graph_256, graph_512, graph_1024

= Pearson

A simple bash script was written, `tests.sh`, with the purpose of making the testing and verification simpler. It has two modes: verify the output of the binary to previously established results and run the performance tests, which was used to extract the data. It ran all the tests on all the provided data files containing the various sizes of vectors, and later all threads. The parallel version of the binary is verified by the provided verification script, named `verify.sh`, making the verification part of `tests.sh` redundant and removed, only leaving the different performance tests.

== Steps

Compiler optimization

Cache implementation

Locality

Loop unfolding

IO optimization

Vector alignment

== Results

#figure(
  placement: bottom,
  caption: [Illustration of time per stage for size 128.],
  kind: "graph",
  supplement: [Graph],
  graph_128
)

#figure(
  placement: bottom,
  caption: [Illustration of time per stage for size 256.],
  kind: "graph",
  supplement: [Graph],
  graph_256
)

#figure(
  placement: bottom,
  caption: [Illustration of time per stage for size 512.],
  kind: "graph",
  supplement: [Graph],
  graph_512
)

#figure(
  placement: bottom,
  caption: [Illustration of time per stage for size 1024.],
  kind: "graph",
  supplement: [Graph],
  graph_1024
)
