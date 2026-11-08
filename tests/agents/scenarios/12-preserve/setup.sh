#!/bin/sh
[ "$1" = base ] || exit 0
. "$HERE/lib.sh"
mkdoc "$KB/platform/runbook-oncall.md" "On-call runbook for the platform team" "How the platform on-call person reacts to a page, who to call next, and how long to wait. Read it before your first on-call shift." "$TODAY" 'x_owner: platform-team
trust: reviewed
verified_by: "Alex Kim <alex.kim@corp.example.org>"
verified: 2026-10-01' <<'EOT'
# On-call runbook

> [!warning] Never page the same person twice in one hour.

%% internal note: this page is read out loud in the weekly sync %%

## Escalation

If nobody answers, wait 10 minutes and page the on-call lead.
EOT
