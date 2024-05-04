# Pulumi Libvirt K8s Lab

## Disclaimer
This it not in working state. There is a problem setting up shared folders within the VMS, which is a hard requirement for this project. There is no easy-to-setup solution for this. The FileSystem element doesn't work and prevents machines to acquire an ip which blocks the whole process.

The alternative would be to provision a shared file system and make it available withing the nodes, the nodes should be able to reach the host, so it should be possible to mount the shared file system from the host to the guests. No room for this for now.

OS packages requirements:
- genisoimage

Edit /etc/libvirt/qemu.conf, set security_driver="none"

##### Notes
- Don't use esternal drives for sotrage pool

#### References
- https://www.pulumi.com/registry/packages/libvirt/
