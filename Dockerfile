FROM ubuntu:18.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2 php7.2-fpm composer 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2-xml php7.2-zip php-redis php-psr-log php-igbinary php-json-schema

RUN mkdir -p /var/www/html
ADD website /var/www/html
RUN chown www-data.www-data /var/www/ -R
RUN mkdir -p /run/php

ADD php-fpm/pool.d/www.conf /etc/php/7.2/fpm/pool.d/www.conf

USER www-data

RUN cd /var/www/html && composer install

EXPOSE 9001/tcp

USER root

ADD scripts/website.sh /opt/website.sh

WORKDIR /opt/
RUN chmod 700 /opt/website.sh

ENTRYPOINT ["./website.sh"]
