---
title: Two tabs can race on token rotation and log the person out
description: Describes a bug pattern where two browser tabs refresh the same token at once, so the second refresh fails. Read it when people report random logouts.
status: active
created: 2026-11-02
updated: 2026-11-07
created_by: "Sam Roe <sam.roe@corp.example.org>"
updated_by: "Sam Roe <sam.roe@corp.example.org>"
tags:
  - auth
  - bug-pattern
sources:
  - TICKET-0911
---

# Token rotation race

A refresh token works once. If two tabs refresh at the same moment, the server
accepts the first call and rejects the second. The second tab then shows the login page.

**Fix.** Use a lock between tabs (the browser `BroadcastChannel`), so that only one
tab refreshes. See [session tokens](session-tokens.md).
