check "the file still exists" sh -c "git -C '$KB' ls-files | grep -qx 'frontend/design-tokens.md' || git -C '$KB' ls-files | grep -q 'design-tokens.md'"
check "no file was deleted in any commit" no_deletions
check "clean tree" tree_clean
check "all documents conform to the standard" docs_pass
check "origin kept its earlier history" origin_keeps_base
check "answer saved" answer_nonempty
