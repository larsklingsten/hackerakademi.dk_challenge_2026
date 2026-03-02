// [ε] root@router:~/git/saas# cat main.c
#include <alsa/asoundlib.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#include <linux/ipv6.h>
#include <netinet/udp.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <unistd.h>

void audio_init();
void *audio_loop(void *);
void recv_note(int event_type, int note, int velocity, int wave_type);

static int active = 0;

enum audio_event_type {
  EVENT_NOTEON,
  EVENT_NOTEOFF,
};

snd_seq_t *open_client() {
  snd_seq_t *handle;
  int err;
  err = snd_seq_open(&handle, "default", SND_SEQ_OPEN_INPUT, 0);
  if (err < 0)
    return NULL;
  snd_seq_set_client_name(handle, "SaaS client");
  return handle;
}

int my_new_port(snd_seq_t *handle) {
  return snd_seq_create_simple_port(
      handle, "SaaS port",
      SND_SEQ_PORT_CAP_WRITE | SND_SEQ_PORT_CAP_SUBS_WRITE |
          SND_SEQ_PORT_CAP_READ |     // These seem neccesary to make make
          SND_SEQ_PORT_CAP_SUBS_READ, // rtpmidid work
      SND_SEQ_PORT_TYPE_MIDI_GENERIC);
}

void recv_loop(void (*cb)(int, int, int, int)) {
  int err;
  snd_seq_t *seq = open_client();
  int port = my_new_port(seq);
  int event_type;

  snd_seq_event_t *ev;
  while (snd_seq_event_input(seq, &ev) >= 0) {
    switch (ev->type) {
    case SND_SEQ_EVENT_NOTEON:
      event_type = EVENT_NOTEON;
      break;
    case SND_SEQ_EVENT_NOTEOFF:
      event_type = EVENT_NOTEOFF;
      break;
    case SND_SEQ_EVENT_CONTROLLER:
      if (ev->data.control.param == MIDI_CTL_RESET_CONTROLLERS)
        return;
      break;
    default:
      snd_seq_drain_output(seq);
      continue;
    }

    active = 1;

    snd_seq_ev_note_t *note = &ev->data.note;

    cb(event_type, note->note, note->velocity, note->channel);
    snd_seq_drain_output(seq);
  }
}

#define PORT 1295
int stream_fd;
struct sockaddr_in stream_addr;

void stream_init() {
  int ret;

  stream_fd = socket(AF_INET, SOCK_DGRAM, 0);
  assert(stream_fd >= 0);

  int broadcast = 1;
  ret = setsockopt(stream_fd, SOL_SOCKET, SO_BROADCAST, &broadcast,
                   sizeof(broadcast));
  assert(ret >= 0);

  struct ifaddrs *ifap, *ifa;
  struct sockaddr_in *sa;
  char *addr;

  ret = -1;
  getifaddrs(&ifap);
  for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
    if (ifa->ifa_ifu.ifu_broadaddr &&
        ifa->ifa_ifu.ifu_broadaddr->sa_family == AF_INET &&
        strcmp(ifa->ifa_name, "lo")) {

      sa = (struct sockaddr_in *)ifa->ifa_ifu.ifu_broadaddr;

      memset(&stream_addr, 0, sizeof(stream_addr));
      stream_addr.sin_family = AF_INET;
      stream_addr.sin_port = htons(PORT);
      stream_addr.sin_addr = sa->sin_addr;

      ret = 0;
      break;
    }
  }
  assert(ret == 0);

  freeifaddrs(ifap);

  return;
}

void stream_bytes(char *buf, int len) {
  int ret;
  int pos = 0;

  if (!active)
    return;

  while (len > 0) {
    int slen = MIN(len, IPV6_MIN_MTU - sizeof(struct udphdr));

    ret = sendto(stream_fd, &buf[pos], slen, 0, (struct sockaddr *)&stream_addr,
                 sizeof(stream_addr));
    assert(ret >= 0);

    len -= slen;
    pos += slen;
  }
}

int main(int argc, char *argv[]) {
  fprintf(stderr, "Initializing\n");
  audio_init();
  stream_init();

  pthread_t thread;
  pthread_create(&thread, NULL, audio_loop, (void *)stream_bytes);

  recv_loop(recv_note);

  execvp(argv[0], argv);
  return EXIT_FAILURE;
}