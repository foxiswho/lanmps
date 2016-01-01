# nginx install function
function Install_Apache {
	local IN_LOG=$LOGPATH/install_Install_Apache.sh.lock
	echo
    [ -f $IN_LOG ] && return
	echo "============================Install Nginx================================="
	ldconfig
	local tmp=$IN_DIR/tmp
	local conf=$IN_DIR/apache/conf/httpd.conf
	local conf_default=$IN_DIR/apache/conf/vhost/00000.default.conf
	
	cd $IN_DOWN
	tar zxvf httpd-${VERS['apache']}.tar.gz
	tar xzf apr-1.5.1.tar.gz
	tar xzf apr-util-1.5.4.tar.gz
	mv apr-1.5.1 httpd-${VERS['apache']}/srclib/apr
	mv apr-util-1.5.4 httpd-${VERS['apache']}/srclib/apr-util
	
	cd httpd-${VERS['apache']}/
	./configure \
	--prefix=$IN_DIR/apache \
	--with-included-apr \
	--enable-nonportable-atomics=yes \
	--with-z
	
	make && make install
	
	sed -i 's/User daemon/User www/g' $conf
    sed -i 's/Group daemon/Group www/g' $conf
	sed -i 's/#LoadModule authz_host_module/LoadModule authz_host_module/g' $conf
	sed -i 's/#LoadModule authz_core_module/LoadModule authz_core_module/g' $conf
	sed -i 's/#LoadModule userdir_module/LoadModule userdir_module/g' $conf
	sed -i 's/#LoadModule dir_module/LoadModule dir_module/g' $conf
	sed -i 's/#LoadModule mime_module/LoadModule mime_module/g' $conf
	sed -i 's/#LoadModule reqtimeout_module/LoadModule reqtimeout_module/g' $conf
	sed -i 's/#LoadModule filter_module/LoadModule filter_module/g' $conf
	sed -i 's/#LoadModule deflate_module/LoadModule deflate_module/g' $conf
	sed -i 's/#LoadModule headers_module/LoadModule headers_module/g' $conf
	sed -i 's/#LoadModule log_config_module/LoadModule log_config_module/g' $conf
	sed -i 's/#LoadModule unixd_module/LoadModule unixd_module/g' $conf
	sed -i 's/#LoadModule alias_module/LoadModule alias_module/g' $conf
	sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/g' $conf
	
    #echo "NameVirtualHost *:80" >> $conf
    #echo "Include conf/httpd-lanmps.conf" >> $conf
    #echo "Include conf/default.conf" >> $conf
    #echo "Include conf/wdcp.conf" >> $conf
	echo "ServerSignature off" >> $conf
	echo "ServerTokens prod" >> $conf
    echo "Include conf/vhost/*.conf" >> $conf
    mkdir -p $IN_DIR/apache/conf/{vhost,rewrite}
    sed -i '/#ServerName/a\
ServerName localhost
' $conf
	sed -i '#AddType application/x-compress .Z#a\
AddType application/x-httpd-php .php
' $conf

	ln -s $IN_DIR/apache/conf/vhost $IN_DIR/etc/
	
	cd $IN_PWD
	file_cp conf.apache.default.conf $conf_default

	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $conf_default
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $conf_default
		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $conf_default
	fi
	mkdir -p $IN_WEB_LOG_DIR/logs/default
	
	if [ $OS_RL == "ubuntu" ]; then
        file_cp action.httpd-ubuntu $IN_DIR/action/httpd
    else
        file_cp action.httpd $IN_DIR/action/httpd
    fi
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i 's:/www/lanmps:'$IN_DIR':g' $IN_DIR/action/nginx
	fi
	chmod +x $IN_DIR/action/httpd
	if [ $ETC_INIT_D_LN = 1 ]; then
		ln -s $IN_DIR/action/httpd $IN_DIR/init.d/httpd
	fi
	
	file_cp sh.vhost.sh $IN_DIR/vhost.sh
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/vhost.sh
		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $IN_DIR/vhost.sh
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $IN_DIR/vhost.sh
	fi
	chmod +x $IN_DIR/vhost.sh
	ln -s $IN_DIR/vhost.sh /root/vhost.sh
	
	unset tmp
	
	echo "============================Install Nginx================================="
	touch $IN_LOG
}