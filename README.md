<p align="center">
  <img src="banner.svg" alt="waymark-trail" width="800"/>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT"/></a>
  &nbsp;
  <img src="https://img.shields.io/badge/plain-Markdown-brightgreen" alt="Plain Markdown"/>
  &nbsp;
  <img src="https://img.shields.io/badge/works%20with-any%20AI%20agent-blueviolet" alt="Works with any AI agent"/>
</p>

<br/>


Skills that teach an AI agent to use a knowledge base of Markdown documents in
a Git repository, safely and with little context.

A knowledge base is a Git repository of Markdown documents. Without rules, an
agent may read too much, overwrite a newer document, or save something it should
not. A skill is one text file with the rules. You give your agent the file, and
it follows the rules. There is no app, no command line tool, and no server.

The trail is the line of marks that agents leave for the next agent.

**Contents:** [Skills](#the-skills) · [Quick start](#quick-start) ·
[Install](#install) · [Global install](#add-the-skill-globally) ·
[Document standard](#the-document-standard) · [Obsidian](#obsidian) ·
[Contributors](#for-contributors) · [License](#license) · [Warning](#warning)

## The skills

| Skill | For |
|:------|:----|
| [`personal-knowledge-base`](personal-knowledge-base/SKILL.md) | One person with their own knowledge base. |
| [`team-knowledge-base`](team-knowledge-base/SKILL.md) | A knowledge base that several people write to. |

Pick one. The team skill has everything the personal skill has, and adds rules
for shared repositories: every change has a clear author, and one person's
mistake does not break the others' documents.

Both skills work the same way:

- **Safe by default.** The agent reads and writes only when you ask.
- **Visible settings.** At first use in a session, the agent shows a table with
  the rows *Reading* and *Writing*. Each row is *Manual* (only when you ask) or
  *Automatic* (the agent decides). Both start at Manual. You change a row in
  plain words, for example "read automatically".
- **Little context.** The agent looks at the path, title, and description of a
  document first. It opens at most 5 documents for one question.
- **Safe writes.** Before it writes, the agent pulls the latest version and
  checks that the document did not change since it read it. It commits under
  your own Git name and email, never force pushes, deletes a document only when
  you ask (otherwise it marks it `disputed` or `deprecated`), and refuses to
  write secrets.

## Quick start

The easiest way: tell your agent, in a session in your knowledge base
repository:

```text
Read https://github.com/ionpulse-dev/waymark-trail and add the
personal-knowledge-base skill. Ask me whether it goes into this repository or
into my global skills, then do it and tell me what you added.
```

For a team, say `team-knowledge-base`. The agent reads this README, picks the
right folder for its own tool, saves the skill, adds the block to `AGENTS.md`,
and, if you want, creates the `.mkbds` marker folder. The repository must be
public, or the agent must have access to it.

To do it yourself, follow the steps below.

## Install

You need a Git repository for your knowledge base and an agent that can read an
`AGENTS.md` file. The skills work in a session started in that repository. This
is also the only way that works in Claude Code on the web and on iPhone.

### Step 1. Mark the knowledge base

Create a folder named `.mkbds` in the folder that holds your documents, with a
file `version` that says `1.0`. It can be the root of the repository or any
folder in it:

```bash
mkdir .mkbds && echo 1.0 > .mkbds/version
```

The skill finds your knowledge base by this folder. If there is no `.mkbds`, the
agent asks you where the knowledge base is.

If the root is the whole repository, `AGENTS.md` is also a Markdown file below
the root. Keep it out of the knowledge base with a file `.mkbds/exclude` (one
path per line):

```text
AGENTS.md
```

A folder whose name starts with `.`, such as `.agents/skills/`, is not part of
the knowledge base, so it needs no entry.

### Step 2. Add the skill

Tell your agent:

```text
Add the skill from this URL to this repository as
.agents/skills/personal-knowledge-base/SKILL.md, then tell me what you added:
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/personal-knowledge-base/SKILL.md
```

For a team knowledge base, use the team skill:

```text
Add the skill from this URL to this repository as
.agents/skills/team-knowledge-base/SKILL.md, then tell me what you added:
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/team-knowledge-base/SKILL.md
```

The agent gets the whole skill from this one URL. The URL works only when the
agent can read the repository, so it must be public or the agent must have
access.

### Step 3. Load it in every session

Add this block to the `AGENTS.md` in your knowledge base repository:

```markdown
## Knowledge base

At the start of every session, read and follow
`.agents/skills/personal-knowledge-base/SKILL.md`.
```

For a team, put the same block in the shared `AGENTS.md`, with
`.agents/skills/team-knowledge-base/SKILL.md`.

Claude Code reads `AGENTS.md` when the repository has no `CLAUDE.md`. If you
have a `CLAUDE.md`, add the line `@AGENTS.md` to it.

### Step 4. Check

Start a new session. The agent shows the settings table and tells you the skill
is active. If it does not, the block in `AGENTS.md` is missing or has the wrong
path.

### Pin a version

Each skill has its own version and its own tag, named
`<skill-name>-v<version>`. The URL in step 2 uses `main`, so it always gives the
newest version:

```text
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/personal-knowledge-base/SKILL.md
```

To pin a version, put the tag in the URL instead of `main`. The pattern is
`.../waymark-trail/<tag>/<skill-name>/SKILL.md`:

```text
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/personal-knowledge-base-v1.0.1/personal-knowledge-base/SKILL.md
```

Then use that URL in the prompt of step 2. The tags exist only after a release
is tagged; until then, use `main`.

### Use it without a file

The body of a skill (everything after the frontmatter) also works when you
paste it into an `AGENTS.md`. Then there is no separate skill file to load.

## Add the skill globally

A skill can also live in the global skill folder of your agent tool, in your
home folder, instead of in one repository. It then works in every project, and
you add it once for all your knowledge bases.

- **Claude Code:** `~/.claude/skills/personal-knowledge-base/SKILL.md`
- **Gemini CLI:** `~/.gemini/skills/personal-knowledge-base/SKILL.md`
- **Other tools:** each tool has its own global folder. Ask the agent to find
  it, or look in the documentation of the tool.

What to know:

- **Every session sees it,** also in projects with no knowledge base. There the
  skill asks where the knowledge base is, which can be a nuisance if you work in
  many unrelated repositories.
- **Loading is not certain.** Most tools load a skill when its description
  matches the task. To load it at the start of every session, add the block from
  step 3 to the global instruction file of your tool, with the path of the
  global skill.
- **It is not in the repository.** People who share the knowledge base do not
  get it. For a team, put the skill into the repository.
- **Updates are by hand.** Ask the agent to fetch the current file again.

## The document standard

The format of a document is written down in the
[Markdown Knowledge Base Document Standard](standard/mkbds-1.0.md) (MKBDS). It
has numbered sections, conformance rules, and valid and invalid example
documents in [standard/conformance/](standard/conformance/). The skills follow
it. Any other tool can follow it too.

In short:

- One topic per Markdown file, at most 100 KB.
- A short YAML header: title, description, status, dates, authors, and optional
  fields such as tags and links. The agent fills in the dates and authors itself.
- No fixed folder. A knowledge base is the folder that holds a marker folder
  named `.mkbds`. The root can be a whole repository or any folder in it.

## Obsidian

A knowledge base is also a valid [Obsidian](https://obsidian.md) vault. Open the
folder in Obsidian, and you get the Properties view, links, backlinks, the graph
view, tags, search, and the file explorer. The format is a stricter subset of
what Obsidian accepts, and the extra Obsidian features that people write in the
body (callouts, embeds, highlights, comments) are allowed and kept. The sample
vault in [standard/conformance/vault](standard/conformance/vault) is set up for
this.

The `.mkbds` marker folder works like Obsidian's `.obsidian` folder, which
marks a vault.

### Settings

By default Obsidian writes `[[wikilinks]]` with short paths. To make it write
relative Markdown links, put this in `.obsidian/app.json` (Settings, Files and
links: *Use Markdown links* on, *New link format* set to relative path):

```json
{
  "useMarkdownLinks": true,
  "newLinkFormat": "relative"
}
```

The other files in `.obsidian/` are your personal settings. A suggestion for
your `.gitignore`: keep only `app.json` in Git, so the link rule travels with
the repository and the rest stays yours.

```text
.obsidian/*
!.obsidian/app.json
```

If you use the agent to set up your knowledge base, tell it that you use
Obsidian, and it can create the file.

### Editing by hand

You can read, search, and edit documents in Obsidian. For changes, we recommend
that you let the agent do it, because the agent follows the rules every time.
Editing by hand can break these things:

- a required header field is missing, or a date has the wrong form;
- `updated` and `updated_by` are not changed;
- the title, description, or document is too long;
- a file is renamed or moved, so the ID and the Git history change;
- a link breaks, or Obsidian writes a link in another form;
- a secret is written, with no one to ask "are you sure?";
- the change is not committed or pushed, or it collides with someone else's.

If you edit by hand, ask the agent afterwards to check the document against the
standard.

## For contributors

Do not edit the finished `SKILL.md` files by hand. They are built from small
parts:

| Part | Content |
|:-----|:--------|
| `src/common.md` | Rules both skills share. |
| `src/personal.md`, `src/team.md` | What only one skill needs. |
| `src/frontmatter/*.yaml` | Name, description, and version of each skill. |
| `standard/` | The document standard and its conformance set. |

```bash
./build.sh                 # write both finished files
./build.sh --check         # fail if a finished file differs from the build
sh tests/build.test.sh     # tests for the build
sh tests/skills.test.sh    # tests for the text of the skills
sh tests/standard.test.sh  # tests for the standard and its conformance set
```

A change to `src/common.md` changes both skills, so raise both versions in the
same commit. A change to the standard also changes `src/common.md`, because the
field table must be identical. A GitHub Actions workflow runs the check on every
push.

The project follows a light spec-driven process. Read [AGENTS.md](AGENTS.md) and
[specs/WORKFLOW.md](specs/WORKFLOW.md) before you change anything.

## License

[MIT](LICENSE).

## Warning

An AI agent is not fully reliable, and these skills are only rules in text.
Nothing enforces them. A skill makes a good agent careful. It does not stop a
bad one. An agent can ignore a rule, misread one, or make a mistake. Know the
main risks before you use them:

- **Data loss.** A wrong write or a bad move can damage or lose a document. Git
  history helps only if you push and keep backups.
- **Leaks.** Once a document is pushed, everyone with access to the repository
  can read it. A team knowledge base shows every document to the whole team.
  Do not store secrets.
- **Wrong content.** The agent can write a document that is wrong, or rely on
  one that is wrong.

Keep backups, check what the agent commits, and use the access controls of your
Git host for real protection. You use the skills at your own risk, as the
[license](LICENSE) says.
