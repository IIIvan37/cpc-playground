-- Migration: Import z80code projects batch 21
-- Projects 41 to 42
-- Generated: 2026-01-25T21:43:30.186475

-- Project 41: 1-bit-audio stuff ## by BSC
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    '1-bit-audio stuff ##',
    'Imported from z80Code. Author: BSC. Uses the envelope generator to create cool sounds',
    'public',
    false,
    false,
    '2022-11-15T23:09:20.205000'::timestamptz,
    '2022-11-19T13:57:35.221000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';#target bin

; Start
;
    org $9000

;  0=9    \__________     single decay then off
;
;  8      \|\|\|\|\|\     repeated decay
;
;  9=0    \__________     single decay then off
;
; 10      \/\/\/\/\/\     repeated decay-attack
;           _________
; 11      \|              single decay then hold
;
; 12      /|/|/|/|/|/     repeated attack
;          __________
; 13      /               single attack then hold
;
; 14      /\/\/\/\/\/     repeated attack-decay
;
; 15=4    /|_________     single attack then off
;

; toggle internal/external song data
READ_SONG equ 0

; slide instead of playing a song
; -> disables reading song data!
SLIDE_UP equ 0
SLIDE_SPEED equ 5

READ_SONG_DATA equ READ_SONG

; tick len when playing the internal test song
TICK_LEN equ 120


; voice and overdub control
; TODO turn on overdub
VOICE_1  equ 1
OVERDUB1 equ 1
; .. 2
VOICE_2  equ 1
OVERDUB2 equ 1
; .. 3
VOICE_3  equ 1 ; TODO 1
OVERDUB3 equ 1

VOICE_4 equ 0 ; overdub currently supports only 3 overdubbed voices!

; 9 = \_
; b = \|
; d = /
; f = /|  

; set to > 0 to override values from song data
STATIC_HI_LO equ $9d ; $d9
STATIC_FINE equ 0 ; 20 ; 10; 2

; lo and hi are flipped when playing
; flipping is achieved using xor
USE_XOR equ 0 


; controls whether to test the inner audio loop
LOOP_TEST equ 0

; toggle back-buffer
USE_BUFFER equ 0

; buffer address hi-byte
BUFFER_HI equ $c0
BUF_SIZE equ 8

; start
three:
    di

    ; PSG-Regs init.
    ld hl,psg_regs+13
    ld de,$f4f6
    ld a,13
psg_loop:

    ld      b,d
    out     (c),a
    ld      b,e
    ld      c,$c0
    out     (c),c
    out     (c),0

    ld c,(hl)
    dec hl

    ld      b,d
    out     (c),c
    ld      b,e
    ld      c,$80
    out     (c),c
    out     (c),0

    dec a 
    jp p,psg_loop

    ld bc,$7f10
    out (c),c

    exx
    ld hl,$f4f6
    ld de,$c080
    exx

song_loop:

song_ptr: equ $+1
    ld sp,song 
    pop hl
    ; h = env period fine
    ; l = env shapes (lo and hi nibble each)
    ld a,h
    or l
    jr nz,no_restart

    ; restart song
    ld sp,loop_position
    pop hl
no_restart:
    ; h = env period fine value
    ; l = env shapes (lo and hi nibble each)

    ; select env period fine register
    exx
    ld a,11
    ld b,h
    out (c),a   
    ld b,l
    out (c),d
    out (c),0
    exx
    ; h = env period fine value
    ld a,h
    exx
    ld b,h  
    out (c),a   
    ld b,l
    out (c),e
    out (c),0
  
    ; select env shape reg.
    ; which is being written during play
    ld b,h
    ld a,13
    out (c),a   
    ld b,l
    out (c),d
    out (c),0
    exx

    ; l = envelope shape hi << 4 & lo
    ; e.g. hl = $2345
    ; => high = 4
    ; => low  = 5

    ; get shape low
    ld a,STATIC_HI_LO

    and 15
    ld b,a
    ; b = shape lo

    ; get shape high
    ld a,STATIC_HI_LO
    rra
    rra
    rra
    rra
    and 15
    ld c,a
    ; c = shape hi

    ; store pattern address
    pop hl
    ld (pattern_ptr),hl

    ; update song position
    ld (song_ptr),sp

tone_loop: 
    ; loop counter
    ld xh,TICK_LEN
    ld xl,150
    ; loop iterations =
    ;   (xh-1) * 256 
    ; + (xl-1) 
    ; e.g. ix=$0180 => $7f iterations

wave_loop:

    ; init sample
    xor a

; reset sp to start of step data each iteration
pattern_ptr: equ $+1
    ld sp,$cafe

; voice 1 and overdub
    ; 1 main
voice1cnt: equ $+1
    ld hl,0
    pop de
    add hl,de
    ld (voice1cnt),hl
    jr nc,no_reset_1 
    inc a
no_reset_1:
    ; 1 overdub
    ; overdub re-uses the main increment, but increased by 1 
    ; to achieve a beating/sweeping effect
voice1cnt2: equ $+1
    ld hl,0
;    inc de
;    inc de
    inc de ; TODO read increment from song
    add hl,de
    ld (voice1cnt2),hl
    jr nc,no_reset_1b
    inc a
no_reset_1b:

; voice 2 and overdub
    ; 2 main
voice2cnt: equ $+1
    ld hl,0
    pop de
    add hl,de
    ld (voice2cnt),hl
    jr nc,no_reset_2 
    inc a
no_reset_2:
    ; 2 overdub
voice2cnt2: equ $+1
    ld hl,0
    inc de ; TODO read increment from song
    add hl,de
    ld (voice2cnt2),hl
    jr nc,no_reset_2b
    inc a
no_reset_2b:

; voice 3 and overdub
    ; 3 main
voice3cnt: equ $+1
    ld hl,0
    pop de
    add hl,de
    ld (voice3cnt),hl
    jr nc,no_reset_3 
    inc a
no_reset_3:
    ; 3 overdub
voice3cnt2: equ $+1
    ld hl,0
    inc de ; TODO read increment from song
    add hl,de
    ld (voice3cnt2),hl
    jr nc,no_reset_3b
    inc a
no_reset_3b:

; a = the "sample", having counted the
; number of times any voice had a zero-crossing
; i.e. needs a waveform-reset aka re-trigger

post_mixing:
    ; a > 0 => re-trig
    or a
    jp z,same

    ; re-trig envelope
    ld a,c

    ; a = current envelope shape
    exx         ; 3
    ld b,h      ; 4
    out (c),a   ; 8
    ld b,l      ; 9
    out (c),e   ; 13
    out (c),0   ; 17
    exx         ; 18

next:
    ; pretty colors
    ld b,$7f
    or $40
    out (c),a

    ; NOTE: xh SHOULD be > 0, otherwise loooong loops must be expected  
    dec xl
    jp nz,wave_loop
    dec xh
    jp nz,wave_loop

   ; next step
    jp song_loop

same:
    ; did not change
    ds 17,0
    jr next


; use internal song data

;                        __ 
; 9    = \_
; b/11 = \|
; d/13 = /
; f/15 = /|  

; hi/lo shape values
; only the hi-nibble is used!
t1 equ $9d ; $90 ; == $90 
t2 equ $99 ; $4b ; b 
t3 equ $bf ; $80 ; 9d 
t4 equ $ff ; $a0 ; d9

; envelope periods
X equ 5
Y equ 10
Z equ 20

; test data
song:
loop_position:
    db t1, Y
    dw pattern1
    db t2, Y
    dw pattern2
    db t3, Y
    dw pattern3
    db t4, Y
    dw pattern2

   ; dw 0

    db t1, Y
    dw pattern1
    db t1, Y
    dw pattern2
    db t1, Y
    dw pattern3

    db t1, Z
    dw pattern1
    db t1, Z
    dw pattern2
    db t1, Z
    dw pattern3

    db t2, X
    dw pattern1
    db t2, Y
    dw pattern2
    db t2, Z
    dw pattern3

    db t3, X
    dw pattern1
    db t3, Y
    dw pattern2
    db t3, Z
    dw pattern3

    db t4, X
    dw pattern1
    db t4, Y
    dw pattern2
    db t4, Z
    dw pattern3
    
    ; end of song
    dw 0

pattern1:
    dw 227,220,454,440

pattern2:
    dw 454,459,456,227

pattern3:
    dw 908,903,910,227


psg_regs:
    ; 0,1 = tone A
    dw $fca

    ; 2,3 = tone B
    dw $aeb

    ; 4,5 = tone C
    dw $be

    ; 6 = noise
    db $00

    ; 7 = control
    ;db %00111000 ; noise=off, wave=on
    ;db %00010111 ; noiseAC=on, others off
    db %00111111 ; noise=off, wave=off

    ; 8,9,10 = vol A,B,C
    ; hardenv on all voices
    db $90,$70,$90
    ;db 16,16,16 

    ; 11,12 = env period
    db 0,0 

    ; 13 = env shape
    db 4 

; EOF
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: audio
  SELECT id INTO tag_uuid FROM tags WHERE name = 'audio';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 42: banana by Demoniak
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'banana',
    'Imported from z80Code. Author: Demoniak. Delta packing',
    'public',
    false,
    false,
    '2020-05-12T14:20:43.528000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '

	DI
	LD	HL,Palette
	LD	B,#7F
	XOR	A
SetPal:
	OUT	(C),A
	INC	B
	OUTI
	INC	A
	CP	18
	JR	C,SetPal
    ld a, #c3
    ld (#38), a
	LD	HL,NewIrq
	LD	(#39),HL
	EI
	LD	BC,#F00
	LD	DE,Fonte
SetFonte:
	LD	HL,DataFnt
	LD	A,C
	AND	B
	ADD	A,L
	LD	L,A
	LD	A,(HL)
	LD	(DE),A
	INC	DE
	LD	HL,DataFnt
	LD	A,C
	RRCA
	RRCA
	RRCA
	RRCA
	AND	B
	ADD	A,L
	LD	L,A
	LD	A,(HL)
	LD	(DE),A
	INC	DE
	INC	C
	JR	NZ,SetFonte
Debut
	LD	IX,AnimDelta
Boucle:
	LD	H,(IX+1)
	LD	L,(IX+0)
	LD	A,H
	OR	H
	JR	Z,Debut
	LD	DE,Buffer
	PUSH	DE
; Decompactage
DepkLzw:
	LD	A,(HL)			; DepackBits = InBuf[ InBytes++ ]
	INC	HL
	RRA				; Rotation rapide calcul seulement flag C
	SET	7,A			; Positionne bit 7 en gardant flag C
	LD	(BclLzw+1),A
	JR	C,TstCodeLzw
CopByteLzw:
	LDI				; OutBuf[ OutBytes++ ] = InBuf[ InBytes++ ]

BclLzw:
	LD	A,0
	RR	A			; Rotation avec calcul Flags C et Z
	LD	(BclLzw+1),A
	JR	NC,CopByteLzw
	JR	Z,DepkLzw

TstCodeLzw:
	LD	A,(HL)			; A = InBuf[ InBytes ];
	AND	A
	JR	Z,InitDraw		; Plus d''octets à traiter = fini

	INC	HL
	LD	B,A			; B = InBuf[ InBytes ]
	RLCA				; A & #80 ?
	JR	NC,TstLzw40

	RLCA
	RLCA
	RLCA
	AND	7
	ADD	A,3			; Longueur = 3 + ( ( InBuf[ InBytes ] >> 4 ) & 7 );
	LD	C,A			; C = Longueur
	LD	A,B			; B = InBuf[InBytes]
	AND	#0F			; Delta = ( InBuf[ InBytes++ ] & 15 ) << 8
	LD	B,A			; B = poids fort Delta
	LD	A,C			; A = Length
	SCF				; Repositionner flag C (pour Delta++)
CopyBytes0:
	LD	C,(HL)			; C = poids faible Delta (Delta |= InBuf[ InBytes++ ]);
	INC	HL
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC			; HL=HL-(BC+1)
	LD	B,0
CopyBytes1:
	LD	C,A
CopyBytes2:
	LDIR
CopyBytes3:
	POP	HL
	JR	BclLzw

TstLzw40:
	RLCA				; A & #40 ?
	JR	NC,TstLzw20

	LD	C,B
	RES	6,C			; Delta = 1 + InBuf[ InBytes++ ] & #3f;
	LD	B,0			; BC = Delta + 1 car flag C = 1
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC
	LDI
	LDI				; Longueur = 2
	JR	CopyBytes3

TstLzw20:
	RLCA				; A & #20 ?
	JR	NC,TstLzw10

	LD	A,B			; B compris entre #20 et #3F
	ADD	A,#E2			; = ( A AND #1F ) + 2, et positionne carry
	LD	B,0			; Longueur = 2 + ( InBuf[ InBytes++ ] & 31 );
	JR	CopyBytes0

CodeLzw0F:
	LD	C,(HL)
	PUSH	HL
	LD	H,D
	LD	L,E
	CP	#F0
	JR	NZ,CodeLzw02

	XOR	A
	LD	B,A
	INC	BC			; Longueur = Delta = InBuf[ InBytes + 1 ] + 1;
	SBC	HL,BC
	LDIR
	POP	HL
	INC	HL			; Inbytes += 2
	JR	BclLzw

CodeLzw02:
	CP	#20
	JR	C,CodeLzw01

	LD	C,B			; Longueur = Delta = InBuf[ InBytes ];
	LD	B,0
	SBC	HL,BC
	JR	CopyBytes2

CodeLzw01:				; Ici, B = 1
	XOR	A			; Carry a zéro
	DEC	H			; Longueur = Delta = 256
	JR	CopyBytes1

TstLzw10:
	RLCA				; A & #10 ?
	JR	NC,CodeLzw0F

	RES	4,B			; B = Delta(high) -> ( InBuf[ InBytes++ ] & 15 ) << 8;
	LD	C,(HL)			; C = Delta(low)  -> InBuf[ InBytes++ ];
	INC	HL
	LD	A,(HL)			; A = Longueur - 1
	INC	HL
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC			; Flag C=1 -> hl=hl-(bc+1) (Delta+1)
	LD	B,0
	LD	C,A
	INC	BC			; BC =  Longueur = InBuf[ InBytes++ ] + 1;
	JR	CopyBytes2

InitDraw:
	LD	A,0
	CP	24
	JR	C,InitDraw
	XOR	A
	LD	(InitDraw+1),A
	POP	HL			; HL = buffer
	LD	A,(HL)
	CP	''D''
	JR	Z,DrawImgD
	CP	''I''
	JR	Z,DrawImgI
	LD	BC,#C000
DrawImgO:
	LD	D,Fonte/512
	INC	HL
	LD	E,(HL)			; Code ASCII
	EX	DE,HL
	ADD	HL,HL
	LD	A,(HL)
	INC	HL
	LD	(BC),A
	SET	3,B
	LD	(BC),A
	SET	4,B
	LD	(BC),A
	RES	3,B
	LD	(BC),A
	SET	5,B
	LD	A,(HL)
	INC	HL
	LD	(BC),A
	SET	3,B
	LD	(BC),A
	RES	4,B
	LD	(BC),A
	RES	3,B
	LD	(BC),A
	RES	5,B
	EX	DE,HL
	INC	BC
	BIT	3,B
	JR	Z,DrawImgO
DrawImgI:
	INC	IX
	INC	IX
	JP	Boucle
DrawImgD:
	LD	DE,#C000
	LD	IY,Buffer
	LD	C,(IY+1)
	LD	B,(IY+2)
DrawImgD1:
	LD	H,0
	LD	L,(IY+3)			; Déplacement
	ADD	HL,DE			; Ajouter à DE
	EX	DE,HL
	LD	L,(IY+4)			; Code ASCII
	LD	H,Fonte/512
	ADD	HL,HL
	LD	A,(HL)
	INC	HL
	LD	(DE),A
	SET	3,D
	LD	(DE),A
	SET	4,D
	LD	(DE),A
	RES	3,D
	LD	(DE),A
	SET	5,D
	LD	A,(HL)
	INC	HL
	LD	(DE),A
	SET	3,D
	LD	(DE),A
	RES	4,D
	LD	(DE),A
	RES	3,D
	LD	(DE),A
	RES	5,D
	INC	IY
	INC	IY
	INC	DE
	DEC	BC
	LD	A,B
	OR	C
	JR	NZ,DrawImgD1
	JR	DrawImgI
	Nolist
NewIrq:
	PUSH	AF
	LD	A,(InitDraw+1)
	INC	A
	LD	(InitDraw+1),A
	POP	AF
	EI
	RET
DataFnt:
	DB	#00, #C0, #0C, #CC, #30, #F0, #3C, #FC
	DB	#03, #C3, #0F, #CF, #33, #F3, #3F, #FF
Fonte	EQU	#B000
Palette:
	DB	"KTJL^TUEF^_GRYD_K",#8C
Delta0:		; Taille #00BF
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#0F,#1F,#87,#0F,#3F,#0F,#7F
	DB	#0F,#17,#10,#11,#11,#10,#10,#4F,#4B,#08,#11,#44,#24,#10,#50,#4C
	DB	#11,#22,#22,#22,#CA,#21,#10,#51,#48,#10,#20,#EE,#12,#12,#21,#51
	DB	#10,#50,#46,#D7,#20,#46,#22,#48,#22,#A2,#11,#10,#4F,#44,#01,#21
	DB	#4F,#20,#A2,#38,#21,#22,#12,#10,#4F,#46,#21,#9B,#20,#EE,#12,#31
	DB	#0C,#31,#11,#10,#4F,#48,#20,#50,#33,#13,#13,#21,#37,#10,#EF,#43
	DB	#21,#E8,#22,#4E,#21,#21,#4C,#02,#12,#11,#6F,#25,#0F,#10,#97,#39
	DB	#81,#3D,#43,#11,#23,#4D,#22,#4E,#11,#96,#01,#23,#13,#11,#8A,#3A
	DB	#10,#20,#42,#10,#11,#26,#4E,#DB,#20,#4B,#81,#99,#01,#12,#2D,#40
	DB	#82,#7B,#12,#20,#4D,#20,#A8,#B3,#21,#5B,#13,#B8,#42,#01,#01,#02
	DB	#04,#11,#13,#C3,#42,#C7,#91,#2B,#21,#49,#22,#09,#01,#01,#00,#11
	DB	#3B,#3D,#B1,#40,#3F,#23,#9A,#09,#15,#67,#FF,#01,#0F,#4F,#00
Delta1:		; Taille #00BF
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#0F,#1F,#43,#0F,#3F,#0F,#47
	DB	#10,#11,#11,#10,#10,#4F,#4B,#11,#04,#44,#24,#10,#50,#4C,#11,#22
	DB	#22,#22,#21,#E5,#10,#51,#48,#10,#20,#EE,#12,#12,#21,#51,#10,#50
	DB	#46,#20,#46,#6B,#22,#48,#22,#A2,#11,#10,#4F,#44,#01,#21,#4F,#20
	DB	#A2,#21,#1C,#22,#12,#10,#4F,#46,#21,#9B,#20,#EE,#12,#31,#31,#86
	DB	#11,#10,#4F,#48,#20,#50,#33,#13,#13,#21,#10,#EF,#41,#FB,#21,#E6
	DB	#24,#4E,#21,#21,#4C,#C1,#3F,#26,#13,#10,#95,#33,#81,#3B,#F7,#23
	DB	#42,#91,#8B,#22,#4E,#01,#21,#13,#04,#11,#88,#38,#A3,#17,#77,#27
	DB	#4E,#23,#0B,#81,#9B,#01,#11,#DD,#3C,#20,#A2,#23,#EC,#12,#7B,#21
	DB	#99,#4B,#01,#13,#BA,#43,#81,#DE,#20,#4C,#12,#CC,#45,#10,#FA,#10
	DB	#27,#47,#11,#11,#89,#3A,#11,#91,#0A,#C1,#93,#91,#87,#11,#89,#39
	DB	#7F,#11,#3D,#0A,#D1,#33,#0A,#15,#84,#C7,#0F,#CC,#0F,#B5,#00
Delta2:		; Taille #00D8
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#07,#30,#10,#41,#41,#10,#10
	DB	#2A,#26,#0F,#24,#11,#24,#04,#44,#11,#10,#50,#4A,#11,#21,#22,#22
	DB	#22,#09,#10,#50,#3E,#10,#10,#27,#3F,#10,#11,#12,#22,#70,#12,#12
	DB	#12,#11,#31,#1A,#10,#92,#29,#42,#01,#BB,#25,#40,#46,#10,#04,#43
	DB	#26,#0F,#01,#23,#1E,#9D,#10,#4F,#2D,#01,#20,#83,#26,#3F,#21,#0A
	DB	#10,#21,#04,#D3,#26,#4F,#20,#F9,#10,#01,#10,#F2,#33,#01,#20,#A1
	DB	#23,#D9,#33,#20,#EE,#21,#ED,#12,#34,#22,#5F,#21,#65,#01,#01,#03
	DB	#11,#46,#3B,#22,#53,#11,#13,#33,#33,#33,#13,#12,#21,#81,#91,#11
	DB	#01,#11,#DE,#44,#22,#21,#21,#EF,#A1,#E1,#12,#2E,#47,#21,#4B,#03
	DB	#12,#10,#4F,#4E,#10,#4E,#47,#25,#4F,#3B,#11,#3B,#45,#23,#4F,#12
	DB	#82,#CF,#10,#4E,#49,#92,#C1,#01,#01,#FA,#11,#10,#4E,#4B,#00,#F3
	DB	#2D,#10,#4C,#3F,#83,#18,#A4,#09,#21,#05,#F4,#10,#10,#10,#9A,#45
	DB	#10,#22,#9A,#23,#54,#10,#A4,#40,#81,#38,#FF,#E3,#5F,#0C,#15,#5C
	DB	#4B,#0F,#52,#0F,#A5,#01,#03,#00
Delta3:		; Taille #00C3
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#0F,#1F,#21,#0F,#34,#10,#41
	DB	#41,#10,#10,#4E,#4B,#11,#44,#84,#24,#11,#10,#4E,#4B,#22,#22,#22
	DB	#21,#10,#50,#49,#80,#11,#12,#12,#12,#22,#12,#11,#10,#F1,#47,#1E
	DB	#11,#20,#99,#20,#4A,#04,#10,#A1,#3D,#10,#01,#01,#52,#10,#23,#92
	DB	#11,#21,#47,#10,#04,#01,#DF,#23,#FB,#21,#16,#10,#96,#35,#22,#3C
	DB	#24,#9F,#34,#21,#F0,#02,#59,#24,#0C,#10,#00,#10,#A7,#37,#20,#88
	DB	#01,#A1,#33,#11,#00,#22,#21,#13,#33,#33,#33,#13,#11,#1D,#25,#9E
	DB	#01,#10,#F4,#3A,#21,#51,#B1,#DD,#21,#21,#22,#75,#22,#0A,#01,#11
	DB	#8F,#42,#01,#22,#50,#03,#12,#30,#48,#11,#EE,#12,#10,#4F,#4D,#25
	DB	#50,#13,#21,#4A,#11,#20,#51,#42,#10,#4F,#49,#DE,#10,#E2,#2A,#10
	DB	#4D,#44,#24,#4E,#22,#50,#10,#10,#52,#41,#A2,#22,#FC,#01,#11,#0A
	DB	#12,#2D,#3F,#82,#C0,#C2,#C2,#0B,#15,#85,#74,#0F,#0F,#79,#0F,#F3
	DB	#0F,#66,#00
Delta4:		; Taille #00C0
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#0F,#1F,#87,#0F,#3F,#0F,#7F
	DB	#0F,#14,#10,#11,#11,#10,#10,#4E,#4C,#08,#24,#44,#11,#10,#4D,#4A
	DB	#21,#22,#22,#22,#67,#10,#4F,#48,#20,#4E,#21,#4D,#12,#12,#20,#F0
	DB	#10,#F1,#46,#11,#1B,#24,#9C,#20,#56,#10,#10,#A2,#45,#20,#4F,#12
	DB	#22,#21,#8B,#20,#9C,#21,#4F,#01,#10,#4F,#46,#11,#31,#31,#20,#EF
	DB	#86,#12,#11,#40,#47,#21,#EF,#21,#13,#13,#33,#10,#4E,#44,#8F,#21
	DB	#E6,#20,#4F,#20,#EE,#81,#41,#21,#21,#11,#25,#0F,#73,#10,#9A,#3B
	DB	#42,#01,#11,#25,#50,#20,#51,#21,#09,#01,#FB,#23,#13,#10,#4F,#38
	DB	#01,#81,#85,#21,#3F,#25,#50,#81,#90,#82,#34,#DF,#11,#94,#3F,#21
	DB	#43,#20,#96,#20,#51,#21,#52,#12,#12,#31,#45,#21,#A2,#FD,#20,#50
	DB	#01,#02,#04,#13,#C6,#42,#22,#92,#21,#48,#22,#09,#F8,#01,#01,#00
	DB	#11,#3F,#3D,#24,#F0,#23,#99,#09,#15,#6A,#FF,#07,#01,#0F,#4F,#00
Delta5:		; Taille #00BD
	DB	#80,#44,#88,#00,#C5,#10,#00,#11,#02,#88,#00,#10,#4B,#22,#07,#24
	DB	#00,#44,#45,#E2,#49,#22,#09,#21,#00,#22,#02,#02,#23,#0B,#41,#21
	DB	#07,#01,#12,#00,#12,#01,#4B,#10,#EA,#46,#21,#0D,#02,#43,#00,#02
	DB	#4B,#59,#38,#01,#11,#47,#55,#69,#21,#17,#03,#01,#DA,#47,#55,#31
	DB	#02,#65,#00,#22,#29,#21,#1E,#96,#47,#75,#59,#13,#02,#00,#33,#21
	DB	#41,#EC,#00,#41,#21,#23,#02,#06,#23,#53,#21,#17,#02,#84,#11,#05
	DB	#23,#11,#38,#11,#02,#01,#22,#1F,#CA,#01,#21,#05,#04,#22,#67,#10
	DB	#02,#4C,#4F,#F2,#01,#20,#63,#37,#01,#22,#1F,#24,#9B,#22,#6D,#20
	DB	#6B,#9E,#05,#21,#1D,#24,#77,#23,#13,#02,#01,#39,#23,#88,#CF,#47
	DB	#02,#21,#40,#22,#47,#12,#04,#21,#59,#21,#09,#FD,#23,#16,#3F,#24
	DB	#06,#22,#3B,#23,#1B,#21,#99,#21,#B1,#4D,#0E,#44,#21,#3B,#25,#22
	DB	#28,#21,#10,#45,#00,#07,#20,#00,#49,#00,#03,#00,#00
Delta6:		; Taille #00D6
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#06,#30,#10,#41,#41,#10,#10
	DB	#29,#25,#10,#4E,#25,#11,#44,#84,#24,#11,#10,#4E,#4B,#22,#22,#22
	DB	#21,#10,#50,#3E,#04,#10,#10,#27,#E1,#11,#12,#12,#12,#22,#B8,#12
	DB	#11,#10,#31,#1A,#10,#4E,#28,#21,#8D,#01,#25,#91,#1E,#11,#47,#7F
	DB	#04,#26,#0F,#01,#00,#00,#D5,#10,#AC,#30,#01,#20,#83,#11,#26,#3F
	DB	#21,#21,#90,#04,#7E,#01,#26,#5F,#27,#0A,#10,#53,#2E,#20,#A1,#22
	DB	#D9,#7F,#34,#CF,#21,#F0,#02,#22,#5E,#21,#65,#01,#01,#11,#46,#3B
	DB	#21,#52,#00,#11,#22,#21,#13,#33,#33,#33,#13,#8E,#11,#10,#4B,#3F
	DB	#D1,#4A,#91,#DD,#21,#21,#22,#12,#31,#47,#5C,#11,#12,#21,#50,#03
	DB	#12,#81,#48,#11,#10,#4F,#4E,#01,#6E,#11,#10,#4F,#4D,#21,#50,#82
	DB	#CF,#12,#13,#71,#4A,#81,#D8,#01,#7D,#10,#4E,#4C,#00,#F3,#2E,#14
	DB	#0D,#40,#82,#C3,#93,#AF,#21,#05,#10,#FA,#10,#10,#9A,#45,#10,#22
	DB	#9A,#23,#54,#10,#A4,#40,#81,#38,#E3,#14,#7F,#0C,#15,#5D,#4A,#0F
	DB	#51,#0F,#A3,#01,#07,#00
Delta7:		; Taille #00C7
	DB	#F8,#4F,#00,#00,#02,#04,#08,#0F,#0F,#0F,#1F,#21,#0F,#37,#10,#41
	DB	#41,#10,#10,#4F,#4B,#11,#24,#04,#44,#11,#10,#50,#4A,#11,#21,#22
	DB	#22,#22,#01,#10,#50,#49,#10,#11,#12,#22,#12,#12,#12,#3E,#11,#10
	DB	#9D,#47,#20,#50,#04,#43,#10,#50,#3E,#10,#01,#82,#01,#23,#E3,#01
	DB	#10,#10,#10,#21,#04,#DF,#23,#4F,#20,#AC,#56,#10,#F9,#35,#21,#3E
	DB	#10,#23,#42,#20,#EE,#B9,#21,#ED,#12,#34,#24,#9F,#22,#62,#10,#A8
	DB	#36,#01,#25,#A0,#00,#11,#13,#33,#33,#33,#13,#21,#22,#3A,#11,#25
	DB	#9E,#01,#10,#F4,#3A,#21,#51,#20,#42,#22,#21,#BE,#21,#B1,#E1,#21
	DB	#4D,#11,#90,#43,#21,#4B,#22,#4E,#01,#11,#E0,#47,#1F,#23,#4E,#12
	DB	#2F,#48,#24,#4F,#10,#4E,#49,#82,#78,#11,#12,#11,#ED,#10,#4E,#49
	DB	#10,#E2,#27,#10,#4C,#43,#10,#24,#4E,#22,#50,#10,#51,#41,#F9,#A1
	DB	#D2,#01,#11,#0A,#10,#4F,#3E,#82,#BB,#D2,#BE,#0B,#1F,#15,#85,#77
	DB	#0F,#7C,#0F,#F9,#0F,#5A,#00
AnimDelta:
	DW	Delta0,Delta1,Delta2,Delta3,Delta4,Delta5,Delta6,Delta7,0
	List
buffer:
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: ascii
  SELECT id INTO tag_uuid FROM tags WHERE name = 'ascii';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
