---
type: foundation
status: implemented
created: 2026-11-08
updated: 2026-11-08
---

# Document standard

## Technical Goal

Define the format of one knowledge base document once, as a versioned written
standard, the Markdown Knowledge Base Document Standard (MKBDS). The skills and
any other tool follow this one text, so the format cannot drift between them.

## Dependents

- `personal-knowledge-base` — its document format rules follow MKBDS.
- `team-knowledge-base` — it shares the same rules through `src/common.md`.
- Other tools — any project may implement MKBDS.

## Deliverables

- `standard/mkbds-1.0.md`: the standard, with numbered sections, conformance classes, and annexes. It defines the root of a knowledge base through a marker folder, and it names no folder.
- `standard/conformance/`: a sample vault of valid documents (19 documents, from small to about 50 KB, covering different kinds of content, deprecated and disputed documents, links, callouts, and non-ASCII text) and a set of invalid documents, each named for the rule it breaks.
- `tests/check-document.sh`: a reference checker for the machine-checkable rules.
- `tests/standard.test.sh`: tests for the standard, the conformance set, and the match between the standard and the skills.

## Scope

**In scope:**
- One document: file name, frontmatter, body, links, sizes.
- The root of a knowledge base, defined by the marker folder `.mkbds`, which also holds the metadata and the configuration of the knowledge base. Its content is open.
- The fixed values and the configurable parameters.
- Compatibility with Obsidian, as a tested claim.
- Conformance classes for a document, a knowledge base, and a producer.

**Out of scope:**
- How an agent behaves (reading levels, write steps). That belongs to the skills.
- The layout of a repository outside the root folder of a knowledge base.
- A claim of recognition by a standards body.

## Constraints

- The standard is in English, in plain words, with "MUST", "SHOULD", and "MAY" used as defined in RFC 2119.
- The checker needs only a shell and `awk`.
- While the repository is private, the text does not call MKBDS an "open standard". It is a document owned by this project.
- The field table in the standard and the field table in the skills are identical text.
- A change to the standard raises its version and both skill versions.

## Acceptance Criteria

- **Given** the standard, **When** it is read, **Then** it has the sections scope, conformance, normative references, terms, knowledge base root and marker folder, document structure, frontmatter fields, links, size limits, configurable parameters, and Obsidian compatibility, and two annexes.
- **Given** a valid document of the conformance set, **When** the checker runs, **Then** it passes.
- **Given** an invalid document of the conformance set, **When** the checker runs, **Then** it fails and names the broken rule.
- **Given** the standard and a finished skill, **When** their field tables are compared, **Then** they are identical.
- **Given** the sample vault, **When** the tests run, **Then** it has at least 15 documents, at least 4 documents over 20 KB, and a deprecated, a disputed, and a superseding document, and every document passes the checker.
- **Given** a folder with a `.mkbds` folder, **When** a tool looks for the root, **Then** the first folder with a marker folder above the document is the root, and files excluded in `.mkbds/exclude`, hidden files, and hidden folders are not documents.
- **Given** the standard, **When** it is read, **Then** it names no folder for the documents.
- **Given** a wikilink in a property that names a missing document, **When** the checker runs, **Then** it fails.
- **Given** the sample vault, **When** it is opened in Obsidian, **Then** properties, links, tags, and the graph show without errors.

## Open Questions

None.
