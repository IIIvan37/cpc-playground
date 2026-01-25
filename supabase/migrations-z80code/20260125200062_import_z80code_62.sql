-- Migration: Import z80code projects batch 62
-- Projects 123 to 124
-- Generated: 2026-01-25T21:43:30.201657

-- Project 123: fruity-franck by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fruity-franck',
    'Imported from z80Code. Author: siko.',
    'public',
    false,
    false,
    '2020-06-19T00:36:13.789000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Palettes are wrong, and sound enveloppe too.
; Initialized by the basic loader


;run #1a34
run #40

org #40

ld hl,#100
ld de,reloc_area
ld bc,end_reloc_blk-begin_reloc_blk
ldir
jp #1a34

org #1400

db #dd,#6e,#00,#dd,#66,#01,#22 ;..n..f..
db #02,#bf,#21
lab140A db #0
db #bf,#22,#06,#bf,#21,#f3,#14,#22
db #00,#bf,#c9,#ed,#73,#04,#bf,#ed ;....s...
db #7b,#06,#bf,#c9,#dd,#2a,#75,#ae ;......u.
db #dd,#36,#03,#1e,#dd,#75,#04,#dd ;.....u..
db #74,#05,#ed,#73,#06,#bf,#ed,#7b ;t..s....
db #04,#bf,#c9
lab1436 or a
    sbc hl,de
    ld hl,0
    ret nz
    dec hl
    ret 
lab143F or a
    sbc hl,de
    ret z
    ld hl,#ffff
    ret 
lab1447 ex de,hl
lab1448 ld a,h
    xor d
    sbc hl,de
    rr h
    xor h
    ld hl,0
    ret p
    dec hl
    ret 
lab1455 ex de,hl
lab1456 ld a,h
    xor d
    sbc hl,de
    rr h
    xor h
    ld hl,0
    ret m
    dec hl
    ret 
lab1463 ld a,#10
    ld b,h
    ld c,l
lab1467 add hl,hl
    rl e
    rl d
    jr nc,lab146F
    add hl,bc
lab146F dec a
    jr nz,lab1467
    ret 
data1473 db #eb
lab1474 ld b,#10
    ld a,h
    ld c,l
    ld hl,0
lab147B sla c
    rla 
    adc hl,hl
    sbc hl,de
    jr nc,lab1486
    add hl,de
    dec c
lab1486 inc c
    djnz lab147B
    ex de,hl
    ld h,a
    ld l,c
    ret 
data148d db #0
lab148E ld a,h
    and d
    ld h,a
    ld a,l
    and e
    ld l,a
    ret 
lab1495 ld a,h
    or d
    ld h,a
    ld a,l
    or e
    ld l,a
    ret 
lab149C ld a,h
    xor d
    ld h,a
    ld a,l
    xor e
    ld l,a
    ret 
lab14A3 ld a,h
    rla 
    ret nc
    ld de,#01
    ex de,hl
    sbc hl,de
    ret 
lab14AD ld a,h
    or l
    ret z
    rl h
    ld hl,#01
    ret nc
    dec hl
    dec hl
    ret 
lab14B9 ld c,l
    ld hl,(#BF08)
    ld de,(#BF0A)
    ld a,h
    ld h,l
    ld l,d
    ld d,e
    rlca 
    ld e,a
    add hl,de
    ld (labBF0A),de
    ld de,lab5A59+1
    add hl,de
    ld (labBF08),hl
    ld e,l
    ld d,#0
    ld h,d
    ld l,d
    ld b,#8
lab14DA add hl,hl
    rl c
    jr nc,lab14E0
    add hl,de
lab14E0 djnz lab14DA
    ld l,h
    ld h,#0
    ret 
lab14E6 push hl
    ld a,h
    xor d
    sbc hl,de
    rr b
    xor b
    pop hl
    ret p
    ex de,hl
    ret 
lab14F2 jp (hl)
data14f3 db #c3
db #34,#1a,#18,#20
lab14F8 db #18
db #15
lab14FA db #44
db #16
lab14FC db #70
db #17
lab14FE db #7a
db #17
lab1500 db #8e
db #17
lab1502 db #d6
db #17
lab1504 db #1e
db #18
lab1506 db #66
db #18
lab1508 db #ae
db #18
lab150A db #f6
db #18
lab150C db #3e
db #19
lab150E db #86
db #19
lab1510 db #ce
db #19
lab1512 db #16
db #1a
lab1514 db #20
db #1a
lab1516 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab1786 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab179A db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab17B4 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00

start_1a34 ld hl,dataa754
    ld (lab1516),hl
    jr lab1A5C
data1a3c db #0
db #00
lab1A3E db #0
db #00
lab1A40 db #0
db #00
lab1A42 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab1A5C ld hl,labA757
    ld (data1a3c),hl
    ld hl,labA75A
    ld (lab1A3E),hl
    ld hl,labA75D
    ld (lab1A40),hl
    ld hl,#02
    ld de,(lab14FE)
    add hl,de
    ld de,#47
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#04
    ld de,(lab14FE)
    add hl,de
    ld de,#3F
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#06
    ld de,(lab14FE)
    add hl,de
    ld de,#001D
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#0008
    ld de,(lab14FE)
    add hl,de
    ld de,#001F
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000C
    ld de,(lab14FE)
    add hl,de
    ld de,#004A
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000E
    ld de,(lab14FE)
    add hl,de
    ld de,#004B
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#0010
    ld de,(lab14FE)
    add hl,de
    ld de,#0048
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#0012
    ld de,(lab14FE)
    add hl,de
    ld de,#49
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,0
    ld (lab1A42),hl
    jp lab5F0A
lab1AE7 jr lab1B09
data1ae9 db #0
db #00
lab1AEB db #0
db #00
lab1AED db #0
db #00
lab1AEF db #0
db #00
lab1AF1 db #0
db #00
lab1AF3 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab1B09 ld hl,#008C
    ld (data1ae9),hl
    ld hl,#0002
    ld (lab1AEB),hl
    ld hl,#0004
    ld (lab1AED),hl
    ld hl,#0001
    ld (lab1AEF),hl
    ld hl,#0003
    ld (lab1AF1),hl
    ld hl,#0031
    ld (lab1AF3),hl
    ld hl,0
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA733
lab1B3A jr lab1B5C
data1b3c db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab1B5C ld hl,#14
    ld (data1b3c),hl
lab1B62 ld hl,#0006
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld hl,0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#0007
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld hl,0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#000F
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld hl,0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#0021
    ld (labBF1E),hl
    ld hl,#0057
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#06
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labAB87
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#07
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,(lab1AF3)
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    jr lab1C16
data1bf6 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab1C16 ld hl,(data1bf6)
    ld de,#0006
    call lab1447
    push hl
    ld hl,(data1bf6)
    ld de,#0008+2
    call lab1448
    pop de
    call lab148E
    ld de,#fffe
    call lab148E
    ld de,#1E
    add hl,de
    ld (labBF1E),hl
    ld hl,#006B
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#0006
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labAB80
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#0007
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,(data1bf6)
    ld de,#0006
    call lab1447
    ld de,#0008
    call lab148E
    push hl
    ld hl,(data1bf6)
    ld de,#0008+1
    call lab1447
    ld de,#0008+2
    call lab148E
    pop de
    add hl,de
    ld de,labA566
    add hl,de
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    jr lab1CBF
data1c9f db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab1CBF ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab1CF4
    ld hl,#16
    ld (labBF1E),hl
    ld hl,#00BE
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labABA6
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
lab1CF4 ld hl,#06
    ld (labBF1E),hl
    ld hl,#11
    ld (labBF1C),hl
    ld hl,#11
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#07
    ld (labBF1E),hl
    ld hl,#18
    ld (labBF1C),hl
    ld hl,#18
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#0F
    ld (labBF1E),hl
    ld hl,#06
    ld (labBF1C),hl
    ld hl,#06
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
lab1D3F jr lab1D61
data1d41 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab1D61 ld hl,#01
    ld (data1d41),hl
    ld hl,#64
    ld (lab1D77+1),hl
lab1D6D call labBD19
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab1D77 ld de,0
    scf
    sbc hl,de
    jp c,lab1D6D
    ld hl,0
    ld (data1d41),hl
    ld hl,#0F
    ld (lab1DAC+1),hl
lab1D8C ld hl,(data1d41)
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld hl,0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab1DAC ld de,0
    scf
    sbc hl,de
    jp c,lab1D8C
    ld hl,0
lab1DB8 ld (labBF1E),hl
    ld ix,labBF1E
    call labA733
    jr lab1DE4
data1dc4 db #0
db #00
lab1DC6 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab1DE4 ld hl,0
    ld (data1dc4),hl
    ld hl,#08+1
    ld (lab1E3A+1),hl
lab1DF0 ld hl,0
    ld (lab1DC6),hl
    ld hl,#000b
    ld (lab1E2A+1),hl
lab1DFC ld hl,(data1ae9)
    ld (labBF1E),hl
    ld hl,(data1dc4)
    add hl,hl
    add hl,hl
    add hl,hl
    ld (labBF1C),hl
    ld hl,(lab1DC6)
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,#08
    add hl,de
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab1DC6)
    inc hl
    ld (lab1DC6),hl
lab1E2A ld de,0
    scf
    sbc hl,de
    jp c,lab1DFC
    ld hl,(data1dc4)
    inc hl
    ld (data1dc4),hl
lab1E3A ld de,0
    scf
    sbc hl,de
    jp c,lab1DF0
    ld hl,#27C
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,0
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#27C
    ld (labBF1E),hl
    ld hl,#18E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#278
    ld (labBF1E),hl
    ld hl,0
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#278
    ld (labBF1E),hl
    ld hl,#18E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,0
    ld (labBF1E),hl
    ld hl,#27C
    ld (labBF1C),hl
    ld hl,#18E
    ld (labBF1A),hl
    ld hl,#172
    ld (labBF18),hl
    ld ix,labBF18
    call labA730
    ld hl,0
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74B
    call labBBDB
    ld hl,#02
    ld (labBF1E),hl
    ld hl,#04
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#08
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA9E9
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#1A
    ld (labBF1E),hl
    ld hl,#04
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA9E4
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#44
    ld (labBF1E),hl
    ld hl,#16
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    call lab545C
    ld hl,#44
    ld (labBF1E),hl
    ld hl,#38
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    call lab548D
    ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab1F8E
    ld hl,#47
    ld (labBF1E),hl
    ld hl,#04
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#02
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labABA1
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    jp lab1FDC
lab1F8E ld hl,(lab1AF1)
    dec hl
    ld a,h
    or l
    jp z,lab1FDC
    ld hl,#02
    ld (data1d41),hl
    ld hl,(lab1AF1)
    ld (lab1FD3+1),hl
lab1FA3 ld hl,#26
    ld (labBF1E),hl
    ld hl,(data1d41)
    ld de,#04
    call lab1463
    ld de,#53
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld hl,0
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab1FD3 ld de,0
    scf
    sbc hl,de
    jp c,lab1FA3
lab1FDC ld hl,0
    ld (data1d41),hl
    ld hl,#95
    ld (lab200D+1),hl
lab1FE8 ld hl,(data1d41)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#64
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#01
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab200D ld de,0
    scf
    sbc hl,de
    jp c,lab1FE8
    jr lab2038
data2018 db #0
db #00
lab201A db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab2038 ld hl,#0F
    call lab14B9
    ld (data2018),hl
    ld hl,(data2018)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    ld (lab201A),hl
    ld hl,0
    ld (lab1DC6),hl
    ld hl,#08+1
    ld (lab2096+1),hl
lab205B ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data2018)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data2018)
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab1DC6)
    inc hl
    ld (lab1DC6),hl
lab2096 ld de,0
    scf
    sbc hl,de
    jp c,lab205B
    ld hl,0
    ld (lab1DC6),hl
    ld hl,#08+2
    ld (lab20D8+1),hl
lab20AB ld hl,0
    ld (labBF1E),hl
    ld hl,(lab201A)
    ld (labBF1C),hl
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,#13
    add hl,de
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(lab1DC6)
    inc hl
    ld (lab1DC6),hl
lab20D8 ld de,0
    scf
    sbc hl,de
    jp c,lab20AB
    ld hl,0
    ld (labBF1E),hl
    ld hl,(lab201A)
    ld (labBF1C),hl
    ld hl,#B5
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,0
    ld (data1dc4),hl
    ld hl,#0E
    ld (lab2147+1),hl
lab2109 ld hl,(data1dc4)
    ld de,#3C
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,0
    ld (labBF1E),hl
    ld hl,(data1dc4)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    ld (labBF1C),hl
    ld hl,#5B
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1dc4)
    inc hl
    ld (data1dc4),hl
lab2147 ld de,0
    scf
    sbc hl,de
    jp c,lab2109
    jr lab2172
data2152 db #0
db #00
lab2154 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab2172 ld hl,0
    ld (data2152),hl
    ld hl,#01
    ld (data1d41),hl
    ld hl,#08+2
    ld (lab21F3+1),hl
lab2184 call lab4408
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,(data1dc4)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,(lab1DC6)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    push hl
    ld hl,(data1dc4)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(lab1DC6)
    ld de,#12
    call lab1463
    ld de,#13
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab21F3 ld de,0
    scf
    sbc hl,de
    jp c,lab2184
    ld hl,#000b
    ld (data1d41),hl
    ld hl,#23
    ld (lab221E+1),hl
lab2208 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab221E ld de,0
    scf
    sbc hl,de
    jp c,lab2208
    ld hl,#01
    ld (lab2154),hl
    ld hl,(data1b3c)
    ld (lab22CC+1),hl
lab2233 ld hl,#08
    ld (data2152),hl
    ld hl,#08
    call lab14B9
    ld de,0
    call lab1436
    push hl
    ld hl,(lab2154)
    ld de,#14
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp z,lab2290
    ld hl,(lab1AED)
    call lab14B9
    ld de,#08+2
    add hl,de
    ld de,#FE
    call lab148E
    ld (data2152),hl
    ld hl,(data2152)
    ld de,#0C
    call lab1436
    push hl
    ld hl,(data2152)
    ld de,#10
    call lab1436
    pop de
    call lab1495
    ld de,#fffe
    call lab148E
    ld de,(data2152)
    add hl,de
    ld (data2152),hl
lab2290 ld hl,(data2152)
    srl h
    rr l
    ld de,#75
    add hl,de
    push hl
    ld hl,(data2152)
    ld de,#16
    call lab1436
    ld de,#02
    call lab148E
    pop de
    add hl,de
    push hl
    ld hl,(data2152)
    ld de,#18
    call lab1436
    ld de,#b
    call lab148E
    pop de
    add hl,de
    ld (data1d41),hl
    call lab4408
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab22CC ld de,0
    scf
    sbc hl,de
    jp c,lab2233
    jr lab22F7
data22d7 db #0
db #00
lab22D9 db #0
db #00
lab22DB db #0
db #00
lab22DD db #0
db #00
lab22DF db #0
db #00
lab22E1 db #0
db #00
lab22E3 db #0
db #00
lab22E5 db #0
db #00
lab22E7 db #0
db #00
lab22E9 db #0
db #00
lab22EB db #0
db #00
lab22ED db #0
db #00
lab22EF db #0
db #00
lab22F1 db #0
db #00
lab22F3 db #0
db #00
lab22F5 db #0
db #00
lab22F7 ld hl,#04
    ld (data22d7),hl
    ld hl,(data2018)
    ld (lab22D9),hl
    ld hl,#08+1
    ld (lab22DB),hl
    ld hl,0
    ld (lab22DD),hl
    ld hl,#22
    ld (lab22DF),hl
    ld hl,(lab201A)
    ld (lab22E1),hl
    ld hl,#B5
    ld (lab22E3),hl
    ld hl,#01
    ld (lab22E5),hl
    ld hl,0
    ld (lab22E7),hl
    ld hl,0
    ld (lab22E9),hl
    ld hl,0
    ld (lab22EB),hl
    ld hl,0
    ld (lab22ED),hl
    ld hl,0
    ld (lab22EF),hl
    ld hl,#74
    ld (lab22F1),hl
    ld hl,#05
    ld (lab22F3),hl
    ld hl,0
    ld (lab22F5),hl
    jr lab2379
data2359 db #0
db #00
lab235B db #0
db #00
lab235D db #0
db #00
lab235F db #0
db #00
lab2361 db #0
db #00
lab2363 db #0
db #00
lab2365 db #0
db #00
lab2367 db #0
db #00
lab2369 db #0
db #00
lab236B db #0
db #00
lab236D db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab2379 ld hl,0
    ld (data2359),hl
    ld hl,0
    ld (lab235B),hl
    ld hl,#14
    ld (lab235D),hl
    ld hl,#4B0
    ld (lab235F),hl
    ld hl,0
    ld (lab2361),hl
    ld hl,0
    ld (lab2363),hl
    ld hl,0
    ld (lab2365),hl
    ld hl,(data1ae9)
    ld de,lab8374
    add hl,de
    ld l,(hl)
    ld h,#0
    push hl
    ld hl,(data1ae9)
    ld de,lab8375
    add hl,de
    ld l,(hl)
    ld h,#0
    ld de,#100
    call lab1463
    pop de
    add hl,de
    ld de,lab8000
    add hl,de
    ld (lab2367),hl
    ld hl,(lab2367)
    ld (lab2369),hl
    ld hl,#02
    ld (lab236B),hl
    ld hl,#01
    ld (data1d41),hl
    ld hl,#04
    ld (lab23F5+1),hl
lab23DF ld hl,(data1d41)
    add hl,hl
    ld de,(lab14FC)
    add hl,de
    ld de,0
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab23F5 ld de,0
    scf
    sbc hl,de
    jp c,lab23DF
    ld hl,#01
    ld (lab236D),hl
    ld hl,#03
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,0
    ld (labBF1E),hl
    ld hl,#18E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#1DA
    ld (labBF1E),hl
    ld hl,#18E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#1DA
    ld (labBF1E),hl
    ld hl,#172
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,0
    ld (labBF1E),hl
    ld hl,#172
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,0
    ld (labBF1E),hl
    ld hl,#18E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,0
    ld (data1d41),hl
    ld hl,#0F
    ld (lab24AA+1),hl
lab247C ld hl,(data1d41)
    ld (labBF1E),hl
    ld hl,(data1d41)
    ld de,lab9000
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1C),hl
    ld hl,(data1d41)
    ld de,lab9000
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab24AA ld de,0
    scf
    sbc hl,de
    jp c,lab247C
    ld hl,#b
    ld (labBF1E),hl
    ld hl,(data1ae9)
    srl h
    rr l
    ld de,labA997
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1C),hl
    ld hl,(data1ae9)
    srl h
    rr l
    ld de,labA997
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    jp lab2C91
lab24E5 jr lab2507
data24e7 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab2507 ld hl,#01
    ld (data24e7),hl
    call lab4EAB
    ld hl,#02
    ld (data1d41),hl
    call lab2EBB
    ld hl,(lab22EF)
    ld a,h
    or l
    jp z,lab2538
    ld hl,(lab22EF)
    ld de,#C8
    call lab1448
    ld de,(lab22EF)
    ex de,hl
    or a
    sbc hl,de
    ld (lab22EF),hl
    jp lab259D
lab2538 ld hl,(data22d7)
    ld de,#03
    call lab148E
    ld de,0
    call lab1436
    ld a,h
    or l
    jp z,lab259D
    ld hl,(data2018)
    ld de,#3C
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,0
    call lab1436
    ld a,h
    or l
    jp z,lab259D
    ld hl,(data22d7)
    ld de,#04
    call lab148E
    ld de,0
    call lab1436
    ld de,#03
    call lab148E
    ld de,(lab1516)
    add hl,de
    push hl
    ld hl,#32
    ld (labBF1E),hl
    ld hl,(lab201A)
    ld (labBF1C),hl
    ld hl,#5B
    ld (labBF1A),hl
    ld ix,labBF1A
    pop hl
    call lab14F2
lab259D ld hl,(lab2361)
    ld a,h
    or l
    jp z,lab25D6
    ld hl,(lab2361)
    dec hl
    ld (lab2361),hl
    ld hl,(lab2361)
    ld de,0
    call lab1436
    ld a,h
    or l
    jp z,lab25D6
    ld hl,#58
    ld (labBF1E),hl
    ld hl,#3C
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
lab25D6 ld hl,(lab22EB)
    ld a,h
    or l
    jp z,lab2624
    jr lab2600
data25e0 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab2600 ld hl,0
    ld (data25e0),hl
    ld hl,(lab22EB)
    dec hl
    ld (lab22EB),hl
    ld hl,(lab22EB)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab2624
    ld hl,#000
    ld (lab22E9),hl
    call lab479F
lab2624 jr lab2646
data2626 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab2646 ld hl,(data2626)
    ld a,h
    or l
    jp z,lab2663
    ld hl,(data2626)
    dec hl
    ld (data2626),hl
    ld hl,(data2626)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab5A73
lab2663 ld hl,(data22d7)
    inc hl
    ld (data22d7),hl
    ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab2D1C
    ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab26BA
    jr lab26A2
data2682 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab26A2 ld hl,data2682
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74E
    ld hl,(data2682)
    ld a,h
    or l
    jp nz,lab5F6F
    jp lab26D5
lab26BA ld hl,#1B
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp nz,lab5E66
lab26D5 call lab58B1
    ld hl,(lab22DD)
    ld a,h
    or l
    jp z,lab270F
    ld hl,(lab22E7)
    add hl,hl
    add hl,hl
    ld de,(lab22E7)
    add hl,de
    ld de,(lab22E5)
    add hl,de
    ld de,(data2152)
    ex de,hl
    or a
    sbc hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data1dc4),hl
    ld hl,(data1dc4)
    ld a,h
    or l
    jp z,lab270F
    call lab58E8
lab270F ld hl,(lab22DD)
    ld a,h
    or l
    jp nz,lab2AD8
    ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab2753
    ld hl,#08
    ld (data2152),hl
    call lab5E9A
    jr lab274A
data272a db #0
db #00
lab272C db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab274A ld hl,(lab272C)
    ld (data272a),hl
    jp lab281E
lab2753 ld hl,#000
    ld (data272a),hl
    jr lab277B
data275b db #0
db #00
lab275D db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab277B ld hl,lab7FFF
    ld (data275b),hl
    ld hl,#01
    ld (data1d41),hl
    ld hl,#04
    ld (lab2815+1),hl
lab278D ld hl,(lab275D)
    ld de,#05
    call lab1463
    ld de,(data1d41)
    add hl,de
    add hl,hl
    ld de,(lab14FE)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab27FF
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab14FC)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    ld (data2152),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab14FC)
    add hl,de
    ld de,(data2152)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    ld de,(data275b)
    call lab1448
    ld a,h
    or l
    jp z,lab27FC
    ld hl,(data2152)
    ld (data275b),hl
    ld hl,(data1d41)
    ld (data272a),hl
    jp lab27FC
lab27FC jp lab280E
lab27FF ld hl,(data1d41)
    add hl,hl
    ld de,(lab14FC)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab280E ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab2815 ld de,#000
    scf
    sbc hl,de
    jp c,lab278D
lab281E ld hl,(data272a)
    dec l
    jp z,lab2834
    dec l
    jp z,lab2857
    dec l
    jp z,lab287E
    dec l
    jp z,lab28A1
    jp lab2D1C
lab2834 ld hl,(lab22D9)
    ld a,h
    or l
    jp z,lab2854
    ld hl,#1A
    ld (lab22DF),hl
    ld hl,#ffff
    ld (lab22E5),hl
    ld hl,#000
    ld (lab22E7),hl
    jp lab28C5
data2851 db #c3
db #57,#28 ;W.
lab2854 jp lab2D1C
lab2857 ld hl,(lab22D9)
    ld de,#fff2
    add hl,de
    ld a,h
    or l
    jp z,lab287B
    ld hl,#22
    ld (lab22DF),hl
    ld hl,#01
    ld (lab22E5),hl
    ld hl,#000
    ld (lab22E7),hl
    jp lab28C5
data2878 db #c3
db #7e,#28
lab287B jp lab2D1C
lab287E ld hl,(lab22DB)
    ld a,h
    or l
    jp z,lab289E
    ld hl,#2A
    ld (lab22DF),hl
    ld hl,#000
    ld (lab22E5),hl
    ld hl,#fffd
    ld (lab22E7),hl
    jp lab28C5
data289b db #c3
db #a1,#28
lab289E jp lab2D1C
lab28A1 ld hl,(lab22DB)
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp z,lab28C2
    ld hl,#2A
    ld (lab22DF),hl
    ld hl,#000
    ld (lab22E5),hl
    ld hl,#03
    ld (lab22E7),hl
    jp lab28C5
lab28C2 jp lab2D1C
lab28C5 ld hl,(lab22D9)
    ld de,(lab22E5)
    add hl,de
    ld (data1dc4),hl
    ld hl,(lab22E7)
    call lab14AD
    ld de,(lab22DB)
    add hl,de
    ld (lab1DC6),hl
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2152),hl
    ld hl,(data2152)
    ld de,#64
    call lab1448
    ld de,(data2152)
    call lab148E
    ld a,h
    or l
    jp z,lab29B7
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#05
    call lab1448
    ld a,h
    or l
    jp z,lab29B7
    ld hl,(data1dc4)
    ld de,(lab22E5)
    add hl,de
    ld de,#0F
    call lab148E
    ld de,#0F
    call lab1436
    ld de,(lab22E7)
    call lab1495
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab2D1C
    ld hl,(data1dc4)
    ld de,(lab22E5)
    add hl,de
    push hl
    ld hl,(lab22E7)
    call lab14AD
    ld de,(lab1DC6)
    add hl,de
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    ld (lab2154),hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab2D1C
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data2152)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    ld (lab22ED),hl
lab29B7 ld hl,(lab22E7)
    ld a,h
    or l
    jp z,lab29ED
    ld hl,#06
    ld (lab22DD),hl
    ld hl,(lab22E7)
    ld de,#000
    call lab1448
    ld de,(lab22DB)
    add hl,de
    ld de,#0F
    call lab1463
    ld de,(lab22D9)
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab29F3
lab29ED ld hl,#05
    ld (lab22DD),hl
lab29F3 ld hl,(data1dc4)
    ld de,(data2018)
    call lab1436
    push hl
    ld hl,(lab1DC6)
    ld de,#04
    call lab1436
    pop de
    call lab148E
    push hl
    ld hl,(lab22EF)
    ld de,#000
    call lab1436
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab2A55
    ld hl,#01
    ld (lab22EF),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#02
    ld (labBF1C),hl
    ld hl,#02
    ld (labBF1A),hl
    ld hl,#96
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0F
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
lab2A55 ld hl,(data1dc4)
    ld (lab22D9),hl
    ld hl,(lab1DC6)
    ld (lab22DB),hl
    ld hl,(data2152)
    ld a,h
    or l
    jp z,lab2AB8
    jr lab2A8B
data2a6b db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab2A8B ld hl,(lab22E1)
    ld de,(lab22E5)
    add hl,de
    ld (data2a6b),hl
    ld hl,(lab22E3)
    ld de,(lab22E7)
    add hl,de
    ld (data24e7),hl
    ld hl,(data2152)
    ld (data1dc4),hl
    call lab5903
    ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab2EA6
lab2AB8 ld hl,(data2152)
    ld de,#78
    call lab1447
    ld a,h
    or l
    jp z,lab2AD8
    ld hl,(data2152)
    ld de,#ff88
    add hl,de
    ld (data2359),hl
    ld hl,(lab22E7)
    ld a,h
    or l
    jp nz,lab2BB5
lab2AD8 ld hl,(data2359)
    ld a,h
    or l
    jp z,lab2BB5
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22D9)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    ld (labBF1C),hl
    ld hl,(lab22DB)
    ld de,#12
    call lab1463
    ld de,#13
    add hl,de
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(lab22DB)
    ld de,#0F
    call lab1463
    ld de,(lab22D9)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    jr lab2B4A
data2b2a db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab2B4A ld hl,(data2b2a)
    ld de,(data2359)
    add hl,de
    ld (data2b2a),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#02
    ld (labBF1C),hl
    ld hl,#02
    ld (labBF1A),hl
    ld hl,(data2359)
    ld de,#05
    call lab1463
    ld de,#64
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(data2359)
    ld de,#14
    call lab1436
    ld de,#28
    call lab148E
    pop de
    add hl,de
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0F
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#000
    ld (data2359),hl
    call lab5348
    ld hl,(data1b3c)
    dec hl
    ld (data1b3c),hl
lab2BB5 ld hl,(lab22EB)
    ld a,h
    or l
    jp z,lab2BF9
    ld hl,(lab22E5)
    ld (data25e0),hl
    ld hl,(lab22E3)
    ld de,(lab22E7)
    add hl,de
    ld de,#fff8
    call lab148E
    push hl
    ld hl,(lab22E3)
    ld de,#fff8
    call lab148E
    pop de
    ex de,hl
    or a
    sbc hl,de
    ld a,h
    or l
    jp z,lab2BF9
    ld hl,(lab22E7)
    call lab14AD
    ld de,#50
    call lab1463
    ld de,(data25e0)
    add hl,de
    ld (data25e0),hl
lab2BF9 ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22E1)
    ld (labBF1C),hl
    ld hl,(lab22E3)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(lab22E1)
    ld de,(lab22E5)
    add hl,de
    ld (lab22E1),hl
    ld hl,(lab22E3)
    ld de,(lab22E7)
    add hl,de
    ld (lab22E3),hl
    ld hl,(lab22DD)
    dec hl
    ld (lab22DD),hl
    ld hl,(lab22DD)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab2C91
    ld hl,(lab22DB)
    ld de,#0F
    call lab1463
    ld de,(lab22D9)
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab1436
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(lab22ED)
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp z,lab2C91
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab2C91 call lab58B1
    ld hl,(lab22ED)
    ld a,h
    or l
    jp z,lab2D0B
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22E5)
    ld de,#05
    call lab1463
    ld de,(lab22E1)
    add hl,de
    ld (labBF1C),hl
    ld hl,(lab22E3)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab22DD)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab2D0B
    ld hl,(lab22ED)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    push hl
    ld hl,(lab22D9)
    ld de,(lab22E5)
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab22ED)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    push hl
    ld hl,(lab22E5)
    ld de,#05
    call lab1463
    ld de,(lab22E1)
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (lab22ED),hl
lab2D0B call lab479F
    ld hl,(data1b3c)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab5BA1
lab2D1C ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld de,(lab22E9)
    call lab1495
    push hl
    ld hl,#36
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab2EA6
    ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab2D60
    ld hl,#02
    ld (data2152),hl
    call lab5E9A
    ld hl,(lab272C)
    ld (data2682),hl
    jp lab2DA7
lab2D60 ld hl,(lab275D)
    ld de,#3A
    call lab1463
    ld de,#13
    add hl,de
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(lab275D)
    ld de,#39
    call lab1463
    ld de,#13
    add hl,de
    ld (labBF1E),hl
    ld hl,lab1A42
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld de,(lab1A42)
    call lab1495
    ld (data2682),hl
lab2DA7 ld hl,(data2682)
    ld a,h
    or l
    jp z,lab2E49
    ld hl,#04
    ld (lab22E9),hl
    jr lab2DD7
data2db7 db #0
db #00
lab2DB9 db #0
db #00
lab2DBB db #0
db #00
lab2DBD db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab2DD7 ld hl,(lab22E5)
    add hl,hl
    dec hl
    call lab14AD
    ld (data2db7),hl
    ld hl,(lab22E7)
    inc hl
    call lab14AD
    ld de,#03
    call lab1463
    ld (lab2DB9),hl
    ld hl,(lab22E1)
    dec hl
    push hl
    ld hl,(lab22E5)
    ld de,#000
    call lab1447
    pop de
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(lab22E5)
    ld de,#000
    call lab1456
    ld de,#04
    call lab148E
    pop de
    add hl,de
    ld (lab2DBB),hl
    ld hl,(lab22E3)
    dec hl
    dec hl
    push hl
    ld hl,(lab22E7)
    ld de,#000
    call lab1436
    ld de,#06
    call lab148E
    pop de
    add hl,de
    push hl
    ld hl,(lab22E7)
    ld de,#000
    call lab1447
    ld de,#0F
    call lab148E
    pop de
    add hl,de
    ld (lab2DBD),hl
    jp lab2E4C
lab2E49 jp lab2EA6
lab2E4C ld hl,data2682
    ld (labBF1E),hl
    ld hl,#42
    ld (labBF1C),hl
    ld hl,(lab2DBB)
    ld de,(data2db7)
    add hl,de
    ld (labBF1A),hl
    ld hl,(lab2DBD)
    ld de,(lab2DB9)
    add hl,de
    ld (labBF18),hl
    ld ix,labBF18
    ld hl,(lab1A3E)
    call lab14F2
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab2E9A
    ld hl,(lab2DBB)
    ld de,(data2db7)
    or a
    sbc hl,de
    ld (lab2DBB),hl
    ld hl,(lab2DBD)
    ld de,(lab2DB9)
    or a
    sbc hl,de
    ld (lab2DBD),hl
lab2E9A call lab479F
    ld hl,#000
    ld (data2682),hl
    call lab4F31
lab2EA6 ld hl,#000
    ld (data24e7),hl
    call lab4EAB
    ld hl,#01
    ld (data1d41),hl
    call lab2EBB
    jp lab3DB5
lab2EBB ld hl,(data1d41)
    ld (data1d41),hl
    ld hl,#23
    ld (lab3DAB+1),hl
lab2EC7 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec l
    jp z,lab30B8
    dec l
    jp z,lab335F
    dec l
    jp z,lab3476
    dec l
    jp z,lab3D9D
    dec l
    jp z,lab3577
    dec l
    jp z,lab3577
    dec l
    jp z,lab3A22
    dec l
    jp z,lab390D
    dec l
    jp z,lab35E4
    dec l
    jp z,lab35E4
    dec l
    jp z,lab3BAD
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,#02
    ld (hl),e
    inc hl
    ld (hl),d
lab2F1E ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#08+1
    call lab1436
    push hl
    ld hl,(data1d41)
    ld de,(lab22ED)
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab308B
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2152),hl
    ld hl,(data2152)
    ld de,#63
    call lab1447
    push hl
    ld hl,(data2152)
    ld de,#ff92
    add hl,de
    pop de
    call lab148E
    push hl
    ld hl,(data2152)
    ld de,#b
    call lab1448
    ld de,(data2152)
    call lab148E
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab308B
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
lab2FEE call lab1436
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#02
    call lab1436
    ld a,h
    or l
    jp z,lab304C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#03
    call lab1447
    ld a,h
    or l
    jp nz,lab308B
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,#02
    ld (hl),e
    inc hl
    ld (hl),d
    call lab5DE6
    jp lab3067
lab304C ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3067
    call lab5E2E
lab3067 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp nz,lab3D9D
    jp lab2EC7
lab307C ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab308B call lab5DE6
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#03
    call lab1448
    ld a,h
    or l
    jp nz,lab3D9D
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#03
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab3D9D
lab30B8 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp nz,lab3266
lab30CA ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2152),hl
    ld hl,(data2152)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab31CA
    ld hl,(data2152)
    ld de,#6E
    call lab1436
    ld a,h
    or l
    jp z,lab3174
    jr lab3139
data3119 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab3139 ld hl,(data3119)
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp z,lab3171
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2a6b),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    push hl
    ld hl,(data2a6b)
    add hl,hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    call lab4CE2
    jp lab31CA
data316e db #c3
db #74,#31 ;t.
lab3171 jp lab307C
lab3174 ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#05
    call lab1448
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#b
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab307C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2a6b),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    push hl
    ld hl,(data2a6b)
    add hl,hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    call lab492F
lab31CA ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#07
    ex de,hl
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#01
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
lab3266 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab335C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab2F1E
lab335C jp lab3D9D
lab335F ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#03
    call lab148E
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3473
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0C
    call lab1436
    ld a,h
    or l
    jp z,lab3473
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    call lab5E2E
    jp lab30CA
lab3473 jp lab3D9D
lab3476 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#08
    call lab1436
    ld a,h
    or l
    jp z,lab351C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab3574
lab351C ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#01
    call lab148E
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3574
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
lab3574 jp lab3D9D
lab3577 ld hl,(data22d7)
    ld de,(data1d41)
    call lab149C
    ld de,#01
    call lab148E
    ld a,h
    or l
    jp nz,lab3D9D
    ld hl,(lab22EF)
    ld de,#C8
    call lab1448
    ld de,(lab22EF)
    call lab148E
    ld a,h
    or l
    jp z,lab35E4
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab35E4
    jr lab35DB
data35bb db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab35DB ld hl,#000
    ld (data35bb),hl
    jp lab37A7
lab35E4 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp z,lab35FF
    ld hl,#01
    ld (data35bb),hl
    jp lab3702
lab35FF ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    add hl,de
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (lab2154),hl
    ld hl,#04
    call lab14B9
    ld a,h
    or l
    jp z,lab365C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2a6b),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data24e7),hl
    call lab457F
    ld hl,(data35bb)
    ld a,h
    or l
    jp nz,lab3702
lab365C ld hl,#02
    call lab14B9
    ld a,h
    or l
    jp z,lab367B
    call lab44C5
    ld hl,(data35bb)
    ld a,h
    or l
    jp z,lab3675
    jp lab3678
lab3675 call lab4507
lab3678 jp lab368F
lab367B call lab4507
    ld hl,(data35bb)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab368F
    call lab44C5
lab368F ld hl,(data35bb)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3702
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#1E
    call lab1436
    ld a,h
    or l
    jp z,lab36CA
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld de,#fffa
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab37A7
data36c7 db #c3
db #02,#37
lab36CA ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1456
    pop de
    ex de,hl
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab37A7
lab3702 ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
lab37A7 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    add hl,hl
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld de,#06
    call lab148E
    pop de
    add hl,de
    push hl
    ld hl,(data22d7)
    ld de,#02
    call lab148E
    pop de
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#08
    call lab1447
    ld de,#2A
    call lab148E
    pop de
    add hl,de
    ld de,#36
    add hl,de
    push hl
    ld hl,(data1d41)
    ld de,#23
    call lab1436
    ld de,#0C
    call lab148E
    pop de
    add hl,de
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data1d41)
    ld de,#23
    call lab1436
    ld a,h
    or l
    jp z,lab3892
    ld hl,(lab22F1)
    ld (labBF1E),hl
    ld hl,#46
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    ld (labBF1C),hl
    ld hl,#46
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,#46
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    pop de
    add hl,de
    ld de,#04
    add hl,de
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
lab3892 ld hl,(data35bb)
    ld a,h
    or l
    jp z,lab390A
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab390A
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    call lab14AD
    pop de
    ex de,hl
    or a
    sbc hl,de
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab390A jp lab3D9D
lab390D ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3973
    call lab4DEF
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    add hl,de
    ld de,(data25e0)
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab22EB)
    ld a,h
    or l
    jp nz,lab3A98
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab3D9D
lab3973 ld hl,(lab22E1)
    srl h
    rr l
    inc hl
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    ex de,hl
    or a
    sbc hl,de
    call lab14A3
    push hl
    ld hl,(lab22E3)
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    inc hl
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    ex de,hl
    or a
    sbc hl,de
    call lab14A3
    pop de
    call lab14E6
    ex de,hl
    ld de,(lab22EB)
    call lab1448
    ld a,h
    or l
    jp nz,lab3D9D
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(lab22E3)
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ld de,#50
    call lab1463
    ld de,(lab22E1)
    add hl,de
    ld de,#c053
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(lab22EB)
    call lab1463
    pop de
    ex de,hl
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab3A98
lab3A22 call lab4DEF
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3A6C
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab3D9D
lab3A6C ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
lab3A98 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld l,(hl)
    ld h,#0
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#CF
    ld (hl),e
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#800
    add hl,de
    ld l,(hl)
    ld h,#0
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#800
    add hl,de
    ld de,#CF
    ld (hl),e
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#1000
    add hl,de
    ld l,(hl)
    ld h,#0
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#1000
    add hl,de
    ld de,#CF
    ld (hl),e
    jp lab3D9D
lab3B3B call lab5DE6
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#08+1
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#66
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    jp lab3D9D
lab3BAD ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3CB9
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    ld (lab1DC6),hl
    ld hl,(lab1DC6)
    ld de,#08+1
    call lab1447
    ld a,h
    or l
    jp nz,lab3B3B
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#04
    call lab1436
    pop de
    call lab1495
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab3B3B
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,(lab1DC6)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab1436
    pop de
    ex de,hl
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,#06
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    ld de,#fff1
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab3CB9 ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    inc hl
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#0C
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab3D9D
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab3D9D ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab3DAB ld de,#000
    scf
    sbc hl,de
    jp c,lab2EC7
    ret 
lab3DB5 ld hl,(lab2365)
    dec l
    jp z,lab3DE4
    dec l
    jp z,lab3EDF
    ld hl,#04
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA73F
    ld hl,(data2682)
    ld de,#80
    call lab148E
    ld a,h
    or l
    jp nz,lab3EDF
    jp lab3E15
lab3DE4 jr lab3E06
data3de6 db #0
db #00,#f1,#19,#0a,#20,#fa,#f5,#10
db #29,#f4,#19,#1e,#2c,#19,#6b,#01 ;......k.
db #83,#20,#1c,#12,#a7,#2c,#14,#01
db #83,#20,#1c,#03,#a7,#2c,#1c
lab3E06 ld hl,(data3de6)
    dec hl
    ld (data3de6),hl
    ld hl,(data3de6)
    ld a,h
    or l
    jp nz,lab3EDF
lab3E15 ld hl,(lab2369)
    ld l,(hl)
    ld h,#0
    ld (data2152),hl
    ld hl,(data2152)
    ld de,#0C
    call lab1436
    ld a,h
    or l
    jp z,lab3E32
    ld hl,#10C
    ld (data2152),hl
lab3E32 ld hl,(lab2369)
    inc hl
    ld l,(hl)
    ld h,#0
    ld (data3de6),hl
    ld hl,(lab2369)
    inc hl
    inc hl
    ld (lab2369),hl
    ld hl,(data3de6)
    ld a,h
    or l
    jp z,lab3EC9
    ld hl,#01
    ld (lab2365),hl
    ld hl,(data2152)
    ld a,h
    or l
    jp z,lab3E95
    ld hl,#84
    ld (labBF1E),hl
    ld hl,#b
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,(data2152)
    ld de,(lab236B)
    call lab1463
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0C
    ld (labBF14),hl
    ld hl,#58
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    jp lab3EC6
lab3E95 ld hl,#84
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#000
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
lab3EC6 jp lab3EDF
lab3EC9 ld hl,(lab2367)
    ld (lab2369),hl
    ld hl,#03
    ld de,(lab236B)
    or a
    sbc hl,de
    ld (lab236B),hl
    jp lab3E15
lab3EDF ld hl,(lab22EF)
    ld a,h
    or l
    jp z,lab3F3F
    ld hl,#46
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp z,lab3F3F
    ld hl,(lab22F1)
    ld de,#7E
    call lab1448
    push hl
    ld hl,(data2018)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    pop de
    call lab148E
    push hl
    ld hl,(data2018)
    ld de,(lab22D9)
    or a
    sbc hl,de
    call lab14A3
    ld de,(lab22DB)
    add hl,de
    ld de,#03
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab432B
lab3F3F ld hl,(lab235B)
    inc hl
    ld (lab235B),hl
    ld hl,(lab235B)
    ld de,(lab235D)
    or a
    sbc hl,de
    ld a,h
    or l
    jp nz,lab24E5
    ld hl,#000
    ld (lab235B),hl
    ld hl,(lab22F5)
    ld de,#000
    call lab1436
    push hl
    ld hl,(data22d7)
    ld de,(lab235F)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab4097
    ld hl,(lab22EF)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab4097
    ld hl,(data2018)
    ld de,#3C
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp nz,lab43FE
    ld hl,#b
    ld (data1d41),hl
    ld hl,(lab1AEB)
    ld de,#08+2
    add hl,de
    ld (lab3FC9+1),hl
lab3FAC ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    ld a,h
    or l
    jp z,lab3FDB
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab3FC9 ld de,#000
    scf
    sbc hl,de
    jp c,lab3FAC
    ld hl,#15
    ld (lab235D),hl
    jp lab4097
lab3FDB ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#05
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,(data2018)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld de,(lab201A)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld de,#5B
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2018)
    ld de,#3C
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#3C
    ld (labBF1E),hl
    ld hl,(lab201A)
    ld (labBF1C),hl
    ld hl,#5B
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    jp lab24E5
lab4097 ld hl,#0E
    call lab14B9
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    call lab148E
    push hl
    ld hl,(data2152)
    ld de,#0F
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    ld de,#0F
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    call lab148E
    pop de
    call lab1495
    push hl
    ld hl,(data2152)
    ld de,(lab22D9)
    or a
    sbc hl,de
    call lab14A3
    ld de,(lab22DB)
    add hl,de
    ld de,#06
    call lab1448
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab43FE
    ld hl,(lab22F5)
    ld de,#000
    call lab1436
    push hl
    ld hl,(data22d7)
    ld de,(lab235F)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab41E9
    jr lab4158
data4138 db #0
db #00
lab413A db #0
db #00
lab413C db #0
db #00
lab413E db #0
db #00,#c1,#ef,#0e,#01,#9e,#20,#0b
db #00,#00,#c9,#ef,#0f,#ec,#20,#19
db #0a,#01,#9f,#20,#1e,#f4,#01,#01
db #0b
lab4158 ld hl,(data2152)
    ld (data4138),hl
    ld hl,#000
    ld (lab413A),hl
    ld hl,(data2152)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    ld (lab22F5),hl
    ld hl,#13
    ld (lab413C),hl
    ld hl,#000
    ld (lab413E),hl
    ld hl,#08+1
    ld (data3119),hl
    ld hl,#10
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,#13
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#6E
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#81
    ld (labBF1E),hl
    ld hl,#07
    ld (labBF1C),hl
    ld hl,#07
    ld (labBF1A),hl
    ld hl,#3C
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0C
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#28
    ld (lab2363),hl
    jp lab24E5
lab41E9 ld hl,#1F
    ld (data1d41),hl
    ld hl,(lab1AEB)
    srl h
    rr l
    ld de,#1E
    add hl,de
    ld (lab421A+1),hl
lab41FD ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    ld a,h
    or l
    jp z,lab422C
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab421A ld de,#000
    scf
    sbc hl,de
    jp c,lab41FD
    ld hl,#50
    ld (lab235D),hl
    jp lab24E5
lab422C ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#b
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,(data2152)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    push hl
    ld hl,(data2152)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld de,#13
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab1436
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#0C
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,#13
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#81
    ld (labBF1E),hl
    ld hl,#07
    ld (labBF1C),hl
    ld hl,#07
    ld (labBF1A),hl
    ld hl,#50
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0C
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,(data1d41)
    ld (lab2363),hl
    jp lab24E5
lab432B ld hl,#46
    ld de,(lab150C)
    add hl,de
    ld de,#08+1
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab22F1)
    inc hl
    inc hl
    ld (lab22F1),hl
    ld hl,#46
    ld de,(lab1500)
    add hl,de
    ld de,(data2018)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab1502)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab1508)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab150A)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab1504)
    add hl,de
    ld de,(lab201A)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab1506)
    add hl,de
    ld de,#13
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab150E)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#46
    ld de,(lab1510)
    add hl,de
    ld de,#32
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2018)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#23
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#72
    ld (labBF1E),hl
    ld hl,(lab201A)
    ld (labBF1C),hl
    ld hl,#13
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab22F1)
    ld (labBF1E),hl
    ld hl,(lab201A)
    inc hl
    ld (labBF1C),hl
    ld hl,#16
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    jp lab24E5
lab43FE ld hl,(lab235D)
    dec hl
    ld (lab235B),hl
    jp lab24E5
lab4408 ld hl,#0F
    call lab14B9
    ld (data1dc4),hl
    ld hl,#08+2
    call lab14B9
    ld (lab1DC6),hl
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#ff9c
    add hl,de
    ld a,h
    or l
    jp nz,lab4408
    ld hl,(data2152)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab447B
    ld hl,(lab1DC6)
    ld de,#07
    call lab1447
    ld a,h
    or l
    jp nz,lab4408
    ld hl,(lab1DC6)
    inc hl
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab4408
lab447B ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    ld (labBF1E),hl
    ld hl,(data1dc4)
    ld de,#05
    call lab1463
    inc hl
    inc hl
    ld (labBF1C),hl
    ld hl,(lab1DC6)
    ld de,#12
    call lab1463
    ld de,#13
    add hl,de
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ret 
lab44C5 ld hl,#000
    ld (data2a6b),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(lab22DB)
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(data1d41)
    ld de,#23
    call lab143F
    pop de
    call lab148E
    push hl
    ld hl,#03
    call lab14B9
    pop de
    add hl,de
    dec hl
    call lab14AD
    ld de,#03
    call lab1463
    ld (data24e7),hl
    jp lab4540
lab4507 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(lab22D9)
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(data1d41)
    ld de,#23
    call lab143F
    pop de
    call lab148E
    push hl
    ld hl,#03
    call lab14B9
    pop de
    add hl,de
    dec hl
    call lab14AD
    ld (data2a6b),hl
    ld hl,#000
    ld (data24e7),hl
lab4540 ld hl,#06
    call lab14B9
    ld de,#000
    call lab1436
    push hl
    ld hl,(data2a6b)
    ld de,(data24e7)
    add hl,de
    ld de,(lab2154)
    call lab1436
    pop de
    call lab149C
    ld a,h
    or l
    jp z,lab457F
    ld hl,(data2a6b)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (data2a6b),hl
    ld hl,(data24e7)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (data24e7),hl
lab457F ld hl,#000
    ld (data35bb),hl
    ld hl,(data2a6b)
    ld de,(data24e7)
    add hl,de
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab4599
    ret 
lab4599 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(data2a6b)
    add hl,de
    ld (data1dc4),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data24e7)
    call lab14AD
    pop de
    add hl,de
    ld (lab1DC6),hl
    ld hl,(data1dc4)
    ld de,#0F
    call lab148E
    ld de,#0F
    call lab1436
    push hl
    ld hl,(lab1DC6)
    ld de,#000
    call lab1448
    pop de
    call lab1495
    push hl
    ld hl,(lab1DC6)
    ld de,#08+1
    call lab1447
    pop de
    call lab1495
    ld a,h
    or l
    jp z,lab45F8
    ret 
lab45F8 ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1456
    pop de
    call lab1495
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab464C
    ret 
lab464C ld hl,(data24e7)
    ld a,h
    or l
    jp z,lab46BD
    ld hl,(data24e7)
    ld de,#000
    call lab1447
    ld de,(lab1DC6)
    add hl,de
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp z,lab46BD
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1456
    ld a,h
    or l
    jp z,lab4698
    ret 
data4695 db #c3
db #bd,#46 ;.F
lab4698 ld hl,(data24e7)
    ld de,#000
    call lab1447
    ld de,(lab1DC6)
    add hl,de
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab46BD ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld de,(data2a6b)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,(data24e7)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    push hl
    ld hl,(data24e7)
    ld de,#000
    call lab1436
    ld de,#06
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,#01
    ld (data35bb),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,(lab1DC6)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,(data1dc4)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0C
    call lab148E
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    add hl,de
    inc hl
    inc hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1510)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab1436
    pop de
    ex de,hl
    or a
    sbc hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,(data1d41)
    ld (hl),e
    inc hl
    ld (hl),d
    ret 
lab479F ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab47AE
    ret 
lab47AE ld hl,(data22d7)
    ld de,#02
    call lab148E
    ld de,(lab22DF)
    add hl,de
    ld de,(lab22E9)
    add hl,de
    ld (lab236D),hl
    ld hl,(lab236D)
    ld (labBF1E),hl
    ld hl,(lab22E1)
    ld (labBF1C),hl
    ld hl,(lab22E3)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ret 
lab47E1 jr lab4803
data47e3 db #0
db #00
lab47E5 db #0
db #00,#00,#a1,#20,#0b,#00,#00,#46 ;.......F
db #d9,#f5,#17,#eb,#20,#0b,#00,#00
db #46,#d2,#ef,#19,#2a,#01,#0b,#00 ;F.......
db #00,#46,#c1,#ef,#0e ;.F...
lab4803 ld hl,(data24e7)
    ld de,(lab47E5)
    call lab14E6
    ex de,hl
    ld (data47e3),hl
    ld hl,(data47e3)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab4820
    ret 
lab4820 ld hl,#13
    ld (lab2154),hl
    ld hl,#1A
    ld (lab4849+1),hl
lab482C ld hl,(lab2154)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    ld a,h
    or l
    jp z,lab4859
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab4849 ld de,#000
    scf
    sbc hl,de
    jp c,lab482C
    ld hl,#000
    ld (data35bb),hl
    ret 
lab4859 ld hl,(lab2154)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#07
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    push hl
    ld hl,(data1dc4)
    add hl,hl
    push hl
    ld hl,(lab1DC6)
    ld de,#50
    call lab1463
    pop de
    add hl,de
    ld de,labBFFD+3
    add hl,de
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld de,(data47e3)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,(data2a6b)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld de,#CF
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld de,#CF
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,#CF
    ld (hl),e
    inc hl
    ld (hl),d
    ret 
lab48D9 ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    push hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1436
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab4917
    ld hl,(lab2154)
    ld (data1d41),hl
    call lab4DEF
lab4917 ld hl,(lab2154)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data47e3)
    ld a,h
    or l
    jp nz,lab4859
    ret 
lab492F ld hl,(data2152)
    ld de,#23
    call lab1436
    ld a,h
    or l
    jp z,lab498F
    ld hl,(lab22F3)
    srl h
    rr l
    ld (data24e7),hl
    ld hl,(lab22F3)
    add hl,hl
    ld (lab22F3),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#05
    ld (labBF1C),hl
    ld hl,#05
    ld (labBF1A),hl
    ld hl,(lab22F1)
    ld de,#05
    call lab1463
    ld de,#2DA
    ex de,hl
    or a
    sbc hl,de
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    jp lab4A18
lab498F ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#08
    call lab1447
    ld a,h
    or l
    jp z,lab49E1
    ld hl,#05
    ld (data24e7),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#04
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld hl,#78
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    jp lab4A18
lab49E1 ld hl,#02
    ld (data24e7),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#03
    ld (labBF1C),hl
    ld hl,#03
    ld (labBF1A),hl
    ld hl,#96
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
lab4A18 ld hl,(lab235D)
    ld de,#14
    call lab1436
    ld a,h
    or l
    jp z,lab4A2F
    ld hl,#13
    ld (lab235B),hl
    jp lab4A43
lab4A2F ld hl,(lab235D)
    ld de,#50
    call lab1436
    ld a,h
    or l
    jp z,lab4A43
    ld hl,#000
    ld (lab235B),hl
lab4A43 ld hl,#000
    ld (labBF1E),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1C),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#01
    call lab148E
    ld de,#000
    call lab1436
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#000
    call lab1447
    pop de
    call lab148E
    ld de,#64
    call lab148E
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#04
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    srl h
    rr l
    inc hl
    ld (data1dc4),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    inc hl
    ld (lab1DC6),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150E)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp z,lab4B84
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    ex de,hl
    or a
    sbc hl,de
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    call lab14AD
    pop de
    ex de,hl
    or a
    sbc hl,de
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab4B84 ld hl,(data2a6b)
    ld de,(data24e7)
    call lab1463
    ld (lab47E5),hl
    ld hl,(data2b2a)
    ld de,(lab47E5)
    add hl,de
    ld (data2b2a),hl
    call lab5348
    ld hl,(lab2361)
    ld a,h
    or l
    jp z,lab4BD8
    jr lab4BC9
data4ba9 db #0
db #00,#d0,#20,#eb,#20,#0b,#00,#00
db #c7,#28,#0b,#00,#00,#c1,#29,#ef
db #0e,#00,#7a,#00,#a5,#00,#9f,#20 ;..z.....
db #1e,#fe,#06,#01,#a1,#20,#0b
lab4BC9 ld hl,(lab47E5)
    ld de,(data4ba9)
    call lab1448
    ld a,h
    or l
    jp nz,lab4C71
lab4BD8 ld hl,(lab47E5)
    ld (data4ba9),hl
    ld hl,#04
    ld (data24e7),hl
lab4BE4 ld hl,(data24e7)
    dec hl
    ld (data24e7),hl
    ld hl,(data24e7)
    add hl,hl
    ld de,(lab1512)
    add hl,de
    push hl
    ld hl,(lab47E5)
    ld de,#08+2
    call lab1474
    ex de,hl
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab47E5)
    ld de,#08+2
    call lab1474
    ld (lab47E5),hl
    ld hl,(lab47E5)
    ld a,h
    or l
    jp nz,lab4BE4
    ld hl,(data24e7)
    ld (lab2154),hl
    ld hl,#04
    ld (lab4C62+1),hl
lab4C24 ld hl,(lab2154)
    add hl,hl
    ld de,(lab1512)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    add hl,hl
    ld de,#44
    add hl,de
    ld (labBF1E),hl
    ld hl,(lab2154)
    ld de,(data24e7)
    or a
    sbc hl,de
    add hl,hl
    ld de,#3C
    add hl,de
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab4C62 ld de,#000
    scf
    sbc hl,de
    jp c,lab4C24
    ld hl,#28
    ld (lab2361),hl
lab4C71 ld hl,#01
    ld (data35bb),hl
    ld hl,#ffae
    ld (data2a6b),hl
    ld hl,(data1dc4)
    ld (data24e7),hl
    ld hl,(lab1DC6)
    dec hl
    dec hl
    ld (lab47E5),hl
    call lab47E1
    ld hl,(data35bb)
    ld a,h
    or l
    jp z,lab4CE1
    ld hl,#ffb2
    ld (data2a6b),hl
    ld hl,#27
    ld de,(data1dc4)
    or a
    sbc hl,de
    ld (data24e7),hl
    call lab47E1
    ld hl,(data35bb)
    ld a,h
    or l
    jp z,lab4CE1
    ld hl,#52
    ld (data2a6b),hl
    ld hl,#18
    ld de,(lab1DC6)
    or a
    sbc hl,de
    ld (lab47E5),hl
    call lab47E1
    ld hl,(data35bb)
    ld a,h
    or l
    jp z,lab4CE1
    ld hl,#4E
    ld (data2a6b),hl
    ld hl,(data1dc4)
    ld (data24e7),hl
    call lab47E1
lab4CE1 ret 
lab4CE2 ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,#08+2
    ld (data24e7),hl
    ld hl,#82
    ld (labBF1E),hl
    ld hl,#06
    ld (labBF1C),hl
    ld hl,#06
    ld (labBF1A),hl
    ld hl,#64
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,(data22d7)
    ld de,#190
    add hl,de
    ld (lab235F),hl
    ld hl,(lab413A)
    ld de,#0F
    call lab1463
    ld de,(data4138)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    push hl
    ld hl,(lab413E)
    ld de,#000
    call lab1447
    ld de,#64
    call lab148E
    push hl
    jr lab4D86
data4d66 db #0
db #00
lab4D68 db #0
db #00,#0e,#20,#fa,#20,#19,#0f,#29
db #01,#97,#20,#1e,#cc,#00,#00,#5a ;.......Z
db #00,#ca,#00,#83,#20,#0b,#00,#00
db #54,#c5,#2c,#40,#0b ;T....
lab4D86 pop hl
    ld de,(data4d66)
    call lab148E
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab22F5)
    srl h
    rr l
    inc hl
    ld (data1dc4),hl
    ld hl,(lab413C)
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    inc hl
    ld (lab1DC6),hl
    ld hl,#000
    ld (lab22F5),hl
    ld hl,(lab413E)
    ld a,h
    or l
    jp z,lab4DEC
    ld hl,(data4138)
    ld de,(lab4D68)
    or a
    sbc hl,de
    push hl
    ld hl,(data3119)
    call lab14AD
    ld de,(lab413A)
    ex de,hl
    or a
    sbc hl,de
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab4DEC jp lab4B84
lab4DEF ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld l,(hl)
    ld h,#0
    ld de,#CF
    call lab1436
    ld a,h
    or l
    jp z,lab4E28
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    pop hl
    ld (hl),e
lab4E28 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#800
    add hl,de
    ld l,(hl)
    ld h,#0
    ld de,#CF
    call lab1436
    ld a,h
    or l
    jp z,lab4E69
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#800
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    pop hl
    ld (hl),e
lab4E69 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#1000
    add hl,de
    ld l,(hl)
    ld h,#0
    ld de,#CF
    call lab1436
    ld a,h
    or l
    jp z,lab4EAA
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1508)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#1000
    add hl,de
    push hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    pop hl
    ld (hl),e
lab4EAA ret 
lab4EAB ld hl,data2152
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA745
    ld hl,(data2152)
    ld de,#FF
    call lab148E
    ld de,(data1bf6)
    call lab1448
    ld a,h
    or l
    jp nz,lab4EAB
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA742
    call lab5515
    ld hl,(lab22E9)
    ld de,#000
    call lab1436
    ld de,(lab22EB)
    call lab1495
    ld a,h
    or l
    jp z,lab4EF3
    ret 
lab4EF3 ld hl,data2682
    ld (labBF1E),hl
    ld hl,#40
    ld (labBF1C),hl
    ld hl,(lab2DBB)
    ld (labBF1A),hl
    ld hl,(lab2DBD)
    ld (labBF18),hl
    ld ix,labBF18
    ld hl,(lab1A3E)
    call lab14F2
    ld hl,#42
    ld (labBF1E),hl
    ld hl,(lab2DBB)
    ld (labBF1C),hl
    ld hl,(lab2DBD)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
lab4F31 ld hl,(data2db7)
    ld (lab47E5),hl
    ld hl,(lab2DB9)
    ld (data2a6b),hl
    ld hl,#01
    ld (data24e7),hl
    ld hl,#01
    ld (lab1A42),hl
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab4F88
    ld hl,#000
    ld (data24e7),hl
    jr lab4F79
data4f59 db #0
db #00
lab4F5B db #0
db #00,#4f,#c1,#28,#0b,#00,#00,#c9 ;.O......
db #29,#ee,#11,#20,#eb,#20,#1e,#f2
db #00,#01,#97,#20,#0b,#00,#00,#4f ;.......O
db #c1,#28,#0b,#00,#00
lab4F79 ld hl,(lab2DBB)
    ld (data4f59),hl
    ld hl,(lab2DBD)
    ld (lab4F5B),hl
    jp lab501D
lab4F88 ld hl,(lab2DBB)
    ld de,(data2db7)
    add hl,de
    ld (data4f59),hl
    ld hl,(lab2DBD)
    ld de,(lab2DB9)
    add hl,de
    ld (lab4F5B),hl
    ld hl,data2682
    ld (labBF1E),hl
    ld hl,#42
    ld (labBF1C),hl
    ld hl,(data4f59)
    ld (labBF1A),hl
    ld hl,(lab4F5B)
    ld (labBF18),hl
    ld ix,labBF18
    ld hl,(lab1A3E)
    call lab14F2
    ld hl,(data2682)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab501D
    ld hl,(data4f59)
    ld (lab2DBB),hl
    ld hl,(lab4F5B)
    ld (lab2DBD),hl
    ld hl,(lab2363)
    ld de,(lab1A42)
    call lab1495
    ld a,h
    or l
    jp nz,lab5225
    ld hl,#81
    ld (labBF1E),hl
    ld hl,#08+2
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#C8
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0C
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    jp lab5225
lab501D ld hl,#000
    ld (lab1A42),hl
    ld hl,#b
    ld (data2152),hl
    ld hl,#23
    ld (lab50F4+1),hl
lab502F ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#fffc
    add hl,de
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#b
    call lab143F
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab50D9
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    ld de,(data4f59)
    call lab1455
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#05
    add hl,de
    ld de,(data4f59)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab50D9
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec hl
    dec hl
    dec hl
    ld de,(lab4F5B)
    call lab1455
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#10
    add hl,de
    ld de,(lab4F5B)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab50D9
    ld hl,#01
    ld (data2a6b),hl
    call lab492F
    jp lab52A7
lab50D9 ld hl,(data2152)
    ld de,#12
    call lab1436
    ld a,h
    or l
    jp z,lab50ED
    ld hl,#1E
    ld (data2152),hl
lab50ED ld hl,(data2152)
    inc hl
    ld (data2152),hl
lab50F4 ld de,#000
    scf
    sbc hl,de
    jp c,lab502F
    ld hl,(lab22F5)
    ld a,h
    or l
    jp z,lab5165
    ld hl,(data3119)
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp z,lab5165
    ld hl,(lab22F5)
    dec hl
    ld de,(data4f59)
    call lab1455
    push hl
    ld hl,(lab22F5)
    ld de,#05
    add hl,de
    ld de,(data4f59)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab5165
    ld hl,(lab413C)
    dec hl
    dec hl
    dec hl
    ld de,(lab4F5B)
    call lab1455
    push hl
    ld hl,(lab413C)
    ld de,#10
    add hl,de
    ld de,(lab4F5B)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab5165
    ld hl,#01
    ld (data2a6b),hl
    call lab4CE2
    jp lab52A7
lab5165 ld hl,(lab236D)
    ld a,h
    or l
    jp z,lab51BE
    ld hl,(lab22E1)
    dec hl
    ld de,(data4f59)
    call lab1455
    push hl
    ld hl,(lab22E1)
    ld de,#05
    add hl,de
    ld de,(data4f59)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab51BE
    ld hl,(lab22E3)
    dec hl
    dec hl
    dec hl
    ld de,(lab4F5B)
    call lab1455
    push hl
    ld hl,(lab22E3)
    ld de,#10
    add hl,de
    ld de,(lab4F5B)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab51BE
    ld hl,#000
    ld (lab22E9),hl
    jp lab479F
lab51BE ld hl,(lab22EF)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab520B
    ld hl,(lab201A)
    dec hl
    ld de,(data4f59)
    call lab1455
    push hl
    ld hl,(lab201A)
    ld de,#05
    add hl,de
    ld de,(data4f59)
    call lab1447
    pop de
    call lab148E
    ld a,h
    or l
    jp z,lab520B
    ld hl,(lab4F5B)
    ld de,#58
    call lab1456
    push hl
    ld hl,(lab4F5B)
    ld de,#6B
    call lab1448
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab52A7
lab520B ld hl,(data24e7)
    inc hl
    ld (data24e7),hl
    ld hl,(data24e7)
    dec l
    jp z,lab4F88
    dec l
    jp z,lab5242
    dec l
    jp z,lab526D
    dec l
    jp z,lab528A
lab5225 ld hl,#40
    ld (labBF1E),hl
    ld hl,(lab2DBB)
    ld (labBF1C),hl
    ld hl,(lab2DBD)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ret 
lab5242 ld hl,#02
    call lab14B9
    ld a,h
    or l
    jp z,lab525D
    ld hl,(lab2DB9)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (lab2DB9),hl
    jp lab4F88
lab525D ld hl,(data2db7)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (data2db7),hl
    jp lab4F88
lab526D ld hl,(data2db7)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (data2db7),hl
    ld hl,(lab2DB9)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (lab2DB9),hl
    jp lab4F88
lab528A ld hl,(lab47E5)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (data2db7),hl
    ld hl,(data2a6b)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (lab2DB9),hl
    jp lab4F88
lab52A7 ld hl,#64
    ld (lab22EB),hl
    ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab52BC
    ret 
lab52BC ld hl,#1A
    ld (lab2154),hl
    ld hl,#52
    ld (data2a6b),hl
    ld hl,#000
    ld (data24e7),hl
    ld hl,#02
    ld (lab47E5),hl
    call lab5301
    ld hl,#4E
    ld (data2a6b),hl
    ld hl,#27
    ld (data24e7),hl
    call lab5301
    ld hl,#ffae
    ld (data2a6b),hl
    ld hl,#18
    ld (lab47E5),hl
    call lab5301
    ld hl,#ffb2
    ld (data2a6b),hl
    ld hl,#000
lab52FE ld (data24e7),hl
lab5301 ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab150C)
    add hl,de
    ld de,#08
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1500)
    add hl,de
    ld de,(data24e7)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1502)
    add hl,de
    ld de,(lab47E5)
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab150A)
    add hl,de
    ld de,(data2a6b)
    ld (hl),e
    inc hl
    ld (hl),d
    ret 
lab5348 ld hl,(data1c9f)
    ld a,h
    or l
    jp z,lab5351
    ret 
lab5351 ld hl,(data2b2a)
    ld de,lab270F+1
    call lab1447
    ld a,h
    or l
    jp z,lab5369
    ld hl,(data2b2a)
    ld de,#d8f0
    add hl,de
    ld (data2b2a),hl
lab5369 ld hl,(data2b2a)
    ld de,#63
    call lab1447
    ld de,(lab1AEF)
    call lab148E
    ld a,h
    or l
    jp z,lab5422
    ld hl,#000
    ld (lab1AEF),hl
    ld hl,#26
    ld (labBF1E),hl
    ld hl,(lab1AF1)
    ld de,#04
    call lab1463
    ld de,#4F
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,#84
    ld (labBF1E),hl
    ld hl,#08+1
    ld (labBF1C),hl
    ld hl,#08+1
    ld (labBF1A),hl
    ld hl,#50
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#000
    ld (lab2365),hl
    ld hl,(lab1AF1)
    inc hl
    ld (lab1AF1),hl
    ld hl,(lab1AF1)
lab53EE ld de,#04
    call lab1436
    ld de,(lab2361)
    call lab148E
    ld a,h
    or l
    jp z,lab5422
    ld hl,#000
    ld (lab2361),hl
    ld hl,#58
    ld (labBF1E),hl
    ld hl,#3C
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
lab5422 jr lab5444
data5424 db #0
db #00,#20,#1e,#90,#01,#00,#1e,#00
db #22,#01,#a1,#20,#28,#0b,#00,#00
db #49,#d4,#20,#fd,#20,#0b,#00,#00 ;I.......
db #c9,#29,#fa,#20,#0f,#20,#eb
lab5444 ld hl,(data2b2a)
    ld de,(data5424)
    call lab1447
    ld a,h
    or l
    jp z,lab545C
    ld hl,(data2b2a)
    ld (data5424),hl
    call lab548D
lab545C ld hl,(data2b2a)
    ld (data24e7),hl
    jr lab5484
data5464 db #0
db #00,#4f,#c3,#28,#0b,#00,#00,#c9 ;.O......
db #29,#ef,#0e,#eb,#20,#0b,#00,#00
db #4f,#cb,#ef,#0e,#01,#a0,#20,#1e ;O.......
db #4c,#01,#00,#21,#00,#2c,#01 ;L......
lab5484 ld hl,#16
    ld (data5464),hl
    jp lab5499
lab548D ld hl,(data5424)
    ld (data24e7),hl
    ld hl,#38
    ld (data5464),hl
lab5499 jr lab54BB
data549b db #0
db #00,#1e,#4a,#01,#00,#66,#00,#36 ;..J..f..
db #01,#0b,#00,#00,#ca,#ef,#f5,#28
db #0b,#00,#00,#4f,#c1,#28,#0b,#00 ;...O....
db #00,#c9,#29,#f4,#0b,#00,#00
lab54BB ld hl,#01
    ld (data549b),hl
    ld hl,#04
    ld (lab550B+1),hl
lab54C7 ld hl,(data24e7)
    ld de,#08+2
    call lab1474
    ex de,hl
    add hl,hl
    ld de,#44
    add hl,de
    ld (labBF1E),hl
    ld hl,(data549b)
    add hl,hl
    ld de,(data5464)
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data24e7)
    ld de,#08+2
    call lab1474
    ld (data24e7),hl
    ld hl,(data549b)
    inc hl
    ld (data549b),hl
lab550B ld de,#000
    scf
    sbc hl,de
    jp c,lab54C7
    ret 
lab5515 ld hl,(lab22F5)
    ld a,h
    or l
    jp z,lab552C
    ld hl,(data3119)
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp nz,lab5675
    jp lab552D
lab552C ret 
lab552D ld hl,(data24e7)
    ld a,h
    or l
    jp z,lab5536
    ret 
lab5536 ld hl,(lab413E)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab55D2
    ld hl,(lab413A)
    inc hl
    ld (lab1DC6),hl
    ld hl,(lab1DC6)
    ld de,#08+1
    call lab1447
    ld a,h
    or l
    jp nz,lab5644
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data4138)
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    call lab148E
    ld a,h
    or l
    jp nz,lab5644
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data4d66),hl
    ld hl,(lab1DC6)
    ld (lab413A),hl
    ld hl,#06
    ld (lab413E),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#6E
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data2152)
    ld de,#fff1
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab55D2 ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(lab413C)
    inc hl
    inc hl
    inc hl
    ld (lab413C),hl
    ld hl,#10
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab413E)
    dec hl
    ld (lab413E),hl
    ld hl,(lab413E)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab5643
    ld hl,(lab413A)
    dec hl
    ld de,#0F
    call lab1463
    ld de,(data4138)
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab5643 ret 
lab5644 ld hl,#28
    ld (data1d41),hl
    call lab5DE6
    ld hl,#000
    ld (lab4D68),hl
    ld hl,#000
    ld (data3119),hl
    ld hl,#88
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
lab5675 ld hl,(lab4D68)
    ld (data2a6b),hl
    ld hl,(lab413E)
    ld a,h
    or l
    jp nz,lab57E2
    ld hl,(data4138)
    ld (data1dc4),hl
    ld hl,(lab413A)
    ld (lab1DC6),hl
    ld hl,#02
    call lab14B9
    ld a,h
    or l
    jp z,lab56C3
    ld hl,#000
    ld (lab4D68),hl
    ld hl,(lab22DB)
    ld de,(lab1DC6)
    or a
    sbc hl,de
    push hl
    ld hl,#03
    call lab14B9
    pop de
    add hl,de
    dec hl
    call lab14AD
    ld de,#03
    call lab1463
    ld (data3119),hl
    jp lab56E3
lab56C3 ld hl,(lab22D9)
    ld de,(data1dc4)
    or a
    sbc hl,de
    push hl
    ld hl,#03
    call lab14B9
    pop de
    add hl,de
    dec hl
    call lab14AD
    ld (lab4D68),hl
    ld hl,#000
    ld (data3119),hl
lab56E3 ld hl,(data4138)
    ld de,(lab4D68)
    add hl,de
    ld (data1dc4),hl
    ld hl,(data3119)
    call lab14AD
    ld de,(lab413A)
    add hl,de
    ld (lab1DC6),hl
    ld hl,(data1dc4)
    ld de,#0F
    call lab148E
    ld de,#0F
    call lab1436
    push hl
    ld hl,(lab1DC6)
    ld de,#000
    call lab1448
    pop de
    call lab1495
    push hl
    ld hl,(lab1DC6)
    ld de,#08+1
    call lab1447
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab586B
    ld hl,(lab1DC6)
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,#64
    call lab143F
    pop de
    call lab148E
    push hl
    ld hl,(lab4D68)
    ld de,(data3119)
    add hl,de
    ld de,#000
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab586B
    ld hl,(data3119)
    ld a,h
    or l
    jp z,lab57A7
    ld hl,(data3119)
    ld de,#000
    call lab1447
    ld de,(lab1DC6)
    add hl,de
    ld de,#0F
    call lab1463
    ld de,(data1dc4)
    add hl,de
    add hl,hl
    ld de,(lab14FA)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab57A7 ld hl,(data3119)
    ld de,#000
    call lab1436
    ld de,#06
    add hl,de
    ld (lab413E),hl
    ld hl,(lab1DC6)
    ld (lab413A),hl
    ld hl,(data1dc4)
    ld (data4138),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data4d66),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#6E
    ld (hl),e
    inc hl
    ld (hl),d
lab57E2 ld hl,(data4d66)
    ld a,h
    or l
    jp z,lab57F3
    ld hl,(data24e7)
    ld a,h
    or l
    jp z,lab57F3
    ret 
lab57F3 ld hl,(lab413E)
    dec hl
    ld (lab413E),hl
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(lab22F5)
    ld de,(lab4D68)
    add hl,de
    ld (lab22F5),hl
    ld hl,(lab413C)
    ld de,(data3119)
    add hl,de
    ld (lab413C),hl
    call lab5871
    ld hl,(lab413E)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab586A
    ld hl,(data4138)
    ld de,(lab4D68)
    or a
    sbc hl,de
    push hl
    ld hl,(data3119)
    call lab14AD
    ld de,(lab413A)
    ex de,hl
    or a
    sbc hl,de
    ld de,#0F
    call lab1463
    pop de
    add hl,de
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld de,#000
    ld (hl),e
    inc hl
    ld (hl),d
lab586A ret 
lab586B ld hl,(data2a6b)
    ld (lab4D68),hl
lab5871 ld hl,(lab4D68)
    add hl,hl
    push hl
    ld hl,(lab4D68)
    ld de,#000
    call lab1436
    ld de,#06
    call lab148E
    pop de
    add hl,de
    push hl
    ld hl,(data22d7)
    ld de,#02
    call lab148E
    pop de
    add hl,de
    ld de,#82
    add hl,de
    ld (labBF1E),hl
    ld hl,(lab22F5)
    ld (labBF1C),hl
    ld hl,(lab413C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ret 
lab58B1 ld hl,(lab22DB)
    ld de,#0F
    call lab1463
    ld de,(lab22D9)
    add hl,de
    ld (data2152),hl
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,h
    or l
    jp z,lab58E7
    ld hl,(data2152)
    add hl,hl
    ld de,(lab14F8)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data1dc4),hl
    jp lab58E8
lab58E7 ret 
lab58E8 ld hl,(lab236D)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp z,lab58F7
    ret 
lab58F7 ld hl,(lab22E1)
    ld (data2a6b),hl
    ld hl,(lab22E3)
    ld (data24e7),hl
lab5903 ld hl,(data1dc4)
    ld de,#63
    call lab1447
    push hl
    ld hl,(data1dc4)
    ld de,#ff92
    add hl,de
    pop de
    call lab148E
    push hl
    ld hl,(data1dc4)
    ld de,(lab22ED)
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp z,lab592D
    ret 
lab592D ld hl,(data1dc4)
    ld de,#6E
    call lab1436
    ld a,h
    or l
    jp z,lab594A
    ld hl,(lab22F5)
    ld (data1dc4),hl
    ld hl,(lab413C)
    ld (lab1DC6),hl
    jp lab596A
lab594A ld hl,(data1dc4)
    add hl,hl
    ld de,(lab1506)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (lab1DC6),hl
    ld hl,(data1dc4)
    add hl,hl
    ld de,(lab1504)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data1dc4),hl
lab596A ld hl,(data1dc4)
    ld de,(data2a6b)
    or a
    sbc hl,de
    call lab14A3
    ld de,#04
    call lab1447
    push hl
    ld hl,(lab1DC6)
    ld de,(data24e7)
    or a
    sbc hl,de
    call lab14A3
    ld de,#0E
    call lab1447
    pop de
    call lab1495
    ld a,h
    or l
    jp z,lab599B
    ret 
lab599B ld hl,(lab236D)
    ld (labBF1E),hl
    ld hl,(lab22E1)
    ld (labBF1C),hl
    ld hl,(lab22E3)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1A40)
    call lab14F2
    ld hl,#84
    ld (labBF1E),hl
    ld hl,#08
    ld (labBF1C),hl
    ld hl,#08
    ld (labBF1A),hl
    ld hl,#50
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#02
    ld (lab2365),hl
    ld hl,#24
    ld (data2626),hl
    ld hl,#000
    ld (lab236D),hl
    ld hl,#000
    ld (lab22ED),hl
    ld hl,(lab22E1)
    srl h
    rr l
    inc hl
    ld (data1dc4),hl
    ld hl,(lab22E3)
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    inc hl
    ld (lab1DC6),hl
    ld hl,#1A
    ld (lab2154),hl
    ld hl,#ffb0
    ld (data2a6b),hl
    ld hl,(lab1DC6)
    dec hl
    dec hl
    ld (data47e3),hl
    call lab48D9
    ld hl,#02
    ld (data2a6b),hl
    ld hl,#27
    ld de,(data1dc4)
    or a
    sbc hl,de
    ld (data47e3),hl
    call lab48D9
    ld hl,#50
    ld (data2a6b),hl
    ld hl,#18
    ld de,(lab1DC6)
    or a
lab5A59 sbc hl,de
    ld (data47e3),hl
    call lab48D9
    ld hl,#fffe
    ld (data2a6b),hl
    ld hl,(data1dc4)
    ld (data47e3),hl
    call lab48D9
    jp lab4C71
lab5A73 call lab5DF6
    ld hl,#58
    ld (labBF1E),hl
    ld hl,#3C
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    call lab5CEF
    ld hl,(lab1AF1)
    dec hl
    ld (lab1AF1),hl
    ld hl,(lab1AF1)
    ld a,h
    or l
    jp z,lab5AD0
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab1AF1)
    ld de,#04
    call lab1463
    ld de,#4F
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    jp lab1B62
lab5AD0 call lab5B81
    ld hl,#1F
    ld (labBF1E),hl
    ld hl,#61
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA9F6
    ld (data1d41),hl
    ld hl,labA9FE
    ld (lab5B19+1),hl
lab5AFF ld hl,(data1d41)
    ld l,(hl)
    ld h,#0
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    call lab5B81
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab5B19 ld de,#000
    scf
    sbc hl,de
    jp c,lab5AFF
    ld hl,#01
    ld (data1d41),hl
    ld hl,#05
    ld (lab5B55+1),hl
lab5B2E ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    call lab5B61
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    call lab5B61
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab5B55 ld de,#000
    scf
    sbc hl,de
    jp c,lab5B2E
    jp lab6955
lab5B61 ld hl,#1F
    ld (labBF1E),hl
    ld hl,#61
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA9F6
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
lab5B81 ld hl,#01
    ld (lab2154),hl
    ld hl,#08+2
    ld (lab5B97+1),hl
lab5B8D call labBD19
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab5B97 ld de,#000
    scf
    sbc hl,de
    jp c,lab5B8D
    ret 
lab5BA1 call lab5DF6
    ld hl,#84
    ld (labBF1E),hl
    ld hl,#01
    ld (labBF1C),hl
    ld hl,#01
    ld (labBF1A),hl
    ld hl,#64
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#0F
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#58
    ld (labBF1E),hl
    ld hl,#3C
    ld (labBF1C),hl
    ld hl,#04
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,#01
    ld (data1d41),hl
    ld hl,#03
    ld (lab5C55+1),hl
lab5BFD ld hl,#01
    ld (lab2154),hl
    ld hl,#1A
    ld (lab5C45+1),hl
lab5C09 call labBD19
    call labBD19
    call labBD19
    ld hl,(lab2154)
    ld (labBF1E),hl
    ld hl,(lab2154)
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA739
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(lab2154)
    ld (labBF1C),hl
    ld hl,(lab2154)
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab5C45 ld de,#000
    scf
    sbc hl,de
    jp c,lab5C09
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab5C55 ld de,#000
    scf
    sbc hl,de
    jp c,lab5BFD
    ld hl,(data1c9f)
    ld a,h
    or l
    jp nz,lab5F75
    ld hl,(data1ae9)
    inc hl
    inc hl
    push hl
    ld hl,(data1ae9)
    ld de,#98
    call lab1436
    ld de,#fff2
    call lab148E
    pop de
    add hl,de
    ld (data1ae9),hl
    ld hl,(data1bf6)
    ld de,#06
    call lab1447
    ld de,(data1bf6)
    add hl,de
    ld (data1bf6),hl
    ld hl,(lab1AED)
    ld de,#10
    call lab1448
    ld de,#04
    call lab148E
    ld de,(lab1AED)
    add hl,de
    ld (lab1AED),hl
    ld hl,(lab1AEB)
    ld de,#08
    call lab1448
    ld de,(lab1AEB)
    ex de,hl
    or a
    sbc hl,de
    ld (lab1AEB),hl
    ld hl,(lab1AF3)
    ld de,#37
    call lab1448
    ld de,(lab1AF3)
    ex de,hl
    or a
    sbc hl,de
    ld (lab1AF3),hl
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    call lab5CEF
    jp lab1B3A
lab5CEF ld hl,#000
    ld (labBF1E),hl
    ld hl,#27C
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#18E
    ld (labBF18),hl
    ld ix,labBF18
    call labA730
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA739
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#000
    ld (data1d41),hl
    ld hl,#4F
    ld (lab5DDC+1),hl
lab5D53 ld hl,(data1d41)
    add hl,hl
    add hl,hl
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,(data1d41)
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,#27C
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    add hl,hl
    ld de,#170
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,(data1d41)
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,#fd84
    add hl,de
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1d41)
    add hl,hl
    add hl,hl
    ld de,#fe90
    add hl,de
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab5DDC ld de,#000
    scf
    sbc hl,de
    jp c,lab5D53
    ret 
lab5DE6 ld hl,(data1d41)
    ld de,(lab2363)
    or a
    sbc hl,de
    ld a,h
    or l
    jp z,lab5DF6
    ret 
lab5DF6 ld hl,#81
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#000
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,#000
    ld (lab2363),hl
    ret 
lab5E2E ld hl,#81
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#07
    ld (labBF1A),hl
    ld hl,#32
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#04
    ld (labBF14),hl
    ld hl,lab7530
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    ld hl,(data1d41)
    ld (lab2363),hl
    ret 
lab5E66 call lab7477
    ld hl,#000
    ld (lab2363),hl
lab5E6F ld hl,data2682
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74E
    ld hl,(data2682)
    ld de,#20
    call lab1495
    ld de,#70
    call lab143F
    ld de,(data2682)
    call lab148E
    ld a,h
    or l
    jp nz,lab26D5
    jp lab5E6F
lab5E9A jr lab5EBC
data5e9c db #0
db #00
lab5E9E db #0
db #00,#28,#0b,#00,#00,#c1,#29,#f2
db #19,#64,#20,#fc,#20,#0b,#00,#00 ;.d......
db #c7,#28,#0b,#00,#00,#c1,#f4,#19
db #0f,#29,#fa,#20,#0b
lab5EBC ld hl,(lab5E9E)
    ld de,(data2152)
    call lab1463
    ld (data5e9c),hl
    ld hl,(data5e9c)
    ld de,#FF
    call lab1447
    ld a,h
    or l
    jp z,lab5EEA
    ld hl,(data1c9f)
    inc hl
    ld (data1c9f),hl
    ld hl,#01
    ld (lab5E9E),hl
    ld hl,(data2152)
    ld (data5e9c),hl
lab5EEA ld hl,(data1c9f)
    ld l,(hl)
    ld h,#0
    ld de,(lab5E9E)
    call lab1474
    push hl
    ld hl,(data2152)
    dec hl
    pop de
    call lab148E
    ld (lab272C),hl
    ld hl,(data5e9c)
    ld (lab5E9E),hl
    ret 
lab5F0A jr lab5F2C
data5f0c db #0
db #00,#ef,#0d,#00,#00,#c1,#01,#0d
db #00,#00,#53,#d9,#ef,#0e,#01,#0d ;..S.....
db #00,#00,#53,#c6,#ef,#0d,#00,#00 ;..S.....
db #c1,#f6,#13,#f4,#10,#01,#0d
lab5F2C ld hl,lab8100
    ld (data5f0c),hl
    ld hl,#000
    ld (data1d41),hl
    ld hl,#08+1
    ld (lab5F66+1),hl
lab5F3E ld hl,(data1d41)
    add hl,hl
    ld de,(lab1514)
    add hl,de
    ld de,#64
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,(data1d41)
    ld de,#1A
    call lab1463
    ld de,(data5f0c)
    add hl,de
    ld de,#FF
    ld (hl),e
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab5F66 ld de,#000
    scf
    sbc hl,de
    jp c,lab5F3E
lab5F6F call lab7477
    call lab675D
lab5F75 call lab7477
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA733
    ld hl,#0E
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#19
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#0E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA660
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    call lab6696
    ld hl,#A8
    ld (lab1DC6),hl
    ld hl,#01
    ld (data2a6b),hl
    ld hl,#27
    ld (lab602C+1),hl
lab5FE0 call lab6702
    ld hl,#01
    ld (data24e7),hl
    ld hl,#04
    ld (lab601C+1),hl
lab5FEF call labBD19
    ld hl,#FE
    ld (labBF1E),hl
    ld hl,#08
    ld (labBF1C),hl
    ld hl,(lab1DC6)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(lab1DC6)
    dec hl
    ld (lab1DC6),hl
    ld hl,(data24e7)
    inc hl
    ld (data24e7),hl
lab601C ld de,#000
    scf
    sbc hl,de
    jp c,lab5FEF
    ld hl,(data2a6b)
    inc hl
    ld (data2a6b),hl
lab602C ld de,#000
    scf
    sbc hl,de
    jp c,lab5FE0
    ld hl,#08+1
    ld (labBF1E),hl
    ld hl,#31
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#E8
    ld (labBF1E),hl
    ld hl,#12C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#04
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#04
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74B
    ld hl,#04
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    call labA709
    ld hl,labA63F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#04
    ld (labBF1E),hl
    ld hl,#18
    ld (labBF1C),hl
    ld hl,#18
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#40
    ld (labBF1E),hl
    ld hl,#21
    ld (labBF1C),hl
    ld hl,#44
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#3A
    ld (labBF1C),hl
    ld hl,#3E
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,#05
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#49
    ld (data1dc4),hl
    ld hl,#01
    ld (data2a6b),hl
    ld hl,#48
    ld (lab61F4+1),hl
lab611B call lab6702
    ld hl,#000
    ld (data2152),hl
    ld hl,#03
    ld (lab61DD+1),hl
lab612A call labBD19
    ld hl,(data2152)
    ld de,#20
    call lab1463
    ld de,#54
    add hl,de
    ld (lab272C),hl
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1dc4)
    inc hl
    ld (labBF1C),hl
    ld hl,(lab272C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data2152)
    ld de,lab8FF4
    add hl,de
    ld l,(hl)
    ld h,#0
    push hl
    ld hl,(data2a6b)
    ld de,#02
    call lab148E
    pop de
    add hl,de
    ld (labBF1E),hl
    ld hl,(data1dc4)
    ld (labBF1C),hl
    ld hl,(lab272C)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data2a6b)
    ld de,#01
    call lab148E
    ld a,h
    or l
    jp z,lab61D6
    ld hl,(data1dc4)
    ld de,#05
    add hl,de
    ld (labBF1E),hl
    ld hl,(lab272C)
    ld de,#04
    add hl,de
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,(data1dc4)
    srl h
    rr l
    push hl
    ld hl,(data2152)
    ld de,#24
    call lab1463
    pop de
    add hl,de
    ld de,labA66F
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
lab61D6 ld hl,(data2152)
    inc hl
    ld (data2152),hl
lab61DD ld de,#000
    scf
    sbc hl,de
    jp c,lab612A
    ld hl,(data1dc4)
    dec hl
    ld (data1dc4),hl
    ld hl,(data2a6b)
    inc hl
    ld (data2a6b),hl
lab61F4 ld de,#000
    scf
    sbc hl,de
    jp c,lab611B
    ld hl,#01
    ld (data2a6b),hl
    ld hl,#04
    ld (lab630F+1),hl
lab6209 ld hl,#01
    ld (data24e7),hl
    ld hl,#04
    ld (lab62FF+1),hl
lab6215 ld hl,#05
    ld (data1dc4),hl
    ld hl,#000
    ld (data2152),hl
    ld hl,#02
    ld (lab62B9+1),hl
lab6227 ld hl,(data2152)
    ld de,#20
    call lab1463
    ld de,#58
    add hl,de
    ld (data549b),hl
    ld hl,(data1dc4)
    srl h
    rr l
    add hl,hl
    ld de,(data24e7)
    call lab1463
    ld (lab1DC6),hl
    ld hl,(data1dc4)
    add hl,hl
    ld (data1dc4),hl
    ld hl,(lab1DC6)
    ld de,#08+2
    call lab1448
    ld de,#03
    call lab148E
    ld de,(lab1516)
    add hl,de
    push hl
    ld hl,(lab1DC6)
    ld de,#08+2
    call lab1474
    add hl,hl
    ld de,#44
    add hl,de
    ld (labBF1E),hl
    ld hl,#3A
    ld (labBF1C),hl
    ld hl,(data549b)
    ld (labBF1A),hl
    ld ix,labBF1A
    pop hl
    call lab14F2
    ld hl,(lab1DC6)
    ld de,#08+2
    call lab1474
    ex de,hl
    add hl,hl
    ld de,#44
    add hl,de
    ld (labBF1E),hl
    ld hl,#3C
    ld (labBF1C),hl
    ld hl,(data549b)
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,(data2152)
    inc hl
    ld (data2152),hl
lab62B9 ld de,#000
    scf
    sbc hl,de
    jp c,lab6227
    ld hl,(data24e7)
    ld de,#02
    call lab1436
    ld de,(data24e7)
    ex de,hl
    or a
    sbc hl,de
    ld (data24e7),hl
    ld hl,#01
    ld (data549b),hl
    ld hl,#05
    ld (lab62EF+1),hl
lab62E2 call lab6702
    call lab66F5
    ld hl,(data549b)
    inc hl
    ld (data549b),hl
lab62EF ld de,#000
    scf
    sbc hl,de
    jp c,lab62E2
    ld hl,(data24e7)
    inc hl
    ld (data24e7),hl
lab62FF ld de,#000
    scf
    sbc hl,de
    jp c,lab6215
    ld hl,(data2a6b)
    inc hl
    ld (data2a6b),hl
lab630F ld de,#000
    scf
    sbc hl,de
    jp c,lab6209
    call lab6689
    ld hl,#05
    ld (data1d41),hl
    ld hl,#07
    ld (lab6347+1),hl
lab6327 ld hl,(data1d41)
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6347 ld de,#000
    scf
    sbc hl,de
    jp c,lab6327
    ld hl,#000
    ld (data1dc4),hl
    ld hl,#14
    ld (lab63AC+1),hl
lab635C call lab66F8
    ld hl,#000
    ld (labBF1E),hl
    ld hl,(data1dc4)
    dec hl
    ld (labBF1C),hl
    ld hl,#52
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(data1a3c)
    call lab14F2
    ld hl,(data1dc4)
    ld de,#02
    call lab148E
    ld de,#26
    add hl,de
    ld (labBF1E),hl
    ld hl,(data1dc4)
    ld (labBF1C),hl
    ld hl,#52
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    call lab675D
    ld hl,(data1dc4)
    inc hl
    ld (data1dc4),hl
lab63AC ld de,#000
    scf
    sbc hl,de
    jp c,lab635C
    ld hl,#05
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#06
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74B
    ld hl,#07
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#9C
    ld (labBF1E),hl
    ld hl,#F0
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#30
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#ffd8
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#ffd0
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#28
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#04
    ld (labBF1E),hl
    ld hl,#DC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#98
    ld (labBF1E),hl
    ld hl,#DC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#CC
    ld (labBF1E),hl
    ld hl,#DC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#164
    ld (labBF1E),hl
    ld hl,#DC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#B6
    ld (labBF1E),hl
    ld hl,#17E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#B6
    ld (labBF1E),hl
    ld hl,#F0
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#B6
    ld (labBF1E),hl
    ld hl,#C8
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#B6
    ld (labBF1E),hl
    ld hl,#36
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,lab8FD0
    ld (data2a6b),hl
    ld hl,#000
    ld (data1d41),hl
    ld hl,#03
    ld (lab652A+1),hl
lab64E5 ld hl,(data2a6b)
    ld l,(hl)
    ld h,#0
    ld (data2152),hl
    ld hl,(data2a6b)
    inc hl
    ld l,(hl)
    ld h,#0
    add hl,hl
    ld (data1dc4),hl
    ld hl,(data2a6b)
    inc hl
    inc hl
    ld l,(hl)
    ld h,#0
    add hl,hl
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,(data2a6b)
    inc hl
    inc hl
    inc hl
    ld (data2a6b),hl
    ld hl,#0C
    ld (data2152),hl
    call lab6B87
    ld hl,#fff4
    ld (data2152),hl
    call lab6B87
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab652A ld de,#000
    scf
    sbc hl,de
    jp c,lab64E5
    ld hl,#5D
    ld (data2152),hl
    ld hl,#194
    ld (data1dc4),hl
    ld hl,#E8
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,labA628
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#50
    ld (data2152),hl
    ld hl,#15E
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,labA636
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#60
    ld (lab272C),hl
    ld hl,#A4
    ld (data1dc4),hl
    ld hl,#24
    ld (lab1DC6),hl
    call lab6ACC
    ld hl,#08
    ld (labBF1E),hl
    ld hl,#B8
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA611
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,labABB9
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#08+1
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labABC4
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#05
    ld (labBF1E),hl
    ld hl,#14
    ld (labBF1C),hl
    ld hl,#14
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#06
    ld (labBF1E),hl
    ld hl,#02
    ld (labBF1C),hl
    ld hl,#02
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#07
    ld (labBF1E),hl
    ld hl,#18
    ld (labBF1C),hl
    ld hl,#18
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#01
    ld (data1d41),hl
    ld hl,#320
    ld (lab6637+1),hl
lab662A call labBD19
    call lab675D
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6637 ld de,#000
    scf
    sbc hl,de
    jp c,lab662A
    jp lab6BBF
lab6643 ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA733
    ld hl,#000
    ld (data1d41),hl
    ld hl,#0F
    ld (lab667C+1),hl
lab665C ld hl,(data1d41)
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab667C ld de,#000
    scf
    sbc hl,de
    jp c,lab665C
    call labBD19
    ret 
lab6689 ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA733
lab6696 ld hl,#000
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA739
    ld hl,#000
    ld (data1d41),hl
lab66AF ld hl,(data1d41)
    ld (data1d41),hl
    ld hl,#0F
    ld (lab66EB+1),hl
lab66BB ld hl,(data1d41)
    ld (labBF1E),hl
    ld hl,lab9000
    ld de,(data1d41)
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1C),hl
    ld hl,lab9000
    ld de,(data1d41)
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab66EB ld de,#000
    scf
    sbc hl,de
    jp c,lab66BB
    ret 
lab66F5 call lab66F8
lab66F8 call lab66FB
lab66FB call labBD19
    call labBD19
    ret 
lab6702 ld hl,(data5e9c)
    dec hl
    ld (data5e9c),hl
    ld hl,#000
    ld (data2152),hl
    ld hl,#03
    ld (lab6754+1),hl
lab6715 ld hl,(data2152)
    ld de,(data5e9c)
    add hl,de
    ld de,#03
    call lab148E
    ld de,lab8FFC
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (lab272C),hl
    ld hl,(data2152)
    ld de,lab8FF8
    add hl,de
    ld l,(hl)
    ld h,#0
    ld (labBF1E),hl
    ld hl,(lab272C)
    ld (labBF1C),hl
    ld hl,(lab272C)
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,(data2152)
    inc hl
    ld (data2152),hl
lab6754 ld de,#000
    scf
    sbc hl,de
    jp c,lab6715
lab675D ld hl,#000
    call lab14B9
    ld (data2682),hl
    ld hl,#000
    ld (lab2363),hl
    ld hl,#2F
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab6790
    ld hl,#000
    ld (lab275D),hl
    jp lab67CF
lab6790 ld hl,#4D
    ld (labBF1E),hl
    ld hl,lab2363
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,#4C
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld de,(lab2363)
    call lab1495
    ld a,h
    or l
    jp z,lab67CE
    ld hl,#01
    ld (lab275D),hl
    jp lab67CF
lab67CE ret 
lab67CF call lab6643
    ld hl,#08
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#08+2
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74B
    ld hl,#0E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#16
    ld (labBF1E),hl
    ld hl,#30
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labAB8E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#04
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#46
    ld (data2152),hl
    ld hl,#FC
    ld (data1dc4),hl
    ld hl,#DC
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,labA563
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#53
    ld (data2152),hl
    ld hl,#78
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,labA575
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#4D
    ld (data2152),hl
    ld hl,#EC
    ld (data1dc4),hl
    ld hl,#AA
    ld (lab1DC6),hl
    call lab6A8F
    ld hl,labA56B
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    call lab6696
    ld hl,#000
    ld (data2152),hl
lab688F ld hl,#11
    ld de,(data2152)
    or a
    sbc hl,de
    ld (data2152),hl
    ld hl,#0E
    ld (labBF1E),hl
    ld hl,(data2152)
    ld (labBF1C),hl
    ld hl,(data2152)
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#01
    ld (data1d41),hl
    ld hl,#14
    ld (lab6937+1),hl
lab68C1 call labBD19
    ld hl,#35
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab68E8
    ld hl,#06
    ld (data1bf6),hl
    jp lab6943
lab68E8 ld hl,#26
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab690C
    ld hl,#08+1
    ld (data1bf6),hl
    jp lab6943
lab690C ld hl,#3C
    ld (labBF1E),hl
    ld hl,data2682
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA751
    ld hl,(data2682)
    ld a,h
    or l
    jp z,lab6930
    ld hl,#0C
    ld (data1bf6),hl
    jp lab6943
lab6930 ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6937 ld de,#000
    scf
    sbc hl,de
    jp c,lab68C1
    jp lab688F
lab6943 call lab8FF0
    ld hl,#000
    ld (data1c9f),hl
    ld hl,#000
    ld (data2b2a),hl
    jp lab1AE7
lab6955 jr lab6977
data6957 db #0
db #00,#03,#01,#a1,#20,#0b,#00,#00
db #4f,#cb,#20,#eb,#20,#0b,#00,#00 ;O.......
db #cd,#ef,#f5,#19,#4e,#01,#0b,#00 ;....N...
db #00,#ce,#ef,#19,#27,#f5,#0b
lab6977 ld hl,(data2b2a)
    ld (data6957),hl
    ld hl,#000
    ld (data1d41),hl
    ld hl,#08+1
    ld (lab69A9+1),hl
lab6989 ld hl,(data1d41)
    add hl,hl
    ld de,(lab1514)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,(data2b2a)
    call lab1447
    ld a,h
    or l
    jp z,lab69B5
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab69A9 ld de,#000
    scf
    sbc hl,de
    jp c,lab6989
    jp lab5F75
lab69B5 ld hl,(data1d41)
    ld de,#fff7
    add hl,de
    ld a,h
    or l
    jp z,lab6A6B
    ld hl,#08+1
    ld (lab2154),hl
    ld hl,(data1d41)
    ld (data1dc4),hl
    ld hl,#08
    ld (lab6A62+1),hl
lab69D3 ld hl,(lab2154)
    dec hl
    ld (lab2154),hl
    ld hl,(lab2154)
    inc hl
    add hl,hl
    ld de,(lab1514)
    add hl,de
    push hl
    ld hl,(lab2154)
    add hl,hl
    ld de,(lab1514)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    jr lab6A19
data69f9 db #0
db #00,#2c,#19,#64,#2c,#0e,#2c,#0e ;...d....
db #2c,#0e,#01,#0d,#00,#00,#53,#da ;......S.
db #ef,#0d,#00,#00,#49,#d4,#f4,#1a ;....I...
db #90,#01,#01,#0d,#00,#00,#c7
lab6A19 ld hl,(lab2154)
    ld de,#1A
    call lab1463
    ld de,(data5f0c)
    add hl,de
    ld (data69f9),hl
    ld hl,(data69f9)
    ld (data2152),hl
    ld hl,(data69f9)
    ld de,#19
    add hl,de
    ld (lab6A52+1),hl
lab6A3A ld hl,(data2152)
    ld de,#1A
    add hl,de
    push hl
    ld hl,(data2152)
    ld l,(hl)
    ld h,#0
    ex de,hl
    pop hl
    ld (hl),e
    ld hl,(data2152)
    inc hl
    ld (data2152),hl
lab6A52 ld de,#000
    scf
    sbc hl,de
    jp c,lab6A3A
    ld hl,(data1dc4)
    inc hl
    ld (data1dc4),hl
lab6A62 ld de,#000
    scf
    sbc hl,de
    jp c,lab69D3
lab6A6B ld hl,(data1d41)
    ld de,#1A
    call lab1463
    ld de,(data5f0c)
    add hl,de
    ld (data69f9),hl
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1514)
    add hl,de
    ld de,(data2b2a)
    ld (hl),e
    inc hl
    ld (hl),d
    jp lab7013
lab6A8F ld hl,#20
    ld (lab272C),hl
    call lab6ACC
    ld hl,(data1dc4)
    ld de,#08
    call lab1474
    inc hl
    inc hl
    ld (labBF1E),hl
    ld hl,(lab1DC6)
    srl h
    rr l
    ld de,#CA
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,(data2152)
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    ret 
lab6ACC ld hl,(data1dc4)
    ld de,#04
    add hl,de
    ld (labBF1E),hl
    ld hl,(data1dc4)
    ld de,(lab272C)
    add hl,de
    ld de,#fffc
    add hl,de
    ld (labBF1C),hl
    ld hl,(lab1DC6)
    dec hl
    dec hl
    ld (labBF1A),hl
    ld hl,(lab1DC6)
    ld de,#ffea
    add hl,de
    ld (labBF18),hl
    ld ix,labBF18
    call labA730
    call labBBDB
    ld hl,#000
    ld (labBF1E),hl
lab6B07 ld hl,#27E
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#18E
    ld (labBF18),hl
    ld ix,labBF18
    call labA730
    ld hl,(data1dc4)
    ld (labBF1E),hl
    ld hl,(lab1DC6)
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,(lab272C)
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#ffe8
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,(lab272C)
    ex de,hl
    ld hl,#000
    or a
    sbc hl,de
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#18
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ret 
lab6B87 ld hl,(data2a6b)
    ld l,(hl)
    ld h,#0
    add hl,hl
    ld (labBF1E),hl
    ld hl,(data2a6b)
    inc hl
    ld l,(hl)
    ld h,#0
    add hl,hl
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#0C
    ld (labBF1E),hl
    ld hl,(data2152)
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,(data2a6b)
    inc hl
    inc hl
    ld (data2a6b),hl
    ret 
lab6BBF call lab6643
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#01
    ld (labBF1C),hl
    ld hl,#05
    ld (labBF1A),hl
    ld hl,#18
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#01
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#02
    ld (labBF1E),hl
    ld hl,#05
    ld (labBF1C),hl
    ld hl,#05
    ld (labBF1A),hl
    ld hl,#18
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#04
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#06
    ld (labBF1E),hl
    ld hl,#13
    ld (labBF1C),hl
    ld hl,#05
    ld (labBF1A),hl
    ld hl,#18
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#13
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#18
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#1B
    ld (labBF1E),hl
    ld hl,#20
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#0E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA600
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#27E
    ld (labBF1E),hl
    ld hl,#13E
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#000
    ld (data1d41),hl
    ld hl,#08+1
    ld (lab6DF8+1),hl
lab6CBA ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#fd82
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#02
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#fffe
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,#27E
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#ffe4
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#fd82
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#1A
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#38
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#ffe6
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#04
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#1A
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#80
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#ffe6
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#04
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,#000
    ld (labBF1E),hl
    ld hl,#1A
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA724
    ld hl,#1BE
    ld (labBF1E),hl
    ld hl,#ffe4
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6DF8 ld de,#000
    scf
    sbc hl,de
    jp c,lab6CBA
    ld hl,#08+2
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#31
    ld (data1d41),hl
    ld hl,#39
    ld (lab6E5E+1),hl
lab6E1A ld hl,#03
    ld (labBF1E),hl
    ld hl,(data1d41)
    ld de,#10
    call lab1463
    ld de,#fd1d
    add hl,de
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,(data1d41)
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    ld hl,#ffe0
    ld (labBF1E),hl
    ld hl,#ffe0
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71E
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6E5E ld de,#000
    scf
    sbc hl,de
    jp c,lab6E1A
    ld hl,#02
    ld (labBF1E),hl
    ld hl,#BD
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA60E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#000
    ld (data1d41),hl
    ld hl,#08+1
    ld (lab6F66+1),hl
lab6E93 ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,(data1d41)
    add hl,hl
    ld de,(lab1514)
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (data2152),hl
    ld hl,#000
    ld (lab272C),hl
    ld hl,(data1d41)
    ld de,#10
    call lab1463
    ld de,#2D
    add hl,de
    ld (lab1DC6),hl
    ld hl,#01
    ld (lab2154),hl
    ld hl,#05
    ld (lab6F1E+1),hl
lab6ED2 ld hl,(lab2154)
    add hl,hl
    ld de,#15
    ex de,hl
    or a
    sbc hl,de
    ld (labBF1E),hl
    ld hl,(lab1DC6)
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,(lab272C)
    ld de,#30
    add hl,de
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    ld hl,(data2152)
    ld de,#08+2
    call lab1474
    ex de,hl
    ld (lab272C),hl
    ld hl,(data2152)
    ld de,#08+2
    call lab1474
    ld (data2152),hl
    ld hl,(lab2154)
    inc hl
    ld (lab2154),hl
lab6F1E ld de,#000
    scf
    sbc hl,de
    jp c,lab6ED2
    ld hl,#1B
    ld (labBF1E),hl
    ld hl,(lab1DC6)
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#03
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,(data1d41)
    ld de,#1A
    call lab1463
    ld de,(data5f0c)
    add hl,de
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6F66 ld de,#000
    scf
    sbc hl,de
    jp c,lab6E93
    call labA70C
    ld hl,#01
    ld (labBF1E),hl
    ld hl,#14
    ld (labBF1C),hl
    ld hl,#14
    ld (labBF1A),hl
    ld ix,labBF1A
    call labA736
    ld hl,#02
    ld (data1d41),hl
    call lab66AF
    call lab6702
    ld hl,#FE
    ld (labBF1E),hl
    ld hl,#08
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld ix,labBF1A
    ld hl,(lab1516)
    call lab14F2
    ld hl,#01
    ld (data1d41),hl
    ld hl,#4B
    ld (lab6FCC+1),hl
lab6FBF call lab66F5
    call lab6702
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab6FCC ld de,#000
    scf
    sbc hl,de
    jp c,lab6FBF
    ld hl,lab8280
    ld (data1c9f),hl
    ld hl,#01
    ld (lab5E9E),hl
    ld hl,#0C
    ld (data1bf6),hl
    ld hl,labBF08
    ld (data1d41),hl
    ld hl,labBF0B
    ld (lab7001+1),hl
lab6FF3 ld de,#000
    ld hl,(data1d41)
    ld (hl),e
    ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab7001 ld de,#000
    scf
    sbc hl,de
    jp c,lab6FF3
    ld hl,(data6957)
    ld (data2b2a),hl
    jp lab1AE7
lab7013 call lab6643
    ld hl,#01
    ld (labBF1E),hl
    ld hl,#12
    ld (labBF1C),hl
    ld hl,#08+2
    ld (labBF1A),hl
    ld hl,#10
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#04
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,#01
    ld (labBF1E),hl
    ld hl,#12
    ld (labBF1C),hl
    ld hl,#07
    ld (labBF1A),hl
    ld hl,#08+1
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#08
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#20
    ld (labBF1E),hl
    ld hl,#EC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#03
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#20
    ld (labBF1E),hl
    ld hl,#80
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#25C
    ld (labBF1E),hl
    ld hl,#80
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#25C
    ld (labBF1E),hl
    ld hl,#EC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#24
    ld (labBF1E),hl
    ld hl,#EC
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#20
    ld (labBF1E),hl
    ld hl,#EE
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#25C
    ld (labBF1E),hl
    ld hl,#EE
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#03
    ld (labBF1E),hl
    ld hl,#10
    ld (labBF1C),hl
    ld hl,#11
    ld (labBF1A),hl
    ld hl,#12
    ld (labBF18),hl
    ld ix,labBF18
    call labA706
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA715
    call labBB6C
    ld hl,#26
    ld (labBF1E),hl
    ld hl,#11C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#0E
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#25A
    ld (labBF1E),hl
    ld hl,#11C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#25A
    ld (labBF1E),hl
    ld hl,#F2
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#26
    ld (labBF1E),hl
    ld hl,#F2
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#26
    ld (labBF1E),hl
    ld hl,#11A
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#64
    ld (labBF1E),hl
    ld hl,#7C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#02
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA748
    ld hl,#64
    ld (labBF1E),hl
    ld hl,#62
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#218
    ld (labBF1E),hl
    ld hl,#62
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#218
    ld (labBF1E),hl
    ld hl,#7C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#68
    ld (labBF1E),hl
    ld hl,#7C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA721
    ld hl,#0D
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74B
    ld hl,#90
    ld (labBF1E),hl
    ld hl,#76
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA71B
    ld hl,#000
    ld (data5e9c),hl
    ld hl,#000
    ld (data2152),hl
    ld hl,#000
    ld (data24e7),hl
    call labA709
    ld hl,#17
    ld (labBF1E),hl
    ld hl,#40
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#08+2
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA57D
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#0E
    ld (labBF1E),hl
    ld hl,#58
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#000
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA58F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#b
    ld (labBF1E),hl
    ld hl,#60
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA5AA
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#11
    ld (labBF1E),hl
    ld hl,#78
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,labA5E8
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    ld hl,#08+1
    ld (labBF1E),hl
    ld hl,#68
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    ld hl,#02
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,labA5C8
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA703
    call lab6696
    call labBB03
lab7329 ld hl,#03
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    call lab740F
    ld hl,#0F
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    ld hl,(data2152)
    ld a,h
    or l
    jp z,lab7354
    call lab7448
    jp lab7365
lab7354 call lab740F
    ld hl,(data2152)
    ld de,#000
    call lab1436
    ld a,h
    or l
    jp nz,lab7329
lab7365 ld hl,(data2152)
    ld de,#7F
    call lab1436
    ld a,h
    or l
    jp z,lab7387
    ld hl,(data5e9c)
    ld de,#000
    call lab1447
    ld de,(data5e9c)
    add hl,de
    ld (data5e9c),hl
    jp lab7329
lab7387 ld hl,(data2152)
    ld de,#0D
    call lab1436
    ld a,h
    or l
    jp z,lab73A4
    ld hl,(data69f9)
    ld de,(data5e9c)
    add hl,de
    ld de,#FF
    ld (hl),e
    jp lab6BBF
lab73A4 ld hl,(data2152)
    ld de,#A3
    call lab1436
    ld a,h
    or l
    jp z,lab73B8
    ld hl,#24
    ld (data2152),hl
lab73B8 ld hl,(data2152)
    ld de,#20
    call lab1448
    push hl
    ld hl,(data2152)
    ld de,#7D
    call lab1447
    pop de
    call lab1495
    push hl
    ld hl,(data5e9c)
    ld de,#19
    call lab1436
    pop de
    call lab1495
    ld a,h
    or l
    jp nz,lab7329
    ld hl,(data69f9)
    ld de,(data5e9c)
    add hl,de
    ld de,(data2152)
    ld (hl),e
    ld hl,(data2152)
    ld (lab2154),hl
    ld hl,#03
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA712
    call lab744E
    ld hl,(data5e9c)
    inc hl
    ld (data5e9c),hl
    jp lab7329
lab740F call lab7448
    ld hl,#000
    ld (data1d41),hl
    ld hl,#13
    ld (lab743E+1),hl
lab741E call labBD19
    ld hl,data2152
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA74E
    ld hl,(data2152)
    ld a,h
    or l
    jp z,lab7437
    ret 
lab7437 ld hl,(data1d41)
    inc hl
    ld (data1d41),hl
lab743E ld de,#000
    scf
    sbc hl,de
    jp c,lab741E
    ret 
lab7448 ld hl,#7F
    ld (lab2154),hl
lab744E ld hl,(data5e9c)
    add hl,hl
    ld de,#0E
    add hl,de
    ld (labBF1E),hl
    ld hl,#8C
    ld (labBF1C),hl
    ld ix,labBF1C
    call labA70F
    call labBD19
    ld hl,(lab2154)
    ld (labBF1E),hl
    ld ix,labBF1E
    call labA700
    ret 
lab7477 ld hl,#87
    ld (labBF1E),hl
    ld hl,#000
    ld (labBF1C),hl
    ld hl,#000
    ld (labBF1A),hl
    ld hl,#000
    ld (labBF18),hl
    ld hl,#000
    ld (labBF16),hl
    ld hl,#000
    ld (labBF14),hl
    ld hl,#000
    ld (labBF12),hl
    ld ix,labBF12
    call labA73C
    call labBB03
    ret 
data74ac db #29
db #29,#f6,#25,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#00,#a7,#c9,#21,#87
db #00,#22,#1e,#bf,#21,#00,#00,#22
db #1c,#bf,#21,#00,#00,#22,#1a,#bf
db #21,#00,#00,#22,#18,#bf,#21,#00
db #00,#22,#16,#bf,#21,#00,#00,#22
db #14,#bf,#21,#00,#00,#22,#12,#bf
db #dd,#21,#12,#bf,#cd,#3c,#a7,#cd
db #03,#bb,#c9,#0b,#00,#00,#c1,#ef
db #0e,#20,#ec,#20,#11,#01,#0b,#00
db #00,#c2,#17,#30,#00,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#0f,#a7,#21
db #8e,#ab,#22,#1e,#bf,#dd,#21,#1e
db #bf,#cd,#03,#a7,#21,#04,#00,#22
db #1e,#bf,#dd,#21,#1e,#bf,#cd,#12
db #a7,#21,#46,#00,#22,#52,#21,#21 ;..F..R..
db #fc,#00,#22
lab7530 db #c4
db #1d,#21,#dc,#00,#22,#c6,#1d,#cd
db #8f,#6a,#21,#63,#a5,#22,#1e,#bf ;.j.c....
db #dd,#21,#1e,#bf,#cd,#03,#a7,#21
db #53,#00,#22,#52,#21,#21,#78,#00 ;S..R..x.
db #22,#c6,#1d,#cd,#8f,#6a,#21,#75 ;.....j.u
db #a5,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#03,#a7,#21,#4d,#00,#22,#52 ;....M..R
db #21,#21,#ec,#00,#22,#c4,#1d,#21
db #aa,#00,#22,#c6,#1d,#cd,#8f,#6a ;.......j
db #21,#6b,#a5,#22,#1e,#bf,#dd,#21 ;.k......
db #1e,#bf,#cd,#03,#a7,#cd,#96,#66 ;.......f
db #21,#00,#00,#22,#52,#21,#21,#11 ;....R...
db #00,#ed,#5b,#52,#21,#b7,#ed,#52 ;...R...R
db #22,#52,#21,#21,#0e,#00,#22,#1e ;.R......
db #bf,#2a,#52,#21,#22,#1c,#bf,#2a ;..R.....
db #52,#21,#22,#1a,#bf,#dd,#21,#1a ;R.......
db #bf,#cd,#36,#a7,#21,#01,#00,#22
db #41,#1d,#21,#14,#00,#22,#38,#69 ;A......i
db #cd,#19,#bd,#21,#35,#00,#22,#1e
db #bf,#21,#82,#26,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#51,#a7,#2a,#82 ;....Q...
db #26,#7c,#b5,#ca,#e8,#68,#21,#06 ;.....h..
db #00,#22,#f6,#1b,#c3,#43,#69,#21 ;.....Ci.
db #26,#00,#22,#1e,#bf,#21,#82,#26
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #51,#a7,#2a,#82,#26,#7c,#b5,#ca ;Q.......
db #0c,#69,#21,#09,#00,#22,#f6,#1b ;.i......
db #c3,#43,#69,#21,#3c,#00,#22,#1e ;.Ci.....
db #bf,#21,#82,#26,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#51,#a7,#2a,#82 ;....Q...
db #26,#7c,#b5,#ca,#30,#69,#21,#0c ;.....i..
db #00,#22,#f6,#1b,#c3,#43,#69,#2a ;.....Ci.
db #41,#1d,#23,#22,#41,#1d,#11,#00 ;A...A...
db #00,#37,#ed,#52,#da,#c1,#68,#c3 ;...R..h.
db #8f,#68,#cd,#f0,#8f,#21,#00,#00 ;.h......
db #22,#9f,#1c,#21,#00,#00,#22,#2a
db #2b,#c3,#e7,#1a,#18,#20,#00,#00
db #03,#01,#a1,#20,#0b,#00,#00,#4f ;.......O
db #cb,#20,#eb,#20,#0b,#00,#00,#cd
db #ef,#f5,#19,#4e,#01,#0b,#00,#00 ;...N....
db #ce,#ef,#19,#27,#f5,#0b,#2a,#2a
db #2b,#22,#57,#69,#21,#00,#00,#22 ;..Wi....
db #41,#1d,#21,#09,#00,#22,#aa,#69 ;A......i
db #2a,#41,#1d,#29,#ed,#5b,#14,#15 ;.A......
db #19,#7e,#23,#66,#6f,#ed,#5b,#2a ;...fo...
db #2b,#cd,#47,#14,#7c,#b5,#ca,#b5 ;..G.....
db #69,#2a,#41,#1d,#23,#22,#41,#1d ;i.A...A.
db #11,#00,#00,#37,#ed,#52,#da,#89 ;.....R..
db #69,#c3,#75,#5f,#2a,#41,#1d,#11 ;i.u..A..
db #f7,#ff,#19,#7c,#b5,#ca,#6b,#6a ;......kj
db #21,#09,#00,#22,#54,#21,#2a,#41 ;....T..A
db #1d,#22,#c4,#1d,#21,#08,#00,#22
db #63,#6a,#2a,#54,#21,#2b,#22,#54 ;cj.T...T
db #21,#2a,#54,#21,#23,#29,#ed,#5b ;..T.....
db #14,#15,#19,#e5,#2a,#54,#21,#29 ;.....T..
db #ed,#5b,#14,#15,#19,#7e,#23,#66 ;.......f
db #6f,#d1,#eb,#73,#23,#72,#18,#20 ;o..s.r..
db #00,#00,#2c,#19,#64,#2c,#0e,#2c ;....d...
db #0e,#2c,#0e,#01,#0d,#00,#00,#53 ;.......S
db #da,#ef,#0d,#00,#00,#49,#d4,#f4 ;.....I..
db #1a,#90,#01,#01,#0d,#00,#00,#c7
db #2a,#54,#21,#11,#1a,#00,#cd,#63 ;.T.....c
db #14,#ed,#5b,#0c,#5f,#19,#22,#f9
db #69,#2a,#f9,#69,#22,#52,#21,#2a ;i..i.R..
db #f9,#69,#11,#19,#00,#19,#22,#53 ;.i.....S
db #6a,#2a,#52,#21,#11,#1a,#00,#19 ;j.R.....
db #e5,#2a,#52,#21,#6e,#26,#00,#eb ;..R.n...
db #e1,#73,#2a,#52,#21,#23,#22,#52 ;.s.R...R
db #21,#11,#00,#00,#37,#ed,#52,#da ;......R.
db #3a,#6a,#2a,#c4,#1d,#23,#22,#c4 ;.j......
db #1d,#11,#00,#00,#37,#ed,#52,#da ;......R.
db #d3,#69,#2a,#41,#1d,#11,#1a,#00 ;.i.A....
db #cd,#63,#14,#ed,#5b,#0c,#5f,#19 ;.c......
db #22,#f9,#69,#2a,#41,#1d,#29,#ed ;..i.A...
db #5b,#14,#15,#19,#ed,#5b,#2a,#2b
db #73,#23,#72,#c3,#13,#70,#21,#20 ;s.r..p..
db #00,#22,#2c,#27,#cd,#cc,#6a,#2a ;......j.
db #c4,#1d,#11,#08,#00,#cd,#74,#14 ;......t.
db #23,#23,#22,#1e,#bf,#2a,#c6,#1d
db #cb,#3c,#cb,#1d,#11,#ca,#00,#eb
db #b7,#ed,#52,#22,#1c,#bf,#dd,#21 ;..R.....
db #1c,#bf,#cd,#0f,#a7,#2a,#52,#21 ;......R.
db #22,#1e,#bf,#dd,#21,#1e,#bf,#cd
db #00,#a7,#c9,#2a,#c4,#1d,#11,#04
db #00,#19,#22,#1e,#bf,#2a,#c4,#1d
db #ed,#5b,#2c,#27,#19,#11,#fc,#ff
db #19,#22,#1c,#bf,#2a,#c6,#1d,#2b
db #2b,#22,#1a,#bf,#2a,#c6,#1d,#11
db #ea,#ff,#19,#22,#18,#bf,#dd,#21
db #18,#bf,#cd,#30,#a7,#cd,#db,#bb
db #21,#00,#00,#22,#1e,#bf,#21,#7e
db #02,#22,#1c,#bf,#21,#00,#00,#22
db #1a,#bf,#21,#8e,#01,#22,#18,#bf
db #dd,#21,#18,#bf,#cd,#30,#a7,#2a
db #c4,#1d,#22,#1e,#bf,#2a,#c6,#1d
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #1b,#a7,#2a,#2c,#27,#22,#1e,#bf
db #21,#00,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#24,#a7,#21,#00,#00
db #22,#1e,#bf,#21,#e8,#ff,#22,#1c
db #bf,#dd,#21,#1c,#bf,#cd,#24,#a7
db #2a,#2c,#27,#eb,#21,#00,#00,#b7
db #ed,#52,#22,#1e,#bf,#21,#00,#00 ;.R......
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #24,#a7,#21,#00,#00,#22,#1e,#bf
db #21,#18,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#24,#a7,#c9,#2a,#6b ;.......k
db #2a,#6e,#26,#00,#29,#22,#1e,#bf ;.n......
db #2a,#6b,#2a,#23,#6e,#26,#00,#29 ;.k..n...
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #1b,#a7,#21,#0c,#00,#22,#1e,#bf
db #2a,#52,#21,#22,#1c,#bf,#dd,#21 ;.R......
db #1c,#bf,#cd,#24,#a7,#2a,#6b,#2a ;......k.
db #23,#23,#22,#6b,#2a,#c9,#cd,#43 ;...k...C
db #66,#21,#00,#00,#22,#1e,#bf,#21 ;f.......
db #01,#00,#22,#1c,#bf,#21,#05,#00
db #22,#1a,#bf,#21,#18,#00,#22,#18
db #bf,#dd,#21,#18,#bf,#cd,#06,#a7
db #21,#01,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#15,#a7,#cd,#6c,#bb ;......l.
db #21,#02,#00,#22,#1e,#bf,#21,#05
db #00,#22,#1c,#bf,#21,#05,#00,#22
db #1a,#bf,#21,#18,#00,#22,#18,#bf
db #dd,#21,#18,#bf,#cd,#06,#a7,#21
db #04,#00,#22,#1e,#bf,#dd,#21,#1e
db #bf,#cd,#15,#a7,#cd,#6c,#bb,#21 ;.....l..
db #06,#00,#22,#1e,#bf,#21,#13,#00
db #22,#1c,#bf,#21,#05,#00,#22,#1a
db #bf,#21,#18,#00,#22,#18,#bf,#dd
db #21,#18,#bf,#cd,#06,#a7,#21,#0f
db #00,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#15,#a7,#cd,#6c,#bb,#21,#00 ;....l...
db #00,#22,#1e,#bf,#21,#13,#00,#22
db #1c,#bf,#21,#00,#00,#22,#1a,#bf
db #21,#18,#00,#22,#18,#bf,#dd,#21
db #18,#bf,#cd,#06,#a7,#21,#1b,#00
db #22,#1e,#bf,#21,#20,#00,#22,#1c
db #bf,#dd,#21,#1c,#bf,#cd,#0f,#a7
db #21,#0e,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#12,#a7,#21,#00,#a6
db #22,#1e,#bf,#dd,#21,#1e,#bf,#cd
db #03,#a7,#21,#7e,#02,#22,#1e,#bf
db #21,#3e,#01,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#1b,#a7,#21,#00,#00
db #22,#41,#1d,#21,#09,#00,#22,#f9 ;.A......
db #6d,#21,#00,#00,#22,#1e,#bf,#dd ;m.......
db #21,#1e,#bf,#cd,#48,#a7,#21,#82 ;....H...
db #fd,#22,#1e,#bf,#21,#00,#00,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#24
db #a7,#21,#02,#00,#22,#1e,#bf,#dd
db #21,#1e,#bf,#cd,#48,#a7,#21,#00 ;....H...
db #00,#22,#1e,#bf,#21,#fe,#ff,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#1e
db #a7,#21,#7e,#02,#22,#1e,#bf,#21
db #00,#00,#22,#1c,#bf,#dd,#21,#1c
db #bf,#cd,#24,#a7,#21,#00,#00,#22
db #1e,#bf,#21,#e4,#ff,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#24,#a7,#21
db #82,#fd,#22,#1e,#bf,#21,#00,#00
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #24,#a7,#21,#00,#00,#22,#1e,#bf
db #21,#1a,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#24,#a7,#21,#38,#00
db #22,#1e,#bf,#21,#00,#00,#22,#1c
db #bf,#dd,#21,#1c,#bf,#cd,#1e,#a7
db #21,#00,#00,#22,#1e,#bf,#21,#e6
db #ff,#22,#1c,#bf,#dd,#21,#1c,#bf
db #cd,#24,#a7,#21,#04,#00,#22,#1e
db #bf,#21,#00,#00,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#1e,#a7,#21,#00
db #00,#22,#1e,#bf,#21,#1a,#00,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#24
db #a7,#21,#80,#00,#22,#1e,#bf,#21
db #00,#00,#22,#1c,#bf,#dd,#21,#1c
db #bf,#cd,#1e,#a7,#21,#00,#00,#22
db #1e,#bf,#21,#e6,#ff,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#24,#a7,#21
db #04,#00,#22,#1e,#bf,#21,#00,#00
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #1e,#a7,#21,#00,#00,#22,#1e,#bf
db #21,#1a,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#24,#a7,#21,#be,#01
db #22,#1e,#bf,#21,#e4,#ff,#22,#1c
db #bf,#dd,#21,#1c,#bf,#cd,#1e,#a7
db #2a,#41,#1d,#23,#22,#41,#1d,#11 ;.A...A..
db #00,#00,#37,#ed,#52,#da,#ba,#6c ;....R..l
db #21,#0a,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#12,#a7,#21,#31,#00
db #22,#41,#1d,#21,#39,#00,#22,#5f ;.A......
db #6e,#21,#03,#00,#22,#1e,#bf,#2a ;n.......
db #41,#1d,#11,#10,#00,#cd,#63,#14 ;A.....c.
db #11,#1d,#fd,#19,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#0f,#a7,#2a,#41 ;.......A
db #1d,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#00,#a7,#21,#e0,#ff,#22,#1e
db #bf,#21,#e0,#ff,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#1e,#a7,#2a,#41 ;.......A
db #1d,#23,#22,#41,#1d,#11,#00,#00 ;...A....
db #37,#ed,#52,#da,#1a,#6e,#21,#02 ;..R..n..
db #00,#22,#1e,#bf,#21,#bd,#00,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#0f
db #a7,#21,#0e,#a6,#22,#1e,#bf,#dd
db #21,#1e,#bf,#cd,#03,#a7,#21,#00
db #00,#22,#41,#1d,#21,#09,#00,#22 ;..A.....
db #67,#6f,#21,#00,#00,#22,#1e,#bf ;go......
db #dd,#21,#1e,#bf,#cd,#12,#a7,#2a
db #41,#1d,#29,#ed,#5b,#14,#15,#19 ;A.......
db #7e,#23,#66,#6f,#22,#52,#21,#21 ;..fo.R..
db #00,#00,#22,#2c,#27,#2a,#41,#1d ;......A.
db #11,#10,#00,#cd,#63,#14,#11,#2d ;....c...
db #00,#19,#22,#c6,#1d,#21,#01,#00
db #22,#54,#21,#21,#05,#00,#22,#1f ;.T......
db #6f,#2a,#54,#21,#29,#11,#15,#00 ;o.T.....
db #eb,#b7,#ed,#52,#22,#1e,#bf,#2a ;...R....
db #c6,#1d,#22,#1c,#bf,#dd,#21,#1c
db #bf,#cd,#0f,#a7,#2a,#2c,#27,#11
db #30,#00,#19,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#00,#a7,#2a,#52,#21 ;......R.
db #11,#0a,#00,#cd,#74,#14,#eb,#22 ;....t...
db #2c,#27,#2a,#52,#21,#11,#0a,#00 ;...R....
db #cd,#74,#14,#22,#52,#21,#2a,#54 ;.t..R..T
db #21,#23,#22,#54,#21,#11,#00,#00 ;...T....
db #37,#ed,#52,#da,#d2,#6e,#21,#1b ;..R..n..
db #00,#22,#1e,#bf,#2a,#c6,#1d,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#0f
db #a7,#21,#03,#00,#22,#1e,#bf,#dd
db #21,#1e,#bf,#cd,#12,#a7,#2a,#41 ;.......A
db #1d,#11,#1a,#00,#cd,#63,#14,#ed ;.....c..
db #5b,#0c,#5f,#19,#22,#1e,#bf,#dd
db #21,#1e,#bf,#cd,#03,#a7,#2a,#41 ;.......A
db #1d,#23,#22,#41,#1d,#11,#00,#00 ;...A....
db #37,#ed,#52,#da,#93,#6e,#cd,#0c ;..R..n..
db #a7,#21,#01,#00,#22,#1e,#bf,#21
db #14,#00,#22,#1c,#bf,#21,#14,#00
db #22,#1a,#bf,#dd,#21,#1a,#bf,#cd
db #36,#a7,#21,#02,#00,#22,#41,#1d ;......A.
db #cd,#af,#66,#cd,#02,#67,#21,#fe ;..f..g..
db #00,#22,#1e,#bf,#21,#08,#00,#22
db #1c,#bf,#21,#00,#00,#22,#1a,#bf
db #dd,#21,#1a,#bf,#2a,#16,#15,#cd
db #f2,#14,#21,#01,#00,#22,#41,#1d ;......A.
db #21,#4b,#00,#22,#cd,#6f,#cd,#f5 ;.K...o..
db #66,#cd,#02,#67,#2a,#41,#1d,#23 ;f..g.A..
db #22,#41,#1d,#11,#00,#00,#37,#ed ;.A......
db #52,#da,#bf,#6f,#21,#80,#82,#22 ;R..o....
db #9f,#1c,#21,#01,#00,#22,#9e,#5e
db #21,#0c,#00,#22,#f6,#1b,#21,#08
db #bf,#22,#41,#1d,#21,#0b,#bf,#22 ;..A.....
db #02,#70,#11,#00,#00,#2a,#41,#1d ;.p....A.
db #73,#2a,#41,#1d,#23,#22,#41,#1d ;s.A...A.
db #11,#00,#00,#37,#ed,#52,#da,#f3 ;.....R..
db #6f,#2a,#57,#69,#22,#2a,#2b,#c3 ;o.Wi....
db #e7,#1a,#cd,#43,#66,#21,#01,#00 ;...Cf...
db #22,#1e,#bf,#21,#12,#00,#22,#1c
db #bf,#21,#0a,#00,#22,#1a,#bf,#21
db #10,#00,#22,#18,#bf,#dd,#21,#18
db #bf,#cd,#06,#a7,#21,#04,#00,#22
db #1e,#bf,#dd,#21,#1e,#bf,#cd,#15
db #a7,#cd,#6c,#bb,#21,#00,#00,#22 ;..l.....
db #1e,#bf,#dd,#21,#1e,#bf,#cd,#12
db #a7,#21,#01,#00,#22,#1e,#bf,#21
db #12,#00,#22,#1c,#bf,#21,#07,#00
db #22,#1a,#bf,#21,#09,#00,#22,#18
db #bf,#dd,#21,#18,#bf,#cd,#06,#a7
db #21,#08,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#15,#a7,#cd,#6c,#bb ;......l.
db #21,#20,#00,#22,#1e,#bf,#21,#ec
db #00,#22,#1c,#bf,#dd,#21,#1c,#bf
db #cd,#1b,#a7,#21,#03,#00,#22,#1e
db #bf,#dd,#21,#1e,#bf,#cd,#48,#a7 ;......H.
db #21,#20,#00,#22,#1e,#bf,#21,#80
db #00,#22,#1c,#bf,#dd,#21,#1c,#bf
db #cd,#21,#a7,#21,#5c,#02,#22,#1e
db #bf,#21,#80,#00,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#21,#a7,#21,#5c
db #02,#22,#1e,#bf,#21,#ec,#00,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#21
db #a7,#21,#24,#00,#22,#1e,#bf,#21
db #ec,#00,#22,#1c,#bf,#dd,#21,#1c
db #bf,#cd,#21,#a7,#21,#20,#00,#22
db #1e,#bf,#21,#ee,#00,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#1b,#a7,#21
db #00,#00,#22,#1e,#bf,#dd,#21,#1e
db #bf,#cd,#48,#a7,#21,#5c,#02,#22 ;..H.....
db #1e,#bf,#21,#ee,#00,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#21,#a7,#21
db #03,#00,#22,#1e,#bf,#21,#10,#00
db #22,#1c,#bf,#21,#11,#00,#22,#1a
db #bf,#21,#12,#00,#22,#18,#bf,#dd
db #21,#18,#bf,#cd,#06,#a7,#21,#0f
db #00,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#15,#a7,#cd,#6c,#bb,#21,#26 ;....l...
db #00,#22,#1e,#bf,#21,#1c,#01,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#1b
db #a7,#21,#0e,#00,#22,#1e,#bf,#dd
db #21,#1e,#bf,#cd,#48,#a7,#21,#5a ;....H..Z
db #02,#22,#1e,#bf,#21,#1c,#01,#22
db #1c,#bf,#dd,#21,#1c,#bf,#cd,#21
db #a7,#21,#5a,#02,#22,#1e,#bf,#21 ;..Z.....
db #f2,#00,#22,#1c,#bf,#dd,#21,#1c
db #bf,#cd,#21,#a7,#21,#26,#00,#22
db #1e,#bf,#21,#f2,#00,#22,#1c,#bf
db #dd,#21,#1c,#bf,#cd,#21,#a7,#21
db #26,#00,#22,#1e,#bf,#21,#1a,#01
db #22,#1c,#bf,#dd,#21,#1c,#bf,#cd
db #21,#a7,#21,#64,#00,#22,#1e,#bf ;...d....
db #21,#7c,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#1b,#a7,#21,#02,#00
db #22,#1e,#bf,#dd,#21,#1e,#bf,#cd
db #48,#a7,#21,#64,#00,#22,#1e,#bf ;H..d....
db #21,#62,#00,#22,#1c,#bf,#dd,#21 ;.b......
db #1c,#bf,#cd,#21,#a7,#21,#18,#02
db #22,#1e,#bf,#21,#62,#00,#22,#1c ;....b...
db #bf,#dd,#21,#1c,#bf,#cd,#21,#a7
db #21,#18,#02,#22,#1e,#bf,#21,#7c
db #00,#22,#1c,#bf,#dd,#21,#1c,#bf
db #cd,#21,#a7,#21,#68,#00,#22,#1e ;....h...
db #bf,#21,#7c,#00,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#21,#a7,#21,#0d
db #00,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#4b,#a7,#21,#90,#00,#22,#1e ;.K......
db #bf,#21,#76,#00,#22,#1c,#bf,#dd ;..v.....
db #21,#1c,#bf,#cd,#1b,#a7,#21,#00
db #00,#22,#9c,#5e,#21,#00,#00,#22
db #52,#21,#21,#00,#00,#22,#e7,#24 ;R.......
db #cd,#09,#a7,#21,#17,#00,#22,#1e
db #bf,#21,#40,#00,#22,#1c,#bf,#dd
db #21,#1c,#bf,#cd,#0f,#a7,#21,#0a
db #00,#22,#1e,#bf,#dd,#21,#1e,#bf
db #cd,#12,#a7,#21,#7d,#a5,#22,#1e
db #bf,#dd,#21,#1e,#bf,#cd,#03,#a7
db #21,#0e,#00,#22,#1e,#bf,#21,#58 ;.......X
db #00,#22,#1c,#bf,#dd,#21,#1c,#bf
db #cd,#0f,#a7,#21,#00,#00,#22,#1e
db #bf,#dd,#21,#1e,#bf,#cd,#12,#a7
db #21,#8f,#a5,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#03,#a7,#21,#0b,#00
db #22,#1e,#bf,#21,#60,#00,#22,#1c
db #bf,#dd,#21,#1c,#bf,#cd,#0f,#a7
db #21,#aa,#a5,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#03,#a7,#21,#11,#00
db #22,#1e,#bf,#21,#78,#00,#22,#1c ;....x...
db #bf,#dd,#21,#1c,#bf,#cd,#0f,#a7
db #21,#e8,#a5,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#03,#a7,#21,#09,#00
db #22,#1e,#bf,#21,#68,#00 ;....h.
lab7FFF db #22
lab8000 db #1c
db #bf,#dd,#21,#1c,#bf,#cd,#0f,#a7
db #21,#02,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#12,#a7,#21,#c8,#a5
db #22,#1e,#bf,#dd,#21,#1e,#bf,#cd
db #03,#a7,#cd,#96,#66,#cd,#03,#bb ;....f...
db #21,#03,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#12,#a7,#cd,#0f,#74 ;.......t
db #21,#0f,#00,#22,#1e,#bf,#dd,#21
db #1e,#bf,#cd,#12,#a7,#2a,#52,#21 ;......R.
db #7c,#b5,#ca,#54,#73,#cd,#48,#74 ;...Ts.Ht
db #c3,#65,#73,#cd,#0f,#74,#2a,#52 ;.es..t.R
db #21,#11,#00,#00,#cd,#36,#14,#7c
db #b5,#c2,#29,#73,#2a,#52,#21,#11 ;...s.R..
db #7f,#00,#cd,#36,#14,#7c,#b5,#ca
db #87,#73,#2a,#9c,#5e,#11,#00,#00 ;.s......
db #cd,#47,#14,#ed,#5b,#9c,#5e,#19 ;.G......
db #22,#9c,#5e,#c3,#29,#73,#2a,#52 ;.....s.R
db #21,#11,#0d,#00,#cd,#36,#14,#7c
db #b5,#ca,#a4,#73,#2a,#f9,#69,#ed ;...s..i.
db #5b,#9c,#5e,#19,#11,#ff,#00,#73 ;.......s
db #c3,#bf,#6b,#2a,#52,#21,#11,#a3 ;..k.R...
db #00,#cd,#36,#14,#7c,#b5,#ca,#b8
db #73,#21,#24,#00,#22,#52,#21,#2a ;s....R..
db #52,#21,#11,#20,#00,#cd,#48,#14 ;R.....H.
db #e5,#2a,#52,#21,#11,#7d,#00,#cd ;..R.....
db #47,#14,#d1,#cd,#95,#14,#e5,#2a ;G.......
db #9c,#5e,#11,#19,#00,#cd,#36,#14
db #d1,#cd,#95,#14,#7c,#b5,#c2,#29
db #73,#2a,#f9,#69,#ed,#5b,#9c,#5e ;s..i....
db #19,#ed,#5b,#52,#21,#73,#2a,#52 ;...R.s.R
db #21,#22,#54,#21,#21,#03,#00,#22 ;..T.....
db #1e,#bf,#dd,#21,#1e,#bf,#cd
lab8100 db #12
db #a7,#cd,#4e,#74,#2a,#9c,#5e,#23 ;..Nt....
db #22,#9c,#5e,#c3,#29,#73,#cd,#48 ;.....s.H
db #74,#21,#00,#00,#22,#41,#1d,#21 ;t....A..
db #13,#00,#22,#3f,#74,#cd,#19,#bd ;....t...
db #21,#52,#21,#22,#1e,#bf,#dd,#21 ;.R......
db #1e,#bf,#cd,#4e,#a7,#2a,#52,#21 ;...N..R.
db #7c,#b5,#ca,#37,#74,#c9,#2a,#41 ;....t..A
db #1d,#23,#22,#41,#1d,#11,#00,#00 ;...A....
db #37,#ed,#52,#da,#1e,#74,#c9,#21 ;..R..t..
db #7f,#00,#22,#54,#21,#2a,#9c,#5e ;...T....
db #29,#11,#0e,#00,#19,#22,#1e,#bf
db #21,#8c,#00,#22,#1c,#bf,#dd,#21
db #1c,#bf,#cd,#0f,#a7,#cd,#19,#bd
db #2a,#54,#21,#22,#1e,#bf,#dd,#21 ;.T......
db #1e,#bf,#cd,#00,#a7,#c9,#21,#87
db #00,#22,#1e,#bf,#21,#00,#00,#22
db #1c,#bf,#21,#00,#00,#22,#1a,#bf
db #21,#00,#00,#22,#18,#bf,#21,#00
db #00,#22,#16,#bf,#21,#00,#00,#22
db #14,#bf,#21,#00,#00,#22,#12,#bf
db #dd,#21,#12,#bf,#cd,#3c,#a7,#cd
db #03,#bb,#c9,#29,#29,#f6,#25,#22
db #1e,#bf,#dd,#21,#1e,#bf,#cd,#00
db #a7,#c9,#21,#87,#00,#22,#1e,#bf
db #21,#00,#00,#22,#1c,#bf,#21,#00
db #00,#22,#1a,#bf,#21,#00,#00,#22
db #18,#bf,#21,#00,#00,#22,#16,#bf
db #21,#00,#00,#22,#14,#bf,#21,#00
db #00,#22,#12,#bf,#dd,#21,#12,#bf
db #cd,#3c,#a7,#cd,#03,#bb,#c9,#0b
db #00,#00,#c1,#ef,#0e,#20,#ec,#20
db #11,#01,#0b,#00,#00,#c2,#17,#01
db #00,#61,#11,#00,#14,#21,#00,#21 ;.a......
db #ed,#b0,#c3,#f3,#14,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab8280 db #0
db #00,#00,#00,#02,#04,#08,#10,#00
db #01,#04,#0c,#30,#00,#03,#08,#10
db #40,#00,#02,#02,#0c,#30,#00,#20
db #00,#00,#04,#00,#40,#00,#02,#04
db #08,#10,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#02,#04,#18,#00,#00
db #00,#01,#02,#0c,#30,#48,#14,#22 ;.....H..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#01,#00,#00,#00,#00
db #08,#09,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#22,#04,#00,#00
db #00,#22,#00,#02,#04,#08,#10,#00
db #00,#00,#06,#10,#20,#00,#02,#04
db #00,#00,#00,#00,#08,#00,#01,#04
db #00,#00,#00,#30,#00,#01,#02,#04
db #00,#00,#00,#04,#04,#08,#10,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #04,#10,#30,#00,#03,#00,#04,#10
db #20,#00,#02,#04,#04,#08,#10,#00
db #01,#02,#08,#10,#30,#00,#03,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#00,#00,#00,#00
db #00,#00,#01,#02,#04,#08,#30,#00
db #03,#0c,#30,#00,#03,#08,#08,#00
db #00,#00,#08,#00,#00,#04,#04,#00
db #01,#00,#03,#0c,#20,#00,#02,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #40,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
lab8374 db #0
lab8375 db #0
db #00,#00,#00,#00,#00,#00,#06,#18
db #00,#02,#04,#10,#40,#00,#00,#00
db #00,#02,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#04,#08,#10,#20
db #00,#02,#06,#18,#00,#02,#04,#10
db #20,#00,#02,#08,#20,#00,#04,#10
db #10,#00,#01,#04,#02,#00,#00,#00
db #03,#04,#08,#20,#00,#14,#1b,#1b
db #1b,#21,#24,#24,#24,#0c,#04,#00
db #00,#04,#20,#24,#24,#09,#08,#20
db #00,#04,#04,#00,#00,#00,#00,#00
db #00,#00,#10,#00,#01,#10,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#02,#04,#08,#22,#04
db #22,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#90,#04,#5c,#05,#f6,#06
db #d2,#05,#ce,#04,#0e,#04,#68,#06 ;......h.
db #bd,#04,#70,#04,#7e,#04,#8e,#04 ;..p.....
db #7e,#04,#8e,#04,#a9,#04,#bd,#04
db #e1,#0c,#00,#04,#bd,#04,#70,#04 ;......p.
db #7e,#04,#8e,#04,#8e,#04,#96,#04
db #8e,#04,#7e,#10,#00,#04,#bd,#04
db #70,#04,#7e,#04,#8e,#04,#7e,#04 ;p.......
db #8e,#04,#a9,#04,#bd,#04,#e1,#0c
db #00,#04,#bd,#04,#a9,#04,#7e,#04
db #8e,#04,#96,#04,#8e,#04,#7e,#04
db #8e,#14,#00,#04,#bd,#0c,#8e,#0c
db #a9,#0c,#7e,#0c,#96,#04,#96,#04
db #96,#04,#96,#04,#a9,#04,#96,#04
db #8e,#08,#7e,#04,#70,#0c,#bd,#0c ;....p...
db #8e,#0c,#a9,#0c,#7e,#0c,#8e,#04
db #96,#04,#96,#04,#96,#04,#96,#04
db #a9,#04,#96,#04,#8e,#10,#00,#08
db #00,#00,#d5,#02,#d5,#02,#9f,#02
db #9f,#02,#9f,#04,#8e,#02,#7e,#0a
db #9f,#02,#7e,#02,#7e,#02,#7e,#02
db #77,#04,#7e,#02,#8e,#08,#8e,#02 ;w.......
db #a9,#02,#d5,#04,#a9,#02,#8e,#04
db #7e,#02,#77,#08,#77,#02,#6a,#02 ;..w.w.j.
db #5f,#04,#6a,#02,#77,#02,#7e,#02 ;..j.w...
db #8e,#02,#9f,#0a,#00,#08,#00,#00
db #ef,#04,#b3,#04,#b3,#04,#bd,#04
db #ef,#04,#b3,#04,#b3,#04,#bd,#04
db #ef,#04,#b3,#06,#9f,#02,#8e,#04
db #86,#04,#77,#0c,#77,#04,#6a,#04 ;..w.w.j.
db #6a,#04,#86,#04,#6a,#04,#77,#04 ;j...j.w.
db #77,#04,#8e,#04,#b3,#04,#86,#04 ;w.......
db #8e,#04,#9f,#04,#b3,#04,#8e,#04
db #b3,#04,#d5,#04,#ef,#02,#ef,#02
db #b3,#06,#9f,#02,#8e,#04,#86,#04
db #77,#04,#59,#04,#6a,#04,#86,#04 ;w.Y.j...
db #8e,#08,#9f,#08,#b3,#0c,#77,#04 ;......w.
db #6a,#08,#7e,#04,#6a,#04,#77,#08 ;j...j.w.
db #8e,#04,#b3,#04,#86,#04,#8e,#04
db #9f,#04,#b3,#04,#8e,#04,#b3,#04
db #d5,#04,#ef,#04,#b3,#06,#9f,#02
db #8e,#04,#86,#04,#77,#04,#59,#04 ;....w.Y.
db #6a,#04,#86,#04,#8e,#08,#9f,#08 ;j.......
db #b3,#0c,#00,#08,#00,#00,#9f,#02
db #96,#02,#86,#04,#86,#02,#96,#04
db #9f,#02,#b3,#06,#9f,#04,#b3,#02
db #c9,#06,#b3,#04,#d5,#02,#c9,#06
db #9f,#04,#96,#02,#86,#04,#86,#02
db #8e,#04,#86,#02,#77,#04,#86,#02 ;....w...
db #8e,#04,#7e,#02,#b3,#0c,#86,#04
db #86,#02,#77,#04,#86,#02,#77,#04 ;..w...w.
db #6a,#02,#64,#04,#6a,#02,#64,#04 ;j.d.j.d.
db #77,#02,#86,#04,#9f,#02,#96,#02 ;w.......
db #9f,#02,#b3,#02,#c9,#04,#d5,#02
db #ef,#04,#0c,#02,#c9,#04,#c9,#02
db #9f,#02,#b3,#02,#c9,#02,#86,#04
db #86,#02,#77,#04,#64,#02,#9f,#04 ;..w.d...
db #c9,#02,#b3,#04,#d5,#02,#c9,#06
db #00,#08,#00,#00,#ef,#04,#b3,#04
db #b3,#06,#b3,#02,#b3,#02,#8e,#06
db #b3,#02,#b3,#02,#9f,#04,#9f,#06
db #9f,#02,#9f,#02,#86,#06,#9f,#04
db #8e,#04,#9f,#06,#b3,#02,#77,#06 ;......w.
db #86,#02,#8e,#04,#8e,#02,#9f,#06
db #9f,#04,#9f,#08,#ef,#02,#ef,#02
db #b3,#04,#b3,#06,#b3,#02,#b3,#02
db #8e,#06,#b3,#04,#9f,#04,#9f,#06
db #9f,#02,#9f,#02,#86,#06,#9f,#02
db #9f,#02,#8e,#02,#77,#06,#86,#04 ;....w...
db #8e,#02,#77,#06,#86,#04,#8e,#06 ;..w.....
db #b3,#02,#9f,#04,#b3,#08,#ef,#04
db #b3,#06,#b3,#02,#b3,#04,#b3,#02
db #8e,#06,#b3,#04,#9f,#06,#9f,#02
db #9f,#04,#9f,#02,#86,#06,#9f,#02
db #9f,#02,#8e,#02,#77,#06,#86,#04 ;....w...
db #8e,#02,#77,#06,#86,#04,#8e,#06 ;..w.....
db #b3,#02,#9f,#04,#b3,#08,#00,#08
db #00,#00,#bd,#04,#9f,#08,#9f,#04
db #9f,#04,#9f,#04,#b3,#04,#bd,#08
db #b3,#04,#9f,#08,#bd,#02,#bd,#02
db #d5,#04,#d5,#04,#bd,#04,#b3,#08
db #bd,#04,#d5,#08,#bd,#04,#b3,#08
db #b3,#02,#b3,#02,#9f,#04,#9f,#04
db #9f,#04,#9f,#08,#b3,#04,#bd,#08
db #b3,#04,#9f,#08,#ef,#04,#ef,#08
db #d5,#04,#bd,#04,#bd,#04,#ef,#04
db #d5,#0c,#ef,#08,#00,#04,#9f,#08
db #9f,#04,#9f,#08,#b3,#04,#bd,#08
db #b3,#04,#9f,#08,#00,#04,#d5,#08
db #bd,#04,#b3,#08,#bd,#04,#d5,#08
db #bd,#04,#b3,#08,#00,#04,#9f,#08
db #9f,#04,#9f,#08,#b3,#04,#bd,#08
db #b3,#04,#9f,#08,#ef,#04,#ef,#08
db #d5,#04,#bd,#04,#bd,#04,#ef,#04
db #d5,#0c,#ef,#08,#00,#08,#00,#00
db #9f,#04,#77,#02,#77,#02,#77,#04 ;..w.w.w.
db #7e,#04,#77,#02,#77,#02,#8e,#04 ;..w.w...
db #9f,#04,#bd,#04,#ef,#02,#ef,#02
db #d5,#02,#d5,#02,#d5,#04,#ef,#04
db #fd,#04,#ef,#0c,#9f,#04,#8e,#04
db #7e,#04,#6a,#04,#8e,#04,#6a,#04 ;..j...j.
db #7e,#04,#9f,#04,#9f,#02,#77,#02 ;......w.
db #77,#02,#77,#04,#7e,#04,#8e,#04 ;w.w.....
db #9f,#0c,#9f,#04,#77,#04,#77,#02 ;....w.w.
db #77,#02,#7e,#04,#77,#02,#77,#02 ;w...w.w.
db #8e,#04,#9f,#04,#bd,#04,#9f,#04
db #8e,#04,#9f,#02,#9f,#02,#b3,#04
db #bd,#04,#d5,#04,#bd,#04,#b3,#04
db #9f,#02,#9f,#02,#9f,#02,#9f,#02
db #9f,#04,#8e,#04,#8e,#02,#8e,#02
db #9f,#04,#bd,#04,#ef,#04,#ef,#02
db #ef,#02,#d5,#04,#d5,#02,#d5,#02
db #ef,#04,#fd,#04,#ef,#08,#9f,#08
db #ef,#04,#ef,#02,#ef,#04,#bd,#04
db #9f,#0c,#9f,#04,#8e,#06,#9f,#02
db #8e,#04,#7e,#04,#77,#0c,#9f,#04 ;....w...
db #77,#04,#77,#04,#7e,#04,#77,#04 ;w.w...w.
db #8e,#04,#9f,#04,#bd,#04,#9f,#04
db #8e,#04,#9f,#04,#b3,#04,#bd,#04
db #d5,#04,#bd,#04,#b3,#04,#9f,#04
db #ef,#04,#ef,#02,#ef,#02,#ef,#04
db #bd,#04,#9f,#0c,#9f,#04,#8e,#06
db #9f,#02,#8e,#04,#7e,#04,#77,#0c ;......w.
db #9f,#04,#77,#04,#77,#02,#77,#02 ;..w.w.w.
db #7e,#04,#77,#02,#77,#02,#8e,#04 ;..w.w...
db #9f,#04,#bd,#04,#77,#04,#6a,#04 ;....w.j.
db #77,#04,#77,#06,#7e,#02,#77,#0c ;w.w...w.
db #00,#08,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#1f,#00,#ff,#ff,#ff
db #ff,#ff,#aa,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #ff,#ff,#ff,#ff,#aa,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#55,#00,#00,#00 ;....U...
db #00,#00,#55,#00,#00,#00,#00,#00 ;..U.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#55,#00 ;......U.
db #00,#00,#00,#00,#55,#00,#00,#00 ;....U...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#aa,#00,#00,#00
db #00,#00,#00,#aa,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#aa,#00
db #00,#00,#00,#00,#00,#aa,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#aa,#51,#cf,#c3 ;.....Q..
db #03,#f3,#00,#aa,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#aa,#41 ;.......A
db #cf,#f3,#03,#c3,#00,#aa,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#aa,#f3,#cf,#c3
db #03,#f3,#8a,#55,#ff,#ff,#aa,#55 ;...U...U
db #ff,#00,#00,#ff,#aa,#ff,#aa,#ff
db #ff,#ff,#ff,#ff,#aa,#ff,#aa,#00
db #00,#ff,#aa,#00,#00,#00,#aa,#c3
db #cf,#f3,#03,#43,#82,#55,#ff,#ff ;...C.U..
db #aa,#00,#00,#55,#ff,#00,#00,#55 ;...U...U
db #ff,#00,#00,#55,#ff,#55,#ff,#00 ;...U.U..
db #55,#ff,#aa,#00,#aa,#f3,#cf,#c3 ;U.......
db #03,#f3,#8a,#00,#00,#00,#55,#aa ;......U.
db #00,#aa,#55,#00,#55,#00,#55,#00 ;..U.U.U.
db #00,#00,#00,#00,#55,#00,#55,#00 ;....U.U.
db #55,#00,#55,#00,#00,#00,#aa,#c3 ;U.U.....
db #cf,#db,#a3,#43,#82,#00,#00,#00 ;...C....
db #55,#00,#00,#aa,#00,#aa,#00,#aa ;U.......
db #00,#aa,#00,#aa,#00,#aa,#00,#aa
db #aa,#00,#55,#00,#aa,#f3,#cf,#c3 ;..U.....
db #03,#f3,#00,#00,#00,#00,#00,#00
db #00,#55,#aa,#00,#00,#00,#00,#00 ;.U......
db #00,#00,#00,#00,#00,#00,#55,#00 ;......U.
db #55,#00,#00,#aa,#00,#00,#aa,#c3 ;U.......
db #c7,#db,#a3,#43,#00,#00,#00,#00 ;...C....
db #00,#aa,#55,#00,#00,#55,#55,#00 ;..U..UU.
db #00,#aa,#55,#00,#00,#00,#00,#55 ;..U....U
db #00,#00,#00,#aa,#aa,#f3,#8a,#00
db #00,#00,#00,#c3,#03,#f3,#00,#00
db #02,#00,#00,#41,#00,#51,#00,#41 ;...A.Q.A
db #03,#f3,#cf,#c3,#00,#51,#00,#aa ;.....Q..
db #aa,#51,#00,#aa,#00,#00,#aa,#43 ;.Q.....C
db #82,#00,#00,#00,#00,#db,#a3,#43 ;.......C
db #00,#55,#55,#00,#82,#55,#55,#00 ;.UU..UU.
db #82,#55,#55,#00,#82,#00,#a2,#00 ;.UU.....
db #00,#db,#00,#aa,#aa,#e7,#8a,#00
db #00,#00,#41,#c3,#03,#f3,#8a,#41 ;..A....A
db #03,#00,#00,#c3,#02,#f3,#8a,#c3
db #03,#f3,#cf,#c3,#02,#f3,#8a,#aa
db #aa,#53,#a2,#aa,#00,#00,#aa,#43 ;.S.....C
db #82,#00,#00,#00,#45,#db,#a3,#43 ;....E..C
db #82,#00,#aa,#41,#c7,#00,#aa,#41 ;...A...A
db #c7,#55,#55,#41,#c3,#45,#f3,#00 ;.UUA.E..
db #00,#cf,#a2,#aa,#aa,#e7,#8a,#00
db #00,#00,#41,#83,#53,#e7,#cb,#01 ;..A.S...
db #53,#00,#00,#c3,#02,#f3,#8a,#41 ;S......A
db #03,#f3,#cf,#c3,#00,#f3,#8a,#55 ;.......U
db #00,#f3,#a2,#aa,#00,#00,#aa,#43 ;.......C
db #82,#00,#00,#00,#45,#db,#a3,#43 ;....E..C
db #c7,#00,#00,#41,#c7,#00,#00,#01 ;...A....
db #c3,#00,#aa,#01,#c3,#45,#f3,#00 ;.....E..
db #41,#cf,#a2,#aa,#aa,#e7,#8a,#00 ;A.......
db #00,#00,#41,#83,#00,#e7,#cb,#01 ;..A.....
db #53,#00,#00,#83,#02,#e7,#8a,#00 ;S.......
db #00,#f3,#8a,#00,#00,#51,#cf,#00 ;.....Q..
db #01,#f3,#00,#aa,#00,#00,#aa,#43 ;.......C
db #82,#00,#00,#00,#45,#db,#00,#43 ;....E..C
db #c3,#00,#00,#03,#c3,#8a,#00,#01
db #c3,#8a,#00,#01,#c3,#45,#f3,#00 ;.....E..
db #41,#cf,#00,#aa,#aa,#e7,#8a,#00 ;A.......
db #00,#00,#41,#83,#00,#45,#cb,#01 ;..A..E..
db #53,#00,#00,#83,#02,#e7,#8a,#00 ;S.......
db #00,#e7,#8a,#00,#00,#51,#cf,#00 ;.....Q..
db #01,#f3,#00,#aa,#00,#00,#aa,#43 ;.......C
db #82,#00,#00,#00,#41,#cf,#00,#01 ;....A...
db #c3,#00,#00,#03,#c3,#8a,#00,#01
db #c3,#8a,#00,#01,#c3,#45,#f3,#00 ;.....E..
db #c3,#8a,#00,#aa,#aa,#e7,#8a,#00
db #00,#00,#41,#83,#00,#45,#cb,#01 ;..A..E..
db #53,#00,#00,#83,#02,#e7,#8a,#00 ;S.......
db #00,#e7,#8a,#55,#aa,#00,#cb,#82 ;...U....
db #03,#a2,#55,#00,#00,#00,#aa,#43 ;..U....C
db #82,#00,#00,#00,#41,#cf,#00,#01 ;....A...
db #c3,#00,#51,#03,#41,#cf,#00,#01 ;..Q.A...
db #c3,#cf,#00,#01,#c3,#45,#f3,#00 ;.....E..
db #c3,#8a,#55,#00,#aa,#e7,#cb,#83 ;..U.....
db #53,#00,#41,#83,#00,#45,#cb,#01 ;S.A..E..
db #53,#00,#00,#83,#02,#e7,#8a,#55 ;S......U
db #00,#e7,#8a,#aa,#55,#00,#cb,#82 ;....U...
db #53,#a2,#55,#00,#00,#00,#aa,#03 ;S.U.....
db #c3,#cf,#f3,#00,#41,#cf,#00,#01 ;....A...
db #c3,#00,#51,#03,#41,#cf,#00,#01 ;..Q.A...
db #c3,#cf,#00,#01,#c3,#45,#f3,#01 ;.....E..
db #c3,#00,#55,#00,#aa,#e7,#cb,#83 ;..U.....
db #53,#a2,#41,#83,#00,#45,#cb,#01 ;S.A..E..
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#aa,#41,#83 ;......A.
db #53,#00,#aa,#00,#00,#00,#aa,#03 ;S.......
db #c3,#cf,#f3,#02,#41,#cf,#00,#01 ;....A...
db #c3,#00,#f3,#02,#00,#cf,#a2,#01
db #c3,#cf,#a2,#01,#c3,#45,#f3,#01 ;.....E..
db #c3,#00,#aa,#00,#aa,#e7,#cb,#83
db #53,#a2,#41,#83,#00,#e7,#cb,#01 ;S.A.....
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#aa,#41,#83 ;......A.
db #53,#00,#aa,#00,#00,#00,#aa,#03 ;S.......
db #c3,#cf,#f3,#02,#41,#cf,#00,#01 ;....A...
db #c3,#00,#f3,#02,#00,#cf,#a2,#01
db #c3,#cf,#a2,#01,#c3,#45,#f3,#03 ;.....E..
db #82,#00,#aa,#00,#aa,#e7,#cb,#83
db #53,#00,#41,#83,#53,#e7,#cb,#01 ;S.A.S...
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#55,#00,#83 ;.....U..
db #02,#55,#00,#00,#00,#00,#aa,#03 ;.U......
db #c3,#cf,#f3,#00,#41,#cf,#00,#03 ;....A...
db #c3,#45,#f3,#00,#00,#45,#f3,#01 ;.E...E..
db #c3,#45,#f3,#01,#c3,#45,#f3,#03 ;.E...E..
db #82,#55,#00,#00,#aa,#e7,#8a,#00 ;.U......
db #00,#00,#41,#83,#53,#e7,#8a,#01 ;..A.S...
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#55,#00,#83 ;.....U..
db #02,#55,#00,#00,#00,#00,#aa,#03 ;.U......
db #82,#00,#00,#00,#41,#cf,#f3,#03 ;....A...
db #82,#45,#f3,#03,#c3,#cf,#f3,#01 ;.E......
db #c3,#45,#f3,#01,#c3,#45,#f3,#03 ;.E...E..
db #82,#55,#00,#00,#aa,#e7,#8a,#00 ;.U......
db #00,#00,#41,#83,#53,#e7,#00,#01 ;..A.S...
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#00,#00,#00,#41,#cf,#f3,#03 ;....A...
db #00,#45,#f3,#03,#c3,#cf,#f3,#01 ;.E......
db #c3,#00,#f3,#03,#c3,#45,#f3,#03 ;.....E..
db #82,#55,#00,#00,#aa,#e7,#8a,#55 ;.U.....U
db #ff,#aa,#41,#83,#51,#e7,#8a,#01 ;..A.Q...
db #53,#00,#00,#83,#02,#e7,#8a,#aa ;S.......
db #aa,#e7,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#55,#ff,#aa,#41,#cf,#f3,#03 ;.U..A...
db #82,#45,#f3,#03,#c3,#cf,#f3,#01 ;.E......
db #c3,#00,#f3,#03,#c3,#45,#f3,#01 ;.....E..
db #c3,#00,#aa,#00,#aa,#e7,#8a,#aa
db #00,#55,#41,#83,#00,#e7,#cb,#00 ;.UA.....
db #53,#a2,#41,#83,#00,#e7,#8a,#aa ;S.A.....
db #aa,#f3,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#aa,#00,#55,#45,#db,#01,#43 ;...UE..C
db #c3,#45,#f3,#00,#00,#45,#f3,#01 ;.E...E..
db #c3,#00,#51,#03,#c3,#45,#f3,#01 ;..Q..E..
db #c3,#00,#aa,#00,#aa,#e7,#8a,#aa
db #00,#55,#41,#83,#00,#45,#cb,#00 ;.UA..E..
db #53,#a2,#45,#c3,#00,#f3,#8a,#aa ;S.E.....
db #aa,#f3,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#aa,#00,#55,#45,#db,#00,#43 ;...UE..C
db #c7,#51,#a3,#00,#00,#51,#f3,#01 ;.Q...Q..
db #c3,#00,#51,#03,#c3,#45,#f3,#00 ;..Q..E..
db #c3,#8a,#55,#00,#aa,#e7,#8a,#aa ;..U.....
db #00,#55,#41,#c3,#00,#51,#cf,#00 ;.UA..Q..
db #03,#f3,#cf,#c3,#00,#f3,#8a,#aa
db #aa,#f3,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#aa,#00,#55,#45,#db,#00,#41 ;...UE..A
db #c7,#51,#a3,#00,#aa,#51,#a3,#41 ;.Q...Q.A
db #c7,#00,#00,#43,#c3,#45,#f3,#00 ;...C.E..
db #c3,#8a,#55,#00,#aa,#f3,#8a,#aa ;..U.....
db #00,#55,#45,#c3,#00,#51,#cf,#00 ;.UE..Q..
db #01,#f3,#cf,#82,#00,#f3,#8a,#aa
db #aa,#f3,#8a,#aa,#00,#00,#aa,#c3
db #02,#aa,#00,#00,#00,#00,#aa,#43 ;.......C
db #82,#aa,#00,#55,#45,#db,#00,#41 ;...UE..A
db #c7,#51,#a3,#55,#55,#51,#a3,#41 ;.Q.UUQ.A
db #c7,#00,#00,#43,#c7,#51,#a3,#00 ;...C.Q..
db #45,#db,#00,#aa,#aa,#f3,#8a,#aa ;E.......
db #00,#55,#45,#c3,#00,#51,#cf,#00 ;.UE..Q..
db #00,#f3,#cf,#00,#00,#f3,#8a,#aa
db #aa,#f3,#8a,#aa,#00,#00,#aa,#c3
db #82,#aa,#00,#00,#00,#00,#aa,#c3
db #82,#aa,#00,#55,#45,#db,#00,#41 ;...UE..A
db #c7,#51,#a3,#55,#55,#51,#a3,#41 ;.Q.UUQ.A
db #c7,#00,#aa,#41,#c7,#51,#a3,#00 ;...A.Q..
db #45,#db,#a2,#aa,#aa,#51,#00,#aa ;E....Q..
db #00,#55,#00,#82,#00,#00,#8a,#00 ;.U......
db #00,#f3,#cf,#00,#00,#51,#00,#aa ;.....Q..
db #aa,#51,#00,#aa,#00,#00,#aa,#41 ;.Q.....A
db #00,#aa,#00,#00,#00,#00,#aa,#c3
db #8a,#aa,#00,#55,#45,#db,#00,#41 ;...UE..A
db #c7,#51,#a3,#55,#55,#51,#a3,#41 ;.Q.UUQ.A
db #c7,#55,#55,#41,#c7,#51,#a3,#00 ;.UUA.Q..
db #00,#db,#a2,#aa,#aa,#00,#00,#aa
db #00,#55,#00,#00,#55,#00,#00,#55 ;.U..U..U
db #aa,#00,#00,#55,#aa,#00,#00,#aa ;...U....
db #aa,#00,#00,#aa,#00,#00,#aa,#00
db #00,#aa,#00,#00,#00,#00,#aa,#41 ;.......A
db #00,#aa,#00,#55,#00,#8a,#00,#00 ;...U....
db #82,#00,#a2,#55,#55,#00,#a2,#00 ;...UU...
db #82,#55,#55,#00,#82,#00,#a2,#00 ;.UU.....
db #00,#db,#00,#aa,#55,#00,#55,#00 ;....U.U.
db #00,#00,#aa,#00,#aa,#aa,#00,#aa
db #55,#00,#00,#aa,#55,#00,#55,#00 ;U...U.U.
db #55,#00,#55,#00,#00,#00,#55,#00 ;U.U...U.
db #55,#00,#00,#00,#00,#00,#aa,#00 ;U.......
db #00,#aa,#00,#55,#00,#00,#55,#00 ;...U..U.
db #00,#00,#00,#55,#55,#00,#00,#00 ;...UU...
db #00,#55,#00,#aa,#00,#00,#00,#55 ;.U.....U
db #00,#00,#00,#aa,#00,#ff,#aa,#00
db #00,#00,#55,#ff,#00,#55,#ff,#00 ;..U..U..
db #00,#ff,#ff,#00,#00,#ff,#aa,#00
db #00,#ff,#aa,#00,#00,#00,#00,#ff
db #aa,#00,#00,#00,#00,#00,#55,#00 ;......U.
db #55,#00,#00,#00,#aa,#00,#aa,#aa ;U.......
db #00,#aa,#00,#aa,#00,#aa,#00,#aa
db #00,#aa,#00,#aa,#00,#aa,#00,#aa
db #aa,#00,#55,#00,#00,#00,#00,#00 ;..U.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #aa,#00,#00,#00,#55,#ff,#00,#55 ;....U..U
db #ff,#55,#ff,#00,#00,#55,#ff,#55 ;.U...U.U
db #ff,#00,#00,#55,#ff,#55,#ff,#00 ;...U.U..
db #55,#ff,#aa,#00,#00,#00,#00,#00 ;U.......
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
lab8FD0 db #5a
db #12,#74,#02,#6e,#02,#6e,#58,#92 ;.t.n.nX.
db #74,#ac,#68,#ac,#74,#3a,#53,#af ;t.h.t.S.
db #55,#b9,#5b,#bf,#2e,#53,#39,#5b ;U....S..
db #1b,#55,#21,#00,#00,#00,#00 ;.U.....
lab8FF0 pop hl
    pop de
    jp (hl)
data8ff3 db #0
lab8FF4 db #34
db #5e,#80,#6a ;..j
lab8FF8 db #8
db #09,#0b,#0d
lab8FFC db #3
db #06,#0f,#18
lab9000 db #0
db #03,#06,#0f,#18,#19,#0c,#09,#14
db #01,#02,#06,#04,#10,#11,#1a
lab9010 db #10
db #91,#5d,#91,#aa,#91,#f7,#91,#44 ;.......D
db #92,#91,#92,#de,#92,#2b,#93,#78 ;.......x
db #93,#c5,#93,#12,#94,#5f,#94,#ac
db #94,#f9,#94,#46,#95,#93,#95,#e0 ;...F....
db #95,#2d,#96,#7a,#96,#c7,#96,#14 ;...z....
db #97,#61,#97,#ae,#97,#fb,#97,#48 ;.a.....H
db #98,#95,#98,#e2,#98,#2f,#99,#7c
db #99,#c9,#99,#16,#9a,#63,#9a,#b0 ;.....c..
db #9a,#ba,#9a,#c4,#9a,#d4,#9a,#e4
db #9a,#f4,#9a,#04,#9b,#14,#9b,#24
db #9b,#34,#9b,#44,#9b,#54,#9b,#64 ;...D.T.d
db #9b,#9e,#9b,#ca,#9b,#04,#9c,#51 ;.......Q
db #9c,#9e,#9c,#eb,#9c,#38,#9d,#85
db #9d,#d2,#9d,#1f,#9e,#6c,#9e,#b9 ;.....l..
db #9e,#06,#9f,#53,#9f,#a0,#9f,#b1 ;...S....
db #9f,#c2,#9f,#d3,#9f,#e4,#9f,#f5
db #9f,#42,#a0,#8f,#a0,#dc,#a0,#29 ;.B......
db #a1,#76,#a1,#c3,#a1,#45,#a2,#c7 ;.v...E..
db #a2,#49,#a3,#cb,#a3,#4d,#a4,#cf ;.I...M..
db #a4,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#88,#05
db #0f,#00,#00,#e8,#fc,#a8,#00,#00
db #40,#00,#fc,#00,#00,#40,#00,#54 ;.......T
db #00,#fc,#40,#30,#00,#00,#3c,#cc
db #4c,#20,#14,#3c,#8c,#0c,#24,#54 ;L......T
db #3c,#cc,#0c,#8c,#54,#bc,#6c,#0c ;....T.l.
db #8c,#14,#3c,#cc,#0c,#8c,#54,#3c ;......T.
db #6c,#8c,#0c,#54,#bc,#cc,#0c,#08 ;l..T....
db #00,#3c,#cc,#cc,#08,#00,#bc,#6c ;.......l
db #0c,#00,#00,#3c,#cc,#8c,#00,#00
db #14,#8c,#08,#00,#05,#0f,#00,#00
db #00,#e8,#a8,#00,#00,#00,#40,#fc
db #00,#00,#00,#40,#54,#00,#f5,#14 ;....T...
db #60,#00,#14,#7d,#00,#ee,#20,#54 ;.......T
db #7d,#00,#ae,#20,#14,#7d,#aa,#ae
db #8c,#fc,#6c,#aa,#ae,#8c,#bc,#6c ;..l....l
db #aa,#ae,#8c,#fc,#6c,#aa,#ae,#0c ;....l...
db #54,#ec,#aa,#ae,#0c,#54,#3c,#ff ;T....T..
db #cc,#0c,#00,#bc,#dd,#0c,#08,#00
db #3c,#7d,#8c,#08,#00,#14,#7d,#0c
db #00,#05,#0f,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#a8,#00,#00,#00,#00,#40,#00
db #00,#00,#28,#d4,#55,#aa,#00,#55 ;....U..U
db #d4,#34,#aa,#00,#ff,#74,#3c,#ff ;.....t..
db #00,#ee,#fc,#7c,#7d,#55,#ee,#a8 ;.....U..
db #bc,#7d,#55,#cc,#ac,#bc,#ec,#ea ;..U.....
db #8c,#0c,#54,#6c,#ff,#84,#0c,#54 ;..Tl...T
db #3c,#dd,#c4,#08,#00,#bc,#7d,#84
db #08,#00,#54,#fd,#c0,#00,#05,#0f ;..T.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#fc,#00,#00,#00,#00
db #54,#00,#00,#00,#55,#e8,#55,#00 ;T...U.U.
db #00,#ff,#b8,#34,#ff,#55,#d5,#ec ;.....U..
db #3c,#d0,#ea,#e4,#cc,#3c,#ea,#f5
db #cc,#18,#3c,#7d,#d5,#ee,#8c,#bc
db #bc,#ff,#ee,#0c,#fc,#3c,#3c,#ff
db #08,#54,#bc,#fc,#ac,#08,#00,#fc ;.T......
db #fc,#0c,#00,#05,#0f,#00,#00,#fc
db #fc,#a8,#00,#54,#a8,#14,#00,#00 ;...T....
db #fc,#00,#14,#00,#00,#a8,#00,#3c
db #00,#00,#00,#0c,#3c,#00,#00,#40
db #18,#1c,#28,#00,#40,#18,#08,#28
db #04,#48,#0c,#08,#28,#84,#60,#84 ;.H......
db #08,#28,#84,#24,#c0,#04,#08,#84
db #0c,#00,#84,#24,#c0,#0c,#00,#84
db #24,#40,#80,#00,#84,#0c,#00,#00
db #00,#c0,#0c,#00,#00,#00,#40,#80
db #05,#0f,#00,#80,#00,#00,#00,#00
db #40,#00,#00,#00,#00,#fc,#98,#a0
db #00,#00,#fc,#98,#a0,#00,#54,#a8 ;......T.
db #98,#f0,#00,#54,#00,#98,#70,#00 ;...T..p.
db #00,#00,#44,#70,#00,#00,#00,#44 ;..Dp...D
db #70,#00,#00,#00,#44,#70,#00,#00 ;p...Dp..
db #00,#44,#70,#00,#00,#00,#44,#70 ;.Dp...Dp
db #00,#00,#00,#98,#a0,#00,#00,#00
db #98,#a0,#00,#00,#44,#70,#00,#00 ;....Dp..
db #00,#44,#a0,#00,#00,#05,#0f,#00 ;.D......
db #fc,#fc,#a8,#00,#54,#fc,#14,#00 ;....T...
db #00,#54,#fc,#14,#00,#00,#fc,#a8 ;.T......
db #14,#00,#00,#a8,#11,#37,#22,#00
db #00,#33,#33,#3b,#00,#00,#62,#33 ;......b.
db #3b,#00,#11,#91,#33,#37,#22,#40
db #62,#33,#37,#22,#40,#91,#33,#37 ;b.......
db #22,#40,#62,#33,#37,#22,#40,#91 ;..b.....
db #91,#33,#22,#00,#c0,#62,#33,#00 ;.....b..
db #00,#91,#91,#33,#00,#00,#40,#c0
db #80,#00,#05,#0f,#00,#00,#54,#fc ;......T.
db #00,#00,#00,#14,#54,#a8,#00,#00 ;....T...
db #bc,#28,#fc,#00,#00,#bc,#28,#54 ;.......T
db #00,#00,#bc,#28,#00,#00,#00,#bc
db #28,#00,#00,#54,#bc,#6c,#00,#00 ;...T.l..
db #54,#bc,#6c,#00,#00,#54,#3c,#6c ;T.l..T.l
db #00,#00,#fc,#3c,#3c,#88,#00,#fc
db #3c,#3c,#88,#00,#fc,#3c,#3c,#88
db #00,#54,#bc,#6c,#00,#00,#54,#bc ;.T.l..T.
db #3c,#00,#00,#00,#fc,#28,#00,#05
db #0f,#00,#00,#54,#fc,#00,#00,#00 ;...T....
db #80,#fc,#a8,#00,#40,#c8,#40,#fc
db #00,#c0,#84,#c8,#54,#00,#c8,#24 ;....T...
db #e4,#00,#00,#c0,#0c,#4c,#88,#40 ;.....L..
db #84,#18,#58,#88,#40,#90,#0c,#0c ;..X.....
db #88,#40,#8c,#0c,#58,#08,#40,#c0 ;....X...
db #18,#0c,#08,#40,#90,#0c,#58,#00 ;......X.
db #44,#c0,#0c,#0c,#00,#40,#18,#18 ;D.......
db #08,#00,#40,#0c,#08,#00,#00,#00
db #00,#00,#00,#00,#05,#0f,#00,#54 ;.......T
db #fc,#00,#00,#00,#00,#7c,#00,#00
db #00,#00,#f4,#a8,#00,#00,#50,#f4 ;......P.
db #fc,#00,#00,#50,#30,#fc,#00,#00 ;...P....
db #98,#30,#fc,#00,#00,#cc,#b0,#a8
db #00,#00,#98,#74,#a8,#00,#00,#cc ;...t....
db #74,#20,#00,#00,#98,#30,#20,#00 ;t.......
db #00,#cc,#30,#a0,#00,#00,#10,#30
db #00,#00,#00,#44,#98,#00,#00,#00 ;...D....
db #00,#20,#00,#00,#00,#00,#00,#00
db #00,#05,#0f,#00,#00,#54,#a8,#00 ;.....T..
db #00,#00,#fc,#fc,#00,#00,#00,#11
db #fc,#a8,#00,#14,#11,#54,#a8,#14 ;.....T..
db #14,#11,#00,#a8,#54,#00,#22,#28 ;....T...
db #00,#00,#22,#39,#39,#28,#00,#39
db #28,#00,#28,#28,#b9,#00,#00,#00
db #b9,#00,#36,#14,#00,#14,#14,#14
db #14,#00,#54,#54,#00,#22,#00,#00 ;..TT....
db #00,#11,#28,#00,#00,#00,#28,#a8
db #00,#00,#00,#a8,#00,#00,#05,#0f
db #14,#3c,#3c,#00,#00,#3c,#28,#a8
db #00,#00,#28,#54,#fc,#00,#00,#11 ;...T....
db #a8,#a8,#a8,#00,#87,#22,#a8,#11
db #00,#c3,#76,#a8,#87,#22,#41,#11 ;..v...A.
db #a8,#c3,#22,#00,#87,#22,#41,#a8 ;......A.
db #00,#c3,#22,#00,#22,#00,#e9,#a8
db #41,#1b,#11,#a8,#54,#41,#93,#87 ;A...TA..
db #22,#11,#00,#82,#c3,#22,#87,#22
db #00,#41,#00,#c3,#22,#00,#00,#00 ;.A......
db #41,#00,#00,#05,#0f,#00,#00,#bc ;A.......
db #fc,#a8,#00,#00,#14,#00,#fc,#00
db #4c,#14,#4c,#54,#04,#4c,#8c,#4c ;L.LT.L.L
db #88,#04,#cc,#cc,#cc,#20,#0c,#4c ;.......L
db #cc,#cc,#cc,#0c,#4c,#cc,#cc,#98 ;....L...
db #0c,#0c,#cc,#cc,#cc,#0c,#0c,#cc
db #cc,#98,#0c,#0c,#cc,#cc,#cc,#0c
db #0c,#cc,#cc,#cc,#0c,#0c,#cc,#cc
db #cc,#04,#0c,#4c,#cc,#88,#04,#0c ;...L....
db #4c,#cc,#88,#00,#0c,#0c,#cc,#00 ;L.......
db #05,#0f,#00,#00,#0c,#00,#00,#00
db #00,#a6,#08,#00,#00,#51,#f3,#08 ;.....Q..
db #00,#00,#00,#f3,#00,#00,#00,#00
db #51,#00,#00,#00,#00,#0f,#00,#00 ;Q.......
db #00,#00,#a7,#18,#00,#00,#51,#0f ;......Q.
db #0c,#20,#00,#a2,#0f,#a6,#08,#00
db #00,#03,#c0,#00,#00,#51,#53,#00 ;.....QS.
db #00,#00,#51,#51,#00,#00,#00,#a2 ;..QQ....
db #51,#e2,#00,#00,#a2,#00,#40,#00 ;Q.......
db #40,#80,#00,#00,#00,#05,#0f,#00
db #00,#0c,#00,#00,#00,#00,#a6,#08
db #00,#00,#51,#f3,#08,#00,#00,#00 ;..Q.....
db #f3,#00,#00,#00,#00,#51,#00,#00 ;.....Q..
db #51,#00,#0f,#04,#20,#00,#f3,#5b ;Q.......
db #84,#18,#00,#00,#0f,#e2,#0c,#00
db #00,#0f,#51,#80,#00,#00,#03,#00 ;..Q.....
db #00,#00,#00,#a3,#00,#00,#00,#00
db #f3,#00,#00,#00,#00,#a2,#a2,#00
db #00,#00,#a2,#40,#00,#00,#40,#80
db #80,#00,#05,#0f,#00,#00,#0c,#00
db #00,#00,#00,#a6,#08,#00,#00,#51 ;.......Q
db #f3,#08,#00,#00,#00,#f3,#00,#00
db #00,#00,#51,#00,#00,#00,#00,#0f ;..Q.....
db #00,#00,#00,#00,#a7,#00,#00,#00
db #51,#0f,#00,#00,#00,#a2,#0f,#a2 ;Q.......
db #00,#00,#00,#03,#00,#00,#00,#51 ;.......Q
db #53,#00,#00,#00,#51,#51,#00,#00 ;S...QQ..
db #00,#a2,#51,#e2,#00,#00,#a2,#00 ;..Q.....
db #40,#00,#40,#80,#00,#00,#00,#05
db #0f,#00,#00,#0c,#00,#00,#00,#00
db #a6,#08,#00,#00,#51,#f3,#08,#00 ;....Q...
db #00,#00,#f3,#00,#00,#00,#00,#51 ;.......Q
db #00,#00,#51,#00,#0f,#00,#00,#00 ;..Q.....
db #f3,#5b,#00,#00,#00,#00,#0f,#a2
db #00,#00,#00,#0f,#51,#00,#00,#00 ;....Q...
db #03,#00,#00,#00,#00,#a3,#00,#00
db #00,#00,#f3,#00,#00,#00,#00,#a2
db #a2,#00,#00,#00,#a2,#40,#00,#00
db #40,#80,#80,#00,#05,#0f,#00,#00
db #0c,#00,#00,#00,#04,#59,#00,#00 ;.....Y..
db #00,#04,#f3,#a2,#00,#00,#00,#f3
db #00,#00,#00,#00,#a2,#00,#00,#00
db #00,#0f,#00,#00,#00,#18,#5b,#00
db #00,#40,#0c,#0f,#a2,#00,#40,#d1
db #0f,#51,#00,#00,#c0,#03,#00,#00 ;.Q......
db #00,#00,#a3,#a2,#00,#00,#00,#a2
db #a2,#00,#00,#d1,#a2,#51,#00,#00 ;.....Q..
db #80,#00,#51,#00,#00,#00,#00,#40 ;..Q.....
db #80,#05,#0f,#00,#00,#0c,#00,#00
db #00,#04,#59,#00,#00,#00,#04,#f3 ;..Y.....
db #a2,#00,#00,#00,#f3,#00,#00,#00
db #00,#a2,#00,#00,#04,#20,#0f,#00
db #a2,#84,#18,#a7,#f3,#00,#c0,#59 ;.......Y
db #0f,#00,#00,#40,#a2,#0f,#00,#00
db #00,#00,#03,#00,#00,#00,#00,#53 ;.......S
db #00,#00,#00,#00,#f3,#00,#00,#00
db #51,#51,#00,#00,#00,#80,#51,#00 ;QQ....Q.
db #00,#00,#40,#40,#80,#00,#05,#0f
db #00,#00,#0c,#00,#00,#00,#04,#59 ;.......Y
db #00,#00,#00,#04,#f3,#a2,#00,#00
db #00,#f3,#00,#00,#00,#00,#a2,#00
db #00,#00,#00,#0f,#00,#00,#00,#00
db #5b,#00,#00,#00,#00,#0f,#a2,#00
db #00,#51,#0f,#51,#00,#00,#00,#03 ;.Q.Q....
db #00,#00,#00,#00,#a3,#a2,#00,#00
db #00,#a2,#a2,#00,#00,#d1,#a2,#51 ;.......Q
db #00,#00,#80,#00,#51,#00,#00,#00 ;....Q...
db #00,#40,#80,#05,#0f,#00,#00,#0c
db #00,#00,#00,#04,#59,#00,#00,#00 ;....Y...
db #04,#f3,#a2,#00,#00,#00,#f3,#00
db #00,#00,#00,#a2,#00,#00,#00,#00
db #0f,#00,#a2,#00,#00,#a7,#f3,#00
db #00,#51,#0f,#00,#00,#00,#a2,#0f ;.Q......
db #00,#00,#00,#00,#03,#00,#00,#00
db #00,#53,#00,#00,#00,#00,#f3,#00 ;.S......
db #00,#00,#51,#51,#00,#00,#00,#80 ;..QQ....
db #51,#00,#00,#00,#40,#40,#80,#00 ;Q.......
db #05,#0f,#00,#04,#0c,#00,#00,#00
db #08,#a2,#08,#00,#00,#59,#f3,#08 ;.....Y..
db #00,#00,#51,#f3,#00,#00,#00,#00 ;..Q.....
db #a2,#51,#20,#00,#a7,#0f,#a6,#18 ;.Q......
db #00,#a7,#0f,#c0,#0c,#00,#a7,#0f
db #40,#80,#00,#a7,#0f,#00,#00,#00
db #01,#03,#00,#00,#00,#51,#53,#00 ;.....QS.
db #00,#00,#51,#51,#00,#00,#00,#d1 ;..QQ....
db #51,#00,#00,#00,#c0,#51,#00,#00 ;Q....Q..
db #00,#40,#40,#00,#00,#05,#0f,#00
db #04,#0c,#00,#00,#00,#08,#a2,#08
db #00,#00,#59,#f3,#08,#00,#00,#51 ;..Y....Q
db #f3,#00,#00,#00,#00,#a2,#00,#00
db #00,#a7,#0f,#a2,#00,#51,#05,#0f ;.....Q..
db #51,#00,#a2,#05,#0f,#00,#a2,#00 ;Q.......
db #05,#0f,#04,#20,#00,#01,#03,#84
db #18,#00,#51,#53,#c0,#0c,#00,#51 ;..QS...Q
db #51,#40,#80,#00,#51,#51,#80,#00 ;Q...QQ..
db #00,#51,#40,#80,#00,#00,#40,#40 ;.Q......
db #00,#00,#05,#0f,#00,#04,#0c,#00
db #00,#00,#08,#a2,#08,#00,#00,#59 ;.......Y
db #f3,#08,#00,#00,#51,#f3,#00,#00 ;....Q...
db #00,#00,#a2,#00,#00,#00,#a7,#0f
db #a2,#00,#00,#a7,#0f,#51,#00,#51 ;.....Q.Q
db #05,#0f,#00,#a2,#51,#05,#0f,#00 ;....Q...
db #00,#00,#01,#03,#00,#00,#00,#51 ;.......Q
db #53,#00,#00,#00,#51,#51,#00,#00 ;S...QQ..
db #00,#d1,#51,#00,#00,#00,#c0,#51 ;..Q....Q
db #00,#00,#00,#40,#40,#00,#00,#05
db #0f,#00,#04,#0c,#00,#00,#00,#08
db #a2,#08,#00,#00,#59,#f3,#08,#00 ;....Y...
db #00,#51,#f3,#00,#00,#00,#00,#a2 ;.Q......
db #00,#00,#00,#a7,#0f,#a2,#00,#51 ;.......Q
db #05,#0f,#a2,#00,#a2,#05,#0f,#51 ;.......Q
db #00,#00,#05,#0f,#51,#00,#00,#01 ;....Q...
db #03,#00,#00,#00,#51,#53,#00,#00 ;....QS..
db #00,#51,#51,#00,#00,#00,#51,#51 ;.QQ...QQ
db #80,#00,#00,#51,#40,#80,#00,#00 ;...Q....
db #40,#40,#00,#00,#05,#0f,#00,#00
db #00,#00,#44,#00,#00,#00,#00,#88 ;..D.....
db #88,#00,#00,#44,#00,#44,#88,#00 ;...D.D..
db #c8,#88,#00,#44,#cc,#c0,#88,#00 ;...D....
db #c8,#80,#c0,#88,#00,#c8,#00,#40
db #c4,#44,#80,#00,#00,#c4,#44,#80 ;.D....D.
db #00,#00,#88,#00,#c8,#00,#40,#88
db #44,#c8,#40,#44,#44,#88,#88,#80 ;D..DD...
db #c4,#00,#00,#44,#88,#88,#00,#00 ;...D....
db #00,#44,#00,#00,#00,#00,#00,#88 ;.D......
db #00,#05,#0f,#00,#00,#44,#70,#00 ;.....Dp.
db #00,#00,#cc,#98,#a0,#00,#00,#dd
db #ee,#70,#44,#cc,#88,#ee,#98,#cc ;.pD.....
db #cc,#cc,#cc,#30,#cc,#cc,#cc,#cc
db #98,#44,#cc,#cc,#cc,#30,#00,#0c ;.D......
db #0c,#4c,#98,#00,#50,#fa,#4c,#88 ;.L..P.L.
db #00,#50,#ae,#cc,#88,#00,#00,#4c ;.P.....L
db #cc,#00,#00,#00,#44,#d8,#00,#00 ;....D...
db #50,#f0,#50,#00,#00,#10,#00,#50 ;P.P....P
db #64,#00,#cc,#00,#00,#44,#05,#0f ;d....D..
db #00,#00,#44,#70,#00,#00,#00,#cc ;..Dp....
db #98,#a0,#00,#00,#88,#ee,#70,#00 ;......p.
db #44,#dd,#ee,#98,#00,#cc,#cc,#cc ;D.......
db #30,#44,#cc,#cc,#cc,#98,#cc,#cc ;.D......
db #cc,#cc,#30,#cc,#0c,#0c,#4c,#98 ;......L.
db #00,#50,#fa,#4c,#88,#00,#50,#ae ;.P.L..P.
db #cc,#88,#00,#00,#4c,#cc,#00,#00 ;....L...
db #00,#50,#cc,#00,#00,#00,#f0,#50 ;.P.....P
db #00,#00,#00,#20,#50,#00,#00,#44 ;....P..D
db #88,#cc,#00,#05,#0f,#00,#b0,#88
db #00,#00,#50,#64,#cc,#00,#00,#b0 ;..Pd....
db #dd,#ee,#00,#00,#64,#dd,#44,#cc ;....d.D.
db #88,#30,#cc,#cc,#cc,#cc,#64,#cc ;......d.
db #cc,#cc,#cc,#30,#cc,#cc,#cc,#88
db #64,#8c,#0c,#0c,#00,#44,#8c,#f5 ;d....D..
db #a0,#00,#44,#cc,#5d,#a0,#00,#00 ;..D.....
db #cc,#8c,#00,#00,#00,#e4,#88,#00
db #00,#00,#a0,#f0,#a0,#00,#98,#a0
db #00,#20,#00,#88,#00,#00,#cc,#00
db #05,#0f,#00,#b0,#88,#00,#00,#50 ;.......P
db #64,#cc,#00,#00,#b0,#dd,#44,#00 ;d.....D.
db #00,#64,#dd,#ee,#88,#00,#30,#cc ;.d......
db #cc,#cc,#00,#64,#cc,#cc,#cc,#88 ;...d....
db #30,#cc,#cc,#cc,#cc,#64,#8c,#0c ;.....d..
db #0c,#cc,#44,#8c,#f5,#a0,#00,#44 ;..D....D
db #cc,#5d,#a0,#00,#00,#cc,#8c,#00
db #00,#00,#cc,#a0,#00,#00,#00,#a0
db #f0,#00,#00,#00,#a0,#10,#00,#00
db #00,#cc,#44,#88,#00,#05,#0f,#00 ;..D.....
db #30,#30,#30,#00,#10,#cc,#cc,#cc
db #20,#44,#ff,#cc,#ff,#88,#64,#55 ;.D....dU
db #cc,#55,#98,#cc,#cc,#98,#cc,#cc ;.U......
db #cc,#cc,#cc,#64,#cc,#cc,#cc,#cc ;...d....
db #64,#cc,#8c,#0c,#0c,#0c,#4c,#04 ;d.....L.
db #f0,#f0,#f0,#08,#44,#58,#fa,#ae ;....DX..
db #88,#00,#d8,#fa,#ee,#00,#00,#44 ;.......D
db #cc,#88,#00,#10,#30,#00,#30,#20
db #10,#00,#00,#00,#20,#cc,#00,#00
db #00,#cc,#05,#0f,#00,#30,#30,#30
db #00,#10,#cc,#cc,#cc,#20,#44,#ff ;......D.
db #cc,#ff,#88,#64,#aa,#cc,#aa,#98 ;...d....
db #cc,#cc,#98,#cc,#cc,#cc,#cc,#cc
db #64,#cc,#cc,#cc,#cc,#64,#cc,#8c ;d....d..
db #0c,#0c,#0c,#4c,#04,#f0,#f0,#f0 ;...L....
db #08,#44,#5d,#f5,#a4,#88,#00,#dd ;.D......
db #f5,#e4,#00,#00,#44,#cc,#88,#00 ;....D...
db #00,#30,#00,#30,#00,#00,#20,#00
db #10,#00,#44,#88,#00,#44,#88,#02 ;..D..D..
db #04,#04,#20,#84,#18,#c0,#0c,#40
db #80,#02,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#02,#07,#f0,#a0,#a0
db #a0,#a0,#a0,#a0,#a0,#a0,#a0,#a0
db #a0,#f0,#a0,#02,#07,#f0,#00,#50 ;.......P
db #00,#50,#00,#50,#00,#50,#00,#50 ;.P.P.P.P
db #00,#f0,#a0,#02,#07,#f0,#a0,#00
db #a0,#00,#a0,#f0,#a0,#a0,#00,#a0
db #00,#f0,#a0,#02,#07,#f0,#a0,#00
db #a0,#00,#a0,#f0,#a0,#00,#a0,#00
db #a0,#f0,#a0,#02,#07,#a0,#a0,#a0
db #a0,#a0,#a0,#f0,#a0,#00,#a0,#00
db #a0,#00,#a0,#02,#07,#f0,#a0,#a0
db #00,#a0,#00,#f0,#a0,#00,#a0,#00
db #a0,#f0,#a0,#02,#07,#f0,#a0,#a0
db #00,#a0,#00,#f0,#a0,#a0,#a0,#a0
db #a0,#f0,#a0,#02,#07,#f0,#a0,#00
db #a0,#00,#a0,#00,#a0,#00,#a0,#00
db #a0,#00,#a0,#02,#07,#f0,#a0,#a0
db #a0,#a0,#a0,#f0,#a0,#a0,#a0,#a0
db #a0,#f0,#a0,#02,#07,#f0,#a0,#a0
db #a0,#a0,#a0,#f0,#a0,#00,#a0,#00
db #a0,#f0,#a0,#08,#07,#03,#02,#03
db #02,#03,#02,#03,#02,#02,#00,#02
db #00,#02,#02,#02,#02,#02,#00,#02
db #00,#02,#02,#02,#02,#03,#02,#02
db #00,#02,#02,#03,#02,#00,#02,#02
db #00,#02,#02,#03,#00,#00,#02,#02
db #00,#02,#02,#02,#02,#03,#02,#03
db #02,#03,#02,#02,#02,#06,#07,#03
db #02,#00,#00,#00,#00,#02,#00,#00
db #00,#00,#00,#02,#00,#00,#00,#03
db #02,#03,#02,#00,#00,#00,#00,#02
db #00,#00,#00,#03,#02,#02,#00,#00
db #00,#00,#00,#03,#02,#00,#00,#00
db #00,#08,#07,#02,#02,#03,#02,#03
db #02,#02,#02,#02,#02,#01,#00,#02
db #00,#02,#02,#02,#02,#01,#00,#02
db #00,#02,#02,#03,#02,#01,#00,#02
db #02,#03,#02,#02,#02,#01,#00,#02
db #02,#02,#02,#02,#02,#01,#00,#02
db #02,#02,#02,#02,#02,#03,#02,#03
db #02,#02,#02,#05,#0f,#00,#11,#3f
db #00,#00,#00,#33,#33,#2a,#00,#00
db #77,#bb,#2a,#00,#00,#22,#bb,#37 ;w.......
db #00,#11,#33,#33,#33,#2a,#11,#33
db #91,#33,#22,#33,#62,#62,#33,#37 ;....bb..
db #50,#b1,#91,#91,#33,#00,#11,#22 ;P.......
db #62,#33,#00,#b1,#22,#91,#80,#50 ;b......P
db #33,#00,#22,#22,#11,#22,#11,#00
db #22,#00,#00,#11,#00,#22,#00,#00
db #22,#00,#22,#00,#04,#08,#04,#08
db #05,#0f,#00,#11,#3f,#00,#00,#00
db #33,#33,#2a,#00,#00,#22,#bb,#2a
db #00,#00,#77,#bb,#37,#00,#11,#33 ;..w.....
db #33,#33,#2a,#11,#33,#91,#33,#22
db #33,#62,#62,#33,#37,#50,#33,#91 ;.bb..P..
db #91,#33,#33,#33,#00,#62,#33,#11 ;.....b..
db #22,#11,#91,#80,#00,#00,#11,#22
db #22,#00,#00,#11,#00,#33,#00,#00
db #11,#00,#11,#00,#00,#04,#00,#11
db #00,#00,#08,#00,#0c,#05,#0f,#00
db #00,#3f,#22,#00,#00,#15,#33,#33
db #00,#00,#15,#77,#bb,#00,#00,#3b ;...w....
db #77,#11,#00,#15,#33,#33,#33,#22 ;w.......
db #11,#33,#62,#33,#22,#3b,#33,#91 ;..b.....
db #91,#33,#33,#62,#62,#72,#a0,#33 ;...bbr..
db #91,#11,#22,#00,#40,#62,#11,#72 ;.....b.r
db #00,#11,#11,#00,#33,#a0,#11,#00
db #22,#11,#22,#11,#00,#22,#00,#00
db #11,#00,#11,#00,#00,#04,#08,#04
db #08,#00,#05,#0f,#00,#00,#3f,#22
db #00,#00,#15,#33,#33,#00,#00,#15
db #77,#11,#00,#00,#3b,#77,#bb,#00 ;w....w..
db #15,#33,#33,#33,#22,#11,#33,#62 ;.......b
db #33,#22,#3b,#33,#91,#91,#33,#33
db #62,#62,#33,#a0,#33,#91,#00,#33 ;bb......
db #33,#40,#62,#22,#11,#22,#11,#11 ;..b.....
db #22,#00,#00,#33,#00,#22,#00,#00
db #22,#00,#22,#00,#00,#22,#00,#08
db #00,#00,#0c,#00,#04,#00,#00,#05
db #0f,#00,#2a,#00,#15,#00,#11,#33
db #00,#33,#22,#11,#ff,#33,#ff,#22
db #11,#aa,#33,#aa,#22,#11,#33,#33
db #33,#22,#00,#33,#33,#33,#00,#00
db #11,#33,#22,#00,#00,#33,#33,#33
db #00,#00,#72,#f0,#b1,#00,#11,#72 ;..r....r
db #0f,#b1,#22,#11,#11,#0f,#22,#22
db #11,#11,#f0,#22,#22,#11,#00,#33
db #00,#22,#11,#00,#00,#00,#22,#0c
db #00,#00,#00,#0c,#05,#0f,#00,#2a
db #00,#15,#00,#11,#33,#00,#33,#22
db #11,#ff,#33,#ff,#22,#11,#55,#33 ;......U.
db #55,#22,#11,#33,#33,#33,#22,#00 ;U.......
db #33,#33,#33,#00,#00,#11,#33,#22
db #00,#00,#33,#33,#33,#00,#11,#72 ;.......r
db #f0,#b1,#22,#11,#11,#33,#22,#22
db #11,#00,#33,#00,#22,#11,#22,#00
db #11,#22,#00,#22,#00,#11,#00,#00
db #22,#00,#11,#00,#04,#08,#00,#04
db #08,#05,#0f,#54,#a8,#00,#00,#00 ;...T....
db #fd,#be,#14,#00,#00,#a8,#fe,#3c
db #14,#00,#fc,#fc,#fc,#3c,#00,#fc
db #fc,#fc,#fc,#28,#fc,#fc,#fc,#fc
db #28,#f0,#fc,#fc,#fc,#bc,#a0,#fc
db #fc,#fc,#fc,#00,#fc,#fc,#fc,#a8
db #50,#fc,#fc,#fc,#00,#f4,#a8,#a8 ;P.......
db #fc,#00,#fc,#00,#a8,#54,#00,#00 ;.....T..
db #54,#a8,#54,#00,#00,#54,#00,#54 ;T.T..T.T
db #00,#00,#cc,#00,#cc,#00,#05,#0f
db #54,#a8,#00,#00,#00,#a8,#be,#14 ;T.......
db #00,#00,#fd,#fe,#3c,#14,#00,#fc
db #fc,#fc,#3c,#00,#fc,#fc,#fc,#fc
db #28,#fc,#fc,#fc,#fc,#28,#fc,#fc
db #fc,#fc,#bc,#a0,#fc,#fc,#fc,#fc
db #00,#fc,#fc,#fc,#a8,#fc,#fc,#fc
db #fc,#00,#54,#54,#a8,#fc,#00,#00 ;..TT....
db #00,#a8,#54,#ec,#00,#00,#a8,#00 ;..T.....
db #44,#00,#00,#a8,#00,#44,#00,#44 ;D....D.D
db #88,#00,#00,#05,#0f,#00,#00,#00
db #54,#a8,#00,#00,#28,#7d,#fe,#00 ;T.......
db #28,#3c,#fd,#54,#00,#3c,#fc,#fc ;...T....
db #fc,#14,#fc,#fc,#fc,#fc,#14,#fc
db #fc,#fc,#fc,#7c,#fc,#fc,#fc,#f0
db #fc,#fc,#fc,#fc,#50,#54,#fc,#fc ;....PT..
db #fc,#00,#00,#fc,#fc,#fc,#a0,#00
db #fc,#54,#54,#f8,#00,#a8,#54,#00 ;.TT...T.
db #fc,#00,#a8,#54,#a8,#00,#00,#a8 ;...T....
db #00,#a8,#00,#00,#cc,#00,#cc,#00
db #05,#0f,#00,#00,#00,#54,#a8,#00 ;.....T..
db #00,#28,#7d,#54,#00,#28,#3c,#fd ;...T....
db #fe,#00,#3c,#fc,#fc,#fc,#14,#fc
db #fc,#fc,#fc,#14,#fc,#fc,#fc,#fc
db #7c,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#50,#54,#fc,#fc,#fc,#00,#00 ;.PT.....
db #fc,#fc,#fc,#fc,#00,#fc
lab9EEF db #54
db #a8,#a8,#dc,#a8,#54,#00,#00,#88 ;....T...
db #00,#54,#00,#00,#88,#00,#54,#00 ;.T....T.
db #00,#00,#00,#44,#88,#00,#05,#0f ;...D....
db #00,#fc,#00,#fc,#00,#54,#ff,#3c ;.....T..
db #ff,#a8,#fc,#55,#fc,#55,#fc,#fc ;...U.U..
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #54,#fc,#fc,#fc,#a8,#54,#a8,#f0 ;T....T..
db #54,#a8,#00,#a8,#00,#54,#00,#00 ;T....T..
db #fc,#00,#fc,#00,#00,#fc,#fc,#fc
db #00,#54,#a8,#fc,#54,#a8,#cc,#00 ;.T..T...
db #00,#00,#cc,#05,#0f,#00,#fc,#00
db #fc,#00,#54,#ff,#3c,#ff,#a8,#fc ;..T.....
db #aa,#fc,#aa,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#54,#fc,#fc ;.....T..
db #fc,#a8,#54,#a8,#f0,#54,#a8,#00 ;..T..T..
db #fc,#fc,#fc,#00,#00,#fc,#00,#fc
db #00,#00,#a8,#00,#54,#00,#00,#a8 ;....T...
db #00,#54,#00,#44,#88,#00,#44,#88 ;.T.D..D.
db #03,#05,#b8,#30,#fc,#b8,#fc,#74 ;.......t
db #b8,#30,#fc,#b8,#fc,#74,#b8,#30 ;.....t..
db #fc,#03,#05,#fc,#30,#fc,#b8,#fc
db #74,#b8,#fc,#74,#b8,#fc,#74,#fc ;t..t..t.
db #30,#fc,#03,#05,#b8,#fc,#74,#b8 ;......t.
db #74,#74,#b8,#b8,#74,#b8,#fc,#74 ;tt..t..t
db #b8,#fc,#74,#03,#05,#b8,#fc,#74 ;..t....t
db #b8,#fc,#74,#b8,#fc,#74,#b8,#fc ;..t..t..
db #74,#fc,#30,#fc,#03,#05,#fc,#30 ;t.......
db #74,#b8,#fc,#fc,#fc,#30,#fc,#fc ;t.......
db #fc,#74,#b8,#30,#fc,#05,#0f,#00 ;.t......
db #04,#a4,#a0,#00,#00,#4c,#4c,#0c ;.....LL.
db #00,#40,#0c,#0c,#0c,#a0,#04,#ff
db #18,#18,#08,#c0,#55,#0c,#0c,#58 ;....U..X
db #84,#55,#4c,#0c,#8c,#c0,#0c,#04 ;.UL.....
db #24,#18,#aa,#00,#04,#84,#8c,#00
db #aa,#ea,#48,#08,#40,#c4,#c4,#84 ;..H.....
db #80,#00,#c0,#c0,#c0,#00,#00,#00
db #c0,#88,#00,#00,#00,#88,#cc,#20
db #00,#00,#88,#00,#20,#00,#10,#20
db #00,#20,#05,#0f,#00,#04,#a4,#a0
db #00,#00,#4c,#4c,#0c,#00,#40,#0c ;..LL....
db #0c,#0c,#a0,#04,#55,#18,#18,#08 ;....U...
db #c0,#55,#0c,#0c,#58,#84,#ff,#4c ;.U..X..L
db #0c,#8c,#c0,#0c,#0c,#24,#18,#aa
db #ae,#84,#84,#8c,#40,#c0,#c0,#48 ;.......H
db #08,#00,#c4,#c4,#84,#80,#00,#40
db #c0,#c0,#00,#00,#00,#c0,#88,#00
db #10,#00,#88,#44,#00,#10,#64,#00 ;...D..d.
db #30,#00,#00,#20,#10,#20,#00,#05
db #0f,#00,#50,#58,#08,#00,#00,#0c ;..PX....
db #0c,#58,#00,#44,#0c,#24,#0c,#08 ;.X.D....
db #04,#4c,#0c,#ff,#08,#84,#24,#4c ;.L.....L
db #aa,#58,#84,#0c,#0c,#aa,#0c,#c0 ;.X......
db #8c,#20,#0c,#0c,#c0,#c0,#08,#00
db #55,#40,#84,#d5,#5d,#00,#40,#c0 ;U.......
db #c8,#c8,#80,#00,#c0,#c0,#c0,#00
db #00,#44,#c0,#00,#00,#10,#cc,#44 ;.D.....D
db #00,#00,#10,#00,#44,#00,#00,#10 ;....D...
db #00,#10,#20,#00,#05,#0f,#00,#50 ;.......P
db #58,#08,#00,#00,#0c,#0c,#58,#00 ;X.....X.
db #44,#0c,#24,#0c,#08,#04,#4c,#0c ;D.....L.
db #aa,#08,#84,#24,#4c,#aa,#58,#84 ;....L.X.
db #0c,#0c,#ff,#0c,#c0,#8c,#24,#0c
db #0c,#c0,#c0,#0c,#5d,#55,#40,#84 ;.....U..
db #c0,#0c,#08,#40,#c0,#c8,#c8,#00
db #00,#c0,#c0,#80,#00,#00,#44,#c0 ;......D.
db #00,#00,#00,#88,#44,#00,#20,#00 ;....D...
db #30,#00,#98,#20,#00,#10,#20,#10
db #00,#05,#0f,#00,#50,#58,#08,#00 ;....PX..
db #00,#0c,#0c,#58,#00,#44,#0c,#24 ;...X.D..
db #0c,#20,#04,#ff,#0c,#ff,#08,#84
db #55,#18,#55,#58,#84,#55,#0c,#55 ;U.UX.U.U
db #8c,#c0,#0c,#8c,#0c,#18,#c0,#0c
db #00,#0c,#24,#40,#d5,#00,#ae,#08
db #40,#c0,#00,#48,#80,#00,#c0,#c0 ;...H....
db #c0,#00,#00,#44,#c0,#88,#00,#10 ;...D....
db #44,#00,#88,#20,#10,#64,#00,#98 ;D....d..
db #20,#00,#20,#00,#10,#00,#05,#0f
db #00,#50,#58,#08,#00,#00,#0c,#0c ;.PX.....
db #58,#00,#44,#0c,#24,#0c,#20,#04 ;X.D.....
db #ff,#0c,#ff,#08,#84,#aa,#18,#aa
db #58,#84,#aa,#0c,#aa,#8c,#c0,#0c ;X.......
db #0c,#0c,#18,#c0,#5d,#00,#ae,#24
db #40,#aa,#00,#55,#08,#40,#d5,#00 ;...U....
db #40,#80,#00,#c0,#55,#c0,#00,#00 ;....U...
db #44,#c0,#88,#00,#00,#88,#00,#44 ;D......D
db #00,#10,#20,#00,#10,#20,#30,#00
db #00,#00,#30,#08,#10,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#e8,#fc,#fc
db #fc,#fc,#d4,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #d4,#fc,#fc,#e8,#fc,#fc,#e8,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#e8,#fc,#fc,#fc,#d4,#fc,#e8
db #fc,#fc,#fc,#d4,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#d4,#fc
db #d4,#fc,#d4,#fc,#e8,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#e8,#fc,#fc,#e8,#fc
db #d4,#fc,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#e8,#fc,#fc,#fc,#fc,#fc,#fc
db #fc,#fc,#fc,#fc,#fc,#08,#10,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#0c
db #48,#8c,#0c,#0c,#48,#8c,#0c,#0c ;H...H...
db #48,#8c,#0c,#0c,#48,#8c,#0c,#c0 ;H...H...
db #c0,#c8,#c0,#c0,#c0,#c8,#c0,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#8c
db #0c,#0c,#48,#8c,#0c,#0c,#48,#8c ;..H...H.
db #0c,#0c,#48,#8c,#0c,#0c,#48,#c8 ;..H...H.
db #c0,#c0,#c0,#c8,#c0,#c0,#c0,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#0c
db #48,#8c,#0c,#0c,#48,#8c,#0c,#0c ;H...H...
db #48,#8c,#0c,#0c,#48,#8c,#0c,#c0 ;H...H...
db #c0,#c8,#c0,#c0,#c0,#c8,#c0,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#8c
db #0c,#0c,#48,#8c,#0c,#0c,#48,#8c ;..H...H.
db #0c,#0c,#48,#8c,#0c,#0c,#48,#c8 ;..H...H.
db #c0,#c0,#c0,#c8,#c0,#c0,#c0,#08
db #10,#cc,#cc,#c0,#d0,#90,#60,#cc
db #cc,#cc,#c8,#f0,#f0,#e0,#60,#cc
db #cc,#cc,#d4,#f0,#f0,#e0,#30,#c4
db #cc,#dc,#d4,#f0,#f0,#f0,#90,#c4
db #cc,#dc,#f8,#f0,#f0,#e0,#c8,#cc
db #cc,#fc,#f0,#f0,#f0,#c4,#cc,#cc
db #cc,#60,#f0,#f0,#e0,#cc,#cc,#cc
db #c8,#60,#f0,#f0,#fc,#dc,#cc,#cc
db #90,#60,#f0,#f4,#fc,#fc,#cc,#c8
db #30,#b8,#d0,#e0,#74,#fc,#dc,#90 ;....t...
db #30,#b8,#d0,#90,#30,#fc,#b8,#74 ;.......t
db #30,#e8,#60,#30,#30,#b8,#30,#74 ;.......t
db #74,#fc,#30,#30,#30,#30,#30,#74 ;t......t
db #fc,#c8,#30,#30,#30,#30,#30,#30
db #ec,#cc,#90,#30,#60,#30,#30,#60
db #cc,#cc,#c8,#30,#d0,#90,#30,#c4
db #cc,#08,#10,#fc,#7c,#d4,#c4,#fc
db #7c,#bc,#d4,#e8,#e8,#fc,#fc,#bc
db #e8,#fc,#bc,#7c,#dc,#e8,#bc,#fc
db #fc,#d4,#dc,#fc,#d4,#fc,#fc,#dc
db #94,#e8,#dc,#d4,#bc,#dc,#7c,#e8
db #fc,#c8,#dc,#bc,#fc,#fc,#d4,#e8
db #7c,#ec,#fc,#d4,#c0,#7c,#c4,#fc
db #c0,#fc,#c8,#fc,#fc,#d4,#68,#fc ;......h.
db #c0,#7c,#d4,#7c,#7c,#fc,#fc,#d4
db #dc,#fc,#94,#e8,#e8,#e8,#bc,#fc
db #fc,#d4,#d4,#e8,#d4,#fc,#68,#d4 ;......h.
db #c8,#d4,#7c,#e8,#c0,#e8,#fc,#c8
db #fc,#d4,#e8,#c0,#6c,#fc,#bc,#e8 ;....l...
db #e8,#fc,#d4,#bc,#cc,#fc,#dc,#bc
db #bc,#bc,#fc,#fc,#d4,#c0,#d4,#fc
db #fc,#d4,#ec,#fc,#bc,#e8,#e8,#e8
db #fc,#d4,#c0,#08,#10,#cc,#cc,#cc
db #cc,#cc,#c4,#cc,#64,#98,#c8,#64 ;....d..d
db #c8,#64,#90,#c4,#cc,#cc,#cc,#cc ;.d......
db #64,#cc,#c4,#64,#98,#c0,#c0,#c0 ;d..d....
db #c0,#c0,#c0,#c0,#c0,#cc,#c8,#cc
db #c4,#cc,#cc,#cc,#cc,#64,#c8,#cc ;.....d..
db #30,#98,#cc,#98,#cc,#98,#c8,#cc
db #cc,#cc,#64,#c8,#98,#c0,#c0,#c0 ;..d.....
db #c0,#c0,#c0,#c0,#c0,#90,#cc,#cc
db #cc,#c4,#c8,#cc,#98,#64,#64,#64 ;.....ddd
db #cc,#c4,#cc,#64,#cc,#cc,#cc,#c8 ;...d....
db #98,#c4,#cc,#98,#cc,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c0,#cc,#c4,#cc
db #98,#cc,#cc,#cc,#c4,#64,#98,#cc ;.....d..
db #cc,#98,#cc,#98,#c4,#c8,#cc,#98
db #cc,#cc,#cc,#cc,#c4,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c0,#08,#10,#c0
db #0c,#84,#48,#c0,#0c,#84,#48,#0c ;..H...H.
db #84,#48,#c0,#0c,#84,#48,#c0,#84 ;.H...H..
db #48,#c0,#0c,#84,#48,#c0,#0c,#48 ;H...H..H
db #c0,#cc,#84,#48,#c0,#cc,#84,#c0 ;...H....
db #0c,#c4,#c8,#c0,#0c,#c4,#c8,#0c
db #84,#48,#c0,#0c,#84,#48,#c0,#84 ;.H...H..
db #48,#c0,#0c,#84,#48,#c0,#0c,#48 ;H...H..H
db #c0,#0c,#84,#48,#c0,#0c,#84,#c0 ;...H....
db #0c,#84,#48,#c0,#0c,#84,#48,#cc ;..H...H.
db #84,#48,#c0,#0c,#84,#48,#c0,#c4 ;.H...H..
db #c8,#c0,#cc,#84,#48,#c0,#0c,#48 ;....H..H
db #c0,#0c,#c4,#c8,#c0,#cc,#84,#c0
db #0c,#84,#48,#c0,#0c,#c4,#c8,#0c ;..H.....
db #84,#48,#c0,#0c,#84,#48,#c0,#84 ;.H...H..
db #48,#c0,#0c,#84,#48,#c0,#cc,#c8 ;H...H...
db #c0,#0c,#84,#48,#c0,#0c,#c4,#08 ;...H....
db #10,#c8,#cc,#cc,#c4,#cc,#c8,#cc
db #cc,#cc,#cc,#cc,#cc,#98,#cc,#cc
db #cc,#cc,#cc,#cc,#64,#cc,#cc,#64 ;....d..d
db #98,#cc,#64,#c4,#cc,#c8,#cc,#c8 ;..d.....
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#cc
db #cc,#cc,#cc,#64,#c8,#cc,#cc,#cc ;...d....
db #cc,#c4,#cc,#cc,#cc,#98,#cc,#98
db #c8,#cc,#cc,#cc,#cc,#cc,#cc,#cc
db #cc,#98,#c8,#98,#c8,#cc,#c8,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#cc
db #64,#cc,#cc,#cc,#cc,#cc,#64,#cc ;d.....d.
db #cc,#c8,#98,#cc,#cc,#c8,#cc,#cc
db #cc,#cc,#cc,#cc,#64,#cc,#cc,#98 ;....d...
db #cc,#98,#c8,#cc,#cc,#cc,#cc,#cc
db #c8,#cc,#cc,#cc,#c8,#cc,#64,#c8 ;......d.
db #cc,#c4,#cc,#64,#cc,#cc,#cc,#cc ;...d....
db #cc,#4e,#54,#45,#52,#20,#53,#54 ;.NTER.ST
db #41,#52,#54,#20,#53,#50,#45,#45 ;ART.SPEE
db #44,#3a,#ff ;D..
labA563 db #20
db #3d,#20
labA566 db #46
db #41,#53,#54,#ff ;AST.
labA56B db #20
db #3d,#20,#4d,#45,#44,#49,#55,#4d ;..MEDIUM
db #ff
labA575 db #20
db #3d,#20,#53,#4c,#4f,#57,#ff ;..SLOW.
labA57D db #43
db #4f,#4e,#47,#52,#41,#54,#55,#4c ;ONGRATUL
db #41,#54,#49,#4f,#4e,#53,#20,#21 ;ATIONS..
db #ff
labA58F db #59
db #6f,#75,#20,#68,#61,#76,#65,#20 ;ou.have.
db #64,#6f,#6e,#65,#20,#77,#65,#6c ;done.wel
db #6c,#2c,#20,#68,#75,#6d,#61,#6e ;l..human
db #2e,#ff
labA5AA db #59
db #6f,#75,#20,#61,#72,#65,#20,#77 ;ou.are.w
db #6f,#72,#74,#68,#79,#20,#74,#6f ;orthy.to
db #20,#62,#65,#20,#6b,#6e,#6f,#77 ;.be.know
db #6e,#20,#61,#73,#ff ;n.as.
labA5C8 db #46
db #72,#75,#69,#74,#79,#20,#46,#72 ;ruity.Fr
db #61,#6e,#6b,#2c,#20,#74,#68,#65 ;ank..the
db #20,#46,#72,#69,#73,#6b,#79,#20 ;.Frisky.
db #46,#72,#65,#61,#6b,#2e,#ff ;Freak..
labA5E8 db #50
db #6c,#65,#61,#73,#65,#20,#65,#6e ;lease.en
db #74,#65,#72,#20,#79,#6f,#75,#72 ;ter.your
db #20,#6e,#61,#6d,#65,#2e,#ff ;.name..


reloc_area:

org #A600,#100

begin_reloc_blk
labA600 db #46
db #52,#49,#53,#4b,#59,#20,#46,#52 ;RISKY.FR
db #45,#41,#4b,#53,#ff ;EAKS.
labA60E db #31
db #30,#ff
labA611 db #50
db #52,#45,#53,#53,#20,#20,#53,#50 ;RESS..SP
db #41,#43,#45,#20,#20,#4f,#52,#20 ;ACE..OR.
db #7b,#46,#49,#52,#45,#ff ;.FIRE.
labA628 db #20
db #3d,#20,#54,#48,#52,#4f,#57,#20 ;..THROW.
db #42,#41,#4c,#4c,#ff ;BALL.
labA636 db #20
db #3d,#20,#50,#41,#55,#53,#45,#ff ;..PAUSE.
labA63F db #43
db #4f,#50,#59,#52,#49,#47,#48,#54 ;OPYRIGHT
db #20,#20,#a4,#20,#20,#53,#54,#45 ;.....STE
db #56,#45,#4e,#20,#57,#41,#4c,#4c ;VEN.WALL
db #49,#53,#20,#31,#39,#38,#34,#ff ;IS......
labA660 db #20
db #4b,#55,#4d,#41,#20,#50,#52,#45 ;KUMA.PRE
db #53,#45,#4e,#54,#53,#20 ;SENTS.
labA66F db #ff
db #20,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#20,#20,#32,#30,#20,#2e
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #20,#20,#34,#30,#20,#50,#4f,#49 ;.....POI
db #4e,#54,#53,#20,#20,#2e,#2e,#2e ;NTS.....
db #2e,#2e,#2e,#2e,#2e,#2e,#20,#20
db #35,#30,#20,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#20,#31,#30,#30
db #20,#50,#4f,#49,#4e,#54,#53,#20 ;.POINTS.
db #20,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#20,#31,#30,#30,#20,#2e
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #20,#32,#30,#30,#20,#50,#4f,#49 ;.....POI
db #4e,#54,#53,#20,#20,#2e,#2e,#2e ;NTS.....
db #2e,#2e,#2e,#2e,#20,#42,#4f,#4e ;.....BON
db #55,#53,#20,#2e,#20,#53,#55,#50 ;US...SUP
db #45,#52,#20,#42,#4f,#4e,#55,#53 ;ER.BONUS
db #20,#50,#4f,#49,#4e,#54,#53,#20 ;.POINTS.



labA700 jp labA76C
labA703 jp labA7D1
labA706 jp labA7E3
labA709 jp labA7F2
labA70C jp labA7F4+1
labA70F jp labA7F9
labA712 jp labA803
labA715 jp labA80D
dataa718 db #c3
db #13,#a8
labA71B jp labA819
labA71E jp labA82A
labA721 jp labA82F
labA724 jp labA834
dataa727 db #c3
db #39,#a8,#c3,#3e,#a8,#c3,#43,#a8 ;......C.
labA730 jp labA848
labA733 jp labA85C
labA736 jp labA862
labA739 jp labA86E
labA73C jp labA877
labA73F jp labA8B1
labA742 jp labA8BF
labA745 jp labA8CB
labA748 jp labA8D9
labA74B jp labA8DF
labA74E jp labA8E5
labA751 jp labA8F3
dataa754 db #c3
db #35,#a9
labA757 db #c3
db #4e,#a9 ;N.
labA75A db #c3
db #68,#a9 ;h.
labA75D db #c3
db #92,#a9
labA760 db #84
labA761 db #b
labA762 db #0
labA763 db #3e
labA764 db #1
labA765 db #0
labA766 db #c
labA767 db #58
labA768 db #0
db #20,#20,#20
labA76C ld a,(ix+0)
labA76F cp #20
    jp c,labBB5A
    cp #80
    jp nc,labBB5A
    sub #20
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    ld de,labAA00
    add hl,de
    push hl
    ld hl,(labA9B6)
    ld a,l
    ld e,h
    inc h
    inc h
    ld (labA9B6),hl
    call labA90E
    pop hl
    ex de,hl
    ld b,#4
labA796 push bc
    ld c,#2
    ld a,(de)
    inc de
    push de
    ld e,a
labA79D ld b,#2
labA79F push hl
    rr e
    jr nc,labA7A7
    ld hl,labA9B8
labA7A7 ld a,(hl)
    and #aa
    ld d,a
    pop hl
    push hl
    rr e
    jr nc,labA7B4
    ld hl,labA9B8
labA7B4 ld a,(hl)
    and #55
    or d
    pop hl
    ld (hl),a
    inc hl
    djnz labA79F
    push de
    ld de,#7FE
    add hl,de
    jr nc,labA7C8
    ld de,#c050
    add hl,de
labA7C8 pop de
    dec c
    jr nz,labA79D
    pop de
    pop bc
    djnz labA796
    ret 
labA7D1 ld l,(ix+0)
    ld h,(ix+1)
labA7D7 ld a,(hl)
    cp #ff
    ret z
    push hl
    call labA76F
    pop hl
    inc hl
    jr labA7D7
labA7E3 ld h,(ix+6)
    ld d,(ix+4)
    ld l,(ix+2)
    ld e,(ix+0)
    jp labBB66
labA7F2 ld a,#1
labA7F4 ld b,#af
    jp labBB63
labA7F9 ld h,(ix+2)
    ld l,(ix+0)
    ld (labA9B6),hl
    ret 
labA803 ld a,(ix+0)
    call labBC2C
    ld (labA9B8),a
    ret 
labA80D ld a,(ix+0)
    jp labBB96
dataa813 db #dd
db #7e,#00,#c3,#b4,#bb
labA819 ld bc,labBBC0
labA81C ld d,(ix+3)
    ld e,(ix+2)
    ld h,(ix+1)
    ld l,(ix+0)
    push bc
    ret 
labA82A ld bc,labBBC3
    jr labA81C
labA82F ld bc,labBBF6
    jr labA81C
labA834 ld bc,labBBF9
    jr labA81C
dataa839 db #1
db #ea,#bb,#18,#de,#01,#ed,#bb,#18
db #d9,#01,#c9,#bb,#18,#d4
labA848 ld d,(ix+7)
    ld e,(ix+6)
    ld h,(ix+5)
    ld l,(ix+4)
    call labBBCF
    ld bc,labBBD2
    jr labA81C
labA85C ld a,(ix+0)
    jp labBC0E
labA862 ld a,(ix+4)
    ld b,(ix+2)
    ld c,(ix+0)
    jp labBC32
labA86E ld b,(ix+2)
    ld c,(ix+0)
    jp labBC38
labA877 ld a,(ix+12)
    ld hl,labA760
    ld (hl),a
    ld a,(ix+10)
    ld (labA761),a
    ld a,(ix+8)
    ld (labA762),a
    ld a,(ix+6)
    ld (labA763),a
    ld a,(ix+7)
    ld (labA764),a
    ld a,(ix+4)
    ld (labA765),a
    ld a,(ix+2)
    ld (labA766),a
    ld a,(ix+0)
    ld (labA767),a
    ld a,(ix+1)
    ld (labA768),a
    jp labBCAA
labA8B1 ld a,(ix+2)
    call labBCAD
    ld l,(ix+0)
    ld h,(ix+1)
    ld (hl),a
    ret 
labA8BF ld l,(ix+0)
    ld h,(ix+1)
    ld de,#000
    jp labBD10
labA8CB call labBD0D
    ld e,(ix+0)
    ld d,(ix+1)
    ex de,hl
    ld (hl),e
    inc hl
    ld (hl),d
    ret 
labA8D9 ld a,(ix+0)
    jp labBBDE
labA8DF ld a,(ix+0)
    jp labBBE4
labA8E5 ld l,(ix+0)
    ld h,(ix+1)
    call labBB09
    jr c,labA8F1
    xor a
labA8F1 ld (hl),a
    ret 
labA8F3 ld a,(ix+2)
    call labBB1E
    ld l,(ix+0)
    ld h,(ix+1)
    jr z,labA905
    ld a,#ff
labA903 ld (hl),a
    ret 
labA905 xor a
    jr labA903
dataa908 db #dd
db #7e,#00,#dd,#5e,#02
labA90E push af
    and #f8
    ld l,a
    ld h,#0
    ld b,h
    ld c,l
    add hl,hl
    add hl,hl
    add hl,bc
    add hl,hl
    pop af
    and #7
    rlca 
    rlca 
    rlca 
    or #c0
    ld d,a
    add hl,de
    ex de,hl
    ld c,(ix+4)
    ld hl,lab9010
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ret 
dataa935 db #cd
db #08,#a9,#c5,#d5,#06,#00,#ed,#b0
db #d1,#eb,#06,#08,#09,#30,#04,#01
db #50,#c0,#09,#eb,#c1,#10,#eb,#c9 ;P.......
db #cd,#08,#a9,#eb,#af,#c5,#e5,#77 ;.......w
db #23,#0d,#20,#fb,#e1,#06,#08,#09
db #30,#04,#01,#50,#c0,#09,#c1,#10 ;...P....
db #ec,#c9,#cd,#08,#a9,#eb,#c5,#e5
db #06,#00,#1a,#13,#ed,#a1,#20,#18
db #ea,#70,#a9,#e1,#06,#08,#09,#30 ;.p......
db #04,#01,#50,#c0,#09,#c1,#10,#e6 ;..P.....
db #dd,#6e,#06,#dd,#66,#07,#70,#c9 ;.n..f.p.
db #e1,#c1,#18,#f4,#cd,#08,#a9,#eb
db #c5
labA997 db #e5
db #1a,#be,#28,#05,#7e,#fe,#cf,#20
db #02,#36,#00,#23,#13,#0d,#20,#f0
db #e1,#06,#08,#09,#30,#04,#01,#50 ;.......P
db #c0,#09,#c1,#10,#e1,#c9
labA9B6 db #4
db #2e
labA9B8 db #3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#06,#18,#05,#14
db #15,#1a,#04
labA9E4 db #48
db #49,#47,#48,#20 ;IGH.
labA9E9 db #53
db #43,#4f,#52,#45,#ff,#4c,#45,#56 ;CORE.LEV
db #45,#4c,#20,#ff ;EL..
labA9F6 db #47
db #41,#4d,#45,#20,#4f,#56,#45 ;AME.OVE
labA9FE db #52
db #ff
labAA00 db #0
db #00,#00,#00,#22,#22,#02,#02,#55 ;.......U
db #05,#00,#00,#20,#27,#27,#00,#26
db #72,#22,#07,#55,#24,#51,#05,#52 ;r..U.Q.R
db #32,#55,#02,#22,#02,#00,#00,#24 ;.U......
db #11,#21,#04,#21,#44,#24,#01,#50 ;....D..P
db #72,#52,#00,#20,#72,#22,#00,#00 ;rR..r...
db #00,#20,#12,#00,#70,#00,#00,#00 ;....p...
db #00,#00,#02,#44,#22,#12,#01,#57 ;...D...W
db #55,#55,#07,#23,#22,#22,#07,#47 ;UU.....G
db #74,#11,#07,#47,#74,#44,#07,#55 ;t..GtD.U
db #75,#44,#04,#17,#71,#44,#07,#17 ;uD..qD..
db #71,#55,#07,#47,#44,#44,#04,#57 ;qU.GDD.W
db #75,#55,#07,#57,#75,#44,#07,#00 ;uU.WuD..
db #20,#00,#02,#00,#20,#20,#12,#40
db #12,#42,#00,#00,#07,#07,#00,#10 ;.B......
db #42,#12,#00,#47,#64,#02,#02,#57 ;B..Gd..W
db #55,#11,#07,#52,#75,#55,#05,#53 ;U..RuU.S
db #35,#55,#03,#52,#11,#51,#02,#53 ;.U.R.Q.S
db #55,#55,#03,#17,#31,#11,#07,#17 ;UU......
db #31,#11,#01,#52,#11,#55,#06,#55 ;...R.U.U
db #75,#55,#05,#27,#22,#22,#07,#46 ;uU.....F
db #44,#54,#02,#55,#35,#55,#05,#11 ;DT.U.U..
db #11,#11,#07,#75,#57,#55,#05,#55 ;...uWU.U
db #77,#57,#05,#52,#55,#55,#02,#53 ;wW.RUU.S
db #35,#11,#01,#52,#55,#55,#42,#53 ;...RUUBS
db #35,#55,#05,#52,#21,#54,#02,#27 ;.U.R.T..
db #22,#22,#02,#55,#55,#55,#02,#55 ;...UUU.U
db #55,#25,#02,#55,#55,#77,#05,#55 ;U..UUw.U
db #25,#55,#05,#55,#25,#22,#02,#47 ;.U.U...G
db #24,#11,#07,#17,#11,#11,#07,#10
db #21,#44,#00,#47,#44,#44,#07,#72 ;.D.GDD.r
db #27,#22,#02,#00,#00,#00,#07,#21
db #04,#00,#00,#00,#47,#57,#07,#11 ;....GW..
db #53,#55,#03,#00,#16,#11,#06,#44 ;SU.....D
db #56,#55,#06,#00,#57,#17,#07,#26 ;VU..W...
db #27,#22,#02,#00,#56,#65,#34,#11 ;....Ve..
db #53,#55,#05,#02,#22,#22,#02,#04 ;SU......
db #44,#44,#25,#11,#55,#53,#05,#22 ;DD..US..
db #22,#22,#02,#00,#75,#55,#05,#00 ;....uU..
db #53,#55,#05,#00,#52,#55,#02,#00 ;SU..RU..
db #53,#35,#11,#00,#56,#65,#44,#00 ;S...VeD.
db #16,#11,#01,#00,#16,#42,#03,#20 ;.....B..
db #27,#22,#06,#00,#55,#55,#06,#00 ;....UU..
db #55,#25,#02,#00,#55,#77,#05,#00 ;U...Uw..
db #55,#52,#05,#00,#55,#65,#34,#00 ;UR..Ue..
db #47,#12,#07,#24,#12,#22,#04,#22 ;G.......
db #22,#22,#02,#21,#42,#22,#01,#55 ;....B..U
db #05,#00,#00,#77,#77,#77,#77 ;...wwww
labAB80 db #53
db #50,#45,#45,#44,#20,#ff ;PEED..
labAB87 db #4c
db #45,#56,#45,#4c,#20,#ff ;EVEL..
labAB8E db #45
db #4e,#54,#45,#52,#20,#53,#54,#41 ;NTER.STA
db #52,#54,#20,#53,#50,#45,#45,#44 ;RT.SPEED
db #3a,#ff
labABA1 db #44
db #45,#4d,#4f,#ff ;EMO.
labABA6 db #44
db #45,#4d,#4f,#4e,#53,#54,#52,#41 ;EMONSTRA
db #54,#49,#4f,#4e,#20,#47,#41,#4d ;TION.GAM
db #45,#ff ;E.
labABB9 db #7d
db #20,#54,#4f,#20,#53,#54,#41,#52 ;.TO.STAR
db #54,#ff ;T.
labABC4 db #55
db #53,#45,#20,#4a,#4f,#59,#53,#54 ;SE.JOYST
db #49,#43,#4b,#20,#7b,#30,#7d,#20 ;ICK.....
db #4f,#52,#20,#54,#48,#45,#53,#45 ;OR.THESE
db #20,#4b,#45,#59,#53,#3a,#ff,#3c ;.KEYS...

end_reloc_blk:

/*


db #3c,#18,#00,#3c,#ff,#ff,#18,#0c
db #18,#30,#18,#18,#3c,#7e,#18,#18
db #7e,#3c,#18,#00,#24,#66,#ff,#66 ;.....f.f
db #24,#00,#00

 
; #ac00
db #00,#00,#00,#00,#00
db #00,#00,#00,#01,#84,#01,#ff,#ff
db #00,#00,#00,#00,#81,#91,#04,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#08,#26,#c9,#fd
db #00,#00,#00,#00,#00,#00,#00,#00
db #08,#26,#c9,#fd,#00,#00,#00,#00
db #00,#00,#00,#00,#08,#26,#c9,#fd
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#02,#26
db #c9,#fd,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #04,#26,#c9,#fd,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#08,#26,#c9,#fd,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#10,#26,#c9,#fd
db #00,#00,#00,#00,#00,#72,#75,#6e ;.....run
db #22,#64,#69,#73,#63,#00,#00,#00 ;.disc...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#a1,#07,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#02,#01,#00
db #08,#0b,#ff,#0a,#04,#ff,#01,#05
db #02,#01,#05,#04,#01,#00,#00,#00
db #00,#00,#01,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#08,#00,#11,#00,#1a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #01,#00,#00,#00,#00,#00,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #ff,#00,#00,#00,#00,#00,#00,#00
db #0c,#02,#36,#02,#70,#ae,#bc,#04 ;....p...
db #a2,#04,#00,#01,#1d,#00,#00,#00
db #00,#00,#17,#00,#02,#00,#8c,#ff
db #02,#06,#ff,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#1a,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#82,#ff,#c2,#04,#fe,#bf,#0d
db #00,#ff,#16,#fb,#a6,#40,#00,#6f ;.......o
db #01,#ce,#07,#ce,#07,#f0,#07,#46 ;.......F
db #08,#00,#00,#eb,#07,#00,#00,#00
db #20,#84,#00,#00,#00,#00,#81,#01
db #4f,#04,#40,#04,#9f,#04,#9b,#04 ;O.......
db #16,#e2,#07,#00,#00,#00,#50,#84 ;......P.
db #00,#00,#00,#00,#81,#01,#5d,#04
db #40,#04,#9a,#04,#96,#04,#16,#d9
db #07,#00,#00,#00,#50,#84,#00,#00 ;....P...
db #00,#00,#81,#01,#6b,#04,#40,#04 ;....k...
db #95,#04,#91,#04,#16,#00,#00,#00
db #50,#85,#00,#00,#82,#c9,#00,#00 ;P.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
labAFEF db #0

db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#70 ;.......p
db #ae,#ff,#16,#ff,#16,#00,#00,#11
db #00,#17,#00,#06,#7e,#b0,#06,#a6
db #04,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#06,#a6,#04,#02
db #00,#82,#00,#30,#84,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #07,#6c,#65,#89,#00,#00,#00,#00 ;.le.....
db #00,#ff,#ff,#ff,#7f,#80,#fe,#ff
db #ff,#7f,#80,#00,#00,#00,#00,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#06,#53,#00,#00,#00,#00 ;..S....
labB1EF db #0
db #00,#00,#00,#00,#81,#8b,#20,#ff
db #00,#01,#08,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#04,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#01
db #02,#10,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#04,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#02,#04
db #20,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#3f,#03,#0a
db #ff,#06,#0a,#01,#06,#0f,#ff,#0c
db #00,#00,#00,#00,#00,#00,#01,#0f
db #ff,#06,#06,#fe,#01,#0f,#ff,#0c
db #00,#00,#00,#00,#00,#00,#04,#0f
db #01,#02,#05,#ff,#02,#01,#00,#06
db #0a,#ff,#03,#00,#00,#00,#03,#05
db #03,#01,#01,#00,#08,#0f,#ff,#03
db #0a,#ff,#03,#00,#00,#00,#01,#0f
db #ff,#0a,#03,#0a,#01,#0f,#ff,#03
db #0a,#ff,#03,#00,#00,#00,#01,#10
db #ff,#0a,#05,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#01,#0b
db #ff,#14,#05,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#01,#10
db #ff,#14,#1b,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#02,#0f
db #01,#06,#0f,#ff,#14,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#03,#04
db #ff,#01,#01,#00,#02,#04,#ff,#01
db #05,#02,#01,#05,#04,#01,#02,#01
db #00,#08,#0b,#ff,#0a,#04,#ff,#01
db #05,#02,#01,#05,#04,#01,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#82,#0a
db #fc,#01,#01,#28,#01,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#82,#05
db #02,#01,#06,#fe,#01,#0f,#ff,#0c
db #00,#00,#00,#00,#00,#00,#82,#05
db #ec,#01,#05,#13,#01,#0f,#ff,#0c
db #00,#00,#00,#00,#00,#00,#82,#05
db #f6,#01,#05,#0a,#01,#01,#00,#06
db #0a,#ff,#03,#00,#00,#00,#82,#03
db #f6,#01,#03,#0a,#01,#0f,#ff,#03
db #0a,#ff,#03,#00,#00,#00,#85,#05
db #fc,#01,#05,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#81,#01
db #01,#04,#05,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#82,#19
db #02,#01,#1b,#fe,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#82,#14
db #05,#01,#01,#9c,#01,#01,#00,#05
db #05,#02,#01,#05,#04,#01,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#f0,#f3
db #f1,#89,#86,#83,#8b,#8a,#f2,#e0
db #87,#88,#85,#81,#82,#80,#10,#2a
db #0d,#23,#84,#ff,#24,#ff,#2d,#29
db #5e,#70,#7c,#6d,#3d,#3a,#40,#5c ;.p.m....
db #6f,#69,#6c,#6b,#2c,#3b,#21,#7d ;oilk....
db #75,#79,#68,#6a,#6e,#20,#5d,#28 ;uyhjn...
db #72,#74,#67,#66,#62,#76,#27,#22 ;rtgfbv..
db #65,#7a,#73,#64,#63,#78,#26,#7b ;ezsdcx..
db #fc,#61,#09,#71,#fd,#77,#0b,#0a ;.a.q.w..
db #08,#09,#58,#5a,#ff,#7f,#f4,#f7 ;..XZ....
db #f5,#89,#86,#83,#8b,#8a,#f6,#e0
db #87,#88,#85,#81,#82,#80,#10,#3c
db #0d,#3e,#84,#ff,#40,#ff,#5f,#5b
db #7c,#50,#25,#4d,#2b,#2f,#30,#39 ;.P.M....
db #4f,#49,#4c,#4b,#3f,#2e,#38,#37 ;OILK....
db #55,#59,#48,#4a,#4e,#20,#36,#35 ;UYHJN...
db #52,#54,#47,#46,#42,#56,#34,#33 ;RTGFBV..
db #45,#5a,#53,#44,#43,#58,#31,#32 ;EZSDCX..
db #fc,#41,#09,#51,#fd,#57,#0b,#0a ;.A.Q.W..
db #08,#09,#58,#5a,#ff,#7f,#f8,#fb ;..XZ....
db #f9,#89,#86,#83,#8c,#8a,#fa,#e0
db #87,#88,#85,#81,#82,#80,#10,#ff
db #0d,#ff,#84,#ff,#5c,#ff,#1f,#a2
db #1e,#10,#ff,#0d,#ff,#ff,#00,#1c
db #0f,#09,#0c,#0b,#ff,#ff,#ff,#ff
db #15,#19,#08,#0a,#0e,#ff,#a6,#ff
db #12,#14,#07,#06,#02,#16,#ff,#1d
db #05,#1a,#13,#04,#03,#18,#1b,#7e
db #fc,#01,#e1,#11,#fe,#17,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#7f,#07,#03
db #4b,#ff,#ff,#ff,#ff,#ff,#ab,#8f ;K.......
db #01,#30,#01,#31,#01,#32,#01,#33
db #01,#34,#01,#35,#01,#36,#01,#37
db #01,#38,#01,#39,#01,#2e,#01,#0d
db #05,#52,#55,#4e,#22,#0d,#00,#00 ;.RUN....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#ff,#90,#b5,#28,#b6,#c1
db #b5,#00,#00,#02,#1e,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#b5,#02,#04,#00,#00
db #00,#c0,#40,#92,#c4,#fd,#06,#04
db #05,#80,#05,#80,#02,#04,#05,#80
db #05,#80,#02,#04,#07,#40,#02,#04
db #07,#40,#02,#04,#04,#10,#04,#08
db #07,#10,#06,#08,#02,#04,#06,#04
db #05,#04,#05,#40,#02,#04,#0f,#06
db #07,#00,#06,#96,#b4,#e6,#b4,#36
db #b5,#86,#b5,#70,#00,#08,#00,#94 ;...p....
db #01,#14,#00,#1c,#00,#85,#00,#12
db #00,#04,#00,#ff,#3f,#86,#00,#05
db #00,#97,#ff,#00,#00,#ff,#ff,#ff
db #6a,#00,#ff,#ff,#00,#00,#04,#00 ;j.......
db #00,#00,#00,#18,#13,#00,#02,#3f
db #00,#92,#13,#00,#00,#00,#00,#00
db #00,#18,#13,#00,#02,#c0,#00,#92
db #13,#ff,#00,#00,#00,#00,#00,#18
db #13,#00,#02,#c0,#00,#92,#13,#00
db #00,#00,#00,#00,#00,#18,#13,#00
db #02,#c0,#00,#92,#13,#00,#00

labB6EF db #0
db #00,#00,#00,#18,#13,#00,#02,#c0
db #00,#92,#13,#00,#00,#00,#00,#00
db #00,#18,#13,#00,#02,#c0,#00,#92
db #13,#00,#00,#00,#00,#00,#00,#18
db #13,#00,#02,#c0,#00,#92,#13,#00
db #00,#00,#00,#00,#00,#18,#13,#00
db #02,#c0,#00,#92,#13,#00,#04,#00
db #00,#00,#00,#18,#13,#00,#02,#3f
db #00,#92,#13,#00,#f0,#ff,#80,#ab
db #00,#ff,#ff,#00,#55,#aa,#55,#aa ;....U.U.
db #55,#aa,#00,#00,#00,#ff,#ff,#00 ;U.......
db #00,#00,#55,#aa,#55,#aa,#55,#aa ;..U.U.U.
db #00,#ff,#ff,#00,#00,#00,#00,#00
db #00,#0a,#00,#07,#00,#00,#00,#00
db #00,#00,#00,#80,#13,#15,#81,#35
db #13,#80,#97,#12,#80,#86,#12,#81
db #e9,#0a,#81,#40,#19,#00,#59,#14 ;......Y.
db #80,#e1,#14,#80,#19,#15,#80,#1e
db #15,#80,#23,#15,#80,#28,#15,#80
db #4f,#15,#80,#3f,#15,#81,#ab,#12 ;O.......
db #81,#a6,#12,#80,#5e,#15,#80,#99
db #15,#80,#8f,#15,#80,#78,#15,#80 ;.....x..
db #65,#15,#80,#52,#14,#81,#ec,#14 ;e..R....
db #81,#55,#0c,#80,#c6,#12,#89,#0d ;.U......
db #15,#84,#01,#15,#00,#eb,#14,#83
db #f1,#14,#82,#fa,#14,#80,#39,#15
db #82,#47,#15,#00,#00,#00,#c0,#c3 ;.G......
db #74,#0c,#00,#00,#00,#00,#00,#00 ;t.......
db #00,#00,#0a,#0a,#14,#14,#0c,#0e
db #0a,#03,#19,#1a,#1e,#00,#04,#15
db #1d,#18,#1c,#1f,#0b,#14,#14,#0c
db #0e,#0a,#03,#19,#1a,#1e,#00,#04
db #15,#1d,#18,#1c,#1f,#0b,#ff,#00
db #0a,#00,#00,#00,#00,#00,#81,#61 ;.......a
db #0d,#00,#00,#00,#0a,#a0,#5e,#a1
db #5c,#a2,#7b,#a3,#23,#a6,#40,#ab
db #7c,#ac,#7d,#ad,#7e,#ae,#5d,#af
db #5b,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#fb
db #b7,#00,#f0,#bf,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#8d,#03,#cb,#01,#9f,#07
db #7e,#01,#e5,#b7,#f8,#b7,#7c,#0d
db #11,#02,#fd,#b7,#2f,#01,#7e,#01
db #82,#73,#82,#80,#6d,#1d,#00,#00 ;.s..m...
db #00,#f9,#b7,#00,#00,#00,#00,#01
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00



db #c3,#5f,#ba,#c3,#66,#ba,#c3,#51 ;....f..Q
db #ba,#c3,#58,#ba,#c3,#70,#ba,#c3 ;..X..p..
db #79,#ba,#c3,#9d,#ba,#c3,#7e,#ba ;y.......
db #c3,#87,#ba,#c3,#a1,#ba,#c3,#a7
db #ba,#3a,#c1,#b8,#b7,#c8,#e5,#f3
db #18,#06,#21,#bf,#b8,#36,#01,#c9
db #2a,#c0,#b8,#7c,#b7,#28,#07,#23
db #23,#23,#3a,#c2,#b8,#be,#e1,#fb
db #c9,#f3,#08,#38,#33,#d9,#79,#37 ;......y.
db #fb,#08,#f3,#f5,#cb,#91,#ed,#49 ;.......I
db #cd,#b1,#00,#b7,#08,#4f,#06,#7f ;.....O..
db #3a,#31,#b8,#b7,#28,#14,#fa,#72 ;.......r
db #b9,#79,#e6,#0c,#f5,#cb,#91,#d9 ;.y......
db #cd,#0a,#01,#d9,#e1,#79,#e6,#f3 ;.....y..
db #b4,#4f,#ed,#49,#d9,#f1,#fb,#c9 ;.O.I....
db #08,#e1,#f5,#cb,#d1,#ed,#49,#cd ;......I.
db #3b,#00,#18,#cf,#f3,#e5,#d9,#d1
db #18,#06
labB98A di
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex af,af''
    ld a,d
    res 7,d
    res 6,d
    rlca 
    rlca 
    rlca 
    rlca 
    xor c
    and #c
    xor c
    push bc
    call labB9B0
    di
    exx
    ex af,af''
    ld a,c
    pop bc
    and #3
    res 1,c
    res 0,c
    or c
    jr labB9B1
labB9B0 push de
labB9B1 ld c,a
    out (c),c
    or a
    ex af,af''
    exx
    ei
    ret 
datab9b9 db #f3
db #08,#79,#e5,#d9,#d1,#18,#15,#f3 ;.y......
db #e5,#d9,#e1,#18,#09,#f3,#d9,#e1
db #5e,#23,#56,#23,#e5,#eb,#5e,#23 ;..V.....
db #56,#23,#08,#7e,#fe,#fc,#30,#be ;V.......
db #06,#df,#ed,#79,#21,#d6,#b8,#46 ;...y...F
db #77,#c5,#fd,#e5,#fe,#10,#30,#0f ;w.......
db #87,#c6,#da,#6f,#ce,#b8,#95,#67 ;...o...g
db #7e,#23,#66,#6f,#e5,#fd,#e1,#06 ;..fo....
db #7f,#79,#cb,#d7,#cb,#9f,#cd,#b0 ;.y......
db #b9,#fd,#e1,#f3,#d9,#08,#59,#c1 ;......Y.
db #78,#06,#df,#ed,#79,#32,#d6,#b8 ;x...y...
db #06,#7f,#7b,#18,#90,#f3,#e5,#d9
db #d1,#18,#08,#f3,#d9,#e1,#5e,#23
db #56,#23,#e5,#08,#7a,#cb,#fa,#cb ;V...z...
db #f2,#e6,#c0,#07,#07,#21,#d9,#b8
db #86,#18,#a5,#f3,#d9,#e1,#5e,#23
db #56,#cb,#91,#ed,#49,#ed,#53,#46 ;V...I.SF
db #ba,#d9,#fb,#cd,#df,#36,#f3,#d9
db #cb,#d1,#ed,#49,#d9,#fb,#c9,#f3 ;...I....
db #d9,#79,#cb,#91,#18,#13,#f3,#d9 ;.y......
db #79,#cb,#d1,#18,#0c,#f3,#d9,#79 ;y......y
db #cb,#99,#18,#05,#f3,#d9,#79,#cb ;......y.
db #d9,#ed,#49,#d9,#fb,#c9,#f3,#d9 ;..I.....
db #a9,#e6,#0c,#a9,#4f,#18,#f2,#cd ;....O...
db #5f,#ba,#18,#0f,#cd,#79,#ba,#3a ;.....y..
db #00,#c0,#2a,#01,#c0,#f5,#78,#cd ;......x.
db #70,#ba,#f1,#e5,#f3,#06,#df,#ed ;p.......
db #49,#21,#d6,#b8,#46,#71,#48,#47 ;I...FqHG
db #fb,#e1,#c9,#3a,#d6,#b8,#c9,#cd
db #ad,#ba,#ed,#b0,#c9,#cd,#ad,#ba
db #ed,#b8,#c9,#f3,#d9,#e1,#c5,#cb
db #d1,#cb,#d9,#ed,#49,#cd,#c2,#ba ;....I...
db #f3,#d9,#c1,#ed,#49,#d9,#fb,#c9 ;....I...
db #e5,#d9,#fb,#c9,#f3,#d9,#59,#cb ;......Y.
db #d3,#cb,#db,#ed,#59,#d9,#7e,#d9 ;....Y...
db #ed,#49,#d9,#fb,#c9,#d9,#79,#f6 ;.I....y.
db #0c,#ed,#79,#dd,#7e,#00,#ed,#49 ;..y....I
db #d9,#c9,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#cf,#5c
db #9b
labBB03 rst 8
databb04 db #98
db #9b,#cf,#bf,#9b
labBB09 rst 8
databb0a db #c5
db #9b,#cf,#fa,#9b,#cf,#46,#9c,#cf ;.....F..
db #b3,#9c,#cf,#04,#9c,#cf,#db,#9c
db #cf,#e1,#9c
labBB1E rst 8
databb1f db #45
db #9e,#cf,#38,#9d,#cf,#e5,#9d,#cf
db #d8,#9e,#cf,#c4,#9e,#cf,#dd,#9e
db #cf,#c9,#9e,#cf,#e2,#9e,#cf,#ce
db #9e,#cf,#34,#9e,#cf,#2f,#9e,#cf
db #f6,#9d,#cf,#f2,#9d,#cf,#fa,#9d
db #cf,#0b,#9e,#cf,#19,#9e,#cf,#74 ;.......t
db #90,#cf,#84,#90,#cf,#59,#94,#cf ;.....Y..
db #52,#94 ;R.
labBB5A rst 8
databb5b db #fe
db #93,#cf,#35,#93,#cf,#ac,#93
labBB63 rst 8
databb64 db #a8
db #93
labBB66 rst 8
databb67 db #8
db #92,#cf,#52,#92 ;..R.
labBB6C rst 8
databb6d db #4f
db #95,#cf,#5a,#91,#cf,#65,#91,#cf ;..Z..e..
db #70,#91,#cf,#7c,#91,#cf,#86,#92 ;p.......
db #cf,#97,#92,#cf,#76,#92,#cf,#7e ;....v...
db #92,#cf,#ca,#91,#cf,#65,#92,#cf ;.....e..
db #65,#92,#cf,#a6,#92,#cf,#ba,#92 ;e.......
labBB96 rst 8
databb97 db #ab
db #92,#cf,#c0,#92,#cf,#c6,#92,#cf
db #7b,#93,#cf,#88,#93,#cf,#d4,#92
db #cf,#f2,#92,#cf,#fe,#92,#cf,#2b
db #93,#cf,#d4,#94,#cf,#e4,#90,#cf
db #03,#91,#cf,#a8,#95,#cf,#d7,#95
labBBC0 db #cf
db #fe,#95
labBBC3 db #cf
db #fb,#95,#cf,#06,#96,#cf,#0e,#96
db #cf,#1c,#96
labBBCF rst 8
databbd0 db #a5
db #96
labBBD2 db #cf
db #ea,#96,#cf,#17,#97,#cf,#2d,#97
labBBDB rst 8
databbdc db #36
db #97
labBBDE rst 8
databbdf db #67
db #97,#cf,#75,#97 ;..u.
labBBE4 rst 8
databbe5 db #6e
db #97,#cf,#7a,#97,#cf,#83,#97,#cf ;..z.....
db #80,#97,#cf,#97,#97,#cf,#94,#97
labBBF6 db #cf
db #a9,#97
labBBF9 db #cf
db #a6,#97,#cf,#40,#99,#cf,#bf,#8a
db #cf,#d0,#8a,#cf,#37,#8b,#cf,#3c
db #8b,#cf,#56,#8b ;..V.
labBC0E rst 8
databc0f db #e9
db #8a,#cf,#0c,#8b,#cf,#17,#8b,#cf
db #5d,#8b,#cf,#6a,#8b,#cf,#af,#8b ;...j....
db #cf,#05,#8c,#cf,#11,#8c,#cf,#1f
db #8c,#cf,#39,#8c
labBC2C rst 8
databc2d db #8e
db #8c,#cf,#a7,#8c
labBC32 rst 8
databc33 db #f2
db #8c,#cf,#1a,#8d
labBC38 rst 8
databc39 db #f7
db #8c,#cf,#1f,#8d,#cf,#ea,#8c,#cf
db #ee,#8c,#cf,#b9,#8d,#cf,#bd,#8d
db #cf,#e5,#8d,#cf,#00,#8e,#cf,#44 ;.......D
db #8e,#cf,#f9,#8e,#cf,#2a,#8f,#cf
db #55,#8c,#cf,#74,#8c,#cf,#93,#8f ;U..t....
db #cf,#9b,#8f,#cf,#bc,#a4,#cf,#ce
db #a4,#cf,#e1,#a4,#cf,#bb,#ab,#cf
db #bf,#ab,#cf,#c1,#ab,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#df,#8b,#a8,#df,#8b,#a8,#df
db #8b,#a8,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#df,#8b,#a8,#cf,#af,#a9,#cf
db #a6,#a9,#cf,#c1,#a9,#cf,#e9,#9f
labBCAA rst 8
databcab db #14
db #a1
labBCAD rst 8
databcae db #ce
db #a1,#cf,#eb,#a1,#cf,#ac,#a1,#cf
db #50,#a0,#cf,#6b,#a0,#cf,#95,#a4 ;P..k....
db #cf,#9a,#a4,#cf,#a6,#a4,#cf,#ab
db #a4,#cf,#5c,#80,#cf,#26,#83,#cf
db #30,#83,#cf,#a0,#82,#cf,#b1,#82
db #cf,#63,#81,#cf,#6a,#81,#cf,#70 ;.c..j..p
db #81,#cf,#76,#81,#cf,#7d,#81,#cf ;..v.....
db #83,#81,#cf,#b3,#81,#cf,#c5,#81
db #cf,#d2,#81,#cf,#e2,#81,#cf,#27
db #82,#cf,#84,#82,#cf,#55,#82,#cf ;.....U..
db #19,#82,#cf,#76,#82,#cf,#94,#82 ;...v....
db #cf,#9a,#82,#cf,#8d,#82
labBD0D rst 8
databd0e db #99
db #80
labBD10 rst 8
databd11 db #a3
db #80,#cf,#ed,#85,#cf,#1c,#86
labBD19 rst 8
    or h
    add a,a
    rst 8
    halt
    add a,a
    rst 8
    ret nz
    add a,a
    rst 8
    add a,(hl)
    add a,a
    rst 8
    adc a,h
    add a,a
    rst 8
    ret po
    add a,a
    rst 8
    dec de
    adc a,b
    rst 8
    ld e,b
    adc a,b
    rst 8
    ld b,h
    adc a,b
    rst 8
    ld h,e
    adc a,b
    rst 8
    cp l
    adc a,b
    rst 8
    inc a
    sbc a,l
    rst 8
    cp #9b
    rst 8
    ld h,b
    sub h
    rst 8
    call pe,#cf95
    push de
    sbc a,c
    rst 8
    or b
    sub a
    rst 8
    xor h
    sub a
    rst 8
    ld hl,(#cf96)
    exx
    sbc a,c
    rst 8
    ld b,l
    adc a,e
    rst 8
    inc c
    adc a,b
    rst 8
    sub a
    add a,e
    rst 8
    ld (bc),a
    xor h
    rst 40
    sub c
labBD63 cpl 
    rst 40
    sbc a,a
labBD66 cpl 
    rst 40
    ret z
labBD69 cpl 
    rst 40
    exx
    cpl 
    rst 40
    ld bc,#ef30
    inc d
    jr nc,labBD63
    ld d,l
    jr nc,labBD66
    ld e,a
    jr nc,labBD69
    add a,#30
    rst 40
    and d
    inc (hl)
    rst 40
    ld e,c
    ld sp,lab9EEF
    inc (hl)
    rst 40
    ld (hl),a
    dec (hl)
    rst 40
    inc b
    ld (hl),#ef
    adc a,b
    ld sp,#dfef
    ld (hl),#ef
    ld sp,#ef37
    daa
    scf
    rst 40
    ld b,l
    inc sp
    rst 40
    ld (hl),e
    cpl 
    rst 40
    xor h
    ld (labAFEF),a
    ld (labB6EF),a
    ld sp,labB1EF
    ld sp,lab2FEE+1
    ld (lab53EE+1),a
    inc sp
    rst 40
    ld c,c
    inc sp
    rst 40
    ret z
    inc sp
    rst 40
    ret c
    inc sp
    rst 40
    pop de
    cpl 
    rst 40
    ld (hl),#31
    rst 40
    ld b,e
    ld sp,#000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp lab125F
    jp lab125F
    jp lab134B
    jp lab13BE
    jp lab140A
    jp lab1786
    jp lab179A
    jp lab17B4
    jp #C8A
    jp #C71
labBDEB jp #B17
    jp lab1DB8
    jp #835
    jp lab1D3F+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labBDEB
    sub b
    xor b
    ld (#fa00),a
    nop
    xor a
    rrca 
    inc c
    rlca 
    ld b,b
    add a,b
    nop
    ld a,(bc)
    nop
    ld b,a
    ld (bc),a
    nop
    ld a,(bc)
    jr labBE57
labBE57 ld a,(bc)
    ld b,#0
    nop
    nop
    nop
    nop
    rst 56
    nop
    add a,b
    and d
    or b
    xor c
    jp nc,lab10BF
    nop
    nop
    jp m,#000
    nop
    nop
    nop
    nop
    add a,b
    sub #c9
    rlca 
    ld b,a
    ld h,(hl)
    or b
    xor c
    nop
    nop
    nop
    nop
    nop
    nop
    and a
    ret 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labBF08 nop
    nop
labBF0A nop
labBF0B nop
    nop
    nop
    nop
    nop
    nop
    nop
labBF12 nop
    nop
labBF14 nop
    nop
labBF16 nop
    nop
labBF18 nop
    nop
labBF1A nop
    nop
labBF1C nop
    nop
labBF1E nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 48
    ld c,c
    dec e
    jp nc,lab52FE+2
    cp c
    dec b
    ld d,b
    ld h,#c9
    ld c,h
    cp (hl)
    nop
    ld (bc),a
    nop
    rst 48
    nop
    rst 48
    ld c,c
    dec e
    jp nc,lab52FE+2
    cp c
    dec b
    ld d,b
    ld h,#c9
    ld c,h
    cp (hl)
    nop
    ld a,(bc)
    or b
    xor e
    call m,#AC8
    ret 
    jp nc,lab52FE+2
    cp c
    nop
    ld a,(bc)
    ld h,b
    jp z,#80
    jp p,#cec8
    ret z
    ld b,l
    nop
    ld b,a
    cp (hl)
    nop
    ld a,(bc)
    or b
    xor c
    ld d,(hl)
    push bc
    jp (hl)
    call m,#db0f
    call nc,lab6B07
    ret m
    nop
    rst 48
    ld c,c
    dec e
    call c,lab52FE+2
    cp c
    nop
    rst 48
    ld c,c
    dec e
    ld l,e
    cp c
    inc e
    inc c
    ld h,h
    nop
    add hl,bc
    add a,d
    and d
    cp c
    add a,h
    ld a,a
    adc a,(hl)
labBFFD jp p,#de6f
*/




labbf08 equ #bf08
labbf0a equ #bf0a
labbf12 equ #bf12
labbf14 equ #bf14
labbf16 equ #bf16
labbf18 equ #bf18
labbf1a equ #bf1a
labbf1c equ #bf1c
labbf1e equ #bf1e

labbd19 equ #bd19
labbbdb equ #bbdb
labbb5a equ #bb5a
labbb63 equ #bb63


LABBFFD equ #BFFD
LABBB6C equ #BB6C
LABBB03 equ #BB03
LABBB66 equ #BB66
LABBC2C equ #BB2c
LABBB96 equ #BB96
LABBBC0 equ #BBc0
LABBF0B equ #BF0B
LABBBC3 equ #BBC3
LABBBF6 equ #BBf6
LABBBF9 equ #BBf9
LABBBCF equ #BBcf
LABBBD2 equ #BBd2
LABBC0E equ #BC0e
LABBC32 equ #BC32
LABBC38 equ #bC38
LABBCAD equ #BCAD
LABBCAA equ #BCAA
LABBD10 equ #BD10
LABBD0D equ #BD0D
LABBBDE equ #BBde
LABBBE4 equ #BBe4
LABBB09 equ #BB09
LABBB1E equ #BB1e

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

-- Project 124: font2spritemode1 by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'font2spritemode1',
    'Imported from z80Code. Author: fma. Convert a font (bit defined, 8 bytes) to a sprite for mode 1 (16 bytes)',
    'public',
    false,
    false,
    '2022-07-16T14:26:38.690000'::timestamptz,
    '2022-07-24T15:28:01.592000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Conversion font to sprite
; Char background is pen 0

BUILDSNA
BANKSET 0
ORG #4000
RUN start

GATE_ARRAY  EQU #7F00
BLACK       EQU #14
WHITE       EQU #00

; -----------------------------------------
; Select ink (use 16 for border)
MACRO M_SELECTINK ink
        LD   BC,GATE_ARRAY+{ink}
        OUT  (C),C
ENDM
; -----------------------------------------

; -----------------------------------------
; Set current ink to color
; Must be used after a M_SELECTINK or M_SETINKCOLOR macro
MACRO M_SETCOLOR color
        LD   A,#40+{color}
        OUT  (C),A
ENDM
; -----------------------------------------

; -----------------------------------------
; Test code
start
        ; Inhibit RST 38 interrupt vector
        DI
        LD   HL,#C9FB
        LD   (#38),HL
        EI

        LD  SP,#C000

;         M_SELECTINK 16
;         M_SETCOLOR BLACK
        M_SELECTINK 0
        M_SETCOLOR WHITE

        LD   HL,font
        LD   A,0
        CALL _font2Sprite
        LD   HL,#C050
        CALL _displaySprite

        LD   HL,font
        LD   A,1
        CALL _font2Sprite
        LD   HL,#C052
        CALL _displaySprite

        LD   HL,font
        LD   A,2
        CALL _font2Sprite
        LD   HL,#C054
        CALL _displaySprite

        LD   HL,font
        LD   A,3
        CALL _font2Sprite
        LD   HL,#C056
        CALL _displaySprite

        JR   $
; -----------------------------------------

; -----------------------------------------
; Convert font defined as bits (8 bytes height) to sprite in mode 1 (16 bytes)
;
; Input:
;   A = pen
;   HL = pointer to font as bits (8 bytes height)
; Output:
;   Result stored at ''sprite'' address
_font2Sprite
        CP   1                      ; pen 1?
        JR   Z,.pen1                ; yes
        CP   2                      ; pen 2?
        JR   Z,.pen2                ; yes
        CP   3                      ; pen 3?
        JR   Z,.pen3                ; yes
        
.pen0
        ; Clear sprite
        LD   HL,sprite
        LD   DE,sprite+1
        LD   BC,2*8-1
        LD   (HL),#00
        LDIR
        
        RET

.pen1
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop1
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        SLA  A
        SLA  A
        SLA  A
        SLA  A                      ; transfert to higher nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop1
        
        RET

.pen2
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop2
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        SRL  A
        SRL  A
        SRL  A
        SRL  A                      ; transfert to lower nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop2

        RET
        
.pen3
        LD   B,8                    ; 8 lines
        LD   DE,sprite              ; get sprite pointer address
.loop3
        LD   A,(HL)                 ; get font
        AND  %11110000              ; mask lower nibble
        LD   C,A
        SRL  A
        SRL  A
        SRL  A
        SRL  A                      ; transfert to lower nibble
        OR   C
        LD   (DE),A                 ; store to sprite pointer
        
        INC  DE                     ; increment sprite pointer
        LD   A,(HL)                 ; get font
        AND  %00001111              ; mask higher nibble
        LD   C,A
        SLA  A
        SLA  A
        SLA  A
        SLA  A                      ; transfert to higher nibble
        OR   C
        LD   (DE),A                 ; store to sprite pointer
        INC  DE                     ; increment sprite pointer
        INC  HL                     ; increment font pointer
        DJNZ .loop3

        RET
; -----------------------------------------

; -----------------------------------------
; Display sprite
; Input:
;   HL = screen destination address
_displaySprite
        LD   DE,sprite
        LD   B,8                    ; nb sprite lines
.loop
        PUSH BC                     ; preserve lines counter
        PUSH HL                     ; preserve screen address (start of line)

        LD   A,(DE)                 ; get sprite
        INC  DE                     ; increment sprite address
        LD   (HL),A                 ; put byte on screen
        INC  HL                     ; increment screen address

        LD   A,(DE)                 ; get sprite
        INC  DE                     ; increment sprite address
        LD   (HL),A                 ; put byte on screen
        INC  HL                     ; increment screen address

        POP  HL                     ; restore screen address (start of line)
        CALL _bc26                  ; compute next screen address

        POP  BC                     ; restore lines counter
        DJNZ .loop                  ; loop on lines (height)

        RET
; -----------------------------------------

; -----------------------------------------
; Compute video address below
; Input:
;   HL = current address
; Output:
;   HL = new address
_bc26
        PUSH DE                     ; save context

        LD   DE,#800
        ADD  HL,DE
        JR   NC,.end
        LD   DE,#C050
        ADD  HL,DE
.end
        POP  DE                     ; restore context

        RET
; -----------------------------------------

; -----------------------------------------
;
; Datas
;
; -----------------------------------------

sprite  DEFS 2*8

font
        DEFB %00111100
        DEFB %01000010,
        DEFB %10000001,
        DEFB %10100101,
        DEFB %10000001,
        DEFB %10011001,
        DEFB %01000010,
        DEFB %00111100
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
