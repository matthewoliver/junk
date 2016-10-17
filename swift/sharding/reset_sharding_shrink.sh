#!/bin/bash

resetswift
swift-init start main
#swift-init start all
#swift-init stop container-sharder
. put_a_bunch.sh

#tail -f /tmp/q &
#swift-init stop container-replicator account-replicator
