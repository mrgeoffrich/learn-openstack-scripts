#!/bin/bash -eux

echo "Static IP of $STATIC_IP"
echo "Subnet Mask of $SUBNET_MASK"
echo "Gateway of $GATEWAY"
echo "DNS servers are $DNS_1 and $DNS_2"

FILE="/etc/network/interfaces"

/bin/cat <<EOM >$FILE
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet static
address $STATIC_IP
netmask $SUBNET_MASK
gateway $GATEWAY
dns-nameservers $DNS_1 $DNS_2
EOM