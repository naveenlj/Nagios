#!/bin/bash

set -x 

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Disable SElinux
sed -i.bak 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
setenforce 0
 
 #yum install php php-cli gcc glibc glibc-common gd gd-devel net-snmp -y

which  wget >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install wget >/dev/null 2>&1
fi

which  httpd >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install  httpd >/dev/null 2>&1
fi

which php >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install php >/dev/null 2>&1
fi

which php-cli >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install php-cli >/dev/null 2>&1
fi

which gcc >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install gcc >/dev/null 2>&1
fi

which glibc >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install glibc >/dev/null 2>&1
fi
which glibc-common >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install glibc-common >/dev/null 2>&1
fi

which gd >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install gd >/dev/null 2>&1
fi

which gd-devel >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install gd-devel >/dev/null 2>&1
fi

which net-snmp >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install net-snmp >/dev/null 2>&1
fi

which git >/dev/null 2>&1
if  [ $? != 0 ]; then
  yum install git >/dev/null 2>&1
fi

# start httpd 

service httpd start

# add nagios users

useradd nagios

passwd nagios

groupadd nagcmd

usermod -a -G nagcmd nagios

usermod -a -G nagcmd apache

# changing directory

 cd /opt/

 wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.1.1.tar.gz
 
 
 tar xzf nagios-4.1.1.tar.gz
 
 cd nagios-4.1.1
 
 ./configure --with-command-group=nagcmd
 
 make all
 
 make install
 
 make install-init
 
 make install-config
 
 make install-commandmode

 make install-webconf

cd ..

htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

# Restart httpd 

service httpd restart

 cd /opt

 wget http://nagios-plugins.org/download/nagios-plugins-2.1.1.tar.gz

 tar xzf nagios-plugins-2.1.1.tar.gz

 cd nagios-plugins-2.1.1

 ./configure --with-nagios-user=nagios --with-nagios-group=nagios

 make

 make install

# Checking nagios config 


 /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

# Start nagios 

 service nagios start

 chkconfig --add nagios
 
 chkconfig nagios on

iptables -I INPUT -m tcp -p tcp --dport 80 -j ACCEPT

service iptables save

clear

 curl -i localhost


