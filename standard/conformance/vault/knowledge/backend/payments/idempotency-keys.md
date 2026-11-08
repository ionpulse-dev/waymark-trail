---
title: The payment API uses idempotency keys on every write
description: Explains how clients must send an idempotency key with each payment request and what happens on a retry. Read it before you call the payment API.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Jane Doe <jane.doe@corp.example.org>"
updated_by: "Jane Doe <jane.doe@corp.example.org>"
tags:
  - payments
  - api
related:
  - "[[backend/payments/retry-policy]]"
---

# Idempotency keys

A client sends the header `Idempotency-Key` with every write. The server stores
the result for 24 hours. See the [retry policy](retry-policy.md).

> [!note]
> Callouts written by people are allowed and are kept.
