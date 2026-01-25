-- Migration: Import z80code projects batch 16
-- Projects 31 to 32
-- Generated: 2026-01-25T21:43:30.184939

-- Project 31: dephaser1 by Siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'dephaser1',
    'Imported from z80Code. Author: Siko. Audio Generation',
    'public',
    false,
    false,
    '2019-09-10T14:15:17.447000'::timestamptz,
    '2023-03-08T22:46:13.848000'::timestamptz
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
    ;exx
    ;ld HL, expression+256       ; HL pointe sur le buffer de donnees
    ;exx
    
mainlp:
    ld  A,(HL)   
    ;xor #0f
    rlca
    ld (hl),a					; Envoie de la donnee du buffer
    and 15
    set_psg_reg_A 8         ; Vers le canal A
    inc HL                  ; Avance dans le buffer
    inc HL                  ; Avance dans le buffer
    ld  A,H                 ; HL doit rester dans le bloc #4000-#8000
    and #3f
    or  hi(expression)
    ld  H,A 

    
	exx
    ld a,(hl)
    ;xor #0f
    and 15
    set_psg_reg_A 9         ; Vers le canal B
    inc HL                  ; Avance dans le buffer
    inc HL                  ; Avance dans le buffer
    inc HL                  ; Avance dans le buffer
    ld  A,H                 ; HL doit rester dans le bloc #4000-#8000
    and #3f
    or  hi(expression)
    ld  H,A 
    exx
    
    ;set_psg_reg_A 10         ; Vers le canal A
          
    ;ld  BC,#7f10            ; Raster dans le border
    ;out (C),C               ; a partir de la donnee envoyee
    ;ld a,(hl)
    ;and 31
    ;or  #40                 
    ;out (C),A   
    
    ds  48                ; Temporisation

    jp  mainlp              ; Boucle


; Bloc de #4000 octets avec les donnees a envoyer sur le canal A
org #C000

expression:
    repeat #3fff,t
        db ( (t and t>>8) and (t*(t>>((t and 4095)>>2)))^(t*3/4 and  t>>2) +t/500) and 255

        ;db  floor((t*t/2000)>>2 + (t and t/1000) ^ t>>7) and 15      
        ;db (t and 1)*15
;        db (t*((t>>9 or t>>13) and 25 and t>>6)/4 + ((t and t/1000) ^ t>>7)/8 ) and  15 
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

  -- Add category tag: audio
  SELECT id INTO tag_uuid FROM tags WHERE name = 'audio';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 32: hud_r9 by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'hud_r9',
    'Imported from z80Code. Author: Unknown. Test de HUD avec REG9=0',
    'public',
    false,
    false,
    '2019-10-08T21:03:40.553000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Exemple d''utilisation du R9=0 pour avoir une partie de l''écran linéaire

macro waitVBL
                ld b, #f5
@loop:          in a, (c)
                rra 
                jr nc, @loop
endm

macro waitLine nLines
                ld b, {nLines} 
@loop:          ds 60
                djnz @loop
endm


macro setCrtcReg reg, val
               ld bc, #bc00 + {reg} 
               out (c), c 
               inc b 
               ld c, {val}
               out (c), c
endm

macro setborder col
                ld bc,#7f10
                out (c), c
                ld c, {col}
                out (c), c
endm

macro setColor iPal, col
                ld bc,#7f00 + {iPal}
                out (c), c
                ld c, {col}
                out (c), c
endm

Color:
.fm_0:          equ #54
.fm_1:          equ #44
.fm_2:          equ #55
.fm_3:          equ #5C
.fm_4:          equ #58
.fm_5:          equ #5d

main:
                di
                ld hl, #c9fb
                ld (#38), hl
                ei

                waitVBL

.loop:
                waitVBL
                waitLine 3
                setCrtcReg 7, #ff
.interrupt_0:   
                setBorder Color.fm_0
.interrupt_1:
                halt
                setBorder Color.fm_1
                waitLine 2 * 8 + 2              ; VCC = 0, VLC = 0
                                                ; Début du premier écran
                setCrtcReg 9, 0                 
                setCrtcReg 4, 2 * 8             ; 16 lignes (2 chars)
                setCrtcReg 12, #30
                setCrtcReg 13, 0 
                waitLine 2 * 8                    ; 16 lignes - 1, 
                setCrtcReg 9, 7                 ; On peut rétablir R9
                
.interrupt_2:
                halt 
                setBorder Color.fm_2
                setCrtcReg 4, 36
                setCrtcReg 7, 36 - 8
                setCrtcReg 6, 22
                setCrtcReg 12, #20
                setCrtcReg 13, 0
            
               
.interrupt_3:
                halt
                setBorder Color.fm_3
.interrupt_4:
                halt
                setBorder Color.fm_4
               
.interrupt_5:
                halt
                setBorder Color.fm_5

                jp .loop


; Donnees directement ecrite en memoire video
; Premier motif en escalier
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
                
; Second motif en escalier ''hud''
org #8000
 ;repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
     db 0 
    else
     db #ff 
    endif
   rend
  rend
 ; ds 48,0
 ;rend',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rupture
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rupture';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
