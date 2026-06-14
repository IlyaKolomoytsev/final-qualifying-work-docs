#import "../core.typ": baseline, first-line-indent

= Equation helpers

== `#equation-list`

/// Renders a group of equations separated by commas, with optional per-equation labels.
///
/// Parameters:
/// - equations: An array where each item is either a formula (content) or a
///   two-element array [formula, label] to attach a numbered label.
///
/// Returns:
/// - A block containing all equations with reduced inter-equation spacing.
#let equation-list(equations) = {
  show math.equation: it => {
    block(
      spacing: 0.5em,
    )[
      #it
    ]
  }
  block(spacing: baseline)[
    #for (i, item) in equations.enumerate() {
      let is-last = i == equations.len() - 1
      let formula = if type(item) == array {
        item.at(0)
      } else {
        item
      }
      let label = if type(item) == array and item.len() > 1 {
        item.at(1)
      } else {
        none
      }

      let body = [
        #formula#if not is-last [,]
      ]

      if label == none {
        math.equation(
          numbering: none,
          block: true,
        )[
          #body
        ]
      } else {
        let eq = math.equation(
          block: true,
        )[
          #body
        ]
        [#eq #label]
      }
    }
  ]
}

== `#where-defs`

/// Renders a "где" variable-definition block aligned under an equation.
///
/// Parameters:
/// - items: An array of two-element arrays [symbol, description].
///
/// Returns:
/// - An indented block with "где" on the left and definitions on the right,
///   each terminated by ";" except the last which ends with ".".
#let where-defs(items) = block[
  #set par(first-line-indent: 0pt)
  #pad(left: first-line-indent, [
    #grid(
      columns: (auto, 1fr),
      column-gutter: 0.6em,
    )[
      где
    ][
      #for (i, item) in items.enumerate() [
        #item.at(0) -- #item.at(1)#if i == items.len() - 1 [.] else [;] \
      ]
    ]
  ])
]
