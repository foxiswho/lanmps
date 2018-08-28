# php install function
function Install_PHP {
	local IN_LOG=$LOGPATH/install_Install_PHP_${PHP_VER}.sh.lock
	echo
    [ -f "$IN_LOG" ] && return
    echo "============================Install PHP ${PHP_VER}================================"
	echo "Input $PHP_VER_ID"
	echo "Install_PHP_VER $PHP_VER $PHP_KEY"
	echo "${IN_PWD}/lib/Install_PHP_${PHP_VER}.sh"
	
	local ver_tmp="7.2.x"
	if echo "${PHP_VER}" | grep -q "7.2."; then
	    ver_tmp="7.2.x"
	elif echo "${PHP_VER}" | grep -q "7.1."; then
    	    ver_tmp="7.1.x"
	elif echo "${PHP_VER}" | grep -q "7.0."; then
      	    ver_tmp="7.0.x"
    elif echo "${PHP_VER}" | grep -q "5.6."; then
    		ver_tmp="5.6.x"
	elif echo "${PHP_VER}" | grep -q "5.5."; then
		ver_tmp="5.5.x"
	elif echo "${PHP_VER}" | grep -q "5.4."; then
		ver_tmp="5.4.x"
	elif echo "${PHP_VER}" | grep -q "5.3."; then
		ver_tmp="5.3.x"
	elif echo "${PHP_VER}" | grep -q "5.2."; then
		ver_tmp="5.2.x"
	fi
	
	import "${IN_PWD}/lib/Install_PHP_${ver_tmp}.sh"
		
	echo "============================PHP ${PHP_VER} install completed======================"
	touch $IN_LOG
}