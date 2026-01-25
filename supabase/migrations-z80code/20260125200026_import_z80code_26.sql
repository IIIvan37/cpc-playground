-- Migration: Import z80code projects batch 26
-- Projects 51 to 52
-- Generated: 2026-01-25T21:43:30.189191

-- Project 51: fade-out by Gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fade-out',
    'Imported from z80Code. Author: Gurneyh. Transition "circulaire"',
    'public',
    false,
    false,
    '2019-11-14T20:18:19.960000'::timestamptz,
    '2021-06-18T14:09:09.950000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; ==============================================================================
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


macro WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
 endm

; ==============================================================================
; Gate Array
; ==============================================================================
; http://www.cpcwiki.eu/index.php/Gate_Array
; http://quasar.cpcscene.net/doku.php?id=assem:gate_array


; ------------------------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; ------------------------------------------------------------------------------
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
 
                di 
                ld hl, #c9fb
                ld (#38), hl
                ei

                SET_MODE 0
                WRITE_CRTC 1, 32
                WRITE_CRTC 2, 42
                WRITE_CRTC 6, 22

; ==============================================================================
; PPI
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc


macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
endm


; ------------------------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700



main_loop:
                WAIT_VBL

                SET_BORDER Color.fm_6
                ld b, 192                       
                ld ixh, 3       ; 256 * 3 + 192
                ld iy, .next 
                ld de, #c000

                exx
                ld hl, table
                exx
.loop:        
                exx
                ld a, (hl)
                inc (hl)
                inc hl
                cp 16
                exx
                jr nc, .next_chr
                
                ld h, hi(patterns)
                add a, a 
                ld l, a
                ld a, (hl)
                inc l
                ld h, (hl)
                ld l, a 
               
                jp (hl)
.next:          
                add hl, de  
                ld a, (hl)
                and c
                
                ld (hl), a 

                ld a, h 
                add a, 8 
                ld h, a 
                
                ld a, (hl)
                and c
               
                ld (hl), a
             
.next_chr:     
                inc e : inc de 
                djnz .loop
                dec ixh

                jp nz, .loop

                jr main_loop

align 256
patterns:
dw pattern_0
dw pattern_1
dw pattern_2
dw pattern_3
dw pattern_4
dw pattern_5
dw pattern_6
dw pattern_7
dw pattern_8
dw pattern_9
dw pattern_10
dw pattern_11
dw pattern_12
dw pattern_13
dw pattern_14
dw pattern_15


pattern_0:
ld hl, 0x0
ld c, 170
jp (iy)

pattern_1:
ld hl, 0x2001
ld c, 170
jp (iy)

pattern_2:
ld hl, 0x1
ld c, 170
jp (iy)

pattern_3:
ld hl, 0x2000
ld c, 170
jp (iy)

pattern_4:
ld hl, 0x1000
ld c, 85
jp (iy)

pattern_5:
ld hl, 0x3001
ld c, 85
jp (iy)

pattern_6:
ld hl, 0x1001
ld c, 85
jp (iy)

pattern_7:
ld hl, 0x3000
ld c, 85
jp (iy)

pattern_8:
ld hl, 0x0
ld c, 85
jp (iy)

pattern_9:
ld hl, 0x2001
ld c, 85
jp (iy)

pattern_10:
ld hl, 0x1
ld c, 85
jp (iy)

pattern_11:
ld hl, 0x2000
ld c, 85
jp (iy)

pattern_12:
ld hl, 0x1000
ld c, 170
jp (iy)

pattern_13:
ld hl, 0x3001
ld c, 170
jp (iy)

pattern_14:
ld hl, 0x1001
ld c, 170
jp (iy)

pattern_15:
ld hl, 0x3000
ld c, 170
jp (iy)



table:
db 145, 150, 155, 159, 163, 167, 171, 175, 178, 182, 184, 187, 189, 191, 192, 193, 193, 193, 192, 191, 189, 187, 184, 182, 178, 175, 171, 167, 163, 159, 155, 150
db 149, 153, 158, 163, 167, 171, 175, 179, 183, 186, 189, 192, 194, 196, 198, 199, 199, 199, 198, 196, 194, 192, 189, 186, 183, 179, 175, 171, 167, 163, 158, 153
db 151, 156, 161, 166, 170, 175, 179, 183, 187, 191, 194, 197, 200, 202, 203, 204, 204, 204, 203, 202, 200, 197, 194, 191, 187, 183, 179, 175, 170, 166, 161, 156
db 154, 159, 164, 169, 174, 178, 183, 187, 191, 195, 199, 202, 205, 207, 209, 210, 210, 210, 209, 207, 205, 202, 199, 195, 191, 187, 183, 178, 174, 169, 164, 159
db 157, 162, 167, 172, 177, 182, 186, 191, 195, 199, 203, 207, 210, 212, 214, 215, 216, 215, 214, 212, 210, 207, 203, 199, 195, 191, 186, 182, 177, 172, 167, 162
db 159, 164, 169, 174, 179, 184, 189, 194, 199, 203, 207, 211, 215, 217, 220, 221, 221, 221, 220, 217, 215, 211, 207, 203, 199, 194, 189, 184, 179, 174, 169, 164
db 161, 166, 171, 177, 182, 187, 192, 197, 202, 207, 211, 215, 219, 222, 225, 227, 227, 227, 225, 222, 219, 215, 211, 207, 202, 197, 192, 187, 182, 177, 171, 166
db 162, 168, 173, 178, 184, 189, 194, 200, 205, 210, 215, 219, 223, 227, 230, 232, 233, 232, 230, 227, 223, 219, 215, 210, 205, 200, 194, 189, 184, 178, 173, 168
db 163, 169, 174, 180, 185, 191, 196, 202, 207, 212, 217, 222, 227, 231, 235, 238, 238, 238, 235, 231, 227, 222, 217, 212, 207, 202, 196, 191, 185, 180, 174, 169
db 164, 170, 175, 181, 187, 192, 198, 203, 209, 214, 220, 225, 230, 235, 239, 243, 244, 243, 239, 235, 230, 225, 220, 214, 209, 203, 198, 192, 187, 181, 175, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 215, 221, 227, 232, 238, 243, 247, 250, 247, 243, 238, 232, 227, 221, 215, 210, 204, 199, 193, 187, 182, 176, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 216, 221, 227, 233, 238, 244, 250, 255, 250, 244, 238, 233, 227, 221, 216, 210, 204, 199, 193, 187, 182, 176, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 215, 221, 227, 232, 238, 243, 247, 250, 247, 243, 238, 232, 227, 221, 215, 210, 204, 199, 193, 187, 182, 176, 170
db 164, 170, 175, 181, 187, 192, 198, 203, 209, 214, 220, 225, 230, 235, 239, 243, 244, 243, 239, 235, 230, 225, 220, 214, 209, 203, 198, 192, 187, 181, 175, 170
db 163, 169, 174, 180, 185, 191, 196, 202, 207, 212, 217, 222, 227, 231, 235, 238, 238, 238, 235, 231, 227, 222, 217, 212, 207, 202, 196, 191, 185, 180, 174, 169
db 162, 168, 173, 178, 184, 189, 194, 200, 205, 210, 215, 219, 223, 227, 230, 232, 233, 232, 230, 227, 223, 219, 215, 210, 205, 200, 194, 189, 184, 178, 173, 168
db 161, 166, 171, 177, 182, 187, 192, 197, 202, 207, 211, 215, 219, 222, 225, 227, 227, 227, 225, 222, 219, 215, 211, 207, 202, 197, 192, 187, 182, 177, 171, 166
db 159, 164, 169, 174, 179, 184, 189, 194, 199, 203, 207, 211, 215, 217, 220, 221, 221, 221, 220, 217, 215, 211, 207, 203, 199, 194, 189, 184, 179, 174, 169, 164
db 157, 162, 167, 172, 177, 182, 186, 191, 195, 199, 203, 207, 210, 212, 214, 215, 216, 215, 214, 212, 210, 207, 203, 199, 195, 191, 186, 182, 177, 172, 167, 162
db 154, 159, 164, 169, 174, 178, 183, 187, 191, 195, 199, 202, 205, 207, 209, 210, 210, 210, 209, 207, 205, 202, 199, 195, 191, 187, 183, 178, 174, 169, 164, 159
db 151, 156, 161, 166, 170, 175, 179, 183, 187, 191, 194, 197, 200, 202, 203, 204, 204, 204, 203, 202, 200, 197, 194, 191, 187, 183, 179, 175, 170, 166, 161, 156
db 149, 153, 158, 163, 167, 171, 175, 179, 183, 186, 189, 192, 194, 196, 198, 199, 199, 199, 198, 196, 194, 192, 189, 186, 183, 179, 175, 171, 167, 163, 158, 153

macro fill_pattern col,lin
  repeat 8,c3   
   repeat {lin},c2
    repeat {col},c1
     if (c1>{col}/{lin}*c2)
      db #82  + #41
     else
      db #02 + #01
     endif
    rend
   rend
   ds 2048-{lin}*{col},0
  rend
mend


; Donnees directement ecrite en memoire video
 org #c000
 fill_pattern 64,22
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: transition
  SELECT id INTO tag_uuid FROM tags WHERE name = 'transition';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 52: z80.o by Madram
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'z80.o',
    'Imported from z80Code. Author: Madram. z80.o from orgams',
    'public',
    false,
    false,
    '2020-04-24T11:01:18.364000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; z80.o / Madram
; http://memoryfull.net/post.php?id=58#744

; Go to /Legend/ by hitting CTRL-ENTER on this line. CTRL-RETURN go back
; Go to /Timing/ notes.

; ======= 8-bit Load ==========================================

; Mnemonic  | Opcodes       | SZ5H3VNC | NOPs  ; Notes
ld r,r''     |    01rrr''''''   | ........ | 1     ; See /rrr/ (CTRL-ENTER)
ld r,(hl)   |    01rrr110   | ........ | 2 
ld r,(ix+n) | DD 01rrr110 n | ........ | 5
ld r,n      |    00rrr110 n | ........ | 2 
ld (hl),r   |    01110rrr   | ........ | 2
ld (ix+n),r | DD 01110rrr n | ........ | 5
ld (hl),n   |    00110110 n | ........ | 3
ld a,(bc)   |    0A         | ........ | 2
ld a,(de)   |    1A         | ........ | 2
ld a,(nn)   |    3A nn      | ........ | 4
ld (bc),a   |    02         | ........ | 2
ld (de),a   |    12         | ........ | 2
ld (nn),a   |    32 nn      | ........ | 4
ld i,a      | ED 47         | ........ | 3
ld r,a      | ED 4F         | ........ | 3
ld a,i      | ED 57         | SZ503!0. | 3 ; P/V:= IFF2
ld a,r      | ED 5F         | SZ503!0. | 3 ; P/V:= IFF2

; ''ld a,i'' and ''ld a,r'' copy IFF2 in P/V flag.
      ; That is, PE = EI (note the mnemonic trick), PO = DI. 
; Bugged on Z8400 (all CPC apparently), fixed in CMOS version.

; ======= 16-bit Load =========================================

ld rr,nn    |    00rr0001 nn | ........ | 3 ;rr: BC=00 DE=01 HL=10 SP=11
ld ix,nn    | DD 00100001 nn | ........ | 4
ld hl,(nn)  |    2a nn       | ........ | 5
ld ix,(nn)  | DD 2a nn       | ........ | 6 
ld rr,(nn)  | ED 01rr1011 nn | ........ | 6 ; Include slower ld hl,(nn)
ld (nn),hl  |    22 nn       | ........ | 5
ld (nn),ix  | DD 22 nn       | ........ | 6 
ld (nn),rr  | ED 01rr0011 nn | ........ | 6 ; Include slower ld (nn),hl
ld sp,hl    |    F9          | ........ | 2
ld sp,ix    | DD F9          | ........ | 3
push qq     |    11qq0101    | ........ | 4 ;qq: BC=00 DE=01 HL=10 AF=11
push ix     | DD 11100101    | ........ | 5
pop qq      |    11qq0001    | ........ | 3
pop ix      | DD 11100001    | ........ | 4

; ======= Exchange, Block Transfer, Block Search ==============

ex de,hl    |    EB | ........ | 1
ex af,af''   |    08 | ........ | 1
exx         |    D9 | ........ | 1
ex (sp),hl  |    E3 | ........ | 6
ex (sp),ix  | DD E3 | ........ | 7

ldi         | ED A0 | ..!0!!0. | 5   ; See [transfer notes] below
ldd         | ED A8 | ..!0!!0. | 5  
ldir        | ED B0 | ..!0!00. | 6 / 5 for last iteration.
lddr        | ED B8 | ..!0!00. | 6 / 5 for last iteration.

cpi         | ED A1 | SZ!H!!1. | 5   ; See [search notes] below
cpd         | ED A9 | SZ!H!!1. | 5  
cpir        | ED B1 | SZ!H!!1. | 6 / 5 for last iteration.
cpdr        | ED B9 | SZ!H!!1. | 6 / 5 for last iteration.

;[transfer notes] After ldi/ldd/ldir/lddr:
  ; P/V reset iif BC reached 0.
  ; Let n := A + (last) copied byte. 
     ;  - 5 if a copy of n.1
     ;  - 3 if a copy of n.3          

;[search notes]     
  ; P/V reset iif BC reached 0.
  ; -> corollary tip: inc hl, dec bc, loop while bc in 8 Nops, 5 bytes. 
          cpi:jp pe,loop

  ; N is set because of the underlying cp (hl), aka "a - (hl)"
  ; Z is set according to the result of the comparaison.
    ; That explains why P/V is used as "BC > 0".
  ; Weird behavior of other flags: TODO if interest is there. See [USY]

;[timing notes] ldir/lddr/cpir/cpdr take:
  ; 6 NOPs while BC > 1
  ; 5 NOPs for the last iteration.

; More on ldir/lddr/cpir/cpdr:
  ; Can and will be interrupted.
  ; While BC > 1, the instruction is simply repeated (hence the ''r'')
    ; That is, the opcode is read again. See ldir_ in "z80tests.o"
    ; As a consequence, R := R + 2*BC

; ======= 8-bit Arithmetic and Logical ========================

add r      |    10000rrr   | SZ5H3V0C | 1 
add (hl)   |    10000110   | SZ5H3V0C | 2
add (ix+n) | DD 10000110 n | SZ5H3V0C | 5
add n      |    11000110 n | SZ5H3V0C | 2  

adc r      |    10001rrr   | SZ5H3V0C | 1 ; Same model as add
sub r      |    10010rrr   | SZ5H3V1C | 1 ; Same model as add
sbc r      |    10011rrr   | SZ5H3V1C | 1 ; Same model as add
and r      |    10100rrr   | SZ5H3P00 | 1 ; Same model as add
 or r      |    10101rrr   | SZ5H3P00 | 1 ; Same model as add
xor r      |    10110rrr   | SZ5H3P00 | 1 ; Same model as add
cp  r      |    10111rrr   | SZ5H3V1C | 1 ; Idem. Also, flags like sub r

inc r      |    00rrr100   | SZ5H3V0. | 1 
inc (hl)   |    00110100   | SZ5H3V0. | 3
inc (ix+n) | DD 00110100 n | SZ5H3V0. | 6
dec r      |    00rrr101   | SZ5H3V1. | 1 
dec (hl)   |    00110101   | SZ5H3V1. | 3
dec (ix+n) | DD 00110101 n | SZ5H3V1. | 6

; Tips:
          or a          ; NC, Z/NZ 
          xor a         ; NC, Z, A=0
          cp a          ; NC, Z, without changing A
          add a         ; Shorter sla a
          adc a         ; Shorter rl a (that is, rla + update S,Z,P).
          sbc a         ; A=-1 if Carry, 0 if NC, carry unchanged.

; ======= 16-bit Arithmetic =======================================

add hl,rr   |    00rr1001 | ......0C | 3 ; rr: BC=00 DE=01 HL=10 SP=11
add ix,rr   | DD 00rr1001 | .....V0C | 4 ;                 IX=10 
adc hl,rr   | ED 01rr1010 | SZ...V0C | 4 ;                 HL=10
sbc hl,rr   | ED 01rr0010 | SZ...V1C | 4 ;                 HL=10
inc rr      |    00rr0011 | ........ | 2 ;                 HL=10 
inc ix      | DD 00100011 | ........ | 3 ;                 IX=10 
dec rr      |    00rr1011 | ........ | 2 ;                 HL=10 
dec ix      | DD 00101011 | ........ | 3 ;                 IX=10 

; ====== General-purpose arithmetic and cpu control ================

daa  |    27 | SZ5H3P.C | 1  ; See [Ams]
cpl  |    2F | ..513.1. | 1  ; A := not A (all bits inversed)
neg  | ED 44 | SZ5H3V1C | 2  ; A := 0 - A (all flags like sub)
ccf  |    3F | ..!!!.0C | 1  ; Carry := not Carry
scf  |    37 | ..!0!.01 | 1
nop  |    00 | ........ | 1  ; Chany''s most used instruction 
halt |    76 | ........ | 1  ; Grim''s favorite
di   |    F3 | ........ | 1  
ei   |    FB | ........ | 1  
im 0 | ED 46 | ........ | 2
im 1 | ED 56 | ........ | 2
im 2 | ED 5E | ........ | 2 

; After ''ccf'' or ''scf'':
   ; H = not Carry
   ; Flag 5 & 3 copied from A

; Since ''neg'' is litteraly A := 0 - A, carry is set iif A wasn''t 0.
; -> corallary tip. Multiplication by 255:
          neg:ld l,a:sbc a:sub l:ld h,a ; HL = A * 255

; ''neg'' equivalent that doesn''t change carry:
          cpl:inc a     ; A := -A without carry update
          dec a:cpl     ; Equivalent variant    
; -> corollary tip. Fast multiplication by 255 when A>0:
          dec a:ld h,a:cpl:ld l,a

; ====== Rotate and shift ==========================================

rlca         |       00000111   | ..503.0C | 1
rrca         |       00001111   | ..503.0C | 1
rla          |       00010111   | ..503.0C | 1
rra          |       00011111   | ..503.0C | 1

rlc r        |    CB 00000rrr   | SZ503P0C | 2 
rlc (hl)     |    CB 00000110   | SZ503P0C | 4
rlc (ix+n)   | DD CB 00000110 n | SZ503P0C | 7
rlc (ix+n),r | DD CB 00000rrr n | SZ503P0C | 7  ; Unundocumented

rrc r        |    CB 00001rrr   | SZ503P0C | 2  ; Same model as rlc
rl r         |    CB 00010rrr   | SZ503P0C | 2  ; Same model as rlc
rr r         |    CB 00011rrr   | SZ503P0C | 2  ; Same model as rlc
sla r        |    CB 00100rrr   | SZ503P0C | 2  ; Same model as rlc
sra r        |    CB 00101rrr   | SZ503P0C | 2  ; Same model as rlc
sl1 r        |    CB 00110rrr   | SZ503P0C | 2  ; Unundocumented
srl r        |    CB 00111rrr   | SZ503P0C | 2  ; Same model as rlc

rld          |    ED 6F         | SZ503P0. | 5 
rrd          |    ED 67         | SZ503P0. | 5 

; DD CB undocumented opcodes are equivalent to e.g.
          ld b,(ix+n)
          sla b
          ld (ix+n),b
; They are *not* equivalent to:
          sla (ix+n)
          ld b,(ix+n)   ; !! No !! Not what happens when ix points ROM.

; ====== Bit set, reset, test =====================================

bit b,r        |    CB   01bbbrrr | !Z513Z0. | 2 
bit b,(hl)     |    CB   01bbb110 | !Z!1!Z0. | 3
bit b,(ix+n)   | DD CB n 01bbb110 | !Z!1!Z0. | 6

res b,r        |    CB   10bbbrrr | ........ | 2
res b,(hl)     |    CB   10bbb110 | ........ | 4
res b,(ix+n)   | DD CB n 10bbb110 | ........ | 7
res b,(ix+n),r | DD CB n 10bbbrrr | ........ | 7 ; Unundocumented

set b,r        |    CB   11bbbrrr | ........ | 2
set b,(hl)     |    CB   11bbb110 | ........ | 4
set b,(ix+n)   | DD CB n 11bbb110 | ........ | 7
set b,(ix+n),r | DD CB n 11bbbrrr | ........ | 7 ; Unundocumented

; ''bit b,r'' performs something akin to ''r AND 2^b'',
; some flags reflect that:
  ; S:= r.7 AND b=7 
  ; P:= Z
; On the other hand, my CPC contradicts [USY]:
  ; 5 and 3 are copies of the operand (again, for bit b,r).

; DD CB undocumented opcodes are equivalent to e.g.
          ld a,(ix+n)
          res 6,a
          ld (ix+n),a
; This is *not* equivalent to:
          res 6,(ix+n)
          ld a,(ix+n)   ; !! No !! Not what happens with ROM.

; ====== Jump, Call and Return ====================================

jp nn       |    11000011 nn  | ........ | 3
jp ccc,nn   |    11ccc010 nn  | ........ | 3 ; See /ccc/
jp hl       |    E9           | ........ | 1 
jp ix       | DD E9           | ........ | 2

jr n        |    00011000 n-2 | ........ | 3 ; PC := PC + n
jr cc,nn    |    001cc000 n-2 | ........ | 3 or 2 if /cc/ not met
djnz n      |    00010000 n-2 | ........ | 4 or 3 when B reaches 0

call nn     |    11001101 nn  | ........ | 5
call ccc,nn |    11ccc100 nn  | ........ | 5 or 3 if /ccc/ not met
rst ttt     |    11ttt111     | ........ | 4

ret         |    11001001     | ........ | 3
ret ccc     |    11ccc000     | ........ | 4 or 2 if /ccc/ not met
reti        | ED 4D           | ........ | 4 ; See notes  
retn        | ED 45           | ........ | 4 ; See notes  

; The t-states for rst are 5-3-3. That''s why despite a total of 11,
; the instruction takes 4 NOPs on CPC.          

; For the same reason, ''ret ccc'' is slower to return than ''ret''. Sad.

; ''djnz'' doesn''t touch Z flag!

; Interruption related notes
; --------------------------

; ''reti'' and ''retn'' are equivalent.
;   Only their encoding differ, a fact detected by friend devices.
; They both copy iff2 to iff1. 
; On a naked CPC, those 2 flags are always equals,
;   so that does nothing more than a RET.
; A NMI (e.g. MultifaceII) only resets iff1, so the EI/DI state before
; the interruption can still be read, and is restored with RETN/RETI.  


; ====== Input and output =========================================

in a,(n)  |    11011011 n | ........ | 3 ; ''in a,(An)'' if you ask me
in r,(C)  | ED 01rrr000   | SZ503P0. | 4 ; ''in r,(BC)'' 
in 0,(C)  | ED 01110000   | SZ503P0. | 4 ; Unundocumented
ini       | ED A2         | !!!!!!!! | 5 ; B decremented after read
ind       | ED AA         | !!!!!!!! | 5 ; B decremented after read
inir      | ED B2         | !!!!!!!! | 6 / 5 for last iteration 
indr      | ED BA         | !!!!!!!! | 6 / 5 for last iteration

out (n),a |    11010011 n | ........ | 3 ; ''out (An),a''
out (C),r | ED 01rrr001   | ........ | 4 ; ''out (BC),r''
out (C),0 | ED 01110001   | ........ | 4 ; Unundocumented
outi      | ED A3         | !!!!!!!! | 5 ; B decremented before write
outd      | ED AB         | !!!!!!!! | 5 ; B decremented before write
outir     | ED B3         | !!!!!!!! | 6 / 5 for last iteration
outdr     | ED BB         | !!!!!!!! | 6 / 5 for last iteration

; ''in a,(n)'' and ''out (x),x'' doesn''t affect flags.

; ''in r,(c)'' and ''in 0,(c)'' affect S, Z, 5, 3 in the same usual way.
; E.g. Z set if read value is 0. 
; BTW ''in F,(c)'' is a misleading notation: value isn''t copied in F.
               ; Newer Z80s call it ''tst (c)''.

; -> Corralary tip:
          ld b,&F5:in 0,(c) ; Changes P flag depending on VSYNC!
; Since parity also depends on cas.in, printer.busy and /exp,
; that is quite brittle. Use at your own risk.

; For all block IO:
; S, Z, 5, 3: affected by dec B. 
; N: copy of bit 7 of value read or written. 

; For ini(r)          take n:= read value + (C+1 and &ff)
; For ind(r)          take n:= read value + (C-1 and &ff)
; For outi(r)/outd(r) take n:= written value + L (post operation)

; Now H & C := n > 255
    ; P is the parity of: (n & 7) xor B (post operation)

; Worth repeating:
; For ini/inir/ind/ind:      B is decremented after the read.
; For outi/outir/outd/outdr: B is decremented before the write.
; [Z80] is wrong.

; =================================================================

; ----------------------------------------------
Legend                  ; (wait for it...)
; ----------------------------------------------

  r: 8-bit reg. Encoding:        
rrr
; 000:b
; 001:c
; 010:d
; 011:e
; 100:h
; 101:l
; 111:a

  n:  8-bit value.
 nn: 16-bit value. Little endian encoding.

Flags: Initial of flag if changed in expected way.
     ; E.g. ''C'' means carry is set or reset depending on the result.
 ; S: Sign  (sign bit = most significant bit of A or HL)
 ; Z: Zero  (set if result is 0)
 ; 5: Internal (typically copy of bit 5 of the result)
 ; H: Half carry
 ; 3: Internal (typically copy of bit 3 of the result)
 ; P: Parity flag
 ; V: Overflow (signed overflow)
 ; N: 1 if previous arithmetic operation was a substraction.
 ; C: Carry  (unsigned overflow)

 ; 1: The flag is set
 ; 0: The flag is reset
 ; .: The flag is unchanged
 ; !: The flag is changed in a unusual way

ccc
 The condition ccc (jp, call, ret) is as follow:
; 000: NZ
; 001:  Z
; 010: NC
; 011:  C
; 100: PO Parity Odd / Signed Overflow / DI
; 101: PE Parity Even / No signed overflow / EI
; 110:  P Sign positive
; 111:  M Sing negative

cc
 The condition cc (jr) is as follow (like ccc with 0xx): 
; 00: NZ
; 01:  Z
; 10: NC
; 11:  C

; ---------------------------------------------------------------
Timing
; ---------------------------------------------------------------

The t-states are the number of cycles taken by each phase of the
instruction (decoding/exec/...).

The length (in NOPs) on CPC can be infered from those: 
  ; sum(ceil(t/4) for t in states)
For your convenience, it''s computed in NOPs column.

- DD or FD prefix without indirection (inc ixl) adds 4 t-states (1 NOP)
  ; -> That''s why they are not included in this doc!
- Dual operations take the same time: e.g. ld b,(hl) vs ld (hl),b
- NOP is a proper time unit! If your quartz is slow,
  ''inc c'' may not take 1 microsecond, yet it will still take "one NOP".
  ; Haters gonna nap.

; ---------------------------------------------------------------
Revisions
; ---------------------------------------------------------------

; v1.0.1 Still in April. Fix CPI tip: it doesn''t touch DE!
                       ; Fix copy/paste typo ''ld r,a'' and ''ld a,r''
; v1.0   2020 April.     Covid Edition.

; ---------------------------------------------------------------
References
; ---------------------------------------------------------------

; [Z80] Z80 reference manual.
; [USY] Undocumented Documented v0.91 by Sean Young.
; [Rus] Russian MSX forums on the dark nets.
; [Ams] Amstrad live.
; [Hub] Pomhub.
; [OvF] Overflow''s trash bin.
; [OvL] My very own tests on a real Z80-based machine.
      ; See "z80tests.o"
           _  _               _  _  _
-=- () |/ /= /'' /. /| /|/ /) /= /''_/'' -=-  20/20

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: doc
  SELECT id INTO tag_uuid FROM tags WHERE name = 'doc';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
