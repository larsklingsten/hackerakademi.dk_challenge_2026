# [β] pamela@1ee55c34929d
info collected 2026-02-26 15:27:28

-----------
Identity
-----------
<hostname>
cmd: hostname

output:
1ee55c34929d
</hostname>

<whoami>
cmd: whoami

output:
pamela
</whoami>

<id>
cmd: id

output:
uid=1001(pamela) gid=1001(pamela) groups=1001(pamela),100(users),103(docker),1337(pwpolicy)
</id>

<uptime>
cmd: uptime

output:
 15:27:28 up 4 days,  6:30,  0 users,  load average: 0.37, 0.24, 0.19
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
Linux 1ee55c34929d 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
</uname>


-----------
Processes
-----------
<ps-count>
cmd: ps aux | wc -l

output:
11
</ps-count>

<ps-top10-cpu>
cmd: ps aux --sort=-%cpu | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
pamela       676 11.1  0.0   2676  1868 pts/0    S+   15:27   0:00 sh os_info.sh
pamela       654  1.8  0.3  19860  7340 ?        S    15:26   0:01 sshd-session: pamela@pts/0
pamela       655  0.3  0.2   5916  5408 pts/0    Ss   15:26   0:00 -bash
root         647  0.1  0.6  19752 12636 ?        Ss   15:26   0:00 sshd-session: pamela [priv]
root           1  0.0  0.3  11764  7776 ?        Ss   Feb22   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
pamela       707  0.0  0.0   2676   972 pts/0    S+   15:27   0:00 sh os_info.sh
pamela       708  0.0  0.0   3504  1828 pts/0    S+   15:27   0:00 grep -v ^\s*#
pamela       709  0.0  0.0   3504  1812 pts/0    S+   15:27   0:00 grep -v ^\s*$
pamela       710  0.0  0.1   6392  3704 pts/0    R+   15:27   0:00 ps aux --sort=-%cpu
pamela       711  0.0  0.0   2592  1556 pts/0    S+   15:27   0:00 head -11
</ps-top10-cpu>

<ps-top10-mem>
cmd: ps aux --sort=-%mem | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         647  0.1  0.6  19752 12636 ?        Ss   15:26   0:00 sshd-session: pamela [priv]
root           1  0.0  0.3  11764  7776 ?        Ss   Feb22   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
pamela       654  1.8  0.3  19860  7340 ?        S    15:26   0:01 sshd-session: pamela@pts/0
pamela       655  0.3  0.2   5916  5408 pts/0    Ss   15:26   0:00 -bash
pamela       715  0.0  0.1   6392  3800 pts/0    R+   15:27   0:00 ps aux --sort=-%mem
pamela       676 10.0  0.0   2676  1868 pts/0    S+   15:27   0:00 sh os_info.sh
pamela       713  0.0  0.0   3504  1824 pts/0    S+   15:27   0:00 grep -v ^\s*#
pamela       714  0.0  0.0   3504  1776 pts/0    S+   15:27   0:00 grep -v ^\s*$
pamela       716  0.0  0.0   2592  1572 pts/0    S+   15:27   0:00 head -11
pamela       712  0.0  0.0   2676   972 pts/0    S+   15:27   0:00 sh os_info.sh
</ps-top10-mem>

<systemd-units>
cmd: systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30

output:
os_info.sh: 1: eval: service: not found
</systemd-units>


-----------
Network
-----------
<ip-addr 4>
cmd: ip -4 addr | grep "inet "

output:
    inet 127.0.0.1/8 scope host lo
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
</ip-addr 4>

<ip-addr 6>
cmd: ip -6 addr | grep "inet "

output:
</ip-addr 6>

<ip-route>
cmd: ip route

output:
default via 172.17.0.1 dev eth0
172.17.0.0/16 dev eth0 proto kernel scope link src 172.17.0.2
</ip-route>

<ip-neighbors>
cmd: ip neighbor show

output:
172.17.0.1 dev eth0 lladdr 02:42:d8:cb:22:18 REACHABLE
</ip-neighbors>

<listeners tcp>
cmd: ss -tlnp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*
LISTEN 0      128             [::]:22           [::]:*
</listeners tcp>

<listeners udp>
cmd: ss -ulnp

output:
State Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
</listeners udp>

<listens>
cmd: ss -lntp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*
LISTEN 0      128             [::]:22           [::]:*
</listens>

<connections>
cmd: ss -tnp | head -20

output:
State Recv-Q Send-Q Local Address:Port  Peer Address:Port Process
ESTAB 0      36        172.17.0.2:22   192.168.122.1:53172
</connections>

<dns>
cmd: cat /etc/resolv.conf

output:
nameserver 1.1.1.1
nameserver 192.168.122.1
search .
</dns>

<hosts>
cmd: cat /etc/hosts

output:
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.2	1ee55c34929d
</hosts>


-----------
Users & Auth
-----------
<id>
cmd: id

output:
uid=1001(pamela) gid=1001(pamela) groups=1001(pamela),100(users),103(docker),1337(pwpolicy)
</id>

<groups>
cmd: groups

output:
pamela users docker pwpolicy
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
users:x:100:user,pamela
nogroup:x:65534:
systemd-journal:x:999:
systemd-network:x:998:
systemd-timesync:x:997:
messagebus:x:996:
_ssh:x:101:
user:x:1000:
pamela:x:1001:
docker:x:103:pamela
pwpolicy:x:1337:pamela
</members>

<passwd>
cmd: cat /etc/passwd | grep -v nologin | grep -v false

output:
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
user:x:1000:1000:,,,:/home/user:/bin/bash
pamela:x:1001:1001:,,,:/home/pamela:/bin/bash
</passwd>

<sudoers>
cmd: cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'

output:
</sudoers>

<logged-in>
cmd: who

output:
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
Client:
 Version:    26.1.5+dfsg1
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  0.13.1+ds1
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
Server:
 Containers: 1
  Running: 1
  Paused: 0
  Stopped: 0
 Images: 2
 Server Version: 26.1.5+dfsg1
 Storage Driver: fuse-overlayfs
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 1.7.24~ds1-6+deb13u1
 runc version: 1.1.15+ds1-2+b4
 init version:
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.12.63+deb13-amd64
 Operating System: Debian GNU/Linux 13 (trixie)
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.927GiB
 Name: hostcontainer
 ID: 1041a691-029c-4878-8b18-576501d17aac
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
</docker-info>

<docker-ps>
cmd: docker ps -a 2>/dev/null

output:
CONTAINER ID   IMAGE        COMMAND               CREATED       STATUS      PORTS                               NAMES
1ee55c34929d   ssh-server   "/usr/sbin/sshd -D"   4 weeks ago   Up 4 days   0.0.0.0:22->22/tcp, :::22->22/tcp   ssh-server
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
Mem:           1.9Gi       860Mi        77Mi       103Mi       1.3Gi       1.1Gi
Swap:             0B          0B          0B
</memory>

<disk>
cmd: df -h

output:
Filesystem      Size  Used Avail Use% Mounted on
fuse-overlayfs  8.7G  4.4G  3.9G  53% /
tmpfs            64M     0   64M   0% /dev
shm              64M     0   64M   0% /dev/shm
tmpfs           395M  252K  395M   1% /run/docker.sock
overlay         8.7G  4.4G  3.9G  53% /etc/hosts
tmpfs           987M     0  987M   0% /proc/asound
tmpfs           987M     0  987M   0% /proc/acpi
tmpfs           987M     0  987M   0% /sys/firmware
</disk>

<block-devices>
cmd: lsblk

output:
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0   10G  0 disk
|-vda1 254:1    0    1G  0 part
`-vda2 254:2    0  8.9G  0 part
</block-devices>