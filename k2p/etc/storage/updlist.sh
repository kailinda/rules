#!/bin/sh
logger -t "【ADBLOCK】" "开始更新规则列表 ..."

#github_net_code=`ping -4 -c 5 -w 10 github.com >/dev/null 2>&1 && echo 1 || echo 0`
#raw_github_net_code=`ping -4 -c 5 -w 10 raw.githubusercontent.com >/dev/null 2>&1 && echo 1 || echo 0`
#api_github_net_code=`ping -4 -c 5 -w 10 api.github.com >/dev/null 2>&1 && echo 1 || echo 0`
#cdn_net_code=`ping -4 -c 5 -w 10 cdn.jsdelivr.net >/dev/null 2>&1 && echo 1 || echo 0`
raw_fastgit_net_code=`ping -4 -c 5 -w 10 raw.fastgit.org >/dev/null 2>&1 && echo 1 || echo 0`
#download_fastgit_net_code=`ping -4 -c 5 -w 10 download.fastgit.org >/dev/null 2>&1 && echo 1 || echo 0`

logger -t "【ADBLOCK】" "更新bogus-nxdomain.conf ..."
if [ "x$raw_fastgit_net_code" = "x1" ] ; then
	NX_URL='https://raw.fastgit.org/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf'
	curl -4sSkL --retry 3 -o /tmp/bogus-nxdomain.conf.tmp $NX_URL && \
	mv -f /tmp/bogus-nxdomain.conf.tmp /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	chmod 644 /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	logger -t "【ADBLOCK】" "更新bogus-nxdomain.conf(行数:`wc -l /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf|cut -f1 -d ' '`),成功" || \
	logger -t "【ADBLOCK】" "更新bogus-nxdomain.conf,失败 !!!"
	[ -f /tmp/bogus-nxdomain.conf.tmp ] && rm -f /tmp/bogus-nxdomain.conf.tmp
else
	logger -t "【ADBLOCK】" "更新bogus-nxdomain.conf,网络不通 !!!"
fi

logger -t "【ADBLOCK】" "更新 github加速文件 ..."
if [ "x$raw_fastgit_net_code" = "x1" ] ; then
	GT_URL='https://raw.fastgit.org/hacamer/filtering/master/hosts'
	curl -4sSkL --retry 3 -o /tmp/fast-github.host.tmp $GT_URL && \
	mv -f /tmp/fast-github.host.tmp /etc/storage/dnsmasq/fast-github.host && \
	chmod 644 /etc/storage/dnsmasq/fast-github.host && \
	logger -t "【ADBLOCK】" "更新 github加速文件(行数:`wc -l /etc/storage/dnsmasq/fast-github.host|cut -f1 -d ' '`),成功" || \
	logger -t "【ADBLOCK】" "更新 github加速文件,失败 !!!"
	[ -f /tmp/fast-github.host.tmp ] && rm -f /tmp/fast-github.host.tmp
else
	logger -t "【ADBLOCK】" "更新 github加速文件,网络不通 !!!"
fi