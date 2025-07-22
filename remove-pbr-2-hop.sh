#!/usr/bin/env bash

# remove r1, reroute traffic from source port 10000 to r2
sudo ip netns exec clab-ibr-r1 iptables -t mangle -D PREROUTING -p tcp --sport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r1 ip rule del fwmark 102 table 102
sudo ip netns exec clab-ibr-r1 ip route del default via 10.1.4.2 dev eth3 table 102

sudo ip netns exec clab-ibr-r4 iptables -t mangle -D PREROUTING -p tcp --sport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r4 ip rule del fwmark 102 table 102
sudo ip netns exec clab-ibr-r4 ip route del default via 10.4.5.2 dev eth3 table 102

# remove r3, reroute traffic for destination port 10000 to r2
sudo ip netns exec clab-ibr-r3 iptables -t mangle -D PREROUTING -p tcp --dport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r3 ip rule del fwmark 102 table 102
sudo ip netns exec clab-ibr-r3 ip route del default via 10.3.5.2 dev eth3 table 102

sudo ip netns exec clab-ibr-r5 iptables -t mangle -D PREROUTING -p tcp --dport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r5 ip rule del fwmark 102 table 102
sudo ip netns exec clab-ibr-r5 ip route del default via 10.4.5.1 dev eth1 table 102
