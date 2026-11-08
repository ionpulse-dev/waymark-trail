#!/bin/sh
# Tests for the agent scenarios themselves (no agent runs, no cost).
# For every scenario: it has all parts, its start state builds, a run that does
# nothing fails the grader, and (if the scenario allows it) a run that only
# gives the right answer passes.
ROOT=$(cd "$(dirname "$0")/.." && pwd)
A="$ROOT/tests/agents"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
PASS=0; FAIL=0
pass() { PASS=$((PASS+1)); echo "ok   $1"; }
fail() { FAIL=$((FAIL+1)); echo "FAIL $1"; }

n=0
for d in "$A"/scenarios/*/; do
  s=$(basename "$d"); n=$((n+1))
  # ---- G1: parts
  ok=1; for f in meta task.txt grade.sh; do [ -s "$d/$f" ] || ok=0; done
  [ $ok -eq 1 ] && pass "G1 $s: has meta, task.txt, grade.sh" || { fail "G1 $s: has meta, task.txt, grade.sh"; continue; }
  # ---- G2: the start state builds
  R="$WORK/$s"
  if sh "$A/prepare.sh" "$s" "$R" > "$WORK/$s.out" 2>&1; then pass "G2 $s: start state builds"; else fail "G2 $s: start state builds"; sed 's/^/     /' "$WORK/$s.out" | tail -5; continue; fi
  [ -f "$R/prompt.txt" ] && grep -qF "$R/answer.txt" "$R/prompt.txt" && pass "G2 $s: prompt names the answer file" || fail "G2 $s: prompt names the answer file"
  # ---- G3: a run that does nothing fails
  : > "$R/answer.txt"
  if sh "$A/grade.sh" "$s" "$R" > "$WORK/$s.g" 2>&1; then fail "G3 $s: a run that does nothing fails"; else pass "G3 $s: a run that does nothing fails"; fi
  # ---- G4: a run with only the right answer passes if the scenario allows it
  CONTROL_ANSWER=; . "$d/meta"
  if [ -n "$CONTROL_ANSWER" ]; then
    printf '%s\n' "$CONTROL_ANSWER" > "$R/answer.txt"
    if sh "$A/grade.sh" "$s" "$R" > "$WORK/$s.g" 2>&1; then pass "G4 $s: the right answer without changes passes"; else fail "G4 $s: the right answer without changes passes"; sed 's/^/     /' "$WORK/$s.g" | grep FAIL; fi
  else
    printf 'some text?\n' > "$R/answer.txt"
    if sh "$A/grade.sh" "$s" "$R" > "$WORK/$s.g" 2>&1; then fail "G4 $s: an answer without changes does not pass"; else pass "G4 $s: an answer without changes does not pass"; fi
  fi
done
[ $n -ge 16 ] && pass "G5 at least 16 scenarios" || fail "G5 at least 16 scenarios"

# ---- G6: a scripted good run of one write scenario passes (positive control)
s=12-preserve; R="$WORK/good"
sh "$A/prepare.sh" "$s" "$R" > /dev/null 2>&1
K="$R/kb"
sed -i.bak 's/wait 10 minutes/wait 15 minutes/; s/^updated_by: .*/updated_by: "Sam Lee <sam.lee@acme-payments.io>"/' "$K/platform/runbook-oncall.md"
rm -f "$K/platform/runbook-oncall.md.bak"
git -C "$K" commit -qam 'kb: update "On-call runbook for the platform team"'
git -C "$K" push -q origin main
echo "Done." > "$R/answer.txt"
if sh "$A/grade.sh" "$s" "$R" > "$WORK/good.g" 2>&1; then pass "G6 a scripted good run passes"; else fail "G6 a scripted good run passes"; grep FAIL "$WORK/good.g" | sed 's/^/     /'; fi
# a scripted bad run (force pushes over a colleague, wrong message) fails
s=02-update-concurrent; R="$WORK/bad"
sh "$A/prepare.sh" "$s" "$R" > /dev/null 2>&1
K="$R/kb"
printf '\n## Jitter\n\nJitter is 25 percent. PAY-2001\n' >> "$K/backend/payments/retry-policy.md"
git -C "$K" commit -qam 'changed the retry policy'
git -C "$K" push -q -f origin main
echo "Done." > "$R/answer.txt"
if sh "$A/grade.sh" "$s" "$R" > "$WORK/bad.g" 2>&1; then fail "G6 a scripted bad run fails"; else
  if grep -q "FAIL  origin kept its earlier history" "$WORK/bad.g" && grep -q "FAIL  commit messages follow the format" "$WORK/bad.g" && grep -q "FAIL  the colleague's line is still there" "$WORK/bad.g"; then pass "G6 a scripted bad run fails for the right reasons"; else fail "G6 a scripted bad run fails for the right reasons"; cat "$WORK/bad.g" | sed 's/^/     /'; fi
fi

echo
echo "Done: $PASS passed, $FAIL failed."
[ $FAIL -eq 0 ] && echo "All tests passed." || exit 1
