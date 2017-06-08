#!/bin/bash

# Create all in one image using packer
packer build --only=vmware-vmx allinoneserver.json

# Start up the new servers!
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start ./vmware/deploy-server/deploy-server.vmx
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start ./vmware/allinone-server/allinone-server.vmx
