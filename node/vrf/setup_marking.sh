#!/bin/bash

# Note: this always appends
echo 200 tored >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 dev eth1 table device1

iptables -A OUTPUT -t mangle -s 192.168.1.1 -j MARK --set-mark 1
ip rule add fwmark 1 table tored
