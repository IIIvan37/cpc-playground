-- Migration: Import z80code projects batch 46
-- Projects 91 to 92
-- Generated: 2026-01-25T21:43:30.196750

-- Project 91: dephaser3 by Siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'dephaser3',
    'Imported from z80Code. Author: Siko.',
    'public',
    false,
    false,
    '2019-09-11T08:12:08.266000'::timestamptz,
    '2021-06-18T13:50:00.364000'::timestamptz
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

	;ld bc, #7f80    
    ;out (c),c
    
    ld  A,%01111110        ; Canal A ouvert uniquement
    set_psg_reg_A 7
    
    ld HL, expression       ; HL pointe sur le buffer de donnees
    ;exx
    ;ld HL, expression+256       ; HL pointe sur le buffer de donnees
    ;exx
    
mainlp:
    ld  A,(HL)   
;     xor #0f    
;    rlca
    ld (hl),a					; Envoie de la donnee du buffer
    and #0f
    set_psg_reg_A 8         ; Vers le canal A
    inc HL                  ; Avance dans le buffer
    ld  A,H                 ; HL doit rester dans le bloc #4000-#8000
    and #3f
    or  hi(expression)
    ld  H,A 

    
	exx
    ld a,(hl)
	add h
    add l
    
 xor #0f
    ;rrca
    
    ld (hl),a					; Envoie de la donnee du buffer
    and #0f
    set_psg_reg_A 9         ; Vers le canal B
    inc HL                  ; Avance dans le buffer
    ld  A,H                 ; HL doit rester dans le bloc #c000-#ffff    
    and #3f
    jr z, razCnt2

    or  hi(expression)
    ld  H,A 
	jr eraz2    
razCnt2:
	ld hl,#C851
eraz2:

    exx
    
    ;set_psg_reg_A 10         ; Vers le canal A
    
    ld  BC,#7f10            ; Raster dans le border
    out (C),C               ; a partir de la donnee envoyee
    ld a,(hl)
    and 31
    or  #40                 
    out (C),A   
    
    ds  120                ; Temporisation

    jp  mainlp              ; Boucle


; Bloc de #4000 octets avec les donnees a envoyer sur le canal A
org #C000
expression:
; Donnees directement ecrite en memoire video
 
 repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
 		db #55 | c3
    else
      if (80-c1>3.2*c2)
		db #55 | c3
        else        
		db #aa | c3
        endif

	endif
   rend
  rend
  ds 48,c3
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

-- Project 92: program340 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program340',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2023-01-27T20:13:38.031000'::timestamptz,
    '2025-08-28T00:43:21.360000'::timestamptz
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


    di
    ld bc, #bc01
    out (c), c
    inc b
    dec c
    out (c), c

loop
    ld b, #f5
.ws in a, (c)
    rra
    jr nc, .ws
        nop 3
        
       
        
        ld bc, #7F10
        out (c), c
        ld a, #54
        out (c), a
        
        WAIT_LINE 6 * 8
        ld bc, #7F10
        out (c), c
        ld a, #4C
        out (c), a
       
       
        WAIT_LINE 42
        ld bc, #7F10
        out (c), c
        ld a, #4E
        out (c), a
        
        WAIT_LINE 42
        ld bc, #7F10
        out (c), c
        ld a, #4A
        out (c), a
        
        WAIT_LINE 42
        ld bc, #7F10
        out (c), c
        ld a, #56
        out (c), a
        
        WAIT_LINE 42
        ld bc, #7F10
        out (c), c
        ld a, #55
        out (c), a
        
        WAIT_LINE 42
        ld bc, #7F10
        out (c), c
        ld a, #5d
        out (c), a
        
    
        jp loop
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
