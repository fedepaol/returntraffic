#!/bin/bash

./ovn-kubernetes/contrib/kind.sh -gm local
./setup_networks.sh
export KUBECONFIG=~/ovn.conf
pushd metallb
inv dev-env -p bgp -b frr --name ovn --log-level debug
popd
./start_client.sh
kubectl apply -f metallb/dev-env/testsvc.yaml
./sync_nodes.sh

