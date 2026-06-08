#import "fqw.typ": fqw-first-line-indent, fqw-indent-before-text

#let en-introduction() = [
  #heading(numbering: none)[Введение]
]

#let en-header-conclusions(label: none) = [
  #heading(level: 2, numbering: none)[Выводы]
  #label
  #fqw-indent-before-text
]

#let en-bibliography(source) = [
  #show bibliography: it => []
  #bibliography(
    source,
    title: none,
    style: "gost-r-7-0-100-2018-numeric-appearance.csl",
  )

]
