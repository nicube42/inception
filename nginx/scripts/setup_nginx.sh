#!bin/sh

mkdir -p /etc/nginx/ssl

#mv ./config/nginx.conf /etc/nginx/nginx.conf.default
#cp ./config/nginx.conf /etc/nginx/nginx.conf

nginx -g 'daemon off;'
