# Spark + Jupyter, EMR Lab

These are a set of terraform/ansible/bash scripts to setup an Amazon EMR lab. It consist on the following:

## Terraform scripts
In folder ./terraform you will find all the necessary infrastucture scripts to setup the infrastructure
on your aws account.

## Ansible playbooks
In folder ./ansible, after creating the infrastructure with terraform, these playbooks can be used
to further provision and configure additional stuff in your cluster.

## Keys
In folder ./keys, are the ssh keys used to communicate with the infrastructure deployed in amazon.

## Resources
In folder ./resources, goes additional resources that will be uploaded to the machines according
to the corresponding playbooks.

