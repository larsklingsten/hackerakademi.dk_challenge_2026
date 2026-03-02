
/* WARNING: Unknown calling convention -- yet parameter storage is locked */

void stream_init(void)

{
  int iVar1;
  ifaddrs *ifap;
  int broadcast;
  sockaddr_in *sa;
  ifaddrs *ifa;
  int ret;
  
  stream_fd = socket(2,2,0);
  if (stream_fd < 0) {
                    /* WARNING: Subroutine does not return */
    __assert_fail("stream_fd >= 0","main.c",0x55,"stream_init");
  }
  broadcast = 1;
  ret = setsockopt(stream_fd,1,6,&broadcast,4);
  if (ret < 0) {
                    /* WARNING: Subroutine does not return */
    __assert_fail("ret >= 0","main.c",0x5a,"stream_init");
  }
  ret = -1;
  getifaddrs(&ifap);
  ifa = ifap;
  do {
    if (ifa == (ifaddrs *)0x0) {
LAB_001015b8:
      if (ret != 0) {
                    /* WARNING: Subroutine does not return */
        __assert_fail("ret == 0","main.c",0x72,"stream_init");
      }
      freeifaddrs(ifap);
      return;
    }
    if (((ifa->ifa_ifu).ifu_broadaddr != (sockaddr *)0x0) &&
       (((ifa->ifa_ifu).ifu_broadaddr)->sa_family == 2)) {
      iVar1 = strcmp(ifa->ifa_name,"lo");
      if (iVar1 != 0) {
        sa = (sockaddr_in *)(ifa->ifa_ifu).ifu_broadaddr;
        memset(&stream_addr,0,0x10);
        stream_addr.sin_family = 2;
        stream_addr.sin_port = htons(0x50f);
        stream_addr.sin_addr.s_addr = (sa->sin_addr).s_addr;
        ret = 0;
        goto LAB_001015b8;
      }
    }
    ifa = ifa->ifa_next;
  } while( true );
}

