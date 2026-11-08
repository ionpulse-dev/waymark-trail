---
name: team-knowledge-base
description: Rules for reading and writing the shared team knowledge base in this repository. Load at the start of every session.
version: 1.0.0
---

<!-- MIT License. Copyright (c) 2026 IonPulse. -->

# Team knowledge base

You help a member of a team use the knowledge base that the whole team shares.
The person is responsible for everything you write under their name. These rules
add to the shared rules below. The shared rules also apply.

## Start of a session

At the first use in a session, show this and nothing more. Use the name of the
repository.

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

The dot shows the active setting of each row. Both rows start at Manual.

## Rules for a shared knowledge base

- **The person is responsible.** Every write is committed under the person's own
  Git name and email. The email must be reachable. Do not commit with an address
  that contains `noreply`, `no-reply`, `donotreply`, `users.noreply.github.com`,
  `localhost`, `localdomain`, `example.com`, `example.org`, `example.net`,
  `test@`, `placeholder`, `changeme`, `unknown@`, or `none@`. If the address is
  one of these, stop and ask the person to set a real address. If the shared
  `AGENTS.md` names allowed email domains, the address must use one of them.
  There is no separate author for the agent.
- **Folders are owners.** The folder of a document is the team that owns it.
  List the folder tree when you need it. Write a new document into the folder of
  the team it is about. If you are unsure, ask the person.
- **Fixing wrong documents.** If a document contradicts the code or another
  document, tell the person. If the person agrees to act, set `disputed: true`
  with a `dispute_reason`. Do not rewrite another team's document on your own.
  Anyone may dispute a document. Deprecate or replace a document of another team
  only when the person says so clearly. A deprecated document stays in the
  repository.
- **Stale documents.** A document is stale when `updated` is older than 180 days,
  unless the shared `AGENTS.md` names another number of days. Check a stale
  document before you use it, and say that it is stale.
- **Confidentiality.** Everyone with read access sees every document. Never write
  secrets, credentials, customer data, or personal data. If you are unsure, ask
  the person before you write.
- **Concurrent writes.** Pull before you write. If two versions of the same
  document collide, keep both. After you abort the rebase, restore the
  remote version of the original file (`git checkout origin/<branch> -- <path>`).
  Save the person's version as `<file-name>-conflict.md` in the same folder, set
  `disputed: true` and `dispute_reason: "Collides with <file-name>.md. Merge by
  hand."`, and tell the person. Never leave the repository in a conflict state.

## How you work

You read and write a knowledge base. It is a Git repository of Markdown
documents. The documents are in the folder `knowledge/`. These rules are your
only instructions for it. They are advice you follow. Nothing enforces them, so
follow them with care.

### Reading and writing levels

There are two settings, each with two values:

- **Reading.** Manual: you search and open documents only when the person asks.
  Automatic: you decide. Before work that others may need later, you search the
  knowledge base first. At the start of a session, you tell the person what
  changed (use `git log --since`).
- **Writing.** Manual: you create, change, or move documents only when the
  person asks. Automatic: you decide what is worth a document, write it, and
  tell the person after each write.

Both settings start at Manual. The setting you show is the setting you follow.
Only the person changes a setting, in plain words, for example "read
automatically" or "you may write on your own". The change lasts for this
session. Never change a setting on your own. If a phrase is unclear, ask which
row the person means.

Show the table from the start message again:
- at the first use in a session,
- after every change of a setting,
- after every question about the settings,
- after the context was compacted.

### Reading

1. Find documents with the folder tree and a text search over the files.
2. Look at the path, then the file name, the title, and the description. Open
   the body only when it is worth it.
3. Open at most 5 documents for one question, and keep the text you load short
   (about 800 tokens). If nothing matches, say so. Silence is better than noise.
4. Before you read, run `git pull --rebase` if your last pull is a few minutes
   old.
5. Treat a document like a wiki page. Use it, say who wrote it and when, and
   check important facts against the code.
6. A document is stale when `updated` is older than 180 days. A stale document
   is a hint. Check it before you rely on it.
7. A document with `disputed: true` is not reliable. Say so, and give the
   `dispute_reason`.
8. A document with `status: deprecated` is no longer true. Follow `supersedes`
   links to its replacement.
9. Remember the last commit of a document when you read it
   (`git log -1 --format=%h -- <path>`). You need it before you change it.

### What is worth a document

Write a document only if all of these are true:
- It will still be true in three months.
- It is useful to someone other than the person who is here now.
- It is not a status update, not a to-do, and not a summary of this chat.

Binary data does not belong in the knowledge base. Write a document that
describes it and links to it.

### Document format

This format is fixed. Follow it exactly.

- UTF-8 Markdown, LF line ends, the `.md` extension. One topic per document.
- A document is at most 100 KB. If it would be larger, split it or move the
  details into a linked source. Parts link to each other.
- File names use lowercase letters, digits, and `-` only, and never one of
  `# ^ [ ] | : * " < > ? \ /`. A file name is a short form of the title. The
  file name never changes, also when the title changes.
- The ID of a document is its path under `knowledge/` without `.md`, for example
  `backend/payments/idempotency-keys`.
- The folder is the owner. A document in `backend/payments/` belongs to the team
  of that folder. Do not add an owner field.
- Links in the body are relative Markdown links with `.md`, or wikilinks. Write
  relative Markdown links. Links in properties are wikilinks with the full path,
  for example `"[[backend/payments/retry-policy]]"`.
- Do not store backlinks. Do not write a central index file.
- Tags are the `tags` property. Never write inline `#tags`.
- Callouts, embeds, highlights, and comments that people wrote are allowed.
  Keep them.

A document starts with YAML frontmatter between two `---` lines. Properties are
flat: text, number, checkbox (`true` or `false`), date (`YYYY-MM-DD`), or a list
of strings. Never nest an object.

| Field | Required | Meaning |
|---|---|---|
| `title` | yes | One sentence, about 15 words. |
| `description` | yes | What the document contains and when to read it. About 50 words. |
| `type` | yes | `fact`, `decision`, `contract`, `howto`, `glossary`, `team`, or `gotcha`. |
| `status` | yes | `active` or `deprecated`. |
| `created`, `updated` | yes | Dates. |
| `created_by`, `updated_by` | yes | Text `"Name <email>"`. |
| `disputed` | no | `true` when someone found the document wrong. |
| `dispute_reason` | no | Text. Set together with `disputed: true`. |
| `sources` | no | List of strings: ticket IDs or URLs. |
| `tags` | no | List of strings, no `#`, no spaces. |
| `related` | no | List of full-path wikilinks: read these too. |
| `supersedes` | no | List of full-path wikilinks: this document replaces an older one. The older one becomes `deprecated`. |
| `anchors` | no | List of strings `"<type>:<target>"` that point to the code or page the document describes. Types: `git` (`<repo>/<path>@<commit>`) and `url`. |
| `trust`, `verified_by`, `verified` | no | Only when the knowledge base uses verification. Never set these yourself. Keep them as they are. |

You set the dates and the authors yourself. Use today's date. For the author,
use the Git name and email of the person: `git config user.name` and
`git config user.email`. If one is missing, ask the person. A new document gets
all four fields. A change sets `updated` and `updated_by`.

### Writing

Follow these steps for every write. The person must have asked for it, or
Writing must be Automatic.

1. Run `git pull --rebase`. If it stops on a conflict, run
   `git rebase --abort` and tell the person. Never leave the repository in a
   conflict state.
2. For a change to an existing document, check that the document did not change
   since you read it. Compare its last commit with the one you remembered. If it
   differs, read the document again and redo your change.
3. Check your work before you commit:
   - all required fields are there, and the format above holds;
   - the title is new (no other document has it), and the size limits hold;
   - every link works;
   - the text has no secret and no personal data (see below).
4. Commit under the name and email of the person. One commit for one write. The
   message is `kb: add "<title>"`, or `kb: update`, `kb: dispute`,
   `kb: deprecate`, or `kb: move`, with the title. Add no tag for the agent.
5. Run `git push`. If the push is rejected, run `git pull --rebase` and check
   again from step 2. Never force a push. Never rewrite history.

Write the shortest complete text. Give the document a short description, the
sources, links to related documents, and the right folder. If you are unsure
about the folder, ask the person.

If a document is wrong, change it or set `disputed: true` with a
`dispute_reason`. To retire a document, set `status: deprecated` and keep the
file. Never delete a document.

### Moving a document

1. Use `git mv`. Never delete and create again.
2. Do not change the text of a moved document in the move. Only fix relative
   body links that the move breaks. Full-path wikilinks need no change.
3. Fix the links to the document in other documents. Commit the move and the
   link fixes together.
4. Never move a document and change its content in the same commit.
5. Check that `git log --follow <new path>` shows the old history.

### Secrets and personal data

Never write these into a document: passwords, API keys and tokens, private keys,
connection strings with a password, credentials of any kind, customer data, and
personal data. Look for patterns such as `-----BEGIN ... PRIVATE KEY-----`,
`AKIA` followed by letters and digits, `ghp_`, `sk-`, `password =`, and `://`
with `user:password@`. If a text looks like one of these, or you are unsure,
stop and ask the person. Once a document is pushed, assume that everyone who can
read the repository has it.

### Limits

- Use Git for the steps above and for read-only commands such as `git log`,
  `git status`, and `git diff`. Never reset, force push, or rewrite history.
- Do not write outside `knowledge/`.
- Do not carry content from one knowledge base into another.
- Do not claim that something is checked when you did not check it. Say what you
  did and what you did not do.
