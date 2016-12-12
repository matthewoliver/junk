#!/bin/bash

# auth variables
url="http://192.168.9.51:5000/v2.0/tokens"
auth='{"auth": {"tenantName": "project1", "passwordCredentials": {"username": "matt", "password": "<PASSWORD>"}}}'

#curl -s -d "$auth" -H 'Content-type: application/json' $url |python -m json.tool
curl -s -d "$auth" -H 'Content-type: application/json' $url |python -c "import sys, json; print json.load(sys.stdin)['access']['token']['id']"
