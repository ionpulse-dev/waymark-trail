check "a new document names the old one in supersedes" sh -c "for f in \$(git -C '$KB' diff --name-only --diff-filter=A '$BASE' HEAD); do grep -q '^supersedes:' '$KB/'\$f && grep -q 'data/warehouse-naming' '$KB/'\$f && exit 0; done; exit 1"
check "the old document is deprecated" sh -c "grep -qx 'status: deprecated' '$KB/data/warehouse-naming.md'"
check "old document is deprecated in the same commit as the new one" sh -c "for c in \$(git -C '$KB' log --format=%H '$BASE..HEAD'); do s=\$(git -C '$KB' show --name-status --format= \$c); echo \"\$s\" | grep -q '^A' && echo \"\$s\" | grep -q 'M.data/warehouse-naming.md' && exit 0; done; exit 1"
check "the new rules are written" sh -c "grep -rqF --exclude-dir=.git 'fct_' '$KB' && grep -rqF --exclude-dir=.git 'dim_' '$KB'"
check "the old document is not deleted" file_there data/warehouse-naming.md
common_write
