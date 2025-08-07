FROM alpine:3.18

# Install MariaDB server and necessary tools
RUN apk update && apk add --no-cache \
    mariadb mariadb-client mariadb-server-utils \
    bash openrc su-exec gettext nano \
    && rm -rf /var/cache/apk/*

# Create data directory and set permissions
RUN mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Copy initialization script (we will create it later)
COPY ./conf/my.cnf /etc/my.cnf
COPY conf/init.sql /docker-entrypoint-initdb.d/init.sql

# Copy our entrypoint script (we will write it next)
COPY ./tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
