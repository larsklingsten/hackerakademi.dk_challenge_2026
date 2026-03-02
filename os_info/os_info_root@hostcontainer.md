# [δ] root@hostcontainer:~$

info collected 2026-02-26 15:16:55

-----------
Identity
-----------
<hostname>
cmd: hostname

output:
hostcontainer
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
 15:16:55 up 4 days,  6:19,  5 users,  load average: 0.29, 0.24, 0.19
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
Linux hostcontainer 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
</uname>


-----------
Processes
-----------
<ps-count>
cmd: ps aux | wc -l

output:
43
</ps-count>

<ps-top10-cpu>
cmd: ps aux --sort=-%cpu | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        3120  8.3  0.0   2676  1852 pts/1    S+   15:16   0:00 sh os_info.md
root        3105  0.7  0.3  19456  7184 ?        S    14:58   0:08 sshd-session: root@pts/1
root        3090  0.4  0.4  14032  9140 pts/2    S+   14:06   0:18 ssh router
root        2889  0.1  0.3  19456  6964 ?        S    07:32   0:52 sshd-session: root@pts/2
root         110  0.1  2.5 1872568 51800 ?       Ssl  Feb22   7:28 /usr/bin/containerd
root        2998  0.1  0.4  14028  9356 pts/3    S+   12:24   0:10 ssh vpn@printserver -p 2200
root        2916  0.0  0.3  19456  6924 ?        S    09:29   0:16 sshd-session: root@pts/3
root         122  0.0  4.7 2136684 95764 ?       Ssl  Feb22   4:22 /usr/sbin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --tlsverify --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/server-cert.pem --tlskey=/root/.docker/server-key.pem -H=0.0.0.0:2376
root         325  0.0  1.1 2133220 24052 ?       Sl   Feb22   2:15 /usr/bin/containerd-shim-runc-v2 -namespace moby -id 1ee55c34929da315866535e6e8c985816bf58614b79ee398158501ea6727f5e7 -address /run/containerd/containerd.sock
root        3010  0.0  0.4  14028  9356 pts/4    S+   12:33   0:03 ssh vpn@printserver -p 2200
</ps-top10-cpu>

<ps-top10-mem>
cmd: ps aux --sort=-%mem | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         122  0.0  4.7 2136684 95764 ?       Ssl  Feb22   4:22 /usr/sbin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --tlsverify --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/server-cert.pem --tlskey=/root/.docker/server-key.pem -H=0.0.0.0:2376
root         110  0.1  2.5 1872568 51800 ?       Ssl  Feb22   7:28 /usr/bin/containerd
root         325  0.0  1.1 2133220 24052 ?       Sl   Feb22   2:15 /usr/bin/containerd-shim-runc-v2 -namespace moby -id 1ee55c34929da315866535e6e8c985816bf58614b79ee398158501ea6727f5e7 -address /run/containerd/containerd.sock
root           1  0.0  0.6  23308 13900 ?        Ss   Feb22   0:16 /usr/lib/systemd/systemd
systemd+      45  0.0  0.6  23444 13844 ?        Ss   Feb22   0:04 /usr/lib/systemd/systemd-resolved
root          19  0.0  0.6  34876 13160 ?        Ss   Feb22   0:03 /usr/lib/systemd/systemd-journald
root        2754  0.0  0.6  21868 12344 ?        Ss   06:06   0:00 /usr/lib/systemd/systemd --user
root        3098  0.0  0.6  19332 12336 ?        Ss   14:58   0:00 sshd-session: root [priv]
root        2882  0.0  0.6  19332 12224 ?        Ss   07:32   0:00 sshd-session: root [priv]
root        2909  0.0  0.6  19332 12176 ?        Ss   09:29   0:00 sshd-session: root [priv]
</ps-top10-mem>

<systemd-units>
cmd: systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30

output:
  UNIT                     LOAD   ACTIVE SUB     DESCRIPTION
  console-getty.service    loaded active running Console Getty
  containerd.service       loaded active running containerd container runtime
  cron.service             loaded active running Regular background program processing daemon
  dbus.service             loaded active running D-Bus System Message Bus
  docker.service           loaded active running Docker Application Container Engine
  ssh.service              loaded active running OpenBSD Secure Shell server
  systemd-journald.service loaded active running Journal Service
  systemd-logind.service   loaded active running User Login Management
  systemd-networkd.service loaded active running Network Configuration
  systemd-resolved.service loaded active running Network Name Resolution
  user@0.service           loaded active running User Manager for UID 0
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
    inet 192.168.153.251/28 metric 1024 brd 192.168.153.255 scope global dynamic host0
    inet 10.0.42.94/24 metric 1024 brd 10.0.42.255 scope global dynamic if41
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
</ip-addr 4>

<ip-addr 6>
cmd: ip -6 addr | grep "inet "

output:
</ip-addr 6>

<ip-route>
cmd: ip route

output:
default via 192.168.153.241 dev host0 proto dhcp src 192.168.153.251 metric 1024
10.0.42.0/24 dev if41 proto kernel scope link src 10.0.42.94 metric 1024
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1
192.168.122.1 via 192.168.153.241 dev host0 proto dhcp src 192.168.153.251 metric 1024
192.168.153.240/28 dev host0 proto kernel scope link src 192.168.153.251 metric 1024
192.168.153.241 dev host0 proto dhcp scope link src 192.168.153.251 metric 1024
</ip-route>

<ip-neighbors>
cmd: ip neighbor show

output:
10.0.42.1 dev if41 lladdr 3e:fd:c2:cb:ee:bf STALE
192.168.153.241 dev host0 lladdr c6:fb:f6:82:34:9d REACHABLE
172.17.0.2 dev docker0 lladdr 02:42:ac:11:00:02 STALE
fe80::3cfd:c2ff:fecb:eebf dev if41 lladdr 3e:fd:c2:cb:ee:bf STALE
fe80::c4fb:f6ff:fe82:349d dev host0 lladdr c6:fb:f6:82:34:9d router STALE
</ip-neighbors>

<listeners tcp>
cmd: ss -tlnp

output:
State  Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
LISTEN 0      128          0.0.0.0:2222       0.0.0.0:*    users:(("sshd",pid=102,fd=6))
LISTEN 0      4096         0.0.0.0:5355       0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=12))
LISTEN 0      4096       127.0.0.1:41251      0.0.0.0:*    users:(("containerd",pid=110,fd=9))
LISTEN 0      4096         0.0.0.0:22         0.0.0.0:*    users:(("docker-proxy",pid=302,fd=4))
LISTEN 0      4096   127.0.0.53%lo:53         0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=19))
LISTEN 0      4096      127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=21))
LISTEN 0      4096               *:2376             *:*    users:(("dockerd",pid=122,fd=3))
LISTEN 0      128             [::]:2222          [::]:*    users:(("sshd",pid=102,fd=7))
LISTEN 0      4096            [::]:5355          [::]:*    users:(("systemd-resolve",pid=45,fd=14))
LISTEN 0      4096            [::]:22            [::]:*    users:(("docker-proxy",pid=307,fd=4))
</listeners tcp>

<listeners udp>
cmd: ss -ulnp

output:
State  Recv-Q Send-Q         Local Address:Port Peer Address:PortProcess
UNCONN 0      0                    0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=11))
UNCONN 0      0                 127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=20))
UNCONN 0      0              127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=18))
UNCONN 0      0      192.168.153.251%host0:68        0.0.0.0:*    users:(("systemd-network",pid=52,fd=36))
UNCONN 0      0            10.0.42.94%if41:68        0.0.0.0:*    users:(("systemd-network",pid=52,fd=31))
UNCONN 0      0                       [::]:5355         [::]:*    users:(("systemd-resolve",pid=45,fd=13))
</listeners udp>

<listens>
cmd: ss -lntp

output:
State  Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
LISTEN 0      128          0.0.0.0:2222       0.0.0.0:*    users:(("sshd",pid=102,fd=6))
LISTEN 0      4096         0.0.0.0:5355       0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=12))
LISTEN 0      4096       127.0.0.1:41251      0.0.0.0:*    users:(("containerd",pid=110,fd=9))
LISTEN 0      4096         0.0.0.0:22         0.0.0.0:*    users:(("docker-proxy",pid=302,fd=4))
LISTEN 0      4096   127.0.0.53%lo:53         0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=19))
LISTEN 0      4096      127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=45,fd=21))
LISTEN 0      4096               *:2376             *:*    users:(("dockerd",pid=122,fd=3))
LISTEN 0      128             [::]:2222          [::]:*    users:(("sshd",pid=102,fd=7))
LISTEN 0      4096            [::]:5355          [::]:*    users:(("systemd-resolve",pid=45,fd=14))
LISTEN 0      4096            [::]:22            [::]:*    users:(("docker-proxy",pid=307,fd=4))
</listens>

<connections>
cmd: ss -tnp | head -20

output:
State Recv-Q Send-Q   Local Address:Port     Peer Address:Port Process
ESTAB 0      36     192.168.153.251:2222    192.168.122.1:44842 users:(("sshd-session",pid=3105,fd=7),("sshd-session",pid=3098,fd=7))
ESTAB 0      0      192.168.153.251:2222    192.168.122.1:45672 users:(("sshd-session",pid=2889,fd=7),("sshd-session",pid=2882,fd=7))
ESTAB 0      0      192.168.153.251:52144 192.168.153.241:2200  users:(("ssh",pid=2998,fd=3))
ESTAB 0      0      192.168.153.251:2222    192.168.122.1:54372 users:(("sshd-session",pid=3020,fd=7),("sshd-session",pid=3013,fd=7))
ESTAB 0      0           10.0.42.94:39478       10.0.42.1:22    users:(("ssh",pid=3090,fd=3))
ESTAB 0      0      192.168.153.251:2222    192.168.122.1:33582 users:(("sshd-session",pid=2916,fd=7),("sshd-session",pid=2909,fd=7))
ESTAB 0      0      192.168.153.251:2222    192.168.122.1:52546 users:(("sshd-session",pid=3006,fd=7),("sshd-session",pid=2999,fd=7))
ESTAB 0      0      192.168.153.251:36022 192.168.153.241:2200  users:(("ssh",pid=3010,fd=3))
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
127.0.0.1	hostcontainer
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
users:x:100:user
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
_ssh:x:102:
docker:x:103:
user:x:1000:
</members>

<passwd>
cmd: cat /etc/passwd | grep -v nologin | grep -v false

output:
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
user:x:1000:1000:,,,:/home/user:/bin/bash
</passwd>

<sudoers>
cmd: cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'

output:
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults	use_pty
root	ALL=(ALL:ALL) ALL
%sudo	ALL=(ALL:ALL) ALL
@includedir /etc/sudoers.d
</sudoers>

<logged-in>
cmd: who

output:
root     sshd pts/1   Feb 26 14:58 (192.168.122.1)
root     sshd pts/5   Feb 26 12:46 (192.168.122.1)
root     sshd pts/4   Feb 26 12:33 (192.168.122.1)
root     sshd pts/3   Feb 26 09:29 (192.168.122.1)
root     sshd pts/2   Feb 26 07:32 (192.168.122.1)
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
table ip nat {
	chain DOCKER {
		iifname "docker0" counter packets 0 bytes 0 return
		iifname != "docker0" tcp dport 22 counter packets 35 bytes 2020 dnat to 172.17.0.2:22
	}
	chain POSTROUTING {
		type nat hook postrouting priority srcnat; policy accept;
		ip saddr 172.17.0.0/16 oifname != "docker0" counter packets 2 bytes 116 masquerade
		ip saddr 172.17.0.2 ip daddr 172.17.0.2 tcp dport 22 counter packets 0 bytes 0 masquerade
	}
	chain PREROUTING {
		type nat hook prerouting priority dstnat; policy accept;
		fib daddr type local counter packets 493 bytes 106154 jump DOCKER
	}
	chain OUTPUT {
		type nat hook output priority dstnat; policy accept;
		ip daddr != 127.0.0.0/8 fib daddr type local counter packets 10 bytes 440 jump DOCKER
	}
}
table ip filter {
	chain DOCKER {
		ip daddr 172.17.0.2 iifname != "docker0" oifname "docker0" tcp dport 22 counter packets 31 bytes 1844 accept
	}
	chain DOCKER-ISOLATION-STAGE-1 {
		iifname "docker0" oifname != "docker0" counter packets 6839 bytes 696578 jump DOCKER-ISOLATION-STAGE-2
		counter packets 13787 bytes 1383252 return
	}
	chain DOCKER-ISOLATION-STAGE-2 {
		oifname "docker0" counter packets 0 bytes 0 drop
		counter packets 6839 bytes 696578 return
	}
	chain FORWARD {
		type filter hook forward priority filter; policy drop;
		counter packets 13787 bytes 1383252 jump DOCKER-USER
		counter packets 13787 bytes 1383252 jump DOCKER-ISOLATION-STAGE-1
		oifname "docker0" ct state related,established counter packets 6917 bytes 684830 accept
		oifname "docker0" counter packets 31 bytes 1844 jump DOCKER
		iifname "docker0" oifname != "docker0" counter packets 6839 bytes 696578 accept
		iifname "docker0" oifname "docker0" counter packets 0 bytes 0 accept
	}
	chain DOCKER-USER {
		counter packets 13787 bytes 1383252 return
	}
}
</firewall-nft>

<firewall-ipt>
cmd: iptables -L -n 2>/dev/null

output:
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy DROP)
target     prot opt source               destination
DOCKER-USER  all  --  0.0.0.0/0            0.0.0.0/0
DOCKER-ISOLATION-STAGE-1  all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
DOCKER     all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     all  --  0.0.0.0/0            0.0.0.0/0
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
Chain DOCKER (1 references)
target     prot opt source               destination
ACCEPT     tcp  --  0.0.0.0/0            172.17.0.2           tcp dpt:22
Chain DOCKER-ISOLATION-STAGE-1 (1 references)
target     prot opt source               destination
DOCKER-ISOLATION-STAGE-2  all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
Chain DOCKER-ISOLATION-STAGE-2 (1 references)
target     prot opt source               destination
DROP       all  --  0.0.0.0/0            0.0.0.0/0
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
Chain DOCKER-USER (1 references)
target     prot opt source               destination
RETURN     all  --  0.0.0.0/0            0.0.0.0/0
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
Mem:           1.9Gi       848Mi       141Mi       103Mi       1.2Gi       1.1Gi
Swap:             0B          0B          0B
</memory>

<disk>
cmd: df -h

output:
Filesystem        Size  Used Avail Use% Mounted on
overlay           8.7G  4.4G  3.9G  53% /
tmpfs             198M     0  198M   0% /tmp
tmpfs             4.0M     0  4.0M   0% /sys
tmpfs             4.0M     0  4.0M   0% /dev
tmpfs             198M     0  198M   0% /dev/shm
tmpfs             395M  260K  395M   1% /run
/dev/mapper/disk  8.7G  4.4G  3.9G  53% /run/host/os-release
tmpfs             4.0M     0  4.0M   0% /run/host/unix-export
tmpfs             198M  768K  197M   1% /run/host/incoming
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs             5.0M     0  5.0M   0% /run/lock
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/console-getty.service
fuse-overlayfs    8.7G  4.4G  3.9G  53% /var/lib/docker/fuse-overlayfs/c5279ceda6d88bb635c18b95c997b583078aa7458fa8e20239cace6915f55098/merged
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
