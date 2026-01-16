*This project has been created as part of the 42 curriculum by tclouet.*

# Description

*This section presents the project, its goals and a brief overview :*

	The Inception project aims to deploy a small web infrastructure using Docker technology.

	It consists of setting up a LEMP stack (Linux, NGINX, MariaDB, and PHP-FPM/WordPress) where each service runs in its own container, built from custom Docker images and orchestrated by Docker Compose.

	Here is an example diagram of the expected result:

![](./utils/diagram.png)

# Instructions

*This section contains information about compilation, installation, and/or execution :*

*Before starting, please ensure that Docker Engine is installed.*

1. ### **Go to the `secrets` directory and fill these files with your own values:**
	
	- `db_root_password.txt` : your MariaDB root password.
	- `db_user_password.txt` : your MariaDB user password.
	- `db_user.txt` : your MariaDB username.
	- `wp_admin_mail.txt` : your WordPress administrator mail.
	- `wp_admin_password.txt` : your WordPress administrator password.
	- `wp_admin_user.txt` : your WordPress administrator username.
	- `wp_user_mail.txt` : your WordPress user mail.
	- `wp_user_password.txt` : your WordPress user password.
	- `wp_user_role.txt` : your WordPress user role ('editor' or 'author').
	- `wp_user.txt` : your WordPress username.


2. ### **Configure the `env_example` file in the `srcs` directory with your own values:**

	- DOMAIN_NAME=YOURDOMAIN.42.FR
	- MYSQL_DATABASE=DATABASE_NAME
	- MYSQL_HOST=(always mariadb:3306)
	- MYSQL_PREFIX=DATABASE_TABLE_PREFIX
	- MYSQL_VOLUME_PATH=/home/YOURUSERNAME/data/mariadb_volume
	- WP_WEBSITE=WEBSITE_NAME
	- WP_VOLUME_PATH=/home/YOURUSERNAME/data/wordpress_volume

#### Note:
	Rename the `env_example` file to `.env` after modifying it.

3. ### **Allow your browser to access the site:**

	Add the following lines to your machine’s `/etc/hosts` file to allow your browser to reach the site:

		127.0.0.1	DOMAIN_NAME.42.fr
		127.0.0.1	www.DOMAIN_NAME.42.fr

4. ### **Build the services and running them:**

	Run `make build` to construct all your services.

	Run `make up` to run the entire infrastructure.

5. ### **Once the services are running, you can access the website via:**

		https://DOMAIN_NAME.42.fr  


#### Note:
	The site uses a self-signed SSL certificate, so your browser may warn about the certificate.

# Ressources

*This section lists references related to the topic, as well as a description of how AI has been used :*

- [Learn about Docker technology.](https://docs.docker.com/manuals/)
- [Debian bookworm and its dependencies.](https://packages.debian.org/bookworm/)
- [NGINX documentation](https://nginx.org/en/docs/) [and configuration.](https://www.nicelydev.com/nginx/nginx)
- [WordPress documentation.](https://developer.wordpress.org/advanced-administration/)
- [PHP-FPM documentation.](https://www.php.net/manual/fr/install.fpm.php)
- [MariaDB documentation](https://mariadb.com/docs/server/) [and configuration.](https://dev.mysql.com/doc/refman/8.4/en/data-directory-initialization.html#data-directory-initialization-procedure)
- [Introduction to bash scripting.](https://www.datacamp.com/fr/tutorial/how-to-write-bash-script-tutorial)
- [Introduction to Markdown.](https://www.youtube.com/watch?v=aFx7f9K-tvM)
- [Docker Hub.](https://hub.docker.com/)

#### **Use of AI :**  
As a novice in system administration, AI helped me throughout the project to understand the functions and purposes of new concepts and technologies.

# Project description

*This section  explains the use of Docker and the sources
included in the project as well as the main design choices :*

	Docker is used to isolate services, simplify deployment, and reduce resource consumption compared to virtual machines. 
	
	Docker Compose allows easy orchestration, starting all services in the correct order, and connecting them through an isolated Docker network.


	The project includes the following sources and configuration files:

	- Dockerfiles for each service (Nginx, WordPress/PHP-FPM, MariaDB).

	- docker-compose.yml for orchestration.

	- Configuration files such as 50-server.cnf, nginx.conf and .env.

	- Scripts required for setup.


	The main design choices are:

	- Containerizing each service individually for modularity and portability.

	- Using NGINX as the single entry point to handle HTTPS traffic and reverse proxying to PHP-FPM.

	- Using Docker networks to isolate container communication and enhance security.

	- Using Docker volumes for persistent data storage and easier backup.


	This architecture allows the infrastructure to be portable, reproducible, and secure while demonstrating a clear separation of concerns between services.
  
### **Virtual Machines vs Docker :**  
	
  	While Virtual Machines use a complete guest operating system (kernel and distribution), Docker containers provide a userland based on a Linux distribution and leverage the host kernel. As a result, containers are lighter and faster to deploy than VMs.  
    
  	In Inception, Docker is used to containerize each service in order to reduce resource consumption and facilitate orchestration with Docker Compose.  
  
  
### **Secrets vs Environment Variables :**  
  
  	While secrets are securely managed by Docker and exposed only to authorized containers, environment variables are accessible to any process running within the container, making them unsuitable for sensitive data.  

  	In Inception, sensitive data, such as passwords, are stored in secrets and non-sensitive data in environment variables.  

### **Docker Network vs Host Network :**  

	Docker networks provide isolated communication between containers, whereas relying on the host network removes this isolation and increases the infrastructure’s exposure.  

	In Inception, Docker networks are used to ensure a closed and secure network between containers.

### **Docker Volumes vs Bind Mounts :**  

	Volumes are managed by Docker, while bind mounts directly map host directories into containers.  

	In Inception, volumes are used for persistent data because they offer better isolation, portability, and are easier to back up and restore.

