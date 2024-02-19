USER = ykerdel

all:  
	@bash ./srcs/conf/create_volumes.sh
	@docker-compose -f ./srcs/docker-compose.yml up -d --remove-orphans

build:
	@docker-compose -f ./srcs/docker-compose.yml up -d --build --remove-orphans

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re:	down
	@docker-compose -f ./srcs/docker-compose.yml up -d --build --remove-orephans

clean: down
	@docker system prune -a

fclean: down
	@printf "\033[33m\u26d4 volume removal \u26d4\033[31m\n"
	# @docker-compose down
	@docker volume remove srcs_wp-volume srcs_db-volume
	@printf "\033[0m\n"

.PHONY	: all build down re clean fclean
