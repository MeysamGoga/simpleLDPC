#==============================================================
# File : scripts/gen_llr.py
#==============================================================

import math
import random

N = 20

SNR_DB = 2.0

LLR_BITS = 8

LLR_MAX = 127
LLR_MIN = -128

CODEWORD = [0]*N

#-------------------------------------------------------------

def gaussian():

    u1 = random.random()
    u2 = random.random()

    return math.sqrt(-2.0*math.log(u1))*math.cos(2.0*math.pi*u2)

#-------------------------------------------------------------

def bpsk(bit):

    if bit == 0:
        return 1.0

    return -1.0

#-------------------------------------------------------------

rate = 0.5

ebn0 = pow(10.0,SNR_DB/10.0)

sigma = math.sqrt(1.0/(2.0*rate*ebn0))

print()

print("Sigma =",sigma)

print()

rx = []

for b in CODEWORD:

    x = bpsk(b)

    y = x + sigma*gaussian()

    rx.append(y)

llr = []

for y in rx:

    value = 2.0*y/(sigma*sigma)

    value = round(value)

    value = max(LLR_MIN,min(LLR_MAX,value))

    llr.append(int(value))

print("Received")

print(rx)

print()

print("LLR")

print(llr)

print()

with open("test_vectors.mem","w") as f:

    for x in llr:

        if x < 0:
            x = (1<<LLR_BITS)+x

        f.write("{:02X}\n".format(x))

print("Generated test_vectors.mem")
