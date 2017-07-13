#!/bin/bash -eux

sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tos-network/g' /etc/hosts
hostnamectl set-hostname os-network
