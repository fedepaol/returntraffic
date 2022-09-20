#!/bin/sh

set -x

#ip link add eth9 type dummy
#ip link add eth10 type dummy
#ip link set dev eth9 up
#ip link set dev eth10 up
ip addr add 192.168.1.1/32 dev lo
ip addr add 192.168.2.1/32 dev lo


socat -v tcp-l:3000,bind=192.168.1.1,fork exec:'echo svc1' &
socat -v tcp-l:3000,bind=192.168.2.1,fork exec:'echo svc2' &
sleep inf
