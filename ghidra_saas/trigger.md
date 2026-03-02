# Code to Trigger 'return' from recv_loop() -> see ghidra_extracts.md
-> trigger.py
-> ghidra_extracts.md
-> saas.h
-> snd*.png

## escape triggers
- need hit these two conditions with 10 and 0x7

- extracted from  void recv_loop(_func_void_int_int_int_int *process_note_callback_function)
```c
    snd_seq_event_note = snd_seq_event->type;
    if (snd_seq_event_note == 10) {
          /* This causes the loop to exit, and continue running main() -> and the call execvp() */
      if ((snd_seq_event->data).note.duration == 0x79) {
        return;
      }
    }
``` 

## Memory Layout
- Here is the math the C compiler uses to find duration:

Member	Size	Offset (Hex)	Offset (Dec)	Description
type	  1	0x00	0	Event type (10 = Note)
flags	  1	0x01	1	
tag	    1	0x02	2	
queue	  1	0x03	3	
time	  8	0x04	4	Timestamp (can be tick or real-time)
source	4	0x0c	12	Client/Port source
dest	  4	0x10	16	Client/Port destination
data	  40	0x1c	28	The Start of the Union


Since data starts at 0x1c (28), we look inside the snd_seq_ev_note structure:

struct snd_seq_ev_note {
    unsigned char channel;      // Offset +0 (Total: 28)
    unsigned char note;         // Offset +1 (Total: 29)
    unsigned char velocity;     // Offset +2 (Total: 30)
    unsigned char off_velocity; // Offset +3 (Total: 31)
    unsigned int duration;      // Offset +4 (Total: 32 / 0x20)
};


Field	   Type	Size	Hex Representation
Event    Type	uchar	1 byte	0x0A
Header   Padding	N/A	27 bytes	0x00 * 27
Note     Channel	uchar	1 byte	0x00
Note     Number	uchar	1 byte	0x00
Velocity  uchar	1 byte	0x00
Off Velocity	uchar	1 byte	0x00
Duration	uint	4 bytes	0x79 0x00 0x00 0x00


