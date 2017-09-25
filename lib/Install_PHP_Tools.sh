function Install_PHP_Tools()
{
    # $1 第一个参数为 PHP安装后路径
    PHP_PATH=$1
    echo "PHP_PATH = ${PHP_PATH}"
	local php_ini=$PHP_PATH/php.ini
	echo "================================="
    echo "================================="
    echo "================================="
	echo "Install memcache php extension..."
	if [ $PHP_KEY == "php7.1.x" ]; then
	    echo "error: memcache不支持7.x"
	elif [ $PHP_KEY == "php7.0.x" ]; then
      	    echo "error: memcache不支持7.x"
    elif [ $PHP_KEY == "php5.6.x" ]; then
            echo "php5.6.x已关闭memcache"
	else
        echo "tar zxvf memcache-${VERS['php-memcache']}.tgz"
        cd $IN_DOWN
        tar zxvf memcache-${VERS['php-memcache']}.tgz
        cd memcache-${VERS['php-memcache']}
        ${PHP_PATH}/bin/phpize
        ./configure --enable-memcache --with-php-config=${PHP_PATH}/bin/php-config --with-zlib-dir
        make && make install
    fi
	echo "================================="
	echo "================================="
	echo "================================="
	echo "Install Redis php extension..."
	echo "${PHP_KEY} "
    echo "tar zxvf redis-${VERS['php-redis']}.tgz"
    cd $IN_DOWN

    if [ $PHP_KEY == "php7.1.x" ]; then
        tar zxvf redis-${VERS['php-redis']}.tgz
        cd redis-${VERS['php-redis']}
    elif [ $PHP_KEY == "php7.0.x" ]; then
        tar zxvf redis-${VERS['php-redis']}.tgz
        cd redis-${VERS['php-redis']}
    else
        tar zxvf redis-${VERS['php-redis2.x']}.tgz
        cd redis-${VERS['php-redis2.x']}
    fi

    make distclean
	${PHP_PATH}/bin/phpize
	./configure --with-php-config=${PHP_PATH}/bin/php-config
    make && make install
	echo "================================="
	echo "================================="
	echo "================================="

	local php_v=`${PHP_PATH}/bin/php -v`
	local php_ext_date="20160303"
	#extension=fileinfo.so\nextension=intl.so\nextension=phar.so
	local PHP_EXT='\n;extension = "memcache.so"\nextension = "redis.so"\n'
	sed -i 's#; extension_dir = "./"#extension_dir = "./"#' $php_ini
	echo "PHP 版本"
	echo "php_vvvvvvv"
	echo "${PHP_PATH}/bin/php -v"
	echo $php_v
	if echo "$php_v" | grep -q "7\.1\."; then
        	php_ext_date="20160303"
        	PHP_EXT='\nextension = "redis.so"\n'
        	echo "7.1."
	elif echo "$php_v" | grep -q "7\.0\."; then
    		php_ext_date="20151012"
    		PHP_EXT='\nextension = "redis.so"\n'
    		echo "7.0."
	elif echo "$php_v" | grep -q "5\.6\."; then
		php_ext_date="20131226"
		echo "5.6."
	elif echo "$php_v" | grep -q "5\.5\."; then
		php_ext_date="20121212"
		echo "5.5."
	elif echo "$php_v" | grep -q "5\.4\."; then
		php_ext_date="20100525"
		echo "5.4."
	elif echo "$php_v" | grep -q "5\.3\."; then
		php_ext_date="20090626"
		echo "5.3."
	elif echo "$php_v" | grep -q "5\.2\."; then
		php_ext_date="20060613"
		echo "5.2."
	fi
	echo "编译后 扩展日期文件夹"
	echo "${php_ext_date}"
	if [ "$php_ext_date" == "20090626" ]; then
	    php_ext_date="no-debug-zts-${php_ext_date}"
	elif [ "$php_ext_date" == "20100525" ]; then
	    php_ext_date="no-debug-zts-${php_ext_date}"
	else
	    php_ext_date="no-debug-non-zts-${php_ext_date}"
	fi
	echo "${php_ext_date}"
    local PHP_EXT2 =${PHP_EXT}'\n;extension = "ssh2.so"'
	EXTENSION_DIR=${PHP_PATH}/lib/php/extensions/${php_ext_date}
	sed -i "s#extension_dir = \"./\"#extension_dir=${EXTENSION_DIR}${PHP_EXT2}#" $php_ini
	echo 's#extension_dir = "./"#extension_dir = '${EXTENSION_DIR}${PHP_EXT2}'#'
	
	echo "Install xdebug php extension..."
	cd $IN_DOWN
	tar zxvf xdebug-${VERS['php-xdebug']}.tgz
	cd xdebug-${VERS['php-xdebug']}
	${PHP_PATH}/bin/phpize
	./configure --enable-xdebug --with-php-config=${PHP_PATH}/bin/php-config
	make && make install
	echo '
[Xdebug]
;zend_extension="'$PHP_PATH'/lib/php/extensions/'$php_ext_date'/xdebug.so"
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
        echo "==================================="
        echo "==================================="
        echo "==================================="

        chown -R www:www $IN_WEB_DIR/default

        cd $IN_DOWN
        echo "安装 composer "
        php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php

        php composer-setup.php

        php -r "unlink('composer-setup.php');"

        mv composer.phar /usr/local/bin/composer

    echo "安装php 扩展 ssh2"


    ProgramDownloadFiles "php-ssh2" "ssh2-${VERS['php-ssh2']}.tar.gz"
    cd ssh2-${VERS['php-ssh2']}
    make distclean
	${PHP_PATH}/bin/phpize
	./configure --with-ssh2=/usr/local/libssh2 --with-php-config=${PHP_PATH}/bin/php-config
    make && make install
}
