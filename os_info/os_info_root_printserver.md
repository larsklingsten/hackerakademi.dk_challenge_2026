# info collected 2026-02-27 14:33:57

# Identity
### cmd: hostname

```bash 
printserver
```

### cmd: cat /proc/sys/kernel/random/boot_id

```bash 
a67ecae4-a87a-4689-8d59-03bd5c8dcc3b
```

### cmd: whoami

```bash 
root
```

### cmd: id

```bash 
uid=0(root) gid=0(root) groups=0(root)
```

### cmd: uptime

```bash 
 14:33:57 up 5 days,  5:36,  3 users,  load average: 0.21, 0.23, 0.18
```

### cmd: sudo -l

```bash 
Matching Defaults entries for root on printserver:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin, use_pty
User root may run the following commands on printserver:
    (ALL : ALL) ALL
```


# OS & Kernel
### cmd: cat /etc/os-release

```bash 
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
```

### cmd: uname -a

```bash 
Linux printserver 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
```


# Processes
### cmd: systemctl list-units --type=service --state=running 2>/dev/null || service --status-all 2>&1 | head -30

```bash 
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
  user@0.service                       loaded active running User Manager for UID 0
  user@1000.service                    loaded active running User Manager for UID 1000
  vault.service                        loaded active running Vault
Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.
19 loaded units listed.
```


# Network 
### cmd: ip -4 addr | grep "inet "

```bash 
    inet 127.0.0.1/8 scope host lo
    inet 192.168.122.39/24 metric 1024 brd 192.168.122.255 scope global dynamic enp1s0
    inet 169.254.238.218/16 metric 2048 brd 169.254.255.255 scope link ve-hostcontvoz3
    inet 192.168.153.241/28 brd 192.168.153.255 scope global ve-hostcontvoz3
```

### cmd: ip -6 addr | grep "inet "

```bash 
```

### cmd: ip route

```bash 
default via 192.168.122.1 dev enp1s0 proto dhcp src 192.168.122.39 metric 1024 
169.254.0.0/16 dev ve-hostcontvoz3 proto kernel scope link src 169.254.238.218 metric 2048 
192.168.122.0/24 dev enp1s0 proto kernel scope link src 192.168.122.39 metric 1024 
192.168.122.1 dev enp1s0 proto dhcp scope link src 192.168.122.39 metric 1024 
192.168.153.240/28 dev ve-hostcontvoz3 proto kernel scope link src 192.168.153.241 
```

### cmd: ip neighbor show | sort

```bash 
192.168.122.1 dev enp1s0 lladdr 52:54:00:71:89:8f REACHABLE 
192.168.153.251 dev ve-hostcontvoz3 lladdr 66:86:2e:47:7c:f7 STALE 
fe80::2c1c:30ff:febd:347e dev br0 lladdr 2e:1c:30:bd:34:7e STALE 
fe80::3cfd:c2ff:fecb:eebf dev br1 lladdr 3e:fd:c2:cb:ee:bf STALE 
fe80::400:52ff:fef6:f8ab dev br0 lladdr 06:00:52:f6:f8:ab STALE 
fe80::4bd:9cff:fecd:dfb8 dev br0 lladdr 06:bd:9c:cd:df:b8 STALE 
fe80::4ca9:d0ff:fe48:af5d dev br1 lladdr 4e:a9:d0:48:af:5d STALE 
fe80::6486:2eff:fe47:7cf7 dev ve-hostcontvoz3 lladdr 66:86:2e:47:7c:f7 STALE 
fe80::fc54:ff:feed:bf69 dev enp1s0 lladdr fe:54:00:ed:bf:69 STALE 
fe80::fc83:d4ff:fe69:d780 dev br0 lladdr fe:83:d4:69:d7:80 STALE 
```

### cmd: ss -tlnp

```bash 
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                                   
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=19))
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=21))
LISTEN 0      128          0.0.0.0:2200      0.0.0.0:*    users:(("sshd",pid=744,fd=6))            
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=12))
LISTEN 0      4096               *:80              *:*    users:(("vault",pid=701,fd=5))           
LISTEN 0      128             [::]:2200         [::]:*    users:(("sshd",pid=744,fd=7))            
LISTEN 0      4096            [::]:5355         [::]:*    users:(("systemd-resolve",pid=438,fd=14))
```

### cmd: ss -ulnp

```bash 
State  Recv-Q Send-Q           Local Address:Port Peer Address:PortProcess                                   
UNCONN 0      0                   127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=20))
UNCONN 0      0                127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=18))
UNCONN 0      0      0.0.0.0%ve-hostcontvoz3:67        0.0.0.0:*    users:(("systemd-network",pid=449,fd=43))
UNCONN 0      0        192.168.122.39%enp1s0:68        0.0.0.0:*    users:(("systemd-network",pid=449,fd=33))
UNCONN 0      0                      0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=11))
UNCONN 0      0                         [::]:5355         [::]:*    users:(("systemd-resolve",pid=438,fd=13))
```

### cmd: ss -lntp

```bash 
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                                   
LISTEN 0      4096   127.0.0.53%lo:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=19))
LISTEN 0      4096      127.0.0.54:53        0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=21))
LISTEN 0      128          0.0.0.0:2200      0.0.0.0:*    users:(("sshd",pid=744,fd=6))            
LISTEN 0      4096         0.0.0.0:5355      0.0.0.0:*    users:(("systemd-resolve",pid=438,fd=12))
LISTEN 0      4096               *:80              *:*    users:(("vault",pid=701,fd=5))           
LISTEN 0      128             [::]:2200         [::]:*    users:(("sshd",pid=744,fd=7))            
LISTEN 0      4096            [::]:5355         [::]:*    users:(("systemd-resolve",pid=438,fd=14))
```

### cmd: ss -tnp | head -20

```bash 
State Recv-Q Send-Q   Local Address:Port    Peer Address:Port Process                                                                   
ESTAB 0      0       192.168.122.39:2200   192.168.122.1:37060 users:(("sshd-session",pid=162888,fd=7),("sshd-session",pid=162867,fd=7))
ESTAB 0      0      192.168.153.241:2200 192.168.153.251:38438 users:(("sshd-session",pid=156106,fd=7),("sshd-session",pid=156099,fd=7))
ESTAB 0      0      192.168.153.241:2200 192.168.153.251:38030 users:(("sshd-session",pid=152397,fd=7),("sshd-session",pid=152375,fd=7))
```

### cmd: cat /etc/resolv.conf

```bash 
nameserver 127.0.0.53
options edns0 trust-ad
search .
```

### cmd: cat /etc/hosts

```bash 
127.0.0.1	localhost
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
```


# Users & Auth
### cmd: id

```bash 
uid=0(root) gid=0(root) groups=0(root)
```

### cmd: groups

```bash 
root
```

### cmd: cat /etc/group | grep -v '^#'

```bash 
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
```

### cmd: cat /etc/passwd | grep -v nologin | grep -v false

```bash 
root:x:0:0:root:/root:/bin/bash
sync:x:4:65534:sync:/bin:/bin/sync
vpn:x:1000:1000:,,,:/home/vpn:/bin/bash
```

### cmd: cat /etc/sudoers 2>/dev/null | grep -v '^#' | grep -v '^$'

```bash 
Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults	use_pty
root	ALL=(ALL:ALL) ALL
%sudo	ALL=(ALL:ALL) ALL
@includedir /etc/sudoers.d
```

### cmd: who

```bash 
root     sshd         Feb 27 14:33 (192.168.122.1)
vpn      sshd pts/2   Feb 27 10:42 (192.168.153.251)
vpn      sshd pts/0   Feb 27 08:30 (192.168.153.251)
```

### cmd: last 2>/dev/null | head -10

```bash 
```


# Security
### cmd: nft list ruleset 2>/dev/null

```bash 
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
table ip io.systemd.nat {
	set masq_saddr {
		type ipv4_addr
		flags interval
		elements = { 192.168.153.240/28 }
	}
	map map_port_ipport {
		type inet_proto . inet_service : ipv4_addr . inet_service
		elements = { tcp . 22 : 192.168.153.251 . 22,
			     tcp . 2222 : 192.168.153.251 . 2222 }
	}
	chain prerouting {
		type nat hook prerouting priority dstnat + 1; policy accept;
		fib daddr type local dnat ip to meta l4proto . th dport map @map_port_ipport
	}
	chain output {
		type nat hook output priority dstnat + 1; policy accept;
		ip daddr != 127.0.0.0/8 oif "lo" dnat ip to meta l4proto . th dport map @map_port_ipport
	}
	chain postrouting {
		type nat hook postrouting priority srcnat + 1; policy accept;
		ip saddr @masq_saddr masquerade
	}
}
table ip6 io.systemd.nat {
	set masq_saddr {
		type ipv6_addr
		flags interval
	}
	map map_port_ipport {
		type inet_proto . inet_service : ipv6_addr . inet_service
	}
	chain prerouting {
		type nat hook prerouting priority dstnat + 1; policy accept;
		fib daddr type local dnat ip6 to meta l4proto . th dport map @map_port_ipport
	}
	chain output {
		type nat hook output priority dstnat + 1; policy accept;
		ip6 daddr != ::1 oif "lo" dnat ip6 to meta l4proto . th dport map @map_port_ipport
	}
	chain postrouting {
		type nat hook postrouting priority srcnat + 1; policy accept;
		ip6 saddr @masq_saddr masquerade
	}
}
```

### cmd: iptables -L -n 2>/dev/null

```bash 
```

### cmd: sestatus 2>/dev/null || echo 'selinux not present'

```bash 
selinux not present
```

### cmd: apparmor_status 2>/dev/null || echo 'apparmor not present'

```bash 
apparmor module is loaded.
102 profiles are loaded.
3 profiles are in enforce mode.
   lsb_release
   nvidia_modprobe
   nvidia_modprobe//kmod
23 profiles are in complain mode.
   Xorg
   plasmashell
   plasmashell//QtWebEngineProcess
   sbuild
   sbuild-abort
   sbuild-adduser
   sbuild-apt
   sbuild-checkpackages
   sbuild-clean
   sbuild-createchroot
   sbuild-destroychroot
   sbuild-distupgrade
   sbuild-hold
   sbuild-shell
   sbuild-unhold
   sbuild-update
   sbuild-upgrade
   transmission-cli
   transmission-daemon
   transmission-gtk
   transmission-qt
   unix-chkpwd
   unprivileged_userns
0 profiles are in prompt mode.
0 profiles are in kill mode.
76 profiles are in unconfined mode.
   1password
   Discord
   MongoDB Compass
   QtWebEngineProcess
   balena-etcher
   brave
   buildah
   busybox
   cam
   ch-checkns
   ch-run
   chrome
   chromium
   crun
   devhelp
   element-desktop
   epiphany
   evolution
   firefox
   flatpak
   foliate
   geary
   github-desktop
   goldendict
   ipa_verify
   kchmviewer
   keybase
   lc-compliance
   libcamerify
   linux-sandbox
   loupe
   lxc-attach
   lxc-create
   lxc-destroy
   lxc-execute
   lxc-stop
   lxc-unshare
   lxc-usernsexec
   mmdebstrap
   msedge
   nautilus
   notepadqq
   obsidian
   opam
   opera
   pageedit
   polypane
   privacybrowser
   qcam
   qmapshack
   qutebrowser
   rootlesskit
   rpm
   rssguard
   runc
   scide
   signal-desktop
   slack
   slirp4netns
   steam
   stress-ng
   surfshark
   systemd-coredump
   toybox
   trinity
   tup
   tuxedo-control-center
   userbindmount
   uwsgi-core
   vdens
   virtiofsd
   vivaldi-bin
   vpnns
   vscode
   wike
   wpcom
1 processes have profiles defined.
0 processes are in enforce mode.
0 processes are in complain mode.
0 processes are in prompt mode.
0 processes are in kill mode.
1 processes are unconfined but have a profile defined.
   /usr/sbin/sshd (1830) runc
0 processes are in mixed mode.
```


# Docker, virsh, vbox, wmware, qemu, nspawn
### cmd: docker info 2>/dev/null

```bash 
```

### cmd: docker ps -a 2>/dev/null

```bash 
```

### cmd: virsh list --all 2>/dev/null

```bash 
```

### cmd: virsh net-list --all 2>/dev/null

```bash 
```

### cmd: VBoxManage list vms 2>/dev/null

```bash 
```

### cmd: vmrun list 2>/dev/null

```bash 
```

### cmd: ps aux | grep -E 'qemu|kvm' | grep -v grep 2>/dev/null

```bash 
root        1246 12.5 12.0 796492 243068 ?       Ssl  Feb22 942:15 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
```

### cmd: machinectl list 2>/dev/null

```bash 
MACHINE       CLASS     SERVICE        OS     VERSION ADDRESSES
hostcontainer container systemd-nspawn debian 13      192.168.153.251…
noted         container systemd-nspawn debian 13      10.0.67.199…
router        container systemd-nspawn debian 13      10.0.67.1…
saas          container systemd-nspawn debian 13      10.0.67.110…
wat           container systemd-nspawn debian 13      10.0.67.102…
5 machines listed.
```


# Hardware/various
### cmd: lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core|Socket|MHz'

```bash 
CPU(s):                                  2
On-line CPU(s) list:                     0,1
Model name:                              Intel(R) Core(TM) i5-3427U CPU @ 1.80GHz
Thread(s) per core:                      1
Core(s) per socket:                      1
Socket(s):                               2
NUMA node0 CPU(s):                       0,1
```

### cmd: free -h

```bash 
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       842Mi        95Mi       103Mi       1.3Gi       1.1Gi
Swap:             0B          0B          0B
```

### cmd: df -h

```bash 
Filesystem        Size  Used Avail Use% Mounted on
udev              966M     0  966M   0% /dev
tmpfs             198M  788K  197M   1% /run
/dev/mapper/disk  8.7G  4.4G  3.9G  53% /
tmpfs             987M     0  987M   0% /dev/shm
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs             987M  152K  987M   1% /tmp
tmpfs             5.0M     0  5.0M   0% /run/lock
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
/dev/vda1         974M   60M  847M   7% /boot
overlay           8.7G  4.4G  3.9G  53% /var/lib/machines/hostcontainer
overlay           8.7G  4.4G  3.9G  53% /var/lib/machines/router
overlay           8.7G  4.4G  3.9G  53% /var/lib/machines/wat
overlay           8.7G  4.4G  3.9G  53% /var/lib/machines/saas
overlay           8.7G  4.4G  3.9G  53% /var/lib/machines/noted
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/router
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/noted
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/wat
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/hostcontainer
tmpfs             1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs             1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
tmpfs             198M  4.0K  198M   1% /run/user/1000
tmpfs             4.0M     0  4.0M   0% /run/systemd/nspawn/unix-export/saas
tmpfs             198M  4.0K  198M   1% /run/user/0
```

### cmd: lsblk

```bash 
NAME     MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINTS
vda      254:0    0   10G  0 disk  
|-vda1   254:1    0    1G  0 part  /boot
`-vda2   254:2    0  8.9G  0 part  
  `-disk 253:0    0  8.9G  0 crypt /
```

### cmd: ps aux | wc -l

```bash 
237
```

### cmd: ps aux --sort=-%cpu | head -11

```bash 
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      163101  100  0.1   6392  3788 ?        R    14:33   0:00 ps aux --sort=-%cpu
root      162872 22.4  0.6  22020 12444 ?        Ss   14:33   0:00 /usr/lib/systemd/systemd --user
root        1246 12.5 12.0 796492 243068 ?       Ssl  Feb22 942:15 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
root      162889 12.2  0.1   4064  2992 ?        Ss   14:33   0:00 bash -s
root      162867  3.6  0.5  19196 11120 ?        Ss   14:33   0:00 sshd-session: root [priv]
root      162888  1.8  0.3  19452  7092 ?        S    14:33   0:00 sshd-session: root@notty
root      156858  1.1  0.1  12872  2720 ?        Ssl  12:09   1:37 saas
root      152374  0.2  0.4  14028  9172 ?        S+   08:30   0:44 ssh vpn@printserver -p 2200
root      155745  0.1  0.4  14032  9180 ?        S+   09:24   0:34 ssh router
vpn       152397  0.1  0.3  19488  7080 ?        S    08:30   0:27 sshd-session: vpn@pts/0
```

### cmd: ps aux --sort=-%mem | head -11

```bash 
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root        1246 12.5 12.0 796492 243068 ?       Ssl  Feb22 942:15 /usr/bin/qemu-system-mipsel -M malta -kernel /services/noted/vmlinux -drive file=/services/noted/rootfs.squashfs,if=ide,format=raw -append rootwait root=/dev/sda -nic user,model=pcnet,hostfwd=tcp::7000-:7000 -virtfs local,path=/root,security_model=mapped-xattr,mount_tag=hostfs -nographic
root        1587  0.0  4.7 2136684 95904 ?       Ssl  Feb22   5:22 /usr/sbin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock --tlsverify --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/server-cert.pem --tlskey=/root/.docker/server-key.pem -H=0.0.0.0:2376
root        1242  0.0  2.9 1014196 59264 ?       Ssl  Feb22   0:10 node server.js
root        1381  0.1  2.5 1872568 51348 ?       Ssl  Feb22   9:11 /usr/bin/containerd
root         388  0.0  1.7  67700 34912 ?        Ss   Feb22   0:08 /usr/lib/systemd/systemd-journald
root        1808  0.0  1.1 2133220 24084 ?       Sl   Feb22   2:45 /usr/bin/containerd-shim-runc-v2 -namespace moby -id 1ee55c34929da315866535e6e8c985816bf58614b79ee398158501ea6727f5e7 -address /run/containerd/containerd.sock
sshd        1243  0.0  0.7 1748776 15792 ?       Ssl  Feb22   0:19 /opt/caas/caas
root           1  0.0  0.7  24060 14688 ?        Ss   Feb22   0:39 /sbin/init
root         821  0.0  0.6  23308 13900 ?        Ss   Feb22   0:20 /usr/lib/systemd/systemd
systemd+    1053  0.0  0.6  23312 13756 ?        Ss   Feb22   0:04 /usr/lib/systemd/systemd-resolved
```

