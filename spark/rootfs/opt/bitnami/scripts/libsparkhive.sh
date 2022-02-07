#!/bin/bash
#
# Spark Hive library

# shellcheck disable=SC1091

# Functions

########################
# Configure Spark Hive Connector
# Returns:
#   None
#########################
spark_generate_hive_conf() {
    info "Generating Spark Hive configuration properties..."
    echo "# Spark HIVE settings" >>"${SPARK_CONFDIR}/spark-defaults.conf"

    spark_conf_set spark.master                                     "$SPARK_MASTER_URL"
    spark_conf_set spark.eventLog.enabled                           "$SPARK_HIVE_EVENTLOG_ENABLED"
    spark_conf_set spark.eventLog.dir                               "$SPARK_HIVE_HDFS_EVENTLOG_DIR"
    spark_conf_set spark.serializer                                 "org.apache.spark.serializer.KryoSerializer"
    spark_conf_set spark.sql.hive.hiveserver2.jdbc.url              "$SPARK_HIVE_JDBC"
    spark_conf_set spark.datasource.hive.warehouse.load.staging.dir "$SPARK_HIVE_WAREHOUSE_STAGING_DIR"
    spark_conf_set spark.datasource.hive.warehouse.metastoreUri     "$SPARK_HIVE_THRIFT_SERVER"
    spark_conf_set spark.security.credentials.hiveserver2.enabled   "$SPARK_HIVE_CREDENTIALS_ENABLED"
    spark_conf_set spark.sql.hive.hiveserver2.jdbc.url.principal    "$SPARK_HIVE_PRINCIPAL"
    
}
