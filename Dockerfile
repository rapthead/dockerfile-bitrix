FROM centos:centos6.6
MAINTAINER Pavel Gribanov <rapthead@gmail.com>

# install epel
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# install tools
RUN yum -y install screen vim-enhanced unzip telnet wget git

# install nginx
RUN yum -y install nginx

# install httpd
RUN yum -y install nginx

# install mysql
RUN yum install -y mysql mysql-server
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
RUN service mysqld start

# install php
RUN yum install -y php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml

# install sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd

ADD phpinfo.php /var/www/html/
ADD http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php /var/www/html/

RUN service mysqld stop

EXPOSE 22 80
