---
name: guidelines-ingest-source
description: Ingest a new source document into the guidelines knowledge base by creating the source folder, storing the original document, and preparing extracted artifacts when needed.
---

# Guidelines Ingest Source

Use this skill when the user asks to add a new source document to `guidelines/sources/` or replace an existing one with a new primary document.

This skill is specific to the `guidelines/` repository layout.

## What this skill does

- chooses a kebab-case `source-id`
- creates `guidelines/sources/<source-id>/`
- stores the original document as `doc.<ext>`
- prepares `extracted/` only when the source format benefits from extraction
- records enough local structure for the rebuild and validation skills to work later

## What this skill does not do

- it does not rewrite the curated knowledge files
- it does not invent new structural conventions
- it does not skip validation after structural changes

## Workflow

1. Identify the source document and its canonical name.
2. Choose a short kebab-case `source-id`.
3. Create `guidelines/sources/<source-id>/`.
4. Store the original document as `doc.<ext>`.
5. If the format is complex, extract the source into `extracted/`.
6. Confirm the resulting paths contain no spaces and no legacy names.
7. Run the structural validator skill if any paths or files were added or moved.

## Naming rules

- Use lowercase letters, digits, and hyphens only.
- Do not use spaces.
- Keep `source-id` stable enough that future replacements remain obvious.

## Output rules

- State the final `source-id`.
- State where the original document was stored.
- State whether `extracted/` was created.
- Mention any follow-up rebuild or validation that is now required.
