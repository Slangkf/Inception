#!/bin/bash

set -eou pipefail


# If it is the first-time initialization, downloads WordPress.
# Creates wp-config.php with database credentials
# Installs WordPress site with admin account
# Creates additional user
# Ensures PHP-FPM can access files.
echo "Check if WordPress is installed..."
if [ ! -d /var/www/html/wordpress ]; then

	echo "WordPress is not installed. Let's try installing it."

	MYSQL_USER=$(cat /run/secrets/MYSQL_USER)
	MYSQL_USER_PWD=$(cat /run/secrets/MYSQL_USER_PWD)
	WP_ADMIN_USER=$(cat /run/secrets/WP_ADMIN_USER)
	WP_ADMIN_PWD=$(cat /run/secrets/WP_ADMIN_PWD)
	WP_ADMIN_MAIL=$(cat /run/secrets/WP_ADMIN_MAIL)
	WP_USER=$(cat /run/secrets/WP_USER)
	WP_USER_PWD=$(cat /run/secrets/WP_USER_PWD)
	WP_USER_ROLE=$(cat /run/secrets/WP_USER_ROLE)
	WP_USER_MAIL=$(cat /run/secrets/WP_USER_MAIL)
	
	mkdir -p /var/www/html/wordpress && cd /var/www/html/wordpress

	wp --allow-root core download

	wp --allow-root config create --dbname="${MYSQL_DATABASE}" \
	--dbuser="${MYSQL_USER}" --dbpass="${MYSQL_USER_PWD}" \
	--dbhost="${MYSQL_HOST}" --dbprefix="${MYSQL_PREFIX}"

	wp --allow-root core install --url="${DOMAIN_NAME}" --title="${WP_WEBSITE}" \
		--admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PWD}" \
		--admin_email="${WP_ADMIN_MAIL}"

	wp --allow-root user create "${WP_USER}" "${WP_USER_MAIL}" \
		--user_pass="${WP_USER_PWD}" --role="${WP_USER_ROLE}"

	chown -R www-data:www-data /var/www/html/wordpress
	echo "WordPress installation completed ✅"
fi

# Replaces socket with TCP port 9000 for NGINX to connect.
if grep -q "/run/php/php8.2-fpm.sock" "/etc/php/8.2/fpm/pool.d/www.conf"; then
	sed -i 's|/run/php/php8\.2-fpm\.sock|0.0.0.0:9000|g' "/etc/php/8.2/fpm/pool.d/www.conf"
fi

# Starts the PHP-FPM server.
# -F forces to stay in the foreground.
# -R allows the master process to run as root while workers drop privileges to www-data (www.conf).
echo "WordPress is installed. Starting the server in foreground ✅"
exec php-fpm8.2 -F -R
