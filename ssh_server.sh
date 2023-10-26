#!/bin/bash

# Set JSON credentials file location
JSON_CREDENTIAL=$LINODE_CRED

# Parse JSON file and retrieve credentials
HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
USER=$(jq -r '.user' "$JSON_CREDENTIAL")
PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")

# Connect to MySQL and perform some operations
echo "Connecting to the Linux server as '$USER'."

sshpass -p "$PASSWORD" ssh $USER@$HOST -p $PORT
