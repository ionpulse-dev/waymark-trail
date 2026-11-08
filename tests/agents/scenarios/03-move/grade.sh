check "retry policy is at the new path" file_there backend/resilience/retry-policy.md
check "idempotency keys is at the new path" file_there backend/resilience/idempotency-keys.md
check "old paths are gone" sh -c "[ ! -e '$KB/backend/payments/retry-policy.md' ] && [ ! -e '$KB/backend/payments/idempotency-keys.md' ]"
check "history follows the retry policy" sh -c "[ \$(git -C '$KB' log --follow --format=%H -- backend/resilience/retry-policy.md | wc -l) -ge 2 ]"
check "history follows idempotency keys" sh -c "[ \$(git -C '$KB' log --follow --format=%H -- backend/resilience/idempotency-keys.md | wc -l) -ge 2 ]"
check "the moves are pure renames (100 percent)" sh -c "[ \$(git -C '$KB' log --format= --name-status -M100% '$BASE..HEAD' | grep -c '^R100') -ge 2 ]"
check "no moved file changed in its move commit" sh -c "git -C '$KB' log --format= --name-status -M '$BASE..HEAD' | grep '^R' | grep -qv '^R100' && exit 1 || exit 0"
common_write
