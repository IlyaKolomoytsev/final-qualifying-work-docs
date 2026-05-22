---
name: guidelines-rebuild-knowledge
description: Rebuild and update the curated guidelines knowledge base from source documents when the source changes or the user asks to refresh department requirements.
---

# Guidelines Rebuild Knowledge

Use this skill when the user asks to update, refresh, or restructure the curated knowledge files under `guidelines/` from the source documents.

This skill is specific to the `guidelines/` knowledge base. It does not describe the source documents themselves.

## What this skill does

- reads the relevant source pages and the current knowledge files
- updates curated Markdown files at the top level of `guidelines/`
- keeps answers grounded in the source hierarchy defined by `AGENTS.md`
- preserves relative links and the current navigation structure

## What this skill does not do

- it does not invent rules, deadlines, or forms
- it does not edit the source PDF or extracted artifacts unless the source itself changed
- it does not replace the structural validator; run `guidelines-validate-state` after structural changes

## Workflow

1. Identify the topic and the knowledge file(s) that own it.
2. Read the relevant source pages first, then the current curated Markdown file.
3. Update only the minimal set of knowledge files needed for the change.
4. Preserve the wording that stays true to the source instead of rewriting everything.
5. Update `README.md` if navigation or file names changed.
6. If file paths, links, or layout changed, run the validator skill afterward.

## Editing rules

- Keep internal links relative.
- Keep filenames and directories in kebab-case.
- Do not move facts out of the source hierarchy into the skill.
- If the source is ambiguous, say that the guidelines do not specify the detail.

## Output rules

- Summarize what changed and why.
- Call out any open questions that still need user confirmation.
- Mention when a follow-up validation run is required.
