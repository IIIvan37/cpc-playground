-- Migration: Import z80code projects batch 33
-- Projects 65 to 66
-- Generated: 2026-01-25T21:43:30.192864

-- Project 65: program379 by lordheavy
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program379',
    'Imported from z80Code. Author: lordheavy.',
    'public',
    false,
    false,
    '2023-05-08T10:38:24.952000'::timestamptz,
    '2023-05-09T09:35:31.646000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; sample code

org #A000

TXT_OUTPUT  equ #BB5A
KM_WAIT_KEY equ #BB18

start:
    LD  HL, message
message_loop:
    LD  A,(HL)
    OR  A
    JR  Z, message_end
    CALL TXT_OUTPUT
    INC HL
    JR message_loop
message_end:
    CALL KM_WAIT_KEY
    ret

message DB "Hello world !",0
end:

; rasm directives
run start
SAVE ''hello.bin'', start, end - start, DSK, ''hello.dsk''
;

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

-- Project 66: sorcery by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sorcery',
    'Imported from z80Code. Author: siko. Sorcery Source',
    'public',
    false,
    false,
    '2020-03-24T21:17:43.045000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org 0
run start

data0000 db #1
db #89,#7f
lab0003 db #ed
lab0004 db #49
db #c3,#91,#05
lab0008 jp labB98A
data000b db #c3
db #84,#b9,#c5
lab000F db #c9
lab0010 db #c3
db #1d,#ba
lab0013 db #c3
db #17
lab0015 db #ba
db #d5,#c9
lab0018 db #c3
db #c7,#b9,#c3,#b9,#b9,#e9
lab001F db #0
db #c3,#c6,#ba,#c3,#c1
lab0025 db #b9
lab0026 db #0
lab0027 db #0
db #c3,#35,#ba,#00,#ed,#49,#d9,#fb ;.....I..
lab0030 db #c7
db #d9,#21,#2b,#00,#71,#18,#08 ;....q..
lab0038 jp labB941
lab003B ret 
data003c db #0
db #00,#00,#00,#21,#00,#c0,#11,#00
db #90,#01,#00,#17,#ed,#b0,#21,#00
db #c0,#11
lab004F db #1
lab0050 db #c0
db #01,#ff,#3f,#75,#ed,#b0,#c3,#ca ;...u....
db #05,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab006A db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab0078 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
lab00B1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab00BE nop
    nop
lab00C0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab00FF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab010A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab0127 ld a,#10
    ld hl,lab0127
    ld de,labA556
    call labBC9E
    ret 
data0133 db #0
db #00,#00,#ef,#cf,#cf,#cf,#aa,#00
db #00,#00,#00,#82
lab0140 db #ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00
lab0150 db #af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#d5,#ff,#ff,#c1 ;...U....
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#ff,#ff,#ff
db #ff,#ff,#82,#ff,#ff,#33,#77,#ff ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#fa,#bb,#fc,#fc,#bb ;T.......
db #82,#11,#ff,#fc,#fd,#bb,#00,#55 ;.......U
db #f5,#ff,#ff,#63,#00,#55,#22,#00 ;...c.U..
db #00,#63,#00,#55,#bb,#00,#11,#c3 ;.c.U....
db #00,#00,#aa,#00,#00,#82,#00,#00
db #ff,#00,#55,#82,#00,#00,#55,#ff ;..U...U.
db #eb,#00,#00,#00,#00,#c3,#82,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
lab01F1 db #ff
db #c3,#00,#55,#d5,#ff,#ff,#c1,#00 ;..U.....
db #55,#ea,#d5,#c0,#eb,#00,#ff,#aa ;U.......
db #d5,#80,#ff,#82,#ff,#ff,#ff,#ff
db #ff,#82,#bb,#ff,#33,#77,#bb,#82 ;.....w..
db #fa,#bb,#fc,#fc,#bb,#82,#fa,#bb
db #54,#54,#bb,#82,#fa,#bb,#54,#54 ;TT....TT
db #bb,#82,#fa,#bb,#fc,#fc,#bb,#82
db #55,#77,#fc ;Uw.
lab022D db #fd
db #63,#00,#55,#f5,#ff,#ff,#63,#00 ;c.U...c.
db #55,#bb,#00,#11,#c3,#00,#00,#aa ;U.......
db #00,#00,#82,#00,#00,#ff,#00,#55 ;.......U
db #82,#00,#00,#55,#ff,#eb,#00,#00 ;...U....
db #00,#00
lab0250 db #eb
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#f5,#ff,#ff,#49 ;...U...I
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#bb,#ff,#ff
db #ff,#bb,#82,#bb,#ff,#33,#77,#bb ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#ff,#33,#fc,#fc,#63 ;T......c
db #00,#55,#77,#fc,#fd,#63,#00,#55 ;.Uw..c.U
db #bb,#ff,#bb,#c3,#00,#00,#aa,#00
db #00,#82,#00,#00,#ff,#00,#55 ;......U
lab02D0 db #82
db #00,#00,#55,#ff,#eb,#00,#00,#00 ;..U.....
db #00,#eb,#82,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00
lab0300 db #af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#d5,#ff,#ff,#c1 ;...U....
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#ff,#ff,#ff
db #ff,#ff
lab032B db #82
db #bb,#ff,#33,#77,#bb,#82,#fa,#bb ;...w....
db #fc,#fc
lab0336 db #bb
db #82,#fa,#bb,#54,#54,#bb,#82,#fa ;...TT...
db #bb,#54,#54,#bb,#82,#fa,#bb,#fc ;.TT.....
db #fc,#bb,#82,#55,#77,#fc,#fd,#63 ;...Uw..c
db #00,#55,#f5,#ff,#ff,#63,#00,#55 ;.U...c.U
db #bb,#00,#11,#c3,#00,#00,#aa,#00
db #00,#82,#00,#00,#ff,#00,#55,#82 ;......U.
db #00,#00,#55,#ff,#eb,#00,#00,#00 ;..U.....
db #00,#eb,#82,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#0a,#00
db #00,#00,#00,#00,#08,#00,#00,#00
db #00,#0a,#08,#00,#00,#00,#00,#00
db #88,#05,#00,#00,#00,#08,#0a,#05
db #00,#00,#00,#0a,#05,#88,#00,#00
db #00,#0a,#05,#0a,#00,#00,#00,#05
db #af,#05,#00,#0a,#0a,#05,#af,#05
db #00,#05,#af,#af,#af,#41,#0a,#55 ;.....A.U
db #af,#ff,#af,#41,#0a,#55,#ff,#ff ;...A.U..
db #eb,#c3,#00,#55,#ff,#bf,#eb,#c3 ;...U....
db #00,#55,#bf,#3f,#3f,#c3,#00,#55 ;.U.....U
db #bf,#3f,#3f
lab03D2 db #c3
db #00,#00,#bf,#3f,#3f,#82,#00,#00
db #bf,#3f,#3f,#82,#00,#00,#bf,#3f
db #3f,#82,#00,#00,#3f,#3f,#3f,#c3
db #00,#00,#3f,#3f,#3f,#c3,#00,#00
db #3f,#3f,#6b,#c3,#41,#3f,#6b,#3f ;..k.A.k.
db #6b,#c3,#c3,#c3,#c3,#97,#c3,#c3 ;k.......
db #c3,#00,#41,#c3,#c3,#c3,#82,#00 ;..A.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#05,#00
db #00,#00,#00,#00,#05,#00,#88,#00
db #00,#00,#44,#00,#88 ;..D..
lab0428 db #0
db #0a,#00,#05,#05,#00,#00,#0a,#0a
db #05,#05,#00,#00,#00,#05,#af,#05
db #00,#0a,#0a,#05,#af,#05,#00,#05
db #af,#af,#aa,#41,#00,#55,#af,#ff ;...A.U..
db #aa,#41,#00,#55,#ff,#ff,#eb,#c3 ;.A.U....
db #00,#55,#ff,#bf,#eb,#c3,#00,#55 ;.U.....U
db #bf,#3f,#3f,#c3,#00,#55,#bf,#3f ;.....U..
db #3f,#c3,#00,#00,#bf,#3f,#3f,#82
db #00,#00,#bf,#3f,#3f,#82,#00,#00
db #bf,#3f,#3f,#82,#00,#00,#3f,#3f
db #3f,#c3,#00,#00,#3f,#3f,#3f,#c3
db #00,#00,#3f,#3f,#6b,#c3,#00,#3f ;....k...
db #6b,#3f,#6b,#c3,#82,#c3,#c3,#97 ;k.k.....
db #c3,#c3,#c3,#00,#41,#c3,#c3,#c3 ;....A...
db #c3,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#50,#a0 ;......P.
db #00,#00,#00,#00,#f0,#72,#00,#00 ;.....r..
db #00,#50,#11,#66,#80,#00,#00 ;.P.f...
lab0500 db #0
db #11,#62,#80,#00,#00,#00,#11,#c4 ;.b......
db #c0,#00,#00,#00,#11,#c0,#c0,#00
db #00,#00,#11,#c0,#c0,#00,#00,#00
db #f5,#55,#55,#80,#00,#00,#04,#0c ;.UU.....
db #0c,#3c,#28,#3c,#3c,#3c,#3c,#3c
db #3c,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
lab0550 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#50,#f0,#00 ;.....P..
db #00,#00,#00,#b1,#62,#80,#00,#00 ;....b...
db #00,#66,#c0,#80,#00,#00,#50,#62 ;.f....Pb
db #c0,#40,#00,#00,#11,#c8,#c0,#00
db #00,#00,#11,#62,#c0,#00,#00,#00 ;...b....
db #f5,#75,#75,#80,#00,#00,#04,#0c ;.uu.....
db #0c,#3c,#28,#3c,#3c,#3c,#3c,#3c
db #3c,#00,#00,#00,#00,#21,#7c,#a6
db #11,#36,#01,#01,#86,#04,#ed,#b0
db #c9,#21,#36,#01,#11,#7c,#a6,#01
db #86,#04,#ed,#b0,#c3,#dc,#05,#c9
db #00,#00,#00
START di
    ld sp,labBFFD+3
    ld bc,lab7F8C
    out (c),c
    call lab1BDD
    ld iy,labAB28
    ld bc,labBC0C
lab05EF ld de,lab3000
    out (c),c
    inc b
    out (c),d
    dec b
    inc c
    out (c),c
    inc b
    out (c),e
    call lab2411
    ld a,#c3
    ld (lab0038),a
    ld hl,lab1D93
    ld (lab0038+1),hl
    ld a,#5
    ld (lab1C97),a
    ld hl,lab1CA6
    ld (lab1C98),hl
    call lab1605
    ei
lab061B call lab1BCF
    ld bc,lab7F8C
    out (c),c
    ld hl,lab1CD4
    call lab1BBF
lab0629 ld (iy+8),#28
    call lab0E4E
    call lab0E7B
    call lab0EB4
    call lab0DCB
    jp nc,lab0665
    ld b,#bc
    ld de,lab0127+1
lab0641 bit 0,(iy+0)
    jr z,lab0641
    res 0,(iy+0)
    out (c),d
    inc b
    out (c),e
    dec b
    dec e
    jp p,lab0641
    call lab1BCF
    ld de,lab0127+1
    ld b,#bc
    out (c),d
    inc b
    out (c),e
    jp lab06D2
lab0665 call lab1BCF
    ld bc,lab7F8D
    out (c),c
    ld hl,lab1CC3
    call lab1BBF
    ld de,lab00FF
    call lab1B32
    ld d,h
    ld c,a
    ld b,h
    ld b,c
    ld e,c
    daa
    ld d,e
    jr nz,lab06C9
    ld d,d
    ld b,l
    ld b,c
    ld d,h
    ld b,l
    ld d,e
    ld d,h
    jr nz,lab06DD+1
    ld c,a
    ld d,d
    ld b,e
    ld b,l
    ld d,d
lab0690 ld b,l
    ld d,d
    out (#21),a
    sub h
    ld hl,lab8E11
    ld (bc),a
    ld c,#5
lab069B ld b,#15
lab069D ld a,(hl)
    call lab1B4B
    inc hl
    djnz lab069D
    call lab1B9F
    call lab1B9F
    call lab1B9F
    push hl
    ld hl,lab006A
    add hl,de
    ex de,hl
    pop hl
    dec c
    jr nz,lab069B
    ld b,#6
lab06B9 bit 4,(iy+9)
    jp z,lab06D2
    ld a,(lab1C3B)
    add a,#29
    ld (lab1C3B),a
    dec hl
lab06C9 ld a,h
lab06CA or l
    jr nz,lab06B9
    djnz lab06B9
    jp lab061B
lab06D2 di
    call lab1BDD
    ld a,(lab1C3B)
    and #7
    cp #5
lab06DD jr c,lab06E1
    sub #5
lab06E1 ld c,a
lab06E2 ld (lab1C3B),a
    add a,c
    add a,c
    ld c,a
    ld b,#0
    ld hl,lab1D80
    add hl,bc
    ld a,(hl)
    ld (iy+8),a
    inc hl
    ld a,(hl)
    ld (iy+1),a
    inc hl
    ld a,(hl)
    ld (iy+2),a
    ld a,#4
    ld (lab1C97),a
    ld hl,lab1C9A
    ld (lab1C98),hl
    ld hl,#c630
    ld (lab1C36),hl
    ld hl,lab2810
    ld (lab1C38),hl
    ld a,#47
    ld (lab1C3A),a
    ld hl,lab5A40
    ld de,labAB68
    ld bc,lab0140
    ldir
    ld hl,lab5B80
    ld de,labAF78
    ld bc,lab0780
    ldir
    ld hl,labAB00
    ld de,labAB01
    ld bc,lab0027
    ld (hl),#0
    ldir
    ld ix,lab1C3C
    ld a,(lab1C3B)
    add a,a
    add a,a
    ld e,a
    ld d,#0
    add ix,de
    ld b,#4
lab074B push bc
    ld a,(ix+0)
    cp #ff
    jr z,lab0777
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld d,h
    ld e,l
    add hl,hl
    add hl,de
    ld de,labAF9A
    add hl,de
    ex de,hl
    ld hl,lab0003
    add hl,de
    ld b,#2
lab0769 ld a,(de)
    ld c,(hl)
    ex de,hl
    ld (de),a
    ld (hl),c
    inc de
    inc hl
    djnz lab0769
    ld (hl),#2
    ex de,hl
    ld (hl),#0
lab0777 pop bc
    inc ix
    djnz lab074B
    xor a
    ld (lab1C5F),a
lab0780 ld (lab1C60),a
    ld (lab1C61),a
    ld (data122d),a
    ld hl,lab2312
    ld (data230e),hl
    ld (lab2310),hl
    ld a,#7
lab0794 ld e,#35
    call lab22F1
    ld hl,lab1CB2
    call lab1BBF
    call lab1605
    ei
    call lab1BCF
    ld de,lab0780
    call lab1B32
    ld b,l
    ld c,(hl)
    ld b,l
    ld d,d
    ld b,a
    ld e,c
    ld l,#2e
    ld l,#2e
    ld l,#2e
    and l
    ld hl,lab2FC0
    ld de,#c630
    ld b,#28
lab07C1 push bc
    push de
    ld bc,lab0010
    ldir
    pop de
    ld a,d
    add a,#8
    ld d,a
    and #38
    jr nz,lab07D8
    push hl
    ld hl,#c050
    add hl,de
    ex de,hl
    pop hl
lab07D8 pop bc
    djnz lab07C1
    ld a,(iy+8)
    call lab0B53
    ld (iy+0),#0
    ld (iy+3),#4f
    ld (iy+4),#0
    ld (iy+5),#0
    ld (iy+6),#99
    ld (iy+7),#c0
    call lab1AF4
lab07FC ld a,(lab1C96)
    rla 
    jr nc,lab07FC
    bit 5,(iy+0)
    jr z,lab0824
lab0808 set 6,(iy+0)
lab080C bit 7,(iy+9)
    jr z,lab080C
lab0812 bit 4,(iy+9)
    jr nz,lab0812
    res 5,(iy+0)
    res 6,(iy+0)
    xor a
    ld (lab1C58),a
lab0824 ld a,#7
    ld (lab1C96),a
    ld a,(iy+5)
    ld (lab1C5E),a
    call lab0EEE
    call lab1A56
lab0835 call lab0B2C
    call lab14A1
    call lab14DD
    call lab17C5
    call lab1542
    call lab1584
    call lab1933
    call lab194C
    call lab1966
    call lab1980
    call lab1AA9
    ld a,(iy+8)
    cp #1c
    call z,lab11F0
    ld a,(lab1C5E)
    cp (iy+5)
    call nz,lab1AF4
    call lab1270
    bit 6,(iy+0)
    jr z,lab07FC
    ld de,lab05EF+1
    ld hl,lab2051
    bit 4,(iy+0)
    call nz,lab1B3F
    ld b,#5
    ld hl,data0000
lab0882 dec hl
    ld a,h
    or l
    jr nz,lab0882
    djnz lab0882
    call lab1BCF
    ld hl,lab1CC3
    call lab1BBF
    di
    ld a,#5
    ld (lab1C97),a
    ld hl,lab1CA6
    ld (lab1C98),hl
    call lab2411
    call lab1605
    ei
    ld bc,lab7F8D
    out (c),c
    ld de,lab0336
    call lab1B32
    ld e,c
    ld c,a
    ld d,l
    jr nz,lab0908
    ld b,e
    ld c,a
    ld d,d
    ld b,l
    ld b,h
    and b
    ld hl,lab1C5F
    call lab1B9F
    call lab1B9F
    call lab1B9F
    ld de,lab03D2
    call lab1B32
    ld b,c
    ld c,(hl)
    ld b,h
    jr nz,lab0923+2
    ld b,c
    ld d,(hl)
    ld b,l
    ld b,h
    and b
    ld a,(data122d)
    and #f
    or #30
    call lab1B4B
    call lab1B32
    jr nz,lab0939
    ld c,a
    ld d,d
    ld b,e
    ld b,l
    ld d,d
    ld b,l
    jp nc,lab2D3A
    ld (de),a
    cp #1
    ld a,#53
    call nz,lab1B4B
    ld a,#2e
    call lab1B4B
    ld a,(data122d)
lab08FF ld b,#a
    cp #8
    jr nz,lab0919
    ld de,lab0550
lab0908 ld hl,lab220C
    call lab1B3F
    ld de,lab05EF+1
    ld hl,lab2232
    call lab1B3F
    ld b,#14
lab0919 dec hl
    ld a,h
    or l
    jr nz,lab0919
    djnz lab0919
    call lab1BCF
lab0923 ld ix,lab2194
    ld hl,lab1C5F
    ld c,#0
lab092C ld a,(ix+21)
    cp (hl)
    jr c,lab0954
    jr nz,lab0946
    inc hl
    ld a,(ix+22)
    cp (hl)
lab0939 jr c,lab0954
    jr nz,lab0945
    inc hl
    ld a,(ix+23)
    cp (hl)
    jr c,lab0954
    dec hl
lab0945 dec hl
lab0946 ld de,lab0018
    add ix,de
    inc c
    ld a,c
    cp #5
    jr nz,lab092C
    jp lab061B
lab0954 ld a,#4
    sub c
    jr z,lab096A
    add a,a
    add a,a
    add a,a
    ld c,a
    add a,c
    add a,c
    ld c,a
    ld b,#0
    ld hl,lab21F3
    ld de,lab220B
    lddr
lab096A ld de,lab00BE
    call lab1B32
    ld d,a
    ld b,l
    ld c,h
    ld c,h
    jr nz,lab09B9+1
    ld c,a
    ld c,(hl)
    ld b,l
    and c
    ld de,lab0150
    call lab1B32
    ld e,c
    ld c,a
    ld d,l
    daa
    ld d,(hl)
    ld b,l
    jr nz,lab09CF
    ld c,a
    ld d,h
    jr nz,lab09CC+1
    jr nz,lab09D6
    ld c,c
    ld b,a
    ld c,b
    jr nz,lab09E6
    ld b,e
    ld c,a
    ld d,d
    ld b,l
    and c
    ld de,lab01F1
    call lab1B32
    ld d,b
    ld c,h
    ld b,l
    ld b,c
    ld d,e
    ld b,l
    jr nz,lab09E9+2
    ld c,(hl)
    ld d,h
    ld b,l
    ld d,d
    jr nz,lab0A05
    ld c,a
    ld d,l
    ld d,d
    jr nz,lab09FF
    ld b,c
    ld c,l
    ld b,l
    xor (hl)
    xor a
    ld (lab1C62),a
lab09B9 ld (lab1C63),a
    ld hl,lab1C64
    ld de,lab1C65
    ld bc,lab000F
    ld (hl),#2e
    ldir
lab09C9 ld de,lab032B
lab09CC ld hl,lab1C79
lab09CF ld a,(lab1C62)
    ld c,a
    ld b,#0
    add hl,bc
lab09D6 ld b,#1d
lab09D8 ld a,(hl)
    call lab1B4B
    cp #2e
    jr nz,lab09E3
    ld hl,lab1C78
lab09E3 inc hl
    djnz lab09D8
lab09E6 ld hl,#c347
lab09E9 call lab0B14
    ld de,lab0428
    ld b,#10
    ld hl,lab1C64
lab09F4 ld a,(hl)
    call lab1B4B
    inc hl
    djnz lab09F4
    ld a,(lab1C63)
    ld e,a
lab09FF ld d,#0
    ld hl,#c428
    add hl,de
lab0A05 add hl,de
    call lab0B14
    ld b,#5
lab0A0B bit 0,(iy+0)
    jr z,lab0A0B
    res 0,(iy+0)
    djnz lab0A0B
    bit 2,(iy+9)
    jr nz,lab0A2E
    ld a,(lab1C62)
    dec a
    ld (lab1C62),a
    jp p,lab09C9
    ld a,#1c
    ld (lab1C62),a
    jr lab09C9
lab0A2E bit 3,(iy+9)
    jr nz,lab0A47
    ld a,(lab1C62)
    inc a
    ld (lab1C62),a
    cp #1d
    jp c,lab09C9
    xor a
    ld (lab1C62),a
    jp lab09C9
lab0A47 bit 4,(iy+9)
    jp nz,lab09C9
    xor a
    ld (lab1C58),a
    ld a,(lab1C62)
    add a,#e
    cp #1d
    jr c,lab0A5D
    sub #1d
lab0A5D ld c,a
    ld b,#0
    ld hl,lab1C79
    add hl,bc
    ld a,(hl)
    cp #23
    jp z,lab0AFD
    cp #21
    jr z,lab0A88
    push af
    ld a,(lab1C63)
    ld c,a
    ld b,#0
    ld hl,lab1C64
    add hl,bc
    pop af
    ld (hl),a
    inc hl
    ld a,(lab1C63)
    inc a
    ld (lab1C63),a
    cp #10
    jp c,lab09C9
lab0A88 push ix
    pop de
    ld hl,lab1C64
    ld bc,lab0015
    ldir
    ld hl,lab1C5F
    ld bc,lab0003
    ldir
    ld hl,lab225A
lab0A9E ld de,lab1C64
    ld c,#0
lab0AA3 ld a,(de)
    cp #2e
    jr nz,lab0AAE
    inc c
    inc de
    bit 4,c
    jr z,lab0AA3
lab0AAE ld b,(hl)
    ld a,b
    and a
    jp z,lab0665
    inc hl
    add a,c
    and #f0
    jr nz,lab0AF8
lab0ABA ld a,(de)
    sub (hl)
    jr nz,lab0AF8
    inc de
    inc hl
    djnz lab0ABA
    ld de,lab06E2+2
    call lab1B32
    ld c,b
    ld b,l
    ld c,h
    ld c,h
    ld c,a
    jr nz,lab0B17
    ld d,l
    ld b,a
    ld c,b
    ld hl,lab5320
    ld d,h
    ld c,c
    ld b,e
    ld c,e
    jr nz,lab0B30-1
    ld c,a
    jr nz,lab0B30+2
    ld b,c
    ld b,d
    ld c,h
    ld b,l
    jr nz,lab0B29+1
    ld c,a
    ld c,a
    ld d,h
    ld b,d
    ld b,c
    ld c,h
    ld c,h
    and c
    ld b,#f
lab0AEE dec hl
    ld a,h
    or l
    jr nz,lab0AEE
    djnz lab0AEE
    jp lab0665
lab0AF8 inc hl
    djnz lab0AF8
    jr lab0A9E
lab0AFD ld a,(lab1C63)
    and a
    jp z,lab09C9
    dec a
    ld (lab1C63),a
    ld c,a
    ld b,#0
    ld hl,lab1C64
    add hl,bc
    ld (hl),#2e
    jp lab09C9
lab0B14 ld b,#2
lab0B16 ld a,(hl)
lab0B17 rra 
    rra 
    rra 
    rra 
    and #f
    ld (hl),a
    inc hl
    djnz lab0B16
    dec hl
    dec hl
    ld a,h
    add a,#8
    ld h,a
    and #38
lab0B29 jr nz,lab0B14
    ret 
lab0B2C ld ix,labAB34
lab0B30 call lab0B3E
    ld ix,labAB3C
    call lab0B3E
    ld ix,lab1CE5
lab0B3E call lab0C70
    ld a,(ix+0)
    and #f
    ld e,a
    ld d,#0
    ld hl,lab1D62
    add hl,de
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    jp (hl)
lab0B53 ld (iy+8),a
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld d,h
    ld e,l
    add hl,hl
    add hl,de
    ld de,labAF78
    add hl,de
    ld de,labAB32
    ld bc,lab0030
    ldir
    ld e,(iy+8)
    ld d,#0
    ld hl,labAB00
    add hl,de
    ld a,(hl)
    ld (hl),#ff
    ld bc,lab0500
    and a
    call z,lab1B8C
    call lab0E4E
    call lab0E7B
    call lab1795
    call lab0EB4
    ld c,#31
    ld de,lab1D27
    ld hl,labAB44
    call lab0C14
    inc hl
    call lab0C14
    inc hl
    ld c,#35
    call lab0C14
    inc hl
    call lab0C14
    inc hl
    ld c,#36
    ld de,lab1D33
    call lab0C14
    call lab0C14
    ld c,#43
    ld de,lab1D3C
    call lab0C14
    ld c,#42
    ld de,lab1D45
    call lab0C14
    call lab1AE2
    ld a,#4
    ld (lab1C96),a
    ld hl,lab1D07
    ld bc,lab08FF
    ld de,lab0004
lab0BD2 ld (hl),c
    add hl,de
    djnz lab0BD2
    ld hl,lab1230
    ld de,lab1231
    ld bc,lab001F
    ld (hl),#ff
    ldir
    ld a,(iy+8)
    cp #1c
    jr nz,lab0BFC
    ld a,(data122d)
    add a,a
    add a,a
    jr z,lab0BFC
    ld c,a
    ld b,#0
    ld hl,lab1250
    ld de,lab1230
    ldir
lab0BFC ld hl,lab1CE5
    ld (hl),#0
    ld a,(labAB60)
    cp #ff
    ret z
    ld (hl),#5
    inc hl
    ld (hl),a
    inc hl
    ld a,(labAB61)
    ld (hl),a
    inc hl
    ld (hl),#54
    ret 
lab0C14 push bc
    push hl
    push de
    ld b,(hl)
    inc b
    jr z,lab0C36
    dec b
    inc hl
    ld c,(hl)
    call lab0C5A
    pop de
    push de
    ld c,#3
lab0C25 ld b,#3
lab0C27 ld a,(de)
    ld (hl),a
    inc de
    inc hl
    djnz lab0C27
    push bc
    ld bc,lab0025
    add hl,bc
    pop bc
    dec c
    jr nz,lab0C25
lab0C36 pop de
    pop hl
    pop bc
    ld ix,lab1CED
    ld a,(hl)
    ld (ix+1),a
    inc hl
    ld a,(hl)
    ld (ix+2),a
    inc hl
    inc hl
db #dd,#71,#03 ;.q.
    ld a,(ix+1)
    inc a
    ret z
    push bc
    push de
    push hl
    call lab0C7C
    pop hl
    pop de
    pop bc
    ret 
lab0C5A ld a,b
    and #f8
    ld l,a
    ld e,a
    ld h,#0
    ld d,h
    add hl,hl
    add hl,hl
    add hl,de
    ld e,c
    srl e
    srl e
    add hl,de
    ld de,labACA8
    add hl,de
    ret 
lab0C70 push ix
    pop hl
    ld de,lab1C50
    ld bc,lab0004
    ldir
    ret 
lab0C7C xor a
    ld (lab1C54),a
    call lab0CF7
    jp lab0D3F
lab0C86 xor a
    ld (lab1C55),a
lab0C8A call lab0CC1
    jp lab0D3F
lab0C90 call lab0CC1
    call lab0CF7
    ld a,(lab1C51)
    sub (ix+1)
    jp z,lab0D3F
    jr nc,lab0CB1
    neg
    ld c,a
    ld a,(lab1C54)
    sub c
    jp c,lab0D3F
    ld (lab1C54),a
    jp lab0D27
lab0CB1 exx
    ld c,a
    ld a,(lab1C55)
    sub c
    exx
    jp c,lab0D3F
    ld (lab1C55),a
    jp lab0D27
lab0CC1 xor a
    ld (lab1C54),a
    ld a,(lab1C50)
    rla 
    jr nc,lab0CF4
    res 7,(ix+0)
    ld a,(lab1C52)
    rra 
    ld hl,data0d54
    jr nc,lab0CDB
    ld hl,DRAW_SPRITE_W6
lab0CDB ld (lab0D2C+1),hl
    ld a,(lab1C53)
    call CALC_TILE
    ld a,(lab1C51)
    ld b,a
    ld a,(lab1C52)
    ld c,a
    call CALC_POS
    ld a,#18
    ld (lab1C54),a
lab0CF4 ld c,#0
    ret 
lab0CF7 xor a
    ld (lab1C55),a
    exx
    set 7,(ix+0)
    bit 0,(ix+2)
    ld hl,data0d54
    jr z,lab0D0C
    ld hl,DRAW_SPRITE_W6
lab0D0C ld (lab0D35+1),hl
    ld a,(ix+3)
    call CALC_TILE
    ld b,(ix+1)
    ld c,(ix+2)
    call CALC_POS
    ld a,#18
    ld (lab1C55),a
    ld c,#0
    exx
    ret 
lab0D27 ld a,c
    and a
    jr z,lab0D2F
    dec c
lab0D2C call data0000
lab0D2F exx
    ld a,c
    and a
    jr z,lab0D3B
    dec c
lab0D35 call data0000
    exx
    jr lab0D27
lab0D3B exx
    or c
    jr nz,lab0D27
lab0D3F ld a,(lab1C54)
    ld c,a
    exx
    ld a,(lab1C55)
    ld c,a
    exx
    or c
    ret z
    xor a
    ld (lab1C55),a
    ld (lab1C54),a
    jr lab0D27
data0d54
DRAW_SPR_LINE_W6 db #6
db #06,#e5,#1a,#ae,#77,#13,#23,#10 ;....w...
db #f9,#e1,#7c,#c6,#08,#67,#e6,#38 ;.....g..
db #c0,#d5,#11,#50,#c0,#19,#d1,#c9 ;...P....
DRAW_SPRITE_W6 db #c5
db #e5,#01,#00,#06,#1a,#0f,#a9,#e6
db #55,#a9,#ae,#77,#1a,#17,#4f,#13 ;U..w..O.
db #23,#10,#f1,#79,#e6,#aa,#ae,#77 ;...y...w
db #e1,#c1,#7c,#c6,#08,#67,#e6,#38 ;.....g..
db #c0,#d5,#11,#50,#c0,#19,#d1,#c9 ;...P....
CALC_TILE push hl
    ld d,a
    ld e,#0
    ld l,a
    ld h,e
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    srl d
    rr e
    add hl,de
    ld de,lab7500
    add hl,de
    ex de,hl
    pop hl
    ret 
CALC_POS push de
    ld a,b
    and #f8
    ld l,a
    ld h,#0
    add hl,hl
    ld d,h
    ld e,l
    add hl,hl
    add hl,hl
    add hl,de
    ld a,b
    rla 
    rla 
    rla 
    and #38
    or #c0
    or h
    ld h,a
    ld e,c
    ld d,#0
    srl e
    add hl,de
    pop de
    ret 
lab0DCB ld hl,lab206F
    ld (data0e42),hl
lab0DD1 ld hl,(data0e42)
    ld a,(lab1C3B)
    add a,#4b
    ld (lab1C3B),a
    ld a,(hl)
    inc hl
    ld (data0e42),hl
    and a
    ret z
    bit 4,(iy+9)
    scf
    ret z
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,h
    add a,#62
    ld h,a
    ld de,lab0E46
    ld bc,lab0008
    ldir
    ld b,#4
lab0DFD bit 0,(iy+0)
    jr z,lab0DFD
    res 0,(iy+0)
    ld c,#0
    ld hl,lab0E46
    ld (lab0E44),hl
lab0E0F ld hl,#c690
    ld a,c
    or h
    ld h,a
    ld d,h
    ld e,l
    inc hl
    push bc
    ld bc,lab004F
    ldir
    pop bc
    ld hl,(lab0E44)
    ld a,(hl)
    and #c0
    ld (de),a
    rl (hl)
    rl (hl)
    inc hl
    ld (lab0E44),hl
    ld a,c
    add a,#8
    ld c,a
    and #c0
    jr z,lab0E0F
    push bc
    call lab1933
    call lab1980
    pop bc
    djnz lab0DFD
    jr lab0DD1
data0e42 db #0
db #00
lab0E44 db #0
db #00
lab0E46 db #0
db #00,#00,#00,#00,#00,#00,#00
lab0E4E ld b,(iy+8)
    inc b
    ld de,lab3240
lab0E55 ld a,(de)
    inc de
    inc a
    jr z,lab0E60
    dec a
    jr nz,lab0E55
    inc de
    jr lab0E55
lab0E60 djnz lab0E55
    ld hl,labACA8
lab0E65 ld a,(de)
    inc a
    ret z
    dec a
    jr z,lab0E6E
    ld (hl),a
    jr lab0E77
lab0E6E inc de
    ld a,(de)
    ld b,a
    xor a
lab0E72 ld (hl),a
    inc hl
    djnz lab0E72
    dec hl
lab0E77 inc de
    inc hl
    jr lab0E65
lab0E7B ld hl,labBFFD+3
    ld de,labACA8
    call lab1605
    ld bc,lab02D0
lab0E87 push bc
    push de
    push hl
    ld a,(de)
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,lab6500
    add hl,de
    pop de
    push de
    ld b,#8
    ld c,b
lab0E9B ld a,(hl)
    ld (de),a
    inc hl
    inc de
    ld a,(hl)
    ld (de),a
    inc hl
    dec de
    ld a,d
    add a,c
    ld d,a
    djnz lab0E9B
    pop hl
    pop de
    pop bc
    inc hl
    inc hl
    inc de
    dec bc
    ld a,b
    or c
    jr nz,lab0E87
    ret 
lab0EB4 ld hl,labACA8
    ld bc,lab02D0
lab0EBA ld a,(hl)
    ld (hl),#0
    dec a
    cp #de
    jr nc,lab0EE7
    inc a
    sub #1e
    sub #2
    jr c,lab0ED9
    sub #26
    sub #2
    jr c,lab0EDD
    sub #26
    sub #2
    jr c,lab0EE1
    ld (hl),#80
    jr lab0EE7
lab0ED9 ld d,#81
    jr lab0EE3
lab0EDD ld d,#1
    jr lab0EE3
lab0EE1 ld d,#2
lab0EE3 ld (hl),d
    inc hl
    dec bc
    ld (hl),d
lab0EE7 inc hl
    dec bc
    ld a,b
    or c
    jr nz,lab0EBA
    ret 
lab0EEE ld ix,labAB28
    call lab0C70
    ld a,(iy+0)
    and #7
    ld e,a
    ld d,#0
    ld hl,lab1D70
    add hl,de
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    jp (hl)
data0f07 db #fd
db #34,#07,#c0,#fd,#34,#00,#c9,#fd
db #34,#04,#fd,#7e,#04,#e6,#03,#c2
db #90,#0c,#fd,#35,#03,#fd,#7e,#03
db #fe,#4b,#c2,#90,#0c,#fd,#36,#03 ;.K......
db #20,#fd,#34,#00,#c3,#90,#0c,#fd
db #cb,#09,#46,#20,#0b,#cd,#b4,#11 ;..F.....
db #38,#06,#fd,#35,#01,#fd,#35,#01
db #fd,#cb,#09,#56,#20,#39,#cd,#77 ;...V...w
db #11,#38,#08,#fd,#35,#02,#fd,#35
db #02,#18,#2c,#06,#1c,#0e,#31,#fd
db #7e,#01,#21,#44,#ab,#be,#20,#0b ;...D....
db #fd,#7e,#02,#d6,#0c,#23,#be,#2b
db #cc,#32,#13,#fd,#7e,#01,#21,#48 ;.......H
db #ab,#be,#20,#0b,#fd,#7e,#02,#d6
db #0c,#23,#be,#2b,#cc,#32,#13,#fd
db #cb,#09,#5e,#20,#39,#cd,#8e,#11
db #38,#08,#fd,#34,#02,#fd,#34,#02
db #18,#2c,#06,#24,#0e,#35,#fd,#7e
db #01,#21,#4c,#ab,#be,#20,#0b,#fd ;..L.....
db #7e,#02,#c6,#0c,#23,#be,#2b,#cc
db #32,#13,#fd,#7e,#01,#21,#50,#ab ;......P.
db #be,#20,#0b,#fd,#7e,#02,#c6,#0c
db #23,#be,#2b,#cc,#32,#13,#fd,#cb
db #09,#46,#28,#42,#cd,#cb,#11,#38 ;.F.B....
db #08,#fd,#34,#01,#fd,#34,#01,#18
db #35,#06,#03,#79,#e6,#03,#28,#02 ;...y....
db #04,#23,#7e,#fe,#81,#20,#27,#2b
db #10,#f8,#fd,#36,#03,#48,#fd,#36 ;.....H..
db #04,#00,#fd,#7e,#00,#e6,#f8,#f6
db #05,#fd,#77,#00,#21,#15,#23,#22 ;..w.....
db #0e,#23,#11,#f0,#05,#21,#15,#20
db #cd,#3f,#1b,#c3,#90,#0c,#fd,#7e
db #06,#a7,#20,#17,#fd,#36,#03,#20
db #fd,#34,#00,#fd,#36,#04,#00,#11
db #f0,#05,#21,#33,#20,#cd,#3f,#1b
db #c3,#90,#0c
lab1023 inc (iy+4)
    ld a,(iy+9)
    cpl 
    and #4
    ld c,a
    ld a,(iy+9)
    cpl 
    rra 
    and #4
    ld b,a
    ld a,#20
    sub c
    add a,b
    ld b,a
    ld a,(iy+4)
    rra 
    rra 
    and #3
    or b
    ld (iy+3),a
    call lab0C90
    ld b,(iy+1)
    ld c,(iy+2)
    call lab0C5A
    ld de,lab0050
    ld a,b
    and #7
    jr z,lab105C
    ld de,lab0078
lab105C add hl,de
    ld a,c
    and #3
    ld b,#3
    jr z,lab1065
    inc b
lab1065 ld a,(hl)
    cp #2
    jr z,lab106E
    inc hl
    djnz lab1065
    ret 
lab106E ld a,(lab1C56)
    sub #32
    ld (lab1C56),a
    ret nc
    ld a,(iy+6)
    sub #1
    ret c
    daa
    ld (iy+6),a
    call lab1AA9
    ret 
data1085 db #cd
db #cb,#11,#38,#09,#fd,#34,#01,#fd
db #34,#01,#c3,#90,#0c,#fd,#36,#03
db #4c,#fd,#36,#04,#00,#fd,#34,#00 ;L.......
db #21,#71,#23,#22,#0e,#23,#c3,#90 ;.q......
db #0c,#fd,#34,#04,#fd,#7e,#04,#e6
db #03,#c2,#90,#0c,#fd,#34,#03,#fd
db #7e,#03,#fe,#50,#c2,#90,#0c,#fd ;...P....
db #7e,#00,#e6,#f8,#fd,#77,#00,#fd ;.....w..
db #cb,#00,#f6,#c3,#86,#0c,#fd,#34
db #04,#fd,#7e,#04,#e6,#03,#c2,#90
db #0c,#fd,#cb,#00,#5e,#20,#0f,#fd
db #34,#03,#fd,#7e,#03,#fe,#4c,#c2 ;......L.
db #90,#0c,#fd,#cb,#00,#de,#fd,#35
db #03,#fd,#7e,#03,#fe,#47,#c2,#90 ;.....G..
db #0c,#fd,#36,#03,#5e,#fd,#34,#00
db #fd,#36,#07,#e0,#c3,#90,#0c,#fd
db #34,#04,#fd,#7e,#04,#e6,#03,#c2
db #90,#0c,#fd,#7e,#03,#ee,#01,#fd
db #77,#03,#fd,#34,#07,#c2,#90,#0c ;w.......
db #fd,#7e,#00,#e6,#f8,#fd,#77,#00 ;......w.
db #dd,#cb,#00,#f6,#c3,#86,#0c,#01
db #0e,#f4,#ed,#49,#01,#00,#f6,#3e ;...I....
db #c0,#ed,#79,#ed,#49,#04,#3e,#92 ;..y.I...
db #ed,#79,#c5,#05,#3e,#49,#ed,#79 ;.y...I.y
db #06,#f4,#ed,#78,#fd,#77,#09,#c1 ;...x.w..
db #3e,#82,#ed,#79,#05,#ed,#49,#fd ;...y..I.
db #cb,#09,#66,#20,#0d,#3a,#58,#1c ;..f...X.
db #fd,#ae,#09,#ee,#10,#fd,#77,#09 ;......w.
db #18,#05,#3e,#10,#32,#58,#1c,#fd ;.....X..
db #cb,#09,#7e,#c0,#fd,#cb,#00,#ee
db #c9,#dd,#46,#01,#dd,#4e,#02,#79 ;..F..N.y
db #d6,#02,#d8,#79,#e6,#03,#c0,#cd ;...y....
db #5a,#0c,#11,#28,#00,#2b,#18,#17 ;Z.......
db #dd,#46,#01,#dd,#4e,#02,#79,#fe ;.F..N.y.
db #94,#37,#c8,#e6,#03,#c0,#cd,#5a ;.......Z
db #0c,#11,#28,#00,#23,#23,#23,#7e
db #19,#b6,#19,#b6,#17,#d8,#78,#e6 ;......x.
db #07,#c8,#19,#7e,#17,#c9,#dd,#46 ;.......F
db #01,#dd,#4e,#02,#78,#d6,#02,#d8 ;..N.x...
db #78,#e6,#07,#c0,#cd,#5a,#0c,#11 ;x....Z..
db #d8,#ff,#19,#18,#15,#dd,#46,#01 ;......F.
db #dd,#4e,#02,#78,#fe,#78,#37,#c8 ;.N.x.x..
db #e6,#07,#c0,#cd,#5a,#0c,#11,#78 ;....Z..x
db #00,#19,#7e,#23,#b6,#23,#b6,#17
db #d8,#79,#e6,#03,#c8,#23,#7e,#2b ;.y......
db #17,#c9
lab11F0 ld a,(lab122F)
    inc a
    and #3
    ld (lab122F),a
    add a,a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    ld ix,lab1230
    add ix,de
    ld b,#2
lab1207 push bc
    ld a,(ix+0)
    cp #ff
    jr z,lab1224
    call lab0C70
    ld a,(ix+3)
    inc a
    xor (ix+3)
    and #3
    xor (ix+3)
    ld (ix+3),a
    call lab0C90
lab1224 pop bc
    ld de,lab0004
    add ix,de
    djnz lab1207
    ret 
data122d db #0
lab122E db #0
lab122F db #0
lab1230 db #0
lab1231 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00
lab1250 db #0
db #68,#04,#54,#00,#68,#8c,#57,#00 ;h.T.h.W.
db #58,#14,#55,#00,#58,#7c ;X.U.X.
lab125F db #56
db #00,#48,#24,#54,#00,#48,#6c,#57 ;.H.T.HlW
db #00,#38,#34,#55,#00,#38,#5c,#56 ;...U...V
lab1270 ld a,(data122d)
    cp #8
    ret nz
    ld a,(iy+8)
    cp #1c
    ret nz
    ld a,(iy+1)
    cp #18
    ret nz
    ld a,(iy+2)
    cp #48
    ret nz
    set 6,(iy+0)
    ld d,#80
lab128E ld hl,lab1CB3
    ld bc,lab7F01
lab1294 ld a,(lab1C96)
    rla 
    jr nc,lab1294
    ld a,#6
    ld (lab1C96),a
lab129F ld a,(hl)
    add a,d
    and #1f
    or #40
    out (c),c
    out (c),a
    inc hl
    inc c
    bit 4,c
    jr z,lab129F
    dec d
    ld a,d
    cp #ff
    jr nz,lab128E
    xor a
    ld (data122d),a
    ld a,#46
    ld (lab122E),a
lab12BE ld a,(lab1C96)
    rla 
    jr nc,lab12BE
    ld a,#7
    ld (lab1C96),a
    ld a,(lab122E)
    dec a
    ld (lab122E),a
    jr nz,lab1300
    ld a,#32
    ld (lab122E),a
    ld a,(data122d)
    inc a
    ld (data122d),a
    dec a
    add a,a
    add a,a
    ld e,a
    ld d,#0
    ld ix,lab1230
    add ix,de
    call lab0C70
    ld a,(ix+3)
    and #3
    or #20
    ld (ix+3),a
    call lab0C90
    ld hl,lab2371
    ld (data230e),hl
lab1300 ld ix,labAB28
    call lab0C70
    call lab1023
    call lab11F0
    ld a,(data122d)
    cp #8
    jr nz,lab12BE
    ld hl,labBFFD+3
    ld de,lab022D
    ld bc,lab00C0
lab131D ld (hl),#0
    ld b,#80
lab1321 djnz lab1321
    add hl,de
    set 6,h
    set 7,h
    ld a,h
    xor c
    or l
    jr nz,lab131D
    set 6,(iy+0)
    ret 
data1332 db #cd
db #88,#14,#d0,#dd,#21,#ed,#1c,#d1
db #dd,#36,#00,#80,#7e,#dd,#77,#01 ;......w.
db #23,#7e,#dd,#77,#02,#23,#23,#36 ;...w....
lab134B db #0
db #2b,#dd,#71,#03,#e5,#78,#32,#57 ;..q..x.W
db #1c,#fd,#77,#03,#dd,#21,#28,#ab ;..w.....
db #cd,#90,#0c,#21,#8d,#23,#22,#10
db #23,#cd,#de,#15,#dd,#21,#ed,#1c
db #cd,#70,#0c,#dd,#35,#03,#cd,#05 ;.p......
db #16,#cd,#90,#0c,#dd,#7e,#03,#d6
db #2e,#e6,#03,#20,#e4,#cd,#de,#15
db #cd,#70,#0c,#3a,#57,#1c,#fe,#20 ;.p..W...
db #9f,#f6,#01,#87,#fd,#86,#02,#fd
db #77,#02,#cd,#90,#0c,#3a,#57,#1c ;w.....W.
db #fe,#20,#9f,#e6,#fc,#f6,#04,#fd
db #86,#02,#47,#3a,#ef,#1c,#b8,#20 ;..G.....
db #d4,#fd,#6e,#08,#26,#00,#29,#29 ;..n.....
db #29,#29,#54,#5d,#29,#19,#11,#78 ;..T....x
db #af,#19
lab13BE db #eb
db #21,#32,#ab,#01,#30,#00,#fd,#cb
db #0c,#be,#fd,#cb,#14,#be,#ed,#b0
db #e1,#7e,#f5,#e6,#3f,#cd,#53,#0b ;......S.
db #f1,#cb,#7f,#20,#21,#21,#44,#ab ;......D.
db #cb,#77,#28,#03,#21,#48,#ab,#7e ;.w...H..
db #fd,#77,#01,#23,#7e,#c6,#04,#fd ;.w......
db #77,#02,#c6,#08,#47,#3e,#24,#32 ;w...G...
db #57,#1c,#0e,#31,#18,#1f,#21,#4c ;W......L
db #ab,#cb,#77,#28,#03,#21,#50,#ab ;..w...P.
db #7e,#fd,#77 ;..w
lab140A db #1
db #23,#7e,#d6,#04,#fd,#77,#02,#d6 ;.....w..
db #08,#47,#3e,#1c,#32,#57,#1c,#0e ;.G...W..
db #35,#dd,#21,#ed,#1c,#fd,#cb,#00
db #be,#fd,#70,#07,#dd,#36,#00,#80 ;..p.....
db #7e,#dd,#77,#02,#2b,#7e,#dd,#77 ;..w....w
db #01,#dd,#71,#03,#cd,#70,#0c,#dd ;..q..p..
db #7e,#03,#d6,#03,#dd,#77,#03,#cd ;.....w..
db #90,#0c,#cd,#de,#15,#cd,#70,#0c ;......p.
db #3a,#57,#1c,#fe,#20,#9f,#f6,#01 ;.W......
db #87,#fd,#86,#02,#fd,#77,#02,#cd ;.....w..
db #90,#0c,#fd,#7e,#02,#fd,#be,#07
db #20,#e0,#21,#ba,#23,#22,#10,#23
db #cd,#de,#15,#dd,#21,#ed,#1c,#cd
db #70,#0c,#dd,#34,#03,#cd,#05,#16 ;p.......
db #cd,#90,#0c,#dd,#7e,#03,#d6,#31
db #e6,#03,#20,#e4,#c9,#23,#23,#23
db #7e,#2b,#2b,#2b,#d6,#01,#d8,#e5
db #5f,#16,#00,#21,#8f,#1d,#19,#19
db #5e,#23,#56,#eb,#e3,#c9 ;..V...
lab14A1 ld a,(iy+44)
    cp #ff
    ret z
    bit 6,(iy+0)
    ret nz
    sub #10
    cp (iy+1)
    jr nz,lab14D5
    ld a,(iy+45)
    sub (iy+2)
    add a,#4
    cp #9
    jr nc,lab14D5
    ld a,(iy+6)
    cp #99
    jr z,lab14D5
    add a,#1
    daa
    ld (iy+6),a
    call lab1AA9
    ld hl,lab2408
    ld (lab2310),hl
lab14D5 ld b,(iy+44)
    ld c,(iy+45)
    jr lab151E
lab14DD ld a,(iy+47)
    cp #ff
    ret z
    bit 6,(iy+0)
    ret nz
    sub #10
    cp (iy+1)
    jr nz,lab1518
    ld a,(iy+48)
    sub (iy+2)
    add a,#4
    cp #9
    jr nc,lab1518
    ld b,(iy+49)
lab14FE ld a,(iy+6)
    and a
    jr z,lab1518
    sub #1
    daa
    ld (iy+6),a
    call lab1AA9
    ld hl,lab2408
    ld (lab2310),hl
    call lab1605
    djnz lab14FE
lab1518 ld b,(iy+47)
    ld c,(iy+48)
lab151E ld a,(lab1C5A)
    cp #4
    ret nz
    call CALC_POS
    ld de,lab1D4E
    ld c,#4
lab152C ld b,#5
lab152E ld a,(de)
lab152F xor (hl)
    ld (hl),a
    inc hl
    inc de
    djnz lab152E
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ld a,h
    add a,#8
    ld h,a
    dec c
    jr nz,lab152C
    ret 
lab1542 ld a,(iy+53)
    cp #ff
    ret z
    sub #8
    cp (iy+1)
    ret nz
    ld a,(iy+54)
    cp (iy+2)
    ret nz
    ld a,(iy+55)
    cp (iy+5)
    ret nz
    ld (iy+5),#0
    ld ix,lab1CED
    ld (ix+0),#80
    ld a,(iy+53)
    ld (ix+1),a
    ld a,(iy+54)
    ld (ix+2),a
    ld (ix+3),#42
    call lab0C70
    call lab0C86
    ld (iy+53),#ff
    jr lab15C6
lab1584 ld a,(iy+50)
    cp #ff
    ret z
    cp (iy+1)
    ret nz
    ld a,(iy+51)
    sub (iy+2)
    add a,#8
    and #ef
    ret nz
    ld a,(iy+52)
    cp (iy+5)
    ret nz
    ld (iy+5),#0
    ld ix,lab1CED
    ld (ix+0),#80
    ld a,(iy+50)
    ld (ix+1),a
    ld a,(iy+51)
    ld (ix+2),a
    ld (ix+3),#43
    call lab0C70
    call lab0C86
    ld (iy+50),#ff
lab15C6 ld b,(ix+1)
    ld c,(ix+2)
    call lab0C5A
    ld de,lab0026
    ld bc,lab0300
lab15D5 ld (hl),c
    inc hl
    ld (hl),c
    inc hl
    ld (hl),c
    add hl,de
    djnz lab15D5
    ret 
data15de db #dd
db #21,#28,#ab,#cd,#70,#0c,#3a,#57 ;....p..W
db #1c,#47,#fd,#7e,#04,#1f,#1f,#e6 ;.G......
db #03,#b0,#fd,#77,#03,#fd,#34,#04 ;...w....
db #cd,#05,#16,#cd,#90,#0c,#fd,#7e
db #04,#e6,#03,#20,#da,#c9
lab1605 push bc
    ld b,#f5
lab1608 in a,(c)
    rra 
    jr nc,lab1608
    pop bc
    ret 
data160f db #fd
db #7e,#00,#e6,#07,#fe,#02,#c2,#90
db #0c,#0e,#2d,#cd,#b9,#18,#0e,#4b ;.......K
db #cd,#b3,#1a,#fd,#7e,#02,#dd,#be
db #02,#30,#08,#cd,#77,#11,#38,#03 ;....w...
db #dd,#35,#02,#dd,#7e,#02,#fd,#be
db #02,#30,#08,#cd,#8e,#11,#38,#03
db #dd,#34,#02,#fd,#7e,#01,#dd,#be
db #01,#30,#08,#cd,#b4,#11,#38,#03
db #dd,#35,#01,#dd,#7e,#01,#fd,#be
db #01,#30,#08,#cd,#cb,#11,#38,#03
db #dd,#34,#01,#dd,#34,#04,#dd,#7e
db #04,#1f,#1f,#dd,#ae,#03,#e6,#03
db #dd,#ae,#03,#dd,#77,#03,#cd,#90 ;....w...
db #0c,#c9,#fd,#7e,#00,#e6,#07,#fe
db #02,#c2,#90,#0c,#0e,#41,#cd,#b9 ;.....A..
db #18,#0e,#3c,#cd,#b3,#1a,#dd,#34
db #04,#fd,#7e,#02,#dd,#be,#02,#30
db #26,#dd,#7e,#04,#e6,#03,#20,#0e
db #dd,#35,#03,#dd,#7e,#03,#fe,#10
db #30,#04,#dd,#36,#03,#13,#dd,#7e
db #03,#fe,#15,#30,#2e,#cd,#77,#11 ;......w.
db #38,#29,#dd,#35,#02,#18,#24,#dd
db #7e,#04,#e6,#03,#20,#0e,#dd,#34
db #03,#dd,#7e,#03,#fe,#1c,#38,#04
db #dd,#36,#03,#18,#dd,#7e,#03,#fe
db #17,#38,#08,#cd,#8e,#11,#38,#03
db #dd,#34,#02,#cd,#90,#0c,#c9,#fd
db #7e,#00,#e6,#07,#fe,#02,#c2,#90
db #0c,#0e,#2c,#cd,#b9,#18,#0e,#32
db #cd,#b3,#1a,#dd,#46,#06,#dd,#4e ;....F..N
db #01,#dd,#56,#02,#dd,#5e,#03,#dd ;..V.....
db #66,#04,#24,#cb,#48,#28,#17,#cb ;f...H...
db #44,#c2,#75,#17,#78,#1f,#9f,#f6 ;D.u.x...
db #01,#83,#5f,#d6,#08,#fe,#04,#da
db #75,#17,#cb,#88,#18,#4f,#7a,#fd ;u....Oz.
db #be,#02,#28,#34,#38,#19,#7b,#fe
db #08,#38,#08,#1e,#0b,#cb,#c8,#cb
db #c0,#18,#3a,#15,#15,#7c,#1f,#1f
db #e6,#03,#f6,#04,#5f,#18,#2e,#7b
db #fe,#0c,#30,#08,#1e,#08,#cb,#c8
db #cb,#80,#18,#21,#14,#14,#7c,#1f
db #1f,#e6,#03,#f6,#0c,#5f,#18,#15
db #7b,#fe,#0a,#9f,#2f,#e6,#01,#f6
db #02,#a8,#e6,#03,#a8,#47,#1f,#9f ;.....G..
db #e6,#03,#c6,#08,#5f,#fd,#7e,#01
db #91,#28,#05,#9f,#f6,#01,#81,#4f ;.......O
db #dd,#70,#06,#dd,#71,#01 ;.p..q.
lab1786 db #dd
db #72,#02,#dd,#73,#03,#dd,#74,#04 ;r..s..t.
db #cd,#90,#0c,#c9,#af,#c9
lab1795 ld l,(iy+8)
    ld h,#0
lab179A add hl,hl
    add hl,hl
    add hl,hl
    ld de,labAB68
    add hl,de
    ld b,#2
lab17A3 push hl
    push bc
    ld de,lab1CEE
    ld bc,lab0003
    ldir
    ld ix,lab1CED
    ld (ix+0),#0
lab17B5 ld a,(ix+3)
    and a
    call nz,lab0C7C
    pop bc
    pop hl
    inc hl
    inc hl
    inc hl
    inc hl
    djnz lab17A3
    ret 
lab17C5 bit 4,(iy+9)
    ret nz
    bit 6,(iy+0)
    ret nz
    ld l,(iy+8)
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,labAB68
    add hl,de
    ld b,#2
lab17DD inc hl
    inc hl
    ld a,(hl)
    and a
    dec hl
    dec hl
    jr z,lab183C
    ld a,(iy+1)
    sub (hl)
    add a,#12
    cp #25
    jr nc,lab183C
    inc hl
    ld a,(iy+2)
    sub (hl)
    dec hl
    add a,#9
    cp #13
    jr nc,lab183C
    ld de,lab1CEE
    ld bc,lab0003
    ldir
    push hl
    ld a,(hl)
    ld (hl),#ff
    ld bc,lab0250
    and a
    call z,lab1B8C
    pop hl
    dec hl
    ld a,(iy+5)
    ld (hl),a
    ld ix,lab1CED
    ld (ix+0),#80
    call lab0C70
    xor a
    ld (lab1C58),a
    ld hl,lab23E7
    ld (lab2310),hl
    ld c,(ix+3)
    ld a,(iy+5)
    ld (iy+5),c
    ld (ix+3),a
    and a
    jp z,lab0C86
    jp lab0C90
lab183C inc hl
    inc hl
    inc hl
    inc hl
    djnz lab17DD
    ld a,(iy+5)
    cp #37
    jr nz,lab186D
    ld (iy+5),#0
    ld hl,lab1D07
    ld a,(iy+1)
    add a,#9
    ld d,a
    ld a,(iy+2)
    add a,#4
    ld e,a
    ld b,#8
lab185E ld (hl),d
    inc hl
    ld (hl),e
    inc hl
    inc hl
    inc hl
    djnz lab185E
    ld hl,lab2346
    ld (data230e),hl
    ret 
lab186D cp #46
    ret nz
    ld (iy+5),#0
    ld a,(iy+1)
    add a,#9
    ld (lab1D07),a
    ld (lab1D0F),a
    ld (lab1D17),a
    ld (lab1D1F),a
    ld a,(iy+2)
    add a,#4
    ld (lab1D08),a
    ld (lab1D10),a
    ld (lab1D18),a
    ld (lab1D20),a
    ld hl,lab2346
    ld (data230e),hl
    ret 
data189d db #dd
db #34,#04,#dd,#7e,#04,#e6,#03,#c0
db #dd,#34,#03,#dd,#7e,#03,#fe,#50 ;.......P
db #c2,#90,#0c,#cd,#86,#0c,#dd,#36
db #00,#00,#c9,#fd,#cb,#09,#66,#20 ;......f.
db #4a,#fd,#7e,#01,#dd,#96,#01,#c6 ;J.......
db #12,#fe,#25,#30,#3e,#fd,#7e,#02
db #dd,#96,#02,#c6,#09,#fe,#13,#30
db #32,#79,#fd,#be,#05,#20,#2c,#0e ;.y......
db #10,#fd,#36,#05,#00,#e1,#dd,#7e
db #00,#e6,#f0,#f6,#04,#dd,#77,#00 ;......w.
db #af,#fd,#77,#09,#dd,#36,#03,#4c ;..w....L
db #dd,#36,#04,#00,#41,#0e,#00,#cd ;....A...
db #8c,#1b,#21,#71,#23,#22,#0e,#23 ;...q....
db #c3,#90,#0c,#21,#07,#1d,#06,#08
db #0e,#05,#dd,#56,#01,#dd,#5e,#02 ;...V....
db #7e,#fe,#ff,#28,#11,#92,#c6,#12
db #fe,#25,#30,#0a,#23,#7e,#2b,#93
db #c6,#09,#fe,#13,#38,#b7,#23,#23
db #23,#23,#10,#e4,#c9
lab1933 ld a,(lab1C5A)
    sub #1
    ld (lab1C5A),a
    ret nc
    ld a,#4
    ld (lab1C5A),a
    ld a,(lab1C59)
    add a,#20
    and #60
    ld (lab1C59),a
    ret 
lab194C ld a,(lab1C5A)
    cp #4
    ret nz
    ld a,(lab1C59)
    ld e,a
    ld d,#0
    ld hl,lab66E0
    add hl,de
    ld (lab1C5B),hl
    ld a,#81
    ld (lab1C5D),a
    jr lab199C
lab1966 ld a,(lab1C5A)
    cp #2
    ret nz
    ld a,(lab1C59)
    ld e,a
    ld d,#0
    ld hl,lab6960
    add hl,de
    ld (lab1C5B),hl
    ld a,#1
    ld (lab1C5D),a
    jr lab199C
lab1980 ld a,(lab1C5A)
    cp #3
    ret nz
    ld a,(lab1C59)
    and #20
    ld e,a
    ld d,#0
    ld hl,lab6BE0
    add hl,de
    ld (lab1C5B),hl
    ld a,#2
    ld (lab1C5D),a
    jr lab199C
lab199C ld hl,labACA8
    ld bc,lab02D0
lab19A2 ld a,(lab1C5D)
    cpir 
    ret po
    push hl
    push bc
    ld bc,labACA8
    scf
    sbc hl,bc
    add hl,hl
    set 6,h
    set 7,h
    ld de,(lab1C5B)
    ld bc,lab0808
lab19BC ld a,(de)
    ld (hl),a
    inc de
    inc hl
    ld a,(de)
    ld (hl),a
    dec de
    inc hl
    set 4,e
    ld a,(de)
    ld (hl),a
    inc de
    inc hl
    ld a,(de)
    ld (hl),a
    inc de
    res 4,e
    dec hl
    dec hl
    dec hl
    ld a,h
    add a,c
    ld h,a
    djnz lab19BC
    pop bc
    pop hl
    inc hl
    dec bc
    ld a,b
    or c
    ret z
    jr lab19A2
data19e0 db #fd
db #7e,#01,#dd,#96,#01,#c6,#17,#fe
db #2e,#30,#31,#fd,#7e,#02,#dd,#96
db #02,#c6,#0b,#fe,#17,#30,#25,#dd
db #7e,#00,#e6,#f0,#f6,#06,#dd,#77 ;.......w
db #00,#21,#2d,#12,#34,#dd,#36,#03
db #50,#fd,#36,#38,#ff,#01,#00,#20 ;P.......
db #cd,#8c,#1b,#21,#46,#23,#22,#0e ;....F...
db #23,#c3,#90,#0c,#dd,#34,#04,#dd
db #7e,#04,#e6,#03,#c0,#dd,#7e,#03
db #3c,#e6,#03,#f6,#54,#dd,#77,#03 ;....T.w.
db #c3,#90,#0c,#dd,#35,#01,#dd,#35
db #01,#dd,#7e,#01,#1f,#ee,#03,#e6
db #03,#c6,#50,#dd,#77,#03,#dd,#7e ;..P.w...
db #01,#fe,#c8,#da,#90,#0c,#dd,#36
db #00,#00,#c3,#86,#0c
lab1A56 ld ix,lab1D07
    ld b,#8
lab1A5C push bc
    ld a,(ix+0)
    cp #ff
    jr z,lab1A84
    call lab1A93
    ld a,(ix+0)
    add a,(ix+2)
    cp #90
    jr nc,lab1A8D
    ld (ix+0),a
    ld a,(ix+1)
    add a,(ix+3)
    cp #a0
    jr nc,lab1A8D
    ld (ix+1),a
    call lab1A93
lab1A84 ld bc,lab0004
    add ix,bc
    pop bc
    djnz lab1A5C
    ret 
lab1A8D ld (ix+0),#ff
    jr lab1A84
lab1A93 ld b,(ix+0)
    ld c,(ix+1)
    call CALC_POS
    ld a,#cc
    xor (hl)
    ld (hl),a
    res 3,h
    set 4,h
    ld a,#cc
    xor (hl)
    ld (hl),a
    ret 
lab1AA9 ld de,lab0794
    ld hl,labAB2E
    call lab1B9F
    ret 
data1ab3 db #fd
db #7e,#01,#dd,#96,#01,#c6,#12,#fe
db #25,#d0,#fd,#7e,#02,#dd,#96,#02
db #c6,#09,#fe,#13,#d0,#21,#08,#24
db #22,#10,#23,#3a,#56,#1c,#91,#32 ;....V...
db #56,#1c,#d0,#fd,#7e,#06,#d6,#01 ;V.......
db #d8,#27,#fd,#77,#06,#c9 ;...w..
lab1AE2 ld b,(iy+10)
    inc b
    ld hl,lab1E3A
    ld de,lab05EF+1
    call lab1B38
    ld hl,lab0629+1
    jr lab1B12
lab1AF4 ld hl,lab1CF5
    ld bc,lab0013
    ld a,(iy+5)
    cpir 
    ret po
    ld a,#13
    sub c
    ld b,a
    ld hl,lab1F1B
    ld de,lab0690
    call lab1B38
    ld hl,lab06CA
    jr lab1B12
lab1B12 and a
    sbc hl,de
    ret c
    ret z
    ld b,h
    ld c,l
    ex de,hl
    set 6,h
    set 7,h
lab1B1E ld d,h
    ld e,l
    inc de
    ld (hl),#0
    push hl
    push bc
    ldir
    pop bc
    pop hl
    ld a,#8
    add a,h
    ld h,a
    and #38
    jr nz,lab1B1E
    ret 
lab1B32 ex (sp),hl
    call lab1B3F
    ex (sp),hl
    ret 
lab1B38 bit 7,(hl)
    inc hl
    jr z,lab1B38
    djnz lab1B38
lab1B3F ld a,(hl)
    and #7f
    call lab1B4B
    bit 7,(hl)
    inc hl
    jr z,lab1B3F
    ret 
lab1B4B cp #20
    jr nc,lab1B5A
    push hl
    inc a
    ld b,a
    ld hl,lab1E0D
    call lab1B38
    pop hl
    ret 
lab1B5A push af
    push bc
    push de
    push hl
    set 6,d
    set 7,d
    ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,h
    add a,#62
    ld h,a
    ld bc,lab0808
lab1B6F ld a,(hl)
    and #f0
    ld (de),a
    inc de
    ld a,(hl)
    add a,a
    add a,a
    add a,a
    add a,a
    ld (de),a
    dec de
    inc hl
    ld a,d
    add a,c
    ld d,a
    djnz lab1B6F
    pop hl
    pop de
    inc de
    inc de
    res 6,d
    res 7,d
    pop bc
    pop af
    ret 
lab1B8C ld hl,lab1C61
    ld a,(hl)
    add a,c
    daa
    ld (hl),a
    dec hl
    ld a,(hl)
    adc a,b
    daa
    ld (hl),a
    dec hl
    ld a,(hl)
    adc a,#0
    daa
    ld (hl),a
    ret 
lab1B9F ld a,#30
    rld 
    call lab1B4B
    rld 
    call lab1B4B
    rld 
    inc hl
    ret 
data1baf db #fd
db #7e,#05,#d6,#3b,#d6,#01,#c9,#fd
db #7e,#05,#d6,#2b,#d6,#01,#c9
lab1BBF ld bc,lab7F00
    ld a,#11
lab1BC4 ld d,(hl)
    out (c),c
    out (c),d
    inc hl
    inc c
    cp c
    jr nz,lab1BC4
    ret 
lab1BCF ld hl,labBFFD+3
    ld de,labBFFD+4
    ld bc,lab3FFF
    ld (hl),#0
    ldir
    ret 
lab1BDD ld de,data0000
lab1BE0 ld a,d
    call lab22F1
    inc d
    ld a,d
    cp #e
    jr nz,lab1BE0
    ld a,#7
    ld e,#3f
    call lab22F1
    ret 
data1bf2 db #fd
db #cb,#00,#76,#c0,#3a,#3a,#1c,#3d ;..v.....
db #32,#3a,#1c,#f0,#3e,#47,#32,#3a ;.....G..
db #1c,#2a,#36,#1c,#cb,#f4,#cb,#fc
db #36,#00,#23,#ed,#4b,#38,#1c,#0d ;....K...
db #20,#19,#0e,#10,#11,#f0,#07,#19
db #7c,#e6,#38,#20,#04,#11,#50,#c0 ;......P.
db #19,#10,#08,#fd,#cb,#00,#f6,#fd
db #cb,#00,#e6,#22,#36,#1c,#ed,#43 ;.......C
db #38,#1c,#c9
lab1C36 db #27
db #c6
lab1C38 db #10
db #28
lab1C3A db #0
lab1C3B db #0
lab1C3C db #16
db #04,#ff,#ff,#0d,#21,#ff,#ff,#13
db #17,#ff,#ff,#17,#1b,#ff,#ff,#13
db #1f,#ff,#ff
lab1C50 db #0
lab1C51 db #0
lab1C52 db #0
lab1C53 db #0
lab1C54 db #0
lab1C55 db #0
lab1C56 db #0
db #00
lab1C58 db #10
lab1C59 db #0
lab1C5A db #0
lab1C5B db #0
db #00
lab1C5D db #0
lab1C5E db #0
lab1C5F db #0
lab1C60 db #0
lab1C61 db #0
lab1C62 db #0
lab1C63 db #0
lab1C64 db #0
lab1C65 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#2e,#2e
db #2e,#2e
lab1C78 db #2e
lab1C79 db #23
db #21,#41,#42,#43,#44,#45,#46,#47 ;.ABCDEFG
db #48,#49,#4a,#4b,#4c,#4d,#4e,#4f ;HIJKLMNO
db #50,#51,#52,#53,#54,#55,#56,#57 ;PQRSTUVW
db #58,#59,#5a,#2e ;XYZ.
lab1C96 db #0
lab1C97 db #0
lab1C98 db #0
db #00
lab1C9A db #d0
db #1d,#d3,#1d,#e6,#1d,#e9,#1d,#ea
db #1d,#f8,#1d
lab1CA6 db #fb
db #1d,#fe,#1d,#01,#1e,#04,#1e,#09
db #1e,#0c,#1e
lab1CB2 db #54
lab1CB3 db #4a
db #4e,#4c,#53,#4b,#5f,#4f,#52,#46 ;NLSK.ORF
db #5c,#56,#43,#42,#40,#5e,#44 ;.VCB..D
lab1CC3 db #54
db #4b,#57,#40,#40,#40,#40,#40,#40 ;KW......
db #40,#40,#40,#40,#40,#40,#40,#54 ;.......T
lab1CD4 db #54
db #4a,#4e,#4c,#53,#4b,#5f,#4f,#52 ;JNLSK.OR
db #46,#5c,#56,#43,#42,#40,#5e,#54 ;F.VCB..T
lab1CE5 db #0
db #00,#00,#00,#00,#00,#00,#00
lab1CED db #0
lab1CEE db #0
db #00,#00,#00,#00,#00,#00
lab1CF5 db #0
db #28,#29,#2a,#2b,#2c,#2d,#37,#38
db #39,#3a,#3b,#40,#41,#44,#45,#46 ;....ADEF
db #47 ;G
lab1D07 db #ff
lab1D08 db #0
db #fc,#00,#ff,#00,#fc,#02
lab1D0F db #ff
lab1D10 db #0
db #00,#02,#ff,#00,#04,#02
lab1D17 db #ff
lab1D18 db #0
db #04,#00,#ff,#00,#04,#fe
lab1D1F db #ff
lab1D20 db #0
db #00,#fe,#ff,#00,#fc,#fe
lab1D27 db #ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff
lab1D33 db #0
db #00,#00,#ff,#ff,#ff,#ff,#ff,#ff
lab1D3C db #0
db #ff,#00,#00
lab1D40 db #ff
db #00,#00,#ff,#00
lab1D45 db #0
db #00,#00,#00,#00,#00,#ff,#ff,#ff
lab1D4E db #0
db #00,#10,#54,#00,#20,#40,#00,#00 ;..T.....
db #a0,#00,#00,#00,#a8,#00,#40,#00
db #a0,#00,#00
lab1D62 db #93
db #17,#0f,#16,#7a,#16,#e7,#16,#9d ;...z....
db #18,#e0,#19,#34,#1a
lab1D70 db #7
db #0f,#0f,#0f,#2f,#0f,#85,#10,#a7
db #10,#cc,#10,#05,#11,#07,#0f
lab1D80 db #0
db #00,#40,#18,#00,#4c,#1d,#20,#7c ;....L...
db #0f,#38,#74,#16,#10,#40,#af,#1b ;..t.....
db #b7,#1b
lab1D93 db #f5
db #c5,#d5,#e5,#06,#f5,#ed,#78,#1f ;......x.
db #30,#05,#3e,#03,#32,#97,#1c,#2a
db #98,#1c,#3a,#97,#1c,#4f,#06,#00 ;.....O..
db #09,#09,#4e,#23,#46,#21,#b7,#1d ;..N.F...
db #e5,#c5,#c9,#3a
lab1DB8 db #97
db #1c,#3c,#fe,#06,#38,#01,#af,#32
db #97,#1c,#3a,#96,#1c,#3d,#32,#96
db #1c,#e1,#d1,#c1,#f1,#fb,#c9,#c3
db #99,#22,#3e,#4a,#3d,#20,#fd,#01 ;...J....
db #00,#7f,#ed,#49,#0e,#44,#ed,#49 ;...I.D.I
db #0e,#8d,#ed,#49,#c9,#c3,#f2,#1b ;...I....
db #c9,#01,#00,#7f,#ed,#49,#0e,#54 ;.....I.T
db #ed,#49,#0e,#8c,#ed,#49,#c9,#c3 ;.I...I..
db #2d,#11,#c3,#36,#24,#c3,#44,#24 ;......D.
db #c3,#52,#24,#fd,#cb,#00,#c6,#c9 ;.R......
db #c3,#2d,#11,#c9
lab1E0D db #80
db #59,#4f,#55,#20,#41,#52,#45,#a0 ;YOU.ARE.
db #43,#41,#52,#52,#59,#49,#4e,#47 ;CARRYING
db #20,#41,#a0,#00,#49,#4e,#20,#54 ;.A..IN.T
db #48,#45,#a0,#00,#4e,#45,#41,#52 ;HE..NEAR
db #20,#54,#48,#45,#a0,#57,#49,#54 ;.THE.WIT
db #48,#20,#41,#a0 ;H.A.
lab1E3A db #80
db #02,#57,#4f,#4f,#44,#53,#ac,#00 ;.WOODS..
db #4f,#55,#54,#53,#49,#44,#45,#20 ;OUTSIDE.
db #54,#48,#45,#20,#43,#41,#53,#54 ;THE.CAST
db #4c,#45,#ac,#02,#43,#41,#53,#54 ;LE..CAST
db #4c,#45,#ac,#03,#43,#48,#41,#54 ;LE..CHAT
db #45,#41,#55,#ac,#02,#43,#48,#41 ;EAU..CHA
db #54,#45,#41,#55,#ac,#00,#41,#42 ;TEAU..AB
db #4f,#56,#45,#20,#54,#48,#45,#20 ;OVE.THE.
db #43,#48,#41,#54,#45,#41,#55,#ac ;CHATEAU.
db #02,#57,#41,#53,#54,#45,#4c,#41 ;.WASTELA
db #4e,#44,#53,#ac,#03,#56,#49,#4c ;NDS..VIL
db #4c,#41,#47,#45,#ac,#00,#41,#54 ;LAGE..AT
db #20,#54,#48,#45,#20,#57,#41,#54 ;.THE.WAT
db #45,#52,#46,#41,#4c,#4c,#ac,#02 ;ERFALL..
db #50,#41,#4c,#41,#43,#45,#ac,#03 ;PALACE..
db #50,#41,#4c,#41,#43,#45,#ac,#02 ;PALACE..
db #54,#55,#4e,#4e,#45,#4c,#ac,#02 ;TUNNEL..
db #44,#55,#4e,#47,#45,#4f,#4e,#53 ;DUNGEONS
db #ac,#02,#53,#54,#52,#4f,#4e,#47 ;..STRONG
db #52,#4f,#4f,#4d,#ac,#00,#41,#54 ;ROOM..AT
db #20,#53,#41,#4e,#43,#54,#55,#41 ;.SANCTUA
db #52,#59,#ac,#00,#41,#54,#20,#54 ;RY..AT.T
db #48,#45,#20,#54,#55,#4e,#4e,#45 ;HE.TUNNE
db #4c,#20,#4d,#4f,#55,#54,#48,#ac ;L.MOUTH.
db #00,#4e,#45,#41,#52,#20,#53,#54 ;.NEAR.ST
db #4f,#4e,#45,#48,#45,#4e,#47,#45 ;ONEHENGE
db #ac,#00,#41,#54,#20,#53,#54,#4f ;..AT.STO
db #4e,#45,#48,#45,#4e,#47,#45,#ac ;NEHENGE.
lab1F1B db #80
db #43,#41,#52,#52,#59,#49,#4e,#47 ;CARRYING
db #20,#4e,#4f,#54,#48,#49,#4e,#47 ;.NOTHING
db #ae,#01,#4a,#45,#57,#45,#4c,#4c ;..JEWELL
db #45,#44,#20,#43,#52,#4f,#57,#4e ;ED.CROWN
db #ae,#04,#4c,#41,#52,#47,#45,#20 ;..LARGE.
db #42,#4f,#54,#54,#4c,#45,#ae,#01 ;BOTTLE..
db #44,#4f,#4f,#52,#20,#4b,#45,#59 ;DOOR.KEY
db #ae,#04,#46,#4c,#45,#55,#52,#20 ;..FLEUR.
db #44,#45,#20,#4c,#59,#53,#ae,#01 ;DE.LYS..
db #53,#48,#41,#52,#50,#20,#41,#58 ;SHARP.AX
db #45,#ae,#04,#42,#41,#4c,#4c,#20 ;E..BALL.
db #26,#20,#43,#48,#41,#49,#4e,#ae ;..CHAIN.
db #01,#53,#48,#4f,#4f,#54,#49,#4e ;.SHOOTIN
db #47,#20,#53,#54,#41,#52,#ae,#04 ;G.STAR..
db #53,#43,#52,#4f,#4c,#4c,#ae,#01 ;SCROLL..
db #47,#4f,#4c,#44,#45,#4e,#20,#43 ;GOLDEN.C
db #48,#41,#4c,#49,#43,#45,#ae,#04 ;HALICE..
db #4c,#49,#54,#54,#4c,#45,#20,#4c ;LITTLE.L
db #59,#52,#45,#ae,#01,#43,#4f,#41 ;YRE..COA
db #54,#20,#4f,#46,#20,#41,#52,#4d ;T.OF.ARM
db #53,#ae,#04,#47,#4f,#42,#4c,#45 ;S..GOBLE
db #54,#20,#4f,#46,#20,#57,#49,#4e ;T.OF.WIN
db #45,#ae,#01,#53,#54,#52,#4f,#4e ;E..STRON
db #47,#20,#53,#57,#4f,#52,#44,#ae ;G.SWORD.
db #04,#53,#50,#45,#4c,#4c,#20,#42 ;.SPELL.B
db #4f,#4f,#4b,#ae,#01,#4d,#41,#47 ;OOK..MAG
db #49,#43,#20,#57,#41,#4e,#44,#ae ;IC.WAND.
db #04,#53,#41,#43,#4b,#20,#4f,#46 ;.SACK.OF
db #20,#53,#50,#45,#4c,#4c,#53,#ae ;.SPELLS.
db #01,#53,#4f,#52,#43,#45,#52,#45 ;.SORCERE
db #52,#27,#53,#20,#4d,#4f,#4f,#4e ;R.S.MOON
db #ae,#59,#4f,#55,#20,#48,#41,#56 ;.YOU.HAV
db #45,#20,#44,#52,#4f,#57,#4e,#45 ;E.DROWNE
db #44,#20,#49,#4e,#20,#54,#48,#45 ;D.IN.THE
db #20,#52,#49,#56,#45,#52,#ac,#59 ;.RIVER.Y
db #4f,#55,#20,#48,#41,#56,#45,#20 ;OU.HAVE.
db #52,#55,#4e,#20,#4f,#55,#54,#20 ;RUN.OUT.
db #4f,#46,#20,#45,#4e,#45,#52,#47 ;OF.ENERG
db #59,#2c,#20,#20,#a0 ;Y....
lab2051 db #59
db #4f,#55,#52,#20,#4c,#55,#43,#4b ;OUR.LUCK
db #20,#41,#4e,#44,#20,#54,#49,#4d ;.AND.TIM
db #45,#20,#52,#41,#4e,#20,#4f,#55 ;E.RAN.OU
db #54,#2c,#20,#20,#a0 ;T....
lab206F db #20
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#53 ;.......S
db #4f,#52,#43,#45,#52,#59,#20,#20 ;ORCERY..
db #20,#20,#20,#43,#4f,#50,#59,#52 ;...COPYR
db #49,#47,#48,#54,#20,#31,#39,#38 ;IGHT....
db #35,#20,#56,#49,#52,#47,#49,#4e ;..VIRGIN
db #20,#47,#41,#4d,#45,#53,#20,#4c ;.GAMES.L
db #54,#44,#2e,#20,#20,#20,#20,#20 ;TD......
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#50 ;.......P
db #52,#4f,#47,#52,#41,#4d,#4d,#45 ;ROGRAMME
db #44,#20,#42,#59,#20,#54,#48,#45 ;D.BY.THE
db #20,#47,#41,#4e,#47,#20,#4f,#46 ;.GANG.OF
db #20,#46,#49,#56,#45,#2e,#20,#20 ;.FIVE...
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#43 ;.......C
db #41,#4e,#20,#59,#4f,#55,#20,#52 ;AN.YOU.R
db #45,#53,#43,#55,#45,#20,#41,#4c ;ESCUE.AL
db #4c,#20,#4f,#46,#20,#59,#4f,#55 ;L.OF.YOU
db #52,#20,#46,#45,#4c,#4c,#4f,#57 ;R.FELLOW
db #20,#53,#4f,#52,#43,#45,#52,#45 ;.SORCERE
db #52,#53,#20,#46,#52,#4f,#4d,#20 ;RS.FROM.
db #43,#45,#52,#54,#41,#49,#4e,#20 ;CERTAIN.
db #44,#4f,#4f,#4d,#20,#41,#54,#20 ;DOOM.AT.
db #54,#48,#45,#20,#48,#41,#4e,#44 ;THE.HAND
db #53,#20,#4f,#46,#20,#54,#48,#45 ;S.OF.THE
db #20,#45,#56,#49,#4c,#20,#46,#4f ;.EVIL.FO
db #52,#43,#45,#53,#20,#3f,#20,#20 ;RCES....
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#50 ;.......P
db #52,#45,#53,#53,#20,#54,#48,#45 ;RESS.THE
db #20,#46,#49,#52,#45,#20,#42,#55 ;.FIRE.BU
db #54,#54,#4f,#4e,#20,#54,#4f,#20 ;TTON.TO.
db #50,#4c,#41,#59,#2e,#20,#20,#20 ;PLAY....
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#00
lab2194 db #44
db #41,#56,#45,#2e,#2e,#2e,#2e,#2e ;AVE.....
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#00,#10,#00,#41 ;.......A
db #4e,#44,#59,#2e,#2e,#2e,#2e,#2e ;NDY.....
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#00,#09,#00,#49 ;.......I
db #41,#4e,#2e,#2e,#2e,#2e,#2e,#2e ;AN......
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#00,#08,#00,#53 ;.......S
db #54,#45,#56,#45,#2e,#2e,#2e,#2e ;TEVE....
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#00,#07
lab21F3 db #0
db #54,#52,#49,#43,#49,#41,#2e,#2e ;TRICIA..
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#2e,#00,#06
lab220B db #0
lab220C db #43
db #4f,#4e,#47,#52,#41,#54,#55,#4c ;ONGRATUL
db #41,#54,#49,#4f,#4e,#53,#21,#20 ;ATIONS..
db #59,#4f,#55,#20,#48,#41,#56,#45 ;YOU.HAVE
db #20,#53,#41,#56,#45,#44,#20,#46 ;.SAVED.F
db #52,#41,#4e,#4b,#ac ;RANK.
lab2232 db #42
db #49,#4c,#4c,#2c,#20,#46,#52,#45 ;ILL..FRE
db #44,#2c,#20,#53,#41,#4d,#2c,#20 ;D..SAM..
db #42,#4f,#42,#2c,#20,#4a,#49,#4d ;BOB..JIM
db #2c,#20,#4d,#49,#43,#4b,#20,#41 ;..MICK.A
db #4e,#44,#20,#4a,#4f,#45,#ae ;ND.JOE.
lab225A db #2
db #48,#42,#03,#48,#53,#42,#04,#48 ;HB.HSB.H
db #2e,#42,#2e,#06,#48,#2e,#53,#2e ;.B..H.S.
db #42,#2e,#04,#48,#55,#47,#48,#09 ;B..HUGH.
db #48,#55,#47,#48,#2e,#42,#41,#4e ;HUGH.BAN
db #44,#0b,#48,#55,#47,#48,#2e,#53 ;D.HUGH.S
db #2e,#42,#41,#4e,#44,#06,#48,#2e ;.BAND.H.
db #42,#41,#4e,#44,#08,#48,#2e,#53 ;BAND.H.S
db #2e,#42,#41,#4e,#44,#00,#3a,#13 ;.BAND...
db #23,#d6,#01,#38,#05,#32,#13,#23
db #18,#1d,#2a,#0e,#23,#7e,#fe,#ff
db #28,#15,#32,#13,#23,#23,#5e,#3e
db #06,#cd,#f1,#22,#23,#5e,#3e,#08
db #cd,#f1,#22,#23,#22,#0e,#23,#3a
db #14,#23,#d6,#01,#38,#04,#32,#14
db #23,#c9,#2a,#10,#23,#7e,#fe,#ff
db #c8,#32,#14,#23,#23,#3e,#02,#5e
db #cd,#f1,#22,#23,#3e,#03,#5e,#cd
db #f1,#22,#23,#3e,#09,#5e,#cd,#f1
db #22,#23,#22,#10,#23,#c9
lab22F1 push bc
    ld b,#f4
    out (c),a
    ld b,#f6
    ld a,#c0
    out (c),a
    xor a
    out (c),a
    ld b,#f4
    out (c),e
    ld b,#f6
    ld c,a
    or #80
    out (c),a
    out (c),c
    pop bc
    ret 
data230e db #12
db #23
lab2310 db #12
db #23
lab2312 db #ff
db #00,#00,#00,#05,#02,#00,#05,#04
db #00,#05,#06,#01,#05,#08,#01,#04
db #0a,#00,#04,#0c,#00,#04,#0e,#02
db #03,#0f,#05,#03,#0e,#06,#02,#0c
db #08,#02,#0a,#08,#01,#08,#09,#01
db #06,#09,#00,#04,#09,#00,#02,#00
db #00,#00,#ff
lab2346 db #5
db #00,#0f,#05,#03,#0e,#05,#05,#0d
db #05,#08,#0b,#04,#0c,#0a,#04,#11
db #09,#04,#18,#07,#03,#1d,#06,#03
db #1b,#05,#02,#1c,#04,#02,#1d,#03
db #02,#1e,#02,#01,#1f,#01,#00,#00
db #00,#ff
lab2371 db #1
db #14,#0a,#01,#12,#0b,#01,#0f,#0c
db #02,#0c,#0d,#02,#09,#0e,#02,#06
db #0c,#02,#04,#09,#03,#02,#05,#00
db #00,#00,#ff,#01,#00,#0d,#0f,#01
db #00,#0c,#0f,#01,#00,#0b,#0f,#01
db #00,#0a,#0f,#01,#00,#09,#0f,#01
db #00,#08,#0f,#01,#00,#07,#0f,#01
db #00,#06,#0f,#01,#00,#05,#0f,#01
db #00,#04,#0f,#00,#00,#00,#00,#ff
db #01,#00,#03,#0f,#01,#00,#04,#0f
db #01,#00,#05,#0f,#01,#00,#06,#0f
db #01,#00,#07,#0f,#01,#00,#08,#0f
db #01,#00,#09,#0f,#01,#00,#0b,#0f
db #01,#00,#0d,#0f,#01,#00,#0f,#0f
db #00,#00,#00,#00,#ff
lab23E7 db #1
db #00,#04,#0f,#01,#96,#03,#0f,#01
db #32,#03,#0f,#00,#c8,#02,#0f,#00
db #64,#02,#0f,#00,#c8,#01,#0f,#00 ;d.......
db #32,#01,#0f,#00,#00,#00,#00,#ff
lab2408 db #0
db #00,#0c,#0f,#00,#00,#00,#00,#ff
lab2411 ld hl,lab2572
    ld (lab27BB),hl
    ld hl,lab25F4
    ld (lab27BE),hl
    ld hl,lab2736
    ld (lab27C1),hl
    ld a,#1
    ld (lab27BA),a
    ld (lab27BD),a
    ld (lab27C0),a
    ld a,#7
    ld e,#38
    call lab22F1
    ret 
data2436 db #dd
db #e5,#0e,#00,#dd,#21,#ba,#27,#cd
db #60,#24,#dd,#e1,#c9,#dd,#e5,#0e
db #01,#dd,#21,#bd,#27,#cd,#60,#24
db #dd,#e1,#c9,#dd,#e5,#0e,#02,#dd
db #21,#c0,#27,#cd,#60,#24,#dd,#e1
db #c9,#dd,#35,#00,#c0,#dd,#6e,#01 ;......n.
db #dd,#66,#02,#5e,#23,#56,#23,#dd ;.f...V..
db #75,#01,#dd,#74,#02,#dd,#72,#00 ;u..t..r.
db #cb,#7b,#28,#12,#7b,#fe,#80,#20
db #09,#79,#c6,#08,#1e,#00,#cd,#f1 ;.y......
db #22,#c9,#cd,#11,#24,#c9,#41,#cb ;......A.
db #21,#21,#b2,#24,#16,#00,#19,#19
db #79,#5e,#cd,#f1,#22,#79,#3c,#23 ;y....y..
db #5e,#cd,#f1,#22,#78,#c6,#08,#21 ;....x...
db #c3,#27,#48,#06,#00,#09,#5e,#cd ;..H.....
db #f1,#22,#c9,#ee,#0e,#18,#0e,#4d ;.......M
db #0d,#8e,#0c,#da,#0b,#2f,#0b,#8f
db #0a,#f7,#09,#68,#09,#e1,#08,#61 ;...h...a
db #08,#e9,#07,#77,#07,#0c,#07,#a7 ;...w....
db #06,#47,#06,#ed,#05,#98,#05,#47 ;.G.....G
db #05,#fc,#04,#b4,#04,#70,#04,#31 ;.....p..
db #04,#f4,#03,#bc,#03,#86,#03,#53 ;.......S
db #03,#24,#03,#f6,#02,#cc,#02,#a4
db #02,#7e,#02,#5a,#02,#38,#02,#18 ;...Z....
db #02,#fa,#01,#de,#01,#c3,#01,#aa
db #01,#92,#01,#7b,#01,#66,#01,#52 ;.....f.R
db #01,#3f,#01,#2d,#01,#1c,#01,#0c
db #01,#fd,#00,#ef,#00,#e1,#00,#d5
db #00,#c9,#00,#be,#00,#b3,#00,#a9
db #00,#9f,#00,#96,#00,#8e,#00,#86
db #00,#7f,#00,#77,#00,#71,#00,#6a ;...w.q.j
db #00,#64,#00,#5f,#00,#59,#00,#54 ;.d...Y.T
db #00,#50,#00,#4b,#00,#47,#00,#43 ;.P.K.G.C
db #00,#3f,#00,#3c,#00,#38,#00,#35
db #00,#32,#00,#2f,#00,#2d,#00,#2a
db #00,#28,#00,#26,#00,#24,#00,#22
db #00,#20,#00,#1e,#00,#1c,#00,#1b
db #00,#19,#00,#18,#00,#16,#00,#15
db #00,#14,#00,#13,#00,#12,#00,#11
db #00,#10,#00
lab2572 db #2b
db #08,#2d,#08,#2f,#08,#30,#10,#33
db #08,#30,#10,#33,#08,#32,#08,#30
db #08,#2f,#08,#30,#10,#33,#08,#30
db #10,#33,#08,#32,#08,#30,#08,#2f
db #08,#30,#10,#33,#08,#30,#08,#33
db #08,#32,#08,#30,#08,#32,#08,#33
db #08,#32,#08,#35,#08,#33,#08,#32
db #10,#38,#08,#30,#10,#33,#08,#32
db #08,#35,#08,#33,#08,#32,#10,#38
db #08,#30,#10,#33,#08,#34,#08,#37
db #08,#36,#08,#34,#18,#34,#08,#36
db #08,#37,#08,#38,#08,#3b,#08,#39
db #08,#37,#18,#38,#08,#39,#08,#3a
db #08,#3b,#08,#3e,#08,#3c,#08,#3b
db #18,#3b,#08,#3c,#08,#3d,#08,#3e
db #08,#42,#08,#40,#08,#3e,#10,#ff ;.B......
db #ff
lab25F4 db #47
db #04,#3b,#04,#46,#04,#3a,#04,#45 ;...F...E
db #04,#39,#04,#50,#04,#44,#04,#4f ;...P.D.O
db #04,#43,#04,#4e,#04,#42,#04,#4d ;.C.N.B.M
db #04,#41,#04,#4c,#04,#40,#04,#4b ;.A.L...K
db #04,#3f,#04,#4d,#04,#41,#04,#4e ;...M.A.N
db #04,#42,#04,#4f,#04,#43,#04,#50 ;.B.O.C.P
db #04,#44,#04,#4f,#04,#43,#04,#4e ;.D.O.C.N
db #04,#42,#04,#4d,#04,#41,#04,#4c ;.B.M.A.L
db #04,#40,#04,#4b,#04,#3f,#04,#4d ;...K...M
db #04,#41,#04,#4e,#04,#42,#04,#4f ;.A.N.B.O
db #04,#43,#04,#50,#04,#44,#04,#4f ;.C.P.D.O
db #04,#43,#04,#50,#04,#44,#04,#51 ;.C.P.D.Q
db #04,#45,#04,#52,#04,#46,#04,#53 ;.E.R.F.S
db #04,#47,#04,#54,#04,#48,#04,#52 ;.G.T.H.R
db #04,#46,#04,#51,#04,#45,#04,#50 ;.F.Q.E.P
db #04,#44,#04,#4f,#04,#43,#04,#4e ;.D.O.C.N
db #04,#42,#04,#4d,#04,#41,#04,#4c ;.B.M.A.L
db #04,#40,#04,#4b,#04,#3f,#04,#4a ;...K...J
db #04,#3e,#04,#49,#04,#3d,#04,#48 ;...I...H
db #04,#3c,#04,#50,#04,#44,#04,#4f ;...P.D.O
db #04,#43,#04,#4e,#04,#38,#04,#4d ;.C.N...M
db #04,#41,#04,#4c,#04,#40,#04,#4b ;.A.L...K
db #04,#3f,#04,#4a,#04,#3e,#04,#49 ;...J...I
db #04,#3d,#04,#48,#04,#3c,#04,#46 ;...H...F
db #04,#3a,#04,#47,#04,#3b,#04,#48 ;...G...H
db #04,#3c,#04,#49,#04,#3d,#04,#4a ;...I...J
db #04,#3e,#04,#4b,#04,#3f,#04,#4d ;...K...M
db #04,#41,#04,#4c,#04,#40,#04,#4b ;.A.L...K
db #04,#3f,#04,#4a,#04,#3e,#04,#4b ;...J...K
db #04,#3f,#04,#4c,#04,#40,#04,#4d ;...L...M
db #04,#41,#04,#4e,#04,#42,#04,#4f ;.A.N.B.O
db #04,#43,#04,#51,#04,#45,#04,#50 ;.C.Q.E.P
db #04,#44,#04,#4f,#04,#43,#04,#4d ;.D.O.C.M
db #04,#41,#04,#4e,#04,#42,#04,#4f ;.A.N.B.O
db #04,#43,#04,#50,#04,#44,#04,#52 ;.C.P.D.R
db #04,#46,#04,#53,#04,#47,#04,#54 ;.F.S.G.T
db #04,#48,#04,#53,#04,#47,#04,#52 ;.H.S.G.R
db #04,#46,#04,#45,#04,#39,#04,#46 ;.F.E...F
db #04,#3a,#04,#48,#04,#3c,#04,#49 ;...H...I
db #04,#3d,#04,#4a,#04,#3e,#04,#ff ;...J....
db #ff
lab2736 db #2b
db #04,#2d,#08,#2f,#08,#30,#10,#33
db #08,#30,#10,#33,#08,#32,#08,#30
db #08,#2f,#08,#30,#10,#33,#08,#30
db #10,#33,#08,#32,#08,#30,#08,#2f
db #08,#30,#10,#33,#08,#30,#08,#33
db #08,#32,#08,#30,#08,#32,#08,#33
db #08,#32,#08,#35,#08,#33,#08,#32
db #10,#38,#08,#30,#10,#33,#08,#32
db #08,#35,#08,#33,#08,#32,#10,#38
db #08,#30,#10,#33,#08,#34,#08,#37
db #08,#36,#08,#34,#18,#34,#08,#36
db #08,#37,#08,#38,#08,#3b,#08,#39
db #08,#37,#18,#38,#08,#39,#08,#3a
db #08,#3b,#08,#3e,#08,#3c,#08,#3b
db #18,#3b,#08,#3c,#08,#3d,#08,#3e
db #08,#42,#08,#40,#08,#3e,#10,#80 ;.B......
db #04,#ff,#ff
lab27BA db #0
lab27BB db #0
db #00
lab27BD db #0
lab27BE db #0
db #00
lab27C0 db #0
lab27C1 db #0
db #00,#0f,#06,#0f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00
lab2810 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab2D3A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab2FAC nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab2FC0 nop
    nop
    nop
    nop
    ld (hl),b
lab2FC5 ret nz
    nop
    nop
    nop
    nop
lab2FCA jr nc,lab2FAC
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,lab2FC5
    ret p
    add a,b
    nop
    nop
    djnz lab2FCA+1
    ret p
    ret nz
    nop
    nop
    nop
    rst 56
data2fe1 db #88
db #30,#f0,#f0,#f0,#d1,#ff,#ff,#b8
db #f0,#f0,#f0,#e0,#00
lab2FEF db #ff
db #88,#70,#f0,#f0,#f0,#f0,#e0,#00 ;.p......
db #00,#f0,#f0,#f0,#f0,#f0,#50,#11 ;......P.
lab3000 db #b8
db #f0,#f4,#f0,#c0,#70,#f0,#60,#70 ;....p..p
db #f0,#60,#50,#f0,#e0,#a0,#d1,#b8 ;..P.....
db #f1,#fc,#d0,#60,#a0,#f0,#a0,#70 ;.......p
db #e0,#b0,#c0,#b0,#50,#50,#51,#b8 ;....PPQ.
db #f6,#fc,#30,#f0,#f0,#50,#c0,#70 ;.....P.p
db #d0,#f0,#e0,#c0,#00,#80,#91,#b8
db #f6,#f4,#f0,#e0,#f0,#80,#a0,#70 ;.......p
db #30,#f0,#70,#f0,#40,#10,#51,#b8 ;..p...Q.
db #f7,#f8,#e0,#a0,#70,#90,#40,#70 ;....p..p
db #f0,#c0,#10,#b0,#a0,#a0,#91,#b8
db #f0,#f0,#c0,#70,#80,#80,#a0,#70 ;...p...p
db #a0,#50,#e0,#50,#10,#50,#51,#b8 ;.P.P.PQ.
db #e0,#d0,#b0,#f0,#f0,#10,#40,#70 ;.......p
db #10,#f0,#f0,#20,#00,#80,#91,#b8
db #90,#30,#b0,#d0,#f0,#a0,#a0,#70 ;.......p
db #f0,#60,#b0,#d0,#40,#10,#51,#b8 ;......Q.
db #f0,#f0,#f0,#90,#70,#50,#40,#70 ;....pP.p
db #e0,#10,#c0,#20,#a0,#a0,#91,#b8
db #f0,#f0,#e0,#70,#a0,#a0,#a0,#70 ;...p...p
db #d0,#f0,#f0,#10,#50,#50,#51,#b8 ;....PPQ.
db #d0,#c0,#30,#f0,#f0,#10,#40,#70 ;.......p
db #30,#f0,#d0,#80,#a0,#00,#91,#b8
db #90,#70,#70,#c0,#f0,#a0,#a0,#70 ;.pp....p
db #f0,#60,#00,#50,#50,#50,#51,#b8 ;...PPPQ.
db #f0,#f0,#f0,#80,#70,#d0,#40,#70 ;....p..p
db #e0,#50,#60,#00,#20,#a0,#91,#b8 ;.P......
db #f0,#e0,#c0,#70,#a0,#a0,#a0,#70 ;...p...p
db #d0,#f0,#f0,#10,#00,#10,#51,#b8 ;......Q.
db #f0,#c0,#30,#f0,#d0,#10,#40,#70 ;.......p
db #30,#f0,#f0,#a0,#a0,#80,#91,#b8
db #90,#30,#f0,#f0,#f0,#a0,#a0,#70 ;.......p
db #f0,#b0,#50,#10,#50,#50,#51,#b8 ;..P.PPQ.
db #f0,#70,#f0,#80,#70,#50,#40,#70 ;.p..pP.p
db #f0,#20,#e0,#20,#a0,#20,#91,#b8
db #f0,#d0,#c0,#60,#80,#80,#a0,#70 ;.......p
db #a0,#f0,#d0,#40,#00,#10,#51,#b8 ;......Q.
db #d0,#c0,#70,#f0,#f0,#10,#40,#70 ;..p....p
db #10,#f0,#e0,#a0,#20,#a0,#91,#b8
db #80,#b0,#f0,#d0,#f0,#a0,#a0,#70 ;.......p
db #f0,#e0,#10,#50,#50,#50,#51,#b8 ;...PPPQ.
db #f0,#f0,#e0,#80,#70,#50,#40,#70 ;....pP.p
db #f0,#50,#a0,#20,#a0,#20,#91,#b8 ;.P......
db #f0,#f0,#c0,#70,#a0,#a0,#a0,#70 ;...p...p
db #a0,#f0,#d0,#40,#10,#10,#51,#b8 ;......Q.
db #e0,#d0,#30,#f0,#f0,#10,#40,#70 ;.......p
db #10,#f0,#e0,#a0,#80,#a0,#91,#b8
db #80,#30,#b0,#e0,#f0,#a0,#a0,#70 ;.......p
db #f0,#b0,#10,#50,#50,#50,#51,#b8 ;...PPPQ.
db #f0,#f0,#e0,#a0,#70,#50,#40,#70 ;....pP.p
db #f0,#10,#a0,#a0,#a0,#20,#91,#b8
db #f0,#f0,#e0,#70,#80,#80,#a0,#70 ;...p...p
db #20,#f0,#f0,#40,#50,#10,#51,#b8 ;....P.Q.
db #d0,#c0,#70,#70,#d0,#10,#40,#70 ;..pp...p
db #b0,#f0,#e0,#80,#80,#a0,#91,#b8
db #80,#70,#70,#f0,#e0,#a0,#a0,#70 ;.pp....p
db #f0,#f0,#90,#50,#50,#50,#51,#b8 ;...PPPQ.
db #e0,#f0,#f0,#c0,#50,#50,#40,#70 ;....PP.p
db #f0,#f0,#80,#a0,#a0,#a0,#91,#b8
db #f0,#f0,#f0,#e0,#a0,#a0,#a0,#70 ;.......p
db #f0,#f0,#50,#50,#50,#50,#51,#b8 ;..PPPPQ.
db #f0,#f0,#f0,#f0,#d0,#50,#40,#70 ;.....P.p
db #f0,#e0,#a0,#a0,#a0,#a0,#91,#b8
db #f0,#f0,#f0,#80,#20,#a0,#a0,#70 ;.......p
db #f0,#80,#10,#50,#50,#50,#51,#b8 ;...PPPQ.
db #f0,#f0,#c0,#20,#80,#50,#40,#70 ;.....P.p
db #c0,#50,#40,#60,#a0,#a0,#91,#b8 ;.P......
db #f0,#e0,#10,#50,#50,#00,#a0,#70 ;...PP..p
db #20,#a0,#a0,#80,#50,#50,#51,#cc ;....PPQ.
db #00,#11,#ff,#ff,#ff,#ff,#00,#00
db #ff,#ff,#ff,#ff,#00,#00,#33,#30
db #a0,#a0,#a0,#a0,#a0,#a0,#ff,#ff
db #50,#50,#50,#50,#50,#50,#c0 ;PPPPPP.
lab3240 db #ff
db #00,#1c,#5a,#5b,#83,#5d,#35,#5d ;..Z.....
db #5d,#5d,#34,#ad,#5d,#35,#00,#1f
db #5a,#83,#ac,#d2,#83,#5b,#5d,#5d ;Z.......
db #5d,#00,#25,#5a,#5b,#83,#33,#34 ;...Z....
db #34,#35,#aa,#82,#ab,#00,#21,#5a ;.......Z
db #5b,#d2,#83,#5b,#d2,#d3,#00,#99
db #36,#37,#00,#26,#5d,#5f,#37,#00
db #25,#5e,#5f,#5e,#37,#00,#0b,#36
db #37,#00,#17,#5e,#5e,#5f,#5f,#37
db #00,#09,#36,#5d,#5f,#37,#00,#12
db #13,#14,#00,#02,#5d,#5e,#5e,#5f
db #5e,#37,#00,#07,#36,#5d,#5e,#5f
db #5f,#37,#00,#10,#13,#15,#16,#14
db #00,#01,#87,#88,#88,#87,#87,#fc
db #00,#06,#36,#5d,#5e,#5e,#5e,#5f
db #5f,#37,#00,#0e,#11,#0f,#15,#16
db #10,#12,#60,#86,#8f,#00,#01,#90
db #00,#07,#fc,#87,#88,#88,#88,#87
db #87,#fc,#00,#10,#0b,#0c,#00,#02
db #86,#60,#00,#0b,#86,#86,#60,#60
db #60,#38,#00,#10,#01,#1b,#1b,#06
db #00,#01,#60,#86,#00,#0b,#86,#86
db #60,#60,#60,#af,#00,#0b,#01,#03
db #18,#18,#19,#19,#17,#17,#19,#18
db #02,#1c,#19,#1d,#02,#05,#03,#04
db #05,#05,#1c,#18,#18,#1d,#02,#1c
db #19,#1d,#1c,#18,#04,#05,#05,#1c
db #03,#03,#04,#03,#1d,#02,#02,#02
db #02,#1c,#1d,#02,#02,#02,#1c,#17
db #ff,#67,#00,#0a,#5a,#5b,#5c,#5e ;.g..Z...
db #5d,#5d,#5d,#d2,#83,#d3,#00,#21
db #5a,#5b,#d2,#d3,#00,#3e,#5d,#d2 ;Z.......
db #d3,#00,#1f,#32,#82,#33,#ac,#35
db #34,#00,#22,#5a,#83,#5b,#5e,#5d ;...Z....
db #5c,#00,#25,#5a,#d3,#00,#a0,#36 ;...Z....
db #00,#26,#36,#5d,#13,#14,#00,#23
db #36,#5d,#5e,#15,#16,#14,#00,#21
db #36,#5d,#5e,#5e,#0d,#0e,#10,#12
db #00,#20,#fc,#87,#88,#87,#0b,#0c
db #00,#23,#60,#86,#86,#19,#17,#18
db #06,#00,#21,#60,#86,#86,#1b,#1b
db #1b,#1b,#18,#06,#00,#1f,#60,#86
db #86,#17,#19,#17,#19,#17,#19,#18
db #03,#03,#04,#05,#1c,#03,#05,#1c
db #03,#18,#03,#04,#05,#02,#02,#1c
db #18,#03,#03,#04,#05,#06,#01,#04
db #05,#03,#03,#04,#05,#18,#17,#17
db #19,#ff,#00,#78,#28,#29,#2a,#7c ;...x....
db #28,#29,#2c,#00,#21,#50,#51,#52 ;.....PQR
db #53,#50,#51,#52,#54,#00,#20,#78 ;SPQRT..x
db #79,#7a,#7b,#78,#79,#7a,#2c,#fb ;yz.xyz..
db #00,#1f,#28,#29,#2a,#2d,#28,#29
db #2a,#2b,#28,#2c,#00,#1e,#50,#51 ;......PQ
db #52,#55,#50,#51,#52,#53,#50,#51 ;RUPQRSPQ
db #2c,#00,#1d,#78,#79,#7a,#55,#78 ;...xyzUx
db #79,#7a,#7b,#78,#79,#54,#00,#1d ;yz.xyT..
db #28,#29,#2a,#55,#28,#29,#2a,#8f ;...U....
db #00,#01,#90,#00,#1e,#50,#51,#52 ;.....PQR
db #53,#50,#51,#52,#00,#21,#78,#79 ;SPQR..xy
db #7a,#7b,#78,#79,#7a,#00,#21,#28 ;z.xyz...
db #29,#2a,#2b,#28,#29,#2a,#2b,#28
db #29,#2a,#7c,#28,#7c,#2c,#00,#19
db #50,#51,#52,#53,#50,#51,#52,#3a ;PQRSPQR.
db #3b,#51,#52,#53,#50,#51,#52,#54 ;.QRSPQRT
db #00,#18,#78,#79,#7a,#7b,#78,#79 ;..xyz.xy
db #7a,#62,#63,#79,#7a,#7b,#78,#79 ;zbcyz.xy
db #7a,#54,#fa,#00,#17,#28,#29,#2a ;zT......
db #2b,#28,#29,#2a,#2b,#28,#a0,#a1
db #2b,#28,#29,#2a,#7c,#28,#29,#2a
db #7c,#2c,#00,#13,#50,#c8,#c9,#53 ;....P..S
db #50,#51,#52,#53,#50,#c8,#c9,#53 ;PQRSP..S
db #50,#51,#52,#53,#50,#51,#52,#53 ;PQRSPQRS
db #50,#2c,#00,#12,#04,#1c,#04,#02 ;P.......
db #02,#02,#1c,#1d,#02,#05,#1c,#1d
db #02,#05,#1d,#02,#1c,#04,#02,#02
db #1c,#1d,#05,#05,#1c,#03,#04,#02
db #1c,#04,#05,#1c,#04,#06,#01,#04
db #05,#02,#1c,#04,#ff,#00,#a0,#28
db #29,#2a,#2c,#00,#20,#39,#29,#2a
db #2b,#50,#51,#52,#53,#2c,#00,#1e ;.PQRS...
db #39,#50,#51,#52,#53,#78,#79,#7a ;.PQRSxyz
db #7b,#54,#00,#1e,#61,#78,#79,#7a ;.T..axyz
db #7b,#28,#29,#2a,#2b,#54,#00,#1e ;.....T..
db #39,#28,#29,#2d,#2b,#50,#51,#52 ;.....PQR
db #53,#2c,#00,#1e,#39,#50,#51,#55 ;S....PQU
db #53,#78,#79,#7a,#7b,#54,#00,#1d ;Sxyz.T..
db #61,#7b,#78,#79,#55,#7b,#28,#8f ;a.xyU...
db #00,#01,#90,#00,#1e,#39,#2b,#28
db #29,#2a,#2b,#50,#00,#20,#61,#52 ;...P..aR
db #53,#50,#51,#52,#53,#78,#00,#20 ;SPQRSx..
db #39,#7a,#7b,#78,#79,#7a,#7b,#28 ;.z.xyz..
db #29,#2a,#2b,#2c,#00,#1b,#61,#29 ;......a.
db #2a,#2b,#28,#29,#2a,#2b,#50,#3a ;......P.
db #3b,#53,#50,#2c,#00,#19,#fa,#39 ;.SP.....
db #51,#52,#53,#50,#51,#52,#53,#78 ;QRSPQRSx
db #62,#63,#7b,#78,#79,#7a,#7c,#2c ;bc.xyz..
db #fb,#00,#13,#fb,#39,#7b,#78,#79 ;......xy
db #7a,#7b,#78,#a0,#a1,#7b,#28,#29 ;z.x.....
db #2a,#2b,#28,#29,#2a,#2b,#28,#29
db #2a,#a0,#a1,#29,#7c,#2c,#fa,#00
db #04,#39,#c8,#c9,#7c,#29,#2a,#2b
db #28,#29,#2a,#2b,#28,#29,#2a,#2b
db #28,#c8,#c9,#2b,#19,#19,#19,#17
db #19,#1d,#1c,#17,#17,#1d,#02,#05
db #03,#17,#19,#17,#17,#19,#17,#03
db #05,#02,#02,#05,#1c,#19,#19,#04
db #05,#02,#02,#1c,#19,#19,#19,#1d
db #03,#04,#05,#1c,#ff,#00,#0c,#5a ;.......Z
db #85,#5b,#ac,#5d,#5d,#5e,#5d,#5c
db #83,#d2,#85,#d3,#5a,#83,#d3,#00 ;....Z...
db #1b,#5a,#83,#ac,#5c,#d2,#d3,#00 ;.Z......
db #24,#5a,#d3,#00,#38,#39,#28,#29 ;.Z......
db #2a,#2b,#00,#22,#39,#53,#50,#51 ;.....SPQ
db #52,#53,#78,#79,#7c,#89,#54,#00 ;RSxy..T.
db #1c,#61,#7a,#7b,#78,#79,#7a,#7b ;.az.xyz.
db #28,#29,#2a,#2c,#00,#1d,#61,#2a ;......a.
db #2b,#2d,#29,#2a,#2b,#50,#51,#52 ;.....PQR
db #53,#00,#1d,#39,#52,#53,#55,#51 ;S...RSUQ
db #52,#53,#78,#79,#7a,#54,#00,#1d ;RSxyzT..
db #61,#7a,#7b,#55,#79,#7a,#7b,#28 ;az.Uyz..
db #29,#2a,#54,#00,#1d,#39,#2a,#2b ;..T.....
db #28,#29,#2a,#2b,#50,#51,#7c,#2c ;....PQ..
db #00,#1b,#39,#7c,#89,#52,#89,#50 ;.....R.P
db #51,#52,#53,#89,#79,#7a,#54,#00 ;QRS.yzT.
db #21,#61,#7a,#7b,#28,#29,#2a,#2b ;.az.....
db #7c,#00,#20,#39,#2a,#2b,#50,#a0 ;......P.
db #a1,#53,#50,#7c,#2c,#00,#1c,#fb ;.SP.....
db #39,#51,#52,#53,#78,#c8,#c9,#7b ;.QRSx...
db #78,#79,#54,#00,#16,#39,#7c,#7b ;xyT.....
db #78,#7b,#7c,#7b,#78,#79,#7a,#7b ;x...xyz.
db #28,#c8,#a1,#2b,#28,#29,#2c,#00
db #01,#fa,#00,#13,#39,#a0,#a1,#a1
db #28,#29,#2a,#2b,#28,#29,#2a,#2b
db #50,#c8,#c9,#53,#50,#51,#52,#7c ;P..SPQR.
db #50,#2c,#00,#0a,#39,#29,#2a,#2c ;P.......
db #00,#01,#39,#7c,#53,#50,#c8,#c9 ;....SP..
db #c9,#c8,#a1,#52,#a0,#a1,#51,#52 ;...R..QR
db #53,#1c,#19,#1d,#02,#02,#1c,#19 ;S.......
db #1b,#03,#04,#05,#02,#1c,#17,#19
db #17,#04,#05,#05,#04,#17,#19,#1d
db #04,#05,#02,#02,#1c,#18,#17,#19
db #1d,#1c,#1d,#1c,#19,#17,#18,#19
db #19,#ff,#34,#ac,#5d,#35,#5c,#d2
db #83,#85,#5b,#d2,#d3,#00,#1d,#5d
db #d2,#83,#d3,#00,#24,#d3,#00,#9a
db #28,#29,#2a,#2b,#28,#14,#00,#22
db #50,#51,#52,#53,#50,#16,#14,#00 ;PQRSP...
db #21,#78,#79,#7a,#7b,#78,#0e,#10 ;.xyz.x..
db #12,#00,#20,#28,#29,#2a,#2d,#28
db #0c,#00,#22,#50,#51,#52,#55,#50 ;...PQRUP
db #1c,#17,#04,#03,#04,#05,#06,#00
db #1c,#78,#79,#7a,#55,#78,#09,#09 ;.xyzUx..
db #08,#09,#08,#08,#0a,#00,#1c,#28
db #29,#2a,#2b,#28,#00,#23,#50,#51 ;......PQ
db #52,#53,#50,#00,#23,#78,#79,#7a ;RSP..xyz
db #7b,#78,#00,#23,#28,#29,#a0,#a1 ;.x......
db #28,#00,#21,#01,#06,#50,#51,#c8 ;.....PQ.
db #c9,#50,#00,#07,#fa,#00,#06,#fb ;.P......
db #00,#02,#01,#06,#00,#0c,#01,#18
db #17,#1d,#78,#79,#c8,#c9,#78,#18 ;..xy..x.
db #1a,#1a,#1a,#18,#1a,#1a,#1a,#18
db #03,#04,#05,#02,#05,#1c,#03,#18
db #1d,#1c,#06,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#13,#1a,#1a
db #17,#1a,#03,#1d,#02,#02,#1c,#ff
db #a6,#a6,#a7,#32,#82,#ad,#33,#34
db #5d,#35,#5d,#67,#00,#0a,#5a,#5b ;...g..Z.
db #d2,#83,#d3,#00,#0d,#58,#30,#f9 ;.....X..
db #5a,#5b,#35,#5d,#5d,#5d,#5d,#5c ;Z.......
db #00,#1d,#31,#30,#57,#00,#02,#5a ;....W..Z
db #85,#5b,#5c,#5d,#ac,#00,#1d,#d6
db #30,#7f,#f9,#00,#05,#5a,#5b,#5c ;.....Z..
db #35,#34,#aa,#ab,#00,#18,#d8,#30
db #7f,#57,#00,#07,#5a,#5b,#5c,#d2 ;.W..Z...
db #d3,#00,#18,#31,#30,#7f,#7f,#f9
db #00,#23,#31,#30,#2e,#7f,#57,#00 ;......W.
db #23,#31,#30,#7f,#2e,#7f,#f9,#00
db #22,#31,#30,#2e,#2e,#2e,#57,#00 ;......W.
db #1d,#13,#14,#00,#03,#31,#30,#a6
db #a6,#a6,#a7,#00,#1c,#13,#15,#16
db #14,#00,#02,#d6,#30,#31,#58,#30 ;......X.
db #00,#1c,#11,#0f,#0d,#0e,#10,#12
db #00,#01,#d8,#30,#80,#b2,#30,#00
db #1e,#0b,#0c,#00,#03,#31,#30,#a8
db #a9,#30,#00,#0a,#fb,#00,#11,#01
db #18,#1d,#02,#1c,#18,#03,#31,#30
db #67,#00,#01,#90,#00,#07,#fa,#00 ;g.......
db #01,#01,#17,#06,#fa,#00,#0f,#07
db #09,#08,#09,#08,#08,#09,#31,#30
db #00,#0a,#fb,#01,#17,#17,#19,#17
db #18,#06,#00,#01,#fa,#00,#12,#b1
db #30,#00,#07,#01,#18,#18,#17,#17
db #1a,#1a,#1a,#1a,#1a,#19,#06,#fb
db #00,#12,#1a,#1a,#19,#17,#1a,#18
db #18,#17,#18,#17,#17,#17,#1a,#1a
db #1a,#1a,#1a,#1a,#1a,#1a,#1a,#19
db #06,#00,#11,#1a,#19,#1d,#1c,#1d
db #02,#02,#02,#1c,#1a,#1a,#1d,#02
db #1c,#1d,#1c,#1b,#19,#1d,#02,#02
db #1c,#17,#18,#1d,#02,#1c,#18,#03
db #17,#03,#04,#05,#02,#05,#1c,#03
db #1d,#1c,#17,#ff,#5d,#67,#00,#01 ;.....g..
db #68,#00,#05,#5a,#85,#83,#5b,#d2 ;h..Z....
db #83,#85,#d3,#00,#17,#5d,#00,#27
db #5d,#00,#27,#5b,#5d,#35,#aa,#ab
db #00,#23,#f9,#5a,#83,#85,#d3,#00 ;...Z....
db #23,#57,#00,#16,#f8,#f9,#00,#0f ;.W......
db #7f,#f9,#00,#15,#56,#57,#00,#0f ;....VW..
db #2e,#57,#00,#14,#f8,#7e,#7f,#f9 ;.W......
db #00,#0e,#7f,#7f,#f9,#00,#13,#56 ;.......V
db #7e,#2e,#57,#00,#0e,#7f,#2e,#57 ;..W....W
db #00,#12,#f8,#7e,#7e,#7f,#7f,#f9
db #00,#0d,#2e,#7f,#7f,#f9,#00,#11
db #56,#7e,#7e,#2e,#7f,#57,#00,#0a ;V....W..
db #32,#82,#33,#2e,#2e,#7f,#57,#00 ;......W.
db #11,#a5,#a6,#a6,#a6,#a6,#a7,#00
db #07,#32,#33,#34,#5d,#5d,#35,#a6
db #a6,#a6,#a7,#00,#12,#59,#31,#58 ;.....Y.X
db #30,#00,#08,#5a,#5b,#ac,#5e,#5c ;...Z....
db #5d,#31,#58,#30,#00,#13,#59,#31 ;..X...Y.
db #2f,#30,#00,#0a,#67,#00,#01,#68 ;....g..h
db #5d,#31,#31,#30,#00,#13,#59,#31 ;......Y.
db #31,#30,#00,#0d,#35,#d6,#31,#30
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#f9,#00,#09,#5d,#d8,#31
db #30,#2e,#2e,#2e,#2e,#2e,#7f,#7f
db #2e,#2e,#2e,#2e,#2e,#2e,#2e,#2e
db #2e,#2e,#2e,#2e,#2e,#2e,#7f,#2e
db #2e,#7f,#7f,#57,#00,#03,#32,#82 ;...W....
db #ad,#35,#34,#5d,#5e,#31,#31,#30
db #7f,#7f,#2e,#7f,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#2e,#7f,#7f
db #2e,#7f,#7f,#7f,#2e,#7f,#7f,#2e
db #7f,#7f,#7f,#f9,#00,#02,#5a,#85 ;......Z.
db #83,#5b,#5c,#5d,#5c,#ff,#00,#a0
db #f9,#00,#26,#f8,#57,#00,#26,#56 ;....W..V
db #7f,#f9,#00,#24,#f8,#7e,#7f,#57 ;.......W
db #00,#07,#f8,#f9,#00,#12,#f8,#f9
db #00,#07,#56,#7e,#7f,#7f,#f9,#00 ;..V.....
db #06,#56,#57,#00,#12,#56,#57,#00 ;.VW..VW.
db #06,#f8,#7e,#7e,#7f,#2e,#57,#00 ;......W.
db #05,#f8,#7e,#7f,#f9,#00,#10,#f8
db #7e,#7f,#f9,#00,#05,#56,#7e,#7e ;.....V..
db #7f,#2e,#7f,#f9,#00,#04,#56,#7e ;......V.
db #7f,#57,#00,#10,#56,#7e,#7f,#57 ;.W..V..W
db #00,#04,#f8,#7e,#7e,#7e,#2e,#2e
db #2e,#57,#00,#03,#f8,#7e,#7e,#7f ;.W......
db #7f,#f9,#00,#0e,#f8,#7e,#7e,#2e
db #7f,#f9,#00,#03,#56,#7e,#7e,#7e ;....V...
db #a6,#a6,#a6,#a7,#00,#03,#56,#7e ;......V.
db #7e,#2e,#7f,#57,#00,#0e,#56,#7e ;...W..V.
db #7e,#2e,#2e,#57,#00,#03,#a5,#a6 ;...W....
db #a6,#a6,#31,#58,#30,#00,#04,#a5 ;...X....
db #a6,#a6,#a6,#a6,#a7,#f8,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#00,#03,#7d
db #7d,#f9,#a5,#a6,#a6,#a6,#a6,#a7
db #00,#04,#59,#31,#31,#31,#31,#30 ;..Y.....
db #00,#05,#59,#31,#58,#30,#00,#01 ;..Y.X...
db #56,#7e,#2e,#2e,#2e,#8f,#00,#01 ;V.......
db #90,#00,#03,#2e,#2e,#57,#00,#01 ;.....W..
db #31,#31,#58,#30,#00,#05,#59,#31 ;..X...Y.
db #31,#d6,#31,#30,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#00,#06,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#59,#31,#d5,#d8,#31,#30 ;..Y.....
db #2e,#2e,#2e,#7f,#7f,#2e,#2e,#2e
db #2e,#2e,#2e,#7f,#2e,#2e,#2e,#00
db #06,#2e,#7f,#2e,#2e,#2e,#2e,#7f
db #2e,#2e,#7f,#2e,#2e,#2e,#59,#31 ;......Y.
db #d7,#31,#31,#30,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#7f,#59,#31 ;......Y.
db #31,#ff,#00,#08,#5a,#83,#85,#5b ;....Z...
db #d2,#83,#85,#85,#d3,#00,#05,#67 ;.......g
db #00,#01,#68,#5d,#35,#34,#5d,#5d ;..h.....
db #5e,#5d,#5c,#34,#d2,#85,#d3,#a5
db #a6,#a6,#00,#19,#5d,#5d,#5d,#5d
db #5d,#ac,#5c,#d2,#d3,#00,#04,#59 ;.......Y
db #31,#00,#19,#ac,#5c,#5d,#d2,#83
db #d3,#00,#06,#f8,#59,#31,#00,#15 ;....Y...
db #32,#33,#34,#35,#d2,#83,#d3,#00
db #09,#56,#59,#31,#00,#15,#5a,#83 ;.VY...Z.
db #85,#d3,#00,#0b,#f8,#7e,#59,#31 ;......Y.
db #00,#24,#56,#7e,#59,#31,#00,#23 ;..V.Y...
db #f8,#7e,#7e,#59,#31,#00,#23,#56 ;...Y...V
db #7e,#7f,#59,#31,#00,#22,#f8,#7e ;..Y.....
db #7e,#7f,#59,#31,#00,#22,#56,#7e ;..Y...V.
db #7f,#2e,#59,#31,#00,#22,#a5,#a6 ;..Y.....
db #a6,#a6,#59,#31,#00,#23,#59,#31 ;..Y...Y.
db #58,#59,#31,#00,#23,#b2,#80,#b2 ;XY......
db #59,#31,#00,#23,#b3,#a8,#a9,#59 ;Y......Y
db #31,#00,#0c,#fa,#00,#16,#67,#00 ;......g.
db #01,#68,#59,#31,#00,#0a,#fa,#00 ;.hY.....
db #01,#fb,#00,#19,#59,#31,#00,#09 ;....Y...
db #01,#17,#06,#fb,#00,#07,#fa,#00
db #11,#59,#b1,#1e,#1f,#1e,#1f,#1e ;.Y......
db #1f,#1e,#1f,#01,#17,#1d,#02,#02
db #1c,#18,#18,#03,#03,#04,#05,#02
db #05,#1c,#1b,#1d,#02,#1c,#03,#04
db #05,#02,#1c,#18,#1b,#1b,#1b,#1b
db #1b,#1b,#1d,#ff,#36,#35,#5d,#5d
db #d2,#67,#00,#08,#46,#47,#46,#47 ;.g..FGFG
db #00,#11,#5a,#5b,#5c,#83,#ac,#5a ;..Z....Z
db #83,#d2,#d3,#00,#0a,#46,#47,#46 ;.....FGF
db #47,#00,#15,#5a,#00,#0e,#46,#47 ;G..Z..FG
db #46,#47,#00,#15,#32,#00,#0e,#46 ;FG.....F
db #47,#46,#47,#00,#13,#36,#82,#35 ;GFG.....
db #00,#0e,#46,#47,#46,#47,#00,#13 ;..FGFG..
db #5a,#83,#85,#00,#0b,#01,#06,#00 ;Z.......
db #01,#46,#47,#46,#47,#00,#1d,#01 ;.FGFG...
db #18,#03,#04,#1d,#02,#06,#46,#47 ;......FG
db #46,#47,#1e,#1f,#1e,#1f,#1e,#1f ;FG......
db #13,#18,#06,#00,#14,#07,#09,#09
db #09,#08,#09,#08,#08,#09,#08,#09
db #07,#09,#46,#47,#46,#47,#08,#09 ;..FGFG..
db #0a,#00,#21,#46,#47,#46,#47,#00 ;...FGFG.
db #24,#46,#47,#46,#47,#00,#24,#46 ;.FGFG..F
db #47,#46,#47,#00,#24,#46,#47,#46 ;GFG..FGF
db #47,#00,#24,#46,#47,#46,#47,#00 ;G..FGFG.
db #24,#46,#47,#46,#47,#00,#24,#46 ;.FGFG..F
db #47,#46,#47,#00,#24,#46,#47,#46 ;GFG..FGF
db #47,#00,#24,#46,#47,#46,#47,#00 ;G..FGFG.
db #10,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#46,#47,#46 ;.....FGF
db #47,#1e,#1f,#1e,#1f,#1e,#1f,#1e ;G.......
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#ff,#00,#0e,#46,#47,#46,#47 ;....FGFG
db #00,#0b,#ca,#cb,#cc,#00,#16,#46 ;.......F
db #47,#46,#47,#00,#0b,#ca,#cb,#cc ;GFG.....
db #00,#16,#46,#47,#46,#47,#00,#0b ;..FGFG..
db #ca,#cb,#cc,#00,#16,#46,#47,#46 ;.....FGF
db #47,#00,#0b,#ca,#cb,#cc,#00,#05 ;G.......
db #32,#33,#34,#f3,#f4,#00,#0c,#46 ;.......F
db #47,#46,#47,#00,#0b,#ca,#cb,#cc ;GFG.....
db #00,#05,#5b,#83,#5b,#cb,#cc,#00
db #0c,#46,#47,#46,#47,#00,#0b,#ca ;.FGFG...
db #cb,#cc,#00,#08,#cb,#cc,#00,#0c
db #46,#47,#46,#47,#00,#0b,#ca,#cb ;FGFG....
db #cc,#00,#08,#cb,#cc,#00,#0c,#46 ;.......F
db #47,#46,#47,#00,#0a,#e1,#e2,#e2 ;GFG.....
db #e2,#fe,#00,#07,#e2,#e2,#fe,#00
db #0b,#46,#47,#46,#47,#00,#08,#32 ;.FGFG...
db #82,#35,#5d,#ac,#5d,#34,#aa,#ab
db #00,#05,#35,#5d,#34,#aa,#ab,#00
db #09,#46,#47,#46,#47,#00,#06,#32 ;.FGFG...
db #33,#5d,#5d,#5d,#5d,#5d,#5d,#5d
db #5c,#d2,#00,#05,#5c,#d2,#83,#d2
db #d3,#00,#09,#46,#47,#46,#47,#00 ;...FGFG.
db #02,#f0,#00,#03,#5a,#85,#83,#5b ;....Z...
db #5c,#5d,#5d,#5c,#d2,#d3,#00,#06
db #d3,#00,#0d,#46,#47,#46,#47,#00 ;...FGFG.
db #02,#f1,#00,#09,#5a,#d3,#00,#10 ;....Z...
db #32,#33,#35,#35,#34,#82,#46,#47 ;......FG
db #46,#47,#00,#02,#f1,#00,#1b,#5a ;FG.....Z
db #5b,#83,#5c,#35,#34,#46,#47,#46 ;.....FGF
db #47,#32,#ab,#f1,#00,#1f,#5a,#5b ;G.....Z.
db #46,#47,#46,#47,#ac,#5d,#35,#aa ;FGFG....
db #ab,#00,#1f,#46,#47,#46,#47,#5a ;...FGFGZ
db #83,#d2,#85,#d3,#00,#1f,#46,#47 ;......FG
db #46,#47,#00,#16,#35,#5d,#34,#aa ;FG......
db #ab,#00,#09,#46,#47,#46,#47,#00 ;...FGFG.
db #0e,#32,#33,#82,#35,#34,#5d,#5d
db #5d,#ff,#00,#10,#ca,#cb,#cc,#00
db #06,#32,#ab,#00,#01,#82,#ab,#00
db #1a,#ca,#cb,#cc,#00,#06,#5a,#5b ;......Z.
db #5d,#d2,#d3,#00,#1a,#ca,#cb,#cc
db #00,#15,#34,#82,#33,#aa,#ab,#00
db #0b,#ca,#cb,#cc,#00,#15,#35,#5d
db #5d,#5c,#5d,#aa,#ab,#00,#09,#ca
db #cb,#cc,#00,#15,#5c,#d2,#83,#d2
db #d3,#5a,#d3,#00,#09,#ca,#cb,#cc ;.Z......
db #00,#04,#32,#33,#5d,#5d,#5d,#5d
db #aa,#ab,#00,#19,#ca,#cb,#cc,#00
db #03,#32,#83,#5d,#d2,#d3,#00,#02
db #5a,#d3,#00,#19,#ca,#cb,#cc,#00 ;Z.......
db #01,#32,#33,#d3,#00,#1e,#32,#33
db #35,#ca,#cb,#cc,#5d,#34,#5d,#aa
db #82,#ab,#00,#1c,#5b,#d2,#83,#ca
db #cb,#cc,#ac,#5d,#35,#5e,#83,#d3
db #00,#1f,#ca,#cb,#cc,#5a,#5b,#d2 ;.....Z..
db #d3,#00,#21,#ed,#ee,#ef,#00,#14
db #f2,#00,#10,#ed,#ee,#ef,#00,#14
db #ca,#00,#01,#f0,#00,#0e,#ed,#ee
db #ef,#00,#14,#ca,#00,#01,#f1,#00
db #0e,#ca,#cb,#cc,#00,#14,#ca,#00
db #01,#f1,#00,#0e,#ca,#cb,#cc,#00
db #14,#ca,#33,#5d,#aa,#ab,#00,#0b
db #e1,#e2,#e2,#e2,#fe,#00,#12,#e1
db #e2,#5d,#5d,#5d,#5d,#82,#84,#33
db #5d,#34,#35,#82,#ab,#00,#01,#a2
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#ff,#00,#09,#5a,#5b,#d2 ;.....Z..
db #83,#85,#83,#5b,#d2,#d3,#00,#0e
db #8f,#00,#01,#90,#00,#75,#ca,#cb ;.....u..
db #cc,#00,#1a,#f2,#f3,#f4,#00,#08
db #ca,#cb,#cc,#00,#1a,#ca,#cb,#cc
db #00,#08,#ed,#cb,#cc,#00,#1a,#ca
db #cb,#cc,#00,#08,#ca,#cb,#cc,#00
db #1a,#ca,#cb,#cc,#00,#08,#ed,#ee
db #ef,#00,#18,#32,#33,#ca,#cb,#cc
db #34,#00,#03,#34,#aa,#82,#84,#ed
db #ee,#ef,#00,#18,#5a,#5b,#ca,#cb ;....Z...
db #cc,#d2,#00,#03,#5b,#5c,#5c,#5d
db #ed,#ee,#ef,#00,#1a,#ca,#cb,#cc
db #00,#06,#5a,#83,#ed,#ee,#ef,#00 ;..Z.....
db #05,#f3,#f4,#00,#13,#ca,#cb,#cc
db #00,#08,#ed,#ee,#ef,#00,#05,#cb
db #cc,#00,#13,#ca,#cb,#cc,#00,#08
db #ed,#ee,#ef,#00,#05,#cb,#cc,#00
db #13,#ca,#cb,#cc,#00,#08,#ed,#ee
db #ef,#00,#04,#68,#cb,#cc,#00,#13 ;...h....
db #ca,#cb,#cc,#00,#08,#ed,#ee,#ef
db #00,#05,#cb,#cc,#00,#13,#ca,#cb
db #cc,#00,#08,#ed,#ee,#ef,#00,#05
db #e2,#e2,#fe,#00,#11,#e1,#e2,#e2
db #e2,#fe,#00,#06,#e1,#e2,#e2,#e2
db #fe,#32,#33,#34,#35,#a3,#81,#a3
db #81,#a3,#81,#a3,#81,#a3,#81,#a3
db #81,#a3,#81,#a3,#81,#a3,#81,#a3
db #81,#a3,#81,#a3,#81,#a3,#81,#a3
db #81,#a3,#81,#a3,#81,#a3,#81,#a3
db #81,#a3,#81,#a3,#81,#ff,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#ce,#cf
db #ce,#cf,#ce,#cf,#ce,#cf,#ce,#cf
db #ce,#cf,#ce,#cf,#ce,#cf,#ce,#cf
db #ce,#cf,#ce,#cf,#ce,#cf,#ce,#cf
db #ce,#cf,#ce,#cf,#ce,#cf,#ce,#cf
db #ce,#cf,#ce,#cf,#ce,#cf
lab3FFF db #a6
db #a6,#a6,#a7,#00,#0f,#a5,#a6,#a6
db #a6,#a7,#00,#06,#a5,#a6,#a6,#a6
db #a7,#00,#05,#8f,#00,#01,#90,#00
db #11,#ca,#cb,#cc,#00,#08,#8f,#00
db #01,#90,#00,#1a,#ca,#cb,#cc,#00
db #25,#f5,#f6,#f7,#00,#11,#ca,#cb
db #cc,#00,#1c,#ca,#cb,#cc,#00,#06
db #ca,#cb,#cc,#00,#1c,#f5,#f6,#f7
db #00,#06,#ca,#cb,#cc,#00,#25,#ca
db #cb,#cc,#00,#25,#ca,#cb,#cc,#00
db #25,#ca,#cb,#cc,#00,#1c,#f2,#f3
db #f4,#00,#06,#f5,#f6,#f7,#00,#1c
db #ca,#cb,#cc,#00,#22,#32,#82,#33
db #ca,#cb,#cc,#34,#00,#03,#34,#84
db #00,#1c,#5a,#5b,#5c,#ca,#cb,#cc ;..Z.....
db #d2,#00,#03,#5a,#83,#00,#04,#84 ;...Z....
db #82,#ab,#00,#18,#ca,#cb,#cc,#00
db #06,#32,#82,#33,#35,#ac,#5d,#5d
db #34,#35,#aa,#84,#ab,#00,#13,#ca
db #cb,#cc,#00,#06,#5b,#5c,#5d,#5d
db #5d,#5d,#5d,#ac,#5d,#5c,#5d,#5d
db #34,#5d,#35,#34,#aa,#ab,#00,#0d
db #ca,#cb,#cc,#00,#06,#ff,#67,#00 ;......g.
db #06,#5a,#5b,#5c,#83,#d3,#5a,#a2 ;.Z....Z.
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#a3,#81,#a3,#81,#a3,#81
db #a3,#81,#00,#0d,#cd,#ce,#cf,#ce
db #cf,#ce,#cf,#ce,#cf,#ce,#cf,#ce
db #cf,#ce,#cf,#ce,#cf,#ce,#cf,#ce
db #cf,#ce,#cf,#ce,#cf,#ce,#cf,#00
db #0f,#a5,#a6,#a6,#a6,#a7,#00,#24
db #ca,#cb,#cc,#00,#0a,#32,#33,#aa
db #82,#ab,#00,#16,#ed,#ee,#ef,#00
db #07,#32,#33,#34,#34,#35,#5c,#5d
db #d2,#00,#16,#ed,#ee,#ef,#00,#07
db #5a,#5b,#d2,#5b,#5c,#d2,#d3,#00 ;Z.......
db #17,#ed,#ee,#ef,#00,#25,#ca,#cb
db #cc,#00,#25,#ca,#cb,#cc,#00,#25
db #ca,#cb,#cc,#00,#25,#ca,#cb,#cc
db #00,#22,#32,#33,#34,#ca,#cb,#cc
db #aa,#84,#ab,#00,#1f,#85,#83,#5b
db #ca,#cb,#cc,#5c,#d2,#d3,#00,#22
db #ca,#cb,#cc,#00,#15,#aa,#ab,#00
db #04,#f0,#00,#09,#ca,#cb,#cc,#00
db #15,#5d,#5d,#aa,#82,#ab,#00,#01
db #f1,#00,#03,#f0,#00,#05,#ca,#cb
db #cc,#00,#15,#5d,#5d,#5d,#d2,#d3
db #00,#01,#f1,#00,#01,#f0,#00,#01
db #f1,#00,#05,#ca,#cb,#cc,#00,#15
db #d2,#5b,#5c,#ab,#84,#33,#34,#5d
db #5d,#5d,#35,#82,#ab,#00,#03,#ca
db #cb,#cc,#00,#15,#ff,#46,#47,#46 ;.....FGF
db #47,#00,#24,#46,#47,#46,#47,#32 ;G..FGFG.
db #33,#00,#22,#46,#47,#46,#47,#5d ;...FGFG.
db #5d,#00,#22,#46,#47,#46,#47,#d3 ;...FGFG.
db #5a,#d3,#00,#21,#46,#47,#46,#47 ;Z...FGFG
db #00,#24,#46,#47,#46,#47,#1e,#1f ;..FGFG..
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#82,#ab,#00,#14
db #5a,#83,#5b,#5c,#83,#85,#5b,#5d ;Z.......
db #ac,#34,#5d,#5d,#5d,#5d,#46,#47 ;......FG
db #46,#47,#d2,#d3,#00,#1d,#5a,#83 ;FG....Z.
db #5b,#5c,#d2,#46,#47,#46,#47,#00 ;...FGFG.
db #24,#46,#47,#46,#47,#00,#24,#46 ;.FGFG..F
db #47,#46,#47,#00,#24,#46,#47,#46 ;GFG..FGF
db #47,#00,#08,#32,#33,#82,#ab,#00 ;G.......
db #04,#32,#ab,#00,#12,#46,#47,#46 ;.....FGF
db #47,#00,#08,#5a,#5b,#5c,#ac,#34 ;G..Z....
db #5d,#5d,#d2,#83,#d3,#00,#12,#46 ;.......F
db #47,#46,#47,#00,#0a,#a5,#a6,#a6 ;GFG.....
db #a6,#a7,#00,#15,#46,#47,#46,#47 ;....FGFG
db #00,#0b,#ca,#cb,#cc,#00,#16,#46 ;.......F
db #47,#46,#47,#00,#0b,#ca,#cb,#cc ;GFG.....
db #00,#15,#32,#46,#47,#46,#47,#aa ;...FGFG.
db #ab,#00,#09,#8f,#00,#01,#90,#00
db #15,#5a,#46,#47,#46,#47,#83,#d3 ;.ZFGFG..
db #00,#22,#46,#47,#46,#47,#00,#16 ;..FGFG..
db #ff,#8f,#00,#26,#90,#00,#50,#50 ;......PP
db #51,#52,#53,#50,#2c,#00,#1c,#39 ;QRSP....
db #81,#81,#81,#81,#81,#78,#79,#7a ;.....xyz
db #89,#78,#54,#00,#1c,#61,#cf,#cf ;.xT..a..
db #cf,#cf,#cf,#00,#11,#6e,#6f,#00 ;.....no.
db #26,#65,#66,#00,#26,#8d,#8e,#00 ;.ef.....
db #b4,#39,#00,#22,#39,#7c,#00,#03
db #89,#8f,#00,#21,#61,#2a,#00,#03 ;....a...
db #39,#00,#21,#39,#7c,#52,#00,#03 ;.....R..
db #61,#00,#21,#61,#79,#7a,#00,#03 ;a..ayz..
db #61,#28,#29,#2a,#2b,#2c,#00,#0d ;a.......
db #39,#2c,#00,#0d,#39,#29,#2a,#00
db #03,#39,#28,#52,#7c,#89,#52,#7c ;...R..R.
db #2a,#52,#89,#7c,#52,#2b,#7a,#7c ;.R..R.z.
db #7a,#7b,#2b,#28,#86,#86,#7c,#7b ;z.......
db #2b,#28,#29,#2a,#2b,#28,#78,#79 ;......xy
db #7a,#7b,#78,#29,#7c,#52,#89,#29 ;z.x..R..
db #28,#2b,#ff,#7f,#7f,#7f,#57,#00 ;......W.
db #20,#56,#7e,#7e,#7e,#a6,#a6,#a6 ;.V......
db #a7,#00,#20,#a5,#a6,#a6,#a6,#67 ;.......g
db #00,#01,#68,#00,#22,#67,#00,#01 ;..h..g..
db #68,#00,#50,#5d,#5d,#5d,#5d,#5d ;h.P.....
db #5d,#5d,#5d,#5d,#5d,#5d,#5d,#5d
db #5d,#00,#03,#5d,#5d,#5d,#5d,#5d
db #5d,#5d,#5d,#5d,#5d,#5d,#5d,#5d
db #5d,#5d,#5d,#5d,#5d,#5d,#5d,#5d
db #5d,#5d,#b0,#d9,#e6,#00,#01,#e7
db #b5,#b6,#dc,#dd,#dd,#dd,#d1,#b0
db #d9,#e6,#00,#01,#e7,#b5,#b6,#dc
db #dd,#dd,#dd,#d1,#b0,#d9,#e6,#00
db #01,#e7,#b5,#b6,#dc,#dd,#dd,#dd
db #d1,#b0,#d9,#e6,#00,#09,#a5,#a6
db #a7,#00,#09,#a5,#a6,#a7,#00,#09
db #a5,#a6,#a7,#00,#0e,#ed,#00,#0b
db #ed,#00,#0b,#ca,#00,#0f,#ed,#00
db #0b,#ed,#00,#0b,#ca,#00,#0f,#ed
db #00,#0b,#ed,#00,#0b,#ca,#00,#0f
db #ed,#00,#0b,#ed,#00,#0b,#ca,#00
db #0f,#ed,#00,#0b,#ed,#00,#0b,#ca
db #00,#0f,#ed,#00,#0b,#ed,#00,#1b
db #ed,#00,#0b,#ed,#00,#1b,#ed,#00
db #0b,#ed,#00,#03,#df,#e0,#00,#01
db #df,#e0,#00,#12,#e1,#e2,#fe,#00
db #09,#e1,#e2,#fe,#00,#02,#da,#db
db #00,#01,#da,#db,#00,#02,#e1,#e2
db #fe,#00,#05,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#ff,#00,#9c,#39,#7c
db #51,#52,#00,#24,#61,#89,#79,#7a ;QR..a.yz
db #00,#08,#6e,#6f,#00,#13,#6e,#6f ;..no..no
db #00,#11,#65,#66,#00,#13,#65,#66 ;..ef..ef
db #00,#11,#8d,#8e,#00,#13,#8d,#8e
db #00,#b3,#39,#89,#28,#7c,#89,#7c
db #2a,#54,#00,#1f,#39,#2b,#54,#00 ;.T....T.
db #1b,#90,#00,#09,#61,#53,#2c,#00 ;....aS..
db #1c,#7c,#2c,#00,#07,#39,#7b,#54 ;.......T
db #00,#1c,#7b,#2b,#2c,#00,#03,#fb
db #00,#01,#39,#7b,#2b,#2c,#fa,#00
db #02,#39,#2b,#2c,#00,#14,#39,#2a
db #7b,#53,#50,#89,#2b,#28,#28,#7c ;.SP.....
db #2a,#2b,#28,#7b,#7a,#89,#7c,#2b ;....z...
db #28,#79,#2c,#1e,#1f,#1e,#1f,#1e ;.y......
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#39,#51,#52 ;......QR
db #ff,#00,#12,#eb,#ec,#00,#26,#e9
db #ea,#00,#26,#eb,#ec,#00,#23,#df
db #e0,#00,#01,#e9,#ea,#00,#23,#da
db #db,#00,#01,#eb,#ec,#00,#22,#3f
db #3d,#3e,#3f,#3d,#3e,#3d,#3e,#3f
db #3f,#00,#17,#6e,#6f,#00,#05,#3d ;...no...
db #3e,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#01,#e8,#00,#07,#6e,#6f,#00 ;.....no.
db #08,#7c,#2c,#00,#05,#65,#66,#00 ;.....ef.
db #05,#3c,#3f,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#07,#65 ;.......e
db #66,#00,#08,#79,#7a,#2c,#00,#04 ;f..yz...
db #8d,#8e,#00,#05,#64,#3f,#e8,#00 ;....d...
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#07,#8d,#8e,#00,#08,#29,#2a
db #2b,#54,#00,#0a,#3d,#3e,#e8,#00 ;.T......
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #3c,#00,#10,#8f,#00,#01,#90,#00
db #0b,#3f,#3f,#3d,#3e,#3f,#3d,#3e
db #3d,#3e,#64,#00,#60,#28,#29,#2a ;..d.....
db #2c,#00,#23,#90,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #39,#2c,#00,#1a,#7c,#2b,#28,#29
db #2a,#7c,#46,#47,#46,#47,#46,#47 ;..FGFGFG
db #53,#54,#00,#1a,#52,#53,#50,#51 ;ST..RSPQ
db #52,#53,#46,#47,#46,#47,#46,#47 ;RSFGFGFG
db #7b,#2c,#00,#09,#39,#2c,#00,#0d
db #39,#7a,#51,#52,#78,#79,#7a,#7b ;.zQRxyz.
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #39,#86,#86,#29,#2a,#78,#79,#7a ;.....xyz
db #7b,#7c,#2b,#28,#29,#2a,#2b,#a0
db #a1,#2a,#ff,#3c,#3f,#3d,#3e,#00
db #0a,#e9,#ea,#00,#18,#64,#3f,#3c ;.....d..
db #00,#0b,#eb,#ec,#00,#18,#3d,#3e
db #64,#00,#0b,#e9,#ea,#00,#18,#3d ;d.......
db #3e,#00,#0c,#eb,#ec,#00,#18,#3f
db #3c,#00,#09,#3d,#3e,#3d,#3e,#3d
db #3e,#3d,#3e,#00,#08,#6e,#6f,#00 ;.....no.
db #0b,#3c,#64,#00,#19,#65,#66,#00 ;..d..ef.
db #0b,#64,#3f,#54,#00,#18,#8d,#8e ;.d.T....
db #00,#0b,#3d,#3e,#2c,#00,#25,#3d
db #3e,#3d,#3e,#00,#24,#8f,#00,#01
db #90,#00,#4c,#39,#00,#26,#61,#86 ;..L...a.
db #3f,#3d,#3e,#3f,#00,#03,#3d,#3e
db #00,#1c,#39,#86,#86,#3c,#3c,#00
db #05,#3d,#3e,#00,#1c,#8f,#00,#01
db #90,#64,#64,#00,#05,#3f,#3c,#00 ;.dd.....
db #1f,#3d,#3e,#00,#05,#3c,#64,#00 ;......d.
db #1f,#3d,#3e,#00,#04,#39,#64,#3f ;......d.
db #2c,#00,#0d,#fa,#00,#01,#39,#2c
db #00,#0a,#61,#2b,#28,#3d,#3e,#3f ;..a.....
db #3f,#3f,#3d,#3e,#3d,#3e,#2b,#79 ;.......y
db #7a,#7b,#2a,#28,#50,#53,#28,#2b ;z...PS..
db #28,#29,#2a,#2b,#86,#7c,#86,#86
db #2c,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#ff,#00,#4f ;.......O
db #39,#00,#26,#39,#3f,#00,#26,#3d
db #3e,#00,#23,#3c,#3c,#3d,#3e,#3f
db #00,#23,#64,#64,#64,#3d,#3e,#3c ;..ddd...
db #00,#22,#3d,#3e,#e8,#00,#01,#e8
db #64,#3c,#3d,#3e,#00,#1f,#3d,#3e ;d.......
db #e8,#00,#01,#e8,#3c,#64,#3f,#3c ;.....d..
db #2c,#00,#20,#e8,#00,#01,#e8,#64 ;.......d
db #3a,#3b,#64,#3c,#00,#20,#e8,#00 ;..d.....
db #01,#e8,#3d,#62,#63,#3e,#64,#2c ;...bc.d.
db #00,#1f,#e8,#00,#01,#e8,#3f,#3d
db #3e,#3f,#3f,#3f,#3c,#3d,#3e,#00
db #1a,#3c,#3f,#e8,#00,#01,#e8,#3d
db #3e,#3d,#3e,#3d,#3e,#64,#3d,#3e ;.....d..
db #3f,#3d,#3e,#00,#03,#3d,#3e,#3f
db #3d,#3e,#00,#0f,#64,#3c,#e8,#00 ;....d...
db #01,#e8,#3f,#3d,#3e,#00,#10,#3f
db #00,#0f,#3f,#64,#3d,#3e,#3f,#8f ;...d....
db #00,#01,#90,#00,#10,#3c,#2c,#00
db #10,#8f,#00,#01,#90,#00,#13,#64 ;.......d
db #3f,#00,#25,#3c,#3d,#3e,#3f,#2c
db #00,#11,#3d,#3e,#3d,#3e,#3f,#3d
db #3e,#3d,#3e,#3d,#3e,#3f,#3d,#3e
db #3d,#3e,#3d,#3e,#64,#3f,#3d,#3e ;....d...
db #3f,#3f,#3d,#3e,#3d,#3e,#3d,#3e
db #3d,#3e,#3d,#3e,#3d,#3e,#3d,#3e
db #3d,#3e,#ff,#00,#27,#68,#00,#75 ;.....h.u
db #5a,#5b,#5c,#00,#2d,#44,#45,#00 ;Z....DE.
db #25,#95,#94,#95,#45,#00,#0b,#13 ;....E...
db #14,#00,#16,#44,#6b,#6c,#6d,#6d ;...Dklmm
db #93,#00,#09,#13,#15,#16,#14,#00
db #17,#0b,#0c,#00,#0a,#11,#0f,#0d
db #0e,#10,#12,#00,#14,#01,#18,#17
db #17,#06,#00,#0b,#0b,#0c,#00,#15
db #01,#1d,#02,#02,#1c,#15,#18,#03
db #04,#05,#1c,#19,#17,#1d,#05,#02
db #1c,#17,#19,#06,#00,#14,#07,#0a
db #07,#09,#09,#08,#0a,#09,#08,#0a
db #07,#09,#09,#08,#0a,#09,#09,#10
db #1d,#1c,#06,#00,#11,#04,#05,#16
db #14,#00,#10,#07,#09,#0a,#00,#10
db #13,#09,#08,#09,#0a,#00,#22,#11
db #0f,#00,#4d,#01,#17,#18,#00,#14 ;..M.....
db #01,#17,#14,#00,#0a,#01,#17,#14
db #13,#1a,#1a,#1a,#18,#17,#18,#03
db #04,#05,#03,#04,#03,#04,#05,#1c
db #19,#19,#17,#18,#03,#02,#05,#03
db #1d,#1c,#1d,#06,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#13,#1d,#1c,#1d
db #02,#02,#1c,#1a,#ff,#34,#ac,#5d
db #d2,#d3,#00,#02,#5a,#85,#5b,#d2 ;....Z...
db #83,#85,#85,#d3,#00,#19,#67,#00 ;......g.
db #01,#68,#00,#75,#5c,#d2,#d3,#00 ;.h.u....
db #24,#f8,#00,#0d,#f8,#f9,#00,#18
db #56,#00,#0d,#56,#57,#00,#17,#f8 ;V..VW...
db #7e,#00,#0c,#f8,#7e,#7f,#f9,#00
db #16,#56,#7e,#00,#0c,#56,#7e,#7f ;.V...V..
db #57,#00,#15,#f8,#7e,#7e,#00,#0b ;W.......
db #f8,#7e,#7e,#2e,#7f,#f9,#00,#14
db #56,#7e,#7f,#00,#0b,#56,#7e,#2e ;V....V..
db #2e,#7f,#57,#00,#13,#f8,#7e,#7f ;..W.....
db #2e,#00,#0b,#a5,#a6,#a6,#a6,#a6
db #a7,#00,#13,#56,#7e,#7f,#2e,#ad ;...V....
db #aa,#ab,#00,#09,#59,#31,#58,#30 ;....Y.X.
db #00,#14,#a5,#a6,#a6,#a6,#67,#00 ;......g.
db #01,#68,#00,#09,#59,#31,#2f,#30 ;.h..Y...
db #00,#15,#59,#31,#31,#00,#0c,#59 ;..Y....Y
db #31,#31,#30,#00,#15,#59,#31,#31 ;.....Y..
db #00,#08,#f8,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#7d
db #7d,#7d,#7d,#7d,#7d,#7d,#7d,#59 ;.......Y
db #31,#d5,#5b,#5c,#aa,#aa,#ab,#00
db #03,#56,#7f,#7f,#7f,#7f,#7f,#7f ;.V......
db #7f,#2e,#2e,#2e,#2e,#2e,#7f,#7f
db #7f,#7f,#7f,#2e,#7f,#7f,#7f,#7f
db #7f,#7f,#7f,#7f,#7f,#2e,#59,#31 ;......Y.
db #d7,#00,#03,#5a,#d3,#00,#02,#f8 ;...Z....
db #7f,#7f,#7f,#7f,#7f,#7f,#7f,#7f
db #7f,#7f,#2e,#2e,#2e,#2e,#2e,#7f
db #7f,#2e,#7f,#7f,#7f,#7f,#7f,#2e
db #7f,#7f,#7f,#7f,#2e,#59,#31,#31 ;.....Y..
db #ff,#8f,#00,#01,#90,#00,#74,#39 ;......t.
db #3d,#7c,#3c,#3f,#8c,#41,#42,#41 ;.....ABA
db #42,#41,#42,#41,#42,#41,#42,#41 ;BABABABA
db #42,#41,#42,#41,#42,#41,#42,#41 ;BABABABA
db #42,#41,#43,#00,#03,#40,#41,#42 ;BAC...AB
db #41,#42,#b4,#3d,#3e,#7c,#3c,#3c ;AB......
db #7b,#64,#3d,#3e,#3f,#3d,#3e,#b8 ;.d......
db #ba,#b7,#ba,#b7,#ba,#b7,#ba,#b7
db #ba,#b7,#ba,#b7,#ba,#b7,#ba,#b7
db #ba,#92,#00,#03,#91,#ba,#b7,#ba
db #b7,#ba,#b7,#ba,#b9,#64,#64,#3c ;.....dd.
db #54,#00,#02,#eb,#ec,#00,#0b,#eb ;T.......
db #ec,#00,#0e,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#3e,#64,#00,#03 ;.....d..
db #e9,#ea,#00,#0b,#e9,#ea,#00,#0e
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#3d,#3e,#00,#03,#eb,#ec,#00
db #0b,#eb,#ec,#00,#0e,#e8,#00,#01
db #e8,#00,#01,#e8,#39,#3c,#54,#00 ;......T.
db #03,#e9,#ea,#00,#09,#40,#41,#42 ;......AB
db #41,#42,#43,#00,#0c,#e8,#00,#01 ;ABC.....
db #e8,#00,#01,#3c,#3f,#64,#2c,#00 ;.....d..
db #03,#eb,#ec,#00,#09,#69,#e8,#00 ;.....i..
db #01,#e8,#00,#0e,#e8,#39,#3e,#7c
db #64,#3f,#8c,#41,#42,#41,#42,#41 ;d..ABABA
db #43,#00,#09,#91,#e8,#00,#01,#e8 ;C.......
db #00,#0c,#40,#41,#42,#41,#42,#41 ;...ABABA
db #b4,#3f,#3f,#b8,#b7,#b7,#b7,#b7
db #6a,#00,#09,#69,#e8,#00,#01,#e8 ;j..i....
db #00,#0c,#69,#b7,#b7,#b7,#b7,#b9 ;..i.....
db #3f,#3c,#3c,#3f,#b8,#ba,#b7,#ba
db #92,#00,#09,#91,#ba,#b7,#ba,#b7
db #92,#00,#0a,#91,#b9,#3d,#3e,#3c
db #3d,#3e,#64,#64,#3d,#3e,#54,#00 ;..dd..T.
db #1d,#61,#3c,#3f,#64,#3f,#3d,#3e ;.a..d...
db #8f,#00,#01,#90,#00,#22,#8f,#00
db #01,#90,#00,#50,#3f,#3c,#3d,#3e ;...P....
db #3d,#3e,#3c,#3d,#3e,#3f,#3c,#3f
db #8c,#41,#42,#41,#42,#b4,#3d,#3e ;.ABAB...
db #3f,#8c,#42,#41,#42,#41,#b4,#3d ;..BABA..
db #3e,#3f,#3d,#3e,#3f,#3c,#3d,#3e
db #3c,#3d,#3e,#3f,#ff,#00,#25,#3d
db #3e,#3c,#2c,#00,#25,#61,#64,#64 ;.....add
db #00,#27,#3d,#3e,#3f,#3d,#3e,#3f
db #3d,#3e,#00,#36,#40,#41,#43,#00 ;.....AC.
db #0f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#69 ;.......i
db #b7,#6a,#00,#0f,#3c,#3d,#3e,#3c ;.j......
db #3c,#3f,#b8,#ba,#b7,#ba,#b9,#3c
db #3c,#3f,#3d,#3e,#3d,#3e,#3d,#3e
db #3f,#3d,#b8,#ba,#92,#00,#0d,#39
db #3f,#64,#3f,#3f,#64,#64,#3d,#3e ;.d..dd..
db #b8,#b7,#b9,#3f,#64,#54,#00,#01 ;....dT..
db #3d,#3e,#3f,#00,#13,#39,#3d,#3e
db #3c,#00,#0f,#3d,#3e,#00,#13,#8f
db #00,#01,#90,#64,#00,#10,#3f,#00 ;...d....
db #16,#3f,#00,#10,#3c,#00,#16,#3c
db #2c,#00,#0f,#64,#00,#03,#3d,#3e ;...d....
db #3f,#3d,#3e,#3f,#3d,#3e,#3c,#3f
db #3d,#3e,#3c,#3c,#3d,#3e,#3f,#3d
db #3e,#64,#3d,#3e,#2c,#00,#12,#3f ;.d......
db #3c,#3a,#3b,#3f,#3c,#3a,#3b,#3d
db #3e,#3a,#3b,#64,#3c,#3a,#3b,#3c ;...d....
db #3d,#3e,#3d,#3e,#3f,#3d,#2c,#00
db #10,#61,#64,#62,#8b,#3f,#64,#8a ;.adb..d.
db #63,#3d,#3e,#8a,#8b,#3e,#64,#62 ;c.....db
db #63,#64,#3f,#3f,#3c,#3d,#8f,#00 ;cd......
db #01,#90,#00,#20,#8f,#00,#01,#90
db #64,#3f,#00,#26,#3d,#3e,#00,#0d ;d.......
db #40,#41,#43,#00,#16,#3f,#3d,#3e ;.AC.....
db #3c,#3d,#3e,#3f,#8c,#41,#b4,#3f ;.....A..
db #3c,#3f,#3f,#3d,#3e,#b8,#b9,#3f
db #3c,#3d,#3e,#3d,#3e,#8c,#41,#42 ;......AB
db #41,#42,#41,#42,#41,#b4,#3d,#3e ;ABABA...
db #3f,#3d,#3e,#3f,#3f,#ff,#8f,#00
db #01,#90,#00,#21,#3f,#3f,#3d,#3e
db #00,#27,#3f,#00,#28,#28,#29,#2a
db #2b,#28,#2c,#00,#22,#50,#51,#3c ;.....PQ.
db #53,#50,#51,#2c,#00,#06,#39,#2b ;SPQ.....
db #7c,#3c,#2a,#7c,#54,#39,#3f,#7c ;....T...
db #2c,#00,#10,#3d,#3e,#64,#3f,#3d ;.....d..
db #3e,#3f,#00,#03,#3f,#3d,#3e,#3f
db #3d,#3e,#64,#3d,#3e,#3f,#3d,#3e ;..d.....
db #3f,#3f,#3d,#3e,#3c,#2c,#00,#0c
db #3c,#3f,#00,#17,#3f,#64,#3f,#1e ;.....d..
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#64,#00,#1a,#3d,#3e ;...d....
db #3f,#3d,#3e,#3d,#3e,#3f,#3d,#3e
db #3f,#3d,#3e,#00,#1f,#e8,#00,#01
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#6e,#6f,#00,#1c ;....no..
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#01,#65 ;.......e
db #66,#00,#1c,#e8,#00,#01,#e8,#00 ;f.......
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#01,#8d,#8e,#00,#1b,#3c,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#01,#e8,#3c,#00,#1d,#64 ;.......d
db #3f,#00,#01,#e8,#00,#01,#e8,#3c
db #e8,#00,#01,#e8,#64,#3f,#3d,#3e ;....d...
db #2c,#00,#19,#64,#3d,#3e,#3f,#3d ;...d....
db #3e,#64,#3d,#3e,#3f,#3d,#3e,#8f ;.d......
db #00,#01,#90,#00,#20,#8f,#00,#01
db #90,#3c,#3d,#00,#26,#64,#3f,#00 ;.....d..
db #26,#3c,#3d,#3e,#3f,#3d,#3e,#8c
db #41,#42,#41,#42,#41,#42,#41,#42 ;ABABABAB
db #41,#42,#41,#42,#41,#42,#41,#42 ;ABABABAB
db #41,#42,#41,#42,#41,#42,#41,#42 ;ABABABAB
db #41,#42,#41,#42,#41,#b4,#3d,#3e ;ABABA...
db #3f,#ff,#00,#27,#68,#00,#74,#32 ;....h.t.
db #33,#5c,#34,#00,#24,#5a,#5b,#d2 ;.....Z..
db #85,#00,#39,#a5,#a6,#a6,#a6,#a7
db #00,#24,#ca,#cb,#cc,#00,#25,#ca
db #cb,#cc,#00,#25,#ca,#cb,#cc,#00
db #1f,#a5,#a6,#a6,#a6,#a7,#00,#01
db #ca,#cb,#cc,#00,#01,#a5,#a6,#a6
db #a6,#a7,#00,#1a,#ca,#cb,#cc,#00
db #02,#ca,#cb,#cc,#00,#02,#ca,#cb
db #cc,#00,#16,#a5,#a6,#a6,#a6,#a7
db #ca,#cb,#cc,#00,#02,#ca,#cb,#cc
db #00,#02,#ca,#cb,#cc,#a5,#a6,#a6
db #a6,#a7,#00,#12,#ca,#cb,#cc,#00
db #01,#ca,#cb,#cc,#00,#02,#ca,#cb
db #cc,#00,#02,#ca,#cb,#cc,#00,#01
db #ca,#cb,#cc,#00,#0e,#a5,#a6,#a6
db #a6,#a7,#ca,#cb,#cc,#00,#01,#ca
db #cb,#cc,#00,#02,#ca,#cb,#cc,#00
db #02,#ca,#cb,#cc,#00,#01,#ca,#cb
db #cc,#a5,#a6,#a6,#a6,#a7,#00,#0a
db #ca,#cb,#cc,#00,#01,#ca,#cb,#cc
db #00,#01,#ca,#cb,#cc,#ab,#00,#01
db #ca,#cb,#cc,#00,#02,#ca,#cb,#cc
lab4D00 db #0
db #01,#ca,#cb,#cc,#00,#01,#ca,#cb
db #cc,#00,#06,#a5,#a6,#a6,#a6,#a7
db #ca,#cb,#cc,#00,#01,#ca,#cb,#cc
db #32,#ca,#cb,#cc,#ac,#ad,#ca,#cb
db #cc,#00,#02,#ca,#cb,#cc,#ab,#ca
db #cb,#cc,#00,#01,#ca,#cb,#cc,#a5
db #a6,#a6,#a6,#a7,#00,#02,#ca,#cb
db #cc,#00,#01,#ca,#cb,#cc,#32,#34
db #35,#5c,#5d,#ca,#cb,#cc,#ac,#5d
db #ca,#cb,#cc,#82,#33,#ca,#cb,#cc
db #35,#34,#5d,#ac,#ab,#ca,#cb,#cc
db #00,#01,#ca,#cb,#cc,#00,#02,#ff
db #00,#16,#44,#6b,#6d,#93,#00,#23 ;..Dkm...
db #44,#6b,#6c,#6d,#95,#93,#00,#24 ;Dklm....
db #0b,#0c,#00,#02,#fa,#00,#20,#bb
db #bd,#bf,#be,#ae,#bc,#bf,#be,#bd
db #96,#00,#1e,#07,#08,#09,#0a,#08
db #0a,#08,#09,#10,#0a,#00,#81,#13
db #00,#26,#13,#15,#00,#25,#11,#0f
db #0d,#00,#1c,#fb,#00,#0a,#0b,#00
db #13,#fa,#00,#06,#bb,#bf,#be,#bd
db #bc,#86,#ae,#be,#bd,#bf,#96,#13
db #18,#17,#00,#08,#44,#45,#00,#06 ;....DE..
db #bb,#bc,#bd,#86,#bf,#bd,#ae,#7c
db #bc,#bd,#0e,#08,#09,#0a,#08,#09
db #09,#09,#08,#09,#08,#09,#08,#09
db #00,#07,#44,#6b,#6d,#93,#00,#04 ;..Dkm...
db #39,#bc,#0a,#08,#08,#09,#09,#0a
db #09,#08,#0a,#00,#14,#44,#6b,#6c ;.....Dkl
db #6d,#45,#95,#00,#02,#bb,#be,#0a ;mE......
db #00,#1f,#0b,#0c,#00,#02,#bb,#bd
db #be,#8f,#00,#18,#ae,#60,#60,#96
db #00,#01,#bb,#bd,#86,#ae,#60,#7c
db #bf,#86,#60,#86,#00,#19,#bc,#be
db #ae,#60,#bd,#86,#60,#86,#be,#86
db #ae,#86,#86,#86,#ae,#00,#06,#39
db #bf,#bd,#bc,#bc,#be,#bf,#bd,#bd
db #bf,#bd,#96,#13,#03,#04,#05,#02
db #1c,#1d,#ff,#54,#00,#27,#54,#00 ;...T..T.
db #27,#96,#00,#27,#bc,#bf,#bd,#bf
db #bc,#be,#bd,#96,#00,#20,#08,#09
db #0a,#08,#07,#08,#09,#0a,#00,#a7
db #44,#45,#00,#25,#94,#6c,#95,#93 ;DE...l..
db #00,#23,#44,#6b,#6c,#6d,#6d,#93 ;..Dklmm.
db #00,#03,#fa,#00,#0a,#fb,#00,#02
db #bb,#bd,#bc,#bd,#00,#0f,#0b,#0c
db #00,#02,#bb,#bd,#bf,#bc,#86,#86
db #ae,#bc,#ae,#bd,#bd,#bf,#bd,#ae
db #bc,#bf,#bd,#ae,#ae,#ae,#ae,#00
db #0e,#39,#bc,#bc,#bf,#bd,#ae,#ae
db #ae,#0e,#09,#08,#09,#0a,#07,#08
db #09,#10,#09,#0a,#08,#09,#09,#0a
db #90,#ae,#ae,#00,#0c,#bb,#bd,#ae
db #0e,#0a,#09,#10,#08,#09,#0a,#00
db #10,#90,#ae,#00,#0a,#bb,#bd,#ae
db #8f,#00,#19,#90,#00,#09,#39,#86
db #86,#bc,#00,#23,#39,#60,#ae,#bc
db #ae,#00,#0b,#fb,#00,#04,#fa,#00
db #0a,#86,#be,#bc,#bd,#7c,#bf,#bd
db #7c,#bc,#be,#bc,#ae,#bc,#ae,#bc
db #ae,#bd,#bf,#bd,#bc,#bd,#be,#bf
db #bd,#bc,#bd,#bf,#bc,#ae,#ae,#bd
db #bf,#bd,#ae,#bd,#bc,#bc,#bc,#bc
db #bc,#ff,#00,#05,#44,#93,#00,#25 ;....D...
db #94,#6c,#95,#45,#00,#23,#94,#6b ;.l.E...k
db #6c,#6d,#6d,#93,#00,#24,#0b,#0c ;lmm.....
db #00,#21,#39,#bd,#bf,#bc,#bf,#bc
db #be,#bd,#bf,#96,#00,#1e,#07,#08
db #09,#0a,#07,#09,#09,#08,#09,#0a
db #00,#bf,#fb,#00,#0c,#fa,#00,#01
db #6e,#6f,#00,#05,#6e,#6f,#00,#09 ;no..no..
db #fb,#00,#05,#bd,#be,#bf,#bd,#bc
db #ae,#86,#86,#bd,#ae,#bd,#bf,#bd
db #bd,#bc,#bd,#be,#ae,#96,#00,#03
db #bb,#ae,#bc,#96,#00,#02,#bb,#bd
db #be,#bc,#ae,#bd,#60,#bf,#bd,#60
db #ae,#bd,#be,#ae,#8f,#08,#09,#08
db #09,#0a,#07,#0a,#08,#09,#08,#09
db #09,#08,#08,#09,#0a,#00,#03,#08
db #09,#be,#be,#bf,#bd,#10,#08,#0a
db #07,#08,#09,#08,#09,#0a,#90,#bc
db #60,#ae,#8f,#00,#15,#39,#ae,#07
db #08,#0a,#00,#0a,#90,#ae,#8f,#00
db #15,#61,#86,#8f,#00,#0e,#90,#00 ;.a......
db #16,#39,#ae,#00,#26,#61,#bc,#00 ;.....a..
db #09,#fa,#00,#06,#bf,#bd,#60,#bc
db #ae,#60,#bd,#96,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #1e,#1f,#bb,#60,#bf,#60,#bd,#bc
db #bd,#bf,#bd,#bc,#ae,#bc,#bf,#bd
db #bd,#ae,#be,#bc,#ff,#07,#08,#09
db #08,#0a,#e5,#07,#08,#09,#0a,#09
db #0a,#00,#21,#e5,#00,#27,#e5,#00
db #27,#e5,#00,#21,#97,#00,#03,#e4
db #00,#01,#e5,#00,#19,#97,#98,#99
db #99,#9a,#00,#03,#72,#98,#73,#99 ;....r.s.
db #73,#99,#98,#9a,#00,#18,#72,#97 ;s.....r.
db #98,#9a,#c2,#00,#04,#c0,#97,#98
db #9a,#c1,#c0,#c2,#00,#18,#97,#98
db #9a,#c2,#00,#06,#72,#c0,#c2,#00 ;....r...
db #1b,#72,#97,#98,#9a,#00,#25,#72 ;.r.....r
db #c0,#c2,#e4,#00,#24,#97,#99,#98
db #73,#99,#98,#9a,#3c,#00,#20,#72 ;s......r
db #c1,#c0,#c1,#3d,#3e,#3f,#64,#1e ;......d.
db #1f,#1e,#1f,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#39,#2c,#00,#15,#e3
db #3c,#3a,#3b,#3f,#3d,#3e,#3d,#3e
db #3d,#3e,#46,#47,#46,#47,#46,#47 ;..FGFGFG
db #3f,#54,#00,#16,#64,#62,#63,#3e ;.T..dbc.
db #3f,#00,#05,#46,#47,#46,#47,#46 ;...FGFGF
db #47,#00,#18,#3f,#64,#3d,#3e,#3c ;G...d...
db #54,#00,#04,#46,#47,#46,#47,#46 ;T..FGFGF
db #47,#00,#1b,#90,#86,#96,#00,#04 ;G.......
db #46,#47,#46,#47,#46,#47,#00,#1c ;FGFGFG..
db #ae,#bc,#bf,#bc,#bd,#96,#46,#47 ;......FG
db #46,#47,#46,#47,#00,#09,#39,#2c ;FGFG....
db #00,#11,#1e,#1f,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#1e,#1f,#1e,#1f
db #1e,#1f,#1e,#1f,#1e,#1f,#39,#2b
db #28,#29,#2a,#2b,#28,#29,#2a,#7c
db #bd,#bf,#bc,#7c,#3d,#3e,#3c,#3d
db #3e,#3f,#ff,#00,#01,#07,#0a,#09
db #08,#e5,#08,#0a,#00,#0a,#07,#08
db #0a,#e5,#07,#08,#09,#0a,#00,#04
db #46,#47,#46,#47,#0a,#e5,#08,#09 ;FGFG....
db #0a,#00,#06,#e5,#00,#0f,#e5,#00
db #08,#46,#47,#46,#47,#00,#01,#e5 ;.FGFG...
db #00,#09,#e5,#00,#0f,#e5,#00,#08
db #46,#47,#46,#47,#00,#01,#e5,#00 ;FGFG....
db #09,#e5,#00,#0f,#e5,#00,#08,#46 ;.......F
db #47,#46,#47,#00,#01,#e5,#00,#08 ;GFG.....
db #e4,#e5,#00,#0c,#e4,#00,#02,#e5
db #00,#08,#46,#47,#46,#47,#e4,#e5 ;..FGFG..
db #00,#04,#99,#98,#99,#73,#99,#98 ;.....s..
db #99,#73,#73,#98,#99,#99,#9b,#00 ;.ss.....
db #03,#75,#99,#73,#73,#98,#99,#99 ;.u.ss...
db #73,#98,#99,#73,#99,#98,#99,#73 ;s..s...s
db #99,#98,#73,#99,#73,#99,#98,#99 ;..s.s...
db #73,#c1,#c0,#c1,#74,#c1,#c0,#c1 ;s...t...
db #74,#c1,#c0,#74,#c1,#c2,#00,#03 ;t..t....
db #72,#c1,#74,#74,#c0,#74,#c1,#74 ;r.tt.t.t
db #c0,#c1,#c1,#74,#c0,#c1,#c1,#74 ;...t...t
db #c0,#74,#c1,#de,#c1,#c0,#c1,#74 ;.t.....t
db #00,#04,#e3,#00,#0d,#e3,#00,#0b
db #46,#47,#46,#47,#e3,#00,#23,#46 ;FGFG...F
db #47,#46,#47,#00,#24,#46,#47,#46 ;GFG..FGF
db #47,#00,#24,#46,#47,#46,#47,#00 ;G..FGFG.
db #22,#39,#2c,#1e,#1f,#1e,#1f,#1e
db #1f,#1e,#1f,#1e,#1f,#98,#9a,#00
db #19,#61,#ae,#ae,#ae,#bd,#ae,#ae ;.a......
db #be,#be,#bc,#ae,#bd,#be,#c0,#c2
db #00,#1a,#08,#ae,#0a,#08,#09,#09
db #08,#07,#08,#08,#09,#0a,#8f,#00
db #3d,#df,#e0,#00,#26,#da,#db,#00
db #0e,#3c,#3f,#99,#98,#99,#99,#99
db #73,#73,#98,#99,#99,#73,#99,#99 ;ss...s..
db #98,#73,#99,#99,#99,#98,#99,#99 ;.s......
db #99,#73,#98,#73,#99,#9b,#bb,#bd ;.s.s....
db #bc,#bd,#bc,#bf,#86,#ae,#bc,#bd
db #bd,#64,#bd,#ff,#07,#08,#09,#e5 ;.d......
db #09,#0a,#07,#0a,#00,#0e,#07,#09
db #e5,#08,#0a,#08,#09,#e5,#0a,#00
db #0c,#e5,#00,#14,#e5,#00,#04,#e5
db #00,#0d,#e5,#00,#14,#e5,#00,#04
db #e5,#00,#22,#e5,#00,#04,#e5,#00
db #22,#e5,#00,#04,#e5,#00,#04,#e4
db #e4,#00,#1b,#97,#98,#99,#99,#99
db #99,#98,#9a,#00,#02,#75,#98,#99 ;.....u..
db #99,#99,#98,#99,#00,#17,#72,#c0 ;......r.
db #74,#74,#74,#74,#c0,#c2,#00,#02 ;tttt....
db #72,#c0,#74,#c1,#74,#c0,#74,#00 ;r.t.t.t.
db #22,#e3,#e3,#00,#7c,#2c,#00,#19
db #e4,#00,#0d,#50,#96,#00,#12,#75 ;...P...u
db #99,#99,#73,#98,#73,#99,#73,#98 ;..s.s.s.
db #73,#73,#99,#98,#73,#73,#73,#98 ;ss..sss.
db #99,#99,#99,#78,#79,#2c,#00,#11 ;...xy...
db #97,#98,#9a,#c1,#c0,#c1,#c1,#74 ;.......t
db #c0,#c1,#c1,#74,#c0,#74,#c1,#c1 ;...t.t..
db #c0,#74,#74,#c1,#28,#8f,#00,#12 ;.tt.....
db #72,#c0,#c2,#e8,#00,#01,#e8,#e3 ;r.......
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#03,#90
db #50,#00,#13,#97,#98,#9b,#e8,#00 ;P.......
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#04,#78,#00,#0c,#97,#98 ;...x....
db #9b,#00,#04,#72,#c0,#c2,#e8,#00 ;...r....
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#04,#78,#51,#7b,#51,#52 ;...xQ.QR
db #79,#7c,#7b,#79,#2b,#28,#7c,#bd ;y..y....
db #c1,#c0,#c2,#be,#bc,#96,#75,#99 ;......u.
db #98,#99,#73,#73,#98,#73,#99,#99 ;..ss.s..
db #98,#99,#73,#73,#98,#99,#99,#99 ;..ss....
db #98,#99,#73,#ff,#00,#26,#90,#2c ;..s.....
db #00,#27,#50,#00,#27,#78,#00 ;..P..x.
lab5320 db #18
db #bb,#ae,#bd,#bc,#ae,#7c,#bd,#bf
db #be,#60,#7c,#bc,#bd,#bf,#bc,#ae
db #00,#18,#07,#08,#09,#0a,#07,#08
db #09,#09,#0a,#08,#09,#09,#08,#09
db #0a,#08,#00,#ab,#6e,#6f,#00,#0e ;....no..
db #6e,#6f,#00,#16,#65,#66,#00,#0e ;no..ef..
db #65,#66,#00,#16,#8d,#8e,#00,#0e ;ef......
db #8d,#8e,#00,#0b,#54,#00,#26,#39 ;....T...
db #bc,#2c,#00,#24,#39,#7b,#ae,#8f
db #00,#25,#90,#ae,#00,#27,#ae,#00
db #18,#e4,#00,#0e,#86,#bc,#7c,#79 ;.......y
db #7a,#7b,#bc,#bf,#ae,#be,#7c,#bf ;z.......
db #bd,#96,#75,#98,#9b,#bb,#bd,#60 ;..u.....
db #86,#ae,#96,#75,#98,#73,#99,#98 ;...u.s..
db #9a,#51,#52,#7c,#7b,#28,#51,#7c ;.QR...Q.
db #29,#28,#7b,#28,#ff,#00,#9a,#6e ;.......n
db #6f,#00,#25,#39,#86,#ae,#96,#00 ;o.......
db #02,#39,#00,#20,#bb,#bc,#bc,#60
db #ae,#ae,#bd,#ae,#00,#20,#07,#0a
db #08,#09,#09,#10,#86,#ae,#00,#26
db #90,#86,#00,#27,#90,#76,#76,#27 ;.....vv.
db #9f,#00,#24,#77,#77,#4f,#c7,#00 ;...wwO..
db #24,#76,#27,#9e,#c3,#00,#0b,#6e ;.v.....n
db #6f,#00,#0b,#bb,#bd,#ae,#bf,#bd ;o.......
db #bc,#be,#bc,#be,#bf,#bd,#bc,#77 ;.......w
db #4f,#c7,#00,#0c,#c4,#27 ;O.....
lab53EF db #9f
db #00,#0a,#07,#09,#0a,#07,#08,#09
db #0a,#08,#10,#ae,#60,#ae,#76,#27 ;......v.
db #c6,#00,#0c,#4e,#4f,#c7,#00,#13 ;...NO...
db #90,#86,#60,#8f,#00,#01,#c3,#00
db #0c,#26,#27,#c6,#00,#14,#90,#86
db #00,#08,#c4,#27,#9f,#00,#03,#c4
db #76,#76,#76,#76,#27,#9f,#00,#12 ;vvvv....
db #ae,#00,#08,#4e,#4f,#c7,#00,#03 ;...NO...
db #c5,#77,#77,#77,#77,#4f,#c7,#00 ;.wwwwO..
db #12,#ae,#1d,#02,#1c,#03,#04,#03
db #04,#02,#04,#02,#02,#1c,#18,#1b
db #1b,#19,#17,#1d,#02,#02,#05,#1c
db #1d,#1c,#18,#04,#03,#15,#bd,#bd
db #bf,#bd,#bc,#bf,#bd,#bf,#bd,#ae
db #bc,#bc,#ff,#07,#08,#09,#08,#09
db #10,#0a,#00,#99,#03,#04,#05,#02
db #05,#02,#06,#00,#21,#0a,#08,#09
db #09,#08,#09,#0a,#00,#99,#76,#76 ;......vv
db #27,#9f,#00,#0a,#26,#76,#76,#76 ;.....vvv
db #76,#76,#76,#76,#76,#76,#76,#27 ;vvvvvvv.
db #9f,#00,#0b,#c4,#76,#77,#77,#4f ;....vwwO
db #c7,#00,#0a,#4e,#77,#77,#77,#77 ;...Nwwww
db #77,#77,#77,#77,#77,#77,#4f,#c7 ;wwwwwwO.
db #00,#0b,#c5,#77,#76,#27,#9e,#c3 ;...wv...
db #00,#0a,#9c,#26,#76,#27,#9e,#9d ;....v...
db #9d,#9d,#26,#76,#27,#9e,#c3,#00 ;...v....
db #0b,#9c,#26,#77,#4f,#c7,#00,#0c ;...wO...
db #4e,#77,#4f,#c7,#00,#03,#4e,#77 ;NwO...Nw
db #4f,#c7,#00,#0d,#4e,#76,#27,#c6 ;O...Nv..
db #00,#0c,#26,#76,#27,#c6,#00,#03 ;...v....
db #26,#76,#27,#c6,#00,#0d,#26,#77 ;.v.....w
db #4f,#c7,#00,#0c,#4e,#77,#4f,#c7 ;O...NwO.
db #00,#03,#4e,#77,#4f,#c7,#00,#0d ;..NwO...
db #90,#76,#27,#c6,#00,#0b,#26,#26 ;.v......
db #76,#27,#c6,#27,#9f,#00,#01,#26 ;v.......
db #76,#27,#c6,#6e,#6f,#00,#0c,#77 ;v..no..w
db #4f,#c7,#00,#07,#6e,#6f,#00,#02 ;O...no..
db #4e,#4e,#77,#4f,#c7,#4f,#c7,#76 ;NNwO.O.v
db #4e,#77,#4f,#c7,#76,#76,#27,#9f ;NwO.vv..
db #00,#0a,#1b,#17,#17,#18,#03,#03
db #04,#05,#03,#04,#02,#1c,#03,#1d
db #1c,#1d,#02,#02,#1c,#03,#04,#05
db #1c,#1a,#1b,#04,#04,#05,#1c,#19
db #19,#17,#18,#03,#04,#05,#02,#1c
db #1a,#19,#ff,#dd,#dd,#dd,#d1,#b0
db #d9,#e6,#00,#01,#e7,#b5,#b6,#dc
db #dd,#dd,#dd,#d1,#b0,#d9,#e6,#00
db #01,#e7,#b5,#b6,#dc,#dd,#dd,#dd
db #d1,#b0,#d9,#e6,#00,#01,#e7,#b5
db #b6,#dc,#dd,#dd,#dd,#d1,#a5,#a6
db #a7,#00,#09,#a5,#a6,#a7,#00,#09
db #a5,#a6,#a7,#00,#09,#a5,#a6,#a7
db #00,#02,#ed,#00,#0b,#ed,#00,#0b
db #ed,#00,#0b,#ed,#00,#03,#f5,#00
db #0b,#f5,#00,#0b,#ed,#00,#0b,#ed
db #00,#0f,#f2,#00,#0b,#ed,#00,#0b
db #8f,#00,#0f,#ed,#00,#0b,#ed,#00
db #1a,#e1,#e2,#fe,#00,#09,#e1,#e2
db #fe,#00,#09,#e1,#00,#03,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#8c,#41,#43 ;......AC
db #00,#03,#40,#41,#42,#41,#42,#41 ;...ABABA
db #42,#41,#b4,#81,#81,#81,#81,#8c ;BA......
db #b4,#81,#81,#81,#81,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#b8,#92,#00
db #03,#91,#ba,#b7,#ba,#b7,#ba,#b7
db #b9,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#00,#8a,#a2,#8c
db #42,#41,#42,#41,#42,#41,#b4,#81 ;BABABA..
db #81,#8c,#42,#41,#b4,#81,#81,#81 ;..BA....
db #81,#81,#81,#81,#00,#12,#cd,#cf
db #b8,#ba,#b7,#ba,#b7,#b9,#cf,#cf
db #cf,#cf,#b8,#b9,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#00,#14,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #02,#90,#00,#14,#e8,#00,#01,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#17,#e8
db #00,#01,#e8,#00,#01,#e8,#00,#01
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#03,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#8c
db #42,#b4,#cf,#cf,#cf,#cf,#cf,#cf ;B.......
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#ff,#b0,#d9,#e6,#00,#01
db #e7,#b5,#b6,#dc,#dd,#dd,#dd,#d1
db #b0,#d9,#e6,#00,#01,#e7,#b5,#b6
db #dc,#dd,#dd,#dd,#d1,#b0,#d9,#e6
db #00,#01,#e7,#58,#30,#00,#08,#90 ;...X....
db #00,#08,#a5,#a6,#a7,#00,#09,#a5
db #a6,#a7,#00,#06,#31,#30,#00,#12
db #ed,#00,#0b,#ca,#00,#07,#31,#30
db #00,#12,#ed,#00,#0b,#f5,#00,#07
db #31,#30,#00,#05,#bb,#bc,#bd,#bf
db #00,#09,#ed,#00,#13,#31,#30,#00
db #05,#07,#09,#09,#08,#00,#08,#e1
db #e2,#fe,#00,#12,#31,#30,#00,#09
db #81,#81,#8c,#41,#42,#41,#42,#b4 ;...ABAB.
db #81,#81,#81,#2c,#00,#11,#31,#30
db #00,#09,#cf,#cf,#cf,#b8,#b7,#b7
db #b9,#cf,#cf,#cf,#cf,#cf,#2c,#00
db #10,#31,#30,#00,#26,#31,#30,#00
db #26,#31,#30,#00,#26,#31,#30,#00
db #13,#e4,#00,#12,#31,#30,#00,#09
db #81,#81,#81,#81,#81,#81,#8c,#41 ;.......A
db #42,#b4,#81,#81,#81,#81,#81,#2c ;B.......
db #00,#0d,#31,#30,#00,#09,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#b8,#b9,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#2c,#00
db #0c,#31,#30,#00,#09,#8f,#00,#03
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#10,#31
db #30,#00,#0d,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#01,#e8
db #00,#0e,#df,#e0,#31,#30,#00,#0d
db #e8,#00,#01,#e8,#00,#01,#e8,#00
db #01,#e8,#00,#01,#e8,#00,#0e,#da
db #db,#31,#30,#2c,#00,#08,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #81,#81,#81,#81,#81,#81,#81,#81
db #8c,#41,#42,#41,#42,#41,#42,#41 ;.ABABABA
db #42,#41,#43,#31,#30,#ae,#bc,#bf ;BAC.....
db #bc,#bd,#bf,#bc,#bc,#bd,#ff,#00
db #09,#eb,#ec,#00,#12,#eb,#ec,#00
db #12,#e9,#ea,#00,#12,#e9,#ea,#00
db #12,#eb,#ec,#00,#12,#eb,#ec,#00
db #12,#e9,#ea,#00,#12,#e9,#ea,#00
db #12,#eb,#ec,#00,#12,#eb,#ec,#00
db #0b,#6e,#6f,#00,#05,#e9,#ea,#00 ;.no.....
db #12,#e9,#ea,#00,#04,#6e,#6f,#00 ;.....no.
db #05,#40,#41,#42,#41,#43,#9f,#00 ;..ABAC..
db #01,#eb,#ec,#00,#12,#eb,#ec,#00
db #01,#40,#43,#9f,#40,#43,#9f,#00 ;..C..C..
db #04,#3c,#b8,#b7,#b7,#92,#c7,#42 ;.......B
db #41,#42,#43,#9f,#41,#42,#41,#43 ;ABC.ABAC
db #9f,#00,#01,#6e,#6f,#00,#01,#40 ;...no...
db #41,#42,#41,#43,#40,#41,#42,#41 ;ABAC.ABA
db #43,#69,#92,#c7,#69,#92,#c7,#00 ;Ci..i...
db #04,#64,#3f,#b8,#ba,#92,#c7,#b7 ;.d......
db #ba,#b7,#6a,#c7,#ba,#b7,#b7,#6a ;..j....j
db #c7,#41,#42,#41,#43,#69,#b7,#ba ;.ABACi..
db #b7,#6a,#69,#b7,#ba,#b7,#92,#91 ;.ji.....
db #6a,#c7,#91,#6a,#c7,#00,#04,#3d ;j..j....
db #3e,#9e,#9d,#9d,#c3,#6a,#9e,#69 ;.....j.i
db #92,#c7,#92,#9e,#69,#92,#c7,#b7 ;....i...
db #ba,#b7,#6a,#91,#6a,#9e,#9d,#9d ;..j.j...
db #91,#6a,#9e,#69,#92,#69,#92,#c7 ;.j.i.i..
db #69,#92,#c7,#00,#04,#3c,#3f,#c6 ;i.......
db #00,#03,#92,#c7,#91,#6a,#c7,#6a ;.....j.j
db #c7,#91,#6a,#c7,#6a,#9e,#9d,#9d ;..j.j...
db #69,#92,#c7,#00,#02,#69,#92,#c7 ;i....i..
db #91,#6a,#91,#6a,#c7,#91,#b9,#c7 ;.j.j....
db #00,#04,#64,#3f,#3c,#3d,#3e,#9f ;..d.....
db #92,#c7,#69,#92,#c7,#b7,#41,#b7 ;..i...A.
db #92,#c7,#92,#c7,#00,#02,#91,#ba
db #42,#41,#43,#91,#ba,#42,#ba,#9e ;BAC..B..
db #69,#b7,#42,#b9,#3c,#c7,#00,#04 ;i.B.....
db #3d,#3e,#64,#3f,#3c,#c6,#6a,#c7 ;..d...j.
db #91,#6a,#c7,#ba,#b7,#92,#9e,#c3 ;.j......
db #6a,#c7,#00,#02,#69,#b7,#ba,#b7 ;j...i...
db #6a,#69,#b7,#ba,#b9,#3e,#91,#ba ;ji......
db #b9,#3f,#64,#c7,#00,#04,#9c,#9d ;..d.....
db #9d,#3f,#64,#c7,#b8,#c7,#69,#92 ;..d...i.
db #c7,#92,#9e,#69,#43,#9f,#92,#c7 ;...iC...
db #00,#02,#91,#6a,#9e,#9d,#9d,#91 ;...j....
db #6a,#9e,#3c,#3f,#9e,#9d,#9d,#3d ;j.......
db #3e,#c7,#00,#07,#3f,#3f,#c6,#3f
db #c7,#91,#6a,#c7,#6a,#c7,#91,#6a ;..j.j..j
db #c7,#6a,#c7,#00,#02,#69,#92,#c7 ;.j...i..
db #00,#02,#69,#92,#c7,#64,#3c,#c7 ;..i..d..
db #00,#02,#3d,#3e,#c7,#00,#04,#3f
db #3c,#3d,#3e,#3c,#c6,#3e,#8c,#ba
db #92,#c7,#92,#c7,#69,#92,#c7,#92 ;....i...
db #c7,#00,#02,#91,#ba,#42,#b4,#3f ;.....B..
db #91,#6a,#c7,#3d,#40,#41,#b4,#3d ;.j...A..
db #3e,#3c,#c7,#00,#04,#3f,#64,#3d ;......d.
db #3e,#64,#c7,#3d,#3e,#b8,#6a,#c7 ;.d....j.
db #b8,#c7,#91,#6a,#c7,#ba,#42,#41 ;...j..BA
db #43,#69,#b7,#b9,#3d,#3e,#69,#92 ;Ci....i.
db #c7,#3f,#91,#b9,#3f,#3d,#3e,#64 ;.......d
db #c7,#00,#03,#bb,#bc,#ae,#bc,#86
db #be,#bd,#be,#86,#ae,#ae,#bd,#bc
db #bf,#86,#be,#bf,#bc,#ae,#ae,#be
db #bc,#bc,#bc,#ae,#bc,#ae,#bc,#bf
db #bc,#86,#bc,#ae,#ae,#bc,#ae,#bf
db #2c,#00,#01,#ff,#cc,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
lab5A40 db #68
db #7c,#2d,#00,#10,#88,#37,#00,#70 ;.......p
db #50,#29,#00,#70,#38,#41,#00,#70 ;P..p.A.p
db #5c,#2a,#00,#60,#40,#29,#00,#68 ;.......h
db #6c,#3b,#00,#68,#2c,#38,#00,#58 ;l..h...X
db #84,#46,#00,#68,#50,#2d,#00,#38 ;.F.hP...
db #08,#41,#00,#70,#14,#2c,#00,#70 ;.A.p...p
db #60,#2c,#00,#58,#44,#39,#00,#60 ;...XD...
db #10,#29,#00,#60,#68,#41,#00,#60 ;....hA..
db #10,#44,#00,#10,#88,#37,#00,#70 ;.D.....p
db #78,#2a,#00,#70,#58,#2b,#00,#18 ;x..pX...
db #20,#2d,#00,#18,#60,#3a,#00,#48 ;.......H
db #28,#29,#00,#60,#54,#2a,#00,#10 ;....T...
db #5c,#40,#00,#30,#68,#37,#00,#70 ;....h..p
db #1c,#2d,#00,#10,#90,#47,#00,#70 ;.....G.p
db #30,#45,#00,#30,#74,#37,#00,#28 ;.E..t...
db #64,#37,#00,#70,#1c,#2c,#00,#40 ;d..p....
db #78,#46,#00,#38,#1c,#37,#00,#70 ;xF.....p
db #50,#2a,#00,#70,#90,#2d,#00,#10 ;P..p....
db #14,#2a,#00,#70,#90,#45,#00,#70 ;...p.E.p
db #34,#2a,#00,#00,#94,#2d,#00,#68 ;.......h
db #34,#41,#00,#10,#54,#29,#00,#08 ;.A..T...
db #44,#28,#00,#70,#0c,#3b,#00,#20 ;D..p....
db #04,#41,#00,#08,#8c,#44,#00,#68 ;.A...D.h
db #84,#2b,#00,#18,#8c,#37,#00,#60
db #40,#29,#00,#48,#00,#2d,#00,#38 ;...H....
db #80,#46,#00,#38,#08,#29,#00,#00 ;.F......
db #14,#2a,#00,#20,#94,#41,#00,#50 ;.....A.P
db #90,#2c,#00,#70,#34,#29,#00,#00 ;...p....
db #00,#00,#00,#00,#00,#00,#00,#08
db #08,#37,#00,#70,#5c,#28,#00,#40 ;...p....
db #5c,#41,#00,#70,#6c,#2c,#00,#40 ;.A.pl...
db #14,#29,#00,#70,#74,#46,#00,#30 ;...ptF..
db #90,#47,#00,#68,#08,#3b,#00,#70 ;.G.h...p
db #84,#40,#00,#10,#4c,#2a,#00,#70 ;....L..p
db #7c,#46,#00,#18,#08,#2a,#00,#00 ;.F......
db #68,#29,#00,#70,#68,#2a,#00,#60 ;h..ph...
db #44,#41,#00,#70,#54,#2d,#00,#30 ;DA.pT...
db #00,#29,#00,#70,#18,#2c,#00,#20 ;...p....
db #6c,#2a,#00,#48,#90,#29,#00,#70 ;l..H...p
db #80,#2d,#00,#48,#30,#46,#00 ;...H.F.
lab5B80 db #7
db #00,#01,#30,#0c,#00,#00,#00,#00
db #00,#02,#70,#58,#14,#00,#00,#00 ;..pX....
db #00,#00,#00,#81,#00,#70,#08,#a7 ;.....p..
db #00,#ff,#00,#00,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#07
db #00,#02,#70,#1c,#14,#00,#00,#00 ;..p.....
db #00,#01,#30,#94,#00,#00,#00,#00
db #00,#00,#00,#97,#00,#ff,#00,#00
db #00,#00,#94,#00,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#01
db #00,#01,#28,#38,#3c,#00,#00,#00
db #00,#02,#70,#6c,#14,#00,#00,#00 ;..pl....
db #00,#00,#00,#83,#00,#48,#1c,#db ;.....H..
db #01,#00,#94,#d0,#00,#70,#94,#4a ;.....p.J
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#02
db #00,#03,#70,#48,#0c,#00,#00,#00 ;..pH....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#08,#00,#84,#00,#50,#04,#1b ;.....P..
db #01,#08,#94,#02,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#02
db #00,#02,#70,#40,#14,#00,#00,#00 ;..p.....
db #00,#01,#40,#10,#00,#00,#00,#00
db #00,#10,#00,#85,#00,#ff,#00,#00
db #00,#00,#94,#03,#00,#ff,#00,#00
db #00,#70,#30,#00,#ff,#00,#00,#58 ;.p.....X
db #78,#29,#ff,#00,#00,#ff,#00,#01 ;x.......
db #00,#02,#70,#34,#14,#00,#00,#00 ;..p.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#00,#00,#00,#70,#00,#9d ;.....p..
db #00,#10,#94,#04,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#03
db #00,#03,#20,#18,#0c,#00,#00,#00
db #00,#01,#60,#24,#00,#00,#00,#00
db #00,#00,#2c,#c7,#00,#68,#08,#92 ;.....h..
db #02,#ff,#00,#00,#00,#70,#94,#57 ;.....p.W
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#05
db #00,#01,#50,#28,#3c,#00,#00,#00 ;..P.....
db #00,#02,#60,#4c,#14,#00,#00,#00 ;...L....
db #00,#00,#04,#88,#00,#ff,#00,#00
db #00,#ff,#00,#00,#00,#68,#90,#06 ;.....h..
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#05
db #00,#02,#50,#34,#14,#00,#00,#00 ;..P.....
db #00,#03,#28,#18,#0c,#00,#00,#00
db #00,#00,#00,#98,#00,#70,#48,#a6 ;.....pH.
db #02,#00,#94,#07,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#58,#54,#44,#70,#54,#03 ;..XTDpT.
db #00,#02,#70,#34,#14,#00,#00,#00 ;..p.....
db #00,#01,#20,#7c,#5a,#00,#00,#00 ;....Z...
db #00,#ff,#00,#00,#00,#68,#00,#ca ;.....h..
db #00,#00,#58,#58,#00,#70,#8c,#12 ;..XX.p..
db #02,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#08
db #00,#01,#00,#38,#3c,#00,#00,#00
db #00,#03,#70,#50,#0c,#00,#00,#00 ;..pP....
db #00,#10,#00,#4b,#00,#68,#00,#c2 ;...K.h..
db #00,#08,#88,#cb,#00,#68,#94,#49 ;.....h.I
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#08
db #00,#01,#70,#3c,#00,#00,#00,#00 ;..p.....
db #00,#03,#20,#3c,#0c,#00,#00,#00
db #00,#00,#00,#50,#00,#70,#00,#0a ;...P.p..
db #00,#00,#94,#0c,#00,#70,#94,#8a ;.....p..
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#09
db #00,#02,#70,#88,#14,#00,#00,#00 ;..p.....
db #00,#03,#20,#4c,#0c,#00,#00,#00 ;...L....
db #00,#00,#00,#8b,#00,#ff,#00,#00
db #00,#10,#94,#0d,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#10
db #68,#29,#ff,#00,#00,#ff,#00,#09 ;h.......
db #00,#02,#70,#44,#14,#00,#00,#00 ;..pD....
db #00,#01,#50,#60,#3c,#00,#00,#00 ;..P.....
db #00,#10,#00,#8c,#00,#ff,#00,#00
db #00,#00,#80,#8e,#00,#68,#94,#18 ;.....h..
db #00,#70,#08,#00,#ff,#00,#00,#ff ;.p......
db #00,#00,#30,#64,#2a,#ff,#00,#09 ;...d....
db #00,#03,#70,#64,#0c,#00,#00,#00 ;..pd....
db #00,#01,#18,#40,#00,#00,#00,#00
db #00,#18,#00,#8f,#00,#ff,#00,#00
db #00,#18,#7c,#8d,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#58,#8c,#3a,#78,#90,#09 ;..X..x..
db #00,#01,#58,#18,#5a,#00,#00,#00 ;..X.Z...
db #00,#03,#18,#4c,#0c,#00,#00,#00 ;...L....
db #00,#00,#00,#90,#00,#ff,#00,#00
db #00,#18,#94,#0e,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#0a
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#18,#9c,#00,#78,#00,#0b ;.....x..
db #00,#00,#94,#0f,#00,#78,#74,#82 ;.....xt.
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#0b
db #00,#02,#70,#78,#14,#00,#00,#00 ;..px....
db #00,#02,#70,#24,#14,#00,#00,#00 ;..p.....
db #00,#00,#00,#c9,#00,#68,#00,#d3 ;.....h..
db #00,#00,#94,#52,#00,#ff,#00,#00 ;...R....
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#50,#90,#2a,#ff,#00,#04 ;..P.....
db #00,#02,#10,#74,#14,#00,#00,#00 ;...t....
db #00,#01,#58,#3c,#5a,#00,#00,#00 ;..X.Z...
db #00,#10,#00,#c9,#00,#70,#00,#91 ;.....p..
db #00,#10,#94,#46,#00,#ff,#00,#00 ;...F....
db #00,#ff,#00,#00,#ff,#00,#00,#68 ;.......h
db #80,#2a,#18,#38,#2a,#ff,#00,#0b
db #00,#01,#70,#50,#3c,#00,#00,#00 ;..pP....
db #00,#03,#00,#04,#0c,#00,#00,#00
db #00,#ff,#00,#00,#00,#60,#00,#d4
db #00,#ff,#00,#00,#00,#68,#94,#51 ;.....h.Q
db #00,#48,#34,#00,#ff,#00,#00,#68 ;.H.....h
db #3c,#29,#ff,#00,#00,#ff,#00,#0b
db #00,#02,#70,#64,#14,#00,#00,#00 ;..pd....
db #00,#03,#10,#18,#0c,#00,#00,#00
db #00,#ff,#00,#00,#00,#50,#00,#d5 ;.....P..
db #00,#ff,#00,#00,#00,#68,#94,#53 ;.....h.S
db #00,#ff,#00,#00,#ff,#00,#00,#30
db #58,#45,#ff,#00,#00,#38,#48,#0b ;XE....H.
db #00,#02,#70,#28,#14,#00,#00,#00 ;..p.....
db #00,#03,#08,#10,#0c,#00,#00,#00
db #00,#ff,#00,#00,#00,#48,#00,#d6 ;.....H..
db #00,#ff,#00,#00,#00,#68,#94,#54 ;.....h.T
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#50,#10,#2a,#ff,#00,#0b ;..P.....
db #00,#02,#70,#38,#14,#00,#00,#00 ;..p.....
db #00,#02,#70,#5c,#14,#00,#00,#00 ;..p.....
db #00,#ff,#00,#00,#00,#70,#00,#d9 ;.....p..
db #00,#ff,#00,#00,#00,#70,#94,#55 ;.....p.U
db #00,#50,#94,#00,#ff,#00,#00,#40 ;.P......
db #88,#2a,#50,#30,#3b,#ff,#00,#00 ;..P.....
db #00,#01,#08,#08,#00,#00,#00,#00
db #00,#01,#50,#90,#3c,#00,#00,#00 ;..P.....
db #00,#ff,#00,#00,#00,#70,#00,#c6 ;.....p..
db #00,#00,#94,#01,#00,#ff,#00,#00
db #00,#38,#30,#00,#ff,#00,#00,#68 ;.......h
db #50,#29,#ff,#00,#00,#ff,#00,#05 ;P.......
db #00,#02,#60,#88,#14,#00,#00,#00
db #00,#01,#18,#90,#3c,#00,#00,#00
db #00,#08,#00,#cd,#00,#68,#00,#89 ;.....h..
db #00,#00,#94,#08,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#0d
db #00,#02,#00,#8c,#14,#00,#00,#00
db #00,#02,#70,#50,#14,#00,#00,#00 ;..pP....
db #00,#00,#00,#da,#00,#70,#00,#e0 ;.....p..
db #00,#ff,#00,#00,#00,#70,#94,#56 ;.....p.V
db #00,#ff,#00,#00,#ff,#00,#00,#48 ;.......H
db #50,#28,#08,#6c,#2a,#48,#44,#0c ;P..l.HD.
db #00,#02,#70,#4c,#14,#00,#00,#00 ;..pL....
db #00,#02,#40,#5c,#14,#00,#00,#00
db #00,#ff,#00,#00,#00,#70,#08,#dd ;.....p..
db #00,#40,#90,#5b,#00,#70,#94,#19 ;.....p..
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#48,#44,#29,#ff,#00,#0c ;..HD....
db #00,#03,#30,#08,#0c,#00,#00,#00
db #00,#01,#18,#90,#00,#00,#00,#00
db #00,#00,#00,#43,#02,#70,#08,#9a ;...C.p..
db #00,#ff,#00,#00,#00,#70,#94,#42 ;.....p.B
db #00,#70,#50,#00,#ff,#00,#00,#40 ;.pP.....
db #74,#38,#18,#1c,#29,#50,#84,#0e ;t....P..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#00,#00,#00,#ff,#00,#00
db #00,#00,#94,#10,#00,#ff,#00,#00
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#06
db #00,#01,#70,#70,#5a,#00,#00,#00 ;..ppZ...
db #00,#01,#00,#44,#3c,#00,#00,#00 ;...D....
db #00,#68,#00,#9e,#00,#78,#3c,#de ;.h...x..
db #00,#10,#94,#45,#00,#70,#94,#5a ;...E.p.Z
db #01,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#06
db #00,#03,#10,#20,#0c,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#70,#00,#9f,#00,#70,#34,#df ;.p...p..
db #00,#38,#94,#1d,#00,#70,#94,#5d ;.....p..
db #00,#ff,#00,#00,#ff,#00,#00,#00
db #10,#40,#ff,#00,#00,#00,#04,#06
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#02,#40,#00,#14,#00,#00,#00
db #00,#70,#00,#a4,#00,#70,#60,#a3 ;.p...p..
db #00,#40,#94,#1e,#00,#70,#94,#5e ;.....p..
db #00,#40,#78,#00,#ff,#00,#00,#ff ;..x.....
db #00,#00,#50,#4c,#29,#ff,#00,#0b ;..PL....
db #00,#02,#70,#5c,#14,#00,#00,#00 ;..p.....
db #00,#01,#40,#04,#5a,#00,#00,#00 ;....Z...
db #00,#10,#00,#a1,#00,#ff,#00,#00
db #00,#ff,#00,#00,#00,#70,#94,#59 ;.....p.Y
db #01,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#10,#90,#2a,#ff,#00,#0b
db #00,#02,#10,#58,#14,#00,#00,#00 ;...X....
db #00,#01,#40,#94,#5a,#00,#00,#00 ;....Z...
db #00,#10,#00,#a2,#00,#70,#00,#e2 ;.....p..
db #00,#10,#94,#20,#00,#ff,#00,#00
db #00,#70,#48,#00,#ff,#00,#00,#70 ;.pH....p
db #70,#2a,#20,#34,#29,#ff,#00,#0f ;p.......
db #00,#01,#70,#44,#5a,#00,#00,#00 ;..pDZ...
db #00,#01,#70,#64,#5a,#00,#00,#00 ;..pdZ...
db #00,#ff,#00,#00,#00,#70,#04,#e3 ;.....p..
db #00,#10,#94,#21,#00,#70,#94,#61 ;.....p.a
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#0f
db #00,#02,#70,#50,#14,#00,#00,#00 ;..pP....
db #00,#01,#30,#2c,#5a,#00,#00,#00 ;....Z...
db #00,#ff,#00,#00,#00,#70,#04,#e4 ;.....p..
db #00,#00,#90,#5f,#00,#70,#94,#62 ;.....p.b
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#10
db #00,#01,#70,#2c,#5a,#00,#00,#00 ;..p.Z...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#00,#00,#00,#70,#00,#e5 ;.....p..
db #00,#40,#94,#1f,#00,#70,#90,#63 ;.....p.c
db #00,#ff,#00,#00,#ff,#00,#00,#ff
db #00,#00,#ff,#00,#00,#ff,#00,#11
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#03,#70,#0c,#0c,#00,#00,#00 ;..p.....
db #00,#ff,#00,#00,#00,#ff,#00,#00
db #00,#ff,#00,#00,#00,#70,#94,#64 ;.....p.d
db #00,#ff,#00,#00,#ff,#00,#00,#08
db #10,#47,#ff,#00,#00,#08,#04,#04 ;.G......
db #00,#02,#20,#3c,#14,#00,#00,#00
db #00,#02,#70,#00,#14,#00,#00,#00 ;..p.....
db #00,#20,#00,#92,#00,#ff,#00,#00
db #00,#20,#94,#48,#00,#70,#94,#67 ;...H.p.g
db #00,#ff,#00,#00,#ff,#00,#00,#70 ;.......p
db #44,#39,#28,#48,#2a,#ff,#00,#04 ;D..H....
db #00,#01,#28,#94,#00,#00,#00,#00
db #00,#03,#08,#64,#0c,#00,#00,#00 ;...d....
db #00,#18,#00,#a6,#00,#70,#00,#e6 ;.....p..
db #00,#00,#94,#40,#00,#ff,#00,#00
db #00,#70,#58,#00,#ff,#00,#00,#70 ;.pX....p
db #38,#29,#ff,#00,#00,#70,#20,#00 ;.....p..
db #00,#00,#00,#00,#00,#00,#00,#18
db #18,#18,#18,#18,#00,#18,#00,#6c ;.......l
db #6c,#6c,#00,#00,#00,#00,#00,#6c ;ll.....l
db #6c,#fe,#6c,#fe,#6c,#6c,#00,#18 ;l.l.ll..
db #3e,#58,#3c,#1a,#7c,#18,#00,#46 ;.X.....F
db #ae,#5c,#38,#74,#ea,#c4,#00,#38 ;...t....
db #6c,#38,#76,#dc,#cc,#76,#00,#18 ;l.v..v..
db #10,#20,#00,#00,#00,#00,#00,#0c
db #18,#30,#30,#30,#18,#0c,#00,#30
db #18,#0c,#0c,#0c,#18,#30,#00,#00
db #66,#3c,#ff,#3c,#66,#00,#00,#00 ;f...f...
db #18,#18,#7e,#18,#18,#00,#00,#00
db #00,#00,#00,#00,#18,#30,#00,#00
db #00,#00,#7e,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#08,#1c,#08,#06
db #0c,#18,#30,#60,#c0,#80,#00,#38
db #4c,#ce,#d6,#e6,#64,#38,#00,#78 ;L...d..x
db #18,#18,#18,#18,#18,#7e,#00,#7c
db #c6,#66,#1c,#30,#62,#fe,#00,#7e ;.f..b...
db #8c,#18,#3c,#06,#86,#7c,#00,#1c
db #3c,#6c,#cc,#fe,#0c,#0c,#00,#7e ;.l......
db #c0,#c0,#fc,#06,#c6,#7c,#00,#1c
db #30,#60,#fc,#c6,#c6,#7c,#00,#fe
db #86,#0c,#18,#30,#60,#c0,#00,#7c
db #c6,#c6,#7c,#c6,#c6,#7c,#00,#7c
db #c6,#c6,#7e,#06,#8c,#78,#00,#00 ;.....x..
db #18,#30,#00,#00,#18,#30,#00,#00
db #00,#18,#18,#00,#18,#18,#30,#0c
db #18,#30,#60,#30,#18,#0c,#00,#00
db #00,#7e,#00,#00,#7e,#00,#00,#60
db #30,#18,#0c,#18,#30,#60,#00,#7c
db #c6,#06,#1c,#30,#30,#00,#30,#7c
db #c6,#de,#de,#de,#c0,#7c,#00,#3a
db #46,#c6,#c6,#c6,#ce,#76,#00,#dc ;F....v..
db #e6,#c6,#fc,#c6,#c6,#fc,#00,#3c
db #42,#c0,#c0,#c0,#66,#3c,#00,#0e ;B...f...
db #76,#ce,#c6,#c6,#46,#3c,#00,#3c ;v...F...
db #66,#c6,#fc,#c0,#66,#3c,#00,#5c ;f...f...
db #66,#60,#f8,#60,#60,#60,#80,#3a ;f.......
db #66,#c6,#c6,#4e,#76,#86,#7c,#c0 ;f..Nv...
db #fc,#e6,#c6,#c6,#cc,#de,#00,#7c
db #b8,#30,#30,#30,#34,#fc,#00,#7f
db #06,#06,#46,#c6,#6c,#38,#00,#c6 ;..F.l...
db #cc,#d8,#f0,#f0,#d8,#ce,#00,#f8
db #30,#60,#60,#60,#66,#7c,#00,#ac ;....f...
db #d6,#d6,#d6,#d6,#d6,#d4,#00,#dc
db #f6,#e6,#c6,#c6,#cc,#de,#00,#38
db #4c,#c6,#c6,#c6,#64,#38,#00,#dc ;L...d...
db #ee,#c6,#c6,#c6,#ec,#d8,#c0,#38
db #4c,#c6,#c6,#c6,#64,#38,#1e,#dc ;L...d...
db #e6,#c6,#c4,#f8,#cc,#c6,#00,#7c
db #c2,#c0,#7c,#06,#c6,#7c,#00,#fe
db #18,#30,#30,#30,#30,#18,#00,#f6
db #66,#46,#c6,#c6,#ee,#76,#00,#e6 ;fF...v..
db #46,#c6,#c6,#66,#3c,#18,#00,#cc ;F..f....
db #46,#d6,#d6,#d6,#d6,#6c,#00,#86 ;F....l..
db #cc,#78,#38,#3c,#66,#c2,#00,#c6 ;.x..f...
db #66,#66,#66,#3c,#8c,#cc,#78,#3e ;fff...x.
db #46,#0c,#18,#30,#62,#fc,#00,#3c ;F...b...
db #30,#30,#30,#30,#30,#3c,#00,#c0
db #60,#30,#18,#0c,#06,#02,#00,#3c
db #0c,#0c,#0c,#0c,#0c,#3c,#00,#18
db #3c,#7e,#18,#18,#18,#18,#00,#00
db #00,#00,#00,#00,#00,#00,#ff
lab6500 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#11,#00,#33,#00,#33,#11
db #73,#11,#53,#33,#e7,#e7,#8b,#f3 ;s.S.....
db #f3,#53,#03,#03,#2b,#3f,#3f,#3f ;.S......
db #3f,#7f,#ff,#eb,#c3,#cf,#cf,#00
db #00,#f3,#11,#f3,#73,#f3,#f3,#f3 ;....s...
db #f3,#53,#53,#03,#2b,#3f,#3f,#33 ;.SS.....
db #11,#73,#73,#b3,#a3,#a3,#03,#03 ;.ss.....
db #03,#03,#3f,#3f,#3f,#3f,#cf,#00
db #73,#a2,#23,#13,#53,#03,#03,#17 ;s...S...
db #2b,#3f,#3f,#c3,#c3,#cf,#cf,#8a
db #00,#e7,#00,#cf,#00,#47,#82,#e7 ;.....G..
db #82,#8b,#cb,#47,#cb,#cb,#cb,#37 ;...G....
db #9f,#13,#6f,#01,#02,#01,#45,#00 ;..o...E.
db #02,#00,#45,#00,#00,#00,#00,#cb ;..E.....
db #cb,#6f,#6f,#cb,#43,#aa,#c7,#8a ;.oo.C...
db #cb,#00,#45,#00,#00,#00,#00,#c3 ;..E.....
db #d7,#ef,#ef,#9f,#9f,#45,#ef,#8a ;.....E..
db #8a,#45,#45,#82,#82,#41,#45,#eb ;.EE..AE.
db #c3,#c7,#c3,#eb,#aa,#d7,#82,#41 ;.......A
db #00,#82,#00,#00,#00,#00,#00,#55 ;.......U
db #bf,#00,#ff,#00,#bf,#00,#ff,#00
db #bf,#00,#ff,#55,#bf,#ab,#57,#aa ;...U..W.
db #82,#c3,#00,#aa,#00,#82,#00,#aa
db #00,#c3,#00,#eb,#00,#c7,#82,#03
db #df,#47,#47,#03,#ff,#57,#ef,#03 ;.GG..W..
db #ff,#8b,#57,#55,#ff,#8a,#aa,#cb ;..WU....
db #2b,#ef,#97,#83,#ff,#df,#8b,#eb
db #97,#ef,#ef,#8a,#8a,#45,#00,#a3 ;.....E..
db #ab,#f7,#03,#fb,#a3,#f3,#13,#a3
db #03,#01,#11,#a2,#02,#01,#01,#83
db #cf,#cf,#8b,#c7,#cf,#cb,#47,#d7 ;......G.
db #c7,#8a,#ef,#41,#55,#82,#41,#00 ;...AU.A.
db #11,#51,#73,#11,#b3,#f3,#fb,#b3 ;.Qs.....
db #77,#b3,#53,#51,#01,#00,#a2,#82 ;w.SQ....
db #00,#c3,#00,#6b,#82,#c3,#82,#eb ;...k....
db #eb,#df,#c3,#8a,#82,#41,#00,#00 ;.....A..
db #51,#00,#11,#00,#73,#11,#e3,#51 ;Q...s..Q
db #f3,#f3,#e3,#f3,#73,#b3,#e3,#a2 ;....s...
db #00,#d3,#00,#c3,#82,#db,#82,#43 ;.......C
db #82,#c7,#c3,#df,#cb,#47,#c3,#73 ;.....G.s
db #e7,#f3,#db,#f3,#e7,#f5,#df,#f3
db #ff,#a3,#57,#a3,#cf,#47,#57,#47 ;..W..GWG
db #c7,#57,#cf,#cf,#cb,#ab,#cf,#47 ;.W.....G
db #cb,#ef,#cb,#ef,#c7,#ef,#cb,#73 ;.......s
db #73,#b3,#f3,#73,#f3,#f3,#f3,#f3 ;s..s....
db #a3,#53,#53,#a3,#a3,#53,#53,#02 ;.SS..SS.
db #00,#a3,#11,#f3,#73,#b3,#f3,#f3 ;....s...
db #23,#03,#f3,#03,#03,#13,#03,#a3
db #a3,#53,#73,#a3,#a3,#03,#03,#03 ;.Ss.....
db #03,#03,#03,#03,#03,#03,#03,#03
db #03,#03,#03,#03,#a3,#53,#53,#03 ;.....SS.
db #a3,#03,#03,#03,#03,#03,#03,#a3
db #a3,#53,#53,#03,#03,#03,#03,#03 ;.SS.....
db #03,#03,#03,#03,#03,#03,#03,#f3
db #53,#a3,#f3,#03,#f3,#03,#53,#2b ;S.....S.
db #03,#3f,#03,#3f,#2b,#3f,#3f,#53 ;.......S
db #f3,#f3,#53,#53,#03,#03,#8b,#8b ;..SS....
db #17,#03,#3f,#9f,#3f,#3f,#3f
lab66E0 db #0
db #00,#00,#10,#00,#34,#10,#69,#34 ;......i.
db #96,#3c,#41,#00,#20,#20,#00,#00 ;..A.....
db #00,#20,#00,#38,#00,#82,#00,#41 ;.......A
db #00,#69,#96,#00,#10,#10,#00,#00 ;.i......
db #00,#00,#00,#00,#00,#00,#00,#00
db #10,#00,#34,#30,#69,#41,#00,#00 ;....iA..
db #00,#00,#00,#10,#20,#34,#3c,#3c
db #82,#61,#c3,#00,#10,#10,#00,#00 ;.a......
db #00,#20,#00,#38,#00,#82,#00,#c3
db #00,#41,#96,#20,#82,#10,#00,#00 ;.A......
db #00,#00,#10,#00,#34,#10,#3c,#34
db #28,#38,#20,#00,#41,#41,#00,#00 ;....AA..
db #30,#10,#3c,#34,#c3,#69,#28,#96 ;.....i..
db #c3,#00,#20,#20,#00,#00,#41,#00 ;......A.
db #00,#20,#00,#00,#00,#00,#10,#82
db #34,#c3,#28,#82,#10,#10,#00,#14
db #3c,#3c,#3c,#69,#c3,#69,#c3,#69 ;...i.i.i
db #c3,#69,#c3,#69,#c3,#69,#c3,#3c ;.i.i.i..
db #28,#3c,#3d,#c3,#97,#c3,#97,#c3
db #97,#c3,#97,#c3,#97,#c3,#97,#77 ;.......w
db #bb,#3b,#bb,#2a,#bb,#2a,#ff,#2a
db #ff,#2a,#ff,#2a,#bb,#2a,#bb,#3f
db #3f,#3f,#3f,#3f,#3f,#22,#00,#ff
db #ff,#33,#ff,#3f,#77,#3f,#55,#3f ;....w.U.
db #55,#3f,#55,#3f,#55,#00,#ff,#ff ;U.U.U...
db #ff,#bb,#33,#37,#3f,#37,#3f,#ff
db #bb,#77,#37,#7f,#37,#55,#37,#ff ;.w...U..
db #37,#ff,#37,#77,#37,#55,#37,#00 ;...w.U..
db #00,#aa,#00,#aa,#00,#7f,#00,#aa
db #00,#7f,#00,#7f,#00,#3f,#aa,#00
db #00,#00,#82,#41,#41,#00,#82,#41 ;...AA..A
db #00,#00,#82,#41,#00,#00,#82,#86 ;...A....
db #08,#c9,#44,#4c,#cc,#0c,#0c,#86 ;..DL....
db #08,#c9,#44,#4c,#cc,#0c,#0c,#22 ;..DL....
db #11,#00,#00,#00,#00,#00,#82,#00
db #82,#41,#82,#c3,#82,#00,#00,#3f ;.A......
db #97,#3f,#97,#3f,#97,#3f,#97,#3f
db #97,#3f,#97,#3f,#97,#3f,#97,#33
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#33,#33,#33,#33,#33,#33,#00
db #00,#00,#00,#00,#00,#00,#11,#00
db #72,#11,#b5,#50,#7a,#72,#3b,#00 ;r..Pzr..
db #11,#00,#33,#11,#72,#33,#b1,#72 ;....r..r
db #f0,#f0,#72,#f0,#f0,#72,#72,#f0 ;..r..rr.
db #22,#b1,#7a,#37,#f0,#37,#b1,#72 ;..z....r
db #f0,#f0,#72,#f0,#f0,#72,#b1,#72 ;..r..r.r
db #b5,#f0,#7a,#b5,#f0,#7a,#b1,#7a ;..z..z.z
db #f0,#7a,#72,#b5,#b1,#72,#f0,#00 ;.zr..r..
db #50,#00,#50,#00,#72,#00,#33,#50 ;P.P.r..P
db #fa,#50,#33,#f0,#72,#f5,#b1,#82 ;.P..r...
db #00,#82,#00,#c1,#00,#6b,#00,#95 ;.....k..
db #82,#95,#82,#ea,#6b,#c1,#c1,#ff ;....k...
db #5f,#ff,#5f,#aa,#5f,#aa,#5f,#aa
db #5f,#00,#5f,#00,#5f,#00,#5f,#00
db #55,#00,#55,#00,#ff,#15,#3f,#00 ;U.U.....
db #ff,#00,#ff,#15,#3f,#ff,#ff,#cc
db #cc,#c8,#0f,#c8,#c0,#8d,#4a,#c8 ;......J.
db #0f,#c8,#c0,#8d,#4a,#8d,#0f,#3c ;....J...
db #3c,#c3,#c5,#c0,#c5,#c3,#c7,#c3
db #c5,#c0,#c5,#c3,#c7,#c3,#c7,#bb
db #77,#37,#2a,#37,#2a,#37,#2a,#37 ;w.......
db #2a,#37,#2a,#37,#2a,#37,#2a,#bb
db #33,#37,#3f,#37,#3f,#37,#3f,#37
db #3f,#37,#3f,#37,#3f,#aa,#00,#33
db #77,#3f,#2a,#3f,#2a,#3f,#2a,#3f ;w.......
db #2a,#3f,#2a,#3f,#2a,#00,#55,#bb ;......U.
db #77,#37,#2a,#37,#2a,#37,#2a,#37 ;w.......
db #2a,#37,#2a,#37,#2a,#aa,#55,#f3 ;......U.
db #f3,#e7,#cf,#e7,#cf,#e7,#cf,#e7
db #cf,#e7,#cf,#e7,#cf,#e7,#cf,#f3
db #f3,#cf,#cf,#cf,#cf,#9a,#c7,#cb
db #45,#cf,#cf,#cf,#cf,#cf,#cf,#f3 ;E.......
db #f3,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#f3
db #f3,#cf,#8a,#cf,#8a,#cf,#8a,#cf
db #8a,#cf,#8a,#cf,#8a,#cf,#8a,#00
db #aa,#00,#00,#00,#00,#00,#0a,#45 ;.......E
db #aa,#aa,#8a,#05,#eb,#00,#aa,#8a
db #00,#00,#82,#45,#55,#45,#0a,#82 ;...EUE..
db #ef,#82,#aa,#d7,#00,#ef,#00
lab6960 db #82
db #00,#14,#41,#10,#00,#14,#00,#00 ;..A.....
db #00,#00,#28,#00,#14,#20,#41,#00 ;......A.
db #20,#82,#20,#00,#20,#00,#00,#20
db #00,#00,#82,#50,#00,#00,#10,#28 ;...P....
db #00,#41,#41,#00,#00,#41,#a0,#10 ;.AA..A..
db #00,#14,#10,#a0,#00,#00,#20,#00
db #14,#41,#00,#00,#a0,#00,#20,#00 ;.A......
db #20,#28,#00,#00,#00,#14,#10,#00
db #00,#82,#20,#00,#00,#20,#82,#00
db #00,#14,#20,#10,#14,#69,#00,#82 ;.....i..
db #00,#00,#50,#10,#00,#00,#00,#00 ;..P.....
db #20,#41,#20,#20,#20,#00,#50,#38 ;.A....P.
db #00,#14,#10,#00,#00,#00,#20,#00
db #00,#20,#82,#82,#00,#14,#10,#00
db #61,#a0,#00,#00,#00,#50,#41,#82 ;a....PA.
db #00,#00,#00,#50,#20,#00,#61,#69 ;...P..ai
db #c3,#69,#c3,#69,#c3,#69,#c3,#69 ;.i.i.i.i
db #c3,#69,#c3,#3f,#3f,#15,#3f,#c3 ;.i......
db #97,#c3,#97,#c3,#97,#c3,#97,#c3
db #97,#c3,#97,#3f,#3f,#3f,#2a,#2a
db #bb,#2a,#bb,#2a,#bb,#2a,#bb,#2a
db #ff,#55,#77,#bb,#2a,#37,#2a,#3f ;.Uw.....
db #55,#3f,#55,#3f,#55,#2a,#ff,#55 ;U.U.U..U
db #33,#bb,#3f,#bb,#3f,#bb,#3f,#37
db #3f,#37,#3f,#37,#3f,#aa,#00,#77 ;.......w
db #ff,#3b,#ff,#2a,#bb,#2a,#ff,#55 ;.......U
db #37,#55,#37,#55,#37,#ff,#37,#ff ;.U.U....
db #37,#33,#aa,#3f,#55,#00,#ff,#aa ;....U...
db #00,#7f,#00,#2a,#00,#00,#00,#ff
db #00,#3f,#aa,#7f,#00,#2a,#00,#41 ;.......A
db #00,#00,#82,#41,#00,#00,#82,#41 ;...A...A
db #00,#00,#82,#41,#00,#00,#82,#11 ;...A....
db #33,#11,#66,#11,#0c,#11,#26,#33 ;..f.....
db #26,#33,#4c,#33,#26,#33,#19,#0f ;..L.....
db #0a,#8d,#0a,#8d,#0a,#0f,#0a,#cc
db #0f,#cc,#0f,#8d,#0f,#4e,#0f,#3f ;.....N..
db #bf,#37,#bf,#37,#7f,#33,#7f,#33
db #3f,#33,#37,#33,#37,#33,#33,#b1
db #f0,#b1,#f0,#b1,#f0,#b1,#f0,#b1
db #f0,#b1,#f0,#b1,#f0,#b1,#f0,#b1
db #7a,#62,#37,#11,#72,#00,#91,#00 ;zb..r...
db #11,#00,#00,#00,#00,#00,#00,#b1
db #72,#33,#b1,#33,#33,#b1,#62,#d0 ;r.....b.
db #91,#33,#72,#40,#62,#00,#11,#33 ;..r.b...
db #72,#72,#33,#b1,#b1,#33,#72,#62 ;rr....rb
db #b5,#33,#b5,#d0,#3b,#22,#62,#72 ;......br
db #f0,#b1,#b1,#f0,#72,#f0,#f0,#33 ;....r...
db #f0,#72,#33,#33,#62,#91,#72,#72 ;.r..b.rr
db #d2,#e0,#62,#33,#f5,#f5,#91,#33 ;..b.....
db #63,#72,#62,#b1,#33,#e0,#b1,#d5 ;crb.....
db #c1,#ea,#c0,#62,#ea,#62,#c0,#c0 ;...b.b..
db #d5,#c0,#c0,#bb,#ea,#c0,#c1,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#00
db #ff,#00,#15,#00,#3f,#55,#15,#00 ;.....U..
db #55,#55,#3f,#00,#ff,#00,#55,#69 ;UU....Ui
db #c3,#29,#83,#69,#4b,#69,#4b,#29 ;...iKiK.
db #83,#ef,#c3,#ef,#c3,#ff,#cf,#0f
db #4f,#5e,#4f,#ad,#ed,#0f,#4f,#5e ;O.O...O.
db #4f,#ad,#df,#0f,#df,#cf,#ff,#37 ;O.......
db #2a,#37,#2a,#37,#2a,#37,#2a,#37
db #2a,#37,#2a,#37,#2a,#aa,#55,#d0 ;......U.
db #f0,#c0,#e0,#55,#eb,#00,#f5,#00 ;...U....
db #e0,#c0,#e0,#94,#e0,#c0,#e0,#c0
db #eb,#d5,#eb,#c3,#82,#ff,#00,#d5
db #00,#d5,#d7,#ff,#55,#ff,#d7,#33 ;....U...
db #33,#33,#22,#33,#00,#22,#00,#22
db #00,#00,#00,#00,#00,#00,#00,#33
db #33,#11,#33,#00,#33,#00,#11,#00
db #11,#00,#00,#00,#00,#00,#00,#e7
db #cf,#e7,#cf,#e7,#cf,#e7,#61,#e7 ;......a.
db #82,#e7,#cf,#e7,#cf,#e7,#cf,#cf
db #8a,#cf,#8a,#cf,#8a,#61,#8a,#82 ;.....a..
db #8a,#cf,#8a,#cf,#8a,#cf,#8a,#2f
db #55,#55,#15,#00,#bf,#00,#00,#2a ;UU......
db #00,#05,#00,#2a,#ff,#00,#05,#00
db #ff,#00,#ff,#00,#ff,#aa,#5f,#55 ;.......U
db #ff,#55,#ff,#05,#ff,#aa,#ff,#82 ;.U......
db #8a,#cb,#55,#45,#0a,#55,#41,#d7 ;..UE.UA.
db #82,#eb,#00,#82,#55,#aa,#eb ;....U..
lab6BE0 db #0
db #0a,#00,#88,#05,#cc,#00,#88,#0a
db #0c,#4e,#0c,#44,#48,#00,#d0,#0a ;.N.DH...
db #00,#05,#00,#44,#05,#44,#44,#8c ;...D.DD.
db #44,#0c,#0c,#c0,#08,#e0,#80,#00 ;D.......
db #05,#05,#44,#05,#04,#44,#88,#44 ;..D..D.D
db #08,#0e,#0c,#0e,#48,#04,#c0,#05 ;....H...
db #05,#05,#05,#04,#05,#00,#0c,#0c
db #0d,#0c,#08,#d0,#80,#c0,#08,#2f
db #0f,#d5,#ff,#2f,#0f,#d5,#ff,#85
db #af,#2f,#0f,#c1,#c3,#c3,#c3,#3f
db #3f,#3f,#3f,#ff,#0f,#ff,#ff,#0f
db #0f,#ff,#af,#0f,#ff,#0f,#5f,#af
db #0f,#ff,#5f,#0f,#ff,#af,#0f,#5f
db #ff,#0f,#0f,#c3,#c3,#c3,#c3,#00
db #15,#00,#3f,#00,#85,#15,#5f,#40
db #af,#2f,#0f,#d5,#ff,#2f,#0f,#3c
db #3c,#3c,#3c,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#c3,#c3,#c3,#c3,#c3
db #c3,#c3,#c3,#3f,#3f,#3f,#3f,#37
db #2a,#37,#2a,#37,#2a,#37,#2a,#37
db #2a,#37,#2a,#aa,#55,#ff,#ff,#bb ;....U...
db #3f,#bb,#3f,#bb,#3f,#bb,#3f,#ff
db #00,#ff,#ff,#bb,#33,#37,#3f,#2a
db #ff,#2a,#ff,#2a,#bb,#2a,#bb,#55 ;.......U
db #bb,#ff,#bb,#33,#ff,#3f,#77,#ff ;......w.
db #ff,#33,#ff,#3f,#77,#3f,#55,#3f ;....w.U.
db #55,#3f,#55,#00,#ff,#ff,#ff,#00 ;U.U.....
db #00,#aa,#00,#ff,#55,#ff,#ff,#bf ;....U...
db #7f,#3f,#3f,#15,#3b,#15,#77,#0f ;......w.
db #0f,#0c,#0c,#cc,#cc,#0f,#0f,#0f
db #0f,#0f,#0f,#00,#00,#c3,#c3,#84
db #5d,#48,#ae,#0c,#0c,#0c,#dd,#84 ;.H......
db #ae,#48,#4c,#0c,#0c,#0c,#4c,#ee ;.HL...L.
db #0d,#dd,#0f,#4c,#cc,#cc,#cc,#ee ;...L....
db #0d,#dd,#0f,#cc,#8d,#4c,#8c,#26 ;.....L..
db #33,#26,#33,#26,#33,#5d,#1b,#5d
db #1b,#5d,#1b,#5d,#1b,#5d,#1b,#33
db #33,#00,#00,#ff,#ff,#ff,#ff,#55 ;.......U
db #ff,#55,#ff,#55,#ff,#55,#ff,#00 ;.U.U.U..
db #00,#00,#00,#00,#00,#00,#50,#a0 ;......P.
db #50,#a0,#f0,#72,#b1,#b1,#f0,#b1 ;P..r....
db #72,#72,#33,#33,#62,#b1,#c0,#80 ;rr..b...
db #50,#00,#11,#00,#00,#00,#00,#00 ;P.......
db #00,#00,#00,#00,#00,#11,#22,#37
db #7a,#7a,#f0,#f0,#b1,#b1,#f0,#b1 ;zz......
db #72,#72,#22,#62,#11,#80,#40,#00 ;rr.b....
db #00,#00,#00,#00,#00,#00,#00,#ff
db #7f,#bf,#bf,#7f,#ff,#ff,#7f,#ff
db #ff,#7f,#bf,#ff,#7f,#7f,#bf,#62 ;.......b
db #91,#c0,#77,#77,#62,#c2,#33,#eb ;..wwb...
db #c1,#d7,#eb,#ff,#d7,#ff,#ff,#c0
db #c0,#c0,#c0,#ea,#62,#91,#ea,#62 ;....b..b
db #91,#93,#c1,#eb,#eb,#ff,#d7,#80
db #3f,#ea,#3f,#ff,#00,#ff,#ff,#63 ;.......c
db #d7,#2a,#55,#00,#41,#00,#00,#69 ;..U.A..i
db #c3,#69,#e1,#78,#d2,#69,#c3,#69 ;.i.x.i.i
db #e1,#ef,#d2,#ef,#c3,#ff,#cf,#0f
db #4f,#1a,#4f,#30,#65,#1a,#4f,#1a ;O.O.e.O.
db #4f,#1a,#df,#0f,#df,#cf,#ff,#fb ;O.......
db #f3,#cf,#cf,#ff,#cf,#6f,#cf,#ff ;.....o..
db #cf,#3f,#cf,#6f,#cf,#3f,#ff,#00 ;...o....
db #e0,#00,#e0,#00,#e0,#00,#e0,#00
db #e0,#00,#50,#00,#50,#00,#50,#eb ;..P.P.P.
db #00,#eb,#00,#eb,#00,#eb,#00,#eb
db #00,#aa,#00,#aa,#00,#82,#00,#3f
db #3f,#3f,#2a,#3f,#00,#2a,#00,#2a
db #00,#00,#00,#00,#00,#00,#00,#3f
db #3f,#15,#3f,#00,#3f,#00,#15,#00
db #15,#00,#00,#00,#00,#00,#00,#e7
db #cf,#e7,#cf,#e7,#cf,#e7,#cf,#e7
db #cf,#e7,#cf,#e7,#cf,#e7,#cf,#cf
db #8a,#cf,#8a,#cf,#8a,#cf,#8a,#cf
db #8a,#cf,#8a,#cf,#8a,#cf,#8a,#82
db #00,#00,#00,#00,#41,#00,#8a,#45 ;....A..E
db #00,#45,#00,#8a,#41,#8a,#82,#df ;.E..A...
db #55,#05,#00,#00,#aa,#00,#55,#aa ;U.....U.
db #00,#00,#00,#0a,#55,#55,#aa,#82 ;....UU..
db #00,#00,#82,#41,#55,#45,#0a,#8a ;...AUE..
db #ef,#00,#aa,#00,#00,#c7,#00,#00
db #00,#aa,#00,#ff,#00,#eb,#00,#d7
db #82,#eb,#82,#d7,#c3,#6b,#eb,#3f ;.....k..
db #3f,#95,#3f,#2f,#0f,#d5,#ff,#2f
db #0f,#2f,#0f,#d5,#af,#2f,#5f,#3f
db #3f,#3f,#3f,#af,#0f,#ba,#7d,#1e
db #05,#0f,#ff,#5f,#ff,#af,#0f,#3f
db #3f,#3f,#3f,#ff,#af,#af,#5f,#5f
db #af,#af,#0f,#ff,#ff,#0f,#0f,#3f
db #3f,#3f,#6b,#af,#4b,#ff,#aa,#0f ;..k.K...
db #4b,#0f,#aa,#ff,#4b,#0f,#4b,#2a ;K...K.K.
db #00,#6b,#00,#af,#82,#5f,#00,#ff ;.k......
db #aa,#0f,#4b,#af,#aa,#ff,#aa,#05 ;..K.....
db #0f,#00,#0f,#00,#05,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#00
db #00,#00,#00,#00,#00,#00,#00,#0f
db #0f,#0f,#0f,#05,#0f,#0a,#0f,#0f
db #00,#0f,#00,#0f,#00,#0f,#00,#00
db #00,#0a,#00,#0a,#00,#0a,#00,#0f
db #00,#0f,#00,#0f,#00,#0f,#00,#2a
db #dd,#88,#57,#02,#13,#02,#8b,#8b ;..W.....
db #ab,#ab,#ab,#67,#03,#3f,#8b,#ff ;...g....
db #dd,#99,#df,#9f,#df,#9f,#df,#6f ;.......o
db #55,#9f,#55,#8a,#ff,#df,#ff,#11 ;U.U.....
db #33,#1b,#00,#1b,#55,#1b,#55,#1b ;....U.U.
db #55,#1b,#55,#1b,#55,#1b,#55,#33 ;U.U.U.U.
db #33,#00,#00,#ff,#ff,#33,#33,#aa
db #11,#ff,#bb,#ff,#bb,#33,#bb,#33
db #33,#00,#41,#ff,#eb,#ff,#eb,#55 ;..A....U
db #eb,#55,#eb,#55,#eb,#55,#eb,#00 ;.U.U.U..
db #00,#c3,#00,#41,#c3,#14,#82,#00 ;...A....
db #69,#00,#69,#00,#14,#00,#14,#00 ;i.i.....
db #00,#00,#00,#c3,#c3,#00,#00,#cf
db #cf,#c3,#c3,#3c,#3c,#c3,#c3,#00
db #41,#00,#82,#82,#00,#00,#00,#00 ;A.......
db #00,#00,#00,#00,#00,#82,#00,#ff
db #bb,#77,#77,#34,#87,#34,#93,#34 ;.ww.....
db #93,#c3,#93,#27,#27,#77,#33,#1b ;.....w..
db #33,#1b,#33,#33,#33,#33,#33,#33
db #33,#33,#33,#27,#33,#1b,#33,#80
db #00,#e0,#00,#33,#80,#62,#e0,#b1 ;.....b..
db #c0,#62,#e0,#f0,#d0,#72,#33,#00 ;.b...r..
db #00,#00,#00,#00,#00,#a0,#00,#62 ;.......b
db #00,#d2,#80,#e1,#22,#72,#c2,#f0 ;.....r..
db #f0,#f0,#3f,#37,#f0,#7a,#f0,#b1 ;.....z..
db #f0,#72,#b1,#b1,#37,#72,#3b,#00 ;.r...r..
db #00,#a0,#50,#00,#f0,#b5,#f0,#72 ;..P....r
db #b1,#7a,#72,#3b,#b1,#33,#33,#d7 ;.zr.....
db #eb,#ff,#bf,#eb,#eb,#ff,#bf,#d7
db #d7,#ff,#7f,#eb,#eb,#ff,#bf,#00
db #5f,#00,#5f,#00,#5f,#00,#5f,#00
db #5f,#00,#5f,#00,#5f,#00,#5f,#33
db #33,#33,#33,#33,#33,#33,#3f,#3f
db #00,#00,#00,#00,#00,#00,#00,#66 ;.......f
db #66,#33,#9b,#33,#9b,#33,#9b,#99 ;f.......
db #cf,#9b,#9b,#67,#33,#67,#33,#33 ;...g.g..
db #33,#33,#33,#26,#33,#26,#33,#5d
db #bb,#0d,#bb,#1b,#1b,#1b,#1b,#19
db #1b,#33,#af,#33,#77,#33,#33,#33 ;....w...
db #33,#33,#33,#26,#26,#33,#19,#f3
db #b7,#cf,#7f,#cf,#9f,#cf,#bf,#cf
db #3f,#9f,#bf,#7f,#ff,#df,#7f,#33
db #33,#ff,#33,#00,#ff,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#33
db #33,#33,#33,#33,#33,#ff,#33,#00
db #ff,#00,#00,#00,#00,#00,#00,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#6f ;.......o
db #cf,#bf,#cf,#6f,#cf,#7f,#cf,#7f ;...o....
db #cf,#7f,#cf,#3f,#ef,#7f,#7f,#cf
db #cf,#cf,#9f,#cf,#9f,#cf,#bf,#df
db #bf,#cf,#9f,#df,#3f,#ff,#3f,#cf
db #cf,#cf,#cf,#cf,#cf,#9a,#c7,#cb
db #45,#cf,#cf,#cf,#cf,#cf,#cf,#00 ;E.......
db #00,#00,#05,#00,#5f,#00,#ff,#05
db #ff,#55,#bf,#5f,#3f,#bf,#6f,#ff ;.U....o.
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#d7
db #ff,#3f,#97,#6b,#6b,#c3,#3f,#00 ;...kk...
db #00,#ff,#55,#ff,#ff,#ff,#ff,#ff ;..U.....
db #ff,#d7,#7f,#6b,#6b,#3f,#3f,#ff ;...kk...
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#eb,#ff,#00
db #00,#ff,#00,#ff,#55,#ff,#ff,#ff ;....U...
db #ff,#ff,#ff,#3f,#ff,#3f,#3f,#0f
db #0f,#ff,#af,#ba,#d7,#4b,#05,#ff ;.....K..
db #ff,#0f,#0f,#c3,#c3,#c3,#c3,#5f
db #0f,#5f,#ff,#af,#0f,#0f,#0f,#ff
db #ff,#0f,#5f,#c3,#c3,#c3,#c3,#af
db #4b,#ff,#aa,#0f,#4b,#ff,#aa,#af ;K...K...
db #4b,#0f,#4b,#c3,#c3,#c3,#c3,#0f ;K.K.....
db #00,#0f,#00,#0a,#00,#0a,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #14,#14,#3c,#05,#c3,#14,#c3,#41 ;.......A
db #c3,#69,#c3,#05,#c3,#00,#4b,#69 ;.i....Ki
db #c3,#0f,#c3,#69,#c3,#0f,#4b,#00 ;...i..K.
db #41,#69,#c3,#0f,#1f,#00,#05,#05 ;Ai......
db #00,#05,#00,#0a,#00,#0a,#00,#0f
db #00,#0f,#00,#0f,#00,#0f,#00,#0f
db #00,#0f,#00,#0f,#00,#0f,#00,#0f
db #00,#0f,#00,#0f,#00,#0f,#00,#9d
db #01,#2b,#01,#2b,#01,#00,#03,#ff
db #ab,#ee,#23,#37,#03,#37,#2b,#ef
db #bb,#67,#37,#df,#66,#df,#67,#df ;.g..f.g.
db #9f,#df,#9f,#df,#9f,#cf,#37,#b0
db #38,#b0,#38,#b0,#38,#b0,#38,#b0
db #38,#b0,#38,#b0,#38,#b0,#38,#3d
db #69,#3d,#69,#3d,#69,#3d,#69,#3d ;i.i.i.i.
db #69,#3d,#69,#3d,#69,#3d,#69,#6b ;i.i.i.ik
db #4f,#6b,#4f,#6b,#4f,#6b,#4f,#6b ;OkOkOkOk
db #4f,#6b,#4f,#6b,#4f,#6b,#4f,#1b ;OkOkOkO.
db #55,#1b,#55,#1b,#55,#1b,#55,#1b ;U.U.U.U.
db #55,#1b,#55,#1b,#c3,#0f,#0f,#22 ;U.U.....
db #11,#22,#bb,#22,#bb,#33,#33,#aa
db #00,#ff,#ff,#c3,#c3,#0f,#0f,#55 ;.......U
db #ff,#55,#ff,#55,#ff,#55,#ff,#55 ;.U.U.U.U
db #ff,#ff,#ff,#c3,#c3,#0f,#0f,#55 ;.......U
db #eb,#55,#eb,#55,#eb,#55,#eb,#55 ;.U.U.U.U
db #eb,#ff,#eb,#c3,#c3,#0f,#0a,#33
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#33,#3f,#3f,#00,#00,#00,#f0
db #f0,#72,#b1,#b1,#d0,#91,#62,#33 ;.r....b.
db #91,#33,#22,#c0,#00,#22,#00,#b1
db #e0,#33,#80,#a5,#80,#4a,#00,#22 ;.....J..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#11,#72 ;.......r
db #33,#b1,#d0,#d0,#b1,#72,#72,#33 ;.....rr.
db #00,#22,#05,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#3b
db #33,#3f,#33,#1f,#3b,#05,#3b,#05
db #3b,#05,#3b,#05,#3b,#05,#3b,#00
db #00,#00,#00,#00,#00,#41,#00,#41 ;.....A.A
db #82,#41,#c3,#41,#c3,#15,#3f,#05 ;.A.A....
db #3b,#05,#3b,#05,#3b,#05,#3b,#05
db #3b,#87,#3b,#c3,#3b,#3f,#3b,#33
db #33,#33,#3f,#3f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#51 ;.......Q
db #e7,#51,#8b,#f3,#57,#f3,#bb,#f3 ;.Q..W...
db #62,#f3,#62,#a3,#03,#01,#cf,#cf ;b.b.....
db #8a,#cf,#8a,#ef,#cf,#ff,#cf,#ff
db #cf,#ff,#cf,#cf,#cf,#cf,#8a,#33
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#ff,#33,#00,#ff,#00,#00,#33
db #33,#33,#33,#33,#33,#33,#33,#33
db #33,#33,#33,#33,#33,#ff,#ff,#00
db #05,#0a,#ff,#00,#05,#0f,#0f,#ff
db #ff,#0f,#5f,#c3,#c3,#c3,#c3,#00
db #03,#00,#45,#00,#01,#00,#01,#00 ;..E.....
db #01,#00,#01,#00,#01,#00,#a3,#cf
db #00,#00,#00,#82,#00,#8a,#00,#8a
db #00,#8a,#00,#8a,#00,#cf,#00,#00
db #10,#00,#14,#00,#30,#00,#20,#10
db #3c,#30,#50,#a0,#a0,#3c,#3c,#3c ;..P.....
db #3c,#c3,#c3,#3c,#3c,#00,#00,#3c
db #3c,#00,#00,#00,#00,#3c,#3c,#00
db #82,#00,#82,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #30,#14,#c3,#00,#82,#00,#28,#14
db #80,#50,#20,#14,#80,#50,#20,#14 ;.P...P..
db #80,#50,#20,#14,#80,#50,#20,#ff ;.P...P..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #3f,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#14
db #20,#14,#20,#14,#20,#14,#20,#14
db #20,#14,#20,#14,#20,#14,#20,#00
db #10,#00,#10,#00,#10,#00,#10,#00
db #10,#00,#32,#11,#38,#36,#92,#28
db #00,#28,#00,#28,#00,#28,#00,#28
db #00,#69,#00,#69,#82,#69,#69,#34 ;.i.i.ii.
db #00,#34,#00,#34,#00,#34,#10,#34
db #10,#34,#38,#41,#38,#00,#92,#00 ;...A....
db #69,#00,#69,#00,#69,#28,#69,#28 ;i.i.i.i.
db #69,#69,#c3,#69,#82,#69,#00,#b0 ;ii.i.i..
db #38,#b0,#38,#b0,#38,#b0,#38,#b0
db #38,#b0,#38,#b0,#38,#b0,#38,#3d
db #69,#3d,#69,#3d,#69,#3d,#69,#3d ;i.i.i.i.
db #69,#3d,#69,#3d,#69,#3d,#69,#6b ;i.i.i.ik
db #4f,#6b,#4f,#6b,#4f,#6b,#4f,#6b ;OkOkOkOk
db #4f,#6b,#4f,#6b,#4f,#6b,#4f,#00 ;OkOkOkO.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#50,#a0,#b0,#2d,#b0,#2d,#b0 ;.P......
db #2d,#b0,#2d,#b0,#2d,#b0,#2d,#b0
db #2d,#b0,#2d,#b0,#2d,#b0,#2d,#00
db #00,#00,#00,#00,#00,#00,#50,#00 ;......P.
db #e0,#00,#26,#50,#49,#26,#92,#00 ;...PI...
db #00,#00,#00,#f0,#c0,#a4,#c3,#49 ;.......I
db #69,#49,#69,#97,#28,#3d,#41,#00 ;iIi...A.
db #00,#00,#00,#2a,#00,#6b,#00,#2a ;.....k..
db #0a,#2a,#0a,#41,#4f,#6b,#45,#05 ;...AOkE.
db #1a,#00,#0f,#00,#05,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#3d
db #69,#1f,#69,#0f,#69,#0f,#c3,#05 ;i.i.i...
db #4b,#00,#00,#00,#00,#00,#00,#6b ;K......k
db #00,#2a,#4f,#6b,#4f,#6b,#0a,#6b ;..OkOk.k
db #00,#00,#00,#00,#00,#00,#00,#00
db #11,#00,#11,#00,#11,#00,#11,#00
db #26,#00,#26,#00,#33,#00,#26,#0a
db #00,#0a,#00,#0a,#00,#0a,#00,#0f
db #00,#0f,#00,#8d,#00,#0f,#00,#00
db #44,#0a,#45,#8a,#8a,#45,#00,#45 ;D.E..E.E
db #00,#45,#00,#4f,#00,#cf,#00,#45 ;.E.O...E
db #00,#45,#44,#00,#8a,#0a,#8a,#8a ;.ED.....
db #cf,#45,#8a,#00,#8a,#00,#8a,#33 ;.E......
db #d5,#91,#91,#40,#80,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#33
db #33,#33,#33,#26,#33,#26,#33,#5d
db #1b,#5d,#1b,#5d,#1b,#19,#1b,#82
db #00,#82,#00,#82,#00,#00,#00,#c3
db #00,#00,#00,#00,#82,#c3,#41,#f0 ;......A.
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0
lab7500 db #0
db #00,#00,#00,#00,#00,#00,#00,#f0
db #a5,#00,#00,#00,#50,#33,#72,#0a ;....P.r.
db #00,#00,#b1,#33,#cc,#85,#00,#00
db #b1,#62,#4c,#8d,#00,#50,#33,#84 ;.bL..P..
db #0c,#cc,#0a,#b1,#c0,#04,#08,#cc
db #8d,#e0,#00,#2c,#08,#00,#8d,#e0
db #14,#2c,#08,#3c,#8d,#e0,#05,#2c
db #08,#b4,#8d,#e0,#14,#2c,#08,#3c
db #8d,#e0,#80,#2c,#08,#6c,#8d,#e0 ;.....l..
db #c0,#2c,#08,#cc,#8d,#50,#c0,#84 ;.....P..
db #0c,#cc,#0a,#50,#c0,#80,#04,#4c ;...P...L
db #0a,#50,#80,#84,#0c,#44,#0a,#00 ;.P...D..
db #e0,#04,#08,#8d,#00,#00,#e0,#00
db #00,#8d,#00,#00,#e0,#14,#3c,#8d
db #00,#00,#50,#15,#3e,#0a,#00,#00 ;..P.....
db #50,#80,#6c,#0a,#00,#00,#50,#c0 ;P.l...P.
db #c4,#0a,#00,#00,#00,#e0,#8d,#00
db #00,#00,#00,#05,#0a,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#f0
db #a5,#00,#00,#00,#50,#33,#72,#0a ;....P.r.
db #00,#00,#b1,#33,#cc,#85,#00,#00
db #b1,#62,#4c,#8d,#00,#50,#33,#84 ;.bL..P..
db #0c,#cc,#0a,#b1,#c0,#04,#08,#cc
db #8d,#e0,#00,#2c,#08,#00,#8d,#e0
db #14,#2c,#08,#3c,#8d,#e0,#44,#2c ;......D.
db #08,#9c,#8d,#e0,#14,#2c,#08,#3c
db #8d,#e0,#80,#2c,#08,#6c,#8d,#e0 ;.....l..
db #c0,#2c,#08,#cc,#8d,#50,#c0,#84 ;.....P..
db #0c,#cc,#0a,#50,#c0,#80,#04,#4c ;...P...L
db #0a,#50,#80,#84,#0c,#44,#0a,#00 ;.P...D..
db #e0,#04,#08,#8d,#00,#00,#e0,#00
db #00,#8d,#00,#00,#e0,#15,#3e,#8d
db #00,#00,#50,#80,#2c,#0a,#00,#00 ;..P.....
db #50,#c0,#c4,#0a,#00,#00,#00,#c0 ;P.......
db #cc,#00,#00,#00,#00,#05,#0a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#f0
db #a5,#00,#00,#00,#50,#33,#72,#0a ;....P.r.
db #00,#00,#b1,#33,#cc,#85,#00,#00
db #b1,#62,#4c,#8d,#00,#50,#33,#84 ;.bL..P..
db #0c,#cc,#0a,#b1,#c0,#04,#08,#cc
db #8d,#e0,#00,#2c,#08,#00,#8d,#e0
db #14,#2c,#08,#3c,#8d,#e0,#50,#2c ;......P.
db #08,#1e,#8d,#e0,#14,#2c,#08,#3c
db #8d,#e0,#80,#2c,#08,#6c,#8d,#e0 ;.....l..
db #c0,#2c,#08,#cc,#8d,#50,#c0,#84 ;.....P..
db #0c,#cc,#0a,#50,#c0,#80,#04,#cc ;...P....
db #0a,#50,#80,#84,#0c,#44,#0a,#00 ;.P...D..
db #a0,#04,#08,#05,#00,#00,#e0,#00
db #00,#8d,#00,#00,#40,#14,#3c,#88
db #00,#00,#50,#80,#04,#0a,#00,#00 ;..P.....
db #00,#c0,#cc,#00,#00,#00,#00,#05
db #0a,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#f0
db #a5,#00,#00,#00,#50,#33,#72,#0a ;....P.r.
db #00,#00,#b1,#33,#cc,#85,#00,#00
db #b1,#62,#4c,#8d,#00,#50,#33,#84 ;.bL..P..
db #0c,#cc,#0a,#b1,#c0,#04,#08,#cc
db #8d,#e0,#00,#2c,#08,#00,#8d,#e0
db #14,#2c,#08,#3c,#8d,#e0,#45,#2c ;......E.
db #08,#9e,#8d,#e0,#14,#2c,#08,#3c
db #8d,#e0,#80,#2c,#08,#6c,#8d,#e0 ;.....l..
db #c0,#2c,#08,#cc,#8d,#50,#c0,#84 ;.....P..
db #0c,#cc,#0a,#50,#c0,#80,#04,#4c ;...P...L
db #0a,#50,#80,#84,#0c,#44,#0a,#00 ;.P...D..
db #e0,#04,#08,#8d,#00,#00,#e0,#00
db #00,#8d,#00,#00,#e0,#15,#3e,#8d
db #00,#00,#50,#80,#2c,#0a,#00,#00 ;..P.....
db #50,#c0,#c4,#0a,#00,#00,#00,#c0 ;P.......
db #cc,#00,#00,#00,#00,#05,#0a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#bd ;......P.
db #3f,#82,#00,#00,#f4,#3f,#3f,#6b ;.......k
db #00,#50,#bd,#3f,#3f,#3f,#82,#54 ;.P.....T
db #bd,#3f,#3f,#3f,#82,#f4,#2a,#3f
db #3f,#3f,#82,#fc,#00,#3f,#3f,#3f
db #c3,#00,#00,#3f,#3f,#3f,#c3,#00
db #08,#3f,#3f,#3f,#c3,#00,#54,#3f ;......T.
db #3f,#6b,#c3,#54,#bd,#3f,#3f,#6b ;.k.T...k
db #c3,#fc,#3f,#2a,#3f,#6b,#82,#fc ;.....k..
db #00,#15,#3f,#6b,#82,#00,#00,#54 ;...k...T
db #3f,#c3,#00,#00,#0a,#bd,#6b,#82 ;......k.
db #00,#05,#5e,#bd,#6b,#00,#00,#00 ;....k...
db #fc,#3f,#6b,#00,#00,#0a,#54,#97 ;..k...T.
db #6b,#00,#a8,#00,#00,#c3,#7e,#00 ;k.......
db #54,#00,#00,#41,#97,#a8,#54,#00 ;T..A..T.
db #00,#00,#c3,#fc,#a8,#00,#00,#00
db #41,#97,#00,#00,#00,#00,#00,#00 ;A.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#bd ;......P.
db #3f,#82,#00,#00,#f4,#3f,#3f,#6b ;.......k
db #00,#50,#bd,#3f,#3f,#3f,#82,#54 ;.P.....T
db #bd,#3f,#3f,#3f,#82,#f4,#2a,#3f
db #3f,#3f,#82,#fc,#00,#3f,#3f,#3f
db #c3,#00,#00,#3f,#3f,#3f,#c3,#00
db #08,#3f,#3f,#3f,#6b,#00,#54,#3f ;....k.T.
db #3f,#3f,#6b,#54,#bd,#3f,#3f,#3f ;..kT....
db #c3,#fc,#3f,#2a,#3f,#3f,#c3,#fc
db #00,#15,#3f,#3f,#82,#00,#00,#54 ;.......T
db #3f,#6b,#82,#00,#0a,#bd,#6b,#c3 ;.k....k.
db #00,#05,#54,#bd,#6b,#00,#00,#00 ;..T.k...
db #fc,#3f,#6b,#00,#00,#00,#e9,#3f ;..k.....
db #6b,#00,#00,#00,#41,#97,#7e,#00 ;k...A...
db #00,#00,#00,#c3,#3f,#a8,#00,#00
db #00,#41,#97,#fc,#54,#00,#00,#00 ;.A..T...
db #c3,#97,#a8,#00,#00,#00,#00,#c3
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#bd ;......P.
db #3f,#82,#00,#00,#f4,#3f,#3f,#6b ;.......k
db #00,#50,#bd,#3f,#3f,#3f,#82,#54 ;.P.....T
db #bd,#3f,#3f,#3f,#82,#f4,#2a,#3f
db #3f,#3f,#82,#fc,#00,#3f,#3f,#3f
db #c3,#00,#00,#3f,#3f,#3f,#c3,#40
db #00,#3f,#3f,#3f,#6b,#00,#54,#3f ;....k.T.
db #3f,#3f,#6b,#54,#bd,#3f,#3f,#3f ;..kT....
db #c3,#fc,#3f,#2a,#3f,#3f,#c3,#fc
db #00,#15,#3f,#3f,#c3,#00,#05,#54 ;.......T
db #3f,#6b,#c3,#00,#0a,#bd,#6b,#c3 ;.k....k.
db #82,#00,#54,#bd,#6b,#82,#00,#00 ;..T.k...
db #bd,#3f,#6b,#00,#00,#00,#e9,#3f ;..k.....
db #6b,#00,#00,#00,#c3,#97,#7e,#00 ;k.......
db #00,#00,#00,#c3,#3f,#a8,#00,#00
db #00,#41,#97,#fc,#00,#00,#00,#00 ;.A......
db #c3,#97,#a8,#00,#00,#00,#00,#41 ;.......A
db #c3,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#bd ;......P.
db #3f,#82,#00,#00,#f4,#3f,#3f,#6b ;.......k
db #00,#50,#bd,#3f,#3f,#3f,#82,#54 ;.P.....T
db #bd,#3f,#3f,#3f,#82,#f4,#2a,#3f
db #3f,#3f,#82,#fc,#00,#3f,#3f,#3f
db #c3,#00,#00,#3f,#3f,#3f,#c3,#00
db #08,#3f,#3f,#3f,#6b,#00,#54,#3f ;....k.T.
db #3f,#3f,#6b,#54,#bd,#3f,#3f,#3f ;..kT....
db #c3,#fc,#3f,#2a,#3f,#3f,#c3,#fc
db #00,#15,#3f,#3f,#82,#00,#00,#54 ;.......T
db #3f,#6b,#82,#00,#0a,#bd,#6b,#c3 ;.k....k.
db #00,#05,#54,#bd,#6b,#00,#00,#00 ;..T.k...
db #fc,#3f,#6b,#00,#00,#00,#e9,#3f ;..k.....
db #6b,#00,#00,#00,#41,#97,#7e,#00 ;k...A...
db #00,#00,#00,#c3,#3f,#a8,#00,#00
db #00,#41,#97,#fc,#54,#00,#00,#00 ;.A..T...
db #c3,#97,#a8,#00,#00,#00,#00,#41 ;.......A
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#bd,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #bd,#3f,#3f,#6b,#82,#f4,#a8,#00 ;...k....
db #3f,#3f,#82,#a8,#2a,#00,#3f,#3f
db #c3,#a8,#6e,#00,#3f,#3f,#c3,#a8 ;..n.....
db #2a,#15,#3f,#3f,#c3,#fc,#3f,#3f
db #3f,#6b,#c3,#fc,#bd,#3f,#3f,#6b ;.k.....k
db #c3,#fc,#3f,#3f,#15,#6b,#82,#54 ;.....k.T
db #3f,#00,#3f,#6b,#82,#00,#00,#00 ;...k....
db #3f,#c3,#00,#00,#05,#15,#6b,#82 ;......k.
db #00,#00,#0f,#bd,#6b,#00,#00,#05 ;....k...
db #fc,#3f,#6b,#00,#00,#05,#54,#97 ;..k...T.
db #6b,#00,#00,#00,#00,#c3,#6b,#41 ;k.....kA
db #00,#00,#00,#41,#c3,#82,#82,#00 ;...A....
db #00,#00,#c3,#c3,#00,#00,#00,#00
db #41,#82,#00,#00,#00,#00,#00,#00 ;A.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#bd,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #bd,#3f,#3f,#6b,#82,#f4,#00,#3f ;...k....
db #00,#15,#82,#a8,#00,#3f,#00,#15
db #c3,#a8,#88,#3f,#88,#15,#c3,#bd
db #2a,#3f,#00,#3f,#c3,#bd,#3f,#3f
db #3f,#6b,#c3,#bd,#3f,#3f,#3f,#6b ;.k.....k
db #c3,#bd,#3f,#3f,#3f,#41,#82,#bd ;.....A..
db #15,#00,#00,#c3,#82,#54,#2a,#0f ;.....T..
db #0a,#c3,#00,#54,#a8,#0f,#41,#c3 ;...T..A.
db #00,#00,#ad,#1f,#6b,#82,#00,#00 ;....k...
db #87,#3f,#6b,#82,#00,#00,#41,#97 ;..k...A.
db #6b,#00,#00,#00,#00,#c3,#6b,#00 ;k.....k.
db #00,#00,#00,#41,#c3,#41,#00,#00 ;...A.A..
db #00,#00,#c3,#41,#00,#00,#00,#00 ;...A....
db #41,#82,#00,#00,#00,#00,#00,#00 ;A.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #c3,#a8,#00,#00,#f4,#bd,#6b,#c3 ;......k.
db #00,#50,#fc,#3f,#3f,#c3,#82,#54 ;.P.....T
db #bd,#3f,#3f,#6b,#82,#54,#a8,#00 ;...k.T..
db #3f,#00,#c3,#f4,#a8,#00,#3f,#00
db #41,#fc,#a8,#44,#3f,#44,#41,#fc ;A..D.DA.
db #bd,#00,#3f,#15,#c3,#fc,#bd,#3f
db #3f,#3f,#c3,#fc,#fc,#3f,#3f,#3f
db #c3,#54,#a8,#3f,#3f,#3f,#c3,#54 ;.T.....T
db #fc,#00,#00,#2a,#c3,#00,#fc,#05
db #0f,#41,#82,#00,#fc,#a8,#0f,#41 ;.A.....A
db #82,#00,#54,#bd,#2f,#4b,#00,#00 ;..T..K..
db #54,#bd,#3f,#c3,#00,#00,#00,#bd ;T.......
db #6b,#82,#00,#00,#00,#fc,#c3,#00 ;k.......
db #00,#00,#a0,#e9,#82,#00,#00,#00
db #a8,#e9,#00,#00,#00,#00,#54,#82 ;......T.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f0,#00,#00,#00,#50,#fc ;......P.
db #bd,#82,#00,#00,#f4,#3f,#6b,#c3 ;......k.
db #00,#50,#bd,#3f,#3f,#c3,#82,#54 ;.P.....T
db #bd,#3f,#3f,#6b,#82,#54,#3f,#3f ;...k.T..
db #00,#41,#c3,#f4,#3f,#3f,#00,#15 ;.A......
db #41,#fc,#3f,#3f,#00,#9d,#41,#fc ;A.....A.
db #3f,#3f,#2a,#15,#41,#fc,#bd,#3f ;....A...
db #3f,#3f,#c3,#fc,#bd,#3f,#3f,#6b ;.......k
db #c3,#54,#bd,#2a,#3f,#3f,#c3,#54 ;.T.....T
db #bd,#3f,#00,#3f,#82,#00,#fc,#3f
db #00,#00,#00,#00,#54,#bd,#2a,#0a ;....T...
db #00,#00,#00,#97,#6b,#0f,#00,#00 ;....k...
db #00,#97,#3f,#c3,#0a,#00,#00,#97
db #6b,#82,#0a,#00,#a8,#97,#c3,#00 ;k.......
db #00,#54,#54,#c3,#82,#00,#00,#00 ;.TT.....
db #e9,#c3,#00,#00,#00,#00,#41,#82 ;......A.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#3f,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #bd,#3f,#3f,#6b,#82,#54,#bd,#3f ;...k.T..
db #3f,#15,#c3,#f4,#bd,#3f,#3f,#00
db #c3,#fc,#3f,#3f,#3f,#00,#00,#fc
db #3f,#3f,#3f,#04,#00,#fc,#bd,#3f
db #3f,#82,#00,#fc,#bd,#3f,#3f,#6b ;.......k
db #82,#54,#bd,#3f,#15,#3f,#c3,#54 ;.T.....T
db #bd,#3f,#2a,#00,#c3,#00,#e9,#3f
db #82,#00,#00,#00,#54,#97,#6b,#05 ;....T.k.
db #00,#00,#00,#97,#6b,#87,#0a,#00 ;....k...
db #00,#97,#3f,#c3,#00,#50,#00,#bd ;.....P..
db #6b,#82,#05,#a8,#00,#bd,#c3,#00 ;k.......
db #00,#a8,#54,#6b,#82,#00,#00,#54 ;..Tk...T
db #fc,#c3,#00,#00,#00,#00,#6b,#82 ;......k.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#3f,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #bd,#3f,#3f,#6b,#82,#54,#bd,#3f ;...k.T..
db #3f,#15,#c3,#f4,#bd,#3f,#3f,#00
db #c3,#fc,#3f,#3f,#3f,#00,#00,#fc
db #3f,#3f,#3f,#04,#00,#fc,#bd,#3f
db #3f,#82,#00,#fc,#bd,#3f,#3f,#6b ;.......k
db #82,#fc,#bd,#3f,#15,#3f,#c3,#54 ;.......T
db #bd,#3f,#2a,#00,#c3,#54,#97,#3f ;.....T..
db #82,#00,#00,#00,#e9,#97,#6b,#05 ;......k.
db #00,#00,#00,#97,#6b,#82,#0a,#00 ;....k...
db #00,#97,#3f,#c3,#00,#00,#00,#97
db #3f,#c3,#00,#00,#00,#bd,#6b,#82 ;......k.
db #00,#00,#54,#3f,#c3,#00,#00,#a0 ;..T.....
db #fc,#6b,#82,#00,#00,#54,#6b,#c3 ;.k...Tk.
db #00,#00,#00,#00,#c3,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#3f,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #fc,#3f,#3f,#6b,#82,#54,#bd,#3f ;...k.T..
db #3f,#15,#c3,#f4,#bd,#3f,#3f,#00
db #c3,#fc,#bd,#3f,#3f,#00,#00,#fc
db #3f,#3f,#3f,#00,#80,#fc,#3f,#3f
db #3f,#82,#00,#fc,#bd,#3f,#3f,#6b ;.......k
db #82,#fc,#bd,#3f,#15,#3f,#c3,#fc
db #bd,#3f,#2a,#00,#c3,#fc,#97,#3f
db #82,#0a,#00,#54,#e9,#97,#6b,#05 ;...T..k.
db #00,#00,#54,#97,#6b,#82,#00,#00 ;..T.k...
db #00,#97,#3f,#6b,#00,#00,#00,#97 ;...k....
db #3f,#c3,#00,#00,#00,#bd,#6b,#c3 ;......k.
db #00,#00,#54,#3f,#c3,#00,#00,#00 ;..T.....
db #fc,#6b,#82,#00,#00,#50,#6b,#c3 ;.k...Pk.
db #00,#00,#00,#c3,#82,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f4,#00,#00,#00,#50,#fc ;......P.
db #6b,#a8,#00,#00,#f4,#bd,#3f,#c3 ;k.......
db #00,#50,#fc,#3f,#3f,#6b,#82,#54 ;.P...k.T
db #fc,#3f,#3f,#6b,#82,#54,#bd,#3f ;...k.T..
db #3f,#15,#c3,#f4,#bd,#3f,#3f,#00
db #c3,#fc,#bd,#3f,#3f,#00,#00,#fc
db #3f,#3f,#3f,#04,#00,#fc,#3f,#3f
db #3f,#82,#00,#fc,#bd,#3f,#3f,#6b ;.......k
db #82,#fc,#bd,#3f,#15,#3f,#c3,#54 ;.......T
db #bd,#3f,#2a,#00,#c3,#54,#97,#3f ;.....T..
db #82,#00,#00,#00,#e9,#97,#6b,#05 ;......k.
db #00,#00,#00,#97,#6b,#82,#0a,#00 ;....k...
db #00,#97,#3f,#c3,#00,#00,#00,#97
db #3f,#c3,#00,#00,#00,#bd,#6b,#82 ;......k.
db #00,#00,#54,#3f,#c3,#00,#00,#a0 ;..T.....
db #fc,#6b,#82,#00,#00,#54,#6b,#c3 ;.k...Tk.
db #00,#00,#00,#41,#82,#00,#00,#00 ;...A....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f0,#a0,#00,#00,#50,#b1 ;......P.
db #22,#55,#00,#00,#b1,#77,#aa,#00 ;.U...w..
db #00,#00,#a0,#c0,#aa,#00,#00,#00
db #22,#40,#d5,#00,#00,#50,#00,#40 ;.....P..
db #d5,#00,#00,#11,#04,#40,#d5,#00
db #00,#11,#00,#40,#d5,#00,#00,#11
db #00,#62,#ff,#00,#00,#00,#22,#77 ;.b.....w
db #0c,#80,#00,#00,#22,#77,#0d,#aa ;.....w..
db #00,#00,#91,#ea,#85,#0a,#00,#00
db #91,#c0,#85,#4a,#00,#30,#62,#24 ;...J..b.
db #0d,#5f,#00,#3c,#30,#30,#0f,#4a ;.......J
db #00,#00,#3c,#34,#0f,#5f,#00,#00
db #ff,#7d,#0f,#ea,#00,#00,#62,#ff ;......b.
db #d5,#d5,#00,#00,#c0,#ea,#ea,#ea
db #00,#00,#62,#d5,#d5,#d5,#00,#00 ;..b.....
db #62,#c0,#ea,#ea,#aa,#50,#62,#c0 ;b....Pb.
db #c0,#d5,#80,#b1,#c0,#ea,#c0,#c0
db #aa,#00,#77,#ea,#d5,#c0,#d5,#00 ;..w.....
db #00,#f0,#f0,#00,#00,#00,#50,#b1 ;......P.
db #22,#aa,#00,#00,#b1,#77,#aa,#55 ;.....w.U
db #00,#00,#a0,#c0,#aa,#00,#00,#00
db #22,#40,#d5,#00,#00,#50,#00,#40 ;.....P..
db #d5,#00,#00,#11,#05,#40,#d5,#00
db #00,#40,#00,#40,#d5,#00,#00,#40
db #00,#62,#ff,#00,#00,#00,#80,#77 ;.b.....w
db #0c,#80,#00,#00,#22,#d5,#0d,#aa
db #00,#20,#33,#ea,#85,#0a,#00,#38
db #31,#24,#85,#4a,#00,#14,#38,#30 ;...J....
db #0f,#5f,#00,#00,#be,#34,#0f,#4a ;.......J
db #00,#00,#77,#7d,#af,#5f,#00,#00 ;..w.....
db #c0,#ea,#ea,#ea,#00,#00,#62,#d5 ;......b.
db #d5,#d5,#00,#00,#62,#ea,#ea ;....b..
lab7F00 db #ea
lab7F01 db #0
db #00,#62,#d5,#d5,#d5,#00,#00,#c0 ;.b......
db #c0,#ea,#ea,#aa,#50,#62,#c0,#c0 ;....Pb..
db #d5,#80,#b1,#c0,#ea,#c0,#c0,#aa
db #00,#77,#ea,#c0,#ea,#d5,#00,#00 ;.w......
db #f0,#f0,#00,#00,#00,#50,#b1,#22 ;.....P..
db #aa,#00,#00,#b1,#77,#aa,#aa,#00 ;....w...
db #00,#a0,#c0,#aa,#00,#00,#00,#22
db #40,#d5,#00,#00,#50,#00,#40,#d5 ;....P...
db #00,#00,#11,#04,#40,#d5,#00,#00
db #11,#00,#40,#d5,#00,#00,#11,#00
db #62,#ff,#00,#00,#00,#22,#77,#0c ;b.....w.
db #80,#00,#00,#22,#d5,#0d,#aa,#00
db #00,#91,#ea,#85,#0a,#00,#00,#33
db #c0,#85,#4a,#00,#30,#62,#24,#0d ;..J..b..
db #5f,#00,#3c,#30,#30,#0f,#4a,#00 ;......J.
db #00,#3c,#34,#0f,#5f,#00,#00,#ff
db #7d,#0f,#ea,#00,#00,#62,#ff,#d5 ;.....b..
db #d5,#00
lab7F8C db #0
lab7F8D db #62
db #ea,#ea,#ea,#00,#00,#c0,#d5,#d5
db #d5,#00,#00,#62,#c0,#ea,#ea,#aa ;...b....
db #50,#c0,#c0,#c0,#d5,#80,#b1,#c0 ;P.......
db #c0,#c0,#ea,#aa,#00,#77,#ea,#d5 ;.....w..
db #ea,#d5,#00,#00,#f0,#f0,#00,#00
db #00,#50,#b1,#22,#aa,#00,#00,#b1 ;.P......
db #77,#aa,#55,#00,#00,#a0,#c0,#aa ;w.U.....
db #00,#00,#00,#22,#40,#d5,#00,#00
db #50,#00,#40,#d5,#00,#00,#11,#04 ;P.......
db #40,#d5,#00,#00,#11,#00,#40,#d5
db #00,#00,#11,#00,#62,#ff,#00,#00 ;....b...
db #00,#22,#77,#0c,#80,#00,#00,#22 ;..w.....
db #d5,#0d,#0a,#00,#00,#33,#ea,#85
db #0a,#00,#00,#33,#c0,#c0,#0f,#00
db #00,#62,#c0,#c0,#0f,#00,#00,#62 ;.b.....b
db #90,#0c,#0f,#00,#00,#30,#30,#25
db #0f,#00,#10,#3c,#38,#2d,#4a,#00 ;......J.
db #14,#ff,#3c,#0f,#d5,#00,#00,#62 ;.......b
db #ea,#ea,#ea,#00,#00,#62,#d5,#d5 ;.....b..
db #d5,#00,#00,#62,#c0,#ea,#ea,#aa ;...b....
db #50,#62,#c0,#c0,#d5,#80,#b1,#c0 ;Pb......
db #c0,#c0,#c0,#aa,#00,#77,#ea,#d5 ;.....w..
db #ea,#d5,#00,#00,#f0,#a0,#00,#00
db #00,#50,#b1,#77,#00,#00,#00,#f0 ;.P.w....
db #77,#aa,#aa,#00,#00,#a0,#c0,#aa ;w.......
db #00,#00,#00,#a0,#00,#d5,#00,#00
db #50,#00,#00,#d5,#00,#00,#50,#04 ;P.....P.
db #04,#d5,#00,#00,#50,#00,#00,#d5 ;....P...
db #00,#00,#11,#00,#00,#ff,#00,#00
db #00,#22,#55,#84,#08,#00,#00,#22 ;..U.....
db #55,#84,#0a,#00,#00,#33,#ea,#84 ;U.......
db #0a,#00,#00,#33,#c0,#c0,#0f,#00
db #00,#62,#c0,#c0,#0f,#00,#00,#62 ;.b.....b
db #90,#0c,#0f,#00,#00,#30,#30,#25
db #0f,#00,#00,#3c,#38,#2d,#4a,#00 ;......J.
db #00,#ff,#be,#0f,#d5,#00,#00,#62 ;.......b
db #ea,#ea,#ea,#00,#50,#62,#c0,#d5 ;....Pb..
db #d5,#00,#11,#62,#c0,#c0,#ea,#aa ;...b....
db #11,#62,#c0,#c0,#d5,#80,#b1,#62 ;.b.....b
db #c0,#c0,#c0,#aa,#33,#62,#ff,#d5 ;.....b..
db #ea,#d5,#00,#00,#f0,#a0,#00,#00
db #00,#50,#b1,#77,#00,#00,#00,#50 ;.P.w...P
db #77,#ff,#00,#00,#00,#a0,#c0,#ff ;w.......
db #00,#00,#00,#a0,#00,#40,#aa,#00
db #00,#a0,#00,#40,#aa,#00,#00,#22
db #08,#48,#aa,#00,#00,#22,#00,#40 ;.H......
db #aa,#00,#00,#22,#00,#40,#aa,#00
db #00,#33,#00,#85,#0a,#00,#00,#cc
db #00,#85,#0f,#00,#00,#8d,#ea,#c4
db #0f,#00,#00,#99,#c0,#c0,#0f,#00
db #00,#8d,#c0,#c0,#0f,#00,#00,#8d
db #c0,#64,#0f,#00,#00,#66,#30,#30 ;.d...f..
db #0f,#00,#00,#62,#3c,#25,#5f,#00 ;...b....
db #00,#62,#ff,#2d,#d5,#00,#00,#62 ;.b.....b
db #c0,#ea,#ff,#00,#50,#62,#c0,#d5 ;....Pb..
db #d5,#00,#50,#62,#c0,#c0,#ea,#aa ;..Pb....
db #50,#62,#c0,#c0,#d5,#aa,#b1,#c0 ;Pb......
db #c0,#c0,#c0,#aa,#b1,#77,#ea,#ff ;.....w..
db #c0,#d5,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#e0,#c0,#aa,#00,#00,#00
db #e0,#c0,#aa,#00,#00,#00,#c0,#c0
db #55,#00,#00,#50,#80,#00,#55,#00 ;U..P..U.
db #00,#50,#80,#00,#55,#00,#00,#50 ;.P..U..P
db #84,#04,#55,#00,#00,#50,#80,#00 ;..U..P..
db #55,#00,#00,#40,#80,#00,#55,#00 ;U.....U.
db #00,#44,#4a,#00,#d5,#00,#00,#8d ;.DJ.....
db #4a,#00,#0f,#00,#00,#8d,#4a,#c0 ;J.....J.
db #0f,#00,#00,#8d,#c0,#c0,#27,#00
db #00,#8d,#c0,#c0,#85,#00,#00,#8d
db #1a,#c0,#0f,#00,#00,#8d,#30,#30
db #5f,#00,#00,#85,#1a,#3c,#d5,#00
db #00,#c0,#1e,#ea,#ff,#00,#00,#c0
db #d5,#d5,#d5,#00,#00,#c0,#c0,#ea
db #ea,#aa,#50,#c0,#c0,#d5,#d5,#aa ;..P.....
db #50,#c0,#c0,#c0,#ea,#aa,#40,#c0 ;P.......
db #c0,#c0,#d5,#d5,#e0,#d5,#ea,#ff
db #c0,#ff,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#b1,#72,#aa,#00,#00,#50 ;...r...P
db #11,#c0,#d5,#00,#00,#00,#11,#c0
db #55,#00,#00,#00,#b1,#00,#55,#00 ;U.....U.
db #00,#00,#e0,#00,#00,#aa,#00,#00
db #62,#08,#08,#aa,#00,#00,#62,#00 ;b.....b.
db #00,#aa,#00,#00,#62,#00,#00,#aa ;....b...
db #00,#44,#4a,#aa,#55,#00,#00,#44 ;.DJ.U..D
db #4a,#aa,#55,#00,#00,#44,#4a,#d5 ;J.U..DJ.
db #d5,#00,#00,#8d,#c0,#c0,#d5,#00
db #00,#8d,#c0,#c0,#d5,#00,#00,#8d
db #0f,#60,#d5,#00,#00,#0f,#1a,#30
db #30,#00,#00,#af,#1e,#34,#3c,#00
db #00,#d5,#0f,#7d,#d5,#00,#00,#62 ;.......b
db #ea,#ea,#ea,#00,#00,#62,#d5,#d5 ;.....b..
db #d5,#aa,#11,#c0,#c0,#ea,#ea,#aa
db #11,#c0,#c0,#d5,#d5,#aa,#11,#c0
db #c0,#c0,#ea,#ff,#62,#d5,#ea,#ff ;....b...
db #d5,#d5,#00,#50,#f0,#f0,#00,#00 ;...P....
db #00,#a0,#40,#d0,#aa,#00,#00,#00
db #50,#e0,#d5,#00,#00,#00,#50,#62 ;P.....Pb
db #55,#00,#00,#00,#b1,#80,#55,#00 ;U.....U.
db #00,#00,#b1,#80,#00,#aa,#00,#00
db #b1,#80,#08,#aa,#00,#00,#b1,#80
db #00,#aa,#00,#00,#f0,#c0,#00,#aa
db #00,#50,#cc,#ea,#55,#00,#00,#50 ;.P..U..P
db #8d,#ea,#55,#00,#00,#44,#0f,#d5 ;..U..D..
db #d5,#00,#00,#e4,#4a,#c0,#d5,#00 ;....J...
db #00,#66,#0f,#1a,#d5,#30,#00,#66 ;.f.....f
db #0f,#30,#30,#3c,#00,#66,#0f,#38 ;.....f..
db #3c,#00,#00,#77,#0f,#94,#ff,#00 ;...w....
db #00,#62,#ea,#ea,#ff,#00,#00,#62 ;.b.....b
db #d5,#d5,#d5,#00,#00,#62,#c0,#ea ;.....b..
db #ff,#00,#50,#62,#c0,#d5,#d5,#00 ;..Pb....
db #11,#62,#c0,#c0,#ea,#40,#b1,#c0 ;.b......
db #c0,#d5,#d5,#80,#b1,#c0,#ea,#d5
db #aa,#00,#00,#00,#f0,#f0,#00,#00
db #00,#50,#11,#62,#aa,#00,#00,#a0 ;.P.b....
db #50,#c0,#d5,#00,#00,#00,#50,#c0 ;P.....P.
db #55,#00,#00,#00,#e0,#80,#55,#00 ;U.....U.
db #00,#00,#e0,#80,#00,#aa,#00,#00
db #62,#80,#0a,#aa,#00,#00,#62,#80 ;b.....b.
db #00,#aa,#00,#00,#62,#c0,#00,#aa ;....b...
db #00,#50,#cc,#ea,#55,#00,#00,#11 ;.P..U...
db #8d,#ea,#55,#00,#00,#44,#5f,#d5 ;..U..D..
db #d5,#10,#00,#e4,#4a,#1a,#90,#34 ;....J...
db #00,#e4,#0f,#30,#34,#28,#00,#66 ;.......f
db #0f,#38,#7d,#00,#00,#27,#0f,#be
db #ff,#00,#00,#77,#d5,#d5,#d5,#00 ;...w....
db #00,#62,#ea,#ea,#ff,#00,#00,#62 ;.b.....b
db #d5,#d5,#d5,#00,#00,#62,#c0,#ea ;.....b..
db #ff,#00,#50,#c0,#c0,#d5,#d5,#00 ;..P.....
db #11,#c0,#c0,#c0,#ea,#aa,#11,#c0
db #c0,#d5,#d5,#d5,#e0,#d5,#c0,#d5
db #ea,#00,#00,#00,#f0,#f0,#00,#00
db #00,#50,#11,#d0,#aa,#00,#00,#50 ;.P.....P
db #11,#c0,#d5,#00,#00,#00,#11,#c0
db #55,#00,#00,#00,#b1,#80,#55,#00 ;U.....U.
db #00,#00,#b1,#80,#00,#aa,#00,#00
db #b1,#80,#08,#aa,#00,#00,#e0,#80
db #00,#aa,#00,#00,#62,#c0,#00,#aa ;....b...
db #00,#50,#cc,#ea,#55,#00,#00,#11 ;.P..U...
db #0f,#ea,#55,#00,#00,#44,#0f,#d5 ;..U..D..
db #d5,#00,#00,#e4,#4a,#c0,#d5,#00 ;....J...
db #00,#e4,#0f,#1a,#d5,#30,#00,#e4
db #0f,#30,#30,#3c,#00,#a5,#0f,#38
db #3c,#00,#00,#f5,#0f,#be,#ff,#00
db #00,#62,#ea,#ff,#ff,#00,#00,#62 ;.b.....b
db #d5,#d5,#d5,#00,#00,#62,#c0,#ea ;.....b..
db #ff,#00,#50,#62,#c0,#d5,#d5,#00 ;..Pb....
db #50,#62,#c0,#c0,#ea,#00,#11,#d5 ;Pb......
db #c0,#c0,#d5,#00,#b1,#d5,#ea,#d5
db #ea,#ff,#00,#00,#f0,#f0,#00,#00
db #00,#50,#11,#72,#aa,#00,#00,#a0 ;.P.r....
db #11,#62,#d5,#00,#00,#00,#11,#c0 ;.b......
db #55,#00,#00,#00,#b1,#80,#55,#00 ;U.....U.
db #00,#00,#62,#80,#00,#aa,#00,#00 ;..b.....
db #62,#80,#08,#aa,#00,#00,#62,#80 ;b.....b.
db #00,#aa,#00,#00,#62,#c0,#00,#aa ;....b...
db #00,#50,#cc,#ea,#55,#00,#00,#44 ;.P..U..D
db #0f,#ea,#55,#00,#00,#44,#5f,#d5 ;..U..D..
db #d5,#00,#00,#8d,#4a,#c0,#d5,#00 ;....J...
db #00,#8d,#c0,#c0,#d5,#00,#00,#8d
db #0f,#60,#d5,#00,#00,#0f,#1a,#30
db #30,#00,#00,#a5,#1e,#34,#3c,#20
db #00,#62,#0f,#3c,#ff,#28,#00,#77 ;.b.....w
db #d5,#d5,#d5,#00,#00,#33,#ea,#ea
db #ff,#00,#50,#62,#d5,#d5,#d5,#00 ;..Pb....
db #50,#62,#c0,#ea,#ea,#00,#b1,#62 ;Pb.....b
db #c0,#d5,#d5,#aa,#11,#77,#ea,#d5 ;.....w..
db #ea,#ff,#00,#00,#f0,#f0,#00,#00
db #00,#50,#b1,#f0,#a0,#00,#00,#f0 ;.P......
db #c8,#80,#80,#00,#00,#e4,#c0,#00
db #50,#00,#50,#b1,#c0,#00,#10,#00 ;P.P.....
db #f0,#62,#c0,#00,#00,#00,#55,#55 ;.b....UU
db #c0,#00,#00,#00,#ae,#5d,#c0,#80
db #00,#00,#04,#0c,#3f,#00,#00,#00
db #00,#1d,#7e,#a0,#00,#00,#04,#3f
db #f8,#f0,#00,#00,#00,#fc,#fc,#72 ;.......r
db #00,#00,#00,#fc,#fc,#b1,#00,#00
db #00,#58,#f0,#e0,#00,#00,#04,#19 ;.X......
db #33,#80,#00,#00,#00,#ea,#c0,#2a
db #00,#00,#00,#3f,#3f,#3f,#00,#00
db #00,#bd,#3f,#3f,#00,#00,#00,#fc
db #bd,#3f,#00,#00,#54,#fc,#fc,#7e ;....T...
db #2a,#00,#54,#fc,#fc,#fc,#2a,#54 ;..T....T
db #bd,#7e,#fc,#fc,#bd,#7e,#fc,#bd
db #3f,#fc,#fc,#fc,#00,#54,#fc,#fc ;.....T..
db #00,#00,#00,#00,#f0,#a0,#00,#00
db #00,#50,#b1,#72,#00,#00,#00,#f0 ;.P.r....
db #c8,#80,#20,#00,#00,#e4,#62,#00 ;......b.
db #00,#00,#50,#b1,#c0,#00,#00,#00 ;..P.....
db #f0,#62,#c0,#00,#00,#00,#55,#55 ;.b....UU
db #c0,#00,#00,#00,#ae,#5d,#c0,#80
db #00,#00,#04,#0c,#3f,#00,#00,#00
db #00,#1d,#f8,#00,#00,#00,#04,#7e
db #f0,#a0,#00,#00,#00,#fc,#b9,#80
db #00,#00,#0c,#f0,#f8,#80,#00,#00
db #04,#72,#f0,#80,#00,#00,#00,#c0 ;.r......
db #c0,#80,#00,#00,#00,#3f,#c0,#2a
db #00,#00,#00,#3f,#3f,#3f,#00,#00
db #00,#bd,#3f,#3f,#00,#00,#00,#fc
db #bd,#3f,#00,#54,#54,#fc,#fc,#bd ;...TT...
db #2a,#54,#54,#fc,#fc,#fc,#2a,#00 ;.TT.....
db #bd,#7e,#fc,#fc,#bd,#fc,#fc,#bd
db #7e,#fc,#fc,#fc,#00,#54,#bd,#7e ;.....T..
db #00,#00,#00,#00,#f0,#f0,#00,#00
db #00,#50,#e0,#d0,#a0,#00,#00,#f0 ;.P......
db #c8,#80,#10,#00,#00,#e4,#c0,#00
db #00,#00,#50,#c0,#c0,#00,#00,#00 ;..P.....
db #f0,#c0,#c0,#00,#00,#00,#55,#55 ;......UU
db #c0,#00,#00,#00,#ae,#5d,#c0,#80
db #00,#00,#04,#0c,#3f,#00,#00,#00
db #04,#1d,#f8,#00,#00,#00,#00,#7e
db #f0,#a0,#00,#00,#0c,#f4,#e8,#a0
db #00,#00,#04,#f0,#e8,#80,#00,#00
db #00,#d0,#f0,#80,#00,#00,#00,#6a ;.......j
db #c0,#80,#00,#00,#00,#3f,#c0,#3f
db #00,#00,#00,#3f,#3f,#3f,#00,#00
db #00,#bd,#3f,#3f,#00,#00,#54,#bd ;......T.
db #3f,#3f,#00,#00,#54,#bd,#fc,#3f ;....T...
db #2a,#00,#54,#fc,#fc,#fc,#2a,#54 ;..T....T
db #bd,#fc,#fc,#fc,#bd,#fc,#fc,#7e
db #bd,#7e,#fc,#a8,#00,#bd,#7e,#fc
db #00,#00,#00,#00,#f0,#a0,#00,#00
db #00,#50,#b1,#72,#00,#00,#00,#f0 ;.P.r....
db #99,#00,#20,#00,#00,#e4,#62,#00 ;......b.
db #00,#00,#50,#b1,#c0,#00,#00,#00 ;..P.....
db #f0,#62,#c0,#00,#00,#00,#55,#55 ;.b....UU
db #c0,#00,#00,#00,#ae,#5d,#c0,#80
db #00,#00,#04,#0c,#3f,#00,#00,#00
db #00,#1d,#f8,#a0,#00,#00,#04,#3f
db #f8,#f0,#00,#00,#00,#7e,#fc,#e0
db #00,#00,#04,#58,#fc,#62,#00,#00 ;...X.b..
db #00,#58,#f0,#62,#00,#00,#00,#ea ;.X.b....
db #33,#80,#00,#00,#00,#3f,#c0,#2a
db #00,#00,#00,#3f,#3f,#3f,#00,#00
db #00,#3f,#3f,#3f,#00,#00,#00,#bd
db #3f,#3f,#2a,#00,#00,#fc,#bd,#3f
db #2a,#54,#54,#fc,#fc,#bd,#2a,#54 ;.TT....T
db #54,#fc,#fc,#fc,#bd,#a8,#fc,#bd ;T.......
db #fc,#bd,#7e,#fc,#00,#54,#3f,#7e ;.....T..
db #00,#00,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#f0,#72,#a0,#00,#00,#00 ;...r....
db #e4,#22,#10,#00,#00,#50,#b1,#c0 ;.....P..
db #00,#00,#00,#50,#c8,#c0,#00,#00 ;...P....
db #00,#11,#c0,#c0,#00,#00,#00,#f5
db #55,#55,#80,#00,#00,#04,#0c,#5d ;UU......
db #00,#00,#00,#04,#0c,#5d,#00,#00
db #00,#fc,#0d,#bf,#2a,#00,#54,#f4 ;......T.
db #fd,#7e,#f4,#00,#54,#d0,#fc,#f8 ;....T...
db #95,#00,#54,#91,#fc,#e8,#95,#00 ;..T.....
db #54,#c0,#fc,#e8,#95,#00,#54,#c0 ;T.....T.
db #0c,#48,#80,#00,#00,#6a,#84,#c0 ;.H...j..
db #2a,#00,#00,#bd,#d5,#95,#2a,#00
db #00,#fc,#3f,#3f,#2a,#00,#00,#fc
db #bd,#3f,#3f,#00,#00,#fc,#fc,#fc
db #3f,#00,#54,#fc,#fc,#7e,#bd,#00 ;..T.....
db #fc,#fc,#fc,#bd,#7e,#2a,#fc,#fc
db #fc,#bd,#7e,#2a,#15,#bd,#bd,#7e
db #7e,#3f,#00,#50,#f0,#a0,#00,#00 ;...P....
db #00,#20,#b1,#22,#00,#00,#00,#00
db #e4,#c0,#00,#00,#00,#50,#62,#c0 ;.....Pb.
db #00,#00,#00,#50,#c8,#c0,#00,#00 ;...P....
db #00,#11,#c0,#c0,#00,#00,#00,#d5
db #55,#55,#a0,#00,#00,#04,#0c,#5d ;UU......
db #00,#00,#00,#04,#0d,#5d,#00,#00
db #00,#fc,#0d,#bf,#2a,#00,#54,#f4 ;......T.
db #fd,#7e,#f4,#00,#54,#d0,#fc,#f8 ;....T...
db #95,#00,#54,#c0,#fc,#f8,#95,#00 ;..T.....
db #54,#c0,#0c,#48,#95,#00,#54,#c0 ;T..H..T.
db #84,#c0,#80,#00,#00,#6a,#d5,#c0 ;.....j..
db #2a,#00,#00,#bd,#95,#95,#2a,#00
db #00,#fc,#3f,#3f,#2a,#00,#00,#fc
db #fc,#3f,#3f,#00,#00,#fc,#fc,#fc
db #3f,#00,#54,#fc,#bd,#fc,#bd,#00 ;..T.....
db #fc,#fc,#fc,#7e,#fc,#2a,#54,#fc ;......T.
db #fc,#bd,#fc,#bd,#00,#54,#3f,#7e ;.....T..
db #7e,#7e,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#f0,#33,#a0,#00,#00,#00
db #e4,#c0,#80,#00,#00,#50,#62,#c0 ;.....Pb.
db #10,#00,#00,#50,#c8,#c0,#00,#00 ;...P....
db #00,#50,#62,#c0,#00,#00,#00,#f5 ;.Pb.....
db #7d,#7d,#80,#00,#00,#04,#0c,#5d
db #00,#00,#00,#04,#0d,#5d,#00,#00
db #00,#fc,#0d,#bf,#2a,#00,#54,#f4 ;......T.
db #fd,#7e,#f4,#00,#54,#f0,#fc,#f8 ;....T...
db #b5,#00,#54,#91,#26,#33,#95,#00 ;..T.....
db #54,#91,#84,#91,#37,#00,#54,#c0 ;T.....T.
db #84,#c0,#80,#00,#00,#6a,#d5,#c0 ;.....j..
db #2a,#00,#00,#bd,#3f,#3f,#2a,#00
db #00,#fc,#3f,#7e,#2a,#00,#00,#fc
db #fc,#3f,#bd,#00,#00,#fc,#fc,#fc
db #3f,#00,#00,#fc,#7e,#fc,#bd,#54 ;.......T
db #fc,#fc,#fc,#7e,#fc,#fc,#fc,#fc
db #bd,#fc,#fc,#fc,#00,#15,#bd,#bd
db #bd,#a8,#00,#50,#f0,#a0,#00,#00 ;...P....
db #00,#20,#b1,#a0,#00,#00,#00,#00
db #e4,#c0,#00,#00,#00,#50,#b1,#c0 ;.....P..
db #00,#00,#00,#50,#c8,#c0,#00,#00 ;...P....
db #00,#50,#62,#c0,#00,#00,#00,#f5 ;.Pb.....
db #55,#55,#80,#00,#00,#04,#0c,#5d ;UU......
db #00,#00,#00,#04,#0d,#5d,#00,#00
db #00,#fc,#0d,#bf,#a8,#00,#54,#f4 ;......T.
db #fd,#7e,#f4,#00,#54,#b1,#fc,#f8 ;....T...
db #37,#00,#54,#91,#fc,#f8,#95,#00 ;..T.....
db #54,#c0,#0c,#48,#95,#00,#54,#c0 ;T..H..T.
db #26,#33,#80,#00,#00,#6a,#d5,#c0 ;.....j..
db #2a,#00,#00,#bd,#95,#95,#a8,#00
db #00,#fc,#3f,#7e,#2a,#00,#00,#fc
db #bd,#3f,#3f,#00,#00,#fc,#fc,#fc
db #3f,#00,#00,#bd,#fc,#fc,#bd,#54 ;.......T
db #54,#fc,#3f,#fc,#fc,#54,#fc,#fc ;T....T..
db #7e,#fc,#fc,#fc,#00,#15,#fc,#fc
db #fc,#fc,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#f0,#b1,#a0,#00,#00,#50 ;.......P
db #33,#66,#c0,#00,#00,#11,#11,#c0 ;.f......
db #c8,#00,#00,#20,#00,#e0,#c0,#80
db #00,#00,#00,#e0,#c0,#c0,#00,#00
db #00,#e0,#aa,#aa,#00,#00,#50,#e0 ;......P.
db #ae,#5d,#00,#00,#00,#7f,#0c,#08
db #00,#00,#50,#bd,#0c,#0a,#00,#00 ;..P.....
db #b1,#37,#2e,#08,#00,#00,#b1,#d4
db #3f,#00,#00,#00,#e0,#7e,#fc,#00
db #00,#00,#e0,#f0,#f0,#0c,#00,#00
db #40,#c0,#c0,#08,#00,#00,#15,#c0
db #d5,#00,#00,#00,#54,#3f,#3f,#00 ;....T...
db #00,#00,#fc,#3f,#3f,#00,#00,#54 ;.......T
db #fc,#fc,#3f,#2a,#00,#54,#fc,#fc ;.....T..
db #fc,#2a,#00,#fc,#fc,#bd,#fc,#2a
db #a8,#fc,#fc,#fc,#3f,#a8,#fc,#fc
db #fc,#fc,#fc,#00,#00,#00,#fc,#bd
db #2a,#00,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#f0,#72,#a0,#00,#00,#10 ;...r....
db #50,#66,#72,#00,#00,#00,#00,#e0 ;Pfr.....
db #c8,#00,#00,#00,#00,#e0,#c0,#80
db #00,#00,#00,#e0,#c0,#c0,#00,#00
db #00,#e0,#aa,#aa,#00,#00,#50,#c0 ;......P.
db #ae,#5d,#00,#00,#00,#3f,#ae,#08
db #00,#00,#54,#b5,#0c,#0a,#00,#00 ;..T.....
db #f8,#62,#3f,#08,#00,#00,#f8,#37 ;.b......
db #fc,#00,#00,#00,#f8,#37,#f0,#0c
db #00,#00,#f8,#72,#33,#08,#00,#00 ;...r....
db #40,#c0,#c0,#00,#00,#00,#15,#c0
db #3f,#00,#00,#00,#54,#3f,#3f,#00 ;....T...
db #00,#00,#fc,#bd,#3f,#00,#00,#54 ;.......T
db #fc,#fc,#3f,#2a,#00,#54,#fc,#fc ;.....T..
db #bd,#2a,#a8,#fc,#fc,#7e,#fc,#2a
db #54,#fc,#fc,#bd,#fc,#a8,#fc,#54 ;T......T
db #fc,#7e,#fc,#00,#00,#00,#bd,#fc
db #a8,#00,#00,#00,#f0,#f0,#00,#00
db #00,#50,#b1,#33,#a0,#00,#00,#20 ;.P......
db #11,#66,#c0,#00,#00,#00,#00,#b1 ;.f......
db #c8,#00,#00,#00,#00,#b1,#c0,#80
db #00,#00,#00,#e0,#c0,#c0,#00,#00
db #00,#e0,#aa,#aa,#00,#00,#50,#e0 ;......P.
db #ae,#5d,#00,#00,#00,#7f,#0c,#08
db #00,#00,#54,#b5,#0c,#08,#00,#00 ;..T.....
db #f8,#f0,#3f,#00,#00,#00,#f8,#37
db #f8,#0c,#00,#00,#f8,#37,#b1,#08
db #00,#00,#f8,#72,#62,#00,#00,#00 ;...rb...
db #11,#33,#95,#00,#00,#00,#15,#c0
db #3f,#00,#00,#00,#54,#3f,#3f,#00 ;....T...
db #00,#00,#fc,#bd,#3f,#00,#00,#15
db #fc,#fc,#3f,#2a,#00,#54,#fc,#fc ;.....T..
db #bd,#2a,#a8,#fc,#fc,#fc,#fc,#2a
db #54,#fc,#7e,#fc,#fc,#2a,#fc,#fc ;T.......
db #bd,#fc,#fc,#00,#00,#54,#7e,#fc ;.....T..
db #a8,#00,#00,#00,#50,#f0,#00,#00 ;....P...
db #00,#00,#f0,#33,#a0,#00,#00,#50 ;.......P
db #11,#66,#72,#00,#00,#00,#00,#c0 ;.fr.....
db #99,#00,#00,#00,#00,#e0,#c0,#80
db #00,#00,#00,#e0,#c0,#c0,#00,#00
db #00,#b1,#aa,#aa,#00,#00,#50,#b1 ;......P.
db #ae,#5d,#00,#00,#00,#7f,#0c,#08
db #00,#00,#54,#b5,#0c,#0a,#00,#00 ;..T.....
db #f8,#f0,#3f,#08,#00,#00,#f8,#37
db #fc,#00,#00,#00,#f8,#37,#f0,#0c
db #00,#00,#f8,#72,#c0,#08,#00,#00 ;...r....
db #11,#c0,#c0,#00,#00,#00,#15,#c0
db #3f,#00,#00,#00,#54,#3f,#3f,#00 ;....T...
db #00,#00,#fc,#fc,#3f,#00,#00,#54 ;.......T
db #fc,#fc,#bd,#2a,#a8,#54,#7e,#fc ;.....T..
db #fc,#2a,#00,#fc,#bd,#fc,#fc,#a8
db #a8,#fc,#7e,#fc,#fc,#a8,#fc,#bd
db #fc,#fc,#fc,#00,#00,#00,#fc,#fc
db #a8,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #50,#a0,#00,#00,#00,#00,#f0,#bd ;P.......
db #00,#00,#00,#00,#fc,#3f,#00,#00
db #00,#00,#15,#2a,#00,#00,#00,#44 ;.......D
db #c0,#c0,#88,#00,#44,#cc,#cc,#8d ;....D...
db #cc,#0a,#cc,#cc,#cc,#cc,#cc,#0f
db #cc,#cc,#d8,#af,#8d,#0f,#d8,#4e ;.......N
db #c8,#af,#0f,#87,#b1,#af,#e0,#ea
db #4b,#c3,#62,#4e,#c0,#ff,#0f,#c3 ;K.bN....
db #11,#4e,#c8,#af,#0f,#82,#11,#4e ;.N.....N
db #d8,#af,#0f,#82,#11,#4e,#d8,#af ;.....N..
db #0f,#82,#11,#4e,#e0,#ff,#0f,#82 ;...N....
db #11,#62,#c0,#ff,#ff,#82,#11,#32 ;.b......
db #68,#ba,#7d,#82,#10,#36,#c2,#be ;h.......
db #d7,#28,#14,#62,#c0,#ff,#eb,#28 ;...b....
db #11,#62,#d5,#ff,#eb,#82,#00,#c3 ;.b......
db #c3,#d7,#c3,#00,#00,#ff,#ff,#eb
db #c3,#00,#00,#50,#f0,#30,#20,#00 ;...P....
db #00,#00,#30,#3c,#00,#00,#00,#00
db #c3,#96,#00,#00,#00,#00,#e1,#82
db #00,#00,#00,#00,#b0,#82,#00,#00
db #00,#00,#b0,#82,#00,#00,#00,#00
db #b0,#69,#00,#00,#00,#00,#b0,#69 ;.i.....i
db #00,#00,#00,#10,#b0,#28,#82,#00
db #00,#70,#61,#c3,#c3,#00,#00,#b0 ;.pa.....
db #c3,#c3,#c3,#00,#10,#b0,#c3,#61 ;.......a
db #41,#82,#50,#61,#c3,#61,#82,#82 ;A.Pa.a..
db #70,#61,#c3,#c3,#c3,#c3,#70,#61 ;pa....pa
db #c3,#c3,#c3,#41,#70,#61,#c3,#69 ;...Apa.i
db #c3,#41,#70,#25,#c3,#c3,#87,#05 ;.Ap.....
db #70,#49,#4b,#c3,#c3,#41,#70,#85 ;pIK..Ap.
db #c3,#c3,#87,#41,#10,#e1,#4b,#c3 ;...A..K.
db #c3,#00,#10,#a4,#c3,#c3,#82,#82
db #00,#70,#49,#c3,#41,#00,#00,#c3 ;.pI.A...
db #c3,#82,#c3,#00,#00,#00,#69,#41 ;......iA
db #00,#00,#00,#00,#50,#f0,#22,#00 ;....P...
db #00,#00,#b1,#33,#c0,#00,#00,#50 ;.......P
db #62,#0f,#4a,#80,#00,#b1,#27,#c0 ;b.J.....
db #c0,#c0,#00,#b1,#c0,#0f,#c0,#84
db #00,#e0,#c0,#c0,#4a,#84,#00,#48 ;....J..H
db #c0,#c0,#4a,#5d,#00,#04,#85,#0f ;..J.....
db #84,#aa,#00,#00,#48,#c0,#5d,#00 ;....H...
db #00,#00,#04,#84,#aa,#00,#00,#00
db #00,#5d,#00,#00,#00,#00,#00,#84
db #00,#00,#00,#00,#00,#84,#00,#00
db #00,#00,#00,#84,#00,#00,#00,#f0
db #22,#84,#00,#00,#00,#0c,#22,#84
db #00,#00,#00,#00,#22,#84,#00,#00
db #00,#a0,#33,#84,#00,#00,#00,#b1
db #62,#84,#00,#00,#00,#26,#62,#84 ;b.....b.
db #00,#00,#00,#08,#c0,#84,#00,#00
db #00,#00,#c0,#84,#00,#00,#00,#b1
db #77,#0c,#00,#00,#00,#0c,#aa,#ff ;w.......
db #00,#00,#00,#00,#50,#00,#00,#00 ;....P...
db #00,#00,#40,#00,#00,#00,#00,#00
db #40,#00,#00,#00,#00,#00,#a4,#0a
db #00,#00,#00,#00,#84,#0a,#00,#00
db #50,#00,#84,#0a,#50,#00,#40,#00 ;P...P...
db #84,#0a,#40,#00,#40,#00,#84,#0a
db #40,#00,#a4,#0a,#84,#0a,#a4,#0a
db #84,#0a,#84,#0a,#84,#0a,#84,#0a
db #84,#0a,#84,#0a,#84,#0a,#84,#0a
db #0c,#0a,#80,#0a,#05,#00,#08,#0a
db #80,#0f,#05,#04,#0a,#0a,#00,#05
db #05,#04,#00,#00,#00,#05,#0c,#0f
db #00,#00,#00,#00,#84,#0a,#00,#00
db #00,#00,#b0,#82,#00,#00,#00,#00
db #b4,#82,#00,#00,#00,#00,#34,#82
db #00,#00,#00,#00,#c3,#82,#00,#00
db #00,#00,#0d,#0a,#00,#00,#50,#40 ;......P.
db #0c,#0f,#05,#00,#00,#84,#04,#05
db #0a,#00,#00,#10,#00,#00,#00,#00
db #00,#10,#00,#00,#00,#00,#04,#0c
db #0c,#0c,#0c,#0c,#04,#ff,#ff,#ff
db #ff,#ff,#00,#41,#82,#00,#00,#00 ;...A....
db #00,#92,#34,#00,#00,#00,#41,#30 ;......A.
db #30,#28,#00,#00,#b0,#b0,#30,#34
db #00,#00,#50,#30,#75,#20,#00,#00 ;..P.u...
db #00,#f0,#ae,#aa,#55,#00,#00,#00 ;....U...
db #0c,#ff,#55,#00,#00,#00,#5d,#ff ;..U.....
db #0a,#00,#55,#00,#5d,#af,#0a,#00 ;..U.....
db #00,#aa,#0c
lab8E11 db #ff
db #0a,#00,#00,#aa,#5d,#ff,#0a,#00
db #00,#aa,#5d,#ff,#0a,#00,#00,#55 ;.......U
db #0c,#ff,#0a,#00,#00,#00,#5d,#5d
db #0a,#00,#00,#00,#5d,#af,#0a,#00
db #00,#00,#5d,#ff,#0a,#00,#00,#00
db #5d,#af,#0a,#00,#00,#00,#ff,#ff
db #5f,#00,#00,#55,#af,#ff,#0f,#aa ;...U....
db #00,#af,#0a,#55,#88,#5f,#00,#00 ;...U....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#30,#28
db #00,#00,#00,#10,#41,#41,#00,#00 ;....AA..
db #00,#20,#82,#82,#00,#44,#10,#c3 ;.....D..
db #00,#41,#00,#25,#4b,#82,#00,#28 ;.A..K...
db #98,#30,#c7,#00,#10,#41,#0f,#30 ;.....A..
db #61,#8a,#20,#82,#30,#c3,#87,#0a ;a.......
db #41,#00,#30,#c3,#87,#8a,#82,#82 ;A.......
db #98,#87,#c3,#8a,#41,#41,#34,#c3 ;....AA..
db #c3,#8a,#00,#82,#2d,#87,#c3,#0a
db #00,#41,#05,#87,#c7,#4b,#ff,#aa ;.A...K..
db #00,#cf,#8a,#41,#0f,#4b,#ff,#00 ;...A.K..
db #00,#3f,#2a,#00,#ff,#00,#15,#00
db #15,#00,#ff,#0a,#2a,#00,#00,#2a
db #ff,#1f,#00,#3f,#2a,#15,#ff,#5f
db #15,#00,#15,#15,#5f,#5f,#2a,#3f
db #2a,#3f,#5f,#4b,#3f,#00,#15,#3f ;...K....
db #5f,#0f,#2a,#00,#00,#3f,#5f,#0f
db #2a,#00,#00,#3f,#5f,#5f,#2a,#00
db #00,#3f,#5f,#5f,#2a,#41,#00,#3f ;.....A..
db #1a,#5f,#2a,#c3,#82,#3f,#4b,#0f ;......K.
db #3e,#c3,#c3,#3f,#0a,#0f,#3e,#69 ;.......i
db #c3,#3f,#5f,#5f,#3e,#69,#c3,#3f ;.....i..
db #5f,#5f,#3e,#3c,#c3,#3f,#5f,#5f
db #3e,#3c,#69,#3f,#5f,#0f,#3e,#3c ;..i.....
db #3c,#3f,#5f,#0f,#3e,#3c,#3c,#3d
db #5f,#4b,#3c,#3c,#3c,#3d,#5f,#0f ;.K......
db #3f,#3f,#3f,#3f,#5f,#5f,#c3,#c3
db #c3,#c3,#5f,#4f,#45,#45,#45,#45 ;...OEEEE
db #5f,#8a,#8a,#8a,#8a,#8a,#00,#55 ;.......U
db #aa,#3f,#2a,#00,#00,#d5,#ff,#00
db #15,#00,#04,#5f,#5f,#00,#00,#2a
db #55,#5f,#5f,#bf,#2a,#15,#55,#5f ;U.....U.
db #5f,#aa,#15,#15,#55,#5f,#5f,#1f ;....U...
db #2a,#3f,#55,#5f,#5f,#0a,#15,#3f ;..U.....
db #d7,#5f,#5f,#0a,#00,#3f,#cb,#5f
db #5f,#0a,#00,#3f,#55,#d7,#5f,#0a ;....U...
db #00,#3f,#55,#5f,#5f,#4b,#00,#3f ;..U..K..
db #55,#5f,#5f,#4b,#82,#3f,#55,#5f ;U..K..U.
db #5f,#4b,#c3,#3f,#55,#5f,#61,#4b ;.K..U.aK
db #c3,#3f,#55,#5f,#0a,#4b,#c3,#3f ;..U..K..
db #d7,#5f,#5f,#1e,#c3,#3f,#cb,#5f
db #5f,#1e,#69,#3f,#55,#d7,#5f,#1e ;..i.U...
db #3c,#3f,#55,#5f,#5f,#1e,#3c,#3d ;..U.....
db #55,#5f,#5f,#1e,#3c,#3d,#41,#5f ;U.....A.
db #5f,#1f,#3f,#3f,#41,#d7,#5f,#4b ;....A..K
db #c3,#c3,#45,#45,#55,#4f,#45,#45 ;..EEUOEE
db #8a,#8a,#8a,#0a,#8a,#8a,#00,#00
db #5d,#bf,#2a,#00,#00,#40,#5f,#aa
db #15,#00,#00,#55,#5f,#5f,#00,#2a ;...U....
db #00,#5d,#5f,#5f,#aa,#15,#40,#5f
db #5f,#5f,#bf,#15,#55,#5f,#5f,#5f ;....U...
db #0a,#3f,#55,#5f,#5f,#5f,#1f,#3f ;..U.....
db #55,#5f,#5f,#5f,#0a,#3f,#c3,#d7 ;U.......
db #5f,#5f,#0a,#3f,#df,#c3,#5f,#5f
db #0a,#3f,#55,#4b,#5f,#5f,#0a,#3f ;..UK....
db #55,#5f,#5f,#5f,#0a,#3f,#55,#5f ;U.....U.
db #5f,#5f,#4b,#3f,#55,#5f,#5f,#61 ;..K.U..a
db #4b,#3f,#55,#5f,#5f,#82,#4b,#3f ;K.U...K.
db #55,#5f,#5f,#5f,#4b,#3f,#55,#5f ;U...K.U.
db #5f,#5f,#4b,#3f,#c3,#d7,#5f,#5f ;..K.....
db #1e,#3f,#df,#c3,#5f,#5f,#1e,#3d
db #55,#4b,#5f,#5f,#1e,#3d,#55,#5f ;UK....U.
db #5f,#5f,#1f,#3f,#55,#5f,#5f,#5f ;....U...
db #4b,#c3,#45,#45,#5f,#5f,#4f,#45 ;K.EE..OE
db #8a,#8a,#8a,#5f,#0a,#8a,#00,#00
db #48,#5d,#00,#00,#00,#40,#5f,#5f ;H.......
db #aa,#00,#00,#55,#5f,#5f,#ff,#00 ;...U....
db #00,#5d,#5f,#5f,#ff,#00,#00,#5f
db #5f,#5f,#af,#aa,#40,#5f,#5f,#5f
db #af,#aa,#55,#5f,#5f,#5f,#af,#ff ;..U.....
db #41,#c3,#5f,#5f,#af,#af,#c3,#c3 ;A.......
db #d7,#5f,#af,#af,#df,#5f,#5f,#5f
db #af,#af,#55,#5f,#5f,#5f,#af,#af ;..U.....
db #55,#5f,#5f,#5f,#af,#af,#55,#5f ;U.....U.
db #5f,#5f,#ba,#87,#55,#5f,#5f,#5f ;....U...
db #be,#87,#55,#5f,#5f,#5f,#eb,#05 ;..U.....
db #55,#5f,#5f,#5f,#af,#af,#55,#5f ;U.....U.
db #5f,#5f,#af,#af,#41,#c3,#5f,#5f ;....A...
db #af,#af,#c3,#c3,#d7,#5f,#af,#af
db #df,#5f,#5f,#5f,#af,#af,#55,#5f ;......U.
db #5f,#5f,#af,#af,#55,#5f,#5f,#5f ;....U...
db #af,#af,#45,#5f,#5f,#5f,#af,#af ;..E.....
db #8a,#8a,#5f,#5f,#af,#8a,#00,#15
db #3f,#00,#00,#ff,#00,#2a,#00,#2a
db #00,#ff,#15,#00,#00,#15,#05,#ff
db #2a,#15,#3f,#00,#2f,#af,#2a,#2a
db #00,#2a,#af,#af,#3f,#15,#3f,#15
db #af,#af,#3f,#2a,#00,#3f,#87,#af
db #3f,#00,#00,#15,#0f,#af,#3f,#00
db #00,#15,#0f,#af,#3f,#00,#00,#15
db #af,#af,#3f,#00,#82,#15,#af,#af
db #3f,#41,#c3,#15,#af,#25,#3f,#c3 ;.A......
db #c3,#3d,#0f,#87,#3f,#c3,#96,#3d
db #0f,#05,#3f,#c3,#96,#3d,#af,#af
db #3f,#c3,#3c,#3d,#af,#af,#3f,#96
db #3c,#3d,#af,#af,#3f,#3c,#3c,#3d
db #0f,#af,#3e,#3c,#3c,#3d,#0f,#af
db #3e,#3c,#3c,#3c,#87,#af,#3f,#3f
db #3f,#3f,#0f,#af,#c3,#c3,#c3,#c3
db #af,#af,#45,#45,#45,#45,#05,#af ;..EEEE..
db #8a,#8a,#8a,#8a,#8a,#af,#00,#15
db #3f,#40,#aa,#00,#00,#2a,#00,#5d
db #af,#00,#15,#00,#00,#85,#af,#aa
db #2a,#15,#6a,#af,#af,#aa,#2a,#2a ;..j.....
db #40,#af,#af,#aa,#3f,#15,#6a,#af ;......j.
db #af,#aa,#3f,#2a,#05,#af,#af,#aa
db #3f,#00,#05,#af,#af,#eb,#3f,#00
db #05,#af,#af,#c7,#3f,#00,#05,#af
db #eb,#aa,#3f,#00,#87,#af,#af,#aa
db #3f,#41,#87,#af,#af,#aa,#3f,#c3 ;.A......
db #87,#af,#af,#aa,#3f,#c3,#87,#61 ;.......a
db #af,#aa,#3f,#c3,#87,#aa,#af,#aa
db #3f,#c3,#2d,#af,#af,#eb,#3f,#96
db #2d,#af,#af,#c7,#3f,#3c,#2d,#af
db #eb,#aa,#3e,#3c,#2d,#af,#af,#aa
db #3e,#3c,#2d,#af,#af,#aa,#3f,#3f
db #2f,#af,#af,#00,#c3,#c3,#87,#af
db #eb,#82,#45,#45,#05,#ef,#45,#45 ;..EE..EE
db #8a,#8a,#8f,#8a,#8a,#8a,#00,#15
db #6a,#84,#00,#00,#00,#2a,#04,#af ;j.......
db #aa,#00,#15,#00,#85,#af,#aa,#00
db #2a,#40,#af,#af,#af,#00,#2a,#2e
db #af,#af,#af,#aa,#3f,#05,#af,#af
db #af,#aa,#3f,#2f,#af,#af,#af,#aa
db #3f,#05,#af,#af,#af,#aa,#3f,#05
db #af,#af,#eb,#c3,#3f,#05,#af,#af
db #c3,#ef,#3f,#05,#af,#af,#87,#aa
db #3f,#05,#af,#af,#af,#aa,#3f,#87
db #af,#af,#af,#aa,#3f,#87,#61,#af ;......a.
db #af,#aa,#3f,#87,#82,#af,#af,#aa
db #3f,#87,#af,#af,#af,#aa,#3f,#87
db #af,#af,#af,#aa,#3f,#87,#af,#af
db #eb,#c3,#3e,#87,#af,#af,#c3,#ef
db #3e,#2d,#af,#af,#87,#aa,#3f,#2f
db #af,#af,#af,#aa,#c3,#87,#af,#af
db #af,#aa,#45,#05,#af,#af,#45,#45 ;..E...EE
db #8a,#8f,#af,#8a,#8a,#8a,#00,#00
db #84,#af,#00,#00,#00,#40,#af,#af
db #aa,#00,#00,#d5,#af,#af,#aa,#00
db #00,#5d,#af,#af,#af,#00,#40,#5f
db #af,#af,#af,#00,#04,#5f,#af,#af
db #af,#aa,#d5,#5f,#af,#af,#af,#aa
db #5f,#5f,#af,#af,#c3,#82,#5f,#5f
db #af,#eb,#c3,#c3,#5f,#5f,#af,#af
db #af,#ef,#5f,#5f,#af,#af,#af,#aa
db #5f,#5f,#af,#af,#af,#aa,#1a,#d7
db #af,#af,#af,#aa,#4b,#7d,#af,#af ;....K...
db #af,#aa,#4b,#55,#af,#af,#af,#aa ;..KU....
db #5f,#5f,#af,#af,#af,#aa,#5f,#5f
db #af,#af,#af,#aa,#5f,#5f,#af,#af
db #c3,#82,#5f,#5f,#af,#eb,#c3,#c3
db #5f,#5f,#af,#af,#af,#ef,#5f,#5f
db #af,#af,#af,#aa,#5f,#5f,#af,#af
db #af,#aa,#5f,#5f,#af,#af,#af,#45 ;.......E
db #8a,#5f,#af,#af,#8a,#8a,#00,#00
db #00,#54,#00,#04,#00,#40,#00,#00 ;.T......
db #00,#84,#00,#00,#00,#a8,#40,#08
db #40,#00,#00,#00,#84,#00,#00,#00
db #61,#c2,#08,#00,#10,#30,#0f,#84 ;a.......
db #c3,#82,#25,#0f,#4a,#0d,#cc,#c3 ;....J...
db #92,#c3,#c3,#c3,#c3,#c3,#c3,#30
db #30,#30,#61,#c3,#97,#c3,#c3,#c3 ;..a.....
db #c3,#c3,#c3,#6b,#c3,#c3,#c3,#c3 ;...k....
db #41,#6b,#c3,#c3,#c3,#82,#41,#3f ;Ak....A.
db #c3,#c3,#c3,#82,#41,#97,#6b,#c3 ;....A.k.
db #c3,#82,#00,#c3,#3f,#6b,#c3,#00 ;.....k..
db #00,#45,#c3,#c3,#00,#00,#00,#15 ;.E......
db #cf,#00,#2a,#00,#00,#97,#15,#82
db #6b,#00,#00,#97,#15,#82,#6b,#00 ;k.....k.
db #41,#2a,#15,#82,#15,#82,#41,#2a ;A.....A.
db #15,#82,#15,#82,#97,#00,#15,#82
db #00,#6b,#97,#00,#6b,#c3,#00,#6b ;.k..k..k
db #c3,#00,#3f,#c3,#00,#c3,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#00,#00,#00,#82,#00,#28 ;.A......
db #00,#00,#14,#00,#10,#00,#00,#00
db #20,#54,#a8,#00,#00,#50,#00,#00 ;.T...P..
db #a8,#00,#40,#80,#00,#00,#00,#00
db #40,#00,#00,#00,#0a,#00,#00,#00
db #00,#44,#00,#0a,#00,#00,#00,#08 ;.D......
db #05,#00,#00,#00,#40,#00,#88,#00
db #00,#00,#22,#04,#00,#05,#00,#50 ;.......P
db #00,#80,#00,#88,#00,#50,#11,#00 ;.....P..
db #04,#00,#00,#f0,#22,#00,#80,#00
db #00,#f0,#22,#11,#00,#00,#f0,#b1
db #33,#22,#00,#05,#39,#b1,#33,#28
db #00,#88,#14,#b1,#36,#00,#04,#00
db #00,#33,#22,#00,#80,#00,#50,#36 ;......P.
db #33,#11,#00,#00,#b1,#28,#39,#22
db #00,#00,#36,#00,#14,#22,#00,#00
db #28,#00,#00,#28,#00,#00,#00,#f0
db #f0,#f0,#f0,#a0,#50,#b0,#70,#30 ;....P.p.
db #f0,#55,#f0,#f0,#f0,#f0,#a0,#55 ;.U.....U
db #36,#36,#39,#39,#77,#d7,#f0,#f0 ;....w...
db #f0,#f0,#f5,#aa,#36,#36,#36,#39
db #22,#00,#33,#33,#33,#33,#22,#00
db #36,#39,#39,#39,#22,#00,#33,#33
db #33,#33,#22,#00,#40,#c2,#c3,#c1
db #c0,#00,#40,#c0,#c0,#c0,#c0,#00
db #40,#c3,#c1,#c1,#c0,#00,#40,#c0
db #c0,#c0,#c0,#00,#40,#c1,#c3,#c1
db #c2,#00,#00,#c0,#c0,#c0,#c0,#80
db #00,#c0,#c0,#e4,#c0,#80,#00,#c0
db #c0,#8d,#c0,#80,#00,#c0,#c0,#0f
db #c0,#80,#00,#c0,#c0,#c0,#c0,#80
db #00,#ff,#ff,#ff,#ff,#ff,#55,#c0 ;......U.
db #c0,#c0,#c0,#ff,#ff,#ff,#ff,#ff
db #ff,#55,#eb,#c3,#c3,#c3,#d7,#55 ;.U.....U
db #55,#ff,#ff,#ff,#ff,#aa,#50,#a0 ;U.....P.
db #00,#00,#55,#aa,#a0,#50,#00,#00 ;..U..P..
db #aa,#55,#a0,#a0,#00,#00,#55,#55 ;.U....UU
db #a0,#00,#f0,#f5,#00,#55,#b1,#72 ;.....U.r
db #e0,#84,#ff,#ff,#a0,#33,#62,#84 ;......b.
db #5d,#55,#a0,#11,#62,#84,#08,#55 ;.U..b..U
db #a0,#11,#62,#84,#08,#55,#a0,#11 ;..b..U..
db #62,#84,#08,#55,#50,#11,#62,#84 ;b..UP.b.
db #08,#aa,#50,#26,#62,#84,#5d,#aa ;..P.b...
db #00,#19,#48,#ae,#ff,#00,#00,#26 ;..H.....
db #77,#84,#ff,#00,#00,#11,#48,#48 ;w.....HH
db #aa,#00,#00,#55,#77,#d5,#aa,#00 ;...Uw...
db #00,#00,#bb,#ff,#00,#00,#00,#00
db #11,#aa,#00,#00,#00,#00,#11,#aa
db #00,#00,#00,#00,#11,#aa,#00,#00
db #00,#00,#11,#aa,#00,#00,#00,#00
db #11,#aa,#00,#00,#00,#00,#b1,#ff
db #00,#00,#00,#f0,#33,#33,#ff,#00
db #50,#b1,#33,#26,#5d,#aa,#11,#00 ;P.......
db #00,#00,#00,#22,#22,#aa,#00,#00
db #11,#55,#22,#aa,#00,#00,#55,#55 ;.U....UU
db #00,#ea,#c0,#ff,#ff,#00,#00,#ba
db #10,#10,#55,#00,#00,#90,#10,#50 ;..U....P
db #55,#00,#00,#32,#10,#50,#55,#00 ;U....PU.
db #00,#32,#50,#50,#55,#00,#00,#d0 ;..PPU...
db #50,#10,#55,#00,#00,#d0,#50,#50 ;P.U...PP
db #55,#00,#40,#50,#50,#10,#10,#aa ;U..PP...
db #40,#50,#50,#10,#10,#aa,#62,#50 ;.PP...bP
db #10,#10,#10,#ff,#62,#50,#50,#10 ;....bPP.
db #10,#ff,#77,#50,#10,#10,#10,#ff ;..wP....
db #77,#10,#10,#10,#10,#ff,#77,#50 ;w.....wP
db #10,#10,#10,#ff,#62,#10,#10,#10 ;....b...
db #10,#ff,#62,#10,#10,#10,#10,#ff ;..b.....
db #40,#90,#10,#10,#55,#aa,#55,#c0 ;....U.U.
db #10,#10,#ff,#aa,#00,#ea,#c0,#d5
db #ff,#00,#00,#55,#d5,#ff,#aa,#00 ;...U....
db #00,#00,#ff,#ff,#00,#00,#cc,#cc
db #cc,#3c,#3c,#3c,#8d,#0f,#0f,#c3
db #c3,#c7,#8d,#0f,#0f,#c3,#c3,#c7
db #c8,#4a,#85,#c3,#c3,#c5,#8d,#c0 ;.J......
db #c0,#c0,#c0,#c7,#c8,#c0,#0f,#c2
db #c2,#c7,#8d,#0f,#0f,#c3,#c3,#c7
db #c8,#4a,#85,#c3,#c3,#c5,#8d,#c0 ;.J......
db #c0,#c0,#c0,#c7,#c8,#c0,#0f,#c2
db #c2,#c7,#8d,#0f,#0f,#c3,#c3,#c7
db #69,#c3,#c3,#0f,#a5,#4b,#69,#c3 ;i....Ki.
db #c3,#5a,#f0,#4b,#29,#cc,#43,#f0 ;.Z.K..C.
db #5a,#e1,#6c,#46,#c9,#a5,#0f,#e1 ;Z.lF....
db #6c,#85,#c9,#0f,#a5,#4b,#6c,#4a ;l....KlJ
db #c9,#5a,#f0,#4b,#6c,#89,#c9,#f0 ;.Z.Kl...
db #5a,#e1,#29,#cc,#43,#a5,#0f,#e1 ;Z...C...
db #41,#c3,#c3,#0f,#a5,#0a,#45,#c3 ;A.....E.
db #c3,#5a,#f0,#82,#00,#cb,#c3,#f0 ;.Z......
db #1f,#00,#00,#45,#c3,#a5,#82,#00 ;...E....
db #00,#00,#cf,#c3,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c0,#84,#00,#00,#00,#40
db #0c,#4c,#88,#00,#00,#84,#f0,#f0 ;.L......
db #cc,#00,#40,#58,#f0,#f0,#e4,#88 ;...X....
db #04,#f0,#b0,#70,#33,#88,#50,#f0 ;...p..P.
db #30,#30,#33,#22,#d0,#b0,#35,#92
db #31,#66,#f0,#b0,#7a,#00,#31,#37 ;.f..z...
db #f0,#30,#82,#00,#30,#37,#f0,#b0
db #00,#00,#31,#37,#f0,#32,#20,#10
db #93,#3f,#58,#b1,#30,#61,#33,#2f ;..X..a..
db #50,#b1,#63,#93,#37,#2a,#04,#f0 ;P.c.....
db #33,#33,#3f,#0a,#00,#5a,#b1,#37 ;.....Z..
db #2f,#00,#00,#05,#3f,#3f,#0a,#00
db #00,#00,#0f,#0f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c0,#84,#00,#00,#00,#40
db #ff,#ff,#88,#00,#00,#d5,#0c,#0c
db #ee,#00,#40,#ae,#0c,#0c,#5d,#88
db #04,#0c,#b0,#70,#0c,#88,#04,#58 ;...p...X
db #30,#30,#26,#88,#84,#b0,#35,#92
db #31,#cc,#58,#b0,#7a,#00,#31,#6e ;..X.z..n
db #f0,#30,#82,#00,#30,#3f,#f0,#b0
db #00,#00,#31,#3f,#d8,#32,#20,#10
db #97,#2f,#cc,#b1,#30,#61,#3f,#0f ;.....a..
db #44,#1b,#63,#97,#2f,#0a,#44,#0f ;D.c...D.
db #3f,#3f,#0f,#0a,#00,#8d,#0f,#0f
db #0f,#00,#00,#05,#0f,#0f,#0a,#00
db #00,#00,#0f,#0f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c0,#84,#00,#00,#00,#40
db #ff,#ff,#88,#00,#00,#d5,#4c,#cc ;......L.
db #ee,#00,#40,#ae,#ff,#ff,#dd,#88
db #04,#5d,#0c,#4c,#ee,#88,#04,#ae ;...L....
db #0c,#0c,#dd,#88,#d5,#0c,#35,#92
db #cc,#ee,#0c,#18,#7a,#00,#64,#cc ;....z.d.
db #58,#30,#82,#00,#35,#6e,#8d,#b0 ;X....n..
db #00,#00,#3f,#0f,#cc,#1a,#20,#15
db #2f,#0f,#cc,#0f,#3f,#3f,#0f,#5f
db #44,#0f,#0f,#0f,#0f,#0a,#44,#0f ;D.....D.
db #0f,#0f,#0f,#aa,#00,#8d,#0f,#0f
db #5f,#00,#00,#44,#0f,#0f,#aa,#00 ;...D....
db #00,#00,#8d,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#c0,#84,#00,#00,#00,#40
db #ff,#ff,#88,#00,#00,#d5,#0c,#0c
db #ee,#00,#40,#ae,#0c,#0c,#5d,#88
db #04,#0c,#b0,#70,#0c,#88,#04,#58 ;...p...X
db #30,#30,#26,#88,#84,#b0,#35,#92
db #31,#cc,#58,#b0,#7a,#00,#31,#6e ;..X.z..n
db #f0,#30,#82,#00,#30,#3f,#f0,#b0
db #00,#00,#31,#3f,#d8,#32,#20,#10
db #97,#2f,#cc,#b1,#30,#61,#3f,#0f ;.....a..
db #44,#1b,#63,#97,#2f,#0a,#44,#8d ;D.c...D.
db #3f,#3f,#0f,#0a,#00,#8d,#0f,#0f
db #0f,#00,#00,#05,#0f,#0f,#0a,#00
db #00,#00,#0f,#0f,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#f0,#f0,#c0,#80,#50,#f0 ;......P.
db #c0,#c0,#d5,#ef,#50,#31,#62,#60 ;....P.b.
db #d5,#4f,#50,#31,#32,#bd,#d5,#4f ;.OP....O
db #50,#31,#32,#bd,#d5,#4f,#50,#b1 ;P....OP.
db #32,#bd,#d5,#ef,#50,#b1,#62,#6a ;....P.bj
db #d5,#ef,#00,#b1,#62,#c0,#ff,#8a ;....b...
db #00,#df,#33,#d5,#ff,#8a,#00,#45 ;.......E
db #ff,#ff,#ef,#00,#00,#00,#df,#ff
db #8a,#00,#00,#00,#45,#cf,#00,#00 ;....E...
db #00,#00,#55,#cf,#00,#00,#00,#00 ;..U.....
db #55,#cf,#00,#00,#00,#00,#11,#cf ;U.......
db #00,#00,#00,#00,#11,#ef,#00,#00
db #00,#00,#11,#ef,#00,#00,#00,#00
db #50,#c5,#00,#00,#00,#00,#e0,#d5 ;P.......
db #8a,#00,#00,#50,#e0,#c0,#ef,#00 ;...P....
db #00,#f0,#f5,#ff,#cf,#8a,#00,#00
db #00,#00,#00,#85,#00,#00,#00,#00
db #00,#0d,#00,#00,#00,#00,#00,#0d
db #00,#00,#00,#80,#40,#0a,#00,#00
db #40,#55,#04,#0a,#00,#00,#40,#aa ;.U......
db #84,#0a,#00,#00,#40,#aa,#0d,#00
db #00,#00,#00,#d5,#af,#00,#00,#00
db #00,#50,#ff,#aa,#00,#00,#00,#10 ;.P......
db #75,#55,#00,#00,#00,#b0,#55,#aa ;uU....U.
db #00,#00,#00,#34,#00,#00,#00,#00
db #50,#20,#00,#00,#00,#00,#10,#28 ;P.......
db #00,#00,#00,#00,#b0,#00,#00,#00
db #00,#00,#34,#00,#00,#00,#00,#50 ;.......P
db #20,#00,#00,#00,#00,#10,#28,#00
db #00,#00,#00,#b0,#00,#00,#00,#00
db #00,#34,#00,#00,#00,#00,#50,#20 ;......P.
db #00,#00,#00,#00,#10,#28,#00,#00
db #00,#00,#b0,#00,#00,#00,#00,#00
db #34,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#30,#30
db #00,#00,#00,#30,#c3,#c3,#30,#00
db #10,#61,#00,#00,#92,#82,#10,#82 ;.a......
db #00,#00,#50,#82,#10,#82,#00,#00 ;..P.....
db #50,#82,#10,#82,#50,#a0,#50,#82 ;P...P.P.
db #10,#20,#50,#82,#10,#00,#00,#70 ;..P....p
db #b0,#c3,#61,#00,#00,#10,#30,#92 ;..a.....
db #82,#00,#00,#00,#92,#c3,#00,#00
db #00,#00,#10,#82,#00,#00,#0f,#5f
db #ff,#af,#ff,#ff,#ff,#af,#0f,#5f
db #0f,#0f,#ff,#ff,#ff,#ff,#ff,#ff
db #0f,#0f,#ff,#0f,#0f,#0f,#ff,#ff
db #ff,#ff,#ff,#ff,#0f,#5f,#0f,#ff
db #af,#0f,#ff,#af,#ff,#0f,#5f,#ff
db #0f,#ff,#ff,#ff,#ff,#0f,#00,#00
db #45,#8a,#00,#00,#00,#00,#cf,#47 ;E......G
db #00,#00,#00,#00,#8b,#cb,#00,#00
db #00,#00,#8b,#cb,#00,#00,#00,#00
db #8b,#cb,#00,#00,#00,#00,#8b,#cb
db #00,#00,#00,#00,#8b,#cb,#00,#00
db #00,#00,#8b,#cb,#00,#00,#00,#00
db #8b,#cb,#00,#00,#00,#00,#8b,#cb
db #00,#00,#00,#50,#8b,#cb,#82,#00 ;...P....
db #00,#10,#8b,#cb,#82,#00,#00,#41 ;.......A
db #8b,#cb,#82,#00,#00,#00,#8b,#cb
db #00,#00,#00,#00,#8b,#cb,#00,#00
db #00,#00,#8b,#cb,#00,#00,#00,#00
db #8b,#cb,#00,#00,#00,#00,#8b,#cb
db #00,#00,#00,#00,#8b,#cb,#00,#00
db #00,#00,#8b,#cb,#00,#00,#00,#00
db #8b,#cb,#00,#00,#00,#00,#8b,#cb
db #00,#00,#00,#00,#8b,#cb,#00,#00
db #00,#00,#cf,#cf,#00,#00,#cc,#00
db #00,#00,#00,#cc,#99,#72,#80,#11 ;.....r..
db #e0,#af,#99,#72,#d5,#99,#e0,#af ;...r....
db #99,#63,#d7,#33,#c3,#af,#99,#d2 ;.c......
db #c1,#63,#e1,#af,#99,#72,#d5,#33 ;.c...r..
db #e0,#af,#99,#63,#d7,#33,#c3,#af ;...c....
db #99,#d2,#c1,#63,#e0,#af,#99,#72 ;...c...r
db #d5,#33,#e0,#af,#99,#63,#d7,#33 ;.....c..
db #c3,#af,#99,#d2,#c3,#63,#c2,#af ;.....c..
db #99,#72,#d5,#33,#e0,#af,#99,#63 ;.r.....c
db #d7,#33,#c3,#af,#99,#d2,#c1,#63 ;.......c
db #c2,#af,#99,#72,#d5,#33,#e0,#af ;...r....
db #99,#63,#d7,#33,#c3,#af,#99,#c3 ;.c......
db #c1,#63,#e0,#af,#99,#72,#d5,#33 ;.c...r..
db #e0,#af,#99,#72,#d5,#33,#e0,#af ;...r....
db #99,#63,#d5,#33,#c2,#af,#99,#72 ;.c.....r
db #d5,#33,#e0,#af,#8d,#0f,#5f,#27
db #0f,#0f,#00,#0f,#0f,#27,#0f,#00
db #00,#00,#05,#0a,#00,#00,#00,#00
db #50,#a0,#00,#b1,#00,#00,#50,#a0 ;P.....P.
db #00,#b1,#00,#00,#50,#22,#50,#b1 ;....P.P.
db #00,#00,#50,#80,#50,#33,#00,#00 ;..P.P...
db #50,#80,#3d,#22,#00,#00,#b1,#c0 ;P.......
db #6b,#82,#00,#00,#b1,#94,#6b,#00 ;k.....k.
db #00,#00,#b1,#95,#c3,#00,#00,#00
db #b1,#3d,#82,#00,#00,#00,#b1,#6b ;.......k
db #82,#00,#00,#50,#b4,#6b,#aa,#00 ;...P.k..
db #00,#50,#37,#c3,#aa,#00,#00,#50 ;.P.....P
db #3d,#d7,#80,#00,#00,#50,#6b,#d7 ;.....Pk.
db #80,#00,#00,#14,#6b,#ea,#80,#00 ;....k...
db #00,#15,#c3,#ea,#c0,#00,#00,#3d
db #d7,#c1,#c0,#00,#00,#6b,#d7,#c2 ;.....k..
db #c0,#00,#14,#6b,#ea,#c2,#c2,#aa ;...k....
db #50,#c3,#ea,#c1,#c0,#ff,#f0,#77 ;P......w
db #c0,#c0,#c0,#d5,#b1,#77,#ea,#c0 ;.....w..
db #ff,#ff,#b1,#ff,#ff,#ff,#ff,#aa
db #33,#55,#ff,#ff,#aa,#00,#08,#00 ;.U......
db #00,#00,#00,#00,#04,#00,#55,#d7 ;......U.
db #00,#00,#04,#aa,#ff,#d7,#00,#00
db #00,#ff,#eb,#af,#00,#00,#00,#ff
db #ff,#0a,#00,#00,#00,#ff,#af,#00
db #00,#00,#00,#bb,#aa,#00,#00,#00
db #00,#33,#22,#00,#00,#00,#00,#33
db #aa,#00,#00,#00,#00,#bb,#af,#00
db #00,#00,#04,#77,#77,#0a,#00,#00 ;...ww...
db #04,#ff,#bb,#af,#00,#00,#55,#ff ;......U.
db #ff,#af,#00,#00,#5d,#ff,#77,#ff ;......w.
db #0a,#00,#5d,#bb,#bb,#ff,#0f,#00
db #ff,#ea,#ff,#ff,#af,#00,#ff,#ff
db #d5,#ff,#af,#0a,#ff,#ff,#ea,#ff
db #ff,#0f,#ff,#ea,#ea,#ff,#ff,#0f
db #ff,#ff,#d5,#ff,#ff,#0f,#55,#ff ;......U.
db #ff,#ff,#af,#0f,#55,#ff,#ff,#ff ;....U...
db #0f,#0f,#05,#0f,#0f,#0f,#0f,#0a
db #00,#0f,#0f,#0f,#0f,#00,#00,#00
db #f0,#a0,#00,#00,#00,#50,#b1,#32 ;.....P..
db #00,#00,#00,#f0,#32,#30,#20,#00
db #00,#b1,#30,#28,#00,#00,#50,#b1 ;......P.
db #34,#00,#50,#00,#50,#32,#28,#50 ;..P.P..P
db #f0,#b1,#50,#36,#00,#00,#f0,#22 ;..P.....
db #f0,#34,#00,#00,#b1,#22,#b1,#34
db #00,#50,#00,#11,#b0,#28,#00,#00 ;.P......
db #00,#00,#b0,#28,#00,#00,#00,#00
db #b0,#28,#00,#00,#00,#00,#b0,#28
db #00,#00,#00,#00,#b1,#28,#00,#00
db #00,#00,#b1,#20,#00,#00,#00,#50 ;.......P
db #31,#33,#00,#00,#00,#50,#31,#33 ;.....P..
db #00,#00,#00,#b0,#10,#33,#00,#00
db #50,#32,#10,#33,#22,#00,#f0,#34 ;P.......
db #00,#31,#33,#f0,#b1,#34,#00,#31
db #33,#33,#30,#28,#00,#10,#33,#33
db #34,#28,#00,#00,#30,#30,#3c,#00
db #00,#00,#14,#3c,#28,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#14,#28,#00,#00,#00,#b0,#28
db #41,#00,#00,#50,#10,#69,#00,#00 ;A..P.i..
db #00,#00,#30,#28,#00,#00,#00,#00
db #10,#28,#14,#00,#00,#00,#10,#28
db #00,#00,#00,#00,#10,#20,#00,#00
db #00,#00,#10,#20,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#50,#00,#41,#82,#00,#50 ;..P.A..P
db #50,#00,#c3,#41,#00,#00,#10,#00 ;P..A....
db #00,#00,#00,#a0,#10,#00,#00,#28
db #00,#20,#10,#00,#00,#28,#00,#20
db #10,#00,#00,#14,#00,#00,#10,#28
db #00,#00,#50,#00,#10,#28,#00,#00 ;..P.....
db #00,#00,#b0,#82,#00,#00,#00,#00
db #b0,#28,#00,#00,#00,#00,#10,#28
db #00,#00,#00,#00,#10,#28,#00,#00
db #00,#00,#10,#20,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#a0,#00,#00,#00,#00,#50 ;.......P
db #00,#00,#00,#50,#a0,#20,#00,#00 ;...P....
db #00,#b0,#30,#20,#00,#00,#00,#00
db #61,#30,#34,#00,#00 ;a....
lab9EEF db #0
db #30,#30,#c3,#00,#00,#00,#30,#3c
db #00,#28,#50,#00,#30,#69,#00,#28 ;..P..i..
db #00,#00,#10,#28,#41,#28,#00,#00 ;....A...
db #10,#28,#41,#3c,#00,#a0,#10,#28 ;..A.....
db #00,#82,#00,#00,#10,#28,#00,#00
db #00,#50,#10,#28,#00,#00,#00,#00 ;.P......
db #10,#28,#00,#00,#00,#00,#10,#28
db #00,#00,#00,#00,#10,#20,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#14,#00,#00
db #00,#00,#00,#20,#00,#00,#00,#00
db #00,#20,#00,#00,#00,#00,#00,#20
db #00,#00,#00,#a0,#00,#20,#14,#00
db #00,#a0,#10,#28,#28,#00,#50,#20 ;......P.
db #10,#28,#00,#00,#50,#20,#10,#3c ;....P...
db #00,#00,#50,#00,#10,#28,#28,#00 ;..P.....
db #b0,#00,#10,#28,#3c,#00,#10,#00
db #10,#28,#96,#00,#10,#00,#10,#28
db #41,#00,#00,#00,#10,#28,#41,#28 ;A.....A.
db #a0,#00,#10,#28,#82,#00,#00,#00
db #10,#28,#82,#00,#00,#00,#10,#28
db #41,#00,#00,#00,#10,#28,#00,#00 ;A.......
db #50,#00,#10,#28,#00,#00,#00,#00 ;P.......
db #10,#20,#00,#00,#00,#00,#10,#28
db #00,#00,#00,#00,#10,#20,#00,#00
db #00,#00,#0a,#00,#00,#00,#00,#0f
db #8d,#00,#00,#00,#05,#cc,#cc,#0a
db #00,#00,#4e,#cc,#cc,#00,#05,#0a ;..N.....
db #44,#04,#08,#00,#0f,#0f,#88,#0c ;D.......
db #0c,#05,#cc,#8d,#00,#0c,#80,#04
db #0c,#8d,#04,#08,#84,#0c,#4c,#0f ;......L.
db #00,#48,#40,#84,#5d,#82,#4e,#19 ;.H....N.
db #33,#26,#af,#00,#4e,#19,#f0,#62 ;....N..b
db #eb,#00,#0a,#48,#72,#62,#eb,#00 ;...Hrb..
db #4e,#48,#91,#c4,#0a,#00,#05,#8c ;NH......
db #c0,#80,#41,#00,#05,#cc,#84,#5d ;..A.....
db #00,#82,#00,#00,#cc,#ff,#aa,#00
db #00,#ff,#ff,#eb,#ff,#eb,#cc,#00
db #ff,#c3,#41,#82,#5f,#aa,#55,#aa ;..A...U.
db #00,#00,#05,#4b,#00,#00,#00,#00 ;...K....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #0a,#00,#00,#00,#00,#0f,#0f,#00
db #00,#00,#05,#0f,#8d,#00,#00,#00
db #00,#44,#88,#00,#05,#0a,#00,#cc ;.D......
db #cc,#00,#0f,#0a,#00,#cc,#08,#4c ;.......L
db #cc,#0a,#00,#8c,#84,#0c,#8d,#0a
db #00,#8c,#40,#0c,#dd,#00,#00,#c8
db #c0,#84,#88,#00,#05,#c8,#f0,#84
db #aa,#00,#00,#8c,#72,#26,#aa,#00 ;....r...
db #05,#c8,#91,#84,#aa,#00,#00,#0e
db #48,#08,#41,#00,#00,#0f,#0c,#5d ;H.A.....
db #00,#00,#00,#00,#0f,#ff,#aa,#00
db #00,#ff,#ff,#eb,#d7,#82,#55,#00 ;......U.
db #ff,#82,#00,#00,#55,#82,#00,#00 ;....U...
db #00,#00,#00,#00,#00,#00,#00,#00
labA0C8 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#0a,#00,#00
db #00,#00,#0f,#0a,#00,#00,#00,#00
db #05,#0a,#00,#00,#00,#00,#05,#0a
db #00,#05,#00,#00,#05,#88,#00,#0f
db #00,#00,#44,#4c,#44,#0a,#00,#00 ;..DLD...
db #44,#04,#88,#0a,#00,#00,#04,#c0 ;D.......
db #4c,#00,#00,#00,#00,#91,#4c,#0a ;L.....L.
db #00,#00,#0f,#19,#80,#00,#00,#00
db #0e,#48,#08,#00,#00,#00,#44,#8c ;.H....D.
db #88,#00,#00,#00,#05,#cc,#8d,#00
db #00,#00,#00,#0a,#0f,#0a,#00,#00
db #0a,#05,#0a,#05,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#0a,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#0a
db #00,#00,#00,#00,#00,#0a,#00,#00
db #00,#00,#00,#8d,#05,#aa,#00,#00
db #00,#05,#0a,#00,#00,#00,#00,#0c
db #dd,#00,#00,#00,#00,#40,#c9,#00
db #00,#00,#00,#c8,#08,#00,#00,#00
db #44,#8c,#aa,#00,#00,#00,#00,#ee ;D.......
db #aa,#00,#00,#00,#00,#5f,#d7,#00
db #00,#00,#00,#00,#00,#82,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#40,#00,#00
db #00,#00,#00,#40,#0a,#00,#00,#00
db #00,#f0,#80,#00,#00,#00,#00,#f0
db #85,#00,#00,#00,#00,#f0,#85,#00
db #00,#00,#00,#f0,#85,#00,#00,#00
db #00,#f0,#85,#00,#00,#00,#50,#f0 ;......P.
db #c0,#00,#00,#50,#f0,#f0,#f0,#d0 ;...P....
db #00,#f0,#f0,#f0,#f0,#f0,#a0,#c0
db #f0,#f0,#f0,#f0,#85,#40,#c0,#d0
db #e0,#c0,#0f,#00,#4a,#d0,#c0,#0f ;....J...
db #0a,#00,#00,#f0,#85,#0a,#00,#00
db #00,#f0,#85,#00,#00,#00,#00,#f0
db #85,#00,#00,#00,#00,#f0,#85,#00
db #00,#00,#00,#f0,#85,#00,#00,#00
db #00,#40,#0f,#00,#00,#00,#00,#40
db #0a,#00,#00,#00,#00,#00,#0a,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#40,#00,#00,#00,#00,#00
db #40,#0a,#00,#00,#00,#00,#50,#80 ;......P.
db #00,#00,#00,#00,#50,#85,#00,#00 ;....P...
db #00,#00,#50,#85,#00,#00,#00,#00 ;..P.....
db #50,#e0,#00,#50,#a5,#00,#50,#e0 ;P..P..P.
db #0a,#f0,#80,#00,#00,#f0,#f0,#e0
db #0a,#00,#00,#f0,#f0,#e0,#00,#00
db #00,#f0,#f0,#85,#00,#00,#50,#f0 ;......P.
db #e0,#0a,#00,#00,#f0,#f0,#e0,#0a
db #00,#50,#e0,#c0,#e0,#0a,#00,#e0 ;.P......
db #c0,#0a,#f0,#80,#00,#c0,#0f,#0a
db #f0,#80,#00,#05,#0a,#00,#50,#85 ;......P.
db #00,#00,#00,#00,#50,#85,#00,#00 ;....P...
db #00,#00,#50,#85,#00,#00,#00,#00 ;..P.....
db #00,#85,#00,#00,#00,#00,#00,#85
db #00,#00,#00,#00,#00,#05,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#50 ;.......P
db #00,#00,#00,#50,#0a,#40,#f0,#00 ;...P....
db #50,#e0,#0a,#05,#d0,#a0,#f0,#85 ;P.......
db #00,#00,#d0,#a5,#f0,#85,#00,#00
db #4a,#f0,#e0,#0a,#00,#00,#40,#f0 ;J.......
db #e0,#0a,#00,#00,#40,#d0,#e0,#0a
db #00,#00,#05,#f0,#a5,#00,#00,#00
db #00,#f0,#a0,#00,#00,#00,#50,#f0 ;......P.
db #f0,#00,#00,#00,#50,#f0,#f0,#00 ;....P...
db #00,#00,#50,#e0,#f0,#00,#00,#00 ;..P.....
db #f0,#85,#d0,#a0,#00,#00,#e0,#85
db #c0,#a0,#00,#50,#c0,#0a,#4a,#d0 ;...P..J.
db #00,#40,#0f,#00,#05,#4a,#0a,#05 ;.....J..
db #00,#00,#00,#05,#0a,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#40,#00,#00,#00
db #00,#00,#40,#0a,#00,#00,#00,#00
db #e0,#0a,#00,#00,#00,#00,#e0,#0a
db #00,#00,#00,#00,#e0,#0a,#00,#f0
db #00,#50,#e0,#0a,#00,#d0,#a0,#50 ;.P.....P
db #e0,#0a,#00,#4a,#f0,#f0,#a5,#00 ;...J....
db #00,#40,#d0,#f0,#a5,#00,#00,#05
db #c0,#f0,#a5,#00,#00,#00,#4a,#f0 ;......J.
db #f0,#00,#00,#00,#40,#f0,#f0,#a0
db #00,#00,#50,#e0,#c0,#f0,#00,#00 ;..P.....
db #f0,#85,#4a,#c0,#80,#00,#f0,#80 ;..J.....
db #05,#4a,#85,#00,#e0,#0a,#00,#05 ;.J......
db #0f,#00,#e0,#0a,#00,#00,#00,#00
db #e0,#0a,#00,#00,#00,#00,#85,#00
db #00,#00,#00,#00,#85,#00,#00,#00
db #00,#00,#05,#00,#00,#00,#00,#00
db #00,#50,#00,#00,#00,#00,#00,#b0 ;.P......
db #20,#00,#00,#00,#00,#34,#20,#00
db #00,#00,#50,#61,#3c,#00,#00,#00 ;..Pa....
db #10,#96,#3c,#00,#00,#5d,#10,#3c
db #3c,#00,#00,#5d,#7d,#55,#55,#28 ;.....UU.
db #00,#34,#04,#0c,#5d,#00,#04,#34
db #04,#0c,#5d,#00,#24,#34,#cd,#0d
db #ef,#9a,#7d,#34,#6d,#df,#8f,#34 ;....m...
db #28,#34,#6d,#8f,#0f,#3c,#28,#14 ;..m.....
db #6d,#0f,#0f,#3c,#00,#45,#6d,#0f ;m....Em.
db #0f,#28,#00,#05,#8f,#0f,#0f,#8a
db #00,#00,#0f,#0f,#0f,#8a,#00,#00
db #0f,#0f,#0f,#0a,#00,#00,#8d,#0f
db #0f,#0a,#00,#00,#8d,#0f,#0f,#4f ;.......O
db #00,#00,#8d,#4f,#0f,#cf,#00,#44 ;...O...D
db #0f,#0f,#8f,#4f,#00,#cc,#0f,#0f ;...O....
db #4f,#8f,#8a,#8d,#cf,#4f,#4f,#cf ;O....OO.
db #8a,#45,#cf,#cf,#df,#ff,#cf,#00 ;.E......
db #00,#50,#b0,#00,#00,#00,#00,#b0 ;.P......
db #30,#20,#00,#00,#00,#34,#20,#14
db #00,#00,#50,#30,#96,#00,#00,#00 ;..P.....
db #10,#69,#3c,#00,#00,#04,#ba,#3c ;.i......
db #3c,#00,#00,#04,#ae,#aa,#aa,#28
db #aa,#10,#2c,#0c,#5d,#55,#aa,#10 ;.....U..
db #2c,#0c,#5d,#10,#28,#10,#6d,#5d ;......m.
db #4f,#9a,#28,#10,#6d,#df,#8f,#34 ;O...m...
db #28,#10,#6d,#8f,#0f,#34,#28,#10 ;..m.....
db #6d,#0f,#0f,#3c,#00,#45,#6d,#0f ;m....Em.
db #0f,#28,#00,#05,#8f,#0f,#0f,#8a
db #00,#00,#0f,#0f,#0f,#8a,#00,#00
db #0f,#0f,#0f,#0a,#00,#00,#8d,#0f
db #0f,#0a,#00,#00,#8d,#0f,#0f,#cf
db #00,#00,#8d,#4f,#0f,#4f,#00,#44 ;...O.O.D
db #0f,#0f,#8f,#4f,#00,#cc,#0f,#0f ;...O....
db #4f,#8f,#00,#8d,#4f ;O...O
labA556 db #f
db #4f,#ef,#8a,#45,#cf,#cf,#df,#ff ;O..E....
db #cf,#00,#00,#50,#00,#00,#00,#00 ;...P....
db #00,#b0,#20,#00,#00,#00,#00,#34
db #20,#00,#00,#00,#50,#61,#3c,#00 ;....Pa..
db #00,#00,#10,#96,#3c,#00,#00,#00
db #5d,#3c,#3c,#55,#aa,#00,#5d,#55 ;...U...U
db #55,#7d,#aa,#00,#34,#0c,#5d,#10 ;U.......
db #28,#00,#34,#0c,#5d,#10,#28,#10
db #3c,#0d,#ef,#3c,#28,#10,#6d,#df ;......m.
db #8f,#34,#00,#10,#6d,#8f,#0f,#3c ;....m...
db #00,#10,#6d,#0f,#0f,#28,#00,#45 ;..m....E
db #6d,#0f,#0f,#8a,#00,#05,#8f,#0f ;m.......
db #0f,#8a,#00,#00,#0f,#0f,#0f,#8a
db #00,#00,#0f,#0f,#0f,#0a,#00,#00
db #8d,#0f,#0f,#0a,#00,#00,#8d,#0f
db #0f,#4f,#00,#00,#8d,#0f,#8f,#cf ;.O......
db #00,#44,#0f,#0f,#4f,#4f,#00,#cc ;.D..OO..
db #0f,#0f,#4f,#8f,#8a,#8d,#0f,#cf ;..O.....
db #4f,#cf,#8a,#45,#ff,#ef,#df,#ff ;O..E....
db #cf,#00,#50,#b4,#00,#00,#00,#00 ;..P.....
db #b0,#30,#28,#00,#00,#50,#00,#34 ;.....P..
db #28,#00,#00,#00,#10,#96,#3c,#00
db #00,#00,#41,#3c,#3c,#00,#00,#04 ;..A.....
db #ba,#3c,#3c,#00,#00,#04,#aa,#aa
db #ff,#28,#aa,#10,#2c,#0c,#ff,#55 ;.......U
db #aa,#10,#2c,#0c,#ff,#10,#28,#10
db #6d,#0e,#ef,#9a,#28,#10,#6d,#df ;m.....m.
db #8f,#34,#28,#10,#6d,#8f,#0f,#34 ;....m...
db #28,#10,#6d,#0f,#0f,#3c,#00,#45 ;..m....E
db #6d,#0f,#0f,#28,#00,#05,#8f,#0f ;m.......
db #0f,#8a,#00,#00,#0f,#0f,#0f,#8a
db #00,#00,#0f,#0f,#0f,#0a,#00,#00
db #8d,#0f,#0f,#0a,#00,#00,#8d,#0f
db #8f,#4f,#00,#00,#8d,#0f,#4f,#cf ;.O....O.
db #00,#44,#0f,#0f,#0f,#4f,#00,#cc ;.D...O..
db #0f,#0f,#4f,#8f,#8a,#8d,#5f,#8f ;..O.....
db #4f,#cf,#8a,#45,#ff,#ef,#cf,#cf ;O..E....
db #cf,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#d5,#ff,#ff,#c1 ;...U....
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#ff,#ff,#ff
db #ff,#ff,#82,#ff,#ff,#33,#77,#ff ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#fa,#bb,#fc,#fc,#bb ;T.......
db #82,#11,#ff,#fc,#fd,#bb,#00,#55 ;.......U
db #f5,#ff,#ff,#63,#00,#55,#22,#00 ;...c.U..
db #00,#63,#00,#55,#bb,#00,#11,#c3 ;.c.U....
db #00,#00,#aa,#00,#00,#82,#00,#00
db #ff,#00,#55,#82,#00,#00,#55,#ff ;..U...U.
db #eb,#00,#00,#00,#00,#c3,#82,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#d5,#ff,#ff,#c1 ;...U....
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#ff,#ff,#ff
db #ff,#ff,#82,#bb,#ff,#33,#77,#bb ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#fa,#bb,#fc,#fc,#bb ;T.......
db #82,#55,#77,#fc,#fd,#63,#00,#55 ;.Uw..c.U
db #f5,#ff,#ff,#63,#00,#55,#bb,#00 ;...c.U..
db #11,#c3,#00,#00,#aa,#00,#00,#82
db #00,#00,#ff,#00,#55,#82,#00,#00 ;....U...
db #55,#ff,#eb,#00,#00,#00,#00,#eb ;U.......
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#f5,#ff,#ff,#49 ;...U...I
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#bb,#ff,#ff
db #ff,#bb,#82,#bb,#ff,#33,#77,#bb ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#ff,#33,#fc,#fc,#63 ;T......c
db #00,#55,#77,#fc,#fd,#63,#00,#55 ;.Uw..c.U
db #bb,#ff,#bb,#c3,#00,#00,#aa,#00
db #00,#82,#00,#00,#ff,#00,#55,#82 ;......U.
db #00,#00,#55,#ff,#eb,#00,#00,#00 ;..U.....
db #00,#eb,#82,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#aa,#00,#00,#00,#00,#82,#ff
db #00,#00,#00,#41,#82,#af,#aa,#00 ;...A....
db #00,#af,#82,#af,#aa,#00,#00,#af
db #82,#af,#aa,#eb,#82,#af,#82,#55 ;.......U
db #55,#ff,#eb,#41,#00,#55,#ff,#ff ;U..A.U..
db #ff,#c3,#00,#55,#d5,#ff,#ff,#c1 ;...U....
db #00,#55,#ea,#d5,#c0,#eb,#00,#ff ;.U......
db #aa,#d5,#80,#ff,#82,#ff,#ff,#ff
db #ff,#ff,#82,#bb,#ff,#33,#77,#bb ;......w.
db #82,#fa,#bb,#fc,#fc,#bb,#82,#fa
db #bb,#54,#54,#bb,#82,#fa,#bb,#54 ;.TT....T
db #54,#bb,#82,#fa,#bb,#fc,#fc,#bb ;T.......
db #82,#55,#77,#fc,#fd,#63,#00,#55 ;.Uw..c.U
db #f5,#ff,#ff,#63,#00,#55,#bb,#00 ;...c.U..
db #11,#c3,#00,#00,#aa,#00,#00,#82
db #00,#00,#ff,#00,#55,#82,#00,#00 ;....U...
db #55,#ff,#eb,#00,#00,#00,#00,#eb ;U.......
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#0a,#00,#00,#00
db #00,#00,#08,#00,#00,#00,#00,#0a
db #08,#00,#00,#00,#00,#00,#88,#05
db #00,#00,#00,#08,#0a,#05,#00,#00
db #00,#0a,#05,#88,#00,#00,#00,#0a
db #05,#0a,#00,#00,#00,#05,#af,#05
db #00,#0a,#0a,#05,#af,#05,#00,#05
db #af,#af,#af,#41,#0a,#55,#af,#ff ;...A.U..
db #af,#41,#0a,#55,#ff,#ff,#eb,#c3 ;.A.U....
db #00,#55,#ff,#bf,#eb,#c3,#00,#55 ;.U.....U
db #bf,#3f,#3f,#c3,#00,#55,#bf,#3f ;.....U..
db #3f,#c3,#00,#00,#bf,#3f,#3f,#82
db #00,#00,#bf,#3f,#3f,#82,#00,#00
db #bf,#3f,#3f,#82,#00,#00,#3f,#3f
db #3f,#c3,#00,#00,#3f,#3f,#3f,#c3
db #00,#00,#3f,#3f,#6b,#c3,#41,#3f ;....k.A.
db #6b,#3f,#6b,#c3,#c3,#c3,#c3,#97 ;k.k.....
db #c3,#c3,#c3,#00,#41,#c3,#c3,#c3 ;....A...
db #82,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #05,#00,#00,#00,#00,#00,#05,#00
db #88,#00,#00,#00,#44,#00,#88,#00 ;....D...
db #0a,#00,#05,#05,#00,#00,#0a,#0a
db #05,#05,#00,#00,#00,#05,#af,#05
db #00,#0a,#0a,#05,#af,#05,#00,#05
db #af,#af,#aa,#41,#00,#55,#af,#ff ;...A.U..
db #aa,#41,#00,#55,#ff,#ff,#eb,#c3 ;.A.U....
db #00,#55,#ff,#bf,#eb,#c3,#00,#55 ;.U.....U
db #bf,#3f,#3f,#c3,#00,#55,#bf,#3f ;.....U..
db #3f,#c3,#00,#00,#bf,#3f,#3f,#82
db #00,#00,#bf,#3f,#3f,#82,#00,#00
db #bf,#3f,#3f,#82,#00,#00,#3f,#3f
db #3f,#c3,#00,#00,#3f,#3f,#3f,#c3
db #00,#00,#3f,#3f,#6b,#c3,#00,#3f ;....k...
db #6b,#3f,#6b,#c3,#82,#c3,#c3,#97 ;k.k.....
db #c3,#c3,#c3,#00,#41,#c3,#c3,#c3 ;....A...
db #c3,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#50,#a0 ;......P.
db #00,#00,#00,#00,#f0,#72,#00,#00 ;.....r..
db #00,#50,#11,#66,#80,#00,#00,#00 ;.P.f....
db #11,#62,#80,#00,#00,#00,#11,#c4 ;.b......
db #c0,#00,#00,#00,#11,#c0,#c0,#00
db #00,#00,#11,#c0,#c0,#00,#00,#00
db #f5,#55,#55,#80,#00,#00,#04,#0c ;.UU.....
db #0c,#3c,#28,#3c,#3c,#3c,#3c,#3c
db #3c,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#50,#f0,#00 ;.....P..
db #00,#00,#00,#b1,#62,#80,#00,#00 ;....b...
db #00,#66,#c0,#80,#00,#00,#50,#62 ;.f....Pb
db #c0,#40,#00,#00,#11,#c8,#c0,#00
db #00,#00,#11,#62,#c0,#00,#00,#00 ;...b....
db #f5,#75,#75,#80,#00,#00,#04,#0c ;.uu.....
db #0c,#3c,#28,#3c,#3c,#3c,#3c,#3c
db #3c
labAB00 db #0
labAB01 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00
labAB28 db #0
db #00,#00,#00,#00,#00
labAB2E db #0
db #00,#00,#00
labAB32 db #0
db #00
labAB34 db #0
db #00,#00,#00,#00,#00,#00,#00
labAB3C db #0
db #00,#00,#00,#00,#00,#00,#00
labAB44 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
labAB60 db #0
labAB61 db #0
db #00,#00,#00,#00,#00,#00
labAB68 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
db #00,#63,#61,#6c,#6c,#20,#26,#61 ;.call..a
db #30,#30,#65,#00,#00,#00,#00,#00 ;..e.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00
labACA8 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
labAD0D db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#05
db #05,#05,#05,#05,#05,#05,#05,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#6f,#01,#70,#ae,#3f,#00,#00 ;.o.p....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#0e
db #a0,#ff,#45,#00,#fe,#bf,#0d,#00 ;..E.....
db #7b,#a6,#fb,#a6,#40,#00,#6f,#01 ;......o.
db #72,#01,#72,#01,#72,#01,#72,#01 ;r.r.r.r.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
labAF78 db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
labAF9A db #0
db #00,#00,#00,#00,#00,#00,#00,#00
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
db #ae,#7b,#a6,#7b,#a6,#00,#00,#00
db #00,#00,#80,#ff,#7e,#b0,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#02
db #0e,#a0,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
db #00,#00,#00,#00,#81,#8b,#20,#00
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
db #00,#00,#00,#00,#00,#3f,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
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
db #01,#8b,#ff,#90,#b5,#28,#b6,#c1
db #b5,#00,#00,#02,#1e,#40,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#bf
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#40,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#1e,#00,#40,#ff,#00
db #00,#00,#40,#92,#c4,#fd,#00,#00
db #07,#40,#08,#08,#04,#10,#04,#10
db #05,#80,#08,#01,#08,#08,#01,#80
db #01,#80,#07,#04,#00,#40,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#15,#0b
db #01,#0b,#00,#96,#b4,#e6,#b4,#36
db #b5,#86,#b5,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#3f,#01,#c7
db #00,#00,#00,#f0,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#ff,#ff,#00,#00,#00,#00
db #00,#00,#00,#18,#27,#00,#02,#f0
db #00,#92,#13,#00,#00,#00,#00,#00
db #00,#18,#27,#00,#02,#f0,#00,#92
db #13,#00,#00,#00,#00,#00,#00,#18
db #27,#00,#02,#f0,#00,#92,#13,#00
db #00,#00,#00,#00,#00,#18,#27,#00
db #02,#f0,#00,#92,#13,#00,#00
labB6EF db #0
db #00,#00,#00,#18,#27,#00,#02,#f0
db #00,#92,#13,#00,#00,#00,#00,#00
db #00,#18,#27,#00,#02,#f0,#00,#92
db #13,#00,#00,#00,#00,#00,#00,#18
db #27,#00,#02,#f0,#00,#92,#13,#00
db #00,#00,#00,#00,#00,#18,#27,#00
db #02,#f0,#00,#92,#13,#00,#0a,#00
db #00,#00,#00,#18,#27,#00,#02,#f0
db #00,#92,#13,#00,#f0,#ff,#7c,#a6
db #00,#00,#00,#00,#33,#cc,#66,#66 ;......ff
db #77,#ee,#66,#00,#33,#cc,#00,#00 ;w.f.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#0a,#01,#07,#00,#00,#00,#00
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
db #82,#47,#15,#01,#00,#00,#c0,#c3 ;.G......
db #74,#0c,#00,#00,#00,#00,#00,#00 ;t.......
db #00,#00,#0a,#0a,#04,#04,#0a,#13
db #0c,#0b,#14,#15,#0d,#06,#1e,#1f
db #07,#12,#19,#04,#17,#04,#04,#0a
db #13,#0c,#0b,#14,#15,#0d,#06,#1e
db #1f,#07,#12,#19,#0a,#07,#ff,#00
db #04,#00,#00,#00,#00,#00,#81,#61 ;.......a
db #0d,#00,#00,#00,#0a,#a0,#5e,#a1
db #5c,#a2,#7b,#a3,#23,#a6,#40,#ab
db #7c,#ac,#7d,#ad,#7e,#ae,#5d,#af
db #5b,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#fb
db #b7
labB831 db #0
db #e0,#bf,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#9f,#07,#00,#0a
db #e5,#b7,#f8,#b7,#7c,#0d,#11,#02
db #fd,#b7,#2f,#01,#00,#0a,#00,#00
db #0a,#0b,#58,#0e,#00,#00,#00,#f9 ;..X.....
db #b7,#00,#00,#00,#00,#04,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#fc,#a6,#00,#00,#06,#c0,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#a7
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#c3,#5f
db #ba,#c3,#66,#ba,#c3,#51,#ba,#c3 ;..f..Q..
db #58,#ba,#c3,#70,#ba,#c3,#79,#ba ;X..p..y.
db #c3,#9d,#ba,#c3,#7e,#ba,#c3,#87
db #ba,#c3,#a1,#ba,#c3,#a7,#ba,#3a
db #c1,#b8,#b7,#c8,#e5,#f3,#18,#06
db #21,#bf,#b8,#36,#01,#c9,#2a,#c0
db #b8,#7c,#b7,#28,#07,#23,#23,#23
db #3a,#c2,#b8,#be,#e1,#fb,#c9
labB941 di
    ex af,af''
    jr c,labB978
    exx
    ld a,c
    scf
    ei
    ex af,af''
    di
    push af
    res 2,c
    out (c),c
    call lab00B1
labB953 or a
    ex af,af''
    ld c,a
    ld b,#7f
    ld a,(labB831)
    or a
    jr z,labB972
    jp m,labB972
    ld a,c
    and #c
    push af
    res 2,c
    exx
    call lab010A
    exx
    pop hl
    ld a,c
    and #f3
    or h
    ld c,a
labB972 out (c),c
    exx
    pop af
    ei
    ret 
labB978 ex af,af''
    pop hl
    push af
    set 2,c
    out (c),c
    call lab003B
    jr labB953
datab984 db #f3
db #e5,#d9,#d1,#18,#06
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
db #ba,#d9,#fb,#cd,#45,#33,#f3,#d9 ;....E...
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
db #9b,#cf,#98,#9b,#cf,#bf,#9b,#cf
db #c5,#9b,#cf,#fa,#9b,#cf,#46,#9c ;......F.
db #cf,#b3,#9c,#cf,#04,#9c,#cf,#db
db #9c,#cf,#e1,#9c,#cf,#45,#9e,#cf ;.....E..
db #38,#9d,#cf,#e5,#9d,#cf,#d8,#9e
db #cf,#c4,#9e,#cf,#dd,#9e,#cf,#c9
db #9e,#cf,#e2,#9e,#cf,#ce,#9e,#cf
db #34,#9e,#cf,#2f,#9e,#cf,#f6,#9d
db #cf,#f2,#9d,#cf,#fa,#9d,#cf,#0b
db #9e,#cf,#19,#9e,#cf,#74,#90,#cf ;.....t..
db #84,#90,#cf,#59,#94,#cf,#52,#94 ;...Y..R.
db #cf,#fe,#93,#cf,#35,#93,#cf,#ac
db #93,#cf,#a8,#93,#cf,#08,#92,#cf
db #52,#92,#cf,#4f,#95,#cf,#5a,#91 ;R..O..Z.
db #cf,#65,#91,#cf,#70,#91,#cf,#7c ;.e..p...
db #91,#cf,#86,#92,#cf,#97,#92,#cf
db #76,#92,#cf,#7e,#92,#cf,#ca,#91 ;v.......
db #cf,#65,#92,#cf,#65,#92,#cf,#a6 ;.e..e...
db #92,#cf,#ba,#92,#cf,#ab,#92,#cf
db #c0,#92,#cf,#c6,#92,#cf,#7b,#93
db #cf,#88,#93,#cf,#d4,#92,#cf,#f2
db #92,#cf,#fe,#92,#cf,#2b,#93,#cf
db #d4,#94,#cf,#e4,#90,#cf,#03,#91
db #cf,#a8,#95,#cf,#d7,#95,#cf,#fe
db #95,#cf,#fb,#95,#cf,#06,#96,#cf
db #0e,#96,#cf,#1c,#96,#cf,#a5,#96
db #cf,#ea,#96,#cf,#17,#97,#cf,#2d
db #97,#cf,#36,#97,#cf,#67,#97,#cf ;.....g..
db #75,#97,#cf,#6e,#97,#cf,#7a,#97 ;u..n..z.
db #cf,#83,#97,#cf,#80,#97,#cf,#97
db #97,#cf,#94,#97,#cf,#a9,#97,#cf
db #a6,#97,#cf,#40,#99,#cf,#bf,#8a
db #cf,#d0,#8a,#cf,#37,#8b,#cf,#3c
db #8b,#cf
labBC0C db #56
db #8b,#cf,#e9,#8a,#cf,#0c,#8b,#cf
db #17,#8b,#cf,#5d,#8b,#cf,#6a,#8b ;......j.
db #cf,#af,#8b,#cf,#05,#8c,#cf,#11
db #8c,#cf,#1f,#8c,#cf,#39,#8c,#cf
db #8e,#8c,#cf,#a7,#8c,#cf,#f2,#8c
db #cf,#1a,#8d,#cf,#f7,#8c,#cf,#1f
db #8d,#cf,#ea,#8c,#cf,#ee,#8c,#cf
db #b9,#8d,#cf,#bd,#8d,#cf,#e5,#8d
db #cf,#00,#8e,#cf,#44,#8e,#cf ;....D..
labBC54 db #f9
db #8e,#cf,#2a,#8f,#cf,#55,#8c,#cf ;.....U..
db #74,#8c,#cf,#93,#8f,#cf,#9b,#8f ;t.......
db #cf,#bc,#a4,#cf,#ce,#a4,#cf,#e1
db #a4,#cf,#bb,#ab,#cf,#bf,#ab,#cf
db #c1,#ab,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#df,#8b,#a8,#df,#8b,#a8,#df
db #8b,#a8,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8
labBC9E rst 8
    xor a
    xor c
    rst 8
    and (hl)
    xor c
    rst 8
    pop bc
    xor c
    rst 8
    jp (hl)
    sbc a,a
    rst 8
    inc d
    and c
    rst 8
    adc a,#a1
    rst 8
    ex de,hl
    and c
    rst 8
    xor h
    and c
    rst 8
    ld d,b
    and b
    rst 8
    ld l,e
    and b
    rst 8
    sub l
    and h
    rst 8
    sbc a,d
    and h
    rst 8
    and (hl)
    and h
    rst 8
    xor e
    and h
    rst 8
    ld e,h
    add a,b
    rst 8
    ld h,#83
    rst 8
    jr nc,labBC54
    rst 8
    and b
    add a,d
    rst 8
    or c
    add a,d
    rst 8
    ld h,e
    add a,c
    rst 8
    ld l,d
    add a,c
    rst 8
    ld (hl),b
    add a,c
    rst 8
    halt
    add a,c
    rst 8
    ld a,l
    add a,c
    rst 8
    add a,e
    add a,c
    rst 8
    or e
    add a,c
    rst 8
    push bc
    add a,c
    rst 8
    jp nc,#cf81
    jp po,#cf81
    daa
    add a,d
    rst 8
    add a,h
    add a,d
    rst 8
    ld d,l
    add a,d
    rst 8
    add hl,de
    add a,d
    rst 8
    halt
    add a,d
    rst 8
    sub h
    add a,d
    rst 8
    sbc a,d
    add a,d
    rst 8
    adc a,l
    add a,d
    rst 8
    sbc a,c
    add a,b
    rst 8
    and e
    add a,b
    rst 8
db #ed,#85
    rst 8
    inc e
    add a,(hl)
    rst 8
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
    ld sp,lab2FEF
    ld (lab53EF),a
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
    ld sp,data0000
    nop
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
    jp lab17B5-1
    jp lab0C8A
    jp lab0C70+1
labBDEB jp lab0B17
    jp lab1DB8
    jp lab0835
    jp lab1D40
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labBE68
labBE68 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    sub #c9
    rlca 
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labBF98 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld l,e
    cp c
    sub b
    ld e,#90
    ld e,#a7
    dec e
    sbc a,#1d
    dec (hl)
    or (hl)
    ld a,(bc)
    nop
    push af
    dec c
    ret p
    ld (bc),a
    call m,labAD0D
    ld de,lab152F
    ld bc,lab4D00
    inc d
    dec de
    rst 40
    adc a,l
    inc bc
    ld d,#1e
    sub d
    call nz,labA0C8
    ld a,l
    and b
    ld c,l
    and b
    nop
    and b
    jr z,labBF98
    and d
    cp c
    add a,l
    ld a,a
    adc a,(hl)
labBFFD jp p,#de6f
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
