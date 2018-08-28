#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin:~/bin
export PATH

PWD=$(pwd)
#循环当前目录
    for element in `ls $PWD`
    do
        dir_or_file=$PWD"/"$element
        if [ -d $dir_or_file ]
        then
            #这是目录
            echo "这是目录，删除目录 "$element
            rm -rf $element
        else
            # 这是文件
            echo "这是文件，不操作 "$element
        fi
    done