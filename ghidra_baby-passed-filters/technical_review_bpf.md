# Technical Analysis: baby-passes-filters
- https://gemini.google.com/app/12f2de043e1756ae

- /home/larsk/source/hacking/fe-2026/ghidra_baby-passed-filters
- - fileinfo_baby-passed-filters.md
- - main-service_FUN_00101289.md
- - mem_00104e0-trigger_data.md

This document summarizes the reverse-engineered mechanics of the baby-passes-filters binary. It identifies the multi-stage socket handling, the BPF trigger requirements, and the specific process-logic "traps" that prevent standard shell execution.

## 1. Process Architecture & Execution Logic
The binary functions as a stealthy backdoor that monitors raw network traffic while maintaining a standard TCP listener.

The Double-Fork (Daemonization)

Upon a successful trigger, the binary implements a double fork() pattern to detach the shell from the service parent.

```c
local_54 = fork();
if (local_54 == 0) {
    local_54 = fork();
    if (local_54 != 0) {
        exit(0); // First child exits, grandchild is orphaned to init (PID 1)
    }
    // Grandchild proceeds to shell handoff
}
```

## The "Drain" Loop Trap

The grandchild process intentionally clears the socket buffer before executing the shell. Any data (commands) sent during or immediately after the trigger packet is discarded.

```c
do {
    // Read and discard data to clear the buffer
    sVar3 = read(*local_48, local_buffer, 0x200);
} while (0 < sVar3);

// Handoff to shell occurs only AFTER the buffer is empty
execve(local_c8, &local_c8, (char **)0x0); // local_c8 = "/bin/sh"
```

## 2. Networking & BPF Implementation
The binary utilizes a raw AF_PACKET socket to bypass the standard TCP stack for its trigger mechanism.

Socket Configuration

Type: socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL))

Filter Attachment: Uses setsockopt with SO_ATTACH_FILTER (0x1a).

Two-Stage Activation

The service does not activate the main exploit filter immediately. It follows a state-machine approach:

Stage 1: Attaches a minimal filter and enters a recv loop.

The Blocking Loop: It executes while (*piVar4 != 0xb) (waiting for EAGAIN). The program will not proceed to the main filter until this loop is "kicked" by a socket flush.

Stage 2: Attaches the 118-instruction BPF located at DAT_00104100.

3. BPF Bytecode Analysis
The 118-instruction filter performs Deep Packet Inspection (DPI) starting from the Link Layer (Ethernet).

Header Validation (Hex Representation)

Memory at 001040e0 reveals the initial packet validation:

```Plaintext
28 00 00 00 0c 00 00 00   ; LDH [12] - Load EtherType from Ethernet Header
15 00 02 00 00 08 00 00   ; JEQ 0x0800 - Verify packet is IPv4
The "PTE1" Constant
```
The binary contains the string PTE1 (50 54 45 31). This is verified by the BPF filter at a specific offset within the TCP payload.

```s

Code snippet
50    PUSH RAX
54    PUSH RSP
45 31 XOR R8D, R8D
```
As Trigger: The filter expects these 4 bytes to appear after the IP and TCP headers are parsed.

## 4. Interaction Requirements Summary
To successfully interact with this service, an external actor must:

- Establish TCP Stream: Connect to Port 666 to be added to the internal tracking linked-list (DAT_00104cb8).

- Flush State: Send initial data to break the recv loop and trigger the attachment of the 118-instruction filter.

- Synchronized Trigger: Send a raw Ethernet frame (including valid IP/TCP headers) containing the PTE1 magic bytes.

- Timing Window: Wait for the grandchild to finish the read() drain loop (approx. 1-2 seconds) before sending shell commands.