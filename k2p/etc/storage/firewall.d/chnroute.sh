#!/bin/sh
logger -t "【恢复ipset集合】" "恢复chnroute ..."
if [ `/sbin/ipset list -n|grep -cw chnroute` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute hash:net family inet && logger -t "【恢复ipset集合】" "chnroute集合初始化,成功 ~~~" || { logger -t "【恢复ipset集合】" "chnroute集合初始化,失败 !!!";exit 1;}
	/sbin/ipset -F chnroute && /sbin/ipset -R -exist </etc/storage/chinadns/chnroute.ipset && logger -t "【恢复ipset集合】" "chnroute集合恢复,成功 ~" || { logger -t "【恢复ipset集合】" "chnroute集合恢复,失败 !";exit 1;}
fi
logger -t "【恢复ipset集合】" "恢复chnroute6 ..."
if [ `/sbin/ipset list -n|grep -cw chnroute6` -eq 0 ] ; then
	/sbin/ipset -exist create chnroute6 hash:net family inet6 && logger -t "【恢复ipset集合】" "chnroute6集合初始化,成功 ~~~" || { logger -t "【恢复ipset集合】" "chnroute6集合初始化,失败 !!!";exit 1;}
	/sbin/ipset -F chnroute6 && /sbin/ipset -R -exist </etc/storage/chinadns/chnroute6.ipset && logger -t "【恢复ipset集合】" "chnroute6集合恢复,成功 ~" || { logger -t "【恢复ipset集合】" "chnroute6集合恢复,失败 !";exit 1;}
fi
exit 0