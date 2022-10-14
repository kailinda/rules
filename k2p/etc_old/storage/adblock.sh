#!/bin/sh

logger_title="[ADBLOCK]"
logger -t "${logger_title}" "【ADBLOCK】try upgrade ..."

#github_net_code=`ping -4 -c 5 -w 10 github.com >/dev/null 2>&1 && echo 1 || echo 0`
raw_github_net_code=`ping -4 -c 5 -w 10 raw.githubusercontent.com >/dev/null 2>&1 && echo 1 || echo 0`
api_github_net_code=`ping -4 -c 5 -w 10 api.github.com >/dev/null 2>&1 && echo 1 || echo 0`
#cdn_net_code=`ping -4 -c 5 -w 10 cdn.jsdelivr.net >/dev/null 2>&1 && echo 1 || echo 0`
antiad_net_code=`ping -4 -c 5 -w 10 anti-ad.net >/dev/null 2>&1 && echo 1 || echo 0`
raw_fastgit_net_code=`ping -4 -c 5 -w 10 raw.fastgit.org >/dev/null 2>&1 && echo 1 || echo 0`
download_fastgit_net_code=`ping -4 -c 5 -w 10 download.fastgit.org >/dev/null 2>&1 && echo 1 || echo 0`

logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf ..."
if [ "x$raw_fastgit_net_code" = "x1" ] ; then
	NX_URL='https://raw.fastgit.org/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf'
	curl -4sSkL --retry 3 -o /tmp/bogus-nxdomain.conf.tmp $NX_URL && \
	mv -f /tmp/bogus-nxdomain.conf.tmp /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	chmod 644 /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf && \
	logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf(行数:`wc -l /etc/storage/dnsmasq/conf.d/bogus-nxdomain.conf|cut -f1 -d ' '`),成功" || \
	logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf,失败 !!!"
	[ -f /tmp/bogus-nxdomain.conf.tmp ] && rm -f /tmp/bogus-nxdomain.conf.tmp
else
	logger -t "${logger_title}" "【ADBLOCK】更新bogus-nxdomain.conf,网络不通 !!!"
fi

logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件 ..."
if [ "x$raw_fastgit_net_code" = "x1" ] ; then
	GT_URL='https://raw.fastgit.org/hacamer/filtering/master/hosts'
	curl -4sSkL --retry 3 -o /tmp/fast-github.host.tmp $GT_URL && \
	mv -f /tmp/fast-github.host.tmp /etc/storage/dnsmasq/fast-github.host && \
	chmod 644 /etc/storage/dnsmasq/fast-github.host && \
	logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件(行数:`wc -l /etc/storage/dnsmasq/fast-github.host|cut -f1 -d ' '`),成功" || \
	logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件,失败 !!!"
	[ -f /tmp/fast-github.host.tmp ] && rm -f /tmp/fast-github.host.tmp
else
	logger -t "${logger_title}" "【ADBLOCK】更新 github加速文件,网络不通 !!!"
fi

logger -t "${logger_title}" "【ADBLOCK】更新 antiad广告文件 ..."
if [ "x$antiad_net_code" = "x1" ] ; then
	GT_URL='https://anti-ad.net/anti-ad-for-dnsmasq.conf'
	[ ! -d /tmp/conf/ ] && mkdir -p /tmp/conf/
	curl -4sSkL --retry 3 -o /tmp/conf/antiad.conf $GT_URL && \
	chmod 644 /tmp/conf/antiad.conf && \
	logger -t "${logger_title}" "【ADBLOCK】更新 antiad广告文件(行数:`wc -l /tmp/conf/antiad.conf|cut -f1 -d ' '`),成功" || \
	logger -t "${logger_title}" "【ADBLOCK】更新 antiad广告文件,失败 !!!"
else
	logger -t "${logger_title}" "【ADBLOCK】更新 antiad广告文件,网络不通 !!!"
fi

logger -t "${logger_title}" "【ADBLOCK】更新 smartdns程序文件 ..."
if [ -f /tmp/bin/smartdns -a "x$api_github_net_code" = "x1" ] ; then
	MD5_ORAGIN=`md5sum /tmp/bin/smartdns |cut -f1 -d ' '`
	#UPD_URL=`/usr/bin/curl -4sSkL --retry 3 https://api.github.com/repos/pymumu/smartdns/releases/latest|grep -i smartdns-mipsel|grep -i download_url|cut -d\" -f 4`
	TAG_RELEASE=`/usr/bin/curl -4sSkL --retry 3 https://api.github.com/repos/pymumu/smartdns/releases/latest|grep -i tag_name|cut -d\" -f 4`
	[ "x$download_fastgit_net_code" = "x1" ] && UPD_URL="https://download.fastgit.org/pymumu/smartdns/releases/download/$TAG_RELEASE/smartdns-mipsel" || \
	UPD_URL="https://github.com/pymumu/smartdns/releases/download/$TAG_RELEASE/smartdns-mipsel"
	GT_URL="$UPD_URL"
	curl -4sSkL --retry 3 -o /tmp/bin/smartdns.tmp $GT_URL && \
	MD5_NEW=`md5sum /tmp/bin/smartdns.tmp |cut -f1 -d ' '` && \
	if [ "x$MD5_ORAGIN" = "x$MD5_NEW" ] ; then
		logger -t "${logger_title}" "【ADBLOCK】停止更新 smartdns程序文件,新旧版本一样"
		logger -t "${logger_title}" "【ADBLOCK】md5值(旧smartdns):$MD5_ORAGIN"
		logger -t "${logger_title}" "【ADBLOCK】md5值(新smartdns):$MD5_NEW"
		logger -t "${logger_title}" "【ADBLOCK】tag值(新smartdns):$TAG_RELEASE"
	else
		chmod 755 /tmp/bin/smartdns.tmp && \
		mv -f /tmp/bin/smartdns.tmp /tmp/bin/smartdns && \
		logger -t "${logger_title}" "【ADBLOCK】更新 smartdns程序文件,成功" && \
		logger -t "${logger_title}" "【ADBLOCK】md5值(旧smartdns):$MD5_ORAGIN" && \
		logger -t "${logger_title}" "【ADBLOCK】md5值(新smartdns):$MD5_NEW" && \
		logger -t "${logger_title}" "【ADBLOCK】tag值(新smartdns):$TAG_RELEASE" || \
		logger -t "${logger_title}" "【ADBLOCK】更新 smartdns程序文件,失败 !!!"
		
		if [ $? -eq 0 ] ; then
			logger -t "${logger_title}" "【ADBLOCK】重启 smartdns程序 ..."
			start-stop-daemon -K -n smartdns >/dev/null 2>&1 && \
			/sbin/start-stop-daemon -S -c nobody -b -o -q -x /tmp/bin/smartdns -- -c /tmp/conf/smart.conf -p /tmp/smart.pid && \
			logger -t "${logger_title}" "【ADBLOCK】重启 smartdns程序,成功 ~~~" || \
			logger -t "${logger_title}" "【ADBLOCK】重启 smartdns程序,失败 !!!"
		fi
	fi
	[ -f /tmp/bin/smartdns.tmp ] && rm -f /tmp/bin/smartdns.tmp
else
	logger -t "${logger_title}" "【ADBLOCK】更新 smartdns程序文件,网络不通 !!!"
fi

exit 0