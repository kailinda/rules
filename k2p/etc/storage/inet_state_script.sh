#!/bin/sh

### Custom user script
### Called on Internet status changed
### $1 - Internet status (0/1)
### $2 - elapsed time (s) from previous state

logger -t "【WAN脚本】" "网络状态: $1, 间隔时间: $2s."
if [ "$1" == "0" ];then
# 网络不通，红灯
logger -t "【WAN脚本】" "网络异常，设置红灯 ..." 
        mtk_gpio -w 13 0
        mtk_gpio -w 14 1
        mtk_gpio -w 15 1
        mtk_gpio -w 13 1
else
# 网络已通，蓝灯
logger -t "【WAN脚本】" "网络正常，设置蓝灯 ..." 
        mtk_gpio -w 13 0
        mtk_gpio -w 14 1
        mtk_gpio -w 15 1
        mtk_gpio -w 15 0
fi

