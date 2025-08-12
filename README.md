# IBR Testbed
Uses an enhanced version of the danet gnmi-target (https://code.fbi.h-da.de/danet/gnmi-target) installed and running in the provided FRR container image (https://hub.docker.com/r/flex/frr-gnmi-target).

# Running the testbed
Start containerlab as usual (`sudo clab deploy`). The extended stat counters can be retrieved, e.g., using gnmic:

Mgmt Interface of r1, also counting gnmic pkts:
```
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth0]/state/counters/in-octets
```

Regular r1 interfaces:
```
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth1]/state/counters/in-octets
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth3]/state/counters/in-octets
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth4]/state/counters/in-octets
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth5]/state/counters/in-octets
```

All gNMI info from r1:
```
gnmic -a clab-ibr-r1:7030 -u admin -p admsdsdin --insecure get --path /
```

r3 interface eth1:
```
gnmic -a clab-ibr-r3:7030 -u admin -p admsdsdin --insecure get --path /interfaces/interface[name=eth1]/state/counters/in-octets
```
