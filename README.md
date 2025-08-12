# IBR Testbed
Uses an enhanced version of the danet gnmi-target (https://code.fbi.h-da.de/danet/gnmi-target) installed and running in the provided FRR container image (https://hub.docker.com/r/flex/frr-gnmi-target).

# Running the testbed
Start containerlab as usual (`sudo clab deploy`). The extended stat counters can be retrieved, e.g., using gnmic:

# Example PBR setup

Start iperf3 on h3-1:
```
docker exec -it clab-ibr-h3-1 bash
h3-1:/$ iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```

Run iperf3 cient on h1-1:
```
h1-1:/$ iperf3 -R -i.5 -c 192.168.13.101
Connecting to host 192.168.13.101, port 5201
Reverse mode, remote host 192.168.13.101 is sending
[  5] local 192.168.11.101 port 52172 connected to 192.168.13.101 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-0.50   sec   369 MBytes  6.20 Gbits/sec
[  5]   0.50-1.00   sec   361 MBytes  6.05 Gbits/sec
[  5]   1.00-1.50   sec   611 MBytes  10.3 Gbits/sec
[  5]   1.50-2.00   sec   726 MBytes  12.2 Gbits/sec
[  5]   2.00-2.50   sec   762 MBytes  12.8 Gbits/sec
[  5]   2.50-3.00   sec   786 MBytes  13.2 Gbits/sec
```

Start `set-tc.sh` on the host and run the iperf3 client again to see the traffic shaper limiting the shortest path to 1 Mbit/s:
```
h1-1:/$ iperf3 -R -i.5 -c 192.168.13.101
Connecting to host 192.168.13.101, port 5201
Reverse mode, remote host 192.168.13.101 is sending
[  5] local 192.168.11.101 port 41202 connected to 192.168.13.101 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-0.50   sec   148 KBytes  2.42 Mbits/sec
[  5]   0.50-1.00   sec  64.6 KBytes  1.06 Mbits/sec
[  5]   1.00-1.50   sec  55.6 KBytes   911 Kbits/sec
[  5]   1.50-2.00   sec  64.6 KBytes  1.05 Mbits/sec
[  5]   2.00-2.50   sec  55.4 KBytes   914 Kbits/sec
...
[  5]   9.00-9.50   sec  55.4 KBytes   907 Kbits/sec
[  5]   9.50-10.00  sec  64.6 KBytes  1.06 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.68  sec  3.03 MBytes  2.38 Mbits/sec    1             sender
[  5]   0.00-10.00  sec  1.27 MBytes  1.07 Mbits/sec                  receiver

iperf Done.
```

# Using gnmic to get gNMI stats

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
