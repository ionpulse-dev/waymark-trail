---
title: Session tokens live for fifteen minutes and are refreshed in the background
description: Explains the lifetime of session tokens, how refresh works, and where tokens are stored. Read it before you change login or token code.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Alex Kim <alex.kim@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
tags:
  - auth
  - security
related:
  - "[[backend/auth/token-rotation-gotcha]]"
  - "[[backend/auth/login-flow]]"
---

# Session tokens

A session token lives for **15 minutes**. The client asks for a new token one
minute before the old one ends, with the refresh token. The refresh token lives
for 30 days and works once.

> [!warning]
> Never store a token in local storage. Use a cookie with the flags `HttpOnly`,
> `Secure`, and `SameSite=Lax`.

See the [token rotation gotcha](token-rotation-gotcha.md) for a known problem.
