---
name: typst-documenter
description: >
  Use this skill whenever the user needs to document Typst (.typ) code — functions, variables,
  or algorithm steps. Triggers include: "document this Typst code", "add doc comments to my .typ file",
  "generate documentation for my Typst module", "create a reference page for my Typst package",
  "add tidy comments", or any request to explain or annotate Typst functions/variables.
  Also use when the user shares Typst source code and asks to make it self-documenting,
  generate a README, or produce a documentation file. Always prefer this skill over generic
  code-documentation approaches when .typ files are involved.
---

# Typst Documenter

Generates documentation for Typst code using the **tidy** package with old (pre-0.4) syntax.
Produces two outputs:
1. The original code **annotated with `///` doc-comments** (inline in the source file)
2. A **separate `docs.typ` file** that renders the documentation with tidy

---

## Typst Basics You Must Know

### Code entities to document
| Entity | Syntax | Notes |
|--------|--------|-------|
| Function | `#let my-func(a, b: "default") = ...` | Named params have `:`; positional don't |
| Variable | `#let my-var = value` | Document as a constant |
| Algorithm step | `//` comment inside a function body | Narrate complex logic inline |
| Module | Top of the file | Overall purpose, author, version |

### Comment types
- `//` — regular comment (ignored by tidy)
- `///` — doc-comment (parsed by tidy, must immediately precede a `#let` definition)
- `/* ... */` — block comment (ignored by tidy)

---

## Old-Syntax Tidy Doc-Comment Format

All parameter descriptions and the return type go in the block **above** the `#let` line.
Parameters are bullet points; types are in parentheses; return type uses `->`.

### Function documentation
```typst
/// Short one-line description of the function.
///
/// Optional longer explanation. Supports full Typst markup:
/// *bold*, _italic_, equations like $f(x) = x^2$, lists, etc.
///
/// - a (int, float): Description of positional parameter `a`.
/// - b (str): Description of named parameter `b`. Defaults to `"hello"`.
/// -> return-type
#let my-func(a, b: "hello") = { ... }
```

**Rules:**
- Parameters listed as `- name (type): description` — exactly this format
- Multiple accepted types separated by comma: `(int, float)`
- Return type on its own `/// ->` line, last in the block
- Leave a blank `///` line to separate summary from extended description
- Common types: `int`, `float`, `str`, `bool`, `content`, `color`, `length`, `array`, `dictionary`, `none`, `auto`, `function`

### Variable documentation
```typst
/// The default font size used throughout the document.
/// -> length
#let default-font-size = 11pt
```

### Module-level documentation
Place a `///` block at the very top of the file:
```typst
/// My Module
///
/// Utility functions for formatting academic papers.
///
/// Author: Jane Doe
/// Version: 1.0.0
```

> **Important:** Do not use Markdown syntax inside `///` comments — the content is parsed and rendered as **Typst markup**, not Markdown. Use Typst syntax: `*bold*`, `_italic_`, `= Heading`, `- list item`, `$math$`. Markdown tables, `**bold**`, `#` headings, and similar constructs will not render correctly.

### Inline algorithm comments
Inside function bodies, use `//` comments to narrate steps:
```typst
#let process-data(items) = {
  // Filter out empty entries
  let filtered = items.filter(x => x != none)
  // Sort alphabetically
  let sorted = filtered.sorted()
  // Return as formatted list
  sorted.map(x => [- #x]).join()
}
```

---

## Documentation File Structure (`docs.typ`)

Always generate a separate `docs.typ` that imports tidy with `old-syntax: true`:

```typst
#import "@preview/tidy:0.4.3"

#set document(title: "Module Reference")
#set page(numbering: "1")
#set heading(numbering: "1.")

= Module Reference

#let module = tidy.parse-module(
  read("my-module.typ"),
  // Optional: set the module name shown in headers
  name: "my-module",
  old-syntax: true,
)

#tidy.show-module(module, style: tidy.styles.default)
```

---

## Step-by-Step Workflow

### Step 1 — Understand the code
Read the provided Typst code and identify:
- [ ] Module purpose (top of file)
- [ ] All `#let` definitions (functions vs. variables)
- [ ] Function signatures: positional params, named params, default values
- [ ] Return types (infer from the body if not stated)
- [ ] Non-trivial algorithm logic that needs inline `//` step narration

### Step 2 — Add `///` doc-comments to source
For each function:
1. Write a one-line summary above the `#let` line
2. List each parameter as `/// - name (type): description`
3. Add `/// -> return-type` as the last line of the block
4. Add `//` step comments inside complex function bodies

For each variable:
1. Write a description and `/// -> type` above the `#let` line

### Step 3 — Produce outputs
Always produce **two files**:
- `annotated-<original-name>.typ` — the source with doc-comments added
- `docs.typ` — the tidy renderer file

### Step 4 — Explain what you did
After producing files, briefly summarize:
- How many functions/variables were documented
- Any types you had to infer
- Anything ambiguous that the user should clarify

---

## Quality Checklist

Before finalizing, verify:
- [ ] Every `#let` definition has at least one `///` comment
- [ ] Every function parameter has a `/// - name (type): description` entry
- [ ] The function itself has a `/// -> return-type` line
- [ ] No parameter description says "the X parameter" — be direct ("Maximum number of items")
- [ ] No `///` comments are placed after `//` comments (tidy won't pick them up)
- [ ] The `docs.typ` file uses `old-syntax: true` and the correct filename in `read("...")`
- [ ] No Markdown syntax inside `///` comments — use Typst markup only

---

## Reference: Type Quick-Reference
See `references/typst-types.md` for the full list of Typst built-in types and when to use them.
