# NMState audit

This part is meant to check if what was done in [../bare](../bare/) and
[..withovnk](../withovnk/) can be implemented in a dichiarative way using nmstate.

## Testing it out

Run `vagrant up`, ssh into the vm with `vagrant ssh` and then run `nmstatectl apply /vagrant/vrf.yaml`
for the vrf setup, and `nmstatectl apply /vagrant/sbr.yaml` for the plain source based routing.

## Source based routing

Source based routing can be implemented following the example in [./sbr.yaml](./sbr.yaml).

## Policy based routing based on marking

Nmstate doesn't currently support the feature. Rules can be expressed only in terms of
source IP or dest IP (see the [api doc](https://nmstate.io/devel/api.html#route-rule)).

## Veth + VRF

Nmstate allows to express the combination of veth pair + VRF wrapping one leg of the veth and
the egress interface. It also allows to set the default gateway in the VRF routing table.

What it _doesn't allow_ is inverting the priority if the rule related to the vrf and the rule
related to the local table, which is normally done via:

```bash
ip -4 rule add pref 32765 table local
ip -4 rule del pref 0
```

This is required to have VRF lookups occur before local ones, and local ones are related to
directly connected interfaces, but can be done with a script once.

It's possible to use source based routing but not marking to drive the outgoing traffic to
the veth leg (as described above in the previous sections).
