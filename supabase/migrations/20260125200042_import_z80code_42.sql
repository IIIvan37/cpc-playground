-- Migration: Import z80code projects batch 42
-- Projects 83 to 84
-- Generated: 2026-01-25T21:43:30.195784

-- Project 83: sprite_test1 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sprite_test1',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2019-11-16T23:39:07.148000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'NUM_SPRITES EQU 10		;  Num of sprites
SEP         EQU 3	    ;  Separation between sprites

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
                ld a, #50
                add l
                ld l, a 
                ld a, #c0
                adc h 
                ld h, a
@end
mend              
                
                di
                ld hl, #c9fb 
                ld (#38), hl 
                ei
				ld ix, traj
                SET_MODE 0
                
                SET_COLOR 0,#14
                SET_COLOR 1,#04
                SET_COLOR 2,#15
                SET_COLOR 3,#17
                SET_COLOR 4,#18
                SET_COLOR 5,#1D               
                
main_loop:
                WAIT_VBL (void)
				
                
index:          ld ix,traj

				SET_COLOR 16, #4c
                

repeat NUM_SPRITES,n
				SET_COLOR 16, 3+(n&1)
				ld l,(IX+0)                
                ld h,(IX+1)                
                ld a,ixl
                add (2*SEP)
                ld ixl,a                
				call clear
rend

				SET_COLOR 16, #54

		        ld ix,(index+2)
                inc ixl
                inc ixl
                ld (index+2),ix
                

repeat NUM_SPRITES,n
				SET_COLOR 16, 1+(n&1)
    			ld l,(IX+0)
                ld h,(IX+1)
				ld a,ixl
                add (2*SEP)
                ld ixl,a
                call ball_0
rend
				SET_COLOR 16, #54

                jp main_loop


ball_0:
                di
                ld (.saveStack + 1), sp
                ld sp, ball
                ld b, 8
.loop:          pop de 
                ld (hl), e: inc hl 
                ld (hl), d: dec hl
                bc26_hl (void)
                djnz .loop
.saveStack:     ld sp, 0
                ei
                ret


clear:
				ld d, 0
repeat 8 
                ld (hl), d
                inc hl 
                ld (hl), d
                dec hl
                bc26_hl (void)
rend 
                ret


ball:
 DEFB #44,#08
 DEFB #44,#08
 DEFB #8c,#48
 DEFB #8c,#48
 DEFB #0c,#48 
 DEFB #0c,#48 
 DEFB #40,#80
 DEFB #40,#80

align 256 

traj:
	repeat 128,angle
    x = 40+30*cos(360*angle/128)
    y = 100+90*sin(2*360*angle/128)
	y0 = (y>>3)
    y1 = (y%8)
    dw #c000 + x + (y0*80) + (#800*y1)
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

-- Project 84: sinosc_transp by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sinosc_transp',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2020-12-28T16:38:40.556000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'macro ADD_____DE_A                    ;; 5c

                add             a, e
                ld              e, a
                jr              nc, $ + 3
                inc             d
endm


macro ADD_____HL_A                    ;; 5c

                add             a, l
                ld              l, a
                jr              nc, $ + 3
                inc             h
endm
;genere une fonction nextline en fonction de la largeur de l.ecran
;CS: modifie AF, durée variable
;Devrait pouvoir etre optimisée (sans test)
MACRO NEXTLINE LW
        LD      a,d  ; h+=#800
        ADD     a,8 
        LD      d,a 
        AND     #38 
        RET     nz 	; <- RET si on n edéborde pas
        LD      a,d 
        SUB     #40 
        LD      d,a 
        LD      a,e 
        ADD     a,{LW}
        LD      e,a 
        RET     nc  ; <- RET
        INC     d 
        RES     3,d
		ret			; <- RET
MEND

MACRO SET_PALETTE palette, start, length
                ld a, {start}
                ld c, {length}
                ld hl, {palette}
                ld b, #7f
@loop:
                out (c), a
                inc b
                outi
                inc a
                dec c
                jr nz, @loop
MEND
nxtline: 
	NEXTLINE 80

run $

 di
 ld sp,#100
 ld hl,#c9fb
 ld (#38),hl
 ld bc,#7f8c
 out (c),c

initpic:
  ld hl,#4000
  ld de,#c000
  ld b,200  
.lp:
	push bc
    push de
    ld bc, 80
    ldir
    pop de
    call nxtline    
	pop bc
	djnz .lp

    ld de,#c000+40
    ld c,200
.lp1
	push de
	ld b,40
  .lp2
   ld a,(de)
   ;and #3f
   or #c0
   ld (de),a
   inc de
   djnz .lp2
   pop de
	call nxtline    
   dec c
   jr nz, .lp1


    SET_PALETTE palette, 0, 8

mainloop:

	ld b,#f5
.vbl
	in a,(c)
    rra
    jr nc,.vbl
ei
halt    
halt    

di
ld bc,#7f10    
out (c),c
ld a,#4b
out (c),a

    exx
stabptr:
    ld hl,sintable
    inc l
    ld (stabptr+1),hl
stabptr2:
    ld de,sintable + 64
    inc e : inc e : inc e
    
    ld (stabptr2+1),de
    exx

 
 ld hl,#4000
 ld de,#c000
 ld bc,25 
 
.lp:
 push bc
    
 repeat 8
 push de
 
 exx
 ld a, (hl)
 inc hl
 exx
 ld c, a
  exx
 ld a, (de)
 inc de
 exx
 add c
 ld c, a
 push hl

 add hl,bc
 ex de,hl

 add hl,bc
 ex de,hl


ld a,(de)
and #3f
ld (de),a
inc de
ld a,(de)
and #3f
ld (de),a
inc de

ld a,(de)
or #c0
ld (de),a
inc de
ld a,(de)
or #c0
ld (de),a
inc de


  pop hl

  ld c, 80
  add hl, bc

 pop de
 ld a,d
 add 8
 ld d,a
 rend

ld bc,#7f10    
out (c),c
ld a,h
and 31
or #41
out (c),a

LD A,#50
ADD E
LD E,A
LD A,#C0
ADC D
LD D,A

 
 pop bc
 dec c
 jp nz, .lp
 
ld bc,#7f10    
out (c),c
ld a,#54
out (c),a
 
 jp mainloop


align 256
sintable:
	repeat 2
    repeat 256,y
    db 20 + 10 * sin((360*y)/256)
    rend
    rend

palette:
db #54, #5c, #4e, #43, #44, #5d, #5f, #4b


    


org #4000
; Data created with Img2CPC - (c) Retroworks - 2007-2015
; Tile dmc - 160x200 pixels, 80x200 bytes.
dmc:
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #84, #cc, #cc, #0c, #0c, #04, #84, #c0, #04, #c0, #48, #40, #00, #40, #40, #84, #4c, #4c, #c0, #4c, #4c, #cc, #cc, #4c, #4c, #0c, #4c, #cc, #cc, #cc, #cc, #48, #c0, #84, #0c, #80, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #80, #00, #00, #00, #00, #00, #00, #44, #4c, #4c, #cc
DEFB #c0, #c0, #c0, #48, #c0, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #0c, #ec, #cc, #8c, #0c, #04, #0c, #48, #c0, #48, #c8, #80, #00, #80, #c0, #0c, #8c, #c8, #c0, #8c, #cc, #8c, #8c, #8c, #cc, #ec, #ec, #ec, #ec, #c8, #c0, #0c, #8c, #08, #c4, #08, #cc, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #80, #00, #80, #00, #00, #00, #00, #84, #cc, #cc, #cc
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #c0, #c0, #84, #c0, #84, #c0, #84, #c0, #84, #cc, #cc, #0c, #0c, #04, #c4, #0c, #c0, #40, #48, #40, #40, #c0, #c4, #84, #44, #08, #c4, #4c, #4c, #4c, #cc, #dc, #dc, #cc, #cc, #c0, #54, #40, #d4, #cc, #4c, #48, #40, #80, #cc, #cc, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #00, #00, #00, #00, #00, #00, #00, #04, #4c, #4c, #4c
DEFB #48, #c0, #48, #c0, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #0c, #ec, #ec, #8c, #8c, #04, #c0, #0c, #48, #80, #c8, #80, #c0, #80, #c0, #08, #84, #c0, #8c, #8c, #cc, #ec, #ec, #ec, #ac, #48, #80, #c0, #c4, #c0, #4c, #8c, #0c, #8c, #0c, #80, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #80, #80, #00, #00, #00, #00, #00, #84, #8c, #cc, #cc
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #c0, #84, #84, #cc, #cc, #0c, #0c, #04, #08, #40, #c0, #c0, #48, #00, #00, #c0, #80, #00, #00, #84, #4c, #dc, #dc, #dc, #8c, #c0, #40, #84, #0c, #c0, #c4, #40, #c4, #0c, #cc, #4c, #0c, #40, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #00, #00, #00, #00, #00, #00, #00, #40, #4c, #4c, #4c
DEFB #c0, #48, #c0, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #0c, #ec, #cc, #8c, #0c, #84, #48, #08, #c0, #80, #c8, #80, #40, #08, #80, #c0, #0c, #ec, #ec, #ec, #ac, #48, #c0, #cc, #4c, #8c, #c8, #cc, #c4, #c0, #c0, #0c, #8c, #cc, #cc, #c0, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #8c, #80, #00, #00, #00, #00, #00, #00, #00, #8c, #8c, #cc
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #c0, #84, #84, #84, #c0, #84, #cc, #cc, #0c, #0c, #40, #84, #c0, #c0, #40, #48, #40, #40, #c0, #4c, #cc, #dc, #cc, #8c, #c0, #84, #4c, #4c, #84, #4c, #4c, #c8, #84, #d4, #04, #84, #84, #c4, #4c, #cc, #88, #dc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #88, #00, #00, #00, #00, #00, #00, #00, #00, #0c, #4c, #4c
DEFB #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #c0, #0c, #ec, #ec, #8c, #8c, #00, #48, #48, #48, #80, #c8, #c0, #4c, #ec, #ec, #ec, #8c, #48, #0c, #8c, #cc, #8c, #ac, #8c, #4c, #cc, #e8, #48, #c4, #c0, #84, #0c, #0c, #8c, #cc, #88, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #a8, #00, #00, #00, #00, #00, #00, #00, #80, #0c, #cc, #cc
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #c0, #c0, #84, #4c, #4c, #cc, #cc, #0c, #0c, #40, #40, #c0, #c0, #40, #cc, #cc, #cc, #cc, #0c, #c0, #84, #4c, #cc, #4c, #4c, #cc, #4c, #cc, #4c, #4c, #8c, #84, #c4, #40, #c0, #48, #80, #0c, #cc, #48, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #00, #00, #00, #00, #00, #00, #40, #04, #0c, #4c, #4c
DEFB #c0, #48, #c0, #48, #c0, #48, #48, #48, #48, #48, #48, #48, #c0, #0c, #cc, #cc, #cc, #ec, #cc, #8c, #0c, #c0, #80, #c0, #cc, #ec, #cc, #ec, #c8, #80, #00, #c0, #0c, #8c, #cc, #ec, #cc, #cc, #cc, #ec, #8c, #cc, #8c, #8c, #c4, #c0, #48, #48, #48, #40, #cc, #c8, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #80, #00, #00, #00, #00, #00, #00, #c0, #0c, #8c, #cc
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #c0, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #0c, #0c, #04, #4c, #cc, #cc, #cc, #8c, #c0, #00, #00, #00, #04, #0c, #cc, #cc, #cc, #4c, #4c, #4c, #cc, #c4, #4c, #4c, #0c, #54, #40, #c0, #c0, #84, #00, #44, #c0, #cc, #cc, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #00, #00, #00, #00, #00, #00, #40, #84, #84, #4c, #4c
DEFB #48, #c0, #48, #48, #48, #48, #48, #48, #c0, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #8c, #0c, #cc, #ec, #ec, #48, #80, #a8, #48, #80, #80, #c0, #84, #8c, #c8, #ec, #cc, #cc, #8c, #4c, #8c, #4c, #4c, #cc, #c8, #c4, #c0, #c0, #48, #c0, #c0, #80, #00, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #c0, #80, #00, #00, #00, #00, #40, #c0, #0c, #8c, #8c
DEFB #c0, #c0, #c0, #c0, #c0, #c0, #40, #84, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #c4, #cc, #c0, #c0, #c0, #c0, #c8, #c0, #80, #48, #00, #c0, #0c, #84, #cc, #cc, #4c, #4c, #4c, #84, #48, #4c, #4c, #4c, #c4, #40, #80, #c0, #c0, #84, #80, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #84, #40, #c0, #00, #40, #40, #40, #04, #84, #0c, #4c
DEFB #c0, #48, #c0, #48, #c0, #48, #0c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #c0, #48, #48, #c0, #c0, #88, #08, #08, #c8, #80, #84, #c8, #8c, #8c, #cc, #4c, #8c, #8c, #0c, #0c, #ec, #48, #0c, #c4, #c0, #48, #c0, #08, #48, #84, #80, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #0c, #c0, #0c, #80, #c0, #80, #40, #c0, #0c, #0c, #8c
DEFB #c0, #c0, #c0, #c0, #84, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #0c, #40, #84, #c0, #c0, #c0, #c8, #c0, #80, #0c, #40, #44, #48, #c0, #cc, #cc, #c4, #0c, #0c, #84, #0c, #c0, #c0, #80, #d4, #c0, #c0, #00, #40, #0c, #84, #40, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #40, #84, #80, #40, #40, #40, #04, #84, #0c, #4c
DEFB #c0, #c0, #0c, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #8c, #0c, #c0, #48, #c0, #c0, #48, #a8, #08, #88, #0c, #80, #84, #c8, #c0, #cc, #cc, #4c, #8c, #c8, #c0, #48, #48, #c0, #80, #c4, #80, #08, #80, #c0, #0c, #48, #00, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #cc, #8c, #80, #48, #08, #c0, #c0, #40, #c0, #0c, #8c, #8c
DEFB #84, #4c, #4c, #0c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #84, #04, #c0, #c0, #c0, #40, #c8, #c0, #80, #84, #00, #40, #0c, #c0, #8c, #84, #84, #84, #c0, #00, #c0, #c0, #40, #c0, #44, #40, #c0, #00, #c0, #c0, #40, #00, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #0c, #00, #0c, #80, #40, #00, #40, #c0, #84, #0c, #4c
DEFB #8c, #cc, #cc, #8c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #c0, #48, #c0, #c0, #80, #88, #08, #80, #48, #c0, #84, #8c, #c8, #c0, #c0, #48, #48, #08, #c0, #80, #48, #c0, #c0, #c4, #c0, #80, #80, #80, #c0, #c0, #80, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #8c, #80, #0c, #08, #c0, #80, #c0, #48, #0c, #0c, #8c
DEFB #4c, #4c, #cc, #0c, #c4, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #0c, #04, #84, #c0, #c0, #c0, #c8, #c0, #80, #c0, #84, #40, #84, #c0, #c0, #84, #c0, #84, #c0, #40, #c0, #80, #c0, #40, #44, #40, #04, #80, #40, #c0, #c0, #00, #dc, #cc, #cc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #48, #80, #c0, #80, #40, #00, #40, #84, #84, #0c, #4c
DEFB #cc, #cc, #cc, #c8, #4c, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #8c, #48, #c0, #48, #c0, #48, #08, #a8, #0c, #88, #48, #80, #00, #48, #c0, #c0, #c0, #48, #c0, #c0, #80, #48, #80, #08, #80, #c4, #c0, #c0, #08, #00, #c0, #80, #80, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #c8, #08, #48, #08, #c0, #80, #c0, #0c, #0c, #0c, #8c
DEFB #4c, #4c, #4c, #0c, #c4, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #04, #c0, #00, #40, #c0, #88, #00, #00, #40, #00, #84, #c0, #40, #c0, #c0, #c0, #84, #c0, #c0, #40, #c0, #00, #00, #44, #00, #c0, #c0, #00, #40, #c0, #40, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #48, #80, #c0, #80, #40, #00, #c0, #84, #84, #84, #4c
DEFB #cc, #cc, #cc, #c8, #c4, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #84, #48, #80, #80, #80, #88, #80, #00, #c0, #80, #c0, #80, #c0, #c0, #80, #80, #c0, #48, #c0, #c0, #80, #80, #80, #c4, #80, #c0, #c0, #80, #80, #c0, #48, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #c8, #08, #48, #08, #c0, #80, #48, #48, #0c, #0c, #8c
DEFB #cc, #4c, #cc, #80, #44, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #0c, #04, #84, #c0, #c0, #c0, #c8, #80, #00, #40, #00, #00, #00, #40, #84, #40, #40, #c0, #40, #40, #c0, #c0, #c0, #40, #54, #40, #40, #80, #40, #00, #00, #40, #dc, #cc, #cc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #c0, #80, #40, #80, #48, #84, #84, #0c, #4c
DEFB #cc, #cc, #88, #00, #00, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #8c, #c8, #84, #48, #48, #c0, #80, #a8, #48, #00, #00, #00, #80, #80, #c0, #0c, #48, #c8, #c0, #c0, #c0, #c0, #48, #80, #c0, #c4, #80, #c0, #80, #c0, #84, #00, #00, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #8c, #88, #48, #08, #c0, #08, #48, #0c, #0c, #8c, #8c
DEFB #4c, #4c, #00, #00, #00, #44, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #c0, #04, #c0, #84, #c0, #84, #88, #c0, #00, #00, #00, #00, #c0, #84, #84, #48, #48, #40, #00, #c0, #c0, #84, #40, #40, #44, #40, #40, #40, #c0, #c0, #40, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #08, #c0, #00, #40, #80, #0c, #84, #84, #0c, #4c
DEFB #cc, #8c, #80, #80, #00, #04, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #8c, #48, #84, #48, #48, #48, #48, #a8, #80, #80, #00, #00, #80, #c0, #0c, #0c, #0c, #48, #c0, #80, #48, #c0, #c0, #c0, #48, #c4, #c0, #80, #c0, #c0, #08, #c0, #c0, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #08, #c0, #80, #80, #80, #48, #0c, #0c, #0c, #8c
DEFB #cc, #48, #40, #00, #00, #40, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #04, #84, #0c, #84, #84, #c8, #c0, #00, #00, #40, #00, #84, #84, #c4, #84, #84, #40, #04, #c0, #c0, #40, #c0, #c0, #44, #c0, #c0, #c0, #40, #c0, #08, #00, #cc, #cc, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #c0, #40, #00, #c0, #c0, #84, #84, #84, #0c, #4c
DEFB #cc, #88, #80, #00, #80, #00, #8c, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #8c, #c8, #c0, #48, #0c, #0c, #48, #a8, #80, #80, #40, #00, #00, #c0, #c0, #4c, #48, #c8, #c0, #c0, #80, #c0, #00, #c0, #c0, #c4, #c0, #c0, #08, #c0, #48, #48, #84, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #48, #c0, #80, #48, #c0, #c0, #0c, #0c, #8c, #8c
DEFB #4c, #48, #00, #00, #00, #00, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #04, #c0, #0c, #84, #c0, #88, #00, #00, #00, #00, #00, #c0, #04, #c0, #c0, #c0, #80, #40, #c0, #c0, #40, #40, #c0, #44, #c0, #c0, #c0, #0c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #40, #40, #00, #04, #40, #04, #84, #0c, #0c, #4c
DEFB #cc, #88, #80, #00, #00, #00, #0c, #8c, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #c0, #48, #48, #48, #80, #88, #80, #00, #00, #00, #00, #80, #40, #48, #c8, #08, #80, #80, #80, #c0, #c0, #80, #c0, #c4, #0c, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #c0, #00, #00, #00, #40, #84, #0c, #0c, #0c, #8c
DEFB #cc, #80, #00, #00, #00, #00, #04, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #04, #84, #84, #84, #c0, #88, #00, #00, #00, #00, #00, #00, #40, #c0, #c0, #c0, #00, #40, #40, #40, #c0, #84, #4c, #cc, #cc, #cc, #cc, #cc, #0c, #c0, #c0, #dc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #80, #00, #00, #00, #00, #84, #0c, #0c, #0c, #4c
DEFB #cc, #80, #80, #00, #00, #00, #84, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #8c, #c8, #c0, #48, #48, #c0, #80, #a8, #00, #00, #00, #00, #00, #80, #c0, #48, #c0, #c0, #80, #c0, #0c, #cc, #ec, #ec, #ec, #ec, #ec, #8c, #48, #c0, #c0, #48, #0c, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #08, #00, #00, #00, #00, #0c, #0c, #0c, #8c, #8c
DEFB #4c, #00, #00, #00, #00, #00, #04, #0c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #40, #c0, #c0, #c0, #00, #88, #40, #00, #00, #00, #00, #00, #40, #c0, #84, #0c, #4c, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #40, #c0, #40, #40, #c0, #c0, #84, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #48, #00, #00, #00, #40, #84, #84, #0c, #0c, #4c
DEFB #cc, #00, #00, #00, #00, #00, #40, #0c, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #c0, #48, #48, #80, #c0, #88, #00, #00, #00, #00, #00, #40, #0c, #cc, #ec, #cc, #ec, #ec, #ec, #8c, #cc, #cc, #ec, #cc, #c0, #80, #c0, #00, #c0, #c0, #0c, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #8c, #c0, #80, #c0, #04, #0c, #0c, #0c, #8c, #8c
DEFB #4c, #00, #00, #00, #00, #00, #40, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #40, #c0, #40, #00, #00, #88, #00, #00, #00, #84, #4c, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #40, #40, #40, #00, #80, #00, #c0, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #04, #00, #04, #04, #84, #0c, #0c, #4c, #4c
DEFB #cc, #08, #80, #00, #00, #00, #40, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #8c, #c8, #80, #c0, #80, #80, #00, #e8, #c0, #4c, #cc, #ec, #cc, #ec, #cc, #cc, #8c, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #80, #c0, #c0, #c0, #80, #c0, #c0, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #84, #80, #04, #0c, #0c, #0c, #0c, #8c, #8c
DEFB #4c, #0c, #80, #00, #00, #00, #40, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #40, #40, #40, #40, #c4, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #40, #c0, #c4, #04, #84, #40, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #0c, #00, #40, #84, #84, #84, #0c, #0c, #4c
DEFB #cc, #8c, #08, #0c, #08, #48, #40, #0c, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #c8, #84, #8c, #cc, #cc, #ec, #cc, #8c, #8c, #8c, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #8c, #48, #08, #c4, #4c, #c0, #48, #48, #84, #48, #00, #40, #ec, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #8c, #c8, #00, #00, #0c, #0c, #0c, #8c, #8c, #8c
DEFB #cc, #0c, #08, #84, #08, #c0, #40, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #4c, #cc, #cc, #cc, #cc, #c0, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #84, #c0, #80, #c0, #40, #80, #c4, #c4, #00, #c0, #c4, #c4, #84, #80, #40, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #08, #00, #04, #0c, #84, #0c, #0c, #4c, #4c
DEFB #cc, #c8, #88, #0c, #08, #48, #c0, #0c, #8c, #cc, #cc, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #8c, #cc, #8c, #48, #80, #80, #c0, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #8c, #cc, #a8, #c0, #c0, #c0, #c0, #80, #c0, #80, #4c, #4c, #80, #48, #84, #84, #0c, #c8, #40, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #88, #00, #04, #0c, #0c, #0c, #0c, #8c, #8c
DEFB #4c, #48, #08, #84, #80, #c0, #40, #84, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #40, #40, #80, #00, #00, #cc, #cc, #cc, #cc, #0c, #c0, #00, #00, #c4, #88, #c0, #00, #c0, #40, #80, #c0, #80, #c4, #c4, #40, #c0, #c4, #40, #0c, #48, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #4c, #48, #00, #40, #84, #84, #84, #0c, #0c, #4c
DEFB #cc, #88, #08, #0c, #08, #48, #c0, #0c, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #88, #80, #c0, #88, #00, #80, #cc, #48, #80, #00, #00, #00, #00, #00, #4c, #a8, #80, #80, #80, #c0, #80, #c0, #c0, #c4, #4c, #80, #84, #84, #84, #8c, #08, #c0, #cc, #ec, #ec, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #8c, #00, #00, #0c, #0c, #0c, #8c, #8c, #8c
DEFB #cc, #08, #48, #c0, #80, #80, #84, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #00, #c4, #c0, #c0, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #c4, #88, #00, #40, #40, #00, #c0, #00, #00, #c4, #c4, #40, #c0, #84, #44, #cc, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #c4, #00, #00, #0c, #84, #0c, #0c, #4c, #4c
DEFB #cc, #c8, #88, #c0, #80, #08, #48, #0c, #8c, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #8c, #88, #c0, #c0, #48, #80, #00, #cc, #80, #00, #00, #00, #00, #00, #80, #4c, #a8, #80, #00, #80, #80, #c0, #00, #80, #c4, #4c, #00, #48, #c0, #c4, #cc, #c8, #84, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #84, #00, #80, #0c, #0c, #0c, #0c, #8c, #cc
DEFB #4c, #48, #48, #c0, #40, #08, #c0, #84, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #04, #c0, #48, #40, #40, #4c, #40, #00, #00, #00, #00, #00, #40, #4c, #88, #00, #00, #c0, #00, #c0, #80, #40, #c4, #4c, #40, #84, #84, #c4, #cc, #08, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #44, #00, #40, #48, #04, #0c, #0c, #4c, #4c
DEFB #cc, #8c, #48, #c0, #c0, #c8, #48, #0c, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #88, #c0, #c0, #48, #48, #00, #4c, #84, #80, #00, #00, #00, #00, #c0, #cc, #a8, #80, #80, #c0, #80, #84, #0c, #00, #4c, #cc, #c0, #48, #84, #0c, #8c, #08, #c4, #ec, #ec, #cc, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #0c, #00, #00, #08, #04, #0c, #8c, #8c, #cc
DEFB #cc, #4c, #48, #c0, #40, #48, #84, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #40, #04, #48, #c0, #00, #4c, #00, #00, #00, #00, #00, #40, #40, #c4, #88, #00, #40, #c0, #00, #84, #0c, #40, #c4, #cc, #40, #84, #c0, #40, #c0, #80, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #48, #00, #00, #00, #04, #40, #0c, #4c, #4c
DEFB #cc, #cc, #48, #c0, #c0, #48, #0c, #0c, #8c, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #0c, #88, #80, #84, #c8, #c8, #00, #4c, #00, #00, #00, #00, #00, #00, #00, #4c, #88, #80, #c0, #c0, #00, #c0, #0c, #c0, #c4, #cc, #c0, #c0, #c0, #80, #00, #00, #40, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #88, #80, #00, #00, #48, #80, #8c, #cc, #8c
DEFB #4c, #4c, #c0, #04, #40, #84, #84, #84, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #40, #84, #08, #00, #4c, #00, #00, #00, #00, #00, #00, #40, #4c, #88, #00, #40, #40, #00, #40, #0c, #40, #c4, #cc, #40, #40, #c0, #c0, #00, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #c0, #00, #00, #00, #c0, #00, #c4, #4c, #4c
DEFB #8c, #cc, #c0, #c0, #04, #84, #0c, #0c, #0c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #8c, #88, #80, #00, #80, #80, #40, #cc, #00, #00, #00, #00, #00, #00, #40, #cc, #a8, #00, #04, #00, #80, #00, #48, #40, #c4, #8c, #c0, #c0, #80, #c0, #80, #00, #40, #cc, #ec, #ec, #ac, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #c0, #00, #00, #00, #48, #00, #84, #8c, #cc
DEFB #4c, #4c, #00, #00, #40, #04, #84, #84, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #48, #00, #c0, #00, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #40, #4c, #88, #00, #04, #00, #80, #40, #84, #44, #44, #cc, #04, #40, #80, #c0, #c0, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #00, #00, #00, #00, #84, #c0, #84, #4c, #4c
DEFB #cc, #cc, #c0, #80, #80, #84, #0c, #0c, #8c, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #0c, #88, #80, #48, #c0, #80, #00, #ec, #00, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #40, #00, #80, #40, #c0, #84, #c4, #cc, #c0, #c0, #80, #48, #80, #80, #40, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #80, #00, #00, #00, #0c, #c8, #0c, #cc, #cc
DEFB #4c, #4c, #4c, #08, #84, #84, #84, #0c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #80, #c0, #80, #00, #cc, #00, #00, #00, #00, #00, #00, #40, #4c, #88, #00, #40, #00, #00, #00, #84, #04, #44, #cc, #04, #c0, #c0, #0c, #40, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #00, #00, #00, #00, #84, #80, #4c, #4c, #4c
DEFB #cc, #cc, #8c, #88, #c8, #0c, #0c, #0c, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #88, #80, #80, #c0, #80, #00, #cc, #80, #00, #00, #00, #80, #40, #c0, #4c, #a8, #00, #00, #00, #00, #00, #c0, #c0, #c4, #8c, #c0, #c0, #48, #84, #80, #00, #04, #ec, #ec, #cc, #ac, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #80, #00, #00, #00, #40, #80, #8c, #8c, #cc
DEFB #4c, #4c, #48, #80, #48, #0c, #84, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #40, #c0, #80, #40, #cc, #00, #00, #00, #00, #00, #00, #40, #4c, #88, #00, #00, #00, #00, #00, #40, #40, #44, #cc, #04, #c0, #0c, #c0, #00, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #80, #00, #00, #00, #00, #40, #4c, #4c, #4c
DEFB #cc, #cc, #c8, #08, #48, #0c, #0c, #0c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #0c, #88, #80, #c0, #08, #80, #00, #ec, #80, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #00, #00, #00, #00, #c0, #80, #c4, #8c, #c0, #c0, #0c, #48, #80, #00, #04, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #88, #80, #00, #00, #00, #84, #8c, #cc, #cc
DEFB #4c, #4c, #0c, #80, #04, #0c, #84, #0c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #c0, #80, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #4c, #88, #00, #00, #00, #00, #00, #40, #40, #c4, #8c, #04, #40, #84, #84, #00, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #0c, #00, #00, #00, #80, #84, #4c, #4c, #4c
DEFB #cc, #cc, #8c, #80, #84, #8c, #0c, #8c, #8c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #8c, #88, #80, #80, #80, #80, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #cc, #a8, #00, #00, #00, #00, #00, #80, #80, #c4, #8c, #c0, #00, #c0, #08, #80, #00, #04, #cc, #ec, #cc, #ac, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #8c, #00, #00, #00, #08, #84, #8c, #8c, #cc
DEFB #4c, #4c, #48, #08, #4c, #0c, #0c, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #40, #c0, #40, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #4c, #88, #00, #00, #00, #00, #00, #40, #00, #44, #cc, #c0, #40, #40, #80, #00, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #00, #00, #40, #80, #04, #4c, #4c, #4c
DEFB #cc, #cc, #c8, #88, #8c, #0c, #48, #0c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #ec, #ec, #cc, #ec, #8c, #88, #80, #48, #c0, #80, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #00, #00, #00, #00, #00, #80, #c4, #8c, #c0, #00, #c0, #48, #80, #00, #04, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #8c, #80, #80, #00, #48, #84, #8c, #cc, #cc
DEFB #4c, #4c, #0c, #08, #48, #08, #80, #0c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #40, #00, #c0, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #4c, #88, #00, #00, #00, #00, #00, #00, #00, #44, #8c, #40, #00, #40, #c0, #00, #00, #04, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #0c, #00, #80, #00, #c0, #04, #4c, #4c, #4c
DEFB #cc, #cc, #c8, #80, #8c, #08, #00, #84, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #88, #c0, #80, #80, #80, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #00, #00, #00, #00, #00, #00, #c4, #8c, #80, #00, #c0, #80, #80, #00, #04, #cc, #ec, #cc, #ac, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #8c, #80, #00, #00, #c0, #84, #8c, #8c, #cc
DEFB #cc, #4c, #84, #40, #84, #40, #40, #04, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #40, #c0, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #4c, #88, #00, #00, #00, #00, #00, #00, #00, #44, #cc, #00, #00, #c0, #40, #c0, #84, #c4, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #00, #00, #00, #40, #44, #4c, #4c, #4c
DEFB #cc, #cc, #c0, #80, #80, #40, #40, #c0, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #8c, #88, #80, #c0, #80, #00, #00, #cc, #00, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #00, #c0, #c0, #0c, #8c, #cc, #ec, #cc, #8c, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ac, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #8c, #80, #80, #00, #08, #0c, #8c, #cc, #cc
DEFB #4c, #4c, #40, #80, #00, #00, #40, #c0, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #40, #00, #00, #00, #cc, #00, #00, #00, #00, #00, #40, #40, #4c, #8c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #00, #00, #00, #00, #0c, #4c, #4c, #4c
DEFB #8c, #cc, #84, #08, #80, #80, #40, #48, #8c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #8c, #88, #80, #00, #00, #00, #00, #cc, #c0, #c0, #0c, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #48, #48, #c0, #80, #00, #04, #cc, #ec, #cc, #ac, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #08, #00, #00, #c0, #0c, #8c, #cc, #cc
DEFB #4c, #4c, #c0, #08, #80, #00, #00, #04, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #00, #00, #40, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #8c, #00, #00, #c0, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #48, #00, #40, #84, #4c, #4c, #4c, #4c
DEFB #cc, #cc, #cc, #c8, #08, #00, #00, #84, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #8c, #c8, #0c, #cc, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #48, #c0, #80, #80, #80, #44, #8c, #00, #00, #c0, #80, #00, #00, #04, #ec, #cc, #ec, #ac, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #c8, #00, #40, #0c, #8c, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #0c, #40, #40, #40, #c4, #4c, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #4c, #cc, #cc, #cc, #cc, #4c, #cc, #cc, #cc, #cc, #0c, #84, #c0, #c0, #cc, #88, #00, #00, #00, #00, #00, #00, #00, #44, #8c, #00, #00, #40, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #4c, #48, #00, #00, #0c, #4c, #4c, #4c, #cc
DEFB #cc, #cc, #8c, #8c, #48, #00, #40, #84, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #8c, #c8, #48, #80, #80, #00, #00, #cc, #80, #80, #00, #00, #00, #00, #80, #cc, #88, #00, #00, #00, #00, #00, #00, #00, #44, #c8, #00, #00, #80, #00, #00, #00, #44, #ec, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #00, #00, #0c, #8c, #cc, #cc, #cc
DEFB #cc, #4c, #4c, #4c, #44, #40, #04, #44, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #40, #00, #00, #00, #40, #cc, #00, #00, #00, #00, #00, #00, #00, #cc, #88, #00, #00, #00, #00, #00, #00, #00, #44, #8c, #00, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #00, #40, #0c, #4c, #4c, #4c, #4c
DEFB #cc, #cc, #cc, #8c, #84, #80, #40, #84, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #0c, #88, #00, #00, #00, #00, #00, #cc, #80, #80, #80, #80, #80, #00, #00, #ec, #88, #00, #00, #00, #00, #00, #00, #80, #44, #8c, #00, #00, #00, #00, #00, #00, #44, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #80, #40, #8c, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #04, #00, #40, #c4, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #08, #00, #00, #40, #84, #4c, #4c, #4c, #0c, #40, #c0, #c0, #c0, #c0, #4c, #80, #00, #00, #00, #00, #00, #00, #00, #44, #c8, #00, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #08, #04, #4c, #4c, #4c, #4c, #cc
DEFB #cc, #cc, #cc, #cc, #40, #80, #40, #0c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #8c, #c8, #c0, #0c, #8c, #8c, #cc, #cc, #ec, #8c, #08, #00, #80, #00, #80, #80, #c0, #80, #80, #00, #00, #00, #00, #00, #44, #c8, #80, #00, #00, #08, #00, #00, #44, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #88, #04, #8c, #8c, #cc, #cc, #cc
DEFB #cc, #4c, #4c, #4c, #40, #00, #00, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #84, #c0, #c0, #00, #00, #00, #00, #04, #cc, #48, #c0, #c0, #c0, #c0, #c0, #00, #40, #00, #40, #40, #00, #00, #00, #44, #8c, #00, #00, #40, #04, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #0c, #84, #4c, #4c, #4c, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #0c, #80, #04, #8c, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ac, #0c, #8c, #80, #00, #00, #80, #80, #80, #80, #ec, #c8, #c0, #48, #48, #c0, #c0, #c0, #c0, #c0, #80, #80, #80, #80, #80, #44, #c8, #00, #00, #08, #08, #80, #00, #44, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #8c, #8c, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #48, #c0, #04, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #84, #84, #48, #00, #00, #00, #00, #00, #00, #00, #4c, #8c, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #c0, #c0, #80, #00, #44, #c8, #00, #00, #00, #84, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #4c, #4c, #4c, #4c, #cc
DEFB #cc, #cc, #cc, #cc, #88, #c8, #04, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #c8, #48, #4c, #88, #80, #00, #00, #00, #c0, #c0, #80, #4c, #8c, #80, #c0, #48, #c0, #48, #c0, #c0, #84, #48, #c0, #0c, #48, #48, #c0, #c8, #80, #00, #80, #84, #08, #00, #44, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #4c, #cc, #4c, #48, #80, #04, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #00, #48, #4c, #80, #00, #00, #40, #84, #c4, #cc, #0c, #4c, #cc, #c0, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #40, #84, #c0, #40, #00, #00, #40, #84, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #48, #84, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #8c, #08, #c0, #48, #cc, #c0, #c0, #0c, #0c, #8c, #dc, #fc, #fc, #ec, #ec, #88, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #08, #c0, #0c, #48, #08, #80, #00, #84, #c8, #08, #00, #44, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #4c, #0c, #04, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #48, #00, #04, #c4, #8c, #84, #4c, #4c, #0c, #4c, #fc, #fc, #fc, #ec, #cc, #48, #c0, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84, #40, #c0, #c0, #c0, #c0, #40, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #cc
DEFB #cc, #cc, #cc, #cc, #8c, #8c, #8c, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #c8, #80, #c0, #48, #c4, #a8, #8c, #8c, #8c, #8c, #4c, #fc, #fc, #fc, #fc, #ec, #c8, #c0, #80, #c0, #c0, #c0, #c0, #c0, #c0, #48, #c0, #c0, #c0, #c0, #48, #48, #80, #80, #00, #00, #00, #44, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #4c, #cc, #4c, #4c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #8c, #80, #00, #80, #48, #5c, #c8, #0c, #0c, #4c, #0c, #4c, #fc, #fc, #fc, #fc, #cc, #cc, #40, #c0, #40, #c0, #c0, #c0, #c0, #c0, #80, #c0, #c0, #c0, #c0, #84, #84, #c0, #00, #04, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #48, #80, #80, #c0, #48, #ec, #0c, #ac, #c8, #8c, #48, #4c, #fc, #fc, #ec, #ec, #cc, #ec, #c0, #c0, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #48, #80, #48, #48, #80, #08, #00, #00, #44, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #cc, #cc, #cc, #0c, #00, #00, #40, #4c, #84, #dc, #44, #48, #c0, #40, #40, #04, #4c, #4c, #dc, #dc, #5c, #cc, #c0, #c0, #c0, #40, #40, #40, #c0, #c0, #40, #40, #c0, #c0, #84, #c0, #04, #84, #c0, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #80, #80, #48, #4c, #cc, #c4, #ec, #c0, #c8, #80, #80, #c0, #c0, #cc, #8c, #8c, #0c, #4c, #fc, #88, #c0, #c0, #80, #c0, #80, #c0, #08, #c0, #08, #c0, #c0, #0c, #48, #c0, #48, #48, #80, #00, #00, #44, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #4c, #cc, #4c, #cc, #4c, #cc, #4c, #cc, #cc, #cc, #48, #40, #c0, #c0, #dc, #8c, #c4, #c8, #c0, #48, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #dc, #c8, #c0, #40, #40, #40, #c0, #c0, #40, #c0, #c0, #40, #c0, #84, #84, #c0, #84, #84, #c0, #00, #00, #44, #cc, #cc, #cc, #cc, #dc, #dc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #ac, #80, #84, #0c, #fc, #fc, #e8, #4c, #a8, #c0, #c0, #c0, #c0, #c0, #80, #80, #c0, #c0, #c0, #c0, #fc, #e8, #c0, #80, #80, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #48, #48, #c0, #48, #0c, #08, #00, #44, #ec, #ec, #ec, #cc, #fc, #ec, #ec, #ec, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #cc, #4c, #cc, #4c, #cc, #4c, #cc, #cc, #cc, #80, #40, #84, #5c, #fc, #fc, #48, #dc, #88, #c0, #c0, #c0, #c0, #c0, #c0, #00, #00, #40, #00, #40, #dc, #ac, #40, #40, #40, #40, #00, #c0, #40, #c0, #c0, #c0, #c0, #84, #c0, #c0, #c0, #84, #84, #84, #00, #44, #cc, #cc, #cc, #cc, #dc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #00, #80, #c0, #fc, #ec, #dc, #c0, #fc, #0c, #cc, #88, #c0, #c0, #c0, #80, #80, #00, #80, #00, #c0, #cc, #ec, #c0, #80, #80, #80, #80, #08, #80, #c0, #c0, #c0, #c0, #0c, #48, #48, #c0, #48, #48, #0c, #08, #44, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #cc, #cc, #ec
DEFB #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #c0, #40, #40, #d4, #fc, #48, #5c, #84, #dc, #54, #fc, #c0, #84, #c0, #40, #40, #00, #00, #00, #00, #40, #d4, #dc, #c0, #c0, #40, #40, #40, #c0, #40, #00, #40, #c0, #c0, #84, #48, #00, #40, #00, #40, #84, #84, #04, #cc, #cc, #8c, #00, #40, #04, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #ec, #cc, #ac, #08, #c0, #84, #fc, #ac, #c8, #ac, #c4, #fc, #d4, #fc, #c4, #ec, #c8, #c0, #80, #80, #00, #00, #00, #80, #c4, #fc, #88, #c0, #c0, #80, #80, #80, #80, #00, #00, #00, #80, #80, #80, #80, #00, #80, #80, #80, #c0, #08, #4c, #cc, #e8, #80, #c0, #84, #4c, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #cc, #4c, #cc, #4c, #cc, #cc, #cc, #0c, #80, #40, #5c, #fc, #8c, #84, #c8, #d4, #fc, #d4, #8c, #5c, #dc, #cc, #0c, #c0, #00, #00, #00, #00, #40, #44, #dc, #48, #40, #00, #00, #00, #40, #40, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #40, #40, #40, #44, #cc, #c8, #40, #40, #04, #c4, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #0c, #80, #0c, #fc, #ec, #8c, #cc, #e8, #cc, #fc, #cc, #a8, #0c, #8c, #8c, #8c, #48, #80, #00, #00, #00, #c0, #c4, #fc, #8c, #0c, #48, #0c, #0c, #0c, #48, #48, #48, #48, #48, #48, #48, #48, #48, #48, #c0, #c0, #c0, #48, #00, #cc, #c8, #80, #80, #84, #0c, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #84, #84, #4c, #dc, #dc, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #dc, #cc, #0c, #0c, #84, #80, #00, #00, #00, #54, #dc, #dc, #cc, #cc, #0c, #0c, #84, #84, #c0, #84, #c0, #84, #c0, #c0, #c0, #84, #c0, #c0, #c0, #84, #84, #c0, #c4, #c8, #00, #00, #04, #c4, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #ec, #8c, #8c, #cc, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #ec, #ec, #ec, #80, #00, #00, #4c, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #8c, #48, #0c, #48, #0c, #0c, #0c, #48, #48, #48, #48, #48, #48, #c0, #48, #cc, #c8, #00, #80, #c0, #0c, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #cc, #4c, #cc, #cc, #cc, #cc, #8c, #c4, #cc, #cc, #dc, #fc, #fc, #fc, #fc, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #dc, #cc, #cc, #8c, #00, #40, #5c, #cc, #cc, #dc, #cc, #dc, #dc, #dc, #dc, #cc, #0c, #0c, #0c, #84, #0c, #84, #84, #c0, #c0, #c0, #c0, #c4, #0c, #4c, #4c, #84, #c0, #04, #84, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #ec, #fc, #fc, #fc, #fc, #fc, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #ec, #ec, #ec, #08, #c0, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #fc, #fc, #fc, #fc, #ec, #8c, #8c, #c8, #0c, #48, #48, #48, #48, #48, #0c, #8c, #8c, #8c, #8c, #cc, #8c, #8c, #cc, #cc, #ec, #cc, #ec, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec
DEFB #cc, #4c, #cc, #cc, #cc, #cc, #cc, #c4, #cc, #cc, #dc, #cc, #dc, #dc, #fc, #fc, #dc, #dc, #dc, #dc, #fc, #fc, #fc, #dc, #dc, #cc, #dc, #cc, #48, #40, #4c, #cc, #dc, #dc, #dc, #dc, #dc, #dc, #dc, #fc, #fc, #fc, #fc, #fc, #cc, #0c, #0c, #84, #84, #84, #84, #0c, #4c, #0c, #4c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #cc, #ec, #cc, #ec, #fc, #fc, #fc, #ec, #4c, #fc, #ec, #fc, #fc, #fc, #ec, #ec, #ec, #ec, #ec, #c8, #c0, #cc, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #8c, #8c, #0c, #48, #48, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #cc, #cc, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #ec
DEFB #4c, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #dc, #dc, #dc, #fc, #cc, #d4, #cc, #dc, #dc, #dc, #cc, #dc, #cc, #cc, #cc, #cc, #48, #04, #4c, #4c, #dc, #dc, #dc, #dc, #cc, #dc, #dc, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #cc, #0c, #0c, #84, #0c, #0c, #4c, #0c, #0c, #0c, #4c, #0c, #0c, #0c, #4c, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #8c, #ec, #cc, #ec, #8c, #cc, #fc, #ec, #fc, #fc, #ec, #4c, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #c8, #0c, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #cc, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec, #cc, #ec
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #8c, #cc, #cc, #cc, #4c, #4c, #dc, #dc, #fc, #fc, #dc, #cc, #dc, #cc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #84, #0c, #cc, #dc, #dc, #dc, #cc, #dc, #dc, #dc, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #cc, #4c, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #4c, #0c, #c0, #84, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #c8, #ec, #cc, #cc, #08, #c0, #dc, #ec, #fc, #fc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #cc, #ec, #cc, #cc, #0c, #8c, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #8c, #48, #cc, #cc, #ec, #ec, #ec, #ec, #ec, #ec, #ec, #ec
DEFB #84, #84, #84, #84, #84, #0c, #84, #cc, #c4, #c0, #00, #00, #44, #ec, #dc, #dc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #4c, #cc, #4c, #0c, #0c, #4c, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #4c, #4c, #0c, #84, #84, #84, #84, #84, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #84, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #ec, #cc, #ec, #cc, #ec, #8c, #ac, #cc, #88, #00, #00, #40, #fc, #cc, #ec, #cc, #ec, #ec, #ec, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #8c, #8c, #0c, #cc, #8c, #cc, #cc, #ec, #ec, #cc, #ec, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #8c, #cc, #48, #48, #48, #48, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #c0, #c0, #ec, #cc, #ec, #cc, #ec, #cc, #ec
DEFB #4c, #4c, #cc, #cc, #cc, #dc, #cc, #c4, #cc, #80, #00, #00, #00, #5c, #dc, #cc, #cc, #dc, #cc, #cc, #cc, #4c, #cc, #4c, #cc, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #4c, #4c, #4c, #cc, #cc, #cc, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #cc, #cc, #0c, #c0, #40, #00, #40, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #c0, #40, #c0, #4c, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #0c, #0c, #0c, #48, #0c, #48, #48, #0c, #0c, #80, #00, #00, #00, #4c, #fc, #fc, #fc, #fc, #fc, #ec, #ec, #cc, #cc, #cc, #cc, #8c, #8c, #8c, #8c, #0c, #0c, #0c, #8c, #8c, #cc, #cc, #cc, #48, #0c, #4c, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ac, #cc, #cc, #8c, #0c, #48, #08, #48, #48, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #48, #84, #48, #84, #8c, #8c, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #4c, #4c, #40, #40, #40, #00, #00, #00, #00, #04, #84, #0c, #0c, #4c, #cc, #cc, #dc, #dc, #dc, #dc, #cc, #cc, #cc, #4c, #0c, #0c, #84, #84, #84, #0c, #0c, #5c, #48, #00, #00, #04, #5c, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #c8, #4c, #4c, #0c, #84, #84, #c0, #84, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #c0, #84, #c0, #04, #0c, #0c, #0c, #0c, #84, #84
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #00, #80, #40, #00, #00, #80, #00, #40, #80, #c0, #c0, #48, #c0, #48, #48, #0c, #0c, #8c, #cc, #ec, #ec, #fc, #fc, #ec, #8c, #cc, #8c, #8c, #8c, #8c, #08, #00, #00, #00, #84, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #e8, #cc, #8c, #8c, #0c, #0c, #08, #0c, #0c, #80, #00, #00, #00, #00, #40, #c0, #80, #00, #00, #04, #48, #0c, #48, #c4, #cc, #ec, #cc, #ec, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #40, #40, #40, #00, #00, #40, #00, #40, #00, #00, #00, #00, #40, #00, #40, #40, #c0, #c0, #c0, #c0, #84, #84, #0c, #0c, #4c, #dc, #dc, #dc, #cc, #8c, #00, #00, #00, #00, #40, #dc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #8c, #4c, #4c, #0c, #84, #0c, #c0, #84, #0c, #00, #00, #00, #00, #00, #40, #0c, #80, #00, #00, #04, #48, #c4, #c8, #44, #dc, #dc, #dc, #dc, #dc, #dc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #c0, #c0, #80, #00, #40, #80, #80, #40, #c0, #80, #80, #80, #80, #00, #00, #00, #00, #00, #80, #80, #c0, #c0, #c0, #c0, #48, #48, #0c, #8c, #cc, #c8, #00, #00, #00, #00, #00, #5c, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ac, #8c, #8c, #8c, #4c, #8c, #c8, #4c, #ec, #80, #00, #00, #00, #00, #44, #0c, #88, #00, #00, #04, #e8, #4c, #ac, #c0, #ec, #ec, #ec, #ec, #ec, #ec
DEFB #4c, #cc, #cc, #cc, #4c, #cc, #40, #c0, #80, #00, #00, #00, #00, #00, #c0, #c0, #c0, #c0, #80, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #c0, #84, #80, #00, #00, #00, #00, #00, #04, #dc, #fc, #fc, #fc, #fc, #fc, #dc, #dc, #8c, #4c, #0c, #84, #5c, #fc, #c8, #5c, #cc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #c8, #d4, #ac, #40, #84, #84, #84, #84, #84, #0c
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #80, #c0, #80, #00, #80, #00, #00, #80, #c0, #48, #c0, #48, #c8, #c0, #48, #48, #c0, #c0, #80, #80, #80, #80, #00, #00, #00, #00, #00, #80, #c0, #80, #00, #00, #00, #00, #00, #40, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #ec, #48, #8c, #8c, #0c, #dc, #ec, #88, #fc, #e8, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #c8, #5c, #e8, #c0, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #40, #c0, #80, #00, #00, #00, #00, #00, #c0, #c0, #c0, #c0, #4c, #c0, #84, #c0, #c0, #c0, #c0, #c0, #c0, #40, #40, #00, #00, #00, #00, #00, #40, #00, #00, #00, #00, #00, #00, #00, #d4, #cc, #dc, #fc, #fc, #fc, #fc, #dc, #84, #0c, #0c, #84, #4c, #ec, #48, #0c, #0c, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #84, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #80, #c0, #80, #00, #00, #80, #00, #80, #c0, #48, #48, #c0, #48, #48, #48, #48, #48, #c0, #48, #c0, #48, #c0, #48, #c0, #c0, #c0, #80, #80, #c0, #00, #00, #00, #00, #00, #00, #00, #c4, #48, #0c, #0c, #cc, #fc, #fc, #fc, #4c, #cc, #8c, #8c, #48, #48, #08, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #80, #c0, #cc, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #cc, #4c, #cc, #cc, #cc, #00, #40, #00, #00, #00, #40, #00, #00, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #40, #c0, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #04, #00, #40, #c0, #40, #84, #84, #4c, #c4, #cc, #cc, #cc, #c0, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #40, #40, #40, #40, #c0, #40, #c0, #44, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #08, #c0, #80, #00, #40, #c0, #80, #80, #c0, #48, #c0, #48, #c0, #c0, #48, #48, #c0, #48, #c0, #48, #c0, #c0, #c0, #48, #c0, #c0, #c0, #48, #08, #00, #00, #00, #00, #80, #00, #80, #40, #08, #00, #48, #08, #08, #80, #48, #80, #c0, #0c, #cc, #c8, #48, #c0, #48, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #80, #80, #80, #84, #ec, #cc, #ec, #cc, #ec
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #88, #40, #80, #00, #40, #00, #80, #00, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #40, #48, #00, #00, #04, #00, #40, #00, #40, #40, #c0, #40, #c0, #c0, #c0, #c0, #c0, #40, #c0, #40, #40, #40, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #04, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #c8, #c0, #80, #00, #c0, #80, #80, #00, #c0, #c0, #48, #c0, #48, #c0, #48, #48, #48, #c0, #48, #c0, #48, #c0, #48, #c0, #c0, #c0, #48, #c0, #08, #00, #00, #00, #00, #00, #80, #00, #00, #0c, #48, #48, #80, #80, #00, #00, #00, #00, #80, #80, #c0, #80, #c0, #80, #80, #80, #80, #80, #80, #80, #80, #00, #80, #00, #80, #00, #00, #00, #00, #00, #84, #cc, #ec, #ec, #ec, #ec
DEFB #4c, #cc, #4c, #cc, #4c, #cc, #0c, #40, #00, #00, #00, #00, #40, #00, #40, #c0, #c0, #c0, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #40, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #84, #84, #84, #c0, #c0, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #c0, #80, #00, #80, #80, #c0, #00, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #48, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #80, #00, #84, #48, #48, #48, #48, #48, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #00, #00, #44, #cc, #cc, #ec, #cc, #ec
DEFB #cc, #4c, #cc, #4c, #cc, #4c, #cc, #c0, #80, #00, #c0, #40, #40, #00, #40, #40, #c0, #c0, #40, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #40, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #04, #0c, #84, #84, #84, #84, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #88, #80, #00, #80, #c0, #c0, #00, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #00, #80, #00, #00, #80, #04, #0c, #48, #48, #48, #48, #48, #00, #00, #00, #00, #00, #00, #00, #80, #08, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #00, #00, #c4, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #cc, #4c, #cc, #4c, #cc, #4c, #c8, #00, #40, #00, #40, #80, #00, #40, #40, #40, #c0, #40, #40, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #40, #40, #c0, #40, #c0, #00, #00, #00, #00, #40, #40, #00, #00, #00, #04, #84, #84, #c0, #84, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #04, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #44, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #80, #40, #80, #c0, #08, #00, #00, #c0, #c0, #c0, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #c0, #c0, #08, #00, #00, #40, #0c, #48, #48, #48, #48, #48, #00, #00, #00, #00, #00, #00, #00, #80, #08, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #4c, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #4c, #cc, #4c, #cc, #4c, #cc, #4c, #80, #40, #40, #04, #c0, #00, #00, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #c0, #40, #00, #00, #00, #40, #c0, #00, #c0, #00, #00, #00, #84, #84, #84, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #88, #40, #80, #c0, #0c, #80, #00, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #00, #00, #c0, #80, #80, #48, #00, #80, #00, #0c, #48, #48, #48, #48, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #80, #80, #80, #c0, #cc, #cc, #ec, #cc, #ec, #cc
DEFB #4c, #4c, #4c, #4c, #4c, #4c, #4c, #cc, #08, #40, #00, #c0, #84, #00, #00, #40, #40, #40, #40, #40, #40, #40, #40, #c0, #40, #40, #40, #c0, #40, #40, #40, #c0, #40, #40, #00, #00, #00, #40, #00, #40, #40, #00, #00, #00, #84, #c0, #c0, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c4, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #8c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #c8, #40, #00, #80, #c0, #80, #00, #80, #80, #80, #80, #c0, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #00, #00, #00, #80, #80, #80, #00, #08, #00, #00, #48, #48, #48, #48, #c0, #48, #00, #00, #00, #00, #80, #80, #80, #80, #80, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #84, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #4c, #4c, #4c, #4c, #4c, #4c, #cc, #4c, #cc, #40, #40, #c0, #04, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #40, #40, #c0, #40, #40, #40, #c0, #40, #c0, #40, #00, #00, #00, #c0, #40, #00, #40, #80, #00, #00, #84, #c0, #c0, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #48, #48, #0c, #0c, #0c, #8c, #cc, #cc, #8c, #40, #c0, #c0, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #c0, #80, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #80, #00, #00, #80, #80, #80, #80, #80, #00, #80, #84, #48, #48, #48, #48, #c0, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c4, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #c0, #84, #c0, #c0, #c0, #84, #84, #84, #84, #04, #40, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #40, #40, #40, #00, #00, #40, #c0, #40, #40, #00, #40, #00, #00, #04, #84, #c0, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c4, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #48, #48, #48, #48, #48, #48, #48, #48, #48, #04, #80, #c0, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #c0, #80, #00, #40, #80, #80, #c0, #80, #c0, #00, #80, #40, #48, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #c0, #84, #84, #c0, #84, #c0, #84, #c0, #c0, #04, #c0, #84, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #40, #40, #c4, #00, #40, #00, #00, #04, #c0, #c0, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #4c, #cc, #4c, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #0c, #48, #48, #48, #48, #48, #48, #48, #48, #40, #80, #c0, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #80, #c0, #c0, #c8, #c0, #00, #00, #40, #48, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #84, #84, #84, #84, #c0, #c0, #c0, #84, #c0, #40, #40, #84, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #04, #40, #88, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #4c, #4c, #4c, #4c, #cc, #4c, #cc, #cc, #cc
DEFB #48, #48, #48, #48, #c0, #48, #48, #48, #c0, #00, #48, #c0, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #c0, #0c, #88, #80, #00, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #4c, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #84, #84, #84, #84, #84, #c0, #c0, #c0, #c0, #00, #c0, #c0, #c0, #00, #00, #00, #00, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #04, #04, #48, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #44, #4c, #4c, #cc, #4c, #cc, #cc, #cc, #cc
DEFB #48, #48, #48, #48, #48, #c0, #48, #c0, #48, #00, #48, #c0, #80, #00, #00, #00, #00, #48, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #00, #80, #40, #48, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #cc, #cc, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #c0, #c0, #c0, #84, #c0, #c0, #c0, #c0, #c0, #00, #c0, #40, #00, #00, #00, #00, #00, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #04, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #4c, #4c, #4c, #4c, #4c, #cc, #4c, #cc
DEFB #c0, #48, #48, #48, #48, #48, #48, #48, #48, #80, #84, #c0, #80, #00, #00, #00, #00, #c0, #c0, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #c0, #80, #00, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #0c, #8c, #8c, #cc, #8c, #cc, #cc, #cc, #cc, #cc
DEFB #84, #c0, #84, #c0, #c0, #c0, #c0, #c0, #c0, #80, #04, #84, #00, #00, #00, #00, #40, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #00, #04, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #84, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #cc, #4c
DEFB #48, #48, #48, #48, #48, #48, #c0, #48, #48, #80, #c0, #48, #80, #00, #00, #00, #40, #80, #80, #80, #80, #80, #80, #00, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #84, #80, #c0, #c0, #48, #80, #00, #00, #00, #00, #80, #00, #80, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #8c, #cc, #8c, #8c, #8c, #cc, #8c, #cc, #cc, #cc, #cc, #cc, #cc
DEFB #84, #84, #84, #84, #c0, #c0, #40, #c0, #40, #00, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #40, #40, #04, #c0, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #0c, #0c, #4c, #0c, #4c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #4c
DEFB #48, #48, #48, #48, #48, #c0, #c0, #c0, #80, #80, #00, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #80, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #48, #48, #48, #48, #48, #0c, #0c, #0c, #8c, #8c, #cc, #8c, #cc
DEFB #84, #84, #84, #84, #84, #c0, #c0, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #c0, #84, #c0, #c0, #c0, #c0, #c0, #c0, #84, #84, #84, #0c, #4c
DEFB #48, #48, #0c, #48, #48, #48, #48, #48, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #84, #80, #c0, #80, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #48, #48, #48, #48, #48, #c0, #48, #48, #c0, #48, #48, #c0, #48
DEFB #84, #c0, #84, #84, #84, #84, #c0, #84, #c0, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #04, #40, #40, #c0, #c0, #04, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #84, #84, #84, #84, #84, #84, #84, #84, #c0, #c0, #84, #84, #84, #84
DEFB #c0, #48, #0c, #48, #48, #48, #48, #48, #48, #48, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #08, #80, #c0, #c0, #c0, #00, #00, #00, #00, #00, #00, #80, #80, #00, #00, #c0, #08, #c0, #48, #48, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #48, #48, #48, #0c, #0c, #0c, #48, #48, #48, #48, #48, #48, #c0, #48
DEFB #84, #84, #c0, #84, #84, #84, #84, #84, #84, #c0, #c0, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #48, #40, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #c0, #40, #c0, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #84, #c0, #84, #84, #84, #84, #84, #84, #84, #84, #84, #c0, #84, #84
DEFB #48, #48, #48, #0c, #48, #0c, #0c, #48, #48, #0c, #0c, #48, #48, #c0, #c0, #80, #80, #80, #80, #80, #80, #00, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #88, #c0, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #c0, #c0, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #40, #48, #48, #48, #48, #48, #48, #0c, #0c, #48, #48, #0c, #48, #48, #48
DEFB #84, #84, #84, #84, #84, #0c, #0c, #84, #84, #84, #84, #84, #c0, #c0, #c0, #c0, #40, #40, #00, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #0c, #00, #40, #40, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #40, #00, #00, #00, #00, #00, #00, #00, #40, #c0, #84, #c0, #c0, #c0, #84, #84, #84, #84, #84, #84, #c0, #84, #84
DEFB #0c, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #48, #48, #48, #48, #48, #48, #c0, #c0, #c0, #80, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c4, #80, #c0, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #00, #00, #00, #00, #00, #00, #48, #48, #c0, #c0, #c0, #c0, #48, #48, #48, #48, #0c, #0c, #0c, #48, #48
DEFB #0c, #0c, #84, #84, #0c, #0c, #0c, #0c, #84, #0c, #0c, #84, #84, #84, #84, #c0, #84, #c0, #c0, #c0, #c0, #40, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #44, #c0, #40, #04, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #c0, #84, #84, #84, #84, #84, #84
DEFB #0c, #48, #0c, #48, #8c, #0c, #0c, #0c, #48, #48, #48, #48, #0c, #48, #0c, #48, #0c, #48, #48, #48, #c0, #c0, #c0, #c0, #c0, #80, #80, #80, #80, #00, #80, #00, #00, #00, #00, #00, #00, #c0, #e8, #80, #0c, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c0, #c0, #c0, #c0, #48, #c0, #48, #48, #48, #48, #48, #48, #48, #48, #0c, #48
DEFB #84, #84, #84, #84, #84, #0c, #84, #0c, #84, #0c, #0c, #84, #84, #84, #84, #84, #84, #84, #84, #84, #c0, #84, #c0, #c0, #c0, #40, #40, #40, #00, #40, #00, #00, #00, #00, #00, #00, #00, #40, #4c, #0c, #08, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #c0, #c0, #84
DEFB #48, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #48, #0c, #48, #0c, #0c, #0c, #48, #48, #48, #48, #48, #48, #c0, #c0, #c0, #c0, #80, #80, #80, #80, #00, #80, #00, #00, #00, #00, #84, #8c, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #80, #c0, #c0, #c0, #c0, #c0, #c0, #48, #c0, #48, #c0, #48, #48, #48
DEFB #0c, #0c, #84, #84, #c0, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #84, #84, #84, #84, #84, #84, #c0, #c0, #84, #c0, #c0, #c0, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #c0, #40, #c0, #c0, #84, #c0, #84, #c0, #84, #84
DEFB #8c, #48, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #c0, #0c, #48, #48, #c0, #48, #c0, #80, #80, #c0, #80, #80, #80, #80, #00, #80, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #00, #80, #80, #80, #c0, #c0, #c0, #c0, #c0, #48, #48, #48, #48, #0c, #48
DEFB #0c, #0c, #84, #0c, #84, #84, #84, #0c, #0c, #0c, #84, #0c, #84, #0c, #c0, #0c, #84, #84, #0c, #0c, #84, #84, #84, #84, #c0, #84, #c0, #84, #c0, #c0, #40, #40, #40, #40, #40, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #40, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84
DEFB #8c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #48, #48, #0c, #48, #48, #48, #48, #c0, #c0, #c0, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #00, #80, #80, #80, #80, #c0, #80, #c0, #c0, #c0, #c0, #48, #48, #48, #48, #48
DEFB #0c, #84, #84, #84, #84, #84, #0c, #0c, #4c, #0c, #0c, #48, #0c, #0c, #84, #84, #0c, #0c, #0c, #0c, #84, #c0, #84, #84, #84, #0c, #84, #0c, #84, #04, #84, #c0, #84, #c0, #c0, #00, #40, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #40, #40, #40, #40, #c0, #c0, #c0, #c0, #c0, #40, #c0, #84, #84, #84
DEFB #8c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #0c, #8c, #48, #0c, #0c, #8c, #0c, #48, #0c, #8c, #8c, #0c, #0c, #0c, #8c, #8c, #0c, #48, #0c, #0c, #48, #48, #48, #48, #c0, #c0, #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #00, #80, #80, #80, #80, #80, #c0, #c0, #c0, #c0, #c0, #48, #c0, #48, #48, #48, #48, #0c, #0c, #0c, #48
DEFB #84, #84, #0c, #0c, #0c, #0c, #84, #0c, #84, #84, #84, #84, #0c, #84, #84, #0c, #84, #0c, #84, #0c, #0c, #0c, #84, #0c, #84, #0c, #84, #84, #84, #0c, #84, #84, #84, #84, #c0, #c0, #40, #c0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #40, #40, #40, #40, #40, #40, #40, #c0, #c0, #c0, #c0, #c0, #84, #84, #84, #84, #84, #84, #84
DEFB #0c, #48, #0c, #0c, #0c, #8c, #8c, #8c, #0c, #0c, #8c, #8c, #8c, #48, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #48, #0c, #0c, #0c, #48, #0c, #48, #0c, #48, #48, #c0, #80, #00, #00, #00, #00, #00, #80, #00, #80, #00, #80, #00, #80, #00, #80, #80, #80, #80, #c0, #80, #c0, #80, #c0, #c0, #c0, #c0, #48, #c0, #c0, #c0, #48, #48, #c0, #48, #48, #48, #0c, #0c, #48, #48, #48
DEFB #0c, #84, #0c, #84, #0c, #84, #c4, #0c, #4c, #4c, #0c, #84, #0c, #4c, #4c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #c0, #84, #84, #84, #84, #0c, #84, #84, #c0, #c0, #c0, #40, #40, #40, #00, #40, #00, #40, #40, #40, #00, #40, #40, #40, #40, #40, #40, #40, #40, #c0, #c0, #c0, #c0, #c0, #c0, #84, #c0, #84, #84, #84, #84, #84, #c0, #84, #84, #0c, #84, #84, #c0
DEFB #48, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #8c, #8c, #0c, #8c, #8c, #8c, #0c, #0c, #48, #0c, #8c, #0c, #48, #0c, #0c, #0c, #0c, #48, #0c, #48, #0c, #8c, #8c, #8c, #0c, #0c, #48, #0c, #0c, #0c, #48, #c0, #c0, #c0, #c0, #c0, #80, #c0, #80, #c0, #80, #c0, #c0, #c0, #80, #c0, #c0, #c0, #c0, #c0, #48, #48, #48, #48, #48, #48, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c
DEFB #0c, #0c, #0c, #c0, #84, #84, #0c, #0c, #c0, #0c, #84, #84, #0c, #0c, #48, #84, #0c, #84, #0c, #0c, #0c, #84, #84, #0c, #0c, #c0, #84, #84, #0c, #0c, #84, #84, #84, #0c, #0c, #84, #0c, #84, #0c, #0c, #0c, #84, #c0, #84, #c0, #c0, #40, #c0, #40, #c0, #c0, #c0, #c0, #40, #40, #c0, #40, #c0, #40, #c0, #c0, #c0, #c0, #84, #c0, #84, #c0, #84, #84, #84, #84, #84, #84, #84, #84, #0c, #84, #0c, #0c, #84
DEFB #48, #0c, #48, #0c, #0c, #48, #0c, #0c, #0c, #8c, #0c, #0c, #48, #0c, #8c, #8c, #0c, #0c, #8c, #0c, #0c, #0c, #8c, #0c, #0c, #8c, #8c, #8c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c, #48, #c0, #48, #48, #c0, #48, #48, #48, #c0, #c0, #48, #48, #c0, #c0, #c0, #48, #48, #48, #48, #48, #48, #48, #48, #0c, #48, #0c, #48, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #48
DEFB #0c, #c0, #84, #c0, #0c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #84, #4c, #4c, #4c, #4c, #0c, #84, #0c, #0c, #0c, #48, #0c, #c0, #84, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #84, #84, #0c, #84, #84, #0c, #84, #84, #84, #c0, #84, #84, #84, #84, #c0, #c0, #40, #c0, #84, #84, #84, #c0, #84, #c0, #84, #84, #84, #84, #c0, #84, #84, #0c, #0c, #84, #84, #84, #84, #84, #84, #84, #0c, #0c
DEFB #0c, #0c, #8c, #0c, #0c, #48, #0c, #0c, #8c, #48, #0c, #48, #0c, #0c, #0c, #8c, #8c, #0c, #8c, #8c, #0c, #8c, #8c, #48, #84, #8c, #8c, #8c, #8c, #c8, #8c, #8c, #8c, #0c, #0c, #0c, #8c, #8c, #8c, #0c, #48, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #48, #48, #48, #48, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #48, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #0c
DEFB #84, #0c, #0c, #0c, #0c, #84, #84, #0c, #84, #0c, #4c, #4c, #0c, #84, #84, #0c, #0c, #0c, #84, #0c, #84, #4c, #0c, #4c, #4c, #0c, #84, #0c, #84, #84, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #84, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #c0, #84, #84, #84, #84, #84, #84, #84, #0c, #84, #84, #c0, #84, #84, #84, #84, #84, #84, #0c, #84, #0c, #0c, #0c, #84, #0c, #84, #84
DEFB #0c, #48, #48, #0c, #0c, #8c, #8c, #8c, #8c, #48, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #8c, #0c, #84, #8c, #8c, #0c, #0c, #8c, #48, #8c, #8c, #8c, #8c, #0c, #0c, #8c, #8c, #8c, #8c, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48
DEFB #0c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #84, #84, #84, #84, #c0, #4c, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #4c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #4c, #0c, #84, #4c, #4c, #0c, #84, #0c, #0c, #0c, #0c, #4c, #4c, #0c, #0c, #0c, #84, #84, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #84, #0c, #84, #84, #84, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84
DEFB #0c, #8c, #8c, #0c, #0c, #8c, #8c, #48, #0c, #8c, #8c, #8c, #c8, #0c, #0c, #8c, #8c, #8c, #0c, #0c, #0c, #0c, #8c, #0c, #8c, #0c, #48, #0c, #8c, #0c, #0c, #8c, #0c, #8c, #8c, #0c, #8c, #8c, #8c, #48, #8c, #8c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #8c, #48, #48, #8c, #8c, #0c, #48, #0c, #8c, #0c, #0c, #8c, #8c, #0c, #48, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #8c, #8c, #0c
DEFB #84, #0c, #c0, #c4, #0c, #0c, #0c, #4c, #0c, #84, #0c, #84, #c4, #4c, #4c, #84, #0c, #84, #0c, #4c, #0c, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #c0, #84, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #84, #0c, #0c, #4c, #0c, #0c, #84, #4c, #0c, #0c, #0c, #0c, #84, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #c0, #84, #84, #84, #0c, #84, #84, #0c, #0c, #0c, #0c, #84, #0c, #84, #0c, #0c, #0c
DEFB #8c, #8c, #0c, #0c, #c8, #0c, #8c, #8c, #8c, #8c, #8c, #48, #0c, #0c, #48, #8c, #8c, #c8, #0c, #0c, #8c, #8c, #c8, #48, #0c, #48, #0c, #8c, #0c, #8c, #0c, #48, #0c, #8c, #8c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #8c, #0c, #8c, #0c, #0c, #0c, #0c, #8c, #8c, #8c, #8c, #48, #0c, #48, #0c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #8c, #0c, #0c, #0c, #8c, #0c, #0c, #48, #0c
DEFB #0c, #4c, #4c, #0c, #4c, #0c, #84, #c4, #4c, #0c, #0c, #84, #84, #c0, #4c, #0c, #84, #84, #4c, #0c, #84, #84, #84, #0c, #0c, #0c, #84, #84, #0c, #0c, #0c, #84, #0c, #84, #0c, #4c, #4c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #4c, #0c, #0c, #84, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #0c, #4c, #0c, #0c, #84, #84, #84, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #84, #84, #84, #84
DEFB #0c, #0c, #8c, #8c, #8c, #c8, #0c, #8c, #8c, #48, #4c, #8c, #cc, #8c, #48, #48, #0c, #8c, #8c, #8c, #4c, #8c, #0c, #48, #0c, #0c, #8c, #8c, #48, #0c, #0c, #8c, #8c, #8c, #0c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #0c, #8c, #cc, #8c, #cc, #8c, #8c, #8c, #8c, #8c, #8c, #48, #0c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #c8, #8c, #8c, #8c, #8c, #8c, #0c, #8c, #48, #0c, #0c, #0c
DEFB #0c, #4c, #84, #0c, #84, #4c, #4c, #4c, #4c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #84, #4c, #4c, #4c, #4c, #4c, #c0, #84, #84, #84, #4c, #4c, #4c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #0c, #0c, #0c, #4c, #0c, #0c, #84, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #48, #4c, #0c, #4c, #4c, #4c, #0c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84
DEFB #8c, #8c, #8c, #0c, #8c, #cc, #8c, #cc, #8c, #8c, #8c, #8c, #8c, #0c, #8c, #8c, #0c, #c8, #0c, #8c, #0c, #cc, #8c, #0c, #0c, #8c, #48, #0c, #0c, #cc, #8c, #8c, #8c, #8c, #8c, #cc, #8c, #8c, #8c, #c8, #c0, #8c, #8c, #0c, #8c, #8c, #0c, #48, #0c, #0c, #8c, #8c, #0c, #8c, #0c, #0c, #8c, #8c, #0c, #0c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #0c, #0c, #0c, #0c, #0c, #48, #0c, #48, #0c, #0c, #0c, #0c, #0c
DEFB #4c, #4c, #4c, #4c, #4c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #84, #0c, #84, #0c, #0c, #0c, #48, #c4, #48, #0c, #4c, #0c, #48, #0c, #0c, #0c, #0c, #4c, #4c, #4c, #0c, #84, #0c, #0c, #4c, #84, #4c, #4c, #0c, #0c, #4c, #0c, #0c, #4c, #4c, #0c, #0c, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #0c, #84, #4c, #4c, #0c, #0c, #4c, #0c, #0c, #84, #0c, #84, #84, #84, #84, #0c, #0c, #48, #84, #0c, #0c, #84
DEFB #0c, #0c, #0c, #8c, #0c, #cc, #cc, #8c, #8c, #8c, #cc, #8c, #8c, #0c, #8c, #8c, #0c, #8c, #8c, #0c, #cc, #cc, #8c, #0c, #0c, #48, #8c, #8c, #8c, #8c, #8c, #c0, #0c, #8c, #0c, #8c, #cc, #8c, #48, #8c, #cc, #cc, #cc, #8c, #0c, #c8, #8c, #8c, #cc, #cc, #8c, #8c, #0c, #48, #8c, #8c, #8c, #48, #0c, #0c, #8c, #c8, #0c, #8c, #8c, #8c, #8c, #0c, #0c, #0c, #0c, #48, #0c, #0c, #8c, #0c, #8c, #8c, #8c, #48
DEFB #4c, #0c, #0c, #0c, #4c, #4c, #4c, #4c, #0c, #4c, #0c, #4c, #84, #4c, #4c, #4c, #0c, #0c, #48, #4c, #4c, #4c, #4c, #0c, #0c, #84, #c0, #0c, #0c, #0c, #0c, #4c, #0c, #c0, #84, #4c, #4c, #4c, #0c, #0c, #0c, #c4, #0c, #c4, #4c, #4c, #0c, #0c, #84, #4c, #0c, #4c, #0c, #4c, #0c, #0c, #0c, #84, #0c, #0c, #0c, #c0, #0c, #4c, #0c, #4c, #cc, #0c, #84, #0c, #84, #0c, #0c, #0c, #0c, #84, #0c, #4c, #0c, #4c
DEFB #0c, #0c, #48, #0c, #8c, #cc, #8c, #cc, #cc, #cc, #8c, #48, #0c, #8c, #8c, #8c, #8c, #8c, #8c, #0c, #8c, #0c, #c8, #8c, #8c, #8c, #8c, #48, #0c, #0c, #8c, #8c, #8c, #8c, #8c, #0c, #0c, #8c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #cc, #8c, #cc, #0c, #0c, #48, #0c, #8c, #8c, #8c, #8c, #c8, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #8c, #0c, #0c, #8c, #8c, #0c, #0c, #0c, #8c, #8c
DEFB #0c, #0c, #0c, #0c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #c4, #4c, #4c, #0c, #4c, #4c, #4c, #0c, #84, #0c, #4c, #0c, #84, #0c, #0c, #84, #0c, #0c, #4c, #0c, #0c, #84, #c4, #84, #0c, #0c, #0c, #4c, #4c, #0c, #4c, #c4, #4c, #84, #4c, #4c, #4c, #4c, #0c, #84, #4c, #4c, #4c, #0c, #c0, #0c, #0c, #0c, #0c, #0c, #84, #0c, #0c, #c4, #4c, #4c, #4c, #84, #0c, #0c, #0c, #84, #4c, #0c, #4c, #0c
DEFB #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #cc, #cc, #cc, #8c, #0c, #8c, #0c, #8c, #cc, #cc, #cc, #8c, #8c, #0c, #c8, #48, #8c, #8c, #8c, #8c, #8c, #c0, #48, #0c, #0c, #0c, #8c, #8c, #8c, #8c, #0c, #0c, #8c, #8c, #cc, #8c, #8c, #0c, #cc, #0c, #cc, #8c, #8c, #0c, #0c, #0c, #0c, #c8, #0c, #8c, #8c, #0c, #0c, #0c, #8c, #8c, #8c, #48, #8c, #0c, #48, #0c, #8c, #8c, #c8, #0c, #8c, #0c, #8c, #8c
DEFB #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #c4, #4c, #4c, #4c, #0c, #4c, #4c, #4c, #4c, #0c, #4c, #4c, #4c, #0c, #0c, #0c, #0c, #48, #40, #84, #0c, #0c, #84, #4c, #4c, #0c, #84, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #84, #84, #0c, #0c, #0c, #4c, #4c, #4c, #84, #0c, #84, #0c, #0c, #0c, #0c, #0c, #84, #4c, #0c, #4c, #0c, #0c, #84, #0c, #0c, #84, #0c, #0c, #0c, #84, #84, #0c, #84, #0c, #0c, #0c, #0c, #0c
DEFB #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #0c, #0c, #cc, #cc, #cc, #8c, #8c, #8c, #cc, #8c, #0c, #8c, #8c, #8c, #c8, #0c, #0c, #0c, #48, #8c, #cc, #8c, #cc, #8c, #48, #0c, #0c, #8c, #0c, #8c, #8c, #8c, #0c, #48, #0c, #0c, #8c, #8c, #cc, #8c, #cc, #0c, #0c, #0c, #0c, #0c, #8c, #0c, #48, #0c, #0c, #8c, #0c, #8c, #cc, #8c, #0c, #0c, #8c, #c8, #0c, #0c, #8c, #48, #0c, #0c, #8c, #0c, #0c
DEFB #0c, #0c, #0c, #c0, #0c, #84, #0c, #0c, #0c, #84, #0c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #0c, #4c, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #c0, #c4, #4c, #4c, #0c, #0c, #4c, #0c, #84, #84, #0c, #0c, #84, #4c, #4c, #4c, #84, #84, #4c, #4c, #4c, #4c, #4c, #48, #c0, #84, #84, #0c, #0c, #84, #0c, #0c, #0c, #c4, #4c, #4c, #4c, #4c, #0c, #c0, #84, #0c, #4c, #0c, #0c, #0c, #84, #84, #0c, #0c
DEFB #0c, #0c, #0c, #48, #48, #48, #0c, #0c, #8c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #cc, #8c, #8c, #8c, #8c, #cc, #8c, #8c, #8c, #8c, #8c, #0c, #8c, #8c, #8c, #c8, #0c, #c8, #0c, #8c, #8c, #8c, #8c, #0c, #0c, #48, #4c, #cc, #cc, #cc, #cc, #c8, #84, #0c, #4c, #8c, #8c, #0c, #8c, #8c, #0c, #48, #48, #0c, #0c, #8c, #8c, #8c, #8c, #0c, #8c, #8c, #8c, #8c, #8c, #84, #0c, #0c, #8c, #0c, #8c, #48, #8c, #0c
DEFB #48, #0c, #0c, #0c, #0c, #84, #84, #84, #84, #84, #48, #84, #84, #84, #0c, #0c, #84, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #0c, #4c, #0c, #0c, #0c, #0c, #4c, #0c, #4c, #0c, #0c, #0c, #0c, #84, #0c, #4c, #0c, #4c, #4c, #0c, #4c, #4c, #4c, #c0, #0c, #4c, #84, #0c, #c0, #4c, #4c, #4c, #0c, #4c, #0c, #84, #84, #0c, #0c, #0c, #0c, #48, #84, #0c, #4c, #4c, #0c, #4c, #0c, #0c, #84, #84, #48, #0c, #0c, #4c
DEFB #0c, #0c, #48, #48, #0c, #0c, #0c, #48, #48, #48, #48, #48, #0c, #48, #48, #0c, #0c, #48, #0c, #0c, #8c, #8c, #cc, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #cc, #8c, #cc, #8c, #c8, #48, #0c, #8c, #8c, #8c, #cc, #8c, #8c, #c0, #4c, #c8, #48, #8c, #cc, #8c, #8c, #c8, #48, #0c, #8c, #8c, #cc, #8c, #cc, #88, #48, #48, #0c, #0c, #0c, #8c, #8c, #c8, #0c, #0c, #8c, #8c, #cc, #8c, #8c, #8c, #0c, #0c, #8c
DEFB #0c, #84, #84, #0c, #84, #0c, #84, #84, #0c, #84, #0c, #c0, #0c, #84, #84, #84, #0c, #48, #84, #0c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #0c, #4c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #4c, #04, #84, #4c, #4c, #4c, #4c, #0c, #4c, #4c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #48, #40, #c4, #4c, #4c, #4c, #84, #4c, #4c, #0c, #48, #c4, #4c, #4c, #4c, #84, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #84, #84
DEFB #48, #0c, #0c, #0c, #48, #48, #0c, #48, #0c, #48, #48, #c0, #0c, #48, #0c, #48, #48, #48, #0c, #0c, #0c, #0c, #0c, #0c, #8c, #8c, #0c, #0c, #cc, #8c, #8c, #0c, #cc, #8c, #cc, #cc, #8c, #8c, #8c, #0c, #cc, #8c, #c8, #0c, #cc, #cc, #8c, #c8, #0c, #8c, #cc, #8c, #cc, #8c, #48, #cc, #8c, #8c, #0c, #48, #0c, #8c, #cc, #cc, #cc, #c8, #48, #0c, #48, #8c, #cc, #8c, #8c, #0c, #8c, #8c, #8c, #84, #8c, #8c
DEFB #c0, #84, #48, #84, #c0, #0c, #84, #0c, #0c, #0c, #48, #84, #48, #84, #c0, #c0, #c0, #c0, #84, #84, #0c, #0c, #84, #0c, #84, #4c, #84, #84, #0c, #4c, #0c, #0c, #4c, #4c, #4c, #0c, #4c, #4c, #4c, #4c, #48, #84, #c0, #4c, #4c, #4c, #0c, #4c, #4c, #4c, #0c, #0c, #c4, #4c, #c4, #4c, #4c, #4c, #4c, #48, #84, #4c, #4c, #4c, #4c, #0c, #84, #0c, #84, #4c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c, #0c
DEFB #c0, #0c, #0c, #48, #48, #0c, #48, #0c, #0c, #48, #48, #0c, #0c, #84, #48, #48, #c0, #48, #84, #84, #0c, #48, #0c, #0c, #48, #0c, #48, #c8, #0c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #8c, #0c, #8c, #84, #cc, #8c, #8c, #8c, #0c, #0c, #0c, #8c, #cc, #cc, #cc, #8c, #8c, #c0, #0c, #0c, #4c, #8c, #48, #0c, #8c, #0c, #8c, #0c, #0c, #48, #8c, #8c, #8c, #8c, #8c, #0c, #48
DEFB #84, #4c, #0c, #48, #84, #c0, #84, #84, #0c, #84, #0c, #84, #84, #84, #84, #48, #c0, #c0, #84, #c0, #84, #0c, #0c, #84, #0c, #0c, #84, #48, #84, #0c, #0c, #0c, #4c, #4c, #4c, #0c, #4c, #0c, #0c, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #c4, #4c, #4c, #4c, #4c, #4c, #4c, #0c, #0c, #84, #4c, #4c, #cc, #c0, #0c, #0c, #4c, #0c, #4c, #04, #0c, #0c, #0c, #0c, #0c, #0c, #40, #84, #4c, #0c, #4c, #0c, #4c, #0c
DEFB #48, #0c, #48, #48, #0c, #84, #48, #48, #48, #0c, #48, #48, #48, #48, #48, #48, #48, #c0, #48, #48, #0c, #48, #48, #0c, #48, #0c, #0c, #48, #0c, #48, #48, #0c, #0c, #8c, #cc, #8c, #8c, #8c, #8c, #8c, #cc, #cc, #cc, #cc, #cc, #8c, #8c, #0c, #8c, #c8, #0c, #8c, #cc, #8c, #8c, #8c, #8c, #cc, #8c, #0c, #8c, #8c, #8c, #8c, #8c, #cc, #8c, #0c, #8c, #8c, #8c, #8c, #48, #8c, #8c, #c8, #48, #0c, #8c, #c8




org #8000
; Data created with Img2CPC - (c) Retroworks - 2007-2015
; Tile tardis - 160x200 pixels, 80x200 bytes.
tardis:
DEFB #70, #70, #f0, #f4, #f0, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #b0, #30, #b0, #74, #fc, #fc, #fc, #fc, #fc, #f0, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #f8, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #30, #f0, #f0, #f8, #f8, #f8, #f8, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #38, #30, #b0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #f0, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #f0, #70, #f0, #f0, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #70, #70, #70, #74, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f0, #f4, #f4, #fc, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc
DEFB #3c, #78, #b0, #f0, #fc, #f8, #f8, #f8, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #38, #b0, #b0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b8, #f0, #f8, #fc, #fc, #f8, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #f8, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #b4, #3c, #f0, #f0, #70, #f4, #f0, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #fc, #f0, #30, #70, #74, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f0, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc
DEFB #3c, #bc, #3c, #bc, #38, #f0, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #b0, #b0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f0, #f0, #fc, #f8, #fc, #f8, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #f8, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #f0, #70, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #70, #70, #70, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f0, #70, #f4, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #bc, #bc, #bc, #3c, #bc, #f8, #78, #f0, #78, #f8, #f8, #f8, #fc, #f8, #fc, #30, #b0, #b0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #f8, #f8, #f8, #f0, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #b4, #7c, #3c, #3c, #3c, #f0, #70, #b4, #f0, #f4, #f0, #f4, #f0, #70, #70, #70, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f0, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #bc, #bc, #3c, #bc, #3c, #3c, #bc, #bc, #78, #38, #f0, #f8, #f8, #f8, #b8, #70, #b0, #f0, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f0, #f8, #f8, #fc, #f8, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f0, #fc, #f8, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #7c, #3c, #b4, #3c, #3c, #3c, #7c, #3c, #b4, #70, #f4, #f4, #b0, #70, #70, #70, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #bc, #bc, #3c, #bc, #3c, #bc, #bc, #bc, #bc, #fc, #f8, #78, #78, #b8, #70, #f0, #f0, #f4, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #f8, #f0, #f8, #fc, #f8, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #f8, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #b4, #3c, #3c, #7c, #3c, #3c, #3c, #7c, #3c, #b4, #3c, #f4, #3c, #f0, #b0, #70, #30, #70, #f4, #f4, #f4, #f4, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #74, #f4, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #f4, #fc
DEFB #3c, #bc, #78, #bc, #bc, #bc, #bc, #3c, #3c, #bc, #bc, #bc, #bc, #bc, #38, #f0, #b0, #f0, #f0, #fc, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #f8, #f0, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #fc, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #f8
DEFB #7c, #3c, #3c, #3c, #b4, #3c, #3c, #b4, #f4, #b4, #7c, #3c, #7c, #7c, #3c, #70, #70, #70, #74, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #fc, #fc, #fc, #fc, #f0, #f0, #f4, #f4, #f4, #f4, #fc, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #f8, #f0
DEFB #3c, #bc, #bc, #bc, #3c, #78, #3c, #bc, #fc, #bc, #bc, #3c, #3c, #3c, #bc, #30, #b0, #f0, #f0, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #f8, #f8, #f0
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #b4, #7c, #b4, #3c, #7c, #7c, #3c, #7c, #3c, #30, #30, #70, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #70, #70, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #f0, #f0, #f0
DEFB #3c, #bc, #bc, #bc, #bc, #bc, #bc, #bc, #3c, #bc, #bc, #3c, #3c, #fc, #bc, #38, #30, #b0, #b0, #f0, #78, #78, #f8, #fc, #f8, #fc, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #20, #70, #f0, #fc, #fc, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f0
DEFB #3c, #3c, #3c, #7c, #3c, #3c, #7c, #7c, #7c, #b4, #3c, #7c, #7c, #7c, #7c, #30, #10, #30, #30, #34, #3c, #b4, #b4, #f4, #7c, #f4, #f4, #f4, #f4, #f0, #fc, #fc, #fc, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #a0, #30, #10, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f4, #f4, #f4, #f0, #f0, #f0, #f0, #f0
DEFB #3c, #3c, #bc, #bc, #bc, #3c, #bc, #3c, #bc, #38, #fc, #bc, #fc, #bc, #bc, #38, #b0, #b0, #38, #34, #fc, #f8, #78, #f0, #f8, #f8, #fc, #f8, #fc, #fc, #f8, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #a8, #30, #30, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #b4, #3c, #3c, #7c, #7c, #7c, #f0, #70, #70, #38, #74, #7c, #7c, #7c, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #70, #74, #fc, #fc, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #70, #70, #f4, #f0, #f0, #f0, #f0, #f4, #fc
DEFB #3c, #bc, #3c, #3c, #bc, #3c, #3c, #bc, #3c, #bc, #bc, #bc, #bc, #bc, #3c, #78, #f0, #78, #f8, #7c, #3c, #bc, #bc, #bc, #f8, #78, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #b0, #f8, #f8, #f8, #b0, #f0, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #7c, #f0, #70, #f4, #7c, #7c, #7c, #7c, #7c, #7c, #7c, #7c, #f0, #70, #f4, #f4, #f4, #f4, #f0, #74, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #70, #f4, #f0, #f0, #f4, #f4, #f4
DEFB #bc, #bc, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #bc, #3c, #78, #f0, #bc, #bc, #bc, #fc, #fc, #fc, #bc, #bc, #bc, #f8, #78, #f0, #f8, #f8, #f8, #b8, #f0, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f0, #f0, #f8, #f8, #f8, #fc, #f8
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #7c, #7c, #34, #f0, #7c, #7c, #7c, #7c, #7c, #3c, #7c, #7c, #7c, #78, #70, #70, #f0, #f0, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #f8, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f0, #f0, #f0, #f0, #f0, #f4, #f4, #f4
DEFB #3c, #bc, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #78, #fc, #3c, #bc, #bc, #bc, #bc, #bc, #3c, #bc, #bc, #78, #f0, #f0, #f0, #f8, #f8, #f8, #f8, #fc, #f8, #f8, #fc, #fc, #fc, #f8, #b0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f0, #fc, #f8, #f0, #f0, #f8, #f8, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #3c, #3c, #7c, #7c, #3c, #7c, #3c, #f0, #7c, #7c, #7c, #3c, #7c, #3c, #3c, #7c, #7c, #7c, #f0, #f0, #f0, #f4, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #50, #f4, #fc, #b8, #10, #74, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f4, #f0, #f4, #fc, #fc, #f0, #70, #f4, #f4, #f4
DEFB #bc, #bc, #3c, #3c, #bc, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #f8, #78, #bc, #3c, #3c, #3c, #bc, #3c, #bc, #bc, #bc, #bc, #78, #f0, #f8, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #f8, #20, #a0, #f0, #a8, #20, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #f8, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #f8, #f0, #f0, #fc, #f8
DEFB #3c, #3c, #3c, #7c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #3c, #7c, #3c, #78, #f0, #7c, #7c, #3c, #7c, #3c, #3c, #3c, #3c, #7c, #3c, #f0, #f0, #f4, #f0, #f0, #f4, #f4, #f0, #f0, #f4, #b0, #00, #00, #00, #50, #00, #54, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #50, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #f4, #f0, #f4, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #f4, #f0, #f0, #f4
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #bc, #3c, #3c, #bc, #3c, #3c, #bc, #f8, #f8, #bc, #3c, #3c, #3c, #3c, #bc, #3c, #bc, #bc, #f8, #78, #f0, #f0, #f0, #f8, #f0, #f4, #f8, #f8, #f8, #20, #a0, #00, #00, #00, #00, #a0, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #7c, #3c, #7c, #78, #f4, #7c, #7c, #7c, #7c, #7c, #3c, #7c, #7c, #7c, #7c, #f0, #f0, #f0, #f4, #f0, #f0, #f0, #f0, #f4, #b0, #00, #00, #00, #00, #00, #00, #00, #10, #50, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #f0, #f4, #f0, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f0
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #bc, #bc, #fc, #3c, #7c, #f8, #f0, #bc, #fc, #bc, #3c, #bc, #3c, #bc, #fc, #bc, #bc, #b0, #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f8, #b0, #20, #00, #00, #00, #00, #00, #00, #00, #a0, #00, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #7c, #3c, #7c, #3c, #7c, #3c, #78, #50, #3c, #7c, #3c, #3c, #3c, #7c, #7c, #7c, #7c, #3c, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f4, #f0, #30, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #50, #f4, #f4, #f4, #f4, #f4, #f0, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #bc, #bc, #bc, #3c, #3c, #bc, #bc, #bc, #3c, #3c, #78, #f0, #bc, #3c, #3c, #bc, #3c, #3c, #3c, #bc, #bc, #bc, #f0, #f0, #f0, #f0, #f8, #f8, #f0, #f8, #b8, #30, #30, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #20, #00, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #f8, #f8, #f8, #f8, #f0, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #3c, #3c, #7c, #3c, #7c, #7c, #7c, #78, #f0, #7c, #3c, #7c, #7c, #7c, #7c, #7c, #7c, #7c, #7c, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #30, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #00, #50, #f4, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f4, #f4, #f0, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #bc, #7c, #3c, #bc, #78, #f0, #bc, #bc, #bc, #3c, #3c, #3c, #bc, #bc, #bc, #bc, #f0, #f0, #f0, #f8, #f8, #f0, #f8, #b8, #30, #30, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #a0, #a0, #70, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #7c, #7c, #78, #f0, #3c, #3c, #3c, #7c, #7c, #3c, #3c, #7c, #7c, #3c, #f0, #f0, #f0, #f4, #f0, #f0, #f4, #30, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f0, #50, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #fc, #bc, #bc, #bc, #3c, #3c, #3c, #bc, #bc, #bc, #78, #f0, #f8, #f0, #f8, #f0, #f0, #30, #30, #20, #00, #00, #a0, #a0, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8, #f8, #f8, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #3c, #7c, #7c, #78, #f4, #3c, #3c, #7c, #7c, #3c, #7c, #3c, #7c, #7c, #7c, #f0, #f0, #70, #f0, #f0, #f0, #b0, #10, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #fc, #fc, #fc, #fc, #f0, #f0, #f4, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #bc, #3c, #bc, #3c, #3c, #3c, #bc, #bc, #bc, #bc, #78, #f8, #f0, #f8, #f8, #f0, #b0, #30, #20, #00, #00, #00, #00, #20, #20, #20, #00, #a0, #a0, #a0, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #3c, #3c, #78, #f0, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #7c, #3c, #f0, #f0, #f0, #f0, #f0, #f0, #30, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f4, #f0, #f0, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #fc, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f8, #bc, #3c, #3c, #bc, #3c, #3c, #bc, #bc, #bc, #bc, #b0, #f8, #f8, #f0, #f8, #b8, #b0, #20, #20, #00, #00, #00, #20, #20, #b0, #30, #20, #20, #20, #a0, #20, #20, #a0, #a0, #a0, #00, #00, #20, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #7c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #7c, #7c, #b0, #f4, #f0, #f4, #f0, #b0, #10, #30, #30, #00, #00, #00, #00, #10, #30, #f0, #10, #10, #10, #10, #10, #00, #00, #10, #00, #00, #00, #10, #f0, #f0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #78, #f8, #bc, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #bc, #bc, #f0, #f0, #f0, #f0, #f8, #b8, #30, #30, #28, #00, #00, #00, #b0, #30, #b0, #a8, #b0, #b0, #f0, #20, #b0, #a0, #20, #20, #a0, #a0, #a0, #20, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #7c, #7c, #70, #f0, #f0, #f0, #f0, #b0, #30, #34, #30, #00, #00, #00, #50, #30, #70, #00, #a0, #70, #50, #20, #f0, #30, #70, #10, #50, #10, #10, #00, #50, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #bc, #3c, #3c, #bc, #3c, #3c, #bc, #bc, #bc, #f8, #f0, #f0, #f0, #f0, #f0, #30, #30, #38, #38, #20, #00, #00, #f0, #b0, #b0, #b0, #b0, #b0, #70, #b0, #b0, #f0, #f0, #30, #b0, #20, #20, #20, #30, #f4, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #7c, #3c, #7c, #70, #f0, #f0, #f4, #70, #30, #34, #34, #30, #00, #00, #00, #10, #70, #70, #70, #70, #f0, #70, #30, #10, #30, #70, #70, #b0, #b0, #00, #00, #00, #54, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #78, #f8, #bc, #3c, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #bc, #b0, #f0, #f0, #f8, #b0, #30, #38, #78, #a0, #20, #00, #00, #20, #30, #f0, #b0, #20, #30, #b0, #a8, #30, #b0, #20, #70, #b0, #30, #30, #f0, #20, #f0, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc
DEFB #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #3c, #7c, #78, #70, #f0, #f4, #f0, #b0, #34, #34, #30, #00, #00, #00, #00, #00, #00, #10, #00, #10, #00, #00, #10, #50, #50, #00, #50, #70, #10, #30, #50, #00, #54, #f4, #f4, #fc, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #bc, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #bc, #f8, #f0, #f0, #f0, #f8, #30, #38, #38, #38, #20, #20, #00, #00, #00, #00, #00, #00, #00, #20, #20, #20, #20, #00, #20, #20, #b8, #f0, #f0, #a0, #20, #f4, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #f8, #fc
DEFB #3c, #3c, #3c, #3c, #b4, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #7c, #3c, #3c, #70, #70, #f0, #b0, #34, #34, #30, #30, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #10, #10, #10, #00, #00, #70, #50, #10, #50, #54, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f4, #f4, #f4, #f4, #f4
DEFB #bc, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f8, #bc, #3c, #bc, #bc, #3c, #bc, #3c, #3c, #3c, #f8, #f0, #f8, #f8, #b8, #38, #38, #38, #20, #20, #20, #00, #00, #00, #00, #00, #20, #00, #00, #20, #00, #00, #20, #a0, #a0, #20, #30, #20, #30, #20, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #fc, #f8
DEFB #b4, #b4, #b4, #b4, #3c, #b4, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #70, #f0, #f0, #30, #34, #34, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #10, #10, #00, #00, #54, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #f4, #f4
DEFB #78, #3c, #78, #3c, #3c, #bc, #3c, #bc, #bc, #3c, #3c, #3c, #3c, #bc, #3c, #78, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f8, #f0, #f8, #f8, #38, #38, #b0, #20, #30, #20, #20, #00, #00, #00, #00, #20, #00, #00, #00, #00, #00, #20, #00, #20, #00, #00, #00, #20, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8
DEFB #b4, #b4, #34, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #7c, #3c, #70, #f4, #fc, #38, #30, #30, #00, #10, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #f4, #f0, #f4, #f4, #f4, #f4
DEFB #3c, #78, #3c, #bc, #3c, #3c, #3c, #bc, #3c, #bc, #3c, #bc, #3c, #bc, #3c, #78, #fc, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #f8, #f0, #fc, #f8, #b8, #38, #30, #20, #20, #20, #30, #00, #00, #00, #a0, #a0, #20, #00, #20, #20, #a0, #a0, #a0, #20, #20, #20, #20, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f0, #f8, #f0, #f8, #f0
DEFB #b4, #34, #b4, #3c, #3c, #3c, #3c, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #70, #f4, #f4, #b0, #30, #30, #00, #00, #10, #00, #00, #00, #00, #54, #f4, #f0, #50, #10, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #54, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #f4, #f4, #f0, #f4, #f0, #f0, #f0, #f0, #30, #70, #50, #70
DEFB #78, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #f8, #b4, #bc, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #30, #20, #20, #20, #70, #20, #00, #00, #00, #a0, #30, #a0, #fc, #f8, #a8, #a0, #00, #00, #20, #00, #20, #00, #20, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #fc, #f8, #f8, #f8, #f8, #f0, #b0, #f0, #f0, #f0, #b0
DEFB #b4, #3c, #3c, #3c, #3c, #3c, #3c, #34, #3c, #3c, #3c, #3c, #3c, #34, #3c, #3c, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #70, #f4, #fc, #b0, #30, #30, #10, #50, #b0, #00, #00, #00, #00, #10, #10, #b0, #10, #10, #00, #00, #00, #50, #00, #10, #00, #00, #00, #00, #00, #54, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f0, #f4, #f0, #f4, #f0, #f0, #70, #f0, #f0, #f0, #f0
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #bc, #bc, #3c, #bc, #bc, #3c, #3c, #3c, #bc, #78, #bc, #bc, #bc, #bc, #3c, #bc, #bc, #3c, #3c, #3c, #bc, #f0, #fc, #fc, #a8, #30, #20, #20, #30, #70, #20, #00, #00, #00, #b0, #30, #a8, #70, #a0, #20, #a0, #00, #f0, #f8, #fc, #b0, #20, #20, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f0, #f8, #b0, #b0, #f0, #f8, #f0, #f8, #f0
DEFB #b4, #3c, #b4, #3c, #34, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f0, #f4, #fc, #a8, #00, #00, #10, #10, #70, #00, #00, #00, #00, #10, #30, #20, #50, #30, #10, #00, #00, #10, #f0, #30, #f0, #50, #00, #00, #50, #54, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f0, #f0, #f0, #30, #70, #70, #f4, #f4, #f4
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #bc, #3c, #3c, #bc, #3c, #78, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #78, #f0, #fc, #fc, #a8, #20, #30, #a0, #20, #f0, #20, #00, #00, #00, #b0, #30, #a0, #70, #b0, #20, #a0, #00, #a0, #70, #20, #a8, #70, #20, #00, #a0, #f0, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f0, #f8, #f8, #b0, #b0, #f0, #fc, #fc, #fc, #fc
DEFB #34, #34, #3c, #34, #3c, #3c, #3c, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f0, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #70, #f4, #fc, #b8, #00, #50, #00, #10, #70, #10, #00, #00, #00, #f0, #30, #b0, #50, #10, #50, #00, #00, #b0, #70, #30, #a0, #50, #00, #00, #00, #54, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #70, #f0, #f0, #f0, #f0, #70, #fc, #fc, #fc, #fc
DEFB #38, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #bc, #3c, #bc, #3c, #3c, #bc, #bc, #78, #fc, #bc, #bc, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #f8, #f0, #fc, #fc, #a8, #20, #30, #20, #30, #b0, #20, #00, #00, #00, #b0, #30, #b8, #70, #30, #20, #a0, #00, #a0, #70, #20, #a8, #70, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #f8, #f4, #fc, #fc, #fc, #fc
DEFB #30, #34, #34, #3c, #3c, #34, #b4, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f0, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #70, #f4, #fc, #a8, #10, #10, #30, #10, #70, #00, #00, #00, #00, #10, #30, #b0, #50, #30, #50, #00, #00, #00, #70, #30, #a0, #50, #00, #00, #00, #54, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f0, #f0, #f0, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #f8, #f4, #fc, #fc, #fc, #fc
DEFB #38, #3c, #3c, #3c, #38, #3c, #78, #3c, #3c, #38, #3c, #3c, #bc, #bc, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #78, #f0, #fc, #fc, #a8, #20, #30, #20, #20, #f0, #20, #00, #00, #00, #b0, #30, #b0, #70, #20, #20, #a0, #00, #a0, #70, #20, #a8, #70, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #b4, #34, #b4, #b4, #3c, #3c, #3c, #3c, #b4, #f0, #f4, #34, #3c, #3c, #3c, #34, #3c, #3c, #3c, #3c, #3c, #70, #f4, #f4, #a8, #00, #10, #00, #10, #70, #00, #00, #00, #00, #10, #20, #b0, #54, #30, #10, #00, #00, #b0, #70, #10, #a0, #50, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #f4, #f4, #f4, #f4, #f4, #fc, #f4, #f4, #f0, #f0, #f4, #f4, #f4, #f8, #f4, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #78, #78, #3c, #38, #3c, #3c, #3c, #38, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #bc, #f8, #f0, #fc, #fc, #a8, #20, #30, #a0, #30, #f0, #20, #00, #00, #00, #b0, #20, #b8, #70, #b0, #20, #00, #00, #b0, #f0, #b0, #a8, #70, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #f8, #f0, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #b4, #b4, #b4, #3c, #3c, #b4, #b4, #b4, #3c, #3c, #3c, #3c, #b4, #b4, #f0, #f4, #b4, #3c, #3c, #3c, #34, #34, #3c, #b4, #3c, #78, #70, #f4, #f4, #a0, #00, #50, #10, #10, #70, #00, #00, #00, #00, #50, #b0, #b0, #74, #30, #70, #00, #00, #00, #50, #10, #b0, #50, #00, #00, #00, #54, #fc, #fc, #f4, #fc, #f4, #fc, #f4, #f4, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f0, #f0, #f4, #fc, #fc, #fc, #fc
DEFB #3c, #38, #78, #3c, #78, #3c, #78, #3c, #3c, #bc, #bc, #3c, #3c, #bc, #3c, #78, #fc, #bc, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #78, #f0, #f8, #f8, #a8, #20, #30, #a0, #20, #f0, #20, #00, #00, #00, #f0, #f8, #f8, #fc, #f8, #a8, #a0, #00, #a0, #70, #20, #b8, #70, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #b4, #b4, #b4, #b4, #b4, #b4, #b4, #3c, #3c, #3c, #3c, #3c, #b4, #b4, #f0, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #70, #f4, #fc, #b8, #00, #50, #20, #50, #70, #00, #00, #00, #00, #f0, #30, #30, #70, #70, #00, #00, #00, #f0, #f0, #30, #a0, #54, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #f4, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f8, #f4, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #78, #3c, #78, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f8, #f0, #fc, #fc, #a8, #20, #b0, #b0, #30, #70, #20, #00, #00, #00, #f0, #b0, #b0, #70, #f0, #a0, #a0, #a0, #f8, #f0, #f8, #f8, #f8, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #b4, #b4, #b4, #3c, #b4, #3c, #3c, #3c, #34, #3c, #b4, #f0, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #70, #f4, #fc, #a0, #10, #50, #20, #10, #70, #00, #00, #00, #00, #50, #70, #00, #54, #70, #00, #00, #00, #f0, #f0, #00, #f0, #50, #00, #00, #00, #54, #f4, #fc, #f4, #f4, #f4, #fc, #fc, #f4, #fc, #f4, #fc, #fc, #f4, #f4, #fc, #f4, #f4, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #38, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #20, #b0, #a0, #30, #f0, #20, #00, #00, #00, #f0, #b0, #a0, #70, #f0, #a0, #00, #00, #f8, #f0, #20, #f8, #f0, #20, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #34, #34, #b4, #34, #34, #3c, #34, #3c, #34, #3c, #3c, #3c, #3c, #b4, #f0, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f0, #f4, #fc, #a8, #00, #f0, #20, #50, #70, #00, #00, #00, #00, #50, #70, #b0, #50, #70, #00, #00, #00, #f0, #f0, #10, #f0, #f0, #00, #00, #00, #54, #f4, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #f4, #f4, #fc, #fc, #f4, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #bc, #f0, #fc, #fc, #a8, #20, #b0, #a0, #70, #f0, #20, #00, #00, #00, #f0, #b0, #a0, #70, #f0, #a0, #00, #00, #f8, #f0, #30, #f8, #f8, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #30, #34, #34, #b4, #34, #3c, #34, #34, #34, #3c, #34, #3c, #34, #3c, #3c, #f0, #f4, #3c, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f4, #fc, #a0, #10, #10, #30, #50, #70, #00, #00, #00, #00, #50, #f0, #00, #50, #70, #00, #00, #00, #f0, #f0, #20, #f4, #f0, #00, #00, #00, #54, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #f4, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #20, #b0, #a0, #30, #f0, #20, #00, #00, #00, #f0, #f0, #a0, #70, #f0, #a0, #00, #00, #f0, #f0, #20, #f8, #f8, #20, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #f8, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #b4, #34, #34, #34, #b4, #34, #3c, #34, #3c, #b4, #3c, #34, #3c, #34, #3c, #f0, #f4, #b4, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #70, #f4, #fc, #a0, #00, #f0, #a0, #50, #70, #00, #00, #00, #00, #f0, #f0, #a0, #50, #f0, #10, #00, #00, #f0, #f0, #30, #f0, #f0, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #f4, #f4, #f4, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #78, #38, #3c, #3c, #78, #78, #3c, #3c, #3c, #78, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f8, #f0, #fc, #fc, #a8, #20, #b0, #a0, #70, #70, #20, #00, #00, #00, #f0, #b0, #a0, #70, #f0, #a0, #a0, #00, #f8, #f8, #30, #f8, #f8, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #70, #b4, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f0, #f4, #b4, #34, #3c, #34, #3c, #34, #3c, #3c, #3c, #78, #f0, #f4, #fc, #a0, #10, #10, #a0, #50, #70, #00, #00, #00, #00, #50, #f0, #00, #54, #70, #10, #00, #00, #f0, #f0, #20, #f4, #f0, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #f4, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #38, #38, #78, #78, #78, #78, #78, #78, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #20, #b0, #a0, #70, #f8, #00, #00, #00, #00, #f0, #f8, #f8, #fc, #f8, #a8, #a0, #a0, #f8, #f8, #20, #f8, #f8, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #b4, #34, #b4, #34, #b4, #34, #34, #34, #34, #34, #3c, #34, #3c, #f0, #f4, #b4, #b4, #34, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #f0, #f4, #fc, #b8, #00, #f0, #a0, #50, #10, #00, #00, #00, #00, #10, #10, #10, #50, #f0, #a0, #00, #00, #f4, #f4, #f0, #54, #f8, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #f4, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #38, #3c, #38, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #bc, #3c, #3c, #3c, #3c, #f0, #fc, #fc, #a8, #20, #b0, #20, #20, #20, #20, #00, #00, #00, #00, #20, #20, #00, #20, #a0, #00, #00, #a0, #70, #f0, #f8, #a8, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #b4, #34, #34, #34, #3c, #34, #34, #34, #34, #34, #f0, #f4, #3c, #34, #b4, #34, #3c, #34, #3c, #3c, #3c, #3c, #f0, #f4, #fc, #a0, #00, #10, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #00, #00, #00, #00, #00, #00, #54, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #f4, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #38, #3c, #3c, #3c, #38, #3c, #3c, #3c, #3c, #3c, #3c, #78, #38, #78, #fc, #3c, #38, #3c, #3c, #3c, #78, #3c, #3c, #3c, #78, #f8, #f8, #fc, #a8, #20, #20, #20, #20, #30, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #00, #20, #00, #00, #00, #a0, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #3c, #34, #3c, #34, #3c, #34, #3c, #b4, #3c, #f0, #f4, #34, #3c, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #b4, #f0, #f4, #fc, #a8, #00, #10, #00, #10, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #fc, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #38, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #38, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f8, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #3c, #34, #34, #3c, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #b4, #3c, #3c, #34, #34, #3c, #3c, #3c, #3c, #f0, #f0, #f4, #fc, #a0, #00, #00, #00, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #38, #38, #3c, #38, #38, #38, #3c, #38, #3c, #38, #3c, #38, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #20, #a0, #a0, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #3c, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #b4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #b4, #f0, #f4, #f4, #a8, #00, #10, #00, #10, #00, #00, #00, #00, #00, #50, #f0, #f0, #50, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #38, #3c, #38, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f0, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #f8, #fc, #f8, #fc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #b4, #3c, #3c, #3c, #34, #3c, #3c, #3c, #3c, #f0, #f0, #f4, #fc, #a0, #00, #00, #00, #00, #10, #00, #00, #00, #00, #50, #fc, #f4, #f4, #f4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #3c, #38, #3c, #38, #3c, #3c, #38, #38, #3c, #38, #3c, #3c, #3c, #3c, #78, #f4, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #f8, #f8, #f8, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #fc, #f8, #fc, #fc, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #b4, #3c, #3c, #34, #34, #3c, #3c, #3c, #3c, #3c, #70, #f4, #f4, #b0, #00, #10, #00, #00, #00, #00, #00, #00, #00, #50, #fc, #f0, #f4, #fc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #3c, #3c, #38, #3c, #38, #3c, #3c, #3c, #38, #3c, #3c, #3c, #3c, #3c, #78, #fc, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #3c, #78, #78, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #fc, #fc, #fc, #fc, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #3c, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #b4, #f4, #b4, #3c, #3c, #34, #34, #34, #3c, #3c, #3c, #b0, #f0, #f4, #fc, #a0, #00, #00, #00, #00, #10, #00, #00, #00, #00, #50, #fc, #f4, #f4, #fc, #00, #00, #54, #00, #00, #00, #00, #00, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #3c, #38, #3c, #38, #38, #38, #38, #38, #3c, #38, #3c, #38, #3c, #3c, #78, #f0, #3c, #3c, #3c, #38, #3c, #38, #3c, #3c, #3c, #38, #f0, #f8, #fc, #a8, #20, #00, #20, #20, #20, #00, #00, #00, #00, #00, #fc, #f8, #fc, #f8, #a0, #00, #50, #00, #00, #f8, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #34, #3c, #34, #30, #b0, #34, #3c, #3c, #34, #78, #70, #f4, #f4, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f4, #f4, #f4, #f4, #00, #00, #54, #00, #50, #54, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc
DEFB #38, #38, #38, #38, #3c, #38, #38, #38, #38, #38, #3c, #3c, #38, #38, #3c, #78, #7c, #38, #3c, #3c, #38, #b8, #3c, #3c, #3c, #3c, #38, #f0, #fc, #fc, #a8, #20, #00, #20, #20, #20, #20, #00, #00, #00, #10, #fc, #f8, #fc, #fc, #20, #00, #00, #00, #54, #f0, #a0, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #34, #3c, #34, #30, #30, #34, #34, #34, #34, #70, #70, #f4, #fc, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f4, #f4, #f4, #f4, #00, #00, #50, #00, #50, #b8, #00, #00, #00, #00, #00, #54, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #38, #38, #38, #38, #3c, #3c, #3c, #3c, #3c, #38, #38, #38, #3c, #38, #78, #f4, #3c, #3c, #38, #38, #30, #38, #3c, #3c, #3c, #78, #f0, #f8, #fc, #a8, #20, #00, #20, #00, #20, #20, #00, #00, #00, #00, #f8, #f8, #f8, #f8, #20, #00, #00, #00, #54, #f0, #a0, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #30, #34, #34, #34, #34, #f4, #34, #3c, #34, #30, #30, #34, #34, #34, #34, #f0, #70, #f4, #fc, #a0, #00, #10, #00, #00, #00, #00, #00, #00, #00, #50, #f4, #f4, #f0, #f4, #20, #00, #00, #00, #50, #f4, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #fc
DEFB #3c, #38, #38, #38, #3c, #38, #38, #38, #3c, #38, #3c, #38, #3c, #3c, #3c, #78, #fc, #38, #3c, #3c, #38, #30, #3c, #38, #3c, #3c, #78, #f0, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #50, #f8, #f8, #f8, #fc, #20, #a0, #00, #00, #00, #f8, #00, #00, #00, #00, #00, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #fc
DEFB #34, #34, #34, #34, #34, #34, #30, #34, #34, #34, #34, #34, #30, #34, #30, #34, #f4, #34, #3c, #34, #30, #30, #34, #34, #30, #34, #f0, #70, #f4, #fc, #a0, #00, #00, #00, #00, #10, #00, #00, #00, #00, #50, #f4, #f4, #fc, #f4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #fc
DEFB #38, #38, #38, #3c, #38, #3c, #38, #3c, #38, #3c, #38, #3c, #38, #38, #38, #78, #f0, #38, #3c, #78, #38, #70, #b0, #38, #38, #f0, #b0, #f0, #f8, #fc, #a8, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #fc, #f8, #f8, #f8, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #f8
DEFB #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #3c, #3c, #34, #f0, #f4, #34, #34, #34, #30, #30, #34, #34, #7c, #f4, #fc, #f8, #f4, #fc, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f4, #f4, #f4, #f4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #f8
DEFB #38, #38, #38, #38, #38, #38, #38, #38, #3c, #38, #3c, #38, #3c, #38, #3c, #78, #fc, #38, #3c, #3c, #38, #30, #38, #38, #fc, #fc, #fc, #f8, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #70, #fc, #fc, #fc, #fc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #b8
DEFB #34, #34, #30, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #b4, #3c, #34, #30, #30, #34, #30, #70, #fc, #fc, #f8, #f4, #fc, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f4, #f0, #f0, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #fc, #f4, #fc, #f4, #fc, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f0, #fc, #fc, #fc, #fc, #b0
DEFB #38, #38, #38, #38, #38, #38, #38, #38, #38, #38, #38, #38, #38, #3c, #38, #78, #b4, #38, #38, #3c, #38, #30, #38, #38, #30, #f0, #fc, #f8, #f8, #fc, #a8, #20, #20, #20, #20, #20, #00, #00, #00, #00, #50, #f8, #f8, #f8, #f8, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #b0
DEFB #34, #34, #34, #34, #34, #34, #34, #30, #34, #34, #34, #34, #34, #34, #34, #34, #f4, #34, #34, #34, #30, #30, #30, #30, #30, #70, #74, #78, #f4, #fc, #a0, #00, #10, #00, #00, #00, #00, #00, #00, #00, #50, #fc, #f4, #f4, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #f4, #f4, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #fc, #30
DEFB #38, #38, #38, #38, #3c, #38, #38, #38, #3c, #38, #38, #38, #3c, #38, #3c, #78, #fc, #38, #3c, #38, #38, #30, #38, #38, #30, #30, #70, #f0, #fc, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #a0, #a0, #a0, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #fc, #fc, #fc, #fc, #30
DEFB #30, #34, #34, #34, #34, #34, #34, #34, #30, #34, #34, #34, #34, #34, #34, #34, #f4, #34, #34, #34, #30, #30, #30, #30, #30, #30, #30, #70, #f4, #fc, #a0, #00, #00, #00, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #fc, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #f4, #f4, #fc, #fc, #fc, #fc, #30
DEFB #38, #38, #38, #38, #38, #38, #38, #3c, #38, #38, #38, #3c, #38, #38, #38, #78, #f0, #b0, #38, #38, #30, #30, #30, #30, #30, #30, #30, #70, #f0, #fc, #a8, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #a0, #00, #00, #00, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #fc, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #fc, #a0
DEFB #34, #30, #30, #30, #34, #30, #34, #30, #34, #30, #30, #34, #34, #34, #34, #70, #f4, #b4, #34, #b4, #30, #30, #34, #30, #30, #30, #30, #70, #f4, #f4, #b0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f0, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #f8, #f4, #fc, #fc, #fc, #fc, #30
DEFB #38, #38, #38, #38, #38, #38, #3c, #3c, #38, #3c, #38, #3c, #3c, #3c, #3c, #78, #f8, #78, #78, #78, #78, #78, #f0, #b0, #30, #30, #30, #70, #f8, #fc, #a8, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #f8, #fc, #fc, #f8, #f8, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #f8, #b0
DEFB #b4, #b4, #b4, #b4, #3c, #b4, #b4, #b4, #b4, #b4, #f0, #b4, #b4, #34, #30, #70, #f4, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #70, #f4, #f4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #f4, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #f4, #fc, #fc, #fc, #f8, #30
DEFB #38, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #f0, #f0, #b4, #38, #f0, #78, #f0, #b0, #b0, #30, #38, #30, #70, #f8, #f8, #a0, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #fc, #f8, #f8, #f8, #fc, #f8, #f8, #f8, #f8, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #f8, #b0
DEFB #30, #30, #30, #70, #34, #f0, #b4, #f0, #b4, #f0, #b4, #f0, #b4, #b4, #f0, #70, #f4, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #70, #f0, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #fc, #f0, #f4, #fc, #fc, #fc, #f8, #10
DEFB #f0, #78, #b0, #b0, #38, #30, #38, #30, #30, #30, #30, #30, #30, #30, #30, #70, #f4, #b0, #30, #30, #30, #30, #30, #30, #30, #30, #38, #70, #f8, #f8, #a0, #20, #20, #20, #00, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #fc, #f8, #f8, #f8, #fc, #f8, #fc, #f8, #fc, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #fc, #fc, #fc, #fc, #f8, #b0
DEFB #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #34, #f0, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #70, #f0, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f4, #f4, #f4, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #fc, #f8, #f4, #fc, #fc, #fc, #f8, #30
DEFB #30, #b4, #38, #38, #30, #38, #30, #38, #30, #38, #38, #30, #30, #38, #38, #78, #3c, #38, #38, #38, #38, #38, #30, #30, #30, #30, #30, #70, #f8, #f8, #a0, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #fc, #f8, #f8, #f8, #f8, #fc, #f8, #f8, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #f8, #f0, #fc, #fc, #fc, #b8, #20
DEFB #b4, #b4, #b4, #b4, #b0, #30, #34, #30, #34, #b4, #b4, #b4, #30, #30, #34, #34, #f4, #30, #30, #30, #34, #30, #30, #30, #30, #30, #30, #70, #f4, #f0, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #f4, #f4, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f4, #fc, #f4, #fc, #fc, #fc, #78, #f4, #f0, #f0, #30, #70, #10
DEFB #78, #38, #3c, #38, #3c, #38, #38, #38, #3c, #78, #3c, #3c, #38, #38, #38, #78, #f8, #38, #38, #38, #38, #30, #38, #30, #30, #30, #30, #70, #f8, #f8, #a0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #f8, #f8, #f8, #f8, #f8, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #fc, #f8, #78, #b0, #f4, #b8, #30, #30, #30, #30
DEFB #b4, #b4, #f0, #30, #34, #30, #30, #34, #b0, #b4, #b4, #34, #34, #34, #30, #34, #f0, #34, #30, #30, #30, #30, #30, #30, #30, #30, #30, #70, #f0, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f4, #f4, #f4, #f4, #f4, #fc, #f4, #fc, #7c, #fc, #f0, #f0, #f0, #f0, #30, #30, #30, #30, #54, #b0, #30, #30, #30, #30
DEFB #78, #78, #78, #38, #38, #38, #38, #38, #38, #78, #78, #38, #38, #38, #30, #f0, #f0, #38, #38, #38, #30, #30, #30, #30, #30, #30, #30, #70, #f8, #f8, #a0, #00, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #fc, #fc, #fc, #fc, #fc, #f8, #f8, #78, #f0, #b0, #30, #20, #30, #20, #30, #30, #30, #f4, #b8, #30, #38, #30, #30
DEFB #b4, #b4, #b4, #30, #30, #30, #30, #34, #70, #b4, #34, #30, #34, #30, #30, #70, #f4, #30, #30, #30, #30, #30, #30, #10, #30, #30, #30, #70, #f4, #f0, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #fc, #fc, #f4, #f0, #f0, #f0, #f0, #30, #30, #30, #30, #10, #10, #70, #30, #30, #30, #30, #f4, #b0, #30, #30, #30, #30
DEFB #f0, #78, #78, #38, #38, #38, #38, #34, #78, #78, #78, #38, #38, #38, #38, #f0, #78, #b0, #30, #30, #30, #30, #20, #20, #30, #30, #38, #70, #f8, #f8, #a0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f8, #f8, #f8, #f0, #b0, #30, #f8, #b0, #78, #b0, #30, #20, #30, #f0, #30, #30, #38, #38, #f4, #b8, #b0, #30, #30, #30
DEFB #f0, #b4, #f0, #30, #30, #34, #30, #74, #70, #b4, #f0, #30, #30, #30, #10, #70, #f0, #30, #30, #30, #30, #30, #30, #10, #30, #30, #30, #70, #f0, #f0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f4, #f4, #f4, #f0, #f4, #70, #30, #30, #74, #30, #30, #30, #74, #10, #30, #30, #30, #54, #b0, #30, #30, #30, #30
DEFB #f8, #78, #78, #38, #30, #70, #30, #3c, #30, #3c, #38, #38, #b0, #b0, #f0, #f0, #78, #b0, #b0, #b0, #b0, #b0, #b0, #20, #30, #30, #30, #70, #f8, #f8, #a0, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #fc, #f8, #f8, #f8, #f8, #f8, #38, #38, #38, #38, #30, #30, #f4, #30, #38, #30, #38, #f4, #b8, #b0, #30, #30, #30
DEFB #bc, #f0, #b4, #30, #30, #70, #70, #34, #50, #b4, #f0, #b0, #70, #30, #70, #70, #f4, #f0, #70, #50, #f0, #f0, #70, #30, #30, #30, #30, #34, #f0, #f0, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #70, #f4, #f4, #f0, #f4, #f4, #38, #34, #30, #78, #30, #30, #74, #30, #30, #30, #30, #f4, #b0, #70, #70, #30, #30
DEFB #f8, #78, #78, #38, #38, #b0, #b0, #f0, #70, #3c, #78, #38, #f0, #f0, #f0, #f8, #78, #f8, #fc, #f8, #f8, #f8, #f0, #b0, #30, #30, #38, #78, #f8, #f8, #a0, #20, #00, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #20, #b8, #b0, #b0, #f8, #f8, #f8, #b0, #38, #38, #38, #30, #30, #f4, #b0, #30, #b0, #b0, #f4, #b8, #f0, #f0, #b0, #30
DEFB #70, #b4, #f0, #b4, #70, #70, #70, #74, #70, #b4, #f0, #70, #f4, #f4, #f4, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f0, #30, #30, #30, #30, #34, #f0, #f4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #30, #20, #10, #70, #f0, #70, #b0, #30, #74, #30, #30, #30, #74, #30, #30, #30, #30, #54, #f0, #70, #70, #b0, #30
DEFB #f0, #78, #78, #78, #78, #f8, #f8, #78, #f8, #3c, #78, #bc, #fc, #fc, #fc, #f8, #f0, #f8, #f8, #f0, #b0, #b0, #30, #30, #30, #30, #30, #78, #f8, #f8, #a0, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #30, #b0, #30, #30, #38, #30, #b8, #38, #7c, #30, #30, #30, #f4, #b0, #b0, #b0, #b0, #f4, #f8, #f0, #f0, #b8, #30
DEFB #74, #7c, #f4, #7c, #f0, #f4, #f4, #f4, #f4, #7c, #b4, #f0, #f4, #f0, #f0, #70, #f4, #70, #70, #30, #30, #00, #10, #30, #30, #30, #30, #70, #b4, #f0, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #30, #30, #10, #30, #b0, #30, #3c, #34, #74, #30, #30, #70, #74, #30, #30, #30, #70, #f4, #f0, #f0, #f0, #b0, #30
DEFB #f0, #f0, #78, #f8, #b0, #f0, #f8, #f0, #f0, #b0, #b0, #30, #b0, #b0, #b0, #70, #f8, #b0, #30, #20, #20, #30, #30, #30, #30, #30, #38, #30, #b0, #30, #20, #20, #20, #20, #20, #00, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #30, #30, #30, #b0, #b0, #b0, #38, #38, #78, #30, #b0, #30, #f4, #b0, #b0, #b0, #30, #f4, #f8, #f8, #f8, #b8, #30
DEFB #70, #10, #30, #30, #70, #f0, #30, #70, #10, #10, #10, #70, #b0, #30, #30, #50, #f0, #30, #20, #10, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #70, #70, #34, #70, #b0, #b0, #34, #30, #34, #30, #30, #30, #74, #30, #30, #30, #30, #70, #f0, #f0, #f4, #b0, #30
DEFB #b0, #b0, #b0, #b0, #b0, #f0, #30, #70, #b0, #b0, #b0, #f0, #a0, #30, #30, #70, #f0, #b0, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #20, #20, #20, #00, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #b0, #38, #30, #38, #78, #f8, #38, #38, #78, #30, #b0, #30, #f4, #30, #b0, #b0, #f0, #f0, #f0, #f0, #f8, #b8, #30
DEFB #50, #70, #70, #30, #30, #70, #10, #50, #70, #30, #10, #30, #30, #30, #30, #70, #f0, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #20, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #30, #30, #30, #30, #34, #f4, #34, #34, #f0, #70, #30, #30, #74, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #30
DEFB #70, #30, #30, #30, #20, #70, #20, #70, #30, #20, #20, #30, #30, #30, #30, #70, #f0, #b0, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #20, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #b0, #38, #30, #30, #30, #78, #78, #78, #f8, #f0, #78, #f0, #f8, #f8, #b0, #b0, #f0, #f8, #f0, #f8, #f8, #f8, #38
DEFB #30, #30, #30, #30, #30, #50, #10, #70, #30, #30, #30, #30, #30, #30, #30, #70, #f0, #30, #30, #10, #30, #30, #30, #30, #30, #30, #30, #30, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #30, #30, #30, #30, #30, #30, #30, #70, #70, #70, #f0, #f0, #f4, #f0, #f0, #f0, #70, #70, #f0, #f0, #f0, #b0, #30
DEFB #30, #30, #30, #30, #30, #70, #30, #70, #30, #30, #30, #30, #70, #30, #20, #70, #f0, #a0, #30, #30, #30, #30, #30, #30, #30, #30, #30, #30, #f0, #a0, #20, #00, #00, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #b0, #38, #30, #30, #30, #70, #b0, #b0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f8, #f8, #f0, #f0, #f0, #f8, #b0, #38
DEFB #70, #30, #30, #30, #30, #70, #30, #70, #30, #30, #30, #30, #70, #30, #10, #70, #f4, #30, #30, #30, #30, #10, #30, #30, #30, #30, #30, #30, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #70, #b0, #30, #30, #30, #70, #70, #f0, #70, #f0, #f0, #f0, #f0, #f4, #f4, #f4, #f4, #f4, #f0, #f0, #f0, #b0, #30
DEFB #30, #30, #30, #30, #30, #30, #30, #70, #30, #30, #30, #30, #70, #30, #30, #70, #f0, #b0, #f0, #f0, #f8, #f0, #f0, #b0, #b0, #30, #30, #30, #b0, #b0, #20, #00, #00, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #38, #30, #30, #30, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #b0, #30
DEFB #70, #30, #30, #30, #30, #30, #30, #70, #30, #30, #30, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f4, #f0, #f0, #f0, #70, #30, #30, #30, #30, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #34, #30, #30, #30, #34, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #30
DEFB #30, #30, #30, #30, #30, #30, #b0, #f0, #30, #b0, #f0, #f0, #f0, #f8, #f8, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #b0, #b0, #30, #30, #30, #20, #30, #20, #00, #00, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #b0, #30, #30, #30, #78, #f0, #f0, #f8, #f8, #f8, #f0, #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f0, #f8, #b8, #20
DEFB #70, #30, #70, #70, #f0, #70, #f0, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f4, #f0, #f0, #f0, #70, #30, #30, #30, #30, #30, #30, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #70, #30, #30, #30, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #00
DEFB #f0, #b0, #f0, #f0, #f8, #f0, #f0, #f0, #30, #b0, #f0, #f0, #f0, #f8, #f8, #f8, #f0, #f8, #f0, #f0, #f8, #f0, #f0, #b0, #b0, #30, #30, #30, #30, #20, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #b0, #30, #30, #38, #30, #f0, #f0, #f8, #f0, #f8, #f8, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #b8, #20
DEFB #70, #30, #30, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #50, #f0, #70, #70, #70, #30, #30, #30, #30, #30, #30, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #70, #30, #30, #30, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #f0, #b0, #10
DEFB #30, #b0, #b0, #b0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f8, #f8, #f0, #f8, #f0, #f0, #f0, #f0, #b0, #b0, #30, #30, #30, #30, #30, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #b0, #b0, #30, #30, #f0, #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f8, #f8, #f0, #f0, #f0, #f0, #f0, #f0, #a0, #30
DEFB #70, #30, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #30, #30, #30, #30, #30, #30, #20, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #70, #f0, #f0, #34, #b0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #30
DEFB #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f8, #f8, #f8, #f8, #f0, #f8, #f8, #f8, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #b0, #b0, #b0, #30, #30, #30, #30, #20, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #78, #f0, #f0, #38, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f8, #f8, #f0, #f8, #f8, #f8, #f0, #f8, #f0, #f8, #30
DEFB #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #50, #f0, #70, #70, #70, #70, #70, #70, #30, #30, #30, #30, #10, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f0, #70, #70, #f0, #f4, #f0, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #30
DEFB #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f0, #b0, #f0, #b0, #b0, #b0, #b0, #30, #b0, #30, #30, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #b0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #b0
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #70, #70, #70, #70, #30, #70, #30, #30, #30, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #70, #f0, #70, #70, #70, #f0, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f8, #f8, #f8, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #b0, #b0, #b0, #b0, #b0, #b0, #a0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #b0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f8, #f8, #38
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #30, #70, #70, #70, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #30, #f4, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f0, #f8, #f0, #f8, #f8, #f8, #f8, #78, #78, #78, #f0, #78, #f0, #78, #f0, #78, #f0, #78, #f0, #f0, #f0, #78, #b0, #f0, #b0, #f0, #b0, #b0, #b0, #b0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #38
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #70, #f0, #f0, #70, #70, #70, #70, #70, #30, #70, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #70, #70, #70, #70, #70, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #b0
DEFB #f8, #f8, #f8, #f0, #f8, #f0, #f8, #78, #78, #78, #78, #78, #78, #78, #78, #b0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #b0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #38
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #70, #70, #70, #70, #f0, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #30, #70, #70, #70, #70, #70, #f0, #f0, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #b0, #b0, #b0, #f0, #78, #78, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #b0, #a0, #20, #00, #00, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f0, #f0, #38
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #70, #f0, #f0, #f0, #70, #70, #f0, #f0, #b4, #f0, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #20, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #b0
DEFB #78, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #f0, #f0, #78, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #b0, #b0, #b0, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f8, #f0, #78, #f0, #f8, #f0, #f8, #f8, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #38
DEFB #70, #70, #70, #f0, #70, #f0, #70, #f0, #70, #f0, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #f0, #70, #f0, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #00, #10, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #b0, #20, #20, #00, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #f0, #b0, #b0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f0, #f0, #f8, #f0, #f8, #f8, #f8, #f0, #f0, #f0, #f0, #f0, #38
DEFB #70, #70, #70, #70, #f0, #70, #70, #70, #f0, #70, #f0, #70, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #34, #f0, #f0, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #a0, #20, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f8, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f0, #f8, #f8, #f8, #f0, #78, #f0, #f8, #38
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #30, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f0, #f0, #70, #f0, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #b0
DEFB #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #b0, #b0, #b0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #38
DEFB #70, #70, #f0, #70, #70, #70, #f0, #70, #70, #70, #f0, #70, #f0, #f0, #f0, #70, #f0, #70, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #a0, #20, #20, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f0, #f0, #f8, #78, #78, #f0, #78, #f0, #78, #f0, #f8, #f0, #f8, #f0, #78, #f0, #f0, #f0, #f8, #f0, #f8, #f0, #f8, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #f0, #70, #f0, #70, #f0, #70, #f0, #70, #70, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #20, #00, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #00, #50, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
DEFB #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #b0, #f0, #b0, #b0, #b0, #20, #20, #20, #00, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #20, #00, #f0, #f0, #f0, #f0, #78, #f0, #f8, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
DEFB #70, #70, #70, #70, #f0, #70, #f0, #70, #f0, #70, #f0, #70, #f0, #70, #70, #70, #f0, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #50, #50, #10, #50, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
DEFB #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #b0, #f0, #b0, #f0, #b0, #20, #20, #20, #20, #20, #00, #00, #00, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #a0, #00, #a8, #a0, #a0, #a0, #30, #f8, #f0, #78, #78, #f0, #f8, #f0, #f8, #f0, #78, #f0, #78, #f0, #78, #f0, #f8, #f0, #f8, #f0, #78, #f0, #f8, #78
DEFB #70, #70, #70, #70, #70, #70, #70, #f0, #70, #70, #70, #f0, #70, #70, #70, #70, #f0, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #30, #00, #10, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #10, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
DEFB #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #b0, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #a0, #a0, #a0, #00, #00, #00, #00, #00, #10, #f8, #78, #78, #f0, #f8, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #70, #70, #34, #70, #f0, #70, #b4, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #50, #50, #50, #00, #00, #00, #00, #00, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0
DEFB #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #b0, #20, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #a0, #a0, #a0, #a0, #a0, #00, #00, #00, #00, #00, #00, #20, #30, #f0, #f8, #f8, #78, #f0, #f8, #f0, #78, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0
DEFB #70, #70, #70, #70, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #70, #f0, #70, #f0, #70, #f0
DEFB #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #b0, #b0, #a0, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #20, #20, #20, #70, #f8, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #b0, #f0
DEFB #70, #70, #70, #70, #70, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #70, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #50, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #70, #f0, #70, #70, #70
DEFB #b0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #30, #20, #20, #20, #00, #a0, #a8, #a0, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #20, #20, #20, #f0, #f0, #f0, #f0, #78, #78, #78, #78, #f0, #f0, #f8, #f0, #f8, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #20, #00, #00, #00, #50, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #70, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #70, #70, #f0, #70, #70
DEFB #b0, #b0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #b0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #f0, #b0, #f0, #b0, #b0, #f0, #f0, #b0, #a0, #20, #20, #a0, #a0, #a0, #a0, #00, #00, #00, #00, #00, #00, #00, #20, #00, #20, #20, #70, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #70, #f0, #70, #b4, #f0, #f0, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #70, #30, #30, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #10, #f0, #f0, #f0, #70, #70, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #70, #70, #70, #70, #f0, #70
DEFB #b0, #b0, #f0, #f0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #78, #78, #78, #78, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #b0, #20, #20, #20, #00, #00, #00, #00, #00, #00, #00, #20, #20, #20, #20, #70, #f0, #f0, #f0, #f0, #f0, #78, #f0, #78, #78, #78, #78, #78, #f0, #f0, #f0, #78, #f0, #f8, #f8, #f8, #f0, #78, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #f0, #70, #70, #f0, #f0, #f0, #70, #70, #70, #f0, #f0, #f0, #f0, #f0, #70, #70, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #70, #f0, #f0, #70, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #70, #f0, #70, #70, #70, #f0, #70, #70
DEFB #b0, #b0, #f0, #b0, #f0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #f0, #f0, #f0, #f0, #f0, #78, #f0, #f0, #f0, #78, #78, #78, #78, #78, #78, #78, #f0, #b0, #20, #00, #00, #00, #00, #00, #00, #00, #00, #20, #70, #f0, #f0, #f0, #78, #f0, #f0, #f0, #78, #78, #78, #78, #78, #f0, #78, #f0, #f8, #f0, #f0, #f0, #78, #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #70, #f0, #70, #f0, #70, #b4, #70, #f0, #70, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #70, #30, #00, #00, #00, #00, #00, #00, #00, #00, #10, #70, #70, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70
DEFB #b0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #f0, #f0, #78, #78, #78, #f0, #f0, #f0, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #b0, #20, #00, #00, #00, #20, #00, #10, #f0, #f0, #f8, #f0, #f0, #78, #78, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f8, #f0, #f8, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f8, #f0, #f0, #f0, #f0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #20, #00, #00, #00, #00, #10, #70, #70, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #70
DEFB #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #b0, #f0, #f0, #78, #78, #78, #f0, #f0, #78, #78, #78, #78, #78, #78, #f0, #78, #b0, #a0, #20, #20, #30, #b0, #f0, #f0, #f0, #f0, #f0, #78, #f0, #78, #f0, #78, #78, #78, #f0, #78, #78, #78, #78, #78, #f0, #78, #f0, #78, #78, #78, #78, #f0, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #34, #70, #70, #70, #f0, #70, #70, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #70, #30, #10, #10, #50, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #70, #70, #f0, #70
DEFB #b0, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #78, #f0, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #f0, #70, #f0, #f8, #f0, #f0, #f0, #78, #78, #78, #f0, #78, #f0, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #f0, #f0, #78, #78, #78, #78, #78, #78, #f0, #78, #78, #78, #f0, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #f0, #f0, #70, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #70, #f0, #70, #70
DEFB #b0, #b0, #b0, #b0, #b0, #f0, #b0, #f0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #78, #78, #f0, #78, #78, #78, #78, #78, #f0, #78, #78, #f0, #f0, #f8, #f0, #78, #f0, #78, #78, #78, #f0, #78, #78, #78, #78, #78, #f0, #78, #78, #78, #f0, #f0, #f0, #78, #f0, #78, #f0, #78, #f0, #78, #78, #78, #b0, #f0, #f0, #78, #f0, #f0, #f0, #f0, #b0, #b0
DEFB #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #70, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b4, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #70, #f0, #f0, #f0, #70, #f0, #70, #70, #70
DEFB #b0, #b0, #b0, #b0, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #b0, #f0, #f0, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #f0, #78, #78, #78, #78, #78, #78, #78, #78, #78, #78, #f0, #78, #f0, #f0, #f0, #f0, #f0, #f0, #b0

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
