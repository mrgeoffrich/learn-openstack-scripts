#!/bin/bash -eux

sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tos-deploy/g' /etc/hosts
hostnamectl set-hostname os-deploy
apt-get install -y aptitude bridge-utils build-essential git ntp ntpdate openssh-server python-dev sudo
git clone -b 15.1.7 https://github.com/openstack/openstack-ansible.git /opt/openstack-ansible
cd /opt/openstack-ansible
scripts/bootstrap-ansible.sh
