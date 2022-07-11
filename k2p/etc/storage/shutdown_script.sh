#!/bin/sh

### Custom user script
### Called before router shutdown
### $1 - action (0: reboot, 1: halt, 2: power-off)

logger_title="[ShutDown]"
logger -t "${logger_title}" "【关机脚本】重置上游DNS ..."
sed -i 's/^#server=202.141.162.123/server=202.141.162.123/' /etc/storage/dnsmasq/dnsmasq.conf
sed -i 's/^#server=101.6.6.6/server=101.6.6.6/' /etc/storage/dnsmasq/dnsmasq.conf
sed -i 's/^#all-servers/all-servers/' /etc/storage/dnsmasq/dnsmasq.conf
sed -i 's/^server=127.0.0.1/#server=127.0.0.1/' /etc/storage/dnsmasq/dnsmasq.conf
#去除anti-ad脚本，停用过滤广告dns
#logger -t "${logger_title}" "【关机脚本】卸载anti-ad ..."
#[ `df|grep anti-ad-for-dnsmasq|wc -l` -eq 1 ] && umount /etc/storage/dnsmasq/conf.d/anti-ad-for-dnsmasq.conf
#[ `df|grep chnlist|wc -l` -eq 1 ] && umount /etc/storage/dnsmasq/conf.d/chnlist.conf
