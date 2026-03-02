#!/bin/bash

# 'tree' as shell script

# v1.00 2026-02-26

echo "tree.sh ran on $(date -u '+%Y-%m-%d %H:%M:%S')"   

run() {
    local tag="$1"
    local cmd="$2"
    echo "<$tag>"
    eval "$cmd" 2>&1 | grep -v '^\s*#' | grep -v '^\s*$' || true
    echo "</${tag}>"
    echo ""
}

tree_format() {
    awk -F/ '
    {
        n = split($0, parts, "/")
        filename = parts[n]
        split(prev_path, pp, "/")

        for (i=2; i<n; i++) {
            if (parts[i] != pp[i]) {
                indent = ""
                for (j=2; j<i; j++) indent = indent "│   "
                print indent "├── " parts[i] "/"
                for (k=i+1; k<=20; k++) pp[k] = ""
            }
        }

        indent = ""
        for (i=2; i<n; i++) indent = indent "│   "
        print indent "├── " filename

        prev_path = $0
        split(prev_path, pp, "/")
    }'
}

# ---------------------------------------------------------------------------
# Search only existing paths
# ---------------------------------------------------------------------------
SEARCH_PATHS=""
for p in /home /root /opt /etc /tmp /srv /var/backups /var/mail /run/host; do
    [ -d "$p" ] && SEARCH_PATHS="$SEARCH_PATHS $p"
done

NAMES="-name '*.js' -o -name '*.go' -o -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.py' -o -name '*.sh' -o -name '*.rb' -o -name '*.php' -o -name '*.pl' -o -name '*.conf' -o -name '*.cfg' -o -name '*.ini' -o -name '*.env' -o -name '*.yaml' -o -name '*.yml' -o -name '*.toml' -o -name '*.json' -o -name '*.xml' -o -name '*.txt' -o -name '*.md' -o -name '*.pdf' -o -name '*.pem' -o -name '*.key' -o -name '*.crt' -o -name '*.pub' -o -name '*.sql' -o -name '*.db' -o -name '*.bak' -o -name '*.csv' -o -name '*.zip'"

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------
run "collected"  "date -u '+%Y-%m-%d %H:%M:%S'"

echo "<file-tree>"
echo "output:"
eval "find $SEARCH_PATHS -type f \( $NAMES \) 2>/dev/null | sort" | tree_format
echo "</file-tree>"
echo ""

run "file-stats" "find $SEARCH_PATHS -type f \( $NAMES \) 2>/dev/null | awk -F. '{print \$NF}' | sort | uniq -c | sort -rn | awk '{printf \"  %-10s %s\n\", \$2, \$1}'"