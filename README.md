# debezium-postgresql-elasticsearch

## Tech Stack
- Docker
- Postgresql
- Zookeeper
- Kafka
- Debezium
- Elasticsearch

## How to Run
```sh
# Run all docker instances
docker-compose up

# Check if elasticsearch is UP
curl http://localhost:9200

# Check if debezium is UP
curl -H "Accept:application/json" localhost:8083/

# Deploy all configurations when elasticsearch and debezium is UP
sh deploy-configurations.sh

# Check debezium configurations
curl -H "Accept:application/json" http://localhost:8083/connector-plugins
curl -H "Accept:application/json" http://localhost:8083/connectors

# Delete connector configuration (if necessary)
curl -i -X DELETE localhost:8083/connectors/employee_db-connector/

# Check elasticsearch configurations
curl -H "Accept:application/json" http://localhost:9200/employee
curl -H "Accept:application/json" http://localhost:9200/employee/_search?pretty

# Watch messages from debezium topic
docker-compose exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic postgre-debezium-server.public.employee

# Open new tab to manipulate table
docker-compose exec postgres env PGOPTIONS="--search_path=public" bash -c 'psql -U $POSTGRES_USER postgres'

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


 
docker run -p 8080:8080 --network=debezium-postgresql-elasticsearch_default --link elasticsearch -d cars10/elasticvue

"transforms": "unwrap,key",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": "false",
    "transforms.unwrap.drop.deletes": "false",
    "transforms.key.type": "org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.key.field": "id",
    "behavior.on.null.values": "delete",
    
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
      --topic postgre-employee.public.employee