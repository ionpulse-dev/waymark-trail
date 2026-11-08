---
title: Login uses short tokens, a refresh token, and a second factor
description: Describes the current login flow with password, second factor, short tokens, and refresh. It replaces the old server session flow.
status: active
created: 2026-10-01
updated: 2026-11-08
created_by: "Alex Kim <alex.kim@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
supersedes:
  - "[[backend/auth/old-login-flow]]"
related:
  - "[[backend/auth/session-tokens]]"
tags:
  - auth
  - security
---

# Login flow

1. The person sends email and password.
2. The server asks for the second factor.
3. The server returns a session token and a refresh token (see [session tokens](session-tokens.md)).

The old flow is described in [old login flow](old-login-flow.md) and is deprecated.
