#!/usr/bin/env bash
function Install_PHP_Tools()
{
	local php_ini=$IN_DIR/php/php.ini
	
	echo "Install memcache php extension..."
	
	echo "tar zxvf memcache-${VERS['memcache']}.tgz"
	cd $IN_DOWN
	tar zxvf memcache-${VERS['memcache']}.tgz
	cd memcache-${VERS['memcache']}
	${IN_DIR}/php/bin/phpize
	./configure --enable-memcache --with-php-config=${IN_DIR}/php/bin/php-config --with-zlib-dir
	make && make install

	local php_v=`${IN_DIR}/php/bin/php -v`
	local php_ext_date="20131226"
	sed -i 's#; extension_dir = "./"#extension_dir = "./"#' $php_ini
	echo "${IN_DIR}/php/bin/php -v"
	echo $php_v
	if echo "$php_v" | grep -q "5.6."; then
		php_ext_date="20131226"
	elif echo "$php_v" | grep -q "5.5."; then
		php_ext_date="20121212"
	elif echo "$php_v" | grep -q "5.4."; then
		php_ext_date="20100525"
	elif echo "$php_v" | grep -q "5.3."; then
		php_ext_date="20090626"
	elif echo "$php_v" | grep -q "5.2."; then
		php_ext_date="20060613"
	fi
	if [ "$php_ext_date" == "20090626" ]; then
	    php_ext_date="no-debug-zts-${php_ext_date}"
	elif [ "$php_ext_date" == "20100525" ]; then
	    php_ext_date="no-debug-zts-${php_ext_date}"
	else
	    php_ext_date="no-debug-non-zts-${php_ext_date}"
	fi
	
	sed -i 's#extension_dir = "./"#extension_dir = "'$IN_DIR'/php/lib/php/extensions/'$php_ext_date'/"\nextension = "memcache.so"\nextension =redis.so\n#' $php_ini
	echo 's#extension_dir = "./"#extension_dir = "'$IN_DIR'/php/lib/php/extensions/'$php_ext_date'/"\nextension = "memcache.so"\nextension =redis.so\n#'

	echo "======================== Redis ==================================="
	wget https://github.com/nicolasff/phpredis/archive/master.zip -O phpredis-master.zip
	cd $IN_DOWN
	unzip phpredis-master.zip
	cd phpredis-master
	${IN_DIR}/php/bin/phpize
	./configure --with-php-config=${IN_DIR}/php/bin/php-config
	make && make install

	echo "================xdebug================================="
	echo "Install xdebug php extension..."
	cd $IN_DOWN
	tar zxvf xdebug-${VERS['xdebug']}.tgz
	cd xdebug-${VERS['xdebug']}
	${IN_DIR}/php/bin/phpize
	./configure --enable-xdebug --with-php-config=${IN_DIR}/php/bin/php-config
	make && make install
	echo '
[Xdebug]
;zend_extension="'$IN_DIR'/php/lib/php/extensions/no-debug-zts-'$php_ext_date'/xdebug.so"
;xdebug.auto_trace=1
;xdebug.collect_params=1
;xdebug.collect_return=1
;xdebug.trace_output_dir = "'$IN_WEB_LOG_DIR'"
;xdebug.profiler_enable=1
;xdebug.profiler_output_dir = "'$IN_WEB_LOG_DIR'" 
;xdebug.max_nesting_level=10000
;xdebug.remote_enable=1
;xdebug.remote_autostart = 0
;xdebug.remote_host=localhost
;xdebug.remote_port=9033
;xdebug.remote_handler=dbgp
;xdebug.idekey="PHPSTORM"  
' >> $php_ini


	echo "======================= phpMyAdmin install ============================"
    local IN_LOG=$LOGPATH/install_Install_PHPMyadmin.sh.lock
	echo
    [ -f $IN_LOG ] && return
	
	cd $IN_DOWN
	tar zxvf phpMyAdmin-${VERS['phpMyAdmin']}-all-languages.tar.gz
	mv phpMyAdmin-${VERS['phpMyAdmin']}-all-languages $IN_WEB_DIR/default/_phpmyadmin/
	mv $IN_WEB_DIR/default/_phpmyadmin/config.sample.inc.php $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s:UploadDir'] = '':UploadDir'] = 'upload':g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s#localhost#localhost:3306#g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s:SaveDir'] = '':SaveDir'] = 'save':g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	
	mkdir $IN_WEB_DIR/default/_phpmyadmin/upload/
	mkdir $IN_WEB_DIR/default/_phpmyadmin/save/
	chmod 755 -R $IN_WEB_DIR/default/_phpmyadmin/
	chown www:www -R $IN_WEB_DIR/default/_phpmyadmin/
	
	touch $IN_LOG
	echo "============================phpMyAdmin install completed======================"
	
	echo "Create PHP Info Tool..."
	#TOOLS
	cd $IN_PWD
	cp conf/index.html $IN_WEB_DIR/default/index.html
	cp conf/php.tz.php $IN_WEB_DIR/default/_tz.php
	cat > $IN_WEB_DIR/default/_phpinfo.php<<EOF
<?php
phpinfo();
?>
EOF
}
