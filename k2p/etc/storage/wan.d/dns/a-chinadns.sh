#!/bin/sh

if [ `/sbin/ipset list -n|grep -cw chnroute` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute hash:net family inet && logger -t "【CHINA_DNS_NG】" "chnroute集合初始化,成功 ~~~" || { logger -t "【CHINA_DNS_NG】" "chnroute集合初始化,失败 !!!";exit 1;}
	/sbin/ipset -F chnroute && /sbin/ipset -R -exist </etc/storage/chinadns/chnroute.ipset && logger -t "【CHINA_DNS_NG】" "chnroute集合恢复,成功 ~" || { logger -t "【CHINA_DNS_NG】" "chnroute集合恢复,失败 !";exit 1;}
fi

if [ `/sbin/ipset list -n|grep -cw chnroute6` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute6 hash:net family inet6 && logger -t "【CHINA_DNS_NG】" "chnroute6集合初始化,成功 ~~~" || { logger -t "【CHINA_DNS_NG】" "chnroute6集合初始化,失败 !!!";exit 1;}
	/sbin/ipset -F chnroute6 && /sbin/ipset -R -exist </etc/storage/chinadns/chnroute6.ipset && logger -t "【CHINA_DNS_NG】" "chnroute6集合恢复,成功 ~" || { logger -t "【CHINA_DNS_NG】" "chnroute6集合恢复,失败 !";exit 1;}
fi

start-stop-daemon -K -n chinadns-ng >/dev/null 2>&1
/sbin/start-stop-daemon -S -c nobody -b -o -q -x /usr/bin/chinadns-ng -- -b 127.0.0.1 -l 5301 -c 127.0.0.1#5601 -t 127.0.0.1#5602 -4 chnroute -6 chnroute6 -f -M -m /etc/storage/chinadns/chnlist.txt && \
logger -t "【CHINA_DNS_NG】" "chinadns-ng启动,成功 ~~~" || \
{ logger -t "【CHINA_DNS_NG】" "chinadns-ng启动,失败 !!!";exit 1;}
exit 0

