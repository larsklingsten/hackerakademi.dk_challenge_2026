# [ε] root@router:

info collected 2026-02-26 15:06:30

-----------
Identity
-----------
<hostname>
cmd: hostname

output:
router
</hostname>

<whoami>
cmd: whoami

output:
root
</whoami>

<id>
cmd: id

output:
uid=0(root) gid=0(root) groups=0(root)
</id>

<uptime>
cmd: uptime

output:
 15:06:30 up 4 days,  6:09,  2 users,  load average: 0.08, 0.14, 0.16
</uptime>


-----------
OS & Kernel
-----------
<os-release>
cmd: cat /etc/os-release

output:
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.3
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
</os-release>

<uname>
cmd: uname -a

output:
Linux router 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
</uname>


-----------
Processes
-----------
<ps-count>
cmd: ps aux | wc -l

output:
26
</ps-count>

<ps-top10-cpu>
cmd: ps aux --sort=-%cpu | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      136886  100  0.1   6392  3804 pts/1    R+   15:06   0:00 ps aux --sort=-%cpu
root      136853 15.3  0.1   4064  3020 pts/1    S+   15:06   0:00 /bin/bash ./os_info.sh
root      136842  0.4  0.3  19452  7000 ?        S    14:58   0:02 sshd-session: root@pts/1
root      134324  0.3  0.3  19452  7100 ?        S    14:06   0:11 sshd-session: root@pts/2
root      136835  0.0  0.6  19332 12348 ?        Ss   14:58   0:00 sshd-session: root [priv]
root      136843  0.0  0.1   4428  3764 pts/1    Ss   14:58   0:00 -bash
systemd+      48  0.0  0.5  20564 10612 ?        Ss   Feb22   0:24 /usr/lib/systemd/systemd-networkd
root           1  0.0  0.6  23348 13612 ?        Ss   Feb22   0:20 /usr/lib/systemd/systemd
caas          78  0.0  0.7 1748776 15780 ?       Ssl  Feb22   0:16 /opt/caas/caas
root      134317  0.0  0.6  19332 12372 ?        Ss   14:06   0:00 sshd-session: root [priv]
</ps-top10-cpu>

<ps-top10-mem>
cmd: ps aux --sort=-%mem | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
caas          78  0.0  0.7 1748776 15780 ?       Ssl  Feb22   0:16 /opt/caas/caas
root           1  0.0  0.6  23348 13612 ?        Ss   Feb22   0:20 /usr/lib/systemd/systemd
root          18  0.0  0.6  34872 13132 ?        Ss   Feb22   0:04 /usr/lib/systemd/systemd-journald
systemd+      41  0.0  0.6  22532 12524 ?        Ss   Feb22   0:03 /usr/lib/systemd/systemd-resolved
root      134317  0.0  0.6  19332 12372 ?        Ss   14:06   0:00 sshd-session: root [priv]
root      136835  0.0  0.6  19332 12348 ?        Ss   14:58   0:00 sshd-session: root [priv]
root      132728  0.0  0.6  21800 12304 ?        Ss   06:07   0:00 /usr/lib/systemd/systemd --user
systemd+      48  0.0  0.5  20564 10612 ?        Ss   Feb22   0:24 /usr/lib/systemd/systemd-networkd
root          82  0.0  0.4  18648  9036 ?        Ss   Feb22   0:03 /usr/lib/systemd/systemd-logind
root         103  0.0  0.3  11768  7804 ?        Ss   Feb22   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
</ps-top10-mem>

<systemd-units>
cmd: systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30

output:
  UNIT                        LOAD   ACTIVE SUB     DESCRIPTION
  baby-passes-filters.service loaded active running evil
  caas.service                loaded active running Compiler as a Service
  console-getty.service       loaded active running Console Getty
  cron.service                loaded active running Regular background program processing daemon
  dbus.service                loaded active running D-Bus System Message Bus
  ssh.service                 loaded active running OpenBSD Secure Shell server
  systemd-journald.service    loaded active running Journal Service
  systemd-logind.service      loaded active running User Login Management
  systemd-networkd.service    loaded active running Network Configuration
  systemd-resolved.service    loaded active running Network Name Resolution
  user@0.service              loaded active running User Manager for UID 0
Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.
11 loaded units listed.
</systemd-units>


-----------
Network
-----------
<ip-addr 4>
cmd: ip -4 addr | grep "inet "

output:
    inet 127.0.0.1/8 scope host lo
    inet 10.0.67.1/24 brd 10.0.67.255 scope global vb-router0
    inet 10.0.42.1/24 brd 10.0.42.255 scope global vb-router1
    inet 10.0.67.1/24 scope global vxlan
</ip-addr 4>

<ip-addr 6>
cmd: ip -6 addr | grep "inet "

output:
</ip-addr 6>

<ip-route>
cmd: ip route

output:
10.0.42.0/24 dev vb-router1 proto kernel scope link src 10.0.42.1
10.0.67.0/24 dev vxlan proto kernel scope link src 10.0.67.1
192.168.153.0/24 via 10.0.42.1 dev vb-router1
</ip-route>

<ip-neighbors>
cmd: ip neighbor show

output:
10.0.67.110 dev vb-router0 lladdr 06:00:52:f6:f8:ab STALE
10.0.67.199 dev vb-router0 lladdr 2e:1c:30:bd:34:7e STALE
10.0.67.102 dev vb-router0 lladdr fe:83:d4:69:d7:80 STALE
10.0.42.94 dev vb-router1 lladdr 4e:a9:d0:48:af:5d REACHABLE
127.0.0.1 dev vb-router1 FAILED
10.0.67.110 dev vxlan FAILED
192.168.153.241 dev vb-router1 FAILED
127.0.0.1 dev vb-router0 FAILED
127.0.0.1 dev vxlan FAILED
127.0.0.1 dev jeff0 FAILED
192.168.153.240 dev vb-router1 FAILED
fe80::4ca9:d0ff:fe48:af5d dev vb-router1 lladdr 4e:a9:d0:48:af:5d STALE
</ip-neighbors>

<listeners tcp>
cmd: ss -tlnp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      10           0.0.0.0:666       0.0.0.0:*    users:(("baby-passes-fil",pid=133173,fd=4))
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=20))
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=22))
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=12))
LISTEN 0      4096               *:55              *:*    users:(("systemd",pid=1,fd=45))
LISTEN 0      4096               *:22              *:*    users:(("sshd",pid=103,fd=3),("systemd",pid=1,fd=49))
LISTEN 0      4096               *:80              *:*    users:(("caas",pid=78,fd=3))
LISTEN 0      4096            [::]:5355         [::]:*    users:(("systemd-resolve",pid=41,fd=14))
</listeners tcp>

<listeners udp>
cmd: ss -ulnp

output:
State  Recv-Q Send-Q      Local Address:Port Peer Address:PortProcess
UNCONN 0      0                 0.0.0.0:4789      0.0.0.0:*
UNCONN 0      0              127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=21))
UNCONN 0      0           127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=19))
UNCONN 0      0      0.0.0.0%vb-router0:67        0.0.0.0:*    users:(("systemd-network",pid=48,fd=28))
UNCONN 0      0      0.0.0.0%vb-router1:67        0.0.0.0:*    users:(("systemd-network",pid=48,fd=25))
UNCONN 0      0                 0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=11))
UNCONN 0      0                    [::]:5355         [::]:*    users:(("systemd-resolve",pid=41,fd=13))
</listeners udp>

<listens>
cmd: ss -lntp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      10           0.0.0.0:666       0.0.0.0:*    users:(("baby-passes-fil",pid=133173,fd=4))
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=20))
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=22))
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=41,fd=12))
LISTEN 0      4096               *:55              *:*    users:(("systemd",pid=1,fd=45))
LISTEN 0      4096               *:22              *:*    users:(("sshd",pid=103,fd=3),("systemd",pid=1,fd=49))
LISTEN 0      4096               *:80              *:*    users:(("caas",pid=78,fd=3))
LISTEN 0      4096            [::]:5355         [::]:*    users:(("systemd-resolve",pid=41,fd=14))
</listens>

<connections>
cmd: ss -tnp | head -20

output:
State Recv-Q Send-Q      Local Address:Port        Peer Address:Port Process
ESTAB 0      36     [::ffff:10.0.42.1]:22   [::ffff:10.0.42.94]:33762 users:(("sshd-session",pid=136842,fd=7),("sshd-session",pid=136835,fd=7))
ESTAB 0      0      [::ffff:10.0.42.1]:22   [::ffff:10.0.42.94]:39478 users:(("sshd-session",pid=134324,fd=7),("sshd-session",pid=134317,fd=7))
</connections>

<dns>
cmd: cat /etc/resolv.conf

output:
nameserver 127.0.0.53
options edns0 trust-ad
search .
</dns>

<hosts>
cmd: cat /etc/hosts

output:
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
</hosts>


-----------
Users & Auth
-----------
<id>
cmd: id

output:
uid=0(root) gid=0(root) groups=0(root)
</id>

<groups>
cmd: groups

output:
root
</groups>

<members>
cmd: cat /etc/group | grep -v '^#'

output:
root:x:0:
daemon:x:1:
bin:x:2:
sys:x:3:
adm:x:4:
tty:x:5:
disk:x:6:
lp:x:7:
mail:x:8:
news:x:9:
uucp:x:10:
man:x:12:
proxy:x:13:
kmem:x:15:
dialout:x:20:
fax:x:21:
voice:x:22:
cdrom:x:24:
floppy:x:25:
tape:x:26:
sudo:x:27:
audio:x:29:
dip:x:30:
www-data:x:33:
backup:x:34:
operator:x:37:
list:x:38:
irc:x:39:
src:x:40:
shadow:x:42:
utmp:x:43:
video:x:44:
sasl:x:45:
plugdev:x:46:
staff:x:50:
games:x:60:
users:x:100:
nogroup:x:65534:
systemd-journal:x:999:
systemd-network:x:998:
crontab:x:997:
messagebus:x:996:
input:x:995:
sgx:x:994:
clock:x:993:
kvm:x:992:
render:x:991:
systemd-resolve:x:990:
netdev:x:101:
caas:x:989:
_ssh:x:102:
</members>

<passwd>
cmd: cat /etc/passwd | grep -v nologin | grep -v false

output:
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
</passwd>

<sudoers>
cmd: cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'

output:
</sudoers>

<logged-in>
cmd: who

output:
root     sshd pts/1   Feb 26 14:58 (10.0.42.94)
root     sshd pts/2   Feb 26 14:06 (10.0.42.94)
</logged-in>

<last-logins>
cmd: last 2>/dev/null | head -10

output:
</last-logins>


-----------
Security
-----------
<firewall-nft>
cmd: nft list ruleset 2>/dev/null

output:
table inet filter {
	chain input {
		type filter hook input priority filter; policy accept;
	}
	chain forward {
		type filter hook forward priority filter; policy accept;
	}
	chain output {
		type filter hook output priority filter; policy accept;
	}
}
</firewall-nft>

<firewall-ipt>
cmd: iptables -L -n 2>/dev/null

output:
</firewall-ipt>

<selinux>
cmd: sestatus 2>/dev/null || echo 'selinux not present'

output:
selinux not present
</selinux>

<apparmor>
cmd: apparmor_status 2>/dev/null || echo 'apparmor not present'

output:
apparmor not present
</apparmor>


-----------
Docker, virsh, vbox, wmware, qemu, nspawn
-----------
<docker-info>
cmd: docker info 2>/dev/null

output:
</docker-info>

<docker-ps>
cmd: docker ps -a 2>/dev/null

output:
</docker-ps>

<virsh-list>
cmd: virsh list --all 2>/dev/null

output:
</virsh-list>

<virsh-nets>
cmd: virsh net-list --all 2>/dev/null

output:
</virsh-nets>

<vboxmanage>
cmd: VBoxManage list vms 2>/dev/null

output:
</vboxmanage>

<vmware>
cmd: vmrun list 2>/dev/null

output:
</vmware>

<qemu-procs>
cmd: ps aux | grep -E 'qemu|kvm' | grep -v grep 2>/dev/null

output:
</qemu-procs>

<systemd-nspawn>
cmd: machinectl list 2>/dev/null

output:
</systemd-nspawn>


-----------
Hardware
-----------
<cpu>
cmd: lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core|Socket|MHz'

output:
CPU(s):                                  2
On-line CPU(s) list:                     0,1
Model name:                              Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
Thread(s) per core:                      1
Core(s) per socket:                      1
Socket(s):                               2
NUMA node0 CPU(s):                       0,1
</cpu>

<memory>
cmd: free -h

output:
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       844Mi        79Mi       103Mi       1.3Gi       1.1Gi
Swap:             0B          0B          0B
</memory>

<disk>
cmd: df -h

output:
Filesystem        Size  Used Avail Use% Mounted on
overlay           8.7G  4.4G  3.9G  53% /
tmpfs             198M   98M  100M  50% /tmp
tmpfs             4.0M     0  4.0M   0% /sys
tmpfs             4.0M     0  4.0M   0% /dev
tmpfs             198M     0  198M   0% /dev/shm
tmpfs             395M  144K  395M   1% /run
/dev/mapper/disk  8.7G  4.4G  3.9G  53% /run/host/os-release
tmpfs             4.0M     0  4.0M   0% /run/host/unix-export
tmpfs             198M  768K  197M   1% /run/host/incoming
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs             5.0M     0  5.0M   0% /run/lock
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/console-getty.service
tmpfs             198M  4.0K  198M   1% /run/user/0
</disk>

<block-devices>
cmd: lsblk

output:
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0   10G  0 disk
|-vda1 254:1    0    1G  0 part
`-vda2 254:2    0  8.9G  0 part
</block-devices>