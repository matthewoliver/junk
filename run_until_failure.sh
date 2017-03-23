#!/bin/bash

n=0
while [ True ]
do 
  clear
  $@
  if [ $? -gt 0 ]
  then 
    echo 'ERROR'
    echo "number " $n
    break
  fi
  let "n=n+1"
  sleep 1
done

