/*

EMR

Contains the defined EMR configurations

*/

resource "aws_key_pair" "spark-emrlab-key" {
  key_name = "spark-emrlabkey${var.CUSTOM_NAME_SUFFIX}"
  public_key = "${file("${var.PATH_TO_PUBLIC_KEY}")}"
}

resource "aws_emr_cluster" "spark-emr-lab" {

  name = "spark-emr-lab${var.CUSTOM_NAME_SUFFIX}"
  release_label = "emr-5.10.0"
  service_role = "${aws_iam_role.iam_spark-emr_service_role.arn}"
  ebs_root_volume_size = "${var.WORKER_NODE_VOLUME_SIZE}"
  master_instance_type = "${var.INSTANCE_TYPES["master_node"]}"
  core_instance_count = 3
  core_instance_type = "${var.INSTANCE_TYPES["worker_node"]}"
  log_uri = "s3://emr-labs/spark-emrlab/logs"
  applications = ["Hadoop", "Spark", "Hive", "Ganglia", "Livy"]

  ec2_attributes {
    instance_profile = "${aws_iam_instance_profile.spark-emr_profile.arn}"
    key_name = "${aws_key_pair.spark-emrlab-key.key_name}"
    subnet_id = "${aws_subnet.spark-emr-main-public.id}"
    additional_master_security_groups = "${aws_security_group.master-sg.id}"
    additional_slave_security_groups = "${aws_security_group.core-sg.id}"
  }

  tags {
    Name = "Spark-EMR-Lab${var.CUSTOM_NAME_SUFFIX}"
    Description = "Apache Spark EMR lab"
    Versions = "Spark 2.2.0"
    Team = "${var.TAGS["Team"]}"
    Project = "${var.TAGS["Project"]}"
    Owner = "${var.TAGS["Owner"]}"
    Environment = "${var.TAGS["Environment"]}"
    Auto_stop = "${var.TAGS["Auto_stop"]}"
    Auto_terminate = "${var.TAGS["Auto_terminate"]}"
    maid_status = "${var.TAGS["maid_status"]}"
  }

}
