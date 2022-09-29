#!/bin/bash
# Set the route to the serviceip via the router
set -x
ip route add 192.168.2.1 via 10.111.224.21

sleep inf
