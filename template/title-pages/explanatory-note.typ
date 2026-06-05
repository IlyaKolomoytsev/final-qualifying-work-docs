#import "components.typ": *

= Explanatory note title pages

== `#approval-block-title`
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
#let approval-block-title(
  title: [your title],
  position: [],
  signature-date: [],
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
      #field(value: signature-date, caption: [(подпись)])
    ][
      #field(value: name, caption: [(инициалы, фамилия)])
    ]
  ][
    #block(width: 80%)[#print-date(date)]
  ]
]
#approval-block-title(
  title: [Утверждаю],
  position: [и. о. заведующего кафедрой],
  signature-date: [15.05.2026],
  name: [Сычёв О. А.],
  date: none,
  position-caption: [должность],
)

== `#approval-block-task`

#let approval-block-task(
  title: [Утверждаю],
  position: [и. о. зав кафедрой],
  signature-date: [],
  name: [],
  date: none,
  position-caption: [],
) = grid(
  columns: (1fr,),
  row-gutter: 1em,
  align: center,
)[
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 1em,
    column-gutter: 1em,
    align: center,
  )[
    #title
  ][
    #position
  ][
    #field(value: signature-date, caption: [(подпись)])
  ][
    #field(value: name, caption: [(инициалы, фамилия)])
  ]
][
  #block(width: 80%)[#print-date(date)]
]

#approval-block-task()

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
  document-title: [пояснительная записка],
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
  year: [#datetime.today().year()],
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
        #approval-block-title(
          title: [Согласовано],
          position: agreement-position,
          name: agreement-name,
          position-caption: [должность гл. специалиста предприятия],
        )
      ][
        #approval-block-title(
          title: [Утверждаю],
          position: approval-position,
          signature-date: approval-signature-date,
          name: approval-name,
          date: approval-date,
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
        #print-field-rows(
          gutter: gutter,
          ..makeRows(topic),
        )
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

== `#explanatory-note-task-page`
/// Creates the task page for a bachelor's explanatory note.
///
/// Parameters:
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - faculty: The faculty name rendered in the labeled faculty field.
/// - department-code: The department code shown in the student metadata row.
/// - document-title: The main document title.
/// - work-kind: The work type shown between "к" and "на тему".
/// - topic: The work topic.
/// - author: The author's full name.
/// - task-from-scientific-supervisor: Initial data issued by the scientific supervisor.
/// - contents-of-explanatory-note: Rows for the explanatory note contents and graphic material sections.
/// - document-code: The document code.
/// - group: The student group code.
/// - supervisor: The supervisor's name.
/// - supervisor-signature-date: The supervisor's signature and signing date.
/// - consultants: A sequence of consultant records with `section`, `signature-date`, and `name` fields.
///
/// Returns:
/// - A configured `page` containing the explanatory note task layout.
#let explanatory-note-task-page(
  ministry: [Министерство науки и высшего образования Российской Федерации],
  university: [
    Федеральное государственное бюджетное образовательное учреждение \
    высшего образования \
    «Волгоградский государственный технический университет»
  ],
  faculty: [Электроники и вычислительной техники],
  department-code: [10.19],
  document-title: [задание],
  work-kind: [выпускную квалификационную работу бакалавра],
  topic: none,
  author: [],
  task-from-scientific-supervisor: warning[Задание, выданное научным руководителем кафедры «ПОАС»],
  contents-of-explanatory-note: (),
  document-code: [],
  group: [],
  supervisor: [],
  supervisor-signature-date: [],
  consultants: (
    (section: [], signature-date: [], name: []),
    (section: [], signature-date: [], name: []),
  ),
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
  #let bigGutter = 2em
  #align(center)[
    #ministry \
    #university
  ]

  #v(bigGutter)
  #labeled-field([Факультет], value: faculty)

  #v(bigGutter)

  #pad(left: 50%)[
    #approval-block-task()
  ]

  #v(bigGutter)

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
    #labeled-field(
      [Студент],
      value: author,
      caption: [фамилия, имя, отчество],
    )
  ][
    #block(width: 90%)[
      #grid(
        columns: 4,
        column-gutter: gutter,
        row-gutter: gutter,
      )[
        Код кафедры
      ][
        #field(value: department-code)
      ][
        Группа
      ][
        #block(width: 80%)[#field(value: group)]
      ]]
  ][
    #let topic-list = ([],)
    #if type(topic) == array {
      topic-list = topic
    } else if type(topic) == content {
      topic-list = (topic,)
    }
    #labeled-field([Тема], value: topic-list.at(0))
    #for (i, item) in topic-list.enumerate() {
      if i != 0 {
        h(gutter)
        field(value: item)
      }
    }
    #if topic-list.len() < 2 {
      h(gutter)
      field()
    }
  ][
    #grid(
      columns: (5fr, 3fr, 1fr),
      column-gutter: gutter,
    )[
      Утверждена приказом по университету
    ][
      #print-date(none)
    ][
      #field()
    ]
  ][
    #labeled-field([Срок представления готовой работы (проекта)], caption: [(дата, подпись студента)])
  ]

  #v(bigGutter)

  #print-field-rows(
    gutter: gutter,
    title: [Исходные данные для выполнения работы (проекта)],
    ..makeRows(task-from-scientific-supervisor, minRowsCount: 2),
  )

  #v(bigGutter)

  #print-field-rows(
    gutter: gutter,
    title: [Содержание основной части пояснительной записки],
    ..makeRows(contents-of-explanatory-note, minRowsCount: 15),
  )

  #v(bigGutter)

  #print-field-rows(
    gutter: gutter,
    numberic: true,
    title: align(center)[Перечень графического материала],
    ..makeRows(contents-of-explanatory-note, minRowsCount: 12),
  )

  #v(bigGutter)

  #signature-row(
    [Руководитель работы],
    signature-date: supervisor-signature-date,
    name: supervisor,
    name-caption: [инициалы и фамилия],
  )

  #v(gutter)

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
]

== `#explanatory-note-title-page2`
/// Creates the internal title page for the explanatory note document.
///
/// Parameters:
/// - ministry: The ministry name shown at the top of the page.
/// - university: The university name shown below the ministry.
/// - department: The department name shown below the university name.
/// - approval-position: The position shown in the "Утверждаю" block.
/// - approval-signature-date: The signature value shown before the approver name.
/// - approval-name: The name shown in the "Утверждаю" block.
/// - approval-date: A `datetime` value or `none` for the date shown in the "Утверждаю" block.
/// - document-title: The main document title.
/// - topic: The work topic.
/// - document-code: The document code.
/// - sheets-count: The number of sheets shown below the document code.
/// - group: The student group code.
/// - supervisor: The supervisor's name.
/// - supervisor-signature-date: A `datetime` value or `none` for the supervisor signing date.
/// - norm-controller: The norm controller's name.
/// - norm-controller-signature-date: A `datetime` value or `none` for the norm controller signing date.
/// - author: The executor's full name.
/// - author-signature-date: A `datetime` value or `none` for the executor signing date.
/// - city: The city shown at the bottom of the page.
/// - year: The year shown at the bottom of the page.
///
/// Returns:
/// - A configured `page` containing the explanatory note title-page layout.
#let explanatory-note-title-page2(
  ministry: [Министерство науки и высшего образования Российской Федерации],
  university: [
    Федеральное государственное бюджетное образовательное учреждение \
    высшего образования \
    «Волгоградский государственный технический университет»
  ],
  department: [Программное обеспечение автоматизированных систем],
  approval-position: [и. о. зав. кафедрой],
  approval-signature-date: [],
  approval-name: [О. А. Сычев],
  approval-date: none,
  document-title: [пояснительная записка],
  topic: [],
  document-code: [],
  sheets-count: [],
  group: [],
  supervisor: [],
  supervisor-signature-date: none,
  norm-controller: [Кузнецова А.С.],
  norm-controller-signature-date: none,
  author: [],
  author-signature-date: none,
  city: [Волгоград],
  year: [#datetime.today().year()],
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
    leading: 0.8em,
    spacing: 0.8em,
  )
  #let bigGutter = 2em
  #let gutter = 0.8em

  #align(center)[
    #ministry \
    #university
  ]

  #v(bigGutter)

  #align(center)[Кафедра «#department»]

  #v(bigGutter)

  #align(right)[
    #block(width: 40%)[
      #upper([Утверждаю:])

      #approval-position

      #grid(columns: 2)[#field(value: approval-signature-date)][#approval-name]

      #print-date(approval-date)
    ]
  ]

  #v(bigGutter)

  #align(center)[
    #for row in makeRows(topic) {
      row
    }
  ]

  #v(bigGutter)

  #align(center)[#upper(document-title)]

  #v(bigGutter)

  #align(center)[#document-code]

  #v(bigGutter)

  #align(center)[Листов #sheets-count]

  #v(bigGutter)

  #grid(columns: (1fr, 1fr), gutter: bigGutter,)[
  ][
    Руководитель работы

    #if supervisor == none {
      field()
      field()
    } else {
      field(value: supervisor)
      field()
    }

    #block(width: 80%)[#print-date(supervisor-signature-date)]
  ][
    Нормоконтролер

    #grid(columns: 2)[#field()][#norm-controller]
    #field()#block(width: 80%)[#print-date(norm-controller-signature-date)]
  ][
    Исполнитель

    студент группы #group
    #field(value: author)
    #print-date(author-signature-date)
  ]

  #v(bigGutter)

  #align(center)[#city #year г.]
]
