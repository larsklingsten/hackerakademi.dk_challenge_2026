#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  char buf[0x10];
  fgets(buf, 0x100000, stdin);
  asm("jmp *%rbp");
  return EXIT_SUCCESS;
}
