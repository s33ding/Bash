#!/bin/bash

# Set JSON credentials file location
JSON_CREDENTIAL=$MYSQL_CRED

# Parse JSON file and retrieve credentials
HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
USER=$(jq -r '.user' "$JSON_CREDENTIAL")
PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")
DATABASE=$(jq -r '.database' "$JSON_CREDENTIAL")

# Connect to MySQL and perform some operations
echo "Connecting to MySQL..."
mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD" "$DATABASE" -e "INSERT INTO mytable VALUES (1, 'myvalue')"
if [ $? -eq 0 ]; then
  echo -e "\U0001F42C MySQL query executed successfully!"
else
  echo "Error executing MySQL query"
fi
