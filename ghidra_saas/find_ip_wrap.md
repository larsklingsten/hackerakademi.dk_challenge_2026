.strtab::00000407			utf8 u8"recv_loop"
.strtab::00000411			utf8 u8"recv_note"
00101030	snd_seq_event_input	<EXTERNAL>	JMP qword ptr [-><EXTERNAL>::snd_seq_event_input]
00101140	calloc	<EXTERNAL>	JMP qword ptr [-><EXTERNAL>::calloc]
00101170	pthread_mutex_lock	<EXTERNAL>	JMP qword ptr [-><EXTERNAL>::pthread_mutex_lock]
001011a0	pthread_mutex_unlock	<EXTERNAL>	JMP qword ptr [-><EXTERNAL>::pthread_mutex_unlock]
001011d0	snd_seq_drain_output	<EXTERNAL>	JMP qword ptr [DAT_001050d0]
001011d0	snd_seq_drain_output	<EXTERNAL>	JMP qword ptr [DAT_001050d0]
001012d9	open_client	Global	PUSH RBP
0010132a	my_new_port	Global	PUSH RBP
00101355	recv_loop	Global	recv_loop
00101355	recv_loop	Global	void __stdcall recv_loop(_func_void_int_int_int_int * process_note_callback_function)
0010171c		main	LEA RAX,[recv_note]
00101723		main	MOV argc=>recv_note,RAX
00101726		main	void recv_loop(_func_void_int_int_int_int * process_note_callback_function)
00101726		main	CALL recv_loop
00102327	recv_note	Global	recv_note
00102327	recv_note	Global	void __stdcall recv_note(int event_type, int note, int velocity, int wave_type)
00103278			ddw recv_loop
001034d4			ddw recv_note
00105140	waveshapes	Global	undefined1[120] 
00105140	waveshapes	Global	undefined1[120] 
00105140	waveshapes	Global	undefined1[120] 
001051f0	active	Global	int 0h
00106208	list	Global	listhead 
00106208	list	Global	listhead 
00106208	list	Global	listhead 
00106208	list	Global	listhead 
00106208	list	Global	listhead 
00106208	list	Global	listhead 
00106220	list_lock	Global	pthread_mutex_t 
00106220	list_lock	Global	pthread_mutex_t 
00106220	list_lock	Global	pthread_mutex_t 
00106220	list_lock	Global	pthread_mutex_t 
