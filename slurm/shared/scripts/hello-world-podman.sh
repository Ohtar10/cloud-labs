#!/bin/bash

#SBATCH -N1 -n1 --mem-per-cpu=100M -t00:10:00 --qos=normal
#SBATCH -J hello-world-podman

podman container run --rm -v /shared/scripts/:/scripts alpine sh /scripts/hello-world.sh

exit $?
