# Supervisor install function
function Install_Supervisor {
	local IN_LOG=$LOGPATH/Install_Supervisor.sh.lock
	echo
    [ -f "$IN_LOG" ] && return
	#http://www.51bbo.com/archives/2120
    echo "============================Install Supervisor=================================="
	
	if [ $OS_RL = "centos" ]; then
        yum install python-setuptools -y
		easy_install supervisor
        chkconfig supervisord on
        #echo_supervisord_conf > /etc/supervisord.conf

		#sed -i 's#;files\s*=\s*relative/directory/\*.ini#files = /etc/supervisor/conf.d/\*.conf#g' /etc/supervisord.conf
		#sed -i 's#logfile=/tmp/supervisord.log#logfile='"$IN_WEB_LOG_DIR"'/supervisord.log#g' /etc/supervisord.conf
		#sed -i 's#pidfile=/tmp/supervisord.pid#pidfile=/var/run/supervisord.pid#g' /etc/supervisord.conf

		file_cp conf.supervisord.conf /etc/supervisord.conf

        mkdir -p /etc/supervisor/conf.d/
		cd $IN_PWD
	    file_cp conf.supervisord.nginx.conf /etc/supervisor/conf.d/nginx.supervisord.conf
	    file_cp conf.supervisord.php-fpm.conf /etc/supervisor/conf.d/php-fpm.supervisord.conf
	    if [ "${IS_DOCKER}"x = "0"x ]; then
	        file_cp conf.supervisord.redis.conf /etc/supervisor/conf.d/redis.supervisord.conf
	        file_cp conf.supervisord.memcached.conf /etc/supervisor/conf.d/memcached.supervisord.conf
	    fi
    else
        apt-get install supervisor -y
    fi
	
	echo "============================Supervisor install completed========================="
	touch $IN_LOG
}
