check "a document about the backup provider was added" sh -c "for f in \$(git -C '$KB' diff --name-only --diff-filter=A '$BASE' HEAD); do grep -qi 'backup provider' '$KB/'\$f && exit 0; done; exit 1"
common_write
