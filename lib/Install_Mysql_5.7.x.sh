

MYSQL_PATH=$IN_DIR/mysql${VERS['mysql5.7.x']}

# mysql install function

local OTHER_MAKE=" -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/include/boost "

cd $IN_DOWN
BOOST_FILE=boost_${VERS['boost']}.tar.gz
ProgramDownloadFiles "boost" "boost-${VERS['boost']}.tar.gz"
if [ -f "$IN_DOWN/$BOOST_FILE" ]; then
    echo ""
else
    wget http://download.lanmps.com/basic/boost_${VERS['boost']}.tar.gz
fi

mkdir -p /usr/local/include/boost
cp -rf boost_1_59_0.tar.gz /usr/local/include/boost

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
-DENABLED_LOCAL_INFILE=1 $OTHER_MAKE
	make && make install

    ln -s $MYSQL_PATH $IN_DIR/mysql
	local cnf=$MYSQL_PATH/my.cnf
	#cp $IN_PWD/conf/conf.mysql.conf $cnf
	#cp $MYSQL_PATH/my-new.cnf $cnf
	#cp support-files/my-huge.cnf $cnf
	cp support-files/my-default.cnf $cnf
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $cnf
	fi
	
	sed -i 's:#loose-skip-innodb:loose-skip-innodb:g' $cnf
	sed -i "s#/www/lanmps/mysql#${MYSQL_PATH}#g" $cnf
#--defaults-file=$cnf
	$MYSQL_PATH/bin/mysqld --initialize-insecure --basedir=$MYSQL_PATH --datadir=$MYSQL_PATH/data --user=mysql --explicit_defaults_for_timestamp=1
	chown -R mysql $MYSQL_PATH/data
	chgrp -R mysql $MYSQL_PATH/.

	$MYSQL_PATH/bin/mysql_ssl_rsa_setup

	MYSQL_BIN_PATH=$IN_DIR/bin/mysql
	cp support-files/mysql.server $MYSQL_BIN_PATH
	chmod 755 $MYSQL_BIN_PATH
	if [ ! $IN_DIR = "/www/lanmps" ]; then
		sed -i "s:/www/lanmps:$IN_DIR:g" $MYSQL_BIN_PATH
	fi

	cat > /etc/ld.so.conf.d/mysql.conf<<EOF
${IN_DIR}/mysql/lib
/usr/local/lib
EOF

	ldconfig
		ln -s $MYSQL_PATH/lib /usr/lib/mysql
        ln -s $MYSQL_PATH/include/mysql /usr/include/mysql

	if [ -d "/proc/vz" ];then
		ulimit -s unlimited
	fi
	
	#start
	$MYSQL_BIN_PATH start

	ln -s $MYSQL_PATH/bin/mysql /usr/bin/mysql
    ln -s $MYSQL_PATH/bin/mysqldump /usr/bin/mysqldump

:<<注释
	$MYSQL_PATH/bin/mysqladmin -u root password $MysqlPassWord

	cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set authentication_string=password('$MysqlPassWord') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and authentication_string='';
DROP USER ''@'%';
flush privileges;
EOF

	$MYSQL_PATH/bin/mysql -u root -p$MysqlPassWord -h localhost < /tmp/mysql_sec_script

	rm -f /tmp/mysql_sec_script

	#sed -i "s#bin/mysql#bin/mysql#g" $IN_DIR/lanmps
	
	$MYSQL_BIN_PATH restart
注释

	$MYSQL_BIN_PATH stop