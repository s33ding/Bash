#!/bin/bash

# Set JSON credentials file location
JSON_CREDENTIAL=$REDIS_CRED

# Parse JSON file and retrieve credentials
HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
PASSWORD=$(jq -r '.password' "$JSON_CREDENTIAL")

# Try to connect to Redis and perform some operations
echo "Connecting to Redis..."
if redis-cli --no-auth-warning -h "$HOST" -p "$PORT" -a "$PASSWORD" ping &>/dev/null; then
  redis-cli --no-auth-warning -h "$HOST" -p "$PORT" -a "$PASSWORD" set mykey "myvalue"
  # Check if key was set successfully
  if [ "$(redis-cli --no-auth-warning -h "$HOST" -p "$PORT" -a "$PASSWORD" get mykey)" == "myvalue" ]; then
    echo -e "\U2714 Redis key 'mykey' set successfully!"
  else
    echo "Error setting Redis key 'mykey'"
  fi
else
  echo "Could not connect to Redis at $HOST:$PORT"
fi

