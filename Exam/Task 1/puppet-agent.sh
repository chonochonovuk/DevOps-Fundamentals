#!/bin/bash

echo "192.168.89.100 web.dof.lab web" >> /etc/hosts
echo "192.168.89.101 db.dof.lab db" >> /etc/hosts

echo " *** Install Puppet Agent ****"

wget https://apt.puppetlabs.com/puppet6-release-focal.deb
sudo dpkg -i puppet6-release-focal.deb
sudo apt-get update
sudo apt-get install -y puppet-agent
