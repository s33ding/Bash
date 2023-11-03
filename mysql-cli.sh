#!/bin/bash

#Set to true if you have a have a MySql container as second option
condition=false

# Initialize choice to a default value
choice=0

# Check the condition
if [ "$condition" = true ]; then
  # Prompt the user for their choice
  echo "Do you want to connect to a local MySQL or a production MySQL?"
  echo "1) Production MySQL"
  echo "2) Local MySQL"
  read -p "Enter your choice [1 or 2]: " choice
fi

if [ "$choice" -eq 1 ] || [ "$condition" = false ]; then
  JSON_CREDENTIAL=$MYSQL_CRED
elif [ "$choice" -eq 2 ]; then
  JSON_CREDENTIAL=$MYSQL_LOCAL_CRED
else
  echo "Invalid choice. Please enter 1 or 2."
  exit 1
fi

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

if [ "$choice" -eq 1 ] || [ "$condition" = false ]; then
  mysql -h "$HOST" -P "$PORT" -u "$USER" -p"$PASSWORD"
elif [ "$choice" -eq 2 ]; then
  docker exec -it $CONTAINER mysql -u "$USER" -p"$PASSWORD"
fi

