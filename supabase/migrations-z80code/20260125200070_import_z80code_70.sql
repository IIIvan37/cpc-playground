-- Migration: Import z80code projects batch 70
-- Projects 139 to 140
-- Generated: 2026-01-25T21:43:30.203528

-- Project 139: compiled13 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'compiled13',
    'Imported from z80Code. Author: gurneyh. animated and shifted',
    'public',
    false,
    false,
    '2019-12-01T18:17:31.344000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'NUM_SPRITES EQU 20		;  Num of sprites
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
                bit 7, a 
                ld h, a 
                jr z, @end
                ld a, #50
                add l
                ld l, a 
                ld a, #c0
                adc h 
                ld h, a
@end
mend          

macro GET_ADR:
                ld a, (ix)
                ld h, hi(rows)
                ld l, a 
                ld a, (hl)
                inc h 
                ld h, (hl)
                ld l, a 
                inc ixh
                ld a, (ix)
                srl a
                dec ixh
                ld c, a 
                ld b, 0
                add hl, bc
endm
                
                di
                ld hl, #c9fb 
                ld (#38), hl 
                ei
	
                ld hl, traj
                ld (displayAll.index + 2), hl
                dec l: dec l
                ld (clearAll.index + 2), hl

                SET_MODE 0
                
                SET_PALETTE palette, 0, 16      
                
main_loop:
                WAIT_VBL (void)

clearAll:       

.index:         ld ix, traj
                ld e, 2
                ld d, 0
.loop:
repeat NUM_SPRITES / 2
	            GET_ADR (void)     
repeat 8
                ld (hl), d : inc hl 
                ld (hl), d : inc hl
                ld (hl), d : inc hl 
                ld (hl), d : inc hl
                ld (hl), d : inc hl
                ld (hl), d 
                bc26_hl (void)
                ld (hl), d : dec hl 
                ld (hl), d : dec hl
                ld (hl), d : dec hl 
                ld (hl), d : dec hl
                ld (hl), d : dec hl
                ld (hl), d 
                bc26_hl (void)
rend
 
                ld (hl), d : inc hl 
                ld (hl), d : inc hl
                ld (hl), d : inc hl 
                ld (hl), d : inc hl
                ld (hl), d : inc hl
                ld (hl), d 
                bc26_hl (void)
                ld (hl), d : dec hl 
                ld (hl), d : dec hl
                ld (hl), d : dec hl 
                ld (hl), d : dec hl
                ld (hl), d : dec hl
                ld (hl), d 
       
                ld a, ixl
                add (SEP)
                ld ixl, a 
rend
                dec e 
                jp nz, .loop

                ld ix, (.index + 2)
                inc ixl
                ld (.index + 2), ix


displayAll:   
.index:         ld ix, traj                
                ld hl, 8 * NUM_SPRITES * 2
                ld a, (index_star + 1)
                ld i, a
repeat NUM_SPRITES, n
                ld iy, @ret
                

                exx 
    	        GET_ADR (void)
                push hl
                exx
                pop de
                ld h, hi(star_ptr)
                ld a, i
                inc a
                ld i, a
                and 7
                add a, a 
                ld l, a
                
                inc ixh 
                ld a, (ix)
                rra
                jr nc, @ok 
                inc h
@ok:
                ld a, (hl)
                inc l 
                ld h, (hl)
                ld l, a 
                dec ixh
                jp (hl)
                
@ret:           
                ld a, ixl
                add (SEP)
                ld ixl, a
rend
               

                ld ix, (.index + 2)
                inc ixl
                ld (.index + 2), ix

                ld hl, (index_star)
                ld e, #15
                ld d, 0
                add hl, de
                ld a, h 
                and 7
                ld h, a
                ld (index_star), hl

                SET_COLOR 16, #54

switch1:        ld hl, #c030
switch2:        ld de, #c310
                ld (switch1 + 1), de
                ld (switch1 + 4), hl
                ex hl, de
                ld b, hi(GATE_ARRAY)
                out (c), h
                ld bc, #bc0c
                out (c), c
                inc b 
                out (c), l
                dec b 
                inc c 
                xor a 
                out (c), c 
                inc b
                out (c), a
                jp main_loop




align 256 

; traj:
; 	repeat 128,angle
;     x = 38 + 38 * cos(360*angle/128)
;     y = 92 + 92 * sin(2*360*angle/128)
; 	y0 = (y>>3)
;     y1 = (y & 7)
;     dw #4000 + x + (y0*80) + (#800*y1)
;     rend

traj:
    repeat 256, n
        angle = n - 1
        db 92 + 92 * sin(2*360*angle/256)
    rend
     repeat 256, n
        angle = n - 1
        db 75 + 75 * cos(360*angle/256)
    rend

align 256:
rows:
    repeat 200, n
        y = n - 1
        y0 = (y >> 3)
        y1 = (y & 7)
        db lo(#4000  + (y0 * 80) + (y1 * #800))
        
    rend
align 256
      repeat 200, n
        y = n - 1
        y0 = (y >> 3)
        y1 = (y & 7)
        db hi(#4000  + (y0 * 80) + (y1 * #800))
       
    rend
palette:
    db #54, #4b, #4c, #4e, #5c, #5f, #43, #53, #40, #44,#5E,#52,#4E,#4A,#40,#4B

align 256
star_ptr:
repeat 8, i
    dw star_{i - 1}
rend
align 256:
repeat 8, i
    dw star_shifted_{i - 1}
rend

index_star: dw 0


star_0:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #9c
dec hl

bc26_hl (void)
ld (hl), #9c
inc hl
ld (hl), #3c
inc hl
ld (hl), #3c
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #3c
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #6c
inc hl
ld (hl), #cc
inc hl

bc26_hl (void)

dec hl
ld (hl), #9c
dec hl
ld (hl), #98
dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
bc26_hl (void)
ld (hl), #9c
inc hl

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
bc26_hl (void)
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
jp (iy)


star_1:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #9c
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #3c
inc hl
ld (hl), #98
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #34
dec hl

bc26_hl (void)

inc hl
ld (hl), #9c
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #38
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

jp (iy)


star_2:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #3c
inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #9c
dec hl

bc26_hl (void)

inc hl
ld (hl), #64
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

jp (iy)


star_3:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl
ld (hl), #64
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #cc
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #30
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #30
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

dec hl

jp (iy)


star_4:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #64
dec hl

bc26_hl (void)
ld (hl), #30
inc hl
ld (hl), #30
inc hl
ld (hl), #cc
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #64
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #30
inc hl
ld (hl), #cc
inc hl

bc26_hl (void)

dec hl
ld (hl), #64
dec hl
ld (hl), #30
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
bc26_hl (void)
ld (hl), #30
inc hl

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
bc26_hl (void)
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

dec hl

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
jp (iy)


star_5:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #98
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #30
inc hl
ld (hl), #30
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #30
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
bc26_hl (void)

inc hl
ld (hl), #30
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

jp (iy)


star_6:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #cc
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #30
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

jp (iy)


star_7:
ex hl, de

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #9c
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl
ld (hl), #3c
inc hl
ld (hl), #98
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl
ld (hl), #6c
dec hl

bc26_hl (void)

inc hl
ld (hl), #9c
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #38
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

jp (iy)


star_shifted_0:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #6c
dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #3c
inc hl
ld (hl), #3c
inc hl
ld (hl), #6c
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #6c
dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #9c
inc hl
ld (hl), #cc
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl
ld (hl), #64
dec hl
ld (hl), #6c
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl
ld (hl), #6c
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
jp (iy)


star_shifted_1:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #38
dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #9c
inc hl
ld (hl), #6c
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #38
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #6c
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #64
dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl

dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

jp (iy)


star_shifted_2:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl
ld (hl), #3c
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #38
dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #98
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

dec hl

jp (iy)


star_shifted_3:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #9c
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl

inc hl
ld (hl), #cc
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #64
dec hl

dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #64
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #64
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

dec hl

jp (iy)


star_shifted_4:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #cc
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #30
inc hl
ld (hl), #64
inc hl
ld (hl), #cc
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #cc
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #30
inc hl
ld (hl), #64
inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl
ld (hl), #30
dec hl
ld (hl), #30
dec hl

bc26_hl (void)
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

inc hl
ld (hl), #64
inc hl

bc26_hl (void)

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
jp (iy)


star_shifted_5:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #30
dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #30
inc hl
ld (hl), #30
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #30
dec hl
ld (hl), #30
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl
ld (hl), #30
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
inc hl

inc hl

inc hl

bc26_hl (void)

dec hl

dec hl

dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

jp (iy)


star_shifted_6:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #98
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #30
dec hl
ld a, (hl) : and #aa : or #10 : ld (hl), a
dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
dec hl

dec hl

jp (iy)


star_shifted_7:
ex hl, de

inc hl

inc hl
ld a, (hl) : and #55 : or #88 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
dec hl

dec hl

bc26_hl (void)

inc hl

inc hl
ld a, (hl) : and #55 : or #28 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #38
dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld (hl), #3c
inc hl
ld (hl), #6c
inc hl
ld a, (hl) : and #55 : or #20 : ld (hl), a
inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #98
dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl
ld (hl), #38
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld (hl), #64
dec hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
dec hl

bc26_hl (void)

inc hl
ld a, (hl) : and #aa : or #14 : ld (hl), a
inc hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
inc hl

inc hl

bc26_hl (void)

dec hl

dec hl
ld a, (hl) : and #aa : or #44 : ld (hl), a
dec hl

dec hl

jp (iy)













print {hex}$
limit #4000
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: sprites-compils
  SELECT id INTO tag_uuid FROM tags WHERE name = 'sprites-compils';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 140: labels_proximity by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'labels_proximity',
    'Imported from z80Code. Author: Unknown. Proximity labels',
    'public',
    false,
    false,
    '2019-09-21T22:47:14.261000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ' call Raster.update

lp:
 call Raster.update.test
 jr lp

Raster.update: 
 ld bc,#7f10
 out (c),c
.test
 ld a,r
 and 31
 or 64
 out (c),a
 ret

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
