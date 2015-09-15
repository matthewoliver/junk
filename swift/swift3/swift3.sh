#!/bin/bash

cd /opt/
git clone https://github.com/stackforge/swift3
cd swift3
apt-get install python-lxml
pip install -r requirements.txt
python setup.py install

cat << EOF >> /etc/swift/proxy-server.conf

[filter:swift3]
use = egg:swift3#swift3

# Swift has no concept of the S3's resource owner; the resources
# (i.e. containers and objects) created via the Swift API have no owner
# information. This option specifies how the swift3 middleware handles them
# with the S3 API.  If this option is 'false', such kinds of resources will be
# invisible and no users can access them with the S3 API.  If set to 'true',
# the resource without owner is belong to everyone and everyone can access it
# with the S3 API.  If you care about S3 compatibility, set 'false' here.  This
# option makes sense only when the s3_acl option is set to 'true' and your
# Swift cluster has the resources created via the Swift API.
allow_no_owner = false

# Set a region name of your Swift cluster.  Note that Swift3 doesn't choose a
# region of the newly created bucket actually.  This value is used only for the
# GET Bucket location API.
location = US

# Set the default maximum number of objects returned in the GET Bucket
# response.
max_bucket_listing = 1000

# Set the maximum number of objects we can delete with the Multi-Object Delete
# operation.
max_multi_delete_objects = 1000

# If set to 'true', Swift3 uses its own metadata for ACL
# (e.g. X-Container-Sysmeta-Swift3-Acl) to achieve the best S3 compatibility.
# If set to 'false', Swift3 tries to use Swift ACL (e.g. X-Container-Read)
# instead of S3 ACL as far as possible.  If you want to keep backward
# compatibility with Swift3 1.7 or earlier, set false here
# If set to 'false' after set to 'true' and put some container/object,
# all users will be able to access container/object.
# Note that s3_acl doesn't keep the acl consistency between S3 API and Swift
# API. (e.g. when set s3acl to true and PUT acl, we won't get the acl
# information via Swift API at all and the acl won't be applied against to
# Swift API even if it is for a bucket currently supported.)
# Note that s3_acl currently supports only keystone and tempauth.
# DON'T USE THIS for production before enough testing for your use cases.
# This stuff is still under development and it might cause something
# you don't expect.
s3_acl = false

# Specify a host name of your Swift cluster.  This enables virtual-hosted style
# requests.
storage_domain =

[filter:s3token]
paste.filter_factory = keystoneclient.middleware.s3_token:filter_factory
auth_port = 35357
auth_host = 10.176.64.250
auth_protocol = http
EOF
