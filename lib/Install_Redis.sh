#!/usr/bin/env bash
function Install_Redis()
{
	echo "=========================== install Redis START ======================"
	local IN_LOG=$LOGPATH/Redis.sh.lock
	echo
    [ -f "$IN_LOG" ] && return


	local Memcached_DIR=$IN_DIR/memcached
	wget ${DUS['redis']}
	tar xzf redis-${VERS['redis']}.tar.gz
	cd redis-${VERS['redis']}
	make PREFIX=$IN_DIR/redis install


	echo "=========================== install Redis  END ======================"
}