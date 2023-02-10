# Nmstate does not allow to change the priority of the table "local" to 255
Bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=2166630
Workaround: use [./configure/localrulemcc.yaml]

# BFD not working through VRFs
Bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=2168855
Workaround: use the upstream 8.4.1 frr available at [quay.io/frrouting/frr:8.4.1]

# Nmstate does not allow routes via interfaces with dynamic ips
With Nmstate the routes can established only when specifying static ips for the interfaces.
RFE tbd