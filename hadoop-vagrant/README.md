# Hadoop Vagrant Lab

This laboratory shows how to configure a hadoop cluster from the scratch using vagrant machines
to simulate a cluster.

## Requirements
* Vagrant 2.0.3 or above
* Ansible 2.7.7 or above
* VirtualBox 5.2.26

## Packages
This lab uses the following software packages
* Apache Hadoop 3.2.0
* CentOS 7
* OpenJDK 1.8

## Usage
The scripts are capable of three flavors, single node, pseudo distributed and fully distributed
depending on the option you might want to tweak the Vagrantfile to edit the amount of hadoop
machines. 
You can control the amount of machines by editing this line in the Vagrantfile:
```
	# Change the number of iterations according to the amount of machines to use
		(1..4).each do |i|
```
Recommended values are:
* Single node: ```(1..1)```
* Pseudo distributed: ```(1..1)```
* Fully distributed: ```(1..5)``` (1 namenode, 2 secondary namenode and 3 workers)

### Vagrant
First, go to the vagrant folder, ensure you have ```vagrant-vbguest``` gem installed:
```
vagrant plugin install vagrant-vbguest
```

Then proceed to get the lab up
```
vagrant up
```

### Ansible
Now ssh into the control machine ```vagrant ssh control```, this machine makes part of the cluster
and is able to see all the machines, it will be able to execute commands in all the machines.
Then, proceed to prepare your laboratory.

First, ssh into the control machine
```
vagrant ssh control
```

Depending on the deployment type you want to use, first ensure you use the right ansible inventory
file by editing ```ansible/ansible.cfg``` and changing the host inventory file to use:
```
[defaults]
inventory=./hadoop-pseudo-distributed-inventory
host_key_checking = False
```
Check you have connectivity to all machines:
```
ansible -m ping all
```
Also, execute the playbook accordingly:
```
ansible-playbook setup.yml
```
```
ansible-playbook setup_pseudo_distributed.yml
```
```
ansible-playbook setup_fully_distributed.yml
```

### Hadoop
After this, you can ssh into any machine to the hadoop cluster and issue hdfs commands!

First, ssh into one of the hadoop members:
```
vagrant ssh hadoop1
```
Then become ```hduser```
```
# pass 'hduser' without quotes
[root@hadoop1 vagrant]# su hduser
```
Then, play around
```
hdfs dfs -ls /
hdfs dfsadmin -report
```
