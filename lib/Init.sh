function Init()
{
	echo "===========     Init         ============================"
	#Set timezone
	if [ "$TIME_ZONE" = "1" ]; then
		rm -rf /etc/localtime
		ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	fi
	
	#Disable SeLinux
	if [ -s /etc/selinux/config ]; then
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	fi
	
	local IN_LOG=$LOGPATH/install_Init.sh.lock
    echo
    [ -f "$IN_LOG" ] && return
	
	#Init_ReplacementSource
	
	if [ $OS_RL = 3 ]; then
		echo "====================================="
	elif [ $OS_RL = "ubuntu" ]; then
		if [ "$IS_EXISTS_REMOVE" = "1" ]; then
			apt-get remove -y apache2 apache2-utils apache2.2-common apache2.2-bin \
			apache2-mpm-prefork apache2-doc apache2-mpm-worker \
			mysql-common mysql-server \
			php5 php5-common php5-cgi php5-mysql php5-curl php5-gd
			
			killall apache2
			
			dpkg -l |grep mysql 
			dpkg -P libmysqlclient15off libmysqlclient15-dev mysql-common 
			dpkg -l |grep apache 
			dpkg -P apache2 apache2-doc apache2-mpm-prefork apache2-utils apache2.2-common
			dpkg -l |grep php 
			dpkg -P php5 php5-common php5-cgi php5-mysql php5-curl php5-gd
			apt-get purge `dpkg -l | grep php| awk '{print $2}'`
		fi
		if [ "$IS_DOCKER" = "0" ]; then
			apt-get install -y ntpdate
			ntpdate -u pool.ntp.org
			date
		fi
		if [ -s /etc/ld.so.conf.d/libc6-xen.conf ]; then
		sed -i 's/hwcap 1 nosegneg/hwcap 0 nosegneg/g' /etc/ld.so.conf.d/libc6-xen.conf
		fi
		
		if [ "$YUM_APT_GET_UPDATE" = "1" ]; then
			apt-get update -y
		fi
		if [ "$IS_DOCKER" = "0" ]; then
			apt-get autoremove -y
			apt-get -fy install
		fi
		echo "apt-get -y install build-essential gcc g++ make cmake autoconf"
		apt-get -y install build-essential gcc g++ make cmake autoconf
		#ln -s /bin/gcc /bin/cc
		
		for packages in libltdl-dev openssl \
		libzip-dev automake re2c wget cron libc6-dev file rcconf \
		flex vim nano bison m4 gawk less cpp binutils diffutils \
		unzip tar bzip2 unrar p7zip libncurses5-dev libncurses5 \
		libtool libevent-dev libpcre3 libpcre3-dev \
		libpcrecpp0  zlibc libssl-dev libsasl2-dev libltdl3-dev  \
		libmcrypt-dev libmysqlclient15-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev \
		libglib2.0-0 libglib2.0-dev libpng3 libfreetype6 libfreetype6-dev libjpeg62 \
		libjpeg62-dev libjpeg-dev libpng-dev libpng12-0 libpng12-dev curl libcurl3 \
		libmhash2 libmhash-dev libpq-dev libpq5 gettext libxml2-dev  \
		libcurl4-openssl-dev libcurl4-gnutls-dev mcrypt libcap-dev libexpat1-dev mysql-client;
		
		do 
			apt-get install -y $packages --force-yes;
			echo "========apt-get install -y $packages --force-yes"
			#apt-get -fy install;
			#apt-get -y autoremove;
		done

	else
		if [ "${IS_DOCKER}"x = "0"x ]; then
			yum install -y ntp
			ntpdate -u pool.ntp.org
			date
		fi
		if [ "${IS_EXISTS_REMOVE}"x = "1"x ]; then
			rpm -qa|grep httpd
			rpm -e httpd
			rpm -qa|grep mysql
			rpm -e mysql
			rpm -qa|grep php
			rpm -e php

			yum -y remove httpd*
			yum -y remove php*
			yum -y remove mysql-server mysql
			yum -y remove php-mysql

			yum -y remove httpd
		fi
		yum -y install yum-fastestmirror
		if [ "${YUM_APT_GET_UPDATE}"x = "1"x ]; then
			yum update -y
		fi

		cp /etc/yum.conf /etc/yum.conf.lnmp
		sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf
		yum -y install gcc gcc-c++ gcc-g77 make

		for packages in patch cmake autoconf \
		flex bison file libtool libtool-libs \
		kernel-devel \
		libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel \
		gd gd-devel \
		freetype freetype-devel \
		libxml2 libxml2-devel \
		zlib zlib-devel glib2 glib2-devel \
		bzip2 bzip2-devel libevent libevent-devel \
		ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel \
		krb5 krb5-devel libidn libidn-devel \
		openssl openssl-devel \
		vim-minimal nano fonts-chinese \
		pcre pcre-devel libtool-ltdl-devel \
		wget \
		libmcrypt-devel libmhash-devel \
		gettext gettext-devel gmp-devel pspell-devel unzip libcap libcap-devel diffutils sendmail expat-devel;
		do 
			yum -y install $packages;
			echo
			echo "==>yum -y install $packages";
			echo
		done

		mv -f /etc/yum.conf.lnmp /etc/yum.conf
	fi
	ldconfig
	touch $IN_LOG
}

function Init_SetDirectoryAndUser
{
	echo
	echo "======make sure source files dir exists."
	echo $IN_DOWN
	echo
	
	cd $IN_PWD
	[ ! -d "$IN_DOWN" ] && mkdir $IN_DOWN
	
	#make sure install dir
	if [ ! -d "$IN_DIR" ]; then
		echo "=============Start creating users and user groups=========="
		echo "groupadd www"
		echo "useradd -s /sbin/nologin -g www www"
		echo "groupadd mysql"
		echo "useradd -s /sbin/nologin -g mysql mysql"
		
		groupadd www
		useradd -s /sbin/nologin -g www www
		
		groupadd mysql
		useradd -s /sbin/nologin -M -g mysql mysql
	
		echo "=============Finish creating users and user groups=========="
		
		echo 
		echo "=============Start to create the directory=========="
		echo $IN_DIR/etc
		echo $IN_DIR/action
		echo $IN_DIR/tmp
		echo $IN_DIR/run
		echo $IN_WEB_DIR/default
		echo $IN_WEB_LOG_DIR
		
		mkdir -p $IN_DIR/{etc,init.d,action,tmp,run}
		
		mkdir -p $IN_WEB_DIR/default
		chmod +w $IN_WEB_DIR/default
		mkdir -p $IN_WEB_LOG_DIR
		chmod 777 $IN_WEB_LOG_DIR
		
		chown -R www:www $IN_WEB_DIR/default
		
		echo "=============Finish to create the directory=========="
	fi
}

function Init_ReplacementSource()
{
	echo
	echo "============= ReplacementSource        ===="
	if [ $SOURCE_ID = 2 ]; then
	    if [ $OS_RL = "ubuntu" ]; then
	        sed -i 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//http:\/\/mirrors\.163\.com\/ubuntu\//g' /etc/apt/sources.list
			rm /var/lib/apt/lists/lock;
		    apt-get update;
		else
		    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
		    cd /etc/yum.repos.d/ 
			wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -O CentOS-Base.repo
			yum clean all 
			yum makecache
		fi
	fi
	echo "============= Finish ReplacementSource        ===="
}