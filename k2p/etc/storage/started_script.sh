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

#drop caches
sync && sync && echo 1 > /proc/sys/vm/drop_caches

logger -t "【Started脚本】" "批量执行Started脚本集合 ..."
[ -d '/etc/storage/started.d' ] && find /etc/storage/started.d -type f -perm /111 -exec flock -xn /tmp/started.d.lock {} \;

