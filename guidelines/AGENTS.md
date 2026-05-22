# Rules

This directory is a curated knowledge base for department requirements related to the final qualification project and predegree practice.

## Source Of Truth

- Treat only department requirements from official source documents as truth inside this directory.
- Do not invent requirements, deadlines, percentages, document forms, admission criteria, or exceptions.
- If a rule is not present in the knowledge files or source pages, state that the provided guidelines do not specify it.
- Higher-level agent policies may define how agents use this knowledge, but they do not define department requirements.

## Source Priority

Use sources in this order:

1. Normalized Markdown knowledge files in this directory.
2. Page files in `sources/guidelines-for-the-2022-final-qualification-project/extracted/pages/`.
3. Raw extracted text in `sources/guidelines-for-the-2022-final-qualification-project/extracted/doc.raw.txt`.
4. The source PDF in `sources/guidelines-for-the-2022-final-qualification-project/doc.pdf` when visual layout, title pages, figures, or binding examples matter.

## How To Answer

- First identify the topic: package composition, explanatory note, technical assignment, system programmer guide, software requirements, predefense, norm control, predegree practice, formatting, binding, or title pages.
- Use [README.md](README.md) as the navigation entrypoint.
- Keep answers grounded in the relevant knowledge file and source page links.
- For practical questions, include a short action checklist.
- If the methodical guidelines provide approximate dates only, say that exact dates are published in the VSTU educational course.
- Do not silently correct source typos as facts. If needed, phrase it as "the guidelines state ...".

## Structure Rules

- Top-level numbered Markdown files are curated knowledge or service reports.
- `README.md` is the human entrypoint.
- `AGENTS.md` is the agent instruction entrypoint.
- `sources/<source-id>/doc.<ext>` stores original source documents.
- `sources/<source-id>/extracted/` stores raw extraction artifacts for that source.
- File and directory names must use kebab-case and must not contain spaces.
- Keep internal Markdown links relative.

## Validation

- Use `lychee` as the standard Markdown link checker for this directory.
- After renaming, moving, adding, or deleting Markdown files, check for stale links and legacy paths.
- Do not leave references to removed files.
