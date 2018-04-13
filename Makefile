.PHONY: help run data_load test clear

DOCKER_NAME = mysql_with_data
ENV_FILE = $(PWD)/.env

ifneq ("$(wildcard $(ENV_FILE))", "")
	include $(ENV_FILE)
	export $(shell sed 's/=.*//' $(ENV_FILE))
endif

help: ## shows all available targets
	@echo ""
	@echo "MySQL with employees sample data"
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/\(.*\)\:.*##/\1:/'
	@echo ""

run: ## runs mysql server (if you want data run `make build` first
	docker-compose up -d
	sleep 2
	echo "Msql up and running"

data_load: ## starts mysql, loads data and stops mysql
	docker-compose up -d
	sleep 10
	mysql -h 127.0.0.1 -uroot -ppaweltest -e "CREATE USER 'test'@'%' IDENTIFIED BY 'pass';"
	mysql -h 127.0.0.1 -uroot -ppaweltest -e "GRANT all privileges ON *.* TO 'test'@'%' with grant option;"
	cd init_data; mysql -h 127.0.0.1 -utest -ppass < employees_partitioned.sql
	echo "Data loaded"
	docker-compose down

test: ## run tests
	init_data/sql_test.sh 'mysql -h 127.0.0.1 -utest -ppass'

clear: ## stops mysql and clears data
	docker-compose down
	sudo rm -rf data/*

define dockerexec # custom function to execute commands inside the 'app' container
	@echo "executing '$1' inside container ..."
	@docker-compose run app /bin/sh -c "$1"
endef
