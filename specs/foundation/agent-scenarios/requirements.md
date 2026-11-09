---
type: foundation
status: implemented
created: 2026-11-08
updated: 2026-11-08
requires:
  - skill-build
  - document-standard
---

# Agent scenarios

## Technical Goal

Test the skills with real agents in a way that is repeatable and graded by
scripts. Each scenario builds a fresh Git repository, gives an agent one task,
and checks the end state of the repository. A number tells whether a change to
a skill made agents better or worse.

## Dependents

- `personal-knowledge-base` — its manual checks M1 to M7 are backed by these scenarios.
- `team-knowledge-base` — its manual checks N1 to N6 are backed by these scenarios.

## Deliverables

- `tests/agents/scenarios/<name>/`: 16 scenarios. Each has `meta`, `task.txt`, `grade.sh`, and (if needed) `setup.sh`.
- `tests/agents/prepare.sh`: builds the start state of a scenario (knowledge base, bare `origin`, global skill folder, global instructions file, empty session folder) and prints the prompt for the agent.
- `tests/agents/grade.sh`: checks the end state and prints PASS or FAIL.
- `tests/agents/summarize.sh`: prints a table of results by scenario and model.
- `tests/agents/lib.sh`: helpers for fixtures and checks.
- `tests/agents.test.sh`: tests for the scenarios themselves. They run in CI and cost nothing.
- `tests/agents/README.md`: how to run a round.
- `results.md`: the results of the recorded rounds.

## Scope and constraints

- A scenario never relies on what an agent says about itself. The grader reads the repository, the remote, and the saved final reply.
- A scenario starts from a fresh repository with a bare `origin`, so pull, push, concurrent changes, and force pushes are real.
- The skill is installed like in real use, at the global user level: a skill file in a `home/skills/` folder and a `home/instructions.md` file with the start block. The block names the path of the knowledge base. The agent starts in an empty session folder, not in the knowledge base. The knowledge base holds only documents.
- Agent runs are not part of CI. They cost money and are not deterministic.
- A run that does nothing must fail the grader. A scenario that allows "do nothing" (for example a refusal) must still need a final reply.

## Acceptance criteria

- **Given** a scenario, **When** `tests/agents.test.sh` runs, **Then** its parts exist, its start state builds, and a run that does nothing fails the grader.
- **Given** a scenario where doing nothing is correct, **When** the right reply is saved without changes, **Then** the grader passes.
- **Given** a scripted good run, **When** it is graded, **Then** it passes. **Given** a scripted bad run (force push, wrong message, lost colleague change), **Then** it fails for those reasons.
- **Given** the 16 scenarios, **When** a round runs on several models, **Then** the results are recorded with the pass rate per scenario and model.

## Open questions

- None.
