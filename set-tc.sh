#!/usr/bin/env bash

# directly in containerlab -> not stable

## r1 -> r3 direct
#sudo containerlab tools netem set -n clab-ibr-r1 -i eth2 --rate 1000 --delay 10ms
## r1 -> r2 1-hop
#sudo containerlab tools netem set -n clab-ibr-r1 -i eth1 --rate 2000 --delay 10ms
## r2 -> r3 1-hop
#sudo containerlab tools netem set -n clab-ibr-r2 -i eth2 --rate 2000 --delay 10ms
## r3 -> r5 2-hop 2 link lag
#sudo containerlab tools netem set -n clab-ibr-r3 -i eth3 --rate 4000
#sudo containerlab tools netem set -n clab-ibr-r3 -i eth4 --rate 4000
## r1 -> r4 2-hop 2 link lag
#sudo containerlab tools netem set -n clab-ibr-r1 -i eth4 --rate 4000
#sudo containerlab tools netem set -n clab-ibr-r1 -i eth3 --rate 4000

# using htb in netn

# r1 r1 <-> r3 direct
# r2 r1 <-> r2 <-> h3 1-hop
# r1 <-> r4 <-> r5 <-> r3 2-hop

# Function to setup HTB
setup_htb() {
    local router=$1
    local interface=$2
    local rate=$3

    #sudo ip netns exec "$router" tc qdisc del dev "$interface" root >/dev/null 2>&1
    #sudo ip netns exec "$router" tc qdisc add dev "$interface" root handle 1: tbf rate $rate limit 25000000 burst 5000000 
    sudo ip netns exec "$router" tc qdisc add dev "$interface" root handle 1: htb default 10
    sudo ip netns exec "$router" tc class add dev "$interface" parent 1: classid 1:1 htb rate "$rate" ceil "$rate" #quantum 1514
    sudo ip netns exec "$router" tc class add dev "$interface" parent 1:1 classid 1:10 htb rate "$rate" ceil "$rate" #quantum 1514
    #sudo ip netns exec "$router" tc qdisc add dev "$interface" parent 1:10 handle 10: sfq #ecn headdrop flows 1024 limit 1000 perturb 60 redflowlimit 100000
    #sudo ip netns exec "$router" tc qdisc add dev "$interface" parent 1:10 handle 10: fq_codel #ecn limit 1000
    # tc -s -d -g qdisc show dev eth0 
}

# r1
setup_htb clab-ibr-r1 eth1 2mbit
setup_htb clab-ibr-r1 eth2 1mbit
setup_htb clab-ibr-r1 eth3 4mbit
setup_htb clab-ibr-r1 eth4 4mbit

# r2
setup_htb clab-ibr-r2 eth1 2mbit
setup_htb clab-ibr-r2 eth2 2mbit

# r3
setup_htb clab-ibr-r3 eth1 1mbit
setup_htb clab-ibr-r3 eth2 2mbit
setup_htb clab-ibr-r3 eth3 4mbit
setup_htb clab-ibr-r3 eth4 4mbit

# r4
setup_htb clab-ibr-r4 eth1 4mbit
setup_htb clab-ibr-r4 eth2 4mbit

# r5
setup_htb clab-ibr-r5 eth3 4mbit
setup_htb clab-ibr-r5 eth4 4mbit
