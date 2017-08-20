#!/bin/bash -eux

sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tos-storage/g' /etc/hosts
hostnamectl set-hostname os-storage
# Need to configure cinder storage volume
# pvcreate --metadatasize 2048 physical_volume_device_path
# vgcreate cinder-volumes physical_volume_device_path