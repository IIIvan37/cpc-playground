-- Migration: Import z80code projects batch 81
-- Projects 161 to 162
-- Generated: 2026-01-25T21:43:30.206196

-- Project 161: z80.o-v1.0.5 by Madram
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'z80.o-v1.0.5',
    'Imported from z80Code. Author: Madram. PERFECTLY ACCURATE Z80 FLAGS AND CPC TIMING',
    'public',
    false,
    false,
    '2021-05-16T16:29:00.053000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '           _  _               _  _  _
-=- ().|/./=./ ./,./|./|/./)./=./._/'' -=-  21/20

; Perfectly accurate Z80 flags and CPC timing.
; Go to [Legend] by hitting CTRL-ENTER on this line. CTRL-RETURN go back
; Go to [Timing] notes.

; ======= 8-bit Load ==========================================

; Mnemonic  | Opcodes       | SZ5H3VNC | NOPs  ; Notes
ld r,r''     |    01rrr''''''   | ........ | 1     ; See [rrr] (CTRL-ENTER)
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
ex (sp),hl  |    E3 | ........ | 6   ; pop tmp:push hl:ld hl,tmp
ex (sp),ix  | DD E3 | ........ | 7   ; pop tmp:push ix:ld ix,tmp

ldi         | ED A0 | ..!0!!0. | 5   ; See [transfer_notes] below
ldd         | ED A8 | ..!0!!0. | 5  
ldir        | ED B0 | ..!0!00. | 6 / 5 for last iteration.
lddr        | ED B8 | ..!0!00. | 6 / 5 for last iteration.

cpi         | ED A1 | SZ!H!!1. | 4   ; See [search_notes] below
cpd         | ED A9 | SZ!H!!1. | 4  
cpir        | ED B1 | SZ!H!!1. | 6 / 4 for last iteration.
cpdr        | ED B9 | SZ!H!!1. | 6 / 4 for last iteration.

transfer_notes
; After ldi/ldd/ldir/lddr:
  ; P/V reset iif BC reached 0, set otherwise.
  ; Let n := A + (last) copied byte. 
     ;  - 5 if a copy of n.1
     ;  - 3 if a copy of n.3          

search_notes
  ; P/V reset only if BC reached 0, set otherwise. P/V = bool(BC <> 0)
  ; -> corollary tip: inc hl, dec bc, loop while bc in 7 Nops, 5 bytes. 
          cpi:jp pe,loop

  ; N is set because of the underlying cp (hl), aka "a - (hl)"
  ; Z is set according to the result of the comparaison.
    ; That explains why P/V is used as "BC > 0".
  ; Weird behavior of other flags: TODO if interest is there. See [USY]

timing_notes
; ldir/lddr/cpir/cpdr take:
  ; 6 NOPs while BC > 1
  ; 5 NOPs for the last iteration (ldir/lddr)
  ; 4 NOPs for the last iteration (cpir/cpdr)

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

; ---- Same model as add ----
adc r      |    10001rrr   | SZ5H3V0C | 1 ; A := A + [r + Carry]
sub r      |    10010rrr   | SZ5H3V1C | 1 ; A := A - r
sbc r      |    10011rrr   | SZ5H3V1C | 1 ; A := A - [r + Carry]
and r      |    10100rrr   | SZ5H3P00 | 1 
 or r      |    10101rrr   | SZ5H3P00 | 1 
xor r      |    10110rrr   | SZ5H3P00 | 1 
cp  r      |    10111rrr   | SZ5H3V1C | 1 ; Flags like sub r

inc r      |    00rrr100   | SZ5H3V0. | 1 
inc (hl)   |    00110100   | SZ5H3V0. | 3
inc (ix+n) | DD 00110100 n | SZ5H3V0. | 6
dec r      |    00rrr101   | SZ5H3V1. | 1 
dec (hl)   |    00110101   | SZ5H3V1. | 3
dec (ix+n) | DD 00110101 n | SZ5H3V1. | 6

; Tips:                        
          add a         ; Shorter sla a
          adc a         ; Shorter rl a (that is, rla + update S,Z,P).
          sbc a         ; A=-1 if Carry, 0 if NC, carry unchanged.
          or a          ; NC, Z/NZ 
          xor a         ; NC, Z, A=0
          cp a          ; NC, Z, without changing A

; ======= 16-bit Arithmetic =======================================

add hl,rr   |    00rr1001 | ..!!!.0C | 3 ; rr: BC=00 DE=01 HL=10 SP=11
add ix,rr   | DD 00rr1001 | ..!!!.0C | 4 ;                 IX=10 
adc hl,rr   | ED 01rr1010 | SZ!!!V0C | 4 ;                 HL=10
sbc hl,rr   | ED 01rr0010 | SZ!!!V1C | 4 ;                 HL=10
inc rr      |    00rr0011 | ........ | 2 ;                 HL=10 
inc ix      | DD 00100011 | ........ | 3 ;                 IX=10 
dec rr      |    00rr1011 | ........ | 2 ;                 HL=10 
dec ix      | DD 00101011 | ........ | 3 ;                 IX=10 

; Flags 5, H, 3 are affected by the operation on H, as if:
     ; ld a,l:add rr.l
     ; ld a,h:adc rr.h  

; ====== General-purpose arithmetic and cpu control ================

daa  |    27 | SZ5H3P.C | 1  ; See [Ams]
neg  | ED 44 | SZ5H3V1C | 2  ; A := 0 - A (all flags like sub)
cpl  |    2F | ..513.1. | 1  ; A := not A (all bits inversed)
ccf  |    3F | ..!!!.0C | 1  ; Carry := not Carry
scf  |    37 | ..!0!.01 | 1
nop  |    00 | ........ | 1  ; Chany''s most used instruction 
halt |    76 | ........ | 1  ; Grim''s favorite
di   |    F3 | ........ | 1  
ei   |    FB | ........ | 1      
; --- IM determines what is executed when an interrupt is accepted ---
im 0 | ED 46 | ........ | 2  ; Opcode. Undefined on CPC (high impedance)
im 1 | ED 56 | ........ | 2  ; RST &38
im 2 | ED 5E | ........ | 2  ; JP (I*&100+??) ??: random, high impedance

; After ''ccf'' or ''scf'':
   ; H = not Carry
   ; Flag 5 & 3 copied from A (as if operation was involving A).

; Since ''neg'' is litteraly A := 0 - A, carry is set iif A wasn''t 0.
; -> corallary tip. Multiplication by 255:
          neg:ld l,a:sbc a:sub l:ld h,a ; HL = A * 255

; ''neg'' equivalent that doesn''t change carry:
          cpl:inc a     ; A := -A without carry update
          dec a:cpl     ; Equivalent variant    
; -> corollary tip. Fast multiplication by 255 when A>0:
          dec a:ld h,a:cpl:ld l,a

; ====== Rotate and shift ==========================================

rlca         |       00000111   | ..503.0C | 1  ; rlc a without S, Z, P
rrca         |       00001111   | ..503.0C | 1  ; rrc a without S, Z, P
rla          |       00010111   | ..503.0C | 1  ; rl  a without S, Z, P
rra          |       00011111   | ..503.0C | 1  ; rr  a without S, Z, P

rlc r        |    CB 00000rrr   | SZ503P0C | 2 
rlc (hl)     |    CB 00000110   | SZ503P0C | 4
rlc (ix+n)   | DD CB 00000110 n | SZ503P0C | 7
rlc (ix+n),r | DD CB 00000rrr n | SZ503P0C | 7  ; Unundocumented

; ---- Same model as rlc ----
rrc r        |    CB 00001rrr   | SZ503P0C | 2  
rl r         |    CB 00010rrr   | SZ503P0C | 2  ; ''adc a'' faster for r=a
rr r         |    CB 00011rrr   | SZ503P0C | 2  
sla r        |    CB 00100rrr   | SZ503P0C | 2  ; ''add a'' faster for r=a
sra r        |    CB 00101rrr   | SZ503P0C | 2  
sl1 r        |    CB 00110rrr   | SZ503P0C | 2  ; Unundocumented
srl r        |    CB 00111rrr   | SZ503P0C | 2  

rld          |    ED 6F         | SZ503P0. | 5 
rrd          |    ED 67         | SZ503P0. | 5 

;  rlc:  Ca <- 7<-----0 <- b7    rrc: b0 -> 7----->0 -> Ca
;   rl:  Ca <- 7<-----0 <- Ca     rr: Ca -> 7----->0 -> Ca
;  sla:  Ca <- 7<-----0 <- 0     sra:       7----->0 -> Ca (7 unchanged)
;  sl1:  Ca <- 7<-----0 <- 1     srl:  0 -> 7----->0 -> Ca 

;    rld: Before  A=pq (hl)=rs    rrd: Before A=pq (hl)=rs
        ;  After  A=pr (hl)=sq          After A=ps (hl)=qr

; DD CB undocumented opcodes are equivalent to e.g.
          ld b,(ix+n)
          sla b
          ld (ix+n),b
; They are *not* equivalent to:
          sla (ix+n)
          ld b,(ix+n)   ; !! No !! Not what happens when ix points ROM.

; ====== Bit test, reset, set =====================================

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
; 000: NZ (When Z = 0)
; 001:  Z (When Z = 1)
; 010: NC (When C = 0)
; 011:  C (When C = 1)
; 100: PO (When P/V = 0) Parity Odd / Signed Overflow / DI / BC = 0
; 101: PE (When P/V = 1) Parity Even / No signed overflow / EI / BC <> 0
; 110:  P (When S = 0) Sign positive
; 111:  M (When S = 1) Sign negative

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
  ; sum(ceil(t/4) for t in states)  !! Except for OUT (c),r
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

; v1.0.4 2021 January    Fix cpir/cpdr timings. (6 nops when looping)
                       ; Enhance some comments.
; v1.0.3 Tuesday.        Fix cpi(r)/cpd(r) timings.  
; v1.0.2 April 25th.     Rotate & shift cheat sheet.  
                       ; Fix flags ADD 16 bits.
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

-- Project 162: fade-in 2 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fade-in 2',
    'Imported from z80Code. Author: gurneyh. Transition "plasma"',
    'public',
    false,
    false,
    '2019-11-20T18:37:24.686000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
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
               	
                res 7, h
                ld a, (hl) 
                and c
                set 7, h
                or (hl)
                ld (hl), a 

                ld a, h 
                add a, 8 
                ld h, a 
                
                res 7, h
                ld a, (hl)
                and c
                set 7, h
                or (hl)
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
db 187, 187, 187, 187, 187, 188, 190, 193, 196, 198, 199, 199, 196, 194, 192, 190, 189, 189, 190, 191, 194, 197, 202, 208, 215, 223, 231, 237, 241, 243, 243, 242
db 186, 186, 186, 186, 186, 187, 188, 191, 194, 196, 197, 196, 194, 191, 189, 187, 186, 186, 187, 188, 191, 195, 199, 205, 213, 221, 229, 236, 240, 242, 242, 241
db 185, 185, 184, 184, 184, 185, 187, 189, 191, 194, 194, 193, 191, 188, 185, 184, 183, 183, 183, 185, 188, 192, 197, 203, 211, 219, 227, 234, 238, 241, 241, 240
db 184, 184, 183, 183, 183, 184, 185, 187, 189, 191, 192, 190, 188, 185, 182, 180, 179, 179, 180, 182, 185, 189, 194, 201, 208, 217, 225, 232, 237, 239, 240, 239
db 183, 183, 182, 182, 182, 182, 183, 185, 187, 189, 189, 187, 185, 182, 179, 177, 176, 176, 177, 179, 182, 186, 192, 198, 206, 215, 224, 231, 235, 238, 239, 238
db 183, 182, 181, 181, 181, 181, 182, 183, 185, 187, 187, 185, 182, 178, 175, 173, 172, 172, 173, 176, 179, 183, 189, 196, 204, 213, 222, 229, 234, 237, 238, 237
db 182, 181, 181, 180, 179, 179, 180, 181, 183, 184, 184, 182, 179, 175, 172, 169, 168, 168, 170, 172, 176, 181, 187, 194, 202, 211, 220, 228, 233, 236, 237, 236
db 182, 181, 180, 179, 178, 178, 179, 180, 182, 182, 182, 180, 176, 172, 168, 166, 164, 165, 166, 169, 173, 178, 184, 192, 200, 210, 219, 226, 232, 235, 236, 235
db 181, 180, 179, 178, 178, 177, 178, 179, 180, 181, 180, 177, 173, 169, 165, 162, 160, 161, 163, 166, 171, 176, 182, 190, 199, 208, 218, 225, 231, 234, 235, 234
db 181, 180, 179, 178, 177, 177, 177, 178, 179, 179, 178, 175, 171, 166, 162, 158, 156, 157, 160, 164, 168, 174, 181, 189, 198, 207, 216, 224, 230, 233, 234, 234
db 181, 180, 178, 177, 177, 176, 176, 177, 178, 178, 177, 174, 170, 164, 159, 155, 152, 154, 157, 162, 167, 173, 180, 188, 197, 206, 216, 223, 229, 232, 233, 233
db 181, 179, 178, 177, 176, 176, 176, 177, 178, 178, 177, 173, 169, 163, 158, 153, 148, 152, 156, 161, 166, 172, 179, 187, 196, 205, 215, 222, 228, 231, 232, 232
db 181, 180, 178, 177, 176, 176, 176, 177, 177, 178, 176, 173, 169, 163, 158, 154, 152, 153, 156, 161, 166, 172, 179, 187, 195, 205, 214, 221, 227, 230, 231, 231
db 181, 180, 179, 177, 177, 176, 176, 177, 177, 178, 177, 174, 169, 165, 160, 157, 155, 156, 158, 162, 167, 172, 179, 186, 195, 204, 213, 220, 225, 229, 230, 230
db 181, 180, 179, 178, 177, 176, 176, 177, 178, 178, 177, 174, 170, 166, 162, 159, 158, 158, 160, 164, 168, 173, 179, 186, 194, 203, 212, 219, 224, 227, 228, 228
db 182, 180, 179, 178, 177, 177, 177, 177, 178, 178, 177, 175, 171, 168, 164, 162, 161, 161, 163, 165, 169, 174, 180, 186, 194, 202, 210, 217, 222, 225, 226, 226
db 182, 181, 180, 179, 178, 177, 177, 178, 178, 179, 178, 176, 173, 169, 166, 164, 163, 163, 165, 167, 170, 175, 180, 186, 193, 201, 208, 215, 219, 222, 223, 223
db 183, 182, 181, 180, 179, 178, 178, 178, 179, 179, 178, 176, 174, 171, 168, 166, 166, 166, 167, 169, 172, 175, 180, 186, 192, 199, 206, 212, 216, 219, 220, 220
db 183, 182, 181, 180, 179, 179, 179, 179, 180, 180, 179, 177, 175, 172, 170, 169, 168, 168, 169, 171, 173, 176, 181, 186, 192, 198, 204, 210, 213, 216, 217, 217
db 184, 183, 182, 181, 181, 180, 180, 180, 181, 181, 180, 179, 177, 174, 172, 171, 170, 170, 171, 173, 175, 178, 182, 186, 192, 198, 203, 208, 212, 214, 215, 215
db 185, 184, 183, 182, 182, 181, 181, 182, 182, 183, 182, 181, 179, 177, 175, 174, 173, 173, 174, 175, 177, 180, 184, 188, 193, 198, 204, 209, 212, 214, 215, 215
db 186, 185, 184, 184, 183, 183, 183, 184, 184, 185, 185, 184, 182, 180, 178, 177, 176, 176, 177, 178, 180, 183, 186, 190, 195, 201, 206, 210, 213, 215, 216, 216


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
 org #4000
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
