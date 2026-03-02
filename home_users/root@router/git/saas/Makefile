# [ε] root@router:~/git/saas# cat Makefile
saas: main.c audio.c
	gcc -ggdb -o $@ $^ -lasound -lm

rtpmidid_24.12.2_amd64.deb:
	curl -OL https://github.com/davidmoreno/rtpmidid/releases/download/v24.12/rtpmidid_24.12.2_amd64.deb