check "nothing was changed (no new commit)" at_base
check "clean tree" tree_clean
check "answer saved" answer_nonempty
check "answer says the document is stale or old" answer_has 'stale|out of date|outdated|old|not been updated|not updated|months ago'
check "answer gives the rule" answer_has 'first monday'
