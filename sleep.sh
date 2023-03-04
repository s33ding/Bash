#!/bin/bash

echo "How long do you want your computer to stay on before shutting down?😴"

# Prompt the user for the number of minutes
read -p "Enter the number of minutes: " minutes

# Convert minutes to seconds

# Schedule the shutdown
shutdown -P $minutes

echo "The computer will shut down in $minutes minutes. Have a good sleep!"
