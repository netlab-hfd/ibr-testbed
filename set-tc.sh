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

# r1
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r1 tc qdisc add dev eth1 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r1 tc class add dev eth1 parent 1: classid 1:10 htb rate 2mbit ceil 2mbit
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r1 tc qdisc add dev eth2 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r1 tc class add dev eth2 parent 1: classid 1:10 htb rate 1mbit ceil 1mbit
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r1 tc qdisc add dev eth3 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r1 tc class add dev eth3 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth4 root
sudo ip netns exec clab-ibr-r1 tc qdisc add dev eth4 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r1 tc class add dev eth4 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit

# r2
sudo ip netns exec clab-ibr-r2 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r2 tc qdisc add dev eth1 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r2 tc class add dev eth1 parent 1: classid 1:10 htb rate 2mbit ceil 2mbit
sudo ip netns exec clab-ibr-r2 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r2 tc qdisc add dev eth2 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r2 tc class add dev eth2 parent 1: classid 1:10 htb rate 2mbit ceil 2mbit

# r3
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r3 tc qdisc add dev eth1 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r3 tc class add dev eth1 parent 1: classid 1:10 htb rate 1mbit ceil 1mbit
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r3 tc qdisc add dev eth2 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r3 tc class add dev eth2 parent 1: classid 1:10 htb rate 2mbit ceil 2mbit
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r3 tc qdisc add dev eth3 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r3 tc class add dev eth3 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth4 root
sudo ip netns exec clab-ibr-r3 tc qdisc add dev eth4 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r3 tc class add dev eth4 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit

# r4
sudo ip netns exec clab-ibr-r4 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r4 tc qdisc add dev eth1 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r4 tc class add dev eth1 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit
sudo ip netns exec clab-ibr-r4 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r4 tc qdisc add dev eth2 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r4 tc class add dev eth2 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit

# r5
sudo ip netns exec clab-ibr-r5 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r5 tc qdisc add dev eth3 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r5 tc class add dev eth3 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit
sudo ip netns exec clab-ibr-r5 tc qdisc del dev eth4 root
sudo ip netns exec clab-ibr-r5 tc qdisc add dev eth4 root handle 1: htb default 10
sudo ip netns exec clab-ibr-r5 tc class add dev eth4 parent 1: classid 1:10 htb rate 4mbit ceil 4mbit
