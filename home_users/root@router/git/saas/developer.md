# Synthesizer as a Service - Developer documentation

This guide is made for a Debian 13 system.

## Running the program locally

Packages needed to start making music.

```sh
apt install vmpk ffmpeg socat libasound2 alsa-utils
```

Start the synthesizer.

```sh
sudo ./saas
```

Open a new shell, and confirm you have a new MIDI device.

```sh
$ aconnect -l
...
client 128: 'SaaS client' [type=user,pid=1652]
    0 'SaaS port       '
```

Listen for music on your local network.

```sh
socat UDP-LISTEN:1295,broadcast,bind=192.168.??.255 - | ffplay -f f64le -fflags nobuffer -ar 192000 -
```

Start VMPK or use your favourite MIDI keyboard.

```sh
vmpk
```

In VMPK, you can connect to the synth by selecting the menu Edit -> MIDI Connections.
Specify MIDI OUT Driver -> ALSA and Output MIDI Connecton -> SaaS client.

If all is in order, you should start hearing music when pressing the piano keys.

## Interacting with the program remotely

Make sure that you have setup the vxlan vpn, and have received an address in the `10.0.67.0/24` network.

You will need to install rtpmidid to send your MIDI commands over the network.

```sh
apt install avahi-daemon ./rtpmidid_24.12.2_amd64.deb
```

Verify that it's working.

```sh
$ aconnect -l
client 129: 'rtpmidid' [type=user,pid=9435]
    0 'Network Export  '
        Connecting To: 14:0
        Connected From: 14:0
    2 'saas            '
    3 'SaaS client-SaaS port'
```

You can connect your keyboard like before, or use `aconnect sender receiver`.
Listen on the vxlan broadcast ip.

```sh
socat UDP-LISTEN:1295,broadcast,bind=10.0.67.255 - | ffplay -f f64le -fflags nobuffer -ar 192000 -
```

## Building

To build the software yourself, you'll need some packages.

```sh
apt install build-essential libasound2-dev
make
```

## Scripting

One way to interact with the synthesizer programmatically is with python.

```sh
apt install python3-rtmidi
```

This script will play a C tone every other second.

```python
#!/usr/bin/env python3

import rtmidi
import time

note_on = [0x90, 60, 100]
note_off = [0x80, 60, 0]

midiout = rtmidi.MidiOut()
available_ports = midiout.get_ports()

for i, p in enumerate(available_ports):
    if "SaaS" in p:
        port = i
        break
else:
    assert False

midiout.open_port(port)

while True:
    time.sleep(1)
    midiout.send_message(note_on)
    time.sleep(1)
    midiout.send_message(note_off)
```