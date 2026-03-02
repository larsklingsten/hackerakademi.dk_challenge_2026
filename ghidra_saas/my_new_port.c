
int my_new_port(snd_seq_t *handle)

{
  int iVar1;
  snd_seq_t *handle_local;
  
  iVar1 = snd_seq_create_simple_port(handle,"SaaS port",99,2);
  return iVar1;
}

