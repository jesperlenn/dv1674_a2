#import "../import/graphs.typ": graph_all, graph_average_difference, graph_average_diff_between

= Pearson

A simple bash script was written, `tests.sh`, with the purpose of making the testing and verification simpler. It has two modes: verify the output of the binary to previously established results and run the performance tests, which was used to extract the data. It ran all the tests on all the provided data files containing the various sizes of vectors, and later all threads. The parallel version of the binary is verified by the provided verification script, named `verify.sh`, making the verification part of `tests.sh` redundant and removed, only leaving the different performance tests.

== Sequential

The initial step taken was to enable compiler optimizations with the flags `-O2` and `-O3` where the one with best time was kept, `-O3` proved to be 527ms quicker than `-O2` and brought the total time down with 71.8% from the original, shown in @table-1-step. All the other stages are using the `-O3` flag when compiling.

#figure(
  caption: [Changes between the Base and the O3 step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-16,170], [4,320],
    [Cache Miss (%)], [7.41], [7.89],
    [CPU (%)], [0.00], [100.00],
    [Memory (MB)], [0.00], [22.12], 
    [Instructions], [-197542221927], [31984950024],
  )
)<table-1-step>

Next was the implementation of a cache, keeping all the results from the `mean` and `magnitude` methods in the `Vector` class. This was achieved by creating two arrays `mean_cache` and `magnitude_cache` which were initialized with the maximum value a double can take. It would check the cache, if the value equals the maximum a value for mean and magnitude would be calculated and then stored at the provided index, otherwise the value would be collected and used. This subtle change pulled the time down with another 32.67% from the previous step, @table-2-step, and 74.4% from the original.

#figure(
  caption: [Changes between O3 and the cache step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-1,833], [2,487],
    [Cache Miss (%)], [3.52], [11.41],
    [CPU (%)], [-0.10], [99.90],
    [Memory (MB)], [0.02], [22.14], 
    [Instructions], [-8746790499], [23238159525],
  )
)<table-2-step>

The third step took inspiration from locality, moving the calculations into the vector. `VTune` showed massive allocation amounts, for size 1024 the total reached 30.2 GB, where the biggest corporate is the constant copying and construction of new vectors when performing all the calculations. This step took the cache and _moved_ it into the vector, or with other words replaced it with the vector itself. By realizing the original vector wasn't needed, all the calculations were changed to be preformed directly on the original. This replaced the original values by the calculated ones storing them in the vector, saving them for the `dot` method. This step lowered the allocation amount down to 103.9 MB for 1024, meaning the requests for more memory to the OS fell giving a positive difference of 40.31% from the caching step, @table-3-step, and 88.64% difference from the original.

#figure(
  caption: [Changes between cache and the locality step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-1,478], [1,008],
    [Cache Miss (%)], [-7.80], [3.61],
    [CPU (%)], [-0.10], [99.80],
    [Memory (MB)], [-0.02], [22.12], 
    [Instructions], [-17290556276], [5947603249],
  )
)<table-3-step>

We continued to loop unfolding, allowing the loops in the vector to do four calculations per iteration and eliminating dependencies by doing said calculations to temporary variables and then calculating the final result from them minimizing the pipeline stalls. This simple change lowered the time by 17.62% from the previous step and 90.2% from the original, leaving it at 704ms for size 1024, shown in @table-4-step.

#figure(
  caption: [Changes between locality and the loop unfolding step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-304], [704],
    [Cache Miss (%)], [0.00], [3.61],
    [CPU (%)], [0.00], [99.80],
    [Memory (MB)], [0.00], [22.12], 
    [Instructions], [-806078158], [5141525091],
  )
)<table-4-step>

The fifth step focused on IO the functions taking the most time now were `dot`, `read`, and `write`. `write` is heavily IO bound due to reading and writing file content to the disk, `write` was optimized by removing `std::endl` from the stream and replacing it with `\n` this allowed the stream to continue without clearing the buffer every iteration through the results. This gave us another 45.16% off the previous, @table-5-step, and a total of 94.64% from the original, giving us 404ms for 1024.

#figure(
  caption: [Changes between loop unfolding and the IO step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-301], [404],
    [Cache Miss (%)], [1.22], [4.83],
    [CPU (%)], [-0.10], [99.70],
    [Memory (MB)], [0.00], [22.12], 
    [Instructions], [-73611048], [5067914043],
  )
)<table-5-step>

The final step taken is vector alignment, by using `alignas(double)`. Aligning the vector class to the primary value in the data array, gave us a slight performance increase. This lowered the L1 cache misses, by 0.21% and LL cache misses by
//TODO: get cache LL difference
and gave us a speed increase of 6.05% from the previous step, @table-6-step, and 94.93% from the original. Leaving us at the final time of 376ms for size 1024 compared to 20,490ms for the original with the same size.

#figure(
  caption: [Changes between IO and the alignment step for size 1024.],
  table(
    columns: (1.3fr, 1fr, 1fr),
    rows: 6,
    [], [Difference], [Actual],
    [Time (ms)], [-0.0278], [376],
    [Cache Miss (%)], [-0.06], [4.77],
    [CPU (%)], [0.00], [99.70],
    [Memory (MB)], [0.00], [22.12], 
    [Instructions], [-7696245], [5060217798],
  )
)<table-6-step>

#place(
  center + bottom,
  float: true,
  scope: "parent",
  clearance: 2em,
)[
  #figure(
    caption: [Illustration of all the different sizes through all the take steps.],
    kind: "graph",
    supplement: [Graph],
    graph_all
  )<graph-time-all>

]

All the changes are illustrated in @graph-time-all showing all the time differences through out the steps on different vector sizes. Due to the size 1024 over shadowing the other values, @graph-difference might be better to look at. The second graph shows the removed time in percent compared to the original while @graph-diff-between shows the removed time in percent from the previous step, or with other words, the impact.

#figure(
  placement: top,
  caption: [Illustration of the total removed time in percent from the base.],
  kind: "graph",
  supplement: [Graph],
  graph_average_difference
)<graph-difference>

#figure(
  placement: bottom,
  caption: [Illustration of the total removed time in percent from the previous step.],
  kind: "graph",
  supplement: [Graph],
  graph_average_diff_between
)<graph-diff-between>

Several  steps to optimize the program were taken, such as caching, loop unfolding, and simple optimisation flags. We will only show the ones actually providing a positive time difference, meaning manual vectorisation using libraries such as `immintrin.h` was discarded due to worsening the time with ~50ms.


