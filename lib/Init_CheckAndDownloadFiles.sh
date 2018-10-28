function Init_CheckAndDownloadFiles()
{
    echo "============================check files=================================="
	
	ProgramDownloadFiles "$PHP_KEY" "php-${PHP_VER}.tar.gz"

	ProgramDownloadFiles "nginx" "nginx-${VERS['nginx']}.tar.gz"
	
	#ProgramDownloadFiles "apache" "httpd-${VERS['apache']}.tar.gz"
	
	if [ "$MYSQL_ID" == "mysql" ]; then
	    tmp_mysql="mysql${MYSQL_KEY}"
		ProgramDownloadFiles "${tmp_mysql}" "mysql-${tmp_mysql}.tar.gz"
	else
		ProgramDownloadFiles "mariadb" "mariadb-${VERS['mariadb10.3.x']}.tar.gz"
	fi
	
	#ProgramDownloadFiles "memcache" "memcache-${VERS['php-memcache']}.tgz"
	
	ProgramDownloadFiles "xdebug" "xdebug-${VERS['php-xdebug']}.tgz"

	ProgramDownloadFiles "redis" "redis-${VERS['php-redis']}.tgz"
	
	
	#ProgramIsInstalled "iconv" "libiconv-${VERS['libiconv']}.tar.gz" "libiconv"
	
	ProgramIsInstalled "autoconf" "autoconf-${VERS['autoconf']}.tar.gz"
	
	ProgramIsInstalled "libmcrypt" "libmcrypt-${VERS['libmcrypt']}.tar.gz"
	
	SoInstallationLocation "libpcre" "pcre-${VERS['libpcre']}.tar.gz"
	
	SoInstallationLocation "libxml2" "libxml2-${VERS['libxml2']}.tar.gz"

	#SoInstallationLocation "libltdl" "libltdl-${VERS['libltdl']}.tar.gz"
	
	#SoInstallationLocation "libmhash" "mhash-${VERS['libmhash']}.tar.gz"

	echo "============================check files=================================="
	echo
	echo "============================ependsAndOpt ===================="
	
	Install_Installed
	
	echo "============================ependsAndOpt ===================="
}

function Install_Installed()
{
	#ProgramInstalled "libpcre" "pcre-${VERS['libpcre']}.tar.gz" "--prefix=/usr/local/libpcre"
	if [ "${LIBS['libpcre']}" = "Installed" ]; then
		echo "libpcre  Installed "
	else
		echo "tar zxvf pcre-${VERS['libpcre']}.tar.gz"
		cd $IN_DOWN
		tar zxvf pcre-${VERS['libpcre']}.tar.gz
		cd pcre-${VERS['libpcre']}/
		./configure --prefix=/usr/local/libpcre
		make && make install
	fi
	
	/sbin/ldconfig
	
	ProgramInstalled "autoconf" "autoconf-${VERS['autoconf']}.tar.gz" "--prefix=/usr/local/autoconf"

	/sbin/ldconfig
	
	ProgramInstalled "libmcrypt" "libmcrypt-${VERS['libmcrypt']}.tar.gz"
	
	/sbin/ldconfig
	
	#ProgramInstalled "libltdl" "libltdl-${VERS['libltdl']}.tar.gz" "--enable-ltdl-install"
	cd $IN_DOWN/libmcrypt-${VERS['libmcrypt']}/libltdl/
	./configure --enable-ltdl-install
    make && make install
	
	/sbin/ldconfig
	
	#ProgramInstalled "libmhash" "mhash-${VERS['libmhash']}.tar.gz"
	
	#/sbin/ldconfig
	
	ProgramInstalled "libxml2" "libxml2-${VERS['libxml2']}.tar.gz" "--prefix=/usr/local/libxml2"
	
	#ProgramInstalled "libiconv" "libiconv-${VERS['libiconv']}.tar.gz" "--prefix=/usr/local/libiconv"
	cd $IN_DOWN
	tar -zxvf libiconv-${VERS['libiconv']}.tar.gz
	cd libiconv-${VERS['libiconv']}
	./configure --prefix=/usr/local/libiconv
	make && make install
	file_bk "/usr/bin/iconv"
	ln -s /usr/local/libiconv/bin/iconv  /usr/bin/iconv
	#ln -s /usr/local/libiconv/lib/libiconv.so /usr/lib/libiconv.so
	cat > /etc/ld.so.conf.d/libiconv.conf<<EOF
/usr/local/libiconv/lib
EOF
	
	/sbin/ldconfig
}

function Install_Openssl()
{
	cd $IN_DOWN
	tar zxvf openssl-1.0.2n.tar.gz
	cd openssl-1.0.2n
	./config --prefix=/usr/local/openssl
	make && make install
	mv /usr/bin/openssl /usr/bin/openssl.OFF
	mv /usr/include/openssl /usr/include/openssl.OFF
	ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
	ln -s /usr/local/openssl/include/openssl /usr/include/openssl
	cat > /etc/ld.so.conf.d/openssl.conf<<EOF
/usr/local/openssl/lib
EOF
	ldconfig -v
	openssl version -a
}