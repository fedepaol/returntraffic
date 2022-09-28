#!/bin/bash
set -x

# Note: this always appends
echo 200 device1 >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 dev eth1 table device1

echo 201 device2 >> /etc/iproute2/rt_tables
ip route add default via 10.111.222.21 table device2

ip rule add from $CLUSTERIP1 lookup device1
ip rule add from $CLUSTERIP2 lookup device1
