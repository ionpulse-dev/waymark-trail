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

<p align="center"><strong>Long-term memory and a knowledge base for AI agents.</strong></p>

<p align="center">Plain Markdown in a Git repository you own.<br/>No app, no command line tool, no server.</p>

---

<br/>

## What it is

- **An open document standard.** The
  [MKBase Document Standard](standard/mkbase-1.0.md) (MKBase)
  defines one document: small files, a short header, no fixed folders. Any tool
  can use it.
- **Two skills.** A skill is one text file with rules. Give it to your agent,
  and the agent reads and writes your knowledge base safely and with little
  context.

The trail is the line of marks that agents leave for the next agent.

<br/>

## What you can use it for

- **Long-term memory for your agents.** The agent saves a decision, a pitfall,
  or a fact. The next session, on any device, finds it again.
- **A personal knowledge base.** Notes, research, how-tos, and things you
  learned, all in files you own and can read.
- **A shared team handbook.** Architecture decisions, runbooks, and onboarding
  guides that every teammate and every agent can use.
- **Data exchange between agent sessions.** Handoffs, an inbox per person, or
  shared state: one session writes a document, and the next session or a
  teammate's agent reads it.
- **Project notes for a codebase.** Why it works this way, which API quirks to
  expect, and what you tried that failed.
- **A common format for other tools.** Build on the standard, and your tool
  reads and writes the same documents.

<br/>

## The skills

| Skill | For |
|:------|:----|
| [`personal-knowledge-base`](personal-knowledge-base/SKILL.md) | You, with your own knowledge base. |
| [`team-knowledge-base`](team-knowledge-base/SKILL.md) | A knowledge base that several people write to. |

Pick one. The team skill does everything the personal skill does, and adds
rules for shared repositories.

Both skills are:

- **Safe by default.** The agent reads and writes only when you ask.
- **Light on context.** The agent looks at titles first and opens few documents.
- **Careful with writes.** No force pushes, no secrets, no deletes unless you ask.

<br/>

## Quick start

In a session in your knowledge base repository, tell your agent:

```text
Read https://github.com/ionpulse-dev/waymark-trail and add the
personal-knowledge-base skill. Ask me whether it goes into this repository or
into my global skills, then do it and tell me what you added.
```

For a team, say `team-knowledge-base`. The repository must be public, or the
agent must have access to it.

Prefer to do it yourself? See [Install](#install).

<br/>

## Install

You need a Git repository and an agent that reads `AGENTS.md`.

**1. Mark the knowledge base.** Create a `.mkbase` folder with a `version` file
in the folder that holds your documents:

```bash
mkdir .mkbase && echo 1.0 > .mkbase/version
```

**2. Add the skill.** Tell your agent:

```text
Add the skill from this URL to this repository as
.agents/skills/personal-knowledge-base/SKILL.md, then tell me what you added:
https://raw.githubusercontent.com/ionpulse-dev/waymark-trail/main/personal-knowledge-base/SKILL.md
```

For a team, use `team-knowledge-base` in both places.

**3. Load it in every session.** Add this to the `AGENTS.md` of your repository:

```markdown
## Knowledge base

At the start of every session, read and follow
`.agents/skills/personal-knowledge-base/SKILL.md`.
```

**4. Check.** Start a new session. The agent tells you that the skill is active.

### Pin a version

The URL above uses `main`, so it gives the newest version. To pin a version,
replace `main` with the tag `<skill-name>-v<version>`, for example
`personal-knowledge-base-v1.1.2`. Tags exist only after a release is
tagged; until then, use `main`.

### Install globally

You can also put a skill in the global skill folder of your agent tool, for
example `~/.claude/skills/personal-knowledge-base/SKILL.md` for Claude Code.
Then it works in every project. Be aware that people who share the knowledge
base do not get it, so for a team, keep the skill in the repository.

<br/>

## The document standard

MKBase has numbered sections, conformance rules, and valid and invalid examples
in [standard/conformance/](standard/conformance/). The skills follow it, and any
other tool can too.

- One topic per Markdown file, at most 100 KB.
- A short YAML header: title, description, status, dates, and authors.
- No fixed folder. A `.mkbase` folder marks the knowledge base.

<br/>

## Obsidian

A knowledge base is also a valid [Obsidian](https://obsidian.md) vault. The
`.mkbase` folder works like Obsidian's `.obsidian` folder, which marks a vault.

To make Obsidian write relative Markdown links instead of `[[wikilinks]]`, put
this in `.obsidian/app.json`:

```json
{
  "useMarkdownLinks": true,
  "newLinkFormat": "relative"
}
```

You can read and search documents in Obsidian. For changes, let the agent do it,
because it follows the rules every time. If you edit by hand, ask the agent
afterwards to check the document against the standard.

<br/>

## For contributors

Do not edit the finished `SKILL.md` files by hand. Edit the parts in `src/` and
run the build:

```bash
./build.sh
```

Read [AGENTS.md](AGENTS.md) and [specs/WORKFLOW.md](specs/WORKFLOW.md) before you
change anything.

<br/>

## Warning

An AI agent is not fully reliable, and these skills are only rules in text.
Nothing enforces them. Know the main risks:

- **Data loss.** A wrong write can damage a document. Keep backups.
- **Leaks.** Everyone with access to the repository can read what is pushed.
  Do not store secrets.
- **Wrong content.** The agent can write or rely on a wrong document.

Check what the agent commits. You use the skills at your own risk, as the
[license](LICENSE) says.

<br/>

## License

[MIT](LICENSE).
