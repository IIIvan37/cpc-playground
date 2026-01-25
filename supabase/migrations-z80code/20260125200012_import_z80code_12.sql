-- Migration: Import z80code projects batch 12
-- Projects 23 to 24
-- Generated: 2026-01-25T21:43:30.184269

-- Project 23: fugitif-mouse modifié by FMA - > piqué par gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fugitif-mouse modifié',
    'Imported from z80Code. Author: FMA - > piqué par gurneyh.',
    'public',
    false,
    false,
    '2021-10-12T20:59:07.124000'::timestamptz,
    '2021-10-12T22:40:41.931000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Fugitif
;
; Code de test pour améliorer le mode 1+.
;
; L''idée est d''afficher à la fois l''image du jeu et l''interface à icônes.
; Pour ça, on utilise une rupture pour avoir 2 screens, en changeant
; l''adresse vidéo, ainsi que les couleurs.
;
; Code forked from Tronic''s example
;
; Frédéric

;NOLIST
;SETCRTC 0
BUILDSNA
BANKSET 0
ORG #40
RUN start


;
; Constants
;
NOP_    equ  #00

PPI_PORT_A              equ #f400               ; read/write
PPI_PORT_B              equ #f500               ; read only
PPI_PORT_C              equ #f600               ; write only
PPI_CTRL                equ #f700               ; write only

; Port B bits
PPI_K7_BIT              equ %10000000
PPI_BUSY_BIT            equ %01000000
PPI_VBL_BIT             equ %00000001

; Port C bits
PPI_AY3_BDIR_BIT        equ %10000000
PPI_AY3_BC1_BIT         equ %01000000

; Ctrl bits
; PPI_CRTL_BIT            equ %10000000
PPI_GROUP_A_MODE_2      equ %11000000
PPI_GROUP_A_MODE_1      equ %10100000
PPI_GROUP_A_MODE_0      equ %10000000
PPI_PORT_A_INPUT        equ %10010000
PPI_PORT_A_OUTPUT       equ %10000000
PPI_PORT_C_HI_INPUT     equ %10001000
PPI_PORT_C_HI_OUTPUT    equ %10000000
PPI_PORT_B_MODE_1       equ %10000100
PPI_PORT_B_MODE_0       equ %10000000
PPI_PORT_B_INPUT        equ %10000010
PPI_PORT_B_OUTPUT       equ %10000000
PPI_PORT_C_LO_INPUT     equ %10000001
PPI_PORT_C_LO_OUTPUT    equ %10000000
; -----------------------------------------

; -----------------------------------------
GATE_ARRAY              equ #7f00
; -----------------------------------------

; Key mapping
; higher byte is line  (set by PPI Port C)
; lower byte is column (AY-3-8912 I/O read in PPI Port A)
KEY_UP      equ #0000+%00000001
KEY_DOWN    equ #0000+%00000100
KEY_LEFT    equ #0100+%00000001
KEY_RIGHT   equ #0000+%00000010
KEY_SPACE   equ #0500+%10000000
KEY_ESC     equ #0800+%00000100
KEY_SHIFT   equ #0200+%00100000


;
; Macros
;

; Execute {action} if {key} is pressed
; Need to call ''scan'' first
MACRO KBDCHECK key, action
        ld   a,(kbd_scan.buffer+hi({key}))
        and  lo({key})
        call z,{action}
MEND

; -----------------------------------------
; Load {value} to CRTC {register}
MACRO LOADCRTC register,value
        ld   bc,CRTC_SELECT+{register}
        out  (c),c
        inc  b
        ld   a,{value}
        out  (c),a
MEND
; -----------------------------------------

; -----------------------------------------
; Select {ink} (use 16 for border)
MACRO SELECTINK ink
        ld   bc,GATE_ARRAY+{ink}
        out  (c),c
ENDM
; -----------------------------------------


; -----------------------------------------
; Set current ink to {color}
; Must be used after a SELECTINK or SETINKCOLOR macro
; TODO: translate CPC colors. Use table and add #40
MACRO SETCOLOR color
        ld   a,{color}
        out  (c),a
ENDM
; -----------------------------------------


; -----------------------------------------
; Assign {color} to {ink}
MACRO SETINKCOLOR ink,color
        SELECTINK {ink}
        SETCOLOR {color}
ENDM
; -----------------------------------------


; -----------------------------------------
; Select next ink
MACRO SELECTNEXTINK
        inc c
        out  (c),c
ENDM
; -----------------------------------------


;
; Main code
;
start
        di

        ; Inhibit RST 38 interrupt vector
        ld   hl,#c9fb
        ld   (#38),hl

        ; Set border black
        SELECTINK 10
        SETCOLOR #40+20;  01

        ; Set all inks black
        SELECTINK 0
        SETCOLOR #40+20
        SELECTNEXTINK
        SETCOLOR #40+20
        SELECTNEXTINK
        SETCOLOR #40+20
        SELECTNEXTINK
        SETCOLOR #40+20

        ; Uncompress icons screen
        ld   hl,iconScreen
        ld   de,#c000
        call dzx0_mega

        ; Set inks 1, 2 and 3 for icons screen
        SELECTINK 1
        SETCOLOR #40+#15
        SELECTNEXTINK
        SETCOLOR #40+#04
        SELECTNEXTINK
        SETCOLOR #40+#13

        call pointer_show
mainLoop
        ; Wait for CRTC vbl
        ld   b,#f5
waitVbl
        in   a,(c)
        rra
        jr   nc,waitVbl


        call kbd_scan
       

;         KBDCHECK KEY_SPACE,spacePressed
;         KBDCHECK KEY_ESC,escPressed
        KBDCHECK KEY_UP,pointer_up
        KBDCHECK KEY_DOWN,pointer_down
        KBDCHECK KEY_LEFT,pointer_left
        KBDCHECK KEY_RIGHT,pointer_right
        
        SETINKCOLOR 16, #4e
        call pointer_hide
        call pointer_show
        SETINKCOLOR 16, #54

        jr   mainLoop


; -----------------------------------------
;
; Sub-routines
;
; -----------------------------------------


MODULE pointer

; -----------------------------------------
; Pointer management
; -----------------------------------------

l_bc26
        ld a, h
        add a, 8
        ld h, a
        and #38
        ret nz
        ld a, #50
        add l
        ld l ,a
        ld a, #c0 ; -#40
        adc a, h
        ld h, a
        ret



;; Storage space for look-up table used to convert a Y coordinate into a screen memory address
screen_addr_table
repeat 200, yy
y = yy - 1
        dw #c000 + (y % 8) * #800 + floor(y / 8) * #50
        print y, {hex}#c000 + (y & 7) * #800 + floor(y / 8) * #50
       
rend
;; the table stores the memory address for 200 lines. Each
;; memory address is a 16-bit value (2 bytes per value).

; To convert from a coordinate to a screen address we use the following code:

;; input conditions:
;; H = x byte coordinate (0-79)
;; L = y coordinate (0-199)
;; output conditions:
;; HL = screen address
get_screen_address
l_bc1d
        push bc
        ld c,h                ;; store H coordinate for later

        ld h,0                ;; H used to hold X coordinate, need to zero this out
                            ;; because we want HL to contain the Y coordinate

        add hl,hl                ;; each element of the look-up table is 2 bytes
                            ;; convert y position to a byte offset from the start
                            ;; of the look up table
        ld de,screen_addr_table
        add hl,de                ;; add start of lookup table to get address of element
                            ;; in lookup table

        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a                ;; read element from lookup table (memory address of the start
                            ;; of the line defined by the y coordinate)

        ld b,0
        add hl,bc                ;; add on X byte coordinate

;; HL = final memory address

        pop bc
        ret

; -----------------------------------------
; Move pointer up
up
        ld   a,(pos.y)
        sub  4
        ld   (pos.y),a
        ret  nc
        xor  a
        ld   (pos.y),a
        ret

; Move pointer down
down
        ld   a,(pos.y)
        add  4
        ld   (pos.y),a
        cp   200-16
        ret  c
        ld   a,200-16
        ld   (pos.y),a
        ret

; Move pointer left
left
        ld   a,(pos.x)
        dec  a
        ld   (pos.x),a
        ret  p
        xor  a
        ld   (pos.x),a
        ret

; Move pointer right
right
        ld   a,(pos.x)
        inc  a
        ld   (pos.x),a
        cp   80-4
        ret  c
        ld   a,80-4
        ld   (pos.x),a
        ret

; Restore screen at pointer pos.
hide
        ; Get video address at pointer pos.
        ld   hl, (prv_adr)
        ld   de,saved
        ld   bc,#10 * #100 + #ff
.loop
        push hl
        ex   de,hl
        ldi
        ldi
        ldi
        ldi
        ex   de,hl
        pop  hl
        call l_bc26                  ; video address below
        djnz .loop

        ret


; Display pointer at current pos.
show
        ; Get video address at pointer pos.
        ld   hl,(pos)
        call l_bc1d
        push hl                     ; save video address
        
        ld (prv_adr), hl
        ; Save screen under pointer pos.
        ld   de,saved         
        ld   bc, #10 * #100 + #ff
.loop1
        push hl
        ldi                         ; transfert screen to save are
        ldi
        ldi
        ldi
        pop  hl
        call l_bc26                  ; video address below
        djnz  .loop1

        pop  hl                     ; retreive initial video addre
        ld   de,data
        ld   bc, #10 * #100 + #ff
.loop2
        push hl
repeat 3
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        inc  hl
        inc  de
rend
        ld   a,(de)
        or   (hl)
        ld   (hl),a
        pop  hl
        inc  de
        call l_bc26                  ; video address below
        djnz .loop2

        ret

pos
.y      defb 100+8                  ; point [0:199]
.x      defb 40-1                   ; byte [0:79]

prv_adr:
        dw 0
data
        defb %00000000, %00000000, %00000000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00000000, %00000000, %00000000
        defb %01110111, %11001100, %00110011, %11101110
        defb %01110111, %11001100, %00110011, %11101110
        defb %00000000, %00000000, %00000000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00010001, %10001000, %00000000
        defb %00000000, %00000000, %00000000, %00000000

saved   defs 4*16
; -----------------------------------------
MODULE OFF


MODULE kbd

; -----------------------------------------
; Scan the 10 lines of the keyboard
; Assume PPI PORT A is already in output mode
;
; Adapted from Roudoudou''s code
; (https://open.amstrad.info/2019/04/27/gestion-du-clavier)
scan
        ld   bc,PPI_PORT_A + 14                    ; load 14 (R14 reg.) to port A (d0-d7 of AY-3-8912)
        out  (c),c
        ld   bc,PPI_PORT_C + PPI_AY3_BDIR_BIT \
                           | PPI_AY3_BC1_BIT        ; select R14 reg. (keyboard)
        out  (c),c
        out  (c),0                                  ; BDIR=0, BC1=0: inactive
        ld   bc,PPI_CTRL + PPI_PORT_A_INPUT \
                         | PPI_PORT_B_INPUT         ; set PPI port A as input
        out  (c),c

        ld   hl,.buffer
        ld   a,#40                                  ; line 0
REPEAT 10
        ld   b,hi(PPI_PORT_C)                       ; AY-3-8912: BDIR=0, BC1=1 (transfert R14 to d0-d7)
        out  (c),a
        ld   b,hi(PPI_PORT_A)                       ; read PPI port A (d0-d7 of ay-3-8912)
        ini
        inc  a                                      ; next line
REND
        ld   bc,PPI_CTRL + PPI_PORT_A_OUTPUT \
                         | PPI_PORT_B_INPUT         ; set PPI port A as output
        out (c),c
        dec  b
        out (c),0                                   ; CPC+ compatibility

        ret
print {hex}$
.buffer
        defs 10                                     ; 10 lines
MODULE OFF


; -----------------------------------------------------------------------------
; ZX0 decoder by Einar Saukas
; "Mega" version (673 bytes, 28% faster)
; -----------------------------------------------------------------------------
; Parameters:
;   HL: source address (compressed data)
;   DE: destination address (decompressing)
; -----------------------------------------------------------------------------

dzx0_mega:
        ld      bc, #ffff               ; preserve default offset 1
        ld      (dzx0m_last_offset+1), bc
        inc     bc
        jr      dzx0m_literals0

dzx0m_new_offset6:
        ld      c, #fe                  ; prepare negative offset
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset1
dzx0m_elias_offset1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_offset7
dzx0m_new_offset7:
        inc     c
        ret     z                       ; check end marker
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length7        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length3
dzx0m_elias_length3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length1
dzx0m_length1:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset0
dzx0m_literals0:
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals3
dzx0m_elias_literals3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals1
dzx0m_literals1:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset0
        inc     c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse3
dzx0m_elias_reuse3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse1
dzx0m_reuse1:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals0

dzx0m_new_offset0:
        ld      c, #fe                  ; prepare negative offset
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset3
dzx0m_elias_offset3:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset1
dzx0m_new_offset1:
        inc     c
        ret     z                       ; check end marker
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length1        ; obtain length
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_length7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length5
dzx0m_elias_length5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length3
dzx0m_length3:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset2
dzx0m_literals2:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_literals7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals5
dzx0m_elias_literals5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals3
dzx0m_literals3:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset2
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_reuse7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse5
dzx0m_elias_reuse5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse3
dzx0m_reuse3:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals2

dzx0m_new_offset2:
        ld      c, #fe                  ; prepare negative offset
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_new_offset7
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset5
dzx0m_elias_offset5:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset3
dzx0m_new_offset3:
        inc     c
        ret     z                       ; check end marker
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length3        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_length7
dzx0m_elias_length7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_length5
dzx0m_length5:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      c, dzx0m_new_offset4
dzx0m_literals4:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_literals7
dzx0m_elias_literals7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_literals5
dzx0m_literals5:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jr      c, dzx0m_new_offset4
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_reuse7
dzx0m_elias_reuse7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_reuse5
dzx0m_reuse5:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals4

dzx0m_new_offset4:
        ld      c, #fe                  ; prepare negative offset
        add     a, a                    ; obtain offset MSB
        jp      c, dzx0m_new_offset3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_new_offset1
        add     a, a
        rl      c
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      c, dzx0m_new_offset7
dzx0m_elias_offset7:
        add     a, a
        rl      c
        rl      b
        add     a, a
        jp      nc, dzx0m_elias_offset5
dzx0m_new_offset5:
        inc     c
        ret     z                       ; check end marker
        ld      b, c
        ld      c, (hl)                 ; obtain offset LSB
        inc     hl
        rr      b                       ; last offset bit becomes first length bit
        rr      c
        ld      (dzx0m_last_offset+1), bc ; preserve new offset
        ld      bc, 1
        jp      c, dzx0m_length5        ; obtain length
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_length1
dzx0m_elias_length1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_length7
dzx0m_length7:
        push    hl                      ; preserve source
        ld      hl, (dzx0m_last_offset+1)
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        inc     c
        ldi                             ; copy one more from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jp      c, dzx0m_new_offset6
dzx0m_literals6:
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_literals5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_literals1
dzx0m_elias_literals1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_literals7
dzx0m_literals7:
        ldir                            ; copy literals
        add     a, a                    ; copy from last offset or new offset?
        jp      c, dzx0m_new_offset6
        inc     c
        add     a, a                    ; obtain length
        jp      c, dzx0m_reuse5
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse3
        add     a, a
        rl      c
        add     a, a
        jp      c, dzx0m_reuse1
dzx0m_elias_reuse1:
        add     a, a
        rl      c
        rl      b
        ld      a, (hl)                 ; load another group of 8 bits
        inc     hl
        add     a, a
        jp      nc, dzx0m_elias_reuse7
dzx0m_reuse7:
        push    hl                      ; preserve source
dzx0m_last_offset:
        ld      hl, 0
        add     hl, de                  ; calculate destination - offset
        ldir                            ; copy from offset
        pop     hl                      ; restore source
        add     a, a                    ; copy from literals or new offset?
        jr      nc, dzx0m_literals6

        jp      dzx0m_new_offset6
; -----------------------------------------------------------------------------

; -----------------------------------------
;
; Datas
;
; -----------------------------------------

; -----------------------------------------
iconScreen
        db #95,#0a,#22,#08,#0a,#15,#69,#a5,#02,#e2,#a1,#de,#84,#85,#f5,#ac
        db #3e,#f5,#fe,#29,#f0,#02,#e2,#b0,#de,#84,#d0,#f5,#ac,#29,#b0,#2f
        db #0f,#fe,#a8,#00,#92,#07,#0f,#fc,#0e,#eb,#ec,#8f,#0b,#0f,#da,#a6
        db #0d,#7c,#91,#55,#00,#fe,#24,#ee,#11,#bb,#66,#0d,#0b,#06,#fa,#e8
        db #bc,#83,#ac,#f6,#f4,#78,#0f,#f0,#c0,#1c,#4a,#70,#f0,#fe,#5e,#7d
        db #4a,#83,#05,#08,#60,#20,#f1,#22,#f8,#b1,#a6,#71,#e6,#71,#98,#ee
        db #f5,#fb,#69,#5f,#70,#70,#06,#10,#90,#20,#00,#fe,#01,#86,#40,#01
        db #07,#0c,#a0,#e6,#61,#c8,#00,#30,#09,#88,#31,#a8,#30,#82,#f8,#f0
        db #24,#2c,#80,#46,#1d,#03,#0a,#21,#00,#20,#84,#90,#cb,#cc,#c4,#60
        db #2c,#21,#b9,#27,#0f,#fe,#4e,#61,#85,#11,#9e,#33,#88,#ee,#fa,#ff
        db #dd,#f4,#dc,#fb,#20,#18,#c9,#06,#61,#4a,#5c,#c4,#80,#2a,#02,#c6
        db #60,#b6,#94,#97,#a0,#00,#cc,#33,#99,#bb,#33,#77,#33,#99,#dd,#cc
        db #00,#20,#c4,#60,#2d,#07,#30,#43,#fc,#58,#d6,#30,#c9,#22,#2d,#00
        db #10,#c3,#0f,#0c,#06,#32,#53,#dd,#0a,#0d,#04,#50,#c3,#89,#0d,#a6
        db #06,#38,#87,#08,#0d,#01,#f9,#94,#f2,#08,#b0,#87,#cb,#a4,#8f,#03
        db #1c,#cb,#e3,#f7,#cb,#60,#e1,#e7,#e7,#fd,#05,#04,#43,#60,#30,#88
        db #c0,#f1,#6f,#71,#f4,#44,#91,#e0,#70,#00,#07,#38,#f3,#d0,#10,#86
        db #70,#fc,#10,#21,#18,#60,#42,#36,#00,#06,#c0,#14,#62,#00,#10,#29
        db #90,#88,#c0,#e1,#05,#2a,#02,#d6,#c0,#fa,#fb,#f1,#4e,#60,#c0,#46
        db #a2,#07,#e0,#10,#68,#80,#05,#62,#03,#03,#05,#49,#08,#34,#87,#08
        db #c3,#0e,#0c,#0c,#0f,#0a,#10,#70,#2c,#04,#35,#60,#7f,#2e,#77,#09
        db #09,#1d,#ff,#ff,#d0,#e1,#60,#04,#21,#64,#00,#30,#03,#2d,#07,#2e
        db #87,#1e,#08,#0f,#0d,#1a,#70,#1f,#24,#43,#17,#fe,#72,#8a,#c2,#6d
        db #1a,#2d,#ee,#27,#0e,#16,#38,#07,#20,#60,#16,#e5,#77,#f4,#3d,#60
        db #b0,#05,#96,#07,#87,#a8,#e1,#1f,#0e,#06,#02,#d8,#c0,#10,#a8,#30
        db #e0,#49,#30,#5b,#d6,#09,#cb,#0b,#90,#2b,#08,#0c,#0c,#03,#0e,#d5
        db #b1,#35,#07,#6c,#97,#14,#be,#63,#06,#fb,#e5,#b5,#42,#ba,#a2,#ee
        db #35,#03,#04,#38,#f9,#f5,#eb,#30,#0d,#11,#01,#93,#99,#87,#0d,#2b
        db #0b,#0e,#02,#06,#6d,#26,#0b,#70,#a2,#31,#0c,#61,#e8,#ee,#ff,#01
        db #0a,#85,#dd,#ad,#cc,#3a,#88,#11,#61,#79,#11,#b9,#05,#fe,#58,#84
        db #01,#05,#0b,#01,#96,#a0,#e5,#5a,#fe,#6e,#1a,#de,#28,#58,#4f,#ac
        db #52,#93,#1a,#55,#90,#00,#58,#25,#0e,#01,#0c,#03,#82,#0c,#03,#08
        db #07,#00,#b1,#80,#65,#80,#75,#59,#00,#0a,#e0,#05,#a4,#34,#56,#18
        db #03,#01,#0d,#00,#a0,#09,#81,#d4,#31,#88,#89,#2c,#00,#11,#aa,#02
        db #0d,#09,#99,#d8,#f0,#f2,#84,#dc,#11,#b8,#89,#90,#a0,#10,#a9,#07
        db #84,#08,#f0,#e0,#26,#3c,#d0,#a0,#44,#28,#03,#40,#9f,#44,#11,#11
        db #fb,#eb,#dd,#f4,#55,#b5,#e9,#00,#5c,#00,#18,#91,#04,#0b,#22,#77
        db #88,#40,#65,#88,#01,#0e,#09,#0f,#0f,#0f,#28,#8a,#77,#33,#ee,#22
        db #99,#88,#37,#c0,#2d,#30,#70,#42,#4b,#c0,#56,#74,#c3,#76,#5a,#04
        db #5d,#56,#00,#22,#0c,#05,#29,#0c,#82,#80,#e1,#0e,#09,#49,#8a,#09
        db #08,#0b,#09,#21,#98,#18,#10,#c3,#0d,#03,#86,#07,#1e,#6a,#04,#0b
        db #70,#04,#a2,#0c,#12,#83,#f3,#ff,#ff,#ce,#70,#ff,#ff,#ff,#18,#04
        db #0a,#c0,#05,#1a,#04,#05,#5b,#02,#66,#c0,#20,#00,#e1,#14,#88,#03
        db #07,#15,#6d,#0f,#56,#01,#98,#b0,#81,#70,#61,#40,#a2,#10,#29,#0d
        db #0d,#80,#01,#70,#87,#46,#a5,#01,#81,#16,#8d,#3f,#ff,#0e,#19,#ec
        db #02,#a6,#00,#1e,#05,#11,#88,#0f,#84,#a0,#28,#11,#92,#b0,#87,#4b
        db #1f,#89,#2f,#88,#03,#69,#14,#b9,#11,#f4,#4d,#57,#00,#69,#01,#92
        db #98,#d2,#d3,#0f,#0f,#03,#a0,#24,#10,#82,#01,#38,#48,#e1,#6a,#4b
        db #37,#b0,#70,#1d,#f5,#57,#ed,#6c,#1b,#0c,#5a,#96,#c5,#fc,#6d,#0e
        db #56,#00,#8a,#1c,#c3,#66,#38,#87,#1f,#66,#06,#02,#4f,#7d,#0c,#01
        db #8e,#bf,#5e,#17,#d5,#7a,#0e,#11,#03,#c8,#3d,#2f,#0c,#99,#52,#b2
        db #bd,#8f,#ed,#57,#00,#98,#03,#01,#07,#2c,#07,#d5,#38,#d5,#35,#c6
        db #d5,#58,#00,#55,#78,#60,#06,#c5,#a4,#c5,#7a,#bd,#21,#60,#76,#40
        db #26,#01,#04,#02,#02,#f7,#02,#fd,#20,#5b,#0f,#c4,#fe,#a0,#0a,#08
        db #26,#f0,#e0,#f1,#ff,#e5,#ee,#f4,#8d,#f0,#16,#57,#00,#11,#a9,#e0
        db #81,#09,#0c,#f0,#82,#dc,#33,#40,#70,#28,#c8,#62,#10,#90,#44,#60
        db #84,#00,#0e,#09,#00,#88,#a2,#70,#01,#7d,#f5,#55,#84,#00,#a4,#00
        db #56,#a9,#43,#1e,#43,#55,#6e,#2a,#fa,#75,#58,#00,#56,#60,#00,#03
        db #09,#51,#98,#30,#0c,#00,#22,#11,#88,#9a,#ff,#77,#ee,#08,#77,#11
        db #bb,#00,#1e,#ed,#ac,#03,#0c,#2e,#1b,#0e,#f3,#d5,#02,#88,#c5,#38
        db #c3,#86,#84,#c3,#02,#04,#07,#c4,#6e,#8e,#99,#1d,#06,#04,#0c,#05
        db #70,#59,#7b,#27,#1c,#18,#86,#03,#0d,#03,#bb,#c7,#07,#ab,#03,#9c
        db #67,#01,#0e,#02,#e1,#81,#fe,#16,#5d,#04,#10,#c3,#f3,#fc,#f0,#86
        db #56,#01,#20,#f0,#e1,#41,#fa,#f3,#61,#fc,#04,#0c,#47,#a7,#51,#85
        db #c0,#0d,#56,#01,#8a,#0e,#70,#05,#56,#81,#30,#16,#b6,#02,#c0,#14
        db #67,#34,#c3,#06,#12,#21,#b0,#00,#4f,#44,#55,#81,#00,#0a,#10,#26
        db #f7,#6f,#07,#88,#0a,#33,#05,#62,#10,#c3,#26,#02,#79,#8f,#a0,#48
        db #15,#8a,#02,#84,#6d,#0f,#3e,#61,#40,#ef,#9c,#20,#60,#55,#d5,#7a
        db #00,#21,#98,#1e,#97,#18,#62,#0e,#20,#01,#09,#82,#04,#0c,#70,#4a
        db #e9,#38,#05,#38,#86,#09,#12,#09,#ff,#0d,#0c,#c3,#05,#00,#0e,#19
        db #3b,#22,#7f,#fe,#98,#04,#0e,#c1,#2c,#0e,#9e,#41,#09,#06,#ed,#f9
        db #44,#c5,#0f,#ff,#1f,#64,#cf,#0c,#0f,#0e,#0e,#61,#0a,#08,#ff,#cc
        db #7e,#d3,#df,#8c,#b0,#87,#0a,#07,#60,#4f,#1c,#cf,#37,#dc,#d1,#f9
        db #8d,#fd,#e1,#79,#94,#d2,#35,#56,#00,#40,#0e,#60,#01,#9c,#4a,#80
        db #00,#55,#da,#a0,#33,#28,#cc,#61,#82,#dd,#b8,#60,#d0,#83,#f5,#92
        db #60,#de,#20,#09,#04,#70,#87,#01,#66,#04,#f0,#0e,#00,#a5,#04,#0a
        db #01,#00,#b4,#00,#db,#f0,#ee,#24,#2a,#b5,#07,#5c,#00,#46,#88,#c0
        db #82,#0e,#00,#98,#f3,#26,#f1,#b8,#80,#c0,#20,#f8,#f0,#a4,#18,#56
        db #21,#0c,#05,#36,#c0,#a3,#b0,#2d,#a6,#57,#00,#44,#83,#08,#20,#0a
        db #0a,#85,#cc,#ed,#d5,#28,#57,#00,#11,#a4,#0f,#1f,#c3,#55,#fa,#18
        db #fb,#55,#35,#5f,#1c,#54,#f1,#ee,#53,#ee,#75,#47,#20,#17,#77,#37
        db #3b,#c3,#d6,#55,#d1,#00,#66,#00,#00,#0e,#0e,#dc,#1d,#56,#00,#5a
        db #c3,#a2,#0e,#2e,#0c,#40,#d9,#6f,#0c,#30,#87,#af,#12,#67,#f5,#18
        db #f3,#56,#84,#ad,#08,#27,#0f,#01,#08,#70,#11,#28,#47,#0d,#9a,#61
        db #08,#01,#fe,#30,#ae,#d1,#35,#0b,#0c,#56,#3d,#b7,#08,#ce,#1f,#fe
        db #55,#ed,#33,#07,#56,#a0,#14,#75,#5e,#00,#26,#e1,#0e,#80,#87,#56
        db #d4,#70,#61,#c0,#d1,#3e,#b4,#de,#f5,#f4,#1b,#0f,#51,#85,#c0,#18
        db #81,#03,#06,#53,#15,#7a,#00,#f0,#0d,#81,#20,#4d,#13,#49,#48,#a0
        db #75,#58,#00,#05,#a9,#14,#20,#07,#30,#0d,#04,#03,#0a,#44,#99,#0f
        db #95,#ce,#8a,#51,#70,#d8,#24,#20,#10,#b5,#e1,#5a,#01,#61,#a0,#cf
        db #a0,#20,#11,#a8,#0f,#20,#4b,#5e,#c3,#3f,#a0,#60,#10,#a2,#01,#08
        db #1f,#09,#1e,#f1,#37,#20,#03,#cd,#a8,#d0,#2c,#d5,#76,#00,#60,#06
        db #0f,#60,#87,#5e,#81,#0c,#0c,#c0,#14,#a2,#86,#1f,#8d,#1a,#ef,#a2
        db #e1,#26,#19,#8e,#18,#3f,#ff,#ad,#2f,#d2,#2a,#b8,#1c,#43,#1f,#1a
        db #ae,#73,#53,#1a,#2a,#13,#6a,#22,#b8,#e3,#8e,#34,#46,#be,#ed,#bb
        db #c3,#f1,#e2,#31,#8b,#4b,#24,#14,#a4,#41,#0f,#03,#17,#fe,#03,#40
        db #37,#e0,#d4,#fe,#d0,#0d,#e0,#71,#56,#a0,#15,#75,#56,#00,#04,#b5
        db #91,#58,#00,#20,#94,#88,#44,#22,#11,#b5,#a1,#56,#00,#42,#65,#f2
        db #87,#0a,#99,#18,#f4,#0f,#5e,#fe,#54,#b5,#60,#58,#00,#5f,#0d,#c4
        db #fe,#75,#5d,#00,#a1,#90,#98,#90,#d4,#30,#08,#91,#00,#00,#49,#99
        db #01,#08,#90,#9d,#f9,#ff,#fe,#87,#c0,#55,#5d,#00,#03,#19,#f1,#e1
        db #00,#05,#05,#cc,#7b,#d5,#24,#55,#5c,#00,#53,#45,#95,#42,#c5,#58
        db #00,#9a,#33,#99,#ee,#24,#11,#ee,#ed,#f8,#55,#e9,#00,#11,#47,#55
        db #8a,#00,#a0,#90,#95,#33,#ff,#ee,#66,#77,#dd,#ff,#ff,#bb,#77,#ee
        db #20,#08,#b1,#03,#0d,#df,#4c,#fe,#6d,#0e,#57,#00,#62,#10,#87,#19
        db #20,#d0,#c3,#04,#08,#10,#b0,#82,#0e,#05,#78,#0f,#09,#20,#18,#b0
        db #86,#09,#00,#30,#f5,#e5,#5e,#03,#f7,#d5,#14,#57,#4e,#3b,#f5,#61
        db #b5,#ad,#81,#58,#00,#50,#88,#03,#0e,#15,#67,#03,#10,#e3,#68,#3a
        db #8d,#70,#8f,#54,#81,#60,#1a,#01,#17,#60,#20,#13,#46,#a2,#d4,#61
        db #c0,#46,#20,#03,#06,#38,#60,#11,#f6,#5f,#20,#14,#3b,#63,#04,#55
        db #90,#00,#09,#a2,#00,#01,#09,#01,#14,#01,#5a,#30,#22,#86,#67,#2d
        db #00,#8d,#23,#86,#20,#81,#20,#09,#30,#30,#03,#14,#52,#f1,#4f,#ab
        db #ab,#0f,#2c,#55,#81,#00,#18,#8a,#c3,#0f,#1f,#62,#04,#28,#01,#0a
        db #10,#8a,#2d,#0f,#8a,#0e,#0e,#ac,#04,#60,#60,#16,#ab,#0e,#e1,#55
        db #58,#89,#9b,#09,#c7,#10,#14,#ea,#86,#6f,#59,#b3,#ff,#bb,#ff,#88
        db #f1,#e1,#a2,#cc,#28,#21,#cf,#22,#f4,#e5,#d2,#25,#88,#df,#71,#e1
        db #ef,#12,#5e,#e1,#4c,#1a,#a8,#ee,#8a,#1d,#ff,#4e,#24,#d5,#30,#0c
        db #77,#cf,#18,#e9,#78,#00,#68,#07,#0d,#0e,#00,#e1,#91,#09,#87,#00
        db #d5,#59,#00,#07,#55,#de,#00,#fe,#1d,#55,#c0,#00,#aa,#f2,#09,#59
        db #95,#14,#f4,#0f,#4a,#b0,#66,#ff,#ff,#ff,#52,#09,#06,#38,#b0,#30
        db #10,#8a,#01,#0b,#82,#a0,#98,#b1,#60,#f3,#b9,#d0,#cc,#b0,#22,#3c
        db #f0,#44,#66,#01,#00,#21,#0c,#b5,#be,#5d,#00,#22,#00,#10,#45,#34
        db #1d,#eb,#55,#85,#00,#0a,#01,#b4,#0e,#59,#42,#5b,#20,#15,#7a,#24
        db #00,#6f,#11,#fb,#55,#90,#00,#22,#02,#0f,#58,#0a,#88,#cc,#ee,#cc
        db #55,#88,#ee,#77,#95,#00,#1d,#55,#66,#a0,#84,#01,#35,#5c,#00,#8a
        db #09,#06,#a8,#0d,#b0,#62,#0f,#04,#49,#21,#02,#1c,#87,#0b,#10,#70
        db #9a,#0e,#0f,#0b,#82,#0a,#26,#0c,#05,#18,#0d,#08,#00,#b0,#83,#14
        db #66,#01,#0f,#03,#89,#d0,#b0,#88,#00,#21,#05,#2a,#01,#8a,#c3,#0c
        db #a2,#0f,#80,#10,#46,#28,#00,#0c,#9a,#c0,#10,#c0,#01,#5d,#d4,#1f
        db #61,#c0,#47,#17,#73,#54,#21,#80,#46,#20,#01,#03,#35,#58,#00,#11
        db #88,#02,#03,#15,#20,#a1,#00,#0f,#06,#20,#80,#08,#00,#06,#11,#cf
        db #52,#a6,#07,#07,#87,#37,#d4,#06,#8c,#2d,#60,#56,#00,#04,#24,#aa
        db #0c,#06,#20,#4b,#79,#c7,#2c,#80,#09,#46,#89,#00,#98,#4b,#5c,#e1
        db #80,#0e,#03,#52,#88,#86,#aa,#01,#0a,#87,#60,#06,#02,#2c,#15,#a2
        db #70,#26,#01,#c6,#c5,#3c,#39,#86,#99,#1d,#bb,#fe,#9a,#fe,#f0,#e1
        db #6e,#98,#10,#f0,#e1,#92,#79,#ee,#8e,#80,#1f,#ff,#97,#1c,#f0,#80
        db #07,#7c,#87,#69,#14,#8a,#1a,#d3,#68,#b8,#a2,#2e,#68,#04,#11,#8e
        db #d1,#0a,#e5,#52,#be,#0d,#75,#f1,#57,#00,#10,#0f,#14,#53,#45,#5e
        db #a0,#20,#91,#44,#28,#33,#a5,#cc,#5d,#55,#85,#00,#5a,#80,#d5,#5c
        db #a0,#8d,#00,#f2,#3d,#a4,#52,#e8,#35,#56,#a1,#91,#28,#4d,#57,#00
        db #68,#f3,#22,#73,#70,#a4,#f0,#d5,#74,#a0,#09,#c1,#03,#10,#61,#c6
        db #0f,#4c,#07,#d0,#60,#2d,#02,#35,#05,#09,#d2,#1d,#55,#c5,#00,#29
        db #01,#47,#d5,#ff,#62,#9b,#ee,#44,#f1,#fb,#55,#a2,#00,#99,#11,#1f
        db #e2,#e2,#ef,#88,#22,#b1,#88,#55,#90,#a0,#98,#07,#00,#21,#61,#21
        db #77,#11,#cc,#dd,#cc,#33,#99,#ee,#66,#ee,#62,#77,#88,#44,#79,#fe
        db #4d,#56,#00,#65,#a8,#0c,#07,#03,#03,#09,#0c,#30,#c3,#28,#06,#64
        db #8a,#08,#0e,#06,#07,#03,#08,#87,#4b,#0f,#6c,#38,#55,#64,#a1,#a6
        db #07,#00,#10,#86,#03,#07,#04,#30,#82,#16,#eb,#ff,#fe,#fe,#d1,#f4
        db #6d,#f0,#15,#68,#a1,#02,#a0,#70,#50,#b4,#0f,#00,#85,#e0,#4b,#0c
        db #15,#5c,#a0,#dd,#c1,#80,#20,#5d,#46,#c1,#81,#08,#56,#d5,#03,#68
        db #01,#d0,#14,#75,#1d,#c0,#d8,#20,#11,#b6,#00,#23,#f4,#07,#61,#b1
        db #72,#35,#eb,#55,#81,#a0,#0a,#30,#80,#80,#06,#60,#e1,#0a,#44,#11
        db #fe,#c3,#52,#29,#43,#0d,#2a,#4b,#17,#8f,#3c,#c3,#03,#09,#dc,#74
        db #0e,#fe,#37,#2c,#53,#55,#76,#00,#4a,#0f,#04,#0f,#49,#3b,#c7,#60
        db #28,#0d,#01,#41,#89,#9c,#f0,#d5,#e0,#ab,#60,#43,#b1,#ff,#4b,#40
        db #99,#05,#01,#17,#86,#b5,#20,#58,#00,#01,#86,#e0,#01,#0f,#06,#30
        db #66,#03,#a3,#07,#71,#48,#86,#66,#76,#f0,#a5,#60,#e9,#1f,#8f,#78
        db #c5,#b6,#29,#3c,#a4,#6c,#05,#7f,#0b,#ae,#d0,#28,#02,#d6,#13,#c5
        db #86,#3a,#1a,#e3,#68,#f6,#ad,#2e,#2b,#c7,#2f,#d1,#9b,#52,#be,#28
        db #0f,#75,#5d,#00,#44,#30,#1c,#43,#15,#64,#a0,#4d,#40,#64,#80,#7d
        db #fe,#07,#05,#59,#a0,#22,#f0,#b8,#62,#f8,#f0,#54,#2d,#03,#56,#00
        db #69,#f0,#86,#e2,#f3,#30,#ec,#70,#00,#0a,#08,#ac,#00,#41,#81,#ec
        db #d8,#c1,#91,#2c,#70,#4a,#0f,#c0,#95,#e0,#f0,#60,#4c,#15,#6a,#a1
        db #00,#81,#21,#46,#75,#07,#06,#e1,#4a,#60,#52,#28,#00,#77,#bb,#99
        db #dd,#bb,#bb,#11,#cc,#ee,#ff,#00,#20,#5f,#60,#10,#d5,#5a,#01,#0e
        db #44,#a6,#c3,#c1,#0c,#56,#a0,#a8,#07,#8a,#10,#d0,#0c,#68,#78,#98
        db #0c,#0f,#09,#a2,#0c,#9a,#30,#09,#66,#0b,#0e,#61,#19,#a8,#20,#00
        db #00,#07,#88,#10,#c1,#15,#69,#08,#2d,#30,#56,#00,#05,#68,#0e,#15
        db #3d,#ff,#55,#cd,#00,#81,#c0,#5b,#10,#05,#58,#a0,#55,#75,#18,#c0
        db #51,#c1,#56,#a1,#28,#0f,#07,#a2,#06,#0e,#0b,#06,#04,#09,#2a,#cc
        db #0b,#61,#0e,#8c,#73,#c3,#01,#48,#a4,#21,#08,#80,#0f,#06,#6e,#49
        db #2d,#09,#57,#53,#3f,#05,#59,#01,#60,#49,#3a,#a7,#0f,#38,#08,#0b
        db #11,#b0,#04,#55,#8b,#a0,#97,#00,#f8,#c0,#60,#10,#8a,#10,#00,#e2
        db #08,#5b,#11,#0e,#ac,#c3,#47,#1f,#80,#fe,#1d,#15,#69,#92,#6d,#0c
        db #10,#90,#87,#1e,#3f,#ff,#57,#01,#14,#86,#86,#60,#71,#f0,#e1,#88
        db #3f,#ed,#94,#c5,#2d,#a4,#83,#d2,#b4,#fa,#70,#a4,#52,#96,#a4,#43
        db #4b,#f2,#31,#1a,#8b,#1f,#ff,#53,#09,#7c,#e0,#93,#95,#0b,#08,#00
        db #c3,#01,#0b,#b5,#ee,#5c,#00,#03,#55,#55,#80
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

-- Project 24: ztb by Paul Shirley
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'ztb',
    'Imported from z80Code. Author: Paul Shirley. ZTB  by drinksoft',
    'public',
    false,
    false,
    '2019-11-13T16:17:05.131000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Zap The BadStars!
; AKA Mission Genocide
; 
; Point d''entree #8000
; Code #8000-
; Patterns ennemis
; Terrain
; Run in Full Screen mode & Enable "Joystick" 
; To make it playable with keyboard 

NUMLIFE EQU 3
FIRSTLEVEL EQU 1

org #8000
run #8000

Entry_point:
	ld a,#C9
    ld (#BDEE),a ; KM TEST BREAKER (?)
    call init_crtc

    ld hl,texte1
lab800B: 
    ld a,(hl) ; Display Text 
    cp #ff
    jr z,lab8016
    call #BB5A ;TXT OUTPUT
    inc hl
    jr lab800B

lab8016 ld sp,#BF3F
    jp lab9000

; Initialise les regs CRTC 
; HL = pointeur vers la table (reg,val)
set_crtc_regs:
.loop
    ld a,#f0
    and (hl)
    ret nz
    ld b,#bc
    di
    ld c,(hl)
    out (c),c
    inc hl
    ld b,#bd
    ld c,(hl)
    out (c),c
    ei
    inc hl
    jr .loop

init_crtc:
    ld hl,table_crtc
    jp set_crtc_regs
	
table_crtc:
    db 1,#20,6,#20,7,#21,4,#26,2,#2a,#ff

texte1:
db #04,#00,#0E,#00,#0F,#0F,#1F,#01,#01,#5A,#54,#42,#20,#62,#79     ; #8041 .........ZTB by
db #20,#44,#72,#69,#6E,#6B,#73,#6F,#66,#74,#63,#6F,#6D,#69,#6E,#67 ; #8050  Drinksoftcoming
db #20,#73,#6F,#6F,#6E,#2E,#2E,#1D,#00,#00,#00,#00,#00,#00,#00,#00 ; #8060  soon...........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8070 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8080 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8090 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#FF ; ,#09,#0C,#0F,#12,#15 ; #80a0 ................

db #09,#0C,#0F,#12,#15 

db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #8070 ................
db #F0,#00,#01,#F0,#00,#01,#F0,#00,#08,#07,#02,#05,#04,#03,#02,#01 ; #8080 ................
db #F8,#00,#01,#F8,#00,#01,#F8,#00,#6E,#00,#01,#0D,#00,#01,#F1,#00 ; #8090 ........n.......
db #F0,#00,#01,#F0,#00,#01,#F0,#00,#05,#05,#05,#05,#05,#05,#05,#05 ; #80a0 ................
db #0D,#00,#64,#2E,#6C,#65,#76,#65,#6E,#00,#01,#2E,#00,#01,#F3,#00 ; #80b0 ..d.leven.......

LAB8100:
db #00,#00,#07,#11,#02,#1A,#04,#0F,#00,#00,#0D,#1A,#03,#17,#01,#0E ; #80c0 ................
db #00,#01,#0C,#18,#12,#15,#03,#06,#00,#00,#0E,#1A,#02,#18,#0C,#10 ; #80d0 ................
db #00,#01,#12,#1A,#09,#10,#18,#06,#00,#00,#04,#17,#0A,#16,#12,#09 ; #80e0 ................
db #00,#01,#08,#18,#12,#10,#06,#03,#00,#00,#0D,#1A,#02,#1A,#10,#18 ; #80f0 ................
db #00,#00,#0B,#17,#01,#16,#09,#12,#80,#00,#03,#12,#09,#1A,#10,#18 ; #8100 ................
db #00,#01,#05,#15,#12,#1A,#0C,#10,#00,#00,#06,#10,#03,#1A,#0A,#0D ; #8110 ................
db #00,#00,#04,#17,#0A,#16,#12,#09,#00,#01,#09,#18,#12,#10,#06,#03 ; #8120 ................

;#8170
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8130 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8140 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8150 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8160 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8170 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8180 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8190 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #81a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #81b0 ................

;#8200
LAB8200:
db #00,#00,#00,#00,#00,#00,#00,#00,#16,#1E,#02,#04,#00,#7E,#01,#00 ; #81c0 .............~..
db #03,#10,#02,#05,#08,#00,#10,#00,#01,#18,#02,#05,#30,#00,#10,#04 ; #81d0 ............0...
db #02,#01,#00,#06,#00,#2A,#20,#00,#14,#07,#02,#02,#70,#00,#30,#03 ; #81e0 .....* .....p.0.
db #19,#05,#02,#03,#0A,#00,#30,#03,#10,#0C,#01,#06,#FF,#00,#00,#01 ; #81f0 ......0.........
db #17,#16,#02,#C5,#FF,#00,#10,#00,#15,#08,#03,#03,#1E,#00,#28,#03 ; #8200 ..............(.
db #02,#08,#00,#07,#FF,#00,#00,#00,#12,#08,#00,#08,#FF,#00,#01,#00 ; #8210 ................
db #0D,#0C,#00,#05,#FF,#00,#81,#00,#11,#10,#08,#04,#13,#00,#10,#03 ; #8220 ................
db #16,#08,#02,#04,#12,#00,#28,#03,#13,#04,#04,#07,#20,#00,#28,#04 ; #8230 ......(..... .(.
db #15,#03,#04,#08,#FF,#00,#28,#00,#17,#40,#01,#05,#FF,#00,#01,#02 ; #8240 ......(..@......
db #1A,#08,#02,#05,#FF,#00,#10,#03,#18,#20,#00,#01,#FF,#00,#04,#00 ; #8250 ......... ......
db #19,#10,#04,#04,#08,#00,#10,#03,#12,#0C,#00,#45,#78,#4A,#01,#00 ; #8260 ...........ExJ..
db #0C,#17,#02,#04,#08,#00,#90,#04,#1A,#18,#08,#08,#C8,#D4,#01,#03 ; #8270 ................
db #12,#10,#00,#03,#6E,#46,#01,#03,#01,#08,#04,#05,#FF,#00,#01,#00 ; #8280 ....nF..........
db #01,#08,#02,#08,#40,#0C,#30,#03,#0C,#1E,#03,#04,#FF,#00,#90,#00 ; #8290 ....@.0.........
db #11,#20,#0C,#0B,#FF,#00,#01,#03,#1B,#28,#04,#05,#0A,#18,#20,#03 ; #82a0 . .......(.... .
db #1C,#14,#02,#03,#B4,#20,#30,#03,#1D,#06,#06,#06,#E2,#DC,#20,#04 ; #82b0 ..... 0....... .
db #10,#08,#03,#05,#64,#00,#28,#04,#14,#04,#05,#07,#DC,#0C,#28,#04 ; #82c0 ....d.(.......(.
db #14,#08,#04,#05,#70,#00,#28,#04,#02,#20,#00,#05,#FF,#00,#01,#00 ; #82d0 ....p.(.. ......
db #02,#01,#00,#08,#DC,#18,#28,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #82e0 ......(.........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #82f0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8300 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8310 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8320 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8330 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8340 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8350 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8360 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8370 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8380 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8390 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #83a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #83b0 ................
LAB8400:
db #00,#00,#00,#00,#00,#00,#00,#0D,#F4,#B2,#B2,#F4,#01,#01,#01,#01 ; #83c0 ................
db #01,#01,#01,#B9,#F1,#01,#01,#1A,#1A,#1A,#B6,#01,#01,#01,#01,#01 ; #83d0 ................
db #01,#BF,#01,#01,#01,#01,#01,#86,#01,#01,#01,#01,#F1,#96,#F1,#F1 ; #83e0 ................
db #B6,#F1,#01,#01,#F0,#F0,#00,#00,#F0,#01,#01,#01,#86,#97,#97,#85 ; #83f0 ................
db #F1,#01,#01,#01,#85,#01,#01,#B5,#F0,#01,#01,#D2,#01,#01,#0C,#28 ; #8400 ...............(
db #BF,#2A,#00,#28,#B9,#2A,#00,#28,#BB,#2A,#00,#28,#0D,#01,#01,#01 ; #8410 .*.(.*.(.*.(....
db #20,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#39,#86 ; #8420  .............9.
db #BA,#86,#39,#01,#01,#01,#01,#01,#01,#01,#01,#01,#20,#01,#39,#0C ; #8430 ..9......... .9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B2,#B2,#B2,#F1,#01,#BA,#F1 ; #8440 ................
db #01,#F1,#01,#F1,#01,#01,#01,#01,#1A,#1A,#BA,#01,#01,#01,#01,#85 ; #8450 ................
db #97,#BF,#01,#01,#01,#01,#86,#BD,#86,#01,#01,#85,#97,#85,#01,#01 ; #8460 ................
db #96,#01,#01,#F0,#F0,#00,#00,#00,#F0,#F0,#01,#01,#01,#F1,#01,#96 ; #8470 ................
db #01,#01,#01,#01,#96,#D2,#01,#01,#01,#01,#01,#01,#B5,#F0,#0C,#29 ; #8480 ...............)
db #00,#2B,#BB,#29,#00,#2B,#BF,#29,#00,#2B,#B9,#29,#0D,#01,#01,#01 ; #8490 .+.).+.).+.)....
db #01,#01,#20,#01,#01,#01,#01,#B5,#38,#B5,#20,#B5,#01,#01,#BB,#39 ; #84a0 .. .....8. ....9
db #BC,#39,#BA,#F1,#01,#20,#01,#01,#F1,#01,#20,#01,#01,#39,#01,#0C ; #84b0 .9... .... ..9..
LAB8500:
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#F4,#F4,#B2,#B2,#F1,#01,#01 ; #84c0 ................
db #01,#BC,#01,#01,#01,#01,#01,#BF,#1A,#1A,#1A,#01,#01,#01,#01,#01 ; #84d0 ................
db #01,#BF,#97,#97,#85,#01,#01,#86,#01,#01,#F1,#96,#F1,#01,#01,#01 ; #84e0 ................
db #96,#01,#F0,#F0,#00,#00,#00,#00,#00,#F0,#F0,#01,#01,#86,#97,#85 ; #84f0 ................
db #97,#97,#85,#97,#85,#01,#01,#01,#01,#B5,#F0,#01,#01,#01,#0C,#2A ; #8500 ...............*
db #00,#28,#BF,#2A,#00,#28,#BD,#2A,#00,#28,#BF,#2A,#0D,#01,#01,#01 ; #8510 .(.*.(.*.(.*....
db #01,#01,#01,#01,#01,#01,#38,#20,#38,#B5,#38,#01,#01,#01,#86,#86 ; #8520 ......8 8.8.....
db #39,#86,#BD,#01,#01,#01,#20,#01,#01,#01,#01,#01,#39,#01,#20,#0C ; #8530 9..... .....9. .

lab8580:
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B6,#B6,#B2,#B2,#B2,#F1,#01 ; #8540 ................
db #01,#01,#F1,#01,#01,#F1,#01,#01,#1A,#1A,#1A,#01,#01,#01,#01,#01 ; #8550 ................
db #01,#BF,#01,#01,#01,#01,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01 ; #8560 ................
db #96,#01,#F0,#F0,#00,#00,#00,#00,#00,#F0,#F0,#01,#01,#01,#01,#96 ; #8570 ................
db #F1,#01,#96,#01,#01,#B5,#F0,#01,#01,#81,#01,#B5,#F0,#01,#0C,#2B ; #8580 ...............+
db #BF,#29,#00,#2B,#BF,#29,#00,#2B,#BF,#29,#00,#2B,#0D,#01,#01,#01 ; #8590 .).+.).+.).+....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#20,#01,#39,#BB ; #85a0 ............ .9.
db #86,#BA,#39,#01,#01,#F1,#01,#01,#01,#01,#01,#01,#20,#01,#39,#0C ; #85b0 ..9......... .9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B6,#B6,#B2,#B2,#B2,#F1,#01 ; #85c0 ................
db #BC,#01,#01,#01,#BB,#01,#01,#01,#BC,#1A,#1A,#01,#01,#01,#BD,#97 ; #85d0 ................
db #97,#BF,#01,#01,#01,#01,#01,#01,#F1,#96,#F1,#01,#01,#01,#01,#01 ; #85e0 ................
db #96,#01,#01,#F0,#F0,#00,#00,#00,#F0,#F0,#01,#01,#01,#01,#01,#87 ; #85f0 ................
db #01,#01,#96,#F1,#01,#01,#01,#01,#B5,#F0,#01,#01,#01,#15,#0B,#28 ; #8600 ...............(
db #BF,#2A,#00,#28,#BC,#2A,#00,#28,#B9,#2A,#00,#28,#0D,#01,#01,#01 ; #8610 .*.(.*.(.*.(....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#86,#39 ; #8620 ...............9
db #20,#39,#BD,#01,#01,#01,#01,#F1,#01,#20,#01,#01,#01,#39,#20,#0C ; #8630  9....... ...9 .
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#F4,#F4,#B2,#B2,#F1,#B9,#01 ; #8640 ................
db #F1,#F1,#01,#F1,#01,#01,#01,#01,#BB,#1A,#1A,#1A,#01,#01,#01,#01 ; #8650 ................
db #01,#BF,#97,#85,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01,#01,#F1 ; #8660 ................
db #B6,#F1,#01,#01,#F0,#F0,#00,#F0,#F0,#01,#01,#01,#01,#F1,#01,#01 ; #8670 ................
db #85,#97,#85,#97,#85,#01,#01,#01,#01,#01,#01,#01,#0B,#2B,#B9,#29 ; #8680 .............+.)
db #00,#2B,#BC,#29,#00,#2B,#BA,#29,#00,#2B,#BD,#29,#0D,#01,#20,#01 ; #8690 .+.).+.).+.).. .
db #01,#01,#01,#01,#20,#01,#38,#B5,#38,#B5,#38,#81,#01,#01,#86,#BC ; #86a0 .... .8.8.8.....
db #39,#86,#BC,#20,#01,#01,#01,#01,#01,#01,#01,#01,#39,#01,#01,#0C ; #86b0 9.. ........9...
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B2,#B2,#B2,#F1,#01,#F1,#01 ; #86c0 ................
db #01,#BB,#01,#01,#BA,#01,#01,#01,#1A,#1A,#1A,#1A,#BF,#01,#01,#85 ; #86d0 ................
db #97,#BF,#01,#01,#01,#01,#F1,#96,#F1,#01,#01,#01,#01,#01,#01,#B6 ; #86e0 ................
db #B6,#B6,#01,#01,#01,#F0,#F0,#F0,#01,#01,#01,#01,#01,#01,#01,#01 ; #86f0 ................
db #96,#F1,#96,#01,#01,#01,#B5,#F0,#01,#01,#01,#0C,#00,#28,#BB,#2A ; #8700 .............(.*
db #00,#28,#BF,#2A,#00,#28,#BF,#2A,#00,#28,#BA,#2A,#0D,#01,#01,#01 ; #8710 .(.*.(.*.(.*....
db #01,#01,#01,#01,#01,#01,#01,#20,#20,#B5,#38,#B5,#01,#01,#39,#BA ; #8720 .......  .8...9.
db #86,#BA,#86,#01,#01,#20,#01,#01,#01,#01,#F1,#01,#01,#20,#39,#0C ; #8730 ..... ....... 9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#F4,#B2,#B2,#F4,#01,#01,#01,#01 ; #8740 ................
db #01,#01,#F1,#01,#01,#01,#01,#01,#1A,#1A,#1A,#1A,#01,#01,#01,#01 ; #8750 ................
db #01,#BF,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01,#01,#F1,#B6,#B6 ; #8760 ................
db #B6,#B6,#B6,#F1,#01,#01,#01,#01,#01,#01,#01,#01,#F1,#01,#01,#01 ; #8770 ................
db #87,#01,#96,#01,#01,#01,#01,#01,#81,#B5,#F0,#0C,#BF,#29,#00,#2B ; #8780 .............).+
db #BC,#29,#00,#2B,#BF,#29,#00,#2B,#BF,#29,#00,#2B,#0D,#01,#01,#01 ; #8790 .).+.).+.).+....
db #01,#20,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#86,#39 ; #87a0 . .............9
db #BB,#39,#BB,#01,#01,#01,#01,#01,#20,#01,#01,#01,#01,#39,#01,#0C ; #87b0 .9...... ....9..



lvltxt:
lab8800:
db #54,#6F,#20,#62,#6F,#6C,#64,#6C,#79,#20,#67,#6F,#2E,#2E,#2E,#2E ; #87c0 To boldly go....
db #77,#61,#74,#63,#68,#20,#79,#6F,#75,#72,#20,#74,#61,#69,#6C,#20 ; #87d0 watch your tail 
db #62,#72,#69,#67,#68,#74,#20,#69,#73,#27,#6E,#74,#20,#69,#74,#21 ; #87e0 bright is''nt it!
db #FF
lvl1txt:
db #20,#20,#20,#20,#4F,#75,#74,#70,#6F,#73,#74,#20,#20,#20,#20     ; #87f1     Outpost    
db #20,#47,#69,#76,#65,#20,#27,#65,#6D,#20,#68,#65,#6C,#6C,#2E,#2E ; #8800  Give ''em hell..
db #2E,#FF
lvl2txt:
db #50,#6C,#61,#6E,#65,#74,#20,#6F,#66,#20,#46,#72,#75,#69         ; #8812 Planet of Frui
db #74,#20,#20,#5A,#61,#70,#20,#74,#68,#65,#20,#63,#72,#6F,#70,#73 ; #8820 t  Zap the crops
db #FF
db #20,#20,#20,#54,#61,#6B,#69,#6E,#67,#20,#74,#68,#65,#20,#20     ; #8831    Taking the  
db #20,#20,#20,#20,#20,#55,#52,#49,#4E,#45,#49,#55,#4D,#FF,#20,#20 ; #8840      URINEIUM.  
db #20,#52,#69,#76,#65,#72,#77,#6F,#72,#6C,#64,#20,#20,#20,#FF,#20 ; #8850  Riverworld   . 
db #20,#49,#20,#64,#6F,#6E,#27,#74,#20,#74,#68,#69,#6E,#6B,#20,#74 ; #8860  I don''t think t
db #68,#65,#79,#20,#6C,#69,#6B,#65,#20,#79,#6F,#75,#2E,#2E,#2E,#FF ; #8870 hey like you....
db #49,#6E,#73,#70,#69,#72,#61,#74,#69,#6F,#6E,#73,#20,#45,#6E,#64 ; #8880 Inspirations End
db #FF,#20,#20,#20,#47,#72,#69,#64,#77,#6F,#72,#6C,#64,#20,#20,#20 ; #8890 .   Gridworld   
db #20,#20,#20,#57,#61,#74,#63,#68,#20,#6F,#75,#74,#20,#66,#6F,#72 ; #88a0    Watch out for
db #20,#69,#6E,#76,#69,#6E,#63,#69,#62,#6C,#65,#20,#70,#6F,#64,#73 ; #88b0  invincible pods
db #21,#FF,#46,#72,#65,#69,#67,#68,#74,#65,#72,#20,#43,#6F,#6E,#76 ; #88c0 !.Freighter Conv
db #6F,#79,#20,#42,#6C,#61,#73,#74,#20,#74,#68,#65,#20,#63,#61,#72 ; #88d0 oy Blast the car
db #67,#6F,#FF,#53,#69,#6E,#6B,#69,#6E,#67,#20,#20,#46,#65,#65,#6C ; #88e0 go.Sinking  Feel
db #69,#6E,#67,#20,#59,#6F,#75,#20,#6D,#61,#79,#20,#6E,#6F,#74,#69 ; #88f0 ing You may noti
db #63,#65,#20,#73,#6F,#6D,#65,#74,#68,#69,#6E,#67,#20,#66,#75,#6E ; #8900 ce something fun
db #6E,#79,#21,#FF,#41,#6E,#6F,#74,#68,#65,#72,#20,#20,#6F,#75,#74 ; #8910 ny!.Another  out
db #70,#6F,#73,#74,#74,#68,#65,#72,#65,#27,#73,#20,#61,#20,#6C,#6F ; #8920 postthere''s a lo
db #74,#20,#6F,#66,#20,#63,#72,#6F,#73,#73,#66,#69,#72,#65,#20,#6F ; #8930 t of crossfire o
db #75,#74,#20,#20,#20,#20,#20,#20,#20,#20,#74,#68,#65,#72,#65,#20 ; #8940 ut        there 
db #20,#20,#20,#20,#FF,#4F,#70,#74,#69,#63,#61,#6C,#20,#49,#6C,#6C ; #8950     .Optical Ill
db #75,#73,#69,#6F,#6E,#20,#74,#72,#79,#20,#73,#75,#6E,#67,#6C,#61 ; #8960 usion try sungla
db #73,#73,#65,#73,#20,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #8970 sses ...........
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #8980 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #8990 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #89a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #89b0 ................


; #8a00

db #00,#00,#00,#00,#00,#00,#00,#00,#38,#38,#B6,#B6,#38,#97,#97,#BC ; #89c0 ........88..8...
db #01,#96,#03,#02,#02,#01,#01,#01,#03,#02,#02,#03,#02,#01,#03,#02 ; #89d0 ................
db #02,#03,#03,#87,#01,#01,#01,#02,#01,#01,#03,#01,#03,#0B,#00,#0D ; #89e0 ................
db #01,#01,#02,#01,#02,#02,#03,#02,#03,#01,#01,#B9,#01,#01,#01,#02 ; #89f0 ................
db #01,#01,#01,#85,#97,#85,#97,#38,#38,#38,#00,#00,#00,#00,#38,#B5 ; #8a00 .......888....8.
db #38,#03,#03,#03,#03,#02,#96,#01,#03,#02,#87,#B5,#B5,#01,#87,#01 ; #8a10 8...............
db #0C,#00,#00,#0D,#02,#03,#01,#96,#01,#96,#02,#01,#01,#96,#02,#01 ; #8a20 ................
db #03,#02,#01,#02,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C ; #8a30 ................


db #00,#00,#00,#00,#00,#00,#00,#00,#38,#B6,#38,#B6,#38,#97,#97,#B9 ; #8a40 ........8.8.8...
db #97,#85,#03,#01,#02,#02,#01,#01,#01,#01,#01,#02,#02,#01,#01,#02 ; #8a50 ................
db #01,#02,#03,#02,#02,#03,#03,#01,#03,#87,#02,#03,#0C,#00,#00,#0D ; #8a60 ................
db #01,#02,#03,#03,#02,#03,#02,#01,#01,#01,#02,#96,#02,#B9,#01,#03 ; #8a70 ................
db #01,#01,#03,#96,#02,#96,#01,#03,#03,#01,#0A,#00,#00,#00,#11,#01 ; #8a80 ................
db #02,#01,#03,#86,#02,#02,#BA,#01,#03,#87,#01,#38,#38,#87,#01,#03 ; #8a90 ...........88...
db #0C,#00,#00,#0D,#01,#03,#02,#85,#01,#96,#01,#01,#01,#96,#03,#01 ; #8aa0 ................
db #03,#01,#02,#B9,#02,#0A,#00,#00,#00,#00,#00,#00,#00,#10,#BB,#0B ; #8ab0 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#38,#38,#38,#02,#01,#03,#01 ; #8ac0 .........888....
db #01,#02,#01,#01,#03,#01,#03,#B5,#97,#85,#01,#01,#02,#01,#01,#02 ; #8ad0 ................
db #03,#02,#01,#03,#02,#01,#03,#01,#01,#96,#01,#01,#0B,#00,#00,#0D ; #8ae0 ................
db #01,#02,#01,#02,#03,#03,#01,#03,#01,#01,#03,#96,#03,#96,#02,#01 ; #8af0 ................
db #01,#01,#02,#B9,#97,#B9,#03,#01,#01,#01,#01,#0A,#00,#00,#00,#11 ; #8b00 ................
db #02,#02,#03,#01,#03,#01,#01,#03,#01,#03,#87,#03,#87,#01,#87,#01 ; #8b10 ................
db #B9,#00,#00,#0D,#03,#01,#03,#03,#03,#B5,#01,#85,#97,#85,#97,#85 ; #8b20 ................
db #01,#02,#01,#02,#03,#B9,#0A,#00,#00,#10,#14,#0A,#00,#11,#0B,#00 ; #8b30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#01,#01,#03,#01,#03,#01,#01 ; #8b40 ................
db #01,#01,#01,#02,#02,#02,#01,#02,#01,#03,#02,#01,#01,#01,#03,#01 ; #8b50 ................
db #01,#03,#01,#02,#01,#01,#02,#01,#01,#87,#01,#0C,#00,#00,#10,#02 ; #8b60 ................
db #02,#01,#03,#02,#03,#02,#01,#03,#03,#01,#02,#96,#02,#96,#03,#03 ; #8b70 ................
db #03,#02,#02,#02,#01,#01,#03,#01,#01,#01,#01,#01,#0A,#00,#00,#00 ; #8b80 ................
db #11,#02,#03,#01,#01,#02,#03,#01,#01,#87,#01,#87,#03,#87,#01,#03 ; #8b90 ................
db #0C,#00,#00,#0D,#02,#01,#03,#02,#03,#01,#03,#01,#02,#02,#03,#01 ; #8ba0 ................
db #03,#B9,#03,#03,#02,#02,#02,#0A,#00,#0D,#BC,#0C,#00,#00,#00,#00 ; #8bb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#03,#02,#02,#01,#03,#01,#03 ; #8bc0 ................
db #01,#01,#03,#96,#01,#02,#96,#01,#01,#01,#02,#B9,#01,#0B,#10,#01 ; #8bd0 ................
db #01,#01,#02,#01,#02,#03,#9B,#02,#01,#1A,#1A,#1A,#1A,#01,#03,#02 ; #8be0 ................
db #01,#38,#98,#38,#02,#03,#01,#01,#03,#02,#01,#01,#01,#01,#01,#01 ; #8bf0 .8.8............
db #01,#01,#01,#01,#99,#01,#03,#98,#01,#01,#02,#02,#01,#01,#01,#01 ; #8c00 ................
db #B2,#98,#99,#01,#01,#01,#01,#01,#03,#01,#01,#01,#1A,#01,#03,#01 ; #8c10 ................
db #99,#03,#01,#01,#99,#01,#01,#01,#01,#03,#B6,#97,#B2,#00,#0D,#1A ; #8c20 ................
db #B2,#1A,#1A,#1A,#01,#01,#03,#03,#01,#01,#01,#1A,#1A,#1A,#1A,#0C ; #8c30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#86,#B9,#BB,#B9,#86,#B9 ; #8c40 ................
db #02,#01,#01,#96,#03,#01,#96,#01,#01,#01,#01,#01,#0B,#10,#01,#B9 ; #8c50 ................
db #97,#B9,#01,#01,#9B,#03,#01,#01,#02,#03,#1A,#1A,#1A,#01,#01,#B2 ; #8c60 ................
db #38,#98,#1A,#99,#38,#03,#01,#01,#01,#02,#01,#01,#01,#01,#BB,#86 ; #8c70 8...8...........
db #BC,#86,#01,#01,#01,#02,#01,#01,#02,#01,#01,#02,#01,#03,#01,#01 ; #8c80 ................
db #B6,#98,#99,#98,#01,#01,#03,#01,#99,#01,#01,#01,#1A,#1A,#03,#01 ; #8c90 ................
db #01,#B2,#01,#98,#01,#01,#01,#01,#01,#02,#02,#01,#0B,#00,#0D,#1A ; #8ca0 ................
db #1A,#1A,#1A,#1A,#01,#9B,#9B,#03,#9B,#01,#01,#B2,#1A,#1A,#1A,#0C ; #8cb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#B9,#1A,#13,#1A,#13,#1A,#BB ; #8cc0 ................
db #01,#86,#97,#86,#01,#01,#96,#01,#01,#01,#01,#01,#0A,#11,#01,#01 ; #8cd0 ................
db #02,#96,#01,#01,#01,#01,#01,#01,#03,#1A,#B2,#1A,#1A,#01,#01,#01 ; #8ce0 ................
db #01,#38,#99,#38,#02,#01,#03,#01,#01,#01,#01,#01,#01,#01,#86,#99 ; #8cf0 .8.8............
db #98,#86,#01,#01,#03,#01,#99,#01,#99,#98,#BA,#01,#01,#01,#01,#01 ; #8d00 ................
db #01,#01,#99,#01,#01,#03,#01,#B6,#B2,#1A,#01,#02,#1A,#1A,#1A,#01 ; #8d10 ................
db #03,#96,#99,#98,#03,#99,#01,#02,#01,#01,#01,#0C,#00,#10,#01,#01 ; #8d20 ................
db #03,#02,#1A,#02,#03,#9B,#9B,#9B,#9B,#9B,#01,#9B,#1A,#1A,#1A,#0C ; #8d30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#13,#1A,#13,#1A,#13,#B9 ; #8d40 ................
db #01,#96,#01,#96,#01,#01,#96,#01,#01,#01,#B9,#03,#0B,#10,#01,#01 ; #8d50 ................
db #01,#96,#02,#01,#01,#01,#01,#01,#01,#1A,#1A,#1A,#1A,#01,#01,#01 ; #8d60 ................
db #01,#01,#38,#03,#01,#38,#01,#03,#01,#02,#03,#B6,#97,#97,#86,#98 ; #8d70 ..8..8..........
db #99,#86,#01,#01,#98,#99,#01,#98,#01,#01,#01,#01,#01,#01,#01,#01 ; #8d80 ................
db #01,#01,#01,#98,#99,#01,#01,#B6,#B2,#1A,#03,#02,#B2,#B6,#1A,#01 ; #8d90 ................
db #01,#96,#99,#01,#98,#01,#01,#B2,#01,#99,#01,#0C,#00,#0D,#01,#B2 ; #8da0 ................
db #02,#1A,#1A,#03,#03,#9B,#B9,#BB,#9B,#9B,#01,#1A,#1A,#1A,#1A,#0C ; #8db0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#BC,#1A,#13,#1A,#13,#1A,#BC ; #8dc0 ................
db #01,#96,#02,#96,#01,#01,#96,#01,#02,#01,#03,#0B,#10,#01,#B9,#97 ; #8dd0 ................
db #97,#B9,#97,#B6,#01,#01,#03,#9B,#01,#1A,#1A,#1A,#1A,#03,#01,#02 ; #8de0 ................
db #01,#02,#01,#01,#38,#1A,#38,#01,#01,#01,#01,#01,#01,#01,#BA,#86 ; #8df0 ....8.8.........
db #86,#86,#01,#01,#01,#BC,#02,#02,#01,#99,#01,#01,#01,#03,#01,#01 ; #8e00 ................
db #01,#02,#98,#99,#01,#01,#01,#98,#01,#02,#B6,#98,#1A,#1A,#1A,#01 ; #8e10 ................
db #03,#B6,#98,#99,#01,#99,#01,#03,#99,#01,#01,#0C,#00,#0D,#01,#1A ; #8e20 ................
db #1A,#02,#1A,#01,#9B,#9B,#B2,#9B,#9B,#9B,#01,#1A,#1A,#1A,#1A,#0C ; #8e30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#B9,#13,#1A,#13,#1A,#13,#B9 ; #8e40 ................
db #01,#86,#97,#86,#02,#02,#BD,#01,#01,#03,#01,#0A,#11,#01,#01,#01 ; #8e50 ................
db #9B,#96,#01,#01,#01,#9B,#01,#01,#01,#1A,#1A,#1A,#1A,#03,#01,#01 ; #8e60 ................
db #01,#01,#B2,#38,#1A,#99,#1A,#38,#01,#01,#01,#01,#01,#01,#01,#01 ; #8e70 ...8...8........
db #96,#01,#01,#01,#02,#01,#98,#BB,#01,#01,#03,#01,#03,#01,#01,#01 ; #8e80 ................
db #01,#01,#B6,#B2,#98,#01,#01,#01,#01,#01,#96,#1A,#1A,#1A,#01,#01 ; #8e90 ................
db #01,#B6,#97,#97,#B2,#99,#03,#99,#98,#01,#01,#B2,#00,#11,#02,#01 ; #8ea0 ................
db #01,#01,#02,#01,#9B,#9B,#9B,#9B,#9B,#9B,#01,#1A,#1A,#9B,#1A,#0C ; #8eb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#BA,#1A,#13,#1A,#13,#1A,#86 ; #8ec0 ................
db #03,#01,#02,#96,#01,#01,#96,#01,#03,#B9,#02,#0B,#10,#03,#02,#01 ; #8ed0 ................
db #02,#96,#01,#02,#01,#01,#01,#01,#01,#B2,#03,#1A,#1A,#01,#01,#01 ; #8ee0 ................
db #01,#03,#01,#03,#38,#1A,#38,#01,#01,#03,#01,#01,#03,#01,#01,#03 ; #8ef0 ....8.8.........
db #96,#01,#01,#01,#99,#01,#01,#01,#01,#98,#01,#01,#01,#01,#01,#02 ; #8f00 ................
db #01,#99,#99,#98,#98,#01,#01,#01,#01,#01,#B2,#1A,#1A,#1A,#01,#01 ; #8f10 ................
db #02,#01,#99,#98,#01,#03,#01,#01,#01,#01,#02,#96,#0A,#00,#0D,#1A ; #8f20 ................
db #B2,#9B,#9B,#01,#9B,#9B,#9B,#9B,#9B,#9B,#9B,#1A,#1A,#1A,#1A,#0C ; #8f30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#B9,#86,#B9,#BA,#B9,#86 ; #8f40 ................
db #01,#01,#01,#96,#01,#01,#96,#01,#01,#02,#0B,#10,#03,#B9,#97,#97 ; #8f50 ................
db #97,#B9,#03,#01,#01,#01,#9B,#01,#01,#1A,#03,#1A,#03,#01,#01,#01 ; #8f60 ................
db #01,#02,#01,#03,#01,#38,#01,#01,#01,#01,#01,#02,#02,#01,#02,#01 ; #8f70 .....8..........
db #B6,#03,#01,#01,#01,#01,#01,#99,#02,#01,#01,#01,#01,#01,#01,#01 ; #8f80 ................
db #01,#98,#98,#99,#01,#99,#99,#01,#03,#01,#03,#1A,#1A,#1A,#01,#01 ; #8f90 ................
db #01,#01,#01,#01,#01,#01,#01,#03,#03,#03,#01,#B6,#0C,#00,#0D,#1A ; #8fa0 ................
db #1A,#9B,#9B,#9B,#01,#01,#01,#01,#03,#9B,#9B,#1A,#1A,#1A,#1A,#0C ; #8fb0 ................

; Main Menu
lab9000 jp lab9E18

db #05,#07,#00,#00,#00,#00,#00,#05,#00,#00,#00,#00,#09 
db #00,#01,#00,#00,#00

; DRAW Tile
; MENU, 
; Landscape (when redrawing the full screen)
; Destroyed landscape
; DE = Source
; HL = Dest
drawtile:
.loop
    push bc
    push hl
.loopline:
    ld a,(de)
    and #cc
    ld c,a 
    ld a,(hl)
    and #33
    or c
    ld (hl),a
    inc l
    ld a,(de)
    ADD A
    ADD A
    and #cc
    ld c,a 
    ld a,(hl)
    and #33
    or c
    ld (hl),a
    inc e
    inc l
    djnz .loopline
    pop hl
    ld bc,#0800   ; Next Line
    add hl,bc
    jr nc,.noovf
    ld bc,#c040
    add hl,bc
    res 3,h
.noovf
    pop bc
    dec c
    jr nz,.loop
    ret 
    nop

; Init
; - Configure IT
lab9043: 
    ld hl,#007F
    ld (lab90C9),hl
    ld de,labA3F3
    ld (next_IT),de
    xor a
    ld (lab90CD),a
    ld a,(#0038+1)
    cp #39
    jr z,lab906A
    ld hl,lab90D0
    ld c,#0
    ld b,#c1
    call #BD19 ; Wait VBL
    call #BCE0 ; KL NEW FAST TICKER
    jr lab9070
lab906A call #BD19
    call labA3C6
lab9070 call #BC0B ;  SCR GET LOCATION
    ld (lab90CB),hl
    ld hl,lab90D9
    ld c,#ff
    ld b,#80
lab907D ld de,lab9117
    call #BCD7 ;  KL NEW FRAME FLY
    call lab949F
    call lab9497
lab9089 ld a,#2
    ld (lab90E5),a
    ld a,#6
lab9090 ld (lab90EE),a
    ld a,NUMLIFE
    ld (LIFE_CNT),a
    ld a,#2
    ld (lab90F4),a
    ld l,#64
    ld h,#7c
    ld (lab90E2),hl
    xor a
    ld (lab90C2),a
    ld (lab90C3),a
    ld (lab90E4),a
    ld (lab90EB),a
    ld hl,#ffff
    ld (lab90C4),hl
    call lab95EA
    call lab9588
    call lab9451
    ret 

LIFE_CNT:  db 3   

lab90C2 db 0
lab90C3 db 0
lab90C4 db #ff
lab90C5 db #ff
lab90C6 add a,b
lab90C7 nop
    nop
lab90C9 djnz lab90CB
lab90CB nop
    ret nz
lab90CD ld bc,#0101
lab90D0 nop
    nop
    nop
    nop
    nop
    pop bc
next_IT:
	dw LABa508
	;ex af,af''
    ;and l
    nop
lab90D9 nop
    nop
    nop
    nop
    nop
    add a,b
    rla 
    sub c
    db #ff
lab90E2 db ''d'' ; #64
lab90E3 ld a,h
lab90E4 nop
lab90E5 ld (bc),a
lab90E6 nop
lab90E7 nop
lab90E8 nop
lab90E9 nop
    ld a,h
lab90EB nop
lab90EC nop
lab90ED nop
lab90EE ld b,#0
    nop
lab90F1 nop
lab90F2 nop
lab90F3 nop
lab90F4 ld (bc),a
lab90F5 db #ff
lab90F6 db #ff
lab90F7 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9101 nop
    nop
    nop
    nop
lab9105 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9117 call labA467
    ld a,(lab90C6)
    and a
    ret nz
    ld a,(lab90E4)
    and a
    jr z,lab9151
    jp p,lab9151
    bit 6,a
    jr nz,lab912F
    dec a
    jr lab9136
lab912F inc a
    cp #87
    jr nz,lab9136
    and #bf
lab9136 ld (lab90E4),a
    srl a
    and #6
    xor #6
    srl a
    ld l,#0
    srl a
    rr l
    add a,#7a
    ld h,a
    ld bc,(lab90E2)
    jp lab921F
lab9151 ld a,(lab90E7)
    ld e,a
    call lab9A26
    and #10
    ld (lab90E7),a
    cp e
    jr z,lab917D
    jr c,lab917D
    ld a,(lab90F1)
    and a
    jr nz,lab917D
    ld bc,(lab90E2)
    ld a,c
    sub #10
    ld c,a ; ''O''
    ld a,b
    add a,#6
    ld b,a
    ld (lab90EE+1),bc
    ld a,#63
    ld (lab90F1),a
lab917D ld a,(lab90E8)
    and a
    jr nz,lab9187
    bit 4,h
    jr z,lab91AA
lab9187 ld a,(lab90EB)
    and a
    jr nz,lab91AA
    ld bc,(lab90E2)
    ld a,c
    sub #10
    ld c,a ; ''O''
    ld a,b
    add a,#6
    ld b,a
    ld (lab90E9),bc
    ld a,#ff
    ld (lab90EB),a
    push hl
    ld hl,lab9508
    call lab9489
    pop hl
lab91AA xor a
    ld (lab90E6),a
    ld a,(lab90E5)
    ld l,a ; ''o''
    ld bc,(lab90E2)
    ld e,c
    ld d,b ; ''P''
    bit 0,h
    jr z,lab91C7
    ld a,e
    cp #21
    jr c,lab91D8
    ld a,c
    sub l
    ld c,a ; ''O''
    ld a,e
    sub l
    ld e,a
lab91C7 bit 1,h
    jr z,lab91D8
    ld a,e
    cp #cb
    jr nc,lab91D8
    ld a,#e8
    ld (lab90E6),a
    ld a,e
    add a,l
    ld e,a
lab91D8 bit 2,h
    jr z,lab91E7
    ld a,d
    and #fc
    jr z,lab91E7
    ld a,b
    sub l
    ld b,a
    ld a,d
    sub l
    ld d,a
lab91E7 bit 3,h
    jr z,lab91FA
    ld a,d
    cp #e8
    jr nc,lab91FA
    ld a,(lab90E6)
    dec a
    ld (lab90E6),a
    ld a,d
    add a,l
    ld d,a
lab91FA ld (lab90E2),de
lab91FE ld a,(lab90E6)
lab9201 ld l,a ; ''o''
lab9202 ld a,b
lab9203 and #2
    db #f ; RRCA 
    db #f ; RRCA 
    xor l
    ld l,a ; ''o''
    ld h,#76
    ld a,(lab90C3)
    and a
    jr z,lab921F
    cp #ff
    jr z,lab9219
    dec a
    ld (lab90C3),a
lab9219 and #4
    jr z,lab921F
    inc h
    inc h
lab921F ld e,l
    ld d,h
    call lab9CDA
    ld b,#15
    call lab9F7A
    ld hl,(lab90EC)
    ld a,h
    cp #c0
    jr c,lab923A
    ld b,#c
    call lab9DF2
    xor a
    ld (lab90ED),a
lab923A ld a,(lab90EB)
    and a
    jr z,lab9260
    ld bc,(lab90E9)
    call lab9CDA
    ld (lab90EC),hl
    ld de,#7960
    ld b,#c
    call lab9C11
    ld a,(lab90EE)
    ld b,a
    ld a,(lab90E9)
    sub b
    ld (lab90E9),a
    call c,lab929F
lab9260 ld hl,(lab90F2)
    ld a,h
    cp #c0
    jr c,lab9271
    ld b,#c
    call lab9DF2
    xor a
    ld (lab90F3),a
lab9271 ld a,(lab90F1)
    and a
    jr z,lab92EF
    dec a
    ld (lab90F1),a
    ld bc,(lab90EE+1)
    call lab9CDA
    ld (lab90F2),hl
    ld de,#7940
    ld b,#c
    call lab9C11
    ld a,(lab90F4)
    ld b,a
lab9291 ld a,(lab90EE+1)
    sub b
lab9295 ld (lab90EE+1),a
    jr nc,lab92A4
lab929A xor a
    ld (lab90F1),a
    ret 
lab929F xor a
    ld (lab90EB),a
    ret 
lab92A4 ld hl,(lab90EE+1)
    ld a,l
    add a,#10
    ld l,a ; ''o''
    call lab9CB8
    jr nc,lab92EF
    jp p,lab92EF
    ld e,a
    and #3f
    cp #3f
    jr nz,lab92BE
    ld a,#f4
    jr lab92CB
lab92BE cp #39
    jr nz,lab92CE
    ld a,r
    and #2
    neg
    add a,e
    and #3f
lab92CB ld (hl),a
    jr lab92DA
lab92CE cp #37
    ld (hl),a
    jr nc,lab92DA
    ld (hl),#20
    bit 6,e
    jr z,lab92DA
    ld (hl),e
lab92DA ld de,lab9000+3
    call lab95B5
    ld hl,(lab9CB6)
    call lab9D2A
    ld hl,lab94FF
    call lab9489
    jp lab929A
lab92EF ld a,(lab90E4)
    and #80
    ret nz
    ld hl,(lab90E2)
    ld de,#0A0A
    add hl,de
    call lab9CB8
    ret nc
    ret m
lab9301 cp #37
    ret c
    cp #38
    ret z
    ld (hl),#38
    cp #37
    jr nz,lab9321
    ld a,(lab90C5)
    add a,#80
    ld (lab90C5),a
    jp nc,lab9408
    ld hl,#ffff
    ld (lab90C4),hl
    jp lab9408
lab9321 cp #39
    jr nz,lab9361
    ld b,#3
    ld a,r
    and #7f
    cp #28
    jr nc,lab9340
lab932F ld a,(lab90F4)
    sub #2
    jr nz,lab936E
    djnz lab9344
    jp lab9408
lab933B djnz lab932F
    jp lab9408
lab9340 cp #50
    jr nc,lab9350
lab9344 ld a,(lab90E5)
    dec a
    cp #2
    jr nc,lab938E
    dec b
    jp z,lab9408
lab9350 ld a,(lab90EE)
    cp #6
    jr z,lab933B
    sub #3
    cp #6
    jr nc,lab93B0
    ld a,#6
    jr lab93B0
lab9361 cp #3a
    jr nz,lab9382
    ld a,(lab90F4)
    add a,#2
    cp #7
    jr nc,lab93CD
lab936E call lab9374
    jp lab93ED
lab9374 ld (lab90F4),a
    sub #2
    ld l,a ; ''o''
    ADD A
    add a,l
    ld hl,#7F26+1
    jp lab9421
lab9382 cp #3b
    jr nz,lab93A3
    ld a,(lab90E5)
    inc a
    cp #5
    jr nc,lab93CD
lab938E call lab9394
    jp lab93ED
lab9394 ld (lab90E5),a
    sub #2
    ld l,a ; ''o''
    ADD A
    add a,l
    ADD A
    ld hl,#7F2E+1
    jp lab9421
lab93A3 cp #3c
    jr nz,lab93C2
    ld a,(lab90EE)
    add a,#3
    cp #d
    jr nc,lab93CD
lab93B0 call lab93B6
    jp lab93ED
lab93B6 ld (lab90EE),a
    sub #6
    ADD A
    ld hl,#7F2B
    jp lab9421
lab93C2 cp #3d
    jr nz,lab9408
    ld a,#ff
    ld (lab90C3),a
    jr lab9408
lab93CD ld a,(lab90C2)
    inc a
    cp #c
    ld (lab90C2),a
    jr c,lab93ED
    xor a
    ld (lab90C2),a
    ld a,(LIFE_CNT)
    inc a
    cp #a
    jr nc,lab93ED
    ld (LIFE_CNT),a
    call lab9588
    call lab952C
lab93ED ld de,lab9000+#0F
    call lab95B5
    ld a,(lab90C5)
    add a,#40
    ld (lab90C5),a
    jr nc,lab9402
    ld a,#ff
lab93FF ld (lab90C5),a
lab9402 ld a,(lab90C5)
    call lab940F
lab9408 ld hl,(lab9CB6)
    call lab9D2A
    ret 
lab940F srl a
    srl a
    srl a
    cp #18
    jr c,lab941B
    ld a,#18
lab941B ld hl,#7F33+1
    jp lab9422
lab9421 ADD A
lab9422 ld c,a ; ''O''
    ld a,#18
    sub c
    ld de,#07FF
    jr z,lab9436
    ld b,a
    ld a,#cc
lab942E ld (hl),a
    inc hl
    ld (hl),a
    call lab9445
    djnz lab942E
lab9436 ld b,c
    ld a,c
    and a
    ret z
    ld a,#c0
lab943C ld (hl),a
    inc hl
    ld (hl),a
    call lab9445
    djnz lab943C
    ret 
lab9445 and a
    adc hl,de
    ret p
    ld de,#c040
    add hl,de
    ld de,#07FF
    ret 
lab9451 xor a
    ld hl,#7F26+1
    call lab9421
    xor a
    ld hl,#7F2B
    call lab9421
    xor a
    ld hl,#7F2E+1
    call lab9421
    ld a,#c
    ld hl,#7F33+1
    jr lab9421
lab946D ld a,(lab90E5)
    dec a
    cp #1
    call nz,lab9394
    ld a,(lab90EE)
    sub #3
    cp #6
    call nc,lab93B6
    ld a,(lab90F4)
    sub #2
    jp nz,lab9374
    ret 
lab9489 push af
    push bc
    push de
    push ix
    call #BCAA ;  SOUND QUEUE
    pop ix
    pop de
    pop bc
    pop af
    ret 

; --------
; Setup enveloppe
lab9497 ld de,#BCBF ; SOUND TONE ENVELOPE
    ld hl,lab94E3
    jr lab94A5
lab949F ld de,#BCBC ; SOUND Ampl ENVELOPE
    ld hl,lab94C3
lab94A5 ld (lab94B3+1),de
    ld b,#1
lab94AB ld a,(hl)
    and #7f
    ret z
    ld c,a 
    ld a,b
    push bc
    push hl
lab94B3 call #BCBF ; SOUND TONE ENVELOPE
    pop hl
    pop bc
    inc b
    ld a,c
    add c
    add c
    inc a
    ld e,a
    ld d,#0
    add hl,de
    jr lab94AB


; Amplitude Envelope Data
lab94C3:
db #03,#00,#0F,#01,#03,#FF,#05,#04,#FD,#0A,#03,#00,#04,#01,#04,#02
db #01,#0C,#FF,#03,#01,#0F,#FF,#0A,#02,#00,#0F,#01,#07,#FE,#01,#00
lab94E3
db #81,#01,#20,#01,#85,#F0,#32,#05,#F0,#29,#05,#F0,#1C,#03,#F0,#34
db #04,#08,#FC,#01,#82,#07,#0A,#01,#00,#AC,#01,#00

lab94ff
db #81,#01,#01,#80, #00,#1F,#00,#00,#00

/*
 Data audio
*/
; Channel, Voluime, Tone env, Tone period1,Tone period2, noise, start volume, duration
; Son du tir
lab9508: db #82,#02,#01,#14,#00,#00,#00,#00,#00

lab9511: db #84,#03,#02,#00,#00,#00,#0F,#00,#00

lab951A: db #81,#04,#00,#00,#00,#0C,#00,#00,#00

lab9523: db #84,#03,#03,#64,#00,#00,#0F,#00,#00

lab952C ld hl,lab9511
    jp lab9489
lab9532 ld hl,lab9523
    jp lab9489
; Variation du son avec r 
lab9538 ld hl,lab951A
    ld a,r
    and #f
    add a,#c
    ld (lab951A+5),a
    jp lab9489
lab9547 ret 


DRAW_HUD_NUMBERS:
lab9548 push bc ; Routine d''affichage des chiffres dans le HUD
    push hl
lab954A ld a,(de)
    RRCA 
    RRCA 
    and #33
    ld (hl),a
    inc l
    ld a,(de)
    and #33
    ld (hl),a
    inc l
    inc de
    djnz lab954A

    pop hl
    ld bc,#0800 ; Ligne suivante
    add hl,bc
    bit 6,h
    jr nz,lab9566
    ld bc,#c040
    add hl,bc
lab9566 pop bc
    dec c
    jr nz,lab9548
    ret 


lab956B push hl
    ld de,#7C30
    ld l,a 
    ld h,#0
    ADD A
    ADD A
    ADD A
    add a,l
    ADD A
    ld l,a ; ''o''
    add hl,hl
    add hl,hl
    add hl,de
    ex de,hl
    pop hl
    ld bc,#0318
    jr lab9548
lab9582 add a,b
    add a,b
lab9584 add a,b
    add a,b
lab9586 add a,b
lab9587 add a,b
lab9588 ld a,(LIFE_CNT)
    ld hl,#7739
    jr lab956B
lab9590 nop
lab9591 ld a,(lab9590)
    sbc a,#1
    jr nc,lab959A
    ld a,#5
lab959A ld (lab9590),a
    ld c,a ; ''O''
    ld hl,lab9587
    ld b,#0
    and a
    sbc hl,bc
    ld a,(hl)
    and a
    ret m
    set 7,(hl)
    ld hl,#7701
    sla c
    add hl,bc
    add hl,bc
    add hl,bc
    jr lab956B

lab95B5 ld hl,lab9582
    ld a,(lab9586)
    push af
    xor a
    ld b,#6
lab95BF ld a,(de)
    adc a,(hl)
    db #27
    ld c,a ; ''O''
    and #f
    ld (hl),a
    ld a,c
    and #1f
    add a,#f0
    inc hl
    inc de
    djnz lab95BF
    ld a,(lab9586)
    and #f
    ld c,a ; ''O''
    pop af
    and #f
    cp c
    ret z
    ld a,(LIFE_CNT)
    inc a
    cp #a
    ret nc
    ld (LIFE_CNT),a
    call lab952C
    jp lab9588
lab95EA ld hl,#0000
    ld (lab9582),hl
    ld (lab9584),hl
    ld (lab9586),hl
lab95F6 call lab95FC
    call lab95FC
lab95FC call lab9591
lab95FF call lab9591
lab9602 ret 
lab9603 nop

; Set level colors 
; A = level
lab9604 ADD A
    ADD A
    ADD A
    ld hl,lab9603
    add a,(hl)
    ld c,a 
    ld b,#0
    ld ix,#0100 ; Data des niveaux
    add ix,bc
    ld b,(ix+1)
    ld c,b
    push bc
    call #BC38 ; SCR SET BORDER
    pop bc
    xor a
    call #BC32 ; SCR SET INK
    bit 7,(ix+0)
    jr nz,lab962E
    call lab965C
    call lab9640
    ret 

lab962E 
    inc ix
    inc ix
    inc ix
    call lab9640
    ld bc,#fffa
    add ix,bc
    call lab965C
    ret 

; Set Color Palette 1
; IX = 
lab9640 ld a,#4
    ld c,#3
    ld b,#4
lab9646 push bc
    push af
    ld b,(ix+2)
    ld c,b
    call #BC32 ; SCR SET INK
    pop af
    inc a
    pop bc
    djnz lab9646
    inc ix
    ld b,#4
    dec c
    jr nz,lab9646
    ret

; Set Color Palette 2
; IX =     
lab965C ld a,#1
    ld c,#3
    ld b,#4
lab9662 push af
lab9663 push bc
    push af
    ld b,(ix+2)
    ld c,b
    call #BC32 ; SCR SET INK
    pop af
    add a,#4
    pop bc
    djnz lab9663
    inc ix
    pop af
    inc a
    ld b,#4
    dec c
    jr nz,lab9662
    ret 

lab967C 
    ld a,(lab9603)
    add #80
    ld (lab9603),a
    ld a,(curLevel)
    call lab9604
    xor a
    ret 

lab968C call lab95F6
    ld hl,lab9977
lab9692 ld de,lab9587
    ld b,#6
lab9697 ld a,(de)
    and #f
    ld c,a ; ''O''
    ld a,(hl)
    and #f
    cp c
    jr c,lab96A7
    ret nz
    dec hl
    dec de
    djnz lab9697
    ret 
lab96A7 call lab9547
    ld hl,lab9582
    ld de,lab9970+2
    ld b,#6
lab96B2 ld a,(hl)
    and #f
    ld (de),a
    inc hl
    inc de
    djnz lab96B2
    ld hl,lab9856+2
    jp lab96F8
lab96C0 ld hl,(lab90C7)
    push hl
    ld hl,#0000
    halt
    ld (lab90C7),hl
    ld hl,lab90C6
    inc (hl)
lab96CF call #BB1B ; KM READ KEY
    jr nc,lab96CF
    or #20
    cp #70
    jr z,lab96CF
    call #BB0C ; KM CHAR RETURN
    ld hl,lab90C6
    dec (hl)
    xor a
    pop hl
    ld (lab90C7),hl
    ret 
lab96E7 call lab9A26
    and #10
    halt
    jr nz,lab96E7

lab96EF call lab9A26
    and #10
    ret nz
    halt
    jr lab96EF


lab96F8 ld a,(hl)
    cp #ff
    ret z
    call #BB5A ; TXT OUTPUT
    inc hl
lab9700 jr lab96F8

lab9702 cp #a
    jr c,lab970F
    push af
    ld a,#31
    call #BB5A ; TXT OUTPUT
    pop af
    sub #a
lab970F add a,#30
    call #BB5A ; TXT OUTPUT
    ret 

lab9715 rra 
    inc b
    dec d
    db #f ; RRCA 
    ld (bc),a
    db ''PRESS FIRE''        
    db #0f
    inc bc
    db #ff
lab9727 rra 
    ld bc,#0F0A
    ld (bc),a
    LD c,h ; L
    LD b,l ; E
    ld d,(hl)
    LD b,l ; E
    LD c,h ; L
lab9731 ld a,(#1FFD+2)
    dec c
    ld a,(bc)
    db #f ; RRCA 
    inc b
    db #ff
lab9739 rra 
    rlca 
    ex af,af''
    db #f ; RRCA 
    inc b
    ld d,a
    LD b,l ; E
    LD c,h ; L
    LD c,h ; L
    jr nz,lab9786+2
    ld c,a ; ''O''
    ld c,(hl)
    LD b,l ; E
    ld hl,#ff21
lab974A xor a
    call lab9DCB
    ld a,#3
    call lab9604
    call lab968C
    call lab999F+1
    ld bc,#201E
    ld de,#4300
    call lab99FE
    ld bc,#c01e
lab9765 ld de,#5E80
    call lab99FE
    ld bc,#204E
    ld de,#5D00
    call lab99FE
    ld bc,#c04e
    ld de,#5D80
    call lab99FE
    ld bc,#207E
    ld de,#5E00
lab9783 call lab99FE
lab9786 ld bc,#c07e
    ld de,#5C80
    call lab99FE
    call lab9978
    ld hl,lab97F0
    call lab96F8
    call lab9F29

menu_loop:
    call #BB06      ;KM WAIT CHAR
    or #20
    cp ''x''
    ret z
    cp ''6''
    ret z
    cp ''q''
    call z,lab97D1 ; start cheat code
    cp ''c''
    call z,lab967C ; couleur
    cp ''j''
    jr nz,lab97C1 ; 
    ld a,#80        ;    joystick
    ld (joykb),a
    ld hl,lab9882
    call lab96F8
    jr menu_loop
lab97C1 cp ''k''
    jr nz,lab97CF
    xor a
    ld (joykb),a
    ld hl,lab986D
    call lab96F8
lab97CF jr menu_loop
lab97D1 call #BB06 ; KM WAIT CHAR   ; Cheat mode
    cp #45 ; ''E''
    ret nz
    call #BB06 ; KM WAIT CHAR
    cp #44 ; ''D''
    ret nz
    call #BB06 ; KM WAIT CHAR
    sub #30 ; Numero -> niveau
    ret z
    ret c
    cp #a
    ret nc
    ld (startLevel),a
    ld a,#7     ; BIP
    call #BB5A 
    ret 

lab97F0 rra 
    add hl,bc
    rlca 
    ld c,#0
    db #f ; RRCA 
    inc b
    jr nz,lab984C
    db ''ILO''    
    jr nz,lab981E
    jr nz,lab9820
lab9800 jr nz,lab9855
    ld c,b
    LD b,l ; E
    db ''I''
    LD c,h ; L
    ld b,h ; ''D''
    rra 
    dec b
    inc c
    db ''MISSILE''    
    jr nz,lab9833
    db ''SPEED''    
    ld d,l
    ld d,b ; ''P''
    rra 
    ld bc,#2011
lab981E LD c,h ; L
    ld b,c
lab9820 ld d,e ; ''S''
    LD b,l ; E
    ld d,d ; ''R''
    jr nz,lab9845
    jr nz,lab9847
    jr nz,lab9871
    ld c,a ; ''O''
    LD c,h ; L
    LD b,l ; E
    jr nz,lab984D
    db #f ; RRCA 
    ld d,#e
    ex af,af''
    db #f ; RRCA 
lab9833 inc c
    ld b,(hl)
    db ''I''
    ld d,d ; ''R''
    LD b,l ; E
lab9838 jr nz,lab98AE
    ld l,a ; ''o''
    jr nz,lab98AC+1
    ld l,h
    ld h,c
    ld a,c
    rra 
    ld b,#14
    ld c,#0
lab9845 db #f ; RRCA 
    inc b
lab9847 ld b,(hl)
    db ''I''
    ld d,d ; ''R''
    LD b,l ; E
    ld b,d
lab984C db ''I''
lab984D ld d,d ; ''R''
    ld b,h ; ''D''
    jr nz,lab9871
    ld sp,#3839
    scf
lab9855 db #f ; RRCA 
lab9856 ld bc,#1FFD+2
    dec bc
    inc de
    db #f ; RRCA 
    rlca 
    inc e
    rlca 
    nop
    jr lab98B0
    LD b,l ; E
    ld d,a
    jr nz,lab98AE
    db ''I''
lab9867 ld d,e ; ''S''
    ld b,e
    ld c,a ; ''O''
    ld d,d ; ''R''
    LD b,l ; E
    db #ff
lab986D rra 
    dec bc
    inc de
    db #f ; RRCA 
lab9871 rlca 
    inc e
    rlca 
    nop
    rla 
    jr nz,lab9898
    ld c,e
    LD b,l ; E
    ld e,c
    ld b,d
    ld c,a ; ''O''
    ld b,c
    ld d,d ; ''R''
    ld b,h ; ''D''
lab9880 jr nz,lab9880+1
lab9882 rra 
    dec bc
    inc de
    db #f ; RRCA 
    rlca 
    inc e
    rlca 
    ld bc,#2018
    jr nz,lab98D8
    ld c,a ; ''O''
    ld e,c
    ld d,e ; ''S''
    ld d,h
    db ''I''
    ld b,e
    ld c,e
lab9895 jr nz,lab9895+1
lab9897 rra 
lab9898 ld bc,#0F01
    inc bc
    ld c,#1
    jr nz,lab98C0
    jr nz,lab98C1+1
    jr nz,lab98C3+1
    jr nz,lab98C6
    jr nz,lab98C8
    jr nz,lab98CA
    jr nz,lab98CC
lab98AC jr nz,lab98CE
lab98AE ld e,d
    ld d,h
lab98B0 ld b,d
lab98B1 jr nz,lab9915
    ld a,c
    jr nz,lab98FA
lab98B6 ld (hl),d
    ld l,c
    ld l,(hl) ; ''n''
    ld l,e
    ld (hl),e
    ld l,a ; ''o''
    ld h,(hl)
    ld (hl),h ; ''t''
    db #ff
lab98BF db #f ; RRCA 
lab98C0 nop
lab98C1 jr nz,lab9867
lab98C3 jr nz,lab9915
    ld h,c
lab98C6 ld (hl),l ; ''u''
    ld l,h
lab98C8 jr nz,lab991D
lab98CA ld l,b
    ld l,c
lab98CC ld (hl),d
    ld l,h
lab98CE ld h,l
    ld a,c
    jr nz,lab98DF+1
    nop
    db #ff
lab98D4 rra 
    ld bc,#0F01
lab98D8 inc bc
    ld c,#0
    jr nz,lab98FD
    jr nz,lab98FD+2
lab98DF jr nz,lab9901
    jr nz,lab9903
    jr nz,lab9905
    jr nz,lab9907
    jr nz,lab9909
    jr nz,lab990B
    ld d,c
    LD b,l ; E
    ld b,h ; ''D''
    ld sp,#392D
    jr nz,lab9967
    ld l,a ; ''o''
    jr nz,lab9959
    ld l,b
    ld h,l
    ld h,c
    ld (hl),h ; ''t''
lab98FA ld hl,#1FFD+2
lab98FD ld bc,#0F01
    ld (bc),a
lab9901 ld c,#0
lab9903 jr nz,lab9925
lab9905 jr nz,lab9925+2
lab9907 jr nz,lab9929
lab9909 jr nz,lab992B
lab990B jr nz,lab992D
    jr nz,lab992F
    jr nz,lab9931
    jr nz,lab9933
    db ''I''
    db #27
lab9915 db ''m''
    jr nz,lab996A
    LD b,l ; E
    ld b,c
    LD c,h ; L
    LD c,h ; L
    ld e,c
lab991D jr nz,lab9961
    ld l,a ; ''o''
    ld (hl),d
    ld h,l
    db ''d'' ; #64
    db #ff
lab9924 rra 
lab9925 ld bc,#0F01
    inc bc
lab9929 ld c,#1
lab992B jr nz,lab994D
lab992D jr nz,lab994D+2
lab992F jr nz,lab9951
lab9931 jr nz,lab9953
lab9933 jr nz,lab9955
    jr nz,lab9957
lab9937 jr nz,lab9959
    jr nz,lab995B    
    db ''MISSION''    
    jr nz,lab998A+1
    db ''ENOCIDE''    
    db #ff
lab994C rra 
lab994D ld bc,#0E14+1
    inc b
lab9951 db #f ; RRCA 
    ex af,af''
lab9953 jr nz,lab9975
lab9955 jr nz,lab9977
lab9957 jr nz,lab9978+1
lab9959 jr nz,lab997B
lab995B jr nz,lab997B+2
    jr nz,lab997E+1
    jr nz,lab9981
lab9961 jr nz,lab9983
    jr nz,lab99AC+1
    db ''I''
    ld d,e ; ''S''
lab9967 ld b,e
    ld c,a ; ''O''
    ld d,d ; ''R''
lab996A LD b,l ; E
lab996B ld a,(#0EFF)
    nop
    db #f ; RRCA 
lab9970 ld bc,#00FD+2
    nop
    nop
lab9975 nop
    nop
lab9977 nop
lab9978 ld hl,lab994C
lab997B call lab96F8
lab997E ld hl,lab9977
lab9981 ld b,#6
lab9983 ld a,(hl)
    call lab970F
    dec hl
    djnz lab9983
lab998A ld a,#20
    call #BB5A ; TXT OUTPUT
    ld hl,lab996B+2
    call lab96F8
    ld b,#7
lab9997 ld de,#ce40
    ld hl,#c680
    jr lab99D2
lab999F ld bc,lab9F20+1
    sbc a,c
    ld a,(hl)
    inc (hl)
    and #3f
    cp #28
    ld hl,lab98D4
lab99AC jr z,lab99C1
    and #7
    cp #7
    ld hl,lab98FA+2
    jr z,lab99C1
    and #1
    ld hl,lab9924
    jr z,lab99C1
    ld hl,lab9897
lab99C1 call lab96F8
    ld hl,lab98BF
    call lab96F8

    ; Recopies de ligne d''écran
    ; Pour le texte plus gros (Titre, hiscore)
    ld b,#7
    ld hl,#c040             
    ld de,#c800             
lab99D2 push bc
    push hl
    push de
    ld bc,#040
    ldir
    pop hl
    call lab99F4
    ex de,hl
    pop hl
    push hl
    push de
    ld bc,#0040
    ldir
    pop hl
    call lab99F4 ; next line
    ex de,hl
    pop hl
    call lab99F4 ; next line
    pop bc
    djnz lab99D2
    ret 

lab99F4 ld bc,#0800 ; Next line
    add hl,bc
    ret nc
    ld bc,#c040
    add hl,bc
    ret 

lab99FE call lab9CDF
    ld bc,#041E+2
    jp drawtile
lab9A07 ld hl,(lab90C4)
    ld a,h
    ld de,(curLevel+2)
    and a
    sbc hl,de
    jr nc,lab9A1B
    call lab946D
    ld hl,#C000
    xor a
lab9A1B xor h
    ld (lab90C4),hl
    and #f
    ret z
    ld a,h
    jp lab940F

lab9A26 ld a,(joykb)
    and a                   ; 0 => keyboard
    jp nz,#BB24
    push bc
    ld b,#0
    ld a,#4
    call #BB1E ; KM TEST KEY
    jr z,lab9A39
    ld b,#30
lab9A39 ld a,#43
    call #BB1E ; KM TEST KEY
    jr z,lab9A42
    set 0,b
lab9A42 ld a,#3c
    call #BB1E ; KM TEST KEY
    jr z,lab9A4B
    set 1,b
lab9A4B ld a,#14
    call #BB1E ; KM TEST KEY
    jr z,lab9A54
    set 2,b
lab9A54 ld a,#c
    call #BB1E ; KM TEST KEY
    jr z,lab9A5D
    set 3,b
lab9A5D ld a,b
    ld l,b
    ld h,b
    pop bc
    ret 
joykb: add a,b              ;  80 = joystick, 0 = Keyboard
lab9A63 ld hl,lab9731+2
    call lab96F8
    ld hl,lab8800
    ld bc,#0A00
    ld a,(curLevel)
    and a
    jr z,lab9A7E
    ld e,a
lab9A76 ld a,#ff
lab9A78 cpir 
    ret po
    dec e
    jr nz,lab9A78
lab9A7E jp lab96F8
lab9A81 ld hl,lab8500
    xor a
    ld b,a
lab9A86 ld (hl),a
    inc hl
    djnz lab9A86
    ld a,#6
    ld (labA060),a
    ld a,#10
    ld (lab9A97),a
    jp lab9C33
lab9A97 djnz lab9A76
    ld hl,lab8500
    ld b,#10
    ld a,(lab9AC3)
    xor #1
    ld (lab9AC3),a
lab9AA6 push bc
    ld a,(ix+3)
    and a
    call nz,lab9AC4
    ld bc,#0008
    add ix,bc
    pop bc
    djnz lab9AA6
    ld a,(lab9AC1)
    add a,#10
    and #30
    ld (lab9AC1),a
    ret 
lab9AC1 nop
    ld a,c
lab9AC3 nop
lab9AC4 jp p,lab9B0E
    ld (ix+4),#3
    ld (ix+5),#2
    ld a,(lab90E3)
    add a,#c
    sub (ix+0)
    jr z,lab9AE3
    jr nc,lab9AE7
    neg
    ld (ix+4),#fd
    jr lab9AE7
lab9AE3 ld (ix+4),#0
lab9AE7 ld b,a
    ld a,(lab90CD+1)
    sub (ix+1)
    ld c,a ; ''O''
    ld a,(lab90E2)
    add a,c
    jr z,lab9AFF
    jr c,lab9B03
    neg
    ld (ix+5),#fc
    jr lab9B03
lab9AFF ld (ix+5),#ff
lab9B03 add a,b
    jr c,lab9B0E
    cp #30
    jr nc,lab9B0E
    res 7,(ix+3)
lab9B0E bit 4,(ix+3)
    jr nz,lab9B26
    ld a,(lab9AC3)
    and a
    jr nz,lab9B26
    ld l,(ix+6)
    ld h,(ix+7)
    ld a,h
    sub #c0
    ret c
    jr lab9B70
lab9B26 ld l,(ix+6)
    ld h,(ix+7)
    ld a,h
    sub #c0
    jr c,lab9B34
    call lab9DF0
lab9B34 ld a,(ix+0)
    add a,(ix+4)
    cp #f8
    jr nc,lab9B82
    ld b,a
    ld (ix+0),a
    ld a,(ix+1)
    add a,(ix+5)
    ld c,a ; ''O''
    ld (ix+1),a
    ld a,(lab90CD+1)
    sub c
    neg
    cp #f1
    jr nc,lab9B82
    ld d,a
    ld a,(lab90E3)
    sub b
    cp #ec
    jr c,lab9B67
    ld a,(lab90E2)
    sub d
    cp #ec
    jr nc,lab9B7F
lab9B67 call lab9CDF
    ld (ix+6),l
    ld (ix+7),h
lab9B70 ld de,(lab9AC1)
    ld a,(ix+3)
    and #80
    or e
    ld e,a
    call lab9C0F
    ret 
lab9B7F call labA0AD
lab9B82 ld (ix+3),#0
    ld (ix+7),#0
    ret 
lab9B8B ld iy,lab8500
    ld ix,lab9BEF
    ld (ix+2),a
    and a
    ld a,(lab9BEE)
lab9B9A set 6,a
    jr nz,lab9BA3
    set 7,a
    inc (ix+2)
lab9BA3 ld (lab9BEE),a
    ld (lab9BEF),hl
    ld de,lab9BFF
    ld (ix+3),#10
    ld bc,#0008
lab9BB3 srl (ix+2)
    jr c,lab9BBE
    ret z
    inc de
    inc de
    jr lab9BB3
lab9BBE ld a,(iy+3)
    and a
    jr z,lab9BCC
    add iy,bc
    dec (ix+3)
    jr nz,lab9BBE
    ret 
lab9BCC ld a,(de)
    ld (iy+4),a
    inc de
    ld a,(de)
    ld (iy+5),a
    ld a,(ix+1)
    ld (iy+0),a
    ld a,(ix+0)
    ld (iy+1),a
    ld (iy+7),#0
    ld a,(lab9BEE)
    ld (iy+3),a
    inc de
    jr lab9BB3
lab9BEE db #40
lab9BEF 
    ds 16
lab9BFF nop
    call m,#fd03
    inc b
    nop
    inc bc
    inc bc
    nop
    inc b
    db #fd
    db #3
    call m,#fd00
    db #fd
lab9C0F db #6
    ex af,af''
lab9C11 ld a,(lab9E0F)
    ld c,a ; ''O''
lab9C15 push bc
    ex de,hl
    ld a,(de)
    and c
    xor (hl)
    ld (de),a
    inc e
    inc l
    ld a,(de)
    and c
    xor (hl)
    ld (de),a
    inc l
    ex de,hl
    ld bc,#07FF
    add hl,bc
    jr nc,lab9C2F
    ld bc,#c040
    add hl,bc
    res 3,h
lab9C2F pop bc
    djnz lab9C15
    ret 
lab9C33 ld ix,lab8400
    ld (lab9C3C),ix
    ret 
lab9C3C nop
    add a,h
lab9C3E nop
lab9C3F ld ix,(lab9C3C)
    xor a
    ld (lab9C3E),a
lab9C47 ld a,(lab90C9+1)
    srl a
    ld b,a
lab9C4D ld a,(ix+0)
    and a
    ret m
    sub b
    ret m
    sub #6
    jr c,lab9C60
    inc ix
    inc ix
    inc ix
    jr lab9C4D
lab9C60 ld a,(ix+2)
    and #e0
    ld b,a
    ld a,(lab90CD+1)
    and #e0
    cp b
    jr nz,lab9CAE
    ld a,(ix+2)
    and #10
    ld (lab9BEE),a
    ld a,(ix+2)
    and #7
    ld h,a
    ld l,(ix+0)
    sla l
    call lab9D24
    ld a,(hl)
    and a
    jp p,lab9CAE
    cp #bf
    jp z,lab9CAE
    ld a,(ix+2)
    and #7
    db #f ; RRCA 
    db #f ; RRCA 
    db #f ; RRCA 
    add a,#c
    ld h,a
    ld a,(ix+0)
    and #7
    db #f ; RRCA 
    db #f ; RRCA 
    db #f ; RRCA 
    add a,#c
    ld l,a ; ''o''
    ld a,(ix+1)
    push ix
    call lab9B8B
    pop ix
lab9CAE inc ix
    inc ix
    inc ix
    jr lab9C47
lab9CB6 nop
    nop
lab9CB8 ld a,h
    rlca 
    rlca 
    rlca 
    and #7
    ld h,a
    ld a,(lab90CD)
    add a,l
    rlca 
    rlca 
    rlca 
    and #7
    ret z
    ld l,a ; ''o''
    ld a,(lab90C9+1)
    add a,l
    add a,l
    ld l,a ; ''o''
    ld (lab9CB6),hl
    call lab9D24
    ld a,(hl)
    and a
    scf
    ret 
lab9CDA ld a,(lab90CD+1)
    add a,c
    ld c,a ; ''O''
lab9CDF ld a,c
    db #f ; RRCA 
    db #f ; RRCA 
    db #f ; RRCA 
    scf
    rra 
    rr b
    scf
    rra 
    rr b
    ld h,a
    ld l,b
    ret 

; init level, en recopiant les données du niveau
; en #8000-#83ff :la map
; en #8400-#84ff
; en #A24F-#A347
; A contient le level
lab9CEE:
    cp #c
    ret nc
    push af
    rlca 
    rlca 
    add a,#4    ; HL = #400 +  level * #400
    ld h,a
    ld l,#0
    ld de,#8000
    ld bc,#0400
    ldir
    pop af

    push af
    ld l,#0
    add a,#34
    ld h,a
    ld de,#8400
    ld bc,#0100
    ldir
    pop af

    ADD A   ; HL = #40 + lvl *8
    ADD A
    ADD A
    ld c,a 
    ld b,#0
    ld hl,#0040
    add hl,bc
    ld bc,#0008
    ld de,labA24F
    ldir
    ret 


lab9D24 scf
    rr h
    rr l
    ret 
lab9D2A push hl
    call lab9D24
    ex de,hl
    pop bc
    ld a,b
    ADD A
    ADD A
    ADD A
    ld l,a ; ''o''
    ld a,c
    rra 
    and #7
    or #c0
    ld h,a
    ld a,(de)
    ex de,hl
    call lab9D49
    ex de,hl
    ld bc,#041E+2
    call drawtile
    ret 
lab9D49 ld l,#0
    ADD A
    jr nc,lab9D56
    and #7f
    cp #6e
    jr c,lab9D56
    ld a,#c
lab9D56 and a
    srl a
    srl a
    rr l
    add a,#40
    ld h,a
    ret 
lab9D61 ld a,(lab90C9+1)
    ld b,#8
    ld l,a ; ''o''
    ld h,#0
    ld de,lab90F7
lab9D6C push hl
    call lab9D24
    ld a,(hl)
    call lab9D49
    ld a,l
    or #7f
    ld l,a ; ''o''
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ex de,hl
    pop hl
    inc h
    djnz lab9D6C
    ret 
lab9D83 ld hl,(lab90C7)
    push hl
    ld hl,#0000
    ld (lab90C7),hl
    ld hl,lab90C6
    inc (hl)
    xor a
    call lab9DCB
    ld hl,(lab90C9)
    res 0,h
    ld l,#0
    call lab9DE0
    ld (lab90C9),hl
    xor a
    ld (lab90F6),a
    call lab9D61
    ld c,#7
    ld a,(lab90C9+1)
    ld l,a ; ''o''
lab9DAF ld h,#0
    ld b,#8
lab9DB3 push bc
    push hl
    call lab9D2A
    pop hl
    inc h
    pop bc
    djnz lab9DB3
    inc l
    inc l
    dec c
    jr nz,lab9DAF
    ld hl,lab90C6
    dec (hl)
    pop hl
    ld (lab90C7),hl
    ret 
lab9DCB ld hl,lab90C6
    inc (hl)
    ld de,#C000+1
    ld hl,#C000
    ld bc,#3FFF
    ld (hl),a
    ldir
    ld hl,lab90C6
    dec (hl)
    ret 
lab9DE0 push af
    push hl
    ld hl,lab90F5
lab9DE5 di
    bit 7,(hl)
    ld (hl),#0
    ei
    jr z,lab9DE5
    pop hl
    pop af
    ret 
lab9DF0 ld b,#8
lab9DF2 ld a,(lab9E0F)
    ld c,a ; ''O''
    ld de,#07FF
lab9DF9 ld a,(hl)
    and c
    ld (hl),a
    inc hl
    ld a,(hl)
    and c
    ld (hl),a
    add hl,de
    jr nc,lab9E0C
    ld de,#c040
    add hl,de
    ld de,#07FF
    res 3,h
lab9E0C djnz lab9DF9
    ret 
lab9E0F call z,#0000
lab9E12 nop
lab9E13 nop

curLevel:    db 1
startLevel:  db FIRSTLEVEL
    db #10
    nop

; Menu?
lab9E18 call lab9043
lab9E1B ld a,#80
    ld (lab90C6),a
    ld hl,#0000
    ld (lab90C7),hl
    ld hl,#0010
    ld (lab90C9),hl
    call lab974A
    call lab9089
    ld a,(startLevel)
    ld (curLevel),a
    xor a
    ld (lab9E13),a
lab9E3C xor a
    ld (lab90E4),a
    ld (lab90F1),a
    ld a,(curLevel)
    call lab9CEE
    ld a,(curLevel)
    call lab9604
    ld a,#80
    ld (lab90C6),a
    ld hl,#0000
    ld (lab90C9),hl
    xor a
    call lab9DCB
    ld hl,lab9727
    call lab96F8
    ld a,(curLevel)
    and a
    jr nz,lab9E6C
    ld a,#c
lab9E6C call lab9702
    ld a,(lab9E13)
    cp #1
    ld hl,lab9739
    call z,lab96F8
    call lab9A63
    ld a,(curLevel)
    add a,#10
    ld (curLevel+2),a
    ld hl,lab9715
    call lab96F8
    call lab96E7
    ld hl,#0010
    ld (lab90C7),hl
    jr lab9EA1
lab9E96 ld a,(lab90C9+1)
    add a,#10
    jr nc,lab9E9E
    xor a
lab9E9E ld (lab90C9+1),a
lab9EA1 call lab9D83
    call lab9DE0
    call lab9DE0
    call lab9A81
    xor a
    ld (lab9E0F+1),a
    ld (labA257),a
    ld (lab90C6),a
    ld (lab9E12),a
    ld a,#ff
    ld (lab9E0F+2),a

lab9EBF ld a,(lab90E4)
    and #80
    jp nz,lab9F51
    ld a,(lab9E12)
    and a
    jp nz,lab9F2F
    call lab9A07
    ld hl,lab9E0F+2
    di
    ld a,(hl)
    ld (hl),#0
    ei
    and a
    call nz,labA218
    call lab9DE0
    call lab9FB6
    call lab9A97+1
    call labA276
    ld a,(lab9C3E)
    and a
lab9EED call nz,lab9C3F
    call lab9591
    call #BB09 ; KM READ CHAR
    jr nc,lab9EBF
    or #20
    cp #63
    call z,lab967C
lab9EFF cp #70
    call z,lab96C0
    cp #6a
    jr nz,lab9F0F
    ld a,#80
    ld (joykb),a
    jr lab9EBF
lab9F0F cp #6b
    jr nz,lab9F19
    xor a
    ld (joykb),a
    jr lab9EBF
lab9F19 cp #20
    jr nz,lab9F26
    ld a,(lab90E8)
lab9F20 xor #10
    ld (lab90E8),a
    xor a
lab9F26 jp lab9EBF
lab9F29 call #BB09 ;KM READ CHAR
    jr c,lab9F29
    ret 
lab9F2F call lab9532
    ld a,(curLevel)
    and a
    jr nz,lab9F41
    ld a,(lab9E13)
    inc a
    ld (lab9E13),a
    ld a,#8
lab9F41 inc a
    ld (curLevel),a
    cp #c
    jp nz,lab9E3C
    xor a
    ld (curLevel),a
    jp lab9E3C
lab9F51 call lab9DE0
    call lab9FB6
    call lab9A97+1
    call lab9591
    ld a,(lab90E4)
    and #80
    jr nz,lab9F51
    ld a,(LIFE_CNT)
    and a
    jp m,lab9F77
    jr z,lab9F77
    ld hl,(lab90C7)
    ld a,l
    or h
    jr z,lab9F2F
    jp lab9E96
lab9F77 jp lab9E1B

; Routine de dessin 6 octets de large (12pix)
; Pour restituer le décor
; DE = source
; HL = Data
; B = nombre de lignes
lab9F7A 
    ld a,(lab9E0F)
    ld c,a 
lab9F7E:
    push bc          ; Dessin 
    push hl
    ex de,hl         ; des push et des ex qui pourraient etre évités

repeat 5
    ld a,(de)
    and c               ; A quoi sert le and C?
    or (hl)
    ld (de),a
    inc e
    inc l
rend        
    ld a,(de)
    and c
    or (hl)
    ld (de),a
    inc l
    
    ex de,hl
    pop hl
    ld bc,#0800    ; Next line
    add hl,bc
    jr nc,lab9FB2
    ld bc,#c040
    add hl,bc
    res 3,h
lab9FB2 pop bc
    djnz lab9F7E
    ret 
lab9FB6 call labA1E4
    ld ix,lab8580
    ld b,#6
lab9FBF push bc
    ld l,(ix+0)
    ld h,(ix+1)
    ld a,l
    or h
    call nz,lab9FD4
    ld bc,#0010
    add ix,bc
    pop bc
    djnz lab9FBF
    ret 
lab9FD4 jp (hl)
lab9FD5 ld a,(ix+5)
    dec (ix+5)
    jr z,labA04F
    dec a
    ld e,#0
    srl a
    srl a
    rr e
    add a,#7a
    ld d,a
    jr lab9FF5
lab9FEB ld d,(ix+9)
    ld a,(ix+8)
    add a,e
    ld e,a
    jr lab9FFB
lab9FF5 ld b,(ix+2)
    ld c,(ix+3)
lab9FFB call lab9CDF
    ld (ix+12),l
    ld (ix+13),h
    ld (ix+10),e
    ld (ix+11),d
    ret 
labA00B push ix
    ld ix,lab8580
    ld hl,lab9FD5
    ld de,#0010
    ld b,#6
labA019 ld a,(ix+0)
    or (ix+1)
    call nz,labA02D
    add ix,de
    djnz labA019
    xor a
    ld (labA257),a
    pop ix
    ret 
labA02D ld (ix+0),l
    ld (ix+1),h
    ld (ix+5),#8
    ld (ix+6),#0
    ld (ix+7),#0
    ret 
labA040 ld hl,lab9FD5
    call labA02D
    call lab9538
    ld de,lab9000+#9
    jp lab95B5
labA04F ld (ix+0),#0
    ld (ix+1),#0
    ld hl,labA060
    inc (hl)
    ld de,#6000
    jr lab9FF5
labA060 ld b,#3a
    ld h,b
    and b
    and a
    scf
    ret z
    ld iy,lab8580
    ld de,#0010
    ld b,#6
labA070 xor a
    ld a,(iy+0)
    or (iy+1)
    jr z,labA07F
    add iy,de
    djnz labA070
    scf
    ret 
labA07F ld hl,labA060
    dec (hl)
    ret 
labA084 ld a,(lab90CD+1)
    neg
    add a,(ix+3)
    ld c,a ; ''O''
    add a,#15
    cp #f8
    jr nc,labA04F
    ld b,(ix+2)
    ld de,(lab90E2)
    ld a,b
    sub d
    add a,#12
    cp #24
    jr nc,labA0D0
    ld a,c
    sub e
    add a,#12
    cp #24
    jr nc,labA0D0
    call labA040
labA0AD ld a,(lab90E4)
    and #80
    ret nz
    di
    ld a,(lab90C3)
    and a
    jr z,labA0C0
    dec a
    ld (lab90C3),a
    ei
    ret 
labA0C0 ei
    call labA00B
    ld hl,LIFE_CNT
    dec (hl)
    ld a,#c0
    ld (lab90E4),a
    jp lab9588
labA0D0 ld a,(lab90EB)
    and a
    ret z
    ld de,(lab90E9)
    ld a,b
    sub d
    add a,#18
    cp #1e
    ret nc
    ld a,c
    sub e
    add a,#14
    cp #20
    ret nc
    bit 1,(ix+5)
    res 1,(ix+5)
    jr nz,labA0F8
    bit 7,(ix+5)
    call z,labA040
labA0F8 xor a
    ld (lab90EB),a
    ret 
labA0FD ld a,(ix+6)
    ld b,(ix+2)
    and a
    jr z,labA109
    jp p,labA111
labA109 add a,b
    jr nc,labA11B
    ld (ix+2),a
    ld b,a
    ret 
labA111 add a,b
    cp #ec
    jr nc,labA11B
    dec e
    ld (ix+2),a
    ret 
labA11B xor a
    sub (ix+6)
    ld (ix+6),a
    ret 

labA123 
    ld a,(ix+7)
    ld c,(ix+3)
    add a,c
    ld (ix+3),a
    bit 7,(ix+7)
    jr z,labA137
    ld e,0
    ld c,a 
    ret 

labA137 ld a,(ix+7)
    ADD A
    add a,(ix+7)
    ADD A
    neg
    ld e,a
    ret 

labA143 ld a,(ix+15)
    add a,(ix+7)
    push af
    push hl
    ld h,#75
    ld l,a ; ''o''
    ld a,(hl)
    pop hl
    ld (ix+7),a
    call labA123
    pop af
    ld (ix+7),a
    ret 

labA15B ld a,(ix+14)
    add a,(ix+6)
    push af
    push hl
    ld h,#75
    ld l,a ; ''o''
    ld a,(hl)
    pop hl
    ld (ix+6),a
    call labA0FD
    pop af
    ld (ix+6),a
    ret 
labA173 ld a,h
    sub l
    jr nc,labA17E
    add a,#8
    ld a,#0
    ret c
    sub c
    ret 
labA17E sub #8
    ld a,c
    ret nc
    xor a
    ret 
labA184 ld a,(lab90CD+1)
    neg
    add a,(ix+3)
    add a,#15
    ld l,a ; ''o''
    ld a,(lab90E2)
    add a,#15
    ld h,a
    ld c,(ix+7)
    push bc
    call labA173
    ld (ix+7),a
    and a
    jp p,labA1A6
    dec (ix+7)
labA1A6 call labA1AE
    pop bc
    ld (ix+7),c
    ret 
labA1AE ld l,(ix+2)
    ld a,(lab90E3)
    ld h,a
    ld c,(ix+6)
    push bc
    call labA173
    ld (ix+6),a
    call labA1C7
    pop bc
    ld (ix+6),c
    ret 
labA1C7 call labA123
    call labA0FD
labA1CD call lab9FEB
    call labA084
    ret 
labA1D4 call labA143
    call labA15B
    jr labA1CD
labA1DC call labA123
    call labA15B
    jr labA1CD
labA1E4 ld b,#6
    ld ix,lab8580
labA1EA ld a,(ix+13)
    ld (ix+13),#0
    cp #c0
    jr c,labA206
    ld h,a
    ld l,(ix+12)
    ld d,(ix+11)
    ld e,(ix+10)
labA1FF push bc
    ld b,#14
    call lab9F7A
    pop bc
labA206 ld de,#0010
    add ix,de
    djnz labA1EA
    ret 
labA20E ld a,r
    ADD A
    ADD A
    cp #e8
    ret c
    sub #e8
    ret 
labA218 ld a,(lab90C9+1)
labA21B rlca 
    rlca 
    rlca 
    and #7
    ld c,a ; ''O''
    ld b,#0
    ld hl,labA24F
    add hl,bc
    ld a,(lab9E0F+1)
    cp (hl)
    ret z
    ld a,(hl)
    ld (lab9E0F+1),a
    add a
    add a
    add a
    ld c,a ; ''O''
    ld b,#0
    rl b
    ld hl,#0200
    add hl,bc
    ld de,labA257
    ld bc,#0008
    ldir
    ld a,(labA258)
    ld (labA25F),a
    xor a
    ld (labA260),a
    ret 
labA24F: ds 8	
labA257 nop
labA258: ds 7
labA25F nop
labA260 
	ld b,#3e
    rst 40
    sub (ix+4)
    jr nc,labA26A
    ld a,#ff
labA26A ld (ix+4),a
    ld a,#0
    sub (ix+2)
    ld (ix+2),a
    ret 
labA276 ld ix,labA257
    dec (ix+8)
    ret nz
    ld a,(ix+0)
    and a
    ret z
labA283 ld a,(ix+1)
    ld (ix+8),a
    bit 5,(ix+6)
    jr z,labA2A8
    ld a,(ix+9)
    and a
    jr nz,labA2A5
    ld a,(labA060)
    cp #6
    ret nz
    ld (ix+9),a
    bit 3,(ix+6)
    call nz,labA260+1
labA2A5 dec (ix+9)
labA2A8 call labA060+1
    ret c
    ld a,(ix+0)
    ld l,#0
    srl a
    rr l
    add a,#60
    ld (iy+8),l
    ld (iy+9),a
    ld a,(ix+6)
    and #80
    or #1
    ld (iy+5),a
    ld a,(ix+6)
    and #10
    call nz,labA260+1
    ld a,(lab90CD+1)
    sub #15
    bit 2,(ix+6)
    jr z,labA2DC
    add a,#f5
labA2DC ld (iy+3),a
    ld a,(ix+4)
    ld (iy+2),a
    cp #ff
    jr nz,labA2F1
    call labA20E
    ld (iy+2),a
    jr labA33E
labA2F1 bit 6,(ix+6)
    jr z,labA32A
    add a,(ix+5)
    bit 7,(ix+5)
    jr nz,labA310
    jr c,labA306
    cp #e8
    jr c,labA33B
labA306 ld a,(ix+5)
    neg
    ld (ix+5),a
    jr labA33E
labA310 jr nc,labA306
    jr c,labA33B
    cp #e8
    jr c,labA33B
    bit 6,(ix+6)
    jr z,labA32A
    push af
    ld a,(ix+5)
    neg
    ld (ix+5),a
    pop af
    jr labA33E
labA32A add a,(ix+5)
    cp #e8
    jr c,labA33B
    sub #18
    bit 7,(ix+5)
    jr nz,labA33B
    add a,#30
labA33B ld (ix+4),a
labA33E ld a,(ix+7)
    and a
    jr z,labA352
    dec a
    jr z,labA36D
    dec a
    jr z,labA372
    dec a
    jr z,labA377
    dec a
    jr z,labA397
    jr labA372
labA352 ld hl,labA1C7
labA355 push hl
    ld a,(ix+2)
    ld (iy+6),a
labA35C ld a,(ix+3)
    call labA3A0
    ld (iy+7),a
    pop hl
    ld (iy+0),l
    ld (iy+1),h
    ret 
labA36D ld hl,labA1AE
    jr labA355
labA372 ld hl,labA184
    jr labA355
labA377 ld hl,labA1D4
    ld a,(ix+3)
    ld (iy+15),a
    ld a,#40
    ld (iy+7),a
    ld (iy+0),l
    ld (iy+1),h
labA38B ld a,(ix+2)
    ld (iy+14),a
    ld a,#0
    ld (iy+6),a
    ret 
labA397 ld hl,labA1DC
    call labA38B
    push hl
    jr labA35C
labA3A0 cp #a
    jr nc,labA3A7
    sub #4
    ret 
labA3A7 ld c,a 
    and #f
    sub #4
    ld b,a
    ld a,r
     RRCA 
     RRCA 
     RRCA 
    ld l,a ; ''o''
    ld a,r
    xor l
    db #f ; RRCA 
    and #3
    bit 7,c
    jr nz,labA3BF
    srl a
labA3BF add a,b
    bit 5,c
    ret z
    neg
    ret 
labA3C6 ld hl,labA3E1
    ld de,#B970
    ld bc,#0010+2
    ldir
    ld a,#5
    ld (labA42D+1),a
    ld a,#4
    ld (labA533+1),a
    ld a,#18
    ld (#B93A+1),a
    ret 

; Interruption, saute a l''adresse stockée dans next_IT. 
labA3E1 
    push af,bc,de,hl
    ld hl,(next_IT)
    call labA3F2
    pop hl,de,bc,af
    jp #B93D

labA3F2 jp (hl)
labA3F3 ld hl,labA4ED
    ld (next_IT),hl
    ld bc,#BC06
    out (c),c
    ld bc,#BD20
    out (c),c
    ld hl,(lab90C9)
    ld a,(lab90C6)
    and a
    jr nz,labA416
    ld bc,(lab90C7)
    and a
    sbc hl,bc
    ld (lab90C9),hl
labA416 add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,h
    ld (lab90CD+1),a
    and #1f
    ld (lab90CD),a
    and #7
    ld (lab90CD+2),a
    ld hl,(lab90C9)
    xor #7
labA42D add a,8   ; Scroll vertical
    ld bc,#BC05
    out (c),c
    inc b
    ld c,a ; ''O''
    out (c),c
    rl l
    ld l,0
    rr l
    ld a,h
    srl a
    rr l
    and #7
    or #c0
    ld h,a
    ld (lab90CB),hl
    srl h
    rr l
    ld bc,#BC0D
    out (c),c
    inc b
    LD c,l ; M
    out (c),c
    ld bc,#BC0C
    out (c),c
    ld a,h
    and #3
    or #30
    ld c,a ; ''O''
    inc b
    out (c),c
    ret 
labA467 ld a,(lab90C6)
    and a
    ret nz
    ld a,(lab90F6)
    ld c,a ; ''O''
    ld a,(lab90CD)
    cp c
    ret z
    ld (lab90F6),a
    push ix
    cp #1f
    jr nz,labA48F
    call lab9D61
    ld a,(lab90C9+1)
    and #1e
    cp #1e
    jr nz,labA48F
    ld a,#ff
    ld (lab9E0F+2),a
labA48F ld bc,#ff00
    call lab9CDA
    ld c,#8
    ld ix,lab9105
    ex de,hl
labA49C ld l,(ix+0)
    ld h,(ix+1)
    ld b,#4
labA4A4 ld a,(hl)
    ADD A
    ADD A
    and #cc
    ld (de),a
    dec e
    ld a,(hl)
    and #cc
    ld (de),a
    dec de
    dec l
    djnz labA4A4
    ld (ix+1),h
    ld (ix+0),l
    dec ix
    dec ix
    dec c
    jr nz,labA49C
    ld hl,#ffc0
    add hl,de
    set 7,h
    set 6,h
    xor a
    ld b,#40
labA4CB ld (hl),a
    dec l
    djnz labA4CB
    pop ix
    ld a,(lab90F6)
    cp #10
    jr nz,labA4DC
    ld hl,lab9C3E
    inc (hl)
labA4DC ld hl,(lab90C9)
    ld a,l
    and #f0
    or h
    ret nz
    ld (lab90C7),hl
    ld a,#ff
    ld (lab9E12),a
    ret 
	
; -- Interruptions	pour regler la rupture
labA4ED 
	ld hl,labA508
    ld (next_IT),hl
    ld bc,#BC04
    out (c),c
    ld bc,#BD1B      ; Ecran principal (28 lignes)
    out (c),c
    ld bc,#BC07
    out (c),c
    ld bc,#BD7F	     ; Overflow du Reg 7
    out (c),c
    ret 
	
labA508 ld hl,labA50F
    ld (next_IT),hl
    ret 
labA50F ld hl,labA516
    ld (next_IT),hl
    ;ld bc,#7f10
	;out (c),c
	;ld c,#49
	;out (c),c

    ret 

;Compensation scroll vertical et 
; offset video pour le HUD
labA516:
	ld hl,labA544	; Prepare prochaine IT
    ld (next_IT),hl
    ld bc,#BC0D		; Offset video #1380 
    out (c),c
    ld bc,#BD80
    out (c),c
    ld bc,#BC0C
    out (c),c
    ld bc,#BD13
    out (c),c
    ld a,(lab90CD+2)
labA533 add a,#1
    ld bc,#BC05
    out (c),c
    inc b
    ld c,a 
    out (c),c
    ld a,#ff
    ld (lab90F5),a
	
	;ld bc,#7f10
	;out (c),c
	;ld c,#48
	;out (c),c

    ret 

; Dernier écran (hud)
labA544:
	ld hl,labA3F3
    ld (next_IT),hl
    ld bc,#BC04
    out (c),c
    ld bc,#BD07
    out (c),c
    ld bc,#BC06
    out (c),c
    ld bc,#BD04
    out (c),c
    ld bc,#BC07
    out (c),c
    ld bc,#BD05
    out (c),c
	
    ;ld bc,#7f10
	;out (c),c
	;ld c,#55
	;out (c),c
    ret 

_end


; ------------------------- DATA: ennemies, terrain, sprites
org #40	

db #01,#20,#09,#01,#24,#1A,#12,#13
db #08,#07,#06,#05,#04,#03,#02,#01 
db #01,#0F,#18,#09,#06,#15,#0D,#0F,#10,#08,#0E,#05,#08,#14,#0A,#0C 
db #11,#0E,#12,#0C,#10,#09,#19,#17,#01,#0A,#10,#08,#1A,#07,#0C,#0E 
db #10,#08,#0F,#14,#03,#17,#1B,#0B,#02,#01,#00,#09,#1C,#0F,#0C,#04 
db #0E,#03,#0A,#10,#0C,#1F,#1E,#1D,#00,#00,#00,#00,#23,#21,#20,#17 
db #1B,#03,#06,#09,#0C,#0F,#0E,#15,#21,#03,#06,#09,#0C,#22,#20,#1E 

db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 
db #F0,#00,#01,#F0,#00,#01,#F0,#00,#08,#07,#02,#05,#04,#03,#02,#01 
db #F8,#00,#01,#F8,#00,#01,#F8,#00,#6E,#00,#01,#0D,#00,#01,#F1,#00 
db #F0,#00,#01,#F0,#00,#01,#F0,#00,#05,#05,#05,#05,#05,#05,#05,#05 
db #0D,#00,#64,#2E,#6C,#65,#76,#65,#6E,#00,#01,#2E,#00,#01,#F3,#00 ; #F0 ..d.leven.......

;100
db #00,#00,#07,#11,#02,#1A,#04,#0F
db #00,#00
db #0D,#1A,#03,#17,#01,#0E  ; palette

;110
db #00,#01,#0C,#18,#12,#15,#03,#06
db #00,#00
db #0E,#1A,#02,#18,#0C,#10 ; palette

;120
db #00,#01,#12,#1A,#09,#10,#18,#06,#00,#00,#04,#17,#0A,#16,#12,#09 
db #00,#01,#08,#18,#12,#10,#06,#03,#00,#00,#0D,#1A,#02,#1A,#10,#18 
db #00,#00,#0B,#17,#01,#16,#09,#12,#80,#00,#03,#12,#09,#1A,#10,#18 
db #00,#01,#05,#15,#12,#1A,#0C,#10,#00,#00,#06,#10,#03,#1A,#0A,#0D 
db #00,#00,#04,#17,#0A,#16,#12,#09,#00,#01,#09,#18,#12,#10,#06,#03 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #00,#00,#06,#12,#0C,#1A,#04,#0F,#00,#00,#0D,#1A,#04,#17,#02,#0E 
db #00,#00,#08,#1A,#14,#19,#02,#0E,#00,#00,#0D,#1A,#06,#18,#0C,#10 
db #00,#00,#12,#1A,#09,#10,#18,#06,#00,#00,#04,#1A,#0A,#16,#12,#09 
db #00,#00,#08,#18,#12,#1A,#14,#0E,#00,#00,#0A,#0F,#05,#19,#10,#14 
db #00,#00,#0B,#1A,#05,#16,#09,#10,#80,#00,#03,#09,#06,#1A,#10,#16 
db #00,#00,#09,#15,#12,#1A,#05,#10,#00,#00,#09,#10,#05,#1A,#0E,#14 
db #00,#00,#06,#17,#0A,#1A,#0A,#14,#00,#00,#0E,#1A,#14,#10,#06,#02 

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 

;200
db #00,#00,#00,#00,#00,#00,#00,#00,#16,#1E,#02,#04,#00,#7E,#01,#00 ; #1c0 .............~..
db #03,#10,#02,#05,#08,#00,#10,#00,#01,#18,#02,#05,#30,#00,#10,#04 ; #1d0 ............0...
db #02,#01,#00,#06,#00,#2A,#20,#00,#14,#07,#02,#02,#70,#00,#30,#03 ; #1e0 .....* .....p.0.
db #19,#05,#02,#03,#0A,#00,#30,#03,#10,#0C,#01,#06,#FF,#00,#00,#01 ; #1f0 ......0.........
db #17,#16,#02,#C5,#FF,#00,#10,#00,#15,#08,#03,#03,#1E,#00,#28,#03 ; #200 ..............(.
db #02,#08,#00,#07,#FF,#00,#00,#00,#12,#08,#00,#08,#FF,#00,#01,#00 ; #210 ................
db #0D,#0C,#00,#05,#FF,#00,#81,#00,#11,#10,#08,#04,#13,#00,#10,#03 ; #220 ................
db #16,#08,#02,#04,#12,#00,#28,#03,#13,#04,#04,#07,#20,#00,#28,#04 ; #230 ......(..... .(.
db #15,#03,#04,#08,#FF,#00,#28,#00,#17,#40,#01,#05,#FF,#00,#01,#02 ; #240 ......(..@......
db #1A,#08,#02,#05,#FF,#00,#10,#03,#18,#20,#00,#01,#FF,#00,#04,#00 ; #250 ......... ......
db #19,#10,#04,#04,#08,#00,#10,#03,#12,#0C,#00,#45,#78,#4A,#01,#00 ; #260 ...........ExJ..
db #0C,#17,#02,#04,#08,#00,#90,#04,#1A,#18,#08,#08,#C8,#D4,#01,#03 ; #270 ................
db #12,#10,#00,#03,#6E,#46,#01,#03,#01,#08,#04,#05,#FF,#00,#01,#00 ; #280 ....nF..........
db #01,#08,#02,#08,#40,#0C,#30,#03,#0C,#1E,#03,#04,#FF,#00,#90,#00 ; #290 ....@.0.........
db #11,#20,#0C,#0B,#FF,#00,#01,#03,#1B,#28,#04,#05,#0A,#18,#20,#03 ; #2a0 . .......(.... .
db #1C,#14,#02,#03,#B4,#20,#30,#03,#1D,#06,#06,#06,#E2,#DC,#20,#04 ; #2b0 ..... 0....... .
db #10,#08,#03,#05,#64,#00,#28,#04,#14,#04,#05,#07,#DC,#0C,#28,#04 ; #2c0 ....d.(.......(.
db #14,#08,#04,#05,#70,#00,#28,#04,#02,#20,#00,#05,#FF,#00,#01,#00 ; #2d0 ....p.(.. ......
db #02,#01,#00,#08,#DC,#18,#28,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #2e0 ......(.........

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #2f0 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #300 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #310 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #320 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #330 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #340 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #350 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #360 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #370 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #380 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #390 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3b0 ................



org #400
; --------------------- MAPS --------------------------

;Tiles 
; 00 => carré noir
; 01 => carré gris
; 02 => terrain1
; 03 => terrain2
; 04 => cercle
; 05 => sphere
; 06 => silo
; 07 => hexagon
; 08 => paserelle veritcale
; 09 => paserelle horizontale
; 0A => terrain quart 1
; 0B => terrain quart 2
; 0C => carré gris avec une peu de rouge en bas
; 0D => carré gris avec une peu de rouge en haut
; 0E => NA
; 0F => NA
; 10 => terrain quart 3
; 11 => terrain quart 4
; 12 => on dirait un joystick
; ...

; MAP Level 12 (=0) 
map12:
db #00,#00,#00,#00,#00,#00,#00,#0D,#F4,#B2,#B2,#F4,#01,#01,#01,#01 ; #3c0 ................
db #01,#01,#01,#B9,#F1,#01,#01,#1A,#1A,#1A,#B6,#01,#01,#01,#01,#01 ; #3d0 ................
db #01,#BF,#01,#01,#01,#01,#01,#86,#01,#01,#01,#01,#F1,#96,#F1,#F1 ; #3e0 ................
db #B6,#F1,#01,#01,#F0,#F0,#00,#00,#F0,#01,#01,#01,#86,#97,#97,#85 ; #3f0 ................
db #F1,#01,#01,#01,#85,#01,#01,#B5,#F0,#01,#01,#D2,#01,#01,#0C,#28 ; #400 ...............(
db #BF,#2A,#00,#28,#B9,#2A,#00,#28,#BB,#2A,#00,#28,#0D,#01,#01,#01 ; #410 .*.(.*.(.*.(....
db #20,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#39,#86 ; #420  .............9.
db #BA,#86,#39,#01,#01,#01,#01,#01,#01,#01,#01,#01,#20,#01,#39,#0C ; #430 ..9......... .9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B2,#B2,#B2,#F1,#01,#BA,#F1 ; #440 ................
db #01,#F1,#01,#F1,#01,#01,#01,#01,#1A,#1A,#BA,#01,#01,#01,#01,#85 ; #450 ................
db #97,#BF,#01,#01,#01,#01,#86,#BD,#86,#01,#01,#85,#97,#85,#01,#01 ; #460 ................
db #96,#01,#01,#F0,#F0,#00,#00,#00,#F0,#F0,#01,#01,#01,#F1,#01,#96 ; #470 ................
db #01,#01,#01,#01,#96,#D2,#01,#01,#01,#01,#01,#01,#B5,#F0,#0C,#29 ; #480 ...............)
db #00,#2B,#BB,#29,#00,#2B,#BF,#29,#00,#2B,#B9,#29,#0D,#01,#01,#01 ; #490 .+.).+.).+.)....
db #01,#01,#20,#01,#01,#01,#01,#B5,#38,#B5,#20,#B5,#01,#01,#BB,#39 ; #4a0 .. .....8. ....9
db #BC,#39,#BA,#F1,#01,#20,#01,#01,#F1,#01,#20,#01,#01,#39,#01,#0C ; #4b0 .9... .... ..9..
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#F4,#F4,#B2,#B2,#F1,#01,#01 ; #4c0 ................
db #01,#BC,#01,#01,#01,#01,#01,#BF,#1A,#1A,#1A,#01,#01,#01,#01,#01 ; #4d0 ................
db #01,#BF,#97,#97,#85,#01,#01,#86,#01,#01,#F1,#96,#F1,#01,#01,#01 ; #4e0 ................
db #96,#01,#F0,#F0,#00,#00,#00,#00,#00,#F0,#F0,#01,#01,#86,#97,#85 ; #4f0 ................
db #97,#97,#85,#97,#85,#01,#01,#01,#01,#B5,#F0,#01,#01,#01,#0C,#2A ; #500 ...............*
db #00,#28,#BF,#2A,#00,#28,#BD,#2A,#00,#28,#BF,#2A,#0D,#01,#01,#01 ; #510 .(.*.(.*.(.*....
db #01,#01,#01,#01,#01,#01,#38,#20,#38,#B5,#38,#01,#01,#01,#86,#86 ; #520 ......8 8.8.....
db #39,#86,#BD,#01,#01,#01,#20,#01,#01,#01,#01,#01,#39,#01,#20,#0C ; #530 9..... .....9. .
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B6,#B6,#B2,#B2,#B2,#F1,#01 ; #540 ................
db #01,#01,#F1,#01,#01,#F1,#01,#01,#1A,#1A,#1A,#01,#01,#01,#01,#01 ; #550 ................
db #01,#BF,#01,#01,#01,#01,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01 ; #560 ................
db #96,#01,#F0,#F0,#00,#00,#00,#00,#00,#F0,#F0,#01,#01,#01,#01,#96 ; #570 ................
db #F1,#01,#96,#01,#01,#B5,#F0,#01,#01,#81,#01,#B5,#F0,#01,#0C,#2B ; #580 ...............+
db #BF,#29,#00,#2B,#BF,#29,#00,#2B,#BF,#29,#00,#2B,#0D,#01,#01,#01 ; #590 .).+.).+.).+....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#20,#01,#39,#BB ; #5a0 ............ .9.
db #86,#BA,#39,#01,#01,#F1,#01,#01,#01,#01,#01,#01,#20,#01,#39,#0C ; #5b0 ..9......... .9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B6,#B6,#B2,#B2,#B2,#F1,#01 ; #5c0 ................
db #BC,#01,#01,#01,#BB,#01,#01,#01,#BC,#1A,#1A,#01,#01,#01,#BD,#97 ; #5d0 ................
db #97,#BF,#01,#01,#01,#01,#01,#01,#F1,#96,#F1,#01,#01,#01,#01,#01 ; #5e0 ................
db #96,#01,#01,#F0,#F0,#00,#00,#00,#F0,#F0,#01,#01,#01,#01,#01,#87 ; #5f0 ................
db #01,#01,#96,#F1,#01,#01,#01,#01,#B5,#F0,#01,#01,#01,#15,#0B,#28 ; #600 ...............(
db #BF,#2A,#00,#28,#BC,#2A,#00,#28,#B9,#2A,#00,#28,#0D,#01,#01,#01 ; #610 .*.(.*.(.*.(....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#86,#39 ; #620 ...............9
db #20,#39,#BD,#01,#01,#01,#01,#F1,#01,#20,#01,#01,#01,#39,#20,#0C ; #630  9....... ...9 .
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#F4,#F4,#B2,#B2,#F1,#B9,#01 ; #640 ................
db #F1,#F1,#01,#F1,#01,#01,#01,#01,#BB,#1A,#1A,#1A,#01,#01,#01,#01 ; #650 ................
db #01,#BF,#97,#85,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01,#01,#F1 ; #660 ................
db #B6,#F1,#01,#01,#F0,#F0,#00,#F0,#F0,#01,#01,#01,#01,#F1,#01,#01 ; #670 ................
db #85,#97,#85,#97,#85,#01,#01,#01,#01,#01,#01,#01,#0B,#2B,#B9,#29 ; #680 .............+.)
db #00,#2B,#BC,#29,#00,#2B,#BA,#29,#00,#2B,#BD,#29,#0D,#01,#20,#01 ; #690 .+.).+.).+.).. .
db #01,#01,#01,#01,#20,#01,#38,#B5,#38,#B5,#38,#81,#01,#01,#86,#BC ; #6a0 .... .8.8.8.....
db #39,#86,#BC,#20,#01,#01,#01,#01,#01,#01,#01,#01,#39,#01,#01,#0C ; #6b0 9.. ........9...
db #00,#00,#00,#00,#00,#00,#00,#0D,#B2,#B2,#B2,#B2,#F1,#01,#F1,#01 ; #6c0 ................
db #01,#BB,#01,#01,#BA,#01,#01,#01,#1A,#1A,#1A,#1A,#BF,#01,#01,#85 ; #6d0 ................
db #97,#BF,#01,#01,#01,#01,#F1,#96,#F1,#01,#01,#01,#01,#01,#01,#B6 ; #6e0 ................
db #B6,#B6,#01,#01,#01,#F0,#F0,#F0,#01,#01,#01,#01,#01,#01,#01,#01 ; #6f0 ................
db #96,#F1,#96,#01,#01,#01,#B5,#F0,#01,#01,#01,#0C,#00,#28,#BB,#2A ; #700 .............(.*
db #00,#28,#BF,#2A,#00,#28,#BF,#2A,#00,#28,#BA,#2A,#0D,#01,#01,#01 ; #710 .(.*.(.*.(.*....
db #01,#01,#01,#01,#01,#01,#01,#20,#20,#B5,#38,#B5,#01,#01,#39,#BA ; #720 .......  .8...9.
db #86,#BA,#86,#01,#01,#20,#01,#01,#01,#01,#F1,#01,#01,#20,#39,#0C ; #730 ..... ....... 9.
db #00,#00,#00,#00,#00,#00,#00,#0D,#F4,#B2,#B2,#F4,#01,#01,#01,#01 ; #740 ................
db #01,#01,#F1,#01,#01,#01,#01,#01,#1A,#1A,#1A,#1A,#01,#01,#01,#01 ; #750 ................
db #01,#BF,#01,#01,#01,#85,#97,#85,#01,#01,#01,#01,#01,#F1,#B6,#B6 ; #760 ................
db #B6,#B6,#B6,#F1,#01,#01,#01,#01,#01,#01,#01,#01,#F1,#01,#01,#01 ; #770 ................
db #87,#01,#96,#01,#01,#01,#01,#01,#81,#B5,#F0,#0C,#BF,#29,#00,#2B ; #780 .............).+
db #BC,#29,#00,#2B,#BF,#29,#00,#2B,#BF,#29,#00,#2B,#0D,#01,#01,#01 ; #790 .).+.).+.).+....
db #01,#20,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#86,#39 ; #7a0 . .............9
db #BB,#39,#BB,#01,#01,#01,#01,#01,#20,#01,#01,#01,#01,#39,#01,#0C ; #7b0 .9...... ....9..

map1:
map1_c1:
db #00,#00,#00,#00,#00,#00,#00,#00,#10,#02,#01,#01,#01,#01,#01,#01 ; #7c0 ................
db #03,#02,#03,#02,#01,#01,#01,#03,#01,#01,#02,#B5,#01,#01,#02,#01 ; #7d0 ................
db #02,#01,#01,#03,#01,#01,#01,#03,#03,#02,#02,#87,#02,#96,#01,#01 ; #7e0 ................
db #01,#03,#02,#02,#01,#03,#02,#01,#02,#02,#02,#96,#01,#03,#03,#96 ; #7f0 ................
db #01,#01,#01,#01,#03,#01,#03,#01,#01,#03,#01,#0B,#00,#00,#00,#10 ; #800 ................
db #03,#01,#01,#03,#02,#03,#03,#01,#01,#03,#87,#03,#87,#02,#87,#01 ; #810 ................
db #01,#01,#01,#B9,#03,#01,#01,#01,#02,#03,#02,#85,#97,#85,#97,#85 ; #820 ................
db #0A,#00,#11,#02,#0A,#10,#03,#0B,#00,#00,#11,#15,#0B,#00,#00,#00 ; #830 ................
map1_c2:
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#38,#38,#38,#01,#03,#02,#01 ; #840 .........888....
db #03,#03,#03,#01,#03,#02,#01,#01,#03,#03,#01,#96,#01,#01,#86,#86 ; #850 ................
db #86,#01,#02,#02,#03,#01,#01,#02,#02,#01,#03,#01,#01,#87,#01,#01 ; #860 ................
db #01,#01,#02,#01,#03,#01,#01,#02,#03,#01,#02,#B9,#02,#01,#03,#96 ; #870 ................
db #02,#02,#01,#03,#01,#03,#02,#01,#02,#02,#0C,#00,#00,#00,#00,#0D ; #880 ................
db #02,#02,#02,#03,#01,#01,#01,#01,#03,#87,#03,#87,#01,#87,#03,#03 ; #890 ................
db #01,#01,#03,#03,#01,#01,#02,#85,#01,#02,#01,#03,#03,#96,#01,#02 ; #8a0 ................
db #01,#0A,#00,#0D,#B9,#02,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8b0 ................
map1_c3:
db #00,#00,#00,#00,#00,#00,#00,#00,#38,#B6,#B6,#38,#38,#97,#97,#BB ; #8c0 ........8..88...
db #97,#85,#01,#02,#02,#02,#03,#01,#03,#02,#01,#96,#03,#01,#38,#B5 ; #8d0 ..............8.
db #86,#01,#03,#87,#02,#02,#03,#03,#02,#02,#01,#03,#01,#01,#01,#03 ; #8e0 ................
db #02,#01,#03,#02,#02,#02,#01,#01,#01,#01,#02,#03,#02,#03,#01,#B9 ; #8f0 ................
db #01,#01,#02,#BC,#97,#B9,#01,#01,#03,#02,#0B,#00,#00,#00,#10,#03 ; #900 ................
db #02,#02,#01,#01,#BC,#97,#85,#85,#02,#03,#87,#38,#38,#01,#87,#01 ; #910 ...........88...
db #03,#86,#03,#01,#03,#01,#02,#96,#01,#03,#01,#01,#02,#96,#02,#01 ; #920 ................
db #03,#03,#0A,#11,#15,#0B,#00,#00,#00,#10,#0A,#00,#00,#00,#00,#00 ; #930 ................
map1_c4:
db #00,#00,#00,#00,#00,#00,#00,#00,#38,#B6,#38,#B6,#38,#97,#97,#B9 ; #940 ........8.8.8...
db #01,#96,#03,#02,#03,#01,#01,#02,#03,#03,#03,#87,#02,#02,#86,#86 ; #950 ................
db #86,#97,#97,#B9,#01,#01,#01,#03,#01,#03,#03,#01,#01,#01,#0B,#0D ; #960 ................
db #02,#02,#02,#01,#03,#03,#03,#02,#01,#01,#01,#01,#01,#01,#01,#01 ; #970 ................
db #01,#01,#01,#96,#01,#96,#02,#02,#02,#0C,#00,#00,#00,#00,#0D,#03 ; #980 ................
db #03,#01,#01,#01,#02,#03,#85,#85,#97,#87,#01,#38,#B5,#87,#01,#01 ; #990 ...........8....
db #01,#0B,#11,#03,#03,#85,#97,#BB,#97,#85,#01,#85,#97,#85,#97,#85 ; #9a0 ................
db #01,#BA,#02,#0A,#00,#00,#00,#00,#00,#11,#0B,#00,#00,#00,#10,#0A ; #9b0 ................
map1_c5:
db #00,#00,#00,#00,#00,#00,#00,#00,#38,#38,#B6,#B6,#38,#97,#97,#BC ; #9c0 ........88..8...
db #01,#96,#03,#02,#02,#01,#01,#01,#03,#02,#02,#03,#02,#01,#03,#02 ; #9d0 ................
db #02,#03,#03,#87,#01,#01,#01,#02,#01,#01,#03,#01,#03,#0B,#00,#0D ; #9e0 ................
db #01,#01,#02,#01,#02,#02,#03,#02,#03,#01,#01,#B9,#01,#01,#01,#02 ; #9f0 ................
db #01,#01,#01,#85,#97,#85,#97,#38,#38,#38,#00,#00,#00,#00,#38,#B5 ; #a00 .......888....8.
db #38,#03,#03,#03,#03,#02,#96,#01,#03,#02,#87,#B5,#B5,#01,#87,#01 ; #a10 8...............
db #0C,#00,#00,#0D,#02,#03,#01,#96,#01,#96,#02,#01,#01,#96,#02,#01 ; #a20 ................
db #03,#02,#01,#02,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C ; #a30 ................
map1_c6:
db #00,#00,#00,#00,#00,#00,#00,#00,#38,#B6,#38,#B6,#38,#97,#97,#B9 ; #a40 ........8.8.8...
db #97,#85,#03,#01,#02,#02,#01,#01,#01,#01,#01,#02,#02,#01,#01,#02 ; #a50 ................
db #01,#02,#03,#02,#02,#03,#03,#01,#03,#87,#02,#03,#0C,#00,#00,#0D ; #a60 ................
db #01,#02,#03,#03,#02,#03,#02,#01,#01,#01,#02,#96,#02,#B9,#01,#03 ; #a70 ................
db #01,#01,#03,#96,#02,#96,#01,#03,#03,#01,#0A,#00,#00,#00,#11,#01 ; #a80 ................
db #02,#01,#03,#86,#02,#02,#BA,#01,#03,#87,#01,#38,#38,#87,#01,#03 ; #a90 ...........88...
db #0C,#00,#00,#0D,#01,#03,#02,#85,#01,#96,#01,#01,#01,#96,#03,#01 ; #aa0 ................
db #03,#01,#02,#B9,#02,#0A,#00,#00,#00,#00,#00,#00,#00,#10,#BB,#0B ; #ab0 ................
map1_c7:
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#38,#38,#38,#02,#01,#03,#01 ; #ac0 .........888....
db #01,#02,#01,#01,#03,#01,#03,#B5,#97,#85,#01,#01,#02,#01,#01,#02 ; #ad0 ................
db #03,#02,#01,#03,#02,#01,#03,#01,#01,#96,#01,#01,#0B,#00,#00,#0D ; #ae0 ................
db #01,#02,#01,#02,#03,#03,#01,#03,#01,#01,#03,#96,#03,#96,#02,#01 ; #af0 ................
db #01,#01,#02,#B9,#97,#B9,#03,#01,#01,#01,#01,#0A,#00,#00,#00,#11 ; #b00 ................
db #02,#02,#03,#01,#03,#01,#01,#03,#01,#03,#87,#03,#87,#01,#87,#01 ; #b10 ................
db #B9,#00,#00,#0D,#03,#01,#03,#03,#03,#B5,#01,#85,#97,#85,#97,#85 ; #b20 ................
db #01,#02,#01,#02,#03,#B9,#0A,#00,#00,#10,#14,#0A,#00,#11,#0B,#00 ; #b30 ................
map1_c8:
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#01,#01,#03,#01,#03,#01,#01 ; #b40 ................
db #01,#01,#01,#02,#02,#02,#01,#02,#01,#03,#02,#01,#01,#01,#03,#01 ; #b50 ................
db #01,#03,#01,#02,#01,#01,#02,#01,#01,#87,#01,#0C,#00,#00,#10,#02 ; #b60 ................
db #02,#01,#03,#02,#03,#02,#01,#03,#03,#01,#02,#96,#02,#96,#03,#03 ; #b70 ................
db #03,#02,#02,#02,#01,#01,#03,#01,#01,#01,#01,#01,#0A,#00,#00,#00 ; #b80 ................
db #11,#02,#03,#01,#01,#02,#03,#01,#01,#87,#01,#87,#03,#87,#01,#03 ; #b90 ................
db #0C,#00,#00,#0D,#02,#01,#03,#02,#03,#01,#03,#01,#02,#02,#03,#01 ; #ba0 ................
db #03,#B9,#03,#03,#02,#02,#02,#0A,#00,#0D,#BC,#0C,#00,#00,#00,#00 ; #bb0 ................



db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#03,#02,#02,#01,#03,#01,#03 ; #bc0 ................
db #01,#01,#03,#96,#01,#02,#96,#01,#01,#01,#02,#B9,#01,#0B,#10,#01 ; #bd0 ................
db #01,#01,#02,#01,#02,#03,#9B,#02,#01,#1A,#1A,#1A,#1A,#01,#03,#02 ; #be0 ................
db #01,#38,#98,#38,#02,#03,#01,#01,#03,#02,#01,#01,#01,#01,#01,#01 ; #bf0 .8.8............
db #01,#01,#01,#01,#99,#01,#03,#98,#01,#01,#02,#02,#01,#01,#01,#01 ; #c00 ................
db #B2,#98,#99,#01,#01,#01,#01,#01,#03,#01,#01,#01,#1A,#01,#03,#01 ; #c10 ................
db #99,#03,#01,#01,#99,#01,#01,#01,#01,#03,#B6,#97,#B2,#00,#0D,#1A ; #c20 ................
db #B2,#1A,#1A,#1A,#01,#01,#03,#03,#01,#01,#01,#1A,#1A,#1A,#1A,#0C ; #c30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#86,#B9,#BB,#B9,#86,#B9 ; #c40 ................
db #02,#01,#01,#96,#03,#01,#96,#01,#01,#01,#01,#01,#0B,#10,#01,#B9 ; #c50 ................
db #97,#B9,#01,#01,#9B,#03,#01,#01,#02,#03,#1A,#1A,#1A,#01,#01,#B2 ; #c60 ................
db #38,#98,#1A,#99,#38,#03,#01,#01,#01,#02,#01,#01,#01,#01,#BB,#86 ; #c70 8...8...........
db #BC,#86,#01,#01,#01,#02,#01,#01,#02,#01,#01,#02,#01,#03,#01,#01 ; #c80 ................
db #B6,#98,#99,#98,#01,#01,#03,#01,#99,#01,#01,#01,#1A,#1A,#03,#01 ; #c90 ................
db #01,#B2,#01,#98,#01,#01,#01,#01,#01,#02,#02,#01,#0B,#00,#0D,#1A ; #ca0 ................
db #1A,#1A,#1A,#1A,#01,#9B,#9B,#03,#9B,#01,#01,#B2,#1A,#1A,#1A,#0C ; #cb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#B9,#1A,#13,#1A,#13,#1A,#BB ; #cc0 ................
db #01,#86,#97,#86,#01,#01,#96,#01,#01,#01,#01,#01,#0A,#11,#01,#01 ; #cd0 ................
db #02,#96,#01,#01,#01,#01,#01,#01,#03,#1A,#B2,#1A,#1A,#01,#01,#01 ; #ce0 ................
db #01,#38,#99,#38,#02,#01,#03,#01,#01,#01,#01,#01,#01,#01,#86,#99 ; #cf0 .8.8............
db #98,#86,#01,#01,#03,#01,#99,#01,#99,#98,#BA,#01,#01,#01,#01,#01 ; #d00 ................
db #01,#01,#99,#01,#01,#03,#01,#B6,#B2,#1A,#01,#02,#1A,#1A,#1A,#01 ; #d10 ................
db #03,#96,#99,#98,#03,#99,#01,#02,#01,#01,#01,#0C,#00,#10,#01,#01 ; #d20 ................
db #03,#02,#1A,#02,#03,#9B,#9B,#9B,#9B,#9B,#01,#9B,#1A,#1A,#1A,#0C ; #d30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#13,#1A,#13,#1A,#13,#B9 ; #d40 ................
db #01,#96,#01,#96,#01,#01,#96,#01,#01,#01,#B9,#03,#0B,#10,#01,#01 ; #d50 ................
db #01,#96,#02,#01,#01,#01,#01,#01,#01,#1A,#1A,#1A,#1A,#01,#01,#01 ; #d60 ................
db #01,#01,#38,#03,#01,#38,#01,#03,#01,#02,#03,#B6,#97,#97,#86,#98 ; #d70 ..8..8..........
db #99,#86,#01,#01,#98,#99,#01,#98,#01,#01,#01,#01,#01,#01,#01,#01 ; #d80 ................
db #01,#01,#01,#98,#99,#01,#01,#B6,#B2,#1A,#03,#02,#B2,#B6,#1A,#01 ; #d90 ................
db #01,#96,#99,#01,#98,#01,#01,#B2,#01,#99,#01,#0C,#00,#0D,#01,#B2 ; #da0 ................
db #02,#1A,#1A,#03,#03,#9B,#B9,#BB,#9B,#9B,#01,#1A,#1A,#1A,#1A,#0C ; #db0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#BC,#1A,#13,#1A,#13,#1A,#BC ; #dc0 ................
db #01,#96,#02,#96,#01,#01,#96,#01,#02,#01,#03,#0B,#10,#01,#B9,#97 ; #dd0 ................
db #97,#B9,#97,#B6,#01,#01,#03,#9B,#01,#1A,#1A,#1A,#1A,#03,#01,#02 ; #de0 ................
db #01,#02,#01,#01,#38,#1A,#38,#01,#01,#01,#01,#01,#01,#01,#BA,#86 ; #df0 ....8.8.........
db #86,#86,#01,#01,#01,#BC,#02,#02,#01,#99,#01,#01,#01,#03,#01,#01 ; #e00 ................
db #01,#02,#98,#99,#01,#01,#01,#98,#01,#02,#B6,#98,#1A,#1A,#1A,#01 ; #e10 ................
db #03,#B6,#98,#99,#01,#99,#01,#03,#99,#01,#01,#0C,#00,#0D,#01,#1A ; #e20 ................
db #1A,#02,#1A,#01,#9B,#9B,#B2,#9B,#9B,#9B,#01,#1A,#1A,#1A,#1A,#0C ; #e30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#B9,#13,#1A,#13,#1A,#13,#B9 ; #e40 ................
db #01,#86,#97,#86,#02,#02,#BD,#01,#01,#03,#01,#0A,#11,#01,#01,#01 ; #e50 ................
db #9B,#96,#01,#01,#01,#9B,#01,#01,#01,#1A,#1A,#1A,#1A,#03,#01,#01 ; #e60 ................
db #01,#01,#B2,#38,#1A,#99,#1A,#38,#01,#01,#01,#01,#01,#01,#01,#01 ; #e70 ...8...8........
db #96,#01,#01,#01,#02,#01,#98,#BB,#01,#01,#03,#01,#03,#01,#01,#01 ; #e80 ................
db #01,#01,#B6,#B2,#98,#01,#01,#01,#01,#01,#96,#1A,#1A,#1A,#01,#01 ; #e90 ................
db #01,#B6,#97,#97,#B2,#99,#03,#99,#98,#01,#01,#B2,#00,#11,#02,#01 ; #ea0 ................
db #01,#01,#02,#01,#9B,#9B,#9B,#9B,#9B,#9B,#01,#1A,#1A,#9B,#1A,#0C ; #eb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#BA,#1A,#13,#1A,#13,#1A,#86 ; #ec0 ................
db #03,#01,#02,#96,#01,#01,#96,#01,#03,#B9,#02,#0B,#10,#03,#02,#01 ; #ed0 ................
db #02,#96,#01,#02,#01,#01,#01,#01,#01,#B2,#03,#1A,#1A,#01,#01,#01 ; #ee0 ................
db #01,#03,#01,#03,#38,#1A,#38,#01,#01,#03,#01,#01,#03,#01,#01,#03 ; #ef0 ....8.8.........
db #96,#01,#01,#01,#99,#01,#01,#01,#01,#98,#01,#01,#01,#01,#01,#02 ; #f00 ................
db #01,#99,#99,#98,#98,#01,#01,#01,#01,#01,#B2,#1A,#1A,#1A,#01,#01 ; #f10 ................
db #02,#01,#99,#98,#01,#03,#01,#01,#01,#01,#02,#96,#0A,#00,#0D,#1A ; #f20 ................
db #B2,#9B,#9B,#01,#9B,#9B,#9B,#9B,#9B,#9B,#9B,#1A,#1A,#1A,#1A,#0C ; #f30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#86,#B9,#86,#B9,#BA,#B9,#86 ; #f40 ................
db #01,#01,#01,#96,#01,#01,#96,#01,#01,#02,#0B,#10,#03,#B9,#97,#97 ; #f50 ................
db #97,#B9,#03,#01,#01,#01,#9B,#01,#01,#1A,#03,#1A,#03,#01,#01,#01 ; #f60 ................
db #01,#02,#01,#03,#01,#38,#01,#01,#01,#01,#01,#02,#02,#01,#02,#01 ; #f70 .....8..........
db #B6,#03,#01,#01,#01,#01,#01,#99,#02,#01,#01,#01,#01,#01,#01,#01 ; #f80 ................
db #01,#98,#98,#99,#01,#99,#99,#01,#03,#01,#03,#1A,#1A,#1A,#01,#01 ; #f90 ................
db #01,#01,#01,#01,#01,#01,#01,#03,#03,#03,#01,#B6,#0C,#00,#0D,#1A ; #fa0 ................
db #1A,#9B,#9B,#9B,#01,#01,#01,#01,#03,#9B,#9B,#1A,#1A,#1A,#1A,#0C ; #fb0 ................


db #00,#00,#00,#00,#00,#00,#00,#00,#1D,#38,#38,#38,#38,#38,#38,#38 ; #fc0 .........8888888
db #38,#38,#BA,#38,#38,#38,#38,#38,#38,#38,#38,#23,#00,#00,#00,#1C ; #fd0 88.88888888#....
db #38,#85,#38,#38,#38,#23,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #fe0 8.888#..........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #ff0 ................
db #00,#09,#00,#1C,#38,#38,#38,#00,#28,#29,#24,#08,#08,#08,#08,#24 ; #1000 ....888.()$....$
db #2A,#00,#00,#00,#00,#00,#28,#38,#38,#38,#38,#38,#38,#38,#85,#38 ; #1010 *.....(8888888.8
db #38,#38,#38,#38,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1020 8888"...........
db #00,#00,#00,#1C,#38,#38,#B9,#38,#38,#38,#38,#38,#38,#22,#00,#00 ; #1030 ....88.888888"..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#1D,#22,#1D,#22,#1D,#38,#38 ; #1040 ..........".".88
db #38,#38,#38,#B9,#38,#23,#92,#1D,#38,#38,#23,#00,#00,#00,#1C,#38 ; #1050 888.8#..88#....8
db #38,#38,#38,#85,#38,#22,#00,#00,#86,#86,#86,#00,#86,#86,#86,#00 ; #1060 888.8"..........
db #86,#86,#86,#00,#1C,#22,#1C,#22,#1C,#22,#1C,#22,#1C,#22,#00,#38 ; #1070 .....".".".".".8
db #22,#09,#1C,#38,#38,#13,#38,#08,#24,#00,#09,#00,#00,#00,#00,#09 ; #1080 "..88.8.$.......
db #2B,#2A,#00,#00,#00,#28,#29,#1D,#38,#38,#38,#B9,#38,#38,#38,#38 ; #1090 +*...().888.8888
db #38,#38,#38,#38,#38,#22,#00,#00,#00,#00,#1C,#38,#38,#22,#00,#00 ; #10a0 88888".....88"..
db #00,#00,#1C,#38,#38,#B9,#38,#38,#38,#38,#23,#1C,#38,#38,#22,#00 ; #10b0 ...88.8888#.88".
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#1D,#22,#1D,#22,#1D,#22 ; #10c0 ..........."."."
db #1D,#38,#B9,#38,#38,#22,#92,#1C,#38,#38,#08,#08,#08,#08,#38,#85 ; #10d0 .8.88"..88....8.
db #38,#38,#38,#38,#38,#23,#00,#00,#86,#24,#86,#00,#86,#24,#86,#00 ; #10e0 88888#...$...$..
db #86,#24,#86,#00,#38,#92,#86,#B9,#86,#86,#92,#38,#23,#2B,#2A,#38 ; #10f0 .$..8......8#+*8
db #38,#38,#13,#86,#13,#38,#38,#00,#2B,#2A,#09,#28,#86,#86,#2A,#09 ; #1100 88...88.+*.(..*.
db #00,#2B,#2A,#00,#28,#29,#00,#00,#1D,#38,#38,#38,#38,#38,#23,#1C ; #1110 .+*.()...88888#.
db #38,#22,#1D,#38,#85,#38,#08,#08,#08,#08,#38,#38,#BC,#38,#22,#00 ; #1120 8".8.8....88.8".
db #00,#00,#B5,#38,#38,#38,#01,#01,#B5,#38,#22,#1D,#38,#92,#38,#00 ; #1130 ...888...8".8.8.
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#1D,#B5,#38,#B5,#38 ; #1140 .............8.8
db #B5,#38,#38,#BB,#38,#38,#38,#38,#38,#38,#22,#00,#00,#00,#1D,#38 ; #1150 .88.888888"....8
db #38,#85,#38,#38,#38,#22,#00,#00,#00,#09,#00,#00,#00,#09,#00,#00 ; #1160 8.888"..........
db #00,#09,#00,#00,#38,#B9,#86,#86,#86,#B9,#86,#38,#00,#00,#2B,#38 ; #1170 ....8......8..+8
db #38,#13,#38,#13,#38,#38,#23,#00,#00,#2B,#38,#29,#BD,#B9,#2B,#38 ; #1180 8.8.88#..+8)..+8
db #00,#00,#38,#13,#38,#00,#00,#00,#00,#1D,#38,#38,#38,#B9,#22,#1D ; #1190 ..8.8.....888.".
db #38,#23,#1C,#38,#38,#38,#38,#00,#00,#38,#38,#38,#38,#38,#38,#38 ; #11a0 8#.8888..8888888
db #38,#38,#38,#38,#38,#38,#38,#38,#B9,#38,#38,#38,#38,#38,#38,#22 ; #11b0 88888888.888888"
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#1C,#38,#B5,#38,#B5 ; #11c0 ............8.8.
db #38,#38,#B9,#38,#38,#38,#38,#38,#38,#38,#23,#00,#00,#00,#1C,#38 ; #11d0 88.8888888#....8
db #38,#38,#38,#85,#38,#38,#08,#08,#08,#24,#08,#24,#08,#24,#08,#24 ; #11e0 888.88...$.$.$.$
db #08,#24,#08,#08,#38,#86,#B9,#86,#86,#86,#86,#38,#00,#00,#00,#38 ; #11f0 .$..8......8...8
db #13,#38,#86,#38,#13,#23,#00,#00,#00,#28,#38,#2A,#B9,#86,#28,#38 ; #1200 .8.8.#...(8*..(8
db #00,#00,#38,#13,#38,#00,#00,#00,#00,#1C,#38,#38,#38,#38,#23,#1C ; #1210 ..8.8.....8888#.
db #38,#22,#1D,#38,#38,#38,#38,#00,#00,#38,#38,#38,#38,#38,#38,#38 ; #1220 8".8888..8888888
db #38,#38,#B5,#38,#38,#38,#38,#38,#38,#38,#38,#38,#38,#38,#38,#23 ; #1230 88.888888888888#
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#1C,#23,#1C,#23,#1C,#23 ; #1240 ...........#.#.#
db #1C,#38,#38,#B9,#38,#23,#92,#1D,#38,#38,#08,#08,#08,#08,#38,#85 ; #1250 .88.8#..88....8.
db #38,#38,#38,#38,#38,#23,#00,#00,#00,#09,#00,#00,#00,#09,#00,#00 ; #1260 88888#..........
db #00,#09,#00,#00,#38,#86,#86,#B9,#86,#B9,#86,#38,#00,#00,#28,#38 ; #1270 ....8......8..(8
db #86,#13,#38,#13,#38,#00,#00,#00,#28,#29,#09,#2B,#86,#86,#29,#09 ; #1280 ..8.8...().+..).
db #00,#28,#29,#00,#2B,#2A,#00,#00,#1C,#38,#38,#BA,#38,#38,#22,#1D ; #1290 .().+*...88.88".
db #38,#23,#1C,#38,#38,#38,#08,#08,#08,#08,#38,#38,#B9,#38,#23,#00 ; #12a0 8#.888....88.8#.
db #00,#00,#B5,#38,#38,#38,#01,#01,#B5,#38,#22,#1D,#38,#38,#38,#00 ; #12b0 ...888...8".888.
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#1C,#23,#1C,#23,#1C,#38,#38 ; #12c0 ..........#.#.88
db #38,#38,#BC,#38,#38,#22,#92,#1C,#38,#38,#22,#00,#00,#00,#1D,#38 ; #12d0 88.88"..88"....8
db #38,#85,#38,#38,#38,#22,#00,#00,#86,#24,#86,#00,#86,#24,#86,#00 ; #12e0 8.888"...$...$..
db #86,#24,#86,#00,#38,#92,#86,#86,#86,#86,#92,#38,#22,#28,#29,#38 ; #12f0 .$..8......8"()8
db #13,#38,#13,#38,#38,#08,#08,#08,#24,#00,#09,#00,#00,#00,#00,#09 ; #1300 .8.88...$.......
db #28,#29,#00,#00,#00,#2B,#2A,#1C,#38,#38,#38,#38,#38,#38,#38,#38 ; #1310 ()...+*.88888888
db #38,#38,#38,#85,#38,#23,#00,#00,#00,#00,#1D,#38,#38,#23,#00,#00 ; #1320 888.8#.....88#..
db #00,#00,#1D,#38,#B9,#38,#38,#38,#38,#38,#23,#1C,#92,#38,#23,#00 ; #1330 ...8.88888#..8#.
db #00,#00,#00,#00,#00,#00,#00,#00,#1C,#38,#38,#38,#38,#38,#38,#38 ; #1340 .........8888888
db #38,#38,#38,#B9,#38,#38,#38,#38,#38,#38,#38,#22,#00,#00,#00,#1D ; #1350 888.8888888"....
db #38,#38,#38,#85,#38,#23,#00,#00,#86,#86,#86,#00,#86,#86,#86,#00 ; #1360 888.8#..........
db #86,#86,#86,#00,#1D,#23,#1D,#23,#1D,#23,#1D,#23,#1D,#23,#00,#1D ; #1370 .....#.#.#.#.#..
db #38,#86,#38,#38,#23,#00,#00,#00,#2B,#2A,#24,#08,#08,#08,#08,#24 ; #1380 8.88#...+*$....$
db #29,#00,#00,#00,#00,#00,#2B,#38,#38,#38,#38,#38,#38,#85,#38,#38 ; #1390 ).....+888888.88
db #38,#38,#38,#38,#23,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #13a0 8888#...........
db #00,#00,#00,#1D,#38,#38,#BB,#38,#38,#38,#38,#38,#38,#23,#00,#00 ; #13b0 ....88.888888#..


db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#01,#02,#03,#03,#02,#03,#02 ; #13c0 ................
db #02,#02,#03,#03,#87,#03,#02,#02,#02,#03,#02,#02,#02,#92,#03,#03 ; #13d0 ................
db #03,#92,#02,#02,#02,#03,#03,#02,#02,#03,#02,#03,#0A,#11,#15,#15 ; #13e0 ................
db #03,#0A,#00,#11,#15,#15,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #13f0 ................
db #00,#00,#00,#00,#11,#15,#15,#15,#03,#01,#03,#03,#02,#87,#97,#87 ; #1400 ................
db #02,#02,#03,#87,#03,#03,#01,#02,#02,#01,#03,#03,#01,#02,#02,#02 ; #1410 ................
db #15,#0B,#00,#11,#15,#0B,#00,#00,#00,#11,#03,#02,#01,#92,#03,#03 ; #1420 ................
db #01,#92,#02,#02,#02,#92,#01,#03,#03,#0B,#00,#00,#11,#15,#15,#0B ; #1430 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#02,#02,#02,#03,#02,#02,#01 ; #1440 ................
db #01,#87,#01,#03,#87,#01,#02,#87,#02,#03,#01,#03,#03,#02,#02,#B9 ; #1450 ................
db #01,#02,#02,#02,#01,#03,#02,#03,#02,#02,#01,#03,#0B,#00,#00,#00 ; #1460 ................
db #11,#15,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1470 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#11,#02,#03,#03,#03,#15,#15,#15 ; #1480 ................
db #03,#02,#03,#96,#03,#01,#B9,#97,#BA,#97,#B9,#03,#02,#03,#15,#0B ; #1490 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#03,#B9,#03,#B9,#02 ; #14a0 ................
db #15,#03,#03,#BC,#01,#03,#15,#15,#0B,#00,#00,#00,#00,#00,#00,#00 ; #14b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#03,#86,#97,#86,#02,#01,#01 ; #14c0 ................
db #03,#96,#02,#03,#96,#03,#02,#96,#02,#01,#03,#03,#02,#01,#BD,#13 ; #14d0 ................
db #B9,#02,#03,#03,#02,#03,#02,#15,#15,#15,#15,#0B,#10,#14,#14,#14 ; #14e0 ................
db #0A,#00,#11,#0A,#00,#00,#00,#00,#10,#14,#0A,#00,#00,#00,#00,#00 ; #14f0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#15,#15,#0B,#00,#00,#00 ; #1500 ................
db #11,#15,#03,#87,#02,#03,#03,#03,#96,#02,#02,#02,#15,#0B,#00,#00 ; #1510 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#15,#15,#15,#0B ; #1520 ................
db #00,#11,#15,#15,#15,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1530 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#01,#96,#92,#96,#02,#B9,#97 ; #1540 ................
db #97,#B9,#97,#97,#BB,#97,#97,#B9,#97,#86,#02,#03,#03,#03,#03,#BA ; #1550 ................
db #03,#01,#02,#02,#15,#15,#0B,#00,#00,#00,#00,#10,#03,#02,#02,#01 ; #1560 ................
db #0C,#00,#00,#11,#14,#0A,#00,#00,#0D,#92,#0C,#00,#00,#00,#00,#00 ; #1570 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1580 ................
db #00,#00,#11,#15,#15,#15,#15,#03,#B5,#02,#15,#0B,#00,#00,#00,#00 ; #1590 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #15a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #15b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#02,#96,#87,#96,#02,#02,#01 ; #15c0 ................
db #03,#96,#03,#01,#96,#03,#01,#96,#02,#01,#01,#02,#03,#92,#03,#01 ; #15d0 ................
db #02,#92,#15,#0B,#00,#00,#10,#14,#14,#14,#14,#01,#02,#03,#03,#15 ; #15e0 ................
db #0B,#00,#00,#00,#11,#0B,#00,#00,#11,#15,#0B,#00,#00,#1C,#B5,#22 ; #15f0 ..............."
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1600 ................
db #00,#00,#00,#00,#00,#00,#00,#11,#15,#0B,#00,#00,#00,#00,#00,#00 ; #1610 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1620 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#0A,#00,#00,#00,#00 ; #1630 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#03,#96,#92,#96,#03,#03,#02 ; #1640 ................
db #02,#87,#03,#03,#87,#02,#02,#87,#02,#02,#03,#02,#02,#03,#02,#15 ; #1650 ................
db #15,#0B,#00,#00,#10,#14,#01,#01,#03,#02,#03,#02,#03,#15,#0B,#00 ; #1660 ................
db #10,#14,#14,#0A,#00,#00,#10,#0A,#00,#00,#00,#00,#00,#BB,#B9,#B9 ; #1670 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1680 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1690 ................
db #00,#00,#10,#0A,#00,#10,#14,#14,#0A,#00,#00,#00,#00,#00,#00,#00 ; #16a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#02,#03,#0A,#00,#00,#00 ; #16b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#02,#86,#97,#86,#03,#02,#01 ; #16c0 ................
db #03,#02,#03,#02,#87,#02,#02,#02,#01,#01,#02,#03,#03,#02,#0B,#00 ; #16d0 ................
db #00,#00,#10,#14,#03,#02,#02,#03,#03,#01,#03,#01,#0B,#00,#10,#14 ; #16e0 ................
db #02,#01,#01,#02,#0A,#00,#11,#0B,#00,#00,#00,#00,#00,#1D,#B5,#23 ; #16f0 ...............#
db #00,#00,#00,#00,#10,#14,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1700 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1710 ................
db #10,#14,#03,#01,#14,#02,#02,#02,#01,#0A,#00,#00,#00,#00,#00,#00 ; #1720 ................
db #00,#00,#00,#00,#00,#00,#10,#14,#14,#01,#92,#02,#02,#0A,#00,#00 ; #1730 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#0D,#02,#03,#03,#03,#02,#02,#03 ; #1740 ................
db #01,#03,#02,#02,#02,#03,#03,#03,#03,#03,#02,#02,#02,#0B,#00,#10 ; #1750 ................
db #14,#14,#02,#03,#01,#02,#02,#02,#02,#02,#01,#0B,#10,#14,#03,#02 ; #1760 ................
db #02,#03,#02,#01,#0C,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1770 ................
db #00,#00,#00,#10,#02,#BA,#03,#14,#0A,#00,#00,#00,#10,#14,#14,#0A ; #1780 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#14,#14 ; #1790 ................
db #03,#02,#BD,#B9,#02,#01,#02,#02,#02,#01,#14,#14,#14,#14,#14,#14 ; #17a0 ................
db #14,#14,#14,#14,#14,#14,#02,#02,#BB,#02,#02,#03,#01,#01,#0A,#00 ; #17b0 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#01,#03,#85,#02,#02 ; #17c0 ................
db #92,#85,#92,#03,#03,#02,#02,#02,#03,#85,#01,#03,#02,#03,#02,#02 ; #17d0 ................
db #02,#03,#01,#02,#02,#02,#02,#01,#02,#01,#03,#01,#02,#02,#01,#02 ; #17e0 ................
db #01,#02,#03,#01,#01,#03,#02,#04,#03,#02,#02,#01,#03,#03,#03,#03 ; #17f0 ................
db #02,#02,#03,#01,#02,#03,#01,#03,#01,#0C,#08,#08,#0D,#02,#01,#02 ; #1800 ................
db #02,#01,#01,#03,#03,#02,#01,#02,#02,#02,#02,#03,#02,#03,#92,#01 ; #1810 ................
db #02,#01,#02,#02,#03,#02,#02,#01,#01,#02,#02,#02,#03,#03,#03,#02 ; #1820 ................
db #03,#BC,#86,#03,#01,#03,#03,#03,#03,#01,#02,#02,#03,#02,#02,#0B ; #1830 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#92,#02,#92,#02 ; #1840 ................
db #92,#92,#92,#01,#01,#02,#02,#02,#92,#96,#02,#02,#03,#03,#01,#02 ; #1850 ................
db #01,#03,#03,#02,#01,#02,#02,#01,#01,#02,#01,#02,#03,#02,#01,#02 ; #1860 ................
db #02,#03,#03,#02,#02,#02,#03,#01,#01,#02,#02,#01,#02,#01,#03,#02 ; #1870 ................
db #01,#03,#02,#02,#02,#02,#01,#02,#01,#0C,#00,#00,#11,#02,#04,#02 ; #1880 ................
db #02,#01,#03,#02,#01,#02,#03,#02,#02,#02,#01,#02,#02,#01,#92,#02 ; #1890 ................
db #92,#02,#02,#04,#03,#02,#01,#01,#01,#B9,#04,#01,#01,#02,#03,#01 ; #18a0 ................
db #02,#86,#86,#02,#04,#03,#03,#01,#01,#03,#02,#BB,#02,#03,#0C,#00 ; #18b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#02,#04,#B9 ; #18c0 ................
db #03,#03,#03,#02,#03,#02,#03,#02,#03,#96,#02,#01,#02,#01,#03,#02 ; #18d0 ................
db #01,#04,#03,#02,#03,#03,#03,#02,#02,#03,#02,#04,#02,#02,#01,#02 ; #18e0 ................
db #02,#02,#03,#01,#02,#03,#03,#01,#02,#02,#92,#02,#04,#02,#01,#02 ; #18f0 ................
db #01,#03,#02,#03,#02,#02,#13,#02,#01,#03,#0A,#00,#00,#11,#02,#02 ; #1900 ................
db #02,#02,#02,#01,#02,#02,#87,#02,#01,#01,#01,#03,#01,#01,#92,#BB ; #1910 ................
db #92,#01,#02,#03,#03,#03,#04,#03,#02,#02,#01,#02,#B9,#02,#04,#03 ; #1920 ................
db #02,#02,#02,#03,#03,#01,#02,#02,#02,#03,#02,#01,#02,#01,#0C,#00 ; #1930 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#92,#01,#92,#01 ; #1940 ................
db #92,#02,#92,#02,#01,#01,#02,#02,#02,#96,#03,#92,#02,#01,#02,#02 ; #1950 ................
db #01,#02,#02,#02,#02,#03,#01,#01,#02,#01,#04,#02,#03,#01,#02,#03 ; #1960 ................
db #02,#02,#02,#02,#03,#02,#01,#01,#03,#03,#04,#B9,#02,#02,#01,#03 ; #1970 ................
db #03,#01,#03,#02,#02,#13,#BD,#13,#01,#03,#03,#0A,#00,#00,#11,#02 ; #1980 ................
db #02,#03,#03,#02,#02,#02,#03,#B9,#02,#01,#03,#02,#02,#02,#92,#02 ; #1990 ................
db #92,#01,#03,#02,#02,#01,#03,#02,#01,#02,#02,#01,#02,#01,#01,#86 ; #19a0 ................
db #86,#01,#03,#03,#02,#02,#0B,#11,#01,#02,#01,#03,#03,#02,#0B,#00 ; #19b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#03,#03,#85,#03,#01 ; #19c0 ................
db #04,#85,#02,#01,#01,#03,#02,#BA,#97,#85,#02,#02,#03,#03,#02,#01 ; #19d0 ................
db #03,#02,#01,#01,#02,#02,#03,#01,#03,#03,#02,#02,#02,#02,#03,#03 ; #19e0 ................
db #04,#01,#02,#03,#03,#02,#03,#01,#01,#01,#02,#92,#02,#01,#02,#03 ; #19f0 ................
db #01,#02,#02,#03,#01,#01,#13,#02,#02,#02,#02,#02,#0A,#00,#00,#0D ; #1a00 ................
db #02,#02,#02,#02,#03,#02,#03,#03,#B9,#03,#02,#04,#02,#01,#92,#02 ; #1a10 ................
db #92,#01,#03,#03,#02,#04,#02,#02,#03,#02,#01,#02,#02,#01,#02,#BA ; #1a20 ................
db #86,#02,#92,#02,#03,#0C,#08,#08,#0D,#03,#03,#03,#01,#0C,#00,#00 ; #1a30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#02,#02,#92,#01,#92,#92 ; #1a40 ................
db #92,#02,#92,#03,#01,#03,#03,#96,#03,#96,#03,#03,#02,#01,#02,#01 ; #1a50 ................
db #03,#03,#02,#02,#03,#04,#02,#02,#03,#02,#01,#02,#01,#02,#02,#03 ; #1a60 ................
db #03,#02,#02,#01,#02,#02,#02,#02,#01,#03,#02,#03,#03,#02,#01,#02 ; #1a70 ................
db #01,#01,#04,#02,#01,#03,#02,#03,#03,#01,#02,#02,#01,#0A,#00,#0D ; #1a80 ................
db #03,#02,#02,#01,#01,#01,#87,#02,#03,#01,#01,#01,#03,#02,#92,#BA ; #1a90 ................
db #92,#03,#02,#02,#03,#02,#03,#01,#02,#02,#02,#02,#02,#01,#02,#04 ; #1aa0 ................
db #02,#03,#02,#03,#03,#02,#0A,#10,#03,#02,#02,#01,#01,#02,#0A,#00 ; #1ab0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#03,#B9,#02,#02,#92,#BD ; #1ac0 ................
db #92,#01,#03,#03,#01,#01,#03,#96,#02,#85,#97,#85,#01,#03,#02,#01 ; #1ad0 ................
db #02,#01,#02,#02,#03,#02,#01,#02,#02,#02,#02,#02,#02,#03,#03,#01 ; #1ae0 ................
db #03,#02,#02,#02,#02,#02,#01,#02,#03,#02,#01,#03,#02,#02,#02,#03 ; #1af0 ................
db #01,#02,#02,#02,#02,#01,#02,#03,#02,#03,#03,#01,#02,#0C,#08,#0D ; #1b00 ................
db #02,#03,#01,#02,#04,#01,#03,#02,#02,#02,#02,#02,#01,#02,#92,#03 ; #1b10 ................
db #92,#01,#02,#04,#02,#03,#01,#03,#01,#04,#B9,#02,#03,#01,#01,#03 ; #1b20 ................
db #02,#02,#03,#86,#86,#02,#02,#02,#01,#01,#03,#BC,#02,#01,#01,#0A ; #1b30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#02,#02,#02,#01,#92,#92 ; #1b40 ................
db #92,#02,#03,#03,#02,#03,#02,#85,#01,#02,#01,#03,#03,#03,#03,#04 ; #1b50 ................
db #02,#01,#02,#02,#01,#02,#03,#01,#03,#02,#01,#01,#03,#03,#01,#03 ; #1b60 ................
db #02,#03,#02,#02,#02,#04,#02,#03,#01,#03,#03,#02,#03,#02,#02,#03 ; #1b70 ................
db #03,#02,#01,#02,#03,#01,#02,#03,#02,#01,#03,#03,#02,#0C,#00,#0D ; #1b80 ................
db #03,#02,#01,#01,#03,#01,#01,#03,#02,#01,#01,#02,#01,#02,#92,#03 ; #1b90 ................
db #01,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02 ; #1ba0 ................
db #02,#02,#02,#BB,#86,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#0C ; #1bb0 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1bc0 ................
db #00,#00,#00,#00,#00,#00,#00,#1D,#B9,#97,#97,#85,#01,#01,#01,#15 ; #1bd0 ................
db #01,#01,#01,#01,#01,#15,#15,#15,#01,#01,#01,#01,#01,#92,#01,#01 ; #1be0 ................
db #01,#01,#01,#01,#01,#01,#13,#13,#13,#13,#13,#01,#01,#13,#13,#13 ; #1bf0 ................
db #01,#01,#01,#01,#85,#01,#01,#96,#01,#01,#85,#01,#01,#01,#01,#01 ; #1c00 ................
db #01,#01,#01,#01,#01,#01,#01,#01,#92,#92,#BB,#92,#92,#01,#01,#01 ; #1c10 ................
db #01,#01,#01,#01,#01,#01,#01,#85,#01,#85,#01,#01,#01,#01,#01,#01 ; #1c20 ................
db #13,#01,#01,#01,#0A,#11,#01,#85,#01,#01,#01,#01,#85,#01,#01,#0B ; #1c30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1c40 ................
db #00,#00,#00,#00,#00,#1C,#22,#00,#1D,#86,#97,#97,#85,#01,#0B,#00 ; #1c50 ......".........
db #11,#01,#01,#85,#0B,#00,#00,#00,#11,#01,#01,#92,#01,#01,#15,#15 ; #1c60 ................
db #15,#15,#15,#01,#01,#01,#13,#01,#01,#01,#13,#01,#13,#01,#01,#01 ; #1c70 ................
db #13,#01,#01,#01,#96,#01,#01,#96,#01,#01,#96,#01,#01,#01,#01,#85 ; #1c80 ................
db #85,#85,#85,#85,#01,#01,#01,#01,#01,#92,#92,#92,#01,#15,#01,#01 ; #1c90 ................
db #01,#93,#01,#93,#01,#01,#01,#01,#BC,#01,#01,#01,#15,#01,#01,#BC ; #1ca0 ................
db #92,#13,#01,#01,#01,#0A,#11,#01,#01,#85,#01,#01,#01,#01,#0B,#00 ; #1cb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1cc0 ................
db #00,#00,#00,#00,#10,#01,#86,#22,#00,#1D,#38,#15,#15,#0B,#10,#14 ; #1cd0 ......."..8.....
db #0A,#11,#01,#38,#00,#10,#38,#86,#22,#11,#01,#01,#01,#0B,#00,#00 ; #1ce0 ...8..8.".......
db #00,#00,#00,#11,#01,#01,#13,#01,#01,#01,#13,#01,#13,#01,#01,#13 ; #1cf0 ................
db #13,#01,#85,#97,#BC,#97,#97,#B9,#97,#97,#B9,#97,#85,#01,#01,#01 ; #1d00 ................
db #01,#96,#01,#01,#01,#01,#01,#01,#01,#01,#92,#01,#0B,#00,#11,#01 ; #1d10 ................
db #01,#01,#87,#01,#01,#01,#01,#85,#01,#85,#01,#0B,#00,#11,#01,#01 ; #1d20 ................
db #13,#01,#01,#01,#01,#01,#0A,#11,#01,#01,#01,#01,#01,#0B,#00,#00 ; #1d30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1d40 ................
db #00,#00,#00,#00,#11,#01,#96,#86,#22,#00,#00,#00,#00,#10,#01,#92 ; #1d50 ........".......
db #0C,#00,#0D,#86,#00,#0D,#85,#97,#B9,#00,#0D,#01,#0C,#00,#1C,#92 ; #1d60 ................
db #B9,#92,#22,#00,#0D,#01,#01,#13,#13,#13,#01,#92,#01,#13,#13,#13 ; #1d70 ..".............
db #01,#01,#01,#01,#96,#01,#01,#96,#01,#01,#96,#01,#01,#01,#01,#85 ; #1d80 ................
db #85,#85,#85,#85,#01,#01,#01,#92,#01,#01,#01,#0C,#00,#B9,#00,#0D ; #1d90 ................
db #01,#93,#01,#93,#01,#01,#01,#01,#01,#01,#0C,#00,#B9,#00,#0D,#01 ; #1da0 ................
db #01,#01,#01,#01,#01,#01,#01,#0A,#11,#15,#BB,#15,#0B,#00,#00,#00 ; #1db0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1dc0 ................
db #00,#00,#10,#0A,#00,#11,#85,#97,#BB,#38,#BC,#14,#14,#01,#01,#01 ; #1dd0 .........8......
db #0B,#10,#01,#86,#00,#0D,#96,#92,#86,#00,#0D,#01,#0C,#00,#92,#B9 ; #1de0 ................
db #96,#B9,#92,#00,#0D,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01 ; #1df0 ................
db #01,#01,#01,#01,#85,#01,#01,#96,#01,#01,#85,#01,#01,#01,#01,#01 ; #1e00 ................
db #01,#01,#01,#01,#01,#01,#92,#92,#92,#01,#01,#01,#0A,#00,#10,#01 ; #1e10 ................
db #01,#01,#01,#01,#01,#13,#01,#01,#01,#01,#01,#0A,#00,#10,#01,#01 ; #1e20 ................
db #01,#01,#01,#13,#01,#01,#BB,#0C,#00,#00,#00,#00,#00,#00,#00,#00 ; #1e30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1e40 ................
db #00,#10,#01,#92,#0A,#00,#0D,#01,#96,#01,#96,#01,#01,#01,#92,#0C ; #1e50 ................
db #00,#0D,#86,#86,#00,#0D,#85,#97,#BA,#00,#0D,#01,#0C,#00,#BC,#97 ; #1e60 ................
db #BD,#96,#B9,#00,#0D,#01,#92,#01,#01,#13,#13,#13,#13,#13,#01,#92 ; #1e70 ................
db #01,#01,#01,#01,#01,#85,#97,#B9,#97,#85,#01,#01,#01,#01,#01,#86 ; #1e80 ................
db #01,#01,#01,#86,#01,#92,#92,#B9,#92,#92,#01,#01,#01,#14,#01,#92 ; #1e90 ................
db #01,#01,#01,#01,#13,#92,#13,#01,#01,#85,#01,#01,#14,#01,#01,#85 ; #1ea0 ................
db #01,#01,#BA,#92,#13,#01,#01,#0B,#10,#14,#BD,#14,#0A,#00,#00,#00 ; #1eb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1ec0 ................
db #10,#01,#01,#01,#01,#0A,#11,#01,#87,#01,#87,#01,#01,#92,#01,#01 ; #1ed0 ................
db #0A,#11,#15,#0B,#10,#01,#01,#92,#23,#10,#01,#92,#0C,#00,#1D,#BB ; #1ee0 ........#.......
db #92,#B9,#23,#00,#0D,#01,#01,#01,#01,#13,#01,#13,#01,#13,#01,#01 ; #1ef0 ..#.............
db #01,#92,#01,#01,#01,#01,#01,#96,#01,#01,#01,#01,#01,#01,#01,#B9 ; #1f00 ................
db #97,#97,#97,#86,#01,#01,#92,#92,#92,#01,#01,#01,#01,#01,#92,#92 ; #1f10 ................
db #92,#01,#01,#01,#01,#13,#01,#01,#85,#BA,#85,#01,#01,#01,#85,#92 ; #1f20 ................
db #85,#01,#01,#13,#01,#01,#0C,#00,#0D,#01,#01,#01,#85,#0A,#00,#00 ; #1f30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10 ; #1f40 ................
db #01,#01,#92,#01,#01,#01,#0A,#11,#01,#01,#01,#01,#01,#01,#01,#01 ; #1f50 ................
db #01,#0A,#00,#10,#01,#01,#01,#0C,#00,#0D,#01,#01,#01,#0A,#00,#00 ; #1f60 ................
db #00,#00,#00,#10,#01,#01,#01,#01,#01,#13,#01,#01,#01,#13,#01,#01 ; #1f70 ................
db #01,#01,#01,#01,#01,#01,#01,#85,#01,#01,#01,#01,#01,#01,#01,#86 ; #1f80 ................
db #01,#01,#01,#B7,#01,#01,#01,#92,#01,#01,#01,#01,#01,#92,#92,#BD ; #1f90 ................
db #92,#92,#01,#01,#01,#01,#01,#01,#01,#85,#01,#01,#01,#01,#01,#85 ; #1fa0 ................
db #01,#01,#01,#01,#01,#01,#0C,#00,#0D,#85,#01,#01,#01,#01,#0A,#00 ; #1fb0 ................

db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#38 ; #1fc0 ,,,,,,,,,,,,,,,8
db #B5,#2C,#BA,#38,#B9,#2C,#38,#B5,#2C,#2C,#2C,#2C,#2C,#ED,#2C,#BA ; #1fd0 .,.8.,8.,,,,,.,.
db #2C,#F0,#2C,#2C,#2C,#23,#1D,#38,#38,#38,#23,#1D,#2C,#2C,#2C,#2C ; #1fe0 ,.,,,#.888#.,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #1ff0 ,,,,,,,,,,,,,,,,
db #2C,#2C,#2C,#2C,#B9,#B9,#2C,#B9,#B9,#2C,#2C,#B9,#B9,#B9,#2C,#2C ; #2000 ,,,,..,..,,...,,
db #2C,#13,#38,#B5,#38,#B5,#38,#13,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2010 ,.8.8.8.,,,,,,,,
db #2C,#2C,#2C,#ED,#22,#00,#00,#00,#1C,#38,#2C,#2C,#2C,#2C,#2C,#2C ; #2020 ,,,."....8,,,,,,
db #2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2030 ,,,.,,,,.,,,,,,,
db #ED,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#2C,#13,#13,#13 ; #2040 .,.,,,,,.,,,,...
db #96,#13,#96,#13,#96,#13,#13,#96,#13,#13,#2C,#2C,#2C,#2C,#2C,#2C ; #2050 ..........,,,,,,
db #2C,#2C,#2C,#2C,#ED,#22,#00,#00,#00,#00,#00,#1C,#ED,#2C,#2C,#38 ; #2060 ,,,,.".......,,8
db #38,#B5,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#2C,#2C ; #2070 8.,,,,,,,,.,,,,,
db #2C,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#2C,#2C,#2C ; #2080 ,,,..,,,..,,,,,,
db #2C,#13,#38,#92,#38,#92,#38,#13,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2090 ,.8.8.8.,,,,,,,,
db #2C,#2C,#2C,#38,#B5,#00,#00,#00,#38,#B5,#38,#2C,#2C,#2C,#2C,#2C ; #20a0 ,,,8....8.8,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C ; #20b0 ,,,,,,,,,.,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#ED,#2C,#13,#01,#92 ; #20c0 ,,,,,,,,,,,.,...
db #96,#01,#96,#01,#87,#01,#01,#85,#01,#13,#2C,#2C,#2C,#2C,#BB,#2C ; #20d0 ..........,,,,.,
db #F0,#2C,#2C,#2C,#2C,#38,#00,#00,#00,#00,#00,#38,#2C,#2C,#2C,#2C ; #20e0 .,,,,8.....8,,,,
db #2C,#B9,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#BC,#00,#B9,#2C,#2C,#2C,#2C ; #20f0 ,.,,,.,,,...,,,,
db #2C,#2C,#2C,#B9,#2C,#2C,#ED,#2C,#2C,#B9,#2C,#2C,#2C,#2C,#2C,#2C ; #2100 ,,,.,,.,,.,,,,,,
db #2C,#13,#38,#38,#BD,#38,#38,#13,#2C,#2C,#2C,#2C,#13,#13,#2C,#2C ; #2110 ,.88.88.,,,,..,,
db #2C,#2C,#2C,#ED,#38,#00,#00,#00,#38,#B5,#2C,#2C,#ED,#2C,#2C,#BB ; #2120 ,,,.8...8.,,.,,.
db #2C,#2C,#2C,#2C,#2C,#BD,#B9,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2130 ,,,,,..,,,,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#13,#01,#01 ; #2140 ,,,,,,,,,.,,,...
db #85,#97,#BB,#01,#87,#01,#01,#96,#92,#13,#2C,#2C,#2C,#2C,#2C,#2C ; #2150 ..........,,,,,,
db #2C,#2C,#2C,#ED,#2C,#38,#00,#00,#00,#00,#00,#38,#2C,#2C,#2C,#B9 ; #2160 ,,,.,8.....8,,,.
db #2C,#2C,#2C,#2C,#BA,#00,#B9,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#2C,#2C ; #2170 ,,,,...,,,.,,,,,
db #2C,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#2C,#2C,#2C ; #2180 ,,,..,,,..,,,,,,
db #2C,#13,#38,#92,#38,#92,#38,#13,#2C,#2C,#2C,#13,#ED,#ED,#13,#2C ; #2190 ,.8.8.8.,,,....,
db #2C,#2C,#2C,#38,#B5,#00,#00,#00,#1D,#38,#38,#2C,#2C,#2C,#B9,#2C ; #21a0 ,,,8.....88,,,.,
db #2C,#2C,#2C,#2C,#2C,#BC,#B9,#2C,#2C,#2C,#2C,#38,#38,#B5,#2C,#2C ; #21b0 ,,,,,..,,,,88.,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#13,#92,#01 ; #21c0 ,,,,,,,,,,,,,...
db #96,#01,#01,#01,#96,#01,#92,#96,#01,#13,#2C,#2C,#2C,#B9,#2C,#F0 ; #21d0 ..........,,,.,.
db #2C,#ED,#2C,#2C,#2C,#23,#00,#00,#00,#00,#00,#1D,#2C,#38,#38,#B5 ; #21e0 ,.,,,#......,88.
db #2C,#2C,#2C,#B9,#2C,#B9,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#B9 ; #21f0 ,,,.,.,,,,,,,,,.
db #B9,#B9,#2C,#2C,#B9,#B9,#2C,#B9,#B9,#2C,#2C,#B9,#B9,#B9,#2C,#2C ; #2200 ..,,..,..,,...,,
db #2C,#13,#38,#38,#B5,#38,#B5,#13,#2C,#2C,#2C,#13,#ED,#ED,#13,#2C ; #2210 ,.88.8..,,,....,
db #2C,#2C,#2C,#ED,#38,#22,#00,#00,#1C,#38,#ED,#2C,#2C,#B9,#2C,#2C ; #2220 ,,,.8"...8.,,.,,
db #2C,#2C,#2C,#2C,#2C,#BB,#B9,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#ED ; #2230 ,,,,,..,,,,,,,,.
db #2C,#2C,#ED,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#B9,#2C,#2C,#13,#01,#01 ; #2240 ,,.,,,,.,,.,,...
db #85,#97,#BC,#97,#85,#97,#97,#85,#01,#13,#2C,#2C,#2C,#2C,#2C,#2C ; #2250 ..........,,,,,,
db #2C,#2C,#2C,#2C,#ED,#22,#1C,#38,#38,#38,#22,#1C,#2C,#2C,#2C,#2C ; #2260 ,,,,.".888".,,,,
db #2C,#38,#38,#B5,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#B9,#B9 ; #2270 ,88.,,,,,,,,,,..
db #2C,#B9,#B9,#2C,#2C,#B9,#B9,#B9,#2C,#2C,#B9,#B9,#2C,#B9,#B9,#2C ; #2280 ,..,,...,,..,..,
db #2C,#13,#13,#13,#13,#13,#13,#13,#2C,#2C,#2C,#2C,#13,#13,#2C,#2C ; #2290 ,.......,,,,..,,
db #2C,#2C,#2C,#38,#38,#38,#22,#1C,#38,#38,#38,#2C,#B9,#2C,#2C,#ED ; #22a0 ,,,888".888,.,,.
db #2C,#2C,#2C,#2C,#2C,#BA,#B9,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C ; #22b0 ,,,,,..,,.,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#13,#13,#13 ; #22c0 ,,,,,,,,,,,,,...
db #96,#13,#96,#13,#96,#13,#13,#96,#13,#13,#2C,#2C,#2C,#2C,#BC,#2C ; #22d0 ..........,,,,.,
db #F0,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C ; #22e0 .,,,,,,,,.,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#B9,#2C,#2C,#2C,#2C,#2C,#B9,#B9,#2C ; #22f0 ,,,,,,,.,,,,,..,
db #2C,#2C,#B9,#B9,#2C,#2C,#2C,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#B9,#B9 ; #2300 ,,..,,,,,..,,,..
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2310 ,,,,,,,,,,,,,,,,
db #2C,#2C,#2C,#ED,#B5,#38,#B5,#38,#B5,#38,#2C,#2C,#2C,#2C,#2C,#2C ; #2320 ,,,..8.8.8,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#38,#38,#B5,#2C,#2C,#2C ; #2330 ,,,,,,,,,,88.,,,
db #2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#38 ; #2340 ,,,,.,,,,,,,,,,8
db #B5,#2C,#B9,#38,#B9,#2C,#38,#B5,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2350 .,.8.,8.,,,,,,,,
db #2C,#2C,#2C,#2C,#2C,#ED,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2360 ,,,,,.,.,,,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#BB,#00,#B9,#2C,#2C,#2C,#2C,#B9,#2C,#2C ; #2370 ,,,,,,...,,,,.,,
db #ED,#2C,#2C,#B9,#B9,#2C,#2C,#2C,#2C,#B9,#2C,#2C,#ED,#2C,#2C,#B9 ; #2380 .,,..,,,,.,,.,,.
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2390 ,,,,,,,,,,,,,,,,
db #2C,#2C,#2C,#38,#38,#B5,#ED,#B5,#38,#38,#38,#2C,#2C,#2C,#2C,#2C ; #23a0 ,,,88...888,,,,,
db #2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #23b0 ,,,.,,,,.,,,,,,,

db #00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#2B,#BB,#39,#BB,#29,#00 ; #23c0 ..........+.9.).
db #00,#00,#00,#BC,#39,#BC,#29,#00,#09,#00,#38,#38,#38,#38,#38,#22 ; #23d0 ....9.)...88888"
db #1C,#23,#1D,#38,#22,#00,#00,#00,#00,#00,#1C,#38,#38,#38,#38,#22 ; #23e0 .#.8"......8888"
db #00,#00,#00,#26,#25,#27,#00,#26,#25,#27,#00,#26,#25,#27,#00,#1C ; #23f0 ...&%''.&%''.&%''..
db #B9,#22,#00,#00,#00,#00,#00,#00,#21,#00,#24,#2A,#00,#00,#24,#29 ; #2400 ."......!.$*..$)
db #00,#2B,#2A,#00,#00,#00,#00,#00,#00,#00,#00,#00,#1C,#BA,#B9,#B9 ; #2410 .+*.............
db #22,#00,#00,#1C,#B9,#B9,#B9,#22,#00,#00,#00,#00,#00,#00,#00,#00 ; #2420 "......"........
db #00,#00,#00,#00,#00,#33,#25,#25,#27,#00,#00,#22,#00,#00,#00,#00 ; #2430 .....3%%''.."....
db #00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#28,#BB,#39,#BB,#2A,#00 ; #2440 ..........(.9.*.
db #00,#00,#28,#BC,#39,#BC,#2A,#00,#09,#00,#38,#38,#38,#23,#1D,#38 ; #2450 ..(.9.*...888#.8
db #B9,#22,#1C,#38,#38,#22,#00,#00,#00,#00,#38,#BA,#38,#B9,#38,#38 ; #2460 .".88"....8.8.88
db #00,#26,#25,#27,#21,#26,#25,#27,#21,#26,#25,#27,#21,#00,#00,#1D ; #2470 .&%''!&%''!&%''!...
db #B9,#23,#00,#00,#00,#00,#00,#00,#21,#28,#29,#2B,#2A,#28,#29,#00 ; #2480 .#......!()+*().
db #00,#00,#2B,#24,#38,#38,#38,#38,#22,#00,#00,#00,#38,#B5,#38,#B5 ; #2490 ..+$8888"...8.8.
db #38,#08,#08,#38,#38,#38,#38,#38,#2A,#00,#00,#28,#38,#38,#38,#38 ; #24a0 8..88888*..(8888
db #22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#33,#25,#25,#27,#00,#00 ; #24b0 ".........3%%''..
db #00,#00,#00,#00,#00,#00,#00,#00,#09,#28,#29,#BB,#BB,#BB,#2B,#2A ; #24c0 .........()...+*
db #00,#28,#29,#BC,#BC,#BC,#2B,#2A,#09,#28,#29,#38,#38,#22,#1C,#23 ; #24d0 .()...+*.()88".#
db #1D,#B9,#38,#38,#85,#38,#22,#00,#00,#00,#1D,#38,#38,#38,#BA,#38 ; #24e0 ..88.8"....888.8
db #22,#00,#21,#00,#21,#00,#21,#00,#21,#00,#21,#00,#21,#00,#00,#00 ; #24f0 ".!.!.!.!.!.!...
db #21,#00,#00,#1C,#38,#38,#22,#00,#24,#29,#00,#00,#24,#29,#00,#00 ; #2500 !...88".$)..$)..
db #00,#00,#00,#00,#21,#00,#21,#1D,#23,#00,#00,#00,#1D,#B9,#BB,#B9 ; #2510 ....!.!.#.......
db #23,#00,#00,#1D,#B9,#B9,#B9,#23,#2B,#24,#28,#29,#33,#25,#25,#38 ; #2520 #......#+$()3%%8
db #38,#27,#00,#00,#00,#00,#00,#00,#00,#00,#26,#25,#25,#25,#25,#27 ; #2530 8''........&%%%%''
db #00,#00,#00,#00,#00,#00,#00,#00,#24,#29,#00,#00,#00,#00,#00,#2B ; #2540 ........$).....+
db #24,#29,#00,#00,#00,#00,#00,#2B,#24,#29,#1C,#38,#38,#38,#B9,#22 ; #2550 $).....+$).888."
db #1C,#23,#1D,#38,#38,#85,#38,#22,#00,#00,#00,#38,#B9,#38,#38,#38 ; #2560 .#.88.8"...8.888
db #38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86 ; #2570 8.8.8.8.8.8.8.8.
db #38,#86,#38,#38,#38,#38,#85,#00,#21,#00,#00,#B9,#B9,#B9,#00,#00 ; #2580 8.8888..!.......
db #00,#00,#00,#33,#25,#25,#25,#27,#00,#00,#00,#00,#00,#09,#00,#09 ; #2590 ...3%%%''........
db #00,#00,#00,#00,#00,#09,#00,#00,#00,#24,#29,#00,#00,#21,#21,#38 ; #25a0 .........$)..!!8
db #85,#00,#00,#33,#25,#25,#27,#00,#00,#00,#33,#25,#25,#27,#00,#00 ; #25b0 ...3%%''...3%%''..
db #00,#00,#00,#00,#00,#00,#00,#00,#24,#2A,#00,#00,#00,#00,#00,#28 ; #25c0 ........$*.....(
db #24,#2A,#00,#00,#00,#00,#00,#28,#24,#2A,#1D,#38,#38,#23,#1D,#38 ; #25d0 $*.....($*.88#.8
db #B9,#22,#1C,#38,#38,#85,#38,#23,#00,#00,#00,#38,#B9,#38,#38,#38 ; #25e0 .".88.8#...8.888
db #38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86,#38,#86 ; #25f0 8.8.8.8.8.8.8.8.
db #38,#86,#38,#38,#38,#38,#85,#00,#21,#00,#00,#BB,#B9,#B9,#00,#00 ; #2600 8.8888..!.......
db #00,#00,#00,#00,#21,#00,#21,#00,#00,#00,#00,#00,#00,#09,#00,#09 ; #2610 ....!.!.........
db #00,#00,#00,#00,#00,#09,#00,#00,#00,#24,#2A,#00,#00,#21,#21,#38 ; #2620 .........$*..!!8
db #85,#00,#00,#00,#1D,#BC,#22,#00,#00,#00,#00,#23,#00,#00,#00,#00 ; #2630 ......"....#....
db #00,#00,#00,#00,#00,#00,#00,#00,#09,#2B,#2A,#BC,#BC,#BC,#28,#29 ; #2640 .........+*...()
db #00,#2B,#2A,#BA,#BA,#BA,#28,#29,#09,#2B,#2A,#38,#38,#22,#1C,#23 ; #2650 .+*...().+*88".#
db #1D,#B9,#38,#38,#85,#38,#23,#00,#00,#00,#1C,#38,#38,#38,#BC,#38 ; #2660 ..88.8#....888.8
db #23,#00,#21,#00,#21,#00,#21,#00,#21,#00,#21,#00,#21,#00,#00,#00 ; #2670 #.!.!.!.!.!.!...
db #21,#00,#00,#1D,#38,#38,#23,#00,#21,#00,#00,#B9,#BD,#B9,#00,#00 ; #2680 !...88#.!.......
db #00,#00,#00,#33,#25,#25,#25,#27,#00,#00,#00,#00,#1C,#BC,#B9,#B9 ; #2690 ...3%%%''........
db #22,#00,#00,#1C,#B9,#B9,#B9,#22,#28,#24,#2B,#2A,#33,#25,#25,#38 ; #26a0 "......"($+*3%%8
db #38,#27,#00,#00,#33,#25,#25,#25,#25,#27,#00,#00,#00,#00,#00,#00 ; #26b0 8''..3%%%%''......
db #00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#2B,#BC,#39,#BC,#29,#00 ; #26c0 ..........+.9.).
db #00,#00,#2B,#BA,#39,#BA,#29,#00,#09,#00,#38,#38,#38,#38,#38,#22 ; #26d0 ..+.9.)...88888"
db #1C,#23,#1D,#38,#38,#23,#00,#00,#00,#00,#38,#B9,#38,#B9,#38,#38 ; #26e0 .#.88#....8.8.88
db #00,#26,#25,#27,#21,#26,#25,#27,#21,#26,#25,#27,#21,#00,#00,#1C ; #26f0 .&%''!&%''!&%''!...
db #B9,#22,#00,#00,#00,#00,#00,#00,#24,#2A,#00,#00,#24,#2A,#00,#00 ; #2700 ."......$*..$*..
db #00,#00,#00,#00,#21,#00,#21,#1C,#22,#00,#00,#00,#38,#B5,#38,#B5 ; #2710 ....!.!."...8.8.
db #38,#08,#08,#38,#38,#38,#38,#38,#29,#00,#00,#2B,#38,#38,#38,#38 ; #2720 8..88888)..+8888
db #23,#00,#00,#00,#1C,#BB,#23,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #2730 #.....#.........
db #00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#28,#BC,#39,#BC,#2A,#00 ; #2740 ..........(.9.*.
db #00,#00,#28,#BA,#39,#BA,#2A,#00,#09,#00,#38,#38,#38,#23,#1D,#38 ; #2750 ..(.9.*...888#.8
db #B9,#22,#1C,#38,#23,#00,#00,#00,#00,#00,#1D,#38,#38,#38,#38,#23 ; #2760 .".8#......8888#
db #00,#00,#00,#26,#25,#27,#00,#26,#25,#27,#00,#26,#25,#27,#00,#1D ; #2770 ...&%''.&%''.&%''..
db #B9,#23,#00,#00,#00,#00,#00,#00,#21,#2B,#2A,#28,#29,#2B,#2A,#00 ; #2780 .#......!+*()+*.
db #00,#00,#28,#24,#38,#38,#38,#38,#23,#00,#00,#00,#1D,#B9,#B9,#BD ; #2790 ..($8888#.......
db #23,#00,#00,#1D,#B9,#B9,#B9,#23,#00,#00,#00,#00,#00,#00,#00,#00 ; #27a0 #......#........
db #00,#00,#00,#33,#25,#25,#27,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #27b0 ...3%%''.........


db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C,#00,#00,#11,#0A ; #27c0 ................
db #10,#0B,#00,#00,#00,#10,#F4,#0A,#00,#00,#00,#00,#00,#00,#00,#00 ; #27d0 ................
db #10,#01,#0A,#10,#01,#15,#F4,#0A,#00,#00,#11,#15,#01,#15,#01,#15 ; #27e0 ................
db #01,#15,#01,#15,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#00 ; #27f0 ................
db #00,#10,#F4,#F4,#F4,#F4,#2C,#2C,#2C,#F4,#00,#00,#00,#00,#00,#F4 ; #2800 ......,,,.......
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#F4,#2C,#2C,#2C,#2C,#2C,#24,#00,#00 ; #2810 ,,,,,,,.,,,,,$..
db #09,#00,#10,#0B,#00,#11,#0A,#00,#00,#00,#00,#00,#00,#00,#00,#11 ; #2820 ................
db #15,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #2830 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#F4,#0B,#00,#00,#00,#11 ; #2840 ................
db #0B,#00,#00,#00,#00,#11,#F4,#0B,#00,#00,#00,#00,#00,#00,#00,#00 ; #2850 ................
db #0D,#F4,#01,#01,#0B,#00,#11,#F4,#0A,#00,#00,#10,#0B,#10,#0B,#10 ; #2860 ................
db #0B,#10,#0B,#00,#11,#14,#0A,#00,#00,#00,#00,#00,#00,#09,#00,#00 ; #2870 ................
db #10,#F4,#00,#00,#00,#00,#F4,#2C,#2C,#F4,#00,#00,#00,#00,#00,#F4 ; #2880 .......,,.......
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#24,#08,#08 ; #2890 ,,,,,,,,,,,,,$..
db #24,#00,#11,#0A,#00,#00,#11,#0A,#00,#00,#00,#00,#00,#00,#00,#00 ; #28a0 $...............
db #00,#00,#00,#00,#00,#00,#00,#24,#08,#08,#08,#24,#08,#08,#08,#24 ; #28b0 .......$...$...$
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C,#00,#00,#00,#00,#00 ; #28c0 ................
db #00,#00,#00,#00,#00,#00,#09,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #28d0 ................
db #0D,#01,#01,#0B,#00,#00,#00,#11,#F4,#00,#10,#0B,#10,#0B,#10,#0B ; #28e0 ................
db #10,#0B,#00,#00,#00,#11,#F4,#0A,#00,#00,#00,#00,#00,#F4,#08,#08 ; #28f0 ................
db #F4,#00,#00,#00,#00,#00,#00,#F4,#2C,#2C,#F4,#00,#00,#00,#F4,#2C ; #2900 ........,,.....,
db #2C,#2C,#38,#38,#38,#38,#F4,#38,#2C,#2C,#F4,#2C,#2C,#24,#00,#00 ; #2910 ,,8888.8,,.,,$..
db #00,#00,#10,#0B,#00,#00,#00,#11,#0A,#00,#00,#00,#00,#00,#00,#00 ; #2920 ................
db #00,#00,#00,#00,#00,#00,#00,#09,#00,#00,#00,#09,#00,#00,#00,#09 ; #2930 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#F4,#0A,#00,#00,#00,#00 ; #2940 ................
db #00,#00,#10,#0A,#00,#00,#09,#00,#00,#10,#0A,#00,#00,#00,#00,#00 ; #2950 ................
db #0D,#F4,#0C,#00,#00,#00,#00,#00,#00,#10,#0B,#10,#0B,#10,#0B,#10 ; #2960 ................
db #0B,#00,#00,#00,#00,#00,#0D,#01,#0A,#00,#00,#00,#00,#09,#00,#00 ; #2970 ................
db #F4,#00,#00,#00,#00,#00,#00,#F4,#2C,#2C,#2C,#F4,#F4,#F4,#2C,#2C ; #2980 ........,,,...,,
db #2C,#2C,#F4,#00,#00,#00,#00,#38,#2C,#2C,#2C,#2C,#2C,#24,#00,#00 ; #2990 ,,.....8,,,,,$..
db #00,#00,#11,#0A,#00,#00,#00,#00,#0D,#0A,#00,#00,#00,#00,#00,#00 ; #29a0 ................
db #00,#00,#00,#10,#14,#0A,#00,#09,#00,#00,#00,#09,#00,#00,#00,#09 ; #29b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C,#00,#00,#00,#00 ; #29c0 ................
db #00,#00,#F4,#F4,#08,#08,#F4,#08,#08,#F4,#F4,#00,#00,#00,#00,#00 ; #29d0 ................
db #11,#01,#0C,#00,#00,#00,#00,#00,#10,#0B,#10,#0B,#10,#0B,#10,#0B ; #29e0 ................
db #00,#00,#00,#00,#00,#00,#11,#01,#01,#0A,#00,#00,#00,#09,#00,#00 ; #29f0 ................
db #F4,#00,#00,#00,#00,#00,#00,#F4,#2C,#ED,#2C,#2C,#2C,#2C,#2C,#2C ; #2a00 ........,.,,,,,,
db #2C,#2C,#38,#00,#00,#00,#00,#38,#2C,#2C,#2C,#2C,#2C,#24,#00,#00 ; #2a10 ,,8....8,,,,,$..
db #00,#00,#10,#0B,#00,#00,#00,#10,#0B,#11,#14,#0A,#00,#10,#14,#0A ; #2a20 ................
db #00,#00,#10,#01,#01,#0C,#08,#24,#00,#00,#00,#09,#00,#00,#00,#09 ; #2a30 .......$........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#F4,#0A,#00,#00,#00 ; #2a40 ................
db #00,#00,#11,#0B,#00,#00,#09,#00,#00,#11,#0B,#00,#00,#00,#00,#00 ; #2a50 ................
db #00,#11,#0C,#00,#00,#00,#00,#10,#0B,#10,#0B,#10,#0B,#10,#0B,#00 ; #2a60 ................
db #00,#00,#00,#00,#00,#00,#00,#0D,#01,#F4,#08,#08,#08,#F4,#00,#00 ; #2a70 ................
db #F4,#00,#00,#00,#00,#00,#00,#F4,#2C,#2C,#2C,#2C,#ED,#2C,#2C,#2C ; #2a80 ........,,,,.,,,
db #2C,#2C,#38,#38,#F4,#38,#38,#38,#2C,#2C,#2C,#2C,#2C,#24,#08,#08 ; #2a90 ,,88.888,,,,,$..
db #24,#00,#11,#0A,#00,#00,#10,#0B,#00,#00,#11,#15,#14,#01,#F4,#0C ; #2aa0 $...............
db #00,#00,#0D,#01,#01,#0C,#00,#09,#00,#00,#00,#24,#08,#08,#08,#24 ; #2ab0 ...........$...$
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#0C,#00,#00,#00 ; #2ac0 ................
db #00,#00,#00,#00,#00,#00,#09,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #2ad0 ................
db #00,#00,#11,#0A,#00,#00,#10,#0B,#10,#0B,#10,#0B,#10,#0B,#00,#00 ; #2ae0 ................
db #00,#00,#00,#00,#00,#00,#00,#11,#15,#0B,#00,#00,#00,#09,#00,#00 ; #2af0 ................
db #11,#F4,#00,#00,#00,#00,#F4,#2C,#2C,#ED,#2C,#2C,#2C,#2C,#ED,#2C ; #2b00 .......,,.,,,,.,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#F4,#2C,#2C,#2C,#24,#00,#00 ; #2b10 ,,,,,,,,,.,,,$..
db #09,#00,#10,#0B,#00,#10,#0B,#10,#0A,#00,#00,#00,#11,#15,#15,#0B ; #2b20 ................
db #00,#00,#0D,#01,#01,#0B,#00,#09,#00,#00,#00,#09,#00,#00,#00,#00 ; #2b30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#F4,#0A,#00,#00 ; #2b40 ................
db #00,#00,#00,#00,#00,#10,#F4,#0A,#00,#00,#00,#00,#00,#00,#00,#00 ; #2b50 ................
db #00,#00,#00,#11,#14,#14,#01,#14,#01,#14,#01,#14,#01,#0A,#00,#00 ; #2b60 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#09,#00,#00 ; #2b70 ................
db #00,#11,#F4,#F4,#F4,#F4,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C ; #2b80 ......,,,,,,,,,,
db #2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#2C,#24,#00,#00 ; #2b90 ,,,,,,,,,,,,,$..
db #09,#00,#11,#0A,#10,#0B,#10,#0B,#11,#0A,#00,#00,#00,#00,#00,#00 ; #2ba0 ................
db #00,#00,#0D,#01,#0B,#00,#00,#24,#08,#08,#08,#24,#00,#00,#00,#00 ; #2bb0 .......$...$....

db #01,#01,#02,#01,#01,#01,#01,#01,#03,#01,#04,#01,#01,#01,#01,#01 ; #2bc0 ................
db #0A,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#1A,#1A,#1A,#1A,#1A,#1A ; #2bd0 ................
db #01,#B9,#01,#BA,#01,#BB,#01,#B9,#01,#B9,#01,#9B,#01,#F4,#0C,#00 ; #2be0 ................
db #00,#11,#01,#01,#01,#01,#01,#01,#86,#97,#86,#97,#86,#02,#01,#01 ; #2bf0 ................
db #01,#01,#92,#0B,#00,#00,#00,#00,#10,#92,#01,#92,#01,#92,#01,#92 ; #2c00 ................
db #01,#01,#87,#87,#01,#85,#97,#85,#02,#85,#01,#13,#85,#F4,#85,#13 ; #2c10 ................
db #01,#01,#B6,#01,#B6,#01,#B6,#01,#0A,#00,#11,#01,#01,#F4,#01,#F4 ; #2c20 ................
db #01,#F4,#01,#F4,#01,#01,#01,#01,#01,#B9,#B9,#B9,#01,#01,#01,#01 ; #2c30 ................
db #01,#02,#01,#04,#01,#01,#01,#01,#01,#03,#03,#01,#92,#01,#01,#01 ; #2c40 ................
db #04,#0A,#00,#00,#00,#00,#00,#00,#10,#02,#1A,#1A,#1A,#B2,#1A,#1A ; #2c50 ................
db #01,#01,#01,#01,#01,#01,#01,#01,#03,#01,#01,#9B,#01,#9B,#0C,#00 ; #2c60 ................
db #00,#00,#0D,#1A,#9B,#1A,#01,#01,#96,#03,#96,#01,#96,#01,#01,#01 ; #2c70 ................
db #01,#92,#0B,#00,#00,#00,#00,#10,#92,#01,#92,#01,#92,#01,#92,#01 ; #2c80 ................
db #92,#01,#01,#01,#01,#96,#01,#96,#01,#96,#01,#01,#13,#85,#13,#01 ; #2c90 ................
db #01,#01,#01,#B6,#01,#B6,#03,#B6,#0C,#00,#00,#0D,#04,#01,#87,#01 ; #2ca0 ................
db #01,#01,#01,#01,#01,#01,#04,#01,#01,#B9,#3C,#B9,#01,#B9,#B9,#B9 ; #2cb0 ..........<.....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#02,#92,#13,#92,#03,#01 ; #2cc0 ................
db #03,#01,#14,#14,#B9,#B9,#B9,#14,#01,#03,#F4,#1A,#1A,#1A,#1A,#1A ; #2cd0 ................
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#02,#9B,#F4,#0C,#00 ; #2ce0 ................
db #00,#00,#0D,#1A,#B2,#1A,#B6,#97,#86,#97,#85,#97,#86,#01,#01,#01 ; #2cf0 ................
db #92,#0C,#00,#00,#00,#00,#10,#92,#02,#92,#01,#92,#01,#92,#01,#92 ; #2d00 ................
db #01,#92,#01,#01,#01,#85,#01,#85,#97,#85,#01,#01,#01,#13,#01,#01 ; #2d10 ................
db #03,#01,#01,#01,#B6,#01,#B6,#01,#0C,#00,#00,#11,#01,#01,#96,#04 ; #2d20 ................
db #01,#01,#BD,#97,#87,#01,#01,#85,#01,#B9,#B9,#B9,#97,#B9,#3D,#B9 ; #2d30 ..............=.
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#02,#92,#13,#85,#13,#92,#01 ; #2d40 ................
db #01,#B9,#03,#15,#15,#15,#15,#15,#01,#01,#01,#1A,#1A,#1A,#B2,#1A ; #2d50 ................
db #01,#01,#F4,#97,#F4,#97,#F4,#97,#F4,#01,#9B,#01,#01,#01,#0B,#00 ; #2d60 ................
db #00,#00,#0D,#1A,#1A,#1A,#01,#01,#96,#01,#96,#01,#96,#01,#92,#01 ; #2d70 ................
db #01,#0C,#00,#00,#00,#10,#92,#01,#92,#01,#92,#01,#92,#01,#92,#01 ; #2d80 ................
db #92,#01,#92,#01,#01,#01,#01,#02,#F4,#01,#01,#01,#01,#01,#01,#01 ; #2d90 ................
db #04,#01,#01,#B6,#01,#B6,#01,#01,#F4,#0A,#00,#00,#0D,#01,#BB,#97 ; #2da0 ................
db #BC,#01,#96,#01,#01,#03,#01,#96,#01,#96,#01,#96,#01,#B9,#B9,#B9 ; #2db0 ................
db #01,#04,#01,#01,#01,#01,#01,#01,#01,#92,#13,#01,#96,#01,#13,#92 ; #2dc0 ................
db #01,#01,#0B,#00,#00,#00,#00,#00,#11,#01,#1A,#1A,#B2,#1A,#1A,#1A ; #2dd0 ................
db #01,#01,#01,#F4,#97,#F4,#97,#F4,#01,#01,#B2,#01,#9B,#0C,#00,#00 ; #2de0 ................
db #00,#00,#11,#03,#01,#01,#01,#03,#86,#97,#86,#97,#86,#01,#01,#01 ; #2df0 ................
db #92,#01,#0A,#00,#00,#0D,#01,#92,#01,#92,#01,#92,#01,#92,#01,#92 ; #2e00 ................
db #01,#92,#01,#03,#03,#01,#01,#04,#01,#85,#97,#85,#97,#85,#01,#13 ; #2e10 ................
db #13,#13,#01,#01,#B6,#01,#B6,#01,#01,#0B,#00,#10,#01,#01,#96,#01 ; #2e20 ................
db #96,#03,#87,#01,#01,#85,#97,#B9,#B9,#B9,#01,#96,#01,#96,#02,#01 ; #2e30 ................
db #01,#01,#01,#01,#04,#01,#01,#01,#92,#13,#85,#97,#87,#97,#85,#13 ; #2e40 ................
db #92,#0C,#00,#00,#00,#00,#00,#00,#00,#0D,#1A,#1A,#1A,#1A,#1A,#01 ; #2e50 ................
db #01,#04,#01,#01,#01,#01,#01,#01,#01,#01,#01,#02,#01,#0C,#00,#00 ; #2e60 ................
db #00,#00,#00,#11,#01,#F4,#01,#01,#01,#01,#96,#01,#01,#03,#01,#01 ; #2e70 ................
db #01,#92,#0C,#08,#08,#0D,#92,#02,#92,#01,#92,#01,#92,#01,#92,#01 ; #2e80 ................
db #92,#01,#01,#87,#87,#01,#01,#01,#01,#96,#01,#96,#01,#01,#01,#13 ; #2e90 ................
db #85,#13,#01,#F4,#01,#B6,#01,#01,#01,#0A,#00,#11,#01,#01,#87,#02 ; #2ea0 ................
db #87,#01,#01,#01,#03,#01,#01,#B9,#3A,#B9,#01,#B9,#B9,#B9,#01,#01 ; #2eb0 ........:.......
db #01,#01,#01,#01,#01,#01,#01,#01,#03,#92,#13,#01,#96,#01,#13,#92 ; #2ec0 ................
db #01,#0C,#00,#00,#00,#00,#00,#00,#00,#11,#01,#01,#1A,#1A,#01,#01 ; #2ed0 ................
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#9B,#01,#0C,#00,#00 ; #2ee0 ................
db #00,#00,#00,#00,#0D,#01,#01,#01,#01,#01,#B6,#01,#01,#01,#1A,#1A ; #2ef0 ................
db #01,#01,#02,#0A,#00,#11,#01,#92,#03,#92,#01,#92,#01,#92,#01,#92 ; #2f00 ................
db #01,#01,#87,#87,#87,#87,#F4,#01,#01,#85,#97,#85,#01,#01,#01,#13 ; #2f10 ................
db #13,#13,#01,#01,#01,#01,#F4,#01,#F4,#0B,#00,#10,#01,#01,#01,#01 ; #2f20 ................
db #01,#01,#04,#01,#01,#01,#01,#B9,#B9,#B9,#97,#B9,#3B,#B9,#01,#04 ; #2f30 ............;...
db #01,#01,#02,#01,#01,#02,#01,#02,#03,#01,#92,#13,#85,#13,#92,#01 ; #2f40 ................
db #01,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#0D,#01,#01,#F4,#01,#01 ; #2f50 ................
db #01,#01,#B9,#01,#BC,#03,#B9,#01,#BD,#01,#01,#01,#9B,#01,#0A,#00 ; #2f60 ................
db #00,#10,#0A,#00,#11,#01,#01,#01,#01,#01,#01,#01,#F4,#01,#B2,#1A ; #2f70 ................
db #01,#01,#92,#0C,#00,#00,#11,#01,#92,#01,#92,#01,#92,#01,#92,#01 ; #2f80 ................
db #01,#01,#01,#87,#87,#03,#01,#01,#01,#01,#02,#01,#02,#01,#03,#01 ; #2f90 ................
db #01,#01,#01,#01,#01,#02,#01,#01,#0B,#00,#10,#01,#01,#01,#F4,#01 ; #2fa0 ................
db #F4,#03,#F4,#01,#01,#01,#01,#01,#01,#01,#01,#B9,#B9,#B9,#02,#01 ; #2fb0 ................

db #13,#13,#13,#13,#13,#38,#B5,#13,#13,#F0,#2C,#2C,#F0,#13,#13,#F0 ; #2fc0 .....8....,,....
db #00,#00,#00,#F0,#13,#13,#13,#B9,#01,#01,#13,#01,#01,#01,#01,#F1 ; #2fd0 ................
db #01,#01,#01,#13,#13,#13,#13,#13,#38,#B5,#B5,#B5,#B5,#38,#13,#13 ; #2fe0 ........8....8..
db #13,#13,#13,#13,#13,#13,#13,#13,#F0,#2C,#F0,#13,#13,#13,#13,#13 ; #2ff0 .........,......
db #13,#13,#F0,#97,#97,#B7,#97,#97,#F0,#13,#13,#13,#13,#13,#13,#13 ; #3000 ................
db #13,#13,#13,#B9,#B9,#B9,#B9,#13,#F1,#13,#13,#13,#13,#13,#13,#13 ; #3010 ................
db #13,#13,#F1,#13,#13,#13,#13,#13,#38,#38,#38,#13,#13,#13,#01,#01 ; #3020 ........888.....
db #01,#01,#01,#F1,#01,#01,#01,#01,#13,#13,#13,#13,#13,#13,#13,#13 ; #3030 ................
db #13,#13,#13,#13,#38,#B5,#38,#B5,#13,#13,#F0,#2C,#2C,#F0,#13,#13 ; #3040 ....8.8....,,...
db #F0,#00,#F0,#13,#13,#13,#13,#13,#B9,#01,#01,#01,#F1,#01,#01,#01 ; #3050 ................
db #13,#01,#13,#13,#13,#13,#13,#38,#F1,#BD,#97,#97,#B9,#F1,#38,#13 ; #3060 .......8......8.
db #13,#13,#13,#13,#13,#13,#F0,#F0,#F0,#ED,#F0,#F0,#13,#13,#13,#13 ; #3070 ................
db #F0,#13,#13,#F0,#01,#96,#01,#F0,#13,#13,#13,#13,#13,#13,#38,#38 ; #3080 ..............88
db #B5,#13,#13,#13,#13,#13,#13,#13,#13,#F0,#F0,#F0,#F0,#13,#F0,#F0 ; #3090 ................
db #F0,#F0,#13,#13,#13,#13,#13,#13,#38,#13,#38,#13,#13,#13,#13,#13 ; #30a0 ........8.8.....
db #01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#13,#13,#13,#13,#13,#13 ; #30b0 ................
db #13,#13,#13,#13,#13,#38,#B5,#13,#13,#F0,#2C,#2C,#F0,#13,#13,#13 ; #30c0 .....8....,,....
db #13,#F0,#13,#13,#13,#F0,#13,#13,#13,#BA,#01,#01,#01,#13,#01,#01 ; #30d0 ................
db #01,#01,#13,#13,#13,#13,#13,#38,#38,#96,#B9,#B9,#96,#38,#38,#13 ; #30e0 .......88....88.
db #13,#13,#13,#13,#13,#13,#F0,#2C,#ED,#2C,#ED,#F0,#13,#13,#13,#F0 ; #30f0 .......,.,......
db #96,#F0,#13,#13,#F0,#96,#F0,#13,#13,#13,#13,#F1,#13,#13,#13,#13 ; #3100 ................
db #13,#13,#B9,#BA,#B9,#B9,#13,#13,#13,#F0,#2C,#2C,#F0,#F0,#F0,#2C ; #3110 ..........,,...,
db #2C,#F0,#13,#13,#13,#13,#13,#13,#38,#38,#38,#38,#13,#13,#13,#13 ; #3120 ,.......8888....
db #13,#13,#13,#01,#86,#97,#97,#86,#01,#01,#13,#13,#13,#13,#13,#13 ; #3130 ................
db #13,#13,#13,#13,#13,#13,#13,#13,#F0,#2C,#2C,#F0,#13,#F0,#13,#13 ; #3140 .........,,.....
db #13,#13,#13,#13,#F0,#00,#F0,#13,#13,#13,#B9,#01,#01,#01,#01,#01 ; #3150 ................
db #01,#01,#01,#13,#13,#13,#13,#38,#38,#B5,#38,#38,#B5,#38,#38,#13 ; #3160 .......88.88.88.
db #13,#13,#01,#01,#13,#13,#F0,#F0,#F0,#ED,#F0,#F0,#13,#13,#F0,#01 ; #3170 ................
db #96,#01,#F0,#13,#13,#F0,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13 ; #3180 ................
db #13,#13,#13,#B9,#B9,#B9,#B9,#13,#13,#F0,#2C,#2C,#2C,#2C,#2C,#2C ; #3190 ..........,,,,,,
db #2C,#F0,#13,#13,#01,#01,#01,#13,#13,#38,#13,#38,#13,#13,#13,#13 ; #31a0 ,........8.8....
db #13,#13,#13,#13,#96,#13,#13,#96,#01,#01,#01,#01,#01,#01,#13,#13 ; #31b0 ................
db #13,#13,#13,#13,#13,#BA,#13,#F0,#2C,#2C,#F0,#BD,#F0,#13,#13,#13 ; #31c0 ........,,......
db #13,#BC,#13,#F0,#00,#00,#00,#F0,#13,#13,#13,#B9,#01,#01,#01,#01 ; #31d0 ................
db #01,#F1,#01,#13,#13,#13,#13,#38,#38,#96,#B9,#B9,#96,#38,#38,#13 ; #31e0 .......88....88.
db #13,#01,#01,#01,#01,#13,#13,#13,#F0,#2C,#F0,#13,#13,#F0,#97,#97 ; #31f0 .........,......
db #85,#97,#97,#F0,#13,#13,#13,#38,#38,#38,#38,#38,#13,#13,#F1,#13 ; #3200 .......88888....
db #13,#13,#13,#13,#13,#13,#13,#13,#13,#F0,#2C,#2C,#F0,#F0,#F0,#2C ; #3210 ..........,,...,
db #2C,#F0,#13,#01,#01,#92,#01,#01,#13,#38,#38,#38,#38,#13,#13,#13 ; #3220 ,........8888...
db #13,#13,#92,#13,#96,#13,#13,#96,#01,#BB,#01,#13,#01,#01,#13,#13 ; #3230 ................
db #13,#13,#13,#13,#13,#13,#13,#13,#F0,#2C,#2C,#F0,#13,#F0,#13,#13 ; #3240 .........,,.....
db #13,#13,#13,#13,#F0,#00,#F0,#13,#13,#13,#BC,#01,#01,#01,#13,#01 ; #3250 ................
db #01,#01,#01,#01,#13,#13,#13,#38,#F1,#B9,#97,#97,#B9,#F1,#38,#13 ; #3260 .......8......8.
db #13,#01,#B9,#B9,#01,#13,#13,#13,#F0,#F0,#F0,#13,#13,#13,#F0,#01 ; #3270 ................
db #96,#01,#F0,#13,#13,#13,#13,#38,#00,#21,#00,#38,#13,#13,#13,#13 ; #3280 .......8.!.8....
db #13,#13,#B9,#B9,#B9,#B9,#13,#13,#13,#F0,#F0,#F0,#F0,#13,#F0,#F0 ; #3290 ................
db #F0,#F0,#13,#01,#92,#BB,#92,#01,#13,#13,#38,#13,#38,#13,#13,#13 ; #32a0 ..........8.8...
db #13,#13,#13,#13,#86,#97,#97,#86,#01,#01,#01,#01,#01,#01,#13,#13 ; #32b0 ................
db #13,#13,#13,#13,#13,#38,#B5,#13,#13,#F0,#2C,#2C,#F0,#13,#13,#13 ; #32c0 .....8....,,....
db #13,#F0,#13,#13,#13,#F0,#13,#13,#13,#B9,#01,#01,#01,#F1,#01,#01 ; #32d0 ................
db #01,#01,#13,#01,#13,#13,#13,#13,#38,#B5,#B5,#B5,#B5,#38,#13,#13 ; #32e0 ........8....8..
db #01,#01,#B9,#BD,#01,#01,#38,#13,#13,#13,#13,#13,#13,#13,#13,#F0 ; #32f0 ......8.........
db #96,#F0,#13,#13,#13,#13,#13,#38,#00,#B8,#00,#38,#13,#13,#38,#38 ; #3300 .......8...8..88
db #B5,#13,#13,#B9,#BC,#B9,#B9,#13,#F1,#13,#13,#13,#13,#F1,#13,#13 ; #3310 ................
db #13,#13,#13,#01,#01,#92,#01,#01,#13,#13,#38,#38,#38,#38,#13,#92 ; #3320 ..........8888..
db #13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#01,#01,#13,#13,#13,#13 ; #3330 ................
db #13,#13,#13,#13,#38,#B5,#38,#B5,#13,#13,#F0,#2C,#2C,#F0,#13,#13 ; #3340 ....8.8....,,...
db #F0,#00,#F0,#13,#13,#13,#13,#13,#BB,#01,#01,#13,#01,#01,#01,#01 ; #3350 ................
db #01,#01,#01,#01,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13 ; #3360 ................
db #01,#BA,#B9,#B9,#B9,#01,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13 ; #3370 ................
db #F0,#13,#13,#13,#13,#13,#13,#38,#00,#21,#00,#38,#13,#13,#13,#13 ; #3380 .......8.!.8....
db #13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#F1,#13,#13,#13,#13 ; #3390 ................
db #13,#13,#13,#13,#01,#01,#01,#13,#13,#13,#13,#38,#13,#38,#13,#13 ; #33a0 ...........8.8..
db #13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13,#13 ; #33b0 ................


db #7A,#FF,#A6,#78,#FF,#C1,#77,#FF,#84,#5A,#00,#B2,#5A,#00,#41,#58 ; #33c0 z..x..w..Z..Z.AX
db #FF,#C4,#58,#C7,#93,#56,#E0,#56,#56,#00,#41,#54,#1F,#30,#4E,#FF ; #33d0 ..X..V.VV.AT.0N.
db #95,#4B,#1F,#30,#45,#FF,#71,#43,#FF,#04,#41,#F1,#C6,#40,#1F,#90 ; #33e0 .K.0E.qC..A..@..
db #3D,#1C,#91,#3A,#FF,#23,#3A,#FF,#E2,#38,#07,#61,#38,#1F,#C0,#37 ; #33f0 =..:.#:..8.a8..7
db #FF,#A5,#35,#1C,#40,#34,#78,#45,#33,#E0,#E7,#33,#38,#42,#31,#70 ; #3400 ..5.@4xE3..38B1p
db #05,#31,#0E,#00,#2F,#C1,#65,#2F,#0E,#A0,#2D,#F1,#67,#2C,#1C,#60 ; #3410 .1../.e/..-.g,.`
db #2A,#FF,#02,#28,#F1,#A6,#28,#7C,#04,#27,#FF,#81,#21,#01,#97,#21 ; #3420 *..(..(|.''..!..!
db #01,#96,#21,#01,#95,#21,#01,#94,#21,#01,#93,#21,#01,#92,#21,#01 ; #3430 ..!..!..!..!..!.
db #91,#21,#01,#90,#1E,#FF,#84,#1C,#C7,#E6,#17,#FF,#82,#15,#FF,#53 ; #3440 .!.............S
db #14,#1F,#50,#12,#F1,#F7,#12,#FF,#B3,#10,#00,#75,#0F,#55,#81,#0E ; #3450 ..P........u.U..
db #AA,#66,#0E,#FF,#43,#0D,#AA,#62,#0C,#22,#46,#0C,#88,#41,#0B,#00 ; #3460 .f..C..b."F..A..
db #E7,#0B,#00,#C0,#09,#FF,#C4,#08,#00,#C7,#08,#00,#E0,#FF,#FF,#FF ; #3470 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3480 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3490 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34b0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34c0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34d0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34e0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #34f0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3500 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3510 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3520 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3530 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3540 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3550 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3560 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3570 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3580 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3590 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #35a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #35b0 ................
db #47,#10,#C5,#45,#28,#84,#40,#70,#A7,#3B,#38,#03,#0F,#83,#64,#0C ; #35c0 G..E(.@p.;8...d.
db #E0,#07,#0C,#0E,#21,#09,#38,#E4,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #35d0 ....!.8.........
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #35e0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #35f0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3600 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3610 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3620 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3630 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3640 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3650 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3660 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3670 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3680 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3690 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #36a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #36b0 ................
db #7D,#55,#62,#7C,#55,#26,#76,#1F,#80,#74,#F1,#26,#5B,#FF,#25,#4C ; #36c0 }Ub|U&v..t.&[.%L
db #C7,#04,#4C,#7C,#63,#3A,#AA,#E6,#3A,#AA,#E2,#37,#D1,#A4,#35,#0E ; #36d0 ..L|c:..:..7..5.
db #42,#21,#0E,#C0,#1F,#78,#85,#16,#55,#86,#16,#AA,#85,#16,#AA,#82 ; #36e0 B!...x..U.......
db #16,#55,#81,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #36f0 .U..............
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3700 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3710 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3720 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3730 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3740 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3750 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3760 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3770 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3780 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3790 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #37a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #37b0 ................

db #7A,#E0,#E6,#75,#0E,#60,#71,#1F,#C0,#6D,#15,#40,#62,#F8,#C7,#5A ; #37c0 z..u.`q..m.@b..Z
db #FF,#E1,#58,#15,#C1,#56,#7C,#81,#45,#F1,#47,#39,#FF,#E3,#21,#AA ; #37d0 ..X..V|.E.G9..!.
db #04,#21,#2D,#00,#14,#FF,#63,#14,#55,#21,#11,#F8,#E5,#11,#FF,#03 ; #37e0 .!-...c.U!......
db #0E,#38,#A3,#0B,#FF,#E5,#0B,#FF,#23,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #37f0 .8......#.......
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3800 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3810 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3820 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3830 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3840 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3850 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3860 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3870 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3880 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3890 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #38a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #38b0 ................
db #72,#1F,#24,#6C,#38,#42,#6A,#70,#E6,#69,#38,#E1,#60,#07,#A6,#60 ; #38c0 r.$l8Bjp.i8.`..`
db #FF,#C4,#5E,#E3,#25,#5E,#1F,#81,#56,#FF,#82,#56,#FF,#A5,#46,#FF ; #38d0 ..^.%^..V..V..F.
db #63,#3B,#FF,#64,#3A,#E3,#E2,#1B,#38,#43,#18,#1F,#C1,#10,#55,#C3 ; #38e0 c;.d:...8C....U.
db #10,#00,#E0,#0F,#AA,#85,#0E,#40,#57,#0C,#04,#31,#0B,#07,#26,#FF ; #38f0 .......@W..1..&.
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3900 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3910 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3920 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3930 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3940 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3950 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3960 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3970 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3980 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3990 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #39a0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #39b0 ................
db #7A,#55,#05,#7A,#AA,#E3,#76,#FF,#A4,#73,#FF,#05,#70,#FF,#E1,#6F ; #39c0 zU.z..v..s..p..o
db #FF,#A6,#6C,#FF,#33,#69,#3F,#E2,#68,#55,#A6,#67,#FF,#60,#65,#AA ; #39d0 ..l.3i?.hU.g.`e.
db #55,#62,#FF,#02,#61,#00,#E1,#5F,#70,#A6,#5E,#E0,#67,#5E,#55,#66 ; #39e0 Ub..a.._p.^.g^Uf
db #50,#00,#E3,#4F,#F1,#A6,#4A,#FF,#22,#47,#7C,#E5,#47,#00,#C2,#44 ; #39f0 P..O..J."G|.G..D
db #FF,#62,#41,#00,#A6,#3F,#00,#E5,#3B,#00,#63,#36,#FF,#85,#32,#7C ; #3a00 .bA..?..;.c6..2|
db #44,#31,#38,#03,#30,#55,#A6,#2F,#00,#43,#2E,#FF,#84,#27,#FF,#C6 ; #3a10 D18.0U./.C...''..
db #27,#FF,#A4,#22,#FF,#05,#1F,#38,#C3,#1E,#78,#A5,#1D,#F8,#66,#1A ; #3a20 ''.."...8..x...f.
db #00,#24,#18,#F8,#A6,#18,#FF,#C4,#18,#1F,#80,#16,#C7,#54,#13,#FF ; #3a30 .$...........T..
db #25,#12,#00,#27,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a40 %..''............
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a50 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a60 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a70 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a80 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3a90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3aa0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3ab0 ................
db #7F,#FF,#A4,#79,#E1,#A5,#79,#1B,#E1,#78,#C1,#87,#78,#07,#60,#73 ; #3ac0 ...y..y..x..x.`s
db #70,#47,#73,#1C,#40,#6F,#55,#A2,#6C,#7C,#65,#6A,#00,#24,#63,#00 ; #3ad0 pGs.@oU.l|ej.$c.
db #E4,#63,#FF,#22,#5D,#1C,#24,#5D,#70,#23,#5C,#07,#24,#5C,#E0,#23 ; #3ae0 .c."].$]p#\.$\.#
db #55,#00,#83,#55,#AA,#61,#53,#AA,#03,#53,#AA,#21,#4D,#55,#65,#4C ; #3af0 U..U.aS..S.!MUeL
db #F1,#27,#4A,#50,#E5,#46,#FF,#42,#45,#50,#45,#43,#14,#21,#40,#F1 ; #3b00 .''JP.F.BEPEC.!@.
db #A7,#39,#FF,#E2,#36,#FF,#87,#34,#FF,#43,#2C,#07,#E1,#29,#F1,#E6 ; #3b10 .9..6..4.C,..)..
db #27,#70,#E7,#25,#1F,#47,#24,#C1,#05,#24,#07,#E1,#23,#FF,#03,#21 ; #3b20 ''p.%.G$..$..#..!
db #FF,#E4,#1D,#1F,#40,#18,#FF,#A3,#17,#00,#47,#16,#83,#34,#14,#F1 ; #3b30 ....@.....G..4..
db #47,#0F,#55,#82,#0E,#55,#84,#0B,#FF,#02,#09,#FF,#E3,#02,#FF,#25 ; #3b40 G.U..U.........%
db #02,#00,#41,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3b50 ..A.............
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3b60 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3b70 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3b80 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3b90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3ba0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3bb0 ................
db #70,#FF,#C4,#70,#FF,#E3,#5D,#00,#66,#5D,#00,#41,#4C,#AA,#45,#4B ; #3bc0 p..p..].f].AL.EK
db #55,#24,#46,#FF,#84,#46,#FF,#A3,#41,#38,#04,#3F,#38,#C3,#3D,#38 ; #3bd0 U$F..F..A8.?8.=8
db #A4,#3D,#38,#83,#3B,#FF,#44,#3B,#FF,#23,#37,#FF,#A4,#37,#38,#E3 ; #3be0 .=8.;.D;.#7..78.
db #2C,#FF,#64,#2B,#00,#41,#25,#FF,#64,#25,#FF,#63,#24,#FF,#45,#24 ; #3bf0 ,.d+.A%.d%.c$.E$
db #FF,#42,#21,#FF,#E5,#20,#E0,#C7,#20,#55,#A4,#20,#0E,#A1,#FF,#FF ; #3c00 .B!.. .. U. ....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c10 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c20 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c30 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c40 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c50 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c60 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c70 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c80 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3c90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3ca0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3cb0 ................
db #5A,#AA,#02,#59,#E0,#C6,#57,#1F,#A0,#56,#F1,#62,#54,#1F,#25,#52 ; #3cc0 Z..Y..W..V.bT.%R
db #C7,#03,#4E,#FF,#86,#4A,#FF,#A2,#46,#E3,#26,#46,#8F,#21,#41,#F8 ; #3cd0 ..N..J..F.&F.!A.
db #06,#41,#3E,#21,#3D,#AA,#45,#3D,#FF,#22,#36,#77,#62,#27,#FF,#61 ; #3ce0 .A>!=.E=."6wb''.a
db #26,#1F,#80,#21,#FF,#E3,#21,#FF,#A1,#1A,#38,#24,#16,#70,#87,#16 ; #3cf0 &..!..!...8$.p..
db #00,#A4,#16,#0E,#40,#13,#FF,#C4,#0C,#00,#87,#0A,#7C,#43,#0A,#00 ; #3d00 ....@.......|C..
db #A1,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d10 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d20 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d30 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d40 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d50 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d60 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d70 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d80 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3d90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3da0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3db0 ................
db #7D,#FF,#61,#7B,#FF,#05,#79,#FF,#21,#77,#FF,#A5,#77,#FF,#A2,#75 ; #3dc0 }.a{..y.!w..w..u
db #AA,#64,#73,#07,#C0,#72,#00,#C7,#71,#15,#C0,#70,#E0,#C7,#6F,#1F ; #3dd0 .ds..r..q..p..o.
db #A0,#6E,#51,#67,#68,#00,#E6,#68,#7C,#13,#66,#00,#26,#63,#FF,#05 ; #3de0 .nQgh..h|.f.&c..
db #60,#FF,#E5,#5D,#1F,#20,#58,#FF,#83,#56,#FF,#66,#52,#38,#53,#4E ; #3df0 `..]. X..V.fR8SN
db #1F,#81,#4D,#FF,#64,#4C,#00,#61,#4A,#F8,#C7,#49,#00,#E0,#48,#F1 ; #3e00 ..M.dL.aJ..I..H.
db #87,#47,#FF,#C2,#46,#55,#95,#42,#F1,#07,#42,#18,#30,#41,#70,#25 ; #3e10 .G..FU.B..B.0Ap%
db #41,#3C,#01,#40,#8C,#E4,#40,#3C,#E2,#3C,#F1,#47,#3A,#FF,#26,#35 ; #3e20 A<.@..@<.<.G:.&5
db #FF,#45,#34,#FF,#62,#2D,#FF,#82,#2D,#00,#40,#2A,#FF,#24,#28,#00 ; #3e30 .E4.b-..-.@*.$(.
db #E7,#28,#55,#D3,#27,#AA,#84,#26,#A0,#87,#26,#55,#63,#25,#AA,#54 ; #3e40 .(U.''..&..&Uc%.T
db #25,#1F,#40,#24,#F1,#17,#24,#55,#23,#23,#AA,#E4,#22,#FF,#C3,#21 ; #3e50 %.@$..$U##.."..!
db #1F,#A0,#1D,#F1,#47,#1A,#FF,#02,#16,#FF,#D2,#15,#FF,#82,#14,#FF ; #3e60 ....G...........
db #42,#11,#00,#03,#0E,#00,#87,#0E,#83,#45,#0C,#FF,#45,#0C,#0E,#41 ; #3e70 B........E..E..A
db #0A,#70,#07,#0A,#38,#25,#0A,#3E,#03,#08,#38,#C5,#FF,#FF,#FF,#FF ; #3e80 .p..8%.>..8.....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3e90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3ea0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3eb0 ................
db #79,#FF,#E4,#73,#1F,#00,#66,#F8,#A5,#64,#00,#65,#62,#FF,#E0,#5D ; #3ec0 y..s..f..d.eb..]
db #FF,#46,#5B,#FF,#07,#58,#00,#A0,#54,#FF,#23,#54,#1F,#40,#53,#FF ; #3ed0 .F[..X..T.#T.@S.
db #25,#53,#00,#42,#4E,#FF,#94,#4B,#00,#42,#49,#FF,#26,#45,#1F,#90 ; #3ee0 %S.BN..K.BI.&E..
db #43,#83,#C4,#40,#E0,#A7,#40,#0E,#81,#3D,#38,#64,#3A,#83,#A2,#39 ; #3ef0 C..@..@..=8d:..9
db #00,#03,#39,#FF,#C1,#38,#78,#F2,#33,#FF,#46,#32,#00,#27,#2D,#FF ; #3f00 ..9..8x.3.F2.''-.
db #65,#2D,#83,#11,#2B,#00,#E4,#28,#78,#A5,#28,#1E,#C1,#21,#C7,#84 ; #3f10 e-..+..(x.(..!..
db #1F,#1F,#80,#1D,#F1,#46,#1C,#1F,#21,#15,#00,#06,#15,#00,#82,#0B ; #3f20 .....F..!.......
db #FF,#54,#07,#55,#B1,#05,#FF,#74,#05,#AA,#61,#FF,#FF,#FF,#FF,#FF ; #3f30 .T.U...t..a.....


db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f40 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f50 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f60 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f70 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f80 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3f90 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3fa0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #3fb0 ................

; ------------------- TILES -------------
org #4000
TILE_EMPTY: ;(#00)
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3fc0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3fd0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3fe0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3ff0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #4000 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #4010 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #4020 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #4030 ................

TILE_TERRAIN1 ;(#01)
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4040 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4050 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4060 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4070 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4080 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4090 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #40a0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #40b0 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#E0,#F0,#F0,#F0,#F0,#F0 ; #40c0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #40d0 ................
db #F1,#F8,#F0,#F0,#F1,#B8,#F0,#F0,#F0,#30,#F0,#F0,#F0,#F0,#F0,#F0 ; #40e0 .........0......
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #40f0 ................
db #F0,#F0,#F0,#F8,#F0,#F0,#F0,#B0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0 ; #4100 ................
db #F0,#E0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4110 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0 ; #4120 ................
db #E2,#F0,#F0,#FC,#E0,#F0,#F0,#90,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4130 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4140 ................
db #F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#70,#F0,#F0,#F0,#70,#F0 ; #4150 ..........p...p.
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4160 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4170 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F4,#F0,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F0 ; #4180 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0 ; #4190 ................
db #F0,#70,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #41a0 .p..............
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #41b0 ................

db #F0,#F0,#F0,#F0,#F0,#E1,#78,#F0,#F0,#87,#1C,#F0,#F0,#3F,#CC,#F0 ; #41c0 ......x......?..
db #E1,#7F,#EE,#70,#C3,#FF,#FF,#30,#D3,#FF,#FF,#B8,#97,#FF,#FF,#98 ; #41d0 ...p...0........
db #B7,#EE,#77,#DC,#B7,#CC,#33,#DC,#3F,#88,#11,#CC,#7F,#88,#71,#EE ; #41e0 ..w...3.?.....q.
db #7F,#10,#F0,#EE,#7F,#10,#E1,#EE,#7F,#30,#E1,#EE,#7F,#30,#E1,#EE ; #41f0 .........0...0..
db #7F,#30,#E1,#EE,#7F,#70,#C3,#EE,#7F,#70,#C3,#EE,#7F,#70,#87,#EE ; #4200 .0...p...p...p..
db #7F,#F8,#97,#CC,#3F,#F8,#1F,#DC,#B7,#CF,#3F,#DC,#B7,#EF,#7F,#DC ; #4210 ....?.....?.....
db #97,#FF,#FF,#98,#D3,#FF,#FF,#B8,#C0,#FF,#FF,#30,#E0,#77,#EE,#70 ; #4220 ...........0.w.p
db #F0,#33,#CC,#F0,#F0,#80,#10,#F0,#F0,#E0,#70,#F0,#F0,#F0,#F0,#F0 ; #4230 .3........p.....

db #F0,#C3,#3C,#F0,#F0,#87,#1E,#F0,#F0,#0F,#0F,#F0,#E1,#0F,#4F,#78 ; #4240 ..<...........Ox
db #E1,#0F,#BF,#F8,#C3,#0F,#7F,#FC,#C3,#1F,#FF,#FC,#C3,#0F,#FF,#FC ; #4250 ................
db #87,#7F,#FF,#DC,#87,#1F,#FF,#DC,#87,#FF,#FF,#DC,#87,#3F,#FF,#BA ; #4260 .............?..
db #1F,#FF,#FF,#CC,#0F,#7F,#FF,#88,#3F,#FF,#FF,#CC,#0F,#FF,#FF,#00 ; #4270 ........?.......
db #3F,#FF,#FF,#CC,#1F,#FF,#EE,#00,#7F,#FF,#FF,#88,#1F,#FF,#CC,#00 ; #4280 ?...............
db #F7,#FF,#FF,#10,#B7,#FF,#88,#10,#B7,#FF,#EE,#10,#B7,#FF,#00,#10 ; #4290 ................
db #F3,#FF,#CC,#30,#F3,#EE,#00,#30,#F3,#DD,#00,#30,#F1,#AA,#00,#70 ; #42a0 ...0...0...0...p
db #E0,#44,#00,#70,#F0,#00,#00,#F0,#F0,#80,#10,#F0,#F0,#C0,#30,#F0 ; #42b0 .D.p..........0.

TILE_SILO: ; (#06)
db #8F,#0F,#0F,#1F,#0F,#0F,#0F,#0E,#4F,#0F,#0F,#2E,#0F,#0F,#0F,#0C ; #42c0 ........O.......
db #2F,#0F,#0F,#4C,#0F,#0F,#0F,#08,#1F,#0F,#0F,#88,#0F,#0F,#0F,#00 ; #42d0 /..L............
db #0F,#00,#00,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00 ; #42e0 .....w...w...w..
db #0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00 ; #42f0 .w...w...w...w..
db #0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00 ; #4300 .w...w...w...w..
db #0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#77,#EE,#00,#0F,#00,#00,#00 ; #4310 .w...w...w......
db #1F,#00,#00,#00,#0E,#00,#00,#88,#2E,#00,#00,#00,#0C,#00,#00,#44 ; #4320 ...............D
db #4C,#00,#00,#00,#08,#00,#00,#22,#88,#00,#00,#00,#00,#00,#00,#11 ; #4330 L......"........

; (#07)
db #F0,#E1,#78,#F0,#F0,#C3,#38,#F0,#F0,#97,#98,#F0,#F0,#3F,#CC,#F0 ; #4340 ..x...8......?..
db #E1,#7F,#EE,#70,#C3,#FF,#FF,#30,#97,#FF,#FF,#98,#3F,#FF,#FF,#CC ; #4350 ...p...0....?...
db #7F,#FF,#FF,#EE,#7F,#EF,#77,#EE,#7F,#DF,#BB,#EE,#7F,#BF,#DD,#EE ; #4360 ......w.........
db #7F,#7F,#EE,#EE,#7F,#7F,#EE,#66,#7F,#7F,#EE,#66,#7F,#7F,#EE,#66 ; #4370 .......f...f...f
db #7F,#7F,#EE,#66,#7F,#7F,#EE,#66,#7F,#7F,#EE,#66,#7F,#7F,#EE,#66 ; #4380 ...f...f...f...f
db #7F,#BB,#CC,#66,#7F,#DD,#88,#EE,#7F,#EE,#11,#EE,#7F,#FF,#33,#EE ; #4390 ...f..........3.
db #3B,#FF,#FF,#CC,#91,#FF,#FF,#98,#C0,#FF,#FF,#30,#E0,#77,#EE,#70 ; #43a0 ;..........0.w.p
db #F0,#33,#CC,#F0,#F0,#91,#98,#F0,#F0,#C0,#30,#F0,#F0,#E0,#70,#F0 ; #43b0 .3........0...p.

; (#08)
db #37,#C8,#13,#68,#37,#C8,#13,#E0,#27,#C0,#13,#EC,#36,#E0,#13,#EC ; #43c0 7..h7...''...6...
db #37,#FC,#13,#EC,#37,#FE,#93,#EC,#37,#FF,#D3,#EC,#37,#DE,#F9,#EC ; #43d0 7...7...7...7...
db #37,#FC,#FD,#68,#37,#FB,#FF,#E0,#27,#F1,#BD,#EC,#36,#F0,#F9,#EC ; #43e0 7..h7...''...6...
db #37,#D8,#F7,#EC,#37,#C8,#F3,#EC,#37,#C8,#71,#EC,#37,#C8,#31,#EC ; #43f0 7...7...7.q.7.1.
db #37,#C8,#13,#68,#37,#C8,#13,#E0,#27,#C0,#13,#EC,#36,#C0,#17,#EC ; #4400 7..h7...''...6...
db #37,#C8,#3F,#EC,#37,#C9,#7F,#EC,#37,#E9,#BD,#EC,#37,#F9,#F9,#EC ; #4410 7.?.7...7...7...
db #37,#FB,#FF,#68,#37,#DE,#FD,#E0,#27,#F4,#F9,#EC,#36,#F7,#F1,#EC ; #4420 7..h7...''...6...
db #37,#FE,#B1,#EC,#37,#FC,#13,#EC,#37,#E8,#13,#EC,#37,#C8,#13,#EC ; #4430 7...7...7...7...

; (#09)
db #00,#00,#00,#00,#00,#00,#00,#00,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F ; #4440 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#DE,#DE,#DE,#DE,#FC,#FC,#FC,#FC ; #4450 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#F1,#FE,#FF,#F0,#F1,#FC,#FF,#F0 ; #4460 ................
db #73,#EC,#F7,#80,#27,#E4,#D6,#80,#36,#C0,#F4,#C8,#37,#C8,#F7,#C8 ; #4470 s...''...6...7...
db #7F,#C8,#73,#C8,#5E,#C8,#63,#C0,#7C,#80,#72,#E4,#7F,#80,#73,#EC ; #4480 ..s.^.c.|.r...s.
db #FF,#E1,#3D,#FC,#FF,#87,#3D,#FE,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #4490 ..=...=.........
db #7B,#7B,#7B,#7B,#F3,#F3,#F3,#F3,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #44a0 {{{{............
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#00,#00,#00,#00,#00,#00,#00,#00 ; #44b0 ................

; (#0A)
db #F0,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#7C,#F0,#F0,#F0 ; #44c0 ....x...x...|...
db #34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0 ; #44d0 4...4...4...4...
db #36,#F0,#F0,#F0,#32,#F0,#F0,#F0,#12,#F0,#F0,#F0,#13,#F8,#F0,#F0 ; #44e0 6...2...........
db #01,#F8,#F0,#F0,#00,#7C,#F0,#F0,#00,#34,#F0,#F0,#00,#34,#F0,#F0 ; #44f0 .....|...4...4..
db #00,#37,#F0,#F0,#00,#01,#F8,#F0,#00,#00,#78,#F0,#00,#00,#7C,#F0 ; #4500 .7........x...|.
db #00,#00,#34,#F0,#00,#00,#34,#F0,#00,#00,#36,#F0,#00,#00,#13,#F0 ; #4510 ..4...4...6.....
db #00,#00,#01,#F0,#00,#00,#01,#F0,#00,#00,#01,#F0,#00,#00,#01,#F0 ; #4520 ................
db #00,#00,#01,#F0,#00,#00,#01,#F8,#00,#00,#00,#7C,#00,#00,#00,#37 ; #4530 ...........|...7

; (#0B)
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F3 ; #4540 ................
db #F0,#F0,#F0,#E2,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#C4,#F0,#F0,#F0,#88 ; #4550 ................
db #F0,#F0,#F1,#00,#F0,#F0,#F1,#00,#F0,#F0,#F1,#00,#F0,#F0,#F3,#00 ; #4560 ................
db #F0,#F0,#E2,#00,#F0,#F0,#E2,#00,#F0,#F0,#E6,#00,#F0,#F0,#C4,#00 ; #4570 ................
db #F0,#F0,#CC,#00,#F0,#F1,#CC,#00,#F0,#F1,#00,#00,#F0,#F3,#00,#00 ; #4580 ................
db #F0,#E2,#00,#00,#F0,#E2,#00,#00,#F0,#E6,#00,#00,#F0,#CC,#00,#00 ; #4590 ................
db #F0,#88,#00,#00,#F0,#88,#00,#00,#F0,#88,#00,#00,#F3,#00,#00,#00 ; #45a0 ................
db #E2,#00,#00,#00,#E2,#00,#00,#00,#C4,#00,#00,#00,#88,#00,#00,#00 ; #45b0 ................

; (#0c)
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #45c0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #45d0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #45e0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #45f0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4600 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4610 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4620 ................
db #F0,#F0,#F0,#F0,#F0,#F5,#F8,#F0,#F0,#BB,#FF,#F2,#FF,#00,#11,#DD ; #4630 ................

; (#0D)
db #2E,#03,#88,#4F,#C3,#AD,#0F,#1E,#E1,#3C,#D2,#F0,#F0,#F0,#F0,#F0 ; #4640 ...O.....<......
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4650 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4660 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4670 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4680 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4690 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #46a0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #46b0 ................

; HUD? 
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #46c0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #46d0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #46e0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#32,#31,#31,#31,#31,#30,#33 ; #46f0 3333333332111103
db #64,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33 ; #4700 d.3333..3333..33
db #33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10 ; #4710 33..3333..3333..
db #33,#33,#33,#33,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #4720 3333.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#33,#33,#33,#33,#02,#4C ; #4730 ..3&...3L.3333.L

db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #4740 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #4750 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #4760 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#30,#30,#30,#31,#02,#4C ; #4770 ..3&...3L.0001.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #4780 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #4790 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #47a0 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #47b0 ..3&...3L....1.L

; TILE #10
db #00,#00,#00,#01,#00,#00,#00,#03,#00,#00,#00,#12,#00,#00,#00,#12 ; #47c0 ................
db #00,#00,#00,#12,#00,#00,#00,#16,#00,#00,#00,#34,#00,#00,#00,#34 ; #47d0 ...........4...4
db #00,#00,#00,#34,#00,#00,#01,#3C,#00,#00,#03,#F0,#00,#00,#12,#F0 ; #47e0 ...4...<........
db #00,#00,#12,#F0,#00,#00,#16,#F0,#00,#03,#3C,#F0,#00,#12,#F0,#F0 ; #47f0 ..........<.....
db #00,#12,#F0,#F0,#00,#12,#F0,#F0,#00,#16,#F0,#F0,#00,#34,#F0,#F0 ; #4800 .............4..
db #00,#34,#F0,#F0,#00,#34,#F0,#F0,#00,#34,#F0,#F0,#00,#3C,#F0,#F0 ; #4810 .4...4...4...<..
db #00,#78,#F0,#F0,#01,#78,#F0,#F0,#01,#F0,#F0,#F0,#01,#F0,#F0,#F0 ; #4820 .x...x..........
db #07,#F0,#F0,#F0,#34,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0 ; #4830 ....4...x...x...

db #88,#00,#00,#00,#CC,#00,#00,#00,#C4,#00,#00,#00,#C4,#00,#00,#00 ; #4840 ................
db #C4,#00,#00,#00,#C4,#00,#00,#00,#E6,#00,#00,#00,#E2,#00,#00,#00 ; #4850 ................
db #E2,#00,#00,#00,#F3,#88,#00,#00,#F0,#CC,#00,#00,#F0,#C4,#00,#00 ; #4860 ................
db #F0,#C4,#00,#00,#F0,#E6,#00,#00,#F0,#E2,#00,#00,#F0,#E2,#00,#00 ; #4870 ................
db #F0,#F3,#88,#00,#F0,#F0,#CC,#00,#F0,#F0,#C4,#00,#F0,#F0,#E6,#00 ; #4880 ................
db #F0,#F0,#E2,#00,#F0,#F0,#E2,#00,#F0,#F0,#E2,#00,#F0,#F0,#F3,#00 ; #4890 ................
db #F0,#F0,#F1,#00,#F0,#F0,#F1,#00,#F0,#F0,#F0,#88,#F0,#F0,#F0,#88 ; #48a0 ................
db #F0,#F0,#F0,#EE,#F0,#F0,#F0,#F3,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1 ; #48b0 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #48c0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #48d0 ................
db #F0,#F0,#F0,#F0,#E1,#0F,#0F,#F8,#E1,#FF,#FF,#70,#E1,#FF,#FF,#70 ; #48e0 ...........p...p
db #E1,#FF,#FF,#70,#E1,#EF,#7F,#70,#E1,#CF,#7B,#70,#E1,#CF,#FB,#70 ; #48f0 ...p...p..{p...p
db #E1,#DF,#FB,#70,#E1,#DF,#F3,#70,#E1,#FE,#B3,#70,#E1,#FF,#99,#70 ; #4900 ...p...p...p...p
db #E1,#FF,#CC,#70,#E1,#FF,#CC,#30,#F1,#00,#00,#10,#F0,#F0,#E0,#10 ; #4910 ...p...0........
db #F0,#F0,#E0,#10,#F0,#F0,#E0,#10,#F0,#F0,#F0,#30,#F0,#F0,#F0,#F0 ; #4920 ...........0....
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4930 ................

db #00,#00,#00,#00,#00,#00,#00,#01,#00,#00,#00,#03,#33,#FF,#FF,#CF ; #4940 ............3...
db #33,#FF,#FF,#CF,#23,#1F,#8F,#4F,#23,#D1,#BC,#47,#23,#D1,#BC,#47 ; #4950 3...#..O#..G#..G
db #23,#D1,#BC,#47,#23,#D1,#BC,#47,#23,#D1,#BC,#47,#23,#D1,#BC,#47 ; #4960 #..G#..G#..G#..G
db #23,#D1,#BC,#47,#23,#11,#8C,#47,#33,#FF,#FF,#CF,#33,#FF,#FF,#CF ; #4970 #..G#..G3...3...
db #33,#FF,#FF,#CF,#33,#FF,#FF,#CF,#23,#1F,#8F,#4F,#23,#D1,#BC,#47 ; #4980 3...3...#..O#..G
db #23,#D1,#BC,#47,#23,#D1,#BC,#47,#23,#D1,#BC,#47,#23,#D1,#BC,#47 ; #4990 #..G#..G#..G#..G
db #23,#D1,#BC,#47,#23,#D1,#BC,#47,#23,#11,#8C,#47,#33,#FF,#FF,#CF ; #49a0 #..G#..G#..G3...
db #33,#FF,#FF,#CF,#03,#0F,#0F,#0F,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F ; #49b0 3...............

db #78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0 ; #49c0 x...x...x...x...
db #34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0 ; #49d0 4...4...4...4...
db #34,#F0,#F0,#F0,#16,#F0,#F0,#F0,#12,#F0,#F0,#F0,#12,#F0,#F0,#F0 ; #49e0 4...............
db #34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#78,#F0,#F0,#F0 ; #49f0 4...4...4...x...
db #78,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0 ; #4a00 x...4...4...4...
db #78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#78,#F0,#F0,#F0 ; #4a10 x...x...x...x...
db #78,#F0,#F0,#F0,#78,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0 ; #4a20 x...x...4...4...
db #34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#34,#F0,#F0,#F0,#78,#F0,#F0,#F0 ; #4a30 4...4...4...x...

db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#E2 ; #4a40 ................
db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1 ; #4a50 ................
db #F0,#F0,#F0,#E2,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1 ; #4a60 ................
db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1 ; #4a70 ................
db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#E2 ; #4a80 ................
db #F0,#F0,#F0,#C4,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#E2,#F0,#F0,#F0,#F3 ; #4a90 ................
db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1 ; #4aa0 ................
db #F0,#F0,#F0,#F1,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F3,#F0,#F0,#F0,#E2 ; #4ab0 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4ac0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4ad0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4ae0 ................
db #0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #4af0 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #4b00 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4b10 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4b20 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4b30 ................

db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b40 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b50 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b60 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b70 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b80 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4b90 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4ba0 ................
db #F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0,#F0,#D3,#B8,#F0 ; #4bb0 ................

db #F0,#F0,#F8,#F0,#F0,#F0,#F8,#F0,#F0,#F1,#F8,#F0,#F0,#F1,#FC,#F0 ; #4bc0 ................
db #F0,#F1,#FC,#F0,#F0,#F1,#FC,#F0,#F0,#F3,#FC,#F0,#F0,#F3,#FC,#F0 ; #4bd0 ................
db #F0,#F3,#FC,#F0,#F0,#F3,#FC,#F3,#F0,#F3,#F8,#FE,#F0,#F3,#F9,#FE ; #4be0 ................
db #F0,#F1,#F3,#FE,#F3,#E9,#F7,#FC,#FF,#CF,#7F,#F8,#F7,#CF,#7C,#F0 ; #4bf0 ..............|.
db #F1,#CB,#78,#F0,#F0,#E3,#F8,#F0,#F0,#F6,#FC,#F0,#F0,#F6,#FE,#F0 ; #4c00 ..x.............
db #F0,#FE,#FE,#F0,#F0,#FE,#FF,#F0,#F0,#FE,#F7,#F0,#F0,#FE,#F7,#F0 ; #4c10 ................
db #F0,#FE,#F7,#F8,#F1,#FE,#F3,#F8,#F1,#FC,#F3,#F8,#F1,#FC,#F1,#FC ; #4c20 ................
db #F1,#FC,#F0,#FC,#F1,#F8,#F0,#F0,#F1,#F8,#F0,#F0,#F1,#F0,#F0,#F0 ; #4c30 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F3,#F0,#F0,#F0,#F1,#F8,#F0,#F0 ; #4c40 ................
db #F1,#FC,#F0,#F0,#F1,#FC,#F0,#F0,#F1,#FE,#F0,#F0,#F0,#FE,#F0,#F0 ; #4c50 ................
db #F0,#FF,#F0,#F0,#F0,#FF,#F0,#F0,#F0,#F7,#F0,#F0,#F0,#F7,#F8,#F0 ; #4c60 ................
db #F0,#F7,#F8,#F0,#F0,#F3,#F8,#F0,#F0,#F1,#F3,#FC,#F0,#E1,#7F,#FE ; #4c70 ................
db #F0,#E1,#7F,#F8,#F0,#F2,#F8,#F0,#F0,#FC,#FC,#F0,#F3,#FC,#FE,#F0 ; #4c80 ................
db #F3,#FC,#F6,#F0,#F7,#F8,#F6,#F0,#F7,#F8,#F7,#F0,#FE,#F0,#F7,#F0 ; #4c90 ................
db #FC,#F0,#F7,#F0,#F0,#F0,#F7,#F0,#F0,#F0,#F7,#F0,#F0,#F0,#F2,#F0 ; #4ca0 ................
db #F0,#F0,#F2,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4cb0 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4cc0 ................
db #F2,#F0,#F4,#F0,#F6,#F4,#F0,#F2,#E6,#FC,#EE,#F4,#D0,#D4,#D4,#E6 ; #4cd0 ................
db #F0,#B0,#90,#A0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4ce0 ................
db #FE,#FC,#F4,#F4,#FD,#F4,#FE,#FC,#98,#E6,#D4,#F6,#F0,#90,#B0,#D0 ; #4cf0 ................
db #F0,#F0,#B0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#FC,#FC,#F4,#FC ; #4d00 ................
db #FC,#F4,#F8,#DC,#D4,#B8,#D4,#90,#90,#90,#B0,#F0,#F0,#F0,#F0,#F0 ; #4d10 ................
db #F0,#F0,#F0,#F0,#F0,#F4,#F0,#F0,#F0,#F6,#F6,#F4,#F6,#D4,#E6,#E6 ; #4d20 ................
db #E2,#B0,#D0,#D0,#D0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #4d30 ................

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#B7,#F0,#F0,#F3,#FB,#F8,#F0 ; #4d40 ................
db #F5,#5F,#F8,#F0,#D7,#FF,#F0,#F0,#F3,#FF,#F8,#F0,#DE,#FF,#F8,#F0 ; #4d50 ._..............
db #B7,#FE,#FC,#F0,#F7,#FF,#FC,#F0,#FB,#FF,#FC,#F0,#B7,#FF,#FC,#F0 ; #4d60 ................
db #FF,#FE,#F8,#F0,#F3,#FF,#F8,#F0,#F7,#FD,#F0,#F0,#F3,#FB,#F0,#F0 ; #4d70 ................
db #F1,#EE,#70,#F0,#F0,#F4,#30,#F0,#F0,#F0,#90,#70,#F0,#F0,#80,#30 ; #4d80 ..p...0....p...0
db #F0,#F0,#D0,#90,#F0,#F0,#E0,#10,#F0,#F0,#90,#30,#F0,#F0,#E0,#B0 ; #4d90 ...........0....
db #F0,#F0,#90,#D0,#F0,#F0,#C0,#90,#F0,#F0,#A0,#50,#F0,#F0,#D0,#C0 ; #4da0 ...........P....
db #F0,#F0,#B0,#70,#F0,#F0,#D0,#D0,#F0,#F0,#F0,#70,#F0,#F0,#F0,#F0 ; #4db0 ...p.......p....

db #00,#00,#00,#01,#00,#00,#00,#01,#00,#00,#00,#13,#00,#00,#00,#13 ; #4dc0 ................
db #00,#00,#00,#35,#00,#00,#00,#35,#00,#00,#00,#79,#00,#00,#00,#79 ; #4dd0 ...5...5...y...y
db #00,#00,#01,#F1,#00,#00,#01,#F1,#00,#00,#12,#F1,#00,#00,#12,#F1 ; #4de0 ................
db #00,#00,#34,#F1,#00,#00,#34,#F1,#00,#00,#78,#F1,#00,#00,#78,#F1 ; #4df0 ..4...4...x...x.
db #00,#01,#F0,#F1,#00,#01,#F0,#F1,#00,#12,#F0,#F1,#00,#12,#F0,#F1 ; #4e00 ................
db #00,#34,#F0,#F1,#00,#34,#F0,#F1,#00,#78,#F0,#F1,#00,#78,#F0,#F1 ; #4e10 .4...4...x...x..
db #01,#F0,#F0,#F1,#01,#F0,#F0,#F1,#12,#F0,#F0,#F1,#12,#F0,#F0,#F1 ; #4e20 ................
db #34,#F0,#F0,#F1,#34,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #4e30 4...4...x.......

db #08,#00,#00,#00,#08,#00,#00,#00,#0C,#00,#00,#00,#4C,#00,#00,#00 ; #4e40 ............L...
db #4A,#00,#00,#00,#6A,#00,#00,#00,#69,#00,#00,#00,#79,#00,#00,#00 ; #4e50 J...j...i...y...
db #78,#08,#00,#00,#78,#88,#00,#00,#78,#84,#00,#00,#78,#C4,#00,#00 ; #4e60 x...x...x...x...
db #78,#C2,#00,#00,#78,#E2,#00,#00,#78,#E1,#00,#00,#78,#F1,#00,#00 ; #4e70 x...x...x...x...
db #78,#F0,#08,#00,#78,#F0,#88,#00,#78,#F0,#84,#00,#78,#F0,#C4,#00 ; #4e80 x...x...x...x...
db #78,#F0,#C2,#00,#78,#F0,#E2,#00,#78,#F0,#E1,#00,#78,#F0,#F1,#00 ; #4e90 x...x...x...x...
db #78,#F0,#F0,#08,#78,#F0,#F0,#88,#78,#F0,#F0,#84,#78,#F0,#F0,#C4 ; #4ea0 x...x...x...x...
db #78,#F0,#F0,#C2,#78,#F0,#F0,#E2,#78,#F0,#F0,#E1,#7F,#FF,#FF,#FF ; #4eb0 x...x...x.......

; HUD
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #4ec0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #4ed0 3333333333333333
db #33,#33,#33,#33,#33,#33,#32,#33,#32,#33,#33,#31,#33,#33,#33,#32 ; #4ee0 3333332323313332
db #31,#33,#33,#33,#32,#30,#33,#33,#33,#31,#33,#31,#31,#31,#31,#31 ; #4ef0 1333203331311111
db #64,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33 ; #4f00 d.3333..3333..33
db #33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10 ; #4f10 33..3333..3333..
db #33,#33,#33,#33,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #4f20 3333.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#33,#33,#33,#33,#02,#4C ; #4f30 ..3&...3L.3333.L

db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #4f40 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #4f50 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #4f60 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#31,#33,#33,#33,#02,#4C ; #4f70 ..3&...3L.1333.L
db #64,#10,#23,#30,#30,#31,#02,#10,#23,#30,#30,#31,#02,#10,#23,#30 ; #4f80 d.#001..#001..#0
db #30,#31,#02,#10,#23,#30,#30,#31,#02,#10,#23,#30,#30,#31,#02,#10 ; #4f90 01..#001..#001..
db #23,#30,#30,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #4fa0 #001.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#30,#30,#30,#31,#02,#4C ; #4fb0 ..3&...3L.0001.L

db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#C0,#70,#F0,#D0,#C0,#10,#70 ; #4fc0 ..........p....p
db #F0,#00,#00,#F0,#F0,#00,#00,#D0,#F0,#00,#00,#70,#B0,#00,#00,#70 ; #4fd0 ...........p...p
db #C0,#00,#11,#70,#C0,#00,#22,#B8,#C0,#00,#55,#74,#C0,#00,#AA,#B8 ; #4fe0 ...p.."...Ut....
db #C0,#11,#55,#66,#80,#00,#AA,#B8,#80,#11,#55,#76,#80,#22,#AA,#FE ; #4ff0 ..Uf......Uv."..
db #80,#55,#55,#76,#80,#22,#AA,#FC,#80,#55,#55,#74,#C0,#AA,#AA,#FE ; #5000 .UUv."...UUt....
db #80,#55,#55,#FE,#80,#AA,#BB,#FE,#D1,#55,#77,#FC,#C0,#AA,#FF,#FC ; #5010 .UU......Uw.....
db #D1,#55,#77,#FC,#E0,#BB,#FE,#F0,#B1,#77,#FF,#F0,#F0,#F7,#FF,#F0 ; #5020 .Uw......w......
db #F0,#F3,#FE,#D0,#D0,#F3,#E8,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #5030 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5040 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5050 ................
db #0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#5A,#5A,#5A,#5A ; #5060 ............ZZZZ
db #A5,#A5,#A5,#A5,#5A,#5A,#5A,#5A,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #5070 ....ZZZZ........
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F5,#F5,#F5,#F5,#FA,#FA,#FA,#FA ; #5080 ................
db #F5,#F5,#F5,#F5,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #5090 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #50a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #50b0 ................

db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#34,#F0,#F0,#F1,#34,#F0,#F0,#F1 ; #50c0 ....x...4...4...
db #12,#F0,#F0,#F1,#12,#F0,#F0,#F1,#01,#F0,#F0,#F1,#01,#F0,#F0,#F1 ; #50d0 ................
db #00,#78,#F0,#F1,#00,#78,#F0,#F1,#00,#34,#F0,#F1,#00,#34,#F0,#F1 ; #50e0 .x...x...4...4..
db #00,#12,#F0,#F1,#00,#12,#F0,#F1,#00,#01,#F0,#F1,#00,#01,#F0,#F1 ; #50f0 ................
db #00,#00,#78,#F1,#00,#00,#78,#F1,#00,#00,#34,#F1,#00,#00,#34,#F1 ; #5100 ..x...x...4...4.
db #00,#00,#12,#F1,#00,#00,#12,#F1,#00,#00,#01,#F1,#00,#00,#01,#F1 ; #5110 ................
db #00,#00,#00,#79,#00,#00,#00,#79,#00,#00,#00,#35,#00,#00,#00,#35 ; #5120 ...y...y...5...5
db #00,#00,#00,#13,#00,#00,#00,#13,#00,#00,#00,#01,#00,#00,#00,#01 ; #5130 ................

db #0F,#0F,#0F,#1F,#78,#F0,#F0,#F1,#78,#F0,#F0,#E2,#78,#F0,#F0,#E2 ; #5140 ....x...x...x...
db #78,#F0,#F0,#C4,#78,#F0,#F0,#C4,#78,#F0,#F0,#88,#78,#F0,#F0,#88 ; #5150 x...x...x...x...
db #78,#F0,#F1,#00,#78,#F0,#F1,#00,#78,#F0,#E2,#00,#78,#F0,#E2,#00 ; #5160 x...x...x...x...
db #78,#F0,#C4,#00,#78,#F0,#C4,#00,#78,#F0,#88,#00,#78,#F0,#88,#00 ; #5170 x...x...x...x...
db #78,#F1,#00,#00,#78,#F1,#00,#00,#78,#E2,#00,#00,#78,#E2,#00,#00 ; #5180 x...x...x...x...
db #78,#C4,#00,#00,#78,#C4,#00,#00,#78,#88,#00,#00,#78,#88,#00,#00 ; #5190 x...x...x...x...
db #79,#00,#00,#00,#79,#00,#00,#00,#6A,#00,#00,#00,#6A,#00,#00,#00 ; #51a0 y...y...j...j...
db #4C,#00,#00,#00,#4C,#00,#00,#00,#88,#00,#00,#00,#88,#00,#00,#00 ; #51b0 L...L...........

db #07,#0F,#0F,#0E,#37,#FF,#FF,#EC,#7F,#FF,#FF,#FE,#7E,#F7,#FE,#F6 ; #51c0 ....7.......~...
db #6C,#73,#EC,#72,#6C,#37,#EC,#36,#48,#7F,#FE,#12,#48,#7F,#FE,#12 ; #51d0 ls.rl7.6H...H...
db #49,#FF,#FF,#92,#49,#FF,#FF,#92,#5F,#FE,#F7,#FA,#7F,#EC,#73,#FE ; #51e0 I...I..._.....s.
db #7F,#EC,#37,#FE,#7F,#C8,#13,#FE,#7F,#C8,#13,#FE,#7F,#80,#01,#FE ; #51f0 ..7.............
db #7F,#80,#01,#FE,#7F,#C8,#13,#FE,#7F,#C8,#13,#FE,#7F,#EC,#37,#FE ; #5200 ..............7.
db #7F,#EC,#37,#FE,#7D,#FE,#7F,#FA,#58,#FF,#FF,#92,#49,#FF,#FF,#92 ; #5210 ..7.}...X...I...
db #48,#7F,#FE,#12,#48,#7F,#FE,#12,#6C,#37,#EC,#36,#6C,#37,#EC,#36 ; #5220 H...H...l7.6l7.6
db #6F,#7F,#EF,#7E,#7F,#FF,#FF,#FE,#73,#FF,#FF,#EC,#70,#F0,#F0,#E0 ; #5230 o..~....s...p...

db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#2D,#F0,#F0,#FB ; #5240 .........x..-...
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #5250 .........x......
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#2D,#F0,#F0,#FB ; #5260 .........x..-...
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #5270 .........x......
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#2D,#F0,#F0,#FB ; #5280 .........x..-...
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #5290 .........x......
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#2D,#F0,#F0,#FB ; #52a0 .........x..-...
db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #52b0 .........x......

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #52c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #52d0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #52e0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #52f0 ................
db #00,#00,#00,#00,#00,#01,#08,#00,#00,#07,#E6,#00,#00,#1E,#F3,#00 ; #5300 ................
db #01,#78,#F5,#88,#01,#3C,#F1,#88,#03,#5A,#F2,#CC,#03,#3C,#F1,#CC ; #5310 .x...<...Z...<..
db #03,#78,#F2,#CC,#07,#B4,#F1,#EE,#16,#78,#F1,#E6,#07,#F0,#F0,#EA ; #5320 .x.......x......
db #16,#F0,#F0,#E6,#07,#F0,#F1,#EE,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #5330 .........x......

db #1E,#F0,#F0,#F7,#0F,#F0,#F1,#FF,#1E,#78,#F0,#F7,#2D,#F0,#F0,#FF ; #5340 .........x..-...
db #16,#F0,#F0,#E6,#07,#F0,#F1,#EE,#16,#F0,#F0,#E6,#07,#F0,#F1,#EE ; #5350 ................
db #12,#F0,#F4,#CC,#12,#F0,#F3,#CC,#12,#F1,#F5,#CC,#10,#F0,#FB,#88 ; #5360 ................
db #10,#F1,#F7,#88,#00,#F4,#FF,#00,#00,#73,#EE,#00,#00,#11,#88,#00 ; #5370 .........s......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5380 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5390 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #53a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #53b0 ................

db #00,#00,#00,#01,#00,#00,#00,#01,#00,#00,#00,#03,#00,#00,#00,#03 ; #53c0 ................
db #00,#00,#00,#03,#00,#00,#00,#01,#00,#00,#00,#01,#00,#00,#00,#00 ; #53d0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#01,#00,#00,#00,#01 ; #53e0 ................
db #00,#00,#07,#03,#00,#00,#07,#83,#00,#00,#3F,#1F,#00,#00,#3F,#9F ; #53f0 ..........?...?.
db #00,#01,#7F,#3F,#00,#01,#7F,#3F,#00,#03,#EF,#7F,#00,#03,#ED,#5E ; #5400 ...?...?.......^
db #00,#17,#CB,#FE,#00,#17,#C3,#FC,#00,#3F,#97,#FC,#00,#3E,#97,#F9 ; #5410 .........?...>..
db #01,#7E,#3F,#F9,#01,#7C,#3F,#F3,#03,#FC,#3F,#F3,#03,#E8,#B6,#F7 ; #5420 .~?..|?...?.....
db #17,#E8,#F2,#F7,#17,#C0,#70,#FF,#3F,#C0,#70,#FE,#3E,#80,#21,#FE ; #5430 ......p.?.p.>.!.

db #7E,#2C,#01,#7C,#7C,#1E,#03,#FC,#ED,#3E,#03,#E8,#ED,#5E,#97,#E8 ; #5440 ~,.||....>...^..
db #CF,#FE,#97,#C0,#CF,#FC,#BF,#C0,#9F,#FC,#FE,#80,#9F,#F9,#FE,#80 ; #5450 ................
db #3F,#F9,#FC,#00,#3F,#F3,#FC,#00,#7F,#F3,#E8,#00,#7E,#F7,#E8,#00 ; #5460 ?...?.......~...
db #FE,#F7,#C0,#00,#FC,#FF,#C0,#00,#FC,#F6,#80,#00,#E8,#F0,#80,#00 ; #5470 ................
db #E8,#F0,#00,#00,#C0,#70,#00,#00,#C0,#00,#00,#00,#80,#00,#00,#00 ; #5480 .....p..........
db #80,#00,#00,#00,#80,#00,#00,#00,#80,#00,#00,#00,#C0,#00,#00,#00 ; #5490 ................
db #C8,#00,#00,#00,#C0,#00,#00,#00,#C8,#00,#00,#00,#C8,#00,#00,#00 ; #54a0 ................
db #C0,#00,#00,#00,#C0,#00,#00,#00,#80,#00,#00,#00,#80,#00,#00,#00 ; #54b0 ................

db #7E,#80,#12,#7E,#3F,#C0,#07,#F6,#37,#C0,#0F,#F3,#17,#E8,#3F,#F3 ; #54c0 ~..~?...7.....?.
db #13,#E8,#7F,#F3,#03,#FC,#7F,#FB,#01,#FE,#7F,#E9,#01,#7E,#B7,#ED ; #54d0 .............~..
db #00,#7F,#97,#FC,#00,#3F,#D3,#FE,#00,#37,#CF,#FE,#00,#17,#EF,#FF ; #54e0 .....?...7......
db #00,#13,#EF,#7F,#00,#03,#EF,#7F,#00,#01,#4F,#3F,#00,#01,#0F,#37 ; #54f0 ..........O?...7
db #00,#00,#0F,#17,#00,#00,#0E,#13,#00,#00,#00,#03,#00,#00,#00,#01 ; #5500 ................
db #00,#00,#00,#01,#00,#00,#00,#01,#00,#00,#00,#01,#00,#00,#00,#03 ; #5510 ................
db #00,#00,#00,#13,#00,#00,#00,#03,#00,#00,#00,#13,#00,#00,#00,#13 ; #5520 ................
db #00,#00,#00,#03,#00,#00,#00,#03,#00,#00,#00,#01,#00,#00,#00,#01 ; #5530 ................

db #80,#00,#00,#00,#80,#00,#00,#00,#0C,#00,#00,#00,#0C,#00,#00,#00 ; #5540 ................
db #0C,#00,#00,#00,#08,#00,#00,#00,#08,#00,#00,#00,#00,#00,#00,#00 ; #5550 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#80,#00,#00,#00,#80,#00,#00,#00 ; #5560 ................
db #C0,#0E,#00,#00,#C9,#2C,#00,#00,#E9,#FE,#00,#00,#FD,#FC,#00,#00 ; #5570 .....,..........
db #FC,#FE,#80,#00,#FE,#FE,#80,#00,#FE,#F7,#C0,#00,#FF,#B7,#C0,#00 ; #5580 ................
db #7F,#D3,#E8,#00,#7F,#CB,#E8,#00,#3F,#E9,#FC,#00,#BF,#ED,#44,#00 ; #5590 ........?.....D.
db #9F,#FC,#7E,#80,#DB,#FC,#3E,#80,#CB,#FC,#3F,#C0,#E9,#F0,#17,#C0 ; #55a0 ..~...>...?.....
db #ED,#F0,#17,#E8,#FC,#E0,#03,#E8,#7C,#2C,#03,#FC,#7E,#84,#01,#7C ; #55b0 ........|,..~..|

db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #55c0 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#0F,#87,#0F,#87,#0F,#0F,#0F,#0F ; #55d0 ................
db #F0,#F0,#F0,#F0,#E1,#F0,#E1,#F0,#01,#80,#01,#80,#01,#80,#01,#80 ; #55e0 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #55f0 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #5600 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#0F,#87,#0F,#87,#0F,#0F,#0F,#0F ; #5610 ................
db #F0,#F0,#F0,#F0,#E1,#F0,#E1,#F0,#01,#80,#01,#80,#01,#80,#01,#80 ; #5620 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #5630 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #5640 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#0F,#87,#0F,#87,#0F,#0F,#0F,#0F ; #5650 ................
db #F0,#0F,#1E,#F0,#E1,#7F,#FE,#F0,#01,#7F,#FE,#80,#01,#7F,#FE,#80 ; #5660 ................
db #01,#6F,#7E,#80,#01,#4F,#7A,#80,#01,#4F,#7A,#80,#01,#4F,#F2,#80 ; #5670 .o~..Oz..Oz..O..
db #01,#4F,#F2,#80,#01,#5E,#D0,#80,#01,#5E,#D0,#80,#01,#7E,#90,#80 ; #5680 .O...^...^...~..
db #01,#7F,#32,#80,#01,#7F,#FE,#80,#0F,#7F,#FE,#87,#0F,#F0,#F0,#0F ; #5690 ..2.............
db #F0,#F0,#F0,#F0,#E1,#F0,#E1,#F0,#01,#80,#01,#80,#01,#80,#01,#80 ; #56a0 ................
db #01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80,#01,#80 ; #56b0 ................
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #56c0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #56d0 3333333333333333
db #33,#33,#33,#33,#33,#33,#32,#31,#30,#33,#33,#31,#33,#33,#33,#31 ; #56e0 3333332103313331
db #33,#33,#33,#33,#31,#33,#33,#33,#33,#30,#20,#30,#20,#20,#30,#11 ; #56f0 3333133330 0  0.
db #64,#10,#23,#03,#03,#13,#02,#10,#23,#03,#03,#13,#02,#10,#23,#03 ; #5700 d.#.....#.....#.
db #03,#13,#02,#10,#23,#03,#03,#13,#02,#10,#23,#03,#03,#13,#02,#10 ; #5710 ....#.....#.....
db #23,#03,#03,#13,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #5720 #....L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#03,#03,#03,#13,#02,#4C ; #5730 ..3&...3L......L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #5740 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #5750 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #5760 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#31,#33,#33,#33,#02,#4C ; #5770 ..3&...3L.1333.L
db #64,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33 ; #5780 d.3333..3333..33
db #33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10 ; #5790 33..3333..3333..
db #33,#33,#33,#33,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #57a0 3333.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#33,#33,#33,#33,#02,#4C ; #57b0 ..3&...3L.3333.L
db #0F,#0F,#0F,#0F,#0F,#0F,#0F,#0E,#78,#F0,#F0,#E0,#78,#F0,#F0,#E0 ; #57c0 ........x...x...
db #4B,#0F,#0F,#2C,#4B,#0F,#0F,#28,#5A,#F0,#F0,#A2,#5A,#F0,#F0,#A2 ; #57d0 K..,K..(Z...Z...
db #5A,#0F,#0F,#A2,#5A,#0F,#0E,#A2,#5A,#78,#E0,#AA,#5A,#78,#E0,#AA ; #57e0 Z...Z...Zx..Zx..
db #5A,#4B,#2C,#AA,#5A,#4B,#28,#AA,#5A,#5A,#A2,#AA,#5A,#5A,#A2,#AA ; #57f0 ZK,.ZK(.ZZ..ZZ..
db #5A,#5A,#A2,#AA,#5A,#5A,#A2,#AA,#5A,#4A,#22,#AA,#5A,#48,#22,#AA ; #5800 ZZ..ZZ..ZJ".ZH".
db #5A,#79,#EE,#AA,#5A,#78,#EE,#AA,#5A,#08,#00,#AA,#5A,#00,#00,#AA ; #5810 Zy..Zx..Z...Z...
db #5A,#F7,#FF,#AA,#5A,#F3,#FF,#AA,#4A,#00,#00,#22,#48,#00,#00,#22 ; #5820 Z...Z...J.."H.."
db #79,#FF,#FF,#EE,#78,#FF,#FF,#EE,#08,#00,#00,#00,#00,#00,#00,#00 ; #5830 y...x...........
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #5840 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #5850 ................
db #F0,#0F,#0F,#F0,#F0,#0F,#0E,#70,#F0,#78,#E0,#70,#F0,#78,#E0,#70 ; #5860 .......p.x.p.x.p
db #F0,#4B,#2C,#70,#F0,#4B,#28,#70,#F0,#5A,#A2,#70,#F0,#5A,#A2,#70 ; #5870 .K,p.K(p.Z.p.Z.p
db #F0,#5A,#A2,#30,#F0,#5A,#A2,#10,#F0,#4A,#22,#00,#F0,#48,#22,#00 ; #5880 .Z.0.Z...J"..H".
db #F0,#79,#EE,#00,#F0,#78,#EE,#00,#F0,#08,#00,#00,#F0,#00,#00,#00 ; #5890 .y...x..........
db #F0,#80,#00,#00,#F0,#C0,#00,#00,#F0,#F0,#F0,#80,#F0,#F0,#F0,#F0 ; #58a0 ................
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0 ; #58b0 ................
db #0F,#0F,#0F,#1E,#08,#00,#00,#02,#08,#00,#00,#02,#38,#F0,#F0,#C2 ; #58c0 ............8...
db #38,#B4,#F0,#C2,#3A,#F0,#70,#C2,#38,#E5,#F0,#C2,#38,#70,#78,#C2 ; #58d0 8...:.p.8...8px.
db #38,#F0,#F0,#C2,#38,#F0,#F0,#C2,#29,#0F,#1E,#C2,#29,#0F,#2E,#C2 ; #58e0 8...8...)...)...
db #29,#0F,#2E,#42,#29,#0F,#6E,#02,#29,#0F,#6E,#02,#29,#3F,#EE,#02 ; #58f0 )..B).n.).n.)?..
db #29,#7F,#EE,#02,#29,#7F,#EE,#02,#29,#FF,#EE,#02,#29,#FF,#EE,#02 ; #5900 )...)...)...)...
db #39,#00,#00,#02,#39,#88,#00,#02,#39,#C8,#00,#02,#39,#E8,#00,#02 ; #5910 9...9...9...9...
db #39,#F8,#F0,#C2,#39,#F8,#F0,#C2,#39,#F8,#F0,#C2,#39,#F8,#F0,#C2 ; #5920 9...9...9...9...
db #39,#F8,#F0,#C2,#1F,#8F,#0F,#0E,#80,#C0,#00,#00,#C0,#60,#00,#00 ; #5930 9............`..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5940 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5950 ................
db #1E,#F0,#F0,#F7,#0F,#F0,#F0,#FF,#07,#F0,#F0,#EE,#07,#F0,#F0,#EE ; #5960 ................
db #03,#78,#F1,#CC,#03,#78,#F1,#CC,#01,#78,#F1,#88,#01,#3C,#F3,#88 ; #5970 .x...x...x...<..
db #00,#3C,#F3,#00,#00,#3C,#F3,#00,#00,#07,#E6,#00,#00,#1E,#F3,#00 ; #5980 .<...<..........
db #01,#78,#F5,#88,#01,#3C,#F1,#88,#03,#5A,#F2,#CC,#03,#3C,#F1,#CC ; #5990 .x...<...Z...<..
db #03,#78,#F2,#CC,#07,#B4,#F1,#EE,#16,#78,#F1,#E6,#07,#F0,#F0,#EA ; #59a0 .x.......x......
db #16,#F0,#F0,#E6,#07,#F0,#F1,#EE,#1E,#78,#F0,#F7,#0F,#F0,#F0,#FB ; #59b0 .........x......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #59c0 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #59d0 x...x...x...x...
db #78,#C3,#3C,#F1,#78,#B4,#F2,#F1,#78,#78,#F1,#F1,#78,#69,#79,#F1 ; #59e0 x.<.x...xx..xiy.
db #78,#4B,#FD,#F1,#78,#4B,#FD,#F1,#78,#4B,#FD,#F1,#78,#4B,#FD,#F1 ; #59f0 xK..xK..xK..xK..
db #78,#5A,#F5,#F1,#78,#5A,#F5,#F1,#78,#5A,#F5,#F1,#78,#78,#F1,#F1 ; #5a00 xZ..xZ..xZ..xx..
db #78,#78,#F1,#F1,#78,#F4,#F2,#F1,#78,#F3,#FC,#F1,#78,#F0,#F0,#F1 ; #5a10 xx..x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5a20 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5a30 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5a40 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#E1,#F0,#F1,#78,#C3,#F8,#F1 ; #5a50 x...x...x...x...
db #78,#D3,#B8,#F1,#78,#D3,#B8,#F1,#78,#D3,#B8,#F1,#78,#97,#B8,#F1 ; #5a60 x...x...x...x...
db #78,#97,#98,#F1,#78,#D7,#98,#F1,#78,#5F,#AA,#F1,#78,#5F,#AA,#F1 ; #5a70 x...x...x_..x_..
db #78,#DF,#AA,#F1,#69,#DF,#BB,#71,#69,#DF,#BB,#71,#69,#CF,#BB,#71 ; #5a80 x...i..qi..qi..q
db #5B,#CF,#BB,#B9,#5B,#CF,#BB,#B9,#5B,#CF,#BB,#B9,#79,#CF,#33,#31 ; #5a90 [...[...[...y.31
db #68,#00,#00,#31,#78,#00,#00,#71,#78,#F0,#00,#71,#78,#F0,#C0,#31 ; #5aa0 h..1x..qx..qx..1
db #78,#F0,#F0,#31,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5ab0 x..1x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5ac0 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#C3,#78,#F1,#78,#87,#3C,#F1 ; #5ad0 x...x...x.x.x.<.
db #78,#87,#3C,#F1,#78,#0F,#1E,#F1,#78,#2F,#9E,#F1,#69,#5F,#4F,#F1 ; #5ae0 x.<.x...x/..i_O.
db #69,#3F,#ED,#F1,#69,#7F,#9A,#71,#69,#3F,#ED,#71,#69,#7F,#9A,#71 ; #5af0 i?..i..qi?.qi..q
db #69,#5D,#65,#71,#78,#2E,#CA,#71,#78,#0F,#A4,#71,#78,#96,#48,#31 ; #5b00 i]eqx..qx..qx.H1
db #78,#87,#84,#31,#78,#C3,#08,#71,#78,#E0,#00,#71,#78,#F0,#E0,#F1 ; #5b10 x..1x..qx..qx...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5b20 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5b30 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5b40 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#87,#78,#F1,#78,#1E,#F0,#F1 ; #5b50 x...x...x.x.x...
db #78,#3C,#F0,#F1,#69,#78,#F2,#F1,#69,#78,#F2,#F1,#69,#78,#E2,#31 ; #5b60 x<..ix..ix..ix.1
db #69,#F0,#E2,#11,#69,#F0,#E2,#11,#69,#F0,#E6,#00,#69,#F0,#E6,#00 ; #5b70 i...i...i...i...
db #69,#F0,#EE,#00,#78,#F1,#CC,#00,#78,#FF,#CC,#00,#78,#F7,#88,#00 ; #5b80 i...x...x...x...
db #78,#F0,#00,#00,#78,#F0,#00,#00,#78,#F0,#80,#00,#78,#F0,#80,#00 ; #5b90 x...x...x...x...
db #78,#F0,#C0,#31,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5ba0 x..1x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5bb0 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5bc0 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5bd0 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5be0 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5bf0 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5c00 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5c10 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5c20 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5c30 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5c40 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5c50 x...x...x...x...
db #78,#F3,#FC,#F1,#78,#C4,#12,#F1,#78,#88,#01,#F1,#78,#88,#01,#F1 ; #5c60 x...x...x...x...
db #79,#00,#00,#79,#79,#00,#00,#79,#79,#00,#00,#79,#79,#00,#00,#79 ; #5c70 y..yy..yy..yy..y
db #79,#00,#00,#79,#79,#00,#00,#79,#79,#00,#00,#79,#78,#88,#01,#F1 ; #5c80 y..yy..yy..yx...
db #78,#88,#01,#F1,#78,#C4,#12,#F1,#78,#C3,#3C,#F1,#78,#F0,#F0,#F1 ; #5c90 x...x...x.<.x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5ca0 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5cb0 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5cc0 ....x...x...x...
db #78,#F0,#F0,#F1,#69,#E1,#E1,#F1,#5B,#DB,#DB,#F9,#5B,#9B,#9B,#B9 ; #5cd0 x...i...[...[...
db #69,#01,#01,#11,#69,#01,#01,#11,#69,#A1,#A1,#B1,#69,#A1,#A1,#B1 ; #5ce0 i...i...i...i...
db #69,#A1,#A1,#B1,#69,#A1,#A1,#B1,#69,#A1,#A1,#B1,#69,#A1,#A1,#B1 ; #5cf0 i...i...i...i...
db #5B,#9B,#9B,#B9,#5B,#9B,#9B,#B9,#5B,#9B,#9B,#99,#78,#10,#10,#11 ; #5d00 [...[...[...x...
db #78,#10,#10,#11,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5d10 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5d20 x...x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5d30 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5d40 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#D3,#F8,#F1,#78,#B7,#B8,#F1 ; #5d50 x...x...x...x...
db #78,#B7,#B8,#F1,#78,#B7,#B8,#F1,#78,#B7,#B8,#F1,#78,#B7,#B8,#F1 ; #5d60 x...x...x...x...
db #78,#B7,#B8,#11,#78,#B7,#A8,#11,#78,#B7,#A8,#00,#78,#B7,#88,#00 ; #5d70 x...x...x...x...
db #78,#B7,#A8,#00,#78,#B7,#A8,#00,#78,#B7,#A8,#00,#78,#B7,#A8,#00 ; #5d80 x...x...x...x...
db #78,#B7,#A8,#00,#78,#B7,#A8,#00,#78,#B7,#A8,#00,#78,#B7,#A8,#00 ; #5d90 x...x...x...x...
db #78,#F3,#20,#00,#78,#E0,#C0,#00,#78,#D3,#60,#00,#78,#97,#20,#00 ; #5da0 x. .x...x.`.x. .
db #78,#F0,#E0,#00,#78,#F0,#E0,#00,#78,#F0,#F0,#00,#7F,#FF,#FF,#88 ; #5db0 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5dc0 ....x...x...x...
db #78,#F0,#F0,#F1,#78,#D3,#F8,#F1,#78,#B6,#B8,#F1,#78,#B6,#B8,#F1 ; #5dd0 x...x...x...x...
db #78,#F3,#70,#F1,#78,#D3,#F8,#F1,#78,#B6,#B8,#F1,#78,#B6,#B8,#11 ; #5de0 x.p.x...x...x...
db #78,#F3,#60,#11,#78,#D3,#E8,#00,#78,#B6,#B8,#00,#78,#B6,#B8,#11 ; #5df0 x.`.x...x...x...
db #78,#F3,#60,#11,#78,#D3,#E8,#00,#78,#B6,#B8,#00,#78,#B6,#B8,#11 ; #5e00 x.`.x...x...x...
db #78,#F3,#60,#11,#78,#0F,#0E,#00,#78,#7F,#CC,#00,#78,#7F,#CC,#00 ; #5e10 x.`.x...x...x...
db #78,#7F,#CC,#00,#78,#7F,#CC,#00,#78,#7F,#CC,#00,#78,#08,#00,#00 ; #5e20 x...x...x...x...
db #78,#80,#00,#00,#78,#C0,#00,#00,#78,#E0,#00,#00,#7F,#FF,#88,#00 ; #5e30 x...x...x.......
db #0F,#0F,#0F,#0F,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1,#78,#F0,#F0,#F1 ; #5e40 ....x...x...x...
db #69,#E9,#E1,#F9,#5B,#DE,#5B,#FD,#7B,#DE,#7B,#FD,#7B,#DC,#B7,#DD ; #5e50 i...[.[.{.{.{...
db #7B,#C8,#F3,#C8,#79,#80,#F1,#08,#5A,#00,#F0,#04,#5A,#00,#F0,#04 ; #5e60 {...y...Z...Z...
db #69,#90,#F0,#08,#78,#78,#E1,#F1,#78,#78,#E1,#F1,#69,#F0,#F0,#79 ; #5e70 i...xx..xx..i..y
db #5A,#F0,#F0,#B5,#5A,#F0,#F0,#B5,#69,#F0,#F0,#79,#78,#78,#E1,#F1 ; #5e80 Z...Z...i..yxx..
db #78,#78,#E1,#F1,#69,#F8,#E1,#F9,#5B,#ED,#D3,#FD,#7B,#DE,#7B,#FD ; #5e90 xx..i...[...{.{.
db #7B,#DE,#7B,#DD,#7B,#D8,#B7,#C8,#79,#80,#F1,#80,#78,#00,#F0,#00 ; #5ea0 {.{.{...y...x...
db #78,#00,#F0,#00,#78,#90,#F0,#80,#78,#F0,#F0,#F1,#7F,#FF,#FF,#FF ; #5eb0 x...x...x.......
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #5ec0 3333333333333333
db #33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33,#33 ; #5ed0 3333333333333333
db #33,#33,#33,#33,#33,#33,#32,#30,#30,#11,#33,#20,#33,#33,#33,#30 ; #5ee0 333333200.3 3330
db #20,#33,#33,#33,#31,#30,#11,#33,#33,#33,#31,#20,#20,#20,#31,#22 ; #5ef0  33310.3331   1"
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #5f00 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #5f10 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #5f20 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #5f30 ..3&...3L....1.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #5f40 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #5f50 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #5f60 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#03,#03,#03,#13,#02,#4C ; #5f70 ..3&...3L......L
db #64,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33 ; #5f80 d.3333..3333..33
db #33,#33,#02,#10,#33,#33,#33,#33,#02,#10,#33,#33,#33,#33,#02,#10 ; #5f90 33..3333..3333..
db #33,#33,#33,#33,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #5fa0 3333.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#33,#33,#33,#33,#02,#4C ; #5fb0 ..3&...3L.3333.L
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5fc0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5fd0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5fe0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #5ff0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6000 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6010 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6020 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6030 ................
db #00,#10,#30,#20,#00,#00,#00,#30,#30,#30,#00,#00,#10,#30,#31,#33 ; #6040 ..0 ...000...013
db #22,#00,#10,#30,#33,#33,#22,#00,#10,#31,#33,#33,#22,#00,#30,#31 ; #6050 "..033"..133".01
db #33,#33,#03,#00,#30,#33,#30,#33,#03,#00,#30,#32,#03,#31,#03,#00 ; #6060 33..0303..02.1..
db #30,#21,#33,#12,#03,#00,#31,#32,#03,#21,#03,#00,#31,#33,#30,#23 ; #6070 0!3...12.!..130#
db #03,#00,#11,#33,#33,#23,#02,#00,#11,#33,#33,#03,#02,#00,#11,#33 ; #6080 ...33#...33....3
db #23,#03,#02,#00,#00,#23,#03,#03,#00,#00,#00,#01,#03,#02,#00,#00 ; #6090 #....#..........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #60a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #60b0 ................
db #33,#00,#00,#00,#00,#33,#33,#33,#32,#31,#33,#33,#31,#33,#31,#23 ; #60c0 3....3332133131#
db #33,#23,#31,#33,#31,#23,#33,#23,#21,#33,#31,#23,#33,#21,#21,#33 ; #60d0 3#131#3#!31#3!!3
db #31,#23,#33,#21,#21,#33,#31,#23,#33,#21,#21,#33,#31,#23,#33,#21 ; #60e0 1#3!!31#3!!31#3!
db #21,#11,#31,#23,#22,#21,#21,#11,#31,#23,#22,#21,#21,#11,#31,#23 ; #60f0 !.1#"!!.1#"!!.1#
db #22,#21,#21,#00,#31,#23,#00,#21,#21,#00,#31,#23,#00,#21,#21,#00 ; #6100 "!!.1#.!!.1#.!!.
db #31,#23,#00,#21,#01,#00,#10,#02,#00,#20,#00,#00,#10,#02,#00,#00 ; #6110 1#.!..... ......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6120 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6130 ................
db #10,#20,#00,#10,#20,#00,#31,#23,#03,#13,#32,#00,#31,#12,#30,#21 ; #6140 . .. .1#..2.1.0!
db #32,#00,#01,#12,#30,#21,#02,#00,#01,#21,#30,#12,#02,#00,#01,#30 ; #6150 2...0!...!0....0
db #30,#30,#02,#00,#01,#13,#30,#23,#02,#00,#00,#12,#33,#21,#00,#00 ; #6160 00....0#....3!..
db #01,#03,#03,#03,#02,#00,#01,#33,#03,#33,#02,#00,#01,#23,#03,#13 ; #6170 .......3.3...#..
db #02,#00,#13,#23,#00,#13,#23,#00,#13,#03,#00,#03,#23,#00,#13,#02 ; #6180 ...#..#.....#...
db #00,#01,#23,#00,#13,#02,#00,#01,#23,#00,#03,#02,#00,#01,#03,#00 ; #6190 ..#.....#.......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #61a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #61b0 ................
db #00,#00,#20,#00,#00,#00,#00,#00,#20,#00,#00,#00,#00,#00,#20,#00 ; #61c0 .. ..... ..... .
db #00,#00,#00,#10,#30,#00,#00,#00,#00,#10,#30,#00,#00,#00,#00,#10 ; #61d0 ....0.....0.....
db #30,#00,#00,#00,#00,#21,#31,#20,#00,#00,#00,#21,#31,#20,#00,#00 ; #61e0 0....!1 ...!1 ..
db #00,#21,#31,#20,#00,#00,#10,#03,#31,#32,#00,#00,#10,#03,#31,#32 ; #61f0 .!1 ....12....12
db #00,#00,#10,#03,#31,#32,#00,#00,#21,#03,#31,#33,#20,#00,#21,#03 ; #6200 ....12..!.13 .!.
db #31,#33,#20,#00,#30,#21,#31,#30,#20,#00,#00,#10,#30,#00,#00,#00 ; #6210 13 .0!10 ...0...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6220 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6230 ................
db #00,#00,#10,#00,#00,#00,#00,#00,#10,#00,#00,#00,#00,#00,#10,#00 ; #6240 ................
db #00,#00,#00,#00,#30,#20,#00,#00,#00,#00,#30,#20,#00,#00,#00,#00 ; #6250 ....0 ....0 ....
db #30,#20,#00,#00,#00,#10,#12,#32,#00,#00,#00,#10,#12,#32,#00,#00 ; #6260 0 .....2.....2..
db #00,#10,#12,#32,#00,#00,#00,#21,#12,#33,#20,#00,#00,#21,#12,#33 ; #6270 ...2...!.3 ..!.3
db #20,#00,#00,#21,#12,#33,#20,#00,#10,#03,#12,#33,#32,#00,#10,#03 ; #6280  ..!.3 ....32...
db #12,#33,#32,#00,#10,#30,#12,#32,#30,#00,#00,#00,#30,#20,#00,#00 ; #6290 .32..0.20...0 ..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #62a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #62b0 ................
db #11,#20,#11,#20,#32,#30,#32,#30,#30,#31,#30,#31,#10,#22,#10,#22 ; #62c0 . . 20200101."."
db #11,#22,#11,#22,#30,#30,#30,#30,#30,#30,#30,#30,#11,#22,#11,#22 ; #62d0 ."."00000000."."
db #10,#22,#10,#22,#30,#31,#30,#31,#32,#30,#32,#30,#11,#20,#11,#20 ; #62e0 ."."01012020. . 
db #10,#20,#10,#20,#32,#31,#32,#31,#32,#31,#32,#31,#10,#20,#10,#20 ; #62f0 . . 21212121. . 
db #10,#00,#31,#02,#31,#02,#31,#02,#01,#00,#01,#00,#11,#00,#11,#00 ; #6300 ..1.1.1.........
db #11,#00,#31,#02,#31,#02,#31,#02,#00,#00,#00,#00,#00,#00,#00,#00 ; #6310 ..1.1.1.........
db #20,#20,#22,#22,#02,#02,#20,#20,#22,#22,#02,#02,#20,#20,#22,#22 ; #6320   ""..  ""..  ""
db #02,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6330 ................

db #00,#00,#00,#00,#10,#20,#10,#20,#10,#20,#10,#20,#00,#00,#00,#00 ; #6340 ..... . . . ....
db #11,#22,#33,#33,#23,#13,#23,#13,#23,#13,#23,#13,#33,#33,#11,#22 ; #6350 ."33#.#.#.#.33."
db #01,#02,#03,#03,#13,#23,#13,#23,#13,#23,#13,#23,#03,#03,#01,#02 ; #6360 .....#.#.#.#....
db #10,#20,#30,#30,#20,#10,#20,#10,#20,#10,#20,#10,#30,#30,#10,#20 ; #6370 . 00 . . . .00. 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6380 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6390 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #63a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #63b0 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #63c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#22,#00,#00,#00,#00 ; #63d0 ..........."....
db #32,#31,#00,#00,#00,#11,#30,#31,#00,#00,#00,#11,#30,#30,#22,#00 ; #63e0 21....01....00".
db #00,#11,#30,#30,#22,#00,#00,#00,#32,#30,#22,#00,#00,#11,#30,#30 ; #63f0 ..00"...20"...00
db #22,#00,#00,#11,#30,#31,#00,#00,#00,#11,#30,#30,#22,#00,#00,#11 ; #6400 "...01....00"...
db #30,#30,#22,#00,#00,#00,#32,#30,#22,#00,#00,#00,#32,#31,#00,#00 ; #6410 00"...20"...21..
db #00,#00,#11,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6420 ..."............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6430 ................

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#22,#33 ; #6440 .............."3
db #00,#00,#00,#32,#31,#30,#22,#00,#00,#32,#30,#30,#31,#00,#11,#30 ; #6450 ...210"..2001..0
db #30,#30,#31,#00,#11,#30,#30,#30,#31,#00,#11,#30,#30,#30,#31,#00 ; #6460 001..0001..0001.
db #00,#32,#30,#30,#22,#00,#00,#32,#30,#30,#22,#00,#00,#32,#30,#31 ; #6470 .200"..200"..201
db #00,#00,#00,#11,#30,#30,#22,#00,#00,#11,#30,#30,#22,#00,#00,#11 ; #6480 ....00"...00"...
db #30,#30,#31,#00,#00,#32,#30,#30,#31,#00,#00,#32,#30,#30,#31,#00 ; #6490 001..2001..2001.
db #00,#11,#32,#30,#31,#00,#00,#00,#11,#32,#22,#00,#00,#00,#00,#11 ; #64a0 ..201....2".....
db #22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #64b0 "...............

db #00,#00,#00,#00,#00,#00,#00,#11,#22,#11,#22,#00,#00,#32,#31,#32 ; #64c0 ........"."..212
db #31,#00,#00,#32,#31,#30,#30,#22,#00,#32,#30,#30,#30,#22,#11,#30 ; #64d0 1..2100".2000".0
db #30,#30,#30,#22,#11,#30,#30,#30,#30,#22,#11,#30,#30,#30,#30,#22 ; #64e0 000".0000".0000"
db #11,#30,#30,#30,#31,#00,#11,#30,#30,#30,#31,#00,#11,#30,#30,#30 ; #64f0 .0001..0001..000
db #22,#00,#00,#32,#30,#30,#33,#00,#00,#32,#30,#30,#30,#22,#00,#32 ; #6500 "..2003..2000".2
db #30,#30,#30,#22,#00,#33,#30,#30,#30,#22,#11,#30,#30,#30,#30,#22 ; #6510 000".3000".0000"
db #11,#30,#32,#30,#30,#22,#11,#31,#32,#30,#31,#00,#00,#33,#11,#32 ; #6520 .0200".1201..3.2
db #31,#00,#00,#00,#00,#11,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6530 1.....".........

db #00,#00,#00,#00,#00,#00,#00,#11,#22,#11,#33,#00,#00,#32,#31,#32 ; #6540 ........".3..212
db #30,#22,#11,#30,#31,#30,#30,#22,#11,#30,#30,#30,#30,#31,#11,#30 ; #6550 0".0100".00001.0
db #30,#30,#30,#31,#32,#30,#30,#30,#30,#31,#32,#30,#30,#30,#30,#31 ; #6560 0001200001200001
db #32,#30,#30,#30,#30,#22,#32,#30,#30,#30,#30,#22,#32,#30,#30,#30 ; #6570 20000"20000"2000
db #31,#22,#11,#30,#30,#30,#32,#22,#11,#30,#30,#30,#30,#31,#11,#30 ; #6580 1".0002".00001.0
db #30,#30,#30,#31,#32,#32,#30,#30,#30,#31,#32,#30,#30,#30,#30,#31 ; #6590 0001220001200001
db #32,#31,#30,#30,#30,#31,#32,#20,#32,#30,#30,#22,#11,#30,#33,#32 ; #65a0 2100012 200".032
db #30,#22,#00,#33,#00,#11,#33,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #65b0 0".3..3.........

db #00,#30,#30,#03,#00,#00,#10,#30,#33,#23,#02,#00,#30,#33,#33,#33 ; #65c0 .00....03#..0333
db #03,#00,#30,#33,#33,#33,#03,#00,#31,#03,#03,#03,#03,#00,#00,#33 ; #65d0 ..0333..1......3
db #03,#03,#00,#00,#00,#33,#23,#03,#00,#00,#00,#31,#33,#23,#00,#00 ; #65e0 .....3#....13#..
db #00,#31,#33,#23,#00,#00,#10,#30,#33,#03,#02,#00,#10,#31,#33,#03 ; #65f0 .13#...03....13.
db #02,#00,#00,#33,#03,#03,#00,#00,#00,#31,#33,#23,#00,#00,#00,#31 ; #6600 ...3.....13#...1
db #33,#23,#00,#00,#00,#31,#33,#23,#00,#00,#30,#30,#30,#33,#03,#00 ; #6610 3#...13#..0003..
db #30,#33,#33,#33,#03,#00,#30,#33,#33,#23,#03,#00,#10,#31,#33,#03 ; #6620 0333..033#...13.
db #02,#00,#00,#30,#03,#03,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6630 ...0............

db #00,#00,#00,#30,#20,#00,#00,#00,#10,#31,#31,#00,#00,#10,#30,#32 ; #6640 ...0 ....11...02
db #13,#22,#00,#30,#33,#30,#33,#22,#00,#30,#31,#33,#23,#22,#10,#30 ; #6650 .".0303".013#".0
db #23,#33,#33,#33,#10,#13,#33,#23,#33,#33,#30,#32,#33,#33,#33,#03 ; #6660 #333..3#3302333.
db #31,#30,#13,#31,#33,#13,#30,#33,#33,#23,#33,#03,#30,#31,#33,#33 ; #6670 10.13.033#3.0133
db #33,#03,#31,#33,#32,#23,#33,#03,#32,#33,#33,#13,#33,#03,#23,#33 ; #6680 3.132#3.233.3.#3
db #13,#33,#23,#23,#33,#32,#33,#33,#23,#23,#11,#33,#33,#23,#13,#03 ; #6690 .3##3233##.33#..
db #11,#33,#23,#23,#13,#02,#11,#13,#23,#13,#03,#02,#00,#23,#13,#03 ; #66a0 .3##....#....#..
db #02,#00,#00,#11,#03,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #66b0 ................

hud:
db #32,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30 ; #66c0 2000000000000000
db #30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30 ; #66d0 0000000000000000
db #30,#30,#30,#30,#30,#31,#32,#10,#32,#11,#33,#20,#33,#33,#33,#22 ; #66e0 0000012.2.3 333"
db #31,#33,#33,#33,#20,#32,#33,#33,#0C,#30,#0C,#24,#24,#24,#24,#0C ; #66f0 1333 233.0.$$$$.

db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #6700 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #6710 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #6720 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #6730 ..3&...3L....1.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #6740 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #6750 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #6760 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #6770 ..3&...3L....1.L
db #64,#10,#03,#03,#03,#03,#02,#10,#03,#03,#03,#03,#02,#10,#03,#03 ; #6780 d...............
db #03,#03,#02,#10,#03,#03,#03,#03,#02,#10,#03,#03,#03,#03,#02,#10 ; #6790 ................
db #03,#03,#03,#03,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #67a0 .....L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#10,#03,#03,#03,#03,#02,#4C ; #67b0 ..3&...3L......L
db #20,#00,#00,#00,#10,#00,#10,#00,#00,#00,#20,#00,#10,#30,#00,#30 ; #67c0  ......... ..0.0
db #20,#00,#00,#31,#30,#32,#00,#00,#00,#31,#33,#32,#00,#00,#00,#30 ; #67d0  ..102...132...0
db #33,#30,#00,#00,#00,#10,#33,#20,#00,#00,#00,#10,#33,#20,#00,#00 ; #67e0 30....3 ....3 ..
db #00,#10,#33,#20,#00,#00,#00,#10,#33,#20,#00,#00,#00,#30,#33,#30 ; #67f0 ..3 ....3 ...030
db #00,#00,#00,#31,#33,#32,#00,#00,#00,#31,#30,#32,#00,#00,#10,#30 ; #6800 ...132...102...0
db #00,#30,#20,#00,#10,#00,#00,#00,#20,#00,#20,#00,#00,#00,#10,#00 ; #6810 .0 ..... . .....
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6820 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6830 ................
db #00,#00,#30,#00,#00,#00,#00,#10,#21,#02,#00,#00,#00,#30,#03,#03 ; #6840 ..0.....!....0..
db #00,#00,#00,#21,#03,#03,#00,#00,#00,#21,#03,#03,#00,#00,#00,#21 ; #6850 ...!.....!.....!
db #03,#03,#00,#00,#00,#01,#03,#02,#00,#00,#00,#10,#03,#22,#00,#00 ; #6860 ............."..
db #00,#30,#31,#33,#00,#00,#10,#30,#31,#33,#22,#00,#10,#30,#13,#33 ; #6870 .013...013"..0.3
db #02,#00,#30,#30,#13,#33,#03,#00,#30,#30,#13,#33,#03,#00,#10,#30 ; #6880 ..00.3..00.3...0
db #13,#33,#02,#00,#10,#21,#13,#23,#02,#00,#00,#03,#00,#03,#00,#00 ; #6890 .3...!.#........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #68a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #68b0 ................
db #00,#00,#11,#00,#00,#00,#00,#00,#11,#00,#00,#00,#00,#00,#11,#22 ; #68c0 ..............."
db #00,#00,#00,#00,#22,#22,#00,#00,#00,#00,#22,#11,#00,#00,#00,#11 ; #68d0 ....""....".....
db #00,#11,#00,#00,#00,#11,#00,#00,#22,#00,#00,#22,#00,#00,#22,#00 ; #68e0 ........".."..".
db #01,#21,#00,#00,#11,#00,#12,#03,#02,#00,#21,#02,#30,#03,#02,#10 ; #68f0 .!........!.0...
db #03,#03,#21,#03,#02,#10,#03,#03,#03,#03,#02,#10,#03,#03,#03,#03 ; #6900 ..!.............
db #02,#01,#03,#03,#01,#03,#00,#01,#03,#03,#00,#00,#00,#00,#03,#02 ; #6910 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6920 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6930 ................
db #00,#00,#00,#00,#20,#00,#00,#30,#00,#10,#20,#00,#10,#30,#20,#30 ; #6940 .... ..0.. ..0 0
db #00,#00,#00,#12,#30,#21,#00,#00,#01,#03,#30,#03,#02,#00,#03,#03 ; #6950 ....0!....0.....
db #03,#23,#02,#00,#03,#23,#03,#03,#23,#00,#23,#03,#23,#03,#03,#00 ; #6960 .#...#..#.#.#...
db #03,#03,#03,#23,#03,#00,#01,#23,#03,#03,#23,#00,#01,#03,#13,#03 ; #6970 ...#...#..#.....
db #02,#00,#01,#03,#03,#03,#02,#00,#00,#13,#03,#13,#00,#00,#00,#03 ; #6980 ................
db #13,#03,#00,#00,#00,#01,#03,#02,#00,#00,#00,#00,#03,#00,#00,#00 ; #6990 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #69a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #69b0 ................
db #00,#10,#30,#20,#00,#00,#00,#30,#30,#30,#00,#00,#10,#30,#30,#30 ; #69c0 ..0 ...000...000
db #20,#00,#10,#30,#31,#30,#20,#00,#10,#30,#32,#32,#20,#00,#30,#31 ; #69d0  ..010 ..022 .01
db #31,#32,#30,#00,#30,#32,#33,#23,#30,#00,#30,#31,#33,#13,#30,#00 ; #69e0 120.023#0.013.0.
db #30,#32,#33,#23,#30,#00,#30,#33,#23,#33,#30,#00,#30,#31,#13,#12 ; #69f0 023#0.03#30.01..
db #12,#00,#10,#21,#23,#23,#20,#00,#10,#30,#13,#12,#02,#00,#10,#30 ; #6a00 ...!## ..0.....0
db #21,#21,#20,#00,#00,#30,#30,#12,#00,#00,#00,#10,#30,#20,#00,#00 ; #6a10 !! ..00.....0 ..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6a20 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6a30 ................
db #00,#10,#31,#00,#00,#00,#00,#20,#02,#22,#00,#00,#10,#01,#01,#11 ; #6a40 ..1.... ."......
db #00,#00,#10,#12,#02,#13,#00,#00,#21,#21,#01,#01,#22,#00,#20,#20 ; #6a50 ........!!..".  
db #02,#02,#22,#00,#21,#01,#01,#01,#22,#00,#20,#02,#02,#02,#22,#00 ; #6a60 ..".!...". ...".
db #23,#01,#01,#01,#22,#00,#22,#02,#02,#02,#22,#00,#23,#01,#01,#01 ; #6a70 #..."."...".#...
db #22,#00,#22,#02,#02,#02,#22,#00,#11,#01,#01,#11,#00,#00,#11,#02 ; #6a80 "."...".........
db #02,#13,#00,#00,#00,#23,#01,#22,#00,#00,#00,#11,#33,#00,#00,#00 ; #6a90 .....#."....3...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6aa0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6ab0 ................
db #00,#00,#31,#00,#00,#00,#00,#00,#31,#00,#00,#00,#00,#10,#31,#22 ; #6ac0 ..1.....1.....1"
db #00,#00,#00,#10,#31,#22,#00,#00,#00,#30,#31,#33,#00,#00,#00,#30 ; #6ad0 ....1"...013...0
db #31,#33,#00,#00,#10,#30,#31,#33,#22,#00,#30,#30,#31,#33,#33,#00 ; #6ae0 13...013".00133.
db #33,#33,#23,#03,#03,#00,#11,#33,#23,#03,#02,#00,#00,#33,#23,#03 ; #6af0 33#....3#....3#.
db #00,#00,#00,#33,#23,#03,#00,#00,#00,#11,#23,#02,#00,#00,#00,#11 ; #6b00 ...3#.....#.....
db #23,#02,#00,#00,#00,#00,#23,#00,#00,#00,#00,#00,#23,#00,#00,#00 ; #6b10 #.....#.....#...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6b20 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6b30 ................
db #00,#10,#30,#20,#00,#00,#10,#30,#30,#30,#20,#00,#10,#30,#30,#30 ; #6b40 ..0 ...000 ..000
db #20,#00,#30,#30,#30,#30,#30,#00,#30,#21,#30,#12,#30,#00,#30,#13 ; #6b50  .00000.0!0.0.0.
db #30,#23,#30,#00,#32,#30,#30,#30,#31,#00,#32,#30,#33,#30,#31,#00 ; #6b60 0#0.20001.20301.
db #32,#30,#33,#30,#31,#00,#32,#31,#30,#32,#31,#00,#10,#30,#30,#30 ; #6b70 20301.21021..000
db #20,#00,#10,#30,#03,#30,#20,#00,#10,#21,#03,#12,#20,#00,#00,#12 ; #6b80  ..0.0 ..!.. ...
db #30,#21,#00,#00,#00,#30,#30,#30,#00,#00,#00,#00,#30,#00,#00,#00 ; #6b90 0!...000....0...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6ba0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6bb0 ................
db #00,#10,#30,#30,#20,#00,#10,#20,#00,#00,#10,#20,#20,#00,#00,#00 ; #6bc0 ..00 .. ...  ...
db #00,#10,#10,#20,#00,#00,#10,#20,#00,#10,#30,#30,#20,#00,#00,#00 ; #6bd0 ... ... ..00 ...
db #00,#00,#00,#00,#00,#00,#30,#30,#00,#00,#00,#30,#00,#00,#30,#00 ; #6be0 ......00...0..0.
db #10,#00,#00,#00,#00,#20,#00,#30,#00,#00,#30,#00,#00,#00,#30,#30 ; #6bf0 ..... .0..0...00
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#30,#30,#20,#00,#00,#20 ; #6c00 ..........00 .. 
db #00,#00,#10,#00,#00,#10,#30,#30,#20,#00,#00,#00,#00,#00,#00,#00 ; #6c10 ......00 .......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6c20 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6c30 ................
db #10,#00,#00,#00,#20,#00,#31,#02,#00,#10,#23,#00,#31,#02,#30,#10 ; #6c40 .... .1...#.1.0.
db #23,#00,#01,#10,#00,#20,#02,#00,#00,#20,#00,#10,#00,#00,#00,#20 ; #6c50 #.... ... ..... 
db #00,#10,#00,#00,#10,#00,#00,#00,#20,#00,#10,#00,#00,#00,#20,#00 ; #6c60 ........ ..... .
db #10,#00,#00,#00,#20,#00,#10,#00,#00,#00,#20,#00,#00,#20,#00,#10 ; #6c70 .... ..... .. ..
db #00,#00,#00,#20,#00,#10,#00,#00,#10,#10,#00,#20,#20,#00,#31,#02 ; #6c80 ... .......  .1.
db #30,#10,#23,#00,#31,#02,#00,#10,#23,#00,#01,#00,#00,#00,#02,#00 ; #6c90 0.#.1...#.......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6ca0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6cb0 ................
db #10,#30,#30,#30,#20,#00,#30,#30,#30,#30,#21,#00,#31,#33,#33,#33 ; #6cc0 .000 .0000!.1333
db #23,#00,#21,#03,#03,#03,#03,#00,#21,#00,#00,#00,#21,#00,#21,#00 ; #6cd0 #.!.....!...!.!.
db #00,#00,#21,#00,#21,#00,#00,#00,#21,#00,#21,#00,#00,#00,#21,#00 ; #6ce0 ..!.!...!.!...!.
db #21,#00,#00,#00,#21,#00,#21,#00,#00,#00,#21,#00,#21,#00,#00,#00 ; #6cf0 !...!.!...!.!...
db #21,#00,#21,#00,#00,#00,#21,#00,#30,#30,#30,#30,#21,#00,#31,#33 ; #6d00 !.!...!.0000!.13
db #33,#33,#23,#00,#21,#03,#03,#03,#03,#00,#01,#03,#03,#03,#02,#00 ; #6d10 33#.!...........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6d20 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6d30 ................
db #30,#30,#30,#30,#30,#00,#31,#33,#33,#33,#23,#00,#03,#03,#03,#03 ; #6d40 00000.1333#.....
db #23,#00,#00,#00,#00,#11,#23,#00,#00,#00,#00,#31,#23,#00,#00,#00 ; #6d50 #.....#....1#...
db #10,#33,#02,#00,#00,#00,#31,#23,#00,#00,#00,#10,#33,#02,#00,#00 ; #6d60 .3....1#....3...
db #00,#31,#23,#00,#00,#00,#10,#33,#02,#00,#00,#00,#31,#23,#00,#00 ; #6d70 .1#....3....1#..
db #00,#00,#31,#02,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00,#30,#30 ; #6d80 ..1.....!.....00
db #30,#30,#30,#00,#31,#33,#33,#33,#23,#00,#03,#03,#03,#03,#03,#00 ; #6d90 000.1333#.......
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6da0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6db0 ................
db #30,#30,#30,#30,#30,#00,#31,#33,#33,#33,#23,#00,#03,#03,#03,#03 ; #6dc0 00000.1333#.....
db #03,#00,#00,#00,#21,#00,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00 ; #6dd0 ....!.....!.....
db #21,#00,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00,#21,#00,#00,#00 ; #6de0 !.....!.....!...
db #00,#00,#21,#00,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00,#21,#00 ; #6df0 ..!.....!.....!.
db #00,#00,#00,#00,#21,#00,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00 ; #6e00 ....!.....!.....
db #21,#00,#00,#00,#00,#00,#21,#00,#00,#00,#00,#00,#21,#00,#00,#00 ; #6e10 !.....!.....!...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6e20 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6e30 ................
db #10,#30,#30,#00,#00,#00,#10,#33,#33,#22,#00,#00,#10,#03,#03,#23 ; #6e40 .00....33".....#
db #00,#00,#10,#00,#00,#10,#02,#00,#10,#00,#00,#10,#02,#00,#10,#00 ; #6e50 ................
db #00,#21,#00,#00,#10,#30,#30,#02,#00,#00,#10,#33,#33,#02,#00,#00 ; #6e60 .!...00....33...
db #10,#03,#03,#02,#00,#00,#10,#00,#00,#23,#00,#00,#10,#00,#00,#11 ; #6e70 .........#......
db #02,#00,#10,#00,#00,#10,#02,#00,#10,#00,#00,#10,#02,#00,#10,#30 ; #6e80 ...............0
db #30,#31,#02,#00,#10,#33,#33,#23,#00,#00,#01,#03,#03,#03,#00,#00 ; #6e90 01...33#........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6ea0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6eb0 ................
db #64,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #6ec0 d...............
db #CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #6ed0 ................
db #CC,#CC,#CC,#CC,#CC,#CC,#32,#11,#10,#11,#33,#30,#31,#33,#33,#30 ; #6ee0 ......2...301330
db #33,#33,#33,#33,#32,#30,#11,#33,#4C,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #6ef0 333320.3L.......
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #6f00 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #6f10 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #6f20 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #6f30 ..3&...3L....1.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #6f40 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #6f50 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #6f60 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #6f70 ..3&...3L....1.L
db #64,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6f80 d...............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6f90 ................
db #00,#00,#00,#00,#00,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #6fa0 .....L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#00,#00,#4C ; #6fb0 ..3&...3L......L
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6fc0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6fd0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6fe0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #6ff0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7000 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7010 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7020 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7030 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7040 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7050 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7060 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7070 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7080 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7090 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70d0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70e0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70f0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7100 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7110 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7120 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7130 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7140 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7150 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7160 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7170 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7180 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7190 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71d0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71e0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #71f0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7200 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7210 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7220 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7230 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7240 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7250 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7260 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7270 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7280 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7290 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72d0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72e0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #72f0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7300 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7310 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7320 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7330 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7340 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7350 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7360 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7370 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7380 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7390 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #73a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #73b0 ................


db #00,#00,#07,#11,#02,#1A,#04,#0F,#00,#00,#0D,#1A,#03,#17,#01,#0E ; #73c0 ................
db #00,#01,#0C,#18,#12,#15,#03,#06,#00,#00,#0E,#1A,#02,#18,#0C,#10 ; #73d0 ................
db #00,#01,#12,#1A,#09,#10,#18,#06,#00,#00,#04,#17,#0A,#16,#12,#09 ; #73e0 ................
db #00,#01,#08,#18,#12,#10,#06,#03,#00,#00,#0D,#1A,#02,#1A,#10,#18 ; #73f0 ................
db #00,#00,#0B,#17,#01,#16,#09,#12,#80,#00,#03,#12,#09,#1A,#10,#18 ; #7400 ................
db #00,#01,#05,#15,#12,#1A,#0C,#10,#00,#00,#06,#10,#03,#1A,#0A,#0D ; #7410 ................
db #00,#00,#04,#17,#0A,#16,#12,#09,#00,#01,#09,#18,#12,#10,#06,#03 ; #7420 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #7430 ................
db #00,#00,#03,#17,#0D,#18,#0A,#11,#00,#00,#0F,#03,#06,#01,#1A,#0D ; #7440 ................
db #00,#01,#09,#18,#06,#17,#00,#0B,#00,#00,#04,#10,#08,#17,#0E,#01 ; #7450 ................
db #00,#00,#18,#06,#10,#17,#04,#0E,#00,#00,#04,#08,#0C,#10,#14,#18 ; #7460 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #7470 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #7480 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #7490 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #74a0 ................
db #00,#03,#06,#09,#0C,#0F,#12,#15,#00,#03,#06,#09,#0C,#0F,#12,#15 ; #74b0 ................
db #00,#00,#00,#00,#00,#00,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01 ; #74c0 ................
db #02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#03,#03,#03,#03 ; #74d0 ................
db #03,#03,#03,#03,#03,#03,#03,#03,#03,#03,#03,#03,#04,#04,#04,#04 ; #74e0 ................
db #04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04 ; #74f0 ................
db #04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04,#04 ; #7500 ................
db #04,#04,#04,#04,#04,#03,#03,#03,#03,#03,#03,#03,#03,#03,#03,#03 ; #7510 ................
db #03,#03,#03,#03,#03,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02,#02 ; #7520 ................
db #02,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#00,#00,#00,#00,#00 ; #7530 ................
db #00,#00,#00,#00,#00,#00,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #7540 ................
db #FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FD,#FD,#FD,#FD ; #7550 ................
db #FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FC,#FC,#FC,#FC ; #7560 ................
db #FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC ; #7570 ................
db #FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC,#FC ; #7580 ................
db #FC,#FC,#FC,#FC,#FC,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD,#FD ; #7590 ................
db #FD,#FD,#FD,#FD,#FD,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE,#FE ; #75a0 ................
db #FE,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00 ; #75b0 ................
db #00,#00,#20,#00,#00,#00,#00,#00,#20,#00,#00,#00,#00,#00,#20,#00 ; #75c0 .. ..... ..... .
db #00,#00,#00,#10,#30,#00,#00,#00,#00,#10,#30,#00,#00,#00,#00,#10 ; #75d0 ....0.....0.....
db #30,#00,#00,#00,#00,#21,#31,#20,#00,#00,#00,#21,#31,#20,#00,#00 ; #75e0 0....!1 ...!1 ..
db #00,#21,#31,#20,#00,#00,#10,#03,#31,#32,#00,#00,#10,#03,#31,#32 ; #75f0 .!1 ....12....12
db #00,#00,#10,#03,#31,#32,#00,#00,#21,#03,#31,#33,#20,#00,#21,#03 ; #7600 ....12..!.13 .!.
db #31,#33,#20,#00,#30,#21,#31,#30,#20,#00,#00,#10,#30,#00,#00,#00 ; #7610 13 .0!10 ...0...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7620 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7630 ................
db #00,#00,#10,#00,#00,#00,#00,#00,#10,#00,#00,#00,#00,#00,#10,#00 ; #7640 ................
db #00,#00,#00,#00,#30,#20,#00,#00,#00,#00,#30,#20,#00,#00,#00,#00 ; #7650 ....0 ....0 ....
db #30,#20,#00,#00,#00,#10,#12,#32,#00,#00,#00,#10,#12,#32,#00,#00 ; #7660 0 .....2.....2..
db #00,#10,#12,#32,#00,#00,#00,#21,#12,#33,#20,#00,#00,#21,#12,#33 ; #7670 ...2...!.3 ..!.3
db #20,#00,#00,#21,#12,#33,#20,#00,#10,#03,#12,#33,#32,#00,#10,#03 ; #7680  ..!.3 ....32...
db #12,#33,#32,#00,#10,#30,#12,#32,#30,#00,#00,#00,#30,#20,#00,#00 ; #7690 .32..0.20...0 ..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #76a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #76b0 ................

db #64,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #76c0 d...............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #76d0 ................
db #00,#00,#00,#00,#00,#4C,#26,#0C,#0C,#19,#26,#0C,#0C,#19,#26,#0C ; #76e0 .....L&...&...&.
db #0C,#19,#33,#26,#0C,#0C,#19,#33,#4C,#00,#00,#00,#00,#00,#00,#4C ; #76f0 ..3&...3L......L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #7700 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #7710 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #7720 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #7730 ..3&...3L....1.L

db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #7740 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #7750 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #7760 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #7770 ..3&...3L....1.L
db #64,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30,#30 ; #7780 d000000000000000
db #30,#30,#30,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C,#0C ; #7790 000.............
db #0C,#0C,#0C,#0C,#0C,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #77a0 .....L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#0C,#0C,#0C,#0C,#0C,#0C,#4C ; #77b0 ..3&...3L......L

db #00,#10,#30,#00,#00,#00,#00,#20,#20,#20,#00,#00,#10,#10,#30,#10 ; #77c0 ..0....   ....0.
db #00,#00,#00,#30,#30,#20,#00,#00,#10,#10,#30,#10,#00,#00,#20,#30 ; #77d0 ...00 ....0... 0
db #30,#20,#20,#00,#10,#21,#31,#30,#00,#00,#20,#21,#31,#20,#20,#00 ; #77e0 0  ..!10.. !1  .
db #10,#21,#31,#30,#00,#00,#30,#03,#31,#32,#20,#00,#10,#03,#31,#32 ; #77f0 .!10..0.12 ...12
db #00,#00,#30,#03,#31,#32,#20,#00,#21,#03,#31,#33,#20,#00,#21,#03 ; #7800 ..0.12 .!.13 .!.
db #31,#33,#20,#00,#30,#21,#31,#30,#20,#00,#20,#30,#30,#20,#20,#00 ; #7810 13 .0!10 . 00  .
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7820 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7830 ................
db #00,#00,#30,#20,#00,#00,#00,#10,#10,#10,#00,#00,#00,#20,#30,#20 ; #7840 ..0 ......... 0 
db #20,#00,#00,#10,#30,#30,#00,#00,#00,#20,#30,#20,#20,#00,#10,#10 ; #7850  ...00... 0  ...
db #30,#30,#10,#00,#00,#30,#12,#32,#20,#00,#10,#10,#12,#32,#10,#00 ; #7860 00...0.2 ....2..
db #00,#30,#12,#32,#20,#00,#10,#21,#12,#33,#30,#00,#00,#21,#12,#33 ; #7870 .0.2 ..!.30..!.3
db #20,#00,#10,#21,#12,#33,#30,#00,#10,#03,#12,#33,#32,#00,#10,#03 ; #7880  ..!.30....32...
db #12,#33,#32,#00,#10,#30,#12,#32,#30,#00,#10,#10,#30,#30,#10,#00 ; #7890 .32..0.20...00..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #78a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #78b0 ................

db #11,#20,#11,#20,#32,#30,#32,#30,#30,#31,#30,#31,#10,#22,#10,#22 ; #78c0 . . 20200101."."
db #11,#22,#11,#22,#30,#30,#30,#30,#30,#30,#30,#30,#11,#22,#11,#22 ; #78d0 ."."00000000."."
db #10,#22,#10,#22,#30,#31,#30,#31,#32,#30,#32,#30,#11,#20,#11,#20 ; #78e0 ."."01012020. . 
db #10,#20,#10,#20,#32,#31,#32,#31,#32,#31,#32,#31,#10,#20,#10,#20 ; #78f0 . . 21212121. . 

db #10,#00,#31,#02,#31,#02,#31,#02,#01,#00,#01,#00,#11,#00,#11,#00 ; #7900 ..1.1.1.........
db #11,#00,#31,#02,#31,#02,#31,#02,#00,#00,#00,#00,#00,#00,#00,#00 ; #7910 ..1.1.1.........
db #20,#20,#22,#22,#02,#02,#20,#20,#22,#22,#02,#02,#20,#20,#22,#22 ; #7920   ""..  ""..  ""
db #02,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7930 ................
db #00,#00,#00,#00,#10,#20,#10,#20,#10,#20,#10,#20,#00,#00,#00,#00 ; #7940 ..... . . . ....
db #11,#22,#33,#33,#23,#13,#23,#13,#23,#13,#23,#13,#33,#33,#11,#22 ; #7950 ."33#.#.#.#.33."
db #01,#02,#03,#03,#13,#23,#13,#23,#13,#23,#13,#23,#03,#03,#01,#02 ; #7960 .....#.#.#.#....
db #10,#20,#30,#30,#20,#10,#20,#10,#20,#10,#20,#10,#30,#30,#10,#20 ; #7970 . 00 . . . .00. 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7980 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7990 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #79a0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #79b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #79c0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#22,#00,#00,#00,#00 ; #79d0 ..........."....
db #32,#31,#00,#00,#00,#11,#30,#31,#00,#00,#00,#11,#30,#30,#22,#00 ; #79e0 21....01....00".
db #00,#11,#30,#30,#22,#00,#00,#00,#32,#30,#22,#00,#00,#11,#30,#30 ; #79f0 ..00"...20"...00
db #22,#00,#00,#11,#30,#31,#00,#00,#00,#11,#30,#30,#22,#00,#00,#11 ; #7a00 "...01....00"...
db #30,#30,#22,#00,#00,#00,#32,#30,#22,#00,#00,#00,#32,#31,#00,#00 ; #7a10 00"...20"...21..
db #00,#00,#11,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7a20 ..."............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7a30 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#11,#22,#33 ; #7a40 .............."3
db #00,#00,#00,#32,#31,#30,#22,#00,#00,#32,#30,#30,#31,#00,#11,#30 ; #7a50 ...210"..2001..0
db #30,#30,#31,#00,#11,#30,#30,#30,#31,#00,#11,#30,#30,#30,#31,#00 ; #7a60 001..0001..0001.
db #00,#32,#30,#30,#22,#00,#00,#32,#30,#30,#22,#00,#00,#32,#30,#31 ; #7a70 .200"..200"..201
db #00,#00,#00,#11,#30,#30,#22,#00,#00,#11,#30,#30,#22,#00,#00,#11 ; #7a80 ....00"...00"...
db #30,#30,#31,#00,#00,#32,#30,#30,#31,#00,#00,#32,#30,#30,#31,#00 ; #7a90 001..2001..2001.
db #00,#11,#32,#30,#31,#00,#00,#00,#11,#32,#22,#00,#00,#00,#00,#11 ; #7aa0 ..201....2".....
db #22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7ab0 "...............
db #00,#00,#00,#00,#00,#00,#00,#11,#22,#11,#22,#00,#00,#32,#31,#32 ; #7ac0 ........"."..212
db #31,#00,#00,#32,#31,#30,#30,#22,#00,#32,#30,#30,#30,#22,#11,#30 ; #7ad0 1..2100".2000".0
db #30,#30,#30,#22,#11,#30,#30,#30,#30,#22,#11,#30,#30,#30,#30,#22 ; #7ae0 000".0000".0000"
db #11,#30,#30,#30,#31,#00,#11,#30,#30,#30,#31,#00,#11,#30,#30,#30 ; #7af0 .0001..0001..000
db #22,#00,#00,#32,#30,#30,#33,#00,#00,#32,#30,#30,#30,#22,#00,#32 ; #7b00 "..2003..2000".2
db #30,#30,#30,#22,#00,#33,#30,#30,#30,#22,#11,#30,#30,#30,#30,#22 ; #7b10 000".3000".0000"
db #11,#30,#32,#30,#30,#22,#11,#31,#32,#30,#31,#00,#00,#33,#11,#32 ; #7b20 .0200".1201..3.2
db #31,#00,#00,#00,#00,#11,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7b30 1.....".........
db #00,#00,#00,#00,#00,#00,#00,#11,#22,#11,#33,#00,#00,#32,#31,#32 ; #7b40 ........".3..212
db #30,#22,#11,#30,#31,#30,#30,#22,#11,#30,#30,#30,#30,#31,#11,#30 ; #7b50 0".0100".00001.0
db #30,#30,#30,#31,#32,#30,#30,#30,#30,#31,#32,#30,#30,#30,#30,#31 ; #7b60 0001200001200001
db #32,#30,#30,#30,#30,#22,#32,#30,#30,#30,#30,#22,#32,#30,#30,#30 ; #7b70 20000"20000"2000
db #31,#22,#11,#30,#30,#30,#32,#22,#11,#30,#30,#30,#30,#31,#11,#30 ; #7b80 1".0002".00001.0
db #30,#30,#30,#31,#32,#32,#30,#30,#30,#31,#32,#30,#30,#30,#30,#31 ; #7b90 0001220001200001
db #32,#31,#30,#30,#30,#31,#32,#20,#32,#30,#30,#22,#11,#30,#33,#32 ; #7ba0 2100012 200".032
db #30,#22,#00,#33,#00,#11,#33,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7bb0 0".3..3.........
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7bc0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7bd0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #7be0 ................
db #00,#00,#00,#70,#F0,#C2,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#4E,#63 ; #7bf0 ...p..s..s..c.Nc
db #00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00 ; #7c00 ..c..c..c..c..c.
db #C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6 ; #7c10 .c..c..c..c..c..
db #63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#F0,#C6,#73,#FF,#CE,#73 ; #7c20 c..c..c..c..s..s
db #FF,#CE,#43,#0F,#0E,#00,#00,#00,#00,#00,#00,#00,#20,#00,#00,#63 ; #7c30 ..C......... ..c
db #00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00 ; #7c40 ..c..c..c..c..c.
db #00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00 ; #7c50 .c..c..c..c..c..
db #63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63 ; #7c60 c..c..c..c..c..c
db #00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#02,#00,#00,#00,#00 ; #7c70 ..c..c..c.......
db #00,#00,#00,#30,#F0,#E0,#73,#FF,#CE,#73,#FF,#CE,#03,#0F,#4E,#00 ; #7c80 ...0..s..s....N.
db #00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#70,#F0 ; #7c90 ..............p.
db #C6,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#0E,#63,#00,#00,#63,#00,#00 ; #7ca0 .s..s..c..c..c..
db #63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#F0,#C0,#73,#FF,#CE,#73 ; #7cb0 c..c..c..c..s..s
db #FF,#CE,#43,#0F,#0C,#00,#00,#00,#00,#00,#00,#70,#F0,#C2,#73,#FF ; #7cc0 ..C........p..s.
db #CE,#73,#FF,#CE,#43,#0F,#4E,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6 ; #7cd0 .s..C.N.........
db #00,#00,#C6,#00,#00,#C6,#30,#F0,#C6,#31,#FF,#CE,#31,#FF,#CE,#03 ; #7ce0 ......0..1..1...
db #0F,#4E,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00 ; #7cf0 .N..............
db #C6,#70,#F0,#C6,#73,#FF,#CE,#73,#FF,#CE,#43,#0F,#0E,#00,#00,#00 ; #7d00 .p..s..s..C.....
db #00,#00,#00,#70,#00,#C2,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63 ; #7d10 ...p..c..c..c..c
db #00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#F0 ; #7d20 ..c..c..c..c..c.
db #C6,#73,#FF,#CE,#73,#FF,#CE,#43,#0F,#4E,#00,#00,#C6,#00,#00,#C6 ; #7d30 .s..s..C.N......
db #00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00 ; #7d40 ................
db #00,#C6,#00,#00,#86,#00,#00,#00,#00,#00,#00,#70,#F0,#C0,#73,#FF ; #7d50 ...........p..s.
db #CE,#73,#FF,#CE,#63,#0F,#0C,#63,#00,#00,#63,#00,#00,#63,#00,#00 ; #7d60 .s..c..c..c..c..
db #63,#00,#00,#63,#00,#00,#63,#F0,#E0,#73,#FF,#CE,#73,#FF,#CE,#43 ; #7d70 c..c..c..s..s..C
db #0F,#4E,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00 ; #7d80 .N..............
db #C6,#30,#F0,#C6,#73,#FF,#CE,#73,#FF,#CE,#03,#0F,#0E,#00,#00,#00 ; #7d90 .0..s..s........
db #00,#00,#00,#70,#F0,#C0,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#0C,#63 ; #7da0 ...p..s..s..c..c
db #00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#00,#00,#63,#F0 ; #7db0 ..c..c..c..c..c.
db #E0,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#4E,#63,#00,#C6,#63,#00,#C6 ; #7dc0 .s..s..c.Nc..c..
db #63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#F0,#C6,#73,#FF,#CE,#73 ; #7dd0 c..c..c..c..s..s
db #FF,#CE,#43,#0F,#0E,#00,#00,#00,#00,#00,#00,#70,#F0,#C2,#73,#FF ; #7de0 ..C........p..s.
db #CE,#73,#FF,#CE,#43,#0F,#4E,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6 ; #7df0 .s..C.N.........
db #00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00 ; #7e00 ................
db #00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00 ; #7e10 ................
db #C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#86,#00,#00,#00 ; #7e20 ................
db #00,#00,#00,#70,#F0,#C2,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#4E,#63 ; #7e30 ...p..s..s..c.Nc
db #00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#F0 ; #7e40 ..c..c..c..c..c.
db #C6,#73,#FF,#CE,#73,#FF,#CE,#63,#0F,#4E,#63,#00,#C6,#63,#00,#C6 ; #7e50 .s..s..c.Nc..c..
db #63,#00,#C6,#63,#00,#C6,#63,#00,#C6,#63,#F0,#C6,#73,#FF,#CE,#73 ; #7e60 c..c..c..c..s..s
db #FF,#CE,#43,#0F,#0E,#00,#00,#00,#00,#00,#00,#70,#F0,#C2,#73,#FF ; #7e70 ..C........p..s.
db #CE,#73,#FF,#CE,#63,#0F,#4E,#63,#00,#C6,#63,#00,#C6,#63,#00,#C6 ; #7e80 .s..c.Nc..c..c..
db #63,#00,#C6,#63,#00,#C6,#63,#F0,#C6,#73,#FF,#CE,#73,#FF,#CE,#43 ; #7e90 c..c..c..s..s..C
db #0F,#4E,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00,#C6,#00,#00 ; #7ea0 .N..............
db #C6,#30,#F0,#C6,#73,#FF,#CE,#73,#FF,#CE,#03,#0F,#0E,#00,#00,#00 ; #7eb0 .0..s..s........
db #64,#10,#30,#30,#30,#30,#02,#10,#30,#30,#30,#30,#02,#10,#30,#30 ; #7ec0 d.0000..0000..00
db #30,#30,#02,#10,#30,#30,#30,#30,#02,#10,#30,#30,#30,#30,#02,#10 ; #7ed0 00..0000..0000..
db #30,#30,#30,#30,#02,#4C,#26,#CC,#CC,#19,#26,#CC,#CC,#19,#26,#CC ; #7ee0 0000.L&...&...&.
db #CC,#19,#33,#26,#C0,#C0,#19,#33,#4C,#10,#30,#30,#30,#30,#02,#4C ; #7ef0 ..3&...3L.0000.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #7f00 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #7f10 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #7f20 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #7f30 ..3&...3L....1.L
db #64,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00 ; #7f40 d.#..1..#..1..#.
db #00,#31,#02,#10,#23,#00,#00,#31,#02,#10,#23,#00,#00,#31,#02,#10 ; #7f50 .1..#..1..#..1..
db #23,#00,#00,#31,#02,#4C,#26,#CC,#CC,#08,#26,#CC,#CC,#08,#26,#CC ; #7f60 #..1.L&...&...&.
db #CC,#08,#33,#26,#C0,#C0,#08,#33,#4C,#00,#00,#00,#00,#31,#02,#4C ; #7f70 ..3&...3L....1.L
db #33,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #7f80 3...............
db #CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #7f90 ................
db #CC,#CC,#CC,#CC,#CC,#99,#26,#0C,#0C,#08,#26,#0C,#0C,#08,#26,#0C ; #7fa0 ......&...&...&.
db #0C,#08,#33,#26,#0C,#0C,#08,#33,#4C,#CC,#CC,#CC,#CC,#CC,#CC,#CC ; #7fb0 ..3&...3L.......



/*
;9000

db #C3,#18,#9E,#05,#07,#00,#00,#00,#00,#00,#05,#00,#00,#00,#00,#09 ; #8fc0 ................
db #00,#01,#00,#00,#00,#C5,#E5,#1A,#E6,#CC,#4F,#7E,#E6,#33,#B1,#77 ; #8fd0 ..........O~.3.w
db #2C,#1A,#87,#87,#E6,#CC,#4F,#7E,#E6,#33,#B1,#77,#1C,#2C,#10,#E7 ; #8fe0 ,.....O~.3.w.,..
db #E1,#01,#00,#08,#09,#30,#06,#01,#40,#C0,#09,#CB,#9C,#C1,#0D,#20 ; #8ff0 .....0..@...... 
db #D4,#C9,#00,#21,#7F,#00,#22,#C9,#90,#11,#F3,#A3,#ED,#53,#D6,#90 ; #9000 ...!.."......S..
db #AF,#32,#CD,#90,#3A,#39,#00,#FE,#39,#28,#0F,#21,#D0,#90,#0E,#00 ; #9010 .2..:9..9(.!....
db #06,#C1,#CD,#19,#BD,#CD,#E0,#BC,#18,#06,#CD,#19,#BD,#CD,#C6,#A3 ; #9020 ................
db #CD,#0B,#BC,#22,#CB,#90,#21,#D9,#90,#0E,#FF,#06,#80,#11,#17,#91 ; #9030 ..."..!.........
db #CD,#D7,#BC,#CD,#9F,#94,#CD,#97,#94,#3E,#02,#32,#E5,#90,#3E,#06 ; #9040 .........>.2..>.
db #32,#EE,#90,#3E,#03,#32,#C1,#90,#3E,#02,#32,#F4,#90,#2E,#64,#26 ; #9050 2..>.2..>.2...d&
db #7C,#22,#E2,#90,#AF,#32,#C2,#90,#32,#C3,#90,#32,#E4,#90,#32,#EB ; #9060 |"...2..2..2..2.
db #90,#21,#FF,#FF,#22,#C4,#90,#CD,#EA,#95,#CD,#88,#95,#CD,#51,#94 ; #9070 .!..".........Q.
db #C9,#03,#00,#00,#FF,#FF,#80,#00,#00,#10,#00,#00,#C0,#01,#01,#01 ; #9080 ................
db #00,#00,#00,#00,#00,#C1,#08,#A5,#00,#00,#00,#00,#00,#00,#80,#17 ; #9090 ................
db #91,#FF,#64,#7C,#00,#02,#00,#00,#00,#00,#7C,#00,#00,#00,#06,#00 ; #90a0 ..d|......|.....
db #00,#00,#00,#00,#02,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #90b0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #90c0 ................
db #00,#00,#00,#00,#00,#00,#00,#CD,#67,#A4,#3A,#C6,#90,#A7,#C0,#3A ; #90d0 ........g.:....:
db #E4,#90,#A7,#28,#2C,#F2,#51,#91,#CB,#77,#20,#03,#3D,#18,#07,#3C ; #90e0 ...(,.Q..w .=..<
db #FE,#87,#20,#02,#E6,#BF,#32,#E4,#90,#CB,#3F,#E6,#06,#EE,#06,#CB ; #90f0 .. ...2...?.....
db #3F,#2E,#00,#CB,#3F,#CB,#1D,#C6,#7A,#67,#ED,#4B,#E2,#90,#C3,#1F ; #9100 ?...?...zg.K....
db #92,#3A,#E7,#90,#5F,#CD,#26,#9A,#E6,#10,#32,#E7,#90,#BB,#28,#1D ; #9110 .:.._.&...2...(.
db #38,#1B,#3A,#F1,#90,#A7,#20,#15,#ED,#4B,#E2,#90,#79,#D6,#10,#4F ; #9120 8.:... ..K..y..O
db #78,#C6,#06,#47,#ED,#43,#EF,#90,#3E,#63,#32,#F1,#90,#3A,#E8,#90 ; #9130 x..G.C..>c2..:..
db #A7,#20,#04,#CB,#64,#28,#23,#3A,#EB,#90,#A7,#20,#1D,#ED,#4B,#E2 ; #9140 . ..d(#:... ..K.
db #90,#79,#D6,#10,#4F,#78,#C6,#06,#47,#ED,#43,#E9,#90,#3E,#FF,#32 ; #9150 .y..Ox..G.C..>.2
db #EB,#90,#E5,#21,#08,#95,#CD,#89,#94,#E1,#AF,#32,#E6,#90,#3A,#E5 ; #9160 ...!.......2..:.
db #90,#6F,#ED,#4B,#E2,#90,#59,#50,#CB,#44,#28,#0B,#7B,#FE,#21,#38 ; #9170 .o.K..YP.D(.{.!8
db #17,#79,#95,#4F,#7B,#95,#5F,#CB,#4C,#28,#0D,#7B,#FE,#CB,#30,#08 ; #9180 .y.O{._.L(.{..0.
db #3E,#E8,#32,#E6,#90,#7B,#85,#5F,#CB,#54,#28,#0B,#7A,#E6,#FC,#28 ; #9190 >.2..{._.T(.z..(
db #06,#78,#95,#47,#7A,#95,#57,#CB,#5C,#28,#0F,#7A,#FE,#E8,#30,#0A ; #91a0 .x.Gz.W.\(.z..0.
db #3A,#E6,#90,#3D,#32,#E6,#90,#7A,#85,#57,#ED,#53,#E2,#90,#3A,#E6 ; #91b0 :..=2..z.W.S..:.
db #90,#6F,#78,#E6,#02,#0F,#0F,#AD,#6F,#26,#76,#3A,#C3,#90,#A7,#28 ; #91c0 .ox.....o&v:...(
db #0E,#FE,#FF,#28,#04,#3D,#32,#C3,#90,#E6,#04,#28,#02,#24,#24,#5D ; #91d0 ...(.=2....(.$$]
db #54,#CD,#DA,#9C,#06,#15,#CD,#7A,#9F,#2A,#EC,#90,#7C,#FE,#C0,#38 ; #91e0 T......z.*..|..8
db #09,#06,#0C,#CD,#F2,#9D,#AF,#32,#ED,#90,#3A,#EB,#90,#A7,#28,#20 ; #91f0 .......2..:...( 
db #ED,#4B,#E9,#90,#CD,#DA,#9C,#22,#EC,#90,#11,#60,#79,#06,#0C,#CD ; #9200 .K....."...`y...
db #11,#9C,#3A,#EE,#90,#47,#3A,#E9,#90,#90,#32,#E9,#90,#DC,#9F,#92 ; #9210 ..:..G:...2.....
db #2A,#F2,#90,#7C,#FE,#C0,#38,#09,#06,#0C,#CD,#F2,#9D,#AF,#32,#F3 ; #9220 *..|..8.......2.
db #90,#3A,#F1,#90,#A7,#28,#78,#3D,#32,#F1,#90,#ED,#4B,#EF,#90,#CD ; #9230 .:...(x=2...K...
db #DA,#9C,#22,#F2,#90,#11,#40,#79,#06,#0C,#CD,#11,#9C,#3A,#F4,#90 ; #9240 .."...@y.....:..
db #47,#3A,#EF,#90,#90,#32,#EF,#90,#30,#0A,#AF,#32,#F1,#90,#C9,#AF ; #9250 G:...2..0..2....
db #32,#EB,#90,#C9,#2A,#EF,#90,#7D,#C6,#10,#6F,#CD,#B8,#9C,#30,#3F ; #9260 2...*..}..o...0?
db #F2,#EF,#92,#5F,#E6,#3F,#FE,#3F,#20,#04,#3E,#F4,#18,#0D,#FE,#39 ; #9270 ..._.?.? .>....9
db #20,#0C,#ED,#5F,#E6,#02,#ED,#44,#83,#E6,#3F,#77,#18,#0C,#FE,#37 ; #9280  .._...D..?w...7
db #77,#30,#07,#36,#20,#CB,#73,#28,#01,#73,#11,#03,#90,#CD,#B5,#95 ; #9290 w0.6 .s(.s......
db #2A,#B6,#9C,#CD,#2A,#9D,#21,#FF,#94,#CD,#89,#94,#C3,#9A,#92,#3A ; #92a0 *...*.!........:
db #E4,#90,#E6,#80,#C0,#2A,#E2,#90,#11,#0A,#0A,#19,#CD,#B8,#9C,#D0 ; #92b0 .....*..........
db #F8,#FE,#37,#D8,#FE,#38,#C8,#36,#38,#FE,#37,#20,#14,#3A,#C5,#90 ; #92c0 ..7..8.68.7 .:..
db #C6,#80,#32,#C5,#90,#D2,#08,#94,#21,#FF,#FF,#22,#C4,#90,#C3,#08 ; #92d0 ..2.....!.."....
db #94,#FE,#39,#20,#3C,#06,#03,#ED,#5F,#E6,#7F,#FE,#28,#30,#11,#3A ; #92e0 ..9 <..._...(0.:
db #F4,#90,#D6,#02,#20,#38,#10,#0C,#C3,#08,#94,#10,#F2,#C3,#08,#94 ; #92f0 .... 8..........
db #FE,#50,#30,#0C,#3A,#E5,#90,#3D,#FE,#02,#30,#42,#05,#CA,#08,#94 ; #9300 .P0.:..=..0B....
db #3A,#EE,#90,#FE,#06,#28,#E4,#D6,#03,#FE,#06,#30,#53,#3E,#06,#18 ; #9310 :....(.....0S>..
db #4F,#FE,#3A,#20,#1D,#3A,#F4,#90,#C6,#02,#FE,#07,#30,#5F,#CD,#74 ; #9320 O.: .:......0_.t
db #93,#C3,#ED,#93,#32,#F4,#90,#D6,#02,#6F,#87,#85,#21,#27,#7F,#C3 ; #9330 ....2....o..!''..
db #21,#94,#FE,#3B,#20,#1D,#3A,#E5,#90,#3C,#FE,#05,#30,#3F,#CD,#94 ; #9340 !..; .:..<..0?..
db #93,#C3,#ED,#93,#32,#E5,#90,#D6,#02,#6F,#87,#85,#87,#21,#2F,#7F ; #9350 ....2....o...!/.
db #C3,#21,#94,#FE,#3C,#20,#1B,#3A,#EE,#90,#C6,#03,#FE,#0D,#30,#1D ; #9360 .!..< .:......0.
db #CD,#B6,#93,#C3,#ED,#93,#32,#EE,#90,#D6,#06,#87,#21,#2B,#7F,#C3 ; #9370 ......2.....!+..
db #21,#94,#FE,#3D,#20,#42,#3E,#FF,#32,#C3,#90,#18,#3B,#3A,#C2,#90 ; #9380 !..= B>.2...;:..
db #3C,#FE,#0C,#32,#C2,#90,#38,#15,#AF,#32,#C2,#90,#3A,#C1,#90,#3C ; #9390 <..2..8..2..:..<
db #FE,#0A,#30,#09,#32,#C1,#90,#CD,#88,#95,#CD,#2C,#95,#11,#0F,#90 ; #93a0 ..0.2......,....
db #CD,#B5,#95,#3A,#C5,#90,#C6,#40,#32,#C5,#90,#30,#05,#3E,#FF,#32 ; #93b0 ...:...@2..0.>.2
db #C5,#90,#3A,#C5,#90,#CD,#0F,#94,#2A,#B6,#9C,#CD,#2A,#9D,#C9,#CB ; #93c0 ..:.....*...*...
db #3F,#CB,#3F,#CB,#3F,#FE,#18,#38,#02,#3E,#18,#21,#34,#7F,#C3,#22 ; #93d0 ?.?.?..8.>.!4.."
db #94,#87,#4F,#3E,#18,#91,#11,#FF,#07,#28,#0B,#47,#3E,#CC,#77,#23 ; #93e0 ..O>.....(.G>.w#
db #77,#CD,#45,#94,#10,#F8,#41,#79,#A7,#C8,#3E,#C0,#77,#23,#77,#CD ; #93f0 w.E...Ay..>.w#w.
db #45,#94,#10,#F8,#C9,#A7,#ED,#5A,#F0,#11,#40,#C0,#19,#11,#FF,#07 ; #9400 E......Z..@.....
db #C9,#AF,#21,#27,#7F,#CD,#21,#94,#AF,#21,#2B,#7F,#CD,#21,#94,#AF ; #9410 ..!''..!..!+..!..
db #21,#2F,#7F,#CD,#21,#94,#3E,#0C,#21,#34,#7F,#18,#B4,#3A,#E5,#90 ; #9420 !/..!.>.!4...:..
db #3D,#FE,#01,#C4,#94,#93,#3A,#EE,#90,#D6,#03,#FE,#06,#D4,#B6,#93 ; #9430 =.....:.........
db #3A,#F4,#90,#D6,#02,#C2,#74,#93,#C9,#F5,#C5,#D5,#DD,#E5,#CD,#AA ; #9440 :.....t.........
db #BC,#DD,#E1,#D1,#C1,#F1,#C9,#11,#BF,#BC,#21,#E3,#94,#18,#06,#11 ; #9450 ..........!.....
db #BC,#BC,#21,#C3,#94,#ED,#53,#B4,#94,#06,#01,#7E,#E6,#7F,#C8,#4F ; #9460 ..!...S....~...O
db #78,#C5,#E5,#CD,#BF,#BC,#E1,#C1,#04,#79,#81,#81,#3C,#5F,#16,#00 ; #9470 x........y..<_..
db #19,#18,#E8

; Data audio
db #03,#00,#0F,#01,#03,#FF,#05,#04,#FD,#0A,#03,#00,#04 ; #9480 ................
db #01,#04,#02,#01,#0C,#FF,#03,#01,#0F,#FF,#0A,#02,#00,#0F,#01,#07 ; #9490 ................
db #FE,#01,#00,#81,#01,#20,#01,#85,#F0,#32,#05,#F0,#29,#05,#F0,#1C ; #94a0 ..... ...2..)...
db #03,#F0,#34,#04,#08,#FC,#01,#82,#07,#0A,#01,#00,#AC,#01,#00


;94ff
db #81,#01,#01,#80,#00,#1F,#00,#00,#00
;9508 : Son
db #82,#02,#01,#14,#00,#00,#00,#00,#00
db #84,#03,#02,#00,#00,#00,#0F,#00,#00
db #81,#04,#00,#00,#00,#0C,#00,#00,#00
db #84,#03,#03,#64,#00,#00,#0F,#00,#00

db #21,#11,#95,#C3 
db #89,#94,#21,#23,#95,#C3,#89,#94,#21,#1A,#95,#ED,#5F,#E6,#0F,#C6 ; #94f0 ..!#....!..._...
db #0C,#32,#1F,#95,#C3,#89,#94,#C9,#C5,#E5,#1A,#0F,#0F,#E6,#33,#77 ; #9500 .2............3w
db #2C,#1A,#E6,#33,#77,#2C,#13,#10,#F1,#E1,#01,#00,#08,#09,#CB,#74 ; #9510 ,..3w,.........t
db #20,#04,#01,#40,#C0,#09,#C1,#0D,#20,#DE,#C9,#E5,#11,#30,#7C,#6F ; #9520  ..@.... ....0|o
db #26,#00,#87,#87,#87,#85,#87,#6F,#29,#29,#19,#EB,#E1,#01,#18,#03 ; #9530 &......o))......
db #18,#C6,#80,#80,#80,#80,#80,#80,#3A,#C1,#90,#21,#39,#77,#18,#DB ; #9540 ........:..!9w..
db #00,#3A,#90,#95,#DE,#01,#30,#02,#3E,#05,#32,#90,#95,#4F,#21,#87 ; #9550 .:....0.>.2..O!.
db #95,#06,#00,#A7,#ED,#42,#7E,#A7,#F8,#CB,#FE,#21,#01,#77,#CB,#21 ; #9560 .....B~....!.w.!
db #09,#09,#09,#18,#B6,#21,#82,#95,#3A,#86,#95,#F5,#AF,#06,#06,#1A ; #9570 .....!..:.......
db #8E,#27,#4F,#E6,#0F,#77,#79,#E6,#1F,#C6,#F0,#23,#13,#10,#F0,#3A ; #9580 .''O..wy....#...:
db #86,#95,#E6,#0F,#4F,#F1,#E6,#0F,#B9,#C8,#3A,#C1,#90,#3C,#FE,#0A ; #9590 ....O.....:..<..
db #D0,#32,#C1,#90,#CD,#2C,#95,#C3,#88,#95,#21,#00,#00,#22,#82,#95 ; #95a0 .2...,....!.."..
db #22,#84,#95,#22,#86,#95,#CD,#FC,#95,#CD,#FC,#95,#CD,#91,#95,#CD ; #95b0 ".."............
db #91,#95,#C9,#00,#87,#87,#87,#21,#03,#96,#86,#4F,#06,#00,#DD,#21 ; #95c0 .......!...O...!
db #00,#01,#DD,#09,#DD,#46,#01,#48,#C5,#CD,#38,#BC,#C1,#AF,#CD,#32 ; #95d0 .....F.H..8....2
db #BC,#DD,#CB,#00,#7E,#20,#07,#CD,#5C,#96,#CD,#40,#96,#C9,#DD,#23 ; #95e0 ....~ ..\..@...#
db #DD,#23,#DD,#23,#CD,#40,#96,#01,#FA,#FF,#DD,#09,#CD,#5C,#96,#C9 ; #95f0 .#.#.@.......\..
db #3E,#04,#0E,#03,#06,#04,#C5,#F5,#DD,#46,#02,#48,#CD,#32,#BC,#F1 ; #9600 >........F.H.2..
db #3C,#C1,#10,#F2,#DD,#23,#06,#04,#0D,#20,#EB,#C9,#3E,#01,#0E,#03 ; #9610 <....#... ..>...
db #06,#04,#F5,#C5,#F5,#DD,#46,#02,#48,#CD,#32,#BC,#F1,#C6,#04,#C1 ; #9620 ......F.H.2.....
db #10,#F1,#DD,#23,#F1,#3C,#06,#04,#0D,#20,#E7,#C9,#3A,#03,#96,#C6 ; #9630 ...#.<... ..:...
db #80,#32,#03,#96,#3A,#14,#9E,#CD,#04,#96,#AF,#C9,#CD,#F6,#95,#21 ; #9640 .2..:..........!
db #77,#99,#11,#87,#95,#06,#06,#1A,#E6,#0F,#4F,#7E,#E6,#0F,#B9,#38 ; #9650 w.........O~...8
db #06,#C0,#2B,#1B,#10,#F1,#C9,#CD,#47,#95,#21,#82,#95,#11,#72,#99 ; #9660 ..+.....G.!...r.
db #06,#06,#7E,#E6,#0F,#12,#23,#13,#10,#F8,#21,#58,#98,#C3,#F8,#96 ; #9670 ..~...#...!X....
db #2A,#C7,#90,#E5,#21,#00,#00,#76,#22,#C7,#90,#21,#C6,#90,#34,#CD ; #9680 *...!..v"..!..4.
db #1B,#BB,#30,#FB,#F6,#20,#FE,#70,#28,#F5,#CD,#0C,#BB,#21,#C6,#90 ; #9690 ..0.. .p(....!..
db #35,#AF,#E1,#22,#C7,#90,#C9,#CD,#26,#9A,#E6,#10,#76,#20,#F8,#CD ; #96a0 5.."....&...v ..
db #26,#9A,#E6,#10,#C0,#76,#18,#F7,#7E,#FE,#FF,#C8,#CD,#5A,#BB,#23 ; #96b0 &....v..~....Z.#
db #18,#F6,#FE,#0A,#38,#09,#F5,#3E,#31,#CD,#5A,#BB,#F1,#D6,#0A,#C6 ; #96c0 ....8..>1.Z.....
db #30,#CD,#5A,#BB,#C9,#1F,#04,#15,#0F,#02,#50,#52,#45,#53,#53,#20 ; #96d0 0.Z.......PRESS 
db #46,#49,#52,#45,#0F,#03,#FF,#1F,#01,#0A,#0F,#02,#4C,#45,#56,#45 ; #96e0 FIRE........LEVE
db #4C,#3A,#FF,#1F,#0D,#0A,#0F,#04,#FF,#1F,#07,#08,#0F,#04,#57,#45 ; #96f0 L:............WE
db #4C,#4C,#20,#44,#4F,#4E,#45,#21,#21,#FF,#AF,#CD,#CB,#9D,#3E,#03 ; #9700 LL DONE!!.....>.
db #CD,#04,#96,#CD,#8C,#96,#CD,#A0,#99,#01,#1E,#20,#11,#00,#43,#CD ; #9710 ........... ..C.
db #FE,#99,#01,#1E,#C0,#11,#80,#5E,#CD,#FE,#99,#01,#4E,#20,#11,#00 ; #9720 .......^....N ..
db #5D,#CD,#FE,#99,#01,#4E,#C0,#11,#80,#5D,#CD,#FE,#99,#01,#7E,#20 ; #9730 ]....N...]....~ 
db #11,#00,#5E,#CD,#FE,#99,#01,#7E,#C0,#11,#80,#5C,#CD,#FE,#99,#CD ; #9740 ..^....~...\....
db #78,#99,#21,#F0,#97,#CD,#F8,#96,#CD,#29,#9F,#CD,#06,#BB,#F6,#20 ; #9750 x.!......)..... 
db #FE,#78,#C8,#FE,#36,#C8,#FE,#71,#CC,#D1,#97,#FE,#63,#CC,#7C,#96 ; #9760 .x..6..q....c.|.
db #FE,#6A,#20,#0D,#3E,#80,#32,#62,#9A,#21,#82,#98,#CD,#F8,#96,#18 ; #9770 .j .>.2b.!......
db #DA,#FE,#6B,#20,#0A,#AF,#32,#62,#9A,#21,#6D,#98,#CD,#F8,#96,#18 ; #9780 ..k ..2b.!m.....
db #CA,#CD,#06,#BB,#FE,#45,#C0,#CD,#06,#BB,#FE,#44,#C0,#CD,#06,#BB ; #9790 .....E.....D....
db #D6,#30,#C8,#D8,#FE,#0A,#D0,#32,#15,#9E,#3E,#07,#CD,#5A,#BB,#C9 ; #97a0 .0.....2..>..Z..
db #1F,#09,#07,#0E,#00,#0F,#04,#20,#53,#49,#4C,#4F,#20,#20,#20,#20 ; #97b0 ....... SILO    
db #20,#53,#48,#45,#49,#4C,#44,#1F,#05,#0C,#4D,#49,#53,#53,#49,#4C ; #97c0  SHEILD...MISSIL
db #45,#20,#20,#53,#50,#45,#45,#44,#55,#50,#1F,#01,#11,#20,#4C,#41 ; #97d0 E  SPEEDUP... LA
db #53,#45,#52,#20,#20,#20,#20,#20,#48,#4F,#4C,#45,#20,#1F,#0F,#16 ; #97e0 SER     HOLE ...
db #0E,#08,#0F,#0C,#46,#49,#52,#45,#20,#74,#6F,#20,#70,#6C,#61,#79 ; #97f0 ....FIRE to play
db #1F,#06,#14,#0E,#00,#0F,#04,#46,#49,#52,#45,#42,#49,#52,#44,#20 ; #9800 .......FIREBIRD 
db #20,#31,#39,#38,#37,#0F,#01,#FF,#1F,#0B,#13,#0F,#07,#1C,#07,#00 ; #9810  1987...........
db #18,#4E,#45,#57,#20,#48,#49,#53,#43,#4F,#52,#45,#FF,#1F,#0B,#13 ; #9820 .NEW HISCORE....
db #0F,#07,#1C,#07,#00,#17,#20,#20,#4B,#45,#59,#42,#4F,#41,#52,#44 ; #9830 ......  KEYBOARD
db #20,#FF,#1F,#0B,#13,#0F,#07,#1C,#07,#01,#18,#20,#20,#4A,#4F,#59 ; #9840  ..........  JOY
db #53,#54,#49,#43,#4B,#20,#FF,#1F,#01,#01,#0F,#03,#0E,#01,#20,#20 ; #9850 STICK ........  
db #20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#5A,#54 ; #9860               ZT
db #42,#20,#62,#79,#20,#44,#72,#69,#6E,#6B,#73,#6F,#66,#74,#FF,#0F ; #9870 B by Drinksoft..
db #00,#20,#A4,#20,#50,#61,#75,#6C,#20,#53,#68,#69,#72,#6C,#65,#79 ; #9880 . . Paul Shirley
db #20,#0E,#00,#FF,#1F,#01,#01,#0F,#03,#0E,#00,#20,#20,#20,#20,#20 ; #9890  ..........     
db #20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#51,#45,#44,#31,#2D ; #98a0            QED1-
db #39,#20,#74,#6F,#20,#63,#68,#65,#61,#74,#21,#FF,#1F,#01,#01,#0F ; #98b0 9 to cheat!.....
db #02,#0E,#00,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20 ; #98c0 ...             
db #20,#20,#20,#49,#27,#6D,#20,#52,#45,#41,#4C,#4C,#59,#20,#42,#6F ; #98d0    I''m REALLY Bo
db #72,#65,#64,#FF,#1F,#01,#01,#0F,#03,#0E,#01,#20,#20,#20,#20,#20 ; #98e0 red........     
db #20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#4D,#49,#53,#53,#49 ; #98f0            MISSI
db #4F,#4E,#20,#47,#45,#4E,#4F,#43,#49,#44,#45,#FF,#1F,#01,#15,#0E ; #9900 ON GENOCIDE.....
db #04,#0F,#08,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20,#20 ; #9910 ...             
db #20,#20,#20,#20,#48,#49,#53,#43,#4F,#52,#45,#3A,#FF,#0E,#00,#0F ; #9920     HISCORE:....
db #01,#FF,#00,#00,#00,#00,#00,#00,#21,#4C,#99,#CD,#F8,#96,#21,#77 ; #9930 ........!L....!w
db #99,#06,#06,#7E,#CD,#0F,#97,#2B,#10,#F9,#3E,#20,#CD,#5A,#BB,#21 ; #9940 ...~...+..> .Z.!
db #6D,#99,#CD,#F8,#96,#06,#07,#11,#40,#CE,#21,#80,#C6,#18,#33,#01 ; #9950 m.......@.!...3.
db #21,#9F,#99,#7E,#34,#E6,#3F,#FE,#28,#21,#D4,#98,#28,#13,#E6,#07 ; #9960 !..~4.?.(!..(...
db #FE,#07,#21,#FC,#98,#28,#0A,#E6,#01,#21,#24,#99,#28,#03,#21,#97 ; #9970 ..!..(...!$.(.!.
db #98,#CD,#F8,#96,#21,#BF,#98,#CD,#F8,#96,#06,#07,#21,#40,#C0,#11 ; #9980 ....!.......!@..
db #00,#C8,#C5,#E5,#D5,#01,#40,#00,#ED,#B0,#E1,#CD,#F4,#99,#EB,#E1 ; #9990 ......@.........
db #E5,#D5,#01,#40,#00,#ED,#B0,#E1,#CD,#F4,#99,#EB,#E1,#CD,#F4,#99 ; #99a0 ...@............
db #C1,#10,#DF,#C9,#01,#00,#08,#09,#D0,#01,#40,#C0,#09,#C9,#CD,#DF ; #99b0 ..........@.....
db #9C,#01,#20,#04,#C3,#15,#90,#2A,#C4,#90,#7C,#ED,#5B,#16,#9E,#A7 ; #99c0 .. ....*..|.[...
db #ED,#52,#30,#07,#CD,#6D,#94,#21,#00,#C0,#AF,#AC,#22,#C4,#90,#E6 ; #99d0 .R0..m.!...."...
db #0F,#C8,#7C,#C3,#0F,#94,#3A,#62,#9A,#A7,#C2,#24,#BB,#C5,#06,#00 ; #99e0 ..|...:b...$....
db #3E,#04,#CD,#1E,#BB,#28,#02,#06,#30,#3E,#43,#CD,#1E,#BB,#28,#02 ; #99f0 >....(..0>C...(.
db #CB,#C0,#3E,#3C,#CD,#1E,#BB,#28,#02,#CB,#C8,#3E,#14,#CD,#1E,#BB ; #9a00 ..><...(...>....
db #28,#02,#CB,#D0,#3E,#0C,#CD,#1E,#BB,#28,#02,#CB,#D8,#78,#68,#60 ; #9a10 (...>....(...xh`
db #C1,#C9,#80,#21,#33,#97,#CD,#F8,#96,#21,#00,#88,#01,#00,#0A,#3A ; #9a20 ...!3....!.....:
db #14,#9E,#A7,#28,#09,#5F,#3E,#FF,#ED,#B1,#E0,#1D,#20,#FA,#C3,#F8 ; #9a30 ...(._>..... ...
db #96,#21,#00,#85,#AF,#47,#77,#23,#10,#FC,#3E,#06,#32,#60,#A0,#3E ; #9a40 .!...Gw#..>.2`.>
db #10,#32,#97,#9A,#C3,#33,#9C,#10,#DD,#21,#00,#85,#06,#10,#3A,#C3 ; #9a50 .2...3...!....:.
db #9A,#EE,#01,#32,#C3,#9A,#C5,#DD,#7E,#03,#A7,#C4,#C4,#9A,#01,#08 ; #9a60 ...2....~.......
db #00,#DD,#09,#C1,#10,#F0,#3A,#C1,#9A,#C6,#10,#E6,#30,#32,#C1,#9A ; #9a70 ......:.....02..
db #C9,#00,#79,#00,#F2,#0E,#9B,#DD,#36,#04,#03,#DD,#36,#05,#02,#3A ; #9a80 ..y.....6...6..:
db #E3,#90,#C6,#0C,#DD,#96,#00,#28,#0A,#30,#0C,#ED,#44,#DD,#36,#04 ; #9a90 .......(.0..D.6.
db #FD,#18,#04,#DD,#36,#04,#00,#47,#3A,#CE,#90,#DD,#96,#01,#4F,#3A ; #9aa0 ....6..G:.....O:
db #E2,#90,#81,#28,#0A,#38,#0C,#ED,#44,#DD,#36,#05,#FC,#18,#04,#DD ; #9ab0 ...(.8..D.6.....
db #36,#05,#FF,#80,#38,#08,#FE,#30,#30,#04,#DD,#CB,#03,#BE,#DD,#CB ; #9ac0 6...8..00.......
db #03,#66,#20,#12,#3A,#C3,#9A,#A7,#20,#0C,#DD,#6E,#06,#DD,#66,#07 ; #9ad0 .f .:... ..n..f.
db #7C,#D6,#C0,#D8,#18,#4A,#DD,#6E,#06,#DD,#66,#07,#7C,#D6,#C0,#38 ; #9ae0 |....J.n..f.|..8
db #03,#CD,#F0,#9D,#DD,#7E,#00,#DD,#86,#04,#FE,#F8,#30,#44,#47,#DD ; #9af0 .....~......0DG.
db #77,#00,#DD,#7E,#01,#DD,#86,#05,#4F,#DD,#77,#01,#3A,#CE,#90,#91 ; #9b00 w..~....O.w.:...
db #ED,#44,#FE,#F1,#30,#2C,#57,#3A,#E3,#90,#90,#FE,#EC,#38,#08,#3A ; #9b10 .D..0,W:.....8.:
db #E2,#90,#92,#FE,#EC,#30,#18,#CD,#DF,#9C,#DD,#75,#06,#DD,#74,#07 ; #9b20 .....0.....u..t.
db #ED,#5B,#C1,#9A,#DD,#7E,#03,#E6,#80,#B3,#5F,#CD,#0F,#9C,#C9,#CD ; #9b30 .[...~...._.....
db #AD,#A0,#DD,#36,#03,#00,#DD,#36,#07,#00,#C9,#FD,#21,#00,#85,#DD ; #9b40 ...6...6....!...
db #21,#EF,#9B,#DD,#77,#02,#A7,#3A,#EE,#9B,#CB,#F7,#20,#05,#CB,#FF ; #9b50 !...w..:.... ...
db #DD,#34,#02,#32,#EE,#9B,#22,#EF,#9B,#11,#FF,#9B,#DD,#36,#03,#10 ; #9b60 .4.2.."......6..
db #01,#08,#00,#DD,#CB,#02,#3E,#38,#05,#C8,#13,#13,#18,#F5,#FD,#7E ; #9b70 ......>8.......~
db #03,#A7,#28,#08,#FD,#09,#DD,#35,#03,#20,#F3,#C9,#1A,#FD,#77,#04 ; #9b80 ..(....5. ....w.
db #13,#1A,#FD,#77,#05,#DD,#7E,#01,#FD,#77,#00,#DD,#7E,#00,#FD,#77 ; #9b90 ...w..~..w..~..w
db #01,#FD,#36,#07,#00,#3A,#EE,#9B,#FD,#77,#03,#13,#18,#C5,#40,#00 ; #9ba0 ..6..:...w....@.
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #9bb0 ................
db #FC,#03,#FD,#04,#00,#03,#03,#00,#04,#FD,#03,#FC,#00,#FD,#FD,#06 ; #9bc0 ................
db #08,#3A,#0F,#9E,#4F,#C5,#EB,#1A,#A1,#AE,#12,#1C,#2C,#1A,#A1,#AE ; #9bd0 .:..O.......,...
db #12,#2C,#EB,#01,#FF,#07,#09,#30,#06,#01,#40,#C0,#09,#CB,#9C,#C1 ; #9be0 .,.....0..@.....
db #10,#E3,#C9,#DD,#21,#00,#84,#DD,#22,#3C,#9C,#C9,#00,#84,#00,#DD ; #9bf0 ....!..."<......
db #2A,#3C,#9C,#AF,#32,#3E,#9C,#3A,#CA,#90,#CB,#3F,#47,#DD,#7E,#00 ; #9c00 *<..2>.:...?G.~.
db #A7,#F8,#90,#F8,#D6,#06,#38,#08,#DD,#23,#DD,#23,#DD,#23,#18,#ED ; #9c10 ......8..#.#.#..
db #DD,#7E,#02,#E6,#E0,#47,#3A,#CE,#90,#E6,#E0,#B8,#20,#40,#DD,#7E ; #9c20 .~...G:..... @.~
db #02,#E6,#10,#32,#EE,#9B,#DD,#7E,#02,#E6,#07,#67,#DD,#6E,#00,#CB ; #9c30 ...2...~...g.n..
db #25,#CD,#24,#9D,#7E,#A7,#F2,#AE,#9C,#FE,#BF,#CA,#AE,#9C,#DD,#7E ; #9c40 %.$.~..........~
db #02,#E6,#07,#0F,#0F,#0F,#C6,#0C,#67,#DD,#7E,#00,#E6,#07,#0F,#0F ; #9c50 ........g.~.....
db #0F,#C6,#0C,#6F,#DD,#7E,#01,#DD,#E5,#CD,#8B,#9B,#DD,#E1,#DD,#23 ; #9c60 ...o.~.........#
db #DD,#23,#DD,#23,#18,#91,#00,#00,#7C,#07,#07,#07,#E6,#07,#67,#3A ; #9c70 .#.#....|.....g:
db #CD,#90,#85,#07,#07,#07,#E6,#07,#C8,#6F,#3A,#CA,#90,#85,#85,#6F ; #9c80 .........o:....o
db #22,#B6,#9C,#CD,#24,#9D,#7E,#A7,#37,#C9,#3A,#CE,#90,#81,#4F,#79 ; #9c90 "...$.~.7.:...Oy
db #0F,#0F,#0F,#37,#1F,#CB,#18,#37,#1F,#CB,#18,#67,#68,#C9,#FE,#0C ; #9ca0 ...7...7...gh...
db #D0,#F5,#07,#07,#C6,#04,#67,#2E,#00,#11,#00,#80,#01,#00,#04,#ED ; #9cb0 ......g.........
db #B0,#F1,#F5,#2E,#00,#C6,#34,#67,#11,#00,#84,#01,#00,#01,#ED,#B0 ; #9cc0 ......4g........
db #F1,#87,#87,#87,#4F,#06,#00,#21,#40,#00,#09,#01,#08,#00,#11,#4F ; #9cd0 ....O..!@......O
db #A2,#ED,#B0,#C9,#37,#CB,#1C,#CB,#1D,#C9,#E5,#CD,#24,#9D,#EB,#C1 ; #9ce0 ....7.......$...
db #78,#87,#87,#87,#6F,#79,#1F,#E6,#07,#F6,#C0,#67,#1A,#EB,#CD,#49 ; #9cf0 x...oy.....g...I
db #9D,#EB,#01,#20,#04,#CD,#15,#90,#C9,#2E,#00,#87,#30,#08,#E6,#7F ; #9d00 ... ........0...
db #FE,#6E,#38,#02,#3E,#0C,#A7,#CB,#3F,#CB,#3F,#CB,#1D,#C6,#40,#67 ; #9d10 .n8.>...?.?...@g
db #C9,#3A,#CA,#90,#06,#08,#6F,#26,#00,#11,#F7,#90,#E5,#CD,#24,#9D ; #9d20 .:....o&......$.
db #7E,#CD,#49,#9D,#7D,#F6,#7F,#6F,#EB,#73,#23,#72,#23,#EB,#E1,#24 ; #9d30 ~.I.}..o.s#r#..$
db #10,#EA,#C9,#2A,#C7,#90,#E5,#21,#00,#00,#22,#C7,#90,#21,#C6,#90 ; #9d40 ...*...!.."..!..
db #34,#AF,#CD,#CB,#9D,#2A,#C9,#90,#CB,#84,#2E,#00,#CD,#E0,#9D,#22 ; #9d50 4....*........."
db #C9,#90,#AF,#32,#F6,#90,#CD,#61,#9D,#0E,#07,#3A,#CA,#90,#6F,#26 ; #9d60 ...2...a...:..o&
db #00,#06,#08,#C5,#E5,#CD,#2A,#9D,#E1,#24,#C1,#10,#F6,#2C,#2C,#0D ; #9d70 ......*..$...,,.
db #20,#ED,#21,#C6,#90,#35,#E1,#22,#C7,#90,#C9,#21,#C6,#90,#34,#11 ; #9d80  .!..5."...!..4.
db #01,#C0,#21,#00,#C0,#01,#FF,#3F,#77,#ED,#B0,#21,#C6,#90,#35,#C9 ; #9d90 ..!....?w..!..5.
db #F5,#E5,#21,#F5,#90,#F3,#CB,#7E,#36,#00,#FB,#28,#F8,#E1,#F1,#C9 ; #9da0 ..!....~6..(....
db #06,#08,#3A,#0F,#9E,#4F,#11,#FF,#07,#7E,#A1,#77,#23,#7E,#A1,#77 ; #9db0 ..:..O...~.w#~.w
db #19,#30,#09,#11,#40,#C0,#19,#11,#FF,#07,#CB,#9C,#10,#EB,#C9,#CC ; #9dc0 .0..@...........
db #00,#00,#00,#00,#01,#01,#10,#00,#CD,#43,#90,#3E,#80,#32,#C6,#90 ; #9dd0 .........C.>.2..
db #21,#00,#00,#22,#C7,#90,#21,#10,#00,#22,#C9,#90,#CD,#4A,#97,#CD ; #9de0 !.."..!.."...J..
db #89,#90,#3A,#15,#9E,#32,#14,#9E,#AF,#32,#13,#9E,#AF,#32,#E4,#90 ; #9df0 ..:..2...2...2..
db #32,#F1,#90,#3A,#14,#9E,#CD,#EE,#9C,#3A,#14,#9E,#CD,#04,#96,#3E ; #9e00 2..:.....:.....>
db #80,#32,#C6,#90,#21,#00,#00,#22,#C9,#90,#AF,#CD,#CB,#9D,#21,#27 ; #9e10 .2..!.."......!''
db #97,#CD,#F8,#96,#3A,#14,#9E,#A7,#20,#02,#3E,#0C,#CD,#02,#97,#3A ; #9e20 ....:... .>....:
db #13,#9E,#FE,#01,#21,#39,#97,#CC,#F8,#96,#CD,#63,#9A,#3A,#14,#9E ; #9e30 ....!9.....c.:..
db #C6,#10,#32,#16,#9E,#21,#15,#97,#CD,#F8,#96,#CD,#E7,#96,#21,#10 ; #9e40 ..2..!........!.
db #00,#22,#C7,#90,#18,#0B,#3A,#CA,#90,#C6,#10,#30,#01,#AF,#32,#CA ; #9e50 ."....:....0..2.
db #90,#CD,#83,#9D,#CD,#E0,#9D,#CD,#E0,#9D,#CD,#81,#9A,#AF,#32,#10 ; #9e60 ..............2.
db #9E,#32,#57,#A2,#32,#C6,#90,#32,#12,#9E,#3E,#FF,#32,#11,#9E,#3A ; #9e70 .2W.2..2..>.2..:
db #E4,#90,#E6,#80,#C2,#51,#9F,#3A,#12,#9E,#A7,#C2,#2F,#9F,#CD,#07 ; #9e80 .....Q.:..../...
db #9A,#21,#11,#9E,#F3,#7E,#36,#00,#FB,#A7,#C4,#18,#A2,#CD,#E0,#9D ; #9e90 .!...~6.........
db #CD,#B6,#9F,#CD,#98,#9A,#CD,#76,#A2,#3A,#3E,#9C,#A7,#C4,#3F,#9C ; #9ea0 .......v.:>...?.
db #CD,#91,#95,#CD,#09,#BB,#30,#C7,#F6,#20,#FE,#63,#CC,#7C,#96,#FE ; #9eb0 ......0.. .c.|..
db #70,#CC,#C0,#96,#FE,#6A,#20,#07,#3E,#80,#32,#62,#9A,#18,#B0,#FE ; #9ec0 p....j .>.2b....
db #6B,#20,#06,#AF,#32,#62,#9A,#18,#A6,#FE,#20,#20,#09,#3A,#E8,#90 ; #9ed0 k ..2b....  .:..
db #EE,#10,#32,#E8,#90,#AF,#C3,#BF,#9E,#CD,#09,#BB,#38,#FB,#C9,#CD ; #9ee0 ..2.........8...
db #32,#95,#3A,#14,#9E,#A7,#20,#09,#3A,#13,#9E,#3C,#32,#13,#9E,#3E ; #9ef0 2.:... .:..<2..>
db #08,#3C,#32,#14,#9E,#FE,#0C,#C2,#3C,#9E,#AF,#32,#14,#9E,#C3,#3C ; #9f00 .<2.....<..2...<
db #9E,#CD,#E0,#9D,#CD,#B6,#9F,#CD,#98,#9A,#CD,#91,#95,#3A,#E4,#90 ; #9f10 .............:..
db #E6,#80,#20,#ED,#3A,#C1,#90,#A7,#FA,#77,#9F,#28,#0A,#2A,#C7,#90 ; #9f20 .. .:....w.(.*..
db #7D,#B4,#28,#BB,#C3,#96,#9E,#C3,#1B,#9E,#3A,#0F,#9E,#4F,#C5,#E5 ; #9f30 }.(.......:..O..
db #EB,#1A,#A1,#B6,#12,#1C,#2C,#1A,#A1,#B6,#12,#1C,#2C,#1A,#A1,#B6 ; #9f40 ......,.....,...
db #12,#1C,#2C,#1A,#A1,#B6,#12,#1C,#2C,#1A,#A1,#B6,#12,#1C,#2C,#1A ; #9f50 ..,.....,.....,.
db #A1,#B6,#12,#2C,#EB,#E1,#01,#00,#08,#09,#30,#06,#01,#40,#C0,#09 ; #9f60 ...,......0..@..
db #CB,#9C,#C1,#10,#C9,#C9,#CD,#E4,#A1,#DD,#21,#80,#85,#06,#06,#C5 ; #9f70 ..........!.....
db #DD,#6E,#00,#DD,#66,#01,#7D,#B4,#C4,#D4,#9F,#01,#10,#00,#DD,#09 ; #9f80 .n..f.}.........
db #C1,#10,#EC,#C9,#E9,#DD,#7E,#05,#DD,#35,#05,#28,#72,#3D,#1E,#00 ; #9f90 ......~..5.(r=..
db #CB,#3F,#CB,#3F,#CB,#1B,#C6,#7A,#57,#18,#0A,#DD,#56,#09,#DD,#7E ; #9fa0 .?.?...zW...V..~
db #08,#83,#5F,#18,#06,#DD,#46,#02,#DD,#4E,#03,#CD,#DF,#9C,#DD,#75 ; #9fb0 .._...F..N.....u
db #0C,#DD,#74,#0D,#DD,#73,#0A,#DD,#72,#0B,#C9,#DD,#E5,#DD,#21,#80 ; #9fc0 ..t..s..r.....!.
db #85,#21,#D5,#9F,#11,#10,#00,#06,#06,#DD,#7E,#00,#DD,#B6,#01,#C4 ; #9fd0 .!........~.....
db #2D,#A0,#DD,#19,#10,#F3,#AF,#32,#57,#A2,#DD,#E1,#C9,#DD,#75,#00 ; #9fe0 -......2W.....u.
db #DD,#74,#01,#DD,#36,#05,#08,#DD,#36,#06,#00,#DD,#36,#07,#00,#C9 ; #9ff0 .t..6...6...6...
db #21,#D5,#9F,#CD,#2D,#A0,#CD,#38,#95,#11,#09,#90,#C3,#B5,#95,#DD ; #a000 !...-..8........
db #36,#00,#00,#DD,#36,#01,#00,#21,#60,#A0,#34,#11,#00,#60,#18,#95 ; #a010 6...6..!`.4..`..
db #06,#3A,#60,#A0,#A7,#37,#C8,#FD,#21,#80,#85,#11,#10,#00,#06,#06 ; #a020 .:`..7..!.......
db #AF,#FD,#7E,#00,#FD,#B6,#01,#28,#06,#FD,#19,#10,#F3,#37,#C9,#21 ; #a030 ..~....(.....7.!
db #60,#A0,#35,#C9,#3A,#CE,#90,#ED,#44,#DD,#86,#03,#4F,#C6,#15,#FE ; #a040 `.5.:...D...O...
db #F8,#30,#BC,#DD,#46,#02,#ED,#5B,#E2,#90,#78,#92,#C6,#12,#FE,#24 ; #a050 .0..F..[..x....$
db #30,#2E,#79,#93,#C6,#12,#FE,#24,#30,#26,#CD,#40,#A0,#3A,#E4,#90 ; #a060 0.y....$0&.@.:..
db #E6,#80,#C0,#F3,#3A,#C3,#90,#A7,#28,#06,#3D,#32,#C3,#90,#FB,#C9 ; #a070 ....:...(.=2....
db #FB,#CD,#0B,#A0,#21,#C1,#90,#35,#3E,#C0,#32,#E4,#90,#C3,#88,#95 ; #a080 ....!..5>.2.....
db #3A,#EB,#90,#A7,#C8,#ED,#5B,#E9,#90,#78,#92,#C6,#18,#FE,#1E,#D0 ; #a090 :.....[..x......
db #79,#93,#C6,#14,#FE,#20,#D0,#DD,#CB,#05,#4E,#DD,#CB,#05,#8E,#20 ; #a0a0 y.... ....N.... 
db #07,#DD,#CB,#05,#7E,#CC,#40,#A0,#AF,#32,#EB,#90,#C9,#DD,#7E,#06 ; #a0b0 ....~.@..2....~.
db #DD,#46,#02,#A7,#28,#03,#F2,#11,#A1,#80,#30,#0F,#DD,#77,#02,#47 ; #a0c0 .F..(.....0..w.G
db #C9,#80,#FE,#EC,#30,#05,#1D,#DD,#77,#02,#C9,#AF,#DD,#96,#06,#DD ; #a0d0 ....0...w.......
db #77,#06,#C9,#DD,#7E,#07,#DD,#4E,#03,#81,#DD,#77,#03,#DD,#CB,#07 ; #a0e0 w...~..N...w....
db #7E,#28,#04,#1E,#00,#4F,#C9,#DD,#7E,#07,#87,#DD,#86,#07,#87,#ED ; #a0f0 ~(...O..~.......
db #44,#5F,#C9,#DD,#7E,#0F,#DD,#86,#07,#F5,#E5,#26,#75,#6F,#7E,#E1 ; #a100 D_..~......&uo~.
db #DD,#77,#07,#CD,#23,#A1,#F1,#DD,#77,#07,#C9,#DD,#7E,#0E,#DD,#86 ; #a110 .w..#...w...~...
db #06,#F5,#E5,#26,#75,#6F,#7E,#E1,#DD,#77,#06,#CD,#FD,#A0,#F1,#DD ; #a120 ...&uo~..w......
db #77,#06,#C9,#7C,#95,#30,#07,#C6,#08,#3E,#00,#D8,#91,#C9,#D6,#08 ; #a130 w..|.0...>......
db #79,#D0,#AF,#C9,#3A,#CE,#90,#ED,#44,#DD,#86,#03,#C6,#15,#6F,#3A ; #a140 y...:...D.....o:
db #E2,#90,#C6,#15,#67,#DD,#4E,#07,#C5,#CD,#73,#A1,#DD,#77,#07,#A7 ; #a150 ....g.N...s..w..
db #F2,#A6,#A1,#DD,#35,#07,#CD,#AE,#A1,#C1,#DD,#71,#07,#C9,#DD,#6E ; #a160 ....5......q...n
db #02,#3A,#E3,#90,#67,#DD,#4E,#06,#C5,#CD,#73,#A1,#DD,#77,#06,#CD ; #a170 .:..g.N...s..w..
db #C7,#A1,#C1,#DD,#71,#06,#C9,#CD,#23,#A1,#CD,#FD,#A0,#CD,#EB,#9F ; #a180 ....q...#.......
db #CD,#84,#A0,#C9,#CD,#43,#A1,#CD,#5B,#A1,#18,#F1,#CD,#23,#A1,#CD ; #a190 .....C..[....#..
db #5B,#A1,#18,#E9,#06,#06,#DD,#21,#80,#85,#DD,#7E,#0D,#DD,#36,#0D ; #a1a0 [......!...~..6.
db #00,#FE,#C0,#38,#11,#67,#DD,#6E,#0C,#DD,#56,#0B,#DD,#5E,#0A,#C5 ; #a1b0 ...8.g.n..V..^..
db #06,#14,#CD,#7A,#9F,#C1,#11,#10,#00,#DD,#19,#10,#DD,#C9,#ED,#5F ; #a1c0 ...z..........._
db #87,#87,#FE,#E8,#D8,#D6,#E8,#C9,#3A,#CA,#90,#07,#07,#07,#E6,#07 ; #a1d0 ........:.......
db #4F,#06,#00,#21,#4F,#A2,#09,#3A,#10,#9E,#BE,#C8,#7E,#32,#10,#9E ; #a1e0 O..!O..:....~2..
db #87,#87,#87,#4F,#06,#00,#CB,#10,#21,#00,#02,#09,#11,#57,#A2,#01 ; #a1f0 ...O....!....W..
db #08,#00,#ED,#B0,#3A,#58,#A2,#32,#5F,#A2,#AF,#32,#60,#A2,#C9,#00 ; #a200 ....:X.2_..2`...
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #a210 ................
db #06,#3E,#EF,#DD,#96,#04,#30,#02,#3E,#FF,#DD,#77,#04,#3E,#00,#DD ; #a220 .>....0.>..w.>..
db #96,#02,#DD,#77,#02,#C9,#DD,#21,#57,#A2,#DD,#35,#08,#C0,#DD,#7E ; #a230 ...w...!W..5...~
db #00,#A7,#C8,#DD,#7E,#01,#DD,#77,#08,#DD,#CB,#06,#6E,#28,#19,#DD ; #a240 ....~..w....n(..
db #7E,#09,#A7,#20,#10,#3A,#60,#A0,#FE,#06,#C0,#DD,#77,#09,#DD,#CB ; #a250 ~.. .:`.....w...
db #06,#5E,#C4,#61,#A2,#DD,#35,#09,#CD,#61,#A0,#D8,#DD,#7E,#00,#2E ; #a260 .^.a..5..a...~..
db #00,#CB,#3F,#CB,#1D,#C6,#60,#FD,#75,#08,#FD,#77,#09,#DD,#7E,#06 ; #a270 ..?...`.u..w..~.
db #E6,#80,#F6,#01,#FD,#77,#05,#DD,#7E,#06,#E6,#10,#C4,#61,#A2,#3A ; #a280 .....w..~....a.:
db #CE,#90,#D6,#15,#DD,#CB,#06,#56,#28,#02,#C6,#F5,#FD,#77,#03,#DD ; #a290 .......V(....w..
db #7E,#04,#FD,#77,#02,#FE,#FF,#20,#08,#CD,#0E,#A2,#FD,#77,#02,#18 ; #a2a0 ~..w... .....w..
db #4D,#DD,#CB,#06,#76,#28,#33,#DD,#86,#05,#DD,#CB,#05,#7E,#20,#10 ; #a2b0 M...v(3......~ .
db #38,#04,#FE,#E8,#38,#35,#DD,#7E,#05,#ED,#44,#DD,#77,#05,#18,#2E ; #a2c0 8...85.~..D.w...
db #30,#F4,#38,#27,#FE,#E8,#38,#23,#DD,#CB,#06,#76,#28,#0C,#F5,#DD ; #a2d0 0.8''..8#...v(...
db #7E,#05,#ED,#44,#DD,#77,#05,#F1,#18,#14,#DD,#86,#05,#FE,#E8,#38 ; #a2e0 ~..D.w.........8
db #0A,#D6,#18,#DD,#CB,#05,#7E,#20,#02,#C6,#30,#DD,#77,#04,#DD,#7E ; #a2f0 ......~ ..0.w..~
db #07,#A7,#28,#0E,#3D,#28,#26,#3D,#28,#28,#3D,#28,#2A,#3D,#28,#47 ; #a300 ..(.=(&=((=(*=(G
db #18,#20,#21,#C7,#A1,#E5,#DD,#7E,#02,#FD,#77,#06,#DD,#7E,#03,#CD ; #a310 . !....~..w..~..
db #A0,#A3,#FD,#77,#07,#E1,#FD,#75,#00,#FD,#74,#01,#C9,#21,#AE,#A1 ; #a320 ...w...u..t..!..
db #18,#E3,#21,#84,#A1,#18,#DE,#21,#D4,#A1,#DD,#7E,#03,#FD,#77,#0F ; #a330 ..!....!...~..w.
db #3E,#40,#FD,#77,#07,#FD,#75,#00,#FD,#74,#01,#DD,#7E,#02,#FD,#77 ; #a340 >@.w..u..t..~..w
db #0E,#3E,#00,#FD,#77,#06,#C9,#21,#DC,#A1,#CD,#8B,#A3,#E5,#18,#BC ; #a350 .>..w..!........
db #FE,#0A,#30,#03,#D6,#04,#C9,#4F,#E6,#0F,#D6,#04,#47,#ED,#5F,#0F ; #a360 ..0....O....G._.
db #0F,#0F,#6F,#ED,#5F,#AD,#0F,#E6,#03,#CB,#79,#20,#02,#CB,#3F,#80 ; #a370 ..o._.....y ..?.
db #CB,#69,#C8,#ED,#44,#C9,#21,#E1,#A3,#11,#70,#B9,#01,#12,#00,#ED ; #a380 .i..D.!...p.....
db #B0,#3E,#05,#32,#2E,#A4,#3E,#04,#32,#3D,#A5,#3E,#18,#32,#3B,#B9 ; #a390 .>.2..>.2=.>.2;.
db #C9,#F5,#C5,#D5,#E5,#2A,#D6,#90,#CD,#F2,#A3,#E1,#D1,#C1,#F1,#C3 ; #a3a0 .....*..........
db #3D,#B9,#E9,#21,#ED,#A4,#22,#D6,#90,#01,#06,#BC,#ED,#49,#01,#20 ; #a3b0 =..!.."......I. 
db #BD,#ED,#49,#2A,#C9,#90,#3A,#C6,#90,#A7,#20,#0A,#ED,#4B,#C7,#90 ; #a3c0 ..I*..:... ..K..
db #A7,#ED,#42,#22,#C9,#90,#29,#29,#29,#29,#7C,#32,#CE,#90,#E6,#1F ; #a3d0 ..B"..))))|2....
db #32,#CD,#90,#E6,#07,#32,#CF,#90,#2A,#C9,#90,#EE,#07,#C6,#08,#01 ; #a3e0 2....2..*.......
db #05,#BC,#ED,#49,#04,#4F,#ED,#49,#CB,#15,#2E,#00,#CB,#1D,#7C,#CB ; #a3f0 ...I.O.I......|.
db #3F,#CB,#1D,#E6,#07,#F6,#C0,#67,#22,#CB,#90,#CB,#3C,#CB,#1D,#01 ; #a400 ?......g"...<...
db #0D,#BC,#ED,#49,#04,#4D,#ED,#49,#01,#0C,#BC,#ED,#49,#7C,#E6,#03 ; #a410 ...I.M.I....I|..
db #F6,#30,#4F,#04,#ED,#49,#C9,#3A,#C6,#90,#A7,#C0,#3A,#F6,#90,#4F ; #a420 .0O..I.:....:..O
db #3A,#CD,#90,#B9,#C8,#32,#F6,#90,#DD,#E5,#FE,#1F,#20,#11,#CD,#61 ; #a430 :....2...... ..a
db #9D,#3A,#CA,#90,#E6,#1E,#FE,#1E,#20,#05,#3E,#FF,#32,#11,#9E,#01 ; #a440 .:...... .>.2...
db #00,#FF,#CD,#DA,#9C,#0E,#08,#DD,#21,#05,#91,#EB,#DD,#6E,#00,#DD ; #a450 ........!....n..
db #66,#01,#06,#04,#7E,#87,#87,#E6,#CC,#12,#1D,#7E,#E6,#CC,#12,#1B ; #a460 f...~......~....
db #2D,#10,#F1,#DD,#74,#01,#DD,#75,#00,#DD,#2B,#DD,#2B,#0D,#20,#DC ; #a470 -...t..u..+.+. .
db #21,#C0,#FF,#19,#CB,#FC,#CB,#F4,#AF,#06,#40,#77,#2D,#10,#FC,#DD ; #a480 !.........@w-...
db #E1,#3A,#F6,#90,#FE,#10,#20,#04,#21,#3E,#9C,#34,#2A,#C9,#90,#7D ; #a490 .:.... .!>.4*..}
db #E6,#F0,#B4,#C0,#22,#C7,#90,#3E,#FF,#32,#12,#9E,#C9,#21,#08,#A5 ; #a4a0 ...."..>.2...!..
db #22,#D6,#90,#01,#04,#BC,#ED,#49,#01,#1B,#BD,#ED,#49,#01,#07,#BC ; #a4b0 "......I....I...
db #ED,#49,#01,#7F,#BD,#ED,#49,#C9,#21,#0F,#A5,#22,#D6,#90,#C9,#21 ; #a4c0 .I....I.!.."...!
db #1F,#A5,#22,#D6,#90,#01,#10,#7F,#ED,#49,#0E,#49,#ED,#49,#C9,#21 ; #a4d0 .."......I.I.I.!
db #56,#A5,#22,#D6,#90,#01,#0D,#BC,#ED,#49,#01,#80,#BD,#ED,#49,#01 ; #a4e0 V."......I....I.
db #0C,#BC,#ED,#49,#01,#13,#BD,#ED,#49,#3A,#CF,#90,#C6,#01,#01,#05 ; #a4f0 ...I....I:......
db #BC,#ED,#49,#04,#4F,#ED,#49,#3E,#FF,#32,#F5,#90,#01,#10,#7F,#ED ; #a500 ..I.O.I>.2......
db #49,#0E,#48,#ED,#49,#C9,#21,#F3,#A3,#22,#D6,#90,#01,#04,#BC,#ED ; #a510 I.H.I.!.."......
db #49,#01,#07,#BD,#ED,#49,#01,#06,#BC,#ED,#49,#01,#04,#BD,#ED,#49 ; #a520 I....I....I....I
db #01,#07,#BC,#ED,#49,#01,#05,#BD,#ED,#49,#01,#10,#7F,#ED,#49,#0E ; #a530 ....I....I....I.
db #55,#ED,#49,#C9,#  ,#  ,#  ,#  ,#  ,#  ,#  ,#  ,#  ,#  ,#  ,#   ; #a540 U.I.

*/',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: disassembled-game
  SELECT id INTO tag_uuid FROM tags WHERE name = 'disassembled-game';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
