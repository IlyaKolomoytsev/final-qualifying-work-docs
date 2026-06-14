#import "../core.typ": baseline, section-numbering

= Figures

== `#gost-figure`

/// Renders a GOST-compliant numbered figure with a caption below.
///
/// Parameters:
/// - body: The figure content (image, diagram, etc.).
/// - caption: The figure caption displayed below the content.
/// - label: An optional Typst label for cross-referencing. Defaults to `none`.
/// - numbering-size: The heading depth used for the figure number prefix.
///   Defaults to `auto` (uses the document default).
///
/// Returns:
/// - A full-width block containing the figure and its caption.
#let gost-figure(body, caption, label: none, numbering-size: auto) = block(spacing: baseline, width: 100%)[
  #counter("gost-figure").step()

  #figure(
    kind: image,
    supplement: [Рисунок],
    caption: caption,
    numbering: n => section-numbering(n, numbering-size: numbering-size),
  )[#body]
  #label
]
