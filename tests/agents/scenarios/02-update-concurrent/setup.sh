#!/bin/sh
# A colleague pushed a change to the same document. The local clone is behind.
[ "$1" = remote ] || exit 0
C="$RUN/colleague"
git clone -q "$ORIGIN" "$C"
git -C "$C" config user.name Colleague
git -C "$C" config user.email colleague@acme-payments.io
printf '\nAdded by a colleague.\n' >> "$C/backend/payments/retry-policy.md"
git -C "$C" commit -qam 'kb: update "colleague change"'
git -C "$C" push -q origin main
