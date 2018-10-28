# mariadb install function

    MYSQL_PATH=$IN_DIR/mariadb${VERS['mariadb10.3.x']}
    echo "============================Install MariaDB ${VERS['mariadb10.3.x']}=================================="
	echo "Delete the old configuration files and directory   /etc/my.cnf /etc/mysql/my.cnf /etc/mysql/"
	
	cd $IN_DOWN
	tar zxvf mariadb-${VERS['mariadb10.3.x']}.tar.gz
	cd mariadb-${VERS['mariadb10.3.x']}/
	cmake . \
	-DCMAKE_INSTALL_PREFIX=$MYSQL_PATH \
	-DINSTALL_SBINDIR=$MYSQL_PATH/bin
	-DMYSQL_DATADIR=$MYSQL_PATH/data \
	-DSYSCONFDIR=$MYSQL_PATH \
	-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
	-DMYSQL_TCP_PORT=3306 \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_MEMORY_STORAGE_ENGINE=1 \
	-DWITH_SPHINX_STORAGE_ENGINE=1 \
    -DWITH_XTRADB_STORAGE_ENGINE=1 \
	-DWITH_PARTITION_STORAGE_ENGINE=1 \
	-DEXTRA_CHARSETS=all \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DWITH_READLINE=1 \
	-DWITH_SSL=system \
	-DWITH_ZLIB=system \
	-DMYSQL_USER=mysql \
	-DWITH_EXTRA_CHARSETS=all \
	-DWITH_EMBEDDED_SERVER=1 \
	-DENABLED_LOCAL_INFILE=1
	make && make install

	local cnf=$MYSQL_PATH/my.cnf
	#cp $IN_PWD/conf/conf.mariadb.conf $cnf
	#cp $MYSQL_PATH/my-new.cnf $cnf
	#cp support-files/my-innodb-heavy-4G.cnf $cnf
	if [ ! -f support-files/wsrep.cnf ];then
	    cp support-files/wsrep.cnf $cnf
	elif
	    cp support-files/my-huge.cnf $cnf
	fi
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $cnf
	fi
	#ln -s $MYSQL_PATH/data/mysql.sock /tmp/mysql.sock
	
	sed -i 's:#loose-skip-innodb:loose-skip-innodb:g' $cnf
	sed -i 's:innodb_additional_mem_pool_size:#innodb_additional_mem_pool_size:g' $cnf
	sed -i "s#/www/lanmps/mysql#${MYSQL_PATH}#g" $cnf

	$MYSQL_PATH/scripts/mysql_install_db --defaults-file=$cnf --basedir=$MYSQL_PATH --datadir=$MYSQL_PATH/data --user=mysql
	chown -R mysql $MYSQL_PATH/data
	chgrp -R mysql $MYSQL_PATH/.

	MYSQL_BIN_PATH=$IN_DIR/bin/mariadb
	cp support-files/mysql.server $MYSQL_BIN_PATH
	chmod 755 $MYSQL_BIN_PATH
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $MYSQL_BIN_PATH
	fi
    sed -i 's#$bindir/mysqld_safe --datadir#$bindir/mysqld_safe --defaults-file="$basedir/my.cnf" --datadir#g' $MYSQL_BIN_PATH
    sed -i 's:parse_server_arguments :#parse_server_arguments :g' $MYSQL_BIN_PATH

	cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${MYSQL_PATH}/lib
/usr/local/lib
EOF

	ldconfig
	ln -s $MYSQL_PATH/lib /usr/lib/mysql
    ln -s $MYSQL_PATH/include/mysql /usr/include/mysql
	
	#start
	$MYSQL_BIN_PATH start
	


	$MYSQL_PATH/bin/mysqladmin -u root password $MysqlPassWord

	cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$MysqlPassWord') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password=''; 
drop database test;
DROP USER ''@'%';
flush privileges;
EOF

	$MYSQL_PATH/bin/mysql -u root -p$MysqlPassWord -h localhost < /tmp/mysql_sec_script

	rm -f /tmp/mysql_sec_script
	
	mkdir -p /var/log/mysqld
	#ln -s $MYSQL_PATH/data/mysql.sock /var/log/mysqld/mysql.sock
	
	$MYSQL_BIN_PATH restart
	$MYSQL_BIN_PATH stop

sed -i "s#bin/mysql#bin/mariadb#g" $IN_DIR/lanmps

ln -s $MYSQL_PATH/bin/mysql /usr/bin/mariadb
ln -s $MYSQL_PATH/bin/mysqldump /usr/bin/mariadbdump

if [ -e /usr/bin/mysql ]; then
       echo ""
else
        ln -s $MYSQL_PATH/bin/mysql /usr/bin/mysql
        ln -s $MYSQL_PATH/bin/mysqldump /usr/bin/mysqldump
fi
if [ -d "/proc/vz" ];then
    ulimit -s unlimited
fi

if [ ! -d "$IN_DIR/mysql/" ]; then
        ln -s $MYSQL_PATH $IN_DIR/mysql
fi
#mysql 软连接
ln -s $IN_DIR/bin/mariadb $IN_DIR/bin/mysql
#服务内名称等替换
sed -i "s#bin/mysql#bin/mariadb#g" $IN_PWD/conf/service.mysql.service
#sed -i "s#bin/mysql#bin/mariadb#g" $IN_PWD/conf/service.mariadb.service