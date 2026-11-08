check "a migration document was added in platform" sh -c "git -C '$KB' diff --name-only --diff-filter=A '$BASE' HEAD | grep -i '^platform/.*migration'"
check "the answer says which test the request fails" answer_has 'status update|three months|still be true|not worth|worth a document'
common_write
