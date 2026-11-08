---
title: Clients retry failed payment writes with the same idempotency key
description: Describes when a client may retry a payment write, how long it waits, and why it must reuse the key. Read it when you build a payment client.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Jane Doe <jane.doe@corp.example.org>"
updated_by: "Sam Roe <sam.roe@corp.example.org>"
sources:
  - TICKET-1042
tags:
  - payments
anchors:
  - "url:https://example.org/docs/payments/retries"
---

# Retry policy

A client retries after a network error or a response with status 503. It waits
one second, then two, then four. It always sends the key from the first attempt.
The key is explained in [idempotency keys](idempotency-keys.md).
