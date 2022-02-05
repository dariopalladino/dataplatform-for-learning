#!/bin/bash

$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver

$HADOOP_HOME/bin/yarn --daemon start timelineserver