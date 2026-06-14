#import "../data/pearson.typ": seq_speedup, multi_speedup, multi_speedup_opt, seq_time
#import "../graphs/pearson.typ": speedup_graph, speedup_graph_multi, speedup_graph_multi_opt, mem_graph_multi

= Pearson

The optimization process followed a simple process: run tests, implement optimization, run tests and determin if they should be kept. Multithreading was implemented using `pthread` when the sequential version reached an optimal stage.

== Sequential

The initial step taken was to enable compiler optimizations with the flags `-O2` and `-O3` where the one with best time was kept, `-O3` proved to be 527ms quicker than `-O2` which gave the results in @table-1-step. All the other stages are using the `-O3` flag when compiling.

#figure(
  caption: [Speed ups after using compile time optimizations.],
  table(
    columns: (1fr, 1fr),
    [Sizes], [Speed Up],
    ..for (size, opt, cache, loop, locality, io) in seq_speedup {
      ([#size], [#opt])
    }
  )
)<table-1-step>

Next was the implementation of a cache, keeping all the results from the `mean` and `magnitude` methods in the `Vector` class. This was achieved by creating two arrays `mean_cache` and `magnitude_cache` which were initialized with the maximum value a double can take. It would check the cache, if the value equals the maximum a value for mean and magnitude would be calculated and then stored at the provided index, otherwise the value would be collected and used. This gave a speed up between 3.4 and 8.2 depending on the vector size, @table-2-step.

#figure(
  caption: [Speed up after implementing a cache.],
  table(
    columns: (1fr, 1fr),
    [Sizes], [Speed Up],
    ..for (size, opt, cache, loop, locality, io) in seq_speedup {
      ([#size], [#cache])
    }
  )
)<table-2-step>

We continued to loop unroling, allowing the loops in the vector to do four calculations per iteration and eliminating dependencies by doing said calculations to temporary variables and then calculating the final result from them minimizing the pipeline stalls. This simple change give the speed ups show in @table-4-step.

#figure(
  caption: [Speed up after implementing loop unroling.],
  table(
    columns: (1fr, 1fr),
    [Sizes], [Speed Up],
    ..for (size, opt, cache, loop, locality, io) in seq_speedup {
      ([#size], [#loop])
    }
  )
)<table-4-step>

The third step took inspiration from locality, moving the calculations into the vector. `VTune` showed massive allocation amounts, for size 1024 the total reached 30.2 GB, where the biggest corporate is the constant copying and construction of new vectors when performing all the calculations. This step took the cache and _moved_ it into the vector, or with other words replaced it with the vector itself. By realizing the original vector wasn't needed, all the calculations were changed to be preformed directly on the original. This replaced the original values by the calculated ones storing them in the vector, saving them for the `dot` method. This step lowered the allocation amount down to 103.9 MB for 1024, meaning the requests for more memory to the OS fell giving a speed up of 3.43 for 128 and 21 for 1024, @table-3-step.

#figure(
  caption: [Speed up after implementing the locality optimizations.],
  table(
    columns: (1fr, 1fr),
    [Sizes], [Speed Up],
    ..for (size, opt, cache, loop, locality, io) in seq_speedup {
      ([#size], [#locality])
    }
  )
)<table-3-step>

The fifth step focused on IO the functions taking the most time now were `dot`, `read`, and `write`. `write` is heavily IO bound due to reading and writing file content to the disk, `write` was optimized by removing `std::endl` from the stream and replacing it with `\n` this allowed the stream to continue without clearing the buffer every iteration through the results. This gave the final speed up of 9.98 for 128 and 57.048 for 1024, @table-5-step.

#figure(
  caption: [Changes between loop unfolding and the IO step for size 1024.],
  table(
    columns: (1fr, 1fr),
    [Sizes], [Speed Up],
    ..for (size, opt, cache, loop, locality, io) in seq_speedup {
      ([#size], [#io])
    }
  )
)<table-5-step>

All the changes are illustrated in @graph-speed-up showing all speed ups through out the steps on different vector sizes and @table-final-seq show all recorded times.

#place(
  center + bottom,
  scope: "parent",
  float: true,
  [
#figure(
  caption: [All run times in seconds.],
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    [Sizes], [Base], [Flags], [Cache], [Loop], [Locality], [IO],
    ..for (size, base, opt, cache, loop, locality, io) in seq_time {
      ([#size], [#base], [#opt], [#cache], [#loop], [#locality], [#io])
    }
  )
)<table-final-seq>
])

#place(
  center + top,
  scope: "parent",
  float: true,
  [
#figure(
  caption: [Illustration of all the different sizes through all the taken steps.],
  kind: "graph",
  supplement: [Graph],
  speedup_graph
)<graph-speed-up>
]
)

== Parallelism

There are some steps needed to achieve parallelism for the pearson program. Firstly a way for the user to specify the amount of wanted threads, secondly split up the work evenly, and lastly a safe way to get the results. To get the thread count a third argument for the binary was specified, thread count, which is used to separate the data evenly and create the wanted threads.

Separating the workload proved to be more of a hassle than expected, the `dot` method isn't run between all possible column pairs in the matrix, instead every column pairs with every column in front it. This can be visualized as _pair triangle_, meaning we can calculate the calculation count using: 
$
"pair count" = ("vector size" * ("vector size" - 1)) / 2
$
, due to the last vector not being multiplied to it self, one is removed from it. The result of the multiplication will always be a multiple of two, thanks to the vector size. We then calculate the pair segment size which will be used to separate them between the threads:
$
"segment size" = ("pair count") / ("thread count")
$
This is we needed to execute the `dot` method evenly across all the threads. But this excludes the `prepeare` method, leaving potential for parallelism. We continued to separate the dataset between the threads which proved to be simpler than the previous one, the only issue was the dependency between `dot` and `prepeare`. `dot` need `prepeare` to run on both the vectors in the calculation before executing. Giving us two choices: (1) running `prepeare` every time `dot` needed it, skipping the calculation if it was done, or (2) run `prepeare` on all the vectors before continuing. Due to all the needed mutex locks for the first option to mitigate all the race conditions, option two was chosen.

In conclusion, the program first separates the dataset between the threads, then it starts the threads which run the `prepeare` method on each vector. The main thread continues to add the vectors to pairs giving them their index for the result and then stops at a `pthread_barrier`, when all the other threads are done processing they'll reach the same barrier, which will let them proceed when all threads reach it. The threads continue to process the `dot` method and places the result in the result vector at the given index, they'll join the main thread when the processing is done.

The same tests were run at the same sizes for each thread count, 1 to 32, giving the results shown through @table-multi-base and @table-multi-optimized.

#place(
  top + center,
  scope: "parent",
  float: true,
    [
      #figure(
        caption: [Total speed up per thread count compared to base sequential version.],
        kind: "figure",
        supplement: [Figure],
        [
          #speedup_graph_multi
          #table(
            columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
            [Sizes], [1], [2], [4], [8], [16], [32],
            ..for (size, one, two, four, eight, sixteen, thirtytwo) in multi_speedup {
              ([#size], [#one], [#two], [#four], [#eight], [#sixteen], [#thirtytwo])
            }
          )
        ]
      )<table-multi-base>
    ]
  )

  #place(
    top + center,
    scope: "parent",
    float: true,
    [
      #figure(
        kind: "figure",
        supplement: [Figure],
        caption: [Total speed up per thread count compared to optimized sequential version subtracted by one to highlight the difference.],
        [
          #speedup_graph_multi_opt
          #table(
            columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
            [Sizes], [1], [2], [4], [8], [16], [32],
            ..for (size, one, two, four, eight, sixteen, thirtytwo) in multi_speedup_opt {
              ([#size], [#one], [#two], [#four], [#eight], [#sixteen], [#thirtytwo])
            }
          )
        ]
      )<table-multi-optimized>
    ]
  )

- Size 128 didn't showed any improvement through out the threads, hovering between 0.8 and 0.9 speed up. This isn't better than the sequential version, meaning a this size threads aren't worth it.

- Size 256 showed slight improvement, bearly reaching a speed up at two and four threads.

- Size 512 shows a slightly better situation than the other two, with a result of 1.129x speed up.

- Size 1024 gave the best improvement, with the greatest speed up of 1.399x with eight threads. This also giva the biggest speed up compared to the base version with a value of 79.8 times.

All the vector sizes show a negative impact when only running one thread, @table-multi-optimized, which is explained by the extra processing needed to prepare the data for multithreading.

== Performance and Scalability

The speed up grow with the thread count if the vector size is big enough, @table-multi-optimized. This allow the CPU utilization to grow with the data with greater speed  ups than shown here. The memory utilization grow with the vector size, @table-multi-mem, but not the thread count. This allow us to use as many threads as we want with minimal memory waste, only limited by the growing vector.

#place(
  top + center,
  scope: "parent",
  float: true,
  [
    #figure(
      kind: "figure",
      supplement: [Figure],
      caption: [Maximum memory consumption during run time per thread count.],
      [
        #mem_graph_multi
      ]
    )<table-multi-mem>
  ]
)

== What more?

Vectorisation using libraries such as `immintrin.h` could improve CPU utilization, performing several calculations simultaneously. This could give performance improvements, though the data sizes in this project seem to be too small to gain enough time to cover for the preparations. Moving the thread preparations to the `read` function could improve some overhead, the function itself could probably be improved with some other file reading or double conversion utility, though both `read` and `write` are heavily IO bound.

