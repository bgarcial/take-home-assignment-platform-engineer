# FROM maven:3.6.3-openjdk-15-alpine
FROM openjdk:14-alpine
MAINTAINER example.com
RUN mkdir -p /opt/demo-0.0.1/lib
# Setting application source code working directory
WORKDIR /opt/demo-0.0.1/
COPY target/demo-0.0.1-SNAPSHOT.jar /opt/demo-0.0.1/lib/
# ADD target/demo-0.0.1-SNAPSHOT.jar /opt/demo-0.0.1/lib/

RUN sh -c 'touch demo-0.0.1-SNAPSHOT.jar'
ENTRYPOINT ["java"]
CMD ["-jar", "/opt/demo-0.0.1/lib/demo-0.0.1-SNAPSHOT.jar"]