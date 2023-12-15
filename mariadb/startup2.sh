#!/bin/sh
if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql

exec /usr/bin/mysqld  --user=mysql --console

