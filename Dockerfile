FROM maven:3.6.1-jdk-8-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml install

FROM confluentinc/cp-kafka-connect-base:4.0.0

RUN pip install envtpl

COPY --from=build /home/app/target/* /opt/target/
COPY --from=build /home/app/target/kafka-connect-target/usr/share/kafka-connect/kafka-connect-rabbitmq/* /usr/share/java/kafka/
COPY config-templates /opt/config-templates
COPY docker-entrypoint.sh /opt
RUN chmod +x /opt/docker-entrypoint.sh

WORKDIR /opt

CMD [ "./docker-entrypoint.sh" ]
