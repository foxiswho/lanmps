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
	--with-http_v2_module \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-http_secure_link_module \
	--with-http_random_index_module \
	--with-http_dav_module \
	--with-http_sub_module \
	--with-http_addition_module \
	--with-http_realip_module \
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
	#--with-http_secure_link_module 防盗链
	#--with-http_random_index_module 从目录中选择一个随机主页
	#--with-http_gzip_static_module 在线实时压缩输出数据流
	#--with-http_dav_module  增加PUT,DELETE,MKCOL：创建集合,COPY和MOVE方法
	#--with-http_sub_module 允许用一些其他文本替换nginx响应中的一些文本
	#--with-http_addition_module 作为一个输出过滤器，支持不完全缓冲，分部分响应请求
	#--with-http_realip_module 启用ngx_http_realip_module支持（这个模块允许从请求标头更改客户端的IP地址值，默认为关）
    #nginx 启动项软连接
	ln -s $IN_DIR/nginx/sbin/nginx /usr/bin/nginx

    #nginx 配置文件
	cd $IN_PWD
	file_cp conf.nginx.conf $conf
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $conf
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $conf
	fi
	
	cd $IN_PWD
	#关闭 nginx 版本显示
	local FASTCGI_FILE=$IN_DIR/nginx/conf/fastcgi.conf
    sed -i "s#nginx/\$nginx_version#nginx#g" $FASTCGI_FILE
    #echo "try_files \$fastcgi_script_name =404;" >> $FASTCGI_FILE
    # upstream 设置单独文件
	file_cp conf.upstream.conf $IN_DIR/nginx/conf/upstream.conf
	
	mkdir -p $IN_DIR/nginx/conf/vhost
	chmod +w $IN_DIR/nginx/conf/vhost
	
	ln -s $IN_DIR/nginx/conf/vhost $IN_DIR/etc/
	
	file_cp conf.default.conf $conf_default
	#检测目录是否改动安装目录
	if [ ! $IN_WEB_DIR = "/www/wwwroot" ]; then
		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $conf_default
	fi
	if [ ! $IN_WEB_LOG_DIR = "/www/wwwLogs" ]; then
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $conf_default
	fi
	
	file_cp bin.nginx $IN_DIR/bin/nginx
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i 's:/www/lanmps:'$IN_DIR':g' $IN_DIR/bin/nginx
	fi
	chmod +x $IN_DIR/bin/nginx
	#虚拟目录命令
	file_cp sh.vhost.sh $IN_DIR/vhost.sh
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/vhost.sh
	fi
	if [ ! $IN_WEB_DIR = "/www/wwwroot" ]; then
		sed -i "s:/www/wwwroot:$IN_WEB_DIR:g" $IN_DIR/vhost.sh
	fi
	if [ ! $IN_WEB_LOG_DIR = "/www/wwwLogs" ]; then
		sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $IN_DIR/vhost.sh
	fi
	#虚拟目录命令
	chmod +x $IN_DIR/vhost.sh
	ln -s $IN_DIR/vhost.sh /root/vhost.sh
:<<注释
	file_cp $IN_PWD/conf/sh.lanmps.sh "${IN_DIR}/lanmps"
    if [ ! $IN_DIR = "/www/lanmps" ]; then
        sed -i 's:/www/lanmps:'$IN_DIR':g' $IN_DIR/lanmps
    fi
    chmod +x "${IN_DIR}/lanmps"
    ln -s $IN_DIR/lanmps /root/lanmps
注释
	unset tmp
	
	echo "============================Install Nginx================================="
	touch $IN_LOG
}