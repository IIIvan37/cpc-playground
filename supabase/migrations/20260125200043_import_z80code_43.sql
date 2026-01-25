-- Migration: Import z80code projects batch 43
-- Projects 85 to 86
-- Generated: 2026-01-25T21:43:30.196076

-- Project 85: test-rupture verticale by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test-rupture verticale',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2020-12-07T18:13:39.971000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '


macro DELAY val
              ld b, {val}
@b1 ds 60 
              djnz @b1
endm

macro WRITE_CRTC reg, val		; 14 nops
              ld bc, #bc00 + {reg}
              ld a, {val}
              out (c), c
              inc b
              out (c), a
endm

macro WAIT_VBL
              ld b,#f5 
@vsync        in a,(c) 
              rra
              jr nc, @vsync
endm


              org #1000
	      run #1000
     		  di 
              ld hl, #c9fb 
              ld (#38), hl

	
main 
	         WAIT_VBL 

              DELAY 4 * 8 ; attente de 32 lignes (4x8)

              WRITE_CRTC 7, #7F
              ; 1er écran
              WRITE_CRTC 4, 8 - 1	; ecran de 64 lignes

              ei
              halt	; 		; on a parcouru 20 lignes du premier ecran
              delay 5 * 8 + 1 ; attente 41 lignes
	          ; 1 ligne pour la transition du r2
 	          ; transition de r2 = 46 => r2 = 49
	          ; attendre hbl C0 = r2 = 46
              ; r0 <- 63 - 3
              ; attendre nouvelle ligne
	          ; r0 <= 61, r2 <= 49
	          ; hcc = 9
              ds 46 - 9 - 14        ; attente hbl (ancienne valeur de r2)
	      	  WRITE_CRTC 0, 63 - 3  ; compensation
	      	  ds 10					; attente début nouvelle ligne	
	      	  WRITE_CRTC 0, 31      ; rétablissement r0 
              WRITE_CRTC 2, 49      ; nouvelle valeur r2 
     	      WRITE_CRTC 4, 0		; VCC = 0; VLC = 0
              WRITE_CRTC 9, 0		;
	      di
              ld d, 20 * 8 - 1		; 160 ecrans de 1 lignes 
loop:			
		WRITE_CRTC 2, #ff			; overflow reg 2
		ds 32 - 14
		WRITE_CRTC 2, #10
		ds 32 - 14 - 4	
		dec d				
              	jr nz, loop
		ei
                ; 1 ligne pour la transition du r2
 	      	    ; transition de r2 = 49 => r2 = 46
	            ; attendre hbl C0 = r2 = 49
                ; r0 <- 63 + 3
                ; attendre nouvelle ligne
	            ; r0 <= 63, r2 <= 46
	            ; hcc = #2f
              	ds #1F - #0c - 14	; attente hbl (ancienne valeur de r2)
		        WRITE_CRTC 0, 31 + 3; compensation 
                ds 7                ; attente début nouvelle ligne  
              	WRITE_CRTC 0, 63	; rétablissement r0 
                WRITE_CRTC 2, 46	; nouvelle valeur r2 
              	; 3ème écran		  ;
              	WRITE_CRTC 4, 11 - 1
              	WRITE_CRTC 9, 7
              	WRITE_CRTC 7, 11 - 4

              	jp main 
              
 


              
              
 org #c000 
 repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
     db c3 and %01010101
    else
     db #aa | c3
    endif
   rend
  rend
  ds 48,0
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

-- Project 86: div8_8 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'div8_8',
    'Imported from z80Code. Author: siko. Division 8/8',
    'public',
    false,
    false,
    '2020-01-29T23:34:46.434000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';See https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division

ld d,255
ld e, 100
call div_d_e

jr $


div_d_e:
   xor	a
   ld	b, 8
.loop:
   sla	d
   rla
   cp	e
   jr	c, .nomod
   sub	e
   inc	d
.nomod   
   djnz	.loop
   
   ret

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: math
  SELECT id INTO tag_uuid FROM tags WHERE name = 'math';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
