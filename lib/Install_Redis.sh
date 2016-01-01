function Install_Redis()
{
	echo "=========================== install Redis START ======================"
	local IN_LOG=$LOGPATH/Redis.sh.lock
	echo
    [ -f "$IN_LOG" ] && return


	local Memcached_DIR=$IN_DIR/memcached
	phpRedisFile=$IN_DOWN/redis-stable.tar.gz
	if [ ! -f "$phpRedisFile" ]; then
	    wget ${DUS['redis']} -O redis-stable.tar.gz
	fi
	tar zxvf redis-stable.tar.gz
	cd redis-stable
	make PREFIX=$IN_DIR/redis install
	cp redis.conf $IN_DIR/redis/redis.conf
	sed -i "s:daemonize no:daemonize yes:g" $IN_DIR/redis/redis.conf
	sed -i "s:timeout 0:timeout 300:g" $IN_DIR/redis/redis.conf
	sed -i "s:loglevel notice:loglevel debug:g" $IN_DIR/redis/redis.conf
	sed -i "s:logfile """":logfile ${IN_WEB_LOG_DIR}/redis.log:g" $IN_DIR/redis/redis.conf
	
	cp ./utils/redis_init_script $IN_DIR/action/redis
	sed -i "s:EXEC=/usr/local/bin/redis-server:EXEC=${IN_DIR}/redis/bin/redis-server:g" $IN_DIR/action/redis
	sed -i "s:CLIEXEC=/usr/local/bin/redis-cli:CLIEXEC=${IN_DIR}/redis/bin/redis-cli:g" $IN_DIR/action/redis
	sed -i "s:/etc/redis/${REDISPORT}.conf:${IN_DIR}/redis/redis.conf:g" $IN_DIR/action/redis
	sed -i "s:/var/run/redis_${REDISPORT}.pid:/var/run/redis.pid:g" $IN_DIR/action/redis

	echo "=========================== install Redis  END ======================"
}