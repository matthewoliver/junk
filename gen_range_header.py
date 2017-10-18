import sys

DEFAULT_NUM_RANGE = 20
DEFAULT_MULTIPLIER = 1000
DEFAULT_RANGE_SIZE = 10

num = DEFAULT_NUM_RANGE
mult = DEFAULT_MULTIPLIER
size = DEFAULT_RANGE_SIZE

if len(sys.argv) > 1:
    try:
        num = int(sys.argv[1])
    except ValueError:
        num = DEFAULT_NUM_RANGE

if len(sys.argv) > 2:
    try:
        mult = int(sys.argv[2])
    except ValueError:
        mult = DEFAULT_MULTIPLIER

if len(sys.argv) > 3:
    try:
        size = int(sys.argv[3])
    except ValueError:
        size = DEFAULT_RANGE_SIZE


val = ("bytes=" + ",".join("%d-%d" % (x * mult, x * mult + size)
                           for x in range(num)))
print("Ranges: %s" % val)
