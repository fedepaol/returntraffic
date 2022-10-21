#!/bin/bash
set -x
docker exec frr bash -c "echo 200 vianet1 >> /etc/iproute2/rt_tables"
docker exec frr bash -c "ip route add default via 10.111.221.12 table vianet1"

docker exec frr bash -c "echo 201 vianet2 >> /etc/iproute2/rt_tables"
docker exec frr bash -c "ip route add default via 10.111.222.13 table vianet2"

docker exec frr bash -c "ip rule add pref 1001 from 10.111.223.23 lookup vianet1"
docker exec frr bash -c "ip rule add pref 1002 from 10.111.224.23 lookup vianet2"

