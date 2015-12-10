#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin:~/bin
export PATH
# Check if user is root
if [ $UID != 0 ]; then echo "Error: You must be root to run the install script, please use root to install lanmps";exit;fi
# DOCKER
NO_INPUT="YES"
IS_DOCKER=1

SERVER_ID=1
SERVER="nginx"

MYSQL_ID=""
MYSQL_SELECT=0

REDIS_SELECT=0;
ELASTIC_SEARCH_ID=0

PHP_VER=${VERS['php5.6.x']}
PHP_KEY="php5.6.x"
PHP_VER_ID=1

SOURCE_ID=1



IN_PWD=$(pwd)
. lib/common.sh

#更新
YUM_APT_GET_UPDATE=0
#不检测
IS_EXISTS_REMOVE=2

Init_SetDirectoryAndUser 2>&1 | tee -a "${LOGPATH}/1.Init_SetDirectoryAndUser-install.log"

Init 2>&1 | tee -a "${LOGPATH}/2.Init-install.log"

{ 
 
Init_CheckAndDownloadFiles;

Install_DependsAndOpt;

if [ $SERVER == "apache" ]; then
	Install_Apache;
else
	Install_Nginx;
fi

Install_PHP;

Install_PHP_Tools;

Install_Memcached;

if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
    Install_Mysql;
fi

if [ ${ELASTIC_SEARCH_ID} == "1" ]; then
    Install_ElasticSearch;
fi

 }  2>&1 | tee -a "${LOGPATH}/3.Install.log"

Starup 2>&1 | tee -a "${LOGPATH}/9.Starup-install.log"

CheckInstall 2>&1 | tee -a "${LOGPATH}/10.CheckInstall-install.log"