-- Migration: Import z80code projects batch 54
-- Projects 107 to 108
-- Generated: 2026-01-25T21:43:30.200179

-- Project 107: wav2ay2 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'wav2ay2',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-01-09T17:38:59.505000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '
;BUILDSNA
;BANK 1
                    org #4000
                    run #4000
start
                    di
                    ld hl, #c9fb
                    ld (#38), hl
                    ei
                    
                    ld c, 7
                    ld a, 8 + 16 + 32
                    call write_to_psg
main_loop:
                    ld b, #f5 
.vs:                in a, (c)
                    rra
                    jr nc, .vs

.ptr:               ld hl, table
                    ld a, (hl)
                    inc a
                    jr nz, .ok
                    ld hl, table
.ok
					inc hl
repeat 9
                    ld c, (hl)
                    inc hl
                    ld a, (hl)
                    inc hl
                    call write_to_psg
rend
   
.end                ld (.ptr + 1), hl 
					halt : halt
                    jp main_loop


;; entry conditions:
;; C = register number
;; A = register data
;; exit conditions:
;; b,C,F corrupt
;; assumptions:
;; PPI port A and PPI port C are setup in output mode.
write_to_psg
ld b,#f4            ; setup PSG register number on PPI port A
out (c),c           ;

ld bc,#f6c0         ; Tell PSG to select register from data on PPI port A
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state.
out (c),c           ;

ld b,#f4            ; setup register data on PPI port A
out (c),a           ;

ld bc,#f680         ; Tell PSG to write data on PPI port A into selected register
out (c),c           ;

ld bc,#f600         ; Put PSG into inactive state
out (c),c           ;
ret


table

; idx,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value,reg,value
db 0, 8, 8, 0, 76, 1, 3, 9, 7, 2, 248, 3, 1, 10, 4, 4, 228, 5, 0
db 1, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 2, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 3, 8, 7, 0, 22, 1, 1, 9, 6, 2, 167, 3, 0, 10, 3, 4, 115, 5, 1
db 4, 8, 9, 0, 62, 1, 1, 9, 8, 2, 156, 3, 0, 10, 5, 4, 80, 5, 0
db 5, 8, 9, 0, 57, 1, 1, 9, 8, 2, 153, 3, 0, 10, 5, 4, 78, 5, 0
db 6, 8, 8, 0, 27, 1, 1, 9, 7, 2, 142, 3, 0, 10, 5, 4, 71, 5, 0
db 7, 8, 8, 0, 25, 1, 1, 9, 7, 2, 142, 3, 0, 10, 5, 4, 70, 5, 0
db 8, 8, 7, 0, 155, 1, 0, 9, 7, 2, 85, 3, 1, 10, 7, 4, 139, 5, 0
db 9, 8, 9, 0, 248, 1, 0, 9, 7, 2, 22, 3, 1, 10, 7, 4, 119, 5, 0
db 10, 8, 8, 0, 233, 1, 0, 9, 7, 2, 120, 3, 0, 10, 5, 4, 59, 5, 0
db 11, 8, 8, 0, 25, 1, 1, 9, 7, 2, 140, 3, 0, 10, 7, 4, 120, 5, 0
db 12, 8, 9, 0, 215, 1, 0, 9, 7, 2, 140, 3, 0, 10, 7, 4, 107, 5, 0
db 13, 8, 9, 0, 208, 1, 0, 9, 8, 2, 107, 3, 0, 10, 5, 4, 136, 5, 0
db 14, 8, 8, 0, 231, 1, 0, 9, 7, 2, 107, 3, 0, 10, 4, 4, 108, 5, 0
db 15, 8, 9, 0, 251, 1, 0, 9, 6, 2, 114, 3, 0, 10, 5, 4, 192, 5, 0
db 16, 8, 10, 0, 234, 1, 0, 9, 7, 2, 116, 3, 0, 10, 5, 4, 59, 5, 0
db 17, 8, 7, 0, 118, 1, 0, 9, 7, 2, 15, 3, 1, 10, 5, 4, 104, 5, 0
db 18, 8, 8, 0, 214, 1, 0, 9, 8, 2, 106, 3, 0, 10, 3, 4, 53, 5, 0
db 19, 8, 8, 0, 214, 1, 0, 9, 8, 2, 104, 3, 0, 10, 5, 4, 127, 5, 0
db 20, 8, 9, 0, 241, 1, 0, 9, 7, 2, 104, 3, 0, 10, 5, 4, 118, 5, 0
db 21, 8, 9, 0, 160, 1, 0, 9, 7, 2, 79, 3, 0, 10, 6, 4, 233, 5, 0
db 22, 8, 9, 0, 162, 1, 0, 9, 7, 2, 79, 3, 0, 10, 5, 4, 248, 5, 0
db 23, 8, 8, 0, 212, 1, 0, 9, 7, 2, 78, 3, 0, 10, 6, 4, 106, 5, 0
db 24, 8, 8, 0, 144, 1, 0, 9, 7, 2, 213, 3, 0, 10, 5, 4, 71, 5, 0
db 25, 8, 9, 0, 142, 1, 0, 9, 7, 2, 71, 3, 0, 10, 5, 4, 35, 5, 0
db 26, 8, 8, 0, 158, 1, 0, 9, 7, 2, 134, 3, 0, 10, 7, 4, 70, 5, 0
db 27, 8, 7, 0, 141, 1, 0, 9, 6, 2, 81, 3, 0, 10, 5, 4, 146, 5, 0
db 28, 8, 10, 0, 154, 1, 0, 9, 6, 2, 80, 3, 0, 10, 4, 4, 147, 5, 0
db 29, 8, 8, 0, 142, 1, 0, 9, 7, 2, 79, 3, 0, 10, 5, 4, 173, 5, 0
db 30, 8, 9, 0, 141, 1, 0, 9, 5, 2, 35, 3, 0, 10, 3, 4, 70, 5, 0
db 31, 8, 8, 0, 138, 1, 0, 9, 6, 2, 161, 3, 0, 10, 6, 4, 71, 5, 0
db 32, 8, 9, 0, 157, 1, 0, 9, 6, 2, 79, 3, 0, 10, 5, 4, 71, 5, 0
db 33, 8, 8, 0, 119, 1, 0, 9, 7, 2, 59, 3, 0, 10, 6, 4, 78, 5, 0
db 34, 8, 8, 0, 120, 1, 0, 9, 8, 2, 59, 3, 0, 10, 3, 4, 168, 5, 0
db 35, 8, 8, 0, 141, 1, 0, 9, 7, 2, 59, 3, 0, 10, 6, 4, 112, 5, 0
db 36, 8, 8, 0, 107, 1, 0, 9, 7, 2, 138, 3, 0, 10, 6, 4, 53, 5, 0
db 37, 8, 8, 0, 107, 1, 0, 9, 7, 2, 53, 3, 0, 10, 3, 4, 151, 5, 0
db 38, 8, 7, 0, 120, 1, 0, 9, 6, 2, 59, 3, 0, 10, 6, 4, 53, 5, 0
db 39, 8, 7, 0, 120, 1, 0, 9, 6, 2, 59, 3, 0, 10, 3, 4, 106, 5, 0
db 40, 8, 7, 0, 107, 1, 0, 9, 5, 2, 53, 3, 0, 10, 5, 4, 157, 5, 0
db 41, 8, 7, 0, 106, 1, 0, 9, 5, 2, 53, 3, 0, 10, 3, 4, 81, 5, 0
db 42, 8, 5, 0, 139, 1, 0, 9, 5, 2, 107, 3, 0, 10, 5, 4, 53, 5, 0
db 43, 8, 4, 0, 138, 1, 0, 9, 3, 2, 54, 3, 0, 10, 3, 4, 71, 5, 0
db 44, 8, 5, 0, 157, 1, 0, 9, 3, 2, 79, 3, 0, 10, 2, 4, 71, 5, 0
db 45, 8, 4, 0, 120, 1, 0, 9, 3, 2, 59, 3, 0, 10, 2, 4, 79, 5, 0
db 46, 8, 4, 0, 59, 1, 0, 9, 3, 2, 119, 3, 0, 10, 0, 4, 0, 5, 0
db 47, 8, 3, 0, 143, 1, 0, 9, 3, 2, 59, 3, 0, 10, 3, 4, 112, 5, 0
db 48, 8, 3, 0, 111, 1, 0, 9, 2, 2, 53, 3, 0, 10, 2, 4, 143, 5, 0
db 49, 8, 5, 0, 106, 1, 0, 9, 2, 2, 53, 3, 0, 10, 0, 4, 0, 5, 0
db 50, 8, 3, 0, 121, 1, 0, 9, 3, 2, 59, 3, 0, 10, 2, 4, 102, 5, 0
db 51, 8, 3, 0, 118, 1, 0, 9, 3, 2, 59, 3, 0, 10, 1, 4, 104, 5, 0
db 52, 8, 3, 0, 104, 1, 0, 9, 2, 2, 161, 3, 0, 10, 1, 4, 53, 5, 0
db 53, 8, 3, 0, 106, 1, 0, 9, 2, 2, 53, 3, 0, 10, 0, 4, 0, 5, 0
db 54, 8, 2, 0, 107, 1, 0, 9, 2, 2, 53, 3, 0, 10, 1, 4, 139, 5, 0
db 55, 8, 1, 0, 138, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 56, 8, 1, 0, 157, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 57, 8, 1, 0, 119, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 58, 8, 1, 0, 120, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 59, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 60, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 61, 8, 1, 0, 107, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 62, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 63, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 64, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 65, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 66, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 67, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 68, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 69, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 70, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 71, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 72, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 73, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 74, 8, 0, 0, 0, 1, 0, 9, 0, 2, 0, 3, 0, 10, 0, 4, 0, 5, 0
db 255

end',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 108: sinus-scroll 2 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sinus-scroll 2',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2022-01-13T13:49:02.017000'::timestamptz,
    '2022-01-15T18:38:47.731000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; 15581 nops

; ==============================================================================
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

macro SET_BORDER ink 
                SET_COLOR #10, {ink}
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
R6	equ 8
R7  equ 14

macro CALC_TILE_ADR
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
	WRITE_CRTC 7, R7
    
	SET_MODE 0

	SET_PALETTE palette, 0, 16

        
.loop
	WAIT_VBL (void)
    SET_BORDER Color.fm_6
.col_count	ld a, 3 	; Colonne du caractère actuel
	or a	; si != 0 on est toujours sur le même caractère
		; pas de nouveau caractère à placer dans le buffer	
	jr nz, .same_chr

		; On doit placer un nouveau caractère dans le buffer
.text_ptr:	ld hl, text - 1 
	inc hl	; On avance le pointeur sur le texte
	ld a, (hl)	; On lit le prochaine caractère
	or a	; Si 0 fin de la chaine, on doit boucler
	jr nz, .save_text_ptr ; Sinon on écrit simplement le caractère dans le buffer
	ld hl, text	; On boucle
	ld a, (hl)	; Et on lit la valeur du premier caractère
.save_text_ptr
	ld (.text_ptr + 1), hl ; on sauvegarde le pointeur pour le prochaine tour
	CALC_TILE_ADR	; Calcul de l''adresse du tile correspondant au caracère

		; Ecriture du caractère après la fin de la partie visible du buffer
.insert_pos	ld de, buffer + R1 * 2
	call cp_chr

.same_chr
	call render	; On affiche la partie visible du buffer à l''écran
	
	ld a, (.col_count + 1) ; Incrémente le numéro de colonne du caractère
	inc a
	and 3	       ; on reste dans la fourchette [0, 4[
	ld (.col_count + 1), a ; sauvegarde le numéro de colonne
	
	ld a, (.insert_pos + 1) ; Incrémente le LSB de la colonne d''insertion dans le buffer
	inc a                   ; aligné sur 256, ainsi on boucle gratuitement		
	ld (.insert_pos + 1), a
    
    SET_BORDER Color.fm_3
	jr .loop





cp_chr:
	ld c, 4	; 4 colonnes
.loop_x
	ld b, 16	; 16 lignes
	ld ixh, d	; Sauvegarde le MSB de l''adresse du buffer
.loop_y	ld a, (hl)	; a = byte du caractère
	ld (de), a	; copie dans le buffer
	inc d	; ligne suivante dans le buffer
	inc l	; prochain byte du caractère
	djnz .loop_y	; pour toutes les lignes
	
	ld d, ixh	; restaure le MSB de l''adresse du buffer(1ère ligne)
	inc e	; colonne suivante du buffer
	dec c	; 
	jr nz, .loop_x ; pour toutes les colonnes du caractère
	
	ret


render:

	di
	ld (.save_stack + 1), sp
	
	exx
.ptr_sin	ld bc, sin_tab ; bc'' <= pointeur sur la table sinus	
	ld hl, adr     ; hl'' <= pointeur sur la table d''adresses écran	
	exx
	
.src:	ld de, buffer	; de <= pointeur sur la partie visible du buffer

    ld b, d	; sauvegarde le MSB du buffer dans b
repeat 96, i	; Pour chaque colonne de l''écran
	
	exx
	ld a, (bc)	; a valeur du sinus pour la colonne courante
	inc c	; avance et boucle dans la table sinus
	ld e, a	; de <= valeur du sinus(multiple de 2)
	ld d, 0
	add hl, de	; hl'' = adresse écran colonne + valeur du sinus
	ld sp, hl	; sp = adresse écran
	exx
	
	xor a
repeat 2
	pop hl	; dépile l''adresse écran
	ld (hl), a	; nettoyage
rend
repeat 16
	pop hl	; dépile l''adresse écran
	ld a, (de)	; valeur dans le buffer
	ld (hl), a	; copie à l''adresse écran
	inc d	; ligne suivante dans le buffer
rend
	xor a
repeat 2
	pop hl	; dépile l''adresse écran
	ld (hl), a	; nettoyage
rend
	ld d, b	; restaure le MSB du buffer
	inc e	; colonne suivante dans le buffer

	exx
	xor a	; colonne suivante du pointeur sur les adresses écran
	ld l, a	
	if (i - 1) % 2 == 0 
	; colonne paire, on place le LSB à #80
	set 7, l
	else 
	; colonne impaire, on incrémente les MSB
	inc h
	endif
	exx
rend
	ld hl, .src + 1
	inc (hl)	; incrémente ls LSB du pointeur sur le buffer
		; (colonne suivante)

	ld hl, .ptr_sin + 1 ; on se déplace dans la table sinus
	dec (hl)
	

.save_stack	ld sp, 0
	ei
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
/*
 Table de la courbe

 Alignée sur 256 car ainsi, pour itérer et boucler sur cette table,
 il suffit d''incrémenter le LSB du pointeur sur la table.
*/
align 256
sin_tab
repeat 256, ii
i = ii - 1
off = floor(7 * sin(i / 256 * 360 * 3))
off1 = floor(16 * cos(i / 256 * 360 * 2))
/*  
 On mutliplie directement par 2 à la génération, ainsi il suffit d''une addition
 avec le pointeur sur le début début de l''adresse de la colonne pour avoir 
 le pointeur sur l''adresse écran correspondant à la valeur lue.
 
 Attention, la valeur de la courbe doit être strictement inférérieur au nombre de lignes de 
 la table d''adresse - la hauteur de la fonte(64 - 16 ici)
*/
v = 24 + off + off1

assert v < 64 - 16 && v > 0

db 2 * v

rend
/*
 Fonte de caracère

 Alignée sur une page de 16ko pour faciliter le calcul de l''adresse d''un tile
 Overkill ici, car on ne lit l''adresse qu''une fois tous les 4 frames...
*/
org #4000
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



/* 
 Buffer

 Chaque ligne du buffer est alignée sur 256 bytes, pour boucler gratuitement
*/
align 256
buffer:	ds 256 * 16

	


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
  dw #c000 + floor(y / 8) * R1 * 2 + (y & 7) * #800 + x
 rend ; next yy
rend ; next xx

module off',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
