#!/bin/bash

# Prompt the user for their choice
echo "Do you want to connect to a local MySQL or a production MySQL?"
echo "1) Local MySQL"
echo "2) Production MySQL"
read -p "Enter your choice [1 or 2]: " choice

if [ $choice -eq 1 ]
then
    JSON_CREDENTIAL=$MYSQL_LOCAL_CRED

    # Parse JSON file and retrieve credentials
    HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
    PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
    USER=$(jq -r '.user' "$JSON_CREDENTIAL")
    PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")

elif [ $choice -eq 2 ]
then
    # Production MySQL credentials
    # Set JSON credentials file location
    JSON_CREDENTIAL=$MYSQL_CRED

    # Parse JSON file and retrieve credentials
    HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
    PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
    USER=$(jq -r '.user' "$JSON_CREDENTIAL")
    PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")
else
    echo "Invalid choice. Please enter 1 or 2."
    exit 1
fi
#
# Connect to MySQL and perform some operations
echo "🐬Connecting to MySQL..."
echo "Connecting as '$USER'"

if [ $choice -eq 1 ]
  then
	docker exec -it ts mysql -u $USER -p$PASSWORD

elif [ $choice -eq 2 ]
  then
	mysql -h $HOST -P $PORT -u $USER -p$PASSWORD
fi
