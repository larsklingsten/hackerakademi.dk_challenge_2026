#!/usr/bin/env python3

# [ε] root@router:~/scripts# cat trigger_baby_passed_filters.py

import socket
import struct
import time

# Target Port 666
# The Raw Packet must pass the BPF and the IHL math.
def send_trigger():
    # AF_PACKET would be more accurate, but SOCK_RAW usually works if padding is right
    s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)

    # 1. 14 Bytes Padding (Ethernet)
    eth_pad = b"\x00" * 12 + b"\x08\x00"

    # 2. IP Header (Start of ip_header_ptr)
    # Byte 0: 0x45 (Version 4, IHL 5) -> (0x45 & 0xf) << 2 = 20 bytes
    ip_head = struct.pack('!BBHHHBBH4s4s', 0x45, 0, 100, 1, 0, 64, 6, 0,
                          socket.inet_aton("127.0.0.1"), socket.inet_aton("127.0.0.1"))

    # 3. TCP Header (Start of abStack_2ee)
    # Byte 12: 0x50 (Data Offset 5) -> (0x50 >> 4) << 2 = 20 bytes
    tcp_head = struct.pack('!HHLLBBHHH', 1234, 666, 0, 0, 0x50, 2, 5840, 0, 0)

    packet = eth_pad + ip_head + tcp_head + b"A"*20
    s.sendto(packet, ("127.0.0.1", 0))
    print("[+] Trigger packet sent.")

# Use 'nc localhost 666' in another terminal first,
# then run this script.
if __name__ == "__main__":
    send_trigger()