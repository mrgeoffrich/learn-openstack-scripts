#!/bin/bash

# Create all in one image using packer
packer build --only=vmware-vmx allinoneserver.json

# Start up the new servers!
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start ./vmware/allinone-server/allinone-server.vmx

echo 'Ensure that the VM is connected as bridged networking to the same network as your Mac.'