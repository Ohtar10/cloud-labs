/*

Security Groups

Contains the defined Security Groups

*/

resource "aws_security_group" "master-sg" {
  vpc_id = "${aws_vpc.spark-emr-main.id}"
  name = "master-sg"
  description = "security group that allows ingress traffic for some master resources"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 8088
    to_port = 8088
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 8042
    to_port = 8042
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 18080
    to_port = 18080
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    security_groups = ["${aws_security_group.public-sg.id}"]
  }

  tags {
    Name = "master-sg"
  }

}

resource "aws_security_group" "core-sg" {
  vpc_id = "${aws_vpc.spark-emr-main.id}"
  name = "core-sg"
  description = "security group that allows ingress traffic for some core machines"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  tags {
    Name = "core-sg"
  }
}

resource "aws_security_group" "public-sg" {
  vpc_id = "${aws_vpc.spark-emr-main.id}"
  name = "public-sg"
  description = "security group for public related services"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 8888
    to_port = 8888
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  ingress {
    from_port = 4040
    to_port = 4040
    protocol = "tcp"
    cidr_blocks = ["${var.INGRESS_ALLOWED_IP}"]
  }

  tags {
    Name = "public-sg"
  }
}