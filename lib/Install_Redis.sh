function Install_Redis()
{
	echo "=========================== install Redis ======================"
	echo "=========================== install Redis ======================"
	echo "=========================== install Redis ======================"
	local IN_LOG=$LOGPATH/install_Install_Redis.sh.lock
	echo
    [ -f "$IN_LOG" ] && return

    REDIS_PATH=${IN_DIR}/redis
    mkdir -p $REDIS_PATH

    cd $IN_DOWN
    tar zxvf redis-${VERS['redis']}.tar.gz
    cd redis-${VERS['redis']}
    make prefix=$REDIS_PATH

    cp -rf src/redis-server  $REDIS_PATH
    cp -rf src/redis-benchmark $REDIS_PATH
    cp -rf src/redis-cli  $REDIS_PATH
    cp -rf src/redis-check-aof  $REDIS_PATH
    cp -rf src/redis-check-rdb  $REDIS_PATH
    cp -rf redis.conf  $REDIS_PATH
    cp -rf utils/redis_init_script ${IN_DIR}/bin/redis

    if [ -e /usr/local/bin/redis-server ]; then
        echo ""
    else
        ln -s "${REDIS_PATH}/redis-server" /usr/local/bin/redis-server
        ln -s "${REDIS_PATH}/redis-cli" /usr/local/bin/redis-cli
    fi
    CONF_FILE=$REDIS_PATH/redis.conf
    #设置配置文件后台运行
    sed -i "s#daemonize no#daemonize yes#g" $CONF_FILE
    # 修改日志文件
    sed -i "s#logfile \"\"#logfile \"/www/wwwLogs/redis.log\"#g" $CONF_FILE
    # 设置启动配置相关
    sed -i "s#/etc/redis/\${REDISPORT}.conf#${REDIS_PATH}/redis.conf#g" ${IN_DIR}/bin/redis
    sed -i "s#start)#restart)\n\$0 stop\n\$0 start\n;;\nstart)#g" ${IN_DIR}/bin/redis
    sed -i "s#argument\"#argument\"\necho \"Usage: \$0 \{start|stop|restart\}\"#g"  ${IN_DIR}/bin/redis
    #服务内名称等替换

	touch $IN_LOG
	echo "=========================== install Redis End======================"
	echo "=========================== install Redis End======================"
	echo "=========================== install Redis End======================"
}