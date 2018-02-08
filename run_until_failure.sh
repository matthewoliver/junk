#!/bin/bash
export TMPDIR=/mnt/sdb1/tmp

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
  echo "n == $n"
  sleep 1
done

