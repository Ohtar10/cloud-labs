# Docker swarm - Vagrant lab

This is a simple docker swarm lab on top of vagrant virtual machines using virtualbox. Once the cluster is up and running it is an out of the box usable swarm cluster.

## Requirements
* Virtualbox 6.x.x
* Vagrant 2.2.x
* Ansible 2.9.x
* At least 4096GB of RAM available

## Setup
Simply go to the vagrant folder and execute `vagrant up`. The tools will do the rest.

## Customization
You can change some environment settings in `./vagrant/config.yaml`:

```yaml
configs:
    manager_name: 'manager'
    manager_memory: 1024
    worker_name: 'node'
    workers: 3
    worker_memory: 1024
    docker:
        install_channel: stable test
```