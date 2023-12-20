#!/bin/sh

# Initialize MariaDB if not already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB Data Directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    echo "Starting MariaDB..."
    mysqld_safe --user=mysql --skip-networking --socket=/var/run/mysqld/mysqld.sock &
    pid=$!

    # Simple wait loop to ensure MariaDB is ready
    echo "Waiting for MariaDB to be ready..."
    i=0
    while [ $i -lt 30 ]; do
        if mysqladmin ping --socket=/var/run/mysqld/mysqld.sock --silent; then
            echo "MariaDB is ready."
            break
        fi
        i=$((i+1))
        sleep 1
    done

    if [ $i -eq 30 ]; then
        echo >&2 'MariaDB init process failed.'
        exit 1
    fi

    # Execute scripts
    echo "Running initialization scripts..."
    if [ -d /docker-entrypoint-initdb.d/ ]; then
        for script in /docker-entrypoint-initdb.d/*; do
            case "$script" in
                *.sh) echo "Running $script"; sh "$script" ;;
                *.sql) echo "Running $script"; mysql --socket=/var/run/mysqld/mysqld.sock < "$script" ;;
                *) echo "Ignoring $script" ;;
            esac
        done
    fi
    mysql --socket=/var/run/mysqld/mysqld.sock < /docker-entrypoint-initdb.d/setup.sql

    # Shut down the temporary instance
    echo "Shutting down MariaDB..."
    mysqladmin --socket=/var/run/mysqld/mysqld.sock -u root shutdown
else
    echo "MariaDB Data Directory already initialized."
fi

# Start MariaDB normally
echo "Starting MariaDB server..."
exec mysqld_safe --user=mysql
