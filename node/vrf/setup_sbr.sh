#!/bin/bash

# Note: this always appends
# route the traffic to the veth leg in default vrf
echo 200 tored >> /etc/iproute2/rt_tables
ip route add default dev red0 table tored
ip rule add from 192.168.1.1 lookup tored
