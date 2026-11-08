# Decisions: Agent scenarios

## Grade the end state, not the report — 2026-11-08

**Decision:** The grader reads the repository, `origin`, and the saved final reply. It does not use what the agent says about its work.

**Alternatives considered:**
- Ask the agent for a report and judge it — an agent can describe its work wrongly, and the tester sees only what it chooses to say.

**Reason:** Scripts are repeatable and cost nothing to run again.

## A bare `origin` in every fixture — 2026-11-08

**Decision:** Every run gets a local bare repository as `origin`. A colleague's change is a commit that exists only on `origin`.

**Alternatives considered:**
- No remote — the pull, push, and collision rules could not run.
- A timed change during the run — needs a hook into the agent.

**Reason:** The check "did the document change since I read it" fires when the pull brings the colleague's commit. No timing is needed.

## Agent runs are not in CI — 2026-11-08

**Decision:** CI runs `tests/agents.test.sh` only. It tests the scenarios and graders with scripted runs. The agent rounds run by hand.

**Alternatives considered:**
- Run agents in CI — cost, secrets, and non-deterministic results make the check unreliable.

**Reason:** The check in CI must be cheap and stable.

## Subagents instead of a headless runner for the first round — 2026-11-08

**Decision:** The first round used subagents of the Claude desktop app, one per run. A runner for `claude -p` is deferred.

**Alternatives considered:**
- `claude -p` in an empty folder — better isolation, but the login of the command line tool had expired in this environment.

**Reason:** The scenarios, fixtures, and graders do not depend on the runner.
