#!/bin/sh
# Tests for build.sh. They run in a temporary copy, so the real files stay
# unchanged. Test names match specs/foundation/skill-build/test.md.

set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

failures=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; failures=$((failures + 1)); }
check() { # check <name> <command...>
  name=$1
  shift
  if "$@" >/dev/null 2>&1; then pass "$name"; else fail "$name"; fi
}

# Fresh copy of the sources
cp -R "$ROOT/src" "$ROOT/build.sh" "$WORK/"
cd "$WORK" || exit 1

P=personal-knowledge-base/SKILL.md
T=team-knowledge-base/SKILL.md

# T1: the build writes both finished files
./build.sh >/dev/null
check "T1 build writes both files" sh -c "[ -s $P ] && [ -s $T ]"

# T2: frontmatter fields, role part, common part, no includes
t2() {
  for f in $P $T; do
    head -1 "$f" | grep -qx -- '---' || return 1
    grep -q '^name: ' "$f" && grep -q '^description: ' "$f" && grep -q '^version: ' "$f" || return 1
    grep -qF "$(head -1 src/common.md)" "$f" || return 1
    if grep -qiE '@include|\{\{|\{%|<include|!\[\[' "$f"; then return 1; fi
  done
  grep -qF "$(head -1 src/personal.md)" $P && grep -qF "$(head -1 src/team.md)" $T
}
check "T2 frontmatter, parts, no includes" t2

# T3: the body (frontmatter removed) holds all rules and does not need it
t3() {
  for f in $P $T; do
    body=$(awk 'BEGIN{n=0} /^---$/ && n<2 {n++; next} n>=2 {print}' "$f")
    printf '%s\n' "$body" | grep -qF "$(head -1 src/common.md)" || return 1
    if printf '%s\n' "$body" | grep -qi 'frontmatter'; then return 1; fi
  done
}
check "T3 body works without frontmatter" t3

# T4: the check passes right after a build
check "T4 check passes after build" ./build.sh --check

# T5: a hand edit makes the check fail and names the file
echo "hand edit" >> $P
out=$(./build.sh --check 2>&1) && fail "T5 check fails on hand edit" || {
  printf '%s' "$out" | grep -qF "$P" && pass "T5 check fails on hand edit" || fail "T5 check names the file"
}
./build.sh >/dev/null

# T6: a change to common.md changes both finished files
cp $P p.before
cp $T t.before
echo "A new shared rule." >> src/common.md
./build.sh >/dev/null
if ! cmp -s p.before $P && ! cmp -s t.before $T; then
  pass "T6 common change reaches both skills"
else
  fail "T6 common change reaches both skills"
fi

# T7: the CI workflow exists and runs the check (checked in the real repo)
check "T7 workflow runs the check" grep -q 'build.sh --check' "$ROOT/.github/workflows/check.yml"

echo
if [ "$failures" -eq 0 ]; then echo "All tests passed."; else echo "$failures test(s) failed."; fi
[ "$failures" -eq 0 ]
