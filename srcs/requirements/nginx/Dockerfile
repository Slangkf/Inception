# Distribution used for the container.
# Bookworm is the penultimate stable version of the Debian distribution.
FROM	debian:bookworm

# Updates the package list and upgrades those that are installed.
# Installs required packages and then clean the apt cache.
RUN		apt update -y && apt upgrade -y && apt install -y \
		vim \
		curl \
		nginx \
		openssl \
		&& rm -rf /var/lib/apt/lists/*

# Creates a directory to store the TLS/SSL certificate and key.
# Generates a self-signed TLS/SSL certificate and key.
# Stores them in /etc/nginx/ssl.
RUN		mkdir -p /etc/nginx/ssl	&& \
		openssl req -x509 -nodes \
		-keyout /etc/nginx/ssl/server.key \
		-out /etc/nginx/ssl/server.crt \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Inception/CN=tclouet.42.fr"

# Replaces default NGINX configuration with custom nginx.conf.
COPY	./conf/nginx.conf /etc/nginx/nginx.conf

# Exposes HTTPS port.
EXPOSE	443

# Starts the NGINX server in the foreground.
CMD	["nginx", "-g", "daemon off;"]
