#!/bin/sh
# Content checks for the finished skill files. They check the text of the
# rules. Whether an agent follows the rules is checked by hand (see the
# test.md file of each feature spec).

set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
P="$ROOT/personal-knowledge-base/SKILL.md"
T="$ROOT/team-knowledge-base/SKILL.md"

failures=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1"; failures=$((failures + 1)); }
has() { # has <file> <fixed text>
  grep -qF -- "$2" "$1"
}
check() { # check <name> <file> <fixed text>...
  name=$1; file=$2; shift 2
  for text in "$@"; do
    if ! has "$file" "$text"; then
      fail "$name (missing: $text)"
      return
    fi
  done
  pass "$name"
}

# ---------- both skills ----------
for f in "$P" "$T"; do
  s=$(basename "$(dirname "$f")")

  check "$s: reading is Manual by default" "$f" \
    "Both settings start at Manual" \
    "you search and open documents only when the person asks"
  check "$s: writing is Manual by default" "$f" \
    "you create, change, or move documents only when the" \
    "Only the person changes a setting, in plain words"
  check "$s: table is shown again" "$f" \
    "after every change of a setting" \
    "after every question about the settings" \
    "after the context was compacted"
  check "$s: write steps" "$f" \
    "git pull --rebase" \
    "Compare its last commit with the one you remembered" \
    "Commit under the name and email of the person" \
    "Never force a push"
  check "$s: size cap and split rule" "$f" \
    "A document is at most 100 KB" \
    "split it or move the"
  check "$s: document fields" "$f" \
    '`title`' '`description`' '`status`' '`created`, `updated`' \
    '`created_by`, `updated_by`' '`disputed`' '`dispute_reason`' '`sources`' \
    '`tags`' '`related`' '`supersedes`' '`anchors`' \
    '`trust`, `verified_by`, `verified`'
  check "$s: file name and link rules" "$f" \
    'lowercase letters, digits, and `-` only' \
    'also when the title changes' \
    'relative Markdown links with `.md`' \
    '"[[backend/payments/retry-policy]]"'
  check "$s: title and description limits" "$f" \
    "at most 15 words" "At most 50 words"
  check "$s: names the standard" "$f" "MKBDS) 1.0"
  check "$s: move rules" "$f" \
    "Use \`git mv\`" "git log --follow"
  check "$s: secrets" "$f" \
    "Never write these into a document" "stop and ask the person"

  if grep -qiE 'waymark|settings file|config file' "$f"; then
    fail "$s: no mention of other tools or a settings file"
  else
    pass "$s: no mention of other tools or a settings file"
  fi
done

# ---------- sizes ----------
[ "$(wc -c < "$P")" -le 12000 ] && pass "personal: stays short (12 KB)" || fail "personal: stays short (12 KB)"
[ "$(wc -c < "$T")" -le 16000 ] && pass "team: stays short (16 KB)" || fail "team: stays short (16 KB)"

# ---------- personal ----------
check "personal: start message" "$P" \
  "**Knowledge base active:** \`<name of the repository>\`" \
  "| **Reading** | ● | |" \
  "| **Writing** | ● | |" \
  "Want a different setting? Just tell me."

# ---------- team ----------
check "team: start message" "$T" \
  "(shared with your team)" \
  "| **Reading** | ● | |" \
  "| **Writing** | ● | |" \
  "Every change is committed under your name. Everyone with access sees every document."
check "team: author and email" "$T" \
  "committed under the person's own" "The email must be reachable" "There is no separate author for the agent"
check "team: dispute and deprecate" "$T" \
  "set \`disputed: true\`" "Do not rewrite another team's document on your own" "A deprecated document stays in the"
check "team: stale threshold" "$T" "180 days" "shared"
check "team: confidentiality" "$T" "Everyone with read access sees every document"
check "team: collision keeps both" "$T" "-conflict.md" "Never leave the repository in a conflict state"

# ---------- team has all shared rules ----------
common_lines=$(wc -l < "$ROOT/src/common.md")
if [ "$(tail -n "$common_lines" "$T")" = "$(cat "$ROOT/src/common.md")" ] \
   && [ "$(tail -n "$common_lines" "$P")" = "$(cat "$ROOT/src/common.md")" ]; then
  pass "both skills end with the identical shared rules"
else
  fail "both skills end with the identical shared rules"
fi

echo
if [ "$failures" -eq 0 ]; then echo "All tests passed."; else echo "$failures test(s) failed."; fi
[ "$failures" -eq 0 ]
