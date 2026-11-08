---
type: feature
status: implemented
created: 2026-11-08
updated: 2026-11-08
requires:
  - skill-build
---

# Personal knowledge base skill

## User Story

> As a private person, I want my AI agent to use my own knowledge base of Markdown documents safely, so that my memory is mine and lasts across all my AI tools.

## Personas

- **Private person** — owns the repository and decides what the agent may do.
- **Maintainer of a knowledge base** — wrote the `AGENTS.md` that loads the skill.

## Behaviour

The skill is one file, `personal-knowledge-base/SKILL.md`. It needs no app, no
CLI, and no server. It works in a session started in the knowledge base
repository, also in Claude Code on the web and on iPhone.

### Start message

At first use in a session, the agent shows this and nothing more:

> **Knowledge base active:** `<name of the repository>`
>
> | | Manual (only when you ask) | Automatic (I decide) |
> |---|---|---|
> | **Reading** | ● | |
> | **Writing** | ● | |
>
> Want a different setting? Just tell me.

### Changing a setting

The person changes a row in plain words at any time, for example "read
automatically" or "read from the knowledge base automatically". The change
lasts for the session. After a change, after a question about the settings, and
after the context is compacted, the agent shows the table again. If a phrase is
unclear, the agent asks which row the person means.

### Reading and writing rules

Both rules are part of the shared rules (`src/common.md`) and are specified in
the foundation item `skill-build`. The skill covers:

- Document format: the fixed format in "Document format" below. The agent sets the dates and the authors itself, from today's
  date and the person's Git name and email.
- Reading: look at the path, title, and description first. Open the body only
  when it is worth it.
- Writing: pull before writing, never overwrite a newer version, commit under
  the person's own name, never write secrets.
- Editing and moving: moves keep the history of a document and fix the links.
- What is worth a document: true in three months, useful to someone else,
  no status updates, no chat summaries.

### Document format

This format is fixed. It is written out here in full, so a knowledge base works
the same everywhere the format is used. A change to this section changes
`src/common.md` too, and raises both versions.

- UTF-8 Markdown, LF line ends, `.md` extension. One topic per document.
- File names use lowercase letters, digits, and `-` only. They never contain `# ^ [ ] | : * " < > ? \ /`. The file name never changes, also when the title changes.
- The ID of a document is its path under `knowledge/` without `.md`.
- Frontmatter is flat YAML. Values are text, number, checkbox, date (`YYYY-MM-DD`), or a list of strings. No nested objects.
- Links in the body are relative Markdown links with `.md`, or wikilinks. The agent writes relative Markdown links. Links in properties are wikilinks with the full path, for example `"[[backend/payments/retry-policy]]"`.
- No document stores its backlinks, and there is no central index file.
- Size limits: `title` about 15 words, `description` about 50 words, whole document 100 KB hard cap. If a document would exceed the cap, the agent splits it or moves details into a linked source.
- Tags are the `tags` property, never inline `#tags` written by the agent.
- Callouts, embeds, highlights, and comments written by people are allowed.

| Field | Required | Meaning |
|---|---|---|
| `title` | yes | One sentence, about 15 words. |
| `description` | yes | What the document contains and when to read it. About 50 words. |
| `type` | yes | `fact`, `decision`, `contract`, `howto`, `glossary`, `team`, or `gotcha`. |
| `status` | yes | `active` or `deprecated`. |
| `created`, `updated` | yes | Dates. |
| `created_by`, `updated_by` | yes | Text `"Name <email>"`. |
| `disputed` | no | Checkbox. `true` when someone found the document wrong. |
| `dispute_reason` | no | Text. Set together with `disputed: true`. |
| `sources` | no | List of strings: ticket IDs or URLs. |
| `tags` | no | List of strings, no `#`, no spaces. |
| `related` | no | List of full-path wikilinks: read these too. |
| `supersedes` | no | List of full-path wikilinks: this document replaces an older one. The older one becomes `deprecated`. |
| `anchors` | no | List of strings `"<type>:<target>"` that point to the code or page the document describes. Types: `git` (`<repo>/<path>@<commit>`) and `url`. |
| `trust`, `verified_by`, `verified` | no | Only when the knowledge base turns on verification. `trust` is `unverified` or `verified`. |

## Interfaces & Contracts

The finished file `personal-knowledge-base/SKILL.md`:

```yaml
---
name: personal-knowledge-base
description: <one sentence: what the skill does and when to load it>
version: <semantic version>
---
```

followed by a license header line and a plain Markdown body. No includes, no
tool-specific syntax. A person installs it by giving the agent the URL of the
file. The same body can be pasted into an `AGENTS.md`.

## Acceptance Criteria

- **Given** a new session in a repository whose `AGENTS.md` loads the skill, **When** the agent first uses the skill, **Then** it shows the start message with both rows at Manual.
- **Given** reading is Manual, **When** the person does not ask about the knowledge base, **Then** the agent does not search or open documents.
- **Given** writing is Manual, **When** the person does not ask for a write, **Then** the agent does not create, change, or move documents.
- **Given** the person says "read automatically", **When** the agent answers, **Then** it shows the table with the dot in the Automatic cell of the Reading row and the Writing row unchanged.
- **Given** the context was compacted, **When** the next message arrives, **Then** the agent shows the table again.
- **Given** a write request, **When** the agent writes, **Then** it pulls first, checks that the document did not change since it read it, commits under the person's name, and writes no secrets.
- **Given** a document would exceed the size cap, **When** the agent writes it, **Then** it splits the document or moves details into a linked source.
- **Given** a document the agent wrote, **When** it is checked against the section "Document format", **Then** every rule in "Document format" holds: fields, names, links, and sizes.
- **Given** the skill file is opened on its own, **When** it is read, **Then** it contains everything needed, with no include and no mention of a settings file.

## Constraints & Edge Cases

- Nothing enforces the skill. It is a set of rules in text. The README must say so.
- No settings file, no stored path, no CLI call.
- The default is Manual for reading and writing. There is no "Ask first" column in the first version.
- The skill must stay short, because it loads into the context of every session.
- A person who wants other defaults edits their own copy of the skill text.

## Open Questions

None.
