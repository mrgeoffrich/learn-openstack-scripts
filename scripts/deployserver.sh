#!/bin/bash -eux

sudo sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tdeploy/g' /etc/hosts
hostnamectl set-hostname deploy
cd ~
mkdir Repos
cd Repos
git clone -b stable/ocata https://github.com/openstack/openstack-ansible.git