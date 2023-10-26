#!/bin/bash

# Update the system
sudo dnf update -y

# Install OpenSSH server
sudo dnf install -y openssh-server

# Start the SSH service
sudo systemctl start sshd

# Enable SSH service to start on boot
sudo systemctl enable sshd

# Generate a random password for the new user
password=$(date +%s | sha256sum | base64 | head -c 20 ; echo)

# Create a new user
sudo useradd -m -s /bin/bash newuser

# Set the password for the new user
echo "newuser:$password" | sudo chpasswd

# Allow only the new user to use SSH
echo "AllowUsers newuser" | sudo tee -a /etc/ssh/sshd_config

# Restart the SSH service
sudo systemctl restart sshd

# Print the new user credentials
echo "New user 'newuser' has been created."
echo "Username: newuser"
echo "Password: $password"
