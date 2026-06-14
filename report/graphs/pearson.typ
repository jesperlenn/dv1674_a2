#import "@preview/cetz:0.3.4"
#import "@preview/cetz-plot:0.1.1"

#import "../data/pearson.typ": seq_speedup, multi_speedup, multi_speedup_opt, multi_memory


#let speedup_graph = {
  align(
    center,
    cetz.canvas({
      import cetz.draw: *
      import cetz-plot: *
      import chart: *
      columnchart(
        size: (12, 5),
        label-key: 0,
        value-key: (1, 2, 3, 4, 5),
        labels: (
          [Flags],
          [Cache],
          [Loops],
          [Localisation],
          [IO]
        ),
        mode: "clustered",
        seq_speedup
      )
    })
  )
}

#let speedup_graph_multi = {
  align(
    center,
    cetz.canvas({
      import cetz.draw: *
      import cetz-plot: *
      import chart: *
      columnchart(
        size: (12, 5),
        label-key: 0,
        value-key: (1, 2, 3, 4, 5, 6),
        labels: (
          [1 Thread],
          [2 Thread],
          [4 Thread],
          [8 Thread],
          [16 Thread],
          [32 Thread]
        ),
        mode: "clustered",
        multi_speedup
      )
    })
  )
}

#let speedup_graph_multi_opt = {
  align(
    center,
    cetz.canvas({
      import cetz.draw: *
      import cetz-plot: *
      import chart: *
      columnchart(
        size: (12, 5),
        label-key: 0,
        value-key: (1, 2, 3, 4, 5, 6),
        
        labels: (
          [1 Thread],
          [2 Thread],
          [4 Thread],
          [8 Thread],
          [16 Thread],
          [32 Thread]
        ),
        mode: "clustered",
        multi_speedup_opt
      )
    })
  )
}

#let mem_graph_multi = {
  align(
    center,
    cetz.canvas({
      import cetz.draw: *
      import cetz-plot: *
      import chart: *
      columnchart(
        size: (12, 5),
        label-key: 0,
        value-key: (1, 2, 3, 4, 5),
        labels: (
          [2 Thread],
          [4 Thread],
          [8 Thread],
          [16 Thread],
          [32 Thread]
        ),
        mode: "clustered",
        multi_memory
      )
    })
  )
}
