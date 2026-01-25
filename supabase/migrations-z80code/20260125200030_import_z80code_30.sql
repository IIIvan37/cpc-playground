-- Migration: Import z80code projects batch 30
-- Projects 59 to 60
-- Generated: 2026-01-25T21:43:30.192182

-- Project 59: line127 by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'line127',
    'Imported from z80Code. Author: tronic. draw',
    'public',
    false,
    false,
    '2021-02-10T16:01:04.551000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; This draws a line from (x0,y0) to (x1,y1), signed coordinates.
; Destroys:
; AF,BC,DE,HL
; LICENSING NOTE:
; This code is (heavily) modified from Axe''s open source code.
; There are structural similarities, but the majority of it is rewritten
; to be platform independent.
; 71 bytes

; Found here : https://github.com/Zeda/Z80-Optimized-Routines/blob/master/gfx/line.z80

; Very cool stuff there too :
; https://github.com/Zeda/Z80-Optimized-Routines
; https://github.com/Zeda/z80float
;
; Tronic/GPA


BUILDSNA
BANKSET 0
SNASET CPC_TYPE,2 

org #40
run $

	ld bc,#7f10:ld a,#6c:out (c),c:out (c),a
    
;Inputs:
;   (H,L) is (x0,y0)
;   (D,E) is (x1,y1)    

	ld h,0
	ld l,0
	ld d,64
	ld e,64
    call line

	ld h,127
	ld l,127
	ld d,64
	ld e,64
    call line

	ld h,127
	ld l,0
	ld d,64
	ld e,64
    call line

	ld h,0
	ld l,127
	ld d,64
	ld e,64
    call line

	ld h,0
	ld l,0
	ld d,127
	ld e,0
    call line
    
	ld h,127
	ld l,0
	ld d,127
	ld e,127
    call line  
    
	ld h,127
	ld l,127
	ld d,0
	ld e,127
    call line    
    
	ld h,0
	ld l,127
	ld d,0
	ld e,0
    call line      


	jr $    


line
  	ld a,d
	sub h
	jp p,nxt0
	ex de,hl
	neg
nxt0
  	push hl   ;Save the coordinates

  	ld c,a
	ld a,l
  	ld l,c
	sub e

  	ld c,0
	jp p,nxt1
	dec c
	neg
nxt1
	ld h,a     ; H=DY, L=DX
	cp l
	jr nc,nxt2
	ld a,l
nxt2
  	pop de     ;restore coordinates
	ld b,a     ; Pixel counter
	inc b
	cp h

	;want to preserve Z

	jr nz,__LineH   ; Line is rather horizontal than vertical
  	
    ;divide A by 2, given carry is reset
	rra

__LineVLoop:
  	call call_ix    ; plot
  	rlc c
  	jr nc,nxt3
  	inc e
 	db #FE          ; j''adore :)
nxt3
  	dec e
	sub	l			; Handling gradient
	jr	nc,nxt4
  	inc d
	add	a,h
nxt4
	djnz __LineVLoop
	jr fini

__LineH:

	;divide A by 2, given carry is set
	or a
	rra

__LineHLoop:
  	call call_ix    ; plot
	inc	d
	sub	h           ; Handling gradient
	jr nc,__LineHNext
  	rlc c
  	jr nc,nxt5
  	inc e
  	db #FE          ; j''adore :)
nxt5
  	dec e
	add	a,l
__LineHNext:
	djnz __LineHLoop

fini
	ret
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Quick plot adaptation...
;   IX points to the pixel plotting routine
;   Takes coordinates, (D,E) = (x,y) and plots the point.
;   preserves HL,DE,BC,A,IX

call_ix
	push af
	push bc
	push de
	push hl

	ld b,d
	ld c,e
	ld e,b
	ld l,c
	ld d,0
	ld h,0

; https://www.cpcwiki.eu/index.php/Programming:Fast_plot				
FPLOT	
    LD A, L			    ;A = Lowbyte Y
	AND %00000111		;isolate Bit 0..2
	LD H, A			    ;= y MOD 8 to H
	XOR L			    ;A = Bit 3..7 of Y
	LD L, A			    ;= (Y\8)*8 to L
	LD C, A			    ;store in C
	LD B,#60		    ;B = &C0\2 = Highbyte Screenstart\2
		
	ADD HL, HL		    ;HL * 2
	ADD HL, HL		    ;HL * 4
	ADD HL, BC		    ;+ BC = Startaddress
	ADD HL, HL		    ;of the raster line
		
	LD A, E			    ;Lowbyte X to A
	SRL D			    ;calculate X\4, because
	RR E			    ;4 pixel per byte
	SRL E
	ADD HL, DE		    ;+ HL = Screenaddress
		
	LD C,%10001000		;Bitmask for MODE 1
	AND %00000011		;A = X MOD 4
	JR Z,NSHIFT		    ;-> = 0, no shift
SHIFT 	
    SRL C			    ;move bitmask to pixel
	DEC A			    ;loop counter
	JR NZ,SHIFT		    ;-position
		
NSHIFT	
    LD A,#f0		    ; (CMASK)		;get color mask
	XOR (HL)		    ;XOR screenbyte
	AND C			    ;AND bitmask
	XOR (HL)		    ;XOR screenbyte
	LD (HL), A		    ;new screenbyte

	pop hl
	pop de
	pop bc
	pop af
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: draw
  SELECT id INTO tag_uuid FROM tags WHERE name = 'draw';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 60: oh_mummy by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'oh_mummy',
    'Imported from z80Code. Author: siko. Oh Mummy disassembled',
    'public',
    false,
    false,
    '2021-07-12T03:35:43.193000'::timestamptz,
    '2021-07-12T03:35:43.206000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '  org #6000
  start_6000:
  call #bca7 ; Firmware: SOUND_RESET
  ld a,#1
  ld hl,lab7FCA
  call #bcbc ; Firmware: SOUND_AMPL_ENVELOPE
  ld a,#1
  ld hl,lab7FE5
  call #bcbf ; Firmware: SOUND_TONE_ENVELOPE
  ld a,#2
  ld hl,lab7FD4
  call #bcbc ; Firmware: SOUND_AMPL_ENVELOPE
  ld a,#2
  ld hl,lab7FF5
  call #bcbf ; Firmware: SOUND_TONE_ENVELOPE
  ld a,#3
  ld hl,lab7FDE
  call #bcbc ; Firmware: SOUND_AMPL_ENVELOPE
  ld a,#3
  ld hl,lab7FF9
  call #bcbf ; Firmware: SOUND_TONE_ENVELOPE
  ld hl,lab905C
  ld (lab905A),hl
lab6039:
  call #bd0d ; Firmware: KL_TIME_PLEASE
  ld (lab8151),hl
  call lab78D1
  call lab78D1
  call lab78D1
  call lab78D1
  call lab7EAB
  call lab78D1
  call lab78D1
  ld a,#6
  ld (lab8169),a
  xor a
  ld (lab816C),a
  ld (lab8168),a
  call lab78D1
  call lab78D1
  ld hl,lab8653
  call lab7EF4
  call lab78D1
  call lab78D1
  call lab78D1
  call lab78D1
  ld ix,lab8ECA
  ld b,#c8
lab607E:
  ld de,data0000
  ld h,d
  ld l,b
  dec l
  push bc
  call #bc1d ; Firmware: SCR_DOT_POSITION
  ld (ix+0),l
  ld (ix+1),h
  inc ix
  inc ix
  pop bc
  djnz lab607E
  call lab78D1
  call lab78D1
  call lab78D1
  call lab78D1
  ld hl,lab8740
  call lab7EF4
  call lab78D1
  call lab78D1
  ld hl,#203
  ld de,#2604
  call lab7EB9
  call lab78D1
  ld hl,#408
  ld de,#2409
  call lab7EB9
  call lab78D1
  ld hl,#40d
  ld de,#80e
  call lab7EB9
  call lab78D1
  ld hl,#d0d
  ld de,#1b0e
  call lab7EB9
  call lab78D1
  ld hl,#200d
  ld de,#240e
  call lab7EB9
  call lab78D1
  ld hl,#412
  ld de,#2413
  call lab7EB9
  call lab78D1
  ld hl,#417
  ld de,#2418
  call lab7EB9
  call lab78D1
  ld hl,#205
  ld de,#318
  call lab7EB9
  call lab78D1
  ld hl,#905
  ld de,#a18
  call lab7EB9
  call lab78D1
  ld hl,#1005
  ld de,#1107
  call lab7EB9
  call lab78D1
  ld hl,#1705
  ld de,#1807
  call lab7EB9
  call lab78D1
  ld hl,#1e05
  ld de,#1f18
  call lab7EB9
  call lab78D1
  ld hl,#2505
  ld de,#2618
  call lab7EB9
  call lab78D1
  ld hl,#1014
  ld de,#1116
  call lab7EB9
  call lab78D1
  ld hl,#1714
  ld de,#1816
  call lab7EB9
  call lab78D1
  ld hl,data0000
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call lab78D1
  ld hl,#2808
  call lab7D85
  ld hl,#2816
  call lab7DFC
  call lab78D1
  ld hl,#2824
  call lab7DCD
  ld hl,#2832
  call lab7E0E
  call lab78D1
  ld hl,#2840
  call lab7D9D
  ld hl,#5008
  call lab7E29
  call lab78D1
  ld hl,lab889D
  call lab7EF4
  ld hl,#5040
  call lab7E29
  call lab78D1
  ld hl,lab7808
  call lab7E29
  ld hl,lab8906
  call lab7EF4
  call lab78D1
  ld hl,lab783E+2
  call lab7E29
  ld hl,#a008
  call lab7DCD
  call lab78D1
  ld hl,#a016
  call lab7E17
  ld hl,#a024
  call lab7DB5
  call lab78D1
  ld hl,#a032
  call lab7E05
  ld hl,#a040
  call lab7DCD
  call lab78D1
  ld hl,lab860F
  ld (lab8645),hl
  call lab794F
  call lab78D1
  ld hl,lab6826+2
  ld (lab8155),hl
  ld a,#2
  ld (lab8157),a
  ld a,#2
  ld (lab815E),a
lab6201:
  call #bb09 ; Firmware: KM_READ_CHAR
  ld b,#1
  call lab78B7
  call lab78F7
  call lab7893
  ld b,#2
  call lab78B7
  call lab78F7
  ld a,#3e
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab6223
  call lab7893
  jr lab6201
lab6223:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr c,lab6223
  ld hl,lab866D
  call lab7EF4
  call lab7EAB
  call lab78D1
  xor a
  ld (lab816C),a
  ld a,#6
  ld (lab8169),a
  ld hl,#803
  ld de,#1f14
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call #bb6c ; Firmware: TXT_CLEAR_WINDOW
  xor a
  call #bb96 ; Firmware: TXT_SET_PAPER
  ld hl,#c05
  ld de,#1b07
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call #bb6c ; Firmware: TXT_CLEAR_WINDOW
  call lab78D1
  ld hl,#a08
  ld de,#1d12
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call #bb6c ; Firmware: TXT_CLEAR_WINDOW
  ld de,#2812
  ld (lab8155),de
  ld a,#2
  ld (lab8157),a
  ld a,#41
  call lab7B39
  ld de,#283a
  ld (lab8155),de
  ld a,#4
  ld (lab8157),a
  ld a,#41
  call lab7B39
  ld a,#1
  call #bb96 ; Firmware: TXT_SET_PAPER
  ld hl,#601
  ld de,#716
  call lab7EB9
  call lab78D1
  ld hl,#2001
  ld de,#2116
  call lab7EB9
  ld hl,#801
  ld de,#1f02
  call lab7EB9
  call lab78D1
  ld hl,#815
  ld de,#1f16
  call lab7EB9
  ld hl,data0000
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  ld hl,lab8676
  call lab7EF4
  call lab78D1
  ld hl,#c0a
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,(lab868C)
  call lab786C
  ld hl,lab868E
  call lab7EF4
  ld hl,#c0c
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,(lab869E)
  call lab786C
  ld hl,lab86A0
  call lab7EF4
  call lab78D1
  ld hl,#c0e
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,(lab86B0)
  call lab786C
  ld hl,lab86B2
  call lab7EF4
  ld hl,#c10
  call #bb75 ; Firmware: TXT_SET_CURSOR
  call lab78D1
  ld hl,(lab86C2)
  call lab786C
  ld hl,lab86C4
  call lab7EF4
  ld hl,#c12
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,(lab86D4)
  call lab786C
  ld hl,lab86D6
  call lab7EF4
  ld hl,lab8637
  ld (lab8645),hl
  call lab794F
  ld hl,lab6826+2
  ld (lab8155),hl
  call lab78D1
  ld a,(lab8168)
  or a
  jr z,lab636C
  ld hl,lab8710
  call lab7EF4
  xor a
  call #bb96 ; Firmware: TXT_SET_PAPER
  ld hl,(lab7FC6)
  call #bb75 ; Firmware: TXT_SET_CURSOR
  xor a
  ld (lab8649),a
  ld a,#8f
  call #bb5a ; Firmware: TXT_OUTPUT
  ld hl,(lab7FC6)
  call #bb75 ; Firmware: TXT_SET_CURSOR
lab6365:
  call #bb09 ; Firmware: KM_READ_CHAR
  jr c,lab6365
  jr lab6372
lab636C:
  ld hl,lab86E8
  call lab7EF4
lab6372:
  ld b,#1
  call lab78B7
  ld b,#2
  call lab78B7
  ld a,(lab8168)
  or a
  jp z,lab6404
  call #bb09 ; Firmware: KM_READ_CHAR
  jr nc,lab6372
  cp #d
  jr z,lab63F3
  cp #7f
  jr z,lab63C4
  ld b,a
  ld a,(lab8649)
  cp #c
  jr z,lab6372
  ld a,b
  cp #20
  jr c,lab6372
  cp #80
  jr nc,lab6372
  ld hl,(lab7FC8)
  ld (hl),a
  inc hl
  ld (lab7FC8),hl
  call #bb5a ; Firmware: TXT_OUTPUT
  ld a,#8f
  call #bb5a ; Firmware: TXT_OUTPUT
  ld hl,(lab7FC6)
  inc h
  ld (lab7FC6),hl
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld a,(lab8649)
  inc a
  ld (lab8649),a
  jr lab6372
lab63C4:
  ld a,(lab8649)
  or a
  jr z,lab6372
  dec a
  ld (lab8649),a
  ld hl,(lab7FC8)
  dec hl
  ld a,#20
  ld (hl),a
  ld (lab7FC8),hl
  call #bb5a ; Firmware: TXT_OUTPUT
  ld hl,(lab7FC6)
  dec h
  ld (lab7FC6),hl
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld a,#8f
  call #bb5a ; Firmware: TXT_OUTPUT
  ld hl,(lab7FC6)
  call #bb75 ; Firmware: TXT_SET_CURSOR
  jp lab6372
lab63F3:
  ld a,#20
  call #bb5a ; Firmware: TXT_OUTPUT
  xor a
  ld (lab8168),a
  ld a,#3
  call #bb96 ; Firmware: TXT_SET_PAPER
  jp lab636C
lab6404:
  call #bb09 ; Firmware: KM_READ_CHAR
  jp nc,lab6372
  cp #50
  jp z,lab6529
  cp #70
  jp z,lab6529
  cp #49
  jp z,lab68B2
  cp #69
  jp z,lab68B2
  cp #4f
  jp z,lab642B
  cp #6f
  jp z,lab642B
  jp lab6372
lab642B:
  call #bb09 ; Firmware: KM_READ_CHAR
  jr c,lab642B
  ld hl,lab7EFD
  call lab7EF4
lab6436:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr nc,lab6436
  cp #31
  jr c,lab6436
  cp #36
  jr nc,lab6436
  call #bb5a ; Firmware: TXT_OUTPUT
  sub #30
  ld hl,#100
  ld de,#e0
  ld b,a
lab6452:
  add hl,de
  djnz lab6452
  ld (lab8153),hl
  ld hl,lab7F4C
  call lab7EF4
lab645E:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr nc,lab645E
  cp #31
  jr c,lab645E
  cp #36
  jr nc,lab645E
  call #bb5a ; Firmware: TXT_OUTPUT
  sub #30
  ld b,a
  ld hl,#7f8
lab6477:
  add hl,hl
  djnz lab6477
  ld a,h
  ld (lab8161),a
  ld hl,lab7F82
  call lab7EF4
lab6484:
  call lab78D1
  ld a,#2b
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab64AB
  ld a,#2e
  call #bb1e ; Firmware: KM_TEST_KEY
  jr z,lab6484
  ld a,#4e
  ld (lab7FC4),a
  ld hl,lab7FC1
  call lab7EF4
  call #bca7 ; Firmware: SOUND_RESET
  ld hl,lab905C
  ld (lab905A),hl
  jr lab64C6
lab64AB:
  ld a,(lab7FC4)
  cp #4e
  jr nz,lab64BB
  call #bca7 ; Firmware: SOUND_RESET
  ld hl,lab905C
  ld (lab905A),hl
lab64BB:
  ld a,#59
  ld (lab7FC4),a
  ld hl,lab7FBD
  call lab7EF4
lab64C6:
  call lab78D1
  ld a,#2b
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab64C6
  ld a,#2e
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab64C6
lab64D7:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr c,lab64D7
  ld hl,lab7FA1
  call lab7EF4
lab64E5:
  call lab78D1
  ld a,#2b
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab6503
  ld a,#2e
  call #bb1e ; Firmware: KM_TEST_KEY
  jr z,lab64E5
  ld a,#4e
  ld (lab7FC5),a
  ld hl,lab7FC1
  call lab7EF4
  jr lab650E
lab6503:
  ld a,#59
  ld (lab7FC5),a
  ld hl,lab7FBD
  call lab7EF4
lab650E:
  ld hl,lab80FB
  call lab7EF4
lab6514:
  call lab78D1
  ld a,#4c
  call #bb1e ; Firmware: KM_TEST_KEY
  jp nz,lab6223
  ld a,#3e
  call #bb1e ; Firmware: KM_TEST_KEY
  jp nz,lab6223
  jr lab6514
lab6529:
  ld a,#5
  ld (lab816A),a
  ld hl,data0000
  ld (lab815A),hl
lab6534:
  xor a
  ld (lab815C),a
  ld (lab8169),a
  ld hl,(lab815A)
  ld a,h
  or l
  jr z,lab654C
  ld a,(lab8161)
  srl a
  or #3
  ld (lab8161),a
lab654C:
  call lab7EAB
  ld de,#c8
lab6552:
  push de
  call lab78D1
  pop de
  dec de
  ld a,d
  or e
  jr nz,lab6552
  ld a,(lab8169)
  inc a
  ld (lab8169),a
  ld a,(lab815C)
  inc a
  ld (lab815C),a
  cp #6
  jp z,lab6739
  xor a
  ld (lab816C),a
  ld (lab816D),a
  ld (lab816E),a
  ld (lab816F),a
  ld (lab8170),a
  ld (lab8171),a
  ld (lab8158),a
  ld hl,lab81DE
  ld a,#60
  ld (hl),a
  ld de,lab81DF
  ld bc,#19
  ldir
  xor a
  ld iy,lab81D6
  ld (iy+13),a
  ld (iy+14),a
  ld (iy+20),a
  ld (iy+21),a
  ld (iy+27),a
  ld (iy+28),a
  call lab78D1
  ld b,#e
  ld a,#10
lab65B1:
  push bc
  push af
lab65B3:
  ld a,#1a
  call lab7D53
  ld b,#8
  add a,b
  ld hl,lab81D6
  ld b,#0
  ld c,a
  add hl,bc
  ld a,(hl)
  cp #60
  jr nz,lab65B3
  pop af
  ld (hl),a
  pop bc
  cp #50
  jr z,lab65D0
  add a,#10
lab65D0:
  djnz lab65B1
  call lab78D1
  ld hl,lab8764
  call lab7EF4
  call lab7863
  ld a,#1
  call #bb96 ; Firmware: TXT_SET_PAPER
  ld a,(lab816A)
  ld b,a
  ld a,#2
  ld (lab8157),a
  ld de,#34
  ld (lab8155),de
lab65F3:
  push bc
  ld a,#41
  call lab7B39
  ld a,(lab8158)
  xor #1
  ld (lab8158),a
  call lab78D1
  ld de,(lab8155)
  ld hl,data0000+4
  add hl,de
  ld (lab8155),hl
  ex de,hl
  pop bc
  djnz lab65F3
  call lab78D1
  ld hl,#203
  ld de,#2604
  call lab7EB9
  ld hl,#408
  ld de,#2409
  call lab7EB9
  ld hl,#40d
  ld de,#240e
  call lab7EB9
  ld hl,#412
  ld de,#2413
  call lab7EB9
  ld hl,#217
  ld de,#2618
  call lab7EB9
  call lab78D1
  ld hl,#205
  ld de,#316
  call lab7EB9
  ld hl,#905
  ld de,#a16
  call lab7EB9
  ld hl,#1001
  ld de,#1116
  call lab7EB9
  ld hl,#1705
  ld de,#1816
  call lab7EB9
  ld hl,#1e05
  ld de,#1f16
  call lab7EB9
  ld hl,#2505
  ld de,#2616
  call lab7EB9
  ld hl,data0000
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  ld a,(lab815C)
  cp #2
  jr c,lab66A8
  jr z,lab66A3
  cp #4
  jr c,lab669E
  jr z,lab6699
  ld hl,lab7E0E
  jr lab66AB
lab6699:
  ld hl,lab7DFC
  jr lab66AB
lab669E:
  ld hl,lab7E20
  jr lab66AB
lab66A3:
  ld hl,lab7E17
  jr lab66AB
lab66A8:
  ld hl,lab7E29
lab66AB:
  ld (lab66B9+1),hl
  ld b,#4
  ld hl,#2808
lab66B3:
  push bc
  push hl
  ld b,#5
lab66B7:
  push bc
  push hl
lab66B9:
  call lab7E29
  call lab78D1
  pop hl
  ld bc,#e
  add hl,bc
  pop bc
  djnz lab66B7
  pop hl
  ld bc,#2800
  add hl,bc
  pop bc
  djnz lab66B3
  ld hl,lab860F
  ld (lab8645),hl
  call lab794F
  ld de,#820
  ld (lab8155),de
  ld a,#3
  ld (lab8157),a
  ld a,#41
  call lab7B39
  xor a
  call #bb96 ; Firmware: TXT_SET_PAPER
lab66ED:
  ld a,#42
  call #bb1e ; Firmware: KM_TEST_KEY
  jp nz,lab68AF
lab66F5:
  ld b,#1
  call lab78B7
  call lab7578
  jp c,lab67B3
  call lab77D1
  call lab7578
  jp c,lab67B3
  call lab7637
  call lab7566
  call lab7893
  ld a,(lab816D)
  or a
  call nz,lab7513
  ld b,#2
  call lab78B7
  call lab7578
  jp c,lab67B3
  call lab77D1
  call lab7578
  jp c,lab67B3
  call lab7637
  call lab7566
  call lab7893
  jp lab66ED
lab6739:
  call lab78D1
  ld hl,lab801B
  call lab7EF4
  ld hl,lab8040
  call lab7EF4
  ld hl,lab8064
  call lab7EF4
  ld hl,lab8088
  call lab7EF4
  call lab78D1
  ld hl,lab809D
  call lab7EF4
  ld a,#2
  call lab7D53
  or a
  jr z,lab677E
lab6765:
  ld hl,(lab815A)
  ld bc,#c8
  add hl,bc
  ld (lab815A),hl
  ld hl,lab80B8
  call lab7EF4
  ld hl,lab80C2
  call lab7EF4
  jp lab6795
lab677E:
  ld a,(lab816A)
  cp #7
  jr z,lab6765
  inc a
  ld (lab816A),a
  ld hl,lab80E0
  call lab7EF4
  ld hl,lab80EA
  call lab7EF4
lab6795:
  call lab78D1
  ld hl,lab80FB
  call lab7EF4
lab679E:
  call lab78D1
  ld a,#4c
  call #bb1e ; Firmware: KM_TEST_KEY
  jp nz,lab6534
  ld a,#3e
  call #bb1e ; Firmware: KM_TEST_KEY
  jp nz,lab6534
  jr lab679E
lab67B3:
  ld hl,lab8125
  call lab7EF4
  ld hl,#90a
  ld de,#1f11
  call lab7EB9
  call lab78D1
  ld hl,data0000
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  ld hl,#d0e
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,lab812D
  ld b,#9
lab67D9:
  push bc
  push hl
  ld de,#400
lab67DE:
  push de
  call lab78D1
  pop de
  dec de
  ld a,d
  or e
  jr nz,lab67DE
  pop hl
  ld a,(hl)
  inc hl
  call #bb5a ; Firmware: TXT_OUTPUT
  ld a,#20
  call #bb5a ; Firmware: TXT_OUTPUT
  pop bc
  djnz lab67D9
  ld de,#4000
lab67F9:
  push de
  call lab78D1
  pop de
  dec de
  ld a,d
  or e
  jr nz,lab67F9
  xor a
  ld hl,(lab815A)
  ld bc,(lab86D4)
  sbc hl,bc
  jp c,lab6039
  ld a,#1
  ld (lab8168),a
  ld de,#12
  ld ix,lab86D4
  xor a
  ld b,#5
lab681F:
  push bc
  ld hl,(lab815A)
  ld c,(ix+0)
lab6826:
  ld b,(ix+1)
  sbc hl,bc
  pop bc
  jr z,lab683B
  jr c,lab683A
  push ix
  pop hl
  sbc hl,de
  push hl
  pop ix
  djnz lab681F
lab683A:
  inc b
lab683B:
  ld a,b
  add a,a
  add a,#8
  ld h,#12
  ld l,a
  ld (lab7FC6),hl
  ld hl,lab86D4
  ld a,#5
  cp b
  jr z,lab6893
  sub b
  ld b,a
  push bc
  call lab78D1
  pop bc
  ld hl,lab86C2
  ld de,lab86D4
lab685A:
  push bc
  ld bc,#12
  ldir
  xor a
  ld bc,#24
  sbc hl,bc
  ex de,hl
  sbc hl,bc
  ex de,hl
  pop bc
  djnz lab685A
  push hl
  call lab78D1
  pop hl
  ld bc,#12
  add hl,bc
  push hl
  ld hl,lab8691
  ld a,#a
  ld (hl),a
  add hl,bc
  ld a,#c
  ld (hl),a
  add hl,bc
  ld a,#e
  ld (hl),a
  add hl,bc
  ld a,#10
  ld (hl),a
  add hl,bc
  ld a,#12
  ld (hl),a
  ld hl,lab86D6
  dec a
  ld (hl),a
  pop hl
lab6893:
  ld de,(lab815A)
  ld (hl),e
  inc hl
  ld (hl),d
  ld bc,data0000+5
  add hl,bc
  ld (lab7FC8),hl
  ld a,#20
  ld (hl),a
  push hl
  pop de
  inc de
  ld bc,#b
  ldir
  jp lab6223
lab68AF:
  jp lab66F5
lab68B2:
  ld hl,data69eb
  call lab69D2
  call lab698A
  call lab78D1
  call lab78D1
  ld hl,data0000+4
  call lab7D85
  call lab78D1
  call lab78D1
  ld hl,#42
  call lab7D9D
  ld hl,lab69F4
  call lab69D2
  ld hl,lab6A0F
  call lab69D2
  ld hl,lab6ABA
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab6B78
  call lab69D2
  ld hl,lab6BEC
  call lab69D2
  ld hl,lab6C75
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab6CE0
  call lab69D2
  ld hl,lab6D3A
  call lab69D2
  ld hl,lab6DA2
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab6E0A
  call lab69D2
  ld hl,lab6E96
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab6F7D
  call lab69D2
  ld hl,lab703C
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab70AE
  call lab69D2
  ld hl,lab7170
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab71F4
  call lab69D2
  ld hl,lab7288
  call lab69D2
  call lab69AC
  call lab698A
  ld hl,lab736E
  call lab69D2
  ld hl,lab738D
  call lab69D2
  ld hl,lab73DD
  call lab69D2
  ld hl,lab7424
  call lab69D2
  ld hl,lab74E7
  call lab69D2
  call lab69AC
  call lab699C
  jp lab6223
lab698A:
  call lab78D1
  call lab78D1
  ld hl,data0000+5
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call #bb6c ; Firmware: TXT_CLEAR_WINDOW
lab699C:
  ld hl,data0000
  ld de,#2718
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call lab78D1
  call lab78D1
  ret
lab69AC:
  call lab78D1
  call lab78D1
  ld hl,lab80FB
  call lab69D2
lab69B8:
  call lab78D1
  ld a,#4c
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab69C9
  ld a,#3e
  call #bb1e ; Firmware: KM_TEST_KEY
  jr z,lab69B8
lab69C9:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  ret nc
  jr lab69C9
lab69D2:
  ld b,(hl)
lab69D3:
  inc hl
  ld a,(hl)
  cp #1f
  jr nz,lab69E5
  push af
  push bc
  push hl
  call lab78D1
  call lab78D1
  pop hl
  pop bc
  pop af
lab69E5:
  call #bb5a ; Firmware: TXT_OUTPUT
  djnz lab69D3
  ret
data69eb:
  db #08,#0e,#00,#0c,#1d,#18,#18,#0e
  db #01
lab69F4:
  db #1a,#0e,#00,#0f,#03,#1f,#0c,#02
  db #4f,#48,#20,#4d,#55,#4d,#4d,#59 ;OH.MUMMY
  db #20,#2d,#20,#53,#43,#45,#4e,#41 ;...SCENA
  db #52,#49,#4f ;RIO
lab6A0F:
  db #aa,#0e,#01,#0f,#00,#1f,#05,#08
  db #59,#6f,#75,#20,#68,#61,#76,#65 ;You.have
  db #20,#62,#65,#65,#6e,#20,#61,#70 ;.been.ap
  db #70,#6f,#69,#6e,#74,#65,#64,#20 ;pointed.
  db #68,#65,#61,#64,#20,#6f,#66,#20 ;head.of.
  db #61,#6e,#1f,#03,#09,#61,#72,#63 ;an...arc
  db #68,#65,#6f,#6c,#6f,#67,#69,#63 ;heologic
  db #61,#6c,#20,#65,#78,#70,#65,#64 ;al.exped
  db #69,#74,#69,#6f,#6e,#2c,#20,#20 ;ition...
  db #73,#70,#6f,#6e,#73,#6f,#72,#65 ;sponsore
  db #64,#1f,#03,#0a,#62,#79,#20,#74 ;d...by.t
  db #68,#65,#20,#42,#72,#69,#74,#69 ;he.Briti
  db #73,#68,#20,#4d,#75,#73,#65,#75 ;sh.Museu
  db #6d,#2c,#20,#61,#6e,#64,#20,#68 ;m..and.h
  db #61,#76,#65,#20,#62,#65,#65,#6e ;ave.been
  db #1f,#03,#0b,#73,#65,#6e,#74,#20 ;...sent.
  db #74,#6f,#20,#45,#67,#79,#70,#74 ;to.Egypt
  db #20,#74,#6f,#20,#65,#78,#70,#6c ;.to.expl
  db #6f,#72,#65,#20,#6e,#65,#77,#6c ;ore.newl
  db #79,#20,#66,#6f,#75,#6e,#64,#1f ;y.found.
  db #03,#0c,#70,#79,#72,#61,#6d,#69 ;..pyrami
  db #64,#73,#2e ;ds.
lab6ABA:
  db #bd,#1f,#05,#0f,#59,#6f,#75,#72 ;....Your
  db #20,#70,#61,#72,#74,#79,#2c,#20 ;.party..
  db #69,#6e,#69,#74,#69,#61,#6c,#6c ;initiall
  db #79,#2c,#20,#63,#6f,#6e,#73,#69 ;y..consi
  db #73,#74,#73,#20,#6f,#66,#1f,#03 ;sts.of..
  db #10,#66,#69,#76,#65,#20,#6d,#65 ;.five.me
  db #6d,#62,#65,#72,#73,#2e,#20,#20 ;mbers...
  db #59,#6f,#75,#72,#20,#74,#61,#73 ;Your.tas
  db #6b,#20,#69,#73,#20,#74,#6f,#20 ;k.is.to.
  db #65,#6e,#74,#65,#72,#1f,#03,#11 ;enter...
  db #74,#68,#65,#20,#66,#69,#76,#65 ;the.five
  db #20,#6c,#65,#76,#65,#6c,#73,#20 ;.levels.
  db #6f,#66,#20,#65,#61,#63,#68,#20 ;of.each.
  db #70,#79,#72,#61,#6d,#69,#64,#2c ;pyramid.
  db #20,#61,#6e,#64,#1f,#03,#12,#72 ;.and...r
  db #65,#63,#6f,#76,#65,#72,#20,#66 ;ecover.f
  db #72,#6f,#6d,#20,#74,#68,#65,#6d ;rom.them
  db #20,#66,#69,#76,#65,#20,#52,#6f ;.five.Ro
  db #79,#61,#6c,#20,#4d,#75,#6d,#6d ;yal.Mumm
  db #69,#65,#73,#1f,#03,#13,#61,#6e ;ies...an
  db #64,#20,#61,#73,#20,#6d,#75,#63 ;d.as.muc
  db #68,#20,#74,#72,#65,#61,#73,#75 ;h.treasu
  db #72,#65,#20,#61,#73,#20,#79,#6f ;re.as.yo
  db #75,#20,#63,#61,#6e,#2e ;u.can.
lab6B78:
  db #73,#1f,#05,#08,#0f,#00,#45,#61 ;s.....Ea
  db #63,#68,#20,#6c,#65,#76,#65,#6c ;ch.level
  db #20,#68,#61,#73,#20,#61,#6c,#72 ;.has.alr
  db #65,#61,#64,#79,#20,#62,#65,#65 ;eady.bee
  db #6e,#20,#70,#61,#72,#74,#6c,#79 ;n.partly
  db #1f,#03,#09,#75,#6e,#63,#6f,#76 ;...uncov
  db #65,#72,#65,#64,#20,#62,#79,#20 ;ered.by.
  db #6c,#6f,#63,#61,#6c,#20,#77,#6f ;local.wo
  db #72,#6b,#65,#72,#73,#20,#61,#6e ;rkers.an
  db #64,#20,#69,#74,#20,#69,#73,#1f ;d.it.is.
  db #03,#0a,#75,#70,#20,#74,#6f,#20 ;..up.to.
  db #79,#6f,#75,#72,#20,#74,#65,#61 ;your.tea
  db #6d,#20,#74,#6f,#20,#66,#69,#6e ;m.to.fin
  db #69,#73,#68,#20,#74,#68,#65,#20 ;ish.the.
  db #64,#69,#67,#2e ;dig.
lab6BEC:
  db #88,#1f,#05,#0d,#55,#6e,#66,#6f ;....Unfo
  db #72,#74,#75,#6e,#61,#74,#65,#6c ;rtunatel
  db #79,#2c,#20,#74,#68,#65,#20,#77 ;y..the.w
  db #6f,#72,#6b,#65,#72,#73,#20,#64 ;orkers.d
  db #69,#67,#67,#69,#6e,#67,#1f,#03 ;igging..
  db #0e,#61,#72,#6f,#75,#73,#65,#64 ;.aroused
  db #20,#47,#75,#61,#72,#64,#69,#61 ;.Guardia
  db #6e,#73,#20,#6c,#65,#66,#74,#20 ;ns.left.
  db #62,#65,#68,#69,#6e,#64,#20,#62 ;behind.b
  db #79,#20,#74,#68,#65,#1f,#03,#0f ;y.the...
  db #61,#6e,#63,#69,#65,#6e,#74,#20 ;ancient.
  db #45,#67,#79,#70,#74,#69,#61,#6e ;Egyptian
  db #20,#50,#68,#61,#72,#6f,#61,#68 ;.Pharoah
  db #73,#20,#74,#6f,#20,#70,#72,#6f ;s.to.pro
  db #74,#65,#63,#74,#1f,#03,#10,#74 ;tect...t
  db #68,#65,#69,#72,#20,#72,#6f,#79 ;heir.roy
  db #61,#6c,#20,#74,#6f,#6d,#62,#73 ;al.tombs
  db #2e
lab6C75:
  db #6a,#1f,#05,#13,#45,#61,#63,#68 ;j...Each
  db #20,#6c,#65,#76,#65,#6c,#20,#68 ;.level.h
  db #61,#73,#20,#32,#20,#47,#75,#61 ;as...Gua
  db #72,#64,#69,#61,#6e,#20,#4d,#75 ;rdian.Mu
  db #6d,#6d,#69,#65,#73,#2c,#1f,#03 ;mmies...
  db #14,#6f,#6e,#65,#20,#6c,#69,#65 ;.one.lie
  db #73,#20,#68,#69,#64,#64,#65,#6e ;s.hidden
  db #20,#77,#68,#69,#6c,#65,#20,#74 ;.while.t
  db #68,#65,#20,#6f,#74,#68,#65,#72 ;he.other
  db #20,#67,#6f,#65,#73,#1f,#03,#15 ;.goes...
  db #69,#6e,#20,#73,#65,#61,#72,#63 ;in.searc
  db #68,#20,#6f,#66,#20,#74,#68,#65 ;h.of.the
  db #20,#69,#6e,#74,#72,#75,#64,#65 ;.intrude
  db #72,#73,#2e ;rs.
lab6CE0:
  db #59,#1f,#05,#08,#0f,#00,#54,#68 ;Y.....Th
  db #65,#20,#70,#61,#72,#74,#6c,#79 ;e.partly
  db #20,#65,#78,#63,#61,#76,#61,#74 ;.excavat
  db #65,#64,#20,#6c,#65,#76,#65,#6c ;ed.level
  db #73,#20,#61,#72,#65,#20,#69,#6e ;s.are.in
  db #1f,#03,#09,#74,#68,#65,#20,#66 ;...the.f
  db #6f,#72,#6d,#20,#6f,#66,#20,#61 ;orm.of.a
  db #20,#67,#72,#69,#64,#20,#6d,#61 ;.grid.ma
  db #64,#65,#20,#75,#70,#20,#6f,#66 ;de.up.of
  db #20,#74,#77,#65,#6e,#74,#79,#1f ;.twenty.
  db #03,#0a,#27,#62,#6f,#78,#65,#73 ;...boxes
  db #27,#2e
lab6D3A:
  db #67,#1f,#05,#0d,#54,#6f,#20,#75 ;g...To.u
  db #6e,#63,#6f,#76,#65,#72,#20,#61 ;ncover.a
  db #20,#27,#62,#6f,#78,#27,#2c,#20 ;..box...
  db #6d,#6f,#76,#65,#20,#79,#6f,#75 ;move.you
  db #72,#20,#74,#65,#61,#6d,#1f,#03 ;r.team..
  db #0e,#61,#6c,#6f,#6e,#67,#20,#74 ;.along.t
  db #68,#65,#20,#66,#6f,#75,#72,#20 ;he.four.
  db #73,#69,#64,#65,#73,#20,#6f,#66 ;sides.of
  db #20,#74,#68,#65,#20,#62,#6f,#78 ;.the.box
  db #20,#66,#72,#6f,#6d,#1f,#03,#0f ;.from...
  db #65,#61,#63,#68,#20,#63,#6f,#72 ;each.cor
  db #6e,#65,#72,#20,#74,#6f,#20,#74 ;ner.to.t
  db #68,#65,#20,#6e,#65,#78,#74,#2e ;he.next.
lab6DA2:
  db #67,#1f,#05,#12,#4e,#6f,#74,#20 ;g...Not.
  db #61,#6c,#6c,#20,#62,#6f,#78,#65 ;all.boxe
  db #73,#20,#6e,#65,#65,#64,#20,#74 ;s.need.t
  db #6f,#20,#62,#65,#20,#75,#6e,#63 ;o.be.unc
  db #6f,#76,#65,#72,#65,#64,#1f,#03 ;overed..
  db #13,#74,#6f,#20,#65,#6e,#61,#62 ;.to.enab
  db #6c,#65,#20,#79,#6f,#75,#20,#74 ;le.you.t
  db #6f,#20,#67,#6f,#20,#74,#68,#72 ;o.go.thr
  db #6f,#75,#67,#68,#20,#74,#68,#65 ;ough.the
  db #20,#45,#78,#69,#74,#1f,#03,#14 ;.Exit...
  db #61,#6e,#64,#20,#69,#6e,#74,#6f ;and.into
  db #20,#74,#68,#65,#20,#6e,#65,#78 ;.the.nex
  db #74,#20,#6c,#65,#76,#65,#6c,#2e ;t.level.
lab6E0A:
  db #8b,#1f,#05,#08,#0f,#00,#45,#61 ;......Ea
  db #63,#68,#20,#6c,#65,#76,#65,#6c ;ch.level
  db #20,#63,#6f,#6e,#74,#61,#69,#6e ;.contain
  db #73,#2c,#20,#20,#74,#65,#6e,#20 ;s...ten.
  db #54,#72,#65,#61,#73,#75,#72,#65 ;Treasure
  db #1f,#03,#09,#62,#6f,#78,#65,#73 ;...boxes
  db #2c,#20,#73,#69,#78,#20,#65,#6d ;..six.em
  db #70,#74,#79,#20,#62,#6f,#78,#65 ;pty.boxe
  db #73,#2c,#20,#61,#6e,#64,#20,#74 ;s..and.t
  db #68,#65,#20,#72,#65,#73,#74,#1f ;he.rest.
  db #03,#0a,#68,#6f,#6c,#64,#20,#61 ;..hold.a
  db #20,#52,#6f,#79,#61,#6c,#20,#4d ;.Royal.M
  db #75,#6d,#6d,#79,#2c,#20,#61,#20 ;ummy..a.
  db #47,#75,#61,#72,#64,#69,#61,#6e ;Guardian
  db #20,#4d,#75,#6d,#6d,#79,#1f,#03 ;.Mummy..
  db #0b,#61,#20,#4b,#65,#79,#20,#61 ;.a.Key.a
  db #6e,#64,#20,#61,#20,#53,#63,#72 ;nd.a.Scr
  db #6f,#6c,#6c,#2e ;oll.
lab6E96:
  db #e6,#1f,#05,#0e,#49,#66,#20,#79 ;....If.y
  db #6f,#75,#20,#75,#6e,#63,#6f,#76 ;ou.uncov
  db #65,#72,#20,#74,#68,#65,#20,#62 ;er.the.b
  db #6f,#78,#20,#68,#6f,#6c,#64,#69 ;ox.holdi
  db #6e,#67,#20,#74,#68,#65,#1f,#03 ;ng.the..
  db #0f,#47,#75,#61,#72,#64,#69,#61 ;.Guardia
  db #6e,#20,#4d,#75,#6d,#6d,#79,#2c ;n.Mummy.
  db #20,#69,#74,#20,#77,#69,#6c,#6c ;.it.will
  db #20,#64,#69,#67,#20,#69,#74,#27 ;.dig.it.
  db #73,#20,#77,#61,#79,#1f,#03,#10 ;s.way...
  db #6f,#75,#74,#20,#61,#6e,#64,#20 ;out.and.
  db #70,#65,#72,#73,#75,#65,#20,#79 ;persue.y
  db #6f,#75,#2e,#20,#20,#42,#65,#69 ;ou...Bei
  db #6e,#67,#20,#63,#61,#75,#67,#68 ;ng.caugh
  db #74,#20,#62,#79,#1f,#03,#11,#61 ;t.by...a
  db #20,#47,#75,#61,#72,#64,#69,#61 ;.Guardia
  db #6e,#20,#4d,#75,#6d,#6d,#79,#20 ;n.Mummy.
  db #6b,#69,#6c,#6c,#73,#20,#6f,#6e ;kills.on
  db #65,#20,#6d,#65,#6d,#62,#65,#72 ;e.member
  db #20,#6f,#66,#1f,#03,#12,#79,#6f ;.of...yo
  db #75,#72,#20,#74,#65,#61,#6d,#20 ;ur.team.
  db #61,#6e,#64,#20,#74,#68,#65,#20 ;and.the.
  db #4d,#75,#6d,#6d,#79,#2c,#20,#75 ;Mummy..u
  db #6e,#6c,#65,#73,#73,#20,#74,#68 ;nless.th
  db #61,#74,#1f,#03,#13,#69,#73,#2c ;at...is.
  db #20,#79,#6f,#75,#20,#68,#61,#76 ;.you.hav
  db #65,#20,#75,#6e,#63,#6f,#76,#65 ;e.uncove
  db #72,#65,#64,#20,#74,#68,#65,#20 ;red.the.
  db #53,#63,#72,#6f,#6c,#6c,#2e ;Scroll.
lab6F7D:
  db #be,#1f,#05,#08,#0f,#00,#54,#68 ;......Th
  db #65,#20,#4d,#61,#67,#69,#63,#20 ;e.Magic.
  db #53,#63,#72,#6f,#6c,#6c,#20,#77 ;Scroll.w
  db #69,#6c,#6c,#20,#61,#6c,#6c,#6f ;ill.allo
  db #77,#20,#79,#6f,#75,#20,#74,#6f ;w.you.to
  db #1f,#03,#09,#62,#65,#20,#63,#61 ;...be.ca
  db #75,#67,#68,#74,#20,#62,#79,#20 ;ught.by.
  db #61,#20,#47,#75,#61,#72,#64,#69 ;a.Guardi
  db #61,#6e,#2c,#20,#77,#69,#74,#68 ;an..with
  db #6f,#75,#74,#20,#61,#6e,#79,#1f ;out.any.
  db #03,#0a,#68,#61,#72,#6d,#20,#74 ;..harm.t
  db #6f,#20,#79,#6f,#75,#72,#20,#74 ;o.your.t
  db #65,#61,#6d,#2e,#20,#20,#54,#68 ;eam...Th
  db #65,#20,#53,#63,#72,#6f,#6c,#6c ;e.Scroll
  db #20,#77,#6f,#72,#6b,#73,#1f,#03 ;.works..
  db #0b,#6f,#6e,#6c,#79,#20,#6f,#6e ;.only.on
  db #20,#74,#68,#65,#20,#6c,#65,#76 ;.the.lev
  db #65,#6c,#20,#6f,#6e,#20,#77,#68 ;el.on.wh
  db #69,#63,#68,#20,#66,#6f,#75,#6e ;ich.foun
  db #64,#2c,#20,#69,#74,#1f,#03,#0c ;d..it...
  db #77,#69,#6c,#6c,#20,#6f,#6e,#6c ;will.onl
  db #79,#20,#64,#65,#73,#74,#72,#6f ;y.destro
  db #79,#20,#6f,#6e,#65,#20,#47,#75 ;y.one.Gu
  db #61,#72,#64,#69,#61,#6e,#2e ;ardian.
lab703C:
  db #71,#1f,#05,#0f,#54,#68,#65,#72 ;q...Ther
  db #65,#20,#61,#72,#65,#20,#74,#77 ;e.are.tw
  db #6f,#20,#77,#61,#79,#73,#20,#74 ;o.ways.t
  db #6f,#20,#67,#61,#69,#6e,#20,#70 ;o.gain.p
  db #6f,#69,#6e,#74,#73,#2c,#1f,#03 ;oints...
  db #10,#6f,#6e,#65,#20,#69,#73,#20 ;.one.is.
  db #62,#79,#20,#75,#6e,#63,#6f,#76 ;by.uncov
  db #65,#72,#69,#6e,#67,#20,#74,#68 ;ering.th
  db #65,#20,#52,#6f,#79,#61,#6c,#20 ;e.Royal.
  db #4d,#75,#6d,#6d,#79,#1f,#03,#11 ;Mummy...
  db #74,#68,#65,#20,#6f,#74,#68,#65 ;the.othe
  db #72,#2c,#20,#62,#79,#20,#75,#6e ;r..by.un
  db #63,#6f,#76,#65,#72,#69,#6e,#67 ;covering
  db #20,#54,#72,#65,#61,#73,#75,#72 ;.Treasur
  db #65,#2e ;e.
lab70AE:
  db #c1,#1f,#05,#08,#0f,#00,#57,#68 ;......Wh
  db #65,#6e,#20,#74,#68,#65,#20,#62 ;en.the.b
  db #6f,#78,#65,#73,#20,#68,#6f,#6c ;oxes.hol
  db #64,#69,#6e,#67,#20,#74,#68,#65 ;ding.the
  db #20,#4b,#65,#79,#20,#61,#6e,#64 ;.Key.and
  db #1f,#03,#09,#74,#68,#65,#20,#52 ;...the.R
  db #6f,#79,#61,#6c,#20,#4d,#75,#6d ;oyal.Mum
  db #6d,#79,#20,#68,#61,#76,#65,#20 ;my.have.
  db #62,#65,#65,#6e,#20,#75,#6e,#63 ;been.unc
  db #6f,#76,#65,#72,#65,#64,#2c,#1f ;overed..
  db #03,#0a,#79,#6f,#75,#20,#77,#69 ;..you.wi
  db #6c,#6c,#20,#62,#65,#20,#61,#62 ;ll.be.ab
  db #6c,#65,#20,#74,#6f,#20,#6c,#65 ;le.to.le
  db #61,#76,#65,#20,#74,#68,#65,#20 ;ave.the.
  db #6c,#65,#76,#65,#6c,#2e,#1f,#03 ;level...
  db #0b,#41,#6e,#79,#20,#72,#65,#6d ;.Any.rem
  db #61,#69,#6e,#69,#6e,#67,#20,#47 ;aining.G
  db #75,#61,#72,#64,#69,#61,#6e,#73 ;uardians
  db #20,#77,#69,#6c,#6c,#20,#62,#65 ;.will.be
  db #20,#61,#62,#6c,#65,#1f,#03,#0c ;.able...
  db #74,#6f,#20,#66,#6f,#6c,#6c,#6f ;to.follo
  db #77,#20,#79,#6f,#75,#20,#6f,#6e ;w.you.on
  db #74,#6f,#20,#74,#68,#65,#20,#6e ;to.the.n
  db #65,#78,#74,#20,#6c,#65,#76,#65 ;ext.leve
  db #6c,#2e ;l.
lab7170:
  db #83,#1f,#05,#0f,#41,#66,#74,#65 ;....Afte
  db #72,#20,#63,#6f,#6d,#70,#6c,#65 ;r.comple
  db #74,#69,#6e,#67,#20,#61,#6c,#6c ;ting.all
  db #20,#35,#20,#6c,#65,#76,#65,#6c ;...level
  db #73,#20,#6f,#66,#20,#61,#1f,#03 ;s.of.a..
  db #10,#70,#79,#72,#61,#6d,#69,#64 ;.pyramid
  db #20,#79,#6f,#75,#20,#77,#69,#6c ;.you.wil
  db #6c,#2c,#20,#77,#68,#65,#6e,#20 ;l..when.
  db #79,#6f,#75,#20,#6c,#65,#61,#76 ;you.leav
  db #65,#20,#74,#68,#65,#1f,#03,#11 ;e.the...
  db #66,#69,#66,#74,#68,#20,#6c,#65 ;fifth.le
  db #76,#65,#6c,#2c,#20,#6d,#6f,#76 ;vel..mov
  db #65,#20,#74,#6f,#20,#6c,#65,#76 ;e.to.lev
  db #65,#6c,#20,#31,#2c,#20,#6f,#66 ;el....of
  db #20,#74,#68,#65,#1f,#03,#12,#6e ;.the...n
  db #65,#78,#74,#20,#70,#79,#72,#61 ;ext.pyra
  db #6d,#69,#64,#2e ;mid.
lab71F4:
  db #93,#1f,#05,#08,#0f,#00,#57,#68 ;......Wh
  db #65,#6e,#20,#79,#6f,#75,#20,#68 ;en.you.h
  db #61,#76,#65,#20,#63,#6f,#6d,#70 ;ave.comp
  db #6c,#65,#74,#65,#64,#20,#61,#20 ;leted.a.
  db #70,#79,#72,#61,#6d,#69,#64,#2c ;pyramid.
  db #1f,#03,#09,#79,#6f,#75,#72,#20 ;...your.
  db #73,#75,#63,#63,#65,#73,#73,#20 ;success.
  db #77,#69,#6c,#6c,#20,#62,#65,#20 ;will.be.
  db #72,#65,#77,#61,#72,#64,#65,#64 ;rewarded
  db #20,#65,#69,#74,#68,#65,#72,#1f ;.either.
  db #03,#0a,#62,#79,#20,#62,#6f,#6e ;..by.bon
  db #75,#73,#20,#70,#6f,#69,#6e,#74 ;us.point
  db #73,#20,#6f,#72,#20,#74,#68,#65 ;s.or.the
  db #20,#61,#72,#72,#69,#76,#61,#6c ;.arrival
  db #20,#6f,#66,#20,#61,#6e,#1f,#03 ;.of.an..
  db #0b,#65,#78,#74,#72,#61,#20,#6d ;.extra.m
  db #65,#6d,#62,#65,#72,#20,#66,#6f ;ember.fo
  db #72,#20,#79,#6f,#75,#72,#20,#74 ;r.your.t
  db #65,#61,#6d,#2e ;eam.
lab7288:
  db #e5,#1f,#05,#0e,#54,#68,#65,#20 ;....The.
  db #47,#75,#61,#72,#64,#69,#61,#6e ;Guardian
  db #73,#20,#69,#6e,#20,#74,#68,#65 ;s.in.the
  db #20,#6e,#65,#78,#74,#20,#70,#79 ;.next.py
  db #72,#61,#6d,#69,#64,#2c,#1f,#03 ;ramid...
  db #0f,#68,#61,#76,#69,#6e,#67,#20 ;.having.
  db #62,#65,#65,#6e,#20,#77,#61,#72 ;been.war
  db #6e,#65,#64,#20,#62,#79,#20,#74 ;ned.by.t
  db #68,#6f,#73,#65,#20,#79,#6f,#75 ;hose.you
  db #20,#68,#61,#76,#65,#1f,#03,#10 ;.have...
  db #65,#73,#63,#61,#70,#65,#64,#20 ;escaped.
  db #66,#72,#6f,#6d,#2c,#20,#77,#69 ;from..wi
  db #6c,#6c,#20,#62,#65,#20,#6d,#6f ;ll.be.mo
  db #72,#65,#20,#61,#6c,#65,#72,#74 ;re.alert
  db #2c,#20,#73,#6f,#1f,#03,#11,#61 ;..so...a
  db #6c,#74,#68,#6f,#75,#67,#68,#20 ;lthough.
  db #74,#68,#65,#20,#47,#75,#61,#72 ;the.Guar
  db #64,#69,#61,#6e,#73,#20,#63,#61 ;dians.ca
  db #6e,#6e,#6f,#74,#20,#66,#6f,#6c ;nnot.fol
  db #6c,#6f,#77,#1f,#03,#12,#79,#6f ;low...yo
  db #75,#20,#66,#72,#6f,#6d,#20,#6f ;u.from.o
  db #6e,#65,#20,#70,#79,#72,#61,#6d ;ne.pyram
  db #69,#64,#20,#74,#6f,#20,#74,#68 ;id.to.th
  db #65,#20,#6e,#65,#78,#74,#2c,#20 ;e.next..
  db #69,#74,#1f,#03,#13,#77,#69,#6c ;it...wil
  db #6c,#20,#70,#61,#79,#20,#74,#6f ;l.pay.to
  db #20,#62,#65,#20,#65,#76,#65,#6e ;.be.even
  db #20,#6d,#6f,#72,#65,#20,#63,#61 ;.more.ca
  db #72,#65,#66,#75,#6c,#2e ;reful.
lab736E:
  db #1e,#0e,#00,#0f,#03,#1f,#0a,#02
  db #4f,#48,#20,#4d,#55,#4d,#4d,#59 ;OH.MUMMY
  db #20,#2d,#20,#49,#4e,#53,#54,#52 ;...INSTR
  db #55,#43,#54,#49,#4f,#4e,#53 ;UCTIONS
lab738D:
  db #4f,#1f,#05,#08,#0e,#01,#0f,#00 ;O.......
  db #59,#6f,#75,#20,#63,#61,#6e,#20 ;You.can.
  db #63,#6f,#6e,#74,#72,#6f,#6c,#20 ;control.
  db #79,#6f,#75,#72,#20,#74,#65,#61 ;your.tea
  db #6d,#20,#62,#79,#20,#75,#73,#69 ;m.by.usi
  db #6e,#67,#1f,#03,#09,#65,#69,#74 ;ng...eit
  db #68,#65,#72,#20,#61,#20,#4a,#6f ;her.a.Jo
  db #79,#73,#74,#69,#63,#6b,#2c,#20 ;ystick..
  db #6f,#72,#20,#74,#68,#65,#20,#4b ;or.the.K
  db #65,#79,#62,#6f,#61,#72,#64,#2e ;eyboard.
lab73DD:
  db #46,#1f,#05,#0b,#54,#68,#65,#20 ;F...The.
  db #6b,#65,#79,#62,#6f,#61,#72,#64 ;keyboard
  db #20,#6b,#65,#79,#73,#20,#61,#72 ;.keys.ar
  db #65,#20,#3a,#2d,#1f,#02,#0d,#0f ;e.......
  db #02,#41,#20,#2d,#20,#55,#70,#20 ;.A...Up.
  db #20,#5a,#20,#2d,#20,#44,#6f,#77 ;.Z...Dow
  db #6e,#20,#20,#20,#2f,#20,#2d,#20 ;n.......
  db #4c,#65,#66,#74,#20,#20,#5c,#20 ;Left....
  db #2d,#20,#52,#69,#67,#68,#74 ;..Right
lab7424:
  db #c2,#0f,#00,#1f,#05,#0f,#54,#68 ;......Th
  db #65,#20,#67,#61,#6d,#65,#20,#68 ;e.game.h
  db #61,#73,#20,#35,#20,#73,#6b,#69 ;as...ski
  db #6c,#6c,#20,#6c,#65,#76,#65,#6c ;ll.level
  db #73,#2c,#20,#74,#68,#65,#73,#65 ;s..these
  db #1f,#03,#10,#64,#65,#74,#65,#72 ;...deter
  db #6d,#69,#6e,#65,#20,#68,#6f,#77 ;mine.how
  db #20,#27,#63,#6c,#65,#76,#65,#72 ;..clever
  db #27,#20,#74,#68,#65,#20,#47,#75 ;..the.Gu
  db #61,#72,#64,#69,#61,#6e,#73,#1f ;ardians.
  db #03,#11,#61,#72,#65,#20,#61,#74 ;..are.at
  db #20,#74,#68,#65,#20,#62,#65,#67 ;.the.beg
  db #69,#6e,#6e,#69,#6e,#67,#20,#6f ;inning.o
  db #66,#20,#61,#20,#67,#61,#6d,#65 ;f.a.game
  db #2e,#20,#20,#59,#6f,#75,#1f,#03 ;...You..
  db #12,#6d,#61,#79,#20,#63,#68,#6f ;.may.cho
  db #6f,#73,#65,#20,#62,#65,#74,#77 ;ose.betw
  db #65,#65,#6e,#20,#35,#20,#64,#69 ;een...di
  db #66,#66,#65,#72,#65,#6e,#74,#20 ;fferent.
  db #73,#70,#65,#65,#64,#1f,#03,#13 ;speed...
  db #6c,#65,#76,#65,#6c,#73,#2c,#20 ;levels..
  db #66,#72,#6f,#6d,#20,#6d,#6f,#64 ;from.mod
  db #65,#72,#61,#74,#65,#20,#74,#6f ;erate.to
  db #20,#6d,#75,#72,#64,#65,#72,#6f ;.murdero
  db #75,#73,#2e ;us.
lab74E7:
  db #2b,#1f,#02,#15,#0f,#03,#4d,#61 ;......Ma
  db #79,#20,#41,#6e,#6b,#68,#2d,#53 ;y.Ankh.S
  db #75,#6e,#2d,#41,#68,#6d,#75,#6e ;un.Ahmun
  db #20,#67,#75,#69,#64,#65,#20,#79 ;.guide.y
  db #6f,#75,#72,#20,#73,#74,#65,#70 ;our.step
  db #73,#20,#2e,#2e ;s...
lab7513:
  dec a
  ld (lab816D),a
  sra a
  ret c
  ld h,#0
  ld l,a
  add hl,hl
  add hl,hl
  ex de,hl
  ld iy,lab8CB9
  add iy,de
  ld hl,(lab8136)
  add a,h
  ld h,a
  call lab7E92
  ld b,#4
lab7530:
  ld a,(iy+0)
  ld (hl),a
  inc iy
  inc hl
  djnz lab7530
  ld a,(lab816D)
  or a
  ret nz
  ld de,(lab8136)
  call lab7D3E
  ld a,#20
  ld (hl),a
  inc hl
  ld (hl),a
  ld de,#28
  add hl,de
  ld (hl),a
  dec hl
  ld (hl),a
  ld a,(lab8169)
  inc a
  ld (lab8169),a
  call lab795B
  ld de,(lab8136)
  ld (ix+2),d
  ld (ix+3),e
  ret
lab7566:
  ld a,(lab8170)
  ld hl,lab816F
  and (hl)
  ret z
  ld a,(lab8156)
  cp #8
  ret nz
  pop hl
  jp lab654C
lab7578:
  ld de,(lab8155)
  ld iy,lab816D
  ld a,(lab816C)
  ld b,a
lab7584:
  push bc
  ld bc,data0000+5
  add iy,bc
  ld a,(iy+0)
  or (iy+1)
  jp z,lab7630
  ld a,(iy+2)
  sub d
  cp #f8
  jr z,lab75A3
  cp #8
  jr z,lab75A3
  or a
  jp nz,lab7630
lab75A3:
  ld a,(iy+3)
  sub e
  cp #fe
  jr z,lab75B2
  cp #2
  jr z,lab75B2
  or a
  jr nz,lab7630
lab75B2:
  xor a
  ld (iy+0),a
  ld (iy+1),a
  ld d,(iy+2)
  ld e,(iy+3)
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  inc e
  inc e
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  ld a,#8
  add a,d
  ld d,a
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  dec e
  dec e
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  ld hl,lab8169
  dec (hl)
  ld de,(lab8155)
  ld a,#41
  call lab7B39
  ld a,(lab816E)
  or a
  jr z,lab760B
  xor a
  ld (lab816E),a
  call #bb96 ; Firmware: TXT_SET_PAPER
  ld a,#3
  call #bb90 ; Firmware: TXT_SET_PEN
  push iy
  call lab7863
  pop iy
  jr lab7630
lab760B:
  ld hl,lab816A
  dec (hl)
  ld a,(hl)
  add a,a
  add a,a
  add a,#34
  ld d,#0
  ld e,a
  ld a,#20
  call lab7B39
  ld hl,lab8000
  ld a,(lab7FC5)
  cp #59
  call z,#bcaa ; Firmware: SOUND_QUEUE
  ld a,(lab816A)
  or a
  jr nz,lab7630
  pop bc
  scf
  ret
lab7630:
  pop bc
  dec b
  jp nz,lab7584
  xor a
  ret
lab7637:
  ld hl,(lab8155)
  ld bc,(lab8138)
  xor a
  ld a,h
  ld e,l
  sbc hl,bc
  ret z
  ld hl,lab813A
  ld bc,data0000+5
  cpir
  ret nz
  ld d,c
  ld a,e
  ld hl,lab813F
  ld bc,data0000+6
  cpir
  ret nz
  ld hl,(lab8155)
  ld (lab8138),hl
  ld a,#4
  sub d
  ld d,a
  add a,a
  add a,a
  add a,a
  sub d
  ld d,a
  ld a,#5
  sub c
  add a,d
  ld h,a
  ld l,a
  ld a,(lab8157)
  cp #2
  jr c,lab7689
  jr z,lab7684
  cp #3
  jr z,lab767F
  ld bc,#108
  jr lab768C
lab767F:
  ld bc,data0000+1
  jr lab768C
lab7684:
  ld bc,data0000+7
  jr lab768C
lab7689:
  ld bc,#708
lab768C:
  add hl,bc
  ld b,h
  ld c,l
  ld ix,lab81D6
  ld iy,lab81D6
  ld e,c
  ld d,#0
  ld c,b
  ld b,d
  add ix,bc
  add iy,de
  bit 0,a
  jr z,lab76AE
  set 0,(ix+0)
  set 2,(iy+0)
  jr lab76B6
lab76AE:
  set 1,(ix+0)
  set 3,(iy+0)
lab76B6:
  ld a,(ix+0)
  and #f
  cp #f
  jr nz,lab76D4
  ld a,(ix+0)
  ld b,c
  push ix
  push iy
  push de
  call lab76EC
  pop de
  pop iy
  pop ix
  xor a
  ld (ix+0),a
lab76D4:
  ld a,(iy+0)
  and #f
  cp #f
  ret nz
  ld a,(iy+0)
  ld b,e
  push iy
  call lab76EC
  pop iy
  xor a
  ld (iy+0),a
  ret
lab76EC:
  push af
  ld a,b
  dec a
  ld b,#0
lab76F1:
  sub #7
  jr c,lab76F8
  inc b
  jr lab76F1
lab76F8:
  add a,#7
  add a,a
  ld c,a
  add a,a
  add a,a
  add a,a
  sub c
  add a,#8
  ld l,a
  ld a,b
  add a,a
  add a,a
  add a,a
  ld b,a
  add a,a
  add a,a
  add a,b
  ld h,a
  pop af
  cp #1f
  ret c
  jr z,lab7764
  cp #3f
  jr c,lab7751
  jr z,lab7784
  cp #5f
  jr c,lab773D
  jp z,lab77B4
  ld a,(lab815C)
  cp #2
  jr c,lab773A
  jr z,lab7737
  cp #4
  jr c,lab7734
  jr z,lab7731
  jp lab7DFC
lab7731:
  jp lab7E20
lab7734:
  jp lab7E17
lab7737:
  jp lab7E29
lab773A:
  jp lab7E0E
lab773D:
  ld (lab816E),a
  push hl
  ld a,#3
  call #bb96 ; Firmware: TXT_SET_PAPER
  xor a
  call #bb90 ; Firmware: TXT_SET_PEN
  call lab7863
  pop hl
  jp lab7DB5
lab7751:
  ld (lab816F),a
  push hl
  ld hl,lab8012
  ld a,(lab7FC5)
  cp #59
  call z,#bcaa ; Firmware: SOUND_QUEUE
  pop hl
  jp lab7D9D
lab7764:
  ld (lab8170),a
  push hl
  ld hl,(lab815A)
  ld bc,#32
  add hl,bc
  ld (lab815A),hl
  call lab7863
  ld hl,lab8012
  ld a,(lab7FC5)
  cp #59
  call z,#bcaa ; Firmware: SOUND_QUEUE
  pop hl
  jp lab7D85
lab7784:
  ld a,#1f
  ld (lab816D),a
  ld de,(lab8155)
  ld a,d
  sub h
  add a,e
  sub l
  cp #ec
  jr z,lab77A2
  cp #14
  jr z,lab77AC
  cp #fa
  jr z,lab77A7
  ld de,#806
  jr lab77AF
lab77A2:
  ld de,data0000
  jr lab77AF
lab77A7:
  ld de,data0000+6
  jr lab77AF
lab77AC:
  ld de,#800
lab77AF:
  add hl,de
  ld (lab8136),hl
  ret
lab77B4:
  push hl
  ld hl,(lab815A)
  ld bc,data0000+5
  add hl,bc
  ld (lab815A),hl
  call lab7863
  ld hl,lab8009
  ld a,(lab7FC5)
  cp #59
  call z,#bcaa ; Firmware: SOUND_QUEUE
  pop hl
  jp lab7DCD
lab77D1:
  ld hl,data0000
  ld (lab814D),hl
  ld (lab814F),hl
  ld ix,lab8150
  ld de,lab814C
  ld b,#4
lab77E3:
  ld a,(de)
  call #bb1e ; Firmware: KM_TEST_KEY
  dec de
  jr nz,lab77F0
  ld a,(de)
  call #bb1e ; Firmware: KM_TEST_KEY
  jr z,lab77F3
lab77F0:
  ld (ix+0),b
lab77F3:
  dec de
  dec ix
  djnz lab77E3
  ld a,(lab8157)
  cp #2
  jr c,lab782F
  jr z,lab7821
  cp #4
  jr c,lab7813
  ld l,(ix+1)
lab7808:
  ld h,(ix+3)
  ld e,(ix+2)
  ld d,(ix+4)
  jr lab783B
lab7813:
  ld l,(ix+4)
  ld h,(ix+2)
  ld e,(ix+1)
  ld d,(ix+3)
  jr lab783B
lab7821:
  ld l,(ix+3)
  ld h,(ix+1)
  ld e,(ix+4)
  ld d,(ix+2)
  jr lab783B
lab782F:
  ld l,(ix+2)
  ld h,(ix+4)
  ld e,(ix+3)
  ld d,(ix+1)
lab783B:
  ld (lab814D),hl
lab783E:
  ld (lab814F),de
  ld b,#4
lab7844:
  push bc
  inc ix
  ld a,(ix+0)
  or a
  jr z,lab785F
  ld (lab8157),a
  ld hl,(lab8155)
  call lab7A98
  call lab7A64
  jr z,lab785F
  pop bc
  jp lab790B
lab785F:
  pop bc
  djnz lab7844
  ret
lab7863:
  ld hl,#901
  call #bb75 ; Firmware: TXT_SET_CURSOR
  ld hl,(lab815A)
lab786C:
  ld b,#4
  ld iy,lab8736
lab7872:
  inc iy
  inc iy
  ld e,(iy+0)
  ld d,(iy+1)
  xor a
  ld a,#30
lab787F:
  sbc hl,de
  jr c,lab7886
  inc a
  jr lab787F
lab7886:
  add hl,de
  call #bb5a ; Firmware: TXT_OUTPUT
  djnz lab7872
  ld a,#30
  add a,l
  call #bb5a ; Firmware: TXT_OUTPUT
  ret
lab7893:
  ld a,#2c
  call #bb1e ; Firmware: KM_TEST_KEY
  ret z
lab7899:
  call lab78D1
  ld a,#2c
  call #bb1e ; Firmware: KM_TEST_KEY
  jr nz,lab7899
lab78A3:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr c,lab78A3
lab78AB:
  call lab78D1
  call #bb09 ; Firmware: KM_READ_CHAR
  jr nc,lab78AB
  call #bb0c ; Firmware: KM_CHAR_RETURN
  ret
lab78B7:
  push bc
  call lab7996
  call lab78D1
  ld de,(lab8153)
lab78C2:
  dec de
  ld a,d
  or e
  jr nz,lab78C2
  pop bc
  ld a,#2
  add a,b
  cp #15
  ld b,a
  jr c,lab78B7
  ret
lab78D1:
  ld hl,(lab905A)
  push hl
  ld a,(lab7FC4)
  cp #59
  call z,#bcaa ; Firmware: SOUND_QUEUE
  pop hl
  ret nc
  ld de,lab937D
  xor a
  ex de,hl
  sbc hl,de
  jr z,lab78F0
  ld hl,data0000+9
  add hl,de
  ld (lab905A),hl
  ret
lab78F0:
  ld hl,lab905C
  ld (lab905A),hl
  ret
lab78F7:
  ld a,(lab8155)
  cp #1a
  jr nz,lab7902
  ld a,#2
  jr lab7908
lab7902:
  cp #34
  jr nz,lab790B
  ld a,#4
lab7908:
  ld (lab8157),a
lab790B:
  ld a,#54
  ld de,(lab8155)
  call lab7B39
  ld a,(lab8157)
  cp #2
  jr c,lab792F
  jr z,lab7928
  cp #3
  jr z,lab7937
  ld a,(lab8155)
  dec a
  dec a
  jr lab7942
lab7928:
  ld a,(lab8155)
  inc a
  inc a
  jr lab7942
lab792F:
  ld a,(lab8156)
  ld b,#8
  sub b
  jr lab793D
lab7937:
  ld a,(lab8156)
  ld b,#8
  add a,b
lab793D:
  ld (lab8156),a
  jr lab7945
lab7942:
  ld (lab8155),a
lab7945:
  ld a,#41
  ld de,(lab8155)
  call lab7B39
  ret
lab794F:
  ld a,(lab8169)
  ld b,a
lab7953:
  push bc
  call lab795B
  pop bc
  djnz lab7953
  ret
lab795B:
  ld a,(lab816C)
  inc a
  ld (lab816C),a
  ld b,a
  ld ix,lab816D
  ld de,data0000+5
lab796A:
  add ix,de
  djnz lab796A
  ld a,#4
  call lab7D53
  inc a
  ld (ix+0),a
  ld a,#4
  call lab7D53
  inc a
  ld (ix+1),a
  ld h,#0
  ld a,(lab816C)
  ld l,a
  add hl,hl
  ld de,(lab8645)
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (ix+2),d
  ld (ix+3),e
  ret
lab7996:
  ld ix,lab816D
  ld de,data0000+5
lab799D:
  add ix,de
  djnz lab799D
  ld a,(ix+0)
  or a
  jr nz,lab79AC
  ld a,(ix+1)
  or a
  ret z
lab79AC:
  ld (lab8162),ix
  ld d,(ix+2)
  ld e,(ix+3)
  ld (lab8164),de
  ld a,(lab8161)
  call lab7D53
  or a
  call z,lab7AB6
  ld hl,(lab8162)
  call lab7A10
  jp nz,lab7AF2
  ld hl,(lab8162)
  inc hl
  call lab7A10
  jp nz,lab7AF2
  ld a,#2
  call lab7D53
  or a
  jr nz,lab79EA
  ld d,(ix+2)
  ld e,(ix+3)
  ld a,#4f
  jp lab7B39
lab79EA:
  ld b,(ix+0)
  ld c,(ix+1)
  dec a
  jr z,lab79F7
  dec b
  dec c
  jr lab79F9
lab79F7:
  inc b
  inc c
lab79F9:
  ld hl,lab864B
  ld d,#0
  ld e,b
  inc e
  add hl,de
  ld b,(hl)
  ld hl,lab864B
  ld e,c
  inc e
  add hl,de
  ld c,(hl)
  ld (ix+0),b
  ld (ix+1),c
  ret
lab7A10:
  ld a,(hl)
  ld (lab8159),a
  or a
  ret z
  call lab7A95
  xor a
  ld (lab8610),a
  ld iy,lab816D
  ld a,(lab816C)
  ld b,a
lab7A25:
  push bc
  ld bc,data0000+5
  add iy,bc
  ld a,(iy+0)
  or (iy+1)
  jr z,lab7A58
  ld a,(iy+2)
  sub d
  cp #f8
  jr z,lab7A42
  cp #8
  jr z,lab7A42
  or a
  jr nz,lab7A58
lab7A42:
  ld a,(iy+3)
  sub e
  cp #fe
  jr z,lab7A51
  cp #2
  jr z,lab7A51
  or a
  jr nz,lab7A58
lab7A51:
  ld a,(lab8610)
  inc a
  ld (lab8610),a
lab7A58:
  pop bc
  djnz lab7A25
  ld a,(lab8610)
  cp #1
  jr z,lab7A64
  xor a
  ret
lab7A64:
  ld (lab8166),de
  ld iy,lab8200
  ld a,e
  srl a
  ld b,#0
  ld c,a
  add iy,bc
  ld e,d
  ld d,#0
  add iy,de
  add iy,de
  add iy,de
  add iy,de
  add iy,de
  ld a,(iy+0)
  or a
  ret z
  ld a,(iy+1)
  or a
  ret z
  ld a,(iy+40)
  or a
  ret z
  ld a,(iy+41)
  or a
  ret
lab7A95:
  ld hl,(lab8164)
lab7A98:
  cp #2
  jr c,lab7AB0
  jr z,lab7AAC
  cp #3
  jr z,lab7AA6
  dec l
  dec l
  jr lab7AB4
lab7AA6:
  ld a,h
  add a,#8
  ld h,a
  jr lab7AB4
lab7AAC:
  inc l
  inc l
  jr lab7AB4
lab7AB0:
  ld a,h
  sub #8
  ld h,a
lab7AB4:
  ex de,hl
  ret
lab7AB6:
  ld bc,(lab8164)
  ld a,(lab8156)
  sub b
  jr c,lab7AC6
  jr z,lab7AC8
  ld a,#3
  jr lab7AC8
lab7AC6:
  ld a,#1
lab7AC8:
  ld (lab815F),a
  ld a,(lab8155)
  sub c
  jr c,lab7AD7
  jr z,lab7AD9
  ld a,#2
  jr lab7AD9
lab7AD7:
  ld a,#4
lab7AD9:
  ld (lab8160),a
  ld a,#2
  call lab7D53
  ld bc,(lab815F)
  or a
  jr z,lab7AEB
  ld a,b
  ld b,c
  ld c,a
lab7AEB:
  ld (ix+0),b
  ld (ix+1),c
  ret
lab7AF2:
  ld de,(lab8164)
  ld a,(lab8159)
  cp #2
  jr c,lab7B19
  jr z,lab7B05
  cp #3
  jr z,lab7B1D
  inc e
  inc e
lab7B05:
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  ld a,#8
  add a,d
  ld d,a
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  jr lab7B2D
lab7B19:
  ld a,#8
  add a,d
  ld d,a
lab7B1D:
  call lab7D3E
  ld a,(hl)
  call lab7CE6
  inc e
  inc e
  call lab7D3E
  ld a,(hl)
  call lab7CE6
lab7B2D:
  ld de,(lab8166)
  ld (ix+2),d
  ld (ix+3),e
  ld a,#4f
lab7B39:
  push af
  ld a,#10
  ld (lab7CC5+1),a
  ld a,#4
  ld (lab7CCF+1),a
  pop af
  cp #20
  jr z,lab7B5E
  cp #54
  jr z,lab7B65
  cp #41
  jp z,lab7C2F
  cp #4f
  jp z,lab7C7C
  ld iy,lab8919
  jp lab7CC4
lab7B5E:
  ld iy,lab8959
  jp lab7CC4
lab7B65:
  ld a,(lab8157)
  cp #2
  jp c,lab7C01
  jr z,lab7BD1
  cp #3
  jr z,lab7BA5
  ld iy,lab8A89
  ld a,#2
  ld (lab7CCF+1),a
  inc e
  inc e
  call lab7D3E
  ld a,#8
  ld (hl),a
  add a,#18
  ld bc,#28
  add hl,bc
  ld (hl),a
  ld a,(lab8158)
  xor #1
  ld (lab8158),a
  jp z,lab7CC4
  ld iy,lab8A99
  ld a,#7
  ld (hl),a
  add a,#19
  sbc hl,bc
  ld (hl),a
  jp lab7CC4
lab7BA5:
  ld iy,lab8A29
  ld a,#8
  ld (lab7CC5+1),a
  call lab7D3E
  ld a,#6
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(lab8158)
  xor #1
  ld (lab8158),a
  jp z,lab7CC4
  ld iy,lab8A49
  ld a,#5
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
  jp lab7CC4
lab7BD1:
  ld iy,lab89F9
  ld a,#2
  ld (lab7CCF+1),a
  call lab7D3E
  ld a,#3
  ld (hl),a
  add a,#1d
  ld bc,#28
  add hl,bc
  ld (hl),a
  ld a,(lab8158)
  xor #1
  ld (lab8158),a
  jp z,lab7CC4
  ld iy,lab8A09
  ld a,#4
  ld (hl),a
  add a,#1c
  sbc hl,bc
  ld (hl),a
  jp lab7CC4
lab7C01:
  ld iy,lab8999
  ld a,#8
  ld (lab7CC5+1),a
  add a,d
  ld d,a
  call lab7D3E
  ld a,#1
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(lab8158)
  xor #1
  ld (lab8158),a
  jp z,lab7CC4
  ld iy,lab89B9
  ld a,#2
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
  jp lab7CC4
lab7C2F:
  ld a,(lab8157)
  cp #2
  jr c,lab7C6C
  jr z,lab7C5C
  cp #3
  jr z,lab7C4C
  ld iy,lab8C39
  ld a,(lab8158)
  or a
  jr z,lab7CC4
  ld iy,lab8C79
  jr lab7CC4
lab7C4C:
  ld iy,lab8BB9
  ld a,(lab8158)
  or a
  jr z,lab7CC4
  ld iy,lab8BF9
  jr lab7CC4
lab7C5C:
  ld iy,lab8B39
  ld a,(lab8158)
  or a
  jr z,lab7CC4
  ld iy,lab8B79
  jr lab7CC4
lab7C6C:
  ld iy,lab8AB9
  ld a,(lab8158)
  or a
  jr z,lab7CC4
  ld iy,lab8AF9
  jr lab7CC4
lab7C7C:
  ld a,(ix+4)
  xor #1
  ld (ix+4),a
  push af
  ld a,(lab8159)
  cp #2
  jr c,lab7CB9
  jr z,lab7CAC
  cp #3
  jr z,lab7C9F
  pop af
  ld iy,lab8E39
  jr z,lab7CC4
  ld iy,lab8E79
  jr lab7CC4
lab7C9F:
  pop af
  ld iy,lab8DB9
  jr z,lab7CC4
  ld iy,lab8DF9
  jr lab7CC4
lab7CAC:
  pop af
  ld iy,lab8D39
  jr z,lab7CC4
  ld iy,lab8D79
  jr lab7CC4
lab7CB9:
  pop af
  ld iy,lab8CB9
  jr z,lab7CC4
  ld iy,lab8CF9
lab7CC4:
  push de
lab7CC5:
  ld b,#10
  ex de,hl
  ld (lab8647),hl
lab7CCB:
  push bc
  call lab7E92
lab7CCF:
  ld b,#4
lab7CD1:
  ld a,(iy+0)
  inc iy
  ld (hl),a
  inc hl
  djnz lab7CD1
  ld hl,(lab8647)
  inc h
  ld (lab8647),hl
  pop bc
  djnz lab7CCB
  pop de
  ret
lab7CE6:
  cp #2
  jr c,lab7D2E
  jr z,lab7D28
  cp #4
  jr c,lab7D22
  jr z,lab7D1C
  cp #6
  jr c,lab7D16
  jr z,lab7D10
  cp #8
  jr c,lab7D0A
  jr z,lab7D04
  ld iy,lab8959
  jr lab7D32
lab7D04:
  ld iy,lab8A89
  jr lab7D32
lab7D0A:
  ld iy,lab8AA9
  jr lab7D32
lab7D10:
  ld iy,lab8A69
  jr lab7D32
lab7D16:
  ld iy,lab8A79
  jr lab7D32
lab7D1C:
  ld iy,lab8A19
  jr lab7D32
lab7D22:
  ld iy,lab89F9
  jr lab7D32
lab7D28:
  ld iy,lab89E9
  jr lab7D32
lab7D2E:
  ld iy,lab89D9
lab7D32:
  ld a,#8
  ld (lab7CC5+1),a
  ld a,#2
  ld (lab7CCF+1),a
  jr lab7CC4
lab7D3E:
  push de
  ld hl,lab8200
  ld a,e
  srl a
  ld b,#0
  ld c,a
  add hl,bc
  ld e,d
  ld d,#0
  add hl,de
  add hl,de
  add hl,de
  add hl,de
  add hl,de
  pop de
  ret
lab7D53:
  ld de,(lab8151)
  call lab7D78
  push hl
  ld e,#4b
  ld a,(lab8151)
  call lab7D78
  ld de,#4b
  add hl,de
  ld de,#101
  xor a
lab7D6B:
  sbc hl,de
  jr c,lab7D71
  jr lab7D6B
lab7D71:
  add hl,de
  dec hl
  ld (lab8151),hl
  pop af
  ret
lab7D78:
  ld h,a
  ld l,#0
  ld d,l
  ld b,#8
lab7D7E:
  add hl,hl
  jr nc,lab7D82
  add hl,de
lab7D82:
  djnz lab7D7E
  ret
lab7D85:
  ld (lab8645),hl
  call lab7DED
  ld hl,(lab8645)
  ld bc,#602
  add hl,bc
  ld (lab8645),hl
  ld iy,lab877D
  call lab7E73
  ret
lab7D9D:
  ld (lab8645),hl
  call lab7DED
  ld hl,(lab8645)
  ld bc,#602
  add hl,bc
  ld (lab8645),hl
  ld iy,lab87C5
  call lab7E73
  ret
lab7DB5:
  ld (lab8645),hl
  call lab7DED
  ld hl,(lab8645)
  ld bc,#602
  add hl,bc
  ld (lab8645),hl
  ld iy,lab880D
  call lab7E73
  ret
lab7DCD:
  ld (lab8645),hl
  call lab7DE5
  ld hl,(lab8645)
  ld bc,#602
  add hl,bc
  ld (lab8645),hl
  ld iy,lab8855
  call lab7E73
  ret
lab7DE5:
  ld a,#f
  ld (lab864A),a
  jp lab7E4F
lab7DED:
  ld a,#ff
  ld (lab864A),a
  jp lab7E4F
data7df5:
  db #af,#32,#4a,#86,#c3,#4f,#7e ;..J..O.
lab7DFC:
  ld a,#ff
  ld (lab7E46+1),a
  ld a,#a5
  jr lab7E30
lab7E05:
  ld a,#f0
  ld (lab7E46+1),a
  ld a,#af
  jr lab7E30
lab7E0E:
  ld a,#f
  ld (lab7E46+1),a
  ld a,#fa
  jr lab7E30
lab7E17:
  ld a,#f0
  ld (lab7E46+1),a
  ld a,#50
  jr lab7E30
lab7E20:
  ld a,#ff
  ld (lab7E46+1),a
  ld a,#55
  jr lab7E30
lab7E29:
  ld a,#f
  ld (lab7E46+1),a
  ld a,#5
lab7E30:
  ld (lab864A),a
  ld a,#a
  ld (lab8649),a
  ld (lab8647),hl
  ld b,#18
lab7E3D:
  push bc
  ld b,#1
  call lab7E59
  ld a,(lab864A)
lab7E46:
  xor #f
  ld (lab864A),a
  pop bc
  djnz lab7E3D
  ret
lab7E4F:
  ld a,#a
  ld (lab8649),a
  ld b,#18
  ld (lab8647),hl
lab7E59:
  push bc
  call lab7E92
  ld a,(lab8649)
  ld b,a
  ld a,(lab864A)
lab7E64:
  ld (hl),a
  inc hl
  djnz lab7E64
  ld hl,(lab8647)
  inc h
  ld (lab8647),hl
  pop bc
  djnz lab7E59
  ret
lab7E73:
  ld b,#c
  ld (lab8647),hl
lab7E78:
  push bc
  call lab7E92
  ld b,#6
lab7E7E:
  ld a,(iy+0)
  inc iy
  ld (hl),a
  inc hl
  djnz lab7E7E
  ld hl,(lab8647)
  inc h
  ld (lab8647),hl
  pop bc
  djnz lab7E78
  ret
lab7E92:
  push ix
  ld ix,lab8ECA
  ld b,#0
  ld c,l
  ld d,b
  ld e,h
  add ix,de
  add ix,de
  ld l,(ix+0)
  ld h,(ix+1)
  add hl,bc
  pop ix
  ret
lab7EAB:
  xor a
  ld hl,lab8172
  ld (hl),a
  push hl
  pop de
  inc de
  ld bc,#49d
  ldir
  ret
lab7EB9:
  push hl
  ld iy,lab81D8
  ld b,#0
  ld c,h
  add iy,bc
  ld b,l
  inc b
  push de
  ld de,#28
lab7EC9:
  add iy,de
  djnz lab7EC9
  pop de
  ld a,e
  inc a
  sub l
  ld b,a
lab7ED2:
  push bc
  ld a,d
  inc a
  sub h
  ld b,a
  ld a,#20
  push iy
lab7EDB:
  ld (iy+0),a
  inc iy
  djnz lab7EDB
  ld bc,#28
  pop iy
  add iy,bc
  pop bc
  djnz lab7ED2
  pop hl
  call #bb66 ; Firmware: TXT_WIN_ENABLE
  call #bb6c ; Firmware: TXT_CLEAR_WINDOW
  ret
lab7EF4:
  ld b,(hl)
lab7EF5:
  inc hl
  ld a,(hl)
  call #bb5a ; Firmware: TXT_OUTPUT
  djnz lab7EF5
  ret
lab7EFD:
  db #4e,#0e,#01,#0f,#02,#0c,#1f,#0c ;N.......
  db #03,#4f,#48,#20,#4d,#55,#4d,#4d ;.OH.MUMM
  db #59,#20,#2d,#20,#4f,#50,#54,#49 ;Y...OPTI
  db #4f,#4e,#53,#1f,#09,#07,#0f,#00 ;ONS.....
  db #53,#50,#45,#45,#44,#20,#4f,#46 ;SPEED.OF
  db #20,#47,#41,#4d,#45,#20,#28,#31 ;.GAME...
  db #2d,#35,#29,#20,#3f,#1f,#0c,#08
  db #0f,#03,#28,#31,#20,#49,#53,#20 ;.....IS.
  db #46,#41,#53,#54,#45,#53,#54,#29 ;FASTEST.
  db #1f,#1f,#07,#8f,#08,#0f,#00
lab7F4C:
  db #35,#1f,#08,#0b,#44,#49,#46,#46 ;....DIFF
  db #49,#43,#55,#4c,#54,#59,#20,#4c ;ICULTY.L
  db #45,#56,#45,#4c,#20,#28,#31,#2d ;EVEL....
  db #35,#29,#20,#3f,#1f,#0c,#0c,#0f
  db #03,#28,#31,#20,#49,#53,#20,#48 ;....IS.H
  db #41,#52,#44,#45,#53,#54,#29,#1f ;ARDEST..
  db #21,#0b,#8f,#08,#0f,#00
lab7F82:
  db #1e,#1f,#08,#0f,#42,#41,#43,#4b ;....BACK
  db #47,#52,#4f,#55,#4e,#44,#20,#4d ;GROUND.M
  db #55,#53,#49,#43,#20,#28,#59,#2d ;USIC..Y.
  db #4e,#29,#20,#3f,#20,#8f,#08 ;N......
lab7FA1:
  db #1b,#1f,#09,#13,#53,#4f,#55,#4e ;....SOUN
  db #44,#20,#45,#46,#46,#45,#43,#54 ;D.EFFECT
  db #53,#20,#28,#59,#2d,#4e,#29,#20 ;S..Y.N..
  db #3f,#20,#8f,#08
lab7FBD:
  db #03,#59,#45,#53 ;.YES
lab7FC1:
  db #02,#4e,#4f ;.NO
lab7FC4:
  db #59 ;Y
lab7FC5:
  db #59 ;Y
lab7FC6:
  db #00,#00
lab7FC8:
  db #00,#00
lab7FCA:
  db #03,#00,#05,#01,#0a,#01,#02,#00
  db #00,#0a
lab7FD4:
  db #03,#00,#0a,#01,#05,#01,#01,#05
  db #fd,#01
lab7FDE:
  db #02,#00,#0a,#01,#05,#01,#02
lab7FE5:
  db #05,#f1,#7b,#1e,#f1,#92,#1e,#f1
  db #aa,#1e,#f1,#c3,#1e,#f1,#de,#1e
lab7FF5:
  db #01,#0a,#fb,#01
lab7FF9:
  db #02,#f0,#8c,#01,#0a,#fb,#01
lab8000:
  db #04,#01,#01,#00,#00,#00,#00,#fa
  db #ff
lab8009:
  db #04,#02,#02,#64,#00,#00,#00,#00 ;...d....
  db #00
lab8012:
  db #04,#03,#03,#00,#00,#00,#00,#fc
  db #ff
lab801B:
  db #24,#0e,#01,#0f,#02,#0c,#1f,#07
  db #05,#21,#21,#20,#20,#53,#20,#54 ;.....S.T
  db #20,#4f,#20,#50,#20,#20,#20,#20 ;.O.P....
  db #50,#20,#52,#20,#45,#20,#53,#20 ;P.R.E.S.
  db #53,#20,#20,#21,#21 ;S....
lab8040:
  db #23,#0f,#00,#1f,#07,#0a,#42,#72 ;......Br
  db #69,#74,#69,#73,#68,#20,#4d,#75 ;itish.Mu
  db #73,#65,#75,#6d,#20,#74,#6f,#64 ;seum.tod
  db #61,#79,#20,#61,#6e,#6e,#6f,#75 ;ay.annou
  db #6e,#63,#65,#64 ;nced
lab8064:
  db #23,#1f,#05,#0b,#73,#75,#63,#63 ;....succ
  db #65,#73,#73,#66,#75,#6c,#20,#65 ;essful.e
  db #78,#63,#61,#76,#61,#74,#69,#6f ;xcavatio
  db #6e,#20,#6f,#66,#20,#61,#6e,#63 ;n.of.anc
  db #69,#65,#6e,#74 ;ient
lab8088:
  db #14,#1f,#05,#0c,#45,#67,#79,#70 ;....Egyp
  db #74,#69,#61,#6e,#20,#70,#79,#72 ;tian.pyr
  db #61,#6d,#69,#64,#2e ;amid.
lab809D:
  db #1a,#0f,#03,#1f,#07,#11,#4c,#65 ;......Le
  db #61,#64,#65,#72,#20,#6f,#66,#20 ;ader.of.
  db #74,#65,#61,#6d,#20,#67,#69,#76 ;team.giv
  db #65,#6e,#20 ;en.
lab80B8:
  db #09,#62,#6f,#6e,#75,#73,#20,#66 ;.bonus.f
  db #6f,#72 ;or
lab80C2:
  db #1d,#1f,#05,#12,#68,#69,#73,#20 ;....his.
  db #65,#66,#66,#6f,#72,#74,#73,#20 ;efforts.
  db #6f,#66,#20,#32,#30,#30,#20,#70 ;of.....p
  db #6f,#69,#6e,#74,#73,#2e ;oints.
lab80E0:
  db #09,#65,#78,#74,#72,#61,#20,#6d ;.extra.m
  db #61,#6e ;an
lab80EA:
  db #10,#1f,#05,#12,#66,#6f,#72,#20 ;....for.
  db #6e,#65,#78,#74,#20,#64,#69,#67 ;next.dig
  db #2e
lab80FB:
  db #29,#0f,#02,#1f,#03,#17,#50,#72 ;......Pr
  db #65,#73,#73,#20,#22,#43,#22,#20 ;ess..C..
  db #6f,#72,#20,#46,#69,#72,#65,#20 ;or.Fire.
  db #42,#75,#74,#74,#6f,#6e,#20,#74 ;Button.t
  db #6f,#20,#43,#6f,#6e,#74,#69,#6e ;o.Contin
  db #75,#65 ;ue
lab8125:
  db #07,#0e,#01,#0f,#02,#1f,#0c,#0d
lab812D:
  db #47,#41,#4d,#45,#20,#4f,#56,#45 ;GAME.OVE
  db #52 ;R
lab8136:
  db #00,#00
lab8138:
  db #00,#00
lab813A:
  db #18,#40,#68,#90,#b8 ;..h..
lab813F:
  db #04,#12,#20,#2e,#3c,#4a,#45,#48 ;.....JEH
  db #16,#4b,#47,#49,#1e ;.KGI.
lab814C:
  db #4a ;J
lab814D:
  db #00,#00
lab814F:
  db #00
lab8150:
  db #00
lab8151:
  db #00,#00
lab8153:
  db #00,#04
lab8155:
  db #00
lab8156:
  db #00
lab8157:
  db #00
lab8158:
  db #00
lab8159:
  db #00
lab815A:
  db #00,#00
lab815C:
  db #00,#00
lab815E:
  db #00
lab815F:
  db #00
lab8160:
  db #00
lab8161:
  db #1f
lab8162:
  db #00,#00
lab8164:
  db #00,#00
lab8166:
  db #00,#00
lab8168:
  db #00
lab8169:
  db #04
lab816A:
  db #00,#00
lab816C:
  db #00
lab816D:
  db #00
lab816E:
  db #00
lab816F:
  db #00
lab8170:
  db #00
lab8171:
  db #00
lab8172:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00
lab81D6:
  db #00,#00
lab81D8:
  db #00,#00,#00,#00,#00,#00
lab81DE:
  db #00
lab81DF:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00
lab8200:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00
lab860F:
  db #00
lab8610:
  db #00,#04,#b8,#4a,#b8,#0a,#b8,#44 ;...J...D
  db #b8,#10,#b8,#3e,#b8,#16,#b8,#38
  db #b8,#1c,#b8,#32,#b8,#22,#b8,#2c
  db #b8,#0a,#90,#44,#90,#10,#90,#3e ;...D....
  db #90,#16,#90,#38,#90,#1c,#90
lab8637:
  db #32,#90,#16,#a8,#38,#a8,#1c,#a8
  db #32,#a8,#22,#a8,#2c,#a8
lab8645:
  db #00,#00
lab8647:
  db #00,#00
lab8649:
  db #00
lab864A:
  db #00
lab864B:
  db #03,#04,#01,#02,#03,#04,#01,#02
lab8653:
  db #19,#1d,#18,#18,#1c,#00,#18,#18
  db #1c,#01,#00,#00,#1c,#02,#0f,#0f
  db #1c,#03,#0b,#0b,#0e,#00,#04,#01
  db #0f,#01
lab866D:
  db #08,#1d,#0b,#0b,#0e,#03,#0c,#0e
  db #02
lab8676:
  db #15,#0e,#00,#0f,#01,#1f,#0e,#07
  db #48,#49,#2d,#53,#43,#4f,#52,#45 ;HI.SCORE
  db #2d,#54,#41,#42,#4c,#45 ;.TABLE
lab868C:
  db #c4,#09
lab868E:
  db #0f,#1f,#12
lab8691:
  db #0a,#53,#74,#75,#70,#65,#6e,#64 ;.Stupend
  db #6f,#75,#73,#20,#21 ;ous..
lab869E:
  db #d0,#07
lab86A0:
  db #0f,#1f,#12,#0c,#45,#78,#63,#65 ;....Exce
  db #6c,#6c,#65,#6e,#74,#20,#21,#20 ;llent...
lab86B0:
  db #dc,#05
lab86B2:
  db #0f,#1f,#12,#0e,#56,#65,#72,#79 ;....Very
  db #20,#47,#6f,#6f,#64,#20,#21,#20 ;.Good...
lab86C2:
  db #e8,#03
lab86C4:
  db #0f,#1f,#12,#10,#51,#75,#69,#74 ;....Quit
  db #65,#20,#47,#6f,#6f,#64,#20,#20 ;e.Good..
lab86D4:
  db #f4,#01
lab86D6:
  db #11,#1f,#12,#12,#4e,#6f,#74,#20 ;....Not.
  db #42,#61,#64,#20,#20,#20,#20,#20 ;Bad.....
  db #0e,#03
lab86E8:
  db #27,#1f,#03,#19,#49,#2d,#49,#6e ;....I.In
  db #73,#74,#72,#75,#63,#74,#69,#6f ;structio
  db #6e,#73,#20,#20,#4f,#2d,#4f,#70 ;ns..O.Op
  db #74,#69,#6f,#6e,#73,#20,#20,#50 ;tions..P
  db #2d,#50,#6c,#61,#79,#20,#20,#3f ;.Play...
lab8710:
  db #27,#1f,#03,#19,#57,#65,#6c,#6c ;....Well
  db #20,#64,#6f,#6e,#65,#20,#21,#21 ;.done...
  db #20,#20,#50,#6c,#65,#61,#73,#65 ;..Please
  db #20,#65,#6e,#74,#65,#72,#20,#79 ;.enter.y
  db #6f,#75,#72,#20,#6e,#61 ;our.na
lab8736:
  db #6d,#65,#10,#27,#e8,#03,#64,#00 ;me....d.
  db #0a,#00
lab8740:
  db #23,#1f,#06,#02,#22,#4f,#48,#20 ;.....OH.
  db #4d,#55,#4d,#4d,#59,#22,#20,#a4 ;MUMMY...
  db #20,#31,#39,#38,#34,#20,#47,#45 ;......GE
  db #4d,#20,#53,#4f,#46,#54,#57,#41 ;M.SOFTWA
  db #52,#45,#0e,#01 ;RE..
lab8764:
  db #18,#1d,#18,#18,#0e,#00,#0f,#02
  db #0c,#1f,#03,#01,#53,#43,#4f,#52 ;....SCOR
  db #45,#1f,#17,#01,#4d,#45,#4e,#0f ;E...MEN.
  db #03
lab877D:
  db #33,#ff,#ff,#ff,#cc,#77,#00,#ff ;.....w..
  db #ff,#00,#00,#33,#00,#00,#00,#01
  db #08,#01,#00,#00,#00,#00,#07,#0e
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#0f,#0f,#0f,#0f
  db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
  db #88,#00,#00,#00,#00,#11,#ee,#77 ;.......w
  db #ff,#ff,#ee,#77,#cc,#00,#00,#00 ;...w....
  db #00,#33,#ee,#77,#ff,#ff,#ee,#77 ;...w...w
lab87C5:
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#cc,#77,#ff,#ff,#ff,#ff ;...w....
  db #88,#33,#ff,#ff,#ff,#ff,#11,#11
  db #00,#00,#00,#00,#33,#88,#00,#00
  db #00,#00,#33,#88,#cc,#11,#ff,#ff
  db #11,#11,#88,#00,#ff,#ff,#88,#33
  db #88,#88,#ff,#ff,#cc,#77,#aa,#aa ;.....w..
  db #ff,#ff,#ff,#ff,#bb,#ee,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
lab880D:
  db #ff,#f8,#ff,#ff,#f1,#ff,#ff,#fa
  db #f7,#fe,#f5,#ff,#ff,#fa,#f7,#fe
  db #f5,#ff,#f9,#fa,#f8,#f1,#f5,#f9
  db #f6,#f2,#00,#00,#f4,#f6,#f7,#fa
  db #00,#00,#f5,#fe,#f7,#fa,#00,#00
  db #f5,#fe,#f6,#f2,#00,#00,#f4,#f6
  db #f9,#fa,#f8,#f1,#f5,#f9,#ff,#fa
  db #f7,#fe,#f5,#ff,#ff,#fa,#f7,#fe
  db #f5,#ff,#ff,#f8,#ff,#ff,#f1,#ff
lab8855:
  db #0f,#00,#00,#00,#00,#0f,#0e,#03
  db #0f,#0f,#0c,#07,#0c,#0c,#c3,#cf
  db #03,#03,#09,#0f,#0f,#0f,#0f,#09
  db #00,#00,#00,#00,#00,#00,#30,#f0
  db #f0,#f0,#f0,#c0,#08,#00,#00,#00
  db #00,#01,#09,#0f,#0f,#0f,#0f,#09
  db #0c,#0c,#cc,#33,#03,#03,#0c,#0c
  db #cc,#33,#03,#03,#0e,#07,#0f,#0f
  db #0e,#07,#0e,#00,#00,#00,#00,#07
lab889D:
  db #68,#1f,#0c,#0b,#0e,#00,#0f,#02 ;h.......
  db #88,#8c,#88,#88,#20,#20,#8c,#8c
  db #84,#84,#84,#8c,#8c,#84,#8c,#8c
  db #84,#84,#84,#08,#08,#08,#08,#08
  db #08,#08,#08,#08,#08,#08,#08,#08
  db #08,#08,#08,#08,#08,#08,#0a,#8a
  db #8a,#8a,#8f,#20,#20,#87,#87,#85
  db #8d,#85,#87,#87,#85,#87,#87,#85
  db #8f,#85,#08,#08,#08,#08,#08,#08
  db #08,#08,#08,#08,#08,#08,#08,#08
  db #08,#08,#08,#08,#08,#0a,#82,#83
  db #82,#82,#20,#20,#81,#20,#81,#83
  db #81,#81,#20,#81,#81,#20,#81,#20
  db #81
lab8906:
  db #12,#1f,#0e,#11,#22,#43,#22,#20 ;.....C..
  db #54,#4f,#20,#43,#4f,#4e,#54,#49 ;TO.CONTI
  db #4e,#55,#45 ;NUE
lab8919:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
lab8959:
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
lab8999:
  db #f0,#87,#f0,#f0,#f0,#87,#f0,#f0
  db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#96,#f0,#f0
  db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
lab89B9:
  db #f0,#f0,#1e,#f0,#f0,#f0,#1e,#f0
  db #f0,#f0,#96,#f0,#f0,#f0,#96,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#96,#f0
  db #f0,#f0,#96,#f0,#f0,#f0,#f0,#f0
lab89D9:
  db #f0,#87,#f0,#87,#f0,#96,#f0,#96
  db #f0,#f0,#f0,#96,#f0,#96,#f0,#f0
lab89E9:
  db #1e,#f0,#1e,#f0,#96,#f0,#96,#f0
  db #f0,#f0,#96,#f0,#96,#f0,#f0,#f0
lab89F9:
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#96,#0f,#96,#0f,#f0,#c3
lab8A09:
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
lab8A19:
  db #f0,#c3,#96,#0f,#96,#0f,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
lab8A29:
  db #f0,#f0,#f0,#f0,#f0,#96,#f0,#f0
  db #f0,#96,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
  db #f0,#87,#f0,#f0,#f0,#87,#f0,#f0
lab8A49:
  db #f0,#f0,#f0,#f0,#f0,#f0,#96,#f0
  db #f0,#f0,#96,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#96,#f0,#f0,#f0,#96,#f0
  db #f0,#f0,#1e,#f0,#f0,#f0,#1e,#f0
lab8A69:
  db #f0,#f0,#f0,#96,#f0,#96,#f0,#f0
  db #f0,#96,#f0,#96,#f0,#87,#f0,#87
lab8A79:
  db #f0,#f0,#96,#f0,#96,#f0,#f0,#f0
  db #96,#f0,#96,#f0,#1e,#f0,#1e,#f0
lab8A89:
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#0f,#96,#0f,#96,#3c,#f0
lab8A99:
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
lab8AA9:
  db #3c,#f0,#0f,#96,#0f,#96,#f0,#f0
  db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
lab8AB9:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#f0,#f0,#7f,#ef,#f0
  db #f0,#0c,#03,#f0,#f0,#86,#16,#78 ;.......x
  db #e0,#77,#cc,#70,#c0,#77,#cc,#70 ;.w.p.w.p
  db #c0,#77,#ee,#70,#c0,#77,#ff,#f0 ;.w.p.w..
  db #c3,#fe,#ff,#f0,#f1,#fe,#ff,#f0
  db #e1,#1e,#ff,#f0,#f0,#1e,#ef,#f0
  db #f0,#f0,#0f,#f0,#f0,#f0,#1e,#f0
lab8AF9:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#f0,#f0,#7f,#ef,#f0
  db #f0,#0c,#03,#f0,#e1,#86,#16,#f0
  db #e0,#33,#ee,#70,#e0,#33,#ee,#30 ;...p....
  db #e0,#77,#ee,#30,#f0,#ff,#ee,#30 ;.w......
  db #f0,#ff,#f7,#3c,#f0,#ff,#f7,#f8
  db #f0,#ff,#87,#78,#f0,#7f,#87,#f0 ;...x....
  db #f0,#0f,#f0,#f0,#f0,#87,#f0,#f0
lab8B39:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#fc,#f0,#ee,#25,#f0
  db #f0,#80,#0f,#3c,#f0,#e6,#2d,#f0
  db #f0,#11,#9e,#f0,#f0,#00,#fe,#f0
  db #f0,#88,#00,#3c,#f0,#cc,#00,#3c
  db #f1,#ff,#fb,#f0,#f3,#ff,#f7,#f8
  db #d3,#fe,#ff,#f8,#87,#fc,#f7,#fc
  db #c3,#78,#c3,#3c,#e1,#3c,#c3,#1e ;.x......
lab8B79:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#fc,#f0,#ee,#25,#f0
  db #f0,#80,#0f,#3c,#f0,#e6,#2d,#f0
  db #f0,#11,#9e,#f0,#e0,#33,#fe,#f0
  db #e0,#00,#6f,#f0,#f0,#89,#2f,#f0 ;..o.....
  db #f0,#ff,#7e,#f0,#f0,#f7,#fc,#f0
  db #f0,#f3,#fc,#f0,#f0,#f3,#fc,#f0
  db #f0,#c3,#3c,#f0,#f0,#c3,#1e,#f0
lab8BB9:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#f0,#f0,#7f,#ef,#f0
  db #f0,#7f,#ef,#f0,#f0,#97,#9e,#f0
  db #f0,#03,#2e,#70,#e0,#67,#6e,#30 ;...p.gn.
  db #e0,#77,#ee,#33,#e1,#ff,#ef,#30 ;.w......
  db #f0,#ff,#e7,#78,#f0,#ff,#f7,#f8 ;...x....
  db #f0,#ff,#87,#78,#f0,#ef,#c3,#78 ;...x...x
  db #f0,#0f,#f0,#f0,#f0,#1e,#f0,#f0
lab8BF9:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f0,#ff,#ff,#f0,#f0,#7f,#ef,#f0
  db #f0,#7f,#ef,#f0,#f0,#97,#9e,#f0
  db #e0,#47,#0c,#f0,#c0,#67,#6e,#70 ;.G...gnp
  db #c0,#77,#ee,#70,#c0,#7f,#ff,#78 ;.w.p...x
  db #e1,#7e,#ff,#f0,#f1,#fe,#ff,#f0
  db #e1,#1e,#ff,#f0,#e1,#3c,#7f,#f0
  db #f0,#f0,#0f,#f0,#f0,#f0,#87,#f0
lab8C39:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f3,#ff,#ff,#f0,#f0,#4a,#77,#f0 ;.....Jw.
  db #c3,#0f,#10,#f0,#f0,#4b,#76,#f0 ;.....Kv.
  db #f0,#97,#88,#f0,#f0,#f7,#00,#f0
  db #c3,#00,#11,#f0,#c3,#00,#33,#f0
  db #f0,#fd,#ff,#f8,#f1,#fe,#ff,#fc
  db #f1,#ff,#f7,#bc,#f3,#fe,#f3,#1e
  db #c3,#3c,#e1,#3c,#87,#3c,#c3,#78 ;.......x
lab8C79:
  db #f0,#f0,#f0,#f0,#f0,#f7,#fe,#f0
  db #f3,#ff,#ff,#f0,#f0,#4a,#77,#f0 ;.....Jw.
  db #c3,#0f,#10,#f0,#f0,#4b,#76,#f0 ;.....Kv.
  db #f0,#97,#88,#f0,#f0,#f7,#cc,#70 ;.......p
  db #f0,#6f,#00,#70,#f0,#4f,#19,#f0 ;.o.p.O..
  db #f0,#e7,#ff,#f0,#f0,#f3,#fe,#f0
  db #f0,#f3,#fc,#f0,#f0,#f3,#fc,#f0
  db #f0,#c3,#3c,#f0,#f0,#87,#3c,#f0
lab8CB9:
  db #f0,#f0,#f0,#f0,#e0,#20,#40,#70 ;.......p
  db #e0,#40,#20,#70,#e0,#40,#20,#70 ;...p...p
  db #e0,#20,#40,#70,#e0,#00,#00,#f0 ;...p....
  db #f0,#00,#00,#f0,#f0,#00,#10,#f0
  db #f0,#80,#30,#f0,#f0,#80,#30,#f0
  db #f0,#00,#30,#f0,#f0,#10,#10,#f0
  db #e0,#10,#10,#f0,#e0,#30,#10,#f0
  db #f0,#f0,#00,#f0,#f0,#f0,#00,#f0
lab8CF9:
  db #f0,#f0,#f0,#f0,#e0,#20,#40,#70 ;.......p
  db #e0,#40,#20,#70,#e0,#40,#20,#70 ;...p...p
  db #e0,#20,#40,#70,#f0,#00,#00,#70 ;...p...p
  db #f0,#00,#00,#f0,#f0,#80,#00,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#00,#f0,#f0,#80,#80,#f0
  db #f0,#80,#80,#70,#f0,#80,#c0,#70 ;...p...p
  db #f0,#00,#f0,#f0,#f0,#00,#f0,#f0
lab8D39:
  db #f0,#f0,#f0,#f0,#f0,#c0,#70,#f0 ;......p.
  db #f0,#80,#30,#f0,#f0,#80,#30,#f0
  db #f0,#c0,#30,#f0,#f0,#80,#70,#f0 ;......p.
  db #f0,#80,#00,#70,#f0,#a0,#00,#30 ;...p....
  db #f0,#80,#b0,#30,#f0,#80,#30,#f0
  db #f0,#80,#30,#f0,#f0,#00,#30,#f0
  db #f0,#10,#10,#f0,#e0,#30,#10,#f0
  db #e0,#30,#80,#f0,#e0,#10,#80,#70 ;.......p
lab8D79:
  db #f0,#f0,#f0,#f0,#f0,#c0,#70,#f0 ;......p.
  db #f0,#80,#30,#f0,#f0,#80,#30,#f0
  db #f0,#c0,#30,#f0,#f0,#80,#70,#f0 ;......p.
  db #f0,#80,#00,#f0,#f0,#a0,#00,#30
  db #f0,#80,#b0,#30,#f0,#80,#30,#f0
  db #f0,#80,#30,#f0,#f0,#80,#30,#f0
  db #f0,#80,#30,#f0,#f0,#80,#30,#f0
  db #f0,#80,#30,#f0,#f0,#80,#10,#f0
lab8DB9:
  db #f0,#f0,#f0,#f0,#f0,#e0,#70,#f0 ;......p.
  db #f0,#c0,#30,#f0,#f0,#c0,#30,#f0
  db #f0,#c0,#30,#f0,#f0,#00,#10,#f0
  db #e0,#00,#00,#f0,#e0,#00,#00,#f0
  db #c0,#40,#40,#70,#c0,#80,#20,#70 ;...p...p
  db #f0,#00,#30,#f0,#f0,#10,#10,#f0
  db #e0,#10,#10,#f0,#e0,#30,#10,#f0
  db #f0,#f0,#00,#f0,#f0,#f0,#00,#f0
lab8DF9:
  db #f0,#f0,#f0,#f0,#f0,#e0,#70,#f0 ;......p.
  db #f0,#c0,#30,#f0,#f0,#c0,#30,#f0
  db #f0,#c0,#30,#f0,#f0,#80,#00,#f0
  db #f0,#00,#00,#70,#f0,#00,#00,#70 ;...p...p
  db #e0,#20,#20,#30,#e0,#40,#10,#30
  db #f0,#c0,#00,#f0,#f0,#80,#80,#f0
  db #f0,#80,#80,#70,#f0,#80,#c0,#70 ;...p...p
  db #f0,#00,#f0,#f0,#f0,#00,#f0,#f0
lab8E39:
  db #f0,#f0,#f0,#f0,#f0,#e0,#30,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#30,#f0,#f0,#e0,#10,#f0
  db #e0,#00,#10,#f0,#c0,#00,#50,#f0 ;......P.
  db #c0,#d0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#00,#f0
  db #f0,#80,#80,#f0,#f0,#80,#c0,#70 ;.......p
  db #f0,#10,#c0,#70,#e0,#10,#80,#70 ;...p...p
lab8E79:
  db #f0,#f0,#f0,#f0,#f0,#e0,#30,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#30,#f0,#f0,#e0,#10,#f0
  db #e0,#00,#10,#f0,#c0,#00,#50,#f0 ;......P.
  db #c0,#d0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#10,#f0,#f0,#c0,#10,#f0
  db #f0,#c0,#10,#f0,#f0,#80,#10,#f0
  db #10,#1d,#01,#01,#1c,#00,#01,#01
  db #1c,#01,#18,#18,#0e,#00,#0f,#01
  db #0c
lab8ECA:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
lab905A:
  db #00,#00
lab905C:
  db #11,#00,#00,#de,#01,#00,#0c,#20
  db #00,#0a,#00,#00,#fc,#04,#00,#0c
  db #08,#00,#11,#00,#00,#aa,#01,#00
  db #0c,#20,#00,#0a,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#11,#00,#00,#92
  db #01,#00,#0c,#20,#00,#0a,#00,#00
  db #bc,#03,#00,#0c,#08,#00,#11,#00
  db #00,#92,#01,#00,#0c,#20,#00,#0a
  db #00,#00,#7e,#02,#00,#0c,#08,#00
  db #02,#00,#00,#7e,#03,#00,#00,#08
  db #00,#02,#00,#00,#7e,#02,#00,#0c
  db #08,#00,#11,#00,#00,#aa,#01,#00
  db #0c,#20,#00,#0a,#00,#00,#fc,#04
  db #00,#0c,#08,#00,#11,#00,#00,#aa
  db #01,#00,#0c,#20,#00,#0a,#00,#00
  db #7e,#02,#00,#0c,#08,#00,#11,#00
  db #00,#de,#01,#00,#0c,#20,#00,#0a
  db #00,#00,#bc,#03,#00,#0c,#08,#00
  db #11,#00,#00,#de,#01,#00,#0c,#1f
  db #00,#0a,#00,#00,#7e,#02,#00,#0c
  db #08,#00,#02,#00,#00,#7e,#02,#00
  db #00,#08,#00,#02,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#11,#00,#00,#de
  db #01,#00,#0c,#20,#00,#0a,#00,#00
  db #fc,#04,#00,#0c,#08,#00,#11,#00
  db #00,#aa,#01,#00,#0c,#20,#00,#0a
  db #00,#00,#7e,#02,#00,#0c,#08,#00
  db #11,#00,#00,#92,#01,#00,#0c,#20
  db #00,#0a,#00,#00,#bc,#03,#00,#0c
  db #08,#00,#11,#00,#00,#3f,#01,#00
  db #0c,#20,#00,#0a,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#02,#00,#00,#7e
  db #02,#00,#00,#08,#00,#02,#00,#00
  db #7e,#02,#00,#0c,#08,#00,#11,#00
  db #00,#aa,#01,#00,#0c,#20,#00,#0a
  db #00,#00,#fc,#04,#00,#0c,#08,#00
  db #11,#00,#00,#92,#01,#00,#0c,#20
  db #00,#0a,#00,#00,#7e,#02,#00,#0c
  db #08,#00,#11,#00,#00,#de,#01,#00
  db #0c,#20,#00,#0a,#00,#00,#bc,#03
  db #00,#0c,#08,#00,#11,#00,#00,#de
  db #01,#00,#0c,#20,#00,#0a,#00,#00
  db #7e,#02,#00,#0c,#08,#00,#02,#00
  db #00,#7e,#02,#00,#00,#08,#00,#02
  db #00,#00,#7e,#02,#00,#0c,#08,#00
  db #11,#00,#00,#92,#01,#00,#0c,#20
  db #00,#0a,#00,#00,#fc,#04,#00,#0c
  db #08,#00,#11,#00,#00,#66,#01,#00 ;.....f..
  db #0c,#20,#00,#0a,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#11,#00,#00,#3f
  db #01,#00,#0c,#0f,#00,#0a,#00,#00
  db #bc,#03,#00,#0c,#08,#00,#01,#00
  db #00,#3f,#01,#00,#00,#01,#00,#01
  db #00,#00,#3f,#01,#00,#0c,#0f,#00
  db #01,#00,#00,#3f,#01,#00,#00,#01
  db #00,#11,#00,#00,#3f,#01,#00,#0c
  db #0f,#00,#0a,#00,#00,#7e,#02,#00
  db #0c,#08,#00,#01,#00,#00,#3f,#01
  db #00,#00,#01,#00,#11,#00,#00,#3f
  db #01,#00,#0c,#0f,#00,#0a,#00,#00
  db #7e,#02,#00,#0c,#08,#00,#01,#00
  db #00,#3f,#01,#00,#00,#01,#00,#11
  db #00,#00,#3f,#01,#00,#0c,#20,#00
  db #0a,#00,#00,#fc,#04,#00,#0c,#08
  db #00,#11,#00,#00,#2d,#01,#00,#0c
  db #20,#00,#0a,#00,#00,#7e,#02,#00
  db #0c,#08,#00,#11,#00,#00,#3f,#01
  db #00,#0c,#20,#00,#0a,#00,#00,#bc
  db #03,#00,#0c,#08,#00,#11,#00,#00
  db #66,#01,#00,#0c,#20,#00,#0a,#00 ;f.......
  db #00,#7e,#02,#00,#0c,#08,#00,#02
  db #00,#00,#7e,#02,#00,#00,#08,#00
  db #02,#00,#00,#7e,#02,#00,#0c,#08
  db #00,#11,#00,#00,#aa,#01,#00,#0c
  db #20,#00,#0a,#00,#00,#fc,#04,#00
  db #0c,#08,#00,#11,#00,#00,#92,#01
  db #00,#0c,#20,#00,#0a,#00,#00,#7e
  db #02,#00,#0c,#08,#00,#11,#00,#00
  db #66,#01,#00,#0c,#0f,#00,#0a,#00 ;f.......
  db #00,#bc,#03,#00,#0c,#08,#00,#01
  db #00,#00,#3f,#01,#00,#00,#01,#00
  db #01,#00,#00,#66,#01,#00,#0c,#0f ;...f....
  db #00,#01,#00,#00,#3f,#01,#00,#00
  db #01,#00,#11,#00,#00,#66,#01,#00 ;.....f..
  db #0c,#0f,#00,#0a,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#01,#00,#00,#3f
  db #01,#00,#00,#01,#00,#11,#00,#00
  db #66,#01,#00,#0c,#0f,#00,#0a,#00 ;f.......
  db #00,#7e,#02,#00,#0c,#08,#00,#01
  db #00,#00,#3f,#01,#00,#00,#01,#00
  db #11,#00,#00,#66,#01,#00,#0c,#20 ;...f....
  db #00,#0a,#00,#00,#fc,#04,#00,#0c
  db #08,#00,#11,#00,#00,#3f,#01,#00
  db #0c,#20,#00,#0a,#00,#00,#7e,#02
  db #00,#0c,#08,#00,#11,#00,#00,#66 ;.......f
  db #01,#00,#0c,#20,#00,#0a,#00,#00
  db #bc,#03,#00,#0c,#08,#00,#11,#00
  db #00,#92,#01,#00,#0c,#20,#00,#0a
  db #00,#00,#7e,#02,#00,#0c,#08,#00
  db #02,#00,#00,#7e,#02,#00,#00,#08
  db #00
lab937D:
  db #02,#00,#00,#7e,#02,#00,#0c,#08
  db #00
data0000:
  equ #0
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: games
  SELECT id INTO tag_uuid FROM tags WHERE name = 'games';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
