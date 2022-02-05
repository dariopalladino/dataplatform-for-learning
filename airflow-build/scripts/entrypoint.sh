#!/usr/bin/env bash

TRY_LOOP="20"

: "${REDIS_HOST:="redis"}"
: "${REDIS_PORT:="6379"}"
: "${REDIS_PASSWORD:=""}"

: "${POSTGRES_HOST:="postgres"}"
: "${POSTGRES_PORT:="5432"}"
: "${POSTGRES_USER:="airflow"}"
: "${POSTGRES_PASSWORD:="airflow"}"
: "${POSTGRES_DB:="airflowdb"}"
: "${AIRFLOW_HOME:="/usr/local/airflow"}"

# Defaults and back-compat
: "${AIRFLOW__CORE__FERNET_KEY:=${FERNET_KEY:=$(python -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}}"
: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Sequential}Executor}"

echo "***********Exporting variables***************"

export \
  AIRFLOW_HOME \
  AIRFLOW__CELERY__BROKER_URL \
  AIRFLOW__CELERY__RESULT_BACKEND \
  AIRFLOW__CORE__EXECUTOR \
  AIRFLOW__CORE__FERNET_KEY \
  AIRFLOW__CORE__LOAD_EXAMPLES \
  AIRFLOW__CORE__SQL_ALCHEMY_CONN \

#TODO: export AIRFLOW__CORE__SQL_ALCHEMY_CONN_CMD=bash_command_to_run
echo "***********Finish Exporting variables***************"

echo "***********CUSTOM CONFIG**************************"
function changeProperty() {
  local path=$1
  local key=$2
  local value=$3

  pattern = $(grep -rnw $path -e "# ${key}")
  if [[ -z $pattern ]]; then
      sed -i "s/^${key}.*/$key = ${value}/" $path
  else
      sed -i "s/^# ${key}.*/$key = ${value}/" $path
  fi
}

if [ "$AIRFLOW_CUSTOM_CONFIG" == "1" ]; then
    echo "Customizing airflow"

    if [ "$AIRFLOW_EXECUTOR" ]; then
       changeProperty /usr/local/airflow/airflow/airflow.cfg executor $AIRFLOW_EXECUTOR
    fi    
    if [ "$AIRFLOW_FERNET_KEY" ]; then
       changeProperty /usr/local/airflow/airflow/airflow.cfg fernet_key $AIRFLOW_FERNET_KEY
    fi
    if [ "$AIRFLOW_SECRET_KEY" ]; then
       changeProperty /usr/local/airflow/airflow/airflow.cfg secret_key $AIRFLOW_SECRET_KEY
    fi
    if [[ "$AIRFLOW_DATABASE_HOST" = "postgresql" && "$AIRFLOW_DATABASE_NAME" && "$AIRFLOW_DATABASE_USERNAME" ]]; then
       changeProperty /usr/local/airflow/airflow/airflow.cfg result_backend $AIRFLOW_DATABASE_HOST"://"$AIRFLOW_DATABASE_USERNAME":"$AIRFLOW_DATABASE_PASSWORD"@"$AIRFLOW_DATABASE_HOST"/"$AIRFLOW_DATABASE_NAME
       changeProperty /usr/local/airflow/airflow/airflow.cfg sql_alchemy_conn $AIRFLOW_DATABASE_HOST"+psycopg2://"$AIRFLOW_DATABASE_USERNAME":"$AIRFLOW_DATABASE_PASSWORD"@"$AIRFLOW_DATABASE_HOST":"$AIRFLOW_DATABASE_PORT"/"$AIRFLOW_DATABASE_NAME       
    fi
    if [[ "$AIRFLOW_REDIS_HOST" && "$AIRFLOW_REDIS_PORT_NUMBER" ]]; then
       changeProperty /usr/local/airflow/airflow/airflow.cfg broker_url "redis://"$AIRFLOW_REDIS_HOST":"$AIRFLOW_REDIS_PORT_NUMBER
    fi
    
fi

echo "************DONE WITH CONFIG*****************"


# Load DAGs exemples (default: Yes)
if [[ -z "$AIRFLOW__CORE__LOAD_EXAMPLES" && "${LOAD_EX:=n}" == n ]]
then
  AIRFLOW__CORE__LOAD_EXAMPLES=False
fi

# Install custom python package if requirements.txt is present
if [ -e "/requirements.txt" ]; then
    $(which pip) install --user -r /requirements.txt
fi

if [ -n "$REDIS_PASSWORD" ]; then
    REDIS_PREFIX=:${REDIS_PASSWORD}@
else
    REDIS_PREFIX=
fi

wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}

echo "*************AIRFLOW CONFIGURATION****************"
cat $AIRFLOW_HOME/airflow/airflow.cfg
echo "*************AIRFLOW CONFIGURATION****************"

if [ "$AIRFLOW__CORE__EXECUTOR" != "SequentialExecutor" ]; then
  #AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
  # AIRFLOW__CELERY__RESULT_BACKEND="db+postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
  wait_for_port "Postgres" "$POSTGRES_HOST" "$POSTGRES_PORT"
fi

if [ "$AIRFLOW__CORE__EXECUTOR" = "CeleryExecutor" ]; then
  # AIRFLOW__CELERY__BROKER_URL="redis://$REDIS_PREFIX$REDIS_HOST:$REDIS_PORT/1"
  wait_for_port "Redis" "$REDIS_HOST" "$REDIS_PORT"
fi

case "$1" in
  webserver)
    airflow db init
    if [ "$AIRFLOW__CORE__EXECUTOR" = "LocalExecutor" ]; then
      # With the "Local" executor it should all run in one container.
      airflow scheduler &
    fi
    exec airflow webserver
    # Create connection
    # exec airflow connections add --conn_id 'postgres_test' --conn_uri 'postgres://test:postgres@postgres:5432/test'
    ;;
  worker|scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow "$@"
    ;;
  flower)
    sleep 10
    exec airflow "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    # The command is something like bash, not an airflow subcommand. Just run it in the right environment.
    exec "$@"
    ;;
esac