描述：
最精简情况下，默认官方可用的功能都已打开(最新到hanwckf版本的2021.06.14号)
添加了jq,chinadns-ng,pdnsd,smartdns软件
修正了mtd_storage脚本，恢复出厂使用自己的脚本
添加了irqbalance脚本，优化CPU使用，默认用rc再started脚本之前运行，并添加到网络改变事件
网络相关内核参数优化
添加storage下started.d、wan.d、firewall.d和shutdown.d四个入口，并采用异步式执行
添加start.d事件执行目录
恢复storage时，自动添加authorized_keys内容
更改默认shell搜索路径path
添加/etc/storage/bin/sysctl硬链接到/etc/storage/start_script.sh
添加yonsm的dnsmasq修复版本，修复tcp的crash问题
添加fanjunjie硬链接到admin计划任务

storage添加智能dns
需要dnsmasq=>chinadns-ng=>smartdns方案可以恢复Storage_K2P(开启dns加速)备份包
* dnsmasq 判断是否gfwlist，如果是，则调用smartdns的5602端口，走可信dns
	如果不是gfwlist,则进入chinadns-ng环节
		chinadns-ng判断是否是chnlist白名单，如果是则走国内dns，调用smartdns的5601端口
			如果不是chnlist，则判断国内dns返回的ip是否是国外区域
				如果是国外区域，则走可信dns,继续调用smartdns的5602端口
				如果是国内区域，则走国内dns，调用smartdns的5601端口
  优点是既可以利用gfwlist加速国外dns，也可以在gfwlist之外的情况智能判断


待升级：
没用开启zram,kvr,dig
默认未劫持53端口，如需要可刷storage