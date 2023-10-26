summary about Samba:

Install Samba: Install Samba on your system. The installation commands may vary based on your Linux distribution:

Ubuntu or Debian: sudo apt-get install samba
CentOS or Fedora: sudo dnf install samba
Configure Samba: Edit the Samba configuration file to set up the shared folder:

sudo vim /etc/samba/smb.conf

Add shared folder: In the configuration file, define the shared folder by adding the following lines at the end:
[SharedFolder]
path = /path/to/folder
writable = yes
guest ok = yes
read only = no
create mask = 0777
directory mask = 0777

sudo smbpasswd -a username
Replace "username" with the desired username for Samba access.

Restart Samba: Restart the Samba service to apply the changes:

Ubuntu or Debian: sudo service smbd restart
CentOS or Fedora: sudo systemctl restart smb
Configure firewall: If necessary, configure the firewall to allow Samba traffic. Typically, open TCP ports 139 and 445.

Access shared folder: From another PC on the same network, open the file manager and enter the following in the address bar:
smb://ip_address/shared_folder_name
Replace ip_address with the IP address of the PC sharing the folder, and shared_folder_name with the name specified in the Samba configuration.

These steps provide a basic outline for creating and accessing a shared folder with Samba between two PCs on the same network. Adjustments may be necessary based on your specific operating system and network configuration.
