# Tests: Skill build

_`[auto]` items are verified by running the automated test suite. `[manual]` items require human verification in a real environment._

_AI checks off `[auto]` items when tests pass. A human checks off `[manual]` items. The foundation item moves to `done` only when all items are checked._

## Acceptance Criteria Coverage

| Criterion | Test Case |
|:----------|:----------|
| **Given** the parts in `src/`, **When** `build.sh` runs, **Then** both finished files are written, each complete on its own. | T1, T2 |
| **Given** a finished file, **When** its body is pasted into an `AGENTS.md`, **Then** it works without the frontmatter. | T3, T7 |
| **Given** a change to a finished file that does not come from the build, **When** the check runs, **Then** it fails. | T4, T5 |
| **Given** a change to `src/common.md`, **When** the build runs, **Then** both finished files change. | T6 |
| **Given** the raw URL of a finished file, **When** an agent is told to add the skill from it, **Then** the agent gets the whole skill from that one URL. | T8 |

## Test Cases

- [x] [auto] T1: `build.sh` writes `personal-knowledge-base/SKILL.md` and `team-knowledge-base/SKILL.md` (`tests/build.test.sh`).
- [x] [auto] T2: Each finished file has `name`, `description`, and `version` in its frontmatter, and contains its role part and the common part. Neither contains an include or tool-specific syntax (`tests/build.test.sh`).
- [x] [auto] T3: The body of each finished file, with the frontmatter removed, still contains all rules and repeats no line of the frontmatter (`tests/build.test.sh`).
- [x] [auto] T4: `build.sh --check` exits with 0 right after a build (`tests/build.test.sh`).
- [x] [auto] T5: After a hand edit of a finished file, `build.sh --check` exits non-zero and names the file (`tests/build.test.sh`).
- [x] [auto] T6: After a change to `src/common.md` and a build, both finished files change (`tests/build.test.sh`).
- [x] [auto] T7: `.github/workflows/check.yml` exists and runs `build.sh --check` (`tests/build.test.sh`).
- [ ] [manual] T8: One URL gives the whole skill.
  1. Push the finished files to the public repository.
  2. Open a new agent session in an empty test repository.
  3. Tell the agent: "Add the skill from `<raw URL of personal-knowledge-base/SKILL.md>`". Repeat with a tag-pinned URL.
  4. Expected: the agent saves the whole file and needs no second file. The skill tells the user that it is active.
  5. Cleanup: delete the test repository.
- [ ] [manual] T9: The body works inside an `AGENTS.md`.
  1. In a test repository, paste the body of `personal-knowledge-base/SKILL.md` (no frontmatter) into `AGENTS.md`.
  2. Start a new agent session in that repository.
  3. Expected: the agent follows the rules and shows the autonomy table at first use.
  4. Cleanup: delete the test repository.
- [ ] [manual] T10: The GitHub Actions check fails on a hand edit.
  1. On a test branch, change one word in a finished `SKILL.md` and push.
  2. Expected: the workflow run fails. Revert the change and push; the run passes.
  3. Cleanup: delete the test branch.

## Notes

- Tests run in a temporary copy of the repository, so they never change the real files.
- T9 depends on the final text of the feature specs. Run it after those specs are implemented.
