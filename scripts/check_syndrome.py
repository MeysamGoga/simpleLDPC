#==============================================================
# File : scripts/check_syndrome.py
#==============================================================

"""
Verify H * c^T = 0 over GF(2)

Input:
    Generated Tanner graph

Output:
    Syndrome
"""

from collections import defaultdict

M = 10
N = 20

CN_CONN = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    []
]

VN_CONN = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    []
]

#-------------------------------------------------------------

def build_from_vn():

    global CN_CONN

    CN_CONN = [[] for _ in range(M)]

    for vn in range(N):

        for cn in VN_CONN[vn]:

            CN_CONN[cn].append(vn)

#-------------------------------------------------------------

def build_from_cn():

    global VN_CONN

    VN_CONN = [[] for _ in range(N)]

    for cn in range(M):

        for vn in CN_CONN[cn]:

            VN_CONN[vn].append(cn)

#-------------------------------------------------------------

def syndrome(bits):

    syn = []

    for cn in range(M):

        p = 0

        for vn in CN_CONN[cn]:

            p ^= bits[vn]

        syn.append(p)

    return syn

#-------------------------------------------------------------

def valid(bits):

    s = syndrome(bits)

    return all(x == 0 for x in s)

#-------------------------------------------------------------

def print_graph():

    print()

    print("Check Nodes")

    for i in range(M):

        print(i, CN_CONN[i])

    print()

    print("Variable Nodes")

    for i in range(N):

        print(i, VN_CONN[i])

#-------------------------------------------------------------

if __name__ == "__main__":

    build_from_vn()

    print_graph()

    print()

    zero = [0]*N

    print("Zero Codeword")

    print(zero)

    print()

    print("Syndrome")

    print(syndrome(zero))

    print()

    print("Valid =", valid(zero))

    print()

    test = [0]*N

    test[3] = 1

    print("Single Error")

    print(test)

    print()

    print(syndrome(test))

    print()

    print("Valid =", valid(test))
