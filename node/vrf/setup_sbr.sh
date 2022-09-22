#!/bin/bash

# Note: this always appends
# route the traffic to the veth leg in default vrf
echo 200 toeth1 >> /etc/iproute2/rt_tables
ip route add default via 192.169.1.2 table toeth1
ip rule add pref 1001 from 192.168.1.1 lookup toeth1

echo 201 toeth2 >> /etc/iproute2/rt_tables
ip route add default via 192.169.2.2 table toeth2
ip rule add pref 1002 from 192.168.2.1 lookup toeth2
