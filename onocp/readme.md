# Deploy

Upstream metallb via the modified `metallb-frr.yaml` file

We can't currently change the priority of the local routing rule, so we do that
using a machine config `localrulemcc.yaml`

We deploy the 4.13 equivalent of knmstate (rust based) via the `deploy-nmstaterust.sh` script.

Label the nodes to be impacted as vrf: enabled

Apply the `knmstate-vrf.yml` configuration file.
The current setup assignes a static ip to the interface we want to move in the vrf (ens9)
192.168.130.1


Once the setup is done, apply the metallb configuration and the service definition:




To do (it will be done by ovnk)
ip rule add pref 1002 from $CLUSTERIP2 lookup 200

On the external node:

podman run -v $(pwd)/externalpeerfrr:/etc/frr --privileged quay.io/openshift/origin-metallb-frr:4.12 

