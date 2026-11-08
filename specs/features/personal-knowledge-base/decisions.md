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

**Superseded by:** No `type` field (see `document-standard`) for the field `type` only.

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
- The skill stays below 14 KB (raised from 12 KB, see the decision on disputed and replaced documents).

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

## No `type` field — 2026-11-08

**Decision:** The skill has no `type` field. The standard removed it (see `document-standard`). The earlier list of required fields no longer contains `type`.

**Reason:** The list of types was never reviewed, and agents had no rule for choosing one.

## The skill finds the root with the marker file — 2026-11-08

**Superseded by:** The skill looks for the marker folder

**Decision:** The skill looks for the file `.mkbds` to find the root of the knowledge base. If it finds none, it asks the person where the knowledge base is and offers to create an empty marker file. It does not assume a folder name.

**Alternatives considered:**
- Assume a folder `knowledge/` — too opinionated.

**Reason:** See `document-standard`. The skill follows the standard.

## The skill looks for the marker folder — 2026-11-08

**Supersedes:** The skill finds the root with the marker file

**Decision:** The marker is the folder `.mkbds`. The skill looks for it, reads `.mkbds/exclude`, leaves unknown files in the folder alone, and offers to create `.mkbds/version` (with `1.0`) when it finds none.

**Reason:** See `document-standard`.

## Only secrets are forbidden — 2026-11-08

**Decision:** The skill refuses secrets and credentials only. It does not refuse personal data or customer data. When a text has a secret, the agent offers to write the document with a placeholder.

**Alternatives considered:**
- Refuse personal data and customer data too — a business has customers, and a team can be a family. A knowledge base is a place for such information, like a wiki.
- Let the shared `AGENTS.md` allow personal data — adds a rule that the agent has to look up, for no gain.

**Reason:** A leaked secret can be misused, and Git keeps it. Other information is the content that a knowledge base exists for. Access control belongs to the Git host.

## No stale threshold — 2026-11-08

**Decision:** There is no stale rule, no stale field, and no stale threshold. If `updated` is old, the agent checks the facts that matter and says how old the document is.

**Alternatives considered:**
- A fixed number of days — age is a weak signal, and `updated` also changes for small edits.
- A `stale` flag — it only says "I doubt this", and `disputed` with a reason already covers that.

**Reason:** The maintainer found the rule arbitrary and the flag unowned. This replaces the 180-day defaults of the earlier decisions.

## No change report at the start of a session — 2026-11-08

**Decision:** The agent does not report what changed at the start of a session, also in Automatic reading. The person can ask for it at any time.

**Alternatives considered:**
- A report with `git log --since` — the skill keeps no state, so the agent cannot know since when. It also costs context in every session.

**Reason:** The maintainer does not need it at startup. This replaces the line about `git log --since` in the earlier defaults decision.

## Clearing a disputed flag — 2026-11-08

**Decision:** When a disputed document is fixed or confirmed, the agent removes `disputed` and `dispute_reason`, sets `updated` and `updated_by`, and commits with `kb: update`. It asks first if someone else set the flag.

**Alternatives considered:**
- No rule — the flag would stay forever, and agents would keep calling a fixed document unreliable.

**Reason:** The maintainer asked for a way to close the dispute process.

## One section for disputed, deprecated, replaced, and deleted documents — 2026-11-08

**Decision:** The rules for these four cases are in one section of the skills, "Wrong, outdated, or replaced documents". The size limit of the personal skill is 14 KB, and of the team skill 16 KB.

**Alternatives considered:**
- Keep the rules spread over the field table, the reading rules, and the writing section — an agent had to join them, and the end of a dispute was missing.
- Keep 12 KB — the new section and the earlier rules did not fit.

**Reason:** An agent follows the nearest rule to its task, so each case needs its own place. The size limit is a judgment call.
