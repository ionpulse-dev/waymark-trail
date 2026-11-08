# Decisions: Team knowledge base skill

_Records why technical choices were made. Never delete entries — add new ones as decisions are made. This file helps future AI sessions and developers understand settled choices without re-debating them._

The decisions about the start message, the autonomy table, the hardcoded
Manual defaults, and the start block in `AGENTS.md` are the same as in
[the personal skill](../personal-knowledge-base/decisions.md).

---

## A separate skill, not a team section in one file — 2026-11-08

**Decision:** The team rules are a separate skill, `team-knowledge-base`, not a section at the end of the personal skill.

**Alternatives considered:**
- One skill with a "shared repositories" section — the agent would load team rules in every personal session, and a change to the team part would affect single users.

**Reason:** A separate skill keeps the context small for a single user, and a change to one skill never affects the other. The shared rules are written once, in the build parts (see `skill-build`).

## One extra line in the start message — 2026-11-08

**Decision:** The start message is the same table. The team skill adds one line: every change is committed under your name, and everyone with access sees every document.

**Alternatives considered:**
- A longer message about visibility, responsibility, and secrets — too long. The rules themselves are in the skill body.

**Reason:** The two facts that matter most in a team are shown once, in a form that is quick to read.

## The person is the author, there is no agent attribution — 2026-11-08

**Decision:** Commits and documents record only the person. There is no agent field and no agent trailer.

**Alternatives considered:**
- A field for the agent or tool name — the skill cannot detect the calling tool reliably, and a self-reported name can be wrong.

**Reason:** In a team the person is responsible, as in a wiki. Git history shows who changed what.

## Defaults for the team rules — 2026-11-08

**Decision:**
- The stale threshold is 180 days. A shared `AGENTS.md` may name another number.
- Anyone may dispute a document. Deprecating or replacing a document of another team needs a clear "yes" from the person.
- The skill lists address parts that are not reachable and stops when the commit address contains one. A shared `AGENTS.md` may name allowed email domains.
- In a collision, the remote version stays in the original file. The person's version is saved as `<file-name>-conflict.md`, marked `disputed` with a reason.
- The skill stays below 16 KB.

**Alternatives considered:**
- Only the owning team may deprecate its documents — the skill cannot know who is on which team.
- Numbered file names such as `-2.md` for the second version — they do not say why the file exists. A disputed file with a reason does.

**Reason:** Safe defaults that need no tool and no settings file. A team that wants other values changes its shared `AGENTS.md`.

## No folder ownership — 2026-11-08

**Decision:** The skill does not say that the folder of a document is its owner. The team decides how it uses folders. The agent reads the folder tree and puts a new document where similar documents are.

**Alternatives considered:**
- The folder is the owning team — too opinionated for a standard format.

**Reason:** The standard does not care about the folder structure (see `document-standard`).
