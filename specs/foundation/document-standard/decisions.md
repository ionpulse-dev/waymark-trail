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

## Six document types, no `team` type — 2026-11-08

**Superseded by:** No `type` field

**Decision:** The default list of `type` has six values: `fact`, `decision`, `contract`, `howto`, `glossary`, and `gotcha`. The value `team` was removed. It belonged to the `_team.md` convention, which was rejected during the design phase. The folder structure may mirror the team structure, and the standard does not care. The versions stay as they are, because the project is in the pre-release stage.

**Alternatives considered:**
- Keep `team` as an unused value — it invites a convention that nobody wants.

**Reason:** The standard should hold only what is used.

## No `type` field — 2026-11-08

**Supersedes:** Six document types, no `team` type

**Decision:** The standard has no `type` field and no list of document types. The list came from an unreviewed draft, and agents had no rule for choosing a type. The field was removed from the standard, the skills, the checker, the tests, and the sample documents. The versions stay as they are, because the project is in the pre-release stage.

**Alternatives considered:**
- Make `type` optional — it keeps an unreviewed list in the standard.
- Keep it required and define the six values — it makes the unreviewed list official.

**Reason:** The standard should hold only what the project decided. A field can be added later in a new version.

## The root is defined by a marker file, not by a folder name — 2026-11-08

**Superseded by:** The marker is a folder

**Decision:** A knowledge base has a root: the folder that contains a file named `.mkbds`. The ID of a document is its path below the root. The marker file may be empty. It may list files and folders that are not documents. The standard names no folder, so the earlier requirement for a `knowledge/` folder is gone. The idea of "the folder is the owner" is also gone, because the team decides how it uses folders.

**Alternatives considered:**
- A fixed folder `knowledge/` — too opinionated.
- A setting that names the folder — needs a place for settings, and it is not discoverable.
- A path in `AGENTS.md` — the standard would depend on a file that it does not define.

**Reason:** The same idea as Obsidian's `.obsidian` folder: one small file marks the root. It works for a whole repository and for a subfolder. The name is open and not tied to any tool.

## The marker is a folder that holds the metadata and the configuration — 2026-11-08

**Supersedes:** The root is defined by a marker file, not by a folder name

**Decision:** The marker is a folder `.mkbds`, not a file. The folder holds every kind of metadata and configuration of the knowledge base, and its content is open. This version defines two files: `version` (required) with the version of the standard, and `exclude` (optional) with the paths that are not documents. A tool keeps its own files in the folder, preferably in a subfolder with its name, and other tools ignore them. Files and folders whose names start with `.` are not part of the knowledge base. The earlier idea of a TOML marker file with settings is dropped.

**Alternatives considered:**
- A marker file in TOML with a fixed set of keys — the standard would have to define the settings of every tool.
- An empty marker folder — Git does not store empty folders, so a file is required.

**Reason:** One place for everything that describes the knowledge base, without a standard that fixes its content. Local state of a tool, such as a lock, is not part of the knowledge base and stays outside the committed folder.
