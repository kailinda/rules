#!/bin/sh

### Custom user script
### Called after router started and network is ready

### Example - load ipset modules
#modprobe ip_set
#modprobe ip_set_hash_ip
#modprobe ip_set_hash_net
#modprobe ip_set_bitmap_ip
#modprobe ip_set_list_set
#modprobe xt_set

#cpu
echo 8 > /proc/irq/11/smp_affinity
echo 4 > /proc/irq/12/smp_affinity


echo f >/sys/class/net/br0/queues/rx-0/rps_cpus
echo 4 >/sys/class/net/ra0/queues/rx-0/rps_cpus
echo 8 >/sys/class/net/ra1/queues/rx-0/rps_cpus
echo 4 >/sys/class/net/rax0/queues/rx-0/rps_cpus
echo 8 >/sys/class/net/rax1/queues/rx-0/rps_cpus
echo 8 >/sys/class/net/eth2/queues/rx-0/rps_cpus
echo 3 >/sys/class/net/eth3/queues/rx-0/rps_cpus
[[ -f /sys/class/net/ppp0/queues/rx-0/rps_cpus ]] && \
echo c > /sys/class/net/ppp0/queues/rx-0/rps_cpus


echo f >/sys/class/net/br0/queues/tx-0/xps_cpus
echo 4 >/sys/class/net/ra0/queues/tx-0/xps_cpus
echo 8 >/sys/class/net/ra1/queues/tx-0/xps_cpus
echo 4 >/sys/class/net/rax0/queues/tx-0/xps_cpus
echo 8 >/sys/class/net/rax1/queues/tx-0/xps_cpus
echo 8 >/sys/class/net/eth2/queues/tx-0/xps_cpus
echo 3 >/sys/class/net/eth3/queues/tx-0/xps_cpus
[[ -f /sys/class/net/ppp0/queues/tx-0/xps_cpus ]] && \
echo c > /sys/class/net/ppp0/queues/tx-0/xps_cpus

echo 256 > /sys/class/net/br0/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/ra0/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/ra1/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/rax0/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/rax1/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/eth2/queues/rx-0/rps_flow_cnt
echo 256 > /sys/class/net/eth3/queues/rx-0/rps_flow_cnt
[[ -f /sys/class/net/ppp0/queues/rx-0/rps_flow_cnt ]] && \
echo 256 > /sys/class/net/ppp0/queues/rx-0/rps_flow_cnt

echo 1024 > /proc/sys/net/core/rps_sock_flow_entries

#drop caches
sync && echo 3 > /proc/sys/vm/drop_caches

# Mount SATA disk
#mdev -s

