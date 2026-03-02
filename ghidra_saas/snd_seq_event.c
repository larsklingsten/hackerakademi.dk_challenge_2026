
/* This is a specific event type that contains note data (pitch, velocity, duration, etc.). */

void recv_loop(_func_void_int_int_int_int *process_note_callback_function)

{
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

