import sys

DEFAULT_NUM_RANGE = 20
num = DEFAULT_NUM_RANGE
if len(sys.argv) > 0:
    try:
        num = int(sys.argv[1])
    except ValueError:
        num = DEFAULT_NUM_RANGE

val = ("bytes=" + ",".join("%d-%d" % (x * 1000, x * 1000 + 10)
                           for x in range(num)))
print("Ranges: %s" % val)
