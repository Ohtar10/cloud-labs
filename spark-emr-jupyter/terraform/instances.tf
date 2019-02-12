

resource "aws_instance" "jupyter-instance" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "${var.INSTANCE_TYPES["jupyter-instance"]}"
  key_name = "${aws_key_pair.spark-emrlab-key.id}"

  vpc_security_group_ids = ["${aws_security_group.public-sg.id}", "${aws_security_group.master-sg.id}"]

  subnet_id = "${aws_subnet.spark-emr-main-public.id}"

  tags {
    Name = "Jupyter Server (LF)"
    Description = "Jupyter Server Machine."
    Team = "${var.TAGS["Team"]}"
    Project = "${var.TAGS["Project"]}"
    Owner = "${var.TAGS["Owner"]}"
    Environment = "${var.TAGS["Environment"]}"
  }
}