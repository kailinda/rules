#!/bin/sh

logger -t "【劫持53端口】" "劫持未经代理的53端口 ..."
gate_local_ip=`/sbin/ifconfig br0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
dnat_rule_num=$(/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|wc -l)
if [ $dnat_rule_num -eq 2 ]; then
	logger -t "【劫持53端口】" "发现劫持53端口规则,准备退出 ..."
else
	logger -t "【劫持53端口】" "未发现劫持53端口规则或不完整,开始修复 ..."
	let index=1
	dnat_tcp_rule_num=$(/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|grep tcp|wc -l)
	[ $dnat_tcp_rule_num -eq 0 ] && /bin/iptables -t nat -I PREROUTING $index -p tcp --dport 53 -j DNAT --to $gate_local_ip
	dnat_udp_rule_num=$(/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|grep udp|wc -l)
	[ $dnat_udp_rule_num -eq 0 ] && /bin/iptables -t nat -I PREROUTING $index -p udp --dport 53 -j DNAT --to $gate_local_ip
fi