#!/bin/bash

ip link add red type vrf table 2
ip link set dev red up
ip link set dev eth1 master red

# Veth pair
ip link add red0 type veth peer name red1
ip link set dev red0 up
ip link set dev red1 up
ip addr add 192.169.1.1/24 dev red0
ip addr add 192.169.1.2/24 dev red1

# one leg of the veth inside the vrf
ip link set dev red1 master red

# vrf default route (we set it via the table)
ip route add default via 10.111.221.21 dev eth1 table 2
# vrf route to the service via red1
ip route add 192.168.1.1/32 via 192.169.1.1 table 2

# useful commands:
# ip route show vrf red
# ip route get 192.168.1.1 vrf red
# [root@6854e5f80a31 /]# ip rule show
# 998:    from 192.168.1.1 lookup tored
# 1000:   from all lookup [l3mdev-table]
# 32765:  from all lookup local
# 32766:  from all lookup main
# 32767:  from all lookup default

