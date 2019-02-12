#!/usr/bin/env bash

suffix=$1
ec2_profile=$2
SUFFIX="${suffix:--demo}"

(cd ../terraform; terraform refresh)
AWS_EC2_PROFILE="${ec2_profile:-default}"

ansible_settings=$(cd ../terraform; terraform output ansible_settings)
ansible_jupyter_settings=$(cd ../terraform; terraform output ansible_jupyter_settings)
master_public_dns=$(cd ../terraform; terraform output master_public_dns)
jupyter_public_dns=$(cd ../terraform; terraform output jupyter_public_dns)

master_private_dns=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PrivateDnsName" \
 --filters "Name=tag:Name,Values=Spark-EMR-Lab${SUFFIX}" "Name=tag:aws:elasticmapreduce:instance-group-role,Values=MASTER" \
  --profile ${AWS_EC2_PROFILE:-"default"} --output text)

workers=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicDnsName" \
 --filters "Name=tag:Name,Values=Spark-EMR-Lab${SUFFIX}" "Name=tag:aws:elasticmapreduce:instance-group-role,Values=CORE" \
 --profile ${AWS_EC2_PROFILE:-"default"} --output text)


WORKERS_ARR=($workers)
for worker in "${WORKERS_ARR[@]}"
do
    workers_dns="$workers_dns$worker$ansible_settings \
    \n"
done


hdfs_url="hdfs://$master_private_dns:8020/"

#zk_ensamble="$master_private_dns:2181"

ansible-playbook refresh_inventory.yml --extra-vars " \
hdfs_url=$hdfs_url \
master_host='$master_public_dns$ansible_settings' \
core_hosts='$workers_dns' \
jupyter_host='$jupyter_public_dns$ansible_jupyter_settings'"

