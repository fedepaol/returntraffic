
# Return traffic routing POC setup

Tearing up / down the setup requires `docker-compose` installed, just run `docker-compose up` from the shell.

## Node

Mimics the kubernetes node hosting two services.

Two netcat instances are running there, listening on `192.168.1.1` and on `192.168.2.1`.

Both IPs are pinned to lo and not reacheable from outside.

The node is connected to two interfaces: `network1` and `network2`, plus the primary network which serves as default gateway.

```bash
ip addr add 192.168.1.1/24 dev lo
ip addr add 192.168.2.1/24 dev lo
nc -l 192.168.1.1 3000 &
nc -l 192.168.2.1 3000 &
```

## Router

The router is connected to the node via the two interfaces. It has routes to each service via a different interface.

```bash
ip route add 192.168.1.1 via 10.111.221.11
ip route add 192.168.2.1 via 10.111.222.11
```

Trying to reach the service from the router works, because the source ip exists in the node's routing table.

## External Client

The external client is connected to the router via another network. There is a route to the service via the router:

```bash
ip route add 192.168.1.1 via 10.111.223.21
```

```none

       ┌─────────────────────────────┐
       │Node                         │
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
       │Router │             │       │
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

### Trying to reach the service from client1

From the client:

```bash
[root@64fb1ad008bb /]# nc 192.168.1.1 3000
```

On the node:

```bash
[root@6153a0852c22 /]# tcpdump tcp -i any port 3000
tcpdump: data link type LINUX_SLL2
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on any, link-type LINUX_SLL2 (Linux cooked v2), snapshot length 262144 bytes
15:31:23.870929 eth1  In  IP 10.111.223.23.52820 > 6153a0852c22.hbci: Flags [S], seq 3242029860, win 64240, options [mss 1460,sackOK,TS val 3023128915 ecr 0,nop,wscale 7], length 0
15:31:23.870961 eth0  Out IP 6153a0852c22.hbci > 10.111.223.23.52820: Flags [S.], seq 3695558510, ack 3242029861, win 65160, options [mss 1460,sackOK,TS val 2396430004 ecr 3023128915,nop,wscale 7], length 0
15:31:24.879147 eth1  In  IP 10.111.223.23.52820 > 6153a0852c22.hbci: Flags [S], seq 3242029860, win 64240, options [mss 1460,sackOK,TS val 3023129923 ecr 0,nop,wscale 7], length 0
15:31:24.879202 eth0  Out IP 6153a0852c22.hbci > 10.111.223.23.52820: Flags [S.], seq 3695558510, ack 3242029861, win 65160, options [mss 1460,sackOK,TS val 2396430964 ecr 3023129923,nop,wscale 7], length 0
```

The ack is beint sent over the default gateway (eth0).

After setting a route back to the client via the router (static route):

```bash
ip route add 10.111.223.23 via 10.111.221.11
```

The connection is established as expected

```bash
15:46:29.065418 eth1  In  IP 10.111.223.23.42782 > 6153a0852c22.hbci: Flags [S], seq 386908592, win 64240, options [mss 1460,sackOK,TS val 3024034109 ecr 0,nop,wscale 7], length 0
15:46:29.065434 eth1  Out IP 6153a0852c22.hbci > 10.111.223.23.42782: Flags [R.], seq 0, ack 386908593, win 0, length 0
15:46:45.653203 eth1  In  IP 10.111.223.23.39900 > 6153a0852c22.hbci: Flags [S], seq 3663634585, win 64240, options [mss 1460,sackOK,TS val 3024050697 ecr 0,nop,wscale 7], length 0
15:46:45.653241 eth1  Out IP 6153a0852c22.hbci > 10.111.223.23.39900: Flags [R.], seq 0, ack 3663634586, win 0, length 0
```

### Using source based routing

```
echo 200 device1 >> /etc/iproute2/rt_tables

ip route add default via 10.111.221.21 dev eth1 table device1
ip rule add from 192.168.1.1 lookup device1

echo 201 device2 >> /etc/iproute2/rt_tables
ip route add default via 10.111.222.21 dev eth2 table device2
ip rule add from 192.168.2.1 lookup device1
```

This will route the traffic coming from the "service ip" to the right interface.
