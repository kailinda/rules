#!/bin/sh

killall -q pdnsd >/dev/null 2>&1
[ ! -f /tmp/pdnsd.cache ] && \
touch /tmp/pdnsd.cache && \
chown nobody:nogroup /tmp/pdnsd.cache && \
/usr/bin/pdnsd -d -4 -c /etc/storage/pdnsd/pdnsd.conf && \
logger -t "【PDNSD】" "pdnsd启动,成功 ~~~" || \
{ logger -t "【PDNSD】" "pdnsd启动,失败 !!!";exit 1;}
exit 0