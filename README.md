# waymark-trail

Skills that teach an AI agent to use a knowledge base of Markdown documents in
a Git repository, safely and with little context.

A knowledge base is a Git repository of Markdown documents (an Obsidian vault
works too). Without rules, an agent may read too much, overwrite a newer
document, or save something it should not. A skill is a text file with the
rules. You give your agent the file, and it follows the rules.

There is no app, no command line tool, and no server. A skill is one file.

The trail is the line of marks that agents leave for the next agent.

> **Status: version 1.0.0, not yet tested with real agents.** Both skills are
> written and the automatic tests pass. The checks with a real agent session are
> still open. The specification is in [specs/](specs/).

## The two skills

| Skill | For |
|:------|:----|
| [`personal-knowledge-base`](personal-knowledge-base/SKILL.md) | One person with their own knowledge base. |
| [`team-knowledge-base`](team-knowledge-base/SKILL.md) | A knowledge base that several people write to. |

Pick one. The team skill has everything the personal skill has, and adds rules
for shared repositories: every change has a clear author, and one person's
mistake does not break the others' documents.

### How they behave

- **Safe by default.** The agent reads and writes only when you ask.
- **Visible settings.** At first use in a session, the agent shows a small table
  with the rows *Reading* and *Writing*. Each row is *Manual* (only when you
  ask) or *Automatic* (the agent decides). Both start at Manual. You change a
  row in plain words, for example "read automatically".
- **Little context.** The agent looks at the path, title, and description of a
  document first. It opens the full text only when that is worth it. It opens
  at most 5 documents for one question.
- **One fixed document format.** Every document is one topic in a Markdown file,
  with a short YAML header (title, description, type, status, dates, authors,
  and optional fields such as tags and links). A document is at most 100 KB.
  The agent fills in the dates and the authors itself. The format works as an
  Obsidian vault.
- **Safe writes.** Before it writes, the agent pulls the latest version and
  checks that the document did not change since it read it. It commits under
  your own Git name and email, never force pushes, never deletes a document
  (it marks it `disputed` or `deprecated`), and refuses to write secrets or
  personal data.

### What they cannot do

The skills are rules in text. Nothing enforces them. A skill makes a good agent
careful. It does not stop a bad one. Keep backups, and use the access controls
of your Git host for real protection.

## Install

You need a Git repository for your knowledge base and an agent that can read an
`AGENTS.md` file. The skills work in a session started in that repository. This
is also the only way that works in Claude Code on the web and on iPhone.

**Step 1. Add the skill.** Tell your agent, in a session in your knowledge
base repository:

```text
Add the skill from this URL to this repository, then tell me what you added:
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/personal-knowledge-base/SKILL.md
```

For a team knowledge base, use the team skill:

```text
Add the skill from this URL to this repository, then tell me what you added:
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/team-knowledge-base/SKILL.md
```

The agent gets the whole skill from this one URL. It needs no second file.
The URL works for an agent only when the agent can read the repository, so the
repository must be public or the agent must have access.

**Step 2. Load it in every session.** Add this block to the `AGENTS.md` in your
knowledge base repository, with the path where the agent saved the skill:

```markdown
## Knowledge base

At the start of every session, read and follow
`personal-knowledge-base/SKILL.md`.
```

For a team, put the same block in the shared `AGENTS.md`, with
`team-knowledge-base/SKILL.md`.

If your agent reads `CLAUDE.md` instead of `AGENTS.md`, create a `CLAUDE.md`
with the single line `@AGENTS.md`.

**Step 3. Check.** Start a new session. The agent shows the settings table and
tells you the skill is active. If it does not, the block in `AGENTS.md` is
missing or has the wrong path.

### Pin a version

Each skill has its own version and its own tag, named
`<skill-name>-v<version>`. To pin a version, put the tag in the URL instead of
`main`:

```text
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/personal-knowledge-base-v0.1.0/personal-knowledge-base/SKILL.md
```

### Use it without a file

The body of a skill (everything after the frontmatter) also works when you
paste it into an `AGENTS.md`. Then there is no separate skill file to load.

## For contributors

Do not edit the finished `SKILL.md` files by hand. They are built from small
parts:

| Part | Content |
|:-----|:--------|
| `src/common.md` | Rules both skills share. |
| `src/personal.md`, `src/team.md` | What only one skill needs. |
| `src/frontmatter/*.yaml` | Name, description, and version of each skill. |

```bash
./build.sh           # write both finished files
./build.sh --check   # fail if a finished file differs from the build
sh tests/build.test.sh     # tests for the build
sh tests/skills.test.sh    # tests for the text of the skills
```

A change to `src/common.md` changes both skills, so raise both versions in the
same commit. A GitHub Actions workflow runs the check on every push.

The project follows a light spec-driven process. Read
[AGENTS.md](AGENTS.md) and [specs/WORKFLOW.md](specs/WORKFLOW.md) before you
change anything.

## License

[MIT](LICENSE).
