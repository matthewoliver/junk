cd ~/code/ceph/build/
../src/stop.sh 
#MON=1 MGR=1 ../src/vstart.sh --debug -n --localhost
MON=1 MGR=1 ../src/vstart.sh --debug -n -i 44.71.0.93
ceph mgr module enable cephadm
ceph orchestrator set backend cephadm
ceph orchestrator host add localhost
rm /tmp/q
#ceph orchestrator rgw add realm zone -i ../src/cephadm/samples/rgw_ssl.json 
