-- Migration: Import z80code projects batch 84
-- Projects 167 to 168
-- Generated: 2026-01-25T21:43:30.206674

-- Project 167: program315 by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program315',
    'Imported from z80Code. Author: fma.',
    'public',
    false,
    false,
    '2022-07-24T14:35:17.782000'::timestamptz,
    '2022-07-24T14:35:17.795000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Conversion font to sprite
; En cours de dev...

BUILDSNA
BANKSET 0
ORG #4000
RUN start

GATE_ARRAY  EQU #7F00
BLACK       EQU #14
WHITE       EQU #00

; -----------------------------------------
; Select ink (use 16 for border)
MACRO M_SELECTINK ink
        LD   BC,GATE_ARRAY+{ink}
        OUT  (C),C
ENDM
; -----------------------------------------

; -----------------------------------------
; Set current ink to color
; Must be used after a M_SELECTINK or M_SETINKCOLOR macro
MACRO M_SETCOLOR color
        LD   A,#40+{color}
        OUT  (C),A
ENDM
; -----------------------------------------

; -----------------------------------------
; Test code
start
        ; Inhibit RST 38 interrupt vector
        DI
        LD   HL,#C9FB
        LD   (#38),HL
        EI

        LD  SP,#C000

;         M_SELECTINK 16
;         M_SETCOLOR BLACK
        M_SELECTINK 0
        M_SETCOLOR WHITE

        LD   HL,font.F
        LD   A,0
        CALL _font2Sprite
        LD   HL,#C050
        CALL _displaySprite

        LD   HL,font.F
        LD   A,1
        CALL _font2Sprite
        LD   HL,#C052
        CALL _displaySprite

        LD   HL,font.F
        LD   A,2
        CALL _font2Sprite
        LD   HL,#C054
        CALL _displaySprite

        LD   HL,font.F
        LD   A,3
        CALL _font2Sprite
        LD   HL,#C056
        CALL _displaySprite

        JR   $
; -----------------------------------------

; -----------------------------------------
; Convert font defined as bits (8 bytes height) to sprite in mode 1 (16 bytes)
;
; Input:
;   A = pen
;   HL = pointer to font as bits (8 bytes height)
; Output:
;   Result stored at ''sprite'' address
;
; TODO: mask + OR with background
_font2Sprite
        CP   1                      ; pen 1?
        JR   Z,.pen1                ; yes
        CP   2                      ; pen 2?
        JR   Z,.pen2                ; yes
        CP   3                      ; pen 3?
        JR   Z,.pen3                ; yes
        
.pen0
        ; Clear sprite
        LD   HL,sprite
        LD   DE,sprite+1
        LD   BC,2*8-1
        LD   (HL),#00
        LDIR
        
        RET

.pen1
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop1
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        SLA  A
        SLA  A
        SLA  A
        SLA  A                      ; transfert to higher nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop1
        
        RET

.pen2
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop2
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        SRL  A
        SRL  A
        SRL  A
        SRL  A                      ; transfert to lower nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop2

        RET
        
.pen3
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop3
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        LD   C,A
        SRL  A
        SRL  A
        SRL  A
        SRL  A                      ; transfert to lower nibble
        OR   C
        LD   (DE),A                 ; store to sprite pointer
        
        INC  DE                     ; increment sprite pointer
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        LD   C,A
        SLA  A
        SLA  A
        SLA  A
        SLA  A                      ; transfert to higher nibble
        OR   C
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop3

        RET
; -----------------------------------------

; -----------------------------------------
; Display sprite
; Input:
;   HL = screen destination address
_displaySprite
        LD   DE,sprite
        LD   B,8                    ; nb sprite lines
.loop
        PUSH BC                     ; preserve lines counter
        PUSH HL                     ; preserve screen address (start of line)

        LD   A,(DE)                 ; get sprite
        INC  DE                     ; increment sprite address
        LD   (HL),A                 ; put byte on screen
        INC  HL                     ; increment screen address

        LD   A,(DE)                 ; get sprite
        INC  DE                     ; increment sprite address
        LD   (HL),A                 ; put byte on screen
        INC  HL                     ; increment screen address

        POP  HL                     ; restore screen address (start of line)
        CALL _bc26                  ; compute next screen address

        POP  BC                     ; restore lines counter
        DJNZ .loop                  ; loop on lines (height)

        RET
; -----------------------------------------

; -----------------------------------------
; Compute video address below
; Input:
;   HL = current address
; Output:
;   HL = new address
_bc26
        PUSH DE                     ; save context

        LD   DE,#800
        ADD  HL,DE
        JR   NC,.end
        LD   DE,#C050
        ADD  HL,DE
.end
        POP  DE                     ; restore context

        RET
; -----------------------------------------

; -----------------------------------------
;
; Datas
;
; -----------------------------------------

sprite  DEFS 2*8

font
.F
        DEFB %01111110
        DEFB %01000000,
        DEFB %01000000,
        DEFB %01111100,
        DEFB %01100000,
        DEFB %01100000,
        DEFB %01100000,
        DEFB %00000000
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

-- Project 168: logging_service by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'logging_service',
    'Imported from z80Code. Author: fma. Full featured logger',
    'public',
    false,
    false,
    '2021-10-21T18:57:36.515000'::timestamptz,
    '2021-10-22T13:40:07.316000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; -----------------------------------------
; Unit tests for logging
; -----------------------------------------

;NOLIST
BUILDSNA
BANKSET 0
ORG #4000
run start


Module logging

IFNDEF _LOGGING_H_

; ----------------------------------
; Consts
; ----------------------------------

TRUE    EQU 1
FALSE   EQU 0

LOGGING_LEVEL_TRACE     EQU  0
LOGGING_LEVEL_DEBUG     EQU  1
LOGGING_LEVEL_INFO      EQU  2
LOGGING_LEVEL_WARNING   EQU  3
LOGGING_LEVEL_ERROR     EQU  4
LOGGING_LEVEL_CRITICAL  EQU  5

COLORS
.BLACK              EQU  0
.BLUE               EQU  1
.BRIGHT_BLUE        EQU  2
.RED                EQU  3
.MAGENTA            EQU  4
.MAUVE              EQU  5
.BRIGHT_RED         EQU  6
.PURPLE             EQU  7
.BRIGHT_MAGENTA     EQU  8
.GREEN              EQU  9
.CYAN               EQU 10
.SKY_BLUE           EQU 11
.YELLOW             EQU 12
.WHITE              EQU 13
.PASTEL_BLUE        EQU 14
.ORANGE             EQU 15
.PINK               EQU 16
.PASTEL_MAGENTA     EQU 17
.BRIGHT_GREEN       EQU 18
.SEA_GREEN          EQU 19
.BRIGHT_CYAN        EQU 20
.LIME               EQU 21
.PASTEL_GREEN       EQU 22
.PASTEL_CYAN        EQU 23
.BRIGHT_YELLOW      EQU 24
.PASTEL_YELLOW      EQU 25
.BRIGHT_WHITE       EQU 26

LET _LOGGING_H_ = 1
ENDIF
IFNDEF _LOGGING_MACRO_

; -----------------------------------------
; Change logger level
MACRO LOGGINGSETLEVEL level
        ld   a,{level}
        ld   (logging_level),a
MEND
; -----------------------------------------

; -----------------------------------------
; Generic logger
MACRO LOGGINGLOG messageAddress,level
ASSERT {level} >= LOGGING_LEVEL_TRACE & {level} <= LOGGING_LEVEL_CRITICAL

        ld   hl,{messageAddress}
        ld   a,{level}
        call logging_log
MEND
; -----------------------------------------

; -----------------------------------------
; Trace logger
MACRO LOGGINGTRACE messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_TRACE
MEND
; -----------------------------------------

; -----------------------------------------
; Debug logger
MACRO LOGGINGDEBUG messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_DEBUG
MEND
; -----------------------------------------

; -----------------------------------------
; Info logger
MACRO LOGGINGINFO messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_INFO
MEND
; -----------------------------------------

; -----------------------------------------
; Warning logger
MACRO LOGGINGWARNING messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_WARNING
MEND
; -----------------------------------------

; -----------------------------------------
; Error logger
MACRO LOGGINGERROR messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_ERROR
MEND
; -----------------------------------------

; -----------------------------------------
; critical logger
MACRO LOGGINGCRITICAL messageAddress
        LOGGINGLOG {messageAddress},LOGGING_LEVEL_CRITICAL
MEND
; -----------------------------------------

LET _LOGGING_MACRO_ = 1
ENDIF

; -----------------------------------------
; Full featured Logger:
;   - use different colors for each setLevel
;   - output current level
;   - output timing
;   - output calling current PC (calling address)
;
: TODO:
;   - allow selection of infos to output
; -----------------------------------------

; -----------------------------------------
; Load the logger colors for the current mode
loadColors
        call #bc11                  ; get screen mode
        cp   0
        jr   nz,.next1
        ld   ix,colorsMode0
        ld   b,6                    ; nb colors to set
        jr   .next3

.next1
        cp   1
        jr   nz,.next2
        ld   ix,colorsMode1
        ld   b,4                    ; nb colors to set
        jr   .next3

.next2
        ld   ix,colorsMode2
        ld   b,2                    ; nb colors to set
.next3
        ld   a,0                    ; pen 0
.loop1
        ; TODO: make critical pen color blink (with background)
        push af
        push bc
        ld   b,(ix+00)
        ld   c,b
        call #bc32                  ; set color
        pop  bc
        pop  af
        inc  a
        inc  ix
        djnz .loop1

        ld   a,TRUE
        ld   (useColors),a

        ret
; -----------------------------------------


; -----------------------------------------
; LOG message with specified level
; HL points to message
; A contains level
log
        ; First, retreive the calling address
        ; Thanks to Siko for the tip!
        pop  ix
        push ix
        dec  ix
        dec  ix
        dec  ix
        ld   (callingPC),ix

        ; Save level
        ld   (levelSave),a

        ; Check if specified level >= current level
        ld   ix,level
        cp   (ix+00)
        ret  c

        push hl                     ; save message address

        ; Set pen/paper according to log level
        ld   a,(useColors)
        cp   TRUE
        jr   nz,.next4

        call #bc11                  ; get scren mode
        cp   0
        jr   nz,.next1
        ld   ix,penPaperMode0
        jr   .next3

.next1
        cp   1
        jr   nz,.next2
        ld   ix,penPaperMode1
        jr   .next3

.next2
        ld   ix,penPaperMode2
.next3
        ; Adjust IX according to level
        ld   a,(levelSave)
        sla  a                      ; A *= 2
        ld   c,a
        ld   b,#00
        add  ix,bc

        ; Set pen/paper
        ld   a,(ix+00)
        call #bb90                  ; set pen
        ld   a,(ix+01)
        call #bb96                  ; set paper
.next4
        ; Print level
        ld   a,(levelSave)
        sla  a                      ; A *= 2
        ld   c,a
        ld   b,#00
        ld   ix,levelsTbl
        add  ix,bc
        ld   l,(ix+00)
        ld   h,(ix+01)
        call printf

        ; Separator
        ld   a,'':''
        call #bb5a

        ; Print time
        call #bd0d                  ; get time (in DEHL)
        call toChars

        ; Separator
        ld   a,'':''
        call #bb5a

        ; Print PC
        ld   a,''#''
        call #bb5a
        ld   hl,(callingPC)
        call toCharsHex

        ; Separator
        ld   a,'':''
        call #bb5a

        ; Print user message
        pop  hl
        call printf

        ; New line
        ld   a,10
        call #bb5a
        ld   a,13
        call #bb5a

        ret
; -----------------------------------------

; ----------------------------------
; Print message pointed by HL
printf
.loop
        ld   a,(hl)
        bit  7,a
        jr   nz,.end
        call #bb5a
        inc  hl
        jr   .loop

.end
        res  7,a
        call #bb5a

        ret
; ----------------------------------

; -----------------------------------------
; Convert value contained in HL in chars
; 5 digits
toChars
        ld   bc,-10000
        call .next
        ld   bc,-1000
        call .next
        ld   bc,-100
        call .next
        ld   c,-10
        call .next
        ld   c,-1
.next
        ld   a,''0''-1
.loop
        inc  a
        add  hl,bc
        jr   c,.loop
        sbc  hl,bc
        call #bb5a

        ret
; -----------------------------------------

; -----------------------------------------
; Convert value contained in HL in chars as hex
toCharsHex
        ld   c,h
        call .next1
        ld   c,l
.next1
        ld   a,c
        rra
        rra
        rra
        rra
        call .next2
        ld   a,c
.next2
        and  #0f
        add  a,#90
        daa
        adc  a,#40
        daa
        call #bb5a

        ret
; -----------------------------------------


; ----------------------------------
; data
; ----------------------------------
level       DEFB LOGGING_LEVEL_TRACE
levelSave   DEFS 1
useColors   DEFB FALSE
callingPC   DEFS 2

levelsTbl
.trace      DEFW levelsNames.trace
.debug      DEFW levelsNames.debug
.info       DEFW levelsNames.info
.warning    DEFW levelsNames.warning
.error      DEFW levelsNames.error
.critical   DEFW levelsNames.critical

levelsNames
.trace      STR "TRC"
.debug      STR "DBG"
.info       STR "INF"
.warning    STR "WRN"
.error      STR "ERR"
.critical   STR "CRT"

colorsMode0
        DEFB COLORS.BLUE
        DEFB COLORS.SKY_BLUE
        DEFB COLORS.GREEN
        DEFB COLORS.BRIGHT_WHITE
        DEFB COLORS.BRIGHT_YELLOW
        DEFB COLORS.BRIGHT_RED

colorsMode1
        DEFB COLORS.BLUE
        DEFB COLORS.SKY_BLUE
        DEFB COLORS.BRIGHT_WHITE
        DEFB COLORS.BRIGHT_RED

colorsMode2
        DEFB COLORS.BLUE
        DEFB COLORS.BRIGHT_YELLOW

penPaperMode0
.trace      DEFB 1,0
.debug      DEFB 2,0
.info       DEFB 3,0
.warning    DEFB 4,0
.error      DEFB 5,0
.critical   DEFB 3,5

penPaperMode1
.trace      DEFB 1,0
.debug      DEFB 1,0
.info       DEFB 2,0
.warning    DEFB 3,0
.error      DEFB 3,0
.critical   DEFB 2,3

penPaperMode2
.trace      DEFB 1,0
.debug      DEFB 1,0
.info       DEFB 1,0
.warning    DEFB 1,0
.error      DEFB 1,0
.critical   DEFB 0,1
; -----------------------------------------

MODULE OFF

; Unittests
start
        ; Restore firmware in RAM

        ; Restore Stack Pointer
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

        ; Display all logging levels in all modes
        ld   a,0                    ; mode
.loop
        push af
        call #bc0e
        call logging_loadColors     ; must be called after setting mode

        LOGGINGSETLEVEL LOGGING_LEVEL_TRACE
        LOGGINGTRACE messages.trace
        LOGGINGDEBUG messages.debug
        LOGGINGINFO messages.info
        LOGGINGWARNING messages.warning
        LOGGINGERROR messages.error
        LOGGINGCRITICAL messages.critical

        ; New line
        ld   a,10
        call #bb5a
        ld   a,13
        call #bb5a

        LOGGINGSETLEVEL LOGGING_LEVEL_INFO
        LOGGINGTRACE messages.trace
        LOGGINGDEBUG messages.debug
        LOGGINGINFO messages.info
        LOGGINGWARNING messages.warning
        LOGGINGERROR messages.error
        LOGGINGCRITICAL messages.critical

        ; New line
        ld   a,10
        call #bb5a
        ld   a,13
        call #bb5a

        LOGGINGSETLEVEL LOGGING_LEVEL_ERROR
        LOGGINGTRACE messages.trace
        LOGGINGDEBUG messages.debug
        LOGGINGINFO messages.info
        LOGGINGWARNING messages.warning
        LOGGINGERROR messages.error
        LOGGINGCRITICAL messages.critical

        call #bb06                  ; wait key pressed
        pop  af
        inc  a
        cp   3
        jr   nz,.next
        jp   #0000                  ; reboot

.next
        push af
        ld   a,0
        ld   b,1
        ld   c,b
        call #bc32                  ; set pen 0 color blue
        ld   a,0
        call #bb96                  ; select paper 0
        call #bb6c                  ; cls
        pop  af
        jp   .loop


; ----------------------------------
; data
; ----------------------------------

messages
.trace      STR "Bla"
.debug      STR "Bla"
.info       STR "Bla"
.warning    STR "Bla"
.error      STR "Bla"
.critical   STR "Bla"
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
