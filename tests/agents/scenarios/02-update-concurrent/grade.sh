P=backend/payments/retry-policy.md
check "the colleague's line is still there" file_has $P "Added by a colleague."
check "the Jitter section exists" file_has $P "Jitter"
check "25 percent is written" file_has $P "25 percent"
check "ticket PAY-2001 is a source" file_has $P "PAY-2001"
check "old sources are kept" file_has $P "TICKET-1042"
check "updated_by is the person" file_has $P "sam.lee@acme-payments.io"
common_write
