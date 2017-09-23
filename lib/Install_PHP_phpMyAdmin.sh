function Install_PHP_phpMyAdmin()
{
	echo "================================="
    echo "================================="
    echo "================================="
	echo "======================= phpMyAdmin install ============================"
    local IN_LOG=$LOGPATH/install_Install_PHPMyadmin.sh.lock
	echo
    [ -f $IN_LOG ] && return
    ProgramDownloadFiles "phpMyAdmin" "phpMyAdmin-${VERS['phpMyAdmin']}-all-languages.tar.gz"
	
	cd $IN_DOWN
	tar zxvf phpMyAdmin-${VERS['phpMyAdmin']}-all-languages.tar.gz
	mv phpMyAdmin-${VERS['phpMyAdmin']}-all-languages $IN_WEB_DIR/default/_phpmyadmin
	mv $IN_WEB_DIR/default/_phpmyadmin/config.sample.inc.php $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s:UploadDir'] = '':UploadDir'] = 'upload':g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s#localhost#localhost:3306#g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	sed -i "s:SaveDir'] = '':SaveDir'] = 'save':g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php
	# 短语密码
	sed -i "s:blowfish_secret'] = '':blowfish_secret'] = 'LANMPS_${RANDOM}_':g" $IN_WEB_DIR/default/_phpmyadmin/config.inc.php

	mkdir $IN_WEB_DIR/default/_phpmyadmin/upload/
	mkdir $IN_WEB_DIR/default/_phpmyadmin/save/
	chmod 755 -R $IN_WEB_DIR/default/_phpmyadmin/
	chown www:www -R $IN_WEB_DIR/default/_phpmyadmin/
	
	touch $IN_LOG
	echo "============================phpMyAdmin install completed======================"s
}
