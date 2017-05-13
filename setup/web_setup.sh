#!/bin/bash
echo "是否安装mysql,如果执行输入y,否则输入任意字符串"
read judge1
if [ "$judge1" = "y" ] ;then
	echo "正在安装mysql"
	rpm -ivh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
	yum install -y mysql-server mysql mysql-deve
	chkconfig --level 3 mysqld on
	service  mysqld start
else
	echo "跳过安装mysql，正在执行下一步"
fi
#================================================================================================
echo "是否安装nginx,如果执行输入y,否则输入任意字符串"
read judge2
if [ "$judge2" = "y" ] ;then
	echo "正在安装nginx"
	rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum install -y nginx
	chkconfig --level 3 nginx on
	service nginx start
else
        echo "跳过安装nginx，正在执行下一步"
fi
#================================================================================================
echo "是否安装redis,如果执行输入y,否则输入任意字符串"
read judge3
if [ "$judge3" = "y" ] ;then
	 rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
     yum -y --enablerepo=remi,remi-test install redis
     
     
else
        echo "跳过安装redis，程序结束"
fi

