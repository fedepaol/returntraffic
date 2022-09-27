#!/bin/bash
set -x

command=$1

KIND_NODES=$(kind get nodes --name ovn)
for n in $KIND_NODES; do
	docker exec "$n" $command
done
