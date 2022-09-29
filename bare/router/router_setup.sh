#!/bin/bash
set -x
ip route add 192.168.1.1 via 10.111.221.11
ip route add 192.168.2.1 via 10.111.222.11

sleep inf
