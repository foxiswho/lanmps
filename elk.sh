#!/usr/bin/env bash
# Check if user is not root
if [ $UID == 0 ]; then
    echo "Error: You must not be root to run the install script, please use not root to install elk";
    echo "不能使用root用户";
    exit;
fi
IN_PWD=$(pwd)
USER_NAME="elasticsearch"
HOME_PWD="/home/elasticsearch"

# elasticsearch logstash kibana
ELASTICSEARCH_URL="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.1.tar.gz"
ELASTICSEARCH_V="5.6.1"

LOGSTASH_URL="https://artifacts.elastic.co/downloads/logstash/logstash-5.6.1.tar.gz"
LOGSTASH_V="5.6.1"

KIBANA_URL="https://artifacts.elastic.co/downloads/kibana/kibana-5.6.1-linux-x86_64.tar.gz"
KIBANA_V="5.6.1"
#java
#http://www.oracle.com/technetwork/java/javase/downloads/index.html
JAVA_URL="http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz"
JAVA_V="jdk1.8.0_144"
JAVA_IS_INSTALLED="NO"

echo "系统检测JAVA是否已安装"
java -version
if [ $? = 0 ];then
    echo "java is installed 【已安装】"
    JAVA_IS_INSTALLED="YES"
else
    echo "java is not installed 【未安装】"
    echo -n "是否使用本程序自带JAVA脚本安装 (y/n)?: "
    read READ_JAVA_ID
    case $READ_JAVA_ID in
    Y | y)
          echo "开始执行 安装JAVA脚本"
          #绕过验证直接下载
          wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $JAVA_URL
          tar zxvf  jdk-*
          mkdir -p /usr/java
          #重命名 下载的压缩包
          #rename jdk _jdk jdk*
          mv $JAVA_V /usr/java/
          echo "设置环境变量"
          echo "export JAVA_HOME=/usr/java/${JAVA_V}
export JRE_HOME=\$JAVA_HOME/jre                 #tomcat需要
export PATH=\$JAVA_HOME/bin:\$PATH
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" > /etc/profile.d/java.sh
          echo "应用java 环境变量生效"
          . /etc/profile
          . /etc/bashrc
          ;;
    N | n)
          echo "你选择的时 不使用本程序自带JAVA脚本安装,请先安装完JAVA后,再执行本程序"
          exit 0
          ;;
    *)
         echo "你选择的时 不使用本程序自带JAVA脚本安装,请先安装完JAVA后,再执行本程序"
         exit 0
         ;;
    esac
fi
#新建用户组
groupadd elasticsearch
#建立用户
useradd  -g elasticsearch -m  elasticsearch
#创建密码
#passwd elasticsearch




#
echo "elasticsearch hard nofile 65536
elasticsearch soft nofile 65536 ">> /etc/security/limits.conf
#echo "vm.max_map_count=655360">> /etc/sysctl.conf
echo "vm.max_map_count=262144">> /etc/sysctl.conf

echo "export ES_HOME=/home/elasticsearch/elasticsearch-${ELASTICSEARCH_V}
export PATH=\$ES_HOME/bin:\$PATH" > /etc/profile.d/elasticsearch.sh

. /etc/profile
. /etc/bashrc

echo "切换到 elasticsearch 用户，和其目录"
su elasticsearch
cd ~
cd /home/elasticsearch



echo "下载 elasticsearch 开始"
wget $ELASTICSEARCH_URL


echo "下载 logstash 开始"
wget $LOGSTASH_URL


echo "下载 kibana 开始"
wget $KIBANA_URL
#wget $KIBANA_URL -O kibana-$KIBANA_V


echo "解压缩开始"
tar -zxvf "elasticsearch-$ELASTICSEARCH_V.tar.gz"
tar -zxvf "logstash-$LOGSTASH_V.tar.gz"
tar -zxvf "kibana-${KIBANA_V}-linux-x86_64.tar.gz"
mv "kibana-${KIBANA_V}-linux-x86_64" "kibana-${KIBANA_V}"

echo "解压缩后目录名是"
eccho $HOME_PWD/elasticsearch-${ELASTICSEARCH_V}
eccho $HOME_PWD/logstash-${LOGSTASH_V}
eccho $HOME_PWD/kibana-${KIBANA_V}

#设置其他IP可以访问
sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/g' $HOME_PWD/elasticsearch-$ELASTICSEARCH_V/config/elasticsearch.yml
sed -i 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' $HOME_PWD/kibana-${KIBANA_V}/config/kibana.yml




echo "elasticsearch 安装 x-pack 插件"

$HOME_PWD/elasticsearch-$ELASTICSEARCH_V/bin/elasticsearch-plugin install x-pack
$HOME_PWD/kibana-${KIBANA_V}/bin/kibana-plugin install x-pack

echo "初始
用户名为 elastic
密码为 changeme"