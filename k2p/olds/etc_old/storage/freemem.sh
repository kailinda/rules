#!/bin/sh
logger_title="[FREEMEM]"

TOTALMEM=`cat /proc/meminfo |grep -i memtotal|awk '{print $2}'`
FREEMEM=`cat /proc/meminfo |grep -i memfree|awk '{print $2}'`
NUMFLAG=`expr $TOTALMEM / $FREEMEM`
if [ $NUMFLAG -ge 4 ] ; then

	LOADAVG=`cat /proc/loadavg |awk '{print $1}'|sed 's/\.//'`
	
	if [ -f /tmp/freemem.time ] ; then
		
		[ $LOADAVG -gt 080 ] && exit 0
		
		LASTTIME=`cat /tmp/freemem.time`
		LASTTIMESECS=`date -d "$LASTTIME" +%s`
		NOWTIME=`date +'%Y-%m-%d %H:%M:%S'`
		NOWTIMESECS=`date --date="$NOWTIME" +%s`
		MINS=`expr \( $NOWTIMESECS - $LASTTIMESECS \) / 60`
		
		[ $MINS -ge 30 ] && \
		logger -t "${logger_title}" "【FREEMEM】空闲倍数:$NUMFLAG 上次执行:$LASTTIME ..." && \
		logger -t "${logger_title}" "【FREEMEM】再次清理内存 ..."
		
		sync && sync && \
		echo 3 > /proc/sys/vm/drop_caches && \
		echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/freemem.time
	else
	
		logger -t "${logger_title}" "【FREEMEM】空闲倍数:$NUMFLAG 发现内存超标 !!!" && \
		
		
		[ $LOADAVG -gt 080 ] && \
		logger -t "${logger_title}" "【FREEMEM】系统负载过高,延期清理 ..." && \
		echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/freemem.time && \
		exit 0
		
		logger -t "${logger_title}" "【FREEMEM】开始清理内存 ..."
		
		sync && sync && \
		echo 3 > /proc/sys/vm/drop_caches && \
		echo `date +'%Y-%m-%d %H:%M:%S'` > /tmp/freemem.time
	fi
else
	if [ -f /tmp/freemem.time ] ; then
		logger -t "${logger_title}" "【FREEMEM】空闲倍数:$NUMFLAG 内存恢复正常 ~~~"
		rm -f /tmp/freemem.time
	fi
fi

