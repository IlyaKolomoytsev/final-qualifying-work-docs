= Help function

== `#warning`

/// Highlights warning or placeholder content in red.
///
/// Parameters:
/// - body: The content to render as a warning.
///
/// Returns:
/// - A `text` element with red fill containing the provided `body`.
#let warning(body) = text(fill: red)[#body]
#warning[Текст предупреждения]

== `#person`

#let word-cases = (
  [Nom],
  [Gen],
  [Dat],
  [Acc],
  [Ins],
  [Prep],
)

/// Creates a person record with full and abbreviated name representations.
///
/// Parameters:
/// - surname: The person's surname.
/// - first-name: The person's first name.
/// - patronymic: The person's patronymic.
/// - extras: Additional named fields to include in the resulting record.
///
/// Returns:
/// - A dictionary containing the source name parts, initials, formatted names,
///   and additional named fields.
#let person(full-name, ..extras) = {
  let make-fields(full-name, postfix: "") = {
    let surname = full-name.at(0)
    let first-name = full-name.at(1)
    let patronymic = full-name.at(2, default: none)

    let first-initial = first-name.at(0)
    let initials = if patronymic == none {
      [#first-initial.]
    } else {
      [#first-initial. #patronymic.at(0).]
    }

    let full = if patronymic == none {
      [#surname #first-name]
    } else {
      [#surname #first-name #patronymic]
    }

    let fields = (
      "surname" + postfix: surname,
      "first-name" + postfix: first-name,
      "patronymic" + postfix: patronymic,
      "initials" + postfix: initials,
      "full" + postfix: full,
      "short" + postfix: [#surname #initials],
      "reverse-short" + postfix: [#initials #surname],
    )

    fields
  }

  let full-name-cases = if type(full-name) == array {
    make-fields(full-name) + make-fields(full-name, postfix: "-nom")
  } else if type(full-name) == dictionary {
    let result = (:)

    for (key, value) in full-name {
      let postfix = "-" + key

      if key == "nom" {
        result += make-fields(value)
      }

      result += make-fields(value, postfix: postfix)
    }

    result
  } else {
    panic("full-name must be array or dictionary")
  }

  full-name-cases + extras.named()
}

#person(("Иванов", "Иван", "Иванович"))

== `#create-codes`

/// Creates document designation codes for a bachelor's final qualification work.
///
/// Parameters:
/// - number: The serial number of the work from the order. Defaults to `XX`.
/// - direction: The direction code. Defaults to `09.03.04`.
/// - department: The department code. Defaults to `10.19`.
/// - year: The completion year. Defaults to the current year.
///
/// Returns:
/// - A dictionary containing the base code in `fqw` and the derived codes in
///   `explanatory-note`, `technical-assignment`, and `system-programmers-guide`.
#let create-codes(
  number: [XX],
  direction: [09.03.04],
  department: [10.19],
  year: [#calc.rem(datetime.today().year(), 100)],
) = {
  let prefix = [ВКРБ]
  let explanatory-note-code = [81]
  let technical-assignment-code = [91]
  let system-programmers-guide-code = [32]
  let base = [#(prefix)--#(direction)--#(department)--#(number)--#(year)]
  (
    fqw: base,
    explanatory-note: [#(base)-#(explanatory-note-code)],
    technical-assignment: [#(base)-#(technical-assignment-code)],
    system-programmers-guide: [#(base)-#(system-programmers-guide-code)],
  )
}

#let default-codes = create-codes()

#default-codes.fqw \
#default-codes.explanatory-note \
#default-codes.technical-assignment \
#default-codes.system-programmers-guide

= Default values

#let fqw-fontsize-in-em = 1.25em
#let fqw-leading = 1.06em
#let fqw-baseline = fqw-fontsize-in-em + (fqw-leading / 2)
#let fqw-first-line-indent = 1.25cm
#let fqw-list-body-indent = 1.5em
#let fqw-default-numbering = state("fqw-default-numbering", 2)

= FQW functions

== `#fqw-indent-before-text`

#let fqw-indent-before-text = { v(fqw-fontsize-in-em + fqw-leading) }

== `default show functions`

#let fqw-default-page(body) = {
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 30mm,
      right: 15mm,
    ),
    header: none,
    footer: none,
    numbering: none,
  )
  body
}
#let fqw-default-text(body) = {
  set text(
    lang: "ru",
    font: "Times New Roman",
    size: 14pt,
    fill: black,
    weight: "regular",
    hyphenate: false,
  )
  body
}
#let fqw-default-paragraph(body) = {
  set par(
    justify: true,
    leading: fqw-leading,
    spacing: fqw-leading,
  )
  body
}
#let fqw-default-first-line-indent(body) = {
  set par(
    first-line-indent: (amount: fqw-first-line-indent, all: true),
  )
  body
}

#let fqw-default(body) = {
  show: fqw-default-page
  show: fqw-default-text
  show: fqw-default-paragraph
  show: fqw-default-first-line-indent
  body
}

== numbering functions

#let fqw-appendix-state = state("fqw-appendix-state", false)

#let fqw-appendix-letter(number) = {
  let letters = (
    "А",
    "Б",
    "В",
    "Г",
    "Д",
    "Е",
    "Ж",
    "И",
    "К",
    "Л",
    "М",
    "Н",
    "П",
    "Р",
    "С",
    "Т",
    "У",
    "Ф",
    "Х",
    "Ц",
    "Ш",
    "Щ",
    "Э",
    "Ю",
    "Я",
  )
  letters.at(number - 1)
}

#let fqw-appendix-numbers(counts) = (fqw-appendix-letter(counts.first()),) + counts.slice(1)

#let fqw-appendix-counts() = fqw-appendix-numbers(counter("fqw-appendix").get())

#let fqw-section-counts(loc: auto, numbering-size: auto) = {
  let read(c) = if loc == auto { c.get() } else { c.at(loc) }
  let numbering-size = if numbering-size == auto { read(fqw-default-numbering) } else { numbering-size }
  let arr = if read(fqw-appendix-state) {
    fqw-appendix-numbers(read(counter("fqw-appendix")))
  } else {
    read(counter(heading))
  }
  arr.slice(0, calc.min(numbering-size - 1, arr.len()))
}

#let fqw-numbering(n, numbering-size: auto) = context {
  (fqw-section-counts(numbering-size: numbering-size) + (n,)).map(str).join(".")
}

== ref function

#let fqw-ref(label, counter-name, numbering-size) = context {
  let prefix = fqw-section-counts(loc: label, numbering-size: numbering-size)
  (prefix + (counter(counter-name).at(label).first(),)).map(str).join(".")
}

#let fqw-section-ref(label) = context {
  let counts = fqw-section-counts(loc: label, numbering-size: 10)
  let last-nonzero = 0
  for (i, v) in counts.enumerate() {
    if v != 0 { last-nonzero = i }
  }
  counts.slice(0, last-nonzero + 1).map(str).join(".")
}

#let fqw-eq-ref(label, numbering-size: auto) = fqw-ref(
  label,
  math.equation,
  numbering-size,
)

#let fqw-figure-ref(label, numbering-size: auto) = fqw-ref(
  label,
  figure.where(kind: image),
  numbering-size,
)

#let fqw-table-ref(label, numbering-size: auto) = fqw-ref(
  label,
  figure.where(kind: table),
  numbering-size,
)

== fqw-document

#let fqw-document(body, document-code: warning[#default-codes.fqw]) = [
  #show: fqw-default

  // header and footer settings
  #set page(
    header: align(center)[#document-code],
    footer: context align(center)[#counter(page).display("1")],
  )

  // headers settings
  #show heading: it => block(
    spacing: fqw-baseline,
  )[
    #if it.level == 1 {
      // update counters
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }
    #show: fqw-default-text
    #par[
      #if it.numbering != none {
        context if fqw-appendix-state.get() {
          counter("fqw-appendix").step(level: it.level)
        }
        fqw-section-counts(numbering-size: 10).map(str).join(".")
        //         context if fqw-appendix-state.get() {
        //           fqw-appendix-counts().slice(0, it.level).map(str).join(".")
        //         } else {
        //           counter(heading).display(it.numbering)
        //         }
      }
      #it.body
    ]
  ]

  // equation settings
  #show math.equation: it => {
    if it.block {
      counter("fqw-equation").step()
      block(
        spacing: fqw-baseline,
      )[
        #it
      ]
    } else {
      it
    }
  }

  // lists
  #set list(marker: [--], indent: fqw-first-line-indent, body-indent: fqw-list-body-indent)
  #set enum(numbering: "1.", indent: fqw-first-line-indent, body-indent: fqw-list-body-indent)
  #show list: it => [
    #let w = measure([--]).width
    #set par(hanging-indent: -fqw-first-line-indent - w - fqw-list-body-indent)
    #it
  ]
  #show enum: it => [
    #let w = measure([--]).width
    #set par(hanging-indent: -fqw-first-line-indent - w - fqw-list-body-indent)
    #it
  ]

  // numbering
  #set heading(numbering: "1.1")
  #set math.equation(numbering: n => [(#fqw-numbering(n))])
  #show figure.where(kind: image): set figure(
    supplement: [Рисунок],
    numbering: n => [#fqw-numbering(n)],
  )

  #set figure.caption(
    separator: [ -- ],
  )

  // default color links
  #show link: it => text(fill: black)[#it]

  #body
]

== base titles

#let fqw-header-abstract() = [
  #heading(level: 1, numbering: none, outlined: false)[Аннотация]
  #fqw-indent-before-text
]
#let fqw-outline() = [
  #heading(numbering: none, outlined: false)[Содержание]
  #set outline.entry(fill: none) // Вроде так нужно
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

== appendix titles

#let fqw-appendix-title(title) = [
  #counter("fqw-appendix").step()
  #pagebreak()
  #v(1fr)

  #context {
    let number = fqw-appendix-letter(counter("fqw-appendix").get().first())

    show heading: it => []
    heading(numbering: none, outlined: true)[
      Приложение #number -- #title
    ]

    align(center)[
      Приложение #number
      #linebreak()
      #title
    ]
  }

  #v(1fr)
]
#let fqw-subappendix(title, label: none) = [
  #fqw-appendix-state.update(true)
  #counter("fqw-appendix").step(level: 2)

  #pagebreak()
  #context {
    let number = fqw-appendix-counts().slice(0, 2).map(str).join(".")
    // header for outline without rendering
    [
      #show heading: it => []
      #heading(numbering: none, outlined: true)[Приложение #number -- #title]
    ]
    // header for render
    align(right)[
      #heading(numbering: none, outlined: false)[Приложение #number]
      #if label != none { label }
    ]
  }

  #align(center)[#title]
  #fqw-indent-before-text
]

== equation help functions

#let fqw-equation-list(equations) = {
  show math.equation: it => {
    block(
      spacing: 0.5em,
    )[
      #it
    ]
  }
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
  #pad(left: fqw-first-line-indent, [
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
  ])
]

== figures

#let fqw-figure(body, caption, numbering-size: auto) = {
  counter("fqw-figure").step()
  let body = align(center)[#body]

  figure(
    kind: image,
    supplement: [Рисунок],
    caption: caption,
    numbering: n => fqw-numbering(n, numbering-size: numbering-size),
  )[#body]
}

#let fqw-placeholder-figure(caption) = fqw-figure(
  rect(width: 120mm, height: 45mm, stroke: 0.8pt)[
    #align(center + horizon)[Место для диаграммы]
  ],
  caption,
)

== tables

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
  numbering-size: auto,
) = block(spacing: fqw-baseline)[
  #counter("fqw-table").step()
  #set par(first-line-indent: 0pt)
  #counter(figure.where(kind: table)).step()
  #set text(hyphenate: true)

  #let table-label = if label == none {
    label("fqw-table-" + str(counter(figure.where(kind: table)).get().first()))
  } else {
    label
  }
  #let table-number = context {
    let n = counter(figure.where(kind: table)).get().first()
    fqw-numbering(n, numbering-size: numbering-size)
  }
  #let column-count = if type(columns) == int {
    columns
  } else {
    columns.len()
  }

  #block(
    sticky: true,
    spacing: 0pt,
  )[
    #set par(
      first-line-indent: 0pt,
      leading: 0em,
    )
    Таблица #table-number -- #caption
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
          Продолжение таблицы #table-number
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
]

// ToDo нужно убрать
#let document-title(title) = [
  #align(left)[#title]
]
