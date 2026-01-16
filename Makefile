MYSQL_VOLUME_PATH := $(shell grep MYSQL_VOLUME_PATH ./srcs/.env | cut -d '=' -f2)
WP_VOLUME_PATH := $(shell grep WP_VOLUME_PATH ./srcs/.env | cut -d '=' -f2)

.PHONY: help prepare build up stop ps logs down destroy

help:
	@echo "Makefile commands:"
	@echo "  make build [c=service]  - Build the specified container or all if none specified"
	@echo "  make up [c=service]     - Start the specified container or all if none specified"
	@echo "  make stop [c=service]   - Stop the specified container or all if none specified"
	@echo "  make down [c=service]   - Stop and remove the specified container or all if none specified"
	@echo "  make destroy            - Stop and remove all images, containers, networks, and volumes"
	@echo "  make logs [c=service]   - Show logs for the specified container or all if none specified"
	@echo "  make ps                 - List all running containers"

prepare:
	@mkdir -p $(MYSQL_VOLUME_PATH)
	@mkdir -p $(WP_VOLUME_PATH)

build: prepare
	@docker compose -f ./srcs/docker-compose.yml build $(c)

up:
	@docker compose -f ./srcs/docker-compose.yml up -d $(c)

stop:
	@docker compose -f ./srcs/docker-compose.yml stop $(c)

ps:
	@docker compose -f ./srcs/docker-compose.yml ps

logs:
	@docker compose -f ./srcs/docker-compose.yml logs --tail=100 $(c)

down: 
	@docker compose -f ./srcs/docker-compose.yml down $(c)

destroy:
	@echo "\033[1;31mWarning\033[0m: persistent data will be deleted. Do you want to continue?"
	@read -p "Type 'YES' to confirm: " confirm; \
	if [ "$$confirm" != "YES" ] && [ "$$confirm" != "yes" ]; then \
		echo "Aborting destroy."; \
		exit 1; \
	fi
	@sudo -k
	@sudo rm -rf $(MYSQL_VOLUME_PATH) $(WP_VOLUME_PATH)
	@docker compose -f ./srcs/docker-compose.yml down -v
	@docker rmi -f nginx:custom mariadb:custom wordpress:custom
