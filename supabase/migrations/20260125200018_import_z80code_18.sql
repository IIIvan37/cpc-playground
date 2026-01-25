-- Migration: Import z80code projects batch 18
-- Projects 35 to 36
-- Generated: 2026-01-25T21:43:30.185141

-- Project 35: rubidouille-acpc22-g by rubi, gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'rubidouille-acpc22-g',
    'Imported from z80Code. Author: rubi, gurneyh. 1400 couleurs "en mode 2"',
    'public',
    false,
    false,
    '2019-11-16T20:43:23.066000'::timestamptz,
    '2023-03-09T16:11:20.894000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';
; Rubidouille A100% n°22: 1400 couleurs en mode 2
;
                org #9000
                di
                ld hl,#c9fb     ;ei
                                ;ret
                ld (#38),hl
                
                ld bc, #bc01
                out (c), c
                inc b 
                dec c 
                out (c), c
prg
                ei
                ld b, #f5
prg_1           in a, (c)
                rra
                jr nc, prg_1

                halt
    rept 5
                halt
                call sprg
    endr
                jr prg
sprg
                ld b, 8    ; petit tempo 1
sprg_1  djnz sprg_1
                ds 1
;
; initialisation du pointeur
                ld hl, color
                ld d, 35
sprg_2          ld bc,#7f10
                out (c),c

; note: La partie suivante est le code présent dans l''original, mais faux
; outi décremnte b AVANT le out
; repeat 6
;                 outi
;                 inc b
; rend
;                 outi

; Correction
    rept 10
            
                outi
    endr
                ds 3
;
; tempo 2
;
                dec d
                jr nz, sprg_2
                ld bc, #7f10
                out (c), c
;
; un peu de blanc
;
                ld a, #54
                out (c),a
                ret

color:
    rept 5
                db #5c, #44, #56, #4c, #58, #56, #4c, #56, #44, #5c
                db #4c, #55, #52, #4e, #5d, #52, #4e, #52, #55, #4c
                db #4e, #57, #42, #4a, #4d, #42, #4a, #42, #57, #4e
                db #4a, #53, #59, #43, #4f, #59, #43, #59, #53, #4a
                db #4e, #57, #42, #4a, #4d, #42, #4a, #42, #57, #4e 
                db #4c, #55, #52, #4e, #5d, #52, #4e, #52, #55, #4c
                db #5c, #44, #56, #4c, #58, #56, #4c, #56, #44, #5c
    endr
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rasters
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rasters';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 36: spirale by demoniak
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'spirale',
    'Imported from z80Code. Author: demoniak. Animation spprale',
    'public',
    false,
    false,
    '2021-06-04T18:48:00.975000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '        ORG     #A000
	RUN	$

NbPt    EQU     32
DecalPt EQU     5

OffsetX EQU     15

        DI
Boucle:
        LD      B,#F5
Sync:
        IN      A,(C)
        RRA
        JR      NC,Sync
Angle:
        LD      C,0                     ; Angle
        LD      B,NbPt
BclEfface:
        LD      H,CosTab/256
        LD      L,C
        LD      A,(HL)                  ; A = Cos(Angle)
        ADD     A,OffsetX
        EX      AF,AF''
        LD      A,L
Decal1:
        ADD     A,0
        ADD     A,B
        LD      L,A
        LD      A,(HL)

        LD      H,0
        ADD     A,A                     ; * 2
        ADD     A,A                     ; * 4
        ADD     A,A                     ; * 8
        RL      H                       ; H = Carry
        LD      L,A
        RES     3,L                     ; Pour faire Y & #FE
        LD      D,H
        LD      E,L                     ; DE = Y * 8
        ADD     HL,HL                   ; * 16
        ADD     HL,HL                   ; * 32
        ADD     HL,DE                   ; HL = ( Y & #FE ) * 40
        ADD     A,A
        ADD     A,A
        OR      #C0                     ; Offset mémoire vidéo
        LD      D,A
        EX      AF,AF''
        LD      E,A
        ADD     HL,DE                   ; Ajouter X
        XOR     A
        LD      (HL),A
        SET     3,H                     ; #C8
        LD      (HL),A
        SET     4,H                     ; #D8
        LD      (HL),A
        RES     3,H                     ; #D0
        LD      (HL),A

        LD      A,C
        ADD     A,DecalPt
        LD      C,A
        DJNZ    BclEfface

        LD      A,(Decal1+1)
Delta:
        ADD     A,1
        LD      (Decal1+1),A
        LD      (Decal2+1),A

        LD      A,(Angle+1)
        ADD	A,12
        LD      (Angle+1),A
        LD      C,A

        LD      B,NbPt
BclAffiche:
        LD      H,CosTab/256
        LD      L,C
        LD      A,(HL)                  ; A = Cos(Angle)
        ADD     A,OffsetX
        EX      AF,AF''
        LD      A,L
Decal2:
        ADD     A,0
        ADD     A,B
        LD      L,A
        LD      A,(HL)

        LD      H,0
        ADD     A,A                     ; * 2
        ADD     A,A                     ; * 4
        ADD     A,A                     ; * 8
        RL      H                       ; H = Carry
        LD      L,A
        RES     3,L                     ; Pour faire Y & #FE
        LD      D,H
        LD      E,L                     ; DE = Y * 8
        ADD     HL,HL                   ; * 16
        ADD     HL,HL                   ; * 32
        ADD     HL,DE                   ; HL = ( Y & #FE ) * 40
        ADD     A,A
        ADD     A,A
        OR      #C0                     ; Offset mémoire vidéo
        LD      D,A
        EX      AF,AF''
        LD      E,A
        ADD     HL,DE
        LD      DE,#0FF0                ; Octets à écrire
        LD      (HL),D
        SET     3,H                     ; #C8
        LD      (HL),E
        SET     4,H                     ; #D8
        LD      (HL),D
        RES     3,H                     ; #D0
        LD      (HL),E

        LD      A,C
        ADD     A,DecalPt
        LD      C,A
        DJNZ    BclAffiche

        JP      Boucle
        RET

        Align	256

CosTab:
      
        DB      #31, #31, #31, #31, #31, #31, #31, #31
        DB      #31, #31, #31, #31, #31, #30, #30, #30
        DB      #30, #30, #2F, #2F, #2F, #2E, #2E, #2E
        DB      #2D, #2D, #2D, #2C, #2C, #2C, #2B, #2B
        DB      #2A, #2A, #2A, #29, #29, #28, #28, #27
        DB      #26, #26, #25, #25, #25, #24, #23, #23
        DB      #22, #22, #21, #21, #20, #1F, #1F, #1E
        DB      #1E, #1D, #1C, #1C, #1B, #1B, #1A, #19
        DB      #18, #18, #18, #17, #16, #15, #15, #15
        DB      #14, #13, #12, #12, #12, #11, #10, #10
        DB      #0F, #0F, #0E, #0E, #0D, #0C, #0C, #0B
        DB      #0B, #0A, #0A, #09, #09, #08, #08, #07
        DB      #07, #07, #06, #06, #05, #05, #05, #04
        DB      #04, #04, #03, #03, #03, #02, #02, #02
        DB      #01, #01, #01, #01, #01, #00, #00, #00
        DB      #00, #00, #00, #00, #00, #00, #00, #00
        DB      #00, #00, #00, #00, #00, #00, #00, #00
        DB      #00, #00, #00, #00, #00, #01, #01, #01
        DB      #01, #01, #02, #02, #02, #03, #03, #03
        DB      #04, #04, #04, #05, #05, #05, #06, #06
        DB      #07, #07, #07, #08, #08, #09, #09, #0A
        DB      #0B, #0B, #0C, #0C, #0C, #0D, #0E, #0E
        DB      #0F, #0F, #10, #10, #11, #12, #12, #13
        DB      #13, #14, #15, #15, #16, #16, #17, #18
        DB      #19, #19, #19, #1A, #1B, #1C, #1C, #1C
        DB      #1D, #1E, #1F, #1F, #1F, #20, #21, #21
        DB      #22, #22, #23, #23, #24, #25, #25, #26
        DB      #26, #27, #27, #28, #28, #29, #29, #2A
        DB      #2A, #2A, #2B, #2B, #2C, #2C, #2C, #2D
        DB      #2D, #2D, #2E, #2E, #2E, #2F, #2F, #2F
        DB      #30, #30, #30, #30, #30, #31, #31, #31
        DB      #31, #31, #31, #31, #31, #31, #31, #31

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
