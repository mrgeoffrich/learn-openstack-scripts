#!/bin/bash

# Create all images using packer
packer build --only=virtualbox-ovf multinode-deploy.json
packer build --only=virtualbox-ovf multinode-compute.json
packer build --only=virtualbox-ovf multinode-controller.json
packer build --only=virtualbox-ovf multinode-infrastructure.json
packer build --only=virtualbox-ovf multinode-network.json
packer build --only=virtualbox-ovf multinode-storage.json
