#!/bin/bash

# Refactor these into loops

# Create all images using packer
packer build --only=virtualbox-ovf multinode-deploy.json
packer build --only=virtualbox-ovf multinode-compute.json
packer build --only=virtualbox-ovf multinode-controller.json
packer build --only=virtualbox-ovf multinode-infrastructure.json
packer build --only=virtualbox-ovf multinode-network.json
packer build --only=virtualbox-ovf multinode-storage.json

# Import VMs
VBoxManage import ./virtualbox/os-deploy/os-deploy.ovf
VBoxManage import ./virtualbox/os-compute/os-compute.ovf
VBoxManage import ./virtualbox/os-controller/os-controller.ovf
VBoxManage import ./virtualbox/os-infrastructure/os-infrastructure.ovf
VBoxManage import ./virtualbox/os-network/os-network.ovf
VBoxManage import ./virtualbox/os-storage/os-storage.ovf

# Have this passed in as a command line argument
BRIDGE_ADAPTER='en0: Wi-Fi (AirPort)'

# Configure networking
VBoxManage modifyvm "os-deploy" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all
VBoxManage modifyvm "os-compute" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all
VBoxManage modifyvm "os-controller" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all
VBoxManage modifyvm "os-infrastructure" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all
VBoxManage modifyvm "os-network" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all
VBoxManage modifyvm "os-storage" --nic1 bridged --bridgeadapter1 'en0: Wi-Fi (AirPort)' --nicpromisc1 allow-all

# Start up VMs. Note: might want to add a pause between each machine starting.
VBoxManage startvm "os-deploy"
VBoxManage startvm "os-compute"
VBoxManage startvm "os-controller"
VBoxManage startvm "os-infrastructure"
VBoxManage startvm "os-network"
VBoxManage startvm "os-storage"

echo 'Now run multinode-config/configure.py to configure your environment for a deployment.'