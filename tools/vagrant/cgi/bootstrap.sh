#!/bin/bash

# install wget for the next action
sudo yum -y install wget

# download Java
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm"

# install Java
sudo yum -y localinstall jdk-8u131-linux-x64.rpm

# elasticsearch GPG key
sudo rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

# create the elasticsearch yum repo
echo '[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1' | sudo tee /etc/yum.repos.d/elasticsearch.repo

# install elasticsearch
sudo yum -y install elasticsearch

# start elasticsearch on boot
#if using System V (check with ps -p 1)
    sudo chkconfig elasticsearch on
#elseif using systemd
#    sudo /bin/systemctl daemon-reload
#    sudo /bin/systemctl enable elasticsearch.service
#fi

# allow host OS to access through port forwarding
sudo echo "
network.bind_host: 0
network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml
sudo sed -i -e '$a\' /etc/elasticsearch/elasticsearch.yml

# create the kibana repo
echo '[kibana-4.6]
name=Kibana repository for 4.6.x packages
baseurl=https://packages.elastic.co/kibana/4.6/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1' | sudo tee /etc/yum.repos.d/kibana.repo

# install kibana
sudo yum -y install kibana

#start kibana on boot
#if using System V (check with ps -p 1)
    sudo chkconfig --add kibana
#elseif using systemd
#    sudo /bin/systemctl daemon-reload
#    sudo /bin/systemctl enable kibana.service
#fi