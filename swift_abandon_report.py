#!/usr/bin/env python

import requests
import json

change_str = """
Number: %(_number)s     Mergeable: %(mergeable)s    Branch: %(branch)s
Subject: %(subject)s
Created: %(created)s    Updated: %(updated)s
Owner: %(name)s     Username: %(username)s
Email: %(email)s
URL: https://review.openstack.org/#/c/%(_number)s"""


def main():
    url = "https://review.openstack.org/changes/?q=status:open+age:4week+(label:Verified<=-1,jenkins+OR+label:Code-Review<=-1)+NOT+label:Workflow<=-1+(project:openstack/swift+OR+project:openstack/python-swiftclient+OR+project:openstack/swift-python-agent+OR+project:openstack/swift-bench+OR+project:openstack/swift-specs)+status:open+NOT+label:Code-Review<=-2&o=DETAILED_ACCOUNTS"
    #auth = requests.auth.HTTPDigestAuth('mattoliverau', '')
    session = requests.Session()
    resp = session.get(url,
                       #auth=auth,
                       headers={'Accept': 'application/json',
                                'Accept-Encoding': 'gzip'})
    ret = json.loads(resp.text[4:])
    for d in ret:
        d.update(d['owner'])
        if 'username' not in d:
            d['username'] = ''
        print change_str % d

if __name__ == "__main__":
    main()
