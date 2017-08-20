#!/bin/bash -eux

mkdir -p /openstack
rsync -avzlHAX --exclude=/repos --exclude=/mirror --exclude=/rpcgit \
    --exclude=/openstackgit --exclude=/python_packages \
    rpc-repo.rackspace.com::openstack_mirror repo/
apt-get install -y nginx apt-cacher-ng

