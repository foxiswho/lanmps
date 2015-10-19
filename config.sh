# common var

IN_DOWN=${IN_PWD}/down
LOGPATH=${IN_PWD}/logs
IN_DIR="/www/lanmps"
IN_WEB_DIR="/www/wwwroot"
IN_WEB_LOG_DIR="/www/wwwLogs"
SERVER="nginx"
RE_INS=0
SOFT_DOWN=1
ETC_INIT_D_LN=2;#1:ln x to $IN_DIR/init.d/x;2:no
INNODB_ID=2
YUM_APT_GET_UPDATE=1;#1:Update the kernel and software(yum install -7 update or apt-get install -y update);2:no
FName="LANMPS"
TIME_ZONE=1;#Asia/Shanghai
MysqlPassWord="root";#mysql username and password

if [ "${IS_EXISTS_REMOVE}" = "0" ]; then
	IS_EXISTS_REMOVE=1
fi
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
declare -A IN_DIR_SETS;
# soft url and down
#http://nginx.org/download/nginx-1.8.0.tar.gz
DUS['nginx']="http://download.lanmps.com/nginx/nginx-1.8.0.tar.gz"
VERS['nginx']="1.8.0"
#http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.21.tar.gz
DUS['mysql']="http://download.lanmps.com/mysql/mysql-5.6.21.tar.gz"
VERS['mysql']="5.6.21"

#http://mirrors.hustunique.com/mariadb/mariadb-10.0.17/source/mariadb-10.0.17.tar.gz
#http://mirrors.opencas.cn/mariadb/mariadb-10.0.20/source/mariadb-10.0.20.tar.gz
DUS['MariaDB']="http://download.lanmps.com/mysql/mariadb-10.0.20.tar.gz"
VERS['MariaDB']="10.0.20"

#http://cn2.php.net/distributions/php-5.6.10.tar.gz
DUS['php5.6.x']="http://download.lanmps.com/php/php-5.6.10.tar.gz"
VERS['php5.6.x']="5.6.10"

#http://cn2.php.net/distributions/php-5.5.26.tar.gz
DUS['php5.5.x']="http://download.lanmps.com/php/php-5.5.26.tar.gz"
VERS['php5.5.x']="5.5.26"

#http://cn2.php.net/distributions/php-5.4.42.tar.gz
DUS['php5.4.x']="http://download.lanmps.com/php/php-5.4.42.tar.gz"
VERS['php5.4.x']="5.4.42"

#http://cn2.php.net/distributions/php-5.3.29.tar.gz
DUS['php5.3.x']="http://download.lanmps.com/php/php-5.3.29.tar.gz"
VERS['php5.3.x']="5.3.29"
IN_DIR_SETS['php5.3.x']=${IN_DIR}/php

#http://jaist.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.4.10/phpMyAdmin-4.4.10-all-languages.tar.gz
DUS['phpMyAdmin']="http://download.lanmps.com/phpMyAdmin/phpMyAdmin-4.4.10-all-languages.tar.gz"
VERS['phpMyAdmin']="4.4.10"

DUS['libpcre']="http://download.lanmps.com/basic/pcre-8.33.tar.gz"
VERS['libpcre']="8.33"

DUS['libiconv']="http://download.lanmps.com/basic/libiconv-1.14.tar.gz"
VERS['libiconv']="1.14"

DUS['autoconf']="http://download.lanmps.com/basic/autoconf-2.69.tar.gz"
VERS['autoconf']="2.69"

DUS['libevent']="http://download.lanmps.com/basic/libevent-2.0.21-stable.tar.gz"
VERS['libevent']="2.0.21"

DUS['memcached']="http://download.lanmps.com/memcache/memcached-1.4.24.tar.gz"
VERS['memcached']="1.4.24"

#http://pecl.php.net/package/memcache
DUS['memcache']="http://download.lanmps.com/memcache/memcache-3.0.8.tar.gz"
VERS['memcache']="3.0.8"

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

DUS['xdebug']="http://xdebug.org/files/xdebug-2.3.3.tgz"
VERS['xdebug']="2.3.3"

#http://sphinxsearch.com/files/sphinx-2.2.9-release.tar.gz
DUS['sphinx']="http://sphinxsearch.com/files/sphinx-2.2.9-release.tar.gz"
VERS['sphinx']="2.2.9"
#http://www.sphinx-search.com/downloads/sphinx-for-chinese-2.2.1-dev-r4311.tar.gz
DUS['sphinx-for-chinese']="http://download.lanmps.com/sphinx/sphinx-for-chinese-2.2.1-dev-r4311.tar.gz"
VERS['sphinx-for-chinese']="2.2.1"
#http://www.coreseek.cn/uploads/csft/4.0/coreseek-4.1-beta.tar.gz
DUS['sphinx-coreseek']="http://download.lanmps.com/sphinx/coreseek-4.1-beta.tar.gz"
VERS['sphinx-coreseek']="4.1"

#http://mirrors.hust.edu.cn/apache/httpd/httpd-2.4.12.tar.gz
DUS['apache']="http://download.lanmps.com/Apache/httpd-2.4.12.tar.gz"
VERS['apache']="2.4.12"

#http://mirrors.axint.net/apache/apr/apr-1.5.1.tar.gz
DUS['apr']="http://download.lanmps.com/Apache/apr-1.5.1.tar.gz"
VERS['apr']="1.5.1"

#http://mirrors.axint.net/apache/apr/apr-util-1.5.4.tar.gz
DUS['apr-util']="http://download.lanmps.com/Apache/apr-util-1.5.4.tar.gz"
VERS['apr-util']="1.5.4"
