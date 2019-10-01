#!/bin/bash

# Install Ansible
sudo yum update -y 
sudo yum install -y epel-release 
sudo yum install -y ansible nano unzip

if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi

cp /home/vagrant/.ssh/id_rsa.pub /keys/control.pub

cat << 'SSHEOF' > /home/vagrant/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
SSHEOF

chown -R vagrant:vagrant /home/vagrant/.ssh/