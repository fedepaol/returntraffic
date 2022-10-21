#!/bin/bash
# Set the route to the serviceip via the router
set -x
ip route delete default
ip route add default via 10.111.223.21

sleep inf
