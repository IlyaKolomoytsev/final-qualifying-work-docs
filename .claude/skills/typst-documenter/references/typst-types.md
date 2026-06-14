# Typst Built-in Types Reference

Use these type names in `/// -> type` annotations.

## Primitive Types
| Type | Description | Example |
|------|-------------|---------|
| `int` | Integer | `42`, `-7` |
| `float` | Floating-point number | `3.14`, `1.5e-3` |
| `bool` | Boolean | `true`, `false` |
| `str` | String | `"hello"` |
| `none` | Absence of value | `none` |
| `auto` | Automatic value (let Typst decide) | `auto` |

## Content & Layout
| Type | Description | Example |
|------|-------------|---------|
| `content` | Typst markup/content | `[*bold text*]` |
| `length` | Absolute or relative length | `12pt`, `1em`, `50%` |
| `relative` | Ratio or length | `50%`, `1em + 5pt` |
| `alignment` | Horizontal/vertical alignment | `left`, `center`, `top` |
| `color` | Color value | `red`, `rgb("#ff0000")` |
| `gradient` | Color gradient | `gradient.linear(...)` |
| `stroke` | Line stroke | `1pt + black` |
| `margin` | Page margin | `(top: 2cm, bottom: 2cm)` |

## Collections
| Type | Description | Example |
|------|-------------|---------|
| `array` | Ordered sequence | `(1, 2, 3)` |
| `dict` | Key-value map | `(a: 1, b: 2)` |

## Functions & Selectors
| Type | Description |
|------|-------------|
| `function` | A callable function |
| `selector` | Element selector (for show rules) |
| `label` | Document label (`<my-label>`) |
| `location` | Position in document |

## Numeric
| Type | Description |
|------|-------------|
| `angle` | Angle value (e.g., `90deg`) |
| `ratio` | Percentage (e.g., `50%`) |
| `fraction` | Fractional unit (e.g., `1fr`) |

## Special
| Type | Description |
|------|-------------|
| `datetime` | Date and time |
| `duration` | Time duration |
| `bytes` | Raw byte data |
| `regex` | Regular expression |
| `version` | Package version |
| `plugin` | WASM plugin |

---

## Combining Types

Use `|` for union types:
```
/// -> int | float
/// -> content | str
/// -> color | gradient | none
/// -> length | auto
```

Use `array` with an element hint in the description:
```
/// An array of strings to display.
/// -> array
```

---

## Common Patterns

### Optional parameter (can be none)
```typst
/// The accent color. If `none`, uses the theme default.
/// -> color | none
accent: none,
```

### Auto-sized parameter
```typst
/// Width of the box. Set to `auto` to fit content.
/// -> length | auto
width: auto,
```

### Content parameter
```typst
/// The body content to display inside the card.
/// -> content
body,
```

### Function parameter (callback)
```typst
/// A function that formats each item. Receives a `str`, returns `content`.
/// -> function
formatter: x => [#x],
```
