#!/bin/sh
[ "$1" = base ] || exit 0
. "$HERE/lib.sh"
mkdoc "$KB/platform/release-calendar.md" "Release freeze dates for production deployments" "When the release freeze starts each month and who can approve an exception. Read it before you plan a release." "$(days_ago 400)" <<'EOT'
# Release calendar

The release freeze starts on the first Monday of each month and lasts two
days. The release manager can approve an exception.
EOT
