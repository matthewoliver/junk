#!/bin/bash

if [ $(egrep -c '^pipeline.*tempauth' /etc/swift/proxy-server.conf) -eq 1 ]
then
  echo tempauth
  exit
fi

if [ $(egrep -c '^pipeline.*keystoneauth' /etc/swift/proxy-server.conf) -eq 1 ]
then
  echo keystone
  exit
fi

if [ $(egrep -c '^pipeline.*auth' /etc/swift/proxy-server.conf) -eq 0 ]
then
  echo No Auth
  exit
fi
