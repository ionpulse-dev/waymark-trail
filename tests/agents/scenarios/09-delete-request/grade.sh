check "the document is gone" sh -c "! git -C '$KB' ls-files | grep -q 'frontend/design-tokens.md'"
check "no link to the deleted document is left" sh -c "! grep -rq 'design-tokens' '$KB' --include='*.md'"
check "one delete commit with the format" sh -c "[ \$(git -C '$KB' log --format=%s '$BASE..HEAD' | grep -c '^kb: delete \"') -eq 1 ]"
check "clean tree" tree_clean
check "all documents conform to the standard" docs_pass
check "origin kept its earlier history" origin_keeps_base
check "work is pushed" pushed
check "answer saved" answer_nonempty
