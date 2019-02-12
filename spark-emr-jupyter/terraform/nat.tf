/*

NAT

Contains the defined NAT gateways

*/

# nat gw
resource "aws_eip" "spark-emr-nat" {
  vpc      = true
}
resource "aws_nat_gateway" "spark-emr-nat-gw" {
  allocation_id = "${aws_eip.spark-emr-nat.id}"
  subnet_id = "${aws_subnet.spark-emr-main-public.id}"
  depends_on = ["aws_internet_gateway.spark-emr-main-gw"]
}

# VPC setup for NAT
resource "aws_route_table" "spark-emr-main-private-rt" {
    vpc_id = "${aws_vpc.spark-emr-main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.spark-emr-nat-gw.id}"
    }

    tags {
        Name = "spark-emr-main-private-rt"
    }
}
