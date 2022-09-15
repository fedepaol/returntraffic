#!/bin/sh

set -x

ip addr add 192.168.1.1/24 dev lo
ip addr add 192.168.2.1/24 dev lo
socat -v tcp-l:3000,bind=192.168.1.1,fork exec:'echo svc1' &
socat -v tcp-l:3000,bind=192.168.2.1,fork exec:'echo svc2' &
sleep inf
