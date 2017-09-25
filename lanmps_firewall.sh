#!/usr/bin/env bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin:~/bin
export PATH
# Check if user is root
if [ $UID != 0 ]; then echo "Error: You must be root to run the install script, please use root to install lanmps";exit;fi

#firwall-cmd：是Linux提供的操作firewall的一个工具；
#--permanent：表示设置为持久； 没有此参数重启后失效
#--add-port：标识添加的端口；
#-–zone 作用域
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent



# 使之生效  无需断开连接
firewall-cmd --reload



#1.启动防火墙
# systemctl start firewalld
#2.禁用防火墙
# systemctl stop firewalld
#3.设置开机启动
# systemctl enable firewalld
#4.停止并禁用开机启动
# sytemctl disable firewalld
#5.重启防火墙
# firewall-cmd --reload
#6.查看状态
# systemctl status firewalld
# 或者
# firewall-cmd --state
#7.查看版本
# firewall-cmd --version
#9.查看区域信息
# firewall-cmd --get-active-zones
#11.拒绝所有包
# firewall-cmd --panic-on
#12.取消拒绝状态
# firewall-cmd --panic-off
#13.查看是否拒绝
# firewall-cmd --query-panic