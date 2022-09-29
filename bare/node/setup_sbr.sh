#!/bin/bash

# Note: this always appends
echo 200 device1 >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 dev eth1 table device1

echo 201 device2 >> /etc/iproute2/rt_tables
ip route add default via 10.111.222.21 dev eth2 table device2

ip rule add from 192.168.1.1 lookup device1
ip rule add from 192.168.2.1 lookup device2
