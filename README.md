LANMPS 一键安装包,php绿色环境套件包
=====================================

Linux+Nginx+Mysql+PHP+Sphinx ( phpmyadmin+opencache+xdebug )环境套件包,绿色PHP套件，一键自动安装

系统需求
-------------------------------------

* 系统：Linux下CentOS,RedHat,Ubuntu
* 内存：大于等于256M内存 
* 安装时需要联网

LANMPS 一键安装包V0.1.0 ：Linux+Nginx+Mysql+PHP+Sphinx ( phpmyadmin+opencache+xdebug )套件包,绿色PHP套件，一键自动安装。
> 
已在 CentOS6.x，Ubuntu14.04，Ubuntu14.10 中安装成功！

注意
------------------------------------
coreseek(Sphinx中文版) 不支持 Ubuntu 12.x,13.x,14.x

安装
-----------------------------------

请以  root  用户执行命令

安装包大小：197MB（包含相关环境所需文件）
### 方法二：
百度网盘下载(速度快)：[http://pan.baidu.com/s/1bnjIYKJ](http://pan.baidu.com/s/1bnjIYKJ)

然后上传文件到服务器上，在当前目录下执行：
`tar -zxvf lanmps-2.2.3.tar.gz && cd lanmps-2.2.3 && ./lanmps.sh`

LANMPS状态管理命令
------------------------------------

### 方法一：

* LANMPS      状态管理 ： /www/lanmps/lanmps {start|stop|reload|restart|kill|status}
* Nginx            状态管理 ： /www/lanmps/action/nginx {start|stop|reload|restart|status|cutLog}
* MySQL          状态管理 ：/www/lanmps/action/mysql {start|stop|restart|reload|force-reload|status}
* PHP-FPM     状态管理 ：/www/lanmps/action/php-fpm {start|stop|quit|restart|reload|logrotate}
* Memcached状态管理 ：/www/lanmps/action/memcached {start|stop|restart}

例如：
> 
重启LANMPS：/root/lanmps restart           输入此命令即可重启
> 
重启mysql     ：/www/lanmps/action/mysql restart

> 
/www                     ：为安装目录位置
> 
/www/lanmps ：套件环境执行文件目录位置

LANMPS 配置文件位置
-----------------------------------------
* /www                     ：为安装目录
* /www/lanmps ：为安装套件程序目录

* Nginx       配置文件：/www/lanmps/nginx/conf/nginx.conf
* Mysql       配置文件：/www/lanmps/mysql/my.cnf
* PHP           配置文件：/www/lanmps/php/php.ini
* PHP-FPM配置文件：/www/lanmps/php/etc/php-fpm.conf
* phpMyadmin目录 ：/www/wwwroot/default/_phpmyadmin/

默认default配置文件：
* /www/lanmp/nginx/conf/vhost/00000.default.conf

* /root/vhost.sh添加的虚拟主机配置文件：
* /www/lanmp/nginx/conf/vhost/域名.conf

* /www/wwwLogs：日志目录
* /www/wwwroot：网站程序目录

Xdubug ：已编译，但默认关闭，如需开启在php.ini中开启

nginx 自动分割日志
--------------------------------------------
0 0 * * * /www/lanmps/action/nginx cutLog
> 
凌晨 0点0分00秒 开始执行

### 更新日志
* 2015年7月16日 LANMPS V2.2.3 发布

 * php 版本更新
 * BUG修复
 
* 2014年12月22日 LANMPS V1.0.3 发布

 * php 版本更新
 * MariaDB 版本更新
 * nginx 版本更新
 * BUG修复
 
* 2014年11月1日 LANMPS V1.0.0 发布

 * php 版本更新
 * 增加MariaDB 数据库
 * nginx 版本更新
 * 增加sphinx搜索
 * 可以更改任意安装目录
 * 支持nginx日志自动分割(需设置linux定时任务)

* 2014年5月15日 LANMPS V0.2 发布

 * php 版本更新
 * 增加MariaDB 数据库
 * nginx 版本更新

* 2013年11月10日 LANMPS V0.1 发布

 * Nginx+Mysql+PHP+Opencache+Phpmyadmin+Xdebug 基础实现安装
 * Xdebug 默认关闭，如需开启，在php.ini中开启
 * Mysql 版本为 5.6.14，默认不能选择版本，以后版本中会实现
 * PHP 可以选择版本
 * Nginx为最新版1.5.6
 * 支持Linux 中的  Ubuntu 和 CentOS 系统

* 2013-09-09 LANMPS  项目开始