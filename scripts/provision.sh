#!/usr/env/bin bash
# Installs pyton3 form source
# usage: provision.sh <python_ver> e.g. provision 3.7.3

if [ "$1" == "" ]; then
    echo "error: no python version provided. usage: provision.sh <version>"
    exit 1
else
    export PVER="$1"
fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get clean
sudo apt-get update

# install/update prerequisites 
sudo apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget

pushd /tmp

# download python source
wget -q "https://www.python.org/ftp/python/${PVER}/Python-${PVER}.tar.xz"

# build python
tar -xf "Python-${PVER}.tar.xz"
pushd "Python-${PVER}"
./configure --enable-optimizations

make -j 1 # one CPU machine
sudo -H make altinstall # do not overwrite the system default python3 binnary

sudo chown -R vagrant:vagrant /home/vagrant/.local # fix local python3 dir permissions for vagrant user

# clean up

sudo apt-get clean
sudo rm -rf /tmp/* 

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

# Zero out the free space to save space in the final image:
echo "Zeroing device to make space..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
