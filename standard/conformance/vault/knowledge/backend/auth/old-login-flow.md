---
title: The old login flow used a server session and a single cookie
description: Describes the old login flow that was replaced by token based login. Kept for history. Do not build on it.
status: deprecated
created: 2025-03-10
updated: 2026-10-01
created_by: "Sam Roe <sam.roe@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
tags:
  - auth
  - history
---

# Old login flow

The server kept the session in memory and sent one cookie. This did not scale
across regions. It was replaced by the flow in [login flow](login-flow.md).
