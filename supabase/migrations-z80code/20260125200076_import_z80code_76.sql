-- Migration: Import z80code projects batch 76
-- Projects 151 to 152
-- Generated: 2026-01-25T21:43:30.205178

-- Project 151: rubidouille-19 by Rubi
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'rubidouille-19',
    'Imported from z80Code. Author: Rubi. Scroll diagonal',
    'public',
    false,
    false,
    '2019-11-24T10:38:41.126000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'T_CARAC EQU #7000
T_TABLE EQU #7800

ORG #9000
_start:
;
; PRENDRE LES FONTES DES CARACTERES
;
        JP QON  ; SCROLLING ACTIVE
        JP QOFF ; SCROLLING DESACTIVE
QON:    XOR A
        CALL #BBA5
        CALL #B906
        PUSH AF
        LD DE,T_CARAC
        LD BC,8*256
        LDIR
        POP AF
        CALL #B90C
;
NB      EQU 55
LI      EQU 110
; CALCUL D''UNE PENTE
        CALL PENTE
        LD HL,NOM       ; LE MESSAGE AU DEBUT SVP
        LD (OFNOM),HL
;
; ON RECCONFIGURE LES INTERUPTIONS DU CPC
;
D_INT:  DI
        LD HL, (#39)
        INC HL
        LD (QINT) ,HL
        LD (HL),#C3
        LD DE, INT_
        INC HL
        LD (HL),E
        INC HL
        LD (HL),D
        INC HL
        LD (D_INT3+1) ,HL
        LD DE,#33
        ADD HL,DE
        LD (D_INT2+1),HL
        RET
;
PENTE:  LD   HL,#C000 + 12
        LD   B,LI
PENTE0: CALL RBC26
        DJNZ PENTE0
        LD   B,8
        LD   IX,T_TABLE
PENTE1: PUSH HL
        LD   C,NB
PENTE2: LD   (IX+0),L
        LD   (IX+1),H
        INC  IX
        INC  IX
        INC  HL
        CALL RBC26
        DEC  C
        JR   NZ,PENTE2
        POP  HL
        CALL RBC26
        DJNZ PENTE1
        LD   HL,(NB-1)*2+T_TABLE
        LD   A,(HL)
        INC  HL
        LD   H,(HL)
        LD   L,A
        LD   (OFSET),HL
        RET
;
INT_:    PUSH AF
        PUSH BC
        PUSH HL
        PUSH DE
        LD BC,#7F8E
        OUT (C),C
        CALL INTA
        POP DE
        POP HL
        POP BC
        POP AF
        EX AF,AF''
D_INT2: JP C,0
D_INT3: JP 0
;
INTA:   LD B,#F5
        IN A, (C)
        RRA
        JR C,INTE0
KL:     LD A, 7
        INC A
        LD (KL+1),A
        CP 1
        JR Z,INTE1
        CP 2
        JR Z,INTE1
        CP 3
        JR Z,INTE1
       CP 4
        JR Z,INTE2
        RET
;
INTE0:  XOR A
        LD (KL+1) ,A
        LD HL,T_TABLE
        JR SPRG1
INTE1:  LD HL, (THL)
SPRG1:   LD B,2
SPRG1_1: LD C,NB-1
         LD E, (HL)
         INC HL
         LD D, (HL)
         INC HL
SPRG1_2: PUSH HL
         LD A, (HL)
         INC HL
         LD H, (HL)
         LD L,A
         LD A, (HL)
         LD (DE), A
         EX DE ,HL
         POP HL
         INC HL
         INC HL
         DEC C
         JR NZ,SPRG1_2
         DJNZ SPRG1_1
         LD (THL) ,HL
         RET
;
INTE2:
SPRG2:   ; ENVOIE DU CARACTERE
         LD HL, (OFNOM)
         LD A, (HL)
         OR A
         JR NZ,SPRG2_1
         LD HL ,NOM
         LD A, (HL)
SPRG2_1: INC HL
         LD (OFNOM), HL
         LD L, A 
         LD H, 0
         ADD HL, HL
         ADD HL, HL
         ADD HL, HL
         LD DE, T_CARAC
         ADD HL, DE
         EX DE, HL
         LD HL, (OFSET)
         LD B, 8
SPRG2_2: LD A, (DE)
         LD (HL), A
         INC DE
         CALL RBC26
         DJNZ SPRG2_2
RET
QOFF:    DI
         LD HL, (QINT)
         LD (HL), #08
         INC HL
         LD (HL), #38
         INC HL
         LD (HL),#33
         RET
;
RBC26:
         LD A,H
         ADD #08
         LD H,A
         AND #38
         RET NZ
         LD A, H 
         SUB #40
         LD H, A 
         LD A, L 
         ADD A, #50
         LD L, A 
         RET NC
         INC H 
         LD A, H 
         AND #07
         RET NZ
         LD A, H 
         SUB #08
         LD H, A
         RET
;
;
FLAG1   DW 0
OFSET   DW 0
OFNOM   DW 0
THL     DW 0
QINT    DW 0
;
NOM     DM "BONJOUR A TOI" 
        DM ", LISEZ 100% "
        DS 12, 32        
        DB 0, 255
_end:
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rubidouille
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rubidouille';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 152: sinus-scroll by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sinus-scroll',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2022-01-11T21:38:45.652000'::timestamptz,
    '2022-01-11T23:38:51.320000'::timestamptz
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


module Scroll

R1	equ 48
R2	equ 50
R3	equ 8
R6	equ 21

macro CALC_TILE_ADR offset
                ld l, 0 : ld h, a
                scf                              ; pour ajouter TILE_ADR au résultat (#4000)
                rr h  : rr l  
                srl h : rr l
endm

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

	SET_MODE 0
	SET_PALETTE palette, 0, 16


.loop
	WAIT_VBL (void)

.col_count	ld a, 3
	or a
	jr nz, .same_chr

.text_ptr:	ld hl, text - 1
	inc hl
	ld a, (hl)
	or a
	jr nz, .save_text_ptr
	ld hl, text
	ld a, (hl)
.save_text_ptr
	ld (.text_ptr + 1), hl
	CALC_TILE_ADR 0
.insert_pos	ld de, buffer + R1 * 2
	call cp_chr
.same_chr
	call render
	
	ld a, (.col_count + 1)
	inc a
	and 3
	ld (.col_count + 1), a
	
	ld a, (.insert_pos + 1)
	inc a
	ld (.insert_pos + 1), a

	jr .loop


render:

.src:	ld de, buffer
repeat R1 * 2, xx
x = xx - 1
ld b, d
off = 100 + floor(16 * sin(x / (R1 * 2) * 360))
off1 = floor(32 * cos(45 + x / (R1 * 8) * 720))
repeat 16, yy
y = yy + off - off1 - 1
print off1
adr = (#c000 + (floor(y / 8) * R1 * 2) + (y & 7) * #800 + x
ld a, (de)
ld (adr), a
inc d
rend yy
ld d, b
inc e
rend

	ld hl, .src + 1
	inc (hl)
	ret	


cp_chr:
	ld c, 4
.loop_x
	ld b, 16
	ld ixh, d
.loop_y	ld a, (hl)
	ld (de), a
	inc d
	inc l
	djnz .loop_y
	ld d, ixh
	inc e
	dec c
	jr nz, .loop_x
	
	ret


align 16
palette
	db Color.fm_0
	db Color.fm_3
	db Color.fm_15
	db Color.fm_25
	db Color.fm_26
	ds 10




text:	db ''hello world                                 ''                                 
	db ''my first sinus scroll on the amstrad cpc !!!''
	db ''                                            '', 0

org #4000
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


align 256
buffer:	ds #1000



module off',
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
