#!/bin/bash

# Note: this always appends
echo 200 toeth1 >> /etc/iproute2/rt_tables
ip route add default via 192.169.1.2 table toeth1
iptables -A PREROUTING -t mangle -s $CLUSTERIP1 -j MARK --set-mark 1
ip rule add fwmark 1 table toeth1

echo 201 toeth2 >> /etc/iproute2/rt_tables
ip route add default via 192.169.2.2 table toeth2
iptables -A PREROUTING -t mangle -s $CLUSTERIP2 -j MARK --set-mark 2
ip rule add fwmark 1 table toeth2
