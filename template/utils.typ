= Help components

== `#warning`

/// Highlights warning or placeholder content in red.
///
/// Parameters:
/// - body: The content to render as a warning.
///
/// Returns:
/// - A `text` element with red fill containing the provided `body`.
#let warning(body) = text(fill: red)[#body]
#warning[Текст предупреждения]
