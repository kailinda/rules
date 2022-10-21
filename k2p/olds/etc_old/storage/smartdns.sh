#!/bin/sh
logger_title="[SMART_DNS]"

[ -f /tmp/smartdns.lock ] && \
[ `pidof chinadns-ng|wc -l` -gt 0 ] && \
[ `pidof pdnsd|wc -l` -gt 0 ] && \
[ `pidof smartdns|wc -l` -gt 0 ] && \
exit 0

#获取响应状态码  
net_code1=`ping -4 -c 5 -w 10 218.30.118.6 >/dev/null 2>&1 && echo 1 || echo 0`
net_code2=`ping -4 -c 5 -w 10 119.29.29.29 >/dev/null 2>&1 && echo 1 || echo 0`
fastgit_net_code=`ping -4 -c 5 -w 10 raw.fastgit.org >/dev/null 2>&1 && echo 1 || echo 0`

[ "x$fastgit_net_code" = "x1" ] && dwn_url='https://raw.fastgit.org/kailinda/rules/main/smartdns/smartdns.tar.bz2.part'
dwn_url='https://cdn.jsdelivr.net/gh/kailinda/rules@master/smartdns/smartdns.tar.bz2.part'

logger -t "${logger_title}" "【SMART_DNS】准备启动dns序列 ..."

logger -t "${logger_title}" "【SMART_DNS】重置上游DNS为可用状态 ..."
sed -i 's/^#server=/server=/' /etc/storage/dnsmasq/dnsmasq.conf && \
sed -i 's/^#all-servers/all-servers/' /etc/storage/dnsmasq/dnsmasq.conf && \
sed -i 's/^server=127/#server=127/' /etc/storage/dnsmasq/dnsmasq.conf && \
sed -i 's/^conf-file=/#conf-file=/' /etc/storage/dnsmasq/dnsmasq.conf && \
restart_dhcpd || { logger -t "${logger_title}" "【SMART_DNS】配置dnsmasq,失败 !!!!";exit 1;}

if [[ "x$net_code1" = "x1" -o "x$net_code2" = "x1" ]]; then
	logger -t "${logger_title}" "【SMART_DNS】合成smartdns.tar.bz2 ..."
	/usr/bin/curl -4sSkL --retry 3 -o /tmp/smartdns.tar.bz2.partaa ${dwn_url}aa && \
	/usr/bin/curl -4sSkL --retry 3 -o /tmp/smartdns.tar.bz2.partab ${dwn_url}ab && \
	/usr/bin/curl -4sSkL --retry 3 -o /tmp/smartdns.tar.bz2.partac ${dwn_url}ac && \
	/bin/cat /tmp/smartdns.tar.bz2.part* > /tmp/smartdns.tar.bz2 && \
	/bin/rm -f /tmp/smartdns.tar.bz2.part* && \
	logger -t "${logger_title}" "【SMART_DNS】smartdns.tar.bz2已合成 ~~~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】smartdns.tar.bz2合成 失败 !!!";exit 1;}
	
	cd /tmp && \
	/bin/tar -jxf /tmp/smartdns.tar.bz2 && \
	/bin/rm -f /tmp/smartdns.tar.bz2 && \
	chmod 644 /tmp/conf/* /tmp/bin/* /tmp/certs/*
	chmod a+x /tmp/bin/* && \
	logger -t "${logger_title}" "【SMART_DNS】smartdns.tar.bz2已解压 ~~~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】smartdns.tar.bz2解压 失败 !!!";exit 1;}
	
	
	statisticinfo=`ls -lh /tmp/conf/*  /tmp/bin/* |grep "^-" |awk '{printf "%s=%s\n",$9,$5}'`
	for info in ${statisticinfo};do
		logger -t "${logger_title}" "【SMART_DNS】文件大小：${info}"
	done
	
	/sbin/ipset -exist create chnroute hash:net family inet && \
	logger -t "${logger_title}" "【SMART_DNS】chnroute集合初始化,成功 ~~~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】chnroute集合初始化,失败 !!!";exit 1;}
	
	/sbin/ipset -F chnroute && \
	/sbin/ipset -R -exist </tmp/conf/chnroute.ipset && \
	logger -t "${logger_title}" "【SMART_DNS】chnroute集合恢复,成功 ~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】chnroute集合恢复,失败 !";exit 1;}

	/sbin/ipset -exist create chnroute6 hash:net family inet6 && \
	logger -t "${logger_title}" "【SMART_DNS】chnroute6集合初始化,成功 ~~~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】chnroute6集合初始化,失败 !!!";exit 1;}
	
	/sbin/ipset -F chnroute6 && \
	/sbin/ipset -R -exist </tmp/conf/chnroute6.ipset && \
	logger -t "${logger_title}" "【SMART_DNS】chnroute6集合恢复,成功 ~" || \
	{ logger -t "${logger_title}" "【SMART_DNS】chnroute6集合恢复,失败 !";exit 1;}

	if [ ! -f /tmp/conf/chnlist.conf ] ; then
		logger -t "${logger_title}" "【SMART_DNS】开始生成chnlist.conf ~~~"
		cat /tmp/conf/chnlist.txt|grep -E '\.(com|cn)$'|sed -e '/[0-9]\{4,\}/d' -e '/\b[0-9,\-]\+\b/d' -e 's/^/server=\//' -e 's/$/\/127.0.0.1#5303/' > /tmp/conf/chnlist.conf && \
		chmod 644 /tmp/conf/chnlist.conf && \
		logger -t "${logger_title}" "【SMART_DNS】生成chnlist.conf,成功 ~~~" || \
		{ logger -t "${logger_title}" "【SMART_DNS】更新chnlist.conf,失败 !!!";exit 1;}
	else
		logger -t "${logger_title}" "【SMART_DNS】chnlist.conf已存在 ~~~"
	fi
	
	start-stop-daemon -K -n chinadns-ng >/dev/null 2>&1
	killall -q pdnsd >/dev/null 2>&1
	start-stop-daemon -K -n smartdns >/dev/null 2>&1
	[ ! -f /tmp/pdnsd.cache ] && touch /tmp/pdnsd.cache && chown nobody:nogroup /tmp/pdnsd.cache
	
	sleep 3
	
	/sbin/start-stop-daemon -S -c nobody -b -o -q -x /tmp/bin/smartdns -- -c /tmp/conf/smart.conf -p /tmp/smart.pid && logger -t "${logger_title}" "【SMART_DNS】smartdns启动,成功 ~~~" || { logger -t "${logger_title}" "【SMART_DNS】smartdns启动,失败 !!!";exit 1;}
	/tmp/bin/pdnsd -d -4 -c /tmp/conf/pdnsd.conf && logger -t "${logger_title}" "【SMART_DNS】pdnsd启动,成功 ~~~" || { logger -t "${logger_title}" "【SMART_DNS】pdnsd启动,失败 !!!";exit 1;}
	/sbin/start-stop-daemon -S -c nobody -b -o -q -x /tmp/bin/chinadns-ng -- -N -b 127.0.0.1 -l 5300 -c '127.0.0.1#5303,119.29.29.29' -t '127.0.0.1#5302,208.67.222.222#443' -4 chnroute -6 chnroute6 -g /tmp/conf/gfwlist.txt -m /tmp/conf/chnlist.txt && logger -t "${logger_title}" "【SMART_DNS】chinadns-ng启动,成功 ~~~" || { logger -t "${logger_title}" "【SMART_DNS】chinadns-ng启动,失败 !!!";exit 1;}
	
	logger -t "${logger_title}" "【SMART_DNS】恢复上游DNS为本地地址 ..."
	sed -i 's/^server=/#server=/' /etc/storage/dnsmasq/dnsmasq.conf && \
	sed -i 's/^all-servers/#all-servers/' /etc/storage/dnsmasq/dnsmasq.conf && \
	sed -i 's/^#server=127/server=127/' /etc/storage/dnsmasq/dnsmasq.conf && \
	sed -i 's/^#conf-file=/conf-file=/' /etc/storage/dnsmasq/dnsmasq.conf && \
	restart_dhcpd || { logger -t "${logger_title}" "【SMART_DNS】配置dnsmasq,失败 !!!!";exit 1;}

	[ ! -f /tmp/smartdns.lock ] && touch /tmp/smartdns.lock
	echo `date +%Y%m%d` > /tmp/smartdns.lock
	
	#sleep 10 && \
	logger -t "${logger_title}" "【SMART_DNS】开始更新dnsmasq配置 ~~~" && \
	{ /etc/storage/adblock.sh ; restart_dhcpd ;}
	
	sleep 10 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
	sleep 20 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
	sleep 30 && flock -xn /tmp/wan_dog.lock /etc/storage/wan_dog.sh &
else
	logger -t "${logger_title}" "【SMART_DNS】网络不通 !!!"
	logger -t "${logger_title}" "【SMART_DNS】1min后,重新启动dns序列 ..."
	sleep 60
	/etc/storage/smartdns.sh &
	exit 0
fi

