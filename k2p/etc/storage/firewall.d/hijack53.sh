#!/bin/sh
ret_r=0
logger -t "【劫持53端口】" "劫持未经代理的53端口 ..."
gate_local_ip=`/sbin/ifconfig br0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
dnat_rule_num=$(/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|wc -l)
if [ $dnat_rule_num -eq 2 ]; then
	logger -t "【劫持53端口】" "53端口劫持规则状态完整 ~~~"
else
	logger -t "【劫持53端口】" "53端口劫持规则不完整,开始修复 ..."
	let index=1
	[ `/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|grep tcp|wc -l` -eq 0 ] && \
	logger -t "【劫持53端口】" "未发现53端口tcp协议规则,开始修复 ..."
	/bin/iptables -t nat -I PREROUTING $index -p tcp --dport 53 -j DNAT --to $gate_local_ip && \
	logger -t "【劫持53端口】" "劫持53端口tcp协议规则,修复成功 ~~~"
	[ `/bin/iptables -L PREROUTING -t nat -nv|grep 'dpt:53'|grep $gate_local_ip|grep udp|wc -l` -eq 0 ] && \
	logger -t "【劫持53端口】" "未发现53端口tcp协议规则,开始修复 ..."
	/bin/iptables -t nat -I PREROUTING $index -p udp --dport 53 -j DNAT --to $gate_local_ip && \
	logger -t "【劫持53端口】" "劫持53端口udp协议规则,修复成功 ~~~"
fi
exit $ret_r