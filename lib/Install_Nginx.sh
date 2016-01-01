# nginx install function
function Install_Nginx {
	local IN_LOG=$LOGPATH/install_Install_Nginx.sh.lock
	echo
    [ -f $IN_LOG ] && return
	echo "============================Install Nginx================================="
	ldconfig
	local tmp=$IN_DIR/tmp
	local conf=$IN_DIR/nginx/conf/nginx.conf
	local conf_default=$IN_DIR/nginx/conf/vhost/00000.default.conf
	
	cd $IN_DOWN
	tar zxvf nginx-${VERS['nginx']}.tar.gz
	cd nginx-${VERS['nginx']}/
	./configure \
	--user=www \
	--group=www \
	--prefix=$IN_DIR/nginx \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-ipv6 \
	--http-proxy-temp-path=${tmp}/nginx-proxy \
	--http-fastcgi-temp-path=${tmp}/nginx-fcgi \
	--http-uwsgi-temp-path=${tmp}/nginx-uwsgi \
	--http-scgi-temp-path=${tmp}/nginx-scgi \
	--http-client-body-temp-path=${tmp}/nginx-client \
	--http-log-path=${IN_WEB_LOG_DIR}/http.log \
	--error-log-path=${IN_WEB_LOG_DIR}/http-error.log 
	make && make install
	#--pid-path=$IN_DIR/nginx/logs/nginx.pid 
	#--lock-path=${tmp}/nginx.lock
	ln -s $IN_DIR/nginx/sbin/nginx /usr/bin/nginx

	cd $IN_PWD
	file_cp conf.nginx.conf $conf

	cd $IN_PWD
	#rm -f $IN_DIR/nginx/conf/fastcgi.conf
	file_cp conf.fastcgi.conf $IN_DIR/nginx/conf/fastcgi.conf
	file_cp conf.upstream.conf $IN_DIR/nginx/conf/upstream.conf
	
	mkdir -p $IN_DIR/nginx/conf/vhost
	chmod +w $IN_DIR/nginx/conf/vhost
	
	ln -s $IN_DIR/nginx/conf/vhost $IN_DIR/etc/
	
	file_cp conf.default.conf $conf_default
	file_cp sh.vhost.sh $IN_DIR/vhost.sh
	file_cp action.nginx $IN_DIR/action/nginx
	if [ ! $IN_DIR = "/www/lanmps" ]; then
	    sed -i "s:/www/lanmps:$IN_DIR:g" $conf
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $conf

		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $conf_default
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $conf_default
		sed -i 's:/www/lanmps:'$IN_DIR':g' $IN_DIR/action/nginx

		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/vhost.sh
		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $IN_DIR/vhost.sh
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $IN_DIR/vhost.sh
	fi

	chmod +x $IN_DIR/action/nginx
	chmod +x $IN_DIR/vhost.sh
	ln -s $IN_DIR/vhost.sh /root/vhost.sh
	
	cd $IN_PWD
	#cp conf/dabr.conf $IN_DIR/nginx/conf/dabr.conf
	#cp conf/discuz.conf $IN_DIR/nginx/conf/discuz.conf
	#cp conf/sablog.conf $IN_DIR/nginx/conf/sablog.conf
	#cp conf/typecho.conf $IN_DIR/nginx/conf/typecho.conf
	#cp conf/wordpress.conf $IN_DIR/nginx/conf/wordpress.conf
	#cp conf/discuzx.conf $IN_DIR/nginx/conf/discuzx.conf
	#cp conf/wp2.conf $IN_DIR/nginx/conf/wp2.conf
	#cp conf/phpwind.conf $IN_DIR/nginx/conf/phpwind.conf
	#cp conf/shopex.conf $IN_DIR/nginx/conf/shopex.conf
	#cp conf/dedecms.conf $IN_DIR/nginx/conf/dedecms.conf
	#cp conf/drupal.conf $IN_DIR/nginx/conf/drupal.conf
	#cp conf/ecshop.conf $IN_DIR/nginx/conf/ecshop.conf
	unset tmp
	
	echo "============================Install Nginx================================="
	touch $IN_LOG
}