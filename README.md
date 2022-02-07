# DATAPLATFORM FOR DEVELOPMENT AND LEARNING
Quite a nice place to start learning around all major buzzy platforms out there, and all connected to work together. I wish this could be the place to create a shared integrated data platform that can be used as a community-driven effort to spread the bigdata knowledge and the techs around it.

However, a small disclaimer: Building a data platform can be done in multiple different ways and with a variety of different stacks. I've picked up those that I know better and are OSS licensed. 
For instance, I could have used Apache Iceberg instead of DeltaLake, however being Delta a need for me, then there you go! Thus, I've chosen those OSS tools I've been using the most based on my working experience. 

## Following capabilities are crafted and containerized for working together:
- Streaming (based on the official containers from both bitnami aka VMWare and Confluent Inc.)
- Streaming monitoring (based on a couple of tools, pick your preferred one)
- The full Elasticsearch stack with Kibana, Logstash and Filebeat! (directly from the official images by Elasticsearch)
- Distributed filesystem with Hadoop cluster (Namenode, Datanode, Resource manager, Yarn, Hive and Hive Metastore based on the official Postgresql by Bitnami)
- Apache Spark with DeltaLake for distributed computing if you want experience running jobs on bigdata (based on the great work made by Bitnami)
- Jupyter with Spark and DeltaLake for learning on-the-fly by connecting to the Apache Spark cluster and using DeltaLake capabilities reading and saving from Hadoop! (based on Jupyter official image)
- Airflow with Spark and DeltaLake (based on official images from Airflow). However, I haven't yet been able to make it fully work nor the time, but it's a good start if you want to learn and work with it.

## How to run
Before running, ensure you are on a good VM with at least 16VCores and 32GB RAM. I tried to keep the specs to the bare minimum and each Spark worker is just using 1GB each, however it is recommended to have more workers for better performance and if you want to have everything running smoothly you should really have a very good VM.

### Watch out! 
Don't run the full stack on a small VM or on your laptop, it will start spinning and it will seem like your computer is ready to sky-rocket!!! I warned you :)

Also, Security is turned off everywhere in this deployment for ease of implementation, so remember, IT IS NOT A PRODUCTION-READY SOLUTION!!!

### Steps
- git clone https://github.com:dariopalladino/dataplatform-for-learning.git
- make create-repo (it creates the data folders required for persistency)
- make create-volumes (it creates the external volumes to bind some working folders)
- make create-net DOCKER_NETWORK=iot_net (it creates the network which will be bound to each container)
- make run DOCKER_NETWORK=iot_net STACK_BRANCH=1.0-SNAPSHOT (it runs the whole stack)

#### Watch out!
All containers run under the external network (bridge driver) iot_net. When you run the make create-net command it will create the network based on a variable set to iot_net. ($DOCKER_NETWORK=iot_net)

### To run only parts of the stack:
#### Apache Spark with Jupyter
- make run-spark DOCKER_NETWORK=iot_net STACK_BRANCH=1.0-SNAPSHOT

#### Hadoop and Spark with Jupyter
- make run-hadoop DOCKER_NETWORK=iot_net STACK_BRANCH=1.0-SNAPSHOT
- make run-spark DOCKER_NETWORK=iot_net STACK_BRANCH=1.0-SNAPSHOT

#### Only Kafka and its ecosystem
- make run-kafka DOCKER_NETWORK=iot_net

#### Build your own image
You may want to refactor these containers, then you can do it and rebuild them all easily with the Makefile
- make build STACK_BRANCH=1.0-SNAPSHOT (it rebuilds each container)
- make build-spark STACK_BRANCH=1.0-SNAPSHOT (rebuild only spark)
- make build-jupyter STACK_BRANCH=1.0-SNAPSHOT CFG_PASSWD=whatever (rebuild only jupyter)
- make build-hadoop STACK_BRANCH=1.0-SNAPSHOT (rebuild only hadoop)
- make build-airflow STACK_BRANCH=1.0-SNAPSHOT (rebuild only airflow)

## Next steps
- Introduce KSQL for realtime analytics reading multiple sources and storing perhaps on Hive tables with Hive Interactive Query (LLAP)? (hmmmm!)
- Add Apache Ranger for enabling integrated security. (Any help?)
- Add PrestoDB as part of the SQL Engine arsenal. I love it and I want to experiment with it. 
- Add Dremio! Dremio is a wanderful Data Reflection/Data Virtualization tool. I've experimented a bit already and I love it!
- Add Apache Atlas for building around Data Governance and Data Lineage. Just to learn more about this powerful OSS tool!
- Add some sample code in python to show each piece of this stack. For instance, reading continuously from WikiMedia changes and streaming to Kafka. Having another job consuming from Kafka and streaming to Elasticsearch to build indexes on specific words and monitoring the changes happening on specific pages. 
- Another example I'm working on is StructuredStreaming, same exercise, reading from a stream of data sent by Filebeat to Kafka from a big dataset (xGB) and listening from a pySpark job which analyze the data and write the content into hadoop with a delta format.
- From Jupyter, you can connect to Apache Spark cluster and read from hadoop with the delta format, create your tables and refresh to see new content as it comes from the streaming job.

If you have DBeaver, you can connect to your store through Hive JDBC (Thrift actually) and read your tables.

There you go! you have a full "working?" data platform covering most of the common business requirements. 

## License
This project is open-sourced software licensed under the [Apache v2.0 License](LICENSE.txt)