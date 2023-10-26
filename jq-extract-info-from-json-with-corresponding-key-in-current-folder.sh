#!/bin/bash

# This script prompts the user to enter the name of a key to extract from a set of JSON files in the current directory.
# It then loops through all of the .json files in the current directory and uses the jq command-line tool to extract the
# value of the specified key from each file. The script then prints the name of each file and the extracted key value to the console.

# Prompt the user to enter the name of the key to extract
echo "Enter the name of the key to extract:"
read key_name

# Loop through all JSON files in the current directory
for file in *.json; do

    # Extract the value of the specified key from the file
    key_value=$(jq ".$key_name" "$file")

    # Check if the key value exists in the file
    if [ -n "$key_value" ]; then
        # Print the filename and the value of the specified key
        echo "$file"
        echo "$key_value"
    fi

done

