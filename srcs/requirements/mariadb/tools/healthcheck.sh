#!/bin/bash

set -eou pipefail

MYSQL_USER=$(cat /run/secrets/MYSQL_USER)
MYSQL_USER_PWD=$(cat /run/secrets/MYSQL_USER_PWD)

echo "Checking if MariaDB is installed... ⏳"
if mysqladmin ping -h localhost -u "${MYSQL_USER}" -p"${MYSQL_USER_PWD}" 2>/dev/null; then
    echo "MariaDB is healthy ✅"
else
    echo "Hey, something went wrong with the MariaDB installation. Check your logs."
fi
