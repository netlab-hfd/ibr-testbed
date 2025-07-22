#!/usr/bin/env bash

# remove r1, reroute traffic from source port 10000 to r2
sudo ip netns exec clab-ibr-r1 iptables -t mangle -D PREROUTING -p tcp --sport 10000 -j MARK --set-mark 100
sudo ip netns exec clab-ibr-r1 ip rule del fwmark 100 table 100
sudo ip netns exec clab-ibr-r1 ip route del default via 10.1.2.2 dev eth1 table 100

# remove r3, reroute traffic for destination port 10000 to r2
sudo ip netns exec clab-ibr-r3 iptables -t mangle -D PREROUTING -p tcp --dport 10000 -j MARK --set-mark 100
sudo ip netns exec clab-ibr-r3 ip rule del fwmark 100 table 100
sudo ip netns exec clab-ibr-r3 ip route del default via 10.2.3.1 dev eth2 table 100
