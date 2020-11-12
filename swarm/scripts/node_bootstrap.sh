#!/bin/bash

DOCKER_INSTALL_CHANNELS="stable"
while [ ! $# -eq 0 ]
do
    case "$1" in
            --test-channel | -tc)
                    DOCKER_INSTALL_CHANNELS="stable test"
                    ;;
    esac
    shift
done

sudo apt update
# Install general basic tools
sudo apt install -y ansible nano

# Install docker
sudo apt-get -y remove docker docker-engine docker.io containerd runc
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   ${DOCKER_INSTALL_CHANNELS}"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant

# Join this node to the cluster
/shared/docker-swarm-join.sh