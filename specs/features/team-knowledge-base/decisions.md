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
