#!/bin/bash

# Collects Linux system information, each command wrapped in tagged blocks.

# ../fe-2026/scripts_sh/os_info.sh

# v1.04 layout from with .md formatter ```bash
# v1.03 layout from with .md formatter ```text
# v1.02 updated neighbor show with sort
# v1.01 adds boot_id
# v1.00 2026-02-26

run() {
    local tag="$1"
    local cmd="$2"

    echo "### cmd: $cmd"
    echo ""
    echo '```bash '
    eval "$cmd" 2>&1 | grep -v '^\s*#' | grep -v '^\s*$'
    echo '```'
    echo ""
}

echo "# info collected $(date -u '+%Y-%m-%d %H:%M:%S')"   

echo 
echo "# Identity"
run "hostname"       "hostname"
run "boot id"        "cat /proc/sys/kernel/random/boot_id"
run "whoami"         "whoami"
run "id"             "id"
run "uptime"         "uptime"
run "sudo rights"    "sudo -l"

echo 
echo "# OS & Kernel"
run "os-release"     "cat /etc/os-release"
run "uname"          "uname -a"
# run "kernel-modules" "lsmod | head -30"

echo 
echo "# Processes"
run "systemd-units"  "systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30"

echo 
echo "# Network "
run "ip-addr 4"      'ip -4 addr | grep "inet "'
run "ip-addr 6"      'ip -6 addr | grep "inet "'
run "ip-route"       "ip route"
run "ip-neighbors"   "ip neighbor show | sort"
run "listeners tcp"  "ss -tlnp"
run "listeners udp"  "ss -ulnp"
run "listens"        "ss -lntp"
run "connections"    "ss -tnp | head -20"
run "dns"            "cat /etc/resolv.conf"
run "hosts"          "cat /etc/hosts"

echo 
echo "# Users & Auth"
run "id"             "id"
run "groups"         "groups"
run "members"        "cat /etc/group | grep -v '^#'"
run "passwd"         "cat /etc/passwd | grep -v nologin | grep -v false"
run "sudoers"        "cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'"
run "logged-in"      "who"
run "last-logins"    "last 2>/dev/null | head -10"

echo 
echo "# Security"
run "firewall-nft"   "nft list ruleset 2>/dev/null"
run "firewall-ipt"   "iptables -L -n 2>/dev/null"
run "selinux"        "sestatus 2>/dev/null || echo 'selinux not present'"
run "apparmor"       "apparmor_status 2>/dev/null || echo 'apparmor not present'"

echo 
echo "# Docker, virsh, vbox, wmware, qemu, nspawn"
run "docker-info"     "docker info 2>/dev/null"
run "docker-ps"       "docker ps -a 2>/dev/null"
#run "docker-images"   "docker images 2>/dev/null"
#run "docker-networks" "docker network ls 2>/dev/null"
#run "docker-volumes"  "docker volume ls 2>/dev/null"
run "virsh-list"      "virsh list --all 2>/dev/null"
run "virsh-nets"      "virsh net-list --all 2>/dev/null"
run "vboxmanage"      "VBoxManage list vms 2>/dev/null"
run "vmware"          "vmrun list 2>/dev/null"
run "qemu-procs"      "ps aux | grep -E 'qemu|kvm' | grep -v grep 2>/dev/null"
run "systemd-nspawn"  "machinectl list 2>/dev/null"


echo 
echo "# Hardware/various"
run "cpu"            "lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core|Socket|MHz'"
run "memory"         "free -h"
run "disk"           "df -h"
run "block-devices"  "lsblk"
run "ps-count"       "ps aux | wc -l"
run "ps-top10-cpu"   "ps aux --sort=-%cpu | head -11"
run "ps-top10-mem"   "ps aux --sort=-%mem | head -11"


# currently disregarded

# ---------------------------------------------------------------------------
# Interesting Paths
# ---------------------------------------------------------------------------
#run "files root-home"      "ls -la /root/"
#run "files tmp"            "ls -la /tmp/"
# ---------------------------------------------------------------------------

# Files & Permissions
# ---------------------------------------------------------------------------
#run "suid-files"     "find / -perm -4000 -type f 2>/dev/null"
#run "world-writable" "find /etc /usr /bin /sbin -writable -type f 2>/dev/null"
#run "crontabs"       "for u in \$(cut -d: -f1 /etc/passwd); do crontab -l -u \$u 2>/dev/null && echo \"(user: \$u)\"; done"
#run "cron-files"     "ls -la /etc/cron* /var/spool/cron 2>/dev/null"
#run "files proc-net-pkt"   "cat /proc/net/packet"