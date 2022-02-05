FROM dariopad/hadoop-base:latest

LABEL maintainer="Dario Palladino <dariopalladino@protonmail.com>"


ARG ARG_HADOOP_VERSION

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
