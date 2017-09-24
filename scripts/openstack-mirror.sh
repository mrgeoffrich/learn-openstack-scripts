#!/bin/bash -eux

mkdir -p /openstack
cd /openstack
# TODO: Find out how to reduce this download. Warning: it's currently 50 GB
#rsync -avzlHAX --exclude=/repos --exclude=/mirror --exclude=/rpcgit \
#    --exclude=/openstackgit --exclude=/python_packages \
#    rpc-repo.rackspace.com::openstack_mirror repo/
apt-get install -y nginx apt-cacher-ng
# TODO: Set up nginx to point to /openstack as the mirror