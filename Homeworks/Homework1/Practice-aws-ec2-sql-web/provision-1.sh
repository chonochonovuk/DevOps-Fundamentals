#!/bin/bash
echo "* Install Software ..."
sudo apt-get update -y
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo apt-get install -y mariadb-server

echo "* Start Mariadb ..."
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "* Create and load the database ..."
sudo mysql -u root < /tmp/1/db_setup.sql

echo "Bind port set to 0.0.0.0"
sudo cp /tmp/1/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

echo "* Restart MariaDB"
sudo systemctl restart mariadb