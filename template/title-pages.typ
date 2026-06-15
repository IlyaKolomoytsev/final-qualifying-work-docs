#import "core.typ": default-first-line-indent, default-page, default-paragraph, default-text
#import "utils.typ": warning
#import "defaults.typ"

= Help components for title pages

== `#caption-text`
/// Creates caption text with a reduced font size.
///
/// Parameters:
/// - body: The caption content.
///
/// Returns:
/// - A `text` element with a font size of 7.5pt containing the provided `body`.
#let caption-text(body) = text(size: 7.5pt)[#if body != [] [(#body)]]
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
#let field(value: [], caption: [], align-value: center, horizontal-inset: 1em) = box(width: 100%)[
  #set par(
    spacing: 0pt,
  )
  #box(
    width: 100%,
    height: if value == [] { 10pt } else { auto },
    inset: (bottom: 2pt, left: horizontal-inset, right: horizontal-inset),
    stroke: (bottom: 0.5pt),
  )[
    #align(align-value + horizon)[#value]
  ]
  #v(1pt)
  #align(center)[#caption-text(caption)]
]
#field(value: [Иванов И. И.], caption: [фамилия, имя, отчество])

== `#print-date`

#let month-names = (
  "января",
  "февраля",
  "марта",
  "апреля",
  "мая",
  "июня",
  "июля",
  "августа",
  "сентября",
  "октября",
  "ноября",
  "декабря",
)

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
    #field(value: [#if d != none { month-names.at(d.month() - 1) }])
  ][
    #if d != none {
      field(value: [#d.year()~г.])
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
#let labeled-field(label, value: [], caption: [], value-width: 1fr, ..field-parameters) = grid(
  columns: (auto, value-width),
  column-gutter: 8pt,
  align: (left, horizon),
)[
  #label
][
  #field(value: value, caption: caption, ..field-parameters.named())
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
/// - field-align: Horizontal alignment for each field value. Defaults to `left`.
/// - numberic: Whether to render row numbers before fields. Defaults to `false`.
/// - title: Optional title displayed before the field rows. Defaults to `none`.
/// - rows: Positional row content collected from the variadic arguments.
///
/// Behavior:
/// - The title is emitted first.
/// - When `numberic` is true, each row is rendered in a two-column grid with a one-based index.
/// - When `numberic` is false, each row is rendered as a full-width field.
///
/// Returns:
/// - Content containing the optional title and the rendered field rows.
#let print-field-rows(
  field-align: left,
  numberic: false,
  title: none,
  ..rows,
) = {
  set par(
    leading: 0.45em,
    spacing: 0.543em,
  )
  title
  for (i, row) in rows.pos().enumerate() {
    if numberic {
      grid(columns: (2.5em, 1fr))[
        #(i + 1))
      ][
        #field(value: row, align-value: field-align)
      ]
      field(value: [], align-value: field-align)
    } else {
      field(value: row, align-value: field-align)
    }
  }
}
=== Without numbers
#print-field-rows(..([Row 1], [Row 2]))
=== With numbers
#print-field-rows(numberic: true, ..([Row 1], [Row 2]))

= Explanatory note title pages
#let default-spacing = 0.8em

#let person-field(person, key, default: []) = {
  if person == none {
    default
  } else {
    person.at(key, default: default)
  }
}

== `#approval-block`
/// Creates an approval block with a centered title, optional position field,
/// signature/name fields, and a date line.
///
/// Parameters:
/// - title: The approval block title displayed at the top.
/// - position: The position value displayed below the title. Defaults to empty content.
/// - name: The initials and surname value displayed in the right field. Defaults to empty content.
/// - date: The date displayed below the signature fields. Defaults to `none`.
/// - position-caption: The caption displayed below the position field. Defaults to empty content.
///
/// Returns:
/// - A block containing the approval title, optional position field, signature/name fields, and date.
#let approval-block(
  title: [your title],
  position: [],
  name: [],
  date: none,
  position-caption: [],
) = block[
  #grid(
    columns: (1fr,),
    row-gutter: 1em,
    align: center,
  )[
    #title
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
      #field(value: [], caption: [(подпись)])
    ][
      #field(value: name, caption: [(инициалы, фамилия)])
    ]
  ][
    #block(width: 80%)[#print-date(date)]
  ]
]
#approval-block(
  title: [Утверждаю],
  position: [и. о. заведующего кафедрой],
  name: [Сычёв О. А.],
  date: none,
  position-caption: [должность],
)

#let default-title-settings(body) = {
  show: default-page
  show: default-text
  set par(
    leading: 0.53em,
    spacing: 0.53em * 1.2,
  )
  body
}

== `#main-title-sheet`
/// Creates the title page for a bachelor's explanatory note.
///
/// Parameters:
/// - topic: The work topic.
/// - author: The author record. Uses `full`, `group`, and optional `signature-date`.
/// - supervisor: The supervisor record. Uses `short` and optional `signature-date`.
/// - reviewer: The reviewer record. Uses `status`, `reverse-short`, and optional `date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - inspector: The norm controller record. Uses `short` and optional `signature-date`.
/// - consultants: Consultant records with `section` and `person` fields.
/// - document-code: The document code.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - faculty: The faculty name rendered in the labeled faculty field.
/// - department: The department name rendered in the labeled department field.
/// - work-kind: The work type shown between "к" and "на тему".
/// - direction: The field-of-study and profile description.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the full title-page layout.
#let main-title-sheet(
  // Work
  topic,
  // Persons
  author: none,
  supervisor: none,
  reviewer: none,
  approver: none,
  inspector: none,
  consultants: (
    (section: [], person: none),
    (section: [], person: none),
  ),
  // Page title parameters
  document-code: [],
  ministry: defaults.ministry,
  university: defaults.university,
  faculty: defaults.faculty,
  department: defaults.department.name,
  work-kind: [выпускной квалификационной работе бакалавра],
  direction: [
    09.03.04 -- Программная инженерия, \
    Разработка программно-информационных систем
  ],
  city: defaults.city,
  year: [#datetime.today().year()],
) = [
  #show: default-title-settings
  // To display all the information on one page, wrap in a grid
  #grid(
    columns: (1fr,),
    row-gutter: (1em, 1.5em, 2em, 1.5em, 1.5em, 3em),
  )[
    // University
    #align(center)[
      #ministry
      #university.rows.join("\n")
    ]
  ][
    // Faculty, Department
    #grid(
      columns: (1fr,),
      row-gutter: default-spacing,
    )[
      #labeled-field([Факультет], value: faculty.full)
    ][
      #labeled-field([Кафедра], value: department)
    ]
  ][
    // Reviewer, Approver
    #grid(
      columns: (1fr, 1fr),
      column-gutter: 0.2fr,
    )[
      #approval-block(
        title: [Согласовано],
        position: person-field(reviewer, "status"),
        name: person-field(reviewer, "reverse-short"),
        date: person-field(reviewer, "date", default: none),
        position-caption: [должность гл. специалиста предприятия],
      )
    ][
      #approval-block(
        title: [Утверждаю],
        position: person-field(approver, "status"),
        name: person-field(approver, "reverse-short"),
        date: person-field(approver, "date", default: none),
      )
    ]
  ][
    // Title
    #set par(spacing: default-spacing)
    #align(center)[#strong(upper([пояснительная записка]))]
    #grid(
      columns: 3,
      column-gutter: 6pt,
    )[ к ][ #field(value: work-kind, caption: [наименование вида работы]) ][ на тему ]

    // Topic
    #print-field-rows(
      ..makeRows(topic),
      field-align: center,
    )
  ][
    // Author
    #signature-row(
      [Автор],
      name: person-field(author, "full"),
      name-caption: [фамилия, имя, отчество],
      signature-date: person-field(author, "signature-date"),
    )
    // Service information about author and direction
    #grid(
      columns: 2,
      column-gutter: default-spacing,
      row-gutter: default-spacing,
    )[Обозначение][
      #block(width: 60%)[#field(
        value: document-code,
        caption: [код документа],
      )]
    ][Группа][
      #block(width: 40%)[#field(
        value: person-field(author, "group", default: warning([ПрИн-XXX])),
        caption: [шифр группы],
      )]
    ][Направление][
      #block(width: 90%)[#field(
        value: direction,
        caption: [код и наименование направления, наименование программы (профиля)],
      )]
    ]
    // Supervisor
    #signature-row(
      [Руководитель работы],
      name: person-field(supervisor, "short"),
      name-caption: [инициалы и фамилия],
      signature-date: person-field(supervisor, "signature-date"),
    )
  ][
    // Consultants
    Консультанты по разделам:
    #for consultant in consultants [
      #block(spacing: default-spacing)[
        #consultant-row(
          section: consultant.section,
          signature-date: person-field(consultant.person, "signature-date"),
          name: person-field(consultant.person, "short"),
        )
      ]
    ]
    // Inspector
    #signature-row(
      [Нормоконтролер:],
      name: person-field(inspector, "short"),
      name-caption: [инициалы и фамилия],
      signature-date: person-field(inspector, "signature-date"),
    )
  ][
    // City, year
    #align(center)[#city #year г.]
  ]
]
#main-title-sheet

== `#main-task-title-sheet`
/// Creates the task page for a bachelor's explanatory note.
///
/// Parameters:
/// - topic: The work topic.
/// - task-from-scientific-supervisor: Initial data issued by the scientific supervisor.
/// - contents-of-explanatory-note: Rows for the explanatory note contents.
/// - graphical-meterials: Rows for the graphic material list.
/// - author: The author record. Uses `full` and `group`.
/// - supervisor: The supervisor record. Uses `short` and optional `signature-date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - consultants: Consultant records with `section` and `person` fields.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - faculty: The faculty name rendered in the labeled faculty field.
/// - department-code: The department code shown in the student metadata row.
/// - work-kind: The work type shown between "к" and "на тему".
///
/// Returns:
/// - A configured `page` containing the explanatory note task layout.
#let main-task-title-sheet(
  // Work
  topic: none,
  task-from-scientific-supervisor: warning[Задание, выданное научным руководителем кафедры «ПОАС»],
  contents-of-explanatory-note: (),
  graphical-meterials: (),
  // Persons
  author: none,
  supervisor: none,
  approver: none,
  consultants: (
    (section: [], person: none),
    (section: [], person: none),
  ),
  // Page title parameters
  ministry: defaults.ministry,
  university: defaults.university,
  department: defaults.department.name,
  university-directive: (date: none, number: []),
  department-code: [10.19],
  work-kind: [выпускную квалификационную работу бакалавра],
) = [
  #show: default-title-settings
  #let delimiter = v(1.5em)

  // University
  #align(center)[
    #ministry \
    #university.rows.join("\n")
  ]
  #delimiter

  // Department
  #labeled-field([Кафедра], value: department)
  #delimiter

  // Approver
  #pad(left: 50%)[
    #grid(
      columns: (1fr, 1.5fr),
      row-gutter: default-spacing,
      column-gutter: 0.2fr,
      align: center,
    )[
      Утверждаю
    ][
      #person-field(approver, "status", default: warning([Должность]))
    ][
      #field(value: [], caption: [(подпись)])
    ][
      #field(
        value: person-field(approver, "reverse-short"),
        caption: [(инициалы, фамилия)],
      )
    ]
    #align(center)[#block(width: 80%)[
      #print-date(person-field(approver, "date", default: none))
    ]]
  ]
  #delimiter

  // Title
  #grid(
    columns: 1,
    row-gutter: default-spacing,
  )[
    #align(center)[#strong(upper([задание]))]
  ][
    #grid(
      columns: 3,
      column-gutter: 6pt,
    )[к][#field(value: work-kind, caption: [наименование вида работы])][на тему]
  ][
    // Author
    #labeled-field(
      [Студент],
      value: person-field(author, "full"),
      caption: [фамилия, имя, отчество],
    )
  ][
    // Department, Group
    #block(width: 90%)[
      #grid(
        columns: 4,
        column-gutter: default-spacing,
        row-gutter: default-spacing,
      )[ Код кафедры ][ #field(value: department-code) ][ Группа ][ #block(width: 80%)[#field(
        value: person-field(author, "group"),
      )]] ]
  ][
    // Topic
    #let topic-list = makeRows(topic, minRowsCount: 2)
    #labeled-field([Тема], value: topic-list.at(0))
    #for (i, item) in topic-list.enumerate() {
      if i != 0 {
        field(value: item)
      }
    }
  ][
    // Work approved
    #grid(
      columns: (auto, 3fr, auto, 1.1fr),
      column-gutter: (1.8em, 0.8em, 0pt),
    )[
      Утверждена приказом по университету
    ][
      #print-date(university-directive.date)
    ][
      №
    ][
      #field(value: university-directive.number, horizontal-inset: 0pt)
    ]
  ][
    // Date of submission of work
    #labeled-field([Срок представления готовой работы (проекта)], caption: [дата, подпись студента])
  ]

  // Task from the supervisor
  #print-field-rows(
    gutter: default-spacing,
    title: [Исходные данные для выполнения работы (проекта)],
    ..makeRows(task-from-scientific-supervisor, minRowsCount: 2),
  )

  // Contents of the explanatory note
  #print-field-rows(
    gutter: default-spacing,
    title: [Содержание основной части пояснительной записки],
    ..makeRows(contents-of-explanatory-note, minRowsCount: 10),
  )
  #delimiter

  // Graphic material
  #print-field-rows(
    gutter: default-spacing,
    numberic: true,
    title: align(center)[Перечень графического материала],
    ..makeRows(graphical-meterials, minRowsCount: 12),
  )
  #delimiter

  // Supervisor
  #signature-row(
    [Руководитель работы],
    name: person-field(supervisor, "short"),
    name-caption: [инициалы и фамилия],
    signature-date: person-field(supervisor, "signature-date"),
  )

  // Consultants
  Консультанты по разделам:
  #for consultant in consultants [
    #block(spacing: default-spacing)[
      #consultant-row(
        section: consultant.section,
        signature-date: person-field(consultant.person, "signature-date"),
        name: person-field(consultant.person, "short"),
      )
    ]
  ]
]

== `#template-subtitle-sheet`
/// Creates the internal title page for the explanatory note document.
///
/// Parameters:
/// - topic: The work topic.
/// - sheets-count: The number of sheets shown below the document code.
/// - author: The executor record. Uses `full`, `group`, and optional `date`.
/// - supervisor: The supervisor record. Uses `short` and optional `date`.
/// - approver: The approving person record. Uses `status`, `reverse-short`, and optional `date`.
/// - inspector: The norm controller record. Uses `short` and optional `date`.
/// - document-title: The main document title.
/// - document-code: The document code.
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - department: The department name shown below the university name.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the explanatory note title-page layout.
#let template-subtitle-sheet(
  // Work
  topic: [],
  sheets-count: [#context counter(page).final().first()],
  // Persons
  author: none,
  supervisor: none,
  approver: none,
  inspector: none,
  // Page title parameters
  document-title: warning([Зависит от типа документа]),
  document-code: warning([Код зависит от документа]),
  ministry: defaults.ministry,
  university: defaults.university,
  department: defaults.department.name,
  city: defaults.city,
  year: [#datetime.today().year()],
) = [
  #show: default-page
  #show: default-text
  #show: default-paragraph
  #let bigGutter = 2em
  #let gutter = 0.8em

  #grid(columns: 1, row-gutter: (3em, 1.5em, 2.5em, 1.5em, 2.5em, 1.5em, 1.5em, 3em))[
    // University
    #align(center)[
      #ministry \
      #university.rows.join("\n")
    ]
  ][
    // Department
    #align(center)[Кафедра «#department»]
  ][
    // Approver
    #align(right)[
      #block(width: 40%)[
        #upper([Утверждаю:])

        #person-field(approver, "status")

        #grid(columns: 2)[#field()][#person-field(approver, "reverse-short")]

        #print-date(person-field(approver, "date", default: none))
      ]
    ]
  ][
    // Topic
    #align(center)[
      #for row in makeRows(topic) {
        row
        parbreak()
      }
    ]
  ][
    // Title
    #align(center)[#upper(document-title)]
  ][
    // Document code
    #align(center)[#document-code]
  ][
    // Sheets count
    #align(center)[
      #context {
        let w = measure([Листов\_]).width + measure(sheets-count).width
        let minW = measure([Листов XX]).width
        block(width: calc.max(w, minW))[
          #labeled-field([Листов], value: sheets-count)
        ]
      }
    ]
  ][
    #grid(columns: (1fr, 1fr), column-gutter: 0.3fr, row-gutter: 1.5em)[
    ][
      // Supervisor
      Руководитель работы

      #if supervisor == none {
        field()
        field()
      } else {
        field(value: person-field(supervisor, "short"), align-value: left, horizontal-inset: 0pt)
        field()
      }

      #print-date(person-field(supervisor, "date", default: none))
    ][
      // Inspector
      Нормоконтролер

      #hide[#field()]
      #field(value: person-field(inspector, "short"), align-value: right, horizontal-inset: 0pt)
      #print-date(person-field(inspector, "date", default: none))
    ][
      // Author
      Исполнитель

      #grid(columns: 2)[студент группы][#field(value: person-field(author, "group"))]
      #field(value: person-field(author, "short"), align-value: left, horizontal-inset: 0pt)
      #print-date(person-field(author, "date", default: none))
    ]
  ][
    // City, year
    #align(center)[#city #year г.]
  ]
]

#let request-to-post-work(
  topic: [],
  author: none,
  supervisor: none,
  restrictions: none,
  date: [],
  reson: [которые имеют действительную или потенциальную коммерческую ценность в силу неизвестности их третьим лицам.],
  university: defaults.university,
  university-president: defaults.university-president,
  faculty: defaults.faculty,
  program: defaults.program,
  type-of-program: defaults.type-of-program,
) = {
  show: default-title-settings
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 20mm,
      right: 15mm,
    ),
    header: none,
    footer: none,
    numbering: none,
  )
  grid(columns: 1, row-gutter: (4em, 1em, 2em))[
    #pad(left: 35%)[
      Ректору #university.short

      #university-president

      #labeled-field(
        [от студента],
        value: person-field(author, "full-gen"),
        caption: [фамилия, имя, отчество полностью],
        align-value: left,
        horizontal-inset: 0pt,
      )
      #labeled-field([Факультет], value: lower(faculty.full), align-value: left, horizontal-inset: 0pt)
      #labeled-field([Направление], value: [#program.code #program.name], align-value: left, horizontal-inset: 0pt)
      #labeled-field([группа], value: person-field(author, "group"), align-value: left, horizontal-inset: 0pt)
      #labeled-field(
        [форма обучения],
        value: type-of-program,
        align-value: left,
        horizontal-inset: 0pt,
      )
    ]
  ][
    #align(center)[#upper([заявление])]
  ][
    #show: default-first-line-indent
    #show: default-paragraph
    Прошу Вас разместить написанную мною выпускную квалификационную
    работу бакалавра (далее ВКР) на тему
    // Topic
    #align(center)[
      #for (i, row) in makeRows(topic).enumerate() {
        let caption = if i == 0 [название работы] else []
        field(value: row, caption: caption)
      }
    ]
  ][
    #let degree = if type(supervisor) == dictionary and "degree" in supervisor [
      ~#person-field(supervisor, "degree")
    ] else []
    #labeled-field([Научный руководитель], value: person-field(supervisor, "full") + degree)
  ][
    в файловом хранилище ВолгГТУ, расположенном по адресу _http:\/\/dump.vstu.ru_
  ][
    #if restrictions == none [
      в полном объеме.
    ] else [
      за исключением разделов (страниц)

      #let rows-of-page-info = makeRows(restrictions.page)
      #let rows-of-content-info = makeRows(restrictions.content)

      #labeled-field([номера разделов (страниц)], value: rows-of-page-info.at(0, default: []))
      #for (i, row) in rows-of-page-info.enumerate() { if i != 0 { field(value: row) } }

      #labeled-field(
        [содержащие],
        value: rows-of-content-info.at(0, default: []),
        caption: [
          указать что именно: производственные; технические: экономические: организационные сведения;
          результаты интеллектуальной деятельности в научно-технической сфере;
          сведения о способах осуществления профессиональной деятельности
        ],
        align-value: left,
      )
      #for (i, row) in rows-of-content-info.enumerate() { if i != 0 { field(value: row, align-value: left) } }
    ]
  ][
    #if restrictions != none [#reson]
  ][
    #pad(left: 3em)[
      #grid(columns: (12em, 12em), row-gutter: 1.5em)[
        Дата
      ][#field(value: date)][
        Подпись
      ][#field()][
        Виза руководителя ВКР
      ][#field()]
    ]
  ]
}

#let declaration-of-professional-ethics(
  topic: [],
  author: none,
  supervisor: none,
  department-chair: none,
  date: [],
  university-president: defaults.university-president,
  university: defaults.university,
  faculty: defaults.faculty,
  program: defaults.program,
  type-of-program: defaults.type-of-program,
  plagiarism-detection-system: defaults.plagiarism-detection-system,
) = {
  show: default-title-settings
  set page(
    paper: "a4",
    margin: (
      top: 20mm,
      bottom: 20mm,
      left: 17.5mm,
      right: 15mm,
    ),
    header: none,
    footer: none,
    numbering: none,
  )
  grid(columns: 1, row-gutter: (4em, 1em, 2em))[
    #pad(left: 50%)[
      #person-field(department-chair, "status", default: [Зав. кафедрой]) ПОАС

      #person-field(department-chair, "short-dat", default: warning([Фамилия инициалы]))

      #labeled-field(
        [от студента группы],
        value: person-field(author, "group"),
        align-value: left,
        horizontal-inset: 0pt,
      )
      #field(value: person-field(author, "full-gen"))
      #field()
      #field()
    ]
  ][
    #align(center)[#upper([заявление])]
  ][
    #align(center)[#upper([
      о соблюдении профессиональной этики \
      при написании выпускной \
      квалификационной работы
    ])]
  ][
    #labeled-field([Я], value: person-field(author, "full"))
    #labeled-field([студент группы], value: person-field(author, "group"), value-width: 10em)
    обучающийся по направлению #program.code «#program.name», #faculty.short
    в #university.short, заявляю, что в моей ВКР на тему:

    // Topic
    #align(center)[
      #for row in makeRows(topic) {
        field(value: row)
      }
    ]
    #set par(justify: true)
    представленной в Государственную экзаменационную комиссию для публичной защиты,
    соблюдены правила профессиональной этики, не допускающие наличия плагиата,
    фальсификации данных и ложного цитирования при написании выпускных квалификационных работ.

    #show: default-first-line-indent
    Все прямые заимствования из печатных и электронных источников,
    а также ранее защищенных письменных работ, кандидатских и докторских диссертаций
    имеют соответствующие ссылки.

    Я ознакомлен с действующим в ВолгГТУ порядком проведения государственной итоговой аттестации,
    положением о порядке проверки ВКР на объем заимствования.
  ][
    #labeled-field([_подпись студента_], value: [(#person-field(author, "short"))], align-value: right)
    #pad(left: 25em)[#labeled-field([_дата_], value: date, value-width: 6em)]
    Работа представлена для проверки уникальности текста в системе «#plagiarism-detection-system».
  ][
    #labeled-field([_дата предоставления ВКР_], value: date, value-width: 6em)
    #labeled-field([_подпись руководителя ВКР_], value: [(#person-field(supervisor, "short"))], align-value: right)
  ]
}

#let opinion-of-scientific-supervisor(
  topic: [],
  about-work: [],
  successes: [],
  author: none,
  supervisor: none,
  department-chair: none,
  date: [],
  university-president: defaults.university-president,
  university: defaults.university,
  faculty: defaults.faculty,
  program: defaults.program,
  type-of-program: defaults.type-of-program,
  plagiarism-detection-system: defaults.plagiarism-detection-system,
) = {
  show: default-title-settings
  set par(justify: true)
  grid(columns: 1, row-gutter: 1em)[
    #pad(left: 45%)[
      Отзыв \
      на выпускную квалификационную работу бакалавра
      кафедры «Программное обеспечение автоматизированных систем»
      #field(value: person-field(author, "full"))
      #field()

      на тему: #underline(topic.join(" "))
    ]
  ][
    Содержание работы:
  ][
    #underline(about-work)
  ][
    #labeled-field([Заключение:], value: [работа завершена, поставленная цель достигнута.], align-value: left)
  ][
    Положительные результаты выпускной работы:

    #for row in makeRows(successes, minRowsCount: 3) { field(value: row, align-value: left) }
  ][
    #labeled-field([Рекомендуемая оценка], value: [Отлично (100 баллов)], align-value: left)
  ][
    #labeled-field(
      [Особо следует отметить:],
      value: [Планируется продолжение работы над этой темой.],
      align-value: left,
      horizontal-inset: 0pt,
    )
  ][
    #grid(columns: 2, column-gutter: 1em)[
    #labeled-field([Руководитель], value-width: 10em)
    ][
        #if supervisor != none and "degree" in supervisor [#supervisor.degree ]
        #person-field(supervisor, "short")
    ]
  ]
}
