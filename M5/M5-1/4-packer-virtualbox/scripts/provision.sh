#!/bin/bash

# Iinstall EPEL, kernel, gcc, etc.
yum install -y epel-release kernel-devel gcc make tar bzip2 wget elfutils-libelf-devel

# Install VirtualBox add-ons
mount $(ls /home/vagrant/VBoxGuestAdditions*.iso) /mnt
/mnt/VBoxLinuxAdditions.run
usermod -aG vboxsf vagrant

# Prepare the insecure key
mkdir -m 0700 -p /home/vagrant/.ssh

wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys

chmod 0600 /home/vagrant/.ssh/authorized_keys

chown vagrant:vagrant -R /home/vagrant/.ssh