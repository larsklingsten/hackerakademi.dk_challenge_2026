#!/bin/bash

# collect selected file types on selected dirs

# v1.00 2026-02-26

echo "tree_collect_files.sh ran on $(date -u '+%Y-%m-%d %H:%M:%S')"   

run() {
    local tag="$1"
    local cmd="$2"
    echo "<$tag>"
    eval "$cmd" 2>&1 | grep -v '^\s*#' | grep -v '^\s*$' || true
    echo "</${tag}>"
    echo ""
}

# ---------------------------------------------------------------------------
# Search only existing paths
# ---------------------------------------------------------------------------
SEARCH_PATHS=""
for p in /home /root /opt /etc /tmp /srv /var/backups /var/mail /run/host; do
    [ -d "$p" ] && SEARCH_PATHS="$SEARCH_PATHS $p"
done

NAMES="-name '*.js' -o -name '*.go' -o -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.py' -o -name '*.sh' -o -name '*.rb' -o -name '*.php' -o -name '*.pl' -o -name '*.conf' -o -name '*.cfg' -o -name '*.ini' -o -name '*.env' -o -name '*.yaml' -o -name '*.yml' -o -name '*.toml' -o -name '*.json' -o -name '*.xml' -o -name '*.txt' -o -name '*.md' -o -name '*.pdf' -o -name '*.pem' -o -name '*.key' -o -name '*.crt' -o -name '*.pub' -o -name '*.sql' -o -name '*.db' -o -name '*.bak' -o -name '*.csv' -o -name '*.zip'"

TREE_AWK="awk -F/ '{dir=\"\"; for(i=1;i<NF;i++) dir=dir\"/\"\$i; sub(/^\/\//,\"/\",dir); if(dir!=prev_dir){ if(prev_dir!=\"\") print \"\"; print dir\"/\"; prev_dir=dir } print \"  \"\$NF}'"

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------
run "collected"  "date -u '+%Y-%m-%d %H:%M:%S'"
run "file-tree"  "find $SEARCH_PATHS -type f \( $NAMES \) 2>/dev/null | sort | $TREE_AWK"
run "file-stats" "find $SEARCH_PATHS -type f \( $NAMES \) 2>/dev/null | awk -F. '{print \$NF}' | sort | uniq -c | sort -rn | awk '{printf \"  %-10s %s\n\", \$2, \$1}'"
