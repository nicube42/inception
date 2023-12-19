#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
    mysql --user=mysql &
    pid="$!"

    for i in {30..0}; do
        if echo 'SELECT 1' | mysql &> /dev/null; then
            break
        fi
        echo 'MariaDB init process in progress...'
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo >&2 'MariaDB init process failed.'
        exit 1
    fi

    if [ -d /docker-entrypoint-initdb.d/ ]; then
        if [ -f /docker-entrypoint-initdb.d/setup.sh ]; then
            sh /docker-entrypoint-initdb.d/setup.sh
        fi

        for script in /docker-entrypoint-initdb.d/*.sql; do
            mysql < "$script"
        done
    fi

    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 'MariaDB shutdown process failed.'
        exit 1
    fi
fi
exec mysqld_safe --user=mysql
