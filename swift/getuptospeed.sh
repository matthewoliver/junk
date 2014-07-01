#!/bin/bash
# This basic script was used to get up to speed after a swift reset when
# testing with test_postform.sh. 
#
# This sets up the Temp_URL_Key the script uses and makes sure the container
# exists. So you an think of the this is run once when swift is restarted after
# hacking on it.
#
# test_postform.sh is run to PostForm using curl and generates the signiture.

. ~/bin/swift_auth.sh

curl -i -X POST -H "X-Auth-Token: $TOKEN" -H "X-ACCOUNT_Meta_Temp_URL_Key: abc123"  $STORAGE_URL
curl -i -X PUT -H "X-Auth-Token: $TOKEN" $STORAGE_URL/container
