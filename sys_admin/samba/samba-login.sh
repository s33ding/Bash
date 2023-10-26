#!/bin/bash

# Samba server details
samba_server=="192.168.68.106"
share_name="work"
username="roberto"

# Connect to the Samba server
echo "smbclient "//$samba_server/$share_name" -U "$username" <<EOF"
# Enter the Samba server password here if needed

# Commands to execute within smbclient
ls
# Add more commands as needed

# Exit smbclient
quit
EOF
