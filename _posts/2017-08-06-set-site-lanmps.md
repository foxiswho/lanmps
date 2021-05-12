---
layout: post
title: 使用 lanmps 环境套件安装设置新站点 案例
permalink: /2017/set_site_lanmps.html
---

假设：
>服务器环境：CentOs 7.3

>套件： LANMPS 一键PHP环境安装包

>程序框架：thinkphp 5.x

>域名：lanmps.com

风.fox

# 建立 站点 目录
那么在 `/www/wwwroot` 下 新建立一个 目录 `lanmps.com`
```SHELL
mkdir -p /www/wwwroot/lanmps.com
```

# 放入程序文件
把你的 程序文件放到 该目录里面
```SHELL
/www/wwwroot/lanmps.com
```
# nginx 站点配置

>注意：thinkphp3.x 和 thinkphp5.x 目录配置是不一样的，不要照抄，这里 配置 是 thinkphp5.x

输入命令编辑
```shell
vim /www/lanmps/nginx/conf/vhost/lanmps.com.conf
```
内容如下：
```SHELL
server {
	listen       80;
	server_name  lanmps.com;
	root /www/wwwroot/lanmps.com/public;
	# 如果不是第一个 server_name ,那么自动跳转到 第一个地址上
	#if ($host != $server_name) {
	#	rewrite ^/(.*)$ http://$server_name/$1 permanent;
	#} 
	index index.html index.htm index.php;
	include /www/wwwroot/lanmps.com/public/lanmps-*.conf;
	
	# 图片缓存 30天
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
			expires      30d;
	}
	# JS CSS 文件缓存 12小时
	location ~ .*\.(js|css)?$ {
			expires      12h;
	}
	location ~ ^.+\.php {
		#fastcgi_pass  unix:/tmp/php-cgi.sock;
		fastcgi_pass   bakend;
		fastcgi_index  index.php;
		#fastcgi_split_path_info ^((?U).+\.php)(/?.+)$;
		#include        fastcgi;
		include fastcgi.conf;
	}
	# 记录访问日志
	#access_log  /www/wwwLogs/lanmps.com.log access;
}
```

# 配置伪静态
```shell
vim /www/wwwroot/lanmps.com/public/lanmps-*.conf;
```
输入
```shell
if (!-e $request_filename) {
 				#rewrite ^.+?\.php\?s=(.*)$ /index.php?s=$1 last;
 				rewrite  ^/index.php/(.*)  /index.php?s=/$1  last;
 				rewrite  ^(.*)$  /index.php?s=$1  last;
 				break;
 }
```

# 配置文件权限 和用户组

```SHELL
chown -R www:www /www/wwwroot/lanmps.com
chmod -R 777 /www/wwwroot/lanmps.com
```

# nginx 重启
```SHELL
/www/lanmps/bin nginx reload
```
首发 http://www.foxwho.com/article/140  
同步 foxwho(神秘狐)的领地 http://www.foxwho.com
