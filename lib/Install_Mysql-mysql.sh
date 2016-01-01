# mysql install function

	echo "Delete the old configuration files and directory   /etc/my.cnf /etc/mysql/my.cnf /etc/mysql/"
	[ -s /etc/my.cnf ] && file_bk "/etc/my.cnf"
	[ -s /etc/mysql/my.cnf ] && file_bk "/etc/mysql/my.cnf"
	[ -e /etc/mysql/ ] && file_bk "/etc/mysql/"
	
	cd $IN_DOWN
	tar zxvf mysql-${VERS['mysql']}.tar.gz
	cd mysql-${VERS['mysql']}/
	cmake . \
	-DCMAKE_INSTALL_PREFIX=$IN_DIR/mysql \
	-DMYSQL_DATADIR=$IN_DIR/mysql/data \
	-DSYSCONFDIR=$IN_DIR/mysql \
	-DMYSQL_UNIX_ADDR=$IN_DIR/mysql/data/mysql.sock \
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

	local cnf=$IN_DIR/mysql/my.cnf
	cp $IN_PWD/conf/conf.mysql.conf $cnf
	ln -s $cnf $IN_DIR/etc/my.cnf

	cp support-files/mysql.server $IN_DIR/action/mysql
	chmod 755 $IN_DIR/action/mysql
	if [ $ETC_INIT_D_LN = 1 ]; then
		ln -s $IN_DIR/action/mysql $IN_DIR/init.d/mysql
	fi
	if [ ! $IN_DIR = "/www/lanmps" ]; then
	    sed -i "s:/www/lanmps:$IN_DIR:g" $cnf
	    sed -i 's:#loose-skip-innodb:loose-skip-innodb:g' $cnf
		sed -i "s:/www/lanmps:$IN_DIR:g" $IN_DIR/action/mysql
	fi

	$IN_DIR/mysql/scripts/mysql_install_db --defaults-file=$cnf --basedir=$IN_DIR/mysql --datadir=$IN_DIR/mysql/data --user=mysql
	chown -R mysql $IN_DIR/mysql/data
	chgrp -R mysql $IN_DIR/mysql/.
	


	cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${IN_DIR}/mysql/lib
/usr/local/lib
EOF

	ldconfig

	ln -s $IN_DIR/mysql/lib/mysql /usr/lib/mysql
	ln -s $IN_DIR/mysql/include/mysql /usr/include/mysql
	if [ -d "/proc/vz" ];then
		ulimit -s unlimited
	fi
	
	#start
	$IN_DIR/action/mysql start
	
	ln -s $IN_DIR/mysql/bin/mysql /usr/bin/mysql
	ln -s $IN_DIR/mysql/bin/mysqldump /usr/bin/mysqldump
	ln -s $IN_DIR/mysql/bin/myisamchk /usr/bin/myisamchk
	ln -s $IN_DIR/mysql/bin/mysqld_safe /usr/bin/mysqld_safe

	$IN_DIR/mysql/bin/mysqladmin -u root password $MysqlPassWord

	cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$MysqlPassWord') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password=''; 
drop database test;
DROP USER ''@'%';
flush privileges;
EOF

	$IN_DIR/mysql/bin/mysql -u root -p$MysqlPassWord -h localhost < /tmp/mysql_sec_script

	rm -f /tmp/mysql_sec_script
	
	$IN_DIR/action/mysql restart
	$IN_DIR/action/mysql stop

