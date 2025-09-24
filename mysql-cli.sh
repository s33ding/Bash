#!/bin/bash

JSON_CREDENTIAL=$MYSQL_CRED

# Parse JSON file and retrieve credentials
HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
USER=$(jq -r '.user' "$JSON_CREDENTIAL")
PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")
CONTAINER=$(jq -r '.container_name' "$JSON_CREDENTIAL")

# Connect to MySQL and perform some operations
echo "🐬 Connecting to MySQL..."
echo "👤 User: $USER"
echo "🌐 Host: $HOST"
echo "🔌 Port: $PORT"

#docker exec -it $CONTAINER mysql -u "$USER" -p"$PASSWORD"
#
mysqlsh --mysqlx -u "$USER" -h "$HOST" -P 33065 -p"$PASSWORD"

