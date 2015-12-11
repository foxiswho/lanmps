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
    cd $IN_DOWN
	es=$IN_DOWN/elasticsearch-servicewrapper-master.zip
	if [ ! -f "$es" ]; then
	    wget https://github.com/elastic/elasticsearch-servicewrapper/archive/master.zip -O elasticsearch-servicewrapper-master.zip
	fi
    unzip elasticsearch-servicewrapper-master.zip
    cd elasticsearch-servicewrapper-master
    mv service $IN_DIR/elasticsearch/bin/

    #chmod +x $IN_DIR/elasticsearch/bin/plugin


	touch $IN_LOG
	echo "=========================== install ElasticSearch ======================"
}