
## find ports open ports
nmap -sV -sC -p- 192.168.122.39 # press spacebar to how much of the task is completed

## output
Nmap scan report for 192.168.122.39
Host is up (0.00030s latency).
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
|     Date: Thu, 12 Feb 2026 13:55:06 GMT
|     <!DOCTYPE html>
|     <!--
|     TODO: Check for vulnerabilities before deploying!
|     this "Secure Vault" through our security scanner and uh...
|     let's just say calling it "secure" is doing some HEAVY lifting!
|     This AI-generated masterpiece might have more holes than swiss cheese.
|     counted at least 2 potential vulns before my coffee got cold.
|     sure, ship it to prod on a Friday, what could go wrong?
|     pamela
|     P.S. If you're reading this in a breach report... I TOLD YOU SO 
|     <html lang="en">
|     <head>
|     <meta charset="UTF-8">
|     <meta name="viewport" content="width=device-width, initial-scale=1.0">
|     <title>Vault Login</title>
|     <link rel="stylesheet" href="/style.css">
|     </head>
|     <body>
|     <div class="login-container">
|_    <div class="login-box">
2200/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
2222/tcp open  ssh     OpenSSH 10.0p2 Debian 7 (protocol 2.0)
5355/tcp open  llmnr?
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port80-TCP:V=7.94SVN%I=7%D=2/12%Time=698DDBBB%P=x86_64-pc-linux-gnu%r(G
SF:etRequest,64D,"HTTP/1\.0\x20200\x20OK\r\nContent-Type:\x20text/html;\x2
SF:0charset=utf-8\r\nDate:\x20Thu,\x2012\x20Feb\x202026\x2013:55:06\x20GMT
SF:\r\n\r\n<!DOCTYPE\x20html>\n<!--\n\x20\x20\x20\x20TODO:\x20Check\x20for
SF:\x20vulnerabilities\x20before\x20deploying!\n\n\x20\x20\x20\x20I\x20ran
SF:\x20this\x20\"Secure\x20Vault\"\x20through\x20our\x20security\x20scanne
SF:r\x20and\x20uh\.\.\.\n\x20\x20\x20\x20let's\x20just\x20say\x20calling\x
SF:20it\x20\"secure\"\x20is\x20doing\x20some\x20HEAVY\x20lifting!\n\n\x20\
SF:x20\x20\x20This\x20AI-generated\x20masterpiece\x20might\x20have\x20more
SF:\x20holes\x20than\x20swiss\x20cheese\.\n\x20\x20\x20\x20I\x20counted\x2
SF:0at\x20least\x202\x20potential\x20vulns\x20before\x20my\x20coffee\x20go
SF:t\x20cold\.\n\n\x20\x20\x20\x20But\x20sure,\x20ship\x20it\x20to\x20prod
SF:\x20on\x20a\x20Friday,\x20what\x20could\x20go\x20wrong\?\n\n\x20\x20\x2
SF:0\x20-\x20pamela\n\x20\x20\x20\x20P\.S\.\x20If\x20you're\x20reading\x20
SF:this\x20in\x20a\x20breach\x20report\.\.\.\x20I\x20TOLD\x20YOU\x20SO\x20
SF:\xf0\x9f\x98\xa4\n-->\n<html\x20lang=\"en\">\n<head>\n\x20\x20\x20\x20<
SF:meta\x20charset=\"UTF-8\">\n\x20\x20\x20\x20<meta\x20name=\"viewport\"\
SF:x20content=\"width=device-width,\x20initial-scale=1\.0\">\n\x20\x20\x20
SF:\x20<title>Vault\x20Login</title>\n\x20\x20\x20\x20<link\x20rel=\"style
SF:sheet\"\x20href=\"/style\.css\">\n</head>\n<body>\n\x20\x20\x20\x20<div
SF:\x20class=\"login-container\">\n\x20\x20\x20\x20\x20\x20\x20\x20<div\x2
SF:0class=\"login-box\">\n\x20\x20\x20\x20\x20\x20\x20")%r(HTTPOptions,64D
SF:,"HTTP/1\.0\x20200\x20OK\r\nContent-Type:\x20text/html;\x20charset=utf-
SF:8\r\nDate:\x20Thu,\x2012\x20Feb\x202026\x2013:55:06\x20GMT\r\n\r\n<!DOC
SF:TYPE\x20html>\n<!--\n\x20\x20\x20\x20TODO:\x20Check\x20for\x20vulnerabi
SF:lities\x20before\x20deploying!\n\n\x20\x20\x20\x20I\x20ran\x20this\x20\
SF:"Secure\x20Vault\"\x20through\x20our\x20security\x20scanner\x20and\x20u
SF:h\.\.\.\n\x20\x20\x20\x20let's\x20just\x20say\x20calling\x20it\x20\"sec
SF:ure\"\x20is\x20doing\x20some\x20HEAVY\x20lifting!\n\n\x20\x20\x20\x20Th
SF:is\x20AI-generated\x20masterpiece\x20might\x20have\x20more\x20holes\x20
SF:than\x20swiss\x20cheese\.\n\x20\x20\x20\x20I\x20counted\x20at\x20least\
SF:x202\x20potential\x20vulns\x20before\x20my\x20coffee\x20got\x20cold\.\n
SF:\n\x20\x20\x20\x20But\x20sure,\x20ship\x20it\x20to\x20prod\x20on\x20a\x
SF:20Friday,\x20what\x20could\x20go\x20wrong\?\n\n\x20\x20\x20\x20-\x20pam
SF:ela\n\x20\x20\x20\x20P\.S\.\x20If\x20you're\x20reading\x20this\x20in\x2
SF:0a\x20breach\x20report\.\.\.\x20I\x20TOLD\x20YOU\x20SO\x20\xf0\x9f\x98\
SF:xa4\n-->\n<html\x20lang=\"en\">\n<head>\n\x20\x20\x20\x20<meta\x20chars
SF:et=\"UTF-8\">\n\x20\x20\x20\x20<meta\x20name=\"viewport\"\x20content=\"
SF:width=device-width,\x20initial-scale=1\.0\">\n\x20\x20\x20\x20<title>Va
SF:ult\x20Login</title>\n\x20\x20\x20\x20<link\x20rel=\"stylesheet\"\x20hr
SF:ef=\"/style\.css\">\n</head>\n<body>\n\x20\x20\x20\x20<div\x20class=\"l
SF:ogin-container\">\n\x20\x20\x20\x20\x20\x20\x20\x20<div\x20class=\"logi
SF:n-box\">\n\x20\x20\x20\x20\x20\x20\x20");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 160.26 seconds