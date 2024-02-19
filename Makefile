USER = ykerdel
HOME = /home/${USER}

all: cert
	@bash ./srcs/conf/create_volumes.sh
	@docker-compose -f ./srcs/docker-compose.yml up -d --remove-orphans

cert:
	@mkdir ${HOME}/inception/srcs/requirements/nginx/tools
	@cd ${HOME}/inception/srcs/requirements/nginx/tools
	@mkcert ${USER}.42.fr
	@mv ${USER}.42.fr-key.pem ${USER}.42.fr.key
	@mv ${USER}.42.fr.pem ${USER}.42.fr.crt
	@cd ${HOME}/inception

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
