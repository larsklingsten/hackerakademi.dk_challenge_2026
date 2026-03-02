# ssh user@192.168.122.39  
[α] user@1ee55c34929d:~$ ls -alh
drwx------ 3 user user 4.0K Jan 28 11:58 .
drwxr-xr-x 4 root root 4.0K Jan 28 11:58 ..
-rw-r--r-- 1 user user  187 Jan 28 11:58 .bash_history
-rw-r--r-- 1 user user  220 Jan 28 11:58 .bash_logout
-rw-r--r-- 1 user user 3.6K Jan 28 11:58 .bashrc
-rw-r--r-- 1 user user  807 Jan 28 11:58 .profile
-rw-r--r-- 1 user user  482 Jan 28 11:58 chat.log
drwxr-xr-x 2 user user 4.0K Jan 28 11:58 hostconf
-rw-r--r-- 1 user user  311 Jan 28 11:58 network.md

## $ cat chat.log
bob: They asked me to look at the bpf service, but I can't access it..
jeff: Are you behind the router?
bob: ...there's a router? What are you talking about?
jeff: You're probably in the wrong part of the network, then.
jeff: Anyway, once you get there, you might need the vxlan vpn thingie I made...
bob: vxlan? I'm not following... can you please explain?
jeff: Yeah, eh, I just gotta get some lunch here..
* jeff has left the chat *
bob: ...damnit jeff
* bob has left the chat *

# $ cat network.md 
# Network diagram
id | subnet           | dhcp        | comments
-- | ---------------- | ----------- | -------------
1  | 192.168.??.??/28 | printserver | wan
41 | 172.17.0.0/24    | docker      | containers
42 | 10.0.42.0/24     | router      | core services
67 | 10.0.67.0/24     | router      | vpn services

## ~/hostconf$ ls
ca.pem  con_ca.cnf  docker.default  makeCert.sh  makeKey.py

## ~/hostconf$ cat docker.default 
DOCKER_OPTS="--tlsverify --tlscacert=/root/.docker/ca.pem --tlscert=/root/.docker/server-cert.pem --tlskey=/root/.docker/server-key.pem -H=0.0.0.0:2376"

## ~$ cat .bash_history 
docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem --tlskey=key.pem -H=172.17.0.1:2376 run --rm -it debian
rm cert.pem key.pem
ssh -p 2222 172.17.0.1
ssh pamela@localhost
su pamela

##  [α] user@1ee55c34929d:/home$ ls
pamela  user

## /home$ cd pamela
-bash: cd: pamela: Permission denied

## ~/hostconf$ cat ca.pem
-----BEGIN CERTIFICATE-----
MIIEODCCAyCgAwIBAgIUUN+7fXWtSUgRy4ZtVmL8yoqZDHgwDQYJKoZIhvcNAQEL
BQAwYTELMAkGA1UEBhMCVUIxEjAQBgNVBAgMCVVTQmtpc3RhbjEVMBMGA1UEBwwM
TG9jYWwgYnJhbmNoMRMwEQYDVQQKDApNb25rRVovRURPMRIwEAYDVQQDDAlsb2Nh
bGhvc3QwHhcNMjYwMTI4MTE1NjI2WhcNMjcwMTI4MTE1NjI2WjBhMQswCQYDVQQG
EwJVQjESMBAGA1UECAwJVVNCa2lzdGFuMRUwEwYDVQQHDAxMb2NhbCBicmFuY2gx
EzARBgNVBAoMCk1vbmtFWi9FRE8xEjAQBgNVBAMMCWxvY2FsaG9zdDCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAK9xy9msBwB8WpO7OEjxnTqVDXHb6H5l
yRt1FAkRYVluJo+WJpNaeiQ4xACQa5vILZOaavC0qc/PR4C8S43y+L699KadKPPw
MVuGPgfWdQ9zkmRKm4iExzNU9wobtvPIcXnDVzAyBYxntpPHwHi7Emw3Q8C7FcSC
DHuI1IvL2YMzrIN1aHN0GNz4FcxLkvhPoAyEIDSTIUMYRpM3CF6RPj+0Ca0ZL9Z+
i28eVY/tyWGj4scjqB1ZWgWPTsDBcT3abfEAZtc9CKMmj13eVt8UeQaUNyUo+gUG
av/oZ1Hnm1T8e9V2mG0XEOJClZo2/+Ccew5mCOS0DVPRlSOKwQl2ZEcCAwEAAaOB
5zCB5DAdBgNVHQ4EFgQUgq/aZs+AZ7zF7r8c2T9E2D3N73QwgZ4GA1UdIwSBljCB
k4AUgq/aZs+AZ7zF7r8c2T9E2D3N73ShZaRjMGExCzAJBgNVBAYTAlVCMRIwEAYD
VQQIDAlVU0JraXN0YW4xFTATBgNVBAcMDExvY2FsIGJyYW5jaDETMBEGA1UECgwK
TW9ua0VaL0VETzESMBAGA1UEAwwJbG9jYWxob3N0ghRQ37t9da1JSBHLhm1WYvzK
ipkMeDASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG
9w0BAQsFAAOCAQEAmdMewq2TZCoX1XGXqWKhO/2CNMb6TXxf2YxkYK0z9cvOqaWN
D+mO1bsVGlydeuUmgFtiSz/RviLSMgVRaU07EkEe5PiL8JqzKZnD28BiVLvy/Phh
s0xERF8FFdJSdMagb0N+h7HsNFRmfWgf5dYnusKmxhmr5aXFV4+dZIOP0RB2OLRT
38btYo04wBHgF8cRUaU2uhy/jr2Nm1u3srzcaDbmJlHvy/STOM39fLXUE7jOm43r
NNKOLetw3JQc96sgXPyGoYL2YOfPorsuHaXFNKJ01o8U7imuDt11bQrUqeyfjq2C
3aG6gt10WQRj07XiI+2os5+LPTON4KVtW+KVvA==
-----END CERTIFICATE-----


## ~/hostconf$ cat con_ca.cnf 
[req]
default_bits = 2048
default_md = sha256
prompt = no
distinguished_name=req_distinguished_name
x509_extensions=v3_ca

[req_distinguished_name]
C = UB
ST = USBkistan
L = Local branch
O = MonkEZ/EDO
CN = localhost

[v3_ca]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer:always
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign