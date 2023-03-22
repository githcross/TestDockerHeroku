#Create image based in following version
FROM php:7.4.33-apache


# Update the package manager
RUN apt-get update

# Install any necessary packages
RUN apt-get install -y git
RUN a2enmod rewrite
RUN apt-get update && apt-get install nano

RUN apt-get update \
    && apt-get install -y libzip-dev \
    && docker-php-ext-install zip

#Install mysqli extensions
RUN docker-php-ext-install mysqli

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Copy the application files into the container
COPY . /var/www/html/

RUN echo "error_reporting = E_ALL & ~E_NOTICE & ~E_WARNING" >> /usr/local/etc/php/conf.d/custom.ini
RUN echo "display_errors = off" >> /usr/local/etc/php/conf.d/custom.ini

# Set the working directory
WORKDIR /var/www/html/

RUN apt-get update && \
    apt-get install -y \
        libmemcached-dev \
        zlib1g-dev \
        && \
    pecl install memcached && \
    docker-php-ext-enable memcached


# expose port 80 to acces at server
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-enabled/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground