import pickle
import sys
import os

if len(sys.argv) < 2:
    print('Usage: $s <path_to_pending_file> [<another_pending_file> ..]' %
          sys.argv[0])
    exit(1)

for pending in sys.argv[1:]:
    if os.path.exists(pending) and os.path.isfile(pending):
        try:
            print('%s:' % pending)
            with open(pending) as f:
                for entry in f.read().split(':'):
                    if not entry:
                        continue
                    print(pickle.loads(entry.decode('base64')))
        except Exception as ex:
            print("Error processing '%s': %s" % (pending, ex))
    else:
        print("Pending file '%s' doesn't exist or isn't a file" % pending)
        continue
