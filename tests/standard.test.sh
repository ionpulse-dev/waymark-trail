#!/bin/sh
# Tests for the standard, the conformance set, and the match between the
# standard and the skills. Names match specs/foundation/document-standard/test.md.

set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
STD="$ROOT/standard/mkbds-1.0.md"
CHECK="$ROOT/tests/check-document.sh"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

failures=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; failures=$((failures + 1)); }

# ---- S1: structure of the standard
s1_ok=1
for h in "## 1 Scope" "## 2 Conformance" "## 3 Normative references" \
         "## 4 Terms and definitions" "## 5 Document structure and file names" \
         "## 6 Frontmatter fields" "## 7 Links" "## 8 Size limits" \
         "## 9 Configurable parameters" "## 10 Obsidian compatibility" \
         "## Annex A (informative)" "## Annex B (informative)"; do
  grep -qF -- "$h" "$STD" || { fail "S1 missing heading: $h"; s1_ok=0; }
done
for w in MUST SHOULD MAY; do
  grep -qw "$w" "$STD" || { fail "S1 missing key word: $w"; s1_ok=0; }
done
grep -q '^\*\*Version:\*\* ' "$STD" || { fail "S1 missing version line"; s1_ok=0; }
[ "$s1_ok" -eq 1 ] && pass "S1 standard has the required structure"

# ---- S2: valid documents pass
valid=$(find "$ROOT/standard/conformance/vault" -name '*.md' | sort)
if [ -n "$valid" ] && echo "$valid" | xargs "$CHECK" >/dev/null 2>&1; then
  pass "S2 checker passes the sample vault"
else
  fail "S2 checker passes the sample vault"
fi

# the example of Annex A is a valid document
mkdir -p "$WORK/annex"
awk '/^```markdown$/ && !done {on=1; next} /^```$/ && on {on=0; done=1} on {print}' "$STD" > "$WORK/annex/idempotency-keys.md"
cp "$ROOT/standard/conformance/vault/knowledge/backend/payments/retry-policy.md" "$WORK/annex/"
if "$CHECK" "$WORK/annex/idempotency-keys.md" >/dev/null 2>&1; then
  pass "S2 the example in Annex A is valid"
else
  fail "S2 the example in Annex A is valid"
fi

# ---- S3: invalid documents fail with the named rule
for f in "$ROOT"/standard/conformance/invalid/*.md; do
  rule=$(basename "$f" .md)
  out=$("$CHECK" "$f" 2>&1) && { fail "S3 $rule passes but must fail"; continue; }
  case "$out" in *": $rule:"*) pass "S3 $rule fails" ;; *) fail "S3 $rule fails with another rule: $out" ;; esac
done
# cases that are built here, because the file itself is the problem
cp "$ROOT/standard/conformance/vault/knowledge/glossary-terms.md" "$WORK/Bad-Name.md"
out=$("$CHECK" "$WORK/Bad-Name.md" 2>&1) && fail "S3 file-name passes but must fail" || {
  case "$out" in *": file-name:"*) pass "S3 file-name fails" ;; *) fail "S3 file-name fails with another rule" ;; esac; }
{ cat "$ROOT/standard/conformance/vault/knowledge/glossary-terms.md"
  awk 'BEGIN{for(i=0;i<3000;i++) print "A long line of text that fills the document up to the size limit of the standard."}'; } > "$WORK/too-large.md"
out=$("$CHECK" "$WORK/too-large.md" 2>&1) && fail "S3 too-large passes but must fail" || {
  case "$out" in *": too-large:"*) pass "S3 too-large fails" ;; *) fail "S3 too-large fails with another rule" ;; esac; }

# a wikilink in a property must name an existing document
mkdir -p "$WORK/kb/knowledge"
make_doc() { # make_doc <file> [extra frontmatter line]
  {
    echo "---"
    echo "title: A valid title for the wikilink test document"
    echo "description: A short valid description that says what the document contains and when to read it."
    echo "status: active"
    echo "created: 2026-11-08"
    echo "updated: 2026-11-08"
    echo 'created_by: "Jane Doe <jane@corp.example.org>"'
    echo 'updated_by: "Jane Doe <jane@corp.example.org>"'
    [ -n "${2:-}" ] && printf '%s\n' "$2"
    echo "---"
    echo
    echo "Body."
  } > "$1"
}
make_doc "$WORK/kb/knowledge/ok.md"
make_doc "$WORK/kb/knowledge/target.md"
make_doc "$WORK/kb/knowledge/good-wikilink.md" 'related:
  - "[[target]]"'
make_doc "$WORK/kb/knowledge/bad-wikilink.md" 'related:
  - "[[does/not-exist]]"'
if "$CHECK" "$WORK/kb/knowledge/good-wikilink.md" >/dev/null 2>&1; then pass "S3 wikilink to an existing document passes"; else fail "S3 wikilink to an existing document passes"; fi
if "$CHECK" "$WORK/kb/knowledge/ok.md" >/dev/null 2>&1; then pass "S3 control document passes"; else fail "S3 control document passes"; fi
out=$("$CHECK" "$WORK/kb/knowledge/bad-wikilink.md" 2>&1) && fail "S3 broken-wikilink passes but must fail" || {
  case "$out" in *": broken-wikilink:"*) pass "S3 broken-wikilink fails" ;; *) fail "S3 broken-wikilink fails with another rule: $out" ;; esac; }

# ---- S6: the sample vault is rich enough to be a useful test
V="$ROOT/standard/conformance/vault/knowledge"
count=$(find "$V" -name '*.md' | wc -l | tr -d ' ')
[ "$count" -ge 15 ] && pass "S6 vault has at least 15 documents ($count)" || fail "S6 vault has at least 15 documents ($count)"
big=$(find "$V" -name '*.md' -size +20000c | wc -l | tr -d ' ')
[ "$big" -ge 4 ] && pass "S6 vault has at least 4 documents over 20 KB ($big)" || fail "S6 vault has at least 4 documents over 20 KB ($big)"
huge=$(find "$V" -name '*.md' -size +40000c | wc -l | tr -d ' ')
[ "$huge" -ge 2 ] && pass "S6 vault has at least 2 documents over 40 KB ($huge)" || fail "S6 vault has at least 2 documents over 40 KB ($huge)"
grep -rqx "status: deprecated" "$V" && pass "S6 vault has a deprecated document" || fail "S6 vault has a deprecated document"
grep -rqx "disputed: true" "$V" && pass "S6 vault has a disputed document" || fail "S6 vault has a disputed document"
grep -rq "^supersedes:" "$V" && pass "S6 vault has a supersedes link" || fail "S6 vault has a supersedes link"
grep -rq "^anchors:" "$V" && pass "S6 vault has anchors" || fail "S6 vault has anchors"
grep -rq "^trust:" "$V" && pass "S6 vault has a trust field" || fail "S6 vault has a trust field"
grep -rqP '[^\x00-\x7F]' "$V" 2>/dev/null || grep -rq 'Größe' "$V"
[ $? -eq 0 ] && pass "S6 vault has non-ASCII text" || fail "S6 vault has non-ASCII text"
grep -rq '\[!' "$V" && pass "S6 vault has a callout" || fail "S6 vault has a callout"

# ---- S4: the standard and the skills agree
table() { awk '/^\| Field \| Required \| Meaning \|$/ {on=1} on && /^\|/ {print; next} on {exit}' "$1"; }
table "$STD" > "$WORK/std.table"
[ -s "$WORK/std.table" ] || fail "S4 no field table in the standard"
for f in "$ROOT/personal-knowledge-base/SKILL.md" "$ROOT/team-knowledge-base/SKILL.md"; do
  s=$(basename "$(dirname "$f")")
  table "$f" > "$WORK/skill.table"
  if cmp -s "$WORK/std.table" "$WORK/skill.table"; then pass "S4 $s: field table equals the standard"; else fail "S4 $s: field table equals the standard"; fi
  grep -qF "A document is at most 100 KB" "$f" && pass "S4 $s: document limit" || fail "S4 $s: document limit"
done
grep -q 'MAX_BYTES=102400' "$CHECK" && grep -q 'MAX_TITLE_WORDS=15' "$CHECK" && grep -q 'MAX_DESCRIPTION_WORDS=50' "$CHECK" \
  && grep -qF '| Whole document | 102400 bytes' "$STD" && grep -qF '| `title` | 15 words |' "$STD" && grep -qF '| `description` | 50 words |' "$STD" \
  && pass "S4 limits in the checker match the standard" || fail "S4 limits in the checker match the standard"

echo
if [ "$failures" -eq 0 ]; then echo "All tests passed."; else echo "$failures test(s) failed."; fi
[ "$failures" -eq 0 ]
