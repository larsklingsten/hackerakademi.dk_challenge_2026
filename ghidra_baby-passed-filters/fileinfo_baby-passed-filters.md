# info on the baby-passed-filter (the exe):

## file
```sh
# ┌──(larsk@imac27-deb)-[~/source/hacking/ctf-capture-the-flag/fe-2026]
file baby-passes-filters 
```
output:
    baby-passes-filters: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=8949cd8eaaff4658f2b8923b95e1b18f49834cd1, for GNU/Linux 3.2.0, stripped

## strings
```sh
# ┌──(larsk@imac27-deb)-[~/source/hacking/ctf-capture-the-flag/fe-2026]
strings baby-passes-filter
```
output:
    [...]
    _ITM_registerTMCloneTable
    PTE1
    u+UH
    /bin/sh
    ;*3$"
    [...]


## finding 'PTE1"
- NOT magic code

"Defined","Label","Location","Code Unit","String View","String Type","Length","Is Word" 
"","","001011ad","PUSH RAX","\"PTE1\"","string","4","false"

```h
001011a0 31 ed 49 89 d1 5e 48 89 e2 48 83 e4 f0 50 54 45 
001011b0 31 c0 31 c9 48 8d 3d ce 00 00 00 ff 15 ff 2d 00
```
50 54 45 31 == "PTE1" (last 3 bytes in row 0, and first byte in row 1 )

Comments:
    "PTE1" is not a magic code, but rather opt codes (exe instructions)

    001011ad: 50 54 45 31  -->  PUSH RAX; PUSH RSP; PUSH RBP; XOR EAX, EAX
    
    50 = PUSH RAX
    54 = PUSH RSP
    45 31 c0 = XOR R8D, R8D (The 31 c0 starts on the next line)


## RECV - assembly code

```S

      0010134b 90            NOP

                         LAB_0010134c                              XREF[2]:   0010136b(j), 00101377(j)  
      0010134c 48 8d b5      LEA       RSI=>local_308,[RBP + -0x300]
               00 fd ff 
               ff
      00101353 8b 45 ec      MOV       EAX,dword ptr [RBP + local_1c]
      00101356 b9 40 00      MOV       ECX,0x40
               00 00
      0010135b ba 00 01      MOV       EDX,0x100
               00 00
      00101360 89 c7         MOV       EDI,EAX
      00101362 e8 d9 fc      CALL      <EXTERNAL>::recv                           ssize_t recv(int __fd, void 
               ff ff
      00101367 48 83 f8      CMP       RAX,-0x1
               ff
      0010136b 75 df         JNZ       LAB_0010134c
      0010136d e8 de fc      CALL      <EXTERNAL>::__errno_location               int * __errno_location(void)
               ff ff

```

## setdockopt @main
```c
      iVar2 = setsockopt(local_file_scriptor,1,0x1a,local_108,0x10);    
```
```s
; like too much code included
      00101379 48 8d 95      LEA       RDX=>local_108,[RBP + -0x100]
               00 ff ff 
               ff
      00101380 8b 45 ec      MOV       EAX,dword ptr [RBP + local_file_scriptor]
      00101383 41 b8 10      MOV       R8D,0x10
               00 00 00
      00101389 48 89 d1      MOV       RCX,RDX
      0010138c ba 1a 00      MOV       EDX,0x1a
               00 00
      00101391 be 01 00      MOV       ESI,0x1
               00 00
      00101396 89 c7         MOV       EDI,EAX
      00101398 e8 c3 fc      CALL      <EXTERNAL>::setsockopt                     int setsockopt(int __fd, int
               ff ff
      0010139d 85 c0         TEST      EAX,EAX
      0010139f 78 0c         JS        LAB_001013ad
      001013a1 c7 45 e8      MOV       dword ptr [RBP + local_20],0x0
               00 00 00 
               00
      001013a8 eb 04         JMP       LAB_001013ae
```

## Mem 001040e0
06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 02 00 00 00 02 00 00 00
28 00 00 00 0c 00 00 00 15 00 02 00 00 08 00 00

## Mem 001040e0 'more bytes
06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 02 00 00 00 02 00 00 00
28 00 00 00 0c 00 00 00 15 00 02 00 00 08 00 00
00 00 00 00 01 00 00 00 02 00 00 00 02 00 00 00
30 00 00 00 17 00 00 00 15 00 02 00 06 00 00 00
00 00 00 00 01 00 00 00 02 00 00 00 02 00 00 00
b1 00 00 00 0e 00 00 00 48 00 00 00 10 00 00 00
15 00 02 00 9a 02 00 00 00 00 00 00 01 00 00 00
02 00 00 00 02 00 00 00 50 00 00 00 1a 00 00 00
74 00 00 00 04 00 00 00 64 00 00 00 02 00 00 00
0c 00 00 00 00 00 00 00 04 00 00 00 0e 00 00 00
02 00 00 00 00 00 00 00 61 00 00 00 00 00 00 00

## Magic bpf @main
```c
    local_f0 = &DAT_001040e0;
    local_108[0] = 0x76;
    local_108[1] = 1;
    local_100 = &DAT_00104100;
    local_file_scriptor = fd;
    iVar2 = setsockopt(fd,1,0x1a,local_f8,0x10);
```