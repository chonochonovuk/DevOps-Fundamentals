FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install apache2 php7.1 libapache2-mod-php7.1 php7.1-mcrypt php7.1-cli php7.1-xml php7.1-zip php7.1-mysql php7.1-gd php7.1-imagick php7.1-recode php7.1-tidy php7.1-xmlrpc php-pear php7.1-dev openssl libgmp-dev libuv1 libuv1-dev wget libssl1.0.0

RUN pecl channel-update pecl.php.net
RUN wget http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.11.0/cassandra-cpp-driver-dbg_2.11.0-1_amd64.deb -P /tmp
RUN wget http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.11.0/cassandra-cpp-driver-dev_2.11.0-1_amd64.deb -P /tmp
RUN wget http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.11.0/cassandra-cpp-driver_2.11.0-1_amd64.deb -P /tmp

RUN dpkg -i /tmp/cassandra-cpp-driver_2.11.0-1_amd64.deb
RUN dpkg -i /tmp/cassandra-cpp-driver-dbg_2.11.0-1_amd64.deb
RUN dpkg -i /tmp/cassandra-cpp-driver-dev_2.11.0-1_amd64.deb

RUN pecl install cassandra

RUN echo 'extension=cassandra.so' >> /etc/php/7.1/apache2/php.ini 
RUN echo 'extension=cassandra.so' >> /etc/php/7.1/cli/php.ini 

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
