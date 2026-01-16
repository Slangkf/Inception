# Distribution used for the container.
# Bookworm is the penultimate stable version of the Debian distribution.
FROM	debian:bookworm

# Updates the package list and upgrades those that are installed.
# Installs the MariaDB server package.
# Cleans the apt cache to reduce image size.
# Removes the MariaDB data directory created during package installation.
RUN		apt update -y && apt upgrade -y && apt install -y \
		mariadb-server \
		&& rm -rf /var/lib/apt/lists/*

# Creates /run/mysqld for MariaDB socket and lock files.
# Ensures it is owned by the MariaDb server user (mysql).
RUN		mkdir -p /run/mysqld \
		&& chown -R mysql:mysql /run/mysqld \
		&& rm -rf /var/lib/mysql

# Replaces default MariaDB server configuration with a custom file.
COPY	./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copies the script into the container.
# Makes it executable so it can be run at container startup.
COPY	./tools/ /usr/local/bin/
RUN		chmod +x /usr/local/bin/*

# Exposes the MariaDB port for WP connection.
EXPOSE 3306

# Runs the script, which initializes the database if needed.
# Starts the MariaDB server in the foreground.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
