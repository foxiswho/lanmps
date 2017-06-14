LANMPS 一键安装包,php绿色环境套件包
=====================================

Linux+Nginx+Mysql+PHP+Elasticsearch ( phpmyadmin+opencache+xdebug )环境套件包,绿色PHP套件，一键自动安装

系统需求
-------------------------------------

* 系统：Linux下CentOS,RedHat,Ubuntu
* 内存：大于等于2048M内存 (目前没有针对小内存优化)
* 安装时需要联网

LANMPS 一键安装包V3.2.2 ：Linux+Nginx+Mysql+PHP+Elasticsearch ( phpmyadmin+opencache+xdebug )套件包,绿色PHP套件，一键自动安装。
> 
已在 CentOS7.x，Ubuntu17.x 中安装成功！

注意
------------------------------------
coreseek(Sphinx中文版) 不支持 Ubuntu 12.x,13.x,14.x `已废弃`

安装
-----------------------------------

请以  root  用户执行命令

安装包大小：340MB（包含相关环境所需文件）
### 方法一：
百度网盘下载(速度快)：[http://pan.baidu.com/s/1bnjIYKJ](http://pan.baidu.com/s/1bnjIYKJ)

### 方法二：
下载地址：http://download.lanmps.com/lanmps/lanmps-3.2.2.tar.gz (七牛免费资源,每月10G流量)

然后上传文件到服务器上，在当前目录下执行：
`tar -zxvf lanmps-3.2.2.tar.gz && cd lanmps-3.2.2 && ./lanmps.sh`

>数据库默认密码为`root`
>mysql5.7.x版密码为空

Centos 7 最后执行 下面两条命令   一个是 增加 防火墙端口，一个是重启防火墙
```SHELL
firewall-cmd --zone=public --add-port=80/tcp --permanent
systemctl restart firewalld.service
```

LANMPS状态管理命令
------------------------------------

### 方法一：

* LANMPS      状态管理 ： /www/lanmps/lanmps {start|stop|reload|restart|kill|status}
* Nginx            状态管理 ： /www/lanmps/bin/nginx {start|stop|reload|restart|status|cutLog}
* MySQL          状态管理 ：/www/lanmps/bin/mysql {start|stop|restart|reload|force-reload|status}
* PHP-FPM     状态管理 ：/www/lanmps/bin/php-fpm {start|stop|quit|restart|reload|logrotate}
* Memcached状态管理 ：/www/lanmps/bin/memcached {start|stop|restart}

例如：
> 
重启LANMPS：/root/lanmps restart           输入此命令即可重启
> 
重启mysql     ：/www/lanmps/bin/mysql restart

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
0 0 * * * /www/lanmps/bin/nginx cutLog
> 
凌晨 0点0分00秒 开始执行

### 更新日志
* 2017年03月07日 LANMPS V3.2.2 发布

 * 升级PHP7.1.x
 * 升级MYSQL5.7.x
 * 升级REDIS
 * 升级NGINX1.11.x
 * BUG修复
 
### 更新日志
* 2016年12月15日 LANMPS V3.2.0 发布

 * 升级PHP7.1
 * 升级MYSQL5.7
 * 升级REDIS
 * 升级NGINX1.11
 * BUG修复
 
* 2016年7月11日 LANMPS V3.1.0 发布

 * 升级PHP7
 * 升级MYSQL5.7
 * 升级REDIS
 * 升级NGINX1.10
 * 搜索引擎更换为 Elasticsearch
 * BUG修复
 
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