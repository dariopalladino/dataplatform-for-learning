#FROM jupyterhub/jupyterhub:latest
FROM jupyter/pyspark-notebook:spark-3.2.0

LABEL maintainer="Dario Palladino <dariopalladino@protonmail.com>"
ARG CFG_USER
ARG CFG_PASSWORD

USER root

RUN useradd --password $(python3 -c 'import crypt; print(crypt.crypt("${CFG_PASSWORD}"))') ${CFG_USER}
RUN pip install delta-spark

USER jovyan