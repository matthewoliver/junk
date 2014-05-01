#!/usr/bin/env python

import gear
import sys

class GearCatClient(gear.Client):
    def __init__(self):
        super(GearCatClient, self).__init__()

    def sendAdminRequest(self):
        for connection in self.active_connections:
            try:
                req = gear.StatusAdminRequest()
                connection.sendAdminRequest(req)
            except Exception:
                print("Exception while listing functions")
                return
            print("Connection: %s" %(str(connection)))
            for line in req.response.split('\n'):
                print("  %s" % (line))


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: %s <gearman_host> <gearman port>" % (sys.argv[0]))
	sys.exit(1)
    host = sys.argv[1]
    port = sys.argv[2]
    gearcatClient = GearCatClient()
    gearcatClient.addServer(host, port)
    gearcatClient.waitForServer()
    gearcatClient.sendAdminRequest()
    gearcatClient.shutdown()
