#import "core.typ" as fqw

= Section titles

== `#header-abstract`

/// Renders an unnumbered, unoutlined "Аннотация" heading.
#let header-abstract() = [
  #fqw.title(
    heading(level: 1, numbering: none, outlined: false)[Аннотация],
  )
]

== `#contents`

/// Renders "Содержание" heading followed by the table of contents, then a page break.
#let contents() = [
  #fqw.title(
    heading(numbering: none, outlined: false)[Содержание],
  )
  #set outline.entry(fill: none) // Вроде так нужно
  #outline(title: none, depth: 3, indent: 0pt)
  #pagebreak()
]

== `#introduction`

/// Renders an unnumbered "Введение" heading with an optional label.
///
/// Parameters:
/// - label: An optional label attached after the heading. Defaults to `none`.
#let introduction(label: none) = [
  #fqw.title(
    heading(numbering: none)[Введение],
  )
  #if label != none {
    label
  }
]

== `#appendix-title`

/// Renders a top-level appendix page ("Приложение А — …") centred vertically.
///
/// Parameters:
/// - title: The appendix title displayed below the letter designation.
#let appendix-title(title) = [
  #counter("appendix").step()
  #pagebreak()
  #v(1fr)

  #context {
    let number = fqw.appendix-letter(counter("appendix").get().first())

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

== `#subappendix`

/// Renders a sub-level appendix section ("Приложение А.1") with an optional label.
///
/// Parameters:
/// - title: The sub-appendix title displayed centred below the number.
/// - label: An optional label attached to the right-aligned heading. Defaults to `none`.
#let subappendix(title, label: none) = [
  #fqw.appendix-state.update(true)
  #counter("appendix").step(level: 2)

  #pagebreak()
  #context {
    let number = fqw.appendix-counts().slice(0, 2).map(str).join(".")
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

  #fqw.title(
    align(center)[#title],
  )
]
