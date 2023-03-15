# Vagrant Slurm

## Requirements
- Vagrant v>=2.3.4
- vagrant-hostmanager v>=1.8.9

## Deploy
```bash
cd vagrant
vagrant up
```

## Post-Setup

### Restart Slurmctld
Sometimes `slurmctld` starts before `slurmdbd` which will cause the former to fail to start successfully.

```bash
vagrant ssh controller
vagrant@controller:~$ sudo systemctl restart slurmctld
```
### Create Accounting Information
```bash
vagrant ssh controller
# Add global account
vagrant@controller:~$ sudo -u slurm sacctmgr add account test,other Cluster=slurm-vagrant Description="Slurm Accounts" Organization="TEST"
# Add users to account
vagrant@controller:~$ sudo -u slurm sacctmgr add user aragorn Account=test
# Add qos queues
vagrant@controller:~$ sudo -u slurm sacctmgr add qos high
# Assign priority to queue
vagrant@controller:~$ sudo -u slurm sacctmgr modify qos high set priority=10
```

## Usage
### Submit a basic job
```bash
vagrant ssh controller
vagrant@controller:~$ sudo su aragorn
aragorn@controller:~$ sbatch /shared/scripts/hello-world.sh
```
### Request Interactive Session
#### Via `srun --pyt` directly
```bash
vagrant ssh controller
vagrant@controller:~$ sudo su aragorn
aragorn@controller:~$ srun --account test --job-name "srun-interactive" --cpus-per-task 2 --mem-per-cpu 100m --time 01:00:000 --pty bash
```
#### Via `salloc`
```bash
vagrant ssh controller
vagrant@controller:~$ sudo su aragorn
# Request and allocate the resources when available
aragorn@controller:~$ salloc --account test --job-name "srun-interactive" --cpus-per-task 2 --mem-per-cpu 100m --time 01:00:000
# Use srun --pty to allocate an interactive terminal in the allocated resource.
aragorn@controller:~$ srun --pty bash
```

### References
- [QoS](https://slurm.schedmd.com/qos.html)
- [Accounting](https://slurm.schedmd.com/accounting.html)
- [GRES](https://slurm.schedmd.com/gres.html)