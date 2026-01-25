-- Migration: Import z80code projects batch 53
-- Projects 105 to 106
-- Generated: 2026-01-25T21:43:30.200109

-- Project 105: toolbox by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'toolbox',
    'Imported from z80Code. Author: Unknown.',
    'public',
    false,
    false,
    '2019-09-08T00:44:20.738000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Affectation du contenu de A dans un registre du PSG
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
mend',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 106: compiled9 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'compiled9',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2019-11-19T19:30:22.006000'::timestamptz,
    '2021-06-18T22:37:04.633000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'NUM_SPRITES EQU 20		;  Num of sprites
SEP         EQU 3	    ;  Separation between sprites
SEP2        EQU 6
; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc

; ---------------------------------------------------------------------------
; ------------------------------------------------------------------------------
;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00
CRTC_READ           equ #BF00

; ---------------------------------------------------------------------------
; WRITE_CRTC
 macro WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
 endm

; =============================================================
; Gate Array
; =============================================================
; http://www.cpcwiki.eu/index.php/Gate_Array
; http://quasar.cpcscene.net/doku.php?id=assem:gate_array
; -------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; -------------------------------------------------------------
; Registers
PENR:           equ %00000000
INKR:           equ %01000000
RMR:            equ %10000000

; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF

macro SET_MODE mode 
                LD bc, GATE_ARRAY | RMR | ROM_OFF | {mode}
                out (c), c
endm

macro SET_COLOR INK,COL 
                LD bc, GATE_ARRAY |{INK}
                OUT (c), c
                LD c, ({COL} & 31) | 64
                OUT (c), c
endm

macro SET_PALETTE palette, start, length
                ld a, {start}
                ld c, {length}
                ld hl, {palette}
                ld b, hi(GATE_ARRAY)
@loop:
                out (c), a
                inc b
                outi
                inc a
                dec c
                jr nz, @loop
endm

; ================================================================
; PPI
; ==============================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc
; --------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700

macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
endm


macro bc26_hl:
                ld a, h 
                add a, 8 
                ld h, a 
                jr nc, @end
                ld a, #60
                add l
                ld l, a 
                ld a, #c0
                adc h 
                ld h, a
@end
mend              

macro WAIT_LINE n 
                ld b, {n}
@b              ds 60
                djnz @b
mend    


                di
                ld hl, #c9fb 
                ld (#38), hl 
                ei

                SET_MODE 0
                WRITE_CRTC 6, 15
                WRITE_CRTC 1, 48
                WRITE_CRTC 2, 50
                WRITE_CRTC 3, 8
                ld ix, traj

                WAIT_VBL (void)
                WAIT_LINE 4 * 8
                WRITE_CRTC 7, #ff
                WRITE_CRTC 4, 15 - 1
                
main_loop:



displayAll:   


                di 
                ld (.saveStack + 1), sp 
                ld sp, stackClearEnd
.index:          ld ix,traj
repeat NUM_SPRITES / 2, n
                ld iy, @ret
                ld h, hi(ball_ptr)
                ld a, n - 1
                
	            add a, a 
                ld l, a 
                ld a, (hl)
                inc l 
                ld h, (hl)
                ld l, a 

                SET_COLOR 16, 1+(n&1)
    	        ld e, (ix + 0)
                ld d, (ix + 1)
	            ld a, ixl
                add (2 * SEP)
                ld ixl, a
                jp (hl)
@ret:           
rend
.index2:          ld ix,traj2
repeat NUM_SPRITES / 2, n
                ld iy, @ret
                ld h, hi(ball_ptr)
                ld a, n - 1
                
	            add a, a 
                ld l, a 
                ld a, (hl)
                inc l 
                ld h, (hl)
                ld l, a 

                SET_COLOR 16, 1+(n&1)
    	        ld e, (ix + 0)
                ld d, (ix + 1)
	            ld a, ixl
                add (2 * SEP2)
                ld ixl, a
                jp (hl)
@ret:           
rend
.saveStack:     ld sp, 0
	            ei
                SET_COLOR 16, #54

                ld ix, (.index+2)
                inc ixl
                inc ixl
                ld (.index+2), ix
                
                ld ix, (.index2+2)
                inc ixl
                inc ixl
                ld (.index2+2), ix

                WRITE_CRTC 7, #ff
                WRITE_CRTC 4, 15 - 1
                SET_COLOR 16, #44
                halt
                halt 
                SET_PALETTE palette2, 0, 16 
                halt
                
                WRITE_CRTC 4, 24 - 1
                WRITE_CRTC 7, 24 - 7
              

                WAIT_VBL (void)
                SET_PALETTE palette, 0, 16      
                SET_COLOR 16, #4b
clearAll:       
                
                di 
                ld (.saveStack + 1), sp 
                ld sp, stackClear
                xor a
repeat NUM_SPRITES
    repeat 8
                pop hl 
                ld (hl), a
                inc hl
                ld (hl), a
    rend
rend
.saveStack:    ld sp, 0
	            ei
                SET_COLOR 16, #54


               
                jp main_loop




align 256 

traj:
	repeat 128,angle
    x = 48+44*cos(360*angle/128)
    y = 60+22*sin(2*360*angle/128)
	y0 = (y>>3)
    y1 = (y & 7)
    dw #c000 + x + (y0*96) + (#800*y1)
    rend

traj2:
	repeat 128,angle
    t = 360 * angle / 128
    a = 3
    b = 180 / 6
    x = 48+44*sin(t)
    y = 60+22*sin(a * t + b)
	y0 = (y>>3)
    y1 = (y & 7)
    dw #c000 + x + (y0*96) + (#800*y1)
    rend


palette:
    db #54,#44,#55,#57,#58,#5D,#5C,#4C,#47,#56,#5E,#52,#4E,#4A,#40,#4B

palette2
    db #54,#4A,#40,#4B,#44,#55,#57,#58,#5D,#5C,#4C,#47,#56,#5E,#52,#4E

align 256
ball_ptr:
repeat NUM_SPRITES, i
    dw ball_{i - 1}
rend



stackClear:
    ds 8 * NUM_SPRITES * 2
stackClearEnd:

ball_0:
ex hl, de
push hl
ld (hl), #44
inc hl
ld (hl), #8
dec hl
bc26_hl (void)
push hl
ld (hl), #44
inc hl
ld (hl), #8
dec hl
bc26_hl (void)
push hl
ld (hl), #8c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #8c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #40
inc hl
ld (hl), #80
dec hl
bc26_hl (void)
push hl
ld (hl), #40
inc hl
ld (hl), #80
jp (iy)


ball_1:
ex hl, de
push hl
ld (hl), #44
inc hl
ld (hl), #8
dec hl
bc26_hl (void)
push hl
ld (hl), #40
inc hl
ld (hl), #80
dec hl
bc26_hl (void)
push hl
ld (hl), #8c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #c0
inc hl
ld (hl), #c0
dec hl
bc26_hl (void)
push hl
ld (hl), #c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #c
inc hl
ld (hl), #48
dec hl
bc26_hl (void)
push hl
ld (hl), #40
inc hl
ld (hl), #80
dec hl
bc26_hl (void)
push hl
ld (hl), #40
inc hl
ld (hl), #80
jp (iy)


ball_2:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #a8
dec hl
bc26_hl (void)
push hl
ld (hl), #51
inc hl
ld (hl), #a8
dec hl
bc26_hl (void)
push hl
ld (hl), #f6
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #f6
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #fc
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #fc
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
jp (iy)


ball_3:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #f6
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #3c
inc hl
ld (hl), #3c
dec hl
bc26_hl (void)
push hl
ld (hl), #fc
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #fc
inc hl
ld (hl), #bc
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
jp (iy)


ball_4:
ex hl, de
push hl
ld (hl), #45
inc hl
ld (hl), #a
dec hl
bc26_hl (void)
push hl
ld (hl), #45
inc hl
ld (hl), #a
dec hl
bc26_hl (void)
push hl
ld (hl), #8f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #8f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
jp (iy)


ball_5:
ex hl, de
push hl
ld (hl), #45
inc hl
ld (hl), #a
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #8f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #c3
inc hl
ld (hl), #c3
dec hl
bc26_hl (void)
push hl
ld (hl), #f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #f
inc hl
ld (hl), #4b
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
jp (iy)


ball_6:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
jp (iy)


ball_7:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #3c
inc hl
ld (hl), #3c
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #36
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
dec hl
bc26_hl (void)
push hl
ld (hl), #14
inc hl
ld (hl), #28
jp (iy)


ball_8:
ex hl, de
push hl
ld (hl), #44
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #44
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #d8
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #d8
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
jp (iy)


ball_9:
ex hl, de
push hl
ld (hl), #44
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #d8
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #30
inc hl
ld (hl), #30
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
jp (iy)


ball_10:
ex hl, de
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #11
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #11
inc hl
ld (hl), #22
jp (iy)


ball_11:
ex hl, de
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #11
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #33
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b3
dec hl
bc26_hl (void)
push hl
ld (hl), #11
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #11
inc hl
ld (hl), #22
jp (iy)


ball_12:
ex hl, de
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #15
inc hl
ld (hl), #2a
dec hl
bc26_hl (void)
push hl
ld (hl), #15
inc hl
ld (hl), #2a
jp (iy)


ball_13:
ex hl, de
push hl
ld (hl), #55
inc hl
ld (hl), #a2
dec hl
bc26_hl (void)
push hl
ld (hl), #15
inc hl
ld (hl), #2a
dec hl
bc26_hl (void)
push hl
ld (hl), #fb
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #3f
inc hl
ld (hl), #3f
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #f3
inc hl
ld (hl), #b7
dec hl
bc26_hl (void)
push hl
ld (hl), #15
inc hl
ld (hl), #2a
dec hl
bc26_hl (void)
push hl
ld (hl), #15
inc hl
ld (hl), #2a
jp (iy)


ball_14:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #2
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #2
jp (iy)


ball_15:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #22
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #2
dec hl
bc26_hl (void)
push hl
ld (hl), #b3
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #3
inc hl
ld (hl), #3
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #33
inc hl
ld (hl), #23
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #2
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #2
jp (iy)


ball_16:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #8a
dec hl
bc26_hl (void)
push hl
ld (hl), #51
inc hl
ld (hl), #8a
dec hl
bc26_hl (void)
push hl
ld (hl), #e7
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #e7
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #cf
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #cf
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
jp (iy)


ball_17:
ex hl, de
push hl
ld (hl), #51
inc hl
ld (hl), #8a
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #e7
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #c3
inc hl
ld (hl), #c3
dec hl
bc26_hl (void)
push hl
ld (hl), #cf
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #cf
inc hl
ld (hl), #cb
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
dec hl
bc26_hl (void)
push hl
ld (hl), #41
inc hl
ld (hl), #82
jp (iy)


ball_18:
ex hl, de
push hl
ld (hl), #1
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #1
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #52
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #52
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
jp (iy)


ball_19:
ex hl, de
push hl
ld (hl), #1
inc hl
ld (hl), #a0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #52
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #30
inc hl
ld (hl), #30
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #f0
inc hl
ld (hl), #b0
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
dec hl
bc26_hl (void)
push hl
ld (hl), #10
inc hl
ld (hl), #20
jp (iy)



',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: sprite-compils
  SELECT id INTO tag_uuid FROM tags WHERE name = 'sprite-compils';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
