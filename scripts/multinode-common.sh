#!/bin/bash -eux

apt-get install -y aptitude bridge-utils build-essential git ntp ntpdate openssh-server python-dev sudo debootstrap ifenslave ifenslave-2.6 lsof lvm2 tcpdump vlan
echo 'bonding' >> /etc/modules
echo '8021q' >> /etc/modules
