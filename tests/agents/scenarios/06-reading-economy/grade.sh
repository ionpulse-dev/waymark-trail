check "nothing was changed (no new commit)" at_base
check "clean tree" tree_clean
check "answer saved" answer_nonempty
check "answer: tokens live 15 minutes" answer_has '15 minutes|15 min|15-minute'
check "answer: flags the disputed or outdated document" answer_has 'disputed|not reliable|do not trust|don.t trust|outdated|contradict'
check "answer: names the current login flow" answer_has 'login-flow|login flow|session-tokens|session tokens'
check "answer: nothing found for quantum keys" answer_has 'nothing|no document|not found|no mention|none|did not find|didn.t find|could not find|couldn.t find|no result'
check "at most 10 documents read in full" reads_at_most 10
