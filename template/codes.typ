#import "defaults.typ"

/// Формирует словарь кодов обозначений документов бакалаврской ВКР.
///
/// Базовый код строится по шаблону: \
/// `<prefix>--<direction>--<department>--<number>--<year>`.
///
/// Коды частных документов получаются добавлением суффикса к базовому коду:
/// - `fqw` — базовый код;
/// - `explanatory-note` — пояснительная записка;
/// - `technical-assignment` — техническое задание;
/// - `system-programmers-guide` — руководство программиста.
///
/// ```typst
/// #let codes = create-codes(number: [42], year: [25])
/// #codes.explanatory-note  // «ВКРБ--09.03.04--10.19--42--25-81»
/// ```
///
/// - prefix (content): Префикс кода. По умолчанию `ВКРБ`.
/// - number (content): Порядковый номер работы по приказу. По умолчанию `XX`.
/// - direction (content): Код направления подготовки. По умолчанию `09.03.04`.
/// - department (content): Код кафедры. По умолчанию `10.19`.
/// - year (content): Год защиты (две последние цифры). По умолчанию — текущий год.
/// -> dictionary
#let create-codes(
  prefix: [ВКРБ],
  number: [XX],
  direction: defaults.program.code,
  department: defaults.department.code,
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

/// Коды документов ВКР с параметрами по умолчанию (направление 09.03.04, кафедра 10.19, номер XX).
/// -> dictionary
#let default-codes = create-codes()

#default-codes.fqw \
#default-codes.explanatory-note \
#default-codes.technical-assignment \
#default-codes.system-programmers-guide
