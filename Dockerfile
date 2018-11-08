FROM php:5.6-apache
RUN apt-get update && apt-get install -y git \
        && apt-get install -y libpng-dev \
        && apt-get install -y libc-client-dev libkrb5-dev 

WORKDIR /var/www/html

RUN git clone https://github.com/osTicket/osTicket.git . && \
        mv /var/www/html/include/ost-sampleconfig.php /var/www/html/include/ost-config.php && \
        php manage.php deploy --setup /var/www/htdocs/osticket/ && \
        php manage.php deploy -v /var/www/htdocs/osticket/

RUN chmod -R g+s /var/www/html \
        && chmod 0666 include/ost-config.php

# install php extensions for gd, gettext and imap

RUN docker-php-ext-install -j$(nproc) gd \
        && docker-php-ext-install -j$(nproc) gettext \
        && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
        && docker-php-ext-install -j$(nproc) imap \
        && docker-php-ext-install -j$(nproc) mysqli \
        && docker-php-ext-enable mysqli

