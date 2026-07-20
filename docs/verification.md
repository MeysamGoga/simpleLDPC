# File: docs/verification.md

# Verification Plan

## Objective

Verify the functional correctness of the LDPC decoder before synthesis.

The decoder shall correctly decode valid codewords using the Plain Min-Sum algorithm and terminate either when all parity checks are satisfied or when the maximum iteration count is reached.

---

# Verification Levels

```
Unit Verification

↓

Module Verification

↓

Top-Level Verification

↓

Regression
```

---

# Unit Verification

Individual RTL modules shall be verified independently.

Modules

```
ldpc_cn_update

ldpc_vn_update

ldpc_syndrome

ldpc_fsm
```

Each module shall be stimulated using directed test vectors.

---

# Top-Level Verification

Instantiate

```
ldpc_decoder
```

Apply

```
Clock

Reset

Start
```

Observe

```
done

success

iter_count

hard_bits
```

---

# Test Cases

## Test 1

```
Zero Noise

Expected

Success

Iteration = 1
```

---

## Test 2

```
Very High SNR

Expected

Success

Small Iteration Count
```

---

## Test 3

```
Medium SNR

Expected

Success

Several Iterations
```

---

## Test 4

```
Low SNR

Expected

Either

Success

or

Maximum Iteration Reached
```

---

## Test 5

```
Random LLR

Expected

No RTL Errors

No Overflow

No Unknown Values
```

---

# Functional Checks

Verify

```
Correct Min1

Correct Min2

Correct Sign

Correct APP LLR

Correct Extrinsic Messages
```

---

# Syndrome Check

For every decoded frame

Verify

```
H × cᵀ = 0
```

When true

```
success = 1
```

Otherwise

```
success = 0
```

---

# Fixed-Point Verification

Check

```
Positive Saturation

Negative Saturation

Overflow

Underflow
```

---

# FSM Verification

Verify state sequence

```
RESET

↓

INIT

↓

CN_UPDATE

↓

VN_UPDATE

↓

SYNDROME

↓

DONE
```

Check

```
No Illegal States

No Deadlock
```

---

# Timing Verification

Verify

```
One Clock

↓

One FSM Transition
```

No combinational feedback shall exist.

---

# Waveforms

Observe

```
channel_llr

vn_to_cn

cn_to_vn

app_llr

hard_bits

done

success

iter_count
```

---

# Success Criteria

The decoder passes verification if

```
RTL Compiles Successfully

↓

Simulation Completes

↓

No Unknown Values

↓

Correct Syndrome

↓

Correct Termination

↓

Expected Hard Decision
```

---

# Future Verification

```
Randomized Testbench

Self-Checking Testbench

Python Golden Model

MATLAB Comparison

Regression Suite

Coverage Collection
```
