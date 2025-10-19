#import "@preview/lilaq:0.5.0" as lq
#import "../data/pearson.typ": seq_data, par_data

#let time_128() = {
  let data = seq_data.at("data").at(0);
  let filtered = ()

  for d in data {
    filtered.push(d.at(0))
  }

  return filtered
}

#let time_256() = {
  let data = seq_data.at("data").at(1);
  let filtered = ()

  for d in data {
    filtered.push(d.at(0))
  }

  return filtered
}

#let time_512() = {
  let data = seq_data.at("data").at(2);
  let filtered = ()

  for d in data {
    filtered.push(d.at(0))
  }

  return filtered
}

#let time_1024() = {
  let data = seq_data.at("data").at(3);
  let filtered = ()

  for d in data {
    filtered.push(d.at(0))
  }

  return filtered
}

#let time_par_128() = {
  let filtered = ()

  for d in par_data {
    filtered.push(d.at(0).at(0) * 1000)
  }

  return filtered
}

#let time_par_256() = {
  let filtered = ()

  for d in par_data {
    filtered.push(d.at(1).at(0) * 1000)
  }

  return filtered
}
#let time_par_512() = {
  let filtered = ()

  for d in par_data {
    filtered.push(d.at(2).at(0) * 1000)
  }

  return filtered
}
#let time_par_1024() = {
  let filtered = ()

  for d in par_data {
    filtered.push(d.at(3).at(0) * 1000)
  }

  return filtered
}

#let graph_128 = lq.diagram(
  ylabel: [Time (s)],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.plot(range(time_128().len()), time_128(), mark:"none", color: black)
)

#let graph_256 = lq.diagram(
  ylabel: [Time (s)],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.plot(range(time_256().len()), time_256(), mark:"none", color: black)
)

#let graph_512 = lq.diagram(
  ylabel: [Time (s)],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.plot(range(time_512().len()), time_512(), mark:"none", color: black)
)

#let graph_1024 = lq.diagram(
  ylabel: [Time (s)],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.plot(range(time_1024().len()), time_1024(), mark:"none", color: black)
)

#let graph_all = lq.diagram(
  ylabel: [Time (s)],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.plot(range(time_128().len()), time_128(), mark:"none", label: [128]),
  lq.plot(range(time_256().len()), time_256(), mark:"none", label: [256]),
  lq.plot(range(time_512().len()), time_512(), mark:"none", label: [512]),
  lq.plot(range(time_1024().len()), time_1024(), mark:"none", label: [1024]),
)

#let graph_average_difference = lq.diagram(
  ylabel: [%],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .slice(2)
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.bar(range(seq_data.at("stages").len() - 2), seq_data.at("differences"))
)

#let graph_average_diff_between = lq.diagram(
  ylabel: [%],
  width: 100%,
  xaxis: (
    ticks: seq_data.at("stages")
      .slice(2)
      .map(rotate.with(-45deg, reflow: true))
      .map(align.with(right))
      .enumerate(),
    subticks: none
  ),
  lq.bar(range(seq_data.at("stages").len() - 2), seq_data.at("diff_between"))
)

#let graph_par_128 = lq.diagram(
  ylabel: [ms],
  width: 100%,
  xaxis: (
    ticks: ("1", "2","4","8","16","32").enumerate(),
    subticks: none,
  ),
  yaxis: (
    lim: (0, 10)
  ),
  lq.plot(range(6), time_par_128(), mark: none)
)

#let graph_par_256 = lq.diagram(
  ylabel: [ms],
  width: 100%,
  xaxis: (
    ticks: ("1", "2","4","8","16","32").enumerate(),
    subticks: none,
  ),
  yaxis: (
    lim: (0, 30)
  ),
  lq.plot(range(6), time_par_256(), mark: none)
)

#let graph_par_512 = lq.diagram(
  ylabel: [ms],
  width: 100%,
  xaxis: (
    ticks: ("1", "2","4","8","16","32").enumerate(),
    subticks: none,
  ),
  yaxis: (
    lim: (0, 90)
  ),
  lq.plot(range(6), time_par_512(), mark: none)
)

#let graph_par_1024 = lq.diagram(
  ylabel: [ms],
  width: 100%,
  xaxis: (
    ticks: ("1", "2","4","8","16","32").enumerate(),
    subticks: none,
  ),
  yaxis: (
    lim: (0, 400)
  ),
  lq.plot(range(6), time_par_1024(), mark: none)
)

