# Note this was an example written by Christian Schwede (cschwede)

# Used tempauth config for this:
#[filter:tempauth]
#use = egg:swift#tempauth
#user_admin_admin = admin .admin .reseller_admin
#user_test_tester = testing .admin
#user_test2_tester2 = testing2 .admin
#user_test_tester3 = testing3
#reseller_prefix = AUTH, SERVICE
#SERVICE_require_group = .service
#user_glance_glance = glancepw .service .admin

set -x
AUTH_TOKEN=`swift stat -v | grep Token | awk -F ': ' '{print $2}'`
GLANCE_TOKEN=`swift -U glance:glance -K glancepw stat -v | grep Token | awk -F ': ' '{print $2}'`

swift post src
touch obj
swift upload src obj

# Preparing SERVICE_glance account
curl -X GET -H "X-Auth-Token: $GLANCE_TOKEN" http://saio:8080/v1/SERVICE_glance/
curl -X PUT -H "X-Auth-Token: $GLANCE_TOKEN" http://saio:8080/v1/SERVICE_glance/glance/
curl -X POST -H "X-Auth-Token: $GLANCE_TOKEN" -H "X-Container-Read: test:tester"  http://saio:8080/v1/SERVICE_glance/glance/
curl -X POST -H "X-Auth-Token: $GLANCE_TOKEN" -H "X-Container-Write: test:tester"  http://saio:8080/v1/SERVICE_glance/glance/

echo

# This should not work
curl -H "X-Auth-Token: $AUTH_TOKEN" http://saio:8080/v1/SERVICE_glance/glance/

echo

# This should work
curl -H "X-Auth-Token: $AUTH_TOKEN" -H "X-Service-Token: $GLANCE_TOKEN" http://saio:8080/v1/SERVICE_glance/glance/

echo

# This should not work
curl -i -X COPY -H "X-Auth-Token: $AUTH_TOKEN" -H "Destination: glance/obj" -H "Destination-Account: SERVICE_glance" http://127.0.0.1:8080/v1/AUTH_test/src/obj

echo

# This should work
curl -i -X COPY -H "X-Auth-Token: $AUTH_TOKEN" -H "X-Service-Token: $GLANCE_TOKEN" -H "Destination: glance/obj" -H "Destination-Account: SERVICE_glance" http://127.0.0.1:8080/v1/AUTH_test/src/obj
