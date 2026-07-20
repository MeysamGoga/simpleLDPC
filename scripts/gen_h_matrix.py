#==============================================================
# File : scripts/gen_h_matrix.py
#==============================================================

"""
Generate a regular (M x N) LDPC parity-check matrix and emit a
SystemVerilog package containing sparse connection tables.

Current defaults:
    M = 10
    N = 20
    CN degree = 4
    VN degree = 2
"""

from collections import defaultdict
import random

M = 10
N = 20

CN_DEG = 4
VN_DEG = 2

assert M * CN_DEG == N * VN_DEG

random.seed(1)

cn_conn = [[] for _ in range(M)]
vn_conn = [[] for _ in range(N)]

edges = []

for vn in range(N):
    for _ in range(VN_DEG):
        edges.append(vn)

random.shuffle(edges)

for cn in range(M):

    for _ in range(CN_DEG):

        while True:

            vn = edges.pop()

            if vn not in cn_conn[cn]:
                break

            edges.insert(0,vn)

        cn_conn[cn].append(vn)
        vn_conn[vn].append(cn)

print("Generated Graph")

print()

for i in range(M):
    print("CN",i,":",cn_conn[i])

print()

for i in range(N):
    print("VN",i,":",vn_conn[i])

print()

print("------------------------------------------------")

print()

print("package ldpc_h_matrix_pkg;")

print()

print("import ldpc_pkg::*;")

print()

print("localparam int CN_DEGREE[M]='{")

for i in range(M):

    if i!=M-1:
        print("    %d,"%CN_DEG)

    else:
        print("    %d"%CN_DEG)

print("};")

print()

print("localparam int VN_DEGREE[N]='{")

for i in range(N):

    if i!=N-1:
        print("    %d,"%VN_DEG)

    else:
        print("    %d"%VN_DEG)

print("};")

print()

print("localparam int CN_CONN[M][%d]='{"%CN_DEG)

for i in range(M):

    s="    '{"

    for j,v in enumerate(cn_conn[i]):

        if j!=CN_DEG-1:
            s += "%2d," % v
        else:
            s += "%2d" % v

    s += "}"

    if i!=M-1:
        s+=","

    print(s)

print("};")

print()

print("localparam int VN_CONN[N][%d]='{"%VN_DEG)

for i in range(N):

    s="    '{"

    for j,v in enumerate(vn_conn[i]):

        if j!=VN_DEG-1:
            s += "%2d," % v
        else:
            s += "%2d" % v

    s += "}"

    if i!=N-1:
        s+=","

    print(s)

print("};")

print()

print("endpackage")
