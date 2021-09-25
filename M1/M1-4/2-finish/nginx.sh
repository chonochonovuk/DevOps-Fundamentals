#!/bin/sh 
yum install -y nginx
chkconfig nginx on
service nginx start
echo '<h1>Hello from NGINX running on AWS EC2 instance</h1>' > /usr/share/nginx/html/index.html