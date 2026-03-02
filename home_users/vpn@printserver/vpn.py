#!/usr/bin/env python3
# vpn@printserver:~$ cat /usr/local/bin/vpn.py
import hashlib
import ipaddress
import os
import signal
import subprocess
import sys
import time

bridge_name = "br0"


def establish_session(vxid, remoteaddr, localaddr):
    ifname = f"vpn-{vxid}"

    subprocess.run(
        f"ip link add {ifname} type vxlan id {vxid} remote {remoteaddr} dstport 4789",
        shell=True,
    )
    subprocess.run(f"ip link set {ifname} master {bridge_name}", shell=True)
    subprocess.run(f"ip l set {ifname} up", shell=True)

    print(
        f"Established vxlan vpn connection {ifname} to {remoteaddr}",
        file=sys.stderr,
    )
    print("", file=sys.stderr)
    print("Run the following commands to connect:", file=sys.stderr)
    print(
        f"$ sudo ip link add vxlan type vxlan id {vxid} remote {localaddr} dstport 4789",
        file=sys.stderr,
    )
    print(
        "$ sudo dhclient vxlan",
        file=sys.stderr,
    )


def destroy_session(vxid, remoteaddr):
    ifname = f"vpn-{vxid}"
    subprocess.run(f"ip l del {ifname}", shell=True)

    print(f"Destroyed connection to {remoteaddr}", file=sys.stderr)


def handle_signal(arg, arg2):
    raise Exception


def main():
    remote, _, local, __ = os.environ["SSH_CONNECTION"].split(" ")
    remoteaddr = ipaddress.ip_address(remote)
    localaddr = ipaddress.ip_address(local)
    vxid = int.from_bytes(hashlib.sha256(str(remoteaddr).encode()).digest()[:2])

    signal.signal(signal.SIGTERM, handle_signal)

    try:
        establish_session(vxid, remoteaddr, localaddr)

        while True:
            time.sleep(1)
    finally:
        destroy_session(vxid, remoteaddr)


if __name__ == "__main__":
    main()