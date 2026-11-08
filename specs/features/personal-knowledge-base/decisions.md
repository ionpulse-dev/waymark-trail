# Decisions: Personal knowledge base skill

_Records why technical choices were made. Never delete entries — add new ones as decisions are made. This file helps future AI sessions and developers understand settled choices without re-debating them._

---

## Hardcoded Manual defaults, no settings — 2026-11-08

**Decision:** Version 1 reads and writes only when the person asks. The skill holds no settings, no config file, and no path to the storage.

**Alternatives considered:**
- A config file next to the skill — updates overwrite the skill folder, and a copy in an `AGENTS.md` has no folder.
- A settings block in `AGENTS.md` — a committed `AGENTS.md` is the same for every person, and settings are personal.
- A personal config file at a fixed path — not available on web and iPhone, and it grows into a full tool.
- Reading and writing "ask always" in the sense of "confirm" — the agent would decide what to write. Manual is the stricter and simpler default.

**Reason:** A hardcoded default works in every tool and every place, including Claude Code on the web and iPhone. The person can still change it for one session in plain words.

## A table as the start message — 2026-11-08

**Decision:** The start message is a 2×2 table: rows Reading and Writing, columns Manual and Automatic, a dot in the active cell, and the line "Want a different setting? Just tell me."

**Alternatives considered:**
- A bulleted text with levels and explanations — too long and too technical for non-developers.
- A command word such as `kb read auto` — too technical.
- "Autonomous" as the column name — hard to read and to write. "Automatic" is simpler.

**Reason:** A table is understood at a glance. Plain words need no command syntax.

## Settings are changed in plain words — 2026-11-08

**Decision:** No command word. The agent accepts natural phrases at any time, asks if a phrase is unclear, and shows the table again after each change, after a question, and after a context compaction.

**Alternatives considered:**
- A fixed command word — rejected as too technical for people who are not developers.

**Reason:** A frontier model understands plain phrases. Showing the table again makes a misunderstanding visible and keeps the state in the recent context.

## The person starts the skill with a block in AGENTS.md — 2026-11-08

**Decision:** The skill does not start itself. The person adds a short block to an `AGENTS.md` that says to load the skill at the start of every session. The README shows two examples: one for the knowledge base repository itself and one for a code project or a personal instruction file that points to the repository path. The block does not ask for an announcement, because the skill announces itself.

**Alternatives considered:**
- Rely on the description of the skill alone — loading is not deterministic.
- A hook per tool — differs per tool.

**Reason:** One short, tool-neutral block. All agent tools read `AGENTS.md`. (To verify before the README claims it for Claude Code.)

## Document fields, set by the agent — 2026-11-08

**Decision:** Every document has the required fields `title`, `description`, `type`, `status`, `created`, `updated`, `created_by`, and `updated_by`. The optional fields are `disputed`, `dispute_reason`, `sources`, `tags`, `related`, `supersedes`, and `anchors`. The agent sets the dates and the authors itself, from today's date and the person's Git name and email.

**Alternatives considered:**
- Make the dates and authors optional and rely on Git history — the author would not be visible inside the document, for example in Obsidian, and the team skill needs a clear author.

**Reason:** Documents stay in one format with or without a CLI, and the author is visible in the document.

## The document format is fixed and complete — 2026-11-08

**Superseded by:** The format follows MKBDS

**Decision:** The skill carries the complete document format: all fields, file names, IDs, links, and size limits. The section "Document format" in `requirements.md` is the specification. A change to it needs the same change in `src/common.md` and a version bump.

**Alternatives considered:**
- A smaller subset of fields — a knowledge base would behave differently with and without the skill, and documents written by the skill could fail the checks of other tools that use the same format.

**Reason:** One format everywhere, so documents are portable between tools.

## Name without the project name — 2026-11-08

**Decision:** The skill is named `personal-knowledge-base`. The repository is named `waymark-trail`.

**Alternatives considered:**
- Skill names with the project prefix — the skill must stand on its own and must not suggest that it needs another tool.
- Generic names such as `knowledge-base` — likely to clash with other skills.

**Reason:** A descriptive, symmetrical pair with `team-knowledge-base`.

## Description text of the skill — 2026-11-08

**Decision:** The description is: "Rules for reading and writing the Markdown knowledge base in this repository. Load at the start of every session."

**Alternatives considered:**
- A longer description that lists the rules — it costs context in every session and does not make loading more reliable.

**Reason:** It names the job and the moment to load, in one sentence. The start block in `AGENTS.md` does the real work, because loading is not deterministic.

## Defaults for the details the format leaves open — 2026-11-08

**Decision:**
- A document is stale after 180 days.
- Reading is limited to 5 documents and about 800 tokens per question.
- The commit message starts with `kb:` followed by the action and the title, for example `kb: add "Payment API v3 uses idempotency keys"`. It has no tag for the agent.
- The agent compares the last commit of a document with the one it remembered, instead of a hash.
- When the person asked for Automatic reading, the agent tells the person what changed at the start of a session, using `git log --since`.
- The skill stays below 12 KB.

**Alternatives considered:**
- No limits on reading — the agent would load too much context.
- A fixed commit text with the word "agent" — rejected, because the person is the author and no agent is named.

**Reason:** Small, safe defaults that work with plain Git and need no tool.

## Starting with `CLAUDE.md` — 2026-11-08

**Decision:** The README says: if your agent reads `CLAUDE.md` instead of `AGENTS.md`, create a `CLAUDE.md` with the single line `@AGENTS.md`.

**Alternatives considered:**
- Claim that every tool reads `AGENTS.md` — not verified for every tool.

**Reason:** The import line works without a claim about each tool.

## The format follows MKBDS — 2026-11-08

**Supersedes:** The document format is fixed and complete

**Decision:** The document format is defined in the Markdown Knowledge Base Document Standard (`standard/mkbds-1.0.md`). The requirements no longer repeat the rules. The skill carries them in short form, and a test compares the field tables.

**Reason:** One source of truth for the format (see `document-standard`).
