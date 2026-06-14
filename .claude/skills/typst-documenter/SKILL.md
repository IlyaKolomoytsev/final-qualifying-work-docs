---
name: typst-documenter
description: >
  Use this skill whenever the user needs to add documentation comments to Typst (.typ) code —
  functions, variables, modules, or algorithm steps.
  Triggers include:
  "document this Typst code",
  "add doc-comments to my .typ file",
  "annotate this Typst file",
  "make this module self-documenting",
  "explain these functions in comments",
  or any request to add or improve documentation comments inside a .typ file.
  Always use this skill when a .typ file is provided and the user asks for documentation,
  annotations, or code comments — even if phrased casually.
---

# Typst Documenter

Adds `///` documentation comments to Typst source code.
Produces a single output: the **original file annotated with doc-comments** in place.

---

## Typst Code Entities to Document

| Entity | Syntax | Notes |
|--------|--------|-------|
| Function | `#let my-func(a, b: "default") = ...` | Named params have `:`; positional don't |
| Variable | `#let my-var = value` | Document as a constant |
| Algorithm step | `//` comment inside a function body | Narrate complex logic inline |
| Module | Top of the file | Overall purpose, author, version |

### Comment types
- `//` — regular inline comment; use inside function bodies to narrate steps
- `///` — doc-comment; must immediately precede a `#let` definition
- `/* ... */` — block comment; avoid using for documentation

---

## Doc-Comment Format

All parameter descriptions and the return type go in the `///` block **directly above** the `#let` line — no blank lines between the block and the definition.

### Function

```typst
/// Short one-line description of the function.
///
/// Optional longer explanation. Supports full Typst markup:
/// *bold*, _italic_, equations like $f(x) = x^2$, lists, etc.
///
/// ```typst
/// #my-func(42, b: "world")
/// ```
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

**Usage example — when to include:**

Place a ` ```typst ``` ` code block at the **end of the extended description**, before the parameter list. Separate it from surrounding text with blank `///` lines.

Include an example when any of the following apply:
- The function has multiple named parameters and the typical call pattern isn't obvious
- The return value needs context to understand (e.g. content that depends on argument combinations)
- The function has optional parameters with non-trivial defaults worth illustrating
- A concrete call would save the reader from having to mentally assemble the signature

Skip the example when:
- The function has 0–1 simple positional parameters and does exactly what the name says
- The one-line summary already makes the call pattern self-evident

If only a short summary is needed (no extended explanation), the example follows the summary directly:

```typst
/// Short one-line description.
///
/// ```typst
/// #my-func(42)
/// ```
///
/// - a (int): Description.
/// -> content
#let my-func(a) = { ... }
```

### Variable

```typst
/// The default font size used throughout the document.
/// -> length
#let default-font-size = 11pt
```

### Module-level

Place a `///` block at the very top of the file (before any `#let` definitions):

```typst
/// My Module
///
/// Utility functions for formatting academic papers.
///
/// Author: Jane Doe
/// Version: 1.0.0
```

> **Important:** Do not use Markdown syntax inside `///` comments — write in **Typst markup**.
> Use: `*bold*`, `_italic_`, `= Heading`, `- list item`, `$math$`.
> Avoid: `**bold**`, `#` headings, Markdown tables, backtick fences.

### Inline algorithm comments

Inside function bodies, use `//` to narrate non-obvious steps:

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

## Step-by-Step Workflow

### Step 1 — Understand the code

Read the provided Typst code and identify:
- [ ] Module purpose (for the file-level doc-comment)
- [ ] All `#let` definitions — distinguish functions from variables
- [ ] Function signatures: positional params, named params, default values
- [ ] Return types (infer from the function body if not stated)
- [ ] Non-trivial logic inside function bodies that needs `//` step narration

### Step 2 — Add `///` doc-comments to source

For each **function**:
1. Write a one-line summary above the `#let` line
2. If the call pattern is non-obvious (see usage example rules above), add a ` ```typst ``` ` example at the end of the description block
3. List each parameter as `/// - name (type): description`
4. Add `/// -> return-type` as the last line of the block
5. Add `//` step comments inside complex function bodies

For each **variable**:
1. Write a description and `/// -> type` above the `#let` line

If the file has no module-level comment, add one at the top.

### Step 3 — Present the annotated file

Output a single file: the original source with all doc-comments added in place.

Then briefly summarize:
- How many functions and variables were documented
- Any return types that had to be inferred (and what reasoning was used)
- Anything ambiguous the user should clarify or review

---

## Quality Checklist

Before finalizing, verify:
- [ ] Every `#let` definition has at least one `///` comment
- [ ] Every function parameter has a `/// - name (type): description` entry
- [ ] Every documented definition ends with `/// -> return-type`
- [ ] Non-trivial functions include a ` ```typst ``` ` usage example placed before the parameter list
- [ ] The `///` block is placed directly above `#let` — no blank lines between them
- [ ] No `///` comment appears after a `//` comment on an adjacent line
- [ ] Descriptions are direct — not "the X parameter" but "Maximum number of items"
- [ ] No Markdown syntax inside `///` comments

---

## Reference: Type Quick-Reference

See `references/typst-types.md` for the full list of Typst built-in types and when to use them.