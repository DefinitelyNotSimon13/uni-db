COMMAND := mariadb --host localhost --port 3306 --user root -ppassword
run:
	sudo docker-compose up -d
cli:
	${COMMAND} ${DB}

init: create_dbs init_smalldb init_smalldbnolinks

reset: drop_dbs init

create_dbs:
	${COMMAND} < base/createdbs.sql

init_smalldb:
	${COMMAND} smalldb < base/smalldb.sql

init_smalldbnolinks:
	${COMMAND} smalldbnolinks < base/smalldbnolinks.sql

drop_dbs:
	${COMMAND} < base/dropall.sql
