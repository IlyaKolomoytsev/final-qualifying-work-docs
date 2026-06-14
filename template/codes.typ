/// Формирует коды обозначений документов для бакалаврской ВКР.
///
/// Базовый код строится по шаблону
/// `ВКРБ--<direction>--<department>--<number>--<year>`.
/// Коды частных документов получаются добавлением суффикса к базовому коду.
///
/// - number (content): Порядковый номер работы по приказу. По умолчанию `XX`.
/// - direction (content): Код направления подготовки. По умолчанию `09.03.04`.
/// - department (content): Код кафедры. По умолчанию `10.19`.
/// - year (content): Год защиты (две последние цифры). По умолчанию — текущий год.
/// -> dictionary
#let create-codes(
  prefix: [ВКРБ],
  number: [XX],
  direction: [09.03.04],
  department: [10.19],
  year: [#calc.rem(datetime.today().year(), 100)],
) = {
  let explanatory-note-code = [81]
  let technical-assignment-code = [91]
  let system-programmers-guide-code = [32]
  // Базовый код, от которого производятся все остальные.
  let base = [#(prefix)--#(direction)--#(department)--#(number)--#(year)]
  (
    fqw: base,
    explanatory-note: [#(base)-#(explanatory-note-code)],
    technical-assignment: [#(base)-#(technical-assignment-code)],
    system-programmers-guide: [#(base)-#(system-programmers-guide-code)],
  )
}

/// Коды документов ВКР со значениями параметров по умолчанию.
/// -> dictionary
#let default-codes = create-codes()

#default-codes.fqw \
#default-codes.explanatory-note \
#default-codes.technical-assignment \
#default-codes.system-programmers-guide
