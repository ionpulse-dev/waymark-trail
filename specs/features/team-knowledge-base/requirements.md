---
type: feature
status: draft
created: 2026-11-08
updated: 2026-11-08
requires:
  - skill-build
---

# Team knowledge base skill

## User Story

> As a member of a team, I want my AI agent to use our shared knowledge base safely, so that the whole team gets durable knowledge and every change has a clear author.

## Personas

- **Team member** — uses the shared knowledge base with their own agent and is responsible for what the agent writes under their name.
- **Maintainer of a knowledge base** — wrote the shared `AGENTS.md` that loads the skill.

## Behaviour

The skill is one file, `team-knowledge-base/SKILL.md`. It has everything the
personal skill has (same start message, same autonomy table, same defaults,
same document and write rules, from the shared `src/common.md`). It adds the
rules for a knowledge base that several people write to.

### Start message

Like the personal skill, with one more line under the table:

> **Knowledge base active:** `<name of the repository>` (shared with your team)
>
> | | Manual (only when you ask) | Automatic (I decide) |
> |---|---|---|
> | **Reading** | ● | |
> | **Writing** | ● | |
>
> Every change is committed under your name. Everyone with access sees every document.
>
> Want a different setting? Just tell me.

### Added team rules

- **The person is responsible.** Every write is committed under the person's own Git name and email. A reachable email is required. There is no separate agent author.
- **Folders are owners.** The folder of a document is the team that owns it. The agent lists the folder tree when it needs it. The shared `AGENTS.md` does not list folders.
- **Fixing wrong documents.** An agent that finds a document that contradicts the code or another document marks it `disputed` with a reason, or deprecates it when it is no longer true. It does not silently rewrite another team's document. A deprecated document stays in the repository.
- **Stale documents.** A document nobody changed for a long time is treated as a hint and checked before it is used.
- **Confidentiality.** Everyone with read access sees every document. The agent never writes secrets, credentials, customer data, or personal data. If it is unsure, it asks the person.
- **Concurrent writes.** Pull before writing. If two versions of the same document collide, keep both as separate files and tell the person. Never leave the repository in a conflict state.

## Interfaces & Contracts

The finished file `team-knowledge-base/SKILL.md` has the same shape as the
personal skill: frontmatter with `name: team-knowledge-base`, a `description`,
and a `version`, then a license header line and a plain Markdown body with no
includes.

## Acceptance Criteria

- **Given** a new session in a repository whose `AGENTS.md` loads the skill, **When** the agent first uses the skill, **Then** it shows the start message with both rows at Manual and the line about commits and visibility.
- **Given** the behaviour shared with the personal skill, **When** the same situation occurs, **Then** the team skill behaves the same way.
- **Given** the agent writes a document, **When** it commits, **Then** the commit author is the person's own name and a reachable email.
- **Given** the agent finds a document that contradicts the code, **When** the person agrees to act, **Then** the agent sets `disputed` with a reason and does not delete the document.
- **Given** a document contains something that looks like a secret or personal data, **When** the agent is about to write it, **Then** it stops and asks the person.
- **Given** two versions of one document collide, **When** the agent syncs, **Then** it keeps both versions as two files and reports it.

## Constraints & Edge Cases

- Nothing enforces the skill. It is a set of rules in text. The README must say so.
- No settings file in the first version. The default is Manual for reading and writing.
- The team skill must stay small. It adds only what a shared repository needs.
- The shared `AGENTS.md` is the same for everyone, so it holds no personal settings.

## Open Questions

- Which stale threshold does the skill name, and where does a team change it?
- Does the skill need a rule for who may deprecate another team's document?
- How does a person get the same autonomy settings in every session, once a personal settings file exists (see Post-MVP in `PROJECT.md`)?
