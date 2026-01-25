-- Migration: Import z80code projects batch 32
-- Projects 63 to 64
-- Generated: 2026-01-25T21:43:30.192714

-- Project 63: program329 by bsc
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program329',
    'Imported from z80Code. Author: bsc.',
    'public',
    false,
    false,
    '2022-12-17T17:40:23.948000'::timestamptz,
    '2022-12-22T18:29:33.635000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'macro waitVBL
                ld b, #f5
@loop:          in a, (c)
                rra 
                jr nc, @loop
endm

macro waitLine nLines
                ld b, {nLines} 
@loop:          ds 60
                djnz @loop
endm

macro setCrtcReg reg, val
               ld bc, #bc00 + {reg} 
               out (c), c 
               inc b 
               ld c, {val}
               out (c), c
endm

macro setborder col
                ld bc,#7f10
                out (c), c
                ld c, {col}
                out (c), c
endm

macro wait lines
                waitLine {lines}
                ld h,$c0
                ld a,r
                ld l,a
                ld (hl),a
                xor e
                xor d
                ex de,hl
                ld r,a
endm            

;
; END of macros
;

.start:
                org $300
                
                ld hl,$c9fb
                ld ($38),hl
                ei
                halt
                waitVBL
                halt
                di

.loop:
                setBorder "D"
                setCrtcReg 7, $ff
                setCrtcReg 9, 1
                setCrtcReg 4, 0
                
                wait 51 ; 52
                setBorder "U"

                wait 52 ; 104
                setBorder "W"           
               
                wait 51; 156
                setBorder "S"     
             
                wait 51; 208
                setBorder "K"                          

                wait 51; 208
                setBorder "Y"
                
                wait 52 ; 260
                ;setBorder "M"

                ;setCrtcReg 4, 1
                setCrtcReg 7, 2

                ds 29

                jp .loop',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 64: cho_demo by Demoniak & CMP
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'cho_demo',
    'Imported from z80Code. Author: Demoniak & CMP. Cho Demo / Impact',
    'public',
    false,
    false,
    '2020-08-26T20:39:43.622000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'skipanim equ #1180 	
			;a quel moment passer a la partie de cmp
			; mettre 1 pour "ignorer" la partie anim soleil



;run demoludo



	ORG #1013
    
	nolist
InitMusic
	DB	#AF,#32,#36,#15,#06,#00,#21,#37,#15,#DD,#21,#5B,#10
	DB	#0E,#22,#3E,#03,#5E,#23,#56,#23,#E5,#DD,#36,#10,#01,#DD,#70,#00
	DB	#DD,#70,#1D,#DD,#73,#03,#DD,#72,#04,#DD,#70,#20,#EB,#5E,#23,#56
	DB	#DD,#36,#05,#02,#DD,#70,#06,#E1,#DD,#73,#01,#DD,#72,#02,#DD,#09
	DB	#3D,#20,#D1,#3C,#32,#C1,#10,#32,#36,#15,#C9,#01,#4A,#17,#3D,#15
	DB	#02,#00,#80,#FF,#17,#15,#18,#15,#FF,#01,#00,#01,#06,#30,#0A,#00
	DB	#41,#01,#05,#00,#0F,#01,#01,#01,#60,#00,#00,#00,#09,#01,#4A,#17
	DB	#2F,#16,#06,#00,#80,#FF,#17,#15,#18,#15,#FF,#01,#00,#03,#06,#30
	DB	#0A,#00,#41,#01,#05,#00,#0F,#01,#01,#01,#40,#00,#00,#00,#12,#01
	DB	#4A,#17,#9B,#15,#04,#00,#A0,#00,#17,#15,#18,#15,#14,#01,#00,#02
	DB	#06,#30,#0A,#00,#41,#01,#05,#00,#0F,#01,#01,#02,#40,#00,#00,#00
	DB	#24,#02
PlayMusic
	DB	#CD,#03,#1B,#3A,#36,#15,#A7,#C8,#3E,#07,#32,#18,#11,#21
	DB	#C1,#10,#35,#20,#1B,#46,#DD,#21,#5B,#10,#CD,#82,#12,#DD,#21,#7D
	DB	#10,#CD,#82,#12,#DD,#21,#9F,#10,#CD,#82,#12,#21,#C1,#10,#36,#04
	DB	#DD,#21,#5B,#10,#CD,#38,#13,#22,#5B,#14,#32,#63,#14,#DD,#21,#7D
	DB	#10,#CD,#38,#13,#22,#5D,#14,#32,#64,#14,#DD,#21,#9F,#10,#CD,#38
	DB	#13,#22,#5F,#14,#32,#65,#14,#3E,#07,#32,#61,#14,#3A,#AB,#1A,#A7
	DB	#28,#30,#2A,#9B,#1B,#22,#5B,#14,#2A,#9F,#1B,#22,#5F,#14,#3A,#A1
	DB	#1B,#32,#61,#14,#3A,#62,#14,#F6,#2D,#21,#A2,#1B,#A6,#32,#62,#14
	DB	#3A,#A3,#1B,#32,#63,#14,#3A,#A5,#1B,#32,#65,#14,#3A,#A7,#1B,#32
	DB	#67,#14,#21,#66,#14,#16,#0B,#5E,#06,#F4,#ED,#51,#01,#00,#F6,#ED
	DB	#49,#3E,#C0,#ED,#79,#ED,#49,#06,#F4,#ED,#59,#06,#F6,#87,#ED,#79
	DB	#ED,#49,#2B,#15,#F2,#57,#11,#C9,#11,#00,#D0,#CD,#85,#11,#15,#F2
	DB	#7B,#11,#11,#3F,#07,#06,#F4,#ED,#51,#01,#00,#F6,#ED,#49,#3E,#C0
	DB	#ED,#79,#ED,#49,#06,#F4,#ED,#59,#06,#F6,#87,#ED,#79,#ED,#49,#C9
	DB	#CD,#B5,#B9,#BE,#7C,#AB,#A6,#13,#95,#8D,#52,#3C,#64,#BA,#04,#C1
	DB	#C6,#CB,#AF,#32,#36,#15,#E1,#C3,#78,#11,#DD,#4E,#05,#DD,#46,#06
	DB	#DD,#6E,#03,#DD,#66,#04,#09,#03,#03,#7E,#23,#56,#5F,#B2,#20,#0C
	DB	#DD,#6E,#03,#DD,#66,#04,#01,#02,#00,#5E,#23,#56,#DD,#71,#05,#DD
	DB	#70,#06,#06,#00,#C3,#94,#12,#DD,#7E,#21,#4F,#E6,#07,#21,#40,#14
	DB	#AE,#A1,#AE,#77,#3E,#01,#DD,#77,#1E,#C3,#94,#12,#DD,#7E,#21,#4F
	DB	#E6,#38,#21,#40,#14,#AE,#A1,#AE,#77,#AF,#DD,#77,#1E,#C3,#94,#12
	DB	#21,#40,#14,#DD,#7E,#21,#2F,#A6,#77,#3E,#01,#DD,#77,#1E,#18,#74
	DB	#1A,#13,#DD,#70,#07,#DD,#70,#08,#DD,#77,#0D,#DD,#CB,#00,#D6,#1A
	DB	#DD,#77,#0E,#13,#18,#5E,#1A,#13,#DD,#77,#20,#18,#57,#1A,#DD,#77
	DB	#1B,#13,#1A,#DD,#77,#1A,#13,#DD,#77,#1C,#18,#48,#DD,#CB,#00,#FE
	DB	#DD,#CB,#00,#DE,#18,#3E,#DD,#70,#1D,#18,#39,#DD,#36,#1D,#40,#18
	DB	#33,#DD,#36,#1D,#C0,#18,#2D,#DD,#CB,#00,#CE,#18,#27,#DD,#70,#13
	DB	#DD,#CB,#00,#AE,#18,#54,#DD,#CB,#00,#E6,#18,#18,#DD,#CB,#1F,#C6
	DB	#18,#12,#DD,#35,#10,#20,#50,#DD,#70,#00,#DD,#CB,#1F,#86,#DD,#5E
	DB	#01,#DD,#56,#02,#1A,#13,#A7,#FA,#E8,#12,#DD,#77,#12,#DD,#CB,#1E
	DB	#46,#28,#03,#32,#CB,#10,#DD,#CB,#00,#66,#20,#1E,#DD,#7E,#19,#DD
	DB	#77,#13,#DD,#CB,#00,#EE,#DD,#CB,#00,#F6,#DD,#CB,#00,#A6,#DD,#7E
	DB	#14,#DD,#77,#16,#DD,#7E,#17,#DD,#77,#18,#DD,#7E,#11,#DD,#77,#10
	DB	#DD,#72,#02,#DD,#73,#01,#C9,#DD,#7E,#00,#CB,#5F,#C8,#17,#30,#04
	DB	#DD,#34,#12,#C9,#DD,#35,#12,#C9,#FE,#B8,#38,#44,#C6,#20,#38,#24
	DB	#C6,#10,#38,#27,#C6,#10,#30,#15,#4F,#21,#10,#15,#09,#4E,#09,#DD
	DB	#75,#0B,#DD,#75,#09,#DD,#74,#0C,#DD,#74,#0A,#18,#87,#C6,#09,#32
	DB	#EF,#10,#18,#80,#3C,#DD,#77,#11,#C3,#94,#12,#DD,#77,#19,#1A,#13
	DB	#DD,#77,#14,#1A,#13,#DD,#77,#15,#1A,#13,#DD,#77,#17,#C3,#94,#12
	DB	#21,#20,#11,#4F,#09,#4E,#09,#E9,#DD,#4E,#00,#CB,#69,#28,#44,#DD
	DB	#7E,#16,#D6,#10,#30,#25,#CB,#71,#28,#26,#DD,#86,#13,#30,#01,#9F
	DB	#C6,#10,#DD,#77,#13,#DD,#7E,#18,#D6,#10,#30,#0A,#CB,#B1,#DD,#7E
	DB	#15,#DD,#77,#16,#18,#1D,#DD,#77,#18,#18,#18,#DD,#77,#16,#18,#13
	DB	#2F,#D6,#0F,#DD,#86,#13,#38,#01,#97,#DD,#77,#13,#DD,#35,#18,#20
	DB	#02,#CB,#A9,#DD,#7E,#20,#DD,#86,#12,#47,#DD,#6E,#0B,#DD,#66,#0C
	DB	#7E,#FE,#87,#38,#07,#DD,#6E,#09,#DD,#66,#0A,#7E,#23,#DD,#75,#0B
	DB	#DD,#74,#0C,#80,#21,#68,#14,#16,#00,#87,#5F,#19,#5E,#23,#56,#DD
	DB	#6E,#1D,#CB,#75,#28,#48,#67,#DD,#46,#1A,#CB,#20,#CB,#7D,#DD,#7E
	DB	#1C,#28,#04,#CB,#41,#20,#1E,#CB,#6D,#20,#0C,#DD,#96,#1B,#30,#12
	DB	#DD,#CB,#1D,#EE,#97,#18,#0B,#DD,#86,#1B,#B8,#38,#05,#DD,#CB,#1D
	DB	#AE,#78,#DD,#77,#1C,#EB,#CB,#38,#90,#5F,#7A,#16,#00,#30,#01,#15
	DB	#C6,#A0,#38,#08,#CB,#23,#CB,#12,#C6,#18,#30,#F8,#19,#EB,#79,#EE
	DB	#01,#DD,#77,#00,#CB,#51,#28,#21,#DD,#46,#0E,#10,#19,#DD,#4E,#0D
	DB	#CB,#79,#28,#01,#05,#DD,#6E,#07,#DD,#66,#08,#09,#DD,#75,#07,#DD
	DB	#74,#08,#19,#EB,#18,#03,#DD,#70,#0E,#DD,#CB,#1F,#46,#28,#0D,#DD
	DB	#CB,#1F,#86,#3E,#00,#32,#18,#11,#3E,#07,#18,#11,#2F,#E6,#03,#3E
	DB	#38,#20,#0A,#3A,#CB,#10,#EE,#08,#32,#18,#11,#3E,#07,#21,#62,#14
	DB	#AE,#DD,#A6,#21,#AE,#77,#EB,#DD,#7E,#13,#C9,#77,#00,#77,#00,#78
	DB	#00,#07,#38,#0A,#0A,#0A,#00,#00,#7C,#07,#08,#07,#B0,#06,#40,#06
	DB	#EC,#05,#94,#05,#44,#05,#F8,#04,#B0,#04,#70,#04,#2C,#04,#F0,#03
	DB	#BE,#03,#84,#03,#58,#03,#20,#03,#F6,#02,#CA,#02,#A2,#02,#7C,#02
	DB	#58,#02,#38,#02,#16,#02,#F8,#01,#DF,#01,#C2,#01,#AC,#01,#90,#01
	DB	#7B,#01,#65,#01,#51,#01,#3E,#01,#2C,#01,#1C,#01,#0B,#01,#FC,#00
	DB	#EF,#00,#E1,#00,#D6,#00,#C8,#00,#BD,#00,#B2,#00,#A8,#00,#9F,#00
	DB	#96,#00,#8E,#00,#85,#00,#7E,#00,#77,#00,#70,#00,#6B,#00,#64,#00
	DB	#5E,#00,#59,#00,#54,#00,#4F,#00,#4B,#00,#47,#00,#42,#00,#3F,#00
	DB	#3B,#00,#38,#00,#35,#00,#32,#00,#2F,#00,#2C,#00,#2A,#00,#27,#00
	DB	#25,#00,#23,#00,#21,#00,#1F,#00,#1D,#00,#1C,#00,#1A,#00,#19,#00
	DB	#17,#00,#16,#00,#15,#00,#13,#00,#12,#00,#11,#00,#10,#00,#0F,#00
	DB	#07,#08,#0A,#0C,#0E,#16,#18,#00,#87,#00,#02,#87,#00,#03,#87,#00
	DB	#09,#87,#00,#00,#02,#02,#04,#04,#05,#05,#87,#00,#05,#87,#0C,#00
	DB	#00,#00,#00,#00,#00,#87,#01,#3D,#15,#2F,#16,#9B,#15,#2D,#17,#83
	DB	#1A,#92,#1A,#92,#1A,#2D,#17,#4F,#17,#2D,#17,#5B,#17,#1A,#1A,#61
	DB	#17,#61,#17,#61,#17,#6E,#17,#8B,#17,#9A,#17,#8B,#17,#A5,#17,#B0
	DB	#17,#B0,#17,#C6,#17,#C6,#17,#B0,#17,#B0,#17,#C6,#17,#D9,#17,#D9
	DB	#17,#EE,#17,#EE,#17,#C6,#19,#C6,#19,#C6,#19,#C6,#19,#C6,#19,#C6
	DB	#19,#C6,#19,#C6,#19,#E2,#19,#E2,#19,#FE,#19,#FE,#19,#95,#1A,#95
	DB	#1A,#95,#1A,#9E,#1A,#92,#1A,#92,#1A,#00,#00,#92,#1A,#2D,#17,#83
	DB	#1A,#92,#1A,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A
	DB	#19,#1A,#19,#38,#1A,#44,#19,#44,#19,#44,#19,#44,#19,#44,#19,#44
	DB	#19,#44,#19,#44,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A
	DB	#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A,#19,#1A
	DB	#19,#1A,#19,#60,#19,#60,#19,#60,#19,#60,#19,#7C,#19,#7C,#19,#7C
	DB	#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C
	DB	#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C
	DB	#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#7C,#19,#A1,#19,#A1,#19,#A1
	DB	#19,#A1,#19,#1A,#19,#95,#1A,#92,#1A,#9E,#1A,#92,#1A,#00,#00,#92
	DB	#1A,#92,#1A,#2D,#17,#83,#1A,#4E,#18,#4E,#18,#6A,#18,#6A,#18,#80
	DB	#18,#80,#18,#4E,#18,#4E,#18,#4E,#18,#4E,#18,#6A,#18,#6A,#18,#80
	DB	#18,#80,#18,#4E,#18,#4E,#18,#4E,#18,#6A,#18,#6A,#18,#4E,#18,#4E
	DB	#18,#6A,#18,#80,#18,#4E,#18,#96,#18,#96,#18,#6A,#18,#6A,#18,#96
	DB	#18,#96,#18,#6A,#18,#6A,#18,#96,#18,#96,#18,#6A,#18,#6A,#18,#96
	DB	#18,#96,#18,#6A,#18,#6A,#18,#AC,#18,#AC,#18,#4E,#18,#4E,#18,#C2
	DB	#18,#C2,#18,#80,#18,#80,#18,#AC,#18,#AC,#18,#4E,#18,#4E,#18,#C2
	DB	#18,#C2,#18,#80,#18,#80,#18,#4E,#18,#4E,#18,#AC,#18,#AC,#18,#6A
	DB	#18,#6A,#18,#80,#18,#80,#18,#4E,#18,#4E,#18,#AC,#18,#AC,#18,#6A
	DB	#18,#6A,#18,#D8,#18,#D8,#18,#D8,#18,#D8,#18,#EE,#18,#EE,#18,#EE
	DB	#18,#D8,#18,#D8,#18,#D8,#18,#AC,#18,#AC,#18,#AC,#18,#04,#19,#04
	DB	#19,#04,#19,#EE,#18,#EE,#18,#EE,#18,#D8,#18,#D8,#18,#D8,#18,#AC
	DB	#18,#AC,#18,#AC,#18,#04,#19,#04,#19,#04,#19,#EE,#18,#EE,#18,#EE
	DB	#18,#D8,#18,#D8,#18,#D8,#18,#AC,#18,#04,#19,#04,#19,#EE,#18,#EE
	DB	#18,#EE,#18,#C2,#18,#C2,#18,#C2,#18,#80,#18,#80,#18,#80,#18,#80
	DB	#18,#95,#1A,#95,#1A,#92,#1A,#92,#1A,#9E,#1A,#00,#00,#BB,#C0,#8A
	DB	#DF,#00,#41,#05,#E5,#36,#88,#01,#01,#82,#37,#32,#33,#E3,#32,#2E
	DB	#E5,#2D,#E5,#2E,#F3,#26,#E5,#27,#26,#30,#2D,#E3,#33,#32,#87,#E5
	DB	#31,#EF,#32,#C3,#E1,#2E,#31,#30,#2F,#2E,#87,#E5,#2D,#2E,#F3,#2B
	DB	#87,#C1,#F7,#35,#E3,#C2,#35,#C1,#35,#EF,#35,#C2,#34,#87,#F7,#C1
	DB	#35,#E3,#C2,#35,#C1,#35,#EF,#35,#E0,#C2,#34,#35,#36,#37,#38,#39
	DB	#3A,#3B,#3C,#3D,#3E,#3F,#40,#41,#42,#43,#87,#C0,#EF,#37,#E7,#3A
	DB	#3F,#F7,#3E,#E7,#3A,#F7,#3D,#E7,#39,#87,#F5,#3C,#E1,#C3,#27,#2A
	DB	#E1,#29,#28,#27,#87,#F5,#3E,#E1,#C3,#2A,#2D,#E1,#2C,#2B,#2A,#87
	DB	#E1,#C6,#31,#32,#30,#32,#E1,#2E,#32,#2D,#E3,#2B,#E1,#32,#30,#32
	DB	#E1,#2E,#32,#2D,#2B,#87,#E1,#36,#37,#35,#37,#33,#37,#32,#E3,#30
	DB	#E1,#37,#35,#37,#33,#37,#32,#30,#87,#E1,#35,#36,#33,#36,#E1,#32
	DB	#36,#31,#E3,#30,#E1,#36,#35,#E1,#36,#33,#36,#31,#30,#87,#C0,#E1
	DB	#84,#19,#01,#52,#84,#19,#01,#52,#E5,#2E,#36,#35,#EF,#3D,#E1,#C3
	DB	#31,#34,#33,#32,#31,#C0,#E1,#84,#19,#01,#52,#84,#19,#01,#52,#E5
	DB	#C0,#2E,#36,#35,#EF,#38,#E1,#C3,#33,#36,#35,#34,#33,#C0,#E1,#84
	DB	#19,#01,#52,#84,#19,#01,#52,#E5,#C0,#2E,#31,#30,#EF,#33,#E1,#C3
	DB	#37,#3A,#39,#38,#37,#C0,#E1,#84,#19,#01,#52,#84,#19,#01,#52,#E5
	DB	#C0,#2D,#36,#35,#EF,#3C,#E1,#C3,#39,#3C,#3B,#3A,#39,#87,#8A,#DF
	DB	#00,#41,#04,#C0,#E1,#91,#13,#91,#1F,#8B,#8D,#07,#8A,#91,#13,#91
	DB	#1F,#91,#13,#8B,#8D,#07,#8A,#91,#1F,#87,#E1,#91,#0C,#91,#18,#8B
	DB	#8D,#07,#8A,#91,#0C,#91,#18,#91,#0C,#8B,#8D,#07,#8A,#91,#18,#87
	DB	#E1,#91,#0E,#91,#1A,#8B,#8D,#07,#8A,#91,#0E,#91,#1A,#91,#0E,#8B
	DB	#8D,#07,#8A,#91,#1A,#87,#E1,#91,#0D,#91,#19,#8B,#8D,#07,#8A,#91
	DB	#0D,#91,#19,#91,#0D,#8B,#8D,#07,#8A,#91,#19,#87,#E1,#91,#0F,#91
	DB	#1B,#8B,#8D,#07,#8A,#91,#0F,#91,#1B,#91,#0F,#8B,#8D,#07,#8A,#91
	DB	#1B,#87,#E1,#91,#15,#91,#21,#8B,#8D,#07,#8A,#91,#15,#91,#21,#91
	DB	#15,#8B,#8D,#07,#8A,#91,#21,#87,#E1,#91,#14,#91,#20,#8B,#8D,#07
	DB	#8A,#91,#14,#91,#20,#91,#14,#8B,#8D,#07,#8A,#91,#20,#87,#E1,#91
	DB	#16,#91,#22,#8B,#8D,#07,#8A,#91,#16,#91,#22,#91,#16,#8B,#8D,#07
	DB	#8A,#91,#22,#87,#E1,#91,#11,#91,#1D,#8B,#8D,#07,#8A,#91,#11,#91
	DB	#1D,#91,#11,#8B,#8D,#07,#8A,#91,#1D,#87,#C0,#DE,#00,#11,#0F,#E1
	DB	#8C,#4F,#4F,#8A,#2E,#8C,#4F,#8A,#2D,#2E,#8C,#4F,#8A,#2B,#8C,#4F
	DB	#8A,#2B,#E3,#2E,#E1,#2D,#2E,#DF,#00,#41,#03,#84,#14,#01,#2B,#84
	DB	#14,#01,#2B,#87,#DF,#00,#11,#0F,#8A,#C6,#E1,#25,#24,#1F,#E3,#25
	DB	#E1,#24,#1F,#E3,#25,#E1,#24,#1F,#E3,#25,#E1,#24,#1F,#25,#C0,#87
	DB	#DE,#00,#11,#0F,#E1,#8C,#4F,#8A,#2E,#30,#8C,#4F,#2E,#2C,#DF,#00
	DB	#41,#03,#8A,#84,#14,#01,#2B,#84,#14,#01,#2B,#87,#DF,#00,#11,#0F
	DB	#E1,#8A,#C1,#2E,#2E,#C2,#2E,#8C,#C0,#46,#8A,#C1,#2E,#C0,#8C,#46
	DB	#8A,#C2,#2E,#C1,#2E,#C0,#8C,#46,#8A,#C1,#2E,#C2,#2E,#C0,#8C,#46
	DB	#87,#DF,#00,#11,#0F,#E1,#8A,#C1,#30,#30,#C2,#30,#8C,#C0,#3E,#8A
	DB	#C1,#30,#C0,#8C,#3E,#8A,#C2,#30,#C1,#30,#C0,#8C,#3E,#8A,#C1,#30
	DB	#C2,#30,#C0,#8C,#3E,#87,#E1,#C5,#8A,#35,#35,#35,#84,#3C,#01,#52
	DB	#35,#84,#3C,#01,#52,#35,#35,#84,#3C,#01,#52,#35,#35,#84,#3C,#01
	DB	#52,#87,#E1,#C1,#8A,#37,#37,#37,#84,#3C,#01,#52,#37,#84,#3C,#01
	DB	#52,#37,#37,#84,#3C,#01,#52,#37,#37,#84,#3C,#01,#52,#87,#E1,#C2
	DB	#8A,#36,#36,#36,#84,#3C,#01,#52,#36,#84,#3C,#01,#52,#36,#36,#84
	DB	#3C,#01,#52,#36,#36,#84,#3C,#01,#52,#87,#C6,#E5,#26,#2E,#E3,#26
	DB	#EF,#27,#E5,#27,#30,#E3,#2D,#EF,#2E,#E5,#2B,#35,#E3,#32,#EF,#33
	DB	#E5,#2A,#30,#E3,#2D,#EF,#2B,#87,#C0,#E3,#8A,#22,#E1,#43,#2B,#43
	DB	#43,#E3,#22,#E3,#24,#E1,#43,#24,#43,#43,#E3,#24,#E3,#24,#E1,#43
	DB	#2D,#43,#43,#E3,#2A,#E3,#2B,#E1,#43,#2B,#43,#43,#E3,#2B,#E3,#2F
	DB	#E1,#43,#32,#43,#43,#E3,#2F,#E3,#30,#E1,#43,#30,#43,#43,#E3,#30
	DB	#E3,#26,#E1,#43,#2D,#43,#43,#E3,#2A,#E3,#26,#E1,#43,#26,#43,#43
	DB	#E3,#26,#87,#E5,#2D,#2E,#EB,#2B,#EF,#90,#37,#FF,#90,#43,#F7,#90
	DB	#43,#87,#E0,#8F,#87,#DF,#00,#11,#01,#8A,#C4,#EF,#3E,#87,#FF,#84
	DB	#FF,#10,#1F,#84,#FF,#01,#24,#87,#FF,#80,#87,#00,#21,#AB,#1A,#36
	DB	#00,#21,#A8,#1B,#87,#85,#6F,#30,#01,#24,#5E,#23,#56,#06,#11,#21
	DB	#53,#1C,#1A,#77,#23,#13,#10,#FA,#3A,#54,#1C,#32,#64,#1C,#2A,#55
	DB	#1C,#22,#9B,#1B,#ED,#5B,#57,#1C,#ED,#53,#9F,#1B,#7D,#32,#A1,#1B
	DB	#3A,#5A,#1C,#32,#A2,#1B,#3A,#59,#1C,#5F,#16,#0C,#CD,#85,#11,#3A
	DB	#63,#1C,#5F,#16,#0D,#CD,#85,#11,#21,#AB,#1A,#34,#C9,#32,#AB,#1A
	DB	#C3,#78,#11,#CD,#66,#1C,#3A,#AB,#1A,#A7,#C8,#3A,#53,#1C,#A7,#28
	DB	#EC,#3D,#32,#53,#1C,#3A,#64,#1C,#A7,#20,#2F,#3A,#61,#1C,#A7,#C8
	DB	#3D,#32,#61,#1C,#3A,#54,#1C,#32,#64,#1C,#3A,#62,#1C,#A7,#28,#03
	DB	#3A,#81,#1C,#47,#3A,#55,#1C,#80,#32,#9B,#1B,#3A,#56,#1C,#80,#E6
	DB	#0F,#32,#9C,#1B,#2A,#57,#1C,#22,#9F,#1B,#21,#64,#1C,#35,#3A,#5F
	DB	#1C,#A7,#28,#1D,#F2,#64,#1B,#2A,#9B,#1B,#ED,#5B,#5B,#1C,#19,#22
	DB	#9B,#1B,#18,#0D,#2A,#9B,#1B,#ED,#5B,#5B,#1C,#A7,#ED,#52,#22,#9B
	DB	#1B,#3A,#60,#1C,#A7,#28,#1D,#F2,#87,#1B,#2A,#9F,#1B,#ED,#5B,#5D
	DB	#1C,#19,#22,#9F,#1B,#18,#0D,#2A,#9F,#1B,#ED,#5B,#5D,#1C,#A7,#ED
	DB	#52,#22,#9F,#1B,#3A,#9B,#1B,#32,#A1,#1B,#C9,#00,#00,#00,#00,#00
	DB	#00,#00,#3F,#10,#00,#10,#00,#FF,#BA,#1B,#CB,#1B,#DC,#1B,#ED,#1B
	DB	#FE,#1B,#0F,#1C,#20,#1C,#31,#1C,#42,#1C,#3C,#46,#80,#00,#A0,#00
	DB	#28,#F2,#29,#00,#11,#00,#FF,#FF,#0A,#00,#00,#3C,#02,#80,#00,#85
	DB	#00,#28,#F2,#13,#00,#10,#00,#FF,#FF,#14,#00,#00,#2D,#07,#08,#00
	DB	#10,#00,#14,#FA,#18,#00,#10,#00,#FF,#01,#05,#00,#00,#55,#0A,#40
	DB	#00,#3B,#00,#1E,#FA,#01,#00,#02,#00,#01,#FF,#0A,#00,#00,#32,#1A
	DB	#B8,#00,#98,#00,#1E,#D7,#03,#00,#04,#00,#01,#01,#03,#01,#00,#64
	DB	#04,#42,#00,#7C,#00,#28,#FA,#09,#00,#11,#00,#FF,#FF,#3C,#00,#00
	DB	#3C,#06,#8F,#00,#7F,#00,#1E,#FA,#01,#00,#01,#00,#01,#01,#08,#00
	DB	#00,#78,#05,#8A,#00,#80,#00,#30,#FA,#16,#00,#12,#00,#01,#01,#2D
	DB	#00,#00,#46,#48,#02,#01,#08,#01,#28,#FA,#08,#00,#06,#00,#01,#01
	DB	#0F,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#3A,#81,#1C,#E6,#48,#CE,#38,#CB,#27,#CB
	DB	#27,#21,#84,#1C,#CB,#16,#2B,#CB,#16,#2B,#CB,#16,#2B,#CB,#16,#7E
	DB	#C9,#00,#00,#00,#00
	

democmp:
	LD	BC,#BC01
	XOR	A
	OUT	(C),C
	INC	B
	OUT	(C),A

	LD	HL,#C000
	LD	DE,#C001
	LD	BC,#3FFF
	LD	(HL),L
	LDIR

	ld de,#f800+#310+#62
	ld hl,PALMIERDATA
	push	hl
	push	hl
	push	hl
	ld bc,#4D10
	call AfficheSpriteMasque

	ld de,#fb10+#19+#62  ;C24C
	pop	hl
	ld bc,#4D10
	call AfficheSpriteMasque

	ld de,#fb10+#31+#62
	pop	hl
	ld bc,#4D10
	call AfficheSpriteMasque

	ld de,#fb10+#50+#62
	pop	hl
	ld bc,#4D10
	call AfficheSpriteMasque

	ld hl,CHOLOGO
	ld de,#C800+8
	ld bc,#264F
	call AfficheSpriteMasque

	ld hl,SOLEILDATA
	ld de,#ECFA+47  ;DBBE > DD5C
    ld bc,#2D13
	call AfficheSpriteMasque

;;;;;;;;;;;;;;;;;;;;;; 


	
	LD HL,CHAINE
	LD	DE,#C7A8
Impact1:
	LD	A,(HL)
	CP #FF
	jr z,initscr
	PUSH HL
	   SUB A,#20 ;#41   ;lettre-41H=valeur dans la fonte
	   ADD	A,A
	LD	L,A
	LD	H,0
	   ADD HL,HL
	   ADD HL,HL   
	   ADD HL,HL  ;X16 une lettre=8 octets en Vertical X 2 colonnes
	   LD BC,FONTE
	   ADD HL,BC
	LD B,8
	PUSH DE
SetChar1:
	LD A,(HL)
	LD (DE),A
	LD A,D
	ADD A,8
	LD D,A
	INC HL
	DJNZ SetChar1
	POP DE
	INC DE
	PUSH DE
	LD	B,8
SetChar2
LD A,(HL)
	LD (DE),A
	LD A,D
	ADD A,8
	LD D,A
	INC HL
	DJNZ SetChar2
	POP	DE
	INC DE
	POP HL
	INC HL
	JR Impact1

initscr

	di
	ld hl,sauvIrq
	ld (#39),hl
 	LD hl,#c9fb
 	LD (#38),hl
	ei

	ld bc,#bc01
	out (c),c
	ld bc,#BD31
	out (c),c

	ld bc,#bc02
	out (c),c
	ld bc,#BD32
	out (c),c

	ld bc,#bc07
	out (c),c
	ld bc,#BD23
 	out (c),c

	ld bc,#bc06
	out (c),c
	ld bc,#BD15
	out (c),c

main   
        LD b,#F5
sync   IN a,(c)
 	RRA 
    jr nc,sync

	ld bc,#7F00
	out (c),c
	ld a,#5C
	out (c),a

	inc c
	out (c),c
	ld a,#4B
	out (c),a

	inc c
	out (c),c
	ld a,#4C
	out (c),a

	inc c
	out (c),c
	ld a,#40
	out (c),a

	ld c,#10
	out (c),c
	ld a,#5C
	out (c),a
	LD C,#8D  ;mode 2 avant
	out (c),c
	ds 9,0

	ld b,32-2
pasvu   ds 60,0
	djnz pasvu
; la partie visible de l''ecran commence ici

	call pallogo ;prend 38 lignes
	ds 22,0
	call palscroller ; prend 8 lignes
	
	ld b,4
wait    ds 60,0
	djnz wait

	EI
	HALT
	ds 5,0
	call palpalmier

	ld bc,#7F00
	out (c),c
	ld a,#4A 
	out (c),a

	ld b,3 ;2 lignes de jaunes pour simuler la plage
r3      ds 60,0
	djnz r3

	ld bc,#7F00
	out (c),c
	ld a,#53 
	out (c),a

	ld bc,#7F10
	out (c),c
	ld a,#44
	out (c),a
	ld b,60
r4	djnz r4

	ld bc,#7F10
	out (c),c
	ld a,#4A ;#55
	out (c),a
	ld b,53
r5	djnz r5

; splits mer
	DI
	ld hl,tblsplit
	ld bc,#7F10
	out (c),c

	ld a,8
rastsplt
	ex af,af''
	inc b
	outi 
	ds 4,0

	inc b
	outi 
	ds 4,0

	inc b
	outi 
	ds 4,0

	inc b
	outi 
	ds 4,0

	inc b
	outi
	ds 4,0

	inc b
	outi
	ds 4,0

	inc b
	outi
	ds 4,0

	DS 10,0
 
	ex af,af''
	dec a
	jr nz,rastsplt
	EI

	ld a,#5F 
	out (c),a

scrollsun:
	ld hl,finsoleil-2
	ld de,finsoleil-1
	ld a,(de)
	LD	BC,107
scrollsens:
	LDDR
	ld (de),a


	ds 10,0

	ld bc,#7F10
	out (c),c
	LD A,#55
	OUT (c),a
  
	ld b,1
r33	djnz r33

	call scrol
	ds 34,0
	ld bc,#7F44
	out (c),c
	call matrice
	

	call animraster

	call PlayMusic

;
; Test Clavier
;
	LD bc,#F40E
	OUT (c),c
 	LD bc,#F6C0	
	OUT (c),c
 	XOR a
 	OUT (c),a
 	LD bc,#F792
 	OUT (c),c
 	DEC b
	LD c,#48       ;CTRL
	 OUT (c),c
 	LD b,#F4
 	IN a,(c)
 	LD bc,#F782
 	OUT (c),c
 	ld bc,#F600
 	OUT (c),c
 	bit 0,A
	jr z,key1
	bit 1,a
	jr z,key2
	bit 2,a
	jr z,keyEsc
	bit 3,a
	jr z,ScrollSunUp
	bit 5,a
	jr z,ScrollSunOff
	bit 7,a
	jr z,ScrollSunDown
	JP main

key1:
	call	baro
	jp 	main
key2:
	ld	a,#FF
	ld	(flagbar+1),a
	jp	main

ScrollSunOff:
	ld	hl,buffer
	ld 	(scrollsun+1),hl
	ld 	(scrollsun+4),hl
	jp 	main

ScrollSunUp:
	ld	hl,tableSoleil+1
	ld 	(scrollsun+1),hl
	dec	hl
	ld 	(scrollsun+4),hl
	ld	a,#B0
	ld	(scrollsens+1),a
	jp	main

ScrollSunDown:
	ld	hl,finsoleil-2
	ld 	(scrollsun+1),hl
	inc	hl
	ld 	(scrollsun+4),hl
	ld	a,#B8
	ld	(scrollsens+1),a
	jp	main
	
keyEsc:
	di
	ld a,#C7
	ld (democmp),a
	ld a,#C3
	ld (#38),a
	ld hl,#800
	ld (finirq+1),hl
	jp demoludo2
       
;;;;;;;;;;;;;;;;;;;;;;
;logo=38 ligne
pallogo 	
	DI
	ld hl,tblazur+3
	ld bc,#7F01
	out (c),c
	ds 8,0	


	ld a,38  ;50+16
rastaz	ex af,af''
	ld a,(hl)
	inc hl

	out (c),a
	
	ds 50,0
	ex af,af''
	dec a
	jp nz,rastaz
	EI
	ret


palscroller
	DI
	LD BC,#7F00
	ld hl,tblrast2
	ld de,tablefond2

	ld a,8
rasts	ex af,af''
	ld b,#7F
	ld a,(hl)
	inc hl
	out (c),c
	out (c),a

	inc c	
	ld a,(de)
	inc de
	out (c),c
	out (c),a
	dec c
	ld b,8
r11	djnz r11

	ex af,af''
	dec a
	jr nz,rasts
	EI
        ret


palpalmier

	EXX
	ld hl,tablesoleil
	LD BC,#7F02
	EXX

	ld hl,tblrast
ptr1	ld de,tablefond

	ld a,80 ;108
rast	ex af,af''
	ld b,#7F
	ld a,(hl)
	inc hl
	out (c),c
	out (c),a

	inc c	
	ld a,(de)
	inc de
	out (c),c
	out (c),a
	dec c
	
	EXX ;1
	ld a,(hl) ;2
	out (c),c ;4
	out (c),a ;4
	inc hl ;2
	EXX ;1
	nop
	nop
	nop
	ld b,3
r22	djnz r22

	ex af,af''
	dec a
	jr nz,rast
	EI
        ret


scrol


	LD   HL,ECRAN+1             
	LD   DE,ECRAN
	Repeat 70
	LDI
	Rend

	LD   HL,ECRAN+1+#800             
	LD   DE,ECRAN+#800
	Repeat 60
	LDI
	Rend

    	LD   HL,ECRAN+1+#1000        
	LD   DE,ECRAN+#1000
	Repeat 66
	LDI
	Rend
  
   	LD   HL,ECRAN+1+#1800           
	LD   DE,ECRAN+#1800
	Repeat 66
	LDI
	Rend
 
   	LD   HL,ECRAN+1+#2000   ;*4             
	LD   DE,ECRAN+#2000
	Repeat 66
	LDI
	Rend

   	LD   HL,ECRAN+1+#2800   ;*5             
	LD   DE,ECRAN+#2800
	Repeat 66
	LDI
	Rend

   	LD   HL,ECRAN+1+#3000   ;*6             
	LD   DE,ECRAN+#3000
	Repeat 66
	LDI
	Rend

   	LD   HL,ECRAN+1+#3800   ;*7            
	LD   DE,ECRAN+#3800
	Repeat 66
	LDI
	Rend

        ret 


matrice

colonneselect
	ld a,0
 	inc a
 	ld (colonneselect+1),a          ;2 octets de longueur a compter
	CP 2
 	JR nz,PtrLettre
 	ld a,0
	ld (colonneselect+1),a
	LD HL,(PTRLETTRE+1)
	INC HL
	LD (PTRLETTRE+1),HL
	LD A,(HL)
	CP #FF
	JR NZ,PtrLettre
	LD Hl,texte
	LD (PTRLETTRE+1),HL
	LD A,0
	LD (colonneselect+1),a
PtrLettre	
	LD HL,texte
	LD A,(HL)
	cp #80
	jr nz,lettreSuite
	ld hl,tablefond
	ld (ptr1+1),hl
	xor a
	ld (animraster+1),a
	ld (flagbar+1),a
	jr colonneselect
LettreSuite
	LD H,0
	SUB A,#20 ;#41   ;lettre-41H=valeur dans la fonte
	LD L,A
	ADD HL,HL
	ADD HL,HL
	ADD HL,HL   
	ADD HL,HL  ;X16 une lettre=8 octets en Vertical X 2 colonnes
	LD DE,FONTE
	ADD HL,DE  ;HL pointe sur la fonte
	LD D,0
	LD A,(colonneselect+1)
	ADD A,A
	ADD A,A
	ADD A,A  ;A=A*8 la taille d''une colonne
	LD E,A
	ADD HL,DE

	LD DE,ECRAN+66-1
	ld bc,#8FF
loopchar   ldi
	dec de

	push bc	   
	ld	bc,#800
	ex	de,hl
	add	hl,bc
	jr	nc,loopchar2
	ld	bc,#C062
	add	hl,bc
loopchar2	pop	bc
	ex	de,hl
	djnz	loopchar
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


animraster  ld a,0
	   inc a
	   CP 200
	   jr z,resetanim
	   ld (animraster+1),a

flagbar	ld a,#FF
	cp #FF
	jr nz,animSuite
	ld hl,tablefondfixe
	ld (ptr1+1),hl
	ret
animSuite
	   ld hl,(ptr1+1)
	   inc hl
	   ld (ptr1+1),hl
	   ret

resetanim  
	   ld a,(flagbar+1)
	   and a
           jr z,baro
	   CP 1
	   jr z,barv
           ret 
barv
	   ld hl,tablefond
	   ld (ptr1+1),hl
	   xor a
	   ld (animraster+1),a
	   ld (flagbar+1),a
	   ret	   

baro
	   ld hl,tablefondo
	   ld (ptr1+1),hl
	   xor a
	   ld (animraster+1),a
	   inc a
	   ld (flagbar+1),a
	   ret	   

AfficheSpriteMasque:
	push	bc
	push	de
masque:
	ld b,(HL)
	ld a,(de)
	and #F0
	jr z,nomasque
	rrca
	rrca
	rrca
	rrca
	cpl
	and b
	ld b,a
	ld a,(de)
nomasque
	or b
	ld (de),a

	inc hl
	inc de
	dec c
	jr nz,masque
	pop	de
	ld	bc,#800
	ex	de,hl
	add	hl,bc
	jr	nc,AfficheSpriteMasque2
	ld	bc,#C062
	add	hl,bc
AfficheSpriteMasque2:
	ex	de,hl
	pop	bc
	djnz	AfficheSpriteMasque
	ret


ECRAN  EQU #C9EA+15  ; #c000+7*98=&c2ae
                  
;

	;run	$
demoludo
	DI
	call InitMusic ;init warhwawk

	ld hl,(#39)
	ld	(sauvIrq),hl
demoLudo2:
	ld	hl,newirq
	ld	(#39),hl
	EI 
	LD	HL,#282E
	LD	BC,#BC01
	OUT	(C),C
	INC	B
	OUT	(C),H
	DEC	B
	INC	C
	OUT	(C),C
	INC	B
	OUT	(C),L
	LD	BC,#BC06
	LD	A,25
	OUT	(C),C
	INC	B
	OUT	(C),A
	LD	HL,Palette
	LD	B,#7F
	XOR	A
SetPal:
	OUT	(C),A
	INC	B
	OUTI
	INC	A
	CP	18
	JR	C,SetPal
	LD	HL,Delta0
Boucle:
	LD	A,(HL)
	INC	A
	JR	NZ,Boucle2
	LD	HL,Delta1
Boucle2:
	LD	DE,Buffer
; Decompactage
DepkLzw:
	LD	A,(HL)			; DepackBits = InBuf[ InBytes++ ]
	INC	HL
	RRA				; Rotation rapide calcul seulement flag C
	SET	7,A			; Positionne bit 7 en gardant flag C
	LD	(BclLzw+1),A
	JR	C,TstCodeLzw
CopByteLzw:
	LDI				; OutBuf[ OutBytes++ ] = InBuf[ InBytes++ ]

BclLzw:
	LD	A,0
	RR	A			; Rotation avec calcul Flags C et Z
	LD	(BclLzw+1),A
	JR	NC,CopByteLzw
	JR	Z,DepkLzw

TstCodeLzw:
	LD	A,(HL)			; A = InBuf[ InBytes ];
	AND	A
	Jr	Z,InitDraw		; Plus d''octets Ã  traiter = fini

	INC	HL
	LD	B,A			; B = InBuf[ InBytes ]
	RLCA				; A & #80 ?
	JR	NC,TstLzw40

	RLCA
	RLCA
	RLCA
	AND	7
	ADD	A,3			; Longueur = 3 + ( ( InBuf[ InBytes ] >> 4 ) & 7 );
	LD	C,A			; C = Longueur
	LD	A,B			; B = InBuf[InBytes]
	AND	#0F			; Delta = ( InBuf[ InBytes++ ] & 15 ) << 8
	LD	B,A			; B = poids fort Delta
	LD	A,C			; A = Length
	SCF				; Repositionner flag C (pour Delta++)
CopyBytes0:
	LD	C,(HL)			; C = poids faible Delta (Delta |= InBuf[ InBytes++ ]);
	INC	HL
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC			; HL=HL-(BC+1)
	LD	B,0
CopyBytes1:
	LD	C,A
CopyBytes2:
	LDIR
CopyBytes3:
	POP	HL
	JR	BclLzw

TstLzw40:
	RLCA				; A & #40 ?
	JR	NC,TstLzw20

	LD	C,B
	RES	6,C			; Delta = 1 + InBuf[ InBytes++ ] & #3f;
	LD	B,0			; BC = Delta + 1 car flag C = 1
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC
	LDI
	LDI				; Longueur = 2
	JR	CopyBytes3

TstLzw20:
	RLCA				; A & #20 ?
	JR	NC,TstLzw10

	LD	A,B			; B compris entre #20 et #3F
	ADD	A,#E2			; = ( A AND #1F ) + 2, et positionne carry
	LD	B,0			; Longueur = 2 + ( InBuf[ InBytes++ ] & 31 );
	JR	CopyBytes0

CodeLzw0F:
	LD	C,(HL)
	PUSH	HL
	LD	H,D
	LD	L,E
	CP	#F0
	JR	NZ,CodeLzw02

	XOR	A
	LD	B,A
	INC	BC			; Longueur = Delta = InBuf[ InBytes + 1 ] + 1;
	SBC	HL,BC
	LDIR
	POP	HL
	INC	HL			; Inbytes += 2
	JR	BclLzw

CodeLzw02:
	CP	#20
	JR	C,CodeLzw01

	LD	C,B			; Longueur = Delta = InBuf[ InBytes ];
	LD	B,0
	SBC	HL,BC
	JR	CopyBytes2

CodeLzw01:				; Ici, B = 1
	XOR	A			; Carry a zero
	DEC	H			; Longueur = Delta = 256
	JR	CopyBytes1

TstLzw10:
	RLCA				; A & #10 ?
	JR	NC,CodeLzw0F

	RES	4,B			; B = Delta(high) -> ( InBuf[ InBytes++ ] & 15 ) << 8;
	LD	C,(HL)			; C = Delta(low)  -> InBuf[ InBytes++ ];
	INC	HL
	LD	A,(HL)			; A = Longueur - 1
	INC	HL
	PUSH	HL
	LD	H,D
	LD	L,E
	SBC	HL,BC			; Flag C=1 -> hl=hl-(bc+1) (Delta+1)
	LD	B,0
	LD	C,A
	INC	BC			; BC =  Longueur = InBuf[ InBytes++ ] + 1;
	JR	CopyBytes2

InitDraw:
	PUSH	HL
	LD	HL,(finirq+1)
	ld	BC,skipanim
	SBC	HL,BC
	JP	NC,democmp
	LD	HL,Buffer
	LD	BC,#C000
	LD	D,FonteAscii/256
DrawImgO:
	LD	A,(HL)			; Code ASCII
	AND	#0F
	RLCA
	RLCA
	LD	E,A
	EX	DE,HL
	LD	A,(HL)
	INC	L
	LD	(BC),A
	SET	3,B
	LD	A,(HL)
	INC	L
	LD	(BC),A
	SET	4,B
	LD	A,(HL)
	INC	L
	LD	(BC),A
	RES	3,B
	LD	A,(HL)
	INC	L
	LD	(BC),A
	SET	5,B
	LD	A,(DE)			; Code ASCII
	AND	#F0
	RRCA
	RRCA
	ADD	A,3
	LD	L,A
	LD	A,(HL)
	DEC	L
	LD	(BC),A
	SET	3,B
	LD	A,(HL)
	DEC	L
	LD	(BC),A
	RES	4,B
	LD	A,(HL)
	DEC	L
	LD	(BC),A
	RES	3,B
	LD	A,(HL)
	LD	(BC),A
	RES	5,B
	EX	DE,HL
	INC	HL
	INC	BC
	BIT	3,B
	JR	Z,DrawImgO
	POP	HL
	INC	HL
	JP	Boucle
sauvirq:
	dw	0
newirq:
	di
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy
cpt:
	ld	A,0
	inc	a
	ld	(cpt+1),a
	cp	6
	jr	c,finirq
	xor	a
	ld	(cpt+1),a
	call	PlayMusic
finirq:
	ld	hl,0
	inc	hl
	ld	(finirq+1),hl
	pop	iy
	pop	ix
	pop	hl
	pop	de
	pop	bc	
	pop	af
	ei
	ret
Palette:
	DB	#4B,#4A,#57,#4E,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#4B,#8D
Delta0:		; Taille #019F
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#AB,#0F,#7F,#0F
	DB	#B3,#0C,#04,#00,#21,#03,#0C,#10,#4A,#41,#03,#20,#42,#02,#D0,#00
	DB	#00,#00,#D0,#DD,#4C,#00,#0C,#42,#50,#DC,#C0,#10,#4F,#3D,#0D,#81
	DB	#20,#4C,#20,#4D,#D4,#D2,#D4,#04,#21,#03,#32,#D4,#20,#52,#40,#0D
	DB	#24,#AA,#10,#4C,#34,#C0,#D0,#81,#20,#9B,#20,#44,#04,#0D,#0D,#40
	DB	#44,#03,#21,#A2,#02,#4D,#40,#04,#02,#40,#4D,#0E,#CD,#B1,#01,#10
	DB	#4E,#31,#20,#88,#4D,#44,#DD,#0D,#2B,#22,#48,#20,#A4,#D0,#22,#F4
	DB	#00,#22,#0C,#04,#4C,#94,#40,#DD,#10,#A1,#33,#C0,#20,#EA,#40,#D4
	DB	#22,#4E,#40,#D0,#DD,#FD,#F4,#F4,#4D,#20,#4B,#4D,#A5,#45,#FD,#22
	DB	#55,#04,#44,#20,#F7,#DC,#10,#A1,#2F,#85,#6F,#C0,#79,#D4,#4D,#DD
	DB	#DD,#02,#04,#4D,#4F,#20,#F2,#D4,#4F,#40,#40,#FF,#86,#D4,#22,#06
	DB	#21,#51,#D4,#44,#0D,#C0,#11,#96,#2B,#AB,#71,#20,#E9,#00,#20,#99
	DB	#DD,#20,#EC,#44,#22,#4F,#BE,#44,#20,#8F,#4D,#44,#02,#21,#4A,#44
	DB	#24,#11,#7C,#40,#DC,#10,#A0,#2B,#A1,#2F,#20,#82,#21,#9E,#23,#3D
	DB	#D4,#00,#D4,#04,#2D,#F4,#4F,#0D,#0D,#4F,#A0,#4D,#2D,#0D,#DF,#D4
	DB	#23,#4F,#04,#10,#9F,#2A,#ED,#21,#4D,#D0,#21,#9C,#21,#36,#DC,#20
	DB	#4F,#23,#F0,#22,#A6,#97,#81,#47,#23,#0A,#25,#0F,#D0,#10,#9F,#2A
	DB	#C0,#CD,#6E,#31,#02,#00,#4D,#04,#21,#DD,#25,#50,#F5,#5D,#60,#4D
	DB	#40,#40,#4D,#FD,#23,#9C,#81,#50,#42,#5D,#11,#DA,#30,#04,#02,#20
	DB	#E0,#43,#44,#26,#51,#45,#D0,#F5,#F5,#FF,#FF,#22,#4E,#4D,#4E,#20
	DB	#68,#75,#5B,#D0,#12,#81,#33,#C0,#22,#A0,#22,#51,#21,#52,#DF,#E8
	DB	#4F,#4F,#D4,#47,#4D,#81,#8F,#81,#97,#13,#6B,#36,#54,#00,#CD,#23
	DB	#51,#D4,#24,#55,#44,#24,#0A,#D4,#EC,#0C,#C0,#20,#BE,#14,#18,#38
	DB	#0C,#91,#E6,#21,#A0,#23,#A5,#E1,#45,#4F,#02,#C0,#CD,#10,#4C,#39
	DB	#21,#F1,#92,#16,#94,#D0,#0D,#47,#D4,#83,#C0,#DD,#00,#83,#32,#FB
	DB	#14,#FE,#42,#22,#53,#0D,#A1,#4E,#24,#0B,#16,#0E,#FF,#0D,#00
Delta1:		; Taille #01B4
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#13,#0F,#7F,#0F
	DB	#B4,#0C,#00,#21,#03,#CC,#00,#0C,#8B,#10,#4B,#45,#21,#49,#40,#44
	DB	#4D,#00,#00,#02,#09,#49,#CC,#0C,#10,#4B,#3D,#0C,#0D,#40,#40,#00
	DB	#40,#D4,#D4,#D4,#04,#04,#04,#D4,#82,#DD,#49,#00,#D0,#C0,#0C,#C0
	DB	#10,#4D,#37,#04,#CC,#C0,#7E,#40,#D2,#04,#0D,#DD,#04,#4D,#44,#22
	DB	#9C,#00,#44,#4D,#DD,#04,#E0,#44,#40,#D0,#00,#C0,#10,#A4,#34,#20
	DB	#9A,#20,#41,#DA,#20,#20,#93,#0D,#45,#42,#D0,#23,#4F,#45,#1F,#21
	DB	#0C,#21,#51,#20,#52,#10,#A2,#32,#20,#4E,#CC,#0D,#44,#83,#20,#4E
	DB	#20,#43,#D0,#D0,#4D,#24,#34,#20,#99,#11,#21,#A5,#F4,#24,#FD,#47
	DB	#D0,#DD,#D4,#3A,#24,#5B,#0C,#10,#A1,#2F,#70,#20,#47,#42,#D4,#05
	DB	#7E,#DD,#02,#44,#12,#CC,#5E,#1E,#82,#54,#20,#ED,#2F,#C1,#EE,#11
	DB	#2F,#21,#0F,#71,#20,#FD,#44,#0D,#C0,#10,#9B,#2F,#81,#8B,#20,#41
	DB	#DD,#81,#23,#4F,#4F,#11,#1E,#EE,#13,#55,#46,#20,#31,#E5,#5E,#11
	DB	#33,#22,#5F,#DD,#F2,#7C,#4C,#DC,#10,#A0,#26,#81,#25,#21,#28,#20
	DB	#9A,#21,#4E,#D0,#0A,#40,#20,#87,#44,#22,#4F,#D4,#D2,#05,#2E,#00
	DB	#21,#D4,#00,#D4,#43,#2E,#01,#03,#62,#DF,#23,#4F,#44,#CD,#CD,#10
	DB	#A0,#26,#20,#46,#0D,#FD,#70,#DC,#43,#22,#7D,#20,#9F,#20,#4F,#23
	DB	#A0,#22,#F6,#FF,#81,#89,#22,#0A,#23,#EE,#02,#91,#E3,#10,#4F,#26
	DB	#70,#42,#68,#D0,#DD,#02,#92,#2B,#44,#25,#A0,#20,#50,#5F,#80,#5D
	DB	#4D,#40,#40,#FD,#FD,#D4,#A1,#4E,#9D,#54,#20,#20,#4E,#10,#4F,#28
	DB	#22,#4D,#4D,#C4,#49,#13,#71,#4B,#24,#44,#26,#A2,#4F,#FF,#FF,#F5
	DB	#02,#D4,#B1,#8C,#44,#22,#9E,#10,#4F,#26,#67,#68,#43,#25,#2B,#20
	DB	#4F,#D0,#0D,#04,#44,#26,#51,#D4,#D4,#4F,#4F,#20,#4B,#4D,#23,#4D
	DB	#D4,#81,#62,#13,#23,#35,#BD,#20,#A1,#D2,#22,#3F,#23,#54,#05,#23
	DB	#4D,#CD,#10,#9D,#28,#05,#2E,#AC,#CC,#81,#76,#00,#02,#D4,#24,#2D
	DB	#ED,#23,#A5,#4D,#21,#AD,#50,#0D,#14,#66,#3D,#22,#53,#02,#FE,#DD
	DB	#21,#93,#20,#98,#22,#4C,#14,#B2,#43,#81,#52,#04,#10,#E5,#36,#03
	DB	#16,#1A,#DD,#00
Delta2:		; Taille #01B8
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#93,#0F,#7F,#0F
	DB	#B5,#00,#0C,#43,#0C,#00,#22,#09,#02,#0C,#10,#4B,#44,#00,#DD,#0C
	DB	#0C,#20,#4D,#31,#48,#0C,#D0,#C0,#10,#52,#3C,#23,#4B,#4D,#40,#20
	DB	#0C,#44,#D4,#D4,#D2,#42,#D0,#4C,#14,#44,#4D,#21,#52,#00,#10,#9C
	DB	#3A,#0D,#4D,#4C,#80,#40,#04,#0D,#00,#0D,#44,#44,#44,#33,#45,#20
	DB	#5A,#4D,#D2,#48,#20,#52,#DC,#00,#02,#C0,#10,#4B,#32,#C0,#00,#DC
	DB	#DC,#2C,#D4,#36,#DD,#20,#47,#21,#49,#D0,#22,#05,#03,#04,#D4,#A3
	DB	#42,#20,#A4,#0D,#C0,#0C,#10,#F4,#34,#00,#20,#E7,#04,#DD,#DD,#20
	DB	#4A,#D0,#40,#F4,#34,#F4,#F6,#4D,#21,#09,#20,#9E,#4D,#22,#58,#20
	DB	#AC,#20,#51,#10,#A1,#30,#33,#76,#20,#46,#40,#D4,#21,#45,#02,#4D
	DB	#2F,#00,#CC,#31,#EE,#35,#40,#00,#F4,#C4,#88,#13,#E2,#34,#22,#11
	DB	#44,#42,#DC,#10,#A0,#2B,#CE,#0C,#81,#86,#20,#D2,#20,#81,#00,#24
	DB	#79,#22,#4F,#00,#44,#21,#11,#EE,#1E,#51,#D4,#44,#60,#33,#EC,#E5
	DB	#33,#11,#21,#11,#20,#B5,#44,#BA,#04,#5F,#C0,#10,#9B,#2C,#02,#20
	DB	#DE,#42,#20,#D8,#01,#23,#4F,#DD,#D2,#03,#2E,#21,#D2,#0D,#C0,#D4
	DB	#23,#E1,#55,#51,#53,#81,#01,#54,#F0,#F4,#40,#DC,#DC,#10,#A0,#27
	DB	#20,#9D,#21,#4B,#21,#44,#7C,#D0,#D0,#02,#81,#29,#22,#0A,#22,#F6
	DB	#81,#94,#D4,#86,#D0,#23,#18,#20,#4F,#4D,#24,#CD,#C0,#10,#9F,#29
	DB	#6D,#69,#0D,#20,#4C,#21,#3F,#4D,#21,#9E,#25,#A0,#4F,#A8,#54,#FD
	DB	#40,#52,#4D,#23,#5C,#DD,#22,#17,#04,#DD,#DC,#11,#E0,#2C,#CD,#0D
	DB	#0D,#0D,#C4,#47,#20,#80,#81,#C9,#25,#A1,#DF,#FF,#FF,#02,#4F,#1D
	DB	#26,#4D,#42,#22,#4C,#12,#82,#30,#20,#F8,#04,#04,#04,#61,#26,#51
	DB	#D4,#4F,#4F,#D4,#21,#A0,#23,#B2,#C4,#F8,#04,#0D,#D0,#13,#74,#36
	DB	#91,#41,#23,#43,#05,#04,#B0,#24,#04,#D4,#D0,#10,#9D,#33,#B1,#E8
	DB	#CD,#22,#F4,#08,#04,#24,#FD,#23,#4A,#4D,#F4,#24,#0F,#2C,#44,#DD
	DB	#93,#38,#14,#5F,#3B,#DD,#21,#8A,#D4,#04,#60,#C0,#02,#D4,#00,#00
	DB	#42,#20,#4B,#0D,#5B,#10,#4C,#3C,#25,#D8,#0D,#04,#21,#0B,#0D,#15
	DB	#53,#4A,#C0,#03,#16,#19,#C4,#00
Delta3:		; Taille #01CF
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#CB,#0F,#7F,#0F
	DB	#B2,#0C,#03,#CC,#00,#03,#02,#41,#10,#4F,#44,#00,#D0,#0C,#00,#00
	DB	#22,#04,#D0,#49,#20,#4F,#0C,#D0,#10,#53,#3D,#C0,#DC,#21,#97,#4D
	DB	#00,#4D,#40,#44,#44,#D4,#D4,#D4,#44,#10,#4D,#4C,#4D,#DD,#20,#A8
	DB	#D0,#D0,#C0,#09,#10,#E8,#38,#C0,#0D,#20,#4B,#42,#D4,#04,#0D,#21
	DB	#20,#9B,#4D,#44,#0D,#0D,#46,#0D,#04,#D7,#21,#55,#10,#A6,#37,#21
	DB	#E1,#D0,#20,#99,#D4,#20,#45,#21,#EE,#03,#21,#F0,#23,#05,#04,#44
	DB	#D0,#D4,#40,#4D,#2C,#0D,#C0,#23,#6D,#10,#ED,#30,#00,#20,#4D,#DD
	DB	#DD,#A6,#DD,#20,#55,#20,#9D,#24,#24,#21,#EA,#0D,#21,#09,#82,#D0
	DB	#21,#A4,#44,#40,#40,#D0,#CD,#10,#F4,#2F,#33,#20,#9D,#20,#49,#4D
	DB	#D4,#20,#45,#21,#50,#DD,#24,#40,#12,#CC,#EE,#15,#44,#00,#20,#55
	DB	#14,#48,#14,#F4,#4D,#20,#52,#DD,#4F,#21,#EE,#0C,#8D,#10,#A0,#2D
	DB	#00,#20,#9C,#20,#DC,#04,#DD,#44,#22,#4E,#40,#44,#22,#11,#EE,#1E
	DB	#11,#20,#95,#54,#10,#1C,#51,#EE,#11,#22,#11,#44,#44,#04,#DE,#CD
	DB	#10,#A0,#2B,#20,#7B,#82,#22,#76,#00,#81,#D7,#23,#9F,#00,#D2,#03
	DB	#2E,#21,#43,#0D,#D4,#33,#30,#E3,#3E,#13,#31,#21,#11,#42,#F2,#4C
	DB	#B6,#DC,#10,#9F,#2B,#20,#9B,#DD,#20,#D4,#21,#EE,#44,#25,#4F,#83
	DB	#22,#F6,#21,#60,#D4,#D3,#D3,#D2,#DF,#22,#9E,#38,#4D,#2F,#C4,#21
	DB	#9F,#11,#41,#2B,#81,#84,#00,#0D,#49,#20,#91,#D0,#DC,#B1,#40,#F5
	DB	#5D,#91,#36,#DD,#1B,#24,#0C,#21,#65,#44,#58,#11,#3E,#2D,#C0,#0D
	DB	#2D,#60,#4D,#40,#4D,#D4,#F4,#21,#3A,#22,#44,#D4,#E0,#F5,#F5,#FF
	DB	#FF,#FF,#22,#9B,#20,#53,#21,#B5,#18,#42,#00,#C0,#11,#DF,#30,#91
	DB	#E0,#04,#04,#24,#C7,#22,#8C,#20,#42,#20,#46,#4F,#4F,#4F,#25,#4C
	DB	#81,#8C,#4E,#D4,#20,#BE,#12,#7E,#33,#20,#82,#0C,#D0,#21,#3E,#D4
	DB	#3F,#22,#43,#21,#55,#24,#06,#22,#EC,#21,#1A,#13,#73,#34,#00,#CD
	DB	#91,#20,#D8,#C0,#D4,#4F,#27,#4A,#FD,#24,#83,#1F,#8B,#81,#0B,#14
	DB	#14,#3B,#00,#21,#3D,#00,#D4,#04,#20,#56,#DC,#D4,#02,#20,#4C,#4A
	DB	#20,#4C,#0C,#14,#AE,#3D,#22,#D8,#93,#20,#52,#45,#00,#DD,#20,#4C
	DB	#0D,#0D,#25,#10,#36,#CC,#10,#53,#41,#05,#C0,#16,#1C,#BF,#00
Delta4:		; Taille #01D8
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#AB,#0F,#7F,#0F
	DB	#B4,#0C,#22,#04,#D0,#22,#05,#00,#26,#0D,#D1,#10,#4A,#3C,#00,#D0
	DB	#00,#47,#DD,#44,#20,#53,#92,#00,#43,#0C,#00,#10,#9B,#3C,#0D,#DC
	DB	#20,#4B,#80,#00,#4D,#44,#40,#40,#44,#44,#44,#10,#44,#4D,#40,#D0
	DB	#20,#57,#C0,#CC,#DC,#2A,#C0,#10,#9D,#36,#0C,#02,#0D,#20,#4C,#44
	DB	#04,#04,#DD,#0D,#20,#99,#4D,#4D,#4D,#0D,#0D,#60,#0D,#D4,#44,#20
	DB	#4C,#4D,#20,#AE,#0C,#F7,#10,#F6,#34,#20,#4C,#20,#4D,#D4,#22,#4C
	DB	#02,#04,#04,#D4,#40,#4D,#20,#52,#4D,#20,#A5,#C0,#10,#4F,#30,#20
	DB	#81,#35,#7C,#DC,#21,#E2,#DD,#20,#E1,#02,#40,#FD,#8E,#24,#21,#9E
	DB	#81,#48,#02,#04,#D0,#0D,#22,#F7,#84,#DC,#0C,#10,#F4,#2F,#C0,#CD
	DB	#DD,#44,#22,#4E,#01,#02,#DD,#4D,#24,#CC,#31,#EE,#5F,#F2,#DD,#20
	DB	#F3,#F4,#F4,#20,#4A,#21,#A4,#57,#20,#5B,#A2,#0C,#11,#37,#2C,#CC
	DB	#00,#C0,#21,#DB,#44,#20,#51,#01,#23,#4E,#FF,#11,#3E,#5E,#1E,#55
	DB	#D0,#C0,#F4,#14,#C1,#E1,#13,#F4,#21,#10,#20,#F2,#B5,#21,#B5,#00
	DB	#10,#A0,#28,#C0,#21,#EA,#02,#0D,#20,#D7,#03,#81,#D4,#23,#9F,#D0
	DB	#D2,#2E,#21,#43,#04,#80,#DD,#32,#11,#E5,#3E,#11,#42,#22,#10,#67
	DB	#20,#B7,#10,#9F,#29,#21,#4C,#D0,#0D,#21,#33,#45,#D0,#CE,#D0,#25
	DB	#F0,#22,#05,#20,#E1,#DD,#42,#20,#55,#20,#56,#72,#D4,#21,#0E,#DD
	DB	#F4,#42,#81,#41,#10,#9E,#27,#C0,#CF,#21,#91,#20,#52,#20,#53,#28
	DB	#A0,#55,#FD,#81,#8A,#23,#09,#1F,#22,#FE,#22,#15,#11,#3F,#2B,#20
	DB	#51,#82,#28,#2D,#04,#04,#07,#20,#9E,#20,#87,#24,#A1,#4F,#F5,#FF
	DB	#F4,#F4,#08,#F4,#D4,#D4,#24,#4E,#4D,#4F,#4D,#0D,#63,#10,#9E,#29
	DB	#E1,#94,#0D,#CD,#04,#22,#A0,#23,#51,#4F,#38,#4F,#FF,#DF,#23,#4C
	DB	#22,#9C,#02,#00,#C0,#A9,#12,#CF,#33,#0C,#C0,#20,#A1,#4F,#20,#A2
	DB	#D4,#25,#55,#23,#25,#4B,#83,#2F,#0D,#0D,#D0,#10,#4F,#34,#0D,#C0
	DB	#9C,#C0,#00,#20,#E4,#21,#4A,#42,#D4,#D4,#24,#56,#E0,#4F,#D4,#04
	DB	#D4,#D0,#91,#12,#13,#C2,#35,#20,#D7,#78,#DD,#CD,#00,#83,#B5,#20
	DB	#44,#21,#49,#22,#99,#DD,#DD,#84,#63,#C0,#14,#63,#3A,#21,#3A,#7E
	DB	#0D,#82,#DE,#21,#48,#B3,#43,#21,#96,#CD,#0C,#15,#50,#40,#23,#DB
	DB	#0D,#C5,#4F,#03,#16,#1A,#BC,#00
Delta5:		; Taille #020C
	DB	#F8,#C0,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#57,#0F,#3F,#0F,#7F
	DB	#0F,#6A,#0C,#10,#49,#48,#C0,#23,#4A,#D0,#A5,#22,#53,#00,#10,#95
	DB	#44,#DD,#DC,#21,#08,#DD,#21,#0A,#24,#D0,#00,#10,#53,#40,#DD,#D0
	DB	#20,#47,#00,#4D,#C0,#40,#2C,#40,#44,#40,#0C,#43,#20,#4B,#48,#D0
	DB	#DD,#C0,#10,#53,#38,#00,#DC,#20,#4B,#C0,#02,#DD,#20,#48,#D2,#04
	DB	#D4,#0D,#0D,#0D,#00,#40,#4D,#4D,#D4,#D0,#D4,#44,#DD,#70,#CC,#DC
	DB	#D0,#0D,#11,#4F,#36,#20,#4C,#20,#99,#42,#A0,#D4,#DD,#0D,#00,#00
	DB	#02,#00,#21,#52,#65,#22,#06,#DD,#20,#52,#4D,#0C,#21,#52,#13,#0B
	DB	#2E,#C0,#03,#20,#9C,#20,#9D,#0C,#0C,#24,#D4,#4D,#DD,#42,#DD,#20
	DB	#F3,#D0,#40,#FD,#FD,#48,#D0,#A2,#00,#02,#00,#04,#44,#02,#4D,#22
	DB	#4D,#E2,#0C,#10,#A1,#2F,#C0,#0D,#44,#20,#DD,#02,#21,#4F,#80,#DD
	DB	#F4,#12,#CC,#E1,#13,#F4,#20,#9F,#FD,#20,#AF,#4D,#20,#99,#20,#53
	DB	#57,#21,#B4,#10,#A0,#27,#23,#77,#33,#21,#9A,#20,#D4,#DC,#40,#78
	DB	#23,#4F,#44,#33,#00,#E1,#EE,#3E,#11,#44,#40,#F4,#CF,#CC,#12,#C4
	DB	#50,#21,#F3,#44,#D0,#22,#20,#10,#A0,#24,#87,#20,#E8,#20,#D5,#81
	DB	#8A,#00,#0D,#CD,#0D,#20,#D8,#81,#25,#4F,#DD,#D2,#2E,#31,#21,#D2
	DB	#20,#A5,#40,#13,#EC,#EE,#11,#22,#D4,#22,#60,#44,#95,#5E,#CD,#10
	DB	#A0,#23,#0C,#20,#4E,#0C,#0D,#82,#23,#0B,#72,#21,#7E,#4C,#26,#4F
	DB	#44,#4D,#DD,#D4,#81,#21,#EC,#F5,#E1,#1E,#11,#31,#42,#21,#0F,#EA
	DB	#D4,#20,#AA,#4C,#11,#3E,#26,#C0,#20,#50,#21,#30,#7C,#1A,#44,#20
	DB	#7F,#0D,#23,#A0,#91,#8F,#DD,#55,#4D,#AB,#81,#89,#91,#98,#D2,#21
	DB	#9D,#4D,#81,#55,#C4,#5E,#EF,#10,#A0,#25,#21,#E8,#75,#21,#33,#C2
	DB	#21,#AB,#A1,#3F,#23,#50,#70,#FF,#F5,#FF,#FD,#91,#E1,#23,#FC,#52
	DB	#F4,#CE,#44,#93,#32,#10,#9F,#26,#20,#75,#C0,#C4,#22,#4D,#20,#58
	DB	#30,#C4,#C4,#C4,#F4,#22,#50,#21,#ED,#4F,#FF,#DC,#FF,#DF,#23,#4C
	DB	#4C,#21,#11,#42,#64,#20,#9D,#EA,#00,#12,#D1,#31,#0C,#7C,#4F,#22
	DB	#A2,#23,#A6,#20,#49,#C3,#23,#4B,#20,#9C,#2F,#04,#D4,#D0,#13,#1D
	DB	#33,#20,#A1,#A6,#CD,#21,#AC,#20,#9A,#44,#2D,#82,#6F,#D4,#24,#55
	DB	#1F,#20,#AF,#81,#53,#83,#85,#10,#9D,#33,#05,#D0,#0D,#CD,#2A,#CC
	DB	#82,#BF,#C4,#42,#24,#20,#49,#4F,#C4,#A1,#20,#57,#0C,#C0,#0D,#DD
	DB	#15,#0B,#39,#00,#91,#C3,#92,#DD,#83,#FF,#DD,#D4,#49,#DD,#04,#83
	DB	#33,#2B,#95,#07,#16,#C7,#3D,#0C,#22,#3E,#00,#84,#A2,#C0,#00,#1F
	DB	#10,#4B,#40,#11,#F8,#0A,#10,#4B,#4A,#0F,#27,#00
Delta6:		; Taille #020D
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#2B,#0F,#7F,#0F
	DB	#6D,#0C,#10,#49,#48,#00,#22,#4A,#0C,#00,#53,#05,#10,#4A,#3E,#C0
	DB	#DC,#22,#4F,#DD,#20,#50,#00,#E4,#D0,#DD,#21,#4E,#DD,#C0,#10,#53
	DB	#3B,#22,#96,#20,#4B,#01,#20,#51,#C0,#44,#44,#4C,#20,#4D,#4D,#7C
	DB	#00,#2C,#43,#53,#22,#57,#45,#10,#FC,#34,#C0,#14,#00,#DC,#77,#0D
	DB	#20,#44,#40,#D4,#04,#00,#04,#0D,#0D,#0D,#DD,#44,#D4,#D4,#82,#40
	DB	#4D,#0D,#CC,#DC,#D0,#0D,#10,#ED,#36,#08,#0D,#D4,#44,#20,#4C,#DD
	DB	#DD,#0D,#00,#1A,#00,#02,#00,#20,#54,#20,#55,#00,#0D,#04,#08,#D2
	DB	#4D,#44,#20,#4E,#0C,#DC,#DC,#C0,#85,#10,#9C,#2F,#D0,#73,#0C,#24
	DB	#D4,#4D,#21,#4F,#A0,#DD,#D0,#D0,#40,#FD,#20,#99,#D0,#23,#56,#EA
	DB	#F0,#20,#63,#44,#20,#61,#C0,#10,#9D,#33,#20,#89,#24,#4E,#80,#DD
	DB	#4D,#34,#C3,#11,#12,#24,#20,#45,#07,#20,#57,#02,#20,#B3,#0D,#44
	DB	#4D,#DC,#4C,#5D,#48,#C0,#10,#53,#2B,#21,#D0,#73,#40,#20,#89,#44
	DB	#01,#23,#4E,#5F,#31,#E5,#EE,#11,#22,#0D,#61,#20,#A4,#24,#24,#4D
	DB	#40,#20,#A2,#20,#50,#44,#1A,#CD,#10,#4C,#27,#0C,#A1,#BB,#21,#05
	DB	#C0,#CD,#04,#86,#44,#25,#4F,#20,#EF,#03,#11,#31,#41,#20,#E7,#20
	DB	#1F,#2C,#E1,#1C,#C2,#51,#00,#DD,#0B,#20,#A0,#21,#13,#00,#12,#38
	DB	#24,#C0,#0C,#00,#D0,#6B,#20,#51,#20,#CD,#00,#20,#A1,#D0,#26,#4F
	DB	#21,#05,#D4,#02,#04,#20,#EC,#54,#3E,#5E,#1E,#C1,#22,#CF,#91,#00
	DB	#20,#4F,#12,#84,#26,#20,#95,#00,#DC,#20,#7E,#20,#7B,#F0,#0D,#DD
	DB	#0D,#CD,#20,#9F,#22,#A0,#21,#89,#7E,#86,#55,#91,#8B,#20,#53,#D3
	DB	#D3,#01,#42,#21,#4E,#D6,#44,#22,#60,#63,#DC,#12,#84,#23,#C0,#20
	DB	#50,#20,#4B,#72,#D0,#02,#4D,#C0,#20,#5B,#91,#3E,#24,#50,#FF,#98
	DB	#F5,#F4,#FD,#81,#E0,#23,#FB,#DD,#4D,#21,#14,#7E,#DC,#12,#D0,#27
	DB	#20,#ED,#21,#9A,#21,#82,#20,#8E,#20,#9F,#C4,#05,#20,#A1,#F4,#24
	DB	#51,#4F,#FF,#FF,#4F,#DF,#39,#28,#4D,#04,#CD,#21,#73,#10,#51,#26
	DB	#12,#05,#0B,#D0,#D4,#70,#44,#4F,#F4,#D4,#24,#A5,#20,#9D,#03,#4D
	DB	#7A,#4D,#24,#0C,#DC,#2D,#28,#10,#A9,#25,#20,#A1,#72,#00,#3C,#D4
	DB	#4F,#7E,#83,#68,#23,#47,#05,#44,#40,#6A,#C0,#20,#9E,#D0,#14,#BD
	DB	#36,#0C,#93,#09,#20,#42,#0F,#83,#A2,#3A,#22,#06,#D2,#C0,#04,#D4
	DB	#D0,#10,#9D,#32,#97,#25,#4E,#93,#57,#20,#A2,#0D,#21,#03,#04,#CC
	DB	#20,#4C,#C8,#00,#CC,#0D,#84,#BA,#CC,#CD,#15,#5A,#3D,#A3,#AB,#F3
	DB	#94,#F9,#04,#C0,#00,#15,#A3,#46,#04,#16,#61,#6E,#00
Delta7:		; Taille #01D1
	DB	#F8,#C0,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#B7,#0F,#3F,#0F,#7F
	DB	#0F,#B8,#00,#05,#22,#04,#0C,#10,#4A,#3F,#22,#C0,#22,#41,#00,#D0
	DB	#D0,#44,#DD,#00,#D9,#4A,#0C,#00,#10,#53,#3C,#22,#39,#0D,#20,#4B
	DB	#20,#45,#10,#4D,#4D,#40,#40,#43,#00,#4C,#DD,#6A,#DD,#50,#D0,#12
	DB	#67,#39,#C0,#20,#4B,#20,#4C,#4D,#80,#44,#44,#D4,#D4,#0D,#0D,#00
	DB	#42,#99,#46,#D4,#40,#21,#52,#20,#A3,#0C,#DC,#10,#53,#31,#B6,#0C
	DB	#21,#9C,#42,#0D,#21,#4C,#21,#41,#00,#02,#11,#20,#4F,#04,#04,#04
	DB	#21,#55,#D4,#44,#4C,#04,#40,#DD,#10,#A2,#33,#C0,#CD,#D0,#DD,#4D
	DB	#2E,#42,#7E,#20,#4E,#02,#DD,#20,#EE,#FD,#4D,#CE,#D0,#23,#56,#20
	DB	#FB,#52,#D0,#DC,#4B,#10,#A1,#33,#08,#2D,#44,#4D,#24,#4E,#FD,#C4
	DB	#12,#1C,#0E,#C3,#22,#0A,#21,#53,#20,#AF,#04,#44,#0D,#CD,#3B,#24
	DB	#C0,#10,#9D,#2B,#0D,#20,#9D,#20,#EC,#24,#4E,#44,#13,#40,#E3,#E5
	DB	#1E,#CC,#44,#00,#20,#A4,#24,#17,#81,#95,#20,#52,#22,#16,#CD,#10
	DB	#A0,#2F,#0C,#DC,#40,#01,#26,#4F,#4D,#D2,#35,#11,#21,#D2,#DD,#40
	DB	#54,#C2,#11,#1C,#CC,#2F,#20,#A3,#D0,#97,#20,#60,#20,#F1,#10,#9E
	DB	#2D,#0C,#82,#72,#DD,#D4,#27,#9F,#09,#42,#D4,#0D,#20,#95,#E3,#EE
	DB	#3E,#11,#C4,#CC,#42,#24,#10,#0D,#C0,#C0,#10,#A0,#2A,#20,#7B,#26
	DB	#C0,#20,#D5,#20,#9F,#D4,#D0,#24,#50,#55,#FD,#81,#81,#E2,#D0,#D4
	DB	#D3,#D3,#01,#4C,#20,#A5,#E9,#A1,#06,#40,#DC,#10,#9E,#2B,#00,#20
	DB	#9E,#23,#9F,#20,#87,#01,#24,#A1,#FF,#F5,#FF,#FD,#FD,#4D,#4D,#FE
	DB	#4D,#24,#FC,#81,#A4,#82,#38,#10,#9F,#2D,#B2,#1A,#20,#9E,#82,#1C
	DB	#C3,#43,#20,#58,#4F,#FF,#FF,#DF,#23,#4C,#20,#4D,#1B,#22,#9D,#20
	DB	#68,#DC,#13,#B4,#2E,#23,#4D,#DD,#04,#C4,#2F,#22,#3C,#22,#A4,#20
	DB	#53,#02,#4D,#24,#4C,#44,#4F,#56,#40,#21,#9B,#11,#DE,#30,#CC,#22
	DB	#CF,#00,#20,#90,#04,#1D,#21,#DE,#D4,#23,#53,#04,#21,#4D,#04,#D4
	DB	#0D,#12,#D0,#14,#12,#37,#00,#0D,#20,#AA,#0D,#D4,#04,#A6,#04,#24
	DB	#4A,#20,#49,#D4,#00,#43,#D0,#20,#69,#26,#CC,#14,#12,#36,#23,#36
	DB	#D0,#CD,#21,#56,#DD,#C0,#ED,#21,#56,#CC,#84,#15,#82,#E8,#00,#15
	DB	#01,#3E,#22,#A7,#21,#43,#39,#04,#CC,#00,#15,#A0,#45,#17,#5A,#74
	DB	#00
Delta8:		; Taille #01B1
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#AB,#0F,#7F,#0F
	DB	#B6,#0C,#03,#00,#21,#07,#D0,#21,#03,#96,#00,#10,#4A,#40,#02,#DD
	DB	#45,#00,#4D,#43,#C0,#20,#44,#0C,#0C,#40,#00,#25,#13,#10,#4F,#36
	DB	#08,#C0,#4D,#4C,#7E,#22,#44,#D2,#D4,#00,#04,#04,#00,#D4,#DF,#D2
	DB	#44,#F4,#70,#00,#4C,#4D,#C0,#10,#52,#37,#20,#8E,#21,#50,#44,#60
	DB	#DF,#DD,#0D,#00,#00,#02,#04,#0D,#00,#0D,#0D,#04,#44,#00,#0C,#4C
	DB	#0D,#82,#C0,#10,#9D,#36,#44,#44,#D4,#DD,#DD,#20,#4F,#90,#D0,#D0
	DB	#D0,#4D,#49,#04,#D0,#24,#53,#0C,#44,#C2,#24,#6A,#10,#9D,#2F,#DC
	DB	#4C,#2C,#40,#0C,#D4,#4D,#21,#4F,#02,#4D,#2F,#12,#C2,#52,#24,#46
	DB	#00,#DD,#20,#57,#40,#20,#52,#D4,#34,#44,#04,#10,#A0,#34,#C0,#20
	DB	#42,#24,#4E,#F4,#13,#10,#5C,#E1,#11,#CC,#20,#E9,#4D,#F4,#24,#03
	DB	#20,#B1,#21,#A3,#42,#4C,#4C,#DC,#DC,#0C,#19,#10,#9E,#30,#4C,#42
	DB	#20,#E5,#23,#4F,#D2,#23,#1E,#00,#15,#21,#42,#DD,#54,#C2,#11,#1C
	DB	#4C,#CC,#2F,#20,#A3,#50,#2F,#C4,#10,#A0,#32,#C0,#8E,#02,#20,#8C
	DB	#24,#4F,#45,#D2,#D2,#D4,#20,#9D,#38,#33,#E5,#5E,#20,#A5,#20,#56
	DB	#21,#B4,#FF,#40,#02,#D0,#10,#9F,#30,#0C,#D0,#00,#44,#D4,#0C,#09
	DB	#24,#4F,#FD,#DD,#21,#E5,#DD,#D3,#03,#01,#E6,#2C,#21,#4E,#20,#4F
	DB	#4D,#02,#10,#9E,#31,#7F,#20,#4F,#08,#DD,#D4,#D0,#23,#A1,#D4,#F5
	DB	#F4,#F0,#EE,#40,#21,#46,#23,#5C,#20,#5D,#D4,#54,#10,#9E,#30,#21
	DB	#EE,#00,#DD,#0D,#DD,#D0,#0D,#04,#DD,#40,#81,#21,#46,#DF,#FF,#FF
	DB	#FF,#DF,#D4,#B1,#EA,#89,#20,#4C,#F4,#42,#12,#CF,#33,#C0,#C0,#0D
	DB	#20,#91,#B4,#4D,#F4,#81,#43,#44,#46,#23,#4B,#4D,#22,#4C,#21,#21
	DB	#0E,#C2,#CD,#CD,#00,#13,#21,#34,#0C,#00,#78,#C4,#C2,#C2,#82,#C9
	DB	#23,#45,#05,#20,#9B,#04,#D8,#C4,#04,#D0,#13,#BD,#38,#22,#53,#D4
	DB	#20,#53,#20,#46,#20,#0D,#2D,#FD,#4D,#0D,#46,#C0,#C2,#59,#22,#4C
	DB	#C0,#C0,#14,#11,#3B,#21,#03,#D4,#44,#C0,#6C,#D4,#00,#21,#03,#22
	DB	#0F,#0C,#15,#00,#41,#22,#53,#0D,#0E,#CC,#10,#98,#3E,#16,#18,#D2
	DB	#00
Delta9:		; Taille #01C0
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#3B,#0F,#7F,#0F
	DB	#BA,#0C,#05,#26,#08,#10,#4B,#3D,#C0,#DC,#91,#20,#44,#00,#D0,#00
	DB	#48,#DD,#D0,#20,#4E,#24,#00,#0C,#10,#53,#3C,#0C,#0C,#02,#CC,#0D
	DB	#50,#4D,#40,#20,#F4,#43,#40,#43,#4C,#20,#44,#4D,#C0,#0C,#D0,#10
	DB	#A3,#3B,#0D,#40,#81,#20,#48,#D2,#04,#04,#0D,#0D,#00,#02,#01,#44
	DB	#D4,#D4,#44,#F4,#44,#0D,#CC,#04,#DC,#00,#10,#E7,#34,#00,#DC,#D0
	DB	#D0,#DC,#C0,#44,#D4,#DD,#DD,#00,#00,#02,#20,#F1,#67,#20,#A0,#21
	DB	#05,#21,#53,#44,#44,#50,#10,#F4,#35,#C0,#8E,#04,#22,#4D,#02,#20
	DB	#56,#DD,#4D,#FD,#20,#ED,#07,#22,#57,#20,#A5,#42,#D4,#F0,#40,#D0
	DB	#00,#37,#10,#4F,#30,#20,#9E,#20,#44,#40,#22,#4D,#03,#4D,#54,#B0
	DB	#C2,#1C,#1C,#C2,#20,#E9,#20,#58,#D0,#53,#1F,#20,#51,#20,#A2,#20
	DB	#56,#91,#58,#11,#8B,#2E,#00,#04,#D4,#01,#25,#4F,#2F,#E1,#E5,#EE
	DB	#11,#2C,#44,#B0,#00,#FD,#24,#24,#20,#ED,#21,#A5,#4F,#20,#B7,#9A
	DB	#0D,#11,#43,#2E,#0C,#81,#3C,#20,#A1,#DD,#C0,#24,#9F,#00,#D2,#31
	DB	#21,#41,#04,#4D,#3F,#2C,#50,#E1,#1C,#CC,#FF,#20,#FE,#00,#20,#54
	DB	#40,#DF,#10,#9E,#2F,#81,#80,#02,#81,#3A,#23,#4F,#44,#42,#20,#8F
	DB	#80,#D0,#44,#EE,#5E,#1E,#C1,#2C,#21,#B3,#8A,#4D,#91,#92,#00,#11
	DB	#3E,#30,#0D,#0D,#0D,#7A,#33,#21,#05,#20,#40,#55,#FD,#20,#5C,#4F
	DB	#D4,#D2,#48,#D3,#03,#42,#24,#4E,#44,#4C,#11,#DF,#31,#0D,#0D,#A1
	DB	#D9,#4D,#20,#51,#46,#FF,#FF,#FF,#FD,#56,#FD,#23,#09,#22,#FC,#44
	DB	#02,#04,#20,#AE,#C0,#3A,#C0,#11,#E0,#30,#D4,#81,#7E,#82,#6E,#21
	DB	#47,#4F,#4F,#66,#DF,#C1,#9B,#22,#9C,#4F,#44,#13,#23,#33,#21,#80
	DB	#0C,#F0,#D0,#44,#F4,#4D,#21,#51,#21,#53,#20,#9D,#03,#1F,#22,#4C
	DB	#03,#21,#9B,#10,#9D,#30,#B1,#94,#0D,#C4,#C0,#1F,#22,#A0,#20,#A5
	DB	#23,#54,#04,#20,#9B,#CD,#D0,#C0,#82,#00,#13,#C0,#39,#00,#00,#04
	DB	#C0,#D0,#20,#EE,#4E,#04,#21,#50,#21,#03,#20,#99,#DD,#0D,#20,#EA
	DB	#C0,#93,#14,#AE,#3C,#42,#CD,#DD,#44,#0D,#04,#20,#94,#B2,#0D,#22
	DB	#98,#C0,#C0,#15,#02,#42,#22,#46,#C0,#24,#08,#03,#16,#14,#B9,#00
Delta10:		; Taille #01AE
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#9B,#0F,#7F,#0F
	DB	#BF,#0C,#0F,#46,#42,#00,#00,#44,#C8,#D0,#0C,#D0,#43,#D0,#00,#10
	DB	#55,#40,#20,#4A,#40,#DD,#0C,#00,#4D,#4D,#0C,#42,#44,#4A,#40,#42
	DB	#00,#10,#52,#3C,#0C,#C0,#20,#95,#00,#40,#DD,#44,#44,#04,#04,#04
	DB	#20,#A2,#0D,#B9,#44,#D4,#DF,#4B,#20,#59,#20,#52,#C0,#10,#E8,#36
	DB	#E8,#C0,#0D,#D0,#20,#40,#D4,#20,#4A,#02,#03,#C8,#40,#40,#40,#21
	DB	#54,#0D,#D4,#51,#20,#B2,#3C,#DC,#00,#10,#4E,#32,#7C,#20,#41,#20
	DB	#4D,#DD,#DD,#BB,#24,#4D,#20,#EF,#DD,#24,#59,#20,#51,#4A,#0D,#10
	DB	#A1,#33,#0F,#20,#9D,#20,#EA,#20,#4D,#22,#4F,#D0,#4D,#24,#C2,#B0
	DB	#12,#C2,#24,#DD,#20,#E9,#02,#F0,#21,#F8,#3F,#20,#67,#81,#46,#11
	DB	#45,#2E,#A1,#38,#22,#4E,#21,#45,#44,#55,#A0,#E1,#E5,#EE,#11,#42
	DB	#21,#A4,#F4,#20,#9B,#B3,#21,#A5,#58,#C4,#C0,#11,#D8,#33,#20,#4F
	DB	#0C,#23,#51,#00,#DD,#D2,#33,#11,#31,#42,#D4,#F4,#40,#C2,#11,#EC
	DB	#CC,#2F,#4D,#20,#5F,#DD,#7F,#20,#56,#91,#E7,#10,#EB,#2B,#20,#D5
	DB	#21,#46,#24,#9F,#23,#07,#D4,#00,#04,#00,#4D,#13,#E5,#5E,#1E,#CC
	DB	#72,#42,#23,#10,#00,#C0,#11,#3C,#31,#02,#22,#53,#0D,#09,#21,#04
	DB	#FF,#F4,#91,#44,#DD,#D5,#03,#21,#66,#21,#20,#A5,#21,#4D,#4D,#4F
	DB	#20,#61,#10,#51,#2F,#C0,#0A,#4D,#91,#39,#40,#23,#9F,#FF,#F5,#FF
	DB	#FD,#2C,#4D,#4D,#81,#E1,#22,#0C,#4D,#20,#4E,#F4,#42,#85,#20,#4D
	DB	#C0,#10,#A1,#30,#C0,#C2,#04,#44,#24,#42,#C0,#D4,#FF,#FF,#FF,#4F
	DB	#D4,#24,#FB,#20,#4E,#85,#92,#DF,#0D,#12,#31,#32,#0C,#CD,#00,#DD
	DB	#21,#51,#BF,#82,#C0,#21,#42,#21,#58,#42,#83,#73,#21,#0A,#2F,#20
	DB	#59,#F3,#13,#71,#35,#21,#D2,#D0,#D4,#20,#4E,#20,#44,#24,#52,#05
	DB	#68,#44,#4F,#44,#83,#37,#C0,#13,#71,#35,#91,#E6,#C0,#94,#0C,#D4
	DB	#27,#4E,#04,#20,#F4,#00,#C0,#20,#EA,#0B,#14,#62,#3D,#83,#61,#CC
	DB	#81,#E9,#CC,#04,#04,#DD,#6F,#22,#5F,#21,#9D,#14,#B1,#3E,#21,#3F
	DB	#00,#02,#21,#4B,#00,#0E,#CC,#10,#4B,#40,#16,#0F,#7B,#00
Delta11:		; Taille #01BD
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#BB,#0F,#7F,#0F
	DB	#B9,#0C,#04,#26,#08,#10,#4B,#42,#00,#21,#04,#4C,#D0,#00,#04,#10
	DB	#52,#41,#0D,#D0,#20,#41,#00,#00,#4D,#2C,#0C,#4D,#4D,#0C,#40,#44
	DB	#19,#20,#58,#D0,#0D,#21,#52,#10,#53,#36,#C0,#D0,#DC,#01,#79,#C0
	DB	#4D,#44,#02,#04,#04,#00,#0A,#00,#02,#00,#46,#44,#44,#44,#C0,#E7
	DB	#23,#52,#10,#9C,#37,#7F,#D2,#0D,#23,#4B,#22,#4D,#23,#05,#84,#D4
	DB	#44,#20,#4E,#0C,#DC,#00,#C0,#10,#9C,#30,#00,#CD,#D0,#D0,#4C,#4C
	DB	#D4,#DD,#DD,#61,#23,#4C,#40,#40,#40,#D0,#23,#08,#54,#DD,#C9,#20
	DB	#63,#0D,#C0,#10,#9D,#34,#CD,#44,#21,#4E,#22,#9E,#C0,#40,#24,#C2
	DB	#C1,#E3,#54,#20,#59,#20,#4C,#15,#20,#EB,#44,#45,#42,#20,#67,#DC
	DB	#D0,#C0,#37,#10,#53,#2B,#81,#36,#22,#93,#44,#20,#4E,#22,#9F,#4D
	DB	#24,#00,#11,#E5,#EE,#1E,#55,#0D,#40,#FD,#90,#34,#24,#44,#4D,#21
	DB	#5F,#44,#C4,#10,#A0,#2D,#65,#21,#4C,#0C,#42,#0D,#24,#22,#4E,#21
	DB	#A1,#DD,#00,#D0,#05,#31,#11,#43,#04,#4D,#3F,#F0,#1C,#51,#EE,#12
	DB	#20,#63,#20,#A4,#20,#F1,#43,#CA,#00,#11,#E4,#29,#0C,#20,#4C,#D0
	DB	#DD,#91,#27,#20,#9B,#0F,#24,#51,#48,#81,#8C,#20,#45,#11,#3E,#1E
	DB	#11,#3A,#23,#81,#02,#4D,#20,#F3,#10,#9E,#2E,#21,#94,#D0,#0D,#26
	DB	#0D,#24,#4C,#03,#55,#4D,#81,#8C,#DD,#D4,#90,#D2,#D3,#D5,#42,#21
	DB	#4E,#44,#D4,#20,#69,#AE,#D4,#92,#4A,#12,#28,#2B,#20,#84,#4D,#20
	DB	#86,#44,#25,#4F,#E0,#F5,#F5,#54,#5D,#FD,#4F,#25,#0D,#56,#96,#42
	DB	#12,#D0,#31,#A1,#BE,#00,#25,#50,#FF,#FF,#02,#8C,#4F,#D4,#23,#0A
	DB	#21,#64,#F4,#04,#C4,#20,#BB,#13,#13,#23,#32,#83,#08,#04,#04,#24
	DB	#94,#4F,#DF,#D4,#87,#22,#B0,#21,#4C,#02,#24,#04,#DD,#DC,#13,#6D
	DB	#34,#ED,#22,#A1,#DC,#21,#3F,#21,#52,#D4,#81,#32,#22,#4B,#4C,#98
	DB	#24,#44,#D0,#22,#1A,#13,#C1,#36,#D0,#CD,#20,#54,#1A,#0C,#20,#4C
	DB	#C4,#21,#49,#83,#BB,#C2,#C4,#D4,#BA,#D2,#20,#4B,#0D,#14,#61,#3E
	DB	#20,#53,#81,#48,#DD,#20,#57,#E8,#0D,#D4,#CC,#24,#4C,#C0,#10,#4F
	DB	#3D,#A1,#98,#92,#70,#0E,#0D,#26,#0D,#16,#15,#B6,#00
Delta12:		; Taille #01E5
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#AB,#0F,#7F,#0F
	DB	#B9,#0C,#21,#03,#D0,#22,#07,#0C,#10,#4A,#40,#22,#00,#21,#42,#00
	DB	#DD,#0C,#04,#0C,#00,#D4,#D0,#00,#21,#53,#C0,#36,#2A,#C0,#3E,#95
	DB	#22,#8D,#84,#C0,#DD,#20,#98,#00,#4D,#4D,#2C,#42,#84,#40,#40,#43
	DB	#D0,#D0,#D0,#0D,#10,#A6,#39,#05,#20,#93,#D0,#79,#4D,#D4,#04,#04
	DB	#00,#56,#00,#02,#20,#4E,#00,#48,#44,#23,#52,#CD,#C3,#11,#32,#33
	DB	#22,#84,#C0,#44,#44,#D4,#22,#4B,#04,#45,#06,#0D,#20,#52,#44,#00
	DB	#DC,#02,#00,#22,#C0,#10,#50,#2F,#C0,#0D,#DD,#20,#E2,#D2,#DD,#66
	DB	#DD,#23,#46,#20,#9C,#40,#D0,#23,#08,#20,#4E,#40,#20,#D4,#44,#DD
	DB	#0D,#C0,#10,#9E,#32,#0C,#00,#08,#24,#D4,#DD,#23,#4F,#40,#24,#C2
	DB	#11,#CC,#E3,#54,#23,#56,#20,#55,#0D,#00,#20,#50,#46,#70,#D0,#DC
	DB	#0C,#C0,#10,#E9,#2B,#22,#9E,#20,#D9,#DD,#01,#23,#4F,#4D,#2F,#11
	DB	#E5,#5E,#13,#F5,#A1,#21,#56,#12,#12,#34,#4D,#20,#51,#D0,#58,#76
	DB	#CD,#10,#A0,#28,#20,#4B,#C0,#20,#98,#44,#21,#9D,#0C,#16,#40,#22
	DB	#9E,#02,#D0,#02,#05,#31,#11,#02,#43,#20,#E9,#35,#E1,#E1,#EE,#11
	DB	#4F,#FF,#21,#11,#21,#68,#22,#A0,#11,#35,#24,#91,#24,#21,#94,#70
	DB	#26,#9F,#13,#21,#3A,#47,#D4,#D4,#20,#E6,#44,#31,#EE,#8E,#15,#20
	DB	#56,#21,#63,#57,#44,#00,#C0,#10,#A0,#28,#E9,#21,#4E,#0D,#0D,#7D
	DB	#4D,#21,#9F,#24,#4F,#02,#9C,#FF,#5D,#21,#F5,#20,#A6,#20,#59,#D2
	DB	#D2,#21,#4E,#F4,#4D,#D4,#20,#4F,#4D,#92,#49,#10,#4D,#25,#21,#9D
	DB	#21,#3A,#44,#4D,#04,#20,#55,#04,#24,#4D,#24,#4F,#4F,#40,#F5,#55
	DB	#54,#5D,#5D,#FD,#24,#FE,#4D,#8F,#20,#4D,#20,#F3,#21,#9F,#10,#A1
	DB	#29,#CC,#C4,#C4,#23,#2B,#46,#0C,#20,#E8,#24,#50,#D4,#FF,#FF,#02
	DB	#DF,#E3,#26,#4D,#20,#4E,#04,#D4,#D0,#13,#21,#31,#20,#4D,#20,#F5
	DB	#A4,#C4,#02,#24,#51,#D4,#4F,#23,#4D,#4D,#22,#4D,#FB,#92,#E2,#81
	DB	#B4,#C0,#14,#57,#34,#20,#49,#21,#F4,#25,#F5,#4B,#81,#22,#9B,#44
	DB	#DD,#0C,#C0,#0D,#00,#14,#A6,#36,#0E,#CD,#83,#A9,#20,#F4,#83,#B6
	DB	#44,#24,#24,#44,#C1,#22,#07,#DD,#CC,#CD,#DD,#00,#14,#4A,#22,#11
	DB	#A0,#1A,#4D,#83,#5B,#C0,#20,#9B,#43,#D4,#D4,#48,#0D,#7A,#DD,#21
	DB	#48,#00,#14,#FF,#3C,#23,#89,#23,#46,#23,#97,#0C,#0D,#15,#9F,#44
	DB	#C0,#16,#15,#74,#00
Delta13:		; Taille #01F2
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#BB,#0F,#7F,#0F
	DB	#68,#0C,#05,#10,#4A,#45,#22,#46,#00,#21,#04,#AC,#0C,#D0,#22,#08
	DB	#10,#50,#41,#DD,#21,#51,#00,#21,#04,#A4,#D0,#DD,#20,#4C,#0C,#DD
	DB	#22,#57,#C0,#10,#4A,#37,#0C,#00,#DC,#20,#4A,#20,#42,#DD,#40,#40
	DB	#44,#00,#44,#44,#40,#4D,#4D,#4D,#4C,#44,#9A,#4D,#21,#56,#C0,#25
	DB	#B4,#10,#EB,#32,#0D,#4D,#21,#4B,#90,#04,#04,#00,#00,#02,#20,#40
	DB	#21,#04,#1B,#4A,#20,#51,#00,#24,#52,#10,#4B,#2F,#C0,#CD,#D0,#75
	DB	#20,#9D,#00,#20,#97,#D4,#22,#4C,#04,#06,#40,#8A,#24,#21,#12,#C0
	DB	#20,#9F,#DC,#00,#C0,#10,#9D,#32,#C7,#7A,#20,#ED,#23,#45,#F0,#40
	DB	#40,#25,#50,#20,#AC,#12,#04,#20,#F8,#DD,#0D,#10,#4D,#2E,#C0,#C0
	DB	#00,#94,#D0,#D0,#20,#EA,#D4,#79,#DD,#D0,#49,#60,#F4,#12,#CC,#E1
	DB	#E5,#20,#E8,#20,#56,#4D,#E3,#23,#56,#20,#F4,#40,#DC,#DC,#02,#11
	DB	#43,#2E,#20,#9E,#0D,#20,#D9,#4D,#21,#9F,#20,#50,#44,#22,#11,#EE
	DB	#04,#3E,#11,#20,#44,#54,#C2,#11,#E1,#3F,#CF,#21,#56,#50,#20,#68
	DB	#10,#A0,#26,#0C,#00,#91,#BA,#21,#32,#1F,#20,#7E,#20,#9F,#81,#D5
	DB	#21,#4E,#21,#50,#D2,#05,#21,#04,#21,#43,#20,#5E,#11,#E3,#5E,#1E
	DB	#31,#FC,#44,#00,#50,#57,#81,#5B,#10,#9E,#25,#22,#E7,#20,#54,#F9
	DB	#82,#6A,#C0,#0D,#21,#9F,#25,#50,#45,#20,#A7,#20,#63,#C0,#D4,#21
	DB	#31,#31,#21,#42,#22,#0E,#56,#71,#5C,#00,#C0,#C0,#10,#A2,#21,#64
	DB	#21,#9A,#DD,#95,#21,#2C,#44,#81,#C1,#40,#27,#4F,#4F,#54,#91,#45
	DB	#73,#23,#0A,#04,#D4,#F4,#81,#40,#10,#9E,#27,#20,#9B,#0D,#39,#71
	DB	#4D,#04,#21,#7D,#81,#77,#25,#50,#D4,#F5,#C0,#F5,#F4,#54,#54,#F4
	DB	#D4,#25,#4E,#54,#34,#CD,#CD,#02,#CD,#11,#41,#23,#81,#BD,#0D,#CD
	DB	#1E,#0D,#B1,#6C,#82,#B7,#81,#78,#23,#50,#4F,#FF,#FF,#EC,#FF,#4F
	DB	#25,#9D,#22,#64,#44,#11,#DC,#2F,#91,#DE,#20,#80,#F7,#20,#5C,#81
	DB	#E2,#24,#93,#4F,#25,#9C,#20,#BA,#81,#8C,#82,#4E,#9A,#CD,#14,#19
	DB	#33,#0C,#20,#FB,#93,#61,#4D,#4D,#26,#4B,#A9,#20,#4C,#4F,#44,#81
	DB	#A8,#DD,#13,#BE,#35,#00,#81,#22,#74,#C0,#D0,#83,#BF,#D4,#20,#F5
	DB	#91,#4B,#81,#38,#C0,#FB,#4B,#94,#B6,#C0,#14,#62,#38,#20,#F6,#21
	DB	#53,#20,#99,#81,#9C,#EA,#D4,#43,#C0,#22,#98,#CD,#15,#57,#3C,#23
	DB	#88,#94,#4F,#EC,#00,#0D,#A1,#FE,#15,#A3,#44,#C0,#27,#59,#16,#66
	DB	#6D,#00
Delta14:		; Taille #01D6
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#5B,#0F,#7F,#0F
	DB	#68,#0C,#04,#10,#4A,#45,#00,#22,#04,#D0,#5B,#04,#22,#53,#00,#10
	DB	#95,#3F,#20,#4F,#D0,#46,#00,#4E,#DD,#20,#47,#43,#47,#0C,#DD,#22
	DB	#15,#C0,#0D,#10,#50,#38,#0D,#20,#4B,#20,#91,#4D,#4D,#40,#40,#30
	DB	#D4,#D4,#00,#04,#21,#06,#4A,#0C,#D0,#24,#DD,#C0,#10,#FB,#34,#C0
	DB	#0C,#22,#33,#04,#44,#C2,#44,#21,#4A,#00,#40,#24,#04,#44,#02,#47
	DB	#20,#53,#20,#54,#20,#A9,#0C,#DC,#D0,#10,#A1,#34,#CD,#C0,#DD,#DD
	DB	#40,#42,#D4,#0D,#23,#48,#05,#AD,#21,#4F,#02,#42,#20,#61,#0D,#21
	DB	#4E,#0C,#10,#A1,#2E,#0F,#20,#84,#21,#E9,#20,#9B,#20,#52,#DD,#D0
	DB	#D0,#40,#50,#FD,#24,#F4,#40,#22,#4E,#D0,#23,#54,#44,#8A,#40,#54
	DB	#CD,#10,#A1,#30,#C0,#CD,#D4,#20,#4E,#02,#44,#21,#4F,#DD,#4D,#24
	DB	#12,#21,#EE,#C4,#E5,#4D,#21,#F4,#14,#14,#24,#23,#50,#20,#F2,#8F
	DB	#10,#9E,#2B,#21,#2C,#20,#9A,#21,#32,#D0,#44,#4D,#22,#9F,#80,#DD
	DB	#44,#22,#11,#EE,#1E,#31,#20,#E6,#E0,#35,#3C,#E1,#EE,#13,#20,#4B
	DB	#5A,#51,#55,#20,#F2,#CD,#10,#A1,#29,#C0,#21,#4D,#0D,#02,#0D,#05
	DB	#75,#44,#23,#9F,#D0,#D2,#05,#2E,#21,#8A,#42,#20,#95,#33,#20,#55
	DB	#11,#21,#D4,#20,#F4,#E5,#21,#61,#DC,#10,#9E,#29,#0C,#C0,#22,#31
	DB	#02,#45,#34,#D0,#D0,#24,#4F,#DD,#22,#05,#21,#95,#D4,#D3,#2C,#D3
	DB	#D2,#23,#B0,#50,#0D,#10,#9F,#2A,#C0,#C0,#13,#21,#92,#21,#3F,#4D
	DB	#04,#26,#A0,#DD,#55,#5D,#9E,#4D,#20,#5C,#81,#48,#23,#0C,#21,#07
	DB	#44,#D0,#11,#DD,#2C,#C0,#C0,#0D,#4D,#2D,#0D,#C4,#20,#F6,#21,#9F
	DB	#03,#02,#22,#44,#D4,#F5,#F5,#F5,#FF,#F5,#52,#4F,#27,#4E,#C4,#C4
	DB	#20,#A0,#00,#12,#30,#2D,#0C,#0D,#81,#40,#0D,#23,#A1,#22,#51,#D4
	DB	#FF,#FF,#FF,#DE,#DF,#27,#4E,#20,#B4,#14,#1A,#35,#24,#A0,#D4,#22
	DB	#52,#25,#F8,#23,#23,#4D,#20,#4C,#C0,#CD,#00,#10,#51,#32,#0C,#0D
	DB	#0D,#81,#73,#D0,#24,#4D,#21,#4E,#4D,#4D,#4D,#2D,#25,#47,#00,#20
	DB	#4B,#0D,#D0,#14,#61,#3A,#0D,#C0,#1A,#C0,#81,#D9,#C0,#21,#F9,#43
	DB	#D4,#00,#CC,#BF,#43,#A1,#B1,#10,#4E,#38,#22,#39,#20,#4F,#45,#C0
	DB	#20,#52,#B3,#84,#6D,#84,#FC,#C0,#00,#15,#50,#41,#22,#54,#0D,#E5
	DB	#5A,#03,#16,#66,#BB,#00
Delta15:		; Taille #01BB
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#0B,#0F,#7F,#0F
	DB	#B3,#00,#04,#0C,#CC,#0C,#0C,#15,#22,#08,#0C,#10,#4A,#3C,#0C,#22
	DB	#3E,#D0,#D0,#CC,#B8,#C0,#D0,#DD,#20,#4D,#47,#4D,#DC,#10,#53,#3E
	DB	#02,#0D,#21,#43,#4D,#4D,#40,#D0,#D4,#D4,#80,#04,#04,#04,#44,#00
	DB	#40,#4D,#20,#A8,#44,#DC,#0D,#10,#4A,#35,#C0,#00,#DC,#21,#88,#44
	DB	#98,#44,#D4,#0D,#20,#46,#44,#00,#00,#02,#A9,#47,#0D,#04,#20,#5C
	DB	#DD,#21,#52,#00,#10,#51,#34,#40,#CD,#DD,#4D,#D2,#DD,#0D,#23,#49
	DB	#D0,#69,#23,#05,#00,#04,#03,#44,#22,#51,#10,#9D,#31,#C0,#80,#D0
	DB	#D0,#4C,#40,#D4,#DD,#DD,#46,#E0,#D0,#40,#FD,#F4,#F4,#20,#E8,#20
	DB	#53,#20,#ED,#AE,#40,#23,#54,#20,#FE,#20,#5E,#C0,#10,#51,#31,#CD
	DB	#20,#E5,#06,#44,#20,#4F,#02,#4D,#4F,#04,#0D,#D4,#82,#4F,#20,#EC
	DB	#F4,#DF,#04,#DF,#F4,#22,#50,#3E,#44,#10,#A0,#31,#20,#7F,#21,#83
	DB	#91,#2C,#21,#4F,#44,#44,#5B,#20,#42,#44,#D4,#24,#06,#21,#A1,#D0
	DB	#45,#4D,#97,#21,#A0,#10,#A1,#29,#72,#0C,#42,#0D,#0D,#21,#3D,#09
	DB	#23,#9F,#D4,#D2,#20,#58,#F4,#D4,#00,#D4,#A3,#20,#F3,#20,#F0,#F4
	DB	#DD,#D0,#22,#61,#D0,#10,#9F,#2C,#54,#C0,#00,#23,#35,#4D,#20,#4E
	DB	#44,#23,#A0,#D4,#FB,#21,#05,#21,#60,#D4,#22,#14,#22,#0F,#20,#4F
	DB	#91,#A5,#10,#52,#2B,#27,#21,#4F,#20,#9F,#20,#40,#40,#4C,#23,#4F
	DB	#DD,#4F,#3E,#54,#20,#E0,#51,#24,#FD,#B1,#00,#11,#8E,#2E,#C0,#C4
	DB	#0E,#0D,#21,#3D,#81,#32,#25,#A1,#45,#F5,#F5,#FF,#44,#FF,#4F,#25
	DB	#4E,#4D,#D4,#04,#20,#6B,#0C,#A9,#11,#91,#2E,#C0,#C0,#81,#70,#0C
	DB	#22,#50,#44,#22,#97,#F0,#DF,#4F,#FF,#DF,#26,#4E,#11,#3D,#2E,#F3
	DB	#BC,#20,#E2,#B8,#04,#C4,#24,#91,#45,#23,#56,#03,#D4,#21,#F3,#E0
	DB	#44,#DD,#C0,#00,#CD,#12,#D0,#32,#21,#A2,#22,#53,#B8,#D4,#D4,#C4
	DB	#20,#F6,#24,#53,#20,#4B,#24,#92,#33,#B4,#0D,#D0,#14,#5F,#3A,#0D
	DB	#21,#54,#81,#DC,#C0,#20,#53,#E7,#20,#48,#20,#5A,#47,#0D,#0C,#25
	DB	#68,#14,#B4,#3A,#22,#53,#9B,#20,#4D,#21,#46,#DD,#10,#4B,#41,#26
	DB	#F7,#C0,#CC,#10,#4B,#45,#03,#16,#1B,#7F,#00
Delta16:		; Taille #019F
	DB	#FC,#CC,#CC,#02,#04,#08,#0F,#0F,#0F,#1F,#0F,#3F,#AB,#0F,#7F,#0F
	DB	#B3,#0C,#04,#00,#21,#03,#0C,#10,#4A,#41,#03,#20,#42,#02,#D0,#00
	DB	#00,#00,#D0,#DD,#4C,#00,#0C,#42,#50,#DC,#C0,#10,#4F,#3D,#0D,#81
	DB	#20,#4C,#20,#4D,#D4,#D2,#D4,#04,#21,#03,#32,#D4,#20,#52,#40,#0D
	DB	#24,#AA,#10,#4C,#34,#C0,#D0,#81,#20,#9B,#20,#44,#04,#0D,#0D,#40
	DB	#44,#03,#21,#A2,#02,#4D,#40,#04,#02,#40,#4D,#0E,#CD,#B1,#01,#10
	DB	#4E,#31,#20,#88,#4D,#44,#DD,#0D,#2B,#22,#48,#20,#A4,#D0,#22,#F4
	DB	#00,#22,#0C,#04,#4C,#94,#40,#DD,#10,#A1,#33,#C0,#20,#EA,#40,#D4
	DB	#22,#4E,#40,#D0,#DD,#FD,#F4,#F4,#4D,#20,#4B,#4D,#A5,#45,#FD,#22
	DB	#55,#04,#44,#20,#F7,#DC,#10,#A1,#2F,#85,#6F,#C0,#79,#D4,#4D,#DD
	DB	#DD,#02,#04,#4D,#4F,#20,#F2,#D4,#4F,#40,#40,#FF,#86,#D4,#22,#06
	DB	#21,#51,#D4,#44,#0D,#C0,#11,#96,#2B,#AB,#71,#20,#E9,#00,#20,#99
	DB	#DD,#20,#EC,#44,#22,#4F,#BE,#44,#20,#8F,#4D,#44,#02,#21,#4A,#44
	DB	#24,#11,#7C,#40,#DC,#10,#A0,#2B,#A1,#2F,#20,#82,#21,#9E,#23,#3D
	DB	#D4,#00,#D4,#04,#2D,#F4,#4F,#0D,#0D,#4F,#A0,#4D,#2D,#0D,#DF,#D4
	DB	#23,#4F,#04,#10,#9F,#2A,#ED,#21,#4D,#D0,#21,#9C,#21,#36,#DC,#20
	DB	#4F,#23,#F0,#22,#A6,#97,#81,#47,#23,#0A,#25,#0F,#D0,#10,#9F,#2A
	DB	#C0,#CD,#6E,#31,#02,#00,#4D,#04,#21,#DD,#25,#50,#F5,#5D,#60,#4D
	DB	#40,#40,#4D,#FD,#23,#9C,#81,#50,#42,#5D,#11,#DA,#30,#04,#02,#20
	DB	#E0,#43,#44,#26,#51,#45,#D0,#F5,#F5,#FF,#FF,#22,#4E,#4D,#4E,#20
	DB	#68,#75,#5B,#D0,#12,#81,#33,#C0,#22,#A0,#22,#51,#21,#52,#DF,#E8
	DB	#4F,#4F,#D4,#47,#4D,#81,#8F,#81,#97,#13,#6B,#36,#54,#00,#CD,#23
	DB	#51,#D4,#24,#55,#44,#24,#0A,#D4,#EC,#0C,#C0,#20,#BE,#14,#18,#38
	DB	#0C,#91,#E6,#21,#A0,#23,#A5,#E1,#45,#4F,#02,#C0,#CD,#10,#4C,#39
	DB	#21,#F1,#92,#16,#94,#D0,#0D,#47,#D4,#83,#C0,#DD,#00,#83,#32,#FB
	DB	#14,#FE,#42,#22,#53,#0D,#A1,#4E,#24,#0B,#16,#0E,#FF,#0D,#00
	DB	#FF			; Fin de l''animation
; Taille totale animation = 7808 (#1E80)

PALMIERDATA

; Genere par ConvImgCpcVersion Beta - 1.0.7530.30816
; mode ecran 1
; Taille (nbColsxNbLignes) 16x77
	DB	#00,#00,#00,#00,#00,#22,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#32,#FE,#00,#00,#00,#00,#00,#00,#77,#CC,#00,#00
	DB	#00,#00,#00,#00,#11,#F0,#E2,#88,#00,#00,#11,#76,#F0,#F0,#C4,#00
	DB	#00,#00,#00,#00,#10,#F0,#F0,#C4,#00,#00,#64,#F0,#F0,#F0,#E2,#00
	DB	#00,#00,#00,#00,#00,#70,#F0,#C0,#00,#00,#FA,#F0,#F0,#F0,#F0,#00
	DB	#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#10,#F0,#F0,#F0,#F0,#F0,#C4
	DB	#00,#00,#00,#00,#00,#00,#F8,#F0,#80,#30,#F0,#F0,#F0,#F0,#F0,#EE
	DB	#00,#00,#00,#00,#00,#00,#F8,#F0,#C4,#70,#F0,#F0,#F0,#74,#FA,#C4
	DB	#00,#00,#00,#00,#00,#00,#30,#F0,#D1,#F0,#F0,#F0,#F3,#00,#75,#EA
	DB	#00,#00,#00,#00,#00,#00,#30,#F0,#F2,#F0,#F0,#E2,#00,#00,#11,#33
	DB	#00,#00,#00,#00,#11,#F1,#33,#F0,#F0,#F0,#F0,#E2,#00,#00,#00,#11
	DB	#00,#00,#00,#32,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#88,#00,#00,#00
	DB	#00,#00,#00,#77,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#E6,#00,#00,#00
	DB	#00,#00,#00,#74,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F3,#00,#00,#00
	DB	#00,#00,#11,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#80,#00,#00
	DB	#00,#00,#32,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#E2,#00,#00
	DB	#00,#00,#F8,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#00,#00
	DB	#00,#11,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#88,#00
	DB	#00,#10,#F8,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#FE,#F0,#F0,#F1,#00,#00
	DB	#00,#33,#F0,#F0,#F0,#DD,#F0,#F0,#F0,#F0,#C4,#FA,#F0,#F0,#80,#00
	DB	#00,#32,#F0,#F0,#B3,#32,#F0,#F0,#F0,#F0,#E0,#22,#F0,#F0,#C0,#00
	DB	#00,#30,#F0,#F0,#00,#70,#F0,#F1,#F0,#F0,#F0,#00,#70,#F0,#F1,#00
	DB	#00,#74,#F0,#E4,#00,#F8,#F0,#F1,#F0,#F0,#F0,#88,#77,#F0,#E0,#00
	DB	#00,#F8,#F0,#E6,#00,#F0,#F0,#E0,#F1,#F0,#F0,#C4,#00,#F0,#F0,#00
	DB	#00,#FC,#F0,#88,#00,#F8,#F0,#E2,#E0,#F8,#F0,#E2,#00,#70,#F3,#C4
	DB	#00,#F8,#F0,#00,#00,#F0,#F0,#C0,#E0,#F8,#F0,#F3,#00,#32,#F4,#88
	DB	#00,#F0,#F3,#00,#11,#F0,#F0,#CC,#E0,#70,#F0,#F3,#00,#22,#F2,#80
	DB	#11,#F0,#E2,#00,#32,#F0,#F1,#CC,#E0,#30,#F0,#E0,#00,#00,#62,#C4
	DB	#11,#F5,#C4,#00,#33,#F0,#F1,#00,#E0,#32,#F0,#F1,#00,#00,#22,#66
	DB	#10,#F9,#80,#00,#33,#F0,#E0,#00,#E0,#10,#F0,#F0,#00,#00,#00,#00
	DB	#33,#FB,#88,#00,#32,#F0,#E2,#11,#E0,#11,#F0,#F0,#80,#00,#00,#00
	DB	#00,#D1,#00,#00,#30,#F0,#E6,#11,#E0,#00,#F8,#F0,#C4,#00,#00,#00
	DB	#00,#C4,#00,#00,#70,#F0,#C4,#11,#E2,#00,#72,#F0,#C0,#00,#00,#00
	DB	#11,#80,#00,#00,#F8,#F0,#88,#11,#E2,#00,#74,#F0,#E6,#00,#00,#00
	DB	#11,#88,#00,#00,#F4,#F0,#00,#11,#E2,#00,#74,#F0,#C4,#00,#00,#00
	DB	#00,#00,#00,#00,#FC,#F0,#00,#10,#E2,#00,#30,#F8,#C0,#00,#00,#00
	DB	#00,#00,#00,#00,#F8,#F3,#00,#10,#E2,#00,#33,#F0,#E2,#00,#00,#00
	DB	#00,#00,#00,#00,#FC,#C4,#00,#10,#E2,#00,#11,#F0,#E2,#00,#00,#00
	DB	#00,#00,#00,#00,#F4,#80,#00,#32,#C0,#00,#00,#F0,#E0,#00,#00,#00
	DB	#00,#00,#00,#00,#FD,#80,#00,#32,#C0,#00,#00,#F0,#E2,#00,#00,#00
	DB	#00,#00,#00,#11,#75,#88,#00,#32,#C0,#00,#00,#FC,#E2,#00,#00,#00
	DB	#00,#00,#00,#00,#64,#00,#00,#30,#C0,#00,#00,#FC,#E2,#00,#00,#00
	DB	#00,#00,#00,#00,#22,#00,#00,#30,#80,#00,#00,#31,#E4,#00,#00,#00
	DB	#00,#00,#00,#00,#22,#00,#00,#74,#80,#00,#00,#31,#E6,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#74,#80,#00,#00,#33,#D1,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#70,#80,#00,#00,#11,#EA,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#F8,#80,#00,#00,#11,#66,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#F8,#88,#00,#00,#00,#22,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#F0,#00,#00,#00,#00,#22,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#11,#F0,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#11,#F1,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#10,#E0,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#32,#E0,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#30,#E2,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#30,#E2,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#74,#C0,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#F8,#C4,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#F8,#80,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#11,#F0,#88,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#11,#F0,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#32,#F1,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#32,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#74,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#70,#E2,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#F8,#C0,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#F0,#C4,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#11,#F0,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#32,#F0,#88,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#32,#F1,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#70,#E0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#F8,#E2,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#33,#F0,#C4,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#11,#F0,#F0,#F3,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#74,#F0,#F0,#F0,#C4,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#F0,#F0,#F0,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#74,#F0,#F0,#F0,#F0,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#76,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1 ; zeros enleves

fonte:
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#10,#20,#20,#20,#10,#00,#30,#00,#00,#80,#80,#80,#00,#00,#80,#00
	DB	#60,#60,#40,#80,#00,#00,#00,#00,#60,#60,#40,#80,#00,#00,#00,#00
	DB	#00,#20,#70,#20,#20,#70,#20,#00,#00,#40,#E0,#40,#40,#E0,#40,#00
	DB	#10,#70,#40,#70,#00,#70,#10,#00,#00,#C0,#00,#C0,#40,#C0,#00,#00
	DB	#E0,#A0,#E0,#10,#20,#40,#40,#00,#40,#40,#80,#00,#E0,#A0,#E0,#00
	DB	#70,#80,#80,#70,#80,#80,#70,#00,#00,#80,#80,#20,#40,#80,#60,#00
	DB	#00,#00,#00,#10,#00,#00,#00,#00,#C0,#C0,#80,#00,#00,#00,#00,#00
	DB	#00,#10,#30,#30,#20,#10,#00,#00,#C0,#00,#00,#00,#00,#40,#C0,#00
	DB	#30,#20,#00,#00,#00,#00,#30,#00,#00,#80,#40,#C0,#C0,#80,#00,#00
	DB	#10,#50,#30,#F0,#30,#50,#10,#00,#00,#40,#80,#E0,#80,#40,#00,#00
	DB	#00,#10,#10,#70,#10,#10,#00,#00,#00,#00,#00,#C0,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#10,#10,#10,#20,#00,#00,#00,#00,#80,#80,#00,#00
	DB	#00,#00,#00,#F0,#00,#00,#00,#00,#00,#00,#00,#C0,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#10,#10,#10,#00,#00,#00,#00,#00,#C0,#40,#C0,#00
	DB	#00,#00,#00,#00,#10,#70,#60,#00,#00,#60,#E0,#80,#00,#00,#00,#00
	DB	#F0,#80,#80,#80,#C0,#C0,#F0,#00,#C0,#C0,#C0,#40,#40,#40,#C0,#00
	DB	#30,#10,#10,#10,#10,#10,#30,#00,#00,#00,#00,#00,#80,#80,#80,#00
	DB	#F0,#90,#00,#F0,#80,#C0,#F0,#00,#80,#80,#80,#80,#00,#80,#80,#00
	DB	#70,#60,#00,#30,#30,#00,#70,#00,#C0,#40,#40,#C0,#40,#40,#C0,#00
	DB	#C0,#80,#80,#F0,#00,#10,#10,#00,#80,#80,#80,#80,#80,#80,#80,#00
	DB	#F0,#90,#80,#F0,#00,#C0,#F0,#00,#80,#80,#00,#00,#80,#80,#00,#00
	DB	#70,#90,#80,#F0,#90,#C0,#F0,#00,#80,#80,#00,#80,#80,#80,#80,#00
	DB	#F0,#C0,#00,#00,#00,#10,#10,#00,#C0,#40,#40,#80,#80,#80,#80,#00
	DB	#F0,#C0,#80,#F0,#80,#90,#F0,#00,#C0,#40,#C0,#C0,#40,#C0,#C0,#00
	DB	#F0,#E0,#80,#F0,#00,#00,#00,#00,#C0,#40,#40,#C0,#40,#C0,#C0,#00
	DB	#30,#20,#30,#00,#30,#20,#30,#00,#80,#80,#80,#00,#80,#80,#80,#00
	DB	#10,#10,#00,#10,#10,#10,#20,#00,#80,#80,#00,#80,#80,#00,#00,#00
	DB	#00,#00,#10,#20,#10,#00,#00,#00,#40,#80,#00,#00,#00,#80,#40,#00
	DB	#00,#00,#70,#00,#70,#00,#00,#00,#00,#00,#E0,#00,#E0,#00,#00,#00
	DB	#80,#40,#20,#10,#20,#40,#80,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#70,#00,#10,#10,#10,#00,#10,#00,#C0,#40,#C0,#00,#00,#00,#00,#00
	DB	#30,#20,#20,#20,#20,#20,#30,#00,#E0,#20,#E0,#A0,#E0,#00,#E0,#00
	DB	#F0,#C0,#80,#F0,#80,#C0,#C0,#00,#C0,#40,#C0,#C0,#40,#40,#40,#00
	DB	#F0,#80,#E0,#F0,#80,#90,#F0,#00,#80,#40,#40,#80,#40,#C0,#80,#00
	DB	#F0,#80,#80,#80,#C0,#C0,#F0,#00,#C0,#C0,#00,#00,#00,#40,#C0,#00
	DB	#F0,#60,#60,#40,#40,#40,#F0,#00,#80,#40,#40,#40,#C0,#C0,#80,#00
	DB	#F0,#80,#C0,#F0,#C0,#80,#F0,#00,#C0,#C0,#00,#80,#00,#C0,#C0,#00
	DB	#F0,#90,#80,#F0,#80,#C0,#C0,#00,#C0,#C0,#00,#80,#00,#00,#00,#00
	DB	#F0,#90,#80,#90,#C0,#C0,#F0,#00,#C0,#C0,#00,#C0,#40,#40,#C0,#00
	DB	#C0,#C0,#80,#F0,#80,#80,#80,#00,#40,#40,#40,#C0,#40,#C0,#C0,#00
	DB	#70,#10,#10,#10,#10,#50,#70,#00,#C0,#40,#00,#00,#00,#00,#C0,#00
	DB	#70,#50,#10,#10,#10,#90,#60,#00,#C0,#40,#00,#80,#80,#00,#00,#00
	DB	#C0,#90,#A0,#D0,#80,#80,#80,#00,#80,#00,#00,#00,#80,#C0,#C0,#00
	DB	#C0,#C0,#C0,#80,#80,#90,#F0,#00,#00,#00,#00,#00,#00,#80,#80,#00
	DB	#80,#E0,#90,#90,#B0,#80,#C0,#00,#20,#E0,#20,#20,#A0,#20,#60,#00
	DB	#80,#C0,#C0,#B0,#80,#80,#80,#00,#C0,#40,#40,#40,#C0,#C0,#40,#00
	DB	#F0,#C0,#C0,#80,#80,#80,#F0,#00,#C0,#40,#40,#40,#C0,#C0,#C0,#00
	DB	#F0,#C0,#80,#F0,#80,#C0,#C0,#00,#C0,#40,#C0,#C0,#00,#00,#00,#00
	DB	#F0,#C0,#C0,#80,#90,#80,#F0,#00,#C0,#40,#40,#40,#40,#80,#40,#00
	DB	#F0,#C0,#80,#F0,#90,#C0,#C0,#00,#C0,#40,#C0,#C0,#00,#80,#C0,#00
	DB	#F0,#80,#80,#70,#00,#80,#F0,#00,#C0,#40,#00,#80,#40,#40,#C0,#00
	DB	#70,#10,#10,#10,#30,#30,#30,#00,#C0,#00,#00,#00,#00,#00,#00,#00
	DB	#C0,#C0,#80,#80,#80,#80,#F0,#00,#40,#40,#40,#C0,#C0,#C0,#C0,#00
	DB	#C0,#80,#80,#40,#40,#30,#30,#00,#40,#40,#40,#80,#80,#00,#00,#00
	DB	#80,#80,#80,#B0,#B0,#C0,#80,#00,#40,#40,#40,#40,#40,#C0,#40,#00
	DB	#C0,#C0,#40,#30,#40,#C0,#C0,#00,#C0,#C0,#80,#00,#80,#C0,#C0,#00
	DB	#80,#80,#40,#20,#10,#10,#10,#00,#60,#60,#40,#80,#00,#80,#80,#00
	DB	#F0,#80,#00,#30,#40,#80,#F0,#00,#C0,#40,#80,#00,#00,#40,#C0,#00
	DB	#70,#60,#60,#40,#40,#40,#70,#00,#C0,#00,#00,#00,#00,#C0,#C0,#00




CHOLOGO
; Genere par ConvImgCpcVersion Beta - 1.0.7530.30816
; mode ecran 1
; Taille (nbColsxNbLignes) 79x38
	DB	#00
	DB	#11,#FF,#FF,#FF,#FF,#FF,#FF,#EE,#00,#33,#FF,#FF,#EE,#00,#00,#00
	DB	#33,#FF,#FF,#EE,#00,#00,#F8,#E2,#77,#FF,#FF,#33,#FF,#88,#00,#00
	DB	#00,#00,#00,#00,#77,#FF,#FF,#33,#FF,#FF,#CC,#FF,#EE,#00,#00,#11
	DB	#FF,#EE,#77,#FF,#FF,#99,#FF,#CC,#00,#00,#77,#FF,#88,#FF,#FF,#88
	DB	#FF,#FF,#00,#00,#33,#FF,#EE,#77,#FF,#FF,#99,#FF,#CC,#00,#00,#74
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F1,#00,#32,#F0,#F0,#E2,#00,#00,#00,#32
	DB	#F0,#F0,#E2,#00,#11,#F0,#E2,#74,#F0,#F1,#32,#F0,#C4,#00,#00,#00
	DB	#00,#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F1,#00,#00,#32,#F0
	DB	#E2,#74,#F0,#F0,#99,#F0,#E2,#00,#00,#F8,#F0,#99,#F0,#F0,#C4,#F8
	DB	#F0,#88,#00,#74,#F0,#E2,#74,#F0,#F0,#99,#F0,#E2,#00,#00,#F8,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#88,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0
	DB	#F0,#E2,#00,#32,#F0,#E2,#74,#F0,#F1,#32,#F0,#E2,#00,#00,#00,#00
	DB	#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#88,#00,#74,#F0,#E2
	DB	#74,#F0,#F0,#99,#F0,#F1,#00,#11,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0
	DB	#C4,#00,#F8,#F0,#E2,#74,#F0,#F0,#99,#F0,#F1,#00,#33,#F0,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#C4,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0
	DB	#E2,#00,#74,#F0,#E2,#74,#F0,#F1,#32,#F0,#F1,#00,#00,#00,#00,#00
	DB	#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#C4,#00,#F8,#F0,#E2,#74
	DB	#F0,#F0,#99,#F0,#F0,#88,#32,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#E2
	DB	#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#88,#74,#F0,#F0,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2
	DB	#00,#F8,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#88,#00,#00,#00,#00,#00
	DB	#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#E2,#11,#F0,#F0,#E2,#74,#F0
	DB	#F0,#99,#F0,#F0,#C4,#32,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#11
	DB	#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#74,#F0,#F0,#F0,#F0,#F0
	DB	#F0,#F0,#F0,#F3,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#11
	DB	#F0,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#C4,#00,#00,#00,#00,#00,#74
	DB	#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#74,#F0,#F0
	DB	#99,#F0,#F0,#C4,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0
	DB	#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#E2,#74,#F0,#F0,#F0,#F0,#F0,#F0
	DB	#F0,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#32,#F0
	DB	#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0
	DB	#F1,#32,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#74,#F0,#F0,#99
	DB	#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0
	DB	#E2,#74,#F0,#F0,#99,#F0,#F0,#E2,#77,#FF,#FF,#FF,#FF,#FF,#FF,#FF
	DB	#FF,#FF,#33,#FF,#FF,#EE,#00,#00,#00,#33,#FF,#FF,#EE,#33,#FF,#FF
	DB	#EE,#77,#FF,#FF,#33,#FF,#FF,#EE,#00,#00,#00,#00,#00,#77,#FF,#FF
	DB	#33,#FF,#FF,#CC,#FF,#FF,#FF,#33,#FF,#FF,#EE,#77,#FF,#FF,#99,#FF
	DB	#FF,#EE,#77,#FF,#FF,#99,#FF,#FF,#CC,#FF,#FF,#FF,#33,#FF,#FF,#EE
	DB	#77,#FF,#FF,#99,#FF,#FF,#EE,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#77,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#33
	DB	#FF,#FF,#EE,#00,#00,#00,#33,#FF,#FF,#EE,#33,#FF,#FF,#EE,#00,#00
	DB	#00,#33,#FF,#FF,#EE,#00,#00,#00,#00,#00,#77,#FF,#FF,#00,#00,#00
	DB	#00,#FF,#FF,#FF,#33,#FF,#FF,#EE,#00,#00,#00,#11,#FF,#FF,#EE,#77
	DB	#FF,#FF,#99,#FF,#FF,#CC,#FF,#FF,#FF,#33,#FF,#FF,#EE,#00,#00,#00
	DB	#11,#FF,#FF,#EE,#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0
	DB	#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00
	DB	#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00
	DB	#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0
	DB	#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11
	DB	#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0
	DB	#E2,#FF,#FF,#FF,#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32
	DB	#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8
	DB	#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0
	DB	#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0
	DB	#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2
	DB	#F8,#F0,#F0,#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0
	DB	#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0
	DB	#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0,#99
	DB	#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0
	DB	#E2,#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8
	DB	#F0,#F0,#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0
	DB	#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1
	DB	#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0
	DB	#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2
	DB	#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0
	DB	#F0,#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2
	DB	#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32
	DB	#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0
	DB	#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74
	DB	#F0,#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0
	DB	#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00
	DB	#00,#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0
	DB	#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4
	DB	#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0
	DB	#F1,#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA
	DB	#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00
	DB	#00,#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0
	DB	#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8
	DB	#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1
	DB	#00,#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0
	DB	#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00
	DB	#00,#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2
	DB	#11,#FF,#FF,#FF,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0
	DB	#F1,#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00
	DB	#00,#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0,#F0
	DB	#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00
	DB	#00,#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32
	DB	#F0,#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1
	DB	#32,#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00
	DB	#00,#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0,#F0,#E2
	DB	#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00
	DB	#74,#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32,#F0
	DB	#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32
	DB	#F0,#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00
	DB	#00,#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0,#F0,#E2,#32
	DB	#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74
	DB	#F0,#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32,#F0,#F0
	DB	#F0,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0
	DB	#F0,#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00
	DB	#00,#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0,#F0,#E2,#32,#F0
	DB	#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0
	DB	#F1,#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32,#F0,#F0,#F0
	DB	#F0,#F0,#C0,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0
	DB	#E2,#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00,#00
	DB	#00,#00,#32,#F0,#F0,#E2,#F8,#F0,#F0,#BA,#F0,#F0,#E2,#32,#F0,#F0
	DB	#E2,#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1
	DB	#00,#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32,#F0,#F0,#F0,#F0
	DB	#F0,#C4,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2
	DB	#00,#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00,#00,#00
	DB	#00,#32,#F0,#F0,#E2,#FF,#FF,#FF,#BA,#F0,#F0,#E2,#32,#F0,#F0,#E2
	DB	#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00
	DB	#00,#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#32,#F0,#F0,#F0,#F0,#F0
	DB	#88,#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00
	DB	#00,#00,#11,#F0,#F0,#E2,#74,#F0,#F1,#00,#00,#00,#00,#00,#00,#00
	DB	#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00
	DB	#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#00,#00
	DB	#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#11,#FF,#FF,#FF,#FF,#FF,#00
	DB	#74,#F0,#F0,#99,#F0,#F0,#C4,#F8,#F0,#F1,#32,#F0,#F0,#E2,#00,#00
	DB	#00,#11,#F0,#F0,#E2,#77,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#33
	DB	#FF,#FF,#EE,#00,#00,#00,#33,#FF,#FF,#EE,#33,#FF,#FF,#EE,#00,#00
	DB	#00,#33,#FF,#FF,#EE,#00,#00,#00,#00,#00,#77,#FF,#FF,#00,#00,#00
	DB	#00,#FF,#FF,#FF,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#00,#00,#77
	DB	#FF,#FF,#99,#FF,#FF,#CC,#FF,#FF,#FF,#33,#FF,#FF,#EE,#00,#00,#00
	DB	#11,#FF,#FF,#EE,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#32,#F0,#F0,#E2,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#77,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#33,#FF,#FF,#EE
	DB	#00,#00,#00,#33,#FF,#FF,#EE,#33,#FF,#FF,#EE,#77,#FF,#FF,#33,#FF
	DB	#FF,#EE,#00,#00,#00,#00,#00,#77,#FF,#FF,#33,#FF,#FF,#CC,#FF,#FF
	DB	#FF,#32,#F0,#F0,#F3,#FF,#FF,#FF,#FF,#FF,#EE,#00,#77,#FF,#FF,#88
	DB	#00,#00,#00,#FF,#FF,#FF,#33,#FF,#FF,#EE,#77,#FF,#FF,#99,#FF,#FF
	DB	#EE,#74,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#32,#F0,#F0,#E2,#00
	DB	#00,#00,#32,#F0,#F0,#E2,#32,#F0,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0
	DB	#E2,#00,#00,#00,#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#F1
	DB	#32,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#00,#74,#F0,#F0,#88,#00
	DB	#00,#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#E2
	DB	#74,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#32,#F0,#F0,#E2,#00,#00
	DB	#00,#32,#F0,#F0,#E2,#32,#F0,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#E2
	DB	#00,#00,#00,#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#F1,#32
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#88,#74,#F0,#F0,#88,#00,#00
	DB	#00,#F8,#F0,#F1,#32,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#E2,#74
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#32,#F0,#F0,#E2,#00,#00,#00
	DB	#32,#F0,#F0,#E2,#32,#F0,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#C4,#00
	DB	#00,#00,#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#E2,#32,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#C4,#74,#F0,#F0,#88,#00,#00,#00
	DB	#F8,#F0,#F1,#11,#F0,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#E2,#74,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F0,#E2,#32,#F0,#F0,#E2,#00,#00,#00,#32
	DB	#F0,#F0,#E2,#11,#F0,#F0,#E2,#74,#F0,#F1,#32,#F0,#F0,#88,#00,#00
	DB	#00,#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#C4,#11,#F8,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#88,#00,#00,#00,#F8
	DB	#F0,#F1,#00,#F8,#F0,#E2,#74,#F0,#F0,#99,#F0,#F0,#C4,#32,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#CC,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0
	DB	#F0,#E2,#00,#F8,#F0,#E2,#74,#F0,#F1,#32,#F0,#F1,#00,#00,#00,#00
	DB	#00,#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F0,#88,#00,#74,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#88,#00,#00,#00,#F8,#F0
	DB	#F1,#00,#74,#F0,#E2,#74,#F0,#F0,#99,#F0,#F1,#88,#11,#FC,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#F3,#00,#32,#F0,#F0,#E2,#00,#00,#00,#32,#F0,#F0
	DB	#E2,#00,#74,#F0,#E2,#74,#F0,#F1,#32,#F0,#E2,#00,#00,#00,#00,#00
	DB	#00,#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#F3,#00,#00,#33,#F0,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#88,#00,#00,#00,#F8,#F0,#F1
	DB	#00,#32,#F0,#E2,#74,#F0,#F0,#99,#F0,#E2,#00,#00,#33,#FF,#FF,#FF
	DB	#FF,#FF,#FF,#CC,#00,#33,#FF,#FF,#EE,#00,#00,#00,#33,#FF,#FF,#EE
	DB	#00,#33,#FF,#EE,#77,#FF,#FF,#33,#FF,#CC,#00,#00,#00,#00,#00,#00
	DB	#74,#F0,#F1,#32,#F0,#F0,#C4,#F8,#C4,#00,#00,#00,#F8,#F0,#F0,#F0
	DB	#F0,#F0,#F0,#F0,#E2,#74,#F0,#F0,#88,#00,#00,#00,#F8,#F0,#F1,#00
	DB	#11,#F8,#E2,#74,#F0,#F0,#99,#F0,#CC,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#77
	DB	#FF,#FF,#33,#FF,#FF,#CC,#FF,#00,#00,#00,#00,#33,#FF,#FF,#FF,#FF
	DB	#FF,#FF,#FF,#EE,#77,#FF,#FF,#88,#00,#00,#00,#FF,#FF,#FF,#00,#00
	DB	#77,#EE,#77,#FF,#FF,#99,#FF ; 2 zeros enleves


SOLEILDATA

; Genere par ConvImgCpcVersion Beta - 1.0.7530.30816
; mode ecran 1
; Taille (nbColsxNbLignes) 19x45
	DB	#00,#00,#00,#00,#00,#00,#00,#01,#0F,#0F,#0C,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#03,#0F,#0F,#0F,#0F,#0E,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#01,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0C,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#07,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#01,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0C,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#01,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0C,#00,#00,#00,#00,#00,#00,#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0E,#00,#00,#00,#00,#00,#00,#00,#07,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#00,#00,#00,#00,#00,#01,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0C,#00,#00,#00,#00,#00
	DB	#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0E,#00,#00
	DB	#00,#00,#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#00,#00,#00,#00,#00,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#08,#00,#00,#00,#00,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#00,#00,#00,#01,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0C,#00,#00,#00,#03,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0E,#00,#00
	DB	#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#00,#00,#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#00,#00,#00,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#00,#01,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#00,#01,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0C,#00,#01
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0C,#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0E,#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0E,#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0E,#00,#07,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#07,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#00,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#08,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#08,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#08,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#07,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#07,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#00,#03,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0E
	DB	#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0E,#00,#03,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F,#0F
	DB	#0F,#0F,#0F,#0F,#0F,#0E,#00

tblsplit  


	db #4C,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4D,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4F,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4C,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4D,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4C,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4C,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C
	db #4C,#5F,#4C,#4F,#4E,#5F,#5F,#4C,#4F,#4E,#4C


tblazur	
	;ds 27,#54
	DB #5C,#5C,#5C,#5C,#54,#5C
	DB #5C,#4C,#4C,#4C,#4E,#4E,#4E,#4E,#4E,#4E,#4A,#4A,#4A,#4A,#43,#4B,#4B,#4B,#4B,#4B,#5B
	DB #5B,#53,#53,#5F,#5F,#57,#57,#55,#55,#55,#44,#44,#44,#44,#44

;;;;;;;;;;;;;
;	ds 22,#44
;	db #55,#44,#44,#44,#44,#44,#55,#55,#55,#55,#55,#55,#53,#55,#55,#55,#55
;	db #53,#53,#53,#4B,#53,#53,#53,#5B,#5B,#4B,#4B
;	ds 10,#4B

;	db #44,#55,#5F,#53,#5B,#4B,#4B,#4B,#4B,#4B,#4B,#5B,#53,#5F,#55,#44
;	db #44,#55,#5F,#53,#5B,#4B,#4B,#4B,#4B,#4B,#4B,#5B,#53,#5F,#55,#44
;	db #44,#55,#5F,#53,#5B,#4B,#4B,#4B,#4B,#4B,#4B,#5B,#53,#5F,#55,#44
;	db #44,#55,#5F,#53,#5B,#4B,#4B,#4B,#4B,#4B,#4B,#5B,#53,#5F,#55,#44
;	db #44,#55,#5F,#53,#5B,#4B,#4B,#4B,#4B,#4B,#4B,#5B,#53,#5F,#55,#44
;
;

tblrast2    DEFB #4C,#5C,#5C,#5C,#5C,#5C,#5C,#5C
tablefond2  DEFB #5E,#52,#42,#5A,#59,#4B,#4B,#59,#5A
	
CHAINE  DEFB "IMPACT(C) 2020"
	DEFB #FF



texte  defb " C''EST CHO ET CA LE RESTERA TOUT L''ETE.....     "
       defb " THIS DEMO WAS CREATED IN AUGUST 2020 FOR THE ASM "
       defb " SUMMER THEM CONTEST OF AMSTRAD.EU           "
       defb " DEMO CODED BY CMP AND DEMONIAK, GFX BY KRIS AND CMP , IN LESS THAN THREE DAYS. "
       defb "       MUSIC OF WARHAWK BY ROB HUBBARD                            "
       defb " THIS DEMO IS ALSO A TRIBUTE TO OUR LATE FEFESSE  "
       defb "                                                  "
       defb " IMPACT TEAM IS  AST, DEMONIAK, KRIS , SID ,"
       defb " DEVILMARKUS, CMP                           "
	db 	#80 ; Code pour animer les palmiers
       defb " NOW IT''S THE TIME TO IMMORTALS GREETINGS......  "
       defb "  GREETINGS ARE GOING TO   VANITY, LOGON SYSTEM, CONDENSE,"
       defb "GPA, BATMAN GROUP, ARKOS, MORTEL, OVERLANDERS, PRALINE, DIRTY MINDS, ODIESOFT, PRODATRON, "
       defb "BENEDICTION, DUFFY, SOLORENZO, SPECTRO88, THE DOCTOR, SHINRA, FLOWER CORP, MORTEL,  "
       defb "TOTO, XTRABET, FUTURS, VOXY, LONE, SYLVAIN ROUVIERE, ZIK, "
       defb "JB LE DARON, HWIKAA, HLIDE, GYNECEON, GRIM, DRILL,BARJACK, EMERIC, KRUSTY, MVKTHEBOSS, SPECTRO88, "
       defb "DLFRSILVER, DECKARD, CHANY, BSC, BOISSETAR, TWOMAG, MADE, OPTIMUS, "
       defb "KHOMENOR, GOLEM13, ROUDOUDOU, HICKS, ELIOT, OVERFLOW, FUTURESOFT, XTRABET, "
       defb " TARGHAN, TOMS, TOM&JERRY, OFFSET, MCDEATH, BEB, MADRAM, EXECUTIONER,  "
       defb "STEPH, ROUDOUDOU, CHESHIRECATE, BSC, NORECESS, CED, GGP, TITAN, ALEXANDRE NOYER,   "
       defb " ERIC BOULAT, FREDERIC BELLEC, HERMOL, MEGACHUR, KUKULCAN, PIERRE VANH,   "
       defb " AND OF COURSE THE WHOLE IMPACT TEAM MEMBERS :)  "
       defb " IT''S REALLY COOL TO SEE THAN IN 2020, THE CPC SCENE IS ALWAYS ALIVE . I LOVE YOU....  "
       defb "                   CMP, KRIS AND DEMONIAK SIGNING OFF THE 17 OF AUGUST 2020     "
       defb " READ AMSTRAD.EU, CPC RULEZ, CPC POWER ,  MEMORYFULL.NET  AMSTRADPLUS.FORUMFOREVER.COM " 
       defb "  AND   USE  OUR IMPACT TOOLS AS : IMPDOS, IMPDRAW, CONVIMG, MANAGEDSK, JAVACPC  "
       defb " IT WILL BE GOOD & COOL FOR U ......                "      
       defb " BY THE WAY FOR ENJOY, USE 1 OR 2 KEYS TO CHANGE PALM RASTERS           "	                
       defb " AND A, W, Q KEYS TO STOP OR START THE SUN RASTER SCROLL....            "	                

       defb #FF

tblrast	defb #4C

	defs 10,#5C
	defb  #4C
	;defs #,#5C   ; ???
    db #5C   ; ???
	defb  #4C
	defs 6,#5C
	defb #4C
	defs 4,#5C
	defb #4C
	defs 2,#5C
	defb #4C
	defb #5C
	defb #4E


	defs 10,#4C
	defb  #4E
	defs 8,#4C
	defb  #4E
	defs 6,#4C
	defb #4E
	defs 4,#4C
	defb #4E
	defs 2,#4C
	defb #4E
	defb #4C
	defb #4E
	defb #4A
	DS 10,#4E
	DEFB #4A

	DS 8,#4E
	DEFB #4A
	DS 6,#4E
	DEFB #4A
	DS 4,#4E
	DEFB #4A
	DS 2,#4E
	DEFB #4A
	DEFB #4E
	DEFB #4A

	DEFB #4E



	DS 8,#4A
	DEFB #4B
	DS 6,#4A
	DEFB #4A
	DS 4,#4A
	DEFB #4B
	DS 2,#4B
	DEFB #4C
	DEFB #4C
	DEFB #4C

	DEFB #4A

tablesoleil
	DS 6,#4B   ;73
	DB #4B,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4E,#4A
	DB #4E,#4E,#4E,#4E,#4E,#4E,#4C,#4E
	DB #4E,#4C,#4C,#4C,#4C,#4C,#4C,#4C,#5C
	DB #4C,#5C,#5C,#58,#58,#58,#58,#5D,#5D,#4C,#4D,#4D,#4E,#4E,#4E,#47,#47,#4F
	DB #4F,#4F,#4A,#43,#43,#4A,#4F,#4F
	DB #4F,#47,#47,#4E,#4E,#4E,#4D,#4D,#4C,#5D,#5D,#58,#58,#58,#58,#5C,#5C,#4C
	DB #5C,#4C,#4C,#4C,#4C,#4C,#4C,#4C,#4E
	DB #4E,#4C,#4E,#4E,#4E,#4E,#4E,#4E
	DB #4A,#4E,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4A,#4B
finsoleil:

tablefond
	ds 100,#54
	DB #56,#52,#56,#56,#52,#52,#52,#56,#56,#52,#52,#52,#59,#5A,#5A,#5A
	DB #56,#56,#52,#52,#52,#5A,#5A,#5A,#5A,#59,#59,#59,#43
	DB #43
	DS 8,#4B
        DB #43
	DB #43,#59,#59,#59,#5A,#5A,#5A,#5A,#52,#52,#52,#52,#56,#56
	DB #59,#5A,#5A,#5A,#52,#52,#52,#56,#56,#52,#52,#52,#56,#56,#52,#56
	ds 90,#54

tablefondo
	ds 100,#54
	DB #5C,#4C,#5C,#5C,#4C,#4C,#4C,#5C,#5C,#4C,#4C,#4C,#4E,#4E,#4E,#4E
	DB #5C,#5C,#4C,#4C,#4C,#4E,#4E,#4E,#4E,#4A,#4A,#4A,#4A
	DS 10,#4B
	DB #4A,#4A,#4A,#4A,#4E,#4E,#4E,#4E,#4C,#4C,#4C,#4C,#5C,#5C
	DB #4E,#4E,#4E,#4E,#4C,#4C,#4C,#5C,#5C,#4C,#4C,#4C,#5C,#5C,#4C,#5C
	ds 130,#54

tablefondfixe
	DB #56,#52,#56,#56,#52,#52,#52,#56,#56,#52,#52,#52,#59,#5A,#5A,#5A
	DB #56,#56,#52,#52,#52,#5A,#5A,#5A,#5A,#59,#59,#59,#43
	DB #43
	DS 7,#4B
	DB #43,#59,#59,#59,#5A,#5A,#5A,#5A,#52,#52,#52,#52,#56,#56
	ds 29,#5C ; Marron

	List
	Align	256		; Doit etre un multiple de 256
FonteAscii:
	DB	#50,#A0,#A0,#50
	DB	#05,#0A,#0A,#05
	DB	#55,#AA,#AA,#55
	DB	#A5,#5A,#5A,#A5
	DB	#F5,#FA,#FA,#F5
	DB	#5F,#AF,#AF,#5F
	DB	#30,#C0,#C0,#30
	DB	#03,#0C,#0C,#03
	DB	#33,#CC,#CC,#33
	DB	#C3,#3C,#3C,#C3
	DB	#F3,#FC,#FC,#F3
	DB	#3F,#CF,#CF,#3F
	DB	#00,#00,#00,#00
	DB	#F0,#F0,#F0,#F0
	DB	#0F,#0F,#0F,#0F
	DB	#FF,#FF,#FF,#FF
buffer:


SAVE ''cho.bin'',#1000,buffer-#1000,DSK,''cho.dsk''


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
