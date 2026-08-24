#!/bin/sh
set -eu

MYSQL_DATA=/var/lib/mysql
INIT_MARKER="$MYSQL_DATA/.onlinebookstore_initialized"
PASSWORD_MARKER="$MYSQL_DATA/.onlinebookstore_root_password_set"
MYSQL_PASSWORD=mysql

if [ ! -d "$MYSQL_DATA/mysql" ]; then
    mysqld --initialize-insecure --user=mysql --datadir="$MYSQL_DATA"
fi

mysqld_safe --datadir="$MYSQL_DATA" --skip-syslog &

MYSQL_READY=0
for attempt in $(seq 1 30); do
    if mysqladmin --protocol=socket ping --silent; then
        MYSQL_READY=1
        break
    fi
    sleep 1
done

if [ "$MYSQL_READY" -ne 1 ]; then
    echo "MySQL did not become ready in time" >&2
    exit 1
fi

if [ ! -f "$PASSWORD_MARKER" ]; then
    mysql --protocol=socket -uroot --skip-password \
        -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    touch "$PASSWORD_MARKER"
fi

if [ ! -f "$INIT_MARKER" ]; then
    mysql --protocol=socket -uroot -p"$MYSQL_PASSWORD" < /init.sql
    touch "$INIT_MARKER"
fi

exec /usr/share/tomcat10/bin/catalina.sh run