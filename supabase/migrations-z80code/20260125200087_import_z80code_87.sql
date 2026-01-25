-- Migration: Import z80code projects batch 87
-- Projects 173 to 174
-- Generated: 2026-01-25T21:43:30.208359

-- Project 173: army_moves1 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'army_moves1',
    'Imported from z80Code. Author: siko. Army Moves Part 1',
    'public',
    false,
    false,
    '2020-06-28T11:21:17.668000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org 0
run start_m0

data0000 db #c9
lab0001 db #89
lab0002 db #7f
lab0003 db #ed
lab0004 db #49
lab0005 db #c3
lab0006 db #91
lab0007 db #5
lab0008 db #c3
lab0009 db #8a
lab000A db #b9
lab000B db #c3
lab000C db #84
db #b9,#c5,#c9
lab0010 db #c3
db #1d
lab0012 db #ba
db #c3
lab0014 db #17
db #ba,#d5,#c9
lab0018 db #c3
lab0019 db #c7
lab001A db #b9
db #c3,#b9,#b9
lab001E db #e9
db #00
lab0020 db #c3
db #c6,#ba,#c3,#c1,#b9
lab0026 db #0
db #00,#c3,#35
lab002A db #ba
db #00,#ed,#49,#d9,#fb ;..I..
lab0030 db #c7
db #d9,#21
lab0033 db #2b
lab0034 db #0
db #71,#18,#08 ;q..
lab0038 db #c3
lab0039 db #11
db #75 ;u
lab003B db #c9
lab003C db #0
db #00,#00,#00
lab0040 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab0060 db #0
lab0061 db #0
lab0062 db #0
lab0063 db #0
lab0064 db #0
lab0065 db #0
lab0066 db #0
db #00
lab0068 db #0
db #00
lab006A db #0
db #00
lab006C db #0
db #00
lab006E db #0
db #00,#00,#00
lab0072 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab007C db #0
db #00
lab007E db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab0092 db #0
db #00
lab0094 db #0
db #00
lab0096 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab00A6 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab00B0 db #0
db #00
lab00B2 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab00CA db #0
db #00
lab00CC db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab00FA db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab012C db #0
db #00
lab012E db #0
db #00,#00,#00,#00,#00,#00,#00,#c3
db #44,#01,#cd,#88,#90,#3e,#02,#cd ;D.......
db #6a,#78,#c3,#b9,#74,#2a,#d1,#88 ;jx..t...
db #eb,#3e,#c9,#12,#cd,#6f,#74,#21 ;.....ot.
db #0c,#7b,#eb,#3e,#40,#12,#21,#94
db #2a,#eb,#3e,#05,#12,#21,#6e,#37 ;......n.
db #eb,#3e,#02,#12,#13,#3e,#fe,#12
db #13,#3e,#06,#12,#13,#3e
lab016D db #5
lab016E db #12
lab016F db #13
lab0170 db #3e
lab0171 db #4
lab0172 db #12
db #13,#3e,#04,#12,#13,#3e,#02,#12
db #13,#3e,#02,#12,#13,#3e,#01,#12
db #13,#3e,#00,#12,#13,#3e,#ff,#12
db #13,#3e,#fe,#12,#13,#3e,#fe,#12
db #13,#3e,#fc,#12,#13,#3e,#fc,#12
db #13,#3e,#fb,#12,#13,#3e,#fa,#12
db #21,#ef,#38,#eb,#3e,#00,#12,#13
db #3e,#28,#12,#13,#3e,#0a,#12,#13
db #3e,#14,#12,#13,#3e,#30,#12,#21
db #61,#3a,#eb,#3e,#19,#12,#13,#3e ;a.......
db #30,#12,#13,#3e,#14,#12,#13,#3e
db #2a,#12,#13,#3e,#44,#12,#21,#d3 ;....D...
db #3b,#eb,#3e,#34,#12,#13,#3e,#30
db #12,#13,#3e,#14,#12,#13,#3e,#23
db #12,#13,#3e,#34,#12,#21,#45,#3d ;......E.
db #eb,#3e,#43,#12,#13,#3e,#30,#12 ;..C.....
db #13,#3e,#14,#12,#13,#3e,#23,#12
db #13,#3e,#34,#12,#21,#3c,#37,#01
db #20,#00,#09,#eb,#3e,#ff,#12,#21
db #8f,#75,#eb,#3e,#00,#12,#21,#14 ;.u......
db #37,#01,#1e,#00,#cd,#8e,#75,#21 ;......u.
db #0f,#37,#eb,#3e,#30,#12,#13,#3e
db #32,#12,#13,#3e,#34,#12,#13,#3e
db #32,#12,#13,#3e,#30,#12,#21,#ce
db #36,#eb,#3e,#00,#12,#13,#3e,#00
db #12,#13,#3e,#00,#12,#13,#3e,#00
db #12,#13,#3e,#00,#12,#13,#3e,#3a
db #12,#13,#3e,#03,#12,#13,#3e,#f8
db #12,#13,#3e,#04,#12,#13,#3e,#00
db #12,#13,#3e,#5c,#12,#13,#3e,#03
db #12,#13,#3e,#fc,#12,#13,#3e,#05
db #12,#13,#3e,#00,#12,#13,#3e,#66 ;.......f
db #12,#13,#3e,#fd,#12,#13,#3e,#02
start_m0:
ld bc,#7f8c
out (c),c
jp #355


;db #12,#13,#3e,#00,#12,#13,#3e,#00
;db #12,#c3,#55,#03 ;..U.

org #287
lab0287 call lab8294
    ld a,(lab88D3)
    ld e,a
    ld a,#2
    cp e
    jp nz,lab02A1
    call lab0874
    ld a,(lab88D5)
    or a
    jp nz,lab02A1
    call lab05EA
lab02A1 call lab149F
    call lab107D
    call lab19EA
    call lab17E6
    call lab126B
    call lab0D52
    call lab0EC9
    ld a,(lab88D7)
    or a
    jp z,lab02C0
    call lab13AB
lab02C0 ld hl,lab7B1D
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab02CE
    jp start_355
lab02CE ld hl,lab7B1E
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab02DE
    ld a,#0
    call lab7835
lab02DE ld a,#38
    call lab76A9
    or a
    jp nz,lab02EA
    call lab04EC
lab02EA ld a,(lab88D9)
    or a
    jp z,lab02F4
    call lab0995
lab02F4 ld a,(lab88D5)
    or a
    jp z,lab02FE
    jp start_355
lab02FE ld a,(lab88DB)
    ld e,a
    ld a,#4a
    cp e
    jp nc,lab031E
    ld a,(lab88DB)
    ld e,a
    ld a,#80
    cp e
    jp c,lab031E
    ld a,(lab88DD)
    or a
    jp nz,lab031E
    ld a,#1
    ld (lab88DD),a
lab031E ld a,(lab88D3)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab032B
    call lab15E3
lab032B ld a,(lab88D3)
    ld hl,lab88DF
    ld c,(hl)
    or c
    or a
    jp nz,lab033D
    call lab21EA
    call lab0346
lab033D call lab0B25
    call lab82A6
    jp lab0287
lab0346 ld a,(lab88E1)
    or a
    jp nz,lab0351
    call lab3DB7
    ret 
lab0351 call lab3DC9
    ret 
start_355 ld hl,lab2A9D
    ld (lab0064),hl
    call lab714A
    ld hl,lab88D1
lab0361 ld bc,lab00FA
    call lab758E
    ld hl,lab3C0C
    ld (lab88E3),hl
    ld hl,lab8282
    ex de,hl
    ld a,#0
    ld (de),a
    ld a,#1
    ld (lab88E5),a
    ld a,#35
    ld (lab88E7),a
    ld hl,lab0026
    ld (lab88E9),hl
    ld hl,lab7B0C
    ld a,(hl)
    ld (lab88DB),a
    ld a,#4
    ld (lab88EB),a
    ld hl,lab04B0
    ld (lab88ED),hl
    call lab21AE
    call lab218B
    ld a,#a
    ld e,a
    ld a,#9
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld sp,lab542D
    ld b,l
    ld b,e
    ld c,h
    ld b,c
    ld b,h
    ld c,a
    nop
    ld a,#c
    ld e,a
    ld a,#9
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld (lab4A2D),a
    ld c,a
    ld e,c
    ld d,e
    ld d,h
    ld c,c
    ld b,e
    ld c,e
    nop
    ld a,#a
    ld e,a
    ld a,#18
    ld d,a
    ld (lab0060),de
    call lab79B5
    inc sp
    dec l
    ld c,d
    ld d,l
    ld b,a
    ld b,c
    ld d,d
    nop
    ld a,#c
    ld e,a
    ld a,#18
    ld d,a
    ld (lab0060),de
    call lab79B5
    inc (hl)
    dec l
    ld c,l
    ld d,l
    ld d,e
    ld c,c
    ld b,e
    ld b,c
    nop
    call lab3DFA
    call lab0723
    ld a,#12
    ld e,a
    ld a,#8
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld d,b
    ld d,d
    ld c,a
    ld b,a
    ld d,d
    ld b,c
    ld c,l
    ld b,c
    jr nz,lab0462+1
    ld c,a
    ld d,d
    jr nz,lab046C+1
    ld c,c
    ld b,e
    ld d,h
    ld c,a
    ld d,d
    jr nz,lab046E+2
    ld d,l
    ld c,c
    ld e,d
    nop
    ld a,#14
    ld e,a
    ld a,#6
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld b,e
    ld c,a
    ld d,b
    ld e,c
    ld d,d
    ld c,c
    ld b,a
    ld c,b
    ld d,h
    jr nz,lab047E
    ld c,c
    ld c,(hl)
    ld b,c
    ld c,l
    ld c,c
    ld b,e
    jr nz,lab0495
    ld c,a
    ld b,(hl)
    ld d,h
    ld l,#20
    ld sp,lab3839
    ld (hl),#0
    call lab0A17
    call lab3DFA
lab0452 call lab8294
    call lab1336
    ld hl,lab7B0C
    ex de,hl
    ld a,(lab88DB)
    ld (de),a
    ld a,#40
lab0462 call lab76A9
    or a
    jp nz,lab0471
    call lab0519
lab046C ld a,#40
lab046E ld (lab88DB),a
lab0471 ld a,#41
    call lab76A9
    or a
    jp nz,lab04A2
    ld hl,lab7B17
    ex de,hl
lab047E ld a,#4b
    ld (de),a
    inc de
    ld a,#4a
    ld (de),a
    inc de
    ld a,#48
    ld (de),a
    inc de
    ld a,#2f
    ld (de),a
    inc de
    ld a,#49
    ld (de),a
    inc de
    ld a,#4c
    ld (de),a
lab0495 inc de
    ld a,#42
    ld (de),a
    inc de
    ld a,#2c
    ld (de),a
    ld a,#50
    ld (lab88DB),a
lab04A2 ld a,#39
    call lab76A9
    or a
    jp nz,lab04AE
    jp lab059F
lab04AE ld a,#38
lab04B0 call lab76A9
    or a
    jp nz,lab04BA
    call lab04EC
lab04BA ld a,(lab88DB)
    ld (lab88EF),a
    ld a,#23
    ld (lab88DB),a
    ld a,#1e
    ld (lab88EB),a
    ld a,#3
    ld (lab88E1),a
    call lab19EA
    call lab17E6
    call lab0D52
    call lab0EC9
    ld a,(lab88EF)
    ld (lab88DB),a
    ld a,#4
    ld (lab88EB),a
    call lab82A6
    jp lab0452
lab04EC ld a,(lab88F1)
    or a
    jp nz,lab04FE
    call lab7148
    ld a,#1
    ld (lab88F1),a
    jp lab050C
lab04FE ld hl,lab2A9D
    ld (lab0064),hl
    call lab714A
    ld a,#0
    ld (lab88F1),a
lab050C ld a,#38
    call lab76A9
    or a
    jp nz,lab0518
    jp lab050C
lab0518 ret 
lab0519 call lab82A6
    ld hl,data0000
    ld (lab007E),hl
    ld a,#40
    call lab76A9
    or a
    jp nz,lab052E
    jp lab0519
lab052E ld a,#0
    ld (lab007E),a
    ld a,#7
    ld (lab00B2),a
lab0538 ld a,#e
    ld e,a
    ld a,#10
    ld d,a
    ld (lab0060),de
    call lab79B5
    jr nz,lab0547
lab0547 ld a,#0
    ld (lab007C),a
    ld a,#8
    ld (lab00B0),a
lab0551 ld hl,(lab007E)
    ld bc,lab0009
    call lab77DB
    ld bc,lab28A0
    add hl,bc
    ld bc,(lab007C)
    add hl,bc
    ld a,(hl)
    ld (lab0064),a
    ld a,(lab0064)
    call lab79C0
    ld hl,lab007C
    inc (hl)
    ld a,(lab00B0)
    cp (hl)
    jp nc,lab0551
    ld a,#0
    call lab7835
    ld hl,lab7B17
    ld bc,(lab007E)
    add hl,bc
    ex de,hl
    ld hl,lab0062
    ld a,(hl)
    ld (de),a
    ld a,#ac
    ld (lab88F3),a
    call lab2282
    ld hl,lab007E
    inc (hl)
    ld a,(lab00B2)
    cp (hl)
    jp nc,lab0538
    ret 
lab059F ld hl,lab09C2+2
    ld (lab88F5),hl
    ld hl,lab8282
    ex de,hl
    ld a,#1
    ld (de),a
    ld a,#0
    ld (lab88E5),a
    ld hl,lab7B0C
    ex de,hl
    ld a,(lab88DB)
    ld (de),a
    call lab21AE
    ld hl,lab000C
    ld (lab88E9),hl
    ld a,#30
    ld (lab88DB),a
    ld a,#a
    ld (lab88EB),a
    call lab217E
    call lab075D
    call lab07AE
    ld a,#0
    ld (lab88E1),a
    call lab05EA
    ld hl,lab012E
    ex de,hl
    ld hl,data0000
    call lab76ED
    jp lab0287
lab05EA ld hl,lab1DA4+2
    ld (lab88F7),hl
    call lab06D5
    ld a,#0
    ld (lab88F9),a
    ld a,#0
    ld (lab88FB),a
    ld a,#0
    ld (lab88FD),a
    ld a,#0
    ld (lab88FF),a
    ld a,#0
    ld (lab8901),a
    ld a,#0
    ld (lab88D7),a
    ld a,#0
    ld (lab8903),a
    ld a,#0
    ld (lab88D3),a
lab061B ld hl,lab0172
    ld bc,(lab88E1)
    call lab77DB
    ld bc,lab3782
    add hl,bc
    ld (lab8905),hl
    ld hl,data0000
    ld (lab8907),hl
    ld hl,(lab8905)
    ld bc,lab016D
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab8907),hl
    ld hl,(lab8905)
    ld bc,lab016E
    add hl,bc
    ld a,(hl)
    ld (lab8909),a
    ld hl,(lab8905)
    ld bc,lab016F
    add hl,bc
    ld a,(hl)
    ld (lab890B),a
    ld hl,(lab8905)
    ld bc,lab0170
    add hl,bc
    ld a,(hl)
    ld (lab88EB),a
    ld hl,(lab8905)
    ld bc,lab0171
    add hl,bc
    ld a,(hl)
    ld (lab88DB),a
    call lab1FCC
    ld hl,lab373C
    ld bc,lab0020
    call lab758E
    ld hl,lab373C
    ld bc,lab0020
    add hl,bc
    ex de,hl
    ld a,#ff
    ld (de),a
    ld hl,data0000
    ld (lab007E),hl
    ld hl,lab0003
    inc hl
    ld (lab00B2),hl
lab068F call lab223A
    ld a,#0
    ld (lab890D),a
    call lab1421
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab068F
    ld a,#c
    ld (lab88E9),a
    ld a,#0
    ld (lab88DF),a
    ld a,(lab88E1)
    or a
    jp z,lab06CB
    ld a,#0
    ld (lab890F),a
    ld a,#0
    ld (lab8911),a
    ld a,#1
    ld (lab88DF),a
lab06CB call lab0723
    call lab8294
    call lab149F
    ret 
lab06D5 ld hl,lab741B+1
    ex de,hl
    ld hl,lab7B70
    call lab76ED
    ld hl,lab000C
    ld (lab8913),hl
    ld a,(lab88E1)
    or a
    jp z,lab06F2
    ld hl,lab0006
    ld (lab8913),hl
lab06F2 ld hl,lab0018
    ld (lab006C),hl
    ld hl,lab000A
    ld (lab006E),hl
    ld hl,lab0064
    ex de,hl
    ld a,#88
    ld (de),a
    inc de
    ld a,#14
    ld (de),a
    ld hl,(lab8913)
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld bc,lab0002
    add hl,bc
    ld (lab0066),hl
    call lab7429
    ret 
lab0723 ld hl,lab758E+1
    ex de,hl
    ld a,#0
    ld (de),a
    ld hl,lab36EC
    ld bc,lab0014
    call lab758E
    ld hl,lab36EC
    ld bc,lab0014
    add hl,bc
    ex de,hl
    ld a,#ff
    ld (de),a
    ld hl,lab3D54
    ld bc,lab0030
    call lab758E
    ld hl,lab3714
    ld bc,lab001E
    call lab758E
    ret 
lab0751 ld a,(lab88E7)
    ld c,#1
    sub c
    ld (lab88E7),a
    call lab0723
lab075D ld a,#12
    ld e,a
    ld a,#6
    ld d,a
    ld (lab0060),de
    call lab79B5
    jr nc,lab076C
lab076C ld a,(lab88E7)
    call lab79C0
    ld a,(lab88E7)
    ld e,a
    ld a,#30
    cp e
    jp nc,lab077D
    ret 
lab077D call lab080F
    ld a,#8
    ld e,a
    ld a,#7
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld c,b
    ld b,c
    ld d,e
    jr nz,lab07E1+1
    ld b,l
    ld d,d
    ld b,h
    ld c,c
    ld b,h
    ld c,a
    jr nz,lab07EE
    ld d,l
    ld d,e
    jr nz,lab07E1+2
    ld b,(hl)
    ld b,l
    ld b,e
    ld d,h
    ld c,c
    ld d,(hl)
    ld c,a
    ld d,e
    ld l,#0
    ld a,#0
    call lab7835
    ret 
lab07AE ld hl,lab7906
    ex de,hl
    ld a,#18
    ld (de),a
    ld hl,lab73A0
    ex de,hl
    ld a,#1
    ld (de),a
    ld a,#13
    ld e,a
    ld a,#13
    ld d,a
    ld (lab0060),de
    ld hl,(lab8915)
    call lab7900
    call lab79B5
    jr nc,lab07D1
lab07D1 ld hl,(lab88F5)
    ex de,hl
    ld hl,(lab8915)
    xor a
    sbc hl,de
    jp c,lab080E
    ld hl,(lab88F5)
lab07E1 ld bc,lab09C2+2
    add hl,bc
    ld (lab88F5),hl
    ld a,(lab88E7)
    ld e,a
    ld a,#35
lab07EE cp e
    jp c,lab080E
    ld a,#1
    ld (lab88D9),a
    ld a,#4
    ld (lab8917),a
    ld a,#1
    ld (lab8919),a
    ld hl,lab2CEC
    ld bc,lab0064
    add hl,bc
    ld (lab0066),hl
    call lab2282
lab080E ret 
lab080F ld a,#1
    ld (lab88D5),a
    call lab877E
    call lab8294
    call lab82A6
    ld a,#6
    ld e,a
    ld a,#9
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld c,h
    ld b,c
    jr nz,lab087B
    ld c,c
    ld d,e
    ld c,c
    ld c,a
    ld c,(hl)
    jr nz,lab087B+2
    ld b,c
    jr nz,lab087E
    ld d,d
    ld b,c
    ld b,e
    ld b,c
    ld d,e
    ld b,c
    ld b,h
    ld c,a
    nop
    ret 
lab0842 call lab877E
    call lab8294
    call lab82A6
    ld a,#8
    ld e,a
    ld a,#8
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld c,b
    ld b,l
    ld c,h
    ld c,c
    ld b,e
    ld c,a
    ld d,b
    ld d,h
    ld b,l
    ld d,d
    ld c,a
    jr nz,lab08B7+1
    ld c,c
    ld c,(hl)
    jr nz,lab08AE+2
    ld b,c
    ld d,e
    ld c,a
    ld c,h
    ld c,c
    ld c,(hl)
    ld b,c
    nop
    jp lab21BD
lab0874 ld hl,lab73A0
    ex de,hl
    ld a,#0
    ld (de),a
lab087B call lab877E
lab087E call lab8294
    call lab82A6
    ld a,(lab88E1)
    ld c,#1
    add a,c
    ld (lab88E1),a
    ld a,#8
    ld e,a
    ld a,#b
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld b,e
    ld c,a
    ld c,l
    ld d,b
    ld c,h
    ld b,l
    ld d,h
    ld b,c
    ld b,h
    ld b,c
    jr nz,lab08EC
    ld b,c
    ld d,e
    ld b,l
    jr nz,lab08AB
lab08AB ld a,(lab88E1)
lab08AE call lab78FD
    call lab08F5
    call lab08BA
lab08B7 jp lab21BD
lab08BA ld a,(lab88E1)
    ld e,a
    ld a,#4
    cp e
    jp nz,lab08F4
    ld a,#5
    call lab7835
    ld a,#a
    ld e,a
    ld a,#8
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld b,e
    ld c,a
    ld b,h
    ld c,c
    ld b,a
    ld c,a
    jr nz,lab092E
    ld b,c
    ld d,d
    ld b,c
    jr nz,lab092F
    ld c,a
    ld b,c
    ld b,h
    dec sp
    jr nz,lab08E9
lab08E9 ld hl,(lab88E3)
lab08EC call lab7900
    ld a,#1
    ld (lab88D5),a
lab08F4 ret 
lab08F5 ld a,(lab88FB)
    or a
    jp z,lab095B
    ld a,(lab88FB)
    ld c,#1
    sub c
    ld (lab88FB),a
    ld hl,lab73A0
    ex de,hl
    ld a,#1
    ld (de),a
    ld hl,(lab88FB)
    ld bc,lab0064
    call lab77DB
    ld (lab891B),hl
    ld a,#d
    ld e,a
    ld a,#9
    ld d,a
    ld (lab0060),de
    call lab79B5
    ld b,d
    ld c,a
    ld c,(hl)
    ld d,l
    ld d,e
    jr nz,lab096C+1
    ld d,h
    ld b,l
lab092E ld d,d
lab092F ld d,d
    ld c,c
    ld e,d
    ld b,c
    ld c,d
    ld b,l
    jr nz,lab0937
lab0937 ld hl,(lab891B)
    call lab7900
    ld hl,(lab8915)
    ld bc,lab0064
    add hl,bc
    ld (lab8915),hl
    call lab07AE
    ld a,#a8
    ld (lab88F3),a
    call lab2282
    ld a,(lab88FB)
    ld c,#1
    add a,c
    call lab7835
lab095B ld a,(lab88D9)
    or a
    jp z,lab0965
    call lab0995
lab0965 ld a,(lab88FB)
    or a
    jp nz,lab0992
lab096C ld a,#d
    ld e,a
    ld a,#9
    ld d,a
    ld (lab0060),de
    call lab79B5
    jr nz,lab0999+2
    jr nz,lab099C+1
    jr nz,lab099F
    jr nz,lab099F+2
    jr nz,lab09A3
    jr nz,lab09A5
    jr nz,lab09A6+1
    jr nz,lab09A9
    jr nz,lab09AB
    jr nz,lab09AB+2
    jr nz,lab09AE+1
    jr nz,lab0991
lab0991 ret 
lab0992 jp lab08F5
lab0995 ld hl,lab741B+1
    ex de,hl
lab0999 ld hl,lab7B70
lab099C call lab76ED
lab099F ld a,(lab8917)
    ld e,a
lab09A3 ld a,#4
lab09A5 cp e
lab09A6 jp nz,lab09B1
lab09A9 ld a,#6
lab09AB ld (lab8917),a
lab09AE jp lab09B6
lab09B1 ld a,#4
    ld (lab8917),a
lab09B6 ld hl,data0000
    ld (lab8913),hl
    ld a,(lab8917)
    ld (lab8913),a
lab09C2 ld hl,lab0010
    ld (lab006C),hl
    ld hl,lab0010
    ld (lab006E),hl
    ld hl,lab0064
    ex de,hl
    ld a,#80
    ld (de),a
    inc de
    ld a,#24
    ld (de),a
    ld hl,(lab8913)
    ld bc,lab711C
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab685C
    add hl,bc
    ld bc,lab0002
    add hl,bc
    ld (lab0066),hl
    call lab7429
    ld a,(lab88D9)
    ld c,#1
    add a,c
    ld (lab88D9),a
    ld a,(lab88D9)
    ld e,a
    ld a,#10
    cp e
    jp nc,lab0A16
    ld a,(lab88E7)
    ld c,#1
    add a,c
    ld (lab88E7),a
    call lab075D
    ld a,#0
    ld (lab88D9),a
lab0A16 ret 
lab0A17 call lab3DFA
    ld hl,data0000
    ld (lab007E),hl
    ld hl,lab0040
    inc hl
    ld (lab00B2),hl
lab0A27 call lab8294
    ld hl,lab0064
    ex de,hl
    ld a,#c8
    ld hl,lab007E
    ld c,(hl)
    add a,c
    ld (de),a
    inc de
    ld a,#6
    ld (de),a
    ld hl,lab2DB0
    ld (lab0066),hl
    call lab80E8
    call lab82A6
    ld hl,(lab007E)
    ld bc,lab0003
    add hl,bc
    ld (lab007E),hl
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab0A27
    ret 
data0a62 db #21
db #1c,#74,#eb,#21,#da,#85,#cd,#ed ;.t......
db #76,#21,#40,#00,#22,#6c,#00,#21 ;v....l..
db #30,#00,#22,#6e,#00,#21,#64,#00 ;...n..d.
db #eb,#3e,#00,#12,#13,#3e,#06,#12
db #cd,#24,#74,#21,#00,#00,#22,#7e ;..t.....
db #00,#21,#40,#00,#23,#22,#b2,#00
db #cd,#94,#82,#21,#64,#00,#eb,#3e ;....d...
db #c8,#21,#7e,#00,#4e,#91,#0e,#40 ;....N...
db #81,#12,#13,#3e,#06,#12,#21,#b0
db #2d,#22,#66,#00,#cd,#e8,#80,#cd ;..f.....
db #a6,#82,#2a,#7e,#00,#01,#03,#00
db #09,#22,#7e,#00,#2a,#7e,#00,#23
db #22,#7e,#00,#ed,#5b,#b2,#00,#af
db #ed,#52,#da,#93,#0a,#21,#00,#00 ;.R......
db #22,#7e,#00,#21,#40,#00,#23,#22
db #b2,#00,#cd,#94,#82,#21,#64,#00 ;......d.
db #eb,#3e,#c8,#21,#7e,#00,#4e,#81 ;......N.
db #12,#13,#3e,#12,#12,#21,#10,#27
db #22,#66,#00,#cd,#e8,#80,#cd,#a6 ;.f......
db #82,#2a,#7e,#00,#01,#01,#00,#09
db #22,#7e,#00,#2a,#7e,#00,#23,#22
db #7e,#00,#ed,#5b,#b2,#00,#af,#ed
db #52,#da,#dd,#0a,#3e,#00,#cd,#35 ;R.......
db #78,#21,#00,#00,#01,#50,#c3,#cd ;x....P..
db #8e,#75 ;.u
lab0B25 ld hl,lab73A0
    ex de,hl
    ld a,#1
    ld (de),a
    ld a,#13
    ld e,a
    ld a,#1d
    ld d,a
    ld (lab0060),de
    ld hl,(lab88F7)
    call lab7900
    ret 
lab0B3D ld a,(lab88DD)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab0B56
    ld a,(lab88EB)
    ld (lab891D),a
    ld a,(lab88DB)
    ld (lab891F),a
    call lab0F88
lab0B56 ld a,(lab88DD)
    ld c,#1
    add a,c
    ld (lab88DD),a
    ld a,(lab88DD)
    ld e,a
    ld a,#3
    cp e
    jp c,lab0B6C
    call lab1336
lab0B6C ld a,(lab88DD)
    ld e,a
    ld a,#6
    cp e
    jp c,lab0B77
    ret 
lab0B77 ld a,(lab88F9)
    or a
    jp z,lab0B81
    call lab0842
lab0B81 call lab0751
    ld a,#0
    ld (lab88DD),a
    jp lab05EA
lab0B8C call lab0E14
    ld a,(lab8921)
    or a
    jp nz,lab0BAD
    ld a,(lab8923)
    ld c,#3
    add a,c
    ld (lab8923),a
    ld a,(lab8925)
    ld c,#4
    sub c
    ld (lab8925),a
    ld a,#2a
    ld (lab8927),a
lab0BAD ld a,(lab8921)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab0BCE
    ld a,(lab8923)
    ld c,#3
    sub c
    ld (lab8923),a
    ld a,(lab8925)
    ld c,#4
    add a,c
    ld (lab8925),a
    ld a,#24
    ld (lab8927),a
lab0BCE ld a,(lab8921)
    ld e,a
    ld a,#2
    cp e
    jp nz,lab0C04
    ld a,(lab8923)
    ld c,#1
    add a,c
    ld (lab8923),a
    ld a,(lab8925)
    ld c,#4
    add a,c
    ld (lab8925),a
    ld a,#2c
    ld (lab8927),a
    ld a,(lab88E1)
    or a
    jp nz,lab0C04
    ld a,#2e
    ld (lab8927),a
    ld a,(lab8923)
    ld c,#1
    add a,c
    ld (lab8923),a
lab0C04 ld a,(lab8921)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab0C1C
    ld a,(lab8923)
    ld c,#3
    add a,c
    ld (lab8923),a
    ld a,#2e
    ld (lab8927),a
lab0C1C ld a,(lab8921)
    ld e,a
    ld a,#4
    cp e
    jp nz,lab0C34
    ld a,(lab8923)
    ld c,#3
    sub c
    ld (lab8923),a
    ld a,#2c
    ld (lab8927),a
lab0C34 ld a,(lab8921)
    ld e,a
    ld a,#5
    cp e
    jp nz,lab0C50
    ld a,(lab8923)
    ld c,#2
    add a,c
    ld (lab8923),a
    ld a,(lab8925)
    ld c,#6
    sub c
    ld (lab8925),a
lab0C50 ld a,(lab0096)
    ld e,a
    ld a,#3
    cp e
    jp nc,lab0C5F
    ld a,#26
    ld (lab8927),a
lab0C5F ld hl,data0000
    ld (lab8913),hl
    ld a,(lab8927)
    ld (lab8913),a
    ld a,(lab8925)
    ld (lab8929),a
    ld a,(lab8923)
    ld (lab892B),a
    jp lab1FA9
lab0C7A ld hl,lab3D54
    ld (lab007E),hl
    ld hl,lab3D54
    ld bc,lab0012
    add hl,bc
    inc hl
    ld (lab00B2),hl
lab0C8B ld hl,(lab007E)
    ld a,(hl)
    or a
    jp nz,lab0CA4
    ld hl,(lab007E)
    ld (lab0064),hl
    call lab0CC0
    ld a,#0
    ld (lab88F3),a
    jp lab2282
lab0CA4 ld hl,(lab007E)
    ld bc,lab0005
    add hl,bc
    ld (lab007E),hl
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab0C8B
    ret 
lab0CC0 ld a,#0
    ld (lab892D),a
    ld a,(lab88E1)
    or a
    jp z,lab0CCF
    jp lab0CE3
lab0CCF ld a,#0
    ld (lab8921),a
    ld a,(lab892F)
    or a
    jp z,lab0CE0
    ld a,#1
    ld (lab892D),a
lab0CE0 jp lab0D03
lab0CE3 ld a,#2
    ld (lab8921),a
    ld a,(lab892F)
    or a
    jp nz,lab0D03
    ld a,#4
    ld (lab8921),a
    ld a,(lab890F)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab0D03
    ld a,#1
    ld (lab8921),a
lab0D03 ld a,(lab88E1)
    or a
    jp nz,lab0D31
    ld hl,(lab0064)
    ex de,hl
    ld a,#1
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld c,#3
    sub c
    ld (de),a
    inc de
    ld a,(lab88DB)
    ld c,#4
    add a,c
    ld (de),a
    inc de
    ld a,(lab892D)
    ld (de),a
    inc de
    ld a,(lab8921)
    ld (de),a
    inc de
    ld a,(lab8931)
    ld (de),a
    ret 
lab0D31 ld hl,(lab0064)
    ex de,hl
    ld a,#1
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld c,#3
    add a,c
    ld (de),a
    inc de
    ld a,(lab88DB)
    ld c,#14
    add a,c
    ld (de),a
    inc de
    ld a,#0
    ld (de),a
    inc de
    ld a,(lab8921)
    ld (de),a
    ret 
lab0D52 ld a,#0
    ld (lab0096),a
    ld a,#7
    ld (lab00CA),a
lab0D5C ld hl,(lab0096)
    ld bc,lab0006
    call lab77DB
    ld bc,lab3D54
    add hl,bc
    ld (lab8933),hl
    ld hl,(lab8933)
    ld a,(hl)
    ld (lab8935),a
    ld a,(lab8935)
    or a
    jp nz,lab0D7D
    jp lab0E08
lab0D7D ld a,(lab8935)
    ld c,#1
    add a,c
    ld (lab8935),a
    ld hl,(lab8933)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab8923),a
    ld hl,(lab8933)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab8925),a
    ld hl,(lab8933)
    ld bc,lab0003
    add hl,bc
    ld a,(hl)
    ld (lab892D),a
    ld hl,(lab8933)
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    ld (lab8921),a
    ld hl,(lab8933)
    ld bc,lab0005
    add hl,bc
    ld a,(hl)
    ld (lab8927),a
    ld a,(lab892D)
    or a
    jp z,lab0DD3
    ld a,(lab8935)
    ld e,a
    ld a,#4
    cp e
    jp nz,lab0DD3
    ld a,#2
    ld (lab8921),a
lab0DD3 ld a,(lab892D)
    or a
    jp z,lab0DE9
    ld a,(lab8935)
    ld e,a
    ld a,#9
    cp e
    jp nz,lab0DE9
    ld a,#3
    ld (lab8921),a
lab0DE9 call lab0B8C
    ld hl,(lab8933)
    ex de,hl
    ld a,(lab8935)
    ld (de),a
    inc de
    ld a,(lab8923)
    ld (de),a
    inc de
    ld a,(lab8925)
    ld (de),a
    inc de
    ld a,(lab892D)
    ld (de),a
    inc de
    ld a,(lab8921)
    ld (de),a
lab0E08 ld hl,lab0096
    inc (hl)
    ld a,(lab00CA)
    cp (hl)
    jp nc,lab0D5C
    ret 
lab0E14 ld a,(lab8923)
    ld e,a
    ld a,#3c
    cp e
    jp nc,lab0E23
    ld a,#0
    ld (lab8935),a
lab0E23 call lab1725
    ld a,(lab8937)
    or a
    jp z,lab0E5D
    call lab0EAE
    ld a,(lab8937)
    ld e,a
    ld a,#c8
    cp e
    jp c,lab0E5D
    ld hl,(lab006A)
    ex de,hl
    ld a,#c8
    ld (de),a
    ld a,#0
    ld (lab8935),a
    ld a,(lab8939)
    ld (lab891D),a
    ld a,(lab893B)
    ld (lab891F),a
    call lab0FF5
    call lab0F88
    ld a,#0
    ld (lab893D),a
lab0E5D ld a,(lab8925)
    ld e,a
    ld a,#5a
    cp e
    jp nc,lab0E88
    ld a,(lab8935)
    or a
    jp z,lab0E88
    ld a,(lab8923)
    ld c,#3
    sub c
    ld (lab891D),a
    ld a,(lab8925)
    ld c,#8
    sub c
    ld (lab891F),a
    call lab0F88
    ld a,#0
    ld (lab8935),a
lab0E88 ld a,(lab88DD)
    or a
    jp nz,lab0EAD
    ld a,(lab0096)
    ld e,a
    ld a,#3
    cp e
    jp nc,lab0EAD
    call lab16C3
    ld a,(lab8937)
    or a
    jp z,lab0EAD
    ld a,#1
    ld (lab88DD),a
    ld a,#0
    ld (lab8935),a
lab0EAD ret 
lab0EAE ld a,(lab8937)
    ld e,a
    ld a,#c3
    cp e
    jp nz,lab0EC7
    ld a,(lab0096)
    ld e,a
    ld a,#3
    cp e
    jp nc,lab0EC7
    ld a,#ff
    ld (lab8937),a
lab0EC7 ret 
data0ec8 db #c9
lab0EC9 ld hl,data0000
    ld (lab0096),hl
    ld hl,lab0005
    inc hl
    ld (lab00CA),hl
lab0ED6 ld hl,(lab0096)
    ld bc,lab0004
    call lab77DB
    ld bc,lab3714
    add hl,bc
    ld (lab893F),hl
    ld hl,data0000
    ld (lab8941),hl
    ld hl,(lab893F)
    ld a,(hl)
    ld (lab8941),a
    ld a,(lab8941)
    or a
    jp nz,lab0EFD
    jp lab0F71
lab0EFD ld hl,(lab893F)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab891D),a
    ld hl,(lab893F)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab891F),a
    ld hl,(lab893F)
    ld bc,lab0003
    add hl,bc
    ld a,(hl)
    ld (lab893D),a
    ld hl,data0000
    ld (lab8913),hl
    ld hl,lab370E
    ld bc,(lab8941)
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab8913),hl
    ld a,(lab891F)
    ld (lab8929),a
    ld a,(lab891D)
    ld (lab892B),a
    call lab1FA9
    ld a,(lab891D)
    ld hl,lab893D
    ld c,(hl)
    add a,c
    ld (lab891D),a
    ld a,(lab8941)
    ld c,#1
    add a,c
    ld (lab8941),a
    ld a,(lab8941)
    ld e,a
    ld a,#5
    cp e
    jp nc,lab0F64
    ld a,#0
    ld (lab8941),a
lab0F64 ld hl,(lab893F)
    ex de,hl
    ld a,(lab8941)
    ld (de),a
    inc de
    ld a,(lab891D)
    ld (de),a
lab0F71 ld hl,(lab0096)
    inc hl
    ld (lab0096),hl
    ld de,(lab00CA)
    xor a
    sbc hl,de
    jp c,lab0ED6
    ld a,#0
    ld (lab893D),a
    ret 
lab0F88 ld hl,lab3714
    ld (lab007E),hl
    ld hl,lab3714
    ld bc,lab0014
    add hl,bc
    inc hl
    ld (lab00B2),hl
lab0F99 ld hl,(lab007E)
    ld a,(hl)
    or a
    jp nz,lab0FB2
    ld hl,(lab007E)
    ld (lab0064),hl
    call lab0FCE
    ld a,#8a
    ld (lab88F3),a
    jp lab2282
lab0FB2 ld hl,(lab007E)
    ld bc,lab0003
    add hl,bc
    ld (lab007E),hl
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab0F99
    ret 
lab0FCE ld hl,(lab0064)
    ex de,hl
    ld a,#1
    ld (de),a
    inc de
    ld a,(lab891D)
    ld (de),a
    inc de
    ld a,(lab891F)
    ld (de),a
    inc de
    ld a,(lab893D)
    ld (de),a
    ret 
lab0FE5 ld a,(lab8943)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab0FF4
    ld a,#2
    ld (lab893D),a
lab0FF4 ret 
lab0FF5 ld hl,(lab006A)
    ld bc,lab0007
    add hl,bc
    ld a,(hl)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab101F
    ld a,(lab8939)
    ld hl,lab8945
    ld c,(hl)
    add a,c
    ld (lab891D),a
    ld a,(lab893B)
    ld hl,lab8947
    ld c,(hl)
    add a,c
    ld (lab891F),a
    ld a,#2
    ld (lab893D),a
lab101F ret 
lab1020 ld hl,lab3D54
    ld bc,lab0018
    add hl,bc
    ld (lab007E),hl
    ld hl,lab3D54
    ld bc,lab002A
    add hl,bc
    inc hl
    ld (lab00B2),hl
lab1035 ld hl,(lab007E)
    ld a,(hl)
    or a
    jp nz,lab1046
    ld hl,(lab007E)
    ld (lab0064),hl
    jp lab1062
lab1046 ld hl,(lab007E)
    ld bc,lab0005
    add hl,bc
    ld (lab007E),hl
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab1035
    ret 
lab1062 ld hl,(lab0064)
    ex de,hl
    ld a,#1
    ld (de),a
    inc de
    ld a,(lab8923)
    ld (de),a
    inc de
    ld a,(lab8925)
    ld (de),a
    inc de
    ld a,#0
    ld (de),a
    inc de
    ld a,(lab8921)
    ld (de),a
    ret 
lab107D call lab1228
    ld a,(lab88DD)
    or a
    jp z,lab108A
    jp lab0B3D
lab108A ld a,(lab88F9)
    or a
    jp z,lab109D
    ld a,(lab88DB)
    ld c,#4
    add a,c
    ld (lab88DB),a
    jp lab1150
lab109D ld a,(lab88D3)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab10AD
    call lab1150
    jp lab1606
lab10AD ld a,(lab88FD)
    or a
    jp z,lab10B7
    call lab11D9
lab10B7 ld a,(lab88D3)
    ld e,a
    ld a,#3
    cp e
    jp nc,lab10C7
    call lab11AD
    jp lab1150
lab10C7 ld a,(lab8901)
    ld e,a
    ld a,#4
    cp e
    jp nc,lab10D4
    jp lab11F4
lab10D4 ld a,(lab8949)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab1103
    ld a,(lab88E1)
    or a
    jp nz,lab1103
    ld a,(lab88FD)
    or a
    jp nz,lab1103
    ld a,(lab8903)
    ld e,a
    ld a,#3f
    cp e
    jp c,lab1103
    ld a,#f
    ld (lab88FD),a
    ld a,#64
    ld (lab88F3),a
    call lab2282
lab1103 ld a,(lab8949)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab112C
    ld a,(lab88E1)
    or a
    jp z,lab112C
    ld a,(lab88DB)
    ld e,a
    ld a,#0
    cp e
    jp nc,lab112C
    ld a,(lab88DB)
    ld c,#4
    sub c
    ld (lab88DB),a
    ld a,#0
    ld (lab88DF),a
lab112C ld a,(lab8949)
    ld e,a
    ld a,#5
    cp e
    jp nz,lab114D
    ld a,(lab88E1)
    or a
    jp z,lab114D
    ld a,(lab88DF)
    or a
    jp nz,lab114D
    ld a,(lab88DB)
    ld c,#4
    add a,c
    ld (lab88DB),a
lab114D call lab1156
lab1150 call lab12F2
    jp lab1336
lab1156 ld a,(lab88DF)
    or a
    jp z,lab115E
    ret 
lab115E ld a,#2
    ld (lab894B),a
    call lab122D
    ld a,(lab8949)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab1184
    ld a,(lab88EB)
    ld e,a
    ld a,(lab8909)
    cp e
    jp c,lab1184
    ld a,(lab88EB)
    ld c,#1
    add a,c
    ld (lab88EB),a
lab1184 ld a,#0
    ld (lab890F),a
    ld a,(lab8949)
    ld e,a
    ld a,#2
    cp e
    jp nz,lab11AC
    ld a,#6
    ld (lab890F),a
    ld a,(lab88EB)
    ld e,a
    ld a,(lab890B)
    cp e
    jp nc,lab11AC
    ld a,(lab88EB)
    ld c,#1
    sub c
    ld (lab88EB),a
lab11AC ret 
lab11AD ld a,(lab88D3)
    ld c,#1
    add a,c
    ld (lab88D3),a
    ld a,(lab88D3)
    ld e,a
    ld a,#1e
    cp e
    jp nz,lab11C5
    ld a,#2
    ld (lab88D3),a
lab11C5 ret 
data11c6 db #3a
db #db,#88,#5f,#3e,#00,#bb,#d2,#d9
db #11,#3a,#db,#88,#0e,#01,#91,#32
db #db,#88
lab11D9 ld a,(lab88FD)
    ld c,#1
    sub c
    ld (lab88FD),a
    ld hl,lab3770
    ld bc,(lab88FD)
    add hl,bc
    ld a,(hl)
    ld hl,lab88DB
    ld c,(hl)
    add a,c
    ld (lab88DB),a
    ret 
lab11F4 ld a,(lab88EB)
    ld e,a
    ld a,(lab8939)
    cp e
    jp nc,lab1208
    ld a,(lab88EB)
    ld c,#2
    sub c
    ld (lab88EB),a
lab1208 ld a,(lab88EB)
    ld e,a
    ld a,(lab8939)
    cp e
    jp c,lab121C
    ld a,(lab88EB)
    ld c,#1
    add a,c
    ld (lab88EB),a
lab121C ld a,(lab88DB)
    ld c,#4
    add a,c
    ld (lab88DB),a
    jp lab1336
lab1228 ld a,#5
    ld (lab894B),a
lab122D ld a,#0
    ld (lab8949),a
    ld hl,data0000
    ld (lab007E),hl
    ld a,#1
    ld (lab007E),a
    ld a,(lab894B)
    ld (lab00B2),a
lab1243 ld hl,lab7B16
    ld bc,(lab007E)
    add hl,bc
    ld a,(hl)
    ld (lab0064),a
    ld a,(lab0064)
    call lab76A9
    or a
    jp nz,lab125F
    ld a,(lab007E)
    ld (lab8949),a
lab125F ld hl,lab007E
    inc (hl)
    ld a,(lab00B2)
    cp (hl)
    jp nc,lab1243
    ret 
lab126B ld a,(lab88DD)
    ld hl,lab88DF
    ld c,(hl)
    or c
    or a
    jp nz,lab127A
    jp lab127B
lab127A ret 
lab127B ld hl,lab7B16
    ld bc,lab0006
    add hl,bc
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab1299
    ld a,(lab894D)
    or a
    jp nz,lab1299
    ld a,#0
    ld (lab892F),a
    call lab0C7A
lab1299 ld a,#0
    ld (lab894D),a
    ld hl,lab7B16
    ld bc,lab0006
    add hl,bc
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab12B2
    ld a,#1
    ld (lab894D),a
lab12B2 ld a,(lab88DD)
    or a
    jp z,lab12BA
    ret 
lab12BA ld hl,lab7B16
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab12D8
    ld a,(lab894F)
    or a
    jp nz,lab12D8
    ld a,#1
    ld (lab892F),a
    call lab0C7A
lab12D8 ld a,#0
    ld (lab894F),a
    ld hl,lab7B16
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    call lab76A9
    or a
    jp nz,lab12F1
    ld a,#1
    ld (lab894F),a
lab12F1 ret 
lab12F2 ld a,(lab88E1)
    or a
    jp z,lab12FC
    jp lab1312
lab12FC ld a,(lab88E9)
    ld e,a
    ld a,#c
    cp e
    jp nz,lab130C
    ld a,#e
    ld (lab88E9),a
    ret 
lab130C ld a,#c
    ld (lab88E9),a
    ret 
lab1312 ld a,(lab8911)
    ld c,#2
    add a,c
    ld (lab8911),a
    ld a,(lab8911)
    ld e,a
    ld a,#4
    cp e
    jp nc,lab132A
    ld a,#0
    ld (lab8911),a
lab132A ld a,(lab890F)
    ld hl,lab8911
    ld c,(hl)
    add a,c
    ld (lab88E9),a
    ret 
lab1336 ld hl,lab0064
    ex de,hl
    ld a,(lab88DB)
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld (de),a
    ld hl,(lab88E9)
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld (lab0066),hl
    ld a,(lab88E1)
    or a
    jp nz,lab1377
    ld hl,lab8283
    ex de,hl
    ld a,(lab88DB)
    ld c,#2
    add a,c
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld c,#1
    add a,c
    ld (de),a
    inc de
    ld a,#12
    ld (de),a
    inc de
    ld a,#8
    ld (de),a
lab1377 ld a,(lab88E1)
    or a
    jp z,lab1399
    ld hl,lab8283
    ex de,hl
    ld a,(lab88DB)
    ld c,#6
    add a,c
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld c,#1
    add a,c
    ld (de),a
    inc de
    ld a,#12
    ld (de),a
    inc de
    ld a,#8
    ld (de),a
lab1399 call lab80E8
    ret 
lab139D ld hl,(lab0096)
    ex de,hl
    ld hl,lab0003
    xor a
    sbc hl,de
    jp nz,lab13AB
    ret 
lab13AB ld hl,data0000
    ld (lab8913),hl
    ld a,(lab8951)
    ld (lab8913),a
    ld a,(lab8953)
    ld (lab8929),a
    ld a,(lab8955)
    ld (lab892B),a
    call lab1FA9
    ld a,(lab88D3)
    ld hl,lab88DF
    ld c,(hl)
    or c
    or a
    jp nz,lab13DD
    ld a,(lab8955)
    ld hl,lab8957
    ld c,(hl)
    add a,c
    ld (lab8955),a
lab13DD ld hl,(lab8959)
    ld bc,lab0001
    add hl,bc
    ex de,hl
    ld a,(lab8953)
    ld (de),a
    inc de
    ld a,(lab8955)
    ld (de),a
    ret 
lab13EF ld a,#0
    ld (lab890D),a
    ld a,(lab8913)
    ld e,a
    ld a,#52
    cp e
    jp nz,lab1403
    ld a,#1
    ld (lab890D),a
lab1403 ld a,(lab8913)
    ld e,a
    ld a,#36
    cp e
    jp nz,lab1412
    ld a,#2
    ld (lab890D),a
lab1412 ld a,(lab8913)
    ld e,a
    ld a,#5a
    cp e
    jp nz,lab1421
    ld a,#2
    ld (lab890D),a
lab1421 ld a,(lab8913)
    ld e,a
    ld a,#4c
    cp e
    jp nz,lab1430
    ld a,#3
    ld (lab890D),a
lab1430 ld hl,(lab8913)
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld (lab0066),hl
    ld hl,(lab0066)
    ld a,(hl)
    ld (lab895B),a
    ld hl,(lab0066)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab895D),a
    ld a,(lab895F)
    or a
    jp z,lab149E
    ld hl,data0000
    ld (lab0064),hl
    ld a,(lab895F)
    ld c,#1
    sub c
    ld c,#8
    call lab7812
    ld (lab0064),a
    ld hl,lab373C
    ld bc,(lab0064)
    add hl,bc
    ex de,hl
    ld a,(lab890D)
    ld (de),a
    inc de
    ld a,(lab0094)
    ld (de),a
    inc de
    ld a,(lab0092)
    ld (de),a
    inc de
    ld a,(lab895B)
    ld (de),a
    inc de
    ld a,(lab895D)
    ld (de),a
    inc de
    ld a,#1
    ld (de),a
    inc de
    ld a,(lab8913)
    ld (de),a
    inc de
    ld a,(lab8961)
    ld (de),a
lab149E ret 
lab149F ld hl,data0000
    ld (lab0096),hl
    ld a,#0
    ld (lab0096),a
    ld a,#3
    ld (lab00CA),a
lab14AF ld hl,(lab0096)
    ld bc,lab0008
    call lab77DB
    ld bc,lab373C
    add hl,bc
    ld (lab8959),hl
    ld hl,(lab8959)
    ld bc,lab0005
    add hl,bc
    ld a,(hl)
    ld (lab88D7),a
    ld a,(lab88D7)
    or a
    jp nz,lab14D4
    jp lab1517
lab14D4 ld hl,(lab8959)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab8955),a
    ld hl,(lab8959)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab8953),a
    ld hl,(lab8959)
    ld bc,lab0006
    add hl,bc
    ld a,(hl)
    ld (lab8951),a
    ld hl,(lab8959)
    ld bc,lab0007
    add hl,bc
    ld a,(hl)
    ld (lab8957),a
    call lab139D
    ld a,(lab88D3)
    or a
    jp nz,lab1517
    call lab1770
    ld a,(lab8937)
    or a
    jp z,lab1517
    call lab1523
lab1517 ld hl,lab0096
    inc (hl)
    ld a,(lab00CA)
    cp (hl)
    jp nc,lab14AF
    ret 
lab1523 ld a,(lab8937)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab1542
    ld a,(lab88EB)
    ld e,a
    ld a,(lab8939)
    cp e
    jp nc,lab1542
    ld a,#1
    ld (lab88D3),a
    ld a,#ff
    ld (lab8963),a
lab1542 ld a,(lab8937)
    ld e,a
    ld a,#2
    cp e
    jp nz,lab15A9
    ld a,(lab88EB)
    ld hl,lab8939
    ld c,(hl)
    sub c
    ld (lab88FB),a
    ld a,(lab88FB)
    ld e,a
    ld a,#a
    cp e
    jp c,lab15A9
    ld a,(lab893B)
    ld hl,lab88DB
    ld c,(hl)
    sub c
    ld e,a
    ld a,#f
    cp e
    jp nc,lab15A9
    ld a,(lab893B)
    ld c,#13
    sub c
    ld (lab88DB),a
    ld a,#4
    ld (lab88D3),a
    ld hl,data0000
    ld (lab890F),hl
    ld a,#1
    ld (lab88DF),a
    ld a,#0
    ld (lab88F9),a
    call lab15C3
    ld a,(lab88E1)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab15A9
    ld a,(lab8939)
    ld c,#e
    add a,c
    ld (lab8963),a
    ld a,#1
    ld (lab88D3),a
lab15A9 ld a,(lab8937)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab15BD
    ld a,(lab8901)
    ld c,#1
    add a,c
    ld (lab8901),a
    ret 
lab15BD ld a,#0
    ld (lab8901),a
    ret 
lab15C3 ld a,(lab88FB)
    ld e,a
    ld a,#5
    cp e
    jp nc,lab15D7
    ld a,#a
    ld hl,lab88FB
    ld c,(hl)
    sub c
    ld (lab88FB),a
lab15D7 ld a,(lab88FB)
    ld c,#a
    call lab7812
    ld (lab88FB),a
    ret 
lab15E3 ld a,#3
    ld (lab88D3),a
    ld a,(lab88EB)
    ld c,#1a
    add a,c
    ld (lab8965),a
    ld a,(lab88EB)
    ld (lab8967),a
    ld a,(lab88DB)
    ld c,#8
    add a,c
    ld (lab8969),a
    ld a,#64
    ld (lab896B),a
    ret 
lab1606 ld a,(lab8967)
    ld c,#1
    add a,c
    ld (lab8967),a
    ld a,(lab896B)
    ld e,a
    ld a,#64
    cp e
    jp nz,lab1621
    ld a,#62
    ld (lab896B),a
    jp lab1626
lab1621 ld a,#64
    ld (lab896B),a
lab1626 ld a,(lab8967)
    ld e,a
    ld a,(lab8963)
    cp e
    jp nc,lab163F
    ld a,(lab8969)
    ld c,#1
    add a,c
    ld (lab8969),a
    ld a,#62
    ld (lab896B),a
lab163F ld a,(lab8967)
    ld (lab892B),a
    ld a,(lab8969)
    ld (lab8929),a
    ld a,(lab896B)
    ld (lab8913),a
    call lab1FA9
    ld a,(lab8967)
    ld e,a
    ld a,(lab8965)
    cp e
    jp nc,lab1664
    ld a,#2
    ld (lab88D3),a
lab1664 ret 
lab1665 ld hl,lab0002
    ld (lab006E),hl
    ld hl,lab0004
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab8925)
    ld c,#2
    add a,c
    ld (de),a
    inc de
    ld a,(lab8923)
    ld c,#2
    add a,c
    ld (de),a
    ld hl,lab8282
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#5
    ld (de),a
    jp lab179C
lab1694 ld hl,lab0006
    ld (lab006E),hl
    ld hl,lab0010
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab896D)
    ld c,#4
    add a,c
    ld (de),a
    inc de
    ld a,(lab896F)
    ld c,#2
    add a,c
    ld (de),a
    ld hl,lab8282
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#5
    ld (de),a
    jp lab179C
lab16C3 ld a,(lab88E1)
    or a
    jp z,lab16CD
    jp lab1665
lab16CD ld hl,lab0001
    ld (lab006E),hl
    ld hl,lab0001
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab8925)
    ld c,#7
    add a,c
    ld (de),a
    inc de
    ld a,(lab8923)
    ld c,#1
    sub c
    ld (de),a
    ld hl,lab8282
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#5
    ld (de),a
    jp lab179C
lab16FC ld a,(lab895B)
    ld (lab006E),a
    ld a,(lab895D)
    ld (lab006C),a
    ld hl,lab0064
    ex de,hl
    ld a,(lab896D)
    ld (de),a
    inc de
    ld a,(lab896F)
    ld (de),a
    ld hl,lab36EC
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#a
    ld (de),a
    jp lab179C
lab1725 ld hl,lab0002
    ld (lab006E),hl
    ld hl,lab0008
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab8925)
    ld (de),a
    inc de
    ld a,(lab8923)
    ld (de),a
    ld hl,lab36EC
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#a
    ld (de),a
    jp lab179C
lab174E ld hl,lab0008
    ld (lab006E),hl
    ld hl,lab0018
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab896D)
    ld c,#1
    add a,c
    ld (de),a
    inc de
    ld a,(lab896F)
    ld c,#2
    sub c
    ld (de),a
    jp lab178F
lab1770 ld hl,lab0008
    ld (lab006E),hl
    ld hl,lab0018
    ld (lab006C),hl
    ld hl,lab0064
    ex de,hl
    ld a,(lab88DB)
    ld c,#1
    add a,c
    ld (de),a
    inc de
    ld a,(lab88EB)
    ld c,#1
    sub c
    ld (de),a
lab178F ld hl,lab373C
    ld (lab0066),hl
    ld hl,lab8367+1
    ex de,hl
    ld a,#8
    ld (de),a
lab179C call lab834A
    ld a,#0
    ld (lab8937),a
    ld hl,(lab0068)
    ex de,hl
    ld hl,#ffff
    xor a
    sbc hl,de
    jp nz,lab17B2
    ret 
lab17B2 ld hl,(lab006A)
    ld a,(hl)
    ld (lab8937),a
    ld hl,(lab006A)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab893B),a
    ld hl,(lab006A)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab8939),a
    ld hl,(lab006A)
    ld bc,lab0003
    add hl,bc
    ld a,(hl)
    ld (lab8971),a
    ld hl,(lab006A)
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    ld (lab8973),a
    ret 
lab17E6 ld hl,data0000
    ld (lab0096),hl
    ld hl,data0000
    ld (lab0096),hl
    ld hl,lab0001
    inc hl
    ld (lab00CA),hl
lab17F9 ld hl,(lab0096)
    ld bc,lab000A
    call lab77DB
    ld bc,lab36EC
    add hl,bc
    ld (lab8975),hl
    ld hl,data0000
    ld (lab8977),hl
    ld hl,(lab8975)
    ld a,(hl)
    ld (lab8977),a
    ld a,(lab8977)
    or a
    jp nz,lab1820
    jp lab19C4
lab1820 ld hl,(lab8975)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab896D),a
    ld hl,(lab8975)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab896F),a
    ld hl,(lab8975)
    ld bc,lab0005
    add hl,bc
    ld a,(hl)
    ld (lab8979),a
    ld hl,(lab8975)
    ld bc,lab0006
    add hl,bc
    ld a,(hl)
    ld (lab897B),a
    ld hl,(lab8975)
    ld bc,lab0007
    add hl,bc
    ld a,(hl)
    ld (lab8943),a
    ld a,(lab88DD)
    or a
    jp nz,lab1898
lab185E call lab1694
    ld a,(lab8937)
    or a
    jp z,lab1898
    ld a,(lab8977)
    ld e,a
    ld a,#c8
    cp e
    jp c,lab1898
    ld a,#c8
    ld (lab8977),a
    ld a,(lab896F)
    ld (lab891D),a
    ld a,(lab896D)
    ld (lab891F),a
    call lab0FE5
    call lab0F88
    ld a,#0
    ld (lab893D),a
    ld a,#c8
    ld (lab8977),a
    ld a,#1
    ld (lab88DD),a
lab1898 ld hl,data0000
    ld (lab8913),hl
    ld a,(lab8943)
    or a
    jp nz,lab18A8
    jp lab19C4
lab18A8 ld a,(lab8943)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab18B8
    call lab1B98
    jp lab1937
lab18B8 ld a,(lab8943)
    ld e,a
    ld a,#2
    cp e
    jp nz,lab18C8
    call lab1B0A
    jp lab1937
lab18C8 ld a,(lab8943)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab18EC
    ld a,#fc
    ld (lab897D),a
    ld a,#fe
    ld (lab897F),a
    call lab1C51
    ld a,#14
    ld hl,lab897B
    ld c,(hl)
    add a,c
    ld (lab8913),a
    jp lab1937
lab18EC ld a,(lab8943)
    ld e,a
    ld a,#5
    cp e
    jp nz,lab1910
    ld a,#2
    ld (lab897D),a
    ld a,#2
    ld (lab897F),a
    call lab1C51
    ld a,#14
    ld hl,lab897B
    ld c,(hl)
    add a,c
    ld (lab8913),a
    jp lab1937
lab1910 ld a,(lab8943)
    ld e,a
    ld a,#4
    cp e
    jp nz,lab192A
    call lab1D2E
    ld a,#22
    ld hl,lab897B
    ld c,(hl)
    sub c
    ld (lab8913),a
    jp lab1937
lab192A ld a,(lab8943)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab1937
    call lab1DBD
lab1937 ld a,(lab8977)
    ld e,a
    ld a,#c7
    cp e
    jp nc,lab198D
    ld a,(lab8977)
    ld c,#1
    add a,c
    ld (lab8977),a
    ld hl,(lab8975)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab896D),a
    ld hl,(lab8975)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab896F),a
    call lab19D6
    ld a,(lab8977)
    ld e,a
    ld a,#ca
    cp e
    jp nz,lab198D
    ld a,#0
    ld (lab8977),a
    ld a,(lab88E5)
    or a
    jp nz,lab198D
    ld hl,(lab8943)
    ld bc,lab0019
    call lab77DB
    ld bc,(lab8915)
    add hl,bc
    ld (lab8915),hl
    call lab07AE
lab198D ld a,(lab896D)
    ld (lab8929),a
    ld a,(lab896F)
    ld (lab892B),a
    call lab1FA9
    ld hl,(lab8975)
    ex de,hl
    ld a,(lab8977)
    ld (de),a
    inc de
    ld a,(lab896D)
    ld (de),a
    inc de
    ld a,(lab896F)
    ld (de),a
    ld hl,(lab8975)
    ld bc,lab0005
    add hl,bc
    ex de,hl
    ld a,(lab8979)
    ld (de),a
    inc de
    ld a,(lab897B)
    ld (de),a
    inc de
    ld a,(lab8943)
    ld (de),a
lab19C4 ld hl,(lab0096)
    inc hl
    ld (lab0096),hl
    ld de,(lab00CA)
    xor a
    sbc hl,de
    jp c,lab17F9
    ret 
lab19D6 ld a,(lab8943)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab19E9
    ld a,(lab896F)
    ld c,#2
    add a,c
    ld (lab896F),a
lab19E9 ret 
lab19EA ld a,(lab8903)
    ld e,a
    ld a,#3e
    cp e
    jp nc,lab19F5
    ret 
lab19F5 ld a,(lab8981)
    ld c,#1
    add a,c
    ld (lab8981),a
    ld a,(lab8981)
    ld e,a
    ld a,#c
    ld hl,lab88E1
    ld c,(hl)
    sub c
    ld hl,lab88E1
    ld c,(hl)
    sub c
    cp e
    jp c,lab1A13
    ret 
lab1A13 ld a,#0
    ld (lab8981),a
    ld hl,lab36EC
    ld (lab007E),hl
    ld hl,lab36EC
    ld bc,lab000A
    add hl,bc
    inc hl
    ld (lab00B2),hl
lab1A29 ld hl,(lab007E)
    ld a,(hl)
    or a
    jp nz,lab1A3D
    ld hl,(lab007E)
    ld (lab8983),hl
    call lab1A8D
    jp lab1A59
lab1A3D ld hl,(lab007E)
    ld bc,lab0009
    add hl,bc
    ld (lab007E),hl
    ld hl,(lab007E)
    inc hl
    ld (lab007E),hl
    ld de,(lab00B2)
    xor a
    sbc hl,de
    jp c,lab1A29
    ret 
lab1A59 call lab16FC
    ld a,(lab8937)
    or a
    jp nz,lab1A8C
    ld hl,(lab8983)
    ex de,hl
    ld a,(lab8977)
    ld (de),a
    inc de
    ld a,(lab896D)
    ld (de),a
    inc de
    ld a,(lab896F)
    ld (de),a
    inc de
    ld a,(lab895D)
    ld (de),a
    inc de
    ld a,(lab895B)
    ld (de),a
    inc de
    ld a,#0
    ld (de),a
    inc de
    ld a,#0
    ld (de),a
    inc de
    ld a,(lab8943)
    ld (de),a
lab1A8C ret 
lab1A8D ld a,#1
    ld (lab8977),a
    call lab21B6
    ld a,(lab88E1)
    or a
    jp z,lab1A9F
    jp lab1AB0
lab1A9F ld a,(lab8985)
    ld e,a
    ld a,#82
    cp e
    jp nc,lab1AAC
    jp lab1EB7
lab1AAC call lab1E8D
    ret 
lab1AB0 ld a,(lab8985)
    ld e,a
    ld a,#b4
    cp e
    jp nc,lab1AC0
    call lab1ECE
    jp lab1AF0
lab1AC0 ld a,(lab8985)
    ld e,a
    ld a,#50
    cp e
    jp nc,lab1AD0
    call lab1EFB
    jp lab1AF0
lab1AD0 ld a,(lab88E5)
    or a
    jp z,lab1AE0
    call lab1E8D
    ld a,#48
    ld (lab896D),a
    ret 
lab1AE0 ld a,(lab88DF)
    or a
    jp z,lab1AED
    ld a,#0
    ld (lab8977),a
    ret 
lab1AED jp lab1F24
lab1AF0 ld a,(lab896D)
    ld e,a
    ld a,#44
    cp e
    jp nc,lab1B09
    ld a,(lab896D)
    ld e,a
    ld a,#80
    cp e
    jp c,lab1B09
    ld a,#0
    ld (lab8977),a
lab1B09 ret 
lab1B0A call lab174E
    ld a,(lab8937)
    ld e,a
    ld a,#3
    cp e
    jp nz,lab1B23
    ld a,(lab8979)
    or a
    jp nz,lab1B23
    ld a,#11
    ld (lab8979),a
lab1B23 ld a,(lab88E5)
    or a
    jp z,lab1B4D
    ld a,(lab896F)
    ld e,a
    ld a,#28
    cp e
    jp nz,lab1B4D
    call lab21B6
    ld a,(lab8985)
    ld e,a
    ld a,#64
    cp e
    jp nc,lab1B4D
    ld a,(lab8979)
    or a
    jp nz,lab1B4D
    ld a,#11
    ld (lab8979),a
lab1B4D ld a,(lab8979)
    or a
    jp z,lab1B77
    ld a,(lab8979)
    ld c,#1
    sub c
    ld (lab8979),a
    ld hl,lab376E
    ld bc,(lab8979)
    add hl,bc
    ld a,(hl)
    ld hl,lab896D
    ld c,(hl)
    add a,c
    ld (lab896D),a
    ld a,(lab896F)
    ld c,#1
    sub c
    ld (lab896F),a
lab1B77 call lab1C2E
    ld a,(lab897B)
    ld e,a
    ld a,#10
    cp e
    jp nz,lab1B8C
    ld a,#12
    ld (lab897B),a
    jp lab1B91
lab1B8C ld a,#10
    ld (lab897B),a
lab1B91 ld a,(lab897B)
    ld (lab8913),a
    ret 
lab1B98 call lab1C2E
    ld a,#6
    ld (lab8987),a
    ld a,(lab8979)
    ld e,a
    ld a,#a
    cp e
    jp nc,lab1BB8
    ld a,(lab896D)
    ld c,#2
    sub c
    ld (lab896D),a
    ld a,#0
    ld (lab8987),a
lab1BB8 ld a,(lab896F)
    ld e,a
    ld a,(lab88EB)
    ld c,#14
    add a,c
    cp e
    jp c,lab1C0A
    ld a,(lab8979)
    ld e,a
    ld a,#a
    cp e
    jp c,lab1C0A
    ld a,(lab8979)
    ld c,#1
    add a,c
    ld (lab8979),a
    ld a,(lab8977)
    ld e,a
    ld a,#c7
    cp e
    jp c,lab1C0A
    call lab21B6
    ld a,(lab8985)
    ld e,a
    ld a,#c8
    cp e
    jp nc,lab1C0A
    ld a,(lab896F)
    ld c,#4
    add a,c
    ld (lab8923),a
    ld a,(lab896D)
    ld c,#e
    add a,c
    ld (lab8925),a
    ld a,#1
    ld (lab8921),a
    call lab1020
lab1C0A ld a,(lab897B)
    ld c,#2
    add a,c
    ld (lab897B),a
    ld a,(lab897B)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab1C22
    ld a,#0
    ld (lab897B),a
lab1C22 ld a,(lab8987)
    ld hl,lab897B
    ld c,(hl)
    add a,c
    ld (lab8913),a
    ret 
lab1C2E ld a,(lab896F)
    ld c,#2
    sub c
    ld (lab896F),a
    ld a,(lab896F)
    ld e,a
    ld a,#80
    cp e
    jp nc,lab1C50
    ld a,(lab896F)
    ld e,a
    ld a,#f4
    cp e
    jp c,lab1C50
    ld a,#0
    ld (lab8977),a
lab1C50 ret 
lab1C51 ld a,(lab8979)
    or a
    jp nz,lab1C64
    ld a,(lab896F)
    ld c,#1
    sub c
    ld (lab896F),a
    call lab1C2E
lab1C64 ld a,(lab896F)
    ld e,a
    ld a,(lab88EB)
    ld c,#4
    sub c
    cp e
    jp c,lab1C7E
    ld a,(lab8979)
    or a
    jp nz,lab1C7E
    ld a,#1
    ld (lab8979),a
lab1C7E ld a,(lab8979)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab1CD6
    ld a,(lab897B)
    ld c,#2
    add a,c
    ld (lab897B),a
    ld a,(lab896D)
    ld hl,lab897D
    ld c,(hl)
    add a,c
    ld (lab896D),a
    ld a,(lab896F)
    ld c,#1
    sub c
    ld (lab896F),a
    call lab1C2E
    ld a,(lab897B)
    ld e,a
    ld a,#e
    cp e
    jp nz,lab1CD6
    ld a,#b
    ld (lab8979),a
    ld a,(lab896F)
    ld c,#6
    add a,c
    ld (lab8923),a
    ld a,(lab896D)
    ld c,#a
    add a,c
    ld hl,lab897D
    ld c,(hl)
    add a,c
    ld (lab8925),a
    ld a,#3
    ld (lab8921),a
    call lab1020
lab1CD6 ld a,(lab897B)
    ld e,a
    ld a,#6
    cp e
    jp nz,lab1CE8
    ld a,#2a
    ld (lab88F3),a
    call lab2282
lab1CE8 ld a,(lab8979)
    ld e,a
    ld a,#a
    cp e
    jp nc,lab1D0A
    call lab1D0B
    ld a,(lab896D)
    ld e,a
    ld a,#44
    cp e
    jp c,lab1D0A
    ld a,(lab896D)
    ld hl,lab897F
    ld c,(hl)
    add a,c
    ld (lab896D),a
lab1D0A ret 
lab1D0B ld a,(lab896F)
    ld c,#2
    add a,c
    ld (lab896F),a
    ld a,(lab896F)
    ld e,a
    ld a,#3d
    cp e
    jp nc,lab1D2D
    ld a,(lab896F)
    ld e,a
    ld a,#80
    cp e
    jp c,lab1D2D
    ld a,#0
    ld (lab8977),a
lab1D2D ret 
lab1D2E ld a,(lab8979)
    or a
    jp nz,lab1D41
    ld a,(lab896F)
    ld c,#1
    add a,c
    ld (lab896F),a
    call lab1D0B
lab1D41 ld a,(lab88EB)
    ld hl,lab896F
    ld c,(hl)
    sub c
    ld e,a
    ld a,#f
    cp e
    jp c,lab1D6F
    ld a,#1
    ld (lab8979),a
    ld a,(lab896F)
    ld c,#3
    add a,c
    ld (lab8923),a
    ld a,(lab896D)
    ld c,#10
    add a,c
    ld (lab8925),a
    ld a,#3
    ld (lab8921),a
    call lab1020
lab1D6F ld a,(lab8979)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab1D9D
    ld a,(lab897B)
    ld c,#2
    add a,c
    ld (lab897B),a
    ld a,(lab896D)
    ld c,#2
    add a,c
    ld (lab896D),a
    call lab1C2E
    ld a,(lab897B)
    ld e,a
    ld a,#e
    cp e
    jp nz,lab1D9D
    ld a,#b
    ld (lab8979),a
lab1D9D ld a,(lab897B)
    ld e,a
    ld a,#6
    cp e
lab1DA4 jp nz,lab1DAF
    ld a,#2a
    ld (lab88F3),a
    call lab2282
lab1DAF ld a,(lab8979)
    ld e,a
    ld a,#a
    cp e
    jp nc,lab1DBC
    call lab1C2E
lab1DBC ret 
lab1DBD call lab1D0B
    call lab21B6
    ld a,(lab8985)
    ld e,a
    ld a,#32
    cp e
    jp c,lab1DE6
    ld a,(lab88E1)
    ld e,a
    ld a,#1
    cp e
    jp nz,lab1DE6
    ld a,(lab8979)
    or a
    jp nz,lab1DE6
    ld a,#1
    ld (lab8979),a
    jp lab1DF3
lab1DE6 ld a,(lab8985)
    ld e,a
    ld a,#32
    cp e
    jp c,lab1DF3
    call lab1E50
lab1DF3 ld a,(lab8979)
    or a
    jp z,lab1E36
    ld a,(lab8979)
    ld c,#1
    add a,c
    ld (lab8979),a
    ld a,(lab897B)
    ld c,#2
    add a,c
    ld (lab897B),a
    call lab1E45
    ld a,(lab8979)
    ld e,a
    ld a,#3
    cp e
    jp nc,lab1E36
    ld a,(lab897B)
    ld c,#4
    sub c
    ld (lab897B),a
    ld a,(lab8979)
    ld e,a
    ld a,#5
    cp e
    jp nc,lab1E36
    ld a,#0
    ld (lab8979),a
    ld a,#0
    ld (lab897B),a
lab1E36 call lab1F65
    ld a,(lab8913)
    ld hl,lab897B
    ld c,(hl)
    add a,c
    ld (lab8913),a
    ret 
lab1E45 ld a,(lab8979)
    ld e,a
    ld a,#4
    cp e
    jp z,lab1E50
    ret 
lab1E50 ld a,#0
    ld (lab8921),a
    ld a,(lab8985)
    ld e,a
    ld a,#19
    cp e
    jp c,lab1E73
    ld a,#3
    ld (lab8921),a
    ld a,(lab88E1)
    ld e,a
    ld a,#2
    cp e
    jp c,lab1E73
    ld a,#5
    ld (lab8921),a
lab1E73 ld a,(lab896F)
    ld hl,lab8989
    ld c,(hl)
    add a,c
    ld (lab8923),a
    ld a,(lab896D)
    ld hl,lab898B
    ld c,(hl)
    add a,c
    ld (lab8925),a
    call lab1020
    ret 
lab1E8D ld a,#30
    ld (lab896D),a
    ld a,#3e
    ld (lab896F),a
    ld a,#2
    ld (lab8943),a
lab1E9C ld a,#a
    ld (lab895B),a
    ld a,#18
    ld (lab895D),a
    ret 
lab1EA7 ld a,#a
    ld (lab895B),a
    ld a,#10
    ld (lab895D),a
    ld a,#c3
    ld (lab8977),a
    ret 
lab1EB7 ld a,#4
    ld (lab896D),a
    ld a,#3e
    ld (lab896F),a
    ld a,#1
    ld (lab8943),a
    ld a,#c3
    ld (lab8977),a
    jp lab1E9C
lab1ECE ld a,(lab8985)
    ld e,a
    ld a,#c8
    cp e
    jp nc,lab1EE5
    ld a,(lab88DB)
    ld e,a
    ld a,#e
    cp e
    jp nc,lab1EE5
    jp lab1F0E
lab1EE5 ld a,(lab88DB)
    ld c,#23
    add a,c
    ld (lab896D),a
    ld a,#3e
    ld (lab896F),a
    ld a,#3
    ld (lab8943),a
    jp lab1EA7
lab1EFB ld a,(lab88DB)
    ld (lab896D),a
    ld a,#f0
    ld (lab896F),a
    ld a,#4
    ld (lab8943),a
    jp lab1EA7
lab1F0E ld a,(lab88DB)
    ld c,#18
    sub c
    ld (lab896D),a
    ld a,#3e
    ld (lab896F),a
    ld a,#5
    ld (lab8943),a
    jp lab1EA7
lab1F24 call lab1F65
    ld hl,(lab8913)
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld (lab0066),hl
    ld hl,(lab0066)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab895B),a
    ld hl,(lab0066)
    ld a,(hl)
    ld (lab895D),a
    ld a,#c3
    ld (lab8977),a
    ld a,#62
    ld hl,lab895D
    ld c,(hl)
    sub c
    ld (lab896D),a
    ld a,#f0
    ld (lab896F),a
    ld a,#6
    ld (lab8943),a
    ret 
lab1F65 ld hl,(lab88E1)
    ld bc,lab0005
    call lab77DB
    ld bc,lab36CE
    add hl,bc
    ld (lab898D),hl
    ld hl,(lab898D)
    ld a,(hl)
    ld (lab8913),a
    ld hl,(lab898D)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab8945),a
    ld hl,(lab898D)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab8947),a
    ld hl,(lab898D)
    ld bc,lab0003
    add hl,bc
    ld a,(hl)
    ld (lab8989),a
    ld hl,(lab898D)
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    ld (lab898B),a
    ret 
lab1FA9 ld hl,lab0064
    ex de,hl
    ld a,(lab8929)
    ld (de),a
    inc de
    ld a,(lab892B)
    ld (de),a
    ld hl,(lab8913)
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld (lab0066),hl
    call lab80E8
    ret 
lab1FCC ld a,#0
    ld (lab898F),a
    call lab877E
    ld hl,lab3E40
    ld bc,(lab8907)
    add hl,bc
    ld (lab8991),hl
    ld hl,lab741B+1
    ex de,hl
    ld hl,lab85DA
    call lab76ED
    call lab21D7
lab1FEC ld hl,(lab8991)
    ld a,(hl)
    ld c,#1
    sub c
    ld (lab8993),a
    ld hl,(lab8991)
    ld bc,lab0001
    add hl,bc
    ld (lab8991),hl
    call lab2004
    ret 
lab2004 ld hl,(lab8991)
    ld a,(hl)
    ld (lab895F),a
    ld hl,(lab8991)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab8995),a
    ld hl,(lab8991)
    ld bc,lab0002
    add hl,bc
    ld a,(hl)
    ld (lab8997),a
    ld hl,(lab8991)
    ld bc,lab0003
    add hl,bc
    ld a,(hl)
    ld (lab8999),a
    ld a,(lab8999)
    ld (lab899B),a
    ld a,(lab8999)
    ld e,a
    ld a,#fb
    cp e
    jp nc,lab2055
    ld hl,(lab8991)
    ld bc,lab0004
    add hl,bc
    ld a,(hl)
    ld (lab899D),a
    ld hl,(lab8991)
    ld bc,lab0005
    add hl,bc
    ld a,(hl)
    ld (lab899B),a
    jp lab2076
lab2055 call lab20CF
lab2058 ld hl,(lab8991)
    ld bc,lab0004
    add hl,bc
    ld (lab8991),hl
    ld a,(lab8993)
    ld c,#4
    sub c
    ld (lab8993),a
    ld a,(lab8993)
    or a
    jp nz,lab2073
    ret 
lab2073 jp lab2004
lab2076 ld a,#1
    ld (lab0072),a
    ld a,(lab899D)
    ld (lab00A6),a
lab2081 call lab20CF
    ld a,(lab8999)
    ld e,a
    ld a,#fc
    cp e
    jp nz,lab2099
    ld a,(lab8995)
    ld hl,lab006E
    ld c,(hl)
    add a,c
    ld (lab8995),a
lab2099 ld a,(lab8999)
    ld e,a
    ld a,#fe
    cp e
    jp nz,lab20AE
    ld a,(lab8997)
    ld hl,lab006C
    ld c,(hl)
    add a,c
    ld (lab8997),a
lab20AE ld hl,lab0072
    inc (hl)
    ld a,(lab00A6)
    cp (hl)
    jp nc,lab2081
    ld hl,(lab8991)
    ld bc,lab0002
    add hl,bc
    ld (lab8991),hl
    ld a,(lab8993)
    ld c,#2
    sub c
    ld (lab8993),a
    jp lab2058
lab20CF ld a,(lab898F)
    or a
    jp nz,lab20D9
    jp lab20FA
lab20D9 ld hl,(lab895F)
    ld bc,lab0002
    call lab77DB
    ld bc,lab711C
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab685C
    add hl,bc
    ld (lab8913),hl
    ld hl,(lab8913)
    ld (lab0066),hl
    jp lab2151
lab20FA ld a,#0
    ld (lab899F),a
    ld hl,(lab895F)
    ex de,hl
    ld hl,lab0033
    xor a
    sbc hl,de
    jp nc,lab211D
    ld hl,(lab895F)
    ld bc,lab0034
    xor a
    sbc hl,bc
    ld (lab895F),hl
    ld a,#1
    ld (lab899F),a
lab211D ld hl,(lab895F)
    ld bc,lab0002
    call lab77DB
    ld bc,lab67F4
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld bc,lab3F4C
    add hl,bc
    ld (lab8913),hl
    ld hl,(lab8913)
    ld (lab0066),hl
    ld hl,(lab0066)
    ld (lab89A1),hl
    call lab845B
    ld a,(lab899F)
    or a
    jp nz,lab2151
    ld hl,(lab89A1)
    ld (lab0066),hl
lab2151 ld hl,lab0064
    ex de,hl
    ld a,(lab8997)
    ld (de),a
    inc de
    ld a,(lab8995)
    ld (de),a
    ld hl,(lab8913)
    ld a,(hl)
    ld (lab006C),a
    ld hl,(lab8913)
    ld bc,lab0001
    add hl,bc
    ld a,(hl)
    ld (lab006E),a
    ld hl,(lab0066)
    ld bc,lab0002
    add hl,bc
    ld (lab0066),hl
    call lab7429
    ret 
lab217E ld hl,lab3ED7
    ld (lab8991),hl
    call lab2198
    call lab7581
    ret 
lab218B ld hl,lab3EAA
    ld (lab8991),hl
    call lab2198
    call lab7581
    ret 
lab2198 ld a,#1
    ld (lab898F),a
    call lab7588
    ld hl,lab741B+1
    ex de,hl
    ld hl,lab7B70
    call lab76ED
    call lab1FEC
    ret 
lab21AE call lab7588
    call lab7571
    ret 
data21b5 db #c9
lab21B6 call lab76B7
    ld (lab8985),a
    ret 
lab21BD ld hl,lab012E
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (lab0064),hl
    ld a,#0
    call lab7835
    ld hl,lab012E
    ex de,hl
    ld hl,(lab0064)
    call lab76ED
    ret 
lab21D7 ld hl,lab3D54
    ld bc,lab0012
    call lab758E
    ld hl,lab373C
    ld bc,lab0014
    call lab758E
    ret 
lab21EA ld a,(lab88FF)
    ld c,#1
    add a,c
    ld (lab88FF),a
    ld hl,(lab88F7)
    ld a,h
    or l
    jp z,lab2207
    ld hl,(lab88F7)
    ld bc,lab000B
    xor a
    sbc hl,bc
    ld (lab88F7),hl
lab2207 ld a,(lab88FF)
    ld e,a
    ld a,#a
    cp e
    jp nz,lab2222
    ld a,(lab8903)
    ld c,#1
    add a,c
    ld (lab8903),a
    ld a,#0
    ld (lab88FF),a
    jp lab2223
lab2222 ret 
lab2223 ld a,(lab8903)
    ld e,a
    ld a,#44
    cp e
    jp nc,lab2233
    ld a,#1
    ld (lab88F9),a
    ret 
lab2233 call lab223A
    call lab13EF
    ret 
lab223A ld hl,(lab8905)
    ld l,(hl)
    ld h,#0
    ld (lab895F),hl
    ld hl,(lab8905)
    ld bc,lab0001
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab0092),hl
    ld hl,(lab8905)
    ld bc,lab0002
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab0094),hl
    ld hl,(lab8905)
    ld bc,lab0003
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab8913),hl
    ld hl,(lab8905)
    ld bc,lab0004
    add hl,bc
    ld l,(hl)
    ld h,#0
    ld (lab8961),hl
    ld hl,(lab8905)
    ld bc,lab0005
    add hl,bc
    ld (lab8905),hl
    ret 
lab2282 ld hl,lab2CEC
    ld bc,(lab88F3)
    add hl,bc
    ld (lab0066),hl
    ld hl,(lab0066)
    ld a,(hl)
    ld (lab8919),a
    ld hl,lab7151
    ex de,hl
    ld a,(lab8919)
    ld (de),a
    ld hl,(lab0066)
    ld bc,lab0001
    add hl,bc
    ld (lab0066),hl
    ld hl,lab0002
    ld (lab0064),hl
    call lab714E
    ret 
data22b0 db #c3
db #b9,#74,#00,#00,#00,#00,#00,#00 ;.t......
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #18,#00,#00,#41,#41,#00,#82,#00 ;...AA...
db #00,#82,#41,#41,#00,#c3,#00,#82 ;..AA....
db #00,#c3,#41,#c3,#00,#c3,#00,#c3 ;..A.....
db #00,#00,#00,#87,#c7,#41,#cb,#00 ;.....A..
db #00,#cb,#87,#c7,#41,#4f,#41,#cb ;....AOA.
db #41,#4f,#87,#4f,#41,#4f,#41,#4f ;AO.OAOAO
db #00,#00,#00,#c7,#c7,#87,#c7,#00
db #00,#cb,#c7,#c7,#87,#c3,#41,#cb ;......A.
db #87,#c3,#41,#4b,#87,#c7,#87,#c3 ;..AK....
db #00,#00,#00,#87,#cf,#87,#87,#00
db #00,#4b,#87,#cf,#41,#cb,#41,#4b ;.K..A.AK
db #41,#cb,#41,#4b,#87,#87,#41,#cb ;A.AK..A.
db #00,#00,#00,#87,#c7,#87,#87,#00
db #00,#4b,#87,#c7,#41,#c7,#41,#4b ;.K..A.AK
db #41,#c7,#41,#4b,#87,#0f,#41,#c7 ;A.AK..A.
db #00,#00,#00,#87,#87,#87,#87,#00
db #00,#4b,#87,#87,#87,#c7,#41,#4b ;.K....AK
db #87,#c7,#41,#4b,#87,#87,#87,#c7 ;..AK....
db #00,#00,#00,#87,#87,#41,#4b,#00 ;.....AK.
db #00,#4b,#87,#87,#41,#0f,#41,#4b ;.K..A.AK
db #41,#0f,#41,#4b,#87,#87,#41,#0f ;A.AK..A.
db #00,#00,#00,#41,#41,#00,#82,#00 ;...AA...
db #00,#82,#41,#41,#00,#c3,#00,#82 ;..AA....
db #00,#c3,#00,#82,#41,#41,#00,#c3 ;....AA..
db #00,#41,#c3,#41,#c3,#00,#41,#41 ;.A.A..AA
db #00,#c3,#00,#c3,#00,#41,#c3,#00 ;.....A..
db #c3,#00,#c3,#00,#c3,#41,#82,#00 ;.....A..
db #82,#87,#4f,#87,#4f,#00,#87,#c7 ;..O.O...
db #41,#4f,#41,#4f,#00,#87,#4f,#41 ;AOAO..OA
db #4f,#41,#4f,#41,#4f,#87,#cb,#41 ;OAOAO..A
db #cb,#41,#4b,#87,#c3,#00,#87,#c7 ;.AK.....
db #87,#c7,#87,#c3,#00,#87,#c7,#87
db #c7,#87,#c3,#87,#c7,#87,#c7,#87
db #c7,#41,#4b,#87,#87,#00,#87,#0f ;.AK.....
db #87,#87,#41,#cb,#00,#87,#87,#87 ;..A.....
db #87,#41,#cb,#87,#87,#87,#87,#87 ;.A......
db #87,#41,#4b,#87,#c3,#00,#87,#87 ;.AK.....
db #87,#0f,#41,#c7,#00,#87,#4b,#87 ;..A...K.
db #0f,#41,#c7,#87,#0f,#87,#87,#87 ;.A......
db #87,#41,#4b,#87,#c3,#00,#87,#87 ;.AK.....
db #87,#87,#87,#c7,#00,#87,#82,#87
db #87,#87,#c7,#87,#87,#87,#87,#87
db #87,#41,#4b,#87,#0f,#00,#87,#87 ;.AK.....
db #87,#87,#41,#0f,#00,#87,#82,#87 ;..A.....
db #87,#41,#0f,#87,#87,#87,#0f,#41 ;.A.....A
db #4b,#00,#82,#41,#c3,#00,#41,#41 ;K..A..AA
db #41,#41,#00,#c3,#00,#41,#00,#41 ;AA...A.A
db #41,#00,#c3,#41,#41,#41,#c3,#00 ;A..AAA..
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab28A0 db #44
db #45,#52,#45,#43,#48,#41,#20,#20 ;ERECHA..
db #49,#5a,#51,#55,#49,#45,#52,#44 ;IZQUIERD
db #41,#20,#20,#53,#55,#42,#49,#52 ;A..SUBIR
db #20,#20,#20,#46,#55,#45,#47,#4f ;...FUEGO
db #2d,#31,#20,#20,#20,#42,#41,#4a ;.....BAJ
db #41,#52,#20,#20,#20,#46,#55,#45 ;AR...FUE
db #47,#4f,#2d,#32,#20,#52,#45,#49 ;GO...REI
db #4e,#49,#43,#49,#41,#52,#20,#20 ;NICIAR..
db #50,#41,#55,#53,#41,#20,#20,#00 ;PAUSA...
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#f3
db #01,#92,#f7,#ed,#49,#05,#0e,#10 ;....I...
db #ed,#49,#08,#f5,#d9,#c5,#01,#00 ;.I......
db #f5,#d9,#dd,#21,#8f,#87,#11,#19
db #07,#3e,#ff,#37,#cd,#c5,#90,#dd
db #21,#36,#01,#11,#26,#67,#3e,#ff ;.....g..
db #37,#cd,#c5,#90,#01,#82,#f7,#ed
db #49,#d9,#c1,#ed,#49,#d9,#f1,#08 ;I...I...
db #fb,#c3,#36,#01,#14,#08,#15,#01
db #10,#7f,#ed,#49,#0e,#4b,#ed,#49 ;...I.K.I
db #d9,#ed,#78,#d9,#1f,#e6,#40,#f6 ;..x.....
db #02,#4f,#bf,#c0,#cd,#5b,#91,#30 ;.O......
db #fa,#21,#15,#04,#10,#fe,#2b,#7c
db #b5,#20,#f9,#cd,#57,#91,#30,#eb ;....W...
db #06,#9c,#cd,#57,#91,#30,#e4,#3e ;...W....
db #c6,#b8,#30,#e0,#24,#20,#f1,#06
db #c9,#cd,#5b,#91,#30,#d5,#78,#fe ;......x.
db #d4,#30,#f4,#cd,#5b,#91,#d0,#79 ;.......y
db #ee,#03,#4f,#26,#00,#06,#cd,#18 ;..O.....
db #1f,#08,#20,#07,#30,#0f,#dd,#75 ;.......u
db #00,#18,#0f,#cb,#11,#ad,#c0,#79 ;.......y
db #1f,#4f,#13,#18,#07,#dd,#7e,#00 ;.O......
db #ad,#c0,#dd,#23,#1b,#08,#06,#ce
db #2e,#01,#cd,#57,#91,#d0,#3e,#dc ;...W....
db #b8,#cb,#15,#06,#cd,#30,#f3,#7c
db #ad,#67,#7a,#b3,#20,#cb,#01,#00 ;.gz.....
db #7f,#3e,#54,#ed,#79,#c9,#cd,#5b ;..T.y...
db #91,#d0,#3e,#18,#3d,#20,#fd,#a7
db #04,#c8,#d9,#ed,#78,#d9,#1f,#a9 ;....x...
db #e6,#40,#28,#f4,#79,#ee,#40,#e6 ;....y...
db #5f,#3c,#4f,#e6,#3f,#f6,#40,#d9 ;..O.....
db #06,#7f,#ed,#79,#06,#f5,#d9,#37 ;...y....
db #c9,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#05,#00,#00,#00,#00
db #00,#00,#00,#00
lab2A9D db #95
db #2b,#00,#00,#25,#2c,#ca,#2c,#95
db #2b,#00,#00,#25,#2c,#ca,#2c,#b6
db #2b,#00,#00,#46,#2c,#ca,#2c,#b6 ;...F....
db #2b,#00,#00,#67,#2c,#ca,#2c,#b6 ;...g....
db #2b,#00,#00,#88,#2c,#ca,#2c,#b6
db #2b,#00,#00,#a9,#2c,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#4d ;.......M
db #2b,#00,#00,#d7,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#71 ;.......q
db #2b,#00,#00,#fe,#2b,#ca,#2c,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#0c
db #38,#02,#06,#00,#00,#06,#38,#02
db #0c,#de,#01,#0c,#38,#02,#06,#00
db #00,#0c,#de,#01,#06,#de,#01,#0c
db #f6,#02,#0c,#7e,#02,#30,#00,#00
db #ff,#de,#01,#0c,#aa,#01,#06,#00
db #00,#06,#aa,#01,#0c,#66,#01,#0c ;.....f..
db #aa,#01,#06,#00,#00,#0c,#66,#01 ;......f.
db #06,#66,#01,#0c,#aa,#01,#0c,#de ;.f......
db #01,#0c,#00,#00,#ff,#00,#00,#06
db #24,#00,#06,#24,#00,#06,#24,#00
db #0c,#24,#00,#0c,#24,#00,#0c,#24
db #00,#06,#24,#00,#06,#24,#00,#06
db #24,#00,#30,#00,#00,#ff,#00,#00
db #06,#47,#00,#06,#47,#00,#06,#47 ;.G..G..G
db #00,#0c,#47,#00,#0c,#47,#00,#0c ;..G..G..
db #47,#00,#06,#47,#00,#06,#47,#00 ;G..G..G.
db #06,#47,#00,#06,#00,#00,#ff,#00 ;.G......
db #00,#0c,#8e,#00,#0c,#00,#00,#06
db #00,#00,#06,#8e,#00,#06,#7f,#00
db #06,#8e,#00,#0c,#77,#00,#06,#77 ;....w..w
db #00,#0c,#6a,#00,#06,#6a,#00,#0c ;..j..j..
db #5f,#00,#0c,#00,#00,#ff,#00,#00
db #0c,#6a,#00,#0c,#00,#00,#06,#00 ;.j......
db #00,#06,#6a,#00,#06,#5f,#00,#06 ;..j.....
db #6a,#00,#0c,#59,#00,#06,#59,#00 ;j..Y..Y.
db #0c,#50,#00,#06,#50,#00,#0c,#47 ;.P..P..G
db #00,#06,#00,#00,#ff,#47,#00,#06 ;.....G..
db #00,#00,#06,#00,#00,#06,#00,#00
db #0c,#00,#00,#0c,#00,#00,#0c,#00
db #00,#06,#00,#00,#06,#00,#00,#06
db #00,#00,#06,#00,#00,#ff,#00,#00
db #06,#47,#00,#06,#47,#00,#06,#47 ;.G..G..G
db #00,#0c,#47,#00,#0c,#47,#00,#0c ;..G..G..
db #47,#00,#06,#47,#00,#06,#47,#00 ;G..G..G.
db #06,#47,#00,#06,#00,#00,#ff,#00 ;.G......
db #00,#06,#50,#00,#06,#50,#00,#06 ;..P..P..
db #50,#00,#0c,#50,#00,#0c,#50,#00 ;P..P..P.
db #0c,#50,#00,#06,#50,#00,#06,#50 ;.P..P..P
db #00,#06,#50,#00,#06,#00,#00,#ff ;..P.....
db #00,#00,#06,#59,#00,#06,#59,#00 ;...Y..Y.
db #06,#59,#00,#0c,#59,#00,#0c,#59 ;.Y..Y..Y
db #00,#0c,#59,#00,#06,#59,#00,#06 ;..Y..Y..
db #59,#00,#06,#59,#00,#06,#00,#00 ;Y..Y....
db #ff,#00,#00,#06,#5f,#00,#06,#5f
db #00,#06,#5f,#00,#0c,#5f,#00,#0c
db #5f,#00,#0c,#5f,#00,#06,#5f,#00
db #06,#5f,#00,#06,#5f,#00,#06,#00
db #00,#ff,#00,#00,#0f,#0e,#0d,#0c
db #0b,#0a,#09,#08,#07,#06,#0f,#0e
db #0d,#0c,#0b,#0a,#09,#08,#07,#06
db #0f,#0e,#0d,#0c,#0b,#0a,#09,#08
db #07,#06,#00,#00,#00,#00
lab2CEC db #0
db #54,#1e,#74,#1c,#94,#1a,#b4,#18 ;T.t.....
db #d4,#16,#f4,#14,#e4,#50,#d4,#8c ;.....P..
db #c4,#c8,#b5,#04,#a5,#40,#95,#7c
db #85,#b8,#75,#f4,#66,#30,#56,#6c ;..u.f.Vl
db #46,#a8,#36,#e4,#27,#20,#17,#5c ;F.......
db #ff,#00,#57,#84,#67,#3e,#76,#f8 ;..W.g.v.
db #86,#b2,#96,#6c,#a6,#26,#b5,#e0 ;...l....
db #c5,#9a,#d5,#54,#e5,#0e,#f4,#c8 ;...T....
db #e4,#e6,#d5,#04,#c5,#22,#b5,#40
db #a5,#5e,#95,#7c,#85,#9a,#75,#b8 ;......u.
db #65,#d6,#55,#f4,#46,#12,#36,#30 ;e.U.F...
db #26,#4e,#16,#6c,#06,#8a,#ff,#00 ;.N.l....
db #a5,#2c,#ff,#00,#f0,#64,#00,#5a ;.....d.Z
db #f0,#50,#00,#46,#e0,#41,#00,#3c ;.P.F.A..
db #d0,#37,#00,#32,#a0,#30,#00,#2e
db #80,#2c,#00,#2c,#40,#2a,#00,#2a
db #20,#28,#00,#28,#10,#26,#00,#26
db #ff,#02,#e5,#90,#f5,#f4,#e5,#d6
db #d5,#b8,#c5,#9a,#b5,#7c,#a5,#5e
db #95,#40,#85,#22,#75,#04,#64,#e6 ;....u.d.
db #44,#e6,#24,#e6,#04,#e6,#ff,#01 ;D.......
db #e0,#32,#ff,#00,#f4,#32,#f4,#28
db #f4,#1e,#ff,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab2DB0 db #30
db #30,#8b,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#87,#8a,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#87,#8a,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#87,#4f,#02,#00,#00,#00,#00 ;..O.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#0f,#4f,#cf,#cf,#8b,#00 ;.A.O....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#0f,#0f,#0f,#0f,#0f,#cf ;.A......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#0f,#0f,#0f,#00
db #00,#41,#0f,#0f,#0f,#0f,#0f,#0f ;.A......
db #8a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#0f,#0f,#0f,#0f,#02
db #00,#00,#87,#0f,#0f,#0f,#0f,#0f
db #4f,#00,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#0a,#00,#00,#00,#05,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#0f,#0f,#0f,#8a
db #00,#00,#05,#0f,#0f,#0f,#0f,#0f
db #0f,#8a,#00,#00,#00,#00,#05,#00
db #00,#0b,#00,#00,#00,#05,#02,#00
db #00,#0a,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#0f,#0f,#cf,#87,#0f,#8a
db #00,#00,#05,#0f,#0f,#c3,#c3,#0f
db #0f,#4f,#00,#00,#00,#00,#05,#00 ;.O......
db #00,#0f,#8a,#00,#00,#0f,#8a,#00
db #00,#0a,#00,#00,#00,#0a,#00,#00
db #00,#00,#00,#00,#00,#05,#00,#00
db #00,#05,#0f,#4f,#00,#87,#0f,#8a ;...O....
db #00,#00,#05,#0f,#05,#8a,#00,#87
db #0f,#0f,#8a,#00,#00,#00,#05,#02
db #00,#0f,#8a,#00,#00,#0f,#8a,#00
db #00,#0a,#00,#00,#05,#0a,#00,#00
db #00,#00,#00,#00,#00,#05,#02,#00
db #00,#05,#0f,#8a,#00,#87,#0f,#8a
db #00,#00,#05,#0f,#45,#00,#00,#41 ;....E..A
db #0f,#0f,#4f,#00,#00,#00,#05,#8a ;..O.....
db #00,#0f,#8a,#00,#00,#0f,#8a,#00
db #05,#0b,#00,#00,#05,#0b,#00,#00
db #00,#00,#01,#00,#00,#05,#8a,#00
db #00,#0f,#0f,#8a,#00,#41,#c3,#8a ;.....A..
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #87,#0f,#4f,#00,#00,#00,#05,#8a ;..O.....
db #00,#0f,#8a,#00,#00,#0f,#8a,#00
db #05,#4f,#00,#00,#05,#4f,#00,#00 ;.O...O..
db #00,#00,#45,#00,#00,#05,#8a,#00 ;..E.....
db #05,#0f,#4f,#00,#00,#00,#00,#00 ;..O.....
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #41,#0f,#0f,#8a,#00,#00,#0f,#8a ;A.......
db #00,#0f,#4f,#00,#00,#0f,#8a,#00 ;..O.....
db #05,#4f,#00,#00,#05,#4f,#00,#00 ;.O...O..
db #00,#00,#4f,#00,#00,#0f,#8a,#00 ;..O.....
db #05,#0f,#4f,#00,#00,#00,#00,#00 ;..O.....
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#87,#0f,#4f,#00,#00,#0f,#8a ;...O....
db #00,#0f,#4f,#00,#00,#0f,#8a,#00 ;..O.....
db #0f,#4f,#00,#00,#05,#0f,#8a,#00 ;.O......
db #00,#00,#4f,#00,#00,#0f,#8a,#00 ;..O.....
db #0f,#0f,#8a,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#87,#0f,#4f,#00,#00,#0f,#8a ;...O....
db #00,#0f,#4f,#00,#00,#0f,#8a,#00 ;..O.....
db #0f,#4f,#00,#00,#05,#0f,#8a,#00 ;.O......
db #00,#00,#0f,#8a,#00,#0f,#8a,#00
db #0f,#0f,#8a,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#41,#0f,#0f,#8a,#05,#0f,#8a ;.A......
db #00,#0f,#0f,#8a,#00,#0f,#8a,#00
db #0f,#0f,#8a,#00,#05,#0f,#8a,#00
db #00,#00,#0f,#8a,#00,#0f,#8a,#00
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#41,#0f,#0f,#8a,#05,#0f,#8a ;.A......
db #00,#0f,#0f,#8a,#00,#0f,#8a,#00
db #0f,#87,#8a,#00,#05,#0f,#4f,#00 ;......O.
db #00,#00,#0f,#8a,#05,#0f,#8a,#00
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#41,#0f,#0f,#8a,#00,#0f,#8a ;.A......
db #00,#0f,#0f,#8a,#00,#0f,#8a,#00
db #0f,#87,#8a,#00,#05,#0f,#4f,#00 ;......O.
db #00,#00,#0f,#8a,#05,#0f,#8a,#05
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#87,#0f,#4f,#00,#0f,#8a ;....O...
db #00,#0f,#0f,#8a,#00,#0f,#8a,#00
db #0f,#87,#8a,#00,#05,#0f,#4f,#00 ;......O.
db #00,#05,#0f,#8a,#05,#0f,#8a,#05
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#87,#0f,#4f,#00,#0f,#8a ;....O...
db #00,#0f,#0f,#8a,#00,#0f,#8a,#00
db #0f,#87,#8a,#00,#05,#cb,#4f,#00 ;......O.
db #00,#05,#0f,#8a,#00,#0f,#8a,#05
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#87,#0f,#4f,#00,#0f,#8a ;....O...
db #00,#0f,#0f,#4f,#00,#0f,#8a,#00 ;...O....
db #0f,#87,#8a,#00,#05,#cb,#4f,#00 ;......O.
db #00,#05,#0f,#8a,#00,#0f,#8a,#0f
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#4f,#00,#0f,#8a,#00 ;...O....
db #0f,#87,#8a,#00,#05,#cb,#4f,#00 ;......O.
db #00,#05,#0f,#8a,#00,#0f,#8a,#0f
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#4f,#00,#0f,#8a,#00 ;...O....
db #0f,#87,#8a,#00,#05,#cb,#0f,#8a
db #00,#05,#8f,#8a,#00,#0f,#8a,#0f
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#4f,#00,#0f,#8a,#00 ;...O....
db #0f,#87,#8a,#00,#0f,#cb,#0f,#8a
db #05,#0f,#8f,#8a,#00,#0f,#8a,#0f
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#4f,#00,#0f,#8a,#00 ;...O....
db #0f,#87,#4f,#00,#0f,#cb,#0f,#8a ;..O.....
db #05,#0f,#8f,#8a,#00,#0f,#8a,#0f
db #4f,#8a,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#4f,#00,#0f,#8a,#05 ;...O....
db #0f,#c3,#4f,#00,#0f,#8a,#87,#8a ;..O.....
db #05,#0f,#8f,#8a,#00,#0f,#8a,#0f
db #4f,#00,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#0f,#8a,#0f,#8a,#05
db #0f,#c3,#4f,#00,#0f,#8a,#87,#8a ;..O.....
db #05,#0f,#8f,#8a,#00,#0f,#8a,#0f
db #4f,#00,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#8f,#0f,#8a,#0f,#8a,#05
db #4f,#41,#4f,#00,#0f,#8a,#87,#4f ;OAO....O
db #0f,#4f,#05,#8a,#00,#0f,#8a,#0f ;.O......
db #4f,#00,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#41,#0f,#0f,#8a,#0f,#8a ;..A.....
db #00,#0f,#cb,#0f,#8a,#0f,#8a,#05
db #4f,#41,#4f,#00,#0f,#8a,#87,#4f ;OAO....O
db #0f,#4f,#05,#8a,#00,#0f,#8a,#0f ;.O......
db #4f,#00,#00,#00,#00,#00,#00,#00 ;O.......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#05,#0f,#0f,#03,#0f,#03
db #03,#0f,#cb,#0f,#8a,#0f,#03,#05
db #0b,#41,#0b,#03,#0f,#03,#87,#0f ;.A......
db #0f,#4f,#05,#0b,#03,#0f,#03,#0f ;.O......
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#05,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#cb,#0f,#8a,#0f,#0f,#05
db #0f,#07,#0f,#0f,#0f,#0f,#cb,#0f
db #0f,#0f,#8f,#0f,#0f,#0f,#0f,#0f
db #0f,#8a,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#00,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#cb,#0f,#8a,#0f,#0f,#05
db #0f,#0f,#0f,#0f,#0f,#0f,#cb,#0f
db #0f,#0f,#8f,#0f,#0f,#0f,#0f,#0f
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#05,#0f,#45,#00,#00,#00 ;....E...
db #00,#05,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#cb,#0f,#4f,#0f,#0f,#05 ;....O...
db #0f,#0f,#0f,#0f,#0f,#0f,#41,#0f ;......A.
db #0f,#0f,#05,#0f,#0f,#0f,#0f,#0f
db #0f,#4f,#00,#00,#00,#00,#00,#00 ;.O......
db #00,#00,#0f,#0f,#45,#00,#00,#00 ;....E...
db #00,#05,#0f,#0f,#4b,#c3,#0f,#c3 ;....K...
db #c3,#0f,#cb,#0f,#4f,#0f,#82,#05 ;....O...
db #0f,#4b,#0f,#c3,#0f,#c3,#c3,#0f ;.K......
db #0f,#4b,#05,#4b,#c3,#0f,#c3,#87 ;.K.K....
db #0f,#0f,#8a,#00,#00,#00,#00,#00
db #00,#00,#0f,#0f,#45,#00,#00,#00 ;....E...
db #00,#0f,#0f,#0f,#8a,#00,#0f,#8a
db #00,#0f,#8a,#87,#4f,#0f,#8a,#0f ;....O...
db #0f,#4b,#0f,#cb,#0f,#8a,#41,#0f ;.K....A.
db #0f,#8a,#05,#4f,#87,#0f,#8a,#41 ;...O...A
db #0f,#0f,#4f,#00,#00,#00,#00,#00 ;..O.....
db #00,#00,#0f,#0f,#45,#00,#00,#00 ;....E...
db #00,#0f,#0f,#4f,#00,#87,#0f,#8a ;...O....
db #00,#0f,#8a,#87,#4f,#0f,#8a,#0f ;....O...
db #4b,#4b,#0f,#8a,#87,#8a,#41,#0f ;KK....A.
db #0f,#8a,#05,#4f,#87,#0f,#8a,#41 ;...O...A
db #0f,#0f,#0f,#8a,#00,#00,#00,#00
db #00,#00,#0f,#0f,#45,#00,#00,#00 ;....E...
db #05,#0f,#0f,#4f,#00,#87,#0f,#8a ;...O....
db #00,#0f,#8a,#87,#4f,#0f,#8a,#0f ;....O...
db #4f,#82,#87,#4f,#87,#8a,#41,#0f ;O..O..A.
db #0f,#8a,#05,#4f,#41,#0f,#8a,#00 ;...OA...
db #87,#0f,#0f,#4f,#00,#00,#00,#00 ;...O....
db #00,#00,#0f,#0f,#45,#00,#00,#00 ;....E...
db #0f,#0f,#0f,#8a,#00,#41,#0f,#8a ;.....A..
db #00,#0f,#8a,#87,#4f,#0f,#8a,#0f ;....O...
db #4f,#00,#87,#4f,#87,#8a,#00,#87 ;O..O....
db #0f,#8a,#05,#4f,#41,#0f,#8a,#00 ;...OA...
db #41,#0f,#0f,#0f,#8a,#00,#00,#00 ;A.......
db #00,#00,#0f,#0f,#45,#00,#00,#05 ;....E...
db #0f,#0f,#4f,#00,#00,#41,#0f,#8a ;..O..A..
db #00,#0f,#8a,#87,#4f,#0f,#8a,#0f ;....O...
db #4f,#00,#87,#4f,#87,#8a,#00,#87 ;O..O....
db #0f,#8a,#05,#4f,#41,#0f,#8a,#00 ;...OA...
db #00,#0f,#0f,#0f,#4f,#8a,#00,#00 ;....O...
db #cf,#00,#0f,#0f,#45,#00,#00,#0f ;....E...
db #0f,#0f,#8a,#00,#00,#41,#0f,#8a ;.....A..
db #05,#0f,#8a,#41,#0f,#0f,#8a,#87 ;...A....
db #4f,#00,#87,#8a,#87,#8a,#00,#87 ;O.......
db #4f,#00,#05,#4f,#41,#0f,#8a,#00 ;O..OA...
db #00,#87,#0f,#0f,#0f,#4f,#8a,#45 ;.....O.E
db #4f,#00,#0f,#0f,#45,#00,#0f,#0f ;O...E...
db #0f,#cf,#00,#00,#00,#00,#87,#8a
db #05,#0f,#8a,#41,#0f,#0f,#8a,#87 ;...A....
db #4f,#00,#87,#8a,#87,#8a,#00,#41 ;O......A
db #4f,#00,#05,#4f,#41,#0f,#8a,#00 ;O..OA...
db #00,#41,#0f,#0f,#0f,#0f,#4f,#8f ;.A....O.
db #4f,#05,#0f,#0f,#05,#0f,#0f,#0f ;O.......
db #4f,#00,#00,#00,#00,#00,#87,#8a ;O.......
db #05,#0f,#8a,#41,#0f,#0f,#8a,#87 ;...A....
db #4f,#00,#87,#8a,#87,#8a,#00,#41 ;O......A
db #4f,#00,#05,#4f,#00,#87,#8a,#00 ;O..O....
db #00,#00,#c3,#0f,#0f,#0f,#0f,#0f
db #4f,#05,#0f,#0f,#0f,#0f,#0f,#0f ;O.......
db #8a,#00,#00,#00,#00,#00,#87,#8a
db #05,#0f,#8a,#00,#87,#0f,#8a,#87
db #4f,#00,#87,#8a,#41,#8a,#00,#41 ;O...A..A
db #4f,#00,#05,#8a,#00,#87,#8a,#00 ;O.......
db #00,#00,#00,#87,#0f,#0f,#0f,#0f
db #4f,#41,#0f,#0f,#0f,#0f,#0f,#cf ;OA......
db #00,#00,#00,#00,#00,#00,#87,#8a
db #41,#0f,#8a,#00,#87,#0f,#8a,#87 ;A.......
db #4f,#00,#87,#8a,#00,#8a,#00,#00 ;O.......
db #83,#00,#05,#8a,#00,#87,#8a,#00
db #00,#00,#00,#41,#0f,#0f,#0f,#0f ;...A....
db #4f,#41,#0f,#0f,#0f,#0f,#cf,#00 ;OA......
db #00,#00,#00,#00,#00,#00,#87,#8a
db #41,#0f,#8a,#00,#87,#0f,#8a,#87 ;A.......
db #8a,#00,#41,#8a,#00,#8a,#00,#00 ;..A.....
db #00,#00,#05,#8a,#00,#87,#8a,#00
db #00,#00,#00,#00,#c3,#0f,#0f,#0f
db #4f,#00,#87,#cf,#cf,#8b,#00,#00 ;O.......
db #00,#00,#00,#00,#00,#00,#87,#8a
db #41,#0f,#8a,#00,#41,#0f,#8a,#87 ;A...A...
db #8a,#00,#00,#02,#00,#02,#00,#00
db #00,#00,#05,#8a,#00,#87,#8a,#00
db #00,#00,#00,#00,#00,#c3,#87,#0f
db #c3,#00,#c3,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#41,#02 ;......A.
db #00,#c3,#02,#00,#41,#0b,#00,#41 ;....A..A
db #02,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#41,#02,#00,#41,#02,#00 ;..A..A..
db #00,#00,#00,#00,#00,#00,#41,#c3 ;......A.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab36CE db #0
db #00,#00,#00,#00,#3a,#03,#f8,#04
db #00,#5c,#03,#fc,#05,#00,#66,#fd ;......f.
db #02,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab36EC db #1
db #48,#38,#18,#0a,#00,#10,#02,#00 ;H.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab370E db #0
db #30,#32,#34,#32,#30
lab3714 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#18,#0a,#01,#00,#00
lab373C db #3
db #48,#26,#10,#0c,#01,#4c,#ff,#00 ;H....L..
db #08,#07,#10,#16,#01,#42,#ff,#00 ;.....B..
db #02,#30,#10,#16,#01,#42,#fe,#00 ;.....B..
db #28,#39,#20,#04,#01,#4e,#ff,#ff ;.....N..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab376E db #2
db #fe
lab3770 db #6
db #05,#04,#04,#02,#02,#01,#00,#ff
db #fe,#fe,#fc,#fc,#fb,#fa,#00,#00
db #00
lab3782 db #1
db #27,#48,#4c,#ff,#02,#08,#08,#42 ;.HL....B
db #ff,#03,#32,#02,#42,#fe,#04,#3a ;....B...
db #28,#4e,#ff,#00,#00,#00,#00,#00 ;.N......
db #00,#00,#00,#00,#00,#02,#3d,#0a
db #40,#fe,#03,#3d,#14,#42,#ff,#00 ;.....B..
db #00,#00,#00,#00,#01,#46,#48,#4c ;.....FHL
db #ff,#02,#3d,#05,#40,#fe,#04,#42 ;.......B
db #2c,#42,#ff,#00,#00,#00,#00,#00 ;.B......
db #00,#00,#00,#00,#00,#02,#3e,#0f
db #40,#fe,#00,#00,#00,#00,#00,#03
db #3c,#48,#4c,#ff,#00,#00,#00,#00 ;.HL.....
db #00,#01,#3e,#03,#42,#ff,#00,#00 ;....B...
db #00,#00,#00,#04,#44,#28,#4e,#ff ;....D.N.
db #02,#3c,#08,#42,#ff,#00,#00,#00 ;...B....
db #00,#00,#00,#00,#00,#00,#00,#03
db #45,#48,#4c,#ff,#00,#00,#00,#00 ;EHL.....
db #00,#01,#3e,#0f,#42,#ff,#00,#00 ;....B...
db #00,#00,#00,#00,#00,#00,#00,#00
db #04,#44,#28,#4e,#ff,#02,#45,#48 ;.D.N..EH
db #4c,#ff,#00,#00,#00,#00,#00,#00 ;L.......
db #00,#00,#00,#00,#03,#45,#48,#4c ;.....EHL
db #ff,#00,#00,#00,#00,#00,#01,#3c
db #19,#40,#ff,#00,#00,#00
lab3839 db #0
db #00,#04,#3c,#28,#42,#ff,#00,#00 ;....B...
db #00,#00,#00,#02,#45,#48,#4c,#ff ;....EHL.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#03,#3c,#04,#42,#ff,#01 ;.....B..
db #3c,#48,#4c,#ff,#00,#00,#00,#00 ;.HL.....
db #00,#00,#00,#00,#00,#00,#04,#4e ;.......N
db #28,#4e,#ff,#00,#00,#00,#00,#00 ;.N......
db #02,#45,#48,#4c,#ff,#00,#00,#00 ;.EHL....
db #00,#00,#03,#3c,#14,#42,#ff,#01 ;.....B..
db #3e,#17,#40,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#04,#4e,#28,#4e,#ff ;....N.N.
db #00,#00,#00,#00,#00,#02,#45,#48 ;......EH
db #4c,#ff,#00,#00,#00,#00,#00,#01 ;L.......
db #3c,#05,#42,#ff,#03,#3c,#0c,#42 ;..B....B
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #04,#48,#28,#52,#ff,#00,#00,#00 ;.H.R....
db #00,#00,#02,#3c,#04,#42,#fe,#00 ;.....B..
db #00,#00,#00,#00,#01,#3c,#30,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#28,#0a
db #14,#30,#01,#24,#58,#36,#02,#02 ;....X...
db #33,#3c,#38,#02,#04,#28,#14,#42 ;.......B
db #02,#03,#05,#0f,#42,#02,#04,#e6 ;....B...
db #58,#60,#02,#01,#f2,#14,#40,#02 ;X.......
db #00,#00,#00,#00,#00,#02,#e6,#48 ;.......H
db #46,#01,#03,#e8,#19,#42,#01,#01 ;F....B..
db #f2,#5a,#44,#02,#04,#f2,#04,#40 ;.ZD.....
db #03,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#04,#f6,#58,#60,#03 ;.....X..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#01,#ec,#4c,#46,#02,#02 ;....LF..
db #f2,#0a,#40,#01,#03,#f2,#10,#40
db #02,#04,#e8,#19,#42,#01,#00,#00 ;....B...
db #00,#00,#00,#01,#f2,#52,#60,#02 ;.....R..
db #03,#ed,#48,#46,#01,#00,#00,#00 ;..HF....
db #00,#00,#00,#00,#00,#00,#00,#01
db #ec,#02,#42,#02,#02,#e6,#50,#60 ;..B...P.
db #02,#00,#00,#00,#00,#00,#04,#f5
db #58,#60,#03,#00,#00,#00,#00,#00 ;X.......
db #02,#ed,#48,#46,#01,#01,#f5,#14 ;..HF....
db #40,#02,#03,#f5,#50,#60,#02,#04 ;....P...
db #f6,#58,#60,#03,#00,#00,#00,#00 ;.X......
db #00,#03,#eb,#14,#42,#02,#00,#f5 ;....B...
db #50,#60,#02,#04,#f6,#5a,#60,#03 ;P....Z..
db #02,#f7,#50,#60,#02,#00,#00,#00 ;..P.....
db #00,#00,#00,#eb,#0f,#42,#02,#01 ;.....B..
db #f5,#0a,#40,#02,#03,#f5,#56,#44 ;......VD
db #02,#04,#f6,#58,#60,#03,#00,#00 ;...X....
db #00,#00,#00,#01,#ed,#48,#46,#01 ;.....HF.
db #02,#ec,#14,#42,#02,#03,#f5,#50 ;...B...P
db #60,#02,#00,#00,#00,#00,#00,#04
db #f6,#14,#40,#01,#00,#00,#00,#00
db #00,#02,#ed,#02,#42,#01,#03,#f6 ;....B...
db #50,#60,#02,#01,#ec,#28,#42,#02 ;P.....B.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#03,#ec,#1e,#42,#02,#04 ;.....B..
db #f5,#5a,#60,#03,#01,#ed,#48,#46 ;.Z....HF
db #01,#02,#ec,#14,#42,#02,#04,#ec ;....B...
db #28,#42,#02,#03,#f6,#50,#60,#02 ;.B...P..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#02,#f6,#1e,#40,#02,#04
db #ec,#28,#42,#01,#01,#dc,#58,#36 ;..B...X.
db #02,#03,#f0,#58,#60,#03,#02,#f6 ;...X....
db #50,#60,#02,#00,#00,#00,#00,#00 ;P.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#19
db #30,#14,#2a,#44,#01,#1e,#46,#5a ;...D..FZ
db #02,#02,#0a,#48,#46,#01,#04,#1e ;...HF...
db #14,#42,#02,#03,#05,#0f,#42,#02 ;.B....B.
db #00,#00,#00,#00,#00,#04,#ef,#50 ;.......P
db #58,#02,#00,#00,#00,#00,#00,#03 ;X.......
db #e6,#48,#46,#01,#02,#e8,#19,#42 ;.HF....B
db #01,#01,#f2,#5a,#56,#02,#04,#f2 ;...ZV...
db #04,#40,#03,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#04,#f6,#50 ;.......P
db #58,#03,#00,#00,#00,#00,#00,#00 ;X.......
db #00,#00,#00,#00,#01,#ec,#4c,#46 ;......LF
db #02,#02,#f2,#0a,#40,#01,#03,#f2
db #10,#40,#02,#04,#e8,#19,#42,#01 ;......B.
db #00,#00,#00,#00,#00,#01,#f2,#4a ;.......J
db #58,#02,#03,#ed,#48,#46,#01,#00 ;X...HF..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#01,#ec,#02,#42,#02,#02,#eb ;....B...
db #48,#58,#02,#00,#00,#00,#00,#00 ;HX......
db #04,#f5,#50,#58,#03,#00,#00,#00 ;..PX....
db #00,#00,#02,#ed,#48,#46,#01,#01 ;....HF..
db #f5,#14,#40,#02,#03,#f5,#48,#58 ;......HX
db #02,#04,#f6,#60,#56,#03,#00,#00 ;....V...
db #00,#00,#00,#01,#eb,#14,#42,#02 ;......B.
db #03,#f5,#48,#58,#02,#04,#f6,#62 ;..HX...b
db #56,#03,#02,#f7,#48,#58,#02,#00 ;V...HX..
db #00,#00,#00,#00,#01,#eb,#0f,#42 ;.......B
db #02,#02,#f5,#0a,#40,#03,#03,#f5
db #56,#56,#02,#04,#f6,#50,#58,#03 ;VV...PX.
db #00,#00,#00,#00,#00,#01,#ed,#48 ;.......H
db #46,#01,#02,#ec,#14,#42,#02,#03 ;F....B..
db #f5,#48,#58,#02,#00,#00,#00,#00 ;.HX.....
db #00,#04,#f6,#14,#40,#01,#00,#00
db #00,#00,#00,#02,#ed,#02,#42,#01 ;......B.
db #03,#f6,#48,#58,#02,#01,#ec,#28 ;..HX....
db #42,#02,#00,#00,#00,#00,#00,#00 ;B.......
db #00,#00,#00,#00,#03,#ec,#1e,#42 ;.......B
db #02,#04,#f5,#52,#58,#03,#01,#ed ;...RX...
db #48,#46,#01,#02,#ec,#14,#42,#02 ;HF....B.
db #04,#ec,#28,#42,#02,#03,#f6,#48 ;...B...H
db #58,#02,#00,#00,#00,#00,#00,#00 ;X.......
db #00,#00,#00,#00,#02,#f6,#1e,#40
db #02,#03,#ec,#28,#40,#02,#01,#dc
db #48,#5a,#02,#04,#f0,#50,#58,#03 ;HZ...PX.
db #02,#f6,#48,#58,#02,#00,#00,#00 ;..HX....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#34,#30,#14,#23,#34,#01,#1e
db #46,#5a,#02,#02,#0a,#48,#46,#01 ;FZ...HF.
db #03,#1e,#14,#42,#01,#04,#05,#0f ;...B....
db #42,#01,#00,#00,#00,#00,#00,#01 ;B.......
db #ef,#50,#46,#02,#00,#00,#00,#00 ;.PF.....
db #00,#03,#e6,#48,#46,#01,#02,#e8 ;...HF...
db #19,#42,#01,#01,#f2,#14,#40,#02 ;.B......
db #04,#f2
lab3C0C db #4
db #40,#01,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#01,#f6,#50,#46 ;......PF
db #02,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#01,#ec,#4c,#46,#02 ;.....LF.
db #02,#f2,#0a,#40,#01,#03,#f2,#10
db #40,#02,#04,#e8,#19,#42,#01,#00 ;.....B..
db #00,#00,#00,#00,#01,#f2,#52,#46 ;......RF
db #02,#03,#ed,#48,#46,#01,#00,#00 ;...HF...
db #00,#00,#00,#00,#00,#00,#00,#00
db #01,#ec,#02,#42,#01,#02,#e6,#50 ;...B...P
db #46,#02,#00,#00,#00,#00,#00,#04 ;F.......
db #f5,#58,#46,#03,#00,#00,#00,#00 ;.XF.....
db #00,#02,#ed,#48,#46,#01,#04,#f5 ;...HF...
db #14,#40,#02,#03,#f5,#50,#46,#02 ;.....PF.
db #01,#f6,#1a,#40,#03,#00,#00,#00
db #00,#00,#04,#eb,#14,#42,#02,#03 ;.....B..
db #f5,#50,#46,#02,#01,#f6,#1c,#40 ;.PF.....
db #03,#02,#f7,#50,#46,#02,#00,#00 ;...PF...
db #00,#00,#00,#00,#eb,#0f,#42,#01 ;......B.
db #01,#f5,#0a,#40,#02,#02,#f5,#10
db #40,#02,#04,#f6,#58,#46,#03,#00 ;....XF..
db #00,#00,#00,#00,#01,#ed,#48,#46 ;......HF
db #01,#02,#ec,#14,#42,#02,#03,#f5 ;....B...
db #50,#46,#02,#00,#00,#00,#00,#00 ;PF......
db #04,#f6,#14,#40,#01,#00,#00,#00
db #00,#00,#02,#ed,#02,#42,#01,#03 ;.....B..
db #f6,#50,#46,#02,#01,#ec,#28,#42 ;.PF....B
db #02,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#03,#ec,#1e,#42,#02 ;......B.
db #04,#f5,#5a,#46,#03,#01,#ed,#48 ;..ZF...H
db #46,#01,#02,#ec,#14,#42,#02,#04 ;F....B..
db #ec,#28,#42,#02,#03,#f6,#50,#46 ;..B...PF
db #02,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#02,#f6,#1e,#40,#02
db #03,#ec,#28,#40,#02,#01,#dc,#48 ;.......H
db #5a,#02,#04,#f0,#58,#46,#03,#02 ;Z...XF..
db #f6,#50,#46,#02,#00,#00,#00,#00 ;.PF.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #43,#30,#14,#23,#34,#04,#ec,#28 ;C.......
db #42,#02,#03,#f6,#50,#46,#02 ;B...PF.
lab3D54 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#43,#30 ;......C.
db #14,#23,#36,#00,#fa,#58,#00,#04 ;.....X..
db #00,#00,#fa,#58,#00,#04,#00,#00 ;...X....
db #fa,#58,#00,#04,#00,#00,#fa,#58 ;.X.....X
db #00,#04,#01,#01,#24,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab3DB7 ld a,#48
    ld (data83b9),a
    ld a,#20
    ld (lab83BB),a
    ld a,#1
    ld (lab83BD),a
    jp lab83B5
lab3DC9 ld a,#48
    ld (data83b9),a
    ld a,#10
    ld (lab83BB),a
    ld a,#1
    ld (lab83BD),a
    call lab83B7
    ld a,#58
    ld (data83b9),a
    ld a,#8
    ld (lab83BB),a
    ld a,#2
    ld (lab83BD),a
    call lab83B7
    ld a,#60
    ld (data83b9),a
    ld a,#3
    ld (lab83BD),a
    jp lab83B7
lab3DFA ld a,#68
    ld de,lab8EA8
    ld ix,lab86AE
lab3E03 ld l,(ix+0)
    inc ix
    ld h,(ix+0)
    inc ix
    ld bc,lab003C
    ldir
    dec a
    jr nz,lab3E03
    ret 
data3e16 db #44
db #45,#52,#45,#43,#48,#41,#49,#5a ;ERECHAIZ
db #51,#55,#49,#45,#52,#20,#53,#55 ;QUIER.SU
db #42,#49,#52,#20,#46,#55,#45,#47 ;BIR.FUEG
db #4f,#2d,#31,#20,#42,#41,#4a,#41 ;O...BAJA
db #52,#20,#46,#55,#45,#47,#4f,#2d ;R.FUEGO.
db #32
lab3E40 db #19
db #24,#00,#48,#00,#25,#08,#48,#00 ;..H...H.
db #58,#16,#48,#00,#24,#1e,#48,#00 ;X.H...H.
db #25,#26,#48,#00,#58,#34,#48,#00 ;..H.X.H.
db #1b,#28,#00,#58,#fc,#03,#00,#23 ;...X....
db #02,#48,#00,#22,#14,#50,#00,#22 ;.H...P..
db #26,#50,#00,#57,#18,#48,#00,#5c ;.P.W.H..
db #0c,#58,#00,#0f,#2a,#00,#48,#fc ;.X....H.
db #06,#00,#2a,#2c,#48,#00,#5e,#0e ;....H...
db #48,#00,#27,#2f,#00,#58,#fc,#06 ;H....X..
db #00,#2f,#08,#58,#00,#2f,#1a,#58 ;...X...X
db #00,#22,#0a,#50,#00,#22,#00,#50 ;...P...P
db #00,#22,#1e,#50,#00,#22,#14,#50 ;...P...P
db #00,#22,#28,#50,#00,#22,#30,#50 ;...P...P
db #00
lab3EAA db #2d
db #05,#06,#00,#00,#06,#0a,#00,#fc
db #1e,#00,#07,#46,#00,#00,#08,#46 ;...F...F
db #10,#fe,#14,#00,#08,#06,#10,#fe
db #14,#00,#0b,#06,#b0,#00,#06,#0a
db #b0,#fc,#1e,#00,#0c,#46,#b0,#00 ;.....F..
db #04,#1a,#ac,#00
lab3ED7 db #75
db #05,#06,#00,#00,#06,#0a,#00,#fc
db #1e,#00,#07,#46,#00,#00,#08,#46 ;...F...F
db #10,#fe,#0d,#00,#08,#06,#10,#fe
db #0d,#00,#0d,#0a,#78,#fc,#3c,#00 ;....x...
db #0a,#46,#78,#fe,#05,#00,#09,#06 ;.Fx.....
db #78,#fe,#05,#00,#0b,#06,#a0,#00 ;x.......
db #0c,#46,#a0,#00,#0f,#0b,#88,#fc ;.F......
db #08,#00,#0e,#0a,#88,#00,#12,#13
db #80,#fc,#0d,#00,#10,#11,#88,#00
db #13,#1f,#80,#00,#11,#12,#80,#00
db #0e,#24,#90,#00,#0f,#25,#90,#fc
db #0e,#00,#10,#33,#90,#00,#02,#24
db #80,#00,#00,#39,#80,#00,#0e,#38
db #90,#00,#0f,#39,#90,#fc,#0c,#00
db #10,#45,#90,#00 ;.E..
lab3F4C db #18
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#f3,#f3,#f3,#51 ;...Q...Q
db #51,#f3,#f3,#f3,#00,#a6,#0c,#0c ;Q.......
db #0c,#e7,#a6,#0c,#0c,#0c,#a2,#51 ;.......Q
db #f3,#f3,#f3,#ff,#fb,#f3,#f3,#f3
db #00,#00,#00,#00,#00,#e7,#a2,#00
db #00,#00,#00,#00,#00,#00,#00,#a7
db #a2,#00,#00,#a2,#00,#00,#00,#51 ;.......Q
db #f3,#c3,#d3,#00,#51,#59,#00,#00 ;....QY..
db #51,#e3,#db,#0f,#0f,#a2,#00,#f3 ;Q.......
db #a2,#00,#e3,#c3,#8f,#c3,#d3,#00
db #00,#51,#5b,#51,#c7,#c7,#0f,#0f ;.Q.Q....
db #c3,#f3,#f3,#a6,#fb,#e3,#cb,#c7
db #4f,#cf,#0f,#0f,#5f,#af,#59,#c3 ;O.....Y.
db #c3,#df,#ff,#ff,#ff,#ff,#af,#5b
db #a2,#cf,#cf,#ff,#ff,#ef,#0f,#0f
db #5b,#a2,#51,#0f,#0f,#cf,#cf,#8f ;..Q.....
db #0f,#f3,#a2
lab4000 db #0
db #a6,#a7,#0f,#0f,#0f,#0f,#f3,#00
db #00,#00,#51,#51,#a7,#0f,#0f,#5b ;..QQ....
db #00,#00,#00,#00,#00,#00,#d3,#cb
db #e7,#d3,#f3,#00,#00,#00,#00,#51 ;.......Q
db #e3,#cb,#c7,#c3,#c3,#a2,#00,#00
db #00,#e7,#f3,#db,#e7,#f3,#f3,#00
db #00,#00,#00,#51,#cf,#cf,#cf,#cf ;...Q....
db #db,#00,#00,#00,#00,#18,#0a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#51,#00,#00 ;.....Q..
db #00,#00,#00,#00,#00,#51,#f3,#e7 ;.....Q..
db #f3,#f3,#00,#00,#00,#00,#00,#a6
db #0c,#ff,#ae,#0c,#a2,#00,#00,#00
db #00,#51,#f3,#e7,#f3,#f3,#00,#00 ;.Q......
db #00,#00,#00,#00,#00,#a7,#a2,#00
db #00,#00,#51,#00,#00,#51,#f3,#c3 ;..Q..Q..
db #d3,#00,#00,#00,#a6,#00,#51,#e3 ;......Q.
db #db,#0f,#0f,#a2,#00,#00,#f3,#00
db #e3,#c3,#8f,#c3,#d3,#00,#00,#51 ;.......Q
db #5b,#51,#c7,#c7,#0f,#0f,#c3,#f3 ;.Q......
db #f3,#f7,#59,#e3,#cb,#c7,#4f,#cf ;..Y...O.
db #0f,#0f,#5f,#ae,#5b,#c3,#c3,#df
db #ff,#ff,#ff,#ff,#af,#5b,#a2,#cf
db #cf,#ff,#ff,#ef,#0f,#0f,#5b,#f3
db #00,#0f,#0f,#cf,#cf,#8f,#0f,#f3
db #f3,#59,#00,#a7,#0f,#0f,#0f,#0f ;.Y......
db #f3,#00,#00,#a2,#00,#51,#a7,#0f ;.....Q..
db #0f,#5b,#00,#00,#00,#00,#00,#00
db #d3,#cb,#e7,#d3,#f3,#00,#00,#00
db #00,#51,#e3,#cb,#c7,#c3,#c3,#a2 ;.Q......
db #00,#00,#00,#e7,#f3,#db,#e7,#f3
db #f3,#00,#00,#00,#00,#51,#cf,#cf ;.....Q..
db #cf,#cf,#db,#00,#00,#00,#00,#18
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#e7,#a2,#00,#00,#00,#00,#00
db #00,#00,#51,#ff,#fb,#00,#00,#00 ;..Q.....
db #00,#00,#00,#00,#00,#e7,#a2,#00
db #00,#51,#00,#00,#00,#00,#00,#a7 ;.Q......
db #a2,#00,#00,#a6,#a2,#00,#00,#51 ;.......Q
db #f3,#c3,#d3,#00,#00,#51,#00,#00 ;.....Q..
db #51,#e3,#db,#0f,#0f,#a2,#00,#a6 ;Q.......
db #a2,#00,#e3,#c3,#8f,#c3,#d3,#00
db #00,#51,#5b,#51,#c7,#c7,#0f,#0f ;.Q.Q....
db #c3,#f3,#f3,#a6,#59,#e3,#cb,#c7 ;....Y...
db #4f,#cf,#0f,#0f,#5f,#ae,#59,#c3 ;O.....Y.
db #c3,#df,#ff,#ff,#ff,#ff,#af,#5b
db #a2,#cf,#cf,#ff,#ff,#ef,#0f,#0f
db #5b,#a2,#a2,#0f,#0f,#cf,#cf,#8f
db #0f,#f3,#a2,#51,#59,#a7,#0f,#0f ;...QY...
db #0f,#0f,#f3,#00,#00,#00,#a2,#51 ;.......Q
db #a7,#0f,#0f,#5b,#00,#00,#00,#51 ;.......Q
db #59,#00,#d3,#cb,#e7,#d3,#f3,#00 ;Y.......
db #00,#00,#a2,#51,#e3,#cb,#c7,#c3 ;...Q....
db #c3,#a2,#00,#00,#00,#e7,#f3,#db
db #e7,#f3,#f3,#00,#00,#00,#00,#51 ;.......Q
db #cf,#cf,#cf,#cf,#db,#00,#00,#00
db #00,#18,#0a,#00,#00,#00,#00,#00
db #00,#00,#f3,#00,#00,#00,#00,#00
db #00,#00,#00,#f3,#0c,#a2,#00,#00
db #00,#00,#00,#51,#f3,#0c,#f3,#00 ;...Q....
db #00,#00,#00,#00,#00,#e7,#0c,#f3
db #51,#a2,#a2,#00,#00,#00,#f3,#ff ;Q.......
db #fb,#00,#51,#59,#5b,#00,#00,#f3 ;..QY....
db #0c,#e7,#a2,#00,#00,#a6,#a2,#00
db #f3,#0c,#f3,#a7,#d3,#00,#00,#a7
db #5b,#51,#0c,#f3,#51,#c3,#0f,#a2 ;.Q..Q...
db #f3,#fb,#59,#00,#f3,#00,#f3,#0f ;..Y.....
db #d3,#f3,#5f,#5b,#a6,#00,#00,#51 ;.......Q
db #db,#c3,#c3,#0f,#af,#a2,#51,#00 ;......Q.
db #00,#e3,#8f,#0f,#0f,#ff,#5b,#00
db #00,#00,#51,#c3,#8f,#cf,#ff,#0f ;..Q.....
db #a2,#00,#00,#00,#e3,#c7,#4f,#ff ;......O.
db #0f,#5b,#00,#00,#00,#51,#c7,#c7 ;.....Q..
db #ff,#ef,#0f,#a2,#00,#00,#00,#51 ;.......Q
db #cb,#df,#ff,#8f,#5b,#00,#00,#00
db #00,#e3,#c3,#ff,#cf,#0f,#a2,#00
db #00,#00,#00,#c3,#cf,#cf,#0f,#5b
db #f3,#00,#00,#00,#00,#cf,#0f,#0f
db #0f,#d3,#c3,#a2,#00,#00,#00,#0f
db #0f,#0f,#e7,#c3,#f3,#00,#00,#00
db #00,#a7,#0f,#cb,#c7,#f3,#db,#00
db #00,#00,#00,#51,#d3,#cb,#e7,#cf ;...Q....
db #a2,#00,#00,#00,#00,#00,#e3,#db
db #cf,#f3,#00,#00,#00,#00,#00,#51 ;.......Q
db #f3,#cf,#f3,#00,#00,#00,#00,#00
db #00,#e7,#cf,#f3,#00,#00,#00,#00
db #00,#00,#00,#18,#0a,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#51,#00,#f3 ;.....Q..
db #00,#00,#51,#00,#00,#00,#00,#e7 ;..Q.....
db #f3,#0c,#a2,#00,#a6,#00,#00,#00
db #00,#f7,#0c,#f3,#00,#51,#59,#00 ;.....QY.
db #00,#00,#f3,#ff,#fb,#00,#00,#f7
db #5b,#00,#00,#51,#0c,#a7,#d3,#00 ;...Q....
db #00,#a6,#a2,#00,#00,#a6,#f3,#c3
db #0f,#a2,#f3,#fb,#00,#00,#00,#51 ;.......Q
db #f3,#0f,#d3,#f3,#5f,#0e,#a2,#00
db #00,#51,#db,#c3,#c3,#0f,#af,#59 ;.Q.....Y
db #00,#00,#00,#e3,#8f,#0f,#0f,#ff
db #5b,#a2,#00,#00,#51,#c3,#8f,#cf ;....Q...
db #ff,#0f,#a2,#00,#00,#00,#e3,#c7
db #4f,#ff,#0f,#5b,#00,#00,#00,#51 ;O......Q
db #c7,#c7,#ff,#ef,#0f,#a2,#00,#00
db #00,#51,#cb,#df,#ff,#8f,#5b,#00 ;.Q......
db #00,#00,#00,#e3,#c3,#ff,#cf,#0f
db #a2,#00,#00,#00,#00,#c3,#cf,#cf
db #0f,#5b,#f3,#00,#00,#00,#00,#cf
db #0f,#0f,#0f,#d3,#c3,#a2,#00,#00
db #00,#0f,#0f,#0f,#e7,#c3,#f3,#00
db #00,#00,#00,#a7,#0f,#cb,#c7,#f3
db #db,#00,#00,#00,#00,#51,#d3,#cb ;.....Q..
db #e7,#cf,#a2,#00,#00,#00,#00,#00
db #e3,#db,#cf,#f3,#00,#00,#00,#00
db #00,#51,#f3,#cf,#f3,#00,#00,#00 ;.Q......
db #00,#00,#00,#e7,#cf,#f3,#00,#00
db #00,#00,#00,#00,#00,#18,#0a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#00,#00,#00,#00,#00,#51 ;.Q.....Q
db #00,#00,#00,#a6,#a2,#00,#00,#00
db #00,#e7,#a2,#00,#00,#51,#a2,#00 ;.....Q..
db #00,#00,#51,#ff,#fb,#00,#00,#a6 ;..Q.....
db #5b,#00,#00,#00,#00,#e7,#a2,#00
db #00,#51,#59,#00,#00,#00,#00,#a7 ;.QY.....
db #d3,#00,#00,#f7,#5b,#00,#00,#00
db #51,#c3,#0f,#a2,#f3,#ae,#a2,#00 ;Q.......
db #00,#00,#f3,#0f,#d3,#f3,#5f,#5b
db #a2,#00,#00,#51,#db,#c3,#c3,#0f ;...Q....
db #af,#f3,#59,#00,#00,#e3,#8f,#0f ;..Y.....
db #0f,#ff,#5b,#00,#a2,#00,#51,#c3 ;......Q.
db #8f,#cf,#ff,#0f,#a2,#51,#59,#00 ;.....QY.
db #e3,#c7,#4f,#ff,#0f,#5b,#00,#00 ;..O.....
db #a2,#51,#c7,#c7,#ff,#ef,#0f,#a2 ;.Q......
db #00,#00,#00,#51,#cb,#df,#ff,#8f ;...Q....
db #5b,#00,#00,#00,#00,#e3,#c3,#ff
db #cf,#0f,#a2,#00,#00,#00,#00,#c3
db #cf,#cf,#0f,#5b,#f3,#00,#00,#00
db #00,#cf,#0f,#0f,#0f,#d3,#c3,#a2
db #00,#00,#00,#0f,#0f,#0f,#e7,#c3
db #f3,#00,#00,#00,#00,#a7,#0f,#cb
db #c7,#f3,#db,#00,#00,#00,#00,#51 ;.......Q
db #d3,#cb,#e7,#cf,#a2,#00,#00,#00
db #00,#00,#e3,#db,#cf,#f3,#00,#00
db #00,#00,#00,#51,#f3,#cf,#f3,#00 ;...Q....
db #00,#00,#00,#00,#00,#e7,#cf,#f3
db #00,#00,#00,#00,#00,#00,#00,#18
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#51,#fb,#00 ;.....Q..
db #00,#00,#00,#00,#00,#00,#00,#a6
db #f3,#00,#a2,#00,#00,#00,#00,#51 ;.......Q
db #f3,#48,#a7,#f3,#f1,#00,#00,#00 ;.H......
db #00,#b7,#ae,#d1,#4f,#f3,#52,#a2 ;....O.R.
db #00,#00,#00,#f7,#48,#a7,#db,#f6 ;....H...
db #f9,#f1,#00,#00,#00,#a6,#d5,#4f ;.......O
db #f3,#a3,#56,#f1,#00,#00,#00,#e2 ;..V.....
db #bf,#db,#db,#f6,#a9,#f2,#f3,#f3
db #f3,#f3,#f0,#f1,#db,#f6,#fc,#bc
db #78,#b4,#78,#6a,#f0,#f0,#f0,#f3 ;x.xj....
db #f3,#f2,#f0,#f0,#a4,#95,#78,#f0 ;......x.
db #f0,#f0,#f0,#f1,#79,#f3,#a4,#6a ;....y..j
db #f3,#79,#f2,#f2,#f0,#f0,#b4,#f0 ;.y......
db #a4,#95,#3c,#f0,#3c,#f0,#f0,#f1
db #f3,#f3,#f3,#6a,#3c,#f3,#b6,#b6 ;...j....
db #f0,#f3,#f0,#f0,#f1,#95,#f3,#f0
db #f1,#f2,#f0,#f2,#f3,#f2,#f1,#6a ;.......j
db #f0,#b7,#f2,#f2,#f1,#f1,#b7,#f3
db #79,#95,#f1,#3f,#7b,#f1,#f2,#f3 ;y.......
db #3f,#7b,#78,#f3,#b7,#7a,#3f,#f0 ;..x..z..
db #b4,#b7,#7a,#3f,#f2,#00,#b7,#72 ;..z....r
db #37,#f2,#79,#b7,#72,#37,#f3,#00 ;..y.r...
db #b7,#f1,#b5,#f2,#f1,#b7,#f1,#b5
db #a2,#00,#b7,#72,#37,#f3,#a2,#b7 ;...r....
db #72,#37,#a2,#00,#b7,#7a,#3f,#a2 ;r....z..
db #00,#b7,#7a,#3f,#a2,#00,#51,#3f ;..z...Q.
db #7b,#00,#00,#51,#3f,#7b,#00,#00 ;...Q....
db #00,#b7,#a2,#00,#00,#00,#b7,#a2
db #00,#18,#0a,#00,#00,#51,#fb,#00 ;.....Q..
db #00,#00,#00,#00,#00,#00,#00,#a6
db #f3,#00,#a2,#00,#00,#00,#00,#51 ;.......Q
db #f3,#48,#a7,#f3,#f1,#00,#00,#00 ;.H......
db #00,#b7,#ae,#d1,#4f,#f3,#52,#a2 ;....O.R.
db #00,#00,#00,#f7,#48,#a7,#db,#f6 ;....H...
db #f9,#f1,#00,#00,#00,#a6,#d5,#4f ;.......O
db #f3,#a3,#56,#f1,#00,#00,#00,#e2 ;..V.....
db #bf,#db,#db,#f6,#a9,#f2,#f3,#f3
db #f3,#f3,#f0,#f1,#db,#f6,#fc,#bc
db #78,#b4,#78,#6a,#f0,#f0,#f0,#f3 ;x.xj....
db #f3,#f2,#f0,#f0,#a4,#95,#78,#f0 ;......x.
db #f2,#f0,#f0,#f1,#79,#f3,#a4,#6a ;....y..j
db #f3,#79,#f2,#f2,#f0,#f0,#b4,#f0 ;.y......
db #a4,#95,#3c,#f0,#3c,#f0,#f0,#f1
db #f3,#f3,#f3,#6a,#3c,#f3,#b6,#b6 ;...j....
db #f0,#f3,#f0,#f0,#f1,#95,#f3,#f0
db #f1,#f2,#f0,#f2,#f3,#f2,#f1,#6a ;.......j
db #f0,#f3,#f2,#f2,#f1,#f1,#f3,#f3
db #79,#95,#f1,#b7,#f3,#f1,#f2,#f3 ;y.......
db #b7,#f3,#78,#f3,#f3,#3f,#7b,#f0 ;..x.....
db #b4,#f3,#3f,#7b,#f2,#00,#b7,#3b
db #3f,#f2,#79,#b7,#3b,#3f,#f3,#00 ;..y.....
db #b7,#f0,#b5,#f2,#f1,#b7,#f0,#b5
db #a2,#00,#b7,#73,#37,#f3,#a2,#b7 ;...s....
db #73,#37,#a2,#00,#b7,#f0,#b5,#a2 ;s.......
db #00,#b7,#f0,#b5,#a2,#00,#b7,#3b
db #3f,#a2,#00,#b7,#3b,#3f,#a2,#00
db #51,#3f,#7b,#00,#00,#51,#3f,#7b ;Q....Q..
db #00,#00,#00,#b7,#a2,#00,#00,#00
db #f3,#a2,#00,#18,#0a,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#f6,#f3,#f9
db #a2,#00,#00,#00,#00,#51,#f3,#f0 ;.....Q..
db #0c,#58,#f1,#00,#00,#00,#00,#f2 ;.X......
db #f0,#f4,#f0,#ac,#59,#00,#00,#00 ;....Y...
db #51,#f1,#f9,#f4,#58,#a4,#58,#51 ;Q...X.XQ
db #00,#00,#f2,#a3,#fc,#5c,#8c,#f0
db #8c,#b6,#f3,#f3,#f1,#f3,#56,#f4 ;......V.
db #58,#f8,#e4,#f2,#b4,#b4,#79,#a9 ;X.....y.
db #fc,#f4,#a4,#ac,#f1,#9c,#78,#f0 ;......x.
db #a1,#56,#f3,#58,#4c,#ac,#58,#70 ;.V.XL.Xp
db #f0,#f0,#f0,#f0,#f0,#5c,#f0,#a4
db #0c,#70,#f1,#f3,#f0,#f3,#f3,#ac ;.p......
db #fc,#f4,#fc,#71,#f2,#f0,#f2,#f0 ;...q....
db #f0,#f3,#f3,#f3,#f3,#d8,#b4,#78 ;.......x
db #f1,#f0,#b4,#b4,#78,#f0,#f0,#f2 ;....x...
db #78,#f0,#f0,#f2,#3c,#b4,#f3,#f2 ;x.......
db #78,#f0,#f1,#f3,#f0,#f2,#f0,#f1 ;x.......
db #f0,#f1,#78,#b6,#f3,#7b,#f2,#f1 ;..x.....
db #f0,#f2,#b7,#f2,#f1,#3c,#b7,#3f
db #f2,#f0,#f3,#f1,#3f,#7b,#f5,#79 ;.......y
db #3f,#b5,#7a,#78,#f0,#b7,#7a,#3f ;..zx..z.
db #f7,#f3,#3b,#b1,#7b,#3c,#e7,#b7
db #72,#37,#f0,#51,#7a,#50,#7b,#f2 ;r..QzP..
db #f9,#bd,#a0,#b5,#f3,#51,#3b,#b1 ;.....Q..
db #7b,#51,#f6,#b7,#72,#37,#a2,#51 ;.Q..r..Q
db #3f,#b5,#7b,#00,#51,#b7,#7a,#3f ;....Q.z.
db #a2,#00,#b7,#3f,#a2,#00,#00,#51 ;.......Q
db #3f,#7b,#00,#00,#51,#7b,#00,#00 ;....Q...
db #00,#00,#b7,#a2,#00,#18,#0a,#00
db #00,#00,#00,#00,#00,#f6,#f3,#f9
db #a2,#00,#00,#00,#00,#51,#f3,#f0 ;.....Q..
db #0c,#58,#f1,#00,#00,#00,#00,#f2 ;.X......
db #f0,#f4,#f0,#ac,#59,#00,#00,#00 ;....Y...
db #51,#f1,#f9,#f4,#58,#a4,#58,#51 ;Q...X.XQ
db #00,#00,#f2,#a3,#fc,#5c,#8c,#f0
db #8c,#b6,#f3,#f3,#f1,#f3,#56,#f4 ;......V.
db #58,#f8,#e4,#f2,#b4,#b4,#79,#a9 ;X.....y.
db #fc,#f4,#a4,#ac,#f1,#9c,#78,#f0 ;......x.
db #a1,#56,#f3,#58,#4c,#ac,#58,#70 ;.V.XL.Xp
db #f0,#f0,#f0,#f0,#f0,#5c,#f0,#a4
db #0c,#70,#f1,#f3,#f0,#f3,#f3,#ac ;.p......
db #fc,#f4,#fc,#71,#f2,#f0,#f2,#f0 ;...q....
db #f0,#f3,#f3,#f3,#f3,#d8,#b4,#78 ;.......x
db #f1,#f0,#b4,#b4,#78,#f0,#f0,#f2 ;....x...
db #78,#f0,#f0,#f2,#3c,#b4,#f3,#f2 ;x.......
db #78,#f0,#f1,#f3,#f0,#f2,#f0,#f1 ;x.......
db #f0,#f1,#78,#b6,#f3,#f3,#f2,#f1 ;..x.....
db #f0,#f2,#f3,#f2,#f1,#3c,#f3,#7b
db #f2,#f0,#f3,#f1,#b7,#f3,#f5,#79 ;.......y
db #b7,#3f,#f2,#78,#f0,#f3,#3f,#7b ;...x....
db #f7,#f3,#3f,#37,#7b,#3c,#f6,#b7
db #3b,#3f,#f0,#51,#7a,#f0,#7b,#f2 ;...Qz...
db #f9,#bd,#f0,#b5,#f3,#51,#3b,#11 ;.....Q..
db #7b,#51,#e7,#b7,#22,#37,#a2,#51 ;.Q.....Q
db #7a,#f0,#7b,#00,#51,#b7,#f0,#b5 ;z...Q...
db #a2,#51,#3f,#37,#7b,#00,#00,#b7 ;.Q......
db #3b,#3f,#a2,#00,#b7,#3f,#a2,#00
db #00,#51,#3f,#7b,#00,#00,#51,#7b ;.Q....Q.
db #00,#00,#00,#00,#b7,#a2,#00,#18
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#f3,#00,#00,#00,#00,#00 ;.Q......
db #00,#00,#00,#a6,#0c,#00,#00,#00
db #00,#00,#00,#00,#00,#a6,#ff,#00
db #00,#00,#51,#a2,#00,#00,#51,#0c ;..Q...Q.
db #59,#00,#00,#00,#a7,#5b,#00,#00 ;Y.......
db #a6,#5d,#fb,#00,#00,#51,#4f,#8f ;.....QO.
db #a2,#51,#5d,#ff,#59,#00,#00,#a7 ;.Q..Y...
db #8f,#0f,#59,#a6,#0c,#0c,#59,#00 ;..Y...Y.
db #f3,#cf,#0f,#8e,#0c,#0c,#0c,#0c
db #5d,#f3,#0c,#ff,#cf,#ff,#ff,#ff
db #ff,#0c,#75,#0c,#0c,#0c,#ff,#0c ;..u.....
db #0c,#0c,#0c,#0c,#ba,#f3,#a6,#0c
db #0c,#0c,#4d,#cf,#db,#a6,#75,#00 ;..M...u.
db #51,#cf,#8e,#8e,#0c,#0c,#59,#a6 ;Q.....Y.
db #59,#00,#00,#f3,#a6,#4d,#0c,#0c ;Y....M..
db #a2,#51,#a2,#00,#00,#00,#51,#f3 ;.Q....Q.
db #8e,#0c,#59,#00,#00,#00,#00,#00 ;..Y.....
db #00,#00,#e7,#cf,#db,#00,#00,#00
db #00,#00,#00,#00,#a6,#0c,#59,#00 ;......Y.
db #00,#00,#00,#00,#00,#51,#0c,#0c ;.....Q..
db #0c,#a2,#00,#00,#00,#00,#00,#00
db #f3,#f3,#f3,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#18,#0a,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#51,#f3,#a2,#00,#00,#00 ;..Q.....
db #00,#00,#00,#00,#a6,#0c,#59,#00 ;......Y.
db #00,#00,#f3,#00,#00,#00,#51,#cf ;......Q.
db #db,#00,#00,#51,#0c,#00,#00,#00 ;...Q....
db #51,#0c,#59,#00,#00,#a6,#ff,#00 ;Q.Y.....
db #00,#00,#51,#0c,#0c,#a2,#51,#0c ;..Q...Q.
db #08,#00,#00,#51,#f3,#0c,#0c,#f3 ;...Q....
db #a6,#ff,#aa,#00,#00,#a7,#4f,#0c ;......O.
db #0c,#0c,#0c,#0c,#00,#00,#51,#4f ;......QO
db #df,#ff,#ff,#ff,#ff,#0c,#aa,#00
db #e7,#df,#ae,#0c,#0c,#0c,#0c,#18
db #75,#00,#a6,#ae,#0c,#0c,#0c,#0c ;u.......
db #0c,#18,#fb,#f3
lab4A2D db #c
db #0c,#0c,#0c,#cf,#cf,#0c,#59,#a2 ;......Y.
db #0c,#0c,#0c,#4d,#cf,#0c,#0c,#f3 ;...M....
db #a2,#00,#f3,#f3,#cf,#db,#a6,#0c
db #0c,#59,#00,#00,#00,#00,#f3,#a2 ;.Y......
db #51,#a6,#0c,#59,#00,#00,#00,#00 ;Q..Y....
db #00,#00,#00,#51,#0c,#0c,#a2,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#a6,#0c
db #59,#00,#00,#00,#00,#00,#00,#00 ;Y.......
db #51,#0c,#db,#a2,#00,#00,#00,#00 ;Q.......
db #00,#00,#00,#e7,#8e,#59,#00,#00 ;.....Y..
db #00,#00,#00,#00,#00,#a6,#0c,#a2
db #00,#00,#00,#00,#00,#00,#51,#0c ;......Q.
db #f3,#00,#00,#00,#00,#00,#00,#00
db #00,#f3,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#18,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#a6,#a2,#00,#00,#00,#00,#00
db #00,#00,#51,#4d,#a2,#00,#00,#00 ;..QM....
db #00,#00,#00,#00,#a6,#a6,#59,#00 ;......Y.
db #00,#00,#00,#00,#00,#00,#51,#a6 ;......Q.
db #59,#00,#00,#51,#00,#00,#00,#00 ;Y..Q....
db #00,#a6,#0c,#a2,#a2,#a6,#a2,#00
db #00,#00,#00,#a6,#5d,#59,#59,#59 ;.....YYY
db #00,#00,#00,#00,#51,#0c,#ef,#8e ;....Q...
db #8e,#a2,#00,#00,#00,#00,#51,#5d ;......Q.
db #8e,#4d,#59,#00,#00,#00,#00,#00 ;.MY.....
db #51,#4d,#0c,#0c,#5d,#a2,#00,#00 ;QM......
db #00,#00,#00,#a6,#0f,#0e,#ef,#59 ;.......Y
db #00,#00,#00,#00,#00,#a7,#4f,#5d ;......O.
db #8e,#59,#00,#00,#00,#00,#51,#0d ;.Y....Q.
db #4f,#4d,#0c,#0c,#a2,#00,#00,#00 ;OM......
db #51,#0d,#8e,#8e,#0c,#0c,#a2,#00 ;Q.......
db #00,#00,#51,#0c,#59,#f3,#f3,#4d ;..Q.Y..M
db #59,#00,#00,#00,#a6,#59,#a2,#00 ;Y....Y..
db #00,#f3,#59,#00,#00,#51,#59,#a2 ;..Y..QY.
db #00,#00,#00,#a6,#a2,#00,#00,#00
db #a2,#00,#00,#00,#00,#51,#00,#00 ;.....Q..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #18,#0a,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#a2,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#59,#00,#00,#00 ;...QY...
db #00,#00,#00,#00,#00,#51,#59,#00 ;.....QY.
db #00,#00,#00,#00,#00,#00,#00,#a6
db #a2,#00,#00,#00,#00,#00,#00,#00
db #00,#a6,#a2,#00,#00,#00,#00,#00
db #f3,#00,#51,#0c,#a2,#00,#00,#00 ;..Q.....
db #00,#51,#4d,#f3,#f7,#0c,#a2,#00 ;.QM.....
db #00,#00,#00,#00,#e7,#0c,#f7,#0c
db #a2,#00,#00,#00,#00,#51,#db,#0c ;.....Q..
db #5d,#5d,#a2,#00,#00,#00,#00,#51 ;.......Q
db #59,#a6,#0c,#5d,#a2,#00,#00,#00 ;Y.......
db #00,#51,#59,#51,#0d,#0e,#59,#00 ;.QYQ..Y.
db #00,#00,#00,#51,#a2,#51,#0d,#8e ;...Q.Q..
db #0c,#f3,#00,#00,#00,#00,#00,#51 ;.......Q
db #0f,#db,#0c,#4d,#a2,#00,#00,#00 ;...M....
db #00,#51,#0f,#59,#f3,#4d,#a2,#00 ;.Q.Y.M..
db #00,#00,#00,#51,#4d,#a2,#00,#a6 ;...QM...
db #a2,#00,#00,#00,#00,#51,#0c,#a2 ;.....Q..
db #00,#e2,#a2,#00,#00,#00,#00,#51 ;.......Q
db #0c,#a2,#00,#a6,#a2,#00,#00,#00
db #00,#51,#59,#00,#00,#f3,#00,#00 ;.QY.....
db #00,#00,#00,#a6,#a2,#00,#00,#00
db #00,#00,#00,#00,#00,#a6,#a2,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#18,#0a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#00,#00,#00,#00,#00,#00 ;.Q......
db #00,#00,#00,#a6,#a2,#00,#00,#00
db #00,#00,#00,#00,#00,#a6,#a2,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #59,#00,#00,#00,#00,#00,#00,#00 ;Y.......
db #00,#51,#59,#00,#00,#00,#00,#00 ;.QY.....
db #00,#00,#00,#51,#0c,#a2,#00,#f3 ;...Q....
db #00,#00,#00,#00,#00,#51,#0c,#fb ;.....Q..
db #f3,#8e,#a2,#00,#00,#00,#00,#51 ;.......Q
db #0c,#fb,#0c,#db,#00,#00,#00,#00
db #00,#51,#ae,#ae,#0c,#e7,#a2,#00 ;.Q......
db #00,#00,#00,#51,#ae,#0c,#59,#a6 ;...Q..Y.
db #a2,#00,#00,#00,#00,#a6,#0d,#0e
db #a2,#a6,#a2,#00,#00,#00,#f3,#0c
db #4d,#0e,#a2,#51,#a2,#00,#00,#51 ;M..Q...Q
db #8e,#0c,#e7,#0f,#a2,#00,#00,#00
db #00,#51,#8e,#f3,#a6,#0f,#a2,#00 ;.Q......
db #00,#00,#00,#51,#59,#00,#51,#8e ;...QY.Q.
db #a2,#00,#00,#00,#00,#51,#d1,#00 ;.....Q..
db #51,#0c,#a2,#00,#00,#00,#00,#51 ;Q......Q
db #59,#00,#51,#0c,#a2,#00,#00,#00 ;Y.Q.....
db #00,#00,#f3,#00,#00,#a6,#a2,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #59,#00,#00,#00,#00,#00,#00,#00 ;Y.......
db #00,#51,#59,#00,#00,#00,#00,#00 ;.QY.....
db #00,#00,#00,#00,#a2,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#18,#0a,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #a2,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#59,#00,#00,#00,#00,#00 ;.QY.....
db #00,#00,#00,#51,#8e,#a2,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#a6,#59,#59 ;......YY
db #00,#00,#00,#00,#a2,#00,#00,#a6
db #59,#a2,#00,#00,#00,#51,#59,#51 ;Y....QYQ
db #51,#0c,#59,#00,#00,#00,#00,#00 ;Q.Y.....
db #a6,#a6,#a6,#ae,#59,#00,#00,#00 ;....Y...
db #00,#00,#51,#4d,#4d,#df,#0c,#a2 ;..QMM...
db #00,#00,#00,#00,#00,#a6,#8e,#4d ;.......M
db #ae,#a2,#00,#00,#00,#00,#51,#ae ;......Q.
db #0c,#0c,#8e,#a2,#00,#00,#00,#00
db #a6,#df,#0d,#0f,#59,#00,#00,#00 ;....Y...
db #00,#00,#a6,#4d,#ae,#8f,#5b,#00 ;...M....
db #00,#00,#00,#51,#0c,#0c,#8e,#8f ;...Q....
db #0e,#a2,#00,#00,#00,#51,#0c,#0c ;.....Q..
db #4d,#4d,#0e,#a2,#00,#00,#00,#a6 ;MM......
db #8e,#f3,#f3,#a6,#0c,#a2,#00,#00
db #00,#a6,#f3,#00,#00,#51,#a6,#59 ;.....Q.Y
db #00,#00,#00,#51,#59,#00,#00,#00 ;...QY...
db #51,#a6,#a2,#00,#00,#00,#a2,#00 ;Q.......
db #00,#00,#00,#51,#00,#00,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#18,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #51,#f3,#a2,#00,#00,#00,#f3,#00 ;Q.......
db #00,#00,#a6,#0c,#59,#00,#00,#00 ;....Y...
db #0c,#a2,#00,#00,#e7,#cf,#a2,#00
db #00,#00,#ff,#59,#00,#00,#a6,#0c ;...Y....
db #a2,#00,#00,#00,#04,#0c,#a2,#51 ;.......Q
db #0c,#0c,#a2,#00,#00,#00,#55,#ff ;......U.
db #59,#f3,#0c,#0c,#f3,#a2,#00,#00 ;Y.......
db #00,#0c,#0c,#0c,#0c,#0c,#8f,#5b
db #00,#00,#55,#0c,#ff,#ff,#ff,#ff ;..U.....
db #ef,#8f,#a2,#00,#ba,#24,#0c,#0c
db #0c,#0c,#5d,#ef,#db,#00,#f7,#24
db #0c,#0c,#0c,#0c,#0c,#5d,#59,#00 ;......Y.
db #51,#a6,#0c,#cf,#cf,#0c,#0c,#0c ;Q.......
db #0c,#f3,#00,#51,#f3,#0c,#0c,#cf ;...Q....
db #8e,#0c,#0c,#0c,#00,#00,#a6,#0c
db #0c,#59,#e7,#cf,#f3,#f3,#00,#00 ;.Y......
db #a6,#0c,#59,#a2,#51,#f3,#00,#00 ;..Y.Q...
db #00,#51,#0c,#0c,#a2,#00,#00,#00 ;.Q......
db #00,#00,#00,#a6,#0c,#59,#00,#00 ;.....Y..
db #00,#00,#00,#00,#51,#e7,#0c,#a2 ;....Q...
db #00,#00,#00,#00,#00,#00,#a6,#4d ;.......M
db #db,#00,#00,#00,#00,#00,#00,#00
db #51,#0c,#59,#00,#00,#00,#00,#00 ;Q.Y.....
db #00,#00,#00,#f3,#0c,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#f3,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #18,#0a,#f3,#a2,#00,#00,#00,#00
db #00,#00,#00,#00,#0c,#59,#00,#00 ;.....Y..
db #00,#00,#00,#00,#00,#00,#ff,#59 ;.......Y
db #00,#00,#00,#00,#00,#00,#00,#00
db #a6,#0c,#a2,#00,#00,#51,#a2,#00 ;.....Q..
db #00,#00,#f7,#ae,#59,#00,#00,#a7 ;....Y...
db #5b,#00,#00,#00,#a6,#ff,#ae,#a2
db #51,#4f,#8f,#a2,#00,#00,#a6,#0c ;QO......
db #0c,#59,#a6,#0f,#4f,#5b,#00,#00 ;.Y..O...
db #ae,#0c,#0c,#0c,#0c,#4d,#0f,#cf ;.....M..
db #f3,#00,#ba,#0c,#ff,#ff,#ff,#ff
db #cf,#ff,#0c,#f3,#75,#0c,#0c,#0c ;....u...
db #0c,#0c,#ff,#0c,#0c,#0c,#ba,#59 ;.......Y
db #e7,#cf,#8e,#0c,#0c,#0c,#59,#f3 ;......Y.
db #a6,#59,#a6,#0c,#0c,#4d,#4d,#cf ;.Y...MM.
db #a2,#00,#51,#a2,#51,#0c,#0c,#8e ;..Q.Q...
db #59,#f3,#00,#00,#00,#00,#a6,#0c ;Y.......
db #4d,#f3,#a2,#00,#00,#00,#00,#00 ;M.......
db #e7,#cf,#db,#00,#00,#00,#00,#00
db #00,#00,#a6,#0c,#59,#00,#00,#00 ;....Y...
db #00,#00,#00,#51,#0c,#0c,#0c,#a2 ;...Q....
db #00,#00,#00,#00,#00,#00,#f3,#f3
db #f3,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#08,#03,#00,#51,#7b,#00 ;.....Q..
db #b7,#ea,#00,#f7,#84,#00,#e2,#5d
db #51,#84,#b7,#e2,#59,#51,#a6,#a2 ;Q...YQ..
db #00,#fb,#00,#00,#08,#03,#00,#a2
db #00,#51,#fb,#00,#f7,#75,#a2,#b3 ;.Q...u..
db #19,#a2,#f7,#75,#a2,#51,#fb,#00 ;...u.Q..
db #00,#a2,#00,#00,#00,#00,#08,#03
db #fb,#00,#00,#a6,#a2,#00,#e2,#59 ;.......Y
db #f3,#51,#84,#bf,#00,#e2,#5d,#00 ;.Q......
db #f7,#84,#00,#b7,#ea,#00,#51,#7b ;......Q.
db #08,#03,#00,#00,#f7,#00,#51,#59 ;......QY
db #f3,#a6,#d1,#7f,#48,#a2,#ae,#d1 ;....H...
db #00,#48,#fb,#00,#d5,#7b,#00,#b7 ;.H......
db #a2,#00,#08,#03,#00,#00,#51,#00 ;......Q.
db #00,#b7,#51,#f3,#ff,#e2,#c0,#c0 ;..Q.....
db #ae,#0c,#0c,#f3,#f3,#ff,#00,#00
db #b7,#00,#00,#51,#08,#03,#a2,#00 ;...Q....
db #00,#7b,#00,#00,#ff,#f3,#a2,#c0
db #c0,#d1,#0c,#0c,#5d,#ff,#f3,#f3
db #7b,#00,#00,#a2,#00,#00,#18,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#a2
db #00,#00,#00,#00,#00,#51,#f3,#00 ;.....Q..
db #51,#7b,#00,#00,#00,#00,#00,#b7 ;Q.......
db #3f,#f3,#b7,#a2,#00,#00,#00,#00
db #00,#b7,#7f,#3f,#3f,#a2,#00,#00
db #00,#00,#51,#3f,#bf,#bf,#3f,#7b ;..Q.....
db #00,#00,#00,#00,#51,#3f,#ff,#ff ;....Q...
db #ff,#3f,#a2,#00,#00,#00,#00,#b7
db #33,#33,#75,#bf,#a2,#00,#00,#00 ;..u.....
db #51,#3f,#32,#24,#33,#3f,#a2,#00 ;Q.......
db #00,#00,#51,#7f,#30,#24,#18,#bf ;..Q.....
db #a2,#00,#00,#00,#51,#7f,#77,#32 ;....Q.w.
db #75,#ff,#7b,#00,#00,#00,#b7,#3f ;u.......
db #bb,#33,#ff,#bf,#7b,#00,#00,#00
db #b7,#b7,#7f,#77,#7f,#3f,#7b,#00 ;...w....
db #00,#00,#51,#f3,#3f,#bf,#3f,#3f ;..Q.....
db #a2,#00,#00,#00,#00,#00,#b7,#b7
db #b7,#f3,#00,#00,#00,#00,#00,#00
db #51,#b7,#f3,#00,#00,#00,#00,#00 ;Q.......
db #00,#00,#00,#51,#00,#00,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #18,#0a,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#51,#f3,#a2,#00 ;....Q...
db #00,#00,#00,#00,#00,#00,#f7,#bf
db #7b,#a2,#00,#00,#00,#00,#00,#51 ;.......Q
db #7b,#3f,#bf,#aa,#00,#00,#00,#00
db #00,#f7,#7f,#f7,#7f,#7b,#00,#00
db #00,#00,#f3,#3f,#3b,#33,#bf,#3f
db #a2,#00,#00,#00,#ff,#7f,#bb,#33
db #77,#fb,#7b,#00,#00,#51,#7b,#b3 ;w....Q..
db #32,#31,#31,#ff,#a2,#00,#00,#f7
db #b7,#fb,#30,#24,#30,#73,#7b,#00 ;.....s..
db #51,#bf,#f7,#ba,#24,#0c,#18,#31 ;Q.......
db #bf,#a2,#51,#7b,#3f,#3a,#30,#0c ;..Q.....
db #18,#33,#7f,#7b,#00,#f3,#bf,#33
db #77,#30,#31,#77,#7f,#a2,#00,#00 ;w..w....
db #b7,#ff,#bb,#31,#77,#3f,#fb,#7b ;....w...
db #00,#00,#b7,#7f,#77,#77,#bf,#7b ;....ww..
db #bf,#a2,#00,#00,#b7,#b7,#bb,#fb
db #3f,#f7,#7b,#00,#00,#00,#51,#bf ;......Q.
db #3f,#3f,#f3,#fb,#a2,#00,#00,#00
db #00,#b7,#7f,#b7,#f7,#a2,#00,#00
db #00,#00,#00,#51,#f3,#7b,#3f,#a2 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#f7
db #f3,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#00,#00,#00,#00,#00,#00 ;.Q......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#18,#0a,#00,#00,#00,#b7
db #a2,#3f,#b7,#a2,#00,#00,#00,#00
db #51,#7b,#7b,#7b,#7f,#7b,#00,#00 ;Q.......
db #00,#00,#00,#b7,#7f,#f7,#3f,#a2
db #00,#00,#00,#00,#51,#3f,#bf,#bf ;....Q...
db #bf,#7b,#00,#00,#00,#00,#b7,#7f
db #7f,#ff,#7f,#3f,#a2,#00,#00,#51 ;.......Q
db #7b,#bf,#bb,#33,#bf,#fb,#a2,#00
db #00,#b7,#b7,#7f,#33,#31,#77,#3f ;......w.
db #7b,#00,#51,#7f,#3f,#ff,#33,#30 ;..Q.....
db #77,#3f,#b7,#a2,#51,#7f,#ff,#3b ;w...Q...
db #32,#30,#31,#37,#7b,#2a,#15,#3f
db #7f,#32,#30,#0c,#18,#77,#7f,#a2 ;.....w..
db #b7,#f7,#bb,#30,#0c,#0c,#18,#31
db #7b,#7b,#7b,#ff,#32,#30,#0c,#0c
db #0c,#31,#37,#b7,#3f,#7f,#33,#30
db #0c,#0c,#18,#30,#77,#7b,#7b,#3f ;....w...
db #bb,#32,#30,#18,#30,#31,#33,#bf
db #b7,#b7,#bf,#33,#32,#30,#30,#33
db #ff,#7b,#51,#7b,#7f,#bb,#77,#31 ;..Q...w.
db #33,#ff,#bf,#bf,#51,#bf,#3f,#3b ;....Q...
db #bb,#bb,#77,#7f,#7f,#7b,#00,#f7 ;..w.....
db #ff,#bb,#bb,#77,#bf,#bf,#b7,#a2 ;...w....
db #00,#51,#b7,#7f,#7f,#ff,#ff,#bf ;.Q......
db #f3,#00,#00,#00,#7b,#ff,#bf,#bf
db #bf,#7f,#a2,#00,#00,#00,#55,#b7 ;......U.
db #7f,#7f,#3f,#bf,#fb,#00,#00,#00
db #00,#7b,#bf,#fb,#7b,#7f,#a2,#00
db #00,#00,#00,#15,#b7,#b7,#b7,#f3
db #00,#00,#00,#00,#00,#00,#7b,#7b
db #7b,#00,#00,#00,#08,#14,#41,#c3 ;......A.
db #c3,#c3,#c3,#c3,#87,#0f,#0f,#0f
db #0f,#4b,#c3,#c3,#c3,#c3,#c3,#c3 ;.K......
db #c3,#c3,#41,#c3,#c3,#c3,#c3,#0f ;..A.....
db #4f,#cf,#cf,#cf,#cf,#8f,#0f,#0f ;O.......
db #c3,#c3,#c3,#c3,#c3,#c3,#41,#c3 ;......A.
db #c3,#0f,#0f,#cf,#cb,#c3,#86,#c3
db #49,#c7,#cf,#cf,#0f,#0f,#c3,#c3 ;I.......
db #c3,#c3,#41,#c3,#0f,#cf,#cf,#c3 ;..A.....
db #c3,#c3,#0c,#0c,#c3,#c3,#c3,#c3
db #cf,#cf,#0f,#c3,#c3,#c3,#c3,#c3
db #0f,#cf,#cf,#c3,#c3,#c3,#49,#86 ;......I.
db #c3,#c3,#c3,#c3,#cf,#cf,#0f,#c3
db #c3,#82,#c3,#c3,#c3,#0f,#0f
lab542D db #cf
db #cb,#86,#c3,#49,#c3,#c7,#cf,#cf ;...I....
db #0f,#0f,#c3,#c3,#c3,#82,#c3,#c3
db #c3,#c3,#c3,#0f,#4f,#cf,#cf,#cf ;....O...
db #cf,#8f,#0f,#0f,#c3,#c3,#c3,#c3
db #c3,#82,#c3,#c3,#c3,#c3,#c3,#c3
db #87,#0f,#0f,#0f,#0f,#4b,#c3,#c3 ;.....K..
db #c3,#c3,#c3,#c3,#c3,#82,#20,#06
db #51,#e7,#cf,#cf,#db,#a2,#a7,#0f ;Q.......
db #4f,#4f,#cf,#db,#0f,#0f,#0f,#0f ;OO......
db #cf,#cf,#0f,#0f,#0f,#0f,#4f,#cf ;......O.
db #af,#0f,#4f,#4f,#cf,#df,#d7,#af ;..OO....
db #cf,#cf,#df,#eb,#d6,#fd,#ff,#ff
db #fe,#e9,#41,#e9,#d6,#e9,#83,#82 ;..A.....
db #41,#fc,#d6,#43,#03,#82,#41,#fc ;A..C..A.
db #d6,#43,#03,#82,#41,#fc,#d6,#43 ;.C..A..C
db #56,#82,#00,#d6,#d6,#e9,#43,#00 ;V.....C.
db #00,#d6,#d6,#e9,#43,#00,#00,#d6 ;....C...
db #d6,#43,#43,#00,#00,#41,#d6,#43 ;.CC..A.C
db #82,#00,#00,#41,#c3,#c7,#8a,#00 ;...A....
db #00,#41,#87,#4f,#8a,#00,#00,#41 ;.A.O...A
db #87,#4f,#8a,#00,#00,#41,#87,#4f ;.O...A.O
db #8a,#00,#00,#41,#87,#4f,#8a,#00 ;...A.O..
db #00,#41,#87,#4f,#8a,#00,#00,#41 ;.A.O...A
db #87,#4f,#8a,#00,#00,#41,#87,#4f ;.O...A.O
db #8a,#00,#00,#41,#87,#4f,#8a,#00 ;...A.O..
db #00,#41,#87,#4f,#8a,#00,#00,#41 ;.A.O...A
db #85,#4f,#8a,#00,#00,#41,#84,#4f ;.O...A.O
db #8a,#00,#00,#41,#84,#4f,#8a,#00 ;...A.O..
db #00,#41,#84,#4f,#8a,#00,#00,#51 ;.A.O...Q
db #84,#4f,#8a,#00,#00,#00,#a6,#4f ;.O.....O
db #a2,#00,#00,#00,#51,#f3,#00,#00 ;....Q...
db #08,#10,#41,#c3,#c3,#c3,#c3,#87 ;..A.....
db #0f,#0f,#0f,#0f,#4b,#c3,#c3,#c3 ;....K...
db #c3,#c3,#41,#c3,#c3,#c3,#0f,#4f ;..A....O
db #cf,#cf,#cf,#cf,#8f,#0f,#c3,#c3
db #c3,#c3,#41,#c3,#0f,#0f,#cf,#8b ;..A.....
db #03,#03,#f6,#fc,#ed,#cf,#0f,#0f
db #c3,#c3,#41,#0f,#cf,#cf,#03,#03 ;..A.....
db #03,#03,#f6,#fc,#fc,#fc,#cf,#cf
db #0f,#c3,#c3,#0f,#cf,#cf,#03,#03
db #03,#53,#fc,#fc,#fc,#fc,#cf,#cf ;.S......
db #0f,#82,#c3,#c3,#0f,#0f,#cf,#8b
db #03,#53,#fc,#fc,#ed,#cf,#0f,#0f ;.S......
db #c3,#82,#c3,#c3,#c3,#c3,#0f,#4f ;.......O
db #cf,#cf,#cf,#cf,#8f,#0f,#c3,#c3
db #c3,#82,#c3,#c3,#c3,#c3,#c3,#87
db #0f,#0f,#0f,#0f,#4b,#c3,#c3,#c3 ;....K...
db #c3,#82,#08,#10,#41,#c3,#c3,#c3 ;....A...
db #c3,#87,#0f,#0f,#0f,#0f,#4b,#c3 ;......K.
db #c3,#c3,#c3,#c3,#41,#c3,#c3,#c3 ;....A...
db #0f,#4f,#cf,#cf,#cf,#cf,#8f,#0f ;.O......
db #c3,#c3,#c3,#c3,#41,#c3,#0f,#0f ;....A...
db #cf,#8b,#53,#f3,#f3,#f3,#ed,#cf ;..S.....
db #0f,#0f,#c3,#c3,#41,#0f,#cf,#cf ;....A...
db #03,#03,#53,#f3,#f3,#f3,#fc,#fc ;..S.....
db #cf,#cf,#0f,#c3,#c3,#0f,#cf,#cf
db #03,#03,#f3,#f3,#f3,#f6,#fc,#fc
db #cf,#cf,#0f,#82,#c3,#c3,#0f,#0f
db #cf,#8b,#f3,#f3,#f3,#f6,#ed,#cf
db #0f,#0f,#c3,#82,#c3,#c3,#c3,#c3
db #0f,#4f,#cf,#cf,#cf,#cf,#8f,#0f ;.O......
db #c3,#c3,#c3,#82,#c3,#c3,#c3,#c3
db #c3,#87,#0f,#0f,#0f,#0f,#4b,#c3 ;......K.
db #c3,#c3,#c3,#82,#08,#10,#41,#c3 ;......A.
db #c3,#c3,#c3,#87,#0f,#0f,#0f,#0f
db #4b,#c3,#c3,#c3,#c3,#c3,#41,#c3 ;K.....A.
db #c3,#c3,#0f,#4f,#cf,#cf,#cf,#cf ;...O....
db #8f,#0f,#c3,#c3,#c3,#c3,#41,#c3 ;......A.
db #0f,#0f,#cf,#db,#f3,#f3,#f3,#f3
db #e7,#cf,#0f,#0f,#c3,#c3,#41,#0f ;......A.
db #cf,#cf,#53,#f3,#f3,#f3,#f3,#f3 ;..S.....
db #f3,#f6,#cf,#cf,#0f,#c3,#c3,#0f
db #cf,#cf,#53,#f3,#f3,#f3,#f3,#f3 ;..S.....
db #f3,#f6,#cf,#cf,#0f,#82,#c3,#c3
db #0f,#0f,#cf,#db,#f3,#f3,#f3,#f3
db #e7,#cf,#0f,#0f,#c3,#82,#c3,#c3
db #c3,#c3,#0f,#4f,#cf,#cf,#cf,#cf ;...O....
db #8f,#0f,#c3,#c3,#c3,#82,#c3,#c3
db #c3,#c3,#c3,#87,#0f,#0f,#0f,#0f
db #4b,#c3,#c3,#c3,#c3,#82,#10,#0a ;K.......
db #00,#00,#00,#00,#00,#c0,#80,#00
db #00,#00,#00,#00,#00,#00,#40,#0c
db #c0,#00,#00,#00,#00,#00,#00,#00
db #84,#0c,#48,#00,#00,#00,#00,#00 ;..H.....
db #00,#00,#84,#0c,#48,#80,#00,#00 ;....H...
db #00,#00,#00,#00,#40,#0c,#0c,#80
db #00,#00,#00,#00,#00,#c0,#80,#0c
db #0c,#c0,#00,#00,#00,#00,#40,#84
db #48,#84,#48,#c0,#80,#00,#00,#00 ;H.H.....
db #c0,#0c,#0c,#84,#48,#48,#80,#00 ;....HH..
db #00,#00,#c0,#0c,#0c,#84,#0c,#0c
db #80,#00,#00,#00,#40,#0c,#0c,#0c
db #0c,#0c,#48,#00,#00,#c0,#40,#84 ;..H.....
db #0c,#0c,#48,#48,#48,#00,#40,#84 ;..HHH...
db #84,#48,#84,#84,#48,#0c,#48,#80 ;.H..H.H.
db #84,#0c,#0c,#84,#48,#0c,#0c,#84 ;....H...
db #0c,#80,#84,#0c,#0c,#c0,#0c,#0c
db #0c,#c0,#0c,#48,#40,#84,#0c,#48 ;...H...H
db #c0,#84,#c0,#c0,#0c,#c0,#00,#40
db #c0,#80,#00,#c0,#c0,#80,#c0,#80
db #10,#16,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#40,#c0,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#84,#48,#80,#00,#00 ;....H...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#04,#c0
db #40,#0c,#0c,#80,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#0c,#48,#80,#84 ;.....H..
db #0c,#c0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#04,#0c,#0c,#c0,#84,#0c,#c0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#04
db #0c,#0c,#c0,#0c,#0c,#0c,#c0,#80
db #00,#c0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#0c,#0c
db #84,#84,#0c,#0c,#84,#48,#40,#0c ;.....H..
db #80,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#08,#0c,#0c,#0c,#48 ;.......H
db #84,#c0,#0c,#0c,#84,#48,#80,#00 ;.....H..
db #00,#00,#40,#80,#00,#40,#80,#00
db #84,#48,#0c,#0c,#0c,#0c,#84,#0c ;.H......
db #0c,#48,#0c,#48,#48,#80,#00,#c0 ;.H.HH...
db #84,#0c,#48,#84,#0c,#48,#0c,#0c ;..H..H..
db #84,#0c,#48,#48,#c0,#48,#84,#c0 ;..HH.H..
db #0c,#84,#0c,#48,#40,#48,#0c,#48 ;...H.H.H
db #84,#0c,#48,#84,#84,#0c,#c0,#84 ;..H.....
db #84,#c0,#40,#c0,#0c,#0c,#0c,#0c
db #0c,#0c,#0c,#0c,#84,#80,#00,#04
db #80,#00,#c0,#48,#c0,#c0,#c0,#48 ;...H...H
db #80,#40,#0c,#48,#c0,#48,#48,#48 ;...H.HHH
db #c0,#c0,#c0,#00,#00,#40,#00,#00
db #00,#c0,#c0,#00,#40,#c0,#00,#00
db #40,#80,#00,#c0,#80,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#08,#0c,#00,#a2,#a2,#00
db #00,#a2,#a2,#00,#14,#14,#a0,#00
db #00,#79,#f1,#00,#51,#f1,#79,#51 ;.y..Q.yQ
db #f2,#f2,#79,#a2,#50,#b6,#f2,#a2 ;..y.P...
db #b6,#b6,#b4,#b6,#78,#78,#f1,#f1 ;....xx..
db #51,#f0,#f3,#f3,#79,#f0,#f1,#f2 ;Q...y...
db #f0,#f0,#f2,#78,#3c,#79,#f0,#f3 ;...x.y..
db #78,#f3,#f1,#f0,#78,#78,#f0,#f2 ;x...xx..
db #f2,#b4,#f0,#b4,#f2,#f2,#79,#78 ;......yx
db #f2,#f2,#f1,#f1,#f1,#f0,#f2,#f2
db #f1,#3c,#b4,#f1,#f3,#f3,#f0,#f2
db #b6,#f2,#f1,#78,#b6,#f2,#f1,#f1 ;...x....
db #78,#78,#3c,#a0,#10,#12,#00,#00 ;xx......
db #00,#00,#00,#00,#00,#00,#00,#00
db #a2,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#51,#f1,#00,#00,#00,#00,#00 ;.Q......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#b7,#f0,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#51,#3f,#3f,#f1 ;....Q...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#b7,#3f
db #b5,#f0,#a2,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #3f,#b5,#f0,#3e,#f1,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#b7,#78,#78,#b5,#7a,#78,#f1 ;..xx.zx.
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #f3,#00,#00,#b6,#b4,#7a,#3c,#3f ;.....z..
db #f0,#b5,#f3,#00,#00,#00,#00,#00
db #00,#b7,#3f,#a2,#51,#3d,#3d,#f0 ;....Q...
db #b4,#b5,#b4,#3c,#3f,#a2,#00,#00
db #00,#00,#51,#3f,#3c,#f1,#51,#3c ;..Q...Q.
db #3f,#f0,#78,#3d,#f0,#b4,#3d,#7b ;..x.....
db #00,#00,#00,#00,#b7,#3e,#3e,#78 ;.......x
db #b6,#b4,#3e,#b4,#f0,#b4,#7a,#b4 ;......z.
db #3d,#3f,#a2,#00,#00,#51,#3d,#78 ;.....Q.x
db #3d,#3c,#f0,#b5,#f0,#78,#78,#78 ;.....xxx
db #3d,#f0,#b5,#3c,#f1,#00,#00,#b6
db #3e,#78,#b5,#78,#b4,#3f,#b4,#f0 ;.x.x....
db #3c,#b4,#b4,#3f,#f0,#3e,#3d,#a2
db #51,#b4,#7a,#78,#78,#7a,#78,#7a ;Q.zxxzxz
db #78,#f0,#7a,#b4,#3c,#3d,#3f,#3d ;x.z.....
db #3c,#7b,#b6,#b5,#f0,#b4,#78,#f0 ;......x.
db #f0,#f0,#f0,#b4,#7a,#f0,#3c,#3c ;....z...
db #3d,#3e,#7a,#3d,#3c,#7a,#b4,#78 ;..z..z.x
db #b4,#f0,#f0,#f0,#f0,#b4,#f0,#b5
db #3f,#3c,#3c,#3f,#f0,#b4,#20,#08
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
db #ff,#ff,#ff,#00,#7f,#00,#7f,#00
db #3f,#3f,#7f,#bf,#bf,#bf,#bf,#bf
db #7f,#7f,#7f,#7f,#00,#7f,#00,#7f
db #2a,#2a,#7f,#ff,#ff,#ff,#ff,#ff
db #3f,#3f,#7f,#bf,#3f,#3f,#3f,#3f
db #3f,#7f,#7f,#7f,#00,#00,#ff,#00
db #3f,#2a,#7f,#7f,#aa,#00,#bf,#aa
db #3f,#3f,#7f,#3f,#aa,#00,#bf,#7f
db #3f,#7f,#7f,#15,#ff,#00,#aa,#3f
db #7f,#2a,#aa,#00,#7f,#aa,#aa,#15
db #2a,#3f,#aa,#00,#2a,#aa,#aa,#00
db #3f,#7f,#00,#00,#15,#7f,#aa,#15
db #ff,#ff,#00,#00,#15,#55,#aa,#15 ;.....U..
db #3f,#aa,#00,#00,#00,#15,#aa,#7f
db #3f,#aa,#ff,#ff,#ff,#ff,#bf,#bf
db #3f,#7f,#3f,#3f,#3f,#3f,#ff,#bf
db #3f,#7f,#bf,#3f,#3f,#3f,#55,#2a ;......U.
db #7f,#7f,#7f,#00,#00,#15,#bf,#00
db #2a,#7f,#55,#00,#00,#15,#bf,#00 ;..U.....
db #3f,#7f,#15,#aa,#00,#7f,#2a,#00
db #3f,#7f,#00,#aa,#00,#7f,#2a,#00
db #7f,#7f,#00,#7f,#00,#7f,#2a,#00
db #2a,#7f,#00,#55,#15,#bf,#00,#00 ;...U....
db #3f,#7f,#ff,#15,#bf,#bf,#00,#00
db #3f,#7f,#3f,#ff,#bf,#bf,#00,#00
db #7f,#7f,#00,#3f,#3f,#bf,#00,#00
db #2a,#7f,#00,#00,#15,#bf,#00,#00
db #3f,#7f,#00,#00,#7f,#2a,#00,#00
db #3f,#7f,#00,#00,#7f,#2a,#00,#00
db #7f,#7f,#ff,#ff,#7f,#2a,#00,#00
db #2a,#3f,#3f,#3f,#7f,#2a,#00,#00
db #10,#0e,#3f,#3f,#3f,#3f,#3f,#3f
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
db #7f,#00,#7f,#00,#7f,#00,#7f,#bf
db #00,#bf,#00,#bf,#00,#bf,#bf,#bf
db #bf,#bf,#bf,#bf,#bf,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#00,#7f,#00,#7f
db #00,#7f,#00,#00,#bf,#00,#bf,#00
db #bf,#00,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #3f,#3f,#3f,#3f,#7f,#3f,#3f,#3f
db #3f,#bf,#3f,#3f,#3f,#3f,#7f,#00
db #15,#ff,#3f,#00,#00,#00,#00,#3f
db #ff,#2a,#00,#bf,#7f,#15,#7f,#3f
db #00,#00,#00,#00,#00,#00,#3f,#bf
db #2a,#bf,#7f,#7f,#bf,#00,#00,#00
db #00,#00,#00,#00,#00,#7f,#bf,#bf
db #ff,#ff,#2a,#00,#00,#00,#00,#00
db #00,#00,#00,#15,#ff,#ff,#55,#bf ;......U.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#7f,#aa,#7f,#2a,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #15,#bf,#bf,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#7f
db #bf,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#7f,#2a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#15,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#0c,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #3f,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#b7,#b7,#f3,#f3,#f3
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#7f
db #bf,#7b,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#b7,#b7,#fb,#f3,#bf,#3f,#f3
db #f3,#f3,#f3,#f3,#f3,#7f,#7f,#f7
db #7b,#f7,#f3,#7b,#f3,#f3,#f3,#f3
db #f3,#7f,#fb,#f7,#bf,#b7,#3f,#b7
db #f3,#f3,#f3,#f3,#b7,#fb,#f7,#fb
db #55,#7f,#7f,#3f,#f3,#f3,#f3,#f3 ;U.......
db #b7,#fb,#fb,#f3,#bf,#bf,#bf,#b7
db #f3,#f3,#f3,#f3,#7f,#7f,#7f,#7f
db #7b,#7b,#bf,#f7,#f3,#f3,#f3,#b7
db #fb,#7f,#3f,#b7,#7b,#f3,#bf,#f3
db #f3,#f3,#f3,#f3,#f3,#ff,#f3,#b7
db #3f,#f3,#fb,#7b,#f3,#f3,#f3,#f3
db #f7,#f7,#f3,#3f,#ff,#7b,#f7,#f3
db #f3,#f3,#f3,#f3,#f3,#fb,#b7,#ff
db #f3,#bf,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#f7,#fb,#f3,#f7,#7b,#f3
db #f3,#f3,#f3,#f3,#f3,#f3,#f7,#f3
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#f3,#20,#04,#55,#3f ;......U.
db #a2,#00,#55,#3f,#7b,#00,#55,#bf ;..U...U.
db #7f,#a2,#55,#b7,#7b,#a2,#55,#3f ;..U...U.
db #3f,#a2,#55,#3f,#3f,#aa,#55,#bf ;..U...U.
db #7f,#aa,#55,#b7,#7b,#aa,#55,#3f ;..U...U.
db #f3,#a2,#55,#3f,#7b,#a2,#55,#bf ;..U...U.
db #7f,#a2,#55,#b7,#7b,#a2,#55,#3f ;..U...U.
db #3f,#a2,#55,#3f,#3f,#aa,#55,#bf ;..U...U.
db #7f,#aa,#55,#b7,#7b,#aa,#51,#3f ;..U...Q.
db #3f,#aa,#51,#3f,#3f,#aa,#51,#bf ;..Q...Q.
db #7f,#aa,#51,#b7,#7b,#aa,#55,#3f ;..Q...U.
db #3f,#aa,#55,#3f,#3f,#a2,#55,#bf ;..U...U.
db #7f,#a2,#55,#b7,#7b,#aa,#55,#bf ;..U...U.
db #7f,#aa,#55,#b7,#7b,#aa,#55,#3f ;..U...U.
db #3f,#aa,#55,#ff,#ff,#aa,#ff,#3f ;..U.....
db #3f,#ff,#bf,#3f,#3f,#7f,#3f,#b7
db #7b,#3f,#bf,#bf,#7f,#7f,#10,#14
db #37,#cc,#9d,#cc,#cc,#6e,#9d,#3b ;.....n..
db #9d,#66,#66,#99,#66,#9d,#6e,#33 ;.ff.f.n.
db #33,#9d,#6e,#99,#33,#33,#bb,#37 ;..n.....
db #99,#33,#33,#3f,#66,#33,#bb,#37 ;....f...
db #33,#66,#3f,#33,#33,#3f,#99,#33 ;.f......
db #33,#33,#3b,#66,#33,#33,#33,#33 ;...f....
db #33,#33,#3b,#33,#33,#33,#33,#33
db #33,#33,#33,#33,#9d,#33,#33,#33
db #33,#33,#33,#33,#3f,#33,#33,#33
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#33,#33,#3b,#33,#3f,#99,#33
db #33,#33,#66,#3f,#33,#3f,#33,#99 ;..f.....
db #66,#33,#3f,#33,#99,#33,#9d,#bf ;f.......
db #37,#ff,#6e,#37,#99,#66,#9d,#bf ;..n..f..
db #3f,#ff,#3f,#66,#99,#3f,#ff,#3f ;...f....
db #99,#33,#66,#3b,#37,#3f,#6e,#dd ;..f...n.
db #6e,#cc,#cc,#6e,#9d,#3f,#7f,#6e ;n..n...n
db #99,#37,#3f,#3f,#cc,#33,#33,#cc
db #66,#33,#cc,#3f,#6e,#33,#33,#99 ;f...n...
db #66,#3f,#37,#6e,#99,#33,#3f,#3b ;f..n....
db #cc,#cc,#33,#33,#33,#33,#33,#cc
db #99,#33,#33,#33,#33,#66,#9d,#cc ;.....f..
db #cc,#66,#99,#33,#66,#33,#33,#3b ;.f..f...
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#33,#cc,#cc,#cc,#cc,#33,#33
db #99,#33,#9d,#3f,#33,#33,#33,#66 ;.......f
db #cc,#9d,#3b,#66,#cc,#cc,#99,#66 ;...f...f
db #99,#66,#cc,#cc,#66,#66,#3f,#ff ;.f..ff..
db #6e,#33,#33,#cc,#3f,#cc,#cc,#cc ;n.......
db #cc,#6e,#cc,#cc,#cc,#cc,#9d,#6e ;.n.....n
db #99,#cc,#7f,#7f,#3f,#cc,#cc,#9d
db #7f,#6e,#cc,#6e,#9d,#bf,#cc,#99 ;.n.n....
db #66,#cc,#7f,#3f,#cc,#9d,#ff,#3f ;f.......
db #3f,#6e,#cc,#9d,#bf,#3f,#cc,#cc ;.n......
db #9d,#bf,#6e,#99,#66,#9d,#7f,#3f ;..n.f...
db #66,#9d,#bf,#3f,#3f,#6e,#cc,#cc ;f....n..
db #3f,#6e,#cc,#cc,#7f,#3f,#6e,#cc ;.n....n.
db #cc,#9d,#3f,#bf,#99,#66,#3f,#3b ;.....f..
db #3f,#cc,#33,#33,#cc,#cc,#3f,#6e ;.......n
db #3f,#3f,#cc,#33,#33,#cc,#3f,#3b
db #20,#0e,#aa,#ff,#00,#ff,#bf,#ff
db #7f,#bf,#2a,#3f,#00,#00,#00,#00
db #f3,#7f,#f3,#f3,#ff,#f3,#7f,#f3
db #b7,#ff,#3f,#ff,#00,#00,#3f,#bf
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
db #7f,#3f,#2a,#2a,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#aa,#f3,#7f,#f3,#7f,#f3,#7f
db #f3,#7f,#f3,#7f,#f3,#7f,#f3,#7f
db #bf,#bf,#bf,#bf,#bf,#bf,#bf,#bf
db #bf,#bf,#bf,#bf,#bf,#bf,#7f,#f3
db #7f,#f3,#7f,#f3,#7f,#f3,#7f,#f3
db #7f,#f3,#7f,#f3,#3f,#3f,#3f,#3f
db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
db #3f,#3f,#f3,#fb,#7f,#f3,#f3,#bf
db #f3,#f3,#fb,#f3,#f3,#bf,#15,#fb
db #0f,#ff,#1f,#eb,#d3,#bf,#c3,#d3
db #ff,#c3,#d3,#bf,#82,#ff,#5b,#bf
db #1f,#eb,#87,#ff,#c3,#87,#bf,#c3
db #87,#ff,#87,#bf,#4b,#bf,#0f,#7f ;....K...
db #0f,#fb,#c3,#0f,#bf,#c3,#0f,#fb
db #0f,#bf,#4b,#51,#5b,#7f,#a7,#bf ;..KQ....
db #c3,#05,#51,#c3,#05,#bf,#05,#f3 ;..Q.....
db #0a,#55,#4b,#97,#aa,#bf,#d3,#00 ;.UK.....
db #55,#82,#00,#ff,#00,#f7,#0f,#15 ;U.......
db #4b,#97,#aa,#ff,#c3,#00,#15,#c3 ;K.......
db #00,#bf,#aa,#b7,#5b,#15,#0f,#c3
db #7f,#fb,#c3,#0a,#15,#c3,#0a,#fb
db #7f,#b7,#4b,#fb,#5b,#c3,#7f,#bf ;..K.....
db #c3,#a2,#fb,#c3,#a2,#bf,#15,#aa
db #4b,#ff,#4b,#c3,#97,#bf,#c3,#82 ;K.K.....
db #ff,#c3,#82,#bf,#d7,#fb,#4b,#bf ;......K.
db #4b,#c3,#bf,#ff,#c3,#87,#bf,#c3 ;K.......
db #87,#ff,#bf,#bf,#0f,#bf,#0f,#c3
db #bf,#fb,#c3,#0f,#bf,#c3,#0f,#ff
db #2f,#bf,#5b,#fb,#5b,#d7,#2f,#bf
db #c3,#a7,#fb,#c3,#a7,#bf,#af,#fb
db #4b,#ff,#41,#d7,#2f,#bf,#c3,#87 ;K.A.....
db #ff,#c3,#87,#bf,#7f,#ff,#4b,#bf ;......K.
db #41,#bf,#87,#ff,#c3,#87,#bf,#c3 ;A.......
db #87,#ff,#97,#bf,#4b,#bf,#05,#bf ;....K...
db #0f,#fb,#c3,#0f,#bf,#c3,#0f,#fb
db #5f,#3f,#0f,#fb,#55,#6b,#a7,#15 ;....Uk..
db #c3,#a7,#fb,#c3,#a7,#15,#bf,#fb
db #5b,#ff,#5f,#6b,#87,#15,#c3,#87 ;...k....
db #ff,#c3,#87,#55,#2f,#ff,#4b,#bf ;...U..K.
db #bf,#c3,#82,#55,#c3,#82,#bf,#c3 ;...U....
db #82,#55,#fb,#bf,#4b,#bf,#bf,#c3 ;.U..K...
db #0a,#51,#c3,#0a,#bf,#c3,#0a,#00 ;.Q......
db #7f,#bf,#4b,#fb,#7b,#c3,#a7,#bf ;..K.....
db #c3,#a7,#fb,#c3,#a7,#bf,#15,#fb
db #0f,#ff,#7f,#c3,#0f,#bf,#c3,#0f
db #ff,#c3,#0f,#bf,#0f,#ff,#5b,#bf
db #5f,#eb,#a7,#ff,#c3,#a7,#bf,#c3
db #a7,#ff,#05,#bf,#4b,#bf,#4b,#eb ;....K.K.
db #87,#fb,#c3,#87,#bf,#c3,#87,#aa
db #87,#bf,#20,#0a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #cf,#0f,#47,#0f,#4f,#cf,#03,#cf ;..G.O...
db #8f,#4f,#0f,#0f,#8f,#4f,#8f,#4f ;.O...O.O
db #cf,#0f,#4f,#cf,#07,#0f,#4f,#0f ;..O...O.
db #4f,#cf,#8f,#0f,#07,#0f,#0f,#4f ;O......O
db #0f,#cf,#cf,#03,#cf,#47,#8b,#47 ;.....G.G
db #4f,#cf,#8f,#0f,#0f,#0f,#cf,#8f ;O.......
db #0f,#8f,#0f,#0b,#cf,#8b,#8f,#0f
db #0f,#07,#0f,#0f,#0f,#0f,#8f,#8f
db #0f,#0f,#0f,#0f,#07,#0f,#8f,#0f
db #4f,#0f,#0f,#8b,#8f,#03,#0b,#8f ;O.......
db #cf,#8f,#0f,#cf,#0c,#8f,#0f,#0f
db #0f,#8e,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0c,#4f,#0c,#0f ;.....O..
db #0d,#4f,#4d,#0c,#4f,#0c,#0f,#0c ;.OM.O...
db #cf,#4f,#0f,#8e,#8f,#0f,#0c,#cf ;.O......
db #4f,#cf,#4f,#0e,#8f,#4f,#0f,#4f ;O.O..O.O
db #cf,#4f,#0f,#4f,#8e,#4d,#0f,#0f ;.O.O.M..
db #0f,#0f,#4f,#8e,#0c,#0f,#4f,#8f ;..O...O.
db #0f,#cf,#cf,#0c,#0f,#4f,#4d,#0d ;.....OM.
db #8f,#0f,#0f,#0f,#0c,#4d,#0d,#8f ;.....M..
db #8f,#4f,#4f,#4f,#4f,#8f,#0f,#8f ;.OOOO...
db #4f,#cf,#0f,#0f,#8f,#8f,#0f,#0f ;O.......
db #4d,#cf,#cf,#cf,#0f,#4f,#4d,#8f ;M....OM.
db #4f,#8e,#4f,#0f,#4f,#4d,#0f,#0f ;O.O.OM..
db #8f,#0c,#0f,#0f,#0f,#0f,#0f,#8f
db #cf,#0f,#0f,#0f,#4f,#0f,#8f,#cf ;....O...
db #0f,#0f,#cf,#cf,#8f,#0f,#8f,#cf
db #cf,#cf,#cf,#8f,#cf,#0f,#0f,#4f ;.......O
db #8f,#4f,#8f,#cf,#0f,#0f,#4d,#0c ;.O....M.
db #cf,#0f,#0f,#cf,#4d,#4d,#8e,#0c ;....MM..
db #0c,#0c,#0c,#4d,#4d,#0c,#8e,#0c ;...MM...
db #0c,#0c,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#08,#0a,#00,#00
db #f3,#a2,#00,#00,#00,#00,#00,#00
db #00,#f3,#7a,#f1,#00,#00,#00,#a2 ;..z.....
db #00,#00,#51,#b5,#3d,#78,#f3,#00 ;..Q..x..
db #f3,#f1,#00,#00,#f2,#3e,#b4,#3e
db #b4,#f3,#f0,#7a,#f3,#00,#f2,#3c ;...z....
db #f0,#3e,#d8,#b4,#b4,#b5,#f0,#f3
db #b5,#b4,#b4,#b5,#3c,#f0,#3c,#78 ;.......x
db #3d,#f0,#f3,#78,#3c,#b4,#f3,#b6 ;...x....
db #f0,#b4,#f3,#f3,#00,#f3,#f3,#f3
db #00,#51,#f3,#f3,#00,#00,#18,#0a ;.Q......
db #00,#00,#00,#00,#00,#00,#f3,#00
db #00,#00,#00,#00,#00,#51,#f3,#f3 ;.....Q..
db #3c,#a2,#00,#00,#00,#00,#00,#b6
db #3c,#b6,#f0,#79,#00,#00,#00,#00 ;...y....
db #51,#78,#fa,#78,#f3,#a2,#00,#00 ;Qx.x....
db #00,#00,#51,#f1,#7b,#f1,#3c,#79 ;..Q....y
db #00,#00,#00,#00,#51,#f3,#3c,#be ;....Q...
db #f5,#b4,#a2,#00,#00,#00,#51,#3c ;......Q.
db #f1,#78,#b7,#f2,#a2,#00,#00,#00 ;.x......
db #b6,#f0,#b6,#f5,#7b,#51,#00,#00 ;.....Q..
db #00,#00,#f2,#f3,#78,#b7,#f3,#00 ;....x...
db #00,#00,#00,#00,#51,#b6,#f5,#51 ;....Q..Q
db #bf,#a2,#00,#00,#00,#00,#00,#f2
db #b7,#51,#7b,#00,#00,#00,#00,#00 ;.Q......
db #00,#f2,#00,#00,#f7,#a2,#00,#00
db #00,#00,#00,#00,#f3,#a2,#b7,#fb
db #00,#00,#00,#00,#00,#51,#3f,#7b ;.....Q..
db #51,#7b,#00,#00,#00,#00,#00,#b7 ;Q.......
db #3a,#64,#f7,#f3,#00,#00,#00,#00 ;.d......
db #51,#3f,#35,#30,#9d,#fb,#00,#00 ;Q.......
db #00,#00,#b2,#3a,#98,#3a,#b7,#7b
db #00,#00,#00,#51,#35,#30,#cc,#3a ;...Q....
db #d9,#7b,#a2,#00,#00,#e6,#35,#98
db #98,#9d,#cc,#b2,#71,#00,#51,#64 ;....q.Qd
db #6e,#cc,#30,#cc,#cc,#64,#30,#a2 ;n....d..
db #b2,#35,#cc,#30,#cc,#64,#cc,#cc ;.....d..
db #cc,#71,#51,#cc,#cc,#cc,#cc,#cc ;.qQ.....
db #64,#e6,#e6,#a2,#00,#f3,#e6,#98 ;d.......
db #30,#f3,#f3,#51,#51,#00,#00,#00 ;...QQ...
db #51,#f3,#f3,#00,#00,#00,#00,#00 ;Q.......
db #18,#10,#00,#00,#00,#51,#f3,#f3 ;.....Q..
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#00
db #00,#00,#00,#51,#f3,#e3,#c3,#87 ;...Q....
db #0f,#0f,#0f,#0f,#4b,#c3,#c3,#f3 ;....K...
db #a2,#00,#51,#e3,#c3,#c3,#0f,#4f ;..Q....O
db #cf,#cf,#cf,#cf,#8f,#0f,#c3,#c3
db #d3,#a2,#e3,#c3,#0f,#0f,#cf,#cb
db #c3,#86,#c3,#49,#c7,#cf,#0f,#0f ;...I....
db #c3,#d3,#c3,#0f,#cf,#cf,#c3,#c3
db #c3,#0c,#0c,#c3,#c3,#c3,#cf,#cf
db #0f,#c3,#c3,#0f,#cf,#cf,#c3,#c3
db #c3,#49,#86,#c3,#c3,#c3,#cf,#cf ;.I......
db #0f,#c3,#c3,#c3,#0f,#0f,#cf,#cb
db #86,#c3,#49,#c3,#c7,#cf,#0f,#0f ;..I.....
db #c3,#c3,#e3,#c3,#c3,#c3,#0f,#4f ;.......O
db #cf,#cf,#cf,#cf,#8f,#0f,#4b,#c3 ;......K.
db #c3,#d3,#51,#e3,#c3,#c3,#c3,#87 ;..Q.....
db #0f,#0f,#0f,#0f,#4b,#c3,#c3,#c3 ;....K...
db #f3,#a2,#00,#51,#f3,#f3,#c3,#c3 ;...Q....
db #c3,#c3,#c3,#c3,#c3,#f3,#f3,#f3
db #00,#00,#00,#00,#00,#7f,#f3,#f3
db #f3,#f3,#f3,#f3,#f3,#7f,#7f,#00
db #00,#00,#00,#00,#00,#7f,#bf,#00
db #bf,#2a,#15,#bf,#2a,#7f,#7f,#00
db #00,#00,#00,#00,#00,#7f,#55,#3f ;......U.
db #bf,#2a,#7f,#15,#3f,#aa,#7f,#00
db #00,#00,#00,#00,#00,#7f,#55,#3f ;......U.
db #bf,#bf,#7f,#15,#bf,#aa,#7f,#00
db #00,#00,#00,#00,#00,#7f,#00,#7f
db #15,#bf,#aa,#15,#bf,#00,#7f,#00
db #00,#00,#00,#00,#00,#7f,#51,#7f ;......Q.
db #b7,#f7,#2a,#15,#7f,#2a,#7f,#00
db #00,#00,#00,#00,#00,#7f,#15,#ff
db #3f,#7f,#7b,#15,#ff,#7b,#7f,#00
db #00,#00,#00,#00,#00,#7f,#b7,#ff
db #3f,#7f,#bf,#b7,#ff,#bf,#7f,#00
db #00,#00,#00,#00,#00,#7f,#7f,#f3
db #bf,#fb,#bf,#3f,#f3,#bf,#7f,#00
db #00,#00,#00,#00,#00,#7f,#7f,#00
db #bf,#aa,#f7,#3f,#00,#f7,#7f,#00
db #00,#00,#00,#00,#00,#f7,#f3,#00
db #f3,#a2,#51,#b7,#00,#51,#f3,#00 ;..Q..Q..
db #00,#00,#00,#00,#00,#51,#00,#00 ;.....Q..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#10,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#a2,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#a2,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#f3,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#e6,#f3,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#f3,#d9,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#f3,#d9,#00,#00 ;...Q....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#51,#f3,#f3,#00,#00 ;...Q....
db #00,#00,#00,#00,#f3,#00,#00,#00
db #00,#00,#00,#f3,#f3,#e6,#f3,#00
db #00,#00,#00,#00,#f3,#00,#00,#00
db #f3,#f3,#f3,#e6,#cc,#d9,#e6,#f3
db #f3,#f3,#f3,#a2,#cc,#f3,#f3,#f3
db #cc,#cc,#cc,#d9,#f3,#f3,#f3,#d9
db #cc,#cc,#cc,#f3,#f3,#f3,#e6,#e6
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#d9,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#f3,#f3,#f3,#f3,#f3
db #f3,#f3,#f3,#f3,#f3,#00,#00,#00
db #00,#51,#f3,#f3,#f3,#f3,#f3,#f3 ;.Q......
db #f3,#f3,#f3,#a2,#10,#0a,#50,#a0 ;......P.
db #a0,#50,#50,#00,#f0,#f0,#00,#b4 ;.PP.....
db #b4,#50,#50,#f0,#00,#f0,#78,#f0 ;.PP...x.
db #b4,#f0,#14,#b4,#f0,#78,#78,#28 ;.....xx.
db #78,#50,#b4,#14,#00,#28,#28,#b4 ;xP......
db #78,#14,#a0,#f0,#50,#28,#28,#28 ;x...P...
db #3c,#f0,#78,#14,#b4,#f0,#28,#28 ;..x.....
db #b4,#14,#50,#78,#78,#78,#78,#a0 ;..Pxxxx.
db #b4,#14,#50,#28,#b4,#00,#f0,#00 ;..P.....
db #f0,#50,#50,#28,#50,#78,#f0,#14 ;.PP.Px..
db #50,#28,#a0,#a0,#50,#78,#28,#f0 ;P...Px..
db #f0,#3c,#00,#b4,#00,#50,#28,#00 ;.....P..
db #b4,#50,#b4,#78,#14,#b4,#00,#b4 ;.P.x....
db #00,#f0,#b4,#00,#b4,#b4,#f0,#50 ;.......P
db #28,#b4,#f0,#78,#78,#78,#3c,#b4 ;...xxx..
db #78,#a0,#f0,#a0,#b4,#78,#3c,#f0 ;x....x..
db #78,#28,#14,#f0,#f0,#50,#3c,#78 ;x....P.x
db #3c,#78,#28,#00,#3c,#f0,#a0,#b4 ;.x......
db #3c,#a0,#b4,#78,#3c,#28,#b4,#78 ;...x...x
db #f0,#3c,#3c,#b4,#14,#78,#78,#b4 ;.....xx.
db #14,#78,#50,#b4,#78,#50,#10,#0a ;.xP.xP..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#a2,#00,#00
db #00,#00,#00,#00,#00,#00,#51,#f1 ;......Q.
db #00,#00,#00,#00,#00,#00,#00,#00
db #f2,#78,#a2,#00,#00,#00,#00,#00 ;.x......
db #00,#00,#b6,#b6,#f1,#00,#00,#00
db #00,#00,#00,#51,#79,#b6,#f1,#00 ;...Qy...
db #00,#00,#00,#00,#00,#00,#a2,#51 ;.......Q
db #78,#a2,#00,#a2,#00,#00,#00,#00 ;x.......
db #00,#51,#b6,#f1,#51,#79,#00,#00 ;.Q..Qy..
db #51,#f3,#00,#b6,#b6,#79,#b6,#b4 ;Q....y..
db #a2,#00,#b6,#78,#f3,#78,#79,#78 ;...x.xyx
db #78,#f3,#79,#00,#51,#b4,#f1,#f1 ;x.y.Q...
db #f3,#78,#f1,#00,#a2,#a2,#00,#b6 ;.x......
db #78,#f1,#79,#3c,#f1,#a2,#f3,#79 ;x.y....y
db #00,#51,#78,#b6,#b4,#3c,#b6,#f1 ;.Qx.....
db #3c,#b4,#00,#b6,#f2,#3c,#b6,#f2
db #3c,#3c,#78,#f3,#00,#51,#79,#79 ;..x..Qyy
db #79,#79,#79,#78,#f0,#a2,#00,#00 ;yyyx....
db #b6,#b4,#3c,#b4,#3c,#f1,#f1,#00
db #10,#06,#00,#00,#b6,#a2,#00,#00
db #00,#51,#f0,#79,#00,#00,#00,#51 ;.Q.y...Q
db #b1,#73,#00,#00,#00,#51,#f3,#73 ;.s...Q.s
db #00,#00,#00,#f2,#f0,#a2,#a2,#00
db #51,#78,#78,#f3,#73,#00,#f2,#f1 ;Qxx.s...
db #f0,#f0,#73,#00,#f2,#a2,#b6,#3c ;..s.....
db #a2,#00,#b3,#f3,#79,#f3,#00,#00 ;....y...
db #51,#51,#78,#a2,#00,#00,#00,#51 ;QQx....Q
db #f0,#f1,#00,#00,#00,#51,#f3,#78 ;.....Q.x
db #a2,#00,#51,#b6,#f1,#f7,#a2,#00 ;..Q.....
db #f7,#be,#f1,#f7,#a2,#00,#b7,#7a ;.......z
db #a2,#f7,#7b,#00,#b7,#f3,#00,#51 ;.......Q
db #a2,#00,#10,#06,#00,#00,#51,#00 ;......Q.
db #00,#00,#00,#00,#b6,#a2,#00,#00
db #00,#51,#f0,#79,#00,#00,#00,#51 ;.Q.y...Q
db #b1,#73,#00,#00,#00,#00,#f3,#73 ;.s.....s
db #00,#00,#00,#51,#f0,#a2,#00,#00 ;...Q....
db #00,#f2,#f0,#a2,#00,#00,#00,#b6
db #f2,#f3,#00,#00,#00,#51,#b4,#b3 ;.....Q..
db #a2,#00,#00,#b3,#b4,#f3,#00,#00
db #00,#f2,#f1,#79,#00,#00,#00,#51 ;...y...Q
db #f0,#a2,#00,#00,#00,#f7,#b6,#f1
db #00,#00,#00,#b7,#f2,#a2,#00,#00
db #00,#51,#fb,#00,#00,#00,#00,#f7 ;.Q......
db #3f,#a2,#00,#00,#20,#04,#00,#51 ;.......Q
db #dc,#98,#51,#e6,#71,#71,#e6,#30 ;..Q.qq..
db #f3,#a2,#98,#f9,#98,#d9,#74,#b2 ;......t.
db #98,#d9,#e6,#98,#98,#88,#e6,#cc
db #cc,#88,#b2,#98,#98,#88,#b2,#98
db #d9,#88,#e6,#98,#f9,#88,#b2,#cc
db #d9,#88,#b2,#b8,#d9,#88,#e6,#ec
db #d9,#88,#e6,#98,#d9,#88,#b2,#98
db #d9,#f9,#7b,#b2,#b2,#b7,#ff,#7b
db #7b,#fb,#7f,#f3,#fb,#3f,#7f,#3f
db #bf,#fb,#55,#fb,#bf,#a2,#55,#a2 ;..U...U.
db #ff,#a2,#55,#a2,#7f,#00,#55,#fb ;..U...U.
db #ff,#00,#55,#fb,#ff,#00,#55,#f7 ;..U...U.
db #55,#00,#55,#f7,#f7,#00,#55,#15 ;U.U...U.
db #55,#00,#55,#15,#f7,#00,#55,#7f ;U.U...U.
db #7f,#00,#55,#7f,#ff,#00,#15,#fb ;..U.....
db #bf,#00,#15,#fb,#bf,#00
lab67F4 db #0
db #00,#f2,#00,#e4,#01,#d6,#02,#c8
db #03,#ba,#04,#ac,#05,#9e,#06,#90
db #07,#82,#08,#74,#09,#66,#0a,#58 ;...t.f.X
db #0b,#4a,#0c,#3c,#0d,#2e,#0e,#20 ;.J......
db #0f,#12,#10,#04,#11,#1e,#11,#38
db #11,#52,#11,#6c,#11,#86,#11,#a0 ;.R.l....
db #11,#92,#12,#84,#13,#76,#14,#18 ;.....v..
db #15,#da,#15,#5c,#16,#de,#16,#60
db #17,#02,#18,#64,#19,#c6,#19,#e8 ;...d....
db #1a,#ea,#1b,#cc,#1c,#8e,#1d,#10
db #1e,#52,#1f,#14,#21,#56,#22,#a8 ;.R...V..
db #22,#9a,#23,#1c,#25,#1e,#26,#c0
db #26,#62,#27,#c4,#27,#26,#28 ;.b.....
lab685C db #10
db #0c,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#00,#00
db #0a,#05,#00,#0a,#00,#00,#05,#0f
db #0f,#0a,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#0f,#0f,#0a,#4f,#cf ;......O.
db #8f,#8a,#4f,#4f,#cf,#8f,#8a,#0f ;..OO....
db #0f,#0a,#4f,#00,#05,#8a,#4f,#4f ;..O...OO
db #00,#05,#8a,#0f,#0f,#0a,#4f,#00 ;......O.
db #05,#8a,#4f,#4f,#00,#05,#8a,#0f ;..OO....
db #0f,#0a,#4f,#cf,#05,#8a,#4f,#4f ;..O...OO
db #cf,#05,#8a,#0f,#0f,#0a,#4f,#00 ;......O.
db #05,#8a,#4f,#4f,#00,#05,#8a,#0f ;..OO....
db #0f,#0a,#4f,#00,#05,#8a,#4f,#4f ;..O...OO
db #00,#05,#8a,#00,#0f,#0a,#4f,#05 ;......O.
db #00,#4f,#8a,#4f,#cf,#8f,#cf,#cf ;.O.O....
db #05,#0a,#00,#05,#00,#00,#00,#00
db #00,#00,#00,#00,#05,#0f,#00,#0f
db #0f,#00,#05,#00,#00,#00,#00,#00
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#10,#0c,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #00,#00,#0f,#00,#05,#0a,#00,#00
db #00,#00,#0f,#0a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#05,#0a
db #4f,#cf,#8a,#4f,#8a,#05,#cf,#8f ;O..O....
db #cf,#cf,#05,#0a,#4f,#00,#05,#8a ;....O...
db #4f,#4f,#00,#05,#8a,#00,#05,#0a ;OO......
db #4f,#00,#05,#8a,#4f,#4f,#00,#05 ;O...OO..
db #8a,#00,#05,#0a,#4f,#cf,#05,#cf ;....O...
db #cf,#05,#cf,#05,#cf,#8a,#0f,#0a
db #4f,#00,#05,#8a,#4f,#00,#05,#8f ;O...O...
db #8a,#00,#05,#0a,#4f,#00,#05,#8a ;....O...
db #4f,#00,#05,#8f,#8a,#00,#05,#0a ;O.......
db #4f,#05,#05,#8a,#4f,#4f,#cf,#05 ;O...OO..
db #cf,#cf,#05,#0a,#00,#05,#00,#00
db #00,#00,#00,#00,#00,#00,#05,#0f
db #00,#0f,#0f,#00,#05,#00,#00,#0a
db #00,#00,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#10,#10,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#00,#00
db #0a,#05,#00,#00,#0a,#00,#00,#05
db #00,#05,#0a,#00,#05,#0a,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#0a,#4f,#cf ;......O.
db #05,#8a,#4f,#4f,#05,#8f,#cf,#8a ;..OO....
db #4f,#8a,#05,#cf,#8a,#0a,#4f,#05 ;O.....O.
db #8f,#8a,#4f,#4f,#8f,#8a,#4f,#05 ;..OO..O.
db #8a,#4f,#4f,#00,#00,#0a,#4f,#05 ;.OO...O.
db #8f,#8a,#4f,#4f,#cf,#8a,#4f,#05 ;..OO..O.
db #8a,#4f,#4f,#00,#05,#0a,#4f,#05 ;.OO...O.
db #8f,#8a,#4f,#4f,#4f,#8a,#4f,#05 ;..OOO.O.
db #8a,#4f,#05,#cf,#00,#0a,#4f,#cf ;.O....O.
db #05,#8a,#4f,#4f,#05,#8a,#4f,#05 ;..OO..O.
db #8a,#4f,#00,#05,#8a,#0a,#4f,#00 ;.O....O.
db #05,#8a,#4f,#4f,#05,#8a,#4f,#05 ;..OO..O.
db #8a,#4f,#00,#05,#8a,#0a,#4f,#00 ;.O....O.
db #00,#4f,#8a,#4f,#05,#8a,#4f,#00 ;.O.O..O.
db #4f,#8a,#4f,#cf,#00,#0a,#00,#05 ;O.O.....
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#05,#0f,#00,#0f
db #0f,#00,#05,#00,#0a,#05,#00,#0f
db #00,#05,#00,#00,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#10,#10,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #00,#00,#0a,#05,#00,#00,#0a,#00
db #00,#05,#00,#05,#0a,#00,#05,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#0a
db #98,#30,#44,#20,#98,#98,#44,#64 ;..D...Dd
db #30,#20,#98,#20,#44,#30,#20,#0a ;....D...
db #98,#44,#64,#20,#98,#98,#64,#20 ;.Dd...d.
db #98,#44,#20,#98,#98,#00,#00,#0a ;.D......
db #98,#44,#64,#20,#98,#98,#30,#20 ;.Dd.....
db #98,#44,#20,#98,#98,#00,#05,#0a ;.D......
db #98,#44,#64,#20,#98,#98,#98,#20 ;.Dd.....
db #98,#44,#20,#98,#44,#30,#00,#0a ;.D..D...
db #98,#30,#44,#20,#98,#98,#44,#20 ;..D...D.
db #98,#44,#20,#98,#00,#44,#20,#0a ;.D...D..
db #98,#00,#44,#20,#98,#98,#44,#20 ;..D...D.
db #98,#44,#20,#98,#00,#44,#20,#0a ;.D...D..
db #98,#00,#00,#98,#20,#98,#44,#20 ;......D.
db #98,#00,#98,#20,#98,#30,#00,#0a
db #00,#05,#0a,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#05,#0f
db #00,#0f,#0f,#00,#05,#00,#0a,#05
db #00,#0f,#00,#05,#00,#00,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#18
db #1c,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cb,#8f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#4b,#8f,#0f,#cf ;....K...
db #0f,#4f,#cf,#cf,#8f,#4f,#8f,#0f ;.O...O..
db #cf,#0f,#cf,#0f,#cf,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#4f,#8f ;......O.
db #4b,#8f,#4f,#cf,#8f,#5b,#cf,#f3 ;K.O.....
db #cf,#4f,#cf,#4f,#cf,#0f,#cf,#0f ;.O.O....
db #cf,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#cf,#e7,#4b,#8f,#cf,#f3 ;....K...
db #cf,#5b,#cf,#f3,#cf,#4f,#cf,#cf ;.....O..
db #cf,#0f,#cf,#0f,#cf,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#db,#cf
db #4b,#8f,#cf,#f3,#cf,#0f,#cf,#cf ;K.......
db #db,#4f,#cf,#cf,#cf,#0f,#e7,#cf ;.O......
db #db,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#e7,#db,#4b,#8f,#cf,#cf ;....K...
db #cf,#0f,#cf,#e7,#db,#4f,#db,#db ;.....O..
db #cf,#0f,#f3,#cf,#f3,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#5b,#a7
db #4b,#8f,#cf,#f3,#cf,#0f,#cf,#f3 ;K.......
db #cf,#4f,#db,#f3,#cf,#0f,#5b,#cf ;.O......
db #a7,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#4b,#8f,#cf,#f3 ;....K...
db #cf,#4f,#cf,#5b,#cf,#4f,#8f,#a7 ;.O...O..
db #cf,#0f,#4f,#cf,#8f,#0f,#0f,#0f ;..O.....
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #4b,#8f,#f3,#0f,#f3,#5b,#f3,#0f ;K.......
db #f3,#5b,#a7,#0f,#f3,#0f,#5b,#f3
db #a7,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#4b,#8f,#f3,#0f ;....K...
db #f3,#5b,#f3,#0f,#f3,#5b,#a7,#0f
db #f3,#0f,#5b,#f3,#a7,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #4b,#8f,#0f,#0f,#0f,#0f,#0f,#0f ;K.......
db #4f,#8f,#0f,#cf,#0f,#4f,#cf,#0f ;O....O..
db #0f,#cf,#0f,#cf,#4f,#cf,#cf,#cf ;....O...
db #0f,#4f,#cf,#8f,#4b,#8f,#0f,#0f ;.O..K...
db #0f,#0f,#0f,#0f,#4f,#cf,#4f,#cf ;....O.O.
db #0f,#cf,#e7,#8f,#0f,#cf,#0f,#cf
db #5b,#cf,#f3,#e7,#0f,#cf,#f3,#cf
db #4b,#8f,#0f,#0f,#0f,#0f,#0f,#0f ;K.......
db #4f,#cf,#cf,#cf,#4f,#db,#f3,#cf ;O...O...
db #0f,#cf,#0f,#cf,#5b,#cf,#e7,#f3
db #0f,#e7,#f3,#f3,#4b,#8f,#0f,#0f ;....K...
db #0f,#0f,#0f,#0f,#4f,#cf,#cf,#cf ;....O...
db #4f,#db,#5b,#cf,#0f,#cf,#0f,#cf ;O.......
db #0f,#cf,#cf,#5b,#0f,#e7,#cf,#db
db #4b,#8f,#4f,#8f,#0f,#0f,#0f,#0f ;K.O.....
db #4f,#db,#db,#cf,#4f,#8f,#0f,#cf ;O...O...
db #0f,#cf,#cf,#cf,#0f,#cf,#e7,#0f
db #0f,#5b,#f3,#cf,#4b,#8f,#cf,#e7 ;....K...
db #0f,#0f,#0f,#0f,#4f,#db,#f3,#cf ;....O...
db #5b,#cf,#4f,#db,#0f,#e7,#cf,#db ;..O.....
db #0f,#cf,#f3,#4f,#0f,#cf,#f3,#cf ;...O....
db #4b,#8f,#db,#cf,#0f,#0f,#0f,#0f ;K.......
db #4f,#8f,#a7,#cf,#5b,#e7,#cf,#f3 ;O.......
db #0f,#f3,#cf,#f3,#4f,#cf,#cf,#cf ;....O...
db #0f,#e7,#cf,#db,#4b,#8f,#e7,#db ;....K...
db #0f,#0f,#0f,#0f,#5b,#a7,#0f,#f3
db #0f,#f3,#f3,#a7,#0f,#5b,#f3,#a7
db #5b,#f3,#f3,#f3,#0f,#f3,#f3,#f3
db #4b,#8f,#5b,#a7,#0f,#0f,#0f,#0f ;K.......
db #5b,#a7,#0f,#f3,#0f,#5b,#f3,#0f
db #0f,#0f,#f3,#0f,#5b,#f3,#f3,#f3
db #0f,#5b,#f3,#a7,#4b,#8f,#0f,#0f ;....K...
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #4b,#cb,#c3,#c3,#c3,#c3,#c3,#c3 ;K.......
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#10,#04,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #4f,#8f,#0f,#8f,#cf,#45,#0f,#8f ;O....E..
db #8a,#cf,#0f,#8f,#45,#8a,#0f,#8f ;....E...
db #0a,#05,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#0f,#0f,#4b,#8f ;......K.
db #0f,#0f,#4b,#10,#02,#cf,#cf,#cf ;..K.....
db #cf,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#4f,#0f,#0a,#0f,#0f,#0f,#0f ;.O......
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#c3,#c3,#c3,#c3,#10,#04,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cb,#0f
db #0f,#0f,#4b,#0f,#0f,#0f,#4b,#0f ;..K...K.
db #0f,#0f,#4b,#0f,#4f,#8f,#4b,#0f ;..K.O.K.
db #8a,#cf,#4b,#0f,#cf,#45,#4b,#0f ;..K..EK.
db #45,#8a,#4b,#0f,#0a,#05,#4b,#0f ;E.K...K.
db #0f,#0f,#4b,#0f,#0f,#0f,#4b,#0f ;..K...K.
db #0f,#0f,#4b,#0f,#0f,#0f,#4b,#87 ;..K...K.
db #0f,#0f,#4b,#8f,#0f,#0f,#4b,#08 ;..K...K.
db #04,#8f,#0f,#0f,#4b,#8f,#0f,#0f ;....K...
db #4b,#8f,#0f,#0f,#4b,#8f,#4f,#0f ;K...K.O.
db #4b,#8f,#0a,#0f,#4b,#8f,#0f,#0f ;K...K...
db #4b,#8f,#0f,#0f,#4b,#8f,#0f,#0f ;K...K...
db #4b,#08,#04,#8f,#0f,#0f,#0f,#8f ;K.......
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #4f,#0f,#0f,#8f,#0a,#0f,#0f,#8f ;O.......
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#08,#04,#0f,#0f,#0f
db #4b,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;K...K...
db #4b,#0f,#4f,#0f,#4b,#0f,#0a,#0f ;K.O.K...
db #4b,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;K...K...
db #4b,#0f,#0f,#0f,#4b,#10,#04,#8f ;K...K...
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#8f
db #0f,#0f,#0f,#8f,#4f,#8f,#0f,#8f ;....O...
db #8a,#cf,#0f,#8f,#cf,#45,#0f,#8f ;.....E..
db #45,#8a,#0f,#8f,#0a,#05,#0f,#8f ;E.......
db #0f,#0f,#0f,#8f,#0f,#0f,#0f,#cb
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#10
db #04,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;....K...
db #4b,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;K...K...
db #4b,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;K...K...
db #4b,#0f,#0f,#0f,#4b,#0f,#4f,#8f ;K...K.O.
db #4b,#0f,#cf,#45,#4b,#0f,#8a,#cf ;K..EK...
db #4b,#0f,#45,#8a,#4b,#0f,#0a,#05 ;K.E.K...
db #4b,#0f,#0f,#0f,#4b,#0f,#0f,#0f ;K...K...
db #4b,#c3,#c3,#c3,#c3,#c3,#c3,#c3 ;K.......
db #c3,#38,#01,#cf,#cf,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#c3,#c3,#18,#01,#cf,#cf,#8f
db #8f,#cf,#8a,#8f,#8f,#8f,#8f,#8f
db #8f,#8f,#8f,#8f,#8f,#8f,#8f,#cf
db #8a,#8f,#8f,#cb,#c3,#18,#01,#cf
db #cf,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#c3,#c3,#18
db #01,#cf,#cb,#4b,#4b,#cb,#41,#4b ;...KK.AK
db #4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b ;KKKKKKKK
db #4b,#4b,#4b,#cb,#41,#4b,#4b,#c3 ;KKK.AKK.
db #c3,#28,#01,#cf,#cf,#8f,#8f,#cf
db #8a,#8f,#8f,#8f,#8f,#8f,#8f,#8f
db #8f,#8f,#8f,#8f,#8f,#8f,#8f,#8f
db #8f,#8f,#8f,#8f,#8f,#8f,#8f,#8f
db #8f,#8f,#8f,#8f,#8f,#cf,#8a,#8f
db #8f,#cb,#c3,#28,#01,#cf,#cf,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#c3,#c3,#28,#01,#cf
db #cb,#4b,#4b,#cb,#41,#4b,#4b,#4b ;.KK.AKKK
db #4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b ;KKKKKKKK
db #4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b ;KKKKKKKK
db #4b,#4b,#4b,#4b,#4b,#4b,#4b,#4b ;KKKKKKKK
db #4b,#cb,#41,#4b,#4b,#c3,#c3 ;K.AKK..
lab711C db #0
db #00,#c2,#00,#84,#01,#86,#02,#88
db #03,#2a,#06,#6c,#06,#8e,#06,#d0 ;...l....
db #06,#f2,#06,#14,#07,#36,#07,#78 ;.......x
db #07,#ba,#07,#f4,#07,#0e,#08,#28
db #08,#42,#08,#6c,#08,#96,#08,#00 ;.B.l....
db #00,#00,#00
lab7148 jr lab71B2
lab714A jr lab7152
data714c db #18
db #60
lab714E jr lab71C8
data7150 db #0
lab7151 db #2
lab7152 ld hl,(lab0064)
    di
    ld (lab730F),hl
lab7159 ld (data730d),hl
    ld hl,(data730d)
    ld iy,lab7311
    ld b,#3
lab7165 ld (iy+0),#0
    ld (iy+1),#0
    ld (iy+8),#0
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,e
    and d
    cp #ff
    jr nz,lab718B
    ld a,(data7150)
    or a
    ld a,#0
    ld (data7150),a
    jr nz,lab71B2
    ld hl,(lab730F)
    jr lab7159
lab718B ld (iy+2),e
    ld (iy+3),d
    ld de,lab000C
    add iy,de
    djnz lab7165
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (data730d),hl
    ld hl,lab7335
    ex de,hl
    ld bc,lab001E
    ldir
    ld hl,data7214
    ld (lab7522),hl
    ld a,#28
    jr lab71B4
lab71B2 ld a,#18
lab71B4 di
    ld (lab721E),a
    ld a,#7
    ld c,#b8
    call lab72EF
    ld a,#6
    ld c,#1f
    call lab72EF
    jr lab71F5
lab71C8 ld a,(lab0064)
    cp #2
    jr z,lab71DD
    jr c,lab71D7
    ld iy,lab7329
    jr lab71E1
lab71D7 ld iy,lab7311
    jr lab71E1
lab71DD ld iy,lab731D
lab71E1 call lab720B
    ret nz
    ld hl,(lab0066)
    di
    ld (iy+8),#1
    ld (iy+10),l
    ld (iy+11),h
    ei
    ret 
lab71F5 ld a,#8
    call lab7206
    ld a,#9
    call lab7206
    ld a,#a
    call lab7206
    ei
    ret 
lab7206 ld c,#0
    jp lab72EF
lab720B ld l,(iy+2)
    ld h,(iy+3)
    ld a,h
    or l
    ret 
data7214 db #fd
db #21,#11,#73,#06,#03,#c5,#cd,#0b ;..s.....
db #72 ;r
lab721E db #18
db #4a,#fd,#7e,#01,#b7,#28,#05,#fd ;J.......
db #35,#01,#18,#29,#7e,#3d,#fd,#77 ;.......w
db #01,#fd,#36,#00,#ff,#23,#fd,#56 ;.......V
db #06,#cd,#cb,#72,#7e,#fe,#ff,#20 ;...r....
db #0e,#c1,#af,#32,#04,#72,#cd,#5c ;.....r..
db #71,#3e,#fb,#32,#04,#72,#c9,#fd ;q....r..
db #75,#02,#fd,#74,#03,#fd,#7e,#00 ;u..t....
db #fe,#09,#28,#03,#fd,#34,#00,#cd
db #d7,#72,#11,#0c,#00,#fd,#19,#c1 ;.r......
db #10,#b1,#c9,#fd,#7e,#08,#b7,#28
db #f1,#fd,#7e,#09,#b7,#28,#05,#fd
db #35,#09,#18,#e6,#3a,#51,#71,#fd ;.....Qq.
db #77,#09,#fd,#6e,#0a,#fd,#66,#0b ;w..n..f.
db #7e,#fe,#ff,#20,#08,#fd,#36,#08
db #00,#0e,#00,#18,#32,#57,#cb,#52 ;.....W.R
db #28,#04,#0e,#a8,#18,#02,#0e,#b8
db #3e,#07,#cd,#ef,#72,#23,#4e,#23 ;....r.N.
db #fd,#75,#0a,#fd,#74,#0b,#fd,#7e ;.u..t...
db #06,#f5,#cd,#ef,#72,#7a,#e6,#03 ;....rz..
db #4f,#f1,#3c,#cd,#ef,#72,#4a,#cb ;O....rJ.
db #39,#cb,#39,#cb,#39,#cb,#39,#cd
db #ec,#72,#18,#96,#7a,#4e,#23,#cd ;.r..zN..
db #ef,#72,#7a,#3c,#4e,#23,#18,#18 ;.rz.N...
db #0e,#00,#2b,#7e,#2b,#b6,#28,#0d
db #fd,#5e,#00,#16,#00,#fd,#6e,#04 ;......n.
db #fd,#66,#05,#19,#4e,#fd,#7e,#07 ;.f..N...
lab72EF ld b,#f4
    out (c),a
    ld b,#f6
    in a,(c)
    or #c0
    out (c),a
    and #3f
    out (c),a
    ld b,#f4
    out (c),c
    ld b,#f6
    ld c,a
    or #80
    out (c),a
    out (c),c
    ret 
data730d db #ad
db #2a
lab730F db #9d
db #2a
lab7311 db #4
db #01,#aa,#2b,#35,#73,#00,#08,#00 ;....s...
db #00,#00,#00
lab731D db #0
db #00,#00,#00,#3f,#73,#02,#09,#00 ;....s...
db #02,#93,#2d
lab7329 db #4
db #01,#3a,#2c,#49,#73,#04,#0a,#00 ;...Is...
db #00,#00,#00
lab7335 db #f
db #0e,#0d,#0c,#0b,#0a,#09,#08,#07
db #06,#0f,#0e,#0d,#0c,#0b,#0a,#09
db #08,#07,#06,#0f,#0e,#0d,#0c,#0b
db #0a,#09,#08,#07,#06,#c9,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab73A0 db #1
lab73A1 db #0
lab73A2 db #0
lab73A3 db #a
db #80,#80,#40,#20,#10,#80,#40
lab73AB db #0
db #7c
lab73AD db #20
db #7b,#a8,#89
lab73B1 db #14
db #14,#00,#0b,#1e,#0a,#16,#12,#06
db #13,#04,#15,#17,#0e,#14,#1c,#0c
db #14,#14,#00,#0b,#1e,#0a,#16,#12
db #06,#13,#04,#15,#17,#0e,#14,#1c
db #0c,#14,#04,#15,#1c,#18,#1d,#0c
db #05,#0d,#16,#06,#17,#1e,#00,#1f
db #0e,#07,#0f,#12,#02,#13,#1a,#19
db #1b,#0a,#03,#0b,#f8,#bf,#4e,#01 ;......N.
db #a2,#b9,#85,#7f,#8e,#f2,#6f,#de ;......o.
db #0d,#00,#0c,#30,#01,#20,#02,#2a
db #06,#18,#1e,#05,#21,#fa,#73,#06 ;......s.
db #bc,#4e,#23,#ed,#49,#04,#4e,#23 ;.N..I.N.
db #ed,#49,#1d,#20,#f2,#c9 ;.I....
lab7418 ld l,a
    ld h,#0
lab741B ld de,lab7B70
    add hl,hl
    add hl,de
    push hl
    pop ix
    ret 
data7424 db #21
db #65,#74,#18,#03 ;et..
lab7429 ld hl,lab7459
    ld (lab7452+1),hl
    ld a,(lab0064)
    call lab7418
    ld a,(lab0065)
    ld (lab744E+1),a
    ld de,(lab0066)
    ld a,(lab006C)
    ld b,a
lab7443 push bc
    ld l,(ix+0)
    inc ix
    ld h,(ix+0)
    inc ix
lab744E ld bc,lab001A
    add hl,bc
lab7452 call lab7459
    pop bc
    djnz lab7443
    ret 
lab7459 ld a,(lab006E)
    ld b,a
lab745D ld a,(de)
    nop
    ld (hl),a
    inc de
    inc hl
    djnz lab745D
    ret 
data7465 db #3a
db #6e,#00,#36,#00,#23,#3d,#20,#fa ;n.......
db #c9,#f3,#e1,#ed,#73,#ee,#73,#e5 ;....s.s.
db #01,#0a,#00,#21,#f6,#bf,#11,#f0
db #73,#ed,#b0,#21,#11,#75,#22,#39 ;s....u..
db #00,#2a,#17,#bd,#cb,#bc,#cb,#b4
db #22,#c2,#74,#3a,#a2,#73,#f5,#cd ;..t..s..
db #0e,#bc,#d9,#79,#f6,#8c,#4f,#ed ;...y..O.
db #49,#d9,#08,#37,#08,#f1,#cd,#7b ;I.......
db #78,#21,#00,#00,#22,#60,#00,#cd ;x.......
db #fe,#74,#21,#2e,#01,#01,#05,#00 ;.t......
db #c3,#8e,#75 ;..u
lab74B9 di
    ld hl,data74d5
    ld c,#fc
    di
    exx
    ld de,lab061B+1
    res 2,c
    call lab74CF
    di
    exx
    set 2,c
    jr lab74D0
lab74CF push de
lab74D0 out (c),c
    exx
    ei
    ret 
data74d5 db #f3
db #cd,#07,#75,#01,#0a,#00,#21,#f0 ;..u.....
db #73,#11,#f6,#bf,#ed,#b0,#ed,#7b ;s.......
db #ee,#73,#11,#40,#00,#21,#7f,#ab ;.s......
db #cd,#cb,#bc,#fb,#c9,#01,#00,#05
db #21,#00,#ac,#ed,#5b,#af,#73,#c9 ;......s.
db #cd,#f3,#74,#7a,#b3,#c8,#ed,#b0 ;..tz....
db #c9,#cd,#f3,#74,#7a,#b3,#c8,#eb ;...tz...
db #ed,#b0,#c9,#f3,#c5,#f5,#06,#f5
db #ed,#78,#1f,#30,#18,#e5,#d5,#dd ;.x......
db #e5,#fd,#e5,#cd
lab7522 db #14
db #72,#cd,#37,#75,#cd,#4e,#75,#cd ;r..u.Nu.
db #54,#75,#fd,#e1,#dd,#e1,#d1,#e1 ;Tu......
db #f1,#c1,#fb,#c9,#2a,#2e,#01,#23
db #22,#2e,#01,#7c,#b5,#20,#04,#21
db #30,#01,#34,#2a,#2c,#01,#23,#22
db #2c,#01,#c9,#cd,#02,#76,#c3,#3a ;.....v..
db #76,#21,#32,#01,#34,#7e,#fe,#32 ;v.......
db #d8,#36,#00,#2b,#7e,#3c,#e6,#01
db #77,#20,#05,#11,#b1,#73,#18,#03 ;w....s..
db #11,#c2,#73,#c3,#dd,#75 ;..s..u
lab7571 call lab7588
    ld hl,labC000
    ld bc,lab4000
    call lab758E
    inc hl
    ld (lab0060),hl
lab7581 ld a,#13
    ld (lab75F0),a
    jr lab75A0
lab7588 xor a
    ld (lab75F0),a
    jr lab75A0
lab758E ld (hl),#0
    push hl
    pop de
    inc de
    dec bc
    ldir
    ret 
data7597 db #cd
db #d4,#75,#32,#c2,#73,#32,#b1,#73 ;.u..s..s
lab75A0 ld de,lab73B1
    jr lab75DD
data75a5 db #cd
db #d4,#75,#32,#c2,#73,#7b,#cd,#d4 ;.u..s...
db #75,#18,#ec,#06,#00,#4b,#21,#b2 ;u....K..
db #73,#09,#e5,#cd,#d4,#75,#e1,#77 ;s....u.w
db #11,#11,#00,#19,#c9,#cd,#b1,#75 ;.......u
db #77,#18,#d7,#cd,#d4,#75,#f5,#7a ;w....u.z
db #cd,#b1,#75,#f1,#18,#f2,#21,#d3 ;..u.....
db #73,#4f,#06,#00,#09,#7e,#c9 ;sO.....
lab75DD ld b,#7f
    ld c,#0
    set 4,c
    out (c),c
    ld a,(de)
    inc de
    set 6,a
    out (c),a
    ld c,#0
lab75ED out (c),c
    ld a,(de)
lab75F0 inc de
    set 6,a
    out (c),a
    inc c
    ld a,c
    cp #10
    jr nz,lab75ED
    ret 
lab75FC di
    call lab7602
    ei
    ret 
lab7602 ld bc,#f40e
    out (c),c
    ld b,#f6
    in a,(c)
    and #30
    ld c,a
    or #c0
    out (c),a
    out (c),c
    inc b
    ld a,#92
    out (c),a
    push bc
    ld hl,lab00CC
    set 6,c
lab761F ld b,#f6
    out (c),c
    ld b,#f4
    in a,(c)
    ld (hl),a
    inc hl
    inc c
    ld a,c
    and #f
    cp #a
    jr nz,lab761F
    pop bc
    ld a,#82
    out (c),a
    dec b
    out (c),c
    ret 
lab763A ld hl,lab00CC
    ld b,#a
lab763F ld a,(hl)
    cp #ff
    jr z,lab7687
    ld c,#0
    bit 0,a
    jr z,lab7669
    inc c
    bit 1,a
    jr z,lab7669
    inc c
    bit 2,a
    jr z,lab7669
    inc c
    bit 3,a
    jr z,lab7669
    inc c
    bit 4,a
    jr z,lab7669
    inc c
    bit 5,a
    jr z,lab7669
    inc c
    bit 6,a
    jr z,lab7669
    inc c
lab7669 ld a,#a
    sub b
    sla a
    sla a
    sla a
    add a,c
    ld (lab0062),a
    ld e,a
    ld d,#0
    ld hl,(lab73AD)
    add hl,de
    ld a,(hl)
    cp #0
    jp z,lab74B9
lab7683 ld (lab0063),a
    ret 
lab7687 inc hl
    djnz lab763F
    ld (lab0062),a
    jr lab7683
lab768F ld l,a
    srl l
    srl l
    srl l
    ld bc,lab00CC
    ld h,#0
    add hl,bc
    and #7
    rla 
    rla 
    rla 
    or #46
    ld (lab76A6+1),a
lab76A6 bit 1,(hl)
    ret 
lab76A9 call lab768F
    ld h,#0
    jr z,lab76B4
    ld a,#ff
    ld l,a
    ret 
lab76B4 xor a
    ld l,a
    ret 
lab76B7 push de
    ld hl,(lab012C)
    ld d,h
    ld e,l
    add hl,hl
    add hl,hl
    add hl,de
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,de
    res 7,h
    ld (lab012C),hl
    ld a,l
    pop de
    ret 
data76cc db #ed
db #5b,#64,#00,#2a,#66,#00,#d5,#af ;.d..f...
db #ed,#52,#e5,#c1,#21,#ff,#7f,#cd ;.R......
db #f2,#77,#e5,#cd,#b7,#76,#c1,#cd ;.w...v..
db #f2,#77,#d1,#19,#22,#64,#00,#c9 ;.w...d..
lab76ED ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ex de,hl
    ret 
data76f4 db #fe
db #30,#38,#65,#fe,#3a,#38,#22,#fe ;..e.....
db #41,#38,#5d,#fe,#47,#30,#59,#f5 ;A...G.Y.
db #cd,#c0,#79,#f1,#d6,#07,#18,#6a ;..y....j
db #fe,#26,#20,#05,#cd,#c0,#79,#18 ;......y.
db #1a,#fe,#30,#38,#43,#fe,#3a,#30 ;....C...
db #3f,#f5,#cd,#c0,#79,#f1,#d6,#30 ;....y...
db #18,#50,#0e,#0a,#3e,#05,#11,#0d ;.P......
db #77,#18,#11,#0e,#10,#3e,#04,#11 ;w.......
db #f4,#76,#18,#08,#0e,#00,#3a,#64 ;.v.....d
db #00,#11,#72,#77,#ed,#53,#70,#77 ;..rw.Spw
db #32,#7e,#77,#79,#32,#ad,#77,#21 ;..wy..w.
db #d7,#00,#06,#00,#3e,#2d,#cd,#c0
db #79,#3e,#08,#cd,#c0,#79,#36,#ff ;y....y..
db #cd,#38,#78,#fe,#2d,#20,#03,#05 ;..x.....
db #18,#0b,#fe,#0d,#28,#16,#fe,#10
db #28,#54,#c3,#0d,#77,#f5,#cd,#c0 ;.T..w...
db #79,#f1,#77,#23,#36,#ff,#04,#78 ;y.w....x
db #fe,#05,#38,#d0,#3e,#20,#cd,#c0
db #79,#3a,#ad,#77,#b7,#20,#05,#78 ;y..w...x
db #32,#64,#00,#c9,#11,#d7,#00,#21 ;.d......
db #00,#00,#3e,#c9,#32,#ba,#77,#1a ;......w.
db #fe,#2d,#20,#06,#af,#32,#ba,#77 ;.......w
db #18,#10,#fe,#ff,#28,#0f,#f5,#01
db #0a,#00,#cd,#db,#77,#f1,#4f,#06 ;....w.O.
db #00,#09,#13,#18,#e2,#c9
lab77BB ld a,h
    cpl 
    ld h,a
    ld a,l
    cpl 
    ld l,a
    inc hl
    ret 
data77c3 db #78
db #b7,#28,#8a,#2b,#05,#3e,#20,#cd
db #c0,#79,#3e,#08,#cd,#c0,#79,#3e ;.y....y.
db #10,#cd,#c0,#79,#c3,#51,#77 ;...y.Qw
lab77DB push de
    ld de,data0000
    ex de,hl
    ld a,#10
lab77E2 srl b
    rr c
    jr nc,lab77E9
    add hl,de
lab77E9 sla e
    rl d
    dec a
    jr nz,lab77E2
    pop de
    ret 
data77f2 db #d5
db #11,#00,#00,#eb,#3e,#10,#cb,#13
db #cb,#12,#ed,#6a,#ed,#42,#30,#01 ;...j.B..
db #09,#3f,#3d,#20,#f1,#cb,#13,#cb
db #12,#22,#33,#01,#eb,#d1,#c9
lab7812 ld l,a
    ld b,#8
    xor a
lab7816 srl c
    jr nc,lab781B
    add a,l
lab781B sla l
    djnz lab7816
    ret 
data7820 db #6f
db #af,#06,#08,#cb,#15,#8f,#99,#30
db #01,#81,#3f,#10,#f6,#cb,#15,#32
db #33,#01,#7d,#c9
lab7835 or a
    jr nz,lab7853
    push hl
    push bc
    push de
lab783B call lab785F
    ld a,(lab0063)
    cp #ff
    jr nz,lab783B
lab7845 call lab785F
    ld a,(lab0063)
    cp #ff
    jr z,lab7845
    pop de
    pop bc
    pop hl
    ret 
lab7853 ld b,a
lab7854 ld hl,lab0361+1
lab7857 dec hl
    ld a,h
    or l
    jr nz,lab7857
    djnz lab7854
    ret 
lab785F ld a,#5
    call lab7853
    call lab75FC
    jp lab763A
data786a db #32
db #a2,#73,#6f,#f3,#d9,#57,#79,#e6 ;.so..Wy.
db #fc,#b2,#4f,#ed,#49,#d9,#fb,#7d ;..O.I...
db #c9,#01,#28,#0c,#38,#14,#21,#00
db #00,#11,#6c,#7a,#3e,#50,#18,#12 ;..lz.P..
db #21,#87,#00,#11,#78,#7a,#3e,#28 ;....xz..
db #18,#08,#21,#87,#87,#11,#97,#7a ;.......z
db #3e,#14,#cd,#a4,#78,#cd,#71,#75 ;....x.qu
db #c9,#22,#0a,#7a,#ed,#53,#12,#7a ;...z.S.z
db #32,#19,#7a,#32,#5d,#7a,#c9,#6f ;..z..z.o
db #3a,#a2,#73,#fe,#01,#7d,#32,#a4 ;..s.....
db #73,#28,#03,#38,#1a,#c9,#11,#a5 ;s.......
db #73,#af,#cb,#45,#28,#02,#cb,#ff ;s..E....
db #cb,#4d,#28,#02,#cb,#df,#06,#04 ;.M......
db #12,#13,#cb,#3f,#10,#fa,#c9,#11
db #a9,#73,#af,#cb,#45,#28,#02,#cb ;.s..E...
db #ff,#cb,#4d,#28,#02,#cb,#df,#cb ;..M.....
db #55,#28,#02,#cb,#ef,#cb,#5d,#28 ;U.......
db #02,#cb,#cf,#12,#13,#cb,#3f,#12
db #c9
lab78FC db #0
lab78FD ld l,a
    ld h,#0
lab7900 xor a
    ld (lab78FC),a
    bit 7,h
lab7906 jr lab7910
data7908 db #3e
db #2d,#32,#fc,#78,#cd,#bb,#77 ;...x..w
lab7910 ld a,(lab73A0)
    cp #1
    jr c,lab791F
    jr z,lab7929
    ld bc,data799b
    xor a
    jr lab792D
lab791F call lab7974
    ld bc,data798d
    ld a,#c9
    jr lab792D
lab7929 ld bc,lab7997
    xor a
lab792D ld (lab798A+1),bc
    ld (lab7973),a
    ld a,(lab73A1)
    or a
    jr z,lab7955
    ld a,h
    call lab79A3
    call lab798A
    ld a,h
    call lab79B1
    call lab798A
    ld a,l
    call lab79A3
    call lab798A
    ld a,l
    call lab79B1
    jr lab7970
lab7955 ld de,#d8f0
    call lab797B
    ld de,#fc18
    call lab797B
    ld de,#ff9c
    call lab797B
    ld de,#fff6
    call lab797B
    ld a,l
    add a,#30
lab7970 call lab79C0
lab7973 nop
lab7974 ld a,(lab78FC)
    or a
    ret z
    jr lab79C0
lab797B ld c,#2f
lab797D inc c
    add hl,de
    jr c,lab797D
    ex de,hl
    ld a,d
    call lab77BB
    cpl 
    add hl,de
    ld d,a
    ld a,c
lab798A jp lab7997
data798d db #fe
db #30,#c8,#01,#97,#79,#ed,#43,#8b ;....y.C.
db #79 ;y
lab7997 call lab79C0
    ret 
data799b db #fe
db #30,#20,#f1,#3e,#20,#18,#f4
lab79A3 and #f0
    rra 
    rra 
    rra 
    rra 
lab79A9 add a,#30
    cp #3a
    ret c
    add a,#7
    ret 
lab79B1 and #f
    jr lab79A9
lab79B5 pop hl
    ld a,(hl)
    inc hl
    push hl
    or a
    ret z
    call lab79C0
    jr lab79B5
lab79C0 push bc
    push de
    push hl
    call lab79CA
    pop hl
    pop de
    pop bc
    ret 
lab79CA cp #2d
    jr nc,lab79F2
    cp #20
    jr z,lab79FA
    cp #25
    jr z,lab79EE
    cp #d
    jp z,lab7A41
    cp #8
    jp z,lab7A56
    cp #9
    jp z,lab7A71
    cp #10
    jp z,lab7A85
    ld a,#34
    jr lab79FA
lab79EE ld a,#21
    jr lab79FA
lab79F2 sub #b
    cp #50
    jr c,lab79FA
    sub #20
lab79FA ld e,a
    ld d,#0
    or a
    ld b,#4
lab7A00 rl e
    rl d
    djnz lab7A00
    ld hl,(lab73AB)
    add hl,de
    dec h
    push hl
    ld a,(lab0060)
    sla a
    sla a
    sla a
    ld l,a
    ld h,#0
    ld de,lab7B70
    add hl,hl
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld a,(lab0061)
    add a,a
    ld l,a
    ld h,#0
    add hl,de
    pop de
    ld b,#8
lab7A2B call lab7A8F
    inc hl
    call lab7A8F
    dec hl
    ld a,h
    add a,#8
    ld h,a
    djnz lab7A2B
    ld a,(lab0061)
    inc a
    cp #28
    jr c,lab7A52
lab7A41 xor a
    ld (lab0061),a
    ld a,(lab0060)
    inc a
    cp #19
    jr c,lab7A4E
    xor a
lab7A4E ld (lab0060),a
    ret 
lab7A52 ld (lab0061),a
    ret 
lab7A56 ld a,(lab0061)
    or a
    jr nz,lab7A6B
    ld a,#28
    ld (lab0061),a
    ld a,(lab0060)
    or a
    jr nz,lab7A6E
    ld a,#18
    jr lab7A4E
lab7A6B dec a
    jr lab7A52
lab7A6E dec a
    jr lab7A4E
lab7A71 ld a,(lab0061)
    or a
    ret z
    ld b,a
    ld a,(lab73A3)
    ld c,a
lab7A7B cp b
    jr nc,lab7A52
    add a,c
    cp #28
    jr c,lab7A7B
    jr lab7A41
lab7A85 call lab7A56
    ld a,#20
    call lab79CA
    jr lab7A56
lab7A8F ld a,(de)
    nop
    ld (hl),a
    inc de
    ret 
data7a94 db #2a
db #ab,#73,#24,#01,#00,#03,#dd,#21 ;.s......
db #a9,#73,#7e,#1e,#00,#57,#e6,#aa ;.s...W..
db #28,#03,#dd,#5e,#00,#7a,#e6,#55 ;.....z.U
db #28,#06,#dd,#7e,#01,#b3,#18,#01
db #7b,#77,#23,#0b,#78,#b1,#20,#e2 ;.w..x...
db #c9,#c9,#4e,#23,#e5,#c5,#3e,#02 ;..N.....
db #f5,#06,#04,#21,#a5,#73,#af,#cb ;.....s..
db #01,#30,#01,#b6,#23,#10,#f8,#12
db #13,#f1,#3d,#20,#eb,#c1,#e1,#10
db #e1,#c9,#4e,#23,#e5,#c5,#3e,#04 ;..N.....
db #f5,#06,#02,#21,#a9,#73,#af,#cb ;.....s..
db #01,#30,#01,#b6,#23,#10,#f8,#12
db #13,#f1,#3d,#20,#eb,#c1,#e1,#10
db #e1,#c9,#1a,#00,#77,#13,#c9,#00 ;....w...
db #00,#00,#00,#00,#00,#00,#00
lab7B0C db #40
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab7B16 db #0
lab7B17 db #1b
db #22,#43,#09,#45,#2f ;.C.E.
lab7B1D db #42
lab7B1E db #2c
db #45,#2f,#01,#0a,#39,#36,#33,#0d ;E.......
db #26,#08,#30,#37,#38,#35,#31,#32
db #30,#10,#2a,#0d,#2b,#34,#3f,#5c
db #3f,#5e,#20,#40,#50,#3b,#4e,#2f ;....P.N.
db #20,#30,#39,#4f,#49,#4c,#4b,#4d ;...OILKM
db #2c,#38,#37,#55,#59,#48,#4a,#4e ;...UYHJN
db #20,#36,#35,#52,#54,#47,#46,#42 ;...RTGFB
db #56,#34,#33,#45,#57,#53,#44,#43 ;V..EWSDC
db #58,#31,#32,#05,#51,#09,#41,#3f ;X...Q.A.
db #5a,#0b,#0a,#08,#01,#30,#ff,#3f ;Z.......
db #10
lab7B70 db #0
db #c0,#00,#c8,#00,#d0,#00,#d8,#00
db #e0,#00,#e8,#00,#f0,#00,#f8,#50 ;.......P
db #c0,#50,#c8,#50,#d0,#50,#d8,#50 ;.P.P.P.P
db #e0,#50,#e8,#50,#f0,#50,#f8,#a0 ;.P.P.P..
db #c0,#a0,#c8,#a0,#d0,#a0,#d8,#a0
db #e0,#a0,#e8,#a0,#f0,#a0,#f8,#f0
db #c0,#f0,#c8,#f0,#d0,#f0,#d8,#f0
db #e0,#f0,#e8,#f0,#f0,#f0,#f8,#40
db #c1,#40,#c9,#40,#d1,#40,#d9,#40
db #e1,#40,#e9,#40,#f1,#40,#f9,#90
db #c1,#90,#c9,#90,#d1,#90,#d9,#90
db #e1,#90,#e9,#90,#f1,#90,#f9,#e0
db #c1,#e0,#c9,#e0,#d1,#e0,#d9,#e0
db #e1,#e0,#e9,#e0,#f1,#e0,#f9,#30
db #c2,#30,#ca,#30,#d2,#30,#da,#30
db #e2,#30,#ea,#30,#f2,#30,#fa,#80
db #c2,#80,#ca,#80,#d2,#80,#da,#80
db #e2,#80,#ea,#80,#f2,#80,#fa,#d0
db #c2,#d0,#ca,#d0,#d2,#d0,#da,#d0
db #e2,#d0,#ea,#d0,#f2,#d0,#fa,#20
db #c3,#20,#cb,#20,#d3,#20,#db,#20
db #e3,#20,#eb,#20,#f3,#20,#fb,#70 ;.......p
db #c3,#70,#cb,#70,#d3,#70,#db,#70 ;.p.p.p.p
db #e3,#70,#eb,#70,#f3,#70,#fb,#c0 ;.p.p.p..
db #c3,#c0,#cb,#c0,#d3,#c0,#db,#c0
db #e3,#c0,#eb,#c0,#f3,#c0,#fb,#10
db #c4,#10,#cc,#10,#d4,#10,#dc,#10
db #e4,#10,#ec,#10,#f4,#10,#fc,#60
db #c4,#60,#cc,#60,#d4,#60,#dc,#60
db #e4,#60,#ec,#60,#f4,#60,#fc,#b0
db #c4,#b0,#cc,#b0,#d4,#b0,#dc,#b0
db #e4,#b0,#ec,#b0,#f4,#b0,#fc,#00
db #c5,#00,#cd,#00,#d5,#00,#dd,#00
db #e5,#00,#ed,#00,#f5,#00,#fd,#50 ;.......P
db #c5,#50,#cd,#50,#d5,#50,#dd,#50 ;.P.P.P.P
db #e5,#50,#ed,#50,#f5,#50,#fd,#a0 ;.P.P.P..
db #c5,#a0,#cd,#a0,#d5,#a0,#dd,#a0
db #e5,#a0,#ed,#a0,#f5,#a0,#fd,#f0
db #c5,#f0,#cd,#f0,#d5,#f0,#dd,#f0
db #e5,#f0,#ed,#f0,#f5,#f0,#fd,#40
db #c6,#40,#ce,#40,#d6,#40,#de,#40
db #e6,#40,#ee,#40,#f6,#40,#fe,#90
db #c6,#90,#ce,#90,#d6,#90,#de,#90
db #e6,#90,#ee,#90,#f6,#90,#fe,#e0
db #c6,#e0,#ce,#e0,#d6,#e0,#de,#e0
db #e6,#e0,#ee,#e0,#f6,#e0,#fe,#30
db #c7,#30,#cf,#30,#d7,#30,#df,#30
db #e7,#30,#ef,#30,#f7,#30,#ff,#80
db #c7,#80,#cf,#80,#d7,#80,#df,#80
db #e7,#80,#ef,#80,#f7,#80,#ff,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#41 ;.......A
db #00,#c7,#82,#c7,#82,#0f,#4b,#87 ;......K.
db #82,#87,#82,#41,#00,#00,#00,#00 ;...A....
db #00,#00,#00,#41,#c3,#87,#4f,#41 ;...A..OA
db #c3,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#41 ;.......A
db #00,#c7,#82,#87,#82,#41,#00,#00 ;.....A..
db #c7,#00,#c7,#41,#cb,#41,#4b,#87 ;...A.AK.
db #82,#87,#82,#4b,#00,#4b,#00,#00 ;...K.K..
db #82,#41,#cb,#87,#c7,#87,#87,#87 ;.A......
db #87,#87,#87,#41,#4b,#00,#82,#00 ;...AK...
db #82,#41,#cb,#87,#cb,#41,#4b,#41 ;.A...AKA
db #4b,#41,#4b,#87,#0f,#41,#c3,#00 ;KAK..A..
db #82,#41,#cb,#87,#c7,#41,#0f,#87 ;.A...A..
db #4b,#87,#c3,#87,#0f,#41,#c3,#41 ;K....A.A
db #82,#87,#cb,#41,#c7,#41,#4b,#41 ;...A.AKA
db #87,#87,#87,#87,#0f,#41,#c3,#41 ;.....A.A
db #41,#87,#c7,#87,#c7,#87,#87,#87 ;A.......
db #0f,#41,#87,#00,#87,#00,#41,#41 ;.A....AA
db #c3,#87,#cf,#87,#c3,#87,#4b,#41 ;......KA
db #87,#87,#87,#41,#4b,#00,#82,#00 ;...AK...
db #c3,#41,#cb,#87,#c7,#87,#4b,#87 ;.A....K.
db #87,#87,#87,#41,#4b,#00,#82,#41 ;...AK..A
db #c3,#87,#4f,#41,#c7,#41,#4b,#41 ;..OA.AKA
db #4b,#87,#82,#87,#82,#41,#00,#00 ;K....A..
db #82,#41,#cb,#87,#c7,#41,#4b,#87 ;.A...AK.
db #87,#87,#0f,#41,#4b,#00,#82,#00 ;...AK...
db #82,#41,#cb,#87,#c7,#87,#87,#41 ;.A.....A
db #0f,#87,#87,#41,#4b,#00,#82,#cb ;...AK...
db #cb,#4b,#4b,#4b,#4b,#82,#82,#00 ;.KKKK...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#00,#c7,#82,#87,#82,#41 ;.A.....A
db #00,#c7,#82,#87,#82,#41,#00,#c7 ;.....A..
db #82,#c7,#82,#c7,#82,#87,#82,#87
db #82,#41,#00,#87,#82,#87,#82,#41 ;.A.....A
db #00,#4b,#cb,#0f,#cb,#87,#82,#0f ;.K......
db #4b,#4b,#4b,#82,#82,#00,#00,#00 ;KKK.....
db #00,#41,#82,#87,#cb,#41,#82,#41 ;.A...A.A
db #82,#87,#cb,#41,#82,#00,#00,#00 ;...A....
db #00,#00,#00,#00,#00,#00,#00,#41 ;.......A
db #00,#c7,#82,#87,#82,#4b,#00,#00 ;.....K..
db #82,#41,#cb,#87,#c7,#41,#87,#41 ;.A...A.A
db #4b,#41,#4b,#41,#c3,#00,#0a,#00 ;KAKA....
db #c3,#41,#4f,#87,#c7,#87,#87,#87 ;.AO.....
db #0f,#87,#87,#87,#87,#41,#41,#41 ;.....AAA
db #82,#87,#cb,#87,#c7,#87,#4b,#87 ;......K.
db #c7,#87,#87,#87,#0f,#41,#c3,#00 ;.....A..
db #82,#41,#cb,#87,#c7,#87,#c3,#87 ;.A......
db #c3,#87,#87,#87,#4b,#41,#82,#41 ;....KA.A
db #82,#87,#cb,#87,#c7,#87,#87,#87
db #87,#87,#87,#87,#0f,#41,#c3,#41 ;.....A.A
db #c3,#87,#4f,#87,#c3,#87,#87,#87 ;..O.....
db #c3,#87,#c3,#87,#0f,#41,#c3,#41 ;.....A.A
db #c3,#87,#4f,#87,#c3,#87,#87,#87 ;..O.....
db #c3,#87,#82,#87,#82,#41,#00,#00 ;.....A..
db #82,#41,#cb,#87,#c7,#87,#c3,#87 ;.A......
db #87,#87,#87,#87,#4b,#41,#82,#41 ;....KA.A
db #41,#87,#c7,#87,#c7,#87,#0f,#87 ;A.......
db #87,#87,#87,#87,#87,#41,#41,#00 ;.....AA.
db #82,#41,#cb,#41,#cb,#41,#4b,#41 ;.A.A.AKA
db #4b,#41,#4b,#41,#4b,#00,#82,#00 ;KAKAK...
db #41,#00,#c7,#00,#c7,#41,#87,#87 ;A....A..
db #87,#87,#87,#41,#0f,#00,#c3,#41 ;...A...A
db #41,#87,#c7,#87,#87,#87,#cb,#87 ;A.......
db #c7,#87,#87,#87,#87,#41,#41,#41 ;.....AAA
db #00,#c7,#82,#c7,#82,#87,#82,#87
db #82,#87,#c3,#87,#0f,#41,#c3,#41 ;.....A.A
db #41,#87,#c7,#87,#8f,#87,#8f,#87 ;A.......
db #0f,#87,#87,#87,#87,#41,#41,#41 ;.....AAA
db #41,#87,#c7,#c7,#c7,#87,#cf,#87 ;A.......
db #c7,#87,#87,#87,#87,#41,#41,#00 ;.....AA.
db #82,#41,#cb,#87,#c7,#87,#87,#87 ;.A......
db #87,#87,#87,#41,#4b,#00,#82,#41 ;...AK..A
db #c3,#87,#4f,#87,#c7,#87,#87,#87 ;..O.....
db #4b,#87,#82,#87,#82,#41,#00,#00 ;K....A..
db #82,#41,#cb,#87,#c7,#87,#87,#87 ;.A......
db #87,#87,#4b,#41,#0f,#00,#c3,#41 ;..KA...A
db #c3,#87,#4f,#87,#c7,#87,#87,#87 ;..O.....
db #4b,#87,#87,#87,#87,#41,#41,#00 ;K....AA.
db #c3,#41,#4f,#87,#c3,#41,#cb,#41 ;.AO..A.A
db #c7,#87,#c7,#41,#0f,#00,#c3,#41 ;...A...A
db #c3,#87,#4f,#41,#4b,#41,#4b,#41 ;..OAKAKA
db #4b,#41,#4b,#41,#4b,#00,#82,#41 ;KAKAK..A
db #41,#87,#c7,#87,#c7,#87,#87,#87 ;A.......
db #87,#87,#87,#41,#4b,#00,#82,#41 ;...AK..A
db #41,#87,#c7,#87,#c7,#87,#87,#41 ;A......A
db #4b,#41,#4b,#41,#4b,#00,#82,#41 ;KAKAK..A
db #41,#87,#c7,#87,#c7,#87,#87,#87 ;A.......
db #0f,#87,#0f,#87,#87,#41,#41,#41 ;.....AAA
db #41,#87,#c7,#87,#c7,#41,#4b,#41 ;A....AKA
db #4b,#87,#87,#87,#87,#41,#41,#41 ;K....AAA
db #41,#87,#c7,#87,#c7,#41,#0f,#41 ;A....A.A
db #87,#87,#87,#41,#0f,#00,#c3,#41 ;...A...A
db #c3,#87,#4f,#41,#c7,#41,#4b,#41 ;..OA.AKA
db #4b,#87,#c3,#87,#0f,#41,#c3,#c3 ;K....A..
db #30,#80,#c3,#82,#80,#c3,#b1,#80
db #01,#01,#00,#00,#00,#00,#f8,#bf
db #e8,#03,#01,#0f,#c0,#53,#46,#4f ;.....SFO
db #52,#cd,#53,#52,#45,#43,#c2,#08 ;R.SREC..
db #00,#00,#00,#00,#00,#00,#4b,#00 ;......K.
db #4b,#0d,#80,#0b,#80,#f4,#01,#ed ;K.......
db #73,#0f,#80,#af,#32,#0a,#80,#cd ;s.......
db #82,#80,#cd,#79,#80,#b1,#28,#26 ;...y....
db #c5,#cd,#79,#80,#c5,#dd,#e1,#c1 ;..y.....
db #3a,#0a,#80,#b7,#20,#09,#3e,#01
db #32,#0a,#80,#dd,#22,#11,#80,#cd
db #b1,#80,#dd,#77,#00,#dd,#23,#0b ;...w....
db #78,#b1,#20,#f3,#18,#d4,#3a,#0a ;x.......
db #80,#47,#3a,#09,#80,#a0,#28,#33 ;.G......
db #ed,#7b,#0f,#80,#2a,#11,#80,#e9
db #cd,#b1,#80,#4f,#cd,#b1,#80,#47 ;...O...G
db #c9,#21,#16,#80,#cd,#d4,#bc,#d2
db #a7,#80,#3e,#05,#dd,#21,#20,#80
db #cd,#1b,#00,#21,#1b,#80,#cd,#d4
db #bc,#d2,#a7,#80,#79,#32,#13,#80 ;....y...
db #22,#14,#80,#af,#18,#06,#3e,#01
db #ed,#7b,#0f,#80,#32,#d6,#00,#c9
db #dd,#e5,#c5,#3a,#13,#80,#4f,#2a ;......O.
db #14,#80,#dd,#21,#2a,#80,#3e,#03
db #cd,#1b,#00,#3a,#0c,#80,#b7,#28
db #09,#3e,#42,#cd,#1e,#bb,#28,#e3 ;..B.....
db #18,#d6,#c1,#dd,#e1,#3a,#0d,#80
db #c9,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab80E8 jr lab80FA
data80ea db #18
db #1c
lab80EC db #18
lab80ED db #a
lab80EE db #a
db #85
lab80F0 db #8
db #a7
lab80F2 db #3c
db #00
lab80F4 db #e8
db #b7
lab80F6 db #48
db #18,#38,#04
lab80FA ld hl,(lab0066)
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld (lab0066),hl
    ld (lab80EC),bc
    ld ix,lab0064
    ld iy,lab80F6
    call lab811A
    call lab81B9
    call lab81FF
    ret 
lab811A ld b,(ix+0)
    ld (iy+0),b
    ld a,(ix+1)
    ld (iy+2),a
    ld a,(lab80ED)
    ld (iy+3),a
    ld a,(lab80EC)
    ld (iy+1),a
    add a,b
    ld c,a
    call lab8138
    ret 
lab8138 ld a,(iy+0)
    ld h,#0
    ld l,#68
    cp l
    jr nc,lab8151
    cp h
    jr nc,lab8165
    ld a,c
    sub h
    jr c,lab81B4
    ld (iy+1),a
    ld (iy+0),h
    jr lab8171
lab8151 add a,(iy+1)
    jp m,lab81B4
    cp (iy+1)
    jr nc,lab81B4
    ld (iy+1),a
    xor a
    ld (iy+0),a
    jr lab8138
lab8165 ld a,c
    cp l
    jr c,lab8171
    ld b,(iy+0)
    ld a,l
    sub b
    ld (iy+1),a
lab8171 ld c,(iy+3)
    xor a
    ld (lab81D4+1),a
    ld a,(iy+2)
    ld d,a
    add a,c
    ld e,a
    ld a,d
    ld h,#0
    ld l,#3c
    cp l
    jr nc,lab819B
    cp h
    jr nc,lab81AB
    ld a,e
    sub h
    jr c,lab81B4
    jr z,lab81B4
lab818F ld (iy+3),a
    ld a,h
    ld (iy+2),a
    sub d
    ld (lab81D4+1),a
    ret 
lab819B add a,c
    sub h
    jp m,lab81B4
    jr z,lab81B4
    cp c
    jr nc,lab81B4
    push af
    sub c
    ld d,a
    pop af
    jr lab818F
lab81AB ld a,e
    cp l
    ret c
    ld a,l
    sub d
    ld (iy+3),a
    ret 
lab81B4 xor a
    ld (iy+1),a
    ret 
lab81B9 ld a,(lab0064)
    sub (iy+0)
    ld hl,data0000
    jr z,lab81D4
    bit 7,a
    jr z,lab81CA
    neg
lab81CA ld b,a
    ld a,(lab80ED)
    ld e,a
    ld d,#0
lab81D1 add hl,de
    djnz lab81D1
lab81D4 ld de,data0000
    add hl,de
    ld de,(lab0066)
    add hl,de
    ld (lab0066),hl
    ret 
lab81E1 ld l,a
    ld h,#0
    push hl
    ld bc,(lab80EE)
    add hl,hl
    add hl,bc
    push hl
    pop ix
    pop hl
    ld bc,(lab80F2)
    call lab77DB
    ld bc,(lab80F0)
    add hl,bc
    ld (lab80F4),hl
    ret 
lab81FF ld a,(iy+3)
    ld (lab8247+1),a
    ld e,a
    ld d,#0
    ld hl,(lab80F2)
    xor a
    sbc hl,de
    ld (lab8279+1),hl
    ld a,(lab80ED)
    ld (lab8274+1),a
    ld a,(iy+0)
    call lab81E1
    ld e,(iy+2)
    ld d,#0
    ld (lab8242+1),de
    ld hl,(lab80F4)
    add hl,de
    ld a,(iy+1)
    or a
    ret z
    ld iy,(lab0066)
    ld b,a
lab8234 push bc
    push iy
    ex de,hl
    ld l,(ix+0)
    inc ix
    ld h,(ix+0)
    inc ix
lab8242 ld bc,lab0038
    add hl,bc
    ex de,hl
lab8247 ld b,#4
lab8249 ld c,(iy+0)
    ld a,#aa
    and c
    jr z,lab825C
    ld a,#55
    and c
    jr nz,lab8267
    ld a,(hl)
    and #55
    or c
    jr lab826B
lab825C ld a,#55
    and c
    jr z,lab826A
    ld a,(hl)
    and #aa
    or c
    jr lab826B
lab8267 ld a,c
    jr lab826B
lab826A ld a,(hl)
lab826B ld (de),a
    inc iy
    inc de
    inc hl
    djnz lab8249
    pop iy
lab8274 ld bc,lab000A
    add iy,bc
lab8279 ld bc,lab0038
    add hl,bc
    pop bc
    djnz lab8234
    ret 
data8281 db #13
lab8282 db #0
lab8283 db #46
db #05,#12,#08,#ff,#00,#00,#fd,#09
db #01,#00,#00,#09,#c1,#10,#b4,#c9
lab8294 ld hl,lab82C0
    ld (lab8338+1),hl
    ld de,labA708
    ld hl,lab8EA8
    ld bc,lab185E+2
    jp lab82C0
lab82A6 ld bc,lab185E+2
    ld hl,lab82B6
    ld (lab8338+1),hl
    ld hl,labA708
    ld ix,lab86AE
lab82B6 ld e,(ix+0)
    inc ix
    ld d,(ix+0)
    inc ix
lab82C0 ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
lab8338 jp pe,lab82C0
    ret 
data833c db #a0
db #ed,#a0,#ed,#a0,#3d,#c2,#bf,#82
db #c9,#00,#00,#00,#00
lab834A ld ix,(lab0066)
    ld iy,lab0064
    ld hl,#ffff
    ld (lab0068),hl
    jr lab836C
lab835A call lab8382
lab835D ld a,#0
    or a
    jr z,lab8367
    ld (lab006A),ix
    ret 
lab8367 ld de,lab0008
    add ix,de
lab836C ld a,(ix+0)
    cp #ff
    jr z,lab837B
    or a
    jr z,lab8367
    inc (iy+4)
    jr lab835A
lab837B ld hl,#ffff
    ld (lab0068),hl
    ret 
lab8382 xor a
    ld (lab835D+1),a
    ld a,(ix+1)
    sub (iy+0)
    jr nc,lab8396
    neg
    cp (ix+3)
    ret nc
    jr lab839A
lab8396 cp (iy+8)
    ret nc
lab839A ld a,(ix+2)
    sub (iy+1)
    jr nc,lab83AA
    neg
    cp (ix+4)
    jr c,lab83AE
    ret 
lab83AA cp (iy+10)
    ret nc
lab83AE ld a,#1
    ld (lab835D+1),a
    ret 
data83b4 db #c9
lab83B5 jr lab83C6
lab83B7 jr lab8419
data83b9 db #48
lab83BA db #0
lab83BB db #20
lab83BC db #3c
lab83BD db #1
lab83BE db #15
db #50,#b4,#00,#00,#00,#00,#00 ;P......
lab83C6 ld a,(data83b9)
    call lab844D
    ld a,(lab83BD)
    ld (lab8413+1),a
    ld b,a
    ld a,(lab83BC)
    sub b
    ld (lab83E9+1),a
    ld a,(lab83BA)
    ld (lab83FC+1),a
    ld a,(lab83BB)
lab83E3 call lab83FC
lab83E6 ld de,labA6CC
lab83E9 ld bc,lab003B
    ldir
    call lab83F7
    dec a
    jr nz,lab83E3
    ret 
lab83F5 ex de,hl
    inc de
lab83F7 ld hl,lab83BE
    jr lab8413
lab83FC ld bc,data0000
    ld l,(ix+0)
    inc ix
    ld h,(ix+0)
    inc ix
    add hl,bc
    ld (lab83E6+1),hl
    ld (lab843B+1),hl
    ld de,lab83BE
lab8413 ld bc,lab0001
    ldir
    ret 
lab8419 ld a,(data83b9)
    call lab844D
    ld a,(lab83BD)
    ld (lab8413+1),a
    ld b,a
    ld a,(lab83BC)
    sub b
    ld (lab8441+1),a
    ld b,a
    ld a,(lab83BA)
    add a,b
    ld (lab83FC+1),a
    ld a,(lab83BB)
lab8438 call lab83FC
lab843B ld de,labA6CC
    ex de,hl
    dec hl
    dec de
lab8441 ld bc,lab0039
    lddr
    call lab83F5
    dec a
    jr nz,lab8438
    ret 
lab844D ld ix,lab85DA
    ld l,a
    ld h,#0
    add hl,hl
    ex de,hl
    add ix,de
    ret 
data8459 db #18
db #0a
lab845B jr lab8492
data845d db #8f
db #87
lab845F db #20
db #00
lab8461 db #8
db #00
lab8463 db #10
db #00,#cd,#c3,#84,#d5,#e5,#ed,#4b ;.......K
db #5f,#84,#0b,#2a,#61,#84,#cd,#db ;....a...
db #77,#d1,#19,#d1,#3a,#5f,#84,#ed ;w.......
db #4b,#61,#84,#ed,#b0,#ed,#4b,#63 ;Ka....Kc
db #84,#b7,#ed,#42,#3d,#20,#f0 ;...B...
lab848B ld hl,(data845d)
    ld (lab0066),hl
    ret 
lab8492 ld a,(lab73A2)
    or a
    jr z,lab849D
    ld hl,data84ee
    jr lab84A0
lab849D ld hl,lab84E0
lab84A0 ld (lab84B4+1),hl
    call lab84C3
    ex de,hl
    ld a,(lab845F)
lab84AA push af
    ld bc,(lab8461)
    add hl,bc
    push hl
    dec hl
lab84B2 ld b,#8
lab84B4 call lab84E0
    inc de
    dec hl
    dec b
    jr nz,lab84B4
    pop hl
    pop af
    dec a
    jr nz,lab84AA
    jr lab848B
lab84C3 ld de,(data845d)
    ld hl,(lab0066)
    ld a,(hl)
    ld (de),a
    ld (lab845F),a
    inc de
    inc hl
    ld a,(hl)
    ld (de),a
    ld (lab8461),a
    ld (lab84B2+1),a
    add a,a
    ld (lab8463),a
    inc de
    inc hl
    ret 
lab84E0 ld a,(de)
    and #aa
    srl a
    ld c,a
    ld a,(de)
    and #55
    sla a
    or c
    ld (hl),a
    ret 
data84ee db #1a
db #e6,#11,#07,#07,#07,#4f,#1a,#e6 ;.....O..
db #22,#07,#b1,#4f,#1a,#e6,#44,#0f ;...O..D.
db #b1,#4f,#1a,#e6,#88,#0f,#0f,#0f ;.O......
db #b1,#77,#c9,#08,#a7,#44,#a7,#80 ;.w...D..
db #a7,#bc,#a7,#f8,#a7,#34,#a8,#70 ;.......p
db #a8,#ac,#a8,#e8,#a8,#24,#a9,#60
db #a9,#9c,#a9,#d8,#a9,#14,#aa,#50 ;.......P
db #aa,#8c,#aa,#c8,#aa,#04,#ab,#40
db #ab,#7c,#ab,#b8,#ab,#f4,#ab,#30
db #ac,#6c,#ac,#a8,#ac,#e4,#ac,#20 ;.l......
db #ad,#5c,#ad,#98,#ad,#d4,#ad,#10
db #ae,#4c,#ae,#88,#ae,#c4,#ae,#00 ;.L......
db #af,#3c,#af,#78,#af,#b4,#af,#f0 ;...x....
db #af,#2c,#b0,#68,#b0,#a4,#b0,#e0 ;...h....
db #b0,#1c,#b1,#58,#b1,#94,#b1,#d0 ;...X....
db #b1,#0c,#b2,#48,#b2,#84,#b2,#c0 ;...H....
db #b2,#fc,#b2,#38,#b3,#74,#b3,#b0 ;.....t..
db #b3,#ec,#b3,#28,#b4,#64,#b4,#a0 ;.....d..
db #b4,#dc,#b4,#18,#b5,#54,#b5,#90 ;.....T..
db #b5,#cc,#b5,#08,#b6,#44,#b6,#80 ;.....D..
db #b6,#bc,#b6,#f8,#b6,#34,#b7,#70 ;.......p
db #b7,#ac,#b7,#e8,#b7,#24,#b8,#60
db #b8,#9c,#b8,#d8,#b8,#14,#b9,#50 ;.......P
db #b9,#8c,#b9,#c8,#b9,#04,#ba,#40
db #ba,#7c,#ba,#b8,#ba,#f4,#ba,#30
db #bb,#6c,#bb,#a8,#bb,#e4,#bb,#20 ;.l......
db #bc,#5c,#bc,#98,#bc,#d4,#bc,#10
db #bd,#4c,#bd,#88,#bd,#c4,#bd,#00 ;.L......
db #be,#3c,#be,#78,#be,#b4,#be,#f0 ;...x....
db #be,#2c,#bf
lab85DA db #a8
db #8e,#e4,#8e,#20,#8f,#5c,#8f,#98
db #8f,#d4,#8f,#10,#90,#4c,#90,#88 ;.....L..
db #90,#c4,#90,#00,#91,#3c,#91,#78 ;.......x
db #91,#b4,#91,#f0,#91,#2c,#92,#68 ;.......h
db #92,#a4,#92,#e0,#92,#1c,#93,#58 ;.......X
db #93,#94,#93,#d0,#93,#0c,#94,#48 ;.......H
db #94,#84,#94,#c0,#94,#fc,#94,#38
db #95,#74,#95,#b0,#95,#ec,#95,#28 ;.t......
db #96,#64,#96,#a0,#96,#dc,#96,#18 ;.d......
db #97,#54,#97,#90,#97,#cc,#97,#08 ;.T......
db #98,#44,#98,#80,#98,#bc,#98,#f8 ;.D......
db #98,#34,#99,#70,#99,#ac,#99,#e8 ;...p....
db #99,#24,#9a,#60,#9a,#9c,#9a,#d8
db #9a,#14,#9b,#50,#9b,#8c,#9b,#c8 ;...P....
db #9b,#04,#9c,#40,#9c,#7c,#9c,#b8
db #9c,#f4,#9c,#30,#9d,#6c,#9d,#a8 ;.....l..
db #9d,#e4,#9d,#20,#9e,#5c,#9e,#98
db #9e,#d4,#9e,#10,#9f,#4c,#9f,#88 ;.....L..
db #9f,#c4,#9f,#00,#a0,#3c,#a0,#78 ;.......x
db #a0,#b4,#a0,#f0,#a0,#2c,#a1,#68 ;.......h
db #a1,#a4,#a1,#e0,#a1,#1c,#a2,#58 ;.......X
db #a2,#94,#a2,#d0,#a2,#0c,#a3,#48 ;.......H
db #a3,#84,#a3,#c0,#a3,#fc,#a3,#38
db #a4,#74,#a4,#b0,#a4,#ec,#a4,#28 ;.t......
db #a5,#64,#a5,#a0,#a5,#dc,#a5,#18 ;.d......
db #a6,#54,#a6,#90,#a6,#cc,#a6,#00 ;.T......
db #00,#00,#00
lab86AE db #aa
db #c0,#aa,#c8,#aa,#d0,#aa,#d8,#aa
db #e0,#aa,#e8,#aa,#f0,#aa,#f8,#fa
db #c0,#fa,#c8,#fa,#d0,#fa,#d8,#fa
db #e0,#fa,#e8,#fa,#f0,#fa,#f8,#4a ;.......J
db #c1,#4a,#c9,#4a,#d1,#4a,#d9,#4a ;.J.J.J.J
db #e1,#4a,#e9,#4a,#f1,#4a,#f9,#9a ;.J.J.J..
db #c1,#9a,#c9,#9a,#d1,#9a,#d9,#9a
db #e1,#9a,#e9,#9a,#f1,#9a,#f9,#ea
db #c1,#ea,#c9,#ea,#d1,#ea,#d9,#ea
db #e1,#ea,#e9,#ea,#f1,#ea,#f9,#3a
db #c2,#3a,#ca,#3a,#d2,#3a,#da,#3a
db #e2,#3a,#ea,#3a,#f2,#3a,#fa,#8a
db #c2,#8a,#ca,#8a,#d2,#8a,#da,#8a
db #e2,#8a,#ea,#8a,#f2,#8a,#fa,#da
db #c2,#da,#ca,#da,#d2,#da,#da,#da
db #e2,#da,#ea,#da,#f2,#da,#fa,#2a
db #c3,#2a,#cb,#2a,#d3,#2a,#db,#2a
db #e3,#2a,#eb,#2a,#f3,#2a,#fb,#7a ;.......z
db #c3,#7a,#cb,#7a,#d3,#7a,#db,#7a ;.z.z.z.z
db #e3,#7a,#eb,#7a,#f3,#7a,#fb,#ca ;.z.z.z..
db #c3,#ca,#cb,#ca,#d3,#ca,#db,#ca
db #e3,#ca,#eb,#ca,#f3,#ca,#fb,#1a
db #c4,#1a,#cc,#1a,#d4,#1a,#dc,#1a
db #e4,#1a,#ec,#1a,#f4,#1a,#fc,#6a ;.......j
db #c4,#6a,#cc,#6a,#d4,#6a,#dc,#6a ;.j.j.j.j
db #e4,#6a,#ec,#6a,#f4,#6a,#fc ;.j.j.j.
lab877E ld a,#0
    ld (lab8EA8),a
    ld de,lab8EA9
    ld hl,lab8EA8
    ld bc,lab185E+1
    ldir
    ret 
db #20,#08,#3f,#3f,#3f,#3f,#3f,#3f
db #3f,#3f,#00,#bf,#00,#bf,#00,#ff
db #ff,#ff,#7f,#7f,#7f,#7f,#7f,#bf
db #3f,#3f,#bf,#00,#bf,#00,#bf,#bf
db #bf,#bf,#ff,#ff,#ff,#ff,#ff,#bf
db #15,#15,#3f,#3f,#3f,#3f,#7f,#bf
db #3f,#3f,#00,#ff,#00,#00,#bf,#bf
db #bf,#3f,#55,#7f,#00,#55,#bf,#bf ;..U..U..
db #15,#3f,#bf,#7f,#00,#55,#3f,#bf ;.....U..
db #3f,#3f,#3f,#55,#00,#ff,#2a,#bf ;...U....
db #bf,#3f,#2a,#55,#55,#bf,#00,#55 ;...UU..U
db #15,#bf,#00,#55,#55,#15,#00,#55 ;...UU..U
db #3f,#15,#2a,#55,#bf,#2a,#00,#00 ;...U....
db #bf,#3f,#2a,#55,#aa,#2a,#00,#00 ;...U....
db #ff,#ff,#bf,#55,#2a,#00,#00,#00 ;...U....
db #55,#3f,#7f,#7f,#ff,#ff,#ff,#ff ;U.......
db #55,#3f,#7f,#ff,#3f,#3f,#3f,#3f ;U.......
db #bf,#3f,#15,#aa,#3f,#3f,#3f,#7f
db #bf,#3f,#00,#7f,#2a,#00,#00,#bf
db #bf,#bf,#00,#7f,#2a,#00,#00,#aa
db #bf,#15,#00,#15,#bf,#00,#55,#2a ;......U.
db #bf,#3f,#00,#15,#bf,#00,#55,#00 ;......U.
db #bf,#3f,#00,#15,#bf,#00,#bf,#00
db #bf,#bf,#00,#00,#7f,#2a,#aa,#00
db #bf,#15,#00,#00,#7f,#7f,#2a,#ff
db #bf,#3f,#00,#00,#7f,#7f,#ff,#3f
db #bf,#3f,#00,#00,#7f,#3f,#3f,#00
db #bf,#bf,#00,#00,#7f,#2a,#00,#00
db #bf,#15,#00,#00,#15,#bf,#00,#00
db #bf,#3f,#00,#00,#15,#bf,#00,#00
db #bf,#3f,#00,#00,#15,#bf,#ff,#ff
db #bf,#bf,#00,#00,#15,#bf,#3f,#3f
db #3f,#15,#0c,#4f,#0f,#0f,#0f,#0f ;...O....
db #cf,#4f,#0f,#8f,#0f,#0f,#0f,#cf ;.O......
db #4f,#cf,#cf,#cf,#cf,#4f,#0f,#4f ;O....O.O
db #cf,#cf,#0f,#0f,#cf,#4f,#8f,#4f ;.....O.O
db #8f,#0f,#0f,#cf,#0c,#4d,#8e,#8e ;.....M..
db #cf,#0f,#0f,#cf,#0c,#8e,#0c,#0c
db #0c,#4d,#0c,#8e,#8e,#0c,#0c,#0c ;.M......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
lab88D1 db #0
db #00
lab88D3 db #0
db #00
lab88D5 db #0
db #00
lab88D7 db #0
db #00
lab88D9 db #0
db #00
lab88DB db #40
db #00
lab88DD db #0
db #00
lab88DF db #0
db #00
lab88E1 db #3
db #00
lab88E3 db #c
db #3c
lab88E5 db #1
db #00
lab88E7 db #35
db #00
lab88E9 db #26
db #00
lab88EB db #4
db #00
lab88ED db #b0
db #04
lab88EF db #40
db #00
lab88F1 db #0
db #00
lab88F3 db #0
db #00
lab88F5 db #1
db #00
lab88F7 db #0
db #00
lab88F9 db #0
db #00
lab88FB db #0
db #00
lab88FD db #0
db #00
lab88FF db #0
db #00
lab8901 db #0
db #00
lab8903 db #0
db #00
lab8905 db #0
db #00
lab8907 db #0
db #00
lab8909 db #0
db #00
lab890B db #0
db #00
lab890D db #0
db #00
lab890F db #0
db #00
lab8911 db #0
db #00
lab8913 db #0
db #00
lab8915 db #0
db #00
lab8917 db #10
db #00
lab8919 db #0
db #00
lab891B db #0
db #00
lab891D db #0
db #00
lab891F db #0
db #00
lab8921 db #0
db #00
lab8923 db #0
db #00
lab8925 db #0
db #00
lab8927 db #0
db #00
lab8929 db #0
db #00
lab892B db #0
db #00
lab892D db #48
db #00
lab892F db #38
db #00
lab8931 db #0
db #00
lab8933 db #0
db #00
lab8935 db #0
db #00
lab8937 db #7e
db #3d
lab8939 db #0
db #00
lab893B db #0
db #00
lab893D db #0
db #00
lab893F db #0
db #00
lab8941 db #0
db #00
lab8943 db #28
db #37
lab8945 db #0
db #00
lab8947 db #2
db #00
lab8949 db #0
db #00
lab894B db #0
db #00
lab894D db #0
db #00
lab894F db #0
db #00
lab8951 db #0
db #00
lab8953 db #0
db #00
lab8955 db #0
db #00
lab8957 db #0
db #00
lab8959 db #0
db #00
lab895B db #0
db #00
lab895D db #0
db #00
lab895F db #a
db #00
lab8961 db #18
db #00
lab8963 db #4
db #00
lab8965 db #0
db #00
lab8967 db #0
db #00
lab8969 db #0
db #00
lab896B db #0
db #00
lab896D db #0
db #00
lab896F db #0
db #00
lab8971 db #48
db #00
lab8973 db #38
db #00
lab8975 db #0
db #00
lab8977 db #0
db #00
lab8979 db #f6
db #36
lab897B db #0
db #00
lab897D db #0
db #00
lab897F db #10
db #00
lab8981 db #0
db #00
lab8983 db #0
db #00
lab8985 db #2
db #00
lab8987 db #ec
db #36
lab8989 db #46
db #00
lab898B db #0
db #00
lab898D db #0
db #00
lab898F db #0
db #00
lab8991 db #0
db #00
lab8993 db #1
db #00
lab8995 db #d7
db #3e
lab8997 db #0
db #00
lab8999 db #1a
db #00
lab899B db #ac
db #00
lab899D db #0
db #00
lab899F db #0
db #00
lab89A1 db #1e
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#84
db #01,#ff,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#08
db #26,#c9,#fd,#00,#00,#00,#00,#00
db #00,#00,#00,#08,#26,#c9,#fd,#00
db #00,#00,#00,#00,#00,#00,#00,#08
db #26,#c9,#fd,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#02,#26,#c9,#fd,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#04,#26,#c9,#fd,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#08,#26,#c9
db #fd,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #26,#c9,#fd,#00,#00,#00,#00,#00
db #72,#75,#6e,#22,#61,#72,#6d,#79 ;run.army
db #6d,#6f,#76,#61,#00,#00,#00,#00 ;mova....
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#6f,#01,#70 ;.....o.p
db #ae,#73,#01,#72,#01,#00,#01,#00 ;.s.r....
db #00,#00,#00,#00,#00,#00,#00,#00
db #ea,#21,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#a0,#01,#ff,#78,#01 ;......x.
db #fe,#bf,#0d,#00,#7b,#a6,#fb,#a6
db #40,#00,#6f,#01,#5a,#23,#5a,#23 ;..o.Z.Z.
db #5a,#23,#5a,#23,#00,#00,#00,#00 ;Z.Z.....
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#70,#ae,#7b ;.....p..
db #a6,#7b,#a6,#00,#7c,#96,#7c,#a6
db #00,#10,#7e,#b0,#08,#42,#00,#00 ;.....B..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#08,#42,#00,#02,#a0,#01 ;...B....
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00
lab8EA8 db #0
lab8EA9 db #0
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#ff,#41,#52,#4d,#59,#4d ;...ARMYM
db #4f,#56,#41,#42,#41,#53,#09,#00 ;OVABAS..
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#18,#3c,#7e,#ff,#18,#18
db #18,#18,#18,#18,#18,#18,#ff,#7e
db #3c,#18,#10,#30,#70,#ff,#ff,#70 ;....p..p
db #30,#10,#08,#0c,#0e,#ff,#ff,#0e
db #0c,#08,#00,#00,#18,#3c,#7e,#ff
db #ff,#00,#00,#00,#ff,#ff,#7e,#3c
db #18,#00,#80,#e0,#f8,#fe,#f8,#e0
db #80,#00,#02,#0e,#3e,#fe,#3e,#0e
db #02,#00,#38,#38,#92,#7c,#10,#28
db #28,#28,#38,#38,#10,#fe,#10,#28
db #44,#82 ;D.
labA6CC db #38
db #38,#12,#7c,#90,#28,#24,#22,#38
db #38,#90,#7c,#12,#28,#48,#88,#00 ;.....H..
db #3c,#18,#3c,#3c,#3c,#18,#00,#3c
db #ff,#ff,#18,#0c,#18,#30,#18,#18
db #3c,#7e,#18,#18,#7e,#3c,#18,#00
db #24,#66,#ff,#66,#24,#00,#00,#00 ;.f.f....
db #00,#07,#00,#00,#00,#00,#10,#a9
db #ff,#ec,#bf
labA708 db #ff
db #00,#41,#52,#4d,#59,#4d,#4f,#56 ;.ARMYMOV
db #41,#42,#ce,#31,#01,#00,#00,#08 ;AB......
db #1b,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #88,#00,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#02
db #1e,#01,#1e,#01,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#02,#00
db #00,#00,#01,#00,#31,#43,#00,#00 ;.....C..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#31,#43,#00,#eb ;.....C..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#71,#36,#c2,#ed,#01 ;...q....
db #0b,#80,#45,#53,#6f,#70,#ae,#04 ;..ESop..
db #c5,#f8,#0a,#2c,#a7,#f9,#20,#03
db #10,#7e,#b0,#3d,#87,#b9,#f1,#05
db #42,#0f,#02,#1c,#80,#1c,#1c,#90 ;B.......
db #8e,#3b,#fc,#c7,#bf,#d9,#f8,#df
db #47,#01,#af,#ff,#00,#00,#00,#00 ;G.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#cf,#e5,#a4,#cf,#50 ;.......P
db #a5,#cf,#57,#a5,#cf,#a0,#a5,#cf ;..W.....
db #18,#a6,#cf,#07,#a6,#cf,#03,#a6
db #cf,#fe,#a4,#cf,#7f,#a5,#cf,#99
db #a5,#cf,#c6,#a5,#cf,#53,#a6,#cf ;.....S..
db #92,#a6,#30,#cd,#07,#00,#00,#24
db #00,#03,#07,#00,#b3,#00,#3f,#00
db #c0,#00,#10,#00,#00,#00,#c1,#09
db #2a,#52,#e5,#02,#04,#06,#ff,#00 ;.R......
db #49,#61,#80,#80,#80,#80,#80,#80 ;Ia......
db #80,#80,#80,#80,#80,#80,#80,#80
db #ff,#ff,#ff,#ff,#ff,#ff,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#24
db #00,#03,#07,#00,#aa,#00,#3f,#00
db #c0,#00,#10,#00,#02,#00,#41,#09 ;......A.
db #2a,#52,#e5,#02,#04,#00,#00,#00 ;.R......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#05,#00,#00,#00,#00,#00,#30
db #a9,#90,#a8,#a9,#a8,#b9,#a8,#00
db #00,#00,#00,#00,#00,#00,#00,#30
db #a9,#d0,#a8,#e9,#a8,#f9,#a8,#00
db #41,#52,#4d,#59,#4d,#4f,#56,#41 ;ARMYMOVA
db #42,#41,#53,#00,#00,#00,#45,#02 ;BAS...E.
db #03,#04,#05,#06,#07,#08,#09,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#52,#4d,#59,#4d,#4f,#56,#41 ;ARMYMOVA
db #42,#ce,#31,#00,#00,#00,#80,#0b ;B.......
db #0c,#0d,#0e,#0f,#10,#11,#12,#13
db #14,#15,#16,#17,#18,#19,#1a,#00
db #41,#52,#4d,#59,#4d,#4f,#56,#41 ;ARMYMOVA
db #42,#ce,#31,#01,#00,#00,#08,#1b ;B.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #41,#52,#4d,#59,#4d,#4f,#56,#41 ;ARMYMOVA
db #42,#ce,#32,#00,#00,#00,#80,#1c ;B.......
db #1d,#1e,#1f,#20,#21,#22,#23,#24
db #25,#26,#27,#28,#29,#2a,#2b,#c9
db #20,#08,#01,#30,#50,#34,#0f,#27 ;....P...
db #68,#01,#18,#10,#9a,#64,#49,#74 ;h....dIt
db #30,#d2,#2e,#61,#26,#c5,#34,#61 ;...a...a
db #5b,#22,#11,#b4,#f3,#c2,#0a,#7f
db #35,#36,#b6,#93,#f2,#46,#b2,#6d ;.....F.m
db #18,#f4,#09,#6f,#4b,#f4,#4f,#33 ;...oK.O.
db #15,#10,#37,#fb,#ff,#80,#a4,#fa
db #aa,#be,#3b,#bd,#b1,#bf,#66,#c3 ;......f.
db #2c,#11,#fa,#4e,#c2,#55,#a4,#96 ;...N.U..
db #be,#03,#91,#15,#6d,#aa,#e5,#cc ;....m...
db #30,#37,#08,#28,#fe,#41,#aa,#55 ;.....A.U
db #40,#36,#2a,#44,#08,#55,#71,#ca ;...D.Uq.
db #31,#a8,#de,#aa,#41,#91,#09,#2a ;....A...
db #dd,#08,#d5,#ff,#bf,#3b,#18,#8a
db #8f,#26,#20,#1b,#7f,#2a,#45,#dc ;......E.
db #73,#08,#18,#1a,#68,#08,#83,#f1 ;s...h...
db #a4,#7c,#ae,#bf,#02,#3f,#15,#33
db #0c,#0c,#07,#ac,#f2,#2a,#0d,#0d
db #03,#10,#da,#7c,#fc,#0f,#1e,#04
db #4f,#8f,#34,#08,#28,#1a,#df,#f3 ;O.......
db #0f,#cf,#38,#7b,#07,#4d,#54,#3d ;.....MT.
db #8e,#02,#ce,#0c,#b8,#2f,#90,#14
db #03,#14,#0c,#3c,#20,#1c,#35,#83
db #26,#f1,#b0,#04,#33,#40,#06,#44 ;.......D
db #48,#7e,#92,#68,#03,#42,#7b,#44 ;H..h.B.D
db #12,#a1,#7e,#3d,#a1,#0f,#28,#37
db #7d,#14,#db,#5a,#0a,#29,#18,#38 ;...Z....
db #a2,#d0,#3e,#43,#61,#38,#4c,#0c ;...Ca.L.
db #f6,#2a,#3f,#05,#10,#0a,#4a,#02 ;......J.
db #05,#ec,#36,#46,#87,#18,#01,#2b ;...F....
db #d7,#3e,#38,#1a,#20,#ac,#38,#06
db #1e,#95,#75,#06,#4a,#0c,#23,#36 ;..u.J...
db #b5,#02,#22,#8c,#bf,#f3,#04,#90
db #15,#08,#25,#b2,#8d,#10,#70,#26 ;......p.
db #c9,#fd,#30,#72,#75,#6e,#e6,#84 ;...run..
db #33,#d9,#35,#d1,#e7,#2c,#e0,#31
db #e6,#34,#e2,#b5,#28,#5d,#e1,#df
db #eb,#00,#33,#87,#01,#a1,#3f,#84
db #fb,#01,#05,#0f,#29,#ec,#bb,#9a
db #56,#1a,#73,#13,#72,#dd,#1b,#df ;V.s.r...
db #14,#a4,#02,#7f,#48,#0a,#80,#04 ;....H...
db #6c,#0d,#94,#a0,#28,#62,#c1,#45 ;l....b.E
db #20,#32,#30,#02,#ae,#17,#e1,#80
db #ec,#7c,#fc,#fe,#bf,#0d,#ff,#13
db #80,#f7,#a6,#40,#09,#6f,#38,#02 ;.....o..
db #b7,#53,#01,#b8,#90,#94,#aa,#80 ;.S......
db #c9,#b8,#ff,#bf,#72,#80,#3d,#7a ;....r..z
db #01,#1f,#41,#da,#1e,#e1,#08,#71 ;..A....q
db #36,#c2,#ed,#01,#0b,#80,#45,#53 ;......ES
db #6f,#70,#ae,#04,#c5,#f8,#0a,#2c ;op......
db #a7,#f9,#20,#03,#10,#7e,#b0,#3d
db #87,#b9,#f1,#05,#42,#0f,#02,#1c ;....B...
db #80,#1c,#1c,#90,#8e,#3b,#fc,#c7
db #bf,#d9,#f8,#df,#47,#01,#af,#ff ;....G...
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
db #00,#00,#00,#00,#00,#00,#00,#01
db #84,#01,#ff,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #08,#26,#c9,#fd,#00,#00,#00,#00
db #00,#00,#00,#00,#08,#26,#c9,#fd
db #00,#00,#00,#00,#00,#00,#00,#00
db #08,#26,#c9,#fd,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#02,#26,#c9,#fd,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#04,#26,#c9,#fd
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#08,#26
db #c9,#fd,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #10,#26,#c9,#fd,#00,#00,#00,#00
db #00,#72,#75,#6e,#22,#61,#72,#6d ;.run.arm
db #79,#6d,#6f,#76,#61,#00,#00,#00 ;ymova...
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#6f,#01 ;......o.
db #70,#ae,#73,#01,#72,#01,#00,#01 ;p.s.r...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ea,#21,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#a0,#01,#ff,#78 ;.......x
db #01,#fe,#bf,#0d,#00,#7b,#a6,#fb
db #a6,#40,#00,#6f,#01,#5a,#23,#5a ;...o.Z.Z
db #23,#5a,#23,#5a,#23,#00,#00,#00 ;.Z.Z....
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#70,#ae ;......p.
db #7b,#a6,#7b,#a6,#00,#7c,#96,#7c
db #a6,#00,#10,#7e,#b0,#08,#42,#00 ;......B.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#08,#42,#00,#02,#a0 ;....B...
db #01,#00,#00,#00,#00,#00,#00,#00
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
db #00,#00,#00,#00,#00,#00,#00,#07
db #6c,#65,#89,#00,#00,#00,#00,#00 ;le......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #06,#53,#00,#00,#00,#00,#00,#00 ;.S......
db #00,#00,#00,#81,#8b,#20,#01,#00
db #01,#08,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#04,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#02
db #10,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#02,#04,#20
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#04,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#3f,#00,#00,#00
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#f0,#f3,#f1
db #89,#86,#83,#8b,#8a,#f2,#e0,#87
db #88,#85,#81,#82,#80,#10,#2a,#0d
db #23,#84,#ff,#24,#ff,#2d,#29,#5e
db #70,#7c,#6d,#3d,#3a,#40,#5c,#6f ;p.m....o
db #69,#6c,#6b,#2c,#3b,#21,#7d,#75 ;ilk....u
db #79,#68,#6a,#6e,#20,#5d,#28,#72 ;yhjn...r
db #74,#67,#66,#62,#76,#27,#22,#65 ;tgfbv..e
db #7a,#73,#64,#63,#78,#26,#7b,#fc ;zsdcx...
db #61,#09,#71,#fd,#77,#0b,#0a,#08 ;a.q.w...
db #09,#58,#5a,#ff,#7f,#f4,#f7,#f5 ;.XZ.....
db #89,#86,#83,#8b,#8a,#f6,#e0,#87
db #88,#85,#81,#82,#80,#10,#3c,#0d
db #3e,#84,#ff,#40,#ff,#5f,#5b,#7c
db #50,#25,#4d,#2b,#2f,#30,#39,#4f ;P.M....O
db #49,#4c,#4b,#3f,#2e,#38,#37,#55 ;ILK....U
db #59,#48,#4a,#4e,#20,#36,#35,#52 ;YHJN...R
db #54,#47,#46,#42,#56,#34,#33,#45 ;TGFBV..E
db #5a,#53,#44,#43,#58,#31,#32,#fc ;ZSDCX...
db #41,#09,#51,#fd,#57,#0b,#0a,#08 ;A.Q.W...
db #09,#58,#5a,#ff,#7f,#f8,#fb,#f9 ;.XZ.....
db #89,#86,#83,#8c,#8a,#fa,#e0,#87
db #88,#85,#81,#82,#80,#10,#ff,#0d
db #ff,#84,#ff,#5c,#ff,#1f,#a2,#1e
db #10,#ff,#0d,#ff,#ff,#00,#1c,#0f
db #09,#0c,#0b,#ff,#ff,#ff,#ff,#15
db #19,#08,#0a,#0e,#ff,#a6,#ff,#12
db #14,#07,#06,#02,#16,#ff,#1d,#05
db #1a,#13,#04,#03,#18,#1b,#7e,#fc
db #01,#e1,#11,#fe,#17,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#7f,#07,#03,#4b ;.......K
db #ff,#ff,#ff,#ff,#ff,#ab,#8f,#01
db #30,#01,#31,#01,#32,#01,#33,#01
db #34,#01,#35,#01,#36,#01,#37,#01
db #38,#01,#39,#01,#2e,#01,#0d,#05
db #52,#55,#4e,#22,#0d,#00,#00,#00 ;RUN.....
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#01
db #81,#ff,#90,#b5,#28,#b6,#c1,#b5
db #00,#00,#02,#1e,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#22,#01,#20,#ff,#00,#00
db #00,#40,#92,#c4,#fd,#04,#04,#06
db #80,#08,#20,#09,#80,#08,#08,#02
db #04,#01,#20,#05,#40,#07,#01,#08
db #08,#03,#20,#09,#80,#09,#80,#09
db #80,#07,#02,#08,#08,#06,#04,#03
db #20,#05,#08,#03,#20,#15,#06,#01
db #06,#00,#96,#b4,#e6,#b4,#36,#b5
db #86,#b5,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#9f,#00,#c7,#00
db #00,#00,#c0,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#ff,#00,#00,#00,#00,#00
db #00,#00,#18,#13,#00,#02,#01,#00
db #92,#13,#00,#00,#00,#00,#00,#00
db #18,#13,#00,#02,#c0,#00,#92,#13
db #00,#00,#00,#00,#00,#00,#18,#13
db #00,#02,#c0,#00,#92,#13,#00,#00
db #00,#00,#00,#00,#18,#13,#00,#02
db #c0,#00,#92,#13,#00,#00,#00,#00
db #00,#00,#18,#13,#00,#02,#c0,#00
db #92,#13,#00,#00,#00,#00,#00,#00
db #18,#13,#00,#02,#c0,#00,#92,#13
db #00,#00,#00,#00,#00,#00,#18,#13
db #00,#02,#c0,#00,#92,#13,#00,#00
db #00,#00,#00,#00,#18,#13,#00,#02
db #c0,#00,#92,#13,#00,#00,#00,#00
db #00,#00,#18,#13,#00,#02,#c0,#00
db #92,#13,#00,#f0,#ff,#7c,#a6,#33
db #00,#11,#88,#00,#cc,#00,#cc,#00
db #cc,#11,#88,#33,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #1f,#11,#0e,#1a,#00,#00,#00,#00
db #00,#00,#80,#13,#15,#81,#35,#13
db #80,#97,#12,#80,#86,#12,#81,#e9
db #0a,#81,#40,#19,#00,#59,#14,#80 ;.....Y..
db #e1,#14,#80,#19,#15,#80,#1e,#15
db #80,#23,#15,#80,#28,#15,#80,#4f ;.......O
db #15,#80,#3f,#15,#81,#ab,#12,#81
db #a6,#12,#80,#5e,#15,#80,#99,#15
db #80,#8f,#15,#80,#78,#15,#80,#65 ;....x..e
db #15,#80,#52,#14,#81,#ec,#14,#81 ;..R.....
db #55,#0c,#80,#c6,#12,#89,#0d,#15 ;U.......
db #84,#01,#15,#00,#eb,#14,#83,#f1
db #14,#82,#fa,#14,#80,#39,#15,#82
db #47,#15,#00,#00,#00,#c0,#c3,#74 ;G......t
db #0c,#00,#00,#00,#00,#00,#00,#00
db #00,#0a,#0a,#14,#14,#00,#0b,#1e
db #0a,#03,#12,#13,#16,#04,#15,#17
db #0e,#06,#1c,#0c,#14,#14,#00,#0b
db #1e,#0a,#03,#12,#13,#16,#04,#15
db #17,#0e,#06,#1c,#0c,#00,#00,#0a
db #00,#00,#00,#00,#00,#81,#61,#0d ;......a.
db #00,#00,#00,#0a,#a0,#5e,#a1,#5c
db #a2,#7b,#a3,#23,#a6,#40,#ab,#7c
db #ac,#7d,#ad,#7e,#ae,#5d,#af,#5b
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#fb,#b7
db #00,#d8,#bf,#00,#00,#00,#00,#00
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#8d
db #03,#8d,#03,#cb,#01,#9f,#07,#7e
db #fb,#d4,#b7,#f8,#b7,#7c,#0d,#11
db #02,#fd,#b7,#2f,#01,#55,#03,#00 ;.....U..
db #00,#30,#b7,#72,#29,#00,#00,#00 ;...r....
db #f9,#b7,#00,#00,#00,#00,#02,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#fc,#a6,#00,#00,#06,#c0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #a7,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#c3
db #5f,#ba,#c3,#66,#ba,#c3,#51,#ba ;...f..Q.
db #c3,#58,#ba,#c3,#70,#ba,#c3,#79 ;.X..p..y
db #ba,#c3,#9d,#ba,#c3,#7e,#ba,#c3
db #87,#ba,#c3,#a1,#ba,#c3,#a7,#ba
db #3a,#c1,#b8,#b7,#c8,#e5,#f3,#18
db #06,#21,#bf,#b8,#36,#01,#c9,#2a
db #c0,#b8,#7c,#b7,#28,#07,#23,#23
db #23,#3a,#c2,#b8,#be,#e1,#fb,#c9
db #f3,#08,#38,#33,#d9,#79,#37,#fb ;.....y..
db #08,#f3,#f5,#cb,#91,#ed,#49,#cd ;......I.
db #b1,#00,#b7,#08,#4f,#06,#7f,#3a ;....O...
db #31,#b8,#b7,#28,#14,#fa,#72,#b9 ;......r.
db #79,#e6,#0c,#f5,#cb,#91,#d9,#cd ;y.......
db #0a,#01,#d9,#e1,#79,#e6,#f3,#b4 ;....y...
db #4f,#ed,#49,#d9,#f1,#fb,#c9,#08 ;O.I.....
db #e1,#f5,#cb,#d1,#ed,#49,#cd,#3b ;.....I..
db #00,#18,#cf,#f3,#e5,#d9,#d1,#18
db #06,#f3,#d9,#e1,#5e,#23,#56,#08 ;......V.
db #7a,#cb,#ba,#cb,#b2,#07,#07,#07 ;z.......
db #07,#a9,#e6,#0c,#a9,#c5,#cd,#b0
db #b9,#f3,#d9,#08,#79,#c1,#e6,#03 ;....y...
db #cb,#89,#cb,#81,#b1,#18,#01,#d5
db #4f,#ed,#49,#b7,#08,#d9,#fb,#c9 ;O.I.....
db #f3,#08,#79,#e5,#d9,#d1,#18,#15 ;..y.....
db #f3,#e5,#d9,#e1,#18,#09,#f3,#d9
db #e1,#5e,#23,#56,#23,#e5,#eb,#5e ;...V....
db #23,#56,#23,#08,#7e,#fe,#fc,#30 ;.V......
db #be,#06,#df,#ed,#79,#21,#d6,#b8 ;....y...
db #46,#77,#c5,#fd,#e5,#fe,#10,#30 ;Fw......
db #0f,#87,#c6,#da,#6f,#ce,#b8,#95 ;....o...
db #67,#7e,#23,#66,#6f,#e5,#fd,#e1 ;g..fo...
db #06,#7f,#79,#cb,#d7,#cb,#9f,#cd ;..y.....
db #b0,#b9,#fd,#e1,#f3,#d9,#08,#59 ;.......Y
db #c1,#78,#06,#df,#ed,#79,#32,#d6 ;.x...y..
db #b8,#06,#7f,#7b,#18,#90,#f3,#e5
db #d9,#d1,#18,#08,#f3,#d9,#e1,#5e
db #23,#56,#23,#e5,#08,#7a,#cb,#fa ;.V...z..
db #cb,#f2,#e6,#c0,#07,#07,#21,#d9
db #b8,#86,#18,#a5,#f3,#d9,#e1,#5e
db #23,#56,#cb,#91,#ed,#49,#ed,#53 ;.V...I.S
db #46,#ba,#d9,#fb,#cd,#45,#33,#f3 ;F....E..
db #d9,#cb,#d1,#ed,#49,#d9,#fb,#c9 ;....I...
db #f3,#d9,#79,#cb,#91,#18,#13,#f3 ;..y.....
db #d9,#79,#cb,#d1,#18,#0c,#f3,#d9 ;.y......
db #79,#cb,#99,#18,#05,#f3,#d9,#79 ;y......y
db #cb,#d9,#ed,#49,#d9,#fb,#c9,#f3 ;...I....
db #d9,#a9,#e6,#0c,#a9,#4f,#18,#f2 ;.....O..
db #cd,#5f,#ba,#18,#0f,#cd,#79,#ba ;......y.
db #3a,#00,#c0,#2a,#01,#c0,#f5,#78 ;.......x
db #cd,#70,#ba,#f1,#e5,#f3,#06,#df ;.p......
db #ed,#49,#21,#d6,#b8,#46,#71,#48 ;.I...FqH
db #47,#fb,#e1,#c9,#3a,#d6,#b8,#c9 ;G.......
db #cd,#ad,#ba,#ed,#b0,#c9,#cd,#ad
db #ba,#ed,#b8,#c9,#f3,#d9,#e1,#c5
db #cb,#d1,#cb,#d9,#ed,#49,#cd,#c2 ;.....I..
db #ba,#f3,#d9,#c1,#ed,#49,#d9,#fb ;.....I..
db #c9,#e5,#d9,#fb,#c9,#f3,#d9,#59 ;.......Y
db #cb,#d3,#cb,#db,#ed,#59,#d9,#7e ;.....Y..
db #d9,#ed,#49,#d9,#fb,#c9,#d9,#79 ;..I....y
db #f6,#0c,#ed,#79,#dd,#7e,#00,#ed ;...y....
db #49,#d9,#c9,#00,#00,#00,#00,#00 ;I.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#cf
db #5c,#9b,#cf,#98,#9b,#cf,#bf,#9b
db #cf,#c5,#9b,#cf,#fa,#9b,#cf,#46 ;.......F
db #9c,#cf,#b3,#9c,#cf,#04,#9c,#cf
db #db,#9c,#cf,#e1,#9c,#cf,#45,#9e ;......E.
db #cf,#38,#9d,#cf,#e5,#9d,#cf,#d8
db #9e,#cf,#c4,#9e,#cf,#dd,#9e,#cf
db #c9,#9e,#cf,#e2,#9e,#cf,#ce,#9e
db #cf,#34,#9e,#cf,#2f,#9e,#cf,#f6
db #9d,#cf,#f2,#9d,#cf,#fa,#9d,#cf
db #0b,#9e,#cf,#19,#9e,#cf,#74,#90 ;......t.
db #cf,#84,#90,#cf,#59,#94,#cf,#52 ;....Y..R
db #94,#cf,#fe,#93,#cf,#35,#93,#cf
db #ac,#93,#cf,#a8,#93,#cf,#08,#92
db #cf,#52,#92,#cf,#4f,#95,#cf,#5a ;.R..O..Z
db #91,#cf,#65,#91,#cf,#70,#91,#cf ;..e..p..
db #7c,#91,#cf,#86,#92,#cf,#97,#92
db #cf,#76,#92,#cf,#7e,#92,#cf,#ca ;.v......
db #91,#cf,#65,#92,#cf,#65,#92,#cf ;..e..e..
db #a6,#92,#cf,#ba,#92,#cf,#ab,#92
db #cf,#c0,#92,#cf,#c6,#92,#cf,#7b
db #93,#cf,#88,#93,#cf,#d4,#92,#cf
db #f2,#92,#cf,#fe,#92,#cf,#2b,#93
db #cf,#d4,#94,#cf,#e4,#90,#cf,#03
db #91,#cf,#a8,#95,#cf,#d7,#95,#cf
db #fe,#95,#cf,#fb,#95,#cf,#06,#96
db #cf,#0e,#96,#cf,#1c,#96,#cf,#a5
db #96,#cf,#ea,#96,#cf,#17,#97,#cf
db #2d,#97,#cf,#36,#97,#cf,#67,#97 ;......g.
db #cf,#75,#97,#cf,#6e,#97,#cf,#7a ;.u..n..z
db #97,#cf,#83,#97,#cf,#80,#97,#cf
db #97,#97,#cf,#94,#97,#cf,#a9,#97
db #cf,#a6,#97,#cf,#40,#99,#cf,#bf
db #8a,#cf,#d0,#8a,#cf,#37,#8b,#cf
db #3c,#8b,#cf,#56,#8b,#cf,#e9,#8a ;...V....
db #cf,#0c,#8b,#cf,#17,#8b,#cf,#5d
db #8b,#cf,#6a,#8b,#cf,#af,#8b,#cf ;..j.....
db #05,#8c,#cf,#11,#8c,#cf,#1f,#8c
db #cf,#39,#8c,#cf,#8e,#8c,#cf,#a7
db #8c,#cf,#f2,#8c,#cf,#1a,#8d,#cf
db #f7,#8c,#cf,#1f,#8d,#cf,#ea,#8c
db #cf,#ee,#8c,#cf,#b9,#8d,#cf,#bd
db #8d,#cf,#e5,#8d,#cf,#00,#8e,#cf
db #44,#8e,#cf,#f9,#8e,#cf,#2a,#8f ;D.......
db #cf,#55,#8c,#cf,#74,#8c,#cf,#93 ;.U..t...
db #8f,#cf,#9b,#8f,#cf,#bc,#a4,#cf
db #ce,#a4,#cf,#e1,#a4,#cf,#bb,#ab
db #cf,#bf,#ab,#cf,#c1,#ab,#df,#8b
db #a8,#df,#8b,#a8,#df,#8b,#a8,#df
db #8b,#a8,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#df,#8b,#a8,#df,#8b,#a8,#df
db #8b,#a8,#df,#8b,#a8,#cf,#af,#a9
db #cf,#a6,#a9,#cf,#c1,#a9,#cf,#e9
db #9f,#cf,#14,#a1,#cf,#ce,#a1,#cf
db #eb,#a1,#cf,#ac,#a1,#cf,#50,#a0 ;......P.
db #cf,#6b,#a0,#cf,#95,#a4,#cf,#9a ;.k......
db #a4,#cf,#a6,#a4,#cf,#ab,#a4,#cf
db #5c,#80,#cf,#26,#83,#cf,#30,#83
db #cf,#a0,#82,#cf,#b1,#82,#cf,#63 ;.......c
db #81,#cf,#6a,#81,#cf,#70,#81,#cf ;..j..p..
db #76,#81,#cf,#7d,#81,#cf,#83,#81 ;v.......
db #cf,#b3,#81,#cf,#c5,#81,#cf,#d2
db #81,#cf,#e2,#81,#cf,#27,#82,#cf
db #84,#82,#cf,#55,#82,#cf,#19,#82 ;...U....
db #cf,#76,#82,#cf,#94,#82,#cf,#9a ;.v......
db #82,#cf,#8d,#82,#cf,#99,#80,#cf
db #a3,#80,#cf,#ed,#85,#cf,#1c,#86
db #cf,#b4,#87,#cf,#76,#87,#cf,#c0 ;....v...
db #87,#cf,#86,#87,#cf,#8c,#87,#cf
db #e0,#87,#cf,#1b,#88,#cf,#58,#88 ;......X.
db #cf,#44,#88,#cf,#63,#88,#cf,#bd ;.D..c...
db #88,#cf,#3c,#9d,#cf,#fe,#9b,#cf
db #60,#94,#cf,#ec,#95,#cf,#d5,#99
db #cf,#b0,#97,#cf,#ac,#97,#cf,#2a
db #96,#cf,#d9,#99,#cf,#45,#8b,#cf ;.....E..
db #0c,#88,#cf,#97,#83,#cf,#02,#ac
db #ef,#91,#2f,#ef,#9f,#2f,#ef,#c8
db #2f,#ef,#d9,#2f,#ef,#01,#30,#ef
db #14,#30,#ef,#55,#30,#ef,#5f,#30 ;...U....
db #ef,#c6,#30,#ef,#a2,#34,#ef,#59 ;.......Y
db #31,#ef,#9e,#34,#ef,#77,#35,#ef ;.....w..
db #04,#36,#ef,#88,#31,#ef,#df,#36
db #ef,#31,#37,#ef,#27,#37,#ef,#45 ;.......E
db #33,#ef,#73,#2f,#ef,#ac,#32,#ef ;..s.....
db #af,#32,#ef,#b6,#31,#ef,#b1,#31
db #ef,#2f,#32,#ef,#53,#33,#ef,#49 ;....S..I
db #33,#ef,#c8,#33,#ef,#d8,#33,#ef
db #d1,#2f,#ef,#36,#31,#ef,#43,#31 ;......C.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c3,#5f,#12,#c3
db #5f,#12,#c3,#4b,#13,#c3,#be,#13 ;...K....
db #c3,#0a,#14,#c3,#86,#17,#c3,#9a
db #17,#c3,#b4,#17,#c3,#8a,#0c,#c3
db #71,#0c,#c3,#17,#0b,#c3,#b8,#1d ;q.......
db #c3,#35,#08,#c3,#40,#1d,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #a9,#90,#a8,#32,#00,#fa,#00,#af
db #0f,#0c,#07,#40,#80,#00,#06,#00
db #c2,#02,#00,#06,#07,#00,#06,#01
db #00,#00,#00,#00,#00,#ff,#00,#e4
db #a7,#b0,#a9,#ca,#bf,#10,#00,#00
db #f9,#00,#00,#00,#00,#00,#00,#80
db #d6,#c9,#07,#c2,#66,#b0,#a9,#ff ;....f...
db #00,#00,#00,#00,#00,#a7,#c9,#00
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#f7,#49,#1d,#d2 ;.....I..
db #00,#53,#b9,#05,#50,#26,#c9,#4c ;.S..P..L
db #be,#00,#00,#b0,#ab,#00,#f7,#49 ;.......I
db #1d,#d2,#00,#53,#b9,#87,#50,#28 ;...S..P.
db #c9,#4c,#be,#00,#06,#b0,#ab,#fc ;.L......
db #c8,#d2,#00,#00,#00,#60,#ca,#80
db #00,#f2,#c8,#ce,#c8,#45,#00,#55 ;.....E.U
db #be,#00,#00,#58,#be,#56,#c5,#f1 ;...X.V..
db #d9,#e4,#a7,#00,#a7,#ff,#44,#6b ;......Dk
db #b9,#18,#08,#f9,#0b,#97,#0c,#9f
db #07,#00,#00,#d4,#b7,#ba,#b8,#7c
db #0d,#69,#01,#7e,#03,#84,#a9,#48 ;.i.....H
db #01,#04,#75,#14,#37,#1a,#02,#a2 ;..u.....
db #b9,#85,#7f,#8e,#f2,#6f,#de ;.....o.
labC000 db #0

; disassembled using: 
;python3.8.exe .\z80-smart-disassembler.py -a 355  -i .\army_355.BIN -d
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

-- Project 174: fire by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fire',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-01-02T11:18:02.424000'::timestamptz,
    '2021-06-18T22:48:10.307000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'FX_W				equ 32
FX_H				equ 25

R1					equ 32
R2 					equ 46 + (R1 - 40) / 2
SCR_W				equ R1 * 2

TABLE_ADR_END		equ #4000 
TABLE_ADR			equ TABLE_ADR_END - 3 * FX_W * FX_H * 2

MACRO WRITE_CRTC reg, val
                ld bc, #bc00 + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
ENDM

macro CPC_PIXEL p
    p0 = (v & (1 << 0)) >> 0
    p1 = (v & (1 << 1)) >> 1
    p2 = (v & (1 << 2)) >> 2
    p3 = (v & (1 << 3)) >> 3
   
    r =  (p0 << 7) + (p1 << 3) + (p2 << 5) + (p3 << 1)
    r += r >> 1
    db r
endm


macro WIN_BRK
                db #ed, #ff
endm
; -------------------------------------------------------------------------------------------
;
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

                org #1000
start
                di
                ld sp, #38
                ld hl, #c9fb
                ld (#38),hl
                ei
				
                WRITE_CRTC 1, R1
                WRITE_CRTC 2, R2
                SET_PALETTE palette, 0, 17
                
                ld bc, #7f8c
                out (c), c
				
                call buildAdrTable
mainloop:

	            ld b, #f5
.vbl
                in a, (c)
                rra
                jr nc, .vbl
               
				call initHotSpots
                ld ix, buf
                
                exx
                ld de, buf2
               	exx
          		di
                ld (.saveStack + 1), sp
                ld sp, TABLE_ADR
 				ld b, FX_H - 1
                
                ld h, hi(pixels)             
                
.loop:			
                ; WIN_BRK (void)
        
repeat FX_W
                ld a, (ix + FX_W)
             	or a
                jr z, @ok
                add a
                add (ix - 1)
                add (ix + 1)
        
            	dec a: dec a
                srl a : srl a
             
               
 @ok 			
 				ld (ix + 0), a
                ld c, a
                inc ix
                exx
                ld a, (de)
                inc de
                exx 
                or a
                jr nz, @draw
                add c
 
 @draw
                ld l, a
                ld a, (hl)
    repeat 3
				pop de : ld (de), a
    rend
rend
                dec b
                jp nz, .loop
                
.saveStack:		ld sp, 0
				ei
                

                jp mainloop


buildAdrTable:
                WIN_BRK (void)
				di
                ld (.saveStack + 1), sp
                ld sp, TABLE_ADR_END
                
                ld hl, #C000 + (FX_H - 1) * SCR_W + SCR_W - 2

 				ld ixh, FX_H
         
                ld e, #10			; hi(#800 * 2) next line diff
.rowloop:		
				ld b, FX_W
.colloop
				ld c, h	: ld a, h	; store MSB screen adr
                
repeat 2
				push hl				; store screen adr
                add e : ld h, a		; next line		
rend
                push hl				; store screen adr
          
				ld h, c				; restore initial screen adr
                dec hl : dec l		; next char
 				djnz .colloop
                
                dec ixh
               	jr nz, .rowloop
             
.saveStack:		ld sp, 0
				ei
                ret

initHotSpots:
                ld b, 3
      
                WIN_BRK (void)
.loop:
				ld hl, buf + FX_W * (FX_H - 1)
                exx
                call rand8
                and 31
                exx
                ld e, a
                ld d, 0
                add hl, de
                
                exx
                call rand8 
                and 63
                exx 
                ld (hl), a
                inc hl
                djnz .loop
                ret

rand8
    ld      hl, (seed_ion)
    ld      a, r
    ld      d, a
    ld      e, a
    add     hl, de
    xor     l
    add     a
    xor     h
    ld      l, a
    ld      (seed_ion), hl
    ret

seed_ion:   dw 0x0 

palette:
	db Color.fm_0
	db Color.fm_3
    db Color.fm_6
	db Color.fm_6
	db Color.fm_15
	db Color.fm_24
	db Color.fm_15
	db Color.fm_24
	db Color.fm_24
    db Color.fm_25
    db Color.fm_25
    db Color.fm_25
    db Color.fm_26
    db Color.fm_26
    db Color.fm_26
    db Color.fm_26
	db Color.fm_0
align 256
pixels:
repeat #10, i
    v = i - 1
    repeat 4
        CPC_PIXEL v
    rend
  
rend


buf:
	ds FX_W * FX_H

end

buf2:
	ds 8 * 32, 0
    ds 4, 0, 1, 63, 27, 0
    ds 3, 0, 1, 63, 1, 0, 1, 63, 26, 0    
    ds 3, 0, 3, 63, 26, 0     
    ds 3, 0, 1, 63, 1, 0, 1, 63, 26, 0
    ds 13 * #20, 0

; SAVE ''fire.bin'', start,end-start, DSK, ''./dist/fire.dsk''     ',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
