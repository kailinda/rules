#!/bin/sh

### Custom user script for tuning router before start

########################################################
### tune linux kernel
########################################################
# backlog for UNIX sockets
echo 64       > /proc/sys/net/unix/max_dgram_qlen

# igmp
echo 30       > /proc/sys/net/ipv4/igmp_max_memberships

# arp
echo 1        > /proc/sys/net/ipv4/conf/all/arp_announce
echo 1        > /proc/sys/net/ipv4/conf/default/arp_announce

# neigh ipv4
echo 256      > /proc/sys/net/ipv4/neigh/default/gc_thresh1
echo 1024     > /proc/sys/net/ipv4/neigh/default/gc_thresh2
echo 2048     > /proc/sys/net/ipv4/neigh/default/gc_thresh3

# ipv6
if [ -d /proc/sys/net/ipv6 ] ; then
  echo 256    > /proc/sys/net/ipv6/neigh/default/gc_thresh1
  echo 1024   > /proc/sys/net/ipv6/neigh/default/gc_thresh2
  echo 2048   > /proc/sys/net/ipv6/neigh/default/gc_thresh3
  echo 16384  > /proc/sys/net/ipv6/route/max_size
fi

# reverse-path filter
echo 1        > /proc/sys/net/ipv4/conf/default/rp_filter
echo 1        > /proc/sys/net/ipv4/conf/eth2/rp_filter

# conntrack
echo 0        > /proc/sys/net/netfilter/nf_conntrack_checksum
echo 1        > /proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal
echo 300      > /proc/sys/net/netfilter/nf_conntrack_generic_timeout
echo 1800     > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
echo 30       > /proc/sys/net/netfilter/nf_conntrack_icmp_timeout
echo 50       > /proc/sys/net/netfilter/nf_conntrack_udp_timeout

echo 30 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
echo 120 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream
echo 15 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
echo 15 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_recv
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_fin_wait
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_last_ack
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_time_wait
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close

# panic
echo 1        > /proc/sys/kernel/panic
echo 1        > /proc/sys/kernel/panic_on_oops
echo 0        > /proc/sys/vm/panic_on_oom

