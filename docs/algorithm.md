# File: docs/algorithm.md

# Plain Min-Sum LDPC Decoding Algorithm

## Introduction

The decoder implements the iterative Flooding Plain Min-Sum algorithm.

The transmitted codeword is assumed to be the all-zero codeword.

The decoder accepts quantized Log-Likelihood Ratios (LLRs) and iteratively updates Check Node (CN) and Variable Node (VN) messages until either the syndrome becomes zero or the maximum iteration count is reached.

---

# Symbols

```
N      Number of Variable Nodes

M      Number of Check Nodes

Lch    Channel LLR

Qij    Variable-to-Check message

Rji    Check-to-Variable message

Lapp   A-Posteriori LLR
```

---

# Initialization

For every edge

```
Qij = Lch
```

For every variable node

```
Lapp = Lch
```

---

# Iterative Procedure

Repeat

```
Check Node Update

↓

Variable Node Update

↓

Hard Decision

↓

Syndrome Check
```

Until

```
Success

or

MAX_ITER
```

---

# Check Node Update

For every Check Node

```
Receive

Q1
Q2
...
Qd
```

Compute

```
SignParity

=

Sign(Q1)

XOR

Sign(Q2)

XOR

...

XOR

Sign(Qd)
```

Compute

```
Min1

Min2
```

Then for each edge

```
if edge == MinIndex

OutputMagnitude = Min2

else

OutputMagnitude = Min1
```

Output sign

```
OutputSign

=

SignParity

XOR

CurrentInputSign
```

Outgoing message

```
Rji

=

OutputSign × OutputMagnitude
```

---

# Variable Node Update

For every Variable Node

```
Lapp

=

Lch

+

Σ(Rji)
```

Extrinsic message

```
Qij

=

Lapp

-

Rji
```

---

# Hard Decision

```
if

Lapp >= 0

Bit = 0

else

Bit = 1
```

---

# Syndrome

For every Check Node

```
Parity

=

XOR

of all connected bits
```

If

```
All parity checks == 0
```

Decoder succeeds.

---

# Complexity

For one iteration

```
CN Processing

O(E)
```

```
VN Processing

O(E)
```

Overall

```
O(E × Iterations)
```

where

```
E

=

Number of Tanner Graph Edges
```

---

# Numerical Representation

```
Signed Fixed Point

8-bit
```

Range

```
-128

...

127
```

All additions are saturated.

---

# Decoder Output

```
decoded_bits[N]

done

success

iter_count
```

---

# Future Extensions

```
Offset Min-Sum

↓

Normalized Min-Sum

↓

Layered Scheduling

↓

Pipeline

↓

Early Termination Optimization
```
