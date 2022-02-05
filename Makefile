DOCKER_NETWORK = iotnet
ENV_FILE = ./hadoop/hadoop.env
hadoop_branch = 3.3.1-snapshot-1
spark_branch = 3.2.0-snapshot-1

build:
	docker build -t dariopad/hadoop-base:$(hadoop_branch) ./hadoop/base --build-arg ARG_HADOOP_VERSION=3.3.1
	docker build -t dariopad/hadoop-namenode:$(hadoop_branch) ./hadoop/namenode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-datanode:$(hadoop_branch) ./hadoop/datanode --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-resourcemanager:$(hadoop_branch) ./hadoop/resourcemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-nodemanager:$(hadoop_branch) ./hadoop/nodemanager --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache
	docker build -t dariopad/hadoop-historyserver:$(hadoop_branch) ./hadoop/historyserver --build-arg ARG_HADOOP_VERSION=3.3.1 --no-cache	
	docker build -t dariopad/hive:$(hadoop_branch) ./hadoop/hive --build-arg HIVE_VERSION=3.1.2 --no-cache
	docker build -t dariopad/postgres-metastore:$(hadoop_branch) ./hadoop/postgres-metastore --build-arg POSTGRES_DATABASE=metastore --build-arg POSTGRES_USER=hive-user --build-arg POSTGRES_PASSWORD=hive-pwd --no-cache
	docker build -t dariopad/spark:$(spark_branch) ./spark --no-cache
	docker build -t dariopad/jupyter-spark:$(spark_branch) ./jupyter --no-cache
	docker build -t dariopad/airflow-spark:$(spark_branch) ./airflow-build --no-cache

push:
	docker push dariopad/hadoop-base:$(hadoop_branch)
	docker push dariopad/hadoop-namenode:$(hadoop_branch)
	docker push dariopad/hadoop-datanode:$(hadoop_branch)
	docker push dariopad/hadoop-resourcemanager:$(hadoop_branch)
	docker push dariopad/hadoop-nodemanager:$(hadoop_branch)
	docker push dariopad/hadoop-historyserver:$(hadoop_branch)
	docker push dariopad/hive:$(hadoop_branch)
	docker push dariopad/postgres-metastore:$(hadoop_branch)
	docker push dariopad/spark:$(spark_branch)
	docker push dariopad/jupyter-spark:$(spark_branch)
	docker push dariopad/airflow-spark:$(spark_branch)

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