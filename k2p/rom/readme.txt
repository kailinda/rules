可以进行的优化：
1. 修改页面端口为3389
2. 清理内存改为：
*/7 * * * * flock -xn /tmp/freemem.lock freemem &