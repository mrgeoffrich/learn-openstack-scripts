#!/bin/bash

# Create base image from packer
packer build --only=vmware-iso ubuntu1604base.json