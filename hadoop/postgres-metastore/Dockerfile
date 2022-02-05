FROM bitnami/postgresql:latest

LABEL maintainer Dario Palladino <dario.palladino@gmail.com>

ARG METASTORE_USERNAME
ARG METASTORE_PASSWORD
ARG METASTORE_DATABASE

ENV METASTORE_USER=${METASTORE_USERNAME:-hive}
ENV METASTORE_PWD=${METASTORE_PASSWORD:-hive}
ENV METASTORE_DB=${METASTORE_DATABASE:-hive}

COPY hive-schema-2.3.0-postgres.sql /hive/hive-schema-2.3.0-postgres.sql
COPY hive-txn-schema-2.3.0-postgres.sql /hive/hive-txn-schema-2.3.0-postgres.sql
COPY upgrade-2.3.0-to-3.0.0-postgres.sql /hive/upgrade-2.3.0-to-3.0.0-postgres.sql
COPY upgrade-3.0.0-to-3.1.0-postgres.sql /hive/upgrade-3.0.0-to-3.1.0-postgres.sql

COPY init-hive-metastore.sh /docker-entrypoint-initdb.d/init-user-db.sh