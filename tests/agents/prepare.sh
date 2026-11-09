#!/bin/sh
# Build the start state of one scenario and print the prompt for the agent.
# Usage: prepare.sh <scenario> <run-dir>
# Result: <run-dir>/kb (the knowledge base), <run-dir>/origin.git, <run-dir>/prompt.txt,
# <run-dir>/home (global skill and global instructions), <run-dir>/work (empty session folder)
set -e
HERE=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$HERE/../.." && pwd)
S=$1; RUN=$2
SC="$HERE/scenarios/$S"
[ -d "$SC" ] || { echo "no scenario $S" >&2; exit 1; }
. "$HERE/lib.sh"
SKILL=personal; FIXTURE=vault; EMAIL=$FIX_EMAIL
. "$SC/meta"

mkdir -p "$RUN"; RUN=$(cd "$RUN" && pwd)
KB="$RUN/kb"; ORIGIN="$RUN/origin.git"; ANSWER="$RUN/answer.txt"
export RUN KB ORIGIN REPO HERE TODAY
rm -rf "$KB" "$ORIGIN" "$RUN/colleague" "$ANSWER"
mkdir -p "$KB"

# the knowledge base holds only documents. The skill and the start block live
# at the global user level, as in a real install.
if [ "$FIXTURE" = vault ]; then cp -R "$REPO/standard/conformance/vault/." "$KB/"; fi
HOME_DIR="$RUN/home"; WORK="$RUN/work"
rm -rf "$HOME_DIR" "$WORK"
mkdir -p "$HOME_DIR/skills/$SKILL-knowledge-base" "$WORK"
cp "$REPO/$SKILL-knowledge-base/SKILL.md" "$HOME_DIR/skills/$SKILL-knowledge-base/SKILL.md"
cat > "$HOME_DIR/instructions.md" <<EOT
## Knowledge base

My knowledge base is the Git repository at \`$KB\`.

- Use this path as the knowledge base in every session, in every folder.
- Run Git commands for it with \`git -C $KB\`.
- At the start of every session, read and follow
  \`$HOME_DIR/skills/$SKILL-knowledge-base/SKILL.md\`.
EOT

git init -q -b main "$KB"
git -C "$KB" config user.name "$FIX_NAME"
git -C "$KB" config user.email "$EMAIL"
git -C "$KB" config commit.gpgsign false
git -C "$KB" add -A
git -C "$KB" commit -q --allow-empty -m initial
git init -q --bare -b main "$ORIGIN"
git -C "$KB" remote add origin "$ORIGIN"
git -C "$KB" push -q -u origin main

# extra start state that is part of the base
if [ -f "$SC/setup.sh" ]; then sh "$SC/setup.sh" base; fi
if [ -n "$(git -C "$KB" status --porcelain)" ]; then
  git -C "$KB" add -A; git -C "$KB" commit -q -m "scenario setup"; git -C "$KB" push -q origin main
fi
git -C "$KB" rev-parse HEAD > "$RUN/base"
# changes that exist on origin only (a colleague who pushed first)
if [ -f "$SC/setup.sh" ]; then sh "$SC/setup.sh" remote; fi
git -C "$ORIGIN" rev-parse main > "$RUN/origin_base"

{
  cat <<EOT
You are an AI agent that works for a person. Your session folder is:

$WORK

Your global instructions are in this file. Read them and follow them at the
start, like in any session:

$HOME_DIR/instructions.md

Do not read, search, or change anything outside your session folder, the files
named in your global instructions, and the knowledge base that they name.

Test harness notes:
- A simulated person says the text between the two lines below. The person
  cannot answer during this run. If your rules tell you to ask the person,
  write the question as your final reply and stop. Otherwise do the work.
- Follow only the rules of your skill for commits. Add no other trailers.
- At the end, save your final reply to the person (the text you would show
  them) into this file, which is not part of the knowledge base:
  $ANSWER
- Finish your run with the single line DONE and nothing else.

------------------------------------------------------------------
EOT
  cat "$SC/task.txt"
  printf -- '------------------------------------------------------------------\n'
} > "$RUN/prompt.txt"
cat "$RUN/prompt.txt"
