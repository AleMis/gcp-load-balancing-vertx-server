FROM openjdk:8-jre-alpine
MAINTAINER aleksander.miszkiewicz
ENV APP_HOME /app
RUN mkdir $APP_HOME
EXPOSE 8080
COPY target/vertx-http-server-1.0.0-SNAPSHOT.jar .
CMD ["/usr/bin/java", "-jar", "-noverify", "-XX:TieredStopAtLevel=1", "-XX:+UnlockExperimentalVMOptions","-XX:+UseCGroupMemoryLimitForHeap", "vertx-http-server-1.0.0-SNAPSHOT.jar"]