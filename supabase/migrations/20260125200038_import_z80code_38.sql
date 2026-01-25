-- Migration: Import z80code projects batch 38
-- Projects 75 to 76
-- Generated: 2026-01-25T21:43:30.194338

-- Project 75: fast-circle by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fast-circle',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-06-14T22:34:03.061000'::timestamptz,
    '2021-06-18T22:32:52.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'module Circle

R1	equ #20
R2	equ #2a
R6	equ #20
R7	equ #22
        
start	di
	call initCrtc
.loop
	call random
	and 3
	
	ld hl, colors
	or l
	ld l, a
	ld a, (hl)
	ld (plot.color + 1), a
	call random
	and #7f
    add 1
	ld c, a
	ld b, 0
	; b <= 0; c <= r
	; h <= xc, l <= yc
	call random
	ld h, a
	call random
	ld l, a
	
	call Circle

	jp .loop



circle
	ld a, c	
	srl a	; a = int(x/2)
	ld d, a	; d <= z
.loop
	; while x >= y
	ld a, c
	cp b
	ret c

	; xc + x, yc + y
	ld a, h		;a <= xc
	add c		;a <= xc + x 
	ld (plot.x + 1), a	
	ld a, l		;a <= yc
	add b		;a <= yc + y
	ld (plot.y + 1), a
	call plot

	; xc + x, yc - y
	;ld a, h
	;add c
	;ld (plot.x + 1), a
	ld a, l
	sub b
	ld (plot.y + 1), a
	call plot

	; xc - x, yc - y
	ld a, h
	sub c
	ld (plot.x + 1), a
	;ld a, l
	;sub b
	;ld (plot.y + 1), a
	call plot

	; xc - x, yc + y
	;ld a, h
	;sub c
	;ld (plot.x + 1), a
	ld a, l
	add b
	ld (plot.y + 1), a
	call plot

	; xc + y, yc + x
	ld a, h
	add b
	ld (plot.x + 1), a
	ld a, l
	add c
	ld (plot.y + 1), a
	call plot

	; xc + y, yc - x
	;ld a, h
	;add b
	;ld (plot.x + 1), a
	ld a, l
	sub c
	ld (plot.y + 1), a
	call plot

	; xc - y, yc - x
	ld a, h
	sub b
	ld (plot.x + 1), a
	;ld a, l
	;sub c
	;ld (plot.y + 1), a
	call plot

	; xc - y, yc + x
	;ld a, h
	;sub b
	;ld (plot.x + 1), a
	ld a, l
	add c
	ld (plot.y + 1), a
	call plot

	inc b	; y += 1
	ld a, d	
	sub b	
	ld d, a	; z -= y
	jr nc, .loop	
	; z < 0
	ld a, d
	add c
	ld d, a
	dec c	; x = x - 1
	jr .loop


plot:
	exx
	ld h, hi(scr_adr)
.y:	ld l, 0
	ld e, (hl)
	inc h
	ld d, (hl)
	ex hl, de
	
.x:	ld e, 0
	ld a, e
	srl e : srl e
	ld d, 0
	add hl, de
	
	ld c, %10001000		;Bitmask for MODE 1
	and 3		; a = X MOD 4
	jr z , .nshift		;-> = 0, no shift
.shift 	srl c		;move bitmask to pixel
	dec a		;loop counter
	jr nz, .shift		;-position

.nshift:	
.color	ld a, #ff
	xor (hl)
	and c
	xor (hl)
	ld (hl), a
	exx
	
	ret

initCrtc

	ld hl, CrtcValues
.loop:
	ld	b,#bd
	outi
	ld	b,#be
	outi
	ld	a,(hl)
	and	a
	jr	nz, .loop
	ret

;-----> Generate a random number
; output a=answer 0<=a<=255
; all registers are preserved except: af
random:
        push    hl
        push    de
        ld      hl,(randData)
        ld      a,r
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      (randData),hl
        pop     de
        pop     hl
        ret

randData	dw 0

align 4
colors:	db #00, #f0, #0f, #ff

CrtcValues
	db 1, R1,2,R2,6,R6,7,R7,12,#30,13,0,0

align 256
scr_adr
repeat 256, yy
_y = (yy - 1)
	db lo(#c000 + (_y & 7) * #800 + (_y >> 3) * R1 * 2)
rend

repeat 256, yy
_y = (yy - 1)
	db hi(#c000 + (_y & 7) * #800 + (_y >> 3) * R1 * 2)
rend

module off
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

-- Project 76: audio_expression by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'audio_expression',
    'Imported from z80Code. Author: Unknown.',
    'public',
    false,
    false,
    '2019-09-10T13:55:32.658000'::timestamptz,
    '2021-06-18T22:38:34.469000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '
; Affectation du contenu de A dans un registre du PSG
macro set_psg_reg_A reg     
    ld   D,0
    ld   BC,#f400 | {reg}
    out  (C),C
    ld   BC,#f6c0
    out  (C),C  
    out  (C),D
    ld   B,#f4
    out  (C),A
    ld   BC,#f680
    out  (C),C  
    out  (C),D
mend

    di                      ; On coupe les interruptions
    ld  A,%01111110        ; Canal A ouvert uniquement
    set_psg_reg_A 7
    
    ld HL, expression       ; HL pointe sur le buffer de donnees
    
mainlp:
    ld  A,(HL)   
    xor #0f
 	ld (hl),a					; Envoie de la donnee du buffer
    and #0f
    set_psg_reg_A 8         ; Vers le canal A
    rlca
    and #0f
    set_psg_reg_A 9         ; Vers le canal B
    
    ;set_psg_reg_A 10         ; Vers le canal A
    
    ld  BC,#7f10            ; Raster dans le border
    out (C),C               ; a partir de la donnee envoyee
    or  #40                 
    out (C),A   
    
;    ds  1+64                ; Temporisation

    inc HL                  ; Avance dans le buffer
    ld  A,H                 ; HL doit rester dans le bloc #4000-#8000
    and #3f
    or  hi(expression)
    ld  H,A 
    jp  mainlp              ; Boucle


; Bloc de #4000 octets avec les donnees a envoyer sur le canal A
org #C000

expression:
    repeat #3fff,t
;        db ( (t and t>>8) and (t*(t>>((t and 4095)>>2)))^(t*3/4 and  t>>2) +t/500) and #0f

        ;db  floor((t*t/2000)>>2 + (t and t/1000) ^ t>>7) and 15      
        ;db (t and 1)*15
        db (t*((t>>9 or t>>13) and 25 and t>>6)/4 + ((t and t/1000) ^ t>>7)/8 ) and  15 
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
