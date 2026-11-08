DOCS_SCOPE=operations
check "marker file says 1.0" sh -c "[ \"\$(tr -d '\n' < '$KB/.mkbds/version')\" = 1.0 ]"
check "marker has its own commit" sh -c "git -C '$KB' log --format=%s | grep -qx 'kb: add marker folder'"
check "two documents in operations" sh -c "[ \$(ls '$KB'/operations/*.md | wc -l) -ge 2 ]"
check "every document names ticket OPS-210" sh -c "[ -z \"\$(grep -L 'OPS-210' '$KB'/operations/*.md)\" ]"
check "every document has tags tls and security" sh -c "[ -z \"\$(grep -L '^  - tls' '$KB'/operations/*.md)\" ] && [ -z \"\$(grep -L '^  - security' '$KB'/operations/*.md)\" ]"
check "a document links the other in related" sh -c "grep -q '\[\[operations/' '$KB'/operations/*.md"
common_write
