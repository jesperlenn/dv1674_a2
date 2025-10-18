#import "./import/title.typ": title_page
#import "./import/report.typ": report

#show: report

#title_page(
  title: [Optimization of Pearson and Blur],
  subtitle: [DV1674 | Assignment 2],
  authors: grid(
    columns: (1fr, 1fr),
    [Alexander Järnström\ aljr21\@student.bth.se],
    [Jesper Lennehag\ jele22\@student.bth.se]
  )
)

#show outline: (it) => {
  set page(columns: 1)
  it
}

#outline()

#counter(page).update(1)

#include "pages/introduction.typ"
#include "pages/method.typ"
#include "pages/pearson.typ"
#include "pages/blur.typ"
#include "pages/results.typ"
