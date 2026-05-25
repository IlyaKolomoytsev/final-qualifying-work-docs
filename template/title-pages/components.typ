= Help components for title pages

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
