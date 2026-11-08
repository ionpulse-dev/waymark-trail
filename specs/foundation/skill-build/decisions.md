# Decisions: Skill build

_Records why technical choices were made. Never delete entries — add new ones as decisions are made. This file helps future AI sessions and developers understand settled choices without re-debating them._

---

## Two separate skills in one repository — 2026-11-08

**Decision:** The repository holds two skills, `personal-knowledge-base` and `team-knowledge-base`, each a normal `SKILL.md` with its own version.

**Alternatives considered:**
- One skill with a team section — loads team rules for every user, and a change to one part affects the other.
- Two repositories — more overhead for a small project.

**Reason:** A separate skill keeps the context small and keeps changes apart.

## Shared rules in parts, joined by a build — 2026-11-08

**Decision:** The shared rules live once in `src/common.md`. A script builds two finished, self-contained files. The finished files are committed.

**Alternatives considered:**
- Two hand-written files with a checklist — the shared rules would drift apart.
- A shared file that a skill reads at run time — a skill is installed by copying one file, and an `AGENTS.md` copy cannot include other files.

**Reason:** No drift, and each finished file works with a single URL.

## Installed by URL — 2026-11-08

**Decision:** The main way to install a skill is to tell the agent: add the skill from this URL. The README has a copy-paste prompt. A tag in the URL pins a version.

**Alternatives considered:**
- A package manager or registry — more setup, no benefit for a single text file.

**Reason:** This is how people already add skills.

## One version and one tag per skill — 2026-11-08

**Decision:** Each skill has its own version, kept in its frontmatter file. Each skill has its own Git tag, named `<skill-name>-v<version>`, for example `personal-knowledge-base-v1.0.0`. A pinned URL uses that tag. A change to `src/common.md` bumps both versions.

**Alternatives considered:**
- One version for the whole repository — simpler, but a small change to one skill forces a new version on the other.

**Reason:** It matches the decision that the skills are separate, and a person can pin one skill without the other.

## Versions are raised by the agent, not by the build — 2026-11-08

**Decision:** The build never changes a version. The agent that changes `src/common.md` raises both versions in the same commit. There is no `--bump` command.

**Alternatives considered:**
- A `build.sh --bump` step — an extra command for the maintainer to learn and run.
- A bump in every build — the output would change on each run, and `--check` could not compare it.

**Reason:** The maintainer does no version work, and the build stays simple.

## GitHub Actions runs the check — 2026-11-08

**Decision:** A GitHub Actions workflow runs `build.sh --check` on every push and pull request.

**Alternatives considered:**
- Another CI service — more setup, and the repository is public on GitHub.

**Reason:** It is free, needs one small file, and needs no extra account.

## Skill names and repository name — 2026-11-08

**Decision:** The repository is `waymark-trail`. The skills are `personal-knowledge-base` and `team-knowledge-base`.

**Alternatives considered:**
- `waymark-kb`, `waymark-memory`, `waymark-vault`, `waymark-wiki` for the repository — `waymark-trail` fits the story: the trail is the line of marks that agents leave.
- A name that contains the storage technology — rejected by the maintainer.

**Reason:** The repository carries the project name. The skills carry descriptive names, so they stand on their own.

## License MIT, copyright holder the company — 2026-11-08

**Decision:** MIT. The copyright holder is the company that owns the repository. The skill file starts with a one-line license header.

**Alternatives considered:**
- The Unlicense or CC0 — the rights of an author cannot be fully waived in some countries, and the Unlicense has no fallback license.

**Reason:** MIT is well known, companies accept it, and it matches the main project. The header keeps the notice when the text is copied.

## No license header in the skill file — 2026-11-08

**Decision:** The skill file has no license line. The `LICENSE` file of the repository covers it. This replaces the one-line license header of the decision above.

**Alternatives considered:**
- A `license: MIT` field in the frontmatter — not needed, the maintainer chose no replacement.

**Reason:** The line was only half a notice, and it cost the agent a line of context in every session.

## The skills live in the content repository — 2026-11-08

**Decision:** The skills are part of the knowledge base repository. A session started there is the simplest use, and the only one that works on the web and on iPhone.

**Alternatives considered:**
- Skills installed at user level with a stored path and settings — needs a personal file that differs per tool and does not exist on web and iPhone.

**Reason:** Clear split between the full project and the standalone skills, and nothing to configure.
