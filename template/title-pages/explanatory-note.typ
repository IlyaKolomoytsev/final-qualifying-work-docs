#import "components.typ": *

= Explanatory note title pages

== `#approval-block`
/// Creates an approval block with a centered title, optional position field,
/// signature/name fields, and a date line.
///
/// Parameters:
/// - title: The approval block title displayed at the top.
/// - position: The position value displayed below the title. Defaults to empty content.
/// - signature-date: The signature value displayed in the left field. Defaults to empty content.
/// - name: The initials and surname value displayed in the right field. Defaults to empty content.
/// - date: The date displayed below the signature fields. Defaults to empty content.
/// - position-caption: The caption displayed below the position field. Defaults to empty content.
///
/// Returns:
/// - A block containing the approval title, optional position field, signature/name fields, and date.
#let approval-block(
  title: [your title],
  position: [],
  signature-date: [],
  name: [],
  date: [],
  position-caption: [],
) = block[
  #grid(
    columns: (1fr,),
    row-gutter: 1em
  )[
    #align(center)[#title]
  ][
    #if position == [] and position-caption == [] [
      #v(1em)
    ] else [
      #field(value: position, caption: position-caption)
    ]
  ][
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 8pt,
    )[
      #field(value: signature-date, caption: [(подпись)])
    ][
      #field(value: name, caption: [(инициалы, фамилия)])
    ]
  ][
    #align(left)[#date]
  ]
]
#approval-block(
  title: [Утверждаю],
  position: [и. о. заведующего кафедрой],
  signature-date: [15.05.2026],
  name: [Сычёв О. А.],
  date: [15.05.2026],
  position-caption: [должность],
)

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

== `#explanatory-note-title-page`
/// Creates the title page for a bachelor's explanatory note.
///
/// Parameters:
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - faculty: The faculty name rendered in the labeled faculty field.
/// - department: The department name rendered in the labeled department field.
/// - agreement-position: The position shown in the "Согласовано" block.
/// - agreement-name: The name shown in the "Согласовано" block.
/// - agreement-date: A `datetime` value or `none` for the date shown in the "Согласовано" block.
/// - approval-position: The position shown in the "Утверждаю" block.
/// - approval-signature-date: The signature and signing date shown in the "Утверждаю" block.
/// - approval-name: The name shown in the "Утверждаю" block.
/// - approval-date: A `datetime` value or `none` for the date shown in the "Утверждаю" block.
/// - document-title: The main document title.
/// - work-kind: The work type shown between "к" and "на тему".
/// - topic: The work topic.
/// - author: The author's full name.
/// - author-signature-date: The author's signature and signing date.
/// - document-code: The document code.
/// - group: The student group code.
/// - direction: The field-of-study and profile description.
/// - supervisor: The supervisor's name.
/// - supervisor-signature-date: The supervisor's signature and signing date.
/// - consultants: A sequence of consultant records with `section`, `signature-date`, and `name` fields.
/// - norm-controller: The norm controller's name.
/// - norm-controller-signature-date: The norm controller's signature and signing date.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the full title-page layout.
#let explanatory-note-title-page(
  ministry: [Министерство науки и высшего образования Российской Федерации],
  university: [
    Федеральное государственное бюджетное образовательное учреждение \
    высшего образования \
    «Волгоградский государственный технический университет»
  ],
  faculty: [Электроники и вычислительной техники],
  department: [Программное обеспечение автоматизированных систем],
  agreement-position: [],
  agreement-name: [],
  agreement-date: none,
  approval-position: [и. о. зав. кафедрой],
  approval-signature-date: [],
  approval-name: [О. А. Сычев],
  approval-date: none,
  document-title: [ПОЯСНИТЕЛЬНАЯ ЗАПИСКА],
  work-kind: [выпускной квалификационной работе бакалавра],
  topic: [],
  author: [],
  author-signature-date: [],
  document-code: [],
  group: [],
  direction: [
    09.03.04 -- Программная инженерия, \
    Разработка программно-информационных систем
  ],
  supervisor: [],
  supervisor-signature-date: [],
  consultants: (
    (section: [], signature-date: [], name: []),
    (section: [], signature-date: [], name: []),
  ),
  norm-controller: [Кузнецова А.С.],
  norm-controller-signature-date: [],
  city: [Волгоград],
  year: [20#h(8mm)],
) = page(
  paper: "a4",
  margin: (
    top: 14mm,
    bottom: 14mm,
    left: 20mm,
    right: 15mm,
  ),
  header: none,
  footer: none,
  numbering: none,
)[
  #set text(
    lang: "ru",
    font: "Times New Roman",
    size: 14pt,
    fill: black,
  )
  #set par(
    first-line-indent: 0pt,
    justify: false,
    leading: 0.6em,
    spacing: 0pt,
  )
  #let gutter = 0.8em
  #block(height: 1fr)[
    #grid(
      columns: (1fr,),
      row-gutter: (0.5fr, 0.5fr, 0.8fr, 0.8fr, 0.3fr, 0.5fr),
    )[
      #align(center)[
        #ministry \
        #university
      ]
    ][
      #grid(
        columns: (1fr,),
        row-gutter: gutter,
      )[
        #labeled-field([Факультет], value: faculty)
      ][
        #labeled-field([Кафедра], value: department)
      ]
    ][
      #grid(
        columns: (1fr, 1fr),
        column-gutter: 22mm,
      )[
        #approval-block(
          title: [Согласовано],
          position: agreement-position,
          name: agreement-name,
          date: align(center)[#block(width: 80%)[#print-date(agreement-date)]],
          position-caption: [должность гл. специалиста предприятия],
        )
      ][
        #approval-block(
          title: [Утверждаю],
          position: approval-position,
          signature-date: approval-signature-date,
          name: approval-name,
          date: align(center)[#block(width: 80%)[#print-date(approval-date)]],
          position-caption: [],
        )
      ]
    ][
      #grid(
        columns: (1fr,),
        row-gutter: gutter,
      )[
        #align(center)[#strong(upper(document-title))]
      ][
        #grid(
          columns: (auto, 1fr, auto),
          column-gutter: 6pt,
          align: (left, horizon, right),
        )[
          к
        ][
          #field(value: work-kind, caption: [наименование вида работы])
        ][
          на тему
        ]
      ][
        #field(value: topic)
      ]
    ][
      #grid(
        columns: (1fr,),
        row-gutter: gutter,
      )[
        #signature-row(
          [Автор],
          signature-date: author-signature-date,
          name: author,
          name-caption: [фамилия, имя, отчество],
        )
      ][
        #grid(
          columns: (auto, 1fr),
          column-gutter: gutter,
          row-gutter: gutter,
        )[
          Обозначение
        ][
          #block(width: 50%)[#field(value: document-code, caption: [код документа])]
        ][
          Группа
        ][
          #block(width: 40%)[#field(value: group, caption: [шифр группы])]
        ][
          Направление
        ][
          #block(width: 90%)[#field(
            value: direction,
            caption: [код и наименование направления, наименование программы (профиля)],
          )]

        ]
      ][
        #signature-row(
          [Руководитель работы],
          signature-date: supervisor-signature-date,
          name: supervisor,
          name-caption: [инициалы и фамилия],
        )
      ]
    ][
      Консультанты по разделам:
      #for consultant in consultants [
        #block(spacing: gutter)[
          #consultant-row(
            section: consultant.section,
            signature-date: consultant.signature-date,
            name: consultant.name,
          )
        ]
      ]
      #signature-row(
        [Нормоконтролер:],
        signature-date: norm-controller-signature-date,
        name: norm-controller,
        name-caption: [инициалы и фамилия],
      )
    ][
      #align(center)[#city #year г.]
    ]
  ]
]
