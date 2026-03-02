# [ζ] vpn@printserver:~/scripts$ cat os_info.md
info collected 2026-02-26 15:32:29

-----------
Identity
-----------
<hostname>
cmd: hostname

output:
printserver
</hostname>

<whoami>
cmd: whoami

output:
vpn
</whoami>

<id>
cmd: id

output:
uid=1000(vpn) gid=1000(vpn) groups=1000(vpn),100(users),999(systemd-journal)
</id>

<uptime>
cmd: uptime

output:
 15:32:29 up 4 days,  6:35,  3 users,  load average: 0.50, 0.25, 0.20
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
Linux printserver 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
</uname>


-----------
Processes
-----------
<ps-count>
cmd: ps aux | wc -l

output:
237
</ps-count>

<ps-top10-cpu>
cmd: ps aux --sort=-%cpu | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
vpn       149783  100  0.1   6392  3740 pts/2    R+   15:32   0:00 ps aux --sort=-%cpu
root        1246 12.5 12.0 796492 243280 ?       Ssl  Feb22 770:05 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
vpn       149749  6.6  0.0   2676  1820 pts/2    S+   15:32   0:00 sh os_info.sh
root      149717  1.1  0.3  19456  7036 ?        S    15:29   0:02 sshd-session: root@pts/1
root       32589  1.1  0.1  12872  2616 ?        Ssl  Feb23  48:19 saas
root      149729  1.0  0.4  14028  9060 pts/1    S+   15:30   0:01 ssh vpn@printserver -p 2200
vpn       149737  0.6  0.3  19456  7060 ?        S    15:30   0:00 sshd-session: vpn@pts/2
root      145537  0.3  0.4  14032  9140 pts/2    S+   14:06   0:18 ssh router
root      145545  0.2  0.3  19452  7100 ?        S    14:06   0:11 sshd-session: root@pts/2
root      143514  0.1  0.3  19456  6964 ?        S    07:32   0:52 sshd-session: root@pts/2
</ps-top10-cpu>

<ps-top10-mem>
cmd: ps aux --sort=-%mem | head -11

output:
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        1246 12.5 12.0 796492 243280 ?       Ssl  Feb22 770:05 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
root        1587  0.0  4.7 2136684 95848 ?       Ssl  Feb22   4:23 /usr/sbin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --tlsverify --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/server-cert.pem --tlskey=/root/.docker/server-key.pem -H=0.0.0.0:2376
root        1242  0.0  2.9 1014196 59604 ?       Ssl  Feb22   0:08 node server.js
root        1381  0.1  2.5 1872568 51800 ?       Ssl  Feb22   7:29 /usr/bin/containerd
root         388  0.0  1.3  59508 27540 ?        Ss   Feb22   0:05 /usr/lib/systemd/systemd-journald
root        1808  0.0  1.1 2133220 24052 ?       Sl   Feb22   2:15 /usr/bin/containerd-shim-runc-v2 -namespace moby -id 1ee55c34929da315866535e6e8c985816bf58614b79ee398158501ea6727f5e7 -address /run/containerd/containerd.sock
sshd        1243  0.0  0.7 1748776 15812 ?       Ssl  Feb22   0:16 /opt/caas/caas
root           1  0.0  0.7  24060 14640 ?        Ss   Feb22   0:30 /sbin/init
systemd+    1053  0.0  0.6  23312 14060 ?        Ss   Feb22   0:03 /usr/lib/systemd/systemd-resolved
root       32477  0.0  0.6  23176 14000 ?        Ss   Feb23   0:10 /usr/lib/systemd/systemd
</ps-top10-mem>

<systemd-units>
cmd: systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30

output:
  UNIT                                 LOAD   ACTIVE SUB     DESCRIPTION
  cron.service                         loaded active running Regular background program processing daemon
  dbus.service                         loaded active running D-Bus System Message Bus
  getty@tty1.service                   loaded active running Getty on tty1
  serial-getty@ttyS0.service           loaded active running Serial Getty on ttyS0
  ssh.service                          loaded active running OpenBSD Secure Shell server
  systemd-journald.service             loaded active running Journal Service
  systemd-logind.service               loaded active running User Login Management
  systemd-machined.service             loaded active running Virtual Machine and Container Registration Service
  systemd-networkd.service             loaded active running Network Configuration
  systemd-nspawn@hostcontainer.service loaded active running Container hostcontainer
  systemd-nspawn@noted.service         loaded active running Container noted
  systemd-nspawn@router.service        loaded active running Container router
  systemd-nspawn@saas.service          loaded active running Container saas
  systemd-nspawn@wat.service           loaded active running Container wat
  systemd-resolved.service             loaded active running Network Name Resolution
  systemd-udevd.service                loaded active running Rule-based Manager for Device Events and Files
  user@1000.service                    loaded active running User Manager for UID 1000
  vault.service                        loaded active running Vault
Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.
18 loaded units listed.
</systemd-units>


-----------
Network
-----------
<ip-addr 4>
cmd: ip -4 addr | grep "inet "

output:
    inet 127.0.0.1/8 scope host lo
    inet 192.168.122.39/24 metric 1024 brd 192.168.122.255 scope global dynamic enp1s0
    inet 169.254.238.218/16 metric 2048 brd 169.254.255.255 scope link ve-hostcontvoz3
    inet 192.168.153.241/28 brd 192.168.153.255 scope global ve-hostcontvoz3
</ip-addr 4>

<ip-addr 6>
cmd: ip -6 addr | grep "inet "

output:
</ip-addr 6>

<ip-route>
cmd: ip route

output:
default via 192.168.122.1 dev enp1s0 proto dhcp src 192.168.122.39 metric 1024
169.254.0.0/16 dev ve-hostcontvoz3 proto kernel scope link src 169.254.238.218 metric 2048
192.168.122.0/24 dev enp1s0 proto kernel scope link src 192.168.122.39 metric 1024
192.168.122.1 dev enp1s0 proto dhcp scope link src 192.168.122.39 metric 1024
192.168.153.240/28 dev ve-hostcontvoz3 proto kernel scope link src 192.168.153.241
</ip-route>

<ip-neighbors>
cmd: ip neighbor show

output:
192.168.122.1 dev enp1s0 lladdr 52:54:00:71:89:8f REACHABLE
192.168.153.251 dev ve-hostcontvoz3 lladdr 66:86:2e:47:7c:f7 REACHABLE
fe80::4bd:9cff:fecd:dfb8 dev br0 lladdr 06:bd:9c:cd:df:b8 STALE
fe80::2c1c:30ff:febd:347e dev br0 lladdr 2e:1c:30:bd:34:7e STALE
fe80::3cfd:c2ff:fecb:eebf dev br1 lladdr 3e:fd:c2:cb:ee:bf STALE
fe80::6486:2eff:fe47:7cf7 dev ve-hostcontvoz3 lladdr 66:86:2e:47:7c:f7 STALE
fe80::fc83:d4ff:fe69:d780 dev br0 lladdr fe:83:d4:69:d7:80 STALE
fe80::fc54:ff:feed:bf69 dev enp1s0 lladdr fe:54:00:ed:bf:69 STALE
fe80::400:52ff:fef6:f8ab dev br0 lladdr 06:00:52:f6:f8:ab STALE
fe80::4ca9:d0ff:fe48:af5d dev br1 lladdr 4e:a9:d0:48:af:5d STALE
</ip-neighbors>

<listeners tcp>
cmd: ss -tlnp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*
LISTEN 0      128          0.0.0.0:2200      0.0.0.0:*
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*
LISTEN 0      4096               *:80              *:*
LISTEN 0      128             [::]:2200         [::]:*
LISTEN 0      4096            [::]:5355         [::]:*
</listeners tcp>

<listeners udp>
cmd: ss -ulnp

output:
State  Recv-Q Send-Q           Local Address:Port Peer Address:PortProcess
UNCONN 0      0                   127.0.0.54:53        0.0.0.0:*
UNCONN 0      0                127.0.0.53%lo:53        0.0.0.0:*
UNCONN 0      0      0.0.0.0%ve-hostcontvoz3:67        0.0.0.0:*
UNCONN 0      0        192.168.122.39%enp1s0:68        0.0.0.0:*
UNCONN 0      0                      0.0.0.0:5355      0.0.0.0:*
UNCONN 0      0                         [::]:5355         [::]:*
</listeners udp>

<listens>
cmd: ss -lntp

output:
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*
LISTEN 0      128          0.0.0.0:2200      0.0.0.0:*
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*
LISTEN 0      4096               *:80              *:*
LISTEN 0      128             [::]:2200         [::]:*
LISTEN 0      4096            [::]:5355         [::]:*
</listens>

<connections>
cmd: ss -tnp | head -20

output:
State Recv-Q Send-Q   Local Address:Port    Peer Address:Port Process
ESTAB 0      0      192.168.153.241:2200 192.168.153.251:36022
ESTAB 0      0      192.168.153.241:2200 192.168.153.251:52144
ESTAB 0      36     192.168.153.241:2200 192.168.153.251:46520
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
uid=1000(vpn) gid=1000(vpn) groups=1000(vpn),100(users),999(systemd-journal)
</id>

<groups>
cmd: groups

output:
vpn users systemd-journal
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
users:x:100:vpn
nogroup:x:65534:
systemd-journal:x:999:vpn
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
vpn:x:1000:
</members>

<passwd>
cmd: cat /etc/passwd | grep -v nologin | grep -v false

output:
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
vpn:x:1000:1000:,,,:/home/vpn:/bin/bash
</passwd>

<sudoers>
cmd: cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'

output:
</sudoers>

<logged-in>
cmd: who

output:
vpn      sshd pts/2   Feb 26 15:30 (192.168.153.251)
vpn      sshd pts/1   Feb 26 12:33 (192.168.153.251)
vpn      sshd pts/0   Feb 26 12:24 (192.168.153.251)
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
root        1246 12.5 12.0 796492 243280 ?       Ssl  Feb22 770:05 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
</qemu-procs>

<systemd-nspawn>
cmd: machinectl list 2>/dev/null

output:
MACHINE       CLASS     SERVICE        OS     VERSION ADDRESSES
hostcontainer container systemd-nspawn debian 13      192.168.153.251…
noted         container systemd-nspawn debian 13      10.0.67.199…
router        container systemd-nspawn debian 13      10.0.67.1…
saas          container systemd-nspawn debian 13      10.0.67.110…
wat           container systemd-nspawn debian 13      10.0.67.102…
5 machines listed.
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
Mem:           1.9Gi       842Mi        92Mi       103Mi       1.3Gi       1.1Gi
Swap:             0B          0B          0B
</memory>

<disk>
cmd: df -h

output:
Filesystem        Size  Used Avail Use% Mounted on
udev              966M     0  966M   0% /dev
tmpfs             198M  776K  197M   1% /run
/dev/mapper/disk  8.7G  4.4G  3.9G  53% /
tmpfs             987M     0  987M   0% /dev/shm
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs             987M     0  987M   0% /tmp
tmpfs             5.0M     0  5.0M   0% /run/lock
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
/dev/vda1         974M   60M  847M   7% /boot
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/router
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/noted
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/wat
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/hostcontainer
tmpfs             1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/saas
tmpfs             198M  4.0K  198M   1% /run/user/1000
</disk>

<block-devices>
cmd: lsblk

output:
NAME     MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda      254:0    0   10G  0 disk
|-vda1   254:1    0    1G  0 part  /boot
`-vda2   254:2    0  8.9G  0 part
  `-disk 253:0    0  8.9G  0 crypt /
</block-devices>