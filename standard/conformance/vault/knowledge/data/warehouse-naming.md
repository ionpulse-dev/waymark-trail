---
title: Warehouse tables follow one naming scheme with layer prefixes
description: Defines the names of warehouse tables and columns, with the layers raw, clean, and mart. Read it before you create a table.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Alex Kim <alex.kim@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
tags:
  - data
  - naming
related:
  - "[[data/event-schema-catalog]]"
---

# Warehouse naming

| Layer | Prefix | Example |
|---|---|---|
| Raw | `raw_` | `raw_events` |
| Clean | `clean_` | `clean_orders` |
| Mart | `mart_` | `mart_daily_revenue` |

Columns use `snake_case`. Times end with `_at`. Flags start with `is_`.
The events behind these tables are in the [event catalog](event-schema-catalog.md).
