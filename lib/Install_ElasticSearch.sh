function Install_ElasticSearch()
{
	echo "=========================== install ElasticSearch ======================"
	local IN_LOG=$LOGPATH/install_Install_ElasticSearch.sh.lock
	echo
    [ -f "$IN_LOG" ] && return
	local ElasticSearch_DIR=$IN_DIR/memcached
    ProgramDownloadFiles "elasticsearch" "elasticsearch-${VERS['ElasticSearch']}.tar.gz"

    cd $IN_DOWN
    mv elasticsearch-${VERS['ElasticSearch']} $IN_DIR/elasticsearch
    wget https://github.com/elastic/elasticsearch-servicewrapper/archive/master.zip -O master.zip
    unzip master.zip
    cd elasticsearch-servicewrapper-master
    mv service $IN_DIR/elasticsearch/bin/

    #chmod +x $IN_DIR/elasticsearch/bin/plugin

    if [ $OS_RL = "centos" ]; then
        yum install python-setuptools -y
        easy_install supervisor
        echo_supervisord_conf > /etc/supervisord.conf
    else
        apt-get install supervisor -y
    fi

	touch $IN_LOG
	echo "=========================== install ElasticSearch ======================"
}