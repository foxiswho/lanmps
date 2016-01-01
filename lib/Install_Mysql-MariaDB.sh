# mariadb install function
	
    echo "============================Install MariaDB ${VERS['MariaDB']}=================================="
	echo "Delete the old configuration files and directory   /etc/my.cnf /etc/mysql/my.cnf /etc/mysql/"
	[ -s /etc/my.cnf ] && file_bk "/etc/my.cnf"
	[ -s /etc/mysql/my.cnf ] && file_bk "/etc/mysql/my.cnf"
	[ -e /etc/mysql/ ] && file_bk "/etc/mysql/"
	TMP_TTT_MARIADB_PATH=$IN_DIR/mysql
	
	cd $IN_DOWN
	tar zxvf mariadb-${VERS['MariaDB']}.tar.gz
	cd mariadb-${VERS['MariaDB']}/
	cmake . \
	-DCMAKE_INSTALL_PREFIX=$TMP_TTT_MARIADB_PATH \
	-DMYSQL_DATADIR=$TMP_TTT_MARIADB_PATH/data \
	-DSYSCONFDIR=$TMP_TTT_MARIADB_PATH \
	-DMYSQL_UNIX_ADDR=$TMP_TTT_MARIADB_PATH/data/mysql.sock \
	-DMYSQL_TCP_PORT=3306 \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_MEMORY_STORAGE_ENGINE=1 \
	-DWITH_PARTITION_STORAGE_ENGINE=1 \
	-DEXTRA_CHARSETS=all \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DWITH_READLINE=1 \
	-DWITH_SSL=system \
	-DWITH_ZLIB=system \
	-DMYSQL_USER=mysql \
	-DWITH_EMBEDDED_SERVER=1 \
	-DENABLED_LOCAL_INFILE=1
	make && make install

	local cnf=$TMP_TTT_MARIADB_PATH/my.cnf
	cp $IN_PWD/conf/conf.mariadb.conf $cnf
	ln -s $cnf $IN_DIR/etc/my.cnf
	if [ $INNODB_ID = 1 ]; then
		sed -i 's:#loose-skip-innodb:loose-skip-innodb:g' $cnf
	fi
	cp support-files/mysql.server $IN_DIR/action/mysql
	chmod 755 $IN_DIR/action/mysql
	if [ $ETC_INIT_D_LN = 1 ]; then
		ln -s $IN_DIR/action/mysql $IN_DIR/init.d/mysql
	fi
	if [ ! $IN_DIR = "/www/lanmps" ]; then
	    sed -i "s:/www/lanmps:$IN_DIR:g" $cnf
	    sed -i "s:/www/wwwLogs:$IN_WEB_LOG_DIR:g" $cnf
		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/action/mysql
	fi

	$TMP_TTT_MARIADB_PATH/scripts/mysql_install_db --defaults-file=$cnf --basedir=$TMP_TTT_MARIADB_PATH --datadir=$TMP_TTT_MARIADB_PATH/data --user=mysql
	chown -R mysql $TMP_TTT_MARIADB_PATH/data
	chgrp -R mysql $TMP_TTT_MARIADB_PATH/.
	


	cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${TMP_TTT_MARIADB_PATH}/lib
/usr/local/lib
EOF

	ldconfig

	ln -s $TMP_TTT_MARIADB_PATH/lib/mysql /usr/lib/mysql
	ln -s $TMP_TTT_MARIADB_PATH/include/mysql /usr/include/mysql
	if [ -d "/proc/vz" ];then
		ulimit -s unlimited
	fi
	
	#start
	$IN_DIR/action/mysql start
	
	ln -s $TMP_TTT_MARIADB_PATH/bin/mysql /usr/bin/mysql
	ln -s $TMP_TTT_MARIADB_PATH/bin/mysqldump /usr/bin/mysqldump
	ln -s $TMP_TTT_MARIADB_PATH/bin/myisamchk /usr/bin/myisamchk
	ln -s $TMP_TTT_MARIADB_PATH/bin/mysqld_safe /usr/bin/mysqld_safe

	$TMP_TTT_MARIADB_PATH/bin/mysqladmin -u root password $MysqlPassWord

	cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$MysqlPassWord') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password=''; 
drop database test;
DROP USER ''@'%';
flush privileges;
EOF

	$TMP_TTT_MARIADB_PATH/bin/mysql -u root -p$MysqlPassWord -h localhost < /tmp/mysql_sec_script

	rm -f /tmp/mysql_sec_script
	
	mkdir -p /var/log/mysqld
	ln -s $IN_DIR/mysql/data/mysql.sock /var/log/mysqld/mysql.sock
	
	$IN_DIR/action/mysql restart
	$IN_DIR/action/mysql stop

