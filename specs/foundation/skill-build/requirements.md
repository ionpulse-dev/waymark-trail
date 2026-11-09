---
type: foundation
status: implemented
created: 2026-11-08
updated: 2026-11-08
---

# Skill build

## Technical Goal

Keep the rules that both skills share in one place, and produce two finished,
self-contained skill files from small parts. A person installs a skill with the
URL of one file.

## Dependents

- `personal-knowledge-base` — the finished skill file is the output of this build.
- `team-knowledge-base` — the finished skill file is the output of this build.

## Deliverables

- `src/common.md`, `src/personal.md`, `src/team.md`: the parts.
- `src/frontmatter/personal.yaml` and `src/frontmatter/team.yaml`: name, description, and version of each skill.
- `build.sh`: joins the parts into the two finished files.
- `personal-knowledge-base/SKILL.md` and `team-knowledge-base/SKILL.md`: the finished files, committed.
- A check that fails when a finished file differs from what the build produces.
- `.github/workflows/check.yml`: a GitHub Actions workflow that runs the check on every push and pull request.
- A README with copy-paste install prompts and the example for the start block in the global instructions file.

## Scope

**In scope:**
- The build of the two skills and the check.
- The layout of the repository.
- Versioning of each skill.

**Out of scope:**
- The content of the rules (that belongs to the two feature specs).
- Any installer, package, or registry.

## Constraints

- The finished files have no includes and no tool-specific syntax.
- The build needs only a shell, with no runtime to install.
- Nobody edits a finished file by hand.
- A change to `src/common.md` changes both skills. The agent that makes the change raises both versions in the same commit. The build does not change versions by itself.
- Each skill has its own version and its own Git tag, named `<skill-name>-v<version>`. A pinned URL uses that tag.

## Acceptance Criteria

- **Given** the parts in `src/`, **When** `build.sh` runs, **Then** both finished files are written, each complete on its own.
- **Given** a finished file, **When** its body is pasted into an `AGENTS.md`, **Then** it works without the frontmatter.
- **Given** a change to a finished file that does not come from the build, **When** the check runs, **Then** it fails.
- **Given** a change to `src/common.md`, **When** the build runs, **Then** both finished files change.
- **Given** the raw URL of a finished file, **When** an agent is told to add the skill from it, **Then** the agent gets the whole skill from that one URL.

## Open Questions

None.
