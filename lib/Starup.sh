# start services
function Starup()
{
	cd $IN_PWD
	
	echo "============================add nginx and php-fpm on startup============================"
	echo "Set start"
	systemd_path=/lib/systemd/system
	if [ ! -d "$systemd_path" ]; then
		if [ $OS_RL = "centos" ]; then
			if [ $SERVER == "nginx" ]; then
				chkconfig --add php-fpm
				chkconfig --level 345 php-fpm on
				
				chkconfig --add nginx
				chkconfig --level 345 nginx on
			else
				chkconfig --add httpd
				chkconfig --level 345 httpd on
			fi
			if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
                chkconfig --add mysql
                chkconfig --level 345 mysql on
            fi

			chkconfig --add memcached
			chkconfig --level 345 memcached on
		else
			if [ $SERVER == "apache" ]; then
				update-rc.d -f httpd defaults
			else
				update-rc.d -f php-fpm defaults
				update-rc.d -f nginx defaults
			fi
			if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
			    update-rc.d -f mysql defaults
			fi
			update-rc.d -f memcached defaults
		fi
	else
		file_cp $IN_PWD/conf/service.nginx.service "${systemd_path}/nginx.service"
		file_cp $IN_PWD/conf/service.php-fpm.service "${systemd_path}/php-fpm.service"
		file_cp $IN_PWD/conf/service.memcached.service "${systemd_path}/memcached.service"
		
		systemctl enable nginx.service
		systemctl enable php-fpm.service
		systemctl enable memcached.service

		
		
		systemctl start nginx.service
		systemctl start php-fpm.service
		systemctl start memcached.service

		if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
		    file_cp $IN_PWD/conf/service.mysql.service "${systemd_path}/mysql.service"
		    systemctl enable mysql.service
		    systemctl start mysql.service
		fi
	fi
	
	echo "===========================add nginx and php-fpm on startup completed===================="
	
	if [ "${FAST}" = "1" ];then
		echo "FAST"
	else
		file_cp $IN_PWD/conf/sh.lanmps.sh "${IN_DIR}/lanmps"
		if [ ! $IN_DIR = "/www/lanmps" ]; then
			sed -i 's:/www/lanmps:'$IN_DIR':g' $IN_DIR/lanmps
		fi
		chmod +x "${IN_DIR}/lanmps"
	fi
	ln -s $IN_DIR/lanmps /root/lanmps
	#sed -i "s:/usr/local/php/logs:$IN_DIR/php/var/run:g" "${IN_DIR}/lnmp"
	
	echo "Starting LANMPS..."
	if [ ! -d "$systemd_path" ]; then
		if [ $SERVER == "nginx" ]; then
			$IN_DIR/action/php-fpm start
			$IN_DIR/action/nginx start
		else
			$IN_DIR/action/httpd start
		fi
		
		$IN_DIR/action/memcached start

		if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
		    $IN_DIR/action/mysql start
		fi
	else
		systemctl start nginx.service
		systemctl start php-fpm.service
		systemctl start memcached.service

		if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
		    systemctl start mysql.service
		fi
	fi
	#add 80 port to iptables
	if [ -s /sbin/iptables ]; then
		/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
		/sbin/iptables -I INPUT -p tcp --dport 21 -j ACCEPT
		/sbin/iptables -I INPUT -p tcp --dport 22 -j ACCEPT
		iptables-save > /etc/iptables.up.rules
		iptables-save > /etc/network/iptables.up.rules
		#/etc/rc.d/action/iptables save
		#/etc/action/iptables restart
	fi
}

function CheckInstall()
{
	echo "===================================== Check install ==================================="
	clear
	isnginx=""
	ismysql=""
	isphp=""
	echo "Checking..."
	if [ $SERVER == "nginx" ]; then
		if [ -s $IN_DIR/nginx ] && [ -s $IN_DIR/nginx/sbin/nginx ]; then
			echo "${SERVER}: OK"
			isnginx="ok"
		else
			echo "Error: $IN_DIR/${SERVER} not found!!!${SERVER} install failed."
		fi
		
		if [ -s "$IN_DIR/php/sbin/php-fpm" ] && [ -s "$IN_DIR/php/php.ini" ] && [ -s $IN_DIR/php/bin/php ]; then
			echo "PHP: OK"
			echo "PHP-FPM: OK"
			isphp="ok"
		else
			echo "Error: $IN_DIR/php not found!!!PHP install failed."
		fi
	else
		if [ -s $IN_DIR/apache ] && [ -s $IN_DIR/apache/bin/httpd ]; then
			echo "${SERVER}: OK"
			isnginx="ok"
		else
			echo "Error: $IN_DIR/${SERVER} not found!!!${SERVER} install failed."
		fi
		
		if [ -s "$IN_DIR/php/php.ini" ] && [ -s $IN_DIR/php/bin/php ]; then
			echo "PHP: OK"
			isphp="ok"
		else
			echo "Error: $IN_DIR/php not found!!!PHP install failed."
		fi
	fi

	if [[ "${MYSQL_SELECT}"x != "0"x  ]]; then
	    if [ -s "$IN_DIR/mysql" ] && [ -s "$IN_DIR/mysql/bin/mysql" ]; then
            echo "MySQL: OK"
            ismysql="ok"
        else
            echo "Error: $IN_DIR/mysql not found!!!MySQL install failed."
        fi
	fi

	if [ "$isnginx" = "ok" ] && [ "$isphp" = "ok" ]; then
		echo "========================================================================="
		echo "LANMPS V2.2.1 for CentOS/Ubuntu Linux Written by Licess "
		echo "========================================================================="
		echo ""
		echo "For more information please visit http://www.lanmps.com"
		echo ""
		echo "lanmps status manage: $IN_DIR/lanmps {start|stop|reload|restart|kill|status}"
		if [ "$ismysql" = "ok" ]; then
		    echo "default mysql root password:$MysqlPassWord"
		fi
		echo "Prober : http://$IP/_tz.php"
		echo "phpinfo : http://$IP/_phpinfo.php"
		echo "phpMyAdmin : http://$IP/_phpmyadmin/"
		echo "Add VirtualHost : $IN_DIR/vhost.sh"
		echo ""
		echo "The path of some dirs:"
		if [ "$ismysql" = "ok" ]; then
		    echo "mysql dir:   $IN_DIR/$MYSQL_INITD"
		fi
		echo "php dir:     $IN_DIR/php"
		if [ $SERVER == "nginx" ]; then
			echo "nginx dir:   $IN_DIR/nginx"
		else
			echo "apache dir:   $IN_DIR/apache"
		fi
		echo "web dir :    $IN_WEB_DIR/default"
		echo ""
		echo "========================================================================="
		$IN_DIR/lanmps status
		netstat -ntl
	else
		echo "Sorry,Failed to install LANMPS!"
		echo "Please visit http://bbs.lanmps.com feedback errors and logs."
		echo "You can download $LOGPATH from your server,And upload all the files in the directory to the Forum."
	fi
}
