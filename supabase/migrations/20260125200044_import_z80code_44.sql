-- Migration: Import z80code projects batch 44
-- Projects 87 to 88
-- Generated: 2026-01-25T21:43:30.196196

-- Project 87: fucked-scroll by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fucked-scroll',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2023-01-05T20:12:27.325000'::timestamptz,
    '2023-01-06T20:09:05.824000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Does not work with the present emulator. (fixed ...)

; Normally ok on a real cpc and winape (search for "!!! WARNING" in this source code)



; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------


;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00
CRTC_READ           equ #BF00


; ---------------------------------------------------------------------------
; WRITE_CRTC
MACRO WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
ENDM

; WRITE_CRTC reg a
MACRO WRITE_CRTC_a, reg
                ld bc, CRTC_SELECT + {reg}
                out (c), c
                inc b
                out (c), a
ENDM




; ------------------------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; ------------------------------------------------------------------------------
; Registers
PENR:           equ %00000000
INKR:           equ %01000000
RMR:            equ %10000000

; ------------------------------------------------------------------------------
; RAM Banking
; -Address-     0      1      2      3      4      5      6      7
; 0000-3FFF   RAM_0  RAM_0  RAM_4  RAM_0  RAM_0  RAM_0  RAM_0  RAM_0
; 4000-7FFF   RAM_1  RAM_1  RAM_5  RAM_3  RAM_4  RAM_5  RAM_6  RAM_7
; 8000-BFFF   RAM_2  RAM_2  RAM_6  RAM_2  RAM_2  RAM_2  RAM_2  RAM_2
; C000-FFFF   RAM_3  RAM_7  RAM_7  RAM_7  RAM_3  RAM_3  RAM_3  RAM_3
RAM_P0          equ #0000
RAM_P1          equ #4000
RAM_P2          equ #8000
RAM_P3          equ #c000

; ------------------------------------------------------------------------------
; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF
Color:
.fm_0:          equ #54
.fm_1:          equ #44
.fm_2:          equ #55
.fm_3:          equ #5C
.fm_4:          equ #58
.fm_5:          equ #5d
.fm_6:          equ #4C
.fm_7:          equ #45
.fm_8:          equ #4d
.fm_9:          equ #56
.fm_10:         equ #46         
.fm_11:         equ #57
.fm_12:         equ #5e
.fm_13:         equ #40
.fm_14:         equ #5f
.fm_15:         equ #4e
.fm_16:         equ #47
.fm_17:         equ #4f
.fm_18:         equ #52
.fm_19:         equ #42
.fm_20:         equ #53
.fm_21:         equ #5A
.fm_22:         equ #59
.fm_23:         equ #5b
.fm_24:         equ #4a
.fm_25:         equ #43
.fm_26:         equ #4B



macro SET_COLOR pen, ink
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                ld c, {ink}
                out (c), c
endm

macro SET_COLOR_a pen
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                out (c), a
endm


macro SET_BORDER ink 
                SET_COLOR #10, {ink}
endm

macro SET_MODE mode 
                LD bc, GATE_ARRAY | RMR | ROM_OFF | {mode}
                out (c), c
               
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

macro WAIT_LINE n
                ld b, {n}
@loop:          ds 60
                djnz @loop
endm

;;
;; DE = DE + A
;;
macro ADD_____DE_A                    ;; 5c

                add             a, e
                ld              e, a
                jr              nc, $ + 3
                inc             d
endm


R1              equ 48
R2              equ 50
R3              equ 6
CHARSET         '' ABCDEFGHIJKLMNOPQRSTUVWXYZ'', 0

                org #40
              
start
                WRITE_CRTC 7, 30 + 5
                call init

main_loop
                ld b, #f5
.ws             halt
                in a, (c)
                rra
                jr nc, .ws

                di

                WRITE_CRTC 7, #ff
                WAIT_LINE 4 * 8 - 3
                ds 14; !!! WARNING only for tiny cpc 26 otherwise

                ld hl, #0400                    ; [3]
                ld de, #0901                    ; [6]
                ld b, hi(CRTC_SELECT)           ; [8]
                out (c), h                      ; [12]
                inc b                           ; [13]
                out (c), l                      ; [17]
                dec b                           ; [18]
                out (c), d                      ; [22]
                inc b                           ; [23]
                out (c), e                      ; [27]
                WRITE_CRTC 6, 1

                ld bc, #7f01
.ptr_colors     ld de, colors + 128
.ptr_copper     ld hl, copper
                exx
.ptr_screen     ld hl, screen_adr
                ld bc, #bc0c
                exx
                ld ixh, 128
.row_loop       
                call set_copper                 ; [5] + [100]
                ds 128 - 105 - 5
                dec ixh
                jr nz, .row_loop

                WRITE_CRTC 4, 7 - 1
                WRITE_CRTC 9, 7
                WRITE_CRTC 7, 7 - 4
                WRITE_CRTC 6, 0
                ei
                call update_last_row
                ld hl, (.ptr_copper + 1)
                inc l
                ld (.ptr_copper + 1), hl
                ld hl, (.ptr_screen + 1)
                dec l
                ld (.ptr_screen + 1), hl
.ptr_sin         ld hl, sin_table
                ld a, (hl)
                ld (set_copper.delta_color + 1), a
                xor a
                ld (set_copper.color_accu + 1), a
                inc l
                ld (.ptr_sin + 1), hl
                ld hl, (.ptr_colors + 1)
                inc l
                ld (.ptr_colors + 1), hl
                jp main_loop

update_last_row

.ptr_row        ld de, font
.accu:          ld a, 7
                inc a
                and 7
                ld (.accu + 1), a
                jr nz, .skip
.row            ld a, 5
                inc a
                cp 6
                jr z, .new_char
.save_row       inc e : inc e : inc e        ; next row in current char
                ld (.ptr_row + 1), de
                ld (.row + 1), a
                jr .skip
.new_char
                xor a
                ld (.row + 1), a
.ptr_char       ld hl, msg_end
                ld a, (hl)
                bit 7, a
                jr z, .no_loop
                ld hl, msg
                ld a, (hl)
.no_loop        inc hl
                ld (.ptr_char + 1), hl
                ; char * 32
                ld l, a : ld h, 0
                add hl, hl : add hl, hl
                add hl, hl : add hl, hl
                add hl, hl                      
                
                ld de, font
                add hl, de
                ld (.ptr_row + 1), hl
                ex hl, de
.skip
                ld hl, (main_loop.ptr_copper + 1)
                ld a, (de) : inc e
                ld (hl), a : inc h
                ld a, (de) : inc e
                ld (hl), a : inc h
                ld a, (de)
                ld (hl), a
                ret


init


                di
                ld hl, #c9fb
                ld (#38), hl
                ei
                
                WRITE_CRTC 1, R1
                WRITE_CRTC 2, R2
                WRITE_CRTC 3, R3
                SET_COLOR 0, Color.fm_0
                SET_BORDER Color.fm_0
                SET_MODE 1

               
                ld de, #4000 + 36
                ld hl, cscroll_bg
                call gen_bg
                ld de, #8000 + 36
                call gen_bg
                ld de, #c000 + 36
                call gen_bg
                ret


gen_bg:
                ld bc, 21 * #100 + #ff
.loop1           
                push hl
                push de
repeat 24
                ldi
rend
                pop de
                pop hl
                push de
                ld a, d
                add 8
                ld d, a
                ld c, #ff
repeat 24
                ldi
rend
                pop de
                ld a, 96
                ADD_____DE_A (void)
                dec b
                jp nz, .loop1

                ret



set_copper


repeat 2
                out (c), c      ; on sélectionne l''encre
                ld a, (de)      ; on la couleur de la ligne
                and (hl) : inc h      ; and masque, passage au masque suivant          
                xor Color.fm_0        ; xor #54          
                out (c), a            ; ob valide la couleur                          
                inc c                 ; on passe à l''encre suivante          
rend
                out (c), c
                ld a, (de)
                and (hl)
                xor Color.fm_0
                out (c), a
                dec c : dec c
                dec h : dec h
                inc l
.color_accu:    ld a, 0
.delta_color:   add 0
                ld (.color_accu + 1), a
                ld a, 0
                adc e
                ld e, a

                exx
                out (c), c
                inc b
                ld a, (hl): inc h
                out (c), a
                dec b : inc c
                out (c), c
                inc b
                ld a, (hl)
                out (c), a
                dec h
                dec b : dec c

.delta:         ld a, 3
                add l
                ld l, a
                exx
                ret             ;[100]


align 256
copper
                ; column 1
                ds 256, #00
                ; column 2
                ds 256, #00
                ; column 3
                ds 256, #00

screen_adr
repeat 256, i
ii = i - 1
v = 32 + floor(30  * sin(ii / 256 * 360))
base = #1000 * (floor(v / 21) + 1)
db hi(base | ((v  % 21) * R1))
rend
repeat 256, i
ii = i - 1
v = 32 + floor(30 * sin(ii / 256 * 360))
base = #1000 * (floor(v / 21) + 1)

db lo(base | ((v  % 21) * R1))
rend

sin_table
repeat 256, i
ii = i - 1
db 128 + floor(127 * sin(ii / 256 * 360))
rend


macro c_000           
                db #00, #00, #00
endm
macro c_001           
                db #00, #00, #FF
endm
macro c_010           
                db #00, #FF, #00
endm
macro c_011           
                db #00, #FF, #FF
endm
macro c_111         
                db #FF, #FF, #FF
endm
macro c_110           
                db #FF, #FF, #00
endm
macro c_101           
                db #FF, #00, #FF
endm
macro c_100           
                db #FF, #00, #00
endm

macro make_chr r1, r2, r3, r4, r5
c_{r1} (void)
c_{r2} (void)
c_{r3} (void)
c_{r4} (void)
c_{r5} (void)
c_000 (void)
ds 14
endm

align 32
font
make_chr 000, 000, 000, 000, 000                ; 
make_chr 111, 101, 111, 101, 101                ; A
make_chr 110, 101, 110, 101, 110                ; B
make_chr 011, 100, 100, 100, 011                ; C
make_chr 110, 101, 101, 101, 110                ; D
make_chr 111, 100, 111, 100, 111                ; E
make_chr 111, 100, 111, 100, 100                ; F
make_chr 011, 100, 101, 101, 011                ; G
make_chr 101, 101, 111, 101, 101                ; H
make_chr 111, 010, 010, 010, 111                ; I
make_chr 001, 001, 001, 101, 111                ; J
make_chr 101, 101, 110, 101, 101                ; K
make_chr 100, 100, 100, 100, 111                ; L
make_chr 101, 111, 101, 101, 101                ; M
make_chr 111, 101, 101, 101, 101                ; N
make_chr 111, 101, 101, 101, 111                ; O
make_chr 111, 101, 111, 100, 100                ; P
make_chr 111, 110, 110, 110, 111                ; Q
make_chr 110, 101, 110, 101, 101                ; R
make_chr 011, 100, 010, 001, 110                ; S
make_chr 111, 010, 010, 010, 010                ; T
make_chr 101, 101, 101, 101, 111                ; U
make_chr 101, 101, 101, 101, 110                ; V
make_chr 101, 101, 101, 111, 101                ; W
make_chr 101, 101, 010, 101, 101                ; X
make_chr 101, 101, 111, 010, 010                ; Y
make_chr 111, 001, 010, 100, 111                ; Z

align 256
colors
repeat 32
db Color.fm_3 xor Color.fm_0
rend
repeat 16
db Color.fm_6 xor Color.fm_0
rend
repeat 16
db Color.fm_15 xor Color.fm_0
rend
repeat 16
db Color.fm_16 xor Color.fm_0
rend
repeat 16
db Color.fm_24 xor Color.fm_0
rend
repeat 16
db Color.fm_25 xor Color.fm_0
rend
repeat 48
db Color.fm_26 xor Color.fm_0
rend
repeat 16
db Color.fm_23 xor Color.fm_0
rend
repeat 16
db Color.fm_22 xor Color.fm_0
rend
repeat 16
db Color.fm_19 xor Color.fm_0
rend
repeat 16
db Color.fm_18 xor Color.fm_0
rend
repeat 32
db Color.fm_9 xor Color.fm_0
rend

msg:
                db ''HELLO WORLD     ''
msg_end         db #ff


;; Data created with Img2CPC - (c) Retroworks - 2007-2017
;; Tile cscroll_bg - 96x63 pixels, 24x63 bytes.
cscroll_bg:
DEFB #f0, #f0, #f0, #f0, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #ff
DEFB #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #ee
DEFB #70, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #cc
DEFB #30, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #cc
DEFB #10, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #88
DEFB #00, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #ff, #ff, #00
DEFB #00, #f0, #f0, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ff, #ff, #ee, #00
DEFB #00, #70, #f0, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ff, #ff, #ee, #00
DEFB #00, #30, #f0, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ff, #ff, #cc, #00
DEFB #00, #10, #f0, #f0, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ff, #ff, #88, #00
DEFB #00, #10, #f0, #f0, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #ff, #ff, #00, #00
DEFB #00, #00, #f0, #f0, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #ff, #ff, #00, #00
DEFB #00, #00, #70, #f0, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #ff, #ee, #00, #00
DEFB #00, #00, #30, #f0, #f0, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #ff, #cc, #00, #00
DEFB #00, #00, #30, #f0, #f0, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ff, #88, #00, #00
DEFB #00, #00, #10, #f0, #f0, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ff, #88, #00, #00
DEFB #00, #00, #00, #f0, #f0, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ff, #00, #00, #00
DEFB #00, #00, #00, #70, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #ff, #ee, #00, #00, #00
DEFB #00, #00, #00, #70, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #cc, #00, #00, #00
DEFB #00, #00, #00, #30, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #cc, #00, #00, #00
DEFB #00, #00, #00, #10, #f0, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #88, #00, #00, #00
DEFB #00, #00, #00, #00, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ff, #ff, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #f0, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ee, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #70, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #ee, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #f0, #f0, #f0, #f0, #87, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #cc, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #3f, #ff, #ff, #ff, #ff, #88, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #f0, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ff, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #70, #f0, #f0, #f0, #c3, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #ee, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #7f, #ff, #ff, #ff, #cc, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #88, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #88, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #f0, #f0, #f0, #e1, #0f, #0f, #0f, #0f, #ff, #ff, #ff, #ff, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #f0, #f0, #f0, #f0, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #ee, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #70, #f0, #f0, #f0, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #cc, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #f0, #f0, #f0, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #88, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #10, #f0, #f0, #f0, #0f, #0f, #0f, #1f, #ff, #ff, #ff, #88, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #10, #f0, #f0, #f0, #87, #0f, #0f, #3f, #ff, #ff, #ff, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #f0, #87, #0f, #0f, #3f, #ff, #ff, #ee, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #70, #f0, #f0, #87, #0f, #0f, #3f, #ff, #ff, #cc, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #30, #f0, #f0, #87, #0f, #0f, #3f, #ff, #ff, #cc, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #30, #f0, #f0, #c3, #0f, #0f, #7f, #ff, #ff, #88, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #10, #f0, #f0, #c3, #0f, #0f, #7f, #ff, #ff, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #c3, #0f, #0f, #7f, #ff, #ee, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #70, #f0, #c3, #0f, #0f, #7f, #ff, #ee, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #70, #f0, #e1, #0f, #0f, #ff, #ff, #cc, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #30, #f0, #e1, #0f, #0f, #ff, #ff, #88, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #e1, #0f, #0f, #ff, #ff, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #e1, #0f, #0f, #ff, #ff, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #f0, #0f, #1f, #ff, #ee, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #f0, #0f, #1f, #ff, #cc, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #f0, #0f, #1f, #ff, #88, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #0f, #1f, #ff, #88, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #f0, #87, #3f, #ff, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #f0, #87, #3f, #ee, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #70, #87, #3f, #cc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #87, #3f, #cc, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #30, #c3, #7f, #88, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #10, #c3, #7f, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #c3, #6e, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #43, #6e, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #41, #44, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #21, #88, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

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

-- Project 88: fugitif_legacy_music by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fugitif_legacy_music',
    'Imported from z80Code. Author: fma. Legacy code of Fugitif music',
    'public',
    false,
    false,
    '2021-11-01T18:45:36.685000'::timestamptz,
    '2021-11-02T11:20:54.519000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Fugitif
;
; Code original de la musique.
;
; Frédéric

;NOLIST
;SETCRTC 0
BUILDSNA
BANKSET 0
ORG #7df0
run start

NOP_    EQU 0

start
PRINT "start:",{hex}start
        ; Restore firmware in RAM
        LD   SP,#c000

        ; Select lower ROM
        LD   BC,#7f80 | %1001
        OUT  (C),C

        EXX
        XOR A
        EX   AF,AF''

        CALL #0044                  ; Restore #00-#40 and
        CALL #08bd                  ; Restore vectors

        ; Other calls made by the ROM
        CALL #1b5c
        CALL #1fe9
        CALL #0abf
        CALL #1074
        CALL #15a8
        CALL #24bc
        CALL #07e0

        ; Back to RAM
        LD   BC,#7f80 | %1101
        OUT  (C),C

        CALL music
        JR   $

ORG #7f11
music
PRINT "music:",{hex}music
        ; Init sound manager
        CALL #bca7

        ; Init tables addresses
        XOR  A
        LD   (endFlagA),A
        LD   (endFlagB),A
        LD   (endFlagC),A
        LD   HL,initTablesAdd
        LD   DE,startChanA
        LD   BC,12
        LDIR

        ; Init pointers
        LD   HL,(startChanA)
        LD   (curChanA),HL
        LD   HL,(startChanB)
        LD   (curChanB),HL
        LD   HL,(startChanC)
        LD   (curChanC),HL

        ; Load envelopes table
        LD   HL,envelopesTable
        LD   A,#01                  ; first envelope
        LD   B,#08                  ; nb envelopes to set
.loop
        PUSH AF
        PUSH BC
        CALL #bcbc                  ; set amplitude envelope
        POP  BC
        POP  AF
        INC  A
        DJNZ .loop

        ; Add music interrupt callback
        LD   DE,callback            ; interrupt callback address
        LD   HL,interruptBloc       ; interrupt bloc address
        LD   B,#81                  ; event class (RAM, immediate exec)
        LD   C,#00                  ; ROM selection
        CALL #bcd7                  ; init and put an interrupt bloc on frame flyback

        RET


; -----------------------------------------
; Interrupt bloc for music callback
interruptBloc
PRINT "interruptBloc:",{hex}interruptBloc
        DEFS 9,NOP_
; -----------------------------------------

; -----------------------------------------
; ???
        DEFS 21,NOP_
; -----------------------------------------

; -----------------------------------------
; Callback for playing music
callback
PRINT "callback:",{hex}callback
        DI
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
        PUSH IX
        PUSH IY

        LD   HL,(curChanA)
        LD   A,(HL)
        CP   #ff
        JR   Z,.next1
        CALL addNote
        LD   (curChanA),HL
        JR   .next2
.next1
        LD   A,#ff
        LD   (endFlagA),A
.next2
        LD   HL,(curChanB)
        LD   A,(HL)
        CP   #ff
        JR   Z,.next3
        CALL addNote
        LD   (curChanB),HL
        JR   .next4
.next3
        LD   A,#ff
        LD   (endFlagB),A
.next4
        LD   HL,(curChanC)
        LD   A,(HL)
        CP   #ff
        JR   Z,.next5
        CALL addNote
        LD   (curChanC),HL
        JR   .next6
.next5
        LD   A,#ff
        LD   (endFlagC),A
.next6
        ; Check if all channels reached end of data...
        LD   A,(endFlagA)
        CP   #ff
        JR   NZ,.end
        LD   A,(endFlagB)
        CP   #ff
        JR   NZ,.end
        LD   A,(endFlagC)
        CP   #ff
        JR   NZ,.end

        ; ...if yes, load loop adresses...
        LD   HL,(loopChanA)
        LD   (curChanA),HL
        LD   HL,(loopChanB)
        LD   (curChanB),HL
        LD   HL,(loopChanC)
        LD   (curChanC),HL

        ; ...and reset end data flags
        XOR  A
        LD   (endFlagA),A
        LD   (endFlagB),A
        LD   (endFlagC),A
.end
        POP  IY
        POP  IX
        POP  HL
        POP  DE
        POP  BC
        POP  AF
        EI

        RET
; -----------------------------------------

; -----------------------------------------
; Add sound to queue if there are free slots
; (HL) contains the channel to manage
addNote
        PUSH HL
        PUSH HL
        LD   A,(HL)                 ; check space in sound queue
        CALL #bcad
        AND  #07
        CP   #00
        POP  HL
        JR   Z,.next                ; jump if no free slots in queue
        CALL #bcaa                  ; add sound to queue
        POP  HL
        LD   BC,9
        ADD  HL,BC                  ; next data

        RET

.next
        POP  HL

        RET
; -----------------------------------------

; -----------------------------------------
; Stop music
stopMusic
        DI
        LD   HL,interruptBloc
        CALL #bcdd                  ; remove interrupt callback for music
        EI
        CALL #bca7                  ; init (reset?) sound manager
        RET
; -----------------------------------------

tables
PRINT "tables:",{hex}tables
; -----------------------------------------
; Music tables/storage
;
; Music management storage
curChanA    DEFW #0000              ; current sound table address for channel A
curChanB    DEFW #0000              ; current sound table address for channel B
curChanC    DEFW #0000              ; current sound table address for channel C

; End of data flags
endFlagA    DEFB #00
endFlagB    DEFB #00
endFlagC    DEFB #00

; Addresses for start
startChanA  DEFW #0000
startChanB  DEFW #0000
startChanC  DEFW #0000

; Addresses for loop
loopChanA   DEFW #0000
loopChanB   DEFW #0000
loopChanC   DEFW #0000

; Envelopes table
envelopesTable
        DEFB #01,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #02,#01,#05,#01,#0f,#ff,#1e,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #03,#01,#05,#01,#0f,#ff,#0c,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #04,#01,#05,#01,#0f,#ff,#06,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #05,#01,#05,#01,#0f,#ff,#04,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #06,#01,#05,#01,#0f,#ff,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #07,#0c,#ff,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
        DEFB #08,#0c,#ff,#03,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00

endCode
PRINT "endCode:",{hex}endCode


ORG #6000
data
PRINT "data:",{hex}data
; Music sound tables address
initTablesAdd
        DEFW startDataA
        DEFW startDataB
        DEFW startDataC
        DEFW loopDataA
        DEFW loopDataB
        DEFW loopDataC

; Music sound table for channel A
startDataA
        DEFB #31,#00,#00,#00,#00,#00,#00,#c8,#00
        DEFB #31,#00,#00,#00,#00,#00,#00,#c8,#00
        DEFB #31,#00,#00,#00,#00,#00,#00,#c8,#00
        DEFB #31,#00,#00,#00,#00,#00,#00,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #31,#04,#00,#47,#00,#00,#08,#26,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #31,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#03,#00,#47,#00,#00,#08,#4b,#00
loopDataA
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#47,#00,#00,#08,#32,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#3c,#00,#00,#08,#0d,#00
        DEFB #01,#04,#00,#64,#00,#00,#08,#26,#00
        DEFB #31,#05,#00,#6a,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#6a,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#54,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#54,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#43,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#59,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#50,#00,#00,#08,#0d,#00
        DEFB #01,#06,#00,#47,#00,#00,#08,#0d,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #31,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#47,#00,#00,#08,#32,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#06,#00,#3c,#00,#00,#08,#0d,#00
        DEFB #01,#04,#00,#64,#00,#00,#08,#26,#00
        DEFB #31,#05,#00,#6a,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#6a,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#54,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#54,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#47,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#35,#00,#00,#08,#19,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#02,#00,#22,#00,#00,#08,#7d,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#02,#00,#22,#00,#00,#08,#7d,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#32,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#1e,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#22,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#22,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#1e,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#03,#00,#2d,#00,#00,#08,#4b,#00
        DEFB #31,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#2d,#00,#00,#08,#19,#00
        DEFB #01,#03,#00,#24,#00,#00,#08,#4b,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#02,#00,#22,#00,#00,#08,#7d,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#02,#00,#22,#00,#00,#08,#7d,#00
        DEFB #31,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#43,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#3c,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#35,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#50,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#3c,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#32,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#28,#00,#00,#08,#19,#00
        DEFB #01,#04,#00,#1e,#00,#00,#08,#32,#00
        DEFB #01,#04,#00,#22,#00,#00,#08,#32,#00
        DEFB #31,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#22,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#1e,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#24,#00,#00,#08,#19,#00
        DEFB #01,#03,#00,#2d,#00,#00,#08,#4b,#00
        DEFB #31,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#43,#00,#00,#08,#19,#00
        DEFB #01,#05,#00,#2d,#00,#00,#08,#19,#00
        DEFB #01,#03,#00,#24,#00,#00,#08,#4b,#00
        DEFB #ff                                    ; end of table

startDataB
        DEFB #2a,#00,#00,#00,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#64,#00
        DEFB #02,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#8e,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
loopDataB
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#64,#00
        DEFB #02,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#8e,#00,#00,#08,#a7,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#d5,#00,#00,#08,#c8,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#c8,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#64,#00
        DEFB #02,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#8e,#00,#00,#08,#a7,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #2a,#00,#00,#00,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#6a,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#11,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#11,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#03,#00,#86,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#03,#00,#86,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#96,#00
        DEFB #02,#05,#00,#c9,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#d5,#00,#00,#08,#19,#00
        DEFB #2a,#05,#00,#0c,#01,#00,#08,#19,#00
        DEFB #02,#05,#00,#1c,#01,#00,#08,#19,#00
        DEFB #02,#03,#00,#3f,#01,#00,#08,#64,#00
        DEFB #02,#04,#00,#9f,#00,#00,#08,#32,#00
        DEFB #2a,#03,#00,#b3,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#19,#00
        DEFB #2a,#04,#00,#d5,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#1c,#01,#00,#08,#19,#00
        DEFB #02,#04,#00,#52,#01,#00,#08,#32,#00
        DEFB #02,#03,#00,#1c,#01,#00,#08,#4b,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#03,#00,#86,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #2a,#02,#00,#9f,#00,#00,#08,#c8,#00
        DEFB #2a,#03,#00,#86,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#77,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#86,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #2a,#02,#00,#c9,#00,#00,#08,#96,#00
        DEFB #02,#05,#00,#c9,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#d5,#00,#00,#08,#19,#00
        DEFB #2a,#05,#00,#0c,#01,#00,#08,#19,#00
        DEFB #02,#05,#00,#1c,#01,#00,#08,#19,#00
        DEFB #02,#03,#00,#3f,#01,#00,#08,#64,#00
        DEFB #02,#04,#00,#9f,#00,#00,#08,#32,#00
        DEFB #2a,#03,#00,#b3,#00,#00,#08,#64,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#8e,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#9f,#00,#00,#08,#19,#00
        DEFB #02,#05,#00,#b3,#00,#00,#08,#19,#00
        DEFB #2a,#04,#00,#d5,#00,#00,#08,#32,#00
        DEFB #02,#05,#00,#1c,#01,#00,#08,#19,#00
        DEFB #02,#04,#00,#52,#01,#00,#08,#32,#00
        DEFB #02,#03,#00,#1c,#01,#00,#08,#4b,#00
        DEFB #ff                                    ; end of table

startDataC
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#32,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#64,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
loopDataC
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#53,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#53,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#08,#00,#00,#00,#14,#0c,#0d,#00
        DEFB #04,#08,#00,#00,#00,#14,#0c,#0d,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#3f,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#3f,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#92,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#92,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#de,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#de,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#1c,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#1c,#01,#00,#09,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#04,#00,#1c,#01,#00,#09,#32,#00
        DEFB #04,#05,#00,#38,#02,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#1c,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#53,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#05,#00,#53,#03,#00,#09,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#08,#00,#00,#00,#01,#0c,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#19,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#0d,#00
        DEFB #04,#07,#00,#00,#00,#0a,#0c,#0d,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#0d,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#cc,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#aa,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#3f,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#05,#00,#7e,#02,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#06,#00,#7e,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#3f,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#0d,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#92,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#24,#03,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#24,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#92,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#de,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#05,#00,#bc,#03,#00,#09,#19,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#06,#00,#bc,#03,#00,#09,#0d,#00
        DEFB #04,#05,#00,#de,#01,#00,#09,#19,#00
        DEFB #1c,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#cc,#02,#00,#09,#0d,#00
        DEFB #04,#05,#00,#cc,#02,#00,#09,#19,#00
        DEFB #04,#06,#00,#66,#01,#00,#09,#0d,#00
        DEFB #1c,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#00,#00,#00,#00,#00,#09,#19,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#aa,#01,#00,#09,#0d,#00
        DEFB #04,#05,#00,#aa,#01,#00,#09,#19,#00
        DEFB #04,#06,#00,#d5,#00,#00,#09,#0d,#00
        DEFB #ff                                    ; end of table

endData
PRINT "endData:",{hex}endData
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: game-fugitif
  SELECT id INTO tag_uuid FROM tags WHERE name = 'game-fugitif';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
