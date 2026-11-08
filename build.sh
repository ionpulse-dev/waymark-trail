#!/bin/sh
# Build the two finished skill files from the parts in src/.
#
# Usage:
#   ./build.sh           write both finished files
#   ./build.sh --check   build into a temporary folder and compare with the
#                        committed files; exit 1 if any file differs
#
# A finished file is: frontmatter, a one-line license header, the role part,
# then the common part. Nobody edits a finished file by hand.

set -eu

ROOT=$(cd "$(dirname "$0")" && pwd)
SKILLS="personal team"
LICENSE_LINE="<!-- MIT License. Copyright (c) 2026 IonPulse. -->"

skill_name() {
  case "$1" in
    personal) echo "personal-knowledge-base" ;;
    team) echo "team-knowledge-base" ;;
  esac
}

# build_one <role> <output root>
build_one() {
  role=$1
  out_root=$2
  dir="$out_root/$(skill_name "$role")"
  mkdir -p "$dir"
  {
    echo "---"
    cat "$ROOT/src/frontmatter/$role.yaml"
    echo "---"
    echo
    echo "$LICENSE_LINE"
    echo
    cat "$ROOT/src/$role.md"
    echo
    cat "$ROOT/src/common.md"
  } > "$dir/SKILL.md"
}

mode=build
if [ "${1:-}" = "--check" ]; then
  mode=check
elif [ $# -gt 0 ]; then
  echo "Unknown argument: $1" >&2
  exit 2
fi

if [ "$mode" = "build" ]; then
  for role in $SKILLS; do
    build_one "$role" "$ROOT"
    echo "Wrote $(skill_name "$role")/SKILL.md"
  done
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
status=0
for role in $SKILLS; do
  build_one "$role" "$tmp"
  file="$(skill_name "$role")/SKILL.md"
  if ! cmp -s "$tmp/$file" "$ROOT/$file"; then
    echo "Out of date: $file (run ./build.sh)" >&2
    status=1
  fi
done
[ "$status" -eq 0 ] && echo "OK: finished files match the build."
exit "$status"
