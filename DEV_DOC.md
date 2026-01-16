*This project has been created as part of the 42 curriculum by tclouet.*

# Developer documentation

*This document describes how a developer can install, run, and maintain the project from scratch.*

### **1. Set up the environment from scratch (prerequisites, configuration files, secrets):**

#### Prerequisites:

- Docker Engine (latest stable version)
- Docker Compose (plugin for Docker)
- Make
- `sudo` access

Verify installation in your terminal:

	docker --version
	docker compose version
	make --version


#### Configuration file:

Edit the `env_example` file in `srcs/` with your own values:

- DOMAIN_NAME=YOURDOMAIN.42.FR
- MYSQL_DATABASE=DATABASE_NAME
- MYSQL_HOST=(always mariadb)
- MYSQL_PREFIX=DATABASE_TABLE_PREFIX
- MYSQL_VOLUME_PATH=/home/YOURUSERNAME/data/mariadb_volume
- WP_WEBSITE=WEBSITE_NAME
- WP_VOLUME_PATH=/home/YOURUSERNAME/data/wordpress_volume

#### Note:
	Once the variables are configured, rename `env_example` to `.env`.

#### Secret files:

Fill in the `.txt` files in the `secrets/` directory with your own values:

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

#### `/etc/hosts` file:

Add the following lines to your machine’s `/etc/hosts` file to allow your browser to reach the site:

		127.0.0.1	DOMAIN_NAME.42.fr
		127.0.0.1	www.DOMAIN_NAME.42.fr

#### Note:  
	All environment variables and secret files are required for the initial setup of the services. Make sure they are correctly configured before running 'make build', otherwise the setup may fail.


### **2. Build and launch the project using the Makefile and Docker Compose:**

#### Build the project:

From the project root directory, run:

	make build

This command builds all Docker images for each service (NGINX, PHP-FPM/WordPress, MariaDB).

You can also build a specific service by specifying the variable c:

	make build c=nginx

#### Launch all services:

After building, start the entire infrastructure:

	make up

This command runs all containers in the background.

Each container is connected to the same Docker network, allowing communication between services.

#### Check that the services are running:

	make ps

Lists all running containers and their status.

Example output:

![](./utils/make_ps.png)

### **3. Use relevant commands to manage the containers and volumes:**

#### Stop running containers:

	make stop

Stops all running containers, but does not remove them.

Useful when you want to temporarily pause the services without losing data.

#### Stop and remove containers and the network:

	make down

Stops containers and removes them along with the Docker network.

Volumes remain intact, so persistent data is not deleted.

#### Remove all containers, networks, and volumes:
	
	make destroy

Completely removes the infrastructure, including containers, networks, and all persistent data volumes.

**Warning**: This operation is destructive. You will be prompted to enter your sudo password to confirm.

#### See all available Makefile commands:

	make help

This command lists all available Makefile commands along with a description of their purpose.

Example of commands:

- `make build` [c=service]  - Build the specified container or all if none specified

- `make up`    [c=service]  - Start the specified container or all if none specified

- `make stop` [c=service]   - Stop the specified container or all if none specified

- `make down` [c=service]   - Stop and remove the specified container or all if none specified

- `make destroy`            - Remove all containers, networks, and persistent volumes

- `make logs` [c=service]   - Show logs for the specified container or all if none specified

- `make ps`                 - List all running containers

#### Note:
	If a specific operation is not available via the Makefile, you can execute Docker Compose commands directly in the srcs/ directory.

### **4. Identify where the project data is stored and how it persists:**

All persistent data are stored in Docker volumes accessible from the host system directories. This ensures that data survives container restarts or rebuilds.

#### Locations of persistent data:

##### MariaDB database:

Volume path defined by the environment variable 		MYSQL_VOLUME_PATH in the .env file:

	example: /home/YOURUSERNAME/data/mariadb_volume

##### WordPress files:

Volume path defined by the environment variable WP_VOLUME_PATH in the .env file:

	example: /home/YOURUSERNAME/data/wordpress_volume

#### How persistence works:

Docker volumes are managed independently of containers, so stopping (`make stop`) or removing containers (`make down`) does not delete your data.

Only `make destroy` will delete the volumes and all persistent data, so use it carefully.

#### Accessing or backing up data:

You can access the host directories directly to inspect or back up the data:

	example: ls -l /home/YOURUSERNAME/data/mariadb_volume
	
To back up your data, simply copy these directories to a safe location.

#### Note:
	Ensure that your .env paths match the directories you want to persist, to avoid accidental data loss. 


