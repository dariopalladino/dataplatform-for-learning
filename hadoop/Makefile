DOCKER_NETWORK = docker-hadoop_default
ENV_FILE = hadoop.env
current_branch = latest
NOCACHE=--no-cache

build:
	docker build -t dariopad/hadoop-base:$(current_branch) ./base --build-arg ARG_HADOOP_VERSION=3.3.1
	docker build -t dariopad/hadoop-namenode:$(current_branch) ./namenode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-datanode:$(current_branch) ./datanode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-resourcemanager:$(current_branch) ./resourcemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-nodemanager:$(current_branch) ./nodemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-historyserver:$(current_branch) ./historyserver --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache	
	docker build -t dariopad/hive:$(current_branch) ./hive --build-arg HIVE_VERSION=3.1.2 --no-cache
	docker build -t dariopad/postgres-metastore:$(current_branch) ./postgres-metastore --build-arg POSTGRES_DATABASE=metastore --build-arg POSTGRES_USER=hive-user --build-arg POSTGRES_PASSWORD=hive-pwd --no-cache
