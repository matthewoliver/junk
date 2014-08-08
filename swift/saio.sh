#!/bin/bash

UNIT_TESTS=1

sudo apt-get update
sudo apt-get install -y curl gcc memcached rsync sqlite3 xfsprogs \
                     git-core libffi-dev python-setuptools
sudo apt-get install -y python-coverage python-dev python-nose \
                     python-simplejson python-xattr python-eventlet \
                     python-greenlet python-pastedeploy \
                     python-netifaces python-pip python-dnspython \
                     python-mock

# Using loopback device
sudo mkdir /srv
sudo truncate -s 1GB /srv/swift-disk
sudo mkfs.xfs /srv/swift-disk

# Add to fstab
if [ grep -c "/srv/swift-disk" /etc/fstab -gt 0 ]
then
    sed -i 's|^/srv/swift-disk .*$|/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0|' /etc/fstab
else
    echo '/srv/swift-disk /mnt/sdb1 xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab
fi

# create the mountpoints 
sudo mkdir -p /mnt/sdb1
sudo mount /mnt/sdb1
sudo mkdir -p /mnt/sdb1/1 /mnt/sdb1/2 /mnt/sdb1/3 /mnt/sdb1/4
sudo chown ${USER}:${USER} /mnt/sdb1/*
for x in {1..4}; do sudo ln -s /mnt/sdb1/$x /srv/$x; done
sudo mkdir -p /srv/1/node/sdb1 /srv/2/node/sdb2 /srv/3/node/sdb3 /srv/4/node/sdb4 /var/run/swift
sudo chown -R ${USER}:${USER} /var/run/swift
# **Make sure to include the trailing slash after /srv/$x/**
for x in {1..4}; do sudo chown -R ${USER}:${USER} /srv/$x/; done

sudo cat << EOF >> /etc/setup_saio_mounts.sh
mkdir -p /var/cache/swift /var/cache/swift2 /var/cache/swift3 /var/cache/swift4
chown ${USER}:${USER} /var/cache/swift*
mkdir -p /var/run/swift
chown ${USER}:${USER} /var/run/swift
EOF

# get the code
cd $HOME; git clone https://github.com/openstack/python-swiftclient.git
cd $HOME/python-swiftclient; sudo python setup.py develop; cd -

git clone https://github.com/openstack/swift.git
cd $HOME/swift; sudo python setup.py develop; cd -

sudo pip install -r swift/test-requirements.txt

# setup rsync
sudo cp $HOME/swift/doc/saio/rsyncd.conf /etc/
sudo sed -i "s/<your-user-name>/${USER}/" /etc/rsyncd.conf
sudo sed -i 's/^RSYNC_ENABLE=.*$/RSYNC_ENABLE=true/' /etc/default/rsync
sudo service rsync restart

# Memcache
sudo service memcached start
sudo chkconfig memcached on

# Syslog
sudo cp $HOME/swift/doc/saio/rsyslog.d/10-swift.conf /etc/rsyslog.d/
sed -i  's/^$PrivDropToGroup .*/$PrivDropToGroup adm/' /etc/rsyslog.conf
sudo mkdir -p /var/log/swift
sudo chown -R syslog.adm /var/log/swift
sudo chmod -R g+w /var/log/swift
sudo service rsyslog restart

# Configure each node
sudo rm -rf /etc/swift

cd $HOME/swift/doc; sudo cp -r saio/swift /etc/swift; cd -
sudo chown -R ${USER}:${USER} /etc/swift

find /etc/swift/ -name \*.conf | xargs sudo sed -i "s/<your-user-name>/${USER}/"

# setup scripts for runnning swift
cd $HOME/swift/doc; cp -r saio/bin $HOME/bin; cd -
chmod +x $HOME/bin/*

# We are using loopback so...
sed -i "s/dev\/sdb1/srv\/swift-disk/" $HOME/bin/resetswift

# install sample configuration for running tests
cp $HOME/swift/test/sample.conf /etc/swift/test.conf
echo "export SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf" >> $HOME/.bashrc

# Add bin directory to PATH
echo "export PATH=${PATH}:$HOME/bin" >> $HOME/.bashrc
. $HOME/.bashrc

# Make the rings
$HOME/bin/remakerings

cat << EOF > $HOME/bin/swift_login.env
#!/bin/bash

#variables
# auth variables
storage_user="test:tester"
storage_password="testing"

# log in
auth_creds=( \$(curl -s -i -H "X-Storage-User: \$storage_user" -H "X-Storage-Pass: \$storage_password" http://127.0.0.1:8080/auth/v1.0 |egrep 'X-Auth-Token|X-Storage-Url' |awk '{print \$2}') )

export TOKEN="\$( echo \${auth_creds[1]} |tr -d '\r' |tr -d '\n' )"
export STORAGE_URL="\$( echo \${auth_creds[0]} |tr -d '\r' |tr -d '\n' )"
EOF
echo "source $HOME/bin/swift_login.env" >> $HOME/.bashrc
. $HOME/.bashrc


# Test rsync
echo -e "Testing Rsync\n================="
rsync rsync://pub@localhost/

if [ $UNIT_TESTS -eq 1 ]
then
    $HOME/swift/.unittests
fi

startmain

if [ $UNIT_TESTS -eq 1 ]
then
    $HOME/swift/.functests
    $HOME/swift/.probetests
fi

if [ $(ps -eaf |grep -c "\/swift") -le 1 ]
then
  $HOME/bin/startmain
  $HOME/bin/startrest
fi
exit 0