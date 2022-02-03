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
