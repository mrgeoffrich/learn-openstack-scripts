#!/bin/bash -eux

hostnamectl set-hostname deploy
cd ~
mkdir Repos
cd Repos
git clone -b stable/ocata https://github.com/openstack/openstack-ansible.git