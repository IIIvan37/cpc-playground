-- Migration: Import z80code projects batch 83
-- Projects 165 to 166
-- Generated: 2026-01-25T21:43:30.206393

-- Project 165: alinka by rix
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'alinka',
    'Imported from z80Code. Author: rix. Revival of Alinka sources',
    'public',
    false,
    false,
    '2022-02-09T14:25:03.879000'::timestamptz,
    '2022-02-10T15:07:30.631000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '
;; -----------------------------------------------------------
;; Various constants
;; -----------------------------------------------------------

DATA_ADDR equ #400b
CODE_ADDR equ #7e65

FILE_BUF 	 equ #1388

COMPRSD_DATA_LEN  equ #3b83
COMPRSD_DATA_ADDR equ #4268

;; -----------------------------------------------------------
;; Various screen address location to display text and bitmaps
;; -----------------------------------------------------------

GAME_TITLE_SCR	 equ #c000

L_AMANT_SCR1	 equ #c1ac
L_AMANT_SCR2	 equ #c3ed

LES_SCR 	 equ #c2b1
MEILLEURS_SCR 	 equ #c2eb
SOUPIRANTS_SCR 	 equ #c32a

KOZAK_DANCER_SCR equ #e4ea
ALINKA_HEAD_SCR	 equ #e4ea


AMANT_SCR 	 equ #c1eb
HSCORE1_SCR	 equ #c3ab
HSCORE2_SCR	 equ #c3eb
HSCORE3_SCR	 equ #c42b
HSCORE4_SCR	 equ #c46b
HSCORE5_SCR	 equ #c4ab

DEFI_CHOICE_SCR	 equ #c645

INVALID_SCR	 equ #c68b
OK_SCR		 equ #c691

INFO_DEFI_SCR	 equ #c183
INFO_LINES_SCR	 equ #c1c3
INFO_BONUS_SCR	 equ #c202
SOUPIRANT_1_SCR	 equ #c2c4
SCORE1_SCR	 equ #c30a
SCORE2_SCR	 equ #c392
SOUPIRANT_2_SCR	 equ #c3cc
ALINKA_SCR	 equ #c509

MENU1_SCR	 equ #c583
MENU2_SCR	 equ #c5c3
MENU3_SCR	 equ #c643
MENU4_SCR1	 equ #c683
MENU4_SCR2 	 equ #c6cc

COPYRIGHT1_SCR	 equ #c746
COPYRIGHT2_SCR	 equ #c786

DROITE_SCR	 equ #c58a
GAUCHE_SCR	 equ #c5ca
ACCELERE_SCR	 equ #c608
ROTATION_SCR	 equ #c648

SOUPIRANT_SCR 	 equ #c3eb
SOUPIRANT_NUM_SCR equ #c433

PRET_SCR 	 equ #c470
DOMMAGE_SCR	 equ #c46d
TU_AS_SCR	 equ #c3ef
ECHOUE_SCR	 equ #c42e
DAMNED_SCR	 equ #c3eb
DEFI_SCR 	 equ #c430
REMPORTE_SCR	 equ #c46c
TES_SCR1	 equ #c5c6
TES_SCR2	 equ #c3f1
INITIALES_SCR1	 equ #c5ce
INITIALES_SCR2   equ #c42b
DOTS_SCR1	 equ #c610
DOTS_SCR2	 equ #c471
BRAVO_SCR	 equ #c46f
TU_ES_SCR	 equ #c3ef
DEVENU_SCR	 equ #c42e
LE_TITRE_SCR	 equ #c3ec
D_SCR 		 equ #c42d
TU_N_AS_SCR 	 equ #c42d
PAS_SCR 	 equ #c471
MAIS_SCR 	 equ #c3f0
EN_TITRE_SCR 	 equ #c46c
MAESTRIA_SCR 	 equ #c42c
COMBO_SCR	 equ #c349
COMBO_DIM	 equ #0814
DEFI2_SCR	 equ #e36d
LIGNES_SCR 	 equ #e3eb
A_SCR		 equ #e473
COMPLETER_SCR	 equ #e4eb

PLAYGND_SCR	 equ #e16a	  ;; playground screen address
PLAYGND_BOTTOM_LINE_SCR equ #e7aa ;; playground bottom line screen address


PLAYGND_DIM	 equ #d014	;; playground dimensions 20x208
PLAYGND_LINE_DIM equ #0814	;; One playground line dimension 20x8

PLAYGND_OFSCR	 equ #2e53	  ;; playground offscreen bitmap''s address

;; Dance floor and curtain offscreen buffers 
;; are overlapping with playground offscreen buffer.
;; They are not used simultaneously.
DANCEFLR_OFSCR	 equ #2fc9	;; Dance floor with columns and Alinka 34x100
CURTAIN_OFSCR 	 equ #3d55	;; Curtain 34x8  

;; Playground mask buffer
;; 22 lignes of 12 cells.
;; cell: 0 is empty, otherwise occupied
PLAYGND_MSK_BUF equ #3ebb


;; Define to 1 to skip the data decompression''s code
;; when linking with the uncompressed data
SKIP_DECOMPRESS equ 1


	org CODE_ADDR

	;RUN DISK_FIX

;;#7e65
MAIN:

	;; --------------------
	;; Set border color
	;; --------------------
	ld bc,#0404
	call #bc38

	;; --------------------
	;; Set pen colors, all purple
	;; to hide the on screen data preparation
	;; --------------------
;;#7e6b
	ld a,#10
MAIN_hide_loop:
	push af
	ld bc,#0404
	dec a
	call #bc32
	pop af
	dec a
	jr nz,MAIN_hide_loop

	;; --------------------
	;; WAIT FLYBACK
	call #bd19	
	;; --------------------
	;; SET SCR BASE #C000
	ld a,#c0
	call #bc08	
	;; --------------------
	;; SET SCR MODE 0
	ld a,#00
	call #bc0e	

;;#7e86
	IFDEF SKIP_DECOMPRESS
	;; --------------------
	;; Skip data deobfuscation and decompression
	;; --------------------
	jp LOAD_HSCORES
	ELSE
	;; --------------------
	;; Deobfuscate and decompress data
	;; --------------------
	ld hl,COMPRSD_DATA_ADDR	
	ENDIF

	ld bc,COMPRSD_DATA_LEN
;;#7e8c
MAIN_dobfuscate_loop:
	ld a,(hl)
	xor c
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,MAIN_dobfuscate_loop

	;; --------------------
	;; replace DRAW_BITMAP NXT_LINE function 
	;; by the kernel one (default screen width/height)
	;; --------------------
;;#7e95
	ld hl,#bc26
	ld (DRAW_ZBMP_nxt_line_fct),hl
	
	;; ''Decompress'' data to #C000
	ld hl,#c000
	ld de,#4268
	call DRAW_ZBMP

	;; --------------------
	;; move decompressed data to DATA_ADDR
	;; --------------------
	ld hl,#c000		
	ld de,DATA_ADDR
	ld b,#c6
;;#7eac
MAIN_cpy_loop1:
	push bc
	push hl
	ld c,#50
;;#7eb0
MAIN_cpy_loop2:
	ld a,(hl)
	ld (de),a
	inc de
	inc hl
	dec c
	jr nz,MAIN_cpy_loop2
	pop hl
	call #bc26	;; kernel NXT LINE
	pop bc
	djnz MAIN_cpy_loop1

	;; --------------------
	;; restore DRAW_BITMAP NXT_LINE function 
	;; for the modified screen width/height
	;; --------------------
	ld hl,NXT_SCR_LINE		
	ld (DRAW_ZBMP_nxt_line_fct),hl


	;; --------------------
	;; load high socres
	;; --------------------
;;#7ec4
LOAD_HSCORES:
	ld hl,HSCORE_FILE
	ld de,FILE_BUF
	ld b,#0a
	call #bc77		;; open file for input
	ld hl,HSCORES_TABLE	;; destination address
	call #bc83		;; read file
	call #bc7a		;; close file

;;#7ed8
LAYOUT_SCREEN:
	;; --------------------
	;; Configure CRTC - change screen width/height 
	;; --------------------
	;; BC01 -> #20		H DISPLAYED 32 characters
	;; BC02 -> #2A		H SYNC 42
	;; BC06 -> #20		V DISPLAYED 32
	;; BC07 -> #22		V SYNC 34
	ld b,#04

	ld hl,crtc_conf
;;#7edd
LAYOUT_SCREEN_crtc_loop:
	push bc
	ld bc,#00bc
	ld a,(hl)
	inc hl
	out (c),a
	inc b
	ld a,(hl)
	inc hl
	out (c),a
	pop bc
	djnz LAYOUT_SCREEN_crtc_loop

	;; --------------------
	;; Fill #C040 -> #FFFF with #C0
	;; using stack pointer''s push (thus going from #FFFF down to #C040)
	;; 255*32 words = 16320 bytes 
	;; --------------------
	ld (sp_tmp),sp
	ld sp,#0000
	ld hl,#c0c0
	ld b,#ff
;;#7ef9	
LAYOUT_SCREEN_fill_loop:
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	push hl
	djnz LAYOUT_SCREEN_fill_loop
	ld sp,(sp_tmp)	;; restore stack pointer.


	;; --------------------
	;; Draw game title
	;; --------------------
;;#7f1f
	ld hl,GAME_TITLE_SCR	;;#c000
	ld de,GAME_TITLE_ZBMP	
	call DRAW_ZBMP

	;; --------------------
	;; Draw box playground area 
	;; --------------------
	ld hl,#c168
	ld c,#14
	call BOX_TOP
	ld bc,PLAYGND_DIM
	call BOX_SIDES
	ld c,#14
	call BOX_BOTTOM

	;; --------------------
	;; Draw box in game score 
	;; --------------------
	ld hl,#c140
	ld c,#12
	call BOX_TOP
	ld bc,#2012
	call BOX_SIDES
	ld c,#12
	call BOX_BOTTOM

	;; --------------------
	;; Draw box next piece 
	;; --------------------
	ld hl,#c158
	ld c,#0a
	call BOX_TOP
	ld bc,#200a
	call BOX_SIDES
	ld c,#0a
	call BOX_BOTTOM

	;; --------------------
	;; Draw box players area
	;; --------------------
	ld hl,#e280
	ld c,#22
	call BOX_TOP
	ld bc,#2822
	call BOX_SIDES
	ld c,#22
	call BOX_BOTTOM

	;; --------------------
	;; Draw box animation/menu area
	;; --------------------
	ld hl,#c440
	ld c,#22
	call BOX_TOP
	ld bc,#7022
	call BOX_SIDES
	ld c,#22
	call BOX_BOTTOM

	;; --------------------
	;; Draw link pattern between next piece box and game box
	;; --------------------
	ld hl,#d966
	ld b,#22
	ld de,box_link_pattern
;;#7f8f	
LAYOUT_SCREEN_link_loop:
	push bc
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld (hl),a
	dec hl
	call NXT_SCR_LINE
	pop bc
	djnz LAYOUT_SCREEN_link_loop

	;; --------------------------------
	;; Set Game Border color	
	;; --------------------------------
	ld b,#04
	ld c,b
	call #bc38

	;; --------------------------------
	;; Set Game Palette color (0-14)
	;; --------------------------------
	ld hl,color_values
	ld a,#0f
;;#7fa7
LAYOUT_SCREEN_color_loop:
	push af
	dec a
	ld b,(hl)
	inc hl
	ld c,b
	push hl
	call #bc32
	pop hl
	pop af
	dec a
	jr nz,LAYOUT_SCREEN_color_loop

	;; --------------------------------
	;; Set flashing color (pen 15)
	;; --------------------------------
	ld a,#0f
	ld b,#01
	ld c,#1a
	call #bc32
	ld hl,#0303
	call #bc3e
	jp SETUP
;; Colors
;;#7fc7
color_values:	
	DB #1A,#13,#12,#09,#19,#18,#0F,#06
	DB #03,#10,#0B,#02,#01,#04,#00

;; CRTC registers config
;;#7fd6
crtc_conf:
	DB #01,#20,#02,#2A,#06,#20,#07,#22

;; Stack pointer backup
;;#7fde
sp_tmp 	
	DB #00,#00

;;#7fe0
box_link_pattern:
	DB #0C,#0C,#CC,#0C,#CC,#CC,#0C,#CC
	DB #CC,#CC,#CC,#CC,#CC,#30,#CC,#CC
	DB #30,#CC,#30,#30,#CC,#30,#30,#30
	DB #30,#30,#0C,#30,#30,#0C,#0C,#30
	DB #0C,#0C

;;#8002
SETUP:
	;; ----------------------------------------
	;; Configure flyback callbacks
	;; ----------------------------------------
	ld hl,FLBK_GAME_MELODY_BLOCK	;; frame flyback block - Manage game melody and speed
	ld de,FLBK_GAME_MELODY_ISR	;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM select address of the routine
	call #bcd7			;; init block
	ld hl,FLBK_GAME_MELODY_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_CLEAR_COMBO_BLOCK	;; frame flyback block - Clear combo text on screen
	ld de,FLBK_CLEAR_COMBO_ISR	;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM select address of the routine
	call #bcd7			;; init block
	ld hl,FLBK_CLEAR_COMBO_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_DANCE_BLOCK		;; frame flyback block - Kozak Dance
	ld de,FLBK_DANCE_ISR		;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM select address of the routine
	call #bcd7			;; init block
	ld hl,FLBK_DANCE_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_RNDM_BLCK_BLOCK	;; frame flyback block - Random blocks 
	ld de,FLBK_RNDM_BLCK_ISR	;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM select address of the routine
	call #bcd7			;; init block 
	ld hl,FLBK_RNDM_BLCK_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_MOVE_UP_BLOCK	;; frame flyback block - Move playground UP
	ld de,FLBK_MOVE_UP_ISR		;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM
	call #bcd7			;; init block 
	ld hl,FLBK_MOVE_UP_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_KAZATCHOK_BLOCK	;; frame flyback block - Kazatchok Melody
	ld de,FLBK_KAZATCHOK_ISR	;; event routine address
	ld bc,#8100			;; B= evt class | C= ROM
	call #bcd7			;; init block 
	ld hl,FLBK_KAZATCHOK_BLOCK
	call #bcdd			;; remove/disable block

	ld hl,FLBK_MENU_ANIM_BLOCK 	;; frame flyback block - Main menu animation
	ld de,FLBK_MENU_ANIM_ISR  	;; event routine address
	ld bc,#8100			;; B: evt class | C: ROM
	call #bcd7			;; init block 
	ld hl,FLBK_MENU_ANIM_BLOCK
	call #bcdd			;; remove/disable block

	;; ----------------------------------------
	;; Default rotation direction
	;; ----------------------------------------
	xor a
	ld (rot_reversed),a

	;; ----------------------------------------
	;; Disable KBD key repeat 
	;; ----------------------------------------
	ld a,#50
;;#8086
SETUP_kdb_dsbl:
	ld b,#00
	dec a
	push af
	call #bb39
	pop af
	jr nz,SETUP_kdb_dsbl

	;; ----------------------------------------
	;; Set KBD repeat delays
	;; ----------------------------------------
	ld hl,#0101
	call #bb3f

	;; ----------------------------------------
	;; Set KBD key mapping (normal and shift)
	;; ----------------------------------------
	ld hl,KBD_MAP	;;#73e3
	ld a,KBD_MAP_LEN 	;;#4e
;;#809b
SETUP_kbd_map:
	ld b,(hl)
	inc hl
	push hl
	dec a
	push af
	call #bb27
	pop af
	push af
	call #bb2d
	pop af
	pop hl
	jr nz,SETUP_kbd_map

	;; ----------------------------------------
	;; Clear offscreen playing area
	;; 20*210
	;; ----------------------------------------
	call CLEAR_PLAYGND_OFSCR

	;; ----------------------------------------
	;; Draw curtain
	;; ----------------------------------------
	ld hl,#e442
	ld b,#03
;;#80b4
SETUP_curt_loop:
	push bc
	push hl
	ld de,CURTAIN_BMP
	ld bc,#0822
	call DRAW_BMP

	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz SETUP_curt_loop

	;; ----------------------------------------
	;; Draw Player 1''s head
	;; ----------------------------------------
	ld hl,#e303
	ld de,P1_HEAD_BMP
	ld bc,#1405
	call DRAW_BMP

	;; ----------------------------------------
	;; Draw Player 2''s head
	;; ----------------------------------------
	ld hl,#c31e
	ld de,P2_HEAD_BMP
	ld bc,#1405
	call DRAW_BMP
;;#80de
START:
	ld a,(hscore_changed)
	dec a
	jr nz,MAIN_SCREEN
	ld (hscore_changed),a

	;; ----------------------------------------
	;; Save High Score file	
	;; ----------------------------------------
	ld b,#0a
	ld hl,HSCORE_FILE
	ld de,#1388
	call #bc8c
	ld hl,HSCORES_TABLE
	ld de,#004a
	ld bc,HSCORES_TABLE
	ld a,#05	;; Binary ''protected'', ie obfuscated using the AMSDOS 128bytes XOR key
	call #bc98
	call #bc8f
	jr MAIN_SCREEN
;;#8105
HSCORE_FILE:
	DB "ALINKA.TBL"

;;#810f
MAIN_SCREEN:
	call START_KAZATCHOK

	;; Display "DEFI  01"
	ld de,INFO_DEFI_STR	;;#7269
	ld hl,INFO_DEFI_SCR	;;#c183
	ld b,#08
	call DRW_TXT

	;; Display "LIGNE 00"
	ld hl,INFO_LINES_SCR;;	#c1c3
	ld b,#08
	call DRW_TXT

	;; Display "BONUS 000"
	ld hl,INFO_BONUS_SCR	;;#c202
	ld b,#09
	call DRW_TXT

	;; Display "SOUPIRANT 1"
	ld hl,SOUPIRANT_1_SCR	;;#c2c4
	ld b,#0b
	call DRW_TXT

	;; Display "00000"
	ld hl,SCORE1_SCR	;;#c30a
	ld b,#05
	call DRW_TXT

	;; Display "00000"
	ld hl,SCORE2_SCR	;;#c392
	ld b,#05
	call DRW_TXT

	;; Display "SOUPIRANT 2"
	ld hl,SOUPIRANT_2_SCR	;;#c3cc
	ld b,#0b
	call DRW_TXT

	;; Display "< ALINKA >"
	ld hl,ALINKA_SCR	;;#c509
	ld b,#0a
	call DRW_TXT

	;; Display "L''AMANT:"
	ld hl,L_AMANT_SCR1
	ld de,L_AMANT_STR
	ld b,#08
	call DRW_TXT

	;; Display "<Amant''s initiales and score>"
	ld hl,AMANT_SCR		;;#c1eb
	ld de,AMANT_NAME
	ld b,#09
	call DRW_WTXT

	;; Display "LES"
	ld hl,LES_SCR
	ld de,LES_STR
	ld b,#03
	call DRW_TXT

	;; Display "MEILLEURS"
	ld hl,MEILLEURS_SCR
	ld b,#09
	call DRW_TXT

	;; Display "SOUPIRANTS"
	ld hl,SOUPIRANTS_SCR
	ld b,#0a
	call DRW_TXT

	;; Display "<initiales 1>"
	ld hl,HSCORE1_SCR	;;#c3ab
	ld de,HSCORE1	;;#7210
	ld b,#03
	call DRW_TXT

	;; Display "<initiales 2>" 
	ld hl,HSCORE2_SCR	;;#c3eb
	ld de,HSCORE2
	ld b,#03
	call DRW_TXT

	;; Display "<initiales 3>" 
	ld hl,HSCORE3_SCR	;;#c42b
	ld de,HSCORE3
	ld b,#03
	call DRW_TXT

	;; Display "<initiales 4>" 
	ld hl,HSCORE4_SCR	;;#c46b
	ld de,HSCORE4
	ld b,#03
	call DRW_TXT

	;; Display "<initiales 5>" 
	ld hl,HSCORE5_SCR	;;#c4ab
	ld de,HSCORE5
	ld b,#03
	call DRW_TXT

	;; Enable high scores animation
	ld a,#03
	ld (menu_dur),a
	ld hl,FLBK_MENU_ANIM_BLOCK
	call #bcda

;; Display main menu
;;#81c8
MENU:	
	;; Display "1-  1 SOUPIRANT"
	ld de,MENU1_STR	;;#72ac
	ld hl,MENU1_SCR	;;#c583
	ld b,#10
	call DRW_TXT
	;; Display "2- 2 SOUPIRANTS"
	ld hl,MENU2_SCR	;;#c5c3
	ld b,#10
	call DRW_TXT
	;; Display "3- CHOIX DU DEFI"
	ld hl,MENU3_SCR	;;#c643
	ld b,#10
	call DRW_TXT
	;; Display "4- REDEFINIR LES"
	ld hl,MENU4_SCR1	;;#c683
	ld b,#10
	call DRW_TXT
	;; Display "TOUCHES"
	ld hl,MENU4_SCR2 	;;#c6cc
	ld b,#07
	call DRW_TXT
	;; Display "PROGRAMME  DE"
	ld hl,COPYRIGHT1_SCR	;;#c746
	ld b,#0d
	call DRW_TXT
	;; Display "ERIC BOUCHER"
	ld hl,COPYRIGHT2_SCR	;;#c786
	ld b,#0d
	call DRW_TXT
;;#8203
MENU_LOOP:	
	;; Read keyboard
	call #bb09
	jr nc,MENU_LOOP
	cp #31
	jp z,MENU_1
	cp #32
	jp z,MENU_2
	cp #33
	jr z,MENU_3
	cp #34
	jp z,MENU_4
	jr MENU_LOOP

;; -------------------
;; Menu 3 - Choix du defi
;; -------------------
;;#821d
MENU_3:
	ld hl,#c582
	ld bc,#3822
	call CLEAR_SCREEN_AREA
	;; Display "TES"
	ld hl,TES_SCR1	;;#c5c6
	ld de,TES_STR	;;#7358
	ld b,#03
	call DRW_TXT
	;; Display "INITIALES"
	inc hl
	inc hl
	ld b,#09
	call DRW_TXT
	;; Display "..."
	ld hl,DOTS_SCR1		;;#c610
	ld b,#03
	call DRW_TXT
;;#8240
MENU_3_letter1:
	ld de,custom_name
	ld hl,#c610
	call WAIT_KEY
	cp #7f		;; Check Delete key
	jr z,MENU_3_letter1
	ld (de),a	;; Store letter
	call DRW_CHAR
;;#8251
MENU_3_letter2:
	ld de,custom_name+1
	ld hl,#c612
	call WAIT_KEY
	cp #7f		;; Check Delete key
	jr z,MENU_3_letter1
	ld (de),a	;; Store letter
	call DRW_CHAR

	ld de,custom_name+2
	ld hl,#c614
	call WAIT_KEY
	cp #7f		;; Check Delete key
	jr z,MENU_3_letter2
	ld (de),a	;; Store letter
	call DRW_CHAR

	;; Display "DEFI NUMERO .."
	ld hl,DEFI_CHOICE_SCR	;;#c645
	ld de,DEFI_CHOICE_STR	;;#7251
	ld b,#0e
	call DRW_TXT
;;#827e	
MENU_3_defi1:
	ld de,start_levelX10	;; Current defi ten''s digit
	ld hl,#c65d
	call WAIT_KEY
	cp #7f		;; Check Delete key
	jr z,MENU_3_defi1
	cp #30		;; Check < ''0''
	jr c,MENU_3_defi1
	cp #3a
	jr nc,MENU_3_defi1	;; Check > ''9''
	push af
	call DRW_CHAR
	pop af
	or a
	sbc #2f
	ld (de),a	;; Store
;;#829c
MENU_3_defi2:
	ld de,start_levelX01	;; Current defi unit''s digit
	ld hl,#c65f
	call WAIT_KEY
	cp #7f		;; Check Delete key
	jr z,MENU_3_defi1
	cp #30		;; Check < ''0''
	jr c,MENU_3_defi2
	cp #3a		;; Check > ''9''
	jr nc,MENU_3_defi2
	push af
	call DRW_CHAR
	pop af
	or a
	sbc #2f
	ld (de),a	;; Store 
	
	;; Lookup name in high score table
	ld hl,HSCORE1
	ld b,#05
;;#82bf
MENU_3_check_custom_name:
	push bc
	ld de,custom_name
	ld b,#03
	push hl
;;#82c6
MENU_3_check_next:
	ld c,(hl)
	ld a,(de)
	cp c
	jp nz,MENU_3_invalid
	inc hl
	inc de
	djnz MENU_3_check_next
	;; Initiales FOUND
	;; Check level
	ld de,#0008
	add hl,de
	ld a,(start_levelX10)
	add #2f
	ld c,a
	ld a,(hl)
	cp c
	jp c,MENU_3_invalid
	jr nz,MENU_3_check_OK
	inc hl
	ld a,(start_levelX01)
	add #2f
	ld c,a
	ld a,(hl)
	cp c
	jp c,MENU_3_invalid
;;#82ed
MENU_3_check_OK:
	pop hl
	pop bc
	;; Display "OK"
	ld hl,OK_SCR	;;#c691
	ld de,OK_STR	;;#725f
	ld b,#02
	call DRW_TXT

	call DELAY

	ld hl,LEVEL_TABLE-7	;; <- level table ptr - 7
	ld a,(start_levelX10)
	dec a
	jr nz,MENU_3_level_X10
	ld a,(start_levelX01)
	dec a
	jr z,MENU_3_level_reset
	;; Offset level ptr += 70 * tens
;;#830c
MENU_3_level_X10:
	ld a,(start_levelX10)
;;#830f
MENU_3_x10_loop:
	dec a
	jr z,MENU_3_level_X01
	ld de,#0046
	add hl,de
	jr MENU_3_x10_loop

	;; Offset level ptr +=  7 * units
;;#8318
MENU_3_level_X01:
	ld a,(start_levelX01)
;;#831b
MENU_3_x01_loop:
	dec a
	jr z,MENU_3_level_done
	ld de,#0007
	add hl,de
	jr MENU_3_x01_loop

;;#8324
MENU_3_level_done:
	ld (start_level_ptr),hl

	ld hl,#c582
	ld bc,#3822
	call CLEAR_SCREEN_AREA
	;; Display level ten''s digit in menu
	ld hl,#c18f
	ld a,(start_levelX10)
	add #2f
	call DRW_CHAR
	;; Display level unit''s digit in menu
	ld a,(start_levelX01)
	add #2f
	call DRW_CHAR
	jp MENU

;;#8346
MENU_3_level_reset:	;; revert to level 01
	ld a,#01
	ld (start_levelX10),a
	inc a
	ld (start_levelX01),a
	ld hl,LEVEL_TABLE
	ld (start_level_ptr),hl
	ld hl,#c582
	ld bc,#3822
	call CLEAR_SCREEN_AREA
	ld hl,#c18f
	ld a,(start_levelX10)
	add #2f
	call DRW_CHAR
	ld a,(start_levelX01)
	add #2f
	call DRW_CHAR
	jp MENU

;;#8374
MENU_3_invalid:
	pop hl
	ld de,#000d
	add hl,de
	pop bc
	dec b
	jp nz,MENU_3_check_custom_name
	ld hl,INVALID_SCR	;;#c68b
	ld de,INVALID_STR	;;#7261
	ld b,#08
	call DRW_TXT
	call DELAY
	jr MENU_3_level_reset

;;#838e
custom_name:
	DB	#00,#00,#00

;; -------------------
;; Menu 4 - Redefinir les touches
;; -------------------
;;#8391
MENU_4:
	;; Clear MENU Area
	ld hl,#c582
	ld bc,#3822
	call CLEAR_SCREEN_AREA
	
	;; Display "DROITE:"
	ld hl,DROITE_SCR	;;#c58a
	ld de,DROITE_STR	;;#730d
	ld b,#07
	call DRW_TXT
	;; Read CHAR
	call #bb18
	;; Draw CHAR
	push af
	call DRW_CHAR
	pop af
	;; Get corresponding key code
	call GET_KEY_CODE

	;; Insert key code into playing routines
	ld (poke_key_right),a
	ld (key_right),a

	;; Display "GAUCHE:"
	ld hl,GAUCHE_SCR	;;#c5ca
	ld b,#07
	call DRW_TXT
	;; Read CHAR
	call #bb18
	;; Draw CHAR
	push af
	call DRW_CHAR
	pop af
	;; Get corresponding key code
	call GET_KEY_CODE
	;; Insert key code into playing routines
	ld (poke_key_left),a
	ld (key_left),a

	;; Display "ACCELERE:"
	ld hl,ACCELERE_SCR	;;#c608
	ld b,#09
	call DRW_TXT
	;; Read CHAR
	call #bb18
	;; Insert CHAR into routine ??
	ld (key_down),a
	;; Draw CHAR
	call DRW_CHAR

	;; Display "ROTATION:"
	ld hl,ROTATION_SCR	;;#c648
	ld b,#09
	call DRW_TXT
	;; Read CHAR
	call #bb18
	;; Insert CHAR into routine ??
	ld (key_rotate),a
	;; Draw CHAR
	call DRW_CHAR

	;; Clear MENU Area
	ld hl,#c582
	ld bc,#3822
	call CLEAR_SCREEN_AREA
	jp MENU

;;#83fd
MENU_1:
	xor a
	ld (p1_game_over),a
	inc a
	ld (p2_game_over),a
	ld a,(start_levelX10)
	cp #01
	jr nz,MENU_1_custom
	ld a,(start_levelX01)
	cp #02
	ld a,#00
	jr z,START_GAME
;;#8415
MENU_1_custom:
	ld a,#01	;; Indicate custom game (ie choosen level)
	jr START_GAME

;;#8419
custom_game:	
	DB #00		;; Whether the player choose a custom level (identified player)

;;#841a
MENU_2:
	ld a,#01
	ld (start_levelX10),a
	inc a
	ld (start_levelX01),a
	ld hl,#7487
	ld (start_level_ptr),hl
	xor a
	ld (p1_game_over),a
	ld (p2_game_over),a

;; -----------------------------------------
;; Start game
;; A: 1 for custom game, 0 otherwise
;; -----------------------------------------
;;#8430
START_GAME:
	;; a==0 -> new game    :level 0
	;; a!=0 -> resume game :custom level
	ld (custom_game),a
	;; Disable HSCORE flyback block 
	ld hl,FLBK_MENU_ANIM_BLOCK
	call #bcdd

	;; Clear playing area
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA

	call DANCEFLR_CURTAIN_DOWN

	;; Disable sound
	ld a,#0a
	ld c,#00
	call CFG_AY_SND
	call STOP_KAZATCHOK
	
	;; Setup level
	ld a,(start_levelX10)
	add #2f
	ld (#726f),a
	ld a,(start_levelX01)
	add #2f
	ld (#7270),a
	ld a,#01
	ld (p1_score_X00001),a
	ld (p2_score_X00001),a
	ld (p1_score_X00010),a
	ld (p2_score_X00010),a
	ld (p1_score_X00100),a
	ld (p2_score_X00100),a
	ld (p1_score_X01000),a
	ld (p2_score_X01000),a
	ld (p1_score_X10000),a
	ld (p2_score_X10000),a
;;#847f+1
start_level_ptr equ $ + 1
	ld hl,LEVEL_TABLE
	ld (p1_level_ptr),hl
	ld (p2_level_ptr),hl
;;#8488+1
start_levelX10 equ $ + 1
	ld a,#01
	ld (cur_level_X10),a
;;#848d+1	
start_levelX01 equ $ + 1
	ld a,#02
	ld (cur_level_X01),a
	jr START_LEVEL

;;#8494
NEXT_LEVEL:
	ld a,(cur_level_X01)
	inc a
	ld (cur_level_X01),a
	cp #0b
	jr nz,START_LEVEL
	ld a,#01
	ld (cur_level_X01),a
	ld a,(cur_level_X10)
	inc a
	ld (cur_level_X10),a

;;#84ab
START_LEVEL:
	ld a,(cur_level_X10)
	cp #04
	jr nz,START_LEVEL_player1
	ld a,(cur_level_X01)
	cp #03
	;; Last level ?? 31
	jp z,GAME_FINISHED

;;#84ba
START_LEVEL_player1:
	ld a,(p1_game_over)
	dec a
	jr z,START_LEVEL_player2
	jp PLAYER1
;;#84c3
START_LEVEL_player2:
	ld a,(p2_game_over)
	dec a
	jr z,NEXT_LEVEL
	jp PLAYER2

;;#84cc
PLAYER1:
	ld a,#01
	ld (cur_player),a
	ld hl,#c30a
	ld (cur_score_scr),hl
	ld hl,p1_score_X00001
	ld de,cur_score_X00001
	ld b,#05
;;#84df
PLAYER1_init_score:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz PLAYER1_init_score

	ld hl,(p1_level_ptr)
	ld (cur_level_ptr),hl
	ld de,SOUPIRANT1_STR
	
	call PLAY
	
	ld hl,(cur_level_ptr)
	ld a,(hl)
	inc hl
	ld (p1_level_ptr),hl
	dec a

	call z,DANCE_ANIMATION

	ld de,p1_score_X00001
	ld hl,cur_score_X00001
	ld b,#05
;;#8505
PLAYER1_store_score:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz PLAYER1_store_score

	call DISABLE_RNDM_BLCK
	call FLBK_MOVE_UP_DISABLE
	call SET_ROT_NORMAL
	call SET_DIR_NORMAL
	jp START_LEVEL_player2

;;#851a
PLAYER2:
	ld a,#02
	ld (cur_player),a
	ld hl,#c392
	ld (cur_score_scr),hl
	ld hl,cur_score_X00001
	ld de,p2_score_X00001
	ld b,#05
;;#852d
PLAYER2_init_score:
	ld a,(de)
	ld (hl),a
	inc de
	inc hl
	djnz PLAYER2_init_score

	ld hl,(p2_level_ptr)
	ld (cur_level_ptr),hl

	ld de,SOUPIRANT2_STR
	call PLAY

	ld hl,(cur_level_ptr)
	ld a,(hl)
	inc hl
	ld (p2_level_ptr),hl
	dec a
	call z,DANCE_ANIMATION

	ld de,p2_score_X00001
	ld hl,cur_score_X00001
	ld b,#05
;;#8553
PLAYER2_store_score:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz PLAYER2_store_score

	call DISABLE_RNDM_BLCK
	call FLBK_MOVE_UP_DISABLE
	call SET_ROT_NORMAL
	call SET_DIR_NORMAL
	jp NEXT_LEVEL

;;#8568
PLAY:
	push de
	call CLEAR_PLAYGND_OFSCR
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA
	call DRAW_POPUP_BOX
	pop de
	;; Draw "SOUPIRANT"
	ld hl,SOUPIRANT_SCR	;;#c3eb
	ld b,#09
	call DRW_TXT
	;; Skip space
	inc de
	;; Draw "1/2" depending on value of reg DE
	ld hl,SOUPIRANT_NUM_SCR	;;#c433
	ld b,#01
	call DRW_TXT
	;; Draw "PRET"
	ld hl,PRET_SCR 		;;#c470
	ld de,PRET_STR		;;#732d
	ld b,#04
	call DRW_TXT

	call DELAY
	
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA

	ld hl,(cur_level_ptr)		;; ptr = &level[0]
	ld de,cur_lignes_X10
	ld b,#02
;;#85a9
PLAY_copy_lignes:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz PLAY_copy_lignes

	ld (cur_level_ptr),hl		;; store ptr = &level[2]
	;; Draw "DEFI"
	ld de,DEFI2_STR		;;#73cf
	ld hl,DEFI2_SCR		;;#e36d
	ld b,#04
	call DRW_WTXT

	;; Draw Current LEVEL
	inc hl
	inc hl
	ld a,(cur_level_X10)
	add #2f
	call DRW_WCHAR
	ld a,(cur_level_X01)
	add #2f
	call DRW_WCHAR

	;; Draw NB LIGNES
	ld hl,LIGNES_SCR 	;;#e3eb
	ld a,(cur_lignes_X10)
	add #2f
	call DRW_WCHAR
	ld a,(cur_lignes_X01)
	add #2f
	call DRW_WCHAR

	;; Draw "LIGNES"
	inc hl
	inc hl
	ld b,#06
	call DRW_WTXT

	;; Draw "A"
	ld hl,A_SCR		;;#e473
	ld b,#01
	call DRW_WTXT

	;; Draw "COMPLETER"
	ld hl,COMPLETER_SCR	;;#e4eb
	ld b,#09
	call DRW_WTXT

	;; Display level info
	ld hl,#c18f
	ld a,(cur_level_X10)
	add #2f
	call DRW_CHAR
	ld a,(cur_level_X01)
	add #2f
	call DRW_CHAR

	ld hl,#c1cf
	ld a,(cur_lignes_X10)
	add #2f
	call DRW_CHAR
	ld a,(cur_lignes_X01)
	add #2f
	call DRW_CHAR

	call DELAY

	ld hl,(cur_level_ptr)	;; load ptr = &level[2] = speed ?
	ld a,(hl)
	ld (down_delay),a	;; set variable (accualy poke the value into instruction)

	;; Down delay : delay before automatic down move
	;; Move delay : laterral move repeat delay

	;; Update move delay based on down delay
	call ADAPT_MOVE_DELAY

	inc hl			;; ptr = &level[3]
	ld a,(hl)		;; 
	inc hl			;; ptr = &level[4]
	ld (cur_level_ptr),hl	;; <- store ptr = &level[4]

	push af
	bit 7,a			;; a.7 -> Random blocks
	call nz,ENABLE_RNDM_BLCK
	pop af
	push af
	bit 6,a			;; a.6 -> Playground move up
	call nz,FLBK_MOVE_UP_ENABLE
	pop af
	push af
	bit 5,a			;; a.5 -> Piece rotation inverted
	call nz,SET_ROT_REVERSED
	pop af
	bit 4,a			;; a.4 -> direction reversed 
	call nz,SET_DIR_REVERSED

	ld hl,(cur_level_ptr)	;; ptr = &level[4]
	push hl
	ld e,(hl)		;; e = level[4]
	inc hl			
	ld d,(hl)		;; d = level[5]
	inc hl			;; <-- useless (probably)
	call SETUP_PLAYGROUND_MASK
	pop hl

	ld e,(hl)		;; e = level[4]
	inc hl			;; 
	ld d,(hl)		;; d = level[5]
	inc hl			;; ptr = &level[6]
	ld (cur_level_ptr),hl 	;; store current ptr = &level[6]
	call SETUP_PLAYGND_OFSCR

	;; Draw playground
	ld hl,PLAYGND_SCR
	ld de,PLAYGND_OFSCR
	ld bc,PLAYGND_DIM
	call DRAW_BMP

	;; Get first piece
	call GET_RNDM_PIECE
	
	;; Draw it
	ld hl,(nxt_piece_prz_pos)
	ld de,(nxt_piece_cur_bmp)
	ld bc,(nxt_piece_cur_dim)
	call DRAW_BMP
	
	call DELAY

	call PLAY_LEVEL

	;; Level terminated
	;;

	call DELAY
	
	ld hl,#c34a
	ld bc,#0812
	call CLEAR_SCREEN_AREA
	
	ld hl,#e15a
	ld bc,#200a
	call CLEAR_SCREEN_AREA
	
	call DRAW_POPUP_BOX
	;; Draw "DAMNED !!"
	ld hl,DAMNED_SCR	;;#c3eb
	ld de,DAMNED_STR	;;#7343
	ld b,#09
	call DRW_TXT
	;; Draw "DEFI"
	ld hl,DEFI_SCR 		;;#c430
	ld b,#04
	call DRW_TXT
	;; Draw "REMPORTE"
	ld hl,REMPORTE_SCR	;;#c46c
	ld b,#08
	call DRW_TXT

	call DELAY

	call DRAW_POPUP_BOX
	;; Draw "BONUS"
	ld hl,#c3ef
	ld de,#7279
	ld b,#05
	call DRW_TXT
	;; Draw "MAESTRIA"
	ld hl,MAESTRIA_SCR 	;;#c42c
	ld de,MAESTRIA_STR	;;#7397
	ld b,#08
	call DRW_TXT

	call DELAY

	call BONUS_MAESTRIA
	jp DELAY

;;#86dd
BONUS_MAESTRIA:
	ld hl,PLAYGND_SCR
	ld de,PLAYGND_OFSCR
	ld bc,PLAYGND_DIM
	call DRAW_BMP

	;; Setup initial bonus value: 400
	ld a,#05
	ld (cur_bonus_X100),a
	ld a,#01
	ld (cur_bonus_X010),a
	ld (cur_bonus_X001),a
	ld hl,#c1aa
	ld bc,#1014
	call CLEAR_SCREEN_AREA
	jp BONUS_MAESTRIA_not_empty

;;#8702
BONUS_MAESTRIA_next:
	;; Display current bonus value
	ld hl,#c20e
	ld a,(cur_bonus_X100)
	add #2f
	call DRW_CHAR
	ld a,(cur_bonus_X010)
	add #2f
	call DRW_CHAR
	ld a,(cur_bonus_X001)
	add #2f
	call DRW_CHAR
	
	;; Check last line of mask playground 
	;; to determine if it''s empty
	ld hl,#3ddf
	ld b,#0a
;;#8722
BONUS_MAESTRIA_check1:
	ld a,(hl)
	inc hl
	inc hl
	cp #00
	jp nz,BONUS_MAESTRIA_not_empty
	djnz BONUS_MAESTRIA_check1

	;; Line is empty
	;; Bonus computation is finished.
	;; Draw flame ???
	ld de,FLAME3_BMP
	ld bc,PLAYGND_LINE_DIM
	ld hl,PLAYGND_BOTTOM_LINE_SCR
	call DRAW_BMP

	;; Delay
	ld b,#64
;;#873a
BONUS_MAESTRIA_delay11:
	ld c,#64
;;#873c
BONUS_MAESTRIA_delay12:
	dec c
	jr nz,BONUS_MAESTRIA_delay12
	djnz BONUS_MAESTRIA_delay11

	;; Clear line
	ld hl,PLAYGND_BOTTOM_LINE_SCR
	ld bc,PLAYGND_LINE_DIM
	call CLEAR_SCREEN_AREA

	call DELAY

;;#874d
BONUS_MAESTRIA_decrease:
	ld a,(cur_bonus_X001)
	dec a
	ld (cur_bonus_X001),a

	jr nz,BONUS_MAESTRIA_display
	ld a,#0a
	ld (cur_bonus_X001),a
	ld a,(cur_bonus_X010)
	dec a
	ld (cur_bonus_X010),a
	jr nz,BONUS_MAESTRIA_display
	ld a,#0a
	ld (cur_bonus_X010),a
	ld a,(cur_bonus_X100)
	dec a
	ld (cur_bonus_X100),a
	jr nz,BONUS_MAESTRIA_display
	
	ld a,#01
	ld (cur_bonus_X100),a
	ld (cur_bonus_X010),a
	ld (cur_bonus_X001),a
;;#877d
BONUS_MAESTRIA_display:
	push af
	ld hl,#c20e
	ld a,(cur_bonus_X100)
	add #2f
	call DRW_CHAR
	ld a,(cur_bonus_X010)
	add #2f
	call DRW_CHAR
	ld a,(cur_bonus_X001)
	add #2f
	call DRW_CHAR
	
	ld b,#01
	call SCORE_ADD_UNITS
	
	pop af
	jr nz,BONUS_MAESTRIA_decrease
	ret
;;#87a2
BONUS_MAESTRIA_not_empty:
	ld hl,PLAYGND_BOTTOM_LINE_SCR
	ld de,FLAME1_BMP
	ld bc,PLAYGND_LINE_DIM
	call DRAW_BMP

	ld b,#64
;;#87b0
BONUS_MAESTRIA_delay21:
	ld c,#96
;;#87b2
BONUS_MAESTRIA_delay22:
	dec c
	jr nz,BONUS_MAESTRIA_delay22
	djnz BONUS_MAESTRIA_delay21

	;; Move offscreen playground 1 line down
	;;ld hl,#3e93	;; probably a bug - should be #3e92
	;;ld de,#3df3	;; probably a bug - should be #3df2
	ld hl,PLAYGND_OFSCR+4160	;;(26*8*20)	;; should substract 1 to be at the end of line
	ld de,PLAYGND_OFSCR+4000	;;(25*8*20)	;; should substract 1 to be at the end of line

	ld b,#c8
;;#87bf
BONUS_MAESTRIA_move_h:
	ld c,#14
;;#87c1
BONUS_MAESTRIA_move_w:
	ld a,(de)
	ld (hl),a
	dec de
	dec hl
	dec c
	jr nz,BONUS_MAESTRIA_move_w
	djnz BONUS_MAESTRIA_move_h

	;; Explosion sound !!
	ld a,#06
	ld c,#1e
	call CFG_AY_SND
	ld a,#07
	ld c,#37
	call CFG_AY_SND
	ld a,#08
	ld c,#10
	call CFG_AY_SND
	ld a,#0b
	ld c,#a0
	call CFG_AY_SND
	ld a,#0c
	ld c,#0f
	call CFG_AY_SND
	ld a,#0d
	ld c,#09
	call CFG_AY_SND


	;; Draw playground (starting 2 lines below the top and ending 1 line before the bottom)
	ld hl,PLAYGND_SCR+128		;;(2*64)	;;#e1ea	top minus 2 ''char'' screen lines 
	ld de,PLAYGND_OFSCR+320		;;(2*8*20) 	;;#2f93	top minus 2*8 bitmap lines 
	ld bc,PLAYGND_DIM-#1800  	;;#b814  height minus 3*8 lines 
	call DRAW_BMP

	;; Draw burning line 
	ld hl,PLAYGND_BOTTOM_LINE_SCR;; #e7aa
	ld de,FLAME2_BMP	
	ld bc,PLAYGND_LINE_DIM
	call DRAW_BMP

	;; Delay
	ld b,#64
;;#880e
BONUS_MAESTRIA_delay31:
	ld c,#c8
;;#8810
BONUS_MAESTRIA_delay32:
	dec c
	jr nz,BONUS_MAESTRIA_delay32
	djnz BONUS_MAESTRIA_delay31

	;; Decrease maestria bonus
	or a
	ld a,(cur_bonus_X010)
	sbc #02
	ld (cur_bonus_X010),a
	jr nc,BONUS_MAESTRIA_cont
	add #0a
	ld (cur_bonus_X010),a
	ld a,(cur_bonus_X100)
	dec a
	ld (cur_bonus_X100),a
	jr nz,BONUS_MAESTRIA_cont
	ld a,#01
	ld (cur_bonus_X100),a
	ld (cur_bonus_X010),a
;;#8836
BONUS_MAESTRIA_cont:
	jp BONUS_MAESTRIA_next

;;#8839
PLAY_LEVEL:
	ld a,(key_down)		;;
	call GET_KEY_CODE	;;
	ld b,#ff		;;
	call #bb39		;; Set down key repeat allowed

	ld hl,GAME_MELODY
	ld (melody_ptr),hl
	ld a,#01
	ld (melody_dur),a
	ld hl,FLBK_GAME_MELODY_BLOCK
	call #bcda

	ld a,#07
	ld c,#30
	call CFG_AY_SND
	ld a,#0a
	ld c,#0a
	call CFG_AY_SND
	
	;; highest_line_idx = 0
	xor a			
	ld (playgnd_top_idx),a		

;;#8867
NEXT_PIECE:
	;; Move next piece info to current piece info
	ld hl,piece_src_pos
	ld de,nxt_piece_scr_pos
	ld b,#1c
;;#886f
NEXT_PIECE_copy:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	djnz NEXT_PIECE_copy

	;; Get the next piece
	call GET_RNDM_PIECE

	;; TODO Clarify
	ld hl,#2ef9			;; reset offscreen1 start address ??
	ld (piece_cur_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call DRAW_MASK_BMP_OFFSCREEN1

	ld hl,(piece_src_pos)
	ld de,(piece_cur_bmp_pos)
	ld bc,(piece_dim)
	call DRAW_BMP_SYNC

	ld hl,(nxt_piece_prz_pos)
	ld de,(nxt_piece_cur_bmp)
	ld bc,(nxt_piece_cur_dim)
	call DRAW_BMP
	
	;; Add 3 points
	ld b,#03
	call SCORE_ADD_UNITS

	ld bc,#61a8	;; delay loop
;;#88ad
NEXT_PIECE_delay:
	dec bc
	ld a,b
	or c
	jr nz,NEXT_PIECE_delay

	ld hl,#3ebf
	ld (piece_cur_msk_pos),hl
	
	ld a,#01
	ld (move_cnt),a
	
	ld a,#1a			;; 26
	ld (piece_top_idx),a		;; line idx of the bottom of the piece

	ld hl,PIECE_MASK_BOTTOM_START  	;; mask playground bottom of piece line address
	ld (piece_msk_bottom),hl	;; increased by 12 (#0c) every move down

	ld hl,PIECE_SCR_BOTTOM_START	;; scr playground bottom of piece line address
	ld (piece_scr_bottom),hl	;; increased by 64 (#40) every move down

	ld hl,PIECE_BMP_BOTTOM_START	;; bmp playground bottom of piece line address
	ld (piece_bmp_bottom),hl	;; increased by 160 (#a0) move down

	ld a,NB_BMP_LINES_START		;; initial number of lines from the bitmap playgraound''s top
	ld (nb_bmp_lines),a		;; increased by 8 every move down

	ld a,NB_MSK_LINES_START		;; initial number of lines from the mask playgraound''s top
	ld (nb_msk_lines),a		;; increased by on every move down

;;#88de
KEY_LOOP:
	ld a,(move_cnt)
	dec a
	jr z,KEY_LOOP_allow_move

	ld hl,CHECK_LOOP
	jr KEY_LOOP_cont
;;#88e9
KEY_LOOP_allow_move:
	ld hl,CHECK_MOVE
;;#88ec
KEY_LOOP_cont:
	ld (check1),hl

	ld hl,CHECK_LOOP
	ld (check2),hl
;;#88f5+1
down_delay equ $ + 1
	ld a,#32
	ld (down_cnt),a

;;#88fa
CHECK_LOOP:
	xor a
	call #bb1b
	push af
;;#88ff+1
key_rotate equ $ + 1
	cp #20
	call z,ROTATE
	pop af
;;#8805+1
key_down equ $ + 1
	cp #0a
	jp z,MOVE_DOWN
;;#880a+1
check1 equ $ + 1
	jp CHECK_MOVE

;; Check lateral moves
;;#880d
CHECK_MOVE:
;;#880d+1
poke_key_left equ $ + 1
	ld a,#08
	call #bb1e
	jp nz,MOVE_LEFT

;;#8815+1
poke_key_right equ $ + 1
	ld a,#01		
	call #bb1e		
	jp nz,MOVE_RIGHT
;;#881d+1
check2 equ $ + 1
	jp CHECK_LOOP		

;;#8920
KEY_CONT:
;;#8920+1
move_delay equ $ + 1
	ld a,#0c
	ld (move_cnt),a
	ld hl,CHECK_LOOP
	ld (check1),hl
	jp CHECK_LOOP

;;#892e
MOVE_DOWN:
	;; Increase score on explicit user''s down move
	ld b,#01
	call SCORE_ADD_UNITS
;;#8933
FALL:
	ld hl,(piece_cur_msk_pos)
	ld bc,#000c
	add hl,bc
	ld (piece_prv_msk_pos),hl
	ld bc,(miece_msk_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,LAND
	ld bc,(piece_msk_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,LAND
	ld bc,(piece_msk_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,LAND
	ld bc,(piece_msk_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,LAND
	ld hl,(piece_prv_msk_pos)
	ld (piece_cur_msk_pos),hl
	
	ld hl,(piece_src_pos)
	ld (piece_prv_scr_pos),hl
	ld bc,#0040
	add hl,bc
	ld (piece_src_pos),hl

	ld hl,(piece_cur_bmp_pos)
	ld (piece_prv_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call CLEAR_MASK_BMP_OFFSCREEN1
	ld hl,(piece_cur_bmp_pos)
	ld bc,#00a0
	add hl,bc
	ld (piece_cur_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call DRAW_MASK_BMP_OFFSCREEN1
	
	;; draw offscreen playground
	;; from previous pos to an extended height (one more line)
	;; This will clear the piece from it previous position 
	;; and display it at its new position.
	ld hl,(piece_prv_scr_pos)
	ld de,(piece_prv_bmp_pos)
	ld bc,(piece_dim)
	ld a,#08
	add b
	ld b,a
	call DRAW_BMP_SYNC
	
	;; (piece_top_idx) = (piece_top_idx)-1
	ld a,(piece_top_idx)
	dec a
	ld (piece_top_idx),a
	
	;; (piece_scr_bottom) = (piece_scr_bottom)+#40
	ld hl,(piece_scr_bottom)
	ld bc,#0040
	add hl,bc
	ld (piece_scr_bottom),hl

	;; (piece_msk_bottom) = (piece_msk_bottom) + #0c
	ld hl,(piece_msk_bottom)
	ld bc,#000c
	add hl,bc
	ld (piece_msk_bottom),hl

	;; (piece_bmp_bottom) = (piece_bmp_bottom) + #a0
	ld hl,(piece_bmp_bottom)
	ld bc,#00a0
	add hl,bc
	ld (piece_bmp_bottom),hl

	;; (nb_msk_lines) = (nb_msk_lines) + 1
	ld a,(nb_msk_lines)
	inc a
	ld (nb_msk_lines),a

	;; (nb_bmp_lines) = (nb_bmp_lines) + #08
	ld a,(nb_bmp_lines)
	ld b,#08
	add b
	ld (nb_bmp_lines),a

	jp KEY_LOOP

;;#89ec
LAND:

	ld d,LANDUP_SOUND_LEN
	ld hl,landup_sound
;;#89f1
LAND_sound:
	ld c,(hl)
	inc hl
	ld a,(hl)
	inc hl
	call CFG_AY_SND
	dec d
	jr nz,LAND_sound
	
	;; Delay
	ld b,#00
;;#89fb
LAND_delay1:
	ld c,#28
;;#89ff
LAND_delay2:
	dec c
	jr nz,LAND_delay2
	djnz LAND_delay1

	;; -----------------------------
	;; Piece landed
	;; Insert piece''s blocks into playground mask 
;;#8a04
	ld hl,(piece_cur_msk_pos)
	ld bc,(miece_msk_B1)
	add hl,bc
	ld (hl),#01		;; set playground mask value to for piece''s block1
	ld bc,(piece_msk_B2)
	add hl,bc
	ld (hl),#01		;; set playground mask value to for piece''s block2
	ld bc,(piece_msk_B3)
	add hl,bc
	ld (hl),#01		;; set playground mask value to for piece''s block3
	ld bc,(piece_msk_B4)
	add hl,bc
	ld (hl),#01		;; set playground mask value to for piece''s block4
	ld hl,COMBO_STR_TBL		
	ld (combo_str),hl	;; init combo string pointer to "------  50"
	
	ld a,#00
	ld (combo_lines),a

	ld a,#d2		;; Initial bliblibliiip pitch
	ld (blibliblip_pitch),a

	;; -----------------------------
	;; Stop land up Sound
;;#8a33
	ld a,#00
	ld c,#00
	call CFG_AY_SND
	ld a,#06
	ld c,#00
	call CFG_AY_SND
	ld a,#07
	ld c,#38
	call CFG_AY_SND
	ld a,#08
	ld c,#00
	call CFG_AY_SND

	;; -----------------------------
	;; Check for completed lines
	ld b,#04	;; <- max number of possible completed lines
;;#8a51
COMPLETED_LINE:
	push bc

	ld hl,(piece_msk_bottom) ;; <- current piece bottom playground mask''s line 
	ld c,#0c	 	 ;; line width (1+10+1)
;;#8957
COMPLETED_LINE_nxt_blk:
	ld a,(hl)
	cp #01
	jp nz,UNCOMPLETED_LINE
	dec hl
	dec c
	jr nz,COMPLETED_LINE_nxt_blk

	;; -----------------------------
	;; Draw burning flame 1
;;#8a61
	ld de,FLAME1_BMP	;; <- flame1 bitmap 20x8 
	ld hl,(piece_scr_bottom)	;; <- must be screen playground line''s start address
	ld bc,PLAYGND_LINE_DIM
	call DRAW_BMP	

	;; -----------------------------
	;; Delay
	ld b,#64
;;#896f
COMPLETED_LINE_delay11:
	ld c,#64
;;#8971
COMPLETED_LINE_delay12:
	dec c
	jr nz,COMPLETED_LINE_delay12
	djnz COMPLETED_LINE_delay11

	;; -----------------------------
	;; Move playground''s bitmap one line down, 
	;; starting at the removed bitmap line address
;;#8a76
	or a
	ld hl,(piece_bmp_bottom)
	ld de,(piece_bmp_bottom)	;; Current line bitmap playground start address
	ld bc,#ff60	;; -160
	add hl,bc
	ld a,(nb_bmp_lines)	;; <- number of pixel lines to top of playground''s bitmap 
	ld b,a
;;#8a86
COMPLETED_LINE_move1_h:
	ld c,#14
;;#8a88
COMPLETED_LINE_move1_w:
	ld a,(hl)
	dec hl
	ld (de),a
	dec de
	dec c
	jr nz,COMPLETED_LINE_move1_w
	djnz COMPLETED_LINE_move1_h

	;; -----------------------------
	;; Move playground''s mask one line down, 
	;; starting at the removed mask line address
;;#8a91
	ld hl,(piece_msk_bottom)
	ld de,(piece_msk_bottom)
	ld bc,#fff4	;; -12
	add hl,bc
	ld a,(nb_msk_lines)	;; <- number of lines to top of playground''s mask 
	ld b,a
;;#8aa0
COMPLETED_LINE_move2_h:
	ld c,#0c
;;#8aa2
COMPLETED_LINE_move2_w:
	ld a,(hl)
	dec hl
	ld (de),a
	dec de
	dec c
	jr nz,COMPLETED_LINE_move2_w
	djnz COMPLETED_LINE_move2_h


	;; -----------------------------
	;; Draw burning flame 2
;;#8aab
	ld de,FLAME2_BMP	;; flame2 bitmap 20x8
	ld hl,(piece_scr_bottom)	;; <- must be screen playground line''s start address
	ld bc,PLAYGND_LINE_DIM
	call DRAW_BMP

	;; -----------------------------
	;; Delay
	ld b,#64
;;#8ab9
COMPLETED_LINE_delay21:
	ld c,#64
;;#8abb
COMPLETED_LINE_delay22:
	dec c
	jr nz,COMPLETED_LINE_delay22
	djnz COMPLETED_LINE_delay21

	;; -----------------------------------
	;; Rebuild the top and bottom shadow/lighting of the cutted pieces
	;; -----------------------------------
	;; Top inner lighting of the lower pieces
;;#8ac0
	or a
	ld hl,(piece_bmp_bottom)
	ld bc,#0028
	add hl,bc
	ld b,#14
;;#8aca
COMPLETED_LINE_lgt1:
	ld a,(hl)
	cp #00
	jr z,COMPLETED_LINE_l1_nxt
	and #55
	cp #04
	jr nz,COMPLETED_LINE_l1_rplc
	xor #2a
	jr COMPLETED_LINE_l1_nxt
;;#8ad9
COMPLETED_LINE_l1_rplc:
	ld a,#3f
;;#8adb
COMPLETED_LINE_l1_nxt:
	ld (hl),a
	dec hl
	djnz COMPLETED_LINE_lgt1

	;; -----------------------------------
	;; Top outer lighting of the lower pieces
	ld b,#14
;;#8ae1
COMPLETED_LINE_lgt2:
	ld a,(hl)
	cp #00
	jr z,COMPLETED_LINE_l2_nxt
	ld (hl),#3f
;;#8ae8
COMPLETED_LINE_l2_nxt:
	dec hl
	djnz COMPLETED_LINE_lgt2

	;; -----------------------------------
	;; Bottom outer lighting of the upper pieces
	ld b,#14
;;#8aed
COMPLETED_LINE_shdw1:
	ld a,(hl)
	cp #00
	jr z,COMPLETED_LINE_s1_nxt
	ld (hl),#0c
;;#8af4
COMPLETED_LINE_s1_nxt:
	dec hl
	djnz COMPLETED_LINE_shdw1

	;; -----------------------------------
	;; Bottom inner lighting of the upper pieces
	ld b,#14
;;#8af9
COMPLETED_LINE_shdw2:
	ld a,(hl)
	cp #00
	jr z,COMPLETED_LINE_s2_nxt
	and #aa
	cp #2a
	jr nz,COMPLETED_LINE_s2_rplc
	xor #04
	jr COMPLETED_LINE_s2_nxt
;;#8b08
COMPLETED_LINE_s2_rplc:
	ld a,#0c
;;#8b0a
COMPLETED_LINE_s2_nxt:
	ld (hl),a
	dec hl
	djnz COMPLETED_LINE_shdw2

	;; -----------------------------
	;; Draw burning flame 3 (which is identical to flame 2 ??? mistake ???)
;;#8b0e
	ld de,FLAME3_BMP
	ld hl,(piece_scr_bottom)
	ld bc,PLAYGND_LINE_DIM
	call DRAW_BMP

	;; ----------------------------
	;; Delay
	ld b,#64
;;#8b1c
COMPLETED_LINE_delay31:
	ld c,#64
;;#8b1e
COMPLETED_LINE_delay32:
	dec c
	jr nz,COMPLETED_LINE_delay32
	djnz COMPLETED_LINE_delay31


	;; -----------------------------
	;; Fully redraw rebuild playground bitmap
	ld hl,PLAYGND_SCR
	ld de,PLAYGND_OFSCR
	ld bc,PLAYGND_DIM
	call DRAW_BMP

	;; ----------------------------
	;; Play the bliblibliip with increasing pitch
	ld d,#03
;;#8b31
COMPLETED_LINE_play_blip:
	or a
	ld a,(blibliblip_pitch)
	ld b,#1e
	sbc b
	ld (blibliblip_pitch),a
	ld c,a
	ld a,#00
	call #bd34
	ld a,#08
	ld c,#0f
	call #bd34

	;; ----------------------------
	;; Delay
	ld b,#00
;;#8b4a
COMPLETED_LINE_delay41:
	ld c,#14
;;#8b4c
COMPLETED_LINE_delay42:
	dec c
	jr nz,COMPLETED_LINE_delay42
	djnz COMPLETED_LINE_delay41

	;; ----------------------------
	;; Cut sound off ??
	ld a,#08
	ld c,#00
	call #bd34
	
	;; ----------------------------
	;; Delay
	ld b,#00
;;#8b5a
COMPLETED_LINE_delay51:
	ld c,#1e
;;#8b5c
COMPLETED_LINE_delay52:
	dec c
	jr nz,COMPLETED_LINE_delay52
	djnz COMPLETED_LINE_delay51

	dec d
	jr nz,COMPLETED_LINE_play_blip

	;; ----------------------------
	;; Cut sound off ??
	ld a,#08
	ld c,#00
	call #bd34

	;; ----------------------------
	;; Decrease pitch a bit for next completed line
	ld a,(blibliblip_pitch)
	ld b,#32
	add b
	ld (blibliblip_pitch),a


	;; ----------------------------
	;; Enable XXX flyback
	ld a,#49
	ld (clear_combo_cnt),a
	ld hl,FLBK_CLEAR_COMBO_BLOCK
	call #bcda

	;; ----------------------------
	;; Increase falling speed (decrease delay)
	ld a,(down_delay)
	dec a
	jr z,COMPLETED_LINE_cont1
	ld (down_delay),a
	;; ----------------------------
	;; Adjust left-right move''s repeat delay
	call ADAPT_MOVE_DELAY
;;#8b8b
COMPLETED_LINE_cont1:
	;; ----------------------------
	;; Draw current combo string 
	ld b,#0a
	ld hl,COMBO_SCR		;;#c349
	ld de,(combo_str)
	call DRW_TXT
	ld (combo_str),de

	;; ----------------------------
	;; Adjust some game variables ...

	ld a,(combo_lines)
	inc a
	ld (combo_lines),a

	ld a,(piece_top_idx)
	dec a
	ld (piece_top_idx),a

	ld a,(playgnd_top_idx)
	dec a
	ld (playgnd_top_idx),a

	;; ----------------------------
	;; Decrease remaining lines
	ld a,(cur_lignes_X01)
	dec a
	ld (cur_lignes_X01),a
	jr nz,COMPLETED_LINE_cont2
	ld a,#0a
	ld (cur_lignes_X01),a

	ld a,(cur_lignes_X10)
	dec a
	ld (cur_lignes_X10),a
	jr nz,COMPLETED_LINE_cont2

	ld a,#01		;; (reminder: digits are offseted by 1. Why? I certainly had a good reason :-) )
	ld (cur_lignes_X10),a	;; 0 remaining lines 
	ld (cur_lignes_X01),a	;; 0 remaining lines

;;#8bcf
COMPLETED_LINE_cont2:
	;; ----------------------------
	;; Display remaining lines
	ld hl,#c1cf
	ld a,(cur_lignes_X10)
	add #2f
	call DRW_CHAR
	ld a,(cur_lignes_X01)
	add #2f
	call DRW_CHAR

;;#8be2
NXT_COMPLETED_LINE:
	pop bc
	dec b
	jp nz,COMPLETED_LINE

;;#8be7
COMBO_COUNT:
	ld a,(combo_lines)
	cp #00
	jr z,COMBO_COUNT_cont_combo

	cp #01
	jr nz,COMBO_COUNT_combo2

	;; One line -> 50 points
	ld b,#05
	call SCORE_ADD_TENS
	jr COMBO_COUNT_cont_combo
;;#8bf9
COMBO_COUNT_combo2:
	cp #02
	jr nz,COMBO_COUNT_combo3

	;; Two lines -> 100 points
	ld b,#01
	jr COMBO_COUNT_add_combo
;;#8c01
COMBO_COUNT_combo3:
	cp #03
	jr nz,COMBO_COUNT_combo4
	;; Three lines -> 200 points
	ld b,#02
	jr COMBO_COUNT_add_combo
;;#8c09
COMBO_COUNT_combo4:
	;; Four lines -> 400 points
	ld b,#04
;;#8c0b
COMBO_COUNT_add_combo:
	call SCORE_ADD_HDRDS
;;#8c0e
COMBO_COUNT_cont_combo:

	ld a,(cur_lignes_X01)
	dec a
	ld b,a
	ld a,(cur_lignes_X10)
	dec a
	or b
	jr z,LEVEL_COMPLETED	;; All requested lines completed

;;#8c1a
HEIGHT_CHECK:
	;; highest_line_idx = max((highest_line_idx), (piece_top_idx) )
	ld a,(piece_top_idx)
	ld b,a
	ld a,(playgnd_top_idx)
	sbc b
	jp nc,HEIGHT_CHECK_max
	or a
	ld a,(piece_top_idx)
	ld (playgnd_top_idx),a
;;#8c2c
HEIGHT_CHECK_max:
	ld a,(playgnd_top_idx)
	cp #18
	jr nc,GAME_OVER

;;#8c33
TRICKS:
	;; Insert random block if necessary
	ld a,(rndm_blck_cnt)
	dec a
	call z,INSERT_RNDM_BLCK

	;; Move playground up if necessary
	ld a,(move_up_cnt)
	dec a
	call z,PLAYGROUND_MOVE_UP

	jp NEXT_PIECE

;;#8c44
UNCOMPLETED_LINE:
	;; Update variables
	ld hl,(piece_scr_bottom)
	ld bc,#ffc0
	add hl,bc
	ld (piece_scr_bottom),hl
	ld hl,(piece_bmp_bottom)
	ld bc,#ff60
	add hl,bc
	ld (piece_bmp_bottom),hl
	ld hl,(piece_msk_bottom)
	ld bc,#fff4
	add hl,bc
	ld (piece_msk_bottom),hl
	ld a,(nb_msk_lines)
	dec a
	ld (nb_msk_lines),a
	ld a,(nb_bmp_lines)
	ld b,#f8
	add b
	ld (nb_bmp_lines),a
	jp NXT_COMPLETED_LINE

;;#8c75
LEVEL_COMPLETED:
	ld a,(key_down)
	call GET_KEY_CODE
	ld b,#00
	call #bb39	;; Disable down KEY repeat

	ld hl,FLBK_GAME_MELODY_BLOCK
	call #bcdd	;; Disable Flyback block
	
	ld hl,(melody_ptr)	;; Load note address
	ld a,(hl)	;; load note
	ld c,a		;; c = note

	ld b,#32	
;;#8c8d
LEVEL_COMPLETED_loop:	
	push bc		
	ld a,#04	
	call CFG_AY_SND	;; | play note
	
	ld bc,#07d0
;;#8c96
LEVEL_COMPLETED_delay:
	dec bc
	ld a,b
	or c
	jr nz,LEVEL_COMPLETED_delay

	pop bc
	dec c
	djnz LEVEL_COMPLETED_loop

	ld a,#0a	;; Sound
	ld c,#00	;; |
	jp CFG_AY_SND	;; OFF

;;#8ca6
GAME_OVER:
	ld a,(key_down)
	call GET_KEY_CODE
	ld b,#00	
	call #bb39	;; Disable KEY repeat
	ld hl,FLBK_GAME_MELODY_BLOCK
	call #bcdd	;; Disable Flyback block

	call DISABLE_RNDM_BLCK
	call FLBK_MOVE_UP_DISABLE
	call SET_ROT_NORMAL
	call SET_DIR_NORMAL

	ld hl,(melody_ptr)	;; Load note address
	ld a,(hl)	;; load note
	ld c,a

	ld b,#32
;;#8cca:
GAME_OVER_loop1:
	push bc
	ld a,#04	;; |
	call CFG_AY_SND
	
	ld bc,#07d0
;;#8cd3:	
GAME_OVER_loop2:
	dec bc
	ld a,b
	or c
	jr nz,GAME_OVER_loop2
	
	pop bc
	inc c
	djnz GAME_OVER_loop1

	ld a,#0a	;; sound
	ld c,#00	;; |
	call CFG_AY_SND	;; OFF

	pop hl		;;
	ld a,(cur_player);;|
	dec a		;; |
	jr z,GAME_OVER_player1
	
	ld (p2_game_over),a	;; <- PLAYER 2 GAME OVER
	jr GAME_OVER_cont

;;#8cef
GAME_OVER_player1:
	inc a		
	ld (p1_game_over),a	;; <- PLAYER 1 GAME OVER

;;#8cf3
GAME_OVER_cont:
	call DRAW_POPUP_BOX
	;; Draw "SOUPIRANT"
	ld hl,#c3eb
	ld de,SOUPIRANT1_STR
	ld b,#09
	call DRW_TXT
	;; Draw "<current player>"
	ld hl,#c433
	ld a,(cur_player)
	add #30
	call DRW_CHAR
	;; Draw "Dommage"
	ld hl,DOMMAGE_SCR	;;#c46d
	ld de,DOMMAGE_STR	;;#7331
	ld b,#07
	call DRW_TXT

	call DELAY
	call DRAW_POPUP_BOX
	;; Draw "TU AS"
	ld hl,TU_AS_SCR		;;#c3ef
	ld de,TU_AS_STR		;;#7338
	ld b,#05
	call DRW_TXT
	;; Draw "ECHOUE"
	ld hl,ECHOUE_SCR	;;#c42e
	ld de,ECHOUE_STR	;;#733d
	ld b,#06
	call DRW_WTXT

	call DELAY
	call CHECK_HIGH_SCORE

	ld a,(p1_game_over)
	dec a
	ld b,a
	ld a,(p2_game_over)
	dec a
	or b
	ret nz 		;; Still 1 player alive

	;; GAME OVER
	pop hl
	ld hl,#e15a
	ld bc,#200a
	call CLEAR_SCREEN_AREA
	call CLEAR_PLAYGND_OFSCR
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA
	call DANCEFLR_CURTAIN_UP
	jp START
;;#8d60
melody_ptr:
	DB #00
	DB #00
;;#8d62
melody_dur:
	DB #00
;;#8d63
FLBK_GAME_MELODY_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; Rom Block
	DW #0000	;; User (not used)
	DB #00,#00,#00,#00,#00	;; Extra (useless)
;;#8d71
move_cnt:
	DB #00
;;#8d72
down_cnt:
	DB #00

	DB #00		;; unused

;; ----------------------------
;; Manage in game melody
;; lateral move repeat delay and automatic move down
;; ----------------------------
;; #8d74
FLBK_GAME_MELODY_ISR:
	di
	push af
	push hl
	push bc
	ld a,(melody_dur)
	dec a
	jr nz,FLBK_GAME_MELODY_ISR_cont
	ld hl,(melody_ptr)
;;#8d81
FLBK_GAME_MELODY_ISR_next:
	ld a,(hl)
	inc a
	jr nz,FLBK_GAME_MELODY_ISR_play
	ld hl,GAME_MELODY
	ld (melody_ptr),hl
	jr FLBK_GAME_MELODY_ISR_next
;;#8d8d
FLBK_GAME_MELODY_ISR_play:
	inc hl
	ld (melody_ptr),hl
	dec a
	ld c,a
	ld a,#04
	call CFG_AY_SND
	ld a,#0a
	ld c,#0a
	call CFG_AY_SND
	ld a,#09
;;#8da1
FLBK_GAME_MELODY_ISR_cont:
	ld (melody_dur),a

	ld a,(move_cnt)
	dec a
	jp z,FLBK_GAME_MELODY_ISR_action1
	ld (move_cnt),a
;;#8dae
FLBK_GAME_MELODY_ISR_cont1:
	ld a,(down_cnt)
	dec a
	jp z,FLBK_GAME_MELODY_ISR_action2
	ld (down_cnt),a
;;#8db8
FLBK_GAME_MELODY_ISR_cont2:
	pop bc
	pop hl
	pop af
	ei
	ret
;;#8dbd
FLBK_GAME_MELODY_ISR_action2:
	ld hl,FALL		;; Action 2
	ld (check1),hl		;; force fall 
	ld (check2),hl		;; force fall 
	jr FLBK_GAME_MELODY_ISR_cont2
;;#8dc8
FLBK_GAME_MELODY_ISR_action1:			;; Action 1: 
	ld hl,CHECK_MOVE	;; left-right repeat delay
	ld (check1),hl		;; Allow lateral move
	jr FLBK_GAME_MELODY_ISR_cont1
;;#8dd0
FLBK_CLEAR_COMBO_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; ROM Block
	DW #0000	;; User (not used)
	DB #00,#00,#00,#00,#00	;; Extra (useless)
;;#8dde
clear_combo_cnt:
	DB #00

;;#8ddf
FLBK_CLEAR_COMBO_ISR:
	di
	push hl
	push af
	push de
	push bc
	ld a,(clear_combo_cnt)
	dec a
	ld (clear_combo_cnt),a
	jr nz,FLBK_CLEAR_COMBO_ISR_cont
	ld hl,COMBO_SCR
	ld bc,COMBO_DIM		;;#0814
	call CLEAR_SCREEN_AREA
	ld hl,FLBK_CLEAR_COMBO_BLOCK
	call #bcdd
;;#8dfc
FLBK_CLEAR_COMBO_ISR_cont:
	pop bc
	pop de
	pop af
	pop hl
	ei
	ret


;; --------------------------------------------------------
;; Rotate piece
;; --------------------------------------------------------
;;#8e02
ROTATE:
	ld hl,(piece_cur_bmp_pos)
	ld (piece_prv_bmp_pos),hl
	ld hl,(piece_src_pos)
	ld (piece_prv_scr_pos),hl
	ld hl,(piece_dim)
	ld (piece_prv_dim),hl
	ld hl,(piece_bmp)
	ld (piece_prv_bmp),hl
	ld hl,(piece_cur_msk_pos)
	ld (piece_prv_msk_pos),hl
	ld bc,(piece_rot_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_left
	ld bc,(piece_rot_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_left
	ld bc,(piece_rot_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_left
	ld bc,(piece_rot_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_left
	jp ROTATE_valid
;;#8e4b
ROTATE_try_left:
	;; Try moving piece one step left
	ld hl,(piece_cur_msk_pos)
	dec hl
	ld (piece_prv_msk_pos),hl
	ld bc,(piece_rot_B1)
	ld bc,(piece_rot_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,ROTATE_try_right
	ld bc,(piece_rot_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_right
	ld bc,(piece_rot_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_right
	ld bc,(piece_rot_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_try_right
	ld hl,(piece_cur_bmp_pos)
	dec hl
	dec hl
	ld (piece_cur_bmp_pos),hl
	ld hl,(piece_src_pos)
	dec hl
	dec hl
	ld (piece_src_pos),hl
	jp ROTATE_valid
;;#8e92
ROTATE_try_right:
	;; Try moving piece one step left
	ld hl,(piece_cur_msk_pos)
	inc hl
	ld (piece_prv_msk_pos),hl
	ld bc,(piece_rot_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,ROTATE_cont
	ld bc,(piece_rot_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_cont
	ld bc,(piece_rot_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_cont
	ld bc,(piece_rot_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_cont
	ld hl,(piece_cur_bmp_pos)
	inc hl
	inc hl
	ld (piece_cur_bmp_pos),hl
	ld hl,(piece_src_pos)
	inc hl
	inc hl
	ld (piece_src_pos),hl
	jp ROTATE_valid
;;#8ed5
ROTATE_cont:
	ld hl,(piece_cur_msk_pos)
	dec hl
	dec hl
	ld (piece_prv_msk_pos),hl
	ld bc,(piece_rot_B1)
	ld bc,(piece_rot_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	ret nz
	ld bc,(piece_rot_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	ret nz
	ld bc,(piece_rot_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	ret nz
	ld bc,(piece_rot_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jr nz,ROTATE_cont

	ld hl,(piece_cur_bmp_pos)
	dec hl
	dec hl
	dec hl
	dec hl
	ld (piece_cur_bmp_pos),hl
	ld hl,(piece_src_pos)
	dec hl
	dec hl
	dec hl
	dec hl
	ld (piece_src_pos),hl
;;#8f1a
ROTATE_valid:
	ld hl,(piece_prv_msk_pos)
	ld (piece_cur_msk_pos),hl
	ld hl,(piece_prv_bmp_pos)
	ld de,(piece_prv_bmp)
	ld bc,(piece_prv_dim)
	call CLEAR_MASK_BMP_OFFSCREEN1
	ld hl,(piece_rot_bmp)
	ld de,piece_bmp
	ld b,#1a
;;#8f36
ROTATE_loop:
	ld a,(hl)
	inc hl
	ld (de),a
	inc de
	djnz ROTATE_loop
	ld de,(piece_rot_bmp_ofst)
	ld hl,(piece_cur_bmp_pos)
	add hl,de
	ld (piece_cur_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call DRAW_MASK_BMP_OFFSCREEN1
	ld hl,(piece_prv_scr_pos)
	ld de,(piece_prv_bmp)
	ld bc,(piece_prv_dim)
	call DRAW_MASK_BMP
	ld hl,(piece_src_pos)
	ld de,(piece_rot_scr_ofst)
	add hl,de
	ld (piece_src_pos),hl
	ld de,(piece_cur_bmp_pos)
	ld bc,(piece_dim)
	jp DRAW_BMP_SYNC

;; --------------------------------------------------------
;; Move piece left
;; --------------------------------------------------------
;;#8f76
MOVE_LEFT:
	;; Check if move is possible
	ld hl,(piece_cur_msk_pos)
	dec hl				;; move 1 cell left
	ld (piece_prv_msk_pos),hl
	ld bc,(miece_msk_B1)		;; Check if the piece block1 
	add hl,bc			;; hits something
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT			;; Move impossible -> abort
	ld bc,(piece_msk_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld bc,(piece_msk_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld bc,(piece_msk_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld hl,(piece_prv_msk_pos)
	ld (piece_cur_msk_pos),hl
	ld hl,(piece_cur_bmp_pos)
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call CLEAR_MASK_BMP_OFFSCREEN1
	ld hl,(piece_cur_bmp_pos)
	dec hl
	dec hl
	ld (piece_cur_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call DRAW_MASK_BMP_OFFSCREEN1
	ld hl,(piece_src_pos)
	dec hl
	dec hl
	ld (piece_src_pos),hl
	ld de,(piece_cur_bmp_pos)
	ld bc,(piece_dim)
	inc c
	inc c
	call DRAW_BMP_SYNC
	jp KEY_CONT

;; --------------------------------------------------------
;; Move piece right
;; --------------------------------------------------------
;;#8fe8
MOVE_RIGHT:
	ld hl,(piece_cur_msk_pos)
	inc hl
	ld (piece_prv_msk_pos),hl
	ld bc,(miece_msk_B1)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld bc,(piece_msk_B2)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld bc,(piece_msk_B3)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld bc,(piece_msk_B4)
	add hl,bc
	ld a,(hl)
	cp #00
	jp nz,KEY_CONT
	ld hl,(piece_prv_msk_pos)
	ld (piece_cur_msk_pos),hl
	ld hl,(piece_cur_bmp_pos)
	ld (piece_prv_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call CLEAR_MASK_BMP_OFFSCREEN1
	ld hl,(piece_prv_bmp_pos)
	inc hl
	inc hl
	ld (piece_cur_bmp_pos),hl
	ld de,(piece_bmp)
	ld bc,(piece_dim)
	call DRAW_MASK_BMP_OFFSCREEN1
	ld hl,(piece_src_pos)
	ld (piece_prv_scr_pos),hl
	inc hl
	inc hl
	ld (piece_src_pos),hl
	ld hl,(piece_prv_scr_pos)
	ld de,(piece_prv_bmp_pos)
	ld bc,(piece_dim)
	inc c
	inc c
	call DRAW_BMP_SYNC
	jp KEY_CONT

;; --------------------------------------------------------
;; Adapt in-game move repeat''s delay (left-right) according to falling speed
;; --------------------------------------------------------
;;#9063
ADAPT_MOVE_DELAY:
	ld a,(down_delay)
	cp #03
	jr nc,ADAPT_MOVE_DELAY_nxt1
	ld a,#04
	ld (move_delay),a
	ret
;;#9070
ADAPT_MOVE_DELAY_nxt1:
	cp #05
	jr nc,ADAPT_MOVE_DELAY_nxt2
	ld a,#08
	ld (move_delay),a
	ret
;;#907a
ADAPT_MOVE_DELAY_nxt2:
	cp #07
	jr nc,ADAPT_MOVE_DELAY_nxt3
	ld a,#09
	ld (move_delay),a
	ret
;;#9084
ADAPT_MOVE_DELAY_nxt3:
	ld a,#0c
	ld (move_delay),a
	ret

;;#908a
menu_info:
	DB #00	;; Either <score> or <level>
;;#908b
menu_dur:
	DB #00

;;#908c
FLBK_MENU_ANIM_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; ROM Block
	DW #0000	;; User	(not used)
	DB #00		;; Extra (useless)

;; -----------------------------------------------
;; Main menu animation Flyback ISR
;; -----------------------------------------------
;;#9096
FLBK_MENU_ANIM_ISR:
	push af
	push bc
	push de
	push hl
	ld a,(menu_dur)
	dec a
	jr nz,FLBK_MENU_ANIM_ISR_cont
	ld (menu_dur),a
	ld a,(menu_info)
	dec a
	jr nz,FLBK_MENU_ANIM_ISR_hscore_levels
	;; Display "<score 1>"
	ld hl,HSCORE1_SCR+8		;;#c3b3		
	ld de,HSCORE1+3
	ld b,#05
	call DRW_TXT
	;; Display "<score 2>"
	ld hl,HSCORE2_SCR+8		;;#c3f3
	ld de,HSCORE2+3
	ld b,#05
	call DRW_TXT
	;; Display "<score 3>"
	ld hl,HSCORE3_SCR+8		;;#c433
	ld de,HSCORE3+3
	ld b,#05
	call DRW_TXT
	;; Display "<score 4>"
	ld hl,HSCORE4_SCR+8		;;#c473
	ld de,HSCORE4+3
	ld b,#05
	call DRW_TXT
	;; Display "<score 5>"
	ld hl,HSCORE5_SCR+8		;;#c4b3
	ld de,HSCORE5+3
	ld b,#05
	call DRW_TXT
	ld (menu_info),a  ;; a!=0
	
	;; Display "Kazatchok Dancer"
	ld hl,KOZAK_DANCER_SCR		;;#e4ea
	ld de,KOZAK_DANCER_ZBMP
	call DRAW_ZBMP
	xor a
;;#90ed
FLBK_MENU_ANIM_ISR_cont:
	ld (menu_dur),a
	pop hl
	pop de
	pop bc
	pop af
	ret
;;#90f5
FLBK_MENU_ANIM_ISR_hscore_levels:
	ld a,#01
	ld (menu_info),a
	;; Display "<level 1>"
	ld hl,HSCORE1_SCR+8		;;#c3b3
	ld de,HSCORE1+8			;;#7218
	ld b,#05
	call DRW_TXT
	;; Display "<level 2>"
	ld hl,HSCORE2_SCR+8		;;#c3f3
	ld de,HSCORE2+8			;;#7225
	ld b,#05
	call DRW_TXT
	;; Display "<level 3>"
	ld hl,HSCORE3_SCR+8		;;#c433
	ld de,HSCORE3+8			;;#7232
	ld b,#05
	call DRW_TXT
	;; Display "<level 4>"
	ld hl,HSCORE4_SCR+8		;;#c473
	ld de,HSCORE4+8			;;#723f
	ld b,#05
	call DRW_TXT
	;; Display "<level 5>"
	ld hl,HSCORE5_SCR+8		;;#c4b3
	ld de,HSCORE5+8			;;#724c
	ld b,#05
	call DRW_TXT
	
	;; Display "Alinka''s head"
	ld hl,ALINKA_HEAD_SCR		;;#e4ea
	ld de,ALINKA_HEAD_ZBMP
	call DRAW_ZBMP
	xor a
	jr FLBK_MENU_ANIM_ISR_cont

;; ------------------------------------------
;; Didn''t beat the Amant
;; ------------------------------------------
;; #913d
NEW_AMANT_MISSED:
	call DRAW_POPUP_BOX
	;; Draw "SOUPIRANT"
	ld hl,#c3eb
	ld de,SOUPIRANT1_STR
	ld b,#09
	call DRW_TXT

	;; Draw "<cur_player>"
	ld hl,#c433
	ld a,(cur_player)
	add #30
	call DRW_CHAR

	;; Draw "BRAVO"
	ld hl,BRAVO_SCR	;;#c46f
	ld de,BRAVO_STR	;;#7367
	ld b,#05
	call DRW_TXT

	call DELAY
	call DRAW_POPUP_BOX

	;; Draw "MAIS"
	ld hl,MAIS_SCR 		;;#c3f0
	ld de,MAIS_STR		;;#738b
	ld b,#04
	call DRW_TXT

	;; Draw "TU N''AS"
	ld hl,TU_N_AS_SCR 	;;#c42d
	ld de,TU_N_AS_STR	;;#7381
	ld b,#07
	call DRW_TXT

	;; Draw "PAS"
	ld hl,PAS_SCR 	;;#c471
	ld de,PAS_STR	;;#7388
	ld b,#03
	call DRW_TXT

	call DELAY
	call DRAW_POPUP_BOX

	;; Draw "LE TITRE"
	ld hl,LE_TITRE_SCR	;;#c3ec
	ld de,LE_TITRE_STR	;;#7377
	ld b,#08
	call DRW_TXT

	;; Draw "D''"
	ld hl,D_SCR 	;;#c42d
	ld de,D_STR	;;#737f
	ld b,#02
	call DRW_WTXT

	;; Draw "AMANT"
	ld de,L_AMANT_STR+2	;;#71eb
	ld b,#05
	call DRW_WTXT
	call DELAY
	jp CHECK_HIGH_SCORE

;; ------------------------------------------
;; Game finished. (31 levels)
;; ------------------------------------------
;;#91b2
GAME_FINISHED:
	ld a,(key_down)
	call GET_KEY_CODE
	ld b,#00
	call #bb39		;; Disable CHAR repeat
	
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA
	
	call DANCE_ANIMATION
	
	call START_KAZATCHOK
	
	ld a,(p1_game_over)
	dec a
	jr z,P2_FINISHED		;; P1 is GAME OVER
	
	ld a,(p2_game_over)
	dec a
	jr z,P1_FINISHED		;; P2 is GAME OVER
	
	;; -----------------------
	;; Compare player''s scores
	;; -----------------------
	ld hl,p1_score_X10000
	ld de,p2_score_X10000
	ld b,#05
;;#91e0
GAME_FINISHED_cmp_next:
	ld c,(hl)
	ld a,(de)
	cp c
	jr nz,GAME_FINISHED_cmp_diff
	dec hl
	dec de
	djnz GAME_FINISHED_cmp_next
	jr P1_WINS
;;#91eb
GAME_FINISHED_cmp_diff:
	jr nc,P2_WINS


;; ------------------------------------------
;; Player 1 beats player 2
;; ------------------------------------------
;;#91ed
P1_WINS:
	;; Process P2 first
	ld a,#02
	ld (cur_player),a
	ld hl,cur_score_X00001
	ld de,p2_score_X00001
	ld b,#05
;;#91fa
P1_WINS_cpy_P2_score:
	ld a,(de)
	ld (hl),a
	inc hl
	inc de
	djnz P1_WINS_cpy_P2_score

	call NEW_AMANT_MISSED		;; Game finished but doesn''t beat the Amant

;; ------------------------------------------
;; Player 1 finished the game
;; ------------------------------------------
;;#9203
P1_FINISHED:
	ld a,#01
	ld (cur_player),a
	ld hl,cur_score_X00001
	ld de,p1_score_X00001
	ld b,#05
;;#9210
P1_FINISHED_cpy_score:
	ld a,(de)
	ld (hl),a
	inc de
	inc hl
	djnz P1_FINISHED_cpy_score
	jp CHECK_NEW_AMANT

;; ------------------------------------------
;; Player 2 beats player 1
;; ------------------------------------------
;;#9219
P2_WINS:
	;; Process P1 first.
	ld a,#01
	ld (cur_player),a
	ld hl,cur_score_X00001
	ld de,p1_score_X00001
	ld b,#05
;;#9226
P2_WINS_cpy_score:
	ld a,(de)
	ld (hl),a
	inc de
	inc hl
	djnz P2_WINS_cpy_score
	call NEW_AMANT_MISSED 		;; Game finished but doesn''t beat the Amant

;; ------------------------------------------
;; Player 2 finished the game
;; ------------------------------------------
;;#922f
P2_FINISHED:
	ld a,#02
	ld (cur_player),a
	ld hl,cur_score_X00001
	ld de,p2_score_X00001
	ld b,#05
;;#923c
P2_FINISHED_copy:
	ld a,(de)
	ld (hl),a
	inc de
	inc hl
	djnz P2_FINISHED_copy

;; ------------------------------------------
;; Check if the player beats the Amant''s score
;; ------------------------------------------
;;#9242
CHECK_NEW_AMANT:
	ld hl,cur_score_X10000
	ld de,AMANT_SCORE 	;; #720b  -> best score
	ld b,#05
;;#924a
CHECK_NEW_AMANT_cmp_score:
	ld a,(hl)
	add #2f
	ld c,a
	ld a,(de)
	cp c
	jr nz,CHECK_NEW_AMANT_cmp_diff
	dec hl
	inc de
	djnz CHECK_NEW_AMANT_cmp_score
	jr NEW_AMANT_WIN
;;#9258
CHECK_NEW_AMANT_cmp_diff:
	jr c,NEW_AMANT_WIN
	call NEW_AMANT_MISSED
	jp NEW_AMANT_WIN_finished

;; ------------------------------------------
;; Called when a player beats the Amant''s score
;; ------------------------------------------
;;#9260
NEW_AMANT_WIN:
	call DRAW_POPUP_BOX
	;; Darw "BRAVO"
	ld hl,#c3ef
	ld de,#7367
	ld b,#05
	call DRW_TXT
	;; Draw "SOUPIRANT"
	ld de,SOUPIRANT1_STR
	ld hl,#c42b
	ld b,#09
	call DRW_TXT
	;; Draw "<current player>"
	ld a,(cur_player)
	add #30
	ld hl,#c473
	call DRW_CHAR

	call DELAY

	call DRAW_POPUP_BOX
	;; Draw "TU ES"
	ld hl,TU_ES_SCR	;;#c3ef
	ld de,TU_ES_STR	;;#736c
	ld b,#05
	call DRW_TXT
	;; Draw "DEVENU"
	ld hl,DEVENU_SCR	;;#c42e
	ld b,#06
	call DRW_TXT

	call DELAY

	call DRAW_POPUP_BOX
	;; Draw "L''AMANT"
	ld hl,L_AMANT_SCR2
	ld de,L_AMANT_STR
	ld b,#07
	call DRW_WTXT

	;; Draw "EN TITRE"
	ld hl,EN_TITRE_SCR 	;;#c46c
	ld de,EN_TITRE_STR	;;#738f
	ld b,#08
	call DRW_TXT

	call DELAY

	call DRAW_POPUP_BOX
	;; Draw "TES"
	ld hl,TES_SCR2		;;#c3f1
	ld de,TES_STR		;;#7358
	ld b,#03
	;; Draw "INITIALES"
	call DRW_TXT
	ld hl,INITIALES_SCR2	;;#c42b
	ld b,#09
	call DRW_TXT
	;; Draw "..."
	ld hl,DOTS_SCR2		;;#c471
	ld b,#03
	call DRW_TXT

	;; Update Amant
	ld de,AMANT_NAME
	ld a,(custom_game)
	dec a
	jr z,NEW_AMANT_WIN_use_custom_name
	call #bb18
;;#92e6
NEW_AMANT_WIN_initiale1:
	dec de
	ld hl,#c471
	call WAIT_KEY
	inc de
	cp #7f		;; delete key
	jr z,NEW_AMANT_WIN_initiale1
	ld (de),a
	call DRW_CHAR
	inc de
;;#92f7
NEW_AMANT_WIN_initiale2:
	dec de
	ld hl,#c473
	call WAIT_KEY
	cp #7f		;; delete key
	jr z,NEW_AMANT_WIN_initiale1
	inc de
	ld (de),a
	call DRW_CHAR
	ld hl,#c475
	call WAIT_KEY
	cp #7f		;; delete key
	jr z,NEW_AMANT_WIN_initiale2
	inc de
	ld (de),a
	inc de
	call DRW_CHAR
;;#9317
NEW_AMANT_WIN_update_score:
	ld a,#01
	ld (hscore_changed),a
	
	;; Update Amant
	inc de
	ld hl,cur_score_X10000
	ld b,#05
;;#9322
NEW_AMANT_WIN_cpy_score:
	ld a,(hl)
	add #2f
	ld (de),a
	inc de
	dec hl
	djnz NEW_AMANT_WIN_cpy_score
	
	ld b,#05
	ld de,HSCORE1
;;#932f
NEW_AMANT_WIN_check_soupirants:
	push bc
	push de
	inc de
	inc de
	inc de
	ld hl,cur_score_X10000
	ld b,#05
;;#9339
NEW_AMANT_WIN_check_nxt:
	ld a,(hl)
	add #2f
	ld c,a
	ld a,(de)
	cp c
	jr nz,NEW_AMANT_WIN_check_score
	inc de
	dec hl
	djnz NEW_AMANT_WIN_check_nxt
;;#9345
NEW_AMANT_WIN_check_cont:
	pop de
	ld hl,#000d
	add hl,de
	ex de,hl
	pop bc
	djnz NEW_AMANT_WIN_check_soupirants
;;#934e
NEW_AMANT_WIN_finished:
	ld hl,PLAYGND_SCR
	ld bc,PLAYGND_DIM
	call CLEAR_SCREEN_AREA
	call CLEAR_PLAYGND_OFSCR
	call DANCEFLR_CURTAIN_UP
	jp START

;;#9360
NEW_AMANT_WIN_use_custom_name:
	ld hl,custom_name
	ld b,#03
;;#9365
NEW_AMANT_WIN_custom_next:
	ld a,(hl)
	ld (de),a
	inc de
	inc hl
	djnz NEW_AMANT_WIN_custom_next
	call DISPLAY_CUSTOM_NAME
	jp NEW_AMANT_WIN_update_score

;;#9371
NEW_AMANT_WIN_check_score:
	jr nc,NEW_AMANT_WIN_check_cont	;; Score is smaller
	;; Score is bigger
	pop de
	pop bc
	push de
	;; Insert entry in table
	;; Move remaining entries by 1 down.
	ld hl,HSCORES_TABLE_END-1 	;;#7250
	ld de,HSCORES_TABLE_END-14 	;;#7243
;;#937c
NEW_AMANT_WIN_entry_next:
	ld c,#0d
;;#937e
NEW_AMANT_WIN_entry_move:
	ld a,(de)
	ld (hl),a
	dec hl
	dec de
	dec c
	jr nz,NEW_AMANT_WIN_entry_move
	djnz NEW_AMANT_WIN_entry_next

	pop de
	ld hl,AMANT_NAME
	ld b,#03
;;#938d
NEW_AMANT_WIN_copy_name:
	ld a,(hl)
	ld (de),a
	inc de
	inc hl
	djnz NEW_AMANT_WIN_copy_name
	inc hl
	ld b,#05
;;#9396
NEW_AMANT_WIN_copy_score:
	ld a,(hl)
	ld (de),a
	inc de
	inc hl
	djnz NEW_AMANT_WIN_copy_score
	ld a,#2e
	ld (de),a
	inc de
	ld (de),a
	inc de
	ld (de),a
	inc de
	ld a,(cur_level_X10)
	add #2f
	ld (de),a
	inc de
	ld a,(cur_level_X01)
	add #2f
	ld (de),a
	jp NEW_AMANT_WIN_finished

;; ---------------------------------------
;; Check if current player''s score is a high score
;; ---------------------------------------
;;#93b4
CHECK_HIGH_SCORE:
	ld b,#05		;; nb of high score table''s entry.
	ld de,HSCORE1
;;#93b9
CHECK_HIGH_SCORE_check_entry:
	push bc
	push de
	inc de
	inc de
	inc de
	ld hl,cur_score_X10000
	ld b,#05
;;#93c3
CHECK_HIGH_SCORE_cmp_score:
	ld a,(hl)
	add #2f
	ld c,a
	ld a,(de)
	cp c
	jr nz,CHECK_HIGH_SCORE_cmp_diff
	inc de
	dec hl
	djnz CHECK_HIGH_SCORE_cmp_score
;;#93cf
CHECK_HIGH_SCORE_check_next:
	pop de
	ld hl,#000d
	add hl,de
	ex de,hl
	pop bc
	djnz CHECK_HIGH_SCORE_check_entry
	ret
;;#93d9
CHECK_HIGH_SCORE_cmp_diff:
	jr nc,CHECK_HIGH_SCORE_check_next
	;; New High Score
	;; Insert entry 
	pop de
	pop bc  		;; b = nb remaining entries
	push de
	ld de,HSCORES_TABLE_END-1 	;;#7250
	ld hl,HSCORES_TABLE_END-14 	;;#7243
;;#93e4
CHECK_HIGH_SCORE_move_next:
	ld c,#0d
;;#93e6
CHECK_HIGH_SCORE_move_entry:
	ld a,(hl)
	ld (de),a
	dec de
	dec hl
	dec c
	jr nz,CHECK_HIGH_SCORE_move_entry
	djnz CHECK_HIGH_SCORE_move_next


	call DRAW_POPUP_BOX

	;; Draw "TES"
	ld hl,TES_SCR2		;;#c3f1
	ld de,TES_STR		;;#7358
	ld b,#03
	call DRW_TXT
	;; Draw "INITIALES"
	ld hl,INITIALES_SCR2	;;#c42b
	ld b,#09
	call DRW_TXT
	;; Draw "..."
	ld hl,DOTS_SCR2		;;#c471
	ld b,#03
	call DRW_TXT

	ld a,(key_down)
	call GET_KEY_CODE
	ld b,#00	
	call #bb39	;; Disable KBD repeat
	
	pop de
	ld a,(custom_game)
	dec a
	jr z,CHECK_HIGH_SCORE_insert_custom_name

	call #bb18	;; Wait KEY
;;#9422
CHECK_HIGH_SCORE_initiale1:
	dec de
	ld hl,#c471
	call WAIT_KEY
	inc de
	cp #7f
	jr z,CHECK_HIGH_SCORE_initiale1
	ld (de),a
	call DRW_CHAR
	inc de
;;#9433
CHECK_HIGH_SCORE_initiale2:
	dec de
	ld hl,#c473
	call WAIT_KEY
	cp #7f
	jr z,CHECK_HIGH_SCORE_initiale1
	inc de
	ld (de),a
	call DRW_CHAR
	ld hl,#c475
	call WAIT_KEY
	cp #7f
	jr z,CHECK_HIGH_SCORE_initiale2
	inc de
	ld (de),a
	inc de
	call DRW_CHAR
;;#9453
CHECK_HIGH_SCORE_insert_score:
	ld a,#01
	ld (hscore_changed),a
	ld hl,cur_score_X10000
	ld b,#05
;;#945d
CHECK_HIGH_SCORE_score_loop:
	ld a,(hl)
	add #2f
	ld (de),a
	dec hl
	inc de
	djnz CHECK_HIGH_SCORE_score_loop

	ld a,#2e
	ld (de),a
	inc de
	ld (de),a
	inc de
	ld (de),a
	inc de
	ld a,(cur_level_X10)
	add #2f
	ld (de),a
	inc de
	ld a,(cur_level_X01)
	add #2f
	ld (de),a
	ret

;;#947b
CHECK_HIGH_SCORE_insert_custom_name:
	ld hl,custom_name
	ld b,#03
;;#9480
CHECK_HIGH_SCORE_name_loop:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz CHECK_HIGH_SCORE_name_loop
	call DISPLAY_CUSTOM_NAME
	jp CHECK_HIGH_SCORE_insert_score

;; -------------------------------------------------
;; Draw the entered name (to be able to choose a start level)
;; -------------------------------------------------
;;#948c
DISPLAY_CUSTOM_NAME:
	push de
	call DELAY
	ld hl,#c471
	ld de,custom_name
	ld b,#03
;;#9498
DISPLAY_CUSTOM_NAME_loop:
	push bc
	ld a,(de)
	inc de
	call DRW_CHAR

	ld bc,#9c40
;;#94a1
DISPLAY_CUSTOM_NAME_delay:
	dec bc
	ld a,b
	or c
	jr nz,DISPLAY_CUSTOM_NAME_delay

	pop bc
	djnz DISPLAY_CUSTOM_NAME_loop
	pop de
	jp DELAY

;; -------------------------------------
;; Display a dot and wait for keyboard input
;; -------------------------------------
;; HL: screen address to display ''.''
;; 
;; A : contain the char pressed is any
;;#94ad
WAIT_KEY:
	;; Display ''.''
	ld a,#2e	
	call DRW_CHAR
	dec hl
	dec hl
	jp #bb18	;; wait key


;; ----------------------------
;; LEFT - RIGHT key code
;; ----------------------------
;;#94b7
key_right:
	DB #01
;;#94b8
key_left:
	DB #08

;; ---------------------------------------
;; Restore direction left-right
;; ---------------------------------------
;;#94b9
SET_DIR_NORMAL:
	ld a,(key_right)
	ld (poke_key_right),a
	ld a,(key_left)
	ld (poke_key_left),a
	ret

;; ---------------------------------------
;; Reverse direction right-left
;; ---------------------------------------
;;#94c6
SET_DIR_REVERSED:
	ld a,(key_right)
	ld (poke_key_left),a
	ld a,(key_left)
	ld (poke_key_right),a
	ret

;;#94d3:
rot_reversed:
	DB #00

;; -------------------
;; Set normal piece''s rotation
;; -------------------
;;#94d4
SET_ROT_NORMAL:
	ld a,(rot_reversed)
	dec a
	ret nz
	ld a,#00
	jr SWITCH_ROT_DIRECTION

;; --------------------------------
;; Set reversed piece''s rotation
;; --------------------------------
;;#94dd
SET_ROT_REVERSED:
	ld a,(rot_reversed)
	dec a
	ret z
	ld a,#01
;; --------------------------------
;; Swap piece daat to reverse rotation direction
;; --------------------------------
;;#94e4
SWITCH_ROT_DIRECTION:
	ld (rot_reversed),a
	ld hl,PIECES_DEFS		;; = PIECE_1
	ld de,reversed_rot_buffer
	ld b,#03
;;#94ef
SWITCH_ROT_DIRECTION_loop1:
	push bc
	inc hl
	inc hl
	inc hl
	inc hl
	ld b,#04
;;#49f6
SWITCH_ROT_DIRECTION_loop2:
	push bc
	ld b,#0c
;;#94f9
SWITCH_ROT_DIRECTION_loop3:
	inc hl
	djnz SWITCH_ROT_DIRECTION_loop3
	ld c,#0e
;;#94fe
SWITCH_ROT_DIRECTION_loop4:
	ld a,(de)
	ld b,(hl)
	ld (hl),a
	ld a,b
	ld (de),a
	inc hl
	inc de
	dec c
	jr nz,SWITCH_ROT_DIRECTION_loop4
	pop bc
	djnz SWITCH_ROT_DIRECTION_loop2
	pop bc
	djnz SWITCH_ROT_DIRECTION_loop1
	ret
;;#950f
;; Only the 3 first pieces (RL - L and T) have different rotation sequences
;; S,Z,I,Cube have the same rotation sequences
reversed_rot_buffer:
	;;-------------------------
	;; Remap piece 1_1
	dw #009e
	dw #003e
	dw PIECE_1_4		;;#7cad
	dw #0000,#0001,#000c,#000c
	;; Remap piece 1_2
	dw #0002
	dw #0002
	dw PIECE_1_1		;;#7c5f
	dw #000c,#0001,#0001,#000a
	;; Remap piece 1_3
	dw #0000
	dw #0000
	dw PIECE_1_2		;;#7c79
	dw #0001,#000c,#000c,#0001
	;; Remap piece 1_4
	dw #ff60
	dw #ffc0
	dw PIECE_1_3		;;#7c93
	dw #0002,#000a,#0001,#0001

	;;-------------------------
	;; Remap piece 2_1
	dw #009e
	dw #003e
	dw PIECE_2_4		;;#7d19
	dw #0001,#000c,#000b,#0001
	;; Remap piece 2_2
	dw #0002
	dw #0002
	dw PIECE_2_1		;;#7ccb
	dw #000c,#0001,#0001,#000c
	;; Remap piece 2_3
	dw #0000
	dw #0000
	dw PIECE_2_2		;;#7ce5
	dw #0001,#0001,#000b,#000c
	;; Remap piece 2_4
	dw #ff60
	dw #ffc0
	dw PIECE_2_3		;;#7cff
	dw #0000,#000c,#0001,#0001

	;;-------------------------
	;; Remap piece 3_1
	dw #009e
	dw #003e
	dw PIECE_3_4		;;#7d85
	dw #0001,#000b,#0001,#000c
	;; Remap piece 3_2
	dw #0002
	dw #0002
	dw PIECE_3_1		;;#7d37
	dw #000c,#0001,#0001,#000b
	;; Remap piece 3_3
	dw #0000
	dw #0000
	dw PIECE_3_2		;;#7d51
	dw #0001,#000c,#0001,#000b
	;; Remap piece 3_4
	dw #ff60
	dw #ffc0
	dw PIECE_3_3		;;#7d6b
	dw #0001,#000b,#0001,#0001


;; -------------------------------------------------------
;; Delay loop (2 or 3 seconds... TBD)
;; -------------------------------------------------------
;;#95b7:
DELAY:
	ld bc,#00c8
;;#95ba
DELAY_delay1:
	push bc
;;#95bb
DELAY_delay2:
	push af
	ld a,(ix+#00)
	ld (ix+#00),a
	ld a,(ix+#00)
	ld (ix+#00),a
	pop af
	dec c
	jr nz,DELAY_delay2
	pop bc
	djnz DELAY_delay1
	ret

;; -----------------------------------------------------
;; Draw text popup in playing area
;; -----------------------------------------------------
;;#95d0
DRAW_POPUP_BOX:
	ld hl,#c3aa
	ld b,#14
;;#95d5
DRAW_POPUP_BOX_top:
	ld (hl),#3f
	inc hl
	djnz DRAW_POPUP_BOX_top
	ld hl,#cbaa
	ld b,#26
;;#95df
DRAW_POPUP_BOX_middle:
	ld (hl),#2a	;; left
	inc hl
	ld c,#12
;;#95e4
DRAW_POPUP_BOX_bkgd:
	ld (hl),#00	;; bkg
	inc hl
	dec c
	jr nz,DRAW_POPUP_BOX_bkgd
	ld (hl),#15	;; right
	inc hl
	;; next line
	ld de,#07ec
	add hl,de
	jr nc,DRAW_POPUP_BOX_next
	ld de,#c040
	add hl,de
;;#95f7
DRAW_POPUP_BOX_next:
	djnz DRAW_POPUP_BOX_middle
	ld b,#14
;;#95fb
DRAW_POPUP_BOX_bottom:
	ld (hl),#3f
	inc hl
	djnz DRAW_POPUP_BOX_bottom
	ret

;; ----------------------
;; Get key code for char
;; input:
;; A: char
;; output:
;; A: key code
;; ----------------------
;;#9601
GET_KEY_CODE:
	push bc
	push hl
	ld c,a

	;; Check without modifier
	ld b,#4e
;;#9606
GET_KEY_CODE_loop_nomod:	
	ld a,b
	dec a
	call #bb2a
	cp c
	jr z,GET_KEY_CODE_key_found
	djnz GET_KEY_CODE_loop_nomod
	
	;;Check with shift modifier
	ld b,#4e
;;#9612
GET_KEY_CODE_loop_shift:	
	ld a,b
	dec a
	call #bb30
	cp c
	jr z,GET_KEY_CODE_key_found
	djnz GET_KEY_CODE_loop_shift
	
	;; Found
;;#961c
GET_KEY_CODE_key_found:
	ld a,b
	dec a
	pop hl
	pop bc
	ret


;; ----------------------------------
;; Draw bitmap on screen
;; DE: src address
;; HL: dst address
;; B : height
;; C : width
;; ----------------------------------
;;#9621
DRAW_BMP_SYNC:
	push bc
	;; Wait flyback signal
	;; by reading μPD8255 port B
	ld b,#f5
;;#9624
DRAW_BMP_SYNC_wait:
	in a,(c)
	rra
	jr nc,DRAW_BMP_SYNC_wait
	;; Got flyback signal...
	;; Draw bitmap.
	pop bc
;;#962a
DRAW_BMP_SYNC_height:
	push bc
	push hl
	push de
;;#962d
DRAW_BMP_SYNC_width:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	dec c
	jr nz,DRAW_BMP_SYNC_width
	pop de
	ld hl,#0014	;; <- bmp width seems to be #14 bytes larges
	add hl,de
	ex de,hl	;; de = de + #14
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz DRAW_BMP_SYNC_height
	ret

;; ----------------------------------
;; Draw bitmap on screen
;; DE: src address
;; HL: dst address
;; B : height
;; C : width
;; ----------------------------------
;;#9642
DRAW_BMP:
	push bc
	push hl
;;#9644
DRAW_BMP_width:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	dec c
	jr nz,DRAW_BMP_width
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz DRAW_BMP
	ret

;; ----------------------------------
;; Draw bitmap to a 20 (#14) bytes wide offscreen buffer 
;; Only draw non null bytes.
;; HL: dst address
;; DE: src address
;; B : height
;; C : width
;; ----------------------------------
;;#9653
DRAW_MASK_BMP_OFFSCREEN1:
	push bc
	push hl
;;#9655
DRAW_MASK_BMP_OFFSCREEN1_width:
	ld a,(de)
	inc de
	cp #00
	jr z,DRAW_MASK_BMP_OFFSCREEN1_skip
	ld (hl),a
;;#965c
DRAW_MASK_BMP_OFFSCREEN1_skip:
	inc hl
	dec c
	jr nz,DRAW_MASK_BMP_OFFSCREEN1_width
	pop hl
	ld bc,#0014
	add hl,bc
	pop bc
	djnz DRAW_MASK_BMP_OFFSCREEN1
	ret

;; ----------------------------------
;; Draw bitmap to a 34 (#22) bytes wide offscreen buffer 
;; HL: dst address
;; DE: src address
;; B : height
;; C : width
;; ----------------------------------
;;#9669
DRAW_BMP_OFSCR_W22:
	push bc
	push hl
;;#966b
DRAW_BMP_OFSCR_W22_width:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	dec c
	jr nz,DRAW_BMP_OFSCR_W22_width
	pop hl
	ld bc,#0022
	add hl,bc
	pop bc
	djnz DRAW_BMP_OFSCR_W22
	ret

;; ----------------------------------
;; Draw masked bitmap on screen (only non null bytes)
;; DE: src address
;; HL: dst address
;; B : height
;; C : width
;; ----------------------------------
;;#967b
DRAW_MASK_BMP:
	push bc
	push hl
;;#967d
DRAW_MASK_BMP_width:
	ld a,(de)
	inc de
	cp #00
	jr z,DRAW_MASK_BMP_skip
	ld (hl),#00
;;#9685
DRAW_MASK_BMP_skip:
	inc hl
	dec c
	jr nz,DRAW_MASK_BMP_width
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz DRAW_MASK_BMP
	ret

;; ----------------------------------
;; Clear bitmap from a 20 (#14) bytes wide offscreen buffer 
;; Only clear non null bytes.
;; HL: dst address
;; DE: src address
;; B : height
;; C : width
;; ----------------------------------
;;#9691
CLEAR_MASK_BMP_OFFSCREEN1:
	push bc
	push hl
;;#9693
CLEAR_MASK_BMP_OFFSCREEN1_width:
	ld a,(de)
	inc de
	cp #00
	jr z,CLEAR_MASK_BMP_OFFSCREEN1_skip
	ld (hl),#00
;;#969b
CLEAR_MASK_BMP_OFFSCREEN1_skip:
	inc hl
	dec c
	jr nz,CLEAR_MASK_BMP_OFFSCREEN1_width
	pop hl
	ld bc,#0014
	add hl,bc
	pop bc
	djnz CLEAR_MASK_BMP_OFFSCREEN1
	ret


;; ----------------------------
;; Clear screen AREA
;; HL: Screen address
;; B : height
;; C : width
;; ----------------------------
;;#96a8
CLEAR_SCREEN_AREA:
	push bc
	push hl
;;#96aa
CLEAR_SCREEN_AREA_width:
	ld (hl),#00
	inc hl
	dec c
	jr nz,CLEAR_SCREEN_AREA_width
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz CLEAR_SCREEN_AREA
	ret


;; -----------------------------------------
;; Add hundreds to score
;; B : the number of hundreds to add
;; -----------------------------------------
;;#96b8
SCORE_ADD_HDRDS:
	ld a,(cur_score_X00100)
	add b
	jp HDRDS
;; -----------------------------------------
;; Add tens to score
;; B : the number of tens to add
;; -----------------------------------------
;;#96bf
SCORE_ADD_TENS:
	ld a,(cur_score_X00010)
	add b
	jp TENS

;; -----------------------------------------
;; Add units to score
;; B : the number of units to add
;; -----------------------------------------
;;#96c6
SCORE_ADD_UNITS:
	ld a,(cur_score_X00001)
	add b
	ld (cur_score_X00001),a
	cp #0b
	jr c,DISPLAY_SCORE
	or a
	sbc #0a
	ld (cur_score_X00001),a
	ld a,(cur_score_X00010)
	inc a
;;#96db
TENS:
	ld (cur_score_X00010),a
	sbc #0b
	jr c,DISPLAY_SCORE
	inc a
	ld (cur_score_X00010),a
	or a
	sbc #0b
	jr c,TENS_cont
	inc a
	ld (cur_score_X00010),a
;;#96ef
TENS_cont:
	ld a,(cur_score_X00100)
	inc a
;;#96f3
HDRDS:
	ld (cur_score_X00100),a
	or a
	sbc #0b
	jr c,DISPLAY_SCORE
	inc a
	ld (cur_score_X00100),a
	ld a,(cur_score_X01000)
	inc a
	ld (cur_score_X01000),a
	cp #0b
	jr c,DISPLAY_SCORE
	ld a,#01
	ld (cur_score_X01000),a
	ld a,(cur_score_X10000)
	inc a
	ld (cur_score_X10000),a
	cp #0b
	jr c,DISPLAY_SCORE
	ld a,#01
	ld (cur_score_X10000),a
;;#971f:
DISPLAY_SCORE:
	ld hl,(cur_score_scr)
	ld a,(cur_score_X10000)
	add #2f
	call DRW_CHAR
	ld a,(cur_score_X01000)
	add #2f
	call DRW_CHAR
	ld a,(cur_score_X00100)
	add #2f
	call DRW_CHAR
	ld a,(cur_score_X00010)
	add #2f
	call DRW_CHAR
	ld a,(cur_score_X00001)
	add #2f
	jp DRW_CHAR

;; -------------------------
;; Draw text
;; HL: screen location
;; DE: text address
;; B : text len
;; -------------------------
;;#974a
DRW_TXT:
	ld a,(de)
	inc de
	call DRW_CHAR
	djnz DRW_TXT
	ret

;; -------------------------
;; Draw wide text
;; HL: screen location
;; DE: text address
;; B : text len
;; -------------------------
;;#9752
DRW_WTXT:
	ld a,(de)
	inc de
	call DRW_WCHAR
	djnz DRW_WTXT
	ret

;; -------------------------
;; Draw character
;; HL: screen address
;; A : character
;; -------------------------
;;#975a
DRW_CHAR:
	push bc
	push de
	push hl
	;; Substract index of '' '' (space)
	ld b,#20
	or a
	sbc b
	;; Multiply by 14
	ld l,a
	ld h,#00
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	ld e,a
	ld d,#00
	sbc hl,de
	sla l
	rl h
	;; Get char bitmap''s address
	ld de,ALPHABET
	add hl,de
	ex de,hl
	pop hl
	push hl
	;; Draw it
	ld b,#07
;;#9782
DRW_CHAR_loop:
	push bc
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	dec hl
	ld bc,#0800
	add hl,bc
	pop bc
	djnz DRW_CHAR_loop
	ld (hl),#00
	inc hl
	ld (hl),#00
	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	ret

;; --------------------------
;; Draw wide character
;; HL: screen address
;; A : character
;; --------------------------
;;#979d
DRW_WCHAR:
	push bc
	push de
	push hl
	;; Substract index of '' '' (space)
	ld b,#20
	or a
	sbc b
	;; Multiply by 14
	ld l,a
	ld h,#00
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	ld e,a
	ld d,#00
	sbc hl,de
	sla l
	rl h
	;; Get char bitmap''s address
	ld de,ALPHABET
	add hl,de
	ex de,hl
	pop hl
	push hl
	;; Draw it, doubling each line
	ld b,#07
;;#97c5
DRW_WCHAR_loop:
	push bc
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	dec de
	ld (hl),a
	dec hl
	ld bc,#0800
	add hl,bc
	jr nc,DRW_WCHAR_cont1
	ld bc,#c040
	add hl,bc
;;#97d8
DRW_WCHAR_cont1:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	dec hl
	ld bc,#0800
	add hl,bc
	jr nc,DRW_WCHAR_cont2
	ld bc,#c040
	add hl,bc
;;#97ea
DRW_WCHAR_cont2:
	pop bc
	djnz DRW_WCHAR_loop
	pop hl
	inc hl
	inc hl
	pop de
	pop bc
	ret

;; ------------------------
;; Get Random piece and clear ''next piece'' area
;; ------------------------
;;#97f3:
GET_RNDM_PIECE:
	ld a,r
	ld c,a
	ld a,(random)
	add c
	sla a
	sla a
	add c
	inc a
	ld (random),a
	and #07			;; mod 7
	cp #07		
	jp nc,GET_RNDM_PIECE	;; if random >= 7 then retry
	sla a			;; x2
	ld c,a
	ld b,#00
	ld hl,PIECES_TABLE
	add hl,bc		;; HL = &piece_table[random]
	ld e,(hl)		;; 
	inc hl			;;
	ld d,(hl)		;; DE = piece_table[random]


	ld hl,nxt_piece_prz_pos ;; Copy piece data into next piece buffer
	ld b,#1e		;; piece data is #1E long
;;#981b	
GET_RNDM_PIECE_copy:			
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	djnz GET_RNDM_PIECE_copy

	ld hl,#e15a
	ld b,#20
;;#9826
GET_RNDM_PIECE_clear1:
	push bc
	push hl
	ld c,#0a
;;#982a
GET_RNDM_PIECE_clear2:
	ld (hl),#00
	inc hl
	dec c
	jr nz,GET_RNDM_PIECE_clear2
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz GET_RNDM_PIECE_clear1
	ret
;;#9838
random:
	DB #00
;;#9839
PIECES_TABLE:
	DW PIECE_5_DEF
	DW PIECE_3_DEF
	DW PIECE_2_DEF
	DW PIECE_4_DEF
	DW PIECE_6_DEF
	DW PIECE_7_DEF
	DW PIECE_1_DEF

;;#9847
ANIMATION_END:
	;; Draw dance floor
	ld hl,#fc82
	ld de,DANCEFLR_OFSCR
	ld bc,#6522
	call DRAW_BMP

	;; Draw Kozak going out
	ld hl,#ee45
	ld de,KOZAK_OUT_BMP
	ld bc,#1604		;; looking carefully, this should probably be #1704
	call DRAW_BMP

	;; Delay
	ld bc,#0000
;;#9862
ANIMATION_END_delay:
	dec bc
	ld a,b
	or c
	jr nz,ANIMATION_END_delay

	;; Draw dance floor
	ld hl,#fc82
	ld de,DANCEFLR_OFSCR
	ld bc,#6522
	call DRAW_BMP
	;; proceed to curtain moving down.

;; ------------------------------------------------
;; Animate the curtain moving down on the dance floor
;; ------------------------------------------------
;;#9873
DANCEFLR_CURTAIN_DOWN:
	ld hl,#fc42		;; upper curtain screen origin
	ld de,DANCEFLR_OFSCR
	ld b,#65
;;#987b
DANCEFLR_CURTAIN_DOWN_loop:
	push bc
	push hl
	push de
	push hl
	;; Prepare offscreen bitmap by copying curtain bitmap
	call PREPARE_DANCEFLR_OFFSCR
	;; Add dance floor background behind the curtain
	;; Only fill ''empty/black'' pixels
	call ADD_DANCEFLOOR_BKG

	;; Sync - Wait flyback 
	ld b,#f5
;;#9887	
DANCEFLR_CURTAIN_DOWN_sync:
	in a,(c)
	rra
	jr nc,DANCEFLR_CURTAIN_DOWN_sync

	;; Draw offscreen bitmap on screen
	ld bc,#0822
	pop hl
	ld de,CURTAIN_OFSCR
	call DRAW_BMP

	;; Move curtain one line down
	pop de
	ld hl,#0022
	add hl,de
	ex de,hl
	pop hl
	call NXT_SCR_LINE

	ld b,#64
;;#98a2
DANCEFLR_CURTAIN_DOWN_delay1:
	ld c,#0a
;;#98a4
DANCEFLR_CURTAIN_DOWN_delay2:
	dec c
	jr nz,DANCEFLR_CURTAIN_DOWN_delay2
	djnz DANCEFLR_CURTAIN_DOWN_delay1
	pop bc
	djnz DANCEFLR_CURTAIN_DOWN_loop

	;; Draw curtain one more time without back ground
	;; We''re all the way down.
	ld de,CURTAIN_BMP
	ld bc,#0822
	jp DRAW_BMP

;; ------------------------------------------------
;; Animate the curtain moving up on the dance floor
;; ------------------------------------------------
;;#98b5
DANCEFLR_CURTAIN_UP:
	ld hl,#e782	;; lower curtain screen address.
	ld de,#3d33	;; revealed background line address while curtain is moving up
	
	ld b,#66
;;#98bd
DANCEFLR_CURTAIN_UP_loop:
	push bc
	push hl
	push de
	call PREPARE_DANCEFLR_OFFSCR
	call ADD_DANCEFLOOR_BKG

	;; Sync - wait flyback
	ld b,#f5
;;#98c8
DANCEFLR_CURTAIN_UP_sync:
	in a,(c)
	rra
	jr nc,DANCEFLR_CURTAIN_UP_sync

	ld bc,#0822
	ld de,CURTAIN_OFSCR
	call DRAW_BMP

	;; Draw revealed background line
	pop de
	ld bc,#0122
	call DRAW_BMP

	;; Move curtain one line up
	ld hl,#ffbc
	add hl,de
	ex de,hl
	pop hl
	or a
	call PRV_SCR_LINE
	
	;; Delay
	ld b,#64
;;#98e9
DANCEFLR_CURTAIN_UP_delay1:
	ld c,#0a
;;#98eb
DANCEFLR_CURTAIN_UP_delay2:
	dec c
	jr nz,DANCEFLR_CURTAIN_UP_delay2
	djnz DANCEFLR_CURTAIN_UP_delay1

	pop bc
	djnz DANCEFLR_CURTAIN_UP_loop
	ret

;; ----------------------------
;; Prepare dancefloor offscreen bitmap
;; ----------------------------
;; #98f4
PREPARE_DANCEFLR_OFFSCR:
	push hl
	push de
	push bc
	push af
	ld hl,CURTAIN_BMP
	ld de,CURTAIN_OFSCR
	ld b,#08
;;#9900
PREPARE_DANCEFLR_OFFSCR_height:
	ld c,#22
;;#9902
PREPARE_DANCEFLR_OFFSCR_width:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	dec c
	jr nz,PREPARE_DANCEFLR_OFFSCR_width
	djnz PREPARE_DANCEFLR_OFFSCR_height

	pop af
	pop bc
	pop de
	pop hl
	ret

;; #9910
ADD_DANCEFLOOR_BKG:
	push hl
	push de
	push bc
	push af
	ld hl,#fef0
	add hl,de
	ld de,CURTAIN_OFSCR
	
	ld b,#08
;;#991d
ADD_DANCEFLOOR_BKG_height:
	ld c,#22
;;#991f
ADD_DANCEFLOOR_BKG_width:
	push bc
	;; Process current bitmap byte
	;; One byte is 2 pixels
	;; pixel 1: 10101010 -> #aa
	;; pixel 2: 01010101 -> #55
	ld a,(de)
	ld b,a
	and #aa		;; check if foreground pixel 1 if empty
	jr nz,ADD_DANCEFLOOR_BKG_skip1	;; non empty -> skip
	ld a,(hl)	;; copy background pixel 1
	and #aa		;;  |
	or b		;;  |
	ld (de),a	;;  ---
;;#992b
ADD_DANCEFLOOR_BKG_skip1:
	ld a,(de)	
	ld b,a		
	and #55		;; check if foreground pixel 2 if empty
	jr nz,ADD_DANCEFLOOR_BKG_skip2	;; non empty -> skip
	ld a,(hl)	;; copy background pixel 2
	and #55		;;  |
	or b		;;  |
	ld (de),a	;;  ---
;;#9936
ADD_DANCEFLOOR_BKG_skip2:
	inc hl
	inc de
	pop bc
	dec c
	jr nz,ADD_DANCEFLOOR_BKG_width
	djnz ADD_DANCEFLOOR_BKG_height
	pop af
	pop bc
	pop de
	pop hl
	ret

;; --------------------------------------------
;; 
;; --------------------------------------------
;;#9943
DANCE_ANIMATION:
	;; Prepare dance floor offscreen bitmap.
	;; - clear background
	;; - paint background collors
	;; - add left column
	;; - Add right column with Alinka
	
	call CLEAR_PLAYGND_OFSCR
	
	ld hl,PLAYGND_OFSCR

	;; Fills 12 white lines	
	ld a,#3f
	ld b,#0c
;;#99d4
DANCE_ANIMATION_fill1_h:
	ld c,#22
;;#994f
DANCE_ANIMATION_fill1_w:
	ld (hl),a
	inc hl
	dec c
	jr nz,DANCE_ANIMATION_fill1_w
	djnz DANCE_ANIMATION_fill1_h


	;; Fills 1 light blue line
	ld a,#30
	ld b,#22
;;#995a
DANCE_ANIMATION_fill2_w:
	ld (hl),a
	inc hl
	djnz DANCE_ANIMATION_fill2_w
	
	;; Fills 63 dark blue lines
	ld a,#0c
	ld b,#3f
;;#9962
DANCE_ANIMATION_fill3_h:
	ld c,#22
;;#9964
DANCE_ANIMATION_fill3_w:
	ld (hl),a
	inc hl
	dec c
	jr nz,DANCE_ANIMATION_fill3_w
	djnz DANCE_ANIMATION_fill3_h
	
	;; Fills 1 light blue line
	ld a,#30
	ld b,#22
;;#996f
DANCE_ANIMATION_fill4_w:
	ld (hl),a
	inc hl
	djnz DANCE_ANIMATION_fill4_w

	;; Draw left column
	ld hl,DANCEFLR_OFSCR	
	ld de,LFT_COLUMN_BMP
	ld bc,#6405		;; 5x100
	call DRAW_BMP_OFSCR_W22


	;; Draw right column with Alinka
	ld hl,#2fe1
	ld de,RGT_COLUMN_BMP
	ld bc,#640a		;; 10x100
	call DRAW_BMP_OFSCR_W22

	;; Animate curtain moving up
	call DANCEFLR_CURTAIN_UP

	;; Draw Kozak dancer coming in
	ld hl,#d605
	ld de,KOZAK_IN_BMP
	ld bc,#1904
	call DRAW_BMP

	;; Start Kozak dance animation
	ld a,#28		;; initial delay, then deley 10 frames
	ld (dance_cnt),a
	ld hl,DANCE_TBL		;; <- dance animation data
	ld (dance_ptr),hl
	ld hl,FLBK_DANCE_BLOCK	
	call #bcda		;; Enable dance flyback

	;; First FLYBACK tempo is longer than the following delay
	;; delay
	ld bc,#0000
;;#99ae
DANCE_ANIMATION_delay:
	dec bc
	ld a,b
	or c
	jr nz,DANCE_ANIMATION_delay

	;; Enable kazatchok melody
	call START_KAZATCHOK

	;; Draw empty dance floor
	ld hl,#fc82
	ld de,DANCEFLR_OFSCR
	ld bc,#6522
	call DRAW_BMP

	;; Add Kozak ready to dance
	ld hl,#ee0e
	ld de,KOZAK7_BMP
	ld bc,#200a
	call DRAW_BMP
;;#99ce
DANCE_ANIMATION_wait:
	ld a,(dance_cnt)
	cp #00
	jr z,DANCE_ANIMATION_done	;; Animation terminated.
	jr DANCE_ANIMATION_wait
;;#99d7
DANCE_ANIMATION_done:
	call ANIMATION_END
	jp STOP_KAZATCHOK

;; --------------------------------
;; Dance animation''s flyback block
;; --------------------------------
;; #99dd
FLBK_DANCE_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; ROM Block
	DW #0000	;; User (not used)
	DB #00,#00,#00,#00,#00,#00 ;; Extra (useless)
;;#99ec
dance_cnt:
	DB #00
;;#99ed
dance_ptr:
	DB #00,#00

;; #99ef
FLBK_DANCE_ISR:
	push af
	ld a,(dance_cnt)
	dec a
	ld (dance_cnt),a
	jr nz,FLBK_DANCE_ISR_cont
	di
	push hl
	push de
	push bc
	ld a,DANCE_TEMPO	;;#0a
	ld (dance_cnt),a
	ld hl,(dance_ptr)
	ld a,(hl)
	cp #ff
	jr nz,FLBK_DANCE_ISR_anim
	ld a,#00		;; <- indicate animation''s done
	ld (dance_cnt),a
	ld hl,FLBK_DANCE_BLOCK
	call #bcdd
	jp FLBK_DANCE_ISR_done
;;#9a18
FLBK_DANCE_ISR_anim:
	ld e,a
	inc hl
	ld a,(hl)
	inc hl
	ld (dance_ptr),hl
	ld d,a
	ld hl,#ee0e		;; screen address
	ld bc,#200a		;; dimensions 10x32
	call DRAW_BMP
;;#9a29
FLBK_DANCE_ISR_done:
	pop bc
	pop de
	pop hl
;;#9a2c
FLBK_DANCE_ISR_cont:
	pop af
	ei
	ret

;; ---------------------------
;; Enable Kazatchok melody
;; ---------------------------
;;#9a2f
START_KAZATCHOK:
	ld hl,KAZATCHOK_MELODY
	ld (kztk_ptr),hl
	ld a,#01
	ld (kztk_dur),a
	
	ld a,#04
	ld c,#00
	call CFG_AY_SND

	ld a,#05
	ld c,#00
	call CFG_AY_SND

	ld hl,FLBK_KAZATCHOK_BLOCK
	call #bcda	;; add/enable flyback block

	ld a,#07
	ld c,#30
	call CFG_AY_SND
	ld a,#0a
	ld c,#0a
	jp CFG_AY_SND

;; ---------------------------
;; Stop Kazatchok melody
;; ---------------------------
;;#9a5c
STOP_KAZATCHOK:
	ld a,#04
	ld c,#00
	call CFG_AY_SND
	ld a,#05
	ld c,#00
	call CFG_AY_SND
	ld a,#0a
	ld c,#00
	call CFG_AY_SND
	ld hl,FLBK_KAZATCHOK_BLOCK
	jp #bcdd	;; disable/remove flyback block

;;#9a77
kztk_ptr:		;; 
	DB #00,#00	;; Current note address
;;#9a79
kztk_dur:		;; 
	DB #00		;; note duration

;;#9a7a
FLBK_KAZATCHOK_BLOCK:		
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; Routine address
	DB #00		;; ROM Block
	DW #0000	;; User (not used)
	DB #00		;; Extra (useless)

;; ---------------------
;; Kazatchok Flyback routine
;; ---------------------
;;#9a84:		
FLBK_KAZATCHOK_ISR:
	di
	push af
	push bc
	push hl
	ld a,(kztk_dur)
	dec a
	ld (kztk_dur),a
	jr nz,FLBK_KAZATCHOK_ISR_cont	;; if duration!=0 then keep playing same note
	;; else program next note	
	ld a,#0a
	ld c,#00
	call CFG_AY_SND
	ld hl,(kztk_ptr)
;;#9a9b
FLBK_KAZATCHOK_ISR_next:
	ld a,(hl)	;; new note duration
	inc a		 
	jr nz,FLBK_KAZATCHOK_ISR_play	;; if duration != #FF then play note
	;; else start over again
	ld hl,KAZATCHOK_MELODY	
	ld (kztk_ptr),hl
	jr FLBK_KAZATCHOK_ISR_next
;;#9aa7
FLBK_KAZATCHOK_ISR_play:
	dec a
	ld (kztk_dur),a
	inc hl
	ld c,(hl)
	inc hl
	ld a,#05
	call CFG_AY_SND
	ld c,(hl)
	inc hl
	ld a,#04
	call CFG_AY_SND
	ld a,#0a
	ld c,#0a
	call CFG_AY_SND
	ld (kztk_ptr),hl
;;#9ac4
FLBK_KAZATCHOK_ISR_cont:
	pop hl
	pop bc
	pop af
	ei
	ret



;; ---------------------------
;; Random block flyback''s block
;; ---------------------------
;;#9ac9
FLBK_RNDM_BLCK_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; ROM Block
	DW #0000	;; User (not used)
	DB #00		;; Extra (useless)
;;#9ad3
rndm_blck_cnt:
	DB #00


;;
;; ---------------------------
;; Random block flyback ISR
;; ---------------------------
;;#9ad4
FLBK_RNDM_BLCK_ISR:
	push af
	;; Decrease ''counter''
	ld a,(rndm_blck_cnt)
	dec a
	jr nz,FLBK_RNDM_BLCK_ISR_cont
	;; Disable flyback
	ld hl,FLBK_RNDM_BLCK_BLOCK
	call #bcdd
	ld a,#01
;;#9ae3
FLBK_RNDM_BLCK_ISR_cont:
	ld (rndm_blck_cnt),a
	pop af
	ret

;; ---------------------------
;; Enable random block flyback
;; ---------------------------
;;#9ae8
ENABLE_RNDM_BLCK:
	xor a
	ld (rndm_blck_cnt),a
	ld hl,FLBK_RNDM_BLCK_BLOCK
	jp #bcda

;; ---------------------------
;; Disable random block flyback
;; ---------------------------
;;#9af2
DISABLE_RNDM_BLCK:
	ld a,#ff
	ld (rndm_blck_cnt),a
	ld hl,FLBK_RNDM_BLCK_BLOCK
	jp #bcdd


;; ---------------------------
;; Insert a random block into playground area
;; ---------------------------
;;#9afd
INSERT_RNDM_BLCK:
	ld a,(random)
	and #03
	inc a
	ld (INSERT_RNDM_BLCK_value),a
	ld ix,#3ff1
	ld hl,#3e05
	ld b,#0f
;;#9b0f
INSERT_RNDM_BLCK_loop1:
	ld c,#0a
	ld d,#00
;;#9b13
INSERT_RNDM_BLCK_loop2:
	ld a,(ix+#00)
	or a
	jr z,INSERT_RNDM_BLCK_empty
;;#9b19
INSERT_RNDM_BLCK_cont:
	dec ix
	dec hl
	dec hl
	dec c
	jr nz,INSERT_RNDM_BLCK_loop2
	dec ix
	dec ix
	or a
	ld de,#ff74
	add hl,de
	djnz INSERT_RNDM_BLCK_loop1
	ret
;;#9b2c
INSERT_RNDM_BLCK_empty:
	ld a,d
	inc d
;;#9b2e+1
INSERT_RNDM_BLCK_value equ $ + 1
	cp #03
	jr nz,INSERT_RNDM_BLCK_cont
	ld a,(ix+#0c)
	dec a
	jr nz,INSERT_RNDM_BLCK_cont
	ld a,(ix-#0c)
	dec a
	jr z,INSERT_RNDM_BLCK_cont
	ld a,(ix-#18)
	dec a
	jr z,INSERT_RNDM_BLCK_cont
	ld (ix+#00),#01
	ld de,BLINK_BLOCK_BMP
	ld bc,#0802
	call DRAW_MASK_BMP_OFFSCREEN1
	ld hl,PLAYGND_SCR
	ld de,PLAYGND_OFSCR
	ld bc,PLAYGND_DIM
	call DRAW_BMP

	ld a,#c8
	ld (rndm_blck_cnt),a
	ld hl,FLBK_RNDM_BLCK_BLOCK
	jp #bcda		;; Enable Flyback block

;; ---------------------------
;; Playground move up Flyback''s block
;; ---------------------------
;;#9b68
FLBK_MOVE_UP_BLOCK:
	DW #0000	;; Chain
	DB #00		;; Count
	DB #00		;; Class
	DW #0000	;; ISR
	DB #00		;; ROM Block
	DW #0000	;; User (not used)
	DB #00		;; Extra (useless)
;;#9b72
move_up_cnt:
	DB #00
;;#9b73
move_up_empty_blk:
	DB #00

;; ---------------------------
;; Playground move up Flyback''s ISR
;; ---------------------------
;;#9b74
FLBK_MOVE_UP_ISR:
	push af
	ld a,(move_up_cnt)
	dec a
	jr nz,FLBK_MOVE_UP_ISR_cont
	;; Disable flyback block
	ld hl,FLBK_MOVE_UP_BLOCK
	call #bcdd
	ld a,#01
;;#9b83
FLBK_MOVE_UP_ISR_cont:
	ld (move_up_cnt),a
	pop af
	ret

;; ---------------------------
;; Playground move up Flyback enable
;; ---------------------------
;;#9b88
FLBK_MOVE_UP_ENABLE:
	xor a
	ld (move_up_cnt),a		;; reset variable. Usage TBD
	ld hl,FLBK_MOVE_UP_BLOCK
	jp #bcda

;; ---------------------------
;; Playground move up Flyback disable
;; ---------------------------
;;#9b92
FLBK_MOVE_UP_DISABLE:
	ld a,#ff
	ld (move_up_cnt),a
	ld hl,FLBK_MOVE_UP_BLOCK
	jp #bcdd

;; ---------------------------------
;; Move playground one line up !!!
;; ---------------------------------
;;#9b9d
PLAYGROUND_MOVE_UP:
	ld a,(playgnd_top_idx)
	cp #0f
	ret nc
	inc a
	ld (playgnd_top_idx),a
	ld hl,PLAYGND_MSK_BUF
	ld de,PLAYGND_MSK_BUF+#0c
	ld b,#19
;;#9baf
PLAYGROUND_MOVE_UP_msk_h:
	ld c,#0c
;;#9bb1
PLAYGROUND_MOVE_UP_msk_w:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	dec c
	jr nz,PLAYGROUND_MOVE_UP_msk_w
	djnz PLAYGROUND_MOVE_UP_msk_h

	ld hl,PLAYGND_OFSCR
	ld de,PLAYGND_OFSCR+160		;;(20*8)	;; 1 line below
	ld b,#c8
;;#9bc2
PLAYGROUND_MOVE_UP_bmp_h:
	ld c,#14
;;#9bc4
PLAYGROUND_MOVE_UP_bmp_w:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	dec c
	jr nz,PLAYGROUND_MOVE_UP_bmp_w
	djnz PLAYGROUND_MOVE_UP_bmp_h

	ld ix,#3fe8

	;; Randomly choose empty block position on the new line.
	ld a,r
	ld c,a
	ld a,(random)
	add c
	sla a
	sla a
	add c
	inc a
	ld (random),a
	and #1f
	add #07
	sra a
	sra a
	ld (move_up_empty_blk),a	;; <- store position

	ld b,#09
;;#9bee
PLAYGROUND_MOVE_UP_draw_blocks:
	push bc
	ld a,(move_up_empty_blk)
	dec a
	jr z,PLAYGROUND_MOVE_UP_draw_empty
;;#9bf5
PLAYGROUND_MOVE_UP_draw_cont:
	ld (move_up_empty_blk),a
	push hl
	ld de,ORANGE_BLOCK_BMP
	ld bc,#0802
	call DRAW_MASK_BMP_OFFSCREEN1
	pop hl
	inc hl
	inc hl
	ld (ix+#00),#01
	inc ix
	pop bc
	djnz PLAYGROUND_MOVE_UP_draw_blocks

	ld hl,PLAYGND_SCR
	ld de,PLAYGND_OFSCR
	ld bc,PLAYGND_DIM
	call DRAW_BMP
	ld a,#fa
	ld (move_up_cnt),a
	ld hl,FLBK_MOVE_UP_BLOCK
	jp #bcda
;;#9c25
PLAYGROUND_MOVE_UP_draw_empty:
	push hl
	ld de,EMPTY_BLOCK_BMP
	ld b,#08
;;#9c2b
PLAYGROUND_MOVE_UP_empty_loop:
	push bc
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	ld bc,#0013
	add hl,bc
	pop bc
	djnz PLAYGROUND_MOVE_UP_empty_loop
	inc hl
	pop hl
	inc hl
	inc hl
	ld (ix+#00),#00
	inc ix
	ld a,#00
	jr PLAYGROUND_MOVE_UP_draw_cont

;;
;; Set up playing area mask (either 0 or 1) 
;; 28 lines of 12 blocks
;;
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;;	100000000001
;; DE ->????????????	
;;	????????????
;;	????????????
;;	????????????
;;	????????????
;;	????????????
;;	222222222222
;;      222222222222
;;#9c48
SETUP_PLAYGROUND_MASK:
	ld b,#14		
	ld hl,PLAYGND_MSK_BUF		;; <- probably playing area mask array address
;;#9c4d
SETUP_PLAYGROUND_MASK_fill1:
	ld (hl),#01		;; left border
	inc hl
	ld c,#0a		;; 10 zeros
;;#9c52
SETUP_PLAYGROUND_MASK_fill2:
	ld (hl),#00
	inc hl
	dec c
	jr nz,SETUP_PLAYGROUND_MASK_fill2
	ld (hl),#01		;; right border
	inc hl
	djnz SETUP_PLAYGROUND_MASK_fill1

	ld b,#48
;;#9c5f
SETUP_PLAYGROUND_MASK_pattern:
	ld a,(de)
	inc de
	cp #00
	jr z,SETUP_PLAYGROUND_MASK_copy	;; empty
	ld a,#01	;; occupied
;;#9c67
SETUP_PLAYGROUND_MASK_copy:
	ld (hl),a
	inc hl
	djnz SETUP_PLAYGROUND_MASK_pattern
	ld b,#18
;;#9c6d
SETUP_PLAYGROUND_MASK_bottom:
	ld (hl),#02
	inc hl
	djnz SETUP_PLAYGROUND_MASK_bottom
	ret

;; ----------------------------------
;; Clear play ground bitmap
;; ----------------------------------
;;#9c73
CLEAR_PLAYGND_OFSCR:

	ld hl,PLAYGND_OFSCR
	ld b,#d2
;;#9c78
CLEAR_PLAYGND_OFSCR_loop_h:
	ld c,#14
;;#9c7a
CLEAR_PLAYGND_OFSCR_loop_w:
	ld (hl),#00
	inc hl
	dec c
	jr nz,CLEAR_PLAYGND_OFSCR_loop_w
	djnz CLEAR_PLAYGND_OFSCR_loop_h
	ret

;;
;; Setup playing area bitmap
;;
;;#9c83
SETUP_PLAYGND_OFSCR:
	ld hl,PLAYGND_OFSCR	;; <- playing area bitmap buffer
	;; Clear 20 first lines of 10 blocks
	ld b,#a0
;;#9c88
SETUP_PLAYGND_OFSCR_clear_h:
	ld c,#14
;;#9c8a
SETUP_PLAYGND_OFSCR_clear_w:
	ld (hl),#00
	inc hl
	dec c
	jr nz,SETUP_PLAYGND_OFSCR_clear_w
	djnz SETUP_PLAYGND_OFSCR_clear_h
	
	;; Setup last 6 line with level''s initial pattern
	ld b,#06
;;#9c94
SETUP_PLAYGND_OFSCR_next_line:
	;; skip level pattern''s left border
	inc de		
	;; setup line (10 blocks)
	ld c,#0a
;;#9c97
SETUP_PLAYGND_OFSCR_next_block:
	push bc
	push de
	push hl
	ld b,#08
	ld a,(de)
	cp #00
	jr z,SETUP_PLAYGND_OFSCR_empty
	cp #01
	jr z,SETUP_PLAYGND_OFSCR_block1
	cp #02
	jr z,SETUP_PLAYGND_OFSCR_block2
	cp #03
	jr z,SETUP_PLAYGND_OFSCR_block3
	cp #04
	jr z,SETUP_PLAYGND_OFSCR_block4
	cp #05
	jr z,SETUP_PLAYGND_OFSCR_block5
	cp #06
	jr z,SETUP_PLAYGND_OFSCR_block6
	cp #07
	jr z,SETUP_PLAYGND_OFSCR_block7
	ld de,BLINK_BLOCK_BMP	;; <- single block 8
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9cc2
SETUP_PLAYGND_OFSCR_empty:
	ld de,EMPTY_BLOCK_BMP	;; empty block
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9cc7
SETUP_PLAYGND_OFSCR_block1:
	ld de,PURPLE_BLOCK_BMP	;; single block color 1
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9ccc
SETUP_PLAYGND_OFSCR_block2:
	ld de,RED_BLOCK_BMP	;; single block color 2
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9cd1
SETUP_PLAYGND_OFSCR_block3:
	ld de,ORANGE_BLOCK_BMP	;; single block color 3
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9cd6
SETUP_PLAYGND_OFSCR_block4:
	ld de,YELLOW_BLOCK_BMP	;; single block color 4
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9cdb
SETUP_PLAYGND_OFSCR_block5:
	ld de,GREEN_BLOCK_BMP	;; single block color 5
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9ce0
SETUP_PLAYGND_OFSCR_block6:
	ld de,BLUE_BLOCK_BMP	;; single block color 6
	jr SETUP_PLAYGND_OFSCR_copy_block
;;#9ce5
SETUP_PLAYGND_OFSCR_block7:
	ld de,LBLUE_BLOCK_BMP	;; single block color 7
;;#9ce8
SETUP_PLAYGND_OFSCR_copy_block:
	push bc
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	ld bc,#0013
	add hl,bc
	pop bc
	djnz SETUP_PLAYGND_OFSCR_copy_block

	pop hl
	inc hl
	inc hl
	pop de
	inc de
	pop bc
	dec c
	jr nz,SETUP_PLAYGND_OFSCR_next_block
	;; skip level pattern''s right border
	inc de
	push bc
	ld bc,#008c
	add hl,bc
	pop bc
	djnz SETUP_PLAYGND_OFSCR_next_line
	ret

;; -----------------------------------
;; NEXT SCR LINE (with new screen dimensions)
;; -----------------------------------
;;#9d0a
NXT_SCR_LINE:
	ld bc,#0800
	add hl,bc
	ret nc
	ld bc,#c040
	add hl,bc
	ret

;; -----------------------------------
;; PREV SCR LINE (with screen dimensions)
;; -----------------------------------
;;#9d14
PRV_SCR_LINE:
	ld bc,#f800
	add hl,bc
	ld a,h
	sub #c0
	ret nc
	ld bc,#3fc0
	add hl,bc
	ret

;; -----------------------------------
;; Configure AY-3-8912 Sound generator  
;; -----------------------------------
;;#9d21
CFG_AY_SND:
	di
	push bc
	push af
	ld b,#f4
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
	pop af
	pop bc
	ei
	ret


;; *****************************
;; * Draw ''compressed'' bitmap 
;; *****************************
;; DE: compressed bitmap''s address
;; HL: destination address
;;
;; bitmap format:
;; bmp[0] = number of line
;; bmp[n] = block len
;;      	len   == #FF -> end of line
;;      	len.7 == 0 -> copy block
;;		scr[...] = bmp[n+1 .. n+1+len]
;;       len.7 == 1 -> fill block
;;		scr[...] = bmp[n+1] * (len&7F)
;;               
;;
;;#9d45
DRAW_ZBMP:
	ld a,(de)
	inc de
	ld b,a
;;#9d48
DRAW_ZBMP_line_loop:			
	push bc
	push hl
;;#9d4a
DRAW_ZBMP_block_loop:			
	ld a,(de)
	inc de
	cp #ff
	jp z,DRAW_ZBMP_nxt_line
	bit 7,a
	jr z,DRAW_ZBMP_copy
	res 7,a
;;#9d57
DRAW_ZBMP_fill:
	ld b,a
	ld a,(de)
	inc de
;;#9d5a
DRAW_ZBMP_fill_loop:
	ld (hl),a
	inc hl
	djnz DRAW_ZBMP_fill_loop
	jr DRAW_ZBMP_block_loop
;;#9d60
DRAW_ZBMP_copy:
	ld b,a
;;#9d61
DRAW_ZBMP_copy_loop:
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	djnz DRAW_ZBMP_copy_loop
;#9d67
DRAW_ZBMP_nxt_line:
	pop hl
;;#9d68+1
DRAW_ZBMP_nxt_line_fct equ $ + 1
	call NXT_SCR_LINE
	pop bc
	djnz DRAW_ZBMP_line_loop
	
	ret

;; ------------------------------
;; DRAW Box Top border 
;; HL = scr address
;; C  = box inner width 
;; ------------------------------
;;
;;#9d6f:
BOX_TOP:
	ld de,box_top_pattern
	ld b,#04
;;#9d74
BOX_TOP_line:
	push bc
	push hl
	;; left pattern
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	;; middle pattern
	ld a,(de)
	inc de
;;#9d80
BOX_TOP_middle:
	ld (hl),a
	inc hl
	dec c
	jr nz,BOX_TOP_middle
	;; right pattern
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz BOX_TOP_line
	ret
;; Box Top border pattern
;;#9d94
box_top_pattern:	
	DB	#C0,#0C,#0C,#0C,#C0
	DB	#84,#CC,#CC,#CC,#48
	DB	#4C,#98,#30,#64,#8c
	DB	#4C,#30,#3C,#30,#8C

;; ------------------------------
;; DRAW Box bottom border 
;; HL = screen address
;; C  = box inner width
;; ------------------------------
;;#9da8:
BOX_BOTTOM:
	ld de,box_bottom_pattern
	ld b,#04
;;#9dad
BOX_BOTTOM_line:
	push bc
	push hl
	;; left pattern
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	;; middle pattern
	ld a,(de)
	inc de
;;#9db9
BOX_BOTTOM_middle:
	ld (hl),a
	inc hl
	dec c
	jr nz,BOX_BOTTOM_middle
	;; right pattern
	ld a,(de)
	inc de
	ld (hl),a
	inc hl
	ld a,(de)
	inc de
	ld (hl),a
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz BOX_BOTTOM_line
	ret
;; Botton Horizontal  border pattern
;;#9dcd
box_bottom_pattern:	
	DB	#4C,#30,#3C,#30,#8C
	DB	#4C,#98,#30,#64,#8c
	DB	#84,#CC,#CC,#CC,#48
	DB	#C0,#0C,#0C,#0C,#C0


;; ------------------------------
;; DAW Box side (Vertical) borders
;; HL: screen address
;; C : inner width 
;; B : height
;; ------------------------------
;;
;; pattern #4C,#34, #00... , #38,#8C
;;#9de1:
BOX_SIDES:
	push bc
	push hl
	;; left side
	ld a,#4c
	ld (hl),a
	inc hl
	ld a,#34
	ld (hl),a
	inc hl
	;; middle
	xor a
;;#9dec
BOX_SIDES_side:
	ld (hl),a
	inc hl
	dec c
	jr nz,BOX_SIDES_side
	;; right side
	ld a,#38
	ld (hl),a
	inc hl
	ld a,#8c
	ld (hl),a
	pop hl
	call NXT_SCR_LINE
	pop bc
	djnz BOX_SIDES
	ret

;; Reset the disk rom
DISK_FIX:
	ld hl,(#be7d)	;; Read address of AMSDOS reserved area (should read #a700)
        ld a,(hl)	;; Read currently selected drive
        push af		;; save it
        ld c,7		;; Rom number
        ld de,#40	;; start address
        ld hl,#b0ff	;; end address
        call #bcce	;; Re initialize Disc ROM (7)
        pop af		;; restore selected drive
        or a		
        jp z,MAIN	;; Drive A? do nothing
			;; Drive B? select it again
        rst #18		;; Call ROM routine
        dw DISCB	;; Address of the call structure
	jp MAIN		

DISCB   DW    #CDDD	;; Call address (select drive B)
        DB    7		;; ROM number

END:

	PRINT "BEGIN:",{hex}DATA_ADDR
	PRINT "END  :",{hex}END
	PRINT "START:",{hex}DISK_FIX



	org DATA_ADDR

;;-------------------------------------------------------
;; Alinka''s head bitmap (zbmp) 20x96
;;#400b
ALINKA_HEAD_ZBMP:
	db #60,#89,#00,#81,#05,#81,#0f,#81
	db #2a,#88,#00,#ff,#89,#00,#81,#0f
	db #81,#3c,#81,#0f,#81,#2a,#87,#00
	db #ff,#89,#00,#81,#4b,#81,#16,#81
	db #0f,#81,#0a,#87,#00,#ff,#88,#00
	db #81,#14,#81,#0b,#81,#3c,#81,#2d
	db #81,#1f,#87,#00,#ff,#87,#00,#81
	db #2a,#81,#01,#81,#4b,#81,#16,#81
	db #2d,#81,#0f,#87,#00,#ff,#14,#00
	db #00,#00,#00,#00,#00,#15,#3f,#01
	db #0b,#83,#2d,#0f,#2a,#00,#00,#00
	db #00,#00,#00,#14,#00,#00,#00,#00
	db #00,#00,#05,#0f,#2b,#4b,#16,#3c
	db #0f,#0a,#00,#00,#00,#00,#00,#00
	db #14,#00,#00,#00,#00,#00,#00,#43
	db #3c,#03,#4b,#83,#3c,#0f,#1f,#00
	db #00,#00,#00,#00,#00,#86,#00,#81
	db #07,#81,#1e,#81,#03,#81,#4b,#81
	db #16,#81,#3c,#82,#0f,#86,#00,#ff
	db #86,#00,#81,#07,#82,#29,#81,#0f
	db #81,#83,#81,#3c,#82,#0f,#81,#2a
	db #85,#00,#ff,#14,#00,#00,#00,#00
	db #00,#01,#07,#16,#29,#0f,#43,#16
	db #0f,#0f,#0a,#00,#00,#00,#00,#00
	db #14,#00,#00,#00,#00,#00,#01,#0f
	db #0b,#29,#0f,#83,#3c,#0f,#0f,#1f
	db #00,#00,#00,#00,#00,#14,#00,#00
	db #00,#00,#00,#01,#0f,#16,#29,#0f
	db #c3,#16,#2d,#0f,#0f,#00,#00,#00
	db #00,#00,#14,#00,#00,#00,#00,#00
	db #01,#0f,#0b,#29,#0f,#0b,#3c,#2d
	db #0f,#0f,#2a,#00,#00,#00,#00,#14
	db #00,#00,#00,#00,#00,#01,#0f,#16
	db #29,#0f,#4b,#16,#2d,#0f,#0f,#0a
	db #00,#00,#00,#00,#14,#00,#00,#00
	db #00,#00,#01,#0f,#0b,#f0,#f0,#0b
	db #96,#2d,#0f,#0f,#1f,#00,#00,#00
	db #00,#14,#00,#00,#00,#00,#00,#07
	db #0f,#f0,#f0,#f0,#a5,#16,#2d,#0f
	db #0f,#1f,#00,#00,#00,#00,#85,#00
	db #81,#07,#81,#5a,#84,#f0,#81,#c3
	db #81,#2d,#83,#0f,#84,#00,#ff,#85
	db #00,#81,#07,#85,#f0,#81,#e1,#81
	db #16,#83,#0f,#84,#00,#ff,#85,#00
	db #81,#07,#86,#f0,#81,#96,#83,#0f
	db #84,#00,#ff,#85,#00,#81,#52,#86
	db #f0,#81,#83,#83,#0f,#81,#2a,#83
	db #00,#ff,#85,#00,#81,#52,#86,#f0
	db #81,#a1,#83,#0f,#81,#2a,#83,#00
	db #ff,#85,#00,#87,#f0,#81,#e1,#81
	db #87,#82,#0f,#81,#2a,#83,#00,#ff
	db #85,#00,#88,#f0,#81,#07,#82,#0f
	db #81,#0a,#83,#00,#ff,#85,#00,#88
	db #f0,#81,#87,#82,#0f,#81,#0a,#83
	db #00,#ff,#85,#00,#88,#f0,#81,#07
	db #82,#0f,#81,#0a,#83,#00,#ff,#85
	db #00,#88,#f0,#81,#a5,#82,#0f,#81
	db #1f,#83,#00,#ff,#85,#00,#88,#f0
	db #81,#e1,#82,#0f,#81,#1f,#83,#00
	db #ff,#85,#00,#81,#50,#82,#f0,#81
	db #3c,#81,#78,#83,#f0,#81,#e1,#83
	db #0f,#83,#00,#ff,#14,#00,#00,#00
	db #00,#00,#50,#f0,#f0,#b4,#3c,#f0
	db #f0,#f0,#e1,#0f,#0f,#0f,#2a,#00
	db #00,#85,#00,#81,#a0,#83,#f0,#81
	db #3c,#84,#f0,#83,#0f,#81,#0a,#82
	db #00,#ff,#14,#00,#00,#00,#00,#00
	db #a0,#f0,#f0,#f0,#b4,#78,#f0,#f0
	db #f0,#87,#0f,#0f,#0a,#00,#00,#14
	db #00,#00,#00,#00,#50,#a0,#f0,#f0
	db #f0,#f0,#78,#f0,#f0,#f0,#87,#0f
	db #0f,#1f,#00,#00,#85,#00,#81,#a0
	db #84,#f0,#81,#b4,#83,#f0,#81,#87
	db #83,#0f,#82,#00,#ff,#84,#00,#81
	db #15,#81,#00,#88,#f0,#81,#e1,#83
	db #0f,#82,#00,#ff,#85,#00,#81,#50
	db #85,#f0,#81,#78,#82,#f0,#81,#e1
	db #83,#0f,#81,#2a,#81,#00,#ff,#85
	db #00,#81,#b4,#81,#f0,#81,#b4,#86
	db #f0,#81,#e1,#83,#0f,#81,#0a,#81
	db #00,#ff,#14,#00,#00,#00,#00,#50
	db #78,#f0,#a0,#78,#f0,#f0,#f0,#f0
	db #f0,#f0,#87,#0f,#0f,#1f,#00,#14
	db #00,#00,#00,#00,#b4,#f0,#f0,#b5
	db #14,#f0,#f0,#f0,#f0,#f0,#f0,#87
	db #0f,#0f,#1f,#00,#14,#00,#00,#00
	db #50,#78,#f0,#f0,#a0,#00,#f0,#f0
	db #f0,#f0,#f0,#f0,#87,#0f,#0f,#1f
	db #00,#14,#00,#00,#00,#14,#f0,#f0
	db #f0,#a0,#00,#78,#f0,#f0,#f0,#f0
	db #f0,#4b,#0f,#0f,#0f,#00,#83,#00
	db #85,#f0,#82,#50,#85,#f0,#81,#1f
	db #83,#0f,#81,#00,#ff,#83,#00,#81
	db #78,#85,#f0,#81,#b4,#85,#f0,#81
	db #4b,#83,#0f,#81,#00,#ff,#82,#00
	db #81,#50,#81,#78,#8b,#f0,#84,#0f
	db #81,#00,#ff,#82,#00,#81,#50,#81
	db #78,#8a,#f0,#81,#e1,#81,#0f,#81
	db #2f,#82,#0f,#81,#2a,#ff,#82,#00
	db #81,#f0,#81,#78,#8a,#f0,#81,#e1
	db #81,#0f,#81,#87,#82,#0f,#81,#2a
	db #ff,#82,#00,#81,#f0,#82,#b4,#89
	db #f0,#81,#e1,#81,#0f,#81,#1f,#82
	db #0f,#81,#2a,#ff,#82,#00,#82,#f0
	db #81,#b4,#89,#f0,#81,#a5,#84,#0f
	db #81,#2a,#ff,#81,#00,#81,#50,#8c
	db #f0,#81,#a5,#84,#0f,#81,#2a,#ff
	db #81,#00,#81,#50,#8c,#f0,#81,#a5
	db #84,#0f,#81,#2a,#ff,#81,#00,#81
	db #50,#8c,#f0,#81,#a5,#84,#0f,#81
	db #2a,#ff,#81,#00,#81,#50,#8c,#f0
	db #81,#87,#84,#0f,#81,#2a,#ff,#81
	db #00,#8d,#f0,#81,#a5,#84,#0f,#81
	db #2a,#ff,#81,#00,#8d,#f0,#81,#87
	db #84,#0f,#81,#00,#ff,#81,#00,#81
	db #f0,#81,#f4,#81,#f8,#8a,#f0,#81
	db #87,#84,#0f,#81,#00,#ff,#81,#00
	db #81,#f0,#82,#fc,#8a,#f0,#85,#0f
	db #81,#00,#ff,#81,#00,#81,#f0,#82
	db #fc,#8a,#f0,#81,#87,#84,#0f,#81
	db #00,#ff,#81,#00,#81,#f0,#81,#a8
	db #81,#54,#81,#f8,#89,#f0,#81,#87
	db #84,#0f,#81,#00,#ff,#81,#00,#81
	db #f0,#81,#a8,#81,#54,#81,#f8,#89
	db #f0,#84,#0f,#81,#1f,#81,#00,#ff
	db #81,#00,#81,#f0,#82,#00,#81,#f8
	db #89,#f0,#81,#a5,#83,#0f,#81,#1f
	db #81,#00,#ff,#81,#00,#81,#f0,#82
	db #00,#81,#fc,#8a,#f0,#81,#3c,#82
	db #0f,#81,#1f,#81,#00,#ff,#14,#00
	db #f0,#00,#00,#54,#f0,#f0,#f0,#f0
	db #f0,#f0,#f0,#f0,#f0,#b4,#f0,#0f
	db #0f,#1f,#00,#81,#00,#81,#f0,#82
	db #00,#81,#54,#8b,#f0,#81,#2d,#81
	db #0f,#81,#1f,#81,#00,#ff,#14,#00
	db #f0,#fc,#a8,#00,#f8,#f0,#f0,#f0
	db #f0,#f0,#f0,#f0,#f0,#78,#f0,#2d
	db #0f,#0a,#00,#14,#00,#f0,#fc,#fc
	db #a8,#f8,#f0,#f0,#f0,#f0,#f0,#f0
	db #f0,#f0,#f0,#f0,#a5,#0f,#0a,#00
	db #81,#00,#81,#f0,#83,#fc,#8b,#f0
	db #81,#b4,#81,#0f,#81,#0a,#81,#00
	db #ff,#81,#00,#81,#f0,#81,#f4,#8c
	db #f0,#82,#b4,#81,#0f,#81,#0a,#81
	db #00,#ff,#81,#00,#8e,#f0,#82,#b4
	db #81,#0f,#81,#2a,#81,#00,#ff,#81
	db #00,#8e,#f0,#82,#b4,#81,#0f,#81
	db #2a,#81,#00,#ff,#81,#00,#8d,#f0
	db #83,#b4,#81,#0f,#81,#2a,#81,#00
	db #ff,#81,#00,#8d,#f0,#81,#3c,#81
	db #b4,#81,#a5,#81,#0f,#82,#00,#ff
	db #81,#00,#8d,#f0,#81,#78,#81,#f0
	db #81,#2d,#81,#1f,#82,#00,#ff,#81
	db #00,#8d,#f0,#82,#78,#81,#2d,#81
	db #0a,#82,#00,#ff,#81,#00,#8d,#f0
	db #81,#b4,#81,#f0,#81,#0f,#81,#2a
	db #82,#00,#ff,#81,#00,#8e,#f0,#81
	db #b4,#81,#0f,#83,#00,#ff,#81,#00
	db #8c,#f0,#81,#0c,#81,#f0,#81,#a5
	db #81,#1f,#83,#00,#ff,#81,#00,#8b
	db #f0,#81,#a4,#81,#64,#81,#58,#81
	db #2d,#81,#2a,#83,#00,#ff,#81,#00
	db #81,#50,#8a,#f0,#81,#04,#81,#3a
	db #81,#1c,#81,#0f,#84,#00,#ff,#14
	db #00,#50,#f0,#f0,#f0,#f0,#f0,#f0
	db #f0,#f0,#a0,#00,#04,#64,#58,#0a
	db #00,#00,#00,#00,#82,#00,#87,#f0
	db #81,#a0,#83,#00,#81,#0c,#81,#2f
	db #85,#00,#ff,#82,#00,#81,#50,#84
	db #f0,#83,#00,#82,#f0,#88,#00,#ff
	db #87,#00,#81,#50,#85,#f0,#87,#00
	db #ff,#84,#00,#81,#50,#88,#f0,#81
	db #a0,#86,#00,#ff,#84,#00,#89,#f0
	db #81,#a0,#86,#00,#ff,#84,#00,#89
	db #f0,#81,#a0,#86,#00,#ff,#84,#00
	db #89,#f0,#81,#a0,#86,#00,#ff,#84
	db #00,#89,#f0,#81,#a0,#86,#00,#ff
	db #84,#00,#89,#f0,#81,#a0,#86,#00
	db #ff,#84,#00,#89,#f0,#81,#a0,#86
	db #00,#ff,#84,#00,#89,#f0,#81,#a0
	db #86,#00,#ff,#84,#00,#89,#f0,#81
	db #a0,#86,#00,#ff,#84,#00,#89,#f0
	db #81,#a0,#86,#00,#ff,#84,#00,#81
	db #50,#88,#f0,#87,#00,#ff,#85,#00
	db #88,#f0,#87,#00,#ff,#86,#00,#87
	db #f0,#87,#00,#ff,#87,#00,#85,#f0
	db #81,#a0,#87,#00,#ff
;;-------------------------------------------------------
;; Large Kozak dancer (zbmp)	      20x96
;;#45e0
KOZAK_DANCER_ZBMP:
	db #60,#94,#00,#ff,#94,#00,#ff,#94
	db #00,#ff,#94,#00,#ff,#94,#00,#ff
	db #94,#00,#ff,#94,#00,#ff,#94,#00
	db #ff,#94,#00,#ff,#94,#00,#ff,#94
	db #00,#ff,#94,#00,#ff,#94,#00,#ff
	db #94,#00,#ff,#94,#00,#ff,#94,#00
	db #ff,#94,#00,#ff,#94,#00,#ff,#94
	db #00,#ff,#94,#0c,#ff,#94,#00,#ff
	db #94,#00,#ff,#94,#0c,#ff,#94,#00
	db #ff,#94,#0c,#ff,#94,#0c,#ff,#94
	db #00,#ff,#94,#0c,#ff,#94,#0c,#ff
	db #94,#0c,#ff,#94,#0c,#ff,#94,#0c
	db #ff,#81,#a4,#93,#0c,#ff,#81,#f0
	db #93,#0c,#ff,#81,#f0,#81,#a4,#81
	db #0c,#81,#f0,#90,#0c,#ff,#81,#58
	db #81,#f0,#81,#58,#81,#f0,#90,#0c
	db #ff,#81,#58,#82,#f0,#81,#a4,#85
	db #0c,#81,#00,#8a,#0c,#ff,#81,#0c
	db #82,#f0,#85,#0c,#81,#08,#81,#00
	db #81,#04,#89,#0c,#ff,#81,#0c,#82
	db #f0,#85,#0c,#81,#08,#82,#00,#89
	db #0c,#ff,#81,#0c,#81,#58,#81,#f0
	db #85,#0c,#83,#00,#81,#04,#88,#0c
	db #ff,#82,#0c,#82,#fc,#84,#0c,#84
	db #00,#88,#0c,#ff,#82,#0c,#82,#fc
	db #84,#0c,#84,#00,#81,#04,#87,#0c
	db #ff,#14,#0c,#0c,#fc,#3c,#0c,#0c
	db #0c,#0c,#00,#00,#00,#00,#04,#0c
	db #0c,#fc,#5c,#ac,#0c,#0c,#82,#0c
	db #81,#fc,#81,#3c,#84,#0c,#85,#00
	db #81,#0c,#81,#5c,#83,#fc,#82,#0c
	db #ff,#82,#0c,#82,#3c,#84,#0c,#85
	db #00,#81,#0c,#81,#5c,#81,#bd,#82
	db #fc,#82,#0c,#ff,#82,#0c,#82,#3c
	db #84,#0c,#85,#00,#81,#0c,#81,#5c
	db #83,#fc,#82,#0c,#ff,#14,#0c,#0c
	db #3c,#3c,#2c,#0c,#0c,#0c,#00,#00
	db #00,#00,#04,#0c,#5c,#fc,#fc,#fc
	db #0c,#0c,#14,#0c,#0c,#3c,#3c,#2c
	db #0c,#0c,#0c,#00,#00,#00,#00,#04
	db #0c,#5c,#fc,#fc,#fc,#0c,#0c,#14
	db #0c,#0c,#3c,#3c,#2c,#0c,#0c,#0c
	db #f0,#2e,#00,#00,#04,#0c,#0c,#fc
	db #fc,#ac,#0c,#0c,#14,#0c,#0c,#3c
	db #3c,#2c,#0c,#0c,#0c,#f0,#0c,#00
	db #00,#0c,#0c,#0c,#fc,#fc,#ac,#0c
	db #0c,#14,#0c,#0c,#3c,#3c,#3c,#0c
	db #0c,#0c,#f0,#f0,#2e,#00,#0c,#0c
	db #0c,#5c,#fc,#0c,#0c,#0c,#14,#0c
	db #0c,#3c,#3c,#3c,#0c,#0c,#0c,#f0
	db #f0,#0c,#04,#0c,#0c,#0c,#5c,#fc
	db #0c,#0c,#0c,#82,#0c,#83,#3c,#83
	db #0c,#83,#f0,#85,#0c,#81,#ac,#83
	db #0c,#ff,#82,#0c,#83,#3c,#81,#2c
	db #81,#0c,#81,#04,#81,#f0,#81,#78
	db #81,#f0,#89,#0c,#ff,#82,#0c,#81
	db #1c,#82,#3c,#81,#2c,#81,#0c,#82
	db #00,#81,#3c,#81,#f0,#89,#0c,#ff
	db #82,#0c,#81,#1c,#82,#3c,#81,#2c
	db #81,#0c,#81,#08,#82,#00,#81,#a4
	db #89,#0c,#ff,#82,#0c,#81,#1c,#83
	db #3c,#81,#2c,#81,#0c,#81,#f0,#81
	db #00,#81,#04,#89,#0c,#ff,#83,#0c
	db #84,#3c,#81,#0c,#81,#f0,#81,#a0
	db #81,#00,#81,#04,#88,#0c,#ff,#83
	db #0c,#85,#3c,#81,#50,#81,#f0,#81
	db #08,#81,#04,#88,#0c,#ff,#83,#0c
	db #85,#3c,#81,#00,#81,#a4,#8a,#0c
	db #ff,#83,#0c,#85,#3c,#81,#00,#81
	db #14,#8a,#0c,#ff,#83,#0c,#85,#3c
	db #81,#28,#81,#3c,#8a,#0c,#ff,#83
	db #0c,#81,#1c,#86,#3c,#81,#2c,#89
	db #0c,#ff,#84,#0c,#87,#3c,#81,#2c
	db #88,#0c,#ff,#84,#0c,#81,#1c,#87
	db #3c,#88,#0c,#ff,#85,#0c,#87,#3c
	db #81,#2c,#87,#0c,#ff,#85,#0c,#81
	db #14,#87,#3c,#87,#0c,#ff,#85,#0c
	db #81,#08,#87,#3c,#81,#2c,#86,#0c
	db #ff,#82,#0c,#82,#3c,#82,#0c,#81
	db #14,#87,#3c,#86,#0c,#ff,#82,#0c
	db #83,#3c,#81,#0c,#81,#00,#87,#3c
	db #81,#2c,#85,#0c,#ff,#81,#30,#81
	db #35,#81,#3e,#83,#3c,#82,#00,#87
	db #3c,#85,#30,#ff,#81,#30,#82,#3f
	db #83,#3c,#81,#28,#82,#00,#86,#3c
	db #81,#38,#84,#30,#ff,#14,#00,#3f
	db #3f,#3e,#3c,#3c,#3c,#00,#00,#14
	db #3c,#3c,#3c,#3c,#3c,#7c,#c0,#f0
	db #f0,#00,#14,#00,#3f,#3f,#3e,#3c
	db #3c,#3c,#3c,#00,#00,#3c,#3c,#3c
	db #3c,#3c,#fc,#d0,#f0,#f0,#00,#14
	db #00,#3f,#3f,#fc,#3c,#3c,#3c,#3c
	db #3c,#00,#00,#14,#3c,#3c,#3c,#fc
	db #f0,#f0,#00,#00,#14,#00,#3f,#3f
	db #fc,#3c,#3c,#3c,#3c,#3c,#28,#3c
	db #68,#3c,#3c,#3c,#fc,#f0,#f0,#a0
	db #00,#14,#00,#3f,#fc,#fc,#3c,#3c
	db #3c,#3c,#3c,#3c,#3c,#3f,#94,#3c
	db #3c,#fc,#f0,#f0,#f0,#00,#14,#00
	db #3f,#fc,#fc,#3c,#3c,#3c,#3c,#3c
	db #3c,#3c,#3f,#6a,#3c,#3c,#fc,#f0
	db #f0,#a1,#a0,#14,#00,#3f,#fc,#fc
	db #bc,#3c,#3c,#3c,#3c,#3c,#3d,#3f
	db #3f,#94,#3c,#00,#00,#50,#52,#52
	db #14,#00,#15,#fc,#fc,#bc,#3c,#3c
	db #3c,#3c,#3c,#3d,#3f,#3f,#6a,#3c
	db #00,#00,#00,#a1,#a1,#81,#00,#81
	db #15,#82,#fc,#81,#bc,#85,#3c,#81
	db #3d,#83,#3f,#85,#00,#81,#52,#ff
	db #82,#00,#83,#fc,#85,#3c,#84,#3f
	db #81,#2a,#85,#00,#ff,#14,#00,#00
	db #54,#fc,#fc,#3c,#3c,#3c,#3c,#3c
	db #3f,#3f,#3f,#7e,#fc,#00,#00,#14
	db #00,#00,#14,#00,#00,#54,#fc,#fc
	db #3c,#3c,#3c,#3c,#3c,#3f,#3f,#3f
	db #fc,#fc,#a8,#00,#3c,#28,#00,#14
	db #00,#00,#00,#fc,#fc,#bc,#3c,#3c
	db #3c,#28,#3f,#3f,#3f,#fc,#fc,#fc
	db #00,#3c,#3c,#00,#83,#00,#83,#fc
	db #83,#3c,#81,#00,#83,#3f,#83,#fc
	db #81,#a8,#82,#3c,#81,#00,#ff,#83
	db #00,#81,#54,#82,#fc,#85,#00,#82
	db #3f,#84,#fc,#82,#3c,#81,#00,#ff
	db #84,#00,#82,#fc,#81,#28,#85,#00
	db #81,#3f,#84,#fc,#82,#3c,#81,#00
	db #ff,#82,#00,#84,#3c,#81,#28,#86
	db #00,#84,#fc,#82,#3c,#81,#00,#ff
	db #81,#00,#81,#14,#84,#3c,#81,#28
	db #86,#00,#84,#fc,#82,#3c,#81,#00
	db #ff,#81,#00,#85,#3c,#81,#28,#86
	db #00,#81,#54,#83,#fc,#82,#3c,#81
	db #00,#ff,#81,#00,#85,#3c,#81,#28
	db #87,#00,#83,#fc,#82,#3c,#81,#00
	db #ff,#81,#00,#85,#3c,#81,#28,#88
	db #00,#82,#fc,#82,#3c,#81,#00,#ff
	db #81,#00,#85,#3c,#8a,#00,#81,#fc
	db #82,#3c,#81,#00,#ff,#81,#00,#81
	db #14,#83,#3c,#8c,#00,#82,#3c,#81
	db #00,#ff,#82,#00,#82,#3c,#8d,#00
	db #81,#3c,#81,#28,#81,#00,#ff
;;-------------------------------------------------------
;;Dancing Kozak going out 4x23 (only 4x22 is displayed) 
;;#4a3f
KOZAK_OUT_BMP:
	db #34,#0c,#0c,#0c,#34,#3c,#0c,#0c
	db #34,#3c,#2c,#0c,#34,#3c,#3c,#0c
	db #34,#3c,#3c,#0c,#20,#2c,#3c,#0c
	db #34,#04,#3c,#0c,#34,#2c,#5c,#0c
	db #34,#2c,#58,#a4,#34,#2c,#58,#a4
	db #34,#2c,#58,#0c,#34,#28,#30,#38
	db #20,#14,#7c,#28,#34,#3c,#7c,#28
	db #34,#3c,#7c,#28,#34,#3c,#7c,#3c
	db #34,#3c,#7c,#3c,#20,#3c,#7e,#14
	db #20,#3f,#3f,#14,#20,#15,#3f,#2a
	db #20,#15,#3f,#2a,#20,#00,#3f,#2a
	db #20,#00,#3f,#00
;;-------------------------------------------------------
;; Dancing Kozak coming in 4x25
;;#4a9b
KOZAK_IN_BMP:
	db #24,#00,#04,#0c,#20,#00,#50,#0c
	db #20,#00,#14,#0c,#20,#00,#50,#0c
	db #20,#00,#04,#0c,#34,#50,#a4,#0c
	db #34,#e0,#84,#0c,#34,#f0,#a4,#0c
	db #34,#f0,#a4,#0c,#34,#3d,#2e,#0c
	db #34,#3d,#0c,#0c,#34,#3c,#0c,#0c
	db #34,#2c,#2e,#0c,#20,#15,#3f,#0c
	db #34,#3f,#3f,#0c,#34,#3f,#3f,#0c
	db #34,#3f,#bd,#0c,#35,#7e,#ac,#0c
	db #35,#5c,#ac,#0c,#24,#5c,#0c,#0c
	db #24,#fc,#5c,#2c,#24,#fc,#bc,#2c
	db #30,#fc,#3c,#38,#20,#bc,#3c,#00
	db #20,#3c,#00,#00
;;-------------------------------------------------------
;; Alinka game title (64x33)
;;#4aff
GAME_TITLE_ZBMP:
	db #21,#81,#c0,#9b,#3f,#81,#2b,#81
	db #03,#a1,#3f,#81,#c0,#ff,#81,#95
	db #9b,#3f,#82,#03,#81,#17,#a0,#3f
	db #81,#6a,#ff,#81,#95,#81,#3f,#84
	db #00,#81,#3c,#94,#00,#81,#01,#81
	db #43,#81,#83,#81,#56,#9a,#00,#81
	db #3c,#84,#00,#81,#3f,#81,#6a,#ff
	db #81,#3f,#81,#2a,#83,#00,#81,#14
	db #81,#3c,#81,#28,#93,#00,#81,#01
	db #81,#43,#81,#6b,#81,#56,#99,#00
	db #81,#14,#81,#3c,#81,#28,#83,#00
	db #81,#15,#81,#3f,#ff,#81,#3f,#81
	db #2a,#83,#00,#81,#14,#82,#3c,#93
	db #00,#81,#01,#81,#43,#81,#83,#81
	db #56,#99,#00,#82,#3c,#81,#28,#83
	db #00,#81,#15,#81,#3f,#ff,#81,#3f
	db #84,#00,#81,#14,#82,#3c,#93,#00
	db #81,#54,#82,#03,#81,#fc,#99,#00
	db #82,#3c,#81,#28,#84,#00,#81,#3f
	db #ff,#81,#30,#84,#00,#81,#14,#82
	db #3c,#94,#00,#81,#a9,#81,#56,#81
	db #fc,#99,#00,#82,#3c,#81,#28,#84
	db #00,#81,#30,#ff,#81,#3f,#84,#00
	db #81,#50,#81,#94,#81,#3c,#94,#00
	db #82,#fc,#81,#a8,#99,#00,#81,#3c
	db #81,#68,#81,#a0,#84,#00,#81,#3f
	db #ff,#81,#3f,#84,#00,#81,#50,#81
	db #e0,#81,#28,#94,#00,#81,#54,#81
	db #fc,#9a,#00,#81,#14,#81,#d0,#81
	db #a0,#84,#00,#81,#3f,#ff,#81,#2a
	db #84,#00,#81,#50,#81,#78,#86,#00
	db #84,#cc,#81,#00,#81,#44,#81,#cc
	db #86,#00,#86,#cc,#81,#44,#81,#cc
	db #82,#00,#81,#44,#81,#cc,#81,#00
	db #81,#44,#81,#88,#87,#00,#84,#cc
	db #85,#00,#81,#b4,#81,#a0,#84,#00
	db #81,#15,#ff,#40,#20,#00,#00,#14
	db #28,#15,#f0,#00,#00,#00,#00,#00
	db #44,#3a,#30,#30,#30,#08,#98,#30
	db #88,#00,#00,#00,#00,#44,#30,#30
	db #30,#30,#30,#64,#98,#30,#88,#00
	db #98,#30,#88,#98,#64,#00,#00,#00
	db #cc,#00,#00,#44,#3a,#30,#30,#30
	db #08,#00,#00,#00,#00,#f0,#2a,#14
	db #28,#00,#00,#10,#40,#2a,#00,#00
	db #3c,#3c,#15,#2a,#00,#00,#00,#00
	db #00,#9d,#30,#0c,#18,#3f,#24,#98
	db #3a,#88,#00,#00,#00,#00,#44,#24
	db #0c,#35,#3f,#24,#0c,#98,#30,#88
	db #00,#98,#3a,#24,#98,#6e,#00,#00
	db #44,#30,#08,#00,#9d,#30,#0c,#18
	db #3f,#24,#00,#00,#00,#00,#15,#2a
	db #3c,#3c,#00,#00,#15,#40,#20,#00
	db #00,#3c,#3c,#28,#2a,#00,#00,#00
	db #00,#00,#98,#24,#00,#04,#35,#24
	db #98,#3a,#64,#00,#00,#00,#00,#98
	db #08,#00,#18,#3a,#08,#00,#98,#3a
	db #64,#00,#44,#35,#24,#9d,#6e,#00
	db #00,#44,#30,#08,#00,#98,#24,#00
	db #04,#35,#24,#00,#00,#00,#00,#15
	db #14,#3c,#3c,#00,#00,#10,#40,#20
	db #00,#00,#14,#7c,#a8,#28,#00,#00
	db #00,#00,#44,#30,#08,#00,#00,#98
	db #24,#98,#35,#64,#00,#00,#00,#00
	db #98,#08,#00,#98,#24,#00,#00,#98
	db #3f,#64,#00,#00,#9d,#24,#98,#6e
	db #00,#00,#98,#3a,#08,#44,#30,#08
	db #00,#00,#98,#24,#00,#00,#00,#00
	db #14,#54,#bc,#28,#00,#00,#10,#40
	db #20,#00,#00,#14,#7c,#f0,#3c,#00
	db #00,#00,#00,#44,#24,#00,#00,#00
	db #98,#24,#44,#30,#64,#00,#00,#00
	db #00,#0c,#00,#44,#30,#08,#00,#00
	db #98,#3f,#30,#88,#00,#98,#24,#44
	db #64,#00,#00,#9d,#24,#00,#44,#24
	db #00,#00,#00,#98,#24,#00,#00,#00
	db #00,#3c,#f0,#bc,#28,#00,#00,#10
	db #40,#20,#00,#00,#00,#7c,#f0,#b4
	db #28,#00,#00,#00,#98,#24,#00,#00
	db #00,#98,#24,#00,#98,#64,#00,#00
	db #00,#00,#00,#00,#98,#30,#08,#00
	db #00,#98,#3a,#30,#88,#00,#98,#24
	db #44,#30,#88,#44,#35,#24,#00,#98
	db #24,#00,#00,#00,#98,#24,#00,#00
	db #00,#14,#78,#f0,#bc,#00,#00,#00
	db #10,#40,#88,#00,#00,#00,#f0,#f4
	db #f0,#3c,#00,#00,#00,#98,#24,#00
	db #00,#00,#98,#24,#00,#98,#64,#00
	db #00,#00,#00,#00,#00,#98,#24,#00
	db #00,#00,#98,#30,#35,#64,#00,#98
	db #24,#44,#30,#88,#44,#3a,#08,#00
	db #98,#24,#00,#00,#00,#98,#24,#00
	db #00,#00,#3c,#f0,#f8,#f0,#00,#00
	db #00,#44,#40,#20,#00,#14,#28,#00
	db #f4,#3c,#3c,#00,#00,#00,#98,#24
	db #00,#00,#00,#98,#24,#00,#98,#64
	db #00,#00,#00,#00,#00,#00,#98,#24
	db #00,#00,#00,#98,#30,#18,#64,#00
	db #98,#24,#44,#30,#88,#98,#30,#08
	db #00,#98,#24,#00,#00,#00,#98,#24
	db #00,#00,#00,#3c,#3c,#f8,#00,#14
	db #28,#00,#10,#40,#88,#00,#3f,#3c
	db #3c,#00,#3c,#3c,#00,#00,#00,#98
	db #3a,#cc,#cc,#cc,#35,#24,#00,#98
	db #64,#00,#00,#00,#00,#00,#00,#98
	db #24,#00,#00,#00,#98,#30,#18,#3a
	db #88,#98,#24,#44,#30,#64,#30,#24
	db #00,#00,#98,#3a,#cc,#cc,#cc,#35
	db #24,#00,#00,#00,#3c,#3c,#00,#3c
	db #3c,#3f,#00,#44,#40,#88,#00,#3f
	db #3e,#3c,#3c,#14,#28,#00,#00,#00
	db #98,#3f,#30,#30,#30,#3f,#24,#00
	db #98,#64,#00,#00,#00,#00,#00,#00
	db #98,#24,#00,#00,#00,#98,#24,#04
	db #30,#88,#98,#24,#44,#35,#30,#30
	db #24,#00,#00,#98,#3f,#30,#30,#30
	db #3f,#24,#00,#00,#00,#14,#28,#3c
	db #3c,#3d,#3f,#00,#44,#40,#88,#00
	db #3f,#bc,#3c,#3c,#28,#00,#00,#00
	db #00,#98,#30,#0c,#0c,#18,#35,#24
	db #00,#98,#64,#00,#00,#00,#00,#00
	db #00,#98,#24,#00,#00,#00,#98,#24
	db #04,#35,#64,#30,#24,#44,#35,#3a
	db #30,#08,#00,#00,#98,#30,#0c,#0c
	db #18,#35,#24,#00,#00,#00,#00,#14
	db #3c,#3c,#7c,#3f,#00,#44,#40,#88
	db #00,#7e,#bc,#3c,#3c,#3c,#2a,#00
	db #00,#00,#98,#24,#00,#00,#44,#30
	db #24,#00,#98,#64,#00,#00,#00,#00
	db #00,#00,#98,#24,#00,#00,#00,#98
	db #24,#00,#18,#64,#30,#24,#44,#35
	db #30,#30,#08,#00,#00,#98,#24,#00
	db #00,#44,#30,#24,#00,#00,#00,#15
	db #3c,#3c,#3c,#7c,#bd,#00,#44,#40
	db #08,#00,#7e,#fc,#3c,#3c,#3d,#3f
	db #00,#00,#00,#98,#24,#00,#00,#00
	db #98,#24,#00,#98,#64,#00,#00,#00
	db #00,#00,#00,#98,#24,#00,#00,#00
	db #98,#24,#00,#18,#3a,#30,#24,#44
	db #30,#24,#18,#24,#00,#00,#98,#24
	db #00,#00,#00,#98,#24,#00,#00,#00
	db #3f,#3e,#3c,#3c,#fc,#bd,#00,#04
	db #40,#88,#00,#54,#fc,#3c,#3c,#3d
	db #3f,#2a,#00,#00,#98,#24,#00,#00
	db #00,#98,#24,#44,#30,#30,#08,#00
	db #04,#08,#00,#00,#98,#30,#88,#00
	db #00,#98,#24,#00,#04,#30,#35,#24
	db #44,#30,#24,#04,#30,#08,#00,#98
	db #24,#00,#00,#00,#98,#24,#00,#00
	db #15,#3f,#3e,#3c,#3c,#fc,#a8,#00
	db #44,#40,#08,#00,#00,#fc,#3c,#3c
	db #3d,#3f,#fc,#00,#28,#98,#30,#08
	db #00,#00,#98,#24,#98,#35,#30,#24
	db #0c,#18,#24,#00,#00,#04,#30,#88
	db #00,#cc,#98,#24,#00,#04,#30,#3f
	db #24,#98,#30,#08,#04,#35,#24,#00
	db #98,#30,#08,#00,#00,#98,#24,#14
	db #00,#fc,#3f,#3e,#3c,#3c,#fc,#00
	db #00,#04,#40,#0c,#00,#00,#fc,#bc
	db #3c,#15,#3f,#fc,#a8,#3c,#98,#3a
	db #24,#00,#00,#98,#24,#98,#35,#3f
	db #30,#30,#30,#24,#00,#00,#00,#18
	db #64,#44,#24,#98,#30,#08,#00,#18
	db #3f,#24,#9d,#3a,#08,#00,#18,#3a
	db #08,#98,#3a,#24,#00,#00,#98,#24
	db #3c,#54,#fc,#3f,#2a,#3c,#7c,#fc
	db #00,#00,#0c,#40,#0c,#00,#00,#54
	db #a8,#00,#00,#15,#fc,#fc,#3c,#44
	db #3f,#24,#00,#00,#98,#24,#98,#3f
	db #30,#30,#30,#3f,#24,#00,#00,#00
	db #18,#3a,#98,#2e,#98,#3a,#24,#00
	db #18,#35,#24,#9d,#24,#00,#00,#18
	db #35,#24,#44,#3f,#24,#00,#00,#98
	db #24,#3c,#fc,#fc,#2a,#00,#00,#54
	db #a8,#00,#00,#0c,#40,#cc,#00,#14
	db #3c,#28,#00,#00,#00,#fc,#fc,#3c
	db #44,#30,#24,#00,#00,#98,#24,#98
	db #3a,#24,#0c,#0c,#35,#24,#cc,#cc
	db #cc,#35,#3a,#30,#24,#98,#3f,#24
	db #00,#04,#30,#24,#98,#24,#00,#00
	db #04,#35,#24,#44,#30,#24,#00,#00
	db #98,#24,#3c,#fc,#fc,#00,#00,#00
	db #14,#3c,#28,#00,#cc,#40,#0c,#00
	db #3c,#3c,#28,#00,#00,#00,#54,#fc
	db #3c,#44,#30,#08,#00,#00,#98,#24
	db #98,#30,#08,#00,#00,#18,#24,#98
	db #30,#30,#30,#30,#30,#08,#04,#30
	db #24,#00,#04,#30,#24,#98,#24,#00
	db #00,#04,#30,#24,#44,#30,#08,#00
	db #00,#98,#24,#3c,#fc,#a8,#00,#00
	db #00,#14,#3c,#3c,#00,#0c,#40,#0c
	db #08,#3c,#3c,#28,#00,#00,#00,#00
	db #54,#3c,#00,#0c,#00,#00,#00,#04
	db #08,#04,#0c,#00,#00,#00,#04,#08
	db #0c,#0c,#0c,#0c,#0c,#0c,#00,#00
	db #0c,#08,#00,#00,#0c,#08,#04,#08
	db #00,#00,#00,#0c,#08,#00,#0c,#00
	db #00,#00,#04,#08,#3c,#a8,#00,#00
	db #00,#00,#14,#3c,#3c,#04,#0c,#81
	db #0c,#81,#08,#81,#14,#81,#28,#86
	db #00,#81,#3c,#aa,#00,#81,#3c,#86
	db #00,#81,#14,#81,#28,#81,#04,#81
	db #0c,#ff,#81,#84,#81,#0c,#bc,#00
	db #81,#0c,#81,#48,#ff,#81,#84,#be
	db #0c,#81,#48,#ff
;;---------------------------------------------------------
;; Piece_1_1: reversed L (6x16)
;;
;;
;; 	XXX
;; 	X
;;
;;#5163
PIECE_1_1_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
	db #3f,#3f,#3f,#2e,#6a,#c0,#c0,#c0
	db #c0,#84,#6a,#c0,#c0,#c0,#c0,#84
	db #6a,#c0,#c0,#c0,#c0,#84,#6a,#c0
	db #c0,#c0,#c0,#84,#6a,#c0,#0c,#0c
	db #0c,#0c,#6a,#84,#0c,#0c,#0c,#0c
	db #6a,#84,#00,#00,#00,#00,#6a,#84
	db #00,#00,#00,#00,#6a,#84,#00,#00
	db #00,#00,#6a,#84,#00,#00,#00,#00
	db #6a,#84,#00,#00,#00,#00,#6a,#84
	db #00,#00,#00,#00,#2e,#0c,#00,#00
	db #00,#00,#0c,#0c,#00,#00,#00,#00
;;---------------------------------------------------------
;; Piece_1_2: reversed L (4x24)
;;
;; 	X
;; 	X
;;	XX
;;
;;#51c3
PIECE_1_2_BMP:
	db #3f,#3f,#00,#00,#3f,#2e,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#00,#00,#6a,#84,#00,#00
	db #6a,#84,#3f,#3f,#6a,#c0,#3f,#2e
	db #6a,#c0,#c0,#84,#6a,#c0,#c0,#84
	db #6a,#c0,#c0,#84,#6a,#c0,#c0,#84
	db #2e,#0c,#0c,#0c,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_1_3: reversed L (6x16)
;;	
;;
;; 	  X
;; 	XXX
;; 
;;#5223
PIECE_1_3_BMP:
	db #00,#00,#00,#00,#3f,#3f,#00,#00
	db #00,#00,#3f,#2e,#00,#00,#00,#00
	db #6a,#84,#00,#00,#00,#00,#6a,#84
	db #00,#00,#00,#00,#6a,#84,#00,#00
	db #00,#00,#6a,#84,#00,#00,#00,#00
	db #6a,#84,#00,#00,#00,#00,#6a,#84
	db #3f,#3f,#3f,#3f,#6a,#84,#3f,#3f
	db #3f,#3f,#c0,#84,#6a,#c0,#c0,#c0
	db #c0,#84,#6a,#c0,#c0,#c0,#c0,#84
	db #6a,#c0,#c0,#c0,#c0,#84,#6a,#c0
	db #c0,#c0,#c0,#84,#2e,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_1_4: reversed L (4x24)
;;
;; 	XX
;; 	 X
;;	 X
;;
;;#5283
PIECE_1_4_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#2e
	db #6a,#c0,#c0,#84,#6a,#c0,#c0,#84
	db #6a,#c0,#c0,#84,#6a,#c0,#c0,#84
	db #2e,#0c,#c0,#84,#0c,#0c,#48,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#6a,#84,#00,#00,#6a,#84
	db #00,#00,#2e,#0c,#00,#00,#0c,#0c

;;---------------------------------------------------------
;; Piece_2_1:  L (6x16)
;;
;;
;; 	XXX
;; 	  X
;;	
;;#52e3
PIECE_2_1_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
	db #3f,#3f,#3f,#2e,#2b,#03,#03,#03
	db #03,#06,#2b,#03,#03,#03,#03,#06
	db #2b,#03,#03,#03,#03,#06,#2b,#03
	db #03,#03,#03,#06,#2e,#0c,#0c,#0c
	db #03,#06,#0c,#0c,#0c,#0c,#09,#06
	db #00,#00,#00,#00,#2b,#06,#00,#00
	db #00,#00,#2b,#06,#00,#00,#00,#00
	db #2b,#06,#00,#00,#00,#00,#2b,#06
	db #00,#00,#00,#00,#2b,#06,#00,#00
	db #00,#00,#2b,#06,#00,#00,#00,#00
	db #2e,#0c,#00,#00,#00,#00,#0c,#0c
;;---------------------------------------------------------
;; Piece_2_2:  L (4x24)
;;
;; 	XX
;; 	X
;;	X
;;
;;#5343
PIECE_2_2_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#2e
	db #2b,#03,#03,#06,#2b,#03,#03,#06
	db #2b,#03,#03,#06,#2b,#03,#03,#06
	db #2b,#03,#0c,#0c,#2b,#06,#0c,#0c
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2b,#06,#00,#00,#2b,#06,#00,#00
	db #2e,#0c,#00,#00,#0c,#0c,#00,#00
;;---------------------------------------------------------
;; Piece_2_3:  L (6x16)
;;
;;
;; 	X
;; 	XXX
;;	
;;#53a3
PIECE_2_3_BMP:
	db #3f,#3f,#00,#00,#00,#00,#3f,#2e
	db #00,#00,#00,#00,#2b,#06,#00,#00
	db #00,#00,#2b,#06,#00,#00,#00,#00
	db #2b,#06,#00,#00,#00,#00,#2b,#06
	db #00,#00,#00,#00,#2b,#06,#00,#00
	db #00,#00,#2b,#06,#00,#00,#00,#00
	db #2b,#06,#3f,#3f,#3f,#3f,#2b,#03
	db #3f,#3f,#3f,#2e,#2b,#03,#03,#03
	db #03,#06,#2b,#03,#03,#03,#03,#06
	db #2b,#03,#03,#03,#03,#06,#2b,#03
	db #03,#03,#03,#06,#2e,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_2_4:  L (4x24)
;;
;; 	 X
;; 	 X
;;	XX
;;
;;#5403
PIECE_2_4_BMP:
	db #00,#00,#3f,#3f,#00,#00,#3f,#2e
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #00,#00,#2b,#06,#00,#00,#2b,#06
	db #3f,#3f,#2b,#06,#3f,#3f,#03,#06
	db #2b,#03,#03,#06,#2b,#03,#03,#06
	db #2b,#03,#03,#06,#2b,#03,#03,#06
	db #2e,#0c,#0c,#0c,#0c,#0c,#0c,#0c

;;---------------------------------------------------------
;; Piece_3_1:  T (6x16)
;; 
;;
;; 	XXX
;; 	 X
;;	
;;#5463
PIECE_3_1_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
	db #3f,#3f,#3f,#2e,#3b,#33,#33,#33
	db #33,#26,#3b,#33,#33,#33,#33,#26
	db #3b,#33,#33,#33,#33,#26,#3b,#33
	db #33,#33,#33,#26,#2e,#0c,#33,#33
	db #0c,#0c,#0c,#0c,#19,#26,#0c,#0c
	db #00,#00,#3b,#26,#00,#00,#00,#00
	db #3b,#26,#00,#00,#00,#00,#3b,#26
	db #00,#00,#00,#00,#3b,#26,#00,#00
	db #00,#00,#3b,#26,#00,#00,#00,#00
	db #3b,#26,#00,#00,#00,#00,#2e,#0c
	db #00,#00,#00,#00,#0c,#0c,#00,#00
;;---------------------------------------------------------
;; Piece_3_2:  T (4x24)
;;
;; 	X
;; 	XX
;;	X
;;
;;#54c3
PIECE_3_2_BMP:
	db #3f,#3f,#00,#00,#3f,#2e,#00,#00
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #3b,#26,#3f,#3f,#3b,#33,#3f,#2e
	db #3b,#33,#33,#26,#3b,#33,#33,#26
	db #3b,#33,#33,#26,#3b,#33,#33,#26
	db #3b,#33,#0c,#0c,#3b,#26,#0c,#0c
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #3b,#26,#00,#00,#3b,#26,#00,#00
	db #2e,#0c,#00,#00,#0c,#0c,#00,#00
;;---------------------------------------------------------
;; Piece_3_3:  T (6x16)
;;
;;
;; 	 X
;; 	XXX
;;	
;;#5523
PIECE_3_3_BMP:
	db #00,#00,#3f,#3f,#00,#00,#00,#00
	db #3f,#2e,#00,#00,#00,#00,#3b,#26
	db #00,#00,#00,#00,#3b,#26,#00,#00
	db #00,#00,#3b,#26,#00,#00,#00,#00
	db #3b,#26,#00,#00,#00,#00,#3b,#26
	db #00,#00,#00,#00,#3b,#26,#00,#00
	db #3f,#3f,#3b,#26,#3f,#3f,#3f,#3f
	db #33,#33,#3f,#2e,#3b,#33,#33,#33
	db #33,#26,#3b,#33,#33,#33,#33,#26
	db #3b,#33,#33,#33,#33,#26,#3b,#33
	db #33,#33,#33,#26,#2e,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_3_4:  T (4x24)
;;
;; 	 X
;; 	XX
;;	 X
;;
;;#5583
PIECE_3_4_BMP:
	db #00,#00,#3f,#3f,#00,#00,#3f,#2e
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #3f,#3f,#3b,#26,#3f,#3f,#33,#26
	db #3b,#33,#33,#26,#3b,#33,#33,#26
	db #3b,#33,#33,#26,#3b,#33,#33,#26
	db #2e,#0c,#33,#26,#0c,#0c,#19,#26
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #00,#00,#3b,#26,#00,#00,#3b,#26
	db #00,#00,#2e,#0c,#00,#00,#0c,#0c


;;---------------------------------------------------------
;; Piece_4_1:  S (6x16)
;;
;;
;; 	 XX
;; 	XX
;; 
;;#55e3
PIECE_4_1_BMP:
	db #00,#00,#3f,#3f,#3f,#3f,#00,#00
	db #3f,#3f,#3f,#2e,#00,#00,#3a,#30
	db #30,#24,#00,#00,#3a,#30,#30,#24
	db #00,#00,#3a,#30,#30,#24,#00,#00
	db #3a,#30,#30,#24,#00,#00,#3a,#30
	db #0c,#0c,#00,#00,#3a,#24,#0c,#0c
	db #3f,#3f,#3a,#24,#00,#00,#3f,#3f
	db #30,#24,#00,#00,#3a,#30,#30,#24
	db #00,#00,#3a,#30,#30,#24,#00,#00
	db #3a,#30,#30,#24,#00,#00,#3a,#30
	db #30,#24,#00,#00,#2e,#0c,#0c,#0c
	db #00,#00,#0c,#0c,#0c,#0c,#00,#00
;;---------------------------------------------------------
;; Piece_4_2:  S (4x24)
;;
;; 	X
;; 	XX
;;	 X
;; 
;;#5643
PIECE_4_2_BMP:
	db #3f,#3f,#00,#00,#3f,#2e,#00,#00
	db #3a,#24,#00,#00,#3a,#24,#00,#00
	db #3a,#24,#00,#00,#3a,#24,#00,#00
	db #3a,#24,#00,#00,#3a,#24,#00,#00
	db #3a,#24,#3f,#3f,#3a,#30,#3f,#2e
	db #3a,#30,#30,#24,#3a,#30,#30,#24
	db #3a,#30,#30,#24,#3a,#30,#30,#24
	db #2e,#0c,#30,#24,#0c,#0c,#3a,#24
	db #00,#00,#3a,#24,#00,#00,#3a,#24
	db #00,#00,#3a,#24,#00,#00,#3a,#24
	db #00,#00,#3a,#24,#00,#00,#3a,#24
	db #00,#00,#2e,#0c,#00,#00,#0c,#0c

;;---------------------------------------------------------
;; Piece_5_1:  Z (6x16)
;;	
;;
;; 	XX
;; 	 XX
;;
;;#56a3
PIECE_5_1_BMP:
	db #3f,#3f,#3f,#3f,#00,#00,#3f,#3f
	db #3f,#2e,#00,#00,#6b,#c3,#c3,#86
	db #00,#00,#6b,#c3,#c3,#86,#00,#00
	db #6b,#c3,#c3,#86,#00,#00,#6b,#c3
	db #c3,#86,#00,#00,#2e,#0c,#c3,#86
	db #00,#00,#0c,#0c,#49,#86,#00,#00
	db #00,#00,#6b,#86,#3f,#3f,#00,#00
	db #6b,#c3,#3f,#2e,#00,#00,#6b,#c3
	db #c3,#86,#00,#00,#6b,#c3,#c3,#86
	db #00,#00,#6b,#c3,#c3,#86,#00,#00
	db #6b,#c3,#c3,#86,#00,#00,#2e,#0c
	db #0c,#0c,#00,#00,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_5_2:  Z (4x24)
;;
;; 	 X
;; 	XX
;;	X
;;
;;#5703
PIECE_5_2_BMP:
	db #00,#00,#3f,#3f,#00,#00,#3f,#2e
	db #00,#00,#6b,#86,#00,#00,#6b,#86
	db #00,#00,#6b,#86,#00,#00,#6b,#86
	db #00,#00,#6b,#86,#00,#00,#6b,#86
	db #3f,#3f,#6b,#86,#3f,#3f,#c3,#86
	db #6b,#c3,#c3,#86,#6b,#c3,#c3,#86
	db #6b,#c3,#c3,#86,#6b,#c3,#c3,#86
	db #6b,#c3,#0c,#0c,#6b,#86,#0c,#0c
	db #6b,#86,#00,#00,#6b,#86,#00,#00
	db #6b,#86,#00,#00,#6b,#86,#00,#00
	db #6b,#86,#00,#00,#6b,#86,#00,#00
	db #2e,#0c,#00,#00,#0c,#0c,#00,#00

;;---------------------------------------------------------
;; Piece_6_1:  I (8x8)
;;	
;;
;; 	XXXX
;;
;;#5763
PIECE_6_1_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#3f
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#2e
	db #7e,#fc,#fc,#fc,#fc,#fc,#fc,#ac
	db #7e,#fc,#fc,#fc,#fc,#fc,#fc,#ac
	db #7e,#fc,#fc,#fc,#fc,#fc,#fc,#ac
	db #7e,#fc,#fc,#fc,#fc,#fc,#fc,#ac
	db #2e,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
;;---------------------------------------------------------
;; Piece_6_2:  I (2x32)
;;
;;	X
;; 	X
;;	X
;;	X
;; 
;;#57a3
PIECE_6_2_BMP:
	db #3f,#3f,#3f,#2e,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#2e,#0c,#0c,#0c

;;---------------------------------------------------------
;; Piece_7_1:  CUBE (4x16)
;;
;; 	XX
;; 	XX
;;	
;;
;;#57e3
PIECE_7_1_BMP:
	db #3f,#3f,#3f,#3f,#3f,#3f,#3f,#2e
	db #6e,#cc,#cc,#8c,#6e,#cc,#cc,#8c
	db #6e,#cc,#cc,#8c,#6e,#cc,#cc,#8c
	db #6e,#8c,#4c,#8c,#6e,#8c,#6e,#8c
	db #6e,#8c,#6e,#8c,#6e,#9d,#6e,#8c
	db #6e,#cc,#cc,#8c,#6e,#cc,#cc,#8c
	db #6e,#cc,#cc,#8c,#6e,#cc,#cc,#8c
	db #2e,#0c,#0c,#0c,#0c,#0c,#0c,#0c


;;---------------------------------------------------------
;; Alphabet
;; 66 characters (2x7)
;;#5823
ALPHABET:
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#00
	db #00,#00,#15,#00,#41,#00,#41,#00
	db #41,#00,#00,#00,#01,#00
	db #00,#00,#2a,#2a,#82,#82,#00,#00
	db #00,#00,#00,#00,#00,#00
	db #00,#00,#15,#2a,#6b,#c3,#41,#82
	db #41,#82,#c3,#83,#01,#02
	db #00,#00,#15,#00,#6b,#82,#c3,#00
	db #c3,#82,#41,#02,#83,#02
	db #00,#00,#6b,#15,#83,#41,#00,#82
	db #41,#00,#2a,#6b,#82,#83
	db #00,#00,#15,#00,#2a,#82,#41,#00
	db #41,#41,#82,#02, #83,#01
	db #00,#00,#00,#82,#15,#00,#00,#00
	db #00,#00,#00,#00,#00,#00
	db #00,#00,#00,#2a,#15,#00,#41,#00
	db #41,#00,#01,#00,#00,#02
	db #00,#00,#15,#00,#00,#82,#00,#82
	db #00,#82,#00,#02,#01,#00
	db #00,#00,#00,#00,#2a,#82,#15,#00
	db #c3,#82,#01,#00,#82,#02
	db #00,#00,#00,#00,#15,#00,#41,#00
	db #6b,#82,#41,#00,#01,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#82,#00,#82,#01,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #6b,#02,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#41,#00,#01,#00
	db #00,#00,#00,#2a,#00,#82,#41,#00
	db #41,#00,#82,#00,#02,#00
	db #00,#00,#15,#00,#2a,#82,#82,#82
	db #82,#82,#82,#02,#01,#00
	db #00,#00,#15,#00,#6b,#00,#41,#00
	db #41,#00,#41,#00,#83,#02
	db #00,#00,#3f,#82,#82,#82,#00,#82
	db #6b,#82,#82,#00,#83,#02
	db #00,#00,#3f,#82,#82,#82,#41,#82
	db #00,#82,#2a,#02,#83,#02
	db #00,#00,#2a,#00,#82,#2a,#82,#82
	db #03,#82,#00,#82,#00,#02
	db #00,#00,#3f,#82,#2a,#00,#c3,#82
	db #00,#82,#2a,#02,#83,#02
	db #00,#00,#3f,#82,#82,#00,#97,#82
	db #82,#82,#82,#02,#83,#02
	db #00,#00,#3f,#82,#00,#82,#00,#82
	db #41,#00,#41,#00,#01,#00
	db #00,#00,#3f,#82,#82,#82,#6b,#82
	db #82,#82,#82,#02,#83,#02
	db #00,#00,#3f,#82,#2a,#82,#82,#82
	db #c3,#82,#00,#02,#83,#02
	db #00,#00,#00,#00,#15,#00,#01,#00
	db #00,#00,#15,#00,#01,#00
	db #00,#00,#00,#2a,#00,#02,#00,#00
	db #00,#2a,#00,#82,#01,#00
	db #00,#00,#00,#00,#00,#2a,#15,#00
	db #82,#00,#41,#00,#00,#02
	db #00,#00,#00,#00,#00,#00,#3f,#82
	db #00,#00,#03,#82,#00,#00
	db #00,#00,#00,#00,#2a,#00,#15,#00
	db #00,#82,#41,#00,#02,#00
	db #00,#00,#3f,#82,#2a,#82,#00,#82
	db #01,#00,#00,#00,#01,#00
	db #00,#00,#15,#82,#2a,#c3,#97,#41
	db #82,#03,#82,#00,#01,#02
	db #00,#00,#15,#00,#2a,#82,#82,#82
	db #97,#82,#82,#02,#82,#02
	db #00,#00,#3f,#00,#82,#82,#97,#00
	db #82,#82,#82,#02,#03,#00
	db #00,#00,#3f,#82,#2a,#82,#82,#00
	db #82,#00,#82,#02,#83,#02
	db #00,#00,#3f,#00,#2a,#82,#82,#82
	db #82,#82,#82,#02,#83,#00
	db #00,#00,#3f,#82,#82,#00,#6b,#00
	db #82,#00,#82,#00,#83,#02
	db #00,#00,#3f,#82,#82,#00,#6b,#00
	db #82,#00,#82,#00,#02,#00
	db #00,#00,#3f,#82,#2a,#00,#82,#00
	db #82,#82,#82,#02,#83,#02
	db #00,#00,#2a,#2a,#82,#82,#97,#82
	db #82,#82,#82,#82,#02,#02
	db #00,#00,#3f,#82,#41,#00,#41,#00
	db #41,#00,#41,#00,#83,#02
	db #00,#00,#00,#2a,#00,#82,#00,#82
	db #2a,#82,#82,#02,#83,#02
	db #00,#00,#2a,#2a,#82,#82,#97,#00
	db #82,#82,#82,#02,#82,#02
	db #00,#00,#2a,#00,#82,#00,#82,#00
	db #82,#00,#82,#00,#83,#02
	db #00,#00,#2a,#2a,#97,#82,#82,#82
	db #82,#82,#82,#02,#02,#02
	db #00,#00,#3f,#00,#82,#82,#82,#82
	db #82,#82,#82,#82,#02,#02
	db #00,#00,#3f,#82,#2a,#82,#82,#82
	db #82,#82,#82,#02,#83,#02
	db #00,#00,#3f,#82,#2a,#82,#82,#82
	db #83,#02,#82,#00,#02,#00
	db #00,#00,#3f,#82,#2a,#82,#82,#82
	db #82,#02,#83,#02,#00,#02
	db #00,#00,#3f,#82,#2a,#82,#82,#82
	db #97,#00,#82,#02,#02,#02
	db #00,#00,#3f,#82,#2a,#00,#c3,#82
	db #00,#82,#00,#02,#83,#02
	db #00,#00,#3f,#82,#41,#00,#41,#00
	db #41,#00,#41,#00,#01,#00
	db #00,#00,#2a,#82,#2a,#2a,#82,#82
	db #82,#82,#82,#02,#83,#02
	db #00,#00,#2a,#82,#2a,#2a,#82,#82
	db #82,#02,#01,#00,#01,#00
	db #00,#00,#2a,#2a,#82,#82,#82,#82
	db #82,#82,#83,#82,#82,#02
	db #00,#00,#2a,#2a,#82,#82,#41,#00
	db #01,#00,#2a,#02,#82,#02
	db #00,#00,#2a,#2a,#82,#82,#97,#82
	db #00,#82,#00,#82,#01,#02
	db #00,#00,#3f,#82,#00,#82,#15,#00
	db #41,#00,#82,#00,#03,#02
	db #00,#00,#3f,#82,#2a,#00,#82,#00
	db #82,#00,#82,#00,#03,#02
	db #00,#00,#2a,#00,#82,#00,#41,#00
	db #41,#00,#00,#82,#00,#02
	db #00,#00,#3f,#82,#00,#82,#00,#82
	db #00,#82,#00,#82,#03,#82
	db #00,#00,#15,#00,#6b,#82,#c3,#02
	db #41,#00,#41,#00,#01,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#6b,#03
	db #00,#00,#15,#00,#00,#82,#00,#00
	db #00,#00,#00,#00,#00,#00
	db #3f,#4b,#2a,#41,#0a,#41,#0a,#41
	db #82,#41,#82,#01,#c3,#03

;;---------------------------------------------------------
;; Curtain 34x8
;;#5bbf
CURTAIN_BMP:
	db #bc,#3c,#7c,#7c,#bc,#3c,#bc,#3c
	db #3c,#7c,#7c,#bc,#3c,#3c,#7c,#bc
	db #bc,#3c,#3c,#7c,#7c,#bc,#3c,#3c
	db #3c,#bc,#fc,#bc,#3c,#fc,#7c,#3c
	db #3c,#7c,#bc,#3c,#7c,#7c,#bc,#7c
	db #bc,#3c,#3c,#7c,#fc,#bc,#3c,#3c
	db #7c,#fc,#bc,#3c,#3c,#7c,#fc,#bc
	db #3c,#3c,#3c,#bc,#fc,#bc,#3c,#fc
	db #fc,#3c,#3c,#7c,#56,#bc,#7c,#e9
	db #56,#e9,#56,#3c,#3c,#7c,#43,#56
	db #bc,#3c,#fc,#43,#56,#bc,#3c,#7c
	db #43,#bc,#3c,#3c,#3c,#bc,#fc,#bc
	db #3c,#fc,#43,#bc,#7c,#e9,#43,#56
	db #fc,#43,#43,#43,#43,#bc,#7c,#e9
	db #43,#43,#56,#fc,#43,#43,#43,#56
	db #3c,#e9,#43,#56,#bc,#3c,#3c,#fc
	db #43,#bc,#3c,#e9,#43,#56,#e9,#43
	db #43,#43,#43,#43,#43,#43,#43,#56
	db #e9,#43,#43,#43,#43,#43,#43,#43
	db #43,#43,#fc,#43,#43,#43,#56,#3c
	db #fc,#43,#43,#56,#fc,#43,#43,#43
	db #43,#43,#41,#43,#43,#02,#41,#02
	db #41,#43,#43,#43,#00,#41,#43,#43
	db #43,#00,#41,#43,#43,#43,#00,#43
	db #43,#fc,#43,#43,#43,#43,#43,#43
	db #00,#43,#43,#02,#00,#41,#43,#00
	db #00,#00,#00,#43,#43,#02,#00,#00
	db #41,#43,#00,#00,#00,#41,#43,#02
	db #00,#41,#43,#43,#43,#43,#00,#43
	db #43,#02,#00,#41,#02,#00,#00,#00
	db #00,#00,#00,#00,#00,#41,#02,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #43,#00,#00,#00,#41,#43,#43,#00
	db #00,#41,#43,#00,#00,#00,#00,#00
;;---------------------------------------------------------
;; Burning flame 1 20x8
;;#5ccf	
FLAME1_BMP:
	db #00,#fc,#00,#54,#a8,#54,#a8,#00
	db #a8,#54,#a8,#00,#54,#00,#00,#00
	db #a8,#54,#54,#00,#54,#03,#a8,#a9
	db #56,#a9,#56,#54,#56,#a9,#56,#00
	db #a9,#a8,#fc,#54,#56,#a9,#a9,#a8
	db #54,#43,#56,#43,#83,#43,#83,#a9
	db #83,#43,#83,#fc,#03,#56,#03,#a9
	db #83,#43,#43,#56,#a9,#97,#83,#97
	db #c3,#97,#c3,#43,#c3,#87,#c3,#03
	db #c3,#83,#c3,#43,#c3,#97,#c3,#56
	db #a9,#c3,#c3,#c3,#43,#6b,#03,#c3
	db #43,#3f,#c3,#83,#97,#6b,#03,#c3
	db #43,#3f,#c3,#56,#a9,#03,#56,#03
	db #a9,#83,#fc,#03,#a9,#c3,#43,#56
	db #43,#83,#fc,#03,#a9,#c3,#03,#a8
	db #54,#03,#a8,#fc,#54,#56,#00,#fc
	db #54,#03,#a9,#a8,#a9,#56,#00,#fc
	db #54,#03,#fc,#00,#00,#fc,#00,#00
	db #00,#a8,#00,#00,#00,#fc,#54,#00
	db #54,#a8,#00,#00,#00,#fc,#00,#00
;;---------------------------------------------------------
;; Burning flame 2 20x8
;;#5d6f
FLAME2_BMP:
	db #00,#54,#a8,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#a9,#56,#00
	db #fc,#00,#00,#fc,#54,#54,#a8,#00
	db #00,#fc,#00,#00,#fc,#00,#fc,#00
	db #54,#43,#83,#fc,#03,#a8,#54,#03
	db #a9,#a9,#56,#00,#fc,#03,#a8,#54
	db #03,#fc,#03,#a8,#54,#17,#6b,#03
	db #83,#a8,#a9,#c3,#17,#17,#d6,#54
	db #03,#c3,#56,#54,#43,#03,#97,#56
	db #54,#43,#43,#97,#83,#a8,#a9,#3f
	db #83,#c3,#56,#54,#43,#6b,#56,#54
	db #17,#6b,#43,#56,#00,#a9,#a9,#c3
	db #56,#00,#a9,#c3,#56,#03,#a8,#54
	db #43,#83,#a8,#54,#43,#83,#a9,#56
	db #00,#54,#54,#03,#a8,#00,#54,#03
	db #a8,#fc,#00,#00,#a9,#56,#00,#00
	db #a9,#56,#54,#a8,#00,#00,#00,#fc
	db #00,#00,#00,#fc,#00,#00,#00,#00
	db #54,#a8,#00,#00,#54,#a8,#00,#00
;;---------------------------------------------------------
;; Burning flame 3 20x8
;;#5e0f
FLAME3_BMP:
	db #00,#54,#a8,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#a9,#56,#00
	db #fc,#00,#00,#fc,#54,#54,#a8,#00
	db #00,#fc,#00,#00,#fc,#00,#fc,#00
	db #54,#43,#83,#fc,#03,#a8,#54,#03
	db #a9,#a9,#56,#00,#fc,#03,#a8,#54
	db #03,#fc,#03,#a8,#54,#17,#6b,#03
	db #83,#a8,#a9,#c3,#17,#17,#d6,#54
	db #03,#c3,#56,#54,#43,#03,#97,#56
	db #54,#43,#43,#97,#83,#a8,#a9,#3f
	db #83,#c3,#56,#54,#43,#6b,#56,#54
	db #17,#6b,#43,#56,#00,#a9,#a9,#c3
	db #56,#00,#a9,#c3,#56,#03,#a8,#54
	db #43,#83,#a8,#54,#43,#83,#a9,#56
	db #00,#54,#54,#03,#a8,#00,#54,#03
	db #a8,#fc,#00,#00,#a9,#56,#00,#00
	db #a9,#56,#54,#a8,#00,#00,#00,#fc
	db #00,#00,#00,#fc,#00,#00,#00,#00
	db #54,#a8,#00,#00,#54,#a8,#00,#00
;;---------------------------------------------------------
;; P1''s head   (20x5)
;;#5eaf
P1_HEAD_BMP:
	db #00,#82,#c3,#82,#00,#41,#c3,#c3
	db #c3,#00,#41,#c3,#c3,#c3,#00,#41
	db #c3,#c3,#c3,#82,#c3,#c3,#c3,#c3
	db #82,#c3,#d2,#c3,#c3,#82,#c3,#d2
	db #c3,#c3,#82,#c3,#f0,#e1,#c3,#82
	db #41,#f0,#e1,#c3,#82,#50,#f0,#f0
	db #e1,#82,#00,#00,#00,#00,#00,#50
	db #0a,#a5,#50,#a0,#50,#00,#a0,#50
	db #a0,#50,#a1,#f0,#f0,#a0,#50,#a1
	db #52,#f0,#00,#50,#f0,#f0,#f0,#00
	db #50,#b4,#b4,#f0,#00,#00,#f0,#78
	db #a0,#00,#00,#f0,#f0,#a0,#00,#00
	db #50,#f0,#00,#00
;;---------------------------------------------------------
;; P2''s head   (20x5)
;;#5f13
P2_HEAD_BMP:
	db #00,#28,#3c,#28,#00,#14,#3c,#3c
	db #3c,#00,#14,#3c,#3c,#3c,#00,#14
	db #3c,#3c,#3c,#28,#3c,#3c,#3c,#3c
	db #28,#3c,#78,#3c,#3c,#28,#3c,#78
	db #3c,#3c,#28,#3c,#f0,#b4,#3c,#28
	db #14,#f0,#b4,#3c,#28,#50,#f0,#f0
	db #b4,#28,#00,#00,#00,#00,#00,#50
	db #0a,#a5,#50,#a0,#50,#00,#a0,#50
	db #a0,#50,#a1,#f0,#f0,#a0,#50,#a1
	db #52,#f0,#00,#50,#f0,#f0,#f0,#00
	db #50,#b4,#b4,#f0,#00,#00,#f0,#78
	db #a0,#00,#00,#f0,#f0,#a0,#00,#00
	db #50,#f0,#00,#00
;;---------------------------------------------------------
;; Left dance floor''s column (5x100)
;;#5f77
LFT_COLUMN_BMP
	db #30,#30,#30,#35,#3a,#3f,#3f,#3f
	db #3a,#3a,#3a,#30,#30,#3f,#30,#35
	db #3f,#3f,#35,#24,#3f,#30,#35,#3a
	db #0c,#30,#35,#30,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #24,#0c,#35,#35,#35,#24,#0c,#35
	db #35,#35,#24,#0c,#35,#35,#35,#24
	db #0c,#35,#35,#35,#24,#0c,#35,#35
	db #35,#24,#0c,#35,#35,#35,#24,#0c
	db #35,#35,#35,#24,#0c,#35,#35,#35
	db #30,#30,#35,#35,#35,#20,#00,#35
	db #35,#35,#20,#00,#35,#35,#35,#20
	db #00,#35,#35,#35,#20,#00,#35,#35
	db #35,#20,#00,#35,#35,#35,#20,#00
	db #35,#35,#35,#20,#00,#35,#35,#35
	db #20,#00,#35,#35,#35,#20,#00,#35
	db #35,#35,#20,#00,#35,#35,#35,#20
	db #00,#35,#35,#35,#20,#00,#35,#35
	db #35,#20,#00,#35,#35,#35,#20,#00
	db #35,#35,#35,#20,#00,#35,#35,#35
	db #20,#00,#35,#35,#35,#20,#00,#35
	db #35,#35,#20,#00,#35,#35,#35,#20
	db #00,#35,#35,#35,#20,#00,#35,#35
	db #35,#20,#00,#35,#35,#35,#20,#00
	db #35,#35,#35,#20,#00,#35,#35,#35
	db #20,#00,#35,#35,#35,#20,#00,#35
	db #35,#35,#20,#00,#30,#35,#30,#20
	db #00,#3f,#30,#35,#3a,#00,#35,#3f
	db #3f,#35,#20,#3a,#30,#30,#3f,#30
	db #3f,#3f,#3f,#3a,#3a,#30,#30,#30
	db #35,#3a,#3f,#3f,#3f,#35,#20,#3f
	db #3f,#3f,#30,#00
;;---------------------------------------------------------
;; Right dance floor column with Alinka (10x100)
;;#616b	
RGT_COLUMN_BMP:
	db #3f,#3f,#3f,#3f,#3f,#35,#3a,#30
	db #30,#30,#30,#30,#30,#30,#30,#35
	db #35,#3f,#3f,#3f,#0c,#0c,#0c,#0c
	db #0c,#30,#3f,#30,#30,#35,#0c,#0c
	db #0c,#0c,#0c,#18,#3a,#3f,#3f,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#35,#3a
	db #30,#3f,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#30,#3a,#30,#0c,#0c,#0c,#0c
	db #0c,#0c,#18,#3a,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#18,#3a,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#18,#3a
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#3a,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#18,#3a,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#18,#3a,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#18,#3a
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#3a,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#18,#3a,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#18,#3a,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#18,#3a
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#3a,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#18,#3a,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#18,#3a,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#18,#3a
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#3a,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#18,#3a,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#18,#3a,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#0c,#18,#3a
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #18,#3a,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#c3,#92,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#c3,#c3,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#49,#c3,#c3
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#49
	db #c3,#c3,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#49,#e1,#e1,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#49,#f0,#e1,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#49,#f0,#e1
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#49
	db #d8,#c9,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#58,#f0,#e1,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#58,#f0,#e1,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#58,#f4,#e1
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#0c
	db #52,#e1,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#0c,#a1,#97,#3a,#3a,#0c,#0c
	db #0c,#0c,#0c,#0c,#f0,#d2,#3a,#3a
	db #0c,#0c,#0c,#0c,#0c,#58,#f0,#d2
	db #3a,#3a,#0c,#0c,#0c,#0c,#0c,#58
	db #f0,#d2,#3a,#3a,#0c,#0c,#0c,#0c
	db #0c,#f0,#e1,#f0,#3a,#3a,#0c,#0c
	db #0c,#0c,#58,#f0,#e1,#f0,#3a,#3a
	db #0c,#0c,#0c,#0c,#f0,#f0,#e1,#f0
	db #3a,#3a,#0c,#0c,#0c,#0c,#e0,#a1
	db #e1,#f0,#3a,#3a,#0c,#0c,#0c,#0c
	db #c0,#52,#f0,#f0,#3a,#3a,#0c,#0c
	db #0c,#0c,#c0,#f0,#c0,#f0,#3a,#3a
	db #0c,#0c,#0c,#0c,#c0,#c0,#c0,#f0
	db #3a,#3a,#0c,#0c,#0c,#0c,#c0,#c0
	db #c0,#f0,#3a,#3a,#0c,#0c,#0c,#0c
	db #48,#c0,#c0,#f0,#3a,#3a,#0c,#0c
	db #0c,#0c,#48,#c0,#d0,#f0,#3a,#3a
	db #0c,#0c,#0c,#0c,#58,#c0,#d0,#f0
	db #3a,#3a,#0c,#0c,#0c,#0c,#58,#c0
	db #f0,#b0,#3a,#3a,#0c,#0c,#0c,#0c
	db #58,#d0,#f0,#b0,#3a,#3a,#0c,#0c
	db #0c,#0c,#e0,#f0,#f0,#90,#3a,#3a
	db #0c,#0c,#0c,#0c,#f0,#f0,#e0,#90
	db #3a,#3a,#0c,#0c,#0c,#0c,#d0,#e4
	db #cc,#90,#3a,#3a,#0c,#0c,#0c,#0c
	db #e4,#cc,#cc,#98,#3a,#3a,#0c,#0c
	db #0c,#0c,#cc,#cc,#cc,#98,#3a,#3a
	db #0c,#0c,#0c,#0c,#cc,#cc,#cc,#98
	db #3a,#3a,#0c,#0c,#0c,#0c,#cc,#cc
	db #cc,#98,#3a,#3a,#0c,#0c,#0c,#4c
	db #cc,#cc,#cc,#98,#3a,#3a,#0c,#0c
	db #0c,#4c,#cc,#cc,#cc,#cc,#3a,#3a
	db #0c,#0c,#0c,#cc,#cc,#cc,#cc,#cc
	db #3a,#3a,#30,#30,#30,#cc,#cc,#cc
	db #cc,#cc,#3a,#3a,#00,#00,#00,#cc
	db #cc,#cc,#cc,#cc,#3a,#3a,#00,#00
	db #44,#cc,#cc,#cc,#cc,#cc,#3a,#3a
	db #00,#00,#44,#cc,#cc,#cc,#cc,#cc
	db #3a,#3a,#00,#00,#cc,#cc,#cc,#cc
	db #cc,#cc,#3a,#3a,#00,#00,#cc,#cc
	db #cc,#cc,#cc,#98,#3a,#3a,#00,#00
	db #cc,#cc,#cc,#cc,#cc,#98,#3a,#3a
	db #00,#00,#cc,#cc,#cc,#cc,#cc,#3a
	db #3a,#3a,#00,#00,#cc,#cc,#cc,#cc
	db #d8,#3a,#3a,#3a,#00,#00,#44,#cc
	db #cc,#d8,#f0,#3a,#3a,#3a,#00,#00
	db #00,#cc,#cc,#d8,#f0,#3a,#3a,#3a
	db #00,#00,#00,#44,#cc,#f0,#b0,#3a
	db #3a,#3a,#00,#00,#00,#01,#03,#f0
	db #b0,#3a,#3a,#3a,#00,#00,#00,#01
	db #03,#f0,#b0,#3a,#3a,#3a,#00,#00
	db #00,#01,#03,#f0,#b0,#3a,#3a,#3a
	db #00,#00,#00,#03,#03,#f0,#b0,#3a
	db #3a,#3a,#00,#00,#00,#03,#02,#f0
	db #b0,#3a,#3a,#3a,#00,#00,#00,#03
	db #02,#78,#38,#3a,#3a,#3a,#00,#00
	db #00,#29,#02,#3c,#38,#3a,#3a,#3a
	db #00,#00,#00,#3c,#28,#3c,#38,#3a
	db #3a,#3a,#00,#00,#14,#3c,#00,#3c
	db #10,#3a,#3a,#3a,#00,#00,#14,#3c
	db #14,#3c,#10,#3a,#3a,#3a,#00,#00
	db #14,#3c,#14,#3c,#10,#3a,#3a,#3a
	db #00,#00,#3c,#28,#14,#3c,#10,#3a
	db #3a,#3a,#00,#00,#3c,#28,#14,#3c
	db #10,#3a,#3a,#3a,#00,#00,#3c,#28
	db #14,#3c,#10,#3a,#3a,#3a,#00,#14
	db #3c,#00,#3c,#28,#10,#3a,#3a,#3a
	db #00,#14,#3c,#00,#3c,#28,#10,#30
	db #3a,#30,#00,#3c,#3c,#00,#3c,#28
	db #35,#3a,#30,#3f,#00,#68,#28,#00
	db #3c,#38,#3a,#3f,#3f,#3a,#14,#3c
	db #00,#00,#14,#38,#3f,#30,#30,#35
	db #14,#3c,#28,#00,#28,#35,#35,#3f
	db #3f,#3f,#14,#3c,#28,#00,#3c,#35
	db #3a,#30,#30,#30,#14,#3c,#28,#00
	db #3c,#10,#3a,#3f,#3f,#3f,#00,#00
	db #00,#00,#3c,#00,#30,#3f,#3f,#3f
;;---------------------------------------------------------
;; Block id = #00
;;#6553
EMPTY_BLOCK_BMP
	db #00,#00,#00,#00,#00,#00,#00,#00
	db #00,#00,#00,#00,#00,#00,#00,#00
;;---------------------------------------------------------
;; Block id = #01
;;#6563
PURPLE_BLOCK_BMP
	db #3f,#3f,#3f,#2e,#6a,#84,#6a,#84
	db #6a,#84,#6a,#84,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #02
;;#6573
RED_BLOCK_BMP
	db #3f,#3f,#3f,#2e,#7e,#ac,#7e,#ac
	db #7e,#ac,#7e,#ac,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #03
;;#6583
ORANGE_BLOCK_BMP
	db #3f,#3f,#3f,#2e,#2b,#06,#2b,#06
	db #2b,#06,#2b,#06,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #04
;;#6593
YELLOW_BLOCK_BMP
	db #3f,#3f,#3f,#2e,#6b,#86,#6b,#86
	db #6b,#86,#6b,#86,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #05
;;#65a3
GREEN_BLOCK_BMP
	db #3f,#3f,#3f,#2e,#3b,#26,#3b,#26
	db #3b,#26,#3b,#26,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #06
;;#65b3
BLUE_BLOCK_BMP:
	db #3f,#3f,#3f,#2e,#6e,#8c,#6e,#8c
	db #6e,#8c,#6e,#8c,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #07
;;#65c3	
LBLUE_BLOCK_BMP:  
	db #3f,#3f,#3f,#2e,#3a,#24,#3a,#24
	db #3a,#24,#3a,#24,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Block id = #08
;;#65d3	
BLINK_BLOCK_BMP:  
	db #3f,#3f,#3f,#2e,#7f,#ae,#7f,#ae
	db #7f,#ae,#7f,#ae,#2e,#0c,#0c,#0c
;;---------------------------------------------------------
;; Kozak dancing 1 (10x32)
;;#65e3
KOZAK1_BMP:
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#08,#04,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#00,#00,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#00,#00
	db #04,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #00,#00,#04,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#00,#00,#04,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#e0,#00,#04,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#f0,#80
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #b4,#a4,#0c,#0c,#0c,#0c,#0c,#0c
	db #3c,#0c,#7a,#a4,#0c,#0c,#0c,#0c
	db #0c,#1c,#3c,#2c,#3f,#0c,#0c,#0c
	db #0c,#0c,#0c,#1c,#3c,#3c,#15,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#3c,#fc
	db #14,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #3c,#f8,#b4,#2c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#f8,#f0,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#58,#f0,#f8,#b4
	db #2c,#0c,#0c,#0c,#0c,#3c,#0c,#50
	db #bc,#3c,#2c,#0c,#0c,#0c,#35,#3e
	db #3c,#28,#14,#3c,#38,#30,#30,#30
	db #15,#3f,#3c,#3c,#28,#3c,#00,#00
	db #00,#00,#15,#7e,#3c,#3c,#3c,#00
	db #00,#00,#00,#00,#15,#fc,#3c,#3c
	db #3c,#3d,#00,#00,#00,#00,#15,#fc
	db #bc,#3c,#3c,#3f,#2a,#00,#00,#00
	db #00,#fc,#bc,#3c,#3c,#3f,#3f,#00
	db #00,#00,#00,#54,#bc,#3c,#3c,#3f
	db #7e,#a8,#14,#00,#00,#54,#fc,#3c
	db #28,#3f,#7e,#fc,#14,#28,#00,#00
	db #fc,#00,#00,#00,#7e,#fc,#bc,#28
	db #00,#3c,#3c,#00,#00,#00,#54,#fc
	db #bc,#28,#14,#3c,#3c,#00,#00,#00
	db #00,#fc,#bc,#28,#14,#3c,#3c,#00
	db #00,#00,#00,#00,#bc,#28,#00,#3c
	db #00,#00,#00,#00,#00,#00,#14,#28
;;---------------------------------------------------------
;; Kozak dancing 2 (10x32)
;;#6723
KOZAK2_BMP:
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #00,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#08,#00,#04,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#00,#00,#04,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#00,#00,#04
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#00
	db #00,#04,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#00,#40,#a4,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#08,#d0,#a4,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#b4,#a4
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #f0,#2e,#1c,#2c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1d,#2e,#3c,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#1d,#14,#3c,#3c
	db #0c,#0c,#0c,#0c,#0c,#0c,#1c,#54
	db #bc,#2c,#0c,#0c,#0c,#0c,#0c,#0c
	db #3c,#f0,#bc,#2c,#0c,#0c,#0c,#0c
	db #0c,#1c,#78,#f0,#bc,#0c,#0c,#0c
	db #0c,#0c,#0c,#3c,#f0,#f8,#f0,#0c
	db #0c,#0c,#0c,#0c,#0c,#3c,#3c,#f8
	db #04,#0c,#0c,#0c,#0c,#0c,#35,#3e
	db #3c,#00,#38,#30,#30,#30,#30,#30
	db #15,#3f,#00,#3c,#3c,#28,#00,#00
	db #00,#00,#15,#7e,#3c,#3c,#3c,#3c
	db #00,#00,#00,#00,#15,#fc,#3c,#3c
	db #3c,#3d,#00,#00,#00,#00,#15,#fc
	db #bc,#3c,#3c,#3f,#2a,#00,#00,#00
	db #00,#fc,#bc,#3c,#3c,#3f,#3f,#00
	db #00,#00,#00,#54,#bc,#3c,#3c,#3f
	db #7e,#a8,#14,#00,#00,#54,#fc,#3c
	db #28,#3f,#7e,#fc,#14,#28,#00,#00
	db #fc,#00,#00,#00,#7e,#fc,#bc,#28
	db #00,#3c,#3c,#00,#00,#00,#54,#fc
	db #bc,#28,#14,#3c,#3c,#00,#00,#00
	db #00,#fc,#bc,#28,#14,#3c,#3c,#00
	db #00,#00,#00,#00,#bc,#28,#00,#3c
	db #00,#00,#00,#00,#00,#00,#14,#28
;;---------------------------------------------------------
;; Kozak dancing 3 (10x32)
;;#6863
KOZAK3_BMP:
	db #a4,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#f0,#58,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#58,#a4,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#58,#a4
	db #0c,#0c,#08,#04,#0c,#0c,#0c,#0c
	db #0c,#fc,#0c,#0c,#00,#00,#0c,#0c
	db #0c,#0c,#0c,#bc,#0c,#0c,#00,#00
	db #04,#0c,#0c,#0c,#0c,#3c,#0c,#0c
	db #00,#00,#04,#0c,#0c,#0c,#0c,#3c
	db #0c,#0c,#00,#00,#04,#0c,#0c,#0c
	db #0c,#3c,#2c,#0c,#e0,#00,#04,#0c
	db #0c,#0c,#0c,#3c,#2c,#0c,#f0,#80
	db #0c,#0c,#0c,#0c,#0c,#3c,#2c,#0c
	db #b4,#a4,#0c,#0c,#0c,#0c,#0c,#1c
	db #3c,#0c,#7a,#a4,#0c,#0c,#0c,#0c
	db #0c,#1c,#3c,#2c,#3f,#0c,#0c,#0c
	db #0c,#0c,#0c,#1c,#3c,#3c,#15,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#3c,#3c
	db #14,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #3c,#3c,#3c,#2c,#0c,#0c,#0c,#0c
	db #0c,#0c,#3c,#3c,#3c,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#08,#3c,#3c,#3c
	db #2c,#0c,#0c,#0c,#0c,#3c,#0c,#14
	db #3c,#3c,#3c,#0c,#0c,#0c,#35,#3e
	db #3c,#28,#14,#3c,#3c,#38,#30,#30
	db #15,#3f,#3c,#3c,#28,#3c,#3c,#3c
	db #f8,#a0,#15,#7e,#3c,#3c,#3c,#fc
	db #3c,#3c,#f0,#00,#15,#fc,#3c,#3c
	db #3c,#3d,#bc,#3c,#f0,#a0,#15,#fc
	db #bc,#3c,#3c,#3f,#7e,#28,#00,#f0
	db #00,#fc,#bc,#3c,#3c,#3f,#3f,#00
	db #00,#50,#00,#54,#bc,#3c,#3c,#3f
	db #7e,#a8,#14,#00,#00,#54,#fc,#3c
	db #28,#3f,#7e,#fc,#14,#28,#00,#00
	db #fc,#00,#00,#00,#7e,#fc,#bc,#28
	db #00,#3c,#3c,#00,#00,#00,#54,#fc
	db #bc,#28,#14,#3c,#3c,#00,#00,#00
	db #00,#fc,#bc,#28,#14,#3c,#3c,#00
	db #00,#00,#00,#00,#bc,#28,#00,#3c
	db #00,#00,#00,#00,#00,#00,#14,#28
;;---------------------------------------------------------
;; Kozak dancing 4 (10x32)
;;#69a3
KOZAK4_BMP:
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#08,#04,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#00,#00,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#08,#00,#00
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#08
	db #00,#00,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#08,#00,#00,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#08,#00,#d0,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#40,#f0
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #58,#78,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#58,#b5,#0c,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#3f,#1c,#3c
	db #2c,#0c,#0c,#0c,#0c,#0c,#0c,#2a
	db #3c,#3c,#2c,#0c,#0c,#0c,#0c,#0c
	db #0c,#28,#fc,#3c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#78,#f4,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#3c,#f0,#f4,#2c
	db #0c,#0c,#0c,#0c,#0c,#1c,#78,#f4
	db #f0,#a4,#0c,#0c,#0c,#0c,#0c,#1c
	db #3c,#7c,#a0,#0c,#3c,#0c,#30,#30
	db #30,#34,#3c,#28,#14,#3c,#3d,#3a
	db #00,#00,#00,#00,#3c,#14,#3c,#3c
	db #3f,#2a,#00,#00,#00,#00,#00,#3c
	db #3c,#3c,#bd,#2a,#00,#00,#00,#00
	db #3e,#3c,#3c,#3c,#fc,#2a,#00,#00
	db #00,#15,#3f,#3c,#3c,#7c,#fc,#2a
	db #00,#00,#00,#3f,#3f,#3c,#3c,#7c
	db #fc,#00,#00,#28,#54,#bd,#3f,#3c
	db #3c,#7c,#a8,#00,#14,#28,#fc,#bd
	db #3f,#14,#3c,#fc,#a8,#00,#14,#7c
	db #fc,#bd,#00,#00,#00,#fc,#00,#00
	db #14,#7c,#fc,#a8,#00,#00,#00,#3c
	db #3c,#00,#14,#7c,#fc,#00,#00,#00
	db #00,#3c,#3c,#28,#14,#7c,#00,#00
	db #00,#00,#00,#3c,#3c,#28,#14,#28
	db #00,#00,#00,#00,#00,#00,#3c,#00
;;---------------------------------------------------------
;; Kozak dancing 5 (10x32)
;;#6ae3
KOZAK5_BMP:
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#00,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#08,#00
	db #04,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #08,#00,#00,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#08,#00,#00,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#08,#00,#00,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#58,#80
	db #00,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #58,#e0,#04,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#58,#78,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#2c,#1d,#f0,#0c,#0c
	db #0c,#0c,#0c,#0c,#3c,#3c,#1d,#2e
	db #0c,#0c,#0c,#0c,#0c,#0c,#3c,#3c
	db #28,#2e,#0c,#0c,#0c,#0c,#0c,#0c
	db #1c,#7c,#a8,#2c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#7c,#f0,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#7c,#f0,#b4
	db #2c,#0c,#0c,#0c,#0c,#0c,#0c,#f0
	db #f4,#f0,#3c,#0c,#0c,#0c,#0c,#0c
	db #0c,#08,#f4,#3c,#3c,#0c,#30,#30
	db #30,#30,#30,#34,#00,#3c,#3d,#3a
	db #00,#00,#00,#00,#14,#3c,#3c,#00
	db #3f,#2a,#00,#00,#00,#00,#3c,#3c
	db #3c,#3c,#bd,#2a,#00,#00,#00,#00
	db #3e,#3c,#3c,#3c,#fc,#2a,#00,#00
	db #00,#15,#3f,#3c,#3c,#7c,#fc,#2a
	db #00,#00,#00,#3f,#3f,#3c,#3c,#7c
	db #fc,#00,#00,#28,#54,#bd,#3f,#3c
	db #3c,#7c,#a8,#00,#14,#28,#fc,#bd
	db #3f,#14,#3c,#fc,#a8,#00,#14,#7c
	db #fc,#bd,#00,#00,#00,#fc,#00,#00
	db #14,#7c,#fc,#a8,#00,#00,#00,#3c
	db #3c,#00,#14,#7c,#fc,#00,#00,#00
	db #00,#3c,#3c,#28,#14,#7c,#00,#00
	db #00,#00,#00,#3c,#3c,#28,#14,#28
	db #00,#00,#00,#00,#00,#00,#3c,#00
;;---------------------------------------------------------
;; Kozak dancing 7 (10x32)
;;#6c23
KOZAK6_BMP:
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#58,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#a4,#f0,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#58,#a4,#0c,#0c
	db #0c,#0c,#08,#04,#0c,#0c,#58,#a4
	db #0c,#0c,#0c,#0c,#00,#00,#0c,#0c
	db #fc,#0c,#0c,#0c,#0c,#08,#00,#00
	db #0c,#0c,#7c,#0c,#0c,#0c,#0c,#08
	db #00,#00,#0c,#0c,#3c,#0c,#0c,#0c
	db #0c,#08,#00,#00,#0c,#0c,#3c,#0c
	db #0c,#0c,#0c,#08,#00,#d0,#0c,#1c
	db #3c,#0c,#0c,#0c,#0c,#0c,#40,#f0
	db #0c,#1c,#3c,#0c,#0c,#0c,#0c,#0c
	db #58,#78,#0c,#1c,#3c,#0c,#0c,#0c
	db #0c,#0c,#58,#b5,#0c,#3c,#2c,#0c
	db #0c,#0c,#0c,#0c,#0c,#3f,#1c,#3c
	db #2c,#0c,#0c,#0c,#0c,#0c,#0c,#2a
	db #3c,#3c,#2c,#0c,#0c,#0c,#0c,#0c
	db #0c,#28,#3c,#3c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#3c,#3c,#3c,#0c,#0c
	db #0c,#0c,#0c,#0c,#3c,#3c,#3c,#3c
	db #0c,#0c,#0c,#0c,#0c,#1c,#3c,#3c
	db #3c,#04,#0c,#0c,#0c,#0c,#0c,#3c
	db #3c,#3c,#28,#0c,#3c,#0c,#30,#30
	db #34,#3c,#3c,#28,#14,#3c,#3d,#3a
	db #50,#e0,#3c,#3c,#3c,#14,#3c,#3c
	db #3f,#2a,#00,#f0,#3c,#3c,#c0,#3c
	db #3c,#3c,#bd,#2a,#50,#f0,#3c,#68
	db #3e,#3c,#3c,#3c,#fc,#2a,#f0,#00
	db #14,#95,#3f,#3c,#3c,#7c,#fc,#2a
	db #a0,#00,#00,#3f,#3f,#3c,#3c,#7c
	db #fc,#00,#00,#28,#54,#bd,#3f,#3c
	db #3c,#7c,#a8,#00,#14,#28,#fc,#bd
	db #3f,#14,#3c,#fc,#a8,#00,#14,#7c
	db #fc,#bd,#00,#00,#00,#fc,#00,#00
	db #14,#7c,#fc,#a8,#00,#00,#00,#3c
	db #3c,#00,#14,#7c,#fc,#00,#00,#00
	db #00,#3c,#3c,#28,#14,#7c,#00,#00
	db #00,#00,#00,#3c,#3c,#28,#14,#28
	db #00,#00,#00,#00,#00,#00,#3c,#00
;;---------------------------------------------------------
;; Kozak dancing 7 (10x32)
;;#6d63
KOZAK7_BMP:	
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #00,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#08,#00,#04,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#08,#00,#00,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#08,#00,#00
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#08
	db #00,#00,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#58,#80,#00,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#58,#e0,#04,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#58,#78,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#1d
	db #f0,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#1d,#2e,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1c,#28,#2e,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#3c,#28,#3c,#2c
	db #0c,#0c,#0c,#0c,#0c,#1c,#3c,#3c
	db #3c,#3c,#0c,#0c,#0c,#0c,#0c,#3c
	db #3c,#3c,#3c,#3c,#2c,#0c,#0c,#0c
	db #0c,#3c,#3c,#3c,#3c,#3c,#2c,#0c
	db #0c,#0c,#0c,#3c,#2c,#3c,#3c,#3c
	db #2c,#0c,#0c,#0c,#0c,#1c,#7c,#3c
	db #3c,#bc,#2c,#0c,#0c,#0c,#0c,#0c
	db #7c,#b4,#78,#bc,#0c,#0c,#30,#30
	db #30,#3a,#7c,#b4,#78,#bc,#30,#30
	db #00,#00,#15,#3f,#3c,#a0,#50,#28
	db #00,#00,#00,#00,#15,#7e,#3c,#3c
	db #3c,#3d,#00,#00,#00,#00,#15,#fc
	db #3c,#3c,#3c,#3f,#2a,#00,#00,#00
	db #15,#fc,#bc,#3c,#3c,#bd,#2a,#00
	db #00,#00,#00,#fc,#bc,#3c,#3c,#fc
	db #2a,#00,#00,#00,#00,#54,#a8,#3c
	db #7c,#fc,#2a,#00,#00,#00,#00,#54
	db #fc,#3c,#54,#fc,#00,#00,#00,#00
	db #00,#00,#fc,#00,#fc,#a8,#00,#00
	db #00,#00,#00,#54,#fc,#00,#fc,#00
	db #00,#00,#00,#00,#00,#fc,#bc,#00
	db #7c,#a8,#00,#00,#00,#00,#00,#fc
	db #3c,#00,#3c,#fc,#00,#00,#00,#00
	db #00,#3c,#00,#00,#00,#3c,#00,#00
;;---------------------------------------------------------
;; Kozak dancing 8 (10x32)
;;#6ea3
KOZAK8_BMP:	 	
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#00,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#08
	db #00,#04,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#00,#00,#04,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#00,#00,#04,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#00,#00,#04
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#00
	db #40,#a4,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#08,#d0,#a4,#0c,#0c,#0c,#0c
	db #0c,#0c,#0c,#0c,#b4,#a4,#0c,#0c
	db #0c,#0c,#0c,#0c,#0c,#0c,#f0,#2e
	db #0c,#0c,#0c,#0c,#0c,#0c,#0c,#0c
	db #1d,#2e,#0c,#0c,#0c,#0c,#0c,#0c
	db #0c,#0c,#1d,#14,#2c,#0c,#0c,#0c
	db #0c,#0c,#0c,#1c,#3c,#14,#3c,#0c
	db #0c,#0c,#0c,#0c,#0c,#3c,#3c,#3c
	db #3c,#2c,#0c,#0c,#0c,#0c,#1c,#3c
	db #3c,#3c,#3c,#3c,#0c,#0c,#0c,#0c
	db #1c,#3c,#3c,#3c,#3c,#3c,#0c,#0c
	db #0c,#0c,#1c,#3c,#3c,#3c,#1c,#3c
	db #0c,#0c,#0c,#0c,#1c,#7c,#3c,#3c
	db #bc,#2c,#0c,#0c,#0c,#0c,#0c,#7c
	db #b4,#78,#bc,#0c,#0c,#0c,#30,#30
	db #30,#7c,#b4,#78,#bc,#35,#30,#30
	db #00,#00,#00,#14,#a0,#50,#3c,#3f
	db #2a,#00,#00,#00,#00,#3e,#3c,#3c
	db #3c,#bd,#2a,#00,#00,#00,#15,#3f
	db #3c,#3c,#3c,#fc,#2a,#00,#00,#00
	db #15,#7e,#3c,#3c,#7c,#fc,#2a,#00
	db #00,#00,#15,#fc,#3c,#3c,#7c,#fc
	db #00,#00,#00,#00,#15,#fc,#bc,#3c
	db #54,#a8,#00,#00,#00,#00,#00,#fc
	db #a8,#3c,#fc,#a8,#00,#00,#00,#00
	db #00,#54,#fc,#00,#fc,#00,#00,#00
	db #00,#00,#00,#00,#fc,#00,#fc,#a8
	db #00,#00,#00,#00,#00,#54,#bc,#00
	db #7c,#fc,#00,#00,#00,#00,#00,#fc
	db #3c,#00,#3c,#fc,#00,#00,#00,#00
	db #00,#3c,#00,#00,#00,#3c,#00,#00
;;---------------------------------------------------------
;; Kazatchock melody data [duration,note]...[#FF] 
;;#6fe3
KAZATCHOK_MELODY:
	db #1e,#00,#d5,#0a,#00,#be,#1e,#00
	db #b3,#0a,#00,#d5,#0a,#00,#b3,#0a
	db #00,#b3,#0a,#00,#be,#0a,#00,#d5
	db #14,#00,#be,#14,#01,#1c,#1e,#00
	db #be,#0a,#00,#b3,#1e,#00,#9f,#0a
	db #00,#be,#0a,#00,#9f,#0a,#00,#9f
	db #0a,#00,#b3,#0a,#00,#be,#28,#00
	db #d5,#14,#00,#8e,#14,#00,#6a,#14
	db #00,#77,#0a,#00,#6a,#0a,#00,#77
	db #0f,#00,#86,#05,#00,#86,#05,#00
	db #86,#05,#00,#8e,#05,#00,#9f,#14
	db #00,#8e,#14,#00,#d5,#0a,#00,#00
	db #14,#00,#86,#0a,#00,#9f,#1e,#00
	db #8e,#0a,#00,#b3,#0a,#00,#9f,#0a
	db #00,#9f,#0a,#00,#b3,#0a,#00,#be
	db #0a,#00,#d5,#0a,#00,#be,#0a,#00
	db #b3,#0a,#00,#9f,#14,#00,#8e,#14
	db #00,#6a,#14,#00,#77,#0a,#00,#6a
	db #0a,#00,#77,#0a,#00,#86,#0a,#00
	db #86,#0a,#00,#8e,#0a,#00,#9f,#14
	db #00,#8e,#14,#00,#d5,#0a,#00,#00
	db #14,#00,#86,#0a,#00,#9f,#1e,#00
	db #8e,#0a,#00,#b3,#0a,#00,#be,#0a
	db #01,#1c,#0a,#00,#b3,#0a,#00,#be
	db #28,#00,#d5,#1e,#00,#a9,#0a,#00
	db #9f,#1e,#00,#8e,#0a,#00,#7f,#0a
	db #00,#8e,#0a,#00,#7f,#0a,#00,#71
	db #0a,#00,#6a,#14,#00,#6a,#14,#00
	db #9f,#1e,#00,#9f,#0a,#00,#8e,#1e
	db #00,#71,#0a,#00,#7f,#0a,#00,#8e
	db #0a,#00,#8e,#05,#00,#9f,#05,#00
	db #a9,#0a,#00,#9f,#28,#00,#a9,#14
	db #00,#a9,#14,#00,#9f,#1e,#00,#8e
	db #0a,#00,#7f,#0a,#00,#8e,#0a,#00
	db #7f,#0a,#00,#71,#0a,#00,#6a,#14
	db #00,#6a,#14,#00,#9f,#0a,#00,#00
	db #14,#00,#9f,#0a,#00,#8e,#0a,#00
	db #71,#0a,#00,#7f,#0a,#00,#8e,#0a
	db #00,#9f,#0a,#00,#a9,#0a,#00,#a9
	db #05,#00,#be,#05,#00,#d5,#0a,#00
	db #e1,#ff
;;---------------------------------------------------------
;; Game melody data [note]...[#FF] 
;; Note durations are fixed to 200ms (10 frames)
;;#7125
GAME_MELODY:
	db #7f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#8e,#9f,#a9,#be,#be
	db #7f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#8e,#9f,#a9,#7f,#7f
	db #7f,#7f,#77,#77,#8e,#7f,#77,#5f
	db #5f,#77,#7f,#7f,#9f,#8e,#7f,#5f
	db #5f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#9f,#a9,#be,#7f,#7f
	db #7f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#8e,#9f,#a9,#be,#be
	db #7f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#8e,#9f,#a9,#7f,#7f
	db #7f,#7f,#77,#77,#8e,#7f,#77,#5f
	db #5f,#77,#7f,#7f,#9f,#8e,#7f,#5f
	db #5f,#7f,#8e,#8e,#a9,#9f,#8e,#8e
	db #a9,#9f,#8e,#8e,#9f,#a9,#be,#be
	db #be,#5f,#6a,#6a,#8e,#7f,#77,#77
	db #7f,#8e,#9f,#9f,#d5,#d5,#d5,#d5
	db #00,#5f,#6a,#6a,#8e,#7f,#77,#77
	db #7f,#8e,#9f,#9f,#9f,#9f,#9f,#9f
	db #00,#9f,#be,#be,#be,#a9,#8e,#9f
	db #a9,#be,#d5,#d5,#6a,#6a,#7f,#7f
	db #7f,#9f,#be,#be,#be,#a9,#8e,#9f
	db #a9,#be,#6a,#6a,#77,#77,#7f,#7f
	db #7f,#7f,#ff


;;---------------------------------------------------------
;; High score changed
;;#71e8	
hscore_changed	 db #00 

;;---------------------------------------------------------
;; Strings (they are not null terminated thus all lengths are hard coded :-) )
;;#71e9
L_AMANT_STR:	 db "L''AMANT:"
LES_STR:	 db "LES"
MEILLEURS_STR:	 db "MEILLEURS"
SOUPIRANTS_STR:	 db "SOUPIRANTS"

HSCORES_TABLE	 equ $
AMANT_NAME:	 db "RIX "		;;#7207
AMANT_SCORE:	 db "40000"		;;#720b"
HSCORE1:	 db "RIX30000...01"	;;#7210
HSCORE2:	 db "PAT25000...01"	;;#721d
HSCORE3:	 db "THB20000...01"	;;#722a
HSCORE4:	 db "ZOU15000...01"	;;#7237
HSCORE5:	 db "TKD10000...01"	;;#7244
HSCORES_TABLE_END equ $

DEFI_CHOICE_STR: db "DEFI NUMERO .."	;;#7251
OK_STR:		 db "OK"		;;#725f
INVALID_STR:	 db "INVALIDE"		;;#7261
INFO_DEFI_STR: 	 db "DEFI  01"		;;#7269
INFO_LINES_STR:	 db "LIGNE 00"		;;#7271
INFO_BONUS_STR:	 db "BONUS 000"		;;#7279
SOUPIRANT1_STR:  db "SOUPIRANT 1"	;;#7282
SCORE1_STR:	 db "00000"		;;#728d
SCORE2_STR:	 db "00000"		;;#7292
SOUPIRANT2_STR:  db "SOUPIRANT 2"	;;#7297
ALINKA_STR:	 db "< ALINKA >"	;;#72a2
MENU1_STR:	 db "1-  1  SOUPIRANT" 	;;#72ac 
MENU2_STR:	 db "2-  2 SOUPIRANTS" 	;;#72bc
MENU3_STR:	 db "3- CHOIX DU DEFI" 	;;#72cc
MENU4_STR1:	 db "4- REDEFINIR LES"	;;#72dc
MENU4_STR2:	 db "TOUCHES"		;;#72ec
COPYRIGHT1_STR:  db "PROGRAMME  DE"	;;#72f3
COPYRIGHT2_STR:  db "ERIC  BOUCHER"	;;#7300
DROITE_STR:	 db "DROITE:"		;;#730d
GAUCHE_STR:	 db "GAUCHE:"		;;#7314
ACCELERE_STR:	 DB "ACCELERE:"		;;#731b
ROTATION_STR:	 db "ROTATION:"		;;#7324
PRET_STR:	 db "PRET"		;;#732d
DOMMAGE_STR:	 db "DOMMAGE"		;;#7331
TU_AS_STR:	 db "TU AS"		;;#7338
ECHOUE_STR:	 db "ECHOUE"		;;#733d
DAMNED_STR:	 db "DAMNED !!"		;;#7343
DEFI_STR:	 db "DEFI"		;;#734c
REMPORTE_STR: 	 db "REMPORTE"		;;#7350
TES_STR:	 db "TES"		;;#7358
INITIALES_STR:	 db "INITIALES"		;;#735b
DOTS_STR:	 db "..."		;;#7364
BRAVO_STR:	 db "BRAVO"		;;#7367
TU_ES_STR: 	 db "TU ES"		;;#736c
DEVENU_STR:	 db "DEVENU"		;;#7371
LE_TITRE_STR:	 db "LE TITRE"		;;#7377
D_STR:		 db "D''"		;;#737f
TU_N_AS_STR: 	 db "TU N''AS"		;;#7381
PAS_STR	:	 db "PAS"		;;#7388
MAIS_STR	 db "MAIS"		;;#738b
EN_TITRE_STR:	 db "EN TITRE"		;;#738f
MAESTRIA_STR:	 db "MAESTRIA"		;;#7397
RAPIDITE_STR:	 db "RAPIDITE"		;;#739f

COMBO_STR_TBL:	 db "------  50"	;;#73a7
		 db "AL---- 100"	;;#73b1
		 db "ALIN-- 200"	;;#73bb
		 db "ALINKA 400"	;;#73c5

DEFI2_STR:	 db "DEFI"		;;#73cf
LIGNES_STR:	 db "LIGNES"		;;#73d3
A_STR:		 db "A"			;;#73d9
COMPLETER_STR:	 db "COMPLETER"		;;#73da



KBD_MAP_LEN 	equ 78			;;#4e
KBD_MAP:				;;#73e3
	db #2b,#3d,#3e,#3c,#5f,#5e,#5a,#00
	db #41,#00,#51,#00,#32,#31,#58,#43
	db #44,#53,#57,#45,#33,#34,#56,#42
	db #46,#47,#54,#52,#35,#36,#20,#4e
	db #4a,#48,#59,#55,#37,#38,#2c,#4d
	db #4b,#4c,#49,#4f,#39,#30,#2e,#2f
	db #3a,#3b,#50,#40,#2d,#5e,#00,#5c
	db #00,#21,#5d,#0d,#5b,#10,#22,#23
	db #24,#25,#26,#27,#00,#08,#2e,#0d
	db #28,#29,#2a,#0a,#09,#0b


DANCE_TEMPO	equ 10
DANCE_TBL:				;;#7431
	dw KOZAK1_BMP ;;#65e3
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK4_BMP ;;#69a3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK3_BMP ;;#6863
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK2_BMP ;;#6723
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK5_BMP ;;#6ae3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK6_BMP ;;#6c23
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK3_BMP ;;#6863
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK4_BMP ;;#69a3
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK2_BMP ;;#6723
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK5_BMP ;;#6ae3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK6_BMP ;;#6c23
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK2_BMP ;;#6723
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK3_BMP ;;#6863
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK1_BMP ;;#65e3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK5_BMP ;;#6ae3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK2_BMP ;;#6723
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK6_BMP ;;#6c23
	dw KOZAK7_BMP ;;#6d63
	dw KOZAK5_BMP ;;#6ae3
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK3_BMP ;;#6863
	dw KOZAK8_BMP ;;#6ea3
	dw KOZAK6_BMP ;;#6c23
	db #ff

;;#7480
	db #00		;; ???

;;#7481
cur_level_ptr	dw LEVEL_01	;; current player level ptr
;;#7483
p1_level_ptr	dw #0000	;; P1 level ptr
;;#7485
p2_level_ptr	dw #0000	;; P2 level ptr


;; 31 Level entries
;; 1 entry is 7 bytes long
;;    	0: nb lines ten''s
;;    	1: nb lines unit''s
;;    	2: ???? related to speed
;;    	3: trick flags, ie reverse rotation, reverse direction, random block, random lines
;;    	4: initial playground setup ptr LSB
;;    	5: initial playground setup ptr HSB
;;    	6: Kozak dance at the end: 0 or 1
;;#7487
LEVEL_TABLE:
LEVEL_01:	
	db #01,#06	;; 05 lignes
	db #32		;; speed #32
	db #00		;; no tricks
	dw PLAYGND_01	;; initial setup 
	db #00		;; No dance 
	
LEVEL_02:	
	db #01,#09	
	db #2d
	db #00
	dw PLAYGND_01
	db #00

LEVEL_03:
	db #02,#03
	db #28
	db #00
	dw PLAYGND_01
	db #01
		
LEVEL_04:
	db #01,#09
	db #23
	db #00
	dw PLAYGND_02
	db #00
		
LEVEL_05:
	db #02,#03
	db #1e
	db #00
	dw PLAYGND_03
	db #00
		
LEVEL_06:
	db #02,#06
	db #19
	db #00
	dw PLAYGND_04
	db #01
		
LEVEL_07:
	db #01,#09
	db #19
	db #80
	dw PLAYGND_01
	db #00
	
LEVEL_08:
	db #02,#03
	db #16
	db #80
	dw PLAYGND_01
	db #00

LEVEL_09:
	db #02,#06
	db #14
	dw #e380
	db #75
	db #01
	
LEVEL_10:
	db #01,#09
	db #16
	db #40
	dw PLAYGND_01
	db #00
	
LEVEL_11:
	db #02,#03
	db #14
	db #40
	dw PLAYGND_01
	db #00
	
LEVEL_12:
	db #02,#06
	db #13
	db #40
	dw PLAYGND_01
	db #01
	
LEVEL_13:
	db #02,#03
	db #1e
	db #20
	dw PLAYGND_05
	db #00
	
LEVEL_14:
	db #02,#06
	db #1b
	db #20
	dw PLAYGND_06
	db #00
	
LEVEL_15:
	db #02,#09
	db #19
	db #20
	dw PLAYGND_07
	db #01
	
LEVEL_16:
	db #02,#03
	db #1b
	db #a0
	dw PLAYGND_08
	db #00
	
LEVEL_17:
	db #02,#06
	db #1b
	db #a0
	dw PLAYGND_09
	db #00
	
LEVEL_18:
	db #02,#09
	db #1b
	db #a0
	dw PLAYGND_10
	db #01
	
LEVEL_19:
	db #02,#03
	db #19
	db #60
	dw PLAYGND_11
	db #00
	
LEVEL_20:
	db #02,#06
	db #19
	db #60
	dw PLAYGND_12
	db #00
	
LEVEL_21:
	db #02,#09
	db #19
	db #60
	dw PLAYGND_13
	db #01
	
LEVEL_22:
	db #02,#06
	db #17
	db #10
	dw PLAYGND_14
	db #00
	
LEVEL_23:
	db #02,#09
	db #17
	db #10
	dw PLAYGND_15
	db #00
	
LEVEL_24:
	db #03,#01
	db #17
	db #10
	dw PLAYGND_16
	db #01
	
LEVEL_25:
	db #02,#06
	db #16
	db #90
	dw PLAYGND_17
	db #00
	
LEVEL_26:
	db #02,#09
	db #16
	db #90
	dw PLAYGND_18
	db #00
	
LEVEL_27:
	db #03,#01
	db #16
	db #90
	dw PLAYGND_19
	db #01
	
LEVEL_28:
	db #02,#06
	db #15
	db #50
	dw PLAYGND_20
	db #00
	
LEVEL_29:
	db #02,#09
	db #15
	db #50
	dw PLAYGND_21
	db #00
	
LEVEL_30:
	db #03,#01
	db #15
	db #50
	dw PLAYGND_22
	db #01
	
LEVEL_31:
	db #03,#01
	db #0f
	db #f0
	dw PLAYGND_23
	db #01

;;#7560
combo_lines:	 db #00		;; Count number of removed line with one piece

;;#7561
cur_score_scr: 	 dw #0000 	;; Current score screen location

;;#7563
		 dw #0000

;;#7565
cur_player	 db #00 	;; player +1

;;#7566
p1_game_over	 db #00  	;; True when player 1 is game over

;;#7567
p2_game_over	 db #00		;; True when player 2 is game over

;;#7568
cur_score_X00001: db #00 	;; score X00001 +1
cur_score_X00010: db #00 	;; score X00010 +1
cur_score_X00100: db #00	;; score X00100 +1
cur_score_X01000: db #00	;; score X01000 +1
cur_score_X10000: db #00	;; score X10000 +1

;;#756d
p1_score_X00001: db #00 	;; player 1 score X00001 +1
p1_score_X00010: db #00		;; player 1 score X00010 +1
p1_score_X00100: db #00		;; player 1 score X00100 +1
p1_score_X01000: db #00		;; player 1 score X01000 +1
p1_score_X10000: db #00		;; player 1 score X10000 +1

;;#7572
p2_score_X00001: db #00		;; player 2 score X00001 +1
p2_score_X00010: db #00		;; player 2 score X00010 +1
p2_score_X00100: db #00		;; player 2 score X00100 +1
p2_score_X01000: db #00		;; player 2 score X01000 +1
p2_score_X10000: db #00		;; player 2 score X10000 +1

;;#7577
cur_level_X10: db #00		;; level X10 +1
cur_level_X01: db #00		;; level X01 +1

;;#7579
cur_lignes_X10: db #00		;; current lignes X10 +1
cur_lignes_X01: db #00		;; current lignes X01 +1

;;#757b
cur_bonus_X100: db #00		;; bonus X100 +1
cur_bonus_X010: db #00		;; bonus X010 +1
cur_bonus_X001: db #00		;; bonus X001 +1

;;#757e
piece_cur_msk_pos: dw #0000	;; current piece position in mask playground.
piece_prv_msk_pos: dw #0000	;; current piece next position in mask playground

;;#7582
playgnd_top_idx: db #00		;; playground''s top line index
piece_top_idx:	 db #00		;; piece''s top line index


;;#7584
;; mask playground''s bottom of piece line address

piece_msk_bottom:	dw #0000
PIECE_MASK_BOTTOM_START	equ #3eea	;; Starting value of the piece''s mask bottom line

;;#7586
;; screen playground''s bottom of piece line address
piece_scr_bottom:	dw #0000
PIECE_SCR_BOTTOM_START	equ #e22a

;;#7588
;; bmp playground''s bottom of piece line address
piece_bmp_bottom:	dw #0000
PIECE_BMP_BOTTOM_START	equ #30d2

;;#758a
;; number of lines from the top of the playground mask
nb_msk_lines:		db #00
NB_MSK_LINES_START	equ 3

;;#758b
;; number of lines from the top of the playground bitmap
nb_bmp_lines:		db #00
NB_BMP_LINES_START	equ 24


;;#758c
;; point to the next combo string
combo_str: 	 	dw #0000	

;;#758e
;; current piece bitmap position
piece_cur_bmp_pos: 	dw #0000	

;;#7590
;; current piece previous screen position before move
piece_prv_scr_pos: 	dw #0000 	

;;#7592
;; current piece previsou bitmap position before move
piece_prv_bmp_pos: 	dw #0000

;;#7594	
;; current piece previous bitmap pointer
piece_prv_bmp:	  	dw #0000 

;;#7596	
;; current piece previous bitmap dimensions (w/h)
piece_prv_dim:	  	dw #0000

;;#7598
;; Next piece definition''s structure ( #1E|30 bytes long )
nxt_piece_prz_pos: 	dw #0000	;; [0,1]  : piece''s presentation screen addr
;;#759a
nxt_piece_scr_pos:  	dw #0000	;; [2,3]  : piece initial screen position
;;#759c
nxt_piece_cur_bmp:  	dw #0000	;; [4,5]  : memory bmp source addr
;;#759e
nxt_piece_cur_dim:  	dw #0000	;; [6,7]  : bmp dimensions: width and height
;;#76a0
nxt_piece_msk_B1:   	dw #0000	;; [8,9]  : mask offset from piece origin of block 1 of the current piece
;;#76a2
nxt_piece_msk_B2:   	dw #0000	;; [10,11]: mask offset from piece origin of block 2 of the current piece
;;#76a4
nxt_piece_msk_B3:   	dw #0000	;; [12,13]: mask offset from piece origin of block 3 of the current piece
;;#76a6
nxt_piece_msk_B4:   	dw #0000	;; [14,15]: mask offset from piece origin of block 4 of the current piece
;;#76a8
nxt_piece_rot_bmp_ofst: dw #0000	;; [16,17]: offset to apply to offscreen position when rotating
;;#76aa
nxt_piece_rot_scr_ofst:	dw #0000	;; [18,19]: offset to apply to screen position when rotating
;;#76ac
nxt_piece_rot_bmp:  	dw #0000	;; [20,11]: bitmap pointer to the rotated piece
;;#76ae
nxt_piece_rot_B1:   	dw #0000	;; [22,13]: mask offset of block 1 of the rotated piece
;;#76b0
nxt_piece_rot_B2:   	dw #0000	;; [24,25]: mask offset of block 2 of the rotated piece
;;#76b2
nxt_piece_rot_B3:   	dw #0000	;; [26,27]: mask offset of block 3 of the rotated piece
;;#76b4
nxt_piece_rot_B4:   	dw #0000	;; [28,29]: mask offset of block 4 of the rotated piece



;;#75b6	;; piece current screen position
;; Current piece definition''s structure ( #1c|28 bytes long )
;; Same as next piece structure, except we dont'' need piece''s presentation screen address
piece_src_pos: 		dw #0000
;;#75b8 
piece_bmp:	   	dw #0000	;; piece bitmap
;;#75ba 
piece_dim:	   	dw #0000	;; piece size (w/h)
;;#75bc 
miece_msk_B1: 	   	dw #0000	;; mask offset from piece origin of block 1 of the current piece
;;#75be
piece_msk_B2: 	   	dw #0000	;; mask offset from piece origin of block 1 of the current piece
;;#75c0
piece_msk_B3: 	   	dw #0000	;; mask offset from piece origin of block 1 of the current piece
;;#75c2
piece_msk_B4:	   	dw #0000	;; mask offset from piece origin of block 1 of the current piece
;;#75c4
piece_rot_bmp_ofst:	dw #0000    ;; offset to apply to offscreen position when rotating
;;#75c6
piece_rot_scr_ofst: 	dw #0000    ;; offset to apply to screen position when rotating
;;#75c8
piece_rot_bmp: 	   	dw #0000	;; bitmap pointer to the rotated piece
;;#75ca
piece_rot_B1:	   	dw #0000	;; mask offset of block 1 of the rotated piece
;;#75cc
piece_rot_B2:	   	dw #0000	;; mask offset of block 2 of the rotated piece
;;#75ce
piece_rot_B3:	   	dw #0000	;; mask offset of block 3 of the rotated piece
;;#75d0
piece_rot_B4:	   	dw #0000	;; mask offset of block 4 of the rotated piece


;;#75d2
blibliblip_pitch   	db #00		;; Completed line bliblibliiip pitch

;;#75d3
landup_sound:		
	db #c8,#00
	db #00,#00
	db #0f,#06
	db #30,#07
	db #10,#08
	db #90,#0b
	db #01,#0c
	db #00,#0d
LANDUP_SOUND_LEN	equ #08


;;#75e3
PLAYGND_01:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
;;#762b
PLAYGND_02:
	db 1,2,0,0,0,0,0,0,0,0,2,1
	db 1,4,0,0,0,0,0,0,0,0,4,1
	db 1,6,0,0,0,0,0,0,0,0,6,1
	db 1,3,0,0,0,0,0,0,0,0,3,1
	db 1,5,0,0,0,0,0,0,0,0,5,1
	db 1,7,0,0,0,0,0,0,0,0,7,1
;;#7673
PLAYGND_03:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,3,3,0,0,0,0,1
	db 1,0,0,0,3,2,1,3,0,0,0,1
	db 1,0,0,3,7,5,6,2,3,0,0,1
	db 1,0,3,3,3,3,3,3,3,3,0,1
;;#76bb
PLAYGND_04:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,3,0,2,0,0,0,1
	db 1,0,7,0,0,0,0,0,0,1,0,1
	db 1,0,0,0,5,0,6,0,0,0,0,1
	db 1,0,2,0,0,0,0,0,4,0,0,1
	db 1,0,0,0,0,3,0,0,0,0,5,1
;;#7703
PLAYGND_05:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,1,0,0,0,0,0,0,0,0,1,1
	db 1,2,1,0,0,0,0,0,0,1,3,1
	db 1,3,2,1,0,0,0,0,1,3,2,1
	db 1,2,1,0,0,0,0,0,0,1,3,1
	db 1,1,0,0,0,0,0,0,0,0,1,1
;;#774b
PLAYGND_06:
	db 1,5,5,5,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,7,7,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,2,0,1
	db 1,1,0,0,0,0,0,4,0,2,0,1
	db 1,0,0,0,0,1,0,4,0,2,0,1
;;#7793
PLAYGND_07:
	db 1,1,0,0,0,0,0,0,0,0,0,1
	db 1,0,6,0,0,0,5,0,0,0,0,1
	db 1,0,0,1,0,0,0,5,0,5,0,1
	db 1,0,0,6,0,0,0,0,5,0,0,1
	db 1,0,1,0,0,0,0,0,5,0,0,1
	db 1,6,0,0,0,0,0,0,0,5,0,1
;;#77db
PLAYGND_08:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,2,0,3,0,4,0,5,0,6,1
	db 1,1,0,7,0,2,0,6,0,3,0,1
;;#7823
PLAYGND_09:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,5,0,2,0,3,0,7,0,1,1
	db 1,1,0,4,0,7,0,6,0,2,0,1
	db 1,0,3,0,5,0,2,0,5,0,1,1
	db 1,2,0,7,0,6,0,1,0,2,0,1
;;#786b
PLAYGND_10:
	db 1,0,2,0,3,0,5,0,7,0,1,1
	db 1,5,0,2,0,4,0,3,0,2,0,1
	db 1,0,6,0,5,0,2,0,4,0,3,1
	db 1,5,0,2,0,4,0,1,0,2,0,1
	db 1,0,1,0,2,0,3,0,4,0,5,1
	db 1,5,0,4,0,3,0,7,0,2,0,1
;;#78b3
PLAYGND_11:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,1,0,0,0,0,0,0,0,0,2,1
	db 1,0,1,0,0,0,0,0,0,2,0,1
	db 1,0,0,1,0,0,0,0,2,2,0,1
	db 1,0,1,0,1,0,0,2,0,2,0,1
;;#78fb
PLAYGND_12:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,3,3,0,0,0,0,0,1,0,1
	db 1,0,0,3,0,5,5,0,1,1,0,1
	db 1,0,0,0,0,0,5,0,0,0,0,1
	db 1,0,0,4,0,0,0,0,7,7,0,1
	db 1,0,0,4,4,0,0,0,7,0,0,1
;;#7943
PLAYGND_13:
	db 1,0,0,1,0,0,0,0,1,0,0,1
	db 1,0,7,0,0,1,0,0,0,2,0,1
	db 1,7,0,0,0,0,3,0,0,0,2,1
	db 1,0,0,5,0,1,0,0,6,0,0,1
	db 1,0,5,0,0,0,3,0,0,6,0,1
	db 1,5,0,0,0,0,0,0,0,0,6,1
;;#798b
PLAYGND_14:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,1,1,1,0,2,0,5,0,5,0,1
	db 1,1,0,1,0,2,0,5,0,5,0,1
	db 1,1,1,0,0,2,0,0,5,0,0,1
	db 1,1,0,1,0,2,0,5,0,5,0,1
	db 1,1,0,1,0,2,0,5,0,5,0,1
;;#79d3
PLAYGND_15:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,1,1,1,0,1,0,1,0,1,0,1
	db 1,0,0,2,2,0,2,2,0,2,0,1
	db 1,0,3,0,3,0,3,3,0,3,0,1
	db 1,5,0,0,5,0,5,5,0,5,0,1
	db 1,7,7,7,0,7,0,0,7,0,0,1
;;#7a1b
PLAYGND_16:
	db 1,0,0,0,0,0,0,0,0,0,0,1
	db 1,0,1,1,3,3,3,0,1,1,0,1
	db 1,1,0,0,3,0,3,1,0,0,0,1
	db 1,1,0,0,3,3,3,1,0,0,0,1
	db 1,1,0,0,3,0,0,1,0,0,0,1
	db 1,0,1,1,3,0,0,0,1,1,0,1
;;#7a63
PLAYGND_17:
	db 1,0,0,0,0,0,0,2,0,0,0,1
	db 1,0,7,0,0,0,2,2,0,0,0,1
	db 1,0,0,7,7,2,0,2,0,0,7,1
	db 1,0,0,0,2,7,7,7,7,7,0,1
	db 1,2,0,2,0,0,0,0,2,0,0,1
	db 1,0,2,0,0,0,0,0,0,2,0,1
;;#7aab
PLAYGND_18:
	db 1,0,0,0,4,0,0,0,0,0,0,1
	db 1,0,0,0,4,0,0,0,0,0,0,1
	db 1,0,0,0,4,0,0,0,0,0,0,1
	db 1,0,0,4,0,0,0,0,0,0,0,1
	db 1,0,0,4,0,0,0,0,4,0,0,1
	db 1,0,4,4,4,4,4,4,0,0,0,1
;;#7af3
PLAYGND_19:
	db 1,0,0,0,1,1,1,1,0,0,0,1
	db 1,0,0,0,0,0,1,0,0,0,0,1
	db 1,0,0,0,0,0,1,0,0,0,0,1
	db 1,0,0,0,0,1,0,0,0,0,0,1
	db 1,0,0,0,0,1,0,0,0,0,0,1
	db 1,0,0,1,1,1,1,1,0,0,0,1
;;#7b3b
PLAYGND_20:
	db 1,0,0,0,0,7,3,0,0,7,7,1
	db 1,0,0,0,7,0,3,0,0,7,0,1
	db 1,0,0,0,7,0,3,0,7,0,0,1
	db 1,0,0,7,0,0,3,7,0,0,0,1
	db 1,7,0,7,0,3,7,0,0,0,0,1
	db 1,0,7,0,0,7,0,0,0,0,0,1
;;#7b83
PLAYGND_21:
	db 1,0,0,0,5,0,0,0,0,0,0,1
	db 1,0,0,0,5,0,0,0,5,0,0,1
	db 1,0,0,0,0,5,0,5,0,0,0,1
	db 1,0,0,0,0,5,5,0,0,0,0,1
	db 1,0,0,0,5,5,0,5,0,0,0,1
	db 1,0,0,5,5,0,0,5,0,0,0,1
;;#7bcb
PLAYGND_22:
	db 1,0,0,0,0,0,0,2,0,0,0,1
	db 1,0,7,0,0,0,2,2,0,0,0,1
	db 1,0,0,7,7,2,0,2,0,0,7,1
	db 1,0,0,0,2,7,7,7,7,7,0,1
	db 1,2,0,2,0,0,0,0,2,0,0,1
	db 1,0,2,0,0,0,0,0,0,2,0,1
;;#7c13
PLAYGND_23:
	db 1,1,1,1,1,1,0,0,0,0,0,1
	db 1,1,0,0,0,8,0,0,0,0,0,1
	db 1,1,1,1,0,0,0,0,0,0,0,1
	db 1,1,0,0,0,3,0,1,1,1,0,1
	db 1,1,0,0,0,3,0,1,0,1,0,1
	db 1,1,0,0,0,3,0,1,0,1,0,1

;;#7c5b
PIECES_DEFS:
	;; DW prz addr		;; presentation address
	;; DW scr addr		;; screen address
	;; DW bmp		;; bitmap
	;; DW dim		;; dim
	;; DW B1,B2,B3,B4	;; 
	;; DW rbmp offset	;; rotated bmp offset
	;; DW rscr offset	;; rotated scr offfset
	;; DW rpiece def		;; rotated piece def
	;; DW rB1,rB2,rB3,rB4	;; rotated blocks

;;#7c5b
PIECE_1_DEF:
	dw #e19c
	dw #e1b0
;;#7c5f
PIECE_1_1:
	dw PIECE_1_1_BMP	;;#5163
	db #06, #10
	dw #000c, #0001, #0001, #000a
	dw #00a0
	dw #0040
	dw PIECE_1_2		;;#7c79
	dw #0001, #000c, #000c, #0001
;;#7c79
PIECE_1_2:
	dw PIECE_1_2_BMP	;;#51c3
	db #04, #18
	dw #0001, #000c, #000c, #0001
	dw #ff62
	dw #ffc2
	dw PIECE_1_3		;;#7c93
	dw #0002, #000a, #0001, #0001
;;#7c93
PIECE_1_3:
	dw PIECE_1_3_BMP	;;#5223
	db #06, #10
	dw #0002, #000a, #0001, #0001
	dw #fffe
	dw #fffe
	dw PIECE_1_4		;;#7cad
	dw #0000, #0001, #000c, #000c
;;#7cad
PIECE_1_4:
	dw PIECE_1_4_BMP	;;#5283
	db #04, #18
	dw #0000, #0001, #000c, #000c
	dw #0000
	dw #0000
	dw PIECE_1_1		;;#7c5f
	dw #000c, #0001, #0001, #000a

;;#7cc7
PIECE_2_DEF:
	dw #e19c
	dw #e1b0
;;#7ccb
PIECE_2_1:
	dw PIECE_2_1_BMP	;;#52e3
	db #06, #10
	dw #000c, #0001, #0001, #000c
	dw #00a0
	dw #0040
	dw PIECE_2_2		;;#7ce5
	dw #0001, #0001, #000b, #000c
;;#7ce5
PIECE_2_2:
	dw PIECE_2_2_BMP	;;#5343
	db #04, #18
	dw #0001, #0001, #000b, #000c
	dw #ff62
	dw #ffc2
	dw PIECE_2_3		;;#7cff
	dw #0000, #000c, #0001, #0001
;;#7cff
PIECE_2_3:
	dw PIECE_2_3_BMP	;;#53a3
	db #06, #10
	dw #0000, #000c, #0001, #0001
	dw #fffe
	dw #fffe
	dw PIECE_2_4		;;#7d19
	dw #0001, #000c, #000b, #0001
;;#7d19
PIECE_2_4:
	dw PIECE_2_4_BMP	;;#5403
	db #04, #18
	dw #0001, #000c, #000b, #0001
	dw #0000
	dw #0000
	dw PIECE_2_1		;;#7ccb
	dw #000c, #0001, #0001, #000c


PIECE_3_DEF:
;;#7d33
	dw #e19c
	dw #e1b0
;;#7d37
PIECE_3_1:
	dw PIECE_3_1_BMP	;;#5463
	db #06, #10
	dw #000c, #0001, #0001, #000b
	dw #00a0
	dw #0040
	dw PIECE_3_2		;;#7d51
	dw #0001, #000c, #0001, #000b
;;#7d51
PIECE_3_2:
	dw PIECE_3_2_BMP	;;#54c3
	db #04, #18
	dw #0001, #000c, #0001, #000b
	dw #ff62
	dw #ffc2
	dw PIECE_3_3		;;#7d6b
	dw #0001, #000b, #0001, #0001
;;#7d6b
PIECE_3_3:
	dw PIECE_3_3_BMP	;;#5523
	db #06, #10
	dw #0001, #000b, #0001, #0001
	dw #fffe
	dw #fffe
	dw PIECE_3_4		;;#7d85
	dw #0001, #000b, #0001, #000c
;;#7d85
PIECE_3_4:
	dw PIECE_3_4_BMP	;;#5583
	db #04, #18
	dw #0001, #000b, #0001, #000c
	dw #0000
	dw #0000
	dw PIECE_3_1		;;#7c37
	dw #000c, #0001, #0001, #000b


;;#7d9f
PIECE_4_DEF:
	dw #e19c
	dw #e1b0
;;#7da3
PIECE_4_1:
	dw PIECE_4_1_BMP	;;#55e3
	db #06, #10
	dw #000d, #0001, #000a, #0001
	dw #009e
	dw #003e
	dw PIECE_4_2		;;#7ddb
	dw #0001, #000c, #0001, #000c
;;#7dbd
PIECE_4_2:
	dw PIECE_4_2_BMP	;;#5643
	db #04, #18
	dw #0001, #000c, #0001, #000c
	dw #ff62
	dw #ffc2
	dw PIECE_4_1		;;#7da3
	dw #000d, #0001, #000a, #0001


;;#7dd7
PIECE_5_DEF:
	dw #e19c
	dw #e1b0
;;#7ddb
PIECE_5_1:
	dw PIECE_5_1_BMP	;;#56a3
	db #06, #10
	dw #000c, #0001, #000c, #0001
	dw #009e
	dw #003e
	dw PIECE_5_2		;;#7df5
	dw #0002, #000b, #0001, #000b
;;#7df5
PIECE_5_2:
	dw PIECE_5_2_BMP	;;#5703
	db #04, #18
	dw #0002, #000b, #0001, #000b
	dw #ff62
	dw #ffc2
	dw PIECE_5_1		;;#7ddb
	dw #000c, #0001, #000c, #0001

;;#7e0f
PIECE_6_DEF:
	dw #c1db
	dw #e1b0
;;#7e13
PIECE_6_1:
	dw PIECE_6_1_BMP	;;#5763
	db #08, #08
	dw #000c, #0001, #0001, #0001
	dw #009e
	dw #003e
	dw PIECE_6_2		;;#7e2d
	dw #0001, #000c, #000c, #000c
;;#7e2d
PIECE_6_2:
	dw PIECE_6_2_BMP	;;#57a3
	db #02, #20
	dw #0001, #000c, #000c, #000c
	dw #ff62
	dw #ffc2
	dw PIECE_6_1		;;#7e13
	dw #000c, #0001, #0001, #0001

;;#7e47
PIECE_7_DEF:
	dw #e19d
	dw #e1b0
;;#7e4b
PIECE_7_1:
	dw PIECE_7_1_BMP	;;#57e3
	db #04, #10
	dw #000c, #0001, #000b, #0001
	dw #0000
	dw #0000
	dw PIECE_7_1		;;#7e4b
	dw #000c, #0001, #000b, #0001

;;#7e65

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

-- Project 166: soundgen by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'soundgen',
    'Imported from z80Code. Author: Unknown.',
    'public',
    false,
    false,
    '2019-09-08T08:28:18.395000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Sound generation
; You may need to click on the emu window to hear audio

 macro set_psg_reg_A reg     
    ld   D,0
    ld   BC,#f400 | {reg}
    out  (C),C
    ld   BC,#f6c0
    out  (C),C  
    out  (C),D
    ld   B,#f4
    out  (C),A
    ld   BC,#f680
    out  (C),C  
    out  (C),D
 mend

    di                      ; On coupe les interruptions
    ld  A,%101111110        ; Canal A ouvert uniquement
    set_psg_reg_A 7
    ld hl,0
    
    ld  BC,#7f10            ; Raster dans le border
    out (C),C              
    
mainlp:
    ld  e,0                 ; Data 
    ld a,R
    and e
    xor 15 
    ld (mainlp+1),a
    set_psg_reg_A 8         ; Vers le canal A
	
	and 31
    or  #40                 
    ld b,#7f 
    out (C),A   

    ld a,h
    ; Wait
 wtrnd:
    dec a
    jr nz,wtrnd   
    
    inc HL                  
    jp  mainlp              
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
