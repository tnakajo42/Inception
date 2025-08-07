#Variables
COMPOSE			=	docker-compose
DOCKER			=	docker
PROJECT_NAME	=	inception
COMPOSE_FILE	=	-f srcs/docker-compose.yml
ENV_FILE		=	--env-file srcs/.env

#Default target: Build and start containers
all: up

#Build and start containers
up:
	$(COMPOSE) $(COMPOSE_FILE) $(ENV_FILE) up --build -d

#Stop containers
down:
	$(COMPOSE) $(COMPOSE_FILE) $(ENV_FILE) down

#Restart cont.
restart:	down up

#Show cont. logs
logs:
	$(COMPOSE) $(COMPOSE_FILE) $(ENV_FILE) logs -f

#List running containers
ps:
	$(COMPOSE) $(COMPOSE_FILE) $(ENV_FILE) ps

#Clean up stopped cont., imgs, and volumes
clean:
	$(COMPOSE) $(COMPOSE_FILE) $(ENV_FILE) down -v --remove-orphans
	$(DOCKER) system prune -af
	sudo rm -r /home/tnakajo/data/wordpress_data/*
	sudo rm -r /home/tnakajo/data/mariadb_data/*

#Completely reset the env
fclean: clean
	@$(DOCKER) volume rm $$(docker volume ls -q) 2>/dev/null || true
	@$(DOCKER) network rm $$(docker network ls -q) 2>/dev/null || true
	@$(DOCKER) rmi -f $$(docker images -q) 2>/dev/null || true

#Rebuild everything from scratch
re:		fclean all