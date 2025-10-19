= Method

Each program was tested to determine a baseline using several profiling tools like:

- Valgrind: Base tool
  - Callgrind: Used for cache simulation and viewing instruction trees. 
  - Massif: Used for memory utilization and analysis.
  - Memcheck: Used to check for leaks.
- Perf stat: used to gather system information during runs. Used with `-d` for cache information and `--repeat 10` to run the test ten times and give an average.
- VTune: sanity checks.

After a baseline was determined different optimisation steps were taken, after which performance tests were run. The improvement would be removed if it worsened the performance.

Parallelism will be implemented into the program when the sequential version is optimal.
