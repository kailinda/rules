#!/bin/sh

### Custom user script
### Called after internal WAN up/down action
### $1 - WAN action (up/down)
### $2 - WAN interface name (e.g. eth3 or ppp0)
### $3 - WAN IPv4 address

if [ "$1" == "up" ] ; then
/usr/bin/irqbalance 0
logger -t "【WAN脚本】" "设置除lo之外的网卡 mtu=1492 ..." 
/sbin/ifconfig |grep "Link encap" |awk '{print $1}'|grep -v "lo"|sed -e 's/^/ifconfig /' -e 's/$/ mtu 1492 up/'| /bin/sh
	if [ ! -f '/tmp/wan.up.lock' ] ; then
		touch /tmp/wan.up.lock
		logger -t "【WAN脚本】" "批量执行WAN初始化脚本集合 ..."
		[ ! -d '/etc/storage/wan.d' ] && mkdir -p /etc/storage/wan.d
		[ -d '/etc/storage/wan.d' ] && find /etc/storage/wan.d -type f -perm /111 -exec {} \;
	fi
else
	rm -f /tmp/wan.up.lock
fi

sleep 10 && flock -xn /tmp/wan_dog.lock /usr/bin/wan_dog &
sleep 20 && flock -xn /tmp/wan_dog.lock /usr/bin/wan_dog &
sleep 30 && flock -xn /tmp/wan_dog.lock /usr/bin/wan_dog &

