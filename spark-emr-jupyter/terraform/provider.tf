/*

Provider

Contains the defined providers

*/

provider "aws" {
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}

/*
terraform {
    backend "s3" {
        bucket = "emr-labs"
        key = "spark-emrlab/terraform/spark-emrlab-key.tfstate"
        region = "us-west-2"
        access_key = "YOUR_AWS_ACCESS_KEY"
        secret_key = "YOUR_AWS_SECRET_KEY"
    }
}

data "terraform_remote_state" "aws-state" {
    backend = "s3"
    config {
        bucket = "emr-labs"
        key = "spark-emrlab/terraform/spark-emrlab-key.tfstate"
        access_key = "${var.AWS_ACCESS_KEY}"
        secret_key = "${var.AWS_SECRET_KEY}"
        region = "us-west-2"
    }
}

*/