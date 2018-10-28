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
PROGRAM_VERSION="V 3.4.0"
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
DUS['nginx']="http://download.lanmps.com/nginx/nginx-1.14.0.tar.gz"
VERS['nginx']="1.14.0"
#http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.29.tar.gz
DUS['mysql']="http://download.lanmps.com/mysql/mysql-5.6.35.tar.gz"
VERS['mysql']="5.6.35"

#http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.38.tar.gz
DUS['mysql5.6.x']="http://download.lanmps.com/mysql/mysql-5.6.38.tar.gz"
VERS['mysql5.6.x']="5.6.38"

#http://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.13.tar.gz
DUS['mysql5.7.x']="http://download.lanmps.com/mysql/mysql-5.7.20.tar.gz"
VERS['mysql5.7.x']="5.7.20"
#https://downloads.mariadb.org/
#https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.1.19/source/mariadb-10.1.19.tar.gz
#DUS['MariaDB']="http://download.lanmps.com/mysql/mariadb-10.1.25.tar.gz"
#VERS['MariaDB']="10.1.25"
#https://downloads.mariadb.org/
#https://downloads.mariadb.org/f/mariadb-10.2.8/source/mariadb-10.2.8.tar.gz
DUS['mariadb10.2.x']="http://download.lanmps.com/mysql/mariadb-10.2.11.tar.gz"
VERS['mariadb10.2.x']="10.2.11"

DUS['mariadb10.3.x']="http://download.lanmps.com/mysql/mariadb-10.3.10.tar.gz"
VERS['mariadb10.3.x']="10.3.10"

#https://mirrors.tuna.tsinghua.edu.cn/mariadb//mariadb-10.1.19/source/mariadb-10.1.19.tar.gz
#DUS['mariadb10.1.x']="http://download.lanmps.com/mysql/mariadb-10.1.25.tar.gz"
#VERS['mariadb10.1.x']="10.1.25"

#http://cn2.php.net/distributions/php-7.1.9.tar.gz
DUS['php7.2.x']="http://download.lanmps.com/php/php-7.2.11.tar.gz"
VERS['php7.2.x']="7.2.11"

#http://cn2.php.net/distributions/php-7.1.9.tar.gz
DUS['php7.1.x']="http://download.lanmps.com/php/php-7.1.20.tar.gz"
VERS['php7.1.x']="7.1.20"

#http://cn2.php.net/distributions/php-7.0.14.tar.gz
DUS['php7.0.x']="http://download.lanmps.com/php/php-7.0.21.tar.gz"
VERS['php7.0.x']="7.0.21"

#http://cn2.php.net/distributions/php-5.6.10.tar.gz
DUS['php5.6.x']="http://download.lanmps.com/php/php-5.6.37.tar.gz"
VERS['php5.6.x']="5.6.37"

#http://cn2.php.net/distributions/php-5.5.26.tar.gz
DUS['php5.5.x']="http://download.lanmps.com/php/php-5.5.38.tar.gz"
VERS['php5.5.x']="5.5.38"

#http://cn2.php.net/distributions/php-5.4.42.tar.gz
#DUS['php5.4.x']="http://download.lanmps.com/php/php-5.4.45.tar.gz"
#VERS['php5.4.x']="5.4.45"

#http://cn2.php.net/distributions/php-5.3.29.tar.gz
#DUS['php5.3.x']="http://download.lanmps.com/php/php-5.3.29.tar.gz"
#VERS['php5.3.x']="5.3.29"
#https://www.phpmyadmin.net/
#https://files.phpmyadmin.net/phpMyAdmin/4.7.4/phpMyAdmin-4.7.4-all-languages.tar.gz
DUS['phpMyAdmin']="https://files.phpmyadmin.net/phpMyAdmin/4.8.3/phpMyAdmin-4.8.3-all-languages.tar.gz"
VERS['phpMyAdmin']="4.8.3"
#http://www.pcre.org/
#https://ftp.pcre.org/pub/pcre/
DUS['libpcre']="http://download.lanmps.com/basic/pcre-8.39.tar.gz"
VERS['libpcre']="8.39"
#http://www.gnu.org/software/libiconv/
#https://ftp.gnu.org/pub/gnu/libiconv/
DUS['libiconv']="http://download.lanmps.com/basic/libiconv-1.15.tar.gz"
VERS['libiconv']="1.15"

DUS['autoconf']="http://download.lanmps.com/basic/autoconf-2.69.tar.gz"
VERS['autoconf']="2.69"
#http://libevent.org/
#https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
DUS['libevent']="http://download.lanmps.com/basic/libevent-2.1.8-stable.tar.gz"
VERS['libevent']="2.1.8"
#https://redis.io/
#http://download.redis.io/releases/redis-4.0.1.tar.gz
DUS['redis']="http://download.redis.io/releases/redis-5.0.0.tar.gz"
VERS['redis']="5.0.0"
#http://pecl.php.net/package/redis
#http://pecl.php.net/get/redis-3.1.0.tgz
DUS['php-redis']="http://download.lanmps.com/php_ext/redis-4.1.1.tgz"
VERS['php-redis']="4.1.1"

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
#https://xdebug.org/
#https://xdebug.org/files/xdebug-2.5.5.tgz
DUS['php-xdebug']="http://xdebug.org/files/xdebug-2.5.5.tgz"
VERS['php-xdebug']="2.5.5"

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

#https://www.libssh2.org/
#https://www.libssh2.org/download/libssh2-1.8.0.tar.gz
DUS['libssh2']="https://www.libssh2.org/download/libssh2-1.8.0.tar.gz"
VERS['libssh2']="1.8.0"
#http://pecl.php.net/package/ssh2
DUS['php-ssh2']="http://pecl.php.net/get/ssh2-1.1.2.tgz"
VERS['php-ssh2']="1.1.2"


#php composer
#https://getcomposer.org/download/1.7.2/composer.phar
DUS['composer']="https://getcomposer.org/download/1.7.2/composer.phar"
VERS['composer']="1.7.2"