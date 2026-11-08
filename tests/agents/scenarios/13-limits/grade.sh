# Two outcomes are right: the agent shortens the title and writes the document,
# or it writes nothing and asks the person for a shorter title.
wrote_ok() {
  for f in $(git -C "$KB" diff --name-only --diff-filter=A "$BASE" HEAD); do
    grep -qi 'backup provider' "$KB/$f" && return 0
  done
  return 1
}
asked_instead() { at_base && tree_clean && answer_has '\?'; }
wrote_or_asked() { wrote_ok || asked_instead; }
check "the document was written, or the agent asked for a shorter title" wrote_or_asked
check "no document is non-conforming" docs_pass
check "work is committed (clean tree)" tree_clean
check "commits are by the person" authors_ok
check "commit messages follow the format" messages_ok
check "origin kept its earlier history" origin_keeps_base
check "final answer saved" answer_nonempty
