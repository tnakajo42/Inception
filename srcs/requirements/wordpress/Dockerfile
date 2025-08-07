FROM alpine:3.18

# Install PHP and required extensions
RUN apk update && apk add --no-cache \
    php81 php81-fpm php81-mysqli php81-mbstring \
    php81-session php81-opcache php81-curl \
    php81-dom php81-exif php81-fileinfo php81-json \
    php81-phar php81-tokenizer php81-xml \
    curl wget tar bash less openrc

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create working directory
RUN mkdir -p /var/www/wordpress

# Copy custom entrypoint
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Increase PHP memory limit to 256M
RUN echo "memory_limit = 256M" > /etc/php81/php.ini
RUN apk add --no-cache netcat-openbsd

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/entrypoint.sh"]
