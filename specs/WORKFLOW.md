# Spec-Driven Development Workflow

## Overview

This project follows a spec-driven development (SDD) approach. The `specs/` folder is the single source of truth for what the product is, what it does, and why decisions were made.

**Core principle: The spec drives the code. Never the other way around.**

- All changes to the product begin with a change to the spec
- Code must always reflect what the spec describes
- If code is changed manually without updating the spec, the spec must be updated to reflect the new reality
- Git history is the audit trail — the spec always describes the **current state**

This file is self-contained. It can be copied into any project to apply the same approach.

---

## Folder Structure

```
specs/
  WORKFLOW.md             ← This file. The rules of engagement.
  PROJECT.md              ← High-level project description and personas
  INDEX.md                ← All features and foundation items with current status
  templates/
    feature/              ← Templates for user-facing features
    foundation/           ← Templates for platform/infrastructure work
  features/               ← One folder per user-facing feature
    <feature-name>/
      requirements.md     ← THE WHAT
      plan.md             ← THE HOW
      tasks.md            ← THE WORK
      test.md             ← THE VERIFICATION
      decisions.md        ← THE HISTORY
      todo.md             ← THE FUTURE
  foundation/             ← One folder per infrastructure or platform item
    <foundation-name>/
      requirements.md
      plan.md
      tasks.md
      test.md
      decisions.md
      todo.md
```

---

## Spec Dependencies (`requires`)

Every spec may declare a `requires` list in its frontmatter — an explicit list of other spec folder names that must reach `implemented` or `done` status before this spec can move to `in-progress`.

```yaml
---
status: draft
# requires:         ← omit entirely when there are no prerequisites
#   - auth-infrastructure
#   - design-system
---
```

**Rules:**
- List only **direct** prerequisites — do not include transitive dependencies
- A spec requires another when it directly uses types, APIs, infrastructure, or UI components delivered by that spec
- AI must verify all `requires` are `implemented` or `done` before moving a spec to `in-progress`
- When writing or reviewing a `tasks.md`, AI must check the `requires` list and confirm all prerequisite specs are complete
- `requires` is optional — omit it when a spec has no prerequisites

**Omitting transitive dependencies:**
If spec A requires spec B, and spec B already requires spec C, then spec A must **not** also list spec C — it is already implied. Only list the closest direct prerequisite. The exception is when a spec directly depends on the transitive spec *in ways not covered by the intermediate spec* — in that case it is a direct dependency and must be listed explicitly.

---

## Two Types of Specs

### Features
Describe what a **user** experiences. Always written from the user's perspective. Owned by the product owner.

### Foundation
Describe **infrastructure or platform work** that enables features but is not directly experienced by end users. Examples: a design system, a networking layer, a data catalog, a CI pipeline.

Foundation items use a different `requirements.md` template — instead of a User Story, they have a Technical Goal and a list of Dependents (which features rely on them).

Both types follow the same workflow and status lifecycle.

---

## Naming Conventions

### Feature folders
Named from the **user's perspective**, using short noun phrases describing what the user accomplishes.

Good examples:
- `user-registration` — user creates an account
- `browse-listings` — user searches for an item
- `send-message` — user contacts another user

Never name features after technical implementation details. Not `auth-endpoint` or `jwt-flow` — these are tasks inside a feature, not features themselves.

### Foundation folders
Use short, descriptive names scoped to what the item delivers. Prefix with a domain or layer name when it helps disambiguation.

Good examples:
- `design-system`
- `auth-infrastructure`
- `data-catalog`
- `api-versioning`

---

## File Purposes

### `requirements.md` — THE WHAT

**For features:** Describes what the user experiences, written from the perspective of a business analyst. Contains **no technical implementation details** — only the *what*, never the *how*. Interfaces and contracts may be specified at the boundary (e.g. endpoint shapes, message schemas) since they define behaviour, but how those interfaces are built belongs in `plan.md`. Written first, owned by the product owner. Non-technical stakeholders must be able to read and understand it.

Contains:
- Status and type (frontmatter)
- User story — 1–3 sentences, non-technical, PO-level
- Personas involved
- UI and visual design specifications (optional for non-UI features)
- Interfaces and contracts (REST endpoints, CLI commands, message schemas, etc.)
- Acceptance criteria — written in BDD format: **Given** / **When** / **Then**
- Constraints and edge cases
- Open questions

**For foundation:** Describes the technical goal, which features depend on it, and what will exist when it is done. Like the feature variant, it captures the *what* — implementation details belong in `plan.md`.

Contains:
- Status and type (frontmatter)
- Technical goal — what engineering problem this solves
- Dependents — which features or foundation items rely on this
- Deliverables — concrete artifacts that will exist when done
- Scope and constraints
- Acceptance criteria — written in BDD format: **Given** / **When** / **Then**
- Open questions

### `plan.md` — THE HOW

Describes how the feature will be built, written from the perspective of a developer. Translates the *what* from `requirements.md` into the *how* — architecture, data flow, module boundaries, and concrete file changes. Written by AI alongside or after `requirements.md` — both may be drafted in a single step and reviewed together.

Contains:
- Technical approach
- Components and modules affected
- New files — every file created by this spec, listed with its full path and a one-line purpose
- Cross-feature dependencies and how they are resolved
- Risks and open technical questions

### `tasks.md` — THE WORK

Breaks the plan into actionable, bite-sized checklists. Written by AI after `plan.md` is approved.

Contains:
- Checklist items in strict prerequisite-first order
- Each item is small enough to implement and verify independently
- AI checks off items as implementation progresses
- Independent tasks with no ordering constraints between them can be dispatched to parallel subagents simultaneously

**Dependency ordering — mandatory:**
Tasks must be listed in strict prerequisite-first order. A task may only appear after all tasks it depends on. Infrastructure tasks that are prerequisites — such as dependency updates, DI container registrations, or schema migrations — must be listed explicitly and placed before any task that requires them. If a prerequisite task is missing, add it before writing any task that depends on it.

### `test.md` — THE VERIFICATION

Defines how the feature is verified. Written by AI after `requirements.md` is approved — derived from the acceptance criteria, not the implementation plan. For foundation items, written alongside `tasks.md`.

Contains:
- Acceptance criteria coverage table — maps every BDD criterion from `requirements.md` to one or more test cases
- `[auto]` items — verified by running the automated test suite
- `[manual]` items — verified by a human on a real device or build

AI checks off `[auto]` items when the test suite passes. A human checks off `[manual]` items.

**`[auto]` vs `[manual]` — the rule:** Mark a test `[manual]` only when it genuinely requires a human in a real environment (e.g. gesture input, visual inspection, clipboard paste, physical hardware). Anything that can be executed via CLI, scripts, or automated tooling must be `[auto]`, even if it involves starting a server and hitting endpoints.

**Every `[manual]` item must include enough detail for someone to perform the check without guessing:**
- The exact steps to follow or commands to run
- The expected outcome — what success looks like
- Any required setup or teardown (seed data, environment variables, cleanup)

### `decisions.md` — THE HISTORY

Records why technical choices were made. Updated throughout the lifecycle. Never delete entries — add new ones.

Contains:
- Decision title and date
- What was decided
- Alternatives considered and why they were rejected
- The reason for the choice

When a later decision supersedes an earlier one, add a `**Superseded by:** <title>` line to the old entry and a `**Supersedes:** <title>` line to the new one. Never edit or remove the original content.

This prevents future AI sessions from re-debating settled decisions.

### `todo.md` — THE FUTURE

Tracks what is still open. Updated throughout the lifecycle.

Contains:
- **Bugs** — what happens vs. what should happen
- **Deferred** — improvements or functionality intentionally pushed to a later iteration; note any dependency that is blocking them
- **Open Questions** — things that need answering before or during implementation

---

## Status Lifecycle

Every feature has a `status` field in the frontmatter of its `requirements.md`. AI always keeps this up to date.

```
draft → planned → in-progress → implemented → done
                      ↑
                   blocked
```

| Status        | Meaning                                                                              |
|:--------------|:-------------------------------------------------------------------------------------|
| `draft`       | `requirements.md` and `plan.md` are being drafted or reviewed — phase 1 not yet complete    |
| `planned`     | `plan.md` and `tasks.md` are complete and approved                                   |
| `in-progress` | Implementation is underway                                                           |
| `blocked`     | Cannot proceed — a `requires` dependency is not yet `implemented` or `done`          |
| `implemented` | All tasks in `tasks.md` are checked off                                              |
| `done`        | All items in `test.md` are checked off (auto + manual)                               |

`blocked` can interrupt any active status. When the blocking dependency is resolved, status reverts to what it was before being blocked.

Status is also mirrored in `INDEX.md` for a project-wide overview. **AI must keep both in sync.**

---

## The Workflow

### Phase 1: Spec (→ draft → planned)

**For features:**
1. Product owner writes a short user story — 1–3 sentences, non-technical
2. AI writes `requirements.md` and `plan.md` — these may be drafted together in a single step or sequentially; either way, both are reviewed before proceeding
3. Product owner reviews and approves both (or requests changes)
4. AI writes `test.md` based on the acceptance criteria
5. AI writes `tasks.md`
6. Product owner reviews and approves
7. AI updates status to `planned`

**For foundation:**
1. Engineer or product owner states the technical goal in 1–3 sentences
2. AI writes `requirements.md` and `plan.md` — these may be drafted together in a single step or sequentially; either way, both are reviewed before proceeding
3. Product owner or tech lead reviews and approves both
4. AI writes `tasks.md` and `test.md`
5. Product owner reviews and approves
6. AI updates status to `planned`

### Phase 2: Implementation (→ in-progress → implemented)

1. AI updates status to `in-progress`
2. AI implements tasks, checking them off in `tasks.md` as completed. When tasks are independent — no shared outputs, no ordering constraints — AI may dispatch them to parallel subagents simultaneously.
3. AI updates `decisions.md` whenever a non-obvious technical choice is made
4. AI updates `todo.md` when discovering issues or deferring work
5. **After every implementation task, AI runs the full test suite automatically — without being asked.** If tests fail, the task stays in-progress until they pass.
6. When all tasks in `tasks.md` are checked off, AI updates status to `implemented`

### Phase 3: Testing (→ implemented → done)

1. AI runs automated tests and checks off all `[auto]` items in `test.md`
2. Human QA verifies all `[manual]` items in a real environment
3. If a bug is found:
   - Bug is added to `todo.md`
   - The relevant test item is unchecked in `test.md`
   - Status reverts to `in-progress`
4. When all items in `test.md` are checked off, AI updates status to `done`

### Handling Spec Changes

When the spec changes after implementation has started:

1. Update `requirements.md` first — always
2. Re-evaluate `plan.md` — update if the change affects the technical approach
3. Re-evaluate `tasks.md` — add, remove, or update tasks accordingly
4. Re-evaluate `test.md` — add, remove, or update test cases accordingly
5. Status reverts to the appropriate earlier phase
6. Document the reason for the change in `decisions.md`

### Handling Manual Code Changes

If code is changed without going through the spec process:

1. Update `requirements.md` to reflect the new reality — immediately
2. Update `plan.md` and `tasks.md` to match
3. The spec must always describe the current state of the product

---

## AI Instructions

When working in this project, AI must:

1. **Read `specs/WORKFLOW.md` and `specs/INDEX.md`** at the start of any spec-related task
2. **Read `specs/PROJECT.md`** to understand the project context and personas before writing any spec or plan
3. **Never implement** without an approved spec and plan
4. **Keep status current** — update `requirements.md` frontmatter and `INDEX.md` whenever status changes
5. **Check off tasks** in `tasks.md` as implementation progresses
6. **Parallelize when beneficial** — when independent tasks with no ordering constraints are ready at the same time, dispatch them to parallel subagents. Use judgment; not all tasks in the same phase are independent.
7. **Verify dependency order before finalising `tasks.md`** — walk the full task list and confirm every task's prerequisites appear above it. Explicitly check for: infrastructure tasks (dependency updates, DI registrations, migrations), and tasks whose output is the input of a later task. Add any missing prerequisite tasks before proceeding.
8. **List all new files in `plan.md` before creating them** — before finalising `plan.md`, enumerate every file that will be created under the `## New Files` section with its full path and purpose. If a task requires creating a file not yet listed there, update `plan.md` first. This ensures every file is permanently traceable to the spec that owns it.
9. **Check `requires` before starting implementation** — read the `requires` frontmatter of the spec being implemented. Verify every listed spec is at status `implemented` or `done` in `INDEX.md`. If any prerequisite is incomplete, set status to `blocked`, note the blocking spec in `INDEX.md` `## Next Up`, and flag it to the user. When the dependency resolves, revert to the previous status.
10. **Record decisions** in `decisions.md` when making non-obvious choices
11. **Never delete** spec files — they are permanent records (git tracks history)
12. **Ask for approval** at each phase gate before proceeding to the next phase
13. **Reverse-propagate** any manual code changes back into the spec files immediately
14. **Keep `## Next Up` current in `INDEX.md`** — after every status change or completed task, update the `## Next Up` section. List items in execution order: what is actively in progress, what is next in line, what is blocked and why. Maximum 5 entries. Remove an item once it reaches `done`. Foundation blockers must appear above the features they unblock.

---

## Approval Gates

Approval can happen in two ways:

- **Human approves explicitly** — by confirming in the conversation ("looks good, proceed") or by checking/editing the file
- **AI proceeds autonomously** — if the user has explicitly asked AI to work end-to-end without interruption

When in doubt, ask before proceeding to the next phase.
