#!/usr/bin/env bash

set -u
set -o pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guidelines_dir="$(cd "${script_dir}/../../../.." && pwd)"
sources_dir="${guidelines_dir}/sources"

status=0

say() {
  printf '%s\n' "${1-}"
}

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1"
  status=1
}

infra_fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 2
}

require_file() {
  local path="$1"
  local label="$2"
  if [[ -f "$path" ]]; then
    pass "$label"
  else
    fail "$label missing: ${path}"
  fi
}

require_dir() {
  local path="$1"
  local label="$2"
  if [[ -d "$path" ]]; then
    pass "$label"
  else
    fail "$label missing: ${path}"
  fi
}

if [[ ! -d "$guidelines_dir" ]]; then
  infra_fail "guidelines directory not found: ${guidelines_dir}"
fi

if [[ ! -f "${guidelines_dir}/README.md" ]]; then
  infra_fail "guidelines root was resolved incorrectly: ${guidelines_dir}"
fi

if ! command -v lychee >/dev/null 2>&1; then
  infra_fail "required tool not found in PATH: lychee"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

say "== Entry Points =="
require_file "${guidelines_dir}/README.md" "README.md exists"
require_file "${guidelines_dir}/AGENTS.md" "AGENTS.md exists"

say
say "== Markdown Links =="
mapfile -d '' markdown_files < <(find "$guidelines_dir" -type f -name '*.md' -print0 | sort -z)
if [[ "${#markdown_files[@]}" -eq 0 ]]; then
  fail "no Markdown files found under guidelines/"
else
  lychee_output="${tmp_dir}/lychee.txt"
  if (
    cd "$guidelines_dir" &&
    lychee --offline --no-progress "${markdown_files[@]}" >"$lychee_output" 2>&1
  ); then
    pass "lychee offline check"
  else
    fail "lychee offline check"
    sed 's/^/  /' "$lychee_output"
  fi
fi

say
say "== Forbidden Link Targets =="
file_uri_hits="${tmp_dir}/file-uri.txt"
if rg -n 'file://' "$guidelines_dir" -g '*.md' >"$file_uri_hits"; then
  fail "found file:// links"
  sed 's/^/  /' "$file_uri_hits"
else
  pass "no file:// links"
fi

absolute_link_hits="${tmp_dir}/absolute-links.txt"
if rg -n '\]\((<)?/' "$guidelines_dir" -g '*.md' >"$absolute_link_hits"; then
  fail "found absolute filesystem links"
  sed 's/^/  /' "$absolute_link_hits"
else
  pass "no absolute filesystem links"
fi

say
say "== Legacy Paths =="
legacy_hits="${tmp_dir}/legacy-paths.txt"
if rg -n 'llm-ready/|\]\((<)?(\./)?extracted/|\]\((<)?(\./)?Методичка ВКР' "$guidelines_dir" -g '*.md' >"$legacy_hits"; then
  fail "found legacy pre-restructure paths"
  sed 's/^/  /' "$legacy_hits"
else
  pass "no legacy pre-restructure paths"
fi

say
say "== Naming Policy =="
space_hits="${tmp_dir}/spaces.txt"
if find "$guidelines_dir" -mindepth 1 \( -type f -o -type d \) -name '* *' -print | sort >"$space_hits" && [[ -s "$space_hits" ]]; then
  fail "found files or directories with spaces"
  sed 's/^/  /' "$space_hits"
else
  pass "no files or directories with spaces"
fi

source_name_hits="${tmp_dir}/source-ids.txt"
if [[ -d "$sources_dir" ]]; then
  while IFS= read -r source_path; do
    source_id="$(basename "$source_path")"
    if [[ ! "$source_id" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
      printf '%s\n' "$source_path"
    fi
  done < <(find "$sources_dir" -mindepth 1 -maxdepth 1 -type d | sort) >"$source_name_hits"

  if [[ -s "$source_name_hits" ]]; then
    fail "found source directories outside kebab-case policy"
    sed 's/^/  /' "$source_name_hits"
  else
    pass "source directory names use kebab-case"
  fi
else
  fail "sources directory missing: ${sources_dir}"
fi

say
say "== Source Structure =="
if [[ -d "$sources_dir" ]]; then
  source_structure_hits="${tmp_dir}/source-structure.txt"
  while IFS= read -r source_path; do
    source_id="$(basename "$source_path")"
    mapfile -t doc_files < <(find "$source_path" -mindepth 1 -maxdepth 1 -type f -name 'doc.*' | sort)
    if [[ "${#doc_files[@]}" -ne 1 ]]; then
      printf '%s: expected exactly 1 doc.<ext> file, found %s\n' "$source_id" "${#doc_files[@]}"
    fi

    extracted_dir="${source_path}/extracted"
    if [[ -d "$extracted_dir" ]]; then
      for required in doc.raw.txt page-index.tsv toc.txt; do
        if [[ ! -f "${extracted_dir}/${required}" ]]; then
          printf '%s: missing extracted file %s\n' "$source_id" "${required}"
        fi
      done
      if [[ ! -d "${extracted_dir}/pages" ]]; then
        printf '%s: missing extracted directory pages/\n' "$source_id"
      fi
    fi
  done < <(find "$sources_dir" -mindepth 1 -maxdepth 1 -type d | sort) >"$source_structure_hits"

  if [[ -s "$source_structure_hits" ]]; then
    fail "source structure violations found"
    sed 's/^/  /' "$source_structure_hits"
  else
    pass "source structure matches expected layout"
  fi
fi

say
if [[ "$status" -eq 0 ]]; then
  say "PASS"
else
  say "FAIL"
fi

exit "$status"
