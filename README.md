## Loadbalancer return traffic POC

This POC aims to find a solution to the asymmetric routing problem with loadbalancer services where the traffic
is coming from an interface different from the default gateway one, from a client that doesn't live on the same subnet.

Using docker networking, we setup a topology as follows:

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

There are two versions, related to two different steps. The first one lives under [./bare](./bare/),
is container based and served as the basis for understanding what needed to be done.

The second one is a full kind cluster running ovnk and with metallb deployed, using what was discovered
in the first step to make the return traffic work. It can be found under [./withovnk](./withovnk/).

The third version is an evolution of the first one, where we attempt to access two services from two
interfaces, and the services share the same IP and port.
All versions come with a separate readme file.

Under [./withnmstate](./withnmstate/) there's a poc on how to achieve the same configuration trying to use
nmstate. It wasn't possible to use it in kind or inside containers, so we resorted to test only the configuration
and not the full setup inside a virtual machine.
