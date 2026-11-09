#!/bin/sh
# Reference checker for MKBase 1.0 (standard/mkbase-1.0.md).
# It checks the rules that a shell can check, for the conformance test set.
# It reads the flat subset of YAML that the standard allows. It is not a full
# YAML parser, and the standard (not this tool) decides what is conforming.
#
# Usage: check-document.sh <file.md>...
# Prints "FAIL <file>: <rule>: <message>" for every broken rule.
# Exit status: 0 if every file passes, 1 otherwise.

set -u

MAX_BYTES=102400
MAX_TITLE_WORDS=15
MAX_DESCRIPTION_WORDS=50
STATUSES="active deprecated"

status=0
fail() { # fail <file> <rule> <message>
  echo "FAIL $1: $2: $3"
  status=1
}

# find_root <file>: print the first folder above the file that holds a .mkbase folder
find_root() {
  d=$(cd "$(dirname "$1")" 2>/dev/null && pwd) || return 1
  while [ -n "$d" ]; do
    if [ -d "$d/.mkbase" ]; then echo "$d"; return 0; fi
    [ "$d" = "/" ] && return 1
    d=$(dirname "$d")
  done
  return 1
}

# is_excluded <file> <root>: true if the file is hidden (a path part starts with
# a dot) or if .mkbase/exclude of the root names it or a folder above it
is_excluded() {
  rel=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
  rel=${rel#"$2"/}
  case "/$rel" in */.*) return 0 ;; esac
  [ -f "$2/.mkbase/exclude" ] || return 1
  grep -v '^[[:space:]]*#' "$2/.mkbase/exclude" | grep -v '^[[:space:]]*$' | while IFS= read -r line; do
    line=${line%/}
    case "$rel" in "$line"|"$line"/*) echo yes; break ;; esac
  done | grep -q yes
}

check_file() {
  file=$1
  name=$(basename "$file")

  root=$(find_root "$file" || true)
  if [ -n "$root" ] && is_excluded "$file" "$root"; then
    echo "SKIP $file: not part of the knowledge base"
    return
  fi

  printf '%s\n' "$name" | grep -Eq '^[a-z0-9-]+\.md$' ||
    fail "$file" file-name "use lowercase letters, digits, and - only"

  size=$(wc -c < "$file" | tr -d ' ')
  [ "$size" -le "$MAX_BYTES" ] ||
    fail "$file" too-large "$size bytes, the limit is $MAX_BYTES"

  if [ "$(head -n 1 "$file")" != "---" ]; then
    fail "$file" no-frontmatter "the file must start with a line ---"
    return
  fi
  close=$(awk 'NR>1 && /^---$/ {print NR; exit}' "$file")
  if [ -z "$close" ]; then
    fail "$file" unclosed-frontmatter "no closing line ---"
    return
  fi
  fm=$(sed -n "2,$((close - 1))p" "$file")
  body=$(sed -n "$((close + 1)),\$p" "$file")

  # Flat properties: an indented line must be a list item.
  if printf '%s\n' "$fm" | grep -E '^[[:space:]]+' | grep -Evq '^[[:space:]]+-[[:space:]]'; then
    fail "$file" nested-property "properties must be flat"
  fi

  get() { # get <key>: the value of a top-level key, without quotes at the ends
    printf '%s\n' "$fm" | sed -n "s/^$1:[[:space:]]*//p" | head -n 1
  }

  for key in title description status created updated created_by updated_by; do
    [ -n "$(get "$key")" ] || fail "$file" "missing-$key" "required field $key is missing or empty"
  done

  s=$(get status)
  if [ -n "$s" ]; then
    case " $STATUSES " in *" $s "*) ;; *) fail "$file" bad-status "status '$s' is not active or deprecated" ;; esac
  fi

  created=$(get created)
  updated=$(get updated)
  date_ok=1
  for d in "$created" "$updated"; do
    if [ -n "$d" ] && ! printf '%s\n' "$d" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; then
      fail "$file" bad-date "'$d' is not YYYY-MM-DD"
      date_ok=0
    fi
  done
  if [ "$date_ok" -eq 1 ] && [ -n "$created" ] && [ -n "$updated" ]; then
    awk -v a="$updated" -v b="$created" 'BEGIN{exit !(a<b)}' &&
      fail "$file" updated-before-created "updated is earlier than created"
  fi

  for key in created_by updated_by; do
    v=$(get "$key")
    if [ -n "$v" ] && ! printf '%s\n' "$v" | grep -Eq '^"?[^<"]+ <[^@ <>]+@[^ <>]+>"?$'; then
      fail "$file" bad-author "$key must look like \"Name <email>\""
    fi
  done

  words=$(get title | awk '{print NF}')
  [ "${words:-0}" -le "$MAX_TITLE_WORDS" ] ||
    fail "$file" title-too-long "$words words, the limit is $MAX_TITLE_WORDS"
  words=$(get description | awk '{print NF}')
  [ "${words:-0}" -le "$MAX_DESCRIPTION_WORDS" ] ||
    fail "$file" description-too-long "$words words, the limit is $MAX_DESCRIPTION_WORDS"

  if [ "$(get disputed)" = "true" ] && [ -z "$(get dispute_reason)" ]; then
    fail "$file" disputed-without-reason "disputed: true needs a dispute_reason"
  fi

  # Relative Markdown links to .md files must point to an existing file.
  dir=$(dirname "$file")
  printf '%s\n' "$body" | grep -Eo '\]\([^)]*\.md(#[^)]*)?\)' | sed 's/^](//; s/)$//; s/#.*$//' |
    while IFS= read -r target; do
      case "$target" in http://*|https://*) continue ;; esac
      [ -f "$dir/$target" ] || echo "$target"
    done > "${TMPDIR:-/tmp}/mkbase-links.$$"
  while IFS= read -r target; do
    fail "$file" broken-link "no file for the link $target"
  done < "${TMPDIR:-/tmp}/mkbase-links.$$"
  rm -f "${TMPDIR:-/tmp}/mkbase-links.$$"

  # Wikilinks in properties name a document by its ID, a path below the root.
  if [ -n "$root" ]; then
    printf '%s\n' "$fm" | grep -Eo '\[\[[^]]+\]\]' | sed 's/^\[\[//; s/\]\]$//' > "${TMPDIR:-/tmp}/mkbase-wiki.$$"
    while IFS= read -r id; do
      [ -f "$root/$id.md" ] || fail "$file" broken-wikilink "no document for the ID $id"
    done < "${TMPDIR:-/tmp}/mkbase-wiki.$$"
    rm -f "${TMPDIR:-/tmp}/mkbase-wiki.$$"
  fi
}

for f in "$@"; do
  check_file "$f"
done
exit "$status"
