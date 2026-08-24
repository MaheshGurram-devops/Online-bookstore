FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        tomcat9 \
        mysql-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY target/onlinebookstore.war /var/lib/tomcat9/webapps/ROOT.war

COPY init.sql /init.sql
COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 8080

CMD ["/usr/local/bin/start.sh"]