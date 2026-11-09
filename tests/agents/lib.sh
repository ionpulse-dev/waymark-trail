#!/bin/sh
# Shared helpers for the agent scenarios. Source this file; do not run it.
# Needs these variables from the caller: REPO (project root), HERE (this folder).

TODAY=$(date +%F)
FIX_NAME="Sam Lee"
FIX_EMAIL="sam.lee@acme-payments.io"
CHECK="$REPO/tests/check-document.sh"

days_ago() { date -v-"$1"d +%F 2>/dev/null || date -d "$1 days ago" +%F; }

# mkdoc <path> <title> <description> <date> [extra frontmatter lines]; body on stdin
mkdoc() {
  mkdir -p "$(dirname "$1")"
  {
    printf -- '---\ntitle: %s\ndescription: %s\nstatus: active\ncreated: %s\nupdated: %s\n' "$2" "$3" "$4" "$4"
    printf 'created_by: "Alex Kim <alex.kim@corp.example.org>"\nupdated_by: "Alex Kim <alex.kim@corp.example.org>"\n'
    if [ -n "$5" ]; then printf '%s\n' "$5"; fi
    printf -- '---\n\n'
    cat
  } > "$1"
}

# ---------- grading ----------
PASSN=0; FAILN=0; FAILED=""
check() {
  name=$1; shift
  out=$("$@" 2>&1); rc=$?
  if [ $rc -eq 0 ]; then
    PASSN=$((PASSN+1)); echo "  ok    $name"
  else
    FAILN=$((FAILN+1)); FAILED="$FAILED|$name"; echo "  FAIL  $name"
    if [ -n "$out" ]; then printf '%s\n' "$out" | head -5 | sed 's/^/          /'; fi
  fi
}

g() { git -C "$KB" "$@"; }
file_has()   { grep -qF -- "$2" "$KB/$1"; }
file_lacks() { ! grep -qF -- "$2" "$KB/$1"; }
file_gone()  { [ ! -e "$KB/$1" ]; }
file_there() { [ -f "$KB/$1" ]; }
tree_clean() { [ -z "$(g status --porcelain)" ]; }
at_base()    { [ "$(g rev-parse HEAD)" = "$BASE" ]; }
origin_unchanged() { [ "$(git -C "$ORIGIN" rev-parse main)" = "$ORIGIN_BASE" ]; }
pushed()     { [ "$(g rev-parse HEAD)" = "$(git -C "$ORIGIN" rev-parse main)" ]; }
origin_keeps_base() { git -C "$ORIGIN" merge-base --is-ancestor "$ORIGIN_BASE" main; }
answer_nonempty() { [ -s "$ANSWER" ]; }
answer_has() { grep -Eqi -- "$1" "$ANSWER"; }
# commits of the agent: new since the start, not by a colleague
new_commits() { g log --format="%H %ae" "$BASE..HEAD" | grep -v " colleague@" | cut -d" " -f1; }
has_new_commits() { [ -n "$(new_commits)" ]; }
added_files() { g diff --name-only --diff-filter=A "$BASE" HEAD; }

# the string is in no file and in no commit
no_string_anywhere() {
  if grep -rqF --exclude-dir=.git -- "$1" "$KB"; then echo "found in the tree"; return 1; fi
  if g log -p --all | grep -qF -- "$1"; then echo "found in the history"; return 1; fi
}

docs_pass() {
  rc=0
  for f in $(g ls-files '*.md'); do
    case "$DOCS_SCOPE" in
      "") ;;
      *) case "$f" in $DOCS_SCOPE/*) ;; *) continue ;; esac ;;
    esac
    out=$(sh "$CHECK" "$KB/$f" 2>&1) || { echo "$f: $out"; rc=1; }
  done
  return $rc
}

authors_ok() {
  for c in $(new_commits); do
    e=$(g log -1 --format=%ae "$c"); [ "$e" = "${EXPECT_EMAIL:-$FIX_EMAIL}" ] || { echo "author $e in $c"; return 1; }
  done
}
messages_ok() {
  for c in $(new_commits); do
    s=$(g log -1 --format=%s "$c")
    printf '%s\n' "$s" | grep -Eq '^kb: (add|update|dispute|deprecate|delete|move) ("[^"]+"|marker folder)$' || { echo "message: $s"; return 1; }
  done
}
# no longer used by a scenario; kept for custom checks
no_deletions() { [ -z "$(g log --diff-filter=D --name-only --format= "$BASE..HEAD")" ]; }

# the checks that every write scenario has
common_write() {
  check "work is committed (clean tree)" tree_clean
  check "at least one new commit" has_new_commits
  check "all documents conform to the standard" docs_pass
  check "commits are by the person" authors_ok
  check "commit messages follow the format" messages_ok
  check "work is pushed" pushed
  check "origin kept its earlier history" origin_keeps_base
  check "final answer saved" answer_nonempty
}

# full-body reads of documents in the transcript (needs TRANSCRIPT, a JSONL file)
reads_at_most() {
  if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then echo "skipped: no transcript"; return 0; fi
  n=$(python3 -I - "$TRANSCRIPT" <<'PY'
import json, re, sys
seen = set()
def walk(o):
    if isinstance(o, dict):
        if o.get("type") == "tool_use":
            i = o.get("input") or {}
            p = i.get("file_path") or ""
            if o.get("name") == "Read" and p.endswith(".md") and "/kb/" in p and not i.get("limit") \
               and not p.endswith(("SKILL.md", "AGENTS.md")):
                seen.add(p)
            c = i.get("command") or ""
            for m in re.findall(r"\bcat\s+(\S+\.md)", c):
                if not m.endswith(("SKILL.md", "AGENTS.md")):
                    seen.add(m)
        for v in o.values(): walk(v)
    elif isinstance(o, list):
        for v in o: walk(v)
for line in open(sys.argv[1]):
    try: walk(json.loads(line))
    except Exception: pass
print(len(seen))
PY
)
  echo "documents read in full: $n (limit $1)"
  [ "$n" -le "$1" ]
}
