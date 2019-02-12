
output "master_public_dns" {
  value = "${aws_emr_cluster.spark-emr-lab.master_public_dns}"
}

output "jupyter_public_dns" {
  value = "${aws_instance.jupyter-instance.public_dns}"
}

output "ansible_settings" {
  value = "\tansible_ssh_private_key_file=${var.PATH_TO_PRIVATE_KEY}\tansible_user=${var.INSTANCE_USERNAME}"
}

output "ansible_jupyter_settings" {
  value = "\tansible_ssh_private_key_file=${var.PATH_TO_PRIVATE_KEY}\tansible_user=${var.JUPYPTER_USERNAME}"
}
