#import "./report.typ": report

#let title_page(title: [], subtitle:[], authors: []) = {
  set page(columns: 1)
  set block(above: 1em, below: 1em)

  rect(
    width: 100%,
    height: 100%,
    stroke: none,
    align(
      center + horizon, 
      grid(
        rows: (1fr, 1fr, 1fr),
        [
          #align(center, text(26pt, weight: "bold")[#title])
          #line(length: 100%)
          #align(center, text(14pt)[#subtitle])
      ],
        [
        #image("bth-logga.jpg", scaling: "smooth")
      ],
        [
        #align(center, text(14pt)[#authors])
      ],
      )
    )
  )
}

