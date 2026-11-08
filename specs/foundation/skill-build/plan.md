# Plan: Skill build

_Written alongside or after `requirements.md`. Describes the technical approach._

## Overview

Plain Markdown parts are joined by a small shell script into two finished skill files. The finished files are committed, so a raw URL works without a build.

## Components Affected

- The repository root — gets the `src/` folder, the build script, and the two skill folders.

## New Files

- `src/common.md` — the rules both skills share.
- `src/personal.md` — only what a single user needs.
- `src/team.md` — only what a shared knowledge base needs.
- `src/frontmatter/personal.yaml` — name, description, version.
- `src/frontmatter/team.yaml` — name, description, version.
- `build.sh` — joins the parts into the finished files and can check them.
- `personal-knowledge-base/SKILL.md` — finished skill, generated.
- `team-knowledge-base/SKILL.md` — finished skill, generated.
- `README.md` — install prompts, start block examples, how to build.
- `tests/build.test.sh` — shell tests for the build and the check.
- `.github/workflows/check.yml` — GitHub Actions workflow that runs `build.sh --check` on every push and pull request.

## Technical Approach

Each finished file is: frontmatter, the role-specific
part, then the common part. `build.sh` reads the parts in that order and writes
the file. `build.sh --check` builds into a temporary place and compares it with
the committed files. CI runs the check on every push. The version lives in the
frontmatter file of each skill.

## Dependencies on Other Foundation Items

None.

## Risks

- A person edits a finished file by hand, and the next build overwrites it. The check catches this.
- A change to the shared rules needs two version bumps. The agent that changes `src/common.md` raises both versions in the same commit.

## Open Questions

None.
