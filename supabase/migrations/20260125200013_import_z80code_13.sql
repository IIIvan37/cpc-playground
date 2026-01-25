-- Migration: Import z80code projects batch 13
-- Projects 25 to 26
-- Generated: 2026-01-25T21:43:30.184624

-- Project 25: zoom_test by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'zoom_test',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2020-11-22T01:29:26.323000'::timestamptz,
    '2023-01-08T15:28:43.485000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'LINEW equ 80
LINEH equ 25
NUMZOOMLVL equ 32

MACRO NEXTLINE LW
        LD      a,h  ; h+=#800
        ADD     a,8*4
        LD      h,a 
        AND     #38 
        RET     nz 	
        LD      a,h 
        SUB     #40 
        LD      h,a 
        LD      a,l 
        ADD     a,{LW}
        LD      l,a 
        RET     nc  ; <- RET
        INC     h 
        RES     2,H 
		ret			; <- RET		
MEND


macro wait_vbl
  ld b,#f5
@wait
  in a,(c)
  rra 
  jr nc, @wait
	ld bc,#7f10
    out (c),c
    ld c,#5a
    ;out (c),c
mend

start:
	di
main

;	#7FC0 / #BC0C,#30 -> mémoire normale, tu affiches #C000 pendant que tu effaces et écrit dans le vrai #4000
;#7FC3 / #BC0C,#10 -> 



.lp: 	
    wait_vbl

    ld bc,#bc0c
    out (c),c

.screenswap:
	ld a,1
    xor 1
    ld (.screenswap+1),a
    jr z,.screen40

.screenc0:
	inc b
    ld c,#30
   	out (c),c
    
	ld bc,#7fc1   
	out (c),c
    jp sinindex
    
.screen40:
	inc b
    ld c,#10
   	out (c),c
	ld bc,#7fc3
    out (c),c


sinindex:
	ld a,127
	inc a
    and 127
    ld (sinindex+1),a
    
    ld l,a
    ld h,0
    ld de,sintable
    add hl,de
    
    ld a,(hl)
    add a
    ld l,a
    ld h,0
    ld de,zoomtable
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    pop ix
  	
    ld hl,data
  	ld de,#4000
    jp (ix)
    
retour:

	jp main.lp


; HL=source
; DE=dest
; TODO: b= offset zoom level
macro render_line zoomlevel
	
    ld a,{zoomlevel}>>1
    ;ld a,{zoomlevel}
    ld (.vskip+1),a
        
	
    ld a,LINEH
    
.lloop:
	ex af,af''
	push hl
	;push de    
    repeat LINEW,cnt
    ldi
    ;print {zoomlevel},cnt,cnt % {zoomlevel}
    if ((cnt % {zoomlevel}) !=0)
    dec hl            
    endif
    rend

      ;  pop hl
     ;	call nxtline
       ; ex de,hl

	pop hl		
        ; on passe au suivant (verticalement) ou pas?
.vskip:        
  ld a,{zoomlevel}
  dec a
  ld (.vskip+1),a
  jr nz,.norepeat

 ld a,{zoomlevel}>>1
;  ld a,{zoomlevel}
  ld (.vskip+1),a

  ld bc,LINEW
  add hl,bc
.norepeat        
  ex af,af''
  dec a
  jp nz,.lloop
    
        
	ld bc,#7f10
    out (c),c
    ld c,#54
    out (c),c
   
    jp retour
mend

nxtline:
 NEXTLINE 80
    ret
    
    
repeat NUMZOOMLVL,cnt1
zoom_{cnt1}:
 render_line cnt1
rend


zoomtable:
  repeat NUMZOOMLVL,cnt1
  dw  zoom_{cnt1}
  rend
    
sintable:
repeat 128,cnt
	db abs(sin(1*180*cnt/128)*((NUMZOOMLVL)-1)) ; +(NUMZOOMLVL>>1) ; -1
rend


data:
  repeat LINEH>>1,l1
    repeat (LINEW>>2),l2
        db #10,0
        db #30,0
        rend
    repeat (LINEW>>1),l2
        db 0,#f0
    rend
    repeat (LINEW>>2),l2
        db #30,0
        db #10,0
        rend
    repeat (LINEW>>1),l2
        db 0,#f0
    rend

rend

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 26: checkboard_pattern by Siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'checkboard_pattern',
    'Imported from z80Code. Author: Siko. Pattern for a checkboard',
    'public',
    false,
    false,
    '2019-09-10T18:38:13.596000'::timestamptz,
    '2021-06-18T13:53:02.751000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Generation d''un motif de damier
; Check board pattern generation

org #1000
run #1000

LINEWIDTH EQU 80
NBLINES EQU 8*floor(2048/LINEWIDTH)
DAMIERMODE EQU 2

	ld hl,#c000
	ld ix,TABLE_LINES_CB
	
	ld c,1
	ld b,NBLINES-1
lpfilline:
	;ld c,4
	push bc,hl
	push hl
	ld de,LINEWIDTH/2	
	add hl,de
	call fillLine
	
	pop hl
	ld (ix+0),l
	inc ix 
	ld (ix+0),h	
	inc ix
	pop hl
	call NXT_LINE
	pop bc
	inc c	
	djnz lpfilline

    
    ld bc,#7F80 | DAMIERMODE
    out (c),c
        
    ld c,#55
    xor a
    out (c),a
    out (c),c
    jp $
    
    ; C contient la largeur d''une case, en pixel
    ; HL contient l''adresse destination
    ; routine sans optimisation particuliere
fillLine:
	; Pour gerer la symmétrie
	push hl
	exx
	pop hl
	exx
	ld d,c

	ld e,LINEWIDTH/2
	ld a,1
	ld (motif+1),a	

lpfill:	
	ld b,2<<DAMIERMODE
	xor a ; Motif en cours
lpoct1:
	sla a

motif:
	or 1
	dec d
	jr nz,noinvert
	; on inverse le motif et on reset le compteur d
	; Si on veut faire un simple triangle, on quitte a ce moment (ret)
	ld d,a
	ld a,(motif+1)
	xor 1
	ld (motif+1),a	
	ld a,d
	ld d,c	
noinvert:	
	djnz lpoct1
	ld (HL),A
	inc HL	
	exx
	
	; Symmetrie en mode 2
	repeat (2<<DAMIERMODE)
	rr a
	rl d
	rend
	ld a,d
	xor 255 ; complement?
	
	ld (hl),a
	dec hl
	exx
	
	dec e
	jr nz, lpfill
	ret
 
; genere une fonction nextline en fonction de la largeur de l''ecran
; CS: modifie AF,DE,  durée variable
MACRO NEXTLINE LW
        LD      a,h  ; h+=#800
        ADD     a,8 
        LD      h,a 
        AND     #38 
        RET     nz 	; <- RET si on ne déborde pas
        ld      de,#C000+LINEWIDTH
		add     hl,de
        ret        		
MEND

NXT_LINE : NEXTLINE LINEWIDTH

TABLE_LINES_CB equ #2000
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: pattern
  SELECT id INTO tag_uuid FROM tags WHERE name = 'pattern';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
