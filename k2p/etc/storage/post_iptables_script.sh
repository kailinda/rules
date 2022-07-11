#!/bin/sh

### Custom user script
### Called after internal iptables reconfig (firewall update)

logger_title="[防火墙已启动]"
logger -t "${logger_title}" "【劫持53端口】劫持未经代理的53端口 ..."
gate_local_ip=`/sbin/ifconfig br0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
dnat_rule_num=$(/bin/iptables -L PREROUTING -t nat --line-numbers|grep DNAT|grep $gate_local_ip|wc -l)
if [ $dnat_rule_num -eq 2 ]; then
	logger -t "${logger_title}" "【劫持53端口】发现劫持53端口规则,准备退出 ..."
else
	logger -t "${logger_title}" "【劫持53端口】未发现劫持53端口规则或不完整,开始修复 ..."
	let Number=ss_spec_lan_dns_rule_num+1
	dnat_tcp_rule_num=$(/bin/iptables -L PREROUTING -t nat --line-numbers|grep DNAT|grep $gate_local_ip|grep tcp|wc -l)
	[ $dnat_tcp_rule_num -eq 0 ] && /bin/iptables -t nat -I PREROUTING $Number -p tcp --dport 53 -j DNAT --to $gate_local_ip || { /bin/iptables -t nat -D PREROUTING -p tcp --dport 53 -j DNAT --to $gate_local_ip && /bin/iptables -t nat -I PREROUTING $Number -p tcp --dport 53 -j DNAT --to $gate_local_ip;}
	dnat_udp_rule_num=$(/bin/iptables -L PREROUTING -t nat --line-numbers|grep DNAT|grep $gate_local_ip|grep udp|wc -l)
	[ $dnat_udp_rule_num -eq 0 ] && /bin/iptables -t nat -I PREROUTING $Number -p udp --dport 53 -j DNAT --to $gate_local_ip || { /bin/iptables -t nat -D PREROUTING -p udp --dport 53 -j DNAT --to $gate_local_ip && /bin/iptables -t nat -I PREROUTING $Number -p udp --dport 53 -j DNAT --to $gate_local_ip;}
fi

if [ -f /tmp/smartdns.lock ] && [ `/sbin/ipset list -n|grep -cw chnroute` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute hash:net family inet && logger -t "${logger_title}" "【SMART_DNS】chnroute集合初始化,成功 ~~~" || { logger -t "${logger_title}" "【SMART_DNS】chnroute集合初始化,失败 !!!";exit 0;}
	/sbin/ipset -F chnroute && /sbin/ipset -R -exist </tmp/conf/chnroute.ipset && logger -t "${logger_title}" "【SMART_DNS】chnroute集合恢复,成功 ~" || { logger -t "${logger_title}" "【SMART_DNS】chnroute集合恢复,失败 !";exit 0;}
fi

if [ -f /tmp/smartdns.lock ] && [ `/sbin/ipset list -n|grep -cw chnroute6` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute6 hash:net family inet6 && logger -t "${logger_title}" "【SMART_DNS】chnroute6集合初始化,成功 ~~~" || { logger -t "${logger_title}" "【SMART_DNS】chnroute6集合初始化,失败 !!!";exit 0;}
	/sbin/ipset -F chnroute6 && /sbin/ipset -R -exist </tmp/conf/chnroute6.ipset && logger -t "${logger_title}" "【SMART_DNS】chnroute6集合恢复,成功 ~" || { logger -t "${logger_title}" "【SMART_DNS】chnroute6集合恢复,失败 !";exit 0;}
fi