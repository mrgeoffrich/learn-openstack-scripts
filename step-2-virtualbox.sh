#!/bin/bash

# Create all in one image using packer
packer build --only=virtualbox-ovf allinoneserver.json

# Start up the new servers! Add in port forwarding assuming its NAT'd
VBoxManage import ./virtualbox/allinone-server/allinone-server.ovf

# List all the available bridge interfaces
VBoxManage list bridgedifs

echo 'From that list of interfaces, pick which network to attach the VM to. Say it is "en0: Wi-Fi (AirPort)", run the following:'
echo 'VBoxManage modifyvm "allinone-server" --nic1 bridged --bridgeadapter1 '\''en0: Wi-Fi (AirPort)'\'''
echo 'VBoxManage modifyvm "allinone-server" --nicpromisc1 allow-all'
echo 'VBoxManage startvm allinone-server'