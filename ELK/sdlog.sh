#!/bin/bash
#将要打包的日志写到filelist下，datefile为日期存放目录
date1=$(date '+%Y%m%d')
#需要打包30天前的日志
date2=`date +%Y%m%d --date="-30 day"`
date3=`date +%Y%m --date="-30 day"`
notes=/var/log/dblogs_$date1.log

进入日志目录
cd /www/log

filelist="输入打包的日志文件$date2.log"

#日志备份的目录
datefile=/mnt/$date3

for file in $filelist
do
    if [ -f $file ]; then
          echo "------'$date1'程序开始执行------" >> $notes
          echo "---------开始打包'$file'日志---------" >> $notes
          echo "+++++++++++++++++++++++++++++++++++++++++++++" >> $notes
          tar -zcf $file.tar.gz $file

          if [ -f $datefile ]; then
                echo "===========================================" >> $notes
          else
                mkdir -p $datefile
          fi

            mv $file.tar.gz  $datefile
            rm -rf $file
          echo "------'$date1''程序执行结束------" >> $notes
          echo "=============================================" >> $notes
   else
          echo "=============================================" >> $notes
          echo "------'$date1' $file 没有日志产生!-----" >> $notes
          echo "=============================================" >> $notes
   fi
done
