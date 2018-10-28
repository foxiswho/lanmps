. $IN_PWD/config.sh

# OS Version detect
# 1:redhat/centos 2:debian/ubuntu
OS_RL="centos"
grep -qi 'Deepin\|debian\|ubuntu' /etc/issue && OS_RL="ubuntu"
if [ $OS_RL = "centos" ]; then
    R6=0
    grep -q 'release 6' /etc/redhat-release && R6=1
fi
X86=0
if uname -m | grep -q 'x86_64'; then
    X86=1
fi

# detect script name, for install log
command=$(basename $0)
logpre=${command%%.sh}
#IP
#IP=$(ifconfig | awk -F'addr:|Bcast' '/Bcast/{print $2}')
IPS=`LC_ALL=C ifconfig|grep "inet addr:"|grep -v "127.0.0.1"|cut -d: -f2|awk '{print $1}'`
i=0;
for a in $IPS;
do
if [ "$i" = "0" ]; then
	IP=$a;
fi
i=$((i+1));
done;
IP=`ip a|grep "inet"|grep -v "127.0.0.1"|grep -v "inet6"|awk '{print $2}'`
IP=${IP//\/24/}
IP=${IP// /}


#=================================================
. $IN_PWD/lib/fun.sh
. $IN_PWD/lib/Init.sh
. $IN_PWD/lib/Init_CheckAndDownloadFiles.sh
. $IN_PWD/lib/Install_DependsAndOpt.sh
. $IN_PWD/lib/Install_Mysql.sh
. $IN_PWD/lib/Install_Nginx.sh
. $IN_PWD/lib/Install_Apache.sh
. $IN_PWD/lib/Install_PHP.sh
. $IN_PWD/lib/Install_PHP_Tools.sh
. $IN_PWD/lib/Install_PHP_phpMyAdmin.sh
. $IN_PWD/lib/Install_Redis.sh
. $IN_PWD/lib/Install_Memcached.sh
. $IN_PWD/lib/Starup.sh
clear
t_median=32
if [ $X86 = 1 ]; then
t_median=64
fi
MemTotal=`free -m | grep Mem | awk '{print  $2}'`
echo "LANMPS ${PROGRAM_VERSION} for CentOS/Ubuntu Linux Written by foxwho"
echo "========================================================================="
echo "A tool to auto-compile & install Apache+Nginx+MySQL+PHP on Linux "
echo "For more information please visit http://www.lanmps.com"
echo "========================================================================="
echo "Environmental Monitoring"
echo "IN_PWD: ${IN_PWD}"
echo "IN_DOWN: ${IN_DOWN}"
echo "LOGPATH: ${LOGPATH}"
echo "IN_DIR: ${IN_DIR}"
echo "IN_WEB_DIR: ${IN_WEB_DIR}"
echo "IN_WEB_LOG_DIR: ${IN_WEB_LOG_DIR}"
echo "Linux	: ${OS_RL} ${t_median}"
echo "Memory	: ${MemTotal}"
echo "IP	: $IP"
x1=`cat /etc/issue`
echo $x1
uname -a
echo "========================================================================="
unset t_median x1

if [[ "$START"x != "no"x  ]]; then

echo ""
#    2 Apache + php + mysql + es  + memcache + phpmyadmin
echo "Select Install  ( 1 default ):
    1 Nginx + php + mysql + redis + phpmyadmin

    5 don't install is now"
sleep 0.1
echo -n "Please Input 1,2,3,4,5: "
read SERVER_ID
if [ "$SERVER_ID" = "" ]; then
	SERVER_ID="1"
fi

echo "Input $SERVER_ID"

if [[ $SERVER_ID == 1 ]]; then
    SERVER="nginx"
elif [[ $SERVER_ID == 2 ]]; then
    SERVER="apache"
elif [[ $SERVER_ID == 3 ]]; then
    SERVER="na"
elif [[ $SERVER_ID == 4 ]]; then
    SERVER="all"
else
    exit
fi
echo $SERVER

#PHP Version
PHP_VER_NUM=72
PHP_VER_ID=3
echo
echo "Select php version:
    3 php-${VERS['php7.2.x']} (default)
    2 php-${VERS['php7.1.x']}
    1 php-${VERS['php5.6.x']}
    0 don't install is now "
echo -n "Please Input 1-6: "
read PHP_VER_ID
if [ "$PHP_VER_ID" = "" ]; then
	PHP_VER_ID="3"
	PHP_VER_NUM=72
fi

if [ "${PHP_VER_ID}" == "1" ]; then
    PHP_VER=${VERS['php5.6.x']}
	PHP_KEY="php5.6.x"
	PHP_VER_ID=1
	PHP_VER_NUM=56
elif [ $PHP_VER_ID == "2" ]; then
    PHP_VER=${VERS['php7.1.x']}
	PHP_KEY="php7.1.x"
	PHP_VER_ID=2
	PHP_VER_NUM=71
elif [ $PHP_VER_ID == "3" ]; then
    PHP_VER=${VERS['php7.2.x']}
	PHP_KEY="php7.2.x"
	PHP_VER_ID=3
	PHP_VER_NUM=72
else
    echo ${PHP_VER_ID}
    echo ${PHP_VER_NUM}
	exit
fi
echo "Input $PHP_VER_ID  ,PHP_VER=${PHP_VER} ,PHP_KEY=${PHP_KEY} , ${PHP_VER_NUM}"

echo "Select mysql :
    3 MariaDB (default ${VERS['mariadb10.3.x']})
    2 MySql  ${VERS['mysql5.7.x']}
    1 MySql  ${VERS['mysql5.6.x']}
    0 don't install is now
    "
echo -n "Please Input 1-3: "
read MYSQL_SELECT
MYSQL_INITD="mysql"
if [ $MYSQL_SELECT == "1" ]; then
    MYSQL_VER=${VERS['mysql5.6.x']}
	MYSQL_ID="mysql"
    MYSQL_KEY="5.6.x"
    MYSQL_SELECT=1
elif [ $MYSQL_SELECT == "2" ]; then
   MYSQL_VER=${VERS['mysql5.7.x']}
   MYSQL_ID="mysql"
   MYSQL_KEY="5.7.x"
   MYSQL_SELECT=2
elif [ $MYSQL_SELECT == "3" ]; then
    MYSQL_VER=${VERS['mariadb10.3.x']}
    MYSQL_KEY="10.3.x"
    MYSQL_ID="MariaDB"
    MYSQL_SELECT=3
else
    echo ${MYSQL_SELECT}
    exit
fi
echo "Input $MYSQL_SELECT  ,MYSQL Name ${MYSQL_ID}"

#update source 
SOURCE_ID=1
echo
#echo "Select Update source :
#    1 Ubuntu default Update source ( default )
#    2 163.com Update source ( Chinese domestic Recommended )"
#read -p "Please Input 1,2: " SOURCE_ID
if [[ $SOURCE_ID == 2 ]]; then
    SOURCE_ID=2
else
    SOURCE_ID=1
fi
#echo "Input $SOURCE_ID"

fi

get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
echo "Press any key to start..."
char=`get_char`;

chmod 777 $IN_PWD/lib/*
chmod 777 $IN_PWD/down/*
if [ ! -d "$LOGPATH" ]; then
	mkdir $LOGPATH
	chmod +w $LOGPATH
else
    chmod +w $LOGPATH
fi
