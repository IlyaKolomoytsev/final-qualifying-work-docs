/// Создаёт словарь полей имени для одного падежа.
///
/// Принимает массив `[фамилия, имя, отчество?]` и возвращает словарь
/// с ключами:
/// - `surname`,
/// - `first-name`,
/// - `patronymic`,
/// - `initials`,
/// - `full`,
/// - `short`,
/// - `reverse-short`.
/// К каждому ключу добавляется `postfix`.
///
/// - full-name (array): Массив вида `("Иванов", "Иван", "Иванович")`.
///   Отчество опционально; без него `initials` содержит только первую букву имени.
/// - postfix (str): Суффикс, добавляемый к каждому ключу словаря.
///   Пустая строка оставляет ключи без изменений.
/// -> dictionary
#let _make-fields(full-name, postfix: "") = {
  let surname = full-name.at(0)
  let first-name = full-name.at(1)
  let patronymic = full-name.at(2, default: none)

  // Инициалы: «И.» без отчества или «И. О.» при наличии отчества.
  let first-initial = first-name.at(0)
  let initials = if patronymic == none {
    [#first-initial.]
  } else {
    [#first-initial. #patronymic.at(0).]
  }

  let full = if patronymic == none {
    [#surname #first-name]
  } else {
    [#surname #first-name #patronymic]
  }

  let fields = (
    "surname" + postfix: surname,
    "first-name" + postfix: first-name,
    "patronymic" + postfix: patronymic,
    "initials" + postfix: initials,
    "full" + postfix: full,
    "short" + postfix: [#surname #initials],
    "reverse-short" + postfix: [#initials #surname],
  )

  fields
}

/// Создаёт запись о персоне с полями имени и дополнительными атрибутами.
///
/// Аргумент `full-name` может быть:
/// - _массивом_ `("Фамилия", "Имя", "Отчество")` — тогда поля генерируются
///   один раз и дублируются с постфиксом `-nom` (для единообразия при смешанном использовании);
/// - _словарём_ `(nom: (...), gen: (...), ...)` — тогда поля генерируются
///   для каждого падежа с постфиксом `-<падеж>`; поля именительного падежа (`nom`)
///   доступны также без постфикса.
///
/// Дополнительные именованные аргументы (`..extras`) добавляются в итоговый словарь без изменений.
///
/// ```typst
/// #let supervisor = person(
///   (
///     nom: ("Иванов", "Иван", "Иванович"),
///     gen: ("Иванова", "Ивана", "Ивановича")
///   ),
///   role: "научный руководитель",
/// )
/// #supervisor.short        // «Иванов И. И.»
/// #supervisor.short-gen    // «Иванова И. И.»
/// #supervisor.role         // «научный руководитель»
/// ```
///
/// - full-name (array, dictionary): Имя персоны — массив для одного падежа
///   или словарь падежей.
/// - ..extras (arguments): Произвольные именованные поля (например, `role`, `degree`),
///   добавляемые в результирующий словарь.
/// -> dictionary
#let person(full-name, ..extras) = {
  // Для массива: поля без постфикса + копия с постфиксом -nom.
  // Для словаря: итерация по падежам; именительный дублируется без постфикса.
  let full-name-cases = if type(full-name) == array {
    _make-fields(full-name) + _make-fields(full-name, postfix: "-nom")
  } else if type(full-name) == dictionary {
    let result = (:)

    for (key, value) in full-name {
      let postfix = "-" + key

      // Поля именительного падежа доступны также без постфикса.
      if key == "nom" {
        result += _make-fields(value)
      }

      result += _make-fields(value, postfix: postfix)
    }

    result
  } else {
    panic("full-name must be array or dictionary")
  }

  full-name-cases + extras.named()
}
