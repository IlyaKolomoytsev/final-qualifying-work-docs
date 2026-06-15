/// Core
///
/// Базовые константы ГОСТ, вспомогательные функции стилизации,
/// нумерации разделов/приложений и перекрёстных ссылок для документов ВКР.

#import "utils.typ": warning
#import "codes.typ": default-codes
#import "appendix.typ": *

= Default values

/// Размер шрифта в em для расчёта интервалов.
///
/// _P.S. Я так понял что 1.25em это фактический размер строки в высоту. Но это не точно. Я так числа *подогнал*._
///
/// -> relative
#let fontsize-in-em = 1.25em

/// Межстрочный интервал (одинарный по ГОСТ).
///
/// _P.S. Тут должен быть полуторный отсутп, но у меня подгоном получилось 1.06em. почему? не знаю. *Подогнал.*..._
///
/// -> relative
#let leading = 1.06em

/// Суммарный базовый интервал: размер шрифта плюс межстрочный интервал.
///
/// Используется как единица отступов вокруг заголовков и блоков.
///
/// -> relative
#let baseline = fontsize-in-em + leading

/// Отступ первой строки абзаца по ГОСТ — 1,25 см.
///
/// -> length
#let first-line-indent = 1.25cm
/// Отступ тела элемента списка от маркера.
///
/// -> relative
#let list-body-indent = 1.5em // На глаз понравилось такое значение)

/// Базовые параметры страницы A4 без колонтитулов и нумерации.
///
/// -> dictionary
#let page-a4 = (
  paper: "a4",
  header: none,
  footer: none,
  numbering: none,
)

/// Параметры страницы A4 с полями ГОСТ: левое 30 мм, правое 15 мм, верх/низ 20 мм.
///
/// -> dictionary
#let gost-page = (
  ..page-a4,
  margin: (top: 20mm, right: 15mm, bottom: 20mm, left: 30mm),
)

/// Параметры шрифта по ГОСТ: Times New Roman 14 пт, чёрный, без переносов.
/// -> dictionary
#let gost-text = (
  lang: "ru",
  font: "Times New Roman",
  size: 14pt,
  fill: black,
  weight: "regular",
  hyphenate: false,
)

/// Параметры абзаца по ГОСТ: выравнивание по ширине, одинарный интервал.
/// -> dictionary
#let gost-paragraph = (
  justify: true,
  leading: leading,
  spacing: leading,
)

/// Количество уровней нумерации в номере раздела по умолчанию (2 → «1.1»).
/// -> state
#let default-numbering = state("default-numbering", 2)

= FQW functions

== default show functions

/// Применяет параметры страницы ГОСТ ко всему содержимому.
///
/// - body (content): Содержимое документа.
/// -> content
#let default-page(body) = {
  set page(..gost-page)
  body
}

/// Применяет параметры шрифта ГОСТ ко всему содержимому.
///
/// - body (content): Содержимое документа.
/// -> content
#let default-text(body) = {
  set text(..gost-text)
  body
}

/// Применяет параметры абзаца ГОСТ ко всему содержимому.
///
/// - body (content): Содержимое документа.
/// -> content
#let default-paragraph(body) = {
  set par(..gost-paragraph)
  body
}

/// Применяет отступ первой строки ко всем абзацам, включая первый.
///
/// - body (content): Содержимое документа.
/// -> content
#let default-first-line-indent(body) = {
  set par(first-line-indent: (amount: first-line-indent, all: true))
  body
}

/// Применяет все параметры ГОСТ одновременно: страница, шрифт, абзац, отступ первой строки.
///
/// - body (content): Содержимое документа.
/// -> content
#let default(body) = {
  set page(..gost-page)
  set text(..gost-text)
  set par(..gost-paragraph)
  set par(first-line-indent: (amount: first-line-indent, all: true))
  body
}

== numbering functions

/// Возвращает массив компонентов текущего номера раздела.
///
/// В режиме *приложений* использует счётчик `"appendix"`,
/// в *обычном* режиме — счётчик `heading`.
///
/// - loc (location, label, auto): Позиция в документе для чтения счётчиков.
///   `auto` читает текущее значение через `.get()`.
/// - numbering-size (int, auto): Число уровней в возвращаемом массиве.
///   `auto` — возвращает все уровни до последнего ненулевого включительно,
///   замыкающие нули отбрасываются.
/// -> array
#let section-counts(loc: auto, numbering-size: auto) = {
  let read(c) = if loc == auto { c.get() } else { c.at(loc) }
  let arr = if read(appendix-state) {
    appendix-numbers(read(counter("appendix")))
  } else {
    read(counter(heading))
  }
  if numbering-size == auto {
    // Возвращаем все уровни до последнего ненулевого, замыкающие нули отбрасываем.
    let last-nonzero = -1
    for (i, v) in arr.enumerate() {
      if v != 0 { last-nonzero = i }
    }
    if last-nonzero == -1 { () } else { arr.slice(0, last-nonzero + 1) }
  } else {
    // Возвращаем массив и numbering-size элементов
    arr.slice(0, calc.min(numbering-size, arr.len()))
  }
}

/// Форматирует полный номер элемента раздела, добавляя `n` к текущему префиксу.
///
/// Например, при `section-counts(1) == (1, 2)` и `n = 3` вернёт `"1.2.3"`.
///
/// - n (int): Порядковый номер элемента внутри текущего раздела.
/// - numbering-size (int, auto): Общее число уровней итогового номера.
///   `auto` — из `default-numbering`.
/// -> content
#let section-numbering(n, numbering-size: auto) = context {
  let prefix-size = if numbering-size == auto {
    default-numbering.get() - 1
  } else {
    numbering-size - 1
  }
  (section-counts(numbering-size: prefix-size) + (n,)).map(str).join(".")
}

== ref function

/// Формирует строку перекрёстной ссылки для произвольного счётчика.
///
/// Берёт префикс номера раздела в позиции `label`, добавляет значение
/// счётчика `counter-name` в той же позиции и возвращает строку вида `«1.2»`
/// или `«А.1»` (в режиме приложений).
///
/// - label (label): Метка целевого элемента.
/// - counter-name (selector): Селектор счётчика (например, `math.equation`).
/// - numbering-size (int, auto): Общее число уровней итогового номера.
///   `auto` — из `default-numbering`.
/// -> content
#let cross-ref(label, counter-name, numbering-size) = context {
  let prefix-size = if numbering-size == auto {
    default-numbering.get() - 1
  } else if type(numbering-size) == int {
    numbering-size - 1
  } else {
    panic("invalid numbering-size type: " + repr(type(numbering-size)))
  }
  let prefix = section-counts(loc: label, numbering-size: prefix-size)
  (prefix + (counter(counter-name).at(label).first(),)).map(str).join(".")
}

/// Формирует номер раздела в позиции метки, отбрасывая замыкающие нули.
///
/// Используется для ссылок вида «раздел 1.2», когда глубина раздела заранее неизвестна.
///
/// - label (label): Метка целевого заголовка.
/// -> content
#let section-ref(label) = context {
  section-counts(loc: label, numbering-size: auto).map(str).join(".")
}

/// Перекрёстная ссылка на уравнение по метке.
///
/// - label (label): Метка уравнения.
/// - numbering-size (int, auto): Число уровней нумерации.
/// -> content
#let eq-ref(label, numbering-size: auto) = cross-ref(
  label,
  math.equation,
  numbering-size,
)

/// Перекрёстная ссылка на рисунок по метке.
///
/// - label (label): Метка рисунка.
/// - numbering-size (int, auto): Число уровней нумерации.
/// -> content
#let figure-ref(label, numbering-size: auto) = cross-ref(
  label,
  figure.where(kind: image),
  numbering-size,
)

/// Перекрёстная ссылка на таблицу по метке.
///
/// - label (label): Метка таблицы.
/// - numbering-size (int, auto): Число уровней нумерации.
/// -> content
#let table-ref(label, numbering-size: auto) = cross-ref(
  label,
  figure.where(kind: table),
  numbering-size,
)

== document-setup

/// Полная настройка документа ВКР: колонтитулы, нумерация заголовков,
/// уравнений, рисунков, таблиц, стиль списков и ссылок.
///
/// Применяется через `#show: document-setup` или
/// `#show: document-setup.with(document-code: [...])`.
///
/// ```typst
/// #show: document-setup.with(document-code: codes.explanatory-note)
/// ```
///
/// - body (content): Содержимое документа.
/// - document-code (content): Код документа для верхнего колонтитула.
///   По умолчанию — `default-codes.fqw` с предупреждением об использовании заглушки.
/// -> content
#let document-setup(body, document-code: warning[#default-codes.fqw]) = [
  #let in-header = state("in-header", false)
  #show: default

  // header and footer settings
  #set page(
    header: align(center)[#document-code],
    footer: context align(center)[#counter(page).display("1")],
  )

  // headers settings
  #show heading: it => {
    // update counters
    if it.level == 1 {
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }

    // write header
    set text(..gost-text)
    set par(..gost-paragraph)
    set par(first-line-indent: (amount: first-line-indent, all: true))

    let above = if in-header.get() { baseline } else { baseline * 2 }

    block(
      above: above,
      below: baseline,
      sticky: true,
    )[
      #par[
        #if it.numbering != none {
          context if appendix-state.get() {
            counter("appendix").step(level: it.level)
          }
          section-counts().map(str).join(".")
        }
        #it.body
      ]
    ]

    in-header.update(true)
  }

  #show par: it => {
    if in-header.get() { v(baseline * 2, weak: true) }
    it
    in-header.update(false)
  }

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
