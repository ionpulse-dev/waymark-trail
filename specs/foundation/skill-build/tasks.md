# Tasks: Skill build

_Written after `plan.md` is approved. Bite-sized implementation checklist. AI checks off items as work is completed._
_List tasks in strict prerequisite-first order. A task may only appear after all tasks it depends on._

The content of the rules belongs to the two feature specs. The parts created here
are short stubs, so the build can run and be tested. The feature specs replace
the stub text.

- [x] Create `src/frontmatter/personal.yaml` and `src/frontmatter/team.yaml` with `name`, `description`, and `version: 0.1.0`.
- [x] Create stub parts `src/common.md`, `src/personal.md`, and `src/team.md`.
- [x] Write `build.sh` build mode: frontmatter, one-line license header, role part, then common part, written to `<skill-name>/SKILL.md` for both skills.
- [x] Add `build.sh --check`: build into a temporary folder and compare with the committed files. Exit non-zero on any difference.
- [x] Write `tests/build.test.sh` with the tests listed in `test.md`.
- [x] Run `build.sh` to write the two finished `SKILL.md` files (they are committed with the rest of the work).
- [x] Run `tests/build.test.sh` and fix any failure.
- [x] Add `.github/workflows/check.yml`: run `build.sh --check` and `tests/build.test.sh` on every push and pull request.
- [x] Write `README.md`: copy-paste install prompts (with and without a pinned tag), start block examples for `AGENTS.md`, and how to build.
- [x] Set status to `implemented` in `requirements.md` and `INDEX.md`.
