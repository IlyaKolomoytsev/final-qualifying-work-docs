#import "../core.typ": baseline, section-numbering

= Tables

== `#gost-table`

/// Renders a GOST-compliant numbered table with a sticky caption above and
/// a "Продолжение таблицы N" header repeated on subsequent pages.
///
/// Parameters:
/// - caption: The table caption displayed above the table body.
/// - columns: Column widths (int or array). Defaults to `1`.
/// - header: Table header cells passed to `table.header`. Defaults to `()`.
/// - rows: Table body cells. Defaults to `()`.
/// - align: Cell alignment. Defaults to `auto`.
/// - header-align: Alignment for the first two header rows. Defaults to `center + horizon`.
/// - inset: Cell padding. Defaults to `6pt`.
/// - label: An optional Typst label for cross-referencing. Auto-generated if `none`.
/// - caption-gap: Vertical gap between the continuation header and content. Defaults to `0.5em`.
/// - numbering-size: The heading depth used for the table number prefix. Defaults to `auto`.
///
/// Returns:
/// - A block containing the sticky caption and the table with a repeating header.
#let gost-table(
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
) = block(spacing: baseline)[
  #counter("gost-table").step()
  #set par(first-line-indent: 0pt)
  #counter(figure.where(kind: table)).step()
  #set text(hyphenate: true)

  #let table-label = if label == none {
    label("gost-table-" + str(counter(figure.where(kind: table)).get().first()))
  } else {
    label
  }
  #let table-number = context {
    let n = counter(figure.where(kind: table)).get().first()
    section-numbering(n, numbering-size: numbering-size)
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
