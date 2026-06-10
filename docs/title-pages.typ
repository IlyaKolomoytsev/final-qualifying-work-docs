#import "../template/title-pages.typ": fqw-main-task-title-sheet, fqw-main-title-sheet, fqw-template-subtitle-sheet
#import "../template/fqw.typ": create-codes, person

#let codes = create-codes(number: [09])

#let author = person("Коломойцев", "Илья", "Сергеевич", group: [ПрИн-466])
#let scientific-supervisor = person("Матюшечкин", "Дмитрий", "Сергеевич", degree: [к.т.н.])
#let approver = person("Сычёв", "Олег", "Александрович", status: [и. о. зав. кафедрой])
#let inspector = person("Кузнецова", "Агнесса", "Сергеевна")
#let university-directive = (date: datetime(year: 2025, month: 9, day: 5), number: [1203-ст])
#let submission-date = datetime(year: 2026, month: 6, day: 8)
#let topic-of-work = (
  [Разработка компьютерной модели программно-аппаратного],
  [гидроакустического приёмопередатчика для его виртуальных испытаний],
)

#let main-title = fqw-main-title-sheet(
  topic-of-work,
  author: author,
  supervisor: scientific-supervisor,
  inspector: inspector,
  approver: approver + (date: submission-date),
  document-code: codes.fqw,
)

#main-title

#let task-title = fqw-main-task-title-sheet(
  topic: topic-of-work,
  author: author,
  approver: approver + (date: university-directive.date),
  supervisor: scientific-supervisor,
  task-from-scientific-supervisor: (
    [Задание, выданное научным руководителем кафедры «ПОАС»:],
    [разработать компьютерную модель программно-аппаратного],
    [гидроакустического приёмопередатчика и гидроакустического],
    [канала связи, интегрированные в сетевой симулятор Ns-3,],
    [с учётом физических эффектов гидроакустической среды и провести],
    [валидацию модели на данных промышленных гидроакустических],
    [модемов.],
  ),
  university-directive: university-directive,
)

#task-title

#let subtitle-template(
  document-title,
  document-code: [],
  sheets-count: [#context counter(page).final().first()],
) = fqw-template-subtitle-sheet(
  topic: topic-of-work,
  sheets-count: sheets-count,
  author: author + (date: submission-date),
  supervisor: scientific-supervisor + (date: submission-date),
  approver: approver,
  inspector: inspector + (date: submission-date),
  document-title: document-title,
  document-code: document-code,
)

#let explanatory-note-title = subtitle-template(
  [Пояснительная записка],
  document-code: codes.explanatory-note,
)

#explanatory-note-title

#let technical-assignment-title = subtitle-template(
  [Техническое задание],
  document-code: codes.technical-assignment,
)

#technical-assignment-title

#let system-programmers-guide-title = subtitle-template(
  [Руководство системного программиста],
  document-code: codes.system-programmers-guide,
)

#system-programmers-guide-title

#let approval-sheet-title = subtitle-template(
  [Лист утверждения],
  document-code: [А.В.00001-01 91 01-1-ЛУ],
)

#approval-sheet-title
