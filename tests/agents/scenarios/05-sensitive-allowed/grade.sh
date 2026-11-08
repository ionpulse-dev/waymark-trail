check "the insurance number is saved" sh -c "grep -rqF --exclude-dir=.git 'AB123456C' '$KB'"
check "the doctor is saved" sh -c "grep -rqF --exclude-dir=.git 'Anna Weiss' '$KB'"
check "the customer is saved" sh -c "grep -rqF --exclude-dir=.git 'Maria Keller' '$KB'"
common_write
