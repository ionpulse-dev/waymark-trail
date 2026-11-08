# Decisions: Document standard

---

## The format is a versioned written standard — 2026-11-08

**Decision:** The document format is defined once, in `standard/mkbds-1.0.md`. The skills follow it and carry the rules in short form.

**Alternatives considered:**
- Copy the rules into each project and keep them in step by hand — they drift.
- Merge the projects into one repository — it removes the sync problem, but it couples a standalone public skill to another project.

**Reason:** One source of truth. Other projects can adopt the same format.

## Name: Markdown Knowledge Base Document Standard — 2026-11-08

**Decision:** The full name is Markdown Knowledge Base Document Standard. The short form is MKBDS, used in file names and version references (`mkbds-1.0.md`, "conforms to MKBDS 1.0"). The version is part of the file name, so old versions stay readable.

**Alternatives considered:**
- Knowledge Base Document Format (KBDF) — shorter, less descriptive.
- Trail Document Format — ties the standard to this project's name.
- FORMAT.md — does not read like a standard.

**Reason:** The name says what the thing is.

## No "open standard" claim yet — 2026-11-08

**Decision:** While the repository is private, the text does not use the words "open standard". It is a document owned by this project. The words can be added when the repository is public and the license and the change process are stated.

**Reason:** "Open" is a claim about publication, not about the text.

## Obsidian is a tested claim, not a normative reference — 2026-11-08

**Decision:** Obsidian has no formal specification. The standard refers to CommonMark, YAML 1.2, and UTF-8 as normative references. Compatibility with Obsidian is a tested claim for a named version, checked by hand with the sample vault. The format is a stricter subset of what Obsidian accepts, and it tolerates Obsidian extras in the body.

**Alternatives considered:**
- Name Obsidian as a normative reference — it would bind the standard to a product that changes without notice.

**Reason:** The standard stays stable, and the claim stays honest.

## Exact word limits — 2026-11-08

**Decision:** The defaults are "at most 15 words" for the title and "at most 50 words" for the description. They were "about" before.

**Reason:** A checker needs an exact number. A knowledge base may change the number (see the configurable parameters).
