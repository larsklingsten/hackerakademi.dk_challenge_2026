#!/bin/bash

# versions
# v1.00 First

VM_IP=192.168.122.39
HOST_IP=10.0.0.42
SSH_EXT_PORT=20022
SSH_INT_PORT=22

SSH_EXT_PORT_2=22222
SSH_INT_PORT_2=2222

HTTP_EXT_PORT=8080
HTTP_INT_PORT=80

echo "Creates ssh tunnel to $VM_IP"

# Kill any existing tunnels
pkill -f "L $HOST_IP:$SSH_EXT_PORT"
pkill -f "L $HOST_IP:$SSH_EXT_PORT_2"
pkill -f "L $HOST_IP:$HTTP_EXT_PORT"

echo "use pwd:hunter2"
echo 
ssh -f -N -L $HOST_IP:$SSH_EXT_PORT:localhost:$SSH_INT_PORT user@$VM_IP
ssh -f -N -p 2222 -L $HOST_IP:$SSH_EXT_PORT_2:localhost:$SSH_INT_PORT_2 root@$VM_IP

ssh -f -N -L $HOST_IP:$HTTP_EXT_PORT:$VM_IP:$HTTP_INT_PORT user@$VM_IP

# Check if they're listening
ss -tlnp | grep -E "$HTTP_EXT_PORT|$SSH_EXT_PORT|$SSH_EXT_PORT_2"