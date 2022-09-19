#!/bin/bash

ip link add red type vrf table 2
ip link set dev red up
ip link set dev eth1 master red

# Veth pair
ip link add red0 type veth peer name red1
ip link set dev red0 up
ip link set dev red1 up

# one leg of the veth inside the vrf
ip link set dev red1 master red

# vrf default route (we set it via the table)
ip route add default via 10.111.221.21 dev eth1 table 2
# vrf route to the service via red1
ip route add 192.168.1.1 dev red1 table 2

# useful commands:
# ip route show vrf red
