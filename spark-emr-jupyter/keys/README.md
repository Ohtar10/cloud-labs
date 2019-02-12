The terraform and ansible scripts expects to find under this directory your
private and public keys named 'spark-emr' and 'spark-emr.pub' respectively.

You can generate them as follows

```
ssh-keygen -t rsa -b 4096 -f ./keys/spark-emr
```
