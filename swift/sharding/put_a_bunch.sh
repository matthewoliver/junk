if [ -n $1 ]
then
  resetswift
  swift-init start main
  . ~/swift_auth.env
  . ~/swiftclient.env
fi


curl -i -H "X-Auth-Token: $TOKEN" $STORAGE_URL/shardme -X PUT -H "X-Container-Sharding: on"


for x in a b c d e f g h i j k l m n o p q r s t u v w x y z; do for y in 1 2 3 4 5 6 7 8 9 0; do curl -i -H "X-Auth-Token: $TOKEN" $STORAGE_URL/shardme/$x$y -X PUT --data-binary ""; done; done
