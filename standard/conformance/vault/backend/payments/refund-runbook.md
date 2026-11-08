---
title: How to refund a payment: twelve common cases and their steps
description: A runbook for support and payment teams with a checklist and twelve refund cases, each with steps, checks, and typical errors. Read it before you create a refund.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Sam Roe <sam.roe@corp.example.org>"
updated_by: "Sam Roe <sam.roe@corp.example.org>"
tags:
  - payments
  - runbook
  - support
sources:
  - TICKET-1107
related:
  - "[[backend/payments/payment-api-v3-contract]]"
---

# Refund runbook

This runbook is for the support and payment teams. It lists the common cases of a refund and the steps for each one. A refund is a write, so it needs an idempotency key (see [idempotency keys](idempotency-keys.md)). The endpoints are in the [API contract](payment-api-v3-contract.md).

## Before you start

1. Open the ticket and read the whole history.
2. Find the payment and check its status.
3. Check that you are in the right mode, test or live.
4. Write down the payment ID in the ticket.

## Checklist for every refund

- [ ] Check 1: the payment, the amount, and the reason match the ticket.
- [ ] Check 2: the payment, the amount, and the reason match the ticket.
- [ ] Check 3: the payment, the amount, and the reason match the ticket.
- [ ] Check 4: the payment, the amount, and the reason match the ticket.
- [ ] Check 5: the payment, the amount, and the reason match the ticket.
- [ ] Check 6: the payment, the amount, and the reason match the ticket.
- [ ] Check 7: the payment, the amount, and the reason match the ticket.
- [ ] Check 8: the payment, the amount, and the reason match the ticket.
- [ ] Check 9: the payment, the amount, and the reason match the ticket.
- [ ] Check 10: the payment, the amount, and the reason match the ticket.
- [ ] Check 11: the payment, the amount, and the reason match the ticket.
- [ ] Check 12: the payment, the amount, and the reason match the ticket.

## Case 1: Full refund of a card payment

**Situation.** The customer asks for all money back within 30 days.

**Steps.**

1. Find the payment by its ID.
2. Check that the payment is `succeeded` and not disputed.
3. Create a refund for the full amount.
4. Wait for the webhook `refund.updated`.
5. Tell the customer that the money arrives in 5 to 10 days.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1001.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 2: Partial refund

**Situation.** Only a part of the amount goes back.

**Steps.**

1. Read the remaining refundable amount.
2. Create a refund with a smaller `amount`.
3. Check that the sum of all refunds stays below the payment.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1002.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 3: Refund after a chargeback

**Situation.** A dispute is open for the same payment.

**Steps.**

1. Do not refund while the dispute is open.
2. Answer the dispute with evidence.
3. Wait for the result and refund only the remainder.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1003.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 4: Refund to an expired card

**Situation.** The original card is no longer valid.

**Steps.**

1. Create the refund as usual.
2. If it fails, the issuer sends the money to the account of the customer.
3. If the status stays `pending` for 10 days, open a ticket with the card network.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1004.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 5: Refund in another currency

**Situation.** The customer paid in a currency that differs from the price.

**Steps.**

1. Refund in the currency of the payment.
2. Do not convert the amount yourself.
3. Explain that the rate of the day of the payment applies.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1005.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 6: Double payment

**Situation.** The customer paid twice by mistake.

**Steps.**

1. Find both payments by customer and amount.
2. Refund the second payment in full.
3. Add a note with the reason `duplicate`.
4. Check the idempotency key of the second call for a client bug.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1006.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 7: Refund of a subscription month

**Situation.** The customer cancels in the middle of a month.

**Steps.**

1. Read the invoice of the month.
2. Compute the unused part by days.
3. Refund the unused part and mark the invoice.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1007.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 8: Refund with a failed webhook

**Situation.** Our system did not get the webhook.

**Steps.**

1. Read the refund with the API.
2. If it is `succeeded`, update the order by hand.
3. Check the dead letter queue of the webhook consumer.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1008.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 9: Refund for a closed account

**Situation.** The customer account was closed.

**Steps.**

1. Ask the support lead for approval.
2. Refund to the original method only.
3. Never refund to a new method.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1009.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 10: Refund above the daily limit

**Situation.** The amount is higher than the limit of the operator.

**Steps.**

1. Ask a second person to approve.
2. Write the approval into the ticket.
3. Create the refund with the second approver as `approved_by` in the metadata.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1010.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 11: Refund of a payout

**Situation.** Money already left to the bank of a seller.

**Steps.**

1. Do not refund from the platform balance.
2. Create a reverse transfer first.
3. Wait until the seller balance covers the refund.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1011.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Case 12: Refund of a test payment

**Situation.** A tester asks for a refund in live mode.

**Steps.**

1. Check the mode of the key.
2. Test payments need no refund. Close the ticket.
3. Tell the team to use test keys.

**Check afterwards.**

- The refund has the status `succeeded` or `pending`.
- The order system shows the new balance.
- The ticket has the refund ID and the reason.

**Example conversation.**

> Customer: I need my money back for order 1012.
> Agent: I found the payment. I can see the status and the amount.
> Customer: How long does it take?
> Agent: The refund is created now. The money arrives in 5 to 10 days.

**Things that go wrong.**

| Symptom | Likely cause | What to do |
|---|---|---|
| Error `unprocessable` | The payment is not refundable. | Read the status and the dispute state. |
| Error `idempotency_conflict` | The key was used before with another body. | Use a new key for a new refund. |
| Refund stays `pending` | The issuer is slow. | Wait 5 days, then open a ticket. |

## Questions and answers

### Question 1

A support agent asks what to do in situation 1: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 2

A support agent asks what to do in situation 2: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 3

A support agent asks what to do in situation 3: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 4

A support agent asks what to do in situation 4: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 5

A support agent asks what to do in situation 5: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 6

A support agent asks what to do in situation 6: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 7

A support agent asks what to do in situation 7: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 8

A support agent asks what to do in situation 8: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 9

A support agent asks what to do in situation 9: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 10

A support agent asks what to do in situation 10: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 11

A support agent asks what to do in situation 11: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 12

A support agent asks what to do in situation 12: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 13

A support agent asks what to do in situation 13: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 14

A support agent asks what to do in situation 14: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 15

A support agent asks what to do in situation 15: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 16

A support agent asks what to do in situation 16: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 17

A support agent asks what to do in situation 17: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 18

A support agent asks what to do in situation 18: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 19

A support agent asks what to do in situation 19: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 20

A support agent asks what to do in situation 20: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 21

A support agent asks what to do in situation 21: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 22

A support agent asks what to do in situation 22: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 23

A support agent asks what to do in situation 23: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 24

A support agent asks what to do in situation 24: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 25

A support agent asks what to do in situation 25: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 26

A support agent asks what to do in situation 26: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 27

A support agent asks what to do in situation 27: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 28

A support agent asks what to do in situation 28: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 29

A support agent asks what to do in situation 29: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 30

A support agent asks what to do in situation 30: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 31

A support agent asks what to do in situation 31: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 32

A support agent asks what to do in situation 32: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 33

A support agent asks what to do in situation 33: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 34

A support agent asks what to do in situation 34: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 35

A support agent asks what to do in situation 35: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 36

A support agent asks what to do in situation 36: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 37

A support agent asks what to do in situation 37: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 38

A support agent asks what to do in situation 38: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 39

A support agent asks what to do in situation 39: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

### Question 40

A support agent asks what to do in situation 40: the payment is old, the customer is waiting, and the status is unclear.

**Answer.** Read the payment first. Check the status, the dispute state, and the sum of all refunds. If one of them is unclear, ask a second person before you create the refund. Write what you did into the ticket.

## Contacts

Ask the payment team in the channel `#payments-support`. For a dispute, ask the risk team. For a limit above the daily cap, ask the support lead.
