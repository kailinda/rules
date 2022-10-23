#!/bin/sh
PATH=/etc/storage/bin:$PATH
export PATH
/sbin/start-stop-daemon -K -n smartdns >/dev/null 2>&1
logger -t "【SMART_DNS】" "测试本地53端口 ..."
TCPING_TEST=1
while [ $TCPING_TEST -ne 0 ];do
	sleep 3
	tcping 127.0.0.1 -p 53 -c 5 -i 1 2>&1 >/dev/null
	TCPING_TEST=$?
done
logger -t "【SMART_DNS】" "本地53端口已启动 ~~~"
logger -t "【SMART_DNS】" "测试本地DNS解析 ..."
for domain in `grep https /etc/storage/smartdns/smartdns.conf |grep -v '#'|awk '{print $2}'`;  
do   
	DNS_TEST="0.000000"
	while [ "$DNS_TEST" == "0.000000" ];do
		sleep 3
		DNS_TEST=`curl -o /dev/null -s -w %{time_connect} $domain`
	done
done
logger -t "【SMART_DNS】" "本地DNS解析正常 ~~~"
sleep 3
logger -t "【SMART_DNS】" "smartdns正在启动中 ..."
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

