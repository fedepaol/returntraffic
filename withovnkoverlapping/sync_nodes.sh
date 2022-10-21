#!/bin/bash
set -x

KIND_NODES=$(kind get nodes --name ovn)
for n in $KIND_NODES; do
	docker exec "$n" rm -rf /node
	docker cp node $n:/node
done


