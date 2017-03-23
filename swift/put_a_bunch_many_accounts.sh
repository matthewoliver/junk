#!/bin/bash
# this assumes no tempauth in your proxy pipeline.

proxy_path=${1:-http://localhost:8080/v1}
for acc in  a a1 a2 a3 a4 a5 a6 a7 a8 a9
do
  curl -i $proxy_path/$acc -X PUT
  echo "$proxy_path/$acc"
  for cont in c c1 c2 c3 c4 c5 c6 c7 c8 c9
  do
    curl -i $proxy_path/$acc/$cont -X PUT
    for obj in o o1 o2 o3 o4 o5 o6 o7 o8 o9
    do
      curl -i $proxy_path/$acc/$cont/$obj -X PUT --data-binary "/$acc/$cont/$obj"
    done
  done
done
