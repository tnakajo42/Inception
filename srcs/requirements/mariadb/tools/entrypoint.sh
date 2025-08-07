#!/bin/sh
set -e

# Initialize MariaDB if not initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "[INFO] Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "[INFO] Starting MariaDB in background..."
    mysqld --user=mysql --skip-networking &
    pid="$!"

    echo "[INFO] Waiting for MariaDB to be ready..."
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "[INFO] Preparing initialization SQL with env variables..."
    envsubst < /docker-entrypoint-initdb.d/init.sql > /tmp/init.sql

    echo "[INFO] Running initialization SQL..."
    mysql --protocol=socket < /tmp/init.sql

    echo "[INFO] Shutting down temporary MariaDB..."
    mysqladmin shutdown

    echo "[INFO] MariaDB initialized."
fi

echo "[INFO] Starting MariaDB server..."
exec mysqld --user=mysql --console
