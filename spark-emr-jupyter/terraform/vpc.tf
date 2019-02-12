/*

VPC

Contains the defined VPC and subnets

*/

# Internet VPC
resource "aws_vpc" "spark-emr-main" {
    cidr_block = "172.32.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "spark-emr-main${var.CUSTOM_NAME_SUFFIX}"
    }
}

# Subnets
resource "aws_subnet" "spark-emr-main-public" {
    vpc_id = "${aws_vpc.spark-emr-main.id}"
    cidr_block = "172.32.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.AWS_REGION}a"

    tags {
        Name = "spark-emr-main-public${var.CUSTOM_NAME_SUFFIX}"
    }
}

# Internet GW
resource "aws_internet_gateway" "spark-emr-main-gw" {
    vpc_id = "${aws_vpc.spark-emr-main.id}"

    tags {
        Name = "spark-emr-main-gw${var.CUSTOM_NAME_SUFFIX}"
    }
}

# route tables
resource "aws_route_table" "spark-emr-main-public-rt" {
    vpc_id = "${aws_vpc.spark-emr-main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.spark-emr-main-gw.id}"
    }

    tags {
        Name = "spark-emr-main-public${var.CUSTOM_NAME_SUFFIX}"
    }
}

# route associations public traffic
resource "aws_route_table_association" "spark-emr-main-public-ar" {
    subnet_id = "${aws_subnet.spark-emr-main-public.id}"
    route_table_id = "${aws_route_table.spark-emr-main-public-rt.id}"
}
