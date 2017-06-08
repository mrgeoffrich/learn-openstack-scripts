#!/bin/bash -eux

SSH_USERNAME=${SSH_USERNAME:-vagrant}

function install_open_vm_tools {
    echo "==> Installing Open VM Tools"
    # Install open-vm-tools so we can mount shared folders
    apt-get install -y open-vm-tools
    # Add /mnt/hgfs so the mount works automatically with Vagrant
    mkdir /mnt/hgfs
}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    KERNEL_VERSION=$(uname -r | cut -d. -f1-2)
    echo "==> Kernel version ${KERNEL_VERSION}"
    MAJOR_VERSION=$(echo ${KERNEL_VERSION} | cut -d '.' -f1)
    MINOR_VERSION=$(echo ${KERNEL_VERSION} | cut -d '.' -f2)
    # open-vm-tools supports shared folders on kernel 4.1 or greater
    . /etc/lsb-release
    install_open_vm_tools
fi