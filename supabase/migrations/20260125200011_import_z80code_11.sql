-- Migration: Import z80code projects batch 11
-- Projects 21 to 22
-- Generated: 2026-01-25T21:43:30.184170

-- Project 21: logs-levels by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'logs-levels',
    'Imported from z80Code. Author: siko. Log Macros',
    'public',
    false,
    false,
    '2021-10-20T16:04:53.584000'::timestamptz,
    '2021-10-20T16:08:27.182000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'MACRO LOG level,message 
 print ''['',{level},'']'', {message}
MEND

MACRO LOG_DBG message 
 LOG  ''DBG'',{message} 
MEND


LOG  ''LOG'',''truc''
LOG_DBG ''truc''

fail

jr $
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rasm
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rasm';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 22: test_arkos_player by Targhan
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test_arkos_player',
    'Imported from z80Code. Author: Targhan. Playing a track with Arkos Tracker V1',
    'public',
    false,
    false,
    '2019-09-10T23:00:49.180000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'MUSIC_ADDRESS       EQU #8000
PLAYER_ADDRESS      EQU #9000
PROGRAM_ADDRESS     EQU #A000
run #A000

; Registres PPI8255
PPI_PortA_H EQU #F4 ; RW
PPI_PortB_H EQU #F5 ; RO
PPI_PortC_H EQU #F6 ; WO
PPI_CTRL_H  EQU #F7 ; Registre de controle. WO

PPI_PortA   EQU #F400
PPI_PortB   EQU #F500
PPI_PortC   EQU #F600
PPI_CTRL    EQU #F700

;Désactive les interruptions, et prépare leur restauration
MACRO DISABLE_INT store
    DI 
    LD      HL,(#38) 
    LD      ({store}),HL 
    LD      HL,#c9fb    ; EI + RET
    LD      (#38),HL 
    EI 
MEND
; Sauvegarde des registres  AF'',BC,DE'' et HL''
MACRO PUSH_MIRROR_REGS
    DI
    EXX
    PUSH HL
    PUSH BC
    PUSH DE
    EXX
    EX AF,AF''
    PUSH AF
    EX AF,AF''
    EI
MEND

; Restauration des registres  AF'',BC,DE'' et HL''
MACRO POP_MIRROR_REGS
    DI
    EX AF,AF''
    POP AF
    EX AF,AF''   
    EXX
    POP DE
    POP BC
    POP HL
    EXX
    EI
MEND

; Attente synchro ecran
MACRO WAITSYNC 
    LD      b,PPI_PortB_H
@SYNC:
    IN      a,(C) 
    RRA 
    JP      nc,@SYNC 
MEND

;Récupere l''état des touches du clavier et joystick
MACRO GETKBSTATE DEST   
    LD      BC,PPI_PORTA |#0E   ; Selection registre 14 du PSG
    OUT     (C),C 
    LD      BC,PPI_PORTC |#C0  
    OUT     (C),C       
    XOR     A 
    OUT     (C),A   

    LD      BC,PPI_CTRL |#92 
    LD      HL,{DEST}
    OUT     (C),C       
    LD      C,#40
    LD      D,10
@KBGETLINE
    LD      B,PPI_PORTC_H      ; Selectionne ligne de clavier
    OUT     (C),C 
    LD      B,PPI_PORTA_H 
    IN      A,(C) 
    LD      (HL),A
    INC     HL      
    INC     C                  ; Ligne suivante
    DEC     D                  
    JR      NZ, @KBGETLINE  
    
    LD      BC,PPI_CTRL |#82   ;On a fini de manipuler
    OUT     (C),C              ; le PSG
    LD      BC,PPI_PORTC
    OUT     (C),C       
MEND


ORG PROGRAM_ADDRESS

    di
    ld bc,#F782
    out (c),c
    DISABLE_INT (INTER+1)   ; Desactive vecteur IT
    
PUSH_MIRROR_REGS        ; Sauve les registres miroirs

MAIN:
    LD DE,MUSIC_ADDRESS     ; Initialise musique
    CALL PLAYER_ADDRESS
MAINLOOP:
    WAITSYNC                ; Attentre trame vidéo 
    DI          
    GETKBSTATE KBSTATE      ; Recupere etat clavier
    EI  
	halt					; Quelques HALT pour qu''on voit le 
    halt					; Temps machine
    halt
    
    ld bc,#7F10 
    out (c),c
    ld a,#56
    out (c),a
    
CALL PLAYER_ADDRESS + 3 ; Joue le soundtrack    

	ld bc,#7F10
    out (c),c
    ld a,#54
    out (c),a


ENDLOOP:    
    LD  A,(KBSTATE+5)       ; Touche ESPACE?
    BIT 7,A
    JP  NZ,MAINLOOP         ; Nouvelle boucle

EXIT:
    POP_MIRROR_REGS         ; Rétablit les registres miroirs
INTER:  
    LD  HL,0                ; Retablit les ITs d''origine 
    LD  (#38),HL    
    ;CALL BIOS_RESET_AUDIO   ; Silence
    RET                     ; Retour au basic

KBSTATE: ds 10              ; Etat du clavier

ORG PLAYER_ADDRESS
    READ "arkos/ArkosTrackerPlayer_CPC_MSX.asm"
    ;READ "arkos/ArkosTrackerPlayer_CPCStable_MSX.asm"

ORG MUSIC_ADDRESS
    INCBIN "still8000.bin"',
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
