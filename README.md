# DATAPLATFORM FOR DEVELOPMENT AND LEARNING
Quite a nice place to start learning around all major buzzy platforms out there, and all connected to work together.

However, a small disclaimer: Building a data platform can be done in multiple different ways and with a variety of different stacks. I've picked up those that I know better and are OSS licensed. 

I could have used Apache Iceberg for instance instead of DeltaLake, however I need to work with Delta and there we go! Thus, I've chosen those tools I need the most based on my working experience. 

## I've crafted and containerized for you the following capabilities and all working together:
- Streaming (based on the official containers from both bitnami aka VMWare and Confluent Inc.)
- Streaming monitoring (based on a couple of tools, pick your preferred one)
- The full Elasticsearch stack with Kibana, Logstash and Filebeat! (directly from the official images by Elasticsearch)
- Distributed filesystem with Hadoop cluster (Namenode, Datanode, Resource manager, Yarn, Hive and Hive Metastore based on the official Postgresql by Bitnami)
- Apache Spark with DeltaLake for distributed computing if you want experience running jobs on bigdata (based on the great work made by Bitnami)
- Jupyter with Spark and DeltaLake for learning on-the-fly by connecting to the Apache Spark cluster and using DeltaLake capabilities reading and saving from Hadoop! (based on Jupyter official image)
- Airflow with Spark and DeltaLake (based on official images from Airflow). However, I haven't yet been able to make it fully work but it's a good start if you want to learn and work with it.

## How to run
Before running, ensure you are on a good VM with at least 16VCores and 32GB RAM. I tried to keep the specs to the bare minimum and each Spark worker is not using more than 1GB each. 

However, if you want to have everything running smoothly you should really have a very good VM.

### Watch out! 
Don't run the full stack on a small VM or on your laptop, it will start spinning and it will seem like your computer is ready to sky-rocket!!! I warned you :)

### Steps
- git clone https://github.com:dariopalladino/dataplatform-for-learning.git
- make create-repo (it creates the data folders required for persistency)
- make create-volumes (it creates the external volumes to bind some working folders)
- make create-net (it creates the network which will be bound to each container)
- make run (it runs the whole stack)

#### Watch out!
All containers run under the external network (bridge driver) iot_net. When you run the make create-net command it will create the network based on a variable set to iot_net. 

However, while you can change it to anything you want, since the docker-compose.yml is not yet parametrized, remember to change the network at the bottom of this file.

### To run only parts of the stack:
#### Apache Spark with Jupyter
- make run-spark

#### Hadoop and Spark with Jupyter
- make run-hadoop
- make run-spark

#### Only Kafka and its ecosystem
- make run-kafka

#### Build your own image
You may want to refactor these containers, then you can do it and rebuild them all easily with the Makefile
- make build (it rebuilds each container)
- make build-spark (rebuild only spark)
- make build-jupyter (rebuild only jupyter)
- make build-hadoop (rebuild only hadoop)
- make build-airflow (rebuild only airflow)

## Next steps
- Add PrestoDB as part of the SQL Engine arsenal. I love it and I want to experiment with it. 
- Add Dremio! Dremio is a wanderful Data Reflection/Data Virtualization tool. I've experimented a bit already and I love it!
- Add some sample code in python to show each piece of this stack through python jobs. For instance, reading continuously from WikiMedia changes and streaming to Kafka. Having another job consuming from Kafka and streaming to Elasticsearch to build indexes on specific words and monitoring the changes happening on specific pages. 
- Another example I'm working on is StructuredStreaming, same exercise, reading from a stream of data sent by Filebeat to Kafka from a big dataset (xGB) and listening from a pySpark job which analyze the data and write the content into hadoop with a delta format.
- From Jupyter, you can connect to Apache Spark cluster and read from hadoop with the delta format, create your tables and refresh to see new content as it comes from the streaming job.

If you have DBeaver, you can connect to your store through Hive JDBC and read your tables.

There you go! you have a full working data platform covering most of the business requirements. 

## License
This project is open-sourced software licensed under the [Apache v2.0 License](LICENSE.txt)