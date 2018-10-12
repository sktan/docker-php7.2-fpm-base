#! /bin/sh

cd /var/www/html/

# Run scripts required to prior to starting the website
# e.g. building cache or database changes if needed.

php-fpm7.2 -F -R
