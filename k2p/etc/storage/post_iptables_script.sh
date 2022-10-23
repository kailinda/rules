#!/bin/sh

### Custom user script
### Called after internal iptables reconfig (firewall update)

logger -t "【FireWall脚本】" "批量执行FireWall初始化脚本集合 ..."
[ ! -d '/etc/storage/firewall.d' ] && mkdir -p /etc/storage/firewall.d
flock -xn /tmp/post_firewall.lock find /etc/storage/firewall.d -type f -perm /111 -exec {} \; &

