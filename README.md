# IBR Testbed
Uses an enhanced version of the danet gnmi-target (https://code.fbi.h-da.de/danet/gnmi-target) installed and running in the provided FRR container image (https://hub.docker.com/r/flex/frr-gnmi-target).

# Running the testbed
Start containerlab as usual (`sudo clab deploy`). The extended stat counters can be retrieved, e.g., using gnmic or directly from the consoles of the containers.

# Example PBR setup

Start iperf3 on h3-1:
```bash
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

Run `set-tc.sh` on the host and run the iperf3 client again to see the traffic shaper limiting the shortest path (h1-1 <-> r1 <-> r3 <-> h3-1, see [topology](viewport-containerlab-ibr.svg)) to 1 Mbit/s:
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
```

Run `set-pbr.sh` to route traffic from TCP source port 10000 over h2 offering 2 Mbit/s on the path h1-1 <-> r1 <-> r2 <-> r3 <-> h3-1:
```
h1-1:/$ iperf3 -R --cport 10000 -c 192.168.13.101
Connecting to host 192.168.13.101, port 5201
Reverse mode, remote host 192.168.13.101 is sending
[  5] local 192.168.11.101 port 10000 connected to 192.168.13.101 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   255 KBytes  2.09 Mbits/sec
[  5]   1.00-2.00   sec   244 KBytes  1.99 Mbits/sec
[  5]   2.00-3.00   sec   240 KBytes  1.96 Mbits/sec
...
[  5]   7.00-8.00   sec   240 KBytes  1.97 Mbits/sec
[  5]   8.00-9.00   sec   240 KBytes  1.97 Mbits/sec
[  5]   9.00-10.00  sec   240 KBytes  1.97 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.04  sec  3.73 MBytes  3.12 Mbits/sec    1             sender
[  5]   0.00-10.00  sec  2.38 MBytes  2.00 Mbits/sec                  receiver
```

Using iperf3 -P 2 we can use both paths for the application to achieve 3 Mbit/s:
```
h1-1:/$ iperf3 -R --cport 10000 -P 2 -c 192.168.13.101
Connecting to host 192.168.13.101, port 5201
Reverse mode, remote host 192.168.13.101 is sending
[  5] local 192.168.11.101 port 10000 connected to 192.168.13.101 port 5201
[  7] local 192.168.11.101 port 10001 connected to 192.168.13.101 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   369 KBytes  3.03 Mbits/sec
[  7]   0.00-1.00   sec   212 KBytes  1.74 Mbits/sec
[SUM]   0.00-1.00   sec   582 KBytes  4.76 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   1.00-2.00   sec   240 KBytes  1.97 Mbits/sec
[  7]   1.00-2.00   sec   120 KBytes   985 Kbits/sec
[SUM]   1.00-2.00   sec   360 KBytes  2.95 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   2.00-3.00   sec   240 KBytes  1.97 Mbits/sec
[  7]   2.00-3.00   sec   120 KBytes   979 Kbits/sec
[SUM]   2.00-3.00   sec   359 KBytes  2.94 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   3.00-4.00   sec   249 KBytes  2.04 Mbits/sec
[  7]   3.00-4.00   sec   120 KBytes   983 Kbits/sec
[SUM]   3.00-4.00   sec   369 KBytes  3.02 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
...
```

After also running `set-pbr-2.sh`, TCP traffic from source port 10002 will be routed over r4 and r5 (single link currently) adding 4 Mbit/s achieving a total sum of 7 Mbit/s across all three paths:
```
h1-1:/$ iperf3 -R --cport 10000 -P 3 -c 192.168.13.101
Connecting to host 192.168.13.101, port 5201
Reverse mode, remote host 192.168.13.101 is sending
[  5] local 192.168.11.101 port 10000 connected to 192.168.13.101 port 5201
[  7] local 192.168.11.101 port 10001 connected to 192.168.13.101 port 5201
[  9] local 192.168.11.101 port 10002 connected to 192.168.13.101 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec   369 KBytes  3.03 Mbits/sec
[  7]   0.00-1.00   sec   212 KBytes  1.74 Mbits/sec
[  9]   0.00-1.00   sec   609 KBytes  4.99 Mbits/sec
[SUM]   0.00-1.00   sec  1.16 MBytes  9.75 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   1.00-2.00   sec   240 KBytes  1.96 Mbits/sec
[  7]   1.00-2.00   sec   120 KBytes   984 Kbits/sec
[  9]   1.00-2.00   sec   489 KBytes  4.00 Mbits/sec
[SUM]   1.00-2.00   sec   849 KBytes  6.95 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   2.00-3.00   sec   240 KBytes  1.97 Mbits/sec
[  7]   2.00-3.00   sec   120 KBytes   979 Kbits/sec
[  9]   2.00-3.00   sec   480 KBytes  3.93 Mbits/sec
[SUM]   2.00-3.00   sec   839 KBytes  6.88 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
[  5]   3.00-4.00   sec   249 KBytes  2.04 Mbits/sec
[  7]   3.00-4.00   sec   120 KBytes   983 Kbits/sec
[  9]   3.00-4.00   sec   489 KBytes  4.01 Mbits/sec
[SUM]   3.00-4.00   sec   858 KBytes  7.03 Mbits/sec
- - - - - - - - - - - - - - - - - - - - - - - - -
...
```

PBR and traffic shaping can be removed by running `remove-pbr-2-hop.sh`, `remove-pbr.sh` and `remove-tc.sh`.

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

# Destroying the testbed

Run `sudo clab destroy` in the main folder of the repo.
