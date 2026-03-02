#!/bin/bash

# Collects data from other Machines (vm, docker)
# v1.00

OUT_FILE="os_info_root_printserver.md"
SCRIPT="scripts_sh/os_info.sh"

ROOT_DIR="/home/larsk/source/hacking/fe-2026/"
SSH_KEY_DIR="${ROOT_DIR}ssh_keys/"
SSH_KEY="id_root_printserver"

PORT="2200" # Added based on your previous messages
PC="root@192.168.122.39"
 
CMD="${ROOT_DIR}${SCRIPT}"

ssh -p $PORT -i "${ROOT}${SSH_KEY_DIR}${SSH_KEY}" $PC "bash -s" < "$CMD" > "${ROOT_DIR}${OUT_FILE}"

echo "file saved as:"
ls "${ROOT_DIR}${OUT_FILE}"