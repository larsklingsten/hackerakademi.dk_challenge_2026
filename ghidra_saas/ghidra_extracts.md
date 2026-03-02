# Ghidra Extracsts

##  main()
```c
int main(int argc,char **argv) {
  char **argv_local;
  int argc_local;
  pthread_t thread;
  
  fwrite("Initializing\n",1,0xd,stderr);
  audio_init();
  stream_init();
  pthread_create(&thread,(pthread_attr_t *)0x0,audio_loop,stream_bytes);
  recv_loop(recv_note); // contd loop, unless note.duration == 0x79, then ret
  execvp(*argv,argv);
  return 1;
}

```

## recv_loop() -> event driven loop, with exit
```c
/* This is a specific event type that contains note data (pitch, velocity, duration, etc.). */

void recv_loop(_func_void_int_int_int_int *process_note_callback_function) {
  int iVar1;
  _func_void_int_int_int_int *cb_local;
  snd_seq_event_t *snd_seq_event;
  snd_seq_ev_note_t *note;
  int port;
  snd_seq_t *seq;
  int event_type;
  byte snd_seq_event_note;
  
  seq = open_client();
  port = my_new_port(seq);
LAB_00101420:
  do {
    iVar1 = snd_seq_event_input(seq,&snd_seq_event);
    if (iVar1 < 0) {
      return;
    }
    snd_seq_event_note = snd_seq_event->type;
    if (snd_seq_event_note == 10) {
                    /* This causes the loop to exit and main() to call execvp() */
      if ((snd_seq_event->data).note.duration == 0x79) {
        return;
      }
    }
    else {
      if (10 < snd_seq_event_note) {
LAB_001013c3:
        snd_seq_drain_output(seq);
        goto LAB_00101420;
      }
      if (snd_seq_event_note == 6) {
        event_type = 0;
      }
      else {
        if (snd_seq_event_note != 7) goto LAB_001013c3;
        event_type = 1;
      }
    }
    active = 1;
    note = (snd_seq_ev_note_t *)&snd_seq_event->data;
    (*process_note_callback_function)
              (event_type,(int)*(undefined *)((long)&snd_seq_event->data + 1),
               (int)*(undefined *)((long)&snd_seq_event->data + 2),(int)note->channel);
    snd_seq_drain_output(seq);
  } while( true );
}
```
## snd_seq_event_input() 
```c
/* WARNING: Control flow encountered bad instruction data */

void snd_seq_event_input(void) {
                    /* WARNING: Bad instruction - Truncating control flow here */
                    /* snd_seq_event_input@ALSA_0.9 */
  halt_baddata();
  // note this normal when working with external library
}
```
Assembler
```asm
                         //
                         // EXTERNAL 
                         // NOTE: This block is artificial and allows ELF Relo
                         // ram:00107000-ram:001070ff
                         //
                         *******************************************************
                         *                   THUNK FUNCTION                    *
                         *******************************************************
                         thunk undefined snd_seq_event_input()
                            Thunked-Function: <EXTERNAL>::snd_se
           undefined       AL:1         <RETURN>
                         snd_seq_event_input@ALSA_0.9
                         <EXTERNAL>::snd_seq_event_input           XREF[2]:   snd_seq_event_input:00101030
                                                                               snd_seq_event_input:00101030
                                                                               00105000(*)  
      00107000               ??        ??


```

## execvp() 
```c
/* WARNING: Control flow encountered bad instruction data */
/* WARNING: Unknown calling convention -- yet parameter storage is locked */

int execvp(char *__file,char **__argv)
{
                    /* WARNING: Bad instruction - Truncating control flow here */
                    /* execvp@GLIBC_2.2.5 */
  halt_baddata();
}
```

## Memory Layout

0x0	0x1	snd_seq_event_type_t	typedef snd_seq_event_type_t uchar	type	
0x1	0x1	uchar	uchar	flags	
0x2	0x1	uchar	uchar	tag	
0x3	0x1	uchar	uchar	queue	
0x4	0x8	snd_seq_timestamp_t	typedef snd_seq_timestamp_t snd_seq_timestamp	time	
0xc	0x2	snd_seq_addr_t	typedef snd_seq_addr_t snd_seq_addr	source	
0xe	0x2	snd_seq_addr_t	typedef snd_seq_addr_t snd_seq_addr	dest	
0x10	0xc	snd_seq_event_data_t	typedef snd_seq_event_data_t snd_seq_event_data	data	
