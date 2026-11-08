# Tests: Agent scenarios

## Coverage

| Criterion | Tests |
|---|---|
| A scenario has its parts, builds, and a run that does nothing fails | G1, G2, G3 |
| A scenario that allows "do nothing" passes with the right reply | G4 |
| A scripted good run passes and a scripted bad run fails for the right reasons | G6 |
| 16 scenarios | G5 |
| A round on several models is recorded | R1 |

## Items

- [x] [auto] G1: Every scenario has `meta`, `task.txt`, and `grade.sh` (`tests/agents.test.sh`).
- [x] [auto] G2: The start state of every scenario builds, and the prompt names the answer file (`tests/agents.test.sh`).
- [x] [auto] G3: A run that does nothing fails the grader in every scenario (`tests/agents.test.sh`).
- [x] [auto] G4: Where the scenario allows it, the right reply without changes passes; elsewhere an answer without changes does not pass (`tests/agents.test.sh`).
- [x] [auto] G5: There are at least 16 scenarios (`tests/agents.test.sh`).
- [x] [auto] G6: A scripted good run of `12-preserve` passes. A scripted bad run of `02-update-concurrent` (force push, wrong message, colleague change lost) fails for those reasons (`tests/agents.test.sh`).
- [x] [manual] R1: Run a round and record it in `results.md`.
  1. For each scenario and run: `sh tests/agents/prepare.sh <scenario> <run-dir>`. Start one agent with the printed prompt.
  2. When it ends: `RESULTS_FILE=<file> LABEL=<model>-<n> sh tests/agents/grade.sh <scenario> <run-dir>`.
  3. `sh tests/agents/summarize.sh <file>`.
  Expected: a table with the pass rate per scenario and model. Failures are explained in `results.md`.
