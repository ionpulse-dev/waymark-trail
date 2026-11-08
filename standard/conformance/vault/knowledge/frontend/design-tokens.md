---
title: Design tokens define colors, spacing, and type sizes for all screens
description: Lists the design tokens for color, spacing, and type, and the rule that code uses tokens and never raw values. Read it before you style a component.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Jane Doe <jane.doe@corp.example.org>"
updated_by: "Jane Doe <jane.doe@corp.example.org>"
tags:
  - frontend
  - design
related:
  - "[[frontend/accessibility-checklist]]"
---

# Design tokens

Code uses tokens. It never uses raw color values or pixel sizes.

## Color

| Token | Light | Dark | Use |
|---|---|---|---|
| `color-bg` | `#ffffff` | `#111418` | Page background |
| `color-text` | `#1b1f24` | `#e8eaed` | Body text |
| `color-accent` | `#0b57d0` | `#8ab4f8` | Links and buttons |
| `color-danger` | `#b3261e` | `#f2b8b5` | Errors |

All pairs reach a contrast ratio of 4.5 or more (see the
[accessibility checklist](accessibility-checklist.md)).

## Spacing

Spacing uses a scale of 4, 8, 12, 16, 24, 32, and 48 pixels: `space-1` to `space-7`.

## Type

Body text is 16 pixels with a line height of 1.5. Headings use steps of 1.25.
