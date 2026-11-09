# waymark-trail — Product Overview

## Vision

waymark-trail is long-term memory and a knowledge base for AI agents, as plain
Markdown in a Git repository. It has two parts: an open document standard
(MKBase) and a pair of skills. A skill tells the agent how to read and write a
knowledge base of Markdown documents safely and with little context. It needs no
app, no CLI, and no server. A person gives the agent the URL of one skill file.
The skills are standalone.

The trail is the line of marks that agents leave for the next agent.

## Personas

### Private person

Keeps a personal knowledge base in a repository they own. Uses it from a
computer and from Claude Code on the web or on iPhone. Success: the agent reads
and writes the knowledge base only when asked, and never damages it.

### Team member

Works in a team that shares one knowledge base repository. Success: the agent
follows the team conventions, every change has a clear author, and one person's
mistake does not break the others' documents.

### Maintainer of a knowledge base

Creates the repository and its `AGENTS.md`. Success: an agent that opens the
repository by chance finds clear rules.

_A single user may play more than one persona._

## Core Concepts

### Skill

A `SKILL.md` file with a `name`, a `description`, and a version in the
frontmatter, and a plain Markdown body. The body also works when it is pasted
into an `AGENTS.md`. A finished skill is complete on its own and has no
includes, so one URL is enough to install it.

### Document standard

The format of one document is defined once, in the Markdown Knowledge Base
Document Standard (MKBase), `standard/mkbase-1.0.md`. The skills follow it. A
conformance set and a reference checker make the rules testable. A knowledge base is the folder that holds a marker folder `.mkbase`. The marker folder holds the metadata and the configuration, and its content is open. The standard names no folder for the documents.

### Parts and build

The rules that both skills share live once, in `src/common.md`. Each skill has
its own part and its own frontmatter. A build script joins them into two
finished files. The finished files are committed.

### Start of a skill

The person adds a short block to an `AGENTS.md` that tells the agent to load the
skill at the start of every session. The skill then tells the person that it is
active.

### Autonomy table

At first use in a session, the skill shows a small table: rows Reading and
Writing, columns Manual (only when you ask) and Automatic (I decide), a dot in
the active cell. Both rows start at Manual. The person changes a row in plain
words.

## Design Principles

- **Stateless** — a skill holds no settings and no paths to storage.
- **Safe by default** — the agent reads and writes only when asked.
- **Plain words** — no commands, no jargon. A frontier model understands them.
- **One source of truth** — shared rules exist once.
- **Independent** — needs no other tool, no app, and no server.
- **Honest about limits** — the skills are rules in text. Nothing enforces them.

## Scope

**In scope:**
- The two skills and their shared rules.
- The document standard (MKBase), its conformance set, and its checker.
- The build script and the install-by-URL instructions.
- The examples for the start block in `AGENTS.md`.

**Out of scope:**
- A CLI, an app, or a server.
- A settings file or a config store (see Post-MVP).
- Enforcement of any rule.

**Where the skills work:** the skills live inside the content repository. The
simplest use is a session started in that repository. This is also the only way
that works in Claude Code on the web and on iPhone. A session in another
folder can use them if its `AGENTS.md` points to the repository.

## Post-MVP

_Capabilities intentionally deferred. No specs exist yet — this section is a reminder only._

- `personal-settings-file` — a personal config file for the team skill with the path and levels per knowledge base.
- `ask-first-level` — a third column "Ask first" for writing.
- `team-ceiling` — a line in the shared `AGENTS.md` for the loosest level a team allows.
