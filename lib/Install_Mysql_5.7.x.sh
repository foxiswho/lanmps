

MYSQL_PATH=$IN_DIR/mysql${VERS['mysql5.7.x']}

# mysql install function

	echo "Delete the old configuration files and directory   /etc/my.cnf /etc/mysql/my.cnf /etc/mysql/"
	[ -s /etc/my.cnf ] && file_bk "/etc/my.cnf"
	[ -s /etc/mysql/my.cnf ] && file_bk "/etc/mysql/my.cnf"
	[ -e /etc/mysql/ ] && file_bk "/etc/mysql/"
	
	cd $IN_DOWN
	tar zxvf mysql-${VERS['mysql5.7.x']}.tar.gz
	cd mysql-${VERS['mysql5.7.x']}/
cmake . \
-DCMAKE_INSTALL_PREFIX=$MYSQL_PATH \
-DMYSQL_DATADIR=$MYSQL_PATH/data \
-DSYSCONFDIR=$MYSQL_PATH \
-DMYSQL_UNIX_ADDR=$MYSQL_PATH/data/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_SSL=system \
-DWITH_ZLIB=system \
-DWITH_EMBEDDED_SERVER=1 \
-DENABLED_LOCAL_INFILE=1
	make && make install

    ln -s $MYSQL_PATH $IN_DIR/mysql
	local cnf=$MYSQL_PATH/my.cnf
	cp $IN_PWD/conf/conf.mysql.conf $cnf
	#cp $MYSQL_PATH/my-new.cnf $cnf
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $cnf
	fi
	
	sed -i 's:#loose-skip-innodb:loose-skip-innodb:g' $cnf
	sed -i "s#/www/lanmps/mysql#${MYSQL_PATH}#g" $cnf

	$MYSQL_PATH/scripts/mysql_install_db --defaults-file=$cnf --basedir=$MYSQL_PATH --datadir=$MYSQL_PATH/data --user=mysql
	chown -R mysql $MYSQL_PATH/data
	chgrp -R mysql $MYSQL_PATH/.
	
	cp support-files/mysql.server $IN_DIR/bin/mysql
	chmod 755 $IN_DIR/bin/mysql
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/bin/mysql
	fi

	cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${IN_DIR}/mysql/lib
/usr/local/lib
EOF

	ldconfig

	if [ -d "/proc/vz" ];then
		ulimit -s unlimited
	fi
	
	#start
	$IN_DIR/bin/mysql start

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
	
	$IN_DIR/bin/mysql restart
	$IN_DIR/bin/mysql stop