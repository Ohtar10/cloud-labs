#!/bin/bash

#SBATCH -N1 -n1 --mem-per-cpu=100M -t00:10:00 --qos=normal
#SBATCH -J hello-world

printf "Hello World Slurm! running from host: %s\n" $(hostname)

exit $?
