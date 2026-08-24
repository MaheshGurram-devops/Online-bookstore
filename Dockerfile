FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Java, Tomcat and MySQL
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    tomcat9 \
    mysql-server \
    && apt-get clean

# Copy WAR file to Tomcat
COPY target/onlinebookstore.war /var/lib/tomcat9/webapps/ROOT.war

# Copy database initialization script
COPY init.sql /docker-entrypoint-initdb.d/init.sql

# Initialize MySQL and create database
RUN service mysql start && \
    mysql < /docker-entrypoint-initdb.d/init.sql

EXPOSE 8080 3306

# Start MySQL and Tomcat
CMD service mysql start && catalina.sh run