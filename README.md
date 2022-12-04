# debezium-postgresql-elasticsearch

## Target Architecture
![Alt text](screenshots/target-architecture.png?raw=true "target-architecture")

## Tech Stack
- Docker
- Postgresql
- Zookeeper
- Schema Registry (Avro)
- Kafka
- Debezium
- Elasticsearch

## How to Run
```sh
# load environment variables
source .env

# Run all docker instances
docker-compose up
```
![Alt text](screenshots/1.running-docker-containers.png?raw=true "running-docker-containers") 

```sh
# Check if debezium is UP
curl -H "Accept:application/json" localhost:8083/
```
![Alt text](screenshots/2.check-debezium-up.png?raw=true "check-debezium-up")

```sh
# Check if elasticsearch is UP
curl http://localhost:9200
```
![Alt text](screenshots/3.check-es-up.png?raw=true "check-es-up")


```sh
# Deploy all configurations when elasticsearch and debezium is UP
sh deploy-configurations.sh
```
![Alt text](screenshots/4.run-deploy-configurations.png?raw=true "run-deploy-configurations")

```sh
# Check installed debezium connector plugins
curl -H "Accept:application/json" http://localhost:8083/connector-plugins
```
![Alt text](screenshots/5.check-installed-connector-plugins.png?raw=true "check-installed-connector-plugins")

```sh
# Check installed debezium configurations
curl -H "Accept:application/json" http://localhost:8083/connectors
```
![Alt text](screenshots/6.check-installed-debezium-configurations.png?raw=true "check-installed-debezium-configurations")

```sh
# Check installed source connector status
curl -H "Accept:application/json" http://localhost:8083/connectors/postgres-employee-source/status
```
![Alt text](screenshots/7.check-installed-source-connector.png?raw=true "check-installed-source-connector")

```sh
# Check installed sink connector status
curl -H "Accept:application/json" http://localhost:8083/connectors/es-employee-sink/status
```
![Alt text](screenshots/8.check-installed-sink-connector.png?raw=true "check-installed-sink-connector")

```sh
# Check elasticsearch configurations
curl -H "Accept:application/json" http://localhost:9200/cdc.employee_db.public.employee
```
![Alt text](screenshots/9.check-installed-es-index.png?raw=true "check-installed-es-index")

```sh
# Check if debezium topic is created 
docker-compose exec kafka /kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --list
```
![Alt text](screenshots/10.check-topic-created-by-debezium.png?raw=true "check-topic-created-by-debezium")

```sh
# Check if elasticsearch already has content
curl -H "Accept:application/json" http://localhost:9200/cdc.employee_db.public.employee/_search?pretty
```
![Alt text](screenshots/11.check-es-has-content.png?raw=true "check-es-has-content")

```sh
# Open new tab to manipulate table
docker-compose exec postgres env PGOPTIONS="--search_path=public" bash -c 'psql -U $POSTGRES_USER postgres'
```

```sh
# Check insert query
curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "id": {
        "query": 6
      }
    }
  }
}'
```
![Alt text](screenshots/12.dml-insert.png?raw=true "dml-insert")
![Alt text](screenshots/13.result-insert.png?raw=true "result-insert")

```sh
# Check update query
curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "id": {
        "query": 5
      }
    }
  }
}'
```
![Alt text](screenshots/14.dml-update.png?raw=true "dml-update")
![Alt text](screenshots/15.result-update.png?raw=true "result-update")

```sh
# Check delete query
curl -X GET "localhost:9200/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": {
      "id": {
        "query": 5
      }
    }
  }
}'
```
![Alt text](screenshots/16.dml-delete.png?raw=true "dml-delete")
![Alt text](screenshots/17.result-delete.png?raw=true "result-delete")

```sh
# Watch messages from debezium topic as Binary
docker-compose exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic cdc.employee_db.public.employee

# Watch messages from debezium topic as Converted Avro to Json
docker run -it --rm --name avro-consumer --network=debezium-postgresql-elasticsearch_default \
    --link cdc_zookeeper \
    --link cdc_kafka \
    --link cdc_postgres \
    --link cdc_schema_registry \
    debezium/connect:0.10 \
    /kafka/bin/kafka-console-consumer.sh \
      --bootstrap-server kafka:9092 \
      --property print.key=true \
      --formatter io.confluent.kafka.formatter.AvroMessageFormatter \
      --property schema.registry.url=http://schema-registry:8081 \
      --topic cdc.employee_db.public.employee

# Terminate all docker instances
docker-compose down
```

## References
- https://github.com/YegorZaremba/sync-postgresql-with-elasticsearch-example/
- https://github.com/debezium/debezium-examples/tree/main/tutorial
- https://medium.com/dana-engineering/streaming-data-changes-in-mysql-into-elasticsearch-using-debezium-kafka-and-confluent-jdbc-sink-8890ad221ccf
- https://debezium.io/documentation/reference/stable/connectors/mysql.html
- https://debezium.io/documentation/reference/connectors/postgresql.html
- https://docs.confluent.io/debezium-connect-mysql-source/current/mysql_source_connector_config.html
- https://debezium.io/documentation/reference/0.10/configuration/avro.html
- https://debezium.io/documentation/reference/1.2/configuration/event-flattening.html
- https://github.com/confluentinc/demo-scene/blob/master/kafka-to-elasticsearch/README.adoc