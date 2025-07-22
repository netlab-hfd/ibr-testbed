#!/usr/bin/env bash

# r1 r1 <-> r3 direct
# r2 r1 <-> r2 <-> h3 1-hop
# r1 <-> r4 <-> r5 <-> r3 2-hop

# r1
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r1 tc qdisc del dev eth4 root

# r2
sudo ip netns exec clab-ibr-r2 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r2 tc qdisc del dev eth2 root

# r3
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth2 root
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r3 tc qdisc del dev eth4 root

# r4
sudo ip netns exec clab-ibr-r4 tc qdisc del dev eth1 root
sudo ip netns exec clab-ibr-r4 tc qdisc del dev eth2 root

# r5
sudo ip netns exec clab-ibr-r5 tc qdisc del dev eth3 root
sudo ip netns exec clab-ibr-r5 tc qdisc del dev eth4 root
