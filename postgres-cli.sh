#!/bin/bash

# Set JSON credentials file location
JSON_CREDENTIAL=$POSTGRES_CRED

# Parse JSON file and retrieve credentials
HOST=$(jq -r '.host' "$JSON_CREDENTIAL")
PORT=$(jq -r '.port' "$JSON_CREDENTIAL")
USER=$(jq -r '.user' "$JSON_CREDENTIAL")
DATABASE=$(jq -r '.database' "$JSON_CREDENTIAL")

echo "Connecting to PostgreSQL..."
psql -h "$HOST" -p "$PORT" -U "$USER" -d "$DATABASE" -W

