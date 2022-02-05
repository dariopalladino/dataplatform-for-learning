#!/bin/bash

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager

$HADOOP_HOME/bin/yarn --daemon start resourcemanager