= Help components for title pages

== `warning`

/// Highlights warning or placeholder content in red.
///
/// Parameters:
/// - body: The content to render as a warning.
///
/// Returns:
/// - A `text` element with red fill containing the provided `body`.
#let warning(body) = text(fill: red)[#body]
#warning[Текст предупреждения]

== `#caption-text`
/// Creates caption text with a reduced font size.
///
/// Parameters:
/// - body: The caption content.
///
/// Returns:
/// - A `text` element with a font size of 7.5pt containing the provided `body`.
#let caption-text(body) = text(size: 7.5pt)[#body]
#caption-text[Пример подписи]

== `#field`
/// Creates a full-width form field with an underlined value area and a centered caption below it.
///
/// Parameters:
/// - value: The field content displayed above the underline. Defaults to empty content.
/// - caption: The caption displayed below the underline. Defaults to empty content.
/// - align-value: Horizontal alignment for the field value. Defaults to `center`.
///
/// Behavior:
/// - If `value` is empty, the value area receives a fixed height of 10pt.
/// - If `value` is not empty, the value area height is determined automatically.
/// - The value is vertically aligned to the horizon and horizontally aligned using `align-value`.
/// - The caption is rendered with `caption-text` and centered below the field.
///
/// Returns:
/// - A full-width `box` containing the underlined value area and its caption.
#let field(value: [], caption: [], align-value: center) = box(width: 100%)[
  #box(
    width: 100%,
    height: if value == [] { 10pt } else { auto },
    inset: (bottom: 2pt, left: 1em, right: 1em),
    stroke: (bottom: 0.5pt),
  )[
    #align(align-value + horizon)[#value]
  ]
  #v(1pt)
  #align(center)[#caption-text(caption)]
]
#field(value: [Иванов И. И.], caption: [фамилия, имя, отчество])

== `#print-date`
/// Creates a three-part date layout for title-page approval blocks.
///
/// Parameters:
/// - d: A `datetime` value to split into day, month, and year, or `none` to render empty placeholders.
///
/// Behavior:
/// - When `d` is a `datetime`, the function renders the day, month, and year in separate fields.
/// - When `d` is `none`, the function renders blank fields for the day and month and a placeholder year area.
///
/// Returns:
/// - A centered three-column `grid` with fields for day, month, and year.
#let print-date(d) = [
  #grid(
    align: center,
    columns: (1fr, 3fr, 2fr),
    column-gutter: 1fr,
  )[
    \"#field(value: [#if d != none { d.day() }])\"
  ][
    #field(value: [#if d != none { d.month() }])
  ][
    #if d != none {
      field(value: [#d.year()~~~г.])
    } else {
      [20 #box(width: 1fr)[#field()] г.]
    }
  ]
]
#print-date(none)
#print-date(datetime(year: 2026, month: 5, day: 25))

== `#labeled-field`
/// Creates a labeled form field arranged in a two-column grid.
///
/// Parameters:
/// - label: The label displayed in the left column.
/// - value: The field content displayed in the right column. Defaults to empty content.
/// - caption: The caption displayed below the field value. Defaults to empty content.
/// - value-width: The width of the value column. Defaults to `1fr`.
///
/// Returns:
/// - A grid containing the label and the corresponding underlined field.
#let labeled-field(label, value: [], caption: [], value-width: 1fr) = grid(
  columns: (auto, value-width),
  column-gutter: 8pt,
  align: (left, horizon),
)[
  #label
][
  #field(value: value, caption: caption)
]
#labeled-field(
  [Группа],
  value: [ПрИн-466],
  caption: [шифр учебной группы],
)

== `#signature-row`
/// Creates a signature row with a label, signature/date field, and name field.
///
/// Parameters:
/// - label: The label displayed in the left column.
/// - signature-date: The signature and signing date value. Defaults to empty content.
/// - name: The name value displayed in the right field. Defaults to empty content.
/// - name-caption: The caption displayed below the name field. Defaults to empty content.
///
/// Returns:
/// - A three-column grid containing the label, signature/date field, and name field.
#let signature-row(label, signature-date: [], name: [], name-caption: []) = grid(
  columns: (auto, 48mm, 1fr),
  column-gutter: 8pt,
  align: (left, horizon, horizon),
)[
  #label
][
  #field(value: signature-date, align-value: right, caption: [подпись и дата подписания])
][
  #field(value: name, caption: name-caption)
]
#signature-row(
  [Автор],
  signature-date: [20.05.2026],
  name: [Коломойцев И. С.],
  name-caption: [фамилия, инициалы],
)

== `#consultant-row`
/// Creates a consultant row for a section with signature/date and name fields.
///
/// Parameters:
/// - section: The section name displayed in the left field. Defaults to empty content.
/// - signature-date: The signature and signing date value. Defaults to empty content.
/// - name: The consultant name displayed in the right field. Defaults to empty content.
///
/// Returns:
/// - A three-column grid containing the section, signature/date field, and name field.
#let consultant-row(section: [], signature-date: [], name: []) = grid(
  columns: (1fr, 48mm, 1fr),
  column-gutter: 8pt,
  align: bottom,
)[
  #field(value: section, caption: [краткое наименование раздела])
][
  #field(value: signature-date, align-value: right, caption: [подпись и дата подписания])
][
  #field(value: name, caption: [инициалы и фамилия])
]
#consultant-row(
  section: [Экономическая часть],
  signature-date: [22.05.2026],
  name: [Соколова А. И.],
)

== `#makeRows`

/// Converts optional content into a sequence of field rows and pads it to a minimum length.
///
/// Parameters:
/// - body: `none`, a single content value, or an array of content values to render as rows.
/// - minRowsCount: The minimum number of rows to return. Defaults to `0`.
///
/// Behavior:
/// - When `body` is `none`, no source rows are added.
/// - When `body` is an array, its items are used as rows.
/// - When `body` is content, it is wrapped into a single-row sequence.
/// - Empty rows are appended until the sequence length reaches `minRowsCount`.
///
/// Returns:
/// - A sequence of content rows suitable for passing to `print-field-rows`.
#let makeRows(body, minRowsCount: 0) = {
  let rows = ()
  if body != none {
    if type(body) == array {
      rows = rows + body
    } else if type(body) == content {
      rows = rows + (body,)
    }
  }
  if rows.len() < minRowsCount {
    for i in range(minRowsCount - rows.len()) {
      rows.push([])
    }
  }
  return rows
}

#makeRows(none, minRowsCount: 5)

#makeRows(minRowsCount: 2)[Мой текст]

#makeRows(([1 строка], [2 строка]), minRowsCount: 5)

== `#print-field-rows`

/// Prints a titled sequence of underlined form fields.
///
/// Parameters:
/// - gutter: Vertical spacing inserted before each rendered field row. Defaults to `0pt`.
/// - field-align: Horizontal alignment for each field value. Defaults to `left`.
/// - numberic: Whether to render row numbers before fields. Defaults to `false`.
/// - title: Optional title displayed before the field rows. Defaults to `none`.
/// - rows: Positional row content collected from the variadic arguments.
///
/// Behavior:
/// - The title is emitted first.
/// - Each row receives `gutter` spacing before it.
/// - When `numberic` is true, each row is rendered in a two-column grid with a one-based index.
/// - When `numberic` is false, each row is rendered as a full-width field.
///
/// Returns:
/// - Content containing the optional title and the rendered field rows.
#let print-field-rows(
  gutter: 0pt,
  field-align: left,
  numberic: false,
  title: none,
  ..rows,
) = {
  title
  for (i, row) in rows.pos().enumerate() {
    v(gutter)
    if numberic {
      grid(columns: (1fr, 10fr))[
        #(i+1))
      ][
        #field(value: row, align-value: field-align)
      ]
    } else {
      field(value: row, align-value: field-align)
    }
  }
}
