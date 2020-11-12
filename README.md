# cloud-labs
This is a set of docker/ansible/terraform/aws recipies for different kind of deployments, e.g., Jupyter, Zeppelin, EMR, Big Data Infrastructure, etc.

## Contents

### spark-emr-jupyter
It's an example of deploying an EMR spark cluster on aws with a custome instance serving as jupyter server.
I connects both by getting the EMR hadoop configuration files.

### hadoop-vagrant
It's a full laboratory setting up a hadoop cluster from scratch on a set of vagrant machines. It has very basic configuration, no security and no tuning.

### spark-hadoop-vagrant
Based on hadoop-vagrant lab, includes installing Apache Spark in all the nodes

### spark-livy-docker
Contains the Dockerfiles for Apache Spark and Apache Livy docker images as well as a docker-compose file to deloy a local only solution

### mlflow-demo
Contains a simple configuration for running mlflow experiments in local mode and in a simulated remote tracking server fashion.

### swarm
Contains a fully functional docker swarm cluster based in vagrant virtual
machines.