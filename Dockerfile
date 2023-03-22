FROM php:7.4-apache

# Copy the application files into the container
COPY . /var/www/html/

RUN chmod -R 777 /var/www/html/

RUN apt-get update && apt-get upgrate -y

RUN docker-php-ext-install pdo_mysql

# Expose port 80
EXPOSE 80

CMD sed -i "s/80/$PORT/g" /etc/apache/sites-enabled/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground
RUN sed -i '/<Directory \/var/www/>/,/<Directory>/ s/AllowOverride NODE/AllowOverride All/' /etc/apache2/apache2.conf