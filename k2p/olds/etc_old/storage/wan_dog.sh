#!/bin/sh
logger_title="[WAN状态探测]"

net_code1=`ping -4 -c 5 -w 10 218.30.118.6 >/dev/null 2>&1 && echo 1 || echo 0`
net_code2=`ping -4 -c 5 -w 10 119.29.29.29 >/dev/null 2>&1 && echo 1 || echo 0`

if [[ "x$net_code1" = "x1" -o "x$net_code2" = "x1" ]]; then
		[ ! -e /tmp/wan_dog_greenled.lock ] && \
		mtk_gpio -w 13 0 && \
        mtk_gpio -w 14 1 && \
        mtk_gpio -w 15 1 && \
        mtk_gpio -w 15 0 && \
		touch /tmp/wan_dog_greenled.lock
		
		[ -e /tmp/wan_dog_redled.lock ] && \
		logger -t "${logger_title}" "【WAN脚本】网络正常，设置蓝灯 ..." && \
		rm -f /tmp/wan_dog_redled.lock
else
		[ -e /tmp/wan_dog_greenled.lock ] && \
		rm -f /tmp/wan_dog_greenled.lock
		
		[ ! -e /tmp/wan_dog_redled.lock ] && \
		logger -t "${logger_title}" "【WAN脚本】网络异常，设置红灯 ..." && \
		mtk_gpio -w 13 0 && \
        mtk_gpio -w 14 1 && \
        mtk_gpio -w 15 1 && \
        mtk_gpio -w 13 1 && \
		touch /tmp/wan_dog_redled.lock
fi

exit 0