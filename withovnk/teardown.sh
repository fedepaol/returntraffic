#!/bin/bash
#

kind delete clusters ovn
docker rm -f client1
docker rm -f frr
docker network rm external0
docker network rm external1
docker network rm vlan0
docker network rm vlan1
