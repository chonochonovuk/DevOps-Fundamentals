#!/bin/bash

echo '* Update repositories'
sudo apt-get update

echo '* Install NGINX'
sudo apt-get install -yq nginx
