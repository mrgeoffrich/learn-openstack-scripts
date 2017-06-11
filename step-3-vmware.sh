#!/bin/bash

# Create deploy image using packer
packer build --only=vmware-vmx deployserver.json