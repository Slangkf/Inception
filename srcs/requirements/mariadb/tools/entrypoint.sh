#!/bin/bash

set -eou pipefail

# Start the MariaDB server in the background and enable the 
# --skip-networking option to prevent remote connections.
start_server_in_background() {
    mysqld --skip-networking --user=mysql &
    while ! mysqladmin ping --silent &> /dev/null; do
        echo "Waiting for MySQL server... ⏳"
        sleep 2
    done
    echo "MySQL server is ready ✅"
}

# For the first-time initialization, run the mariadb-install-db script
# to initialize the data directory and create the system tables in the MySQL database. 
# Then, start the server in the background to configure users and the database.
# Once the configuration is done, shut down the server...
if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "Initializing MariaDB data directory...⏳"

    MYSQL_ROOT_PWD=$(cat /run/secrets/MYSQL_ROOT_PWD)
	MYSQL_USER=$(cat /run/secrets/MYSQL_USER)
	MYSQL_USER_PWD=$(cat /run/secrets/MYSQL_USER_PWD)

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    start_server_in_background

    echo "Creating users and the database ...⏳"
    mysql -u root <<EOF
DELETE FROM mysql.user WHERE User='';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PWD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PWD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    echo "Users and the database are created ✅"

    echo "Shutting down MariaDB server...⏳"
    mysqladmin -u root -p${MYSQL_ROOT_PWD} shutdown
fi

# ...and start it again in the foreground after dropping root privileges.
echo "Starting MariaDB server in foreground ✅"
exec mysqld --user=mysql
