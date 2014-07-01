#!/bin/bash

#variables
# auth variables
storage_user="test:tester"
storage_password="testing"

# formpost variables
max_file_size=1000000
redirect="http://localhost"
max_file_count="1"
expires=600
signature=""
x_delete_at="$(date +%s --date "1 day")"
path="/v1/AUTH_test/container/obj2_"
filepath="test_file.txt"

# log in
auth_creds=( $(curl -s -i -H "X-Storage-User: $storage_user" -H "X-Storage-Pass: $storage_password" http://127.0.0.1:8080/auth/v1.0 |egrep 'X-Auth-Token|X-Storage-Url' |awk '{print $2}') )

TOKEN="$( echo ${auth_creds[1]} |tr -d '\r' |tr -d '\n' )"
STORAGE_URL="$( echo ${auth_creds[0]} |tr -d '\r' |tr -d '\n' )"

echo "Token: $TOKEN"
echo "STORAGE_URL: $STORAGE_URL"

postform_creds=( $(swift-form-signature $path $redirect $max_file_size $max_file_count $expires "abc123" |awk '{print $2}') )
d_expires="${postform_creds[0]}"
signature="${postform_creds[1]}"

echo "Expires: $d_expires"
echo "Signature: $signature"

#swift-form-signature /v1/AUTH_test/container/obj_ http://localhost 99999999999 9999 9999999 AUTH_tk1ab659a1ca7e446cbeb07fb8190f0219
curl -v -X POST -i --form "redirect=$redirect" --form "max_file_size=$max_file_size" --form "max_file_count=$max_file_count" --form "signature=$signature" \
                --form "x-delete-at=$x_delete_at" --form "expires=$d_expires" --form "file=@$filepath" http://127.0.0.1:8080$path
                #--form "x-delete-at=$x_delete_at" --form "expires=$d_expires" --form "file=@$filepath" http://127.0.0.1:8888
