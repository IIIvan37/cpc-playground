-- Migration: Import z80code projects batch 51
-- Projects 101 to 102
-- Generated: 2026-01-25T21:43:30.199498

-- Project 101: bombjack by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'bombjack',
    'Imported from z80Code. Author: siko. Disassembled Game',
    'public',
    false,
    false,
    '2021-07-12T21:20:26.782000'::timestamptz,
    '2021-07-13T17:24:24.965000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '  org #10
  run #10
  
  di
  ; Mode 0
  ld bc,#7f8c
  out (c),c
  
  
  ld hl,0
  ld de,#b63f
  ld a,#8c
  exx
  ex af,af''
  ld hl,#a064
  ;ld bc,#07d0
  ld de,#efd0
  ld ix,#012a
  ld iy,#000C
  jp #3B
  
org #3B
  start_3B:
  ld a,#14
lab003D:
  ld bc,lab7F10
lab0040:
  or #40
  out (c),c
  out (c),a
  ld hl,lab2B98
  ld (lab39E1+1),hl
  ld hl,data2A6C
lab004F:
  ld (lab2B14),hl
  ld a,#1
  ld (lab2C0A),a
  inc a
  ld (lab2B76),a
  ld hl,data_SCORE_FONTE_01
  ld (lab2B55),hl
  ld sp,lab2667
lab0064:
  call lab2971
  ld hl,lab2000
  ld bc,#BC0C
  out (c),c
  inc b
  out (c),h
  dec b
  inc c
  out (c),c
  inc b
  out (c),l
  ld hl,lab033F
  ld (data2921),hl
  call lab26FC
  jp lab3E0A
lab0085:
  ld (data02B3),sp
  call lab2971
  call lab3AE6
  ld a,#3
  ld (lab2F59),a
  ld hl,#0000
  ld (lab2F51),hl
  ld (lab2F53),hl
  call lab3AA2
  ld a,#3
  ld (lab2F59),a
  ld (lab02B5),a
  ld hl,#0000
  ld (lab2F51),hl
  ld (lab2F53),hl
  call lab39B5
lab00B4:
  ld sp,(data02B3)
  call lab3C93
  ld a,#ff
  ld (lab2F67),a
  xor a
  ld (lab2F68),a
  ld (lab2F69),a
  ld (lab2F6F),a
  jr lab00D5
lab00CC:
  ld sp,(data02B3)
  ld a,#1
  ld (lab02B6),a
lab00D5:
  xor a
  ld (lab2F6B),a
  ld (lab2F70),a
  ld a,(lab2F69)
  inc a
  cp #d
  jr nz,lab00E9
  xor a
  ld (lab2F68),a
  inc a
lab00E9:
  ld (lab2F69),a
  ld a,#18
  ld (lab2F6C),a
  ld a,(lab2F68)
  inc a
  cp #6
  jr nz,lab00FB
  ld a,#1
lab00FB:
  ld (lab2F68),a
lab00FE:
  ld a,(lab2F6F)
  inc a
  cp #6
  jr nz,lab0108
  ld a,#1
lab0108:
  ld (lab2F6F),a
  ld a,(lab2F67)
  inc a
  ld (lab2F67),a
  sla a
  sla a
  ld b,a
  ld a,#64
  sub b
  jr nc,lab011D
  xor a
lab011D:
  ld (lab2F6D),a
  ld a,(lab2F67)
  ld b,a
  sla a
  sla a
  sla a
  add a,b
  ld b,a
lab012C:
  ld a,#e6
  sub b
  cp #32
  jr nc,lab0135
  ld a,#32
lab0135:
  ld (lab2F6E),a
  ld hl,(lab2F69)
  ld h,#0
  dec l
  ld de,#0008
  call lab1D68
  ld de,lab0427
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  ld de,(lab2F71)
  ld b,#18
lab0152:
  ld a,(hl)
  exx
  srl a
  srl a
  srl a
  srl a
  ld e,a
  ld d,#0
  ld hl,#000E
  call lab1D68
  ld a,l
  srl a
  exx
  inc a
  ld (de),a
  ld a,(hl)
  exx
  and #f
  ld e,a
  ld d,#0
  ld hl,#0017
  call lab1D68
  ld a,l
  exx
  inc de
  and #fe
  ld (de),a
  inc de
  inc hl
  djnz lab0152
  ex de,hl
  ld (hl),#ff
lab0185:
  ld sp,(data02B3)
  ld hl,(lab2F69)
  ld h,#0
  dec l
  ld de,#0008
  call lab1D68
  ld de,lab0427
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld (lab0756),de
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld (lab262C),de
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld (lab200B),de
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld (lab2008),de
  ld a,#12
  ld (lab1FCF),a
  ld (lab1FD0),a
  ld (lab1F6F),a
  ld (lab1F71),a
  neg
  ld (lab1F6E),a
  ld (lab1F70),a
  ld hl,lab2676
  ld de,#000B
  ld b,#9
lab01D7:
  ld (hl),#0
  add hl,de
  djnz lab01D7
  ld hl,lab1FA2
  ld de,lab1FA8
  exx
  ld hl,lab1FB4
  exx
  xor a
  ld b,#6
lab01EA:
  ld (hl),#0
  ld (de),a
  exx
  ld (hl),#0
  inc hl
  exx
  inc de
  inc hl
  djnz lab01EA
  ld hl,lab1E94
  ld (lab262E),hl
  ld (hl),#ff
lab01FE:
  ld hl,lab200D
  ld e,l
  ld d,h
  ld (hl),#0
  inc de
  ld bc,#0017
  ldir
  ld a,#1
  ld (lab1F16),a
  ld (lab1FCE),a
  inc a
  ld (lab2676),a
lab0217:
  ld a,#ff
  ld (lab1F0E),a
  ld (lab1F0F),a
  ld a,#3a
  ld (lab267B),a
  ld (lab2677),a
  ld a,#46
  ld (lab267D),a
  ld (lab2679),a
  ld hl,(lab2F6F)
  ld h,#0
  dec l
  add hl,hl
  ld de,lab02E4
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (lab2DB1),de
  ld hl,(lab2F6F)
  ld h,#0
  dec l
  ld de,#0009
  call lab1D68
  ld de,lab02B7
  add hl,de
  ld (lab1F11),hl
  call lab1E84
  ld hl,lab032A
  ld de,lab032E
  ld (hl),e
  inc hl
  ld (hl),d
  inc hl
  ld (hl),#0
  inc hl
  ld (hl),#0
  ld hl,lab02EE
  call lab3CCE
  call lab3D4A
  call lab1D9A
  call lab3D69
  call lab2CBB
  call lab1C43
  call lab2CBB
  call lab10AB
  call lab1B2C
  ld a,(lab02B6)
  and a
  jr nz,lab0294
  ld a,(lab2F59)
  dec a
  ld (lab2F59),a
  call lab3C93
lab0294:
  ld a,(lab2F47)
  add a,#30
  ld (lab42FB),a
  call lab3969
  sbc hl,bc
  ld b,#96
  call lab0B08
  call lab2CD7
  xor a
  ld (lab02B6),a
  call lab26FC
  jp lab0758
data02B3:
  db #00,#00
lab02B5:
  db #00
lab02B6:
  db #00
lab02B7:
  db #15,#1c,#15,#17,#07,#13,#0e,#14
  db #03,#17,#12,#16,#06,#0b,#15,#17
  db #14,#1c,#17,#1e,#1c,#14,#00,#06
  db #15,#04,#16,#17,#00,#14,#06,#0b
  db #15,#17,#1a,#14,#04,#0c,#16,#12
  db #1a,#03,#1e,#1e,#14
lab02E4:
  db #f8,#64,#a9,#6b,#e9,#70,#f2,#75 ;.d.k.p.u
  db #c0,#7a ;.z
lab02EE:
  db #00,#00
lab02F0:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#0b,#00,#00,#00
  db #0a,#00,#00,#00,#0c,#00,#00,#00
  db #14,#00,#00,#00,#00,#00,#35,#03
  db #02,#00
lab032A:
  db #2e,#03,#00,#00
lab032E:
  db #14,#1c,#0c,#05,#0c,#1c,#ff
lab0335:
  db #0e,#0a,#03,#0b,#ff
lab033A:
  db #14,#14,#0a,#0a,#ff
lab033F:
  db #0e,#00,#03,#00,#00,#00
lab0345:
  db #00,#00,#08,#09,#00,#01,#00,#ff
  db #ff,#11,#00,#02,#00,#00,#00
lab0354:
  db #00,#00,#01,#00,#00,#06,#02,#00
  db #07,#01,#ff,#ff,#0e,#00,#02,#00
  db #00,#00,#00,#00,#08,#09,#00,#01
  db #01,#ff,#ff,#0e,#00,#1e,#00,#32
  db #00,#a0,#00,#01,#02,#00,#10,#04
  db #ff,#ff,#0e,#00,#0f,#00,#50,#00 ;......P.
  db #00,#00,#01,#00,#00,#10,#14,#ff
  db #ff,#0e,#00,#14,#00,#64,#00,#ff ;.....d..
  db #00,#01,#00,#00,#10,#fc,#ff,#ff
  db #0e,#00,#19,#00,#50,#00,#00,#00 ;....P...
  db #01,#05,#00,#10,#05,#ff,#ff,#11
  db #00,#1b,#00,#28,#00,#00,#00,#01
  db #01,#00,#10,#1c,#23,#01,#00,#ff
  db #ff,#11,#00,#32,#00,#1e,#00,#00
  db #00,#01,#01,#00,#10,#7f,#12,#01
  db #00,#ff,#ff,#0e,#00,#ff,#00,#0b
  db #00,#00,#00,#01,#00,#00,#10,#1f
  db #ff,#ff,#0e,#00,#3c,#00,#23,#00
  db #ff,#00,#01,#00,#00,#10,#f0,#ff
  db #ff,#1a,#00,#3c,#00,#23,#01,#00
  db #00,#00,#ff,#00,#01,#00,#00,#07
lab03FC:
  db #01,#00,#06,#1f,#00,#10,#fe,#14
  db #10,#7f,#ff,#ff,#0e,#00,#1b,#00
  db #32,#00,#00,#00,#01,#01,#00,#10
  db #0f,#ff,#ff
lab0417:
  db #66,#11,#5a,#13,#5a,#13,#5a,#13 ;f.Z.Z.Z.
  db #5a,#13,#5a,#13,#5a,#13,#5a,#13 ;Z.Z.Z.Z.
lab0427:
  db #9f,#04,#8f,#04,#87,#04,#b7,#04
  db #dc,#04,#c9,#04,#bf,#04,#f4,#04
  db #1a,#05,#0a,#05,#fe,#04,#32,#05
  db #59,#05,#4c,#05,#3e,#05,#71,#05 ;Y.L...q.
  db #8e,#05,#8d,#05,#7f,#05,#a6,#05
  db #cf,#05,#bc,#05,#b4,#05,#e7,#05
  db #0c,#06,#f9,#05,#ef,#05,#24,#06
  db #53,#06,#3a,#06,#2e,#06,#6b,#06 ;S.....k.
  db #9e,#06,#85,#06,#77,#06,#b6,#06 ;....w...
  db #9f,#04,#8d,#05,#c4,#06,#a6,#05
  db #ed,#06,#da,#06,#d2,#06,#05,#07
  db #2a,#07,#17,#07,#0d,#07,#42,#07 ;......B.
  db #7a,#14,#7a,#14,#7a,#14,#3d,#14 ;z.z.z...
  db #93,#85,#10,#35,#83,#10,#7a,#84 ;......z.
  db #10,#ad,#85,#10,#2c,#83,#10,#ff
  db #42,#52,#62,#72,#83,#84,#85,#86 ;BRbr....
  db #03,#04,#05,#06,#10,#20,#30,#76 ;.......v
  db #66,#56,#38,#28,#18,#80,#70,#60 ;fV....p.
  db #2a,#10,#2a,#10,#2a,#10,#2a,#10
  db #63,#14,#63,#14,#7a,#14,#3d,#14 ;c.c.z...
  db #7a,#14,#05,#83,#10,#e5,#83,#10 ;z.......
  db #29,#83,#10,#c9,#83,#10,#4d,#83 ;......M.
  db #10,#ad,#83,#10,#ff,#54,#64,#74 ;.....Tdt
  db #61,#71,#81,#52,#42,#32,#50,#40 ;aq.RB.P.
  db #30,#01,#11,#21,#14,#24,#34,#16
  db #26,#36,#56,#66,#76,#18,#0a,#18 ;..Vfv...
  db #0a,#18,#0a,#18,#0a,#18,#0a,#63 ;.......c
  db #14,#63,#14,#63,#14,#3d,#14,#63 ;.c.c...c
  db #14,#63,#14,#43,#83,#10,#a3,#83 ;.c.C....
  db #10,#7b,#82,#10,#1d,#83,#10,#cd
  db #83,#10,#ff,#51,#61,#70,#80,#31 ;...Qap..
  db #21,#00,#01,#28,#38,#58,#68,#06 ;.....Xh.
  db #16,#26,#35,#34,#33,#53,#54,#55 ;.....STU
  db #66,#76,#86,#30,#10,#30,#10,#30 ;fv......
  db #10,#30,#10,#7a,#10,#7a,#10,#7a ;...z.z.z
  db #14,#7a,#14,#63,#14,#3d,#14,#63 ;.z.c...c
  db #14,#7a,#14,#7a,#14,#23,#83,#10 ;.z.z....
  db #c3,#83,#10,#2d,#83,#10,#cd,#83
  db #10,#ff,#64,#74,#84,#24,#14,#04 ;..dt....
  db #51,#61,#71,#31,#21,#11,#08,#18 ;Qaq.....
  db #28,#68,#78,#88,#66,#76,#86,#26 ;.hx.fv..
  db #16,#06,#20,#10,#20,#10,#20,#10
  db #20,#10,#20,#10,#20,#10,#20,#10
  db #3d,#14,#3d,#14,#3d,#14,#3d,#14
  db #3d,#14,#3d,#14,#3d,#14,#ff,#55 ;.......U
  db #56,#57,#31,#32,#33,#71,#72,#73 ;VW...qrs
  db #75,#76,#77,#51,#52,#53,#35,#36 ;uvwQRS..
  db #37,#11,#12,#13,#15,#16,#17,#30
  db #42,#30,#42,#30,#42,#30,#42,#30 ;B.B.B.B.
  db #42,#30,#42,#30,#42,#63,#14,#63 ;B.B.Bc.c
  db #14,#7a,#14,#3d,#14,#73,#83,#10 ;.z...s..
  db #05,#85,#10,#b7,#83,#10,#b7,#03
  db #8d,#ba,#03,#dd,#3d,#88,#1b,#ff
  db #23,#13,#03,#04,#05,#06,#07,#87
  db #86,#85,#84,#83,#73,#63,#47,#37 ;....scG.
  db #27,#17,#61,#51,#10,#00,#70,#80 ;..aQ..p.
  db #18,#24,#18,#24,#18,#24,#18,#24
  db #63,#14,#7a,#14,#63,#14,#7a,#14 ;c.z.c.z.
  db #3d,#14,#73,#83,#10,#37,#84,#10 ;..s.....
  db #a7,#84,#10,#3a,#84,#10,#aa,#84
  db #10,#7d,#82,#10,#ff,#54,#64,#74 ;.....Tdt
  db #36,#37,#38,#34,#24,#14,#11,#21
  db #31,#51,#61,#71,#06,#07,#08,#86 ;.Qaq....
  db #87,#88,#56,#57,#58,#30,#3c,#30 ;..VWX...
  db #3c,#30,#3c,#30,#3c,#30,#3c,#63 ;.......c
  db #14,#63,#14,#7a,#14,#3d,#14,#7a ;.c.z...z
  db #14,#3d,#14,#52,#04,#2d,#16,#84 ;...R....
  db #1b,#b2,#04,#2d,#b6,#84,#a0,#1b
  db #84,#10,#5b,#04,#93,#bb,#84,#10
  db #bb,#04,#83,#ff,#78,#77,#76,#84 ;....xwv.
  db #74,#64,#24,#14,#04,#18,#17,#16 ;td......
  db #31,#32,#33,#10,#11,#12,#70,#71 ;......pq
  db #72,#51,#52,#53,#18,#30,#18,#30 ;rQRS....
  db #18,#30,#18,#30,#18,#30,#18,#30
  db #7a,#14,#7a,#14,#7a,#14,#7a,#14 ;z.z.z.z.
  db #3d,#14,#3d,#14,#3d,#14,#72,#83 ;......r.
  db #10,#72,#03,#8d,#75,#84,#a0,#58 ;.r..u..X
  db #89,#10,#88,#03,#7d,#8b,#83,#a0
  db #8e,#85,#10,#8e,#03,#83,#ff,#63 ;.......c
  db #73,#83,#86,#87,#88,#18,#28,#38 ;s.......
  db #78,#68,#58,#08,#07,#06,#23,#22 ;xhX.....
  db #21,#11,#12,#13,#16,#26,#36,#20
  db #46,#20,#46,#46,#46,#46,#46,#20 ;F.FFFFF.
  db #46,#20,#46,#20,#46,#7a,#14,#7a ;F.F.Fz.z
  db #14,#7a,#14,#7a,#14,#7a,#14,#7a ;.z.z.z.z
  db #14,#7a,#14,#3d,#14,#7a,#14,#3d ;.z...z..
  db #14,#7a,#14,#33,#85,#10,#b3,#83 ;.z......
  db #1c,#33,#09,#8d,#e3,#09,#9d,#3b
  db #82,#a0,#bb,#83,#1b,#ff,#63,#64 ;......cd
  db #65,#22,#23,#24,#34,#35,#36,#80 ;e.......
  db #81,#82,#41,#42,#43,#86,#87,#88 ;..ABC...
  db #00,#01,#02,#60,#61,#62,#10,#18 ;....ab..
  db #10,#18,#10,#18,#10,#18,#63,#14 ;......c.
  db #3d,#14,#7a,#14,#3d,#14,#7a,#14 ;..z...z.
  db #d3,#84,#10,#05,#84,#10,#d7,#84
  db #10,#09,#84,#10,#db,#84,#10,#0d
  db #84,#10,#ff,#76,#86,#87,#88,#28 ;...v....
  db #18,#08,#60,#70,#80,#73,#83,#82 ;...p.s..
  db #52,#42,#32,#00,#01,#02,#13,#14 ;RB......
  db #15,#74,#75,#14,#00,#24,#00,#a8 ;.tu.....
  db #00,#10,#00,#14,#00,#24,#00,#a8
  db #00,#10,#00,#14,#00,#24,#00
lab0756:
  db #00,#00
lab0758:
  ld a,(lab2679)
  ld b,a
  ld a,(lab267D)
  cp b
  jr z,lab076E
  ld (lab0345),a
  xor a
  ld (lab2923),a
  ld c,#fa
  call lab2722
lab076E:
  ld b,#f5
  in a,(c)
  rra
  jr nc,lab076E
  call lab2D2F
  call lab27DF
  ld a,(lab2029)
  inc a
  ld (lab2029),a
  cp #5
  jr c,lab0790
  xor a
  ld (lab2029),a
  ld hl,lab02EE
  call lab3CF5
lab0790:
  ld a,(lab2024)
  and a
  jr nz,lab07E2
  call lab0C2A
  call lab0D68
  call lab0D01
  call lab0FB2
  jp c,lab0A08
  ld a,#a
  sub b
  cp #2
  jp z,lab08AD
  cp #3
  jp z,lab091A
  ld b,a
  ld a,(lab2018)
  and a
  jp nz,lab0966
  ld e,b
  ld d,#0
  ld hl,lab1FB4
  dec de
  dec de
  dec de
  dec de
  add hl,de
  ld a,(hl)
  and a
  jp nz,lab0A08
  ld hl,#0000
  ld (lab2011),hl
  ld hl,#FF00
  ld (lab2013),hl
  ld a,(lab2677)
  ld (lab267B),a
  ld a,(lab2679)
  ld (lab267D),a
lab07E2:
  ld a,(lab267B)
  ld c,a
  ld a,(lab267D)
  ld b,a
  call lab1AFF
  ld a,(hl)
  cp #ff
  jp z,lab0806
  ld a,(lab2014)
  bit 7,a
  jr z,lab0820
  ld hl,lab00FE+2
  ld (lab2013),hl
  ld a,(lab2679)
  ld (lab267D),a
lab0806:
  ld a,(lab267D)
  cp #3
  jr nc,lab081B
  ld a,#3
  ld (lab267D),a
  ld hl,#0000
  ld (lab2013),hl
  jp lab0888
lab081B:
  cp #b3
  jp c,lab0888
lab0820:
  xor a
  ld (lab2024),a
  call lab26FC
  ld a,(lab4404)
  dec a
  jp nz,lab0844
  ld a,(lab2F59)
  and a
  jp nz,lab0185
  call lab3969
  ld a,(de)
  ld b,e
  ld b,#96
  call lab0B08
lab083F:
  ld sp,(data02B3)
  ret
lab0844:
  ld a,(lab2F59)
  and a
  jr nz,lab0861
  ld a,(lab2F47)
  add a,#30
  ld (lab4316),a
  call lab3969
  ex af,af''
  ld b,e
  call lab3969
  ld a,(de)
  ld b,e
  ld b,#96
  call lab0B08
lab0861:
  call lab3AA2
  ld hl,lab02B5
  ld a,(hl)
  ld (hl),#0
  and a
  jp z,lab0871
  jp lab00B4
lab0871:
  ld a,(lab2F59)
  and a
  jp z,lab087B
  jp lab0185
lab087B:
  call lab3AA2
  ld a,(lab2F59)
  and a
  jp z,lab083F
  jp lab0185
lab0888:
  ld hl,(lab2013)
  ld de,#000F
  add hl,de
  ld (lab2013),hl
  ld de,(lab2011)
  add hl,de
  ld a,h
  ld h,#0
  ld (lab2011),hl
  ld h,a
  ld a,(lab267D)
  add a,h
  ld (lab267D),a
  ld a,#1
  ld (lab2024),a
  jp lab0B05
lab08AD:
  ld a,#2
  ld (lab2018),a
  ld hl,lab012C
  ld (lab1F69),hl
  xor a
  ld (lab1F6C),a
  ld (lab201B),a
  ld a,#3
  ld (lab2681),a
  exx
  ld hl,lab269C
  ld de,#000B
  exx
  ld hl,lab26A0
  ld de,lab1FFC
  ld a,#6
lab08D4:
  exx
  ex af,af''
  ld a,(hl)
  and #fe
  ld (hl),a
  add hl,de
  ex af,af''
  exx
  ldi
  ldi
  ld bc,lab5F04
  dec hl
  ld (hl),b
  dec hl
  ld (hl),c
  ld bc,#000B
  add hl,bc
  dec a
  jr nz,lab08D4
  ld bc,#0000
  ld de,lab2000
  call lab3A9C
  ld a,#a
  ld (lab2923),a
  ld c,#64
  call lab2722
  ld hl,lab032A
  ld de,lab0335
  ld (hl),e
  inc hl
  ld (hl),d
  inc hl
  ld (hl),#0
  inc hl
  ld (hl),#0
  ld hl,lab02EE
  call lab3CCE
  jp lab0A08
lab091A:
  ld a,(lab1FD7)
  and a
  jp nz,lab093D
  ld a,(lab2F70)
  inc a
  ld (lab2F70),a
  ld bc,#0000
  ld de,lab0FFF+1
  call lab3A9C
  ld a,#8
  ld (lab2923),a
  ld c,#64
  call lab2722
  jr lab095A
lab093D:
  ld a,(lab2F59)
  inc a
  ld (lab2F59),a
  call lab3C47
  ld bc,#0000
  ld de,lab3000
  call lab3A9C
  ld a,#9
  ld (lab2923),a
  ld c,#fe
  call lab2722
lab095A:
  ld a,#3
  ld (lab268C),a
  xor a
  ld (lab2019),a
  jp lab0A08
lab0966:
  push bc
  ld a,#c
  ld (lab2923),a
  ld c,#64
  call lab2722
  ld a,(lab2016)
  inc a
  ld (lab2016),a
  ld bc,#0000
  and #7
  ld d,a
  ld e,#0
  call lab3A9C
  pop bc
  push bc
  ld l,b
  ld h,#0
  dec hl
  ld de,#000B
  call lab1D68
  ld de,lab2676
  add hl,de
  ld (hl),#3
  pop bc
  ld a,b
  sub #4
  ld (lab2630),a
  ld l,a
  ld h,#0
  add hl,hl
  ld de,lab1F72
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  ld bc,lab135A
  and a
  sbc hl,bc
  jr z,lab09DC
  add hl,bc
  ld bc,lab13A9
  and a
  sbc hl,bc
  jr z,lab09DC
  add hl,bc
  ld bc,lab13BF
  and a
  sbc hl,bc
  jr z,lab09DC
  add hl,bc
  ld bc,lab11CC
  and a
  sbc hl,bc
  jr nz,lab09D4
  ex de,hl
  ld de,data1166
  ld (hl),d
  dec hl
  ld (hl),e
  jr lab0A02
lab09D4:
  ld hl,(lab200B)
  dec hl
  dec hl
  ld (lab200B),hl
lab09DC:
  ld hl,(lab2008)
  dec hl
  dec hl
  ld (lab2008),hl
  ld hl,(lab2630)
  ld h,#0
  ld bc,lab1FAE
  add hl,bc
  ld (hl),#0
  ld hl,(lab2630)
  ld h,#0
  ex de,hl
  ld de,data0B55
  ld (hl),d
  dec hl
  ld (hl),e
  ld a,(lab2022)
  inc a
lab09FF:
  ld (lab2022),a
lab0A02:
  ld a,(lab2F6E)
  ld (lab1F0D),a
lab0A08:
  call lab0C94
  and a
  jp z,lab0ABB
  exx
  ld a,(lab2F6C)
  cp #e
  jr z,lab0A1B
  cp #1
  jr nz,lab0A25
lab0A1B:
  call lab1AE1
  cp #64
  jr c,lab0A25
  ld (lab201A),a
lab0A25:
  exx
  ld a,(lab2F6C)
  dec a
  ld (lab2F6C),a
  jp nz,lab0A43
  call lab26FC
  call lab2971
  ld a,(lab2F6B)
  inc a
  call lab3D82
  call lab2971
  jp lab00CC
lab0A43:
  push hl
  ld a,#19
  sub b
  ld e,a
  ld d,#0
  ld hl,lab0040
  call lab1D68
  ld de,lab202A
  add hl,de
  ld (lab300C),hl
  pop hl
  ld a,(hl)
  sla a
  ld (lab3006),a
  ld (hl),#fe
  inc hl
  ld a,(hl)
  ld (lab3008),a
  ld a,#8
  ld (lab300E),a
  dec hl
  call lab0B79
  ld hl,lab4584
  ld (lab300A),hl
  call lab30C4
  ld a,(lab1F10)
  and a
  jr z,lab0ABB
  ld a,(lab3006)
  and #fe
  ld c,a
  ld hl,lab5D04
  ld a,(lab2F70)
  ld b,a
  and #1
  or c
  ld (lab3006),a
  ld a,b
  and #2
  jr z,lab0A98
  ld hl,lab5E04
lab0A98:
  ld (lab300A),hl
  ld de,(lab300C)
  ld hl,(lab262E)
  ld (hl),#50
  inc hl
  ld a,(lab3006)
  ld (hl),a
  inc hl
  ld a,(lab3008)
  ld (hl),a
  inc hl
  ld (hl),e
  inc hl
  ld (hl),d
  inc hl
  ld (lab262E),hl
  ld (hl),#ff
  call lab3013
lab0ABB:
  ld a,(lab2F6E)
  ld b,a
  ld a,(lab201E)
  inc a
  ld (lab201E),a
  cp b
  jp c,lab0AF6
  ld hl,lab1F7E
  ld b,#5
lab0ACF:
  inc hl
  ld (hl),#1
  djnz lab0ACF
  ld a,(lab2F68)
  add a,#5
  cp #7
  jr c,lab0ADF
  ld a,#6
lab0ADF:
  ld b,a
  ld a,(lab1FCE)
  inc a
  cp b
  jr nz,lab0AEF
  ld a,#1
  ld (lab2017),a
  jp lab0AF6
lab0AEF:
  ld (lab1FCE),a
  xor a
  ld (lab201E),a
lab0AF6:
  call lab183C
  call lab197C
  call lab10B7
  call lab1064
  call lab0B25
lab0B05:
  jp lab0758
lab0B08:
  ld l,#5
lab0B0A:
  push bc
  call lab2988
  dec l
  jr nz,lab0B19
  ld hl,lab02EE
  call lab3CF5
  ld l,#5
lab0B19:
  ld bc,lab0217+1
lab0B1C:
  dec bc
  ld a,b
  or c
  jr nz,lab0B1C
  pop bc
  djnz lab0B0A
  ret
lab0B25:
  ld hl,lab1E94
  ld a,#8
  ld (lab300E),a
lab0B2D:
  ld a,(hl)
  cp #ff
  ret z
  push hl
  and a
  jr z,lab0B4E
  dec a
  ld (hl),a
  jr nz,lab0B4E
  inc hl
  ld a,(hl)
  ld (lab3006),a
  inc hl
  ld a,(hl)
  ld (lab3008),a
  inc hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (lab300C),de
  call lab30C4
lab0B4E:
  pop hl
  ld de,#0005
  add hl,de
  jr lab0B2D
data0B55:
  db #3a,#17,#20,#a7,#c8,#3a,#0d,#1f
  db #3d,#32,#0d,#1f,#c0,#3a,#6e,#2f ;......n.
  db #32,#0d,#1f,#3a,#22,#20,#a7,#c8
  db #3d,#32,#22,#20,#21,#5a,#13,#eb ;.....Z..
  db #73,#23,#72,#c9 ;s.r.
lab0B79:
  ld a,(lab2020)
  and a
  jp z,lab0BB8
  ld a,(lab3006)
  ld b,a
  ld a,(lab1F0E)
  cp b
  jp nz,lab0C12
  inc hl
  ld b,(hl)
  dec hl
  ld a,(lab1F0F)
  cp b
  jp nz,lab0C12
  ld a,(lab2F6B)
  inc a
  ld (lab2F6B),a
  push hl
  ld bc,#0000
  ld de,lab01FE+2
  call lab3A9C
  ld a,#4
  ld (lab2923),a
  ld c,#fc
  call lab2722
  pop hl
  ld a,#ff
  ld (lab1F10),a
  jr lab0BD1
lab0BB8:
  push hl
  ld bc,#0000
  ld de,lab00FE+2
  call lab3A9C
  ld a,#3
  ld (lab2923),a
  ld c,#fc
  call lab2722
  pop hl
  xor a
  ld (lab1F10),a
lab0BD1:
  ld b,#18
  exx
  ld hl,(lab300C)
  exx
lab0BD8:
  exx
  ld de,lab0040
  add hl,de
  exx
  inc hl
  inc hl
  ld a,(hl)
  cp #ff
  jp nz,lab0BEF
  ld hl,(lab2F71)
  ld a,(hl)
  exx
  ld hl,lab206A
  exx
lab0BEF:
  cp #fe
  jp nz,lab0BFD
  djnz lab0BD8
  xor a
  ld (lab2020),a
  jp lab0C12
lab0BFD:
  sla a
  ld (lab1F0E),a
  inc hl
  ld a,(hl)
  ld (lab1F0F),a
  ld a,#1
  ld (lab2020),a
  exx
  ld (data1E92),hl
  exx
  ret
lab0C12:
  ld bc,#0000
  ld de,lab00FE+2
  call lab3A9C
  ld a,#3
  ld (lab2923),a
  ld c,#fc
  call lab2722
  xor a
  ld (lab1F10),a
  ret
lab0C2A:
  ld a,(lab2020)
  and a
  ret z
  ld a,(lab2026)
  xor #1
  ld (lab2026),a
  ret z
  ld hl,(data1E92)
  ld (lab300C),hl
  ld a,(lab1F0F)
  ld (lab3008),a
  ld hl,lab3006
  ld a,(lab1F0E)
  ld (hl),a
  ld b,a
  ld a,(lab201F)
  ld c,a
  inc a
  cp #3
  jr nz,lab0C56
  xor a
lab0C56:
  ld (lab201F),a
  ld hl,lab4584
  bit 1,a
  jr z,lab0C64
  ld hl,lab4684
  xor a
lab0C64:
  ld (lab2027),hl
  or b
  ld d,a
  ld hl,lab4584
  ld a,c
  bit 1,a
  jr z,lab0C75
  ld hl,lab4684
  xor a
lab0C75:
  or b
  ld (lab3006),a
  ld (lab300A),hl
  ld a,#2
  ld (lab300E),a
  push de
  call lab30C4
  pop de
  ld hl,(lab2027)
  ld (lab300A),hl
  ld a,d
  ld (lab3006),a
  call lab3013
  ret
lab0C94:
  ld hl,(lab2F71)
  ld a,(lab267B)
  add a,#2
  ld e,a
  ld a,(lab267D)
  add a,#5
  ld d,a
  ld a,#18
lab0CA5:
  ex af,af''
  push de
  ld a,(hl)
  cp #fe
  jr z,lab0CCF
  sla a
  ld c,a
  inc hl
  ld b,(hl)
  add a,#8
  cp e
  jr c,lab0CD0
  ld a,#1
  add a,e
  cp c
  jr c,lab0CD0
  ld a,b
  add a,#f
  cp d
  jr c,lab0CD0
  ld a,#4
  add a,d
  cp b
  jr c,lab0CD0
  pop de
  dec hl
  ex af,af''
  ld b,a
  ld a,#1
  ret
lab0CCF:
  inc hl
lab0CD0:
  inc hl
  pop de
  ex af,af''
  dec a
  jr nz,lab0CA5
  ret
data0CD7:
  db #3a,#18,#20,#a7,#20,#1f,#7e,#fe
  db #12,#30,#1a,#3c,#77,#6f,#dd,#7e ;....wo..
  db #05,#e6,#fe,#cb,#55,#28,#01,#3c ;....U...
  db #dd,#77,#05,#21,#04,#5b,#dd,#75 ;.w.....u
  db #09,#dd,#74,#0a,#c9,#36,#00,#e1 ;..t.....
  db #c5,#c9
lab0D01:
  ld a,(lab201C)
  and a
  jr z,lab0D1D
  ld a,(lab1F13)
  and a
  ret z
  dec a
  jr z,lab0D16
  ld hl,lab4A04
  ld (lab267F),hl
  ret
lab0D16:
  ld hl,lab4904
  ld (lab267F),hl
  ret
lab0D1D:
  ld a,(lab1F13)
  and a
  jr z,lab0D52
  dec a
  jr z,lab0D3C
  ld a,(lab2014)
  inc a
  bit 7,a
  jr z,lab0D35
  ld hl,lab4F04
  ld (lab267F),hl
  ret
lab0D35:
  ld hl,lab4D04
  ld (lab267F),hl
  ret
lab0D3C:
  ld a,(lab2014)
  inc a
  bit 7,a
  jr z,lab0D4B
  ld hl,lab4E04
  ld (lab267F),hl
  ret
lab0D4B:
  ld hl,lab4C04
  ld (lab267F),hl
  ret
lab0D52:
  ld a,(lab2014)
  inc a
  bit 7,a
  jr z,lab0D61
  ld hl,lab5004
  ld (lab267F),hl
  ret
lab0D61:
  ld hl,lab4B04
  ld (lab267F),hl
  ret
lab0D68:
  xor a
  ld (lab1F14),a
  ld (lab1F15),a
  ld (lab1F13),a
  call lab1B76
  ld c,a
  bit 0,c
  jp z,lab0D80
  ld a,#5
  ld (lab1F14),a
lab0D80:
  bit 1,c
  jp z,lab0D8A
  ld a,#5
  ld (lab1F15),a
lab0D8A:
  bit 2,c
  call nz,lab0E8C
  bit 3,c
  call nz,lab0EAD
  bit 4,c
  jr z,lab0DD4
  ld a,(lab1F16)
  dec a
  jp nz,lab0DDD
  ld a,#3
  ld (lab1F16),a
  ld a,(lab201C)
  and a
  jp z,lab0DCB
  ld hl,lab03FC
  ld (lab2013),hl
  ld a,(lab2F70)
  inc a
  sla a
  sla a
  sla a
  sla a
  and #70
  ld e,a
  ld d,#0
  ld bc,#0000
  call lab3A9C
  jp lab0DDD
lab0DCB:
  ld hl,#000F
  ld (lab2013),hl
  jp lab0DDD
lab0DD4:
  ld a,(lab1F16)
  dec a
  jr z,lab0DDD
  ld (lab1F16),a
lab0DDD:
  ld hl,(lab2011)
  ld de,(lab2013)
  bit 7,d
  jp z,lab0DF6
  ld a,d
  cpl
  ld d,a
  ld a,e
  neg
  ld e,a
  and a
  sbc hl,de
  jp lab0DF7
lab0DF6:
  add hl,de
lab0DF7:
  ld a,h
  ld h,#0
  ld (lab2011),hl
  ld hl,lab267D
  bit 7,a
  jp z,lab0E18
  and a
  jp z,lab0E28
  cp #fe
  jr z,lab0E13
  cp #ff
  jp z,lab0E14
  inc (hl)
lab0E13:
  inc (hl)
lab0E14:
  inc (hl)
  jp lab0E28
lab0E18:
  and a
  jp z,lab0E28
  cp #1
  jp z,lab0E27
  cp #2
  jr z,lab0E26
  dec (hl)
lab0E26:
  dec (hl)
lab0E27:
  dec (hl)
lab0E28:
  ld a,(hl)
  cp #b7
  jp c,lab0E41
  ld a,#b7
  ld (lab267D),a
  ld a,#1
  ld (lab201C),a
  ld hl,#0000
  ld (lab2013),hl
  jp lab0E56
lab0E41:
  ld hl,lab201C
  ld (hl),#0
  cp #3
  jp nc,lab0E56
  ld a,#3
  ld (lab267D),a
  ld hl,#0000
  ld (lab2013),hl
lab0E56:
  ld hl,(lab2013)
  bit 7,h
  jp z,lab0E79
  res 7,h
  ld bc,#000F
  ld a,(lab1F15)
  add a,c
  ld c,a
  and a
  sbc hl,bc
  jp nc,lab0E71
  ld hl,#0000
lab0E71:
  set 7,h
  ld (lab2013),hl
  jp lab0E89
lab0E79:
  ld a,#f
  ld bc,(lab1F14)
  sub c
  ld c,a
  ld b,#0
  and a
  sbc hl,bc
  ld (lab2013),hl
lab0E89:
  jp lab0ECE
lab0E8C:
  ld hl,(lab200D)
  ld de,lab00B4
  add hl,de
  ld b,h
  ld h,#0
  ld (lab200D),hl
  ld a,(lab267B)
  sub b
  cp #1
  jp nc,lab0EA4
  ld a,#1
lab0EA4:
  ld (lab267B),a
  ld a,#1
  ld (lab1F13),a
  ret
lab0EAD:
  ld hl,(lab200F)
  ld de,lab00B4
  add hl,de
  ld b,h
  ld h,#0
  ld (lab200F),hl
  ld a,(lab267B)
  add a,b
  cp #75
  jp c,lab0EC5
  ld a,#75
lab0EC5:
  ld (lab267B),a
  ld a,#2
  ld (lab1F13),a
  ret
lab0ECE:
  ld hl,lab1F17
  xor a
  ld (lab2634),a
lab0ED5:
  ld a,(hl)
  cp #ff
  jp z,lab0FA9
  push hl
  ld a,(lab267B)
  ld b,a
  ld c,(hl)
  ld d,c
  inc hl
  ld a,(hl)
  inc hl
  add a,c
  ld (lab1F67),a
  inc b
  cp b
  jp c,lab0FA1
  ld a,#6
  add a,b
  cp c
  jp c,lab0FA1
  ld a,(lab267D)
  ld b,a
  ld c,(hl)
  inc hl
  ld a,(hl)
  add a,c
  ld e,a
  cp b
  jp c,lab0FA1
  ld a,#10
  add a,b
  cp c
  jp c,lab0FA1
  ld l,c
  cp c
  jp z,lab0F24
  inc a
  cp c
  jp z,lab0F24
  inc a
  cp c
  jp z,lab0F24
  dec a
  dec a
  dec a
  cp c
  jp z,lab0F24
  dec a
  cp c
  jp nz,lab0F42
lab0F24:
  ld a,(lab2014)
  bit 7,a
  jp z,lab0F8A
  ld a,#10
  ld c,a
  ld a,l
  sub c
  ld (lab267D),a
  ld a,#1
  ld (lab201C),a
  ld hl,#0000
  ld (lab2013),hl
  jp lab0F8A
lab0F42:
  ld a,e
  cp b
  jp z,lab0F5C
  inc a
  cp b
  jp z,lab0F5C
  inc a
  cp b
  jp z,lab0F5C
  dec a
  dec a
  dec a
  cp b
  jp z,lab0F5C
  dec a
  cp b
  jr nz,lab0F84
lab0F5C:
  ld a,(lab267B)
  ld c,a
  ld a,#8
  add a,c
  cp d
  jp z,lab0F84
  ld a,(lab1F67)
  inc c
  cp c
  jp z,lab0F84
  ld a,(lab2014)
  bit 7,a
  jr nz,lab0F84
  ld hl,#0000
  ld (lab2013),hl
  ld a,(lab2679)
  ld (lab267D),a
  jr lab0F8A
lab0F84:
  ld a,(lab2677)
  ld (lab267B),a
lab0F8A:
  ld hl,lab2634
  inc (hl)
  ld a,(lab2633)
  and a
  jr nz,lab0FA1
  ld a,#6
  ld (lab2633),a
  ld (lab2923),a
  ld c,#5a
  call lab2722
lab0FA1:
  pop hl
  inc hl
  inc hl
  inc hl
  inc hl
  jp lab0ED5
lab0FA9:
  ld a,(lab2634)
  and a
  ret nz
  ld (lab2633),a
  ret
lab0FB2:
  ld a,(lab267B)
  add a,#2
  ld e,a
  ld a,(lab267D)
  add a,#4
  ld d,a
  ld hl,lab2681
  ld a,#8
lab0FC3:
  ex af,af''
  push de
  ld a,(hl)
  and a
  jr z,lab0FFF
  cp #3
  jr z,lab0FFF
  ld bc,#0005
  add hl,bc
  ld c,(hl)
  ld a,#8
  add a,c
  cp e
  jr c,lab0FF4
  ld a,#2
  add a,e
  cp c
  jr c,lab0FF4
  inc hl
  inc hl
  ld c,(hl)
  dec hl
  dec hl
  ld a,#10
  add a,c
  cp d
  jr c,lab0FF4
  ld a,#8
  add a,d
  cp c
  jr c,lab0FF4
  pop de
  ex af,af''
  ld b,a
  and a
  ret
lab0FF4:
  ld de,#0006
  add hl,de
  ex af,af''
  pop de
  dec a
  jr nz,lab0FC3
  scf
  ret
lab0FFF:
  ld de,#000B
  add hl,de
  ex af,af''
  pop de
  dec a
  jr nz,lab0FC3
  scf
  ret
lab100A:
  ld hl,(lab1F69)
  dec hl
  ld (lab1F69),hl
  ld a,h
  or l
  jp nz,lab104D
  ld de,lab26A0
  ld hl,lab1FFC
  ld a,#6
lab101E:
  ldi
  ldi
  ex de,hl
  ld bc,#0009
  add hl,bc
  ex de,hl
  dec a
  jp nz,lab101E
  xor a
  ld (lab2018),a
  ld (lab2016),a
  ld hl,lab1FB4
  ld b,#6
lab1038:
  ld (hl),#50
  inc hl
  djnz lab1038
  ld hl,lab032A
  ld de,lab032E
  ld (hl),e
  inc hl
  ld (hl),d
  inc hl
  ld (hl),#0
  inc hl
  ld (hl),#0
  ret
lab104D:
  ld de,lab0064
  and a
  sbc hl,de
  ret nz
  ld hl,lab032A
  ld de,lab033A
  ld (hl),e
  inc hl
  ld (hl),d
  inc hl
  ld (hl),#0
  inc hl
  ld (hl),#0
  ret
lab1064:
  ld a,(lab2F6D)
  ld b,a
  ld a,(lab1F6D)
  inc a
  ld (lab1F6D),a
  cp b
  ret c
  xor a
  ld (lab1F6D),a
  ld a,(lab1FCF)
  inc a
  cp #80
  jr z,lab1080
  ld (lab1FCF),a
lab1080:
  ld a,(lab1FD0)
  inc a
  cp #80
  jr z,lab108B
  ld (lab1FD0),a
lab108B:
  ld a,(lab1F6E)
  dec a
  cp #85
  jr z,lab109B
  ld (lab1F6E),a
  neg
  ld (lab1F6F),a
lab109B:
  ld a,(lab1F70)
  dec a
  cp #85
  ret z
  ld (lab1F70),a
  neg
  ld (lab1F71),a
  ret
lab10AB:
  ld hl,lab0417
  ld de,lab1F72
  ld bc,#000C
  ldir
  ret
lab10B7:
  ld a,(lab2018)
  cp #1
  jp z,lab100A
  cp #2
  jr nz,lab10C7
  dec a
  ld (lab2018),a
lab10C7:
  ld hl,lab1FB4
  ld (lab1FCA),hl
  ld hl,lab1F84
  ld (lab1FBA),hl
  ld hl,lab1F90
  ld (lab1FBC),hl
  ld hl,lab1F9C
  ld (lab1FBE),hl
  ld hl,lab1FA2
  ld (lab1FC0),hl
  ld hl,lab1FA8
  ld (lab1FC2),hl
  ld hl,lab1FAE
  ld (lab1FC4),hl
  ld hl,lab1F7E
  ld (lab1FC6),hl
  ld hl,lab2697
  ld (lab1FCC),hl
  ld hl,lab1F72
  ld a,(lab1FCE)
  ld b,a
lab1104:
  push bc
  push hl
  ld e,l
  ld d,h
  ld c,(hl)
  inc hl
  ld b,(hl)
  inc hl
  ld hl,lab1112+1
  ld (hl),c
  inc hl
  ld (hl),b
lab1112:
  call lab1112
  ld hl,(lab1FBE)
  inc hl
  ld (lab1FBE),hl
  ld hl,(lab1FBA)
  inc hl
  inc hl
  ld (lab1FBA),hl
  ld hl,(lab1FC0)
  inc hl
  ld (lab1FC0),hl
  ld hl,(lab1FCA)
  ld a,(hl)
  and a
  jr z,lab1134
  dec a
  ld (hl),a
lab1134:
  inc hl
  ld (lab1FCA),hl
  ld hl,(lab1FBC)
  inc hl
  inc hl
  ld (lab1FBC),hl
  ld hl,(lab1FC2)
  inc hl
  ld (lab1FC2),hl
  ld hl,(lab1FC4)
  inc hl
  ld (lab1FC4),hl
  ld hl,(lab1FC6)
  inc hl
  ld (lab1FC6),hl
  ld hl,(lab1FCC)
  ld de,#000B
  add hl,de
  ld (lab1FCC),hl
  pop hl
  pop bc
  inc hl
  inc hl
  djnz lab1104
  ret
data1166:
  db #21,#cc,#11,#eb,#73,#23,#72,#3e ;....s.r.
  db #02,#32,#97,#26,#cd,#e1,#1a,#e6
  db #03,#a7,#28,#0c,#3d,#28,#0f,#3d
  db #28,#12,#3e,#02,#06,#b6,#18,#20
  db #3e,#02,#06,#03,#18,#1a,#3e,#73 ;.......s
  db #06,#03,#18,#04,#3e,#73,#06,#b6 ;.....s..
  db #32,#9c,#26,#78,#32,#9e,#26,#21 ;...x....
  db #04,#53,#22,#a0,#26,#c3,#b3,#11 ;.S......
  db #32,#9c,#26,#78,#32,#9e,#26,#21 ;...x....
  db #04,#54,#22,#a0,#26,#3a,#9c,#26 ;.T......
  db #32,#98,#26,#3a,#9e,#26,#32,#9a
  db #26,#2a,#c2,#1f,#36,#fe,#2a,#ca
  db #1f,#36,#50,#c3,#f0,#12 ;..P...
lab11CC:
  db #3a,#18,#20,#a7,#c0,#32,#32,#26
  db #2a,#ba,#1f,#ed,#5b,#bc,#1f,#4e ;.......N
  db #1a,#6f,#26,#00,#cb,#79,#ca,#ea ;.o...y..
  db #11,#06,#ff,#c3,#eb,#11,#44,#cb ;......D.
  db #21,#cb,#18,#09,#eb,#2a,#bc,#1f
  db #73,#7a,#32,#32,#26,#3a,#9c,#26 ;sz......
  db #82,#32,#9c,#26,#ed,#5b,#ba,#1f
  db #eb,#23,#13,#4e,#1a,#6f,#26,#00 ;...N.o..
  db #cb,#79,#ca,#16,#12,#06,#ff,#c3 ;.y......
  db #17,#12,#44,#cb,#21,#cb,#10,#09 ;..D.....
  db #eb,#2a,#bc,#1f,#23,#73,#3a,#32 ;.....s..
  db #26,#b2,#32,#32,#26,#3a,#9e,#26
  db #82,#32,#9e,#26,#3a,#9c,#26,#fe
  db #02,#d2,#40,#12,#3e,#02,#32,#9c
  db #26,#c3,#67,#12,#fe,#71,#da,#4d ;..g..q.M
  db #12,#3e,#70,#32,#9c,#26,#c3,#67 ;..p....g
  db #12,#3a,#9e,#26,#fe,#03,#d2,#5d
  db #12,#3e,#03,#32,#9e,#26,#c3,#67 ;.......g
  db #12,#fe,#b7,#da,#76,#12,#3e,#b6 ;....v...
  db #32,#9e,#26,#2a,#ba,#1f,#7e,#ed
  db #44,#77,#23,#7e,#ed,#44,#77,#c3 ;Dw...Dw.
  db #43,#13,#ed,#4b,#9c,#26,#3a,#9e ;C..K....
  db #26,#47,#cd,#ff,#1a,#7e,#fe,#ff ;.G......
  db #ca,#db,#12,#d9,#2a,#be,#1f,#7e
  db #a7,#20,#1f,#36,#01,#cd,#e1,#1a
  db #2a,#ba,#1f,#e6,#01,#28,#08,#7e
  db #23,#46,#77,#2b,#70,#18,#0b,#7e ;.Fw.p...
  db #ed,#44,#23,#46,#77,#78,#ed,#44 ;.D.Fwx.D
  db #2b,#77,#d9,#ed,#4b,#9c,#26,#3a ;.w..K...
  db #9e,#26,#47,#cd,#26,#1b,#7e,#fe ;..G.....
  db #ff,#ca,#43,#13,#3a,#98,#26,#32 ;..C.....
  db #9c,#26,#3a,#9a,#26,#32,#9e,#26
  db #2a,#ba,#1f,#7e,#ed,#44,#77,#23 ;.....Dw.
  db #7e,#ed,#44,#77,#c3,#43,#13,#2a ;..Dw.C..
  db #be,#1f,#36,#00,#2a,#c0,#1f,#46 ;.......F
  db #3a,#32,#26,#80,#77,#fe,#0a,#da ;....w...
  db #43,#13,#af,#77,#3a,#cf,#1f,#32 ;C..w....
  db #d1,#1f,#3a,#d0,#1f,#32,#d2,#1f
  db #3a,#9c,#26,#47,#3a,#7b,#26,#90 ;...G....
  db #30,#0c,#08,#3a,#cf,#1f,#ed,#44 ;.......D
  db #32,#d1,#1f,#08,#ed,#44,#5f,#3a ;.....D..
  db #9e,#26,#47,#3a,#7d,#26,#90,#30 ;..G.....
  db #0c,#08,#3a,#d0,#1f,#ed,#44,#32 ;......D.
  db #d2,#1f,#08,#ed,#44,#bb,#38,#0d ;....D...
  db #2a,#ba,#1f,#36,#00,#23,#3a,#d2
  db #1f,#77,#c3,#43,#13,#2a,#ba,#1f ;.w.C....
  db #3a,#d1,#1f,#77,#23,#36,#00,#2a ;...w....
  db #ba,#1f,#7e,#a7,#28,#0f,#cb,#7f
  db #28,#05,#21,#04,#53,#18,#03,#21 ;....S...
  db #04,#54,#22,#a0,#26,#c9 ;.T....
lab135A:
  db #dd,#2a,#cc,#1f,#21,#a9,#13,#eb
  db #73,#23,#72,#3e,#05,#32,#23,#29 ;s.r.....
  db #0e,#fa,#cd,#22,#27,#dd,#36,#00
  db #02,#2a,#08,#20,#7e,#cb,#3f,#47 ;.......G
  db #cb,#3f,#cb,#3f,#80,#dd,#77,#05 ;......w.
  db #dd,#77,#01,#23,#7e,#dd,#77,#03 ;.w....w.
  db #dd,#77,#07,#23,#22,#08,#20,#2a ;.w......
  db #c2,#1f,#36,#50,#2a,#ba,#1f,#36 ;...P....
  db #00,#23,#36,#00,#2a,#c6,#1f,#36
  db #00,#2a,#ca,#1f,#36,#50,#c9 ;.....P.
lab13A9:
  db #21,#0a,#20,#dd,#2a,#cc,#1f,#01
  db #b7,#13,#cd,#d7,#0c,#c9,#eb,#11
  db #bf,#13,#73,#23,#72,#c9 ;..s.r.
lab13BF:
  db #3a,#18,#20,#a7,#c0,#ed,#53,#d3 ;......S.
  db #1f,#dd,#2a,#cc,#1f,#21,#04,#48 ;.......H
  db #dd,#75,#09,#dd,#74,#0a,#dd,#4e ;.u..t..N
  db #05,#dd,#46,#07,#cd,#ff,#1a,#7e ;..F.....
  db #fe,#ff,#c2,#9a,#14,#2a,#c6,#1f
  db #36,#00,#2a,#c0,#1f,#4e,#06,#00 ;.....N..
  db #2a,#ba,#1f,#5e,#23,#56,#e5,#21 ;.....V..
  db #07,#00,#19,#eb,#e1,#72,#2b,#73 ;.....r.s
  db #eb,#09,#7c,#a7,#ca,#10,#14,#3d
  db #ca,#0d,#14,#dd,#34,#07,#dd,#34
  db #07,#eb,#2a,#c0,#1f,#73,#dd,#7e ;.....s..
  db #07,#fe,#b7,#da,#4b,#15,#3e,#b7 ;....K...
  db #dd,#77,#07,#3e,#0b,#32,#23,#29 ;.w......
  db #0e,#64,#cd,#22,#27,#2a,#be,#1f ;.d......
  db #36,#00,#2a,#0b,#20,#5e,#23,#56 ;.......V
  db #23,#22,#0b,#20,#eb,#e9,#11,#4e ;.......N
  db #17,#2a,#d3,#1f,#73,#23,#72,#dd ;....s.r.
  db #2a,#cc,#1f,#2a,#ba,#1f,#36,#ff
  db #23,#36,#01,#21,#04,#5c,#dd,#75 ;.......u
  db #09,#dd,#74,#0a,#2a,#ca,#1f,#36 ;..t.....
  db #50,#c3,#4b,#15,#dd,#2a,#cc,#1f ;P.K.....
  db #11,#82,#15,#2a,#d3,#1f,#73,#23 ;......s.
  db #72,#af,#2a,#ba,#1f,#77,#23,#77 ;r....w.w
  db #c3,#5b,#14,#dd,#2a,#cc,#1f,#11
  db #4c,#15,#2a,#d3,#1f,#73,#23,#72 ;L....s.r
  db #af,#2a,#ba,#1f,#77,#23,#77,#21 ;....w.w.
  db #04,#57,#dd,#75,#09,#dd,#74,#0a ;.W.u..t.
  db #c3,#5b,#14,#e5,#2a,#ba,#1f,#36
  db #00,#23,#36,#00,#e1,#e5,#dd,#4e ;.......N
  db #05,#dd,#46,#07,#cd,#26,#1b,#7e ;..F.....
  db #fe,#ff,#ca,#bb,#14,#2a,#c2,#1f
  db #7e,#ed,#44,#77,#2a,#c0,#1f,#4e ;..Dw...N
  db #06,#00,#eb,#2a,#c2,#1f,#7e,#6f ;.......o
  db #cb,#7f,#ca,#dc,#14,#e5,#21,#04
  db #48,#dd,#75,#09,#dd,#74,#0a,#e1 ;H.u..t..
  db #26,#ff,#c3,#e8,#14,#e5,#21,#04
  db #47,#dd,#75,#09,#dd,#74,#0a,#e1 ;G.u..t..
  db #60,#09,#7c,#dd,#86,#05,#dd,#77 ;.......w
  db #05,#eb,#73,#e1,#fe,#02,#d2,#00 ;..s.....
  db #15,#3e,#02,#dd,#77,#05,#c3,#38 ;....w...
  db #15,#fe,#74,#da,#0d,#15,#3e,#74 ;..t....t
  db #dd,#77,#05,#c3,#38,#15,#ed,#5b ;.w......
  db #c2,#1f,#dd,#7e,#05,#46,#b8,#c2 ;.....F..
  db #1f,#15,#1a,#cb,#7f,#c2,#30,#15
  db #23,#7e,#80,#d6,#08,#dd,#be,#05
  db #c2,#4b,#15,#1a,#cb,#7f,#c2,#4b ;.K.....K
  db #15,#2a,#c6,#1f,#7e,#a7,#c2,#4b ;.......K
  db #15,#2a,#c2,#1f,#7e,#ed,#44,#77 ;......Dw
  db #dd,#7e,#01,#dd,#77,#05,#dd,#7e ;....w...
  db #03,#dd,#77,#07,#c9,#2a,#be,#1f ;..w.....
  db #dd,#2a,#cc,#1f,#01,#5a,#15,#cd ;.....Z..
  db #d7,#0c,#c9,#eb,#11,#62,#15,#73 ;.....b.s
  db #23,#72,#c9,#3a,#18,#20,#a7,#c0 ;.r......
  db #dd,#2a,#cc,#1f,#21,#04,#57,#dd ;......W.
  db #46,#05,#3a,#7b,#26,#b8,#38,#03 ;F.......
  db #21,#04,#58,#dd,#75,#09,#dd,#74 ;..X.u..t
  db #0a,#18,#32,#2a,#be,#1f,#dd,#2a
  db #cc,#1f,#01,#90,#15,#cd,#d7,#0c
  db #c9,#eb,#11,#98,#15,#73,#23,#72 ;.....s.r
  db #c9,#3a,#18,#20,#a7,#c0,#dd,#2a
  db #cc,#1f,#21,#04,#59,#dd,#7e,#05 ;....Y...
  db #e6,#02,#28,#03,#21,#04,#5a,#dd ;......Z.
  db #75,#09,#dd,#74,#0a,#dd,#7e,#05 ;u..t....
  db #47,#3a,#7b,#26,#b8,#d2,#da,#15 ;G.......
  db #3a,#70,#1f,#4f,#3a,#d5,#1f,#47 ;.p.O...G
  db #2a,#ba,#1f,#7e,#90,#cb,#7f,#ca
  db #d6,#15,#b9,#d2,#d6,#15,#79,#77 ;......yw
  db #c3,#f2,#15,#3a,#71,#1f,#4f,#3a ;....q.O.
  db #d5,#1f,#47,#2a,#ba,#1f,#7e,#80 ;..G.....
  db #cb,#7f,#c2,#f1,#15,#b9,#da,#f1
  db #15,#79,#77,#57,#23,#dd,#46,#07 ;.ywW..F.
  db #3a,#7d,#26,#b8,#d2,#16,#16,#3a
  db #6e,#1f,#4f,#3a,#d6,#1f,#47,#7e ;n.O...G.
  db #90,#cb,#7f,#ca,#12,#16,#b9,#d2
  db #12,#16,#79,#77,#c3,#2b,#16,#3a ;..yw....
  db #6f,#1f,#4f,#3a,#d6,#1f,#47,#7e ;o.O...G.
  db #80,#cb,#7f,#c2,#2a,#16,#b9,#da
  db #2a,#16,#79,#77,#5f,#2a,#bc,#1f ;..yw....
  db #7e,#e5,#6f,#26,#00,#4a,#cb,#79 ;..o..J.y
  db #ca,#3f,#16,#06,#ff,#c3,#40,#16
  db #44,#cb,#21,#cb,#10,#09,#4d,#44 ;D.....MD
  db #e1,#71,#dd,#7e,#05,#80,#fe,#02 ;.q......
  db #d2,#62,#16,#3e,#02,#08,#d9,#2a ;.b......
  db #ba,#1f,#7e,#ed,#44,#77,#d9,#08 ;....Dw..
  db #c3,#74,#16,#fe,#74,#da,#74,#16 ;.t..t.t.
  db #3e,#74,#08,#d9,#2a,#ba,#1f,#7e ;.t......
  db #ed,#44,#77,#d9,#08,#dd,#77,#05 ;.Dw...w.
  db #23,#7e,#e5,#6f,#26,#00,#4b,#cb ;...o..K.
  db #79,#ca,#88,#16,#06,#ff,#c3,#89 ;y.......
  db #16,#44,#cb,#21,#cb,#10,#09,#4d ;.D.....M
  db #44,#e1,#71,#dd,#7e,#07,#80,#fe ;D.q.....
  db #03,#d2,#ac,#16,#3e,#03,#08,#d9
  db #2a,#ba,#1f,#23,#7e,#ed,#44,#77 ;......Dw
  db #d9,#08,#c3,#bf,#16,#fe,#b7,#da
  db #bf,#16,#3e,#b7,#08,#d9,#2a,#ba
  db #1f,#23,#7e,#ed,#44,#77,#d9,#08 ;....Dw..
  db #dd,#77,#07,#dd,#4e,#05,#dd,#46 ;.w..N..F
  db #07,#cd,#ff,#1a,#7e,#fe,#ff,#ca
  db #4d,#17,#e5,#3e,#07,#32,#23,#29 ;M.......
  db #0e,#64,#cd,#22,#27,#e1,#1e,#00 ;.d......
  db #dd,#7e,#05,#47,#4e,#23,#7e,#23 ;...GN...
  db #81,#b8,#28,#05,#3d,#b8,#c2,#f2
  db #16,#cb,#c3,#3e,#06,#80,#b9,#28
  db #05,#0c,#b9,#c2,#ff,#16,#cb,#cb
  db #dd,#7e,#07,#47,#4e,#23,#7e,#81 ;...GN...
  db #b8,#28,#05,#3d,#b8,#c2,#11,#17
  db #cb,#d3,#3e,#10,#80,#b9,#28,#04
  db #0c,#b9,#20,#02,#cb,#db,#2a,#ba
  db #1f,#3e,#03,#a3,#ca,#36,#17,#dd
  db #7e,#01,#dd,#77,#05,#dd,#7e,#03 ;...w....
  db #dd,#77,#07,#7e,#ed,#44,#77,#3e ;.w...Dw.
  db #0c,#a3,#ca,#4d,#17,#dd,#7e,#03 ;...M....
  db #dd,#77,#07,#dd,#7e,#01,#dd,#77 ;.w.....w
  db #05,#23,#7e,#ed,#44,#77,#c9,#3a ;....Dw..
  db #18,#20,#a7,#c0,#dd,#2a,#cc,#1f
  db #dd,#7e,#05,#fe,#04,#30,#07,#3e
  db #05,#dd,#77,#05,#18,#23,#fe,#72 ;..w....r
  db #38,#07,#3e,#71,#dd,#77,#05,#18 ;...q.w..
  db #18,#dd,#7e,#07,#fe,#05,#30,#07
  db #3e,#06,#dd,#77,#07,#18,#0a,#fe ;...w....
  db #b7,#da,#a7,#17,#3e,#b6,#dd,#77 ;.......w
  db #07,#3a,#7b,#26,#cb,#3f,#dd,#46 ;.......F
  db #05,#cb,#38,#90,#2a,#ba,#1f,#77 ;.......w
  db #3a,#7d,#26,#dd,#46,#07,#cb,#3f ;....F...
  db #cb,#38,#90,#23,#77,#c3,#00,#18 ;....w...
  db #2a,#ba,#1f,#ed,#5b,#bc,#1f,#4e ;.......N
  db #1a,#6f,#26,#00,#cb,#79,#ca,#c1 ;.o...y..
  db #17,#06,#ff,#cb,#21,#cb,#10,#c3
  db #c6,#17,#44,#cb,#21,#cb,#10,#09 ;..D.....
  db #eb,#2a,#bc,#1f,#73,#7a,#dd,#86 ;....sz..
  db #05,#dd,#77,#05,#ed,#5b,#ba,#1f ;..w.....
  db #eb,#23,#13,#4e,#1a,#6f,#26,#00 ;...N.o..
  db #cb,#79,#ca,#ed,#17,#06,#ff,#cb ;.y......
  db #21,#cb,#10,#c3,#f2,#17,#44,#cb ;......D.
  db #21,#cb,#10,#09,#eb,#2a,#bc,#1f
  db #23,#73,#7a,#dd,#86,#07,#dd,#77 ;.sz....w
  db #07,#dd,#4e,#05,#dd,#46,#07,#cd ;..N..F..
  db #ff,#1a,#7e,#fe,#ff,#ca,#3b,#18
  db #3e,#07,#32,#23,#29,#0e,#64,#cd ;......d.
  db #22,#27,#dd,#7e,#01,#dd,#77,#05 ;......w.
  db #dd,#7e,#03,#dd,#77,#07,#cd,#e1 ;....w...
  db #1a,#2a,#ba,#1f,#e6,#01,#28,#07
  db #7e,#ed,#44,#77,#c3,#3b,#18,#23 ;..Dw....
  db #7e,#ed,#44,#77,#c9 ;..Dw.
lab183C:
  ld a,(lab2019)
  and a
  jp nz,lab189E
  ld a,(lab26CE)
  and a
  ret nz
  ld a,(lab201B)
  and a
  ret nz
  call lab1AE1
  and a
  ret nz
  call lab1AE1
  cp #dc
  ret c
  ld a,(lab2F70)
  cp #3
  ret nc
  call lab1AE1
  cp #1e
  jr nc,lab1876
  ld a,(lab1FD7)
  and a
  jr nz,lab186E
  call lab1D7F
lab186E:
  ld a,#1
  ld (lab1FD7),a
  dec a
  jr lab1883
lab1876:
  ld a,(lab1FD7)
  and a
  jr z,lab187F
  call lab1D7F
lab187F:
  xor a
  ld (lab1FD7),a
lab1883:
  ld (lab1FD8),a
  inc a
  ld (lab2019),a
  inc a
  ld (lab268C),a
  ld a,#3
  ld (lab268F),a
  ld (lab2693),a
  ld a,#70
  ld (lab2691),a
  ld (lab268D),a
lab189E:
  ld a,(lab1FD8)
  and a
  jr z,lab18D5
  dec a
  jr z,lab18BF
  ld hl,(lab1FD9)
  ld de,(lab1FDD)
  and a
  sbc hl,de
  ld a,l
  ld (lab1FD9),a
  ld a,(lab2691)
  add a,h
  ld (lab2691),a
  jp lab18E8
lab18BF:
  ld hl,(lab1FD9)
  ld de,(lab1FDD)
  add hl,de
  ld a,l
  ld (lab1FD9),a
  ld a,(lab2691)
  add a,h
  ld (lab2691),a
  jp lab18E8
lab18D5:
  ld hl,(lab1FDB)
  ld de,(lab1FDF)
  add hl,de
  ld a,l
  ld (lab1FDB),a
  ld a,(lab2693)
  add a,h
  ld (lab2693),a
lab18E8:
  ld a,(lab2691)
  cp #2
  jp nc,lab18FD
  ld a,#2
  ld (lab2691),a
  ld a,#1
  ld (lab1FD8),a
  jp lab190C
lab18FD:
  cp #74
  jp c,lab190C
  ld a,#74
  ld (lab2691),a
  ld a,#2
  ld (lab1FD8),a
lab190C:
  ld a,(lab2691)
  ld c,a
  ld a,(lab2693)
  ld b,a
  call lab1AFF
  ld a,(hl)
  cp #ff
  jp z,lab193E
  ld a,(lab1FD8)
  and a
  jr z,lab1962
  ld a,(lab2691)
  ld c,a
  ld a,(lab2693)
  ld b,a
  call lab1B26
  ld a,(hl)
  cp #ff
  jr z,lab196B
  ld a,(lab1FD8)
  cpl
  and #3
  ld (lab1FD8),a
  jr lab196B
lab193E:
  ld a,(lab2693)
  cp #b7
  jp c,lab195C
  ld a,#b7
  ld (lab2693),a
  ld a,(lab1FD8)
  and a
  jr nz,lab196B
  call lab1AE1
  and #1
  inc a
  ld (lab1FD8),a
  jr lab196B
lab195C:
  xor a
  ld (lab1FD8),a
  jr lab196B
lab1962:
  call lab1AE1
  and #1
  inc a
  ld (lab1FD8),a
lab196B:
  ld hl,lab5104
  ld a,(lab2691)
  and #2
  jr z,lab1978
  ld hl,lab5204
lab1978:
  ld (lab2695),hl
  ret
lab197C:
  ld a,(lab201B)
  and a
  jp nz,lab19C0
  ld a,(lab201A)
  and a
  ret z
  xor a
  ld (lab201A),a
  ld a,(lab26CE)
  and a
  ret nz
  ld a,(lab2019)
  and a
  ret nz
  ld a,(lab2018)
  and a
  ret nz
  inc a
  ld (lab201B),a
  inc a
  ld (lab2681),a
  ld a,#3
  ld (lab2688),a
  ld (lab2684),a
  ld a,#40
  ld (lab2686),a
  ld (lab2682),a
  ld a,(lab1FE2)
  ld (lab1FE3),a
  ld a,(lab1FE1)
  ld (lab1FE4),a
  ret
lab19C0:
  ld a,(lab2688)
  ld (lab0354),a
  ld a,#1
  ld (lab2923),a
  ld c,#fa
  call lab2722
  ld de,(lab1FE4)
  bit 7,e
  jp z,lab19DE
  ld d,#ff
  jp lab19E0
lab19DE:
  ld d,#0
lab19E0:
  sla e
  rl d
  ld hl,(lab1FE5)
  ld h,#0
  add hl,de
  ld a,l
  ld (lab1FE5),a
  ld b,h
  ld a,(lab2686)
  add a,b
  ld (lab2686),a
  cp #2
  jp nc,lab1A0B
  ld a,#2
  ld (lab2686),a
  ld a,(lab1FE4)
  neg
  ld (lab1FE4),a
  jp lab1A1D
lab1A0B:
  cp #74
  jp c,lab1A1D
  ld a,#74
  ld (lab2686),a
  ld a,(lab1FE4)
  neg
  ld (lab1FE4),a
lab1A1D:
  ld de,(lab1FE3)
  bit 7,e
  jp z,lab1A2B
  ld d,#ff
  jp lab1A2D
lab1A2B:
  ld d,#0
lab1A2D:
  ld hl,(lab1FE7)
  ld h,#0
  add hl,de
  ld a,l
  ld (lab1FE7),a
  ld b,h
  ld a,(lab2688)
  add a,b
  ld (lab2688),a
  cp #3
  jp nc,lab1A54
  ld a,#3
  ld (lab2688),a
  ld a,(lab1FE3)
  neg
  ld (lab1FE3),a
  jp lab1A66
lab1A54:
  cp #b7
  jp c,lab1A66
  ld a,#b7
  ld (lab2688),a
  ld a,(lab1FE3)
  neg
  ld (lab1FE3),a
lab1A66:
  ld a,(lab2686)
  ld c,a
  ld a,(lab2688)
  ld b,a
  call lab1AFF
  ld a,(hl)
  cp #ff
  jp z,lab1AD0
  ld e,#0
  ld a,(lab2686)
  ld b,a
  ld c,(hl)
  inc hl
  ld a,(hl)
  inc hl
  add a,c
  cp b
  jp nz,lab1A88
  set 0,e
lab1A88:
  ld a,#6
  add a,b
  cp c
  jp nz,lab1A91
  set 1,e
lab1A91:
  ld a,(lab2688)
  ld b,a
  ld c,(hl)
  inc hl
  ld a,(hl)
  add a,c
  cp b
  jp nz,lab1A9F
  set 2,e
lab1A9F:
  ld a,#10
  add a,b
  cp c
  jp nz,lab1AA8
  set 3,e
lab1AA8:
  ld a,#3
  and e
  jp z,lab1AB6
  ld a,(lab1FE4)
  neg
  ld (lab1FE4),a
lab1AB6:
  ld a,#c
  and e
  jp z,lab1AC4
  ld a,(lab1FE3)
  neg
  ld (lab1FE3),a
lab1AC4:
  ld a,(lab2684)
  ld (lab2688),a
  ld a,(lab2682)
  ld (lab2686),a
lab1AD0:
  ld hl,lab5504
  ld a,(lab2686)
  and #2
  jr z,lab1ADD
  ld hl,lab5604
lab1ADD:
  ld (lab268A),hl
  ret
lab1AE1:
  ld de,(lab1FE9)
  ld h,e
  ld l,#fd
  ld a,d
  sbc hl,de
  sbc a,#0
  sbc hl,de
  sbc a,#0
  ld e,a
  ld d,#0
  sbc hl,de
  jp nc,lab1AFA
  inc hl
lab1AFA:
  ld (lab1FE9),hl
  ld a,h
  ret
lab1AFF:
  ld hl,lab1F17
lab1B02:
  push hl
  ld a,(hl)
  cp #ff
  jr z,lab1B23
  ld e,(hl)
  inc hl
  ld a,(hl)
  inc hl
  add a,e
  cp c
  jr c,lab1B25
  ld a,#6
  add a,c
  cp e
  jr c,lab1B25
  ld e,(hl)
  inc hl
  ld a,(hl)
  add a,e
  cp b
  jr c,lab1B25
  ld a,#10
  add a,b
  cp e
  jr c,lab1B25
lab1B23:
  pop hl
  ret
lab1B25:
  pop hl
lab1B26:
  ld de,#0004
  add hl,de
  jr lab1B02
lab1B2C:
  ld b,#18
  ld a,#8
  ld (lab300E),a
  ld hl,(lab2F71)
  ld (lab1FEB),hl
  ld hl,lab206A
  ld (lab1FED),hl
  ld hl,lab4584
  ld (lab300A),hl
lab1B45:
  push bc
  ld hl,(lab1FEB)
  ld c,(hl)
  inc hl
  ld e,(hl)
  inc hl
  ld (lab1FEB),hl
  ld a,c
  cp #fe
  jr z,lab1B68
  sla c
  ld a,c
  ld (lab3006),a
  ld a,e
  ld (lab3008),a
  ld hl,(lab1FED)
  ld (lab300C),hl
  call lab3013
lab1B68:
  ld hl,(lab1FED)
  ld de,lab0040
  add hl,de
  ld (lab1FED),hl
  pop bc
  djnz lab1B45
  ret
lab1B76:
  ld l,#3
  ld a,(lab442C)
  dec a
  jr z,lab1B99
  ld l,#0
  dec a
  jr z,lab1BBE
  ld d,#8
  call lab2B16
  ld h,a
  and #8
  rra
  rra
  rra
  or l
  ld l,a
  ld a,h
  and #20
  rra
  rra
  rra
  rra
  or l
  ld l,a
lab1B99:
  ld d,#4
  call lab2B16
  and #40
  rra
  rra
  rra
  or l
  ld l,a
  ld d,#5
  call lab2B16
  and #40
  rra
  rra
  rra
  rra
  or l
  ld l,a
  ld d,#7
  call lab2B16
  and #80
  rra
  rra
  rra
  or l
  ret
lab1BBE:
  ld d,#9
  call lab2B16
  ret
data1BC4:
  db #c9
lab1BC5:
  ld hl,(lab1FEF)
  add hl,hl
  ld de,lab2DB7
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  push hl
  ld hl,(lab1FF1)
  srl h
  rr l
  dec hl
  dec hl
  ld (lab1FF3),hl
  add hl,de
  ex de,hl
  exx
  ld l,a
  ld h,#0
  ld de,#000C
  ld b,h
  ld c,l
  ld hl,#0000
lab1BEC:
  srl d
  rr e
  jp nc,lab1BF4
  add hl,bc
lab1BF4:
  sla c
  rl b
  ld a,d
  or e
  jp nz,lab1BEC
  pop de
  push hl
  exx
  pop hl
  ld bc,lab5F84
  add hl,bc
  ld b,#6
lab1C07:
  push bc
  ld b,#2
lab1C0A:
  ld c,#ff
  ld a,(hl)
  and #aa
  jr nz,lab1C13
  ld c,#55
lab1C13:
  ld a,(hl)
  and #55
  jr nz,lab1C1C
  ld a,#aa
  and c
  ld c,a
lab1C1C:
  ld a,(hl)
  and c
  ex af,af''
  ld a,c
  cpl
  ld c,a
  set 6,d
  ld a,(de)
  and c
  ld c,a
  ex af,af''
  or c
  res 6,d
  ld (de),a
  inc hl
  inc de
  djnz lab1C0A
  exx
  ex de,hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ex de,hl
  ld bc,(lab1FF3)
  add hl,bc
  push hl
  exx
  pop de
  pop bc
  djnz lab1C07
  ret
lab1C43:
  ld hl,(lab262C)
  ld (lab1FF5),hl
  ld ix,lab1F17
  ld a,(lab2F68)
  cp #5
  jr nz,lab1C59
  ld (ix+0),#ff
  ret
lab1C59:
  ld a,#4
  ld (lab1FF9),a
  ld a,#6
  ld (lab1FFA),a
  ld hl,(lab1FF5)
  ld a,(hl)
  ld (ix+0),a
  cp #ff
  ret z
  push af
  and #f0
  exx
  srl a
  srl a
  srl a
  srl a
  ld l,a
  ld h,#0
  ld de,#000E
  call lab1D68
  srl h
  rr l
  ld a,l
  add a,#5
  ld (lab1FF1),a
  sub #2
  ld (ix+0),a
  exx
  pop af
  exx
  and #f
  ld e,a
  ld d,#0
  ld hl,#0017
  call lab1D68
  srl h
  rr l
  ld a,l
  and #fe
  ld (lab1FEF),a
  ld (ix+2),a
  exx
  inc hl
  ld a,(hl)
  and #7f
  ld b,a
  sla a
  ld c,a
  sla a
  add a,c
  add a,b
  add a,#4
  srl a
  srl a
  sub #2
  ld (lab1FF7),a
  ld a,(hl)
  bit 7,a
  jp z,lab1CE7
  ld a,#c
  ld (lab1FF8),a
  xor a
  ld (lab1FFA),a
  ld a,#6
  ld (ix+3),a
  ld a,(lab1FF7)
  inc a
  inc a
  sla a
  sla a
  ld (ix+1),a
  jp lab1D03
lab1CE7:
  xor a
  ld (lab1FF9),a
  ld a,#d
  ld (lab1FF8),a
  ld a,#4
  ld (ix+1),a
  ld a,(lab1FF7)
  inc a
  inc a
  sla a
  ld b,a
  sla a
  add a,b
  ld (ix+3),a
lab1D03:
  inc hl
  ld a,(hl)
  and #f0
  srl a
  srl a
  srl a
  srl a
  push hl
  call lab1BC5
  pop hl
  ld a,(hl)
  and #f
  ld (lab1FFB),a
  inc hl
  ld (lab1FF5),hl
lab1D1E:
  ld a,(lab1FF1)
  ld b,a
  ld a,(lab1FF9)
  add a,b
  ld (lab1FF1),a
  ld a,(lab1FEF)
  ld b,a
  ld a,(lab1FFA)
  add a,b
  ld (lab1FEF),a
  ld a,(lab1FF8)
  call lab1BC5
  ld a,(lab1FF7)
  dec a
  ld (lab1FF7),a
  jp nz,lab1D1E
  ld a,(lab1FF1)
  ld b,a
  ld a,(lab1FF9)
  add a,b
  ld (lab1FF1),a
  ld a,(lab1FEF)
  ld b,a
  ld a,(lab1FFA)
  add a,b
  ld (lab1FEF),a
  ld a,(lab1FFB)
  call lab1BC5
  ld de,#0004
  add ix,de
  jp lab1C59
lab1D68:
  ld b,h
  ld c,l
  ld hl,#0000
lab1D6D:
  srl d
  rr e
  jp nc,lab1D75
  add hl,bc
lab1D75:
  sla c
  rl b
  ld a,d
  or e
  jp nz,lab1D6D
  ret
lab1D7F:
  exx
  ld hl,lab5105
  ld de,lab64B8
  exx
  ld bc,lab0040
lab1D8A:
  exx
  ld c,(hl)
  ld a,(de)
  ld (hl),a
  ld a,c
  ld (de),a
  inc hl
  inc hl
  inc de
  exx
  dec bc
  ld a,c
  or b
  jr nz,lab1D8A
  ret
lab1D9A:
  ld hl,data_SCORE_FONTE_AB
  ld (data2DAF),hl
  call lab2D71
  ld a,#80
  ld (lab2675),a
  ld hl,data_SCORE_FONTE_AB
  ld a,(hl)
  ld (lab266C),a
  ld e,a
  ld d,#0
  sla e
  rl d
  inc hl
  ld a,(hl)
  ld (lab266D),a
  inc hl
  ld a,(hl)
  ld (lab266B),a
  inc hl
  ld (lab2672),hl
  ld hl,(lab266D)
  ld h,#0
  call lab1D68
  ld de,#EFD3
  add hl,de
  ld (lab2670),hl
  ld hl,#8280
  ld (lab266E),hl
  ld a,(lab266D)
  ld b,a
lab1DDD:
  push bc
  ld a,#50
  ld (lab2669),a
  ld a,(lab266C)
  ld b,a
lab1DE7:
  push af
  ld hl,(lab2670)
  ld a,(hl)
  ld (lab2674),a
  inc hl
  ld (lab2670),hl
  ld hl,(lab266E)
  ld b,#8
lab1DF8:
  push bc
  ld a,(lab266B)
  ld b,a
lab1DFD:
  push bc
  call lab1E6A
  and a
  jr z,lab1E0F
  ld a,(lab2674)
  and #55
  sla a
  ld (hl),a
  jp lab1E15
lab1E0F:
  ld a,(lab2674)
  and #aa
  ld (hl),a
lab1E15:
  call lab1E6A
  and a
  jr z,lab1E26
  ld a,(lab2674)
  and #55
  ld b,(hl)
  or b
  ld (hl),a
  jp lab1E30
lab1E26:
  ld a,(lab2674)
  and #aa
  srl a
  ld b,(hl)
  or b
  ld (hl),a
lab1E30:
  inc hl
  pop bc
  djnz lab1DFD
  ld hl,(lab266E)
  ld a,h
  add a,#8
  ld h,a
  ld (lab266E),hl
  pop bc
  djnz lab1DF8
  sub #40
  ld h,a
  ld de,(lab266B)
  ld d,#0
  add hl,de
  ld (lab266E),hl
  ld hl,(lab2669)
  and a
  sbc hl,de
  ld (lab2669),hl
  pop af
  sub e
  jp nz,lab1DE7
  ld de,(lab266E)
  add hl,de
  ld (lab266E),hl
  pop bc
  dec b
  jp nz,lab1DDD
  ret
lab1E6A:
  push hl
  ld hl,(lab2672)
  ld a,(lab2675)
  ld c,a
  and (hl)
  ld b,a
  ld a,c
  srl a
  jr nc,lab1E7E
  rra
  inc hl
  ld (lab2672),hl
lab1E7E:
  ld (lab2675),a
  ld a,b
  pop hl
  ret
lab1E84:
  ld bc,lab09FF
  ld de,lab02F0
lab1E8A:
  ldi
  inc de
  inc de
  inc de
  djnz lab1E8A
  ret
data1E92:
  db #00,#00
lab1E94:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#80,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
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
lab1F0D:
  db #00
lab1F0E:
  db #00
lab1F0F:
  db #00
lab1F10:
  db #00
lab1F11:
  db #00,#00
lab1F13:
  db #00
lab1F14:
  db #00
lab1F15:
  db #00
lab1F16:
  db #00
lab1F17:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#80,#89
  db #15,#13,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
lab1F67:
  db #00,#00
lab1F69:
  db #00,#00,#00
lab1F6C:
  db #00
lab1F6D:
  db #00
lab1F6E:
  db #c4
lab1F6F:
  db #3c
lab1F70:
  db #c4
lab1F71:
  db #3c
lab1F72:
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff
lab1F7E:
  db #ff,#ff,#ff,#ff,#ff,#ff
lab1F84:
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff
lab1F90:
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff
lab1F9C:
  db #ff,#ff,#ff,#ff,#ff,#ff
lab1FA2:
  db #ff,#ff,#ff,#ff,#ff,#ff
lab1FA8:
  db #ff,#ff,#ff,#ff,#ff,#ff
lab1FAE:
  db #ff,#12,#00,#ff,#ff,#ff
lab1FB4:
  db #ff,#ff,#ff,#ff,#ff,#ff
lab1FBA:
  db #00,#00
lab1FBC:
  db #00,#00
lab1FBE:
  db #00,#00
lab1FC0:
  db #00,#00
lab1FC2:
  db #00,#00
lab1FC4:
  db #00,#00
lab1FC6:
  db #00,#00,#00,#00
lab1FCA:
  db #00,#00
lab1FCC:
  db #00,#00
lab1FCE:
  db #00
lab1FCF:
  db #27
lab1FD0:
  db #27,#00,#00,#00,#00,#01,#01
lab1FD7:
  db #00
lab1FD8:
  db #00
lab1FD9:
  db #00,#00
lab1FDB:
  db #00,#00
lab1FDD:
  db #3e,#00
lab1FDF:
  db #64,#00 ;d.
lab1FE1:
  db #3e
lab1FE2:
  db #64 ;d
lab1FE3:
  db #00
lab1FE4:
  db #00
lab1FE5:
  db #00,#00
lab1FE7:
  db #00,#00
lab1FE9:
  db #d2,#04
lab1FEB:
  db #00,#00
lab1FED:
  db #00,#00
lab1FEF:
  db #00,#00
lab1FF1:
  db #00,#00
lab1FF3:
  db #00,#00
lab1FF5:
  db #00,#00
lab1FF7:
  db #00
lab1FF8:
  db #00
lab1FF9:
  db #00
lab1FFA:
  db #00
lab1FFB:
  db #00
lab1FFC:
  db #ff,#ff,#ff,#ff
lab2000:
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
lab2008:
  db #00,#00,#00
lab200B:
  db #00,#00
lab200D:
  db #00,#00
lab200F:
  db #00,#00
lab2011:
  db #00,#00
lab2013:
  db #00
lab2014:
  db #00,#00
lab2016:
  db #00
lab2017:
  db #00
lab2018:
  db #00
lab2019:
  db #00
lab201A:
  db #00
lab201B:
  db #00
lab201C:
  db #00,#00
lab201E:
  db #00
lab201F:
  db #00
lab2020:
  db #00,#00
lab2022:
  db #00,#00
lab2024:
  db #00,#00
lab2026:
  db #00
lab2027:
  db #00,#00
lab2029:
  db #00
lab202A:
  db #ff,#ff,#ff,#ff,#ff,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
lab206A:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#80,#81,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#a0,#a0,#00,#14,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#13,#15,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#80,#80,#41,#10,#ff ;.....A..
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#08,#00,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#c8,#88,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#40,#c0,#10,#00,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#12,#18,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #00,#00
lab262C:
  db #00,#00
lab262E:
  db #00,#00
lab2630:
  db #00,#00,#00
lab2633:
  db #00
lab2634:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00
lab2667:
  db #00,#00
lab2669:
  db #00,#00
lab266B:
  db #00
lab266C:
  db #00
lab266D:
  db #00
lab266E:
  db #00,#00
lab2670:
  db #00,#00
lab2672:
  db #00,#00
lab2674:
  db #00
lab2675:
  db #00
lab2676:
  db #00
lab2677:
  db #00,#00
lab2679:
  db #00,#00
lab267B:
  db #0a,#00
lab267D:
  db #0a,#00
lab267F:
  db #10,#27
lab2681:
  db #00
lab2682:
  db #00,#00
lab2684:
  db #00,#00
lab2686:
  db #0a,#00
lab2688:
  db #0a,#00
lab268A:
  db #10,#27
lab268C:
  db #00
lab268D:
  db #00,#00
lab268F:
  db #00,#00
lab2691:
  db #0a,#00
lab2693:
  db #0a,#00
lab2695:
  db #10,#27
lab2697:
  db #00,#00,#00,#00,#00
lab269C:
  db #0a,#00,#0a,#00
lab26A0:
  db #10,#27,#00,#00,#00,#00,#00,#0a
  db #00,#0a,#00,#10,#27,#00,#00,#00
  db #00,#00,#0a,#00,#0a,#00,#10,#27
  db #00,#00,#00,#00,#00,#0a,#00,#0a
  db #00,#10,#27,#00,#00,#00,#00,#00
  db #0a,#00,#0a,#00,#10,#27
lab26CE:
  db #00,#00,#00,#00,#00,#0a,#00,#0a
  db #00,#10,#27,#00,#00,#00,#00,#00
  db #0a,#00,#0a,#00,#10,#27,#11,#00
  db #c0,#21,#00,#80,#3e,#08,#01,#d0
  db #07,#ed,#b0,#01,#30,#00,#09,#eb
  db #09,#eb,#3d,#20,#f1,#c9
lab26FC:
  ld a,#7
  ld c,#b8
  call lab2957
  ld a,#b8
  ld (lab2924),a
  ld a,#8
  ld c,#0
  call lab2957
  inc a
  call lab2957
  inc a
  call lab2957
  ld b,#30
  ld hl,lab2927
lab271C:
  ld (hl),#0
  inc hl
  djnz lab271C
  ret
lab2722:
  ld a,(lab2923)
  ld hl,(data2921)
  and a
lab2729:
  jr z,lab2732
  ld e,(hl)
  inc hl
  ld d,(hl)
  add hl,de
  dec a
  jr lab2729
lab2732:
  exx
  ld hl,lab2933
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (lab2925),de
  ld hl,lab2927
  ld b,#3
  ld c,(hl)
  ex af,af''
  xor a
  ex af,af''
  exx
  ld de,lab292D
  ld b,#ff
  exx
lab274D:
  ld a,(hl)
  cp c
  jr z,lab2763
  jr nc,lab2759
  ld c,a
lab2754:
  ld e,l
  ld d,h
  ex af,af''
  ld a,b
  ex af,af''
lab2759:
  inc hl
  inc hl
  exx
  inc de
  inc de
  exx
  djnz lab274D
  jr lab2790
lab2763:
  exx
  ld a,(de)
  cp b
  jr z,lab2771
  jr nc,lab276E
  ld b,a
  exx
  jr lab2754
lab276E:
  exx
  jr lab2759
lab2771:
  push hl
  push de
  ld hl,#0006
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld hl,(lab2925)
  and a
  sbc hl,de
  jr nc,lab2787
  pop de
  pop hl
  exx
  jr lab2759
lab2787:
  ld (lab2925),de
  pop de
  pop hl
  exx
  jr lab2754
lab2790:
  exx
  ld a,c
  exx
  cp c
  ret c
  ex de,hl
  ex af,af''
  ld b,#20
  dec a
  jr z,lab27A3
  srl b
  dec a
  jr z,lab27A3
  srl b
lab27A3:
  ld a,(lab2924)
  or b
  ld (lab2924),a
  ld c,a
  ld a,#7
  call lab2957
  ld (hl),a
  ld a,#f
  ld de,#0006
  add hl,de
  ld (hl),a
  add hl,de
  exx
  inc hl
  inc hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  push de
  exx
  pop bc
  ld (hl),c
  inc hl
  ld (hl),b
  dec hl
  add hl,de
  exx
  ld a,(hl)
  inc hl
  exx
  ld (hl),a
  inc hl
  ld (hl),#0
  dec hl
  add hl,de
  exx
  push hl
  exx
  pop bc
  ld (hl),c
  inc hl
  ld (hl),b
  dec hl
  add hl,de
  ld a,#1
  ld (hl),a
  ret
lab27DF:
  ld hl,lab2945
  ld de,lab2927
  ld b,#3
lab27E7:
  ld a,(de)
  and a
  jp z,lab2918
  push bc
  push hl
  push de
  ld a,#3
  sub b
  ld b,a
  ld c,#8
  and a
  jr z,lab27FF
  sla c
  dec a
  jr z,lab27FF
  sla c
lab27FF:
  ld a,c
  ld (lab2864+1),a
  ld a,b
  ld (lab2885+1),a
  sla a
  ld (lab284F+1),a
  ld (lab2846+2),a
  ld (lab28E7+1),a
  ld (lab28EC+1),a
  ld (lab288D+2),a
  srl a
  add a,#8
  ld (lab28DF+1),a
  ld (lab28C9+1),a
  ld a,(hl)
  dec a
  jp nz,lab28A8
  ld de,#FFFB
  add hl,de
  ld b,(hl)
  dec hl
  ld c,(hl)
lab282E:
  ld a,(bc)
  inc bc
  inc a
  jr nz,lab283C
  ld bc,#FFE8
  add hl,bc
  ld (hl),#0
  jp lab28C9
lab283C:
  dec a
  cp #10
  jr nz,lab284B
  ld a,(bc)
  ld ix,lab2951
lab2846:
  ld (ix+0),a
  jr lab289A
lab284B:
  cp #2
  jr nc,lab285E
lab284F:
  add a,#0
  ld (lab2859+2),a
  ld ix,lab294B
  ld a,(bc)
lab2859:
  ld (ix+0),a
  jr lab289A
lab285E:
  cp #7
  jr nz,lab2881
  ld a,(bc)
  push bc
lab2864:
  ld c,#0
  and a
  jr nz,lab2872
  ld a,(lab2924)
  or c
  ld (lab2924),a
  jr lab287C
lab2872:
  ld a,(lab2924)
  ld b,a
  ld a,c
  cpl
  and b
  ld (lab2924),a
lab287C:
  ld c,a
  ld a,#7
  jr lab2896
lab2881:
  cp #8
  jr nz,lab2891
lab2885:
  add a,#0
  ld ix,lab292D
  ld d,a
  ld a,(bc)
lab288D:
  ld (ix+0),a
  ld a,d
lab2891:
  ex af,af''
  push bc
  ld a,(bc)
  ld c,a
  ex af,af''
lab2896:
  call lab2957
  pop bc
lab289A:
  inc bc
  ld a,(bc)
  inc bc
  and a
  jr z,lab282E
  ld (hl),c
  inc hl
  ld (hl),b
  dec hl
  ld de,#0006
  add hl,de
lab28A8:
  ld (hl),a
  ld de,#FFF4
  add hl,de
  ld a,(hl)
  inc hl
  ld c,(hl)
  add a,c
  ld (hl),a
  ld a,#0
  rl a
  ex af,af''
  ld de,#FFFA
  add hl,de
  ld b,(hl)
  dec hl
  ld c,(hl)
  dec bc
  ld a,c
  or b
  jr nz,lab28D2
  ld de,#FFF4
  add hl,de
  ld (hl),#0
lab28C9:
  ld a,#8
  ld c,#0
  call lab2957
  jr lab28E4
lab28D2:
  ld (hl),c
  inc hl
  ld (hl),b
  add hl,de
  dec hl
  ex af,af''
  ld b,a
  ld a,(hl)
  sub b
  ld (hl),a
  and #f
  ld c,a
lab28DF:
  ld a,#8
  call lab2957
lab28E4:
  ld hl,lab294B
lab28E7:
  ld de,#0000
  add hl,de
  ld c,(hl)
lab28EC:
  ld a,#0
  call lab2957
  inc hl
  ex af,af''
  ld a,(hl)
  and #f
  ld c,a
  ex af,af''
  inc a
  call lab2957
  ld b,(hl)
  dec hl
  ld c,(hl)
  ld de,#0006
  add hl,de
  ld d,#0
  ld a,(hl)
  bit 7,a
  jr z,lab290C
  ld d,#ff
lab290C:
  ld e,a
  ex de,hl
  add hl,bc
  ex de,hl
  ld bc,#FFFA
  add hl,bc
  ld (hl),e
  pop de
  pop hl
  pop bc
lab2918:
  inc hl
  inc hl
  inc de
  inc de
  dec b
  jp nz,lab27E7
  ret
data2921:
  db #00,#00
lab2923:
  db #00
lab2924:
  db #00
lab2925:
  db #00,#00
lab2927:
  db #00,#00,#00,#00,#00,#00
lab292D:
  db #00,#00,#00,#00,#00,#00
lab2933:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00
lab2945:
  db #00,#00,#00,#00,#00,#00
lab294B:
  db #00,#00,#00,#00,#00,#00
lab2951:
  db #00,#00,#00,#00,#00,#00
lab2957:
  ld b,#f4
  out (c),a
  ld de,data_BACK_BUFFER
  inc b
  inc b
  out (c),d
  out (c),e
  dec b
  dec b
  out (c),c
  inc b
  inc b
  ld d,#80
  out (c),d
  out (c),e
  ret
lab2971:
  ld a,#14
  ld c,#f
lab2975:
  call lab297F
  dec c
  jr nz,lab2975
  call lab297F
  ret
lab297F:
  or #40
  ld b,#7f
  out (c),c
  out (c),a
  ret
lab2988:
  ld b,#f5
  in a,(c)
  rra
  jr nc,lab2988
  ret
lab2990:
  xor a
  ld (lab2B0E),a
  ld (lab2B0C),a
  ld (lab2B0F),a
  ld (lab2B12),a
  ld d,#8
  call lab2B16
  and #40
  and a
  ld a,(lab2B13)
  jr z,lab29B6
  ld b,a
  and #2
  jr nz,lab29BB
  ld a,b
  xor #1
  or #2
  jr lab29B8
lab29B6:
  and #1
lab29B8:
  ld (lab2B13),a
lab29BB:
  ld hl,(lab2B14)
  ld d,#2
  call lab2B16
  and #80
  jr z,lab29CE
  ld a,#1
  ld (lab2B12),a
  jr lab29D7
lab29CE:
  ld d,#2
  call lab2B16
  and #20
  jr z,lab29DB
lab29D7:
  ld de,lab004F+1
  add hl,de
lab29DB:
  ld (lab2B10),hl
  ld b,#0
lab29E0:
  push bc
  ld d,b
  call lab2B16
  and a
  jr z,lab2A2F
  ld b,#7
lab29EA:
  sla a
  jr c,lab29F1
  djnz lab29EA
  xor a
lab29F1:
  ld e,a
  ld a,b
  pop bc
  ld l,b
  push bc
  ld h,#0
  add hl,hl
  add hl,hl
  add hl,hl
  ld c,a
  ld b,#0
  add hl,bc
  ld b,c
  ld c,e
  ld de,(lab2B10)
  add hl,de
  ld e,c
  ld a,(hl)
  and a
  jr z,lab2A28
  ld c,a
  ld a,(lab2B0E)
  inc a
  ld (lab2B0E),a
  dec a
  jr z,lab2A24
  dec a
  jr nz,lab2A69
  ld a,#1
  ld (lab2B0F),a
  ld a,(lab2B0D)
  cp c
  jr nz,lab2A28
lab2A24:
  ld a,c
  ld (lab2B0C),a
lab2A28:
  ld a,e
  and a
  jr z,lab2A2F
  dec b
  jr lab29EA
lab2A2F:
  pop bc
  inc b
  ld a,#a
  cp b
  jp nz,lab29E0
  ld a,(lab2B0F)
  and a
  jp nz,lab2A67
  ld a,(lab2B0D)
  ld b,a
  ld a,(lab2B0C)
  ld (lab2B0D),a
  and a
  ret z
  cp b
  jr z,lab2A67
  ld b,a
  ld a,(lab2B13)
  and #1
  jr z,lab2A5A
  ld a,b
  call lab2CF3
  ld b,a
lab2A5A:
  ld a,(lab2B12)
  and a
  ld a,b
  ret z
  and #df
  sub #40
  ret nc
  xor a
  ret
lab2A67:
  xor a
  ret
lab2A69:
  pop bc
  xor a
  ret
data2A6C:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#5b,#0d,#5d,#00,#00,#5c,#00
  db #5e,#2d,#40,#70,#3b,#3a,#2f,#2e ;...p....
  db #30,#39,#6f,#69,#6c,#6b,#6d,#2c ;..oilkm.
  db #38,#37,#75,#79,#68,#6a,#6e,#20 ;..uyhjn.
  db #36,#35,#72,#74,#67,#66,#62,#76 ;..rtgfbv
  db #34,#33,#65,#77,#73,#64,#63,#78 ;..ewsdcx
  db #31,#32,#1b,#71,#09,#61,#00,#7a ;...q.a.z
  db #00,#00,#00,#00,#00,#00,#00,#7f
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#7b,#0d,#7d,#00,#00,#60,#00
  db #23,#3d,#7c,#50,#2b,#2a,#3f,#3e ;...P....
  db #5f,#29,#4f,#49,#4c,#4b,#4d,#3c ;..OILKM.
  db #28,#27,#55,#59,#48,#4a,#4e,#20 ;..UYHJN.
  db #26,#25,#52,#54,#47,#46,#42,#56 ;..RTGFBV
  db #24,#23,#45,#57,#53,#44,#43,#58 ;..EWSDCX
  db #21,#22,#1b,#51,#09,#41,#00,#5a ;...Q.A.Z
  db #00,#00,#00,#00,#00,#00,#00,#7f
lab2B0C:
  db #00
lab2B0D:
  db #00
lab2B0E:
  db #00
lab2B0F:
  db #00
lab2B10:
  db #00,#00
lab2B12:
  db #00
lab2B13:
  db #01
lab2B14:
  db #00,#00
lab2B16:
  ld bc,#F40E
  out (c),c
  ld b,#f6
  ld a,#c9
  out (c),a
  out (c),c
  inc b
  ld a,#92
  out (c),a
  ld a,d
  or #40
  ld b,#f6
  out (c),a
  ld b,#f4
  in a,(c)
  ld bc,#F782
  out (c),c
  dec b
  ld c,#0
  out (c),c
  cpl
  ret
data2B3F:
  db #d9,#e5,#47,#e6,#fe,#67,#2e,#00 ;..G..g..
  db #cb,#24,#cb,#24,#78,#e6,#01,#28 ;....x...
  db #04,#11,#18,#00,#19,#11
lab2B55:
  db #d0,#c7,#19,#eb,#2a,#80,#2c,#cb
  db #25,#cb,#25,#cb,#25,#01,#04,#00
  db #09,#29,#01,#b7,#2d,#09,#4e,#23 ;......N.
  db #46,#3a,#7f,#2c,#6f,#cb,#27,#85 ;F...o...
  db #c6
lab2B76:
  db #01,#6f,#26,#00,#09,#eb,#01,#18 ;.o......
  db #00,#ed,#a0,#ed,#a0,#ed,#a0,#e2
  db #93,#2b,#1b,#1b,#1b,#e5,#cd,#9a
  db #2c,#e1,#c3,#7f,#2b,#e1,#d9,#c3
  db #65,#2c ;e.
lab2B98:
  db #6f,#26,#00,#29,#5d,#54,#29,#19 ;o....T..
  db #11
lab2BA1:
  db #38,#60,#19,#22,#1d,#2d,#3e,#80
  db #32,#1f,#2d,#d9,#e5,#3a,#82,#2c
  db #e6,#0f,#47,#3a,#83,#2c,#e6,#0f ;..G.....
  db #5f,#2f,#a0,#47,#cd,#84,#2c,#32 ;...G....
  db #7d,#2c,#43,#cd,#84,#2c,#5f,#3a ;..C.....
  db #82,#2c,#e6,#f0,#47,#3a,#83,#2c ;....G...
  db #e6,#f0,#57,#2f,#a0,#1f,#1f,#1f ;..W.....
  db #1f,#47,#cd,#84,#2c,#32,#7e,#2c ;.G......
  db #7a,#a7,#1f,#1f,#1f,#1f,#47,#cd ;z.....G.
  db #84,#2c,#4f,#43,#2a,#80,#2c,#cb ;..OC....
  db #25,#cb,#25,#cb,#25,#11,#04,#00
  db #19,#29,#11,#b7,#2d,#19,#5e,#23
  db #56,#3a,#7f,#2c,#6f,#cb,#27,#85 ;V...o...
  db #c6
lab2C0A:
  db #01,#6f,#26,#00,#19,#d9,#06,#08 ;.o......
  db #c5,#06,#06,#cd,#fc,#2c,#cb,#21
  db #cb,#21,#79,#06,#03,#cb,#21,#d9 ;..y.....
  db #38,#09,#7e,#a1,#5f,#3a,#7e,#2c
  db #b3,#18,#07,#7e,#a0,#5f,#3a,#7d
  db #2c,#b3,#57,#d9,#cb,#21,#d9,#38 ;..W.....
  db #0a,#7e,#87,#a1,#5f,#3a,#7e,#2c
  db #b3,#18,#08,#7e,#87,#a0,#5f,#3a
  db #7d,#2c,#b3,#cb,#3f,#b2,#77,#23 ;......w.
  db #d9,#10,#ca,#d9,#2b,#2b,#2b,#cd
  db #ab,#2c,#d9,#c1,#05,#c2,#12,#2c
  db #d9,#e1,#d9,#21,#7f,#2c,#34,#7e
  db #fe,#1a,#3f,#d0,#36,#00,#21,#80
  db #2c,#34,#7e,#fe,#19,#3f,#d0,#3f
  db #36,#00,#c9,#01,#01,#01,#00,#00
  db #00,#00,#af,#cb,#38,#1f,#cb,#38
  db #30,#02,#f6,#08,#cb,#38,#30,#02
  db #f6,#20,#cb,#38,#d0,#f6,#02,#c9
lab2C9A:
  ld a,d
  cpl
  and #38
  jr z,lab2CA5
  ld a,d
  add a,#8
  ld d,a
  ret
lab2CA5:
  ld hl,#C850
  add hl,de
  ex de,hl
  ret
lab2CAB:
  ld a,h
  cpl
  and #38
  jr z,lab2CB6
  ld a,h
  add a,#8
  ld h,a
  ret
lab2CB6:
  ld de,#C850
  add hl,de
  ret
lab2CBB:
  ld de,data_BACK_BUFFER
  ld hl,data_SCREEN
  ld a,#c8
lab2CC3:
  ex af,af''
  ld bc,lab003D+1
  push hl
  ldir
  pop hl
  call lab2CAB
  ld e,l
  ld d,h
  set 6,d
  ex af,af''
  dec a
  jr nz,lab2CC3
  ret
lab2CD7:
  ld de,data_SCREEN
  ld hl,data_BACK_BUFFER
  ld a,#c8
lab2CDF:
  ex af,af''
  ld bc,lab003D+1
  push de
  ldir
  pop de
  call lab2C9A
  ld l,e
  ld h,d
  set 6,h
  ex af,af''
  dec a
  jr nz,lab2CDF
  ret
lab2CF3:
  cp #61
  ret c
  cp #7b
  ret nc
  sub #20
  ret
data2CFC:
  db #2a,#1d,#2d,#3a,#1f,#2d,#57,#0e ;......W.
  db #00,#7e,#a2,#28,#01,#37,#cb,#11
  db #cb,#3a,#30,#03,#cb,#1a,#23,#10
  db #f0,#22,#1d,#2d,#7a,#32,#1f,#2d ;....z...
  db #c9,#00,#00,#00
lab2D20:
  db #fe,#10,#da,#98,#2b,#fe,#1a,#d2
  db #98,#2b,#d6,#10,#c3,#3f,#2b
lab2D2F:
  ld hl,lab2676
  ld a,#9
  ld (data2D70),a
lab2D37:
  push hl
  ld de,lab3001
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
  call lab3157
  ld hl,lab3001
  pop de
  ldi
  ldi
  ldi
  ldi
  ldi
  ld hl,#0006
  add hl,de
  ld a,(data2D70)
  dec a
  ld (data2D70),a
  jr nz,lab2D37
  ret
data2D70:
  db #00
lab2D71:
  ld hl,(lab2DB1)
  ld a,(hl)
  cp #2
  jp nz,lab2D9E
  inc hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  exx
  ld de,(data2DAF)
  ld hl,(lab2DB1)
  inc hl
  inc hl
  inc hl
lab2D89:
  ld b,(hl)
  inc hl
  bit 7,b
  jp nz,lab2D9F
  ld a,(hl)
  inc hl
lab2D92:
  ld (de),a
  inc de
  djnz lab2D92
lab2D96:
  exx
  dec de
  dec de
  ld a,d
  or e
  exx
  jr nz,lab2D89
lab2D9E:
  ret
lab2D9F:
  res 7,b
  exx
  inc de
  exx
lab2DA4:
  ld a,(hl)
  ld (de),a
  inc de
  inc hl
  exx
  dec de
  exx
  djnz lab2DA4
  jr lab2D96
data2DAF:
  db #00,#c0
lab2DB1:
  db #28,#23,#00,#00,#00,#00
lab2DB7:
  db #00,#80,#00,#88,#00,#90,#00,#98
  db #00,#a0,#00,#a8,#00,#b0,#00,#b8
  db #50,#80,#50,#88,#50,#90,#50,#98 ;P.P.P.P.
  db #50,#a0,#50,#a8,#50,#b0,#50,#b8 ;P.P.P.P.
  db #a0,#80,#a0,#88,#a0,#90,#a0,#98
  db #a0,#a0,#a0,#a8,#a0,#b0,#a0,#b8
  db #f0,#80,#f0,#88,#f0,#90,#f0,#98
  db #f0,#a0,#f0,#a8,#f0,#b0,#f0,#b8
  db #40,#81,#40,#89,#40,#91,#40,#99
  db #40,#a1,#40,#a9,#40,#b1,#40,#b9
  db #90,#81,#90,#89,#90,#91,#90,#99
  db #90,#a1,#90,#a9,#90,#b1,#90,#b9
  db #e0,#81,#e0,#89,#e0,#91,#e0,#99
  db #e0,#a1,#e0,#a9,#e0,#b1,#e0,#b9
  db #30,#82,#30,#8a,#30,#92,#30,#9a
  db #30,#a2,#30,#aa,#30,#b2,#30,#ba
  db #80,#82,#80,#8a,#80,#92,#80,#9a
  db #80,#a2,#80,#aa,#80,#b2,#80,#ba
  db #d0,#82,#d0,#8a,#d0,#92,#d0,#9a
  db #d0,#a2,#d0,#aa,#d0,#b2,#d0,#ba
  db #20,#83,#20,#8b,#20,#93,#20,#9b
  db #20,#a3,#20,#ab,#20,#b3,#20,#bb
  db #70,#83,#70,#8b,#70,#93,#70,#9b ;p.p.p.p.
  db #70,#a3,#70,#ab,#70,#b3,#70,#bb ;p.p.p.p.
  db #c0,#83,#c0,#8b,#c0,#93,#c0,#9b
  db #c0,#a3,#c0,#ab,#c0,#b3,#c0,#bb
  db #10,#84,#10,#8c,#10,#94,#10,#9c
  db #10,#a4,#10,#ac,#10,#b4,#10,#bc
  db #60,#84,#60,#8c,#60,#94,#60,#9c
  db #60,#a4,#60,#ac,#60,#b4,#60,#bc
  db #b0,#84,#b0,#8c,#b0,#94,#b0,#9c
  db #b0,#a4,#b0,#ac,#b0,#b4,#b0,#bc
  db #00,#85,#00,#8d,#00,#95,#00,#9d
  db #00,#a5,#00,#ad,#00,#b5,#00,#bd
  db #50,#85,#50,#8d,#50,#95,#50,#9d ;P.P.P.P.
  db #50,#a5,#50,#ad,#50,#b5,#50,#bd ;P.P.P.P.
  db #a0,#85,#a0,#8d,#a0,#95,#a0,#9d
  db #a0,#a5,#a0,#ad,#a0,#b5,#a0,#bd
  db #f0,#85,#f0,#8d,#f0,#95,#f0,#9d
  db #f0,#a5,#f0,#ad,#f0,#b5,#f0,#bd
  db #40,#86,#40,#8e,#40,#96,#40,#9e
  db #40,#a6,#40,#ae,#40,#b6,#40,#be
  db #90,#86,#90,#8e,#90,#96,#90,#9e
  db #90,#a6,#90,#ae,#90,#b6,#90,#be
  db #e0,#86,#e0,#8e,#e0,#96,#e0,#9e
  db #e0,#a6,#e0,#ae,#e0,#b6,#e0,#be
  db #30,#87,#30,#8f,#30,#97,#30,#9f
  db #30,#a7,#30,#af,#30,#b7,#30,#bf
  db #80,#87,#80,#8f,#80,#97,#80,#9f
  db #80,#a7,#80,#af,#80,#b7,#80,#bf
lab2F47:
  db #01,#20,#20,#20,#20,#20,#20,#20
  db #20,#ff
lab2F51:
  db #00
lab2F52:
  db #00
lab2F53:
  db #00
lab2F54:
  db #00,#03,#14,#02,#ff
lab2F59:
  db #04
lab2F5A:
  db #1c
lab2F5B:
  db #68,#14,#00,#01 ;h...
lab2F5F:
  db #6e,#14,#01,#01 ;n...
lab2F63:
  db #7a,#14,#05,#01 ;z...
lab2F67:
  db #00
lab2F68:
  db #00
lab2F69:
  db #00,#00
lab2F6B:
  db #00
lab2F6C:
  db #00
lab2F6D:
  db #00
lab2F6E:
  db #00
lab2F6F:
  db #00
lab2F70:
  db #00
lab2F71:
  db #9f,#2f
lab2F73:
  db #02,#20,#20,#20,#20,#20,#20,#20
  db #20,#ff,#00,#00,#00,#00,#03,#14
  db #14,#ff,#02,#ac,#68,#14,#12,#01 ;....h...
  db #74,#14,#13,#01,#7a,#14,#17,#01 ;t...z...
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#d0,#2f,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#01,#00,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff
lab3000:
  db #ff
lab3001:
  db #00
lab3002:
  db #00,#00
lab3004:
  db #00,#00
lab3006:
  db #00,#00
lab3008:
  db #00,#00
lab300A:
  db #00,#00
lab300C:
  db #00,#00
lab300E:
  db #08
lab300F:
  db #00,#00,#00,#00
lab3013:
  ld (lab300F),sp
  ld a,(lab3006)
  ld hl,(lab300A)
  ld bc,#0000
  srl a
  rr c
  add hl,bc
  ld sp,hl
  ld c,a
  ld a,(lab3008)
  and #fe
  ld l,a
  ld h,#0
  add hl,hl
  ld de,lab2DB7
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  add hl,bc
  ld e,l
  ld d,h
  set 6,h
  exx
  ld a,(lab300E)
  ld b,a
  ld hl,(lab300C)
  exx
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  inc hl
  inc de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  inc hl
  inc de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  inc hl
  inc de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  ld a,d
  add a,#8
  ld d,a
  or #40
  ld h,a
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  dec hl
  dec de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  dec hl
  dec de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  dec hl
  dec de
  ld a,(hl)
  exx
  ld (hl),a
  dec hl
  pop de
  and e
  or d
  exx
  ld (hl),a
  ld (de),a
  ld ix,data30B0
  jp lab313E
data30B0:
  db #d9,#10,#92,#3a,#08,#30,#32,#04
  db #30,#3a,#06,#30,#32,#02,#30,#ed
  db #7b,#0f,#30,#c9
lab30C4:
  ld (lab300F),sp
  ld a,(lab3008)
  and #fe
  ld l,a
  ld h,#0
  add hl,hl
  ld bc,lab2DB7
  add hl,bc
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  ld a,(lab3006)
  srl a
  ld c,a
  ld b,#0
  add hl,bc
  ld d,h
  ld e,l
  set 6,h
  ld bc,(lab300C)
  exx
  ld a,(lab300E)
  ld b,a
  exx
  ld a,(bc)
  ld (hl),a
  ldi
  ld a,(bc)
  ld (hl),a
  ldi
  ld a,(bc)
  ld (hl),a
  ldi
  ld a,(bc)
  ld (hl),a
  ld (de),a
  dec bc
  ld a,d
  add a,#8
  ld d,a
  or #40
  ld h,a
  ld a,(bc)
  ld (hl),a
  ldd
  ld a,(bc)
  ld (hl),a
  ldd
  ld a,(bc)
  ld (hl),a
  ldd
  ld a,(bc)
  ld (hl),a
  ld (de),a
  dec bc
  ld ix,data311E
  jp lab313E
data311E:
  db #d9,#10,#ce,#3a,#08,#30,#32,#04
  db #30,#3a,#06,#30,#32,#02,#30,#ed
  db #7b,#0f,#30,#c9,#21,#00,#80,#11
  db #00,#c0,#01,#00,#40,#ed,#b0,#c9
lab313E:
  ld a,d
  cpl
  and #38
  jr z,lab314D
  ld a,d
  add a,#8
  ld d,a
  or #40
  ld h,a
  jp (ix)
lab314D:
  ld hl,#C850
  add hl,de
  ld d,h
  ld e,l
  set 6,h
  jp (ix)
lab3157:
  ld a,(lab3001)
  and a
  ret z
  ld (lab300F),sp
  dec a
  jr z,lab3177
  dec a
  jp nz,lab387D
  inc a
  ld (lab3001),a
  ld a,(lab3006)
  ld (lab3002),a
  ld a,(lab3008)
  ld (lab3004),a
lab3177:
  ld a,(lab3002)
  and #fe
  ld b,a
  ld a,(lab3006)
  and #fe
  cp b
  jp z,lab322F
  jp c,lab31DB
  call lab3266
  jp c,lab31B4
  ld hl,lab3909
  add a,a
  add a,a
  add a,l
  ld l,a
  jr nc,lab3199
  inc h
lab3199:
  ld de,lab31B1+1
  ldi
  ldi
  ld de,lab369E
  ldi
  ldi
  ld de,lab3822
  ldi
  ldi
  call lab384E
lab31B1:
  jp #0000
lab31B4:
  neg
  ld hl,lab38E9
  add a,a
  add a,a
  add a,l
  ld l,a
  jr nc,lab31C0
  inc h
lab31C0:
  ld de,lab31D8+1
  ldi
  ldi
  ld de,lab34A9
  ldi
  ldi
  ld de,lab37BE
  ldi
  ldi
  call lab3824
lab31D8:
  jp #0000
lab31DB:
  call lab3266
  jr z,lab31E5
  jp nc,lab320A
  neg
lab31E5:
  ld hl,lab3929
  add a,a
  add a,a
  add a,l
  ld l,a
  jr nc,lab31EF
  inc h
lab31EF:
  ld de,lab3207+1
  ldi
  ldi
  ld de,lab33DE
  ldi
  ldi
  ld de,lab356A
  ldi
  ldi
  call lab3824
lab3207:
  jp #0000
lab320A:
  ld hl,lab3949
  add a,a
  add a,a
  add a,l
  ld l,a
  jr nc,lab3214
  inc h
lab3214:
  ld de,lab322C+1
  ldi
  ldi
  ld de,lab36FD
  ldi
  ldi
  ld de,lab3506
  ldi
  ldi
  call lab384E
lab322C:
  jp #0000
lab322F:
  call lab3266
  jr c,lab324F
  ld hl,lab3752
  ld (lab33DE),hl
  ld hl,data38D9
  add a,l
  ld l,a
  jr nc,lab3242
  inc h
lab3242:
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (lab324C+1),de
  call lab384E
lab324C:
  jp #0000
lab324F:
  neg
  ld hl,lab38E1
  add a,l
  ld l,a
  jr nc,lab3259
  inc h
lab3259:
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (lab33DE),de
  call lab3824
  jp lab32CD
lab3266:
  ld a,(lab3004)
  and #fe
  ld b,a
  ld a,(lab3008)
  and #fe
  sub b
  ret
data3273:
  db #ed,#a0,#ed,#a0,#ed,#a0,#7e,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#ed ;z..W..g.
  db #a8,#ed,#a8,#ed,#a8,#7e,#12,#dd
  db #21,#91,#32,#c3,#3e,#31,#ed,#a0
  db #ed,#a0,#ed,#a0,#7e,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#ed,#a8,#ed ;.W..g...
  db #a8,#ed,#a8,#7e,#12,#dd,#21,#af
  db #32,#c3,#3e,#31,#ed,#a0,#ed,#a0
  db #ed,#a0,#7e,#12,#7a,#c6,#08,#57 ;....z..W
  db #f6,#40,#67,#ed,#a8,#ed,#a8,#ed ;..g.....
  db #a8,#7e,#12,#dd,#21,#cd,#32,#c3
  db #3e,#31
lab32CD:
  exx
  ld b,#5
  exx
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  inc hl
  inc de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  inc hl
  inc de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  inc hl
  inc de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  ld a,d
  add a,#8
  ld d,a
  or #40
  ld h,a
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  dec hl
  dec de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  dec hl
  dec de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  dec hl
  dec de
  pop bc
  ld a,(hl)
  and c
  or b
  ld (de),a
  ld ix,data3313
  jp lab313E
data3313:
  db #d9,#10,#ba,#d9,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #23,#13,#c1,#7e,#a1,#b0,#12,#23
  db #13,#c1,#7e,#a1,#b0,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#c1,#7e,#a1 ;.W..g...
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#2b,#1b,#c1,#7e,#a1,#b0,#12
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#dd
  db #21,#59,#33,#c3,#3e,#31,#c1,#7e ;.Y......
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#23,#13,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#c1 ;z..W..g.
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#2b,#1b,#c1,#7e,#a1
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#dd,#21,#9b,#33,#c3,#3e,#31
  db #c1,#7e,#a1,#b0,#12,#23,#13,#c1
  db #7e,#a1,#b0,#12,#23,#13,#c1,#7e
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#7a,#c6,#08,#57,#f6,#40 ;..z..W..
  db #67,#c1,#7e,#a1,#b0,#12,#2b,#1b ;g.......
  db #c1,#7e,#a1,#b0,#12,#2b,#1b,#c1
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#dd,#21,#dd,#33,#c3
  db #3e,#31,#c3
lab33DE:
  db #00,#00,#c1,#7e,#a1,#b0,#12,#23
  db #13,#c1,#7e,#a1,#b0,#12,#23,#13
  db #c1,#7e,#a1,#b0,#12,#23,#13,#c1
  db #7e,#a1,#b0,#12,#7a,#c6,#08,#57 ;....z..W
  db #f6,#40,#67,#c1,#7e,#a1,#b0,#12 ;..g.....
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#2b
  db #1b,#c1,#7e,#a1,#b0,#12,#2b,#1b
  db #c1,#7e,#a1,#b0,#12,#dd,#21,#22
  db #34,#c3,#3e,#31,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #23,#13,#c1,#7e,#a1,#b0,#12,#23
  db #13,#c1,#7e,#a1,#b0,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#c1,#7e,#a1 ;.W..g...
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#2b,#1b,#c1,#7e,#a1,#b0,#12
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#dd
  db #21,#64,#34,#c3,#3e,#31,#c1,#7e ;.d......
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#23,#13,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#c1 ;z..W..g.
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#2b,#1b,#c1,#7e,#a1
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#dd,#21,#a6,#34,#c3,#3e,#31
  db #1b,#2b,#c3
lab34A9:
  db #00,#00,#d9,#06,#07,#18,#08,#d9
  db #06,#06,#18,#03,#d9,#06,#05,#d9
  db #c1,#7e,#a1,#b0,#12,#23,#13,#c1
  db #7e,#a1,#b0,#12,#23,#13,#c1,#7e
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#23,#13,#7e,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#ed,#a8,#c1 ;.W..g...
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#2b,#1b,#c1,#7e,#a1
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#dd,#21,#01,#35,#c3,#3e,#31
  db #d9,#10,#b4,#d9,#c3
lab3506:
  db #00,#00,#d9,#06,#08,#18,#0d,#d9
  db #06,#07,#18,#08,#d9,#06,#06,#18
  db #03,#d9,#06,#05,#d9,#c1,#7e,#a1
  db #b0,#12,#23,#13,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #23,#13,#c1,#7e,#a1,#b0,#12,#23
  db #13,#7e,#12,#7a,#c6,#08,#57,#f6 ;...z..W.
  db #40,#67,#ed,#a8,#c1,#7e,#a1,#b0 ;.g......
  db #12,#2b,#1b,#c1,#7e,#a1,#b0,#12
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#2b
  db #1b,#c1,#7e,#a1,#b0,#12,#dd,#21
  db #63,#35,#c3,#3e,#31,#d9,#10,#b4 ;c.......
  db #d9,#23,#13,#c3
lab356A:
  db #00,#00,#c1,#7e,#a1,#b0,#12,#23
  db #13,#c1,#7e,#a1,#b0,#12,#23,#13
  db #c1,#7e,#a1,#b0,#12,#23,#13,#c1
  db #7e,#a1,#b0,#12,#7a,#c6,#08,#57 ;....z..W
  db #f6,#40,#67,#c1,#7e,#a1,#b0,#12 ;..g.....
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#2b
  db #1b,#c1,#7e,#a1,#b0,#12,#2b,#1b
  db #c1,#7e,#a1,#b0,#12,#dd,#21,#ae
  db #35,#c3,#3e,#31,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #23,#13,#c1,#7e,#a1,#b0,#12,#23
  db #13,#c1,#7e,#a1,#b0,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#c1,#7e,#a1 ;.W..g...
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#2b,#1b,#c1,#7e,#a1,#b0,#12
  db #2b,#1b,#c1,#7e,#a1,#b0,#12,#dd
  db #21,#f0,#35,#c3,#3e,#31,#c1,#7e
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#23,#13,#c1,#7e,#a1,#b0
  db #12,#23,#13,#c1,#7e,#a1,#b0,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#c1 ;z..W..g.
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#2b,#1b,#c1,#7e,#a1
  db #b0,#12,#2b,#1b,#c1,#7e,#a1,#b0
  db #12,#dd,#21,#32,#36,#c3,#3e,#31
  db #3a,#08,#30,#32,#04,#30,#3a,#06
  db #30,#32,#02,#30,#ed,#7b,#0f,#30
  db #c9,#ed,#a0,#ed,#a0,#ed,#a0,#7e
  db #12,#7a,#c6,#08,#57,#f6,#40,#67 ;.z..W..g
  db #ed,#a8,#ed,#a8,#ed,#a8,#7e,#12
  db #dd,#21,#61,#36,#c3,#3e,#31,#ed ;..a.....
  db #a0,#ed,#a0,#ed,#a0,#7e,#12,#7a ;.......z
  db #c6,#08,#57,#f6,#40,#67,#ed,#a8 ;..W..g..
  db #ed,#a8,#ed,#a8,#7e,#12,#dd,#21
  db #7f,#36,#c3,#3e,#31,#ed,#a0,#ed
  db #a0,#ed,#a0,#7e,#12,#7a,#c6,#08 ;.....z..
  db #57,#f6,#40,#67,#ed,#a8,#ed,#a8 ;W..g....
  db #ed,#a8,#7e,#12,#dd,#21,#9d,#36
  db #c3,#3e,#31,#c3
lab369E:
  db #00,#00,#ed,#a0,#ed,#a0,#ed,#a0
  db #7e,#12,#7a,#c6,#08,#57,#f6,#40 ;..z..W..
  db #67,#ed,#a8,#ed,#a8,#ed,#a8,#7e ;g.......
  db #12,#dd,#21,#be,#36,#c3,#3e,#31
  db #ed,#a0,#ed,#a0,#ed,#a0,#7e,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#ed ;z..W..g.
  db #a8,#ed,#a8,#ed,#a8,#7e,#12,#dd
  db #21,#dc,#36,#c3,#3e,#31,#ed,#a0
  db #ed,#a0,#ed,#a0,#7e,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#ed,#a8,#ed ;.W..g...
  db #a8,#ed,#a8,#7e,#12,#dd,#21,#fa
  db #36,#c3,#3e,#31,#2b,#1b,#c3
lab36FD:
  db #00,#00,#ed,#a0,#ed,#a0,#ed,#a0
  db #7e,#12,#7a,#c6,#08,#57,#f6,#40 ;..z..W..
  db #67,#ed,#a8,#ed,#a8,#ed,#a8,#7e ;g.......
  db #12,#dd,#21,#1d,#37,#c3,#3e,#31
  db #ed,#a0,#ed,#a0,#ed,#a0,#7e,#12
  db #7a,#c6,#08,#57,#f6,#40,#67,#ed ;z..W..g.
  db #a8,#ed,#a8,#ed,#a8,#7e,#12,#dd
  db #21,#3b,#37,#c3,#3e,#31,#ed,#a0
  db #ed,#a0,#ed,#a0,#7e,#12,#7a,#c6 ;......z.
  db #08,#57,#f6,#40,#67,#ed,#a8,#ed ;.W..g...
  db #a8,#ed,#a8,#7e,#12
lab3752:
  db #3a,#08,#30,#32,#04,#30,#3a,#06
  db #30,#32,#02,#30,#ed,#7b,#0f,#30
  db #c9,#d9,#06,#07,#18,#08,#d9,#06
  db #06,#18,#03,#d9,#06,#05,#d9,#ed
  db #a0,#c1,#7e,#a1,#b0,#12,#23,#13
  db #c1,#7e,#a1,#b0,#12,#23,#13,#c1
  db #7e,#a1,#b0,#12,#23,#13,#c1,#7e
  db #a1,#b0,#12,#7a,#c6,#08,#57,#f6 ;...z..W.
  db #40,#67,#c1,#7e,#a1,#b0,#12,#2b ;.g......
  db #1b,#c1,#7e,#a1,#b0,#12,#2b,#1b
  db #c1,#7e,#a1,#b0,#12,#2b,#1b,#c1
  db #7e,#a1,#b0,#12,#2b,#1b,#7e,#12
  db #dd,#21,#b9,#37,#c3,#3e,#31,#d9
  db #10,#b4,#d9,#c3
lab37BE:
  db #00,#00,#d9,#06,#08,#18,#0d,#d9
  db #06,#07,#18,#08,#d9,#06,#06,#18
  db #03,#d9,#06,#05,#d9,#ed,#a0,#c1
  db #7e,#a1,#b0,#12,#23,#13,#c1,#7e
  db #a1,#b0,#12,#23,#13,#c1,#7e,#a1
  db #b0,#12,#23,#13,#c1,#7e,#a1,#b0
  db #12,#7a,#c6,#08,#57,#f6,#40,#67 ;.z..W..g
  db #c1,#7e,#a1,#b0,#12,#2b,#1b,#c1
  db #7e,#a1,#b0,#12,#2b,#1b,#c1,#7e
  db #a1,#b0,#12,#2b,#1b,#c1,#7e,#a1
  db #b0,#12,#2b,#1b,#7e,#12,#dd,#21
  db #1b,#38,#c3,#3e,#31,#d9,#10,#b4
  db #d9,#23,#13,#c3
lab3822:
  db #00,#00
lab3824:
  pop ix
  ld a,(lab3006)
  ld hl,(lab300A)
  ld bc,#0000
  srl a
  rr c
  add hl,bc
  ld sp,hl
  ld c,a
  ld a,(lab3008)
  and #fe
  ld l,a
  ld h,#0
  add hl,hl
  ld de,lab2DB7
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  add hl,bc
  ld e,l
  ld d,h
  set 6,h
  jp (ix)
lab384E:
  pop ix
  ld a,(lab3006)
  ld hl,(lab300A)
  ld bc,#0000
  srl a
  rr c
  add hl,bc
  ld sp,hl
  ld a,(lab3002)
  srl a
  ld c,a
  ld a,(lab3004)
  and #fe
  ld l,a
  ld h,#0
  add hl,hl
  ld de,lab2DB7
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  add hl,bc
  ld d,h
  ld e,l
  set 6,h
  jp (ix)
lab387D:
  ld (lab300F),sp
  ld a,(lab3004)
  and #fe
  ld l,a
  ld h,#0
  add hl,hl
  ld bc,lab2DB7
  add hl,bc
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  ld a,(lab3002)
  srl a
  ld c,a
  ld b,#0
  add hl,bc
  ld d,h
  ld e,l
  set 6,h
  exx
  ld b,#8
lab38A2:
  exx
  ldi
  ldi
  ldi
  ld a,(hl)
  ld (de),a
  ld a,d
  add a,#8
  ld d,a
  or #40
  ld h,a
  ldd
  ldd
  ldd
  ld a,(hl)
  ld (de),a
  ld ix,lab38C1
  call lab313E
lab38C1:
  exx
  djnz lab38A2
  xor a
  ld (lab3001),a
  ld a,(lab3008)
  ld (lab3004),a
  ld a,(lab3006)
  ld (lab3002),a
  ld sp,(lab300F)
  ret
data38D9:
  db #cd,#32,#af,#32,#91,#32,#73,#32 ;......s.
lab38E1:
  db #00,#00,#3b,#37,#1d,#37,#ff,#36
lab38E9:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #64,#34,#63,#37,#3b,#37,#00,#00 ;d.c.....
  db #22,#34,#68,#37,#1d,#37,#00,#00 ;..h.....
  db #e0,#33,#6d,#37,#ff,#36,#00,#00 ;..m.....
lab3909:
  db #c0,#37,#00,#00,#52,#37,#00,#00 ;....R...
  db #7f,#36,#c5,#37,#f0,#35,#00,#00
  db #61,#36,#ca,#37,#ae,#35,#00,#00 ;a.......
  db #43,#36,#cf,#37,#6c,#35,#00,#00 ;C...l...
lab3929:
  db #08,#35,#00,#00,#52,#37,#00,#00 ;....R...
  db #9b,#33,#0d,#35,#3b,#37,#00,#00
  db #59,#33,#12,#35,#1d,#37,#00,#00 ;Y.......
  db #17,#33,#17,#35,#ff,#36,#00,#00
lab3949:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #dc,#36,#ab,#34,#f0,#35,#00,#00
  db #be,#36,#b0,#34,#ae,#35,#00,#00
  db #a0,#36,#b5,#34,#6c,#35,#00,#00 ;....l...
lab3969:
  pop hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  push hl
  ex de,hl
lab3970:
  ld a,(hl)
  exx
  call lab39CE
  exx
  ret c
  inc hl
  jr lab3970
lab397A:
  ld de,data39B1
  ld bc,#0004
  ldir
  ld a,(lab39B4)
  ld c,a
lab3986:
  push bc
  ld a,#3
  call lab39CE
  ld a,(lab39B2)
  call lab39CE
  ld a,(lab39B3)
  call lab39CE
  pop bc
  ld b,#6
lab399B:
  push bc
  ld a,(data39B1)
  call lab39CE
  pop bc
  ld hl,data39B1
  inc (hl)
  djnz lab399B
  ld hl,lab39B3
  inc (hl)
  dec c
  jr nz,lab3986
  ret
data39B1:
  db #ff
lab39B2:
  db #ff
lab39B3:
  db #ff
lab39B4:
  db #ff
lab39B5:
  ld a,(lab2F47)
  dec a
  ret z
  jp lab3AA2
lab39BD:
  ld a,(hl)
  and a
  ret z
  ld (lab4205),a
  push hl
  ld hl,lab4203
  call lab3970
  pop hl
  inc hl
  jr lab39BD
lab39CE:
  ex af,af''
  ld hl,data3A2E
  ld a,(hl)
  and a
  jp nz,lab3A0F
  ex af,af''
  sub #20
  jp c,lab39E4
  cp #df
  scf
  ret z
lab39E1:
  jp #0000
lab39E4:
  add a,#20
  ld bc,#0005
  ld hl,lab4418
  and a
lab39ED:
  cpi
  jr z,lab39F9
  jp po,lab3A21
  inc hl
  inc hl
  inc hl
  jr lab39ED
lab39F9:
  ld a,(hl)
  inc hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  ex de,hl
  and a
  jr z,lab3A20
  ld (data3A2E),a
  ld (lab3A33),hl
  ld hl,lab3A31
  ld (lab3A2F),hl
  ret
lab3A0F:
  ex af,af''
  ld de,(lab3A2F)
  ld (de),a
  inc de
  ld (lab3A2F),de
  and a
  dec (hl)
  ret nz
  ld hl,(lab3A33)
lab3A20:
  jp (hl)
lab3A21:
  ld a,#16
  ld bc,lab7F10
  or #40
  out (c),c
  out (c),a
lab3A2C:
  jr lab3A2C
data3A2E:
  db #00
lab3A2F:
  db #00,#00
lab3A31:
  db #00,#00
lab3A33:
  db #00,#00
lab3A35:
  push bc
  ld (data3A82),hl
  ld a,(hl)
  and #f0
  jr nz,lab3A66
  ld a,(lab3A84)
  call lab39CE
  ld hl,(data3A82)
  ld a,(hl)
  and #f
  jr nz,lab3A75
  pop bc
  push bc
  dec b
  jr z,lab3A75
  ld a,(lab3A84)
  call lab39CE
  pop bc
  ld hl,(data3A82)
  inc hl
  djnz lab3A35
  ret
lab3A5F:
  push bc
  ld (data3A82),hl
  ld a,(hl)
  and #f0
lab3A66:
  rra
  rra
  rra
  rra
  add a,#30
  call lab39CE
  ld hl,(data3A82)
  ld a,(hl)
  and #f
lab3A75:
  add a,#30
  call lab39CE
  pop bc
  ld hl,(data3A82)
  inc hl
  djnz lab3A5F
  ret
data3A82:
  db #00,#00
lab3A84:
  db #00
lab3A85:
  ld hl,lab2F54
  ld a,(hl)
  add a,e
  daa
  ld (hl),a
  dec hl
  ld a,(hl)
  adc a,d
  daa
  ld (hl),a
  dec hl
  ld a,(hl)
  adc a,c
  daa
  ld (hl),a
  dec hl
  ld a,(hl)
  adc a,b
  daa
  ld (hl),a
  ret
lab3A9C:
  call lab3A85
  jp lab3C28
lab3AA2:
  ld hl,lab2F47
  ld de,lab2F73
  ld bc,#002C
lab3AAB:
  ld a,(hl)
  ex af,af''
  ld a,(de)
  ld (hl),a
  ex af,af''
  ld (de),a
  inc hl
  inc de
  dec bc
  ld a,b
  or c
  jr nz,lab3AAB
  ret
data3AB9:
  db #01,#2c,#1a,#0b,#78,#b1,#20,#fb ;....x...
  db #c9
lab3AC2:
  call lab3969
  cp d
  ld b,b
  ld hl,lab6278
  ld (lab2BA1),hl
  ld hl,lab442D
  call lab397A
  ld hl,lab4431
  call lab397A
  ld hl,lab4435
  call lab397A
  ld hl,lab6038
  ld (lab2BA1),hl
  ret
lab3AE6:
  call lab3D63
  call lab3969
  dec a
  ld b,h
  ld hl,lab6278
  ld (lab2BA1),hl
  ld hl,lab4439
  call lab397A
  ld hl,lab6038
  ld (lab2BA1),hl
  ret
data3B01:
  db #3a,#31,#3a,#32,#82,#2c,#a7,#c9
  db #3a,#31,#3a,#32,#83,#2c,#a7,#c9
  db #a7,#c9,#3a,#31,#3a,#32,#7f,#2c
  db #3a,#32,#3a,#32,#80,#2c,#a7,#c9
lab3B21:
  ld hl,lab2DB7
  ld (lab3BFF),hl
  xor a
lab3B28:
  call lab3B3B
  inc a
  cp #32
  jr nz,lab3B28
  ld a,#31
lab3B32:
  call lab3B3B
  dec a
  cp #ff
  jr nz,lab3B32
  ret
lab3B3B:
  call lab3B3E
lab3B3E:
  ld (lab3BFD),a
  inc a
  srl a
  ld (lab3BFE),a
  call lab3B73
  ld a,(lab3BFE)
  add a,a
  neg
  add a,#4f
  ld c,a
  ld b,#0
  push hl
  ld a,(lab3BFD)
  ld e,a
  ld d,#0
  ld hl,lab3BCB
  add hl,de
  ld a,(hl)
  pop hl
  ld d,h
  ld e,l
  inc de
  ld (hl),a
  ldir
  inc hl
  ld a,(lab3BFE)
  call lab3B8B
  ld a,(lab3BFD)
  ret
lab3B73:
  ld hl,(lab3BFF)
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld (lab3BFF),hl
  ex de,hl
  and a
  ret z
  ld b,a
  ld de,data3B99
lab3B84:
  ld a,(de)
  ld (hl),a
  inc hl
  inc de
  djnz lab3B84
  ret
lab3B8B:
  and a
  ret z
  ld de,lab3BCB
  ld b,a
  ld a,e
  sub b
  ld e,a
  jr nc,lab3B84
  dec d
  jr lab3B84
data3B99:
  db #84,#98,#b4,#a9,#87,#84,#98,#b4
  db #a9,#87,#84,#98,#b4,#a9,#87,#84
  db #98,#b4,#a9,#87,#84,#98,#b4,#a9
  db #87,#4b,#56,#78,#64,#48,#4b,#56 ;.KVxdHKV
  db #78,#64,#48,#4b,#56,#78,#64,#48 ;xdHKVxdH
  db #4b,#56,#78,#64,#48,#4b,#56,#78 ;KVxdHKVx
  db #64,#48 ;dH
lab3BCB:
  db #c0,#0c,#cc,#30,#f0,#3c,#fc,#03
  db #c3,#0f,#c0,#0c,#cc,#30,#f0,#3c
  db #fc,#03,#c3,#0f,#c0,#0c,#cc,#30
  db #f0,#3c,#fc,#03,#c3,#0f,#c0,#0c
  db #cc,#30,#f0,#3c,#fc,#03,#c3,#0f
  db #c0,#0c,#cc,#30,#f0,#3c,#fc,#03
  db #c3,#0f
lab3BFD:
  db #ff
lab3BFE:
  db #ff
lab3BFF:
  db #ff,#ff,#21,#00,#c0,#11,#00,#80
  db #01,#d0,#3f,#ed,#b0,#cd,#69,#39 ;......i.
  db #b0,#41,#3a,#2c,#44,#21,#b5,#41 ;.A..D..A
  db #a7,#ca,#70,#39,#21,#cf,#41,#3d ;..p...A.
  db #ca,#70,#39,#21,#e9,#41,#c3,#70 ;.p...A.p
  db #39
lab3C28:
  ld hl,lab2D20
  ld (lab39E1+1),hl
  ld a,#9
  ld (lab3A84),a
  call lab3969
  ld d,l
  cpl
  ld b,#3
  ld hl,lab2F52
  call lab3A35
  ld hl,lab2B98
  ld (lab39E1+1),hl
  ret
lab3C47:
  ld a,(lab2F5A)
  ld (lab3004),a
  ld (lab3008),a
  ld b,#4
lab3C52:
  ld a,b
  and a
  rla
  rla
  rla
  add a,#76
  ld (lab3002),a
  ld a,#3
  ld (lab3001),a
  push bc
  call lab3157
  pop bc
  djnz lab3C52
  ld a,(lab2F59)
  and a
  ret z
  ld hl,lab4E04
  ld (lab300A),hl
  cp #5
  jr c,lab3C79
  ld a,#4
lab3C79:
  ld b,a
lab3C7A:
  ld a,b
  and a
  rla
  rla
  rla
  neg
  add a,#9e
  ld (lab3006),a
  ld a,#2
  ld (lab3001),a
  push bc
  call lab3157
  pop bc
  djnz lab3C7A
  ret
lab3C93:
  ld hl,lab6278
  ld (lab2BA1),hl
  call lab3969
  ld b,a
  ld b,h
  ld b,#2
lab3CA0:
  push bc
  ld hl,lab2F5B
  call lab397A
  ld hl,lab2F5F
  call lab397A
  ld hl,lab2F63
  call lab397A
  call lab3C28
  call lab3C47
  call lab3AA2
  call lab3969
  ld b,d
  ld b,h
  pop bc
  djnz lab3CA0
  ld hl,lab6038
  ld (lab2BA1),hl
  ret
lab3CCB:
  ld hl,lab444C
lab3CCE:
  ld c,#0
lab3CD0:
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld a,e
  or d
  inc hl
  ld a,(hl)
  inc hl
  jr z,lab3CE2
  ld (hl),a
  push hl
  ld l,a
  ld h,#0
  add hl,de
  ld a,(hl)
  pop hl
lab3CE2:
  or #40
  ld b,#7f
  out (c),c
  out (c),a
  inc hl
  inc c
  ld a,c
  cp #10
  jr nz,lab3CD0
  ret
lab3CF2:
  ld hl,lab444C
lab3CF5:
  ld c,#0
lab3CF7:
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld a,d
  or d
  inc hl
  jr z,lab3D18
  inc (hl)
  ld a,(hl)
  push hl
  ld l,a
  ld h,#0
  add hl,de
  ld a,(hl)
  pop hl
  cp #ff
  jr nz,lab3D10
  ld (hl),#0
  ld a,(de)
lab3D10:
  or #40
  ld b,#7f
  out (c),c
  out (c),a
lab3D18:
  inc hl
  inc c
  ld a,c
  cp #10
  jr nz,lab3CF7
  ret
lab3D20:
  call lab2990
  and a
  ret z
  call lab2CF3
  cp #31
  jp z,lab3DF7
  cp #32
  jp z,lab3DF7
  ld b,#0
  cp #4b
  jr z,lab3D42
  inc b
  cp #54
  jr z,lab3D42
  inc b
  cp #4a
  jr nz,lab3D48
lab3D42:
  ld a,b
  ld (lab442C),a
  scf
  ret
lab3D48:
  and a
  ret
lab3D4A:
  ld hl,data_SCREEN
  ld b,#c8
lab3D4F:
  push bc
  push hl
  ld (hl),#0
  ld d,h
  ld e,l
  inc de
  ld bc,lab003D
  ldir
  pop hl
  call lab2CAB
  pop bc
  djnz lab3D4F
  ret
lab3D63:
  ld hl,#803E
  call lab3D6C
lab3D69:
  ld hl,#C03E
lab3D6C:
  ld b,#c8
lab3D6E:
  push bc
  push hl
  ld (hl),#33
  ld d,h
  ld e,l
  inc de
  ld bc,#0011
  ldir
  pop hl
  call lab2CAB
  pop bc
  djnz lab3D6E
  ret
lab3D82:
  sub #14
  ret c
  push af
  add a,#30
  ld (lab4352),a
  pop af
  ld bc,#0001
  jr z,lab3D9D
  ld c,#2
  dec a
  jr z,lab3D9D
  ld c,#3
  dec a
  jr z,lab3D9D
  ld c,#5
lab3D9D:
  ld a,c
  add a,#30
  ld (lab4373),a
  ld de,#0000
  call lab3A85
  call lab2971
  ld a,#14
  ld (lab44C8),a
  call lab3CCB
  call lab3B21
  ld hl,lab2B98
  ld (lab39E1+1),hl
  ld hl,lab44F4
  call lab39BD
  call lab3969
  ld l,#43
  call lab3AC2
  ld b,#46
lab3DCD:
  exx
  ld bc,lab1A2B+1
lab3DD1:
  dec bc
  ld a,b
  or c
  jr nz,lab3DD1
  call lab3CF2
  exx
  ld a,b
  cp #3d
  jr nz,lab3DE4
  ld a,#ff
  ld (lab44C8),a
lab3DE4:
  ld a,b
  cp #b
  jr nz,lab3DEE
  ld a,#14
  ld (lab44C8),a
lab3DEE:
  djnz lab3DCD
  call lab3AE6
  call lab3C93
  ret
lab3DF7:
  pop hl
  sub #30
  ld (lab4404),a
  ld a,#2
  ld (lab2C0A),a
  call lab0085
  ld a,#1
  ld (lab2C0A),a
lab3E0A:
  call lab3D20
  call lab2971
  ld hl,lab2B98
  ld (lab39E1+1),hl
  call lab3B21
  call lab3969
  sbc a,h
  ld b,b
  call lab3AC2
  call lab3969
  ex (sp),hl
  ld b,b
  call lab3969
  or l
  ld b,c
  call lab3969
  rst 8
  db #41,#cd,#69,#39,#e9,#41,#21,#e3 ;A.i..A..
  db #44,#cd,#bd,#39,#cd,#e4,#26,#cd ;D.......
  db #b5,#39,#06,#02,#c5,#0e,#0a,#21
  db #87,#43,#e5,#06,#04,#11,#51,#2f ;.C....Q.
  db #1a,#be,#ca,#7c,#3f,#da,#82,#3f
  db #c5,#3e,#14,#32,#c8,#44,#cd,#cb ;.....D..
  db #3c,#cd,#21,#3b,#21,#e7,#44,#cd ;......D.
  db #bd,#39,#3a,#47,#2f,#c6,#30,#32 ;...G....
  db #55,#42,#cd,#69,#39,#3b,#42,#cd ;UB.i..B.
  db #c2,#3a,#cd,#69,#39,#59,#42,#3e ;...i.YB.
  db #20,#32,#84,#3a,#21,#51,#2f,#06 ;.....Q..
  db #04,#cd,#35,#3a,#cd,#69,#39,#79 ;.....i.y
  db #42,#af,#32,#17,#44,#32,#16,#44 ;B...D..D
  db #cd,#f9,#3e,#06,#be,#c5,#cd,#b9
  db #3a,#cd,#f2,#3c,#cd,#90,#29,#a7
  db #ca,#2d,#3f,#fe,#0d,#ca,#47,#3f ;......G.
  db #08,#3a,#17,#44,#a7,#20,#11,#3c ;...D....
  db #32,#17,#44,#21,#48,#2f,#11,#49 ;..D.H..I
  db #2f,#01,#07,#00,#36,#20,#ed,#b0
  db #08,#cb,#7f,#20,#61,#fe,#09,#28 ;....a...
  db #10,#fe,#08,#28,#4c,#fe,#7f,#28 ;....L...
  db #43,#fe,#20,#38,#51,#47,#cd,#ed ;C...QG..
  db #3e,#3a,#16,#44,#fe,#07,#28,#43 ;...D...C
  db #3c,#32,#16,#44,#18,#3d,#3a,#16 ;...D....
  db #44,#5f,#16,#00,#21,#48,#2f,#19 ;D....H..
  db #70,#c9,#cd,#69,#39,#d6,#42,#cd ;p..i..B.
  db #69,#39,#48,#2f,#cd,#69,#39,#e1 ;i.H..i..
  db #42,#3e,#03,#cd,#ce,#39,#3a,#16 ;B.......
  db #44,#c6,#09,#cd,#ce,#39,#cd,#69 ;D......i
  db #39,#dc,#42,#c9,#06,#20,#cd,#ed ;..B.....
  db #3e,#3a,#16,#44,#3d,#fa,#2a,#3f ;...D....
  db #32,#16,#44,#cd,#f9,#3e,#c1,#78 ;..D....x
  db #fe,#b5,#20,#05,#3e,#ff,#32,#c8
  db #44,#78,#fe,#0b,#20,#05,#3e,#14 ;Dx......
  db #32,#c8,#44,#05,#c2,#9c,#3e,#c5 ;..D.....
  db #c1,#cd,#69,#39,#e1,#42,#c1,#3e ;..i..B..
  db #0b,#91,#32,#03,#44,#0d,#28,#14 ;....D...
  db #af,#47,#79,#cb,#21,#cb,#21,#81 ;.Gy.....
  db #cb,#21,#81,#4f,#21,#f2,#43,#11 ;...O..C.
  db #ff,#43,#ed,#b8,#e1,#11,#f7,#ff ;.C......
  db #19,#eb,#21,#48,#2f,#01,#0d,#00 ;...H....
  db #ed,#b0,#c3,#8b,#3f,#23,#13,#05
  db #c2,#4f,#3e,#e1,#11,#0d,#00,#19 ;.O......
  db #0d,#c2,#49,#3e,#cd,#a2,#3a,#c1 ;..I.....
  db #05,#c2,#43,#3e,#3a,#03,#44,#a7 ;..C...D.
  db #c2,#d6,#3f,#cd,#71,#29,#cd,#01 ;....q...
  db #3c,#3e,#14,#32,#c8,#44,#cd,#cb ;.....D..
  db #3c,#06,#be,#d9,#cd,#b9,#3a,#cd
  db #f2,#3c,#cd,#20,#3d,#30,#07,#c5
  db #cd,#01,#3c,#c1,#18,#02,#20,#17
  db #d9,#78,#fe,#b5,#20,#05,#3e,#ff ;.x......
  db #32,#c8,#44,#78,#fe,#0b,#20,#05 ;..Dx....
  db #3e,#14,#32,#c8,#44,#10,#d4,#3e ;....D...
  db #14,#32,#c8,#44,#cd,#71,#29,#cd ;...D.q..
  db #21,#3b,#cd,#69,#39,#9c,#40,#cd ;...i....
  db #c2,#3a,#cd,#69,#39,#1d,#42,#21 ;...i..B.
  db #f0,#44,#cd,#bd,#39,#21,#7e,#43 ;.D.....C
  db #22,#01,#44,#21,#00,#44,#36,#01 ;..D..D..
  db #3e,#02,#cd,#ce,#39,#3a,#00,#44 ;.......D
  db #fe,#10,#20,#02,#3e,#0a,#21,#03
  db #44,#be,#3e,#0f,#20,#01,#af,#cd ;D.......
  db #ce,#39,#3e,#03,#cd,#ce,#39,#3e
  db #02,#cd,#ce,#39,#3a,#00,#44,#fe ;......D.
  db #10,#20,#02,#3e,#0a,#c6,#0a,#cd
  db #ce,#39,#3e,#20,#cd,#ce,#39,#21
  db #00,#44,#06,#01,#3e,#20,#32,#84 ;.D......
  db #3a,#cd,#35,#3a,#cd,#69,#39,#7b ;.....i..
  db #43,#2a,#01,#44,#cd,#70,#39,#23 ;C..D.p..
  db #06,#04,#cd,#35,#3a,#22,#01,#44 ;.......D
  db #3e,#20,#cd,#ce,#39,#21,#00,#44 ;.......D
  db #7e,#c6,#01,#27,#77,#fe,#11,#20 ;....w...
  db #97,#af,#32,#03,#44,#cd,#cb,#3c ;....D...
  db #06,#be,#d9,#cd,#b9,#3a,#cd,#f2
  db #3c,#cd,#20,#3d,#da,#9a,#3f,#c2
  db #9a,#3f,#d9,#78,#fe,#b5,#20,#05 ;...x....
  db #3e,#ff,#32,#c8,#44,#78,#fe,#0b ;....Dx..
  db #20,#05,#3e,#14,#32,#c8,#44,#10 ;......D.
  db #d9,#c3,#9a,#3f,#c9,#01,#00,#02
  db #0f,#03,#02,#03,#45,#6c,#69,#74 ;....Elit
  db #65,#20,#53,#79,#73,#74,#65,#6d ;e.System
  db #73,#20,#50,#72,#65,#73,#65,#6e ;s.Presen
  db #74,#73,#ff,#03,#02,#04,#20,#20 ;ts......
  db #03,#16,#04,#20,#20,#03,#02,#05
  db #20,#20,#03,#16,#05,#20,#20,#03
  db #02,#06,#20,#20,#03,#16,#06,#20
  db #20,#03,#02,#07,#20,#20,#03,#16
  db #07,#20,#20,#ff,#01,#00,#02,#0f
  db #03,#02,#08,#20,#4c,#69,#63,#65 ;....Lice
  db #6e,#73,#65,#64,#20,#46,#72,#6f ;nsed.Fro
  db #6d,#20,#54,#65,#68,#6b,#61,#6e ;m.Tehkan
  db #20,#03,#02,#09,#20,#20,#20,#20
  db #43,#6f,#70,#79,#72,#69,#67,#68 ;Copyrigh
  db #74,#20,#31,#39,#38,#35,#20,#20 ;t.......
  db #20,#20,#03,#02,#0a,#20,#20,#41 ;.......A
  db #6c,#6c,#20,#52,#69,#67,#68,#74 ;ll.Right
  db #73,#20,#52,#65,#73,#65,#72,#76 ;s.Reserv
  db #65,#64,#20,#03,#02,#0c,#20,#50 ;ed.....P
  db #52,#45,#53,#53,#3a,#20,#20,#20 ;RESS....
  db #20,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#03,#02,#0d,#20
  db #31,#20,#2d,#20,#4f,#6e,#65,#20 ;....One.
  db #50,#6c,#61,#79,#65,#72,#20,#53 ;Player.S
  db #74,#61,#72,#74,#20,#03,#02,#0e ;tart....
  db #20,#32,#20,#2d,#20,#54,#77,#6f ;.....Two
  db #20,#50,#6c,#61,#79,#65,#72,#20 ;.Player.
  db #53,#74,#61,#72,#74,#20,#03,#02 ;Start...
  db #0f,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#20,#20,#20,#03
  db #02,#10,#20,#53,#45,#4c,#45,#43 ;...SELEC
  db #54,#20,#4f,#50,#54,#49,#4f,#4e ;T.OPTION
  db #3a,#20,#20,#20,#20,#20,#20,#20
  db #ff,#01,#0f,#02,#00,#ff,#03,#02
  db #11,#20,#20,#4b,#20,#2d,#20,#4b ;...K...K
  db #65,#79,#62,#6f,#61,#72,#64,#20 ;eyboard.
  db #20,#20,#20,#20,#20,#20,#20,#ff
  db #03,#02,#12,#20,#20,#54,#20,#2d ;.....T..
  db #20,#4b,#65,#79,#62,#6f,#61,#72 ;.Keyboar
  db #64,#28,#54,#75,#72,#62,#6f,#29 ;d.Turbo.
  db #20,#ff,#03,#02,#13,#20,#20,#4a ;.......J
  db #20,#2d,#20,#4a,#6f,#79,#73,#74 ;...Joyst
  db #69,#63,#6b,#20,#20,#20,#20,#20 ;ick.....
  db #20,#20,#20,#ff
lab4203:
  db #03,#02
lab4205:
  db #00,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#20,#20,#20,#ff
  db #01,#0e,#02,#0f,#03,#02,#09,#20
  db #20,#20,#20,#20,#42,#45,#53,#54 ;....BEST
  db #20,#42,#4f,#4d,#42,#45,#52,#53 ;.BOMBERS
  db #20,#20,#20,#20,#20,#ff,#01,#0f
  db #02,#0f,#03,#02,#09,#20,#20,#57 ;.......W
  db #45,#4c,#4c,#20,#44,#4f,#4e,#45 ;ELL.DONE
  db #20,#50,#4c,#41,#59,#45,#52,#20 ;.PLAYER.
  db #00,#20,#20,#ff,#03,#02,#0b,#20
  db #59,#6f,#75,#72,#20,#67,#72,#65 ;Your.gre
  db #61,#74,#20,#73,#63,#6f,#72,#65 ;at.score
  db #20,#6f,#66,#20,#20,#03,#02,#0c ;.of.....
  db #02,#00,#20,#ff,#02,#0f,#20,#6d ;.......m
  db #65,#61,#6e,#73,#20,#79,#6f,#75 ;eans.you
  db #20,#20,#20,#03,#02,#0d,#20,#61 ;.......a
  db #72,#65,#20,#69,#6e,#20,#77,#69 ;re.in.wi
  db #74,#68,#20,#74,#68,#65,#20,#42 ;th.the.B
  db #65,#73,#74,#20,#03,#02,#0e,#20 ;est.....
  db #42,#6f,#6d,#62,#65,#72,#73,#2e ;Bombers.
  db #20,#20,#20,#20,#20,#20,#20,#20
  db #20,#20,#20,#20,#20,#03,#02,#10
  db #20,#20,#20,#45,#6e,#74,#65,#72 ;...Enter
  db #20,#79,#6f,#75,#72,#20,#6e,#61 ;.your.na
  db #6d,#65,#20,#20,#20,#20,#02,#00 ;me......
  db #ff,#03,#09,#12,#01,#0f,#ff,#13
  db #01,#0e,#5e,#ff,#03,#09,#13,#20
  db #20,#20,#20,#20,#20,#20,#20,#ff
  db #01,#0e,#02,#f0,#03,#06,#0a,#50 ;.......P
  db #4c,#41,#59,#45,#52,#20 ;LAYER.
lab42FB:
  db #00,#03,#07,#0b,#53,#54,#41,#52 ;....STAR
  db #54,#21,#02,#00,#ff,#01,#0e,#02 ;T.......
  db #f0,#03,#06,#0a,#50,#4c,#41,#59 ;....PLAY
  db #45,#52,#20 ;ER.
lab4316:
  db #00,#02,#00,#ff,#01,#0e,#02,#f0
  db #03,#05,#0b,#47,#41,#4d,#45,#20 ;...GAME.
  db #4f,#56,#45,#52,#21,#02,#00,#ff ;OVER....
  db #03,#02,#0b,#01,#0f,#02,#0f,#20
  db #57,#65,#6c,#6c,#20,#64,#6f,#6e ;Well.don
  db #65,#20,#21,#20,#59,#6f,#75,#20 ;e...You.
  db #67,#6f,#74,#20,#20,#03,#02,#0c ;got.....
  db #02,#00,#20,#32
lab4352:
  db #00,#02,#0f,#20,#73,#70,#61,#72 ;....spar
  db #6b,#69,#6e,#67,#20,#62,#6f,#6d ;king.bom
  db #62,#73,#2e,#20,#20,#20,#03,#08 ;bs......
  db #0e,#02,#00,#42,#4f,#4e,#55,#53 ;...BONUS
  db #20
lab4373:
  db #00,#30,#30,#30,#30,#02,#0f,#ff
  db #29,#20,#ff,#41,#4e,#44,#59,#20 ;...ANDY.
  db #57,#20,#20,#ff,#00,#08,#21,#60 ;W.......
  db #54,#45,#5a,#20,#20,#20,#20,#20 ;TEZ.....
  db #ff,#00,#07,#20,#00,#50,#41,#55 ;.....PAU
  db #4c,#20,#20,#20,#20,#ff,#00,#05 ;L.......
  db #94,#01,#48,#45,#4c,#45,#4e,#20 ;..HELEN.
  db #20,#20,#ff,#00,#05,#94,#00,#4d ;.......M
  db #41,#4e,#44,#59,#20,#20,#20,#ff ;ANDY....
  db #00,#03,#22,#50,#4b,#41,#52,#45 ;...PKARE
  db #4e,#20,#20,#20,#ff,#00,#02,#85 ;N.......
  db #20,#57,#45,#4e,#44,#59,#20,#20 ;.WENDY..
  db #20,#ff,#00,#02,#22,#00,#54,#4f ;......TO
  db #4d,#20,#20,#20,#20,#20,#ff,#00 ;M.......
  db #01,#59,#80,#44,#49,#43,#4b,#20 ;.Y.DICK.
  db #20,#20,#20,#ff,#00,#01,#14,#10
  db #48,#41,#52,#52,#59,#20,#20,#20 ;HARRY...
  db #ff,#00,#00,#90,#50,#ff,#ff,#ff ;....P...
  db #00
lab4404:
  db #01,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
  db #ff,#ff,#ff,#ff
lab4418:
  db #02,#01,#09,#3b,#00,#00,#11,#3b
  db #01,#01,#01,#3b,#03,#02,#13,#3b
  db #09,#00,#65,#2c ;..e.
lab442C:
  db #00
lab442D:
  db #20,#04,#04,#04
lab4431:
  db #38,#0a,#04,#04
lab4435:
  db #50,#10,#04,#04 ;P...
lab4439:
  db #20,#14,#06,#0c,#02,#00,#01,#ca
  db #ff,#02,#00,#01,#cb,#ff,#02,#00
  db #01,#ce,#ff
lab444C:
  db #00,#00,#14,#00,#8c,#44,#3c,#00 ;.....D..
  db #8c,#44,#3d,#00,#8c,#44,#3e,#00 ;.D...D..
  db #8c,#44,#3f,#00,#8c,#44,#40,#00 ;.D...D..
  db #8c,#44,#41,#00,#8c,#44,#42,#00 ;.DA..DB.
  db #8c,#44,#43,#00,#8c,#44,#44,#00 ;.DC..DD.
  db #8c,#44,#45,#00,#00,#00,#0c,#00 ;.DE.....
  db #00,#00,#14,#00,#00,#00,#00,#00
  db #d3,#44,#00,#00,#dc,#44,#00,#00 ;.D...D..
  db #0c,#0c,#0c,#0c,#0e,#0e,#0e,#0e
  db #0a,#0a,#0a,#0a,#03,#03,#03,#03
  db #0b,#0b,#0b,#0b,#02,#02,#02,#02
  db #1a,#1a,#1a,#1a,#13,#13,#13,#13
  db #06,#06,#06,#06,#15,#15,#15,#15
  db #04,#04,#04,#04,#18,#18,#18,#18
  db #0f,#0f,#0f,#0f,#0d,#0d,#0d,#0d
  db #05,#05,#05,#05
lab44C8:
  db #14,#14,#14,#14,#14,#14,#14,#14
  db #14,#14,#ff,#14,#14,#14,#14,#0b
  db #0b,#0b,#0b,#ff,#0c,#0c,#0d,#0d
  db #15,#15,#ff,#03,#0b,#14,#00,#03
  db #08,#0a,#0f,#11,#12,#13,#14,#00
  db #03,#08,#0a,#00
lab44F4:
  db #03,#08,#09,#0a,#0d,#0e,#0f,#10
  db #11,#12,#13,#14,#00,#23,#12,#13
  db #10,#fc,#d9,#1b,#1b,#7a,#b3,#d9 ;.....z..
  db #20,#eb,#c9,#cb,#b8,#d9,#13,#d9
  db #7e,#12,#13,#23,#d9,#1b,#d9,#10
  db #f7,#18,#e7,#00,#c0,#28,#23,#00
  db #00,#00,#00,#00,#80,#00,#88,#00
  db #90,#00,#98,#00,#a0,#00,#a8,#00
  db #b0,#00,#b8,#50,#80,#50,#88,#50 ;...P.P.P
  db #90,#50,#98,#50,#a0,#50,#a8,#50 ;.P.P.P.P
  db #b0,#50,#b8,#a0,#80,#a0,#88,#a0 ;.P......
  db #90,#a0,#98,#a0,#a0,#a0,#a8,#a0
  db #b0,#a0,#b8,#f0,#80,#f0,#88,#f0
  db #90,#f0,#98,#f0,#a0,#f0,#a8,#f0
  db #b0,#f0,#b8,#40,#81,#40,#89,#40
  db #91,#40,#99,#40,#a1,#40,#a9,#40
  db #b1,#40,#b9,#90,#81,#90,#89,#90
  db #91,#90,#99,#90,#a1,#90,#a9,#90
lab4584:
  db #ff,#00,#aa,#11,#ff,#00,#ff,#00
  db #ff,#00,#55,#22,#55,#22,#ff,#00 ;..U.U...
  db #ff,#00,#ff,#00,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#cb,#00,#cf,#ff,#00
  db #55,#8a,#00,#cf,#00,#c7,#aa,#45 ;U......E
  db #aa,#45,#00,#c7,#00,#cf,#55,#8a ;.E....U.
  db #55,#8a,#00,#cf,#00,#c7,#aa,#45 ;U......E
  db #aa,#45,#00,#cf,#00,#cf,#55,#8a ;.E....U.
  db #55,#8a,#00,#cf,#00,#c7,#aa,#45 ;U......E
  db #ff,#00,#00,#cb,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#8f,#00,#cf,#ff,#00
  db #55,#8a,#00,#8f,#00,#4f,#ff,#00 ;U....O..
  db #ff,#00,#aa,#45,#00,#07,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
lab4684:
  db #aa,#05,#aa,#45,#55,#8a,#55,#0a ;...EU.U.
  db #ff,#00,#00,#8f,#55,#0a,#ff,#00 ;....U...
  db #ff,#00,#00,#8f,#00,#4f,#55,#0a ;.....OU.
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #aa,#11,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#c3,#00,#63 ;.......c
  db #00,#d3,#00,#f7,#00,#f7,#ff,#00
  db #ff,#00,#00,#f7,#00,#ff,#00,#d3
  db #00,#d3,#00,#ff,#00,#f7,#ff,#00
  db #ff,#00,#00,#f7,#00,#ff,#00,#73 ;.......s
  db #aa,#11,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#c3,#00,#63 ;.......c
  db #00,#93,#00,#73,#00,#f3,#ff,#00 ;...s....
  db #ff,#00,#00,#b3,#00,#93,#00,#e3
  db #00,#73,#00,#b3,#00,#b3,#ff,#00 ;.s......
  db #ff,#00,#55,#a2,#00,#73,#aa,#11 ;..U..s..
  db #aa,#41,#00,#e3,#55,#a2,#ff,#00 ;.A..U...
  db #ff,#00,#55,#a2,#00,#e3,#aa,#41 ;..U....A
  db #aa,#41,#00,#63,#55,#22,#ff,#00 ;.A.cU...
  db #ff,#00,#55,#22,#00,#33,#aa,#11 ;..U.....
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #55,#22,#00,#c3,#00,#c3,#aa,#11 ;U.......
  db #aa,#41,#00,#f3,#00,#fb,#55,#aa ;.A....U.
  db #55,#aa,#00,#fb,#00,#f7,#aa,#41 ;U......A
  db #aa,#41,#00,#f7,#00,#fb,#55,#aa ;.A....U.
  db #55,#aa,#00,#fb,#00,#f7,#aa,#11 ;U.......
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #55,#22,#00,#c3,#00,#c3,#aa,#11 ;U.......
  db #aa,#41,#00,#33,#00,#f3,#55,#a2 ;.A....U.
  db #55,#22,#00,#73,#00,#c3,#aa,#51 ;U..s...Q
  db #aa,#11,#00,#f3,#00,#73,#55,#22 ;.....sU.
  db #ff,#00,#00,#f3,#00,#33,#ff,#00
  db #aa,#41,#00,#f3,#00,#f3,#ff,#00 ;.A......
  db #55,#a2,#00,#d3,#55,#a2,#aa,#11 ;U...U...
  db #aa,#11,#55,#a2,#00,#d3,#55,#22 ;..U...U.
  db #ff,#00,#aa,#11,#55,#22,#aa,#11 ;....U...
  db #aa,#11,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#c3,#00,#63 ;.......c
  db #00,#fb,#00,#fb,#00,#f3,#ff,#00
  db #ff,#00,#00,#f3,#00,#ff,#00,#fb
  db #00,#fb,#00,#ff,#00,#f3,#ff,#00
  db #ff,#00,#00,#b3,#00,#ff,#00,#fb
  db #aa,#11,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#c3,#00,#63 ;.......c
  db #00,#d3,#00,#b3,#00,#63,#ff,#00 ;.....c..
  db #ff,#00,#00,#d3,#00,#63,#00,#63 ;.....c.c
  db #00,#63,#00,#73,#00,#b3,#ff,#00 ;.c.s....
  db #ff,#00,#55,#22,#00,#b3,#aa,#51 ;..U....Q
  db #aa,#41,#00,#e3,#55,#a2,#ff,#00 ;.A..U...
  db #ff,#00,#55,#a2,#00,#e3,#aa,#41 ;..U....A
  db #aa,#11,#00,#b3,#55,#a2,#ff,#00 ;....U...
  db #ff,#00,#55,#22,#00,#33,#aa,#11 ;..U.....
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #55,#a2,#00,#c3,#00,#c3,#aa,#11 ;U.......
  db #aa,#55,#00,#f7,#00,#f3,#55,#a2 ;.U....U.
  db #55,#a2,#00,#fb,#00,#f7,#aa,#55 ;U......U
  db #aa,#55,#00,#f7,#00,#fb,#55,#a2 ;.U....U.
  db #55,#22,#00,#fb,#00,#f7,#aa,#55 ;U......U
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #55,#22,#00,#c3,#00,#c3,#aa,#11 ;U.......
  db #aa,#41,#00,#f3,#00,#33,#55,#82 ;.A....U.
  db #55,#a2,#00,#c3,#00,#93,#aa,#11 ;U.......
  db #aa,#11,#00,#93,#00,#f3,#55,#22 ;......U.
  db #ff,#00,#00,#33,#00,#f3,#ff,#00
  db #ff,#00,#00,#d3,#aa,#41,#55,#a2 ;.....AU.
  db #55,#22,#aa,#41,#00,#f3,#aa,#41 ;U..A...A
  db #aa,#11,#00,#f3,#aa,#51,#55,#22 ;.....QU.
  db #55,#22,#aa,#11,#55,#22,#ff,#00 ;U...U...
lab4904:
  db #aa,#11,#ff,#00,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#55,#22,#00,#33,#aa,#11 ;..U.....
  db #aa,#45,#00,#cf,#55,#22,#ff,#00 ;.E..U...
  db #ff,#00,#55,#22,#00,#c7,#aa,#41 ;..U....A
  db #aa,#11,#00,#33,#ff,#00,#ff,#00
  db #ff,#00,#55,#82,#00,#e3,#aa,#51 ;..U....Q
  db #aa,#45,#00,#db,#00,#c3,#ff,#00 ;.E......
  db #ff,#00,#00,#e3,#00,#cf,#aa,#45 ;.......E
  db #aa,#45,#00,#cf,#00,#e3,#ff,#00 ;.E......
  db #ff,#00,#00,#63,#00,#9b,#aa,#45 ;...c...E
  db #aa,#05,#00,#1b,#00,#63,#55,#82 ;.....cU.
  db #55,#82,#00,#cb,#00,#cf,#aa,#45 ;U......E
  db #aa,#45,#00,#cf,#00,#cb,#55,#82 ;.E....U.
  db #55,#82,#00,#cb,#00,#cf,#aa,#11 ;U.......
  db #aa,#11,#00,#33,#00,#63,#55,#82 ;.....cU.
  db #ff,#00,#00,#63,#00,#33,#ff,#00 ;...c....
  db #ff,#00,#55,#22,#aa,#11,#ff,#00 ;..U.....
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#00,#cf,#00,#9b,#ff,#00
  db #ff,#00,#00,#9b,#00,#c3,#ff,#00
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#c3,#00,#f3,#ff,#00
  db #ff,#00,#00,#cf,#00,#e3,#55,#82 ;......U.
  db #55,#82,#00,#db,#00,#cf,#ff,#00 ;U.......
  db #aa,#11,#00,#cf,#00,#db,#55,#82 ;......U.
  db #55,#82,#00,#67,#00,#9b,#aa,#11 ;U..g....
  db #ff,#00,#00,#1b,#00,#27,#00,#c3
  db #00,#c3,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#00,#c3
  db #00,#c3,#00,#cf,#00,#33,#ff,#00
  db #aa,#11,#55,#22,#00,#33,#00,#c3 ;..U.....
  db #55,#82,#00,#93,#55,#22,#aa,#11 ;U...U...
lab4A04:
  db #ff,#00,#55,#22,#aa,#11,#ff,#00 ;..U.....
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#00,#67,#00,#cf,#ff,#00 ;...g....
  db #ff,#00,#00,#c3,#00,#67,#ff,#00 ;.....g..
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #ff,#00,#00,#f3,#00,#c3,#ff,#00
  db #aa,#41,#00,#d3,#00,#cf,#ff,#00 ;.A......
  db #ff,#00,#00,#cf,#00,#e7,#aa,#41 ;.......A
  db #aa,#41,#00,#e7,#00,#cf,#ff,#00 ;.A......
  db #ff,#00,#00,#cf,#00,#33,#aa,#41 ;.......A
  db #00,#c3,#00,#33,#00,#0f,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#00,#c3
  db #00,#c3,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#9b,#00,#cf,#00,#c3
  db #00,#c3,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#55,#22,#00,#33,#aa,#41 ;..U....A
  db #ff,#00,#aa,#11,#ff,#00,#55,#22 ;......U.
  db #55,#22,#00,#33,#aa,#11,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#00,#cf,#55,#8a ;......U.
  db #55,#82,#00,#cb,#aa,#11,#ff,#00 ;U.......
  db #ff,#00,#ff,#00,#00,#33,#55,#22 ;......U.
  db #55,#a2,#00,#d3,#aa,#41,#ff,#00 ;U....A..
  db #ff,#00,#00,#c3,#00,#e7,#55,#8a ;......U.
  db #55,#8a,#00,#cf,#00,#d3,#ff,#00 ;U.......
  db #ff,#00,#00,#d3,#00,#cf,#00,#9b
  db #00,#9b,#00,#33,#00,#c7,#ff,#00
  db #aa,#41,#00,#87,#00,#33,#55,#0a ;.A....U.
  db #55,#8a,#00,#cf,#00,#c7,#aa,#41 ;U......A
  db #aa,#41,#00,#c7,#00,#cf,#55,#8a ;.A....U.
  db #55,#22,#00,#9b,#00,#c7,#aa,#41 ;U......A
  db #aa,#41,#00,#93,#55,#22,#00,#33 ;.A..U...
  db #00,#33,#55,#82,#00,#93,#ff,#00 ;..U.....
lab4B04:
  db #aa,#11,#ff,#00,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#33,#00,#33,#00,#33
  db #00,#67,#00,#cf,#00,#9b,#ff,#00 ;.g......
  db #ff,#00,#00,#9b,#00,#c3,#00,#67 ;.......g
  db #00,#9b,#00,#cf,#00,#67,#ff,#00 ;.....g..
  db #ff,#00,#00,#e7,#00,#33,#00,#db
  db #00,#cf,#00,#f3,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#00,#cf
  db #00,#e7,#00,#cf,#00,#db,#ff,#00
  db #ff,#00,#00,#cb,#00,#cf,#00,#c7
  db #00,#87,#00,#8f,#00,#4b,#ff,#00 ;.....K..
  db #ff,#00,#00,#cb,#00,#cf,#00,#c7
  db #00,#c7,#00,#cf,#00,#cb,#ff,#00
  db #ff,#00,#00,#c3,#00,#33,#00,#c3
  db #00,#c3,#00,#33,#00,#c3,#ff,#00
  db #ff,#00,#55,#22,#00,#33,#aa,#11 ;..U.....
  db #ff,#00,#55,#22,#aa,#11,#ff,#00 ;..U.....
  db #55,#22,#00,#33,#00,#33,#aa,#11 ;U.......
  db #aa,#11,#00,#cf,#00,#cf,#55,#22 ;......U.
  db #55,#22,#00,#c7,#00,#cb,#aa,#11 ;U.......
  db #aa,#45,#00,#67,#00,#9b,#55,#8a ;.E.g..U.
  db #55,#8a,#00,#73,#00,#b3,#aa,#45 ;U..s...E
  db #aa,#45,#00,#db,#00,#e7,#55,#8a ;.E....U.
  db #55,#8a,#00,#cf,#00,#cf,#aa,#45 ;U......E
  db #aa,#51,#00,#cf,#00,#cf,#55,#a2 ;.Q....U.
  db #55,#82,#00,#cf,#00,#cf,#aa,#41 ;U......A
  db #aa,#41,#00,#4f,#00,#0f,#55,#82 ;.A.O..U.
  db #55,#82,#00,#cf,#00,#cf,#aa,#41 ;U......A
  db #aa,#41,#00,#cf,#00,#cf,#55,#82 ;.A....U.
  db #55,#82,#00,#63,#00,#93,#aa,#41 ;U..c...A
  db #aa,#41,#00,#93,#00,#63,#55,#82 ;.A...cU.
  db #ff,#00,#00,#33,#00,#33,#ff,#00
lab4C04:
  db #ff,#00,#55,#22,#ff,#00,#ff,#00 ;..U.....
  db #ff,#00,#ff,#00,#00,#33,#00,#b3
  db #00,#73,#00,#33,#ff,#00,#ff,#00 ;.s......
  db #ff,#00,#ff,#00,#00,#e3,#aa,#11
  db #aa,#45,#00,#db,#55,#82,#ff,#00 ;.E..U...
  db #ff,#00,#00,#e3,#00,#cf,#ff,#00
  db #aa,#51,#00,#67,#00,#cb,#55,#82 ;.Q.g..U.
  db #55,#82,#00,#cb,#00,#9b,#00,#67 ;U......g
  db #00,#67,#00,#cf,#00,#db,#55,#82 ;.g....U.
  db #55,#82,#00,#cf,#00,#0f,#ff,#00 ;U.......
  db #ff,#00,#00,#cf,#00,#0f,#55,#82 ;......U.
  db #55,#82,#00,#cf,#00,#cf,#aa,#45 ;U......E
  db #aa,#45,#00,#9b,#00,#cf,#55,#82 ;.E....U.
  db #55,#82,#aa,#11,#00,#33,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#aa,#11,#55,#22 ;......U.
  db #55,#22,#ff,#00,#ff,#00,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#ff,#00,#ff,#00
  db #ff,#00,#55,#22,#00,#33,#aa,#51 ;..U....Q
  db #aa,#11,#00,#b3,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#55,#82,#00,#73,#ff,#00 ;..U..s..
  db #ff,#00,#00,#cf,#00,#e3,#ff,#00
  db #55,#82,#00,#db,#aa,#45,#ff,#00 ;U....E..
  db #ff,#00,#00,#b3,#00,#cf,#00,#c3
  db #00,#c3,#00,#67,#00,#cf,#aa,#11 ;...g....
  db #aa,#11,#00,#cf,#00,#cf,#00,#e3
  db #00,#cb,#00,#4f,#aa,#05,#ff,#00 ;...O....
  db #ff,#00,#aa,#45,#00,#8f,#00,#4b ;...E...K
  db #00,#cb,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#00,#67,#00,#cb ;.....g..
  db #00,#63,#55,#22,#aa,#11,#ff,#00 ;.cU.....
  db #ff,#00,#ff,#00,#55,#22,#00,#33 ;....U...
  db #aa,#11,#ff,#00,#ff,#00,#ff,#00
lab4D04:
  db #ff,#00,#ff,#00,#55,#22,#ff,#00 ;....U...
  db #55,#a2,#00,#33,#aa,#11,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#00,#73,#55,#22 ;.....sU.
  db #ff,#00,#00,#b3,#aa,#41,#ff,#00 ;.....A..
  db #ff,#00,#00,#d3,#00,#cf,#ff,#00
  db #ff,#00,#55,#8a,#00,#e7,#aa,#41 ;..U....A
  db #00,#c3,#00,#cf,#00,#73,#ff,#00 ;.....s..
  db #55,#22,#00,#cf,#00,#9b,#00,#c3 ;U.......
  db #00,#d3,#00,#cf,#00,#cf,#55,#22 ;......U.
  db #ff,#00,#55,#0a,#00,#8f,#00,#c7 ;..U.....
  db #00,#87,#00,#4f,#55,#8a,#ff,#00 ;...OU...
  db #ff,#00,#00,#cf,#00,#cf,#00,#c7
  db #00,#c7,#00,#9b,#00,#cf,#ff,#00
  db #ff,#00,#55,#22,#aa,#11,#00,#93 ;..U.....
  db #00,#33,#aa,#11,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#55,#22 ;......U.
  db #ff,#00,#ff,#00,#aa,#11,#ff,#00
  db #00,#73,#00,#33,#ff,#00,#ff,#00 ;.s......
  db #ff,#00,#ff,#00,#00,#33,#00,#b3
  db #55,#22,#00,#d3,#ff,#00,#ff,#00 ;U.......
  db #ff,#00,#aa,#41,#00,#e7,#55,#8a ;...A..U.
  db #ff,#00,#00,#cf,#00,#d3,#ff,#00
  db #aa,#41,#00,#c7,#00,#9b,#55,#a2 ;.A....U.
  db #00,#9b,#00,#67,#00,#c7,#aa,#41 ;...g...A
  db #aa,#41,#00,#e7,#00,#cf,#00,#9b ;.A......
  db #ff,#00,#00,#0f,#00,#cf,#aa,#41 ;.......A
  db #aa,#41,#00,#0f,#00,#cf,#ff,#00 ;.A......
  db #55,#8a,#00,#cf,#00,#cf,#aa,#41 ;U......A
  db #aa,#41,#00,#cf,#00,#67,#55,#8a ;.A...gU.
  db #ff,#00,#00,#33,#55,#22,#aa,#41 ;....U..A
  db #aa,#11,#55,#22,#55,#22,#ff,#00 ;..U.U...
  db #ff,#00,#ff,#00,#ff,#00,#aa,#11
lab4E04:
  db #aa,#51,#00,#c3,#00,#d3,#ff,#00 ;.Q......
  db #55,#82,#00,#e3,#00,#93,#00,#63 ;U......c
  db #00,#33,#00,#33,#00,#e3,#55,#82 ;......U.
  db #55,#82,#00,#e3,#00,#33,#00,#33 ;U.......
  db #00,#cf,#00,#9b,#00,#e3,#55,#82 ;......U.
  db #55,#82,#00,#e3,#00,#9b,#00,#c3 ;U.......
  db #00,#cf,#00,#73,#00,#cb,#55,#82 ;...s..U.
  db #55,#82,#00,#cf,#00,#e7,#00,#33 ;U.......
  db #00,#f3,#00,#cf,#00,#67,#ff,#00 ;.....g..
  db #ff,#00,#00,#67,#00,#9b,#00,#67 ;...g...g
  db #00,#27,#00,#1b,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#55,#8a,#00,#cf,#aa,#45 ;..U....E
  db #aa,#45,#00,#cf,#ff,#00,#ff,#00 ;.E......
  db #ff,#00,#ff,#00,#00,#33,#aa,#11
  db #aa,#11,#00,#33,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#55,#22,#aa,#11 ;....U...
  db #ff,#00,#00,#c3,#00,#c3,#55,#a2 ;......U.
  db #00,#c3,#00,#73,#00,#c3,#aa,#11 ;...s....
  db #aa,#11,#00,#33,#00,#73,#00,#c3 ;.....s..
  db #00,#c3,#00,#73,#00,#33,#aa,#11 ;...s....
  db #aa,#45,#00,#cf,#00,#73,#00,#c3 ;.E...s..
  db #00,#c3,#00,#73,#00,#c7,#aa,#41 ;...s...A
  db #aa,#45,#00,#9b,#00,#e7,#00,#c3 ;.E......
  db #00,#cb,#00,#cf,#00,#73,#aa,#11 ;.....s..
  db #aa,#51,#00,#e7,#00,#9b,#55,#8a ;.Q....U.
  db #55,#8a,#00,#33,#00,#cf,#aa,#11 ;U.......
  db #aa,#11,#00,#0f,#00,#33,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#55,#8a,#ff,#00 ;....U...
  db #ff,#00,#55,#22,#00,#33,#ff,#00 ;..U.....
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#ff,#00,#00,#33,#ff,#00
lab4F04:
  db #aa,#51,#00,#c3,#00,#c3,#ff,#00 ;.Q......
  db #55,#22,#00,#c3,#00,#b3,#00,#c3 ;U.......
  db #00,#c3,#00,#b3,#00,#33,#55,#22 ;......U.
  db #55,#22,#00,#33,#00,#b3,#00,#c3 ;U.......
  db #00,#c3,#00,#b3,#00,#cf,#55,#8a ;......U.
  db #55,#82,#00,#cb,#00,#b3,#00,#c3 ;U.......
  db #00,#c3,#00,#db,#00,#67,#55,#8a ;.....gU.
  db #55,#22,#00,#b3,#00,#cf,#00,#c7 ;U.......
  db #aa,#45,#00,#67,#00,#db,#55,#a2 ;.E.g..U.
  db #55,#22,#00,#cf,#00,#33,#aa,#45 ;U......E
  db #ff,#00,#00,#33,#00,#0f,#55,#22 ;......U.
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#aa,#45,#00,#cf,#ff,#00 ;...E....
  db #ff,#00,#00,#33,#aa,#11,#ff,#00
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #ff,#00,#00,#33,#ff,#00,#ff,#00
  db #ff,#00,#00,#e3,#00,#c3,#55,#82 ;......U.
  db #00,#93,#00,#63,#00,#d3,#aa,#41 ;...c...A
  db #aa,#41,#00,#d3,#00,#33,#00,#33 ;.A......
  db #00,#33,#00,#33,#00,#d3,#aa,#41 ;.......A
  db #aa,#41,#00,#d3,#00,#67,#00,#cf ;.A...g..
  db #00,#c3,#00,#67,#00,#d3,#aa,#41 ;...g...A
  db #aa,#41,#00,#c7,#00,#b3,#00,#cf ;.A......
  db #00,#33,#00,#db,#00,#cf,#aa,#41 ;.......A
  db #ff,#00,#00,#9b,#00,#cf,#00,#f3
  db #00,#9b,#00,#67,#00,#9b,#ff,#00 ;...g....
  db #ff,#00,#aa,#11,#00,#27,#00,#1b
  db #55,#8a,#00,#cf,#aa,#45,#ff,#00 ;U....E..
  db #ff,#00,#ff,#00,#00,#cf,#55,#8a ;......U.
  db #55,#22,#00,#33,#ff,#00,#ff,#00 ;U.......
  db #ff,#00,#ff,#00,#00,#33,#55,#22 ;......U.
  db #55,#22,#aa,#11,#ff,#00,#ff,#00 ;U.......
lab5004:
  db #aa,#41,#ff,#00,#55,#82,#ff,#00 ;.A..U...
  db #ff,#00,#00,#c3,#00,#c3,#00,#c3
  db #00,#b3,#00,#c3,#00,#73,#ff,#00 ;.....s..
  db #ff,#00,#00,#73,#00,#33,#00,#b3 ;...s....
  db #00,#e7,#00,#cf,#00,#db,#ff,#00
  db #ff,#00,#00,#cb,#00,#c3,#00,#c7
  db #00,#9b,#00,#cf,#00,#67,#ff,#00 ;.....g..
  db #ff,#00,#00,#e7,#00,#33,#00,#db
  db #00,#cf,#00,#f3,#00,#cf,#ff,#00
  db #ff,#00,#00,#33,#00,#cf,#00,#33
  db #00,#33,#00,#0f,#00,#33,#ff,#00
  db #ff,#00,#55,#8a,#00,#cf,#aa,#45 ;..U....E
  db #aa,#45,#00,#cf,#55,#8a,#ff,#00 ;.E..U...
  db #ff,#00,#55,#22,#00,#33,#aa,#11 ;..U.....
  db #aa,#11,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#ff,#00,#00,#33,#ff,#00
  db #ff,#00,#55,#82,#aa,#41,#ff,#00 ;..U..A..
  db #55,#82,#00,#c3,#00,#c3,#aa,#41 ;U......A
  db #aa,#51,#00,#63,#00,#93,#55,#a2 ;.Q.c..U.
  db #55,#a2,#00,#33,#00,#33,#aa,#51 ;U......Q
  db #aa,#51,#00,#cf,#00,#cf,#55,#a2 ;.Q....U.
  db #55,#82,#00,#c7,#00,#cb,#aa,#41 ;U......A
  db #aa,#45,#00,#63,#00,#93,#55,#8a ;.E.c..U.
  db #55,#8a,#00,#63,#00,#93,#aa,#45 ;U..c...E
  db #aa,#45,#00,#cf,#00,#cf,#55,#8a ;.E....U.
  db #55,#22,#00,#9b,#00,#67,#aa,#11 ;U....g..
  db #aa,#11,#00,#27,#00,#1b,#55,#22 ;......U.
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#cf,#00,#cf,#ff,#00
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#55,#22,#aa,#11,#ff,#00 ;..U.....
lab5104:
  db #ff
lab5105:
  db #00,#ff,#00,#ff,#00,#ff,#00,#ff
  db #00,#55,#8a,#00,#cf,#ff,#00,#aa ;.U......
  db #45,#00,#cf,#00,#cf,#ff,#00,#ff ;E.......
  db #00,#00,#4f,#00,#0f,#aa,#45,#00 ;..O...E.
  db #cf,#00,#33,#00,#4f,#55,#8a,#55 ;....OU.U
  db #8a,#00,#27,#00,#27,#00,#8f,#00
  db #8f,#00,#27,#00,#27,#55,#8a,#55 ;.....U.U
  db #8a,#00,#0f,#00,#33,#00,#8f,#00
  db #8f,#00,#27,#00,#27,#55,#8a,#55 ;.....U.U
  db #8a,#00,#27,#00,#27,#00,#8f,#00
  db #cf,#00,#33,#00,#4f,#55,#8a,#ff ;....OU..
  db #00,#00,#4f,#00,#0f,#aa,#45,#aa ;..O...E.
  db #45,#00,#cf,#00,#cf,#ff,#00,#ff ;E.......
  db #00,#55,#8a,#00,#cf,#ff,#00,#ff ;.U......
  db #00,#ff,#00,#ff,#00,#ff,#00,#ff
  db #00,#ff,#00,#ff,#00,#ff,#00,#ff
  db #00,#ff,#00,#ff,#00,#ff,#00,#ff
  db #00,#55,#8a,#ff,#00,#ff,#00,#ff ;.U......
  db #00,#aa,#45,#00,#cf,#ff,#00,#ff ;..E.....
  db #00,#00,#4f,#aa,#45,#ff,#00,#ff ;..O.E...
  db #00,#00,#8f,#00,#27,#55,#8a,#55 ;.....U.U
  db #8a,#00,#27,#00,#8f,#ff,#00,#ff
  db #00,#00,#8f,#00,#27,#55,#8a,#55 ;.....U.U
  db #8a,#00,#27,#00,#8f,#ff,#00,#ff
  db #00,#00,#8f,#00,#27,#55,#8a,#55 ;.....U.U
  db #8a,#00,#27,#00,#8f,#ff,#00,#ff
  db #00,#00,#8f,#00,#27,#55,#8a,#ff ;.....U..
  db #00,#00,#4f,#aa,#45,#ff,#00,#ff ;..O.E...
  db #00,#aa,#45,#00,#cf,#ff,#00,#ff ;..E.....
  db #00,#55,#8a,#ff,#00,#ff,#00,#ff ;.U......
  db #00,#ff,#00,#ff,#00,#ff,#00,#ff
  db #00,#ff,#00,#ff,#00,#ff,#00
lab5204:
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#aa,#45,#ff,#00,#ff,#00 ;...E....
  db #ff,#00,#ff,#00,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#55,#8a,#ff,#00,#ff,#00 ;..U.....
  db #ff,#00,#aa,#45,#00,#cf,#ff,#00 ;...E....
  db #ff,#00,#00,#4f,#aa,#45,#ff,#00 ;...O.E..
  db #ff,#00,#00,#8f,#00,#27,#55,#8a ;......U.
  db #55,#8a,#00,#27,#00,#8f,#ff,#00 ;U.......
  db #ff,#00,#00,#8f,#00,#27,#55,#8a ;......U.
  db #55,#8a,#00,#27,#00,#8f,#ff,#00 ;U.......
  db #ff,#00,#00,#8f,#00,#27,#55,#8a ;......U.
  db #55,#8a,#00,#27,#00,#8f,#ff,#00 ;U.......
  db #ff,#00,#00,#8f,#00,#27,#55,#8a ;......U.
  db #ff,#00,#00,#4f,#aa,#45,#ff,#00 ;...O.E..
  db #ff,#00,#aa,#45,#00,#cf,#ff,#00 ;...E....
  db #ff,#00,#55,#8a,#ff,#00,#ff,#00 ;..U.....
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #55,#a2,#00,#f3,#aa,#51,#ff,#00 ;U....Q..
  db #aa,#51,#00,#f3,#00,#f3,#ff,#00 ;.Q......
  db #55,#a2,#00,#c3,#00,#e3,#00,#c3 ;U.......
  db #00,#ff,#00,#c3,#00,#d3,#55,#a2 ;......U.
  db #55,#a2,#55,#a2,#aa,#51,#00,#ff ;U.U..Q..
  db #00,#eb,#ff,#00,#ff,#00,#55,#82 ;......U.
  db #55,#a2,#ff,#00,#ff,#00,#55,#82 ;U.....U.
  db #55,#82,#ff,#00,#ff,#00,#55,#82 ;U.....U.
  db #ff,#00,#ff,#00,#ff,#00,#55,#82 ;......U.
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#aa,#51,#00,#f3,#55,#a2 ;...Q..U.
  db #00,#d3,#00,#d3,#aa,#51,#ff,#00 ;.....Q..
  db #ff,#00,#00,#e3,#00,#e3,#ff,#00
  db #00,#d3,#00,#c3,#00,#c3,#aa,#41 ;.......A
  db #aa,#55,#00,#fb,#00,#c3,#00,#f3 ;.U......
  db #aa,#51,#00,#f3,#55,#aa,#aa,#55 ;.Q..U..U
  db #aa,#55,#55,#82,#ff,#00,#aa,#41 ;.UU....A
  db #aa,#51,#ff,#00,#ff,#00,#aa,#41 ;.Q.....A
  db #aa,#41,#ff,#00,#ff,#00,#aa,#41 ;.A.....A
  db #ff,#00,#ff,#00,#ff,#00,#aa,#41 ;.......A
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #aa,#51,#00,#f3,#55,#a2,#ff,#00 ;.Q..U...
  db #ff,#00,#55,#a2,#00,#e3,#00,#e3 ;..U.....
  db #ff,#00,#00,#d3,#00,#d3,#ff,#00
  db #55,#82,#00,#c3,#00,#c3,#00,#e3 ;U.......
  db #00,#f3,#00,#c3,#00,#f7,#55,#aa ;......U.
  db #55,#aa,#aa,#55,#00,#f3,#55,#a2 ;U..U..U.
  db #55,#82,#ff,#00,#aa,#41,#55,#aa ;U....AU.
  db #55,#82,#ff,#00,#ff,#00,#55,#a2 ;U.....U.
  db #55,#82,#ff,#00,#ff,#00,#55,#82 ;U.....U.
  db #55,#82,#ff,#00,#ff,#00,#ff,#00 ;U.......
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#55,#a2,#00,#f3,#aa,#51 ;..U....Q
  db #ff,#00,#00,#f3,#00,#f3,#55,#a2 ;......U.
  db #00,#c3,#00,#f3,#00,#c3,#aa,#51 ;.......Q
  db #aa,#51,#00,#e3,#00,#d3,#00,#ff ;.Q......
  db #00,#ff,#55,#a2,#aa,#51,#aa,#51 ;..U..Q.Q
  db #aa,#41,#ff,#00,#ff,#00,#00,#d7 ;.A......
  db #aa,#41,#ff,#00,#ff,#00,#aa,#51 ;.A.....Q
  db #aa,#41,#ff,#00,#ff,#00,#aa,#41 ;.A.....A
  db #aa,#41,#ff,#00,#ff,#00,#ff,#00 ;.A......
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
lab5504:
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#55,#8a,#00,#cf,#ff,#00 ;..U.....
  db #aa,#45,#00,#c7,#00,#cf,#ff,#00 ;.E......
  db #ff,#00,#00,#cf,#00,#cb,#aa,#41 ;.......A
  db #00,#c3,#00,#33,#00,#cb,#55,#82 ;......U.
  db #55,#82,#00,#63,#00,#67,#00,#c3 ;U..c.g..
  db #00,#c3,#00,#67,#00,#63,#55,#82 ;...g.cU.
  db #55,#82,#00,#63,#00,#67,#00,#c3 ;U..c.g..
  db #00,#c3,#00,#33,#00,#c3,#55,#82 ;......U.
  db #55,#82,#00,#cb,#00,#67,#00,#c3 ;U....g..
  db #00,#c3,#00,#67,#00,#c3,#55,#82 ;...g..U.
  db #ff,#00,#00,#cb,#00,#cb,#aa,#45 ;.......E
  db #aa,#45,#00,#cf,#00,#c7,#ff,#00 ;.E......
  db #ff,#00,#55,#8a,#00,#cf,#ff,#00 ;..U.....
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#cf,#aa,#41,#ff,#00 ;.....A..
  db #ff,#00,#00,#c3,#00,#c7,#55,#8a ;......U.
  db #55,#82,#00,#cf,#00,#c3,#ff,#00 ;U.......
  db #aa,#41,#00,#93,#00,#67,#00,#cf ;.A...g..
  db #00,#cf,#00,#9b,#00,#93,#aa,#41 ;.......A
  db #aa,#41,#00,#93,#00,#93,#00,#cf ;.A......
  db #00,#cf,#00,#9b,#00,#9b,#aa,#45 ;.......E
  db #aa,#45,#00,#9b,#00,#63,#00,#c3 ;.E...c..
  db #00,#c3,#00,#cb,#00,#9b,#aa,#45 ;.......E
  db #aa,#45,#00,#9b,#00,#c3,#00,#c3 ;.E......
  db #55,#82,#00,#cb,#00,#c7,#ff,#00 ;U.......
  db #ff,#00,#00,#cf,#00,#c3,#55,#82 ;......U.
  db #ff,#00,#00,#cb,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
lab5604:
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#55,#82,#00,#c3,#ff,#00 ;..U.....
  db #aa,#41,#00,#c3,#00,#c3,#ff,#00 ;.A......
  db #ff,#00,#00,#c7,#00,#c3,#aa,#45 ;.......E
  db #00,#cf,#00,#33,#00,#c7,#55,#82 ;......U.
  db #55,#8a,#00,#63,#00,#63,#00,#cf ;U..c.c..
  db #00,#cf,#00,#63,#00,#67,#55,#8a ;...c.gU.
  db #55,#82,#00,#67,#00,#67,#00,#c7 ;U..g.g..
  db #00,#cf,#00,#33,#00,#cf,#55,#8a ;......U.
  db #55,#8a,#00,#cf,#00,#63,#00,#cb ;U....c..
  db #00,#c7,#00,#63,#00,#c7,#55,#8a ;...c..U.
  db #ff,#00,#00,#c7,#00,#c3,#aa,#45 ;.......E
  db #aa,#41,#00,#c3,#00,#c3,#ff,#00 ;.A......
  db #ff,#00,#55,#82,#00,#c3,#ff,#00 ;..U.....
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#cb,#aa,#45,#ff,#00 ;.....E..
  db #ff,#00,#00,#cf,#00,#cb,#55,#82 ;......U.
  db #55,#82,#00,#cb,#00,#cf,#ff,#00 ;U.......
  db #aa,#45,#00,#9b,#00,#63,#00,#c3 ;.E...c..
  db #00,#c3,#00,#9b,#00,#9b,#aa,#41 ;.......A
  db #aa,#45,#00,#93,#00,#9b,#00,#c3 ;.E......
  db #00,#cb,#00,#9b,#00,#9b,#aa,#41 ;.......A
  db #aa,#41,#00,#93,#00,#67,#00,#c7 ;.A...g..
  db #00,#cb,#00,#cf,#00,#93,#aa,#41 ;.......A
  db #aa,#41,#00,#93,#00,#cb,#00,#cf ;.A......
  db #55,#8a,#00,#cf,#00,#c3,#ff,#00 ;U.......
  db #ff,#00,#00,#c3,#00,#cf,#55,#82 ;......U.
  db #ff,#00,#00,#cf,#aa,#41,#ff,#00 ;.....A..
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#55,#22 ;......U.
  db #55,#22,#aa,#45,#ff,#00,#ff,#00 ;U..E....
  db #ff,#00,#ff,#00,#00,#63,#55,#8a ;.....cU.
  db #55,#22,#00,#db,#aa,#11,#ff,#00 ;U.......
  db #ff,#00,#00,#63,#00,#c7,#ff,#00 ;...c....
  db #ff,#00,#00,#b3,#00,#cb,#aa,#11
  db #aa,#11,#00,#c7,#00,#b3,#ff,#00
  db #ff,#00,#55,#8a,#00,#d3,#00,#63 ;..U....c
  db #00,#63,#00,#f3,#55,#22,#ff,#00 ;.c..U...
  db #ff,#00,#55,#a2,#00,#73,#00,#ff ;..U..s..
  db #00,#ff,#00,#73,#55,#a2,#ff,#00 ;...sU...
  db #ff,#00,#00,#f3,#00,#73,#00,#ff ;.....s..
  db #00,#bb,#00,#b3,#00,#33,#55,#a2 ;......U.
  db #55,#a2,#00,#c3,#00,#63,#00,#73 ;U....c.s
  db #aa,#51,#00,#63,#00,#f3,#55,#8a ;.Q.c..U.
  db #ff,#00,#00,#e7,#00,#d3,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#aa,#11
  db #00,#67,#ff,#00,#ff,#00,#ff,#00 ;.g......
  db #ff,#00,#ff,#00,#aa,#45,#00,#93 ;.....E..
  db #00,#9b,#00,#63,#ff,#00,#ff,#00 ;...c....
  db #ff,#00,#aa,#45,#00,#c3,#55,#22 ;...E..U.
  db #55,#22,#00,#db,#00,#63,#ff,#00 ;U....c..
  db #ff,#00,#00,#63,#00,#e7,#55,#22 ;...c..U.
  db #ff,#00,#00,#b3,#00,#c3,#aa,#11
  db #aa,#11,#00,#d3,#00,#b3,#ff,#00
  db #ff,#00,#00,#f3,#00,#bb,#aa,#55 ;.......U
  db #aa,#55,#00,#bb,#00,#f3,#ff,#00 ;.U......
  db #55,#a2,#00,#f3,#00,#bb,#aa,#55 ;U......U
  db #aa,#55,#00,#73,#00,#33,#00,#73 ;.U.s...s
  db #00,#d3,#00,#c3,#00,#b3,#aa,#11
  db #ff,#00,#00,#b3,#00,#d3,#55,#a2 ;......U.
  db #aa,#45,#00,#f3,#aa,#41,#ff,#00 ;.E...A..
  db #55,#22,#ff,#00,#ff,#00,#ff,#00 ;U.......
  db #ff,#00,#ff,#00,#ff,#00,#00,#67 ;.......g
  db #00,#db,#55,#22,#ff,#00,#ff,#00 ;..U.....
  db #ff,#00,#ff,#00,#00,#9b,#00,#63 ;.......c
  db #aa,#45,#00,#f3,#55,#22,#ff,#00 ;.E..U...
  db #ff,#00,#00,#9b,#00,#d3,#aa,#11
  db #aa,#11,#00,#c7,#00,#b3,#ff,#00
  db #55,#22,#00,#f3,#00,#cb,#ff,#00 ;U.......
  db #ff,#00,#00,#63,#00,#d3,#55,#22 ;...c..U.
  db #55,#aa,#00,#77,#00,#c3,#ff,#00 ;U..w....
  db #ff,#00,#00,#d3,#00,#77,#55,#aa ;.....wU.
  db #55,#aa,#00,#77,#00,#d3,#aa,#41 ;U..w...A
  db #00,#93,#00,#33,#00,#b3,#55,#aa ;......U.
  db #55,#22,#00,#73,#00,#d3,#00,#c3 ;U..s....
  db #00,#db,#00,#f3,#00,#73,#ff,#00 ;.....s..
  db #ff,#00,#55,#a2,#00,#f3,#aa,#45 ;..U....E
  db #aa,#11,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#55,#22,#aa,#45 ;....U..E
  db #aa,#11,#00,#e7,#ff,#00,#ff,#00
  db #ff,#00,#55,#22,#00,#db,#aa,#11 ;..U.....
  db #ff,#00,#00,#73,#00,#e7,#ff,#00 ;...s....
  db #55,#22,#00,#db,#00,#63,#ff,#00 ;U....c..
  db #ff,#00,#00,#67,#00,#d3,#55,#22 ;...g..U.
  db #00,#b3,#00,#d3,#aa,#11,#ff,#00
  db #ff,#00,#aa,#11,#00,#c3,#00,#b3
  db #00,#ff,#00,#93,#aa,#41,#ff,#00 ;.....A..
  db #ff,#00,#aa,#41,#00,#b3,#00,#ff ;...A....
  db #00,#ff,#00,#b3,#00,#c3,#ff,#00
  db #aa,#41,#00,#33,#00,#63,#00,#77 ;.A...c.w
  db #00,#b3,#00,#b3,#00,#c3,#aa,#41 ;.......A
  db #ff,#00,#00,#f3,#00,#b3,#55,#a2 ;......U.
  db #ff,#00,#00,#f3,#aa,#51,#aa,#45 ;.....Q.E
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#63,#aa,#11 ;.....c..
  db #aa,#11,#00,#93,#00,#33,#ff,#00
  db #55,#22,#00,#33,#00,#33,#00,#33 ;U.......
  db #00,#c3,#00,#33,#00,#33,#55,#82 ;......U.
  db #55,#82,#00,#f3,#00,#f3,#00,#eb ;U.......
  db #00,#eb,#00,#f3,#00,#f3,#55,#82 ;......U.
  db #55,#82,#00,#f3,#00,#f3,#00,#eb ;U.......
  db #00,#c3,#00,#33,#00,#33,#55,#82 ;......U.
  db #55,#22,#00,#33,#00,#33,#00,#33 ;U.......
  db #aa,#11,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#00,#33,#00,#33,#aa,#11
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #55,#22,#00,#c3,#00,#33,#ff,#00 ;U.......
  db #ff,#00,#00,#63,#00,#33,#55,#22 ;...c..U.
  db #00,#33,#00,#33,#00,#33,#aa,#11
  db #aa,#11,#00,#c3,#00,#93,#00,#33
  db #00,#f3,#00,#d3,#00,#d7,#aa,#51 ;.......Q
  db #aa,#51,#00,#d7,#00,#d3,#00,#f3 ;.Q......
  db #00,#f3,#00,#d3,#00,#d7,#aa,#51 ;.......Q
  db #aa,#11,#00,#c3,#00,#93,#00,#33
  db #00,#33,#00,#33,#00,#33,#aa,#11
  db #ff,#00,#00,#33,#00,#33,#55,#22 ;......U.
  db #55,#22,#00,#33,#00,#33,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#00,#93,#00,#63,#aa,#11 ;.....c..
  db #aa,#11,#00,#93,#00,#33,#ff,#00
  db #55,#22,#00,#33,#00,#33,#00,#33 ;U.......
  db #00,#33,#00,#63,#00,#c3,#55,#22 ;...c..U.
  db #55,#a2,#00,#eb,#00,#e3,#00,#f3 ;U.......
  db #00,#f3,#00,#e3,#00,#eb,#55,#a2 ;......U.
  db #55,#a2,#00,#eb,#00,#e3,#00,#f3 ;U.......
  db #00,#33,#00,#63,#00,#c3,#55,#22 ;...c..U.
  db #55,#22,#00,#33,#00,#33,#00,#33 ;U.......
  db #aa,#11,#00,#33,#00,#33,#ff,#00
  db #ff,#00,#00,#33,#00,#33,#aa,#11
  db #ff,#00,#00,#33,#55,#22,#ff,#00 ;....U...
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #55,#22,#00,#c3,#00,#33,#ff,#00 ;U.......
  db #ff,#00,#00,#63,#00,#33,#55,#22 ;...c..U.
  db #00,#33,#00,#33,#00,#33,#aa,#11
  db #aa,#41,#00,#33,#00,#33,#00,#c3 ;.A......
  db #00,#d7,#00,#f3,#00,#f3,#aa,#41 ;.......A
  db #aa,#41,#00,#f3,#00,#f3,#00,#d7 ;.A......
  db #00,#d7,#00,#f3,#00,#f3,#aa,#41 ;.......A
  db #aa,#41,#00,#33,#00,#33,#00,#c3 ;.A......
  db #00,#33,#00,#33,#00,#33,#aa,#11
  db #ff,#00,#00,#33,#00,#33,#55,#22 ;......U.
  db #55,#22,#00,#33,#00,#33,#ff,#00 ;U.......
  db #ff,#00,#aa,#11,#00,#33,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #aa,#05,#ff,#00,#55,#0a,#ff,#00 ;....U...
  db #ff,#00,#55,#8a,#55,#8a,#ff,#00 ;..U.U...
  db #ff,#00,#55,#0a,#55,#0a,#aa,#05 ;..U.U...
  db #00,#8f,#55,#8a,#aa,#05,#55,#0a ;..U...U.
  db #aa,#05,#aa,#45,#00,#4f,#55,#0a ;...E.OU.
  db #55,#0a,#00,#8f,#00,#4f,#aa,#45 ;U....O.E
  db #ff,#00,#00,#4f,#00,#8f,#ff,#00 ;...O....
  db #55,#0a,#00,#4f,#00,#cf,#aa,#05 ;U..O....
  db #00,#4f,#00,#cf,#00,#8f,#00,#8f ;.O......
  db #ff,#00,#00,#8f,#00,#4f,#ff,#00 ;.....O..
  db #ff,#00,#00,#cf,#55,#0a,#ff,#00 ;....U...
  db #ff,#00,#00,#4f,#00,#cf,#aa,#05 ;...O....
  db #aa,#45,#00,#0f,#aa,#05,#ff,#00 ;.E......
  db #55,#0a,#ff,#00,#aa,#45,#aa,#05 ;U....E..
  db #aa,#05,#aa,#05,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#aa,#05,#55,#0a ;......U.
  db #aa,#45,#ff,#00,#55,#8a,#ff,#00 ;.E..U...
  db #ff,#00,#55,#0a,#55,#0a,#ff,#00 ;..U.U...
  db #ff,#00,#55,#8a,#55,#8a,#aa,#45 ;..U.U..E
  db #00,#4f,#55,#0a,#aa,#45,#55,#8a ;.OU..EU.
  db #aa,#45,#aa,#05,#00,#8f,#55,#8a ;.E....U.
  db #55,#8a,#00,#4f,#00,#8f,#aa,#05 ;U..O....
  db #ff,#00,#00,#8f,#00,#4f,#ff,#00 ;.....O..
  db #55,#8a,#00,#8f,#00,#0f,#aa,#45 ;U......E
  db #00,#8f,#00,#0f,#00,#4f,#00,#4f ;.....O.O
  db #ff,#00,#00,#4f,#00,#8f,#ff,#00 ;...O....
  db #ff,#00,#00,#0f,#55,#8a,#ff,#00 ;....U...
  db #ff,#00,#00,#8f,#00,#0f,#aa,#45 ;.......E
  db #ff,#00,#00,#cf,#aa,#45,#ff,#00 ;.....E..
  db #55,#8a,#ff,#00,#aa,#05,#aa,#45 ;U......E
  db #aa,#45,#aa,#45,#ff,#00,#ff,#00 ;.E.E....
  db #ff,#00,#ff,#00,#aa,#45,#55,#8a ;.....EU.
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#55,#a2,#00,#f3,#ff,#00 ;..U.....
  db #aa,#51,#00,#c3,#00,#d3,#ff,#00 ;.Q......
  db #55,#a2,#00,#c3,#00,#c3,#00,#e3 ;U.......
  db #00,#b3,#00,#63,#00,#33,#55,#a2 ;...c..U.
  db #55,#a2,#00,#ff,#00,#fb,#00,#f7 ;U.......
  db #00,#33,#00,#33,#00,#33,#55,#22 ;......U.
  db #55,#22,#00,#33,#00,#33,#00,#33 ;U.......
  db #00,#0f,#00,#4f,#00,#0f,#55,#0a ;...O..U.
  db #ff,#00,#aa,#05,#aa,#45,#aa,#05 ;.....E..
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#00,#f3,#aa,#51,#ff,#00 ;.....Q..
  db #ff,#00,#00,#e3,#00,#c3,#55,#a2 ;......U.
  db #00,#d3,#00,#c3,#00,#c3,#aa,#51 ;.......Q
  db #aa,#11,#00,#93,#00,#63,#00,#33 ;.....c..
  db #00,#ff,#00,#fb,#00,#f7,#aa,#55 ;.......U
  db #aa,#11,#00,#33,#00,#33,#00,#33
  db #00,#33,#00,#33,#00,#33,#aa,#11
  db #aa,#45,#00,#cf,#00,#4f,#00,#cf ;.E...O..
  db #55,#8a,#55,#0a,#55,#8a,#ff,#00 ;U.U.U...
lab5D04:
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #aa,#15,#00,#bf,#55,#aa,#aa,#15 ;....U...
  db #00,#3f,#55,#aa,#00,#bf,#aa,#15 ;..U.....
  db #aa,#15,#00,#bf,#55,#aa,#55,#2a ;....U.U.
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #aa,#15,#00,#bf,#55,#aa,#aa,#15 ;....U...
  db #00,#3f,#55,#aa,#00,#bf,#aa,#15 ;..U.....
  db #aa,#15,#00,#bf,#55,#aa,#55,#2a ;....U.U.
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#00,#ff,#ff,#00
  db #ff,#00,#aa,#55,#55,#aa,#55,#aa ;...UU.U.
  db #aa,#55,#ff,#00,#00,#ff,#ff,#00 ;.U......
  db #ff,#00,#55,#aa,#55,#aa,#55,#aa ;..U.U.U.
  db #ff,#00,#ff,#00,#00,#ff,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
lab5E04:
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #aa,#15,#00,#bf,#55,#aa,#aa,#15 ;....U...
  db #00,#3f,#55,#aa,#00,#bf,#aa,#15 ;..U.....
  db #aa,#15,#00,#bf,#55,#aa,#55,#2a ;....U.U.
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#00,#ff,#ff,#00
  db #ff,#00,#aa,#55,#55,#aa,#55,#aa ;...UU.U.
  db #aa,#55,#ff,#00,#00,#ff,#ff,#00 ;.U......
  db #ff,#00,#aa,#55,#55,#aa,#55,#aa ;...UU.U.
  db #ff,#00,#ff,#00,#00,#ff,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #aa,#15,#00,#bf,#55,#aa,#aa,#15 ;....U...
  db #00,#3f,#55,#aa,#00,#bf,#aa,#15 ;..U.....
  db #aa,#15,#00,#bf,#55,#aa,#55,#2a ;....U.U.
  db #00,#3f,#00,#ff,#00,#bf,#00,#3f
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#55,#aa,#55,#aa ;....U.U.
  db #55,#aa,#55,#aa,#55,#aa,#55,#aa ;U.U.U.U.
  db #aa,#55,#ff,#00,#00,#ff,#55,#aa ;.U....U.
  db #55,#aa,#ff,#00,#55,#aa,#55,#aa ;U...U.U.
  db #ff,#00,#ff,#00,#ff,#00,#55,#aa ;......U.
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
  db #ff,#00,#ff,#00,#ff,#00,#ff,#00
lab5F04:
  db #ff,#00,#aa,#15,#55,#2a,#ff,#00 ;....U...
  db #ff,#00,#00,#3f,#00,#3f,#ff,#00
  db #aa,#15,#00,#7f,#00,#bf,#55,#2a ;......U.
  db #55,#2a,#00,#ff,#00,#ff,#aa,#15 ;U.......
  db #aa,#15,#00,#ff,#00,#ff,#55,#2a ;......U.
  db #00,#bf,#00,#bf,#00,#bf,#00,#7f
  db #00,#7f,#00,#3f,#00,#3f,#00,#bf
  db #00,#bf,#00,#6f,#00,#6f,#00,#7f ;...o.o..
  db #00,#7f,#00,#ff,#00,#ff,#00,#bf
  db #00,#bf,#00,#ff,#00,#ff,#00,#7f
  db #00,#7f,#00,#7f,#00,#bf,#00,#bf
  db #55,#2a,#00,#7f,#00,#bf,#aa,#15 ;U.......
  db #aa,#15,#00,#ff,#00,#ff,#55,#2a ;......U.
  db #55,#2a,#00,#bf,#00,#7f,#aa,#15 ;U.......
  db #ff,#00,#00,#3f,#00,#3f,#ff,#00
  db #ff,#00,#55,#2a,#aa,#15,#ff,#00 ;..U.....
lab5F84:
  db #33,#22,#33,#33,#cf,#8f,#cf,#8f
  db #0f,#0f,#0f,#0a,#11,#33,#33,#33
  db #67,#cf,#67,#cf,#0f,#0f,#05,#0f ;g.g.....
  db #00,#22,#11,#8f,#11,#8f,#11,#8f
  db #11,#8f,#11,#8f,#11,#8f,#11,#8f
  db #11,#8f,#11,#8f,#11,#8f,#00,#0a
  db #05,#9b,#05,#9b,#05,#cf,#05,#cf
  db #05,#8f,#05,#8f,#27,#9b,#33,#9b
  db #cf,#9b,#cf,#9b,#0f,#9b,#0f,#9b
  db #33,#8f,#33,#9b,#cf,#cf,#cf,#cf
  db #0f,#0f,#0f,#0f,#33,#33,#33,#33
  db #cf,#cf,#cf,#cf,#0f,#8f,#1b,#8f
  db #00,#11,#00,#33,#11,#67,#11,#cf ;.....g..
  db #11,#8f,#11,#8f,#27,#00,#33,#0a
  db #cf,#0f,#cf,#8f,#0f,#8f,#1b,#8f
  db #11,#8f,#11,#9b,#11,#cf,#11,#67 ;.......g
  db #00,#27,#00,#11,#33,#8f,#33,#8f
  db #cf,#8f,#cf,#0f,#0f,#0a,#0f,#00
  db #33,#33,#33,#33,#cf,#cf,#cf,#cf
  db #0f,#0f,#0f,#0f,#11,#8f,#11,#8f
  db #11,#8f,#11,#8f,#11,#8f,#11,#8f
  db #33,#8f,#33,#9b,#cf,#cf,#cf,#cf
  db #0f,#8f,#1b,#8f
lab6038:
  db #00,#00,#00,#00,#00,#00,#20,#82
  db #08,#20,#02,#00,#51,#40,#00,#00 ;....Q...
  db #00,#00,#51,#4f,#94,#f9,#45,#00 ;..QO..E.
  db #21,#ea,#1c,#2b,#c2,#00,#01,#25
  db #08,#52,#40,#00,#42,#8a,#14,#a2 ;.R..B...
  db #85,#00,#00,#00,#00,#00,#82,#00
  db #31,#86,#18,#61,#83,#00,#c1,#86 ;...a....
  db #18,#61,#8c,#00,#01,#42,#1c,#21 ;.a...B..
  db #40,#00,#20,#82,#3e,#20,#82,#00
  db #20,#82,#00,#00,#00,#00,#00,#00
  db #3e,#00,#00,#00,#00,#00,#00,#01
  db #04,#00,#08,#20,#84,#10,#40,#00
  db #00,#e4,#d3,#4d,#33,#80,#00,#63 ;...M...c
  db #86,#18,#63,#c0,#00,#e4,#c3,#18 ;..c.....
  db #c7,#c0,#01,#e0,#ce,#0c,#37,#80
  db #00,#63,#96,#59,#f1,#80,#01,#f4 ;.c.Y....
  db #1e,#0d,#33,#80,#00,#e4,#1e,#4d ;.......M
  db #33,#80,#01,#f0,#c6,#18,#c3,#00
  db #00,#e4,#ce,#4d,#33,#80,#00,#e4 ;...M....
  db #d3,#3c,#33,#80,#00,#82,#00,#00
  db #82,#00,#00,#82,#00,#20,#84,#00
  db #10,#84,#20,#40,#81,#00,#00,#0f
  db #80,#f8,#00,#00,#40,#81,#02,#10
  db #84,#00,#31,#20,#84,#20,#02,#00
  db #72,#2a,#aa,#b2,#07,#00,#73,#2c ;r.....s.
  db #be,#cb,#2c,#80,#f3,#2c,#bc,#cb
  db #2f,#00,#73,#2c,#30,#c3,#27,#00 ;..s.....
  db #f3,#2c,#b2,#cb,#2f,#00,#fb,#0c
  db #3c,#c3,#0f,#80,#fb,#0c,#3c,#c3
  db #0c,#00,#73,#2c,#30,#db,#27,#80 ;..s.....
  db #cb,#2c,#be,#cb,#2c,#80,#f1,#86
  db #18,#61,#8f,#00,#78,#c3,#0c,#b2 ;.a..x...
  db #c6,#00,#cb,#4e,#38,#e3,#4c,#80 ;...N..L.
  db #c3,#0c,#30,#c3,#2f,#80,#cb,#6e ;.......n
  db #ba,#cb,#2c,#80,#cb,#2e,#ba,#db
  db #6c,#80,#73,#2c,#b2,#cb,#27,#00 ;l.s.....
  db #f3,#2c,#b2,#f3,#0c,#00,#73,#2c ;......s.
  db #b2,#db,#46,#80,#f3,#2c,#b2,#f3 ;..F.....
  db #2c,#80,#73,#2c,#1c,#0b,#27,#00 ;..s.....
  db #f1,#86,#18,#61,#86,#00,#cb,#2c ;...a....
  db #b2,#cb,#27,#00,#cb,#2c,#94,#50 ;.......P
  db #82,#00,#cb,#2c,#ba,#e9,#45,#00 ;......E.
  db #89,#47,#08,#71,#48,#80,#db,#67 ;.G.qH..g
  db #08,#20,#82,#00,#fb,#29,#08,#43 ;.......C
  db #2f,#80,#18,#41,#04,#10,#41,#80 ;...A..A.
  db #10,#41,#08,#20,#80,#00,#60,#82 ;.A......
  db #08,#20,#86,#00,#20,#87,#1c,#a8
  db #82,#00,#00,#00,#00,#00,#0f,#80
  db #21,#44,#38,#41,#07,#00,#01,#cc ;.D.A....
  db #9e,#cb,#66,#80,#c3,#cc,#b2,#cb ;..f.....
  db #2b,#00,#01,#cc,#b0,#c3,#27,#00
  db #19,#e9,#a6,#9a,#66,#80,#01,#cc ;....f...
  db #bc,#c3,#27,#00,#63,#4c,#38,#c3 ;....cL..
  db #0c,#30,#01,#c9,#a6,#78,#69,#9c ;.....xi.
  db #c3,#cc,#b2,#cb,#2c,#80,#30,#03
  db #0c,#30,#c3,#00,#18,#01,#86,#18
  db #61,#8c,#c3,#8d,#38,#d3,#4c,#80 ;a.....L.
  db #30,#c3,#0c,#30,#c3,#00,#03,#4e ;.......N
  db #ba,#eb,#2c,#80,#03,#cc,#b2,#cb
  db #2c,#80,#01,#cc,#b2,#cb,#27,#00
  db #03,#cc,#b2,#cb,#2f,#30,#01,#e9
  db #a6,#9a,#67,#86,#03,#4e,#b0,#c3 ;..g..N..
  db #0c,#00,#01,#cc,#bc,#0b,#2f,#00
  db #61,#87,#18,#61,#83,#00,#03,#2c ;a..a....
  db #b2,#cb,#27,#00,#03,#2c,#b2,#51 ;.......Q
  db #42,#00,#03,#2c,#b2,#e9,#c5,#00 ;B.......
  db #02,#49,#18,#62,#49,#00,#03,#2c ;.I.bI...
  db #b2,#c9,#e0,#9c,#03,#ec,#84,#23
  db #2f,#80,#18,#82,#10,#20,#81,#80
  db #20,#82,#08,#20,#82,#00,#c0,#82
  db #04,#20,#8c,#00,#00,#00,#28,#50 ;.......P
  db #00,#00,#72,#2e,#b2,#ea,#27,#00 ;..r.....
lab6278:
  db #00,#00,#00,#0c,#31,#c7,#00,#20
  db #40,#e3,#cf,#fe,#00,#21,#28,#e3
  db #c5,#cb,#00,#00,#00,#00,#08,#e3
  db #00,#00,#00,#1c,#fb,#ff,#00,#00
  db #00,#03,#0e,#3c,#3c,#f0,#03,#0c
  db #30,#c3,#ff,#f3,#e7,#1c,#73,#fe ;......s.
  db #2d,#b4,#d7,#5f,#f1,#c3,#8f,#7d
  db #f7,#ff,#ff,#ff,#fe,#09,#e6,#59 ;.......Y
  db #75,#d7,#f1,#e3,#8e,#73,#ce,#3c ;u....s..
  db #1c,#71,#c7,#18,#63,#8f,#fb,#c7 ;.q..c...
  db #0d,#34,#d7,#3e,#8c,#10,#41,#04 ;......A.
  db #18,#62,#ff,#ff,#dd,#75,#d7,#6b ;.b...u.k
  db #59,#6b,#ae,#ba,#fb,#ef,#f9,#e7 ;Yk......
  db #9e,#fb,#cf,#38,#3c,#f3,#c8,#1c
  db #00,#00,#f3,#b9,#18,#80,#00,#00
  db #48,#6e,#07,#00,#00,#00,#ae,#b8 ;Hn......
  db #a3,#00,#00,#00,#be,#f2,#37,#00
  db #00,#00,#d0,#8c,#00,#00,#00,#00
  db #0c,#c6,#10,#82,#08,#20,#fc,#41 ;.......A
  db #06,#18,#50,#82,#fc,#00,#03,#14 ;..P.....
  db #ae,#5a,#fc,#00,#38,#72,#a4,#71 ;.Z...r.q
  db #fc,#41,#0c,#31,#4a,#18,#c0,#c1 ;.A..J...
  db #82,#04,#10,#79,#82,#08,#20,#82 ;...y....
  db #08,#20,#0c,#10,#40,#04,#10,#41 ;.......A
  db #66,#cb,#74,#f7,#c7,#4d,#46,#18 ;f.t..MF.
  db #2c,#fb,#e5,#92,#ef,#4a,#10,#41 ;.....J.A
  db #04,#51,#1c,#10,#41,#37,#b5,#6b ;.Q..A..k
  db #82,#08,#20,#82,#08,#62,#04,#10 ;.....b..
  db #41,#01,#cf,#2a,#37,#71,#7d,#03 ;A....q..
  db #ff,#df,#48,#c0,#7e,#07,#fd,#eb ;..H.....
  db #4d,#2c,#c6,#96,#69,#4a,#56,#b4 ;M...iJV.
  db #61,#07,#93,#57,#96,#6b,#6a,#55 ;a..W.kjU
  db #b3,#43,#5a,#a5,#7b,#7f,#ef,#7f ;.CZ.....
  db #79,#93,#cf,#9f,#17,#3f,#7f,#ff ;y.......
  db #be,#f3,#b1,#3f,#30,#a5,#19,#88
  db #50,#3f,#ad,#5a,#d5,#a8,#63,#30 ;P..Z..c.
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #1f,#7d,#ff,#ff,#00,#00,#38,#e3
  db #8d,#f3,#00,#00,#00,#00,#08,#63 ;.......c
  db #00,#00,#00,#00,#0b,#b6,#00,#00
  db #00,#00,#00,#0f,#00,#00,#00,#00
  db #00,#00,#fc,#f7,#cf,#3c,#f3,#df
  db #ec,#bd,#cf,#75,#75,#59,#4f,#7b ;...uuYO.
  db #f7,#be,#eb,#8e,#eb,#ce,#9a,#1a
  db #fb,#ef,#39,#e7,#7d,#eb,#ad,#34
  db #00,#03,#8e,#38,#f3,#cf,#79,#e7 ;......y.
  db #9e,#7b,#ef,#ba,#e3,#8c,#75,#d7 ;......u.
  db #fb,#f9,#ba,#eb,#ae,#ba,#eb,#f7
  db #be,#fb,#ef,#be,#f3,#d7,#a2,#84
  db #10,#82,#8c,#34,#3c,#f1,#c5,#08
  db #10,#00,#e7,#dd,#f3,#3f,#00,#c0
  db #e7,#4d,#28,#a1,#0c,#00,#df,#7e ;.M......
  db #db,#74,#03,#c0,#ef,#ae,#b6,#b8 ;.t......
  db #0f,#c0,#e3,#af,#1c,#78,#13,#c0 ;.....x..
  db #1c,#f7,#dc,#e3,#16,#4e,#83,#bf ;.....N..
  db #9e,#3c,#f1,#c1,#18,#b0,#43,#3f ;......C.
  db #ff,#fc,#63,#48,#30,#f3,#ff,#cf ;..cH....
  db #07,#77,#de,#f3,#ce,#20,#e3,#cf ;.w......
  db #8e,#1e,#39,#9c,#01,#c0,#9a,#71 ;.......q
  db #86,#18,#03,#10,#33,#cf,#3c,#fb
  db #02,#64,#16,#dd,#34,#d3,#02,#f0 ;.d......
  db #2c,#b8,#c3,#0f,#01,#c0,#9a,#71 ;.......q
  db #a6,#9a,#01,#c0,#0c,#30,#c3,#1e
  db #70,#26,#9c,#61,#86,#00,#c4,#0c ;p..a....
  db #f3,#cf,#3e,#c0,#99,#05,#b7,#4d ;.......M
  db #34,#c0,#bc,#0b,#2e,#30,#c3,#c0
  db #70,#26,#9c,#69,#a6,#80,#31,#01 ;p..i....
  db #8c,#61,#87,#80,#39,#9c,#78,#71 ;.a....xq
  db #f3,#c7,#04,#73,#cf,#7b,#ee,#e0 ;...s....
  db #f3,#ff,#cf,#0c,#12,#c6,#3f,#ff
  db #fc,#c2,#0d,#18,#83,#8f,#3c,#79 ;.......y
  db #fd,#c1,#72,#68,#c7,#3b,#ef,#38 ;..rh....
lab64B8:
  db #00,#00,#00,#00,#00,#8a,#cf,#00
  db #45,#cf,#cf,#00,#00,#4f,#0f,#45 ;E....O.E
  db #cf,#33,#67,#8a,#8a,#0f,#27,#8f ;..g.....
  db #8f,#27,#0f,#8a,#8a,#27,#33,#8f
  db #8f,#27,#0f,#8a,#8a,#0f,#27,#8f
  db #cf,#33,#67,#8a,#00,#4f,#0f,#45 ;..g..O.E
  db #45,#cf,#cf,#00,#00,#8a,#cf,#00 ;E.......
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #02,#ae,#06,#83,#3e,#11,#02,#7f
  db #ff,#7f,#ff,#12,#ff,#87,#fe,#ec
  db #c8,#80,#8c,#ce,#ef,#04,#ff,#81
  db #f7,#6c,#ff,#8f,#fe,#cc,#c8,#80 ;.l......
  db #fe,#ed,#98,#03,#f7,#bd,#30,#d6
  db #8c,#ce,#ef,#04,#ff,#81,#f7,#3b
  db #ff,#89,#ee,#ff,#ff,#c0,#00,#ff
  db #ff,#31,#00,#20,#ff,#97,#fe,#ec
  db #c8,#80,#ed,#bd,#cc,#a5,#ce,#4a ;.......J
  db #03,#85,#9e,#72,#fd,#10,#b5,#bd ;...r....
  db #09,#7d,#8c,#ce,#ef,#04,#ff,#81
  db #f7,#31,#ff,#93,#ec,#88,#00,#80
  db #05,#37,#b7,#fa,#da,#de,#44,#8e ;......D.
  db #8a,#ea,#aa,#ff,#73,#11,#10,#18 ;....s...
  db #ff,#9f,#fe,#ec,#cc,#88,#fd,#ef
  db #e5,#23,#fb,#f6,#d6,#da,#ff,#fb
  db #e5,#80,#b5,#2d,#a0,#01,#ff,#a5
  db #20,#08,#ff,#fb,#51,#08,#cc,#ee ;....Q...
  db #ee,#2d,#ff,#9c,#fe,#ec,#cc,#c8
  db #ce,#c9,#ca,#ec,#95,#22,#0a,#08
  db #d1,#95,#bd,#b2,#cc,#c8,#64,#a9 ;......d.
  db #fd,#4b,#c9,#37,#ff,#77,#73,#33 ;.K...ws.
  db #11,#ff,#a6,#ee,#cc,#88,#ef,#ff
  db #fb,#4b,#89,#4c,#ce,#ef,#80,#17 ;.K.L....
  db #dd,#ff,#d1,#92,#14,#2d,#9e,#00
  db #04,#97,#f6,#bf,#16,#92,#a0,#05
  db #a9,#78,#ff,#f7,#fb,#d0,#88,#cc ;.x......
  db #ee,#28,#ff,#9b,#fe,#88,#80,#00
  db #00,#fc,#d8,#c9,#08,#a5,#a5,#81
  db #7e,#db,#eb,#d3,#00,#99,#25,#29
  db #7f,#ed,#fb,#d2,#10,#ee,#ef,#0f
  db #ff,#ae,#ee,#cc,#88,#ff,#ff,#fa
  db #4f,#c3,#7d,#2f,#fd,#a5,#e9,#6f ;O......o
  db #f2,#ff,#70,#9f,#06,#d2,#c0,#f0 ;..p.....
  db #1b,#f6,#9f,#96,#b4,#8c,#fe,#97
  db #41,#aa,#1f,#18,#79,#d7,#0f,#cb ;A...y...
  db #5a,#ff,#f7,#17,#b5,#88,#cc,#ee ;Z.......
  db #21,#ff,#a0,#ec,#cc,#88,#88,#fe
  db #bc,#61,#20,#dc,#44,#6e,#a2,#df ;.a..Dn..
  db #39,#02,#00,#ee,#cd,#50,#a0,#ff ;.....P..
  db #ff,#f7,#30,#c4,#02,#20,#2f,#80
  db #8c,#ac,#ad,#03,#88,#81,#cc,#05
  db #ff,#b6,#ee,#cc,#88,#ff,#ef,#ee
  db #cf,#8e,#65,#8e,#07,#df,#5b,#f8 ;..e.....
  db #f0,#85,#a9,#73,#08,#c3,#c3,#c7 ;...s....
  db #e0,#c3,#da,#f3,#15,#87,#a4,#12
  db #43,#90,#7e,#be,#95,#f5,#85,#8b ;C.......
  db #43,#ab,#52,#c3,#c3,#b3,#8d,#e5 ;C.R.....
  db #ac,#ff,#7f,#f7,#b7,#88,#cc,#ee
  db #1d,#ff,#a0,#ef,#ec,#cf,#cc,#f9
  db #d8,#8c,#ff,#aa,#af,#e5,#05,#ff
  db #7b,#7b,#5a,#ff,#fb,#df,#7d,#ad ;..Z.....
  db #ad,#c2,#4d,#ee,#d4,#11,#97,#ef ;..M.....
  db #ee,#fe,#ef,#04,#cc,#04,#ff,#b4
  db #fa,#db,#5a,#7d,#f5,#a9,#04,#a5 ;..Z.....
  db #e5,#85,#58,#94,#a5,#92,#4b,#e1 ;..X...K.
  db #f5,#a5,#a2,#1a,#fa,#5a,#50,#27 ;.....ZP.
  db #ea,#fa,#40,#0d,#f4,#b5,#af,#59 ;.......Y
  db #f1,#8a,#5b,#ad,#80,#f4,#b6,#a5
  db #e1,#78,#ea,#0a,#f3,#57,#f0,#8b ;.x...W..
  db #9f,#56,#fa,#56,#03,#ff,#84,#5b ;.V.V....
  db #88,#cc,#ee,#15,#ff,#a4,#fe,#ee
  db #ee,#cc,#f9,#b1,#4f,#a8,#85,#e7 ;....O...
  db #25,#b2,#ed,#e6,#f3,#9d,#80,#b4
  db #0e,#9d,#fe,#cf,#ff,#f6,#f5,#2f
  db #3f,#e9,#ff,#a6,#6c,#c4,#fc,#fd ;....l...
  db #ee,#ee,#03,#cc,#81,#c8,#04,#ff
  db #bf,#c5,#a5,#86,#10,#a0,#a7,#85
  db #ef,#b4,#09,#ea,#78,#eb,#0a,#c3 ;....x...
  db #84,#e7,#38,#6f,#e0,#93,#6d,#a7 ;...o..m.
  db #f8,#e7,#c0,#87,#ef,#df,#b0,#3c
  db #0f,#80,#2d,#86,#82,#84,#87,#87
  db #cb,#eb,#3a,#5e,#f3,#a5,#08,#d2
  db #00,#e1,#07,#58,#70,#a6,#92,#0d ;...Xp...
  db #65,#ff,#fb,#1f,#52,#88,#cc,#ee ;e...R...
  db #11,#ff,#04,#cc,#99,#d7,#b1,#f7
  db #10,#c0,#16,#10,#18,#95,#c8,#8a
  db #cd,#94,#9c,#6a,#bb,#84,#14,#08 ;...j....
  db #08,#fb,#1f,#ff,#ff,#80,#03,#00
  db #88,#fd,#fd,#ef,#ff,#80,#00,#00
  db #88,#04,#ff,#c3,#e1,#de,#79,#6d ;......ym
  db #be,#5b,#5f,#1a,#84,#35,#88,#7c
  db #b6,#1f,#2d,#5b,#e0,#c9,#01,#7a ;.......z
  db #bc,#c3,#f0,#a5,#e7,#59,#61,#82 ;.....Ya.
  db #f1,#ed,#21,#6d,#a4,#3f,#41,#f0 ;...m..A.
  db #fc,#2f,#61,#e9,#f0,#5a,#0f,#8d ;..a..Z..
  db #f7,#2f,#03,#da,#c5,#0a,#d2,#c9
  db #e9,#d6,#b5,#e7,#de,#5e,#d3,#a7
  db #ff,#7b,#7d,#f4,#88,#cc,#ee,#0d
  db #ff,#81,#ee,#04,#ff,#97,#f3,#00
  db #00,#ff,#ff,#71,#00,#ad,#35,#11 ;...q....
  db #31,#c0,#8c,#60,#8f,#da,#ce,#ce
  db #ff,#ff,#b5,#e7,#e3,#03,#ff,#89
  db #f7,#db,#ca,#5c,#fe,#cc,#cc,#ee
  db #ee,#04,#ff,#c7,#d5,#cf,#41,#c7 ;......A.
  db #ba,#6c,#25,#a1,#ca,#0f,#d2,#05 ;.l......
  db #f2,#d7,#14,#ad,#ad,#7e,#0f,#52 ;.......R
  db #a5,#21,#9e,#78,#95,#a4,#a7,#fe ;...x....
  db #9c,#fa,#4f,#24,#d3,#e5,#28,#fa ;..O.....
  db #d8,#52,#96,#f5,#85,#e3,#48,#f5 ;.R....H.
  db #e8,#05,#84,#2c,#b8,#7a,#ff,#fa ;.....z..
  db #f2,#d3,#a5,#af,#f5,#9e,#f5,#be
  db #b7,#bc,#fd,#bf,#bf,#5b,#ff,#af
  db #88,#cc,#ee,#12,#ff,#9d,#ee,#cc
  db #88,#91,#24,#20,#56,#e7,#b6,#d3 ;....V...
  db #08,#f7,#7f,#b3,#30,#b6,#35,#21
  db #00,#80,#80,#40,#08,#fe,#de,#de
  db #ee,#ee,#ef,#05,#ff,#cc,#f7,#e1
  db #8f,#3c,#34,#9e,#3d,#28,#3c,#a1
  db #4a,#52,#fc,#a7,#34,#af,#10,#e7 ;JR......
  db #a7,#18,#f3,#d2,#ad,#b1,#6d,#e5 ;......m.
  db #a5,#84,#b7,#ec,#bd,#79,#38,#bc ;.....y..
  db #0c,#f1,#c3,#a0,#f7,#0c,#f0,#a3
  db #4e,#b4,#87,#97,#f1,#0f,#f4,#a0 ;N.......
  db #02,#81,#20,#81,#80,#85,#00,#80
  db #08,#50,#a5,#ff,#7d,#af,#be,#df ;.P......
  db #d2,#ff,#7a,#ff,#3f,#ff,#6f,#88 ;..z...o.
  db #cc,#ee,#04,#ff,#ff,#80,#ff,#ff
  db #e8,#00,#fe,#e8,#00,#02,#ff,#fd
  db #ae,#40,#9e,#fe,#df,#e9,#ed,#a0
  db #b5,#b9,#f3,#3f,#b5,#04,#f7,#33
  db #11,#84,#85,#16,#72,#12,#ec,#cc ;....r...
  db #88,#00,#fd,#89,#a6,#41,#88,#88 ;.....A..
  db #cc,#cc,#a0,#c7,#18,#6a,#a0,#5a ;.....j.Z
  db #f6,#01,#c1,#69,#a1,#69,#cc,#21 ;...i.i..
  db #0f,#03,#b0,#3e,#50,#10,#df,#c7 ;....P...
  db #85,#29,#f1,#ef,#58,#b7,#de,#fa ;....X...
  db #05,#f7,#f1,#ff,#70,#9f,#bc,#6f ;....p..o
  db #4b,#ef,#b1,#42,#4a,#21,#9e,#ce ;K..BJ...
  db #ff,#b4,#f3,#8f,#6f,#7a,#ad,#eb ;....oz..
  db #f7,#bf,#ff,#7d,#a7,#ff,#fd,#6d ;.......m
  db #a6,#fe,#ff,#97,#df,#08,#f5,#fe
  db #d9,#05,#ee,#87,#97,#c8,#fe,#11
  db #29,#40,#fa,#42,#ff,#86,#84,#c4 ;...B....
  db #9a,#84,#48,#be,#c8,#01,#02,#e9 ;..H.....
  db #08,#c2,#8c,#ce,#7a,#a7,#8c,#9e ;....z...
  db #da,#ca,#6e,#84,#ff,#ed,#fe,#ff ;..n.....
  db #e9,#0f,#80,#e9,#69,#c2,#5a,#a4 ;....i.Z.
  db #a1,#f0,#0a,#f3,#7f,#b3,#19,#a4
  db #fa,#58,#e5,#e0,#71,#c6,#fa,#f1 ;.X..q...
  db #6b,#f0,#72,#c6,#d6,#f0,#12,#f8 ;k.r.....
  db #1c,#87,#89,#8f,#b5,#a0,#08,#c8
  db #1f,#f4,#ff,#87,#02,#d0,#04,#de
  db #1b,#41,#f7,#bd,#3f,#3f,#1b,#b7 ;.A......
  db #fb,#63,#58,#f3,#cf,#8f,#ff,#84 ;.cX.....
  db #80,#08,#0c,#a4,#00,#34,#02,#da
  db #e2,#6d,#c5,#9f,#4e,#b5,#80,#87 ;.m..N...
  db #ff,#62,#ff,#c4,#ba,#5c,#ef,#8a ;.b......
  db #dc,#80,#98,#ff,#3b,#2b,#40,#ab
  db #b6,#b2,#7a,#b7,#ff,#66,#ef,#a4 ;..z..f..
  db #f2,#10,#c3,#7f,#a4,#3c,#23,#01
  db #cc,#10,#00,#10,#ff,#b7,#ef,#c0
  db #f7,#85,#a1,#17,#fb,#f7,#9e,#7a ;.......z
  db #e2,#0e,#48,#69,#a5,#30,#08,#52 ;..Hi...R
  db #a7,#f1,#4b,#58,#d3,#49,#65,#96 ;..KX.Ie.
  db #83,#f3,#ef,#d2,#a0,#43,#d2,#53 ;.....C.S
  db #bf,#01,#e8,#68,#f0,#5a,#70,#36 ;...h.Zp.
  db #8d,#e7,#bc,#3c,#96,#78,#e1,#f6 ;.....x..
  db #b4,#ac,#4b,#48,#8c,#78,#ad,#e3 ;..KH.x..
  db #c9,#3e,#5a,#d3,#ff,#bf,#7e,#9b ;..Z.....
  db #f0,#00,#16,#80,#df,#ff,#3f,#ff
  db #ed,#7f,#bd,#ff,#dd,#8b,#b9,#a3
  db #a5,#a4,#88,#08,#d4,#1b,#18,#55 ;.......U
  db #f7,#fe,#43,#7f,#99,#b2,#a2,#ab ;..C.....
  db #b8,#81,#ba,#f6,#fe,#ae,#98,#8b
  db #d5,#ac,#9a,#9e,#a4,#f9,#6f,#7b ;......o.
  db #81,#8b,#cc,#f2,#c2,#f6,#9c,#84
  db #29,#ff,#00,#c1,#d9,#80,#07,#48 ;.......H
  db #9b,#f6,#08,#80,#08,#f9,#60,#88
  db #cf,#bd,#e5,#20,#10,#e8,#0f,#a0
  db #13,#44,#00,#83,#28,#14,#28,#1b ;.D......
  db #00,#85,#28,#34,#34,#14,#28,#0e
  db #00,#03,#80,#08,#00,#87,#28,#34
  db #34,#38,#34,#14,#28,#0c,#00,#85
  db #20,#34,#68,#94,#80,#06,#00,#81 ;..h.....
  db #28,#06,#36,#81,#14,#0b,#00,#87
  db #20,#38,#29,#94,#94,#68,#80,#04 ;.....h..
  db #00,#8a,#28,#94,#36,#36,#68,#68 ;......hh
  db #94,#68,#94,#14,#09,#00,#88,#20 ;.h......
  db #20,#38,#39,#36,#91,#62,#40,#03 ;.....b..
  db #00,#88,#28,#34,#38,#38,#34,#34
  db #38,#38,#03,#34,#81,#14,#08,#00
  db #82,#20,#38,#04,#39,#92,#36,#91
  db #40,#00,#28,#16,#29,#16,#29,#29
  db #16,#38,#34,#38,#38,#34,#34,#14
  db #07,#00,#8b,#38,#36,#39,#36,#16
  db #16,#34,#91,#40,#00,#16,#04,#29
  db #86,#16,#16,#29,#16,#29,#38,#03
  db #34,#81,#14,#05,#00,#85,#20,#38
  db #29,#91,#39,#03,#36,#83,#91,#40
  db #00,#03,#29,#82,#16,#29,#03,#16
  db #88,#29,#29,#16,#29,#38,#38,#34
  db #14,#04,#00,#8b,#02,#34,#29,#94
  db #62,#62,#91,#36,#91,#40,#00,#05 ;bb......
  db #16,#8c,#29,#29,#16,#29,#16,#29
  db #16,#29,#16,#34,#34,#14,#03,#00
  db #86,#02,#01,#01,#16,#94,#62,#03 ;......b.
  db #91,#82,#40,#00,#03,#29,#81,#16
  db #06,#29,#82,#16,#29,#04,#16,#82
  db #34,#14,#04,#00,#8c,#20,#34,#16
  db #68,#91,#62,#91,#40,#28,#16,#16 ;h.b.....
  db #29,#06,#16,#83,#29,#16,#16,#03
  db #29,#03,#16,#81,#14,#03,#20,#89
  db #38,#16,#29,#16,#68,#91,#91,#68 ;....h..h
  db #14,#05,#16,#06,#29,#04,#16,#04
  db #34,#87,#38,#38,#34,#38,#16,#29
  db #94,#05,#68,#83,#29,#16,#29,#03 ;..h.....
  db #16,#83,#29,#16,#29,#03,#16,#90
  db #29,#29,#34,#34,#38,#38,#16,#34
  db #16,#38,#29,#16,#38,#94,#94,#68 ;.......h
  db #03,#94,#82,#16,#29,#03,#16,#90
  db #29,#29,#16,#29,#16,#16,#29,#16
  db #16,#34,#34,#38,#38,#16,#38,#34
  db #03,#38,#03,#34,#84,#16,#29,#68 ;.......h
  db #68,#02,#3d,#05,#83,#3e,#11,#02 ;h.......
  db #7f,#ff,#7f,#ff,#7f,#ff,#7f,#ff
  db #7f,#ff,#0e,#ff,#97,#fe,#ec,#85
  db #ff,#ec,#ce,#4c,#fb,#73,#00,#11 ;...L.s..
  db #f3,#08,#20,#81,#ff,#f7,#14,#00
  db #ff,#ff,#f7,#18,#03,#ff,#81,#f7
  db #57,#ff,#92,#fe,#ff,#ff,#ec,#85 ;W.......
  db #ff,#ee,#48,#01,#9f,#d8,#80,#08 ;..H.....
  db #80,#84,#20,#00,#ed,#03,#ff,#85
  db #c4,#20,#00,#00,#ef,#03,#ff,#90
  db #f7,#10,#00,#00,#ff,#7d,#30,#00
  db #f7,#34,#02,#81,#ff,#ff,#30,#02
  db #03,#ff,#81,#78,#03,#ff,#81,#f0 ;...x....
  db #03,#ff,#81,#f0,#03,#ff,#81,#f0
  db #03,#ff,#81,#f0,#03,#ff,#81,#f0
  db #03,#ff,#81,#f0,#03,#ff,#81,#f0
  db #03,#ff,#81,#f0,#03,#ff,#81,#f0
  db #03,#ff,#81,#f0,#03,#ff,#81,#f0
  db #03,#ff,#81,#f0,#03,#ff,#81,#f3
  db #14,#ff,#e8,#89,#02,#12,#89,#f0
  db #f7,#a5,#fa,#b0,#fb,#a5,#fa,#90
  db #f3,#a5,#fa,#a0,#f0,#a5,#f2,#ef
  db #0f,#fa,#07,#ff,#0f,#fa,#0b,#ff
  db #0f,#f7,#0f,#ff,#0f,#ff,#0f,#e8
  db #0f,#ff,#0f,#c6,#f1,#00,#f0,#cd
  db #0d,#99,#0b,#f4,#f6,#56,#f8,#f0 ;.....V..
  db #f4,#b4,#f0,#f0,#fa,#5a,#f0,#f0 ;.....Z..
  db #f4,#b4,#f0,#f0,#fa,#5a,#f0,#f0 ;.....Z..
  db #f4,#b4,#f0,#fe,#fb,#7b,#f0,#f0
  db #f1,#bf,#fa,#f7,#f7,#c3,#fc,#f0
  db #fd,#f6,#f8,#f0,#fc,#b4,#f0,#f0
  db #fa,#5a,#f0,#f0,#f4,#b4,#f0,#c4 ;.Z......
  db #cc,#4c,#88,#14,#ff,#81,#cf,#03 ;.L......
  db #ff,#81,#f8,#03,#88,#81,#f9,#03
  db #88,#81,#ff,#03,#88,#81,#ff,#03
  db #88,#81,#ff,#03,#88,#95,#ff,#b8
  db #88,#88,#ff,#f8,#88,#88,#ff,#f8
  db #88,#88,#ff,#f8,#88,#88,#ff,#f8
  db #88,#88,#fd,#03,#dd,#8d,#fb,#99
  db #9d,#9d,#ff,#99,#99,#9d,#ff,#99
  db #99,#9d,#ff,#03,#99,#a4,#ff,#f9
  db #99,#9d,#ff,#f9,#99,#99,#fd,#dd
  db #d9,#dd,#f5,#fd,#7d,#5d,#ff,#f9
  db #99,#99,#ff,#ff,#99,#99,#ff,#ff
  db #99,#9d,#ff,#ff,#99,#99,#ff,#ff
  db #99,#9d,#1c,#ff,#89,#89,#89,#88
  db #89,#88,#89,#89,#88,#88,#03,#98
  db #94,#88,#88,#98,#88,#88,#89,#88
  db #89,#88,#88,#98,#98,#88,#89,#88
  db #89,#88,#88,#98,#98,#03,#88,#85
  db #98,#88,#88,#89,#89,#04,#dd,#81
  db #99,#03,#9d,#81,#99,#04,#9d,#81
  db #99,#05,#9d,#83,#99,#9d,#99,#05
  db #9d,#81,#99,#03,#dd,#86,#fd,#82
  db #a8,#80,#28,#99,#05,#9d,#8e,#99
  db #9d,#99,#9d,#9d,#99,#9d,#9d,#99
  db #9d,#9d,#99,#9d,#9d,#1c,#ff,#82
  db #89,#88,#03,#89,#87,#88,#89,#89
  db #88,#98,#98,#88,#03,#98,#8f,#88
  db #89,#89,#88,#89,#88,#98,#98,#88
  db #89,#89,#88,#89,#98,#88,#04,#98
  db #83,#88,#98,#88,#03,#89,#04,#dd
  db #06,#9d,#84,#99,#9d,#99,#99,#08
  db #9d,#81,#99,#05,#9d,#8b,#fd,#bd
  db #ff,#ed,#f7,#ff,#bf,#ff,#9d,#99
  db #99,#06,#9d,#81,#99,#03,#9d,#87
  db #99,#9d,#9d,#99,#99,#9d,#9d,#1c
  db #ff,#a8,#a9,#a9,#89,#a9,#89,#a8
  db #a9,#a9,#9a,#98,#9a,#9b,#9a,#98
  db #9a,#9b,#89,#a9,#a9,#89,#98,#9a
  db #9a,#9b,#89,#a9,#a9,#89,#9a,#8a
  db #9a,#99,#98,#9a,#8a,#98,#88,#89
  db #a9,#a9,#04,#dd,#09,#9d,#81,#99
  db #03,#9d,#85,#99,#99,#9d,#9d,#99
  db #04,#9d,#8a,#99,#99,#ff,#bd,#99
  db #9d,#dd,#9d,#9d,#99,#03,#9d,#82
  db #99,#99,#05,#9d,#81,#99,#03,#9d
  db #81,#99,#05,#9d,#1c,#ff,#9d,#b9
  db #99,#bd,#bd,#99,#bd,#bd,#bf,#9b
  db #9b,#db,#fb,#99,#9b,#db,#fb,#b9
  db #b9,#bd,#bf,#99,#9b,#db,#db,#b9
  db #b9,#bd,#bd,#9b,#03,#db,#85,#9b
  db #9b,#db,#db,#99,#03,#bd,#04,#dd
  db #81,#9d,#03,#bd,#89,#9d,#9d,#bd
  db #bd,#9d,#9d,#bd,#bd,#9d,#03,#bd
  db #8c,#9d,#9d,#bd,#bd,#9d,#9d,#99
  db #bd,#9d,#99,#bd,#bd,#03,#9d,#8a
  db #bd,#9d,#9d,#bd,#bd,#9d,#9d,#99
  db #bd,#9d,#03,#bd,#88,#9d,#9d,#bd
  db #bd,#9d,#b9,#bd,#bd,#1a,#ff,#e1
  db #f0,#25,#bf,#bf,#ff,#5a,#bf,#bf ;.....Z..
  db #ff,#5a,#fb,#ff,#ff,#5a,#fb,#ff ;.Z...Z..
  db #ff,#5a,#bf,#bf,#ff,#5a,#fb,#ff ;.Z...Z..
  db #ff,#5a,#bf,#bf,#ff,#5a,#fb,#ff ;.Z...Z..
  db #ff,#5a,#fb,#ff,#ff,#5a,#bf,#bf ;.Z...Z..
  db #ff,#5a,#dd,#dd,#df,#6f,#bd,#bd ;.Z...o..
  db #bf,#00,#bd,#bd,#bf,#00,#bd,#bd
  db #bf,#00,#bd,#bd,#bf,#00,#bd,#bd
  db #bf,#02,#bd,#bd,#bf,#0a,#bd,#bd
  db #bf,#0d,#bd,#bd,#bf,#0f,#bd,#bd
  db #bf,#0f,#bd,#bd,#bf,#0f,#bd,#bd
  db #bf,#0f,#bd,#bd,#bf,#7f,#bd,#bd
  db #bf,#04,#ff,#81,#f3,#10,#ff,#ec
  db #fe,#ed,#dc,#dc,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f1,#f0,#0f,#af,#f8,#fc,#cf,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#0f,#af
  db #f0,#f0,#0f,#af,#f0,#f0,#2f,#af
  db #f0,#f0,#5f,#af,#f1,#fa,#5f,#af
  db #c6,#eb,#7f,#bf,#06,#ff,#86,#fb
  db #99,#ff,#ff,#77,#58,#03,#ff,#85 ;...wX...
  db #db,#ff,#ff,#fb,#b3,#03,#ff,#8d
  db #a1,#ff,#ff,#76,#b2,#ff,#ff,#fd ;...v....
  db #de,#ff,#ff,#fd,#d8,#03,#ff,#85
  db #e4,#ff,#ff,#dd,#d8,#03,#ff,#85
  db #bb,#ff,#ff,#77,#5b,#03,#ff,#85 ;...w....
  db #db,#ff,#ff,#fb,#b6,#03,#ff,#8d
  db #29,#ff,#ff,#76,#d6,#ff,#ff,#fd ;...v....
  db #de,#ff,#ff,#fd,#9b,#03,#ff,#85
  db #f6,#ff,#ff,#dc,#d9,#03,#ff,#8d
  db #b1,#ff,#ff,#77,#5b,#ff,#ff,#b7 ;...w....
  db #db,#ff,#ff,#fb,#b6,#03,#ff,#95
  db #29,#ff,#ff,#77,#f7,#ff,#ff,#fd ;...w....
  db #de,#ff,#ff,#fd,#db,#ff,#fb,#fb
  db #f2,#ff,#ff,#dd,#d9,#03,#ff,#9e
  db #fa,#ff,#bf,#fd,#ff,#89,#d9,#df
  db #df,#fd,#ff,#be,#ff,#fe,#66,#44 ;......fD
  db #04,#8e,#ee,#fe,#ff,#88,#01,#00
  db #00,#ce,#ee,#fa,#ff,#fa,#03,#20
  db #87,#9f,#ff,#bf,#ff,#fb,#ff,#fb
  db #05,#ff,#89,#bb,#fb,#ff,#ff,#8c
  db #ed,#fd,#ff,#90,#03,#00,#84,#ec
  db #c8,#08,#08,#04,#ff,#81,#ef,#03
  db #ff,#89,#cc,#88,#80,#80,#e5,#05
  db #10,#00,#d0,#03,#00,#84,#b3,#b3
  db #77,#f7,#04,#ff,#83,#b9,#df,#df ;w.......
  db #05,#ff,#9c,#99,#37,#f7,#ff,#bc
  db #dd,#fd,#ff,#84,#8c,#44,#00,#ac ;.....D..
  db #8d,#fd,#ff,#e5,#ee,#fe,#fe,#96
  db #6f,#ff,#ff,#d0,#05,#5b,#fb,#7f ;o.......
  db #00,#23,#00,#83,#a8,#d6,#d6,#04
  db #a8,#15,#00,#03,#a8,#87,#d6,#d6
  db #e9,#d6,#e9,#d6,#d6,#03,#a8,#0d
  db #a2,#05,#00,#81,#a8,#04,#d6,#05
  db #e9,#82,#d6,#e9,#07,#d6,#81,#f6
  db #05,#d6,#81,#54,#05,#00,#81,#a8 ;...T....
  db #0a,#d6,#81,#f6,#06,#d6,#82,#f6
  db #f6,#05,#d6,#07,#00,#0a,#d6,#81
  db #f6,#06,#d6,#82,#f6,#f9,#05,#d6
  db #07,#00,#0a,#d6,#82,#f6,#f6,#0c
  db #d6,#07,#00,#0a,#d6,#03,#f6,#0b
  db #d6,#07,#00,#0a,#d6,#05,#f6,#09
  db #d6,#06,#00,#81,#a8,#11,#f6,#07
  db #d6,#81,#a8,#04,#00,#81,#a8,#19
  db #d6,#85,#54,#00,#ac,#84,#ac,#06 ;..T.....
  db #84,#82,#ac,#ac,#04,#84,#81,#ac
  db #05,#84,#86,#ac,#84,#ac,#84,#ac
  db #ac,#04,#84,#91,#5c,#d4,#5c,#e8
  db #d4,#e8,#d4,#e8,#d4,#5c,#fc,#d4
  db #d4,#e8,#e8,#fc,#d4,#03,#e8,#87
  db #d4,#fc,#d4,#fc,#d4,#d4,#e8,#04
  db #d4,#02,#06,#05,#83,#3e,#11,#02
  db #49,#ff,#84,#ee,#fe,#fe,#ff,#03 ;I.......
  db #77,#5b,#ff,#81,#bf,#18,#ff,#88 ;w.......
  db #de,#de,#da,#ca,#cc,#cc,#ce,#ee
  db #58,#ff,#81,#9d,#03,#8c,#88,#ff ;X.......
  db #f3,#00,#00,#ff,#ff,#f1,#07,#03
  db #ff,#81,#3f,#09,#ff,#87,#fe,#fc
  db #de,#b5,#b7,#b7,#af,#03,#ff,#85
  db #bf,#ff,#f7,#73,#37,#54,#ff,#03 ;...s.T..
  db #bb,#81,#b1,#13,#ff,#91,#f7,#ff
  db #fc,#dc,#ce,#bd,#bf,#a5,#af,#df
  db #5f,#8d,#bf,#ff,#f3,#33,#37,#53 ;.......S
  db #ff,#85,#ee,#ee,#e6,#e6,#f7,#04
  db #ee,#8f,#f7,#30,#00,#0c,#ff,#fc
  db #00,#00,#e8,#13,#40,#17,#fd,#b3
  db #7f,#05,#ff,#88,#fa,#d8,#c8,#c8
  db #fb,#73,#77,#76,#54,#ff,#84,#fe ;.swvT...
  db #de,#da,#c2,#04,#ff,#89,#ee,#56 ;.......V
  db #52,#42,#ff,#77,#77,#33,#e0,#03 ;RB.ww...
  db #00,#88,#ff,#fe,#ec,#c8,#ff,#ff
  db #f7,#73,#04,#ff,#04,#c8,#84,#89 ;.s......
  db #90,#00,#00,#50,#ff,#99,#fe,#ef ;...P....
  db #ff,#ff,#b7,#b5,#a5,#63,#ff,#fe ;.....c..
  db #ed,#cd,#c8,#48,#08,#08,#cc,#ee ;...H....
  db #ef,#ff,#ff,#fe,#ec,#c0,#80,#03
  db #00,#82,#ce,#ef,#04,#ff,#86,#f7
  db #73,#c9,#d9,#d9,#db,#04,#ff,#84 ;s.......
  db #f7,#77,#77,#73,#50,#ff,#04,#dc ;.wwsP...
  db #8c,#93,#94,#82,#84,#f0,#ff,#aa
  db #a8,#f0,#ff,#33,#31,#04,#ff,#8d
  db #fe,#da,#ca,#4f,#f7,#73,#31,#1f ;...O.s..
  db #ce,#ee,#ee,#ff,#fb,#07,#ff,#82
  db #cc,#ee,#05,#ff,#81,#73,#4c,#ff ;.....sL.
  db #04,#dc,#a1,#b3,#c4,#bb,#44,#ff ;......D.
  db #ff,#77,#bb,#b5,#bd,#fd,#ff,#b7 ;.w......
  db #b1,#91,#f1,#ef,#f3,#33,#f3,#af
  db #f9,#99,#f9,#ee,#e2,#22,#e2,#ff
  db #fe,#ee,#ff,#cf,#03,#ff,#84,#93
  db #53,#93,#43,#50,#ff,#85,#ee,#dd ;S.CP....
  db #ee,#cc,#88,#03,#00,#83,#aa,#dd
  db #ee,#03,#ff,#92,#77,#ff,#b5,#a1 ;....w...
  db #81,#e1,#ff,#f3,#33,#f3,#ff,#f9
  db #99,#f9,#ee,#e2,#20,#80,#03,#ff
  db #89,#fd,#fb,#bf,#bf,#ff,#88,#98
  db #89,#89,#4c,#ff,#03,#ee,#81,#ce ;..L.....
  db #03,#ee,#89,#ff,#aa,#a0,#a0,#00
  db #aa,#a0,#a0,#00,#04,#88,#92,#a5
  db #a1,#81,#e1,#b7,#b1,#31,#f1,#ff
  db #f9,#99,#f1,#d9,#99,#b9,#9f,#dd
  db #fd,#05,#ff,#82,#ef,#ff,#03,#7f
  db #03,#ff,#81,#77,#47,#ff,#85,#fe ;...wG...
  db #ce,#8a,#ca,#48,#05,#ff,#87,#75 ;...H...u
  db #51,#31,#ff,#f5,#55,#f5,#04,#88 ;Q...U...
  db #06,#a5,#86,#a4,#84,#f7,#73,#53 ;......sS
  db #12,#04,#9f,#89,#ff,#ff,#77,#ff ;......w.
  db #ef,#ed,#e8,#a4,#80,#03,#00,#84
  db #88,#cc,#ce,#ef,#24,#ff,#85,#f7
  db #20,#00,#00,#90,#03,#00,#88,#f7
  db #20,#00,#00,#ff,#73,#11,#00,#03 ;....s...
  db #ff,#81,#f3,#0c,#ff,#88,#dc,#fe
  db #ff,#ff,#b7,#f7,#b5,#a5,#05,#ff
  db #87,#ee,#ee,#ec,#ff,#ff,#55,#5f ;......U.
  db #04,#88,#81,#a0,#03,#00,#81,#80
  db #03,#00,#81,#ef,#03,#ff,#04,#9f
  db #81,#ee,#03,#ff,#84,#a4,#84,#ad
  db #ad,#03,#ff,#86,#7f,#ff,#ff,#ee
  db #ee,#88,#03,#00,#16,#ff,#9b,#fc
  db #a0,#ff,#ff,#90,#00,#ff,#ff,#ec
  db #00,#ff,#f5,#29,#28,#ff,#b0,#4d ;.......M
  db #6b,#f7,#db,#f3,#eb,#ff,#b7,#5b ;k.......
  db #c7,#ef,#04,#ff,#83,#f7,#73,#30 ;......s.
  db #0c,#ff,#88,#da,#98,#88,#aa,#a5
  db #ad,#ef,#ef,#03,#ff,#81,#df,#03
  db #ff,#a1,#2f,#ff,#ff,#cd,#d9,#d1
  db #64,#48,#84,#ab,#ce,#ed,#fe,#f7 ;dH......
  db #77,#1d,#d4,#fb,#5b,#db,#ff,#ff ;w.......
  db #0a,#05,#00,#dc,#cc,#ec,#cc,#bf
  db #ff,#ff,#dd,#04,#ee,#13,#ff,#b9
  db #e8,#ff,#ee,#88,#00,#ff,#ff,#fe
  db #97,#de,#d5,#f9,#af,#fd,#d6,#ba
  db #57,#d3,#5a,#ef,#3c,#c5,#88,#68 ;W.Z....h
  db #df,#a7,#a1,#0d,#eb,#c7,#ac,#af
  db #b5,#8c,#4a,#d6,#61,#ff,#ff,#f7 ;..J.a...
  db #77,#f8,#cf,#dc,#ee,#f8,#cf,#14 ;w.......
  db #00,#f8,#cf,#10,#1a,#a8,#a8,#88
  db #88,#03,#ed,#a1,#ad,#de,#dc,#cc
  db #ce,#d2,#df,#ff,#fb,#9a,#9a,#53 ;.......S
  db #43,#80,#cc,#cc,#2c,#ff,#ee,#ee ;C.......
  db #de,#b5,#bd,#ad,#69,#dd,#ad,#77 ;....i..w
  db #76,#bb,#4b,#ff,#fe,#04,#cc,#96 ;v.K.....
  db #df,#df,#ff,#ff,#8d,#8c,#94,#94
  db #f4,#6f,#94,#a4,#f4,#6f,#10,#20 ;.o...o..
  db #f4,#6f,#03,#1b,#f5,#7f,#03,#ff ;.o......
  db #cb,#ef,#e6,#9a,#df,#e5,#15,#80
  db #e5,#e4,#80,#b7,#ac,#5e,#ff,#e4
  db #eb,#da,#57,#fc,#85,#84,#69,#25 ;..W...i.
  db #a2,#94,#25,#44,#de,#66,#bf,#ce ;...D.f..
  db #b5,#c2,#df,#bf,#d0,#4a,#6d,#fe ;.....Jm.
  db #fe,#d7,#3d,#be,#ff,#ff,#7b,#cd
  db #80,#ac,#ef,#ff,#ed,#a5,#ad,#20
  db #88,#88,#9e,#de,#a5,#85,#85,#a5
  db #ce,#ef,#ed,#ed,#fb,#bb,#bf,#ff
  db #ad,#a5,#63,#23,#03,#a5,#91,#a6 ;..c.....
  db #da,#5a,#52,#54,#a5,#a5,#b6,#a6 ;.ZRT....
  db #89,#91,#10,#00,#fe,#ee,#ef,#ff
  db #04,#cc,#91,#ff,#e9,#a9,#ad,#94
  db #94,#90,#90,#94,#80,#a5,#bf,#fe
  db #be,#c0,#00,#80,#03,#00,#bc,#ed
  db #bd,#ec,#a5,#bc,#ca,#56,#bf,#ff ;.....V..
  db #d3,#48,#8b,#d4,#8d,#f2,#3c,#fa ;.H......
  db #f6,#9b,#7a,#a1,#a9,#20,#84,#cb ;..z.....
  db #d6,#42,#40,#ee,#7f,#ad,#e9,#88 ;.B......
  db #14,#0a,#2c,#f2,#95,#b5,#af,#c6
  db #b6,#5a,#34,#95,#e3,#85,#c9,#b5 ;.Z......
  db #2a,#0a,#9c,#ca,#22,#8c,#ef,#ff
  db #fa,#fc,#8b,#03,#ff,#82,#77,#a4 ;......w.
  db #03,#00,#03,#ed,#86,#ff,#80,#84
  db #84,#ac,#cc,#03,#99,#89,#8a,#a8
  db #aa,#8a,#f5,#5f,#55,#f5,#ee,#03 ;....U...
  db #bb,#08,#ff,#89,#cc,#cc,#df,#ff
  db #a5,#80,#00,#00,#80,#03,#00,#03
  db #ff,#a1,#ad,#ff,#af,#be,#db,#92
  db #7b,#bf,#a6,#80,#18,#32,#5c,#83
  db #6d,#6a,#5c,#ff,#49,#ad,#a5,#80 ;mj..I...
  db #09,#2b,#54,#a3,#76,#f5,#b7,#ac ;..T.v...
  db #24,#9d,#ae,#12,#00,#82,#a8,#a8
  db #16,#00,#81,#0a,#06,#00,#82,#a8
  db #54,#16,#00,#04,#0a,#86,#00,#00 ;T.......
  db #a8,#54,#54,#a8,#15,#00,#81,#a8 ;.TT.....
  db #04,#00,#85,#8a,#88,#e4,#e4,#88
  db #14,#00,#83,#a8,#54,#a8,#04,#8a ;....T...
  db #83,#00,#e4,#e4,#15,#00,#8a,#a8
  db #fc,#a8,#a8,#45,#88,#88,#00,#e4 ;...E....
  db #d8,#14,#00,#8c,#a8,#54,#dc,#ec ;.....T..
  db #54,#88,#88,#44,#88,#e4,#cc,#88 ;T..D....
  db #14,#00,#8c,#88,#e4,#64,#64,#cc ;.....dd.
  db #e4,#e4,#44,#e4,#cc,#44,#88,#13 ;..D..D..
  db #00,#81,#88,#03,#64,#06,#98,#81 ;....d...
  db #64,#14,#00,#84,#31,#64,#98,#64 ;d....d.d
  db #06,#98,#81,#32,#13,#00,#84,#22
  db #31,#64,#64,#04,#98,#85,#4c,#98 ;.dd...L.
  db #32,#31,#22,#11,#00,#84,#22,#22
  db #33,#32,#05,#98,#85,#e4,#98,#32
  db #32,#11,#09,#00,#05,#88,#03,#00
  db #84,#22,#11,#33,#31,#04,#98,#87
  db #64,#e4,#32,#32,#31,#11,#11,#05 ;d.......
  db #00,#03,#88,#86,#46,#46,#c4,#c4 ;....FF..
  db #44,#88,#03,#00,#82,#64,#98,#04 ;D....d..
  db #4c,#87,#8c,#4c,#64,#98,#64,#98 ;L..Ld.d.
  db #10,#04,#00,#82,#88,#88,#04,#c4
  db #03,#46,#82,#89,#c4,#04,#64,#8c ;.F....d.
  db #98,#4c,#8c,#8c,#4c,#8c,#4c,#8c ;.L..L.L.
  db #8c,#64,#98,#98,#04,#64,#87,#c4 ;.d...d..
  db #46,#46,#89,#46,#89,#c8,#03,#89 ;FF.F....
  db #b9,#c4,#c4,#64,#98,#64,#98,#4c ;...d.d.L
  db #8c,#4c,#4c,#8c,#4c,#4c,#8c,#64 ;.LL.LL.d
  db #98,#98,#64,#98,#98,#46,#89,#89 ;..d..F..
  db #46,#c4,#c8,#46,#89,#46,#89,#46 ;F..F.F.F
  db #89,#46,#89,#46,#c4,#98,#4c,#4c ;.F.F..LL
  db #8c,#c6,#c9,#4c,#0c,#0c,#64,#98 ;...L..d.
  db #98,#c4,#c4,#89,#46,#46,#89,#46 ;....FF.F
  db #89,#89,#02,#cb,#04,#83,#3e,#11
  db #02,#7f,#ff,#7f,#ff,#7f,#ff,#7f
  db #ff,#7f,#ff,#7f,#ff,#7f,#ff,#0d
  db #ff,#88,#ec,#80,#ff,#f0,#00,#00
  db #ff,#1f,#03,#ff,#81,#0f,#03,#ff
  db #85,#8f,#ff,#ff,#88,#0f,#03,#ff
  db #83,#f3,#33,#33,#1e,#ff,#96,#ee
  db #ee,#ec,#80,#00,#00,#ff,#99,#9f
  db #99,#ff,#99,#9f,#99,#ff,#99,#9f
  db #99,#ff,#99,#9f,#99,#26,#ff,#9e
  db #ee,#ee,#ec,#80,#00,#00,#ff,#ff
  db #dd,#77,#ff,#cc,#ff,#cc,#ff,#99 ;.w......
  db #ff,#99,#ff,#33,#ff,#33,#ff,#22
  db #ff,#22,#ff,#44,#ff,#44,#04,#cc ;...D.D..
  db #1c,#ff,#04,#ee,#94,#fd,#d7,#5d
  db #75,#9f,#99,#9f,#99,#bf,#99,#9f ;u.......
  db #99,#9f,#99,#9f,#99,#9f,#99,#9f
  db #99,#24,#ff,#04,#ee,#9c,#dd,#77 ;.......w
  db #dd,#77,#dd,#77,#dd,#77,#ff,#cc ;.w.w.w..
  db #ff,#cc,#ff,#99,#ff,#99,#ff,#33
  db #ff,#33,#ff,#22,#ff,#22,#ff,#44 ;.......D
  db #ff,#44,#04,#cc,#06,#ff,#8e,#ec ;.D......
  db #80,#ff,#f0,#00,#00,#ff,#f0,#00
  db #00,#ff,#f7,#77,#77,#08,#ff,#04 ;...ww...
  db #ee,#94,#d7,#5d,#75,#d7,#9f,#99 ;....u...
  db #9f,#99,#9f,#99,#9f,#99,#9f,#99
  db #9f,#99,#df,#99,#9f,#99,#24,#ff
  db #04,#ee,#9c,#dd,#77,#dd,#77,#dd ;....w.w.
  db #77,#dd,#77,#ff,#cc,#ff,#cc,#ff ;w.w.....
  db #99,#ff,#99,#ff,#33,#ff,#33,#ff
  db #22,#ff,#22,#ff,#44,#ff,#44,#04 ;....D.D.
  db #cc,#04,#ff,#81,#ed,#03,#a5,#08
  db #af,#04,#88,#a7,#ff,#ff,#ec,#80
  db #ec,#80,#00,#00,#ff,#cc,#cc,#ff
  db #ff,#22,#22,#ff,#ff,#11,#11,#ff
  db #ff,#00,#00,#ff,#ff,#88,#88,#ff
  db #ff,#44,#44,#ff,#ff,#22,#22,#ff ;.DD.....
  db #ff,#11,#11,#05,#ff,#94,#ee,#ee
  db #ec,#c8,#f8,#bb,#ab,#8f,#f0,#37
  db #25,#0f,#f0,#53,#65,#0f,#f1,#55 ;...Se..U
  db #75,#1f,#04,#ff,#04,#ee,#9c,#dd ;u.......
  db #77,#dd,#77,#dd,#77,#dd,#77,#ff ;w.w.w.w.
  db #cc,#ff,#cc,#ff,#99,#ff,#99,#ff
  db #33,#ff,#33,#ff,#22,#ff,#22,#ff
  db #44,#ff,#44,#04,#cc,#90,#8a,#98 ;D.D.....
  db #b8,#ff,#f5,#37,#bf,#00,#f6,#15
  db #9f,#00,#f9,#9b,#9f,#00,#04,#88
  db #a7,#ff,#ff,#fd,#a5,#ed,#e5,#a5
  db #a5,#fc,#cc,#cf,#ff,#f2,#22,#2f
  db #ff,#f1,#11,#1f,#ff,#f0,#00,#0f
  db #ff,#f8,#88,#8f,#ff,#f4,#44,#4f ;......DO
  db #ff,#f2,#22,#2f,#ff,#f1,#11,#1f
  db #06,#ff,#b7,#55,#ff,#88,#ff,#55 ;...U...U
  db #ff,#88,#ff,#55,#ff,#88,#ff,#55 ;...U...U
  db #ff,#88,#ff,#55,#ff,#88,#ff,#55 ;...U...U
  db #ff,#88,#ff,#55,#ff,#88,#ff,#55 ;...U...U
  db #ff,#ff,#dd,#77,#dd,#77,#ff,#cc ;...w.w..
  db #ff,#cc,#ff,#99,#ff,#99,#ff,#33
  db #ff,#33,#ff,#22,#ff,#22,#ff,#44 ;.......D
  db #ff,#44,#04,#de,#04,#a5,#94,#ff ;.D......
  db #f8,#88,#88,#ff,#fc,#cc,#c0,#ff
  db #f6,#66,#60,#ff,#f3,#33,#30,#ff ;.f......
  db #f1,#11,#11,#04,#a5,#a0,#cc,#cc
  db #ff,#fc,#dd,#dd,#00,#0d,#ee,#ee
  db #00,#0e,#ff,#ff,#00,#0f,#88,#88
  db #ff,#f8,#bb,#bb,#00,#0b,#dd,#dd
  db #00,#0d,#ee,#ee,#00,#0e,#04,#ff
  db #9c,#8f,#ff,#88,#8f,#8f,#ff,#88
  db #8f,#8f,#ff,#88,#8f,#8f,#ff,#88
  db #8f,#8f,#ff,#88,#8f,#8f,#ff,#88
  db #8f,#8f,#ff,#88,#8f,#04,#ff,#98
  db #dd,#77,#dd,#77,#ff,#cc,#ff,#cc ;.w.w....
  db #ff,#99,#ff,#99,#ff,#33,#ff,#33
  db #ff,#22,#ff,#22,#ff,#44,#ff,#44 ;.....D.D
  db #04,#de,#04,#a5,#94,#ff,#88,#88
  db #8f,#ff,#cc,#cc,#0f,#ff,#66,#66 ;......ff
  db #0f,#ff,#33,#33,#0f,#ff,#11,#11
  db #1f,#04,#a5,#a0,#cc,#cf,#ff,#cc
  db #dd,#d0,#00,#dd,#ee,#e0,#00,#ee
  db #ff,#f0,#00,#ff,#88,#8f,#ff,#88
  db #bb,#b0,#00,#bb,#dd,#d0,#00,#dd
  db #ee,#e0,#00,#ee,#05,#ff,#9a,#88
  db #8f,#ff,#ff,#88,#8f,#ff,#ff,#88
  db #8f,#ff,#ff,#88,#8f,#ff,#ff,#88
  db #8f,#ff,#ff,#88,#8f,#ff,#ff,#88
  db #8f,#05,#ff,#98,#dd,#77,#dd,#77 ;.....w.w
  db #ff,#cc,#ff,#cc,#ff,#99,#ff,#99
  db #ff,#33,#ff,#33,#ff,#22,#ff,#22
  db #ff,#44,#ff,#44,#04,#de,#04,#a5 ;.D.D....
  db #94,#f8,#88,#88,#ff,#fc,#cc,#c0
  db #ff,#f6,#66,#60,#ff,#f3,#33,#30 ;..f.....
  db #ff,#f1,#11,#11,#ff,#04,#a5,#a0
  db #cc,#ff,#fc,#cc,#dd,#00,#0d,#dd
  db #ee,#00,#0e,#ee,#ff,#00,#0f,#ff
  db #88,#ff,#f8,#88,#bb,#00,#0b,#bb
  db #dd,#00,#0d,#dd,#ee,#00,#0e,#ee
  db #04,#ff,#9c,#88,#8f,#ff,#88,#88
  db #8f,#ff,#88,#88,#8f,#ff,#88,#88
  db #8f,#ff,#88,#88,#8f,#ff,#88,#88
  db #8f,#ff,#88,#88,#8f,#ff,#88,#04
  db #ff,#98,#dd,#77,#dd,#77,#ff,#cc ;...w.w..
  db #ff,#cc,#ff,#99,#ff,#99,#ff,#33
  db #ff,#33,#ff,#22,#ff,#22,#ff,#44 ;.......D
  db #ff,#44,#04,#de,#04,#a5,#94,#88 ;.D......
  db #88,#8f,#f8,#cc,#cc,#0f,#fc,#99
  db #99,#f0,#09,#cc,#cc,#f0,#0c,#ee
  db #ee,#e0,#0e,#04,#a5,#a0,#cf,#ff
  db #cc,#cc,#d0,#00,#dd,#dd,#e0,#00
  db #ee,#ee,#f0,#00,#ff,#ff,#8f,#ff
  db #88,#88,#b0,#00,#bb,#bb,#d0,#00
  db #dd,#dd,#e0,#00,#ee,#ee,#04,#ff
  db #ad,#8f,#ff,#00,#00,#8f,#ff,#cc
  db #cc,#8f,#ff,#11,#11,#8f,#ff,#88
  db #88,#8f,#ff,#66,#66,#8f,#ff,#11 ;...ff...
  db #11,#8f,#ff,#88,#88,#ff,#ff,#77 ;.......w
  db #77,#dd,#77,#dd,#77,#ff,#cc,#cc ;w.w.w...
  db #ff,#ff,#11,#11,#ff,#f8,#03,#88
  db #88,#f7,#66,#66,#77,#ff,#00,#00 ;..ffw...
  db #ff,#04,#de,#04,#a5,#81,#8f,#03
  db #ff,#8d,#f0,#32,#22,#22,#f0,#60
  db #99,#00,#f0,#c4,#44,#44,#e0,#03 ;....DD..
  db #00,#03,#a5,#a1,#a0,#fc,#cc,#cc
  db #cf,#f2,#22,#22,#2f,#f1,#11,#11
  db #1f,#fc,#dd,#dc,#cc,#f1,#55,#51 ;......UQ
  db #11,#fc,#cc,#cc,#cf,#f2,#22,#22
  db #2f,#f1,#11,#11,#1f,#04,#ff,#7f
  db #00,#62,#00,#82,#88,#20,#04,#10 ;.b......
  db #81,#20,#07,#00,#82,#88,#88,#04
  db #18,#09,#00,#83,#88,#88,#4c,#05 ;......L.
  db #18,#81,#10,#07,#00,#82,#88,#4c ;.......L
  db #04,#18,#09,#00,#8b,#88,#4c,#4c ;......LL
  db #18,#18,#1a,#18,#18,#10,#00,#88
  db #03,#80,#84,#00,#00,#88,#c4,#04
  db #18,#09,#00,#84,#88,#c4,#4c,#90 ;......L.
  db #04,#18,#88,#10,#00,#4c,#60,#60 ;.....L..
  db #40,#88,#88,#08,#18,#82,#00,#08
  db #04,#2e,#84,#00,#88,#4c,#4c,#05 ;.....LL.
  db #18,#82,#10,#24,#03,#18,#83,#40
  db #c4,#c4,#08,#18,#81,#00,#08,#18
  db #83,#4c,#18,#90,#03,#18,#82,#98 ;.L......
  db #c4,#05,#18,#82,#c4,#18,#03,#24
  db #81,#18,#03,#24,#81,#00,#07,#18
  db #82,#30,#64,#05,#18,#82,#98,#c4 ;..d.....
  db #05,#18,#82,#c4,#18,#03,#24,#81
  db #18,#03,#24,#81,#00,#07,#18,#84
  db #30,#c4,#1a,#90,#03,#18,#82,#98
  db #c4,#05,#18,#82,#c4,#18,#03,#24
  db #81,#18,#03,#24,#81,#00,#07,#18
  db #82,#30,#4c,#05,#18,#84,#98,#c4 ;..L.....
  db #18,#18,#03,#24,#82,#c4,#18,#03
  db #24,#81,#18,#03,#24,#81,#00,#08
  db #18,#89,#4c,#18,#18,#90,#90,#18 ;..L.....
  db #98,#c4,#18,#04,#24,#81,#c4,#03
  db #18,#82,#90,#90,#03,#18,#01,#00
  db #02,#3d,#05,#83,#3e,#11,#02,#7f
  db #ff,#7f,#ff,#7f,#ff,#7f,#ff,#7f
  db #ff,#7f,#ff,#7f,#ff,#6a,#ff,#f0 ;.....j..
  db #fb,#ff,#ff,#bd,#7f,#ff,#ff,#bf
  db #ff,#ff,#af,#f7,#7e,#ff,#bf,#f6
  db #f3,#ff,#bb,#ed,#bd,#ff,#d6,#be
  db #3e,#ff,#5b,#6d,#bf,#ff,#5d,#bd ;...m....
  db #89,#ff,#3c,#5b,#d2,#ff,#ad,#85
  db #a8,#ff,#9b,#e1,#4e,#ff,#69,#05 ;....N.i.
  db #81,#ff,#61,#a4,#e5,#ff,#54,#b8 ;..a...T.
  db #52,#ff,#41,#49,#4d,#ff,#a2,#d3 ;R.AIM...
  db #70,#ff,#68,#52,#5f,#ff,#69,#4a ;p.hR..iJ
  db #58,#ff,#9d,#78,#27,#ff,#5b,#5a ;X..x...Z
  db #51,#ff,#c3,#ad,#b4,#ff,#ab,#db ;Q.......
  db #19,#ff,#ad,#6b,#df,#ff,#96,#d7 ;...k....
  db #c7,#ff,#dd,#7b,#9b,#ff,#df,#f6
  db #fc,#ff,#5f,#fe,#e7,#ff,#ff,#df
  db #03,#ff,#82,#9b,#ef,#03,#ff,#ff
  db #fd,#cb,#db,#fd,#ff,#ff,#a5,#bf
  db #df,#90,#32,#80,#01,#ef,#fb,#e7
  db #fa,#fe,#7b,#af,#7a,#bf,#f5,#fe ;....z...
  db #5c,#fb,#5b,#db,#4b,#d6,#a5,#a6 ;....K...
  db #39,#d6,#16,#17,#b5,#ab,#52,#40 ;......R.
  db #86,#9e,#97,#8f,#5a,#8a,#d3,#cb ;....Z...
  db #56,#b9,#66,#f6,#dc,#f5,#c9,#56 ;V.f....V
  db #bd,#9c,#0b,#16,#5b,#b6,#36,#b6
  db #2f,#d2,#8d,#06,#ad,#da,#75,#a7 ;......u.
  db #5b,#ae,#db,#09,#4c,#ea,#43,#c2 ;....L.C.
  db #59,#9e,#9e,#1f,#a5,#82,#5b,#df ;Y.......
  db #e9,#96,#86,#8e,#da,#b6,#5a,#56 ;......ZV
  db #89,#fd,#ad,#bd,#2d,#df,#fa,#f7
  db #a3,#f7,#6d,#5f,#e5,#80,#02,#81 ;..m.....
  db #0a,#90,#c4,#10,#08,#ff,#5a,#df ;......Z.
  db #bf,#c2,#42,#04,#00,#fb,#ef,#ff ;..B.....
  db #5f,#de,#f6,#57,#fa,#63,#fd,#79 ;...W.c.y
  db #e5,#a9,#da,#52,#d9,#7b,#ad,#86 ;...R....
  db #aa,#86,#be,#50,#5a,#7a,#8d,#20 ;...PZz..
  db #ea,#5e,#97,#af,#52,#91,#b5,#af ;....R...
  db #a5,#5a,#a7,#da,#ca,#18,#b4,#b2 ;.Z......
  db #0f,#6f,#9a,#db,#f9,#24,#b5,#a7 ;.o......
  db #d7,#cd,#b6,#a5,#09,#84,#fc,#52 ;.......R
  db #53,#43,#d8,#d4,#92,#0d,#81,#a4 ;SC......
  db #bc,#3a,#d6,#fa,#05,#0a,#da,#5e
  db #36,#33,#95,#bd,#f9,#42,#d2,#d4 ;.....B..
  db #0d,#6f,#a1,#4a,#ce,#7e,#da,#5f ;.o.J....
  db #5a,#25,#9e,#5f,#a4,#88,#e4,#bf ;Z.......
  db #9a,#4a,#d7,#a0,#ad,#e5,#a4,#e9 ;.J......
  db #aa,#e9,#b5,#a4,#b9,#e5,#fb,#e9
  db #7a,#59,#f6,#ae,#f5,#68,#fd,#7f ;zY...h..
  db #af,#b7,#d6,#09,#7a,#06,#d4,#ff ;....z...
  db #92,#92,#f4,#c3,#76,#f6,#05,#a0 ;....v...
  db #a0,#5a,#f2,#82,#48,#29,#f4,#d7 ;.Z..H...
  db #fd,#69,#02,#bf,#6f,#d6,#09,#f2 ;.i..o...
  db #e5,#a5,#0e,#b6,#bb,#d2,#0d,#af
  db #5f,#da,#04,#bf,#b7,#ba,#0a,#a4
  db #94,#9a,#52,#a2,#14,#52,#a5,#82 ;..R..R..
  db #08,#34,#94,#ea,#fa,#f9,#5a,#b2 ;......Z.
  db #bf,#2f,#fa,#88,#18,#d4,#7a,#fc ;......z.
  db #fe,#b5,#fd,#ed,#3f,#4b,#e5,#ad ;.....K..
  db #6d,#6a,#53,#bf,#be,#d5,#05,#a0 ;mjS.....
  db #50,#4a,#fd,#d2,#df,#b6,#0b,#b6 ;PJ......
  db #7a,#5a,#07,#db,#ed,#b6,#01,#fe ;zZ......
  db #fb,#69,#04,#84,#31,#49,#f2,#ad ;.i...I..
  db #af,#5a,#09,#db,#5b,#29,#f5,#b6 ;.Z......
  db #94,#94,#f2,#b6,#09,#e5,#06,#fe
  db #5b,#e6,#bd,#ad,#e5,#b4,#b7,#ff
  db #bd,#b6,#7f,#3a,#a0,#a4,#34,#20
  db #9c,#48,#0a,#1a,#95,#e9,#b5,#fe ;.H......
  db #b5,#f5,#fe,#bf,#bf,#a7,#ef,#5f
  db #b1,#bb,#ff,#2f,#ad,#7b,#eb,#df
  db #c6,#d9,#ab,#57,#f6,#bf,#af,#6f ;...W...o
  db #fc,#fd,#eb,#df,#b0,#20,#08,#0a
  db #ea,#10,#a5,#49,#f2,#63,#62,#f7 ;...I.cb.
  db #83,#6f,#b5,#f6,#90,#48,#22,#83 ;.o...H..
  db #fd,#ef,#5f,#bf,#b4,#de,#5f,#6f ;.......o
  db #e9,#47,#a2,#51,#fe,#7d,#7d,#bf ;.G.Q....
  db #fe,#5e,#bd,#7f,#df,#5f,#bd,#7f
  db #a5,#85,#10,#24,#9a,#79,#da,#f6 ;.....y..
  db #91,#a8,#25,#85,#bd,#af,#6d,#bd ;......m.
  db #fb,#d6,#a7,#e5,#a8,#a5,#05,#23
  db #b5,#ad,#f6,#d9,#84,#b5,#f5,#89
  db #d7,#a5,#0b,#ea,#db,#c6,#12,#ff
  db #a5,#cb,#ac,#27,#eb,#97,#5b,#2f
  db #5f,#af,#5a,#05,#bf,#af,#d5,#0e ;..Z.....
  db #b7,#e9,#6d,#0d,#f7,#ef,#d6,#09 ;..m.....
  db #f5,#a6,#89,#09,#63,#c7,#b3,#0b ;....c...
  db #e5,#af,#5e,#0b,#f5,#b6,#db,#0b
  db #e3,#fa,#da,#0d,#fd,#eb,#da,#05
  db #b6,#d4,#92,#18,#39,#a0,#5a,#f4 ;......Z.
  db #0a,#f4,#b4,#0f,#5e,#d6,#bd,#84
  db #7f,#a0,#5a,#7d,#04,#c1,#81,#92 ;..Z.....
  db #81,#a8,#e6,#f6,#93,#a1,#41,#f4 ;......A.
  db #85,#a2,#14,#f4,#21,#81,#41,#f8 ;......A.
  db #05,#90,#5b,#f1,#20,#96,#a0,#4f ;.......O
  db #af,#d2,#af,#b1,#02,#ed,#30,#84
  db #5b,#be,#50,#0d,#75,#92,#de,#fa ;..P.u...
  db #09,#9f,#7a,#e5,#a5,#8d,#36,#49 ;..z....I
  db #02,#c8,#42,#04,#80,#81,#05,#ff ;..B.....
  db #0a,#04,#af,#7d,#af,#f5,#df,#bd
  db #fb,#7d,#bf,#d7,#fe,#7d,#d6,#ff
  db #af,#eb,#ee,#c5,#9b,#75,#de,#d7 ;.....u..
  db #f7,#f6,#fd,#7d,#7f,#ff,#fd,#7d
  db #5f,#bd,#af,#fd,#f7,#d7,#87,#12
  db #94,#0a,#dc,#fd,#bd,#f2,#f2,#fb
  db #6b,#22,#e7,#f7,#db,#f5,#bd,#7b ;k.......
  db #69,#eb,#df,#af,#fa,#bf,#df,#eb ;i.......
  db #a7,#df,#fb,#eb,#ef,#1f,#bf,#d6
  db #fc,#f6,#88,#e5,#62,#75,#b7,#be ;....bu..
  db #5f,#7d,#ff,#be,#de,#eb,#f6,#fb
  db #fd,#af,#db,#eb,#5f,#fa,#80,#1a
  db #05,#80,#d6,#db,#fd,#6f,#b4,#39 ;.....o..
  db #d6,#fb,#fd,#e5,#7e,#5a,#a5,#06 ;.....Z..
  db #92,#d2,#d6,#0a,#dd,#75,#be,#0d ;.....u..
  db #ad,#f3,#de,#0c,#ff,#d5,#eb,#ff
  db #09,#ed,#f5,#f5,#06,#ff,#79,#a6 ;......y.
  db #05,#ef,#a9,#ee,#14,#ab,#03,#fa
  db #78,#5b,#fd,#ff,#0a,#0e,#7d,#eb ;x.......
  db #e4,#2f,#7f,#bf,#f0,#a7,#eb,#af
  db #60,#de,#fd,#ff,#a0,#ff,#fd,#ea
  db #f1,#49,#df,#dd,#d0,#49,#4d,#8b ;.I...IM.
  db #6f,#d2,#41,#df,#50,#f9,#ff,#a0 ;o.A.P...
  db #ff,#48,#0d,#d5,#f0,#5f,#be,#82 ;.H......
  db #8d,#b4,#20,#af,#25,#0f,#eb,#f5
  db #e1,#af,#bb,#98,#7d,#a6,#f7,#d6
  db #0e,#5a,#7a,#f2,#06,#fd,#f1,#fd ;.Zz.....
  db #0d,#eb,#bf,#a7,#0e,#fe,#3f,#d7
  db #0b,#3e,#6e,#b6,#05,#f9,#e5,#a5 ;..n.....
  db #f9,#63,#0b,#e1,#af,#be,#fb,#f1 ;.c......
  db #41,#06,#82,#81,#d7,#eb,#fd,#ec ;A.......
  db #3d,#e3,#fe,#86,#9e,#bf,#fe,#e8
  db #e7,#a7,#d5,#ff,#80,#83,#82,#88
  db #fb,#be,#eb,#ff,#d0,#0a,#10,#40
  db #d7,#01,#02,#00,#9f,#cf,#e7,#ff
  db #c0,#61,#94,#00,#8f,#ad,#fd,#ff ;.a......
  db #80,#89,#01,#04,#e1,#38,#24,#0d
  db #ff,#af,#00,#20,#fb,#e0,#61,#a0 ;......a.
  db #f8,#34,#05,#07,#d0,#81,#b4,#02
  db #cf,#8b,#e9,#fd,#c3,#04,#20,#83
lab7F10:
  db #e7,#9a,#7a,#fb,#cd,#f5,#fd,#fb ;..z.....
  db #a0,#38,#c8,#a0,#d0,#a6,#1c,#10
  db #98,#ff,#3c,#f9,#93,#fc,#9f,#f5
  db #b0,#70,#20,#91,#f8,#ff,#c9,#fb ;.p......
  db #f7,#cb,#78,#f6,#f0,#88,#20,#04 ;..x.....
  db #7f,#00,#79,#00,#03,#83,#82,#a1 ;..y.....
  db #83,#03,#a1,#10,#83,#03,#a1,#82
  db #83,#a1,#04,#83,#88,#43,#a1,#a1 ;.....C..
  db #83,#a1,#83,#43,#83,#04,#43,#86 ;...C..C.
  db #83,#43,#83,#43,#83,#83,#03,#43 ;.C.C...C
  db #88,#83,#83,#a1,#83,#52,#52,#83 ;.....RR.
  db #43,#04,#a1,#87,#52,#a1,#a1,#52 ;C...R..R
  db #52,#43,#a1,#04,#52,#81,#a1,#04 ;RC..R...
  db #52,#82,#a1,#a1,#03,#52,#07,#a1 ;R....R..
  db #84,#52,#a1,#52,#52,#07,#a1,#8a ;.R.RR...
  db #52,#52,#a1,#52,#52,#a1,#a1,#52 ;RR.RR..R
  db #a1,#52,#04,#a1,#84,#52,#a1,#52 ;.R...R.R
  db #52,#03,#a1,#83,#0b,#07,#07,#08 ;R.......
  db #0b,#03,#07,#85,#0b,#07,#0b,#0b
  db #07,#03,#0b,#88,#07,#0b,#07,#0b
  db #a1,#52,#0b,#07,#0f,#0b,#83,#07 ;.R......
  db #0b,#0b,#07,#07,#86,#0b,#07,#0b
  db #0b,#52,#0b,#03,#16,#09,#29,#83 ;.R......
  db #16,#29,#16,#06,#29,#81,#16,#04
  db #29,#84,#16,#0b,#a1,#a1,#10,#29
  db #88,#16,#29,#16,#29,#16,#29,#29
  db #16,#06,#29,#83,#07,#06,#09,#04
  db #06,#87,#09,#06,#09,#09,#06,#09
  db #06,#06,#09,#8c,#06,#09,#06,#06
  db #09,#09,#06,#06,#09,#06,#06,#09

data_SCREEN equ #8000
data_BACK_BUFFER equ #c000

org #C7D0
data_SCORE_FONTE_01:
  db #33,#cf,#9b,#67,#33,#27,#67,#27 ;...g..g.
  db #27,#67,#27,#27,#67,#27,#27,#67 ;.g..g..g
  db #27,#27,#67,#33,#27,#33,#0f,#1b ;..g.....
  db #67,#cf,#1b,#67,#33,#1b,#27,#1b ;g..g....
  db #1b,#33,#9b,#1b,#33,#9b,#1b,#67 ;.......g
  db #9b,#0f,#67,#33,#27,#27,#0f,#0f ;..g.....

org #CFD0
data_SCORE_FONTE_23:
  db #67,#cf,#9b,#67,#33,#27,#33,#0f ;g..g....
  db #27,#67,#33,#27,#67,#27,#1b,#67 ;.g..g..g
  db #67,#9b,#67,#33,#27,#27,#0f,#0f ;g.g.....
  db #67,#cf,#9b,#67,#33,#27,#27,#0f ;g..g....
  db #27,#67,#33,#1b,#27,#0f,#27,#67 ;.g.....g
  db #cf,#27,#67,#33,#27,#27,#0f,#1b ;..g.....

org #D7D0
data_SCORE_FONTE_45:
  db #33,#67,#9b,#33,#cf,#27,#67,#9b ;.g....g.
  db #27,#67,#27,#27,#67,#27,#27,#67 ;.g..g..g
  db #33,#27,#33,#0f,#27,#33,#33,#0f
  db #67,#cf,#8f,#67,#33,#27,#67,#27 ;g..g..g.
  db #1b,#67,#33,#27,#27,#0f,#27,#67 ;.g.....g
  db #cf,#27,#67,#33,#27,#27,#0f,#1b ;..g.....

org #DFD0
data_SCORE_FONTE_67:
  db #33,#cf,#8f,#67,#33,#27,#67,#27 ;...g..g.
  db #1b,#67,#33,#27,#67,#27,#27,#67 ;.g..g..g
  db #27,#27,#67,#33,#27,#33,#0f,#1b ;..g.....
  db #67,#cf,#8f,#67,#33,#27,#27,#0f ;g..g....
  db #27,#33,#cf,#27,#33,#9b,#1b,#33
  db #9b,#1b,#33,#9b,#1b,#33,#0f,#1b

org #E7D0
data_SCORE_FONTE_89:
  db #33,#cf,#9b,#67,#33,#27,#67,#27 ;...g..g.
  db #27,#67,#33,#27,#67,#27,#27,#67 ;.g..g..g
  db #27,#27,#67,#33,#27,#33,#0f,#1b ;..g.....
  db #33,#cf,#9b,#67,#33,#27,#67,#27 ;...g..g.
  db #27,#67,#27,#27,#67,#33,#27,#33 ;.g..g...
  db #0f,#27,#33,#9b,#27,#33,#0f,#1b


org #EFD0  
data_SCORE_FONTE_AB:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00  
  db #00,#00,#00,#00,#00,#00,#00,#00
 
org #F7D0  
data_SCORE_FONTE_CD:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00

org #FFD0  
data_SCORE_FONTE_EF:
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00,#00,#00
  db #00,#00,#00,#00
  db #00,#00,#00,#00,#00,#00
  db #00
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: game
  SELECT id INTO tag_uuid FROM tags WHERE name = 'game';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 102: barbapapa_lw by Tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'barbapapa_lw',
    'Imported from z80Code. Author: Tronic. Generated by Arkos Tracker 2.',
    'public',
    false,
    false,
    '2019-10-25T15:55:53.510000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Song Untitled in Lightweight format (V1).
; Generated by Arkos Tracker 2.

Untitled_Start
Untitled_StartDisarkGenerateExternalLabel

Untitled_DisarkByteRegionStart0
	db "ATLW"	; Format marker (LightWeight).
	db 1	; Format version.
Untitled_DisarkByteRegionEnd0
Untitled_DisarkPointerRegionStart1
	dw Untitled_FmInstrumentTable
	dw Untitled_ArpeggioTable
	dw Untitled_PitchTable
; Table of the Subsongs.
	dw Untitled_Subsong0
Untitled_DisarkPointerRegionEnd1

; The Arpeggio table.
Untitled_ArpeggioTable
Untitled_DisarkWordRegionStart2
	dw 0
Untitled_DisarkWordRegionEnd2
Untitled_DisarkPointerRegionStart3
Untitled_DisarkPointerRegionEnd3

; The Pitch table.
Untitled_PitchTable
Untitled_DisarkWordRegionStart4
	dw 0
Untitled_DisarkWordRegionEnd4
Untitled_DisarkPointerRegionStart5
Untitled_DisarkPointerRegionEnd5

; The FM Instrument table.
Untitled_FmInstrumentTable
Untitled_DisarkPointerRegionStart6
	dw Untitled_FmInstrument0
	dw Untitled_FmInstrument1
	dw Untitled_FmInstrument2
	dw Untitled_FmInstrument3
	dw Untitled_FmInstrument4
	dw Untitled_FmInstrument5
	dw Untitled_FmInstrument6
	dw Untitled_FmInstrument7
Untitled_DisarkPointerRegionEnd6

Untitled_DisarkByteRegionStart7
Untitled_FmInstrument0
	db 255	; Speed.

Untitled_FmInstrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart8
	dw Untitled_FmInstrument0Loop	; Loops.
Untitled_DisarkPointerRegionEnd8

Untitled_FmInstrument1
	db 2	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart9
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd9

Untitled_FmInstrument2
	db 4	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart10
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd10

Untitled_FmInstrument3
	db 5	; Speed.

	db 253	; Volume: 15.
	db 232	; Arpeggio: -12.
	dw -4	; Pitch: -4.

	db 185	; Volume: 14.
	db 232	; Arpeggio: -12.

	db 181	; Volume: 13.
	db 232	; Arpeggio: -12.

	db 177	; Volume: 12.
	db 232	; Arpeggio: -12.

	db 97	; Volume: 8.
	dw -2	; Pitch: -2.

	db 169	; Volume: 10.
	db 232	; Arpeggio: -12.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 5	; Volume: 1.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 0	; Volume: 0.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart11
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd11

Untitled_FmInstrument4
	db 2	; Speed.

	db 125	; Volume: 15.
	dw -2	; Pitch: -2.

	db 57	; Volume: 14.

	db 117	; Volume: 13.
	dw -4	; Pitch: -4.

	db 49	; Volume: 12.

	db 109	; Volume: 11.
	dw -6	; Pitch: -6.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 45	; Volume: 11.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart12
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd12

Untitled_FmInstrument5
	db 0	; Speed.

	db 248	; Volume: 15.
	db 1	; Noise.

	db 121	; Volume: 14.
	dw 150	; Pitch: 150.

	db 117	; Volume: 13.
	dw 300	; Pitch: 300.

	db 113	; Volume: 12.
	dw 400	; Pitch: 400.

	db 109	; Volume: 11.
	dw 500	; Pitch: 500.

	db 105	; Volume: 10.
	dw 600	; Pitch: 600.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart13
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd13

Untitled_FmInstrument6
	db 0	; Speed.

	db 248	; Volume: 15.
	db 1	; Noise.

	db 232	; Volume: 13.
	db 1	; Noise.

	db 216	; Volume: 11.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart14
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd14

Untitled_FmInstrument7
	db 0	; Speed.

	db 248	; Volume: 15.
	db 1	; Noise.

	db 249	; Volume: 14.
	db 1	; Arpeggio: 0.
	db 2	; Noise: 2.
	dw -10	; Pitch: -10.

	db 241	; Volume: 12.
	db 1	; Arpeggio: 0.
	db 3	; Noise: 3.
	dw -30	; Pitch: -30.

	db 216	; Volume: 11.
	db 1	; Noise.

	db 80	; Volume: 10.

	db 208	; Volume: 10.
	db 1	; Noise.

	db 200	; Volume: 9.
	db 1	; Noise.

	db 192	; Volume: 8.
	db 1	; Noise.

	db 184	; Volume: 7.
	db 1	; Noise.

	db 176	; Volume: 6.
	db 1	; Noise.

	db 168	; Volume: 5.
	db 1	; Noise.

	db 160	; Volume: 4.
	db 1	; Noise.

	db 144	; Volume: 2.
	db 1	; Noise.

	db 136	; Volume: 1.
	db 1	; Noise.

	db 4	; End the instrument.
Untitled_DisarkPointerRegionStart15
	dw Untitled_FmInstrument0Loop	; Loop to silence.
Untitled_DisarkPointerRegionEnd15

Untitled_DisarkByteRegionEnd7
Untitled_Subsong0DisarkByteRegionStart0
; Song Untitled, Subsong 0 - Subsong - in Lightweight format (V1).
; Generated by Arkos Tracker 2.

Untitled_Subsong0
	db 6	; Initial speed.

; The Linker.
; Pattern 0
Untitled_Subsong0loop
	db 7	; State byte.
	db 8	; New speed.
	db 63	; New height.
Untitled_Subsong0DisarkPointerRegionStart1
	dw Untitled_Subsong0_Track2, Untitled_Subsong0_Track0, Untitled_Subsong0_Track1
Untitled_Subsong0DisarkPointerRegionEnd1
; The tracks.

; Pattern 1
	db 1	; State byte.
Untitled_Subsong0DisarkPointerRegionStart2
	dw Untitled_Subsong0_Track5, Untitled_Subsong0_Track3, Untitled_Subsong0_Track4
Untitled_Subsong0DisarkPointerRegionEnd2
; The tracks.

; Pattern 2
	db 1	; State byte.
Untitled_Subsong0DisarkPointerRegionStart3
	dw Untitled_Subsong0_Track8, Untitled_Subsong0_Track6, Untitled_Subsong0_Track7
Untitled_Subsong0DisarkPointerRegionEnd3
; The tracks.

	db 0	; End of the subsong.
Untitled_Subsong0DisarkPointerRegionStart4
	dw Untitled_Subsong0loop
Untitled_Subsong0DisarkPointerRegionEnd4

; The Tracks.
Untitled_Subsong0_Track0
	db 228	; Note: 60.
	db 4	; New instrument: 2.
	db 129	; Volume + possible Pitch up/down.
	db 100	; Note: 60.
	db 128	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 100	; Note: 60.
	db 129	; Volume + possible Pitch up/down.
	db 41	; Note: 65.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 46	; Note: 70.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 43	; Note: 67.
	db 62	; Short wait: 1.

	db 41	; Note: 65.
	db 254	; Short wait: 4.

	db 63, 72	; Escaped note: 72.
	db 63, 74	; Escaped note: 74.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 63, 72	; Escaped note: 72.
	db 61, 6	; Long wait: 7.

	db 36	; Note: 60.
	db 100	; Note: 60.
	db 128	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 100	; Note: 60.
	db 129	; Volume + possible Pitch up/down.
	db 41	; Note: 65.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 46	; Note: 70.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 43	; Note: 67.
	db 62	; Short wait: 1.

	db 41	; Note: 65.
	db 62	; Short wait: 1.

	db 63, 72	; Escaped note: 72.
	db 63, 74	; Escaped note: 74.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 63, 72	; Escaped note: 72.
	db 62	; Short wait: 1.

	db 43	; Note: 67.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 46	; Note: 70.
	db 62	; Short wait: 1.

	db 63, 72	; Escaped note: 72.
	db 62	; Short wait: 1.

	db 41	; Note: 65.
	db 62	; Short wait: 1.


Untitled_Subsong0_Track1
	db 209	; Note: 41.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 81	; Note: 41.
	db 131	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 81	; Note: 41.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 76	; Note: 36.
	db 129	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 12	; Note: 36.
	db 12	; Note: 36.
	db 190	; Short wait: 3.

	db 81	; Note: 41.
	db 128	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 126	; Short wait: 2.

	db 15	; Note: 39.
	db 15	; Note: 39.
	db 190	; Short wait: 3.


Untitled_Subsong0_Track2
	db 216	; Note: 48.
	db 10	; New instrument: 5.
	db 132	; Volume + possible Pitch up/down.
	db 5	; Note: 29.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 216	; Note: 48.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 16	; Note: 40.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 144	; Note: 40.
	db 12	; New instrument: 6.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 16	; Note: 40.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.


Untitled_Subsong0_Track3
	db 126	; Short wait: 2.

	db 191, 74	; Escaped note: 74.
	db 4	; New instrument: 2.
	db 63, 72	; Escaped note: 72.
	db 63, 74	; Escaped note: 74.
	db 62	; Short wait: 1.

	db 63, 76	; Escaped note: 76.
	db 62	; Short wait: 1.

	db 63, 77	; Escaped note: 77.
	db 62	; Short wait: 1.

	db 63, 72	; Escaped note: 72.
	db 62	; Short wait: 1.

	db 45	; Note: 69.
	db 62	; Short wait: 1.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 38	; Note: 62.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 33	; Note: 57.
	db 126	; Short wait: 2.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 191, 73	; Escaped note: 73.
	db 2	; New instrument: 1.
	db 62	; Short wait: 1.

	db 63, 73	; Escaped note: 73.
	db 63, 73	; Escaped note: 73.
	db 126	; Short wait: 2.

	db 63, 72	; Escaped note: 72.
	db 61, 11	; Long wait: 12.

	db 216	; Note: 48.
	db 8	; New instrument: 4.
	db 131	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 131	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 131	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 131	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 24	; Note: 48.
	db 88	; Note: 48.
	db 129	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 129	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 129	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 129	; Volume + possible Pitch up/down.
	db 24	; Note: 48.
	db 88	; Note: 48.
	db 128	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 129	; Volume + possible Pitch up/down.

Untitled_Subsong0_Track4
	db 150	; Note: 46.
	db 6	; New instrument: 3.
	db 126	; Short wait: 2.

	db 22	; Note: 46.
	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 19	; Note: 43.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 17	; Note: 41.
	db 190	; Short wait: 3.


Untitled_Subsong0_Track5
	db 150	; Note: 46.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 159	; Note: 55.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 24	; Note: 48.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 157	; Note: 53.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 156	; Note: 52.
	db 14	; New instrument: 7.
	db 197	; Note: 29.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 216	; Note: 48.
	db 12	; New instrument: 6.
	db 130	; Volume + possible Pitch up/down.
	db 197	; Note: 29.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 69	; Note: 29.
	db 129	; Volume + possible Pitch up/down.
	db 216	; Note: 48.
	db 12	; New instrument: 6.
	db 130	; Volume + possible Pitch up/down.
	db 197	; Note: 29.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 216	; Note: 48.
	db 14	; New instrument: 7.
	db 130	; Volume + possible Pitch up/down.
	db 196	; Note: 28.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 216	; Note: 48.
	db 12	; New instrument: 6.
	db 130	; Volume + possible Pitch up/down.
	db 196	; Note: 28.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 68	; Note: 28.
	db 129	; Volume + possible Pitch up/down.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 216	; Note: 48.
	db 12	; New instrument: 6.
	db 128	; Volume + possible Pitch up/down.
	db 196	; Note: 28.
	db 10	; New instrument: 5.
	db 129	; Volume + possible Pitch up/down.

Untitled_Subsong0_Track6
	db 152	; Note: 48.
	db 8	; New instrument: 4.
	db 24	; Note: 48.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 24	; Note: 48.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 24	; Note: 48.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 24	; Note: 48.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 164	; Note: 60.
	db 4	; New instrument: 2.
	db 126	; Short wait: 2.

	db 36	; Note: 60.
	db 33	; Note: 57.
	db 62	; Short wait: 1.

	db 38	; Note: 62.
	db 36	; Note: 60.
	db 62	; Short wait: 1.

	db 36	; Note: 60.
	db 62	; Short wait: 1.

	db 41	; Note: 65.
	db 40	; Note: 64.
	db 62	; Short wait: 1.

	db 38	; Note: 62.
	db 36	; Note: 60.
	db 61, 26	; Long wait: 27.


Untitled_Subsong0_Track7
	db 145	; Note: 41.
	db 6	; New instrument: 3.
	db 126	; Short wait: 2.

	db 5	; Note: 29.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 5	; Note: 29.
	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 126	; Short wait: 2.

	db 17	; Note: 41.
	db 5	; Note: 29.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 5	; Note: 29.
	db 126	; Short wait: 2.

	db 5	; Note: 29.
	db 17	; Note: 41.
	db 61, 26	; Long wait: 27.


Untitled_Subsong0_Track8
	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 142	; Note: 38.
	db 14	; New instrument: 7.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 142	; Note: 38.
	db 14	; New instrument: 7.
	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 4	; Note: 28.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 142	; Note: 38.
	db 14	; New instrument: 7.
	db 24	; Note: 48.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 142	; Note: 38.
	db 14	; New instrument: 7.
	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 4	; Note: 28.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 10	; New instrument: 5.
	db 14	; Note: 38.
	db 62	; Short wait: 1.

	db 4	; Note: 28.
	db 152	; Note: 48.
	db 14	; New instrument: 7.
	db 62	; Short wait: 1.

	db 152	; Note: 48.
	db 12	; New instrument: 6.
	db 132	; Note: 28.
	db 10	; New instrument: 5.
	db 24	; Note: 48.
	db 14	; Note: 38.
	db 62	; Short wait: 1.

	db 9	; Note: 33.
	db 12	; Note: 36.
	db 61, 26	; Long wait: 27.


Untitled_Subsong0DisarkByteRegionEnd0
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
