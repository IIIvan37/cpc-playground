-- Migration: Import z80code projects batch 40
-- Projects 79 to 80
-- Generated: 2026-01-25T21:43:30.194856

-- Project 79: program370 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program370',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2023-04-09T10:38:39.605000'::timestamptz,
    '2023-04-10T21:47:01.687000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';les boucles REPEAT démarre leur compteur à 0                
module Move
R1              equ 32



start
                di
                ld hl, #c9fb
                ld (#38), hl
                ei

                ld bc, #bc01
                out (c), c
                inc b
                ld a, R1
                out (c), a
                
                ld a, 0
                ld (angle), a
 
 main
                 call init

.loop
                ld hl, (x)
                ld de, (dx)
                add hl, de
                ld (x), hl
                
                ld a, h
                cp 255
                jr nc, .out
                
                ld hl, (y)
                ld de, (dy) 
                add hl, de
                ld (y), hl
                
                ; check bounds
                ld a, h
                cp 200
                jr nc, .out


                ld hl, (x)
                ld a, h
                ld (plot.x + 1), a
                
                ld hl, (y)
                ld a, h
                ld (plot.y + 1), a

                call plot
                jr .loop
 
 .out
                ld a, (angle)
                inc a
                ld (angle), a

                call init
                jp .loop


init
                
                ld a, (angle)
                ; on récupère l''incrément dy pour un angle donné
                ld h, hi(sin_table)
                ld l, a
                ld e, (hl)
                inc h
                ld d, (hl)
                ld (dy), de
                
                ; on récupère l''incrément dx pour un angle donne
                ; la fonction cosinus est identique à la fonction sin
                ; mais un décalage de 90°
                ; pour nous 90 => 64
                ld a, (angle)
                add 64
                ld h, hi(sin_table)
                ld l, a
                ld e, (hl)
                inc h
                ld d, (hl)
                ld (dx), de
                
                ; on se replace au centre de l''écran
                ld hl, 128 * #100
                ld (x), hl
                ld hl, 100 * #100
                ld (y), hl
                ret
                
 plot:
               
                ld h, hi(adr)
.y:	            ld l, 0
	            ld e, (hl)
	            inc h
	            ld d, (hl)
	            ex hl, de
	
.x:	            ld e, 0
	            ld a, e
	            srl e : srl e
	            ld d, 0
	            add hl, de
	
	            ld c, %10001000		;Bitmask for MODE 1
	            and 3		; a = X MOD 4
	            jr z , .nshift		;-> = 0, no shift
.shift 	        srl c		;move bitmask to pixel
	            dec a		;loop counter
	            jr nz, .shift		;-position

.nshift:	
.color	        ld a, #f0
	            xor (hl)
	            and c
	            xor (hl)
	            ld (hl), a
	           
	
	ret


align 4
colors:	db #00, #f0, #0f, #ff

angle          db 0
x              dw 128 * #100
y              dw 100 * #100
dx             dw 0
dy             dw 0
 
 

 
align 256
sin_table
repeat 256, ii
i = ii - 1
db lo(floor(256 * sin(i * 360 / 256)) & #ffff)
rend

repeat 256, ii
i = ii - 1
db hi(floor(256 * sin(i * 360 / 256)) & #ffff)
rend

adr
repeat 256, ii
i = ii - 1
v = #c000 + floor(i / 8) * R1 * 2 + (i % 8) * #800
db lo(v)
rend

repeat 256, ii
i = ii - 1
v = #c000 + floor(i / 8) * R1 * 2 + (i % 8) * #800
db hi(v)
rend

module off',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 80: commando by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'commando',
    'Imported from z80Code. Author: siko. Commande by Elite (1985), disassembled',
    'public',
    false,
    false,
    '2020-05-08T14:16:13.734000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org 0
run #52a

data0000 db #1
db #89
lab0002 db #7f
lab0003 db #ed
lab0004 db #49
lab0005 db #c3
lab0006 db #91
db #05,#c3,#8a
lab000A db #b9
db #c3
lab000C db #84
db #b9
lab000E db #c5
db #c9,#c3
lab0011 db #1d
db #ba,#c3
lab0014 db #17
lab0015 db #ba
lab0016 db #d5
db #c9
lab0018 db #c3
lab0019 db #c7
db #b9,#c3
lab001C db #b9
db #b9,#e9,#00
lab0020 db #c3
db #c6,#ba,#c3,#c1,#b9,#00,#00,#c3
db #35,#ba,#00,#ed,#49,#d9,#fb,#c7 ;....I...
lab0031 db #d9
db #21,#2b,#00,#71,#18,#08,#c3 ;...q...
lab0039 db #41
db #b9,#c9
lab003C db #0
db #00,#00,#00
lab0040 db #0
lab0041 db #0
db #00,#00
lab0044 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab0050 db #0
lab0051 db #0
db #00,#00,#00
lab0055 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00
lab006A db #0
db #00
lab006C db #0
db #00
lab006E db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab0080 db #0
db #00
lab0082 db #0
db #00,#00,#00,#00,#00
lab0088 db #0
db #00,#00,#00,#00
lab008D db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab00A0 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab00BB db #0
db #00,#00,#00,#00
lab00C0 db #0
lab00C1 db #0
lab00C2 db #0
lab00C3 db #0
db #00,#00,#00,#00,#00,#00
lab00CA db #0
db #00
lab00CC db #0
lab00CD db #0
lab00CE db #0
lab00CF db #0
lab00D0 db #0
lab00D1 db #0
db #00,#00,#00
lab00D5 db #0
db #00,#00
lab00D8 db #0
db #00
lab00DA db #0
db #00,#00,#00,#00,#00
lab00E0 db #0
db #00,#00,#00
lab00E4 db #0
lab00E5 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab00F0 db #0
db #00,#00
lab00F3 db #0
db #00,#00,#00
lab00F7 db #0
lab00F8 db #0
db #00,#00
lab00FB db #0
lab00FC db #0
db #00
lab00FE db #0
lab00FF db #0
db #c3,#50,#15,#c3 ;.P..
lab0104 db #79
db #15,#c3,#0b,#15,#c3,#00,#00,#c3
db #72,#11,#c3,#72,#11,#c3 ;r..r..
lab0113 db #c
db #11
lab0115 jp lab0340
data0118 db #c3
db #a7,#14,#c3,#69,#14 ;...i.
lab011E db #c3
db #2a,#05,#c3,#5b,#0e
lab0124 jp lab103C
lab0127 jp lab0139
lab012A jp lab01B7
lab012D jp lab1781
lab0130 jp lab07AB
lab0133 jp lab163D
lab0136 jp lab178B
lab0139 ld hl,data01f8
    ld de,lab0005
    ld b,#5
lab0141 ld a,(hl)
    cp #80
    call nz,lab014B
    add hl,de
    djnz lab0141
    ret 
lab014B push hl
    add hl,de
    dec hl
    dec (hl)
    jr z,lab0153
    pop hl
    ret 
lab0153 ld (hl),#3
    pop hl
    push hl
    push de
    push bc
    ld ix,lab0211
    ld a,(hl)
    ld (ix+0),a
    ld (ix+4),a
    inc hl
    ld b,(hl)
    ld (ix+1),b
    ld a,r
    jp p,lab0170
    inc (hl)
    inc b
lab0170 ld (ix+5),b
    inc hl
    ld a,(hl)
    call lab01A5
    ld (ix+2),a
    ld (ix+3),b
    inc (hl)
    ld a,(hl)
    add a,a
    add a,a
    xor #c
    or #7
    ld c,a
    ld a,#9
    di
    call lab178B
    ei
    ld a,(hl)
    call lab01A5
    ld (ix+6),a
    ld (ix+7),b
    jr nc,lab019E
    dec hl
    dec hl
    ld (hl),#80
lab019E call lab1C0F
    pop bc
    pop de
    pop hl
    ret 
lab01A5 or a
    jr z,lab01B4
    dec a
    ld c,a
    and #1
    add a,#27
    ld b,a
    ld a,c
    cp #3
    ccf 
    ret nc
lab01B4 ld b,#0
    ret 
lab01B7 push hl
    ld hl,data01f8
    ld de,lab0005
    ld b,#5
    ld a,#80
lab01C2 cp (hl)
    jr z,lab01CA
    add hl,de
    djnz lab01C2
    pop hl
    ret 
lab01CA pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),#0
    inc hl
    inc hl
    ld (hl),#1
    ret 
lab01D6 ld ix,lab0211
    ld (ix+8),#4
    ld (ix+9),#5f
lab01E2 ld (ix+10),#a
    ld (ix+11),#0
    ld hl,data01f8
    ld de,lab0005
    ld b,#5
lab01F2 ld (hl),#80
    add hl,de
    djnz lab01F2
    ret 
data01f8 db #0
db #00,#00,#00,#00,#00,#00
lab01FF db #0
db #00,#00,#00
lab0203 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab0211 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab0225 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab025D ld hl,data02e8
    ld (lab032F),hl
    ld a,#1
    ld (lab0331),a
    ret 
lab0269 ld a,(lab0331)
    dec a
    ld (lab0331),a
    call z,lab02AB
    ld e,#2
lab0275 ld bc,lab4006+1
    ld hl,labF5FF
lab027B push de
    ld de,lab0332
    dec e
    ld a,e
    add a,c
    add a,c
    ld e,a
    ex de,hl
    rl (hl)
    ex de,hl
    dec e
    ld a,(de)
    jr nc,lab028E
    or #8
lab028E add a,a
    ld (de),a
    pop de
    ld d,#8
lab0293 ld a,(hl)
    jr nc,lab0297
    or d
lab0297 add a,a
    ld (hl),a
    dec l
    djnz lab0293
    ld l,#ff
    ld a,h
    sub #8
    ld h,a
    ld b,#40
    dec c
    jr nz,lab027B
    dec e
    jr nz,lab0275
    ret 
lab02AB ld a,#4
    ld (lab0331),a
    ld hl,(lab032F)
    ld a,(hl)
    cp #1f
    jr z,lab02E1
    inc hl
    ld (lab032F),hl
    cp #20
    jr nz,lab02C2
    ld a,#2f
lab02C2 ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,labD488
    add hl,de
    ld de,lab0332
    ld b,#7
lab02D1 ld a,(hl)
    and #f0
    ld (de),a
    inc de
    ld a,(hl)
    inc hl
    add a,a
    add a,a
    add a,a
    add a,a
    ld (de),a
    inc de
    djnz lab02D1
    ret 
lab02E1 ld hl,data02e8
    ld (lab032F),hl
    ret 
data02e8 db #50
db #52,#45,#53,#53,#20,#53,#20,#54 ;RESS.S.T
db #4f,#20,#53,#54,#41,#52,#54,#20 ;O.START.
db #47,#41,#4d,#45,#20,#20,#50,#52 ;GAME..PR
db #45,#53,#53,#20,#4a,#20,#46,#4f ;ESS.J.FO
db #52,#20,#4a,#4f,#59,#53,#54,#49 ;R.JOYSTI
db #43,#4b,#20,#20,#50,#52,#45,#53 ;CK..PRES
db #53,#20,#4b,#20,#54,#4f,#20,#52 ;S.K.TO.R
db #45,#44,#45,#46,#49,#4e,#45,#20 ;EDEFINE.
db #4b,#45,#59,#53,#20,#1f ;KEYS..
lab032F db #0
db #00
lab0331 db #0
lab0332 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab0340 ld a,(labEF69)
    push af
    ld a,#7
    sub c
    ld e,a
    add a,#68
    ld l,a
    ld h,#ef
    ld c,#0
lab034F dec l
    ld d,#1
lab0352 ld a,(hl)
    add a,b
lab0354 cp #3a
    jr c,lab035D
    sub #a
    inc d
    jr lab0354
lab035D ld (hl),a
    inc c
    dec e
    jr z,lab0365
    ld b,d
    djnz lab034F
lab0365 ld d,#c0
    inc e
    sla e
lab036A ld a,(hl)
    inc l
    sub #30
    push hl
    add a,a
    add a,a
    add a,#60
    ld l,a
    ld h,#d7
    adc a,h
    sub l
    ld h,a
    ld b,#4
lab037B ld a,(hl)
    rra 
    rra 
    and #30
    or #c0
    ld (de),a
    inc e
    ld a,(hl)
    and #30
    or #c0
    ld (de),a
    set 3,d
    ld a,(hl)
    add a,a
    add a,a
    add a,a
    add a,a
    and #30
    or #c0
    ld (de),a
    dec e
    ld a,(hl)
    inc l
    add a,a
    add a,a
    and #30
    or #c0
    ld (de),a
    ld a,d
    add a,#8
    ld d,a
    djnz lab037B
    ld d,#c0
    inc e
    inc e
    pop hl
    dec c
    jr nz,lab036A
    pop af
    cp (iy+105)
    ret z
    ld hl,labEF66
    inc (hl)
    ld a,(hl)
    cp #a
    ret nc
    add a,#30
    ld de,labC02A
    call lab142E
    ret 
lab03C4 ld a,h
    push af
    srl h
    sla l
    sla l
    call lab3489
    pop af
    rrca 
    ret nc
    set 3,h
    ret 
data03d5 db #ed
db #73,#02,#ef,#11,#00,#00,#f9,#d5 ;s.......
db #d5,#d5,#d5,#d5,#d5,#d5,#d5,#d5
db #d5,#7c,#c6,#08,#67,#30,#08,#7d ;....g...
db #c6,#40,#6f,#7c,#ce,#c0,#67,#10 ;..o...g.
db #e5,#ed,#7b,#02,#ef,#c9,#3a,#3c
db #ef,#fe
lab0400 db #a1
db #20,#01,#c9,#cb,#6f,#28,#2c,#f5 ;....o...
db #21,#5a,#c2,#e6,#1f,#cb,#3f,#3c ;.Z......
db #47,#cd,#d5,#03,#f1,#f5,#e6,#1f ;G.......
db #cb,#3f,#ee,#0f,#28,#06,#47,#cd ;......G.
db #8c,#34,#10,#fb,#f1,#f5,#e6,#1f
db #cb,#3f,#d6,#10,#ed,#44,#47,#cd ;.....DG.
db #d5,#03,#f1,#3c,#32,#3c,#ef,#3d
db #67,#cb,#77,#20,#20,#cb,#6f,#7c ;g.w...o.
db #28,#04,#e6,#1f,#ee,#1f,#e6,#1f
db #67,#3e,#1f,#06,#20,#11,#00,#00 ;g.......
db #94,#30,#06,#c6,#20,#cd,#7e,#04
db #14,#1c,#10,#f4,#c9,#cb,#6f,#7c ;......o.
db #28,#04,#e6,#1f,#ee,#1f,#e6,#1f
db #67,#3e,#1f,#06,#20,#11,#1f,#00 ;g.......
db #94,#30,#06,#c6,#20,#cd,#7e,#04
db #14,#1d,#10,#f4,#c9,#f5,#d5,#e5
db #c5,#d9,#11,#00,#c6,#d9,#2e,#03
db #3a,#3c,#ef,#3d,#cb,#6f,#28,#02 ;.....o..
db #ee,#1f,#e6,#1f,#c6,#91,#67,#01 ;......g.
db #0a,#00,#cd,#d9,#04,#c1,#e1,#d1
db #f1,#c9
lab04A3 ld a,(labEF3B)
    ld h,a
    inc a
    ld (labEF3B),a
    ld a,#1f
    ld b,#20
    ld de,data0000
lab04B2 sub h
    jr nc,lab04BB
    add a,#20
    call lab04BF
    inc d
lab04BB inc e
    djnz lab04B2
    ret 
lab04BF push af
    push de
    push hl
    push bc
    exx
    ld de,labC740
    exx
    ld l,#5
    ld a,(labEF3B)
    ld h,a
    ld bc,lab0016
    call lab04D9
    pop bc
    pop hl
    pop de
    pop af
    ret 
lab04D9 ld a,#1f
    sub d
    srl h
    add a,h
    sub #10
    ld h,a
    call lab03C4
    push hl
    ld a,#1f
    sub e
    ld e,a
    ld h,c
    call lab1C0C
    exx
    push de
    exx
    pop de
    add hl,de
    ld a,h
    cp #c8
    jr c,lab04FB
    add a,#6
    ld h,a
lab04FB pop de
    xor a
lab04FD ld a,(hl)
    and #f0
lab0500 ld b,a
    srl a
    srl a
    srl a
    srl a
    bit 2,(iy+7)
    jr z,lab0510
    or b
lab0510 ld (de),a
    inc e
    ld a,(hl)
    add a,a
    add a,a
    add a,a
    add a,a
    ld b,a
    ld a,(hl)
    and #f
    bit 2,(iy+7)
    jr z,lab0522
    or b
lab0522 ld (de),a
    inc e
    inc hl
    dec c
    jp nz,lab04FD
    ret 
    ld sp,labE000
    call lab5321
    call lab1580
    call lab15CA
    call lab1638
    call lab150B
    set 1,(iy+7)
    ld hl,labEF2B
    ld (labEF29),hl
    xor a
    ld (labEF27),a
    ld (labEF18),a
    ld (labEF04),a
    ei
    call lab15F1
    call lab0D8A
    call lab0641
    call lab0690
    call lab0CEE
    call lab0D66
    jr z,lab057A
    call lab025D
lab0568 bit 0,(iy+7)
    jr z,lab0575
    call lab0269
    res 0,(iy+7)
lab0575 call lab0D66
    jr nz,lab0568
lab057A push af
    call lab0690
    pop af
    cp #53
    jp z,lab06FB
    cp #4a
    jp z,lab0CBE
    call lab1166
    jr lab0590
data058e db #16
db #0c
lab0590 db #0
db #19,#01,#52,#45,#44,#45,#46,#49 ;..REDEFI
db #4e,#45,#09,#4b,#45,#59,#53,#16 ;NE.KEYS.
db #16,#00,#19,#00,#18,#00,#1f,#21
db #c8,#10,#06,#0c,#36,#00,#23,#10
db #fb,#06,#06,#21,#03,#06,#c5,#cd
db #e4,#0c,#e5,#cd,#86,#34,#76,#cd ;......v.
db #83,#06,#4f,#e5,#cd,#ec,#05,#e1 ;..O.....
db #38,#f4,#3a,#19,#ef,#77,#23,#3a ;.....w..
db #1a,#ef,#77,#79,#cd,#22,#11,#cd ;..wy....
db #66,#11,#03,#04,#0d,#1f,#e1,#23 ;f.......
db #23,#c1,#10,#d2,#fd,#36,#04,#00
db #c3,#65,#05,#21,#c8,#10,#06,#06 ;.e......
db #3a,#19,#ef,#be,#23,#20,#06,#3a
db #1a,#ef,#be,#37,#c8,#23,#10
lab0600 db #f0
db #b7,#c9,#55,#50,#03,#0d,#2e,#1f ;..UP....
db #cc,#10,#44,#4f,#57,#4e,#03,#0b ;..DOWN..
db #2e,#1f,#ce,#10,#4c,#45,#46,#54 ;....LEFT
db #03,#0b,#2e,#1f,#d0,#10,#52,#49 ;......RI
db #47,#48,#54,#03,#0a,#2e,#1f,#d2 ;GHT.....
db #10,#46,#49,#52,#45,#03,#0b,#2e ;.FIRE...
db #1f,#ca,#10,#47,#52,#45,#4e,#41 ;...GRENA
db #44,#45,#03,#08,#2e,#1f,#c8,#10 ;DE......
lab0641 res 2,(iy+7)
    xor a
    ld (labEF3B),a
    ld hl,labF10C
    ld b,#5
    ld de,labDE00
lab0651 push bc
    push hl
    ld b,#14
lab0655 ld a,(de)
    and #f0
    ld c,a
    srl a
    srl a
    srl a
    srl a
    or c
    ld (hl),a
    ld a,(de)
    and #f
    ld c,a
    add a,a
    add a,a
    add a,a
    add a,a
    or c
    inc de
    inc l
    ld (hl),a
    inc l
    djnz lab0655
    pop hl
    pop bc
    call lab348C
    djnz lab0651
    ld b,#20
lab067B push bc
    call lab04A3
    pop bc
    djnz lab067B
    ret 
data0683 db #3a
db #18,#ef,#b7,#20,#fa,#3a,#18,#ef
db #b7,#28,#fa,#c9
lab0690 res 3,(iy+7)
    ld hl,lab0600
    ld bc,lab2210
    call lab06A7
    ld hl,lab1600
    ld bc,lab4002
    call lab06A7
    ret 
lab06A7 sla c
    sla c
    sla c
    add hl,hl
    add hl,hl
    call lab3489
    ld d,b
lab06B3 push hl
    ld b,d
lab06B5 ld (hl),#0
    inc l
    djnz lab06B5
    pop hl
    call lab348C
    dec c
    jr nz,lab06B3
    ret 
data06c2 db #41
db #42,#43,#44,#45,#46,#47,#48,#49 ;BCDEFGHI
db #4a,#4b,#4c,#4d,#4e,#4f,#50,#51 ;JKLMNOPQ
db #52,#53,#54,#55,#56,#57,#58,#59 ;RSTUVWXY
db #5a,#3a,#3b,#3c,#3d,#3e,#3f ;Z......
lab06E2 ld hl,labC040
    ld bc,lab4017
    call lab110C
    ret 
lab06EC ld b,#5c
lab06EE push bc
    call lab1C03
    pop bc
    bit 4,(iy+21)
    ret nz
    djnz lab06EE
    ret 
lab06FB call data14a7
lab06FE call lab1469
    res 1,(iy+7)
    halt
    call lab1C06
    halt
    call lab1603
    call lab3D49
    call lab163D
    call lab1638
    halt
    set 1,(iy+7)
    bit 0,(iy+98)
    jr z,data0755
    ld hl,labEF67
    ld a,(hl)
    cp #7
    jr nc,lab072B
    ld (hl),#6
lab072B call lab07B1
    ld a,(labEF66)
    add a,#2f
    cp #3a
    ld de,labC02A
    call c,lab142E
    dec (iy+102)
    jp z,lab07EF
lab0741 ld hl,(labEF0A)
    dec hl
    dec hl
lab0746 dec hl
    dec hl
    ld a,(hl)
    cp #22
    jr nz,lab0746
    inc hl
    inc hl
    ld (labEF0A),hl
    jp lab06FE
data0755 db #cd
db #fa,#15,#af,#cd,#e2,#06,#cd,#a9
db #15,#cd,#66,#11,#19,#01,#16,#14 ;..f.....
db #09,#42,#52,#4f,#4b,#45,#20,#41 ;.BROKE.A
db #52,#45,#41,#20,#20,#1f,#cd,#d7 ;REA.....
db #07,#fd,#34,#65,#cd,#66,#11,#16 ;...e.f..
db #19,#06,#4e,#4f,#57,#20,#52,#55 ;..NOW.RU
db #53,#48,#20,#54,#4f,#20,#41,#52 ;SH.TO.AR
db #45,#41,#20,#20,#1f,#cd,#d7,#07 ;EA......
db #01,#04,#02,#cd,#40,#03,#01,#dc
db #05,#cd,#79,#15,#cd,#b6,#15,#cd ;..y.....
db #ba,#07,#c3,#fe,#06
lab07AB add a,(iy+103)
    ld (labEF67),a
lab07B1 ld a,(labEF67)
    push de
    ld de,labC03A
    jr lab07C1
data07ba db #3a
db #65,#ef,#d5,#11,#1a,#c0 ;e.....
lab07C1 push bc
    ld b,#2f
lab07C4 inc b
    sub #a
    jr nc,lab07C4
    push af
    ld a,b
    call lab142E
    pop af
    add a,#3a
    call lab142E
    pop bc
    pop de
    ret 
data07d7 db #3a
db #65,#ef,#c5,#06,#2f,#04,#d6,#0a ;e.......
db #30,#fb,#f5,#78,#cd,#72,#11,#f1 ;...x.r..
db #c6,#3a,#cd,#72,#11,#c1,#c9 ;...r...
lab07EF db #3e
db #11,#01,#e0,#7f,#16,#54,#3d,#ed ;.....T..
db #79,#ed,#51,#20,#f9,#cd,#66,#11 ;y.Q...f.
db #01,#00,#00,#1f,#cd,#f1
lab0806 db #15
db #cd,#ca,#15,#cd,#af,#15,#cd,#73 ;.......s
db #0c,#b7,#ca,#51,#05,#d6,#0b,#ed ;...Q....
db #44,#32,#39,#ef,#af,#32,#3a,#ef ;D.......
db #cd,#8a,#0d,#cd,#41,#06,#cd,#66 ;....A..f
db #11,#16,#0c,#01,#13,#01,#1f,#21
db #c2,#06,#0e,#04,#06,#08,#7e,#23
db #cd,#72,#11,#3e,#09,#cd,#72,#11 ;.r....r.
db #10,#f4,#cd,#66,#11,#03,#04,#0d ;...f....
db #1f,#0d,#20,#e8,#cd,#66,#11,#16 ;.....f..
db #20,#01,#18,#02,#19,#01,#45,#4e ;......EN
db #54,#45,#52,#20,#59,#4f,#55,#52 ;TER.YOUR
db #20,#4e,#41,#4d,#45,#19,#00,#13 ;.NAME...
db #00,#1f,#21,#f4,#0b,#11,#02,#0c
db #01,#0e,#00,#ed,#b0,#dd,#21,#02
db #0c,#06,#11,#c5,#dd,#34,#05,#cb
db #40,#28,#08,#3a,#08,#0c,#ee,#02
db #32,#08,#0c,#cd,#80,#34,#06,#f5
db #ed,#78,#e6,#01,#28,#fa,#c1,#10 ;.x......
db #e2,#af,#32,#08,#0c,#cd,#80,#34
db #cd,#67,#0c,#3e,#14,#32,#32,#ef ;.g......
db #af,#32,#36,#ef,#cd,#10,#0c,#3a
db #18,#ef,#b7,#20,#07,#3a,#05,#ef
db #e6,#1f,#28,#f3,#cd,#66,#11,#16 ;.....f..
db #20,#01,#03,#0f,#20,#18,#03,#1f
db #cd,#38,#0b,#cd,#b6,#0a,#fd,#36
db #38,#01,#01,#c0,#f5,#ed,#78,#e6 ;......x.
db #01,#28,#fa,#fd,#cb,#05,#66,#20 ;......f.
db #06,#fd,#36,#37,#00,#18,#07,#3a
db #37,#ef,#b7,#cc,#e9,#0a,#cd,#eb
db #09,#fd,#35,#38,#20,#07,#fd,#36
db #38,#02,#cd,#81,#09,#06,#f5,#ed
db #78,#e6,#01,#28,#fa,#dd,#21,#02 ;x.......
db #0c,#cd,#80,#34,#cd,#10,#0c,#3a
db #05,#ef,#e6,#0c,#ea,#21,#09,#fe
db #04,#3e,#01,#28,#02,#3e,#ff,#32
db #36,#ef,#3a,#32,#ef,#fd,#86,#36
db #fe,#13,#28,#11,#fe,#2d,#28,#0d
db #32,#32,#ef,#e6,#07,#fe,#04,#20
db #04,#af,#32,#36,#ef,#3a,#05,#ef
db #e6,#03,#ea,#4d,#09,#fe,#01,#28 ;...M....
db #02,#3e,#ff,#32,#0e,#0c,#dd,#4e ;.......N
db #0c,#cd,#66,#0b,#3a,#08,#0c,#b7 ;..f.....
db #20,#19,#dd,#cb,#04,#46,#20,#13 ;.....F..
db #dd,#36,#0c,#00,#3a,#0f,#0c,#fe
db #03,#28,#08,#3c,#38,#02,#d6,#02
db #32,#0f,#0c,#cd,#10,#0c,#c3,#d1
db #08,#cd,#83,#06,#cd,#90,#06,#c3
db #5a,#05,#21,#56,#0b,#06,#08,#c5 ;Z..V....
db #7e,#23,#4f,#3c,#28,#12,#7e,#cd ;..O.....
db #a4,#09,#34,#7e,#cd,#a4,#09,#7e
db #fe,#20,#20,#04,#2b,#36,#ff,#23
db #c1,#23,#10,#e3,#c9,#59,#57,#3e ;.....YW.
db #16,#cd,#72,#11,#79,#d6,#41,#30 ;..r.y.A.
db #02,#c6,#21,#e6,#f8,#cb,#3f,#c6
db #0c,#cd,#72,#11,#79,#fe,#41,#ce ;..r.y.A.
db #00,#3d,#e6,#07,#87,#3c,#cd,#72 ;.......r
db #11,#7a,#e6,#03,#0f,#30,#06,#3e ;.z......
db #03,#0e,#40,#18,#07,#b7,#3e,#03
db #28,#02,#3e,#01,#47,#3e,#18,#cd ;....G...
db #72,#11,#78,#cd,#72,#11,#79,#cd ;r.x.r.y.
db #72,#11,#4b,#c9,#dd,#21,#4a,#0b ;r.K...J.
db #06,#04,#dd,#7e,#00,#3c,#28,#13
db #cd,#20,#0b,#dd,#35,#02,#28,#13
db #dd
lab0A00 db #7e
db #01,#d6,#04,#dd,#77,#01,#cd,#20 ;....w...
db #0b,#11,#03,#00,#dd,#19
lab0A0F db #10
db #e0,#c9,#dd,#6e,#00,#dd,#66,#01 ;...n..f.
db #dd,#36,#00,#ff,#7c,#d6,#16,#e6
db #f8,#cb,#3d,#85,#21,#c2,#06,#cd
db #83,#34,#7e,#fe,#3f,#28,#5e,#c5
db #f5,#cd,#3d,#0a,#f1,#fe,#3e,#c4
db #c2,#0a,#c1,#18,#cd,#4f,#cd,#66 ;.....O.f
db #11,#18,#00,#16,#1f,#3a,#39,#ef
db #67,#87,#84,#c6,#0c,#cd,#72,#11 ;g.....r.
db #3a,#3a,#ef,#5f,#c6,#11,#cd,#72 ;.......r
db #11,#21,#3a,#ef,#79,#fe,#3e,#20 ;....y...
db #07,#1c,#1d,#c8,#35,#35,#0e,#0c
db #7e,#3c,#fe,#09,#c8,#77,#2b,#7e ;.....w..
db #87,#87,#87,#87,#96,#23,#86,#21
db #b6,#0d,#3d,#fe,#ff,#c8,#cd,#83
db #34,#79,#fe,#0c,#20,#03,#23,#0e ;.y......
db #20,#71,#c3,#72,#11,#dd,#21,#4a ;.q.r...J
db #0b,#06,#04,#11,#03,#00,#dd,#7e
db #00,#3c,#c4,#20,#0b,#dd,#19,#10
db #f5,#06,#14,#c5,#06,#0a,#76,#10 ;......v.
db #fd,#cd,#81,#09,#c1,#10,#f4,#c1
db #cd,#90,#06,#c3,#5a,#05,#21,#56 ;....Z..V
db #0b,#06,#08,#36,#ff,#23,#23,#10
db #fa,#c9,#4f,#21,#56,#0b,#06,#08 ;..O.V...
db #7e,#b9,#28,#12,#23,#23,#10,#f8
db #21,#56,#0b,#06,#08,#7e,#3c,#28 ;.V......
db #0b,#23,#23,#10,#f8,#c9,#23,#7e
db #e6,#03,#77,#c9,#71,#23,#36,#00 ;..w.q...
db #c9,#3e,#ff,#32,#37,#ef,#dd,#21
db #4a,#0b,#06,#04,#11,#03,#00,#dd ;J.......
db #7e,#00,#3c,#28,#05,#dd,#19,#10
db #f6,#c9,#3a,#06,#0c,#3c,#f6,#01
db #dd,#77,#00,#3e,#4e,#dd,#77,#01 ;.w..N.w.
db #fd,#96,#32,#d6,#06,#e6,#f8,#cb
db #3f,#cb,#3f,#c6,#02,#dd,#77,#02 ;......w.
db #dd,#6e,#00,#cb,#25,#cb,#25,#dd ;.n......
db #66,#01,#cd,#89,#34,#7e,#ee,#30 ;f.......
db #77,#cb,#dc,#7e,#ee,#30,#77,#c9 ;w.....w.
db #dd,#21,#4a,#0b,#11,#03,#00,#06 ;..J.....
db #04,#dd,#36,#00,#ff,#dd,#19,#10
db #f8,#c9,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#3a,#06
db #0c,#87,#87,#dd,#86,#06,#81,#47 ;.......G
db #fe,#ff,#c8,#fe,#39,#c8,#e6,#03
db #32,#08,#0c,#78,#cb,#3f,#cb,#3f ;...x....
db #32,#06,#0c,#3a,#08,#0c,#41,#0e ;......A.
db #02,#10,#06,#b7,#ca,#67,#0c,#18 ;.....g..
db #20,#04,#c8,#fe,#03,#28,#31,#11
db #07,#00,#21,#20,#02,#06,#10,#cb
db #26,#2b,#cb,#16,#2b,#cb,#16,#2b
db #cb,#16,#19,#10,#f2,#0d,#20,#e7
db #c9,#21,#1d,#02,#06,#10,#cb,#3e
db #23,#cb,#1e,#23,#cb,#1e,#23,#cb
db #1e,#23,#10,#f2,#0d,#20,#ea,#c9
db #21,#a4,#d7,#11,#1d,#02,#d9,#06
db #10,#d9,#4e,#23,#46,#23,#7e,#23 ;..N.F...
db #23,#cb,#27,#cb,#10,#cb,#11,#cb
db #27,#cb,#10,#cb,#11,#eb,#36,#00
db #23,#71,#23,#70,#23,#77,#23,#eb ;.q.p.w..
db #d9,#10,#de,#c9,#08,#3d,#00,#01
db #08,#3d,#00,#01,#48,#5f,#0a,#00 ;....H...
lab0C00 db #0
db #03,#00
lab0C03 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#3a,#06,#0c,#87
db #87,#6f ;.o
lab0C16 db #3a
db #32,#ef,#c6,#02,#67,#cd,#89,#34 ;....g...
db #06,#10,#11,#1d,#02,#4d,#1a,#e6 ;.....M..
db #f0,#ae,#77,#2c,#1a,#87,#87,#87 ;..w.....
db #87,#ae,#77,#2c,#13,#1a,#e6,#f0 ;..w.....
db #ae,#77,#2c,#1a,#87,#87,#87,#87 ;.w......
db #ae,#77,#2c,#13,#1a ;.w...
lab0C44 db #e6
db #f0,#ae,#77,#2c,#1a,#87,#87,#87 ;..w.....
db #87,#ae,#77,#2c,#13,#1a,#e6,#f0 ;..w.....
db #ae,#77,#2c,#1a,#87,#87,#87,#87 ;.w......
db #ae,#77,#13,#69,#cd,#8c,#34,#10 ;.w.i....
db #be,#c9,#21,#a4,#d7,#11,#1d,#02
db #01,#40,#00,#ed,#b0,#c9,#21,#68 ;.......h
db #ef,#11,#b0,#0d,#0e,#0b,#06,#0f
db #13,#10,#fd,#e5,#d5,#d9,#d1,#e1
db #06,#06,#1a
lab0C88 db #be
db #38,#0c,#20,#04,#23,#13,#10,#f6
db #d9,#0d,#20,#e6,#af,#c9,#d9,#79 ;.......y
db #f5,#3d,#28,#10,#d9,#21,#4b,#0e ;......K.
db #11,#5a,#0e,#01,#0f,#00,#ed,#b8 ;.Z......
db #3d,#20,#f8,#d9,#3e,#20,#d5,#06
db #09,#1b,#12,#10,#fc,#d1,#01,#06
db #00,#ed,#b0,#f1,#c9
lab0CBE call lab1166
    jr lab0CC5
data0cc3 db #16
db #18
lab0CC5 db #4
db #19,#01,#4a,#4f,#59,#53,#54,#49 ;..JOYSTI
db #43,#4b,#16,#1d,#04,#53,#45,#4c ;CK...SEL
db #45,#43,#54,#45,#44,#1f,#3e,#01 ;ECTED...
db #32,#04,#ef,#c3,#65,#05,#7e,#23 ;....e...
db #fe,#1f,#c8,#cd,#72,#11,#18,#f6 ;....r...
lab0CEE call lab0D72
    inc de
    nop
    ld d,#c
    ld (bc),a
    jr lab0CFA
data0cf8 db #19
db #01
lab0CFA db #50
db #55,#42,#4c,#49,#53,#48,#45,#44 ;UBLISHED
db #20,#42,#59,#1f,#3e,#40,#32,#3c ;.BY.....
db #ef,#fd,#cb,#07,#d6,#06,#60,#c5
db #cd,#fc,#03,#c1,#10,#f9,#cd,#72 ;.......r
db #0d,#16,#1d,#02,#18,#00,#43,#4f ;......CO
db #4e,#56,#45,#52,#54,#45,#44,#20 ;NVERTED.
db #42,#59,#04,#14,#01,#53,#49,#4d ;BY...SIM
db #4f,#4e,#20,#46,#52,#45,#45,#4d ;ON.FREEM
db #41,#4e,#04,#4b,#45,#49,#54,#48 ;AN.KEITH
db #20,#41,#4e,#44,#20,#4e,#49,#47 ;.AND.NIG
db #45,#4c,#04,#0d,#47,#52,#41,#50 ;EL..GRAP
db #48,#49,#43,#20,#20,#44,#45,#53 ;HIC..DES
db #49,#47,#4e,#04,#14,#06,#4a,#4f ;IGN...JO
db #4e,#1f,#c9 ;N..
lab0D66 ld a,(labEF18)
    cp #53
    ret z
    cp #4a
    ret z
    cp #4b
    ret 
lab0D72 ld b,#f5
lab0D74 in a,(c)
    and #1
    jr z,lab0D74
    call lab0D66
    pop hl
    ret z
    ld a,(hl)
    inc hl
    push hl
    cp #1f
    ret z
    call lab1172
    jr lab0D72
lab0D8A call lab1166
    ld bc,data0000
    rra 
    call lab1166
    inc de
    ld de,lab0C16
    ld de,lab0019
    rra 
    ld hl,data0db6
    ld c,#b
lab0DA1 ld b,#f
lab0DA3 ld a,(hl)
    call lab1172
    inc hl
    djnz lab0DA3
    ld a,#d
    call lab1172
    call lab1172
    dec c
    jr nz,lab0DA1
    ret 
data0db6 db #53
db #49,#4d,#4f,#4e,#20,#20,#20,#20 ;IMON....
db #30,#36,#30,#30,#30,#30,#4b,#45 ;......KE
db #49,#54,#48,#20,#20,#20,#20,#30 ;ITH.....
db #35,#30,#30,#30,#30,#4e,#49,#47 ;.....NIG
db #55,#4c,#20,#20,#20,#20,#30,#34 ;UL......
db #30,#30,#30,#30,#4a,#4f,#4e,#20 ;....JON.
db #20,#20,#20,#20,#20,#30,#33,#30
db #30,#30,#30,#52,#4f,#52,#59,#20 ;...RORY.
db #20,#20,#20,#20,#30,#32,#30,#30
db #30,#30,#4b,#41,#52,#45,#4e,#20 ;..KAREN.
db #20,#20,#20,#30,#31,#30,#30,#30
db #30,#53,#54,#55,#41,#52,#54,#20 ;.STUART.
db #20,#20,#30,#30,#39,#30,#30,#30
db #52,#41,#59,#20,#20,#20,#20,#20 ;RAY.....
db #20,#30,#30,#38,#30,#30,#30,#43 ;.......C
db #4c,#41,#52,#45,#20,#20,#20,#20 ;LARE....
db #30,#30,#37,#30,#30,#30,#43,#48 ;......CH
db #52,#49,#53,#20,#20,#20,#20,#30 ;RIS.....
db #30,#36,#30,#30,#30,#44,#41,#57 ;.....DAW
db #4e,#20,#20,#20,#20,#20,#30,#30 ;N.......
db #35,#30,#30,#30
lab0E5B db #22
db #0f,#ef,#21,#00,#00,#e3,#22,#12
db #ef,#22,#a8,#0e,#ed,#73,#0d,#ef ;.....s..
db #31,#00,#ef,#f5,#c5,#d5,#fd,#cb
db #07,#4e,#20,#32,#06,#f5,#ed,#78 ;.N.....x
db #f5,#cd,#4a,#0f,#f1,#e6,#01,#28 ;..J.....
db #15,#cd,#72,#10,#32,#05,#ef,#21 ;..r.....
db #42,#ef,#35,#20,#09,#36,#02,#fd ;B.......
db #cb,#07,#c6,#cd,#66,#16,#d1,#c1 ;....f...
db #f1,#2a,#0f,#ef,#ed,#7b,#0d,#ef
db #33,#33,#fb,#c3,#11,#ef,#06,#f5
db #ed,#78,#e6,#01,#28,#e8,#cd,#be ;.x......
db #0e,#32,#18,#ef,#ed,#43,#19,#ef ;.....C..
db #18,#c7,#af,#01,#0e,#f4,#ed,#49 ;.......I
db #01,#c0,#f6,#ed,#49,#ed,#79,#04 ;....I.y.
db #0e,#92,#ed,#49,#0e,#42,#21,#09 ;...I.B..
db #0f,#16,#08,#06,#f6,#ed,#49,#06 ;......I.
db #f4,#ed,#78,#2f,#b7,#20,#10,#7d ;..x.....
db #c6,#08,#6f,#8c,#95,#67,#0c,#15 ;..o..g..
db #20,#e9,#7a,#42,#4a,#18,#0a,#06 ;..zBJ...
db #00,#37,#23,#cb,#10,#0f,#30,#fa
db #7e,#c5,#01,#82
lab0F00 db #f7
db #ed,#49 ;.I
lab0F03 db #5
db #0e,#00,#ed,#49,#c1,#c9,#00,#00 ;...I....
db #0d,#00,#00,#01,#00,#00,#00,#00
db #00,#50,#00,#00,#00,#00,#30,#39 ;.P......
db #4f,#49,#4c,#4b,#4d,#00,#38,#37 ;OILKM...
db #55,#59,#48,#4a,#4e,#20,#36,#35 ;UYHJN...
db #52,#54,#47,#46 ;RTGF
lab0F30 db #42
db #56,#34,#33,#45,#57,#53,#44,#43 ;V..EWSDC
db #58,#31,#32,#02,#51,#00,#41,#00 ;X...Q.A.
db #5a,#00 ;Z.
lab0F43 db #0
db #00,#00,#00,#00,#00,#00,#ed,#5b
db #0d,#ef,#7a,#fe,#5f,#d8,#fe,#c0 ;..z.....
db #d2,#26,#10,#cd,#5b,#0f,#13,#6b ;.......k
db #26,#5f,#af,#ae,#24,#ae,#24,#ae
db #24,#ae,#24,#ae
lab0F68 db #24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae
lab0FC0 db #24
db #ae,#24,#ae,#24
lab0FC5 db #ae
db #24,#ae,#24,#ae,#24,#ae,#24,#ae
db #24,#ae,#24,#ae,#24,#ae,#24,#ae
db #24,#ae
lab0FD8 db #24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae
lab1002 db #24
db #ae
lab1004 db #24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae
lab1010 db #24
db #ae,#24,#ae,#24,#ae,#24,#ae,#24
db #ae,#24,#ae,#24,#ae,#24,#ae
lab1020 db #24
db #26,#f7,#ae,#12,#c9,#3c,#c0,#3a
db #75,#ef,#08,#f5,#3a,#74,#ef,#cd ;u....t..
db #3c,#10,#2a,#0d,#ef,#77,#f1,#08 ;.....w..
db #2c,#77,#c9 ;.w.
lab103C ld hl,labFF00
lab103F xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    xor (hl)
    ex af,af''
    inc l
    jr nz,lab103F
    ret 
data1072 db #3a
db #04,#ef,#b7,#ca,#d4,#10,#af,#01
db #0e,#f4,#ed,#49,#01,#c0,#f6,#ed ;...I....
db #49,#ed,#79,#04,#0e,#92,#ed,#49 ;I.y....I
db #0e,#49,#06,#f6,#ed,#49,#06,#f4 ;.I...I..
db #ed,#78,#4f,#3e,#45,#06,#f6,#ed ;.xO.E...
db #79,#06,#f4,#ed,#78,#cb,#3f,#cb ;y...x...
db #3f,#f6,#df,#a1,#2f,#01,#82,#f7
db #ed,#49,#05,#0e,#00,#ed,#49,#4f ;.I....IO
db #e6,#30,#47,#cb,#39,#8f,#cb,#39 ;..G.....
db #8f,#cb,#39,#8f,#cb,#39,#8f,#b0
db #c9,#fe,#01,#7f,#01,#45,#80,#48 ;.....E.H
db #80,#48,#02,#47,#08,#44,#02,#44 ;.H.G.D.D
db #01,#21,#c8,#10,#af,#5f,#01,#0e
db #f4,#ed,#49,#01,#c0,#f6,#ed,#49 ;..I....I
db #ed,#79,#04,#0e,#92,#ed,#49,#16 ;.y....I.
db #06,#4e,#23,#06,#f6,#ed,#49,#06 ;.N....I.
db #f4,#ed,#78,#4e,#23,#a1,#fe,#01 ;..xN....
db #cb,#13,#15,#20,#ec
lab1100 db #7b
db #01,#82,#f7,#ed,#49,#05,#0e,#00 ;....I...
db #ed,#49,#c9 ;.I.
lab110C sla c
    sla c
    sla c
    ld d,b
    ld e,a
lab1114 push hl
    ld b,d
lab1116 ld (hl),e
    inc l
    djnz lab1116
    pop hl
    call lab348C
    dec c
    jr nz,lab1114
    ret 
data1122 db #fe
db #0d,#28,#26,#fe,#20,#28,#2f,#fe
db #02,#38,#11,#c2,#72,#11,#cd,#66 ;....r..f
db #11,#03,#05,#08,#45,#53,#43,#41 ;....ESCA
db #50,#45,#1f,#c9,#cd,#66,#11,#03 ;PE...f..
db #04,#08,#53,#48,#49,#46,#54,#1f ;..SHIFT.
db #c9,#cd,#66,#11,#03,#04,#08,#45 ;..f....E
db #4e,#54,#45,#52,#1f,#c9,#cd,#66 ;NTER...f
db #11,#03,#04,#08,#53,#50,#41,#43 ;....SPAC
db #45,#1f,#c9 ;E..
lab1166 ex (sp),hl
    ld a,(hl)
    inc hl
    ex (sp),hl
    cp #1f
    ret z
    call lab1172
    jr lab1166
lab1172 push hl
    push af
lab1174 ld a,(labEF27)
    and a
    jr z,lab1190
    pop af
    push af
    ld hl,(labEF29)
    ld (hl),a
    inc hl
    ld (labEF29),hl
    ld a,(labEF27)
    dec a
    ld (labEF27),a
    jr z,lab11B0
    pop af
    pop hl
    ret 
lab1190 pop af
    push af
    cp #20
    jp nc,lab11C2
    ld (labEF28),a
    ld hl,lab13C2
    call lab3483
    ld a,(hl)
    ld (labEF27),a
    and a
    jr z,lab11B0
    ld hl,labEF2B
    ld (labEF29),hl
    pop af
    pop hl
    ret 
lab11B0 ld a,(labEF28)
    add a,a
    ld hl,lab13E2
    call lab3483
    call lab3486
    push hl
    ld hl,labEF25
    ret 
lab11C2 push bc
    push de
    cp #2e
    jr nz,lab11CA
    ld a,#3a
lab11CA cp #21
    jr nz,lab11D0
    ld a,#3c
lab11D0 cp #26
    jr nz,lab11D6
    ld a,#3d
lab11D6 sub #20
    jr z,lab11DC
    sub #f
lab11DC ld hl,labEF2F
    bit 0,(hl)
    jr z,lab11EF
    push af
    or a
    call nz,lab1781
    ld bc,lab0018
    call lab1579
    pop af
lab11EF ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,(labEF23)
    add hl,de
    ex de,hl
    ld hl,(labEF25)
    add hl,hl
    sla l
    call lab3489
    push hl
    ld b,#7
    ld a,(labEF30)
    cp #1
    jr c,lab1279
    jr z,lab122C
    cp #2
    jr z,lab125B
lab1214 ld a,(de)
    rra 
    rra 
    rra 
    rra 
    and #f
    xor (hl)
    ld (hl),a
    inc l
    ld a,(de)
    inc de
    and #f
    xor (hl)
    ld (hl),a
    dec l
    call lab348C
    djnz lab1214
    jr lab128D
lab122C ld a,(de)
    inc de
    rrca 
    rl c
    rrca 
    rl c
    rrca 
    rl c
    rrca 
    rl c
    push af
    ld a,(hl)
    xor c
    and #f
    ld (hl),a
    inc l
    pop af
    rrca 
    rl c
    rrca 
    rl c
    rrca 
    rl c
    rrca 
    rl c
    ld a,(hl)
    xor c
    and #f
    ld (hl),a
    dec l
    call lab348C
    djnz lab122C
    jr lab128D
lab125B ld a,(de)
    and #f0
    ld (hl),a
    set 3,h
    ld (hl),a
    res 3,h
    inc l
    ld a,(de)
    add a,a
    add a,a
    add a,a
    add a,a
    and #f0
    inc de
    ld (hl),a
    set 3,h
    ld (hl),a
    dec l
    call lab348C
    djnz lab125B
    jr lab128D
lab1279 ld a,(de)
    rra 
    rra 
    rra 
    rra 
    and #f
    ld (hl),a
    ld a,(de)
    and #f
    inc l
    inc de
    ld (hl),a
    dec l
    call lab348C
    djnz lab1279
lab128D pop hl
    pop de
    pop bc
    ld a,(labEF31)
    add a,a
    ld hl,data12a2
    call lab3483
    call lab3486
    push hl
    ld hl,labEF25
    ret 
data12a2 db #fd
db #12,#06,#13,#e7,#12,#f3,#12,#3a
db #2b,#ef,#d6,#08,#da,#b5,#13,#fe
db #04,#d2,#b5,#13,#32,#31,#ef,#c3
db #ba,#13,#c5,#d5,#3a,#2b,#ef,#57 ;.......W
db #1e,#08,#21,#00,#c0,#01,#06,#00
db #cd,#d6,#12,#24,#24,#1d,#20,#f5
db #c3,#bd,#13,#72,#2c,#10,#fc,#24 ;...r....
db #0d,#20,#f8,#c9,#23,#34,#34,#2b
db #3a,#1f,#ef,#77,#23,#7e,#3c,#77 ;...w...w
db #fe,#31,#d2,#b5,#13,#c3,#ba,#13
db #23,#7e,#3d,#77,#da,#b5,#13,#c3 ;...w....
db #ba,#13,#7e,#3d,#77,#fa,#b5 ;....w..
lab1302 db #13
db #c3,#ba,#13,#7e,#3c,#77,#fe,#20 ;.....w..
db #da,#ba,#13,#18,#d3,#c3,#ba,#13
db #21,#2f,#ef,#3a,#2b,#ef,#fe,#02
db #d2,#b5,#13,#cb,#86,#b6,#77,#c3 ;......w.
db #ba,#13,#c3,#ba,#13,#c3,#ba,#13
db #3a,#2c,#ef,#fe,#20,#d2,#b5,#13
db #77,#23,#3a,#2b,#ef,#fe,#2f,#d2 ;w.......
db #b5,#13,#77,#c3,#ba,#13,#2a,#2b ;..w.....
db #ef,#7c,#cd,#72,#11,#2d,#20,#f9 ;...r....
db #18,#6d,#3a,#2b,#ef,#32,#1f,#ef ;.m......
db #18,#65,#3a,#2b,#ef,#fe,#20,#d2 ;.e......
db #b5,#13,#be,#77,#d2,#ba,#13,#23 ;...w....
db #7e,#c6,#02,#77,#18,#51,#2a,#2b ;...w.Q..
db #ef,#22,#23,#ef,#18,#49,#c5,#21 ;.....I..
db #30,#ef,#46,#36,#00,#cd,#66,#11 ;..F...f.
db #08,#20,#08,#1f,#70,#18,#3c,#3a ;....p...
db #2b,#ef,#32,#30,#ef,#18,#30,#18
db #2e,#3e,#00,#32,#20,#ef,#3e,#01
db #32,#31,#ef,#af,#32,#1f,#ef,#32
db #2f,#ef,#32,#30,#ef,#21,#00,#00
db #22,#25,#ef,#21,#00,#d6,#22,#23
db #ef,#21,#00,#58,#22,#21,#ef,#c3 ;...X....
db #ba,#13,#c3,#50,#15,#c1,#d1,#f1 ;...P....
db #e1,#c9,#d1,#c1,#f1,#e1,#c9
lab13C2 db #1
db #00,#01,#02,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#01
db #01,#01,#01,#01,#01,#02,#00,#01
db #01,#02,#00,#00,#00,#00,#00
lab13E2 db #bd
db #12,#8c,#13,#aa,#12,#41,#13,#df ;.....A..
db #12,#b5,#13,#b5,#13,#b5,#13,#fd
db #12,#06,#13,#e7,#12,#f3,#12,#71 ;.......q
db #13,#e3,#12,#b5,#13
lab1400 db #b5
db #13,#25,#13,#28,#13,#10,#13,#4d ;.......M
db #13,#55,#13,#8a,#13,#2b,#13,#b5 ;.U......
db #13,#82,#13,#13,#13,#69,#13,#b5 ;.....i..
db #13,#b5,#13,#b5,#13,#b5,#13,#b5
db #13,#e3,#7e,#23,#e3,#fe,#1f,#c8
db #cd,#2e,#14,#18,#f4
lab142E ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    ld bc,labD69E+2
    add hl,bc
    ld b,#4
lab1439 ld a,(hl)
    rra 
    rra 
    and #30
    or #c0
    ld (de),a
    inc e
    ld a,(hl)
    and #30
    or #c0
    ld (de),a
    set 3,d
    ld a,(hl)
    add a,a
    add a,a
    add a,a
    add a,a
    and #30
    or #c0
    ld (de),a
    dec e
    ld a,(hl)
    inc l
    add a,a
    add a,a
    and #30
    or #c0
    ld (de),a
    ld a,d
    add a,#8
    ld d,a
    djnz lab1439
    ld d,#c0
    inc e
    inc e
    ret 
lab1469 xor a
    res 6,(iy+21)
    ld (labEF06),a
    ld (labEF08),a
    ld (labEF5A),a
    ld (labEF60),a
    ld (labEF7A),a
    ld (labEF7B),a
    ld a,#ff
    ld (labEF43),a
    ld (labEF45),a
    ld (labEF47),a
    ld (labEF49),a
    ld (labEF4B),a
    res 0,(iy+98)
    res 4,(iy+21)
    call lab1521
    call lab01D6
    xor a
    call lab06E2
    call lab06EC
    ret 
data14a7 db #2a
db #0a,#1c,#22,#0a,#ef,#af,#32,#27
db #ef,#3c,#32,#65,#ef,#21,#68,#ef ;...e..h.
db #06,#06,#36,#30,#23,#10,#fb,#3e
db #05,#32,#66,#ef,#3c,#32,#67,#ef ;..f...g.
db #cd,#b6,#15,#cd,#66,#11,#01,#00 ;....f...
db #00,#1f,#21,#01,#c0,#06,#08,#36
db #40,#7c,#c6,#08,#67,#10,#f8,#11 ;....g...
db #02,#c0,#cd,#22,#14,#30,#30,#30
db #30,#30,#30,#40,#3a,#3b,#3c,#3a
db #40,#30,#31,#40,#40,#3e,#3c,#3f
db #40,#35,#40,#3d,#30,#3e,#3d
lab14FF db #35
db #40,#30,#36,#1f,#fb,#76,#fd,#cb ;.....v..
db #07,#86,#c9
lab150B ld iy,labEF00
    call lab1552
    call lab1562
    call lab153B
    ld (iy+7),#0
    ld (iy+66),#2
    ret 
lab1521 ld hl,labE700
    ld c,#20
    ld a,#8
lab1528 ld (hl),a
    inc l
    sub #10
    ld (hl),a
    inc l
    add a,#18
    ld b,#6
lab1532 ld (hl),#0
    inc l
    djnz lab1532
    dec c
    jr nz,lab1528
    ret 
lab153B ld hl,lab5F00
    ld de,labF700
lab1541 ld b,#61
    xor a
lab1544 xor (hl)
    inc h
    djnz lab1544
    ld (de),a
    inc e
    ld h,#5f
    inc l
    jr nz,lab1541
    ret 
data1550 db #f3
db #76 ;v
lab1552 ld a,(data155f)
    ld (labEF11),a
    ld hl,lab0E5B
    ld (lab0039),hl
    ret 
data155f db #c3
db #5b,#0e
lab1562 ld b,#80
    ld de,labC000
    ld hl,labFE00
lab156A ld (hl),e
    inc l
    ld (hl),d
    inc l
    ex de,hl
    call lab348C
    call lab348C
    ex de,hl
    djnz lab156A
    ret 
lab1579 halt
    dec bc
    ld a,b
    or c
    jr nz,lab1579
    ret 
lab1580 di
    ld hl,data1595
    ld b,#bc
lab1586 ld a,(hl)
    cp #ff
    ret z
    inc hl
    out (c),a
    inc b
    ld a,(hl)
    inc hl
    out (c),a
    dec b
    jr lab1586
data1595 db #1
db #20,#02,#2a,#04,#26,#07,#1e,#0c
db #30,#06,#18,#0d,#00,#ff,#06,#17
db #0d,#20,#ff,#21,#a4,#15,#cd,#84
db #15,#3e,#8d,#21,#e9,#15,#18,#0b
db #21,#9f,#15,#cd,#84,#15,#3e,#8c
db #21,#ed,#15,#01,#c0,#7f,#ed,#79 ;.......y
db #3e,#04,#18,#05
lab15CA ld hl,data15dc
    ld a,#11
    ld bc,lab7FE0
lab15D2 ld d,(hl)
    inc hl
    dec a
    out (c),a
    out (c),d
    jr nz,lab15D2
    ret 
data15dc db #54
db #55,#5e,#44,#4c,#5c,#4e,#46,#53 ;U.DL.NFS
db #42,#40,#52,#43,#57,#4a,#4c,#54 ;B.RCWJLT
db #56,#47,#54,#5e ;VGT.
lab15F1 ld hl,lab1AA4
    exx
    ld hl,lab1A92
    jr lab160A
data15fa db #21
db #a2,#1b,#d9,#21,#9a
lab1600 db #1b
db #18,#07
lab1603 ld hl,lab17CE
    exx
    ld hl,data17aa
lab160A ld (lab1695+1),hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (lab1684+1),de
    ld (lab168B+1),hl
    exx
    ld (lab16D7+1),hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (lab16C6+1),de
    ld (lab16CD+1),hl
    xor a
    ld (lab1666),a
    call lab1684
    ld (lab1668),a
    call lab16C6
    ld (lab1676),a
    ret 
lab1638 ld hl,data1650
    jr lab1645
lab163D ld a,#c9
    ld (lab1666),a
    ld hl,lab1659
lab1645 ld a,(hl)
    inc a
    ret z
    inc hl
    ld c,(hl)
    call lab178B
    inc hl
    jr lab1645
data1650 db #5
db #11,#06,#aa,#08,#10,#0b,#02,#ff
lab1659 db #0
db #00,#07,#0f,#06,#aa,#03,#00,#04
db #00,#08,#10,#ff
lab1666 db #c9
db #3e
lab1668 db #1
db #3d,#cc,#84,#16,#32,#68,#16,#3d ;.....h..
db #4f,#cc,#bf,#16,#3e ;O....
lab1676 db #1
db #3d,#cc,#c6,#16,#32,#76,#16,#3d ;.....v..
db #c0,#4f,#c3,#0e,#17 ;.O...
lab1684 ld hl,lab1BAA
    ld c,(hl)
    inc c
    jr nz,lab16A2
lab168B ld hl,lab1B9C
    inc hl
    ld a,(hl)
    dec hl
    inc a
    jp nz,lab1698
lab1695 ld hl,lab1B9A
lab1698 ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (lab168B+1),hl
    ex de,hl
    ld c,(hl)
    inc c
lab16A2 inc hl
    ld d,(hl)
    inc hl
    ld (lab1684+1),hl
    inc c
    jp z,lab16BF
    ld b,#0
    ld hl,lab16E7+2
    add hl,bc
    xor a
    ld c,(hl)
    call lab178B
    inc hl
    ld c,(hl)
    inc a
    call lab178B
    ld c,#e
lab16BF ld a,#8
    call lab178B
    ld a,d
    ret 
lab16C6 ld hl,lab1BB9
    ld c,(hl)
    inc c
    jr nz,lab16E4
lab16CD ld hl,lab1BA4
    inc hl
    ld a,(hl)
    dec hl
    inc a
    jp nz,lab16DA
lab16D7 ld hl,lab1BA2
lab16DA ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (lab16CD+1),hl
    ex de,hl
    ld c,(hl)
    inc c
lab16E4 inc hl
    ld d,(hl)
    inc hl
lab16E7 ld (lab16C6+1),hl
    inc c
    jp z,lab170E
    inc c
    jp z,lab1715
    dec c
    ld b,#0
    ld hl,lab1701
    add hl,bc
    ld a,#4
    ld c,(hl)
    inc hl
lab16FD call lab178B
    inc a
lab1701 ld c,(hl)
    call lab178B
    ld c,#aa
lab1707 ld a,#7
    call lab178B
    ld c,#d
lab170E ld a,#a
    call lab178B
    ld a,d
    ret 
lab1715 ld c,#0
    ld a,#4
    call lab178B
    inc a
    call lab178B
    ld c,#8e
    jp lab1707
data1725 db #7b
db #01,#66,#01,#52,#01,#3f,#01,#2d ;.f.R....
db #01,#1c,#01,#0c,#01,#fd,#00,#ef
db #00,#e1,#00,#d5,#00,#c9,#00,#be
db #00,#b3,#00,#a9,#00,#9f,#00,#96
db #00,#8e,#00,#86,#00,#7f,#00,#77 ;.......w
db #00,#71,#00,#6a,#00,#64,#00,#5f ;.q.j.d..
db #00,#59,#00,#54,#00,#50,#00,#4b ;.Y.T.P.K
db #00,#47,#00,#43,#00,#3f,#00,#3c ;.G.C....
db #00,#38,#00,#35,#00,#32,#00,#2f
db #00,#2d,#00,#2a,#00,#28,#00,#26
db #00,#24,#00,#22,#00,#20,#00,#1e
db #00,#1c,#00
lab1781 ld c,#0
    ld a,#d
    di
    call lab178B
    ei
    ret 
lab178B push af
    push bc
    ld b,#f4
    out (c),a
    ld a,#c0
    ld b,#f6
    out (c),a
    xor a
    out (c),a
    ld b,#f4
    out (c),c
    ld a,#80
    ld b,#f6
    out (c),a
    xor a
    out (c),a
    pop bc
    pop af
    ret 
data17aa db #14
db #18,#14,#18,#61,#18,#fc,#18,#4e ;...a...N
db #19,#a1,#19,#a1,#19,#a1,#19,#a1
db #19,#b6,#19,#ff,#19,#ff,#19,#10
db #1a,#4a,#1a,#4a,#1a,#8f,#1a,#8f ;.J.J....
db #1a,#ff,#ff
lab17CE db #2f
db #18,#2f,#18,#40,#18,#2f,#18,#2f
db #18,#40,#18,#ca,#18,#ca,#18,#db
db #18,#2f,#18,#3d,#19,#50,#18,#2f ;.....P..
db #18,#2f,#18,#2f,#18,#40,#18,#2f
db #18,#2f,#18,#3d,#19,#3d,#19,#dd
db #19,#dd,#19,#ee,#19,#ee,#19,#3d
db #19,#3d,#19,#3d,#19,#3d,#19,#40
db #18,#40,#18,#69,#1a,#69,#1a,#84 ;...i.i..
db #1a,#84,#1a,#ff,#ff,#fe,#0c,#5c
db #06,#5c,#06,#5c,#09,#5c,#09,#58 ;.......X
db #06,#fe,#03,#5c,#03,#5c,#06,#5c
db #06,#58,#06,#5c,#0c,#fe,#0c,#ff ;.X......
db #2c,#09,#44,#03,#fd,#06,#2c,#06 ;..D.....
db #2c,#0c,#fd,#06,#40,#03,#44,#03 ;......D.
db #ff,#2e,#09,#46,#03,#fd,#06,#2e ;...F....
db #06,#2e,#0c,#fd,#06,#44,#03,#46 ;.....D.F
db #03,#22,#09,#3a,#03,#fd,#06,#22
db #06,#22,#0c,#fd,#06,#36,#03,#3a
db #03,#ff,#fe,#03,#5c,#03,#5c,#06
db #5c,#06,#5c,#06,#5c,#0c,#5c,#09
db #5c,#03,#fe,#03,#6a,#03,#6a,#06 ;....j.j.
db #6a,#06,#6a,#06,#6a,#0c,#fe,#0c ;j.j.j...
db #6c,#0c,#6a,#0c,#6c,#0c,#6a,#0c ;l.j.l.j.
db #fe,#03,#60,#03,#60,#06,#60,#06
db #60,#06,#60,#0c,#fe,#0c,#fe,#03
db #62,#03,#62,#06,#62,#06,#62,#06 ;b.b.b.b.
db #62,#0c,#62,#09,#62,#03,#fe,#03 ;b.b.b...
db #70,#03,#70,#06,#70,#06,#70,#06 ;p.p.p.p.
db #70,#0c,#fe,#0c,#72,#0c,#70,#0c ;p...r.p.
db #72,#0c,#70,#0c,#fe,#03,#66,#03 ;r.p...f.
db #66,#06,#66,#06,#66,#06,#66,#0c ;f.f.f.f.
db #fe,#0c,#ff,#32,#09,#4a,#03,#fd ;.....J..
db #06,#32,#06,#32,#0c,#fd,#06,#46 ;.......F
db #03,#4a,#03,#ff,#34,#09,#4c,#03 ;.J....L.
db #fd,#06,#34,#06,#34,#0c,#fd,#06
db #4a,#03,#4c,#03,#28,#09,#40,#03 ;J.L.....
db #fd,#06,#28,#06,#28,#0c,#fd,#06
db #3c,#03,#40,#03,#ff,#fe,#0c,#5c
db #06,#5c,#06,#5c,#03,#5c,#03,#5c
db #06,#60,#06,#62,#06,#66,#03,#66 ;...b.f.f
db #03,#66,#06,#66,#06,#66,#06,#66 ;.f.f.f.f
db #0c,#fe,#06,#66,#03,#6a,#03,#6c ;...f.j.l
db #03,#6c,#03,#6a,#06,#66,#06,#62 ;.l.j.f.b
db #06,#60,#06,#5c,#06,#5a,#0c,#fe ;.....Z..
db #03,#5c,#03,#5c,#06,#5c,#06,#60
db #06,#5c,#0c,#fe,#0c,#ff,#36,#09
db #4e,#03,#fd,#06,#36,#06,#36,#0c ;N.......
db #fd,#06,#4a,#03,#4e,#03,#ff,#62 ;..J.N..b
db #03,#60,#06,#5e,#03,#5c,#06,#62 ;.......b
db #03,#60,#06,#5e,#03,#5c,#06,#62 ;.......b
db #03,#60,#06,#5e,#03,#5c,#06,#62 ;.......b
db #03,#60,#06,#5e,#03,#5c,#06,#62 ;.......b
db #03,#60,#06,#5c,#03,#6c,#06,#6a ;.....l.j
db #06,#6c,#03,#6a,#06,#68,#03,#66 ;.l.j.h.f
db #06,#6c,#03,#6a,#06,#68,#03,#66 ;.l.j.h.f
db #06,#6c,#06,#6a,#06,#60,#03,#5e ;.l.j....
db #06,#5c,#03,#5a,#06,#60,#03,#5e ;...Z....
db #06,#5c,#03,#5a,#06,#62,#06,#60 ;...Z.b..
db #06,#ff,#62,#03,#60,#06,#5e,#03 ;..b.....
db #5c,#06,#62,#03,#60,#06,#5e,#03 ;..b.....
db #5c,#06,#62,#06,#66,#06,#ff,#6e ;..b.f..n
db #12,#6e,#06,#6a,#0c,#64,#06,#60 ;.n.j.d..
db #06,#60,#06,#5e,#06,#5e,#0c,#fe
db #06,#5e,#03,#5e,#03,#60,#06,#64 ;.......d
db #06,#64,#12,#64,#06,#6a,#09,#64 ;.d.d.j.d
db #09,#60,#06,#64,#30,#ff,#26,#09 ;...d....
db #3e,#03,#fd,#06,#26,#06,#26,#0c
db #fd,#06,#3a,#03,#36,#03,#ff,#34
db #09,#4c,#03,#fd,#06,#34,#06,#34 ;.L......
db #0c,#fd,#06,#48,#03,#4a,#03,#ff ;...H.J..
db #66,#0c,#fe,#06,#66,#03,#66,#03 ;f...f.f.
db #6a,#09,#66,#09,#62,#06,#66,#30 ;j.f.b.f.
db #ff,#6a,#0c,#fe,#06,#6a,#03,#6a ;.j...j.j
db #03,#6e,#09,#6a,#09,#66,#06,#6a ;.n.j.f.j
db #30,#6a,#0c,#fe,#06,#6a,#03,#6a ;.j...j.j
db #03,#6e,#09,#6a,#09,#66,#06,#6a ;.n.j.f.j
db #09,#6e,#09,#72,#06,#6e,#09,#72 ;.n.r.n.r
db #09,#74,#06,#ff,#fe,#03,#52,#03 ;.t....R.
db #52,#06,#52,#06,#4e,#06,#52,#0c ;R.R.N.R.
db #fe,#0c,#ff,#76,#03,#76,#03,#76 ;...v.v.v
db #03,#76,#03,#76,#03,#5e,#03,#72 ;.v.v...r
db #03,#76,#03,#76,#03,#72,#03,#76 ;.v.v.r.v
db #06,#76,#03,#76,#03,#72,#03,#72 ;.v.v.r.r
db #03,#ff,#38,#03,#38,#03,#38,#03
db #38,#03,#fd,#06,#34,#03,#38,#03
db #38,#03,#34,#03,#38,#06,#fd,#06
db #34,#03,#34,#03,#ff,#fe,#0c,#fd
db #06,#fe,#12,#fd,#06,#fe,#06,#ff
db #fe,#30,#ff
lab1A92 db #b2
db #1a,#c5,#1a,#b2,#1a,#d0,#1a,#0c
db #1b,#b2,#1a,#d0,#1a,#5c,#1b,#ff
db #ff
lab1AA4 db #db
db #1a,#db,#1a,#2b,#1b,#db,#1a,#81
db #1b,#81,#1b,#ff,#ff,#64,#24,#60 ;.....d..
db #0c,#66,#06,#64,#0c,#60,#0c,#64 ;.f.d...d
db #0c,#fe,#06,#5c,#24,#5c,#0c,#ff
db #5c,#06,#5a,#0c,#56,#12,#5a,#06 ;..Z.V.Z.
db #5c,#06,#ff,#5c,#06,#5a,#0c,#56 ;.....Z.V
db #0c,#52,#0c,#fe,#06,#ff,#2c,#0c ;.R......
db #fd,#06,#2c,#06,#2c,#0c,#fd,#06
db #2c,#06,#28,#0c,#fd,#06,#28,#06
db #28,#0c,#fd,#06,#28,#06,#36,#0c
db #fd,#06,#36,#06,#36,#0c,#fd,#06
db #36,#06,#3a,#0c,#fd,#06,#3a,#06
db #3a,#0c,#fd,#06,#3a,#06,#ff,#52 ;.......R
db #24,#56,#06,#5c,#06,#5c,#0c,#5a ;.V.....Z
db #18,#5c,#06,#60,#06,#64,#0c,#60 ;.....d..
db #18,#62,#06,#66,#06,#66,#0c,#64 ;.b.f.f.d
db #0c,#60,#0c,#5c,#0c,#ff,#26,#0c
db #fd,#06,#26,#06,#26,#0c,#fd,#06
db #26,#06,#34,#0c,#fd,#06,#34,#06
db #34,#0c,#fd,#06,#34,#06,#36,#0c
db #fd,#06,#36,#06,#36,#0c,#fd,#06
db #36,#06,#3a,#0c,#fd,#06,#3a,#06
db #3a,#0c,#fd,#06,#3a,#06,#ff,#5c
db #30,#fe,#06,#4e,#06,#52,#06,#4e ;...N.R.N
db #06,#5c,#06,#5a,#06,#52,#06,#60 ;...Z.R..
db #06,#5c,#30,#fe,#06,#4e,#06,#52 ;.....N.R
db #06,#4e,#06,#5c,#06,#5a,#06,#52 ;.N...Z.R
db #06,#4e,#06,#ff,#2c,#0c,#fd,#06 ;.N......
db #2c,#06,#2c,#0c,#fd,#06,#2c,#06
db #36,#0c,#fd,#06,#36,#06,#3a,#0c
db #fd,#06,#3a,#06,#ff
lab1B9A db #aa
db #1b
lab1B9C db #aa
db #1b,#c8,#1b,#ff,#ff
lab1BA2 db #b9
db #1b
lab1BA4 db #b9
db #1b,#d7,#1b,#ff,#ff
lab1BAA db #6a
db #03,#6a,#03,#6a,#06,#6a,#06,#6a ;.j.j.j.j
db #06,#70,#0c,#74,#0c,#ff ;.p.t..
lab1BB9 db #5c
db #03,#5c,#03,#5c,#06,#5c,#06,#5c
db #06,#62,#0c,#66,#0c,#ff,#fe,#03 ;.b.f....
db #78,#03,#78,#06,#78,#06,#7c,#06 ;x.x.x...
db #78,#18,#fe,#00,#ff,#fe,#03,#6a ;x......j
db #03,#6a,#06,#6a,#06,#6e,#06,#6a ;.j.j.n.j
db #18,#fe,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#c3,#00
db #01
lab1C03 jp lab2D5C
lab1C06 jp lab2D73
data1c09 db #c3
db #fb,#2d
lab1C0C jp lab2993
lab1C0F jp lab3480
data1c12 db #e8
db #21,#8b,#2c,#fd,#2b,#f0,#2b,#39
db #2a,#0b,#2b,#23,#2c,#bd,#22,#20
db #22,#12,#2a,#1f,#2a,#2c,#2a,#78 ;.......x
db #28,#78,#28,#b6,#29,#cb,#29,#e0 ;.x......
db #29,#79,#29,#86,#29,#5d,#1e,#9e ;.y......
db #23,#b3,#23,#69,#1c,#c4,#23,#78 ;...i...x
db #28,#b5,#20,#9b,#1f,#0b,#1f,#95
db #1e,#87,#1e,#9a,#1e,#73,#1d,#92 ;.....s..
db #1c,#8a,#1c,#70,#1c,#7d,#1c,#6b ;...p...k
db #1c,#30,#2c,#69,#1c,#62,#1c,#fd ;...i.b..
db #73,#7b,#fd,#36,#7d,#01,#37,#c9 ;s.......
db #21,#11,#a4,#18,#03,#21,#f1,#a2
db #7a,#fe,#65,#3f,#d8,#06,#06,#c3 ;z.e.....
db #4c,#24,#7a,#fe,#65,#3f,#d8,#21 ;L.z.e...
db #51,#a3,#06,#06,#c3,#5a,#25,#1d ;Q....Z..
db #37,#c0,#fd,#cb,#15,#e6,#c9,#01
db #01,#17,#cd,#ab,#21,#d8,#d9,#3a
db #60,#ef,#e6,#18,#5f,#16,#00,#21
db #32,#1d,#19,#e5,#11,#f4,#1c,#01
db #08,#00,#ed,#b0,#e1,#11,#01,#1d
db #0e,#08,#ed,#b0,#c5,#f1,#08,#3a
db #60,#ef,#e6,#06,#87,#5f,#50,#21 ;......P.
db #52,#1d,#19,#5e,#23,#56,#23,#7e ;R....V..
db #23,#66,#6f,#01,#cf,#cf,#d9,#78 ;.fo....x
db #fe,#17,#20,#16,#3e,#10,#2d,#36
db #00,#3d,#20,#fa,#cb,#dc,#3e,#10
db #36,#00,#2c,#3d,#20,#fa,#05,#cd
db #8c,#34,#ed,#73,#02,#ef,#f9,#08 ;...s....
db #d9,#c5,#c5,#c5,#e5,#d5,#c5,#c5
db #c5,#d9,#cb,#dc,#f9,#d9,#c5,#c5
db #c5,#e5,#d5,#c5,#c5,#c5,#d9,#08
db #7c,#c6,#08,#67,#30,#08,#7d,#c6 ;...g....
db #40,#6f,#7c,#ce,#c0,#67,#10,#d6 ;.o...g..
db #ed,#7b,#02,#ef,#b7,#fd,#cb,#15
db #66,#c8,#21,#60,#ef,#34,#7e,#fe ;f.......
db #20,#3f,#d0,#36,#00,#37,#c9,#c5
db #c5,#c5,#e5,#d5,#c5,#c5,#c5,#c5
db #c5,#e5,#f5,#f5,#d5,#c5,#c5,#c5
db #e5,#f5,#f5,#f5,#f5,#d5,#c5,#e5
db #f5,#f5,#f5,#f5,#f5,#f5,#d5,#cf
db #8a,#45,#cf,#cf,#00,#00,#cf,#8a ;.E......
db #00,#00,#45,#00,#00,#00,#00,#21 ;..E.....
db #00,#1e,#11,#4f,#ef,#01,#0d,#00 ;...O....
db #ed,#b0,#79,#32,#13,#1e,#b7,#c9 ;..y.....
db #dd,#21,#4f,#ef,#dd,#cb,#0b,#7e ;..O.....
db #28,#e5,#7a,#fe,#28,#30,#0a,#ed ;..z.....
db #5f,#f2,#bc,#1d,#dd,#34,#05,#18
db #30,#3e,#01,#32,#13,#1e,#dd,#7e
db #0b,#f6,#ed,#3c,#20,#03,#32,#5b
db #ef,#fd,#cb,#5b,#46,#20,#0d,#dd ;....F...
db #35,#06,#f2,#af,#1d,#dd,#36,#06
db #03,#dd,#35,#04,#fd,#35,#5b,#f2
db #bc,#1d,#fd,#36,#5b,#03,#dd,#35
db #05,#dd,#7e,#06,#e6,#01,#c6,#02
db #5f,#3e,#10,#cd,#3e,#1e,#7b,#c6
db #0e,#5f,#3e,#08,#cd,#3e,#1e,#7b
db #d6,#0e,#5f,#3e,#02,#cd,#0d,#1e
db #dd,#7e,#06,#dd,#77,#02,#21,#5a ;....w..Z
db #ef,#7e,#cb,#be,#f6,#e5,#3c,#37
db #c8,#cb,#fe,#3a,#53,#ef,#d6,#06 ;....S...
db #32,#53,#ef,#3a,#4f,#ef,#d6,#06 ;.S..O...
db #32,#4f,#ef,#b7,#c9,#0c,#fa,#00 ;.O......
db #00,#0c,#fa,#00,#00,#04,#5f,#0a
db #80,#01,#f5,#7b,#dd,#77,#07,#ee ;.....w..
db #01,#dd,#77,#03,#f1,#f5,#dd,#a6 ;..w.....
db #0b,#dd,#7e,#06,#f5,#28,#08,#dd
db #36,#07,#00,#dd,#36,#06,#00,#cd
db #80,#34,#f1,#dd,#77,#06,#f1,#dd ;....w...
db #cb,#0b,#6e,#c0,#dd,#b6,#0b,#dd ;..n.....
db #77,#0b,#c9,#d5,#2a,#4f,#ef,#e5 ;w....O..
db #dd,#46,#02,#c5,#cd,#0d,#1e,#c1 ;.F......
db #dd,#70,#02,#e1,#2c,#2c,#2c,#22 ;.p......
db #4f,#ef,#21,#53,#ef,#34,#34,#34 ;O..S....
db #d1,#c9,#cb,#7b,#cb,#bb,#28,#1d
db #1d,#21,#50,#bb,#06,#14,#d5,#cd ;..P.....
db #df,#23,#d1,#7b,#c6,#07,#5f,#06
db #14,#d5,#21,#d0,#bd,#cd,#df,#23
db #d1,#7b,#d6,#06,#5f,#21,#f0,#bb
db #06,#14,#18,#18,#06,#14,#21,#d2
db #b6,#1c,#1d,#28,#0f,#21,#b2,#b8
db #18,#0a,#21,#f0,#ba,#18,#03,#21
db #92,#ba,#06,#04,#e5,#d9,#e1,#d9
db #0e,#18,#cd,#ab,#21,#d8,#e5,#d9
db #e5,#d9,#e1,#19,#d1,#ed,#73,#02 ;......s.
db #ef,#f9,#eb,#7d,#d1,#73,#2c,#72 ;.....s.r
db #2c,#d1,#73,#2c,#72,#2c,#d1,#73 ;..s.r..s
db #2c,#72,#2c,#d1,#73,#2c,#72,#2c ;.r..s.r.
db #d1,#73,#2c,#72,#2c,#d1,#73,#2c ;.s.r..s.
db #72,#6f,#cb,#dc,#d1,#73,#2c,#72 ;ro...s.r
db #2c,#d1,#73,#2c,#72,#2c,#d1,#73 ;..s.r..s
db #2c,#72,#2c,#d1,#73,#2c,#72,#2c ;.r..s.r.
db #d1,#73,#2c,#72,#2c,#d1,#73,#2c ;.s.r..s.
db #72,#6f,#7c,#c6,#08,#67,#30,#08 ;ro...g..
db #7d,#c6,#40,#6f,#7c ;...o.
lab1F00 db #ce
db #c0,#67,#10,#b1,#ed,#7b,#02,#ef ;.g......
db #b7,#c9,#21,#4b,#ef,#36,#0a,#23 ;...K....
db #36,#6a,#23,#36,#46,#af,#32,#79 ;.j..F..y
db #ef,#32,#78,#ef,#37,#c9 ;..x...
lab1F1F ld hl,labEF4B
    ld e,(hl)
    inc e
    ret z
    dec e
    inc hl
    inc hl
    dec (hl)
    ld a,(hl)
    dec hl
    jp p,lab1F30
    neg
lab1F30 cp #32
    jr c,lab1F35
    dec (hl)
lab1F35 cp #1e
    jr c,lab1F3A
    dec (hl)
lab1F3A ld a,(hl)
    cp #4
    jr nc,lab1F58
    dec hl
    ld (hl),#ff
    ret 
lab1F43 res 7,e
    dec hl
    ld (hl),#ff
    push de
    ld c,#2
    call lab2073
    pop hl
    ld a,h
    sub #e
    ld h,a
    ld a,#2
    jp lab012A
lab1F58 ld d,a
    ld bc,lab1010
    bit 7,e
    jr nz,lab1F43
    call lab21AB
    sla b
    push hl
    ld hl,labBF00
    add hl,de
    pop de
    ld (labEF02),sp
    ld sp,hl
    ex de,hl
lab1F71 ld a,l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    ld l,a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab1F94
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    ld h,a
lab1F94 djnz lab1F71
    ld sp,(labEF02)
    ret 
data1f9b db #7b
db #32,#4e,#ef,#21,#47,#ef,#5e,#3e ;.N..G...
db #03,#1c,#28,#06,#1d,#7b,#e6,#03
db #23,#23,#77,#23,#36,#04,#37,#c9 ;..w.....
lab1FB4 ld hl,labEF47
    ld a,(hl)
    inc a
    jr nz,lab1FC0
    inc hl
    inc hl
    ld a,(hl)
    inc a
    ret z
lab1FC0 call lab2059
    ld hl,labEF47
    push hl
    call lab1FDA
    pop hl
    jr nc,lab1FCF
    ld (hl),#ff
lab1FCF inc hl
    inc hl
    push hl
    call lab1FDA
    pop hl
    ret nc
    ld (hl),#ff
    ret 
lab1FDA ld e,(hl)
    or a
    inc e
    ret z
    dec e
    ld a,(labEF4E)
    dec a
    jr z,lab1FF2
    ld (labEF4E),a
    inc e
    cp #14
    jr nc,lab1FF1
    rrca 
    jr c,lab1FF1
    dec e
lab1FF1 ld (hl),e
lab1FF2 inc hl
    ld a,r
    jp p,lab1FF9
    inc (hl)
lab1FF9 ld d,(hl)
    ld bc,lab0C03
    ld a,e
    and #2
lab2000 ex af,af''
    ld a,e
    srl e
    srl e
    cp #6b
    jp z,lab2073
    ld c,#18
    call lab21AB
    ret c
    sla b
    ex af,af''
    jr nz,lab2017
    dec l
lab2017 ex af,af''
    push hl
lab2019 ld hl,lab8BF9
    add hl,de
    pop de
lab201E ld (labEF02),sp
    ld sp,hl
    ex de,hl
lab2024 ld a,l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
lab2033 inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    ld l,a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab2051
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    ld h,a
lab2051 djnz lab2024
    ld sp,(labEF02)
    or a
    ret 
lab2059 ld a,(labEF4E)
    dec a
    ret z
    cp #14
    jr nc,lab2064
    rrca 
    ret nc
lab2064 ld a,(hl)
    and #1
    ld hl,lab8BF9
    jr z,lab206F
    ld hl,lab88DC
lab206F ld (lab2019+1),hl
    ret 
lab2073 sla c
    ld a,c
    ex af,af''
    ld a,c
    add a,a
    dec a
    ld l,a
    ld h,#0
    push hl
    call lab21AB
    ret c
    ex af,af''
    ld c,a
    pop de
    add hl,de
    ld (labEF02),sp
    ld de,data0000
    ld a,b
lab208E ex af,af''
    ld sp,hl
    inc sp
    ld b,c
lab2092 push de
    djnz lab2092
    set 3,h
    ld sp,hl
    inc sp
    ld b,c
lab209A push de
    djnz lab209A
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab20AB
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    ld h,a
lab20AB ex af,af''
    dec a
    jr nz,lab208E
    ld sp,(labEF02)
    scf
    ret 
data20b5 db #21
db #43,#ef,#5e,#3e,#07,#1c,#28,#06 ;C.......
db #1d,#7b
lab20C0 db #e6
db #07,#23,#23,#c6,#b8,#77,#23,#36 ;.....w..
db #04,#37,#c9
lab20CC ld hl,labEF43
    ld a,(hl)
    inc a
    jr nz,lab20D8
    inc hl
    inc hl
    ld a,(hl)
    inc a
    ret z
lab20D8 dec a
    push af
    ld a,r
    jp p,lab20E5
    inc (iy+68)
    inc (iy+70)
lab20E5 pop af
    ld hl,lab86DD+1
    and #2
    jr z,lab20F0
    ld hl,lab89FC
lab20F0 ld (lab2161+1),hl
    ld hl,labEF43
    call lab20FC
    ld hl,labEF45
lab20FC ld a,(hl)
    cp #ff
    ret z
    dec (hl)
    jr z,lab2131
    inc hl
    ld a,(hl)
    dec hl
    add a,a
    jr c,lab2112
    push hl
    call lab2144
    pop hl
    ret nc
    ld (hl),#ff
    ret 
lab2112 push hl
    ld a,(hl)
    rrca 
    rrca 
    rrca 
    and #1f
    inc a
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    and #7f
    sub #e
    ld h,a
    xor a
    push hl
    call lab012A
    pop hl
    inc l
    inc l
    inc l
    xor a
    call lab012A
    pop hl
lab2131 ld e,(hl)
    ld (hl),#ff
    srl e
    srl e
    srl e
    inc hl
    ld d,(hl)
    res 7,d
    ld bc,lab1004
    jp lab2073
lab2144 ld a,(hl)
    inc a
    and #4
    ex af,af''
    ld a,(hl)
    inc a
    inc hl
    rrca 
    rrca 
    rrca 
    and #1f
    ld e,a
    ld d,(hl)
    ld bc,lab1020
    call lab21AB
    ret c
    ex af,af''
    jr z,lab215E
    inc l
lab215E sla b
    push hl
lab2161 ld hl,lab86DD+1
    add hl,de
    pop de
    ld (labEF02),sp
    ld sp,hl
    ex de,hl
lab216C ld a,l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    pop de
    ld (hl),e
    inc l
    ld (hl),d
    ld l,a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab21A3
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    ld h,a
lab21A3 djnz lab216C
    ld sp,(labEF02)
    or a
    ret 
lab21AB ld a,d
    cp #60
    jr nc,lab21CA
    ld h,b
    sub b
    cp #3
    jp p,lab21D3
    sub #3
    neg
    ld h,a
    neg
    add a,b
    ld b,a
    ld a,e
    ld e,c
    call lab2993
    ld e,a
    ld d,#4
    jr lab21DA
lab21CA sub b
    sub #5f
    ccf 
    ret c
    ld h,b
    neg
    ld b,a
lab21D3 ld a,d
    sub h
    inc a
    ld d,a
    ld hl,data0000
lab21DA ex de,hl
    ld a,l
    add a,a
    ld l,h
    sla l
    ld h,#fe
    add a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    or a
    ret 
data21e8 db #7a
db #fe,#7f,#3f,#d8,#06,#20,#cb,#7b
db #20,#0f,#7b,#fe,#0f,#21,#d8,#aa
db #da,#da,#26,#21,#d2,#b0,#c3,#da
db #26,#cb,#bb,#d5,#0e,#03,#cd,#73 ;.......s
db #20,#e1,#7c,#d6,#16,#67,#3e ;.....g.
lab2210 db #2
db #e5,#cd,#2a,#01,#e1,#3e,#02,#2c
db #2c,#2c,#cd,#2a,#01,#37,#c9,#7a ;.......z
db #fe,#78,#3f ;.x.
lab2224 db #d8
db #06,#19,#7a,#3c,#90,#57,#fe,#04 ;..z..W..
db #f2,#4f,#22,#7a,#80 ;.O.z.
lab2232 db #d6
lab2233 db #4
db #47,#26,#c0,#7b,#87,#c6,#41,#6f ;G.....Ao
db #7a,#d9,#ed,#44,#c6,#04,#6f,#26 ;z..D..o.
db #00,#29,#29,#29,#29,#11,#61,#a1 ;......a.
db #19,#18,#12,#7a,#87,#6f,#7b,#26 ;...z.o..
db #fe,#87,#3c,#86,#2c,#66,#6f,#06 ;.....fo.
db #19,#d9,#21,#61,#a1,#01,#08,#00 ;...a....
db #ed,#73,#02,#ef,#d9,#d9,#f9,#09 ;.s......
db #f1,#d1,#d9,#f1,#d1,#f9,#33,#d5
db #f5,#d9,#d5,#f5,#d9,#d5,#f5,#d9
db #d5,#f5,#d9,#d5,#f5,#d9,#d5,#f5
db #d9,#cb,#dc,#d9,#f9,#09,#f1,#d1
db #d9,#f1,#d1,#f9,#33,#d5,#f5,#d9
db #d5,#f5,#d9,#d5,#f5,#d9,#d5
lab229B db #f5
db #d9,#d5,#f5,#d9,#d5,#f5,#d9,#7c
db #c6,#08,#67,#30,#0c,#7d,#c6,#40 ;..g.....
db #6f,#7c,#ce,#c0,#67,#fe,#c6,#28 ;o...g...
db #02,#10,#b2,#ed,#7b,#02,#ef,#b7
db #c9,#7a,#fe,#65,#3f,#d8,#06,#06 ;.z.e....
db #7a,#3c,#90,#57,#fe,#04,#d9,#21 ;z..W....
db #6a,#23,#d9 ;j..
lab22CF db #f2
db #e6,#22,#7a,#80,#d6,#04,#47,#7a ;..z...Gz
db #ed,#44,#c6,#04,#87,#87,#87,#d9 ;.D......
db #cd,#83,#34,#d9,#16,#04,#7a,#87 ;......z.
db #6f,#7b,#26,#fe,#87,#3c,#86,#2c ;o.......
db #66,#6f,#ed,#73,#02,#ef,#f9,#33 ;fo.s....
db #d9,#5e,#23,#56,#23,#4e,#23,#46 ;...V.N.F
db #23,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#d9,#cb,#dc,#f9,#33,#d9,#5e
db #23,#56,#23,#4e,#23,#46,#23,#c5 ;.V.N.F..
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#c5
db #d5,#c5,#d5,#c5,#d5,#c5,#d5,#d9
db #7c,#c6,#08,#67,#30,#0c,#7d,#c6 ;...g....
db #40,#6f,#7c,#ce,#c0,#67,#fe,#c6 ;.o...g..
db #28,#02,#10,#92,#ed,#7b,#02,#ef
db #b7,#c9,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#c0,#c0,#80,#85,#25
db #0f,#ca,#0f,#1a,#25,#4f,#8f,#0f ;.....O..
db #0f,#cf,#c5,#cf,#cf,#ca,#c0,#c0
db #c0,#80,#0f,#cf,#8f,#0f,#0f,#30
db #0f,#4f,#1a,#1a,#25,#4f,#8f,#0f ;.O...O..
db #0f,#cf,#cf,#cf,#cf,#8a,#7a,#fe ;......z.
db #80,#3f,#d8,#06,#21,#7b,#b7,#21
db #71,#a4,#ca,#3b,#26,#21,#71,#a4 ;q.....q.
db #c3,#3b,#26,#7a,#fe,#78,#3f,#d8 ;...z.x..
db #06,#19,#21,#21,#9b,#d5,#cd,#91
db #27,#d1,#b7,#c9,#7a,#fe,#87,#3f ;....z...
db #d8,#06,#28,#21,#99,#a9,#d5,#cd
db #df,#23,#d1,#7b,#c6,#07,#5f,#06
db #28,#21,#99,#a9,#c3,#df,#23,#0e
db #08,#e5,#cd,#ab,#21,#30,#02,#e1
db #c9,#e3,#19,#d1,#ed,#73,#02,#ef ;.....s..
db #f9,#eb,#ed,#5f,#f2,#25,#24,#d1
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#cb,#dc,#d1,#7e,#a2,#b3 ;.w......
db #77,#2d,#d1,#7e,#a2,#b3,#77,#7c ;w.....w.
db #c6,#08,#67,#30,#08,#7d,#c6,#40 ;..g.....
db #6f,#7c,#ce,#c0,#67,#10,#d8,#b7 ;o...g...
db #ed,#7b,#02,#ef,#c9,#3b,#f1,#b6
db #77,#2c,#f1,#b6,#77,#cb,#dc,#f1 ;w...w...
db #b6,#77,#2d,#f1,#b6,#77,#7c,#c6 ;.w...w..
db #08,#67,#30,#08,#7d,#c6,#40,#6f ;.g.....o
db #7c,#ce,#c0,#67,#10,#e0,#b7,#ed ;...g....
db #7b,#02,#ef,#c9,#0e,#10,#e5,#cd
db #ab,#21,#e3,#19,#d1,#ed,#73,#02 ;......s.
db #ef,#f9,#eb,#d1,#7e,#a2,#b3,#77 ;.......w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#cb,#dc,#d1,#7e,#a2,#b3 ;.w......
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#7c,#c6,#08,#67,#30 ;..w...g.
db #08,#7d,#c6,#40,#6f,#7c,#ce,#c0 ;....o...
db #67,#10,#c0,#b7,#ed,#7b,#02,#ef ;g.......
db #c9,#0e,#18,#e5,#cd,#ab,#21,#e3
db #19,#d1,#ed,#73,#02,#ef,#f9,#eb ;...s....
db #ed,#5f,#f2,#13,#25,#d1,#7e,#a2
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #cb,#dc,#d1,#7e,#a2,#b3,#77,#2d ;......w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#7c,#c6,#08 ;....w...
lab2500 db #67
db #30,#08,#7d,#c6,#40,#6f,#7c,#ce ;.....o..
db #c0,#67,#10,#a8,#b7,#ed ;.g....
lab250F db #7b
db #02,#ef,#c9,#3b,#f1,#b6,#77,#2c ;......w.
db #f1,#b6,#77,#2c,#f1,#b6,#77,#2c ;..w...w.
db #f1,#b6,#77,#2c,#f1,#b6,#77,#2c ;..w...w.
db #f1,#b6,#77,#cb,#dc,#f1,#b6,#77 ;..w....w
db #2d,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #2d,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #2d,#f1,#b6,#77,#7c,#c6,#08,#67 ;...w...g
db #30,#08,#7d,#c6,#40,#6f,#7c,#ce ;.....o..
db #c0,#67,#10,#c0,#b7,#ed,#7b,#02 ;.g......
db #ef,#c9,#0e,#20,#e5,#cd,#ab,#21
db #e3,#19,#d1,#ed,#73,#02,#ef,#f9 ;....s...
db #eb,#ed,#5f,#f2,#e4,#25,#d1,#7e
db #a2,#b3,#77,#2c,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2c,#d1,#7e,#a2,#b3,#77,#2c ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2c,#d1,#7e ;....w...
db #a2,#b3,#77,#2c,#d1,#7e,#a2 ;..w....
lab258F db #b3
db #77,#2c,#d1,#7e,#a2,#b3,#77,#2c ;w.....w.
db #d1,#7e,#a2,#b3,#77,#cb,#dc,#d1 ;....w...
db #7e,#a2,#b3,#77,#2d,#d1,#7e,#a2 ;...w....
db #b3,#77,#2d,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2d,#d1,#7e,#a2,#b3,#77,#2d,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2d,#d1,#7e,#a2 ;...w....
db #b3,#77,#2d,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2d,#d1,#7e,#a2,#b3,#77,#7c,#c6 ;.....w..
db #08,#67,#30,#08,#7d,#c6,#40,#6f ;.g.....o
db #7c,#ce,#c0,#67,#10,#90,#b7,#ed ;...g....
db #7b,#02,#ef,#c9,#3b,#f1,#b6,#77 ;.......w
db #2c,#f1,#b6,#77,#2c,#f1,#b6,#77 ;...w...w
db #2c,#f1,#b6,#77,#2c,#f1,#b6,#77 ;...w...w
db #2c,#f1,#b6,#77,#2c,#f1,#b6,#77 ;...w...w
db #2c,#f1,#b6,#77 ;...w
lab2604 db #cb
db #dc,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #2d,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #2d,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #2d,#f1,#b6,#77,#2d,#f1,#b6,#77 ;...w...w
db #7c,#c6,#08,#67,#30,#08,#7d,#c6 ;...g....
db #40,#6f,#7c,#ce,#c0,#67,#10,#b0 ;.o...g..
db #b7,#ed,#7b,#02,#ef,#c9,#0e,#28
db #e5,#cd,#ab,#21,#e3,#19,#d1,#ed
db #73,#02,#ef,#f9,#eb,#d1,#7e,#a2 ;s.......
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #cb,#dc,#d1,#7e,#a2,#b3,#77,#2d ;......w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#7c,#c6,#08 ;....w...
db #67,#30,#08,#7d,#c6,#40,#6f,#7c ;g.....o.
db #ce,#c0,#67,#05,#c2,#4a,#26,#b7 ;..g..J..
db #ed,#7b,#02,#ef,#c9,#0e,#30,#e5
db #cd,#ab,#21,#e3,#19,#d1,#ed,#73 ;.......s
db #02,#ef,#f9,#eb,#d1,#7e,#a2,#b3
db #77,#2c,#d1,#7e,#a2,#b3,#77,#2c ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2c,#d1,#7e ;....w...
db #a2,#b3,#77,#2c,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2c,#d1,#7e,#a2,#b3,#77,#2c ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2c,#d1,#7e ;....w...
db #a2,#b3,#77,#2c,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2c,#d1,#7e,#a2,#b3,#77,#2c ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2c,#d1,#7e ;....w...
db #a2,#b3,#77,#cb,#dc,#d1,#7e,#a2 ;..w.....
db #b3,#77,#2d,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2d,#d1,#7e,#a2,#b3,#77,#2d,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2d,#d1,#7e,#a2 ;...w....
db #b3,#77,#2d,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2d,#d1,#7e,#a2,#b3,#77,#2d,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2d,#d1,#7e,#a2 ;...w....
db #b3,#77,#2d,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2d,#d1,#7e,#a2,#b3,#77,#2d,#d1 ;.....w..
db #7e,#a2,#b3,#77,#7c,#c6,#08,#67 ;...w...g
db #30,#08,#7d,#c6,#40,#6f,#7c,#ce ;.....o..
db #c0,#67,#05,#c2,#e9,#26,#b7,#ed ;.g......
db #7b,#02,#ef,#c9,#0e,#40,#e5,#cd
db #ab,#21,#e3,#19,#d1,#ed,#73,#02 ;......s.
db #ef,#f9,#eb,#d1,#7e,#a2,#b3,#77 ;.......w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#2c,#d1,#7e,#a2,#b3,#77 ;.w.....w
db #2c,#d1,#7e,#a2,#b3,#77,#2c,#d1 ;.....w..
db #7e,#a2,#b3,#77,#2c,#d1,#7e,#a2 ;...w....
db #b3,#77,#cb,#dc,#d1,#7e,#a2,#b3 ;.w......
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#2d,#d1,#7e,#a2,#b3 ;..w.....
db #77,#2d,#d1,#7e,#a2,#b3,#77,#2d ;w.....w.
db #d1,#7e,#a2,#b3,#77,#2d,#d1,#7e ;....w...
db #a2,#b3,#77,#7c,#c6,#08,#67,#30 ;..w...g.
db #08,#7d,#c6,#40,#6f,#7c,#ce,#c0 ;....o...
db #67,#05,#c2,#a0,#27,#b7,#ed,#7b ;g.......
db #02,#ef,#c9,#7b,#08,#1e,#00,#01
db #02,#20,#cd,#ab,#21,#d8,#e5,#21
db #39,#29,#19,#eb,#e1,#08,#e6,#08
db #20,#16,#7d,#c6,#0f,#6f,#c5,#d5 ;.....o..
db #e5
lab2896 db #cd
db #bb,#28,#e1,#d1,#c1,#7d,#f6,#3f
db #6f,#cd,#f2,#28,#b7,#c9,#7d,#c6 ;o.......
db #1f,#6f,#c5,#d5,#e5,#cd,#f2,#28 ;.o......
db #e1,#d1,#c1,#7d,#f6,#3f,#6f,#cd ;......o.
db #bb,#28,#b7,#c9,#d5,#e3,#5e,#23
db #56,#23,#e3,#ed,#73,#02,#ef,#f9 ;V...s...
db #33,#d5,#d5,#d5,#d5,#d5,#d5,#d5
db #d5,#cb,#dc,#f9,#33,#d5,#d5,#d5
db #d5,#d5,#d5,#d5,#d5,#7c,#c6,#08
db #67,#30,#08,#7d,#c6,#40,#6f,#7c ;g.....o.
db #ce,#c0,#67,#ed,#7b,#02,#ef,#10 ;..g.....
db #cc,#d1,#c9,#d5,#e3,#5e,#23,#56 ;.......V
db #23,#e3,#ed,#73,#02,#ef,#f9,#33 ;...s....
db #d5,#d5,#d5,#d5,#d5,#d5,#d5,#d5
db #d5,#d5,#d5,#d5,#d5,#d5,#d5,#d5
db #cb,#dc,#f9,#33,#d5,#d5,#d5,#d5
db #d5,#d5,#d5,#d5,#d5,#d5,#d5,#d5
db #d5,#d5,#d5,#d5,#7c,#c6,#08,#67 ;.......g
db #30,#08,#7d,#c6,#40,#6f,#7c,#ce ;.....o..
db #c0,#67,#ed,#7b,#02,#ef,#10,#bc ;.g......
db #d1,#c9,#00,#00,#45,#45,#cf,#cf ;....EE..
db #ca,#cf,#cf,#cf,#cf,#ca,#c5,#c5
db #e7,#e2,#e2,#f3,#f3,#f3,#ff,#f3
db #f3,#f3,#f3,#ff,#f3,#f3,#f7,#fb
db #f3,#f3,#f3,#ff,#fb,#f7,#f7,#fb
db #f3,#f3,#f3,#ff,#f3,#f3,#f7,#fb
db #f3,#f3
lab2969 db #f3
db #f3,#ff,#f3,#f3,#ff,#f3,#f3,#f7
db #fb,#fb,#f7,#f3,#f3,#51,#51,#7a ;.....QQz
db #fe,#67,#3f,#d8,#06,#08,#21,#1d ;.g......
db #96,#c3,#4c,#24,#7a,#fe,#67,#3f ;..L.z.g.
db #d8,#06,#08,#21,#9d,#95,#c3,#4c ;.......L
db #24
lab2993 ld l,#0
    ld d,l
    add hl,hl
    jr nc,lab299A
    add hl,de
lab299A add hl,hl
    jr nc,lab299E
    add hl,de
lab299E add hl,hl
    jr nc,lab29A2
    add hl,de
lab29A2 add hl,hl
    jr nc,lab29A6
    add hl,de
lab29A6 add hl,hl
    jr nc,lab29AA
    add hl,de
lab29AA add hl,hl
    jr nc,lab29AE
    add hl,de
lab29AE add hl,hl
    jr nc,lab29B2
    add hl,de
lab29B2 add hl,hl
    ret nc
    add hl,de
    ret 
data29b6 db #7a
db #fe,#67,#3f,#d8,#3e,#01,#06,#08 ;.g......
db #0e,#01,#cb,#7b,#20,#30,#21,#95
db #98,#c3,#4c,#24,#7a,#fe,#6a,#3f ;..L.z.j.
db #d8,#3e,#03,#06,#0b,#0e,#02,#cb
db #7b,#20,#1b,#21,#13,#99,#c3,#a1
db #24,#7a,#fe,#6a,#3f,#d8,#3e,#05 ;.z.j....
db #06,#0b,#0e,#02,#cb,#7b,#20,#06
db #21,#19,#9a,#c3,#a1,#24,#cb,#bb
db #cd,#30,#01,#79,#87,#83,#fe,#21 ;...y....
db #38,#01,#1d,#cd,#73,#20,#01,#04 ;....s...
db #01,#cd,#15,#01,#3e,#03,#cd,#2d
db #01,#37,#c9,#7a,#fe,#68,#3f,#d8 ;...z.h..
db #06,#09,#21,#9d,#96,#c3,#4c,#24 ;......L.
db #7a,#fe,#68,#3f,#d8,#06,#09,#21 ;z.h.....
db #2d,#97,#c3,#a1,#24,#7a,#fe,#68 ;.....z.h
db #3f,#d8,#06,#09,#21,#05,#98,#c3
db #4c,#24,#7a,#fe,#9f,#3f,#d8,#06 ;L.z.....
db #40,#3c,#90,#57,#d6,#04,#f2,#77 ;...W...w
db #2a,#ed,#44,#4f,#3e,#3f,#91,#cb ;..DO....
db #3f,#cb,#3f,#3c,#47,#79,#cb,#3f ;....Gy..
db #cb,#3f,#83,#5f,#c6,#20,#87,#6f ;.......o
db #26,#c0,#79,#e6,#03,#ee,#03,#57 ;..y....W
db #14,#79,#e6,#03,#0e,#c0,#28 ;.y.....
lab2A6E db #17
db #fe,#02,#28,#4a,#38,#2b,#18,#62 ;...J...b
db #06,#10,#7a,#87,#6f,#26,#fe,#7e ;..z.o...
db #2c,#66,#83,#83,#6f,#0e,#c0,#7d ;.f..o...
db #2f,#e6,#1f,#3c,#32,#96,#2a,#71 ;.......q
db #2c,#3d,#20,#fb,#cb,#dc,#3e,#04
db #2d,#71,#3d,#20,#fb,#cd,#e9,#2b ;.q......
db #c8,#36,#40,#7d,#2f,#e6,#1f,#32
db #b1,#2a,#2c,#71,#3d,#20,#fb,#cb ;...q....
db #dc,#3e,#20,#71,#2d,#3d,#20,#fb ;...q....
db #36,#40,#cd,#e9,#2b,#c8,#36,#00
db #7d,#2f,#e6,#1f,#32,#ce,#2a,#2c
db #71,#3d,#20,#fb,#cb,#dc,#3e,#20 ;q.......
db #71,#2d,#3d,#20,#fb,#77,#cd,#e9 ;q....w..
db #2b,#c8,#36,#00,#2c,#36,#40,#7d
db #2f,#e6,#1f,#32,#ef,#2a,#28,#05
db #2c,#71,#3d,#20,#fb,#cb,#dc,#3e ;.q......
db #20,#b7,#28,#05,#71,#2d,#3d,#20 ;....q...
db #fb,#36,#40,#2d,#77,#cd,#e9,#2b ;....w...
db #c8,#7a,#c6,#04,#57,#1c,#05,#c2 ;.z..W...
db #79,#2a,#b7,#c9,#7a,#fe,#9f,#3f ;y...z...
db #d8,#06,#40,#3c,#90,#57,#d6,#04 ;.....W..
db #f2,#4a,#2b,#ed,#44,#4f,#3e,#3f ;.J..DO..
db #91,#cb,#3f,#cb,#3f,#3c,#47,#79 ;......Gy
db #cb,#3f,#cb,#3f,#83,#5f,#c6,#20
db #87,#6f,#2c,#26,#c0,#79,#e6,#03 ;.o...y..
db #ee,#03,#57,#14,#79,#e6,#03,#0e ;..W.y...
db #c0,#28,#18,#fe,#02,#28,#60,#38
db #37,#18,#78,#06,#10,#7a,#87,#6f ;..x..z.o
db #26,#fe,#7e,#2c,#66,#83,#83,#3c ;....f...
db #6f,#0e,#c0,#36,#00,#2d,#36,#00 ;o.......
db #7d,#e6,#1f,#32,#6f,#2b,#28,#05 ;....o...
db #2d,#71,#3d,#20,#fb,#cb,#dc,#3e ;.q......
db #00,#b7,#28,#05,#71,#2c,#3d,#20 ;....q...
db #fb,#77,#2c,#77,#cd,#e9,#2b,#c8 ;.w.w....
db #36,#00,#2d,#36,#80,#7d,#e6,#1f
db #32,#94,#2b,#28,#05,#2d,#71,#3d ;......q.
db #20,#fb,#cb,#dc,#3e,#00,#b7,#28
db #05,#71,#2c,#3d,#20,#fb,#36,#80 ;.q......
db #2c,#36,#00,#cd,#e9,#2b,#c8,#36
db #00,#7d,#e6,#1f,#32,#b6,#2b,#2d
db #71,#3d,#20,#fb,#cb,#dc,#3e,#01 ;q.......
db #71,#2c,#3d,#20,#fb,#36,#00,#cd ;q.......
db #e9,#2b,#c8,#36,#80,#7d,#e6,#1f
db #32,#d2,#2b,#2d,#71,#3d,#20,#fb ;....q...
db #cb,#dc,#3e,#01,#71,#2c,#3d,#20 ;....q...
db #fb,#36,#80,#cd,#e9,#2b,#c8,#7a ;.......z
db #c6,#04,#57,#1c,#05,#c2,#4c,#2b ;..W...L.
db #b7,#c9,#cd,#8c,#34,#7c,#fe,#c6
db #c9,#7a,#fe,#68,#3f,#d8,#06,#09 ;.z.h....
db #21,#70,#be,#c3,#4c,#24,#7a,#fe ;.p..L.z.
db #6b,#30,#0a,#21,#d9,#8d,#06,#0c ;k.......
db #d5,#cd,#df,#23,#d1,#1d,#7a,#d6 ;......z.
db #0c,#3f,#d0,#fe,#04,#3f,#d0,#57 ;.......W
db #fe,#67,#3f,#d8,#21,#19,#8d,#06 ;.g......
db #08,#c3,#a1,#24,#7a,#fe,#6a,#3f ;....z.j.
db #d8,#06,#0b,#21,#97,#94,#c3,#a1
db #24,#7b,#e6,#1f,#cb,#7b,#20,#1c
db #21,#89,#8f,#e5,#21,#39,#8e,#cb
db #73,#28,#2b,#fd,#72,#5f,#fd,#cb ;s...r...
db #71,#86,#cb,#6b,#28,#20,#fd,#cb ;q..k....
db #71,#c6,#18,#1a,#21,#01,#90,#e5 ;q.......
db #21,#e1,#8e,#cb,#73,#28,#0f,#fd ;....s...
db #72,#5e,#fd,#cb,#71,#8e,#cb,#6b ;r...q..k
db #28,#04,#fd,#cb,#71,#ce,#5f,#06 ;....q...
db #15,#3e,#ec,#cd,#80,#2c,#e1,#d8
db #06,#0f,#3e,#fe,#cd,#80,#2c,#b7
db #c9,#d5,#82,#57,#d6,#04,#b7,#f4 ;...W....
db #df,#23,#d1,#c9,#7a,#fe,#93,#3f ;....z...
db #d8,#cb,#7b,#cb,#bb,#7b,#20,#09
db #21,#99,#91,#e5,#21,#b8,#92,#18
db #07,#21,#79,#90,#e5,#21,#b8,#92 ;..y.....
db #06,#14,#d5,#3e,#40,#cd,#9f,#1e
db #d1,#e1,#06,#0c,#d5,#7a,#d6,#24 ;.....z..
db #57,#fe,#04,#3e,#40,#f4,#9f,#1e ;W.......
db #d1,#7a,#d6,#14,#fe,#04,#3f,#d0 ;.z......
db #57,#01,#00,#10,#cd,#ab,#21,#3f ;W.......
db #d0,#11,#0b,#00,#19,#ed,#73,#02 ;......s.
db #ef,#11,#f0,#f0,#f9,#33,#d5,#d5
db #d5,#d5,#d5,#d5,#cb,#dc,#f9,#33
db #d5,#d5,#d5,#d5,#d5,#d5,#7c,#c6
db #08,#67,#30,#08,#7d,#c6,#40,#6f ;.g.....o
db #7c,#ce,#c0,#67,#10,#de,#ed,#7b ;...g....
db #02,#ef,#b7,#c9
lab2D03 ld a,(labEF06)
    or a
    jr z,lab2D0E
    dec a
    ld (labEF06),a
    ret 
lab2D0E ld hl,(labEF0A)
    ld a,(hl)
    and #7f
    cp #7f
    jr nz,lab2D1E
    ld hl,data2dfb
    ld a,(hl)
    and #7f
lab2D1E inc hl
    ld e,(hl)
    inc hl
    ld (labEF0A),hl
    or a
    jr nz,lab2D2C
    ld a,e
    ld (labEF06),a
    ret 
lab2D2C cp #29
    jr c,lab2D32
    di
    halt
lab2D32 cp #22
    jr nz,lab2D3E
    dec e
    jr nz,lab2D0E
    set 4,(iy+21)
    ret 
lab2D3E call lab2DC9
    jr lab2D0E
data2d43 db #f3
db #76 ;v
lab2D45 ld a,(labEF08)
    or a
    ret z
    ld hl,labE700
lab2D4D ld l,(hl)
    ld e,l
    ld a,l
    add a,#4
    ld l,a
    inc (hl)
    ld l,e
    ld a,(labEF08)
    cp l
    jr nz,lab2D4D
    ret 
lab2D5C bit 4,(iy+21)
    jr nz,lab2D73
    call lab2D45
    call lab2D03
    bit 1,(iy+7)
    ret nz
    ld a,#80
    ld r,a
    jr lab2D76
lab2D73 xor a
    ld r,a
lab2D76 call lab20CC
    call lab1FB4
    call lab1F1F
    ld a,(labEF08)
    or a
    ret z
    ld hl,labE700
lab2D87 ld l,(hl)
lab2D88 push hl
    inc l
    inc l
    ld a,(hl)
    and #7f
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)
    cp #29
    jr nc,lab2DA6
    ld hl,lab2DA8
    push hl
    dec a
    add a,a
    add a,#12
    ld l,a
    ld h,#1c
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    jp (hl)
lab2DA6 di
    halt
lab2DA8 jr nc,lab2DC1
    pop hl
    ld a,(labEF08)
    cp l
    jr z,lab2DBB
    ld a,l
    ld l,(hl)
    push hl
    ld l,a
    call lab2DE4
    pop hl
    jr lab2D88
lab2DBB inc l
    ld a,(hl)
    ld (labEF08),a
    ret 
lab2DC1 pop hl
    ld a,(labEF08)
    cp l
    jr nz,lab2D87
    ret 
lab2DC9 ld b,a
    ld h,#e7
    ld a,(labEF08)
    ld l,a
    ld a,(hl)
    ld l,a
    ld (labEF08),a
    inc l
    inc l
    ld (hl),b
    inc l
    ld (hl),e
    inc l
    ld (hl),#4
    inc l
    ld (hl),#0
    inc l
    ld (hl),#0
    ret 
lab2DE4 ld d,l
    ld a,(hl)
    inc l
    ld l,(hl)
    ld e,l
    ld (hl),a
    ld l,a
    inc l
    ld (hl),e
    ld a,(labEF08)
    ld l,a
    ld e,(hl)
    ld (hl),d
    ld l,d
    ld (hl),e
    inc l
    ld (hl),a
    ld l,e
    inc l
    ld (hl),d
    ret 
data2dfb db #22
db #00,#00,#04,#83,#0c,#00,#05,#83
db #0a,#83,#0e,#00,#1e,#83,#1c,#83
db #02,#00,#15,#82,#9a,#26,#59,#00 ;......Y.
db #14,#87,#14,#00,#14,#83,#08,#00
db #1e,#83,#12,#83,#16,#00,#05,#83
db #14,#00,#19,#83,#09,#00,#14,#82
db #9a,#26,#59,#00,#28,#83,#01,#83 ;..Y.....
db #17,#83,#05,#00,#06,#83,#03,#00
db #10,#8a,#11,#8b,#13,#8b,#16,#8c
db #19,#00,#08,#83,#0d,#0f,#11,#00
db #1c,#83,#18,#82,#00,#26,#c6,#00
db #28,#83,#19,#00,#1e,#82,#8a,#82
db #10,#26,#09,#26,#96,#00,#36,#87
db #14,#00,#04,#20,#00,#00,#05,#22
db #00,#00,#23,#83,#02,#00,#14,#83
db #13,#00,#1e,#8b,#1d,#8b,#1a,#8a
db #18,#00,#08,#13,#19,#00,#06,#11
db #16,#00,#0d,#09,#0b,#09,#1f,#96
db #0c,#00,#17,#00,#01,#1b,#3c,#00
db #0b,#08,#1f,#00,#14,#87,#0f,#00
db #32,#22,#00,#00,#1e,#87,#01,#00
db #23,#87,#09,#00,#14,#87,#12,#00
db #1e,#87,#01,#87,#0e,#87,#1b,#00
db #19,#8a,#02,#8b,#04,#8b,#07,#8c
db #0a,#00,#0a,#11,#03,#00,#0f,#8a
db #13,#8b,#15,#8b,#18,#8c,#1b,#00
db #12,#8a,#04,#8b,#06,#8c,#09,#00
db #09,#10,#05,#00,#05,#22,#00,#00
db #32,#8a,#0d,#8b,#0f,#8c,#12,#00
db #19,#8a,#00,#8b,#02,#8c,#05,#00
db #1c,#8b,#1d,#8b,#1a,#8a,#18,#00
db #08,#0f,#18,#00,#32,#09,#0b,#09
db #1f,#21,#14,#00,#16,#22,#01,#00
db #5e,#1c,#00,#1a,#00,#00,#3c,#1b
db #ff,#00,#28
lab2F0F db #f
db #07,#00,#08,#24,#00,#24,#04,#25
db #08,#00,#19,#23,#14,#24,#16,#25
db #1a,#00,#1e,#23,#02,#24,#04,#25
db #08,#00,#08,#23,#16,#24,#18,#25
db #1c,#00,#1e,#23,#0a,#24,#0c,#24
db #10,#25,#14,#00,#14,#10,#1b,#00
db #0a,#22,#00,#00,#32,#23,#12,#24
db #14,#24,#18,#24,#1c,#00,#19,#23
db #01,#24,#03,#25,#07,#00,#1e,#23
db #0c,#24,#0e,#24,#12,#24,#16,#25
db #1a,#00,#1e,#23,#02,#24,#04,#25
db #08,#00,#3c,#10,#14,#00,#0c,#09
db #0b,#09,#1f,#96,#0c,#00,#17,#00
db #0c,#08,#1f,#00,#50,#22,#00,#00 ;....P...
db #14,#95,#00,#00,#23,#10,#03,#00
db #1e,#28,#19,#00,#0f,#98,#10,#00
db #02,#0d,#08,#00,#19,#00,#05,#00
db #0a,#81,#00,#00,#14,#28,#00,#00
db #32,#81,#1a,#00,#05,#22,#00,#00
db #3c,#81,#00,#00,#1e,#1f,#1a,#00
db #03,#1e,#1a,#00,#0f,#1f,#00,#00
db #03,#1e,#00,#1e,#1a,#00,#13,#1e
db #00,#1e,#1a,#00,#13,#1d,#00,#1d
db #1a,#00,#04,#09,#0b,#09,#1f,#21
db #14,#00,#16,#22,#01,#00,#14,#94
db #86,#00,#19,#94,#94,#00,#28,#94
db #81,#00,#14,#10,#16,#00,#0a,#94
db #8b,#00,#1e,#94,#94,#00,#0a,#94
db #84,#00,#28,#94,#8d,#00,#28,#94
db #86,#00,#19,#94,#99,#00,#23,#23
lab3000 db #12
db #24,#14,#25,#18,#00,#0d,#10,#14
db #94,#81,#00,#16,#94,#8c,#00,#32
db #94,#86,#00,#0a,#22,#00,#00,#05
db #94,#93,#00,#19,#24,#00,#24,#04
db #25,#08,#00,#1e,#94,#88,#00,#1e
db #23,#14,#24,#16,#25,#1a,#00,#28
db #94,#92,#00,#1e,#23,#00,#24,#02
db #24,#06,#25,#0a,#00,#1e,#11,#04
db #00,#28,#09,#0b,#09,#1f,#96,#0c
db #00,#17,#00,#0c,#08,#1f,#00,#5a ;.......Z
db #1a,#00,#00,#1e,#1b,#ff,#00,#05
db #22,#00,#00,#28,#1a,#00,#00,#23
db #1b,#ff,#00,#1e,#1c,#00,#00,#28
db #1a,#00,#00,#3c,#28,#1e,#00,#28
db #1c,#00,#28,#00,#00,#05,#22,#00
db #00,#3c,#0f,#04,#00,#3c,#8a,#02
db #8b,#04,#8c,#07,#8a,#17,#8b,#19
db #8c,#1c,#00,#05,#10,#0a,#10,#13
db #00,#04,#13,#1b,#12,#03,#00,#14
db #09,#0b,#09,#1f,#21,#14,#00,#16
db #22,#01,#00,#46,#28,#46,#00,#14 ;...F.F..
db #98,#10,#00,#02,#0d,#08,#00
lab30B0 db #19
db #00,#05,#00,#19,#10,#19,#00,#19
db #98,#08,#00,#02,#0d,#10,#00
lab30C0 db #19
db #00,#05,#00,#3c,#98,#10,#00,#02
db #0d,#08,#00,#19,#00,#05,#00,#1e
db #22,#00,#00,#14,#28,#46,#83,#02 ;.....F..
db #00,#23,#83,#14,#00,#23,#05,#10
db #00,#11,#8a
lab30E4 db #1
db #8b,#03,#8b,#06,#8c,#09,#00,#19
db #04,#1b,#28,#14,#00,#13,#05,#00
db #06,#10,#00,#03,#04,#15,#11,#04
db #00,#16,#04,#0f,#00,#16,#04,#09
db #00,#0d,#06,#00,#00,#09,#04,#03
db #83,#14,#00,#14,#83,#1b,#00,#32
db #81,#1a,#00,#1e,#28,#00,#00,#28
db #87,#04,#00,#05,#22,#00,#00,#28
db #11,#19,#00,#14,#8a,#14,#8b,#16
db #8c,#19,#00,#32
lab3131 db #10
db #04,#00,#32,#09,#0b,#09,#1f,#21
db #14,#00,#1e,#22,#01,#00,#05,#83
db #05,#00,#05,#83,#0b,#00,#1e,#82
db #80,#26,#ec,#82,#06,#00,#1e,#82
db #9a,#26,#59,#00,#1e,#83,#03,#00 ;..Y.....
db #05,#83,#07,#00,#14,#26,#1f,#82
db #80,#82,#06,#26,#ec,#00,#3c,#0f
db #09,#83,#0c,#00,#08,#83,#0a,#00
db #28,#82,#8a,#82,#10,#26,#09,#26
db #96,#00,#3c,#82,#1a,#82,#94,#26
db #73,#00,#06,#82,#00,#26,#c6,#00 ;s.......
db #32,#22,#00,#00,#05,#83,#0a,#83
db #0e,#00,#08,#83,#0c,#00,#28,#83
db #14,#00,#03,#83,#18,#00,#07,#83
db #1b,#00,#0a,#82,#80,#82,#06,#26
db #ec,#00,#0f,#82,#1a,#82,#94,#26
db #73,#00,#3c,#11,#09,#00,#0e,#09 ;s.......
db #0b,#09,#1f,#96,#0c,#00,#17,#00
db #01,#1b,#3c,#00,#0b,#08,#1f,#00
db #28,#87,#0e,#00,#1e,#87,#04,#00
db #28,#22,#00,#00,#05,#8a,#18,#8b
db #1a,#8b,#1d,#00,#05,#87,#06,#00
db #14,#87,#19,#00,#0f,#87,#10,#00
db #1e,#87,#16,#8b,#00,#8c,#03,#00
db #22,#87,#02,#00,#18,#87,#0b,#00
db #14,#87,#12,#00,#08,#82,#80,#82
db #06,#26,#ec,#00,#14,#87,#19,#00
db #1e,#8a,#0f,#8b,#11,#8c,#14,#00
db #3c,#28,#1e,#23,#0a,#24,#0c,#24
db #10,#25,#14,#00,#14,#25,#0a,#24
db #06,#23,#04,#23,#14,#24,#16,#25
db #1a,#00,#0f,#28,#00,#09,#0b,#09
db #1f,#21,#14,#00,#16,#22,#01,#00
db #28,#81,#00,#00,#32,#81,#1a,#00
db #32,#81,#00,#00,#28,#81,#1a,#00
db #32,#1f,#1a,#1f,#00,#00,#03,#1e
db #1a,#1e,#00,#00,#13,#11,#07,#1e
db #1a,#1e,#00,#00,#13,#1e,#1a,#1e
db #00,#00,#13,#10,#16,#1e,#1a,#1e
db #00,#00,#13,#1e,#1a,#1e,#00,#00
db #13,#1e,#1a,#1e,#00,#00,#13,#1d
db #00,#1d,#1a,#00,#23,#09,#0b,#09
db #1f,#96,#0c,#00,#17,#00,#0c,#08
db #1f,#00,#3c,#25,#00,#00,#1e,#22
db #00,#00,#05,#24,#1c,#23,#1a,#00
db #21,#24,#00,#24,#04,#25,#08,#00
db #19,#23,#10,#24,#12,#24,#16,#28
db #14,#24,#1a,#25,#1e,#00,#0a,#11
db #04,#00,#0e,#98,#10,#00,#02,#0d
db #08,#00,#19,#00,#05,#00,#14,#28
db #00,#23,#0a,#24,#0c,#24,#10,#24
db #14,#25,#18,#00,#28,#24,#00,#24
db #04,#24,#08,#25,#0c,#00,#1e,#23
db #12,#24,#14,#25,#18,#00,#05,#22
db #00,#00,#32,#23,#14,#24,#16,#25
db #1a,#00,#0e,#10,#16,#28,#19,#00
db #1e,#98,#08,#00,#02,#0d,#10,#00
db #19,#00,#05,#00,#19,#23,#06,#24
db #08,#24,#0c,#25,#10,#00,#14,#23
db #10,#24,#12,#28,#00,#24,#16,#25
db #1a,#00,#0f,#24,#00,#24,#04,#24
db #08,#25,#0c,#00,#0f,#09,#0b,#09
db #1f,#21,#14,#00,#16,#22,#01,#00
db #1e,#94,#00,#94,#14,#94,#1a,#00
db #32,#94,#00,#94,#06,#94,#0c,#00
db #1e,#94,#00,#94,#14,#94,#1a,#00
db #28,#94,#00,#94,#06,#94,#0c,#00
db #3c,#94,#00,#94,#06,#94,#12,#00
db #28,#94,#0a,#94,#10,#00,#05,#22
db #00,#00,#32,#94,#00,#94,#1a,#00
db #1e,#94,#0d,#00,#3c,#12,#03,#00
db #02,#11,#1a,#00,#0f,#09,#0b,#09
db #1f,#96,#0c,#00,#17,#00,#0c,#08
db #1f,#00,#3c,#1a,#00,#00,#28,#22
db #00,#00,#3c,#28,#28,#11,#04,#00
db #1e,#1c,#00,#00,#50,#28,#0c,#00 ;....P...
db #32,#11,#03,#00,#64,#0f,#19,#00 ;....d...
db #05,#22,#00,#00,#05,#28,#0c,#00
db #78,#28,#00,#00,#1e,#09,#0b,#09 ;x.......
db #1f,#21,#14,#00,#16,#22,#01,#00
db #3c,#8a,#07,#8b,#09,#8b,#0c,#8c
db #0f,#00,#28,#98,#08,#00,#02,#0d
db #10,#00,#19,#00,#05,#00,#0f,#98
db #10,#00,#02,#0d,#08,#00,#19,#00
db #05,#00,#1e,#8b,#00,#8b,#03,#8c
db #06,#8b,#1d,#8a,#1b,#00,#28,#95
db #00,#00,#28,#1b,#ff,#00,#0a,#10
db #14,#00,#14,#1b,#ff,#00,#05,#22
db #00,#00,#1e,#11,#15,#00,#05,#83
db #02,#00,#23,#83,#14,#00
lab3400 db #23
db #05,#10,#00,#11,#8b,#00,#8b,#03
db #8c,#06,#00,#09,#12,#02,#00,#0e
db #04,#1b,#00,#03,#28,#14,#00,#10
db #05,#00,#06,#10,#00,#03,#04,#15
db #00,#16,#04,#0f,#00,#16,#04,#09
db #00,#0d,#06,#00,#00,#0d,#04,#03
db #11,#19,#00,#28,#10,#06,#00,#14
db #95,#00,#00,#3c,#0f,#0a,#00,#05
db #22,#00,#00,#05,#28,#14,#00,#82
db #10,#04,#28,#00,#00,#32,#09,#0b
db #09,#1f,#21,#14,#00,#1e,#22,#01
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab3480 jp lab34D0
lab3483 jp lab349A
lab3486 jp lab34A0
lab3489 jp lab34A5
lab348C jp lab34B2
data348f db #c3
db #c0,#34,#00,#3c,#00,#3c,#80,#bc
db #80,#bc
lab349A add a,l
    ld l,a
    adc a,h
    sub l
    ld h,a
    ret 
lab34A0 ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ret 
lab34A5 ld a,l
    srl a
    ld l,h
    sla l
    ld h,#fe
    add a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ret 
lab34B2 ld a,h
    add a,#8
    ld h,a
    ret nc
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    ld h,a
    ret 
data34c0 db #7c
db #d6,#08,#67,#e6,#40,#c0,#7d,#d6 ;..g.....
db #40,#6f,#7c,#de,#c0,#67,#c9 ;.o...g.
lab34D0 set 5,(ix+11)
    ld d,(ix+4)
    ld e,(ix+0)
    ld (ix+0),d
    ld a,d
    add a,#2
    cp #22
    jr c,lab34EC
    ld a,e
    add a,#2
    cp #22
    jp nc,lab3D15
lab34EC ld b,(ix+5)
    ld c,(ix+1)
    ld a,(ix+8)
    sub (ix+10)
    cp b
    jp m,lab3500
    cp c
    jp p,lab3D19
lab3500 ld a,(ix+9)
    cp b
    jp p,lab350B
    cp c
    jp m,lab3D15
lab350B exx
    ld a,(ix+2)
    add a,a
    add a,#92
    bit 2,(ix+11)
    jr z,lab3519
    inc a
lab3519 ld l,a
    ld h,#34
    ld l,(hl)
    ld a,(ix+3)
    add a,#5e
    ld h,a
    exx
    ld a,(ix+6)
    ld (ix+2),a
    add a,a
    add a,#92
    bit 2,(ix+11)
    jr z,lab3534
    inc a
lab3534 ld l,a
    ld h,#34
    ld l,(hl)
    ld a,(ix+7)
    ld (ix+3),a
    add a,#5e
    ld h,a
    ld a,d
    cp #1e
    jp nc,lab37BC
    ld a,e
    cp #1e
    jp nc,lab37BC
    ld a,(ix+8)
    dec a
    cp b
    jp p,lab3C50
    cp c
    jp p,lab3C50
    push hl
    ld h,(ix+1)
    ld a,(ix+5)
    cp h
    jr nc,lab3564
    ld h,a
lab3564 ld a,(ix+9)
    sub h
    inc a
    ex af,af''
    ld a,d
    add a,a
    ld l,h
    sla l
    ld h,#fe
    add a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ld a,d
    sub e
    ex de,hl
    pop hl
    exx
    ex af,af''
    ld e,a
    or a
    ex af,af''
    ld (labEF02),sp
    ld sp,hl
    ld a,(ix+1)
    ld c,#0
    jp c,lab3705
    jp nz,lab3651
    sub (ix+5)
    jr z,lab35A2
    ld hl,lab35A2
    ld b,a
    ld c,a
    jp nc,lab3BF8
    neg
    ld b,a
    ld c,a
    jp lab3B8E
lab35A2 ld a,(ix+10)
    sub c
    ld b,a
    ld hl,data3627
lab35AA exx
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    set 3,d
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
lab3604 or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    ld a,d
    add a,#8
    ld d,a
    jr nc,lab361F
    ld a,e
    add a,#40
    ld e,a
    ld a,d
    adc a,#c0
    ld d,a
lab361F exx
    dec e
    jp z,lab3D2C
    djnz lab35AA
    jp (hl)
data3627 db #d9
db #08,#3e,#00,#17,#17,#83,#5f,#d9
db #dd,#7e,#05,#dd,#6e,#01,#95,#28 ;....n...
db #0d,#21,#46,#36,#47,#d2,#f8,#3b ;..F.G...
db #ed,#44,#47,#c3,#8e,#3b ;.DG...
lab3646 ld a,(ix+5)
    ld (ix+1),a
    ld sp,(labEF02)
    ret 
lab3651 sub (ix+5)
    jr z,lab366E
    ld hl,lab366E
    ld b,a
    ld c,a
    jp nc,lab3BF8
    exx
    dec e
    dec e
    exx
    ld hl,lab3672
    neg
    ld b,a
    ld c,a
    scf
    ex af,af''
    jp lab3B8E
lab366E exx
    dec e
    dec e
    exx
lab3672 ld a,(ix+10)
    sub c
    ld b,a
    ld hl,data3627
lab367A exx
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    set 3,d
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    ld a,d
    add a,#8
    ld d,a
    jr nc,lab36FB
    ld a,e
    add a,#40
    ld e,a
    ld a,d
    adc a,#c0
    ld d,a
lab36FB exx
    dec e
    jp z,lab3D2C
    dec b
    jp nz,lab367A
    jp (hl)
lab3705 sub (ix+5)
    jr z,lab3729
    ld hl,lab3729
    ld b,a
    ld c,a
    ex af,af''
    scf
    ex af,af''
    jp nc,lab3BF8
    neg
    ld b,a
    ld c,a
    exx
    inc e
    inc e
    exx
    or a
    ex af,af''
    ld hl,data3725
    jp lab3B8E
data3725 db #d9
db #1d,#1d,#d9
lab3729 ld a,(ix+10)
    sub c
    ld b,a
    ld hl,data3627
lab3731 exx
    pop bc
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    set 3,d
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    ld a,d
    add a,#8
    ld d,a
    jr nc,lab37B2
    ld a,e
    add a,#40
    ld e,a
    ld a,d
    adc a,#c0
    ld d,a
lab37B2 exx
    dec e
    jp z,lab3D2C
    dec b
    jp nz,lab3731
    jp (hl)
lab37BC push de
    push hl
    or a
    jp p,lab3826
    ld hl,data37f2
    push hl
    ld a,c
    ld c,b
    dec a
    cp (ix+9)
    ret p
    add a,(ix+10)
    cp (ix+8)
    ret m
    sub (ix+10)
    inc a
    ld b,#0
    call lab387E
    ld a,e
    cp #2
    jr c,lab37EB
    inc a
    jp z,lab392C
    inc a
    ret nz
    jp lab397B
lab37EB exx
    add a,e
    ld e,a
    exx
    jp lab38C9
data37f2 db #d9
db #e1,#d9,#d1,#21,#25,#3d,#e5,#79 ;.......y
db #3d,#dd,#be,#09,#f0,#dd,#86,#0a
db #dd,#be,#08,#f8,#dd,#96,#0a,#3c
db #06,#00,#cd,#7e,#38,#5a,#7b,#fe ;.....Z..
db #02,#38,#09,#3c,#ca,#96,#3a,#3c
db #c0,#c3,#dc,#3a,#d9,#83,#5f,#d9
db #c3,#40,#3a
lab3826 ld hl,data3850
    push hl
    ld a,c
    ld c,b
    dec a
    cp (ix+9)
    ret p
    add a,(ix+10)
    cp (ix+8)
    ret m
    sub (ix+10)
    inc a
    ld b,e
    call lab387E
    ld a,e
    cp #20
    ret nc
    sub #1f
    jp z,lab3A05
    inc a
    jp z,lab39B6
    jp lab38C9
data3850 db #d9
db #e1,#d9,#d1,#21,#25,#3d,#e5,#5a ;.......Z
db #79,#3d,#dd,#be,#09,#f0,#dd,#86 ;y.......
db #0a,#dd,#be,#08,#f8,#dd,#96,#0a
db #3c,#43,#cd,#7e,#38,#7b,#fe,#20 ;.C......
db #d0,#d6,#1f,#ca,#58,#3b,#3c,#ca ;....X...
db #12,#3b,#c3,#40,#3a
lab387E cp (ix+8)
    jp m,lab38A3
    ld l,a
    ex af,af''
    sla l
    ld h,#fe
    ld a,(hl)
    add a,b
    add a,b
    inc l
    ld h,(hl)
    ld l,a
    push hl
    exx
    pop de
    ex af,af''
    ld b,(ix+10)
    sub (ix+9)
    neg
    cp b
    jr nc,lab38A1
    inc a
    ld b,a
lab38A1 exx
    ret 
lab38A3 add a,(ix+10)
    sub (ix+8)
    exx
    ld b,a
    ld a,(ix+10)
    sub b
    ld e,a
    add a,a
    add a,e
    add a,a
    add a,a
    add a,l
    ld l,a
    ex de,hl
    ld l,(ix+8)
    sla l
    ld h,#fe
    ld a,(hl)
    inc l
    exx
    add a,b
    add a,b
    exx
    ld h,(hl)
    ld l,a
    ex de,hl
    exx
    ret 
lab38C9 ld (labEF02),sp
    exx
    ld sp,hl
    ex de,hl
lab38D0 pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    inc l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    inc l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    set 3,h
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    dec l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    dec l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab3924
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    cp #c6
    jr z,lab3926
    ld h,a
lab3924 djnz lab38D0
lab3926 exx
    ld sp,(labEF02)
    ret 
lab392C ld (labEF02),sp
    exx
    ld sp,hl
    ex de,hl
lab3933 pop de
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    inc l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    set 3,h
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    dec l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    pop de
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab3973
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    cp #c6
    jr z,lab3975
    ld h,a
lab3973 djnz lab3933
lab3975 exx
    ld sp,(labEF02)
    ret 
lab397B ld (labEF02),sp
    exx
    ld sp,hl
    ex de,hl
lab3982 pop de
    pop de
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    set 3,h
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    pop de
    pop de
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab39AE
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    cp #c6
    jr z,lab39B0
    ld h,a
lab39AE djnz lab3982
lab39B0 exx
    ld sp,(labEF02)
    ret 
lab39B6 ld (labEF02),sp
    exx
    ld sp,hl
    ex de,hl
lab39BD pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    inc l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    pop de
    pop de
    set 3,h
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    dec l
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab39FD
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    cp #c6
    jr z,lab39FF
    ld h,a
lab39FD djnz lab39BD
lab39FF exx
    ld sp,(labEF02)
    ret 
lab3A05 ld (labEF02),sp
    exx
    ld sp,hl
    ex de,hl
lab3A0C pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    inc l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    pop de
    pop de
    pop de
    pop de
    set 3,h
    pop de
    ld a,e
    cpl 
    and (hl)
    ld (hl),a
    dec l
    ld a,d
    cpl 
    and (hl)
    ld (hl),a
    ld a,h
    add a,#8
    ld h,a
    jr nc,lab3A38
    ld a,l
    add a,#40
    ld l,a
    ld a,h
    adc a,#c0
    cp #c6
    jr z,lab3A3A
    ld h,a
lab3A38 djnz lab3A0C
lab3A3A exx
    ld sp,(labEF02)
    ret 
data3a40 db #ed
db #73,#02,#ef,#d9,#f9,#e1,#1a,#b5 ;s.......
db #12,#1c,#1a,#b4,#12,#1c,#e1,#1a
db #b5,#12,#1c,#1a,#b4,#12,#1c,#e1
db #1a,#b5,#12,#1c,#1a,#b4,#12,#cb
db #da,#e1,#1a,#b5,#12,#1d,#1a,#b4
db #12,#1d,#e1,#1a,#b5,#12,#1d,#1a
db #b4,#12,#1d,#e1,#1a,#b5,#12,#1d
db #1a,#b4,#12,#7a,#c6,#08,#57,#30 ;...z..W.
db #0c,#7b,#c6,#40,#5f,#7a,#ce,#c0 ;.....z..
db #fe,#c6,#28,#03,#57,#10,#b6,#d9 ;....W...
db #ed,#7b,#02,#ef,#c9,#ed,#73,#02 ;......s.
db #ef,#d9,#f9,#e1,#e1,#1a,#b5,#12
db #1c,#1a,#b4,#12,#1c,#e1,#1a,#b5
db #12,#1c,#1a,#b4,#12,#cb,#da,#e1
db #1a,#b5,#12,#1d,#1a,#b4,#12,#1d
db #e1,#1a,#b5,#12,#1d,#1a,#b4,#12
db #e1,#7a,#c6,#08,#57,#30,#0c,#7b ;.z..W...
db #c6,#40,#5f,#7a,#ce,#c0,#fe,#c6 ;...z....
db #28,#03,#57,#10,#c6,#d9,#ed,#7b ;..W.....
db #02,#ef,#c9,#ed,#73,#02,#ef,#d9 ;....s...
db #f9,#e1,#e1,#e1,#1a,#b5,#12,#1c
db #1a,#b4,#12,#cb,#da,#e1,#1a,#b5
db #12,#1d,#1a,#b4,#12,#e1,#e1,#7a ;.......z
db #c6,#08,#57,#30,#0c,#7b,#c6,#40 ;..W.....
db #5f,#7a,#ce,#c0,#fe,#c6,#28,#03 ;.z......
db #57,#10,#d6,#d9,#ed,#7b,#02,#ef ;W.......
db #c9,#ed,#73,#02,#ef,#d9,#f9,#e1 ;..s.....
db #1a,#b5,#12,#1c,#1a,#b4,#12,#1c
db #e1,#1a,#b5,#12,#1c,#1a,#b4,#12
db #e1,#e1,#cb,#da,#e1,#1a,#b5,#12
db #1d,#1a,#b4,#12,#1d,#e1,#1a,#b5
db #12,#1d,#1a,#b4,#12,#7a,#c6,#08 ;.....z..
db #57,#30,#0c,#7b,#c6,#40,#5f,#7a ;W......z
db #ce,#c0,#fe,#c6,#28,#03,#57,#10 ;......W.
db #c6,#d9,#ed,#7b,#02,#ef,#c9,#ed
db #73,#02,#ef,#d9,#f9,#e1,#1a,#b5 ;s.......
db #12,#1c,#1a,#b4,#12,#e1,#e1,#e1
db #cb,#da,#e1,#e1,#1a,#b5,#12,#1d
db #1a,#b4,#12,#7a,#c6,#08,#57,#30 ;...z..W.
db #0c,#7b,#c6,#40,#5f,#7a,#ce,#c0 ;.....z..
db #fe,#c6,#28,#03,#57,#10,#d6,#d9 ;....W...
db #ed,#7b,#02,#ef,#c9
lab3B8E exx
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    inc e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    inc e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    set 3,d
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    dec e
    pop bc
    ld a,(de)
    cpl 
    or c
    cpl 
    ld (de),a
    dec e
    ld a,(de)
    cpl 
    or b
    cpl 
    ld (de),a
    ld a,d
    add a,#8
    ld d,a
    jr nc,lab3BF0
    ld a,e
    add a,#40
    ld e,a
    ld a,d
    adc a,#c0
    cp #c6
    jp z,lab3646
    ld d,a
lab3BF0 exx
    dec e
    jp z,lab3D2C
    djnz lab3B8E
    jp (hl)
lab3BF8 exx
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
lab3C00 ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    inc e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    set 3,d
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    dec e
    ld a,(de)
    or (hl)
    ld (de),a
    inc l
    ld a,d
    add a,#8
    ld d,a
    jr nc,lab3C48
    ld a,e
lab3C3C add a,#40
    ld e,a
    ld a,d
    adc a,#c0
    cp #c6
    jp z,lab3646
    ld d,a
lab3C48 exx
    dec e
    jp z,lab3D2C
    djnz lab3BF8
    jp (hl)
lab3C50 push hl
    ld (labEF02),sp
    sub c
    exx
    inc a
    jp m,lab3C62
    ld c,a
    add a,a
    add a,c
    add a,a
    add a,a
    add a,l
    ld l,a
lab3C62 ld sp,hl
    exx
    ld a,e
    ex af,af''
    ld a,c
    exx
lab3C68 cp (ix+8)
    jp p,lab3C71
    ld a,(ix+8)
lab3C71 ld c,a
    add a,a
    ld l,a
    ld h,#fe
    ex af,af''
    add a,a
    add a,(hl)
    inc l
    ld d,(hl)
    ld e,a
    exx
    ld a,c
    sub (ix+8)
    add a,(ix+10)
    dec a
    jp m,lab3CA9
    cp (ix+10)
    inc a
    jr c,lab3C91
    ld a,(ix+10)
lab3C91 ld b,a
    exx
    add a,c
    exx
    dec a
lab3C96 sub (ix+9)
    jr c,lab3CA1
    jr z,lab3CA1
    neg
    add a,b
    ld b,a
lab3CA1 ld e,#0
    ld hl,lab3CA9
    jp lab3B8E
lab3CA9 ld a,(ix+8)
    ld c,(ix+5)
    sub c
    exx
    ld c,a
    ld a,#0
    jp m,lab3CBC
    ld a,c
    add a,a
    add a,c
    add a,a
    add a,a
lab3CBC ld sp,(labEF02)
    pop hl
lab3CC1 ld (labEF02),sp
    add a,l
    ld l,a
    exx
    ld a,d
    ex af,af''
    ld a,c
    exx
    cp (ix+8)
    jp p,lab3CD5
    ld a,(ix+8)
lab3CD5 ld c,a
    add a,a
    ex de,hl
    ld l,a
    ld h,#fe
    ex af,af''
    add a,a
    add a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ex de,hl
    exx
    ld a,c
    sub (ix+8)
    add a,(ix+10)
    dec a
    jp m,lab3D0F
    cp (ix+10)
    inc a
    jr c,lab3CF7
    ld a,(ix+10)
lab3CF7 ld b,a
    exx
    add a,c
    exx
    dec a
    sub (ix+9)
    jr c,lab3D07
    jr z,lab3D07
    neg
    add a,b
    ld b,a
lab3D07 ld e,#0
    ld hl,lab3D0F
    jp lab3BF8
lab3D0F ld sp,(labEF02)
    jr lab3D1F
lab3D15 res 5,(ix+11)
lab3D19 ld a,(ix+6)
    ld (ix+2),a
lab3D1F ld a,(ix+7)
    ld (ix+3),a
    ld a,(ix+5)
    ld (ix+1),a
    ret 
lab3D2C ld a,(ix+5)
    ld (ix+1),a
    ld sp,(labEF02)
    ret 
data3d37 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #c3,#9f,#3d
lab3D43 jp lab3FCA
lab3D46 jp lab3FEB
lab3D49 jp lab3D9F
data3d4c db #c3
db #cf,#40
lab3D4F jp lab3E8D
lab3D52 jp lab3FE7
lab3D55 call lab1C03
    ld ix,labE600
lab3D5C inc (ix+5)
    ld de,lab0014
    add ix,de
    ld a,(ix+0)
    sub #90
    jr nz,lab3D5C
    ld (labEF6E),a
    ret 
lab3D6F ld a,(labEF7B)
    or a
    ret z
    dec (iy+125)
    ret nz
    ld (labEF7D),a
    call lab3FCA
    ld b,#4
    ld l,#ff
    bit 7,a
    jr z,lab3D8A
    ld b,#c
    ld l,#1f
lab3D8A and #f
    sub #4
    ld h,a
    call lab4212
    add a,b
    ld b,a
    ld c,#c
    call lab420F
    ret z
    set 6,(ix+11)
    ret 
lab3D9F ld hl,labE600
    xor a
lab3DA3 ld (hl),a
    inc l
    jr nz,lab3DA3
    ld a,#90
    ld (labE6C7+1),a
    ld (labE6DD),a
    ld iy,labEF00
    ld (iy+110),#0
    ld hl,labE6C7+2
    ld (hl),#10
    inc hl
    ld (hl),#40
    inc hl
    ld (hl),#2
    inc hl
    inc hl
    ex de,hl
    ld hl,labE6C7+2
    ld bc,lab0004
    ldir
    ex de,hl
    inc hl
    inc hl
    ld (hl),#a
    inc hl
    ld (hl),#30
    inc hl
    call lab5324
    ld hl,labEF1B
    ld a,(hl)
    add a,#24
    ld (hl),a
    inc l
    xor #aa
    ld (hl),a
    inc l
    rrca 
    ld (hl),a
    xor #aa
    ld (hl),a
    ld a,#90
    ld (labEF17),a
    ld (labEF5E),a
    ld (labEF5F),a
    ld (iy+112),#88
    ld (iy+22),#88
    ld (iy+93),#1
    jp lab3F60
data3e04 db #2
db #03,#02,#03,#04,#05,#06,#06,#06
db #06,#06,#06,#07,#08,#09,#0a,#09
db #0a,#09,#0a,#0b,#0c,#0d,#0d,#0d
db #0d,#0d,#0d,#0e,#0f,#02,#03,#26
db #26,#1e,#1e
lab3E28 db #1f
db #1f,#1e,#1e,#1f,#1f,#00,#00,#00
db #00,#25,#25,#20,#20,#09,#09
lab3E38 ld ix,labE600
lab3E3C bit 5,(ix+11)
    call nz,lab3E54
    ld de,lab0014
    add ix,de
    ld a,(ix+0)
    cp #90
    ret z
    jr lab3E3C
lab3E50 ld ix,labE6C7+2
lab3E54 ld a,(ix+12)
    bit 4,(ix+11)
    jr z,lab3E69
    cp #10
    jr nc,lab3E69
    bit 0,a
    jr z,lab3E69
    and #fe
    or #2
lab3E69 add a,a
    ld e,a
    ld a,(ix+16)
    and #2
    rra 
    add a,e
    ld e,a
    ld d,#0
    ld hl,data3e04
    add hl,de
    ld a,(hl)
    bit 4,(ix+11)
    jr z,lab3E82
    add a,#e
lab3E82 ld (ix+7),a
    ld a,(ix+18)
    cp #9
    jp z,lab3F34
lab3E8D ld a,(labEF17)
    cp #88
    jp nc,lab3F34
    sub #d
    jp c,lab3F34
    cp #4
    jp c,lab3F34
    ld b,a
    ld a,(ix+5)
    sub b
    jp p,lab3F34
    add a,#a
    jp p,lab3EAE
    jr lab3EDF
lab3EAE ld a,b
    cp #5f
    jr nc,lab3EDA
    ld c,#5f
    cp (ix+8)
    jr z,lab3EF9
    push bc
    ld h,a
    dec h
    ld a,h
    cp #60
    jr nc,lab3ED7
    ld l,#3b
    call lab3489
    ld bc,lab0500
lab3ECA ld (hl),c
    inc l
    djnz lab3ECA
    set 3,h
lab3ED0 dec l
    ld b,#5
lab3ED3 ld (hl),c
    dec l
    djnz lab3ED3
lab3ED7 pop bc
    jr lab3EF9
lab3EDA res 5,(ix+11)
    ret 
lab3EDF ld a,b
    sub #1f
    jr nc,lab3EE8
    ld c,#5f
    jr lab3EF9
lab3EE8 cp #4
    jr nc,lab3EF0
    ld a,#4
    jr lab3EF6
lab3EF0 cp #5f
    jr c,lab3EF6
    ld a,#5f
lab3EF6 ld c,a
lab3EF7 ld b,#4
lab3EF9 ld (ix+9),c
    ld (ix+8),b
lab3EFF ld a,(ix+5)
    cp b
    jp p,lab3F0C
    add a,#a
    cp c
    jp p,lab3F21
lab3F0C call lab3F3C
    ld a,(ix+18)
    cp #7
    jr z,lab3F1C
    ld a,(ix+4)
    cp #1f
    ret nc
lab3F1C set 5,(ix+11)
    ret 
lab3F21 ld a,(ix+5)
    cp #e0
    jr nc,lab3F0C
    cp #40
    jr c,lab3F0C
    ld (ix+12),#16
    ld (ix+7),#0
lab3F34 ld (ix+8),#4
    ld (ix+9),#5f
lab3F3C bit 4,(ix+11)
lab3F40 jr nz,lab3F5B
    bit 6,(ix+11)
    jp z,lab3480
    ld a,(ix+18)
    ld c,#2
    cp #c
    jp z,lab3F5D
    cp #e
    jr nz,lab3F5D
    ld c,#4
    jr lab3F5D
lab3F5B ld c,#0
lab3F5D jp lab1C0F
lab3F60 bit 0,(iy+98)
    jr z,lab3F7A
    ld a,(labE6D3+2)
    cp #19
    jr nc,lab3F7A
    call lab0133
    ld a,#19
    ld (labE6D3+2),a
    ld a,#2
    ld (labE6D9+1),a
lab3F7A bit 0,(iy+7)
    jr z,lab3F7A
    res 0,(iy+7)
    ld a,(labEF6E)
    cp #32
    jr nc,lab3F8E
    inc (iy+110)
lab3F8E bit 5,(iy+21)
    jr z,lab3F99
    call lab3D55
    jr lab3F9C
lab3F99 call lab1C06
lab3F9C call lab3E38
    res 5,(iy+21)
    call lab4209
    call lab4200
    call lab4203
    call lab4206
    call lab5309
    call lab5312
    call lab5303
    call lab3E50
    call lab5306
    call lab420C
    call lab0127
    call lab3D6F
    jp lab3F60
lab3FCA ld a,(labEF1B)
    and #48
    add a,#38
    rla 
    rla 
    rl (iy+30)
    rl (iy+29)
    rl (iy+28)
    rl (iy+27)
    ld a,(labEF1B)
    ret 
lab3FE7 ld e,#2
    jr lab3FED
lab3FEB ld e,#0
lab3FED ld (labEF02),sp
    ld sp,labFF00
lab3FF4 xor a
    ex af,af''
    pop bc
    ld a,c
    bit 7,a
    jr nz,lab402F
lab3FFC sub l
    jr c,lab4002
    sub e
lab4000 jr nc,lab4021
lab4002 add a,b
    jr c,lab4008
    sub e
lab4006 jr nc,lab4021
lab4008 pop bc
    ld a,c
    sub h
    jp m,lab3FF4
    sub b
    jp p,lab3FF4
lab4012 ld sp,(labEF02)
    ex af,af''
lab4017 jr nz,lab4025
    scf
    ret 
lab401B ld sp,(labEF02)
    xor a
    ret 
lab4021 pop bc
    jp lab3FF4
lab4025 set 0,(iy+98)
    set 7,(ix+11)
    scf
    ret 
lab402F cp #80
    jr z,lab401B
    and #7f
    bit 1,a
    jr z,lab404A
    inc e
    dec e
    jr z,lab4045
    bit 4,(ix+11)
    jr z,lab4045
    inc a
    ex af,af''
lab4045 ld a,c
    and #7c
    jr lab3FFC
lab404A bit 2,a
    jr nz,lab4072
    inc e
    dec e
    jr z,lab4021
    bit 4,(ix+11)
    jr z,lab4021
    ld a,b
    sub l
    jr nc,lab4021
    add a,#8
    jr nc,lab4021
    pop bc
    ld a,c
    sub h
    jr c,lab3FF4
    sub #8
    jr nc,lab3FF4
    ld c,b
    ld b,#e7
    ld a,(bc)
    or #80
    ld (bc),a
    jr lab401B
lab4072 ld (labEF33),de
    pop de
    ld c,a
    sub l
    jr nc,lab40C8
    add a,b
    jr nc,lab40C8
    sub d
lab407F jr nc,lab40A7
    ld a,e
    sub h
    jr c,lab40C8
lab4085 sub d
    jr nc,lab4098
    ld a,e
    sub h
    ld b,a
    ld a,l
    sub d
    sub c
    cp b
    jr nc,lab40C8
lab4091 ld de,(labEF33)
    jp lab4012
lab4098 sub d
    jr nc,lab40C8
    ld a,h
    sub e
    add a,b
    ld b,a
    ld a,l
    sub d
    sub c
    cp b
    jr nc,lab40C8
    jr lab4091
lab40A7 ld a,e
    sub h
lab40A9 jr c,lab40C8
    sub d
    jr nc,lab40B9
    ld a,e
    sub h
    ld b,a
    ld a,c
    add a,d
    sub l
    cp b
    jr nc,lab40C8
    jr lab4091
lab40B9 sub d
    jr nc,lab40C8
    ld a,h
    sub e
    add a,b
    ld b,a
    ld a,c
    add a,d
    sub l
    cp b
    jr nc,lab40C8
    jr lab4091
lab40C8 ld de,(labEF33)
lab40CC jp lab3FF4
data40cf db #dd
db #cb,#0b,#4e,#20,#63,#7d,#fe,#20 ;..N.c...
db #30,#5e,#e5,#d5,#7d,#87,#87,#c6
db #04,#83,#6f,#7c,#c6,#06,#67,#cd ;..o...g.
db #e7,#3f,#d1,#e1,#30,#4a,#dd,#cb ;.....J..
db #0b,#66,#20,#43,#7c,#fe,#60,#30 ;.f.C....
db #04,#fe,#03,#30,#05,#dd,#36,#0c
lab4100 db #16
db #c9,#dd,#7e,#12,#fe,#05,#28,#20
db #fe,#04,#28,#08,#fe,#01,#28,#04
db #fe,#0c,#20,#14,#cd,#12,#42,#dd ;......B.
db #86,#13,#ee,#08,#e6,#0f,#47,#e6 ;......G.
db #07,#20,#01,#04,#dd,#70,#13,#c9 ;.....p..
db #cd,#12,#42,#dd,#86,#0c,#c6,#04 ;..B.....
db #e6,#0f,#dd,#77,#0c,#c9,#c9,#dd ;...w....
db #75,#04,#dd,#73,#06,#7a,#fe,#04 ;u..s.z..
db #38,#08,#fe,#0d,#30,#04,#dd,#74 ;.......t
db #05,#c9,#dd,#cb,#0b,#66,#28,#f6 ;.....f..
db #7c,#fe,#3c,#30,#f1,#fd,#cb,#05
db #5e,#28,#16,#fd,#cb,#15,#66,#28 ;......f.
db #0c,#fe,#1a,#30,#e1,#dd,#cb,#0b
db #4e,#28,#06,#18,#d9,#fd,#cb,#15 ;N.......
db #ee,#c9,#24,#18,#d1,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab41AA db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00
lab41FF db #0
lab4200 jp lab4601
lab4203 jp lab4DD2
lab4206 jp lab4801
lab4209 jp lab4E61
lab420C jp lab43EA
lab420F jp lab4552
lab4212 jp lab42AC
data4215 db #c3
db #7f,#48,#83,#00,#8b,#00,#05,#05 ;.H......
db #80,#00,#80,#00,#80,#00,#88,#00
db #8d,#00,#81,#00,#08,#09,#88,#ff
db #08,#09,#80,#00,#80,#00,#85,#00
db #86,#00,#86,#00,#87,#00,#87,#00
db #8a,#00,#84,#00,#8e,#00,#80,#00
db #82,#00,#80,#00,#80,#00,#80,#00
db #80,#00,#18,#03,#90,#00,#18,#04
db #80,#00,#80,#00,#80,#00,#8f,#00
db #89,#00,#8c,#00,#04,#26,#6b,#4e ;......kN
db #8b,#50,#b2,#50,#61,#51,#00,#52 ;.P.PaQ.R
db #2d,#52,#3f,#52,#65,#52,#46,#50 ;.R.ReRFP
db #06,#50,#4c,#4f,#e5,#4e,#37,#4f ;.PLO.N.O
db #24,#4f,#20,#4f,#33,#4f,#a3,#4f ;.O.O.O.O
db #a8,#42,#9c,#4c,#1b,#4c,#69,#4d ;.B.L.LiM
db #9c,#4c,#83,#49,#6d,#49,#00,#00 ;.L.ImI..
db #6e,#4c,#81,#4c,#83,#49,#00,#00 ;nL.L.I..
db #c9,#4a,#90,#4b,#99,#52,#d4,#4a ;.J.K.R.J
db #df,#4a,#c1,#c3,#00,#64 ;.J...d
lab42AC call lab3D43
    and #3
    ret z
    dec a
    dec a
    ret 
lab42B5 ld hl,labEF70+2
    ld de,labEF43
    ld a,(de)
    inc a
    jr z,lab42C2
    call lab42D1
lab42C2 ld hl,labEF73
    ld de,labEF45
    ld a,(de)
    inc a
    jr z,lab4324
    call lab42D1
    jr lab4324
lab42D1 push de
    push hl
    ex de,hl
    add a,#8
    ld e,a
    inc l
    ld d,(hl)
    srl e
    ld hl,lab59F4
    ld b,#1d
    call lab487F
    pop de
    pop hl
    jr z,lab42F0
    inc l
    set 7,(hl)
    ld bc,lab4B02
    jp lab0115
lab42F0 ex de,hl
    dec (hl)
    ret nz
    ld (hl),#28
    ld a,(de)
    add a,#3b
    ret c
    sub #a
    and #f8
    rra 
    rra 
    rra 
    ld l,a
    inc e
    ld a,(de)
    sub #e
    ret c
    ld h,a
    push hl
    ld bc,lab1002
    call lab4552
    pop de
    ret z
    ld (hl),#fd
    dec l
    dec l
    ld (hl),#a
    dec l
    dec l
    ld (hl),#0
    dec l
    ld (hl),#0
    dec l
    ld (hl),d
    dec l
    dec l
    set 6,(hl)
    ret 
lab4324 ld a,(labEF4B)
    inc a
    jp z,lab43B2
    dec a
    add a,a
    add a,a
    add a,#8
    ld e,a
    ld a,(labEF4C)
    ld d,a
    cp #50
    ld hl,labEF78
    jr c,lab4341
    inc l
    ld (hl),#0
    jr lab4390
lab4341 inc (hl)
    ld b,#1f
    cp #20
    jr nc,lab4353
    srl b
    ld a,(labEF65)
    cp #5
    jr c,lab4353
    srl b
lab4353 ld a,(hl)
    and b
    push hl
    jr nz,lab436C
    push de
    ex de,hl
    ld a,(labEF63)
    add a,#4
    ld c,a
    ld a,(labEF64)
    add a,#4
    ld b,a
    ld a,#5
    call lab5300
    pop de
lab436C ld hl,lab5A00
    ld b,#10
    ld a,e
    sub #6
    ld e,a
    ld a,d
    sub #10
    ld d,a
    call lab487F
    pop hl
    jr z,lab4390
    inc l
    inc (hl)
    ld a,(hl)
    cp #e
    jr c,lab4390
    set 7,(iy+75)
    ld bc,lab0F03
    call lab0115
lab4390 ld a,(labEF4B)
    add a,a
    add a,a
    sub #3
    sub (iy+99)
    jr nc,lab43B2
    add a,#d
    jr nc,lab43B2
    ld a,(labEF4C)
    sub #17
    sub (iy+100)
    jr nc,lab43B2
    add a,#c
    jr nc,lab43B2
    set 0,(iy+98)
lab43B2 ld hl,labEF47
    ld a,(hl)
    inc a
    call nz,lab43BF
    ld hl,labEF49
    ld a,(hl)
    ret z
lab43BF ld a,(labEF63)
    add a,#7
    sub (hl)
    ret c
    sub #16
    ret nc
    ld a,(labEF64)
    inc l
    sub (hl)
    ret nc
    add a,#10
    ret nc
    ld a,(labEF4E)
    cp #3d
    ret c
    set 0,(iy+98)
    ret 
lab43DD ld bc,lab0806
    ld h,#4
    call lab4552
    ld (ix+10),#7
    ret 
lab43EA call lab42B5
    dec (iy+93)
    jr z,lab43FF
    bit 4,(iy+21)
    ret z
    ld a,(labEF7A)
    cp #14
    jr nc,lab4451
    ret 
lab43FF ld a,(labEF65)
    cp #7
    jr c,lab4408
    ld a,#7
lab4408 srl a
    neg
    add a,#3
    add a,a
    add a,a
    add a,a
    add a,a
    add a,#1e
    ld (iy+93),a
    bit 4,(iy+21)
    jp z,lab44A9
    ld a,(labEF7A)
    or a
    jr nz,lab444D
    ld a,(labEF65)
    and #3
    jr nz,lab444D
    push af
    ld l,#2
    call lab43DD
    ld l,#8
    call lab43DD
    set 7,(ix+11)
    ld l,#14
    call lab43DD
    set 7,(ix+11)
    ld l,#1b
    call lab43DD
    pop af
    ld (iy+122),#4
lab444D cp #14
lab444F jr c,lab445F
lab4451 ld a,(labEF7C)
    or a
    ret nz
    ld a,(labE6D3+1)
    set 1,a
    ld (labE6D3+1),a
    ret 
lab445F ld (iy+93),#a
    ld l,#f
    call lab3D43
    bit 7,a
    jr nz,lab446D
    dec l
lab446D and #7
    add a,#ff
    ld h,a
    call lab42AC
    add a,#8
    ld b,a
    ld c,#f
    ld a,(labEF7A)
    cp #a
    jr nz,lab4482
    dec c
lab4482 push bc
    call lab4552
    pop bc
    ret z
    ld a,c
    cp #e
    jr nz,lab449D
    set 1,(ix+11)
    set 6,(ix+11)
    set 0,(ix+12)
    ld (ix+17),#20
lab449D inc (iy+122)
    call lab3D43
    and #1
    jp z,lab4D33
    ret 
lab44A9 call lab3D43
    and #4
    jr z,lab44BA
    ld l,#1f
    ld bc,lab0C00
    ld a,(labEF5F)
    jr lab44C2
lab44BA ld l,#fe
    ld bc,lab0400
    ld a,(labEF5E)
lab44C2 cp #60
    jr nc,lab44F1
    cp #28
    jr c,lab44F1
    sub #20
lab44CC ld h,a
    bit 3,b
lab44CF ld a,(labEF70+1)
    jr nz,lab44D5
    rra 
lab44D5 ld c,#18
    rra 
    jr nc,lab44DC
    ld c,#30
lab44DC push bc
    ld c,#2
    rlc (iy+22)
lab44E3 jr c,lab44E9
    ld (iy+93),#8
lab44E9 call lab4552
    pop bc
    ld (ix+17),c
    ret 
lab44F1 ld a,(labEF17)
    cp #5e
    jr nc,lab451B
    cp #2a
    jr c,lab451B
    ld h,a
    ld c,#7
lab44FF rlc (iy+112)
    jr nc,lab450D
    ld c,#9
    ld a,h
    sub #24
    ld h,a
    jr lab4552
lab450D ld a,h
    sub #37
    ld h,a
    ld a,l
    xor #1
    ld l,a
    ld (iy+93),#28
    jr lab4552
lab451B ld a,(labEF6E)
    cp #32
    jr c,lab452A
    ld c,#4
    srl (iy+93)
    jr lab4531
lab452A call lab3D43
    and #e
    jr nz,lab453D
lab4531 call lab3D43
    ld c,#4
    bit 7,a
    jr z,lab454D
    inc c
    jr lab454D
lab453D call lab3D43
    and #1e
    ld l,a
    ld h,#ff
    call lab42AC
    add a,#8
    ld b,a
    jr lab4552
lab454D and #3f
    add a,#8
    ld h,a
lab4552 exx
    ld hl,labE600
lab4556 ld a,(hl)
    cp #90
    ret z
    ld a,l
    add a,#b
    ld l,a
    bit 5,(hl)
    jr z,lab4567
    add a,#9
    ld l,a
    jr lab4556
lab4567 sub #b
    ld l,a
    push hl
    exx
    ld d,#20
    ld a,c
    cp #9
    jr z,lab457F
    cp #b
    jr z,lab457F
    cp #2
    jr z,lab457F
    cp #f
    jr nz,lab4581
lab457F set 1,d
lab4581 push bc
    push hl
    ld a,l
    cp #20
    jr c,lab4589
    xor a
lab4589 add a,a
    add a,a
    add a,#7
    ld l,a
    ld a,h
    add a,#6
    ld h,a
    call lab3D52
    pop hl
    pop bc
    jr nc,lab45AC
    ld a,c
    cp #6
    jr z,lab45AC
    cp #a
    jr z,lab45AC
    bit 1,d
    jr nz,lab45AC
    pop hl
    ld (iy+93),#1
    ret 
lab45AC ex de,hl
    ex (sp),hl
    push hl
    pop ix
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    ld (hl),#0
    inc l
    ld (hl),#0
    inc l
    ld (hl),e
    inc l
    ld (hl),d
    inc l
    ld (hl),#3
    inc l
    ld (hl),#0
    inc l
    ld (hl),#4
    inc l
    ld (hl),#5f
    inc l
    ld (hl),#a
    inc l
    pop de
    ld (hl),d
    inc l
    ld (hl),b
    inc l
    ld (hl),#0
    ld a,l
    add a,#3
    ld l,a
    ld (hl),#0
    inc l
    ld e,#f
    ld a,c
    cp #7
    jr z,lab45E7
    cp #8
    jr nz,lab45E9
lab45E7 ld e,#38
lab45E9 ld (hl),e
    inc l
    ld (hl),c
    inc l
    ld (hl),b
    cp #c
lab45F0 ret nz
    ld (ix+12),#18
    or a
lab45F6 ret 
data45f7 db #4
db #0c,#0c,#08,#06,#0a,#04,#00,#02
db #0e
lab4601 ld ix,labE6C7+2
    ld a,(labE6CB+2)
    add a,a
    add a,a
    add a,(ix+6)
    ld (labEF63),a
    ld e,a
    ld a,(labE6CE)
    ld (labEF64),a
    ld d,a
    bit 1,(ix+11)
    jr z,lab4657
    bit 4,(ix+12)
    jr z,lab462C
    ld (ix+12),#0
    ld (ix+10),#a
lab462C ld a,e
    cp #40
    jr nz,lab4643
    ld a,d
    or a
    jr nz,lab463F
    res 0,(iy+98)
    ld (iy+122),#0
    pop af
    ret 
lab463F ld d,#8
    jr lab464B
lab4643 jr c,lab4649
    ld d,#2
    jr lab464B
lab4649 ld d,#1
lab464B ld a,(labEF05)
    and #f0
    or d
    ld (labEF05),a
    jp lab468F
lab4657 ld a,(labE6D3+2)
    cp #10
    jr c,lab468F
    dec (ix+17)
    ret nz
    ld b,#19
    ld a,b
    ld (labE6D3+2),a
    ld (ix+17),#2
    ld a,(labE6D3)
    ld b,a
    ld a,#f
    xor b
    add a,a
    add a,#64
    ld c,a
    xor a
    di
    call lab0136
    ei
    ld a,b
    dec a
    ld (labE6D3),a
    dec a
    jr nz,lab468B
    set 0,(iy+98)
    pop af
    ret 
lab468B inc (ix+5)
    ret 
lab468F ld a,(labEF05)
    and #f
    ret z
    cp #b
    jr c,lab469B
    ld a,#8
lab469B ld hl,lab45F6
    ld c,a
    ld b,#0
    add hl,bc
    ld a,(hl)
    ld d,a
    ld e,(ix+12)
    sub e
    jr z,lab46DE
    bit 4,e
    jr nz,lab46DE
    call lab46BB
    ld a,e
    and #f
    ld (ix+12),a
    ld d,a
    jp lab46DE
lab46BB ld b,a
    and #f
    cp #5
    jr c,lab46D6
    cp #8
    jr z,lab46D8
    jr c,lab46D3
    cp #c
    jr c,lab46CE
    dec e
    ret 
lab46CE dec e
    dec e
    dec e
    dec e
    ret 
lab46D3 inc e
    inc e
    inc e
lab46D6 inc e
    ret 
lab46D8 bit 7,b
    jr nz,lab46D3
    jr lab46CE
lab46DE inc (ix+16)
    ld h,(ix+5)
    ld l,(ix+4)
    ld e,(ix+6)
    ld a,d
    cp #10
    jr z,lab46F8
    cp #17
    jr nz,lab471E
    call lab477C
    jr lab46FB
lab46F8 call lab474B
lab46FB ld (ix+6),e
    ld (ix+4),l
    ld d,(ix+15)
    ld e,(ix+14)
    ld h,(ix+19)
    call lab531E
    ld (ix+15),h
    ld (ix+14),l
    ld (ix+19),c
    ld a,(ix+13)
    add a,h
    ld (ix+5),a
    ret 
lab471E ld bc,data472b
    push bc
    or a
    ret z
    cp #8
    ret z
    jr c,lab474B
    jr lab477C
data472b db #7d
db #fe,#81,#38,#09,#fe,#fe,#30,#05
db #dd,#cb,#0b,#ae,#c9,#7a,#fe,#04 ;.....z..
db #ca,#c6,#47,#38,#6a,#fe,#0c,#ca ;..G.j...
db #c6,#47,#da,#de,#47,#18,#60 ;.G..G..
lab474B cp #1
    jr z,lab4753
    cp #7
    jr nz,lab4758
lab4753 bit 0,(ix+16)
    ret z
lab4758 bit 4,(ix+11)
    jr z,lab4763
    bit 0,(iy+5)
    ret z
lab4763 ld a,e
    inc a
    and #3
    ld e,a
    jr z,lab476B
    ret 
lab476B ld a,l
    inc a
    cp #1e
    jr nc,lab4773
lab4771 ld l,a
    ret 
lab4773 bit 4,(ix+11)
    jr z,lab4771
    ld e,#3
    ret 
lab477C cp #9
    jr z,lab4784
    cp #f
    jr nz,lab4789
lab4784 bit 0,(ix+16)
    ret z
lab4789 bit 4,(ix+11)
    jr z,lab4796
    bit 1,(iy+5)
    jr nz,lab4796
    ret 
lab4796 ld a,e
    dec a
    and #3
    ld e,a
    cp #3
    ret nz
    dec l
    ld a,l
    inc a
    ret nz
    bit 4,(ix+11)
    ret z
    inc l
    ld e,#0
    ret 
data47ab db #fe
db #03,#28,#04,#fe,#0d,#20,#06,#dd
db #cb,#10,#46,#28,#0d,#dd,#cb,#0b ;..F.....
db #66,#28,#06,#fd,#cb,#05,#5e,#28 ;f.......
db #01,#25,#7c,#fe,#61,#38,#10,#fe ;....a...
db #fa,#30,#0c,#dd,#7e,#12,#fe,#07
db #28,#05,#dd,#cb,#0b,#ae,#c9,#c3
db #4c,#3d,#fe,#05,#28,#04,#fe,#0b ;L.......
db #20,#06,#dd,#cb,#10,#46,#28,#da ;.....F..
db #7c,#3c,#fe,#55,#38,#0c,#dd,#cb ;...U....
db #0b,#66,#28,#06,#7a,#fe,#08,#c8 ;.f..z...
db #18,#01,#67,#18,#c5 ;..g..
lab4801 ld a,(labEF7C)
    ld (labEF7E),a
    ld (iy+124),#0
    ld ix,labE600
lab480F bit 5,(ix+11)
    jp z,lab4ABB
    ld a,(ix+4)
    add a,a
    add a,a
    add a,(ix+6)
    ld e,a
    ld d,(ix+5)
    ld a,(ix+18)
    cp #a
    jr z,lab4835
    cp #6
    jr z,lab4835
    ld a,d
    cp #61
    jr nc,lab4835
    inc (iy+124)
lab4835 ld hl,lab5A00
    ld b,#9
    inc e
    inc e
    ld a,(ix+12)
    cp #13
    jr c,lab4847
    cp #17
    jr c,lab4872
lab4847 ld a,(ix+18)
    sub #a
    jr z,lab4872
    inc a
    jr z,lab4872
    call lab487F
    jr z,lab4872
lab4856 ld (ix+12),#13
    ld (ix+17),#10
    ld (ix+6),#0
    ld bc,lab0203
    ld a,(ix+18)
    cp #e
    jr nz,lab486D
    inc c
lab486D call lab0115
    jr lab4896
lab4872 ld hl,lab59F4
    ld b,#1d
    call lab487F
    jr nz,lab4856
    jr lab4896
lab487E inc l
lab487F ld a,(hl)
    inc l
    cp #90
    ret z
    sub d
    jr c,lab487E
    cp b
    jr nc,lab487E
    ld a,e
    sub (hl)
    jr nc,lab487E
    neg
    cp b
    jr nc,lab487E
    inc b
    dec b
    ret 
lab4896 bit 4,(ix+12)
    jr nz,lab48BF
    ld a,(ix+18)
    cp #9
    jr z,lab48BF
    ld a,(labEF64)
    sub d
    jr nc,lab48BF
    add a,#5
    jr nc,lab48BF
    ld a,(labEF63)
    add a,#3
    sub e
    jr nc,lab48B7
    neg
lab48B7 cp #6
    jr nc,lab48BF
    set 0,(iy+98)
lab48BF ld a,(ix+12)
    ld d,a
    cp #10
    jp c,lab4A74
    jr z,lab48E6
    cp #18
    jp z,lab4A74
    cp #16
    jr nz,lab48DA
    res 5,(ix+11)
    jp lab4ABB
lab48DA cp #11
    jr z,lab491D
    cp #12
    jr z,lab4945
    cp #17
    jr nz,lab4901
lab48E6 dec (ix+17)
    ld d,a
    jr nz,lab48FE
    ld (ix+18),#0
    call lab4CF9
    ld (ix+12),a
    ld (ix+17),#10
    res 1,(ix+11)
lab48FE jp lab4AB8
lab4901 dec (ix+17)
    ld b,#16
    jr z,lab4917
    inc (ix+16)
    ld a,(ix+16)
    dec b
    rra 
    jr nc,lab4917
    dec b
    rra 
    jr nc,lab4917
    dec b
lab4917 ld (ix+12),b
    jp lab4ABB
lab491D dec (ix+17)
    jp nz,lab4ABB
    ld (ix+12),#12
    ld (ix+17),#4
    ld d,(ix+5)
    ld a,(ix+4)
    add a,a
    add a,a
    add a,(ix+6)
    sub #3
    ld e,a
    ld c,#0
    push ix
    call lab52DE
    pop ix
    jp lab4ABB
lab4945 dec (ix+17)
    jp nz,lab4ABB
    ld (ix+17),#12
    ld a,(ix+18)
    cp #8
    jp z,lab4C81
    cp #4
    jr nz,lab4964
    call lab4CF9
    ld (ix+12),a
    jp lab4ABB
lab4964 ld a,(ix+19)
    ld (ix+12),a
    jp lab4ABB
lab496D ld a,#2
    ld e,(ix+6)
    dec e
    dec e
    jr z,lab4978
    jr lab497D
lab4978 ld (ix+12),#11
    add a,a
lab497D ld (ix+17),a
    jp lab4ABB
data4983 db #cd
db #f9,#4c,#dd,#77,#0c,#cd,#43,#3d ;.L.w..C.
db #1f,#38,#de,#e6,#0c,#20,#08,#dd
db #7e,#12,#fe,#09,#c4,#33,#4d,#dd ;......M.
db #36,#11,#0e,#c3,#94,#4a ;.....J
lab49A2 dec (ix+17)
    jp nz,lab4ABB
    ld a,(ix+19)
    or a
    jr z,lab49D8
    cp #3
    jr z,lab49D8
    cp #1
    jr nz,lab49C0
    call lab4CF9
    ld (ix+12),b
    ld a,#1
    jr lab49D8
lab49C0 call lab4CF9
    ld (ix+12),a
    call lab3D43
    bit 6,a
    push af
    push bc
    call nz,lab4D33
    pop bc
    pop af
    and #2
    jr nz,lab49D8
    jr lab4A06
lab49D8 inc a
    and #3
    ld (ix+19),a
    ld d,a
    ld bc,lab0113
    call lab3D43
    and #1f
    add a,c
    ld c,a
    ld a,d
    bit 0,a
    jr z,lab49F0
    ld c,#4
lab49F0 inc a
    and #2
    ld a,b
    jr z,lab49F8
    neg
lab49F8 ld b,a
    add a,(ix+5)
    ld (ix+5),a
lab49FF ld a,(ix+10)
    sub b
    ld (ix+10),a
lab4A06 ld (ix+17),c
    jp lab4ABB
lab4A0C ld l,(ix+4)
    ld a,(ix+5)
    ld h,a
    cp #60
    jr nc,lab4A71
    cp #2e
    jr c,lab4A31
    ld (ix+18),#1
    call lab42AC
    and #f
    ld (ix+12),a
    ld (ix+19),a
    ld (ix+10),#a
    jp lab4ABB
lab4A31 bit 4,(iy+21)
    jr nz,lab4A3B
    cp #14
    jr c,lab4A71
lab4A3B ld a,(labE6CB+2)
    sub l
    jr z,lab4A54
    jr nc,lab4A4A
    inc a
    jr z,lab4A54
    ld b,#a
    jr lab4A56
lab4A4A dec a
    jr z,lab4A54
    dec a
    jr z,lab4A54
    ld b,#6
    jr lab4A56
lab4A54 ld b,#8
lab4A56 ld (ix+12),b
    dec (ix+17)
    jr nz,lab4A71
    ld (ix+17),#19
    call lab3D43
    and #3
    jr z,lab4A6E
    ld a,b
    cp #8
    jr nz,lab4A71
lab4A6E call lab4D33
lab4A71 jp lab4ABB
lab4A74 ld a,(ix+18)
    cp #6
    jr z,lab4A0C
    cp #a
    jp z,lab49A2
    dec (ix+17)
    jp nz,lab4A94
    ld a,(ix+18)
    add a,a
    add a,#88
    ld l,a
    ld h,#42
    ld e,(hl)
    inc l
    ld h,(hl)
    ld l,e
    jp (hl)
lab4A94 ld a,(ix+18)
    cp #d
    jp z,lab4ABB
    cp #4
    jr z,lab4AB0
    cp #9
    jr z,lab4AB0
    cp #1
    jr z,lab4AB0
    cp #c
    jr z,lab4AB0
    cp #f
    jr nz,lab4AB5
lab4AB0 ld d,(ix+19)
    jr lab4AB8
lab4AB5 ld d,(ix+12)
lab4AB8 call lab46DE
lab4ABB ld de,lab0014
    add ix,de
    ld a,(ix+0)
    cp #90
    ret z
    jp lab480F
data4ac9 db #dd
db #cb,#0b,#8e,#dd,#36,#12,#00,#c3
db #9c,#4c,#dd,#cb,#0b,#8e,#dd,#36 ;.L......
db #11,#30,#c3,#94,#4a,#dd,#7e,#05 ;....J...
db #fe,#24,#30,#34,#dd,#7e,#13,#57 ;.......W
db #fe,#04,#38,#04,#fe,#0c,#38,#0f
db #dd,#36,#12,#01,#dd,#cb,#0b,#8e
db #dd,#36,#11,#10,#c3,#94
lab4B00 db #4a
db #dd
lab4B02 db #46
db #13,#dd,#36,#11,#0b,#cd,#43,#3d ;......C.
db #e6,#03,#20,#6c ;...l
lab4B0F db #cd
db #43,#3d,#e6,#0f,#dd,#77,#0c,#c3 ;C....w..
db #94,#4a,#dd,#cb,#0b,#8e,#cd,#43 ;.J.....C
db #3d,#f5,#e6,#07,#20,#1c,#f1,#f5
db #e6,#18,#20,#07,#f1,#dd,#36,#12
db #04,#18,#c3,#f1,#dd,#36,#12,#00
db #e6,#e0,#18,#ba,#dd,#cb,#0b,#fe
db #18,#b4,#f1,#dd,#36,#11,#05,#cd
db #f9,#4c,#dd,#70,#13,#cd,#43,#3d ;.L.p..C.
db #cb,#7f,#28,#1d,#e6,#0f,#4f,#78 ;......Ox
db #e6,#07,#20,#0f,#79,#fe,#04,#28 ;....y...
db #08,#fe,#0c,#20,#06,#0e,#0a,#18
db #02,#0e,#02,#dd,#71,#0c,#c3,#94 ;....q...
db #4a,#cd,#43,#3d,#e6,#0f,#f6,#01 ;J.C.....
db #dd,#77,#13,#dd,#70,#0c,#3a,#7e ;.w..p...
db #ef,#fe,#01,#28,#05,#cd,#43,#3d ;......C.
db #e6,#07,#cc,#33,#4d,#c3,#94,#4a ;....M..J
db #dd,#cb,#0b,#4e,#28,#10,#dd,#35 ;...N....
db #0e,#dd,#36,#11,#01,#c2,#bb,#4a ;.......J
db #dd,#cb,#0b,#8e,#18,#6e,#dd,#56 ;.....n.V
db #05,#dd,#7e,#04,#87,#87,#dd,#86
db #06,#5f,#0e,#02,#3a,#63,#ef,#93 ;.....c..
db #30,#04,#ed,#44,#0e,#00,#47,#3a ;...D..G.
db #64,#ef,#92,#38,#4f,#b8,#38,#4c ;d...O..L
db #78,#fe,#14,#30,#02,#0e,#01,#dd ;x.......
db #e5,#c5,#0e,#00,#cd,#de,#52,#c1 ;......R.
db #28,#38,#dd,#71,#0c,#dd,#cb,#00 ;...q....
db #c6,#dd,#cb,#00,#ce,#1e,#04,#3a
db #65,#ef,#fe,#04,#38,#0c,#1c,#fe ;e.......
db #06,#38,#07,#1c,#fe,#08,#38,#02
db #1e,#08,#dd,#73,#06,#dd,#36,#07 ;...s....
db #73,#dd,#e1,#dd,#36,#11,#01,#dd ;s.......
db #cb,#0b,#ce,#dd,#36,#0e,#03,#c3
db #bb,#4a,#dd,#e1,#dd,#36,#11,#1c ;.J......
db #c3,#94,#4a,#06,#10,#3a,#65,#ef ;..J...e.
db #fe,#04,#38,#02,#06,#09,#dd,#70 ;.......p
db #11,#cd,#43,#3d,#e6,#01,#28,#35 ;..C.....
db #cd,#f9,#4c,#dd,#7e,#13,#e6,#07 ;..L.....
db #20,#0f,#78,#fe,#04,#28,#08,#fe ;..x.....
db #0c,#20,#06,#06,#0a,#18,#02,#06
db #06,#dd,#70,#0c,#3a,#65,#ef,#3d ;..p..e..
db #fe,#03,#06,#03,#38,#05,#06,#01
db #28,#01,#05,#cd,#43,#3d,#a0,#cc ;....C...
db #33,#4d,#c3,#94,#4a,#dd,#7e,#13 ;.M..J...
db #dd,#77,#0c,#c3,#94,#4a,#dd,#36 ;.w...J..
db #12,#01,#16,#08,#dd,#72,#0c,#dd ;.....r..
db #72,#13,#dd,#36,#11,#1a,#c3,#b8 ;r.......
db #4a ;J
lab4C81 inc (ix+13)
    ld a,(ix+13)
    cp #5
    jp c,lab496D
    ld a,(ix+19)
    xor #8
    ld (ix+12),a
    ld (ix+17),#40
    ld d,a
    jp lab4AB8
data4c9c db #dd
db #cb,#0b,#7e,#20,#28,#cd,#43,#3d ;......C.
db #e6,#0f,#57,#c6,#19,#dd,#77,#11 ;..W...w.
db #06,#01,#3a,#65,#ef,#fe,#05,#38 ;...e....
db #08,#06,#03,#fe,#07,#38,#02,#06
db #07,#dd,#7e,#10,#a0,#20,#06,#dd
db #72,#0c,#c3,#b8,#4a,#c5,#cd,#f9 ;r...J...
db #4c,#dd,#70,#0c,#e1,#dd,#cb,#0b ;L.p.....
db #7e,#20,#09,#cd,#43,#3d,#a4,#20 ;....C...
db #15,#c3,#94,#4a,#dd,#36,#11,#11 ;...J....
db #dd,#34,#0f,#dd,#7e,#0f,#e6,#07
db #20,#04,#dd,#cb,#0b,#be,#cd,#33
db #4d,#c3,#94,#4a ;M..J
lab4CF9 ld a,(labE6CE)
    ld bc,data0000
    sub (ix+5)
    jr c,lab4D0C
    sub #10
    jr c,lab4D12
    set 2,c
    jr lab4D12
lab4D0C add a,#10
    jr c,lab4D12
    set 3,c
lab4D12 ld a,(labE6CB+2)
    cp (ix+4)
    jr z,lab4D2A
    jr nc,lab4D24
    add a,#1
    jr c,lab4D2A
    set 1,c
    jr lab4D2A
lab4D24 sub #1
    jr c,lab4D2A
    set 0,c
lab4D2A ld hl,lab45F6
    add hl,bc
    ld a,(hl)
    and #f
    ld b,a
    ret 
lab4D33 push ix
    push ix
    pop hl
    call lab4E40
    ld a,h
    cp #60
    jr nc,lab4D66
    cp #5
    jr c,lab4D66
    ld a,l
    cp #80
    jr nc,lab4D66
    ld a,(labE6CE)
    add a,#4
    ld b,a
    ld a,(labEF63)
    add a,#4
    ld c,a
    ld a,(labEF65)
    inc a
    rra 
    inc a
    cp #8
    jr c,lab4D61
    ld a,#7
lab4D61 or #80
    call lab5300
lab4D66 pop ix
    ret 
data4d69 db #dd
db #7e,#0c,#fe,#08,#38,#04,#3e,#17
db #18,#02,#3e,#10,#dd,#77,#0c,#dd ;.....w..
db #36,#13,#f6,#dd,#36,#11,#10,#dd
db #36,#0f,#00,#dd,#36,#0e,#00,#dd
db #7e,#05,#dd,#77,#0d,#c3,#bb,#4a ;...w...J
lab4D92 db #4
db #ff,#00,#fc,#07,#02,#02,#fc,#07
db #02,#03,#fd,#07,#02,#04,#fe,#07
db #04,#04,#00,#07,#07,#04,#02,#07
db #07,#03,#03,#07,#07,#02,#04,#04
db #0a,#00,#04,#00,#06,#fe,#04,#00
db #06,#fd,#03,#00,#06,#fc,#02,#00
db #05,#fc,#00,#00,#01,#fc,#fe,#00
db #01,#fd,#fd,#00,#01,#fe,#fc
lab4DD2 ld a,(labE6D3+2)
    cp #10
    ret nc
    bit 4,(iy+5)
    ld a,(labEF15)
    ld d,a
    jr nz,lab4DF4
    and #70
    ld (labEF15),a
lab4DE7 bit 5,(iy+5)
    jr nz,lab4E03
    bit 6,a
    ret z
    res 6,a
    jr lab4E2D
lab4DF4 bit 7,a
    jr z,lab4E2B
    inc a
    ld (labEF15),a
    and #f
    cp #f
    ld a,d
    jr c,lab4DE7
lab4E03 ld a,(labEF15)
    and #f0
    ld (labEF15),a
    ld a,(labEF67)
    or a
    ret z
    ld a,(labE6C7+2)
    add a,a
    add a,a
    ld l,a
    ld a,(labE6CA)
    ld h,a
    sub #30
    jr nc,lab4E20
    ld a,#4
lab4E20 ld b,a
    ld c,l
    call lab531B
    ret z
    ld a,#ff
    jp lab0130
lab4E2B or #c0
lab4E2D ld (labEF15),a
    ld hl,labE6C7+2
    ld a,(labE6D3+2)
    ld b,a
    call lab4E40
    call lab530C
    jp lab012D
lab4E40 ld a,(hl)
    add a,a
    add a,a
    ld e,a
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)
    add a,e
    ld e,a
    ld hl,lab4D92
    ld a,b
    add a,a
    add a,a
    ld c,a
    ld b,#0
    add hl,bc
    ld a,(hl)
    add a,e
    ld e,a
    inc hl
    ld a,(hl)
    add a,d
    ld d,a
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    ex de,hl
    ret 
lab4E61 ld (iy+23),#ff
    ld hl,labE700
    ld de,labFF00
lab4E6B ld a,l
    and #f8
    ld l,a
    cp (iy+8)
    jr z,lab4E9D
    ld l,(hl)
    inc l
    inc l
    ld a,(hl)
    and #3f
    cp #27
    jr nc,lab4E6B
    add a,a
    add a,#16
    ld c,a
    ld b,#42
    inc l
    ld a,(hl)
    and #1f
    add a,a
    add a,a
    ld (de),a
    ld a,(bc)
    bit 7,a
    jr nz,lab4EC8
    inc e
    ld (de),a
    inc e
    inc c
    inc l
    ld a,(hl)
    ld (de),a
    inc e
    ld a,(bc)
    ld (de),a
    inc e
    jr lab4E6B
lab4E9D ld a,(labEF4B)
    inc a
    jr z,lab4EB7
    dec a
    add a,a
    add a,a
    ld (de),a
    ex de,hl
    inc l
    ld (hl),#10
    inc l
    ld a,(labEF4C)
    sub #6
    ld (hl),a
    inc l
    ld (hl),#4
    inc l
    ex de,hl
lab4EB7 ld a,#80
    ld (de),a
    xor a
    ex af,af''
    xor a
    call lab0124
    ld (labEF74),a
    ex af,af''
    ld (labEF75),a
    ret 
lab4EC8 and #7f
    exx
    add a,a
lab4ECC ld h,#42
    add a,#64
    ld l,a
    ld e,(hl)
    inc l
    ld d,(hl)
    push de
    exx
    ret 
data4ed7 db #eb
db #2c,#77,#2c,#1c,#1a,#77,#2c,#70 ;.w...w.p
db #2c,#36,#80,#eb,#c9,#4e,#3e,#1c ;.....N..
db #06,#2d,#cd,#d7,#4e,#2c,#fe,#20 ;....N...
db #30,#2b,#fe,#06
lab4EF4 db #30
db #04,#36,#08,#18,#23,#35,#20,#20
db #cd,#43,#3d ;.C.
lab4F00 db #e6
db #0f,#c6,#14,#77,#e5,#d5,#fd,#36 ;...w....
db #16,#aa,#79,#b7,#28,#09,#fe,#18 ;..y.....
db #38,#08,#cd,#b0,#44,#18,#03,#cd ;....D...
db #ba,#44,#d1,#e1,#c3,#6b,#4e,#2c ;.D...kN.
db #7e,#18,#0a,#3a,#17,#ef,#3c,#20
db #07,#2c,#7e,#c6,#26,#32,#17,#ef
db #18,#ea,#1a,#c6,#04,#12,#1a,#f6
db #82,#12,#eb,#2c,#36,#04,#2c,#1c
db #1a,#d6,#04,#77,#2c,#36,#02,#2c ;...w....
db #eb,#18,#d1,#7e,#e6,#1f
lab4F4F db #4f
db #3e,#1c,#06,#12,#cd,#d7,#4e,#2c ;......N.
db #d6,#12,#30,#04,#36,#00,#18,#bd
db #c6,#04,#fe,#4e,#30 ;...N.
lab4F65 db #f8
db #47,#7e,#e6,#1f,#20,#07,#cd,#43 ;G......C
db #3d,#e6,#1f,#c6,#1e,#77,#35,#20 ;.....w..
db #e7,#cd,#43,#3d,#e6,#c0,#c6,#3c ;..C.....
db #77,#e5,#d5,#60,#69,#01,#0b,#08 ;w...i...
db #2c,#cb,#7d,#cb,#bd,#28,#02,#06
db #06
lab4F8F db #cd
db #52,#45,#28,#0b,#cd,#43,#3d,#e6 ;RE...C..
db #03,#20,#04,#dd,#cb,#0b,#fe,#d1
db #e1,#18,#bb,#7e,#e6,#1f,#4f,#3e ;......O.
db #18,#06,#14,#cd,#d7,#4e,#2c,#d6 ;.....N..
db #12,#30,#05,#36,#00,#c3,#6b,#4e ;......kN
db #c6,#04,#fe,#4e,#30,#f7,#47,#7e ;...N..G.
db #b7,#20,#0d,#78,#fe,#08,#38,#ed ;...x....
db #cd,#43,#3d,#e6,#80,#c6,#28 ;.C.....
lab4FCF db #77
db #35,#20,#e2,#cd,#43,#3d,#e6,#3f ;....C...
db #c6,#0c,#fd,#cb,#15,#66,#28,#0c ;.....f..
db #3a,#7a,#ef,#fe ;.z..
lab4FE4 db #14
db #30,#ce,#fd,#34,#7a,#18,#02,#c6 ;....z...
db #af,#77,#e5,#d5,#60,#69,#01,#0b ;.w...i..
db #04,#7d,#2c,#2c,#b7,#28,#03,#2d
db #06,#0c,#cd
lab5000 db #52
db #45,#d1,#e1,#18,#af,#4e,#1a,#f6 ;E....N..
db #82,#12,#eb,#2c,#36,#10,#2c,#1c
db #1a,#d6,#04,#77,#2c,#36,#02,#2c ;...w....
db #eb,#d6,#02,#30,#06,#2c,#36,#00
db #c3,#6b,#4e,#c6,#01,#47,#23,#7e ;.kN..G..
db #3c,#28,#f5,#36,#ff,#e5,#d5,#60
db #69,#01,#0a,#08,#cd,#52,#45,#28 ;i....RE.
db #08,#7d,#36,#00,#d6,#09,#6f,#36 ;......o.
db #05,#d1,#e1
lab5044 db #18
db #db,#03,#0a,#d9,#47,#d9,#4e,#3e ;....G.N.
db #0c,#06,#09,#cd,#d7,#4e,#d6,#0e ;.....N..
db #30,#06,#2c,#36,#00,#c3,#6b,#4e ;......kN
db #3d,#47,#2c,#7e,#3c,#28,#f6,#36 ;.G......
db #ff,#d9,#04,#d9,#20,#0a,#fd,#34
db #61,#fd,#cb,#61,#46,#28,#e6,#04 ;a..aF...
db #e5,#d5,#60,#69,#01,#06,#08,#cd ;...i....
db #52,#45,#28,#06,#7d,#d6,#09,#6f ;RE.....o
db #36,#08,#d1,#e1,#18,#cf,#7e,#fe
db #0b,#20,#ca,#06,#24,#af,#12,#3e
db #38,#cd,#d7,#4e,#2d,#3e,#4a,#12 ;...N..J.
db #3e,#38,#cd,#d7,#4e,#fd,#cb,#15 ;....N...
db #66,#c2,#6b,#4e,#d6,#0c,#47,#0e ;f.kN..G.
db #33,#c6,#18,#18,#3a,#1a,#4f,#3e ;......O.
db #06,#06,#26,#cd,#d7,#4e,#2d,#79 ;.....N.y
db #c6,#1a,#12,#06,#26,#3e,#06,#cd
db #d7,#4e,#eb,#36,#82,#2c,#71,#2c ;.N....q.
lab50CD db #1a
db #d6,#05,#47,#70,#2c,#36,#1d,#2c ;..Gp....
db #79,#c6 ;y.
lab50D8 db #20
db #f6,#82,#77,#2c,#ed,#44,#c6,#80 ;..w..D..
db #77,#2c,#70,#2c,#36,#1d,#2c,#36 ;w.p.....
db #80,#eb,#78,#2c,#fe,#4b,#d2,#6b ;..x..K.k
db #4e,#fe,#15,#30,#08,#36,#01,#2c ;N.......
db #36,#00,#c3,#6b,#4e,#35,#c2,#6b ;...kN..k
db #4e,#36,#0c,#cd,#43,#3d,#e6,#07 ;N...C...
db #80,#d6,#30,#08,#2c,#7e,#c6,#10
db #77,#3a,#65,#ef,#c6,#05,#07,#07 ;w.e.....
db #07,#be,#da,#6b,#4e,#7e,#e6,#30 ;...kN...
db #ee,#30,#e5,#d5,#1e,#00,#79,#01 ;......y.
db #07,#0c,#20,#03,#0c,#1e,#12,#2e
db #1f,#c6,#0d,#08,#67,#30,#07,#08 ;....g...
db #cb,#77,#20,#0d,#18,#05,#08,#cb ;.w......
db #77,#28,#06,#ed,#44,#c6,#80,#18 ;w...D...
db #04,#06,#04,#2e,#fe,#93,#f5,#cd
db #52,#45,#d1,#cd,#43,#3d,#e6,#07 ;RE..C...
db #82,#dd,#77,#11,#d1,#e1,#18,#24 ;..w.....
db #eb,#7e,#4f,#fe,#40,#38,#02,#d6 ;..O.....
db #04,#f6,#84,#77,#2c,#36,#1c,#2c ;...w....
db #1c,#1a,#47,#77,#2c,#36,#0e,#2c ;..Gw....
db #eb,#2c,#fe,#70,#30,#06,#fe,#14 ;...p....
db #30,#2a,#36,#1c,#c5,#d9,#d1,#7a ;.......z
db #d6,#08,#57,#7b,#c6,#0d,#5f,#21 ;..W.....
db #f4,#59,#06,#10,#cd,#7f,#48,#d9 ;.Y....H.
db #ca,#6b,#4e,#2d,#2d,#cb,#fe,#e5 ;.kN.....
db #d5,#01,#04,#03,#cd,#15,#01,#d1
db #e1,#c3,#6b,#4e,#08,#7e,#fe,#19 ;..kN....
db #38,#02,#36,#17,#08,#35,#20,#cc
db #36,#17,#d6,#10,#d5,#e5,#c5,#57 ;.......W
db #fe,#48,#1e,#03,#38,#02,#1e,#08 ;.H......
db #3a,#cd,#e6,#bb,#38,#2c,#83,#fe
db #1e,#30,#27,#79,#cb,#77,#20,#02 ;...y.w..
db #c6,#0a,#c6,#04,#5f,#0e,#80,#cd
db #de,#52,#28,#16,#dd,#cb,#00,#ce ;.R......
db #dd,#36,#07,#a8,#3a,#65,#ef,#06 ;.....e..
db #05,#fe,#04,#38,#02,#06,#07,#dd
db #70,#06 ;p.
lab51FB db #c1
db #e1,#d1,#18
lab51FF db #85
db #eb,#01,#0c,#18,#36,#84,#2c,#70 ;.......p
db #2c,#1c,#1a,#c6,#01,#77,#2c,#71 ;.....w.q
db #2c,#36,#00,#2c,#36,#0f,#2c,#c6
db #01,#77,#2c,#36,#20,#2c,#eb,#2c ;.w......
db #0e,#81,#d6,#16,#da,#5b,#4f,#c3 ;......O.
db #60,#4f,#c3,#85,#51,#eb,#7e,#36 ;.O..Q...
db #81,#2c,#77,#1c,#2c,#1a,#77,#2c ;..w...w.
db #1d,#73,#2c,#eb,#c3,#6b,#4e,#eb ;.s...kN.
db #46,#36,#81,#2c,#70,#1c,#2c,#1a ;F...p...
db #4f,#77,#2c,#1d,#73,#2c,#36,#81 ;Ow..s...
db #2c,#78,#c6,#08,#77,#2c,#79,#d6 ;.x..w.y.
db #08,#30,#02,#3e,#04,#77,#2c,#73 ;.....w.s
db #2c,#eb,#c3,#6b,#4e,#4e,#2c,#7e ;...kNN..
db #2c,#fe,#06,#28,#06,#30,#f3,#36
db #00,#18,#ef,#7e,#3c,#28,#eb,#36
db #ff,#d5,#e5,#26,#fd,#69,#01,#0d ;.....i..
db #08,#3e,#80,#12,#cd,#52,#45,#28 ;.....RE.
db #0c,#dd,#36,#06,#00,#dd,#36,#0f
db #14,#dd,#36,#11,#01,#e1,#d1,#18
db #c9,#dd,#36,#11,#01,#dd,#7e,#04
db #87,#87,#5f,#dd,#7e,#05,#57,#fe ;......W.
db #34,#38,#07,#17,#38,#04,#dd,#36
db #12,#01,#57,#dd,#35,#0f,#c2,#bb ;..W.....
db #4a,#3a,#65,#ef,#06,#14,#fe,#04 ;J.e.....
db #38,#02,#06,#0f,#dd,#70,#0f,#7b ;.....p..
db #fe,#40,#30,#02,#c6,#08,#d6,#04
db #5f,#14,#0e,#80,#dd,#e5,#cd,#de
db #52,#dd,#e1,#c3,#bb,#4a ;R....J
lab52DE ld a,e
    cp #78
    jr nc,lab52FE
    ld a,d
    cp #60
    jr nc,lab52FE
    cp #4
    jr c,lab52FE
    ld a,(labE6CE)
    add a,#5
    ld b,a
    ld a,(labEF63)
    add a,#3
    or c
    ld c,a
    ex de,hl
    xor a
    jp lab530F
lab52FE xor a
    ret 
lab5300 jp lab55ED
lab5303 jp lab547C
lab5306 jp lab57FF
lab5309 jp lab536E
lab530C jp lab534A
lab530F jp lab55E0
lab5312 jp lab5468
data5315 db #c3
db #79,#56,#c3,#94,#56 ;yV..V
lab531B jp lab55DA
lab531E jp lab544A
lab5321 jp lab5833
lab5324 ld hl,lab5833
    call lab5337
    call lab5337
    call lab5337
    call lab533B
    ld b,#14
    jr lab533D
lab5337 ld b,#e
    jr lab533D
lab533B ld b,#5
lab533D push bc
lab533E ld (hl),#0
    inc hl
    djnz lab533E
    pop bc
    ld a,(hl)
    inc a
    jr nz,lab533D
    inc hl
    ret 
lab534A ld ix,lab5924
    ld de,lab0005
lab5351 ld a,(ix+0)
    inc a
    ret z
    dec a
    jr z,lab535D
    add ix,de
    jr lab5351
lab535D ld (ix+1),l
    ld (ix+2),h
    ld (ix+3),c
    ld (ix+4),b
    ld (ix+0),#e
    ret 
lab536E ld ix,lab5924
    ld hl,lab5A00
    ld (hl),#90
    ld (labEF3D),hl
lab537A ld a,(ix+0)
    inc a
    ret z
    dec a
    jr nz,lab5389
lab5382 ld de,lab0005
    add ix,de
    jr lab537A
lab5389 ld l,(ix+1)
    ld h,(ix+2)
    call lab56AF
    ld a,(ix+3)
    add a,l
    ld (ix+1),a
    ld l,a
    rla 
    jp c,lab5438
    ld a,(ix+4)
    add a,h
    bit 5,(iy+21)
    jr z,lab53A9
    inc a
lab53A9 ld (ix+2),a
    ld h,a
    cp #60
    jp nc,lab5438
    cp #5
    jp c,lab5438
    dec (ix+0)
    jp z,lab5443
    ex de,hl
    ld hl,(labEF3D)
    ld (hl),d
    inc l
    ld (hl),e
    inc l
    ld (hl),#90
    ld (labEF3D),hl
    ld a,(labEF5A)
    ld b,a
    bit 7,a
    jr z,lab542A
    ld a,(labEF54)
    sub d
    jr nc,lab542A
    add a,#a
    jr nc,lab542A
    ld a,(labEF53)
    ld c,a
    add a,a
    add a,a
    add a,(iy+85)
    sub e
    jr nc,lab542A
    add a,#7
    jr nc,lab53F7
    bit 4,b
    jr nz,lab542A
    set 4,(iy+90)
    ld l,c
    jr lab540B
lab53F7 add a,#b
    jr c,lab542A
    add a,#7
    jr nc,lab542A
    bit 1,b
    jr nz,lab542A
    set 1,(iy+90)
    ld a,c
    add a,#4
    ld l,a
lab540B ld h,(iy+84)
    push de
    ld bc,lab1302
    push ix
    call lab420F
    jr z,lab5421
    ld (ix+17),#12
    ld (ix+6),#0
lab5421 ld bc,lab0104
    call lab0115
    pop ix
    pop de
lab542A ex de,hl
    inc l
    call lab3D46
    dec l
    jr c,lab543F
    call lab56B6
    jp lab5382
lab5438 ld (ix+0),#0
    jp lab5382
lab543F ld (ix+0),#0
lab5443 ex de,hl
    call lab57B1
    jp lab5382
lab544A ld a,h
    ld l,#0
    add a,#2
    ld c,a
    ld h,a
    jp p,lab5458
    dec l
    scf
    jr lab5459
lab5458 xor a
lab5459 rr h
    rr l
    rr h
    rr l
    rr h
    rr l
    add hl,de
    ld a,h
    ret 
lab5468 call lab5476
    ld ix,lab5915
    ld a,#90
    ld (lab59F4),a
    jr lab5480
lab5476 ld ix,lab58C0
    jr lab5480
lab547C ld ix,lab5833
lab5480 ld c,(ix+0)
    inc c
    ret z
    dec c
    jp z,lab55D2
    ld d,(ix+3)
    ld e,(ix+2)
    push de
    srl d
    srl e
    bit 3,(ix+0)
    jr z,lab549F
    call lab5779
    jr lab54A2
lab549F call lab5694
lab54A2 ld a,(ix+0)
    bit 3,a
    jr z,lab54CA
    and #3
    jp nz,lab54CA
    ld d,(ix+10)
    ld e,(ix+9)
    ld h,(ix+8)
    call lab544A
    rla 
    jr c,lab54C1
    pop de
    jp lab557D
lab54C1 ld (ix+10),h
    ld (ix+9),l
    ld (ix+8),c
lab54CA ld a,(ix+1)
    ld b,(ix+6)
    ld c,(ix+0)
    ld e,(ix+4)
    ld d,(ix+5)
    ld hl,data0000
    bit 5,c
    res 5,c
    jr nz,lab54E5
lab54E2 sub d
    jr nc,lab54EF
lab54E5 inc h
    add a,e
    jr c,lab54EF
    djnz lab54E5
    set 5,c
    jr lab54F2
lab54EF inc l
    djnz lab54E2
lab54F2 ld (ix+1),a
    ld (ix+0),c
    pop de
    ld a,h
    rl c
    jr c,lab5500
    neg
lab5500 add a,d
    bit 5,(iy+21)
    jr z,lab5509
    inc a
    inc a
lab5509 cp #c0
    jr c,lab5518
lab550D ld a,(ix+0)
    and #c
    jp z,lab55CE
    jp lab557D
lab5518 cp #9
    jp c,lab550D
    ld (ix+3),a
    ld d,a
    ld a,l
    rl c
    jr c,lab552C
    ld a,e
    sub l
    jr c,lab550D
    jr lab552F
lab552C add a,e
    jr c,lab550D
lab552F ld e,a
    ld (ix+2),a
    jr c,lab550D
    srl d
    srl e
    push de
    bit 3,(ix+0)
    jr z,lab554F
    ld h,#1
    call lab56CD
    pop de
    ld a,(ix+0)
    and #3
    jr nz,lab5553
    jr lab556C
lab554F call lab5679
    pop de
lab5553 ld a,(labEF63)
    inc a
    sub e
    jr nc,lab556C
    add a,#6
    jr nc,lab556C
    ld a,(labEF64)
    sub d
    jr nc,lab556C
    add a,#6
    jr nc,lab556C
    set 0,(iy+98)
lab556C ld a,(ix+7)
    sub (ix+6)
    ld (ix+7),a
    jr nc,lab55D2
    ld d,(ix+3)
    ld e,(ix+2)
lab557D srl d
    srl e
    ld a,(ix+0)
    and #c
    jr z,lab55CB
    ld hl,lab59F4
    ld a,d
    add a,#f
    ld (hl),a
    inc l
    ld a,e
    add a,#f
    ld (hl),a
    ld a,(labEF64)
    sub #6
    sub d
    jr nc,lab55B6
    add a,#14
    jr nc,lab55B6
    ld a,(labEF63)
    sub e
    jp c,lab55AD
    sub #6
    jr nc,lab55B6
    jr lab55B2
lab55AD add a,#7
    jp nc,lab55B6
lab55B2 set 0,(iy+98)
lab55B6 ld h,#0
    call lab56CD
    ld a,(lab59CA)
    ld l,a
    ld a,(lab59CB)
    ld h,a
    ld a,(lab59CC)
    call lab012A
    jr lab55CE
lab55CB call lab57B1
lab55CE xor a
    ld (ix+0),a
lab55D2 ld de,lab000E
    add ix,de
    jp lab5480
lab55DA ld ix,lab5915
    jr lab55E4
lab55E0 ld ix,lab58C0
lab55E4 set 7,b
    add a,a
    jr nc,lab55EB
    or #80
lab55EB jr lab55F1
lab55ED ld ix,lab5833
lab55F1 sla h
    sla l
    ex af,af''
lab55F6 ld de,lab000E
lab55F9 ld a,(ix+0)
    inc a
    ret z
    dec a
    jr z,lab5605
    add ix,de
    jr lab55F9
lab5605 ld a,b
    rla 
    ld b,#90
    jr nc,lab560D
    set 3,b
lab560D sub h
    jr nc,lab5614
    res 7,b
    neg
lab5614 ld d,a
    sla c
    ld a,c
    jr nc,lab561C
    set 2,b
lab561C sub l
    jr nc,lab5623
    neg
    jr lab5625
lab5623 set 6,b
lab5625 ld e,a
    cp d
    jr c,lab562C
    ld c,e
    jr lab562D
lab562C ld c,d
lab562D ld (ix+0),b
    ld a,e
    srl a
    ld (ix+1),a
    ld (ix+2),l
    ld (ix+3),h
    ld (ix+4),e
    ld (ix+5),d
    ex af,af''
    bit 7,a
    res 7,a
    ld (ix+6),a
    jr z,lab564E
    ld c,#60
lab564E ld (ix+7),c
    bit 3,b
    jr z,lab5677
    ld d,#0
    ld (ix+9),d
    ld (ix+10),d
    ld a,c
    and #e0
    bit 4,c
    jr z,lab5666
    add a,#20
lab5666 ld (ix+7),a
    rra 
    rra 
    rra 
    rra 
    or a
    ret z
    rra 
    ld (ix+6),a
    ld (ix+8),#e0
lab5677 or a
    ret 
lab5679 call lab56BD
    ret nc
    ex de,hl
    ld a,l
    push af
    call lab3489
    pop af
    and #1
    ld a,#80
    jr z,lab568B
    rrca 
lab568B ld d,a
    or (hl)
    ld (hl),a
    set 3,h
    ld a,d
    or (hl)
    ld (hl),a
    ret 
lab5694 call lab56BD
    ret nc
    ex de,hl
    ld a,l
    push af
    call lab3489
    pop af
    and #1
    ld a,#7f
    jr z,lab56A6
    rrca 
lab56A6 ld d,a
    and (hl)
    ld (hl),a
    ld a,d
    set 3,h
    and (hl)
    ld (hl),a
    ret 
lab56AF push hl
    ex de,hl
    call lab5694
    pop hl
    ret 
lab56B6 push hl
    ex de,hl
    call lab5679
    pop hl
    ret 
lab56BD ld a,(labEF17)
    sub #d
    ret c
    sub d
    ret c
    sub #1f
    jr nc,lab56CB
    xor a
    ret 
lab56CB scf
    ret 
lab56CD ex de,hl
    ld a,(ix+10)
    ld b,a
    add a,h
    ld c,a
    push ix
    ld a,(ix+0)
    and #1
    add a,a
    add a,a
    or #20
    ld (lab59D1),a
    ld a,l
    and #2
    ld (lab59CC),a
    ld a,l
    and #fc
    rra 
    rra 
    ld (lab59CA),a
    inc d
    dec d
    ld a,b
    ld b,#0
    jr z,lab5712
    bit 0,(ix+0)
    jr z,lab5704
    ld a,(ix+12)
    add a,#22
    jr lab5713
lab5704 neg
    ld b,#22
    cp #10
    jr c,lab5712
    inc b
    cp #1a
    jr c,lab5712
    inc b
lab5712 ld a,b
lab5713 ld (lab59CD),a
    ld ix,lab59C6
    ld (ix+8),#4
    ld (ix+9),#5f
    ld (ix+10),#5
    ld a,c
    sub (ix+1)
    jp p,lab5750
    neg
lab572F sub #5
    jr c,lab5770
    push af
    ld a,(lab59C7)
    sub #4
    ld (lab59CB),a
    call lab3480
    pop af
    inc a
    ld b,a
    ld a,(lab59CB)
    sub b
    ld c,a
    ld a,b
    cp #5
    jr c,lab572F
    ld a,#5
    jr lab572F
lab5750 sub #5
    jr c,lab5770
    push af
    ld a,(lab59C7)
    add a,#4
    ld (lab59CB),a
    call lab3480
    pop af
    inc a
    ld b,a
    add a,(ix+5)
    ld c,a
    ld a,b
    cp #5
    jr c,lab5750
    ld a,#5
    jr lab5750
lab5770 ld (ix+5),c
    call lab3480
    pop ix
    ret 
lab5779 ex de,hl
    ld a,(ix+10)
    ld c,a
    add a,h
    ld (lab59C7),a
    ld a,l
    and #2
    ld (lab59C8),a
    ld a,l
    and #fc
    rra 
    rra 
    ld (lab59C6),a
    bit 0,(ix+0)
    jr z,lab579D
    ld a,(ix+12)
    add a,#22
    jr lab57AD
lab579D ld a,c
    neg
    ld c,#22
    cp #10
    jr c,lab57AC
    inc c
    cp #1a
    jr c,lab57AC
    inc c
lab57AC ld a,c
lab57AD ld (lab59C9),a
    ret 
lab57B1 ld hl,lab594D
lab57B4 ld a,(hl)
    inc a
    jr z,lab57FC
    ld bc,lab0011
    add hl,bc
    ld a,(hl)
    or a
    jr z,lab57C6
    ld bc,lab0003
    add hl,bc
    jr lab57B4
lab57C6 push de
    ld (hl),#7
    xor a
    sbc hl,bc
    ld a,e
    sub #3
    ld e,a
    and #2
    add a,a
    ld b,a
    ld a,e
    and #fc
    rra 
    rra 
    ld e,a
    ld (hl),e
    inc hl
    ld a,d
    sub #2
    ld (hl),a
    inc hl
    ld (hl),#0
    inc hl
    ld (hl),#21
    inc hl
    ld (hl),e
    inc hl
    ld (hl),a
    inc hl
    ld (hl),#0
    inc hl
    ld (hl),#21
    inc hl
    inc hl
    inc hl
    ld (hl),#5
    inc hl
    ld a,(hl)
    and #fb
    or b
    ld (hl),a
    pop de
lab57FC jp lab5694
lab57FF ld ix,lab594D
lab5803 ld a,(ix+0)
    inc a
    ret z
    ld a,(ix+17)
    or a
    jr nz,lab5815
lab580E ld de,lab0014
    add ix,de
    jr lab5803
lab5815 dec a
    ld (ix+17),a
    jr nz,lab5821
    ld (ix+7),#0
    jr lab582B
lab5821 dec a
    srl a
    jr c,lab580E
    and #1
    xor #1
    add a,a
lab582B ld (ix+6),a
    call lab3D4F
    jr lab580E
lab5833 ret 
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
    nop
    nop
    nop
lab588C nop
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
    rst 56
lab58C0 nop
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
    rst 56
lab5915 nop
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
    rst 56
lab5924 nop
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
    nop
    nop
    nop
    nop
    nop
    rst 56
lab594D nop
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
    rst 56
lab59C6 nop
lab59C7 nop
lab59C8 nop
lab59C9 nop
lab59CA nop
lab59CB nop
lab59CC nop
lab59CD nop
    inc b
    ld e,a
    inc d
lab59D1 jr nz,lab59D3
lab59D3 nop
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
lab59F4 nop
    nop
    sub b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab5A00 sub b
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
    sub b
    sub b
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
lab5A73 nop
lab5A74 nop
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
    nop
    nop
    nop
    nop
    in a,(#88)
    nop
    nop
lab5C04 ld hl,lab0352
    ld de,lab0040
    ld bc,lab3ED0
    ldir
    ex de,hl
    dec hl
    ld de,lab5A73
    call lab5CC9
    ld sp,lab5C04
    ld hl,lab88C0
    ld de,labC000
    ld bc,lab0400
    ldir
    ld hl,labC900
    ld de,lab89FC
    ld bc,lab3604
    ldir
    ld hl,labC000
    ld de,labC600
    ld b,#2
    ldir
    ld de,labCE00
    ld b,#2
    ldir
    ld hl,lab8678
    ld d,#d6
    ld bc,lab01E2+2
    ldir
    ld de,labDE00
    inc b
    ldir
    ld hl,lab8BFB
    ld de,lab88DD
lab5C57 ld a,(hl)
    and #55
    add a,a
    or c
    ld (de),a
    ld a,(hl)
    and #aa
    rrca 
    ld c,a
    dec hl
    dec de
    ld a,e
    cp #dd
    jr nz,lab5C57
    ld a,d
    cp #86
    jr nz,lab5C57
    ld hl,lab8D18
    ld de,lab89FB
    ld c,#0
lab5C76 ld a,(hl)
    and #55
    add a,a
    or c
    ld (de),a
    ld a,(hl)
    and #aa
    rrca 
    ld c,a
    dec hl
    dec de
    ld a,e
    cp #db
    jr nz,lab5C76
    ld a,d
    cp #88
    jr nz,lab5C76
    push bc
    push de
    ld d,#0
    ld e,#8
    ld hl,labC000
lab5C96 ld bc,lab0006
lab5C99 ld (hl),d
    inc l
    djnz lab5C99
    inc h
    dec c
    jr nz,lab5C99
    inc h
    inc h
    dec e
    jr nz,lab5C96
    xor a
    ld hl,lab5D4A
lab5CAA ld (hl),a
    inc l
    jr nz,lab5CAA
    inc h
lab5CAF ld (hl),a
    inc l
    jr nz,lab5CAF
    ld hl,lab0040
lab5CB6 ld (hl),a
    inc l
    jr nz,lab5CB6
    ld hl,lab5A74
lab5CBD ld (hl),a
    inc l
    jr nz,lab5CBD
    inc h
lab5CC2 ld (hl),a
    inc l
    jr nz,lab5CC2
    jp lab011E
lab5CC9 ld a,(hl)
    dec hl
    ld b,a
    scf
    rra 
    ld i,a
lab5CD0 ld a,b
    rra 
    jr c,lab5CE1
    ldd
lab5CD6 ld a,i
    ld b,a
    rra 
    ld i,a
    and a
    jr nz,lab5CD0
    jr lab5CC9
lab5CE1 ld a,(hl)
    dec hl
    and a
    ret z
    bit 7,a
    jr z,lab5D00
    ld b,a
    rrca 
    rrca 
    rrca 
    rrca 
    and #7
    add a,#3
    ld c,a
    ld a,b
    and #f
    ld b,a
    ld a,(hl)
    dec hl
    push hl
    ld l,a
    ld h,b
    ld b,#0
    jr lab5D20
lab5D00 ld bc,lab0002
    bit 6,a
    jr z,lab5D0B
    and #3f
    jr lab5D15
lab5D0B bit 5,a
    jr z,lab5D27
    and #1f
    add a,c
    ld c,a
    ld a,(hl)
    dec hl
lab5D15 push hl
    ld l,a
    ld h,b
    jr lab5D20
lab5D1A xor a
    ld c,a
    inc b
lab5D1D ld h,b
    ld l,c
    dec hl
lab5D20 inc hl
    add hl,de
    lddr
    pop hl
    jr lab5CD6
lab5D27 bit 4,a
    jr z,lab5D39
    and #f
    ld b,(hl)
    dec hl
    ld c,(hl)
    dec hl
    push hl
    ld h,a
    ld l,b
    ld b,#0
    inc bc
    jr lab5D20
lab5D39 cp #f
    jr nz,lab5D43
    ld c,(hl)
    dec hl
    push hl
    inc bc
    jr lab5D1D
lab5D43 push hl
    cp c
    jr c,lab5D1A
    ld c,a
    jr lab5D1D
lab5D4A nop
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
lab5F00 nop
    ld (lab0C88),hl
    nop
    nop
    nop
    nop
    inc c
    ld d,ixl
    nop
    nop
    cp e
    xor d
    inc c
    nop
    nop
    nop
    nop
    inc c
    ld d,l
    ld d,l
    nop
    nop
    xor d
    xor d
    inc c
    nop
    nop
    nop
    nop
    inc c
    ld b,h
    ld de,lab1100
    ld b,h
    ld de,lab000C
    nop
    nop
    nop
    call z,labBBFC
    ld (lab7711),hl
    ret p
    call z,data0000
    nop
    nop
    call z,labBBF3
    nop
    nop
    ld (hl),h
    call m,lab00CC
    nop
    nop
    nop
    nop
    jp po,lab00F0
    nop
    call m,lab0055
    nop
    nop
    nop
    nop
    nop
    xor d
    xor d
    nop
    nop
    ld d,ixl
    nop
    nop
    nop
    nop
    nop
    nop
    inc h
    xor d
    nop
    nop
    dec h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,d
    nop
    nop
    jr nz,lab5F6F
lab5F6F nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    ld (data0000),hl
    ld d,l
db #dd,#0c
    nop
    nop
    nop
    nop
    inc c
    xor d
    cp e
    nop
    nop
    ld d,l
    ld d,l
    inc c
    nop
    nop
    nop
    nop
    inc c
    xor d
    xor d
    nop
    nop
    ld de,lab0C44
    nop
    nop
    nop
    nop
    inc c
    nop
    ld b,h
    ld de,labBB22
    cp b
    adc a,b
    nop
    nop
    nop
    nop
    ld b,h
    ret p
    ld (hl),a
    ld de,labBB22
    di
    adc a,b
    nop
    nop
    nop
    nop
    nop
    call m,lab1174
    nop
    ret p
    jp po,data0000
    nop
    nop
    nop
    nop
db #dd,#aa
    nop
    nop
    ld d,l
    xor d
    nop
    nop
    nop
    nop
    nop
    nop
db #dd,#aa
    nop
    nop
    inc h
    and h
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,d
    nop
    nop
    nop
    nop
    inc b
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
lab6000 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    and d
    ld d,c
    nop
    nop
    di
    ei
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    di
    rst 48
    nop
    nop
    di
    di
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    di
    di
    nop
    nop
    pop de
    jp po,lab0080
    nop
    nop
    nop
    add a,b
    push de
    jp pe,lab554F+2
    rst 48
    cp e
    xor d
    nop
    nop
    nop
    nop
    xor d
    inc sp
    ei
    ld d,c
    nop
    rst 48
    ld (hl),a
    xor d
    nop
    nop
    nop
    nop
    xor d
    cp e
    cp e
    nop
    nop
    inc sp
    ld (hl),a
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    cp e
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 56
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    add a,b
    and d
    ld d,c
    nop
    nop
    nop
    nop
    di
    ei
    add a,b
    nop
    nop
    add a,b
    di
    rst 48
    nop
    nop
    nop
    nop
    di
    di
    add a,b
    nop
    nop
    add a,b
    di
    di
    nop
    nop
    nop
    nop
    pop de
    jp po,lab0080
    nop
    add a,b
    push de
    jp pe,lab0051
    nop
    ld d,l
    rst 48
    cp e
    xor d
    nop
    nop
    xor d
    inc sp
    ei
    ld d,c
    nop
    nop
    nop
    rst 48
    ld (hl),a
    xor d
    nop
    nop
    xor d
    cp e
    cp e
    nop
    nop
    nop
    nop
    inc sp
    ld (hl),a
    nop
    nop
    nop
    nop
    ei
    cp e
    nop
    nop
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    di
    rst 56
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,c
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    rst 48
    di
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    di
    di
    nop
    nop
    di
    di
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    jp po,lab00D1
    ld d,c
    jp pe,lab80D5
    nop
    nop
    nop
    nop
    xor d
    cp e
    rst 48
    ld d,l
    ld d,c
    ei
    inc sp
    xor d
    nop
    nop
    nop
    nop
    xor d
    ld (hl),a
    rst 48
    ld d,l
    ld d,c
    cp e
    cp e
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    inc sp
    nop
    nop
    rst 48
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    di
    nop
    nop
    di
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    rst 48
    di
    add a,b
    nop
    nop
    add a,b
    di
    di
    nop
    nop
    nop
    nop
    di
    di
    add a,b
    nop
    nop
    add a,b
    jp po,lab00D1
    nop
    nop
    ld d,c
    jp pe,lab80D5
    nop
    nop
    xor d
    cp e
    rst 48
    ld d,l
    nop
    nop
    ld d,c
    ei
    inc sp
    xor d
    nop
    nop
    xor d
    ld (hl),a
    rst 48
    ld d,l
    nop
    nop
    ld d,c
    cp e
    cp e
    nop
    nop
    nop
    nop
    ld (hl),a
    inc sp
    nop
    nop
    nop
    nop
    rst 48
    rst 56
    nop
    nop
    nop
    nop
    rst 56
    di
    nop
    nop
    nop
    nop
    di
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    and d
    ld d,c
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    di
    and a
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    di
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    add a,b
    ld (lab00FB),hl
    ld d,l
    or e
    ld (lab0080),hl
    nop
    nop
    nop
    xor d
    rst 56
    inc sp
    ld d,c
    ld d,l
    ld (hl),a
    rst 40
    nop
    nop
    nop
    nop
    nop
    nop
    rst 8
    rst 56
    ld de,labFF55
    adc a,d
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    ei
    ld d,c
    nop
    rst 56
    rst 48
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    di
    nop
    ld d,c
    di
lab6262 ret nz
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ld b,b
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    and d
    ld d,c
    nop
    nop
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    di
    and a
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    di
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    add a,b
    ld (lab00FB),hl
    nop
    nop
    ld d,l
    or e
    ld (lab0080),hl
    nop
    xor d
    rst 56
    inc sp
    ld d,c
    nop
    nop
    ld d,l
    ld (hl),a
    rst 40
    nop
    nop
    nop
    nop
    rst 8
    rst 56
    ld de,data0000
    ld d,l
    rst 56
    adc a,d
    nop
    nop
    nop
    nop
    xor d
    ei
    ld d,c
    nop
    nop
    nop
    rst 56
    rst 48
    nop
    nop
    nop
    nop
    ret nz
    di
    nop
    nop
    nop
    ld d,c
    di
    ret nz
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    and d
    ld d,c
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    di
    and a
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    di
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    add a,b
    ld (lab00FB),hl
    ld d,l
    or e
    ld (lab0080),hl
    nop
    nop
    nop
    nop
    rst 56
    inc sp
    ld d,c
    ld d,l
    ld (hl),a
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 24
    rst 56
    ld de,labEF51
    rst 24
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    rst 48
    nop
    nop
    ld d,c
    xor d
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    and d
    ld d,c
    nop
    nop
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    di
    and a
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    di
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    add a,b
    ld (lab00FB),hl
    nop
    nop
    ld d,l
    or e
    ld (lab0080),hl
    nop
    nop
    rst 56
    inc sp
    ld d,c
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    nop
    nop
    nop
    nop
    rst 24
    rst 56
    ld de,data0000
    ld d,c
    rst 40
    rst 24
    nop
    nop
    nop
    nop
    xor d
    rst 48
    nop
    nop
    nop
    nop
    ld d,c
    xor d
    nop
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    di
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    and d
    rst 48
    ld d,c
    ld d,c
    ei
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    ld a,(bc)
    di
    ld d,c
    ld d,c
    and a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    ld de,labAA77
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    or e
    ld d,l
    ei
    cp e
    rst 56
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ret nz
    jp po,labC0FB
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld (lab55B2+1),hl
    ld de,labFF33
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    rst 56
    ld d,c
    nop
    rst 48
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    and d
    rst 56
    nop
    nop
    ret nz
lab6462 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    and a
    di
    nop
    nop
    nop
    nop
    di
    ld a,(bc)
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    nop
    nop
    nop
    ld d,l
    ld (hl),a
    xor d
    nop
    nop
    nop
    nop
    rst 56
    inc sp
    ld d,c
    nop
    nop
    rst 48
    or e
    rst 56
    nop
    nop
    nop
    ret nz
    ret nz
    ret nz
    ei
    nop
    nop
    rst 48
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ld (lab51FF),hl
    nop
    nop
    ld de,labFF33
    nop
    nop
    nop
    xor d
    rst 56
    rst 48
    nop
    nop
    nop
    nop
    di
    rst 56
    xor d
    nop
    nop
    add a,b
    ld b,b
    di
    nop
    nop
    nop
    ld b,b
    add a,b
    ret nz
    nop
    nop
    nop
    add a,b
    ret nz
    nop
    ret nz
    nop
    nop
    ret nz
    add a,b
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    di
    di
    ld d,c
    nop
    nop
    ld d,c
    and a
    rrca 
    nop
    nop
    nop
    nop
    ld a,(bc)
    ret nz
    ld d,l
    nop
    nop
    ld d,l
    rst 56
    xor d
    nop
    nop
    nop
    nop
    nop
    push de
    or e
    nop
    ld d,c
    ei
    ret nz
    nop
    nop
    nop
    nop
    nop
    add a,b
    jp z,lab55F6+1
    ld d,c
    ld (hl),e
    rst 40
    ret nz
    nop
    nop
    nop
    nop
    ld b,b
    rst 56
    or e
    ld d,l
    nop
    rst 56
    ld (data0000),hl
    nop
    nop
    nop
    nop
    xor d
    rst 48
    nop
    nop
    rst 56
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    rst 48
    push de
    nop
    nop
    ret nz
    jp pe,data0000
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    ld d,c
    and d
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    nop
    nop
    di
lab6590 ei
    nop
    nop
    di
    di
    ld d,c
    nop
    nop
lab6598 nop
    nop
lab659A ld d,c
    and a
    rrca 
    nop
    nop
    ld a,(bc)
    ret nz
    ld d,l
    nop
    nop
    nop
    nop
    ld d,l
    rst 56
    xor d
    nop
    nop
    nop
    rst 56
    or e
    nop
    nop
    nop
    ld d,c
    ei
    ret nz
    nop
    nop
    nop
    add a,b
    jp z,lab55F6+1
    nop
    nop
    ld d,c
    ld (hl),e
    rst 40
    ret nz
    nop
    nop
    ld b,b
    rst 56
    or e
    ld d,l
    nop
    nop
    nop
    rst 56
lab65CB ld (data0000),hl
    nop
lab65CF nop
    xor d
    rst 48
    nop
    nop
    nop
    nop
    rst 56
    and d
    nop
    nop
    nop
    nop
    rst 48
    push de
    nop
    nop
    nop
lab65E1 nop
    ret nz
lab65E3 jp pe,data0000
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    add a,b
    ld b,b
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
    di
    nop
    nop
    nop
    nop
    nop
    and d
    ei
    ld d,c
    nop
    nop
    ld d,c
    rst 48
    and d
    nop
    nop
    nop
    nop
    and d
    di
    di
    nop
    nop
    di
    rrca 
    ld a,(bc)
    nop
    nop
    nop
    nop
    nop
    add a,l
    jp pe,data0000
    rst 48
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    ei
    nop
    ld d,l
    or e
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    jp z,lab51FB
    ld d,l
    rst 48
    rst 40
    add a,b
    nop
    nop
    nop
    nop
    ret nz
    xor d
    ld (hl),a
    ld d,c
    nop
    cp e
    ld (hl),a
    ld b,b
    nop
    nop
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    ld d,l
    xor d
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
lab6666 nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    di
    nop
    nop
    nop
    and d
    ei
    ld d,c
    nop
    nop
    nop
    nop
    ld d,c
    rst 48
    and d
    nop
    nop
    and d
    di
    di
    nop
    nop
    nop
    nop
    di
    rrca 
    ld a,(bc)
    nop
    nop
    nop
    add a,l
    jp pe,data0000
    nop
    nop
    rst 48
    rst 56
    nop
    nop
    nop
    nop
    xor d
    ei
    nop
    nop
    nop
    ld d,l
    or e
    rst 56
    nop
    nop
    nop
    nop
    jp z,lab51FB
    nop
    nop
    ld d,l
    rst 48
    rst 40
    add a,b
    nop
    nop
    ret nz
    xor d
    ld (hl),a
    ld d,c
    nop
    nop
    nop
    cp e
    ld (hl),a
    ld b,b
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    nop
    nop
    ld d,l
    xor d
    nop
    nop
    nop
    nop
    xor d
    ld d,c
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    nop
    nop
    and d
    ld d,c
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    di
    di
    nop
    nop
    nop
    nop
    nop
    nop
    ld e,e
    and a
    nop
    ld d,l
    ret nz
    ret nz
    xor d
    nop
    nop
    nop
    nop
    xor d
    rst 48
    ld (hl),a
    ld d,c
    ld d,l
    or e
    rst 56
    xor d
    nop
    nop
    nop
    nop
    xor d
    ld (hl),a
    rst 8
    ld d,c
    ld d,l
    jp po,lab00BB
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    ld h,d
    nop
    nop
    jp pe,lab00FF
    nop
    nop
    nop
    nop
    nop
    ei
    jp po,data0000
    rst 56
    di
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    rst 48
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    and d
    ld d,c
    nop
    nop
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    di
    di
    nop
    nop
    nop
    nop
    ld e,e
    and a
    nop
    nop
    nop
    ld d,l
    ret nz
    ret nz
    xor d
    nop
    nop
    xor d
    rst 48
    ld (hl),a
    ld d,c
    nop
    nop
    ld d,l
    or e
    rst 56
    xor d
    nop
    nop
    xor d
    ld (hl),a
    rst 8
    ld d,c
    nop
    nop
    ld d,l
    jp po,lab00BB
    nop
    nop
    nop
    ld (hl),a
    ld h,d
    nop
    nop
    nop
    nop
    jp pe,lab00FF
    nop
    nop
    nop
    ei
    jp po,data0000
    nop
    nop
    rst 56
    di
    nop
    nop
    nop
    nop
    ret nz
    rst 48
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
lab6800 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    and d
    ld d,c
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    di
    di
    nop
    nop
    nop
    nop
    nop
    nop
    ld e,e
    and a
    nop
    ld d,l
    ret nz
    ret nz
    xor d
    nop
    nop
    nop
    nop
    xor d
    rst 48
    ld (hl),a
    ld d,c
    ld d,l
    or e
    rst 56
    xor d
    nop
    nop
    nop
    nop
    xor d
    ld (hl),a
    rst 8
    ld d,c
    ld d,l
    jp po,lab00BB
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    ld h,d
    nop
    nop
    jp pe,lab00FF
    nop
    nop
    nop
    nop
    nop
    rst 56
    rst 48
    nop
    nop
    di
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    ret nz
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    and d
    ld d,c
    nop
    nop
    nop
    nop
    di
    ei
    nop
    nop
    nop
    nop
    di
    rst 48
lab6896 nop
    nop
    nop
    nop
    di
    di
    nop
    nop
    nop
    nop
    ld e,e
    and a
    nop
    nop
    nop
    ld d,l
    ret nz
    ret nz
    xor d
    nop
    nop
    xor d
    rst 48
    ld (hl),a
    ld d,c
    nop
    nop
    ld d,l
    or e
    rst 56
    xor d
    nop
    nop
    xor d
    ld (hl),a
    rst 8
    ld d,c
    nop
    nop
    ld d,l
    jp po,lab00BB
    nop
    nop
    nop
    ld (hl),a
    ld h,d
    nop
    nop
    nop
    nop
    jp pe,lab00FF
    nop
    nop
    nop
    rst 56
    rst 48
    nop
    nop
    nop
    nop
    di
    rst 56
    nop
    nop
    nop
    nop
    rst 56
    ret nz
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
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
lab6900 nop
    di
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    and d
    rst 48
    ld d,c
    ld d,c
    ei
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    di
    di
    ld d,c
    dec b
    rrca 
    di
    nop
    nop
    nop
    nop
    nop
    nop
    push de
    ld c,d
    nop
    nop
    rst 56
    ei
    nop
    nop
    nop
    nop
    nop
    and d
    rst 48
    ld d,l
    nop
    nop
    ld d,l
    ei
    ei
    nop
    nop
    nop
    nop
    rst 48
    rst 48
    push de
    nop
    ld b,b
    push de
    ei
    ld (hl),e
    nop
    nop
    nop
    nop
    rst 48
    cp e
    ld d,c
    ld b,b
    nop
    nop
    ld (hl),a
    xor d
    nop
    nop
    nop
    nop
    and d
    rst 56
    nop
    nop
    nop
    nop
    rst 48
    xor d
    nop
    nop
    nop
    nop
    add a,b
    rst 48
    ld d,c
    nop
    nop
    ld d,c
    jp po,lab0080
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    di
    nop
    nop
    nop
    nop
    nop
    and d
    rst 48
    ld d,c
    nop
    nop
    ld d,c
    ei
    and d
    nop
    nop
    nop
    nop
    di
    di
    ld d,c
    nop
    nop
    dec b
    rrca 
    di
    nop
    nop
    nop
    nop
    push de
    ld c,d
    nop
    nop
    nop
    nop
    rst 56
    ei
    nop
    nop
    nop
    and d
    rst 48
    ld d,l
    nop
    nop
    nop
    nop
    ld d,l
    ei
    ei
    nop
    nop
    rst 48
    rst 48
    push de
    nop
    nop
    nop
    ld b,b
    push de
    ei
    ld (hl),e
    nop
    nop
    rst 48
    cp e
    ld d,c
    ld b,b
    nop
    nop
    nop
    nop
    ld (hl),a
    xor d
    nop
    nop
    and d
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 48
    xor d
    nop
    nop
    add a,b
    rst 48
    ld d,c
    nop
    nop
    nop
    nop
    ld d,c
    jp po,lab0080
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    nop
    and d
    di
    di
    nop
    nop
    rrca 
    ld e,e
    and d
    nop
    nop
    nop
    nop
    xor d
    ret nz
    dec b
    nop
    nop
    ld d,l
    rst 56
    and d
    nop
    nop
    nop
    nop
    xor d
    ei
    nop
    nop
    nop
    ld d,l
    rst 48
    rst 48
    nop
    nop
    nop
    nop
    ei
    di
    ld b,b
    nop
    nop
    ret nz
    rst 56
    rst 48
    nop
    nop
    nop
    nop
    ld (hl),e
    rst 56
    add a,b
    ld b,b
    ld b,b
    ld d,l
    inc sp
    xor d
    nop
    nop
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
lab6A6A nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    and d
    di
    di
    nop
    nop
    nop
    nop
    rrca 
    ld e,e
    and d
    nop
    nop
    xor d
    ret nz
    dec b
    nop
    nop
    nop
    nop
    ld d,l
    rst 56
    and d
    nop
    nop
    xor d
    ei
    nop
    nop
    nop
    nop
    nop
    ld d,l
    rst 48
    rst 48
    nop
    nop
    ei
    di
    ld b,b
    nop
    nop
    nop
    nop
    ret nz
    rst 56
    rst 48
    nop
    nop
    ld (hl),e
    rst 56
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ld d,l
    inc sp
    xor d
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    nop
    nop
    di
    di
    nop
    nop
    rrca 
    di
    nop
    nop
    nop
    nop
    nop
    nop
    ld e,e
    dec b
    nop
    nop
    ld d,c
    rst 56
    xor d
    nop
    nop
    nop
    nop
    xor d
    rst 48
    rst 48
    nop
    nop
    ld e,e
    rst 56
    xor d
    nop
    nop
    nop
    nop
    xor d
    rst 48
    rrca 
    ret nz
    ret nz
    push de
    cp e
    ld (data0000),hl
    nop
    nop
    xor d
    inc sp
    ld d,l
    nop
    nop
    ei
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    rst 48
    ld d,l
    ld d,c
    ei
    di
    nop
    nop
    nop
    nop
    nop
    add a,b
    di
    add a,b
    ld b,b
    ret nz
    add a,b
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    add a,b
    ret nz
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    nop
    di
    di
    nop
    nop
    nop
    nop
    rrca 
    di
    nop
    nop
    nop
    nop
    ld e,e
    dec b
    nop
    nop
    nop
    nop
    ld d,c
    rst 56
    xor d
    nop
    nop
    xor d
    rst 48
    ld e,a
    nop
    nop
    nop
    nop
    ld e,e
    rst 56
    xor d
    nop
    nop
    xor d
    rst 48
    rrca 
    ret nz
    nop
    nop
    ret nz
    daa
    rst 56
    ld (data0000),hl
    xor d
    inc sp
    cp e
    nop
    nop
    nop
    nop
    ld d,c
    rst 56
    nop
    nop
    nop
    nop
    rst 56
    ld d,l
    nop
    nop
    nop
    nop
    ld d,c
    ei
    nop
    nop
    nop
    nop
    di
    ld d,l
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    nop
    nop
    di
    nop
    nop
    nop
    ld d,c
    ei
    and d
    nop
    nop
    nop
    nop
    and d
    di
    ld d,l
    nop
    nop
    ld d,c
    di
    and d
    nop
    nop
    nop
    nop
    and d
    di
    dec b
    ld b,b
    ld b,b
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    xor d
    rst 48
    jp po,data0000
    ei
    rst 56
    rst 56
    nop
    nop
    nop
    nop
    rst 56
    rst 48
    rst 48
    nop
    nop
    ld d,c
    ld (hl),a
    rst 56
    nop
    nop
    nop
    nop
    ld (hl),a
    or e
    ld d,l
    nop
    nop
    ld d,c
    rst 56
    xor d
    nop
    nop
    nop
    nop
    and d
    rst 48
    nop
    nop
    nop
    ld d,l
    ei
    xor d
    nop
    nop
    nop
    nop
    rst 48
    push de
    ld b,b
    nop
    nop
    ld b,b
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    nop
    di
    nop
    nop
    nop
    nop
    nop
    ld d,c
    ei
    and d
    nop
    nop
    and d
    di
    ld d,l
    nop
    nop
    nop
    nop
    ld d,c
    di
    and d
    nop
    nop
    and d
    di
    dec b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    ret nz
    nop
    nop
    nop
    xor d
    rst 48
    jp po,data0000
    nop
    nop
    ei
    rst 56
    rst 56
    nop
    nop
    rst 56
    rst 48
    rst 48
    nop
    nop
    nop
    nop
    ld d,c
    ld (hl),a
    rst 56
    nop
    nop
    ld (hl),a
    or e
    ld d,l
    nop
    nop
    nop
    nop
    ld d,c
    rst 56
    xor d
    nop
    nop
    and d
    rst 48
    nop
    nop
    nop
    nop
    nop
    ld d,l
    ei
    xor d
    nop
    nop
    rst 48
    push de
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    ret nz
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    add a,b
    ld b,b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,c
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    nop
    nop
    di
    di
    nop
    ld b,b
    ld e,e
    di
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    ld b,b
    nop
    pop de
    rst 56
    nop
    nop
    nop
    nop
    nop
    xor d
    rst 48
    rst 48
    nop
    nop
    ld d,c
    ld (hl),a
    xor d
    nop
    nop
    nop
    nop
    xor d
    inc sp
    ld d,l
    nop
    nop
    nop
    rst 56
    xor d
    nop
    nop
    nop
    nop
    xor d
    rst 48
    nop
    nop
    nop
    ld d,c
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    ld d,c
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,c
    and d
    nop
    nop
    nop
    nop
    di
    rst 48
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    di
    di
    nop
    nop
    nop
    ld b,b
    ld e,e
    di
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    ld b,b
    nop
    nop
    nop
    pop de
    rst 56
    nop
    nop
    nop
    xor d
    rst 48
    rst 48
    nop
    nop
    nop
    nop
    ld d,c
    ld (hl),a
    xor d
    nop
    nop
    xor d
    inc sp
    ld d,l
    nop
    nop
    nop
    nop
    nop
    rst 56
    xor d
    nop
    nop
    xor d
    rst 48
    nop
    nop
    nop
    nop
    nop
    ld d,c
    rst 56
    nop
    nop
    nop
    nop
    rst 56
    ld d,c
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
lab6E00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    adc a,b
    ld b,h
    nop
    nop
    call z,lab80E4
    nop
    nop
    nop
    nop
    add a,b
    call z,lab00D8
    nop
    call z,lab80CA+2
    nop
    nop
    nop
    nop
    add a,b
    call z,lab00CC
    nop
    call nz,lab80C8
    nop
    nop
    nop
    nop
    add a,b
    ret nc
    ret po
    ld b,h
    ld d,b
    ret c
    push hl
    and b
    nop
    nop
    nop
    nop
    and b
    rst 8
    call po,lab0044
    ret c
lab6E3E jp c,lab00A0
    nop
    nop
    nop
    and b
    push hl
    push hl
    nop
    nop
    rst 8
    jp c,data0000
    nop
    nop
    nop
    nop
    call po,lab00E5
    nop
    ret c
    call z,data0000
    nop
    nop
    nop
    nop
    ret nz
    ret p
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    add a,b
    adc a,b
    ld b,h
    nop
    nop
    nop
    nop
    call z,lab80E4
    nop
    nop
    add a,b
    call z,lab00D8
    nop
    nop
    nop
    call z,lab80CA+2
lab6E9D nop
    nop
    add a,b
    call z,lab00CC
    nop
    nop
    nop
    call nz,lab80C8
    nop
    nop
    add a,b
    ret nc
    ret po
    ld b,h
    nop
    nop
    ld d,b
    ret c
    push hl
    and b
    nop
    nop
    and b
    rst 8
    call po,lab0044
    nop
lab6EBD nop
    ret c
    jp c,lab00A0
    nop
    and b
    push hl
    push hl
    nop
    nop
    nop
    nop
    rst 8
lab6ECB jp c,data0000
    nop
    nop
    call po,lab00E5
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    nop
    ret nz
    ret p
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    ret c
    call z,lab0080
    nop
    nop
    nop
    add a,b
    call z,lab00CC
    nop
    call z,lab80CA+2
    nop
    nop
    nop
    nop
    add a,b
    ret z
    call nz,lab43FF+1
    ret po
    ret nc
    add a,b
    nop
    nop
    nop
    nop
    and b
    push hl
    ret c
    ld d,b
    ld b,h
    call po,labA0CF
    nop
    nop
    nop
    nop
    and b
    jp c,lab50D8
    ld b,h
    push hl
    push hl
    nop
    nop
    nop
    nop
    nop
    nop
    jp c,lab00CF
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    call z,data0000
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    ret c
    call z,lab0080
    nop
    add a,b
    call z,lab00CC
    nop
    nop
    nop
    call z,lab80CA+2
    nop
    nop
    add a,b
    ret z
    call nz,data0000
    nop
    ld b,h
    ret po
    ret nc
    add a,b
    nop
    nop
    and b
    push hl
    ret c
    ld d,b
    nop
    nop
    ld b,h
    call po,labA0CF
    nop
    nop
    and b
    jp c,lab50D8
    nop
    nop
    ld b,h
    push hl
    push hl
    nop
    nop
    nop
    nop
    jp c,lab00CF
    nop
    nop
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    ret p
    call z,data0000
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    nop
    adc a,b
    ld b,h
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    call z,lab008D
    nop
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    call z,data0000
    ret nz
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    add a,b
    adc a,d
    call po,lab5000
    ret c
    adc a,d
    add a,b
    nop
    nop
    nop
    nop
    and b
    ret p
    push hl
    ld b,h
    ld d,b
    rst 8
    push hl
    nop
    nop
    nop
    nop
    nop
    nop
    rst 8
    rst 8
    ld b,h
    ld b,l
    ret p
    adc a,d
    nop
    nop
    nop
    nop
    nop
    nop
    and b
    call po,lab0044
    ret c
    ret c
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    call nz,data0000
    call nz,lab00C0
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ld b,b
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    adc a,b
    ld b,h
    nop
    nop
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    call z,lab008D
    nop
    nop
    ld b,b
    ld a,(bc)
    call z,data0000
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    add a,b
    adc a,d
    call po,data0000
    nop
    ld d,b
    ret c
    adc a,d
    add a,b
    nop
    nop
    and b
    ret p
    push hl
    ld b,h
    nop
    nop
    ld d,b
    rst 8
    push hl
    nop
    nop
    nop
    nop
    rst 8
    rst 8
    ld b,h
    nop
    nop
    ld b,l
    ret p
    adc a,d
    nop
    nop
    nop
    nop
    and b
    call po,lab0044
    nop
    nop
    ret c
    ret c
    nop
    nop
    nop
    nop
    ret nz
    call nz,data0000
    nop
    nop
    call nz,lab00C0
    nop
    nop
    add a,b
    ret nz
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    adc a,b
    ld b,h
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    call z,lab008D
    nop
    nop
    nop
    nop
    ld b,b
    ld a,(bc)
    call z,data0000
    ret nz
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    add a,b
    adc a,d
    call po,lab5000
    call lab808A
    nop
    nop
    nop
    nop
    nop
    ret p
    rst 8
    ld b,h
    ld d,b
    jp c,lab00F0
    nop
    nop
    nop
    nop
    nop
    jp c,lab45F0
    ld b,h
    push hl
    jp c,data0000
    nop
    nop
    nop
    nop
    and b
    ret c
    nop
    nop
    ld b,h
    and b
    nop
    nop
    nop
    nop
    nop
    nop
    and b
    ld b,h
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    adc a,b
    ld b,h
    nop
    nop
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    call z,lab008D
    nop
    nop
    ld b,b
    ld a,(bc)
    call z,data0000
    nop
    nop
    ret nz
    add a,b
    ld b,b
    nop
    nop
    add a,b
    adc a,d
    call po,data0000
    nop
    ld d,b
    call lab808A
    nop
    nop
    nop
    ret p
    rst 8
    ld b,h
    nop
    nop
    ld d,b
    jp c,lab00F0
    nop
    nop
    nop
    jp c,lab45F0
    nop
    nop
    ld b,h
    push hl
    jp c,data0000
    nop
    nop
    and b
    ret c
    nop
    nop
    nop
    nop
    ld b,h
    and b
    nop
    nop
    nop
    nop
    and b
    ld b,h
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    call z,data0000
    nop
    nop
    nop
    adc a,b
    ret c
    ld b,h
    nop
    nop
    ld b,h
    call po,lab0088
    nop
    nop
    nop
    ld a,(bc)
    call z,lab0044
    nop
    ld b,h
    adc a,l
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    push hl
    ret p
    nop
    nop
    nop
    nop
    nop
    and b
    jp c,lab00CD
    ld b,h
    call po,labA0DA
    nop
    nop
    nop
    add a,b
    ret nz
    ret nz
    ret z
    ld d,b
    ld b,h
    ret po
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    push hl
    ret c
    nop
    nop
    rst 8
    jp c,lab00A0
    nop
    nop
    nop
    ret p
    ret p
    ld b,h
    nop
    nop
    ld b,h
    ret c
    ret p
    nop
    nop
    nop
    nop
    ret nz
    adc a,b
    ret nz
    nop
    nop
    ret nz
    nop
    ret nz
    nop
    nop
    nop
    add a,b
    ret nz
    nop
    add a,b
    ld b,b
    ld b,b
    ret nz
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab727F nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    nop
    adc a,l
    call z,data0000
    nop
    nop
    call z,lab000A
    nop
    nop
    nop
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    rst 8
    ret p
    nop
    nop
    nop
    and b
    jp c,lab00E4
    nop
    nop
    ld d,b
    ret c
    jp c,lab00A0
    add a,b
    ret nz
    ret nz
    ret nz
    ld b,h
    nop
    nop
    ld d,b
    ret z
    ret nz
    ret nz
    add a,b
    nop
    nop
    rst 8
    call po,data0000
    nop
    nop
    rst 8
    jp c,lab00A0
    nop
    nop
    ret p
    ret c
    nop
    nop
    nop
    nop
    ld b,h
    call po,data0000
    nop
    nop
    call po,lab0050
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    call z,lab44CC
    nop
    nop
    ld b,h
    adc a,l
    rrca 
    nop
    nop
    nop
    nop
    ld a,(bc)
    ret nz
    ld d,b
    nop
    nop
    ld d,b
    ret p
    and b
    nop
    nop
    nop
    nop
    nop
    ret nc
    call lab43FF+1
    call po,lab00C0
    nop
    nop
    nop
    nop
    add a,b
    jp z,lab50D8
    ld b,h
    adc a,#e5
    ret nz
    nop
    nop
    nop
    nop
    ld b,b
    ret p
    call lab0050
    ret p
    adc a,d
    nop
    nop
    nop
    nop
    nop
    nop
    and b
    ret c
    nop
    nop
    ret p
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call z,lab00D0
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    ld b,h
    adc a,b
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    nop
    nop
    call z,lab00E4
    nop
    call z,lab44CC
    nop
    nop
    nop
    nop
    ld b,h
    adc a,l
    rrca 
    nop
    nop
    ld a,(bc)
    ret nz
    ld d,b
    nop
    nop
    nop
    nop
    ld d,b
    ret p
    and b
    nop
    nop
    nop
    ret nc
    call data0000
    nop
    ld b,h
    call po,lab00C0
    nop
    nop
    add a,b
    jp z,lab50D8
    nop
    nop
    ld b,h
    adc a,#e5
    ret nz
    nop
    nop
    ld b,b
    ret p
    call lab0050
    nop
    nop
    ret p
    adc a,d
    nop
    nop
    nop
    nop
    and b
    ret c
    nop
    nop
    nop
    nop
    ret p
    adc a,b
    nop
    nop
    nop
    nop
    call z,lab00D0
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    add a,b
    ret nz
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
    call z,data0000
    nop
    nop
    nop
    adc a,b
    call po,lab0044
    nop
    ld b,h
    ret c
    adc a,b
    nop
    nop
    nop
    nop
    adc a,b
    call z,lab00CC
    nop
    call z,lab0A0F
    nop
    nop
    nop
    nop
    nop
    add a,l
    ret po
    nop
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    and b
    call po,lab5000
    call lab00F0
    nop
    nop
    nop
    nop
    nop
    jp z,lab44E3+1
    ld d,b
    ret c
    push hl
    add a,b
    nop
    nop
    nop
    nop
    ret nz
    and b
    jp c,lab0044
    push hl
    jp c,lab0040
    nop
    nop
    nop
    nop
    and b
    ld b,h
    nop
    nop
    ld d,b
    and b
    nop
    nop
    nop
    nop
    nop
    nop
    and b
    ld b,h
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    call z,data0000
    nop
    adc a,b
    call po,lab0044
    nop
    nop
    nop
    ld b,h
    ret c
    adc a,b
    nop
    nop
    adc a,b
    call z,lab00CC
    nop
    nop
    nop
    call z,lab0A0F
    nop
    nop
    nop
    add a,l
    ret po
    nop
    nop
    nop
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    and b
    call po,data0000
    nop
    ld d,b
    call lab00F0
    nop
    nop
    nop
    jp z,lab44E3+1
    nop
    nop
    ld d,b
    ret c
    push hl
    add a,b
    nop
    nop
    ret nz
    and b
    jp c,lab0044
    nop
    nop
    push hl
    jp c,lab0040
    nop
    nop
    and b
    ld b,h
    nop
    nop
    nop
    nop
    ld d,b
    and b
    nop
    nop
    nop
    nop
    and b
    ld b,h
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    ret c
    call z,data0000
    nop
    nop
    nop
    nop
    call z,lab00CC
    nop
    adc a,l
    ld c,(hl)
    nop
    nop
    nop
    nop
    nop
    and b
    ret nz
    ret nz
    ld d,b
    ld b,h
    jp c,labA0D8
    nop
    nop
    nop
    nop
    and b
    ret p
    call lab444F+1
    rst 8
    jp c,lab00A0
    nop
    nop
    nop
    nop
    push hl
    ret z
    ld d,b
    nop
    jp z,lab00DA
    nop
    nop
    nop
    nop
    nop
    ret p
    ret po
    nop
    nop
    ret z
    call po,data0000
    nop
    nop
    nop
    nop
    call z,lab00F0
    nop
    ret c
    call z,data0000
    nop
    nop
    nop
    nop
    call po,lab00E4
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    nop
    call z,lab00CC
    nop
    nop
    nop
    adc a,l
    ld c,(hl)
    nop
    nop
    nop
    and b
    ret nz
    ret nz
    ld d,b
    nop
    nop
    ld b,h
    jp c,labA0D8
    nop
    nop
    and b
    ret p
    call lab0050
    nop
    ld b,h
    rst 8
    jp c,lab00A0
    nop
    nop
    push hl
    ret z
    ld d,b
    nop
    nop
    nop
    jp z,lab00DA
    nop
    nop
    nop
    ret p
    ret po
    nop
    nop
    nop
    nop
    ret z
    call po,data0000
    nop
    nop
    call z,lab00E0
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    nop
    call po,lab00E4
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    nop
    adc a,b
    ld b,h
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    call z,lab00CC
    nop
    nop
    nop
    nop
    nop
    ld c,(hl)
    adc a,l
    nop
    ld d,b
    ret nz
    ret nz
    and b
    nop
    nop
    nop
    nop
    and b
    ret c
    jp c,lab5044
    call labA0F0
    nop
    nop
    nop
    nop
    and b
    jp c,lab44CF
    ld d,b
    ret z
    push hl
    nop
    nop
    nop
    nop
    nop
    nop
    jp c,lab00CA
    nop
    ret po
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ret z
    nop
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    call po,data0000
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
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
    nop
    adc a,b
    ld b,h
    nop
    nop
    nop
    nop
    call z,lab00E4
    nop
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    call z,lab00CC
    nop
    nop
    nop
    ld c,(hl)
    adc a,l
    nop
    nop
    nop
    ld d,b
    ret nz
    ret nz
    and b
    nop
    nop
    and b
    ret c
    jp c,lab0044
    nop
    ld d,b
    call labA0F0
    nop
    nop
    and b
    jp c,lab44CF
    nop
    nop
    ld d,b
    ret z
    push hl
    nop
    nop
    nop
    nop
    jp c,lab00CA
    nop
    nop
    nop
    ret po
    ret p
    nop
    nop
    nop
    nop
    ret p
    ret z
    nop
    nop
    nop
    nop
    ret c
    ret p
    nop
    nop
    nop
    nop
    ret p
    call po,data0000
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
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
    call z,data0000
    nop
    nop
    nop
    nop
    nop
    adc a,b
    ret c
    ld b,h
    ld b,h
    call po,lab0088
    nop
lab7711 nop
    nop
    nop
    nop
    call z,lab44CC
    dec b
    rrca 
    call z,data0000
    nop
    nop
    nop
    nop
    ret nc
    ld c,d
    nop
    nop
    ret p
    call po,data0000
    nop
    nop
    nop
    adc a,b
    ret c
    ld d,b
    nop
    nop
    ld d,b
    call po,lab00E4
    nop
    nop
    nop
    ret c
    ret c
    ret nc
    nop
    ld b,b
    ret nc
    call po,lab00CE
    nop
    nop
    nop
    ret c
    push hl
    ld b,h
    ld b,b
    nop
    nop
    jp c,lab00A0
    nop
    nop
    nop
    adc a,b
    ret p
    nop
    nop
    nop
    nop
    ret c
    and b
    nop
    nop
    nop
    nop
    add a,b
    ret c
    ld b,h
    nop
    nop
    ld b,b
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    call z,data0000
    nop
    nop
    nop
    adc a,b
    ret c
    ld b,h
    nop
    nop
    ld b,h
    call po,lab0088
    nop
    nop
    nop
    call z,lab44CC
    nop
    nop
    dec b
    rrca 
    call z,data0000
    nop
    nop
    ret nc
    ld c,d
    nop
    nop
    nop
    nop
    ret p
    call po,data0000
    nop
    adc a,b
    ret c
    ld d,b
    nop
    nop
    nop
    nop
    ld d,b
    call po,lab00E4
    nop
    ret c
    ret c
    ret nc
    nop
    nop
    nop
    ld b,b
    ret nc
    call po,lab00CE
    nop
    ret c
    push hl
    ld b,h
    ld b,b
    nop
    nop
    nop
    nop
    jp c,lab00A0
    nop
    adc a,b
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    ret c
    and b
    nop
    nop
    add a,b
    ret c
    ld b,h
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    add a,b
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    ret c
    call z,data0000
    nop
    nop
    nop
    adc a,b
    call z,lab00CC
    nop
    rrca 
    ld c,(hl)
    adc a,b
    nop
    nop
    nop
    nop
    and b
    ret nz
    dec b
    nop
    nop
    ld d,b
    ret p
    adc a,b
    nop
    nop
    nop
    nop
    and b
    call po,data0000
    nop
    ld d,b
    ret c
    ret c
    nop
    nop
    nop
    nop
    call po,lab40CC
    nop
    nop
    ret nz
    ret p
    ret c
    nop
    nop
    nop
    nop
    adc a,#f0
    add a,b
    ld b,b
    ld b,b
    ld d,b
    rst 8
    and b
    nop
    nop
    nop
    nop
    nop
    call po,data0000
    nop
    nop
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    call po,data0000
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    adc a,b
    call z,lab00CC
    nop
    nop
    nop
    rrca 
    ld c,(hl)
    adc a,b
    nop
    nop
    and b
    ret nz
    dec b
    nop
    nop
    nop
    nop
    ld d,b
    ret p
    adc a,b
    nop
    nop
    and b
    call po,data0000
    nop
    nop
    nop
    ld d,b
    ret c
    ret c
    nop
    nop
    call po,lab40CC
    nop
    nop
    nop
    nop
    ret nz
    ret p
    ret c
    nop
    nop
    adc a,#f0
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ld d,b
    rst 8
    and b
    nop
    nop
    nop
    call po,data0000
    nop
    nop
    nop
    nop
    ret p
    nop
    nop
    nop
    nop
    call po,data0000
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
lab78FC nop
    nop
    nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    ret c
    call z,data0000
    nop
    nop
    nop
    nop
    call z,lab00CC
    nop
    rrca 
    call z,data0000
    nop
    nop
    nop
    nop
    ld c,(hl)
    dec b
    nop
    nop
    ld d,b
    ret c
    and b
    nop
    nop
    nop
    nop
    and b
    call po,lab00CC
    ret nz
    ld c,(hl)
    ret c
    and b
    nop
    nop
    nop
    nop
    and b
    call po,labC00F
    nop
    ld b,h
    push hl
    adc a,d
    nop
    nop
    nop
    nop
    and b
    rst 8
    ld b,h
    nop
    nop
    ret c
    ret c
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    call po,lab5044
    call z,lab00CC
    nop
    nop
    nop
    nop
    add a,b
    call z,lab407F+1
    ret nz
    add a,b
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    add a,b
    ret nz
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    ret c
    call z,data0000
    nop
    nop
    call z,lab00CC
    nop
    nop
    nop
    rrca 
    call z,data0000
    nop
    nop
    ld c,(hl)
    dec b
    nop
    nop
    nop
    nop
    ld b,h
    ret p
    and b
    nop
    nop
    and b
    ret c
    ld e,d
    nop
    nop
    nop
    ret nz
    ld c,(hl)
    ret p
    and b
    nop
    nop
    and b
    ret c
    rrca 
    ret nz
    nop
    nop
    nop
    adc a,a
    ret p
    adc a,d
    nop
    nop
    and b
    rst 8
    push hl
    nop
    nop
    nop
    nop
    ld b,h
    ret p
    nop
    nop
    nop
    nop
    ret p
    ld d,b
    nop
    nop
    nop
    nop
    ld b,h
    call po,data0000
    nop
    nop
    call z,lab0050
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
lab7A00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,data0000
    nop
    ld b,h
    call po,lab0088
    nop
    nop
    nop
    adc a,b
    call z,lab0050
    ld b,b
    ld b,h
    call z,lab0088
    nop
    nop
    nop
    adc a,b
    call z,lab4085
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    nop
    and b
    ret c
    ret z
    nop
    nop
    call po,labF0F0
    nop
    nop
    nop
    nop
    ret p
    ret c
    ret c
    nop
    nop
    ld b,h
    jp c,lab00F0
    nop
    nop
    nop
    jp c,lab50CD
    nop
    nop
    ld b,h
    ret p
    and b
    nop
    nop
    nop
    nop
    adc a,b
    ret c
    nop
    nop
    nop
    ld d,b
    call po,lab00A0
    nop
    nop
    nop
    ret c
    ret nc
    ld b,b
    nop
    nop
    ld b,b
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    nop
    call z,data0000
    nop
    nop
    nop
    ld b,h
    call po,lab0088
    nop
    adc a,b
    call z,lab0050
    nop
    nop
    ld b,b
    ld b,h
    call z,lab0088
    nop
    adc a,b
    call z,lab4085
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    and b
    ret c
    ret z
    nop
    nop
    nop
    nop
    call po,labF0F0
    nop
    nop
    ret p
    ret c
    ret c
    nop
    nop
    nop
    nop
    ld b,h
    jp c,lab00F0
    nop
    jp c,lab50CD
    nop
    nop
    nop
    nop
    ld b,h
    ret p
    and b
    nop
    nop
    adc a,b
    ret c
    nop
    nop
    nop
    nop
    nop
    ld d,b
    call po,lab00A0
    nop
    ret c
    ret nc
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    ret nz
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    add a,b
    ld b,b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    call po,lab00CC
    nop
    nop
    nop
    nop
    nop
    call z,lab00CC
    ld b,b
    ld c,(hl)
    call z,data0000
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    ld b,b
    nop
    call nz,lab00F0
    nop
    nop
    nop
    nop
    and b
    ret c
    ret c
    nop
    nop
    ld b,h
    jp c,lab00A0
    nop
    nop
    nop
    and b
    rst 8
    ld d,b
    nop
    nop
    nop
    ret p
    and b
    nop
    nop
    nop
    nop
    and b
    ret c
    nop
    nop
    nop
    ld b,h
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ld b,h
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,h
    adc a,b
    nop
    nop
    nop
    nop
    call z,lab00D8
    nop
    nop
    nop
    call po,lab00CC
    nop
    nop
    nop
    call z,lab00CC
    nop
    nop
    ld b,b
    ld c,(hl)
    call z,data0000
    nop
    nop
    add a,b
    ret nz
    ld b,b
    nop
    nop
    nop
    call nz,lab00F0
    nop
    nop
    and b
    ret c
    ret c
    nop
    nop
    nop
    nop
    ld b,h
    jp c,lab00A0
    nop
    and b
    rst 8
    ld d,b
    nop
    nop
    nop
    nop
    nop
    ret p
    and b
    nop
    nop
    and b
    ret c
    nop
    nop
    nop
    nop
    nop
    ld b,h
    ret p
    nop
    nop
    nop
    nop
    ret p
    ld b,h
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
lab7BEE ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ret nz
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
    rrca 
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    ld e,a
    nop
    nop
    ei
    rst 48
    di
    dec b
    nop
    nop
    xor a
    di
    di
    rst 48
    nop
    nop
    ld d,c
    and a
    ld e,e
    and a
    nop
    nop
    xor d
    ret nz
    ret nz
    ld d,l
    nop
    nop
    nop
    cp e
    rst 48
    and d
    nop
    nop
    ld (labB273),hl
    ld (data0000),hl
    djnz lab7BEE
    ld (data0000),a
    nop
    nop
    ld e,a
    ld a,(de)
    nop
    nop
    ld de,lab3131
    ld sp,lab0031
    nop
    nop
    ld e,a
    ld a,(de)
    nop
    nop
    nop
    djnz lab7C7E
    ld (data0000),a
    nop
    ld (labBAFB),hl
    ld (data0000),hl
    ld d,l
    cp e
    rst 48
    nop
    nop
    nop
    nop
    ei
    and d
    rst 56
    nop
    nop
    ret nz
    nop
    jp po,lab0080
    nop
    add a,b
    ld b,b
    nop
    ret nz
    nop
    ld b,b
    ret nz
    nop
    ld b,b
    ret nz
    nop
    nop
    ret nz
    ld b,b
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
lab7C7E nop
    nop
    nop
    nop
    ld d,c
    and d
    nop
    nop
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    rst 48
    di
    nop
    nop
    nop
    and d
    di
    di
    nop
    nop
    nop
    nop
    rrca 
    ld e,e
    and d
    nop
    nop
    xor d
    ret nz
    dec b
    nop
    nop
    nop
    nop
    ld d,l
    rst 56
    and d
    nop
    nop
    xor d
    ei
    nop
    nop
    nop
    nop
    nop
    ld d,l
    jp po,lab00F7
    nop
    ei
    jp po,lab00F3
    nop
    nop
    ld e,a
    ei
    push de
    rst 48
    nop
    nop
    ld (hl),e
    push de
    di
    ld e,a
    nop
    nop
    nop
    ld b,b
    inc sp
    xor d
    nop
    nop
    nop
    ei
    ret nz
    nop
    nop
    nop
    nop
    add a,b
    rst 56
    nop
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
lab7CF0 nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
lab7CFC nop
    nop
    nop
    nop
    nop
    nop
    ld d,c
    and d
    rrca 
    nop
    nop
    xor a
    ei
    di
    nop
    nop
    nop
    ld a,(bc)
    rst 48
    di
    rst 48
    nop
    nop
    ei
    di
    di
    ld e,a
    nop
    nop
    ld e,e
    and a
    ld e,e
    and d
    nop
    nop
    xor d
    ret nz
    ret nz
    ld d,l
    nop
    nop
    ld d,c
    ei
    ld (hl),a
    nop
    nop
    nop
    ld de,labF76F+2
    ld de,data0000
    nop
    ld (hl),c
    ld (hl),a
    jr nz,lab7D36
lab7D36 nop
    nop
    dec h
    xor a
    nop
    nop
    nop
    djnz lab7D71
    ld (lab2232),a
    nop
    nop
    dec h
    xor a
    nop
    nop
    nop
    nop
    ld sp,lab2033
    nop
    nop
    ld de,labF775
    ld de,data0000
    nop
    rst 56
    ld (hl),a
    xor d
    nop
    nop
    rst 56
    ld d,c
    rst 48
    nop
    nop
    nop
    ld b,b
    pop de
    nop
    ret nz
    nop
    nop
    ret nz
    nop
    add a,b
    ld b,b
    nop
    nop
    ret nz
    add a,b
    nop
    ret nz
lab7D71 add a,b
    add a,b
    ret nz
    nop
    add a,b
    ret nz
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
    ld d,c
    and d
    nop
    nop
    ei
    di
    nop
    nop
    nop
    nop
    nop
    ld a,(bc)
    rst 48
    di
    nop
    nop
    di
    di
    ld a,(bc)
    dec b
    nop
    nop
    nop
    xor d
    rrca 
    ld e,e
    nop
    nop
    ret nz
    dec b
    rst 48
    nop
    nop
    nop
    nop
    ei
    rst 56
    rst 48
    nop
    nop
    rst 56
    di
    ld d,l
    nop
    nop
    nop
    nop
    nop
    jp pe,lab00F7
    nop
    ei
    jp po,data0000
    nop
    nop
    nop
    nop
    push de
    rst 48
    nop
    nop
    ld (lab00D5),hl
    nop
    nop
    nop
    nop
    ld b,b
    inc sp
    xor d
    nop
    nop
    nop
    ei
    ret nz
    nop
    nop
    nop
    nop
    add a,b
    rst 56
    nop
    nop
    nop
    nop
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
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
    add a,b
    di
    nop
    nop
    nop
    nop
    nop
    and d
    rst 48
    pop de
    ld b,b
    ld b,b
    pop de
    ei
    and d
    nop
    nop
    nop
    nop
    and d
    di
    pop de
    ld b,b
    ld b,b
    pop de
    rrca 
    or e
    nop
    nop
    nop
    nop
    ld h,a
    ret nz
    push bc
    ld b,b
    dec b
    push bc
    inc sp
    rst 8
    nop
    nop
    nop
    nop
    ld h,a
    ld h,a
    push bc
    dec b
    ld b,b
    push bc
    inc sp
    rst 8
    nop
    nop
    nop
    nop
    xor d
    rst 56
    push de
    ld b,b
    ld b,b
    push bc
    ld h,a
    ld (data0000),hl
    nop
    nop
    adc a,d
    sbc a,e
    sub c
    ld b,b
    ld b,b
    push bc
    inc sp
    ld (data0000),hl
    nop
    nop
    adc a,d
    sbc a,e
    push bc
    ld b,b
    nop
    ld de,lab229B
    nop
    nop
    nop
    nop
    adc a,d
    sbc a,e
    ld b,l
    nop
    nop
    ld b,b
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    add a,b
    di
    nop
    nop
    nop
    and d
    rst 48
    pop de
    ld b,b
    nop
    nop
    ld b,b
    pop de
    ei
    and d
    nop
    nop
    and d
    di
    pop de
    ld b,b
    nop
    nop
    ld b,b
    pop de
    rrca 
    or e
    nop
    nop
    ld h,a
    ret nz
    push bc
    ld b,b
    nop
    nop
    dec b
    push bc
    inc sp
    rst 8
    nop
    nop
    ld h,a
    ld h,a
    push bc
    dec b
    nop
    nop
    ld b,b
    push bc
    inc sp
    rst 8
    nop
    nop
    xor d
    rst 56
    push de
    ld b,b
    nop
    nop
    ld b,b
    sub c
    sbc a,e
    ld (data0000),hl
    adc a,d
    ld h,a
    push bc
    ld b,b
    nop
    nop
    ld b,b
    sub c
    rst 8
    ld (data0000),hl
    adc a,d
    ld h,a
    sub c
    ld b,b
    nop
    nop
    nop
    ld de,lab22CF
    nop
    nop
    adc a,d
    ld h,a
    ld de,data0000
    nop
    nop
    ld b,b
    ret nz
    add a,b
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    djnz lab7F03
lab7F03 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7F1E
    djnz lab7F10
lab7F10 nop
    nop
    nop
    nop
    nop
    jr nz,lab7F47
    nop
    nop
    jr nc,lab7F4B
    nop
    nop
    nop
lab7F1E nop
    nop
    nop
    jr nz,lab7F53
    djnz lab7F25
lab7F25 jr nc,lab7F47
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7F3E+1
    djnz lab7F31
lab7F31 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7F3C
lab7F3C nop
    nop
lab7F3E djnz lab7F40
lab7F40 nop
    nop
    nop
    nop
    nop
    nop
    nop
lab7F47 nop
    nop
    djnz lab7F5B
lab7F4B djnz lab7F4D
lab7F4D nop
    nop
    nop
    jr nz,lab7F82
    nop
lab7F53 nop
    nop
    nop
    jr nc,lab7F88
    nop
    nop
    nop
lab7F5B nop
    jr nz,lab7F8D+1
    djnz lab7F60
lab7F60 nop
    nop
    jr nc,lab7F84
    nop
    nop
    nop
    nop
    djnz lab7F7A
    djnz lab7F6C
lab7F6C nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7F77
lab7F77 nop
    nop
    nop
lab7F7A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab7F82 nop
    nop
lab7F84 nop
    nop
    nop
    nop
lab7F88 nop
    nop
    nop
    nop
    nop
lab7F8D djnz lab7F8F
lab7F8F nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7F98
lab7F98 nop
    jr nc,lab7FBB
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz,lab7FD3
    nop
    nop
    djnz lab7FA7
lab7FA7 nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab7FB0
lab7FB0 nop
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
lab7FBB nop
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
    djnz lab7FCC
lab7FCC nop
    nop
    nop
    nop
    nop
    djnz lab7FD3
lab7FD3 nop
    nop
    nop
    jr nc,lab7FF8
    nop
    nop
    nop
    nop
    jr nz,lab800E
    nop
    nop
lab7FE0 nop
    nop
    djnz lab7FE4
lab7FE4 nop
    nop
    nop
    nop
    nop
    djnz lab7FEB
lab7FEB nop
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
lab7FF8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8000 nop
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
lab800E add a,d
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab0041
    nop
    ld b,c
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,c
    nop
    nop
    nop
    add a,b
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
    nop
    nop
    nop
    nop
    nop
    ld b,c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    jp nz,lab0080
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    ld b,c
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    jp nz,data0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab0082
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
    nop
    nop
    nop
lab8082 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab808A nop
    nop
    nop
    nop
    nop
    add a,d
    nop
    nop
    nop
    nop
    jp nz,lab0041
    nop
    nop
    nop
    ld b,c
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ld b,c
    nop
    nop
    nop
    nop
    nop
    add a,b
    nop
    nop
lab80AA nop
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
    nop
    nop
    ld b,c
    nop
lab80C0 nop
    nop
lab80C2 nop
    nop
    add a,b
    ld b,b
    nop
    nop
lab80C8 nop
    nop
lab80CA jp nz,lab0080
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
lab80D5 ld b,c
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    jp nz,data0000
lab80E4 nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    add a,d
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
    add a,d
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab0041
    nop
    jp lab00C0
    nop
    nop
    nop
    nop
    nop
    ret nz
    jp data0000
    jp nz,lab00C0
    nop
    nop
    nop
    nop
    nop
    ret nz
    jp nz,data0000
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab00C2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab00C2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab00C2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,lab00C1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    pop bc
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
    nop
    nop
    nop
    nop
    nop
    nop
    add a,d
    nop
    nop
    nop
    nop
    jp nz,lab0041
    nop
    nop
    nop
    jp lab00C0
    nop
    nop
    nop
    ret nz
    jp data0000
    nop
    nop
    jp nz,lab00C0
    nop
    nop
    nop
    ret nz
    jp nz,data0000
    nop
    nop
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
lab81C0 nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    jp nz,data0000
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    jp nz,data0000
    nop
    nop
lab81DA nop
    nop
    nop
    nop
    jp nz,data0000
    jp nz,data0000
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    pop bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    pop bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8200 nop
    nop
    add a,d
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab0041
    nop
    ld b,c
    jp nz,data0000
    nop
    nop
    nop
    add a,b
    ret nz
    jp data0000
    jp lab80C0
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    jp nz,data0000
    jp nz,lab80C0
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    nop
    nop
    ld b,c
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
    jp nz,lab80C2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,c
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,data0000
    ld b,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ld b,c
    nop
    nop
    nop
    add a,d
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
    nop
    nop
    nop
    add a,d
    nop
    nop
    nop
    nop
    jp lab0041
    nop
    nop
    nop
    ld b,c
    jp nz,data0000
    nop
    add a,b
    ret nz
    jp data0000
    nop
    nop
    jp lab80C0
    nop
    nop
    add a,b
    ret nz
    jp nz,data0000
    nop
    nop
    jp nz,lab80C0
    nop
    nop
    nop
    ret nz
    ld b,b
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    nop
    nop
    nop
    nop
    add a,b
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
lab82C3 nop
    nop
    nop
    ld b,c
    nop
    nop
    jp nz,data0000
    nop
    nop
    nop
    nop
    nop
    add a,b
    jp nz,data0000
    ld b,c
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    jp nz,data0000
    nop
    nop
    nop
    add a,b
    ld b,b
    nop
    nop
    nop
    nop
    ld b,c
    add a,b
    nop
    nop
    nop
    nop
    add a,d
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
lab82FF nop
    ld b,b
    ld d,c
    di
    nop
    nop
    nop
    nop
    nop
    and d
    ei
    di
    ld b,b
    ld b,b
    rst 48
    di
    and d
    nop
    nop
    nop
    nop
    and d
    di
    ld d,c
    dec b
    ld b,b
    and a
    di
    and d
    nop
    nop
    nop
    nop
    rst 56
    ld e,e
    and a
    ld b,b
    ld b,b
    or e
    rst 48
    rst 56
    nop
    nop
    nop
    ld a,(bc)
    rst 56
    ei
    or e
    ld b,b
    ld b,b
    ld d,l
    ld (hl),a
    and d
    ld a,(bc)
    nop
    nop
    nop
    and d
    ld (hl),e
    ld d,c
    ld b,l
    ld b,l
    ld de,lab2233
    nop
    nop
    nop
lab8343 nop
    nop
    rst 56
    ld d,l
    nop
    nop
    rst 48
    and d
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    ei
    nop
    nop
lab8355 di
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    rst 48
    ld d,c
    nop
    nop
    ld b,b
    push de
    add a,b
    nop
    nop
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    nop
    add a,b
    ld b,b
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
    ld b,b
    ld d,c
    di
    nop
    nop
    nop
    nop
    ei
    di
    ld b,b
    nop
    nop
    ld b,b
    rst 48
    di
    and d
    nop
    nop
    and d
    di
    ld d,c
    dec b
    nop
    nop
    ld b,b
    and a
    di
    and d
    nop
    nop
    rst 56
    ld e,e
    and a
    ld b,b
    nop
    nop
    ld b,b
    or e
    rst 48
    rst 56
    nop
    ld a,(bc)
    rst 56
    ei
    or e
    ld b,b
    nop
    nop
    ld b,b
    ld d,l
    ld (hl),a
    and d
    ld a,(bc)
    nop
    and d
    ld (hl),e
    ld d,c
    ld b,l
    nop
    nop
    ld b,l
    ld de,lab2233
    nop
    nop
    nop
    rst 56
    ld d,l
    nop
    nop
    nop
    nop
    rst 48
    and d
    nop
    nop
    nop
    nop
    xor d
    ei
    nop
    nop
    nop
    nop
    di
    rst 56
    nop
    nop
    nop
    nop
    rst 48
    ld d,c
    nop
    nop
    nop
    nop
    ld b,b
    ret nz
    add a,b
    nop
    nop
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ret nz
    nop
    nop
    add a,b
    ld b,b
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
    ld d,c
    di
    nop
    nop
    nop
    and d
    ei
    di
    nop
    nop
    nop
    nop
    di
    rst 48
    and a
    nop
    nop
    ld d,c
    di
    di
    nop
    nop
    nop
    nop
    di
    and a
    di
    nop
    nop
    di
    rrca 
    ei
    ld d,c
    nop
    nop
    ld d,l
    or e
    rst 48
    and d
    nop
    nop
    and d
    ld (hl),e
    ei
    ld e,e
    ld b,l
    ld b,l
    ld a,(bc)
    rst 48
    ld (hl),a
    nop
    nop
    nop
    nop
    cp e
    di
    add a,b
    ld b,l
    nop
    ret nz
    inc sp
    inc sp
    nop
    nop
    nop
    nop
    rst 56
    push de
    ld b,b
    nop
    nop
    nop
    ret nz
    rst 48
    xor d
    nop
    nop
    xor d
    ei
    ld b,b
    nop
    nop
    nop
    nop
    ld d,l
    ei
    xor d
    nop
    nop
    nop
    di
    ld d,l
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ld b,b
    nop
    nop
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    ret nz
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
    ld d,c
    di
    nop
    and d
    ei
    di
    nop
    nop
    nop
    nop
    nop
    nop
    di
    rst 48
    and a
    ld d,c
    di
    di
    nop
    nop
    nop
    nop
    nop
    nop
    di
    and a
    di
    di
    rrca 
    ei
    ld d,c
    nop
    nop
    nop
    nop
    ld d,l
    or e
    rst 48
    and d
    and d
    ld (hl),e
    ei
    ld e,e
    ld b,l
lab84AF nop
    nop
    ld b,l
    ld a,(bc)
    rst 48
    ld (hl),a
    nop
    nop
    cp e
    di
    add a,b
    ld b,l
    nop
    nop
    nop
    ret nz
    inc sp
    inc sp
    nop
    nop
    rst 56
    push de
    ld b,b
    nop
    nop
    nop
    nop
    nop
    ret nz
    rst 48
    xor d
    xor d
    ei
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,l
    ei
    xor d
    nop
    di
    ld d,l
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    nop
lab84E6 add a,b
    ret nz
    add a,b
    ld b,b
    nop
    nop
lab84EC nop
    nop
    ld b,b
    ret nz
    ret nz
    add a,b
    nop
    nop
    ret nz
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
    dec b
    ld a,(bc)
    nop
    nop
    nop
    nop
    dec h
    rrca 
    dec b
    nop
    nop
    rrca 
    rrca 
    ld a,(de)
    ld a,(bc)
    adc a,d
    jr nz,lab8534
    dec h
    rrca 
    rrca 
    nop
    nop
    rrca 
    jr nc,lab8536
    ld c,a
    nop
    jr nz,lab84AF
    dec h
    jr nc,lab8533
    dec b
    dec b
    sbc a,d
    jr nc,lab8557+1
    sbc a,d
    rrca 
    dec h
    rst 8
    ld c,a
    jr nc,lab857E
    rrca 
    dec h
    ld a,(de)
    adc a,a
lab8533 rrca 
lab8534 sbc a,d
    adc a,a
lab8536 rrca 
    jr nc,lab8548
    sbc a,d
    jr nc,lab854B
    dec h
    dec h
    rrca 
    dec h
    ld h,l
    adc a,d
    ld a,(bc)
    rrca 
    ld a,(de)
    jr nc,lab8555+1
    dec h
lab8548 jr nc,lab8564
    rrca 
lab854B dec h
    dec h
    ld a,(bc)
    ld a,(bc)
    ld a,(de)
    jr nc,lab84EC
    dec h
    jr nc,lab8565
lab8555 jr nc,lab84E6
lab8557 jr nc,lab8589
    dec b
    ld a,(de)
    jr nz,lab8577
    ld a,(de)
    ld h,l
    djnz lab85A6
    rst 8
    jr nc,lab8573
lab8564 dec b
lab8565 dec h
    ld a,(bc)
    nop
    ld a,(de)
    ld a,(de)
    adc a,a
    djnz lab856D
lab856D rst 8
    dec h
    dec h
    nop
    nop
    nop
lab8573 nop
    ld a,(bc)
    ld a,(de)
    nop
lab8577 nop
    nop
    nop
    nop
    nop
    nop
    nop
lab857E nop
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
lab8589 nop
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
    nop
    nop
    nop
    nop
    ld a,(bc)
    dec b
    rrca 
    nop
    nop
    nop
    dec b
lab85A6 ld h,l
    jr nc,lab85B3
    nop
    nop
    adc a,d
    adc a,a
    ld h,l
    djnz lab85B0
lab85B0 nop
    nop
    adc a,a
lab85B3 adc a,a
    nop
    nop
    nop
    nop
    ld a,(de)
    ld a,(de)
    dec b
    nop
    nop
    ld b,l
    ld c,a
    rrca 
    ld a,(bc)
    nop
lab85C2 nop
    ld a,(bc)
    ld c,a
    ld c,a
    ld h,l
    nop
    nop
    ld a,(de)
    adc a,a
    sbc a,d
    ld a,(bc)
    nop
    nop
    nop
    dec h
    djnz lab85F8
    nop
    nop
    nop
    nop
    ld a,(bc)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab85E1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab85EB nop
    nop
    nop
    nop
    nop
    nop
    nop
lab85F2 nop
    nop
    nop
    nop
    nop
    nop
lab85F8 nop
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
    nop
    nop
    nop
    dec b
    ld a,(bc)
    nop
    nop
    nop
    nop
    dec h
    nop
    rrca 
    ld a,(de)
    nop
    nop
    dec h
    ld a,(de)
    ld a,(bc)
    rrca 
    ld a,(bc)
    jr nz,lab8645
    adc a,a
    rrca 
    jr nc,lab8624
lab8624 nop
    dec b
    jr nc,lab85C2
    ld a,(de)
    ld a,(bc)
    adc a,d
    jr nc,lab8652
    ld h,l
    ld a,(de)
    djnz lab8635+1
    jr nz,lab8658
    ld c,a
    ld c,a
lab8635 jr nz,lab8637
lab8637 adc a,a
    ld a,(de)
    ld a,(de)
    ld a,(de)
    djnz lab863D
lab863D ld h,l
    rrca 
    adc a,a
    adc a,a
    nop
    nop
    ld c,a
    rrca 
lab8645 jr nc,lab85E1
    nop
    nop
    dec h
    jr nc,lab86B1
    dec h
    ld a,(bc)
    ld a,(bc)
    rrca 
    ld a,(de)
    ld c,a
lab8652 ld a,(de)
    djnz lab8664+1
    dec h
    ld c,a
    ld c,a
lab8658 ld h,l
    ld a,(bc)
    jr nz,lab85EB
    ld a,(de)
    ld h,l
    jr nc,lab8670
    nop
    jr nc,lab85F2
    rrca 
lab8664 djnz lab8666
lab8666 nop
    nop
    ld a,(de)
    djnz lab866B
lab866B nop
    nop
    nop
    nop
    nop
lab8670 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8678 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr z,lab86EE
    ld l,h
    ld l,h
    ld l,h
    ld l,h
    jr z,lab8688
lab8688 jr lab86C1+1
    jr lab86A4
    jr lab86A6
    inc a
    nop
    ld e,h
    adc a,#4e
    inc e
    jr nc,lab869C
    ld a,(hl)
    nop
    ld l,h
    add a,#6
    inc e
lab869C ld b,#c6
    ld l,h
    nop
    inc c
    inc c
    inc l
    ld c,h
lab86A4 xor #c
lab86A6 ld e,#0
    cp #fc
    add a,b
    call pe,labC606
    call pe,lab3400
lab86B1 ld h,d
    ld h,b
    ld l,h
    ld h,(hl)
    ld h,(hl)
    inc (hl)
    nop
    cp #f8
    add a,(hl)
    inc e
    jr c,lab86FA
    jr lab86C0
lab86C0 ld l,h
lab86C1 add a,#c6
    ld l,h
    add a,#c6
    ld l,h
    nop
    inc l
    ld h,(hl)
    ld h,(hl)
    ld (hl),#6
    ld b,(hl)
    inc l
    nop
    nop
    nop
    nop
    nop
    nop
    jr lab86EF
    nop
    ld l,h
    sbc a,(hl)
    cp (hl)
    cp (hl)
    ld e,h
lab86DD jr c,lab86DF
lab86DF nop
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
lab86EE nop
lab86EF nop
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
lab86FA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ccf 
    nop
    dec d
    ccf 
    ld hl,(lab3EFF+1)
    ld hl,(lab0015)
    nop
    nop
    nop
    jp lab82C3
    call z,labCCCC
    ccf 
    call z,lab9DCC
    call z,lab88CC
    nop
    nop
    nop
    sub (hl)
    inc a
    ld l,c
    call z,labCCCC
    call z,labCCCC
    sbc a,l
    call z,lab883F
    nop
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    call z,labCCCC
    sbc a,l
    call z,lab6ECB+1
    ld l,(hl)
    sbc a,l
    adc a,b
    nop
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    sbc a,l
    call z,lab3F9C+1
    call z,lab3FCA+2
    call z,lab886E
    nop
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    call z,lab3FCA+2
    sbc a,l
    call z,lab6E9D
    ld l,(hl)
    call z,lab0088
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    sbc a,l
    call z,lab3F9C+1
    call z,lab3F9C+1
    call z,lab886E
    nop
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    call z,lab3FCA+2
    ld l,(hl)
    ld l,(hl)
    sbc a,l
    ld l,(hl)
    ld l,(hl)
    call z,lab0088
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    sbc a,l
    call z,lab3F9C+1
    call z,lab6ECB+1
    ld l,(hl)
    call z,lab006E
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    call z,lab9DCC
    ld l,(hl)
    ld l,(hl)
    call z,lab6E9D
    call z,lab00CC
    nop
    jp lab3C96
    ld l,c
    call z,lab9DCC
    ccf 
    call z,lab6ECB+1
    ld l,(hl)
    call z,lab006E
    nop
    jp lab3C96
    ld l,c
    call z,lab3F9C+1
    ld l,(hl)
    sbc a,l
lab87B7 ccf 
    ccf 
    call z,lab6E3E+1
    nop
    nop
    jp labC3C3
    jp labCCCC
    ccf 
    sbc a,l
    call z,lab6E3E+1
    ld l,(hl)
    sbc a,l
    sbc a,l
    nop
    nop
    jp lab3C3C
    jp labCCCC
    call z,labCC9D
    call z,lab6ECB+1
    call z,lab00CC
    nop
    sub (hl)
    inc bc
    xor c
    jp labCC9D
    call z,labCC9D
    call z,lab6ECB+1
    call z,lab00CC
    nop
    add a,e
    inc bc
    xor c
    jp labCCCC
    call z,labCC9D
    call z,lab6ECB+1
    call z,lab00CC
    nop
    add a,e
    ld d,(hl)
    inc bc
    jp labCC9D
    call z,labCC9D
    call z,lab6ECB+1
    call z,lab00CC
    nop
    add a,e
    ld d,(hl)
    inc bc
    ld l,c
    call z,labCCCC
    sbc a,l
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
    sub (hl)
    inc a
    inc a
    ld l,c
    sbc a,l
    call z,lab9DCC
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
    sub (hl)
    inc a
    inc a
    ld l,c
    call z,labCCCC
    sbc a,l
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
    sub (hl)
lab883F inc a
    inc a
    ld l,c
    sbc a,l
    call z,lab9DCC
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
    sub (hl)
    inc a
    inc a
    ld l,c
    call z,labCCCC
    sbc a,l
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
    sub (hl)
    ld l,c
    jp lab9D69
    call z,lab9DCC
    call z,labCCCC
    ld l,(hl)
    call z,lab00CC
    nop
lab886E sub (hl)
    sub (hl)
    inc a
    add a,#cc
    ld c,(hl)
    call z,lab4E9D
    call z,lab8DCC
    call z,lab00CC
    nop
    ld b,c
    inc a
    inc a
    ld l,c
    call z,labCCCE
    call z,labCCCE
    call z,labCCCD
    adc a,b
    nop
    nop
    ld b,c
    ld l,b
    ret nz
    inc a
    jp labC3CB
    jp labC3CB
    jp labC3C7
lab889B jp data0000
    ld b,c
    pop bc
    inc a
    sub h
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
lab88AA inc a
    ld l,b
    nop
    nop
    ld b,b
    srl h
    jp z,labC0C0
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    rst 8
lab88C0 rst 0
    adc a,d
    nop
    nop
    nop
    ld b,l
    set 1,a
    ld b,l
    set 1,a
    nop
lab88CC nop
    nop
    nop
    ld b,l
    rst 8
    nop
    nop
    nop
    nop
    nop
    rst 8
    adc a,d
lab88D8 nop
    rst 8
    adc a,d
    nop
lab88DC nop
lab88DD nop
    nop
    nop
    nop
    nop
    nop
    nop
lab88E4 nop
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
    nop
    nop
    nop
    inc d
    jp data0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab2896
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab2896
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc a
    inc a
    add a,d
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,c
    pop bc
    jp lab8082
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab0F68
    nop
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,c
    jp labF379
    nop
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    dec d
    sub (hl)
    di
    call z,lab1400
    ld b,c
    nop
    nop
    nop
    nop
    nop
    ld c,a
    out (#e6),a
    sub (hl)
    add a,d
    inc d
    sub (hl)
    nop
    nop
    nop
    nop
    jp labF3C7
    sbc a,h
    sub (hl)
    rst 0
    sub h
    sub (hl)
    inc bc
    nop
    nop
    jp labC7C3
    sub (hl)
    jp nz,labD39E
    di
    ex (sp),hl
    inc bc
    nop
    nop
    sub (hl)
    inc a
    rrca 
    res 2,(hl)
    rst 8
    call nz,labE29C
    add a,b
    nop
    inc d
    inc a
    ld l,l
    ld c,a
    ld l,a
    inc a
    sub (hl)
    pop bc
    pop bc
    jp nz,lab00C3
    inc d
    inc a
    adc a,a
    rst 8
    sbc a,a
    pop bc
    ld l,b
    pop bc
    sub (hl)
    sub h
    inc a
    add a,d
    nop
    ld l,l
    adc a,a
    ld sp,labD11F
    jp po,lab3CC1
    ret nz
    sbc a,(hl)
    jr z,lab89A9
lab89A9 rst 8
    dec b
    ld sp,labF335
    or (hl)
    ld l,c
    ld l,b
    inc a
    push bc
    adc a,d
    nop
    rst 8
    dec l
    ld h,l
    ld c,d
    di
    ex (sp),hl
    inc d
    sbc a,(hl)
    inc a
    ld l,l
    adc a,d
    nop
    rst 8
    jr z,lab89D3
    ld l,d
    di
    ld l,c
    ld b,l
    sbc a,(hl)
    inc a
    ld l,l
    adc a,d
    nop
    rst 8
    inc a
    inc d
    jp z,labE2DB
lab89D3 ld b,l
    srl h
    ld l,l
    adc a,d
    nop
    ld b,l
    sbc a,(hl)
    ld l,l
    adc a,d
    rst 8
    nop
    nop
    rst 8
    inc a
    rst 8
    nop
    nop
    ld b,l
    rst 8
    rst 8
    adc a,d
    ld b,l
    nop
    nop
    rst 8
    rst 8
    rst 8
    nop
    nop
    nop
    rst 8
    rst 8
    nop
    nop
    nop
    nop
    ld b,l
    rst 8
    adc a,d
lab89FB nop
lab89FC nop
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
    nop
    dec d
    ld hl,(lab3EFF+1)
    ccf 
    nop
    dec d
    ccf 
    nop
    ld hl,(data0000)
    nop
    ld b,c
    jp lab44C2+1
    call z,lab9DCC
    ld l,(hl)
    call z,lab6ECB+1
    call z,lab00CC
    nop
    nop
    ld b,c
    inc a
    inc a
    add a,#cc
    call z,labCCCC
    call z,lab6ECB+1
    sbc a,l
    ld l,(hl)
    nop
    nop
    nop
    jp lab3C3C
    add a,#cc
    call z,lab6ECB+1
    call z,lab9D9D
    call z,lab006E
    nop
    nop
    jp lab3C3C
    add a,#6e
    call z,lab6E3E+1
    call z,lab6E9D
    sbc a,l
    call z,data0000
    nop
    jp lab3C3C
    add a,#cc
    sbc a,l
    ld l,(hl)
    ld l,(hl)
    call z,lab9D3F
    call z,lab00CC
    nop
    nop
    jp lab3C3C
    add a,#6e
    call z,lab6E3E+1
    call z,lab6E3E+1
    sbc a,l
    call z,data0000
    nop
    jp lab3C3C
    add a,#cc
    sbc a,l
    ccf 
    sbc a,l
    call z,lab9D3F
    call z,lab00CC
    nop
    nop
    jp lab3C3C
    add a,#6e
    call z,lab6E3E+1
    call z,lab9D9D
    call z,lab889B+2
    nop
    nop
    jp lab3C3C
    add a,#cc
    call z,lab9D3F
    call z,lab3FCA+2
    call z,lab88CC
    nop
    ld b,c
    jp lab3C3C
    add a,#cc
    call z,lab6E3E+1
    call z,lab9D9D
    call z,lab889B+2
    nop
    ld b,c
lab8ACD jp lab3C3C
    add a,#cc
    ccf 
    ccf 
    call z,lab3F40-1
    ld l,(hl)
    sbc a,l
    ccf 
    adc a,b
    nop
    ld b,c
    jp labC3C3
    add a,#cc
    sbc a,l
    ld l,(hl)
    ld l,(hl)
    sbc a,l
    ccf 
    sbc a,l
    call z,lab2A6E
    nop
    ld b,c
    sub (hl)
    inc a
    ld l,c
    add a,#cc
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    add hl,hl
    ld d,(hl)
    ld b,e
    add a,#6e
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc bc
    ld d,(hl)
    ld b,e
    add a,#cc
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc bc
    xor c
    ld b,e
    add a,#6e
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc bc
    xor c
    ld d,#c6
    call z,labCCCC
    ld l,(hl)
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc a
    inc a
    inc a
    add a,#6e
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc a
    inc a
    inc a
    add a,#cc
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc a
    inc a
    inc a
    add a,#6e
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc a
    inc a
    inc a
    add a,#cc
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    inc a
    jp labC696
    ld l,(hl)
    call z,lab6ECB+1
    call z,lab9DCC
    call z,lab88CC
    nop
    ld b,c
    ld l,c
    inc a
    ld l,c
    call z,labCC8D
    call z,labCC2F
    call z,lab4ECC
    call z,lab0088
    nop
    sub (hl)
    inc a
    inc a
    add a,#cd
    call z,labCDCC
    call z,labCCCC
    adc a,#cc
    nop
    nop
    nop
    sub (hl)
    ret nz
    sub h
    ld l,c
    rst 0
    jp labC7C3
    jp labC3C3
    set 0,e
    add a,d
    nop
    nop
    jp nz,lab6896
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    add a,b
    nop
    nop
    push bc
    sub (hl)
    ld l,l
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ld b,l
    set 1,a
    nop
    nop
    nop
    nop
    rst 8
    rst 0
    adc a,d
    rst 8
    rst 0
    adc a,d
    nop
    nop
    nop
    nop
    rst 8
    adc a,d
    nop
    nop
lab8BF2 nop
    nop
    ld b,l
    rst 8
    nop
    ld b,l
    rst 8
lab8BF9 nop
    nop
lab8BFB nop
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
    ld l,c
    add a,d
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,c
    jp lab003C
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,c
    jp lab003C
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc d
    inc a
    ld l,c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp nz,labC3C3
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,c
    sub (hl)
    add a,l
    ld a,(bc)
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp labF396
    and d
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld l,e
    ld a,c
    and #88
    nop
    jr z,lab8BF2
    nop
    nop
    nop
    nop
    dec b
    set 6,e
    ret 
    ld l,c
    nop
    ld l,c
    jr z,lab8C7D
lab8C7D nop
    nop
    ld b,c
    jp labE6D9+2
    ld l,c
    ld l,c
    jp z,lab2969
    ld (bc),a
    nop
    ld b,c
    jp labCBC3
    ld l,c
    push bc
    ld l,c
    di
    di
    add a,e
    ld (bc),a
    nop
    ld b,c
    inc a
    dec l
    ld c,a
    jp labCA6D
    call z,labC079
    nop
    nop
    inc a
    inc a
    adc a,a
    sbc a,a
    sbc a,(hl)
    ld l,c
    ld l,b
    jp nz,labC1C3
    add a,d
    nop
    inc a
    ld l,l
    ld c,a
    rst 8
    ld l,d
    sub (hl)
    ret nz
    jp lab3C68
    ld l,c
    nop
    inc d
    rst 8
    ld a,(de)
    daa
    ld l,d
    di
    ret nz
    sub (hl)
    ld l,b
    push bc
    inc a
    nop
    ld b,l
    adc a,d
    ld a,(de)
    ld (labF37B),a
    inc a
    sub (hl)
    sub h
    ld l,b
    rst 8
    nop
    ld b,l
    sbc a,(hl)
    ld a,(de)
    adc a,a
    pop de
    di
    add a,d
    ld l,l
    inc a
    inc a
    rst 8
    nop
    ld b,l
    sbc a,(hl)
    dec b
    rra 
    pop de
    or (hl)
    add a,d
    rst 8
    inc a
    inc a
    rst 8
    nop
    ld b,l
    sbc a,(hl)
    jr z,lab8D59+2
    push bc
    di
    add a,b
    rst 8
    sub (hl)
    inc a
    rst 8
    nop
    nop
    rst 8
    inc a
    rst 8
    ld b,l
    adc a,d
    nop
    ld b,l
    sbc a,(hl)
    ld l,l
    adc a,d
    nop
    nop
    rst 8
    rst 8
    rst 8
    nop
    adc a,d
    nop
    ld b,l
    rst 8
    rst 8
    adc a,d
    nop
    nop
    ld b,l
    rst 8
    adc a,d
    nop
    nop
    nop
    nop
    rst 8
    rst 8
lab8D18 nop
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xor d
    nop
    ld d,l
    call z,labCC00
    nop
    call pe,labEC00
    nop
    nop
    ld d,l
    xor b
    ld d,l
    ret z
    nop
    ret z
    nop
    call po,labC000
    nop
    ld b,b
    xor d
    add a,b
    nop
    call z,labD000
    nop
    call p,labF400
    nop
    add a,b
    nop
    xor b
    nop
    ret c
    nop
lab8D59 call z,labDC00
    nop
    ret z
lab8D5E nop
    ld d,b
    nop
    call po,labC400
    nop
    call po,labCC00
    nop
    call nz,labE7FF+1
    nop
    call c,labC7FF+1
    nop
    ret z
    nop
    call nz,labD400
    nop
    call z,labC7FF+1
    nop
    call z,labFC00
    nop
    call z,labF400
    nop
    call c,labD800
    nop
    call z,labE400
    nop
    call nz,labDC00
    nop
    ret nz
    nop
    ret nz
    nop
    ret c
    nop
    call nz,labC7FF+1
    nop
    call po,labD000
    nop
    call nz,labCC00
    ld d,l
    ret po
    nop
    call z,labD800
    nop
    ret z
    xor d
    ret z
    xor d
    call nz,labD800
    nop
    ret z
    nop
    call pe,labD0FF
    ld d,l
    ret nc
    ld d,l
    adc a,b
    xor d
    ret nz
    nop
    call z,labD000
    ld d,l
    ld b,h
    rst 56
    ld b,h
    rst 56
    call nz,labD8FF
    nop
    call m,lab00FF
    rst 56
    adc a,b
lab8DCC rst 56
    adc a,b
    rst 56
    ld b,b
    rst 56
    ld c,(hl)
    ld d,l
    rst 8
    nop
    adc a,b
    rst 56
    nop
    rst 56
    rst 8
    xor d
    nop
    ld d,l
    ld a,(bc)
    ld d,l
    ld c,a
    xor d
    dec b
    xor d
    adc a,d
lab8DE4 nop
    ld a,(bc)
    nop
    ld b,l
    xor d
    ld b,l
    rst 56
    adc a,a
    nop
    rst 8
    nop
    dec b
lab8DF0 rst 56
    nop
    rst 56
    adc a,a
lab8DF4 nop
    rst 8
    nop
    nop
lab8DF8 rst 56
    nop
    rst 56
    adc a,a
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    xor d
    adc a,a
    nop
    rst 8
    nop
    nop
    xor d
    dec b
    xor d
    rst 8
    nop
    ld c,a
    ld d,l
    ld b,l
    xor d
    ld b,l
    xor d
    rst 8
    ld d,l
    ld a,(bc)
    ld d,l
    ld b,l
    nop
    dec b
    nop
    adc a,d
    nop
    ld a,(bc)
    nop
    rst 8
    nop
    adc a,a
    xor d
    adc a,a
    nop
    ld c,a
    xor d
    rst 8
    xor d
    ld b,l
    rst 56
    rst 8
    rst 56
    ld b,l
    rst 56
    ld b,l
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    ld b,h
    xor d
    ld d,b
    nop
    nop
    rst 56
    nop
    rst 56
    ld d,b
    nop
    ret c
    nop
    nop
    rst 56
    nop
    rst 56
    ret p
    nop
    ret c
    nop
    nop
    rst 56
    nop
    rst 56
    ret c
    nop
    ret p
    nop
    nop
    xor d
    nop
    xor d
    ret c
    nop
    ret p
    nop
    ld b,h
    xor d
    ld b,h
    xor d
    ret p
    nop
    ret m
    nop
    ld d,b
    nop
    ld b,h
    nop
    ret p
    nop
    ret c
    nop
    ret c
    nop
    call p,labF400
    nop
    ret p
    nop
    call z,labDCAA
    xor d
    ret c
    nop
    call p,lab5000
    xor d
    ld d,b
    xor d
    ret p
    nop
    ret p
    nop
    ld b,h
    xor d
    ld d,b
    nop
    ret m
    nop
    ret c
    nop
    ld d,b
    nop
    call po,labF000
    nop
    call m,labD800
    nop
    ret c
    nop
    ret c
    nop
    ret p
    nop
    call po,labE400
    nop
    call p,labF000
    nop
    ret c
    nop
    ret p
    nop
    ret c
    nop
    ret p
    nop
    call po,labE400
    nop
    call p,labF800
    nop
    call pe,labDCAA
    nop
    ret p
    nop
    ret p
    nop
    ld d,b
    xor d
    call c,labD8AA
    nop
    ret m
    nop
    ld b,h
    ld d,l
    ld b,h
    ld d,l
    ret p
    nop
    call p,lab88AA
    rst 56
    adc a,b
    rst 56
    ret c
    rst 56
    ld d,b
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    adc a,b
    ld d,l
    nop
    rst 56
    nop
    rst 56
    and b
    nop
    and b
    nop
    nop
    rst 56
    nop
    rst 56
    call po,labF000
    nop
    nop
    rst 56
    nop
    rst 56
lab8EFF call po,labE400
    nop
    nop
    rst 56
    nop
    ld d,l
    ret p
    nop
    call po,data0000
    ld d,l
    adc a,b
    ld d,l
lab8F0F ret p
    nop
    ret p
    nop
    adc a,b
    ld d,l
    and b
    nop
    call p,labF000
    nop
    adc a,b
    nop
    call po,labE400
    nop
    ret m
    nop
    ret m
    nop
lab8F25 call z,labF055
    nop
    call po,labEC00
    ld d,l
    and b
    ld d,l
    ret m
    nop
    ret p
    nop
    and b
    ld d,l
    adc a,b
    ld d,l
    ret p
    nop
    call p,labA000
    nop
    and b
    nop
    call po,labF000
    nop
    ret c
    nop
    call po,labFC00
    nop
    call po,labE400
    nop
    ret c
    nop
    ret p
    nop
lab8F51 ret m
    nop
    ret c
    nop
    call po,labF000
    nop
lab8F59 call po,labF000
    nop
    ret c
    nop
    ret p
    nop
    ret m
    nop
    ret c
    nop
    call c,labF455
    nop
    ret p
    nop
    call pe,labA000
    ld d,l
    ret p
    nop
    call po,labEC00
    ld d,l
    adc a,b
    xor d
    call p,labF000
    nop
    adc a,b
    xor d
    ld b,h
    rst 56
    ret m
    ld d,l
    call po,lab44FF
    rst 56
    nop
    rst 56
    and b
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    dec b
    xor d
    dec b
    xor d
    nop
    rst 56
    nop
    rst 56
    dec b
    xor d
    dec b
    xor d
    nop
    rst 56
    nop
    rst 56
    dec b
    xor d
lab8FA5 djnz lab8F51
    nop
    rst 56
    nop
    rst 56
    dec b
    xor d
    djnz lab8F59
    nop
lab8FB0 rst 56
    nop
    rst 56
    dec b
    nop
    dec b
    nop
    nop
    rst 56
    nop
    rst 56
    ld a,(de)
    nop
    rrca 
    nop
    nop
    rst 56
    nop
    rst 56
    ld a,(de)
    nop
    rrca 
    nop
    nop
    rst 56
    nop
    rst 56
    ld a,(de)
    nop
    rrca 
    nop
lab8FCF nop
    rst 56
    nop
    xor d
    ld a,(de)
    nop
    ld a,(de)
    nop
    nop
    xor d
    dec b
    xor d
    dec h
    nop
    ld a,(de)
    nop
    dec b
    xor d
    dec b
    xor d
    dec h
    nop
    ld a,(de)
    nop
    dec b
    nop
    dec b
    nop
    dec h
    nop
    ld a,(de)
    nop
    rrca 
    nop
    rrca 
    xor d
    dec h
    nop
    ld a,(de)
    nop
    ld a,(de)
    rst 56
    dec b
    rst 56
    dec h
    rst 56
    rst 8
    rst 56
    nop
lab9000 rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    adc a,d
    nop
    nop
    rst 56
    nop
    rst 56
    adc a,d
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    ld c,a
    nop
    nop
    ld d,l
    nop
    ld d,l
    rst 8
    nop
    adc a,a
    nop
    adc a,d
    ld d,l
    adc a,d
    ld d,l
    ld c,a
    nop
    adc a,a
    nop
    adc a,d
    ld d,l
    adc a,d
    nop
    ld c,a
    nop
    adc a,a
    nop
    adc a,d
    nop
    rst 8
    nop
    ld c,a
    nop
    adc a,a
    nop
    rst 8
    ld d,l
    rst 8
    rst 56
    ld c,a
    nop
    rrca 
    rst 56
    adc a,d
    rst 56
    nop
    rst 56
    rst 8
    rst 56
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
    ld d,b
    and b
    nop
    nop
    ld b,h
    ret p
    nop
    nop
    nop
    nop
    nop
    ld d,b
    ret c
    ret c
    and b
    ld d,b
    ret c
    ret c
    nop
    nop
    nop
    nop
    nop
    ret p
    call po,labECF0
    ret p
    ret m
    ret p
    nop
    nop
    nop
    nop
    ld d,b
    call c,labF8F0
    ret c
    call c,labF0F0
    nop
    nop
    nop
    nop
    ld b,h
    call po,labF0F0
    ret p
    ret p
    ret p
    ret p
    nop
    nop
    nop
    nop
    ret p
    ret m
    ret p
    ret p
    ret m
    call p,labF0F4
    nop
    nop
    ld d,b
    call po,labF0D8
    call po,labDCFC
    ret c
    ret m
    ret p
    nop
    nop
    call po,labF4F0
    ret c
    ret c
    ret p
    ret p
    ret p
    ret p
    ret p
    nop
    ld d,b
    ret p
    ret p
    call c,labF4F8
    call p,labF0F8
    call p,lab00F0
    ld d,b
    ret c
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    nop
    ret c
    call m,labF0F8
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    ret p
    nop
    call m,labF0F0
    ret p
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    ret c
    ret c
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call m,labFCFC
    call m,labF8F0
    call m,labFCFC
    ret m
    ret p
    call p,labFCF4
    call m,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    call p,labF0F0
    ret p
    call p,labF4F4
    ret p
    ret m
    ret p
    ret p
    ret m
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret p
    ret m
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    call p,labF4F0
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    adc a,b
    nop
    nop
    ld d,b
    and b
    nop
    nop
    nop
    nop
    nop
    nop
    call po,labA0E4
    ld d,b
    call po,labA0E4
    nop
    nop
    nop
    nop
    nop
    ret p
    call p,labDCF0
    ret p
    ret c
    ret p
    nop
    nop
    nop
    nop
    nop
    ret p
    ret p
    call pe,labF4E4
    ret p
    call pe,lab00A0
    nop
    nop
    nop
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret c
    adc a,b
    nop
    nop
    nop
    nop
    ret p
    ret m
    ret m
    call p,labF0F0
    call p,lab00F0
    nop
    nop
    nop
    ret p
    call p,labECE4
    call m,labF0D8
    call po,labA0D8
    nop
    nop
    ret p
    ret p
    ret p
    ret p
    ret p
    call po,labF8E4
    ret p
    ret c
    nop
    nop
    ret p
    ret m
    ret p
    call p,labF8F8
    call p,labF0EC
    ret p
    and b
    nop
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call po,lab00A0
    ret p
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    call p,labE4FC
    nop
    ret p
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    ret p
    ret p
    ret p
    call m,labF000
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call po,labF0E4
    call p,labFCFC
    call m,labF0F4
    call m,labFCFC
    call m,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call m,labF8FC
    ret m
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call p,labF8F0
    ret m
    ret m
    ret p
    ret p
    ret p
    ret m
    ret p
    call p,labF0F0
    ret p
    ret m
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret p
    ret m
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    call p,labF0F0
    ret p
    ret p
    ret m
    ret p
    ret m
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
lab92B6 ret p
    ret p
    ret p
    call m,labF0F8
    call m,labFCF4
    ret m
    call pe,labF8F0
    ret c
    ret c
    ret p
    ret p
    call m,labECFC
    call p,labD8F0
    call p,labECE4
    call po,labE4CC
    ret p
    ret p
    call pe,labF0E4
    ret c
    call po,lab88E4
    ret c
    ret c
    ret p
    call c,labCCD8
    ret p
    ret c
    call z,labECF4
    xor b
    ld e,d
    rrca 
    ret c
    call c,labCCFC
    call z,labF0D8
    call po,lab8D5E
    ld c,(hl)
    dec h
    call z,labECD8
    call z,labEC98
    call z,lab4EF4
    sbc a,l
lab9300 rrca 
    ld c,a
    dec h
    ld h,h
    sbc a,b
    cp b
    sbc a,b
    call z,labE4DC
    rra 
    rst 8
    ld a,(de)
    rst 8
    sbc a,b
    sbc a,d
    sbc a,b
    sbc a,b
    sbc a,b
    call z,lab6EBD
    rrca 
    rst 8
    dec h
    ld h,l
    adc a,a
    sbc a,d
    jr nc,lab92B6
    adc a,l
    call lab0F30
    ld c,a
    ld c,a
    jr nc,lab9375
    adc a,#9a
    jr nc,lab935A
    dec h
    ld c,a
    jr nc,lab9353
    rrca 
    ld c,a
    dec h
    rrca 
    rst 8
    rst 8
    jr nc,lab9366
    jr nc,lab9347
    sbc a,d
    ld a,(de)
    ld c,a
    ld c,a
    jr nc,lab93A3
    adc a,#cf
    jr nc,lab9372
    jr nc,lab9353
    ld a,(de)
    dec h
    rrca 
lab9347 adc a,a
    dec h
    rrca 
    rst 8
    rst 8
    jr nc,lab937E
    jr nc,lab935F
    rst 8
    ld a,(de)
    rrca 
lab9353 ld c,a
    ld a,(de)
    ld h,l
    ld c,a
    rst 8
    jr nc,lab938A
lab935A jr nc,lab9381
    ld c,a
    dec h
    dec h
lab935F adc a,a
    ld a,(de)
    ld a,(de)
    rst 8
    rst 8
    jr nc,lab9396
lab9366 jr nc,lab9377
    rst 8
    sbc a,d
    rrca 
    ld c,a
    ld a,(de)
    jr nc,lab93BE
    rst 8
    jr nc,lab938C
lab9372 jr nc,lab9399
    ld c,a
lab9375 sbc a,d
    dec h
lab9377 adc a,a
    ld c,a
    ld a,(de)
    dec h
    rst 8
    jr nc,lab9398
lab937E jr nc,lab938F
    ld c,a
lab9381 sbc a,d
    rrca 
    ld c,a
    adc a,a
    ld h,l
    ld c,a
    rst 8
    jr nc,lab93A4
lab938A jr nc,lab93B1
lab938C ld c,a
    sbc a,d
    dec h
lab938F rrca 
    ld c,a
    rrca 
    adc a,a
    rst 8
    jr nc,lab93BB
lab9396 jr nc,lab93B2
lab9398 rst 8
lab9399 sbc a,d
    rrca 
    ld c,a
    adc a,a
    dec h
    ld c,a
    rst 8
    jr nc,lab93C7
    ld a,(de)
lab93A3 dec h
lab93A4 ld c,a
    rst 8
    dec h
    rrca 
    ld c,a
    ld a,(de)
    adc a,a
    rst 8
    sbc a,d
    dec h
    ld a,(de)
    jr nc,lab93C0
lab93B1 rst 8
lab93B2 ld a,(de)
    ld c,a
    adc a,a
    adc a,a
    ld c,a
    rst 8
    sbc a,d
    dec h
    rrca 
lab93BB dec h
    ld c,a
    rst 8
lab93BE dec h
    rrca 
lab93C0 ld c,a
    sbc a,d
    adc a,a
    rst 8
    sbc a,d
    jr nc,lab93E1
lab93C7 jr nc,lab93D8
    rst 8
    ld a,(de)
    ld c,a
    adc a,a
    sbc a,d
    rrca 
    rst 8
    sbc a,d
    jr nc,lab93E2
    dec h
    ld c,a
    rst 8
    dec h
    rrca 
lab93D8 ld c,a
    sbc a,d
    dec h
    ld c,a
    sbc a,d
    jr nc,lab93EE
    jr nc,lab93F0
lab93E1 rst 8
lab93E2 jr nc,lab9433
    adc a,a
    rst 8
    dec h
    ld c,a
    sbc a,d
    jr nc,lab93FA
    dec h
    ld c,a
    rst 8
lab93EE adc a,a
    rrca 
lab93F0 ld c,a
    rst 8
    rrca 
    rst 8
    rst 8
    jr nc,lab9406
    jr nc,lab9408
    rst 8
lab93FA sbc a,d
    rrca 
    rrca 
    rst 8
    dec h
    ld c,a
lab9400 rst 8
    jr nc,lab941D
    ld a,(de)
    ld c,a
    ld c,a
lab9406 adc a,a
    rrca 
lab9408 ld c,a
    rst 8
    rrca 
    rst 8
    rst 8
    jr nc,lab941E
    dec h
    rrca 
    rst 8
    sbc a,d
    rrca 
    rrca 
    rst 8
    dec h
    ld c,a
    rst 8
    jr nc,lab942A
    jr nc,lab9442
lab941D ld c,a
lab941E adc a,a
    dec h
    ld c,a
    rst 8
    rrca 
    adc a,a
    rst 8
    jr nc,lab9441
    ld a,(de)
    rrca 
    rst 8
lab942A sbc a,d
    rrca 
    rrca 
    rst 8
    jr nc,lab947F
    rst 8
    adc a,a
    rrca 
lab9433 dec h
    ld h,l
    ld c,a
    rst 8
    dec h
    ld c,a
    adc a,a
    ld a,(de)
    rrca 
    rst 8
    adc a,a
    rrca 
    dec h
    rrca 
lab9441 rst 8
lab9442 rst 8
    rrca 
    rrca 
    adc a,a
    dec h
    ld c,a
    ld c,a
    adc a,a
    ld a,(de)
    ld a,(de)
    ld c,a
    ld c,a
    rst 8
    dec h
    rst 8
    ld a,(de)
    rrca 
    rrca 
    rst 8
    rst 8
    rrca 
    dec h
    rrca 
    adc a,a
    rst 8
    rrca 
    jr nc,lab946D
    dec h
    ld c,a
    ld c,a
    rst 8
    ld a,(de)
    ld a,(de)
    ld c,a
    ld c,a
    rst 8
    dec h
    sbc a,d
    ld a,(de)
    rrca 
    adc a,a
    rst 8
lab946D rst 8
    rrca 
    jr nc,lab9400
    adc a,a
    rst 8
    rrca 
    dec b
    adc a,a
    ld c,a
    ld c,a
    ld c,a
    rst 8
    sbc a,d
    rrca 
    ld h,l
    ld c,a
    rst 8
lab947F nop
    nop
    dec b
    adc a,a
    adc a,a
    rst 8
    rst 8
    nop
    ld a,(de)
    adc a,a
    adc a,a
    rst 8
    nop
    nop
    nop
    ld b,l
    rst 8
    rst 8
    nop
    nop
    nop
    rst 8
    rst 8
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld b,b
    nop
    sub (hl)
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    add a,b
    nop
    ld l,c
    nop
    inc a
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    inc d
    nop
    inc a
    nop
    sub (hl)
    nop
    ld l,b
    nop
    nop
    ld d,l
    nop
    ld d,l
    ld l,b
    nop
    ld l,c
    nop
    inc a
    nop
    inc a
    nop
    nop
    xor d
    nop
    xor d
    sub (hl)
    nop
    inc a
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    add a,b
    ld d,l
    add a,b
    nop
    ld l,c
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld b,b
    nop
    ld b,b
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    add a,b
    nop
    ld l,b
    nop
    ld l,c
    nop
    sub h
    nop
    inc a
    nop
    inc a
    nop
    pop bc
    nop
    pop bc
    nop
    inc a
    nop
    pop bc
    nop
    inc a
    nop
    inc a
    nop
    jp nz,lab6800
    nop
    ld l,c
    nop
    pop bc
    nop
    sub (hl)
    nop
    ld l,b
    nop
    sub (hl)
    nop
    jp lab6800
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    jp nz,lab6800
    nop
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    pop bc
    nop
    sub h
    nop
    inc a
    nop
    ret nz
    nop
    sub (hl)
    nop
    ld a,#0
    ld l,c
    nop
    ld l,b
    nop
    jp nz,lab6900
    nop
    inc a
    nop
    ld a,#0
    pop bc
    nop
    sub (hl)
    nop
    ld l,b
    xor d
    jp nz,labB400
    nop
    ld a,#0
    inc a
    nop
    ret nz
    nop
    ret nz
    nop
    inc a
    nop
    ld a,d
    nop
    dec a
    nop
    pop bc
    nop
    jp nz,lab40A9+1
    rst 56
    pop bc
    nop
    jp lab3C00
    nop
    ld l,b
    nop
    ret nz
    ld d,l
    ret nz
    rst 56
    ld l,b
    ld d,l
    jp nc,lab7A00
    nop
    ret nz
    rst 56
    ld b,b
    rst 56
    nop
    rst 56
    ret nz
    rst 56
    pop hl
    rst 56
    jp nz,labC0FF
    rst 56
    add a,b
    rst 56
    nop
    rst 56
    add a,b
    rst 56
    ret nz
    rst 56
    jp nz,lab00FF
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    ld b,c
    nop
    add a,d
    nop
    nop
    rst 56
    nop
    ld d,l
    pop bc
    nop
    jp nz,data0000
    rst 56
    nop
    rst 56
    jp nz,lab9400
    nop
    nop
    ld d,l
    jr z,lab961C
    inc a
    nop
    jp nz,data0000
    rst 56
    nop
    rst 56
    ld b,e
    xor d
    add hl,hl
    nop
    and d
    ld d,l
    and d
    ld d,l
    out (#0),a
    ex (sp),hl
    xor d
    nop
    rst 56
    nop
    rst 56
    ld bc,lab53A9+1
    nop
    jr z,lab95E5
lab95E5 jr z,lab95E7
lab95E7 and e
    nop
    ld d,c
    xor d
    nop
    rst 56
    nop
    rst 56
    ld bc,lab8355
    nop
    ld l,c
    nop
    inc a
    nop
    add a,e
    xor d
    ld bc,lab0055
    rst 56
    nop
    nop
    ld (bc),a
lab9600 rst 56
    jp lab16FD+2
    nop
    ld d,#0
    ld b,c
    rst 56
    ld (bc),a
    rst 56
    nop
    nop
    adc a,e
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,e
    rst 56
    rst 8
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
lab961C rst 56
    nop
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    ld b,c
    nop
    add a,d
    nop
    nop
    rst 56
    nop
    rst 56
    pop bc
    nop
    jp nz,data0000
    xor d
    nop
    xor d
    ld l,b
    nop
    pop bc
    nop
    nop
    rst 56
    nop
    rst 56
    pop bc
    nop
    inc a
    nop
    inc d
    xor d
    ld d,c
    xor d
    ld d,#0
    add a,e
    ld d,l
    nop
    rst 56
    nop
    rst 56
    out (#55),a
    ex (sp),hl
    nop
    ld d,c
    xor d
    inc d
    nop
    and e
    nop
    ld (bc),a
    ld d,l
    nop
    rst 56
    nop
    rst 56
    and d
    ld d,l
    ld d,e
    nop
    inc d
    nop
    sub (hl)
    nop
    ld b,e
    nop
    ld (bc),a
    xor d
    nop
    rst 56
    nop
    rst 56
    ld (bc),a
    xor d
    ld b,e
    ld d,l
    inc a
    nop
    add hl,hl
    nop
    jp lab01FF
    rst 56
    nop
    nop
    nop
    nop
    ld bc,lab82FF
    rst 56
    add hl,hl
    nop
    ld b,a
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,a
    rst 56
    rst 8
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    dec b
    nop
    ld a,(de)
    nop
    nop
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld b,l
    nop
    dec h
    nop
    adc a,a
    nop
    rrca 
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    djnz lab96D1
lab96D1 dec h
    nop
    ld c,a
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    djnz lab96DB
lab96DB nop
    xor d
    nop
    xor d
    rst 8
    nop
    dec h
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    jr nc,lab96EB
lab96EB ld b,l
    xor d
    ld b,l
    nop
    ld a,(de)
    nop
    rrca 
    nop
    adc a,a
    nop
    ld h,l
    nop
    jr nc,lab96F9
lab96F9 rrca 
    nop
    ld b,l
    nop
    sbc a,d
    nop
    ld a,(de)
    nop
    jr nc,lab9703
lab9703 ld h,l
    nop
    rst 8
    nop
    dec h
    nop
    dec h
    nop
    ld c,a
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    rst 8
    ld d,l
    rrca 
    nop
    rrca 
    nop
    ld a,(de)
    nop
    rrca 
    rst 56
    dec h
    rst 56
    dec h
    rst 56
    ld c,a
    rst 56
    adc a,d
    rst 56
    rst 8
    rst 56
    rst 8
    rst 56
    adc a,a
    rst 56
    nop
    xor d
    nop
    nop
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
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
    dec b
    nop
    rrca 
    nop
    dec b
    nop
    rrca 
    nop
    rrca 
    nop
    ld a,(bc)
    nop
    dec h
    nop
    dec h
    nop
    dec h
    nop
    rrca 
    nop
    ld a,(de)
    nop
    ld a,(de)
    nop
    dec h
    nop
    dec h
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    jr nc,lab9767
lab9767 ld h,l
    nop
    rst 8
    nop
    sbc a,d
    nop
    rrca 
    nop
    rst 8
    nop
    sbc a,d
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    rrca 
    nop
    ld c,a
    nop
    rrca 
    nop
    rrca 
    nop
    ld c,a
    nop
    adc a,a
    nop
    sbc a,d
    nop
    ld h,l
    nop
    dec h
    nop
    dec h
    nop
    ld h,l
    nop
    ld h,l
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    ld a,(de)
    nop
    sbc a,d
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    nop
    ld c,a
    nop
    rst 8
    nop
    adc a,a
    nop
    rst 8
    nop
    ld h,l
    nop
    dec h
    nop
    rrca 
    nop
    jr nc,lab97B9
lab97B9 dec h
    nop
    ld h,l
    nop
    jr nc,lab97BF
lab97BF jr nc,lab97C1
lab97C1 jr nc,lab97C3
lab97C3 ld h,l
    nop
    ld a,(de)
    nop
    rrca 
    nop
    ld h,l
    nop
    dec h
    nop
    ld h,l
    nop
    dec h
    nop
    dec h
    nop
    ld c,a
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    nop
    rrca 
    nop
    ld a,(de)
    nop
    rrca 
    nop
    rrca 
    nop
    ld a,(de)
    nop
    dec h
    rst 56
    dec h
    rst 56
    ld c,a
    rst 56
    ld a,(de)
    rst 56
    ld a,(de)
    rst 56
    ld a,(de)
    rst 56
    ld c,a
    rst 56
    rst 8
    rst 56
    rst 8
    rst 56
    sbc a,d
    rst 56
    adc a,a
    rst 56
    sbc a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    rst 8
    nop
    adc a,a
    nop
    rrca 
    nop
    jr nc,lab9839
lab9839 adc a,d
    nop
    nop
    rst 56
    nop
    ld d,l
    jr nz,lab9841
lab9841 jr nc,lab9843
lab9843 jr nc,lab9845
lab9845 adc a,a
    nop
    rrca 
    nop
    adc a,a
    nop
    nop
    ld d,l
    ld a,(bc)
    ld d,l
    rrca 
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    rrca 
    nop
    ld a,(bc)
    ld d,l
    jr nz,lab985F
lab985F ld a,(de)
    nop
    adc a,a
    nop
    jr nc,lab9865
lab9865 jr nc,lab9867
lab9867 adc a,a
    nop
    dec h
    nop
    adc a,d
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    sbc a,d
    nop
    adc a,a
    nop
    rst 8
    nop
    ld c,a
    nop
    rst 8
    nop
    ld c,a
    nop
    rrca 
    ld d,l
    rrca 
    nop
    dec h
    nop
    adc a,a
    ld d,l
    ld h,l
    rst 56
    rrca 
    rst 56
    ld a,(de)
    rst 56
    ld c,a
    rst 56
    adc a,d
    rst 56
    rst 8
    rst 56
    rst 8
    rst 56
    adc a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld d,c
    nop
    nop
    nop
    and d
    nop
    di
    nop
    nop
    nop
    nop
    rst 56
    nop
    xor d
    ld d,c
    nop
    di
    nop
    di
    nop
    or (hl)
    nop
    di
    nop
    di
    nop
    nop
    nop
    ld d,c
    nop
    di
    nop
    di
    nop
    inc a
    nop
    inc a
    nop
    or (hl)
    nop
    di
    nop
    di
    nop
    out (#0),a
    di
    nop
    inc a
    nop
    inc a
    nop
    inc a
    ld d,l
    inc a
    nop
    or (hl)
    nop
    jp labC300
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
lab98EC rst 56
lab98ED jr z,lab98ED+1
    inc a
lab98F0 ld d,l
    sub (hl)
    nop
    jp labC300
    xor d
    sub (hl)
lab98F8 nop
    inc a
    rst 56
    nop
    rst 56
    nop
    rst 56
lab98FF jr z,lab98FF+1
    sub (hl)
    ld d,l
    jp lab41FF
    rst 56
    sub (hl)
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    and d
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    di
    nop
    ld d,c
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    di
    nop
    di
    nop
    and d
    nop
    nop
    ld d,l
    nop
    nop
    ld a,c
    nop
    di
    nop
    di
    nop
    ld d,c
    nop
    nop
    rst 56
    nop
    rst 56
    di
    nop
    di
    nop
    or (hl)
    nop
    ld a,c
    nop
    and d
    nop
    di
    nop
    ld a,c
    nop
    inc a
    nop
    di
    nop
    out (#0),a
    nop
    rst 56
    nop
    rst 56
    jp labE300
    nop
    sub (hl)
    nop
    out (#0),a
    pop bc
    nop
    sub (hl)
    nop
    ld l,b
    nop
    ld l,c
    nop
    sub (hl)
    nop
    jp data0000
    rst 56
    nop
    xor d
    jp labC300
    nop
    sub (hl)
    nop
    sub h
    nop
    ld l,c
    nop
    sub (hl)
    ld d,l
    sub (hl)
    nop
    ld l,b
    nop
    sub (hl)
    nop
    jp data0000
    nop
    ld d,c
    nop
    ex (sp),hl
    nop
    jp labC000
    nop
    ld l,c
    nop
    ld l,c
    rst 56
    add a,d
    rst 56
    sub (hl)
    ld d,l
    ld l,b
    nop
    jp nz,labF300
    nop
    di
    nop
    pop de
    nop
    di
    nop
    sub h
    nop
    ld l,b
    nop
    ld l,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    ld l,b
    ld d,l
    inc a
    nop
    jp po,labC200
    nop
    jp labC100
    nop
    inc a
    nop
    ld l,b
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    inc a
    ld d,l
    sub (hl)
    nop
    jp labC300
    xor d
    jp lab6900
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    sub (hl)
    ld d,l
    jp lab41FF
    rst 56
    jp lab00FF
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld d,c
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    and d
    nop
    di
    nop
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld d,c
    nop
    di
    nop
    di
    nop
    nop
    ld d,l
    nop
    nop
    or (hl)
    nop
    di
    nop
    di
    nop
    nop
    nop
    nop
    rst 56
    nop
    xor d
    ld d,c
    nop
    pop de
    nop
    di
    nop
    inc a
    nop
    and d
    nop
    di
    nop
    inc a
    nop
    or (hl)
    nop
    jp po,labF300
    nop
    nop
    xor d
    ld d,c
    xor d
    di
    nop
    di
    nop
    sub h
    nop
    inc a
    nop
    or (hl)
    nop
    inc a
    nop
    ld l,b
    nop
    sub h
    nop
    or (hl)
    nop
    di
    nop
    ld b,c
    xor d
    ld b,c
    xor d
    out (#0),a
    inc a
    nop
    sub h
    nop
    sub h
lab9A9A nop
    ld l,c
    nop
    inc a
    ld d,l
    sub h
    nop
    ret nz
    nop
    inc a
    nop
    jp lab4100
    nop
    ld b,c
    nop
    jp lab3C00
    nop
    sub h
    nop
    sub h
    nop
    ld l,c
    rst 56
    add a,d
    rst 56
    sub h
    ld d,l
    inc a
    nop
    jp nz,labC300
    nop
    di
    nop
    out (#0),a
    ex (sp),hl
    nop
    ret nz
    nop
    inc a
    nop
    pop bc
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,b
    rst 56
    inc a
    ld d,l
    ld l,b
    nop
    jp po,labC300
    nop
    jp lab9600
    nop
    ld l,b
    nop
    ld l,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    ld l,b
    ld d,l
    sub (hl)
    nop
    jp labC300
    xor d
    sub (hl)
    nop
    ld l,b
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    sub (hl)
    ld d,l
    jp lab41FF
    rst 56
    jp lab00FF
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
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
    ld b,b
    nop
    ret nz
    nop
    ret nz
    nop
    add a,b
    nop
    ld b,b
    nop
    ret nz
    nop
    ret nz
    nop
    add a,b
    nop
    ld b,b
    nop
    ret nz
    nop
    ret nz
    nop
    add a,b
    nop
    ld b,b
    nop
    ret nz
    nop
    ret nz
    nop
    add a,b
    nop
    jp z,lab0F00
    nop
    dec h
    nop
    add a,l
    nop
    ld c,d
    nop
    rrca 
    nop
    dec h
    nop
    add a,l
    nop
    ld c,d
    nop
    rrca 
    nop
    dec h
    nop
    add a,l
    nop
    jp z,lab0F00
    nop
    dec h
    nop
    adc a,a
    nop
    rrca 
    nop
    ld a,(de)
    nop
    dec h
    nop
    ld c,a
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    dec h
    nop
    ld c,a
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    jr nc,lab9BB7
lab9BB7 ld c,a
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    jr nc,lab9BBF
lab9BBF ld c,a
    nop
    ld c,a
    nop
    rrca 
    nop
    rrca 
    nop
    rst 8
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    nop
    rrca 
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    nop
    rrca 
    nop
    adc a,a
    nop
    push bc
    nop
    rst 8
    nop
    rst 8
    nop
    jp z,labC500
    nop
    rst 8
    nop
    rst 8
    nop
    jp z,labC500
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,d
    nop
    push bc
    nop
    rst 8
    nop
    rst 8
    nop
    jp z,labC000
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    adc a,a
    nop
    ld c,a
    nop
    rst 8
    nop
    rrca 
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    nop
    ld c,a
    nop
    adc a,a
    nop
    rrca 
    nop
    rst 8
    nop
    rrca 
    nop
    ld c,a
    nop
    rst 8
    nop
    rrca 
    nop
    rst 8
    nop
    ld a,(de)
    nop
    ld a,(de)
    nop
    dec h
    nop
    rrca 
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    ld a,(de)
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    jr nc,lab9C55
lab9C55 adc a,a
    nop
    ld c,a
    nop
    dec h
    nop
    adc a,a
    nop
    dec h
    nop
    rrca 
    nop
    ld a,(de)
    nop
    dec h
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    rrca 
    nop
    adc a,a
    nop
    rrca 
    nop
    ld h,l
    nop
    rrca 
    nop
    dec h
    nop
    ld c,a
    nop
    jr nc,lab9C79
lab9C79 dec h
    nop
    adc a,a
    nop
    jr nc,lab9C7F
lab9C7F ld c,a
    nop
    ld c,a
    nop
    ld a,(de)
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    ld a,(de)
    nop
    ld a,(de)
    nop
    jr nc,lab9C8F
lab9C8F ld a,(de)
    nop
    ld c,a
    nop
    jr nc,lab9C95
lab9C95 adc a,a
    nop
    rrca 
    nop
    dec h
    nop
    dec h
    nop
    dec h
    nop
    rrca 
    nop
    ld a,(de)
    nop
    dec h
    nop
    sbc a,d
    nop
    ld a,(de)
    nop
    rrca 
    nop
    sbc a,d
    nop
    rrca 
    nop
    ld c,a
    nop
    rrca 
    nop
    rrca 
    nop
    ld c,a
    nop
    ld a,(de)
    nop
    rrca 
    nop
    sbc a,d
    nop
    jr nc,lab9CBF
lab9CBF jr nc,lab9CC1
lab9CC1 ld c,a
    nop
    dec h
    nop
    adc a,a
    nop
    dec h
    nop
    dec h
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    dec h
    nop
    rrca 
    nop
    jr nc,lab9CDB
lab9CDB dec h
    nop
    dec h
    nop
    dec h
    nop
    dec h
    nop
    dec h
    nop
    adc a,a
    nop
    ld c,a
    nop
    rrca 
    nop
    rst 8
    nop
    rst 8
    nop
    adc a,a
    nop
    ld c,a
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    nop
    adc a,a
    nop
    adc a,a
    nop
    jr nc,lab9CFF
lab9CFF ld c,a
    nop
    ld c,a
    nop
    dec h
    nop
    adc a,a
    nop
    adc a,a
    nop
    sbc a,d
    nop
    rst 8
    nop
    rst 8
    nop
    sbc a,d
    nop
    ld h,l
    nop
    rst 8
    nop
    rst 8
    nop
    ld h,l
    nop
    ld c,a
    nop
    adc a,a
    nop
    rrca 
    nop
    rrca 
    nop
    adc a,a
    nop
    ld c,a
    nop
    rst 8
    nop
    jp z,labCEFE+2
    nop
    adc a,a
    nop
    rst 8
    nop
    rrca 
    nop
    rrca 
    nop
    rst 8
    nop
    ld c,a
    nop
    rst 8
    nop
    push bc
    nop
    push bc
    nop
    rrca 
    nop
lab9D3F jp z,labC500
    nop
    rst 8
    nop
    jp z,labCA00
    nop
    rst 8
    nop
    adc a,a
    nop
    adc a,a
    xor d
    ld a,(de)
    rst 56
    dec h
    rst 56
    ld c,a
    ld d,l
    ld c,a
    nop
    rst 8
    nop
    push bc
    nop
    rst 8
    nop
    jp z,labC500
    nop
    jp z,labC000
    nop
    ret nz
    nop
    rst 8
    nop
lab9D69 adc a,a
    nop
    adc a,a
    ld d,l
    rrca 
    rst 56
    sbc a,d
    rst 56
    ld h,l
    rst 56
    rrca 
    rst 56
    ld c,a
    xor d
    ld c,a
    nop
    jp z,labCEFE+2
    nop
    ret nz
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rrca 
    xor d
    ld a,(de)
    rst 56
lab9D8D djnz lab9D8D+1
    nop
    rst 56
    nop
    rst 56
lab9D93 jr nz,lab9D93+1
    dec h
    rst 56
    rrca 
    ld d,l
    rst 8
    nop
    rst 8
    nop
lab9D9D rst 8
    nop
    rst 8
    nop
    push bc
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    nop
lab9DA9 jr nc,lab9DA9+1
lab9DAB jr nz,lab9DAB+1
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
lab9DB5 djnz lab9DB5+1
lab9DB7 jr nc,lab9DB7+1
    adc a,a
    nop
    rst 8
    nop
    rst 8
    nop
    jp z,lab9000
    nop
    ret nz
    nop
    ld c,a
    nop
    dec h
    xor d
    dec b
    rst 56
    nop
lab9DCC rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    ld a,(de)
    ld d,l
    adc a,a
    nop
    ret nz
    nop
    ld h,b
    nop
    jr nc,lab9DE3
lab9DE3 push bc
    nop
    rrca 
    nop
    dec h
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld a,(de)
    xor d
    rrca 
    nop
    jp z,lab3000
    nop
    rrca 
    nop
    jp z,lab2500
    nop
lab9E07 djnz lab9E07+1
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
lab9E19 jr nz,lab9E19+1
    ld a,(de)
    nop
    push bc
    nop
    rrca 
    nop
    rrca 
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    ld a,(bc)
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    dec b
    rst 56
    dec h
    nop
    ld c,a
    nop
    rrca 
    nop
    sub b
    nop
    rst 8
    nop
    rrca 
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    rrca 
    nop
    rst 8
    nop
    ld h,b
    nop
    ld c,a
    nop
    ret nz
    nop
    rst 8
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    ret nz
    nop
    adc a,a
    nop
    adc a,a
    nop
    dec h
    nop
    adc a,a
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld c,a
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    push bc
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,a
    nop
    dec h
    nop
    jp z,lab4F00
    nop
    jr nc,lab9EC5
lab9EC5 rst 8
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
    nop
    jr nc,lab9EDF
lab9EDF adc a,a
    nop
    adc a,a
    nop
    dec h
    nop
    rst 8
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
    xor d
    ld a,(de)
    nop
    ld c,a
    nop
    ld c,a
    nop
    jr nc,lab9F05
lab9F05 rst 8
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    rst 8
    ld d,l
    jr nc,lab9F1F
lab9F1F adc a,a
    nop
    adc a,a
    nop
    dec h
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    ld a,(de)
    nop
    ld c,a
    nop
    ld c,a
    nop
    sbc a,d
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    ld h,l
    nop
    adc a,a
    nop
    adc a,a
    nop
    ld h,l
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    sbc a,d
    nop
    ld c,a
    nop
    ld c,a
    nop
    adc a,a
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    ld c,a
    nop
    adc a,a
    nop
    push bc
    nop
    rst 8
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    rst 8
    nop
    jp z,labC500
    nop
    jp z,lab44FF+1
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    push bc
    nop
    jp z,lab8EFF+1
    nop
    ld h,l
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    sbc a,d
    nop
    ld c,a
labA000 nop
    ld c,a
    nop
    sbc a,d
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labA019 nop
    rst 56
    adc a,d
    ld d,l
    ld h,l
    nop
    adc a,a
    nop
    push bc
    nop
    ld h,l
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    sbc a,d
    nop
    jp z,lab8EFF+1
    nop
    adc a,a
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    ld c,a
    nop
    ld c,a
    nop
    ld c,a
    nop
    rrca 
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    rrca 
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    rst 8
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    rst 8
    nop
    dec h
    nop
    ld h,l
    nop
    ld a,(de)
    nop
    adc a,d
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    nop
    dec h
    nop
    sbc a,d
    nop
    adc a,a
    nop
    dec h
    nop
    dec b
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labA0CF nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
labA0D8 rst 56
    nop
labA0DA rst 56
    ld a,(bc)
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    ld a,(de)
    xor d
    sbc a,d
labA0E4 xor d
    ld h,l
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
labA0F0 rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    sbc a,d
    ld d,l
    ld h,l
    xor d
    dec h
    ld d,l
    rrca 
    xor d
    rst 8
    nop
    sbc a,d
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld h,l
    rst 56
    rst 8
    nop
    rrca 
    nop
    dec b
    rst 56
    dec b
    rst 56
    adc a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    rst 56
    ld b,l
    rst 56
    ld a,(bc)
    rst 56
    ld b,l
    rst 56
    rrca 
    rst 56
    ld b,l
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld c,a
    rst 56
    ld c,a
    rst 56
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
    ld b,b
    ret nz
    ret nz
    add a,b
    ld b,b
    ret nz
    ret nz
    add a,b
    sub b
    ld a,(de)
    rrca 
    jp z,lab0FC5
    rrca 
    ret nz
    adc a,a
    jr nc,labA1A9
    rst 8
    adc a,a
    jr nc,labA1B8
    rst 8
    rst 8
    rrca 
    ld c,a
    rst 8
    rst 8
    rrca 
    ld c,a
    rst 8
    push bc
    rst 8
    rst 8
    jp z,labCFC5
    rst 8
    jp z,labC0C0
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    rrca 
    rst 8
    ld a,(de)
    ld a,(de)
    adc a,a
    sbc a,d
    rst 8
labA1A9 rrca 
    jr nc,labA1FB
    jr nc,labA1D3
    adc a,a
    jr nc,labA1E1
    ld a,(de)
    jr nc,labA203
    ld a,(de)
    dec h
    jr nc,labA1E8
labA1B8 ld c,a
    rrca 
    dec h
    ld a,(de)
    ld a,(de)
    dec h
    sbc a,d
    jr nc,labA210
    rrca 
    dec h
    ld a,(de)
    ld a,(de)
    rrca 
    adc a,a
    jr nc,labA217+1
    rrca 
    dec h
    ld c,a
    ld a,(de)
    rrca 
    adc a,a
    jr nc,labA1EB
    rrca 
    dec h
labA1D3 ld c,a
    ld a,(de)
    rrca 
    dec h
    jr nc,labA228
    sbc a,d
    dec h
    ld c,a
    rrca 
    rrca 
    dec h
    dec h
    rst 8
labA1E1 adc a,a
    rrca 
    jp z,lab4F8F
    rst 8
    ld c,d
labA1E8 jp z,labCFCA
labA1EB push bc
    push bc
    jp z,labCFC5
    jp z,labC0CA
    rst 8
    jp z,labCAC5
    ret nz
    push bc
    rst 8
    rst 8
labA1FB rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
labA203 rst 8
    rst 8
    jp z,labCFCF
    rst 8
    ret nz
    push bc
    rst 8
    add a,l
    ret nz
    push bc
    rst 8
labA210 push bc
    dec h
    rrca 
    add a,l
    rrca 
    ld c,a
    ld c,d
labA217 jp z,lab258F
    dec h
    rrca 
    dec h
    dec h
    adc a,a
    adc a,a
    adc a,a
    ld a,(de)
    rrca 
    adc a,a
    ld a,(de)
    rrca 
    ld c,a
    rst 8
labA228 ld c,a
    dec h
    ld h,l
    rst 8
    dec h
    dec h
    ld h,l
    ld c,a
    rrca 
    ld c,d
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rrca 
    rst 8
    rst 8
    ret nz
    ret nz
    ret nz
    rst 8
    jp z,labCFBF+1
    adc a,a
    jr nc,labA252+1
    ld c,a
    ld h,l
    dec h
    dec h
    ret nz
    adc a,a
    jr nc,labA29B
    rrca 
    add a,l
    rrca 
    ld a,(de)
    rrca 
    ld a,(de)
labA252 jr nc,labA284
    dec h
    push bc
    ld a,(de)
    dec h
    dec h
    adc a,a
    jr nc,labA27F+2
    dec h
    push bc
    sbc a,d
    ld a,(de)
    rrca 
    rst 8
    jr nc,labA27E
    rrca 
    add a,l
    ld a,(de)
    jr nc,labA2B8
    jp z,lab9A9A
    ld c,d
    adc a,a
    adc a,a
labA26F rrca 
    rst 8
    add a,l
    adc a,a
    rrca 
    rst 8
    rst 8
    rst 8
    rst 8
    jp z,labD0C0
    rst 8
    push bc
    rst 8
labA27E push bc
labA27F jp z,lab0FC0
    push bc
    adc a,a
labA284 rrca 
    rrca 
    ld c,d
    adc a,a
    dec h
    dec h
    push bc
    rrca 
    rrca 
    jr nc,labA2EF
    adc a,a
    jr nc,labA2AC
    push bc
    rrca 
    ld a,(de)
    jr nc,labA2BC
    and l
    ld a,(de)
    jr nc,labA2EA
labA29B rrca 
    jr nc,labA2CE
    ld a,(de)
    adc a,a
    ld a,(de)
    rrca 
    ld h,l
    rrca 
    rrca 
    dec h
    ld (hl),b
    and l
    rrca 
    jr nc,labA26F
    ld h,b
labA2AC rrca 
    jr nc,labA31F
    adc a,a
    rrca 
    rst 8
    jp z,labCFDA
    rst 8
    rst 8
    push bc
labA2B8 ld c,a
    ret nz
    ret nz
    ret nz
labA2BC push bc
    ld h,b
    ret nz
    add a,l
    ld c,d
    add a,l
    ld c,d
    rrca 
    push bc
    add a,l
    rrca 
    rrca 
    rrca 
    rrca 
    dec h
    rrca 
    rrca 
    rrca 
labA2CE jr nc,labA2EA
    dec h
    rrca 
    ld a,(de)
    rrca 
    ld c,a
    rrca 
    jr nc,labA2E7
    jr nc,labA30A
    dec h
    dec h
    ld c,d
    dec h
    dec h
    ld a,(de)
    ld a,(de)
    adc a,d
    nop
    nop
    nop
    rst 8
    nop
labA2E7 ld b,l
    dec b
    rrca 
labA2EA ld b,l
    ld a,(bc)
    adc a,a
    ld a,(bc)
    adc a,a
labA2EF ld a,(bc)
    adc a,a
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    dec b
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    rst 56
    ld b,b
labA30A nop
    add a,b
    xor d
    nop
    xor d
    nop
    rst 56
    nop
    ld d,l
    add a,b
    xor d
    add a,l
    nop
    nop
    nop
    ld c,a
    nop
    ld b,l
    nop
    dec b
    nop
labA31F nop
    xor d
    add a,b
    nop
    ld b,l
    nop
    jp z,labCEFE+2
    nop
    ret nz
    nop
    jp z,labCEFE+2
    nop
    ld b,b
    rst 56
    ret nz
    xor d
    ret nz
    ld d,l
    ret nz
    ld d,l
    ret nz
    nop
    push bc
    rst 56
    push bc
    xor d
    push bc
    rst 56
    nop
    ld d,l
    ld b,b
    rst 56
    add a,b
    rst 56
    ld a,(bc)
    rst 56
    ret nz
    rst 56
    nop
    rst 56
    dec b
    rst 56
    nop
    rst 56
    add a,b
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    xor d
    nop
    nop
    nop
    xor d
    nop
    xor d
    nop
    ld d,l
    nop
    ld d,l
    nop
    xor d
    nop
    ld d,l
    nop
    xor d
    nop
    nop
    nop
    nop
    nop
    ld d,l
    nop
    nop
    nop
    nop
    dec b
    nop
    adc a,d
    nop
    dec b
    nop
    ld c,a
    nop
    ld b,b
    nop
    dec b
    nop
    add a,b
    nop
    add a,b
    nop
    ld b,b
    nop
    ld a,(bc)
    nop
    ld b,b
    nop
    add a,l
    nop
    jp z,lab0A00
    nop
    jp z,lab49FF+1
    nop
    push bc
    nop
    ret nz
    nop
    push bc
    nop
    jp z,labC500
    nop
    ret nz
    nop
    adc a,a
    nop
    rst 8
    nop
    ret nz
    nop
    push bc
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    jp z,labC500
    nop
    ret nz
    nop
    jp z,labC000
    nop
    jp z,labC500
    nop
    ret nz
    nop
    jp z,labC000
    nop
    ret nz
    nop
    jp z,labC000
    nop
    ret nz
    nop
    ret nz
    nop
    jp z,labC000
    nop
    push bc
    nop
    ret nz
    nop
    jp z,labC000
    nop
    jp z,labC000
    nop
    jp z,labC000
    nop
    ret nz
    nop
    ret nz
    xor d
    jp z,labC000
    nop
    ret nz
    xor d
    ret nz
    ld d,l
    ret nz
    xor d
    ret nz
    rst 56
    ret nz
    ld d,l
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ld b,b
    rst 56
    add a,l
    rst 56
    ld c,d
    rst 56
    ld b,b
    rst 56
    add a,b
    rst 56
    dec b
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    xor d
    ld a,(bc)
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    nop
    ld b,b
    ld d,l
    add a,b
    nop
    dec b
    nop
    nop
    xor d
    nop
    rst 56
    ld a,(bc)
    nop
    nop
    nop
    ld c,a
    nop
    adc a,d
    nop
    push bc
    nop
    jp z,lab4000
    nop
    nop
    ld d,l
    push bc
    ld d,l
    ret nz
    rst 56
    ret nz
    nop
    ret nz
    nop
    ret nz
    xor d
    ret nz
    xor d
    ret nz
    ld d,l
    ld a,(bc)
    rst 56
    ld a,(bc)
    rst 56
    nop
    xor d
    jp z,labCAFF
    ld d,l
    dec b
    rst 56
    ld b,b
    rst 56
    add a,b
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,b
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ret nz
    nop
    ld l,b
    nop
    sub h
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ret nz
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    ret nz
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub h
    nop
    jp labC200
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ret nz
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    jp nz,labC200
    nop
    jp labC300
    nop
    sub (hl)
    nop
    ld l,b
    nop
    sub h
    nop
    inc a
    nop
    add a,b
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    sub h
    nop
    jp labC300
    nop
    jp labC100
    nop
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    add a,b
    nop
    nop
    rst 56
    nop
    ld d,l
    ld l,b
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    jp labC100
    nop
    jp labC300
    nop
    jp labC000
    nop
    ret nz
    nop
    nop
    ld d,l
    add a,b
    nop
    ret nz
    nop
    ret nz
    nop
    jp nz,labC300
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    jp labC000
    nop
    pop bc
    nop
    ret nz
    nop
    add a,b
    nop
    ret nz
    nop
    jp nz,labC300
    nop
    pop bc
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC300
    nop
    jp labC100
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    jp labC000
    nop
    ret nz
    nop
    jp labC300
    nop
    jp labC100
    nop
    jp labC300
    nop
    pop bc
    nop
    jp labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC000
    nop
    ret nz
    nop
    jp labC000
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    ret nz
    nop
    jp labC000
    nop
    ret nz
    nop
    jp labC200
    nop
    jp nz,labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC100
    nop
    jp labC000
    nop
labA6FF jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp labC100
    nop
    jp labC300
    nop
    jp nz,labC100
    nop
    jp nz,labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    ret nz
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC100
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
labA79F jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    rst 56
    ret nz
    xor d
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC200
    ld d,l
    nop
    rst 56
    djnz labA79F+2
    jp nz,labC255
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,lab8000
    rst 56
    nop
    rst 56
    ld b,l
    rst 56
    add a,b
    xor d
    jp nz,labC000
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC100
    nop
    jp nz,labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC055
    rst 56
    jp nz,lab00FF
    rst 56
    nop
    rst 56
    nop
    ld d,l
    dec b
    rst 56
    jp nz,labC0FF
    ld d,l
    jp nz,labC155
    nop
    jp labC300
    nop
    ret nz
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC100
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    xor d
    nop
    rst 56
    ld a,(bc)
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    nop
    ld d,l
    ld a,(bc)
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld b,l
    rst 56
    nop
    ld d,l
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    ld a,(bc)
    ld d,l
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    dec b
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC2AA
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    adc a,d
    rst 56
    adc a,d
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC100
    rst 56
    ld b,b
    ld d,l
    jp nz,labC3AA
    nop
    jp labC100
    nop
    add a,b
    rst 56
    nop
    rst 56
    nop
    xor d
    dec b
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    add a,b
    rst 56
    pop bc
    nop
    jp labC300
    nop
    ret nz
    rst 56
    nop
    rst 56
    adc a,d
    xor d
    ld b,b
    rst 56
    jp labC3AA
    nop
    ret nz
    ld d,l
    nop
    xor d
    nop
    rst 56
    dec b
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    rst 56
    nop
    rst 56
    ret nz
    ld d,l
    jp labC100
    rst 56
    nop
    rst 56
    nop
    rst 56
    dec b
    rst 56
    nop
    ld d,l
    ld b,b
    ld d,l
    jp lab80AA
    ld d,l
    dec b
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    add a,b
    ld d,l
    pop bc
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    adc a,d
    rst 56
    ld a,(bc)
    rst 56
    ld b,b
    rst 56
    add a,b
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    rst 56
    add a,b
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    rst 56
    nop
    xor d
    nop
    ld d,l
    nop
    nop
    nop
    nop
    ld b,l
    nop
    adc a,d
    nop
    rst 0
    nop
    rlc b
    jp labC300
    nop
    ld l,c
    nop
    sub (hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    jp labC300
    nop
    rlc b
    rst 0
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    ld d,l
    adc a,a
    xor d
    ld a,(de)
    xor d
    dec h
    ld d,l
    ld a,(bc)
    nop
    dec b
    nop
    ld b,c
    nop
    add a,d
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    ld l,l
    nop
    sbc a,(hl)
    nop
    rlc b
    rst 0
    nop
    jp labC300
    nop
    rst 0
    nop
    rlc b
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    ld d,l
    adc a,a
    xor d
    ld a,(de)
    xor d
    dec h
    ld d,l
    ld a,(bc)
    nop
    dec b
    nop
    inc d
    nop
    jr z,labAA75
labAA75 rst 0
    nop
labAA77 rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    sbc a,(hl)
    nop
    ld l,l
    nop
    rst 0
    nop
    rlc b
    jp labC300
    nop
    rlc b
    rst 0
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    rst 8
    nop
    ld c,a
    ld d,l
    adc a,a
    xor d
    ld a,(de)
    nop
    dec h
    nop
    ld a,(bc)
    nop
    dec b
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    jr z,labAB1A
labAB1A nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    inc a
    nop
    inc d
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc d
    nop
    inc a
    nop
    inc a
    nop
    nop
    nop
    nop
    ld d,l
    nop
    nop
    jr z,labAB54
labAB54 inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labAB80
labAB80 ld l,c
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    ld l,c
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    ld l,c
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp labC300
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    jp labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp labC300
    nop
    jp labD300
    nop
    ld l,c
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labD300
    nop
    jp labC300
    nop
    pop de
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    rst 56
    nop
    xor d
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labD100
    nop
    jp labC300
    nop
    pop de
    nop
    jp lab6900
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    xor d
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp nz,labD100
    nop
    jp labC355
    ld d,l
    di
    nop
    jp nz,labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    ex (sp),hl
    nop
    add a,d
    ld d,l
    add a,d
    rst 56
    ex (sp),hl
    nop
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp labD100
    nop
    jp lab8200
    rst 56
    nop
    rst 56
    jp labD100
    nop
    jp nz,lab6900
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC200
    nop
    ex (sp),hl
    nop
    jp lab0055
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    ex (sp),hl
    nop
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    ex (sp),hl
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    jp labD100
    nop
    jp lab6900
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp labD300
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    jp nz,labD100
    nop
    sub (hl)
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD100
    nop
    jp nz,labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    pop bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    ex (sp),hl
    nop
    jp lab0055
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    ex (sp),hl
    nop
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    ld l,c
    nop
    rlc b
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    ld l,c
    nop
    jp labC000
    nop
    ex (sp),hl
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    jp labD100
    nop
    jp nz,lab6900
    nop
    ld l,c
    nop
    rlc b
    rst 8
    nop
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    ld h,e
    nop
    inc a
    nop
    jp labC200
    nop
    pop de
    nop
    sub (hl)
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD100
    nop
    jp nz,labC300
    nop
    sub (hl)
    nop
    rlc b
    rst 8
    nop
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    ld h,e
labAECF nop
    jp labC300
    nop
    jp nz,labE300
    nop
    jp lab0055
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    ex (sp),hl
    nop
    jp nz,labC300
    nop
    jp labCB00
    nop
    ld e,e
    nop
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    ld h,e
    nop
    jp labC300
    nop
    jp nz,labE300
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    jp labD300
    nop
    jp labC300
    nop
    ld c,e
    nop
    ld c,a
    nop
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    ld h,e
    nop
    jp labC300
    nop
    out (#0),a
    sub (hl)
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD300
    nop
    jp labC300
    nop
    ld c,e
    nop
    ld c,a
    nop
    push bc
    nop
    out (#aa),a
    ld a,c
    rst 56
    push bc
    nop
    ld c,a
    nop
    ld h,e
    nop
    jp lab9600
    nop
    jp labC300
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    jp lab9600
    nop
    jp lab4B00
    nop
    ld h,a
    nop
    ld l,l
    nop
    ld b,b
    rst 56
    nop
    rst 56
    inc a
    xor d
    ld c,a
    nop
    ld c,e
    nop
    ld l,c
    nop
    sub (hl)
    nop
    inc a
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    ld h,e
    nop
    ld c,a
    nop
    inc a
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc d
    rst 56
    ld l,l
    nop
    ld c,e
    nop
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    nop
    sub (hl)
    nop
    inc a
    nop
    ld c,e
    nop
    inc a
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc a
    rst 56
    ld c,e
    nop
    inc a
    nop
    sub (hl)
    nop
    ld l,c
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    sub (hl)
    nop
    inc a
    nop
    ld l,c
    nop
    inc d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    xor d
    inc a
    nop
    sub (hl)
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    sub (hl)
    nop
    inc a
    nop
    ld l,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    inc a
    nop
    sub (hl)
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp lab3C00
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc a
    rst 56
    jp lab0055
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp lab14FF
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labB0E4 nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    nop
    inc d
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jr z,labB12A
labB12A inc a
    nop
    nop
    nop
    nop
    xor d
    nop
    rst 56
    nop
    xor d
    nop
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB13C
labB13C nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc d
    nop
    nop
    nop
    inc d
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB16E
labB16E nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    jr z,labB188
labB188 inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jr z,labB1B6
labB1B6 inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB1D0
labB1D0 nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB202
labB202 nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    jr z,labB214
labB214 inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    jp labC300
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jr z,labB242
labB242 inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    jp labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB264
labB264 nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    inc a
    nop
    inc a
labB273 nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC300
    nop
    jp labC300
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB296
labB296 nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    jr z,labB2A0
labB2A0 inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    ex (sp),hl
    nop
    jp labC300
    nop
    ex (sp),hl
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    jr z,labB2CE
labB2CE inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labE200
    nop
    jp labC300
    nop
    jp po,labC300
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB2F8
labB2F8 nop
    ld d,l
    nop
    ld d,l
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    jp labE200
    nop
    jp labC300
    xor d
    jp po,labC100
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jr z,labB32A
labB32A jr z,labB32C
labB32C inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC100
    nop
    di
    nop
    jp lab41AA
    xor d
    out (#0),a
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    out (#0),a
    ld b,c
    rst 56
    ld b,c
    rst 56
    jp labE200
    nop
    jp lab9600
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    pop bc
    nop
    jp po,labC300
    nop
    nop
    rst 56
    nop
    rst 56
    jp labD3AA
    nop
    pop bc
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    out (#0),a
    sub (hl)
    xor d
    nop
    rst 56
    nop
    rst 56
    ld b,c
    xor d
    out (#0),a
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    ld l,c
    nop
    jp lab9600
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    jp labE200
    nop
    jp lab4100
    rst 56
labB400 nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    ld l,c
    nop
    jp po,labC100
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    ld l,c
    nop
    ex (sp),hl
    nop
    ex (sp),hl
    nop
    jp nz,lab9600
    nop
    inc a
    nop
    inc a
    nop
    inc a
    nop
    jp labC100
    nop
    jp po,labC300
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD3AA
    nop
    ret nz
    nop
    jp lab3C00
    nop
    inc a
    nop
    ld l,c
    nop
    ld l,c
    nop
    jp z,labE300
    nop
    ex (sp),hl
    nop
    jp z,labC700
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    jp labC000
    nop
    out (#0),a
    sub (hl)
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    xor d
    out (#0),a
    ret nz
    nop
    jp lab9600
    nop
    ld l,c
    nop
    ld l,c
    nop
    sbc a,e
    nop
    jp z,labE300
    nop
    ex (sp),hl
    nop
    jp z,labCEFE+2
    nop
    rst 0
    nop
    sub (hl)
    nop
    sub (hl)
    nop
    pop bc
    nop
    jp po,labC300
    nop
    ld b,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    ld l,c
    nop
    jp po,labC100
    nop
    jp lab3C00
    nop
    sub e
    nop
    sbc a,e
    nop
    jp z,labE300
    nop
    ex (sp),hl
    nop
    jp z,labCEFE+2
    nop
    rst 0
    nop
    ld l,c
    nop
    jp labC100
    nop
    jp po,labC300
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD3AA
    nop
    pop bc
    nop
    jp labC300
    nop
    sub e
    nop
    sbc a,e
    nop
    jp z,labE300
    nop
    ex (sp),hl
    nop
    jp z,labA6FF+1
    nop
    rst 0
    nop
    jp labC300
    nop
    pop bc
    nop
    out (#0),a
    sub (hl)
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    xor d
    out (#0),a
    pop bc
    nop
    jp labC300
    nop
    sub e
    nop
    sbc a,e
    nop
    jp z,labE300
    nop
    ex (sp),hl
    nop
    jp z,lab8EFF+1
    nop
    add a,a
    nop
    jp labC300
    nop
    ex (sp),hl
    nop
    jp lab4100
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    ld l,c
    nop
    ex (sp),hl
    nop
    jp labC300
    nop
    sub e
    nop
    sbc a,e
    nop
    jp z,labE300
    nop
    ex (sp),hl
    ld d,l
    jp z,lab8EFF+1
    nop
    add a,a
    nop
    jp labC300
    nop
    ex (sp),hl
    nop
    jp data0000
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labC3AA
    nop
    ld l,c
    nop
    jp lab9300
    nop
    adc a,a
    nop
    jp z,labB600
    rst 56
    add a,b
    rst 56
    sbc a,(hl)
    nop
    sbc a,e
    nop
    add a,a
    nop
    jp lab6900
    nop
    jp lab9600
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    xor d
    inc a
    nop
    ld l,c
    nop
    sub (hl)
    nop
    add a,a
    nop
    adc a,a
    nop
    inc a
    ld d,l
    nop
    rst 56
    nop
    rst 56
    inc a
    rst 56
    adc a,a
    nop
    sub e
    nop
    inc a
    nop
    ld l,c
    nop
    inc a
    nop
    ld b,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    inc a
    nop
    ld l,c
    nop
    inc a
    nop
    add a,a
    nop
    sbc a,(hl)
    nop
labB5C6 jr z,labB5C6+1
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc a
    ld d,l
    add a,a
    nop
    inc a
    nop
    ld l,c
    nop
    sub (hl)
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    sub (hl)
    xor d
    ld l,c
    nop
    inc a
    nop
    add a,a
    nop
    inc a
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labB5FE jr z,labB5FE+1
labB600 sub (hl)
    nop
    inc a
    nop
    ld l,c
    nop
    sub (hl)
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    xor d
    ld l,c
    nop
    inc a
    nop
    sub (hl)
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    sub (hl)
    rst 56
    inc a
    nop
    ld l,c
    nop
    ld b,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    ld l,c
    nop
    inc a
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc a
    ld d,l
    jp data0000
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp lab3CA9+1
    rst 56
    nop
    rst 56
    nop
labB685 rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labB692 jr z,labB692+1
    jp lab00FF
    rst 56
    nop
    rst 56
    nop
labB69B rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,c
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ret p
    call p,labF8F4
    ret m
labB6D7 call po,lab8DE4
    ld c,a
    rst 8
    rrca 
    ld c,a
    call p,labF8F4
    ret p
    ret p
    adc a,l
    push hl
    ld c,a
    rst 8
    rst 8
    rst 8
    rrca 
    ret p
    call p,labF0F0
    call po,lab8FB0
    rst 8
    adc a,a
    sbc a,d
    jr nc,labB685
    ret m
    ret p
    ret p
    ret m
    ret c
labB6FB ld c,a
    ld c,a
    rst 8
    ld h,l
    ld c,a
    jr nc,labB765+2
    call m,labF8F0
labB705 call po,lab8FA5
    rst 8
    sbc a,d
    jr nc,labB69B
    sbc a,d
    ld h,l
    ret m
    ret p
    call p,lab30E4
labB713 ld c,a
    rst 8
    ld a,(de)
    jr nc,labB6D7+1
    push bc
    ld h,l
    ret p
    call p,lab8DF4
    ld a,(de)
    rst 8
    rst 8
    adc a,a
    ld h,b
    ret nz
    ret nz
    dec h
    call p,labF4F4
    ret c
    ld h,l
    ld c,a
    rst 8
    ld h,l
    ret nz
    ret nz
    ret nz
    adc a,a
    ret p
    ret p
    ret p
    sbc a,b
    rrca 
    rst 8
    rst 8
    jr nc,labB6FB
    ret nz
    ret nz
    ret nz
    ret p
    ret p
    call po,lab65E1
    ld c,a
    rst 8
    jr nc,labB705+2
    ret nz
    ret nz
    add a,b
    call m,labF0F4
    sbc a,b
    adc a,a
    ld c,a
    rst 8
    jr nc,labB713
    ret nz
    ret nz
    nop
    call p,labE4F4
    sbc a,b
    ld c,a
    rst 8
    rst 8
    ld h,b
    ret nz
    ret nz
    push bc
    nop
    call p,labF0F0
labB765 call po,labCF8F
    adc a,a
    jp z,labC5C0
    rst 8
    dec b
    ret p
    call p,lab98F0
    ld c,a
    rst 8
    sbc a,d
    ld c,d
    ret nz
    rst 8
labB778 adc a,d
    nop
    call p,labE4F0
    sbc a,b
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    push bc
    rst 8
    adc a,d
    ld b,l
    ret p
    ret p
    call po,lab4FE4
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
    adc a,d
    nop
    ret p
    ret p
    ret m
    sbc a,b
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
labB79C dec b
    nop
    ret m
    ret p
    ret m
    adc a,l
    ld c,a
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
    nop
    nop
    call p,labECF0
labB7AD sbc a,b
    adc a,a
    rst 8
    rst 8
    jr nc,labB778
    rst 8
    nop
    nop
    ret p
    ret p
    call pe,lab65E3+1
    ld c,a
    adc a,a
    rst 8
    push bc
    rst 8
    ld b,l
    dec b
    ret p
    call p,lab98EC
    rrca 
    rst 8
    rst 8
    rrca 
    push bc
    rst 8
    nop
    nop
    ret p
    ret p
    ret p
    call z,lab4F65
    rst 8
    jr nc,labB79C
    rst 8
    adc a,d
    nop
    ret p
    call p,labD8F0
    dec h
    rst 8
    rst 8
    jr nc,labB7AD
    rst 8
    adc a,d
    ld b,l
    ret m
    call p,labCCF0
labB7EA sbc a,b
    ld c,a
    rst 8
    sbc a,d
    jp z,lab8ACD+2
    nop
    ret p
    ret p
    call p,labB0E4
    adc a,a
    rst 8
    sbc a,d
    rst 8
    push bc
    adc a,d
    nop
labB7FE call p,labF4F0
    ret m
    adc a,l
    ld c,a
    ld c,a
    rst 8
    adc a,a
    push bc
    adc a,d
    ld a,(bc)
    ret p
    ret p
    ret p
    ret p
    sbc a,b
    dec h
    rst 8
    rst 8
    ld a,(de)
    ld h,b
    adc a,d
    nop
    ret p
    ret p
    ret p
    call p,lab65CB+1
    ld c,a
    rst 8
    jr nc,labB7EA
    rst 8
    nop
    call p,labF8F0
    call p,lab0FD8
    adc a,a
    rst 8
    rst 8
    ld a,(de)
    push bc
    nop
    call p,labF0F0
    call p,lab30E4
    ld c,a
    ld c,a
    rst 8
    jr nc,labB7FE
    adc a,d
    call p,labF0F0
    call p,lab8DF8
    dec h
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    adc a,d
    ret p
    ret p
    ret m
    ret m
    ret m
    sbc a,b
    ld c,a
    ld c,a
    ld c,a
    rst 8
    ld h,b
    rst 8
    ret p
    ret p
    call p,labFCF0
    call po,lab8F25
    adc a,a
    rst 8
    sbc a,d
    ret nz
    ret m
    call p,labF0F0
    ret p
    call po,lab6598
    ld c,a
    ld c,a
labB868 rst 8
    ld h,b
    ret p
    call p,labF0F0
    call p,lab98F0
    ld a,(de)
    adc a,a
    adc a,a
    ld c,a
    rst 8
    call p,labF8F0
    ret p
    call p,labCCF4
    ld h,l
    ld c,a
    ld c,a
    rrca 
    rst 8
    call p,labF8F0
    call p,labF8F0
    call po,lab8FA5
    adc a,a
    adc a,a
    ld c,a
    call m,labF0F0
    ret p
    ret p
    call m,lab8DF0
    ld h,l
    ld c,a
    ld c,a
    rrca 
    ret m
    call p,labF8F0
    ret m
    ret p
    call po,lab30B0
    adc a,a
    adc a,a
    adc a,a
    ret p
    call p,labF0F0
    ret p
    call p,lab98F8
    ld a,(de)
    ld c,a
    ld c,a
    rrca 
    adc a,a
    rrca 
    rst 8
    adc a,a
    ld c,(hl)
    ret c
    ret c
    call p,labF8F4
    ret m
    ret p
    rrca 
    rst 8
    rst 8
    rst 8
    adc a,a
    jp c,labF04E
    ret p
    call p,labF8F8
    ld c,a
    jr nc,labB932
    ld c,a
    rst 8
labB8CF ld c,a
    ld (hl),b
    ret c
    ret p
    ret p
    ret m
    ret p
    sbc a,d
    jr nc,labB868
    sbc a,d
    rst 8
    adc a,a
    adc a,a
    call po,labF0F4
    ret p
    call p,lab659A
    ld c,a
    jr nc,labB94C
labB8E7 rst 8
    ld c,a
    ld e,d
    ret c
    call p,labFCF0
    sbc a,d
    jp z,lab30C0
    dec h
labB8F3 rst 8
    adc a,a
    jr nc,labB8CF
    ret m
    ret p
    call p,labC01A
    ret nz
    sub b
    ld c,a
labB8FF rst 8
    rst 8
    dec h
    ld c,(hl)
    ret m
    ret m
    ret p
    ld c,a
    ret nz
    ret nz
    ret nz
    sbc a,d
    rst 8
    adc a,a
    sbc a,d
    call po,labF8F8
    ret m
    ret nz
    ret nz
    ret nz
    ret nz
    jr nc,labB8E7
    rst 8
    rrca 
    ld h,h
    ret p
    ret p
    ret p
    ld b,b
    ret nz
    ret nz
    ret nz
    jr nc,labB8F3
    adc a,a
    sbc a,d
    jp nc,labF0D8
    ret p
    nop
    ret nz
    ret nz
    ret nz
    jr nc,labB8FF
    adc a,a
    ld c,a
labB932 ld h,h
    ret p
    ret m
    call m,labCA00
    ret nz
    ret nz
    sub b
    rst 8
    rst 8
    adc a,a
    ld h,h
    ret c
    ret m
    ret m
    ld a,(bc)
    rst 8
    jp z,labC5C0
    ld c,a
    rst 8
    ld c,a
    ret c
    ret p
labB94C ret p
    ret m
    nop
    ld b,l
    rst 8
    ret nz
    add a,l
    ld h,l
    rst 8
    adc a,a
    ld c,(hl)
    ret p
    ret m
    ret p
    adc a,d
    ld b,l
    rst 8
    jp z,lab6590
    rst 8
    ld c,a
    ld h,h
    ret c
    ret p
    ret m
    nop
    ld b,l
    rst 8
    rst 8
    sub b
    ld h,l
    rst 8
    adc a,a
    ret c
    ret c
    ret p
    ret p
    nop
    ld a,(bc)
    rst 8
    rst 8
    sub b
    ld h,l
    rst 8
    ld c,a
    ld h,h
    call p,labF0F0
    nop
    nop
    rst 8
    rst 8
    sub b
    ld h,l
    rst 8
    adc a,a
    ld c,(hl)
    call p,labF4F0
    nop
    nop
    rst 8
labB98D jp z,labCF30
    rst 8
    ld c,a
    ld h,h
    call c,labF8F0
    ld a,(bc)
    adc a,d
    rst 8
    jp z,lab4FCF
    adc a,a
    sbc a,d
    ret c
    call c,labF0F0
    nop
    nop
    rst 8
    jp z,labCF0F
    rst 8
    rrca 
    ld h,h
    call c,labF0F8
    nop
    ld b,l
    rst 8
    jp z,labCF30
    adc a,a
    sbc a,d
    call z,labF0F0
    ret p
    adc a,d
    ld b,l
    rst 8
    push bc
    jr nc,labB98D+2
    rst 8
    ld a,(de)
    call po,labF8F0
    ret p
    nop
    ld b,l
    rst 8
    push bc
labB9CA ld h,l
    rst 8
    adc a,a
    ld h,h
    call z,labF8F0
    call p,lab44FF+1
    jp z,lab65CF
    rst 8
    ld c,a
    ld (hl),b
    ret c
    ret m
    ret p
    ret p
    dec b
    ld b,l
    jp z,labCF4D+2
    adc a,a
    adc a,a
    ld c,(hl)
    call p,labF0F8
    ret m
    nop
    ld b,l
    sub b
    dec h
labB9EE rst 8
    rst 8
    ld a,(de)
    ld h,h
    ret p
    ret p
    ret p
    ret p
    nop
    rst 8
    push bc
    jr nc,labB9CA
    adc a,a
    sbc a,d
    call z,labF0F8
    ret p
    ret p
    nop
    jp z,labCF25
    rst 8
    ld c,a
    rrca 
    call po,labF4F8
    ret p
    ret m
    ld b,l
    jp z,labCF30
    adc a,a
    adc a,a
    jr nc,labB9EE
    ret m
    ret p
    ret p
    ret m
    ld b,l
    sub b
    ld h,l
    rst 8
    ld c,a
    ld a,(de)
    ld c,(hl)
    call p,labF0F8
    ret p
    ret m
    rst 8
    sub b
    rst 8
    adc a,a
    adc a,a
    adc a,a
    ld h,h
    call p,labF4F4
    ret p
    ret p
    ret nz
    ld h,l
    rst 8
    ld c,a
    ld c,a
    ld a,(de)
    ret c
    call m,labF8F0
    ret p
    ret p
    sub b
    rst 8
    adc a,a
    adc a,a
    sbc a,d
    ld h,h
    ret c
    ret p
    ret p
    ret p
    ret m
    call p,lab8FCF
    ld c,a
    ld c,a
    dec h
    ld h,h
    ret p
    ret m
    ret p
    ret p
    ret m
    ret p
    rst 8
    rrca 
    adc a,a
    adc a,a
    sbc a,d
    call z,labF8F8
    ret p
    call p,labF8F0
    adc a,a
    ld c,a
    ld c,a
    ld c,a
    ld e,d
    ret c
    call p,labF8F0
    call p,labF8F0
    rrca 
    adc a,a
    adc a,a
    sbc a,d
    ld c,(hl)
    ret p
    call m,labF0F0
    ret p
    ret p
    call m,lab4F4F
    ld c,a
    jr nc,labBAEF
    ret c
    ret p
    call p,labF0F4
    ret m
    call p,lab8F0F
    adc a,a
    dec h
    ld h,h
    call p,labF0F8
    ret p
    ret p
    ret m
    ret p
    ld c,a
    ld c,a
    adc a,a
    ld c,(hl)
    ret c
    ret p
    ret c
    and l
    rrca 
    ld a,(de)
    rrca 
    rrca 
    adc a,a
    rst 8
    ld c,a
    ld c,(hl)
    call po,labB0E4
    ld c,(hl)
    ld c,(hl)
    rst 8
    dec h
    rrca 
    ld h,l
    dec h
    adc a,a
    sbc a,d
    ld a,(lab250F)
    dec h
    adc a,a
    rst 8
    ld a,(de)
    ld a,(bc)
    ld a,(de)
    ld c,a
    ld c,a
    sbc a,a
    dec (hl)
    rra 
    ld a,(de)
    rrca 
    ld c,a
    ld c,a
    adc a,a
    ld a,(bc)
    dec h
    dec h
    adc a,a
    sbc a,d
    ld a,(lab2F0F)
    dec h
    adc a,a
    rst 8
    sbc a,d
    ld a,(bc)
    ld a,(de)
    rrca 
    ld c,a
    rst 8
    dec h
    rra 
    rra 
    ld a,(de)
    ld c,a
    ld c,a
    adc a,a
    nop
    rrca 
    rrca 
    adc a,a
    rst 8
    adc a,a
    dec b
    cpl 
    cpl 
    rrca 
    adc a,a
    ld a,(bc)
    nop
    nop
    rrca 
    ld c,a
    adc a,d
    nop
    nop
    nop
    dec b
    rrca 
labBAEF ld a,(bc)
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
labBAFB nop
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
    call po,lab88D8
    nop
    nop
    nop
    nop
    nop
    nop
    call po,lab00E4
    ret c
    call po,labD8F0
    adc a,b
    nop
    nop
    call po,labF8E4
    ret p
    ret c
    ret p
    ret m
labBB22 call pe,labE4F4
    ret c
    ret c
    ret c
    call p,labF8F0
    call p,labF0F0
    ret p
    ret m
    ret c
    ret m
    ret p
    call p,labF0F0
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    ret p
    ret p
    ret m
    ret p
    ret p
    ret m
    call p,labF0F4
    ret p
    ret p
    ret p
    ret p
    ret m
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld b,c
    xor d
    nop
    rst 56
    nop
    rst 56
    ld b,c
    nop
    ld b,c
    nop
    nop
    rst 56
    nop
    rst 56
    sub (hl)
    nop
    sub (hl)
    nop
    nop
    xor d
    nop
    xor d
    add a,a
    nop
    dec l
    nop
    ld b,c
    xor d
    ld b,c
    nop
    ld l,b
    nop
    inc a
    nop
    ld b,c
    nop
    sub (hl)
    nop
    inc a
    nop
    inc a
    nop
    sub (hl)
    nop
    jp labC300
    nop
    inc a
    nop
    sub (hl)
    nop
    sub (hl)
    xor d
    inc a
    nop
    rrca 
    nop
    add a,a
    nop
    dec b
    nop
    dec h
    nop
    ld a,(de)
    nop
    rrca 
    nop
    rst 8
    nop
    rrca 
    nop
    rst 8
    nop
    rrca 
    xor d
    ld c,d
    nop
    rrca 
    nop
    jr nc,labBBB6
labBBB6 dec b
    nop
    sbc a,d
    nop
    rrca 
    nop
    rrca 
    nop
    ld c,a
    xor d
    rrca 
    nop
    rst 8
    nop
    rrca 
    nop
    dec b
    nop
    ld a,(de)
    nop
    rrca 
    nop
    ld h,l
    nop
    sbc a,d
    nop
    adc a,a
    nop
    dec h
    nop
    ld a,(de)
    nop
    adc a,a
    nop
    dec h
    nop
    jr nc,labBBDC
labBBDC ld a,(de)
    nop
    sbc a,d
    nop
    adc a,a
    nop
    rst 8
    nop
    rrca 
    nop
    ld a,(de)
    nop
    rrca 
    rst 56
    dec h
    rst 56
    rst 8
    rst 56
    adc a,a
    rst 56
    nop
    nop
    nop
labBBF3 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labBBFC nop
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
    jp labC3C3
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab4B0F
    sub (hl)
    dec l
    rrca 
    add a,e
    add a,e
    add a,e
    add a,e
    add a,e
    add a,e
    dec l
    ld a,(de)
    dec h
    sub (hl)
    rrca 
    dec h
    dec bc
    add a,e
    add a,e
    add a,e
    add a,e
    add a,e
labBC29 rrca 
    ld a,(de)
    dec h
    dec l
    ld a,(de)
    ld a,(de)
    rrca 
    add a,e
    add a,e
    add a,e
    add a,e
    add a,e
    rrca 
    dec h
    ld a,(de)
    dec l
    adc a,a
    rrca 
    rrca 
    add a,e
    add a,e
    add a,e
    add a,e
    add a,e
    ret nz
    rrca 
    rrca 
    inc a
    ld c,a
    rrca 
    ld c,d
    add a,e
    add a,e
    add a,e
    add a,e
    jp labC042
    add a,l
    dec l
    rrca 
    adc a,a
    pop bc
    add a,e
    add a,e
    add a,e
    add a,e
    jp labC00F
    ret nz
    rrca 
    jr nc,labBC29
    ld b,e
    ld b,e
    add a,e
    add a,e
    jp lab0F43
    ld a,(de)
    dec h
    ld a,(de)
    dec h
    ld c,e
    ld b,e
    ld b,e
    add a,e
    add a,e
    jp lab0741+2
    dec h
    rrca 
    rrca 
    rrca 
    rrca 
    jp lab8343
    add a,e
    jp lab8343
    rrca 
    ld c,a
    rst 8
    rrca 
    rrca 
    jp lab8343
    add a,e
    jp lab8343
    dec l
    jp z,labCFBF+1
    sbc a,(hl)
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    ld l,b
    ret nz
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    jp labC3C3
    jp labC3C3
    jp labC3C3
    jp labC3C3
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    inc a
    rrca 
    rrca 
    ld e,#f
    inc a
    inc a
    ld a,c
    di
    di
    di
    di
    and a
    rrca 
    jr nc,labBCEE+1
    jr nc,labBCF1
    inc a
    ld a,c
    di
    di
    di
    di
    and a
    ld a,(de)
    rrca 
    ld c,a
    rrca 
    rrca 
labBCEE ld e,#79
    ret nz
labBCF1 ret nz
    ret nz
    ret nz
labBCF4 or (hl)
    rrca 
    rrca 
    sbc a,d
    rrca 
    rrca 
    sbc a,(hl)
    ld a,c
    ret nz
    ret nz
    ret nz
    ret nz
    or (hl)
    ld c,a
    rst 8
    dec h
    rst 8
    rst 8
    inc a
    ld a,c
    ret nz
    ret nz
    ret nz
    ret nz
    or (hl)
    rst 8
    rst 8
    ld c,a
    rrca 
    dec h
    rrca 
    dec l
    ret nz
    ret nz
    ret nz
labBD17 ret nz
    and a
    rrca 
    rrca 
    adc a,a
    ld a,(de)
    rrca 
    dec h
    rrca 
    ret nz
    ret nz
    ret nz
labBD23 ret nz
    rrca 
    dec h
labBD26 jr nc,labBD77
    dec h
    adc a,a
    ld a,(de)
    adc a,a
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    ld a,(de)
    rrca 
    dec h
    sbc a,d
    rst 8
    rrca 
    ld c,a
    ret nz
    ret nz
    ret nz
    ret nz
    rst 8
    rrca 
    rrca 
    rst 8
    rst 8
    ld c,a
    rst 8
    rst 8
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    rst 8
    rst 8
    rrca 
    ld c,a
    rrca 
    rrca 
    ld c,a
    ret nz
    ret nz
    ret nz
    ret nz
    rrca 
    ld c,a
    rrca 
    jr nc,labBDBE
    dec h
    dec h
    rrca 
    ret nz
    ret nz
    ret nz
    ret nz
    rrca 
    ld c,a
    sbc a,d
    jr nc,labBCF4
    sbc a,d
    ld a,(de)
    ld h,l
    ret nz
    ret nz
    ret nz
    ret nz
    sbc a,d
    rst 8
    rst 8
    rst 8
    rrca 
    ld c,a
    rst 8
    rst 8
    ret nz
    ret nz
    ret nz
labBD77 ret nz
    rst 8
    ld c,a
    ld c,a
    adc a,a
    jr nc,labBDCD
    dec h
    ld c,a
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    ld a,(de)
    jr nc,labBD17
    jr nc,labBDBA
    jr nc,labBD26
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    dec h
    jr nc,labBD23
    ld a,(de)
    ld c,a
    jr nc,labBD26+1
    ret nz
    ret nz
    ret nz
    ret nz
    adc a,a
    ld a,(de)
    dec h
    sbc a,d
    rst 8
    push bc
    ld c,a
    rst 8
    ret nz
    ret nz
    ret nz
    ret nz
    ld c,a
    rst 8
    rst 8
    ld c,a
    rrca 
    adc a,a
    dec h
    ld c,a
    ret nz
    ret nz
    ret nz
    ret nz
    dec h
    rrca 
    adc a,a
    dec h
    rrca 
    adc a,a
labBDBA ld a,(de)
    rrca 
    ret nz
    ret nz
labBDBE ret nz
    ret nz
    dec h
    dec h
    ld h,l
    rrca 
    rst 8
    ld h,l
    ld h,l
    ld c,a
    ret nz
    ret nz
    ret nz
    ret nz
    rst 8
labBDCD sbc a,d
    sbc a,d
    rst 8
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    ld a,(bc)
    ld d,l
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    ld d,l
    ld a,(bc)
    nop
    nop
    rst 56
    nop
    rst 56
    add a,d
    nop
    ld l,c
    nop
    nop
    rst 56
    nop
    ld d,l
    ld c,e
    nop
    rrca 
    nop
    nop
    ld d,l
    add a,d
    ld d,l
    rst 8
    nop
    ret nz
    nop
    add a,d
    nop
    add a,d
    nop
    inc a
    nop
    inc a
    nop
    ld l,c
    nop
    ld l,c
    nop
    inc a
    nop
    jp labC300
    nop
    ld l,c
    nop
    inc a
    nop
    rrca 
    nop
    ld c,e
    nop
    dec h
    nop
    ld a,(de)
    nop
    dec h
    nop
    rrca 
    nop
    ld c,a
    nop
    rrca 
    nop
    rst 8
    nop
    rlc b
    rrca 
    nop
    dec h
    nop
    ld a,(de)
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    ld c,e
    nop
    bit 2,l
    ld c,a
    nop
    ld a,(de)
    nop
    ld h,l
    nop
    jr nz,labBE46
labBE46 jr nc,labBE48
labBE48 rrca 
    nop
    ld c,a
    nop
    adc a,a
    nop
    rst 8
    nop
    rrca 
    nop
    ld c,e
    nop
    ld h,c
    nop
    ld a,(de)
    nop
    dec h
    nop
    rlc b
    adc a,a
    nop
    ld a,(de)
    nop
    rst 8
    nop
    ld c,a
    nop
    rrca 
    ld d,l
    rrca 
    nop
    ld a,(de)
    rst 56
    ld c,a
    rst 56
    adc a,d
    rst 56
    rst 8
    rst 56
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    inc bc
    nop
    ld b,d
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ld b,d
    nop
    inc bc
    nop
    add a,c
    nop
    inc bc
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    inc bc
    nop
    add a,c
    nop
    ret nz
    nop
    inc bc
    nop
    ld b,d
    nop
    ret nz
    nop
    ret nz
    nop
    ld b,d
    nop
    inc bc
    nop
    ret nz
    nop
    ret nz
    nop
    add a,c
    nop
    inc bc
    nop
    ret nz
    nop
    ret nz
    nop
    inc bc
    nop
    add a,c
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    inc bc
    nop
    ld b,d
    nop
    ld b,d
    nop
    inc bc
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    add a,c
    nop
    inc bc
    nop
    inc bc
    nop
    add a,c
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    nop
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
    ret nz
    rst 56
labBEFA ret nz
labBEFB rst 56
    ret nz
    rst 56
    ret nz
    rst 56
labBF00 rst 56
    or (hl)
    sub h
    sub h
    sub h
    ld l,b
    ld a,c
    rst 56
    di
    jp pe,labC0C0
    ret nz
    ret nz
    push de
    di
    jp labC0C0
    ret nz
    ret nz
    ret nz
    ret nz
    sub (hl)
    ret nz
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    ret nz
    ret nz
    ret nz
    rst 8
    jp z,labC0C0
    ret nz
    ret nz
    ret nz
    jp labE3F3
    sub (hl)
    inc a
    jp lab81C0
    out (#f3),a
    di
    sub (hl)
    inc a
    jp labC042
    ei
    ei
    rst 48
    jp labC3C3
    ret nz
    ret nz
    ei
    rst 56
    di
    inc a
    inc a
    inc a
    ret nz
    ld l,b
    jp pe,labEAF3
    ld l,b
    ret nz
    ret nz
    sub h
    ld l,b
    rst 56
    ret nz
    pop de
    ld l,b
    ret nz
    ret nz
    sub h
    ld l,b
    sub c
    inc sp
    ld h,d
    add hl,sp
    inc sp
    ld h,d
    sub h
    ld l,b
    inc sp
    inc sp
    inc sp
    ld (hl),a
    ei
    inc sp
    sub h
    ld l,b
    rst 8
    rst 8
    rst 8
    rst 48
    rst 48
    or d
    sub h
    inc a
    ret nz
    ret nz
    ret nz
    rst 48
    di
    and (hl)
    inc a
    ld l,c
    rst 8
    rst 8
    rst 8
    di
    ei
    or d
    sub (hl)
    ld l,c
    push bc
    push bc
    push bc
    ei
    di
    ld e,l
    sub (hl)
    ld l,c
    rst 8
    jp z,labAECF
    inc c
labBF8E ld (hl),l
    sub (hl)
    ld l,c
    rst 8
    rst 8
    rst 8
    sbc a,d
    jr labBF8E
    sub (hl)
    ld l,c
    ret nz
    jp z,labCFC5
    ld d,c
    rst 56
    sub (hl)
    ld l,c
    rst 8
    rst 8
    rst 8
    inc c
    di
    rst 56
    sub (hl)
    ld l,c
labBFA9 jp labC3C3
    jr labBFA9
    ex de,hl
    sub (hl)
    inc a
    inc a
    inc a
    inc a
    inc c
    rst 48
    inc a
    inc a
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,b
    ld l,c
    ld l,c
    inc a
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,b
    ld l,c
    ld l,c
    inc a
    inc a
    inc a
    inc a
    inc a
    ld l,b
    inc a
    inc a
    inc a
    ret nz
    ret nz
    nop
    nop
    ld b,b
    nop
    ret nz
    ret nz
    ld b,b
    add a,b
    nop
    nop
    ld b,b
    nop
    ld b,b
    add a,b
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
labC000 nop
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
labC00F nop
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
labC01A nop
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
labC02A nop
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
labC03A nop
    nop
    nop
    nop
    nop
    nop
labC040 nop
    nop
labC042 nop
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
    nop
labC055 nop
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
    nop
labC079 nop
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
    nop
    nop
labC0C0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC0CA nop
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
labC0FB nop
    nop
    nop
    nop
labC0FF nop
labC100 nop
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
labC155 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC1C3 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC200 nop
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
labC255 nop
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
labC2AA nop
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
labC300 nop
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
labC355 nop
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
labC3AA nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC3C3 nop
    nop
    nop
    nop
labC3C7 nop
    nop
    nop
    nop
labC3CB nop
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
    nop
labC400 nop
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
labC4C7 nop
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
    nop
    nop
    nop
    nop
    nop
labC500 nop
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
    nop
    nop
    nop
    nop
labC5C0 nop
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
labC600 nop
    nop
    nop
    rlca 
labC604 rlca 
    rlca 
labC606 nop
    nop
    nop
    nop
    nop
    nop
    nop
    ex af,af''
    adc a,b
    adc a,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC669
    ld d,b
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC67B
    ret nc
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC68C
    ret nc
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC685+1
    sub b
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC688
    djnz labC683
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC68B
    djnz labC68D
    nop
    nop
    nop
    nop
    inc bc
    rst 56
    sub b
    ld b,a
    djnz labC695
    inc bc
    rst 56
    add a,b
    nop
    inc e
    nop
    ld d,b
    ld c,b
    sub b
    ld bc,lab001C
    ld b,b
    nop
    jr nz,labC667
labC667 ld d,b
    ld d,b
labC669 ld d,b
    ld bc,lab0020
    ld b,b
    nop
    ld b,b
    rst 56
    ret nc
    ld d,b
    ld d,b
    ccf 
    ld b,b
    rst 56
    ret nz
    nop
    ld b,e
    rst 56
labC67B sub b
    ld d,b
    ld d,b
    ld a,(hl)
    ld b,e
    rst 56
    add a,b
    nop
labC683 add a,a
    nop
labC685 djnz labC6D7
labC687 ld d,b
labC688 ld b,b
    add a,a
    nop
labC68B nop
labC68C nop
labC68D adc a,h
    nop
    djnz labC6E1
    ld d,b
    ld b,b
    adc a,h
    nop
labC695 nop
labC696 ld bc,lab0088
    djnz labC6EB
    ld d,b
    ld b,c
    adc a,b
    nop
    nop
    ld bc,lab0088
    jr labC6FB+2
    ld e,b
    ld b,c
    adc a,b
    nop
    nop
    ld bc,lab0088
    jr labC687
    ret c
    pop bc
    adc a,b
    nop
    nop
    inc bc
    add a,a
    rst 56
    sbc a,b
    ret c
    ret c
    jp labFF87
    add a,b
    inc bc
    add a,b
    nop
    ld e,b
    ret c
    ret c
    jp lab0080
    ld b,b
    inc bc
    ret nz
    nop
    ld e,l
db #dd,#dd
    jp lab00C0
    ld b,b
    inc bc
    rst 56
    rst 56
    rst 24
    rst 24
labC6D7 rst 24
    jp labFFFF
    ret nz
    ld bc,labFFFF
    sbc a,a
    rst 24
labC6E1 rst 24
    pop bc
    rst 56
    rst 56
    add a,b
    ld bc,lab00F8
    rra 
    rst 24
labC6EB rst 24
    pop bc
    ret m
    nop
    nop
    ld bc,lab00F8
    ld e,#de
    sbc a,#c1
    ret m
    nop
    nop
    nop
labC6FB call m,lab1F00
    ld e,a
    ld e,a
labC700 ld b,b
    call m,data0000
    nop
    ei
    nop
    ld e,#de
    sbc a,#c0
    ei
    nop
    nop
    nop
    ld (hl),l
    rst 56
    sbc a,l
    ld e,l
    ld e,l
    ld a,#75
    rst 56
    add a,b
    nop
    ld a,d
    nop
    ld e,d
    jp c,lab81DA
    ld a,d
    nop
    ld b,b
    nop
    dec a
    nop
    ld e,l
    ld e,l
    ld e,l
    ld b,c
    dec a
    nop
    ld b,b
    nop
    rra 
    rst 56
    rst 8
    adc a,a
    adc a,a
    rst 56
    rra 
    rst 56
    ret nz
    nop
    inc bc
    rst 56
    add a,a
    rlca 
    rlca 
    cp #3
    rst 56
labC73F add a,b
labC740 nop
    inc bc
    rst 56
    cp #0
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
    rlca 
    ret m
    nop
    nop
    nop
    ld a,h
    ld b,a
db #fd,#00
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
    ei
    rst 32
    ret m
    nop
    nop
    adc a,b
    rrca 
    ei
    add a,b
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
    ld bc,labF0FF
    rlca 
    add a,b
    ld bc,lab0F00
    ei
    jp lab00FE
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,#ff
    rst 56
    ret p
    nop
    add a,b
    ld bc,lab1F00
    rst 56
    rst 56
    rst 56
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab87B7
    rst 56
    ret m
    jr labC7ED+1
    ld (bc),a
    ld bc,labFFE0
    di
    rst 56
    ret z
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    ld e,a
    rst 8
    sbc a,c
    rlca 
    ret p
labC7C3 ld b,b
    inc b
    cp #3f
    nop
    scf
    rst 40
    cp a
    pop af
    call m,data0000
    nop
    nop
    nop
    dec b
    rst 24
    rst 24
    rst 40
    nop
    call c,labE00F
    rrca 
    nop
    ccf 
    rst 40
    add a,b
    rlca 
db #fd,#fe
    ld h,#78
    nop
    nop
    nop
    rra 
    rst 56
    rst 40
    rst 56
    nop
    ei
labC7ED call m,lab2000
    ld a,(bc)
    inc b
    rst 56
    pop bc
    rst 32
    ret p
    dec b
    ret m
    ld e,a
    ret m
    ld a,a
    inc bc
    ret m
    ccf 
    rrca 
labC7FF xor #0
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
labC900 nop
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
labCA00 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labCA6D nop
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
    nop
    nop
labCAC5 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labCAFF nop
labCB00 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCBC3 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC00 nop
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
labCC2F nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC8D nop
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
labCC9D nop
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
labCCCC nop
labCCCD nop
labCCCE nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCCD8 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labCCF0 nop
    nop
    nop
    nop
labCCF4 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCCFC nop
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
    nop
    nop
    nop
labCDCC nop
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
labCE00 nop
    rst 40
    jp p,lab00FC
    jr nz,labCE0F
    jr c,labCE48
    rlca 
    rst 48
    ld e,e
    ret m
    nop
    ld a,(hl)
labCE0F ld e,a
    adc a,a
    add a,e
    rst 32
    adc a,e
    adc a,(hl)
    ld bc,labEFEF
    pop hl
    call m,lab2000
    dec bc
    add a,#3f
    add a,#f7
    ret po
    call m,lab00FC
    ld e,h
    rra 
    add a,e
    ret p
    cp (hl)
    ld bc,labC4C7
    rst 40
    pop hl
    call m,labE001
    inc c
    nop
    ccf 
    add a,#f7
    pop af
    call m,lab78FC
    nop
    dec de
    add a,e
    ret p
    ld b,c
    rst 0
    rst 0
    inc hl
    adc a,#0
    call m,lab201E
labCE48 add hl,bc
    ret po
    ccf 
    push bc
    rst 48
    pop af
    call m,labF62A+2
    ld a,(hl)
    jr nz,labCE58
    ld d,b
    ld e,a
    rlca 
    rst 0
labCE58 rst 32
    xor a
    and c
    inc a
    nop
    jr nz,labCE6D
    nop
    rst 56
    jp labF1F7
    call m,labFEFE
    dec d
    ccf 
    rlca 
    ret p
    ld e,h
    rst 32
labCE6D rst 0
    rst 32
    rst 40
    ld h,c
    rst 24
    nop
    nop
    ex af,af''
    inc bc
    ccf 
    rst 56
    rst 48
    pop af
    xor h
    cp #fe
    ld a,a
    ld a,a
    rlca 
    ret m
    ld b,a
    rst 32
    pop bc
    rst 32
    rst 40
    ret po
    call m,lab206F+1
    ex af,af''
    inc b
    ccf 
    ret nc
    rlca 
    pop af
    ret p
    cp #fe
    ld a,a
    rst 56
    rlca 
    ret m
    cpl 
    rst 48
    rst 0
    ld h,a
    rst 40
    ret po
    ld e,h
    ex af,af''
labCE9F jr nz,labCEA9
    ld a,(labD03F)
    nop
    pop af
    call m,labFE4D+2
labCEA9 rrca 
    rst 56
    rlca 
    ret m
    inc sp
    rst 48
    rlca 
    ex (sp),hl
    jp po,labFCE1
    ld b,#20
    add hl,bc
    add a,c
    ccf 
    ret nc
    rlca 
    pop af
    call m,labF4FF
    ld a,a
    ret m
    rlca 
    cp b
    ccf 
    cpl 
    rst 0
    add a,h
    rst 40
    pop hl
    call m,labA019
    ld c,#0
    ld a,(labF73E+1)
    ld b,c
    call m,labEEFD
    ld a,a
    rst 40
    rrca 
    cp h
    rra 
    rst 56
    rst 0
    rst 32
    rst 40
    ret po
    ld e,h
    jr nz,labCF02
    ex af,af''
    nop
    rst 8
    rst 0
    rst 48
    pop af
    call m,labDEFF
    ld a,a
    rst 56
    ld c,#3c
    rra 
    rst 56
    add a,a
    rst 32
    rst 40
    pop hl
    call m,lab2000
    ex af,af''
    nop
    rra 
    rst 0
    rst 48
    pop af
labCEFE call m,labDEFD+1
    ld a,b
labCF02 rst 40
    rrca 
    inc a
    rra 
    rst 24
    rst 0
    rst 32
    rrca 
    pop hl
    sbc a,h
    nop
    jr nz,labCF17
labCF0F call pe,labC73F
    rst 48
    pop af
    call z,labBEFA
labCF17 ld a,l
    rst 24
    rrca 
    inc b
    ld e,#ff
    rst 0
    and #cf
    ret po
    ld l,a
    ld l,h
    jr nz,labCF34
labCF25 nop
    ld a,a
    rst 0
    rst 48
    pop af
    cp h
    ld sp,hl
    cp (hl)
    ld a,l
    rst 24
    rrca 
labCF30 ld a,#18
    nop
    nop
labCF34 pop bc
    rst 40
    pop hl
    call m,lab20C0
    ex af,af''
    ld bc,labC7FF
    rst 48
    pop af
    call m,labBEFB
    ld a,l
    rst 24
    ld c,#fe
    rrca 
    ld a,a
    call nz,labE1E7
    ld (hl),e
labCF4D call m,lab6000
    ex af,af''
    ld a,(bc)
    ccf 
    ex de,hl
    rst 48
    ret nz
    call m,lab3EF9
    inc a
    sbc a,a
    dec de
    ret m
    ld e,#7c
    rst 0
    rst 0
    rst 40
    rst 40
    call m,lab6000
    ex af,af''
    nop
    ccf 
    rst 40
    rst 48
    pop af
    ld a,h
    ld sp,hl
    ld a,#2c
    sbc a,a
    rra 
    and (hl)
    rra 
    ccf 
    ld b,a
    rst 40
    rst 40
    sbc a,#ff
    nop
    and b
    ex af,af''
    rrca 
    cp #de
    ld (hl),a
    ei
    call m,lab3E28
    ld a,h
    rra 
    rra 
    rst 56
    rra 
    ld a,#7
    rst 56
    rst 32
    rst 56
labCF8F inc c
    add a,b
    jr nz,labCF98+2
    ret p
    dec e
    rst 56
    add a,h
    ld d,a
labCF98 call po,lab3EF7+1
    ld a,b
    rra 
    rra 
    rra 
    dec bc
    inc e
    rst 0
    ei
    ret pe
    ld a,a
    or a
    ret p
    jr nz,labCFAD
    ret nz
    inc bc
    rst 56
    ex (sp),hl
labCFAD rst 56
    ld sp,hl
    call m,lab727F
    inc a
    and l
    ex af,af''
    cp a
    sbc a,e
    rst 40
db #fd,#ef
    cp a
    ret m
    ld c,a
    ret nz
    inc bc
labCFBF jr nz,labCFD0
    rst 56
    jp labF89F
labCFC5 ld a,h
    ld a,a
    ld l,(hl)
    ccf 
    cp a
labCFCA sbc a,a
    cp a
    adc a,a
    rst 40
db #fd
labCFCF db #c7
labCFD0 rst 24
    ret p
    add a,b
    ld b,b
    nop
    add a,b
    rlca 
    rst 56
    add a,c
    cp a
labCFDA pop af
    xor h
    ld a,a
    ld a,(hl)
    ccf 
    cp a
    sbc a,a
    cp a
    adc a,a
    rst 40
    rst 56
    add a,e
    rst 56
    ret p
    nop
    add a,b
    nop
    ld a,a
    rst 56
    rst 56
    ld a,a
    ld a,a
    xor #fb
    cp (hl)
    cp l
    rst 24
    ld e,a
    ld l,a
    ld e,a
    ld (hl),l
    rst 16
    rst 56
    ld a,l
    rst 56
    rst 56
    rst 56
    nop
labD000 nop
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
labD03F nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD0C0 nop
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
labD0FF nop
labD100 nop
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
labD11F nop
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
    nop
    nop
    nop
    nop
labD300 nop
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
    nop
    nop
    nop
    nop
labD39E nop
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
labD3AA nop
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
labD400 nop
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
labD488 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr z,labD676
    ld l,h
    ld l,h
    ld l,h
    ld l,h
    jr z,labD610
labD610 jr labD649+1
    jr labD62C
    jr labD62E
    inc a
    nop
    ld e,h
    adc a,#4e
    inc e
    jr nc,labD624
    ld a,(hl)
    nop
    ld l,h
    add a,#6
    inc e
labD624 ld b,#c6
    ld l,h
    nop
    inc c
    inc c
    inc l
    ld c,h
labD62C xor #c
labD62E ld e,#0
    cp #fc
    add a,b
    call pe,labC606
    call pe,lab3400
    ld h,d
    ld h,b
    ld l,h
    ld h,(hl)
    ld h,(hl)
    inc (hl)
    nop
    cp #f8
    add a,(hl)
    inc e
    jr c,labD682
    jr labD648
labD648 ld l,h
labD649 add a,#c6
    ld l,h
    add a,#c6
    ld l,h
    nop
    inc l
    ld h,(hl)
    ld h,(hl)
    ld (hl),#6
    ld b,(hl)
    inc l
    nop
    nop
    nop
    nop
    nop
    nop
    jr labD677
    nop
    ld l,h
    sbc a,(hl)
    cp (hl)
    cp (hl)
    ld e,h
    jr c,labD677
    nop
    jr labD682
    jr labD682+2
    jr labD66E
labD66E jr labD670
labD670 jr c,labD6D5+1
    jr c,labD6E6
    sbc a,d
    ret c
labD676 ld l,h
labD677 nop
    djnz labD6A8+2
    ld a,(hl)
    cp #7e
    jr nc,labD68E+1
    nop
    ret po
    add a,b
labD682 call z,labEA8A
    ld a,(bc)
    inc c
    nop
    jr labD6A1+1
    jr labD6A4
    jr labD6A5+1
labD68E jr labD690
labD690 jr nc,labD6C1+1
    ld e,b
    ld e,b
    ld a,h
    adc a,h
    sbc a,(hl)
    nop
    call pe,lab6666
    ld l,h
    ld h,(hl)
    ld h,(hl)
labD69E call pe,lab6E00
labD6A1 add a,#c2
    ret nz
labD6A4 ret nz
labD6A5 jp nz,lab006C
labD6A8 call pe,lab6666
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    call pe,labEE00
    ld h,d
    ld h,h
    ld l,h
    ld h,h
    ld h,d
    xor #0
    xor #62
    ld h,h
    ld l,h
    ld h,h
    ld h,b
    ret po
    nop
    ld l,(hl)
labD6C1 add a,#c2
    ret nz
    adc a,#c6
    ld l,h
    nop
    xor #6c
    ld l,h
    ld a,h
    ld l,h
    ld l,h
    xor #0
    inc a
    jr labD6EB
    jr labD6ED
labD6D5 jr labD713
    nop
    ld e,#c
    inc c
    inc c
    call z,lab588C
    nop
    xor #64
    ld l,b
    ld a,b
    ld l,h
    ld l,h
labD6E6 xor #0
    ret p
    ld h,b
    ld h,b
labD6EB ld h,b
    ld h,d
labD6ED ld h,(hl)
    xor #0
    adc a,(hl)
    call c,lab7CFC
    xor h
    xor h
    adc a,(hl)
    nop
    add a,#e2
    ld (hl),d
    cp d
    sbc a,h
    adc a,(hl)
    add a,#0
    ld l,h
    add a,#c6
    add a,#c6
    add a,#6c
    nop
    call pe,lab6666
    ld h,(hl)
    ld l,h
    ld h,b
    ret po
    nop
    ld l,h
    add a,#c6
labD713 add a,#d6
    call z,lab006A
    call pe,lab6666
    ld l,h
    ld l,h
    ld h,(hl)
    and #0
    ld l,(hl)
    jp po,lab7CF0
    ld e,#8e
    call pe,lab5A00
    ld e,d
    jr labD744
    jr labD746
    jr labD730
labD730 jp p,lab6262
    ld h,d
    ld h,d
    ld h,d
    inc (hl)
    nop
    jp p,lab6462
    inc (hl)
    jr nc,labD756
    jr labD740
labD740 jp po,lab6A6A
    ld l,d
labD744 inc (hl)
    inc (hl)
labD746 inc (hl)
    nop
    add a,#e4
    ld (hl),b
    jr c,labD768+1
    ld c,(hl)
    add a,#0
    and #64
    jr nc,labD76C
    jr labD76E
labD756 inc a
    nop
    or #ce
    sbc a,h
    jr c,labD7CE+1
    and #de
    nop
    xor #aa
    xor (hl)
    ret po
    ld c,h
    call nz,labE04E
labD768 adc a,#26
    adc a,#e0
labD76C xor #26
labD76E ld l,#e0
    xor d
    xor (hl)
    ld (labEE20),hl
    adc a,(hl)
    ld l,#e0
    xor #8e
    xor (hl)
    ret po
    xor #22
    ld b,h
    ld b,b
    xor #ae
    xor (hl)
    ret po
    xor #ae
    ld l,#e0
    ld c,(hl)
    xor (hl)
    jp pe,labCE9F+1
    xor (hl)
    jp pe,labEEA0
    adc a,h
    adc a,(hl)
    ret po
    adc a,#ac
    xor (hl)
    ret nz
    xor (hl)
    xor #aa
    and b
    ld hl,(labEEEE)
    and b
    nop
    nop
    nop
    nop
    nop
    cp #0
    nop
    inc bc
    ld de,lab0080
    inc b
    djnz labD7EF
    nop
    ex af,af''
    nop
    jr nz,labD7B4
labD7B4 ex af,af''
    nop
    jr nz,labD7B8
labD7B8 djnz labD7BA
labD7BA djnz labD7BC
labD7BC djnz labD7BE
labD7BE djnz labD7C0
labD7C0 ld e,#0
    ret p
    nop
    djnz labD7C6
labD7C6 djnz labD7C8
labD7C8 djnz labD7CA
labD7CA djnz labD7CC
labD7CC ex af,af''
    nop
labD7CE jr nz,labD7D0
labD7D0 ex af,af''
    nop
    jr nz,labD7D4
labD7D4 inc b
    djnz labD817
    nop
    inc bc
    ld de,lab0080
    nop
    cp #0
    nop
    nop
    nop
    nop
    nop
    nop
    or (hl)
    nop
    jp labC300
    nop
    sub (hl)
    nop
    inc a
    nop
labD7EF inc a
    rst 56
labD7F1 jr z,labD7F1+1
    inc a
    ld d,l
    sub (hl)
    nop
    jp labC300
    xor d
    sub (hl)
    nop
    inc a
    rst 56
    nop
labD800 nop
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
    nop
    nop
    nop
    nop
    nop
labD817 nop
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
labD8AA nop
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
    nop
labD8F0 nop
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
labD8FF nop
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
    nop
    nop
    nop
labDC00 nop
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
labDCAA nop
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
    nop
labDCF0 nop
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
labDCFC nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDD9E nop
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
labDDBE nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDDC6 nop
    nop
    nop
    nop
    nop
    nop
labDDCC nop
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
labDDE9 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDDF2 nop
    nop
    nop
    nop
    nop
    nop
labDDF8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDE00 ld (hl),e
    jr labDDCC
    inc c
    ld h,e
    dec e
    jr z,labDDE9
    adc a,h
    ld d,c
    sub d
    ei
    cp b
    pop bc
    dec h
    inc h
    ld de,labC604
    ld (hl),b
    inc d
    and l
    dec l
    ld (de),a
    sub h
    and c
    jr z,labDD9E
    ld d,d
    xor d
    ld d,d
    ld (lab0225),hl
    dec h
    ld b,d
labDE24 ld l,#85
    add hl,hl
    ld b,b
    rla 
    cp c
    ex de,hl
    djnz labDE24
    add hl,de
    jr z,labDDF2
    ld (de),a
    adc a,e
    sub d
    inc hl
    jr c,labDDF8
    dec h
    add a,d
    jr z,labDDBE
    and #30
    sub h
    and c
    add hl,hl
    ld (de),a
    sub h
    dec b
    jr z,labDDC6
    ld d,d
    adc a,d
    ld (de),a
    ld (lab2224),hl
    dec h
    ld b,d
    ld l,#84
    add hl,hl
    ld c,b
    ld h,h
    and c
    add hl,hl
    inc c
    sub h
    jr c,labDE24+1
    pop hl
    adc a,h
    adc a,d
    inc c
    inc hl
    and h
    pop bc
    add hl,de
    inc h
    ld de,lab2604
    jr nc,labDE65
labDE65 nop
    nop
    rlca 
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ex af,af''
    adc a,b
    adc a,b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDECD
    ld d,b
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDEDF
    ret nc
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDEF0
    ret nc
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDEE9+1
    sub b
    ld b,b
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDEEC
    djnz labDEE7
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labDEEF
    djnz labDEF1
    nop
    nop
    nop
    nop
    inc bc
    rst 56
    sub b
    ld b,a
    djnz labDEF9
    inc bc
    rst 56
    add a,b
    nop
    inc e
    nop
    ld d,b
    ld c,b
    sub b
    ld bc,lab001C
    ld b,b
    nop
    jr nz,labDECB
labDECB ld d,b
    ld d,b
labDECD ld d,b
    ld bc,lab0020
    ld b,b
    nop
    ld b,b
    rst 56
    ret nc
    ld d,b
    ld d,b
    ccf 
    ld b,b
    rst 56
    ret nz
    nop
    ld b,e
    rst 56
labDEDF sub b
    ld d,b
    ld d,b
    ld a,(hl)
    ld b,e
    rst 56
    add a,b
    nop
labDEE7 add a,a
    nop
labDEE9 djnz labDF3B
    ld d,b
labDEEC ld b,b
    add a,a
    nop
labDEEF nop
labDEF0 nop
labDEF1 adc a,h
    nop
    djnz labDF43+2
    ld d,b
    ld b,b
    adc a,h
    nop
labDEF9 nop
    ld bc,lab0088
labDEFD djnz labDF4F
labDEFF ld d,b
    xor d
    sbc a,d
    nop
    ld c,a
    nop
    ld c,a
    nop
    sbc a,d
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    ld h,l
    nop
    adc a,a
    nop
    push bc
    nop
    ld h,l
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labDF3B nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    sbc a,d
    nop
labDF43 jp z,lab8EFF+1
    nop
    adc a,a
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
labDF4F nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    ld c,a
    nop
    ld c,a
    nop
    ld c,a
    nop
    rrca 
    nop
    adc a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    xor d
    rrca 
    nop
    adc a,a
    nop
    ld a,(de)
    nop
    rst 8
    nop
    ld b,l
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    adc a,d
    ld d,l
    rst 8
    nop
    dec h
    nop
    ld h,l
    nop
    ld a,(de)
    nop
    adc a,d
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld b,l
    nop
    dec h
    nop
    sbc a,d
    nop
    adc a,a
    nop
    dec h
    nop
    dec b
    nop
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    nop
    ld a,(de)
    nop
    ld c,a
    nop
    ld a,(de)
    xor d
    sbc a,d
    xor d
    ld h,l
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    sbc a,d
labE000 nop
labE001 nop
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
labE00F nop
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
labE04E nop
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
labE1E7 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE200 nop
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
    nop
    nop
labE29C nop
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
labE2DB nop
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
    nop
    nop
labE300 nop
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
    nop
    nop
    nop
    nop
labE3F3 nop
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
labE400 nop
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
labE4CC nop
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
labE4DC nop
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
    nop
    nop
labE4F0 nop
    nop
    nop
    nop
labE4F4 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE4FC nop
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
    nop
    nop
    nop
    nop
labE600 nop
    ret nz
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp labC100
    nop
    jp labC300
    nop
    jp nz,labC100
    nop
    jp nz,labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    ret nz
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC100
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
labE6A3 jp nz,labC300
    nop
    ret nz
    nop
    ret nz
    nop
    jp labC200
    nop
    ret nz
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
labE6C7 jp nz,labC000
labE6CA nop
labE6CB jp nz,labC300
labE6CE nop
    ret nz
    rst 56
    ret nz
    xor d
labE6D3 jp labC200
    nop
    ret nz
    nop
labE6D9 jp nz,labC100
    nop
labE6DD jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,labC200
    ld d,l
    nop
    rst 56
    djnz labE6A3+2
    jp nz,labC255
    nop
    ret nz
labE700 nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC000
    nop
    jp nz,lab8000
    rst 56
    nop
    rst 56
    ld b,l
    rst 56
    add a,b
    xor d
    jp nz,labC000
    nop
    jp nz,labC100
    nop
    jp labC300
    nop
    jp nz,labC100
    nop
    jp nz,labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    jp nz,labC055
    rst 56
    jp nz,lab00FF
    rst 56
    nop
    rst 56
    nop
    ld d,l
    dec b
    rst 56
    jp nz,labC0FF
    ld d,l
    jp nz,labC155
    nop
    jp labC300
    nop
    ret nz
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC100
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    xor d
    nop
    rst 56
    ld a,(bc)
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    nop
    ld d,l
    ld a,(bc)
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    ld b,l
    rst 56
    nop
    ld d,l
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC200
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    ld a,(bc)
    ld d,l
    nop
    ld d,l
    nop
    rst 56
    nop
    rst 56
    dec b
    rst 56
    nop
    rst 56
    ld a,(bc)
    rst 56
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC300
    nop
    jp labC2AA
    nop
    jp labC300
    nop
    pop bc
    nop
    add a,d
    ld d,l
    adc a,d
    rst 56
    adc a,d
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    ld d,l
    pop bc
    nop
    jp labC300
    nop
    jp nz,labC100
    rst 56
    ld b,b
    ld d,l
labE7FF jp nz,data0000
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
    nop
    nop
labEA8A nop
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
    nop
    nop
labEAF3 nop
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
labEC00 nop
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
labEC98 nop
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
labECD8 nop
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
labECE4 nop
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
labECF0 nop
    nop
    nop
    nop
labECF4 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labECFC nop
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
    nop
    nop
    nop
    nop
labEE00 ld h,a
    nop
    ld h,e
    nop
    jp labC300
    nop
    jp nz,labE300
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    jp labD300
    nop
labEE20 jp labC300
    nop
    ld c,e
    nop
    ld c,a
    nop
    push bc
    nop
    out (#0),a
    out (#0),a
    push bc
    nop
    ld h,a
    nop
    ld h,e
    nop
    jp labC300
    nop
    out (#0),a
    sub (hl)
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp labD300
    nop
    jp labC300
    nop
    ld c,e
    nop
    ld c,a
    nop
    push bc
    nop
    out (#aa),a
    ld a,c
    rst 56
    push bc
    nop
    ld c,a
    nop
    ld h,e
    nop
    jp lab9600
    nop
    jp labC300
    ld d,l
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    jp lab9600
    nop
    jp lab4B00
    nop
    ld h,a
    nop
    ld l,l
    nop
    ld b,b
    rst 56
    nop
    rst 56
    inc a
    xor d
    ld c,a
    nop
    ld c,e
    nop
    ld l,c
    nop
    sub (hl)
    nop
    inc a
    nop
    add a,d
    ld d,l
    nop
    rst 56
    nop
    rst 56
labEEA0 nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    ld h,e
    nop
    ld c,a
    nop
    inc a
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc d
    rst 56
    ld l,l
    nop
    ld c,e
    nop
    inc a
    nop
    sub (hl)
    nop
    inc a
    nop
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
    nop
    sub (hl)
    nop
    inc a
    nop
    ld c,e
    nop
    inc a
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
labEEEE nop
    rst 56
    inc a
    rst 56
    ld c,e
    nop
    inc a
    nop
    sub (hl)
    nop
    ld l,c
    ld d,l
    nop
    rst 56
    nop
labEEFD rst 56
    nop
    rst 56
labEF00 nop
    rst 56
labEF02 nop
    rst 56
labEF04 nop
labEF05 rst 56
labEF06 nop
    rst 56
labEF08 nop
    rst 56
labEF0A nop
    rst 56
    nop
    rst 56
    ld l,c
    ld d,l
    sub (hl)
labEF11 nop
    inc a
    nop
    ld l,c
labEF15 nop
    inc d
labEF17 rst 56
labEF18 nop
    rst 56
    nop
labEF1B rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    ld l,c
labEF23 xor d
    inc a
labEF25 nop
    sub (hl)
labEF27 nop
labEF28 add a,d
labEF29 ld d,l
    nop
labEF2B rst 56
    nop
    rst 56
    nop
labEF2F rst 56
labEF30 nop
labEF31 rst 56
    nop
labEF33 rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
labEF3B rst 56
    nop
labEF3D rst 56
    add a,d
    rst 56
    sub (hl)
    nop
    inc a
labEF43 nop
    ld l,c
labEF45 rst 56
    nop
labEF47 rst 56
    nop
labEF49 rst 56
    nop
labEF4B rst 56
labEF4C nop
    rst 56
labEF4E nop
    rst 56
    nop
labEF51 rst 56
    ld b,c
labEF53 rst 56
labEF54 inc a
    nop
    sub (hl)
    nop
    add a,d
    rst 56
labEF5A nop
    rst 56
    nop
    rst 56
labEF5E nop
labEF5F rst 56
labEF60 nop
    rst 56
    nop
labEF63 rst 56
labEF64 nop
labEF65 rst 56
labEF66 nop
labEF67 rst 56
    nop
labEF69 rst 56
    nop
    rst 56
    nop
    rst 56
labEF6E nop
    rst 56
labEF70 jp lab3C00
labEF73 xor d
labEF74 nop
labEF75 rst 56
    nop
    rst 56
labEF78 nop
    rst 56
labEF7A nop
labEF7B rst 56
labEF7C nop
labEF7D rst 56
labEF7E nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    inc a
    rst 56
    jp lab0055
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    jp lab14FF
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    add a,d
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    xor d
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
labEFEF rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    rst 56
    nop
    ld d,l
    nop
    nop
labF000 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF04E nop
    nop
    nop
    nop
    nop
    nop
    nop
labF055 nop
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
labF0D8 nop
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
labF0E4 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF0EC nop
    nop
    nop
    nop
labF0F0 nop
    nop
    nop
    nop
labF0F4 nop
    nop
    nop
    nop
labF0F8 nop
    nop
    nop
    nop
    nop
    nop
    nop
labF0FF nop
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
labF10C nop
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
labF1F7 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF300 nop
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
    nop
labF335 nop
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
labF379 nop
    nop
labF37B nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF396 nop
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
labF3C7 nop
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
    nop
    nop
    nop
    nop
    nop
labF400 nop
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
labF455 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labF4E4 nop
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
labF4F0 nop
    nop
    nop
    nop
labF4F4 nop
    nop
    nop
    nop
labF4F8 nop
    nop
    nop
    nop
    nop
    nop
    nop
labF4FF nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labF59F nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF5DC nop
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
labF5FF nop
    ld c,a
    rst 8
    ld h,l
    ld c,a
    jr nc,labF669+2
    call m,labF8F0
labF609 call po,lab8FA5
    rst 8
    sbc a,d
    jr nc,labF59F
    sbc a,d
    ld h,l
    ret m
    ret p
    call p,lab30E4
labF617 ld c,a
    rst 8
    ld a,(de)
    jr nc,labF5DC
    push bc
    ld h,l
    ret p
    call p,lab8DF4
    ld a,(de)
    rst 8
    rst 8
    adc a,a
    ld h,b
    ret nz
    ret nz
    dec h
labF62A call p,labF4F4
    ret c
    ld h,l
    ld c,a
    rst 8
    ld h,l
    ret nz
    ret nz
    ret nz
    adc a,a
    ret p
    ret p
    ret p
    sbc a,b
    rrca 
    rst 8
    rst 8
    jr nc,labF5FF
    ret nz
    ret nz
    ret nz
    ret p
    ret p
    call po,lab65E1
    ld c,a
    rst 8
    jr nc,labF609+2
    ret nz
    ret nz
    add a,b
    call m,labF0F4
    sbc a,b
    adc a,a
    ld c,a
    rst 8
    jr nc,labF617
    ret nz
    ret nz
    nop
    call p,labE4F4
    sbc a,b
    ld c,a
    rst 8
    rst 8
    ld h,b
    ret nz
    ret nz
    push bc
    nop
    call p,labF0F0
labF669 call po,labCF8F
    adc a,a
    jp z,labC5C0
    rst 8
    dec b
    ret p
    call p,lab98F0
    ld c,a
    rst 8
    sbc a,d
    ld c,d
    ret nz
    rst 8
labF67C adc a,d
    nop
    call p,labE4F0
    sbc a,b
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    push bc
    rst 8
    adc a,d
    ld b,l
    ret p
    ret p
    call po,lab4FE4
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
    adc a,d
    nop
    ret p
    ret p
    ret m
    sbc a,b
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
labF6A0 dec b
    nop
    ret m
    ret p
    ret m
    adc a,l
    ld c,a
    rst 8
    sbc a,d
    ld h,b
    rst 8
    rst 8
    nop
    nop
    call p,labECF0
labF6B1 sbc a,b
    adc a,a
    rst 8
    rst 8
    jr nc,labF67C
    rst 8
    nop
    nop
    ret p
    ret p
    call pe,lab65E3+1
    ld c,a
    adc a,a
    rst 8
    push bc
    rst 8
    ld b,l
    dec b
    ret p
    call p,lab98EC
    rrca 
    rst 8
    rst 8
    rrca 
    push bc
    rst 8
    nop
    nop
    ret p
    ret p
    ret p
    call z,lab4F65
    rst 8
    jr nc,labF6A0
    rst 8
    adc a,d
    nop
    ret p
    call p,labD8F0
    dec h
    rst 8
    rst 8
    jr nc,labF6B1
    rst 8
    adc a,d
    ld b,l
    ret m
    call p,labCCF0
labF6EE sbc a,b
    ld c,a
    rst 8
    sbc a,d
    jp z,lab8ACD+2
    nop
    ret p
    ret p
    call p,labB0E4
    adc a,a
    rst 8
    sbc a,d
    rst 8
    push bc
labF700 adc a,d
    nop
labF702 call p,labF4F0
    ret m
    adc a,l
    ld c,a
    ld c,a
    rst 8
    adc a,a
    push bc
    adc a,d
    ld a,(bc)
    ret p
    ret p
    ret p
    ret p
    sbc a,b
    dec h
    rst 8
    rst 8
    ld a,(de)
    ld h,b
    adc a,d
    nop
    ret p
    ret p
    ret p
    call p,lab65CB+1
    ld c,a
    rst 8
    jr nc,labF6EE
    rst 8
    nop
    call p,labF8F0
    call p,lab0FD8
    adc a,a
    rst 8
    rst 8
    ld a,(de)
    push bc
    nop
    call p,labF0F0
    call p,lab30E4
    ld c,a
    ld c,a
    rst 8
    jr nc,labF702
    adc a,d
labF73E call p,labF0F0
    call p,lab8DF8
    dec h
    adc a,a
    rst 8
    sbc a,d
    ld h,b
    adc a,d
    ret p
    ret p
    ret m
    ret m
    ret m
    sbc a,b
    ld c,a
    ld c,a
    ld c,a
    rst 8
    ld h,b
    rst 8
    ret p
    ret p
    call p,labFCF0
    call po,lab8F25
    adc a,a
    rst 8
    sbc a,d
    ret nz
    ret m
    call p,labF0F0
    ret p
    call po,lab6598
    ld c,a
    ld c,a
labF76C rst 8
    ld h,b
    ret p
labF76F call p,labF0F0
    call p,lab98F0
labF775 ld a,(de)
    adc a,a
    adc a,a
    ld c,a
    rst 8
    call p,labF8F0
    ret p
    call p,labCCF4
    ld h,l
    ld c,a
    ld c,a
    rrca 
    rst 8
    call p,labF8F0
    call p,labF8F0
    call po,lab8FA5
    adc a,a
    adc a,a
    ld c,a
    call m,labF0F0
    ret p
    ret p
    call m,lab8DF0
    ld h,l
    ld c,a
    ld c,a
    rrca 
    ret m
    call p,labF8F0
    ret m
    ret p
    call po,lab30B0
    adc a,a
    adc a,a
    adc a,a
    ret p
    call p,labF0F0
    ret p
    call p,lab98F8
    ld a,(de)
    ld c,a
    ld c,a
    rrca 
    adc a,a
    rrca 
    rst 8
    adc a,a
    ld c,(hl)
    ret c
    ret c
    call p,labF8F4
    ret m
    ret p
    rrca 
    rst 8
    rst 8
    rst 8
    adc a,a
    jp c,labF04E
    ret p
    call p,labF8F8
    ld c,a
    jr nc,labF836
    ld c,a
    rst 8
labF7D3 ld c,a
    ld (hl),b
    ret c
    ret p
    ret p
    ret m
    ret p
    sbc a,d
    jr nc,labF76C
    sbc a,d
    rst 8
    adc a,a
    adc a,a
    call po,labF0F4
    ret p
    call p,lab659A
    ld c,a
    jr nc,labF850
    rst 8
    ld c,a
    ld e,d
    ret c
    call p,labFCF0
    sbc a,d
    jp z,lab30C0
    dec h
    rst 8
    adc a,a
    jr nc,labF7D3
    ret m
    ret p
    call p,labC01A
labF800 nop
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
    nop
    nop
labF836 nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF850 nop
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
labF89F nop
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
labF8E4 nop
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
labF8F0 nop
    nop
    nop
    nop
labF8F4 nop
    nop
    nop
    nop
labF8F8 nop
    nop
    nop
    nop
labF8FC nop
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
    nop
    nop
    nop
    nop
    nop
    nop
labFC00 nop
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
    nop
    nop
    nop
labFCE1 nop
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
labFCF0 nop
    nop
    nop
    nop
labFCF4 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFCFC nop
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
    nop
    nop
    nop
    nop
labFE00 ret nz
    rst 56
    ret nz
    rst 56
    rst 56
    or (hl)
    sub h
    sub h
    sub h
    ld l,b
    ld a,c
    rst 56
    di
    jp pe,labC0C0
    ret nz
    ret nz
    push de
    di
    jp labC0C0
    ret nz
    ret nz
    ret nz
    ret nz
    sub (hl)
    ret nz
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    ret nz
    ret nz
    ret nz
    rst 8
    jp z,labC0C0
    ret nz
    ret nz
    ret nz
    jp labE3F3
    sub (hl)
    inc a
    jp lab81C0
    out (#f3),a
    di
    sub (hl)
    inc a
    jp labC042
    ei
    ei
    rst 48
    jp labC3C3
    ret nz
    ret nz
    ei
    rst 56
    di
    inc a
    inc a
    inc a
    ret nz
    ld l,b
labFE4D jp pe,labEAF3
    ld l,b
    ret nz
    ret nz
    sub h
    ld l,b
    rst 56
    ret nz
    pop de
    ld l,b
    ret nz
    ret nz
    sub h
    ld l,b
    sub c
    inc sp
    ld h,d
    add hl,sp
    inc sp
    ld h,d
    sub h
    ld l,b
    inc sp
    inc sp
    inc sp
    ld (hl),a
    ei
    inc sp
    sub h
    ld l,b
    rst 8
    rst 8
    rst 8
    rst 48
    rst 48
    or d
    sub h
    inc a
    ret nz
    ret nz
    ret nz
    rst 48
    di
    and (hl)
    inc a
    ld l,c
    rst 8
    rst 8
    rst 8
    di
    ei
    or d
    sub (hl)
    ld l,c
    push bc
    push bc
    push bc
    ei
    di
    ld e,l
    sub (hl)
    ld l,c
    rst 8
    jp z,labAECF
    inc c
labFE92 ld (hl),l
    sub (hl)
    ld l,c
    rst 8
    rst 8
    rst 8
    sbc a,d
    jr labFE92
    sub (hl)
    ld l,c
    ret nz
    jp z,labCFC5
    ld d,c
    rst 56
    sub (hl)
    ld l,c
    rst 8
    rst 8
    rst 8
    inc c
    di
    rst 56
    sub (hl)
    ld l,c
labFEAD jp labC3C3
    jr labFEAD
    ex de,hl
    sub (hl)
    inc a
    inc a
    inc a
    inc a
    inc c
    rst 48
    inc a
    inc a
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,b
    ld l,c
    ld l,c
    inc a
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,b
    ld l,c
    ld l,c
    inc a
    inc a
    inc a
    inc a
    inc a
    ld l,b
    inc a
    inc a
    inc a
    ret nz
    ret nz
    nop
    nop
    ld b,b
    nop
    ret nz
    ret nz
    ld b,b
    add a,b
    nop
    nop
    ld b,b
    nop
    ld b,b
    add a,b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFEFE nop
    nop
labFF00 nop
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
labFF33 nop
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
labFF55 nop
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
labFF87 nop
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
    nop
    nop
    nop
labFFE0 nop
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
labFFFF nop
',
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
