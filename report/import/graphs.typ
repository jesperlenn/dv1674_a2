#import "@preview/lilaq:0.5.0" as lq
#import "../data/pearson.typ": seq_data

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
