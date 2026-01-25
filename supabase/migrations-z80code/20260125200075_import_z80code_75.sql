-- Migration: Import z80code projects batch 75
-- Projects 149 to 150
-- Generated: 2026-01-25T21:43:30.205095

-- Project 149: program331 by Longshot
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program331',
    'Imported from z80Code. Author: Longshot.',
    'public',
    false,
    false,
    '2023-01-10T22:07:33.114000'::timestamptz,
    '2023-01-11T01:28:40.425000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';=======================================================================================
;
; Synchronisation Vsync
; A l''issue du call de synchronisation, la 1ere usec est celle sur laquelle le CRTC a positionne le signal Vsync
; Principe
; - attendre le signal vsync avec la marge d''erreur
; - attendre que le signal vsync se termine
; - faire deriver le test de vsync avec une boucle durant 19968+1 us
; - des que la vsync est detectee par le test, c''est la detection au plus tot, a laquelle il faut soustraire la duree du test
;
;========================================================================================

 call sync_vbl

 ld bc,#bc01
 out (c),c
 ld bc,#bd00
 out (c),c
 ld bc, #7f10
 out (c),c
 xor a;
 nop
 nop
 nop
 
 ld bc,#7F10
 ld hl,#4B5C
 out (c),c
; 19968 nops loop
noend:
 out (c),h
 nop
 out (c),l
 nop
 ds 13+39+13
 jr noend
 
 
; ----- Sync Routine
sync_vbl:
 di
 ld b,#f5       ; Attendre Etat Vsync =1
 ld hl,19968-23 ; Compteur de nop (moins les marges et la gestion de l''attente)
 ld de,-11
sync_wvblon1    ; Ici on attend le debut de la periode Vsync (ou on attend pas si on y etait deja)
 in a,(c) ;
 rra ;
 jr nc,sync_wvblon1
sync_wvbloff1   ; Flag Vsync CRT passe a 1 (ou etait deja a 1)
 in a,(c)       ; Attendre que le flag repasse a 0 (Fin de Vsync)
 rra
 jr c,sync_wvbloff1
sync_wvblon2    ; On est certain maintenant que le signal Vsync n''etait pas deja en cours
 in a,(c)       ;
 rra            ; marge1 de 7us
 jr nc,sync_wvblon2
sync_wvbloff2   ; Attendre que le signal Vsync repasse a 0 en comptant le temps ecoule
 add hl,de      ; 3 On nop2 On nop3
 in a,(c)       ; 4 2 1
 rra            ; 1 1 1
 jr c,sync_wvbloff2 ; 3/2 2 3 (bcl)+3+4+1+2=15 / marge 15-5=10
 ex de,hl       ; 1
 call wait_usec ; 5 >> 6 + 10(marge2)

;
; Zone de derive pour attendre de nouveau la premiere manifestation du flag
; le in a,(c) va "descendre" nop par nop (frame par frame) jusqu''a ce que le in recupere le flag actif
sync_derive_bcl:
 ld b,#f5 ; 2
 in a,(c) ; 4 usec. 0.1.2.[3] (+1)
 rra ; 1 usec (+1)
 jr c,sync_first ; 2/3 (+3)
 ld de,19969-20 ; 3
 call wait_usec ; 5+(19969-20)
 jr sync_derive_bcl ; 3 >> 20
sync_first ; 6 Le flag a ete détecté au plus tôt, et ce depuis 5 usec (1+1+3)
 ld de,19968-11 ; 3
 jp wait_usec ; 3 >> 11 >> de=19968-11


;==================================================================================
; wait "de" usec
; 40+(((de/8)-5) x 8)+(de and 7) nop
; nb - le call de la fonction n''est pas compte
;========================================================================================
wait_usec:
 ld hl,sync_adjust ; 3
 ld b,0 ; 2
 ld a,e ; 1
 and %111 ; 2>8
 ld c,a ; 1
 sbc hl,bc ; 4
 srl d ; 2
 rr e ; 2>17
 srl d ; 2
 rr e ; 2
 srl d ; 2
 rr e ; 2>25
 dec de ; 2>27 8
 dec de ; 2>29 16
 dec de ; 2>31 24
 dec de ; 2>33 32
 dec de ; 2>35 40 *
 nop ; 1>36
wait_usec_01
 dec de ; 2 -
 ld a,d ; 1 -
 or e ; 1 -
 nop ; 1 -
 jp nz,wait_usec_01 ; 3 - v=(8 x DE)
 jp (hl) ; 1>37 
 nop ; 1 * v=0--7
 nop ; 1
 nop ; 1
 nop ; 1
 nop ; 1
 nop ; 1
 nop ; 1
sync_adjust:
 ret ; 3>40
 ',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: compendium
  SELECT id INTO tag_uuid FROM tags WHERE name = 'compendium';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 150: strcmp by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'strcmp',
    'Imported from z80Code. Author: fma. Sting compare',
    'public',
    false,
    false,
    '2022-01-05T09:52:45.645000'::timestamptz,
    '2022-01-07T09:16:30.978000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'BUILDSNA
BANKSET 0

ORG #40


GATE_ARRAY  EQU #7F00

COLOR_HW    
.GREEN      EQU #16
.RED        EQU #1C

MACRO SETCOLOR ink,color
        LD   BC,GATE_ARRAY+{ink}
        OUT  (C),C
        LD   C,#40+{color}
        OUT  (C),C
ENDM


start
        LD   IX,word
        LD   IY,action
        CALL strcmp
        JR   Z,.same
        JR   NZ,.different
        
.same
        SETCOLOR 16,COLOR_HW.GREEN
        JR   $

.different
        SETCOLOR 16,COLOR_HW.RED
        JR   $


word    STR "regarder"
action  STR "regarde"


; -----------------------------------------
; Compare 2 strings
; Input:
;   IX = pointer to first string
;   IY = pointer to second string
; Output:
;   Z string are equal
;   NZ strings are different
; Note: strings must have their last char bit 7 set
strcmp
.loop
        LD   A,(IX+00)              ; get char from first string
        CP   (IY+00)                ; compare with second string
        RET  NZ                     ; if different, return (NZ set)
        BIT  7,(IX+00)              ; is last char of first string?
        JR   Z,.next1               ; no, go on
        BIT  7,(IY+00)              ; is last char of second string?
        JR   Z,.next2               ; no, go on

        XOR  A                      ; end of both strings, which are equal -> set Z flag
        RET

.next1
        BIT  7,(IY+00)              ; is last char of second string?
        JR   Z,.next3               ; no, go on

        RET                         ; strings differ in length, so return (NZ set)

.next2
        BIT  7,(IX+00)              ; is last char of second string?
        JR   Z,.next3               ; no, go on

        RET                         ; strings differ in length, so return (NZ set)

.next3
        INC  IX                     ; increment pointer of first string
        INC  IY                     ; increment pointer of second string
        JR   .loop                  ; loop
; -----------------------------------------
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
