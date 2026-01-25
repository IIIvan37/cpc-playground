-- Migration: Import z80code projects batch 4
-- Projects 7 to 8
-- Generated: 2026-01-25T21:43:30.182813

-- Project 7: cngintro#1 by CNGSoft
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
    'Imported from z80Code. Author: CNGSoft. CRTC tricks',
    'public',
    false,
    false,
    '2020-07-01T19:09:53.019000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'buildsna
org #9000
run #9700
WITH_SCROLL	equ 0

font	equ #9400
logo	equ #9000
 
db #40
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
db #fc,#fc,#ff,#ff,#fc,#be,#fd,#3c
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
db #f4,#40,#4c,#40,#4c,#f4,#e4,#40 ;..L.Lr...
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


start_9700 
	di

    	call init

	; Initialisation CRTC
	; R0 : #40, R1 : #40
	; R2 : #3d, R5 : #4
	; R6 : #1f, R7 : #22
    	ld bc, #bc3f
    	out (c), 0
    	inc b
    	out (c), c
    	ld bc,#bc05
    	out (c), c
    	inc b
    	dec c
    	out (c),c
    	ld bc,#bc01
    	ld hl, #3f3d
    	out (c),c
    	inc b
    	out (c), h
    	dec b
    	inc c
    	out (c),c
    	inc b
    	out (c),l
    	ld bc,#bc06
    	ld hl, #0f22
    	out (c),c
    	inc b
    	out (c),h
    	dec b
    	inc c
    	out (c),c
    	inc b
    	out (c), l


mainLoop:

.counter:	ld iy, #0000
    	inc iyl
    	ld a, iyl
    	cp #10
    	jr nz, .skipPal
    	ld a, iyh
    	and a
    	jr nz, .skipPal

	; Initialisation palette une seule fois, lorsque iy = #0010
    	ld bc, #7F10
    	ld iy, endPalette
.loopPal 	dec iy
    	dec c
    	out (c), c
    	ld a, (iy + 0)
    	out (c), a
    	jr nz, .loopPal
    	inc iyh
.skipPal 	
	ld (mainLoop.counter + 2), iy
    	ld a, iyh
    	and a
    	jp z, drawBlock

    	ld b, #f5
.vsync 	in a,(c)
    	rra 
    	jr nc, .vsync

	; Cycle des 4 premières couleurs pour scroll du background
    	ld bc, #7f54
    	ld a, iyl
    	rra 	; cycle tous les 2 frames
    	and #3
    	out (c), a
    	out (c), c
    	inc a
    	and #3
    	ld c, #5c
    	out (c), a
    	out (c), c
    	inc a
    	and #3
    	ld c, #56
    	out (c), a
    	out (c), c
    	inc a
    	and #3
    	ld c, #44
    	out (c), a
    	out (c), c
	  
.pScr 	ld hl, #c000
if WITH_SCROLL
	; --------------------------------------------------------------
	; SCROLL TEXT 
	; --------------------------------------------------------------
	; Adresse du premier caractère du scroll texte
ScrollText:
.ptr: 	ld ix, scrollTextSpaces
    	ld a, iyl
    	rra 
    	jr nc, .scrollStart
	inc l	; Pour ralentir le scroll ?
.scrollStart 	ld de, #0F8E
    	add hl,de
    	ld a, h
    	and #7
    	or #c0
    	ld h, a
    	ex de, hl

	; 1 caractère 0 = #30
	; #30 * #10 = #300
    	ld sp, font - #300; Adresse police caractères
	
    	ld iy, #35
.loopScroll 	
	ld a, (ix + 0)
    	and a
    	jr nz, .charOk
	; Fin du scroll text, on se replace au début
    	ld ix, strScrollText
    	ld a, (ix + 0)	; Index du caractère à afficher
.charOk 	ld l, a
    	ld h, #0
    	add hl, hl	; x2
    	add hl, hl	; x4
    	add hl, hl	; x8
    	add hl, hl	; x16 => taille d''un caractère
    	add hl, sp
    	ld a, d
	
    	ld bc, #08ff	; b = 8, 
	    	; c = #ff pour ne pas modifier b lors du ldi	
repeat 2
repeat 7 
    	ldi
    	dec e	; On se replace sur la bonne colonne
    	add a, b	; ligne suivante
    	ld d, a
rend
    	
    	ldi	
	; On se replace sur la première ligne du caractère
	; 1 octet à droite pour la colonne suivante
    	ld a, d	
    	and #7
    	or #c0
    	ld d, a
rend
  
    	inc ix		; caractère suivant
    	dec iyl	
    	jr nz, .loopScroll

    	ld iy, (mainLoop.counter + 2)
    	ld hl, (.ptr + 2)
    	ld a, iyl
    	rra 
    	jr c, .endScroll
    	inc hl
    	ld a,(hl)
    	and a
    	jr nz, .endScroll
	; Fin du scroll text, on se replace au début
    	ld hl, strScrollText
.endScroll 	ld (.ptr + 2), hl
endif


drawBlock 	
.adr:	ld hl, logo
.pTabSin:	ld ix, tabSin
	
    	srl h : rr l	; hl = int(adr / 2)
    	srl h : rr l	; hl = int(adr / 4)
    	srl h : rr l	; hl = int(adr / 8)

	; transformation valeur 8 bits signée en valeur 16 bits signées
	; dans bc
	; #01 => bc = #0001
	; #02 => bc = #0002
	; #ff => bc = #ffff
	; #f6 => bc = #fff6, etc
	; bc = valeur du décalage
    	ld b, #00
    	ld c, (ix + 0)
    	bit 7, c
    	jr z, .noNeg
    	dec b	

.noNeg: 	add hl, bc	; hl = int(adr / 8) + decalage
    	add hl, hl	; (hl = int(adr / 8) + decalage) * 2
    	add hl, hl	; (hl = int(adr / 8) + decalage) * 4
    	add hl, hl	; (hl = int(adr / 8) + decalage) * 8
		
	; On avance dans la table sinus uniquement lors des frames impairs
	ld a, iyl
    	rra 
    	jr c, .end
    	inc ix

	; Bouclage sur la table sinus [tabSin, tabSin + #20]	
    	ld a, ixl
    	cp #21
    	jr nz, .end
	ld ix, tabSin

.end 	ld (.pTabSin + 2), ix
	; pointeur sur data Logo entre [#9000, #93ff]
    	ld a, h
    	and #3
    	or #90
    	ld h, a
    	ld (.adr + 1), hl
	
    	ex de, hl
    	ld hl ,(mainLoop.pScr + 1)
    	
	ld bc, #0080	; bc = 31 * 2
    	add hl, bc	; hl = adresse colonne droite
	; Correction débordement bloc
    	ld a, h
    	and #7
    	or #c0
    	ld h, a

	; Affichage d''un bloc de 8 x 16
    	ld c, #0f	
.loopY1 	ld b, #08	; Nombre de lignes à afficher
    	ld a, c
    	add a, #40	; Pour ne pas modifier b lors du ldi
    	ld c, a
    	ld sp, #800 - 8
.loopY2 	ex de, hl
	; hl = pointeur du logo
	; de = screen address
	; pointeur sur data Logo entre [#9000, #93ff]
    	ld a, h
    	and #3
    	or #90
    	ld h, a

repeat 8
	ldi
rend
    	
    	ex de, hl
	; hl = screen address
	; de = pointeur du logo
    	add hl, sp	; ligne suivante
    	djnz .loopY2

    	ld sp, #3f * 2	; R1 * 2	
    	add hl, sp	; ligne du caractère suivant

	; Correction débordement bloc
    	ld a, h
    	and #7
    	or #c0
    	ld h, a

    	dec c 	; compteur lignes = compteur lignes - 1
    	jr nz, .loopY1

if WITH_SCROLL
	;
	; Nettoyage des 8 octets sur la première et denière ligne de l''écran
	; qui autrement vont scroller, et finiront par provoquer du garbage
	;
    	xor a	; pour mettre la carry à 0
    	ld c, #3F
    	sbc hl, sp	; ligne précédente
    	ld a, h
    	ld e, l
    	or #f8
    	ld h, a
    	ld b, #8
lab98EC 	ld (hl), c
    	inc l
    	djnz lab98EC
    	ld l, e
    	add hl, sp
    	add hl, sp
    	ld a, h
    	and #7
    	or #c0
    	ld h, a
    	ld b, #8
lab98FB 	ld (hl),c
    	inc l
    	djnz lab98FB
endif
    	ld hl, (mainLoop.pScr + 1)
    	srl h
    	rr l
    	inc hl
    	inc hl
    	inc hl
    	inc hl	; offset CRTC += 4
    	ld a, h
    	and #3
    	or #30
    	ld h, a
	; Mise à jour CRTC r12/r13
    	ld bc, #bc0d
    	out (c), c
    	inc b
    	out (c), l
    	dec b
    	dec c
    	out (c), c
    	inc b
    	out (c), h
    	add hl, hl
	; Offset crtc => Adresse écran
    	ld a, h
    	xor #a0
    	ld h, a

    	ld (mainLoop.pScr + 1), hl
    	ld a, iyh	; a = frameCounter
    	and a
	; Boucle si plus de 256 frames
    	jp z, mainLoop

	
.modifLogo 	ld hl, logo
    	ld a, h
    	and #1
    	or #90
    	ld h, a
    	xor #2
    	ld d, a
    	ld e, l
    	ld a, (de)
    	ld c, (hl)
    	ex de, hl
    	ld (de), a
    	ld (hl), c
    	ld c, #d
    	add hl, bc
    	ld (.modifLogo + 1),hl

    	
    	jp mainLoop
	; Sinon on restaure la pile

init
	; Set mode 0
	ld bc, #7F8C
    	out (c),c

; 	; Toutes les encres + border à 0 
    	ld c, #11
    	ld a, #54
.loopPal0 	dec c
    	out (c), c
    	out (c), a
    	jr nz, .loopPal0
    	
	; Nettoyage écran #c000 
	ld hl, #c000
    	ld bc, #0040	; loop #100 * #40
    	xor a
.loopClear: 	ld (hl), a
    	inc hl
    	djnz .loopClear
    	dec c
    	jr nz, .loopClear
    	ret


align 256
tabSin 
db #ff
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
db #05,#07,#09,#07,#05,#03,#01

palette:
db #5c
db #4c,#4e,#4a,#44,#55,#57,#53,#56 ;LNJDUWSV
db #52,#54,#4b ;RTK
endPalette:


scrollTextSpaces 

db #5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f,#5f,#5f,#5f,#5f,#5f,#5f
db #5f,#5f

strScrollText
db #53		   ;0	
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

  -- Add category tag: intro
  SELECT id INTO tag_uuid FROM tags WHERE name = 'intro';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 8: test_arkos_tracker_2 by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test_arkos_tracker_2',
    'Imported from z80Code. Author: Unknown. Arkos Tracker 2 Lightweight  format',
    'public',
    false,
    false,
    '2019-10-25T15:54:49.793000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '        ;Tests the Lightweight player, for AMSTRAD CPC.                
        ;This builds a SNApshot, handy for testing (RASM feature).
        ;buildsna
        ;bankset 0
        ;run #1000        
        ;org #1000


        di
        ld hl,#c9fb
        ld (#38),hl
        ld sp,#38

        ;Initializes the music.
        ld hl,Music
        xor a                                   ;Subsong 0.
        call PLY_LW_Init

        ;Puts some markers to see the CPU.
        ld a,255
        ld hl,#c000 + 5 * #50 
        ld (hl),a
        ld hl,#c000 + 6 * #50
        ld (hl),a
        ld hl,#c000 + 7 * #50
        ld (hl),a
        ld hl,#c000 + 8 * #50
        ld (hl),a
        ld hl,#c000 + 9 * #50
        ld (hl),a
		
        ld bc,#7f03
        out (c),c
        ld a,#4c
        out (c),a

Sync:   ld b,#f5
        in a,(c)
        rra
        jr nc,Sync + 2

        ei
        nop
        halt
        halt

       
        di

        ld b,90
        djnz $

        ld bc,#7f10
        out (c),c
        ld a,#4b
        out (c),a

	;Plays the music.
        call PLY_LW_Play

        ld bc,#7f10
        out (c),c
        ld a,#54
        out (c),a

        jr Sync

Music:
        ; La configuration n''est pas obligatoire, mais elle permet
        ; de réduire la taille du binaire produit (ici 1.6K au lieu de 1.8K)
        include "./barbapapa_lw_playerconfig.asm"       
        include "./barbapapa_lw.asm"       
        
Player:
        include "./PlayerLightweight.asm"
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
