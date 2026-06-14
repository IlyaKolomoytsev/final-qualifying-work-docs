#import "utils.typ": warning
#import "persons.typ": default-codes

= Default values

#let fontsize-in-em = 1.25em
#let leading = 1.06em
#let baseline = fontsize-in-em + leading
#let first-line-indent = 1.25cm
#let list-body-indent = 1.5em
#let default-numbering = state("default-numbering", 2)

= FQW functions

/// Wraps a heading in a block with correct GOST spacing.
/// Pass `new-chapter: true` to insert a page break before the block.
#let title(body, new-chapter: false) = {
  if new-chapter { pagebreak() }
  block(spacing: baseline * 2, width: 100%, sticky: true)[#body]
}

== `default show functions`

#let default-page(body) = {
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
#let default-text(body) = {
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
#let default-paragraph(body) = {
  set par(
    justify: true,
    leading: leading,
    spacing: leading,
  )
  body
}
#let default-first-line-indent(body) = {
  set par(
    first-line-indent: (amount: first-line-indent, all: true),
  )
  body
}

#let default(body) = {
  show: default-page
  show: default-text
  show: default-paragraph
  show: default-first-line-indent
  body
}

== numbering functions

#let appendix-state = state("appendix-state", false)

#let appendix-letter(number) = {
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

#let appendix-numbers(counts) = (appendix-letter(counts.first()),) + counts.slice(1)

#let appendix-counts() = appendix-numbers(counter("appendix").get())

#let section-counts(loc: auto, numbering-size: auto) = {
  let read(c) = if loc == auto { c.get() } else { c.at(loc) }
  let numbering-size = if numbering-size == auto { read(default-numbering) } else { numbering-size }
  let arr = if read(appendix-state) {
    appendix-numbers(read(counter("appendix")))
  } else {
    read(counter(heading))
  }
  arr.slice(0, calc.min(numbering-size - 1, arr.len()))
}

#let section-numbering(n, numbering-size: auto) = context {
  (section-counts(numbering-size: numbering-size) + (n,)).map(str).join(".")
}

== ref function

#let cross-ref(label, counter-name, numbering-size) = context {
  let prefix = section-counts(loc: label, numbering-size: numbering-size)
  (prefix + (counter(counter-name).at(label).first(),)).map(str).join(".")
}

#let section-ref(label) = context {
  let counts = section-counts(loc: label, numbering-size: 10)
  let last-nonzero = 0
  for (i, v) in counts.enumerate() {
    if v != 0 { last-nonzero = i }
  }
  counts.slice(0, last-nonzero + 1).map(str).join(".")
}

#let eq-ref(label, numbering-size: auto) = cross-ref(
  label,
  math.equation,
  numbering-size,
)

#let figure-ref(label, numbering-size: auto) = cross-ref(
  label,
  figure.where(kind: image),
  numbering-size,
)

#let table-ref(label, numbering-size: auto) = cross-ref(
  label,
  figure.where(kind: table),
  numbering-size,
)

== document-setup

#let document-setup(body, document-code: warning[#default-codes.fqw]) = [
  #show: default

  // header and footer settings
  #set page(
    header: align(center)[#document-code],
    footer: context align(center)[#counter(page).display("1")],
  )

  // headers settings
  #show heading: it => block(
    spacing: baseline,
  )[
    #if it.level == 1 {
      // update counters
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }
    #show: default-text
    #par[
      #if it.numbering != none {
        context if appendix-state.get() {
          counter("appendix").step(level: it.level)
        }
        section-counts(numbering-size: 10).map(str).join(".")
      }
      #it.body
    ]
  ]

  // equation settings
  #show math.equation: it => {
    if it.block {
      counter("equation").step()
      block(
        spacing: baseline,
      )[
        #it
      ]
    } else {
      it
    }
  }

  // lists
  #set list(marker: [--], indent: first-line-indent, body-indent: list-body-indent)
  #set enum(numbering: "1.", indent: first-line-indent, body-indent: list-body-indent)
  #show list: it => [
    #let w = measure([--]).width
    #set par(hanging-indent: -first-line-indent - w - list-body-indent)
    #it
  ]
  #show enum: it => [
    #let w = measure([--]).width
    #set par(hanging-indent: -first-line-indent - w - list-body-indent)
    #it
  ]

  // numbering
  #set heading(numbering: "1.1")
  #set math.equation(numbering: n => [(#section-numbering(n))])
  #show figure.where(kind: image): set figure(
    supplement: [Рисунок],
    numbering: n => [#section-numbering(n)],
  )

  #set figure.caption(
    separator: [ -- ],
  )

  // default color links
  #show link: it => text(fill: black)[#it]

  #body
]
