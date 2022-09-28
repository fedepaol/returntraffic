#!/bin/bash
set -x

command=$1

export CLUSTERIP1=$(kubectl get svc nginx1 -o=jsonpath='{.spec.clusterIP}')
export CLUSTERIP2=$(kubectl get svc nginx2 -o=jsonpath='{.spec.clusterIP}')
export SERVICEIP1=$(kubectl get svc nginx1 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
export SERVICEIP2=$(kubectl get svc nginx2 -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
KIND_NODES=$(kind get nodes --name ovn)
for n in $KIND_NODES; do
	docker exec "$n" bash -c "CLUSTERIP1=$CLUSTERIP1 CLUSTERIP2=$CLUSTERIP2 SERVICEIP1=$SERVICEIP1 SERVICEIP2=$SERVICEIP2 $command"
done
