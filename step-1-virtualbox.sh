#!/bin/bash

# Create base image from packer
packer build --only=virtualbox-iso ubuntu1604base.json