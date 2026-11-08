# Plan: Document standard

## Overview

The standard is one Markdown file. It is the source of truth for the document
format. The skills carry the rules in short form, and a test compares the two.
A small shell checker and a conformance set make the rules testable.

## Components Affected

- `src/common.md` — the document format section follows the standard (field table identical).
- `tests/skills.test.sh` — expects the new limit wording.
- `.github/workflows/check.yml` — runs the new test.
- `README.md` and `specs/PROJECT.md` — mention the standard.

## New Files

- `standard/mkbds-1.0.md` — the standard.
- `standard/conformance/vault/.obsidian/app.json` — Obsidian settings of the sample vault (Markdown links, relative paths).
- `standard/conformance/vault/knowledge/backend/payments/idempotency-keys.md` — valid sample document.
- `standard/conformance/vault/knowledge/backend/payments/retry-policy.md` — valid sample document, linked from the first.
- `standard/conformance/vault/knowledge/glossary-terms.md` — valid sample document with optional fields.
- `standard/conformance/invalid/*.md` — one invalid document per broken rule.
- `tests/check-document.sh` — reference checker.
- `tests/standard.test.sh` — tests.

## Technical Approach

- The standard's structure follows ISO and RFC style: numbered sections, defined terms, normative and informative parts.
- The field table text is identical in the standard and in `src/common.md`. `tests/standard.test.sh` extracts both and compares them.
- The checker reads a document, splits the frontmatter, and checks: file name, size, delimiters, flat properties, required fields, values, dates, author format, word limits, and relative links.
- Invalid documents are named `<rule>.md`. The test expects the checker to fail on each and to print the rule name.
- The stale threshold and the other configurable values are listed in one section, with their defaults.
- The Obsidian check is manual. No Obsidian version has been tested yet; the standard says so.

## Cross-feature Dependencies

- `skill-build` (implemented): the build joins the shared rules.
- `personal-knowledge-base` requires this item for its document format.

## Risks

- The checker does not read YAML fully. It checks the flat subset that the standard allows, and it is a reference for the test set only.
- Obsidian can change without notice. The standard names a tested version per release.

## Open Questions

None.
