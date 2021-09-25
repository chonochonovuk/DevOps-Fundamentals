 #!/bin/bash
echo "* Install Software ..."
sudo apt-get update -y
sudo apt install -y apache2
sudo apt install -y php
sudo apt install -y php-mysqlnd

echo "* Start HTTP ..."
sudo systemctl enable apache2
sudo systemctl start apache2

echo "* Copy web site files to /var/www/html/ ..."
sudo rm /var/www/html/index.html
sudo cp /tmp/2/* /var/www/html