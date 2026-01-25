-- Migration: Import z80code projects batch 72
-- Projects 143 to 144
-- Generated: 2026-01-25T21:43:30.203705

-- Project 143: sinus-scroll v3 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sinus-scroll v3',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2022-01-15T18:19:30.702000'::timestamptz,
    '2024-10-07T20:55:58.007000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; ==============================================================================
; PPI
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700


; ---------------------------------------------------------------------------
; WAIT_VBL
 macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
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

; ------------------------------------------------------------------------------
; ROM
UPPER_OFF       equ %00001000
UPPER_ON        equ %00000000
LOWER_OFF       equ %00000100
LOWER_ON        equ %00000000
ROM_OFF         equ UPPER_OFF | LOWER_OFF


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



macro SET_COLOR pen, ink
                ld bc, GATE_ARRAY | PENR | {pen}
                out (c), c
                ld c, {ink}
                out (c), c
endm




macro SET_BORDER ink 
                SET_COLOR #10, {ink}
endm

macro SET_MODE mode 
                LD bc, GATE_ARRAY | RMR | ROM_OFF | {mode}
                out (c), c
                print "Mode :", {hex}GATE_ARRAY | RMR | ROM_OFF | {mode}
endm

macro SET_PALETTE palette, start, length
                ld a, {start}
                ld c, {length}
                ld hl, {palette}
                ld b, hi(GATE_ARRAY)
@loop:
                out (c), a
                inc b
                outi
                inc a
                dec c
                jr nz, @loop
endm
; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00

; ---------------------------------------------------------------------------
; WRITE_CRTC
MACRO WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
ENDM

                org #40
module SinScroll

macro CALC_TILE_ADR
                ld h, a
                scf                              ; pour ajouter TILE_ADR au résultat (#4000)
                rr h  : rr l  
                srl h : rr l
endm


R1	equ 48
R2	equ 50
R3	equ 8
R6	equ 8
R7 	equ 14


charset ''0'', ''9'', 0
charset ''a'', ''z'', 10
charset ''!'', 36
charset ''.'', 37
charset '' '', 38

start:
	di
	ld hl, #c9fb
	ld (#38), hl
	ei 

	WRITE_CRTC 1, R1
	WRITE_CRTC 2, R2
	WRITE_CRTC 3, R3
	WRITE_CRTC 6, R6
	WRITE_CRTC 7, R7

	SET_MODE 0
	SET_PALETTE palette, 0, 16
    SET_BORDER Color.fm_0
main
.loop
	WAIT_VBL (void)


.text_ptr:	ld hl, text
	ld a, (hl)	; On lit le prochaine caractère
	
.col_count	ld h, 0 	; Colonne du caractère actuel
	ld l, 0
	srl h : rr l
	srl h : rr l   
	CALC_TILE_ADR	; Calcul de l''adresse du tile correspondant au caracère
.src	ld ix, write_scr_start + 128 * 64 + #09
	ld (render.tile_col + 1), hl
	call cp_chr
	call render	; On affiche la partie visible du buffer à l''écran
	
	ld a, (.col_count + 1) ; Incrémente le numéro de colonne du caractère
	inc a
	and 3	       ; on reste dans la fourchette [0, 4[
	ld (.col_count + 1), a ; sauvegarde le numéro de colonne
	or a
	jr nz, .end

	ld hl, (.text_ptr + 1)
	inc hl
	ld a, (hl)
	or a
	jr nz, .save_text_ptr

	ld hl, text
.save_text_ptr: ld (.text_ptr + 1), hl
.end
	
	
	jr .loop



cp_chr:

repeat 16, n
row = n - 1		; 16 lignes
	ld a, (hl)	; a = byte du caractère
	ld (ix + row * 3 + 1), a	; copie dans le buffer
	inc l	; prochain byte du caractère
rend		; pour toutes les lignes

	ret

align 16
palette
	db Color.fm_0
	db Color.fm_3
	db Color.fm_15
	db Color.fm_25
	db Color.fm_26
	ds 10


text:	db '' hello world                                 ''                                 
	db ''my first sinus scroll on the amstrad cpc !!!''
	db ''                                            '', 0

/*
 Table de la courbe

 Alignée sur 256 car ainsi, pour itérer et boucler sur cette table,
 il suffit d''incrémenter le LSB du pointeur sur la table.
*/
align 256
sin_tab
repeat 256, ii
i = ii - 1
off = floor(5 * sin(i / 256 * 360))
off1 = floor(7 * cos(i / 256 * 360 * 3))
/*  
 On mutliplie directement par 2 à la génération, ainsi il suffit d''une addition
 avec le pointeur sur le début début de l''adresse de la colonne pour avoir 
 le pointeur sur l''adresse écran correspondant à la valeur lue.
 
 Attention, la valeur de la courbe doit être stricteent inférérieur au nombre de lignes de 
 la table d''adresse - la hauteur de la fonte(64 - 16 ici)
*/
v = 16 + off + off1
assert v < 64 - 16

db 2 * v
rend

/*
 Table d''adresses écran

 Les adresses sont stockées en colonnes.
 Ainsi :
  - les words[0, 64[ sont les adresses de la colonne 0,
  - les words[64, 128[ sont les sont les adresses de le colonne 1, etc

 On s''aligne sur 256 car avec cet alignement pour passer d''une colonne à l''autre
 - si colonne paire, pour passer à la colonne suivante, il suffit de placer le bit 7 du LSB du pointeur
 - si colonne impaire, pour passer à la colonne suivante, il suffit d''incrémenter le MSB du pointeur 	
*/
align 256
adr
repeat R1 * 2, xx
 x = xx - 1 ; les compteurs de rasm débutent à 1 :(
 repeat 64, yy
  y = yy - 1 ; les compteurs de rasm débutent à 1 :(
  dw (#c000 + floor(y / 8) * R1 * 2 + (y & 7) * #800) + x
 rend ; next yy
rend ; next xx

org #4000
/*
 Fonte

 Alignée sur une page de 16ko pour faciliter le calcul de l''adresse d''un tile
 Overkill ici, car on ne lit l''adresse qu''une fois tous les 4 frames...
*/
font
;; Data created with Img2CPC - (c) Retroworks - 2007-2017
;; Tile fnt_savage1_000 - 2x16 pixels, 1x16 bytes.
fnt_savage1_000:
DEFB #00
DEFB #00
DEFB #00
DEFB #84
DEFB #18
DEFB #64
DEFB #64
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #4c
DEFB #04
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_001 - 2x16 pixels, 1x16 bytes.
fnt_savage1_001:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #0c
DEFB #08
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_002 - 2x16 pixels, 1x16 bytes.
fnt_savage1_002:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #4c
DEFB #c4
DEFB #10
DEFB #44
DEFB #10
DEFB #10
DEFB #44
DEFB #24
DEFB #48
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_003 - 2x16 pixels, 1x16 bytes.
fnt_savage1_003:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_004 - 2x16 pixels, 1x16 bytes.
fnt_savage1_004:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_005 - 2x16 pixels, 1x16 bytes.
fnt_savage1_005:
DEFB #00
DEFB #00
DEFB #40
DEFB #84
DEFB #64
DEFB #c0
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #c0
DEFB #0c
DEFB #64
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_006 - 2x16 pixels, 1x16 bytes.
fnt_savage1_006:
DEFB #00
DEFB #00
DEFB #c0
DEFB #64
DEFB #cc
DEFB #cc
DEFB #cc
DEFB #cc
DEFB #cc
DEFB #cc
DEFB #64
DEFB #64
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_007 - 2x16 pixels, 1x16 bytes.
fnt_savage1_007:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #08
DEFB #88
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_008 - 2x16 pixels, 1x16 bytes.
fnt_savage1_008:
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #90
DEFB #90
DEFB #c4
DEFB #40
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #64
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_009 - 2x16 pixels, 1x16 bytes.
fnt_savage1_009:
DEFB #00
DEFB #00
DEFB #c0
DEFB #64
DEFB #48
DEFB #08
DEFB #80
DEFB #48
DEFB #c4
DEFB #c4
DEFB #24
DEFB #8c
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_010 - 2x16 pixels, 1x16 bytes.
fnt_savage1_010:
DEFB #00
DEFB #00
DEFB #80
DEFB #8c
DEFB #cc
DEFB #cc
DEFB #64
DEFB #8c
DEFB #c8
DEFB #08
DEFB #80
DEFB #90
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_011 - 2x16 pixels, 1x16 bytes.
fnt_savage1_011:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #08
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_012 - 2x16 pixels, 1x16 bytes.
fnt_savage1_012:
DEFB #00
DEFB #00
DEFB #00
DEFB #84
DEFB #90
DEFB #c0
DEFB #00
DEFB #00
DEFB #44
DEFB #00
DEFB #c0
DEFB #90
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_013 - 2x16 pixels, 1x16 bytes.
fnt_savage1_013:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #48
DEFB #00
DEFB #10
DEFB #24
DEFB #80
DEFB #00
DEFB #00
DEFB #c0
DEFB #4c
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_014 - 2x16 pixels, 1x16 bytes.
fnt_savage1_014:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #4c
DEFB #24
DEFB #88
DEFB #84
DEFB #44
DEFB #44
DEFB #90
DEFB #64
DEFB #0c
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_015 - 2x16 pixels, 1x16 bytes.
fnt_savage1_015:
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_016 - 2x16 pixels, 1x16 bytes.
fnt_savage1_016:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #c4
DEFB #64
DEFB #64
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_017 - 2x16 pixels, 1x16 bytes.
fnt_savage1_017:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #44
DEFB #84
DEFB #c8
DEFB #48
DEFB #80
DEFB #80
DEFB #08
DEFB #98
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_018 - 2x16 pixels, 1x16 bytes.
fnt_savage1_018:
DEFB #00
DEFB #00
DEFB #00
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #24
DEFB #24
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #00

;; Tile fnt_savage1_019 - 2x16 pixels, 1x16 bytes.
fnt_savage1_019:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #c8
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_020 - 2x16 pixels, 1x16 bytes.
fnt_savage1_020:
DEFB #00
DEFB #00
DEFB #00
DEFB #10
DEFB #c4
DEFB #90
DEFB #90
DEFB #cc
DEFB #00
DEFB #00
DEFB #90
DEFB #c4
DEFB #04
DEFB #40
DEFB #00
DEFB #00

;; Tile fnt_savage1_021 - 2x16 pixels, 1x16 bytes.
fnt_savage1_021:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #8c
DEFB #48
DEFB #48
DEFB #cc
DEFB #40
DEFB #00
DEFB #00
DEFB #48
DEFB #cc
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_022 - 2x16 pixels, 1x16 bytes.
fnt_savage1_022:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #c0
DEFB #00
DEFB #00
DEFB #8c
DEFB #cc
DEFB #44
DEFB #90
DEFB #64
DEFB #8c
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_023 - 2x16 pixels, 1x16 bytes.
fnt_savage1_023:
DEFB #00
DEFB #00
DEFB #80
DEFB #c8
DEFB #88
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_024 - 2x16 pixels, 1x16 bytes.
fnt_savage1_024:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #90
DEFB #c4
DEFB #c4
DEFB #c4
DEFB #04
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_025 - 2x16 pixels, 1x16 bytes.
fnt_savage1_025:
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #64
DEFB #8c
DEFB #c8
DEFB #08
DEFB #08
DEFB #08
DEFB #48
DEFB #8c
DEFB #4c
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_026 - 2x16 pixels, 1x16 bytes.
fnt_savage1_026:
DEFB #00
DEFB #c4
DEFB #cc
DEFB #8c
DEFB #08
DEFB #10
DEFB #64
DEFB #44
DEFB #00
DEFB #40
DEFB #40
DEFB #90
DEFB #8c
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_027 - 2x16 pixels, 1x16 bytes.
fnt_savage1_027:
DEFB #00
DEFB #80
DEFB #88
DEFB #80
DEFB #00
DEFB #00
DEFB #08
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_028 - 2x16 pixels, 1x16 bytes.
fnt_savage1_028:
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #04
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #40
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_029 - 2x16 pixels, 1x16 bytes.
fnt_savage1_029:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #48
DEFB #00
DEFB #40
DEFB #10
DEFB #44
DEFB #c4
DEFB #24
DEFB #24
DEFB #8c
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_030 - 2x16 pixels, 1x16 bytes.
fnt_savage1_030:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #c4
DEFB #8c
DEFB #c8
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_031 - 2x16 pixels, 1x16 bytes.
fnt_savage1_031:
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_032 - 2x16 pixels, 1x16 bytes.
fnt_savage1_032:
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #10
DEFB #44
DEFB #44
DEFB #04
DEFB #90
DEFB #90
DEFB #c4
DEFB #c4
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_033 - 2x16 pixels, 1x16 bytes.
fnt_savage1_033:
DEFB #00
DEFB #00
DEFB #c0
DEFB #64
DEFB #0c
DEFB #08
DEFB #88
DEFB #64
DEFB #8c
DEFB #0c
DEFB #08
DEFB #08
DEFB #cc
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_034 - 2x16 pixels, 1x16 bytes.
fnt_savage1_034:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #44
DEFB #10
DEFB #64
DEFB #8c
DEFB #8c
DEFB #44
DEFB #44
DEFB #4c
DEFB #8c
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_035 - 2x16 pixels, 1x16 bytes.
fnt_savage1_035:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_036 - 2x16 pixels, 1x16 bytes.
fnt_savage1_036:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #10
DEFB #44
DEFB #44
DEFB #44
DEFB #40
DEFB #00
DEFB #00
DEFB #00
DEFB #44
DEFB #40
DEFB #00

;; Tile fnt_savage1_037 - 2x16 pixels, 1x16 bytes.
fnt_savage1_037:
DEFB #00
DEFB #00
DEFB #c0
DEFB #18
DEFB #60
DEFB #48
DEFB #08
DEFB #08
DEFB #08
DEFB #8c
DEFB #84
DEFB #40
DEFB #c4
DEFB #8c
DEFB #48
DEFB #00

;; Tile fnt_savage1_038 - 2x16 pixels, 1x16 bytes.
fnt_savage1_038:
DEFB #00
DEFB #00
DEFB #c0
DEFB #8c
DEFB #4c
DEFB #04
DEFB #04
DEFB #04
DEFB #04
DEFB #90
DEFB #c4
DEFB #24
DEFB #48
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_039 - 2x16 pixels, 1x16 bytes.
fnt_savage1_039:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_040 - 2x16 pixels, 1x16 bytes.
fnt_savage1_040:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #90
DEFB #4c
DEFB #64
DEFB #64
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #40
DEFB #00
DEFB #00

;; Tile fnt_savage1_041 - 2x16 pixels, 1x16 bytes.
fnt_savage1_041:
DEFB #00
DEFB #00
DEFB #00
DEFB #c0
DEFB #4c
DEFB #24
DEFB #48
DEFB #08
DEFB #80
DEFB #80
DEFB #00
DEFB #80
DEFB #8c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_042 - 2x16 pixels, 1x16 bytes.
fnt_savage1_042:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #c8
DEFB #4c
DEFB #84
DEFB #04
DEFB #04
DEFB #04
DEFB #04
DEFB #c4
DEFB #4c
DEFB #c8
DEFB #00
DEFB #00

;; Tile fnt_savage1_043 - 2x16 pixels, 1x16 bytes.
fnt_savage1_043:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #00
DEFB #00

;; Tile fnt_savage1_044 - 2x16 pixels, 1x16 bytes.
fnt_savage1_044:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #60
DEFB #64
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #cc
DEFB #8c
DEFB #c8
DEFB #8c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_045 - 2x16 pixels, 1x16 bytes.
fnt_savage1_045:
DEFB #00
DEFB #00
DEFB #00
DEFB #90
DEFB #24
DEFB #48
DEFB #80
DEFB #00
DEFB #cc
DEFB #0c
DEFB #80
DEFB #00
DEFB #90
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_046 - 2x16 pixels, 1x16 bytes.
fnt_savage1_046:
DEFB #00
DEFB #00
DEFB #00
DEFB #c8
DEFB #cc
DEFB #44
DEFB #44
DEFB #8c
DEFB #c8
DEFB #8c
DEFB #64
DEFB #64
DEFB #8c
DEFB #48
DEFB #00
DEFB #00

;; Tile fnt_savage1_047 - 2x16 pixels, 1x16 bytes.
fnt_savage1_047:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_048 - 2x16 pixels, 1x16 bytes.
fnt_savage1_048:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #4c
DEFB #cc
DEFB #64
DEFB #cc
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #40
DEFB #00
DEFB #00

;; Tile fnt_savage1_049 - 2x16 pixels, 1x16 bytes.
fnt_savage1_049:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #4c
DEFB #8c
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #8c
DEFB #4c
DEFB #00
DEFB #00

;; Tile fnt_savage1_050 - 2x16 pixels, 1x16 bytes.
fnt_savage1_050:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #84
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #8c
DEFB #00
DEFB #00

;; Tile fnt_savage1_051 - 2x16 pixels, 1x16 bytes.
fnt_savage1_051:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #08
DEFB #88
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #88
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_052 - 2x16 pixels, 1x16 bytes.
fnt_savage1_052:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #84
DEFB #4c
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #18
DEFB #4c
DEFB #04
DEFB #00
DEFB #00

;; Tile fnt_savage1_053 - 2x16 pixels, 1x16 bytes.
fnt_savage1_053:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #98
DEFB #8c
DEFB #48
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #48
DEFB #64
DEFB #00
DEFB #00

;; Tile fnt_savage1_054 - 2x16 pixels, 1x16 bytes.
fnt_savage1_054:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #04
DEFB #24
DEFB #4c
DEFB #90
DEFB #84
DEFB #04
DEFB #c4
DEFB #4c
DEFB #88
DEFB #00
DEFB #00

;; Tile fnt_savage1_055 - 2x16 pixels, 1x16 bytes.
fnt_savage1_055:
DEFB #00
DEFB #00
DEFB #00
DEFB #20
DEFB #20
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #00
DEFB #00

;; Tile fnt_savage1_056 - 2x16 pixels, 1x16 bytes.
fnt_savage1_056:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #c4
DEFB #64
DEFB #64
DEFB #cc
DEFB #cc
DEFB #cc
DEFB #4c
DEFB #84
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_057 - 2x16 pixels, 1x16 bytes.
fnt_savage1_057:
DEFB #00
DEFB #00
DEFB #c0
DEFB #64
DEFB #c8
DEFB #08
DEFB #80
DEFB #48
DEFB #cc
DEFB #48
DEFB #80
DEFB #c8
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_058 - 2x16 pixels, 1x16 bytes.
fnt_savage1_058:
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #c4
DEFB #64
DEFB #8c
DEFB #80
DEFB #40
DEFB #84
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_059 - 2x16 pixels, 1x16 bytes.
fnt_savage1_059:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #20
DEFB #88
DEFB #08
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_060 - 2x16 pixels, 1x16 bytes.
fnt_savage1_060:
DEFB #00
DEFB #00
DEFB #00
DEFB #10
DEFB #10
DEFB #44
DEFB #44
DEFB #44
DEFB #c4
DEFB #64
DEFB #4c
DEFB #c4
DEFB #44
DEFB #44
DEFB #00
DEFB #00

;; Tile fnt_savage1_061 - 2x16 pixels, 1x16 bytes.
fnt_savage1_061:
DEFB #00
DEFB #00
DEFB #00
DEFB #48
DEFB #98
DEFB #8c
DEFB #48
DEFB #08
DEFB #08
DEFB #cc
DEFB #48
DEFB #48
DEFB #08
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_062 - 2x16 pixels, 1x16 bytes.
fnt_savage1_062:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #4c
DEFB #84
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #40
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_063 - 2x16 pixels, 1x16 bytes.
fnt_savage1_063:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #88
DEFB #08
DEFB #00
DEFB #00
DEFB #88
DEFB #08
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_064 - 2x16 pixels, 1x16 bytes.
fnt_savage1_064:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #10
DEFB #44
DEFB #c4
DEFB #84
DEFB #08
DEFB #24
DEFB #8c
DEFB #cc
DEFB #c4
DEFB #00
DEFB #00

;; Tile fnt_savage1_065 - 2x16 pixels, 1x16 bytes.
fnt_savage1_065:
DEFB #00
DEFB #00
DEFB #00
DEFB #18
DEFB #24
DEFB #48
DEFB #48
DEFB #88
DEFB #cc
DEFB #40
DEFB #80
DEFB #80
DEFB #40
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_066 - 2x16 pixels, 1x16 bytes.
fnt_savage1_066:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #84
DEFB #40
DEFB #00
DEFB #00
DEFB #48
DEFB #40
DEFB #04
DEFB #90
DEFB #4c
DEFB #8c
DEFB #00
DEFB #00

;; Tile fnt_savage1_067 - 2x16 pixels, 1x16 bytes.
fnt_savage1_067:
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_068 - 2x16 pixels, 1x16 bytes.
fnt_savage1_068:
DEFB #00
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #98
DEFB #cc
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #c8
DEFB #c8
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_069 - 2x16 pixels, 1x16 bytes.
fnt_savage1_069:
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #c0
DEFB #64
DEFB #8c
DEFB #48
DEFB #80
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_070 - 2x16 pixels, 1x16 bytes.
fnt_savage1_070:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #c8
DEFB #4c
DEFB #44
DEFB #44
DEFB #44
DEFB #4c
DEFB #60
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_071 - 2x16 pixels, 1x16 bytes.
fnt_savage1_071:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #08
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_072 - 2x16 pixels, 1x16 bytes.
fnt_savage1_072:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #40
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_073 - 2x16 pixels, 1x16 bytes.
fnt_savage1_073:
DEFB #40
DEFB #04
DEFB #44
DEFB #00
DEFB #10
DEFB #98
DEFB #4c
DEFB #10
DEFB #44
DEFB #44
DEFB #44
DEFB #4c
DEFB #cc
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_074 - 2x16 pixels, 1x16 bytes.
fnt_savage1_074:
DEFB #08
DEFB #88
DEFB #00
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #48
DEFB #0c
DEFB #c0
DEFB #00
DEFB #00

;; Tile fnt_savage1_075 - 2x16 pixels, 1x16 bytes.
fnt_savage1_075:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_076 - 2x16 pixels, 1x16 bytes.
fnt_savage1_076:
DEFB #00
DEFB #00
DEFB #00
DEFB #4c
DEFB #24
DEFB #00
DEFB #00
DEFB #84
DEFB #0c
DEFB #20
DEFB #88
DEFB #8c
DEFB #cc
DEFB #4c
DEFB #04
DEFB #00

;; Tile fnt_savage1_077 - 2x16 pixels, 1x16 bytes.
fnt_savage1_077:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #c0
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #cc
DEFB #00

;; Tile fnt_savage1_078 - 2x16 pixels, 1x16 bytes.
fnt_savage1_078:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #84
DEFB #40
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #44
DEFB #44
DEFB #8c
DEFB #8c
DEFB #08
DEFB #00

;; Tile fnt_savage1_079 - 2x16 pixels, 1x16 bytes.
fnt_savage1_079:
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #08
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_080 - 2x16 pixels, 1x16 bytes.
fnt_savage1_080:
DEFB #00
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_081 - 2x16 pixels, 1x16 bytes.
fnt_savage1_081:
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #40
DEFB #c4
DEFB #8c
DEFB #c8
DEFB #98
DEFB #4c
DEFB #84
DEFB #c0
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_082 - 2x16 pixels, 1x16 bytes.
fnt_savage1_082:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #8c
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #20
DEFB #cc
DEFB #4c
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_083 - 2x16 pixels, 1x16 bytes.
fnt_savage1_083:
DEFB #00
DEFB #00
DEFB #00
DEFB #20
DEFB #08
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_084 - 2x16 pixels, 1x16 bytes.
fnt_savage1_084:
DEFB #00
DEFB #24
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_085 - 2x16 pixels, 1x16 bytes.
fnt_savage1_085:
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #84
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_086 - 2x16 pixels, 1x16 bytes.
fnt_savage1_086:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #84
DEFB #4c
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_087 - 2x16 pixels, 1x16 bytes.
fnt_savage1_087:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_088 - 2x16 pixels, 1x16 bytes.
fnt_savage1_088:
DEFB #00
DEFB #00
DEFB #00
DEFB #60
DEFB #98
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #c8
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_089 - 2x16 pixels, 1x16 bytes.
fnt_savage1_089:
DEFB #00
DEFB #00
DEFB #80
DEFB #24
DEFB #4c
DEFB #c4
DEFB #44
DEFB #44
DEFB #04
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_090 - 2x16 pixels, 1x16 bytes.
fnt_savage1_090:
DEFB #00
DEFB #00
DEFB #c0
DEFB #64
DEFB #4c
DEFB #84
DEFB #40
DEFB #40
DEFB #40
DEFB #84
DEFB #90
DEFB #4c
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_091 - 2x16 pixels, 1x16 bytes.
fnt_savage1_091:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #00
DEFB #88
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_092 - 2x16 pixels, 1x16 bytes.
fnt_savage1_092:
DEFB #00
DEFB #00
DEFB #00
DEFB #60
DEFB #98
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_093 - 2x16 pixels, 1x16 bytes.
fnt_savage1_093:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #0c
DEFB #c0
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_094 - 2x16 pixels, 1x16 bytes.
fnt_savage1_094:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #cc
DEFB #4c
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #4c
DEFB #60
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_095 - 2x16 pixels, 1x16 bytes.
fnt_savage1_095:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #08
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_096 - 2x16 pixels, 1x16 bytes.
fnt_savage1_096:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #64
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_097 - 2x16 pixels, 1x16 bytes.
fnt_savage1_097:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #0c
DEFB #48
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_098 - 2x16 pixels, 1x16 bytes.
fnt_savage1_098:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #4c
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #10
DEFB #c4
DEFB #24
DEFB #c8
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_099 - 2x16 pixels, 1x16 bytes.
fnt_savage1_099:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_100 - 2x16 pixels, 1x16 bytes.
fnt_savage1_100:
DEFB #00
DEFB #00
DEFB #00
DEFB #60
DEFB #98
DEFB #cc
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #c8
DEFB #c8
DEFB #00
DEFB #00

;; Tile fnt_savage1_101 - 2x16 pixels, 1x16 bytes.
fnt_savage1_101:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #8c
DEFB #48
DEFB #08
DEFB #80
DEFB #80
DEFB #00
DEFB #cc
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_102 - 2x16 pixels, 1x16 bytes.
fnt_savage1_102:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #4c
DEFB #04
DEFB #00
DEFB #10
DEFB #10
DEFB #64
DEFB #8c
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_103 - 2x16 pixels, 1x16 bytes.
fnt_savage1_103:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_104 - 2x16 pixels, 1x16 bytes.
fnt_savage1_104:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #90
DEFB #64
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #40
DEFB #44
DEFB #00
DEFB #00

;; Tile fnt_savage1_105 - 2x16 pixels, 1x16 bytes.
fnt_savage1_105:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #0c
DEFB #48
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #04
DEFB #00
DEFB #00

;; Tile fnt_savage1_106 - 2x16 pixels, 1x16 bytes.
fnt_savage1_106:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #4c
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #10
DEFB #c4
DEFB #24
DEFB #c8
DEFB #cc
DEFB #04
DEFB #00

;; Tile fnt_savage1_107 - 2x16 pixels, 1x16 bytes.
fnt_savage1_107:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #88
DEFB #00

;; Tile fnt_savage1_108 - 2x16 pixels, 1x16 bytes.
fnt_savage1_108:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #60
DEFB #64
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #cc
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #00
DEFB #00

;; Tile fnt_savage1_109 - 2x16 pixels, 1x16 bytes.
fnt_savage1_109:
DEFB #00
DEFB #00
DEFB #00
DEFB #90
DEFB #24
DEFB #48
DEFB #80
DEFB #00
DEFB #cc
DEFB #4c
DEFB #c4
DEFB #04
DEFB #40
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_110 - 2x16 pixels, 1x16 bytes.
fnt_savage1_110:
DEFB #00
DEFB #00
DEFB #00
DEFB #c8
DEFB #cc
DEFB #44
DEFB #44
DEFB #8c
DEFB #c8
DEFB #08
DEFB #20
DEFB #c8
DEFB #cc
DEFB #84
DEFB #00
DEFB #00

;; Tile fnt_savage1_111 - 2x16 pixels, 1x16 bytes.
fnt_savage1_111:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #80
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #00
DEFB #00

;; Tile fnt_savage1_112 - 2x16 pixels, 1x16 bytes.
fnt_savage1_112:
DEFB #00
DEFB #00
DEFB #00
DEFB #10
DEFB #18
DEFB #64
DEFB #4c
DEFB #84
DEFB #00
DEFB #00
DEFB #00
DEFB #c8
DEFB #8c
DEFB #4c
DEFB #00
DEFB #00

;; Tile fnt_savage1_113 - 2x16 pixels, 1x16 bytes.
fnt_savage1_113:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #c8
DEFB #80
DEFB #8c
DEFB #cc
DEFB #84
DEFB #40
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_114 - 2x16 pixels, 1x16 bytes.
fnt_savage1_114:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #44
DEFB #04
DEFB #80
DEFB #8c
DEFB #cc
DEFB #c4
DEFB #c4
DEFB #90
DEFB #64
DEFB #8c
DEFB #00
DEFB #00

;; Tile fnt_savage1_115 - 2x16 pixels, 1x16 bytes.
fnt_savage1_115:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #00
DEFB #80
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_116 - 2x16 pixels, 1x16 bytes.
fnt_savage1_116:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #04
DEFB #04
DEFB #04
DEFB #04
DEFB #40
DEFB #00
DEFB #00

;; Tile fnt_savage1_117 - 2x16 pixels, 1x16 bytes.
fnt_savage1_117:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #64
DEFB #4c
DEFB #4c
DEFB #4c
DEFB #8c
DEFB #88
DEFB #88
DEFB #88
DEFB #8c
DEFB #4c
DEFB #00
DEFB #00

;; Tile fnt_savage1_118 - 2x16 pixels, 1x16 bytes.
fnt_savage1_118:
DEFB #00
DEFB #64
DEFB #64
DEFB #c8
DEFB #cc
DEFB #48
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #c0
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_119 - 2x16 pixels, 1x16 bytes.
fnt_savage1_119:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #08
DEFB #00
DEFB #00

;; Tile fnt_savage1_120 - 2x16 pixels, 1x16 bytes.
fnt_savage1_120:
DEFB #00
DEFB #00
DEFB #00
DEFB #4c
DEFB #40
DEFB #10
DEFB #c4
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #cc
DEFB #c4
DEFB #00
DEFB #00

;; Tile fnt_savage1_121 - 2x16 pixels, 1x16 bytes.
fnt_savage1_121:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #c8
DEFB #08
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #0c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_122 - 2x16 pixels, 1x16 bytes.
fnt_savage1_122:
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #04
DEFB #04
DEFB #10
DEFB #4c
DEFB #8c
DEFB #80
DEFB #00
DEFB #00

;; Tile fnt_savage1_123 - 2x16 pixels, 1x16 bytes.
fnt_savage1_123:
DEFB #00
DEFB #00
DEFB #00
DEFB #20
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #00
DEFB #00

;; Tile fnt_savage1_124 - 2x16 pixels, 1x16 bytes.
fnt_savage1_124:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #00
DEFB #04
DEFB #04
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #44
DEFB #40
DEFB #00
DEFB #00

;; Tile fnt_savage1_125 - 2x16 pixels, 1x16 bytes.
fnt_savage1_125:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #c8
DEFB #88
DEFB #88
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #80
DEFB #0c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_126 - 2x16 pixels, 1x16 bytes.
fnt_savage1_126:
DEFB #00
DEFB #00
DEFB #00
DEFB #44
DEFB #44
DEFB #04
DEFB #40
DEFB #00
DEFB #04
DEFB #44
DEFB #4c
DEFB #8c
DEFB #c8
DEFB #08
DEFB #00
DEFB #00

;; Tile fnt_savage1_127 - 2x16 pixels, 1x16 bytes.
fnt_savage1_127:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #08
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_128 - 2x16 pixels, 1x16 bytes.
fnt_savage1_128:
DEFB #00
DEFB #00
DEFB #00
DEFB #18
DEFB #44
DEFB #24
DEFB #24
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #8c
DEFB #c4
DEFB #44
DEFB #00
DEFB #00

;; Tile fnt_savage1_129 - 2x16 pixels, 1x16 bytes.
fnt_savage1_129:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #48
DEFB #80
DEFB #00
DEFB #00
DEFB #04
DEFB #10
DEFB #44
DEFB #c4
DEFB #4c
DEFB #c8
DEFB #00
DEFB #00

;; Tile fnt_savage1_130 - 2x16 pixels, 1x16 bytes.
fnt_savage1_130:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #10
DEFB #0c
DEFB #04
DEFB #40
DEFB #00
DEFB #00
DEFB #40
DEFB #84
DEFB #4c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_131 - 2x16 pixels, 1x16 bytes.
fnt_savage1_131:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #88
DEFB #80
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_132 - 2x16 pixels, 1x16 bytes.
fnt_savage1_132:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #10
DEFB #40
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #4c
DEFB #00
DEFB #00

;; Tile fnt_savage1_133 - 2x16 pixels, 1x16 bytes.
fnt_savage1_133:
DEFB #00
DEFB #00
DEFB #00
DEFB #8c
DEFB #4c
DEFB #44
DEFB #44
DEFB #00
DEFB #00
DEFB #44
DEFB #10
DEFB #64
DEFB #8c
DEFB #c8
DEFB #00
DEFB #00

;; Tile fnt_savage1_134 - 2x16 pixels, 1x16 bytes.
fnt_savage1_134:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #44
DEFB #18
DEFB #cc
DEFB #24
DEFB #c8
DEFB #4c
DEFB #44
DEFB #44
DEFB #04
DEFB #00
DEFB #00

;; Tile fnt_savage1_135 - 2x16 pixels, 1x16 bytes.
fnt_savage1_135:
DEFB #00
DEFB #00
DEFB #00
DEFB #64
DEFB #8c
DEFB #c8
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #80
DEFB #4c
DEFB #c8
DEFB #00
DEFB #00

;; Tile fnt_savage1_136 - 2x16 pixels, 1x16 bytes.
fnt_savage1_136:
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #10
DEFB #04
DEFB #00
DEFB #00
DEFB #10
DEFB #c4
DEFB #4c
DEFB #8c
DEFB #8c
DEFB #4c
DEFB #84
DEFB #00

;; Tile fnt_savage1_137 - 2x16 pixels, 1x16 bytes.
fnt_savage1_137:
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #20
DEFB #c8
DEFB #4c
DEFB #44
DEFB #44
DEFB #04
DEFB #40
DEFB #00
DEFB #40
DEFB #90
DEFB #cc
DEFB #00

;; Tile fnt_savage1_138 - 2x16 pixels, 1x16 bytes.
fnt_savage1_138:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #04
DEFB #90
DEFB #4c
DEFB #4c
DEFB #24
DEFB #c8
DEFB #88
DEFB #08
DEFB #80
DEFB #00

;; Tile fnt_savage1_139 - 2x16 pixels, 1x16 bytes.
fnt_savage1_139:
DEFB #00
DEFB #00
DEFB #00
DEFB #20
DEFB #88
DEFB #88
DEFB #88
DEFB #08
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_140 - 2x16 pixels, 1x16 bytes.
fnt_savage1_140:
DEFB #00
DEFB #00
DEFB #00
DEFB #c4
DEFB #24
DEFB #08
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #40
DEFB #84
DEFB #4c
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_141 - 2x16 pixels, 1x16 bytes.
fnt_savage1_141:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #80
DEFB #00
DEFB #00
DEFB #04
DEFB #10
DEFB #4c
DEFB #64
DEFB #c8
DEFB #c8
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_142 - 2x16 pixels, 1x16 bytes.
fnt_savage1_142:
DEFB #00
DEFB #00
DEFB #00
DEFB #cc
DEFB #c4
DEFB #4c
DEFB #64
DEFB #c8
DEFB #88
DEFB #80
DEFB #00
DEFB #00
DEFB #80
DEFB #cc
DEFB #00
DEFB #00

;; Tile fnt_savage1_143 - 2x16 pixels, 1x16 bytes.
fnt_savage1_143:
DEFB #00
DEFB #00
DEFB #00
DEFB #88
DEFB #88
DEFB #80
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #08
DEFB #00
DEFB #00

;; Tile fnt_savage1_144 - 2x16 pixels, 1x16 bytes.
fnt_savage1_144:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_145 - 2x16 pixels, 1x16 bytes.
fnt_savage1_145:
DEFB #00
DEFB #4c
DEFB #98
DEFB #64
DEFB #64
DEFB #64
DEFB #cc
DEFB #4c
DEFB #4c
DEFB #c4
DEFB #44
DEFB #00
DEFB #90
DEFB #64
DEFB #c4
DEFB #00

;; Tile fnt_savage1_146 - 2x16 pixels, 1x16 bytes.
fnt_savage1_146:
DEFB #00
DEFB #08
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #c8
DEFB #48
DEFB #48
DEFB #80
DEFB #80
DEFB #00
DEFB #08
DEFB #88
DEFB #08
DEFB #00

;; Tile fnt_savage1_147 - 2x16 pixels, 1x16 bytes.
fnt_savage1_147:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_148 - 2x16 pixels, 1x16 bytes.
fnt_savage1_148:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00

;; Tile fnt_savage1_149 - 2x16 pixels, 1x16 bytes.
fnt_savage1_149:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #90
DEFB #64
DEFB #c4
DEFB #00

;; Tile fnt_savage1_150 - 2x16 pixels, 1x16 bytes.
fnt_savage1_150:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #08
DEFB #88
DEFB #08
DEFB #00

;; Tile fnt_savage1_151 - 2x16 pixels, 1x16 bytes.
fnt_savage1_151:
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00
DEFB #00


ds 64 ; space



render:
              
.end_write	ld hl, write_scr_start + 96 * 64
	ld de, .store_write
	ldi : ldi : ldi
	
	ld hl, .jp_code
	ld de, (.end_write + 1)
	ldi : ldi : ldi

	di
	ld (.save_stack + 1), sp

	xor a
	ld b, a 

	exx
	ld d, a
	ld hl, adr
.sin_ptr	ld bc, sin_tab

.jp_write	jp write_scr_start
.ret_adr
	exx 

	di
.save_stack:	ld sp, 0

	ld hl, .sin_ptr + 1
	dec (hl)

	ld hl, .store_write
	ld de, (.end_write + 1)
	ldi : ldi : ldi


	ld hl, (.jp_write + 1)
	ld (.restore + 2), hl

	ld de, #40
	ld hl, (.jp_write + 1)
	add hl, de
	ld (.jp_write + 1), hl
	bit 5, h
	jr nz, .loop
	ld hl, (.end_write + 1)
	add hl, de
	ld (.end_write + 1), hl
	ld hl, (main.src + 2)
	add hl, de
	ld (main.src + 2), hl
	jr .restore

.loop:	
	ld hl, write_scr_start
	ld (.jp_write + 1), hl
	ld hl, write_scr_start + 96 * 64
	ld (.end_write + 1), hl
	ld hl, write_scr_start + 128 * 64 + #09
	ld (main.src + 2), hl

.restore:	ld ix, 0
	ld de, 9
	add ix, de
.tile_col:	ld hl, 0
	call cp_chr
	ret	

.store_write	ds 3
.jp_code:	jp render.ret_adr



macro PRE_WRITE
	
	ld a, (bc)	; a valeur du sinus pour la colonne courante
	inc c	; avance et boucle dans la table sinus
	ld e, a	; de <= valeur du sinus(multiple de 2)
	add hl, de	; hl'' = adresse écran colonne + valeur du sinus
	ld sp, hl	; sp = adresse écran
	exx
endm


macro POST_WRITE i
	exx
	ld l, d	
	if ({i} - 1) % 2 == 0 
	; colonne paire, on place le LSB à #80
	set 7, l
	else 
	; colonne impaire, on incrémente les MSB
	inc h : nop
	endif
endm

macro CLEAR_SCR n
  repeat {n}
    	pop hl
    	ld (hl), b
  rend 
endm


macro MK_WRITE_SCR
	
  repeat 256, xx
wstart = $
    x = xx - 1
   	PRE_WRITE (void)
	CLEAR_SCR 1
   repeat 16
  	pop hl
@adr	ld (hl), #0
	
   rend
	CLEAR_SCR 1
	POST_WRITE x
	nop : nop  ; for 64 bytes size
  rend
endm

	org #8000
write_scr_start
	MK_WRITE_SCR (void)
module off

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: demo-effect
  SELECT id INTO tag_uuid FROM tags WHERE name = 'demo-effect';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 144: delta_làl by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'delta_làl',
    'Imported from z80Code. Author: tronic. 1er essai',
    'public',
    false,
    false,
    '2022-09-09T17:28:27.177000'::timestamptz,
    '2022-09-28T12:11:40.188000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Petit essai de delta via de la rupture ligne à ligne cette fois-ci et pour changer...
; LàL permettant la répétition en Y de portions de l''animation.
; On ne stock donc que les octets (souvent en bordures...)
; des "x" frames de l''animation qui ne se répètent pas en Y (la LàL s''en chargeant...)
; Animation logo "GPA" générée sur PC via code/tool perso sous delphi (pascal).
; 15 frames (sur 200 lignes) dans cet exemple (L''anim au complet faisant 60 frames...) 
; Ce qui est moyen visuellement parlant (pas smooth quoi...)
; Mais qui, pour ce niveau de détails, tient cependant dans 64ko...
; Pour claquer les 60 frames (ou 30 à la rigueur), il faudrait utiliser les banks...
; afin d''obtenir une "meilleure fluidité" puisque plus d''étapes... (+ fluide = 60>30>15 = -fluide)
; Delta générés également sur PC via code/tool perso qui pond directement du "ld a,val + ld (adr),a"
; et tout ce qu''il faut (nbr nop... etc...) pour chacune des 200 lignes par frame (x15).
; lignes sur lesquelles on pourrait rajouter des trucs (rasters...) puisque bourrées de nops...
; Le logo est volontairement placé à droite, pour ne pas se manger le "beam vbl horizontal/ligne/64nop"
; Une rupture de deux lignes serait plus judicieux... (type la GameBoy/logon''s run...)
; pour ce genre d''objet plus "complexes et/ou avec du détails"...
; Pas de vbl, temps fixe, 19968 nops...
; Bref, c''est un premier essai quoi...
; Tronic/GPA.


; Toolz dispo ici : https://uptobox.com/kb6ujgg9fegk


    BUILDSNA
    BANKSET 0

    org #40
	nolist
	run $
    
speed 	equ 5        ; vitesse...

waste	equ w_end+5+3

	macro wline num
	ld bc,{num}*8-1
	@loop nop
	dec bc
	ld a,b
	or c
	jr nz,@loop
	defs 6,0
	mend
	

	di
	ld hl,#c9fb
	ld (#38),hl

	ld bc,#7f00
	ld a,#40
	out (c),c
	out (c),a
	ld bc,#7f10
	ld a,#40
	out (c),c
	out (c),a    
	ld bc,#7f01
	ld a,#4b
	out (c),c
	out (c),a
	ld bc,#7f02
	ld a,#54
	out (c),c
	out (c),a
	ld bc,#7f03
	ld a,#6c
	out (c),c
	out (c),a

	ld bc,#bc0c
	out (c),c
	ld bc,#bd00+#30
	out (c),c
   

main
	ld b,#f5
nosync
	in a,(c)
	rra
	jp c,nosync
	ld b,#f5
sync
	in a,(c)
	rra
	jp nc,sync
	

novbl

	ld bc,#7f8d
 	out (c),c

	ld bc,#bc07
	out (c),c
	ld bc,#bd00+#ff
	out (c),c

	ld bc,#bc09
	out (c),c
	ld bc,#bd00
	out (c),c

	ld bc,#bc04
	out (c),c
	ld bc,#bd00
	out (c),c

	wline 71

incre
	ld sp,animate
	ret
    
continue

    wline 39
    defs 16,0

 	ld bc,#bc07
 	ld a,0
 	out (c),c
 	inc b
 	out (c),a


 	ld bc,#bc04
 	out (c),c
 	ld a,0
 	inc b
 	out (c),a


 	ld bc,#bc09
 	ld a,0
 	out (c),c
 	inc b
 	out (c),a


	jp novbl

nxt             ; 12 nops
    nop:nop:nop
    ld (incre+1),sp
    jp continue

nxtraz          ; 12 nops
    ld sp,animate
    ld (incre+1),sp
    jp continue


w_start
    defs 61,0
w_end
    ret

animate
let nbr=speed
    repeat nbr : dw frame0000,nxt:rend
    repeat nbr : dw frame0004,nxt:rend
    repeat nbr : dw frame0008,nxt:rend
    repeat nbr : dw frame0012,nxt:rend
    repeat nbr : dw frame0016,nxt:rend
    repeat nbr : dw frame0020,nxt:rend
    repeat nbr : dw frame0024,nxt:rend
    repeat nbr : dw frame0028,nxt:rend
    repeat nbr : dw frame0032,nxt:rend
    repeat nbr : dw frame0035,nxt:rend
    repeat nbr : dw frame0040,nxt:rend
    repeat nbr : dw frame0044,nxt:rend
    repeat nbr : dw frame0048,nxt:rend
    repeat nbr : dw frame0052,nxt:rend
    repeat nbr : dw frame0056,nxt:rend    
    repeat nbr : dw frame0052,nxt:rend    
    repeat nbr : dw frame0048,nxt:rend    
    repeat nbr : dw frame0044,nxt:rend    
    repeat nbr : dw frame0040,nxt:rend    
    repeat nbr : dw frame0035,nxt:rend
    repeat nbr : dw frame0032,nxt:rend 
    repeat nbr : dw frame0028,nxt:rend 
    repeat nbr : dw frame0024,nxt:rend
    repeat nbr : dw frame0020,nxt:rend
    repeat nbr : dw frame0016,nxt:rend
    repeat nbr : dw frame0012,nxt:rend
    repeat nbr : dw frame0008,nxt:rend
    repeat nbr : dw frame0004,nxt:rend
    repeat nbr : dw frame0000,nxt:rend    
    repeat nbr : dw frame0004,nxt:rend
    repeat nbr : dw frame0008,nxt:rend
    repeat nbr : dw frame0012,nxt:rend
    repeat nbr : dw frame0016,nxt:rend
    repeat nbr : dw frame0020,nxt:rend
    repeat nbr : dw frame0024,nxt:rend
    repeat nbr : dw frame0028,nxt:rend
    repeat nbr : dw frame0032,nxt:rend
    repeat nbr : dw frame0035,nxt:rend
    repeat nbr : dw frame0040,nxt:rend
    repeat nbr : dw frame0044,nxt:rend
    repeat nbr : dw frame0048,nxt:rend
    repeat nbr : dw frame0052,nxt:rend    
    repeat nbr-1 : dw frame0056,nxt:rend
    dw frame0056,nxtraz

stack_save
	dw #0000

	dw #0000
stack_context
 

finprog


frame0000
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#30
ld (#C000+72),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#04
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#70
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#02
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#B0
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#E0
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#01
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#38
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#1E
ld (#C000+71),a
ld a,#C0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#06
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#80
ld (#C000+67),a
ld a,#06
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#C0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#80
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#07
ld (#C000+71),a
ld a,#40
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#70
ld (#C000+63),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#06
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
call waste-52
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#16
ld (#C000+62),a
call waste-58
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#06
ld (#C000+62),a
ld a,#F0
ld (#C000+66),a
ld a,#0C
ld (#C000+75),a
ld a,#40
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#02
ld (#C000+62),a
ld a,#06
ld (#C000+74),a
ld a,#30
ld (#C000+75),a
ld a,#C0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#03
ld (#C000+73),a
ld a,#18
ld (#C000+74),a
ld a,#F0
ld (#C000+75),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#80
ld (#C000+67),a
ld a,#01
ld (#C000+72),a
ld a,#0C
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#06
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#38
ld (#C000+63),a
ld a,#C0
ld (#C000+67),a
ld a,#01
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#0C
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#06
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#3C
ld (#C000+63),a
ld a,#F0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#07
ld (#C000+69),a
ld a,#80
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#14
ld (#C000+63),a
ld a,#03
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#16
ld (#C000+63),a
ld a,#83
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#06
ld (#C000+63),a
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+71),a
ld a,#03
ld (#C000+72),a
ld a,#78
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#02
ld (#C000+63),a
ld a,#01
ld (#C000+69),a
ld a,#28
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#38
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#01
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#80
ld (#C000+68),a
ld a,#3C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#1C
ld (#C000+73),a
ld a,#E0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#1E
ld (#C000+73),a
ld a,#F0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0E
ld (#C000+73),a
ld a,#E0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#3C
ld (#C000+64),a
ld a,#06
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#07
ld (#C000+73),a
ld a,#80
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#14
ld (#C000+64),a
ld a,#0E
ld (#C000+73),a
ld a,#70
ld (#C000+74),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#16
ld (#C000+64),a
ld a,#07
ld (#C000+72),a
ld a,#18
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#F0
ld (#C000+68),a
ld a,#03
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#02
ld (#C000+64),a
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#07
ld (#C000+69),a
ld a,#18
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#04
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#B0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#F0
ld (#C000+69),a
ld a,#80
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#3C
ld (#C000+65),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#14
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#10
ld (#C000+66),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
ld a,#01
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#80
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#18
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#01
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#E0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#18
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#0C
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#83
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#0E
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
ld a,#F0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#0F
ld (#C000+62),a
ld a,#30
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
call waste-22
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#18
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#38
ld (#C000+62),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#34
ld (#C000+62),a
ld a,#00
ld (#C000+70),a
ld a,#3C
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#14
ld (#C000+62),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#12
ld (#C000+62),a
ld a,#C0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#02
ld (#C000+62),a
ld a,#C0
ld (#C000+67),a
ld a,#06
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne88  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
call waste-58
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#70
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#03
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#E0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne91  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne92  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#F0
ld (#C000+67),a
ld a,#01
ld (#C000+71),a
ld a,#78
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#14
ld (#C000+63),a
ld a,#80
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
ld a,#00
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#02
ld (#C000+63),a
ld a,#0F
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#80
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0C
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#00
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#78
ld (#C000+64),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#34
ld (#C000+64),a
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#14
ld (#C000+64),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne111  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#02
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#C0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne117  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#38
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#34
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#14
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne123  ;;;;;;;;;;;
ld a,#C0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#12
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne125  ;;;;;;;;;;;
ld a,#02
ld (#C000+65),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne126  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne127  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#C0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne128  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
ld a,#0C
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
ld a,#60
ld (#C000+72),a
ld a,#03
ld (#C000+73),a
ld a,#0E
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+73),a
ld a,#03
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+74),a
ld a,#80
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#C0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0E
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#18
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#0C
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#70
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#E0
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#00
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#38
ld (#C000+64),a
ld a,#80
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#0E
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#14
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-22
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#16
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#C0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#C0
ld (#C000+67),a
ld a,#03
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#78
ld (#C000+63),a
ld a,#03
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#38
ld (#C000+63),a
ld a,#C1
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#30
ld (#C000+71),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#18
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#34
ld (#C000+63),a
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-34
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#C1
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#E0
ld (#C000+64),a
ld a,#07
ld (#C000+65),a
ld a,#0E
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-34
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#00
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-34
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#18
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#90
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#E0
ld (#C000+71),a
ld a,#14
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+71),a
ld a,#16
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#1C
ld (#C000+65),a
ld a,#80
ld (#C000+70),a
ld a,#06
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#38
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#02
ld (#C000+72),a
ld a,#C0
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#03
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#01
ld (#C000+72),a
ld a,#E0
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#3C
ld (#C000+64),a
ld a,#78
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#07
ld (#C000+72),a
ld a,#38
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#F0
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#14
ld (#C000+64),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#07
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#80
ld (#C000+78),a
call waste-46
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#02
ld (#C000+64),a
ld a,#83
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#18
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+77),a
ld a,#00
ld (#C000+78),a
call waste-34
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+73),a
ld a,#70
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#80
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#40
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0004
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#04
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#82
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#04
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#02
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#80
ld (#C000+70),a
ld a,#C2
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#C1
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#00
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
ld a,#C0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#00
ld (#C000+66),a
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#F0
ld (#C000+63),a
ld a,#04
ld (#C000+66),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#06
ld (#C000+66),a
ld a,#80
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#82
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#83
ld (#C000+66),a
ld a,#01
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#0E
ld (#C000+75),a
ld a,#04
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#C3
ld (#C000+66),a
ld a,#06
ld (#C000+74),a
ld a,#30
ld (#C000+75),a
ld a,#82
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#07
ld (#C000+73),a
ld a,#10
ld (#C000+74),a
ld a,#F0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#08
ld (#C000+67),a
ld a,#03
ld (#C000+72),a
ld a,#18
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0C
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#C1
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#0C
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#02
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E1
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#04
ld (#C000+67),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+76),a
ld a,#08
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#06
ld (#C000+67),a
ld a,#30
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#86
ld (#C000+67),a
ld a,#D0
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#82
ld (#C000+67),a
ld a,#10
ld (#C000+69),a
ld a,#C0
ld (#C000+71),a
ld a,#10
ld (#C000+72),a
ld a,#04
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#83
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+72),a
ld a,#84
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#82
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#08
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#70
ld (#C000+73),a
ld a,#C2
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0C
ld (#C000+68),a
ld a,#C1
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne45  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#30
ld (#C000+73),a
ld a,#E1
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#E0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#06
ld (#C000+68),a
ld a,#14
ld (#C000+73),a
ld a,#80
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#03
ld (#C000+72),a
ld a,#1C
ld (#C000+73),a
ld a,#00
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#82
ld (#C000+68),a
ld a,#03
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#30
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#83
ld (#C000+68),a
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-22
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#C0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#07
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#0C
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#18
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
ld a,#01
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#0C
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#04
ld (#C000+66),a
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+74),a
ld a,#04
ld (#C000+75),a
call waste-22
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-34
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#18
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0F
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#04
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#86
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#0F
ld (#C000+63),a
ld a,#00
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#82
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#07
ld (#C000+62),a
ld a,#00
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
call waste-46
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#E0
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#83
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#F0
ld (#C000+62),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#C1
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#C0
ld (#C000+66),a
ld a,#08
ld (#C000+67),a
ld a,#08
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#C1
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
ld a,#E1
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#E0
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#E1
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#E0
ld (#C000+66),a
ld a,#70
ld (#C000+71),a
ld a,#0C
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#F0
ld (#C000+75),a
ld a,#04
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#06
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
ld a,#06
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#86
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#82
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#83
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
ld a,#C3
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#C0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#C1
ld (#C000+67),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#06
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#E1
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
ld a,#0C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#70
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#08
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#07
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#C0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#C0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#08
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E1
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#06
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne117  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#83
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#82
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne123  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#80
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne125  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+73),a
ld a,#0C
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+71),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#08
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#81
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0E
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#03
ld (#C000+73),a
ld a,#0C
ld (#C000+75),a
call waste-16
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#08
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0C
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+74),a
ld a,#06
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
call waste-46
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#06
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
call waste-52
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#82
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#83
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#C0
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#C3
ld (#C000+75),a
call waste-22
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#C0
ld (#C000+66),a
ld a,#08
ld (#C000+67),a
ld a,#C1
ld (#C000+75),a
ld a,#08
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#C1
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#70
ld (#C000+71),a
ld a,#E1
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#E0
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#08
ld (#C000+67),a
ld a,#01
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#F0
ld (#C000+75),a
ld a,#04
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#E0
ld (#C000+65),a
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#1C
ld (#C000+71),a
ld a,#06
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#00
ld (#C000+64),a
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0E
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#03
ld (#C000+65),a
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#86
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#00
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#83
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0C
ld (#C000+65),a
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-34
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#38
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#C3
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#C1
ld (#C000+76),a
ld a,#08
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#0C
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#0E
ld (#C000+68),a
ld a,#30
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#06
ld (#C000+68),a
ld a,#F0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#07
ld (#C000+68),a
ld a,#06
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#87
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#10
ld (#C000+72),a
ld a,#86
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#08
ld (#C000+69),a
ld a,#01
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#82
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#83
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#0F
ld (#C000+72),a
ld a,#C1
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#0C
ld (#C000+72),a
ld a,#08
ld (#C000+78),a
call waste-52
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E1
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne179  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#F0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#00
ld (#C000+78),a
call waste-58
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#30
ld (#C000+73),a
ld a,#80
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-16
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-34
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne188  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne189  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0008
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#06
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
ld a,#03
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
ld a,#C1
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#08
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#02
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E1
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#F0
ld (#C000+65),a
ld a,#0C
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#04
ld (#C000+67),a
ld a,#30
ld (#C000+70),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#03
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#84
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#F0
ld (#C000+63),a
ld a,#0F
ld (#C000+66),a
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#10
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#83
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#0F
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#C3
ld (#C000+66),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#08
ld (#C000+68),a
ld a,#0F
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#0C
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#0F
ld (#C000+72),a
ld a,#10
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#E1
ld (#C000+66),a
ld a,#0F
ld (#C000+71),a
ld a,#10
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#07
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+70),a
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#0E
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#0C
ld (#C000+68),a
ld a,#03
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#87
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#F0
ld (#C000+69),a
ld a,#83
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#0F
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#70
ld (#C000+69),a
ld a,#C3
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#10
ld (#C000+71),a
ld a,#C1
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#08
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#E1
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#E0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#08
ld (#C000+69),a
ld a,#70
ld (#C000+72),a
ld a,#0C
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne43  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#F0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0C
ld (#C000+69),a
ld a,#07
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#30
ld (#C000+72),a
ld a,#0E
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#87
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#83
ld (#C000+76),a
ld a,#0C
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#10
ld (#C000+72),a
ld a,#08
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#87
ld (#C000+68),a
ld a,#03
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
ld a,#82
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#18
ld (#C000+72),a
ld a,#04
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#0F
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
ld a,#08
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C1
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#C0
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#80
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne62  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne68  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#08
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-16
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0F
ld (#C000+64),a
ld a,#0E
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-22
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#00
ld (#C000+65),a
ld a,#0E
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+72),a
ld a,#83
ld (#C000+73),a
call waste-22
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#08
ld (#C000+63),a
ld a,#30
ld (#C000+64),a
ld a,#E0
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C1
ld (#C000+73),a
ld a,#08
ld (#C000+75),a
call waste-16
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-34
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
call waste-58
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#E0
ld (#C000+73),a
ld a,#0C
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#C0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#83
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#C3
ld (#C000+66),a
ld a,#08
ld (#C000+68),a
ld a,#07
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#83
ld (#C000+74),a
ld a,#0F
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#C3
ld (#C000+74),a
ld a,#08
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#C1
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne91  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#10
ld (#C000+70),a
ld a,#E1
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#E0
ld (#C000+74),a
ld a,#0C
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#F0
ld (#C000+74),a
ld a,#07
ld (#C000+75),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#08
ld (#C000+69),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#70
ld (#C000+71),a
ld a,#08
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#87
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#38
ld (#C000+70),a
ld a,#06
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E1
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#C1
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#82
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#80
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#C3
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#08
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne112  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne115  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#08
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#87
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#82
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne133  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne134  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
call waste-16
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0E
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#20
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-10
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#0E
ld (#C000+74),a
call waste-10
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#C1
ld (#C000+71),a
ld a,#0F
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#81
ld (#C000+72),a
ld a,#08
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#E0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#F0
ld (#C000+72),a
ld a,#83
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#C1
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#83
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#0C
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#C3
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#E0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#70
ld (#C000+70),a
ld a,#0E
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#E1
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#0F
ld (#C000+75),a
call waste-22
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#3C
ld (#C000+70),a
ld a,#87
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#1C
ld (#C000+70),a
ld a,#83
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#01
ld (#C000+69),a
ld a,#1E
ld (#C000+70),a
ld a,#C3
ld (#C000+74),a
ld a,#08
ld (#C000+76),a
call waste-16
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C1
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#F0
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0C
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne162  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#0E
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#07
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0E
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#87
ld (#C000+75),a
ld a,#0F
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#83
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#10
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#87
ld (#C000+68),a
ld a,#08
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#C1
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#C3
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
ld a,#0C
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#70
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
ld a,#0E
ld (#C000+77),a
call waste-22
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#07
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#0F
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#83
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#0E
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#10
ld (#C000+72),a
ld a,#C1
ld (#C000+76),a
ld a,#0C
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#08
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#70
ld (#C000+75),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#00
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne188  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne189  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0012
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#01
ld (#C000+69),a
ld a,#0C
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#06
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#02
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#C1
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#0E
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#F0
ld (#C000+65),a
ld a,#87
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#83
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#C0
ld (#C000+67),a
ld a,#04
ld (#C000+68),a
ld a,#C3
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#80
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#C1
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#83
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#C3
ld (#C000+66),a
ld a,#E1
ld (#C000+71),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#06
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
ld a,#01
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#0E
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#07
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#C1
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#08
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#1E
ld (#C000+68),a
ld a,#E0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#0E
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#0C
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#E1
ld (#C000+67),a
ld a,#F0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#40
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#07
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#07
ld (#C000+69),a
ld a,#18
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#08
ld (#C000+70),a
ld a,#83
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#0C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#0F
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#C3
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#C1
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne47  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#C3
ld (#C000+68),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#3C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#E1
ld (#C000+68),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#F0
ld (#C000+73),a
ld a,#00
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#07
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#0C
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#E0
ld (#C000+73),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#C1
ld (#C000+73),a
ld a,#0C
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#83
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#04
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne60  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne61  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne62  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne68  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne69  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#03
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#80
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#03
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
call waste-28
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#F0
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
ld a,#08
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#83
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#C1
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#0E
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#D0
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#87
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#E1
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#83
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#C3
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#70
ld (#C000+69),a
ld a,#C1
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#08
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#78
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#38
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#0C
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#C3
ld (#C000+67),a
ld a,#07
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#1E
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#E1
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#83
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#70
ld (#C000+70),a
ld a,#C1
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#08
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#01
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E1
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#0E
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#E1
ld (#C000+72),a
ld a,#08
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#C1
ld (#C000+72),a
ld a,#0E
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#E1
ld (#C000+68),a
ld a,#08
ld (#C000+69),a
ld a,#C3
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#0C
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#87
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#C3
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#02
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#60
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#F0
ld (#C000+65),a
ld a,#C1
ld (#C000+66),a
ld a,#0E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#F0
ld (#C000+66),a
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#08
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+68),a
ld a,#0C
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#F0
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
ld a,#0E
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#C0
ld (#C000+66),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#08
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#E1
ld (#C000+66),a
ld a,#18
ld (#C000+67),a
ld a,#83
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#C1
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#0C
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#08
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#06
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
ld a,#0F
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#38
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#20
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#C1
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#81
ld (#C000+67),a
ld a,#08
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#C1
ld (#C000+68),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#0C
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#07
ld (#C000+72),a
ld a,#0E
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#87
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#83
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#87
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#C1
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#C3
ld (#C000+68),a
ld a,#08
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#1C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#E1
ld (#C000+68),a
ld a,#0C
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#F0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#07
ld (#C000+73),a
ld a,#0E
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#87
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#C1
ld (#C000+70),a
ld a,#83
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+70),a
ld a,#0F
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#C1
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#0C
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#30
ld (#C000+72),a
ld a,#07
ld (#C000+74),a
ld a,#0E
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#70
ld (#C000+73),a
ld a,#87
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#10
ld (#C000+73),a
ld a,#83
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne191  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#02
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne192  ;;;;;;;;;;;
ld a,#00
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0016
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne6  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne7  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#C1
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne14  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#08
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#06
ld (#C000+67),a
ld a,#0C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#C3
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#C1
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#41
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#60
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#28
ld (#C000+68),a
ld a,#08
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#41
ld (#C000+67),a
ld a,#0C
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#61
ld (#C000+67),a
ld a,#38
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#60
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#20
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#08
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#0C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#87
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#80
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#90
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#D2
ld (#C000+68),a
ld a,#E1
ld (#C000+69),a
ld a,#0E
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#40
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#41
ld (#C000+68),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#60
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#20
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#87
ld (#C000+70),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#16
ld (#C000+69),a
ld a,#83
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#06
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#C3
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#C1
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#41
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
ld a,#60
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#28
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#60
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#70
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne55  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#70
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#10
ld (#C000+70),a
ld a,#87
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#86
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne62  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#41
ld (#C000+66),a
ld a,#0F
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#21
ld (#C000+66),a
ld a,#08
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#20
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0C
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#C1
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#E1
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#A0
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#90
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#82
ld (#C000+67),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#42
ld (#C000+67),a
ld a,#83
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#40
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#41
ld (#C000+67),a
ld a,#03
ld (#C000+68),a
ld a,#0C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#21
ld (#C000+67),a
ld a,#43
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#20
ld (#C000+67),a
ld a,#41
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#49
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#29
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#20
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#24
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#14
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#90
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne94  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#82
ld (#C000+68),a
ld a,#08
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#42
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#40
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#41
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#21
ld (#C000+68),a
ld a,#43
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#20
ld (#C000+68),a
ld a,#41
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#E1
ld (#C000+69),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne104  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne105  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#B0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne107  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#90
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#42
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#40
ld (#C000+69),a
ld a,#87
ld (#C000+70),a
ld a,#08
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#41
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#20
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#21
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#0E
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne138  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#08
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne145  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne148  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne150  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#03
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne153  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne154  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#81
ld (#C000+68),a
ld a,#0C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne157  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#60
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#20
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#08
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne166  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#0C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#81
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne172  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne173  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne175  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne176  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#83
ld (#C000+70),a
ld a,#08
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne178  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#43
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#41
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#21
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#10
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne188  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne189  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#08
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#08
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne194  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne195  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0020
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#40
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#04
ld (#C000+69),a
ld a,#E0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#80
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#38
ld (#C000+68),a
ld a,#C0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#78
ld (#C000+68),a
ld a,#90
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#81
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#78
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#E1
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#1E
ld (#C000+68),a
ld a,#C0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
ld a,#3C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#08
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#E0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#0C
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#06
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#07
ld (#C000+69),a
ld a,#06
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#0E
ld (#C000+70),a
ld a,#86
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#1C
ld (#C000+70),a
ld a,#82
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#83
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C3
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
ld a,#C1
ld (#C000+71),a
ld a,#80
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#78
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#83
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#07
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#E0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#70
ld (#C000+70),a
ld a,#83
ld (#C000+71),a
ld a,#1E
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#78
ld (#C000+70),a
ld a,#F0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#38
ld (#C000+70),a
ld a,#C3
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#C1
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0E
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#1C
ld (#C000+70),a
ld a,#E1
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#1E
ld (#C000+70),a
ld a,#F0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#38
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#1C
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#06
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
ld a,#06
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne66  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#80
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#F0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#70
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#1C
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#38
ld (#C000+68),a
ld a,#B0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#14
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#78
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
ld a,#1E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#C3
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#80
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne82  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#E1
ld (#C000+69),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#78
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#78
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#F0
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#3C
ld (#C000+68),a
ld a,#07
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#3C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#1C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#83
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#C3
ld (#C000+70),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#C1
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#E1
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#78
ld (#C000+69),a
ld a,#E0
ld (#C000+70),a
ld a,#1E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#F0
ld (#C000+70),a
ld a,#B0
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#3C
ld (#C000+69),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#90
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#F0
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#14
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#1E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C1
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#38
ld (#C000+70),a
ld a,#83
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#1C
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#70
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#60
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#0C
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#48
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+70),a
ld a,#80
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#3C
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#38
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#1E
ld (#C000+68),a
ld a,#D0
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#90
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#38
ld (#C000+68),a
ld a,#06
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#E1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#C0
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#38
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#78
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne153  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#16
ld (#C000+70),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#14
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#3C
ld (#C000+68),a
ld a,#B4
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#B0
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#C1
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#1E
ld (#C000+68),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
ld a,#83
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#78
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#07
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#78
ld (#C000+69),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#38
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne168  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#0E
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#1C
ld (#C000+69),a
ld a,#87
ld (#C000+71),a
ld a,#1E
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#83
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#3C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#C3
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#C1
ld (#C000+71),a
ld a,#78
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#70
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#E1
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#80
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#78
ld (#C000+70),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#38
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#3C
ld (#C000+70),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#1C
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#80
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#1E
ld (#C000+70),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne188  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
ld a,#60
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne192  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#28
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne193  ;;;;;;;;;;;
ld a,#08
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne196  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0024
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#18
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#06
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#02
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#18
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#04
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#70
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#3C
ld (#C000+66),a
ld a,#81
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#38
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#70
ld (#C000+66),a
ld a,#83
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+68),a
ld a,#03
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#80
ld (#C000+68),a
ld a,#80
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#1C
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#3C
ld (#C000+65),a
ld a,#1E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#01
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#3C
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#C0
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#1E
ld (#C000+65),a
ld a,#E0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0E
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#78
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#80
ld (#C000+68),a
ld a,#38
ld (#C000+72),a
ld a,#F0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0F
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-34
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#3C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#40
ld (#C000+66),a
ld a,#03
ld (#C000+70),a
ld a,#1C
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#80
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#03
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#01
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#83
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-28
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#C0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#C3
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#18
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#03
ld (#C000+71),a
ld a,#70
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#F0
ld (#C000+67),a
ld a,#80
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#38
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#F0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#F0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#3C
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#78
ld (#C000+67),a
ld a,#03
ld (#C000+71),a
ld a,#1C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#E0
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#0E
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#1C
ld (#C000+67),a
ld a,#18
ld (#C000+73),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#C0
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#18
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#1E
ld (#C000+67),a
ld a,#C1
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#0F
ld (#C000+67),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#C0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne64  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
ld a,#80
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne65  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne66  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#18
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#38
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0C
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#83
ld (#C000+70),a
ld a,#80
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#3C
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-34
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#38
ld (#C000+66),a
ld a,#81
ld (#C000+69),a
ld a,#78
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#70
ld (#C000+66),a
ld a,#07
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#C0
ld (#C000+68),a
ld a,#C0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#03
ld (#C000+69),a
ld a,#3C
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#1C
ld (#C000+65),a
ld a,#1C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#E0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#38
ld (#C000+65),a
ld a,#01
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#0E
ld (#C000+65),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
ld a,#80
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#07
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#38
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#03
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#78
ld (#C000+66),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#38
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#07
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#1C
ld (#C000+66),a
ld a,#30
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#C0
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#83
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#E0
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#78
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#C1
ld (#C000+71),a
ld a,#38
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#03
ld (#C000+71),a
ld a,#C0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#78
ld (#C000+67),a
ld a,#C0
ld (#C000+70),a
ld a,#3C
ld (#C000+73),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#1C
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
ld a,#1C
ld (#C000+73),a
ld a,#00
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#0F
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#C0
ld (#C000+69),a
ld a,#01
ld (#C000+71),a
ld a,#C0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#1C
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#0E
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#C0
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne118  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#70
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#38
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#30
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#18
ld (#C000+68),a
ld a,#F0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#38
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#70
ld (#C000+67),a
ld a,#81
ld (#C000+70),a
ld a,#78
ld (#C000+71),a
ld a,#80
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#1C
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-22
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#C0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#3C
ld (#C000+66),a
ld a,#83
ld (#C000+69),a
ld a,#3C
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#01
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#78
ld (#C000+66),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+68),a
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+70),a
ld a,#18
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0E
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
ld a,#F0
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#1E
ld (#C000+65),a
ld a,#03
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#1C
ld (#C000+65),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#70
ld (#C000+71),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#1E
ld (#C000+65),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0E
ld (#C000+65),a
ld a,#04
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#B0
ld (#C000+69),a
ld a,#B0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#C1
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#1E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#38
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#F0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#80
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#1C
ld (#C000+66),a
ld a,#E0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne168  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#38
ld (#C000+73),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#0E
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#81
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#83
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#1C
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
ld a,#00
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#C1
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#78
ld (#C000+67),a
ld a,#1C
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#3C
ld (#C000+67),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#1C
ld (#C000+67),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#1E
ld (#C000+67),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#80
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#C0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#78
ld (#C000+68),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#80
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne191  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne192  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne193  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne194  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#03
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne195  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0028
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#F0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#04
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#02
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#02
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#10
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#02
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
ld a,#C0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#03
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#1E
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#00
ld (#C000+68),a
ld a,#E0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#80
ld (#C000+67),a
ld a,#01
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#00
ld (#C000+67),a
ld a,#0F
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#0E
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#F0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#1C
ld (#C000+63),a
ld a,#80
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#78
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#C0
ld (#C000+67),a
ld a,#07
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#3C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#1C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#1E
ld (#C000+63),a
ld a,#C0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#0E
ld (#C000+63),a
ld a,#00
ld (#C000+67),a
ld a,#03
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#C0
ld (#C000+66),a
ld a,#1E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#0F
ld (#C000+63),a
ld a,#E0
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#0E
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#01
ld (#C000+71),a
ld a,#E0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#40
ld (#C000+64),a
ld a,#07
ld (#C000+69),a
ld a,#20
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#00
ld (#C000+64),a
ld a,#01
ld (#C000+68),a
ld a,#18
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#70
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#00
ld (#C000+71),a
ld a,#F0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#18
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#80
ld (#C000+71),a
ld a,#78
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#0C
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#00
ld (#C000+71),a
ld a,#38
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#07
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#18
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
ld a,#3C
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#1C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#F0
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#03
ld (#C000+72),a
ld a,#C0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0E
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#01
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#70
ld (#C000+74),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#0E
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0F
ld (#C000+72),a
ld a,#30
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#C0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#3C
ld (#C000+65),a
ld a,#03
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#1E
ld (#C000+65),a
ld a,#C1
ld (#C000+69),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#0E
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#80
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#80
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne64  ;;;;;;;;;;;
ld a,#01
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne65  ;;;;;;;;;;;
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
ld a,#C0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne66  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#1C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#18
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#10
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#08
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0C
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#E0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#38
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
ld a,#3C
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+67),a
ld a,#03
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#0E
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#F0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#1E
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#07
ld (#C000+62),a
ld a,#1C
ld (#C000+63),a
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#80
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#C0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#0E
ld (#C000+63),a
ld a,#80
ld (#C000+68),a
ld a,#78
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#07
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#E0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#C0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#03
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne96  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#78
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#07
ld (#C000+71),a
ld a,#F0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#38
ld (#C000+64),a
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#18
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#3C
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#00
ld (#C000+69),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne103  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#70
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#C0
ld (#C000+72),a
ld a,#38
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#07
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+71),a
ld a,#E0
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#03
ld (#C000+72),a
ld a,#3C
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#80
ld (#C000+70),a
ld a,#1C
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#14
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#C0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#1E
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#01
ld (#C000+72),a
ld a,#0E
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-16
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#80
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#C0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#70
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#01
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
ld a,#04
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#18
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#18
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#30
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#18
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0E
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0C
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#C1
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#70
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
ld a,#3C
ld (#C000+71),a
ld a,#80
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#01
ld (#C000+70),a
ld a,#00
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+70),a
ld a,#80
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#C0
ld (#C000+67),a
ld a,#02
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#70
ld (#C000+64),a
ld a,#07
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#0E
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+67),a
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#00
ld (#C000+73),a
ld a,#01
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-16
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#0F
ld (#C000+70),a
ld a,#0C
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#80
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#07
ld (#C000+69),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+75),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#0E
ld (#C000+63),a
ld a,#0C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#30
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#06
ld (#C000+63),a
ld a,#90
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+68),a
ld a,#D0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#14
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#C1
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
ld a,#E0
ld (#C000+70),a
ld a,#01
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#80
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#07
ld (#C000+72),a
ld a,#C0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#78
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#1E
ld (#C000+64),a
ld a,#38
ld (#C000+73),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#80
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#07
ld (#C000+71),a
ld a,#3C
ld (#C000+73),a
ld a,#00
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#1C
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#83
ld (#C000+69),a
ld a,#18
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#78
ld (#C000+65),a
ld a,#C1
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#3C
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#1E
ld (#C000+65),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#0E
ld (#C000+65),a
ld a,#C0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#06
ld (#C000+65),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#78
ld (#C000+66),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#C0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#3C
ld (#C000+66),a
ld a,#80
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne191  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#1C
ld (#C000+66),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne192  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne193  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0032
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#40
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#02
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#18
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#04
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#18
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#34
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#02
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#14
ld (#C000+63),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#38
ld (#C000+63),a
ld a,#C0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#02
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#70
ld (#C000+63),a
ld a,#80
ld (#C000+66),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#02
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#C0
ld (#C000+66),a
call waste-46
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#01
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#00
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
call waste-58
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
ld a,#E0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#30
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne28  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#34
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#80
ld (#C000+65),a
ld a,#10
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#C0
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#08
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#E0
ld (#C000+63),a
ld a,#00
ld (#C000+64),a
ld a,#06
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#12
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#03
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#0C
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#06
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#01
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#00
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#08
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-46
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#0C
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
ld a,#78
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#80
ld (#C000+69),a
ld a,#30
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#C0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#E0
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#34
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#10
ld (#C000+73),a
ld a,#F0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#80
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#12
ld (#C000+73),a
ld a,#E0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#02
ld (#C000+73),a
ld a,#C0
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#06
ld (#C000+73),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#07
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
ld a,#00
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#03
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#F0
ld (#C000+69),a
ld a,#C0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#C0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne64  ;;;;;;;;;;;
ld a,#06
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne65  ;;;;;;;;;;;
ld a,#03
ld (#C000+73),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne66  ;;;;;;;;;;;
ld a,#03
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#10
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#06
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0E
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-40
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
call waste-40
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#06
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#38
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#70
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#70
ld (#C000+63),a
ld a,#00
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#06
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#30
ld (#C000+71),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#70
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#F0
ld (#C000+66),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
call waste-58
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#80
ld (#C000+67),a
ld a,#C0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#10
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#80
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#E0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#C0
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#70
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#F0
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#08
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+68),a
ld a,#80
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#E0
ld (#C000+77),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#70
ld (#C000+73),a
ld a,#F0
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#80
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#30
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#80
ld (#C000+78),a
call waste-34
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#10
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#30
ld (#C000+73),a
ld a,#E0
ld (#C000+77),a
ld a,#00
ld (#C000+78),a
call waste-46
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#10
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#E0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#0E
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
ld a,#07
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
ld a,#0F
ld (#C000+74),a
call waste-16
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0C
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#0C
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#80
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0C
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
call waste-40
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0C
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
call waste-40
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
call waste-52
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#0E
ld (#C000+63),a
ld a,#80
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#1C
ld (#C000+63),a
ld a,#80
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#38
ld (#C000+63),a
ld a,#80
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#E0
ld (#C000+66),a
ld a,#80
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#02
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#00
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
ld a,#A0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#80
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#08
ld (#C000+67),a
ld a,#00
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0D
ld (#C000+73),a
ld a,#08
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#04
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#03
ld (#C000+74),a
ld a,#0C
ld (#C000+76),a
call waste-22
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#08
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
ld a,#03
ld (#C000+75),a
call waste-22
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#83
ld (#C000+67),a
ld a,#08
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+74),a
ld a,#E0
ld (#C000+75),a
ld a,#04
ld (#C000+76),a
call waste-16
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
ld a,#C0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#D0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne161  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#B0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#00
ld (#C000+69),a
ld a,#10
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#C0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#80
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#82
ld (#C000+68),a
ld a,#E0
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#C0
ld (#C000+68),a
ld a,#01
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#78
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#38
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#80
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#00
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#F0
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#80
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#00
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#80
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0035
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#0F
ld (#C000+72),a
ld a,#0E
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#04
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#02
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
ld a,#01
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#C1
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#18
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#0C
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#06
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#83
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#00
ld (#C000+67),a
ld a,#70
ld (#C000+71),a
ld a,#C3
ld (#C000+75),a
ld a,#08
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#02
ld (#C000+66),a
ld a,#C1
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#F0
ld (#C000+63),a
ld a,#0E
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#07
ld (#C000+66),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#E1
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#E0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#83
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#08
ld (#C000+67),a
ld a,#10
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#F0
ld (#C000+75),a
ld a,#06
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#C1
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#C0
ld (#C000+66),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#E0
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#87
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#83
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#00
ld (#C000+64),a
ld a,#0C
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#80
ld (#C000+63),a
ld a,#06
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#07
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#C1
ld (#C000+76),a
ld a,#08
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#18
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#06
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#08
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#30
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0C
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+70),a
ld a,#E1
ld (#C000+76),a
ld a,#0C
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#0C
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#86
ld (#C000+70),a
ld a,#E0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
ld a,#10
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+76),a
ld a,#06
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#87
ld (#C000+77),a
call waste-58
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#E0
ld (#C000+67),a
ld a,#83
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+67),a
ld a,#06
ld (#C000+68),a
ld a,#C0
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#80
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#03
ld (#C000+72),a
ld a,#38
ld (#C000+73),a
ld a,#00
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#87
ld (#C000+68),a
ld a,#03
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#30
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#08
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#10
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C0
ld (#C000+76),a
call waste-22
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#0B
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#10
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#E0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
ld a,#01
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne66  ;;;;;;;;;;;
ld a,#01
ld (#C000+73),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#01
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0E
ld (#C000+73),a
ld a,#03
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0C
ld (#C000+72),a
ld a,#30
ld (#C000+73),a
ld a,#83
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#C3
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C1
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#0C
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#08
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-34
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#06
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#0E
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#06
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#30
ld (#C000+70),a
ld a,#07
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#87
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#F0
ld (#C000+63),a
ld a,#40
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#83
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#81
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#10
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#70
ld (#C000+62),a
ld a,#C3
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#00
ld (#C000+70),a
ld a,#C1
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#E1
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#E0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#70
ld (#C000+71),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#F0
ld (#C000+75),a
ld a,#06
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#07
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#87
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#0C
ld (#C000+68),a
ld a,#10
ld (#C000+71),a
ld a,#83
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#08
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#0F
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
ld a,#C1
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#0C
ld (#C000+77),a
call waste-58
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+67),a
ld a,#01
ld (#C000+68),a
ld a,#08
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#E1
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#0E
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#F0
ld (#C000+76),a
ld a,#06
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#30
ld (#C000+72),a
ld a,#07
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#C0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#87
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#10
ld (#C000+72),a
ld a,#83
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#08
ld (#C000+78),a
call waste-34
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#C3
ld (#C000+77),a
call waste-58
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#C1
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne113  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#70
ld (#C000+73),a
ld a,#E1
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#E0
ld (#C000+77),a
ld a,#00
ld (#C000+78),a
call waste-52
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#E0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#80
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#03
ld (#C000+71),a
ld a,#0F
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#00
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#00
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
ld a,#08
ld (#C000+75),a
call waste-16
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+72),a
ld a,#03
ld (#C000+73),a
call waste-22
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#02
ld (#C000+63),a
ld a,#F0
ld (#C000+64),a
ld a,#F0
ld (#C000+73),a
ld a,#C1
ld (#C000+74),a
ld a,#0C
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#1C
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#38
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#70
ld (#C000+63),a
ld a,#E1
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#F0
ld (#C000+63),a
ld a,#E0
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#30
ld (#C000+62),a
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
call waste-28
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#83
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+74),a
ld a,#0C
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#04
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#10
ld (#C000+62),a
ld a,#D0
ld (#C000+73),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#0C
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+75),a
ld a,#08
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#08
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#03
ld (#C000+73),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#70
ld (#C000+63),a
ld a,#0E
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-16
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#80
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+73),a
ld a,#81
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+74),a
ld a,#03
ld (#C000+75),a
ld a,#0F
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#F0
ld (#C000+75),a
ld a,#07
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#83
ld (#C000+76),a
ld a,#08
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#06
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#C1
ld (#C000+76),a
ld a,#0C
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#E1
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#08
ld (#C000+69),a
ld a,#E0
ld (#C000+76),a
ld a,#0E
ld (#C000+77),a
call waste-40
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#30
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
ld a,#F0
ld (#C000+76),a
ld a,#07
ld (#C000+77),a
call waste-22
;;;;;;;;; ligne173  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#1E
ld (#C000+72),a
ld a,#06
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0E
ld (#C000+72),a
ld a,#82
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#E0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#C0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#80
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#E0
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-22
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne187  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne188  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne189  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0040
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#01
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#81
ld (#C000+71),a
ld a,#0C
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#06
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+71),a
ld a,#03
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#02
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#83
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C1
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#0E
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#E1
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#E0
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#C0
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#C0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
ld a,#07
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#08
ld (#C000+68),a
ld a,#08
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#87
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#83
ld (#C000+66),a
ld a,#87
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#70
ld (#C000+70),a
ld a,#83
ld (#C000+73),a
ld a,#0C
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#0C
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#00
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#0C
ld (#C000+67),a
ld a,#30
ld (#C000+70),a
ld a,#C1
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#0E
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#60
ld (#C000+64),a
ld a,#00
ld (#C000+65),a
ld a,#E1
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#10
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
ld a,#0F
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#1E
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
ld a,#08
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0C
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#87
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#C1
ld (#C000+69),a
ld a,#83
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#0C
ld (#C000+70),a
ld a,#0C
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#80
ld (#C000+68),a
ld a,#04
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#C1
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#E0
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
ld a,#E1
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#0F
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#08
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
ld a,#07
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#87
ld (#C000+68),a
ld a,#08
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#83
ld (#C000+68),a
ld a,#00
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#07
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#87
ld (#C000+75),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#83
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#C1
ld (#C000+68),a
ld a,#00
ld (#C000+71),a
ld a,#08
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#07
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
ld a,#0E
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#C1
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#82
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#80
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#80
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne61  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne62  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne68  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#07
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#08
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0C
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#0E
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#87
ld (#C000+72),a
ld a,#0C
ld (#C000+74),a
call waste-22
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#83
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#C1
ld (#C000+72),a
ld a,#0E
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne80  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#80
ld (#C000+66),a
ld a,#01
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#C1
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#30
ld (#C000+69),a
ld a,#E1
ld (#C000+72),a
ld a,#0F
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#E0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#E1
ld (#C000+66),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#07
ld (#C000+73),a
ld a,#08
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne87  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+66),a
ld a,#00
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#83
ld (#C000+73),a
ld a,#0C
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#08
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#70
ld (#C000+70),a
ld a,#C3
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
ld a,#C1
ld (#C000+73),a
ld a,#0E
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne94  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#C1
ld (#C000+67),a
ld a,#30
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#E0
ld (#C000+73),a
ld a,#0F
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#3C
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E1
ld (#C000+67),a
ld a,#1C
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#F0
ld (#C000+73),a
ld a,#08
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+70),a
ld a,#07
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#C1
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#87
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#83
ld (#C000+74),a
ld a,#0C
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#C1
ld (#C000+74),a
ld a,#0E
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
ld a,#E1
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#E0
ld (#C000+74),a
ld a,#0F
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne111  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#F0
ld (#C000+74),a
ld a,#07
ld (#C000+75),a
ld a,#08
ld (#C000+77),a
call waste-46
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#87
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#83
ld (#C000+75),a
ld a,#0C
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#70
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#C3
ld (#C000+75),a
ld a,#00
ld (#C000+77),a
call waste-52
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#C1
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#08
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne133  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#0F
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#80
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0C
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#E0
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#0E
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#F0
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+68),a
ld a,#03
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
ld a,#08
ld (#C000+73),a
call waste-22
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#30
ld (#C000+63),a
ld a,#83
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#10
ld (#C000+63),a
ld a,#C0
ld (#C000+70),a
ld a,#08
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#83
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#C0
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
ld a,#C0
ld (#C000+71),a
ld a,#0C
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#C1
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#F0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#83
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#C3
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#C1
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#30
ld (#C000+64),a
ld a,#1E
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#E1
ld (#C000+72),a
ld a,#0C
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#E0
ld (#C000+72),a
ld a,#08
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#10
ld (#C000+64),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#0E
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#80
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#20
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#80
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#0F
ld (#C000+73),a
ld a,#08
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#C0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
ld a,#0C
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+70),a
ld a,#03
ld (#C000+71),a
ld a,#0E
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
ld a,#0F
ld (#C000+74),a
ld a,#08
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#0C
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#83
ld (#C000+72),a
ld a,#0E
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#C1
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#10
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
ld a,#07
ld (#C000+73),a
ld a,#0F
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#10
ld (#C000+70),a
ld a,#83
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#18
ld (#C000+70),a
ld a,#C1
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#08
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
ld a,#08
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#87
ld (#C000+68),a
ld a,#F0
ld (#C000+73),a
ld a,#07
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#0C
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#0F
ld (#C000+70),a
ld a,#78
ld (#C000+71),a
ld a,#83
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#38
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne173  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#3C
ld (#C000+71),a
ld a,#C3
ld (#C000+74),a
ld a,#0E
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#01
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
ld a,#C1
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#E0
ld (#C000+70),a
ld a,#14
ld (#C000+71),a
ld a,#E1
ld (#C000+74),a
ld a,#0F
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#D0
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#0E
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#10
ld (#C000+68),a
ld a,#90
ld (#C000+69),a
ld a,#F0
ld (#C000+74),a
ld a,#07
ld (#C000+75),a
ld a,#0C
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#06
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#80
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#C0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#10
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne189  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0044
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne6  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#01
ld (#C000+68),a
ld a,#08
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#83
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#C1
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#0E
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#80
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#C0
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#3C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-34
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#E1
ld (#C000+66),a
ld a,#1C
ld (#C000+68),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#87
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#0E
ld (#C000+68),a
ld a,#83
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#08
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne24  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#00
ld (#C000+68),a
ld a,#C3
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#84
ld (#C000+67),a
ld a,#C1
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#70
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#E1
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#0E
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#3C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#1E
ld (#C000+69),a
ld a,#87
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#06
ld (#C000+69),a
ld a,#08
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#87
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#C1
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0C
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#78
ld (#C000+70),a
ld a,#E1
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#38
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#0E
ld (#C000+74),a
call waste-58
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#F0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#E1
ld (#C000+68),a
ld a,#1C
ld (#C000+70),a
ld a,#07
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#1E
ld (#C000+70),a
ld a,#83
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#08
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#C3
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#C1
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#E1
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#C1
ld (#C000+72),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#30
ld (#C000+69),a
ld a,#83
ld (#C000+72),a
ld a,#0C
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#86
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne62  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne68  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#08
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#C0
ld (#C000+66),a
call waste-52
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#82
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#F0
ld (#C000+67),a
ld a,#C0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#08
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#C3
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#E0
ld (#C000+66),a
ld a,#30
ld (#C000+67),a
call waste-46
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#38
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#1C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#1E
ld (#C000+68),a
ld a,#87
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#83
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#08
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#E1
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#E0
ld (#C000+67),a
ld a,#70
ld (#C000+69),a
ld a,#C1
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
ld a,#E1
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#E0
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne97  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#C3
ld (#C000+68),a
ld a,#07
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#1E
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#82
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#08
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#C1
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#0C
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#70
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#10
ld (#C000+69),a
ld a,#E1
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
ld a,#0E
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne111  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#10
ld (#C000+70),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne114  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#83
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#08
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#C3
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
ld a,#C1
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#0C
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#E1
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#E0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne123  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#20
ld (#C000+72),a
ld a,#0C
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne125  ;;;;;;;;;;;
ld a,#10
ld (#C000+72),a
ld a,#06
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne126  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne127  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne128  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne129  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0C
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0F
ld (#C000+68),a
ld a,#08
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0E
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#30
ld (#C000+65),a
ld a,#C1
ld (#C000+66),a
ld a,#0F
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#E0
ld (#C000+66),a
ld a,#0C
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#F0
ld (#C000+66),a
ld a,#07
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#81
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#10
ld (#C000+65),a
ld a,#E0
ld (#C000+67),a
ld a,#08
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#C1
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#14
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#06
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#08
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#87
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#83
ld (#C000+67),a
ld a,#38
ld (#C000+68),a
ld a,#83
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#30
ld (#C000+66),a
ld a,#3C
ld (#C000+68),a
ld a,#C3
ld (#C000+69),a
ld a,#0C
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#C3
ld (#C000+67),a
ld a,#1C
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#C1
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#10
ld (#C000+66),a
ld a,#1E
ld (#C000+68),a
ld a,#0E
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
ld a,#06
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#83
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
ld a,#87
ld (#C000+70),a
ld a,#0C
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#06
ld (#C000+69),a
ld a,#03
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#0B
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#B0
ld (#C000+68),a
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#90
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#30
ld (#C000+67),a
ld a,#82
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#08
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#C3
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#87
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
ld a,#83
ld (#C000+70),a
ld a,#0C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
ld a,#C1
ld (#C000+70),a
ld a,#0E
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#E1
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#E0
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#0F
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#F0
ld (#C000+68),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
ld a,#08
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#70
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#C3
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#C1
ld (#C000+69),a
ld a,#C1
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#30
ld (#C000+68),a
ld a,#E0
ld (#C000+69),a
ld a,#0C
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#10
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#14
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#90
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#70
ld (#C000+69),a
ld a,#D0
ld (#C000+70),a
ld a,#0E
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#70
ld (#C000+70),a
ld a,#0F
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#10
ld (#C000+70),a
ld a,#83
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
ld a,#08
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#70
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#C3
ld (#C000+72),a
ld a,#0C
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#C1
ld (#C000+72),a
ld a,#0E
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
ld a,#08
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne190  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0048
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne6  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#04
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#28
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne11  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#3C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#40
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#48
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#1E
ld (#C000+69),a
ld a,#08
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#20
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#24
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#84
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#02
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#40
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne23  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#48
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#08
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#28
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#2C
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#0C
ld (#C000+70),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#48
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#40
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#60
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#20
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#A0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#10
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#42
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#08
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#09
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#2D
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0C
ld (#C000+71),a
ld a,#40
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#48
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#1C
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#20
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#04
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#0F
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#10
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#78
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#38
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne53  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne54  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#1C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne57  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#0E
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne63  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#0C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne72  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#18
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne75  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#78
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#60
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#38
ld (#C000+69),a
ld a,#68
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#28
ld (#C000+69),a
ld a,#28
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne80  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
ld a,#34
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#14
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne83  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#1E
ld (#C000+69),a
ld a,#90
ld (#C000+70),a
ld a,#80
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#0E
ld (#C000+69),a
ld a,#82
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#C2
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#41
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#40
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne90  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#28
ld (#C000+70),a
ld a,#68
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#28
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne93  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#3C
ld (#C000+70),a
ld a,#20
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#1C
ld (#C000+70),a
ld a,#34
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#14
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#1E
ld (#C000+70),a
ld a,#94
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#0E
ld (#C000+70),a
ld a,#90
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne99  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne100  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne102  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne103  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#78
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#38
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne106  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#3C
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#80
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne110  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+71),a
ld a,#40
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne115  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#60
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#68
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#28
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne122  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne123  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne125  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne126  ;;;;;;;;;;;
ld a,#0F
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne127  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne128  ;;;;;;;;;;;
ld a,#06
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne129  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne130  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#80
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#3C
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne136  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne140  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#60
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#30
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne143  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne144  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#14
ld (#C000+70),a
ld a,#80
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#3C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#06
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne149  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#86
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#82
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne152  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#C2
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne154  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#0F
ld (#C000+69),a
ld a,#42
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#02
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#D0
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0A
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#90
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#0E
ld (#C000+70),a
ld a,#82
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#83
ld (#C000+71),a
ld a,#60
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne165  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#0F
ld (#C000+70),a
ld a,#C3
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#C1
ld (#C000+71),a
ld a,#68
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#41
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#61
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#60
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#68
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#38
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne174  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#1C
ld (#C000+71),a
ld a,#A0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#B0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#F0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne180  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne181  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0F
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#70
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne184  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#78
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne187  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#1C
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#0C
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne191  ;;;;;;;;;;;
ld a,#00
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0052
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#18
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#04
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#80
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#0C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#30
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#E0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#38
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#78
ld (#C000+67),a
ld a,#81
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#70
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-28
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#81
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#E1
ld (#C000+68),a
ld a,#38
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#1E
ld (#C000+66),a
ld a,#E0
ld (#C000+68),a
ld a,#E0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
ld a,#F0
ld (#C000+68),a
ld a,#2C
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#08
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#84
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#80
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne25  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
ld a,#C0
ld (#C000+69),a
ld a,#03
ld (#C000+72),a
ld a,#60
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#03
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
ld a,#E0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#0F
ld (#C000+71),a
ld a,#30
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#3C
ld (#C000+67),a
ld a,#03
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#1C
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#30
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#E1
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#1E
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#0E
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#70
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#10
ld (#C000+72),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#48
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#0B
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#87
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#78
ld (#C000+68),a
ld a,#83
ld (#C000+70),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#38
ld (#C000+68),a
ld a,#C3
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#0F
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#3C
ld (#C000+68),a
ld a,#C1
ld (#C000+70),a
ld a,#70
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#E1
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#78
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
ld a,#38
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#30
ld (#C000+73),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#07
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#70
ld (#C000+69),a
ld a,#18
ld (#C000+72),a
ld a,#C0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#78
ld (#C000+69),a
ld a,#80
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
ld a,#B0
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#80
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
ld a,#00
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#80
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#1E
ld (#C000+69),a
ld a,#E0
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#18
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0F
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#06
ld (#C000+70),a
ld a,#C0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#38
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#38
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#0A
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#50
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#C0
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#38
ld (#C000+67),a
ld a,#02
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0E
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#80
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#1C
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-22
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#38
ld (#C000+66),a
ld a,#03
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#C0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#1C
ld (#C000+66),a
ld a,#F0
ld (#C000+68),a
ld a,#07
ld (#C000+69),a
ld a,#78
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#38
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne84  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#1E
ld (#C000+66),a
ld a,#83
ld (#C000+69),a
ld a,#3C
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0E
ld (#C000+66),a
ld a,#1C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne87  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#C3
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#70
ld (#C000+67),a
ld a,#C1
ld (#C000+69),a
ld a,#0E
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne90  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne91  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#38
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#70
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne94  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#1C
ld (#C000+67),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#F0
ld (#C000+72),a
ld a,#E0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#1E
ld (#C000+67),a
ld a,#87
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0E
ld (#C000+67),a
ld a,#83
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#38
ld (#C000+71),a
ld a,#80
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#C2
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#00
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#70
ld (#C000+68),a
ld a,#D0
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#38
ld (#C000+68),a
ld a,#80
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#00
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#1C
ld (#C000+68),a
ld a,#80
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#1E
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0E
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne116  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#38
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne119  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne120  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne123  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#1E
ld (#C000+69),a
ld a,#80
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne125  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne126  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne127  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne128  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne129  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne130  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#1C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#38
ld (#C000+70),a
ld a,#E0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#01
ld (#C000+67),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
ld a,#1C
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#38
ld (#C000+69),a
ld a,#F0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#70
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#38
ld (#C000+68),a
ld a,#80
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#70
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0E
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#C1
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#1E
ld (#C000+67),a
ld a,#83
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#1C
ld (#C000+67),a
ld a,#07
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#78
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#3C
ld (#C000+67),a
ld a,#C1
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#38
ld (#C000+67),a
ld a,#83
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#3C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#78
ld (#C000+67),a
ld a,#1C
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#70
ld (#C000+67),a
ld a,#87
ld (#C000+69),a
ld a,#F0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne151  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#83
ld (#C000+69),a
ld a,#38
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#F0
ld (#C000+67),a
ld a,#70
ld (#C000+71),a
ld a,#80
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0E
ld (#C000+66),a
ld a,#0E
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#1E
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#1C
ld (#C000+70),a
ld a,#C0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#E0
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
ld a,#C1
ld (#C000+68),a
ld a,#70
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#38
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#83
ld (#C000+68),a
ld a,#1C
ld (#C000+69),a
ld a,#C1
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#3C
ld (#C000+67),a
ld a,#07
ld (#C000+68),a
ld a,#38
ld (#C000+69),a
ld a,#C3
ld (#C000+71),a
ld a,#3C
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#0C
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#83
ld (#C000+71),a
ld a,#1C
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#03
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+71),a
ld a,#F0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#C1
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#1E
ld (#C000+68),a
ld a,#80
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#E1
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#3C
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#38
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#0E
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#1C
ld (#C000+72),a
ld a,#E0
ld (#C000+74),a
call waste-52
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#38
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#07
ld (#C000+71),a
ld a,#78
ld (#C000+72),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#3C
ld (#C000+68),a
ld a,#70
ld (#C000+72),a
ld a,#80
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#1C
ld (#C000+68),a
ld a,#06
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#00
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#94
ld (#C000+71),a
ld a,#C0
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#B0
ld (#C000+71),a
ld a,#80
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#0E
ld (#C000+68),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne180  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#01
ld (#C000+66),a
ld a,#E0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne183  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#80
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#38
ld (#C000+69),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#E0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#07
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#1C
ld (#C000+69),a
ld a,#C0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret


frame0056
;;;;;;;;; ligne0  ;;;;;;;;;;;
ld (stack_save),sp
ld sp,stack_context
call waste-55 
;;;;;;;;; ligne1  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne2  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne3  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne4  ;;;;;;;;;;;
ld a,#80
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne5  ;;;;;;;;;;;
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#C0
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne6  ;;;;;;;;;;;
ld a,#F0
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne7  ;;;;;;;;;;;
ld a,#02
ld (#C000+69),a
ld a,#70
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne8  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#30
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne9  ;;;;;;;;;;;
ld a,#04
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne10  ;;;;;;;;;;;
ld a,#02
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne11  ;;;;;;;;;;;
ld a,#10
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne12  ;;;;;;;;;;;
ld a,#04
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne13  ;;;;;;;;;;;
ld a,#02
ld (#C000+65),a
ld a,#70
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne14  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne15  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#3C
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#F0
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne16  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#38
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#1E
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne17  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#70
ld (#C000+65),a
ld a,#00
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne18  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#C0
ld (#C000+67),a
ld a,#07
ld (#C000+70),a
ld a,#C0
ld (#C000+73),a
call waste-28
;;;;;;;;; ligne19  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne20  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#38
ld (#C000+64),a
ld a,#E0
ld (#C000+67),a
ld a,#0F
ld (#C000+71),a
ld a,#00
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne21  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#08
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne22  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#00
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne23  ;;;;;;;;;;;
ld a,#F0
ld (#C000+67),a
call waste-58
;;;;;;;;; ligne24  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#3C
ld (#C000+64),a
ld a,#02
ld (#C000+74),a
ld a,#40
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne25  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#03
ld (#C000+73),a
ld a,#18
ld (#C000+74),a
ld a,#C0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne26  ;;;;;;;;;;;
ld a,#0C
ld (#C000+73),a
ld a,#F0
ld (#C000+74),a
ld a,#E0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne27  ;;;;;;;;;;;
ld a,#1E
ld (#C000+64),a
ld a,#80
ld (#C000+68),a
ld a,#07
ld (#C000+72),a
ld a,#30
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne28  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#01
ld (#C000+71),a
ld a,#08
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
call waste-34
;;;;;;;;; ligne29  ;;;;;;;;;;;
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#F0
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne30  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#03
ld (#C000+70),a
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne31  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0F
ld (#C000+64),a
ld a,#70
ld (#C000+65),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne32  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne33  ;;;;;;;;;;;
ld a,#E1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#3C
ld (#C000+70),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne34  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#78
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#1C
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne35  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#81
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne36  ;;;;;;;;;;;
ld a,#1E
ld (#C000+70),a
ld a,#E0
ld (#C000+71),a
ld a,#07
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne37  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#3C
ld (#C000+65),a
ld a,#F0
ld (#C000+68),a
ld a,#0E
ld (#C000+70),a
ld a,#83
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#78
ld (#C000+73),a
call waste-22
;;;;;;;;; ligne38  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#07
ld (#C000+69),a
ld a,#03
ld (#C000+71),a
ld a,#38
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne39  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
ld a,#01
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne40  ;;;;;;;;;;;
ld a,#80
ld (#C000+69),a
ld a,#E0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne41  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#1C
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne42  ;;;;;;;;;;;
ld a,#00
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne43  ;;;;;;;;;;;
ld a,#F0
ld (#C000+76),a
call waste-58
;;;;;;;;; ligne44  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
ld a,#1E
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne45  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#0E
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
call waste-46
;;;;;;;;; ligne46  ;;;;;;;;;;;
ld a,#07
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-52
;;;;;;;;; ligne47  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#78
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#80
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne48  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#0C
ld (#C000+73),a
call waste-52
;;;;;;;;; ligne49  ;;;;;;;;;;;
ld a,#01
ld (#C000+71),a
ld a,#0F
ld (#C000+72),a
ld a,#70
ld (#C000+73),a
ld a,#00
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne50  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+71),a
ld a,#18
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne51  ;;;;;;;;;;;
ld a,#1C
ld (#C000+66),a
ld a,#01
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#70
ld (#C000+72),a
ld a,#C0
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne52  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#18
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne53  ;;;;;;;;;;;
ld a,#04
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+74),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne54  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0E
ld (#C000+66),a
ld a,#30
ld (#C000+70),a
ld a,#80
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne55  ;;;;;;;;;;;
ld a,#F0
ld (#C000+70),a
ld a,#C0
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne56  ;;;;;;;;;;;
ld a,#00
ld (#C000+73),a
call waste-58
;;;;;;;;; ligne57  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne58  ;;;;;;;;;;;
ld a,#70
ld (#C000+67),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne59  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne60  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#78
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#00
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne61  ;;;;;;;;;;;
ld a,#18
ld (#C000+67),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne62  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#07
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#08
ld (#C000+68),a
ld a,#60
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-28
;;;;;;;;; ligne63  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-40
;;;;;;;;; ligne64  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne65  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne66  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne67  ;;;;;;;;;;;
ld a,#07
ld (#C000+70),a
ld a,#0C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#80
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne68  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne69  ;;;;;;;;;;;
ld a,#07
ld (#C000+69),a
ld a,#0E
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne70  ;;;;;;;;;;;
ld a,#01
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#38
ld (#C000+70),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne71  ;;;;;;;;;;;
ld a,#07
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne72  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#18
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne73  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne74  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#18
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne75  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#0B
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne76  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#0E
ld (#C000+66),a
ld a,#50
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#E0
ld (#C000+70),a
ld a,#70
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne77  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#30
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#81
ld (#C000+70),a
ld a,#F0
ld (#C000+74),a
call waste-28
;;;;;;;;; ligne78  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#0C
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#78
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne79  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0F
ld (#C000+64),a
ld a,#30
ld (#C000+65),a
ld a,#C1
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne80  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#0C
ld (#C000+64),a
ld a,#F0
ld (#C000+65),a
ld a,#01
ld (#C000+69),a
ld a,#80
ld (#C000+75),a
call waste-34
;;;;;;;;; ligne81  ;;;;;;;;;;;
ld a,#03
ld (#C000+62),a
ld a,#0F
ld (#C000+63),a
ld a,#30
ld (#C000+64),a
ld a,#80
ld (#C000+68),a
ld a,#3C
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne82  ;;;;;;;;;;;
ld a,#F0
ld (#C000+64),a
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne83  ;;;;;;;;;;;
ld a,#70
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne84  ;;;;;;;;;;;
ld a,#01
ld (#C000+62),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne85  ;;;;;;;;;;;
ld a,#80
ld (#C000+68),a
ld a,#07
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne86  ;;;;;;;;;;;
ld a,#38
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne87  ;;;;;;;;;;;
ld a,#00
ld (#C000+62),a
ld a,#E0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne88  ;;;;;;;;;;;
ld a,#C0
ld (#C000+68),a
ld a,#03
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne89  ;;;;;;;;;;;
ld a,#1C
ld (#C000+64),a
ld a,#70
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne90  ;;;;;;;;;;;
ld a,#F0
ld (#C000+75),a
call waste-58
;;;;;;;;; ligne91  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#E0
ld (#C000+68),a
ld a,#78
ld (#C000+72),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne92  ;;;;;;;;;;;
ld a,#1E
ld (#C000+64),a
ld a,#01
ld (#C000+70),a
ld a,#38
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne93  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne94  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
call waste-58
;;;;;;;;; ligne95  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#F0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne96  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#03
ld (#C000+70),a
ld a,#78
ld (#C000+72),a
ld a,#80
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne97  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#07
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne98  ;;;;;;;;;;;
ld a,#78
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#00
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne99  ;;;;;;;;;;;
ld a,#38
ld (#C000+65),a
ld a,#81
ld (#C000+69),a
ld a,#1C
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne100  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#83
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne101  ;;;;;;;;;;;
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne102  ;;;;;;;;;;;
ld a,#1C
ld (#C000+65),a
ld a,#C3
ld (#C000+69),a
ld a,#30
ld (#C000+70),a
ld a,#E0
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne103  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#C0
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#80
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne104  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne105  ;;;;;;;;;;;
ld a,#0E
ld (#C000+65),a
ld a,#C0
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne106  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#00
ld (#C000+72),a
call waste-52
;;;;;;;;; ligne107  ;;;;;;;;;;;
ld a,#C0
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne108  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#00
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne109  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne110  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne111  ;;;;;;;;;;;
ld a,#78
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne112  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne113  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
call waste-58
;;;;;;;;; ligne114  ;;;;;;;;;;;
ld a,#3C
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne115  ;;;;;;;;;;;
ld a,#1C
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne116  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne117  ;;;;;;;;;;;
ld a,#E0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne118  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne119  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne120  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne121  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#70
ld (#C000+67),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne122  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
call waste-58
;;;;;;;;; ligne123  ;;;;;;;;;;;
ld a,#C0
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne124  ;;;;;;;;;;;
ld a,#38
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne125  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#C0
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne126  ;;;;;;;;;;;
ld a,#00
ld (#C000+69),a
call waste-58
;;;;;;;;; ligne127  ;;;;;;;;;;;
ld a,#3C
ld (#C000+67),a
ld a,#C0
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne128  ;;;;;;;;;;;
ld a,#07
ld (#C000+66),a
ld a,#1C
ld (#C000+67),a
ld a,#00
ld (#C000+68),a
call waste-46
;;;;;;;;; ligne129  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne130  ;;;;;;;;;;;
ld a,#02
ld (#C000+70),a
call waste-58
;;;;;;;;; ligne131  ;;;;;;;;;;;
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne132  ;;;;;;;;;;;
ld a,#03
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
ld a,#C0
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne133  ;;;;;;;;;;;
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#80
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne134  ;;;;;;;;;;;
ld a,#03
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#C0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne135  ;;;;;;;;;;;
ld a,#0F
ld (#C000+68),a
ld a,#30
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne136  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#0C
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne137  ;;;;;;;;;;;
ld a,#0F
ld (#C000+67),a
ld a,#30
ld (#C000+69),a
ld a,#E0
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne138  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#0C
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
call waste-46
;;;;;;;;; ligne139  ;;;;;;;;;;;
ld a,#0F
ld (#C000+66),a
ld a,#38
ld (#C000+68),a
call waste-52
;;;;;;;;; ligne140  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#0E
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#F0
ld (#C000+74),a
call waste-40
;;;;;;;;; ligne141  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#38
ld (#C000+67),a
call waste-52
;;;;;;;;; ligne142  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#0E
ld (#C000+66),a
ld a,#F0
ld (#C000+67),a
ld a,#30
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne143  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#18
ld (#C000+66),a
ld a,#C0
ld (#C000+70),a
ld a,#38
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne144  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#03
ld (#C000+70),a
ld a,#80
ld (#C000+75),a
call waste-46
;;;;;;;;; ligne145  ;;;;;;;;;;;
ld a,#0F
ld (#C000+64),a
ld a,#0E
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#1C
ld (#C000+71),a
call waste-28
;;;;;;;;; ligne146  ;;;;;;;;;;;
ld a,#1E
ld (#C000+65),a
ld a,#80
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne147  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#1C
ld (#C000+65),a
ld a,#E0
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#C0
ld (#C000+75),a
call waste-28
;;;;;;;;; ligne148  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#38
ld (#C000+65),a
ld a,#80
ld (#C000+68),a
ld a,#0E
ld (#C000+71),a
call waste-40
;;;;;;;;; ligne149  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
call waste-58
;;;;;;;;; ligne150  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#70
ld (#C000+65),a
ld a,#03
ld (#C000+70),a
ld a,#E0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne151  ;;;;;;;;;;;
ld a,#0F
ld (#C000+63),a
ld a,#F0
ld (#C000+65),a
ld a,#80
ld (#C000+68),a
ld a,#07
ld (#C000+70),a
ld a,#0F
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne152  ;;;;;;;;;;;
ld a,#0E
ld (#C000+64),a
ld a,#01
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#70
ld (#C000+72),a
call waste-40
;;;;;;;;; ligne153  ;;;;;;;;;;;
ld a,#07
ld (#C000+63),a
ld a,#1C
ld (#C000+64),a
ld a,#07
ld (#C000+69),a
ld a,#0C
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
call waste-34
;;;;;;;;; ligne154  ;;;;;;;;;;;
ld a,#C1
ld (#C000+68),a
ld a,#0F
ld (#C000+69),a
ld a,#30
ld (#C000+71),a
ld a,#F0
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne155  ;;;;;;;;;;;
ld a,#83
ld (#C000+68),a
ld a,#0C
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne156  ;;;;;;;;;;;
ld a,#03
ld (#C000+63),a
ld a,#0E
ld (#C000+64),a
ld a,#03
ld (#C000+68),a
ld a,#38
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne157  ;;;;;;;;;;;
ld a,#C0
ld (#C000+67),a
ld a,#0F
ld (#C000+68),a
ld a,#0E
ld (#C000+69),a
ld a,#F0
ld (#C000+70),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne158  ;;;;;;;;;;;
ld a,#03
ld (#C000+67),a
ld a,#18
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne159  ;;;;;;;;;;;
ld a,#01
ld (#C000+63),a
ld a,#0F
ld (#C000+64),a
ld a,#C0
ld (#C000+66),a
ld a,#0F
ld (#C000+67),a
ld a,#0E
ld (#C000+68),a
ld a,#70
ld (#C000+69),a
call waste-28
;;;;;;;;; ligne160  ;;;;;;;;;;;
ld a,#70
ld (#C000+65),a
ld a,#83
ld (#C000+66),a
ld a,#18
ld (#C000+68),a
ld a,#F0
ld (#C000+69),a
ld a,#10
ld (#C000+72),a
ld a,#C0
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne161  ;;;;;;;;;;;
ld a,#00
ld (#C000+63),a
ld a,#07
ld (#C000+64),a
ld a,#60
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#0E
ld (#C000+67),a
ld a,#70
ld (#C000+68),a
ld a,#C0
ld (#C000+71),a
ld a,#0E
ld (#C000+72),a
call waste-16
;;;;;;;;; ligne162  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#49
ld (#C000+65),a
ld a,#1C
ld (#C000+67),a
ld a,#F0
ld (#C000+68),a
ld a,#83
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne163  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#03
ld (#C000+65),a
ld a,#38
ld (#C000+67),a
ld a,#E0
ld (#C000+70),a
ld a,#03
ld (#C000+71),a
call waste-34
;;;;;;;;; ligne164  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#70
ld (#C000+67),a
ld a,#C0
ld (#C000+70),a
ld a,#0F
ld (#C000+72),a
ld a,#E0
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne165  ;;;;;;;;;;;
ld a,#0F
ld (#C000+65),a
ld a,#F0
ld (#C000+67),a
ld a,#00
ld (#C000+70),a
ld a,#70
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne166  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
ld a,#C0
ld (#C000+69),a
ld a,#01
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne167  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#1E
ld (#C000+66),a
ld a,#78
ld (#C000+73),a
ld a,#F0
ld (#C000+76),a
call waste-40
;;;;;;;;; ligne168  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#1C
ld (#C000+66),a
ld a,#38
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne169  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
call waste-58
;;;;;;;;; ligne170  ;;;;;;;;;;;
ld a,#07
ld (#C000+64),a
ld a,#78
ld (#C000+66),a
ld a,#E0
ld (#C000+69),a
ld a,#07
ld (#C000+71),a
ld a,#80
ld (#C000+77),a
call waste-34
;;;;;;;;; ligne171  ;;;;;;;;;;;
ld a,#03
ld (#C000+64),a
ld a,#70
ld (#C000+66),a
ld a,#0F
ld (#C000+71),a
ld a,#1C
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne172  ;;;;;;;;;;;
ld a,#0E
ld (#C000+65),a
ld a,#F0
ld (#C000+66),a
ld a,#03
ld (#C000+70),a
ld a,#70
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne173  ;;;;;;;;;;;
ld a,#F0
ld (#C000+69),a
ld a,#0F
ld (#C000+70),a
ld a,#0C
ld (#C000+72),a
ld a,#F0
ld (#C000+73),a
ld a,#E0
ld (#C000+76),a
ld a,#00
ld (#C000+77),a
call waste-28
;;;;;;;;; ligne174  ;;;;;;;;;;;
ld a,#01
ld (#C000+64),a
ld a,#0F
ld (#C000+65),a
ld a,#E0
ld (#C000+69),a
ld a,#38
ld (#C000+72),a
ld a,#80
ld (#C000+76),a
call waste-34
;;;;;;;;; ligne175  ;;;;;;;;;;;
ld a,#70
ld (#C000+66),a
ld a,#F0
ld (#C000+69),a
ld a,#07
ld (#C000+70),a
ld a,#0E
ld (#C000+71),a
ld a,#F0
ld (#C000+72),a
ld a,#00
ld (#C000+76),a
call waste-28
;;;;;;;;; ligne176  ;;;;;;;;;;;
ld a,#18
ld (#C000+71),a
ld a,#C0
ld (#C000+75),a
call waste-52
;;;;;;;;; ligne177  ;;;;;;;;;;;
ld a,#00
ld (#C000+64),a
ld a,#78
ld (#C000+66),a
ld a,#70
ld (#C000+71),a
ld a,#00
ld (#C000+75),a
call waste-40
;;;;;;;;; ligne178  ;;;;;;;;;;;
ld a,#38
ld (#C000+66),a
ld a,#90
ld (#C000+70),a
ld a,#F0
ld (#C000+71),a
ld a,#E0
ld (#C000+73),a
ld a,#40
ld (#C000+74),a
call waste-34
;;;;;;;;; ligne179  ;;;;;;;;;;;
ld a,#B0
ld (#C000+70),a
ld a,#C1
ld (#C000+73),a
ld a,#00
ld (#C000+74),a
call waste-46
;;;;;;;;; ligne180  ;;;;;;;;;;;
ld a,#07
ld (#C000+65),a
ld a,#3C
ld (#C000+66),a
ld a,#F0
ld (#C000+70),a
ld a,#80
ld (#C000+73),a
call waste-40
;;;;;;;;; ligne181  ;;;;;;;;;;;
ld a,#1C
ld (#C000+66),a
ld a,#E0
ld (#C000+72),a
ld a,#00
ld (#C000+73),a
call waste-46
;;;;;;;;; ligne182  ;;;;;;;;;;;
ld a,#C0
ld (#C000+72),a
call waste-58
;;;;;;;;; ligne183  ;;;;;;;;;;;
ld a,#03
ld (#C000+65),a
ld a,#1E
ld (#C000+66),a
ld a,#00
ld (#C000+72),a
call waste-46
;;;;;;;;; ligne184  ;;;;;;;;;;;
ld a,#0E
ld (#C000+66),a
ld a,#E0
ld (#C000+71),a
call waste-52
;;;;;;;;; ligne185  ;;;;;;;;;;;
ld a,#80
ld (#C000+71),a
call waste-58
;;;;;;;;; ligne186  ;;;;;;;;;;;
ld a,#01
ld (#C000+65),a
ld a,#0F
ld (#C000+66),a
ld a,#00
ld (#C000+71),a
call waste-46
;;;;;;;;; ligne187  ;;;;;;;;;;;
ld a,#00
ld (#C000+65),a
ld a,#70
ld (#C000+67),a
ld a,#C0
ld (#C000+70),a
call waste-46
;;;;;;;;; ligne188  ;;;;;;;;;;;
ld a,#03
ld (#C000+66),a
ld a,#80
ld (#C000+70),a
call waste-52
;;;;;;;;; ligne189  ;;;;;;;;;;;
ld a,#00
ld (#C000+66),a
ld a,#00
ld (#C000+67),a
ld a,#E0
ld (#C000+69),a
ld a,#00
ld (#C000+70),a
call waste-40
;;;;;;;;; ligne190  ;;;;;;;;;;;
ld a,#00
ld (#C000+68),a
ld a,#00
ld (#C000+69),a
call waste-52
;;;;;;;;; ligne191  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne192  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne193  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne194  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne195  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne196  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne197  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne198  ;;;;;;;;;;;
call waste-64
;;;;;;;;; ligne199  ;;;;;;;;;;;
call waste-55
ld sp,(stack_save)
ret

finframe',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: 1er-essai
  SELECT id INTO tag_uuid FROM tags WHERE name = '1er-essai';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
