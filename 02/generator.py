from random import randint
import sys
import itertools
# Run: python generator.py <filnename> <number>
# Source: https://gist.github.com/andreasWallner/11c9784cb42d8777217c
def lsfr(seed, polynom):
    data = seed
    poly = polynom

    while 1:
        lsb = data & 1
        data = data >> 1
        if lsb != 0:
            data = data ^ poly
            yield 1
        else:
            yield 0

with open(sys.argv[1], 'w') as file:
    x = lsfr(0b0110, 0b1100)
    data = list(itertools.islice(x, int(sys.argv[2])))
    for i, bit in enumerate(data):
        file.write(str(bit))
        if i != len(data) - 1:
            file.write('\n')