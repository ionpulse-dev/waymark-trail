# Decisions: Personal knowledge base skill

_Records why technical choices were made. Never delete entries — add new ones as decisions are made. This file helps future AI sessions and developers understand settled choices without re-debating them._

---

## Hardcoded Manual defaults, no settings — 2026-11-08

**Decision:** Version 1 reads and writes only when the person asks. The skill holds no settings, no config file, and no path to the storage.

**Alternatives considered:**
- A config file next to the skill — updates overwrite the skill folder, and a copy in an `AGENTS.md` has no folder.
- A settings block in `AGENTS.md` — a committed `AGENTS.md` is the same for every person, and settings are personal.
- A personal config file at a fixed path — not available on web and iPhone, and it grows into a second waymark.
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

## Name without the project name — 2026-11-08

**Decision:** The skill is named `personal-knowledge-base`. The repository is named `waymark-trail`.

**Alternatives considered:**
- `waymark-*` skill names — the skill must stand on its own and must not suggest that it needs waymark.
- Generic names such as `knowledge-base` — likely to clash with other skills.

**Reason:** A descriptive, symmetrical pair with `team-knowledge-base`.
