-- Migration: Import z80code projects batch 63
-- Projects 125 to 126
-- Generated: 2026-01-25T21:43:30.201881

-- Project 125: rubidouille-acpc22 by Rubi
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'rubidouille-acpc22',
    'Imported from z80Code. Author: Rubi. 1400 couleurs en mode 2',
    'public',
    false,
    false,
    '2019-11-16T21:09:40.476000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
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
prg
                ei
                ld b, #f5
prg_1           in a, (c)
                rra
                jr nc, prg_1

                halt
repeat 5
                halt
                call sprg
rend
                jr prg
sprg
                ld b, 8    ; petit tempo 1
sprg_1  djnz sprg_1
                ds 3
;
; initialisation du pointeur
                ld hl, color
                ld d, 35
sprg_2          ld bc,#7f00
                out (c ) ,c

; note: La partie suivante est le code présent dans l''original, mais faux
; outi décremnte b AVANT le out
; repeat 6
;                 outi
;                 inc b
; rend
;                 outi

; Correction
repeat 6        
				inc b				
                outi
rend
                outi
            
                ds 12
;
; tempo 2
;
                dec d
                jr nz, sprg_2
                ld bc, #7f00
                out (c), c
;
; un peu de blanc
;
                ld a, #4b
                out (c),a
                ret
color
a1               equ   #55
a2               equ   #4a
a3               equ   #59
a4               equ   #47
a5               equ   #40
a6               equ   #46
a7               equ   #5d
a8 			     equ   #4c
a9 			     equ   #4d		
repeat 5
                db a1,a2,a3,a4,a5,a6,a7
rend

repeat 5
                db a7,a1,a2,a3,a4,a5,a6
rend

repeat 5
                db a6,a7,a1,a2,a3,a4,a5
rend

repeat 5
                db a5,a6,a7,a1,a2,a3,a4
rend

repeat 5
                db a4,a5,a6,a7,a1,a2,a3
rend

repeat 5
                db a3,a4,a5,a6,a7,a1,a2
rend

repeat 5
                db a2,a3,a4,a5,a6,a7,a1
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

  -- Add category tag: rubidouille
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rubidouille';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 126: fsm_oo by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fsm_oo',
    'Imported from z80Code. Author: fma. gurneyh''s Object Oriented FSM implementation',
    'public',
    false,
    false,
    '2021-12-20T22:31:07.337000'::timestamptz,
    '2021-12-22T17:14:14.485000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; OO FSM implementation
;
; from gurneyh''s code

BUILDSNA
BANKSET 0
ORG #4000
RUN start


STRUCT stateStruct
onEnter DEFW 0
onDo    DEFW 0
onExit  DEFW 0
endSTRUCT


MACRO FSMINIT state
        LD   IX,{state}
        LD   HL,{state}_enter
        LD   (IX+stateStruct.onEnter),HL
        LD   HL,{state}_do
        LD   (IX+stateStruct.onDo),HL
IFDEF {state}_exit                      ; marcho pô :o( Le test est toujours faux...
        LD   HL,{state}_exit
ELSE
        LD   HL,dummy
ENDIF
        LD   (IX+stateStruct.onExit),HL
ENDM 

MACRO FSMEXEC action
        LD HL,(IX+stateStruct.{action})
        CALL jpHL
ENDM

dummy
        RET

; -----------------------------------------
; Test code
start
        ; Restore firmware in RAM
        ld sp,#c000

        ; Select lower ROM
        ld bc,#7f80 | %1001
        out (c),c

        exx
        xor a
        ex af,af''

        call #0044                  ; Restore #00-#40 and
        call #08bd                  ; Restore vectors

        ; Other calls made by the ROM
        call #1b5c
        call #1fe9
        call #0abf
        call #1074
        call #15a8
        call #24bc
        call #07e0

        ; Back to RAM
        ld   bc,#7f80 | %1101
        out  (c),c

        FSMINIT BaseState
        FSMINIT State1
        FSMINIT State2
        FSMINIT State3

        LD   IX,BaseState
        LD   HL,state1
        LD   (nextState),HL
.loop
        LD   HL,(nextState)
        LD   A,H
        OR   L
        JR   Z,.noChange

        FSMEXEC onExit

        LD   IX,(nextState)
        LD   HL,0
        LD   (nextState),HL

        FSMEXEC onEnter
.noChange
        FSMEXEC onDo

        JR .loop
; -----------------------------------------

; -----------------------------------------
MODULE baseState
enter                               ; can be used to call async_enter
        RET

do
        RET

exit                               ; can be used to call async_exit
        RET
MODULE OFF


MODULE state1
enter
        LD   HL,msgState1.enter
        JP   printMsg

do
        LD   hl,msgState1.do
        CALL printMsg

        LD   HL,state2
        LD   (nextState),HL

        RET

; exit
;         LD   HL,msgState1.exit
;         JP   printMsg
MODULE OFF
; -----------------------------------------

; -----------------------------------------
;
MODULE state2
enter
        LD   HL,msgState2.enter
        JP   printMsg

do
        LD   HL,msgState2.do
        CALL printMsg

        LD   HL,state3
        LD   (nextState),HL

        RET

exit
        LD   HL,msgState2.exit
        JP   printMsg
MODULE OFF
; -----------------------------------------

; -----------------------------------------
;
MODULE state3
enter
        LD   HL,msgState3.enter
        JP   printMsg

do
        LD   HL,msgState3.do
        CALL printMsg

        LD   HL,state1
        LD   (nextState),hl

        RET

exit
        LD   HL,msgState3.exit
        JP   printMsg
MODULE OFF
; -----------------------------------------

; -----------------------------------------
;
jpHL
        JP   (HL)
; -----------------------------------------

; -----------------------------------------
; Print message
printMsg
.loop
        LD   A,(HL)
        BIT  7,A
        JR   NZ,.end
        CALL #BB5A
        INC  HL
        JR   .loop

.end
        RES  7,A
        CALL #BB5A
        LD   A,10
        CALL #BB5A
        LD   A,13
        CALL #BB5A
        RET
; -----------------------------------------


; -----------------------------------------
;
; Datas
;
; -----------------------------------------

msgState1
.enter  STR "State 1: enter"
.do     STR "State 1: do"
.exit   STR "State 1: exit"

msgState2
.enter  STR "State 2: enter"
.do     STR "State 2: do"
.exit   STR "State 2: exit"

msgState3
.enter  STR "State 3: enter"
.do     STR "State 3: do"
.exit   STR "State 3: exit"

STRUCT stateStruct BaseState
STRUCT stateStruct State1
STRUCT stateStruct State2
STRUCT stateStruct State3

nextState   DEFW 0
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
