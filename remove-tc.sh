#!/usr/bin/env bash

# r1 r1 <-> r3 direct
# r2 r1 <-> r2 <-> h3 1-hop
# r1 <-> r4 <-> r5 <-> r3 2-hop

# Function to remove HTB
remove_htb() {
    local router=$1
    local interface=$2

    sudo ip netns exec "$router" tc qdisc del dev "$interface" root >/dev/null 2>&1
}

# r1
remove_htb clab-ibr-r1 eth1
remove_htb clab-ibr-r1 eth2
remove_htb clab-ibr-r1 eth3
remove_htb clab-ibr-r1 eth4

# r2
remove_htb clab-ibr-r2 eth1
remove_htb clab-ibr-r2 eth2

# r3
remove_htb clab-ibr-r3 eth1
remove_htb clab-ibr-r3 eth2
remove_htb clab-ibr-r3 eth3
remove_htb clab-ibr-r3 eth4

# r4
remove_htb clab-ibr-r4 eth1
remove_htb clab-ibr-r4 eth2

# r5
remove_htb clab-ibr-r5 eth3
remove_htb clab-ibr-r5 eth4
