#!/bin/bash

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager

$HADOOP_HOME/bin/yarn --daemon start nodemanager