#!/bin/bash
set -x
docker exec frr ip route add 192.168.10.0 via 10.111.221.12
docker exec frr ip route add 192.168.11.0 via 10.111.222.13

