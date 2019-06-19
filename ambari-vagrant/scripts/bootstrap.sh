#!/bin/bash

sudo apt-get -y update
sudo apt-get install -y python python-pip
pip install --upgrade pip
pip install ansible --user
sudo ln -s /home/ubuntu/.local/bin/ansible /usr/local/bin/ansible
sudo ln -s /home/ubuntu/.local/bin/ansible-playbook /usr/local/bin/ansible-playbook

