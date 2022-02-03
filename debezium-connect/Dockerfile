ARG DEBEZIUM_VERSION
FROM debezium/connect:${DEBEZIUM_VERSION}

ENV KAFKA_CONNECT_JDBC_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-jdbc
ENV KAFKA_CONNECT_ES_DIR=$KAFKA_CONNECT_PLUGINS_DIR/kafka-connect-elasticsearch

ARG POSTGRES_VERSION=42.3.1
ARG KAFKA_JDBC_VERSION=10.0.0

# Deploy PostgreSQL JDBC Driver
RUN cd /kafka/libs && curl -sO https://jdbc.postgresql.org/download/postgresql-$POSTGRES_VERSION.jar

# Deploy Kafka Connect JDBC
RUN mkdir $KAFKA_CONNECT_JDBC_DIR && cd $KAFKA_CONNECT_JDBC_DIR
COPY kafka-connect-jdbc $KAFKA_CONNECT_JDBC_DIR

# Deploy Confluent Elasticsearch sink connector
RUN mkdir $KAFKA_CONNECT_ES_DIR && cd $KAFKA_CONNECT_ES_DIR
COPY kafka-connect-elasticsearch $KAFKA_CONNECT_ES_DIR