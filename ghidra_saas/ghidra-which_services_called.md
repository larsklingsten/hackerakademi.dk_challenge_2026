# Whcih services are being called

```c

/* WARNING: Unknown calling convention */

snd_seq_t * open_client(void) {
  snd_seq_t *handle;
  int err;
  
  err = snd_seq_open(&handle,"default",2,0);
  if (err < 0) {
    handle = (snd_seq_t *)0x0;
  }
  else {
    snd_seq_set_client_name(handle,"SaaS client");
  }
  return handle;
}
```

# port unknown

```c

/* WARNING: Control flow encountered bad instruction data */

void snd_seq_open(void)

{
                    /* WARNING: Bad instruction - Truncating control flow here */
                    /* snd_seq_open@ALSA_0.9 */
  halt_baddata();
}


/* WARNING: Control flow encountered bad instruction data */

void snd_seq_open(void)

{
                    /* WARNING: Bad instruction - Truncating control flow here */
                    /* snd_seq_open@ALSA_0.9 */
  halt_baddata();
}

