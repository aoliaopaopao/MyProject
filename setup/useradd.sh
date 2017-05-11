#!/bin/bash
echo "请输入要添加的用户！"
read name
useradd -gusers $name
passwd $name
#=============================
echo "是否给用户sudo权限,如果需要输入yes,否则输入任意"
read judge
if [ "$judge" = "yes" ] ; then
cat >> /etc/sudoers << EOF
$name    ALL=(ALL)       ALL
EOF
else
	echo "跳过sudo权限，正在执行下一步"
fi
#=============================
mkdir /home/$name/.ssh
chmod 700 /home/$name/.ssh
#============================
echo "请输入用户公钥"
read authorized_keys
echo "$authorized_keys" > /home/$name/.ssh/authorized_keys
chmod 600 /home/$name/.ssh/authorized_keys
chown -R $name.users /home/$name