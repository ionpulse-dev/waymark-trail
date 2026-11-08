---
title: Decision: use a double-entry ledger for all balances in the platform
description: Records why the platform replaced the single balance column with an append-only double-entry ledger, the options we weighed, the rules, the rollout plan, and the risks.
status: active
created: 2026-11-08
updated: 2026-11-08
created_by: "Alex Kim <alex.kim@corp.example.org>"
updated_by: "Sam Roe <sam.roe@corp.example.org>"
tags:
  - payments
  - ledger
  - adr
sources:
  - TICKET-0987
related:
  - "[[backend/payments/refund-runbook]]"
anchors:
  - "git:payments-service/src/ledger@a1b2c3d"
trust: unverified
---

# Decision: a double-entry ledger for all balances

## Status

Accepted on 2026-11-08. It replaces the single `balance` column of the account table.

## Context

Today every account has one `balance` number. Payments, refunds, and payouts change it with an update statement. This has caused three problems in the last year: a lost update during a refund, a balance that could not be explained after a payout, and an audit that needed two weeks of manual work. We need a record that explains every change.

## Options

### Option 1: Keep the column and add an audit table

**Advantages.**

- Small change.
- The audit table can drift from the column.
- Two writes must succeed together.

**Disadvantages.**

- The explanation stays secondary.
- A bug in one write still loses an update.

### Option 2: Event sourcing for the whole platform

**Advantages.**

- Every change is an event.
- Perfect history.

**Disadvantages.**

- A very large change.
- All teams must learn it.
- Reads need projections.

### Option 3: A double-entry ledger for money only

**Advantages.**

- Every change is two entries that sum to zero.
- The balance is the sum of entries.
- Audits read the ledger.

**Disadvantages.**

- A new table and new rules.
- Balances need a cache for speed.

### Option 4: Buy a ledger service

**Advantages.**

- Fast to start.

**Disadvantages.**

- A new vendor risk.
- Data leaves our systems.
- Cost grows with volume.

## Decision

We choose option 3. Every movement of money is a transaction with at least two entries. The entries of a transaction sum to zero. An entry is never changed or deleted. A correction is a new transaction.

## Rules of the ledger

1. An entry has an account, an amount, a currency, a transaction ID, and a time.
2. A transaction is written in one database transaction.
3. The sum of the entries of a transaction is zero for each currency.
4. An account balance is the sum of its entries. A cached balance is only a copy.
5. A refund is a new transaction that reverses a part of an older one and links to it.
6. No code outside the ledger module writes to the entry table.
7. A job compares cached balances with the sums every hour and alerts on a difference.

## Sample transactions

| Transaction | Account | Debit | Credit |
|---|---|---|---|
| tx_0001 | customer_1 | 1000 | |
| tx_0001 | platform_cash | | 1000 |
| tx_0002 | customer_2 | 2000 | |
| tx_0002 | platform_cash | | 2000 |
| tx_0003 | customer_3 | 3000 | |
| tx_0003 | platform_cash | | 3000 |
| tx_0004 | customer_4 | 4000 | |
| tx_0004 | platform_cash | | 4000 |
| tx_0005 | customer_5 | 5000 | |
| tx_0005 | platform_cash | | 5000 |
| tx_0006 | customer_6 | 6000 | |
| tx_0006 | platform_cash | | 6000 |
| tx_0007 | customer_7 | 7000 | |
| tx_0007 | platform_cash | | 7000 |
| tx_0008 | customer_8 | 8000 | |
| tx_0008 | platform_cash | | 8000 |
| tx_0009 | customer_9 | 9000 | |
| tx_0009 | platform_cash | | 9000 |
| tx_0010 | customer_10 | 10000 | |
| tx_0010 | platform_cash | | 10000 |
| tx_0011 | customer_11 | 11000 | |
| tx_0011 | platform_cash | | 11000 |
| tx_0012 | customer_12 | 12000 | |
| tx_0012 | platform_cash | | 12000 |
| tx_0013 | customer_13 | 13000 | |
| tx_0013 | platform_cash | | 13000 |
| tx_0014 | customer_14 | 14000 | |
| tx_0014 | platform_cash | | 14000 |
| tx_0015 | customer_15 | 15000 | |
| tx_0015 | platform_cash | | 15000 |
| tx_0016 | customer_16 | 16000 | |
| tx_0016 | platform_cash | | 16000 |
| tx_0017 | customer_17 | 17000 | |
| tx_0017 | platform_cash | | 17000 |
| tx_0018 | customer_18 | 18000 | |
| tx_0018 | platform_cash | | 18000 |
| tx_0019 | customer_19 | 19000 | |
| tx_0019 | platform_cash | | 19000 |
| tx_0020 | customer_20 | 20000 | |
| tx_0020 | platform_cash | | 20000 |
| tx_0021 | customer_21 | 21000 | |
| tx_0021 | platform_cash | | 21000 |
| tx_0022 | customer_22 | 22000 | |
| tx_0022 | platform_cash | | 22000 |
| tx_0023 | customer_23 | 23000 | |
| tx_0023 | platform_cash | | 23000 |
| tx_0024 | customer_24 | 24000 | |
| tx_0024 | platform_cash | | 24000 |
| tx_0025 | customer_25 | 25000 | |
| tx_0025 | platform_cash | | 25000 |
| tx_0026 | customer_26 | 26000 | |
| tx_0026 | platform_cash | | 26000 |
| tx_0027 | customer_27 | 27000 | |
| tx_0027 | platform_cash | | 27000 |
| tx_0028 | customer_28 | 28000 | |
| tx_0028 | platform_cash | | 28000 |
| tx_0029 | customer_29 | 29000 | |
| tx_0029 | platform_cash | | 29000 |
| tx_0030 | customer_30 | 30000 | |
| tx_0030 | platform_cash | | 30000 |
| tx_0031 | customer_31 | 31000 | |
| tx_0031 | platform_cash | | 31000 |
| tx_0032 | customer_32 | 32000 | |
| tx_0032 | platform_cash | | 32000 |
| tx_0033 | customer_33 | 33000 | |
| tx_0033 | platform_cash | | 33000 |
| tx_0034 | customer_34 | 34000 | |
| tx_0034 | platform_cash | | 34000 |
| tx_0035 | customer_35 | 35000 | |
| tx_0035 | platform_cash | | 35000 |
| tx_0036 | customer_36 | 36000 | |
| tx_0036 | platform_cash | | 36000 |
| tx_0037 | customer_37 | 37000 | |
| tx_0037 | platform_cash | | 37000 |
| tx_0038 | customer_38 | 38000 | |
| tx_0038 | platform_cash | | 38000 |
| tx_0039 | customer_39 | 39000 | |
| tx_0039 | platform_cash | | 39000 |
| tx_0040 | customer_40 | 40000 | |
| tx_0040 | platform_cash | | 40000 |
| tx_0041 | customer_41 | 41000 | |
| tx_0041 | platform_cash | | 41000 |
| tx_0042 | customer_42 | 42000 | |
| tx_0042 | platform_cash | | 42000 |
| tx_0043 | customer_43 | 43000 | |
| tx_0043 | platform_cash | | 43000 |
| tx_0044 | customer_44 | 44000 | |
| tx_0044 | platform_cash | | 44000 |
| tx_0045 | customer_45 | 45000 | |
| tx_0045 | platform_cash | | 45000 |
| tx_0046 | customer_46 | 46000 | |
| tx_0046 | platform_cash | | 46000 |
| tx_0047 | customer_47 | 47000 | |
| tx_0047 | platform_cash | | 47000 |
| tx_0048 | customer_48 | 48000 | |
| tx_0048 | platform_cash | | 48000 |
| tx_0049 | customer_49 | 49000 | |
| tx_0049 | platform_cash | | 49000 |
| tx_0050 | customer_50 | 50000 | |
| tx_0050 | platform_cash | | 50000 |
| tx_0051 | customer_51 | 51000 | |
| tx_0051 | platform_cash | | 51000 |
| tx_0052 | customer_52 | 52000 | |
| tx_0052 | platform_cash | | 52000 |
| tx_0053 | customer_53 | 53000 | |
| tx_0053 | platform_cash | | 53000 |
| tx_0054 | customer_54 | 54000 | |
| tx_0054 | platform_cash | | 54000 |
| tx_0055 | customer_55 | 55000 | |
| tx_0055 | platform_cash | | 55000 |
| tx_0056 | customer_56 | 56000 | |
| tx_0056 | platform_cash | | 56000 |
| tx_0057 | customer_57 | 57000 | |
| tx_0057 | platform_cash | | 57000 |
| tx_0058 | customer_58 | 58000 | |
| tx_0058 | platform_cash | | 58000 |
| tx_0059 | customer_59 | 59000 | |
| tx_0059 | platform_cash | | 59000 |
| tx_0060 | customer_60 | 60000 | |
| tx_0060 | platform_cash | | 60000 |
| tx_0061 | customer_61 | 61000 | |
| tx_0061 | platform_cash | | 61000 |
| tx_0062 | customer_62 | 62000 | |
| tx_0062 | platform_cash | | 62000 |
| tx_0063 | customer_63 | 63000 | |
| tx_0063 | platform_cash | | 63000 |
| tx_0064 | customer_64 | 64000 | |
| tx_0064 | platform_cash | | 64000 |
| tx_0065 | customer_65 | 65000 | |
| tx_0065 | platform_cash | | 65000 |
| tx_0066 | customer_66 | 66000 | |
| tx_0066 | platform_cash | | 66000 |
| tx_0067 | customer_67 | 67000 | |
| tx_0067 | platform_cash | | 67000 |
| tx_0068 | customer_68 | 68000 | |
| tx_0068 | platform_cash | | 68000 |
| tx_0069 | customer_69 | 69000 | |
| tx_0069 | platform_cash | | 69000 |
| tx_0070 | customer_70 | 70000 | |
| tx_0070 | platform_cash | | 70000 |
| tx_0071 | customer_71 | 71000 | |
| tx_0071 | platform_cash | | 71000 |
| tx_0072 | customer_72 | 72000 | |
| tx_0072 | platform_cash | | 72000 |
| tx_0073 | customer_73 | 73000 | |
| tx_0073 | platform_cash | | 73000 |
| tx_0074 | customer_74 | 74000 | |
| tx_0074 | platform_cash | | 74000 |
| tx_0075 | customer_75 | 75000 | |
| tx_0075 | platform_cash | | 75000 |
| tx_0076 | customer_76 | 76000 | |
| tx_0076 | platform_cash | | 76000 |
| tx_0077 | customer_77 | 77000 | |
| tx_0077 | platform_cash | | 77000 |
| tx_0078 | customer_78 | 78000 | |
| tx_0078 | platform_cash | | 78000 |
| tx_0079 | customer_79 | 79000 | |
| tx_0079 | platform_cash | | 79000 |
| tx_0080 | customer_80 | 80000 | |
| tx_0080 | platform_cash | | 80000 |
| tx_0081 | customer_81 | 81000 | |
| tx_0081 | platform_cash | | 81000 |
| tx_0082 | customer_82 | 82000 | |
| tx_0082 | platform_cash | | 82000 |
| tx_0083 | customer_83 | 83000 | |
| tx_0083 | platform_cash | | 83000 |
| tx_0084 | customer_84 | 84000 | |
| tx_0084 | platform_cash | | 84000 |
| tx_0085 | customer_85 | 85000 | |
| tx_0085 | platform_cash | | 85000 |
| tx_0086 | customer_86 | 86000 | |
| tx_0086 | platform_cash | | 86000 |
| tx_0087 | customer_87 | 87000 | |
| tx_0087 | platform_cash | | 87000 |
| tx_0088 | customer_88 | 88000 | |
| tx_0088 | platform_cash | | 88000 |
| tx_0089 | customer_89 | 89000 | |
| tx_0089 | platform_cash | | 89000 |
| tx_0090 | customer_90 | 90000 | |
| tx_0090 | platform_cash | | 90000 |
| tx_0091 | customer_91 | 91000 | |
| tx_0091 | platform_cash | | 91000 |
| tx_0092 | customer_92 | 92000 | |
| tx_0092 | platform_cash | | 92000 |
| tx_0093 | customer_93 | 93000 | |
| tx_0093 | platform_cash | | 93000 |
| tx_0094 | customer_94 | 94000 | |
| tx_0094 | platform_cash | | 94000 |
| tx_0095 | customer_95 | 95000 | |
| tx_0095 | platform_cash | | 95000 |
| tx_0096 | customer_96 | 96000 | |
| tx_0096 | platform_cash | | 96000 |
| tx_0097 | customer_97 | 97000 | |
| tx_0097 | platform_cash | | 97000 |
| tx_0098 | customer_98 | 98000 | |
| tx_0098 | platform_cash | | 98000 |
| tx_0099 | customer_99 | 99000 | |
| tx_0099 | platform_cash | | 99000 |
| tx_0100 | customer_100 | 100000 | |
| tx_0100 | platform_cash | | 100000 |
| tx_0101 | customer_101 | 101000 | |
| tx_0101 | platform_cash | | 101000 |
| tx_0102 | customer_102 | 102000 | |
| tx_0102 | platform_cash | | 102000 |
| tx_0103 | customer_103 | 103000 | |
| tx_0103 | platform_cash | | 103000 |
| tx_0104 | customer_104 | 104000 | |
| tx_0104 | platform_cash | | 104000 |
| tx_0105 | customer_105 | 105000 | |
| tx_0105 | platform_cash | | 105000 |
| tx_0106 | customer_106 | 106000 | |
| tx_0106 | platform_cash | | 106000 |
| tx_0107 | customer_107 | 107000 | |
| tx_0107 | platform_cash | | 107000 |
| tx_0108 | customer_108 | 108000 | |
| tx_0108 | platform_cash | | 108000 |
| tx_0109 | customer_109 | 109000 | |
| tx_0109 | platform_cash | | 109000 |
| tx_0110 | customer_110 | 110000 | |
| tx_0110 | platform_cash | | 110000 |
| tx_0111 | customer_111 | 111000 | |
| tx_0111 | platform_cash | | 111000 |
| tx_0112 | customer_112 | 112000 | |
| tx_0112 | platform_cash | | 112000 |
| tx_0113 | customer_113 | 113000 | |
| tx_0113 | platform_cash | | 113000 |
| tx_0114 | customer_114 | 114000 | |
| tx_0114 | platform_cash | | 114000 |
| tx_0115 | customer_115 | 115000 | |
| tx_0115 | platform_cash | | 115000 |
| tx_0116 | customer_116 | 116000 | |
| tx_0116 | platform_cash | | 116000 |
| tx_0117 | customer_117 | 117000 | |
| tx_0117 | platform_cash | | 117000 |
| tx_0118 | customer_118 | 118000 | |
| tx_0118 | platform_cash | | 118000 |
| tx_0119 | customer_119 | 119000 | |
| tx_0119 | platform_cash | | 119000 |
| tx_0120 | customer_120 | 120000 | |
| tx_0120 | platform_cash | | 120000 |
| tx_0121 | customer_121 | 121000 | |
| tx_0121 | platform_cash | | 121000 |
| tx_0122 | customer_122 | 122000 | |
| tx_0122 | platform_cash | | 122000 |
| tx_0123 | customer_123 | 123000 | |
| tx_0123 | platform_cash | | 123000 |
| tx_0124 | customer_124 | 124000 | |
| tx_0124 | platform_cash | | 124000 |
| tx_0125 | customer_125 | 125000 | |
| tx_0125 | platform_cash | | 125000 |
| tx_0126 | customer_126 | 126000 | |
| tx_0126 | platform_cash | | 126000 |
| tx_0127 | customer_127 | 127000 | |
| tx_0127 | platform_cash | | 127000 |
| tx_0128 | customer_128 | 128000 | |
| tx_0128 | platform_cash | | 128000 |
| tx_0129 | customer_129 | 129000 | |
| tx_0129 | platform_cash | | 129000 |
| tx_0130 | customer_130 | 130000 | |
| tx_0130 | platform_cash | | 130000 |
| tx_0131 | customer_131 | 131000 | |
| tx_0131 | platform_cash | | 131000 |
| tx_0132 | customer_132 | 132000 | |
| tx_0132 | platform_cash | | 132000 |
| tx_0133 | customer_133 | 133000 | |
| tx_0133 | platform_cash | | 133000 |
| tx_0134 | customer_134 | 134000 | |
| tx_0134 | platform_cash | | 134000 |
| tx_0135 | customer_135 | 135000 | |
| tx_0135 | platform_cash | | 135000 |
| tx_0136 | customer_136 | 136000 | |
| tx_0136 | platform_cash | | 136000 |
| tx_0137 | customer_137 | 137000 | |
| tx_0137 | platform_cash | | 137000 |
| tx_0138 | customer_138 | 138000 | |
| tx_0138 | platform_cash | | 138000 |
| tx_0139 | customer_139 | 139000 | |
| tx_0139 | platform_cash | | 139000 |
| tx_0140 | customer_140 | 140000 | |
| tx_0140 | platform_cash | | 140000 |
| tx_0141 | customer_141 | 141000 | |
| tx_0141 | platform_cash | | 141000 |
| tx_0142 | customer_142 | 142000 | |
| tx_0142 | platform_cash | | 142000 |
| tx_0143 | customer_143 | 143000 | |
| tx_0143 | platform_cash | | 143000 |
| tx_0144 | customer_144 | 144000 | |
| tx_0144 | platform_cash | | 144000 |
| tx_0145 | customer_145 | 145000 | |
| tx_0145 | platform_cash | | 145000 |
| tx_0146 | customer_146 | 146000 | |
| tx_0146 | platform_cash | | 146000 |
| tx_0147 | customer_147 | 147000 | |
| tx_0147 | platform_cash | | 147000 |
| tx_0148 | customer_148 | 148000 | |
| tx_0148 | platform_cash | | 148000 |
| tx_0149 | customer_149 | 149000 | |
| tx_0149 | platform_cash | | 149000 |
| tx_0150 | customer_150 | 150000 | |
| tx_0150 | platform_cash | | 150000 |
| tx_0151 | customer_151 | 151000 | |
| tx_0151 | platform_cash | | 151000 |
| tx_0152 | customer_152 | 152000 | |
| tx_0152 | platform_cash | | 152000 |
| tx_0153 | customer_153 | 153000 | |
| tx_0153 | platform_cash | | 153000 |
| tx_0154 | customer_154 | 154000 | |
| tx_0154 | platform_cash | | 154000 |
| tx_0155 | customer_155 | 155000 | |
| tx_0155 | platform_cash | | 155000 |
| tx_0156 | customer_156 | 156000 | |
| tx_0156 | platform_cash | | 156000 |
| tx_0157 | customer_157 | 157000 | |
| tx_0157 | platform_cash | | 157000 |
| tx_0158 | customer_158 | 158000 | |
| tx_0158 | platform_cash | | 158000 |
| tx_0159 | customer_159 | 159000 | |
| tx_0159 | platform_cash | | 159000 |
| tx_0160 | customer_160 | 160000 | |
| tx_0160 | platform_cash | | 160000 |
| tx_0161 | customer_161 | 161000 | |
| tx_0161 | platform_cash | | 161000 |
| tx_0162 | customer_162 | 162000 | |
| tx_0162 | platform_cash | | 162000 |
| tx_0163 | customer_163 | 163000 | |
| tx_0163 | platform_cash | | 163000 |
| tx_0164 | customer_164 | 164000 | |
| tx_0164 | platform_cash | | 164000 |
| tx_0165 | customer_165 | 165000 | |
| tx_0165 | platform_cash | | 165000 |
| tx_0166 | customer_166 | 166000 | |
| tx_0166 | platform_cash | | 166000 |
| tx_0167 | customer_167 | 167000 | |
| tx_0167 | platform_cash | | 167000 |
| tx_0168 | customer_168 | 168000 | |
| tx_0168 | platform_cash | | 168000 |
| tx_0169 | customer_169 | 169000 | |
| tx_0169 | platform_cash | | 169000 |
| tx_0170 | customer_170 | 170000 | |
| tx_0170 | platform_cash | | 170000 |
| tx_0171 | customer_171 | 171000 | |
| tx_0171 | platform_cash | | 171000 |
| tx_0172 | customer_172 | 172000 | |
| tx_0172 | platform_cash | | 172000 |
| tx_0173 | customer_173 | 173000 | |
| tx_0173 | platform_cash | | 173000 |
| tx_0174 | customer_174 | 174000 | |
| tx_0174 | platform_cash | | 174000 |
| tx_0175 | customer_175 | 175000 | |
| tx_0175 | platform_cash | | 175000 |
| tx_0176 | customer_176 | 176000 | |
| tx_0176 | platform_cash | | 176000 |
| tx_0177 | customer_177 | 177000 | |
| tx_0177 | platform_cash | | 177000 |
| tx_0178 | customer_178 | 178000 | |
| tx_0178 | platform_cash | | 178000 |
| tx_0179 | customer_179 | 179000 | |
| tx_0179 | platform_cash | | 179000 |
| tx_0180 | customer_180 | 180000 | |
| tx_0180 | platform_cash | | 180000 |
| tx_0181 | customer_181 | 181000 | |
| tx_0181 | platform_cash | | 181000 |
| tx_0182 | customer_182 | 182000 | |
| tx_0182 | platform_cash | | 182000 |
| tx_0183 | customer_183 | 183000 | |
| tx_0183 | platform_cash | | 183000 |
| tx_0184 | customer_184 | 184000 | |
| tx_0184 | platform_cash | | 184000 |
| tx_0185 | customer_185 | 185000 | |
| tx_0185 | platform_cash | | 185000 |
| tx_0186 | customer_186 | 186000 | |
| tx_0186 | platform_cash | | 186000 |
| tx_0187 | customer_187 | 187000 | |
| tx_0187 | platform_cash | | 187000 |
| tx_0188 | customer_188 | 188000 | |
| tx_0188 | platform_cash | | 188000 |
| tx_0189 | customer_189 | 189000 | |
| tx_0189 | platform_cash | | 189000 |
| tx_0190 | customer_190 | 190000 | |
| tx_0190 | platform_cash | | 190000 |
| tx_0191 | customer_191 | 191000 | |
| tx_0191 | platform_cash | | 191000 |
| tx_0192 | customer_192 | 192000 | |
| tx_0192 | platform_cash | | 192000 |
| tx_0193 | customer_193 | 193000 | |
| tx_0193 | platform_cash | | 193000 |
| tx_0194 | customer_194 | 194000 | |
| tx_0194 | platform_cash | | 194000 |
| tx_0195 | customer_195 | 195000 | |
| tx_0195 | platform_cash | | 195000 |
| tx_0196 | customer_196 | 196000 | |
| tx_0196 | platform_cash | | 196000 |
| tx_0197 | customer_197 | 197000 | |
| tx_0197 | platform_cash | | 197000 |
| tx_0198 | customer_198 | 198000 | |
| tx_0198 | platform_cash | | 198000 |
| tx_0199 | customer_199 | 199000 | |
| tx_0199 | platform_cash | | 199000 |

## Consequences

- Refunds and payouts get a full explanation in the ledger.
- Reads of a balance need the cache. The cache needs a fix job.
- Old balances need a one-time import with a start transaction per account.
- The finance team can read the ledger directly for audits.
- The write path gets slower by about 3 ms because of the second entry.

## Rollout plan

### Phase 1: shadow

- Write entries next to the old update.
- Compare sums with balances every hour.
- Fix every difference.

### Phase 2: read

- Read balances from the ledger cache.
- Keep the old column as a fallback.

### Phase 3: write

- Stop the old update.
- Remove the fallback after 30 quiet days.

### Phase 4: clean up

- Drop the old column.
- Update the runbooks, including the [refund runbook](refund-runbook.md).

## Risks

| Risk | Chance | Effect | Answer |
|---|---|---|---|
| Cache and ledger differ | medium | wrong balance shown | hourly compare job and alert |
| Slow writes | low | longer latency | batch entries in one insert |
| Import error | low | wrong start balance | dry run and finance sign-off |
| Team habits | high | direct updates by mistake | code owner rule and a lint check |

## Open points

The retention of old entries is not decided. See also the [payment API contract](payment-api-v3-contract.md) for the fields that clients see.
