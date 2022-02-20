#!/usr/bin/env bash

# setup elasticsearch indices
curl -i -X PUT -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:9200/employee?include_type_name=true -d @configs/es-employee-index.json

# setup elasticsearch sink
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @configs/es-employee-sink.json

# setup connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @configs/postgres-employee-source.json