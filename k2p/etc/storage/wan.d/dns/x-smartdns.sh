#!/bin/sh
/sbin/start-stop-daemon -K -n smartdns >/dev/null 2>&1
sleep 3
/sbin/start-stop-daemon -S -c nobody -b -o -q -m -p /tmp/smartdns.pid -x /usr/bin/smartdns -- -c /etc/storage/smartdns/smartdns.conf
if [ $? -eq 0 ];then
	logger -t "【SMART_DNS】" "smartdns启动,成功 ~~~"
	sleep 10
	logger -t "【SMART_DNS】" "清理smartdns日志 ~"
	> /tmp/smartdns.log
else
	logger -t "【SMART_DNS】" "smartdns启动,失败 !!!"
	exit 1
fi
exit 0

