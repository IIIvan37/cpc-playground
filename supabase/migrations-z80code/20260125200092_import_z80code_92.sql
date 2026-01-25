-- Migration: Import z80code projects batch 92
-- Projects 183 to 184
-- Generated: 2026-01-25T21:43:30.209202

-- Project 183: program383 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program383',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2024-01-30T22:12:25.528000'::timestamptz,
    '2024-01-30T22:28:20.147000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; sample code (skeleton)
 org #A000

_start:

 run $

; Restore firmware in RAM
 LD SP,#C000

; Select lower ROM
 LD BC,#7F80 | %1001
 OUT (C),C

 EXX
 XOR A
 EX AF,AF''

 CALL #0044                  ; restore #00-#40 and
 CALL #08BD                  ; restore vectors

; Other calls made by the ROM
 CALL #1B5C
 CALL #1FE9
 CALL #0ABF
 CALL #1074
 CALL #15A8
 CALL #24BC
 CALL #07E0

; Back to RAM
 LD   BC,#7F80 | %1101
 OUT  (C),C

 LD   A,1
 CALL #BC0E                  ; set mode 1


TXT_OUTPUT  equ #BB5A
KM_WAIT_KEY equ #BB18

    LD HL, message
message_loop:
    LD A,(HL)
    INC HL
    OR A
    JR Z, message_end
;    push hl
    CALL TXT_OUTPUT
;    pop hl
    JR message_loop
message_end:
    CALL KM_WAIT_KEY
    ret

message DB "Hello world !!",0

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

-- Project 184: program385 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program385',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2024-03-01T09:39:12.066000'::timestamptz,
    '2024-03-01T11:07:50.114000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';Uncomment line 174, and see how jitter disappears


MACRO M_LOADCRTC r,v
    ld bc, #bc00+{r}
    out (c),c
    inc b
    ld c,{v}
    out (c),c
    
ENDM


org #1000
run #1000


; -----------------------------------------
start

        CALL disableRasterInterrupt

        LD  SP,#38

        ; Game init
        ...

        call enableRasterInterrupt
mainLoop
        ; Game management...
        ...

        JR   mainLoop
; -----------------------------------------


SWITCH_TO_HUD_ONLY EQU 1
SWITCH_TO_HUD_SCREEN EQU 2

; -----------------------------------------
rasterInterrupt
        PUSH AF

        ; Test if interrupt occured during Vsync
        LD   A,#F5
        IN   A,(#FF)
        RRA
        JR   C,.next
        POP  AF
        EI
        RET

.next
        PUSH BC
        PUSH DE
        PUSH HL
        PUSH IX
        PUSH IY

        CALL disableRasterInterrupt

        LD   A,(switchScreenHud)
        CP   SWITCH_TO_HUD_ONLY
        JR   Z,.switchToHudOnly
        CP   SWITCH_TO_HUD_SCREEN
        JR   Z,.switchToHudScreen
        JP   .sync

.switchToHudOnly
        M_LOADCRTC 4,63               ; increase total screen length by 25 lines
        M_LOADCRTC 6,7                ; reduce visible screen height to 7
        M_LOADCRTC 7,9                ; shift image down by setting Vsync at 9
        M_LOADCRTC 12,%110000         ; set screen address at [#C000-#FFFF]
        M_LOADCRTC 13,#00             ; no offset
        HALT                              ; ensure VCC > 63
        HALT
        HALT
        HALT
        HALT
        M_LOADCRTC 4,38               ; restore total screen length

        XOR  A
        LD   (switchScreenHud),A

        ; Sync on next frame
        HALT

        JP   .sync

.switchToHudScreen
        ld bc,#7F01
        out (c),c
        ld a,#54
        out (c),a
        
        inc c
        out (c),c
        ld a,#54
        out (c),a
        
        inc c
        out (c),c
        ld a,#54
        out (c),a
        inc c
        
;        color.M_SELECTINK 1
;        color.M_SETCOLOR color.HW.BLACK
;        color.M_SELECTNEXTINK
;        color.M_SETCOLOR color.HW.BLACK
;        color.M_SELECTNEXTINK
;        color.M_SETCOLOR color.HW.BLACK

        M_LOADCRTC 4,13               ; reduce total screen length by 25 lines
        M_LOADCRTC 6,32               ; increase visible screen height to 32
        M_LOADCRTC 7,34               ; shift image down by setting Vsync at 34
        M_LOADCRTC 12,%101100         ; set screen address at [#8000-#FFFF]
        M_LOADCRTC 13,#30/2           ; offset
        HALT                              ; ensure VCC > 13
        M_LOADCRTC 4,38               ; restore total screen length

        ; Wait start of hud raster lines
        HALT
        HALT
        HALT
        ;rt.M_WAIT 29,32

        repeat 39
        ds 32
        rend
        

        ; Set hud inks
        ;CALL raster.do.hud

        repeat 200,i        
            ld bc,#7F00
            out (c),c
            ld a,#40+(i&15)
            out (c),a
            ds 64-13,0                
        rend

        XOR  A
        LD   (switchScreenHud),A

        ; Sync on next frame
        HALT
        HALT

.sync
        DI

        ; Constant time routines to execute once a frame
        ;...


        ; Wait start of raster lines
        ;rt.M_WAIT 32,20
        repeat 32
        ds 32
        rend
        
        ;CALL raster.do
        repeat 200,i        
            ld bc,#7F00
            out (c),c
            ld a,#40+(i&15)
            out (c),a
            ds 64-13,0        
        rend
        
        
        ; This nop stabilizes the effect :O Uncomment 
        ;nop
        

        EI

        ; Non-constant time routines to execute once a frame
        ...

        CALL enableRasterInterrupt

        POP  IY
        POP  IX
        POP  HL
        POP  DE
        POP  BC
        POP  AF

        RET
; -----------------------------------------

; -----------------------------------------
disableRasterInterrupt
        DI
        LD   HL,#C9FB    ; EI : RET
        LD   (#0038),HL
        EI
        RET
; -----------------------------------------

; -----------------------------------------
enableRasterInterrupt
        DI
        LD   A,#C3
        LD   (#0038),A
        LD   HL,rasterInterrupt
        LD   (#0039),HL
        EI
        RET
; -----------------------------------------

; -----------------------------------------
; Data
switchScreenHud     DEFB 0
; -----------------------------------------

; -----------------------------------------
; Wait start of VSYNC
    MACRO rt.M_VSYNC_WAIT_START
        LD   B,#F5
.loop
        HALT
        IN   C,(C)
        RRA
        JR   NC,.loop
    ENDM
; -----------------------------------------

; -----------------------------------------
; Wait end of VSYNC
    MACRO rt.M_VSYNC_WAIT_END
        LD   B,#F5
.loop
        IN   C,(C)
        RRA
        JR   C,.loop
    ENDM
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
