# AGENTS.md — waymark-trail

This file is the entry point for all AI agents. Read it at the start of every
session.

## This is a spec-driven project (light form)

The specification drives the content. The skill text is the product, and the
finished `SKILL.md` files are generated from parts in `src/`. Nobody edits a
finished file by hand.

**At the start of EVERY session, read these files again, in this order:**

1. [specs/WORKFLOW.md](specs/WORKFLOW.md): the rules of the process.
2. [specs/INDEX.md](specs/INDEX.md): the current status of all specs.
3. [specs/PROJECT.md](specs/PROJECT.md): what this project is and why.

Do not rely on memory of an earlier session. Read the files anew.

"Light" means: few specs and small files. The workflow is the same. A spec
folder gets `plan.md`, `tasks.md`, and `test.md` when its phase begins, not
before. There are three specs: two features (the two skills) and one
foundation item (how they are built).

## What does not belong in this repository

This repository will be public. Never commit secrets, company or customer
names, internal host names, or business details such as pricing or revenue
plans. Maintainers keep non-public notes outside this repository.

## Writing conventions

- Use Simple English (ASD-STE100 style): short sentences, active voice.
- Say "document", not "note", for the unit of a knowledge base.
- Ask the user one question at a time.
- Write all code, comments, documentation, and commit messages in English.
- Every commit that changes a skill raises the version of both skills: the patch
  part for a normal change (1.5.0 to 1.5.1), the minor part only for a
  substantial one (1.5.3 to 1.6.0). Run
  `git config core.hooksPath .githooks` once. The pre-commit hook enforces it.

## License

MIT. See [LICENSE](LICENSE).
