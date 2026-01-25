-- Migration: Import z80code projects batch 22
-- Projects 43 to 44
-- Generated: 2026-01-25T21:43:30.186677

-- Project 43: fsm_overkill by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fsm_overkill',
    'Imported from z80Code. Author: fma. Overkill implementation of a FSM!',
    'public',
    false,
    false,
    '2021-10-20T19:30:00.490000'::timestamptz,
    '2025-02-04T17:54:46.649000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; -----------------------------------------
; Overkill implementation of a FSM!
; Ported from my own Python code:
;   https://framagit.org/fma38/Py4bot/-/blob/master/py4bot/common/fsm.py
;
; Frédéric
; -----------------------------------------

;NOLIST
;SETCRTC 0
BUILDSNA
BANKSET 0
ORG #4000
;RUN start
        jp start

Module fsm

IFNDEF _FSM_H_

FSM_MAX_TRANSITIONS equ 16

; Consts for transitionStruct index
EVENT_NAME_IDX  EQU 0
SRC_IDX         EQU 1
DST_IDX         EQU 2
ASYNC_IDX       EQU 3
BEFORE_IDX      EQU 4
LEAVE_IDX       EQU 6
ENTER_IDX       EQU 8
REENTER_IDX     EQU 10
AFTER_IDX       EQU 12


STRUCT transitionStruct
eventName   defb 0                  ; event name (0xff to end transitions)
src         defb 0                  ; source state this transition apply to
dst         defb 0                  ; destination state this transition leads to
async       defb 0                  ; if 1, holds the current state until ''fsm_transition'' is called
onBefore    defw 0                  ; address called before triggering the event
onLeave     defw 0                  ; address called before leaving the current state
onEnter     defw 0                  ; address called before reaching the destination state (when dst != src)
onReEnter   defw 0                  ; address called before re-entering the destination state (when dst == src)
onAfter     defw 0                  ; address called after triggering the event
ENDSTRUCT

STRUCT pendingTransitionStruct
enable      defw 0                  ; 0 means no pending transition
onLeave     defw 0                  ; address called before leaving the current state
onEnter     defw 0                  ; address called before reaching the destination state (when dst != src)
onAfter     defw 0                  ; address called after triggering the event
ENDSTRUCT

; Event can be used by onXXX callbacks
STRUCT eventStruct
name    defb 0                      ; event name
src     defb 0                      ; source state this transition apply to
dst     defb 0                      ; destination this transition leads to
ENDSTRUCT

LET _FSM_H_ = 1
ENDIF
IFNDEF _FSM_MACRO_

LET nbTransitions = 0

; -----------------------------------------
; Define a transition
; event: num of the transition
; src: source state num this transition apply to
; dst: destination state num this transition leads to
; async: if 1, holds the current state until ''transition'' sub-routineis called
; onBefore: called before triggering the event
; onLeave: called before leaving the current state
; onEnter: called before reaching the destination state (when dst != src)
; onReEnter: called before re-entering the destination state (when dst == src)
; onAfter: called after triggering the event
MACRO FSMDEFTRANSITION event,src,dst,async,onBefore,onLeave,onEnter,onReEnter,onAfter
;ASSERT nbTransitions < FSM_MAX_TRANSITIONS
        defb {event}
        defb {src}
        defb {dst}
        defb {async}
        defw {onBefore}
        defw {onLeave}
        defw {onEnter}
        defw {onReEnter}
        defw {onAfter}
nbTransitions += 1
MEND
; -----------------------------------------

; -----------------------------------------
;
MACRO FSMEXECCALLBACK index,next
        ld   hl,.onLeaveCont
        push hl
        ld   l,(ix+LEAVE_IDX)
        ld   h,(ix+LEAVE_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
MEND
; -----------------------------------------

; -----------------------------------------
; TODO: move to logging.asm helper
;       make a simple call (ld ix,{messageAddress} : ld e,{logMessageNum} : call debug)
MACRO LOG messageAddress,logMessageNum
        push af
        ld   hl,{messageAddress}

@loop
        ld   a,(hl)
        or   a
        jr   z,@next
        call #bb5a
        inc  hl
        jr   @loop

@next
        ld   a,'' ''
        call #bb5a
        ld   a,{logMessageNum}
        call #bb5a
        ld   a,10
        call #bb5a
        ld   a,13
        call #bb5a

        pop  af
MEND
; -----------------------------------------


LET _FSM_MACRO_ = 1
ENDIF

; -----------------------------------------
; FSM core
; -----------------------------------------

; -----------------------------------------
; Init the FSM
; A contains the initial state
init
        ld   (initState),a
        ld   (state),a

        ; TODO: clear transitions table

        ret
; -----------------------------------------

; -----------------------------------------
; Reset the FSM
reset
        ld   a,(initState)
        ld   (state),a
        ret
; -----------------------------------------

; -----------------------------------------
; Set the transitions table address
setTransitions
        ld   (transitions),hl
        ret
; -----------------------------------------

; -----------------------------------------
; Get the current state
getState
        ld   a,(state)
        ret
; -----------------------------------------

; -----------------------------------------
; Trigger the given event
; A contains the event name
trigger
        LOG  messages.fsmTriggerMsg,'' ''

        ld   (eventNameSave),a      ; save event name

        ; Check if an async transition is already registered
        ld   a,(pendingTransition.enable)
        cp   1
        jr   nz,.next1              ; if not, proceed
        ld   a,''A''                  ; error num
        scf                         ; else, set error flag
        ret                         ; and exit

        ; Retreive transition associated with this event
.next1
        ld   ix,(transitions)       ; start of transitions table
.loop1
;         LOG  messages.fsmTriggerMsg,''0''
        ld   a,(eventNameSave)      ; retreive event name
        cp   (ix+EVENT_NAME_IDX)    ; does transition event match the requested one?
        jr   z,.next2               ; yes, jump to .next2
.loop2
;         LOG  messages.fsmTriggerMsg,''1''
        ld   bc,{SIZEOF}transitionStruct    ; lenght of transition struct.
        add  ix,bc                  ; compute address of next transition

        ; Check for end of table (event name is #ff)
        ld   b,(ix+EVENT_NAME_IDX)
        inc  b
        ld   a,''B''                  ; error num
        jr   nz,.loop1              ; #ff+1 -> 0
        scf
        ret

.next2
        ; Check transition src
        ld   a,''*''                  ; get current state
        cp   (ix+SRC_IDX)           ; check if transition src matches wildcard
;         LOG  messages.fsmTriggerMsg,''2''
        jr   z,.next3               ; if yes, continue
        ld   a,(state)              ; get current state
        cp   (ix+SRC_IDX)           ; check if it matches transition src
;         LOG  messages.fsmTriggerMsg,''3''
        jr   z,.next3               ; if yes, continue
        ld   a,(eventNameSave)      ; if not, retreive event and starts over
        jp   .loop2

.next3
;         LOG  messages.fsmTriggerMsg,''4''

        ; Check if transition dst is ''=''
        ld   a,(ix+DST_IDX)
        cp   ''=''
        jr   nz,.next4
;         LOG  messages.fsmTriggerMsg,''5''
        ld   a,(ix+SRC_IDX)         ; dst = src
.next4
;         LOG  messages.fsmTriggerMsg,''6''

        ; Fill event
        ld   (event.dst),a
        ld   a,(ix+SRC_IDX)
        ld   (event.src),a
        ld   a,(ix+EVENT_NAME_IDX)
        ld   (event.name),a

        ; Execute the onBefore handler
        ; TODO: make a macro
        scf                         ; set Carry flag
        ccf                         ; invert Carry flag -> clear Carry flag
        ld   hl,.onBeforeCont       ; as we use a jp to call the onBefore handler,
        push hl                     ;   we need to put the next address onto the stack
        ld   l,(ix+BEFORE_IDX)
        ld   h,(ix+BEFORE_IDX+1)
        push hl                     ; push the onBefore handler address to the stack
        ld   hl,event               ; make HL points to the event
        ret                         ; jumps to onBefore we just pushed on the stack
        
.onBeforeCont                       ; as we pushed the .onBeforeCont address to the stack,
                                    ;   the RET of the onBefore handler will lead here
;         LOG  messages.fsmTriggerMsg,''7''
        ld   a,''C''                  ; error num
        ret  c                      ; if the handler set the Carry, it means it wants to cancel

;         LOG  messages.fsmTriggerMsg,''8''

        ; Check if transition dst is equal to src, or ''=''
        ; TODO: test event.dst and event.src to avoid 2 tests?
        ld   a,(ix+DST_IDX)
        cp   (ix+SRC_IDX)
        jr   z,.next5
        cp   ''=''
        jr   z,.next5

;         LOG  messages.fsmTriggerMsg,''9''

        ; Fill pending transition
        ld   a,1
        ld   (pendingTransition.enable),a

        ld   l,(ix+LEAVE_IDX)
        ld   h,(ix+LEAVE_IDX+1)
        ld   (pendingTransition.onLeave),hl

        ld   l,(ix+ENTER_IDX)
        ld   h,(ix+ENTER_IDX+1)
        ld   (pendingTransition.onEnter),hl

        ld   l,(ix+AFTER_IDX)
        ld   h,(ix+AFTER_IDX+1)
        ld   (pendingTransition.onAfter),hl

        ; Check async flag
        ld   a,(ix+ASYNC_IDX)
        or   a                      ; test async flag
        ret  nz                     ; if set, end the fsm_trigger routine (user must manually call ''fsm_transition'')
;         LOG  messages.fsmTriggerMsg,''a''
        jp   transition             ; if not set, execute the transition. This ends ''fsm_trigger''

        ; Execute onLeave, onReEnter and onAfter
.next5
;         LOG  messages.fsmTriggerMsg,''b''
        ld   hl,.onLeaveCont
        push hl
        ld   l,(ix+LEAVE_IDX)
        ld   h,(ix+LEAVE_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
.onLeaveCont
        ld   hl,.onReEnterCont
        push hl
        ld   l,(ix+REENTER_IDX)
        ld   h,(ix+REENTER_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
.onReEnterCont
        ; This is the last callback, so we do not push the return address on the stack
        ld   l,(ix+AFTER_IDX)
        ld   h,(ix+AFTER_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
; -----------------------------------------

; -----------------------------------------
; Handle transition
; only needed to be called by user in case of async transition
; Called internally for sync transitions
transition
        LOG  messages.fsmTransitionMsg,'' ''

        ; Reset pending transition
        xor  a
        ld   (pendingTransition.enable),a

        ; Set dest as current state
        ld   a,(event.dst)
        ld   (state),a

        ; Execute onLeave, onReEnter and onAfter
        ld   hl,.onLeaveCont
        push hl
        ld   l,(ix+LEAVE_IDX)
        ld   h,(ix+LEAVE_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
.onLeaveCont
        ld   hl,.onEnterCont
        push hl
        ld   l,(ix+ENTER_IDX)
        ld   h,(ix+ENTER_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
.onEnterCont
        ; This is the last callback, so we do not push the return address on the stack
        ld   l,(ix+AFTER_IDX)
        ld   h,(ix+AFTER_IDX+1)
        push hl
        ld   hl,event               ; HL points to the event
        ret
; -----------------------------------------

; -----------------------------------------
; Datas
; -----------------------------------------

initState   DEFB 0
state       DEFB 0
eventNameSave DEFB 0
transitions DEFW 0                  ; address of transitions
STRUCT pendingTransitionStruct pendingTransition
STRUCT eventStruct event

MODULE OFF


; -----------------------------------------
; Entry point
;
; Unittests has example code
; -----------------------------------------
start
PRINT {hex}start

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

;         ; Set mode 2
;         ld   a,2
;         call #bc0e

;         ; Set border color
;         ld   bc,#0404
;         call #bc38

        ; Store transitions table to FSM
        ld   hl,testTransitions
        call fsm_setTransitions

        ; Init FSM
        LOG  messages.fsmInitMsg,'' ''
        ld   a,0                    ; initial state
        call fsm_init

        ; Tests trigger
        ; TODO: execute one test at a time, and wait for key pressed before next
        LOG  messages.tstMsg,''a''
        ld   a,''a''                  ; select event ''a''
        call fsm_trigger            ; trigger event
        call c,printStatus.error
        jr   c,.next1
        call fsm_getState           ; get new state in A
        cp   1                      ; check if state is correct
        ld   a,''1''                  ; num error
        call nz,printStatus.error
        jr   nz,.next1
        call printStatus.ok

.next1
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''b''
        ld   a,''b''                  ; select event ''b''
        call fsm_trigger            ; trigger event
        call c,printStatus.error
        jr   c,.next2
        call fsm_getState           ; get new state in A
        cp   2                      ; check if state is correct
        ld   a,''2''                  ; num error
        call nz,printStatus.error
        jr   nz,.next2
        call printStatus.ok

.next2
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''e''
        ld   a,''e''                  ; select event ''e''
        call fsm_trigger            ; trigger event
        call c,printStatus.error
        jr   c,.next3
        call fsm_getState           ; get new state in A
        cp   3                      ; check if state is correct
        ld   a,''3''                  ; num error
        call nz,printStatus.error
        jr   nz,.next3
        call printStatus.ok

.next3
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''z''
        ld   a,''z''                  ; select event ''z''
        call fsm_trigger            ; trigger event
        call nc,printStatus.error   ; must generate an error (event does not exists)
        jr   nc,.next4
        call printStatus.ok

.next4
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''f''
        ld   a,''f''                  ; select event ''f''
        call fsm_trigger            ; trigger event
        call nc,printStatus.error   ; must generate an error (onBefore cancels trigger)
        jr   nc,.next5
        call printStatus.ok

.next5
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''g''
        ld   a,''g''                  ; select event ''g''
        call fsm_trigger            ; trigger event
        call fsm_getState           ; get new state in A
        cp   3                      ; check if state is correct (as event is async, it should not change)
        ld   a,''3''                  ; num error
        call nz,printStatus.error
        jr   nz,.next6
        call fsm_transition
        call c,printStatus.error
        jr   c,.next6
        call fsm_getState           ; get new state in A
        cp   1                      ; check if state is correct
        ld   a,''4''                  ; num error
        call nz,printStatus.error
        jr   nz,.next6
        call printStatus.ok

.next6
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls
        LOG  messages.tstMsg,''h''
        ld   a,''h''                  ; select event ''h''
        call fsm_trigger            ; trigger event
        call c,printStatus.error
        jr   c,.next7
        call fsm_getState           ; get new state in A
        cp   1                      ; check if state is correct
        ld   a,''5''                  ; num error
        call nz,printStatus.error
        jr   nz,.next7
        call printStatus.ok

.next7
        call #bb06
        ld   bc,#0101               ; reset border color
        call #bc38
        call #bb6c                  ; cls

        jp   #0000                  ; reboot

printStatus
.ok
        ld   bc,#0909               ; select border color green
        jr   .setBorderColor
.error
        ld   hl,messages.errorMsg,
        ld   (messages.errorMsg+6),a   ; store error code
        call printf                 ;   print it
        ld   bc,#0303               ;   and select border color red
.setBorderColor
        push af
        call #bc38
        pop af
        ret

; ----------------------------------

; ----------------------------------
; Sub-routines
; ----------------------------------

; ----------------------------------
; Print text
; HL contains the text address
; text must end with 0
printf
        ld   a,(hl)
        or   a
        jr   z,.next
        call #bb5a
        inc  hl
        jr   printf

.next
        ld   A,10
        call #bb5a
        ld   A,13
        call #bb5a
        ret


; ----------------------------------
; data
; ----------------------------------

; Transitions
testTransitions
        FSMDEFTRANSITION ''a'', 0, 1, 0,onBefore,      onLeave,onEnter,onReEnter,onAfter
        FSMDEFTRANSITION ''b'', 1, 2, 0,onBefore,      onLeave,onEnter,onReEnter,onAfter
        FSMDEFTRANSITION ''e'',''*'',3, 0,onBefore,      onLeave,onEnter,onReEnter,onAfter
        FSMDEFTRANSITION ''f'', 3, 1, 0,onBeforeCancel,onLeave,onEnter,onReEnter,onAfter
        FSMDEFTRANSITION ''g'', 3, 1, 1,onBefore,      onLeave,onEnter,onReEnter,onAfter
        FSMDEFTRANSITION ''h'', 1,''='',0,onBefore,      onLeave,onEnter,onReEnter,onAfter
;         FSMDEFTRANSITION ''i'',(0, 1),1,0,onBefore,onLeave,onEnter,onReEnter,onAfter TODO!!!
DEFB 0xff ; end of table

; When onXXX callbacks are called, HL points to the event
; TODO: log the event
onBefore
        LOG  messages.onBeforeMsg,'' ''
        ret

onBeforeCancel
        LOG  messages.onBeforeCancelMsg,'' ''
        scf                             ; set Carry flag to cancel
        ret

onLeave
        LOG  messages.onLeaveMsg,'' ''
        ret

onEnter
        LOG  messages.onEnterMsg,'' ''
        ret

onReEnter
        LOG  messages.onReEnterMsg,'' ''
        ret

onAfter
        LOG  messages.onAfterMsg,'' ''
        ret

; Messages
messages
.fsmInitMsg         DEFB "fsm_init",0
.fsmTriggerMsg      DEFB "fsm_trigger",0
.fsmtransitionMsg   DEFB "fsm_transition",0
.tstMsg             DEFB "Test",0

.errorMsg           DEFB "Error _",0

.onBeforeMsg        DEFB "onBefore",0
.onBeforeCancelMsg  DEFB "onBeforeCancel",0
.onLeaveMsg         DEFB "onLeave",0
.onEnterMsg         DEFB "onEnter",0
.onReEnterMsg       DEFB "onReEnter",0
.onAfterMsg         DEFB "onAfter",0
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

-- Project 44: bluepillcpc by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'bluepillcpc',
    'Imported from z80Code. Author: fma. Code to send midi data to interface',
    'public',
    false,
    false,
    '2022-08-13T19:13:32.425000'::timestamptz,
    '2022-08-13T19:14:02.860000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; 110 MEMORY &2800-1
; 120 CAT
; 130 INPUT "Song";song$
; 140 LOAD song$,&2900
; 180 PRINT
; 190 PRINT "Done. Press key to start program."
; 200 PRINT
; 210 a$=INKEY$:IF a$="" THEN 210
; 220 REM
; 225 OUT &FEAD,&3F:a=INP(&FEAC)
; 230 CALL &2800
; 240 RUN

ORG #2800

midiData    EQU #2900

; -----------------------------------------
; Main prog.
start
        LD   A,2                    ; mode 2
        CALL #BC0E                  ; set mode

        LD   DE,0                   ; reset timer
        LD   HL,0
        CALL #BD10                  ; set elapsed timer (DEHL = 1/300s value)

        LD   HL,midiAddr            ; write midiData start adress #4000 into pointer reg.
        LD   (HL),midiData mod 256
        INC  HL
        LD   (HL),midiData / 256
        LD   HL,(midiAddr)          ; load first time delta from data

        LD   E,(HL)                 ; store first time delta into curCount
        LD   D,0
        LD   (curCount),DE

.next
        CALL #BB09                  ; scan keyboard
        CP   0                      ; not keypress?
        JR   Z,.midiAvailable
        CP   ''q''                    ; q = quit
        RET  Z

.midiAvailable
        CALL _avail
        CP   1
        JR   Z,.process
        CP   2                      ; 2 = end of data
        JR   NZ,.next

        RET

.process
        CALL _outa
        JR   .next
; -----------------------------------------

; -----------------------------------------
;
_avail
        CALL #BD0D                  ; get timer. We are interested in HL (faster running)
        LD   DE,(curCount)
        LD   D,0
        SBC  HL,DE
        JR   C,.notYet              ; current ticker (HL) smaller than MIDI next counter (DE)

        ; next MIDI byte
        LD   HL,(midiAddr)          ; load MIDI data for current block
        INC  HL                     ; advance to read MIDI data for the match
        LD   B,(HL)                 ; read MIDI data for current block
        INC  HL                     ; pointer points to next MIDI block, pre-load curCounter
        PUSH HL                     ; save current pointer, preload counter
        LD   E,(HL)
        LD   D,0
        LD   (curCount),DE          ; store next counter for fast access during playback
        LD   A,E
        CP   #FF
        JR   Z,.endOfSong
        LD   HL,lastByte
        LD   (HL), B                ; store MIDI byte there
        POP  DE                     ; get saved pointer
        LD   HL,midiAddr
        LD   (HL),E                 ; update pointer
        INC  HL
        LD   (HL),D
        LD   A,1                    ; signal byte is available

        RET

.notYet
        LD   A,0                    ; signal no byte available

        RET

.endOfSong
        LD   A,"@"
        CALL #BB5D                  ; like #BB5A but do not interpret control chars
        POP  HL                     ; clean up stack for return...
        LD   A,2                    ; signal end of song data

        RET
; -----------------------------------------

; -----------------------------------------
;
_outa
        LD   BC,#FEAC
        LD   A,(lastByte)
        OUT  (C),A

        LD   DE,0                   ; reset timer
        LD   HL,0
        CALL #BD10                  ; set elapsed timer (DEHL = 1/300s value)

        RET
; -----------------------------------------

; -----------------------------------------
lastByte    DEFB 0
curCount    DEFW 0
midiAddr    DEFW 0
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
