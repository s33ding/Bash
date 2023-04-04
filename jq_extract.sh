#!/bin/bash

# This script prompts the user to enter the name of a key to extract from a set of JSON files in the current directory.
# It then loops through all of the .json files in the current directory and uses the jq command-line tool to extract the
# value of the specified key from each file. The script then prints the name of each file and the extracted key value to the console.

# Prompt the user to enter the name of the key to extract
echo "Enter the name of the key to extract:"
read key_name

# Loop through all JSON files in the current directory
for file in *.json; do

    # Print the filename and the value of the specified key
    echo "$file"
    jq ".$key_name" "$file"

done

