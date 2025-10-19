#let report(doc) = {
  set page(
    paper: "a4",
    columns: 2,
    margin: 1.5cm
  )
  set par(
    first-line-indent: 1em,
    justify: true,
    spacing: 0.65em
  )

  set list(
    marker: [---],
    indent: 1em,
    body-indent: 1em
  )

  set text(size: 11pt)
  set heading(numbering: "I.")

  show heading.where(level: 1): it => {
    smallcaps(text(14pt, weight: "regular")[#it])
    set block(above: 0em);
    line(length: 100%)
  }

  show heading.where(level: 2): it => {
    smallcaps(text(12pt, weight: "regular")[#it])
  }

  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    set block(above: 1em, below: 1em)

    it
  }

  set table(
    stroke: (x, y) => {
    if y == 0 {
      (bottom: 0.7pt + black)
    }
  },
    fill: (_, y) => {
      if not calc.even(y) {
        luma(230)
      }
    },
    inset: (right: 1.5em),
  )

  show table.cell: it => {
    if it.x == 0 {
      align(left, strong(it))
    } else if it.y == 0 {
      strong(it) 
    } else if it.body == [] {
      pad(..it.inset)[_N/A_]
    } else {
      it
    }
  }

  show table: it => {
    set par(justify: false)
    rect(inset: 0.35pt, stroke: 0.7pt + black, it)
  }

  doc
}

#let floating_figure(alignment, caption: [], body) = place(
  alignment,
  float: true,
  clearance: 2em,
  figure(
    caption: caption,
    body
  )
)

#let title(title: [], subtitle: []) = {
  place(
    center + top,
    float: true,
    scope: "parent",
    clearance: 2em
  )[
    #set block(above: 1em, below: 1em)
    #align(center, text(17pt, weight: "bold")[
      #title
    ])
    #line(length: 100%)
    
    #line(length: 100%)
    #align(center, text(12pt)[#subtitle])
  ]
}

