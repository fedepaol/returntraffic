#!/bin/bash
# Set the route to the serviceip via the router
set -x
ip route add 192.168.1.1 via 10.111.223.21

sleep inf
