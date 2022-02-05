#!/bin/bash
set -e
#POSTGRES_USER=$POSTGRES_USER
#POSTGRES_PWD=$POSTGRES_PWD
#POSTGRES_DB=$POSTGRES_DB

echo "User: " $METASTORE_USER
echo "Password: " $METASTORE_PWD
echo "Database: " $METASTORE_DB

#export PGPASSWORD=$POSTGRES_PWD

psql -v ON_ERROR_STOP=1 --username "postgres" -v USR="$METASTORE_USER" -v DB="$METASTORE_DB" -v PWD="$METASTORE_PWD"<<-EOSQL
  CREATE USER :USR WITH PASSWORD ':PWD';
  CREATE DATABASE :DB;
  GRANT ALL PRIVILEGES ON DATABASE :DB TO :USR;

  \c :DB

  \i /hive/hive-schema-2.3.0.postgres.sql
  \i /hive/hive-txn-schema-2.3.0.postgres.sql
  \i /hive/upgrade-2.3.0-to-3.0.0.postgres.sql
  \i /hive/upgrade-3.0.0-to-3.1.0.postgres.sql

  \pset tuples_only
  \o /tmp/grant-privs
SELECT 'GRANT SELECT,INSERT,UPDATE,DELETE ON "' || schemaname || '"."' || tablename || '" TO :USR ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and schemaname = 'public';
  \o
  \i /tmp/grant-privs
EOSQL
