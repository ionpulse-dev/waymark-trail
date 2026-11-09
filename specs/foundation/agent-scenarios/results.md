# Results: round 1

Date: 2026-11-08. Skills at the commit after "Add graded agent scenarios and a
spec for them". Each run uses a fresh repository and one scenario. The scripts
grade the end state.

## Pass rates

| Model | Runs | Passed |
|:------|-----:|-------:|
| Haiku (3 rounds) | 48 | 47 (01 passed after the task and grader fixes) |
| Sonnet | 16 | 16 |
| Opus | 5 (02, 03, 04, 07, 12) | 5 |

## Failures

- **01-write-new (Haiku, 1 run).** The agent made the marker folder and asked
  for the content of the two documents. It refused to invent the steps. This
  was a defect of the scenario, not of the skill. The task now contains the
  facts. The rerun passed after a second fix: the grader now accepts inline tag lists.
- **11-team-status-update (Haiku, 1 run).** The commit carried a
  `Co-Authored-By` trailer, which the harness that runs the agents adds. The rule
  now allows a trailer that the tool adds on its own, and the grader no longer
  checks for it.

## Earlier fixes in this round

- 05: the task named no folder, so the agent asked. The task now names one.
- 13: the grader now accepts a shortened title or a question.
- Earlier rounds led to the changes in `src/common.md` (secrets only, move in
  two commits, no-remote case, commit messages).

## Open

- The headless runner is not used: the CLI login expired. Runs were done with
  subagents.
- The harness trailer conflict.
- Opus ran only five scenarios, because of cost.
