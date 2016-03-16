test="$1"

count=1
while [ 1 -eq 1 ]
do
  nosetests $test
  res=$?
  echo count = $count
  if [ $res -gt 0 ]
  then
    break
  fi
  let "count+=1"
done
