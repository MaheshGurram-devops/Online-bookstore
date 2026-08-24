#!/bin/sh
set -eu

MYSQL_DATA=/var/lib/mysql
INIT_MARKER="$MYSQL_DATA/.onlinebookstore_initialized"

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

if [ ! -f "$INIT_MARKER" ]; then
    mysql --protocol=socket < /init.sql
    touch "$INIT_MARKER"
fi

exec /usr/share/tomcat9/bin/catalina.sh run