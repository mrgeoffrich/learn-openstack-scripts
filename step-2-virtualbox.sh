#!/bin/bash

# Create deploy image using packer
packer build --only=virtualbox-ovf deployserver.json