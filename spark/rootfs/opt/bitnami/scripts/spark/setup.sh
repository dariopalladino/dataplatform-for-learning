#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspark.sh
. /opt/bitnami/scripts/libsparkhive.sh


# Load Spark environment variables
eval "$(spark_env)"

# Ensure Spark environment variables settings are valid
spark_validate

# Ensure 'spark' user exists when running as 'root'
am_i_root && ensure_user_exists "$SPARK_DAEMON_USER" --group "$SPARK_DAEMON_GROUP"

# Ensure Spark Hive is configured
spark_generate_hive_conf

# Ensure Spark is initialized
spark_initialize

