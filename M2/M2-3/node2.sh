#!/usr/bin/bash

echo "* Add hosts ..."
echo "192.168.99.101 node1.k8s node1" >> /etc/hosts
echo "192.168.99.102 node2.k8s node2" >> /etc/hosts

echo " Assign Static Ip Address in /etc/netplan/00-installer-config.yaml"

sudo tee /etc/netplan/00-installer-config.yaml<<EOF
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses: [192.168.99.102/24]
  version: 2
EOF

sudo netplan apply

echo "* Update the apt package index and install packages to allow apt to use a repository over HTTPS"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

echo "* Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "* set up the stable repository"
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 

echo "* Install Docker ..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "* Enable and start Docker ..."
sudo systemctl enable docker
sudo systemctl start docker

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant 

echo " **** Get kubernetes repo key....."
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo " **** Add kubernetes repo to manifest .... "
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo " **** Install kubeadm, kubectl, kubelet"
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

echo " **** Turn off swap ..."
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo tee -a /etc/ufw/sysctl.conf<<EOF
net/bridge/bridge-nf-call-ip6tables = 1
net/bridge/bridge-nf-call-iptables = 1
net/bridge/bridge-nf-call-arptables = 1
EOF

echo "* Start Kubernetes ..."
sudo systemctl enable kubelet
sudo systemctl start kubelet

echo "* Join the worker node (node-2) ..."
sudo bash /vagrant/test.txt
