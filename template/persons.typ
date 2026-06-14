= Persons and document codes

== `#person`

/// Creates a person record with full and abbreviated name representations.
///
/// Parameters:
/// - full-name: An array [surname, first-name, patronymic] for a single case,
///   or a dictionary keyed by grammatical case names (e.g. nom, gen, dat).
/// - extras: Additional named fields to include in the resulting record.
///
/// Returns:
/// - A dictionary containing the source name parts, initials, formatted names,
///   and additional named fields.
#let person(full-name, ..extras) = {
  let make-fields(full-name, postfix: "") = {
    let surname = full-name.at(0)
    let first-name = full-name.at(1)
    let patronymic = full-name.at(2, default: none)

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

  let full-name-cases = if type(full-name) == array {
    make-fields(full-name) + make-fields(full-name, postfix: "-nom")
  } else if type(full-name) == dictionary {
    let result = (:)

    for (key, value) in full-name {
      let postfix = "-" + key

      if key == "nom" {
        result += make-fields(value)
      }

      result += make-fields(value, postfix: postfix)
    }

    result
  } else {
    panic("full-name must be array or dictionary")
  }

  full-name-cases + extras.named()
}

#person(("Иванов", "Иван", "Иванович"))

== `#create-codes`

/// Creates document designation codes for a bachelor's final qualification work.
///
/// Parameters:
/// - number: The serial number of the work from the order. Defaults to `XX`.
/// - direction: The direction code. Defaults to `09.03.04`.
/// - department: The department code. Defaults to `10.19`.
/// - year: The completion year. Defaults to the current year.
///
/// Returns:
/// - A dictionary containing the base code in `fqw` and the derived codes in
///   `explanatory-note`, `technical-assignment`, and `system-programmers-guide`.
#let create-codes(
  number: [XX],
  direction: [09.03.04],
  department: [10.19],
  year: [#calc.rem(datetime.today().year(), 100)],
) = {
  let prefix = [ВКРБ]
  let explanatory-note-code = [81]
  let technical-assignment-code = [91]
  let system-programmers-guide-code = [32]
  let base = [#(prefix)--#(direction)--#(department)--#(number)--#(year)]
  (
    fqw: base,
    explanatory-note: [#(base)-#(explanatory-note-code)],
    technical-assignment: [#(base)-#(technical-assignment-code)],
    system-programmers-guide: [#(base)-#(system-programmers-guide-code)],
  )
}

#let default-codes = create-codes()

#default-codes.fqw \
#default-codes.explanatory-note \
#default-codes.technical-assignment \
#default-codes.system-programmers-guide
