#!/bin/bash

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

dnf install -y bash-completion docker-ce docker-ce-cli

mkdir -p /etc/docker
echo '{ "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"] }' | tee /etc/docker/daemon.json
mkdir -p /etc/systemd/system/docker.service.d/
echo [Service] | tee /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart= | tee -a /etc/systemd/system/docker.service.d/docker.conf
echo ExecStart=/usr/bin/dockerd | tee -a /etc/systemd/system/docker.service.d/docker.conf

usermod -aG docker vagrant

systemctl enable --now docker

firewall-cmd --add-interface docker0 --zone trusted --permanent
firewall-cmd --add-port 8080/tcp --permanent
firewall-cmd --add-port 5000/tcp --permanent
firewall-cmd --add-port 5601/tcp --permanent
firewall-cmd --add-port 9200/tcp --permanent
firewall-cmd --add-port 9300/tcp --permanent
firewall-cmd --reload


curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
