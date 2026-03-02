#include <alsa/asoundlib.h>
#include <assert.h>
#include <bits/time.h>
#include <math.h>
#include <pthread.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <sys/queue.h>
#include <time.h>
#include <unistd.h>

enum audio_event_type {
  EVENT_NOTEON,
  EVENT_NOTEOFF,
};

enum audio_shape_types {
  SHAPE_SINE,
  SHAPE_SAWTOOTH,
  SHAPE_CHORD,
};

#define SAMPLE_RATE 192000
#define MAX_SAMPLE 841686092616
#define PI 3.141592653589793
#define SEMITONE 1.0594630943592953 // equal temperament

typedef struct note note;

typedef struct waveshape {
  void (*init)(note *, struct waveshape *, int, int);
  void (*delete)(note *n);
  double (*gen)(int sampleno, note *n);
  double (*envelope)(int sampleno, note *n, double signal);
  bool (*can_delete)(int sampleno, note *n);
} waveshape;

struct waveshape waveshapes[];

typedef struct envelopedata {
  double attack;
  double decay;
  double sustain;
  double release;
} envelopedata;

typedef struct sine_shapedata {
  unsigned short freq;
} sine_shapedata;

typedef struct sawtooth_shapedata {
  unsigned short freq;
} sawtooth_shapedata;

typedef struct chord_shapedata {
  unsigned long _pad : 9;
  unsigned long root : 13;
  unsigned long third : 13;
  unsigned long fifth : 13;
} chord_shapedata;

typedef struct shapedata {
  char _reserved[0x10];
  int active;
  union {
    struct {
      envelopedata *ed;
      union {
        sine_shapedata sinedata;
        sawtooth_shapedata sawtoothdata;
      };
    };
    chord_shapedata chorddata;
  };
} shapedata;

typedef struct note {
  LIST_ENTRY(note) entries;
  int active;
  int note;
  int velocity;
  int trigger_on_time;
  int trigger_off_time;
  waveshape *ws;
  shapedata *sd;
} note;

unsigned char notes_played[0x1000];
int notes_played_idx = 0;

double envelope(int sampleno, note *n, double signal) {
  waveshape *ws = n->ws;
  envelopedata *ed = n->sd->ed;
  if (n->active) {
    double dur = sampleno - n->trigger_on_time;
    dur = dur / SAMPLE_RATE;
    if (dur < ed->attack) {
      return (dur / ed->attack) * signal;
    }
    if (dur < ed->attack + ed->decay) {
      double b = (ed->sustain - 1) / (ed->decay);
      double a = 1 - b * ed->attack;
      return (a + b * dur) * signal;
    }
    return ed->sustain * signal;
  }
  // !n->active
  double dur = sampleno - n->trigger_off_time;
  dur = dur / SAMPLE_RATE;
  if (dur > ed->release) {
    return 0;
  }
  return ((ed->release - dur) / ed->release) * ed->sustain * signal;
}

void generic_init(note *n, waveshape *ws, int note, int velocity) {
  n->active = true;
  n->note = note;
  n->velocity = velocity;
  n->ws = ws;
  n->sd = calloc(1, sizeof(shapedata));
  n->sd->active = true;
  notes_played[notes_played_idx++ %
               (sizeof(notes_played) / sizeof(notes_played[0]))] =
      note + velocity;
}

bool generic_can_delete(int sampleno, note *n) {
  if (n->active || !n->trigger_off_time)
    return false;

  return sampleno > n->trigger_off_time + (n->sd->ed->release * SAMPLE_RATE);
}

void generic_delete(note *n) {
  if (!n->sd->active) {
    return;
  }
  n->sd->active = false;
  free(n->sd);
}

envelopedata sine_ed = {
    .attack = 0.2,
    .decay = 0.5,
    .sustain = 0.7,
    .release = 0.4,
};

void sine_init(note *n, waveshape *ws, int note, int velocity) {
  generic_init(n, ws, note, velocity);
  n->sd->ed = &sine_ed;
  n->sd->sinedata.freq = 440 * pow(SEMITONE, n->note - 49);
}

double sine_gen(int sampleno, note *n) {
  double arg = 2 * PI * sampleno / SAMPLE_RATE;
  double sample = sin(arg * n->sd->sinedata.freq) * n->velocity / 0x7f;
  return sample;
}

envelopedata sawtooth_ed = {
    .attack = 0.1,
    .decay = 1,
    .sustain = 0.7,
    .release = 0,
};

void sawtooth_init(note *n, waveshape *ws, int note, int velocity) {
  generic_init(n, ws, note, velocity);
  n->sd->ed = &sawtooth_ed;
  n->sd->sawtoothdata.freq = 440 * pow(SEMITONE, n->note - 49);
}

double sawtooth_gen(int sampleno, note *n) {
  double t = (double)sampleno / SAMPLE_RATE * n->sd->sawtoothdata.freq;
  double sample = (-1 + 2 * (t - floor(t))) * n->velocity / 0x7f;
  return sample;
}

void chord_init(note *n, waveshape *ws, int note, int velocity) {
  generic_init(n, ws, note, velocity);
  chord_shapedata *sd = &n->sd->chorddata;
  n->sd->chorddata.root = (440 * pow(SEMITONE, n->note - 73));
  n->sd->chorddata.third = (440 * pow(SEMITONE, n->note - 73 + 4));
  n->sd->chorddata.fifth = (440 * pow(SEMITONE, n->note - 73 + 7));
}

double chord_gen(int sampleno, note *n) {
  double arg = 2 * PI * sampleno / SAMPLE_RATE;

  double progress = sampleno / (SAMPLE_RATE * 0.25);
  double phase = floor(progress);

  int freq = 4;
  switch (((int)phase) % 4) {
  case 0:
    freq *= n->sd->chorddata.root;
    break;
  case 1:
    freq *= n->sd->chorddata.third;
    break;
  case 2:
    freq *= n->sd->chorddata.fifth;
    break;
  case 3:
    freq *= n->sd->chorddata.third;
    break;
  }
  double edge = 1;
  double proximity = fmin(progress - phase, (phase + 1) - progress);
  if (proximity < 0.2) {
    edge = proximity / 0.2;
  }
  double sample = sin(arg * freq) * n->velocity / 0x7f;
  return sample * edge;
}

bool chord_can_delete(int sampleno, note *n) {
  if (n->active || !n->trigger_off_time)
    return false;

  return sampleno > n->trigger_off_time + (0.3 * SAMPLE_RATE);
}

struct waveshape waveshapes[] = {
    [SHAPE_SINE] = {.init = sine_init,
                    .delete = generic_delete,
                    .gen = sine_gen,
                    .envelope = envelope,
                    .can_delete = generic_can_delete},
    [SHAPE_SAWTOOTH] = {.init = sawtooth_init,
                        .delete = generic_delete,
                        .gen = sawtooth_gen,
                        .envelope = envelope,
                        .can_delete = generic_can_delete},
    [SHAPE_CHORD] = {.init = chord_init,
                     .delete = generic_delete,
                     .gen = chord_gen,
                     .envelope = NULL,
                     .can_delete = chord_can_delete}};

LIST_HEAD(listhead, note) list;
pthread_mutex_t list_lock = PTHREAD_MUTEX_INITIALIZER;

void update_ts(int sampleno, note *n) {
  if (n->active && !n->trigger_on_time)
    n->trigger_on_time = sampleno;
  if (!n->active && !n->trigger_off_time)
    n->trigger_off_time = sampleno;
}

double generate(int sampleno) {
  double sum = 0;
  note *n;

  LIST_FOREACH(n, &list, entries) {
    update_ts(sampleno, n);
    double signal = n->ws->gen(sampleno, n);
    if (n->ws->envelope) {
      signal = n->ws->envelope(sampleno, n, signal);
    }
    sum += signal;
  }

  return sum;
}

void remove_finished(int sampleno) {
  note *n, *old;
  while (1) {
    old = NULL;
    LIST_FOREACH(n, &list, entries) {
      if (n->ws->can_delete(sampleno, n)) {
        old = n;
        break;
      }
    }
    if (!old)
      break;
    if (n->ws->delete)
      n->ws->delete(n);
    LIST_REMOVE(old, entries);
    free(old);
  }
}

void *audio_loop(void *arg) {
  void (*stream_bytes)(char *, int) = arg;
  long sample = 0;
  double buf[0x1000];

  struct timespec time;
  clock_gettime(CLOCK_REALTIME, &time);

  while (1) {
    memset(buf, 0, sizeof(buf));

    pthread_mutex_lock(&list_lock);
    for (int i = 0; i < 0x1000; i++) {
      buf[i] = generate(sample);
      sample++;
    }
    remove_finished(sample);
    pthread_mutex_unlock(&list_lock);

    stream_bytes((char *)buf, sizeof(buf));

    time.tv_nsec += 0x1000 * (1000000000 / 192000);
    if (time.tv_nsec > 1000000000L) {
      time.tv_sec++;
      time.tv_nsec -= 1000000000L;
    }
    clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &time, NULL);
    if (sample > MAX_SAMPLE)
      sample = 0;
  }

  return NULL;
}

void recv_note(int event_type, int note, int velocity, int wave_type) {
  pthread_mutex_lock(&list_lock);

  if (event_type == EVENT_NOTEON) {
    struct note *n = calloc(1, sizeof(struct note));
    waveshape *ws = &waveshapes[wave_type];
    if (!ws->init) {
      return;
    }
    ws->init(n, ws, note, velocity);

    LIST_INSERT_HEAD(&list, n, entries);
  }
  if (event_type == EVENT_NOTEOFF) {
    struct note *n;
    LIST_FOREACH(n, &list, entries) {
      if (n->note == note) {
        if (!n->active && n->ws->delete)
          n->ws->delete(n);
        n->active = false;
      }
    }
  }

  pthread_mutex_unlock(&list_lock);
}

void audio_init() { LIST_INIT(&list); }