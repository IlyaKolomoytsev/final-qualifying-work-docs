#import "fqw.typ": fqw-indent-before-text, fqw-first-line-indent

#let en-introduction() = [
  #heading(numbering: none)[Введение]
]

#let en-header-conclusions(label: none) = [
  #heading(level: 2, numbering: none)[Выводы]
  #label
  #fqw-indent-before-text
]

#let en-bibliography(source) = [
  #pagebreak()
  #heading(numbering: none)[Список использованных источников]
  #fqw-indent-before-text
  #pad(left: fqw-first-line-indent, [
    #bibliography(
      source,
      title: none,
      style: "gost-r-7-0-100-2018-numeric-appearance.csl",
    )
  ])
]
