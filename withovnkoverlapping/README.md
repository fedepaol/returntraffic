# Return traffic routing POC setup

This is another layer on top of the [withovnk poc](../withovnk).

## Changes

A couple of changes are required:

- MetalLB checks on overlapping IPs with the same port are disabled.
- OVNK iptable settings add the "-i intf" discriminator in order to translate the LB IP to the right clusterip, depending on
the interface the traffic is coming from
- Given the service's IP is the same, we do source based routing on the router, looking at the ip of the client

This aside, both clients are able to reach their respective service even though they have the same port and IP.
