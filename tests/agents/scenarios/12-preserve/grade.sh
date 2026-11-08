P=platform/runbook-oncall.md
check "wait time is 15 minutes" file_has $P "wait 15 minutes"
check "10 minutes is gone" file_lacks $P "wait 10 minutes"
check "unknown property is kept" file_has $P "x_owner: platform-team"
check "trust is kept" file_has $P "trust: reviewed"
check "verified_by is kept" file_has $P 'verified_by: "Alex Kim <alex.kim@corp.example.org>"'
check "verified is kept" file_has $P "verified: 2026-10-01"
check "callout is kept" file_has $P "> [!warning] Never page the same person twice in one hour."
check "comment is kept" file_has $P "%% internal note: this page is read out loud in the weekly sync %%"
check "updated_by is the person" file_has $P "updated_by: \"Sam Lee <sam.lee@acme-payments.io>\""
check "created_by is kept" file_has $P 'created_by: "Alex Kim <alex.kim@corp.example.org>"'
common_write
