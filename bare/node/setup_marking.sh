#!/bin/bash

# Note: this always appends
echo 200 device1 >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 dev eth1 table device1

echo 201 device2 >> /etc/iproute2/rt_tables
ip route add default via 10.111.222.21 dev eth2 table device2


iptables -A OUTPUT -t mangle -s 192.168.1.1 -j MARK --set-mark 1
ip rule add fwmark 1 table device1
iptables -A OUTPUT -t mangle -s 192.168.2.1 -j MARK --set-mark 2
ip rule add fwmark 2 table device1
