#!/bin/bash

# ping nearby IPs

# v1.02 Parallel network scanner
# v1.01 Ping all hosts on all directly connected networks
# v1.00

NETWORKS=()

# Extract directly connected networks
while read -r line; do
    NET=$(echo "$line" | awk '{print $1}')
    [[ "$NET" == "default" ]] && continue

    PREFIX=$(echo "$NET" | sed -E 's|([0-9]+\.[0-9]+\.[0-9]+)\..*|\1.|')
    NETWORKS+=("$PREFIX")
done < <(ip route | grep "scope link")

# Sort networks numerically
IFS=$'\n' NETWORKS=($(sort -t. -k1,1n -k2,2n -k3,3n <<<"${NETWORKS[*]}"))
unset IFS

echo "[*] Networks detected (sorted):"
for net in "${NETWORKS[@]}"; do
    echo "    $net"
done
echo

# Scan each network in parallel
scan_network() {
    local NET="$1"
    local OUTPUT=""
 
    for i in {1..254}; do
        IP="${NET}${i}"
        if ping -c 1 -W 0.1 "$IP" > /dev/null 2>&1; then
            OUTPUT+="[+] Found: $IP"$'\n'
        fi
    done
    echo "$OUTPUT"
  
}

export -f scan_network

# Run all networks in parallel and wait
for NET in "${NETWORKS[@]}"; do
    scan_network "$NET" &
done

wait

echo "Done."
