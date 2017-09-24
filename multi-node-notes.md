# 3 Node OpenStack installation

* Deploy - Performs the openstack deployment using openstack-ansible.
* Infrastructure - MySQL, RabbitMQ, HAProxy, Memcache. All openstack controller software, including keystone, horizon, nova, heat.
* Compute - Openstack compute node, runs the VMs.
* Storage - Runs cinder and swift storage, iSCSI block storage.

| Network                | CIDR              | VLAN |
|------------------------|-------------------|------|
| Management Network     | 172.29.236.0/22   | 10   |
| Tunnel (VXLAN) Network | 172.29.240.0/22	 | 30   |
| Storage Network        | 172.29.244.0/22	 | 20   |
| Host Network           | 192.168.0.0/16    | -    |

| Host name	       |  Management IP	 |Tunnel (VxLAN) IP | Storage IP   |Host Network IP |
|------------------|-----------------|------------------|--------------|----------------|
|os-deploy         |  172.29.236.16  |                  |              | 192.168.0.20   |
|os-infrastructure |  172.29.236.11	 | 	                |              | 192.168.0.24   |
|os-compute        |  172.29.236.12	 | 172.29.240.12	| 172.29.244.12| 192.168.0.21   |
|os-storage        |  172.29.236.13	 |                  | 172.29.244.13| 192.168.0.23   |

## Use packer to provision the base machines.

Have a python script generate the network configuration files and the openstack-ansible yaml files
required for installation. Static IP addresses should be assigned here, to be passed in to the script
when it's run.

The python script will also validate particular things to make sure the environment is ready
to have an installation done.

Once the python script is successful, tell the user where to SSH to and what commands to run to begin the
installation.

## Remaining steps

### I manually added a second hard drive to os-storage
```
sudo fdisk /dev/sdb
n for new
p for primary partition
1 for first partition
enter twice to select default start and end sectors
t to change type
8e to select LVM
p to confirm setup
w to write and exit
```

### Then
```
pvcreate /dev/sdb1
vgcreate cinder-volumes /dev/sdb1
```

### Setup SSH keys so ansible can access other servers.
SSH on to os-deploy, sudo su

copy all the os-deploy:/root/.ssh/ contents to all other servers


Copy the contents of the /opt/openstack-ansible/etc/openstack_deploy directory to the /etc/openstack_deploy directory.
Upload openstack_user_config.yml to /etc/openstack_deploy
cd /opt/openstack-ansible/scripts
python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
cd /opt/openstack-ansible/playbooks
openstack-ansible setup-infrastructure.yml --syntax-check # Checks the openstack_user_config.yml is openstack
openstack-ansible setup-hosts.yml
openstack-ansible setup-infrastructure.yml
ansible galera_container -m shell -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"
openstack-ansible setup-openstack.yml