-- Migration: Import z80code projects batch 9
-- Projects 17 to 18
-- Generated: 2026-01-25T21:43:30.183887

-- Project 17: sintimus by Grim
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sintimus',
    'Imported from z80Code. Author: Grim. https://www.grimware.org/doku.php/sources/sintimus',
    'public',
    false,
    false,
    '2020-04-17T20:34:16.631000'::timestamptz,
    '2021-09-29T13:44:24.024000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Sintimus / Arkos
; After https://www.grimware.org/doku.php/sources/sintimus

;Note that there''s no screen mode or palette initialization. 
;We save some bytes by using the fact that when this program will be executed by the firmware
;(with the MC BOOT PROGRAM after a RUN"file from BASIC), 
;the screen will be cleared and set with the default graphic mode and palette 
;(amongs others things).


org #400
run #400

wav_lib_gen_sinref_adr:	equ 0

  di
  ld hl,sinusdot_data_crtc
sinusdot_crtc:
  ld a,(hl)
  ld b,#BC+1
  outi
  ld b,#BD+1
  outi
  or a
  jp p,sinusdot_crtc

sinref_store = wav_lib_gen_sinref_adr & #FC00
sinref_lenght 	equ 1024
sinref_store_h	equ hi(sinref_store) ; / 256
sinref_and_mask	equ #03
sinref_or_mask	equ sinref_store_h & #FC
sinref_store_q3	equ sinref_store_h+2
sinref_store_q4	equ sinref_store_h+3

 xor a
 ld bc, sinref_store_q3*256 + sinref_store_q4
 ld l,a
 ld e,l
 exx
 ld b,a ; 256
 ld d,b
wavlib_gen_sinref_loop		
 ld c,b
 dec b
 ld e,b
 ld h,d
 ld l,d
wavlib_gen_sinref_square	
 add hl,de
 djnz wavlib_gen_sinref_square
 ld a,h
 exx
 rra
 ld d,b
 ld h,c
 dec l
 ld (de),a 
 ld (hl),a 
 cpl
 res 1,d
 res 1,h
 ld (de),a 
 ld (hl),a 
 inc e
 exx
 ld b,c
 djnz wavlib_gen_sinref_loop

 ld hl,#1000 
 ld de,#1001
 ld (hl),#80
 ld bc,#1000
 ldir

 ld hl,#30C0
 ld de,#10C3
 exx
sinusdot_mainloop
 ld b,#F5
 in a,(c)
 rra
 jr nc,sinusdot_mainloop+2

; Clear dots
sinusdot_sp 
 ld sp,#1000
 xor a
 ld b,64
sinusdot_clear
 pop hl
 ld (hl),a
 pop hl
 ld (hl),a
 pop hl
 ld (hl),a
 pop hl
 ld (hl),a
 djnz sinusdot_clear
sinusdot_sin1_ptr				
 ld ix,0		
 ld de,9
 add ix,de
 ld (sinusdot_sin1_ptr+2),ix
sinusdot_sin2_ptr				
 ld iy,0		
 ld de,7
 add iy,de
 ld (sinusdot_sin2_ptr+2),iy
 ld bc,3
sinusdot_plot					
 db #DD 
 ld a,h
 and %11
 db #DD
 ld h,a
 db #FD
 ld a,h
 and %11
 db #FD
 ld h,a
 ld a,(iy+0)
 rrca
 rrca
 rrca
 ld h,a
 ld l,(ix+0)
 ld a,%1000
 scf	
 rr h
 rr l
 jr nc,$+5
 srl a 
 or a
 rr h
 rr l
 jr nc,$+7
 srl a 
 srl a 
 or (hl)
 ld (hl),a
 push hl
 ld de,15
 add ix,de
 ld de,9
 add iy,de
 djnz sinusdot_plot

; flipping
 exx
 ex de,hl
 ld b,#BD
 out (c),h
 ld b,#7F
 out (c),l
 exx
 ld a,(sinusdot_sp+2)
 xor 8 ;%00001000
 ld (sinusdot_sp+2),a
 jp sinusdot_mainloop
 sinusdot_data_crtc
 
 db 7,34
 db 1,32
 db 2,42
 db 6,32
 db 12+128,#30
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: dots
  SELECT id INTO tag_uuid FROM tags WHERE name = 'dots';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 18: it_example by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'it_example',
    'Imported from z80Code. Author: Unknown.',
    'public',
    false,
    false,
    '2019-09-10T12:42:40.189000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';ITs Example

ei
loop: 
jp loop


org #9000

val:
 LD A,0
 inc a
 cp 6
 jr nz,nores
 xor a
nores: 
 ld (val+1),a

 add a
 OR #40
 ld bc, #7f10
 Out (c),c
 out (c),a
 ld c, #00
 Out (c),c
 out (c),a

 ei
 ret

;Set IT 
org #38
 jp #9000 


            
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
