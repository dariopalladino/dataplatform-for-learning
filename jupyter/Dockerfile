FROM jupyterhub/jupyterhub:latest

LABEL maintainer="Dario Palladino <dariopalladino@protonmail.com>"
ARG CFG_USER
ARG CFG_PASSWORD
ENV USER ${CFG_USER}
ENV PWD ${CFG_PASSWORD}

RUN useradd --password $(python3 -c 'import crypt; print(crypt.crypt("${PWD}"))') -c "" ${USER} && pip install notebook
