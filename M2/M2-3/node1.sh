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
      addresses: [192.168.99.101/24]
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

echo "* Initialize Kubernetes cluster ..."
sudo kubeadm init --apiserver-advertise-address=192.168.99.101 --pod-network-cidr=10.244.0.0/16

echo "* Copy configuration for vagrant ..."
mkdir -p /home/vagrant/.kube
sudo chown vagrant:vagrant /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config

echo "* Copy configuration for root ..."
mkdir -p /root/.kube
sudo chown root:root /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
sudo chown root:root /root/.kube/config

echo "* Install POD network plugin (Calico) ..."
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
wget https://docs.projectcalico.org/manifests/custom-resources.yaml -O /tmp/custom-resources.yaml
sed -i 's/192.168.0.0/10.244.0.0/g' /tmp/custom-resources.yaml
kubectl create -f /tmp/custom-resources.yaml

echo "* Install Dashboard ..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

echo "* Create Dashboard admin user ..."
cat << EOF > /vagrant/dashboard-admin-user.yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF

echo "* Create Dashboard admin user role ..."
cat << EOF > /vagrant/dashboard-admin-role.yml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

echo "* Add both the user and role ..."
kubectl apply -f /vagrant/dashboard-admin-user.yml
kubectl apply -f /vagrant/dashboard-admin-role.yml

echo "* Save the user token ..."
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}') > /vagrant/admin-user-token.txt

echo "* Create custom token ..."

echo $(kubeadm token create --print-join-command) > /vagrant/test.txt