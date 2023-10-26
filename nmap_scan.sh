#!/bin/bash

# Scan the local network for hosts with SSH port open and extract IP addresses
ip_addresses=$(nmap -p 22 --open 192.168.1.0/25 -oG - | awk '/22\/open/ {print $2}')

# Read the IP addresses
for ip_address in $ip_addresses; do
    # Test if the IP address belongs to the local machine
    if [[ "$ip_address" != "$(hostname -I)" ]]; then
        echo "The IP address of another computer with SSH port open is: $ip_address"
    fi
done

