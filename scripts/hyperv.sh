#!/bin/bash -eux

apt-get update
apt-get install -y --install-recommends linux-virtual-lts-xenial
apt-get install -y --install-recommends linux-tools-virtual-lts-xenial linux-cloud-tools-virtual-lts-xenial

echo "UseDNS no" >> /etc/ssh/sshd_config
# Fix for blank screen on hyper-v display
TARGET_KEY='GRUB_CMDLINE_LINUX_DEFAULT'
REPLACEMENT_VALUE='"nomodeset"'
CONFIG_FILE=/etc/default/grub
sed -i "s/\($TARGET_KEY *= *\).*/\1$REPLACEMENT_VALUE/" $CONFIG_FILE
update-grub
