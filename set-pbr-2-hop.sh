#!/usr/bin/env bash

# r1
# 10.1.2.1 (r1 eth1: -> r2 eth1)
# 10.1.3.1 (r1 eth2: -> r3 eth1)
# 10.1.4.1 (r1 eth3: -> r4 eth1)
# 10.1.4.5 (r1 eth4: -> r4 eth2)
# 192.168.11.1 (r1 eth5: -> h1-1 eth1)
# 10.10.10.1 (loopback)
#
# r2
# 10.1.2.2 (r2 eth1: -> r1 eth1)
# 10.2.3.1 (r2 eth2: -> r3 eth2)
# 192.168.12.1 (r2 eth3: -> h1-2 eth1)
# 10.10.10.2 (loopback)
#
# r3
# 10.1.3.2
# 10.2.3.2
# 10.3.5.1
# 10.3.5.5
# 192.168.13.1
# 10.10.10.3 (loopback)
#
# r4
# 10.1.4.2
# 10.1.5.6
# 10.4.5.1
# 10.4.5.5
# 10.10.10.4 (loopback)
#
# r5
# 10.3.5.2
# 10.3.5.6
# 10.4.5.2
# 10.4.5.6
# 10.10.10.5 (loopback)

# r1, reroute traffic from source port 10000 to r2
sudo ip netns exec clab-ibr-r1 iptables -t mangle -A PREROUTING -p tcp --sport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r1 ip rule add fwmark 102 table 102
sudo ip netns exec clab-ibr-r1 ip route add default via 10.1.4.2 dev eth3 table 102

sudo ip netns exec clab-ibr-r4 iptables -t mangle -A PREROUTING -p tcp --sport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r4 ip rule add fwmark 102 table 102
sudo ip netns exec clab-ibr-r4 ip route add default via 10.4.5.2 dev eth3 table 102

# r3, reroute traffic for destination port 10000 to r2
sudo ip netns exec clab-ibr-r3 iptables -t mangle -A PREROUTING -p tcp --dport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r3 ip rule add fwmark 102 table 102
sudo ip netns exec clab-ibr-r3 ip route add default via 10.3.5.2 dev eth3 table 102

sudo ip netns exec clab-ibr-r5 iptables -t mangle -A PREROUTING -p tcp --dport 10002 -j MARK --set-mark 102
sudo ip netns exec clab-ibr-r5 ip rule add fwmark 102 table 102
sudo ip netns exec clab-ibr-r5 ip route add default via 10.4.5.1 dev eth1 table 102

#docker exec -it clab-ibr-h1-1 iperf3 -R --cport 10000 -c 192.168.13.101
#docker exec -it clab-ibr-h1-1 iperf3 -R -P 2 --cport 10000 -c 192.168.13.101
