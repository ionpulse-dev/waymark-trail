#!/bin/sh
# Grade the end state of one run. Usage: grade.sh <scenario> <run-dir> [transcript.jsonl]
# Exit status 0 = PASS. If RESULTS_FILE is set, one line is appended to it.
HERE=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$HERE/../.." && pwd)
S=$1; RUN=$(cd "$2" && pwd); TRANSCRIPT=$3
SC="$HERE/scenarios/$S"
. "$HERE/lib.sh"
SKILL=personal; FIXTURE=vault; EMAIL=$FIX_EMAIL
. "$SC/meta"
KB="$RUN/kb"; ORIGIN="$RUN/origin.git"; ANSWER="$RUN/answer.txt"
BASE=$(cat "$RUN/base"); ORIGIN_BASE=$(cat "$RUN/origin_base")
EXPECT_EMAIL=$EMAIL
echo "$S"
. "$SC/grade.sh"
if [ $FAILN -eq 0 ]; then R=PASS; else R=FAIL; fi
echo "RESULT $S $R ($PASSN ok, $FAILN failed)"
if [ -n "$RESULTS_FILE" ]; then
  printf '%s\t%s\t%s\t%s\n' "$S" "${LABEL:-run}" "$R" "$FAILED" >> "$RESULTS_FILE"
fi
[ $FAILN -eq 0 ]
