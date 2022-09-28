#!/bin/bash
set -x
# Note: this always appends
# route the traffic to the veth leg in default vrf
echo 200 toeth1 >> /etc/iproute2/rt_tables
ip route add default via 192.169.1.2 table toeth1
ip rule add pref 1001 from $CLUSTERIP1 lookup toeth1

echo 201 toeth2 >> /etc/iproute2/rt_tables
ip route add default via 192.169.2.2 table toeth2
ip rule add pref 1002 from $CLUSTERIP2 lookup toeth2
