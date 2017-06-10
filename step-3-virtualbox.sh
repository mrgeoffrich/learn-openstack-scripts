#!/bin/bash

# Create all in one image using packer
packer build --only=virtualbox-ovf allinoneserver.json

# Start up the new servers!
VBoxManage import ./virtualbox/allinone-server/allinone-server.ovf
VBoxManage startvm allinone-server