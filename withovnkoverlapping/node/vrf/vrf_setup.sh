#!/bin/bash

set -x

### VRF for eth1 
ip link add eth1vrf type vrf table 2
ip link set dev eth1vrf up

# eth1 goes in the vrf eth1vrf
ip link set dev eth1 master eth1vrf

# vrf default route (we set it via the table)
ip route add default via 10.111.221.21 dev eth1 table 2

# Veth pair for eth1
ip link add eth1veth-def type veth peer name eth1veth-vrf
ip link set dev eth1veth-def up
ip link set dev eth1veth-vrf up

ip addr add 192.169.1.1/24 dev eth1veth-def
ip addr add 192.169.1.2/24 dev eth1veth-vrf

# one leg of the veth inside the vrf
ip link set dev eth1veth-vrf master eth1vrf

# vrf route to the service via eth1veth-def
#### NOTE HERE WE ARE INJECTING THE CLUSTER IP TO ROUTE TO
#### THE CLUSTER
#### IT's the cluster ip because it's already dnatted
ip route add 10.96.0.0/16 via 192.169.1.1 table 2



## VRF for eth2 
ip link add eth2vrf type vrf table 3
ip link set dev eth2vrf up

# eth2 goes in the vrf 
ip link set dev eth2 master eth2vrf

# vrf default route (we set it via the table)
ip route add default via 10.111.222.21 dev eth2 table 3

# Veth pair for eth2
ip link add eth2veth-def type veth peer name eth2veth-vrf
ip link set dev eth2veth-def up
ip link set dev eth2veth-vrf up

ip addr add 192.169.2.1/24 dev eth2veth-def
ip addr add 192.169.2.2/24 dev eth2veth-vrf

# one leg of the veth inside the vrf
ip link set dev eth2veth-vrf master eth2vrf

# vrf route to the service via eth1veth-def
ip route add 10.96.0.0/16 via 192.169.2.1 table 3

ip -4 rule add pref 32765 table local
ip -4 rule del pref 0

# useful commands:
# ip route show vrf red
# ip route get 192.168.1.1 vrf red
# [root@6854e5f80a31 /]# ip rule show
