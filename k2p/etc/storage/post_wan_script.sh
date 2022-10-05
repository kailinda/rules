#!/bin/sh

### Custom user script
### Called after internal WAN up/down action
### $1 - WAN action (up/down)
### $2 - WAN interface name (e.g. eth3 or ppp0)
### $3 - WAN IPv4 address

logger_title="[WAN已开启]"
if [ $1 = "up" ] ; then
logger -t "${logger_title}" "【WAN脚本】设置除lo之外的网卡 mtu=1492 ..." 
/sbin/ifconfig |grep "Link encap" |awk '{print $1}'|grep -v "lo"|sed -e 's/^/ifconfig /' -e 's/$/ mtu 1492 up/'| /bin/sh
	if [ ! -f '/tmp/wan.up.lock' ] ; then
		touch /tmp/wan.up.lock
		logger -t "${logger_title}" "【WAN脚本】执行smartdns.sh ..." && \
		sleep 15
		flock -xn /tmp/smartdns.lock /etc/storage/smartdns.sh
	fi
else
	rm -f /tmp/wan.up.lock
fi

sleep 10 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
sleep 20 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
sleep 30 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
