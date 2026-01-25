-- Migration: Import z80code projects batch 60
-- Projects 119 to 120
-- Generated: 2026-01-25T21:43:30.201407

-- Project 119: program51 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program51',
    'Imported from z80Code. Author: gurneyh. affichage simple',
    'public',
    false,
    false,
    '2019-11-17T15:29:13.688000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'NUM_SPRITES EQU 10		;  Num of sprites
SEP         EQU 3	    ;  Separation between sprites

; =============================================================
; Gate Array
; =============================================================
; http://www.cpcwiki.eu/index.php/Gate_Array
; http://quasar.cpcscene.net/doku.php?id=assem:gate_array
; -------------------------------------------------------------
;  I/O port address
GATE_ARRAY:     equ #7f00

; -------------------------------------------------------------
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

macro SET_COLOR INK,COL 
                LD bc, GATE_ARRAY |{INK}
                OUT (c), c
                LD c, ({COL} & 31) | 64
                OUT (c), c
endm
              ; ================================================================
; PPI
; ==============================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc
; --------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700

macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
endm


macro bc26_hl:
                ld a, h 
                add a, 8 
                ld h, a 
                jr nc, @end
                ld a, #50
                add l
                ld l, a 
                ld a, #c0
                adc h 
                ld h, a
@end
mend              
                
                di
                ld hl, #c9fb 
                ld (#38), hl 
                ei
				ld ix, traj
                SET_MODE 0
                
                SET_COLOR 0,#14
                SET_COLOR 1,#04
                SET_COLOR 2,#15
                SET_COLOR 3,#17
                SET_COLOR 4,#18
                SET_COLOR 5,#1D               
                
main_loop:
                WAIT_VBL (void)
				
                
index:          ld ix,traj

				SET_COLOR 16, #4c
                

repeat NUM_SPRITES,n
				SET_COLOR 16, 3+(n&1)
				ld l,(IX+0)                
                ld h,(IX+1)                
                ld a,ixl
                add (2*SEP)
                ld ixl,a                
				call clear
rend

				SET_COLOR 16, #54

		        ld ix,(index+2)
                inc ixl
                inc ixl
                ld (index+2),ix
                

repeat NUM_SPRITES,n
				SET_COLOR 16, 1+(n&1)
    			ld l,(IX+0)
                ld h,(IX+1)
				ld a,ixl
                add (2*SEP)
                ld ixl,a
                call ball_0
rend
				SET_COLOR 16, #54

                jp main_loop


ball_0:
                di
                ld (.saveStack + 1), sp
                ld sp, ball
                ld b, 8
.loop:          pop de 
                ld (hl), e: inc hl 
                ld (hl), d: dec hl
                bc26_hl (void)
                djnz .loop
.saveStack:     ld sp, 0
                ei
                ret


clear:
				ld d, 0
repeat 8 
                ld (hl), d
                inc hl 
                ld (hl), d
                dec hl
                bc26_hl (void)
rend 
                ret


ball:
 DEFB #44,#08
 DEFB #44,#08
 DEFB #8c,#48
 DEFB #8c,#48
 DEFB #0c,#48 
 DEFB #0c,#48 
 DEFB #40,#80
 DEFB #40,#80

align 256 

traj:
	repeat 128,angle
    x = 40+30*cos(360*angle/128)
    y = 100+90*sin(2*360*angle/128)
	y0 = (y>>3)
    y1 = (y%8)
    dw #c000 + x + (y0*80) + (#800*y1)
    rend
    ',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: balls
  SELECT id INTO tag_uuid FROM tags WHERE name = 'balls';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 120: mon-nom est personne by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'mon-nom est personne',
    'Imported from z80Code. Author: tronic. AT2 : MOD import can generate PSG instruments instead of samples. Useful for conversion to soundchip!',
    'public',
    false,
    false,
    '2020-02-01T23:05:45.625000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; On Arkos Tracker 2 alpha 8
; https://www.julien-nevo.com/arkostracker/index.php/download/
;
; A new killer feature ?! oO ?! :
; - MOD import can generate PSG instruments instead of samples. Useful for conversion to soundchip!
;
; For this test, music comes from the movie "Mon nom est personne" (My name is nobody) ^^
; Original Amiga module (.mod / 4channels / Samples) found here :
; https://amp.dascene.net/downmod.php?index=5569
; Also put there (mod + aks) :
; https://index.amstrad.info/wp-content/uploads/martine/nobody.zip
;
; On AT2 import check "ignore sample (generate raw PSG instruments instead)"
; Work a little bit on it with the toolbox panel on the right to get "right" transpositions
; on (all or/and specific) instruments, etc... (it''s quite easy to understand...)
; Then work on your song as usual...
;
; Here is a quick result of this "pure amiga .mod" transfert 
; (Don''t blame me, i''m not a musician ^^)
; 
; Arkos rulez!


		org #c000
		run $

        di
        ld hl,#c9fb
        ld (#38),hl

		ld hl,Music         ; Initialisation
        xor a               ; Subsong #0.
        call PLY_LW_Init
        ei


vbl
        ld b,#f5
Sync:   in a,(c)
        rra
        jr nc,Sync
       	halt
        halt

        call PLY_LW_Play    ; Jouer la musique

        jp vbl

Music:

; Configuration that can be included to Arkos Tracker 2 players.
; It indicates what parts of code are useful to the song/sound effects, to save both memory and CPU.
; The players may or may not take advantage of these flags, it is up to them.
; You can either:
; - Include this to the source that also includes the player (BEFORE the player is included) (recommended solution).
; - Include this at the beginning of the player code.
; - Copy/paste this directly in the player.
; If you use one player but several songs, don''t worry, these declarations will stack up.
; If no configuration is used, the player will use default values (full code used).

	PLY_CFG_ConfigurationIsPresent = 1
	PLY_CFG_UseSpeedTracks = 1
	PLY_CFG_UseEffects = 1
	PLY_CFG_UseInstrumentLoopTo = 1
	PLY_CFG_NoSoftNoHard = 1
	PLY_CFG_SoftOnly = 1
	PLY_CFG_UseEffect_SetVolume = 1

; Song MY NAME IS NOBODY in Lightweight format (V1).
; Generated by Arkos Tracker 2.

MYNAMEISNOBODY_Start
MYNAMEISNOBODY_StartDisarkGenerateExternalLabel

MYNAMEISNOBODY_DisarkByteRegionStart0
	db "ATLW"	; Format marker (LightWeight).
	db 1	; Format version.
MYNAMEISNOBODY_DisarkByteRegionEnd0
MYNAMEISNOBODY_DisarkPointerRegionStart1
	dw MYNAMEISNOBODY_FmInstrumentTable
	dw MYNAMEISNOBODY_ArpeggioTable
	dw MYNAMEISNOBODY_PitchTable
; Table of the Subsongs.
	dw MYNAMEISNOBODY_Subsong0
MYNAMEISNOBODY_DisarkPointerRegionEnd1

; The Arpeggio table.
MYNAMEISNOBODY_ArpeggioTable
MYNAMEISNOBODY_DisarkWordRegionStart2
	dw 0
MYNAMEISNOBODY_DisarkWordRegionEnd2
MYNAMEISNOBODY_DisarkPointerRegionStart3
MYNAMEISNOBODY_DisarkPointerRegionEnd3

; The Pitch table.
MYNAMEISNOBODY_PitchTable
MYNAMEISNOBODY_DisarkWordRegionStart4
	dw 0
MYNAMEISNOBODY_DisarkWordRegionEnd4
MYNAMEISNOBODY_DisarkPointerRegionStart5
MYNAMEISNOBODY_DisarkPointerRegionEnd5

; The FM Instrument table.
MYNAMEISNOBODY_FmInstrumentTable
MYNAMEISNOBODY_DisarkPointerRegionStart6
	dw MYNAMEISNOBODY_FmInstrument0
	dw MYNAMEISNOBODY_FmInstrument1
	dw MYNAMEISNOBODY_FmInstrument2
	dw MYNAMEISNOBODY_FmInstrument3
	dw MYNAMEISNOBODY_FmInstrument4
MYNAMEISNOBODY_DisarkPointerRegionEnd6

MYNAMEISNOBODY_DisarkByteRegionStart7
MYNAMEISNOBODY_FmInstrument0
	db 255	; Speed.

MYNAMEISNOBODY_FmInstrument0Loop	db 0	; Volume: 0.

	db 4	; End the instrument.
MYNAMEISNOBODY_DisarkPointerRegionStart8
	dw MYNAMEISNOBODY_FmInstrument0Loop	; Loops.
MYNAMEISNOBODY_DisarkPointerRegionEnd8

MYNAMEISNOBODY_FmInstrument1
	db 0	; Speed.

	db 189	; Volume: 15.
	db 250	; Arpeggio: -3.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

MYNAMEISNOBODY_FmInstrument1Loop	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 4	; End the instrument.
MYNAMEISNOBODY_DisarkPointerRegionStart9
	dw MYNAMEISNOBODY_FmInstrument1Loop	; Loops.
MYNAMEISNOBODY_DisarkPointerRegionEnd9

MYNAMEISNOBODY_FmInstrument2
	db 0	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

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
MYNAMEISNOBODY_DisarkPointerRegionStart10
	dw MYNAMEISNOBODY_FmInstrument0Loop	; Loop to silence.
MYNAMEISNOBODY_DisarkPointerRegionEnd10

MYNAMEISNOBODY_FmInstrument3
	db 0	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

MYNAMEISNOBODY_FmInstrument3Loop	db 45	; Volume: 11.

	db 4	; End the instrument.
MYNAMEISNOBODY_DisarkPointerRegionStart11
	dw MYNAMEISNOBODY_FmInstrument3Loop	; Loops.
MYNAMEISNOBODY_DisarkPointerRegionEnd11

MYNAMEISNOBODY_FmInstrument4
	db 0	; Speed.

	db 189	; Volume: 15.
	db 216	; Arpeggio: -20.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 161	; Volume: 8.
	db 242	; Arpeggio: -7.

	db 157	; Volume: 7.
	db 242	; Arpeggio: -7.

	db 153	; Volume: 6.
	db 242	; Arpeggio: -7.

	db 149	; Volume: 5.
	db 242	; Arpeggio: -7.

	db 145	; Volume: 4.
	db 242	; Arpeggio: -7.

	db 141	; Volume: 3.
	db 242	; Arpeggio: -7.

	db 137	; Volume: 2.
	db 242	; Arpeggio: -7.

	db 133	; Volume: 1.
	db 242	; Arpeggio: -7.

	db 4	; End the instrument.
MYNAMEISNOBODY_DisarkPointerRegionStart12
	dw MYNAMEISNOBODY_FmInstrument0Loop	; Loop to silence.
MYNAMEISNOBODY_DisarkPointerRegionEnd12

MYNAMEISNOBODY_DisarkByteRegionEnd7
MYNAMEISNOBODY_Subsong0DisarkByteRegionStart0
; Song MY NAME IS NOBODY, Subsong 0 - Main - in Lightweight format (V1).
; Generated by Arkos Tracker 2.

MYNAMEISNOBODY_Subsong0
	db 6	; Initial speed.

; The Linker.
; Pattern 0
MYNAMEISNOBODY_Subsong0loop
	db 7	; State byte.
	db 3	; New speed.
	db 63	; New height.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart1
	dw MYNAMEISNOBODY_Subsong0_Track0, MYNAMEISNOBODY_Subsong0_Track1, MYNAMEISNOBODY_Subsong0_Track2
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd1
; The tracks.

; Pattern 1
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart2
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track5
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd2
; The tracks.

; Pattern 2
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart3
	dw MYNAMEISNOBODY_Subsong0_Track6, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track7
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd3
; The tracks.

; Pattern 3
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart4
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track8
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd4
; The tracks.

; Pattern 4
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart5
	dw MYNAMEISNOBODY_Subsong0_Track6, MYNAMEISNOBODY_Subsong0_Track9, MYNAMEISNOBODY_Subsong0_Track10
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd5
; The tracks.

; Pattern 5
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart6
	dw MYNAMEISNOBODY_Subsong0_Track11, MYNAMEISNOBODY_Subsong0_Track12, MYNAMEISNOBODY_Subsong0_Track13
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd6
; The tracks.

; Pattern 6
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart7
	dw MYNAMEISNOBODY_Subsong0_Track14, MYNAMEISNOBODY_Subsong0_Track15, MYNAMEISNOBODY_Subsong0_Track16
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd7
; The tracks.

; Pattern 7
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart8
	dw MYNAMEISNOBODY_Subsong0_Track17, MYNAMEISNOBODY_Subsong0_Track18, MYNAMEISNOBODY_Subsong0_Track19
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd8
; The tracks.

; Pattern 8
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart9
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track21, MYNAMEISNOBODY_Subsong0_Track22
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd9
; The tracks.

; Pattern 9
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart10
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track23, MYNAMEISNOBODY_Subsong0_Track24
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd10
; The tracks.

; Pattern 10
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart11
	dw MYNAMEISNOBODY_Subsong0_Track25, MYNAMEISNOBODY_Subsong0_Track26, MYNAMEISNOBODY_Subsong0_Track27
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd11
; The tracks.

; Pattern 11
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart12
	dw MYNAMEISNOBODY_Subsong0_Track28, MYNAMEISNOBODY_Subsong0_Track29, MYNAMEISNOBODY_Subsong0_Track30
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd12
; The tracks.

; Pattern 12
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart13
	dw MYNAMEISNOBODY_Subsong0_Track28, MYNAMEISNOBODY_Subsong0_Track31, MYNAMEISNOBODY_Subsong0_Track32
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd13
; The tracks.

; Pattern 13
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart14
	dw MYNAMEISNOBODY_Subsong0_Track14, MYNAMEISNOBODY_Subsong0_Track15, MYNAMEISNOBODY_Subsong0_Track16
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd14
; The tracks.

; Pattern 14
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart15
	dw MYNAMEISNOBODY_Subsong0_Track17, MYNAMEISNOBODY_Subsong0_Track18, MYNAMEISNOBODY_Subsong0_Track19
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd15
; The tracks.

; Pattern 15
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart16
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track21, MYNAMEISNOBODY_Subsong0_Track22
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd16
; The tracks.

; Pattern 16
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart17
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track23, MYNAMEISNOBODY_Subsong0_Track24
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd17
; The tracks.

; Pattern 17
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart18
	dw MYNAMEISNOBODY_Subsong0_Track25, MYNAMEISNOBODY_Subsong0_Track26, MYNAMEISNOBODY_Subsong0_Track27
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd18
; The tracks.

; Pattern 18
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart19
	dw MYNAMEISNOBODY_Subsong0_Track33, MYNAMEISNOBODY_Subsong0_Track34, MYNAMEISNOBODY_Subsong0_Track35
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd19
; The tracks.

; Pattern 19
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart20
	dw MYNAMEISNOBODY_Subsong0_Track36, MYNAMEISNOBODY_Subsong0_Track37, MYNAMEISNOBODY_Subsong0_Track38
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd20
; The tracks.

; Pattern 20
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart21
	dw MYNAMEISNOBODY_Subsong0_Track39, MYNAMEISNOBODY_Subsong0_Track40, MYNAMEISNOBODY_Subsong0_Track41
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd21
; The tracks.

; Pattern 21
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart22
	dw MYNAMEISNOBODY_Subsong0_Track42, MYNAMEISNOBODY_Subsong0_Track43, MYNAMEISNOBODY_Subsong0_Track44
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd22
; The tracks.

; Pattern 22
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart23
	dw MYNAMEISNOBODY_Subsong0_Track39, MYNAMEISNOBODY_Subsong0_Track45, MYNAMEISNOBODY_Subsong0_Track46
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd23
; The tracks.

; Pattern 23
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart24
	dw MYNAMEISNOBODY_Subsong0_Track47, MYNAMEISNOBODY_Subsong0_Track48, MYNAMEISNOBODY_Subsong0_Track49
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd24
; The tracks.

; Pattern 24
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart25
	dw MYNAMEISNOBODY_Subsong0_Track50, MYNAMEISNOBODY_Subsong0_Track51, MYNAMEISNOBODY_Subsong0_Track52
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd25
; The tracks.

; Pattern 25
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart26
	dw MYNAMEISNOBODY_Subsong0_Track53, MYNAMEISNOBODY_Subsong0_Track54, MYNAMEISNOBODY_Subsong0_Track55
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd26
; The tracks.

; Pattern 26
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart27
	dw MYNAMEISNOBODY_Subsong0_Track39, MYNAMEISNOBODY_Subsong0_Track56, MYNAMEISNOBODY_Subsong0_Track57
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd27
; The tracks.

; Pattern 27
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart28
	dw MYNAMEISNOBODY_Subsong0_Track58, MYNAMEISNOBODY_Subsong0_Track59, MYNAMEISNOBODY_Subsong0_Track60
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd28
; The tracks.

; Pattern 28
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart29
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track5
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd29
; The tracks.

; Pattern 29
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart30
	dw MYNAMEISNOBODY_Subsong0_Track6, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track7
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd30
; The tracks.

; Pattern 30
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart31
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track8
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd31
; The tracks.

; Pattern 31
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart32
	dw MYNAMEISNOBODY_Subsong0_Track6, MYNAMEISNOBODY_Subsong0_Track9, MYNAMEISNOBODY_Subsong0_Track10
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd32
; The tracks.

; Pattern 32
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart33
	dw MYNAMEISNOBODY_Subsong0_Track11, MYNAMEISNOBODY_Subsong0_Track12, MYNAMEISNOBODY_Subsong0_Track13
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd33
; The tracks.

; Pattern 33
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart34
	dw MYNAMEISNOBODY_Subsong0_Track14, MYNAMEISNOBODY_Subsong0_Track15, MYNAMEISNOBODY_Subsong0_Track16
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd34
; The tracks.

; Pattern 34
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart35
	dw MYNAMEISNOBODY_Subsong0_Track17, MYNAMEISNOBODY_Subsong0_Track18, MYNAMEISNOBODY_Subsong0_Track19
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd35
; The tracks.

; Pattern 35
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart36
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track21, MYNAMEISNOBODY_Subsong0_Track22
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd36
; The tracks.

; Pattern 36
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart37
	dw MYNAMEISNOBODY_Subsong0_Track20, MYNAMEISNOBODY_Subsong0_Track23, MYNAMEISNOBODY_Subsong0_Track24
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd37
; The tracks.

; Pattern 37
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart38
	dw MYNAMEISNOBODY_Subsong0_Track25, MYNAMEISNOBODY_Subsong0_Track26, MYNAMEISNOBODY_Subsong0_Track27
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd38
; The tracks.

; Pattern 38
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart39
	dw MYNAMEISNOBODY_Subsong0_Track33, MYNAMEISNOBODY_Subsong0_Track34, MYNAMEISNOBODY_Subsong0_Track35
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd39
; The tracks.

; Pattern 39
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart40
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track5
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd40
; The tracks.

; Pattern 40
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart41
	dw MYNAMEISNOBODY_Subsong0_Track6, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track7
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd41
; The tracks.

; Pattern 41
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart42
	dw MYNAMEISNOBODY_Subsong0_Track3, MYNAMEISNOBODY_Subsong0_Track4, MYNAMEISNOBODY_Subsong0_Track8
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd42
; The tracks.

; Pattern 42
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart43
	dw MYNAMEISNOBODY_Subsong0_Track61, MYNAMEISNOBODY_Subsong0_Track62, MYNAMEISNOBODY_Subsong0_Track10
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd43
; The tracks.

; Pattern 43
	db 1	; State byte.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart44
	dw MYNAMEISNOBODY_Subsong0_Track29, MYNAMEISNOBODY_Subsong0_Track63, MYNAMEISNOBODY_Subsong0_Track64
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd44
; The tracks.

	db 0	; End of the subsong.
MYNAMEISNOBODY_Subsong0DisarkPointerRegionStart45
	dw MYNAMEISNOBODY_Subsong0loop
MYNAMEISNOBODY_Subsong0DisarkPointerRegionEnd45

; The Tracks.
MYNAMEISNOBODY_Subsong0_Track0
	db 255, 82	; Escaped note: 82.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 49	; Long wait: 50.

	db 219	; Note: 51.
	db 4	; New instrument: 2.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 95	; Note: 55.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 99	; Note: 59.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 91	; Note: 51.
	db 130	; Volume + possible Pitch up/down.

MYNAMEISNOBODY_Subsong0_Track1
	db 226	; Note: 58.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 50	; Long wait: 51.

	db 28	; Note: 52.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 96	; Note: 56.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 88	; Note: 48.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.

MYNAMEISNOBODY_Subsong0_Track2
	db 214	; Note: 46.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 49	; Long wait: 50.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 221	; Note: 53.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 97	; Note: 57.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 89	; Note: 49.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.


MYNAMEISNOBODY_Subsong0_Track3
	db 219	; Note: 51.
	db 8	; New instrument: 4.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 14	; Long wait: 15.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 18	; Long wait: 19.


MYNAMEISNOBODY_Subsong0_Track4
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 91	; Note: 51.
	db 132	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 86	; Note: 46.
	db 132	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.


MYNAMEISNOBODY_Subsong0_Track5
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 29	; Note: 53.
	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track6
	db 219	; Note: 51.
	db 8	; New instrument: 4.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 14	; Long wait: 15.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 61, 18	; Long wait: 19.


MYNAMEISNOBODY_Subsong0_Track7
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track8
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track9
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 91	; Note: 51.
	db 132	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track10
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 29	; Note: 53.
	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track11
	db 219	; Note: 51.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 62	; Long wait: 63.


MYNAMEISNOBODY_Subsong0_Track12
	db 223	; Note: 55.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 58	; Long wait: 59.

	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track13
	db 62	; Short wait: 1.

	db 226	; Note: 58.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 126	; Short wait: 2.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 61, 4	; Long wait: 5.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track14
	db 226	; Note: 58.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 36	; Note: 60.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 98	; Note: 58.
	db 128	; Volume + possible Pitch up/down.
	db 61, 22	; Long wait: 23.

	db 39	; Note: 63.
	db 41	; Note: 65.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 103	; Note: 63.
	db 128	; Volume + possible Pitch up/down.
	db 61, 14	; Long wait: 15.

	db 38	; Note: 62.
	db 190	; Short wait: 3.

	db 39	; Note: 63.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track15
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 91	; Note: 51.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 6	; Long wait: 7.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 90	; Note: 50.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 61, 6	; Long wait: 7.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track16
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 14	; Note: 38.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 12	; Note: 36.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track17
	db 228	; Note: 60.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 38	; Note: 62.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 6	; Long wait: 7.

	db 41	; Note: 65.
	db 43	; Note: 67.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 105	; Note: 65.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 103	; Note: 63.
	db 128	; Volume + possible Pitch up/down.
	db 61, 18	; Long wait: 19.

	db 38	; Note: 62.
	db 190	; Short wait: 3.

	db 39	; Note: 63.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track18
	db 223	; Note: 55.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 61, 6	; Long wait: 7.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 61, 6	; Long wait: 7.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 61, 4	; Long wait: 5.

	db 20	; Note: 44.
	db 62	; Short wait: 1.

	db 20	; Note: 44.
	db 190	; Short wait: 3.

	db 20	; Note: 44.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track19
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 20	; Note: 44.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 20	; Note: 44.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track20
	db 230	; Note: 62.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 98	; Note: 58.
	db 128	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 98	; Note: 58.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 34	; Note: 58.
	db 61, 7	; Long wait: 8.

	db 63, 72	; Escaped note: 72.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 110	; Note: 70.
	db 128	; Volume + possible Pitch up/down.
	db 61, 14	; Long wait: 15.

	db 39	; Note: 63.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track21
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 61, 10	; Long wait: 11.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track22
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 10	; Note: 34.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track23
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 29	; Note: 53.
	db 61, 14	; Long wait: 15.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 10	; Note: 34.
	db 61, 4	; Long wait: 5.


MYNAMEISNOBODY_Subsong0_Track24
	db 223	; Note: 55.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track25
	db 230	; Note: 62.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 98	; Note: 58.
	db 128	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 98	; Note: 58.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 34	; Note: 58.
	db 61, 6	; Long wait: 7.

	db 44	; Note: 68.
	db 46	; Note: 70.
	db 126	; Short wait: 2.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 108	; Note: 68.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 43	; Note: 67.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track26
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 61, 6	; Long wait: 7.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.

	db 10	; Note: 34.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track27
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 10	; Note: 34.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track28
	db 235	; Note: 67.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 30	; Long wait: 31.

	db 41	; Note: 65.
	db 61, 22	; Long wait: 23.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track29
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 62	; Long wait: 63.


MYNAMEISNOBODY_Subsong0_Track30
	db 219	; Note: 51.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track31
	db 214	; Note: 46.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 58	; Long wait: 59.

	db 214	; Note: 46.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track32
	db 219	; Note: 51.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 27	; Note: 51.
	db 126	; Short wait: 2.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track33
	db 235	; Note: 67.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 18	; Long wait: 19.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 39	; Note: 63.
	db 61, 6	; Long wait: 7.

	db 41	; Note: 65.
	db 61, 18	; Long wait: 19.

	db 39	; Note: 63.
	db 190	; Short wait: 3.

	db 38	; Note: 62.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track34
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 61, 10	; Long wait: 11.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track35
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 10	; Note: 34.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track36
	db 231	; Note: 63.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 30	; Long wait: 31.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 22	; Long wait: 23.

	db 107	; Note: 67.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track37
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 91	; Note: 51.
	db 131	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 91	; Note: 51.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track38
	db 207	; Note: 39.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 29	; Note: 53.
	db 31	; Note: 55.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 86	; Note: 46.
	db 129	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 29	; Note: 53.
	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 86	; Note: 46.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track39
	db 235	; Note: 67.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 43	; Note: 67.
	db 61, 10	; Long wait: 11.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 43	; Note: 67.
	db 61, 6	; Long wait: 7.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 39	; Note: 63.
	db 61, 6	; Long wait: 7.

	db 41	; Note: 65.
	db 190	; Short wait: 3.

	db 43	; Note: 67.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track40
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.


MYNAMEISNOBODY_Subsong0_Track41
	db 226	; Note: 58.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 34	; Note: 58.
	db 61, 4	; Long wait: 5.


MYNAMEISNOBODY_Subsong0_Track42
	db 233	; Note: 65.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 46	; Long wait: 47.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 107	; Note: 67.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track43
	db 218	; Note: 50.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 26	; Note: 50.
	db 61, 6	; Long wait: 7.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 6	; Long wait: 7.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track44
	db 218	; Note: 50.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 4	; Long wait: 5.


MYNAMEISNOBODY_Subsong0_Track45
	db 216	; Note: 48.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.

	db 17	; Note: 41.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 17	; Note: 41.
	db 62	; Short wait: 1.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 12	; Note: 36.
	db 61, 4	; Long wait: 5.

	db 12	; Note: 36.
	db 62	; Short wait: 1.

	db 12	; Note: 36.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 6	; Long wait: 7.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track46
	db 216	; Note: 48.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.

	db 24	; Note: 48.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 4	; Long wait: 5.


MYNAMEISNOBODY_Subsong0_Track47
	db 235	; Note: 67.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 46	; Long wait: 47.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 127, 72	; Escaped note: 72.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 46	; Note: 70.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track48
	db 214	; Note: 46.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 8	; Long wait: 9.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 19	; Note: 43.
	db 62	; Short wait: 1.


MYNAMEISNOBODY_Subsong0_Track49
	db 226	; Note: 58.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 34	; Note: 58.
	db 62	; Short wait: 1.


MYNAMEISNOBODY_Subsong0_Track50
	db 255, 72	; Escaped note: 72.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 46	; Note: 70.
	db 190	; Short wait: 3.

	db 63, 72	; Escaped note: 72.
	db 61, 10	; Long wait: 11.

	db 46	; Note: 70.
	db 190	; Short wait: 3.

	db 63, 72	; Escaped note: 72.
	db 61, 6	; Long wait: 7.

	db 46	; Note: 70.
	db 190	; Short wait: 3.

	db 44	; Note: 68.
	db 61, 6	; Long wait: 7.

	db 46	; Note: 70.
	db 190	; Short wait: 3.

	db 63, 72	; Escaped note: 72.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track51
	db 212	; Note: 44.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 15	; Note: 39.
	db 62	; Short wait: 1.

	db 20	; Note: 44.
	db 61, 4	; Long wait: 5.

	db 15	; Note: 39.
	db 62	; Short wait: 1.

	db 20	; Note: 44.
	db 62	; Short wait: 1.

	db 15	; Note: 39.
	db 62	; Short wait: 1.

	db 20	; Note: 44.
	db 61, 6	; Long wait: 7.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 20	; Note: 44.
	db 61, 4	; Long wait: 5.

	db 20	; Note: 44.
	db 62	; Short wait: 1.

	db 20	; Note: 44.
	db 190	; Short wait: 3.

	db 8	; Note: 32.
	db 61, 6	; Long wait: 7.

	db 8	; Note: 32.
	db 62	; Short wait: 1.

	db 10	; Note: 34.
	db 62	; Short wait: 1.

	db 12	; Note: 36.
	db 62	; Short wait: 1.

	db 15	; Note: 39.
	db 62	; Short wait: 1.

	db 17	; Note: 41.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track52
	db 224	; Note: 56.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 32	; Note: 56.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 62	; Short wait: 1.


MYNAMEISNOBODY_Subsong0_Track53
	db 238	; Note: 70.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 44	; Note: 68.
	db 190	; Short wait: 3.

	db 46	; Note: 70.
	db 61, 10	; Long wait: 11.

	db 44	; Note: 68.
	db 190	; Short wait: 3.

	db 46	; Note: 70.
	db 61, 14	; Long wait: 15.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 107	; Note: 67.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 41	; Note: 65.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track54
	db 211	; Note: 43.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 10	; Long wait: 11.

	db 19	; Note: 43.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 190	; Short wait: 3.

	db 17	; Note: 41.
	db 61, 10	; Long wait: 11.

	db 27	; Note: 51.
	db 61, 10	; Long wait: 11.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 61, 6	; Long wait: 7.

	db 26	; Note: 50.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track55
	db 223	; Note: 55.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 62	; Short wait: 1.


MYNAMEISNOBODY_Subsong0_Track56
	db 204	; Note: 36.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 12	; Note: 36.
	db 62	; Short wait: 1.

	db 12	; Note: 36.
	db 190	; Short wait: 3.

	db 12	; Note: 36.
	db 61, 6	; Long wait: 7.

	db 12	; Note: 36.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 20	; Note: 44.
	db 61, 6	; Long wait: 7.

	db 20	; Note: 44.
	db 61, 6	; Long wait: 7.

	db 20	; Note: 44.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track57
	db 223	; Note: 55.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 24	; Note: 48.
	db 62	; Short wait: 1.

	db 24	; Note: 48.
	db 62	; Short wait: 1.


MYNAMEISNOBODY_Subsong0_Track58
	db 233	; Note: 65.
	db 2	; New instrument: 1.
	db 128	; Volume + possible Pitch up/down.
	db 61, 30	; Long wait: 31.

	db 39	; Note: 63.
	db 61, 14	; Long wait: 15.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 14	; Long wait: 15.


MYNAMEISNOBODY_Subsong0_Track59
	db 214	; Note: 46.
	db 6	; New instrument: 3.
	db 130	; Volume + possible Pitch up/down.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 61, 6	; Long wait: 7.

	db 91	; Note: 51.
	db 131	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 27	; Note: 51.
	db 61, 4	; Long wait: 5.

	db 91	; Note: 51.
	db 132	; Volume + possible Pitch up/down.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track60
	db 221	; Note: 53.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 29	; Note: 53.
	db 190	; Short wait: 3.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 26	; Note: 50.
	db 62	; Short wait: 1.

	db 15	; Note: 39.
	db 190	; Short wait: 3.

	db 86	; Note: 46.
	db 129	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 126	; Short wait: 2.

	db 29	; Note: 53.
	db 31	; Note: 55.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 91	; Note: 51.
	db 130	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.


MYNAMEISNOBODY_Subsong0_Track61
	db 196	; Note: 28.
	db 4	; New instrument: 2.
	db 128	; Volume + possible Pitch up/down.
	db 61, 62	; Long wait: 63.


MYNAMEISNOBODY_Subsong0_Track62
	db 219	; Note: 51.
	db 6	; New instrument: 3.
	db 132	; Volume + possible Pitch up/down.
	db 190	; Short wait: 3.

	db 27	; Note: 51.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 27	; Note: 51.
	db 61, 6	; Long wait: 7.

	db 60	; No note, effects only.
	db 143	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 91	; Note: 51.
	db 132	; Volume + possible Pitch up/down.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 61, 4	; Long wait: 5.

	db 22	; Note: 46.
	db 62	; Short wait: 1.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 22	; Note: 46.
	db 61, 6	; Long wait: 7.

	db 22	; Note: 46.
	db 190	; Short wait: 3.

	db 15	; Note: 39.
	db 61, 6	; Long wait: 7.


MYNAMEISNOBODY_Subsong0_Track63
	db 62	; Short wait: 1.

	db 214	; Note: 46.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 61	; Long wait: 62.


MYNAMEISNOBODY_Subsong0_Track64
	db 126	; Short wait: 2.

	db 219	; Note: 51.
	db 4	; New instrument: 2.
	db 130	; Volume + possible Pitch up/down.
	db 61, 60	; Long wait: 61.


MYNAMEISNOBODY_Subsong0DisarkByteRegionEnd0
        
Player:
    include "./PlayerLightweight.asm"',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: audio-amiga-mod-to-soundchip
  SELECT id INTO tag_uuid FROM tags WHERE name = 'audio-amiga-mod-to-soundchip';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
