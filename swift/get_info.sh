#!/bin/bash
count=$(find /mnt/sdb1/ -name "*.db" |grep container | wc -l)
i=0
for cont in $(find /mnt/sdb1/ -name "*.db" |grep container)
do
  let "i+=1"
  echo "Path: $cont"
  echo "size: $(du -sh $cont |awk '{print $1}')"
  swift-container-info $cont |grep -A 3 'Path:'
  swift-container-info $cont |grep -A 11 '^Metadata:'
  swift-container-info $cont |grep 'System Metadata:'
  echo "Pivot_ranges"
  sqlite3 $cont 'select * from pivot_ranges;'
  echo "DB $i/$count"; echo
  read
done
