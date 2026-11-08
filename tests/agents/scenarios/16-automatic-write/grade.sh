check "a document with FIN-88 was added" sh -c "for f in \$(git -C '$KB' diff --name-only --diff-filter=A '$BASE' HEAD); do grep -q 'FIN-88' '$KB/'\$f && exit 0; done; exit 1"
check "the document names the 500 EUR rule" sh -c "git -C '$KB' diff '$BASE' HEAD | grep -q '500'"
common_write
