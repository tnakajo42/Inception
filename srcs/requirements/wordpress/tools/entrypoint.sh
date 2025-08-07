#!/bin/sh
set -e

cd /var/www/wordpress

# Download WordPress if it's not installed
if [ ! -f wp-config-sample.php ]; then
    echo "[INFO] Downloading WordPress..."
    PHP_MEMORY_LIMIT=256M wp core download --allow-root
fi

# Create wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "[INFO] Creating wp-config.php..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi

# Ensure correct permissions
chown -R nobody:nobody /var/www/wordpress

# Configure PHP-FPM to listen on 0.0.0.0:9000
sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php81/php-fpm.d/www.conf

# Wait for MariaDB to be ready
echo "[INFO] Waiting for MariaDB to accept TCP connections..."
until nc -z -v -w5 mariadb 3306; do
  echo "[INFO] Waiting for MariaDB..."
  sleep 2
done


# Install WordPress core if not installed
if ! wp core is-installed --allow-root; then
    echo "[INFO] Installing WordPress..."
    wp core install \
        --url="${WP_SITE_URL}" \
        --title="${WP_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root
fi

# Force update the WordPress URLs every time
wp option update siteurl "${WP_SITE_URL}" --allow-root
wp option update home "${WP_SITE_URL}" --allow-root

# Create an additional WordPress user if not exists
if ! wp user get "$WP_EDITOR_USER" --allow-root > /dev/null 2>&1; then
    echo "[INFO] Creating additional WordPress user '$WP_EDITOR_USER'..."
    wp user create "$WP_EDITOR_USER" "$WP_EDITOR_EMAIL" \
        --role=editor \
        --user_pass="$WP_EDITOR_PASS" \
        --allow-root
fi

echo "[INFO] Starting PHP-FPM..."
exec php-fpm81 --nodaemonize
