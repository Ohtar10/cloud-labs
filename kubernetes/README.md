# Kubernetes - Vagrant lab

This is a simple Kubernetes lab on top of vagrant virtual machines using virtualbox. Once the cluster is up and running it is an out of the box usable k8s cluster.

## Requirements
* Virtualbox 6.x.x
* Vagrant 2.2.x
* Ansible 2.9.x
* At least 6144GB of RAM available

## Setup
Simply go to the vagrant folder and execute `vagrant up`. The tools will do the rest.

## Customization
You can change some environment settings in `./vagrant/config.yaml`:

```yaml
configs:
    box_image: 'ubuntu/focal64'
    manager_name: 'manager'
    manager_memory: 2048
    manager_cpus: 2
    worker_name: 'node'
    workers: 2
    worker_memory: 2048
    worker_cpus: 4
```