# common var
#源程序目录
IN_DOWN=${IN_PWD}/down
#安装日志目录
LOGPATH=${IN_PWD}/logs
#安装后 程序目录
IN_DIR="/www/lanmps"
#安装后 站点项目目录
IN_WEB_DIR="/www/wwwroot"
#安装后 站点日志目录
IN_WEB_LOG_DIR="/www/wwwLogs"

#Asia/Shanghai  时区 设置为上海
TIME_ZONE=1
#程序名称
PROGRAM_NAME="LANMPS"
PROGRAM_VERSION="V 3.2.3"
#安装服务
SERVER="nginx"

#下载
SOFT_DOWN=1

#1:Update the kernel and software(yum install -7 update or apt-get install -y update);2:no
YUM_APT_GET_UPDATE=1;
FName="LANMPS"

#mysql username and password  数据库用户名及密码
MysqlPassWord="root";

if [ "${IS_EXISTS_REMOVE}" = "0" ]; then
	IS_EXISTS_REMOVE=1
fi
IS_DOCKER=0
if [ "${IS_DOCKER}" = "1" ]; then
	IS_DOCKER=0
fi

if [ "$FAST" = "1" ]; then
	FAST=1
else
	FAST=0
fi

declare -A LIBS;
declare -A VERS;
declare -A DUS;
# soft url and down
#http://nginx.org/download/nginx-1.8.0.tar.gz
DUS['nginx']="http://download.lanmps.com/nginx/nginx-1.12.1.tar.gz"
VERS['nginx']="1.12.1"
#http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.29.tar.gz
DUS['mysql']="http://download.lanmps.com/mysql/mysql-5.6.35.tar.gz"
VERS['mysql']="5.6.35"

DUS['mysql5.6.x']="http://download.lanmps.com/mysql/mysql-5.6.35.tar.gz"
VERS['mysql5.6.x']="5.6.35"

#http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.13.tar.gz
DUS['mysql5.7.x']="http://download.lanmps.com/mysql/mysql-5.7.17.tar.gz"
VERS['mysql5.7.x']="5.7.17"

#https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.1.19/source/mariadb-10.1.19.tar.gz
DUS['MariaDB']="http://download.lanmps.com/mysql/mariadb-10.1.25.tar.gz"
VERS['MariaDB']="10.1.25"

DUS['mariadb10.2.x']="http://download.lanmps.com/mysql/mariadb-10.2.7.tar.gz"
VERS['mariadb10.2.x']="10.2.7"

#https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.1.19/source/mariadb-10.1.19.tar.gz
DUS['mariadb10.1.x']="http://download.lanmps.com/mysql/mariadb-10.1.25.tar.gz"
VERS['mariadb10.1.x']="10.1.25"

#http://cn2.php.net/distributions/php-7.0.14.tar.gz
DUS['php7.0.x']="http://download.lanmps.com/php/php-7.0.21.tar.gz"
VERS['php7.0.x']="7.0.21"

DUS['php7.1.x']="http://download.lanmps.com/php/php-7.1.7.tar.gz"
VERS['php7.1.x']="7.1.7"

#http://cn2.php.net/distributions/php-5.6.10.tar.gz
DUS['php5.6.x']="http://download.lanmps.com/php/php-5.6.31.tar.gz"
VERS['php5.6.x']="5.6.31"

#http://cn2.php.net/distributions/php-5.5.26.tar.gz
DUS['php5.5.x']="http://download.lanmps.com/php/php-5.5.38.tar.gz"
VERS['php5.5.x']="5.5.38"

#http://cn2.php.net/distributions/php-5.4.42.tar.gz
DUS['php5.4.x']="http://download.lanmps.com/php/php-5.4.45.tar.gz"
VERS['php5.4.x']="5.4.45"

#http://cn2.php.net/distributions/php-5.3.29.tar.gz
DUS['php5.3.x']="http://download.lanmps.com/php/php-5.3.29.tar.gz"
VERS['php5.3.x']="5.3.29"

#https://files.phpmyadmin.net/phpMyAdmin/4.6.5.2/phpMyAdmin-4.6.5.2-all-languages.tar.gz
DUS['phpMyAdmin']="http://download.lanmps.com/phpMyAdmin/phpMyAdmin-4.6.5.2-all-languages.tar.gz"
VERS['phpMyAdmin']="4.6.5.2"

DUS['libpcre']="http://download.lanmps.com/basic/pcre-8.39.tar.gz"
VERS['libpcre']="8.39"

DUS['libiconv']="http://download.lanmps.com/basic/libiconv-1.14.tar.gz"
VERS['libiconv']="1.14"

DUS['autoconf']="http://download.lanmps.com/basic/autoconf-2.69.tar.gz"
VERS['autoconf']="2.69"

DUS['libevent']="http://download.lanmps.com/basic/libevent-2.0.21-stable.tar.gz"
VERS['libevent']="2.0.21"

#http://download.redis.io/releases/redis-3.2.1.tar.gz
DUS['redis']="http://download.lanmps.com/redis/redis-3.2.6.tar.gz"
VERS['redis']="3.2.6"

#http://pecl.php.net/get/redis-3.1.0.tgz
DUS['php-redis']="http://download.lanmps.com/php_ext/redis-3.1.1.tgz"
VERS['php-redis']="3.1.1"

DUS['php-redis2.x']="http://download.lanmps.com/php_ext/redis-2.2.8.tgz"
VERS['php-redis2.x']="2.2.8"


DUS['memcached']="http://download.lanmps.com/memcache/memcached-1.4.24.tar.gz"
VERS['memcached']="1.4.24"

#http://pecl.php.net/package/memcache
DUS['php-memcache']="http://download.lanmps.com/memcache/memcache-3.0.8.tar.gz"
VERS['php-memcache']="3.0.8"

DUS['libxml2']="http://download.lanmps.com/basic/libxml2-2.9.1.tar.gz"
VERS['libxml2']="2.9.1"


DUS['libmcrypt']="http://download.lanmps.com/basic/libmcrypt-2.5.8.tar.gz"
VERS['libmcrypt']="2.5.8"
#http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz
DUS['libmhash']="http://download.lanmps.com/basic/mhash-0.9.9.9.tar.gz"
VERS['libmhash']="0.9.9.9"

#http://nchc.dl.sourceforge.net/project/mcrypt/MCrypt/2.6.8/mcrypt-2.6.8.tar.gz
DUS['mcrypt']="http://download.lanmps.com/basic/mcrypt-2.6.8.tar.gz"
VERS['mcrypt']="2.6.8"

DUS['php-xdebug']="http://xdebug.org/files/xdebug-2.5.0.tgz"
VERS['php-xdebug']="2.5.0"

#http://mirrors.hust.edu.cn/apache/httpd/httpd-2.4.23.tar.gz
DUS['apache']="http://download.lanmps.com/Apache/httpd-2.4.23.tar.gz"
VERS['apache']="2.4.23"

#http://mirrors.axint.net/apache/apr/apr-1.5.1.tar.gz
DUS['apr']="http://download.lanmps.com/Apache/apr-1.5.1.tar.gz"
VERS['apr']="1.5.1"

#http://mirrors.axint.net/apache/apr/apr-util-1.5.4.tar.gz
DUS['apr-util']="http://download.lanmps.com/Apache/apr-util-1.5.4.tar.gz"
VERS['apr-util']="1.5.4"

#https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz
DUS['cmake']="http://download.lanmps.com/basic/cmake-3.5.2.tar.gz"
VERS['cmake']="3.5.2"

#http://mirror.hust.edu.cn/gnu/libtool/libtool-2.4.6.tar.gz
DUS['libtool']="http://download.lanmps.com/basic/libtool-2.4.6.tar.gz"
VERS['libtool']="2.4.6"


DUS['boost']="http://download.lanmps.com/basic/boost_1_59_0.tar.gz"
VERS['boost']="1_59_0"
