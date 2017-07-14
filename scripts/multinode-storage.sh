#!/bin/bash -eux

sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tos-storage/g' /etc/hosts
hostnamectl set-hostname os-storage
apt-get install -y aptitude build-essential git ntp ntpdate openssh-server python-dev sudo
