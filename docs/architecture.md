# File: docs/architecture.md

# LDPC Decoder Architecture

## Overview

This project implements a sequential Flooding Plain Min-Sum LDPC decoder
targeted for FPGA implementation.

```
                +----------------+
                |      FSM       |
                +--------+-------+
                         |
     +-------------------+-------------------+
     |                   |                   |
     v                   v                   v
+----------------+  +---------------+  +---------------+
| Initialization |  |   CN Update   |  |   VN Update   |
+----------------+  +---------------+  +---------------+
                         |
                         v
                 +----------------+
                 | Syndrome Check |
                 +--------+-------+
                          |
                          v
                        DONE
```

---

## Datapath

Stored memories:

```
channel_llr[N]

app_llr[N]

vn_to_cn[M][MAX_CN_DEG]

cn_to_vn[M][MAX_CN_DEG]

hard_bits[N]
```

---

## Decoder Flow

```
RESET

↓

INIT

↓

CN UPDATE

↓

VN UPDATE

↓

APP LLR

↓

HARD DECISION

↓

SYNDROME

↓

SUCCESS ?

YES --------> DONE

NO

↓

ITER++

↓

CN UPDATE
```

---

## Scheduling

Flooding

All check nodes are updated first.

Then all variable nodes are updated.

---

## Check Node Update

For each check node

```
Receive messages

↓

Absolute value

↓

Find minimum

↓

Find second minimum

↓

Compute sign parity

↓

Generate outgoing messages
```

---

## Variable Node Update

For each variable node

```
Channel LLR

+

All incoming CN messages

↓

APP LLR

↓

Extrinsic messages
```

---

## Fixed Point

Signed 8-bit

Range:

```
-128
...
127
```

---

## Termination

Decoder stops when

```
Syndrome == Zero
```

or

```
Iteration == MAX_ITER
```

---

## Future Improvements

- Offset Min-Sum
- Normalized Min-Sum
- Layered Scheduling
- Pipeline
- BRAM implementation
- AXI interface
- External LLR source
- DVB-S2 / WiFi / 5G LDPC matrices
