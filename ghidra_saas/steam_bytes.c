
void stream_bytes(char *buf,int len)

{
  int iVar1;
  ssize_t sVar2;
  int len_local;
  char *buf_local;
  int ret;
  int slen;
  int pos;
  
  pos = 0;
  len_local = len;
  if (active != 0) {
    for (; 0 < len_local; len_local = len_local - iVar1) {
      iVar1 = len_local;
      if (0x4f7 < (uint)len_local) {
        iVar1 = 0x4f8;
      }
      sVar2 = sendto(stream_fd,buf + pos,(long)iVar1,0,(sockaddr *)&stream_addr,0x10);
      if ((int)sVar2 < 0) {
                    /* WARNING: Subroutine does not return */
        __assert_fail("ret >= 0","main.c",0x85,"stream_bytes");
      }
      pos = pos + iVar1;
    }
  }
  return;
}

