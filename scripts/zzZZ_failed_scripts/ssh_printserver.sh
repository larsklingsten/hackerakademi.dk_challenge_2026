#!/bin/bash

# connect to root@printserver from root@router, and the jump succedeed"

# v1.01 change from unreliable process count to boot id
# v1.00 2026-02-26

echo "Usage:"
echo "./ssh_printerserver.sh          -> proof + interactive shell"
echo "./ssh_printerserver.sh --test   -> proof only, no shell "
echo ""

# 1. Capture the local boot_id
LOCAL_BOOT_ID=$(cat /proc/sys/kernel/random/boot_id)

echo "=== BEFORE (Local Machine) ==="
echo "Hostname: $(hostname)"
echo "Boot ID:  $LOCAL_BOOT_ID"
echo ""
echo "=== Jumping to printserver... ==="
echo ""

# 2. Logic to run on the remote side
# It captures the remote boot_id and compares it to the local one passed via variable
PROOF="
  REMOTE_BOOT_ID=\$(cat /proc/sys/kernel/random/boot_id);
  echo '=== AFTER (Remote Machine) ===';
  echo \"Hostname: \$(hostname)\";
  echo \"Boot ID:  \$REMOTE_BOOT_ID\";
  echo '';
  if [ \"\$REMOTE_BOOT_ID\" == \"$LOCAL_BOOT_ID\" ]; then
    echo 'WARN: IDENTICAL BOOT ID DETECTED!';
    echo 'PROOF: You are SSHing into the SAME kernel/machine (Loopback).';
  else
    echo 'SUCCESS: BOOT IDs DIFFER.';
    echo 'PROOF: This is a different machine/VM.';
  fi"

INTERACTIVE="echo 'note: You are now in the remote shell.'; exec bash -i"

if [ "$1" = "--test" ]; then
  REMOTE_CMD="$PROOF"
else
  REMOTE_CMD="$PROOF; $INTERACTIVE"
fi

# 3. Execute SSH
# Uses the ProxyCommand identified in the original script
ssh \
  -i /root/.ssh/id_ed25519 \
  -o "ProxyCommand=nc -U /run/host/unix-export/ssh" \
  -o "StrictHostKeyChecking=no" \
  -t \
  root@printserver \
  "$REMOTE_CMD"