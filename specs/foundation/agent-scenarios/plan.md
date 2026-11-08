# Plan: Agent scenarios

## Approach

A scenario is a folder. `prepare.sh` copies the sample vault (or an empty
repository) into a run folder, installs the skill like a real user does, makes a
bare `origin`, and tags the start state. `setup.sh` adds scenario state in two
phases: `base` (part of the start commit, for example a planted document) and
`remote` (only on `origin`, for example a colleague who pushed first). The
prompt tells the agent to read `AGENTS.md`, to stay in the folder, to save its
final reply to `answer.txt`, and to stop and write its question when its rules
say to ask.

`grade.sh` sources `lib.sh` and the `grade.sh` of the scenario. The checks read
the repository, `origin`, the saved reply, and optionally the transcript of the
agent (to count documents opened in full). All write scenarios share
`common_write`: clean tree, new commits, all documents pass the checker, the
person as author, the commit message format, no agent trailer, work pushed, and
`origin` keeps its earlier history.

An operator (a person or an agent) runs a round: prepare, start one agent per
run with the prompt, grade, summarize. The runner for headless runs is deferred
(see `todo.md`).

## Scenarios

| # | Name | Skill | Tests |
|---|---|---|---|
| 01 | write-new | personal | marker folder, two linked documents, fields |
| 02 | update-concurrent | personal | a colleague pushed first; nothing is lost |
| 03 | move | personal | pure renames, link fixes, history |
| 04 | secrets-refuse | personal | no secret is written; the agent asks or uses a placeholder |
| 05 | sensitive-allowed | personal | personal and customer data are written |
| 06 | reading-economy | personal | answers, disputed document, no match, few documents opened |
| 07 | hostile-document | personal | instructions inside a document are ignored |
| 08 | supersede | personal | `supersedes` and `deprecated` in one commit |
| 09 | delete-request | personal | a requested delete is done, links fixed, one `kb: delete` commit |
| 10 | team-email | team | a noreply address blocks the write |
| 11 | team-status-update | team | a request that fails a test is written with a note |
| 12 | preserve | personal | unknown properties, `trust` fields, callouts, comments |
| 13 | limits | personal | a title over 15 words is shortened |
| 14 | stale-team | team | the answer says an old document is old and gives the rule |
| 15 | manual-no-write | personal | no write without a request |
| 16 | automatic-write | personal | writing after "you may write on your own" |

## New Files

- `tests/agents/lib.sh` — helpers for fixtures and checks.
- `tests/agents/prepare.sh` — builds the start state and the prompt.
- `tests/agents/grade.sh` — grades the end state.
- `tests/agents/summarize.sh` — table of results.
- `tests/agents/README.md` — how to run a round.
- `tests/agents/scenarios/*/meta`, `task.txt`, `grade.sh`, `setup.sh` — the 16 scenarios.
- `tests/agents.test.sh` — tests for the scenarios; runs in CI.
- `specs/foundation/agent-scenarios/results.md` — recorded rounds.

## Risks

- Subagents are isolated by instruction only. A headless runner in an empty folder would isolate them for real (deferred).
- Models change. A recorded round is a snapshot, not a guarantee.
