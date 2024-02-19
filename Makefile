USER = ykerdel
HOME = /home/${USER}
CERT_PATH = ${HOME}/inception/srcs/requirements/nginx/tools

all: cert
	@bash ./srcs/conf/create_volumes.sh
	@docker-compose -f ./srcs/docker-compose.yml up -d --remove-orphans

cert:
	@mkdir ${CERT_PATH}
	@cd ${CERT_PATH} && mkcert ${USER}.42.fr
	@mv ${CERT_PATH}/${USER}.42.fr-key.pem ${CERT_PATH}/${USER}.42.fr.key
	@mv ${CERT_PATH}/${USER}.42.fr.pem ${CERT_PATH}/${USER}.42.fr.crt

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

check:
	@docker network ls
	@docker volume ls
	@docker images ls
	@docker ps -a

.PHONY	: all build down re clean fclean cert check
