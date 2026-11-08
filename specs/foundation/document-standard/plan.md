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
- `standard/conformance/vault/.mkbds/version` — the version file of the marker folder (`1.0`).
- `standard/conformance/vault/.mkbds/exclude` — excludes `README.md`.
- `standard/conformance/vault/.mkbds/example-tool/settings.toml` — a file of an imaginary tool, to show that the marker folder is open.
- `standard/conformance/vault/README.md` — explains the vault. It is excluded, so it has no header.
- `standard/conformance/vault/.obsidian/app.json` — Obsidian settings of the sample vault (Markdown links, relative paths).
- `standard/conformance/vault/backend/auth/legacy-session-length.md` — disputed document with a reason.
- `standard/conformance/vault/backend/auth/login-flow.md` — decision that supersedes the old flow.
- `standard/conformance/vault/backend/auth/old-login-flow.md` — deprecated document.
- `standard/conformance/vault/backend/auth/session-tokens.md` — fact with a callout.
- `standard/conformance/vault/backend/auth/token-rotation-gotcha.md` — gotcha.
- `standard/conformance/vault/backend/payments/idempotency-keys.md` — small contract-style fact with tags, related link, and a callout.
- `standard/conformance/vault/backend/payments/ledger-design-decision.md` — large decision record (about 19 KB) with the `trust` field and a git anchor.
- `standard/conformance/vault/backend/payments/payment-api-v3-contract.md` — large contract (about 45 KB) with tables and code blocks.
- `standard/conformance/vault/backend/payments/refund-runbook.md` — large how-to (about 29 KB) with checklists and tables.
- `standard/conformance/vault/backend/payments/retry-policy.md` — decision with sources and a URL anchor.
- `standard/conformance/vault/data/event-schema-catalog.md` — largest contract (about 52 KB), many tables and examples.
- `standard/conformance/vault/data/warehouse-naming.md` — how-to with a table.
- `standard/conformance/vault/frontend/accessibility-checklist.md` — large how-to (about 29 KB) with 120 checks.
- `standard/conformance/vault/frontend/design-tokens.md` — fact with tables.
- `standard/conformance/vault/glossary-terms.md` — glossary with `supersedes` and `disputed: false`.
- `standard/conformance/vault/notes-in-other-languages.md` — non-ASCII text (UTF-8).
- `standard/conformance/vault/onboarding.md` — how-to that links across folders.
- `standard/conformance/vault/platform/deploy-process.md` — large how-to (about 18 KB).
- `standard/conformance/invalid/*.md` — one invalid document per broken rule.
- `tests/check-document.sh` — reference checker.
- `tests/standard.test.sh` — tests.

## Technical Approach

- The large sample documents were generated once from data with a throwaway script. They are ordinary files now. Nobody edits them by hand without running the tests.

- The standard's structure follows ISO and RFC style: numbered sections, defined terms, normative and informative parts.
- The field table text is identical in the standard and in `src/common.md`. `tests/standard.test.sh` extracts both and compares them.
- The checker finds the root (the first folder above the file with a `.mkbds` folder), skips excluded files, reads a document, splits the frontmatter, and checks: file name, size, delimiters, flat properties, required fields, values, dates, author format, word limits, and relative links.
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
