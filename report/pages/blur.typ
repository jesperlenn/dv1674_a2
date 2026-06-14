= Blur

The objective of this work was to optimize and parallelize the Gaussian blur filter while preserving correctness. The original implementation applies a separable Gaussian blur using two passes: a horizontal pass followed by a vertical pass. Although the algorithm is already more efficient than a full two-dimensional convolution, several implementation-level inefficiencies remained.

The optimization process was performed incrementally. After each optimization step, performance measurements were collected and compared against the original implementation. Once the sequential optimizations had been completed, the filter was parallelized using POSIX threads (pthreads) to utilize multiple CPU cores.

Correctness was verified after each optimization and after parallelization using the provided verification script.

== Sequential Optimizations

=== Precomputation of Gaussian Weights

In the original implementation the Gaussian weights were recomputed for every pixel in both the horizontal and vertical passes. Since the weights depend only on the blur radius, recalculating them for each pixel introduces unnecessary overhead.

To eliminate this redundancy the weight array was computed once before the blur operation and reused throughout both passes.

This optimization significantly reduced the number of expensive exponential function evaluations and produced a speedup of approximately $1.4$ - $1.6x$ compared to the baseline implementation.

#figure(
  table(
    columns: 2,
    align: center,

    [Image], [Speedup],

    [im1], [1.45×],
    [im2], [1.39×],
    [im3], [1.49×],
    [im4], [1.57×],

    [*Average*], [*1.48×*],
  ),
  caption: [Speedup achieved by precomputing Gaussian weights relative to the original implementation.]
)

=== Direct Memory Access

The original implementation accessed image data through matrix accessor functions such as `r(x,y)`, `g(x,y)`, and `b(x,y)`. These function calls were executed repeatedly inside the innermost loops of the blur algorithm.

To reduce this overhead, direct pointers to the red, green, and blue channel arrays were obtained using `get_R()`, `get_G()`, and `get_B()`. Pixel values could then be accessed directly through array indexing.

Removing the accessor function calls reduced instruction overhead and allowed the compiler to generate more efficient code. This optimization increased the overall speedup to approximately $2.4$ - $2.7x$ relative to the original implementation.

#figure(
  table(
    columns: 2,
    align: center,

    [Image], [Speedup],

    [im1], [2.56×],
    [im2], [2.39×],
    [im3], [2.46×],
    [im4], [2.66×],

    [*Average*], [*2.52×*],
  ),
  caption: [Speedup achieved by direct memory access relative to the original implementation.]
)

=== Cache-Friendly Linear Traversal

The original implementation traversed the image using nested x--y loops. The optimized implementation instead processes pixels using a single linear index corresponding to the image's memory layout.

Since image data is stored contiguously in memory, linear traversal improves spatial locality and enables more effective hardware prefetching. As a result, cache utilization improves and memory accesses become more efficient.

The performance gain from this optimization was smaller than the previous optimization. This is likely because neighboring pixels were already accessed during the blur operation, resulting in relatively good cache behavior before the optimization was applied.
#figure(
  table(
    columns: 2,
    align: center,

    [Image], [Speedup],

    [im1], [2.52×],
    [im2], [2.50×],
    [im3], [2.37×],
    [im4], [2.69×],

    [*Average*], [*2.52×*],
  ),
  caption: [Speedup achieved by cache-friendly linear traversal relative to the original implementation.]
)

=== Final

The largest sequential improvement was obtained from direct memory access. The linear traversal optimization provided only a modest additional gain because neighboring pixels were already stored close together in memory, resulting in relatively good cache utilization before the optimization.

#figure(
  image("sequential_speedup.png", width: 80%),
  caption: [Speedup obtained after each sequential optimization step.]
)

== Parallelization Strategy

=== Work Partitioning

After completing the sequential optimizations, the blur filter was parallelized using POSIX threads. The image was partitioned by rows, and each thread was assigned a contiguous range of rows to process.

The number of rows assigned to each thread was calculated as:

$
  "rows_per_thread" = "image_height" / "thread_count"
$

This partitioning strategy provides good load balancing because each pixel requires approximately the same amount of computation.

=== Data Organization

The image is stored using three separate arrays corresponding to the red, green, and blue color channels. Additional scratch arrays are used to store intermediate results generated during the horizontal blur pass.

All threads share access to these arrays. Since each thread writes only to its assigned rows, no write conflicts occur during execution.

=== Synchronization

The blur operation consists of two dependent phases:

+ Horizontal blur
+ Vertical blur

The vertical pass requires all intermediate values from the horizontal pass to be available before execution can begin. To ensure correctness, a pthread barrier was introduced between the two phases.

After finishing the horizontal pass, all threads wait at the barrier. Once every thread reaches the barrier, execution continues and the vertical pass begins.

This synchronization mechanism guarantees that no thread reads incomplete data from the scratch buffers.

== Performance and Scalability

The multithreaded implementation achieved near-linear speedup up to approximately eight threads. Figure 2 shows the relationship between speedup and thread count for the tested images.

#figure(
  image("thread_scaling.png", width: 80%),
  caption: [Speedup as a function of the number of threads.]
)

The results show that speedup increases steadily from one to eight threads, reaching approximately 6--7x depending on the image. Beyond eight threads, performance improvements become negligible and, in some cases, slightly decrease.

Several factors contribute to this behavior:

+ The available CPU cores are fully utilized at approximately eight threads.
+ Memory bandwidth becomes a limiting factor because each thread continuously reads and writes large image buffers.
+ Synchronization overhead increases as the number of threads grows.
+ According to Amdahl's Law, the serial portion of the program limits maximum achievable speedup.

As a result, additional threads beyond eight provide little additional performance.