FROM dariopad/hadoop-base:latest

LABEL maintainer Dario Palladino <dario.palladino@gmail.com>


ARG ARG_HADOOP_VERSION

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
