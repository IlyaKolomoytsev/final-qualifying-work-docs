#import "core.typ": title

#let en-header-conclusions(label: none) = [
  #title()[
    #heading(level: 2, numbering: none)[Выводы]
    #label
  ]
]

#let en-bibliography(source) = [
  #show bibliography: it => []
  #bibliography(
    source,
    title: none,
    style: "gost-r-7-0-100-2018-numeric-appearance.csl",
  )
]
