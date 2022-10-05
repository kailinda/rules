#!/bin/sh

### Custom user script
### Called before router shutdown
### $1 - action (0: reboot, 1: halt, 2: power-off)

logger_title="[ShutDown]"
logger -t "${logger_title}" "【关机脚本】重置上游DNS ..."
sed -i 's/^#server=/server=/' /etc/storage/dnsmasq/dnsmasq.conf
sed -i 's/^#all-servers/all-servers/' /etc/storage/dnsmasq/dnsmasq.conf
sed -i 's/^server=127/#server=127/' /etc/storage/dnsmasq/dnsmasq.conf
#去除挂载目录
logger -t "${logger_title}" "【关机脚本】卸载挂载目录 ..."
[ `df|grep anti-ad-for-dnsmasq|wc -l` -eq 1 ] && umount /etc/storage/dnsmasq/conf.d/anti-ad-for-dnsmasq.conf
[ `df|grep chnlist|wc -l` -eq 1 ] && umount /etc/storage/dnsmasq/conf.d/chnlist.conf
sed -i 's/^conf-file=/#conf-file=/' /etc/storage/dnsmasq/dnsmasq.conf
