#!/usr/bin/env bash

(cd terraform; terraform apply -auto-approve)

(cd ansible; ./refresh-inventory && ansible-playbook _1_pre_setup.yml && ansible-playbook _2_prepare_hadoop_conf.yml)
