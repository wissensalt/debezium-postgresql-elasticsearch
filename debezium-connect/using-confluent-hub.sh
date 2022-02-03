#!/usr/bin/env bash

CONFLUENT_HUB="confluent-hub-client-latest.tar.gz"

# echo "Downloading confluent hub client..."
# curl -sO  http://client.hub.confluent.io/${CONFLUENT_HUB} && \
# echo "Done"

echo "Extracting..."
tar -xzf ${CONFLUENT_HUB} && \
echo "Done"

echo "Removing installer"
rm ${CONFLUENT_HUB} && \
echo "Done"

cd bin && \

echo "PWD : " ${PWD}

echo "Installing kafka connect jdbc..."
sh confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.3.1 --component-dir /app/libs

echo "Installing kafka connect elasticsearch"
sh confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.1.8