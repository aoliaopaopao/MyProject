#!/bin/bash
#author:aoliaopaopao v1.0
#文件位置
dir=/root/setup
#安装常用工具
rpm -ivh epel-release-6-8.noarch.rpm
yum install -y ntsysv wget vim openssh-clients java-1.8.0-openjdk*

#修改network
cat >> /etc/sysconfig/network << EOF
NOZEROCONF=yes
NETWORKING_IPV6=no
EOF

service network restart

#修改fstab
sed -i 's:/dev/shm:/tmp:' /etc/fstab
sed -i '9s/defaults/defaults,nodiratime,noatime/' /etc/fstab

#安装htpdate
rpm -ivh rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum install -y htpdate
sed -i '$ i SERVERS="www.qq.com www.baidu.com"' /etc/sysconfig/htpdate
sed -i 's/SERVERS="www.linux.org www.freebsd.org"/SERVERS="www.qq.com www.baidu.com"/' /etc/rc.d/init.d/htpdate
chkconfig --level 3 htpdate on
service htpdate start

#修改SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

#修改tty
sed -i 's/1-6/1-1/' /etc/sysconfig/init

#修改中文
sed -i '1d ' /etc/sysconfig/i18n && sed -i '1 i LANG="zh_CN.UTF-8"' /etc/sysconfig/i18n

cat >> /etc/profile <<EOF
LC_MESSAGES=en_US.UTF-8
LC_TIME=en_US.UTF-8
export LC_MESSAGES LC_TIME
EOF

sed -i 's/inet_protocols = all/inet_protocols = ipv4/' /etc/postfix/main.cf

#修改限制
cat >> /etc/security/limits.conf << EOF
* soft nproc  65535
* hard nproc  65535
* soft nofile 65535
* hard nofile 65535
EOF

sed -i 's/1024/65535/' /etc/security/limits.d/90-nproc.conf

#减少swap分区
cat >> /etc/sysctl.conf  << EOF
vm.swappiness = 0
EOF

sysctl -p

#修改iptables
sed -i '10 a -A INPUT -p tcp -m multiport --dports 2222 -j ACCEPT' /etc/sysconfig/iptables
service iptables restart

yum -y update

#编译工具安装
yum install -y crul curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel gcc perl-ExtUtils-MakeMaker  gcc make gcc-c++

#git安装
#wget https://www.kernel.org/pub/software/scm/git/git-2.11.1.tar.gz
tar -xvf git-2.11.1.tar.gz
cd git-2.11.1
autoconf
./configure
make
make install
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
source /etc/bashrc

#apache-maven
#wget http://apache.fayea.com/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
cd $dir
tar -xvf apache-maven-3.3.9-bin.tar.gz
mv apache-maven-3.3.9 /usr/local/src/

echo "MAVEN_HOME=/usr/local/src/apache-maven-3.3.9" >> /etc/profile
echo "export MAVEN_HOME" >> /etc/profile
echo 'export PATH=${PATH}:${MAVEN_HOME}/bin' >> /etc/profile

source /etc/profile


\cp -f settings.xml /usr/local/src/apache-maven-3.3.9/conf/

#nodejs&&pm2
#wget https://rpm.nodesource.com/setup_6.x
cd $dir
chmod +x setup_6.x
./setup_6.x
yum -y install nodejs

npm install -g pm2

#修改yum
yum install -y yum-cron
sed -i 's/plugins=1/plugins=0/' /etc/yum.conf && sed -i 's/enabled = 1/enabled = 0/' /etc/yum.repos.d/rpmforge.repo && sed -i '12 a exclude=kernel* centos-release*' /etc/yum.conf
chkconfig yum-cron on
service yum-cron start