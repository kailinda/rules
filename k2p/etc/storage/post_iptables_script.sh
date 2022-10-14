#!/bin/sh

### Custom user script
### Called after internal iptables reconfig (firewall update)

logger -t "【FireWall脚本】" "批量执行FireWall初始化脚本集合 ..."
[ -d '/etc/storage/firewall.d' ] && find /etc/storage/firewall.d -type f -perm /111 -exec flock -xn /tmp/firewall.d.lock {} \;

