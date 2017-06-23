#!/bin/bash -eux

# Disable daily apt unattended updates.
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

if [[ ! -z "${APT_CACHE}" ]]; then
    echo "Acquire::http { Proxy \"$APT_CACHE\"; };" >> /etc/apt/apt.conf.d/00aptcache
fi