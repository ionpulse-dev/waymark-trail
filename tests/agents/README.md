# Agent scenarios

Tests for the skills with real agents. Each scenario builds a fresh Git
repository, gives an agent one task, and a script checks the end state.
See `specs/foundation/agent-scenarios/`.

## Check the scenarios (free, runs in CI)

```bash
sh tests/agents.test.sh
```

## Run a round

For each scenario and run:

```bash
sh tests/agents/prepare.sh 03-move /tmp/round/03-move-haiku-1
```

The command builds the knowledge base, a global skill folder, a global
instructions file, and an empty session folder (`work`), and prints the prompt.
Start one agent in the `work` folder with that prompt (a new session or a
subagent, with the model you want to test). When it ends:

```bash
RESULTS_FILE=/tmp/round/results.tsv LABEL=haiku-1 \
  sh tests/agents/grade.sh 03-move /tmp/round/03-move-haiku-1
```

`grade.sh` prints each check and appends one line to `RESULTS_FILE`. Pass a
transcript (JSONL) as third argument to let `06-reading-economy` count the
documents that the agent opened in full. At the end:

```bash
sh tests/agents/summarize.sh /tmp/round/results.tsv
```

Run each scenario several times. A scenario that passes only in some runs shows
a rule that is not clear enough.
