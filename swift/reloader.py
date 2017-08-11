import multiprocessing
import time

from swift.common.wsgi import run_wsgi


def start_daemon(conf_file='/etc/swift/proxy-server.conf', options={}):
    run_wsgi(conf_file, 'proxy-server', **options)


def start_stopper(num=3, sleep=0.5):
    # setup
    queue = []
    try:
        for i in range(num):
            p = multiprocessing.Process(target=start_daemon)
            p.start()
            queue.append(p)

        while True:
            time.sleep(sleep)
            p = queue.pop(0)
            p.terminate()
            p = multiprocessing.Process(target=start_daemon)
            p.start()
            queue.append(p)

    finally:
        for p in queue:
            p.terminate()

if __name__ == "__main__":
    start_stopper()
