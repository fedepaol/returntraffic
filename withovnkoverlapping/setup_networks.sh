#!/bin/bash
#

docker network create --driver=bridge --subnet=10.111.221.1/24 vlan0
docker network create --driver=bridge --subnet=10.111.222.1/24 vlan1
docker network create --driver=bridge --subnet=10.111.223.1/24 external0
docker network create --driver=bridge --subnet=10.111.224.1/24 external1


docker network connect vlan0 ovn-control-plane --ip 10.111.221.11
docker network connect vlan0 ovn-worker --ip 10.111.221.12
docker network connect vlan0 ovn-worker2 --ip 10.111.221.13

docker network connect vlan1 ovn-control-plane --ip 10.111.222.11
docker network connect vlan1 ovn-worker --ip 10.111.222.12
docker network connect vlan1 ovn-worker2 --ip 10.111.222.13

