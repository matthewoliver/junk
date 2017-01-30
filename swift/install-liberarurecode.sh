#!/bin/bash

sudo apt-get install build-essential autoconf automake libtool
#sudo yum install -y gcc make autoconf automake libtool

cd $HOME
git clone https://github.com/openstack/liberasurecode
cd liberasurecode

./autogen.sh
./configure
make
sudo make install
