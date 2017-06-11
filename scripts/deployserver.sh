#!/bin/bash -eux

sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tdeploy/g' /etc/hosts
hostnamectl set-hostname deploy
apt-get install -y aptitude build-essential git ntp ntpdate openssh-server python-dev sudo
git clone -b stable/ocata https://github.com/openstack/openstack-ansible.git /opt/openstack-ansible
cd /opt/openstack-ansible
scripts/bootstrap-ansible.sh