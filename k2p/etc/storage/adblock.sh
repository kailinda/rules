#!/bin/sh

logger_title="[ADBLOCK]"
logger -t "${logger_title}" "【ADBLOCK】try upgrade ..."

github_net_code=`ping -4 -c 3 -w 5 raw.githubusercontent.com >/dev/null 2>&1 && echo 1 || echo 0`
cdn_net_code=`ping -4 -c 3 -w 5 cdn.jsdelivr.net >/dev/null 2>&1 && echo 1 || echo 0`
antiad_net_code=`ping -4 -c 3 -w 5 anti-ad.net >/dev/null 2>&1 && echo 1 || echo 0`

[ ! "x$github_net_code" = "x1" ] && [ ! "x$cdn_net_code" = "x1" ] && [ ! "x$antiad_net_code" = "x1" ] && \
logger -t "${logger_title}" "【ADBLOCK】无法ping通域名 ..." && \
exit 0

logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf ..."
[ "x$cdn_net_code" = "x1" ] && NX_URL='https://cdn.jsdelivr.net/gh/felixonmars/dnsmasq-china-list@master/bogus-nxdomain.china.conf'
if [ "x$cdn_net_code" = "x1" ] ; then
	curl -4sSkL -o /tmp/bogus-nxdomain.conf.tmp $NX_URL && \
	mv -f /tmp/bogus-nxdomain.conf.tmp /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	chmod 644 /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf,成功" || \
	{ logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf,失败" ; \
	[ -f /tmp/bogus-nxdomain.conf.tmp ] && rm -f /tmp/bogus-nxdomain.conf.tmp ; \
	exit 1 ; }
	[ -f /tmp/bogus-nxdomain.conf.tmp ] && rm -f /tmp/bogus-nxdomain.conf.tmp
fi

logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件 ..."
[ "x$cdn_net_code" = "x1" ] && GT_URL='https://cdn.jsdelivr.net/gh/hacamer/filtering@master/hosts'
if [ "x$cdn_net_code" = "x1" ] ; then
	curl -4sSkL -o /tmp/fast-github.host.tmp $GT_URL && \
	mv -f /tmp/fast-github.host.tmp /etc/storage/dnsmasq/fast-github.host && \
	chmod 644 /etc/storage/dnsmasq/fast-github.host && \
	logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件,成功" || \
	{ logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件,失败" ; \
	[ -f /tmp/fast-github.host.tmp ] && rm -f /tmp/fast-github.host.tmp ; \
	exit 1 ; }
	[ -f /tmp/fast-github.host.tmp ] && rm -f /tmp/fast-github.host.tmp
fi

exit 0