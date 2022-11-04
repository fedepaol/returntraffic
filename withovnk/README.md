# Return traffic routing POC setup

This is the expanded, ovnk + metallb based version of the [bare poc](../bare).

## Deployment

The deployment is the same, but instead of simulated nodes / router we have a kind cluster and a container running FRR as the router.
The router is fully integrated with metallb.

Extra docker networking is put in place via the [setup_networks.sh](./setup_networks.sh) and inside the [dev-env](./metallb/tasks.py) setup of metallb.

Convenience scripts for the environment are [start.sh](./start.sh) for setting up and [teardown.sh](./teardown.sh) for bringing down.

The content of [node](./node) is synced on every node and used to do the various configurations.

```none

       ┌─────────────────────────────┐
       │Kind Node                    │
       │                             │    Default Network
       │ ┌────────┐     ┌────────┐ ──┼────────────────────
       │ │ SVC1   │     │ SVC2   │   │
       │ │        │     │        │   │
       │ └────────┘     └────────┘   │
       │                             │
       │ 10.111.221.11  10.111.222.11│
       │       │             │       │
       └───────┼─────────────┼───────┘
               │             │
       Network1│             │Network2
               │             │
       ┌───────┼─────────────┼───────┐
       │FRR    │             │       │
       │                             │
       │ 10.111.221.21  10.111.222.21│
       │                             │
       │                             │
       │                             │
       │                             │
       │10.111.223.21   10.111.224.21│
       │     │                  │    │
       └─────┼──────────────────┼────┘
             │                  │
             │                  │
External0    │                  │   External1
             │                  │
 ┌───────────┼─────────┐  ┌─────┼───────────────┐
 │           │         │  │     │               │
 │                     │  │                     │
 │  10.111.223.23      │  │  10.111.224.23      │
 │                     │  │                     │
 │        Client1      │  │        Client2      │
 │                     │  │                     │
 └─────────────────────┘  └─────────────────────┘
```

Two extra convenience commands are [run_on_nodes.sh](./run_on_nodes.sh) to run a command on all the nodes, and [sync_nodes.sh](./sync_nodes.sh)
to sync the content of `node`.

## Baseline

MetalLB is configured with two IPAddresspool and two services, meant to be exposed each one via a different interface of the node
(and, for debugging convenience, via different nodes).

For example, the advertisement related to the first pool is:

```yaml
apiVersion: metallb.io/v1beta1
kind: BGPAdvertisement
metadata:
  name: first-adv
  namespace: metallb-system
spec:
  ipAddressPools:
    - first-pool
  peers:
    - routervlan0
  nodeSelectors:
  - matchLabels:
      kubernetes.io/hostname: ovn-worker
```

Trying to reach the serviceIP from Client1 has the same result of the [bare](../bare/) setup:

```bash
12:26:04.821006 eth1  In  IP 10.111.223.23.34330 > 192.168.10.0.80: Flags [S], seq 3785684458, win 64240, options [mss 1460,sackOK,TS val 1749795585 ecr 0,nop,wscale 7], length 0
12:26:04.821027 breth0 Out IP 10.111.223.23.34330 > 10.96.145.170.80: Flags [S], seq 3785684458, win 64240, options [mss 1460,sackOK,TS val 1749795585 ecr 0,nop,wscale 7], length 0
12:26:04.822497 genev_sys_6081 Out IP 100.64.0.4.34330 > 10.244.2.4.80: Flags [S], seq 3785684458, win 64240, options [mss 1460,sackOK,TS val 1749795585 ecr 0,nop,wscale 7], length 0
12:26:04.824810 genev_sys_6081 P   IP 10.244.2.4.80 > 100.64.0.4.34330: Flags [S.], seq 3261080071, ack 3785684459, win 64704, options [mss 1360,sackOK,TS val 4190023163 ecr 1749795585,nop,wscale 7], length 0
12:26:04.825565 breth0 In  IP 10.96.145.170.80 > 10.111.223.23.34330: Flags [S.], seq 3261080071, ack 3785684459, win 64704, options [mss 1360,sackOK,TS val 4190023163 ecr 1749795585,nop,wscale 7], length 0
12:26:04.825583 breth0 Out IP 192.168.10.0.80 > 10.111.223.23.34330: Flags [S.], seq 3261080071, ack 3785684459, win 64704, options [mss 1360,sackOK,TS val 4190023163 ecr 1749795585,nop,wscale 7], length 0
12:26:04.825711 eth0  Out IP 192.168.10.0.80 > 10.111.223.23.34330: Flags [S.], seq 3261080071, ack 3785684459, win 64704, options [mss 1360,sackOK,TS val 4190023163 ecr 1749795585,nop,wscale 7], length 0
```

The traffic comes in from eth1, but the return traffic goes via the default gateway (eth0).

### Solutions

Here we followed the same approach taken in the [bare](../bare).

#### Static return routes

Setting static routes with `./run_on_nodes.sh /node/set_route_to_client.sh` will make the trick.
It will run [./node/set_route_to_client.sh](./node/set_route_to_client.sh) to set the static routes via the right interface.

#### Using source based routing

This is enabled by `./run_on_nodes.sh /node/setup_sbr.sh`.

Setting up routes based on the clusterip of the service (and not on the serviceip) will make the traffic return via the right interface.

```yaml
echo 200 device1 >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 dev eth1 table device1

ip rule add from $CLUSTERIP1 lookup device1
```

Note: we are using the clusterip here because the routing happens before the un-dnatting.

#### Using marking and policy based routing

This is enabled by running `./run_on_nodes.sh /node/setup_marking.sh`.

```bash
echo 200 device1 >> /etc/iproute2/rt_tables
ip route add default via 10.111.221.21 table device1

iptables -A PREROUTING -t mangle -s $CLUSTERIP1 -j MARK --set-mark 1
ip rule add fwmark 1 table device1
```

Note again the clusterip is used, and the PREROUTING chain used because the traffic is dropped on the host from breth and
needs to be routed to the right interface, so the marking must happen before the routing.

### With VRF

The VRF setup is the same as in the [./bare](./bare) setup.
For more details, see the "using a vrf" section of [../bare/README.md](../bare/README.md).

This is enabled by running `./run_on_nodes.sh /node/vrf/vrf_setup.sh`, and by running `./router_setup_vrf.sh`.
The latter is needed because after putting the interfaces in the vrf, metallb won't be able to announce the service
anymore, so we hack routes in the router pretending it works.

The main difference again, is the fact that the route to the service (inside the vrf) is driven by the clusterIP,
because the iptable rule that dnats it is happening in the PREROUTING chain:

```yaml
-A PREROUTING -j OVN-KUBE-EXTERNALIP
```

The two variants (still based on the clusterip) will use the same steering methods described above, with the difference that
the steering is done to the leg of the veth pair which lives in the default vrf instead of the device itself.

In order to enable the routing via source,  `./run_on_nodes.sh /node/vrf/setup_sbr.sh`. On the other hand, for using marking
and policy based routing:  `./run_on_nodes.sh /node/vrf/setup_marking.sh`.

### Egress Traffic

We also validate that the same logic can be applied to pods initiating the traffic using the "k8s.ovn.org/egress-service" annotation on the service. An "egress" pod is created and added to an "egress" service. 

Running nc on client1 and trying to access it from the pod will work.

In order to make it work, another rule must be added to the routing table of the VRF, because the egress traffic is S-NATed using a rule like:

```bash
-A OVN-KUBE-EGRESS-SVC -s 10.244.0.5/32 -m comment --comment "default/egress" -j SNAT --to-source 192.168.12.0
```

Becuase of the fact that the return traffic is un-dnatted, we need to set a route inside the vrf routing table to steer the traffic directed to the pods cidr to the default vrf.

```bash
ip route add 10.244.0.0/16 via 192.169.1.1 table 2
```


### Egress Traffic steering from a generic pod

This is the last POC, where we try to influence the path of the egress traffic
based on the destination IP. Since the steering logic is based on the marking,
any logic can be applied (namespace, pod selector) as long as OVNK exposes an
API to do the marking based on various discriminators. In this POC, we
mark the traffic coming from the `egressnosvc` pod looking at the destination
IP.

Another change that needs to be done to make this work is to add an additional
masquerade rule to let the traffic take the VLAN IP, because by default the
traffic is masqueraded using the IP of the veth leg belonging to the default
VRF.

Adding two rules like

```bash
iptables -t nat -A POSTROUTING -s 192.169.1.1 -j MASQUERADE
```

make the trick (where `192.169.1.1` is the IP of `eth1veth-def`, the leg of
the veth pair living in the default VRF.

