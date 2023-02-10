# Deploy

Currently the deployment relies on the upstream versions, that can be found under `deploy`.

## MetalLB

Upstream metallb via the modified [./deploy/deploy-metallb-frr.yaml] file.
Also, run `oc adm policy add-scc-to-user privileged -n metallb-system -z speaker` as per [the official docs](https://metallb.universe.tf/installation/clouds/).

## KNmstate

We deploy the 4.13 equivalent of knmstate (rust based) via the [./deploy/deploy-nmstaterust.sh] script.

# Configure

This configuration assumes two nodes which are assigned the IPs `192.168.130.2` and `192.168.130.3`,
and an external host `192.168.130.1` where we run an frr instance.

The two nodes must be labeled with `vrf: enabled`.

## Changing the priority of the local routing table

This is currently not possible with nmstate (see [./limitations.md]), so a workaround is to
apply those changes via mco with [./configure/localrulemcc.yaml].

## Setting up the IP of the nodes

One `NodeNetworkConfigurationPolicy` per node where we set the static IP of the interface we want to
add to the VRF.
In this case the files are [./configure/knmstate-node0.yaml] and [./configure/knmstate-node1.yaml].

This assumes the interface to be consistently `ens9` and a CIDR of `192.168.130.0/24`.

## Setting up the vrfs, the veth pairs and the routes

This is done via the [./configure/knmstate-vrf.yml], which is meant to be node independent, assuming
all the nodes have the same interface we want to embed in a VRF.

## Configuring MetalLB and run a service

This is done via the [./configure/metallbconfig.yaml] file, where we do setup the BGPPeer `192.168.130.1`,
the IPAddressPool and the BGPAdvertisement.

Also, we create a service with a pod where we can run nc from (port 30100).

## Running the external FRR

This is done using `podman run -v $(pwd)/externalpeerfrr:/etc/frr --privileged quay.io/openshift/origin-metallb-frr:4.12 `

## Adding a static route for the service's return traffic

This is done using the `knmstate-servicereturn-testonly.yaml` file, where the ip depends on the clusterip
of the service we just created. This is temporary and will be implemented by OVN-Kubernetes.
Please remember to change the source ip accordingly.


# Checking the configurations are running

Go to the external container, run:

- `vtysh -c "show bgp neighbors"` to see if the sessions are up
- `vtysh -c "show bgp ipv4"` to see if ips are advertised
- `vtysh -c "show bfd peers"` to see if the bfd session is up

Login to the server pod and run nc -l 30100, then try to access it from the external server.

