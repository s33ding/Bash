#!/bin/bash

directory="$1"  # Get the target directory from the first command-line argument

while true; do
    du -h "$directory"  # Use the target directory from the argument
    sleep 3s  # Wait for 3 seconds before the next measurement
    printf "\r"   # Move the cursor back to the beginning of the line
done

