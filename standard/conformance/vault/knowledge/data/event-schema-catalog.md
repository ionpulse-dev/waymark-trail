---
title: Event schema catalog: names, owners, fields, and quality rules
description: The list of all events in the data platform with their fields, owners, versions, and quality rules. Read it before you add a producer or build a report on events.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Alex Kim <alex.kim@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
tags:
  - data
  - events
  - schema
related:
  - "[[data/warehouse-naming]]"
---

# Event schema catalog

Every event in the data platform has a name, an owner, a version, and a list of fields. The name has the form `<domain>.<action>`. A producer must not change the meaning of a field in a version. It adds a new version instead.

## Common fields

| Field | Type | Notes |
|---|---|---|
| `event_id` | string | Unique, a UUID. |
| `event_name` | string | The name from this catalog. |
| `event_version` | integer | Starts at 1. |
| `occurred_at` | string | UTC time of the event. |
| `actor_id` | string | The person or the system that caused it. |
| `trace_id` | string | Links events of one request. |

## Domain: account

### `account.created`

Sent when account created happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `created_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.created",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0001",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.updated`

Sent when account updated happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `updated_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.updated",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0002",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.closed`

Sent when account closed happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `closed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.closed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0003",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.locked`

Sent when account locked happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `locked_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.locked",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0004",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.unlocked`

Sent when account unlocked happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `unlocked_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.unlocked",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0005",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.email_changed`

Sent when account email changed happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `email_changed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.email_changed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0006",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.plan_changed`

Sent when account plan changed happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `plan_changed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.plan_changed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0007",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `account.limit_changed`

Sent when account limit changed happens. Owner: the account team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `account_id` | string | yes | The ID of the account. |
| `limit_changed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `account_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "account.limit_changed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "account_id": "acc_0008",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: order

### `order.created`

Sent when order created happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `created_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.created",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0009",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.paid`

Sent when order paid happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `paid_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.paid",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0010",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.shipped`

Sent when order shipped happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `shipped_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.shipped",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0011",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.delivered`

Sent when order delivered happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `delivered_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.delivered",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0012",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.cancelled`

Sent when order cancelled happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `cancelled_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.cancelled",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0013",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.returned`

Sent when order returned happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `returned_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.returned",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0014",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.split`

Sent when order split happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `split_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.split",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0015",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `order.merged`

Sent when order merged happens. Owner: the order team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `order_id` | string | yes | The ID of the order. |
| `merged_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `order_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "order.merged",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "order_id": "ord_0016",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: session

### `session.started`

Sent when session started happens. Owner: the session team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `session_id` | string | yes | The ID of the session. |
| `started_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `session_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "session.started",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "session_id": "ses_0017",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `session.refreshed`

Sent when session refreshed happens. Owner: the session team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `session_id` | string | yes | The ID of the session. |
| `refreshed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `session_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "session.refreshed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "session_id": "ses_0018",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `session.expired`

Sent when session expired happens. Owner: the session team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `session_id` | string | yes | The ID of the session. |
| `expired_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `session_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "session.expired",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "session_id": "ses_0019",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `session.revoked`

Sent when session revoked happens. Owner: the session team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `session_id` | string | yes | The ID of the session. |
| `revoked_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `session_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "session.revoked",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "session_id": "ses_0020",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `session.elevated`

Sent when session elevated happens. Owner: the session team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `session_id` | string | yes | The ID of the session. |
| `elevated_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `session_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "session.elevated",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "session_id": "ses_0021",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: payment

### `payment.authorized`

Sent when payment authorized happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `authorized_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.authorized",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0022",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `payment.captured`

Sent when payment captured happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `captured_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.captured",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0023",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `payment.failed`

Sent when payment failed happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `failed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.failed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0024",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `payment.refunded`

Sent when payment refunded happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `refunded_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.refunded",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0025",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `payment.disputed`

Sent when payment disputed happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `disputed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.disputed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0026",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `payment.settled`

Sent when payment settled happens. Owner: the payment team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `payment_id` | string | yes | The ID of the payment. |
| `settled_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `payment_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "payment.settled",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "payment_id": "pay_0027",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: notification

### `notification.queued`

Sent when notification queued happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `queued_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.queued",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0028",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `notification.sent`

Sent when notification sent happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `sent_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.sent",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0029",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `notification.bounced`

Sent when notification bounced happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `bounced_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.bounced",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0030",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `notification.opened`

Sent when notification opened happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `opened_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.opened",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0031",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `notification.clicked`

Sent when notification clicked happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `clicked_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.clicked",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0032",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `notification.unsubscribed`

Sent when notification unsubscribed happens. Owner: the notification team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `notification_id` | string | yes | The ID of the notification. |
| `unsubscribed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `notification_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "notification.unsubscribed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "notification_id": "not_0033",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: search

### `search.query`

Sent when search query happens. Owner: the search team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `search_id` | string | yes | The ID of the search. |
| `query_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `search_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "search.query",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "search_id": "sea_0034",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `search.click`

Sent when search click happens. Owner: the search team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `search_id` | string | yes | The ID of the search. |
| `click_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `search_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "search.click",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "search_id": "sea_0035",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `search.no_result`

Sent when search no result happens. Owner: the search team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `search_id` | string | yes | The ID of the search. |
| `no_result_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `search_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "search.no_result",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "search_id": "sea_0036",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `search.filter_used`

Sent when search filter used happens. Owner: the search team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `search_id` | string | yes | The ID of the search. |
| `filter_used_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `search_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "search.filter_used",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "search_id": "sea_0037",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: inventory

### `inventory.reserved`

Sent when inventory reserved happens. Owner: the inventory team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `inventory_id` | string | yes | The ID of the inventory. |
| `reserved_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `inventory_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "inventory.reserved",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "inventory_id": "inv_0038",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `inventory.released`

Sent when inventory released happens. Owner: the inventory team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `inventory_id` | string | yes | The ID of the inventory. |
| `released_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `inventory_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "inventory.released",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "inventory_id": "inv_0039",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `inventory.adjusted`

Sent when inventory adjusted happens. Owner: the inventory team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `inventory_id` | string | yes | The ID of the inventory. |
| `adjusted_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `inventory_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "inventory.adjusted",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "inventory_id": "inv_0040",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `inventory.counted`

Sent when inventory counted happens. Owner: the inventory team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `inventory_id` | string | yes | The ID of the inventory. |
| `counted_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `inventory_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "inventory.counted",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "inventory_id": "inv_0041",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Domain: support

### `support.ticket_opened`

Sent when support ticket opened happens. Owner: the support team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `support_id` | string | yes | The ID of the support. |
| `ticket_opened_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `support_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "support.ticket_opened",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "support_id": "sup_0042",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `support.ticket_closed`

Sent when support ticket closed happens. Owner: the support team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `support_id` | string | yes | The ID of the support. |
| `ticket_closed_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `support_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "support.ticket_closed",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "support_id": "sup_0043",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `support.ticket_escalated`

Sent when support ticket escalated happens. Owner: the support team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `support_id` | string | yes | The ID of the support. |
| `ticket_escalated_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `support_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "support.ticket_escalated",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "support_id": "sup_0044",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

### `support.reply_sent`

Sent when support reply sent happens. Owner: the support team. Version 1.

| Field | Type | Required | Notes |
|---|---|---|---|
| `support_id` | string | yes | The ID of the support. |
| `reply_sent_at` | string | yes | UTC time. |
| `source` | string | no | `web`, `app`, `api`, or `job`. |
| `reason` | string | no | A short text, at most 200 characters. |
| `amount` | integer | no | In the smallest unit, only for money events. |

**Quality rules.**

- The event must arrive in the warehouse within 15 minutes.
- `support_id` must never be empty.
- Late events keep their `occurred_at`.

**Used by.** Dashboards, the finance export, and the anomaly job.

**Example.**

```json
{
  "event_id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "event_name": "support.reply_sent",
  "event_version": 1,
  "occurred_at": "2026-11-08T09:30:00Z",
  "support_id": "sup_0045",
  "source": "api"
}
```

**History.**

| Version | Date | Change |
|---|---|---|
| 1 | 2026-01-15 | First version. |
| 1 | 2026-04-02 | Added the optional field `reason`. |
| 1 | 2026-07-19 | Added the optional field `amount`. |

## Retired events

| Event | Retired on | Replaced by |
|---|---|---|
| `legacy.event_1` | 2026-02-01 | `order.created` |
| `legacy.event_2` | 2026-03-01 | `session.started` |
| `legacy.event_3` | 2026-04-01 | `payment.authorized` |
| `legacy.event_4` | 2026-05-01 | `notification.queued` |
| `legacy.event_5` | 2026-06-01 | `search.query` |
| `legacy.event_6` | 2026-07-01 | `inventory.reserved` |
| `legacy.event_7` | 2026-08-01 | `support.ticket_opened` |
| `legacy.event_8` | 2026-09-01 | `account.created` |
| `legacy.event_9` | 2026-01-01 | `order.created` |
| `legacy.event_10` | 2026-02-01 | `session.started` |
| `legacy.event_11` | 2026-03-01 | `payment.authorized` |
| `legacy.event_12` | 2026-04-01 | `notification.queued` |
| `legacy.event_13` | 2026-05-01 | `search.query` |
| `legacy.event_14` | 2026-06-01 | `inventory.reserved` |

See the [warehouse naming rules](warehouse-naming.md) for the tables that hold these events.
