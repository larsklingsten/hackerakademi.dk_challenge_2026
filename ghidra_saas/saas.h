typedef unsigned char   undefined;

typedef unsigned char    bool;
typedef unsigned char    byte;
typedef unsigned char    dwfenc;
typedef unsigned int    dword;
typedef long long    int16;
typedef long long    longlong;
typedef unsigned long    qword;
typedef long    sqword;
typedef unsigned char    uchar;
typedef unsigned int    uint;
typedef unsigned long long    uint16;
typedef unsigned long    ulong;
typedef unsigned long long    ulonglong;
typedef unsigned char    undefined1;
typedef unsigned int    undefined4;
typedef unsigned long    undefined8;
typedef unsigned short    ushort;
typedef unsigned short    word;
typedef struct snd_seq_event snd_seq_event, *Psnd_seq_event;

typedef uchar snd_seq_event_type_t;

typedef union snd_seq_timestamp snd_seq_timestamp, *Psnd_seq_timestamp;

typedef union snd_seq_timestamp snd_seq_timestamp_t;

typedef struct snd_seq_addr snd_seq_addr, *Psnd_seq_addr;

typedef struct snd_seq_addr snd_seq_addr_t;

typedef union snd_seq_event_data snd_seq_event_data, *Psnd_seq_event_data;

typedef union snd_seq_event_data snd_seq_event_data_t;

typedef uint snd_seq_tick_time_t;

typedef struct snd_seq_real_time snd_seq_real_time, *Psnd_seq_real_time;

typedef struct snd_seq_ev_note snd_seq_ev_note, *Psnd_seq_ev_note;

typedef struct snd_seq_ev_note snd_seq_ev_note_t;

typedef struct snd_seq_ev_ctrl snd_seq_ev_ctrl, *Psnd_seq_ev_ctrl;

typedef struct snd_seq_ev_ctrl snd_seq_ev_ctrl_t;

typedef struct snd_seq_ev_raw8 snd_seq_ev_raw8, *Psnd_seq_ev_raw8;

typedef struct snd_seq_ev_raw8 snd_seq_ev_raw8_t;

typedef struct snd_seq_ev_raw32 snd_seq_ev_raw32, *Psnd_seq_ev_raw32;

typedef struct snd_seq_ev_raw32 snd_seq_ev_raw32_t;

typedef struct snd_seq_ev_ext snd_seq_ev_ext, *Psnd_seq_ev_ext;

typedef struct snd_seq_ev_ext snd_seq_ev_ext_t;

typedef struct snd_seq_ev_queue_control snd_seq_ev_queue_control, *Psnd_seq_ev_queue_control;

typedef struct snd_seq_ev_queue_control snd_seq_ev_queue_control_t;

typedef struct snd_seq_connect snd_seq_connect, *Psnd_seq_connect;

typedef struct snd_seq_connect snd_seq_connect_t;

typedef struct snd_seq_result snd_seq_result, *Psnd_seq_result;

typedef struct snd_seq_result snd_seq_result_t;

typedef struct snd_seq_ev_ump_notify snd_seq_ev_ump_notify, *Psnd_seq_ev_ump_notify;

typedef struct snd_seq_ev_ump_notify snd_seq_ev_ump_notify_t;

typedef union anon_union_8_6_a51d3e97_for_param anon_union_8_6_a51d3e97_for_param, *Panon_union_8_6_a51d3e97_for_param;

typedef struct snd_seq_queue_skew snd_seq_queue_skew, *Psnd_seq_queue_skew;

typedef struct snd_seq_queue_skew snd_seq_queue_skew_t;

struct snd_seq_ev_raw32 {
    uint d[3];
};

struct snd_seq_ev_ext {
    uint len;
    void *ptr;
};

struct snd_seq_result {
    int event;
    int result;
};

struct snd_seq_real_time {
    uint tv_sec;
    uint tv_nsec;
};

union snd_seq_timestamp {
    snd_seq_tick_time_t tick;
    struct snd_seq_real_time time;
};

struct snd_seq_queue_skew {
    uint value;
    uint base;
};

union anon_union_8_6_a51d3e97_for_param {
    int value;
    snd_seq_timestamp_t time;
    uint position;
    snd_seq_queue_skew_t skew;
    uint d32[2];
    uchar d8[8];
};

struct snd_seq_ev_queue_control {
    uchar queue;
    uchar unused[3];
    union anon_union_8_6_a51d3e97_for_param param;
};

struct snd_seq_ev_ump_notify {
    uchar client;
    uchar block;
};

struct snd_seq_addr {
    uchar client;
    uchar port;
};

struct snd_seq_connect {
    snd_seq_addr_t sender;
    snd_seq_addr_t dest;
};

struct snd_seq_ev_ctrl {
    uchar channel;
    uchar unused[3];
    uint param;
    int value;
};

struct snd_seq_ev_raw8 {
    uchar d[12];
};

struct snd_seq_ev_note {
    uchar channel;
    uchar note;
    uchar velocity;
    uchar off_velocity;
    uint duration;
};

union snd_seq_event_data {
    snd_seq_ev_note_t note;
    snd_seq_ev_ctrl_t control;
    snd_seq_ev_raw8_t raw8;
    snd_seq_ev_raw32_t raw32;
    snd_seq_ev_ext_t ext;
    snd_seq_ev_queue_control_t queue;
    snd_seq_timestamp_t time;
    snd_seq_addr_t addr;
    snd_seq_connect_t connect;
    snd_seq_result_t result;
    snd_seq_ev_ump_notify_t ump_notify;
};

struct snd_seq_event {
    snd_seq_event_type_t type;
    uchar flags;
    uchar tag;
    uchar queue;
    snd_seq_timestamp_t time;
    snd_seq_addr_t source;
    snd_seq_addr_t dest;
    snd_seq_event_data_t data;
};

