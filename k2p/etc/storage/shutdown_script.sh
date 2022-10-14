#!/bin/sh

### Custom user script
### Called before router shutdown
### $1 - action (0: reboot, 1: halt, 2: power-off)

logger -t "【Shutdown脚本】" "批量执行Shutdown脚本集合 ..."
[ -d '/etc/storage/shutdown.d' ] && find /etc/storage/shutdown.d -type f -perm /111 -exec {} \;

