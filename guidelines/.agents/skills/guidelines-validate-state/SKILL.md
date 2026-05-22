---
name: guidelines-validate-state
description: Validate the current state of the local guidelines knowledge base when the user asks to check guidelines links, paths, naming policy, legacy paths, or source structure consistency.
---

# Guidelines Validate State

Use this skill when the user wants to verify the structural integrity of `guidelines/`.

This skill is specific to this repository. It does not try to validate arbitrary knowledge bases.

## What this skill checks

- Markdown links under `guidelines/`
- forbidden absolute filesystem and `file://` links
- stale legacy paths from the pre-restructure layout
- spaces in file and directory names
- `sources/<source-id>/` naming and minimal source layout

This v1 skill does not evaluate coverage completeness or semantic traceability.

## Workflow

1. Run `guidelines/.agents/skills/guidelines-validate-state/scripts/validate-guidelines.sh`.
2. Read the final `PASS` or `FAIL` status and the failing check groups.
3. Report the violations succinctly.

Do not manually recreate the checks if the script is available. The script is the canonical validator.

## Exit codes

- `0`: all checks passed
- `1`: validation violations found
- `2`: validator infrastructure problem, such as missing `lychee`

## Response rules

- If the script returns `0`, say that the current structural validation passed.
- If the script returns `1`, list the broken rules and point to the relevant paths.
- If the script returns `2`, explain which required tool or directory is missing.
- Do not auto-fix files unless the user explicitly asks for remediation.
