#!/usr/bin/env bash

# remove source connector
curl -i -X DELETE localhost:8083/connectors/postgres-employee-source

# remove sink connector
curl -i -X DELETE localhost:8083/connectors/es-employee-sink