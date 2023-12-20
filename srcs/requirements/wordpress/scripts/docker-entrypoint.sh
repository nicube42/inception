#!/bin/sh

sed -i "s/username_here/$DB_USER/g" wp-config-sample.php
sed -i "s/password_here/$DB_PASSWORD/g" wp-config-sample.php
sed -i "s/localhost/$DB_HOST/g" wp-config-sample.php
sed -i "s/database_name_here/$DB_NAME/g" wp-config-sample.php
cp wp-config-sample.php wp-config.php

sleep 1

if ! wp core is-installed --path=/var/www/html --quiet; then
    echo "Installing WordPress..."
    wp core install \
        --url="Inception" \
        --title="Inception" \
        --admin_user="user0" \
        --admin_password="user0" \
        --admin_email="user0@example.com" \
        --path=/var/www/html \
        --skip-email
fi

exec php-fpm81 -F
