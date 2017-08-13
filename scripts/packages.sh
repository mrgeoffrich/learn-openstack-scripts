#!/bin/bash -eux

apt -y update && apt-get -y upgrade
apt -y install software-properties-common git wget curl vim nfs-common dkms