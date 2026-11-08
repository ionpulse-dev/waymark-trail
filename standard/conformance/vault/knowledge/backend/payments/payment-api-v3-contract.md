---
title: Payment API v3 contract: endpoints, errors, and webhook events
description: The full contract of payment API version 3 with conventions, authentication, errors, every endpoint, and webhook events. Read it before you build or change a client.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Sam Roe <sam.roe@corp.example.org>"
updated_by: "Jane Doe <jane.doe@corp.example.org>"
tags:
  - payments
  - api
  - contract
sources:
  - TICKET-1042
  - https://example.org/docs/payments/v3
related:
  - "[[backend/payments/retry-policy]]"
  - "[[backend/payments/idempotency-keys]]"
anchors:
  - "git:payments-service/openapi/v3.yaml@3f9a1c2"
---

# Payment API v3 contract

This document is the contract of the payment API, version 3. Clients and the platform team rely on it. A change that breaks it needs a new version of the API. The rules for retries are in [retry policy](retry-policy.md), and the rules for keys are in [idempotency keys](idempotency-keys.md).

## Conventions

- All bodies are JSON with UTF-8 text. Field names use `snake_case`.
- Money is an integer in the smallest unit of the currency, with a three-letter ISO code.
- Times are UTC in the form `2026-11-08T09:30:00Z`.
- Every write needs the header `Idempotency-Key`.
- A list returns at most 100 items and a `next_cursor`.

## Authentication

Send the secret key as a bearer token: `Authorization: Bearer sk_live_...`. Keys belong to one account and one mode (test or live). A test key never touches live money.

## Errors

An error has the body `{"error": {"code": "...", "message": "...", "request_id": "..."}}`.

| Code | Status | Meaning |
|---|---|---|
| `invalid_request` | 400 | The request body or a parameter is not valid. |
| `unauthorized` | 401 | The API key is missing or wrong. |
| `forbidden` | 403 | The key has no right for this resource. |
| `not_found` | 404 | The resource does not exist. |
| `idempotency_conflict` | 409 | The key was used with a different body. |
| `unprocessable` | 422 | The request is valid but the state does not allow it. |
| `rate_limited` | 429 | Too many requests. Wait for the time in `Retry-After`. |
| `server_error` | 500 | An error on our side. Retry with the same key. |
| `unavailable` | 503 | The service is busy. Retry with the same key. |

## Endpoints

### 1. POST `/v3/payments`

Create a payment. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `amount` | integer | yes | Rules for `amount` are in the field catalog of the account guide. |
| `currency` | string | yes | Rules for `currency` are in the field catalog of the account guide. |
| `customer_id` | string | no | Rules for `customer_id` are in the field catalog of the account guide. |
| `method` | string | no | Rules for `method` are in the field catalog of the account guide. |
| `description` | string | no | Rules for `description` are in the field catalog of the account guide. |
| `metadata` | object | no | Rules for `metadata` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1001",
  "object": "payment",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/payments \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "amount": "example_amount",
  "currency": "example_currency",
  "customer_id": "example_customer_id",
  "method": "example_method",
  "description": "example_description",
  "metadata": "example_metadata"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 2. GET `/v3/payments/{id}`

Read one payment. A successful call returns status 200.

Example response:

```json
{
  "id": "pay_1002",
  "object": "payment",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payments/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 3. GET `/v3/payments`

List payments with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1003",
  "object": "payment",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payments \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 4. PATCH `/v3/payments/{id}`

Change a payment. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `description` | string | no | Rules for `description` are in the field catalog of the account guide. |
| `metadata` | object | no | Rules for `metadata` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1004",
  "object": "payment",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/payments/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "description": "example_description",
  "metadata": "example_metadata"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 5. POST `/v3/refunds`

Create a refund. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | Rules for `payment_id` are in the field catalog of the account guide. |
| `amount` | integer | yes | Rules for `amount` are in the field catalog of the account guide. |
| `reason` | string | no | Rules for `reason` are in the field catalog of the account guide. |
| `metadata` | object | no | Rules for `metadata` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "ref_1005",
  "object": "refund",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/refunds \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "payment_id": "example_payment_id",
  "amount": "example_amount",
  "reason": "example_reason",
  "metadata": "example_metadata"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 6. GET `/v3/refunds/{id}`

Read one refund. A successful call returns status 200.

Example response:

```json
{
  "id": "ref_1006",
  "object": "refund",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/refunds/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 7. GET `/v3/refunds`

List refunds with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "ref_1007",
  "object": "refund",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/refunds \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 8. PATCH `/v3/refunds/{id}`

Change a refund. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `reason` | string | no | Rules for `reason` are in the field catalog of the account guide. |
| `metadata` | object | no | Rules for `metadata` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "ref_1008",
  "object": "refund",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/refunds/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "reason": "example_reason",
  "metadata": "example_metadata"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 9. POST `/v3/customers`

Create a customer. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `email` | string | yes | Rules for `email` are in the field catalog of the account guide. |
| `name` | string | yes | Rules for `name` are in the field catalog of the account guide. |
| `country` | string | no | Rules for `country` are in the field catalog of the account guide. |
| `locale` | string | no | Rules for `locale` are in the field catalog of the account guide. |
| `tax_id` | string | no | Rules for `tax_id` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "cus_1009",
  "object": "customer",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/customers \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "email": "example_email",
  "name": "example_name",
  "country": "example_country",
  "locale": "example_locale",
  "tax_id": "example_tax_id"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 10. GET `/v3/customers/{id}`

Read one customer. A successful call returns status 200.

Example response:

```json
{
  "id": "cus_1010",
  "object": "customer",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/customers/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 11. GET `/v3/customers`

List customers with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "cus_1011",
  "object": "customer",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/customers \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 12. PATCH `/v3/customers/{id}`

Change a customer. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `locale` | string | no | Rules for `locale` are in the field catalog of the account guide. |
| `tax_id` | string | no | Rules for `tax_id` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "cus_1012",
  "object": "customer",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/customers/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "locale": "example_locale",
  "tax_id": "example_tax_id"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 13. POST `/v3/payment-methods`

Create a payment method. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `customer_id` | string | yes | Rules for `customer_id` are in the field catalog of the account guide. |
| `type` | string | yes | Rules for `type` are in the field catalog of the account guide. |
| `token` | string | no | Rules for `token` are in the field catalog of the account guide. |
| `billing_country` | string | no | Rules for `billing_country` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1013",
  "object": "payment-method",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/payment-methods \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "customer_id": "example_customer_id",
  "type": "example_type",
  "token": "example_token",
  "billing_country": "example_billing_country"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 14. GET `/v3/payment-methods/{id}`

Read one payment method. A successful call returns status 200.

Example response:

```json
{
  "id": "pay_1014",
  "object": "payment-method",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payment-methods/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 15. GET `/v3/payment-methods`

List payment-methods with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1015",
  "object": "payment-method",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payment-methods \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 16. PATCH `/v3/payment-methods/{id}`

Change a payment method. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `token` | string | no | Rules for `token` are in the field catalog of the account guide. |
| `billing_country` | string | no | Rules for `billing_country` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1016",
  "object": "payment-method",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/payment-methods/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "token": "example_token",
  "billing_country": "example_billing_country"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 17. POST `/v3/invoices`

Create a invoice. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `customer_id` | string | yes | Rules for `customer_id` are in the field catalog of the account guide. |
| `currency` | string | yes | Rules for `currency` are in the field catalog of the account guide. |
| `due_date` | string | no | Rules for `due_date` are in the field catalog of the account guide. |
| `lines` | array | no | Rules for `lines` are in the field catalog of the account guide. |
| `memo` | string | no | Rules for `memo` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "inv_1017",
  "object": "invoice",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/invoices \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "customer_id": "example_customer_id",
  "currency": "example_currency",
  "due_date": "example_due_date",
  "lines": "example_lines",
  "memo": "example_memo"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 18. GET `/v3/invoices/{id}`

Read one invoice. A successful call returns status 200.

Example response:

```json
{
  "id": "inv_1018",
  "object": "invoice",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/invoices/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 19. GET `/v3/invoices`

List invoices with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "inv_1019",
  "object": "invoice",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/invoices \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 20. PATCH `/v3/invoices/{id}`

Change a invoice. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `lines` | array | no | Rules for `lines` are in the field catalog of the account guide. |
| `memo` | string | no | Rules for `memo` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "inv_1020",
  "object": "invoice",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/invoices/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "lines": "example_lines",
  "memo": "example_memo"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 21. POST `/v3/payouts`

Create a payout. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `amount` | integer | yes | Rules for `amount` are in the field catalog of the account guide. |
| `currency` | string | yes | Rules for `currency` are in the field catalog of the account guide. |
| `destination` | string | no | Rules for `destination` are in the field catalog of the account guide. |
| `schedule` | string | no | Rules for `schedule` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1021",
  "object": "payout",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/payouts \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "amount": "example_amount",
  "currency": "example_currency",
  "destination": "example_destination",
  "schedule": "example_schedule"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 22. GET `/v3/payouts/{id}`

Read one payout. A successful call returns status 200.

Example response:

```json
{
  "id": "pay_1022",
  "object": "payout",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payouts/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 23. GET `/v3/payouts`

List payouts with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1023",
  "object": "payout",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/payouts \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 24. PATCH `/v3/payouts/{id}`

Change a payout. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `destination` | string | no | Rules for `destination` are in the field catalog of the account guide. |
| `schedule` | string | no | Rules for `schedule` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "pay_1024",
  "object": "payout",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/payouts/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "destination": "example_destination",
  "schedule": "example_schedule"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 25. POST `/v3/disputes`

Create a dispute. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | Rules for `payment_id` are in the field catalog of the account guide. |
| `reason` | string | yes | Rules for `reason` are in the field catalog of the account guide. |
| `evidence` | object | no | Rules for `evidence` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "dis_1025",
  "object": "dispute",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/disputes \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "payment_id": "example_payment_id",
  "reason": "example_reason",
  "evidence": "example_evidence"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 26. GET `/v3/disputes/{id}`

Read one dispute. A successful call returns status 200.

Example response:

```json
{
  "id": "dis_1026",
  "object": "dispute",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/disputes/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 27. GET `/v3/disputes`

List disputes with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "dis_1027",
  "object": "dispute",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/disputes \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 28. PATCH `/v3/disputes/{id}`

Change a dispute. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `reason` | string | no | Rules for `reason` are in the field catalog of the account guide. |
| `evidence` | object | no | Rules for `evidence` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "dis_1028",
  "object": "dispute",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/disputes/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "reason": "example_reason",
  "evidence": "example_evidence"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 29. POST `/v3/webhooks`

Create a webhook endpoint. A successful call returns status 201.

| Field | Type | Required | Notes |
|---|---|---|---|
| `url` | string | yes | Rules for `url` are in the field catalog of the account guide. |
| `events` | array | yes | Rules for `events` are in the field catalog of the account guide. |
| `secret_hint` | string | no | Rules for `secret_hint` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "web_1029",
  "object": "webhook",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X POST https://api.example.org/v3/webhooks \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "url": "example_url",
  "events": "example_events",
  "secret_hint": "example_secret_hint"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 30. GET `/v3/webhooks/{id}`

Read one webhook endpoint. A successful call returns status 200.

Example response:

```json
{
  "id": "web_1030",
  "object": "webhook",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/webhooks/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 31. GET `/v3/webhooks`

List webhooks with filters and paging. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `limit` | integer | no | Rules for `limit` are in the field catalog of the account guide. |
| `cursor` | string | no | Rules for `cursor` are in the field catalog of the account guide. |
| `created_after` | string | no | Rules for `created_after` are in the field catalog of the account guide. |
| `created_before` | string | no | Rules for `created_before` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "web_1031",
  "object": "webhook",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X GET https://api.example.org/v3/webhooks \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "limit": "example_limit",
  "cursor": "example_cursor",
  "created_after": "example_created_after",
  "created_before": "example_created_before"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

### 32. PATCH `/v3/webhooks/{id}`

Change a webhook endpoint. A successful call returns status 200.

| Field | Type | Required | Notes |
|---|---|---|---|
| `events` | array | no | Rules for `events` are in the field catalog of the account guide. |
| `secret_hint` | string | no | Rules for `secret_hint` are in the field catalog of the account guide. |

Example response:

```json
{
  "id": "web_1032",
  "object": "webhook",
  "created": "2026-11-08T09:30:00Z",
  "livemode": false
}
```

Possible errors: `invalid_request`, `unauthorized`, `not_found`, `idempotency_conflict`.

Example request:

```sh
curl -X PATCH https://api.example.org/v3/webhooks/id_123 \
  -H "Authorization: Bearer sk_test_..." \
  -H "Idempotency-Key: 6f1c0d3a-1b2c-4d5e-8f90-a1b2c3d4e5f6" \
  -H "Content-Type: application/json"
```

Example body:

```json
{
  "events": "example_events",
  "secret_hint": "example_secret_hint"
}
```

Notes:

- The call is safe to retry with the same key for 24 hours.
- A client must not rely on the order of fields in the response.
- Unknown fields in the request are rejected with `invalid_request`.
- The rate limit for this call is 100 requests per second per key.
- Test mode and live mode use the same path with different keys.

## Webhook events

| Event | Sent when |
|---|---|
| `payment.created` | A payment is created. |
| `payment.updated` | A payment is updated. |
| `payment.failed` | A payment is failed. |
| `refund.created` | A refund is created. |
| `refund.updated` | A refund is updated. |
| `refund.failed` | A refund is failed. |
| `customer.created` | A customer is created. |
| `customer.updated` | A customer is updated. |
| `customer.failed` | A customer is failed. |
| `payment_method.created` | A payment method is created. |
| `payment_method.updated` | A payment method is updated. |
| `payment_method.failed` | A payment method is failed. |
| `invoice.created` | A invoice is created. |
| `invoice.updated` | A invoice is updated. |
| `invoice.failed` | A invoice is failed. |
| `payout.created` | A payout is created. |
| `payout.updated` | A payout is updated. |
| `payout.failed` | A payout is failed. |
| `dispute.created` | A dispute is created. |
| `dispute.updated` | A dispute is updated. |
| `dispute.failed` | A dispute is failed. |
| `webhook_endpoint.created` | A webhook endpoint is created. |
| `webhook_endpoint.updated` | A webhook endpoint is updated. |
| `webhook_endpoint.failed` | A webhook endpoint is failed. |

## Change log

- **3.0:** First release.
- **3.1:** Added disputes and payouts.
- **3.2:** Added webhook secrets and the `Retry-After` header.
