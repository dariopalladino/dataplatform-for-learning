DOCKER_NETWORK = iot_net
ENV_FILE = ./hadoop/hadoop.env
docker_user = dariopad
hadoop_branch = 3.3.1-snapshot-1
spark_branch = 3.2.0-snapshot-1
jupyterpwd=whatever

build:
	docker build -t $(docker_user)/hadoop-base:$(hadoop_branch) ./hadoop/base --build-arg ARG_HADOOP_VERSION=3.3.1
	docker build -t $(docker_user)/hadoop-namenode:$(hadoop_branch) ./hadoop/namenode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-datanode:$(hadoop_branch) ./hadoop/datanode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-resourcemanager:$(hadoop_branch) ./hadoop/resourcemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-nodemanager:$(hadoop_branch) ./hadoop/nodemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-historyserver:$(hadoop_branch) ./hadoop/historyserver --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache	
	docker build -t $(docker_user)/hive:$(hadoop_branch) ./hadoop/hive --build-arg HIVE_VERSION=3.1.2 --no-cache
	docker build -t $(docker_user)/spark:$(spark_branch) ./spark --no-cache
	docker build -t $(docker_user)/jupyter-spark:$(spark_branch) ./jupyter --no-cache --build-arg CFG_USER=jupyter --build-arg CFG_PASSWORD=$(jupyterpwd)
	docker build -t $(docker_user)/airflow-spark:$(spark_branch) ./airflow-build --no-cache

build-hadoop:
	docker build -t $(docker_user)/hadoop-base:$(hadoop_branch) ./hadoop/base --build-arg ARG_HADOOP_VERSION=3.3.1
	docker build -t $(docker_user)/hadoop-namenode:$(hadoop_branch) ./hadoop/namenode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-datanode:$(hadoop_branch) ./hadoop/datanode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-resourcemanager:$(hadoop_branch) ./hadoop/resourcemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-nodemanager:$(hadoop_branch) ./hadoop/nodemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t $(docker_user)/hadoop-historyserver:$(hadoop_branch) ./hadoop/historyserver --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache	
	docker build -t $(docker_user)/hive:$(hadoop_branch) ./hadoop/hive --build-arg HIVE_VERSION=3.1.2 --no-cache

build-spark:
	docker build -t $(docker_user)/spark:$(spark_branch) ./spark --no-cache

build-jupyter:
	docker build -t $(docker_user)/jupyter-spark:$(spark_branch) ./jupyter --no-cache --build-arg CFG_USER=jupyter --build-arg CFG_PASSWORD=$(jupyterpwd)

buid-airflow:
	docker build -t $(docker_user)/airflow-spark:$(spark_branch) ./airflow-build --no-cache

push:
	docker push $(docker_user)/hadoop-base:$(hadoop_branch)
	docker push $(docker_user)/hadoop-namenode:$(hadoop_branch)
	docker push $(docker_user)/hadoop-datanode:$(hadoop_branch)
	docker push $(docker_user)/hadoop-resourcemanager:$(hadoop_branch)
	docker push $(docker_user)/hadoop-nodemanager:$(hadoop_branch)
	docker push $(docker_user)/hadoop-historyserver:$(hadoop_branch)
	docker push $(docker_user)/hive:$(hadoop_branch)
	docker push $(docker_user)/postgres-metastore:$(hadoop_branch)
	docker push $(docker_user)/spark:$(spark_branch)
	docker push $(docker_user)/jupyter-spark:$(spark_branch)

push-airflow:
	docker push $(docker_user)/airflow-spark:$(spark_branch)

create-net:
	docker network create $(DOCKER_NETWORK)

remove-volumes:
	docker volume rm zk_1_data zk_2_data zk_3_data kafka1_data kafka2_data kafka3_data spark_m_data spark_w_data postgresql_data redis_fs_data airflow_data airflow_w_data airflow_sk_data elasticsearch_data kibana_data logstash_data logstash_data2

create-volumes:
	docker volume create zk_1_data
	docker volume create zk_2_data
	docker volume create zk_3_data 
	docker volume create kafka1_data
	docker volume create kafka2_data
	docker volume create kafka3_data
	docker volume create spark_m_data
	docker volume create spark_w_data
	docker volume create postgresql_data
	docker volume create redis_fs_data
	docker volume create redis_fs_data
	docker volume create airflow_data
	docker volume create airflow_w_data
	docker volume create airflow_sk_data
	docker volume create elasticsearch_data
	docker volume create kibana_data
	docker volume create logstash_data 
	docker volume create logstash_data2

run:
	docker-compose -f docker-compose.yml up -d

run-spark:
	docker-compose -f ./spark/docker-compose.yml up -d

run-kafka:
	docker-compose -f ./kafka/docker-compose.yml up -d

run-hadoop:
	docker-compose -f ./hadoop/docker-compose.yml up -d

stop:
	docker-compose -f docker-compose.yml down

stop-spark:
	docker-compose -f ./spark/docker-compose.yml down

stop-kafka:
	docker-compose -f ./kafka/docker-compose.yml down

stop-hadoop:
	docker-compose -f ./hadoop/docker-compose.yml down

create-repo:
	mkdir -p ./data/hadoop/dfs/datanode
	mkdir -p ./data/hadoop/dfs/namenode
	mkdir -p ./data/hadoop/postgres
	mkdir -p ./data/hadoop/yarn
	mkdir -p ./data/jupyter/notebooks
	mkdir -p ./data/spark/jobs
	mkdir -p ./data/spark/resources/data
	mkdir -p ./data/spark/resources/jars
	mkdir -p ./data/kafka/config
	mkdir -p ./data/kafka/data
	mkdir -p ./data/kafka/zookeeper
	mkdir -p ./data/airflow
