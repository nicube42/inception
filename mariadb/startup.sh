#!/bin/sh

# Ensure proper permissions
chown -R mysql:mysql /var/lib/mysql
chmod 755 /var/lib/mysql

# Initialize the database directory
mysql_install_db --user=wordpress --basedir=/usr --datadir=/var/lib/mysql

# Start the MySQL service
/etc/init.d/mysql start

# Check if the database exists
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then 
    echo "Database already exists"
else
    # Set up MySQL root user without a password for local access
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY ''; FLUSH PRIVILEGES;"

    # Set root password and apply security settings
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_ROOT_PASSWORD'); DELETE FROM mysql.user WHERE User=''; DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'); DROP DATABASE IF EXISTS test; DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'; FLUSH PRIVILEGES;"

    # Add a root user on '%' to allow remote connection
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

    # Create database and user for WordPress
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;"

    # Uncomment the following line if you have an SQL file to import
    # mysql -u root -p"$MYSQL_ROOT_PASSWORD" $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
fi

# Stop the MySQL service
/etc/init.d/mysql stop

# Execute the CMD from the Dockerfile
exec "$@"
