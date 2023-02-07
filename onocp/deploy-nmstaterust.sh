#!/bin/sh

git clone https://github.com/qinqon/kubernetes-nmstate -b use-nmstatectl-rust
cd kubernetes-nmstate
export DEV_IMAGE_REGISTRY=quay.io
export KUBEVIRT_PROVIDER=external
make IMAGE_REPO=fpaoline cluster-sync
