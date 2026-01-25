-- Migration: Import z80code projects batch 7
-- Projects 13 to 14
-- Generated: 2026-01-25T21:43:30.183173

-- Project 13: cngintro#1 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'cngintro#1',
    'Imported from z80Code. Author: siko. Doesn''t work with tinyCPC',
    'public',
    false,
    false,
    '2020-06-27T11:11:07.115000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; CNG INTRO 1
; Doesn''t work on TinyCPC, because CRTC.R0=CRTC.R1=#40


run #9700

data0000 equ 0
lab000B equ #b
lab0012 equ #12
lab0035 equ #35
lab0040 equ #40
lab0080 equ #80
lab07F8 equ #7f8

lab08FF  equ #08FF
lab0F8E equ #f8e
lab191E equ #191e
lab1F22 equ #1f22
lab282E equ #282e

lab403D equ #403d

lab7F10 equ #7f10
lab7F54 equ #7f54
lab7F8C equ #7f8c
org #9000

lab9000 db #40
db #4c,#40,#4c,#40,#4c,#40,#4c,#50 ;L.L.L.LP
db #3c,#3c,#3c,#3c,#3c,#3c,#6c,#b0 ;......l.
db #78,#78,#38,#38,#78,#78,#3c,#70 ;xx..xx.p
db #70,#b4,#b0,#30,#34,#34,#34,#30 ;p.......
db #f0,#78,#6c,#10,#b0,#b0,#3c,#70 ;.xl....p
db #70,#b4,#6c,#10,#30,#30,#70,#30 ;p.l...p.
db #f0,#78,#6c,#40,#4c,#40,#4c,#70 ;.xl.L.Lp
db #70,#b4,#6c,#50,#3c,#3c,#3c,#30 ;p.lP....
db #f0,#78,#6c,#10,#78,#78,#3c,#70 ;.xl.xx.p
db #70,#34,#3c,#3c,#34,#34,#34,#30 ;p.......
db #b0,#b0,#38,#38,#b0,#b0,#78,#10 ;......x.
db #30,#30,#30,#30,#30,#30,#e4,#14
db #be,#fc,#be,#fc,#be,#fc,#ec,#b4
db #7c,#b4,#7c,#b4,#7c,#b4,#fc,#78 ;.......x
db #3c,#f8,#78,#78,#3c,#f8,#7c,#f4 ;..xx....
db #b4,#7c,#6c,#14,#b4,#7c,#f4,#b4 ;..l.....
db #f8,#3c,#ee,#50,#f8,#3c,#bc,#34 ;...P....
db #7c,#b4,#ec,#50,#7c,#b4,#7d,#78 ;...P...x
db #3c,#f8,#ec,#10,#3c,#f8,#7c,#f4
db #b4,#7c,#6c,#14,#b4,#7c,#f4,#b4 ;..l.....
db #f8,#3c,#ee,#50,#f8,#3c,#bc,#b4 ;...P....
db #7c,#b4,#ec,#50,#7c,#b4,#7d,#f0 ;...P....
db #f0,#38,#6c,#50,#f0,#38,#b4,#54 ;..lP...T
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#fc
db #fc,#fc,#fc,#fc,#fc,#fc,#fd,#7c
db #be,#fc,#3c,#3c,#3c,#3c,#7c,#7c
db #7d,#fd,#ec,#40,#4c,#40,#4c,#7c ;....L.L.
db #be,#fd,#5c,#ff,#ff,#ff,#ee,#7c
db #7d,#fd,#1c,#fc,#fc,#fc,#ff,#7c
db #be,#fd,#1c,#3c,#fc,#be,#fd,#7c
db #7d,#fd,#ee,#40,#fe,#7d,#fd,#7c
db #fc,#fc,#ff,#ff,#fc,#be,#fd
lab9100 db #3c
db #fc,#fc,#fc,#fc,#fc,#fc,#fc,#14
db #3c,#3c,#3c,#3c,#3c,#3c,#ec,#40
db #0d,#ff,#ff,#ff,#ff,#ff,#4c,#40 ;......L.
db #5f,#0f,#0f,#0f,#0f,#0f,#4c,#05 ;......L.
db #af,#40,#0d,#ff,#ff,#ff,#ee,#05
db #ff,#ff,#ff,#0f,#0f,#0f,#ee,#05
db #0f,#0f,#0f,#40,#4c,#5f,#4e,#05 ;....L.N.
db #ff,#ff,#ff,#ff,#ff,#af,#4c,#05 ;......L.
db #0f,#0f,#0f,#0f,#0f,#4a,#4c,#40 ;.....JL.
db #49,#cf,#cf,#cf,#cf,#ca,#4c,#40 ;I.....L.
db #c7,#c3,#c3,#c3,#c3,#c7,#4c,#41 ;......LA
db #cb,#40,#4c,#40,#4c,#c3,#ce,#41 ;..L.L..A
db #ce,#40,#4c,#40,#4c,#41,#ce,#41 ;..L.LA.A
db #c7,#40,#4c,#40,#4c,#c7,#c6,#40 ;..L.L...
db #c3,#cf,#cf,#cf,#cf,#cb,#4c,#40 ;......L.
db #49,#c3,#c3,#c3,#c3,#c2,#4c,#01 ;I.....L.
db #0f,#0f,#0f,#0f,#0f,#0f,#4e,#01 ;......N.
db #0b,#03,#03,#03,#03,#03,#46,#01 ;......F.
db #4e,#40,#4c,#40,#4c,#40,#4c,#01 ;N.L.L.L.
db #0f,#0f,#0f,#4a,#4c,#40,#4c,#01 ;...JL.L.
db #0b,#03,#03,#42,#4c,#40,#4c,#01 ;...BL.L.
db #4e,#40,#4c,#40,#4c,#40,#4c,#01 ;N.L.L.L.
db #46,#40,#4c,#40,#4c,#40,#4c,#15 ;F.L.L.L.
db #c3,#c3,#c3,#c3,#c3,#c3,#c6,#15
db #3f,#3f,#3f,#83,#03,#03,#46,#40 ;......F.
db #4c,#40,#1d,#c2,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#c2,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#c2,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#c2,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#6a,#4c,#40,#4c,#40 ;L..jL.L.
db #4c,#40,#4c,#40,#4c,#40,#4c,#40 ;L.L.L.L.
db #4c,#40,#4c,#40,#4c,#40,#4c,#40 ;L.L.L.L.
db #4c,#40,#4c,#40,#4c,#40,#4c,#41 ;L.L.L.LA
db #0f,#0f,#0f,#0f,#0f,#0f,#4e,#83 ;......N.
db #4b,#4b,#0b,#0b,#4b,#4b,#0f,#43 ;KK..KK.C
db #43,#87,#83,#03,#07,#07,#07,#03 ;C.......
db #c3,#4b,#4e,#01,#83,#83,#0f,#43 ;.KN....C
db #43,#87,#4e,#01,#03,#03,#43,#03 ;C.N...C.
db #c3,#4b,#4e,#40,#4c,#40,#4c,#43 ;.KN.L.LC
db #43,#87,#4e,#41,#0f,#0f,#0f,#03 ;C.NA....
db #c3,#4b,#4e,#01,#4b,#4b,#0f,#43 ;.KN.KK.C
db #43,#07,#0f,#0f,#07,#07,#07,#03 ;C.......
db #83,#83,#0b,#0b,#83,#83,#4b,#01 ;......K.
db #03,#03,#03,#03,#03,#03,#c6,#05
db #af,#cf,#af,#cf,#af,#cf,#ce,#87
db #4f,#87,#4f,#87,#4f,#87,#cf,#4b ;O.O.O..K
db #0f,#cb,#4b,#4b,#0f,#cb,#4f,#c7 ;..KK..O.
db #87,#4f,#4e,#05,#87,#4f,#c7,#87 ;.ON..O..
db #cb,#0f,#ee,#41,#cb,#0f,#8f,#07 ;...A....
db #4f,#87,#ce,#41,#4f,#87,#5f,#4b ;O..AO..K
db #0f,#cb,#ce,#01,#0f,#cb,#4f,#c7 ;......O.
db #87,#4f,#4e,#05,#87,#4f,#c7,#87 ;.ON..O..
db #cb,#0f,#ee,#41,#cb,#0f,#8f,#87 ;...A....
db #4f,#87,#ce,#41,#4f,#87,#5f,#c3 ;O..AO...
db #c3,#0b,#4e,#41,#c3,#0b,#87,#45 ;..NA...E
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#cf
db #cf,#cf,#cf,#cf,#cf,#cf,#df,#4f ;.......O
db #af,#cf,#0f,#0f,#0f,#0f,#4f,#4f ;......OO
db #5f,#df,#ce,#40,#4c,#40,#4c,#4f ;....L.LO
db #af,#df,#4d,#ff,#ff,#ff,#ee,#4f ;..M....O
db #5f,#df,#0d,#cf,#cf,#cf,#ff,#4f ;.......O
db #af,#df,#0d,#0f,#cf,#af,#df,#4f ;.......O
db #5f,#df,#ee,#40,#ef,#5f,#df,#4f ;.......O
db #cf,#cf,#ff,#ff,#cf,#af,#df,#0f
db #cf,#cf,#cf,#cf,#cf,#cf,#cf,#05
db #0f,#0f,#0f,#0f,#0f,#0f,#ce,#40
db #1c,#ff,#ff,#ff,#ff,#ff,#4c,#40 ;......L.
db #7d,#3c,#3c,#3c,#3c,#3c,#4c,#14 ;......L.
db #be,#40,#1c,#ff,#ff,#ff,#ee,#14
db #ff,#ff,#ff,#3c,#3c,#3c,#ee,#14
db #3c,#3c,#3c,#40,#4c,#7d,#6c,#14 ;....L.l.
db #ff,#ff,#ff,#ff,#ff,#be,#4c,#14 ;......L.
db #3c,#3c,#3c,#3c,#3c,#68,#4c,#40 ;.....hL.
db #58,#fc,#fc,#fc,#fc,#e8,#4c,#40 ;X.....L.
db #f4,#f0,#f0,#f0,#f0,#f4,#4c,#50 ;......LP
db #f8,#40,#4c,#40,#4c,#f0,#ec,#50 ;..L.L..P
db #ec,#40,#4c,#40,#4c,#50,#ec,#50 ;..L.LP.P
db #f4,#40,#4c,#40,#4c,#f4,#e4,#40 ;..L.L...
db #f0,#fc,#fc,#fc,#fc,#f8,#4c,#40 ;......L.
db #58,#f0,#f0,#f0,#f0,#e0,#4c,#10 ;X.....L.
db #3c,#3c,#3c,#3c,#3c,#3c,#6c,#10 ;......l.
db #38,#30,#30,#30,#30,#30,#64,#10 ;......d.
db #6c,#40,#4c,#40,#4c,#40,#4c,#10 ;l.L.L.L.
db #3c,#3c,#3c,#68,#4c,#40,#4c,#10 ;...hL.L.
db #38,#30,#30,#60,#4c,#40,#4c,#10 ;....L.L.
db #6c,#40,#4c,#40,#4c,#40,#4c,#10 ;l.L.L.L.
db #64,#40,#4c,#40,#4c,#40,#4c,#15 ;d.L.L.L.
db #f0,#f0,#f0,#f0,#f0,#f0,#e4,#15
db #3f,#3f,#3f,#b0,#30,#30,#64,#40 ;......d.
db #4c,#40,#1d,#e0,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#e0,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#e0,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#e0,#4c,#40,#4c,#40 ;L...L.L.
db #4c,#40,#1d,#6a,#4c,#40,#4c,#40 ;L..jL.L.
db #4c,#40,#4c,#40,#4c,#40,#4c,#40 ;L.L.L.L.
db #4c,#40,#4c,#40,#4c,#40,#4c,#3b ;L.L.L.L.
db #77,#f3,#b3,#e3,#b3,#f3,#7b,#3f ;w.......
db #23,#a9,#e9,#e3,#e3,#a3,#3f,#3b
db #77,#f6,#f6,#d3,#73,#f3,#f3,#3f ;w...s...
db #03,#03,#c3,#c3,#63,#a9,#b7,#3b ;....c...
db #77,#f3,#e3,#93,#73,#f3,#f3,#3f ;w...s...
db #23,#a9,#e9,#e3,#63,#a9,#b7,#33 ;....c...
db #fd,#f3,#93,#d3,#33,#f3,#f3,#3f
db #23,#a9,#e9,#e3,#e3,#a9,#3f,#37
db #a9,#a3,#b3,#f3,#d3,#03,#3f,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#33
db #f6,#f3,#b3,#f3,#33,#f3,#f3,#37
db #ab,#a9,#63,#e9,#e3,#a3,#3f,#3b ;..c.....
db #76,#f3,#b3,#f3,#b3,#f3,#7b,#37 ;v.......
db #ab,#a9,#c3,#63,#e9,#a3,#3f,#33 ;...c....
db #f6,#f3,#93,#d3,#d3,#03,#3f,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#3b
db #77,#f3,#b3,#73,#b3,#f3,#7b,#3f ;w..s....
db #23,#a9,#e3,#63,#e9,#a3,#3f,#3b ;...c....
db #76,#f3,#b3,#f3,#d3,#03,#3f,#37 ;v.......
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#3f
db #13,#57,#d6,#93,#d6,#53,#3f,#3f ;.W...S..
db #03,#03,#c3,#c3,#c3,#03,#3f,#3b
db #57,#56,#d3,#d3,#93,#53,#7b,#3f ;WV...S..
db #03,#03,#c3,#c3,#c3,#03,#3f,#3f
db #03,#03,#c3,#c3,#93,#76,#f9,#3f ;.....v..
db #03,#03,#c3,#c3,#c3,#03,#3f,#3f
db #03,#33,#f6,#f3,#c3,#03,#3f,#3f
db #03,#23,#eb,#e9,#c3,#03,#3f,#3f
db #03,#03,#c3,#c3,#93,#56,#7b,#3f ;.....V..
db #03,#03,#c3,#c3,#c3,#03,#3f,#3b
db #77,#f3,#b3,#d3,#d3,#13,#7b,#3f ;w.......
db #23,#a9,#e9,#e3,#c3,#03,#3f,#3b
db #76,#f9,#f6,#f3,#b3,#f3,#7b,#37 ;v.......
db #bb,#f6,#76,#f9,#e3,#23,#b7,#3b ;..v.....
db #77,#f3,#b3,#f3,#f3,#a3,#b7,#3f ;w.......
db #23,#a9,#e9,#e3,#e3,#a3,#b7,#33
db #f7,#f3,#b3,#f3,#b3,#f3,#f3,#3f
db #23,#a9,#e3,#63,#e9,#a3,#3f,#3b ;...c....
db #76,#f3,#e3,#e3,#b3,#f3,#7b,#37 ;v.......
db #ab,#a9,#c3,#c3,#63,#a9,#b7,#33 ;....c...
db #fd,#f3,#e3,#e3,#b3,#f3,#f3,#3f
db #23,#a9,#e3,#e3,#e3,#a3,#3f,#33
db #f6,#f3,#b3,#f3,#b3,#f3,#f3,#37
db #ab,#a9,#c3,#c3,#63,#a9,#b7,#33 ;....c...
db #f6,#f3,#b3,#f3,#e3,#a3,#b7,#37
db #ab,#a9,#c3,#c3,#c3,#03,#3f,#3b
db #76,#f3,#e3,#e3,#b3,#f3,#7b,#37 ;v.......
db #ab,#a9,#63,#e9,#e3,#a3,#b7,#37 ;..c.....
db #a3,#b3,#f3,#f3,#e3,#a3,#b7,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#33
db #f6,#f3,#d3,#d3,#73,#f3,#f3,#37 ;....s...
db #ab,#a9,#c3,#c3,#63,#a9,#b7,#33 ;....c...
db #f6,#f3,#c3,#c3,#33,#f3,#f3,#37
db #ab,#a9,#e3,#e3,#e3,#a3,#3f,#37
db #a9,#b3,#f3,#f3,#f3,#a3,#b7,#37
db #ab,#a9,#c3,#63,#e9,#a3,#b7,#37 ;...c....
db #ab,#a9,#e3,#e3,#b3,#f3,#f3,#3f
db #03,#03,#c3,#63,#e9,#a3,#b7,#37 ;...c....
db #b9,#f3,#f3,#e3,#e3,#a3,#b7,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#33
db #fd,#f3,#f3,#e3,#e3,#a3,#b7,#3f
db #23,#a9,#e3,#e3,#e3,#a3,#b7,#3b
db #77,#f3,#e3,#e3,#b3,#f3,#7b,#3f ;w.......
db #23,#a9,#e9,#e3,#e3,#a3,#3f,#33
db #fd,#f3,#b3,#f3,#f3,#a3,#b7,#3f
db #23,#a9,#e3,#e3,#c3,#03,#3f,#3b
db #77,#f3,#e3,#b3,#f3,#f3,#7b,#3f ;w.......
db #23,#a9,#e9,#e3,#e3,#23,#bd,#33
db #f7,#f3,#b3,#f3,#f3,#a3,#b7,#3f
db #23,#a9,#e9,#e3,#63,#a9,#b7,#3b ;....c...
db #76,#f3,#b3,#d3,#33,#f3,#f3,#37 ;v.......
db #ab,#a9,#c3,#63,#e9,#a3,#3f,#33 ;...c....
db #f6,#f3,#d3,#d3,#d3,#53,#7b,#37 ;.....S..
db #ab,#a9,#c3,#c3,#c3,#03,#3f,#37
db #a9,#a3,#e3,#e3,#b3,#f3,#7b,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#3f,#37
db #a9,#a3,#b3,#f3,#f3,#53,#7b,#37 ;.....S..
db #ab,#a9,#e9,#e3,#e3,#03,#3f,#37
db #a9,#a3,#e3,#b3,#f3,#f3,#b7,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#b7,#37
db #a9,#b3,#f3,#73,#f3,#a3,#b7,#37 ;...s....
db #ab,#a9,#e3,#63,#e9,#a3,#b7,#37 ;...c....
db #a9,#b3,#f3,#d3,#33,#f3,#f3,#37
db #ab,#a9,#e9,#e3,#e3,#a3,#3f,#33
db #f6,#f3,#93,#73,#b3,#f3,#f3,#37 ;...s....
db #ab,#a9,#e3,#c3,#63,#a9,#b7,#3f ;....c...
db #13,#56,#d3,#d3,#d3,#53,#3f,#37 ;.V...S..
db #ab,#a3,#c3,#c3,#63,#a9,#b7,#3f ;....c...
db #03,#13,#d6,#73,#f9,#a3,#b7,#37 ;...s....
db #a9,#a3,#e3,#c3,#c3,#03,#3f,#37
db #b9,#f7,#d3,#d3,#73,#f9,#b7,#3f ;....s...
db #03,#03,#c3,#c3,#c3,#03,#3f,#37
db #a9,#a3,#e3,#c3,#c3,#03,#3f,#37
db #ab,#a9,#e9,#c3,#c3,#03,#3f,#3f
db #03,#03,#c3,#c3,#c3,#03,#3f,#3f
db #03,#03,#c3,#c3,#c3,#03,#3f
start_9700 di
    ld (lab998A+1),sp
    call lab99D5
    ld bc,#bc40
    out (c),0
    inc b
    out (c),c
    ld bc,#bc05
    out (c),c
    inc b
    dec c
    out (c),c
    ld bc,#bc01
    ld hl,lab403D
    out (c),c
    inc b
    out (c),h
    dec b
    inc c
    out (c),c
    inc b
    out (c),l
    ld bc,#bc06
    ld hl,lab1F22
    out (c),c
    inc b
    out (c),h
    dec b
    inc c
    out (c),c
    inc b
    out (c),l
    call lab9B66
    xor a
    ld bc,lab9BE6
    call lab99F4
    ld a,#1
    ld bc,lab9C8B
    call lab99F4
    ld a,#2
    ld bc,lab9D32
    call lab99F4
lab9757 ld iy,data0000
    inc iyl
    ld a,iyl
    cp #10
    jr nz,lab977D
    ld a,iyh
    and a
    jr nz,lab977D
    ld bc,lab7F10
    ld iy,lab9E2D
lab976F dec iy
    dec c
    out (c),c
    ld a,(iy+0)
    out (c),a
    jr nz,lab976F
    inc iyh
lab977D ld (lab9757+2),iy
    ld a,iyh
    and a
    jp z,lab9860
    ld b,#f5
lab9789 in a,(c)
    rra 
    jr nc,lab9789
    ld bc,lab7F54
    ld a,iyl
    rra 
    and #3
    out (c),a
    out (c),c
    inc a
    and #3
    ld c,#5c
    out (c),a
    out (c),c
    inc a
    and #3
    ld c,#56
    out (c),a
    out (c),c
    inc a
    and #3
    ld c,#44
    out (c),a
    out (c),c
lab97B5 ld hl,#c000
lab97B8 ld ix,lab9E2D
    ld a,iyl
    rra 
    jr nc,lab97C2
    inc l
lab97C2 ld de,lab0F8E
    add hl,de
    ld a,h
    and #7
    or #c0
    ld h,a
    ex de,hl
    ld sp,lab9100
    ld iy,lab0035
lab97D4 ld a,(ix+0)
    and a
    jr nz,lab97E1
    ld ix,lab9E60
    ld a,(ix+0)
lab97E1 ld l,a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,sp
    ld a,d
    ld bc,lab08FF
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    ld a,d
    and #7
    or #c0
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    dec e
    add a,b
    ld d,a
    ldi
    ld a,d
    and #7
    or #c0
    ld d,a
    inc ix
    dec iyl
    jr nz,lab97D4
    ld iy,(lab9757+2)
    ld hl,(lab97B8+2)
    ld a,iyl
    rra 
    jr c,lab985D
    inc hl
    ld a,(hl)
    and a
    jr nz,lab985D
    ld hl,lab9E60
lab985D ld (lab97B8+2),hl
lab9860 ld hl,lab9000
lab9863 ld ix,lab9DC1
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ld b,#0
    ld c,(ix+0)
    bit 7,c
    jr z,lab987D
    dec b
lab987D add hl,bc
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,iyl
    rra 
    jr c,lab9892
    inc ix
    ld a,ixl
    cp #21
    jr nz,lab9892
    ld ix,lab9DC1
lab9892 ld (lab9863+2),ix
    ld a,h
    and #3
    or #90
    ld h,a
    ld (lab9860+1),hl
    ex de,hl
    ld hl,(lab97B5+1)
    ld bc,lab0080
    add hl,bc
    ld a,h
    and #7
    or #c0
    ld h,a
    ld c,#f
lab98AF ld b,#8
    ld a,c
    add a,#40
    ld c,a
    ld sp,lab07F8
lab98B8 ex de,hl
    ld a,h
    and #3
    or #90
    ld h,a
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    ex de,hl
    add hl,sp
    djnz lab98B8
    ld sp,lab0080
    add hl,sp
    ld a,h
    and #7
    or #c0
    ld h,a
    dec c
    jr nz,lab98AF
    xor a
    ld c,#3f
    sbc hl,sp
    ld a,h
    ld e,l
    or #f8
    ld h,a
    ld b,#8
lab98EC ld (hl),c
    inc l
    djnz lab98EC
    ld l,e
    add hl,sp
    add hl,sp
    ld a,h
    and #7
    or #c0
    ld h,a
    ld b,#8
lab98FB ld (hl),c
    inc l
    djnz lab98FB
    ld hl,(lab97B5+1)
    srl h
    rr l
    inc hl
    inc hl
    inc hl
    inc hl
    ld a,h
    and #3
    or #30
    ld h,a
    ld bc,#bc0d
    out (c),c
    inc b
    out (c),l
    dec b
    dec c
    out (c),c
    inc b
    out (c),h
    add hl,hl
    ld a,h
    xor #a0
    ld h,a
    ld (lab97B5+1),hl
    ld a,iyh
    and a
    jp z,lab9757
lab992D ld hl,lab9000
    ld a,h
    and #1
    or #90
    ld h,a
    xor #2
    ld d,a
    ld e,l
    ld a,(de)
    ld c,(hl)
    ex de,hl
    ld (de),a
    ld (hl),c
    ld c,#d
    add hl,bc
    ld (lab992D+1),hl
    ld sp,lab9E2D
    ld hl,lab9BE5
    ld a,(hl)
    and a
    jr nz,lab9951
    ld a,#4
lab9951 dec a
    ld (hl),a
    xor a
    call lab9A1C
    ld a,#1
    call lab9A1C
    ld a,#2
    call lab9A1C
    call lab9B75
    ld bc,#f40e
    out (c),c
    ld bc,#f6c0
    out (c),c
    out (c),0
    ld bc,#f792
    out (c),c
    ld bc,#f645
    out (c),c
    ld b,#f4
    in a,(c)
    rla 
    ld bc,#f782
    out (c),c
    dec b
    out (c),0
    jp c,lab9757
lab998A ld sp,data0000
    call lab9B66
    ld bc,#bc3f
    out (c),0
    inc b
    out (c),c
    ld bc,#bc05
    out (c),c
    inc b
    out (c),0
    ld bc,#bc0d
    ld a,#30
    out (c),c
    inc b
    out (c),0
    dec b
    dec c
    out (c),c
    inc b
    out (c),a
    ld bc,#bc01
    ld hl,lab282E
    out (c),c
    inc b
    out (c),h
    dec b
    inc c
    out (c),c
    inc b
    out (c),l
    ld bc,#bc06
    ld hl,lab191E
    out (c),c
    inc b
    out (c),h
    dec b
    inc c
    out (c),c
    inc b
    out (c),l
lab99D5 ld bc,lab7F8C
    out (c),c
    ld c,#11
    ld a,#54
lab99DE dec c
    out (c),c
    out (c),a
    jr nz,lab99DE
    ld hl,#c000
    ld bc,lab0040
    xor a
lab99EC ld (hl),a
    inc hl
    djnz lab99EC
    dec c
    jr nz,lab99EC
    ret 
lab99F4 ld hl,lab9BAF
    ld de,lab0012
    and a
    jr z,lab9A01
lab99FD add hl,de
    dec a
    jr nz,lab99FD
lab9A01 ld a,#3
lab9A03 ld (hl),c
    inc hl
    ld (hl),b
    inc hl
    dec a
    jr nz,lab9A03
    inc a
    ld (hl),d
    inc hl
    ld (hl),d
    inc hl
    ld (hl),a
    inc hl
    ld b,#3
lab9A13 ld (hl),a
    inc hl
    ld (hl),d
    inc hl
    ld (hl),d
    inc hl
    djnz lab9A13
    ret 
lab9A1C ld ix,lab9BAF
    ld de,lab0012
    ld c,a
    and a
    jr z,lab9A2C
    ld b,a
lab9A28 add ix,de
    djnz lab9A28
lab9A2C ld a,(lab9BE5)
    and a
    jp nz,lab9ADF
    dec (ix+8)
    jp nz,lab9ADF
    ld e,(ix+0)
    ld d,(ix+1)
lab9A3F ld a,(de)
    inc de
    cp #f0
    jr c,lab9ABD
    jr z,lab9AB9
    sub #f1
    jr nz,lab9A53
    ld e,(ix+2)
    ld d,(ix+3)
    jr lab9A3F
lab9A53 dec a
    jr nz,lab9A65
    ex de,hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (ix+4),l
    ld (ix+5),h
    add hl,de
    ex de,hl
    jr lab9A3F
lab9A65 dec a
    jr nz,lab9A70
    ld e,(ix+4)
    ld d,(ix+5)
    jr lab9A3F
lab9A70 dec a
    jr nz,lab9A7A
    ld a,(de)
    inc de
    ld (ix+7),a
    jr lab9A3F
lab9A7A dec a
    jr nz,lab9A84
    ld a,(de)
    inc de
    ld (ix+10),a
    jr lab9A3F
lab9A84 dec a
    jr nz,lab9A8E
    ld a,(de)
    inc de
    ld (ix+11),a
    jr lab9A3F
lab9A8E dec a
    jr nz,lab9AA2
    ld a,(de)
    inc de
    ld l,a
    rrca 
    rrca 
    rrca 
    rrca 
    and #f
    ld (ix+13),a
    ld (ix+14),l
    jr lab9A3F
lab9AA2 dec a
    jr nz,lab9AB9
    ld a,(de)
    inc de
    ld l,a
    rrca 
    rrca 
    rrca 
    rrca 
    and #f
    ld (ix+16),a
    ld a,l
    and #f
    ld (ix+17),a
    jr lab9A3F
lab9AB9 ld l,#0
    jr lab9AC3
lab9ABD ld l,(ix+11)
    add a,(ix+7)
lab9AC3 ld (ix+6),a
    ld (ix+9),l
    ld (ix+0),e
    ld (ix+1),d
    ld a,(ix+10)
    ld (ix+8),a
    ld a,(ix+13)
    ld (ix+12),a
    ld (ix+15),#1
lab9ADF ld a,(ix+9)
    and a
    jr z,lab9B35
    dec (ix+12)
    jr nz,lab9AF8
    add a,(ix+14)
    and #f
    ld (ix+9),a
    ld a,(ix+13)
    ld (ix+12),a
lab9AF8 ld h,(ix+15)
    ld a,(ix+6)
    ld l,#3
    dec h
    jr z,lab9B10
    add a,(ix+16)
    ld l,h
    dec h
    jr z,lab9B10
    ld a,(ix+6)
    add a,(ix+17)
lab9B10 ld (ix+15),l
    ld b,#1
lab9B15 cp #c
    jr c,lab9B1E
    inc b
    sub #c
    jr lab9B15
lab9B1E add a,a
    ld hl,data9b4e
    add a,l
    ld l,a
    jr nc,lab9B27
    inc h
lab9B27 ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    dec b
    jr z,lab9B34
lab9B2E srl h
    rr l
    djnz lab9B2E
lab9B34 ex de,hl
lab9B35 ld hl,lab9BA4
    rlc c
    add hl,bc
    rrc c
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,lab9BAC
    add hl,bc
    ld a,d
    or e
    ld a,(ix+9)
    jr nz,lab9B4C
    xor a
lab9B4C ld (hl),a
    ret 
data9b4e db #ee
db #0e,#18,#0e,#4d,#0d,#8e,#0c,#da ;...M....
db #0b,#2f,#0b,#8f,#0a,#f7,#09,#68 ;.......h
db #09,#e1,#08,#61,#08,#e9,#07 ;...a...
lab9B66 ld hl,lab9BA4
    ld b,#b
    xor a
lab9B6C ld (hl),a
    inc hl
    djnz lab9B6C
    ld a,#38
    ld (lab9BAB),a
lab9B75 ld bc,#f782
    out (c),c
    ld hl,lab9BA4
    ld de,lab000B
lab9B80 ld c,(hl)
    ld b,#f4
    out (c),d
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
    inc hl
    inc d
    dec e
    jr nz,lab9B80
    ret 
lab9BA4 db #0
db #00,#00,#00,#00,#00,#00
lab9BAB db #0
lab9BAC db #0
db #00,#00
lab9BAF db #0
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00
lab9BE5 db #0
lab9BE6 db #f5
db #01,#f6,#0b,#f7,#2f,#2e,#2b,#27
db #2d,#29,#26,#32,#2d,#29,#26,#32
db #2d,#29,#26,#32,#2d,#f2,#1a,#00
db #2b,#28,#32,#2d,#29,#26,#32,#2d
db #29,#26,#32,#2d,#29,#26,#32,#2d
db #f2,#07,#00,#f2,#35,#00,#f2,#32
db #00,#f1,#29,#26,#35,#32,#2d,#29
db #35,#32,#2d,#29,#35,#32,#2d,#29
db #35,#32,#2d,#29,#32,#2d,#29,#26
db #32,#2d,#29,#26,#32,#2d,#29,#26
db #32,#2d,#29,#26,#30,#2b,#28,#26
db #30,#2d,#28,#26,#32,#2d,#28,#24
db #30,#2b,#f3,#2e,#2b,#35,#30,#2c
db #29,#35,#30,#2c,#29,#35,#30,#2c
db #29,#35,#30,#2c,#29,#38,#35,#30
db #2c,#38,#35,#30,#2c,#38,#35,#30
db #2c,#38,#35,#30,#2c,#35,#30,#2c
db #29,#35,#30,#2c,#29,#35,#30,#2c
db #29,#35,#30,#2c,#29,#33,#2e,#2b
db #29,#33,#30,#2b,#29,#35,#30,#2b
db #27,#33,#2e,#f3
lab9C8B db #f5
db #01,#f6,#0b,#f2,#16,#00,#f2,#13
db #00,#f2,#10,#00,#f2,#0d,#00,#f2
db #4f,#00,#f2,#4c,#00,#f2,#49,#00 ;O..L..I.
db #f2,#46,#00,#f1,#1a,#1a,#1a,#1a ;.F......
db #1a,#f6,#0f,#1a,#f6,#0b,#1a,#1a
db #1a,#f6,#0f,#1a,#f6,#0b,#1a,#f6
db #0f,#1a,#f6,#0b,#1a,#1a,#1a,#f6
db #0f,#1a,#f6,#0b,#1a,#1a,#1a,#f6
db #0f,#1a,#f6,#0b,#1a,#f6,#0f,#1a
db #f6,#0b,#1a,#1a,#1a,#f6,#0f,#1a
db #f6,#0b,#1a,#1a,#1a,#f6,#0f,#1a
db #f6,#0b,#1a,#f6,#0f,#1a,#f6,#0b
db #f3,#1d,#1d,#1d,#1d,#1d,#f6,#0f
db #1d,#f6,#0b,#1d,#1d,#1d,#f6,#0f
db #1d,#f6,#0b,#1d,#f6,#0f,#1d,#f6
db #0b,#1d,#1d,#1d,#f6,#0f,#1d,#f6
db #0b,#1d,#1d,#1d,#f6,#0f,#1d,#f6
db #0b,#1d,#f6,#0f,#1d,#f6,#0b,#1d
db #1d,#1d,#f6,#0f,#1d,#f6,#0b,#1d
db #1d,#1d,#f6,#0f,#1d,#f6,#0b,#1d
db #f6,#0f,#1d,#f6,#0b,#f3
lab9D32 db #f5
db #01,#f6,#0f,#f7,#2f,#f2,#32,#00
db #f2,#1f,#00,#f2,#3d,#00,#f2,#29
db #00,#f2,#16,#00,#f2,#34,#00,#f2
db #52,#00,#f2,#3f,#00,#f2,#5d,#00 ;R.......
db #f2,#49,#00,#f2,#36,#00,#f2,#54 ;.I.....T
db #00,#f1,#35,#32,#2d,#29,#35,#32
db #2d,#29,#35,#32,#2d,#29,#35,#32
db #2d,#29,#32,#2d,#29,#26,#32,#2d
db #29,#26,#32,#2d,#29,#26,#32,#2d
db #29,#26,#f3,#30,#2b,#28,#26,#30
db #2d,#28,#26,#32,#2d,#28,#24,#30
db #2b,#28,#24,#f3,#38,#35,#30,#2c
db #38,#35,#30,#2c,#38,#35,#30,#2c
db #38,#35,#30,#2c,#35,#30,#2c,#29
db #35,#30,#2c,#29,#35,#30,#2c,#29
db #35,#30,#2c,#29,#f3,#33,#2e,#2b
db #29,#33,#30,#2b,#29,#35,#30,#2b
db #27,#33,#2e,#2b,#27,#f3
lab9DC1 db #ff
db #fd,#fb,#f9,#f7,#f5,#f7,#f9,#fb
db #fd,#ff,#01,#03,#05,#07,#09,#0b
db #09,#07,#05,#03,#01,#ff,#fd,#fb
db #f9,#f7,#f9,#fb,#fd,#ff,#01,#03
db #05,#07,#09,#07,#05,#03,#01,#ff
db #fd,#fb,#f9,#fb,#fd,#ff,#01,#03
db #05,#07,#05,#03,#01,#ff,#fd,#fb
db #fd,#ff,#01,#03,#05,#03,#01,#ff
db #fd,#fb,#f9,#fb,#fd,#ff,#01,#03
db #05,#07,#05,#03,#01,#ff,#fd,#fb
db #f9,#f7,#f9,#fb,#fd,#ff,#01,#03
db #05,#07,#09,#07,#05,#03,#01,#5c
db #4c,#4e,#4a,#44,#55,#57,#53,#56 ;LNJDUWSV
db #52,#54,#4b ;RTK
lab9E2D db #5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f
lab9E60 db #53
db #4f,#59,#45,#5a,#5f,#4c,#45,#53 ;OYEZ.LES
db #5f,#42,#49,#45,#4e,#56,#45,#4e ;.BIENVEN
db #55,#53,#5f,#41,#5f,#4c,#41,#5f ;US.A.LA.
db #50,#52,#45,#4d,#49,#45,#52,#45 ;PREMIERE
db #5f,#49,#4e,#54,#52,#4f,#5f,#44 ;.INTRO.D
db #45,#5f,#43,#4e,#47,#53,#4f,#46 ;E.CNGSOF
db #54,#3b,#5f,#5f,#5f,#43,#4f,#44 ;T....COD
db #45,#45,#5f,#4c,#45,#5f,#44,#49 ;EE.LE.DI
db #4d,#41,#4e,#43,#48,#45,#5f,#32 ;MANCHE..
db #30,#5f,#44,#45,#5f,#4a,#55,#49 ;..DE.JUI
db #4c,#4c,#45,#54,#5f,#44,#45,#5f ;LLET.DE.
db #32,#30,#30,#33,#5f,#50,#4f,#55 ;.....POU
db #52,#5f,#4c,#45,#5f,#5a,#45,#5f ;R.LE.ZE.
db #4d,#45,#45,#54,#49,#4e,#47,#5f ;MEETING.
db #32,#30,#30,#33,#3e,#3e,#3e,#5f
db #44,#4f,#4d,#4d,#41,#47,#45,#3c ;DOMMAGE.
db #5f,#4a,#45,#5f,#4e,#45,#5f,#50 ;.JE.NE.P
db #45,#55,#58,#5f,#50,#41,#53,#5f ;EUX.PAS.
db #59,#5f,#41,#4c,#4c,#45,#52,#3b ;Y.ALLER.
db #5f,#5f,#5f,#4c,#41,#5f,#49,#4e ;...LA.IN
db #54,#52,#4f,#5f,#4f,#43,#43,#55 ;TRO.OCCU
db #50,#45,#5f,#34,#4b,#5f,#45,#54 ;PE..K.ET
db #5f,#4c,#41,#5f,#4d,#55,#53,#49 ;.LA.MUSI
db #51,#55,#45,#5f,#45,#53,#54,#5f ;QUE.EST.
db #55,#4e,#45,#5f,#41,#44,#41,#50 ;UNE.ADAP
db #54,#41,#54,#49,#4f,#4e,#5f,#44 ;TATION.D
db #55,#5f,#5e,#4c,#4f,#41,#44,#45 ;U..LOADE
db #52,#54,#55,#4e,#45,#5e,#5f,#44 ;RTUNE..D
db #45,#5f,#4a,#4f,#47,#45,#49,#52 ;E.JOGEIR
db #5f,#4c,#49,#4c,#4a,#45,#44,#41 ;.LILJEDA
db #48,#4c,#3e,#5f,#5f,#5f,#41,#55 ;HL....AU
db #5f,#52,#45,#56,#4f,#49,#52,#3b ;.REVOIR.
db #5f,#3d,#43,#4e,#47,#53,#4f,#46 ;..CNGSOF
db #54,#40,#45,#4d,#55,#55,#4e,#4c ;T.EMUUNL
db #49,#4d,#3e,#43,#4f,#4d,#3d,#5f ;IM.COM..
db #5f,#5f,#5f,#5f,#5f,#5f,#00,#00

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: demo
  SELECT id INTO tag_uuid FROM tags WHERE name = 'demo';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 14: lesmondesengloutis by Tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'lesmondesengloutis',
    'Imported from z80Code. Author: Tronic. Playing "mod" with Arkos Tracker 2',
    'public',
    false,
    false,
    '2019-11-20T01:16:42.307000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '        ;Tests the MOD player, for AMSTRAD CPC.
        ;Compiles with SJasmPlus or RASM.

        ;This builds a SNApshot, handy for testing (RASM feature).
        buildsna
        bankset 0

        org #1000
        
        ld hl,#c000
		ld de,#c001
		ld bc,#3fff
		ld (hl),0
		ldir

        di
        ld hl,#c9fb
        ld (#38),hl
        ld sp,#38

        ;Initializes the music.
        ld hl,Music
        call PLY_MOD_Init

MainLoop:
        ld bc,#7f10
        out (c),c
        ld a,#4b
        out (c),a

        call PLY_MOD_Play

        ld bc,#7f10
        out (c),c
        ld a,#54
        out (c),a

        jr MainLoop

Player:
;       Arkos Tracker 2 MOD Player.
;       By Targhan/Arkos, March 2018.

;       This plays 3-channel sample music. The name of this file is a misnomer, the input format is not "MOD",
;       but the "RAW" format from AT2, with the following parameters (it is IMPORTANT to make sure they are well set):
;       ------------------------------
;       - Encode song/subsong metadatas: ON.
;       - Encode Speed Tracks: ON.
;       - Encode Event Tracks: not used, should be OFF.
;       - Encode Reference tables: ON.
;       - Encode Arpeggios: ON, unless the effect flag below is set to OFF.
;       - Encode Pitches: not used, should be OFF.
;       - Encode effects: should be ON, unless you don''t want them.
;       - Encode empty lines as RLE: OFF.
;       - Encode transpositions in linker: OFF. Transpositions are NOT supported.
;       - Encode heights in linker: ON.
;       - Pitch Track ratio: 0.25 (but this is an approximation).
;
;       Samples
;       -----------------------------
;       Some very specific tricks are used to make the replay fast. The sample export of AT2 must be configured this way:
;       - The sample MUST be encoded with an "offset" of 128.
;       - The "amplitude" should be between 8 and 10, it''s up to you to choose what is best for the song.
;       - It is strongly advised to add a "padding length" of at least "PLY_MOD_IterationCountPerFrame" + 1, else strange things will happen. Use 320 and you should be fine.

;       "Only" 128 instruments possible (small optimization).
;
;       Only the following effects are supported:
;       - Pitch up/down (not Fast).
;       - Arpeggio table.
;       - Arpeggio 3 notes.
;       - Arpeggio 4 notes.
;       - Reset.
;
;       The stack is diverted: the interruptions must be disabled.
;
;       On initialization, the song is MODIFIED to accelerate the access to data.
;       So be sure to call the init method only once!

;       Even though the replay code itself is very very fast, the song management is rather slow.
;       The export format is generic and I didn''t want to make another converter specific to this player.
;       However, I don''t think this is a problem, the music sounds good enough on a CPC.
;       On request, I could make this code convert the Patterns into another format to gain some speed.

PLY_MOD_IterationCountPerFrame: equ 312                 ;How many samples to play per frame.
;Very important value. Should be fine, but try fiddle with it according to the song (from #83-85, else it will sound like crap).
PLY_MOD_FillerByte: equ #84

PLY_MOD_InstrumentHeaderSize: equ 10                    ;How large is the Sample Instrument header.


;Initializes the music.
;IN:    HL = music.
PLY_MOD_Init:
        ;Skips the flags.
        inc hl
        inc hl
        ;Skips the song name, author, composer, comments, subsong title.
        ld b,5
PLY_MOD_Init_SkipLoop:
        call PLY_MOD_Skip0TerminatedString
        djnz PLY_MOD_Init_SkipLoop
                        
        ;Sets the speed.
        ld a,(hl)
        ld (PLY_MOD_Speed + 1),a
        dec a           ;Current speed is speed-1 to force the new line at first iteration.
        ld (PLY_MOD_CurrentSpeed + 1),a
        
        ;Skips many information, we don''t need them.
        ld de,15
        add hl,de
        ld de,PLY_MOD_PtLinker + 1
        ldi
        ldi
        ;Skips the address of the tables for the tracks, speed/event tracks.
        ld de,6
        add hl,de
        ld de,PLY_MOD_PtInstrumentTable + 1
        ldi
        ldi
        ld de,PLY_MOD_PtArpeggioTable + 1
        ldi
        ldi
        
        ;Cuts all the channels.
        ld hl,#0700 + %00111111
        call PLY_MOD_SetPsg
        ;Nice trick (c) me, to handle overflow of volume.
        ld hl,#0b01
        call PLY_MOD_SetPsg
        ld hl,#0c00
        call PLY_MOD_SetPsg
        ld hl,#0d0d     ;Ramp up and stays up.
        call PLY_MOD_SetPsg
        ;Selects the PSG volume register of the second channel.
        ;Is it important that this is the last PSG selected.
        ld hl,#0900
        call PLY_MOD_SetPsg
        
        ;Fills the RET table. One iteration is already encoded, so we can directly "LDIR" it.
        ld hl,PLY_MOD_CodeRetTable
        ld de,PLY_MOD_CodeRetTable + 2
        ld bc,(PLY_MOD_IterationCountPerFrame - 1) * 2
        ldir
        
        ;Replaces the zero-instrument with a sample instrument.
        ld hl,(PLY_MOD_PtInstrumentTable + 1)
        ld (hl),PLY_MOD_Instrument0_Header MOD 256
        inc hl
        ld (hl),(PLY_MOD_Instrument0_Header AND #ff00) / 256
        inc hl
               
        ;Reorganizes each Instrument header for the data to be faster to address.
        ex de,hl
        ld ixl,e
        ld ixh,d                ;IX = points on the Instrument table, past the 0 Instrument.
PLY_MOD_Init_ChangeInstrumentHeader_Loop:
        ld c,(ix + 0)           ;Reads the instrument address. #ffff marks the end of the list.
        ld b,(ix + 1)
        inc ix
        inc ix
        ld a,c                ;0 = Not encoded Instrument. Skip.
        or b
        jr z,PLY_MOD_Init_ChangeInstrumentHeader_Loop
        ld hl,#ffff
        or a
        sbc hl,bc
        jr z,PLY_MOD_Init_AfterChangeInstrumentHeader
        
        ;IY points on the header of the instrument.
        ld iyl,c
        ld iyh,b
        
        ld hl,PLY_MOD_InstrumentHeaderSize
        add hl,bc
        ex de,hl                ;DE = address of the sample data.
        
        ;New header:
        ;       - No more Instrument type.
        ;       dw sample data address
        ;       dw sample data end address
        ;       dw sample data loop index
        ;       dw loop? (0 = no, #ffff = yes).
        
        ld (iy + 0),e           ;Sample header + 0/1 is now the address of the beginning of the sample data.
        ld (iy + 1),d
        
        ld l,(iy + 3)           ;Reads the end index of the sample data.
        ld h,(iy + 4)
        add hl,de
        ld (iy + 2),l           ;Sample header + 2/3 is now the end address of the sample data.
        ld (iy + 3),h
        
        ld l,(iy + 5)           ;Reads the loop index of the sample data.
        ld h,(iy + 6)
        add hl,de
        ld (iy + 4),l           ;Sample header + 4/5 is now the loop address of the sample data.
        ld (iy + 5),h
        
        ld a,(iy + 7)           ;Copies the loop flag to the previous byte to get a word.
        ld (iy + 6),a
        jr PLY_MOD_Init_ChangeInstrumentHeader_Loop        
PLY_MOD_Init_AfterChangeInstrumentHeader:

        ;Simulates reading notes of Instrument 0 to set-up everything quickly.
                ld de,PLY_MOD_Channel1Data
        exx
        ld hl,PLY_MOD_InitEmptyInstrumentCell
        call PLY_MOD_ReadTrack
        
                ld de,PLY_MOD_Channel2Data
        exx
        ld hl,PLY_MOD_InitEmptyInstrumentCell
        call PLY_MOD_ReadTrack
        
                ld de,PLY_MOD_Channel3Data
        exx
        ld hl,PLY_MOD_InitEmptyInstrumentCell
        jp PLY_MOD_ReadTrack
        
PLY_MOD_InitEmptyInstrumentCell:
        db 12 * 4
        db 0            ;Instrument 0.
        db 0            ;No effect.

        
;Finds the next 0, skips it too.
;IN:    HL = Points on 0 zero-terminated string.
;OUT:   HL = Points after the first 0 found.
;MOD:   HL, A.
PLY_MOD_Skip0TerminatedString:
        ld a,(hl)
        inc hl
        or a
        ret z
        jr PLY_MOD_Skip0TerminatedString
        
        
        
        
        
;Plays one frame of the music. It must have been initialized before!
PLY_MOD_Play:
        ld (PLY_MOD_SaveSP + 1),sp

        ;Are we at the beginning of a new line?
PLY_MOD_CurrentSpeed: ld a,0
        inc a
PLY_MOD_Speed: cp 1             ;The speed to reach (>0).
        jr nz,PLY_MOD_LineEnd

        ;We must read a new line. But maybe the pattern is over!
PLY_MOD_NewLine:
        ;Is the current Pattern over?
PLY_MOD_PatternHeight: ld a,1
        dec a
        jr nz,PLY_MOD_PatternReadEnd

        ;Reads a new Pattern.
PLY_MOD_PtLinker: ld hl,0
PLY_MOD_LinkerReadTracks:
        ld c,(hl)          ;Track 1, or end if 0.
        inc hl
        ld b,(hl)
        ld a,b
        or c
        jr nz,PLY_MOD_LinkerNotEnd
        ;End of the Song. Where to go to?
        inc hl
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        ld c,(hl)
        inc hl
        ld b,(hl)
PLY_MOD_LinkerNotEnd:
        inc hl
        ld (PLY_MOD_PtTrack1 + 1),bc
        ld de,PLY_MOD_PtTrack2 + 1
        ldi
        ldi
        ld de,PLY_MOD_PtTrack3 + 1
        ldi
        ldi
        ld de,PLY_MOD_PtSpeedTrack + 1
        ldi
        ldi
        ;Gets the Track height.
        ld a,(hl)
        inc hl
        ld (PLY_MOD_PtLinker + 1),hl
PLY_MOD_PatternReadEnd:
        ld (PLY_MOD_PatternHeight + 1),a
        
        ;Reads the Speed Track.
PLY_MOD_PtSpeedTrack: ld hl,0
        ld a,(hl)
        inc hl
        ld (PLY_MOD_PtSpeedTrack + 1),hl
        or a
        jr z,PLY_MOD_ReadSpeedTrackEnd
        ld (PLY_MOD_Speed + 1),a
PLY_MOD_ReadSpeedTrackEnd:
                
        ;Reads the Track 1.
                ld de,PLY_MOD_Channel1Data
        exx
PLY_MOD_PtTrack1: ld hl,0
        call PLY_MOD_ReadTrack
        ld (PLY_MOD_PtTrack1 + 1),hl
        
        ;Reads the Track 2.
                ld de,PLY_MOD_Channel2Data
        exx
PLY_MOD_PtTrack2: ld hl,0
        call PLY_MOD_ReadTrack
        ld (PLY_MOD_PtTrack2 + 1),hl
        
        ;Reads the Track 3.
                ld de,PLY_MOD_Channel3Data
        exx
PLY_MOD_PtTrack3: ld hl,0
        call PLY_MOD_ReadTrack
        ld (PLY_MOD_PtTrack3 + 1),hl

        xor a
PLY_MOD_LineEnd:
        ld (PLY_MOD_CurrentSpeed + 1),a

        
        ;Gets the Step of each channel and puts it in the replay code.
        ;Also manages the effects for each, such as Pitch and Arpeggio.
        ld ix,PLY_MOD_Channel1Data
        call PLY_MOD_ManageArpeggio
        call PLY_MOD_ManagePitch
        ld a,l
        ld (PLY_MOD_PS_Step1Decimal + 1),a
        ld a,h
        ld (PLY_MOD_PS_Step1Integer + 1),a
        
        ld ix,PLY_MOD_Channel2Data
        call PLY_MOD_ManageArpeggio
        call PLY_MOD_ManagePitch
        ld a,l
        ld (PLY_MOD_PS_Step2Decimal + 1),a
        ld a,h
        ld (PLY_MOD_PS_Step2Integer + 1),a
        
        ld ix,PLY_MOD_Channel3Data
        call PLY_MOD_ManageArpeggio
        call PLY_MOD_ManagePitch
        ld a,l
        ld (PLY_MOD_PS_Step3Decimal + 1),a
        ld a,h
        ld (PLY_MOD_PS_Step3Integer + 1),a
        
        

        ;Plays the samples, via the RET table.
                ld hl,(PLY_MOD_Channel3Data_Sample)
PLY_MOD_BaseStep3: ld de,#00f4       ;D'' = decimal steps for sample 3.
        exx
        ld hl,(PLY_MOD_Channel1Data_Sample)
        ld de,(PLY_MOD_Channel2Data_Sample)
PLY_MOD_BaseStep12: ld bc,0         ;B/C = decimal steps for sample 1/2.
        ld sp,PLY_MOD_CodeRetTable
        ret
PLY_MOD_CodeRetReturn:
        ;Saves the Steps and sample pointers.
        ld (PLY_MOD_Channel1Data_Sample),hl
        ld (PLY_MOD_Channel2Data_Sample),de
        ld (PLY_MOD_BaseStep12 + 1),bc
        exx
                ld (PLY_MOD_Channel3Data_Sample),hl
                ld a,d
                ld (PLY_MOD_BaseStep3 + 2),a
        
        ;Manages the sample pointers advance (has a sample reached its end?), for each channel.  
        ld sp,PLY_MOD_Channel1Data
        ld iy,PLY_MOD_ManageSampleTracker1_Return
        jp PLY_MOD_ManageSamplePointers
PLY_MOD_ManageSampleTracker1_Return:

        ld sp,PLY_MOD_Channel2Data
        ld iy,PLY_MOD_ManageSampleTracker2_Return
        jp PLY_MOD_ManageSamplePointers
PLY_MOD_ManageSampleTracker2_Return:

        ld sp,PLY_MOD_Channel3Data
        ld iy,PLY_MOD_ManageSampleTracker3_Return
        jp PLY_MOD_ManageSamplePointers
PLY_MOD_ManageSampleTracker3_Return:

PLY_MOD_Exit:
PLY_MOD_SaveSP: ld sp,0
        ret

;Code that plays the samples. Called via a RET table.
;Takes 61 cycles. Try to beat diz!
;IN:    HL = sample 1.
;       DE = sample 2.
;       HL''= sample 3.
;       B = decimal step sample1.
;       C = decimal step sample2.
;       D''= decimal step sample3.
;       E''= #f4
;MOD:
;       B''= PSG.
;       C''= temp for mix.
PLY_MOD_PlaySamples:
        ;Increases the step for sample 1.
        ld a,b
PLY_MOD_PS_Step1Decimal: add a,0
        ld b,a
        ld a,l
PLY_MOD_PS_Step1Integer: adc a,0
        ld l,a
        jr nc,$ + 3
        inc h
        
        ;Increases the step for sample 2.
        ld a,c
PLY_MOD_PS_Step2Decimal: add a,0
        ld c,a
        ld a,e
PLY_MOD_PS_Step2Integer: adc a,0
        ld e,a
        jr nc,$ + 3
        inc d
        
        ;Mixes sample 1 and 2.
        ld a,(de)
        add a,(hl)
        exx
                ld c,a
        
                ;Increases the step for sample 3.
                ld a,d
PLY_MOD_PS_Step3Decimal: add a,0
                ld d,a
                ld a,l
PLY_MOD_PS_Step3Integer: adc a,0
                ld l,a
                jr nc,$ + 3
                inc h
                
                ;Mixes the whole.
                ld a,(hl)
                add a,c
                
                ld b,e
                out (c),a       ;#f400 + value.
                ld b,#f6
                out (c),a       ;#f680
                out (c),0
        exx
        ret        

;Manages the advance of each sample, make it loop if it has reached its end.
;IN:    IY = Return address.
;       SP = Channel data block.
PLY_MOD_ManageSamplePointers:
        inc sp          ;Skips the base note.
        ld (PLY_MOD_ManageSamplePointers_SaveSpAfterSteps + 1),sp
        pop hl          ;HL = current sample data pointer.
        pop de          ;DE = end sample.

        ;Have we reached the end? If no, we can quit.
        or a
        sbc hl,de
        jr c,PLY_MOD_ManageSamplePointers_End
        ;Loop (or end of sample).
        pop hl          ;HL = where to loop (if loop!)
        pop af          ;Loop. Trick: uses directly F to know if loop.
        jr nc,PLY_MOD_ManageSamplePointers_NoLoop:
        ;Loop. Encodes HL into the current sample data pointer.
PLY_MOD_ManageSamplePointers_SaveSpAfterSteps: ld sp,0
        pop bc          ;Goes after the value to set.
        push hl
PLY_MOD_ManageSamplePointers_End:
        jp (iy)
PLY_MOD_ManageSamplePointers_NoLoop:
        ;No loop: this means this sample must refer to the empty instrument.
        ;Simply replaces the datablock.
        ld hl,PLY_MOD_EmptyInstrument_DataBlock
        ld de,(PLY_MOD_ManageSamplePointers_SaveSpAfterSteps + 1)
        dec de          ;Goes back to the base note, one byte before.
        ld bc,PLY_MOD_EmptyInstrument_DataBlockEnd - PLY_MOD_EmptyInstrument_DataBlock
        ldir
        jp (iy)




;Reads the given Track.
;IN:    HL = Points on the Track to read.
;       DE''= The channel data block.
;OUT:   HL = Channel data, after the read cell.
PLY_MOD_ReadTrack:
        ;IX now also points on the channel data block, useful for the effects.
        exx
                ld ixl,e
                ld ixh,d
        exx

        ld a,(hl)
        inc hl
        cp 120
        jr z,PLY_MOD_RT_SkipInstrumentAndReadEffect
        jr c,PLY_MOD_RT_NotePresentMaybeEffect
        ;Other value? Then, nothing for this cell.                
        ret
PLY_MOD_RT_SkipInstrumentAndReadEffect:
        inc hl          ;Skips the instrument, not needed.
        jr PLY_MOD_RT_ReadEffect
PLY_MOD_RT_NotePresentMaybeEffect:
        ;add 0                  ;Transposes all the notes, if wanted. If doing this, make sure the padding of the empty sound is large enough (see at the end of the source).

        exx
                ;Stores the note.
                ld (de),a
                inc de
        exx
        ;Reads the instrument number.
        ld a,(hl)
        inc hl
        exx
                ;Gets the instrument address.
                add a,a
                ld l,a
                ld h,0
PLY_MOD_PtInstrumentTable: ld bc,0
                add hl,bc
                ld a,(hl)
                inc hl
                ld h,(hl)
                ld l,a
                
                ;Copies the sample pointer. Remember the Instrument header has been modified by the
                ;initialization code, so it does not match the RAW format anymore.
                ldi
                ldi
                ;Copies the end sample pointer.
                ldi
                ldi
                ;Copies the sample loop address pointer.
                ldi
                ldi
                ;Copies the isLoop? flag.
                ldi
                ldi
                ;Resets the current pitch
                xor a
                ld (de),a
                inc de
                ld (de),a
                ;Resets the pitch to add.
                inc de
                ld (de),a
                inc de
                ld (de),a
                ;Resets the Arpeggio index.
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex),a
        exx
PLY_MOD_RT_ReadEffect:
        ;Reads the possible effects.
        ld a,(hl)
        inc hl
        or a
        ret z           ;No effect? Exits.
        
        ;Finds the code of the effect to jump to.
        ;Warning! Effect code will be in auxiliary registers, and must put HL back on exit (or return to "normal" registers).
        ;The effect code must jump to PLY_MOD_RT_ReadEffect, on "normal" registers.
        exx
                add a,a
                add a,a
                ld l,a
                ld h,0
                ld bc,PLY_MOD_RT_EffectJumpTable
                add hl,bc
                jp (hl)
PLY_MOD_RT_ReadEffect_Skip:
        ;Skips the effect data.
        exx
        inc hl
        inc hl
        jr PLY_MOD_RT_ReadEffect
        
PLY_MOD_RT_EffectJumpTable:
        jp PLY_MOD_RT_ReadEffect_Skip           ;0: No effect.
        nop
        jp PLY_MOD_RT_ReadEffect_PitchUp        ;1: Pitch up.
        nop
        jp PLY_MOD_RT_ReadEffect_PitchDown      ;2: Pitch down.
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;3
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;4
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;5: Volume.
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;6
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;7
        nop
        jp PLY_MOD_RT_ReadEffect_ArpeggioTable  ;8: Arpeggio table.
        nop
        jp PLY_MOD_RT_ReadEffect_Arpeggio3Notes ;9: Arpeggio 3 notes.
        nop
        jp PLY_MOD_RT_ReadEffect_Arpeggio4Notes ;10: Arpeggio 4 notes.
        nop
        jp PLY_MOD_RT_ReadEffect_Reset          ;11: Reset
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;12
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;13
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;14
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;15: Fast pitch up.
        nop
        jp PLY_MOD_RT_ReadEffect_Skip           ;16: Fast pitch down.

;Pitch up.
PLY_MOD_RT_ReadEffect_PitchUp:
        ;Copies the pitch to add to the data for the channel.
        exx
        ld a,(hl)
        inc hl
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 0),a
        ld a,(hl)
        inc hl
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 1),a        
        jr PLY_MOD_RT_ReadEffect

;Pitch down.
PLY_MOD_RT_ReadEffect_PitchDown:
        ;Copies the pitch to add to the data for the channel.
        exx
 
        ld a,(hl)
        inc hl
        cpl
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 0),a
        
        ld a,(hl)
        inc hl
        cpl
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 1),a
        jp PLY_MOD_RT_ReadEffect

;Reset.        
PLY_MOD_RT_ReadEffect_Reset:
        exx
        ;Skips the value, useless.
        inc hl
        inc hl
        
        ;No more pitch to add.
        xor a
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 0),a
        ld (ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 1),a
        ;No more Arpeggio.
        ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 0),a
        ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 1),a
        jp PLY_MOD_RT_ReadEffect

;Arpeggio Table effect.
PLY_MOD_RT_ReadEffect_ArpeggioTable:
        ;Reads the Arpeggio table index.
        exx
        ld a,(hl)
        inc hl
        exx
                ld e,a
        exx
        ld a,(hl)
        inc hl
        exx
                ld d,a
                ;It is *16 by default
                srl d
                rr e
                srl d
                rr e
                srl d
                rr e
PLY_MOD_PtArpeggioTable: ld hl,0
                add hl,de
                ld a,(hl)       ;Gets the Arpeggio header.
                inc hl
                ld h,(hl)
                ld l,a
                
                inc hl          ;Skips the length.
                ld a,(hl)       ;Gets the end index.
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataEndIndex),a
                inc hl
                ld a,(hl)       ;Gets the loop index.
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataLoopIndex),a
                inc hl
                inc hl          ;Skips the speed, not used.
                ;HL points now on the the arpeggio data.
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 0),l
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 1),h
                ;The index inside the Arpeggio is 0, of course.
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex),0
        exx
        
        jp PLY_MOD_RT_ReadEffect

;Arpeggio 3 Notes effect.
PLY_MOD_RT_ReadEffect_Arpeggio3Notes:
        ;Reads the Arpeggio data (-ab-).
        exx
        
        ld a,(hl)               ;Reads "b-". "b" is on the most significant nibble.
        inc hl
        rra
        rra
        rra
        rra
        and %1111
        ld (ix + PLY_MOD_ChannelDataOffset_InlineArpeggioValue2),a

        ld a,(hl)               ;Reads "-a". The most significant nibble is 0.
        inc hl
        ld (ix + PLY_MOD_ChannelDataOffset_InlineArpeggioValue1),a
        
        ;Makes the arpeggio pointer points on the the arpeggio data.
        exx
                ld hl,PLY_MOD_ChannelDataOffset_InlineArpeggioValue0
                ld e,ixl
                ld d,ixh
                add hl,de
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 0),l
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 1),h
                
                ;The index inside the Arpeggio is 0, of course, as well as the loop index.
                xor a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex),a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataLoopIndex),a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataEndIndex),2      ;This Arpeggio has only 3 values.
        exx
        
        jp PLY_MOD_RT_ReadEffect

;Arpeggio 4 Notes effect.
PLY_MOD_RT_ReadEffect_Arpeggio4Notes:
        ;Reads the Arpeggio data (-abc).
        exx
        
        ld b,(hl)               ;Reads "bc".
        inc hl
        ld a,b
        and %1111
        ld (ix + PLY_MOD_ChannelDataOffset_InlineArpeggioValue3),a
        ld a,b
        rra
        rra
        rra
        rra
        and %1111
        ld (ix + PLY_MOD_ChannelDataOffset_InlineArpeggioValue2),a

        ld a,(hl)               ;Reads "-a". The most significant nibble is 0.
        inc hl
        ld (ix + PLY_MOD_ChannelDataOffset_InlineArpeggioValue1),a
        
        ;Makes the arpeggio pointer points on the the arpeggio data.
        exx
                ld hl,PLY_MOD_ChannelDataOffset_InlineArpeggioValue0
                ld e,ixl
                ld d,ixh
                add hl,de
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 0),l
                ld (ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 1),h
                
                ;The index inside the Arpeggio is 0, of course, as well as the loop index.
                xor a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex),a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataLoopIndex),a
                ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataEndIndex),3      ;This Arpeggio has 4 values.
        exx
        
        jp PLY_MOD_RT_ReadEffect

;Manages the Pitch effect for the channel the data block is given from.
;This updates the Current Pitch value. In return is the current step to use.
;IN:    IX = Data block of the channel.
;       A = Note to play (= should be base note + arpeggio).
;OUT:   HL = Step.
PLY_MOD_ManagePitch:
        ;Gets the Pitch to Add.
        ld e,(ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 0)
        ld d,(ix + PLY_MOD_ChannelDataOffset_PitchToAdd + 1)
     
        ;Add it to the "current pitch" (2 bytes).
        ld l,(ix + PLY_MOD_ChannelDataOffset_CurrentPitch + 0)
        ld h,(ix + PLY_MOD_ChannelDataOffset_CurrentPitch + 1)
        add hl,de
        ld (ix + PLY_MOD_ChannelDataOffset_CurrentPitch + 0),l
        ld (ix + PLY_MOD_ChannelDataOffset_CurrentPitch + 1),h
        
        ;Adds the MSB of the current pitch to the Current Step. Note that it is not modified!
        ld e,h
        ld d,0
        ;Is the pitch negative? If yes, D is #ff.
        bit 7,h
        jr z,$ + 3
        dec d
        
        ;Finds the step of the current note.
        add a,a         ;Only 7 bits, so all right.
        ld l,a
        ld h,0
        ld bc,PLY_MOD_StepsTable
        add hl,bc
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        
        add hl,de
        ret

     
;Manages the Arpeggio effect for the channel the data block is given from.
;If there is no Arpeggio, nothing happens.
;IN:    IX = Data block of the channel.
;OUT:   A = Note + Arpeggio.
PLY_MOD_ManageArpeggio:
        ;Gets the Arpeggio base. If 0, it means there is no Arpeggio.
        ld l,(ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 0)
        ld h,(ix + PLY_MOD_ChannelDataOffset_BaseArpeggioData + 1)
        ld a,l
        or h
        jr z,PLY_MOD_ManageArpeggio_Present        ;No arp. Exits, returning the base note only. Works because A = 0 if no arp!
        
        ;Gets the current index on the Arp. Has the end index been passed?
        ld a,(ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex)
        ld c,(ix + PLY_MOD_ChannelDataOffset_ArpeggioDataEndIndex)
        cp c
        jr c,PLY_MOD_ManageArpeggio_IndexOk
        ;End index passed. Gets the loop index.
        ld a,(ix + PLY_MOD_ChannelDataOffset_ArpeggioDataLoopIndex)
PLY_MOD_ManageArpeggio_IndexOk:
        ld c,a
        ld b,0
        
        ;Increases and stores the index for next time.
        inc a
        ld (ix + PLY_MOD_ChannelDataOffset_ArpeggioDataIndex),a

        add hl,bc
        ld a,(hl)               ;A is the Arpeggio value.
        
        ;Note to play = current note + Arpeggio note.
PLY_MOD_ManageArpeggio_Present:
        add a,(ix + PLY_MOD_ChannelDataOffset_BaseNote)
        ret
        

;Sends a value to a PSG register.
;IN:    H = Register.
;       L = Value.
PLY_MOD_SetPsg:
        ld b,#f4
        out (c),h
        ld bc,#f6c0
        out (c),c
        out (c),0
        ld b,#f4
        out (c),l
        ld bc,#f680
        out (c),c
        out (c),0
        ret
        
        
        




;Steps for each note, nominal octave. Calculated by ear :). Don''t worry, I''m good at that.
PLY_MOD_Step_Oct4_0: equ #0100
PLY_MOD_Step_Oct4_1: equ #0110
PLY_MOD_Step_Oct4_2: equ #0120
PLY_MOD_Step_Oct4_3: equ #0130
PLY_MOD_Step_Oct4_4: equ #0140
PLY_MOD_Step_Oct4_5: equ #015a 
PLY_MOD_Step_Oct4_6: equ #016a
PLY_MOD_Step_Oct4_7: equ #0180
PLY_MOD_Step_Oct4_8: equ #0196
PLY_MOD_Step_Oct4_9: equ #01ae
PLY_MOD_Step_Oct4_10: equ #01cb
PLY_MOD_Step_Oct4_11: equ #01e0
        
;Steps for every note.
PLY_MOD_StepsTable:
        dw PLY_MOD_Step_Oct4_0 / 128                            ;Octave 0
        dw PLY_MOD_Step_Oct4_1 / 128
        dw PLY_MOD_Step_Oct4_2 / 128
        dw PLY_MOD_Step_Oct4_3 / 128
        dw PLY_MOD_Step_Oct4_4 / 128
        dw PLY_MOD_Step_Oct4_5 / 128
        dw PLY_MOD_Step_Oct4_6 / 128
        dw PLY_MOD_Step_Oct4_7 / 128
        dw PLY_MOD_Step_Oct4_8 / 128
        dw PLY_MOD_Step_Oct4_9 / 128
        dw PLY_MOD_Step_Oct4_10 / 128
        dw PLY_MOD_Step_Oct4_11 / 128
        
        dw PLY_MOD_Step_Oct4_0 / 64                            ;Octave 1
        dw PLY_MOD_Step_Oct4_1 / 64
        dw PLY_MOD_Step_Oct4_2 / 64
        dw PLY_MOD_Step_Oct4_3 / 64
        dw PLY_MOD_Step_Oct4_4 / 64
        dw PLY_MOD_Step_Oct4_5 / 64
        dw PLY_MOD_Step_Oct4_6 / 64
        dw PLY_MOD_Step_Oct4_7 / 64
        dw PLY_MOD_Step_Oct4_8 / 64
        dw PLY_MOD_Step_Oct4_9 / 64
        dw PLY_MOD_Step_Oct4_10 / 64
        dw PLY_MOD_Step_Oct4_11 / 64
        
        dw PLY_MOD_Step_Oct4_0 / 32                            ;Octave 2
        dw PLY_MOD_Step_Oct4_1 / 32
        dw PLY_MOD_Step_Oct4_2 / 32
        dw PLY_MOD_Step_Oct4_3 / 32
        dw PLY_MOD_Step_Oct4_4 / 32
        dw PLY_MOD_Step_Oct4_5 / 32
        dw PLY_MOD_Step_Oct4_6 / 32
        dw PLY_MOD_Step_Oct4_7 / 32
        dw PLY_MOD_Step_Oct4_8 / 32
        dw PLY_MOD_Step_Oct4_9 / 32
        dw PLY_MOD_Step_Oct4_10 / 32
        dw PLY_MOD_Step_Oct4_11 / 32
        
        dw PLY_MOD_Step_Oct4_0 / 16                            ;Octave 3
        dw PLY_MOD_Step_Oct4_1 / 16
        dw PLY_MOD_Step_Oct4_2 / 16
        dw PLY_MOD_Step_Oct4_3 / 16
        dw PLY_MOD_Step_Oct4_4 / 16
        dw PLY_MOD_Step_Oct4_5 / 16
        dw PLY_MOD_Step_Oct4_6 / 16
        dw PLY_MOD_Step_Oct4_7 / 16
        dw PLY_MOD_Step_Oct4_8 / 16
        dw PLY_MOD_Step_Oct4_9 / 16
        dw PLY_MOD_Step_Oct4_10 / 16
        dw PLY_MOD_Step_Oct4_11 / 16
        
        dw PLY_MOD_Step_Oct4_0 / 8                            ;Octave 4
        dw PLY_MOD_Step_Oct4_1 / 8
        dw PLY_MOD_Step_Oct4_2 / 8
        dw PLY_MOD_Step_Oct4_3 / 8
        dw PLY_MOD_Step_Oct4_4 / 8
        dw PLY_MOD_Step_Oct4_5 / 8
        dw PLY_MOD_Step_Oct4_6 / 8
        dw PLY_MOD_Step_Oct4_7 / 8
        dw PLY_MOD_Step_Oct4_8 / 8
        dw PLY_MOD_Step_Oct4_9 / 8
        dw PLY_MOD_Step_Oct4_10 / 8
        dw PLY_MOD_Step_Oct4_11 / 8
        
        dw PLY_MOD_Step_Oct4_0 / 4                            ;Octave 5
        dw PLY_MOD_Step_Oct4_1 / 4
        dw PLY_MOD_Step_Oct4_2 / 4
        dw PLY_MOD_Step_Oct4_3 / 4
        dw PLY_MOD_Step_Oct4_4 / 4
        dw PLY_MOD_Step_Oct4_5 / 4
        dw PLY_MOD_Step_Oct4_6 / 4
        dw PLY_MOD_Step_Oct4_7 / 4
        dw PLY_MOD_Step_Oct4_8 / 4
        dw PLY_MOD_Step_Oct4_9 / 4
        dw PLY_MOD_Step_Oct4_10 / 4
        dw PLY_MOD_Step_Oct4_11 / 4
        
        dw PLY_MOD_Step_Oct4_0 / 2                            ;Octave 6
        dw PLY_MOD_Step_Oct4_1 / 2
        dw PLY_MOD_Step_Oct4_2 / 2
        dw PLY_MOD_Step_Oct4_3 / 2
        dw PLY_MOD_Step_Oct4_4 / 2
        dw PLY_MOD_Step_Oct4_5 / 2
        dw PLY_MOD_Step_Oct4_6 / 2
        dw PLY_MOD_Step_Oct4_7 / 2
        dw PLY_MOD_Step_Oct4_8 / 2
        dw PLY_MOD_Step_Oct4_9 / 2
        dw PLY_MOD_Step_Oct4_10 / 2
        dw PLY_MOD_Step_Oct4_11 / 2

        dw PLY_MOD_Step_Oct4_0                                ;Octave 7
        dw PLY_MOD_Step_Oct4_1
        dw PLY_MOD_Step_Oct4_2
        dw PLY_MOD_Step_Oct4_3
        dw PLY_MOD_Step_Oct4_4
        dw PLY_MOD_Step_Oct4_5
        dw PLY_MOD_Step_Oct4_6
        dw PLY_MOD_Step_Oct4_7
        dw PLY_MOD_Step_Oct4_8
        dw PLY_MOD_Step_Oct4_9
        dw PLY_MOD_Step_Oct4_10
        dw PLY_MOD_Step_Oct4_11

        dw PLY_MOD_Step_Oct4_0 * 2                            ;Octave 8
        dw PLY_MOD_Step_Oct4_1 * 2
        dw PLY_MOD_Step_Oct4_2 * 2
        dw PLY_MOD_Step_Oct4_3 * 2
        dw PLY_MOD_Step_Oct4_4 * 2
        dw PLY_MOD_Step_Oct4_5 * 2
        dw PLY_MOD_Step_Oct4_6 * 2
        dw PLY_MOD_Step_Oct4_7 * 2
        dw PLY_MOD_Step_Oct4_8 * 2
        dw PLY_MOD_Step_Oct4_9 * 2
        dw PLY_MOD_Step_Oct4_10 * 2
        dw PLY_MOD_Step_Oct4_11 * 2
 
        dw PLY_MOD_Step_Oct4_0 * 4                            ;Octave 9
        dw PLY_MOD_Step_Oct4_1 * 4
        dw PLY_MOD_Step_Oct4_2 * 4
        dw PLY_MOD_Step_Oct4_3 * 4
        dw PLY_MOD_Step_Oct4_4 * 4
        dw PLY_MOD_Step_Oct4_5 * 4
        dw PLY_MOD_Step_Oct4_6 * 4
        dw PLY_MOD_Step_Oct4_7 * 4
        dw PLY_MOD_Step_Oct4_8 * 4
        dw PLY_MOD_Step_Oct4_9 * 4
        dw PLY_MOD_Step_Oct4_10 * 4
        dw PLY_MOD_Step_Oct4_11 * 4

        dw PLY_MOD_Step_Oct4_0 * 8                            ;Octave 10
        dw PLY_MOD_Step_Oct4_1 * 8
        dw PLY_MOD_Step_Oct4_2 * 8
        dw PLY_MOD_Step_Oct4_3 * 8
        dw PLY_MOD_Step_Oct4_4 * 8
        dw PLY_MOD_Step_Oct4_5 * 8
        dw PLY_MOD_Step_Oct4_6 * 8
        dw PLY_MOD_Step_Oct4_7 * 8
        ;dw PLY_MOD_Step_Oct4_8 * 8
        ;dw PLY_MOD_Step_Oct4_9 * 8
        ;dw PLY_MOD_Step_Oct4_10 * 8
        ;dw PLY_MOD_Step_Oct4_11 * 8
        
        assert ($ - PLY_MOD_StepsTable) == 256

        
;The data block for the Channel 1.
PLY_MOD_Channel1Data:
PLY_MOD_Channel1Data_BaseNote: db 0     ;The base note (without arpeggio).
;This MUST match the (forged) header of an Instrument!
PLY_MOD_Channel1Data_Sample: dw 0
PLY_MOD_Channel1Data_SampleEnd: dw 0
PLY_MOD_Channel1Data_SampleLoop: dw 0
PLY_MOD_Channel1Data_IsLoop: dw 0       ;0 if no loop.
PLY_MOD_Channel1Data_PitchToAdd: dw 0   ;Pitch to add to the current pitch (as read in the Track). Does not change (unless new effect/effect stops).
PLY_MOD_Channel1Data_CurrentPitch: dw 0   ;Pitch to add to the step (integer/decimal).

PLY_MOD_Channel1Data_BaseArpeggioData: dw 0   ;0 = No arp, or points on the base of the current Arpeggio data (does not evolve, unless a new Arpeggio is used).
PLY_MOD_Channel1Data_ArpeggioDataIndex: db 0   ;The current index within the arpeggio data. Evolves.
PLY_MOD_Channel1Data_ArpeggioDataLoopIndex: db 0
PLY_MOD_Channel1Data_ArpeggioDataEndIndex: db 0
PLY_MOD_Channel1Data_InlineArpeggioValue0: db 0                 ;Value 0 for effect B/C. Always 0!
PLY_MOD_Channel1Data_InlineArpeggioValue1: db 0                 ;Value 1 for effect B/C.
PLY_MOD_Channel1Data_InlineArpeggioValue2: db 0                 ;Value 2 for effect B/C.
PLY_MOD_Channel1Data_InlineArpeggioValue3: db 0                 ;Value 3 for effect C.
PLY_MOD_Channel1DataEnd:

        ;The inline arpeggio must be in a row!
        assert (PLY_MOD_Channel1Data_InlineArpeggioValue1 - PLY_MOD_Channel1Data_InlineArpeggioValue0) == 1
        assert (PLY_MOD_Channel1Data_InlineArpeggioValue2 - PLY_MOD_Channel1Data_InlineArpeggioValue1) == 1
        assert (PLY_MOD_Channel1Data_InlineArpeggioValue3 - PLY_MOD_Channel1Data_InlineArpeggioValue2) == 1

PLY_MOD_ChannelDataSize: equ PLY_MOD_Channel1DataEnd - PLY_MOD_Channel1Data

;The data block for the Channel 2 and 3.
PLY_MOD_Channel2Data: ds PLY_MOD_ChannelDataSize, 0
PLY_MOD_Channel3Data: ds PLY_MOD_ChannelDataSize, 0

PLY_MOD_ChannelDataOffset_BaseNote: equ PLY_MOD_Channel1Data_BaseNote - PLY_MOD_Channel1Data
;PLY_MOD_ChannelDataOffset_Step: equ PLY_MOD_Channel1Data_Step - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_Sample: equ PLY_MOD_Channel1Data_Sample - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_PitchToAdd: equ PLY_MOD_Channel1Data_PitchToAdd - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_CurrentPitch: equ PLY_MOD_Channel1Data_CurrentPitch - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_BaseArpeggioData: equ PLY_MOD_Channel1Data_BaseArpeggioData - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_ArpeggioDataIndex: equ PLY_MOD_Channel1Data_ArpeggioDataIndex - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_ArpeggioDataLoopIndex: equ PLY_MOD_Channel1Data_ArpeggioDataLoopIndex - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_ArpeggioDataEndIndex: equ PLY_MOD_Channel1Data_ArpeggioDataEndIndex - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_InlineArpeggioValue0: equ PLY_MOD_Channel1Data_InlineArpeggioValue0 - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_InlineArpeggioValue1: equ PLY_MOD_Channel1Data_InlineArpeggioValue1 - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_InlineArpeggioValue2: equ PLY_MOD_Channel1Data_InlineArpeggioValue2 - PLY_MOD_Channel1Data
PLY_MOD_ChannelDataOffset_InlineArpeggioValue3: equ PLY_MOD_Channel1Data_InlineArpeggioValue3 - PLY_MOD_Channel1Data

PLY_MOD_Channel2Data_Sample: equ PLY_MOD_Channel2Data + PLY_MOD_ChannelDataOffset_Sample
PLY_MOD_Channel3Data_Sample: equ PLY_MOD_Channel3Data + PLY_MOD_ChannelDataOffset_Sample
PLY_MOD_Channel2Data_PitchToAdd: equ PLY_MOD_Channel2Data + PLY_MOD_ChannelDataOffset_PitchToAdd
PLY_MOD_Channel3Data_PitchToAdd: equ PLY_MOD_Channel3Data + PLY_MOD_ChannelDataOffset_PitchToAdd
PLY_MOD_Channel2Data_CurrentPitch: equ PLY_MOD_Channel2Data + PLY_MOD_ChannelDataOffset_CurrentPitch
PLY_MOD_Channel3Data_CurrentPitch: equ PLY_MOD_Channel3Data + PLY_MOD_ChannelDataOffset_CurrentPitch

;RET table of all the sample call.
PLY_MOD_CodeRetTable:
        dw PLY_MOD_PlaySamples
        ds (PLY_MOD_IterationCountPerFrame - 1) * 2, 0            ;-1 because we have added one already.
        dw PLY_MOD_CodeRetReturn

;The datablock to use when a sample is empty.
PLY_MOD_EmptyInstrument_DataBlock:
        db 0            ;Note = 0.
;The "empty" instrument.
PLY_MOD_Instrument0_Header:
        dw PLY_MOD_SampleEmpty
        dw PLY_MOD_SampleEmpty_End - 1
        dw PLY_MOD_SampleEmpty
        dw #ffff
PLY_MOD_Instrument0_HeaderEnd:
        dw 0              ;Pitch to add.
        dw 0              ;Current pitch.
PLY_MOD_EmptyInstrument_DataBlockEnd:
;"Empty" sample data.
PLY_MOD_SampleEmpty: ds PLY_MOD_IterationCountPerFrame, PLY_MOD_FillerByte
PLY_MOD_SampleEmpty_End
;Some padding is necessary after the "empty" sound, especially if transpositing the notes, as the "empty" note will also be transposed.
        ds PLY_MOD_IterationCountPerFrame / 2, PLY_MOD_FillerByte



        
Music:
        ;What music to play?
; Song: le mondes engloutis, Subsong: Main
; RAW format, generated by Arkos Tracker 2.

; Header
	db 183	; Flag byte 1.
	db 4	; Flag byte 2.
; Song/Subsong metadata
	db "le mondes engloutis" : db 0	; Song name.
	db 0	; Author.
	db 0	; Composer.
	db "Converted by Arkos Tracker." : db 0	; Comments.

	db "Main" : db 0	; Subsong title.
	db 6	; Initial speed.
	db 0	; Digichannel.
	db 50	; Replay rate, in Hz.

	db 3	; Channel count.
	db 1	; Psg count.
	db 24	; Length in position (>0).
	db 0	; Loop To position index (>=0).
; Psg 1
	db 64, 66, 15, 0	; PSG frequency, in Hz.
	dw 440	; Reference frequency, in Hz.
	dw 11025	; Sample player frequency, in Hz.

; Reference tables
	dw Main_Subsong0_Linker
	dw Main_Subsong0_TrackIndexes
	dw Main_Subsong0_SpeedTrackIndexes	; Speed Track indexes.
	dw 0	; Event Track indexes.
	dw Main_InstrumentIndexes	; Instrument indexes.
	dw Main_ArpeggioIndexes	; Arpeggio indexes.
	dw 0	; Pitch indexes.

; Linker
Main_Subsong0_Linker
Main_Subsong0_Loop	; Pattern 0.
	dw Main_Subsong0_Track1, Main_Subsong0_Track2, Main_Subsong0_Track3
	dw Main_Subsong0_SpeedTrack1	; Speed Track.
	db 64	; Height (>0).

; Pattern 1.
	dw Main_Subsong0_Track4, Main_Subsong0_Track5, Main_Subsong0_Track6
	dw Main_Subsong0_SpeedTrack2	; Speed Track.
	db 64	; Height (>0).

; Pattern 2.
	dw Main_Subsong0_Track7, Main_Subsong0_Track8, Main_Subsong0_Track9
	dw Main_Subsong0_SpeedTrack3	; Speed Track.
	db 64	; Height (>0).

; Pattern 3.
	dw Main_Subsong0_Track10, Main_Subsong0_Track11, Main_Subsong0_Track12
	dw Main_Subsong0_SpeedTrack4	; Speed Track.
	db 64	; Height (>0).

; Pattern 4.
	dw Main_Subsong0_Track13, Main_Subsong0_Track14, Main_Subsong0_Track15
	dw Main_Subsong0_SpeedTrack5	; Speed Track.
	db 64	; Height (>0).

; Pattern 5.
	dw Main_Subsong0_Track16, Main_Subsong0_Track17, Main_Subsong0_Track18
	dw Main_Subsong0_SpeedTrack6	; Speed Track.
	db 64	; Height (>0).

; Pattern 6.
	dw Main_Subsong0_Track7, Main_Subsong0_Track8, Main_Subsong0_Track9
	dw Main_Subsong0_SpeedTrack3	; Speed Track.
	db 64	; Height (>0).

; Pattern 7.
	dw Main_Subsong0_Track19, Main_Subsong0_Track20, Main_Subsong0_Track21
	dw Main_Subsong0_SpeedTrack7	; Speed Track.
	db 64	; Height (>0).

; Pattern 8.
	dw Main_Subsong0_Track22, Main_Subsong0_Track23, Main_Subsong0_Track24
	dw Main_Subsong0_SpeedTrack8	; Speed Track.
	db 64	; Height (>0).

; Pattern 9.
	dw Main_Subsong0_Track25, Main_Subsong0_Track26, Main_Subsong0_Track27
	dw Main_Subsong0_SpeedTrack9	; Speed Track.
	db 64	; Height (>0).

; Pattern 10.
	dw Main_Subsong0_Track28, Main_Subsong0_Track29, Main_Subsong0_Track30
	dw Main_Subsong0_SpeedTrack10	; Speed Track.
	db 64	; Height (>0).

; Pattern 11.
	dw Main_Subsong0_Track31, Main_Subsong0_Track32, Main_Subsong0_Track33
	dw Main_Subsong0_SpeedTrack11	; Speed Track.
	db 64	; Height (>0).

; Pattern 12.
	dw Main_Subsong0_Track34, Main_Subsong0_Track35, Main_Subsong0_Track36
	dw Main_Subsong0_SpeedTrack12	; Speed Track.
	db 64	; Height (>0).

; Pattern 13.
	dw Main_Subsong0_Track37, Main_Subsong0_Track38, Main_Subsong0_Track39
	dw Main_Subsong0_SpeedTrack13	; Speed Track.
	db 64	; Height (>0).

; Pattern 14.
	dw Main_Subsong0_Track40, Main_Subsong0_Track41, Main_Subsong0_Track42
	dw Main_Subsong0_SpeedTrack14	; Speed Track.
	db 64	; Height (>0).

; Pattern 15.
	dw Main_Subsong0_Track43, Main_Subsong0_Track44, Main_Subsong0_Track45
	dw Main_Subsong0_SpeedTrack15	; Speed Track.
	db 64	; Height (>0).

; Pattern 16.
	dw Main_Subsong0_Track46, Main_Subsong0_Track47, Main_Subsong0_Track48
	dw Main_Subsong0_SpeedTrack16	; Speed Track.
	db 64	; Height (>0).

; Pattern 17.
	dw Main_Subsong0_Track49, Main_Subsong0_Track50, Main_Subsong0_Track51
	dw Main_Subsong0_SpeedTrack17	; Speed Track.
	db 64	; Height (>0).

; Pattern 18.
	dw Main_Subsong0_Track52, Main_Subsong0_Track53, Main_Subsong0_Track54
	dw Main_Subsong0_SpeedTrack18	; Speed Track.
	db 64	; Height (>0).

; Pattern 19.
	dw Main_Subsong0_Track55, Main_Subsong0_Track56, Main_Subsong0_Track57
	dw Main_Subsong0_SpeedTrack19	; Speed Track.
	db 64	; Height (>0).

; Pattern 20.
	dw Main_Subsong0_Track22, Main_Subsong0_Track23, Main_Subsong0_Track24
	dw Main_Subsong0_SpeedTrack8	; Speed Track.
	db 64	; Height (>0).

; Pattern 21.
	dw Main_Subsong0_Track25, Main_Subsong0_Track26, Main_Subsong0_Track27
	dw Main_Subsong0_SpeedTrack9	; Speed Track.
	db 64	; Height (>0).

; Pattern 22.
	dw Main_Subsong0_Track28, Main_Subsong0_Track29, Main_Subsong0_Track30
	dw Main_Subsong0_SpeedTrack10	; Speed Track.
	db 64	; Height (>0).

; Pattern 23.
	dw Main_Subsong0_Track31, Main_Subsong0_Track32, Main_Subsong0_Track33
	dw Main_Subsong0_SpeedTrack11	; Speed Track.
	db 64	; Height (>0).

	dw 0, Main_Subsong0_Loop	; End of Linker, with the loop.

; Track index table
Main_Subsong0_TrackIndexes
	dw 0
	dw Main_Subsong0_Track1
	dw Main_Subsong0_Track2
	dw Main_Subsong0_Track3
	dw Main_Subsong0_Track4
	dw Main_Subsong0_Track5
	dw Main_Subsong0_Track6
	dw Main_Subsong0_Track7
	dw Main_Subsong0_Track8
	dw Main_Subsong0_Track9
	dw Main_Subsong0_Track10
	dw Main_Subsong0_Track11
	dw Main_Subsong0_Track12
	dw Main_Subsong0_Track13
	dw Main_Subsong0_Track14
	dw Main_Subsong0_Track15
	dw Main_Subsong0_Track16
	dw Main_Subsong0_Track17
	dw Main_Subsong0_Track18
	dw Main_Subsong0_Track19
	dw Main_Subsong0_Track20
	dw Main_Subsong0_Track21
	dw Main_Subsong0_Track22
	dw Main_Subsong0_Track23
	dw Main_Subsong0_Track24
	dw Main_Subsong0_Track25
	dw Main_Subsong0_Track26
	dw Main_Subsong0_Track27
	dw Main_Subsong0_Track28
	dw Main_Subsong0_Track29
	dw Main_Subsong0_Track30
	dw Main_Subsong0_Track31
	dw Main_Subsong0_Track32
	dw Main_Subsong0_Track33
	dw Main_Subsong0_Track34
	dw Main_Subsong0_Track35
	dw Main_Subsong0_Track36
	dw Main_Subsong0_Track37
	dw Main_Subsong0_Track38
	dw Main_Subsong0_Track39
	dw Main_Subsong0_Track40
	dw Main_Subsong0_Track41
	dw Main_Subsong0_Track42
	dw Main_Subsong0_Track43
	dw Main_Subsong0_Track44
	dw Main_Subsong0_Track45
	dw Main_Subsong0_Track46
	dw Main_Subsong0_Track47
	dw Main_Subsong0_Track48
	dw Main_Subsong0_Track49
	dw Main_Subsong0_Track50
	dw Main_Subsong0_Track51
	dw Main_Subsong0_Track52
	dw Main_Subsong0_Track53
	dw Main_Subsong0_Track54
	dw Main_Subsong0_Track55
	dw Main_Subsong0_Track56
	dw Main_Subsong0_Track57
	dw 65535	; End marker.

; SpeedTrack index table
Main_Subsong0_SpeedTrackIndexes
	dw 0
	dw Main_Subsong0_SpeedTrack1
	dw Main_Subsong0_SpeedTrack2
	dw Main_Subsong0_SpeedTrack3
	dw Main_Subsong0_SpeedTrack4
	dw Main_Subsong0_SpeedTrack5
	dw Main_Subsong0_SpeedTrack6
	dw Main_Subsong0_SpeedTrack7
	dw Main_Subsong0_SpeedTrack8
	dw Main_Subsong0_SpeedTrack9
	dw Main_Subsong0_SpeedTrack10
	dw Main_Subsong0_SpeedTrack11
	dw Main_Subsong0_SpeedTrack12
	dw Main_Subsong0_SpeedTrack13
	dw Main_Subsong0_SpeedTrack14
	dw Main_Subsong0_SpeedTrack15
	dw Main_Subsong0_SpeedTrack16
	dw Main_Subsong0_SpeedTrack17
	dw Main_Subsong0_SpeedTrack18
	dw Main_Subsong0_SpeedTrack19
	dw 65535	; End marker.

; EventTrack index table
Main_Subsong0_EventTrackIndexes
	dw 65535	; End marker.

; Tracks
Main_Subsong0_Track1
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track2
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track3
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track4
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track5
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track6
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track7
	db 63	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 73	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 80	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track8
	db 75	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 70	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track9
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track10
	db 60	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track11
	db 72	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track12
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track13
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track14
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track15
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track16
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track17
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track18
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track19
	db 60	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 71	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track20
	db 72	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track21
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track22
	db 75	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 85	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 85	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 92	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 92	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track23
	db 82	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 120	; No note.
	db 0	; No instrument.
	db 5	; Effect number: 5
	dw 0	; Effect value: 0
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track24
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track25
	db 74	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 84	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 84	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 91	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 91	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 91	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track26
	db 78	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track27
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track28
	db 75	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 85	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 85	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 92	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 92	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 94	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track29
	db 82	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 78	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track30
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track31
	db 74	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 84	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 84	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 91	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 89	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 91	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 87	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 86	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track32
	db 78	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 78	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track33
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track34
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track35
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track36
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track37
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track38
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track39
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track40
	db 63	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 73	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 80	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track41
	db 75	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 70	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track42
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track43
	db 60	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track44
	db 72	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track45
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track46
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track47
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track48
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track49
	db 67	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 67	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 65	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

Main_Subsong0_Track50
	db 79	; Note.
	db 4	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 81	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track51
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track52
	db 63	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 73	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 63	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 80	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 82	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track53
	db 75	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 77	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 70	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track54
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track55
	db 60	; Note.
	db 5	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 70	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 60	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 62	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 77	; Note.
	db 5	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track56
	db 72	; Note.
	db 2	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 72	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 74	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 75	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 2	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 81	; Note.
	db 4	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

Main_Subsong0_Track57
	db 79	; Note.
	db 3	; Instrument.
	db 5	; Effect number: 5
	dw 3840	; Effect value: 3840
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 3	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.
	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

	db 79	; Note.
	db 6	; Instrument.
	db 0	; End of effects.

	db 128	; One empty cell.

; SpeedTracks
Main_Subsong0_SpeedTrack1
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack2
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack3
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack4
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack5
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack6
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack7
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack8
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack9
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack10
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack11
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack12
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack13
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack14
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack15
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack16
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack17
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack18
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

Main_Subsong0_SpeedTrack19
	db 4
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0
	db 0

; Arpeggio index table
Main_ArpeggioIndexes
	dw Main_Subsong0_Arpeggio0
	dw 65535	; End marker.

; Arpeggios
Main_Subsong0_Arpeggio0
	db 1	; Length.
	db 0	; End index.
	db 0	; Start loop index.
	db 0	; Speed (>=0).

	db 0

; Instrument index table
Main_InstrumentIndexes
	dw Main_Instrument0
	dw 0
	dw Main_Instrument2
	dw Main_Instrument3
	dw Main_Instrument4
	dw Main_Instrument5
	dw Main_Instrument6
	dw 65535	; End marker.

; Instruments
Main_Instrument0
	db 0	; Instrument type (FM).
	db 1	; Length.
	db 0	; End index.
	db 0	; Loop start index.
	db 1	; Loop?
	db 255	; Speed.
	db 0	; Retrig?

; Cell 0
	db 5	; Link: NoSoftwareNoHardware.
	db 0	; Volume (0-15).
	db 0	; Noise (0-31).
	dw 0	; Software period (0 for auto).
	dw 0	; Software pitch.
	db 0	; Software arpeggio.
	db 4	; Ratio (0-7).
	db 8	; Hardware envelope (8-15).
	dw 0	; Hardware period (0 for auto).
	dw 0	; Hardware pitch.
	db 0	; Hardware arpeggio.
	db 0	; Retrig?

Main_Instrument2
	db 1	; Instrument type (Sample).
	dw 9972	; Length (including padding).
	dw 9651	; End index.
	dw 0	; Loop start index.
	db 0	; Loop?
	db 7	; Amplitude (8 bits) - 1.
	db 128	; Offset added to the each value.

; The sample data.
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132
	db 132, 132, 132, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 130
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 133, 132, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 130, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 132, 132, 132, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 130, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 133, 133, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 130, 130, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 132, 132, 133, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 130, 130, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 133, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 131, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130
	db 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 130, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130
	db 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 134
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 129, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 133
	db 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 130, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 133, 132, 133, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 132, 133, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132
	db 133, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 133, 133, 133, 134, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 130
	db 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 133, 132, 134, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 132, 133, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 131, 130, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133
	db 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 130, 130, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130
	db 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129
	db 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 134, 134, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 134, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 129, 130, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 134, 133, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130
	db 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133
	db 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 130, 129, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 133, 134, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 130
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133, 133, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 133, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 130, 131, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 134, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 133, 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130
	db 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 133, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 132, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131
	db 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131
	db 131, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131
	db 132, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 131, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 131, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 132, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 133, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 133, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 131, 132, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 132, 131, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 131, 130, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 133, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 131, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131
	db 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131
	db 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 132, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 130, 130, 131, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 132
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 130, 130, 131, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 132, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 131, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 132, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 131, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 132
	db 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 132, 132, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 131, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 130, 130, 131, 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 132, 132, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 131, 131, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 132, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 132, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131
	db 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 132
	db 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 133, 133, 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 131, 132
	db 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132
	db 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131
	db 132, 132, 132, 131, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 132
	db 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132
	db 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132
	db 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 132, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 130, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133
	db 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 131, 133, 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131
	db 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 133, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133, 132, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 133, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 130, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131
	db 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 130, 130, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132
	db 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130
	db 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 129, 130, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 132, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 129, 130
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 134, 133, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131
	db 130, 130, 130, 130, 130, 130, 130, 130, 132, 132, 132, 132, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128

Main_Instrument3
	db 1	; Instrument type (Sample).
	dw 1920	; Length (including padding).
	dw 1599	; End index.
	dw 0	; Loop start index.
	db 0	; Loop?
	db 7	; Amplitude (8 bits) - 1.
	db 128	; Offset added to the each value.

; The sample data.
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 131, 129, 131, 133, 130, 131, 134, 133, 129
	db 129, 130, 133, 133, 132, 132, 131, 131, 133, 132, 130, 130, 132, 132, 130, 131, 132, 131, 131, 130
	db 131, 133, 132, 129, 130, 133, 133, 131, 130, 131, 132, 132, 132, 131, 130, 134, 135, 132, 131, 135
	db 135, 135, 135, 135, 133, 133, 132, 133, 132, 132, 134, 135, 135, 135, 135, 134, 135, 135, 135, 133
	db 135, 135, 135, 135, 135, 133, 133, 132, 131, 133, 135, 133, 135, 133, 132, 129, 129, 130, 130, 131
	db 131, 131, 130, 128, 128, 128, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 129, 128, 128, 129, 129, 129, 130, 131, 133, 134, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 133, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 129, 129, 129, 129, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 129, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 134, 134, 134, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 134, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130
	db 129, 129, 129, 129, 129, 129, 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 129, 129, 129, 130, 130, 131, 132, 133, 133, 134, 133, 134, 134, 134, 134, 133, 133
	db 134, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 134, 134, 134, 134, 134, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130
	db 130, 130, 130, 131, 130, 129, 130, 130, 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 129, 129, 129
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129
	db 129, 129, 129, 129, 129, 129, 129, 129, 129, 130, 130, 130, 130, 129, 129, 130, 130, 129, 129, 129
	db 129, 129, 129, 129, 130, 130, 130, 130, 130, 130, 131, 131, 130, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 133, 133, 133, 133, 134, 134, 133, 134
	db 134, 134, 134, 134, 134, 133, 133, 133, 133, 134, 134, 134, 134, 134, 135, 134, 134, 134, 134, 134
	db 134, 134, 134, 134, 134, 134, 134, 133, 133, 133, 133, 134, 134, 134, 134, 134, 134, 134, 134, 134
	db 134, 134, 134, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 132, 131, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 129, 129, 129
	db 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129
	db 129, 129, 129, 129, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130
	db 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 131
	db 131, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 131, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128

Main_Instrument4
	db 1	; Instrument type (Sample).
	dw 9972	; Length (including padding).
	dw 8843	; End index.
	dw 3644	; Loop start index.
	db 1	; Loop?
	db 7	; Amplitude (8 bits) - 1.
	db 128	; Offset added to the each value.

; The sample data.
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132
	db 132, 132, 132, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 130
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 133, 132, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 130, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 132, 132, 132, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 130, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 133, 133, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 130, 130, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 132, 132, 133, 133, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 131, 131, 130, 130, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 133, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 131, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130
	db 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 130, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130
	db 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 134
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 129, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 133
	db 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 130, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 133, 132, 133, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 132, 133, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132
	db 133, 132, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 133, 133, 133, 134, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 130
	db 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 133, 132, 134, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 130, 131, 129, 130, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 132, 133, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 131, 130, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133
	db 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 130, 130, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130
	db 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129
	db 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 134, 134, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 134, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 129, 130, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 134, 133, 133, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 134, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 131, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130
	db 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 134, 133, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 129, 130, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 132, 133, 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 131, 130, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133
	db 134, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 130, 129, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 133, 134, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 130
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 133, 133, 133, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 133, 132, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 130, 131, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 129, 130, 130, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 134, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 134
	db 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 134, 133, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 133, 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130
	db 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130
	db 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 133, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 132, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131
	db 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131
	db 131, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132
	db 132, 131, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132
	db 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131
	db 132, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 131, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 131, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 132, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 133, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 133, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 131, 132, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 132, 131, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 131, 130, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 133, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 131, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131
	db 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 132, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131
	db 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 132, 131, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 132, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 130, 130, 131, 132, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 132
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 130, 130, 131, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 131
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 132, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 132, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 131, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 132, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 131, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 132, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 132
	db 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 130, 132, 132, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 133, 131, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 130, 130, 131, 130, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 132, 132, 132, 131, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 131, 131, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 132, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131, 132, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131, 131, 131, 131
	db 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 132
	db 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 133, 133, 132, 132, 132, 132, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131
	db 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 131, 132
	db 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 132, 132, 132, 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132
	db 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131
	db 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131
	db 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131
	db 132, 132, 132, 131, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 132
	db 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 131, 132, 132, 132, 132
	db 132, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132
	db 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131, 131, 131, 132, 131, 131, 131, 130
	db 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 130, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 132, 133
	db 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 132, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 130, 131, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 131, 133
	db 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130
	db 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131
	db 131, 131, 133, 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131
	db 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 132, 133, 133, 133
	db 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 130, 131, 131, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 131, 131, 133, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 130

Main_Instrument5
	db 1	; Instrument type (Sample).
	dw 8420	; Length (including padding).
	dw 8099	; End index.
	dw 0	; Loop start index.
	db 0	; Loop?
	db 7	; Amplitude (8 bits) - 1.
	db 128	; Offset added to the each value.

; The sample data.
	db 132, 132, 132, 132, 128, 128, 130, 130, 131, 131, 132, 132, 133, 133, 134, 134, 134, 134, 133, 133
	db 133, 133, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 134, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 134, 134, 134, 134, 134, 133, 133, 132, 132, 132, 133, 132, 132, 133, 133, 132, 133
	db 134, 133, 133, 133, 133, 133, 133, 134, 133, 132, 133, 133, 132, 132, 133, 132, 131, 132, 132, 131
	db 131, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 130, 131, 130, 130, 130, 130, 130, 129, 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 129, 129, 130, 130, 130, 130, 130, 130, 131, 131, 132, 131, 131
	db 131, 132, 132, 131, 131, 130, 130, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 130, 131, 131, 131, 131, 133, 132, 131, 132, 132, 132, 133, 133, 133, 132, 133, 133, 133, 133, 134
	db 133, 132, 133, 133, 133, 133, 135, 134, 132, 134, 135, 134, 134, 135, 135, 134, 135, 134, 134, 134
	db 135, 135, 134, 134, 134, 134, 133, 133, 133, 133, 134, 134, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 130, 130, 129, 129, 129, 129, 129
	db 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 130, 130, 129, 130
	db 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 131, 131, 131, 132, 130, 131, 131, 131, 129
	db 130, 131, 129, 130, 130, 130, 130, 131, 131, 130, 130, 131, 132, 131, 132, 133, 131, 132, 133, 134
	db 132, 133, 134, 132, 132, 134, 134, 133, 133, 133, 133, 133, 134, 134, 134, 134, 134, 134, 133, 135
	db 135, 134, 134, 135, 134, 134, 134, 134, 134, 134, 135, 135, 134, 134, 134, 133, 133, 134, 134, 133
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131
	db 131, 130, 130, 129, 129, 129, 129, 129, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 129, 129, 129, 130, 130, 130, 131, 131, 130, 131, 132, 132, 132, 132, 131, 131, 131
	db 132, 131, 131, 131, 131, 130, 130, 131, 130, 129, 130, 130, 129, 130, 131, 130, 129, 131, 131, 130
	db 131, 132, 132, 131, 132, 132, 132, 133, 133, 132, 132, 133, 134, 133, 133, 134, 133, 132, 133, 133
	db 133, 134, 134, 133, 133, 134, 134, 134, 134, 135, 135, 135, 135, 134, 134, 134, 135, 135, 135, 135
	db 134, 134, 134, 134, 133, 134, 134, 133, 132, 133, 133, 133, 133, 133, 132, 132, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 132, 132, 132, 131, 130, 130, 129, 129, 128, 129, 129, 129, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 130, 130, 131
	db 131, 131, 132, 132, 131, 131, 132, 132, 131, 131, 132, 131, 130, 131, 131, 130, 130, 130, 130, 130
	db 130, 130, 129, 130, 131, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 133, 133, 132, 132
	db 133, 133, 133, 133, 132, 133, 133, 133, 133, 134, 134, 133, 133, 133, 134, 134, 134, 135, 135, 134
	db 134, 134, 134, 135, 135, 135, 135, 135, 134, 134, 134, 134, 134, 133, 133, 133, 133, 133, 133, 133
	db 133, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 133, 132, 132, 131, 130, 129
	db 129, 129, 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 129, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 131, 132, 131, 131, 131
	db 131, 130, 131, 131, 130, 129, 130, 130, 130, 129, 130, 130, 130, 130, 130, 130, 131, 132, 131, 131
	db 132, 132, 132, 132, 132, 133, 133, 133, 132, 133, 133, 133, 133, 133, 133, 132, 133, 134, 134, 133
	db 133, 133, 134, 134, 135, 135, 134, 134, 134, 134, 134, 135, 135, 135, 134, 135, 135, 134, 134, 134
	db 133, 133, 133, 133, 133, 133, 133, 132, 133, 133, 133, 132, 133, 133, 133, 133, 133, 133, 132, 133
	db 133, 133, 133, 133, 132, 131, 130, 131, 130, 129, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 130, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 130, 130, 130, 130, 129, 130, 129, 130, 130, 130
	db 130, 130, 130, 130, 130, 131, 132, 132, 131, 132, 132, 132, 132, 133, 133, 132, 133, 133, 133, 133
	db 133, 132, 133, 133, 134, 134, 133, 133, 133, 133, 133, 135, 135, 134, 134, 134, 134, 134, 135, 135
	db 135, 135, 135, 135, 135, 135, 134, 134, 134, 134, 133, 133, 133, 133, 132, 133, 133, 132, 132, 133
	db 133, 132, 133, 133, 133, 133, 133, 133, 133, 133, 134, 133, 132, 132, 131, 131, 130, 130, 129, 129
	db 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129
	db 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130
	db 130, 130, 130, 129, 129, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 132, 131, 132, 132, 132
	db 133, 132, 132, 133, 133, 133, 133, 133, 132, 132, 133, 133, 133, 134, 133, 132, 132, 133, 134, 134
	db 134, 134, 134, 134, 135, 135, 134, 135, 135, 135, 135, 135, 135, 134, 134, 134, 134, 133, 134, 133
	db 132, 132, 133, 133, 132, 132, 132, 132, 132, 133, 133, 132, 133, 133, 133, 133, 134, 134, 133, 133
	db 132, 132, 132, 132, 131, 130, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 129, 129, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 129, 129, 130, 130, 129, 130, 131
	db 130, 130, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 133, 133, 133
	db 134, 133, 132, 133, 133, 133, 134, 134, 134, 134, 134, 135, 134, 134, 135, 135, 135, 135, 135, 135
	db 134, 135, 135, 134, 134, 134, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 133, 133, 133, 132
	db 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 130, 130, 130, 129, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130
	db 130, 129, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 132, 132, 131, 132, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 132, 133, 133, 133, 132, 133, 134, 133, 134, 134, 134, 134
	db 134, 135, 135, 135, 135, 135, 135, 135, 135, 134, 135, 135, 134, 133, 134, 133, 133, 133, 133, 132
	db 132, 132, 132, 132, 132, 133, 132, 132, 133, 133, 133, 133, 133, 133, 134, 134, 133, 133, 133, 132
	db 131, 131, 131, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 129, 129, 129, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 131, 131, 131, 130, 130, 130, 129, 130, 130, 129, 129, 130, 130, 129, 129, 130, 130, 130, 131, 132
	db 131, 131, 132, 132, 132, 133, 133, 133, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 134, 134, 134, 134, 134, 134, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 134
	db 134, 134, 134, 134, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 134, 134, 134, 133, 133, 133, 132, 132, 131, 131, 130, 129, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 130, 130, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130
	db 130, 130, 129, 130, 130, 131, 131, 131, 131, 131, 131, 132, 133, 133, 132, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 133, 133, 134, 134, 133, 133, 134, 134, 134, 135, 135
	db 135, 135, 135, 135, 135, 134, 134, 134, 134, 134, 134, 133, 133, 133, 132, 132, 132, 132, 132, 131
	db 132, 132, 132, 132, 133, 132, 132, 133, 133, 133, 134, 134, 133, 133, 133, 133, 132, 132, 131, 131
	db 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 129, 129, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 131
	db 131, 130, 130, 130, 130, 130, 130, 130, 130, 129, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 133, 133
	db 133, 133, 133, 134, 134, 134, 134, 134, 134, 135, 135, 135, 135, 134, 134, 134, 134, 134, 134, 133
	db 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 132, 131, 131, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 133, 133, 132
	db 133, 133, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 134, 133, 133, 134, 134, 134, 135, 135
	db 134, 134, 134, 134, 134, 134, 134, 133, 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 130, 130, 129
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 130, 130
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 130, 130, 131, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 133, 133, 132, 133, 133, 133, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 133, 133, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 134, 133, 133, 133, 133, 132
	db 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 131, 130, 129, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 129, 129, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 133, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 134, 134, 134, 134, 134, 134, 134, 134, 134
	db 134, 134, 134, 134, 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 131, 131, 130, 129, 129, 129, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133
	db 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 133, 134, 134, 134, 133, 134, 134, 134, 134, 134, 133, 133, 133, 133, 132, 132, 132, 131, 131
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133
	db 132, 132, 131, 130, 130, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129
	db 129, 129, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 134, 134, 133, 133, 133, 133, 133, 134, 134, 133
	db 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 130, 130, 129, 129, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 134, 133, 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 132, 132
	db 132, 132, 131, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131
	db 130, 130, 130, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 130
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132
	db 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 133, 133, 133, 132, 132, 131, 131, 131, 130, 130, 129, 129, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 129, 129, 129, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 131, 132, 132, 132, 131, 132
	db 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 131, 131, 131, 130, 130, 129
	db 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 130, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 132, 132, 131, 131, 131, 130, 130, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129
	db 129, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133
	db 133, 133, 133, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 130, 130, 129, 129, 128, 128, 128
	db 128, 128, 128, 128, 128, 129, 129, 129, 129, 130, 130, 130, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 132, 132, 132, 131
	db 131, 131, 130, 129, 129, 129, 128, 128, 128, 128, 128, 128, 129, 129, 129, 129, 130, 130, 130, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 133, 132, 132
	db 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 133, 133, 133, 133, 132, 132, 132, 131, 131, 130, 130, 130, 129, 129, 129, 128, 128, 128, 128, 129
	db 129, 129, 129, 130, 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 133, 133, 133
	db 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 132, 132, 132, 131, 131, 131, 130, 130
	db 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 130, 130, 130, 130, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 133, 133, 133, 132, 132, 133, 133, 133, 133, 133, 133, 133, 132, 132, 132, 132, 132, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 133, 133, 133
	db 132, 132, 132, 131, 131, 131, 130, 130, 129, 129, 129, 129, 129, 129, 129, 129, 129, 129, 130, 130
	db 130, 130, 130, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 133, 133, 132
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 133, 133, 133, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 129, 129, 129
	db 129, 129, 129, 129, 129, 129, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133
	db 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 133, 132, 132, 132, 131, 131
	db 131, 131, 130, 130, 130, 129, 129, 129, 129, 129, 129, 129, 129, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132, 133, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 133, 132, 132, 132, 132, 132, 131, 131, 131, 130, 130, 130, 130, 129, 129, 129, 129, 129, 129
	db 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130
	db 130, 130, 129, 129, 129, 129, 129, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130
	db 130, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130
	db 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130
	db 130, 130, 130, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130
	db 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 130, 130, 130, 130, 130, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 132, 132, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 131, 131, 131, 132, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 132, 132, 132, 131, 131, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 132, 132
	db 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128

Main_Instrument6
	db 1	; Instrument type (Sample).
	dw 2446	; Length (including padding).
	dw 2125	; End index.
	dw 0	; Loop start index.
	db 0	; Loop?
	db 7	; Amplitude (8 bits) - 1.
	db 128	; Offset added to the each value.

; The sample data.
	db 132, 132, 132, 132, 132, 132, 132, 132, 133, 128, 135, 128, 135, 128, 129, 135, 130, 132, 129, 135
	db 129, 130, 133, 128, 134, 130, 131, 133, 133, 129, 135, 131, 131, 134, 133, 133, 133, 134, 131, 133
	db 133, 133, 132, 131, 132, 130, 134, 132, 135, 130, 132, 128, 130, 128, 130, 128, 128, 128, 128, 128
	db 128, 128, 129, 129, 128, 131, 133, 133, 135, 135, 135, 135, 135, 135, 135, 134, 135, 134, 134, 134
	db 131, 129, 128, 128, 128, 128, 130, 130, 132, 133, 133, 134, 134, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 133, 132, 131, 130, 130, 129, 129, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 129, 130, 131, 132
	db 133, 133, 134, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135, 135
	db 135, 135, 135, 135, 135, 134, 134, 134, 133, 133, 132, 132, 131, 131, 132, 132, 131, 130, 131, 129
	db 130, 128, 128, 128, 129, 128, 128, 128, 128, 129, 129, 130, 130, 129, 130, 130, 129, 131, 131, 131
	db 129, 130, 130, 129, 129, 129, 129, 129, 129, 129, 129, 129, 131, 130, 130, 130, 130, 130, 129, 129
	db 131, 129, 130, 130, 128, 130, 129, 130, 130, 130, 129, 130, 130, 131, 131, 131, 133, 133, 133, 133
	db 133, 135, 134, 134, 134, 134, 133, 133, 134, 134, 134, 133, 133, 134, 133, 133, 133, 134, 133, 134
	db 134, 133, 135, 135, 135, 134, 135, 135, 135, 135, 135, 135, 135, 134, 135, 134, 135, 135, 133, 134
	db 133, 133, 132, 133, 131, 132, 131, 130, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130, 128
	db 129, 129, 128, 129, 128, 128, 128, 128, 128, 128, 128, 128, 129, 129, 129, 130, 130, 130, 129, 130
	db 129, 130, 131, 130, 131, 131, 130, 131, 130, 132, 131, 132, 130, 131, 130, 131, 131, 130, 131, 131
	db 132, 131, 131, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 130, 131, 131, 130, 131
	db 131, 131, 132, 132, 132, 133, 132, 132, 133, 133, 133, 133, 134, 132, 134, 134, 135, 135, 135, 134
	db 134, 134, 134, 134, 134, 134, 135, 133, 134, 133, 134, 134, 134, 134, 134, 134, 134, 134, 135, 133
	db 134, 133, 133, 132, 133, 132, 133, 131, 132, 131, 132, 131, 131, 131, 129, 130, 131, 129, 129, 130
	db 129, 129, 130, 130, 129, 130, 130, 129, 131, 130, 130, 131, 131, 131, 131, 131, 131, 131, 131, 130
	db 132, 131, 131, 131, 131, 131, 131, 132, 131, 132, 131, 131, 131, 131, 130, 131, 131, 131, 131, 131
	db 130, 131, 131, 130, 130, 130, 130, 130, 130, 130, 130, 130, 131, 130, 130, 131, 130, 130, 131, 131
	db 131, 132, 131, 131, 131, 130, 132, 131, 132, 132, 132, 131, 132, 132, 132, 133, 132, 133, 132, 132
	db 132, 133, 133, 133, 133, 133, 132, 132, 133, 133, 131, 132, 133, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 131, 132, 132, 131, 132, 131, 132, 132, 132, 134, 132, 133, 134, 133, 134, 133, 133, 134
	db 132, 133, 132, 133, 133, 133, 131, 132, 131, 131, 132, 131, 131, 132, 132, 131, 132, 130, 132, 132
	db 132, 133, 133, 133, 134, 133, 133, 133, 134, 133, 132, 133, 133, 132, 132, 133, 132, 132, 132, 131
	db 132, 131, 131, 131, 131, 131, 132, 130, 131, 131, 131, 131, 131, 130, 131, 131, 130, 130, 131, 130
	db 131, 129, 130, 129, 129, 128, 128, 128, 129, 128, 129, 129, 130, 129, 130, 130, 131, 131, 131, 131
	db 132, 131, 131, 131, 130, 131, 131, 131, 131, 131, 130, 130, 131, 130, 131, 131, 131, 131, 131, 131
	db 132, 131, 132, 132, 131, 131, 131, 133, 130, 131, 130, 131, 131, 131, 131, 131, 130, 130, 130, 132
	db 130, 130, 131, 130, 131, 132, 131, 133, 131, 133, 133, 133, 133, 133, 133, 134, 133, 133, 133, 134
	db 133, 133, 133, 134, 134, 133, 134, 133, 134, 134, 134, 134, 134, 135, 134, 135, 134, 133, 133, 134
	db 133, 133, 133, 133, 133, 133, 133, 132, 132, 133, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131
	db 130, 130, 131, 131, 130, 130, 130, 131, 131, 131, 131, 132, 131, 131, 132, 131, 131, 131, 132, 131
	db 132, 131, 132, 133, 131, 132, 132, 132, 132, 131, 131, 131, 132, 131, 132, 131, 131, 131, 131, 130
	db 131, 130, 131, 130, 131, 130, 131, 129, 130, 130, 129, 129, 130, 129, 128, 129, 128, 129, 129, 130
	db 128, 129, 131, 131, 129, 131, 131, 131, 132, 131, 132, 132, 132, 132, 131, 131, 133, 131, 133, 132
	db 131, 131, 131, 131, 133, 132, 132, 132, 133, 132, 134, 133, 134, 133, 133, 132, 133, 132, 132, 133
	db 132, 132, 130, 131, 132, 131, 132, 131, 133, 130, 131, 132, 132, 131, 132, 132, 131, 132, 132, 132
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 131, 132, 132, 132
	db 132, 133, 134, 133, 133, 133, 133, 133, 133, 133, 132, 134, 133, 132, 133, 132, 133, 132, 132, 133
	db 131, 132, 131, 131, 132, 130, 130, 131, 129, 129, 130, 129, 129, 130, 129, 129, 130, 130, 129, 131
	db 131, 131, 130, 130, 131, 132, 131, 132, 132, 132, 133, 133, 133, 133, 133, 134, 133, 134, 133, 133
	db 133, 133, 133, 131, 132, 132, 131, 131, 131, 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 131, 130, 131, 131, 132, 131, 131, 131, 132, 130, 131, 131, 130, 131, 129, 131, 130, 130
	db 130, 131, 131, 131, 131, 132, 131, 131, 131, 132, 131, 133, 132, 132, 133, 133, 133, 133, 133, 133
	db 134, 133, 133, 133, 133, 134, 133, 133, 132, 132, 132, 132, 131, 131, 131, 131, 131, 131, 130, 131
	db 131, 130, 131, 129, 131, 130, 131, 131, 130, 131, 130, 131, 131, 131, 130, 130, 131, 130, 131, 130
	db 131, 130, 132, 131, 131, 132, 133, 132, 133, 133, 133, 134, 134, 133, 133, 134, 133, 133, 134, 132
	db 133, 132, 133, 132, 131, 132, 132, 132, 131, 132, 131, 131, 130, 131, 132, 131, 130, 131, 131, 131
	db 131, 131, 131, 130, 130, 130, 131, 129, 129, 130, 131, 131, 131, 131, 131, 131, 130, 132, 132, 131
	db 133, 132, 133, 133, 132, 132, 133, 133, 133, 133, 133, 132, 133, 133, 132, 133, 132, 133, 133, 133
	db 134, 133, 133, 132, 132, 132, 132, 132, 131, 132, 131, 131, 130, 131, 131, 130, 130, 130, 131, 131
	db 129, 131, 130, 131, 130, 132, 131, 130, 132, 131, 133, 132, 132, 132, 132, 133, 132, 133, 132, 133
	db 133, 133, 132, 132, 132, 131, 133, 132, 130, 133, 132, 132, 132, 132, 131, 133, 132, 131, 133, 132
	db 131, 133, 132, 131, 133, 131, 132, 130, 131, 130, 131, 130, 130, 130, 130, 131, 131, 131, 131, 131
	db 130, 132, 131, 131, 131, 131, 131, 131, 131, 132, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132
	db 132, 131, 132, 133, 132, 131, 133, 132, 132, 132, 133, 131, 132, 131, 132, 132, 132, 131, 132, 130
	db 130, 131, 130, 130, 131, 131, 130, 131, 131, 131, 132, 131, 132, 132, 131, 132, 131, 132, 132, 131
	db 132, 131, 132, 131, 131, 132, 131, 131, 132, 132, 131, 132, 131, 133, 131, 131, 132, 131, 131, 131
	db 132, 132, 131, 133, 131, 132, 131, 132, 132, 131, 132, 131, 131, 131, 132, 131, 131, 132, 131, 133
	db 132, 132, 133, 132, 132, 132, 132, 132, 132, 132, 132, 133, 133, 131, 132, 131, 131, 131, 131, 131
	db 130, 131, 130, 131, 130, 130, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 131, 132, 132, 132
	db 132, 131, 132, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132
	db 131, 132, 132, 131, 131, 132, 132, 132, 132, 132, 131, 132, 131, 132, 131, 132, 131, 131, 130, 130
	db 131, 131, 130, 131, 130, 132, 131, 132, 131, 132, 131, 132, 132, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 133, 132, 132, 133, 133, 132, 132, 132, 130, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 132, 132
	db 132, 131, 132, 132, 132, 131, 132, 132, 131, 132, 132, 132, 132, 131, 133, 131, 131, 132, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 131, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 132, 132, 132, 132, 131, 132, 131, 132, 131, 132, 132, 131, 131, 132, 131, 132
	db 131, 132, 132, 132, 132, 131, 132, 131, 131, 132, 131, 131, 132, 131, 130, 131, 131, 131, 131, 131
	db 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 133, 132, 132, 133, 133, 131, 132, 132, 132
	db 131, 132, 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 131, 131, 132, 131
	db 131, 132, 131, 132, 131, 132, 131, 131, 132, 132, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131, 131, 132, 131, 132, 131, 132, 132, 132
	db 132, 131, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 131, 131, 132
	db 132, 132, 132, 132, 132, 132, 132, 133, 133, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131, 131
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 132, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 131
	db 131, 131, 132, 131, 131, 131, 131, 131, 131, 132, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131
	db 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 131, 131
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 132, 131, 131, 131
	db 131, 131, 131, 132, 131, 131, 132, 132, 132, 132, 132, 131, 131, 131, 132, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 132
	db 131, 131, 131, 131, 131, 131, 132, 131, 131, 132, 131, 131, 132, 131, 131, 132, 131, 131, 132, 132
	db 131, 132, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131, 132, 132, 132, 132, 131, 131, 131, 132, 131
	db 131, 132, 131, 131, 131, 131, 131, 131, 132, 131, 131, 131, 131, 131, 132, 131, 131, 131, 131, 132
	db 131, 131, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 131, 132, 132, 131, 132, 132, 132, 131, 132, 131, 132, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 132, 131, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 132, 132, 132, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 131, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132, 131, 132, 131
	db 132, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 131
	db 131, 131, 131, 131, 131, 131, 131, 131, 131, 131, 132, 132, 132, 132, 132, 132, 132, 132, 132, 132
	db 132, 132, 132, 132, 132, 132, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128, 128
	db 128, 128, 128, 128, 128, 128


',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: audio
  SELECT id INTO tag_uuid FROM tags WHERE name = 'audio';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
