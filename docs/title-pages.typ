#import "../template/title-pages.typ": (
  fqw-declaration-of-professional-ethics, fqw-main-task-title-sheet, fqw-main-title-sheet, fqw-request-to-post-work,
  fqw-template-subtitle-sheet, fqw-opinion-of-scientific-supervisor,
)
#import "../template/fqw.typ": create-codes, person

#let codes = create-codes(number: [09])

#let author = person(
  (
    nom: ("Коломойцев", "Илья", "Сергеевич"),
    gen: ("Коломойцева", "Ильи", "Сергеевича"),
    dat: ("Коломойцеву", "Илье", "Сергеевичу"),
    acc: ("Коломойцева", "Илью", "Сергеевича"),
    ins: ("Коломойцевым", "Ильёй", "Сергеевичем"),
    prep: ("Коломойцеве", "Илье", "Сергеевиче"),
  ),
  group: [ПрИн-466],
)

#let scientific-supervisor = person(
  (
    nom: ("Матюшечкин", "Дмитрий", "Сергеевич"),
    gen: ("Матюшечкина", "Дмитрия", "Сергеевича"),
    dat: ("Матюшечкину", "Дмитрию", "Сергеевичу"),
    acc: ("Матюшечкина", "Дмитрия", "Сергеевича"),
    ins: ("Матюшечкиным", "Дмитрием", "Сергеевичем"),
    prep: ("Матюшечкине", "Дмитрии", "Сергеевиче"),
  ),
  degree: [к.т.н.],
)

#let approver = person(
  (
    nom: ("Сычёв", "Олег", "Александрович"),
    gen: ("Сычёва", "Олега", "Александровича"),
    dat: ("Сычёву", "Олегу", "Александровичу"),
    acc: ("Сычёва", "Олега", "Александровича"),
    ins: ("Сычёвым", "Олегом", "Александровичем"),
    prep: ("Сычёве", "Олеге", "Александровиче"),
  ),
  status: [и. о. зав. кафедрой],
)

#let inspector = person((
  nom: ("Кузнецова", "Агнесса", "Сергеевна"),
  gen: ("Кузнецовой", "Агнессы", "Сергеевны"),
  dat: ("Кузнецовой", "Агнессе", "Сергеевне"),
  acc: ("Кузнецову", "Агнессу", "Сергеевну"),
  ins: ("Кузнецовой", "Агнессой", "Сергеевной"),
  prep: ("Кузнецовой", "Агнессе", "Сергеевне"),
))

#let university-directive = (date: datetime(year: 2025, month: 9, day: 5), number: [1203-ст])
#let submission-date = datetime(year: 2026, month: 6, day: 8)
#let topic-of-work = (
  [Разработка компьютерной модели программно-аппаратного],
  [приёмопередатчика для его виртуальных испытаний],
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
  contents-of-explanatory-note: (
    [1. Анализ современного состояния вопроса],
    [2. Предлагаемое решение],
    [Выводы],
    [3. Проектирование и разработка модуля гидроакустической связи],
    [Выводы],
    [4. Результаты разработки и апробация],
    [Выводы],
    [Заключение],
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
  approver: approver + (date: submission-date),
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

#let request-to-post-work = fqw-request-to-post-work(
  topic: topic-of-work,
  author: author,
  supervisor: scientific-supervisor,
  date: submission-date.display("[day].[month].[year]"),
)

#request-to-post-work

#let declaration-of-professional-ethics = fqw-declaration-of-professional-ethics(
  topic: topic-of-work,
  author: author,
  supervisor: scientific-supervisor,
  department-chair: approver,
  date: submission-date.display("[day].[month].[year]"),
)

#declaration-of-professional-ethics

#let opinion-of-scientific-supervisor = fqw-opinion-of-scientific-supervisor(
  topic: topic-of-work,
  author: author,
  supervisor: scientific-supervisor,
  about-work: [
    Работа посвящена разработке модели гидроакустического приёмопередатчика,
    интегрированной в сетевой симулятор Ns-3.
    В работе проведён комплексный анализ бизнес-процессов разработки
    гидроакустических систем и сравнение существующих решений для моделирования.
    Предложена модифицированная V-образная модель разработки с
    интеграцией компьютерного моделирования на всех этапах проектирования.
    На основе анализа предметной области разработаны и формализованы модели
    гидроакустического канала связи и программно-аппаратного приёмопередатчика,
    включающие учёт физических эффектов и критерий успешного приёма на основе SINR.
    Реализован программный модуль на языке C++ с модульной архитектурой,
    позволяющей расширять и комбинировать отдельные компоненты.
  ],
  successes: (
    [1. Разработан программный модуль гидроакустической связи для],
    [сетевого симулятора Ns-3, реализующий формальные модели канала и],
    [приёмопередатчика],
    [2. Спроектирована архитектура с иерархией абстрактных классов для],
    [моделей канала, потерь при распространении, приёмопередатчика и],
    [интерференции, позволяющая заменять и комбинировать компоненты],
    [3. Реализованы модели физического уровня гидроакустического],
    [приёмопередатчика в полудуплексном режиме и однолучевая модель],
    [канала с расчётом задержек и потерь сигнала],
    [4. Проведена валидация корректности физических зависимостей на],
    [паспортных данных промышленных гидроакустических модемов],
  ),
)

#opinion-of-scientific-supervisor