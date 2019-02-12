/*

Vars

Contains the several variable definitions used across all the terraform scripts

*/

##############################
## General config variables ##
##############################
variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "INGRESS_ALLOWED_IP" {}

variable "CUSTOM_NAME_SUFFIX" {
  default = "-demo"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "../keys/spark-emr"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "../keys/spark-emr.pub"
}
variable "INSTANCE_USERNAME" {
  default = "hadoop"
}

variable "JUPYPTER_USERNAME" {
  default = "ubuntu"
}

variable "AWS_REGION" {
  default = "us-east-2"
}

##############################
## Volume Related Variables ##
##############################
variable "DEFAULT_VOLUME_TYPE" {
  default = "gp2"
}

variable "STANDARD_VOLUME_SIZE" {
  default = "40"
}

variable "DEFAULT_ROOT_VOLUME_SIZE" {
  default = "30"
}

variable "WORKER_NODE_VOLUME_SIZE" {
  default = "20"
}


#################################
## Instances Related Variables ##
#################################
variable "INSTANCE_TYPES" {
  type = "map"
  default = {
    worker_node = "m4.large"
    master_node = "m4.large"
    jupyter-instance = "t2.medium"
  }
}


#################################
###      Tags variables       ###
#################################
variable "TAGS"{
  type = "map"
  default = {
    Team = "My team"
    Project = "My project"
    Owner = "Me"
    Environment = "POC"
  }
}

##############################
#### AMI Related Variables ###
##############################
variable "AMIS" {
  type = "map"
  default = {
    # Ubuntu 18.04 official
    us-east-2 = "ami-0f65671a86f061fcd"
    us-west-2 = "ami-0ac019f4fcb7cb7e6"
  }
}
