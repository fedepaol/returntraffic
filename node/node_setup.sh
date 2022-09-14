#!/bin/sh

set -x

ip addr add 192.168.1.1/24 dev lo
ip addr add 192.168.2.1/24 dev lo
nc -l 192.168.1.1 3000 &
nc -l 192.168.2.1 3000 &
sleep inf
