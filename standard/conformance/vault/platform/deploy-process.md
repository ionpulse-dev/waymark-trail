---
title: How the platform team ships a release to production, step by step
description: The ten phases of a production release with roles, checklists, exit criteria, a normal timeline, hotfix rules, and commands. Read it before you lead or join a release.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Sam Roe <sam.roe@corp.example.org>"
updated_by: "Alex Kim <alex.kim@corp.example.org>"
tags:
  - platform
  - release
  - runbook
---

# Deploy process

This document describes how the platform team ships a release to production. It applies to all services. A service may add steps, but it may not skip one.

## Roles

| Role | Task |
|---|---|
| Release manager | Leads the release and decides on a rollback. |
| Deputy | Takes over if the release manager is not available. |
| On-call engineer | Watches alerts during the rollout. |
| Support contact | Reports customer problems. |

## Phase 1: Prepare the release

- [ ] Check that the main branch is green.
- [ ] Read the list of merged changes.
- [ ] Name the release manager and a deputy.
- [ ] Open the release ticket.

**Detailed notes.**

Note 1 for phase 1: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 1: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 1: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 1 done" in the ticket.

**Common problems.**

1. A problem in phase 1 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 1 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 1 that costs time when nobody expects it, and the first thing to check.

## Phase 2: Freeze

- [ ] Announce the freeze in the channel.
- [ ] Stop merges that are not fixes.
- [ ] Tag the release candidate.

**Detailed notes.**

Note 1 for phase 2: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 2: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 2: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 2 done" in the ticket.

**Common problems.**

1. A problem in phase 2 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 2 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 2 that costs time when nobody expects it, and the first thing to check.

## Phase 3: Test in staging

- [ ] Deploy the candidate to staging.
- [ ] Run the smoke tests.
- [ ] Run the load test for 20 minutes.
- [ ] Check the dashboards for new errors.

**Detailed notes.**

Note 1 for phase 3: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 3: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 3: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 3 done" in the ticket.

**Common problems.**

1. A problem in phase 3 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 3 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 3 that costs time when nobody expects it, and the first thing to check.

## Phase 4: Database changes

- [ ] List all migrations.
- [ ] Check that each one is backward compatible.
- [ ] Run them on a copy of production data.
- [ ] Write the rollback step for each one.

**Detailed notes.**

Note 1 for phase 4: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 4: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 4: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 4 done" in the ticket.

**Common problems.**

1. A problem in phase 4 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 4 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 4 that costs time when nobody expects it, and the first thing to check.

## Phase 5: Feature flags

- [ ] List new flags and their defaults.
- [ ] Check that every flag has an owner.
- [ ] Check that new flags start off.

**Detailed notes.**

Note 1 for phase 5: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 5: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 5: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 5 done" in the ticket.

**Common problems.**

1. A problem in phase 5 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 5 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 5 that costs time when nobody expects it, and the first thing to check.

## Phase 6: Canary

- [ ] Send 1 percent of traffic to the new version.
- [ ] Watch the error rate and latency for 15 minutes.
- [ ] Increase to 10 percent, then 50 percent.

**Detailed notes.**

Note 1 for phase 6: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 6: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 6: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 6 done" in the ticket.

**Common problems.**

1. A problem in phase 6 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 6 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 6 that costs time when nobody expects it, and the first thing to check.

## Phase 7: Full rollout

- [ ] Send all traffic to the new version.
- [ ] Keep the old version warm for one hour.
- [ ] Post the status in the channel.

**Detailed notes.**

Note 1 for phase 7: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 7: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 7: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 7 done" in the ticket.

**Common problems.**

1. A problem in phase 7 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 7 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 7 that costs time when nobody expects it, and the first thing to check.

## Phase 8: Verify

- [ ] Run the production smoke tests.
- [ ] Check the business metrics against the last week.
- [ ] Ask support for new complaints.

**Detailed notes.**

Note 1 for phase 8: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 8: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 8: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 8 done" in the ticket.

**Common problems.**

1. A problem in phase 8 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 8 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 8 that costs time when nobody expects it, and the first thing to check.

## Phase 9: Rollback

- [ ] Decide within 10 minutes if the error rate stays high.
- [ ] Switch the traffic back.
- [ ] Run the rollback of the migrations only if the release manager agrees.
- [ ] Write a short report.

**Detailed notes.**

Note 1 for phase 9: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 9: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 9: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 9 done" in the ticket.

**Common problems.**

1. A problem in phase 9 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 9 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 9 that costs time when nobody expects it, and the first thing to check.

## Phase 10: Close

- [ ] Remove old flags after two weeks.
- [ ] Close the release ticket.
- [ ] Update the change log.

**Detailed notes.**

Note 1 for phase 10: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 2 for phase 10: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

Note 3 for phase 10: the team learned this rule from earlier releases. Write down what you see, not what you expect. If a number looks wrong, ask before you go on, because a small doubt in this phase becomes a long night in the next one. Keep the notes short, and add them to the release ticket so that the next release manager can read them.

**Exit criteria.**

The phase is done when all boxes are checked and the release manager writes "phase 10 done" in the ticket.

**Common problems.**

1. A problem in phase 10 that costs time when nobody expects it, and the first thing to check.
2. A problem in phase 10 that costs time when nobody expects it, and the first thing to check.
3. A problem in phase 10 that costs time when nobody expects it, and the first thing to check.

## Timeline of a normal release

| Time | Step |
|---|---|
| 09:00 | Prepare the release |
| 09:30 | Freeze |
| 10:00 | Test in staging |
| 10:30 | Database changes |
| 11:00 | Feature flags |
| 11:30 | Canary |
| 12:00 | Full rollout |
| 13:00 | Verify |
| 14:00 | Rollback |
| 15:00 | Close |

## Rules for hotfixes

- A hotfix has one reviewer and one change.
- It skips the freeze, but not the canary.
- It needs a ticket with the cause.
- It is followed by a normal release within two days.

## Appendix: commands

```sh
./deploy canary --percent 1
./deploy canary --percent 10
./deploy promote
./deploy rollback --to previous
```
