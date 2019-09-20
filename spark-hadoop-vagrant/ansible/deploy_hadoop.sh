#!/bin/bash

ansible-playbook \
-e var_java_home=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.222.b10-0.el7_6.x86_64 \
-e var_create_user=False \
-e var_apps_home=/home/${USER}/software \
-e var_user_name=${USER} \
setup_hadoop_fully_distributed.yml \
--start-at-task "Ensure Java 1.8 Devel and tools are installed"