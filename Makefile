COMMAND := mariadb --host localhost --port 3306 --user root -ppassword
DOCKER_CONFIG := /opt/docker/configs/phpmyadmin

run:
	sudo docker-compose up -d
restart:
	sudo docker-compose restart
cli:
	${COMMAND} ${DB}

init_all: init_docker init_db

init_docker: init_docker_config run

init_db: create_dbs init_smalldb init_smalldbnolinks

reset: drop_dbs init

create_dbs:
	${COMMAND} < base/createdbs.sql

init_smalldb:
	${COMMAND} smalldb < base/smalldb.sql

init_smalldbnolinks:
	${COMMAND} smalldbnolinks < base/smalldbnolinks.sql

drop_dbs:
	${COMMAND} < base/dropall.sql

init_docker_config:
	sudo mkdir -p ${DOCKER_CONFIG}
	sudo chown ${USER} ${DOCKER_CONFIG}
	ln -s ${PWD}/themes ${DOCKER_CONFIG}/themes
	ln -s ${PWD}/config/phpMyAdminConfig.php ${DOCKER_CONFIG}/config.user.inc.php

reset_docker:
	sudo docker-compose stop
	yes | sudo docker-compose rm
	sudo docker-compose up -d
