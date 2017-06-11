#!/bin/bash

# Create all in one image using packer
packer build --only=virtualbox-ovf allinoneserver.json

# Start up the new servers! Add in port forwarding assuming its NAT'd
VBoxManage import ./virtualbox/allinone-server/allinone-server.ovf
VBoxManage startvm allinone-server
VBoxManage controlvm "allinone-server" natpf1 "guestssh,tcp,127.0.0.1,9022,,22"
