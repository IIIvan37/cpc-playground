-- Migration: Import z80code projects batch 80
-- Projects 159 to 160
-- Generated: 2026-01-25T21:43:30.206135

-- Project 159: program355 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program355',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2023-02-10T14:20:42.947000'::timestamptz,
    '2023-02-10T14:37:13.989000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'macro WAIT_LINE n
                ld b, {n}
@loop:          ds 60
                djnz @loop
endm


Color:
.fm_0:          equ #54
.fm_1:          equ #44
.fm_2:          equ #55
.fm_3:          equ #5C
.fm_4:          equ #58
.fm_5:          equ #5d
.fm_6:          equ #4C
.fm_7:          equ #45
.fm_8:          equ #4d
.fm_9:          equ #56
.fm_10:         equ #46         
.fm_11:         equ #57
.fm_12:         equ #5e
.fm_13:         equ #40
.fm_14:         equ #5f
.fm_15:         equ #4e
.fm_16:         equ #47
.fm_17:         equ #4f
.fm_18:         equ #52
.fm_19:         equ #42
.fm_20:         equ #53
.fm_21:         equ #5A
.fm_22:         equ #59
.fm_23:         equ #5b
.fm_24:         equ #4a
.fm_25:         equ #43
.fm_26:         equ #4B

; ----------------------------------------------------------------------

    di
    ld hl, #c9fb
    ld (#38), hl
    ei

main
    ld b, #f5
.ws in a, (c)
    rra
    jr nc, .ws
    
    WAIT_LINE 16
    ei : nop
    halt
    halt
    di
    ds 30
    ld e, 68 + 68
    ld bc, #7f00
    ld hl, raster
    out (c), c
.loop
    inc b
    outi
    
    ds 64 - 6 - 4
    dec e
    jr nz, .loop
    jp main
    
raster
db Color.fm_0
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_4
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_4
db Color.fm_7
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_4
db Color.fm_7
db Color.fm_8
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_4
db Color.fm_7
db Color.fm_8
db Color.fm_17
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_4
db Color.fm_7
db Color.fm_8
db Color.fm_17
db Color.fm_26
db Color.fm_26
db Color.fm_17
db Color.fm_8
db Color.fm_7
db Color.fm_4
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_17
db Color.fm_8
db Color.fm_7
db Color.fm_4
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_8
db Color.fm_7
db Color.fm_4
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_7
db Color.fm_4
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_4
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_3
db Color.fm_0
db Color.fm_0
db Color.fm_0

db Color.fm_0
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_10
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_10
db Color.fm_14
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_10
db Color.fm_14
db Color.fm_20
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_10
db Color.fm_14
db Color.fm_20
db Color.fm_23
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_10
db Color.fm_14
db Color.fm_20
db Color.fm_23
db Color.fm_26
db Color.fm_26
db Color.fm_23
db Color.fm_20
db Color.fm_14
db Color.fm_10
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_23
db Color.fm_20
db Color.fm_14
db Color.fm_10
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_20
db Color.fm_14
db Color.fm_10
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_14
db Color.fm_10
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_10
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_1
db Color.fm_0
db Color.fm_0
db Color.fm_0
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

-- Project 160: round(sqr()) by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'round(sqr())',
    'Imported from z80Code. Author: tronic. LUT(LookUpTable) generation',
    'public',
    false,
    false,
    '2020-01-30T11:59:24.060000'::timestamptz,
    '2021-06-18T13:53:48.458000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Generate rounded upper square root LUT / aka get fast "round(sqr(value))"
; On a 8 bits value min=0 and max=255 (aligned 256 table) 
; On a 16 bits value min=0 and max=16512 (huge table!)
; Mais a quoi ca peut bien servir ? (https://www.squarerootcalculator.co)
; Square roots can be used to...
; solve for the distance between two points (Pythagorean Theorem)
; solve for the length of a side of a right triangle (Pythagorean Theorem)
; find the solutions to quadratic equations
; find normal distribution
; find standard deviation
; basically to solve for a squared variable in an equation
; If you see an equation like N2 = 27 , you can solve for N by taking the square 
; root of 27 which gives N = 5.1961524
;
; Tronic/GPA


	org #1000
	run $
	call genroundupsqr	; generation de la table

; 8bits LUT... si cp 17

	ld h,sqrtab/256
	ld l,255			; sqr(255)= round(15.96) = 16 (#10)
	ld a,(hl)

	ld h,sqrtab/256
	ld l,27				; sqr(27)= round(5.19) = 5 (#05)
	ld a,(hl)


; ou alors 16bits LUT... si cp 129

	ld hl,sqrtab
	ld bc,16512			; sqr(16512)= round(128.49) = 128 (#80)
	add hl,bc
	ld a,(hl)

	ld hl,sqrtab
	ld bc,4659			; sqr(4659)= round(68.25) = 68 (#44)
	add hl,bc
	ld a,(hl)

	ld hl,sqrtab
	ld bc,4700			; sqr(4700)= round(68.55) = 69 (#45)
	add hl,bc
	ld a,(hl)

	ld hl,sqrtab
	ld bc,666			; sqr(666)= round(25.80) = 26 (#1A)
	add hl,bc
	ld a,(hl)

	jr $

genroundupsqr
	ld de,sqrtab+1
	ld hl,modif+1
	ld a,1
modif	
	ld b,2
loop
	ld (de),a
	inc de
	djnz loop
	inc (hl)
	inc (hl)
	inc a
	cp 129	
	; cp 129 pour jusqu''a round(sqr(16512)) maxi
	; cp 17 jusqu''a round(sqr(255)) maxi (Attention, la table deborde d''un octet...)
	; cp val... round(sqr(x))=val, la table s''arretera donc a round(sqr(x-1)) - normalement ! ^^
	ret z
	jr modif

align 256
sqrtab
	db 0',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: mathlut
  SELECT id INTO tag_uuid FROM tags WHERE name = 'mathlut';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
