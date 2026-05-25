#let fqw-default-document-code = "ВКРБ-09.03.04-10.19-XX-26-81"

#let fqw-fontsize-in-em = 1.25em
#let fqw-leading = 1.06em
#let fqw-baseline = fqw-fontsize-in-em + fqw-leading

#let fqw-indent-before-text = { v(fqw-fontsize-in-em) }

#let fqw-text-settings(body) = [
  #set text(
    lang: "ru",
    font: "Times New Roman",
    size: 14pt,
    fill: black,
    weight: "regular",
    hyphenate: false,
  )
  #set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
    leading: fqw-leading,
    spacing: 1.1em,
  )
  #body
]

#let fqw-document(body, document-code: fqw-default-document-code) = [
  // page settings
  #set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 30mm,
      right: 15mm,
    ),
    header: align(center)[#document-code],
    footer: context align(center)[#counter(page).display("1")],
  )

  // main text settings
  #show: fqw-text-settings

  // headers settings
  #show heading: it => block(
    spacing: fqw-baseline,
  )[
    #if it.level == 1 {
      counter(figure.where(kind: image)).update(0)
      counter("fqw-table").update(0)
    }
    #show: fqw-text-settings
    #set par()
    #par[
      #if it.numbering != none [
        #counter(heading).display(it.numbering) #h(0.5em)
      ]
      #it.body
    ]
  ]

  #show math.equation: it => {
    if it.block {
      block(
        spacing: fqw-baseline,
      )[
        #it
      ]
    } else {
      it
    }
  }

  // lists markers
  #set list(marker: [--], indent: 1.25cm)
  #set enum(numbering: "1.", indent: 1.25cm)

  // numbering
  #set heading(numbering: "1.1")
  #set enum(numbering: "1.")
  #set math.equation(numbering: n => {
    numbering(
      "(1.1)",
      counter(heading).get().first(),
      n,
    )
  })
  #show figure.where(kind: image): set figure(
    supplement: [Рисунок],
    numbering: n => numbering(
      "1.1",
      counter(heading).get().first(),
      n,
    ),
  )

  #set figure.caption(
    separator: [ -- ],
  )

  // default color links
  #show link: it => text(fill: black)[#it]

  #body
]

#let fqw-header-abstract() = [
  #heading(level: 1, numbering: none, outlined: false)[Аннотация]
  #fqw-indent-before-text
]

#let fqw-outline() = [
  #heading(numbering: none, outlined: false)[Содержание]
  #outline(title: none, depth: 3, indent: 0pt)
  #pagebreak()
]

#let fqw-introduction(label: none, heading-counter: none) = [
  #heading(numbering: none)[Введение]
  #fqw-indent-before-text
  #if label != none {
    label
  }
  #if heading-counter != none {
    counter(heading).update(heading-counter)
  }
]

#let fqw-equation-list(equations) = {
  block(spacing: fqw-baseline)[
    #for (i, item) in equations.enumerate() {
      let is-last = i == equations.len() - 1
      let formula = if type(item) == array {
        item.at(0)
      } else {
        item
      }
      let label = if type(item) == array and item.len() > 1 {
        item.at(1)
      } else {
        none
      }

      let body = [
        #formula#if not is-last [,]
      ]

      if label == none {
        math.equation(
          numbering: none,
          block: true,
        )[
          #body
        ]
      } else {
        let eq = math.equation(
          block: true,
        )[
          #body
        ]
        [#eq #label]
      }
    }
  ]
}

#let fqw-where(items) = block[
  #set par(first-line-indent: 0pt)

  #grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
  )[
    где
  ][
    #for (i, item) in items.enumerate() [
      #item.at(0) -- #item.at(1)#if i == items.len() - 1 [.] else [;] \
    ]
  ]
]

#let fqw-eq-ref(label) = context numbering("(1.1)", ..counter(math.equation).at(label))

#let fqw-figure-ref(label) = context numbering(
  "1.1",
  counter(heading).at(label).first(),
  counter(figure.where(kind: image)).at(label).first(),
)

#let fqw-table-number() = context numbering(
  "1.1",
  counter(heading).get().first(),
  counter("fqw-table").get().first(),
)

#let fqw-table-ref(label) = context numbering(
  "1.1",
  counter(heading).at(label).first(),
  counter("fqw-table").at(label).first(),
)

#let fqw-figure(body, caption) = figure(
  kind: image,
  supplement: [Рисунок],
  caption: caption,
)[
  #align(center)[#body]
]

#let fqw-placeholder-figure(caption) = fqw-figure(
  rect(width: 120mm, height: 45mm, stroke: 0.8pt)[
    #align(center + horizon)[Место для диаграммы]
  ],
  caption,
)

#let fqw-table(
  caption,
  columns: 1,
  header: (),
  rows: (),
  align: auto,
  header-align: center + horizon,
  inset: 6pt,
  label: none,
  caption-gap: 0.5em,
) = [
  #set par(first-line-indent: 0pt)
  #counter("fqw-table").step()

  #let table-label = if label == none {
    label("fqw-table-" + str(counter("fqw-table").get().first()))
  } else {
    label
  }
  #let column-count = if type(columns) == int {
    columns
  } else {
    columns.len()
  }

  #v(fqw-baseline)

  #block(
    sticky: true,
    spacing: 0pt,
  )[
    #set par(
      first-line-indent: 0pt,
      leading: 0em,
    )
    Таблица #fqw-table-number() -- #caption
    #table-label
  ]

  #let repeated-header = (
    (
      table.cell(
        colspan: column-count,
        inset: (top: 0pt, bottom: caption-gap, left: 0pt, right: 0pt),
        stroke: none,
      )[
        #context if here().page() != query(table-label).first().location().page() [
          Продолжение таблицы #fqw-table-number()
        ]
      ],
    )
      + header
  )

  #show table.cell.where(y: 0): set table.cell(align: header-align)
  #show table.cell.where(y: 1): set table.cell(align: header-align)

  #table(
    columns: columns,
    align: align,
    inset: inset,
    table.header(..repeated-header),
    ..rows,
  )

  #v(fqw-baseline)
]

#let fqw-landscape(body, document-code: none) = page(
  flipped: true,
  header: if document-code == none {
    none
  } else {
    grid(
      columns: (1fr, auto),
      align: (left, right),
      [#document-code], context counter(page).display("1"),
    )
  },
)[#body]

#let fqw-appendix(title) = [
  #pagebreak()
  #counter("fqw-appendix").step()
  #align(center)[
    Приложение #context counter("fqw-appendix").display("А")
    #linebreak()
    #title
  ]
]

#let fqw-subappendix(title) = [
  #counter("fqw-subappendix").step()
  #align(right)[
    Приложение #context counter("fqw-appendix").display("А").#sym.dot#context counter("fqw-subappendix").display("1")
  ]
  #align(center)[#title]
]

#let document-title(title) = [
  #align(left)[#title]
]
