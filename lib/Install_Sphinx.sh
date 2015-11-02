# Sphinx install function
function Install_Sphinx {
	local IN_LOG=$LOGPATH/install_Install_Sphinx_${ELASTIC_SEARCH_ID}.sh.lock
	echo
    [ -f $IN_LOG ] && return
	echo "============================Install Sphinx >> ${ELASTIC_SEARCH_ID} ================================="
	
	import "${IN_PWD}/lib/Install_Sphinx_${ELASTIC_SEARCH_ID}.sh"
	
	echo "============================Install Sphinx >> ${ELASTIC_SEARCH_ID}================================="
	touch $IN_LOG
}