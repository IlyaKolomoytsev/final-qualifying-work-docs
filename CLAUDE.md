# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **FQW Typst Project** — a comprehensive final qualification work (ВКР) written in Typst. The project develops a computer model of a hydroacoustic software-hardware transceiver for virtual testing of multi-agent systems.

**Key documents:**
- `docs/explanatory-note.typ` — detailed explanatory note with theory, analysis, and proposed solutions
- `docs/technical-assignment.typ` — formal technical assignment
- `docs/system-programmers-guide.typ` — programming guide for implementation details
- `docs/common.typ` — shared content imported by main documents

All documents are built from `docs/*.typ` source files into PDF outputs in `build/`.

## Build Commands

The project uses a Makefile with Typst as the document compiler.

### Standard builds
```bash
make explanatory-note        # Compile poyasnitelnaya zapiska to build/explanatory-note.pdf
make technical-assignment   # Compile technical assignment to build/technical-assignment.pdf
make system-programmers-guide  # Compile programmer guide to build/system-programmers-guide.pdf
make all                     # Build all three documents
make clean                   # Remove all PDFs from build/
```

### Watch mode (auto-rebuild on file changes)
```bash
make watch-explanatory-note
make watch-technical-assignment
make watch-common            # Useful when editing shared content
```

The `TYPST` variable can be overridden: `make TYPST=typst-x64 explanatory-note` if needed.

## Project Architecture

### Document structure
- **Source files** (`docs/*.typ`): Typst source files organized by document. Each imports the main template and uses a common import system.
- **Templates** (`template/`): 
  - `fqw.typ` — main document class with page layout, styling, heading numbering, equation formatting
  - `explanatory-note.typ` — template/macros specific to poyasnitelnaya zapiska
  - `technical-assignment.typ` — template/macros specific to technical assignment
  - `system-programmers-guide.typ` — template/macros specific to programmer guide
  - `title-pages/` — title page templates
  - Citation style file (GOST-compliant)
- **Assets** (`assets/images/`): Diagrams and images referenced in documents
- **Guidelines** (`guidelines/`): Department requirements and knowledge base (Markdown)
  - Treated as source of truth for VKR rules and formatting standards
  - Used by terminology guardian and other agents for validation

### Typst template functions (from `template/fqw.typ`)
Core functions available in all documents:
- `fqw-document(body)` — main document wrapper with page margins, numbering, header/footer
- `fqw-text-settings(body)` — applies Russian typography (14pt, Times New Roman, justified, hyphenation off)
- `fqw-header-abstract()` — formats abstract section
- `fqw-outline()` — generates table of contents
- `fqw-introduction(label:)` — formats introduction section
- `fqw-figure(content, caption)` — numbered figure with GOST caption
- `fqw-eq-ref()` — cross-reference to equations
- `fqw-where()` — variable definitions under equations

### Content organization
The explanatory note (1600+ lines) covers:
1. **Abstract** — problem statement and key keywords
2. **Introduction** — motivation, V-model development integration, modeling tasks
3. **Theoretical foundations** — OSI layers, hydroacoustic channel physics, Doppler effect, multipath effects, attenuation
4. **Literature review** — existing solutions for modeling (MATLAB/Simulink, Cadence OrCAD, Verilog/VHDL, Ns-3, OMNeT++, channel modeling tools)
5. **Proposed solution** — modified V-model with simulation at each stage, formal channel and transceiver models, SINR-based reception criteria
6. **Design section** — functional and non-functional requirements, architecture

Formulas use Typst's `$...$` math notation. Cross-references use labels like `<sec:analysis>` and `#fqw-eq-ref()` or `#fqw-figure-ref()`.

## Terminology Management

The project includes a **Terminology Guardian agent** (`.codex/agents/terminology-guardian.toml`) that maintains controlled terminology consistency across documentation.

### When to use the Terminology Guardian

Invoke the agent when:
- Documentation introduces, changes, or repeats technical terms
- You want to verify that terminology is semantically consistent
- You need to update the canonical terminology database

The agent works with `docs/terminology.md` (the controlled terminology database) and ensures:
- One concept = one preferred Russian term
- Aliases only when actually used in sources or standards
- Definitions are academically precise and suitable for a thesis
- No duplicate, vague, or conflicting terms

### Key rules
- **Canonical terms**: Prefer Russian unless the project defines an English term as canonical
- **Semantic clarity**: Distinguish between цель/задача/требование/ограничение, система/приложение/модуль/компонент/сервис, пользователь/оператор/клиент/администратор, and similar contrasts
- **No marketing language**: Definitions must be precise and neutral
- **Git discipline**: Terminology changes are committed atomically with messages like: `agent(terminology-guardian): add term "компонент системы" for architecture chapter consistency`

## Formatting Standards

The project follows GOST-R 7.0.100-2018 (Russian standard for thesis formatting):
- Page: A4, margins 30mm (left), 20mm (top/bottom), 15mm (right)
- Font: 14pt Times New Roman, justified, no hyphenation
- Line spacing: 1.06em (single-spaced in terms)
- First line indent: 1.25cm (except headings)
- Heading numbering: 1.1 for chapters, 1.1.1 for sections
- Equations: numbered as (1.1), (1.2), etc. per chapter
- Figures: numbered as 1.1, 1.2, etc. per chapter; captions centered below

## Guidelines (Department Requirements)

The `guidelines/` directory contains curated knowledge about VKR rules:
- Source priority: Markdown files in `guidelines/` → extracted pages → raw text → original PDF
- Topics covered: package composition, explanatory note, technical assignment, system programmer guide, software requirements, formatting, binding, title pages
- Entry point: `guidelines/README.md`; agent entry point: `guidelines/AGENTS.md`

When editing documents, consult guidelines to ensure compliance with department standards.

## Local Workflow

1. **Edit Typst source**: Modify files in `docs/` or `template/`
2. **Watch and rebuild**: Run `make watch-explanatory-note` in a terminal to see changes live as PDFs
3. **Check terminology**: Before adding new technical terms, use the Terminology Guardian agent to ensure consistency
4. **Verify links**: Use `lychee` to check Markdown links in `guidelines/` after moving or renaming files
5. **Build final PDFs**: Run `make all` before committing

## Key Files to Know

| File | Purpose |
|------|---------|
| `Makefile` | Build rules for Typst documents |
| `docs/*.typ` | Document source files |
| `template/fqw.typ` | Core document template and styling |
| `docs/terminology.md` | Controlled terminology database (maintain via Terminology Guardian agent) |
| `guidelines/README.md` | Entry point to department rules and standards |
| `.codex/agents/terminology-guardian.toml` | Configuration for terminology consistency agent |
| `docs/common.typ` | Shared content included by all documents |

## Tips

- Typst compilation is fast; use `make watch-*` to get instant feedback while editing
- When referencing equations, use `@` citations for bibliography and `#fqw-eq-ref()` for equations
- Images should be in `assets/images/` with descriptive names; update paths in imports if you reorganize
- Comments in Typst use `//` syntax; use them sparingly
- The explanatory note is the primary deliverable; keep it well-organized and self-contained
