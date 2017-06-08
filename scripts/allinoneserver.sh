#!/bin/bash -eux

sudo sed -i 's/127\.0\.1\.1\tvagrant\.vm\tvagrant/127\.0\.1\.1\tallinone/g' /etc/hosts
hostnamectl set-hostname allinone
