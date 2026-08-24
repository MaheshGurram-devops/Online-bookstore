FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        openjdk-17-jre-headless \
        mysql-server \
        ca-certificates \
        curl \
        tar \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /usr/share/tomcat10 \
    && curl -fsSL https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.44/bin/apache-tomcat-10.1.44.tar.gz -o /tmp/tomcat.tar.gz \
    && tar -xzf /tmp/tomcat.tar.gz --strip-components=1 -C /usr/share/tomcat10 \
    && rm /tmp/tomcat.tar.gz \
    && rm -rf /usr/share/tomcat10/webapps/*

COPY target/onlinebookstore.war /usr/share/tomcat10/webapps/ROOT.war

COPY init.sql /init.sql
COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh

EXPOSE 8080

ENV CATALINA_HOME=/usr/share/tomcat10
ENV CATALINA_BASE=/usr/share/tomcat10

CMD ["/usr/local/bin/start.sh"]