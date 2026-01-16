# Distribution used for the container.
# Bookworm is the penultimate stable version of the Debian distribution.
FROM	debian:bookworm

# Updates the package list and upgrades those that are installed.
# Installs PHP 8.2 and necessary extensions for WordPress, then cleans the apt cache.
RUN		apt update -y && apt upgrade -y && apt install -y \
		php8.2 \
		php8.2-fpm \
		php8.2-mysql\
		php8.2-dom \
		php8.2-exif \
		php8.2-igbinary \
		php8.2-imagick \
		php8.2-intl \
		php8.2-mbstring \
		php8.2-xml \
		php8.2-zip \
		curl \
		&& rm -rf /var/lib/apt/lists/*

# Installs the WP-CLI tool to download WordPress and configure it.
RUN		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		&& chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copies the custom initialization scripts into the container's executables directory.
# Makes all sripts in /usr/local/bin executable.
COPY	./tools/ /usr/local/bin/
RUN		chmod +x /usr/local/bin/*

# Exposes PHP-FPM port for NGINX.
EXPOSE 9000

# Runs the custom initialization script at the container start.
# Starts the PHP-FPM server in the foreground.
ENTRYPOINT	["/usr/local/bin/entrypoint.sh"]
