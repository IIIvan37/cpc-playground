-- Migration: Import z80code projects batch 104
-- Projects 207 to 208
-- Generated: 2026-01-25T21:43:30.212270

-- Project 207: program415 by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program415',
    'Imported from z80Code. Author: tronic. animation',
    'public',
    false,
    false,
    '2025-11-24T13:06:35.998000'::timestamptz,
    '2025-11-24T13:06:36.006000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; DeltaMaker
; More info (and some other stuff ^^) on my little webpage there : https://amstrad.neocities.org/
; Tronic/GPA.

BUILDSNA
BANKSET 0
INK00 	EQU  #54
INK01 	EQU  #44
INK02 	EQU  #55
INK03 	EQU  #5C
INK04 	EQU  #58
INK05 	EQU  #5D
INK06 	EQU  #4C
INK07 	EQU  #45
INK08 	EQU  #4D
INK09 	EQU  #56
INK10 	EQU  #46
INK11 	EQU  #57
INK12 	EQU  #5E
INK13 	EQU  #41
INK14 	EQU  #5F
INK15 	EQU  #4E
INK16 	EQU  #47
INK17 	EQU  #4F
INK18 	EQU  #52
INK19 	EQU  #51
INK20 	EQU  #53
INK21 	EQU  #5A
INK22 	EQU  #59
INK23 	EQU  #5B
INK24 	EQU  #4A
INK25 	EQU  #43
INK26 	EQU  #4B

	nolist
	org #38
	ei:ret
	run $
	ld a,1
	call #bc0e
	ld bc,#bc01
	out (c),c
	ld bc,#bd31
	out (c),c
	ld bc,#bc02
	out (c),c
	ld bc,#bd32
	out (c),c
	ld bc,#bc03
	out (c),c
	ld bc,#bd06
	out (c),c

	ld a,#0f
	ld (#eb7e),a
	ld (#fb7e),a
	ld (#cbe0),a
	ld (#eb7e+19),a
	ld (#fb7e+19),a
	ld (#cbe0+19),a
	ld (#eb7e+19+19),a
	ld (#fb7e+19+19),a
	ld (#cbe0+19+19),a
	ld (#eb7e+19+19+19),a
	ld (#fb7e+19+19+19),a
	ld (#cbe0+19+19+19),a
	ld (#eb7e+19+19+19+19),a
	ld (#fb7e+19+19+19+19),a
	ld (#cbe0+19+19+19+19),a

main	ld b,#f5
vbl	in a,(c)
	rra
	jr nc,vbl

	ld bc,#7f10
	ld a,ink00
	out (c),c
	out (c),a
	ld bc,#7f00
	ld a,ink00
	out (c),c
	out (c),a
	ld bc,#7f01
	ld a,ink26
	out (c),c
	out (c),a
	ld bc,#7f02
	ld a,ink20
	out (c),c
	out (c),a
	ld bc,#7f03
	ld a,ink11
	out (c),c
	out (c),a

xorme	ld a,0
	xor #ff
	ld (xorme+1),a
	or a
	jr z,v2
v1
	di
	ld bc,#7f10
	ld a,#4c
	out (c),c
	out (c),a
	ld bc,#7f00
	ld a,#4c
	out (c),c
	out (c),a


	ld (stack+1),sp
	ld de,19+19
idx	ld sp,delta_index
again1	pop hl
	ld a,h
	or l
	jr nz,cont1
	ld sp,delta_index
	jr again1
cont1	ld (idx+1),sp
	ld sp,hl
again2	pop bc	; b=nbr c=value
	ld a,b
	or c
	jr z,exit
bcl	pop hl	; hl=adrecr
	ld (hl),c
	add hl,de
	ld (hl),c
	add hl,de
	ld (hl),c
	djnz bcl
	jr again2
exit
stack	ld sp,0
	ld bc,#7f10
	ld a,#54
	out (c),c
	out (c),a
	ld bc,#7f00
	ld a,#54
	out (c),c
	out (c),a
	jr escape

v2
	di
	ld bc,#7f10
	ld a,#4c
	out (c),c
	out (c),a
	ld bc,#7f00
	ld a,#4c
	out (c),c
	out (c),a
	ld (stackv2+1),sp
	ld de,19
idxv2	ld sp,delta_index+34
again1v2
	pop hl
	ld a,h
	or l
	jr nz,cont1v2
	ld sp,delta_index
	jr again1v2
cont1v2	ld (idxv2+1),sp
	ld sp,hl
again2v2
	pop bc	; b=nbr c=value
	ld a,b
	or c
	jr z,exitv2
bclv2	pop hl	; hl=adrecr
	add hl,de
	ld (hl),c
	add hl,de
	add hl,de
	ld (hl),c
	djnz bclv2
	jr again2v2
exitv2
stackv2	ld sp,0
	ld bc,#7f10
	ld a,#54
	out (c),c
	out (c),a
	ld bc,#7f00
	ld a,#54
	out (c),c
	out (c),a


escape
	ei
	halt
	halt
	halt
	di
	jp main
delta_start
;include "gif_deltas.asm"
; Deltas générés par DeltaMaker
; GIF source = 640x400, frames = 69
; Viewport GIF = origine (0,0), taille 640x400
; Frames utilisées = 69
; Mode 1, dithering b2
; Zone utile CPC = 320 x 200
; Base vidéo = #C000, CRTC R1 = 31h, bytes/ligne = 98
; Offset CPC = (-120 px, 0 lignes)
; Réglages couleur = Lum=0, Contraste=0, Gamma=1.0, Saturation=0
; Type de delta sélectionné = 3
;  Type 1 = DW #ADRESSE + DB #VALEUR
;  Type 2 = DB #VALEUR + DW pokeN, puis N * DW #ADRESSE
;  Type 3 = DB #VALEUR + DB N, puis N * DW #ADRESSE
;  (regroupement par valeur d''octet pour les types 2 et 3)
; Chaque bloc de frame se termine par DW #0000

Delta_index:
 DW Delta_00_01
 DW Delta_01_02
 DW Delta_02_03
 DW Delta_03_04
 DW Delta_04_05
 DW Delta_05_06
 DW Delta_06_07
 DW Delta_07_08
 DW Delta_08_09
 DW Delta_09_10
 DW Delta_10_11
 DW Delta_11_12
 DW Delta_12_13
 DW Delta_13_14
 DW Delta_14_15
 DW Delta_15_16
 DW Delta_16_17
 DW Delta_17_18
 DW Delta_18_19
 DW Delta_19_20
 DW Delta_20_21
 DW Delta_21_22
 DW Delta_22_23
 DW Delta_23_24
 DW Delta_24_25
 DW Delta_25_26
 DW Delta_26_27
 DW Delta_27_28
 DW Delta_28_29
 DW Delta_29_30
 DW Delta_30_31
 DW Delta_31_32
 DW Delta_32_33
 DW Delta_33_34
 DW Delta_34_35
 DW Delta_35_36
 DW Delta_36_37
 DW Delta_37_38
 DW Delta_38_39
 DW Delta_39_40
 DW Delta_40_41
 DW Delta_41_42
 DW Delta_42_43
 DW Delta_43_44
 DW Delta_44_45
 DW Delta_45_46
 DW Delta_46_47
 DW Delta_47_48
 DW Delta_48_49
 DW Delta_49_50
 DW Delta_50_51
 DW Delta_51_52
 DW Delta_52_53
 DW Delta_53_54
 DW Delta_54_55
 DW Delta_55_56
 DW Delta_56_57
 DW Delta_57_58
 DW Delta_58_59
 DW Delta_59_60
 DW Delta_60_61
 DW Delta_61_62
 DW Delta_62_63
 DW Delta_63_64
 DW Delta_64_65
 DW Delta_65_66
 DW Delta_66_67
 DW Delta_67_68
 DW Delta_68_00
 DW #0000

; Delta frame 0 -> frame 1
Delta_00_01:
 db #00 : db 8
 dw #C4FA
 dw #CE24
 dw #D507
 dw #D5C0
 dw #E4AB
 dw #EE26
 dw #F5C1
 dw #FE2B
 db #01 : db 4
 dw #C624
 dw #D55D
 dw #EC43
 dw #EDC1
 db #03 : db 3
 dw #C55D
 dw #F4A6
 dw #FD5E
 db #07 : db 3
 dw #C442
 dw #C4A6
 dw #DDC1
 db #0F : db 34
 dw #C567
 dw #C56B
 dw #CC43
 dw #CD6B
 dw #CD6C
 dw #CDC2
 dw #CDC5
 dw #D3DB
 dw #D3DC
 dw #D3DD
 dw #D3DE
 dw #D49A
 dw #D5C6
 dw #DBDB
 dw #DBDD
 dw #DBDE
 dw #DC9A
 dw #DDC3
 dw #DDC4
 dw #E3DF
 dw #E499
 dw #E565
 dw #E5C5
 dw #EBD9
 dw #EBDF
 dw #EC44
 dw #ED64
 dw #EE2B
 dw #F3E0
 dw #F437
 dw #F444
 dw #F509
 dw #FBE0
 dw #FD0A
 db #11 : db 3
 dw #CDC0
 dw #DD5D
 dw #F3DE
 db #1E : db 1
 dw #F5CA
 db #1F : db 10
 dw #CBE2
 dw #CC45
 dw #CCA8
 dw #DBDC
 dw #DCFC
 dw #EC9A
 dw #ECFC
 dw #ED5F
 dw #FBE3
 dw #FC46
 db #23 : db 6
 dw #CB75
 dw #CC42
 dw #CD5D
 dw #E443
 dw #E5C1
 dw #F506
 db #2D : db 1
 dw #DD6B
 db #2F : db 9
 dw #C445
 dw #C4A8
 dw #C4FC
 dw #D445
 dw #D4A8
 dw #D4FC
 dw #E3DA
 dw #E3E2
 dw #F37F
 db #33 : db 3
 dw #FBDF
 dw #FD05
 dw #FE29
 db #3C : db 1
 dw #DDCB
 db #47 : db 4
 dw #CCA6
 dw #D4A6
 dw #DC43
 dw #FDC2
 db #4B : db 3
 dw #D56B
 dw #E56B
 dw #F5CB
 db #4F : db 1
 dw #FD63
 db #5A : db 1
 dw #E3D8
 db #5F : db 11
 dw #CD0B
 dw #DC46
 dw #DD0B
 dw #EBE3
 dw #EC46
 dw #ED0B
 dw #ED60
 dw #ED63
 dw #FC39
 dw #FCA9
 dw #FD62
 db #67 : db 3
 dw #D625
 dw #E507
 dw #E626
 db #78 : db 2
 dw #E5CB
 dw #EC38
 db #7F : db 13
 dw #CBE3
 dw #CC46
 dw #CCA9
 dw #CD6D
 dw #DB81
 dw #DC9B
 dw #DCA9
 dw #EBDB
 dw #EBDC
 dw #ECA9
 dw #FB1E
 dw #FBDA
 dw #FCFD
 db #87 : db 2
 dw #CC9A
 dw #FBD8
 db #88 : db 4
 dw #D4AB
 dw #DD01
 dw #FC49
 dw #FC9E
 db #8C : db 1
 dw #E501
 db #8F : db 9
 dw #CE25
 dw #D443
 dw #D4FB
 dw #D508
 dw #D5C1
 dw #ED5E
 dw #F5C2
 dw #FC44
 dw #FD06
 db #AE : db 2
 dw #C49D
 dw #D49D
 db #AF : db 18
 dw #C49B
 dw #C50B
 dw #C564
 dw #C565
 dw #C566
 dw #D50B
 dw #D55F
 dw #E3DD
 dw #E446
 dw #E4A9
 dw #E500
 dw #E50B
 dw #F3DF
 dw #F3E3
 dw #F49D
 dw #F4A9
 dw #F501
 dw #F50B
 db #BF : db 5
 dw #C43C
 dw #D500
 dw #E49D
 dw #F3DB
 dw #F62B
 db #C3 : db 4
 dw #E5CC
 dw #EBD8
 dw #F3D8
 dw #F56B
 db #CC : db 4
 dw #C500
 dw #D31D
 dw #F502
 dw #FD03
 db #CF : db 2
 dw #EBDE
 dw #EE27
 db #DF : db 1
 dw #FD02
 db #E1 : db 2
 dw #DDCC
 dw #EDCB
 db #EE : db 4
 dw #CC9D
 dw #CD00
 dw #FBE6
 dw #FE2A
 db #EF : db 1
 dw #F628
 db #F0 : db 3
 dw #C439
 dw #D5CC
 dw #FBD7
 db #FF : db 9
 dw #DD00
 dw #DD60
 dw #EB81
 dw #EBDD
 dw #EBE4
 dw #EC47
 dw #EC9D
 dw #ED01
 dw #FC47
; Taille bloc delta = 466 octets
 DW #0000

; Delta frame 1 -> frame 2
Delta_01_02:
 db #00 : db 10
 dw #C31C
 dw #CB16
 dw #D4AB
 dw #DE25
 dw #E55D
 dw #F627
 dw #FC49
 dw #FC98
 dw #FE29
 dw #FE2A
 db #01 : db 5
 dw #C5C0
 dw #CB75
 dw #D625
 dw #DC42
 dw #FC43
 db #03 : db 4
 dw #F3D5
 dw #FCA6
 dw #FCFB
 dw #FDC2
 db #07 : db 6
 dw #CD08
 dw #CE25
 dw #D4A6
 dw #E4FB
 dw #ED5E
 dw #F5C2
 db #0F : db 33
 dw #C376
 dw #C43A
 dw #C442
 dw #C49A
 dw #C4A6
 dw #C566
 dw #C5C6
 dw #C5CD
 dw #CC42
 dw #CC9A
 dw #CDC4
 dw #CDCD
 dw #D443
 dw #D56B
 dw #DBDC
 dw #DC43
 dw #DD64
 dw #DD6B
 dw #E3DA
 dw #E3DD
 dw #E3DE
 dw #E56B
 dw #E5C3
 dw #E5C4
 dw #EBDE
 dw #ED6B
 dw #F3DF
 dw #F56B
 dw #FBDF
 dw #FC44
 dw #FD06
 dw #FD63
 dw #FDCC
 db #11 : db 6
 dw #C4A5
 dw #C624
 dw #CC41
 dw #DD07
 dw #E626
 dw #EDC1
 db #1E : db 3
 dw #D3D8
 dw #E3D7
 dw #E5CA
 db #1F : db 12
 dw #CDC3
 dw #DBE2
 dw #DC45
 dw #DC9A
 dw #DCA8
 dw #DD6C
 dw #DE2D
 dw #EBDA
 dw #ECA8
 dw #FBD9
 dw #FCA8
 dw #FD60
 db #23 : db 2
 dw #C55D
 dw #F443
 db #2D : db 1
 dw #DBD8
 db #2F : db 11
 dw #C3E1
 dw #E3DB
 dw #E439
 dw #E445
 dw #E49A
 dw #E4A8
 dw #E4FC
 dw #E56C
 dw #F3E2
 dw #F49A
 dw #F4A8
 db #33 : db 1
 dw #FBDE
 db #3C : db 2
 dw #EBD7
 dw #EDCA
 db #47 : db 9
 dw #C508
 dw #D375
 dw #D442
 dw #DCA6
 dw #DDC1
 dw #E4A6
 dw #EC43
 dw #F4FB
 dw #F55E
 db #4B : db 1
 dw #F438
 db #4F : db 4
 dw #CD64
 dw #EBDD
 dw #ED63
 dw #FD03
 db #5A : db 2
 dw #C62C
 dw #D3D9
 db #5F : db 10
 dw #DD63
 dw #EBDB
 dw #EBDC
 dw #ED62
 dw #FB1E
 dw #FB80
 dw #FBE3
 dw #FC46
 dw #FD02
 dw #FD61
 db #67 : db 2
 dw #C441
 dw #F506
 db #77 : db 2
 dw #EE27
 dw #F628
 db #78 : db 5
 dw #D438
 dw #DDCB
 dw #E3D8
 dw #F3D7
 dw #F5CA
 db #7F : db 11
 dw #CC9B
 dw #CD0B
 dw #DBE3
 dw #DC46
 dw #DD0B
 dw #DD60
 dw #EB81
 dw #ED0B
 dw #FCA9
 dw #FD04
 dw #FD0B
 db #87 : db 5
 dw #DBD9
 dw #EDCC
 dw #FC38
 dw #FD6B
 dw #FDCB
 db #88 : db 5
 dw #CD01
 dw #DC9E
 dw #E49E
 dw #E4AB
 dw #F62C
 db #8C : db 1
 dw #F49E
 db #8F : db 6
 dw #CCA6
 dw #D5C5
 dw #E443
 dw #E55E
 dw #E627
 dw #F564
 db #AE : db 1
 dw #D448
 db #AF : db 14
 dw #C445
 dw #C4A8
 dw #C5CE
 dw #D3E2
 dw #D445
 dw #D49D
 dw #D500
 dw #E37F
 dw #E49D
 dw #E501
 dw #F3DB
 dw #F3DE
 dw #F446
 dw #F502
 db #B4 : db 1
 dw #FDCA
 db #BF : db 2
 dw #C49D
 dw #C500
 db #CC : db 7
 dw #D382
 dw #D501
 dw #E31E
 dw #E502
 dw #EC9E
 dw #F503
 dw #FBDB
 db #CF : db 2
 dw #DE26
 dw #FD05
 db #D2 : db 1
 dw #F5CB
 db #DF : db 2
 dw #CD63
 dw #ED61
 db #E1 : db 2
 dw #EBD8
 dw #EC38
 db #EE : db 2
 dw #ED02
 dw #FC9E
 db #F0 : db 1
 dw #EDCB
 db #FF : db 10
 dw #CC9D
 dw #CCA9
 dw #CD00
 dw #DB81
 dw #DC9D
 dw #DCA9
 dw #DD01
 dw #F3DC
 dw #F3DD
 dw #FBE4
; Taille bloc delta = 486 octets
 DW #0000

; Delta frame 2 -> frame 3
Delta_02_03:
 db #00 : db 11
 dw #C624
 dw #CDC0
 dw #D625
 dw #DB1E
 dw #DD5D
 dw #E626
 dw #EC98
 dw #EDC1
 dw #F498
 dw #F62C
 dw #FAB8
 db #01 : db 3
 dw #CD5D
 dw #D4A5
 dw #FDC2
 db #03 : db 3
 dw #D375
 dw #DDC1
 dw #F55E
 db #07 : db 5
 dw #D5C1
 dw #DCFB
 dw #ECA6
 dw #F4A6
 dw #FC43
 db #0F : db 37
 dw #C441
 dw #C499
 dw #C5CC
 dw #CCA6
 dw #CDC3
 dw #CDCC
 dw #D442
 dw #D499
 dw #D4A6
 dw #D565
 dw #D5C5
 dw #DC39
 dw #DC42
 dw #DCA6
 dw #E3DB
 dw #E3DC
 dw #E443
 dw #EBDA
 dw #EBDB
 dw #EBDC
 dw #EBDD
 dw #EC38
 dw #EC43
 dw #ED5F
 dw #ED63
 dw #EDCC
 dw #F3D9
 dw #F3DE
 dw #F564
 dw #F56A
 dw #FBDE
 dw #FC38
 dw #FD03
 dw #FD04
 dw #FD05
 dw #FD6A
 dw #FD6B
 db #11 : db 6
 dw #C5C0
 dw #D55D
 dw #E5C1
 dw #ED06
 dw #EE27
 dw #F628
 db #1E : db 1
 dw #F5C9
 db #1F : db 11
 dw #CC9A
 dw #CD0A
 dw #CD6C
 dw #DB7F
 dw #DD0A
 dw #EBE2
 dw #EC45
 dw #ED0A
 dw #FBE2
 dw #FC45
 dw #FD0A
 db #22 : db 1
 dw #FAB7
 db #23 : db 6
 dw #CCA5
 dw #CE25
 dw #D441
 dw #DE26
 dw #EC42
 dw #FD5E
 db #2F : db 12
 dw #C444
 dw #C4A7
 dw #C50A
 dw #C56C
 dw #D3E1
 dw #D49A
 dw #D50A
 dw #D56C
 dw #D5C3
 dw #E50A
 dw #F445
 dw #F50A
 db #3C : db 3
 dw #DBD8
 dw #DDCB
 dw #FDC9
 db #47 : db 8
 dw #C4A5
 dw #CD08
 dw #E442
 dw #E627
 dw #ECFB
 dw #ED5E
 dw #F5C2
 dw #FCA6
 db #4B : db 4
 dw #D3DA
 dw #D5CC
 dw #E438
 dw #E5CC
 db #4F : db 1
 dw #FD62
 db #5A : db 1
 dw #C62B
 db #5F : db 10
 dw #CBE2
 dw #CC45
 dw #CCA8
 dw #DC45
 dw #DCA8
 dw #DD62
 dw #ECA8
 dw #ED61
 dw #FBDA
 dw #FD6C
 db #67 : db 1
 dw #C440
 db #6E : db 2
 dw #CB1C
 dw #ED03
 db #78 : db 1
 dw #DC38
 db #7F : db 7
 dw #CD60
 dw #CDCE
 dw #EBE3
 dw #EC46
 dw #EE2C
 dw #FB1E
 dw #FC46
 db #87 : db 3
 dw #CE2C
 dw #D439
 dw #DDCC
 db #88 : db 6
 dw #C49E
 dw #CC9E
 dw #D4AB
 dw #D502
 dw #F31F
 dw #FC9F
 db #8F : db 15
 dw #C376
 dw #C565
 dw #C5C5
 dw #C625
 dw #CC41
 dw #CDC1
 dw #D5C4
 dw #D626
 dw #E4A6
 dw #E564
 dw #EDC2
 dw #EE28
 dw #F3DD
 dw #F443
 dw #F506
 db #AE : db 1
 dw #E49E
 db #AF : db 14
 dw #C49D
 dw #C500
 dw #D4A8
 dw #D501
 dw #E3E2
 dw #E43B
 dw #E445
 dw #E4A8
 dw #F3DC
 dw #F3E2
 dw #F439
 dw #F43B
 dw #F4A8
 dw #F503
 db #BF : db 3
 dw #E502
 dw #F49E
 dw #F504
 db #C3 : db 2
 dw #CC39
 dw #E3D9
 db #CC : db 4
 dw #C501
 dw #D49E
 dw #DC9E
 dw #FBE6
 db #D2 : db 1
 dw #C62C
 db #DF : db 2
 dw #ED02
 dw #FD01
 db #E1 : db 1
 dw #DBD9
 db #EE : db 2
 dw #DD02
 dw #EC9E
 db #EF : db 1
 dw #FBDD
 db #F0 : db 3
 dw #E3D8
 dw #EBD8
 dw #FDCA
 db #FF : db 19
 dw #CC46
 dw #CCFD
 dw #CD01
 dw #CD0B
 dw #DC46
 dw #DD0B
 dw #DD6D
 dw #EC3B
 dw #ECA9
 dw #ED6D
 dw #F505
 dw #F629
 dw #F62B
 dw #FBDB
 dw #FBDC
 dw #FC3B
 dw #FC9B
 dw #FC9E
 dw #FCA9
; Taille bloc delta = 496 octets
 DW #0000

; Delta frame 3 -> frame 4
Delta_03_04:
 db #00 : db 11
 dw #C5C0
 dw #CC98
 dw #D4AB
 dw #D55D
 dw #DC98
 dw #DD07
 dw #E5C1
 dw #EE27
 dw #F628
 dw #FAB7
 dw #FDC2
 db #01 : db 4
 dw #C55D
 dw #ECA5
 dw #F55E
 dw #F5C2
 db #03 : db 5
 dw #DCA5
 dw #ECFB
 dw #ED5E
 dw #F4FB
 dw #FB74
 db #07 : db 5
 dw #D4A5
 dw #D4FB
 dw #D508
 dw #E55E
 dw #F442
 db #0F : db 39
 dw #C440
 dw #C4A5
 dw #C5C2
 dw #C5C5
 dw #CC41
 dw #CD64
 dw #D439
 dw #D441
 dw #D5C3
 dw #D5C4
 dw #D5CB
 dw #D5CC
 dw #DDCB
 dw #DDCC
 dw #E442
 dw #E4A6
 dw #E564
 dw #E5CA
 dw #E5CC
 dw #EC42
 dw #ECA6
 dw #ED07
 dw #F3DA
 dw #F3DB
 dw #F3DC
 dw #F3DD
 dw #F438
 dw #F443
 dw #F4A6
 dw #F505
 dw #F506
 dw #FBD9
 dw #FBDC
 dw #FBDD
 dw #FC43
 dw #FCA6
 dw #FD60
 dw #FD61
 dw #FD62
 db #11 : db 10
 dw #C43E
 dw #C4A4
 dw #CD5D
 dw #CE25
 dw #DDC1
 dw #DE26
 dw #EC41
 dw #F4A5
 dw #F629
 dw #FD5E
 db #1E : db 1
 dw #D62A
 db #1F : db 5
 dw #CC44
 dw #CCA7
 dw #DCA7
 dw #ED60
 dw #FDCC
 db #23 : db 6
 dw #D440
 dw #D5C1
 dw #E441
 dw #E4A5
 dw #FC42
 dw #FCFB
 db #2D : db 1
 dw #DC38
 db #2F : db 9
 dw #D444
 dw #D4A7
 dw #D55F
 dw #D5CD
 dw #E3E1
 dw #E444
 dw #E4A7
 dw #F4FC
 dw #F560
 db #33 : db 1
 dw #ED06
 db #3C : db 1
 dw #CE2A
 db #3F : db 1
 dw #ED04
 db #47 : db 4
 dw #CDC1
 dw #D626
 dw #E4FB
 dw #EDC2
 db #4B : db 1
 dw #E3DA
 db #4F : db 3
 dw #DD63
 dw #ED62
 dw #FD02
 db #5A : db 5
 dw #C62A
 dw #D3DA
 dw #D438
 dw #D62B
 dw #E5CB
 db #5F : db 19
 dw #CD0A
 dw #CD63
 dw #DBE2
 dw #DD0A
 dw #DD60
 dw #DD61
 dw #DD6C
 dw #EC45
 dw #ED02
 dw #ED03
 dw #ED0A
 dw #ED6C
 dw #EDCD
 dw #FB1E
 dw #FBDB
 dw #FC45
 dw #FCA8
 dw #FCFD
 dw #FD0A
 db #67 : db 2
 dw #C625
 dw #E627
 db #6E : db 1
 dw #EB1E
 db #77 : db 1
 dw #EE28
 db #78 : db 1
 dw #DBD8
 db #7F : db 7
 dw #CCA8
 dw #DB1D
 dw #DC3A
 dw #DCA8
 dw #FBE3
 dw #FC39
 dw #FD6C
 db #87 : db 2
 dw #CC39
 dw #EBD9
 db #88 : db 8
 dw #C502
 dw #DC3C
 dw #E43C
 dw #E49F
 dw #EBE6
 dw #EC3C
 dw #ED05
 dw #F383
 db #8C : db 2
 dw #C49E
 dw #F49F
 db #8F : db 14
 dw #C4FB
 dw #C508
 dw #C5C1
 dw #C5C4
 dw #CC40
 dw #CCA5
 dw #CCFB
 dw #CD08
 dw #DC41
 dw #DD5E
 dw #E5C2
 dw #F504
 dw #F563
 dw #FDC3
 db #AE : db 1
 dw #D49E
 db #AF : db 13
 dw #C444
 dw #C4A7
 dw #C501
 dw #C50A
 dw #D50A
 dw #E49E
 dw #E502
 dw #E50A
 dw #E56C
 dw #F37F
 dw #F445
 dw #F49E
 dw #F56C
 db #BF : db 3
 dw #D3E5
 dw #D502
 dw #E503
 db #C3 : db 2
 dw #C439
 dw #F5CB
 db #CC : db 8
 dw #C43D
 dw #CD02
 dw #DD03
 dw #EC9F
 dw #F3E6
 dw #F43C
 dw #FB1F
 dw #FC3C
 db #DF : db 1
 dw #CD62
 db #E1 : db 2
 dw #DBDA
 dw #EDCB
 db #EE : db 2
 dw #CBE5
 dw #CC9E
 db #EF : db 1
 dw #C43F
 db #F0 : db 6
 dw #C62B
 dw #C62C
 dw #CE2B
 dw #DBD9
 dw #E3D9
 dw #FDC9
 db #FF : db 13
 dw #C31B
 dw #CD6D
 dw #DC9B
 dw #DC9E
 dw #DCFD
 dw #DD02
 dw #EC3A
 dw #EC9B
 dw #EC9E
 dw #ED0B
 dw #F62A
 dw #FC9F
 dw #FD0B
; Taille bloc delta = 522 octets
 DW #0000

; Delta frame 4 -> frame 5
Delta_04_05:
 db #00 : db 15
 dw #C498
 dw #CB82
 dw #CD5D
 dw #CE25
 dw #D31D
 dw #D498
 dw #DBE6
 dw #DDC1
 dw #DE26
 dw #E498
 dw #EB83
 dw #F31F
 dw #F5C2
 dw #F629
 dw #FD5E
 db #01 : db 8
 dw #C507
 dw #C625
 dw #CD07
 dw #D5C1
 dw #D626
 dw #E440
 dw #ED5E
 dw #F4FB
 db #03 : db 3
 dw #CDC1
 dw #E4FB
 dw #FBD5
 db #07 : db 4
 dw #C4FB
 dw #CCFB
 dw #D55E
 dw #ECA5
 db #0F : db 43
 dw #C43F
 dw #C508
 dw #C565
 dw #C5C3
 dw #C5C4
 dw #CC38
 dw #CC39
 dw #CC40
 dw #CCA5
 dw #CD08
 dw #D438
 dw #D440
 dw #D4A5
 dw #D508
 dw #D62D
 dw #DB7F
 dw #DC38
 dw #DC41
 dw #DCA5
 dw #DD5F
 dw #DD63
 dw #E438
 dw #E441
 dw #E55F
 dw #E5CB
 dw #ECFC
 dw #ED03
 dw #ED04
 dw #ED60
 dw #ED61
 dw #ED62
 dw #EDCA
 dw #EDCB
 dw #F442
 dw #F4FC
 dw #F504
 dw #F563
 dw #F5CB
 dw #FBD8
 dw #FBDA
 dw #FBDB
 dw #FC42
 dw #FDCB
 db #11 : db 8
 dw #C55D
 dw #D507
 dw #DCA4
 dw #E627
 dw #EB74
 dw #F55E
 dw #FC41
 dw #FCFB
 db #1E : db 1
 dw #D629
 db #1F : db 8
 dw #CD09
 dw #CD5F
 dw #CDCD
 dw #DC39
 dw #DC44
 dw #ECA7
 dw #ED05
 dw #FCA7
 db #23 : db 9
 dw #D43F
 dw #D4A4
 dw #E507
 dw #E55E
 dw #ECFB
 dw #EDC2
 dw #F3D5
 dw #F441
 dw #FCA5
 db #2D : db 1
 dw #FDC8
 db #2F : db 10
 dw #C31A
 dw #C37E
 dw #C49A
 dw #C4A6
 dw #C509
 dw #C5CD
 dw #D509
 dw #F3E1
 dw #F444
 dw #F4A7
 db #33 : db 2
 dw #CC3E
 dw #EE28
 db #3C : db 2
 dw #CE29
 dw #DBD8
 db #47 : db 10
 dw #C437
 dw #C5C1
 dw #CCA4
 dw #DCFB
 dw #DD5E
 dw #DE27
 dw #E5C2
 dw #F4A5
 dw #FB74
 dw #FDC3
 db #4B : db 1
 dw #C439
 db #4F : db 2
 dw #CD63
 dw #DD62
 db #5A : db 4
 dw #C629
 dw #D62A
 dw #E3DB
 dw #F5CA
 db #5F : db 8
 dw #CCA7
 dw #CD60
 dw #CD62
 dw #DCA7
 dw #DD03
 dw #EC39
 dw #ECFD
 dw #FD01
 db #6E : db 1
 dw #DB1D
 db #77 : db 1
 dw #F62A
 db #7F : db 10
 dw #CC45
 dw #CD0A
 dw #CD6C
 dw #DC45
 dw #DD6C
 dw #EC45
 dw #ED0A
 dw #ED6C
 dw #FCA8
 dw #FD0A
 db #87 : db 1
 dw #DBDB
 db #88 : db 7
 dw #CC9F
 dw #CD03
 dw #D382
 dw #D49F
 dw #DD04
 dw #E31E
 dw #F4A0
 db #8C : db 3
 dw #C3E5
 dw #C448
 dw #E43C
 db #8F : db 18
 dw #C43E
 dw #C4A4
 dw #CC3F
 dw #CD5E
 dw #CE26
 dw #D564
 dw #DDC2
 dw #E4A5
 dw #E563
 dw #E628
 dw #EC37
 dw #EC41
 dw #EE29
 dw #F437
 dw #F499
 dw #F5C3
 dw #FC99
 dw #FD5F
 db #AE : db 6
 dw #C381
 dw #C62F
 dw #D503
 dw #E382
 dw #E49F
 dw #F43C
 db #AF : db 15
 dw #C318
 dw #C3E1
 dw #C43C
 dw #C49E
 dw #C56C
 dw #D444
 dw #D49E
 dw #D4A7
 dw #D502
 dw #D56C
 dw #E444
 dw #E4A7
 dw #E503
 dw #F49F
 dw #F50A
 db #BF : db 4
 dw #C502
 dw #D31C
 dw #E504
 dw #F31E
 db #CC : db 7
 dw #C31B
 dw #CB1C
 dw #D43C
 dw #DB82
 dw #DC3C
 dw #DC9F
 dw #FCA0
 db #CF : db 1
 dw #DC40
 db #D2 : db 2
 dw #C62C
 dw #E3DA
 db #DD : db 1
 dw #F62B
 db #DF : db 3
 dw #CD61
 dw #DD02
 dw #ED01
 db #E1 : db 3
 dw #EBD9
 dw #FBD7
 dw #FDCA
 db #EE : db 2
 dw #EC3C
 dw #FC3C
 db #EF : db 2
 dw #C43D
 dw #ED06
 db #F0 : db 3
 dw #C62A
 dw #CE2A
 dw #DBDA
 db #FF : db 9
 dw #CC9E
 dw #CCA8
 dw #CD02
 dw #DCA8
 dw #DDCE
 dw #EC46
 dw #EC9F
 dw #ECA8
 dw #FC46
; Taille bloc delta = 554 octets
 DW #0000

; Delta frame 5 -> frame 6
Delta_05_06:
 db #00 : db 15
 dw #C55D
 dw #C625
 dw #D382
 dw #D5C1
 dw #D626
 dw #E31E
 dw #E3E6
 dw #E4AB
 dw #E627
 dw #ED5E
 dw #EDC2
 dw #EE28
 dw #F383
 dw #F55E
 dw #FCFB
 db #01 : db 6
 dw #E55E
 dw #E5C2
 dw #EB74
 dw #ECFB
 dw #F440
 dw #F4A4
 db #03 : db 2
 dw #DCFB
 dw #DD07
 db #07 : db 6
 dw #CD07
 dw #CD5E
 dw #DC37
 dw #F499
 dw #F55F
 dw #FC99
 db #0F : db 38
 dw #C438
 dw #C439
 dw #C43E
 dw #C4A4
 dw #C62C
 dw #CC3E
 dw #CC3F
 dw #CCA4
 dw #CD5F
 dw #CD63
 dw #CE2C
 dw #D43F
 dw #D4A4
 dw #D55F
 dw #D564
 dw #DC40
 dw #DD60
 dw #DD61
 dw #DD62
 dw #E440
 dw #E4A5
 dw #E4FC
 dw #E563
 dw #E62C
 dw #EC41
 dw #ECA5
 dw #ED05
 dw #ED06
 dw #F441
 dw #F4A5
 dw #F560
 dw #F561
 dw #F562
 dw #F5C9
 dw #F5CA
 dw #FCA5
 dw #FD02
 dw #FDCA
 db #11 : db 5
 dw #CDC1
 dw #D4A3
 dw #E43F
 dw #F4FB
 dw #F62A
 db #1E : db 2
 dw #C628
 dw #F3DB
 db #1F : db 13
 dw #CB1B
 dw #CCA6
 dw #CD6B
 dw #DB1C
 dw #DD09
 dw #DD6B
 dw #EC44
 dw #ED09
 dw #ED6B
 dw #FC44
 dw #FCFD
 dw #FD09
 dw #FD6B
 db #23 : db 9
 dw #C5C1
 dw #CCA3
 dw #CE26
 dw #D43E
 dw #DD5E
 dw #DE27
 dw #E4FB
 dw #ECA4
 dw #FDC3
 db #2F : db 13
 dw #C443
 dw #C55F
 dw #C56B
 dw #D443
 dw #D4A6
 dw #D56B
 dw #D62D
 dw #E4A6
 dw #E509
 dw #E560
 dw #E56B
 dw #F509
 dw #F56B
 db #3F : db 1
 dw #C31A
 db #44 : db 2
 dw #C31B
 dw #E506
 db #47 : db 13
 dw #C4A3
 dw #CC37
 dw #CCFB
 dw #D375
 dw #D4FB
 dw #D507
 dw #D55E
 dw #DC3F
 dw #DDC2
 dw #E4A4
 dw #EC40
 dw #F5C3
 dw #FD5F
 db #4B : db 4
 dw #D3DA
 dw #D62B
 dw #F3D8
 dw #F3DC
 db #4C : db 2
 dw #DB1D
 dw #EB1E
 db #4F : db 1
 dw #ED02
 db #55 : db 1
 dw #F62B
 db #5A : db 1
 dw #D629
 db #5F : db 11
 dw #CD61
 dw #DD02
 dw #DD04
 dw #DDCD
 dw #EBE2
 dw #ECA7
 dw #ED01
 dw #FBE2
 dw #FCA7
 dw #FCFE
 dw #FD00
 db #67 : db 1
 dw #E628
 db #7F : db 7
 dw #CCA7
 dw #CCFD
 dw #DCFD
 dw #EC39
 dw #EDCD
 dw #FB1E
 dw #FC45
 db #87 : db 2
 dw #EBDC
 dw #FBD7
 db #88 : db 8
 dw #CB1C
 dw #E4A0
 dw #F3E6
 dw #F43D
 dw #FB1F
 dw #FB83
 dw #FC3D
 dw #FCA1
 db #8C : db 1
 dw #E382
 db #8F : db 16
 dw #C43D
 dw #C499
 dw #C507
 dw #C55E
 dw #C564
 dw #C626
 dw #CC99
 dw #D499
 dw #D5C2
 dw #D627
 dw #DC99
 dw #DCA4
 dw #E499
 dw #EC99
 dw #F503
 dw #FC41
 db #A5 : db 3
 dw #FDC7
 dw #FDC8
 dw #FDC9
 db #AE : db 2
 dw #D3E5
 dw #D43C
 db #AF : db 14
 dw #C4A6
 dw #C502
 dw #C509
 dw #D3E1
 dw #D503
 dw #D509
 dw #E439
 dw #E43C
 dw #E49F
 dw #E504
 dw #E5CD
 dw #F43C
 dw #F444
 dw #F4A7
 db #BF : db 5
 dw #D49F
 dw #E31D
 dw #E505
 dw #F448
 dw #F4A0
 db #CC : db 7
 dw #C381
 dw #C3E5
 dw #C49F
 dw #C503
 dw #CE2F
 dw #D504
 dw #ECA0
 db #D2 : db 2
 dw #C62B
 dw #E3DB
 db #DF : db 2
 dw #CD03
 dw #FCFF
 db #E1 : db 1
 dw #CE2B
 db #EE : db 2
 dw #CC9F
 dw #DC48
 db #EF : db 2
 dw #C318
 dw #EE29
 db #F0 : db 6
 dw #C629
 dw #CE29
 dw #E3DA
 dw #EBD9
 dw #EBDA
 dw #EBDB
 db #FF : db 17
 dw #CC3C
 dw #CC3D
 dw #CC9B
 dw #CD0A
 dw #CDCE
 dw #DC3C
 dw #DC9F
 dw #DD0A
 dw #DD6C
 dw #EB81
 dw #EC3C
 dw #ED6C
 dw #FC3C
 dw #FCA0
 dw #FCA8
 dw #FD6C
 dw #FDCD
; Taille bloc delta = 562 octets
 DW #0000

; Delta frame 6 -> frame 7
Delta_06_07:
 db #00 : db 12
 dw #C31B
 dw #CB1C
 dw #CCAB
 dw #CDC1
 dw #E55E
 dw #E5C2
 dw #EBE6
 dw #ECFB
 dw #F4FB
 dw #FB1F
 dw #FCAB
 dw #FDC3
 db #01 : db 7
 dw #D506
 dw #D55E
 dw #DCFB
 dw #DDC2
 dw #E4A3
 dw #F5C3
 dw #FD5F
 db #03 : db 7
 dw #C4FB
 dw #C506
 dw #CD5E
 dw #D375
 dw #D5C2
 dw #EC3F
 dw #F55F
 db #07 : db 8
 dw #D499
 dw #D4A3
 dw #E437
 dw #E499
 dw #EC99
 dw #ED5F
 dw #FC40
 dw #FCFC
 db #0F : db 36
 dw #C43B
 dw #C43C
 dw #C43D
 dw #C4A3
 dw #C507
 dw #C55F
 dw #CC3D
 dw #CCA3
 dw #CD07
 dw #CD62
 dw #D3D8
 dw #D3DA
 dw #D4FC
 dw #D507
 dw #D62B
 dw #DBDB
 dw #DC3F
 dw #DCA4
 dw #DCFC
 dw #DD07
 dw #E4A4
 dw #E505
 dw #E507
 dw #E560
 dw #E561
 dw #E562
 dw #EBDC
 dw #EC40
 dw #ECA4
 dw #F3D8
 dw #F440
 dw #F503
 dw #FBD7
 dw #FC41
 dw #FCFD
 dw #FDC9
 db #11 : db 9
 dw #C5C1
 dw #CCA2
 dw #CE26
 dw #DD06
 dw #DD5E
 dw #DE27
 dw #E4FB
 dw #ECA3
 dw #F43F
 db #1E : db 3
 dw #CE28
 dw #EBD7
 dw #F5C5
 db #1F : db 10
 dw #CD08
 dw #CD60
 dw #DB7F
 dw #DCA6
 dw #DD04
 dw #ECA6
 dw #ECFD
 dw #EDCC
 dw #FC38
 dw #FCA6
 db #23 : db 5
 dw #C4A2
 dw #CCFB
 dw #CD06
 dw #D4FB
 dw #E628
 db #2D : db 1
 dw #FBDB
 db #2F : db 10
 dw #C508
 dw #D439
 dw #D508
 dw #D560
 dw #E443
 dw #F438
 dw #F443
 dw #F4A6
 dw #F4FD
 dw #F5CC
 db #3F : db 1
 dw #CB1B
 db #47 : db 6
 dw #C55E
 dw #DCA3
 dw #EDC3
 dw #F499
 dw #FC99
 dw #FCA4
 db #4B : db 2
 dw #C62B
 dw #E3DB
 db #4F : db 1
 dw #FD01
 db #5A : db 4
 dw #C43E
 dw #F3D7
 dw #F3DA
 dw #F5C6
 db #5F : db 20
 dw #CC3B
 dw #CC3C
 dw #CC44
 dw #CD03
 dw #CD09
 dw #CD6B
 dw #DC44
 dw #DCFD
 dw #DD09
 dw #DD6B
 dw #EC44
 dw #ECFE
 dw #ED00
 dw #ED09
 dw #ED6B
 dw #EE2C
 dw #FC44
 dw #FCFF
 dw #FD09
 dw #FD6B
 db #67 : db 3
 dw #C626
 dw #D627
 dw #DC3E
 db #6E : db 2
 dw #CD04
 dw #DD05
 db #77 : db 1
 dw #EE29
 db #78 : db 2
 dw #C628
 dw #E3D8
 db #7F : db 8
 dw #CDCD
 dw #CE2E
 dw #DCFE
 dw #DDCD
 dw #EC9B
 dw #ECA7
 dw #ECFF
 dw #FC9B
 db #87 : db 2
 dw #CE2B
 dw #FDC8
 db #88 : db 8
 dw #C3E5
 dw #C504
 dw #CCA0
 dw #DB1D
 dw #DB82
 dw #EB1E
 dw #ECA1
 dw #FBE6
 db #8C : db 2
 dw #D448
 dw #F31E
 db #8F : db 11
 dw #CDC2
 dw #D43E
 dw #D563
 dw #DE28
 dw #E43F
 dw #E55F
 dw #E5C3
 dw #F4A4
 dw #F4FC
 dw #FC37
 dw #FDC4
 db #99 : db 1
 dw #D43D
 db #AE : db 3
 dw #D31C
 dw #E448
 dw #F43D
 db #AF : db 17
 dw #C49F
 dw #C503
 dw #C56B
 dw #C5CD
 dw #C62E
 dw #D43C
 dw #D49F
 dw #D4A6
 dw #D56B
 dw #D5CD
 dw #E3E1
 dw #E4A6
 dw #E509
 dw #E56B
 dw #F4A0
 dw #F509
 dw #F56B
 db #BF : db 5
 dw #D381
 dw #D504
 dw #E3E5
 dw #E4A0
 dw #F382
 db #C3 : db 1
 dw #FBDC
 db #CC : db 9
 dw #C448
 dw #CBE5
 dw #CC48
 dw #D4A0
 dw #DC3D
 dw #E382
 dw #E43D
 dw #EC3D
 dw #F4A1
 db #D2 : db 1
 dw #C62A
 db #DF : db 2
 dw #CD02
 dw #DD01
 db #E1 : db 2
 dw #DBDA
 dw #EBDB
 db #EE : db 5
 dw #CB81
 dw #DBE5
 dw #DCA0
 dw #EB82
 dw #FCA1
 db #F0 : db 3
 dw #F3DB
 dw #FDC6
 dw #FDC7
 db #FF : db 11
 dw #C31A
 dw #CC9F
 dw #CD6C
 dw #DC3A
 dw #E506
 dw #ECA0
 dw #ED0A
 dw #EDCD
 dw #FC39
 dw #FC3D
 dw #FD0A
; Taille bloc delta = 560 octets
 DW #0000

; Delta frame 7 -> frame 8
Delta_07_08:
 db #00 : db 18
 dw #C381
 dw #C3E5
 dw #C5C1
 dw #CE26
 dw #D55E
 dw #DB82
 dw #DCAB
 dw #DCFB
 dw #DD5E
 dw #DDC2
 dw #DE27
 dw #E4FB
 dw #EB1E
 dw #ECAB
 dw #F3E6
 dw #F5C3
 dw #FB83
 dw #FD5F
 db #01 : db 6
 dw #C4FB
 dw #C505
 dw #C55E
 dw #CCFB
 dw #D627
 dw #EDC3
 db #03 : db 5
 dw #CDC2
 dw #EC99
 dw #F499
 dw #FC3F
 dw #FCFC
 db #07 : db 8
 dw #C499
 dw #C5C2
 dw #CC99
 dw #DD5F
 dw #EC37
 dw #ECFC
 dw #F437
 dw #FC37
 db #0F : db 40
 dw #C4A2
 dw #C4FC
 dw #C506
 dw #C564
 dw #C62B
 dw #CC3C
 dw #CCFC
 dw #CD06
 dw #CD60
 dw #CD61
 dw #CE2B
 dw #D4A3
 dw #D560
 dw #D561
 dw #D562
 dw #D563
 dw #D62A
 dw #DBD8
 dw #DC3E
 dw #DCA3
 dw #DD03
 dw #DD04
 dw #E3D7
 dw #E43F
 dw #E4A3
 dw #E504
 dw #E506
 dw #EBD7
 dw #EC3F
 dw #ECFD
 dw #ED02
 dw #F3D7
 dw #F3DC
 dw #F4A4
 dw #F4FD
 dw #FC40
 dw #FCA4
 dw #FD00
 dw #FD01
 dw #FDC8
 db #11 : db 8
 dw #C4A1
 dw #C626
 dw #CD5E
 dw #D4FB
 dw #D5C2
 dw #E4A2
 dw #E628
 dw #F55F
 db #1E : db 4
 dw #D43E
 dw #D629
 dw #F3D9
 dw #FDC5
 db #1F : db 12
 dw #CD6A
 dw #CDCC
 dw #DCFD
 dw #DD05
 dw #DD08
 dw #DD6A
 dw #DDCC
 dw #ED08
 dw #ED6A
 dw #FCFE
 dw #FD08
 dw #FD6A
 db #23 : db 4
 dw #DCA2
 dw #ED5F
 dw #FC99
 dw #FCA3
 db #2F : db 14
 dw #C4A5
 dw #C560
 dw #C56A
 dw #C5CC
 dw #D31B
 dw #D4A5
 dw #D56A
 dw #D5CC
 dw #E4A5
 dw #E4FD
 dw #E56A
 dw #E5CC
 dw #F508
 dw #F56A
 db #33 : db 1
 dw #EE29
 db #3C : db 2
 dw #EBD8
 dw #FBDA
 db #44 : db 1
 dw #F62C
 db #47 : db 11
 dw #D437
 dw #D4A2
 dw #DC37
 dw #DC99
 dw #E43E
 dw #E499
 dw #E55F
 dw #E5C3
 dw #F4A3
 dw #F4FC
 dw #FDC4
 db #4B : db 2
 dw #C62A
 dw #E5C5
 db #4F : db 1
 dw #ED01
 db #5A : db 2
 dw #C43D
 dw #E3D8
 db #5F : db 11
 dw #CC3A
 dw #CCA6
 dw #CCFD
 dw #CD02
 dw #CD04
 dw #DC39
 dw #DCA6
 dw #DD01
 dw #ECA6
 dw #ECFF
 dw #FDCC
 db #6E : db 2
 dw #CB1B
 dw #FB1E
 db #78 : db 2
 dw #EDC5
 dw #F5C5
 db #7F : db 15
 dw #CC9B
 dw #CCFE
 dw #CD09
 dw #CD6B
 dw #DC9B
 dw #DCA7
 dw #DCFF
 dw #DD09
 dw #DD6B
 dw #ED09
 dw #ED6B
 dw #EDCD
 dw #FCA7
 dw #FD09
 dw #FD6B
 db #87 : db 4
 dw #CE2A
 dw #DBDA
 dw #EDC6
 dw #FBDC
 db #88 : db 6
 dw #C448
 dw #CBE5
 dw #CD05
 dw #DCA1
 dw #E382
 dw #F43E
 db #89 : db 1
 dw #EC3E
 db #8C : db 1
 dw #C4A0
 db #8F : db 14
 dw #C563
 dw #CCA2
 dw #CE27
 dw #D43D
 dw #D506
 dw #D55F
 dw #DD06
 dw #DDC3
 dw #E4FC
 dw #E629
 dw #ECA3
 dw #F43F
 dw #F502
 dw #F5C4
 db #A5 : db 1
 dw #DBD9
 db #AE : db 5
 dw #C504
 dw #D381
 dw #E3E5
 dw #F382
 dw #F448
 db #AF : db 10
 dw #C508
 dw #D504
 dw #D508
 dw #E31C
 dw #E4A0
 dw #E508
 dw #F3E1
 dw #F43D
 dw #F4A1
 dw #F4A6
 db #BF : db 4
 dw #C4AA
 dw #D4A0
 dw #D50C
 dw #E43D
 db #C3 : db 2
 dw #C43E
 dw #EBDB
 db #CC : db 10
 dw #CB81
 dw #D31C
 dw #D3E5
 dw #E31D
 dw #E4A1
 dw #EB82
 dw #EE2D
 dw #F31E
 dw #FC3E
 dw #FCA2
 db #CF : db 2
 dw #DC3D
 dw #DE28
 db #D2 : db 2
 dw #E3DA
 dw #F3DB
 db #E1 : db 2
 dw #CC3E
 dw #FDC7
 db #EE : db 4
 dw #CCA0
 dw #D505
 dw #EC48
 dw #ECA1
 db #F0 : db 3
 dw #F3DA
 dw #F5C6
 dw #FBDB
 db #FF : db 6
 dw #CCA7
 dw #DC45
 dw #DCA0
 dw #EC3D
 dw #FC45
 dw #FCA1
; Taille bloc delta = 570 octets
 DW #0000

; Delta frame 8 -> frame 9
Delta_08_09:
 db #00 : db 14
 dw #C448
 dw #C55E
 dw #C626
 dw #CBE5
 dw #CCFB
 dw #CD5E
 dw #D4FB
 dw #D5C2
 dw #DB1D
 dw #E382
 dw #ED5F
 dw #EDC3
 dw #F55F
 dw #FBE6
 db #01 : db 6
 dw #E55F
 dw #E5C3
 dw #EBD5
 dw #EC99
 dw #F499
 dw #F4FC
 db #03 : db 8
 dw #C437
 dw #CC37
 dw #CC99
 dw #CE27
 dw #D499
 dw #DC99
 dw #DD5F
 dw #FB74
 db #07 : db 5
 dw #CD5F
 dw #D4FC
 dw #E4A2
 dw #F560
 dw #FB14
 db #0F : db 36
 dw #C505
 dw #C560
 dw #C561
 dw #C562
 dw #C563
 dw #C62A
 dw #CCA2
 dw #CD05
 dw #CE28
 dw #CE2A
 dw #D4A2
 dw #D506
 dw #D629
 dw #DBD9
 dw #DC3D
 dw #DCA2
 dw #DCFD
 dw #DD02
 dw #DD05
 dw #DD06
 dw #E4FD
 dw #EBD8
 dw #EC3E
 dw #EC9A
 dw #ECA3
 dw #ECFE
 dw #ED01
 dw #F43F
 dw #F49A
 dw #F4A3
 dw #F502
 dw #FC3F
 dw #FC9A
 dw #FCA3
 dw #FCFE
 dw #FCFF
 db #11 : db 5
 dw #C4FB
 dw #CDC2
 dw #D627
 dw #FC99
 dw #FCFC
 db #1E : db 6
 dw #C43C
 dw #D3D9
 dw #D43D
 dw #E3D8
 dw #E43E
 dw #E5C4
 db #1F : db 3
 dw #CCFD
 dw #CE2D
 dw #EC38
 db #23 : db 4
 dw #C5C2
 dw #E499
 dw #ECFC
 dw #FDC4
 db #2D : db 1
 dw #DC3E
 db #2E : db 1
 dw #DB1C
 db #2F : db 7
 dw #C319
 dw #C507
 dw #C62D
 dw #D4FD
 dw #D507
 dw #F4A5
 dw #F4FE
 db #3C : db 2
 dw #CC3D
 dw #DDC4
 db #47 : db 13
 dw #C499
 dw #D375
 dw #D55F
 dw #DCFC
 dw #DDC3
 dw #DE28
 dw #E437
 dw #E4FC
 dw #EC37
 dw #F437
 dw #F5C4
 dw #FC37
 dw #FD60
 db #4B : db 1
 dw #C43E
 db #4C : db 1
 dw #FB1E
 db #4F : db 2
 dw #CC3B
 dw #ED00
 db #5A : db 5
 dw #D43E
 dw #D5C4
 dw #E3D9
 dw #E3DA
 dw #F3D9
 db #5F : db 22
 dw #CCFF
 dw #CD01
 dw #CD08
 dw #CD6A
 dw #CDCC
 dw #DCFE
 dw #DCFF
 dw #DD00
 dw #DD08
 dw #DD6A
 dw #DDCC
 dw #DE2D
 dw #ED08
 dw #ED6A
 dw #EDCC
 dw #FB1D
 dw #FC9B
 dw #FCA0
 dw #FCA1
 dw #FCA6
 dw #FD08
 dw #FD6A
 db #6E : db 1
 dw #EB1D
 db #6F : db 1
 dw #FCA2
 db #78 : db 1
 dw #FBDA
 db #7F : db 5
 dw #CCA7
 dw #DC45
 dw #FC39
 dw #FC45
 dw #FC9C
 db #87 : db 4
 dw #CC3E
 dw #CE29
 dw #EBDB
 dw #FDC7
 db #88 : db 6
 dw #CB81
 dw #CC48
 dw #D3E5
 dw #D448
 dw #EB82
 dw #F31E
 db #8C : db 2
 dw #E3E5
 dw #E448
 db #8F : db 10
 dw #C4A1
 dw #C55F
 dw #C627
 dw #CCFC
 dw #D3D6
 dw #D505
 dw #D5C3
 dw #D628
 dw #E503
 dw #F43E
 db #AE : db 1
 dw #C4AA
 db #AF : db 19
 dw #C443
 dw #C4A0
 dw #C504
 dw #C56A
 dw #C5CC
 dw #D443
 dw #D4A0
 dw #D4A1
 dw #D56A
 dw #D5CC
 dw #E43D
 dw #E443
 dw #E4A1
 dw #E56A
 dw #E5CC
 dw #F4A2
 dw #F508
 dw #F56A
 dw #F5CC
 db #BF : db 8
 dw #C380
 dw #C3E4
 dw #C50C
 dw #D4AA
 dw #E381
 dw #E4AA
 dw #F3E5
 dw #F4AA
 db #C3 : db 3
 dw #C629
 dw #DDC5
 dw #EDC6
 db #CC : db 5
 dw #D381
 dw #DBE5
 dw #DC48
 dw #F382
 dw #F5CE
 db #CF : db 3
 dw #CCA1
 dw #ECA2
 dw #FC3E
 db #DF : db 1
 dw #CD00
 db #EE : db 6
 dw #DB81
 dw #DCA1
 dw #DE2E
 dw #EBE5
 dw #FB82
 dw #FC48
 db #F0 : db 3
 dw #C43D
 dw #E5C5
 dw #EDC5
 db #FF : db 10
 dw #CCA0
 dw #CDCD
 dw #DDCD
 dw #ECA1
 dw #ED09
 dw #ED6B
 dw #EDCD
 dw #F62B
 dw #FD09
 dw #FD6B
; Taille bloc delta = 538 octets
 DW #0000

; Delta frame 9 -> frame 10
Delta_09_10:
 db #00 : db 20
 dw #C4FB
 dw #C5C2
 dw #CB81
 dw #CC48
 dw #CDC2
 dw #D31C
 dw #D3E5
 dw #D448
 dw #D627
 dw #DBD5
 dw #E55F
 dw #E5C3
 dw #E628
 dw #EB82
 dw #EC99
 dw #F31E
 dw #F499
 dw #F4FC
 dw #FC99
 dw #FCFC
 db #01 : db 6
 dw #D499
 dw #D55F
 dw #DDC3
 dw #E4FC
 dw #F3D5
 dw #FD60
 db #03 : db 6
 dw #CD5F
 dw #D375
 dw #D4FC
 dw #D5C3
 dw #DC37
 dw #EC37
 db #07 : db 3
 dw #C4FC
 dw #CDC3
 dw #FCFD
 db #0F : db 37
 dw #C4A1
 dw #C629
 dw #CC9A
 dw #CCA1
 dw #CCFD
 dw #CD03
 dw #CD04
 dw #CE29
 dw #D3D9
 dw #D49A
 dw #D4A1
 dw #D4FD
 dw #D505
 dw #DBDA
 dw #DC9A
 dw #DCFE
 dw #DD00
 dw #DD01
 dw #E3D8
 dw #E3DB
 dw #E49A
 dw #E4A2
 dw #E503
 dw #EBD9
 dw #ECA2
 dw #ECFF
 dw #ED00
 dw #F4A2
 dw #F4FE
 dw #F4FF
 dw #F500
 dw #F501
 dw #FBDC
 dw #FC3E
 dw #FCA2
 dw #FDC5
 dw #FDC7
 db #11 : db 6
 dw #DC99
 dw #DD5F
 dw #E3D5
 dw #E499
 dw #ECFC
 dw #FDC4
 db #1E : db 3
 dw #DC3D
 dw #F3D9
 dw #F43E
 db #1F : db 5
 dw #CC39
 dw #EB1C
 dw #EDCB
 dw #FC9B
 dw #FDCB
 db #23 : db 14
 dw #C437
 dw #C499
 dw #CC37
 dw #CC99
 dw #CE27
 dw #D437
 dw #DCFC
 dw #DE28
 dw #E437
 dw #F437
 dw #F560
 dw #F5C4
 dw #FBD5
 dw #FC37
 db #2D : db 1
 dw #EC3E
 db #2F : db 13
 dw #C4FD
 dw #C569
 dw #C5CB
 dw #D569
 dw #D5CB
 dw #E4FE
 dw #E507
 dw #E569
 dw #E5CB
 dw #E62C
 dw #F507
 dw #F569
 dw #F5CB
 db #47 : db 6
 dw #C55F
 dw #C627
 dw #CCFC
 dw #ED60
 dw #EDC4
 dw #FB14
 db #4B : db 1
 dw #C5C4
 db #4C : db 1
 dw #EE2D
 db #4F : db 2
 dw #CD02
 dw #DCFF
 db #5A : db 3
 dw #C43C
 dw #C628
 dw #E43E
 db #5F : db 7
 dw #CCFE
 dw #CD00
 dw #EC39
 dw #EC9B
 dw #FC9C
 dw #FC9D
 dw #FC9F
 db #6E : db 1
 dw #DB1C
 db #78 : db 3
 dw #D43D
 dw #D5C4
 dw #F3DA
 db #7F : db 6
 dw #CB80
 dw #CDCC
 dw #DDCC
 dw #EC9C
 dw #EDCC
 dw #FDCC
 db #87 : db 1
 dw #EDC6
 db #88 : db 9
 dw #D381
 dw #DBE5
 dw #DC48
 dw #E31D
 dw #E3E5
 dw #E448
 dw #F382
 dw #F5CE
 dw #FB1E
 db #8C : db 4
 dw #C380
 dw #C3E4
 dw #F3E5
 dw #F448
 db #8F : db 10
 dw #C4A0
 dw #C504
 dw #D43C
 dw #DCA1
 dw #E4A1
 dw #E502
 dw #E560
 dw #F49A
 dw #F4FD
 dw #FC9A
 db #9E : db 2
 dw #E43D
 dw #E5C4
 db #AE : db 3
 dw #D4AA
 dw #E381
 dw #E50C
 db #AF : db 8
 dw #C4A5
 dw #D439
 dw #D4A5
 dw #D62D
 dw #E4A5
 dw #E62D
 dw #F443
 dw #F4A5
 db #BF : db 3
 dw #C447
 dw #D3E4
 dw #F31D
 db #C3 : db 2
 dw #D5C5
 dw #F3DB
 db #CC : db 8
 dw #C31A
 dw #CB1B
 dw #DB81
 dw #EBE5
 dw #EC48
 dw #F62C
 dw #FB82
 dw #FC48
 db #CF : db 4
 dw #CCA0
 dw #DC3C
 dw #EC3D
 dw #ECA1
 db #D2 : db 2
 dw #D43E
 dw #F5C6
 db #DF : db 1
 dw #FC9E
 db #E1 : db 4
 dw #DC3E
 dw #DDC5
 dw #FBDB
 dw #FDC6
 db #EE : db 5
 dw #CBE4
 dw #CCAA
 dw #DCAA
 dw #DD0C
 dw #FBE5
 db #F0 : db 3
 dw #CC3D
 dw #CDC4
 dw #FBDA
 db #FF : db 5
 dw #CD09
 dw #CD6B
 dw #CE2E
 dw #DD09
 dw #DD6B
; Taille bloc delta = 512 octets
 DW #0000

; Delta frame 10 -> frame 11
Delta_10_11:
 db #00 : db 19
 dw #CC99
 dw #D381
 dw #D499
 dw #D55F
 dw #DBE5
 dw #DC48
 dw #DC99
 dw #DCFC
 dw #DD5F
 dw #DDC3
 dw #E31D
 dw #E3E5
 dw #E448
 dw #E499
 dw #E4FC
 dw #ECFC
 dw #F382
 dw #FD60
 dw #FDC4
 db #01 : db 11
 dw #C437
 dw #C55F
 dw #CC37
 dw #CCFC
 dw #D437
 dw #D5C3
 dw #DC37
 dw #E437
 dw #EC37
 dw #F437
 dw #FBD5
 db #03 : db 3
 dw #CDC3
 dw #EDC4
 dw #FC9A
 db #07 : db 6
 dw #CBD6
 dw #D628
 dw #DD60
 dw #E49A
 dw #EC9A
 dw #ECFD
 db #0F : db 25
 dw #C319
 dw #C43E
 dw #C49A
 dw #C4FD
 dw #C504
 dw #C628
 dw #CCA0
 dw #CCFE
 dw #CD02
 dw #D504
 dw #DCA1
 dw #DCFF
 dw #E4A1
 dw #E4FE
 dw #E4FF
 dw #E500
 dw #E501
 dw #E502
 dw #EBDB
 dw #EC38
 dw #EC3D
 dw #ECA1
 dw #F438
 dw #FC38
 dw #FC9B
 db #11 : db 10
 dw #C499
 dw #CB16
 dw #CD5F
 dw #CE27
 dw #D4FC
 dw #EB74
 dw #EBD5
 dw #F560
 dw #F5C4
 dw #FC37
 db #16 : db 2
 dw #C5C3
 dw #E5C4
 db #1E : db 7
 dw #C4A0
 dw #CC3C
 dw #D43C
 dw #E3D9
 dw #E43D
 dw #F561
 dw #F5C5
 db #1F : db 17
 dw #CCA5
 dw #CD07
 dw #CD69
 dw #CDCB
 dw #DC9B
 dw #DCA5
 dw #DD07
 dw #DD69
 dw #DE2C
 dw #EB7F
 dw #EC9B
 dw #ECA5
 dw #ED07
 dw #ED69
 dw #FCA5
 dw #FD07
 dw #FD69
 db #23 : db 3
 dw #C4FC
 dw #ED60
 dw #FCFD
 db #2D : db 1
 dw #FC3E
 db #2F : db 4
 dw #C439
 dw #D4FE
 dw #E49B
 dw #F49B
 db #3C : db 2
 dw #DC3D
 dw #FBDA
 db #3F : db 1
 dw #D31B
 db #47 : db 4
 dw #C3D6
 dw #E560
 dw #F49A
 dw #F4FD
 db #4B : db 4
 dw #C4A1
 dw #E3DA
 dw #F3DB
 dw #F562
 db #4C : db 1
 dw #EB1D
 db #4F : db 2
 dw #CD01
 dw #FCA1
 db #5A : db 1
 dw #F43E
 db #5F : db 8
 dw #CC39
 dw #CC9B
 dw #DDCB
 dw #EC9C
 dw #ECA0
 dw #EDCB
 dw #FC9E
 dw #FDCB
 db #67 : db 1
 dw #C627
 db #6E : db 1
 dw #CB80
 db #77 : db 1
 dw #F62A
 db #78 : db 2
 dw #CDC4
 dw #EDC5
 db #7F : db 11
 dw #CC3A
 dw #CD6A
 dw #CE2D
 dw #DB80
 dw #DC9C
 dw #DE2D
 dw #EC39
 dw #EC9D
 dw #ED6A
 dw #FD08
 dw #FD6A
 db #87 : db 3
 dw #CDC5
 dw #FC3F
 dw #FDC6
 db #88 : db 5
 dw #DB81
 dw #EBE5
 dw #EC48
 dw #F448
 dw #FB82
 db #8C : db 2
 dw #C447
 dw #D4AA
 db #8F : db 9
 dw #D49A
 dw #D4A0
 dw #D560
 dw #DC3C
 dw #DC9A
 dw #E4FD
 dw #F43D
 dw #F4A1
 dw #FDC5
 db #9E : db 1
 dw #FD61
 db #AE : db 6
 dw #C50C
 dw #D3E4
 dw #D50C
 dw #E4AA
 dw #F31D
 dw #F4AA
 db #AF : db 16
 dw #C318
 dw #C43A
 dw #C507
 dw #C569
 dw #C5CB
 dw #C62D
 dw #D507
 dw #D569
 dw #D5CB
 dw #E507
 dw #E569
 dw #E5CB
 dw #F507
 dw #F569
 dw #F5CB
 dw #F62B
 db #BF : db 4
 dw #D380
 dw #D447
 dw #E31C
 dw #F381
 db #C3 : db 2
 dw #D43E
 dw #F5C6
 db #CC : db 9
 dw #C380
 dw #C3E4
 dw #C4AA
 dw #CBE4
 dw #CCAA
 dw #E381
 dw #F3E5
 dw #FBE5
 dw #FD0C
 db #CF : db 2
 dw #DCA0
 dw #FC3D
 db #DF : db 2
 dw #EC9E
 dw #EC9F
 db #E1 : db 2
 dw #EBDA
 dw #FD62
 db #EE : db 6
 dw #CC47
 dw #CD0C
 dw #EB81
 dw #ECAA
 dw #EE2D
 dw #FCAA
 db #F0 : db 3
 dw #C5C4
 dw #E43E
 dw #EC3E
 db #FF : db 5
 dw #EDCC
 dw #F62C
 dw #FB81
 dw #FCA7
 dw #FDCC
; Taille bloc delta = 532 octets
 DW #0000

; Delta frame 11 -> frame 12
Delta_11_12:
 db #00 : db 28
 dw #C3E4
 dw #C499
 dw #C4FC
 dw #C55F
 dw #CCFC
 dw #CD5F
 dw #D4FC
 dw #D5C3
 dw #DB81
 dw #DC37
 dw #E3D5
 dw #E437
 dw #E56E
 dw #EBD5
 dw #EBE5
 dw #EC37
 dw #EC48
 dw #ED60
 dw #F3E5
 dw #F437
 dw #F448
 dw #F560
 dw #F5C4
 dw #FB1E
 dw #FB82
 dw #FBD5
 dw #FC37
 dw #FCFD
 db #01 : db 6
 dw #CDC3
 dw #E560
 dw #EDC4
 dw #F374
 dw #F49A
 dw #F4FD
 db #03 : db 2
 dw #DC9A
 dw #E4FD
 db #07 : db 6
 dw #C49A
 dw #CC9A
 dw #CD60
 dw #D3D6
 dw #D4FD
 dw #FDC5
 db #0F : db 28
 dw #C4A1
 dw #C4FE
 dw #C503
 dw #CC3E
 dw #CCFF
 dw #CD00
 dw #CD01
 dw #D43E
 dw #D4FE
 dw #D4FF
 dw #D502
 dw #D503
 dw #DC3C
 dw #DC9B
 dw #DCA0
 dw #E3DA
 dw #E49B
 dw #EC9B
 dw #EDC6
 dw #F3DB
 dw #F49B
 dw #F4A1
 dw #F5C6
 dw #FC3D
 dw #FC3F
 dw #FC9C
 dw #FCA1
 dw #FDC6
 db #11 : db 5
 dw #C437
 dw #CC37
 dw #D437
 dw #F3D5
 dw #FC9A
 db #16 : db 1
 dw #DDC4
 db #1E : db 2
 dw #D4A0
 dw #F43D
 db #1F : db 8
 dw #CC9B
 dw #CE2C
 dw #EC43
 dw #EC9C
 dw #EDCA
 dw #FB7F
 dw #FC9D
 dw #FDCA
 db #23 : db 8
 dw #C5C3
 dw #C627
 dw #DD60
 dw #E49A
 dw #E5C4
 dw #EC9A
 dw #ECFD
 dw #EE29
 db #2D : db 2
 dw #DD61
 dw #EDC5
 db #2F : db 20
 dw #C49B
 dw #C506
 dw #C568
 dw #C5CA
 dw #C62C
 dw #D37E
 dw #D49B
 dw #D500
 dw #D506
 dw #D568
 dw #D5CA
 dw #D62C
 dw #E506
 dw #E568
 dw #E5CA
 dw #F49C
 dw #F506
 dw #F568
 dw #F5CA
 dw #F62B
 db #3C : db 4
 dw #CC3C
 dw #CCA0
 dw #EC3D
 dw #ED61
 db #47 : db 4
 dw #D49A
 dw #D560
 dw #DCFD
 dw #FD61
 db #4B : db 2
 dw #D561
 dw #E4A1
 db #4C : db 1
 dw #DB1C
 db #4F : db 2
 dw #ECA0
 dw #FCA0
 db #5A : db 1
 dw #F3DA
 db #5F : db 15
 dw #CB7F
 dw #CC9C
 dw #CD69
 dw #CDCB
 dw #DC9C
 dw #DC9D
 dw #DD69
 dw #EC9D
 dw #EC9E
 dw #EC9F
 dw #ED07
 dw #ED69
 dw #FC39
 dw #FD07
 dw #FD69
 db #78 : db 6
 dw #C43C
 dw #C4A0
 dw #E43D
 dw #E561
 dw #E5C5
 dw #FBDA
 db #7F : db 5
 dw #DD6A
 dw #EC3A
 dw #ED08
 dw #EE2C
 dw #FC3A
 db #87 : db 6
 dw #CCA1
 dw #DC3E
 dw #DCA1
 dw #EBDA
 dw #ED62
 dw #FBDB
 db #88 : db 13
 dw #C380
 dw #C447
 dw #C4AA
 dw #CB1B
 dw #CBE4
 dw #CCAA
 dw #D4AA
 dw #D56E
 dw #E381
 dw #E62E
 dw #EB1D
 dw #FBE5
 dw #FC48
 db #8C : db 7
 dw #C50C
 dw #D447
 dw #D50C
 dw #E50C
 dw #F31D
 dw #F4AA
 dw #F50C
 db #8F : db 12
 dw #C318
 dw #C49F
 dw #C560
 dw #CC3B
 dw #CCFD
 dw #D501
 dw #DBD6
 dw #E3D6
 dw #E43C
 dw #E4A0
 dw #F438
 dw #FC38
 db #9E : db 2
 dw #F561
 dw #F5C5
 db #AE : db 4
 dw #D380
 dw #E3E4
 dw #E447
 dw #F381
 db #AF : db 2
 dw #D62E
 dw #E62C
 db #BC : db 1
 dw #D5C4
 db #BF : db 1
 dw #F62C
 db #C3 : db 2
 dw #C43D
 dw #E43E
 db #CC : db 11
 dw #C56E
 dw #CB80
 dw #CC47
 dw #D3E4
 dw #DBE4
 dw #DCAA
 dw #E4AA
 dw #EB81
 dw #ECAA
 dw #ED0C
 dw #FCAA
 db #CF : db 2
 dw #CC9F
 dw #EC3C
 db #D2 : db 1
 dw #F562
 db #DF : db 1
 dw #DC9F
 db #E1 : db 3
 dw #CC3D
 dw #EC3E
 dw #FC3E
 db #EE : db 1
 dw #DC47
 db #EF : db 1
 dw #F62A
 db #F0 : db 3
 dw #D43D
 dw #DC3D
 dw #F43E
 db #FF : db 7
 dw #CBE3
 dw #CC3A
 dw #CDCC
 dw #DDCC
 dw #DE2D
 dw #ECA7
 dw #FD6A
; Taille bloc delta = 554 octets
 DW #0000

; Delta frame 12 -> frame 13
Delta_12_13:
 db #00 : db 22
 dw #C380
 dw #C437
 dw #C447
 dw #C4AA
 dw #CBE4
 dw #CC37
 dw #CCAA
 dw #CDC3
 dw #D3E4
 dw #D437
 dw #D4AA
 dw #DD60
 dw #E381
 dw #E560
 dw #EC9A
 dw #ECFD
 dw #F3D5
 dw #F49A
 dw #F4FD
 dw #FBE5
 dw #FC48
 dw #FC9A
 db #01 : db 4
 dw #C5C3
 dw #D49A
 dw #D560
 dw #DCFD
 db #03 : db 4
 dw #C3D6
 dw #CCFD
 dw #DE28
 dw #FC38
 db #07 : db 9
 dw #C438
 dw #CC38
 dw #D438
 dw #DBD6
 dw #DC38
 dw #E3D6
 dw #E438
 dw #F3D6
 dw #FC9B
 db #0F : db 27
 dw #C43D
 dw #C4FF
 dw #CC9B
 dw #CC9F
 dw #CCA1
 dw #CCA5
 dw #D49B
 dw #D500
 dw #D501
 dw #DC3E
 dw #DC9C
 dw #DCA1
 dw #E3D9
 dw #E43E
 dw #E4A1
 dw #EBDA
 dw #EC43
 dw #EC9C
 dw #EC9D
 dw #EDC5
 dw #F49C
 dw #FBDB
 dw #FC39
 dw #FC9D
 dw #FC9E
 dw #FC9F
 dw #FCA0
 db #11 : db 6
 dw #DC9A
 dw #E49A
 dw #E4FD
 dw #E628
 dw #EDC4
 dw #F629
 db #16 : db 2
 dw #D5C4
 dw #ED61
 db #1E : db 2
 dw #C49F
 dw #DC3C
 db #1F : db 8
 dw #CC39
 dw #CDCA
 dw #DC39
 dw #DDCA
 dw #EC39
 dw #EE2B
 dw #FBD7
 dw #FD68
 db #23 : db 7
 dw #C49A
 dw #CC9A
 dw #CD60
 dw #D375
 dw #D4FD
 dw #FB74
 dw #FD61
 db #2F : db 8
 dw #C500
 dw #D439
 dw #E439
 dw #E49C
 dw #E4A4
 dw #E62B
 dw #F439
 dw #F4A4
 db #33 : db 1
 dw #FE2A
 db #3C : db 5
 dw #CDC4
 dw #DD61
 dw #E4A0
 dw #ECA0
 dw #FC3D
 db #47 : db 9
 dw #C4FD
 dw #C560
 dw #CBD6
 dw #DDC4
 dw #EC38
 dw #EE29
 dw #F438
 dw #FCFE
 dw #FDC5
 db #4B : db 4
 dw #C561
 dw #E5C5
 dw #F3DA
 dw #F4A1
 db #4F : db 2
 dw #DC9F
 dw #FBD8
 db #56 : db 1
 dw #F561
 db #5F : db 5
 dw #CC9D
 dw #CE2C
 dw #DC9E
 dw #DE2C
 dw #FC3A
 db #69 : db 1
 dw #CD61
 db #6E : db 2
 dw #DB80
 dw #FB1D
 db #78 : db 4
 dw #C5C4
 dw #D561
 dw #DCA0
 dw #F43D
 db #7F : db 6
 dw #CC9E
 dw #DC3A
 dw #DD08
 dw #EB80
 dw #EDCB
 dw #FC3B
 db #87 : db 5
 dw #CC3D
 dw #DD62
 dw #DDC5
 dw #EC3E
 dw #ECA1
 db #88 : db 14
 dw #C56E
 dw #CB80
 dw #CC47
 dw #CD6E
 dw #D447
 dw #DBE4
 dw #DCAA
 dw #E4AA
 dw #EB81
 dw #ECAA
 dw #F4AA
 dw #FCAA
 dw #FD0C
 dw #FE2C
 db #8C : db 1
 dw #E447
 db #8F : db 8
 dw #C502
 dw #D49F
 dw #EBD6
 dw #F49B
 dw #F4FE
 dw #F5C5
 dw #F62A
 dw #FBD6
 db #9E : db 2
 dw #E43C
 dw #F4A0
 db #AE : db 4
 dw #C3E3
 dw #F3E4
 dw #F447
 dw #F56D
 db #AF : db 8
 dw #C5CA
 dw #C62C
 dw #D5CA
 dw #D62C
 dw #E5CA
 dw #F31C
 dw #F5CA
 dw #F62B
 db #BC : db 1
 dw #E561
 db #BF : db 4
 dw #C37F
 dw #C4A9
 dw #D62E
 dw #E380
 db #C3 : db 4
 dw #C4A0
 dw #D43D
 dw #F43E
 dw #FC3E
 db #CC : db 15
 dw #C50C
 dw #CB1B
 dw #CD0C
 dw #D380
 dw #D50C
 dw #DC47
 dw #DD0C
 dw #E3E4
 dw #E50C
 dw #EBE4
 dw #EC47
 dw #F31D
 dw #F381
 dw #F50C
 dw #FB81
 db #D2 : db 1
 dw #E562
 db #E1 : db 4
 dw #CCA0
 dw #DC3D
 dw #ED62
 dw #FBDA
 db #EE : db 2
 dw #C31A
 dw #FC47
 db #EF : db 1
 dw #FC3C
 db #F0 : db 5
 dw #D4A0
 dw #E43D
 dw #EC3D
 dw #F562
 dw #FD62
 db #FF : db 7
 dw #CE2D
 dw #DBE3
 dw #DCA7
 dw #DD6A
 dw #ED6A
 dw #FDCB
 dw #FE2B
; Taille bloc delta = 530 octets
 DW #0000

; Delta frame 13 -> frame 14
Delta_13_14:
 db #00 : db 28
 dw #C50C
 dw #C56E
 dw #C5C3
 dw #CC47
 dw #CC9A
 dw #CD60
 dw #CD6E
 dw #D447
 dw #D49A
 dw #D4FD
 dw #D50C
 dw #D560
 dw #D56E
 dw #DBE4
 dw #DC47
 dw #DC9A
 dw #DCAA
 dw #DCFD
 dw #DD6E
 dw #E49A
 dw #E4AA
 dw #E4FD
 dw #EB74
 dw #EB81
 dw #ECAA
 dw #EDC4
 dw #F4AA
 dw #FCAA
 db #01 : db 9
 dw #C4FD
 dw #C560
 dw #E438
 dw #E5C4
 dw #E628
 dw #EC38
 dw #F438
 dw #F561
 dw #FB74
 db #03 : db 11
 dw #C438
 dw #CBD6
 dw #CC38
 dw #D3D6
 dw #DBD6
 dw #EBD6
 dw #EC9B
 dw #ED61
 dw #F49B
 dw #F4FE
 dw #FBD6
 db #07 : db 5
 dw #CDC4
 dw #DC9B
 dw #E49B
 dw #E4FE
 dw #F5C5
 db #0F : db 30
 dw #C49B
 dw #C500
 dw #C501
 dw #CC3D
 dw #CC9C
 dw #CDC5
 dw #D43D
 dw #D49C
 dw #D5C5
 dw #DC39
 dw #DC9D
 dw #DDC5
 dw #E439
 dw #E49C
 dw #E5C5
 dw #E629
 dw #EC39
 dw #EC3E
 dw #EC9E
 dw #EC9F
 dw #ECA1
 dw #F3D9
 dw #F3DA
 dw #F439
 dw #F43E
 dw #F49D
 dw #F49E
 dw #F4A1
 dw #F62A
 dw #FBDA
 db #11 : db 4
 dw #C49A
 dw #CCFD
 dw #FC38
 dw #FD61
 db #1E : db 4
 dw #C502
 dw #DC9F
 dw #E43C
 dw #EC3C
 db #1F : db 7
 dw #CE2B
 dw #DC9E
 dw #DD68
 dw #DE2B
 dw #ED68
 dw #FB1C
 dw #FC3A
 db #23 : db 7
 dw #C3D6
 dw #D438
 dw #DC38
 dw #DDC4
 dw #F629
 dw #FC9B
 dw #FCFE
 db #2D : db 1
 dw #FCA0
 db #2F : db 7
 dw #C49C
 dw #C62B
 dw #D62B
 dw #E49D
 dw #E5C9
 dw #F3D7
 dw #F5C9
 db #34 : db 1
 dw #DD61
 db #3C : db 3
 dw #CC9F
 dw #D49F
 dw #DC3C
 db #3F : db 1
 dw #C31A
 db #47 : db 5
 dw #D5C4
 dw #DE28
 dw #E3D6
 dw #ECFE
 dw #F3D6
 db #4B : db 3
 dw #C43C
 dw #C562
 dw #F4FF
 db #4C : db 2
 dw #CB1B
 dw #DB80
 db #4F : db 2
 dw #CC9E
 dw #FC3C
 db #56 : db 1
 dw #E561
 db #5F : db 9
 dw #DB7F
 dw #DD07
 dw #DDCA
 dw #EC3A
 dw #ED08
 dw #EDCA
 dw #EE2B
 dw #FC3B
 dw #FDCA
 db #69 : db 2
 dw #FCFF
 dw #FD62
 db #78 : db 6
 dw #C49F
 dw #C561
 dw #CC3C
 dw #CD61
 dw #D43C
 dw #F4A0
 db #7F : db 6
 dw #CC3A
 dw #CD08
 dw #CDCB
 dw #DE2C
 dw #EC3B
 dw #FB80
 db #87 : db 4
 dw #CCA0
 dw #CD62
 dw #DC3D
 dw #FC3E
 db #88 : db 11
 dw #CD0C
 dw #CDCF
 dw #DD0C
 dw #E3E4
 dw #E447
 dw #E50C
 dw #EBE4
 dw #EC47
 dw #ED0C
 dw #F381
 dw #F50C
 db #8C : db 2
 dw #C3E3
 dw #C4A9
 db #8F : db 7
 dw #D43B
 dw #D49B
 dw #D628
 dw #DCFE
 dw #EE29
 dw #F3D8
 dw #F49F
 db #9E : db 2
 dw #E49F
 dw #F43C
 db #AE : db 4
 dw #C446
 dw #D4A9
 dw #E31C
 dw #E380
 db #AF : db 7
 dw #C568
 dw #D568
 dw #D62E
 dw #E568
 dw #E62B
 dw #F506
 dw #F568
 db #BF : db 5
 dw #D3E3
 dw #D446
 dw #E4A9
 dw #E56D
 dw #F4A9
 db #C3 : db 3
 dw #D4A0
 dw #D562
 dw #E43D
 db #CC : db 5
 dw #C5CF
 dw #F3E4
 dw #F447
 dw #FBE4
 dw #FC47
 db #CF : db 1
 dw #DC3B
 db #E1 : db 5
 dw #DCA0
 dw #DD62
 dw #E4A0
 dw #EC3D
 dw #ECA0
 db #EE : db 5
 dw #CBE3
 dw #CC46
 dw #CCA9
 dw #DCA9
 dw #ED6D
 db #F0 : db 3
 dw #E562
 dw #F43D
 dw #FC3D
 db #F8 : db 2
 dw #C5C4
 dw #D561
 db #FF : db 6
 dw #DDCB
 dw #EBE3
 dw #EDCB
 dw #FBE3
 dw #FD08
 dw #FE2A
; Taille bloc delta = 532 octets
 DW #0000

; Delta frame 14 -> frame 15
Delta_14_15:
 db #00 : db 29
 dw #C49A
 dw #C4FD
 dw #C560
 dw #CB80
 dw #CCFD
 dw #CD0C
 dw #D5CF
 dw #DC38
 dw #DD0C
 dw #E3E4
 dw #E438
 dw #E447
 dw #E50C
 dw #EB1D
 dw #EBE4
 dw #EC38
 dw #EC47
 dw #ED0C
 dw #F374
 dw #F381
 dw #F3E4
 dw #F438
 dw #F447
 dw #F50C
 dw #FC38
 dw #FC9B
 dw #FCFE
 dw #FD0C
 dw #FD61
 db #01 : db 13
 dw #C3D6
 dw #CBD6
 dw #CE27
 dw #D3D6
 dw #DBD6
 dw #E3D6
 dw #E49B
 dw #EBD6
 dw #ECFE
 dw #ED61
 dw #F3D6
 dw #F4FE
 dw #FBD6
 db #03 : db 3
 dw #CC9B
 dw #D5C4
 dw #DCFE
 db #07 : db 7
 dw #C5C4
 dw #CCFE
 dw #DE28
 dw #E375
 dw #F439
 dw #F629
 dw #FC39
 db #0F : db 21
 dw #C439
 dw #C49C
 dw #C4A0
 dw #CC39
 dw #CC3B
 dw #CC3C
 dw #CC9D
 dw #CC9E
 dw #D439
 dw #D49D
 dw #DC3D
 dw #DC9E
 dw #E49D
 dw #E49E
 dw #EC3A
 dw #EE29
 dw #F3D7
 dw #FBD7
 dw #FC3A
 dw #FC3E
 dw #FD62
 db #11 : db 9
 dw #C438
 dw #CC38
 dw #D438
 dw #EC9B
 dw #EE28
 dw #F49B
 dw #F561
 dw #FB74
 dw #FE29
 db #12 : db 1
 dw #DD61
 db #16 : db 1
 dw #D561
 db #1E : db 5
 dw #C501
 dw #F43C
 dw #F49F
 dw #FC3C
 dw #FC9F
 db #1F : db 10
 dw #CBE1
 dw #CCA5
 dw #CD68
 dw #DBE1
 dw #DC3A
 dw #EBE1
 dw #EDC9
 dw #FC3B
 dw #FC43
 dw #FDC9
 db #23 : db 4
 dw #D49B
 dw #DC9B
 dw #E4FE
 dw #E628
 db #2D : db 1
 dw #ECFF
 db #2F : db 10
 dw #C5C9
 dw #D4A4
 dw #D5C9
 dw #E31B
 dw #E37E
 dw #E43A
 dw #E567
 dw #F43A
 dw #F567
 dw #F62A
 db #32 : db 1
 dw #E561
 db #34 : db 1
 dw #CD61
 db #3C : db 2
 dw #EC3C
 dw #EC9F
 db #47 : db 4
 dw #C49B
 dw #CDC4
 dw #D4FE
 dw #DB75
 db #4B : db 5
 dw #D4A0
 dw #D502
 dw #E43D
 dw #E4FF
 dw #F500
 db #4C : db 1
 dw #FB1D
 db #4F : db 1
 dw #DC3B
 db #5A : db 2
 dw #D43C
 dw #F562
 db #5F : db 7
 dw #CC3A
 dw #CD08
 dw #CDCA
 dw #DE2B
 dw #EB1C
 dw #EC3B
 dw #FD68
 db #6E : db 2
 dw #CB1B
 dw #EB80
 db #78 : db 7
 dw #D49F
 dw #DC3C
 dw #DC9F
 dw #E43C
 dw #E49F
 dw #F4FF
 dw #FCFF
 db #7F : db 6
 dw #CE2C
 dw #DDCB
 dw #FD08
 dw #FD69
 dw #FDCA
 dw #FE2B
 db #87 : db 1
 dw #DCA0
 db #88 : db 7
 dw #C3E3
 dw #C4A9
 dw #CCA9
 dw #D380
 dw #FB81
 dw #FBE4
 dw #FC47
 db #8C : db 6
 dw #D3E3
 dw #D446
 dw #E380
 dw #E4A9
 dw #F4A9
 dw #F56D
 db #8F : db 4
 dw #C4FE
 dw #E439
 dw #EB75
 dw #EC39
 db #9E : db 1
 dw #C49E
 db #AE : db 5
 dw #C37F
 dw #C50B
 dw #D50B
 dw #E446
 dw #E56D
 db #AF : db 4
 dw #C62B
 dw #D62B
 dw #E506
 dw #F5C9
 db #BF : db 7
 dw #C56D
 dw #D56D
 dw #D62E
 dw #E3E3
 dw #E50B
 dw #F380
 dw #F50B
 db #C3 : db 9
 dw #C502
 dw #C562
 dw #CD02
 dw #E4A0
 dw #EC3D
 dw #ECA0
 dw #F4A0
 dw #FCA0
 dw #FD00
 db #CC : db 7
 dw #C446
 dw #CBE3
 dw #CC46
 dw #D4A9
 dw #DCA9
 dw #ECA9
 dw #FD6D
 db #D2 : db 3
 dw #D562
 dw #E562
 dw #F43D
 db #DF : db 1
 dw #FE2A
 db #E1 : db 2
 dw #CD62
 dw #FC3D
 db #EE : db 7
 dw #CD0B
 dw #DBE3
 dw #DC46
 dw #DD0B
 dw #DD6D
 dw #FAB7
 dw #FCA9
 db #F0 : db 2
 dw #C49F
 dw #CC9F
 db #F8 : db 1
 dw #C561
 db #FF : db 4
 dw #CC45
 dw #CCA7
 dw #EE2C
 dw #FC45
; Taille bloc delta = 534 octets
 DW #0000

; Delta frame 15 -> frame 16
Delta_15_16:
 db #00 : db 29
 dw #C3D6
 dw #C3E3
 dw #C438
 dw #C446
 dw #C4A9
 dw #CBD6
 dw #CC38
 dw #CCA9
 dw #D3D6
 dw #D438
 dw #D4A9
 dw #DBD6
 dw #DC9B
 dw #DCA9
 dw #E3D6
 dw #E49B
 dw #E4A9
 dw #EBD6
 dw #EC9B
 dw #ECFE
 dw #F3D6
 dw #F49B
 dw #F4FE
 dw #F561
 dw #FB74
 dw #FB81
 dw #FBD6
 dw #FBE4
 dw #FC47
 db #01 : db 6
 dw #C49B
 dw #D4FE
 dw #D627
 dw #DDC4
 dw #E561
 dw #FC39
 db #03 : db 6
 dw #C4FE
 dw #C627
 dw #CDC4
 dw #DB75
 dw #DC39
 dw #E439
 db #07 : db 6
 dw #C439
 dw #E628
 dw #EB75
 dw #EC9C
 dw #F49C
 dw #FBD7
 db #0F : db 20
 dw #C43C
 dw #C49D
 dw #CCA0
 dw #CCA5
 dw #D4A0
 dw #D4A4
 dw #D628
 dw #DC3A
 dw #DC3B
 dw #DE28
 dw #E31B
 dw #E43A
 dw #EBE1
 dw #EC3B
 dw #ED62
 dw #F43A
 dw #F629
 dw #FBD8
 dw #FC3B
 dw #FC43
 db #11 : db 8
 dw #CB75
 dw #CC9B
 dw #D49B
 dw #DCFE
 dw #E4FE
 dw #E5C4
 dw #ED61
 dw #F628
 db #12 : db 1
 dw #CD61
 db #16 : db 1
 dw #C561
 db #1E : db 4
 dw #C49E
 dw #CC9E
 dw #D49E
 dw #D501
 db #1F : db 4
 dw #CC3A
 dw #DDC9
 dw #EB1C
 dw #EE2A
 db #23 : db 7
 dw #CCFE
 dw #CE27
 dw #D5C4
 dw #DD61
 dw #EC39
 dw #EE28
 dw #F439
 db #2D : db 1
 dw #DC3C
 db #2E : db 1
 dw #CB1B
 db #2F : db 9
 dw #C31A
 dw #C43A
 dw #C62A
 dw #D31B
 dw #D43A
 dw #D567
 dw #D62A
 dw #E62A
 dw #F43B
 db #32 : db 1
 dw #D561
 db #34 : db 1
 dw #FCFF
 db #3C : db 4
 dw #CD01
 dw #DCFF
 dw #ECFF
 dw #FC3C
 db #47 : db 4
 dw #CC39
 dw #D439
 dw #E375
 dw #FC9C
 db #4B : db 5
 dw #C502
 dw #D43C
 dw #E4A0
 dw #E562
 dw #F4A0
 db #4F : db 1
 dw #EBD8
 db #5A : db 2
 dw #D4FF
 dw #E43C
 db #5F : db 3
 dw #CE2B
 dw #DD08
 dw #FE2A
 db #77 : db 1
 dw #FE29
 db #78 : db 6
 dw #C501
 dw #E4FF
 dw #EC3C
 dw #F43C
 dw #F49F
 dw #FC9F
 db #7F : db 6
 dw #CBE2
 dw #CCA7
 dw #DBE2
 dw #ED08
 dw #EE2B
 dw #FC45
 db #87 : db 6
 dw #CD02
 dw #DD00
 dw #DD02
 dw #EC3D
 dw #ECA0
 dw #FCA0
 db #88 : db 13
 dw #C31B
 dw #C5CF
 dw #CBE3
 dw #CC46
 dw #D31C
 dw #D446
 dw #DB80
 dw #EB1D
 dw #ECA9
 dw #F4A9
 dw #FAB8
 dw #FCA9
 dw #FD6D
 db #8C : db 7
 dw #C56D
 dw #D56D
 dw #E3E3
 dw #E446
 dw #E50B
 dw #E56D
 dw #F50B
 db #8F : db 13
 dw #C3D7
 dw #D3D7
 dw #E3D7
 dw #E3D8
 dw #E43B
 dw #E49C
 dw #EBD7
 dw #F375
 dw #F3D7
 dw #F562
 dw #F5C5
 dw #FB75
 dw #FD62
 db #AE : db 2
 dw #F380
 dw #F446
 db #AF : db 5
 dw #C5C9
 dw #D5C9
 dw #E5C9
 dw #F3D8
 dw #F62A
 db #BF : db 4
 dw #C4A8
 dw #D5CE
 dw #E31C
 dw #F3E3
 db #C3 : db 5
 dw #D562
 dw #E500
 dw #ED00
 dw #F43D
 dw #F500
 db #CC : db 15
 dw #C50B
 dw #CD0B
 dw #CD6D
 dw #D3E3
 dw #D50B
 dw #DBE3
 dw #DC46
 dw #DD0B
 dw #DD6D
 dw #E380
 dw #EC46
 dw #ED0B
 dw #ED6D
 dw #F56D
 dw #FD0B
 db #E1 : db 1
 dw #FD00
 db #EE : db 3
 dw #DDCE
 dw #EBE3
 dw #FC46
 db #F0 : db 4
 dw #D49F
 dw #DC9F
 dw #E49F
 dw #EC9F
 db #F8 : db 1
 dw #F4FF
 db #FF : db 6
 dw #DC45
 dw #DDCB
 dw #DE2C
 dw #EC45
 dw #FAB7
 dw #FE2B
; Taille bloc delta = 524 octets
 DW #0000

; Delta frame 16 -> frame 17
Delta_16_17:
 db #00 : db 24
 dw #C49B
 dw #C50B
 dw #C5CF
 dw #CB75
 dw #CBE3
 dw #CC46
 dw #CC9B
 dw #CD0B
 dw #CDCF
 dw #D380
 dw #D446
 dw #D49B
 dw #D4FE
 dw #D50B
 dw #DC46
 dw #DCFE
 dw #E4FE
 dw #EC39
 dw #ECA9
 dw #ED61
 dw #F439
 dw #F4A9
 dw #FC39
 dw #FCA9
 db #01 : db 10
 dw #C439
 dw #C4FE
 dw #CC39
 dw #D375
 dw #D439
 dw #D561
 dw #DE27
 dw #E5C4
 dw #F314
 dw #FC9C
 db #03 : db 7
 dw #CE27
 dw #DBD7
 dw #E375
 dw #E3D7
 dw #E49C
 dw #EB75
 dw #EBD7
 db #07 : db 6
 dw #C49C
 dw #C627
 dw #CC9C
 dw #EE28
 dw #FD62
 dw #FDC5
 db #0F : db 22
 dw #C31A
 dw #C43A
 dw #C502
 dw #CC3A
 dw #D43A
 dw #D43B
 dw #D43C
 dw #D502
 dw #DC3C
 dw #DCA0
 dw #DD02
 dw #DD62
 dw #E3D8
 dw #E43B
 dw #E43D
 dw #E4A0
 dw #E562
 dw #E628
 dw #EBD8
 dw #ECA0
 dw #F43B
 dw #F4A0
 db #11 : db 7
 dw #CCFE
 dw #DC39
 dw #DD61
 dw #E439
 dw #E561
 dw #E627
 dw #EDC4
 db #12 : db 2
 dw #C561
 dw #FCFF
 db #1E : db 4
 dw #E49E
 dw #E501
 dw #EC9E
 dw #F49E
 db #1F : db 5
 dw #CB1B
 dw #CCA5
 dw #DE2A
 dw #EBE1
 dw #FBE1
 db #23 : db 8
 dw #CD61
 dw #D627
 dw #DB75
 dw #EC9C
 dw #F3D7
 dw #F49C
 dw #F628
 dw #FBD7
 db #2D : db 2
 dw #DD01
 dw #EC3C
 db #2F : db 6
 dw #D4A4
 dw #E5C8
 dw #F37E
 dw #F3D8
 dw #F5C8
 dw #F629
 db #34 : db 1
 dw #ECFF
 db #3C : db 4
 dw #CC9E
 dw #CCFF
 dw #D49E
 dw #DC9E
 db #47 : db 7
 dw #C3D7
 dw #CBD7
 dw #D3D7
 dw #D49C
 dw #DC9C
 dw #F375
 dw #FB75
 db #4B : db 2
 dw #D562
 dw #F43D
 db #4C : db 1
 dw #EB80
 db #55 : db 1
 dw #C68C
 db #56 : db 1
 dw #F4FF
 db #5A : db 3
 dw #C4FF
 dw #D501
 dw #F43C
 db #5F : db 3
 dw #EB7F
 dw #EE2A
 dw #FDC9
 db #6E : db 3
 dw #DB1C
 dw #FB1D
 dw #FB80
 db #78 : db 3
 dw #C49E
 dw #D4FF
 dw #FC3C
 db #7F : db 4
 dw #CB7F
 dw #CD08
 dw #EBE2
 dw #ED69
 db #87 : db 1
 dw #CD00
 db #88 : db 17
 dw #C56D
 dw #CD6D
 dw #D3E3
 dw #D56D
 dw #DBE3
 dw #DD0B
 dw #DD6D
 dw #E446
 dw #E50B
 dw #E56D
 dw #EC46
 dw #ED0B
 dw #ED6D
 dw #F446
 dw #F50B
 dw #F56D
 dw #FD0B
 db #8C : db 4
 dw #C4A8
 dw #D4A8
 dw #E5CE
 dw #F3E3
 db #8F : db 2
 dw #F43A
 dw #FC3A
 db #9E : db 1
 dw #E4FF
 db #AE : db 2
 dw #C445
 dw #E4A8
 db #AF : db 2
 dw #D62A
 dw #E62A
 db #BC : db 1
 dw #DCFF
 db #BF : db 3
 dw #C3E2
 dw #C50A
 dw #F4A8
 db #C3 : db 4
 dw #C49F
 dw #D500
 dw #DD00
 dw #FC3D
 db #CC : db 6
 dw #C31B
 dw #CCA8
 dw #D31C
 dw #E3E3
 dw #EBE3
 dw #FC46
 db #DF : db 1
 dw #FE29
 db #E1 : db 3
 dw #CC9F
 dw #DC9F
 dw #ED00
 db #EE : db 3
 dw #DCA8
 dw #ECA8
 dw #FBE3
 db #F0 : db 4
 dw #C501
 dw #CD01
 dw #F49F
 dw #FC9F
 db #FF : db 3
 dw #CCA7
 dw #CE2C
 dw #FC45
; Taille bloc delta = 468 octets
 DW #0000

; Delta frame 17 -> frame 18
Delta_17_18:
 db #00 : db 32
 dw #C439
 dw #C4FE
 dw #C56D
 dw #CC39
 dw #CCFE
 dw #CD6D
 dw #D3E3
 dw #D439
 dw #D56D
 dw #DC39
 dw #DD0B
 dw #DD6D
 dw #E439
 dw #E446
 dw #E50B
 dw #E561
 dw #E56D
 dw #EBD7
 dw #EC46
 dw #ED0B
 dw #ED6D
 dw #F3D7
 dw #F446
 dw #F49C
 dw #F50B
 dw #F56D
 dw #F5CE
 dw #FBD7
 dw #FC46
 dw #FC9C
 dw #FD0B
 dw #FD6D
 db #01 : db 10
 dw #C3D7
 dw #C561
 dw #CD61
 dw #D49C
 dw #DC9C
 dw #E375
 dw #EB75
 dw #EDC4
 dw #F375
 dw #FB75
 db #03 : db 6
 dw #D5C4
 dw #DE27
 dw #ECFF
 dw #F43A
 dw #FB14
 dw #FC3A
 db #07 : db 7
 dw #C376
 dw #CE27
 dw #D43A
 dw #D627
 dw #DC3A
 dw #F562
 dw #F628
 db #0F : db 10
 dw #CD02
 dw #CD62
 dw #D562
 dw #EC3D
 dw #EE28
 dw #F3D8
 dw #F43D
 dw #F5C5
 dw #FCA0
 dw #FDC5
 db #11 : db 12
 dw #C68B
 dw #CBD7
 dw #D375
 dw #D3D7
 dw #D561
 dw #DB75
 dw #DBD7
 dw #E3D7
 dw #E49C
 dw #EC9C
 dw #EE27
 dw #F5C4
 db #16 : db 1
 dw #D4FF
 db #1E : db 2
 dw #F49D
 dw #F501
 db #1F : db 7
 dw #CB7E
 dw #CC43
 dw #CDC9
 dw #CE2A
 dw #DC43
 dw #EC43
 dw #FC43
 db #23 : db 5
 dw #C49C
 dw #CC9C
 dw #DDC4
 dw #E627
 dw #FCFF
 db #2D : db 1
 dw #ED01
 db #2F : db 4
 dw #C567
 dw #D5C8
 dw #D629
 dw #E629
 db #32 : db 1
 dw #F4FF
 db #33 : db 1
 dw #FE28
 db #34 : db 1
 dw #CCFF
 db #3C : db 3
 dw #EC9E
 dw #FC3C
 dw #FC9D
 db #47 : db 3
 dw #CDC4
 dw #E43A
 dw #EC3A
 db #4B : db 1
 dw #C562
 db #56 : db 2
 dw #DCFF
 dw #E4FF
 db #5A : db 1
 dw #E501
 db #5F : db 9
 dw #CD07
 dw #CD08
 dw #DB1C
 dw #DE2A
 dw #ED68
 dw #ED69
 dw #EDC9
 dw #FB7F
 dw #FE29
 db #78 : db 3
 dw #CC9E
 dw #D49E
 dw #E49E
 db #7F : db 7
 dw #CC44
 dw #DCA6
 dw #DD08
 dw #DE2B
 dw #EDCA
 dw #FBE2
 dw #FE2A
 db #87 : db 2
 dw #CC9F
 dw #FC3D
 db #88 : db 9
 dw #C4A8
 dw #CB1C
 dw #CCA8
 dw #CE2F
 dw #D4A8
 dw #DCA8
 dw #E3E3
 dw #EBE3
 dw #EDCE
 db #8C : db 7
 dw #C445
 dw #C50A
 dw #C62F
 dw #D5CE
 dw #F31D
 dw #F380
 dw #F4A8
 db #8F : db 7
 dw #C43A
 dw #C627
 dw #CB76
 dw #CC3A
 dw #EB15
 dw #ED62
 dw #FBD8
 db #96 : db 2
 dw #C500
 dw #CD00
 db #9E : db 1
 dw #C4FF
 db #AE : db 7
 dw #C3E2
 dw #C5CE
 dw #D445
 dw #D50A
 dw #E50A
 dw #F50A
 dw #F56C
 db #AF : db 5
 dw #C62A
 dw #E31C
 dw #F567
 dw #F5C8
 dw #F629
 db #B4 : db 1
 dw #FC9E
 db #BF : db 5
 dw #C37F
 dw #C56C
 dw #D56C
 dw #E445
 dw #E56C
 db #C3 : db 5
 dw #D49F
 dw #DC9F
 dw #E49F
 dw #ED00
 dw #FD00
 db #CC : db 8
 dw #DDCE
 dw #E4A8
 dw #E5CE
 dw #EB80
 dw #ECA8
 dw #F3E3
 dw #FBE3
 dw #FCA8
 db #D2 : db 1
 dw #D500
 db #E1 : db 5
 dw #CD01
 dw #DD01
 dw #EC9F
 dw #F49F
 dw #FC9F
 db #EE : db 12
 dw #CC45
 dw #CD0A
 dw #CD6C
 dw #CDCE
 dw #DC45
 dw #DD0A
 dw #DD6C
 dw #ED0A
 dw #ED6C
 dw #FAB8
 dw #FD0A
 dw #FD6C
 db #F0 : db 1
 dw #D501
 db #FF : db 1
 dw #CD6A
; Taille bloc delta = 498 octets
 DW #0000

; Delta frame 18 -> frame 19
Delta_18_19:
 db #00 : db 29
 dw #C3D7
 dw #C49C
 dw #C4A8
 dw #CBD7
 dw #CC9C
 dw #CCA8
 dw #D375
 dw #D3D7
 dw #D49C
 dw #D4A8
 dw #DB75
 dw #DBD7
 dw #DBE3
 dw #DC9C
 dw #DCA8
 dw #DD61
 dw #E375
 dw #E3D7
 dw #E3E3
 dw #E49C
 dw #E4A8
 dw #E62E
 dw #EB75
 dw #EC9C
 dw #ECA8
 dw #EDCE
 dw #F375
 dw #F4A8
 dw #FB75
 db #01 : db 7
 dw #C626
 dw #DC3A
 dw #E43A
 dw #F4FF
 dw #F5C4
 dw #FCFF
 dw #FDC4
 db #03 : db 5
 dw #DCFF
 dw #DDC4
 dw #EE27
 dw #F3D8
 dw #FBD8
 db #07 : db 9
 dw #C3D8
 dw #CB76
 dw #CBD8
 dw #D376
 dw #D3D8
 dw #E627
 dw #EC9D
 dw #F376
 dw #F49D
 db #0F : db 10
 dw #C49F
 dw #C562
 dw #C567
 dw #C627
 dw #CB7E
 dw #CE27
 dw #D627
 dw #EC3C
 dw #FC3D
 dw #FD00
 db #11 : db 7
 dw #CD61
 dw #CE26
 dw #EC3A
 dw #F314
 dw #F43A
 dw #F627
 dw #FC3A
 db #12 : db 1
 dw #D4FF
 db #1E : db 3
 dw #E500
 dw #ED00
 dw #F500
 db #1F : db 3
 dw #CD07
 dw #ED68
 dw #EE29
 db #23 : db 8
 dw #C43A
 dw #CC3A
 dw #D43A
 dw #E4FF
 dw #E5C4
 dw #ECFF
 dw #EDC4
 dw #FB14
 db #2F : db 2
 dw #C3E0
 dw #F628
 db #3C : db 3
 dw #CD00
 dw #D500
 dw #DD00
 db #47 : db 7
 dw #C376
 dw #CCFF
 dw #D5C4
 dw #DBD8
 dw #E3D8
 dw #EBD8
 dw #FC9D
 db #4B : db 3
 dw #D49F
 dw #E43C
 dw #F501
 db #4C : db 1
 dw #EB1D
 db #55 : db 1
 dw #C68B
 db #56 : db 1
 dw #C4FF
 db #5F : db 3
 dw #CB7F
 dw #DCA6
 dw #EDCA
 db #67 : db 2
 dw #E315
 dw #FE28
 db #69 : db 1
 dw #FC3C
 db #78 : db 5
 dw #C500
 dw #DC9E
 dw #EC9E
 dw #F49E
 dw #FC9E
 db #7F : db 3
 dw #CD08
 dw #DC44
 dw #FCA6
 db #87 : db 3
 dw #DC9F
 dw #EC9F
 dw #ED01
 db #88 : db 16
 dw #C50A
 dw #CD0A
 dw #CDCE
 dw #D380
 dw #D50A
 dw #D5CE
 dw #DB1D
 dw #DD0A
 dw #DDCE
 dw #E31D
 dw #E50A
 dw #E5CE
 dw #ED0A
 dw #F3E3
 dw #FBE3
 dw #FCA8
 db #8C : db 2
 dw #D445
 dw #E445
 db #8F : db 9
 dw #D49D
 dw #DB76
 dw #DC9D
 dw #DE27
 dw #E376
 dw #E49D
 dw #E562
 dw #EB76
 dw #FB76
 db #AE : db 3
 dw #D31C
 dw #F31D
 dw #F445
 db #AF : db 1
 dw #E629
 db #BF : db 5
 dw #C31B
 dw #C4A7
 dw #D3E2
 dw #D4A7
 dw #F5CD
 db #C3 : db 7
 dw #C501
 dw #CD01
 dw #D501
 dw #DD01
 dw #E501
 dw #F49F
 dw #FC9F
 db #CC : db 16
 dw #C445
 dw #C56C
 dw #C5CE
 dw #C62F
 dw #CB1C
 dw #CC45
 dw #CD6C
 dw #D56C
 dw #DC45
 dw #DD6C
 dw #E56C
 dw #ED6C
 dw #F50A
 dw #F56C
 dw #FD0A
 dw #FD6C
 db #EE : db 3
 dw #EC45
 dw #FC45
 dw #FDCD
 db #F0 : db 1
 dw #CC9E
; Taille bloc delta = 428 octets
 DW #0000

; Delta frame 19 -> frame 20
Delta_19_20:
 db #00 : db 36
 dw #C43A
 dw #C50A
 dw #C56C
 dw #C5CE
 dw #CB16
 dw #CC3A
 dw #CD0A
 dw #CD6C
 dw #CDCE
 dw #D43A
 dw #D50A
 dw #D561
 dw #D56C
 dw #D5CE
 dw #DC3A
 dw #DD0A
 dw #DD6C
 dw #DDCE
 dw #E43A
 dw #E50A
 dw #E56C
 dw #E5CE
 dw #EBE3
 dw #EC3A
 dw #ED0A
 dw #ED6C
 dw #F314
 dw #F3E3
 dw #F43A
 dw #F50A
 dw #F56C
 dw #FBD8
 dw #FC3A
 dw #FCA8
 dw #FD0A
 dw #FD6C
 db #01 : db 8
 dw #C376
 dw #C3D8
 dw #CBD8
 dw #D3D8
 dw #D4FF
 dw #E4FF
 dw #ECFF
 dw #FB14
 db #03 : db 9
 dw #C626
 dw #CB76
 dw #CE26
 dw #D376
 dw #DB76
 dw #EC9D
 dw #F49D
 dw #FC9D
 dw #FDC4
 db #07 : db 7
 dw #C49D
 dw #CDC4
 dw #D5C4
 dw #DDC4
 dw #EB15
 dw #F43B
 dw #FC3B
 db #0F : db 8
 dw #CB1B
 dw #CC9F
 dw #DE27
 dw #E43C
 dw #E562
 dw #E627
 dw #ED62
 dw #F501
 db #11 : db 7
 dw #C561
 dw #DBD8
 dw #E3D8
 dw #E626
 dw #EBD8
 dw #F3D8
 dw #FCFF
 db #23 : db 11
 dw #C4FF
 dw #CCFF
 dw #D626
 dw #DCFF
 dw #DE26
 dw #E315
 dw #E376
 dw #EB76
 dw #F376
 dw #F627
 dw #FB76
 db #2D : db 1
 dw #FD00
 db #2F : db 3
 dw #C4A4
 dw #C567
 dw #C629
 db #3C : db 1
 dw #ED00
 db #47 : db 6
 dw #CC9D
 dw #DC9D
 dw #E49D
 dw #E5C4
 dw #EDC4
 dw #F5C4
 db #4B : db 3
 dw #E49F
 dw #E501
 dw #F43C
 db #56 : db 1
 dw #D49D
 db #5F : db 2
 dw #CD07
 dw #FCA5
 db #6E : db 3
 dw #CB1C
 dw #CBE2
 dw #EB1D
 db #78 : db 4
 dw #D500
 dw #DD00
 dw #E500
 dw #F500
 db #7F : db 7
 dw #CCA6
 dw #DCA6
 dw #EC44
 dw #ECA6
 dw #EDCA
 dw #FB1D
 dw #FC44
 db #87 : db 1
 dw #DD01
 db #88 : db 6
 dw #C445
 dw #C62F
 dw #CB80
 dw #CC45
 dw #D445
 dw #DC45
 db #8C : db 4
 dw #C4A7
 dw #D4A7
 dw #E31D
 dw #F5CD
 db #8F : db 7
 dw #D43B
 dw #DC3B
 dw #E43B
 dw #EC3B
 dw #EE27
 dw #F562
 dw #FD62
 db #AE : db 4
 dw #C509
 dw #E4A7
 dw #E5CD
 dw #F4A7
 db #AF : db 2
 dw #C37F
 dw #F628
 db #BF : db 10
 dw #C56B
 dw #C5CD
 dw #D31C
 dw #D509
 dw #D56B
 dw #D5CD
 dw #E509
 dw #F31D
 dw #F509
 dw #F56B
 db #CC : db 7
 dw #DB80
 dw #DE2E
 dw #E445
 dw #EC45
 dw #F445
 dw #FC45
 dw #FDCD
 db #D2 : db 1
 dw #C49E
 db #DF : db 1
 dw #FE28
 db #E1 : db 2
 dw #CC9E
 dw #FC3C
 db #EE : db 6
 dw #CCA7
 dw #CD09
 dw #DCA7
 dw #ECA7
 dw #EDCD
 dw #FCA7
 db #F0 : db 8
 dw #C500
 dw #CD00
 dw #D49E
 dw #DC9E
 dw #E49E
 dw #EC9E
 dw #F49E
 dw #FC9E
 db #FF : db 3
 dw #ED08
 dw #EE2B
 dw #FD08
; Taille bloc delta = 422 octets
 DW #0000

; Delta frame 20 -> frame 21
Delta_20_21:
 db #00 : db 6
 dw #C445
 dw #C62F
 dw #CE2F
 dw #DB15
 dw #FB14
 dw #FBE3
 db #01 : db 5
 dw #C5C3
 dw #CDC3
 dw #D5C3
 dw #DDC3
 dw #E5C3
 db #03 : db 5
 dw #C561
 dw #CD61
 dw #D561
 dw #DD61
 dw #FCFF
 db #07 : db 1
 dw #F315
 db #0F : db 25
 dw #C3E0
 dw #C567
 dw #C5C4
 dw #C626
 dw #CDC4
 dw #CE26
 dw #D31B
 dw #D43B
 dw #D49F
 dw #D5C4
 dw #DC3B
 dw #DDC4
 dw #E49F
 dw #E501
 dw #E5C4
 dw #EC3B
 dw #ED01
 dw #EDC4
 dw #EE27
 dw #F43C
 dw #F562
 dw #F5C4
 dw #FC3C
 dw #FD62
 dw #FDC4
 db #11 : db 15
 dw #C376
 dw #C3D8
 dw #CB76
 dw #CBD8
 dw #D376
 dw #D3D8
 dw #DB76
 dw #E376
 dw #EB76
 dw #EDC3
 dw #EE26
 dw #F376
 dw #F5C3
 dw #FB76
 dw #FDC3
 db #16 : db 7
 dw #C4FF
 dw #CCFF
 dw #D4FF
 dw #E49D
 dw #EC9D
 dw #F49D
 dw #FC9D
 db #1F : db 3
 dw #DB1C
 dw #FD06
 dw #FDC8
 db #23 : db 5
 dw #E561
 dw #E626
 dw #ED61
 dw #F561
 dw #FD61
 db #2F : db 5
 dw #D3E0
 dw #D442
 dw #E628
 dw #F31C
 dw #F442
 db #3F : db 1
 dw #C31B
 db #47 : db 4
 dw #DE26
 dw #EB15
 dw #ECFF
 dw #F4FF
 db #4B : db 2
 dw #C501
 dw #C562
 db #4C : db 1
 dw #DB1D
 db #56 : db 2
 dw #DCFF
 dw #E4FF
 db #5A : db 2
 dw #C49E
 dw #F500
 db #5F : db 13
 dw #CBE1
 dw #CCA5
 dw #DBE1
 dw #DC43
 dw #DCA5
 dw #DE2B
 dw #EB1D
 dw #ECA5
 dw #ED68
 dw #EDCA
 dw #FB1D
 dw #FBE1
 dw #FC43
 db #67 : db 2
 dw #D316
 dw #F627
 db #77 : db 1
 dw #C68B
 db #7F : db 3
 dw #DD69
 dw #ED69
 dw #FD08
 db #87 : db 2
 dw #CD01
 dw #FC9F
 db #88 : db 11
 dw #CCA7
 dw #D31D
 dw #E445
 dw #EC45
 dw #EDCD
 dw #F445
 dw #F5CD
 dw #FAB9
 dw #FB1E
 dw #FC45
 dw #FDCD
 db #8C : db 10
 dw #C56B
 dw #C5CD
 dw #D380
 dw #D509
 dw #D56B
 dw #E380
 dw #E509
 dw #E56B
 dw #F509
 dw #F56B
 db #8F : db 2
 dw #D626
 dw #FC3B
 db #9E : db 5
 dw #C49D
 dw #CC9D
 dw #D49D
 dw #DC9D
 dw #F43B
 db #A5 : db 1
 dw #FD00
 db #AE : db 3
 dw #D62E
 dw #E31D
 dw #F380
 db #AF : db 4
 dw #D31C
 dw #D506
 dw #D629
 dw #F31D
 db #BF : db 2
 dw #E3E2
 dw #E62D
 db #CC : db 22
 dw #C380
 dw #C4A7
 dw #C509
 dw #CB80
 dw #CD09
 dw #CD6B
 dw #CDCD
 dw #D4A7
 dw #D5CD
 dw #DCA7
 dw #DD09
 dw #DD6B
 dw #DDCD
 dw #E4A7
 dw #E5CD
 dw #ECA7
 dw #ED09
 dw #ED6B
 dw #F4A7
 dw #FCA7
 dw #FD09
 dw #FD6B
 db #DD : db 1
 dw #C68C
 db #EE : db 1
 dw #EB80
 db #F0 : db 4
 dw #D500
 dw #DD00
 dw #E500
 dw #ED00
 db #FF : db 4
 dw #CCA6
 dw #CDCB
 dw #DCA6
 dw #FAB8
; Taille bloc delta = 430 octets
 DW #0000

; Delta frame 21 -> frame 22
Delta_21_22:
 db #00 : db 35
 dw #C376
 dw #C3D8
 dw #C4A7
 dw #C56B
 dw #C5CD
 dw #CB76
 dw #CBD8
 dw #CC45
 dw #CDCD
 dw #D376
 dw #D3D8
 dw #D445
 dw #D56B
 dw #D5CD
 dw #DB76
 dw #DBD8
 dw #DDCD
 dw #E376
 dw #E3D8
 dw #E445
 dw #E56B
 dw #E5CD
 dw #EB76
 dw #EBD8
 dw #ED6B
 dw #EDCD
 dw #F376
 dw #F3D8
 dw #F445
 dw #F56B
 dw #F5CD
 dw #FAB9
 dw #FB76
 dw #FD6B
 dw #FDCD
 db #01 : db 1
 dw #D625
 db #03 : db 3
 dw #C625
 dw #F315
 dw #FDC3
 db #07 : db 9
 dw #C377
 dw #C5C3
 dw #CB77
 dw #CDC3
 dw #D377
 dw #D5C3
 dw #DDC3
 dw #E5C3
 dw #E626
 db #0F : db 17
 dw #C501
 dw #CC9D
 dw #CD01
 dw #D501
 dw #D626
 dw #DC9F
 dw #DD01
 dw #DE26
 dw #E43B
 dw #EB1C
 dw #EC9F
 dw #F43B
 dw #F49F
 dw #FB1C
 dw #FC3B
 dw #FC9F
 dw #FCFF
 db #11 : db 8
 dw #C43A
 dw #C49C
 dw #D43A
 dw #D49C
 dw #E315
 dw #E43A
 dw #F43A
 dw #FE27
 db #1E : db 2
 dw #C49D
 dw #D49D
 db #1F : db 5
 dw #CBE1
 dw #DBE1
 dw #DC43
 dw #ED06
 dw #FBE1
 db #23 : db 4
 dw #CE25
 dw #D316
 dw #EB15
 dw #EE26
 db #27 : db 1
 dw #F627
 db #2F : db 5
 dw #C3E0
 dw #C442
 dw #C567
 dw #E442
 dw #F3E0
 db #3C : db 8
 dw #CCFF
 dw #D4FF
 dw #DC9D
 dw #DCFF
 dw #E4FF
 dw #EC9D
 dw #ECFF
 dw #FC9D
 db #47 : db 3
 dw #EDC3
 dw #F5C3
 dw #FB15
 db #4B : db 1
 dw #C49E
 db #55 : db 1
 dw #C68B
 db #5F : db 1
 dw #EE29
 db #6E : db 3
 dw #DB1D
 dw #DB80
 dw #EB80
 db #78 : db 3
 dw #C4FF
 dw #E49D
 dw #F49D
 db #7F : db 8
 dw #CB1C
 dw #CBE2
 dw #CCA6
 dw #DCA6
 dw #DE2B
 dw #EB1D
 dw #EDCA
 dw #FB80
 db #88 : db 19
 dw #C31C
 dw #C509
 dw #CD09
 dw #CD6B
 dw #D4A7
 dw #D509
 dw #DCA7
 dw #DD09
 dw #DD6B
 dw #DE2E
 dw #E4A7
 dw #E509
 dw #EB1E
 dw #ECA7
 dw #ED09
 dw #F4A7
 dw #F509
 dw #FCA7
 dw #FD09
 db #8C : db 1
 dw #C380
 db #8F : db 12
 dw #CD61
 dw #D561
 dw #DB16
 dw #DB77
 dw #DD61
 dw #E377
 dw #E561
 dw #EB77
 dw #ED61
 dw #F377
 dw #F561
 dw #FD61
 db #9E : db 2
 dw #C561
 dw #F4FF
 db #AE : db 3
 dw #C62E
 dw #D380
 dw #E380
 db #AF : db 3
 dw #E31D
 dw #E3E2
 dw #E5C8
 db #BF : db 4
 dw #C3E2
 dw #E5CC
 dw #F380
 dw #F5CC
 db #CC : db 6
 dw #CE2E
 dw #D31D
 dw #D62E
 dw #EE2D
 dw #F31E
 dw #FB1E
 db #E1 : db 2
 dw #DC9E
 dw #ED00
 db #EE : db 2
 dw #CB80
 dw #FDCC
 db #FF : db 6
 dw #CD08
 dw #DD08
 dw #ECA6
 dw #FCA6
 dw #FD08
 dw #FD69
; Taille bloc delta = 418 octets
 DW #0000

; Delta frame 22 -> frame 23
Delta_22_23:
 db #00 : db 23
 dw #C509
 dw #CCA7
 dw #CD09
 dw #CD6B
 dw #D4A7
 dw #D509
 dw #D62E
 dw #DC45
 dw #DCA7
 dw #DD09
 dw #DD6B
 dw #DE2E
 dw #E315
 dw #E4A7
 dw #E509
 dw #EC45
 dw #ECA7
 dw #ED09
 dw #F4A7
 dw #F509
 dw #FC45
 dw #FCA7
 dw #FD09
 db #01 : db 27
 dw #C49C
 dw #C4FE
 dw #C560
 dw #C5C2
 dw #CC9C
 dw #CCFE
 dw #CDC2
 dw #D316
 dw #D49C
 dw #D4FE
 dw #D560
 dw #D5C2
 dw #DC9C
 dw #DCFE
 dw #DE25
 dw #E49C
 dw #E4FE
 dw #E560
 dw #EC9C
 dw #ED60
 dw #F315
 dw #F43A
 dw #F49C
 dw #F4FE
 dw #F560
 dw #FC9C
 dw #FD60
 db #03 : db 2
 dw #CB77
 dw #D625
 db #07 : db 4
 dw #C3D9
 dw #CE25
 dw #F377
 dw #FB77
 db #0F : db 17
 dw #C5C3
 dw #CD61
 dw #CDC3
 dw #D3E0
 dw #D561
 dw #D5C3
 dw #DD61
 dw #DDC3
 dw #E561
 dw #E5C3
 dw #ED61
 dw #EDC3
 dw #F3E0
 dw #F561
 dw #F5C3
 dw #FD61
 dw #FDC3
 db #11 : db 10
 dw #C68A
 dw #DC3A
 dw #DDC2
 dw #E5C2
 dw #EB15
 dw #EC3A
 dw #EDC2
 dw #F5C2
 dw #F626
 dw #FC3A
 db #1E : db 1
 dw #C561
 db #1F : db 3
 dw #DD06
 dw #EB7F
 dw #FB7F
 db #23 : db 6
 dw #C377
 dw #CD60
 dw #DD60
 dw #ECFE
 dw #FB15
 dw #FCFE
 db #2D : db 1
 dw #CC9D
 db #33 : db 1
 dw #FE27
 db #3C : db 1
 dw #FCFF
 db #3F : db 1
 dw #CB1C
 db #47 : db 6
 dw #D377
 dw #DB16
 dw #DB77
 dw #E377
 dw #EB77
 dw #EE26
 db #5A : db 1
 dw #D49D
 db #5F : db 5
 dw #DB1D
 dw #DC43
 dw #DD68
 dw #EB1D
 dw #EC43
 db #77 : db 1
 dw #C68B
 db #78 : db 7
 dw #CCFF
 dw #D4FF
 dw #DCFF
 dw #E4FF
 dw #EC9D
 dw #F4FF
 dw #FC9D
 db #7F : db 7
 dw #CD69
 dw #DB80
 dw #DDCA
 dw #EB80
 dw #EE2B
 dw #FD07
 dw #FD69
 db #87 : db 4
 dw #CC9E
 dw #CD01
 dw #FC9F
 dw #FD00
 db #88 : db 8
 dw #C62E
 dw #CBE3
 dw #CE2E
 dw #DBE3
 dw #E31E
 dw #EE2D
 dw #FAB9
 dw #FDCC
 db #8C : db 4
 dw #C5CC
 dw #D5CC
 dw #E62D
 dw #F56A
 db #8F : db 7
 dw #C625
 dw #CBD9
 dw #D3D9
 dw #DBD9
 dw #E316
 dw #E3D9
 dw #E626
 db #AE : db 6
 dw #C56A
 dw #D56A
 dw #E508
 dw #E56A
 dw #F31E
 dw #F508
 db #AF : db 7
 dw #C3E2
 dw #C506
 dw #D380
 dw #D3E2
 dw #E380
 dw #F380
 dw #F627
 db #BF : db 6
 dw #C380
 dw #C508
 dw #D4A6
 dw #D508
 dw #E4A6
 dw #F4A6
 db #C3 : db 2
 dw #D49E
 dw #F500
 db #CC : db 7
 dw #C31C
 dw #CDCC
 dw #DDCC
 dw #E5CC
 dw #EB1E
 dw #EDCC
 dw #F5CC
 db #CF : db 1
 dw #CB17
 db #D2 : db 1
 dw #E500
 db #E1 : db 3
 dw #DD00
 dw #EC9E
 dw #FC9E
 db #EE : db 8
 dw #CD6A
 dw #DD08
 dw #DD6A
 dw #ED08
 dw #ED6A
 dw #FB1E
 dw #FD08
 dw #FD6A
 db #FF : db 3
 dw #CB80
 dw #FDCA
 dw #FE2A
; Taille bloc delta = 450 octets
 DW #0000

; Delta frame 23 -> frame 24
Delta_23_24:
 db #00 : db 15
 dw #C5CC
 dw #C62E
 dw #CDCC
 dw #CE2E
 dw #D5CC
 dw #DDCC
 dw #E5CC
 dw #EB15
 dw #EDCC
 dw #EE2D
 dw #F315
 dw #F5CC
 dw #FB15
 dw #FDCC
 dw #FE2C
 db #01 : db 5
 dw #C624
 dw #CB77
 dw #D377
 dw #E43A
 dw #EC3A
 db #03 : db 8
 dw #DE25
 dw #E49C
 dw #EB77
 dw #EC9C
 dw #EDC2
 dw #F49C
 dw #F5C2
 dw #FC9C
 db #07 : db 16
 dw #C560
 dw #C5C2
 dw #CBD9
 dw #CD60
 dw #CDC2
 dw #D3D9
 dw #D560
 dw #D5C2
 dw #D625
 dw #DD60
 dw #E560
 dw #EB16
 dw #ED60
 dw #F4FE
 dw #F560
 dw #FD60
 db #0F : db 7
 dw #C3E0
 dw #C562
 dw #C625
 dw #CD01
 dw #CE25
 dw #F37E
 dw #FC9F
 db #11 : db 5
 dw #C377
 dw #CC3A
 dw #D316
 dw #E625
 dw #FE27
 db #1F : db 6
 dw #CB1C
 dw #CB7F
 dw #CD06
 dw #DB7F
 dw #FCA4
 dw #FD67
 db #23 : db 9
 dw #C49C
 dw #CC9C
 dw #D49C
 dw #DB16
 dw #DB77
 dw #DC9C
 dw #E377
 dw #FC3A
 dw #FDC2
 db #2F : db 3
 dw #E31C
 dw #F3E0
 dw #F505
 db #3C : db 1
 dw #CC9D
 db #47 : db 11
 dw #CB17
 dw #CCFE
 dw #DCFE
 dw #DDC2
 dw #E316
 dw #E4FE
 dw #E5C2
 dw #ECFE
 dw #F377
 dw #FB77
 dw #FCFE
 db #4B : db 2
 dw #D49E
 dw #F500
 db #55 : db 1
 dw #C68C
 db #56 : db 2
 dw #C4FE
 dw #D4FE
 db #5A : db 1
 dw #C561
 db #5F : db 4
 dw #CC43
 dw #CD68
 dw #CE2A
 dw #DDC9
 db #69 : db 1
 dw #FCFF
 db #6E : db 1
 dw #EB1E
 db #7F : db 4
 dw #CE2B
 dw #DB1D
 dw #ED07
 dw #FB1E
 db #88 : db 19
 dw #C31C
 dw #C381
 dw #C3E3
 dw #CB81
 dw #CC45
 dw #D3E3
 dw #DB1E
 dw #DD6A
 dw #E3E3
 dw #E56A
 dw #E62D
 dw #EBE3
 dw #ED6A
 dw #F3E3
 dw #F56A
 dw #FB1F
 dw #FB81
 dw #FBE3
 dw #FD6A
 db #8C : db 3
 dw #D508
 dw #D62D
 dw #E508
 db #8F : db 2
 dw #EBD9
 dw #F316
 db #AE : db 4
 dw #C508
 dw #C62D
 dw #E4A6
 dw #F4A6
 db #AF : db 4
 dw #C380
 dw #E567
 dw #E628
 dw #F4A4
 db #BF : db 5
 dw #C4A6
 dw #E5CB
 dw #F31E
 dw #F444
 dw #F5CB
 db #CC : db 15
 dw #C56A
 dw #CD6A
 dw #D381
 dw #D56A
 dw #DB81
 dw #DD08
 dw #DE2D
 dw #E31E
 dw #E381
 dw #EB81
 dw #ED08
 dw #F381
 dw #F508
 dw #F62C
 dw #FD08
 db #D2 : db 1
 dw #E49E
 db #EE : db 6
 dw #CD08
 dw #CE2D
 dw #DCA6
 dw #ECA6
 dw #FCA6
 dw #FDCB
 db #F0 : db 6
 dw #CCFF
 dw #DCFF
 dw #EC9D
 dw #ECFF
 dw #FC9D
 dw #FC9E
 db #FF : db 7
 dw #CCA6
 dw #DB80
 dw #DD69
 dw #ED69
 dw #EE2B
 dw #FC44
 dw #FD69
; Taille bloc delta = 410 octets
 DW #0000

; Delta frame 24 -> frame 25
Delta_24_25:
 db #00 : db 17
 dw #C317
 dw #C377
 dw #C56A
 dw #CB77
 dw #CD6A
 dw #D316
 dw #D377
 dw #D56A
 dw #DB16
 dw #DD6A
 dw #DE2D
 dw #E56A
 dw #E62D
 dw #ED6A
 dw #F56A
 dw #FAB9
 dw #FD6A
 db #01 : db 5
 dw #D43A
 dw #DC3A
 dw #E316
 dw #E377
 dw #EB77
 db #03 : db 6
 dw #C3D9
 dw #C49C
 dw #CC9C
 dw #EB16
 dw #FB77
 dw #FC3A
 db #07 : db 9
 dw #C378
 dw #D317
 dw #DBD9
 dw #E3D9
 dw #E49C
 dw #EC9C
 dw #F5C2
 dw #FB16
 dw #FC9C
 db #0F : db 20
 dw #C49E
 dw #C560
 dw #C5C2
 dw #CD60
 dw #CDC2
 dw #D560
 dw #D5C2
 dw #DB1C
 dw #DD60
 dw #DDC2
 dw #E37E
 dw #E560
 dw #E5C2
 dw #E626
 dw #ECFE
 dw #ED60
 dw #F3E0
 dw #F560
 dw #FCFE
 dw #FD60
 db #11 : db 13
 dw #C55F
 dw #C5C1
 dw #CD5F
 dw #CDC1
 dw #CE24
 dw #D55F
 dw #D5C1
 dw #DB77
 dw #DD5F
 dw #E55F
 dw #ED5F
 dw #F55F
 dw #FD5F
 db #16 : db 2
 dw #C4FE
 dw #F49C
 db #1E : db 1
 dw #F4FE
 db #1F : db 5
 dw #CC43
 dw #DE29
 dw #ECA4
 dw #ED67
 dw #FB1D
 db #23 : db 5
 dw #C624
 dw #CB17
 dw #EC3A
 dw #F377
 dw #F43A
 db #2F : db 3
 dw #C5C8
 dw #E505
 dw #E628
 db #33 : db 1
 dw #FE27
 db #47 : db 6
 dw #CBD9
 dw #D49C
 dw #DC9C
 dw #DE25
 dw #F316
 dw #FDC2
 db #55 : db 1
 dw #C68B
 db #5A : db 1
 dw #D49E
 db #5F : db 4
 dw #CE2B
 dw #DB1D
 dw #ED06
 dw #FD06
 db #78 : db 2
 dw #D49D
 dw #DC9D
 db #7F : db 7
 dw #CB80
 dw #CD07
 dw #CDCA
 dw #DB80
 dw #DD07
 dw #EB1E
 dw #FD68
 db #87 : db 1
 dw #ED00
 db #88 : db 14
 dw #C445
 dw #C62D
 dw #CB1D
 dw #CE2D
 dw #D445
 dw #D62D
 dw #DC45
 dw #DD08
 dw #E508
 dw #ED08
 dw #F508
 dw #F62C
 dw #FD08
 dw #FDCB
 db #8C : db 5
 dw #C381
 dw #C3E3
 dw #D3E3
 dw #D5CB
 dw #F4A6
 db #8F : db 3
 dw #D625
 dw #EDC2
 dw #F3D9
 db #9E : db 4
 dw #CCFE
 dw #D4FE
 dw #DCFE
 dw #E4FE
 db #AE : db 6
 dw #C5CB
 dw #D381
 dw #D4A6
 dw #E381
 dw #F381
 dw #F569
 db #AF : db 1
 dw #F31E
 db #BF : db 3
 dw #D569
 dw #E569
 dw #E62C
 db #C3 : db 1
 dw #E500
 db #CC : db 15
 dw #C31C
 dw #C508
 dw #CBE3
 dw #CD08
 dw #D508
 dw #DBE3
 dw #DDCB
 dw #E3E3
 dw #E5CB
 dw #EBE3
 dw #EDCB
 dw #F3E3
 dw #F5CB
 dw #FB1F
 dw #FCA6
 db #D2 : db 1
 dw #D500
 db #DD : db 1
 dw #C68C
 db #E1 : db 3
 dw #CD00
 dw #FC9E
 dw #FCFF
 db #EE : db 11
 dw #CB81
 dw #CCA6
 dw #CDCB
 dw #D31D
 dw #DB81
 dw #EB81
 dw #ED69
 dw #EE2C
 dw #FB81
 dw #FD69
 dw #FE2B
 db #F0 : db 5
 dw #C4FF
 dw #D4FF
 dw #E4FF
 dw #F49D
 dw #F4FF
 db #FF : db 3
 dw #DDCA
 dw #DE2B
 dw #EDCA
; Taille bloc delta = 440 octets
 DW #0000

; Delta frame 25 -> frame 26
Delta_25_26:
 db #00 : db 14
 dw #C62D
 dw #C68A
 dw #CE2D
 dw #D62D
 dw #DB77
 dw #E316
 dw #E377
 dw #E5CB
 dw #EDCB
 dw #F508
 dw #F5CB
 dw #F62C
 dw #FD08
 dw #FDCB
 db #01 : db 7
 dw #D4FD
 dw #DCFD
 dw #E4FD
 dw #E5C1
 dw #F316
 dw #F377
 dw #FB77
 db #03 : db 10
 dw #C378
 dw #C5C1
 dw #CBD9
 dw #CD5F
 dw #CDC1
 dw #D55F
 dw #DD5F
 dw #ED5F
 dw #F43A
 dw #FD5F
 db #07 : db 3
 dw #D378
 dw #D49C
 dw #FDC2
 db #0F : db 6
 dw #C442
 dw #CC9E
 dw #D37E
 dw #EDC2
 dw #F5C2
 dw #FD00
 db #11 : db 7
 dw #C4FD
 dw #CB17
 dw #CCFD
 dw #EB16
 dw #EB77
 dw #EDC1
 dw #FE27
 db #1E : db 4
 dw #C4FE
 dw #C560
 dw #F49C
 dw #FC9C
 db #1F : db 5
 dw #CD67
 dw #DCA4
 dw #DD67
 dw #DDC8
 dw #EDC8
 db #23 : db 11
 dw #C3D9
 dw #C55F
 dw #CE24
 dw #D317
 dw #D5C1
 dw #DDC1
 dw #E43A
 dw #ECFD
 dw #F4FD
 dw #FB16
 dw #FCFD
 db #2D : db 1
 dw #CC9D
 db #2F : db 2
 dw #F566
 dw #F5C7
 db #33 : db 1
 dw #FAB7
 db #3C : db 4
 dw #CCFE
 dw #D4FE
 dw #DCFE
 dw #ECFE
 db #44 : db 1
 dw #C68C
 db #47 : db 9
 dw #C49C
 dw #C624
 dw #CB78
 dw #CC9C
 dw #D3D9
 dw #DB17
 dw #DBD9
 dw #E55F
 dw #F55F
 db #4B : db 1
 dw #D49E
 db #5F : db 7
 dw #CB80
 dw #CC43
 dw #CDC9
 dw #DB80
 dw #DD06
 dw #EB80
 dw #FD67
 db #67 : db 1
 dw #C318
 db #78 : db 1
 dw #E4FE
 db #7F : db 5
 dw #CE2B
 dw #ED68
 dw #EE2A
 dw #FCA5
 dw #FDC9
 db #88 : db 14
 dw #CDCB
 dw #D508
 dw #D5CB
 dw #DB82
 dw #DDCB
 dw #E382
 dw #E445
 dw #EB82
 dw #EC45
 dw #EE2C
 dw #F31F
 dw #F382
 dw #F445
 dw #FB82
 db #8C : db 3
 dw #C445
 dw #E31E
 dw #F569
 db #8F : db 4
 dw #DB78
 dw #DC9C
 dw #E317
 dw #EC9C
 db #9E : db 1
 dw #E49C
 db #AE : db 8
 dw #C381
 dw #C62C
 dw #D31D
 dw #D569
 dw #D62C
 dw #E3E3
 dw #E569
 dw #F3E3
 db #AF : db 9
 dw #C3E3
 dw #C4A6
 dw #D381
 dw #D567
 dw #E381
 dw #E4A4
 dw #E628
 dw #F381
 dw #F444
 db #BF : db 5
 dw #C569
 dw #D3E3
 dw #D4A6
 dw #F5CA
 dw #F62B
 db #CC : db 8
 dw #C5CB
 dw #CC45
 dw #D445
 dw #DE2C
 dw #E62C
 dw #ED69
 dw #FD69
 dw #FE2B
 db #D2 : db 2
 dw #C500
 dw #F49E
 db #EE : db 6
 dw #CD69
 dw #CE2C
 dw #DD69
 dw #EBE3
 dw #FBE3
 dw #FDCA
 db #F0 : db 2
 dw #DC9D
 dw #E49D
 db #FF : db 9
 dw #CB81
 dw #CBE3
 dw #CCA6
 dw #DB81
 dw #DBE3
 dw #EB81
 dw #ED07
 dw #FB81
 dw #FD07
; Taille bloc delta = 408 octets
 DW #0000

; Delta frame 26 -> frame 27
Delta_26_27:
 db #00 : db 14
 dw #C5CB
 dw #C68C
 dw #CB17
 dw #CDCB
 dw #D5CB
 dw #DDCB
 dw #DE2C
 dw #E62C
 dw #EB16
 dw #EB77
 dw #EE2C
 dw #F316
 dw #F377
 dw #FE2B
 db #01 : db 4
 dw #C378
 dw #C3D9
 dw #F49B
 dw #FC9B
 db #03 : db 6
 dw #D378
 dw #D4FD
 dw #DBD9
 dw #DCFD
 dw #E5C1
 dw #EC3A
 db #07 : db 8
 dw #C49C
 dw #C55F
 dw #D5C1
 dw #E378
 dw #EB17
 dw #EBD9
 dw #F4FD
 dw #FCFD
 db #0F : db 2
 dw #CC9D
 dw #DC9C
 db #11 : db 7
 dw #C318
 dw #D317
 dw #E49B
 dw #EC9B
 dw #F5C1
 dw #FB16
 dw #FB77
 db #1E : db 1
 dw #E49C
 db #1F : db 4
 dw #CC43
 dw #CDC8
 dw #CE29
 dw #FD05
 db #23 : db 8
 dw #C4FD
 dw #CB78
 dw #CBD9
 dw #CCFD
 dw #D3D9
 dw #DB17
 dw #DC3A
 dw #EDC1
 db #2F : db 1
 dw #D505
 db #33 : db 1
 dw #FE27
 db #3C : db 2
 dw #EC9C
 dw #FC9C
 db #47 : db 8
 dw #CB18
 dw #DB78
 dw #DDC1
 dw #E317
 dw #E4FD
 dw #ECFD
 dw #F43A
 dw #FC3A
 db #4B : db 1
 dw #C49E
 db #5A : db 3
 dw #C49D
 dw #D49D
 dw #F4FE
 db #5F : db 7
 dw #CBE2
 dw #CC44
 dw #ED67
 dw #FB1E
 dw #FB80
 dw #FBE2
 dw #FDC8
 db #78 : db 4
 dw #C4FE
 dw #CCFE
 dw #D4FE
 dw #DCFE
 db #7F : db 6
 dw #CD68
 dw #DD68
 dw #DE2A
 dw #ECA5
 dw #EDC9
 dw #FC44
 db #87 : db 1
 dw #DC9E
 db #88 : db 13
 dw #C4A7
 dw #CB82
 dw #CCA7
 dw #CE2C
 dw #D382
 dw #D62C
 dw #DBE4
 dw #E3E4
 dw #EBE4
 dw #F569
 dw #FAB9
 dw #FC45
 dw #FD69
 db #8C : db 6
 dw #C3E4
 dw #C508
 dw #E382
 dw #E445
 dw #F382
 dw #F5CA
 db #8F : db 15
 dw #C319
 dw #C5C1
 dw #CC9C
 dw #CD5F
 dw #CDC1
 dw #D49C
 dw #D55F
 dw #DD5F
 dw #E55F
 dw #EB78
 dw #ED5F
 dw #F317
 dw #F55F
 dw #FD5F
 dw #FDC2
 db #A5 : db 1
 dw #FCFF
 db #AE : db 3
 dw #D445
 dw #E5CA
 dw #F4A6
 db #AF : db 7
 dw #C567
 dw #C629
 dw #D3E3
 dw #D4A6
 dw #D5C8
 dw #E3E3
 dw #F3E3
 db #BF : db 5
 dw #C381
 dw #C445
 dw #D5CA
 dw #E4A6
 dw #E62B
 db #C3 : db 1
 dw #E49E
 db #CC : db 13
 dw #C62C
 dw #CBE4
 dw #D3E4
 dw #D508
 dw #DB82
 dw #DD69
 dw #E569
 dw #EC45
 dw #F31F
 dw #F445
 dw #F62B
 dw #FB82
 dw #FDCA
 db #D2 : db 1
 dw #E500
 db #EE : db 9
 dw #CC45
 dw #D31D
 dw #DC45
 dw #DDCA
 dw #EB82
 dw #EDCA
 dw #EE2B
 dw #FB1F
 dw #FCA6
 db #FF : db 7
 dw #CDCA
 dw #CE2B
 dw #DCA6
 dw #DD07
 dw #EBE3
 dw #FBE3
 dw #FD68
; Taille bloc delta = 402 octets
 DW #0000

; Delta frame 27 -> frame 28
Delta_27_28:
 db #00 : db 17
 dw #C318
 dw #C378
 dw #C62C
 dw #C68B
 dw #CE2C
 dw #D317
 dw #D62C
 dw #DB17
 dw #F569
 dw #F62B
 dw #FAB7
 dw #FAB8
 dw #FAB9
 dw #FB16
 dw #FB77
 dw #FD69
 dw #FDCA
 db #01 : db 13
 dw #CB18
 dw #CBD9
 dw #D378
 dw #D3D9
 dw #D55E
 dw #DC9B
 dw #DD5E
 dw #E49B
 dw #E55E
 dw #ED5E
 dw #F55E
 dw #F5C1
 dw #FD5E
 db #03 : db 4
 dw #E378
 dw #E43A
 dw #EDC1
 dw #FC9B
 db #07 : db 8
 dw #C624
 dw #CCFD
 dw #D4FD
 dw #DDC1
 dw #F378
 dw #F3D9
 dw #F43A
 dw #FB17
 db #0F : db 19
 dw #C37E
 dw #C49E
 dw #C55F
 dw #C5C1
 dw #CC9C
 dw #CD5F
 dw #CDC1
 dw #D442
 dw #D55F
 dw #DD5F
 dw #E55F
 dw #ECFD
 dw #ED5F
 dw #F4FD
 dw #F500
 dw #F55F
 dw #FCFD
 dw #FD5F
 dw #FDC2
 db #11 : db 11
 dw #C3D9
 dw #C55E
 dw #C5C0
 dw #CB78
 dw #CD5E
 dw #D49B
 dw #D624
 dw #E317
 dw #F4FC
 dw #FCFC
 dw #FE27
 db #1E : db 1
 dw #D49C
 db #1F : db 3
 dw #DC43
 dw #EE28
 dw #FDC7
 db #23 : db 4
 dw #DB78
 dw #EB17
 dw #EC9B
 dw #F49B
 db #2D : db 2
 dw #CC9D
 dw #FCFE
 db #2F : db 3
 dw #D628
 dw #E566
 dw #E5C7
 db #47 : db 8
 dw #C319
 dw #C4FD
 dw #D318
 dw #E3D9
 dw #E5C1
 dw #EB78
 dw #EC3A
 dw #F317
 db #4B : db 1
 dw #C49D
 db #5F : db 7
 dw #CD06
 dw #DBE2
 dw #DC44
 dw #DD67
 dw #DE29
 dw #EBE2
 dw #EDC8
 db #78 : db 4
 dw #ECFE
 dw #F49C
 dw #F4FE
 dw #FC9C
 db #7F : db 8
 dw #CB81
 dw #CDC9
 dw #DDC9
 dw #EE29
 dw #FB81
 dw #FBE2
 dw #FD06
 dw #FE29
 db #87 : db 1
 dw #CC9E
 db #88 : db 9
 dw #CC46
 dw #D446
 dw #D4A7
 dw #DCA7
 dw #EB1F
 dw #ED69
 dw #EDCA
 dw #EE2B
 dw #F5CA
 db #8C : db 3
 dw #C4A7
 dw #D569
 dw #F3E4
 db #8F : db 7
 dw #C379
 dw #C49C
 dw #D5C1
 dw #DB18
 dw #DCFD
 dw #E4FD
 dw #FC3A
 db #AE : db 9
 dw #C508
 dw #C569
 dw #D31D
 dw #D5CA
 dw #D62B
 dw #E31E
 dw #E382
 dw #E3E4
 dw #F445
 db #AF : db 5
 dw #C3E4
 dw #C445
 dw #C5C8
 dw #D445
 dw #E4A6
 db #BF : db 8
 dw #C5CA
 dw #C62B
 dw #D3E4
 dw #E445
 dw #F382
 dw #F4A6
 dw #F507
 dw #F62A
 db #C3 : db 1
 dw #E500
 db #CC : db 9
 dw #C446
 dw #CCA7
 dw #D382
 dw #DDCA
 dw #DE2B
 dw #E5CA
 dw #E62B
 dw #FBE4
 dw #FE2A
 db #D2 : db 1
 dw #F4FF
 db #EE : db 7
 dw #CDCA
 dw #CE2B
 dw #DB82
 dw #DBE4
 dw #EBE4
 dw #EC45
 dw #FC45
 db #F0 : db 2
 dw #CCFE
 dw #DCFE
 db #FF : db 11
 dw #CBE4
 dw #CC45
 dw #DC45
 dw #DD68
 dw #EB82
 dw #ECA6
 dw #ED68
 dw #EDC9
 dw #EE2A
 dw #FB82
 dw #FDC9
; Taille bloc delta = 432 octets
 DW #0000

; Delta frame 28 -> frame 29
Delta_28_29:
 db #00 : db 14
 dw #C3D9
 dw #CB18
 dw #CB78
 dw #D378
 dw #DE2B
 dw #E317
 dw #E5CA
 dw #E62B
 dw #EB17
 dw #ED69
 dw #EDCA
 dw #EE2B
 dw #F5CA
 dw #FE2A
 db #01 : db 5
 dw #CC3A
 dw #CDC0
 dw #D49B
 dw #E378
 dw #E4FC
 db #03 : db 11
 dw #C55E
 dw #CD5E
 dw #DB18
 dw #DC3A
 dw #DD5E
 dw #E3D9
 dw #E49B
 dw #EB78
 dw #ED5E
 dw #F55E
 dw #FCFC
 db #07 : db 7
 dw #CB19
 dw #CB79
 dw #E318
 dw #E5C1
 dw #EC3A
 dw #F49B
 dw #FB78
 db #0F : db 14
 dw #C49C
 dw #C49D
 dw #CBE1
 dw #CC9D
 dw #CC9E
 dw #CCFD
 dw #D5C1
 dw #DBE1
 dw #DCA4
 dw #DCFD
 dw #EB7F
 dw #EBE1
 dw #FB7F
 dw #FC3A
 db #11 : db 10
 dw #C319
 dw #C49B
 dw #CBD9
 dw #CC9B
 dw #D318
 dw #D4FC
 dw #D5C0
 dw #DB78
 dw #DCFC
 dw #F317
 db #1E : db 3
 dw #D4FD
 dw #E4FD
 dw #F4FD
 db #1F : db 3
 dw #CD06
 dw #EC43
 dw #FD66
 db #23 : db 7
 dw #C5C0
 dw #DBD9
 dw #DC9B
 dw #ECFC
 dw #F4FC
 dw #FB17
 dw #FD5E
 db #47 : db 7
 dw #C379
 dw #D55E
 dw #E43A
 dw #E55E
 dw #EBD9
 dw #EC9B
 dw #F378
 db #4B : db 2
 dw #C561
 dw #F500
 db #5A : db 2
 dw #E49C
 dw #F4FE
 db #5F : db 4
 dw #CE29
 dw #DDC8
 dw #ECA5
 dw #FBE2
 db #7F : db 11
 dw #CBE3
 dw #CC44
 dw #CCA6
 dw #DB81
 dw #DBE3
 dw #EB81
 dw #ED06
 dw #ED67
 dw #EDC8
 dw #FD67
 dw #FDC8
 db #87 : db 1
 dw #FCFF
 db #88 : db 16
 dw #C3E5
 dw #CBE5
 dw #CE2B
 dw #D62B
 dw #DBE5
 dw #DD69
 dw #DDCA
 dw #E3E5
 dw #E446
 dw #E4A7
 dw #E569
 dw #EBE5
 dw #EC46
 dw #ECA7
 dw #F383
 dw #FB83
 db #8C : db 4
 dw #C5CA
 dw #D446
 dw #D4A7
 dw #E31E
 db #8F : db 6
 dw #C31A
 dw #C3DA
 dw #D379
 dw #DDC1
 dw #FBD9
 dw #FC9B
 db #9E : db 1
 dw #C4FD
 db #AE : db 3
 dw #C446
 dw #C4A7
 dw #F5C9
 db #AF : db 8
 dw #D3E4
 dw #E3E4
 dw #E445
 dw #F382
 dw #F445
 dw #F4A6
 dw #F505
 dw #F5C7
 db #BF : db 4
 dw #E382
 dw #E62A
 dw #F3E4
 dw #F568
 db #C3 : db 1
 dw #DD00
 db #CC : db 9
 dw #C62B
 dw #CD69
 dw #CDCA
 dw #D3E5
 dw #D569
 dw #D5CA
 dw #DC46
 dw #DCA7
 dw #F62A
 db #D2 : db 1
 dw #E49E
 db #EE : db 8
 dw #CC46
 dw #CCA7
 dw #CD08
 dw #D31D
 dw #EE2A
 dw #FD07
 dw #FD68
 dw #FDC9
 db #F0 : db 2
 dw #ECFE
 dw #FC9C
 db #FF : db 16
 dw #CB81
 dw #CD07
 dw #CD68
 dw #CDC9
 dw #CE2A
 dw #DBE4
 dw #DDC9
 dw #DE2A
 dw #EBE4
 dw #EC45
 dw #FB81
 dw #FBE4
 dw #FC45
 dw #FCA6
 dw #FE28
 dw #FE29
; Taille bloc delta = 418 octets
 DW #0000

; Delta frame 29 -> frame 30
Delta_29_30:
 db #00 : db 18
 dw #C319
 dw #C31C
 dw #C62B
 dw #CBD9
 dw #CE2B
 dw #D318
 dw #D5CA
 dw #D62B
 dw #DB18
 dw #DB78
 dw #DDCA
 dw #E378
 dw #E569
 dw #EE2A
 dw #F317
 dw #F62A
 dw #FB17
 dw #FE27
 db #01 : db 6
 dw #C379
 dw #C49B
 dw #C4FC
 dw #CCFC
 dw #DBD9
 dw #E318
 db #03 : db 4
 dw #DCFC
 dw #EB18
 dw #FB78
 dw #FD5E
 db #07 : db 10
 dw #C3DA
 dw #C55E
 dw #DB79
 dw #E49B
 dw #E55E
 dw #ED5E
 dw #F318
 dw #F4FC
 dw #F55E
 dw #FCFC
 db #0F : db 5
 dw #DB7F
 dw #DDC1
 dw #E442
 dw #FBE1
 dw #FC9B
 db #11 : db 5
 dw #CB19
 dw #D3D9
 dw #EB78
 dw #FC39
 dw #FC9A
 db #1E : db 3
 dw #C49D
 dw #C4FD
 dw #DCFD
 db #1F : db 4
 dw #DE28
 dw #ED66
 dw #EDC7
 dw #FC43
 db #23 : db 7
 dw #CB79
 dw #CC9B
 dw #D43A
 dw #D49B
 dw #D4FC
 dw #E3D9
 dw #F378
 db #2D : db 1
 dw #CC9D
 db #2F : db 5
 dw #C37E
 dw #C628
 dw #D566
 dw #D5C7
 dw #E627
 db #3C : db 1
 dw #DC9C
 db #47 : db 5
 dw #D319
 dw #D379
 dw #DC9B
 dw #E4FC
 dw #ECFC
 db #5A : db 1
 dw #E500
 db #5F : db 7
 dw #CC44
 dw #CD67
 dw #CDC8
 dw #ED67
 dw #EE28
 dw #FC44
 dw #FDC7
 db #67 : db 1
 dw #C31A
 db #7F : db 7
 dw #CD07
 dw #CE29
 dw #DD67
 dw #DE29
 dw #EBE3
 dw #FB81
 dw #FBE3
 db #88 : db 10
 dw #C447
 dw #CC47
 dw #CDCA
 dw #D569
 dw #E62A
 dw #EB83
 dw #F4A7
 dw #FC46
 dw #FDC9
 dw #FE29
 db #8C : db 3
 dw #C3E5
 dw #C569
 dw #D508
 db #8F : db 8
 dw #CBDA
 dw #CD5E
 dw #D55E
 dw #DB19
 dw #DD5E
 dw #E379
 dw #EC9B
 dw #F43A
 db #9E : db 1
 dw #F49B
 db #A5 : db 1
 dw #FCFF
 db #AE : db 10
 dw #D31D
 dw #D3E5
 dw #D4A7
 dw #D62A
 dw #E31E
 dw #E3E5
 dw #E446
 dw #E5C9
 dw #F568
 dw #F629
 db #AF : db 5
 dw #C446
 dw #C4A7
 dw #D628
 dw #F3E4
 dw #F566
 db #BF : db 5
 dw #C508
 dw #C62A
 dw #D446
 dw #D5C9
 dw #E568
 db #C3 : db 1
 dw #E49E
 db #CC : db 12
 dw #C5CA
 dw #DD08
 dw #DE2A
 dw #E4A7
 dw #EC46
 dw #EDC9
 dw #F3E5
 dw #F446
 dw #F5C9
 dw #FB83
 dw #FBE5
 dw #FD68
 db #E1 : db 1
 dw #DD00
 db #EE : db 8
 dw #CBE5
 dw #CE2A
 dw #DBE5
 dw #DC46
 dw #DCA7
 dw #DDC9
 dw #EBE5
 dw #ED68
 db #F0 : db 3
 dw #C4FE
 dw #D4FE
 dw #E4FE
 db #FF : db 6
 dw #C31B
 dw #CC46
 dw #CCA7
 dw #EB81
 dw #EE29
 dw #FDC8
; Taille bloc delta = 392 octets
 DW #0000

; Delta frame 30 -> frame 31
Delta_30_31:
 db #00 : db 23
 dw #C31A
 dw #C379
 dw #C43A
 dw #C5CA
 dw #CB19
 dw #CB1D
 dw #CB79
 dw #CDCA
 dw #D3D9
 dw #D62A
 dw #DD69
 dw #DE2A
 dw #E318
 dw #E62A
 dw #EB18
 dw #EB78
 dw #ED08
 dw #EDC9
 dw #F5C9
 dw #F629
 dw #FDC9
 dw #FE28
 dw #FE29
 db #01 : db 6
 dw #D379
 dw #D5C0
 dw #E3D9
 dw #F318
 dw #F49A
 dw #FC39
 db #03 : db 7
 dw #C3DA
 dw #C4FC
 dw #C5C0
 dw #CC9B
 dw #DB79
 dw #EBD9
 dw #FB18
 db #07 : db 7
 dw #C37A
 dw #CBDA
 dw #D49B
 dw #D4FC
 dw #E319
 dw #E379
 dw #E43A
 db #0F : db 14
 dw #C55E
 dw #C560
 dw #CC43
 dw #CD5E
 dw #D55E
 dw #DD5E
 dw #E55E
 dw #EC9B
 dw #ECA4
 dw #ECFC
 dw #F43A
 dw #F4FC
 dw #F4FD
 dw #FCFC
 db #11 : db 8
 dw #C55D
 dw #CD5D
 dw #D319
 dw #D55D
 dw #DBD9
 dw #EC9A
 dw #F378
 dw #F439
 db #1E : db 2
 dw #CCFD
 dw #F49B
 db #1F : db 3
 dw #CE28
 dw #DDC7
 dw #EE27
 db #23 : db 6
 dw #C49B
 dw #CB1A
 dw #CDC0
 dw #DB19
 dw #FB78
 dw #FC9A
 db #2F : db 3
 dw #C5C7
 dw #E4A4
 dw #F5C6
 db #3C : db 1
 dw #DCFD
 db #3F : db 1
 dw #CB1C
 db #47 : db 3
 dw #CCFC
 dw #DC3A
 dw #FD5E
 db #4B : db 1
 dw #E500
 db #55 : db 1
 dw #C31B
 db #5A : db 1
 dw #E49E
 db #5F : db 6
 dw #DD67
 dw #DE28
 dw #EC44
 dw #EDC7
 dw #FCA5
 dw #FD66
 db #78 : db 3
 dw #E49C
 dw #EC9C
 dw #F4FE
 db #7F : db 6
 dw #CB81
 dw #CD68
 dw #DCA6
 dw #EB81
 dw #EE28
 dw #FC44
 db #88 : db 7
 dw #CCA8
 dw #CD69
 dw #CE2A
 dw #DC47
 dw #E5C9
 dw #FCA7
 dw #FD68
 db #8C : db 2
 dw #D382
 dw #D5C9
 db #8F : db 9
 dw #D31A
 dw #D3DA
 dw #DC9B
 dw #DCFC
 dw #E49B
 dw #E4FC
 dw #EB79
 dw #EC3A
 dw #ED5E
 db #AE : db 5
 dw #C447
 dw #E4A7
 dw #E568
 dw #E629
 dw #F446
 db #AF : db 5
 dw #D446
 dw #D4A7
 dw #E446
 dw #E5C7
 dw #E627
 db #BF : db 5
 dw #D3E5
 dw #E3E5
 dw #F3E5
 dw #F5C8
 dw #F628
 db #C3 : db 2
 dw #EC9E
 dw #F49E
 db #CC : db 10
 dw #C4A8
 dw #C569
 dw #C62A
 dw #D447
 dw #DDC9
 dw #ECA7
 dw #EE29
 dw #F383
 dw #F4A7
 dw #F568
 db #EE : db 6
 dw #CC47
 dw #CDC9
 dw #D31D
 dw #FBE5
 dw #FC46
 dw #FDC8
 db #EF : db 1
 dw #F627
 db #FF : db 7
 dw #DB81
 dw #DBE5
 dw #DC46
 dw #DCA7
 dw #DE29
 dw #EBE5
 dw #EC46
; Taille bloc delta = 384 octets
 DW #0000

; Delta frame 31 -> frame 32
Delta_31_32:
 db #00 : db 20
 dw #C31B
 dw #C62A
 dw #CB1A
 dw #CE2A
 dw #D319
 dw #D379
 dw #D569
 dw #DB19
 dw #DBD9
 dw #DDC9
 dw #E5C9
 dw #E629
 dw #EE29
 dw #F318
 dw #F378
 dw #F568
 dw #F626
 dw #F628
 dw #FB18
 dw #FD68
 db #01 : db 11
 dw #C37A
 dw #C3DA
 dw #C55D
 dw #CD5D
 dw #D31A
 dw #D55D
 dw #E49A
 dw #E4FB
 dw #ECFB
 dw #F439
 dw #F4FB
 db #03 : db 2
 dw #CBDA
 dw #F49A
 db #07 : db 7
 dw #C4FC
 dw #CC9B
 dw #D37A
 dw #D3DA
 dw #F319
 dw #F379
 dw #FD5E
 db #0F : db 12
 dw #C37E
 dw #C49D
 dw #CCFC
 dw #D4FC
 dw #DC9B
 dw #DCFC
 dw #E49B
 dw #E4FC
 dw #EC3A
 dw #ED5E
 dw #F442
 dw #FCFE
 db #11 : db 8
 dw #D4FB
 dw #DB79
 dw #DC9A
 dw #DCFB
 dw #DD5D
 dw #E319
 dw #E55D
 dw #FB78
 db #1E : db 3
 dw #C560
 dw #F4FD
 dw #FC9B
 db #1F : db 6
 dw #CC43
 dw #CCA5
 dw #CDC7
 dw #DB7F
 dw #DE27
 dw #FDC6
 db #23 : db 6
 dw #E379
 dw #EB19
 dw #EBD9
 dw #EC9A
 dw #FC39
 dw #FCFB
 db #2F : db 2
 dw #D31C
 dw #D627
 db #3C : db 1
 dw #CCFD
 db #47 : db 7
 dw #C49B
 dw #C5C0
 dw #CB7A
 dw #DB1A
 dw #EB79
 dw #F3D9
 dw #FC9A
 db #55 : db 1
 dw #F627
 db #5A : db 2
 dw #F4FE
 dw #F4FF
 db #5F : db 5
 dw #CE28
 dw #EB1E
 dw #ED06
 dw #EE27
 dw #FC44
 db #67 : db 1
 dw #EE26
 db #77 : db 1
 dw #CB1B
 db #7F : db 8
 dw #CC45
 dw #DB81
 dw #DC45
 dw #DDC8
 dw #EC45
 dw #ECA6
 dw #ED67
 dw #FDC7
 db #88 : db 11
 dw #C448
 dw #CC48
 dw #D5C9
 dw #DCA8
 dw #DE29
 dw #EBE6
 dw #ED68
 dw #F3E6
 dw #F447
 dw #FBE6
 dw #FDC8
 db #8C : db 4
 dw #E31E
 dw #E447
 dw #E568
 dw #F4A7
 db #8F : db 1
 dw #D49B
 db #AE : db 5
 dw #C3E5
 dw #C4A8
 dw #C5C9
 dw #D508
 dw #E5C8
 db #AF : db 7
 dw #C447
 dw #C508
 dw #C628
 dw #D5C7
 dw #E3E5
 dw #F3E5
 dw #F446
 db #BF : db 5
 dw #C629
 dw #D447
 dw #D568
 dw #E4A7
 dw #E628
 db #C3 : db 2
 dw #E49E
 dw #E500
 db #CC : db 7
 dw #CDC9
 dw #D31D
 dw #D4A8
 dw #D629
 dw #EC47
 dw #F5C8
 dw #FCA7
 db #D2 : db 1
 dw #F49E
 db #E1 : db 1
 dw #EC9E
 db #EE : db 7
 dw #CCA8
 dw #CE29
 dw #DC47
 dw #DD68
 dw #ECA7
 dw #EDC8
 dw #EE28
 db #F0 : db 2
 dw #EC9C
 dw #F49C
 db #FF : db 6
 dw #CB1C
 dw #CB81
 dw #CC47
 dw #CD08
 dw #FBE5
 dw #FC46
; Taille bloc delta = 388 octets
 DW #0000

; Delta frame 32 -> frame 33
Delta_32_33:
 db #00 : db 20
 dw #C37A
 dw #C3DA
 dw #CB1B
 dw #CB1C
 dw #CD69
 dw #D31A
 dw #D5C9
 dw #D629
 dw #DB1A
 dw #DB79
 dw #DE29
 dw #E319
 dw #E379
 dw #EB19
 dw #ED68
 dw #EE28
 dw #F5C8
 dw #F627
 dw #FB78
 dw #FDC8
 db #01 : db 6
 dw #CBDA
 dw #CCFB
 dw #D4FB
 dw #DD5D
 dw #EB79
 dw #EBD9
 db #03 : db 7
 dw #E49A
 dw #E4FB
 dw #ECFB
 dw #F3D9
 dw #F4FB
 dw #FC39
 dw #FCFB
 db #07 : db 6
 dw #C37B
 dw #C49B
 dw #EB1A
 dw #EC9A
 dw #FB79
 dw #FBD9
 db #0F : db 9
 dw #C4FC
 dw #CC43
 dw #CC9B
 dw #CC9D
 dw #D49B
 dw #DC43
 dw #F31C
 dw #F500
 dw #FC9A
 db #11 : db 6
 dw #C4FB
 dw #CB7A
 dw #D49A
 dw #E3D9
 dw #EC39
 dw #F319
 db #1F : db 3
 dw #CE27
 dw #EB1D
 dw #EDC6
 db #23 : db 9
 dw #C55D
 dw #CD5D
 dw #D37A
 dw #DC9A
 dw #DCFB
 dw #E31A
 dw #F379
 dw #F439
 dw #FB19
 db #2D : db 1
 dw #FCFE
 db #2F : db 2
 dw #C627
 dw #E5C6
 db #33 : db 1
 dw #EE26
 db #3C : db 1
 dw #FC9B
 db #47 : db 2
 dw #D3DA
 dw #DB7A
 db #4B : db 1
 dw #E49E
 db #5A : db 1
 dw #C4FD
 db #5F : db 5
 dw #CCA6
 dw #CD07
 dw #DDC7
 dw #DE27
 dw #FDC6
 db #67 : db 1
 dw #D31B
 db #7F : db 5
 dw #CDC8
 dw #CE28
 dw #DD07
 dw #EDC7
 dw #FCA6
 db #87 : db 1
 dw #FCFF
 db #88 : db 13
 dw #C4A9
 dw #C509
 dw #C569
 dw #CDC9
 dw #CE29
 dw #DBE6
 dw #DC48
 dw #E3E6
 dw #E448
 dw #E4A8
 dw #E568
 dw #E628
 dw #EDC8
 db #8F : db 7
 dw #C43B
 dw #DB1B
 dw #DBDA
 dw #E37A
 dw #E43A
 dw #F49A
 dw #F55E
 db #AE : db 6
 dw #D4A8
 dw #D568
 dw #F447
 dw #F4A7
 dw #F507
 dw #F567
 db #AF : db 9
 dw #C4A8
 dw #D3E5
 dw #D447
 dw #D627
 dw #E382
 dw #E447
 dw #E4A7
 dw #E626
 dw #F5C6
 db #BF : db 3
 dw #D5C8
 dw #D628
 dw #F5C7
 db #C3 : db 2
 dw #EC9E
 dw #F49E
 db #CC : db 12
 dw #C448
 dw #C5C9
 dw #C629
 dw #CC48
 dw #D448
 dw #DCA8
 dw #DD68
 dw #E5C8
 dw #F3E6
 dw #FBE6
 dw #FC47
 dw #FD07
 db #D2 : db 1
 dw #F4FF
 db #EE : db 4
 dw #DDC8
 dw #DE28
 dw #FD67
 dw #FDC7
 db #FF : db 6
 dw #CBE5
 dw #CCA8
 dw #DC47
 dw #EC47
 dw #ECA7
 dw #EE27
; Taille bloc delta = 360 octets
 DW #0000

; Delta frame 33 -> frame 34
Delta_33_34:
 db #00 : db 24
 dw #C629
 dw #CB7A
 dw #CBDA
 dw #CDC9
 dw #CE29
 dw #D31B
 dw #D31D
 dw #D37A
 dw #D624
 dw #DB1E
 dw #DE28
 dw #E31A
 dw #E3D9
 dw #E5C8
 dw #E625
 dw #E628
 dw #EB1A
 dw #EB1F
 dw #EB79
 dw #EDC8
 dw #EE26
 dw #EE27
 dw #F319
 dw #FB19
 db #01 : db 3
 dw #D3DA
 dw #EC39
 dw #F499
 db #03 : db 3
 dw #C55D
 dw #CB7B
 dw #CCFB
 db #07 : db 4
 dw #C3DB
 dw #DC3A
 dw #FB1A
 dw #FC39
 db #0F : db 8
 dw #C4A4
 dw #D505
 dw #DB7F
 dw #E31C
 dw #EC9A
 dw #F49A
 dw #F4FD
 dw #FCA4
 db #11 : db 7
 dw #C37B
 dw #CC9A
 dw #D31C
 dw #DB1B
 dw #DB7A
 dw #EBD9
 dw #F379
 db #1E : db 2
 dw #E49B
 dw #EC9B
 db #1F : db 4
 dw #CD67
 dw #DCA5
 dw #DD06
 dw #DE26
 db #23 : db 8
 dw #C4FB
 dw #D49A
 dw #D55D
 dw #E37A
 dw #F31A
 dw #F3D9
 dw #FB79
 dw #FC99
 db #2F : db 3
 dw #D626
 dw #F4A4
 dw #F505
 db #3F : db 1
 dw #DB1D
 db #47 : db 9
 dw #D4FB
 dw #DBDA
 dw #DC9A
 dw #DCFB
 dw #E31B
 dw #E4FB
 dw #ECFB
 dw #F4FB
 dw #FCFB
 db #4B : db 1
 dw #F500
 db #5A : db 2
 dw #D49C
 dw #D4FD
 db #5F : db 3
 dw #DCA6
 dw #DD07
 dw #FD06
 db #6E : db 2
 dw #CE28
 dw #EDC7
 db #78 : db 1
 dw #DC9C
 db #7F : db 4
 dw #CCA7
 dw #CD08
 dw #DE27
 dw #ED07
 db #88 : db 9
 dw #C5C9
 dw #CD69
 dw #D509
 dw #D628
 dw #DCA9
 dw #ED68
 dw #FC48
 dw #FCA8
 dw #FDC7
 db #8C : db 4
 dw #C448
 dw #C569
 dw #D448
 dw #E448
 db #8F : db 7
 dw #C49B
 dw #D37B
 dw #DB1C
 dw #E3DA
 dw #E49A
 dw #EB1B
 dw #EB7A
 db #A5 : db 1
 dw #FCFF
 db #AE : db 2
 dw #D5C8
 dw #E508
 db #AF : db 5
 dw #D4A8
 dw #D508
 dw #F447
 dw #F4A7
 dw #F507
 db #BF : db 7
 dw #C4A9
 dw #C509
 dw #C628
 dw #D568
 dw #E382
 dw #E4A8
 dw #F567
 db #C3 : db 1
 dw #E49E
 db #CC : db 13
 dw #CD09
 dw #D4A9
 dw #DDC8
 dw #E31E
 dw #E568
 dw #E627
 dw #EBE6
 dw #EC48
 dw #ED08
 dw #F448
 dw #F4A8
 dw #F5C7
 dw #FD67
 db #D2 : db 1
 dw #F49E
 db #E1 : db 1
 dw #EC9E
 db #EE : db 5
 dw #CC48
 dw #CCA9
 dw #DC48
 dw #DD68
 dw #ECA8
 db #EF : db 1
 dw #E626
 db #FF : db 6
 dw #DB81
 dw #DCA8
 dw #DD08
 dw #FC47
 dw #FCA7
 dw #FD07
; Taille bloc delta = 370 octets
 DW #0000

; Delta frame 34 -> frame 35
Delta_34_35:
 db #00 : db 19
 dw #C37B
 dw #CB7B
 dw #CE28
 dw #D31C
 dw #D628
 dw #DB1B
 dw #DB1C
 dw #DB1D
 dw #DB7A
 dw #E31B
 dw #E37A
 dw #E626
 dw #E627
 dw #EBD9
 dw #F31A
 dw #F379
 dw #FB1A
 dw #FB79
 dw #FDC7
 db #01 : db 3
 dw #C49A
 dw #D37B
 dw #E499
 db #03 : db 3
 dw #CC9A
 dw #CD5D
 dw #F499
 db #07 : db 10
 dw #C4FB
 dw #CCFB
 dw #D49A
 dw #D4FB
 dw #DCFB
 dw #E3DA
 dw #E4FB
 dw #ECFB
 dw #F439
 dw #F4FB
 db #0F : db 12
 dw #C49B
 dw #C560
 dw #CD06
 dw #D49E
 dw #DC9A
 dw #E43A
 dw #E49A
 dw #EC43
 dw #FB1D
 dw #FC39
 dw #FCFE
 dw #FD05
 db #11 : db 3
 dw #D3DA
 dw #E439
 dw #EB1B
 db #1F : db 2
 dw #ECA5
 dw #FDC5
 db #23 : db 6
 dw #C37C
 dw #C3DB
 dw #DBDA
 dw #EB7A
 dw #EC39
 dw #EC99
 db #2F : db 3
 dw #E31D
 dw #F31D
 dw #F5C5
 db #33 : db 1
 dw #DE25
 db #3C : db 1
 dw #EC9B
 db #47 : db 7
 dw #C55D
 dw #CBDB
 dw #D43A
 dw #DB7B
 dw #F37A
 dw #FBD9
 dw #FC99
 db #5A : db 1
 dw #F49B
 db #5F : db 6
 dw #CBE3
 dw #CE27
 dw #DE26
 dw #ECA6
 dw #ED07
 dw #ED67
 db #67 : db 2
 dw #E31C
 dw #F31B
 db #6E : db 1
 dw #FDC6
 db #7F : db 3
 dw #CB81
 dw #DD68
 dw #FC45
 db #87 : db 2
 dw #CC9D
 dw #FCFF
 db #88 : db 8
 dw #CD0A
 dw #D4AA
 dw #D569
 dw #DDC8
 dw #DE27
 dw #E509
 dw #F5C7
 dw #FD08
 db #8C : db 6
 dw #C4AA
 dw #D5C8
 dw #D627
 dw #E568
 dw #F3E6
 dw #F508
 db #8F : db 5
 dw #CB7C
 dw #D3DB
 dw #DC3A
 dw #E37B
 dw #FB1B
 db #AE : db 4
 dw #D448
 dw #E448
 dw #E4A9
 dw #F448
 db #AF : db 10
 dw #C4A9
 dw #C509
 dw #C627
 dw #D4A9
 dw #D568
 dw #D626
 dw #E4A8
 dw #E508
 dw #E5C6
 dw #F4A8
 db #BF : db 3
 dw #C569
 dw #D509
 dw #E5C7
 db #C3 : db 2
 dw #EC9E
 dw #F49E
 db #CC : db 6
 dw #C50A
 dw #C628
 dw #CCAA
 dw #DD09
 dw #ECA9
 dw #EDC7
 db #EE : db 5
 dw #CD69
 dw #EC48
 dw #FC48
 dw #FCA8
 dw #FD67
 db #F0 : db 1
 dw #DC9C
 db #FF : db 7
 dw #CCA9
 dw #CD08
 dw #CD09
 dw #DCA9
 dw #EC45
 dw #ECA8
 dw #ED08
; Taille bloc delta = 344 octets
 DW #0000

; Delta frame 35 -> frame 36
Delta_35_36:
 db #00 : db 19
 dw #C37C
 dw #C3DB
 dw #C628
 dw #CB7C
 dw #D37B
 dw #D3DA
 dw #D627
 dw #DB7B
 dw #DE25
 dw #DE26
 dw #DE27
 dw #E31C
 dw #E31D
 dw #E31E
 dw #EB1B
 dw #EB1C
 dw #EB7A
 dw #F31B
 dw #F5C7
 db #01 : db 5
 dw #E37B
 dw #E439
 dw #E55D
 dw #F3D9
 dw #FC38
 db #03 : db 2
 dw #FB7A
 dw #FBD9
 db #07 : db 1
 dw #F499
 db #0F : db 7
 dw #CB7F
 dw #CC9D
 dw #D49A
 dw #D4A4
 dw #D566
 dw #E505
 dw #FC43
 db #11 : db 4
 dw #D499
 dw #DBDA
 dw #F37A
 dw #FB1B
 db #1E : db 2
 dw #C560
 dw #F4FD
 db #1F : db 3
 dw #CE26
 dw #EC43
 dw #ED06
 db #23 : db 4
 dw #CBDB
 dw #D37C
 dw #DC99
 dw #E3DA
 db #2D : db 1
 dw #FCFE
 db #2F : db 5
 dw #C37F
 dw #C506
 dw #C626
 dw #D37F
 dw #E37F
 db #47 : db 7
 dw #C49A
 dw #C624
 dw #D3DB
 dw #E499
 dw #EB7B
 dw #EC39
 dw #EC99
 db #4B : db 2
 dw #D49E
 dw #E49E
 db #5A : db 2
 dw #C561
 dw #F4FF
 db #5F : db 7
 dw #CC45
 dw #CD08
 dw #CD68
 dw #EDC6
 dw #FB81
 dw #FCA6
 dw #FDC5
 db #67 : db 3
 dw #C37D
 dw #D625
 dw #F31C
 db #6E : db 3
 dw #EB1E
 dw #FB1F
 dw #FD67
 db #7F : db 6
 dw #CBE3
 dw #DB81
 dw #DCA7
 dw #EC45
 dw #ED08
 dw #FD07
 db #87 : db 1
 dw #EC9E
 db #88 : db 7
 dw #C50B
 dw #CD6A
 dw #DD0A
 dw #ECAA
 dw #EDC7
 dw #F509
 dw #F568
 db #8C : db 1
 dw #D50A
 db #8F : db 12
 dw #C3DC
 dw #C4FB
 dw #CB7D
 dw #CC9A
 dw #CCFB
 dw #D4FB
 dw #DB7C
 dw #DCFB
 dw #EB1D
 dw #EBDA
 dw #F439
 dw #FC99
 db #A5 : db 1
 dw #FCFF
 db #AE : db 4
 dw #C448
 dw #D4AA
 dw #D569
 dw #E5C7
 db #AF : db 6
 dw #C50A
 dw #C569
 dw #D509
 dw #E4A9
 dw #F508
 dw #F567
 db #BF : db 9
 dw #C4AA
 dw #C627
 dw #D626
 dw #E448
 dw #E509
 dw #E568
 dw #F448
 dw #F4A9
 dw #F5C6
 db #CC : db 10
 dw #C56A
 dw #C5C9
 dw #CE27
 dw #DCAA
 dw #DD69
 dw #E4AA
 dw #ED09
 dw #ED68
 dw #FCA9
 dw #FDC6
 db #D2 : db 1
 dw #F49E
 db #EE : db 2
 dw #CCAA
 dw #FD08
 db #F0 : db 1
 dw #E49C
 db #FF : db 8
 dw #CD0A
 dw #CD69
 dw #DC45
 dw #DD09
 dw #EC48
 dw #ECA9
 dw #FC48
 dw #FCA8
; Taille bloc delta = 356 octets
 DW #0000

; Delta frame 36 -> frame 37
Delta_36_37:
 db #00 : db 19
 dw #C37D
 dw #CB7D
 dw #CBDB
 dw #CE27
 dw #D37C
 dw #D625
 dw #D626
 dw #DB7C
 dw #DBDA
 dw #E37B
 dw #EB1D
 dw #EB1E
 dw #EB7B
 dw #F31C
 dw #F31F
 dw #F37A
 dw #FB1B
 dw #FB1C
 dw #FB7A
 db #01 : db 4
 dw #CC99
 dw #D3DB
 dw #F31D
 dw #F438
 db #07 : db 4
 dw #CBDC
 dw #D43A
 dw #DC99
 dw #E499
 db #0F : db 13
 dw #C37F
 dw #CC9A
 dw #CCA5
 dw #CCFB
 dw #CD67
 dw #D49E
 dw #DC3A
 dw #DD06
 dw #EC43
 dw #ED66
 dw #F439
 dw #FC99
 dw #FCFE
 db #11 : db 5
 dw #CE24
 dw #DC39
 dw #E3DA
 dw #E55D
 dw #F3D9
 db #1F : db 5
 dw #CB80
 dw #DD67
 dw #FB1E
 dw #FCA5
 dw #FD66
 db #23 : db 3
 dw #C3DC
 dw #F37B
 dw #FBD9
 db #2F : db 4
 dw #C3E1
 dw #C567
 dw #D4A4
 dw #F37F
 db #47 : db 4
 dw #D499
 dw #DBDB
 dw #EBDA
 dw #FC38
 db #4B : db 1
 dw #C561
 db #5F : db 4
 dw #CDC8
 dw #FBE3
 dw #FD07
 dw #FD67
 db #67 : db 5
 dw #C37E
 dw #C624
 dw #D37D
 dw #E37C
 dw #E439
 db #6E : db 1
 dw #CE26
 db #7F : db 8
 dw #CC45
 dw #CD08
 dw #CD69
 dw #DC45
 dw #DD08
 dw #ECA7
 dw #ED68
 dw #FB81
 db #87 : db 1
 dw #FCFF
 db #88 : db 6
 dw #CDC9
 dw #D56A
 dw #ED0A
 dw #FCAA
 dw #FD68
 dw #FDC6
 db #8C : db 3
 dw #C5C9
 dw #E50A
 dw #F5C6
 db #8F : db 12
 dw #C49A
 dw #CB7E
 dw #DB7D
 dw #E4FB
 dw #EB7C
 dw #EC39
 dw #EC99
 dw #F3DA
 dw #F499
 dw #FB1D
 dw #FB7B
 dw #FDC2
 db #9F : db 1
 dw #CE25
 db #AE : db 2
 dw #D5C8
 dw #E4AA
 db #AF : db 9
 dw #C56A
 dw #C626
 dw #D50A
 dw #D569
 dw #E509
 dw #E568
 dw #F448
 dw #F4A9
 dw #F5C5
 db #BF : db 4
 dw #C50B
 dw #D4AA
 dw #F31E
 dw #F509
 db #C3 : db 3
 dw #E49E
 dw #EC9E
 dw #F49E
 db #CC : db 7
 dw #C627
 dw #D382
 dw #D50B
 dw #E569
 dw #F4AA
 dw #F568
 dw #FD09
 db #D2 : db 1
 dw #F4FF
 db #EE : db 5
 dw #CD0B
 dw #CD6A
 dw #DCAA
 dw #ECAA
 dw #FBE6
 db #FF : db 8
 dw #CCAA
 dw #DC48
 dw #DD0A
 dw #DD69
 dw #ED08
 dw #ED09
 dw #FCA9
 dw #FD08
; Taille bloc delta = 340 octets
 DW #0000

; Delta frame 37 -> frame 38
Delta_37_38:
 db #00 : db 19
 dw #C37E
 dw #C3DC
 dw #C627
 dw #CB7E
 dw #CE24
 dw #CE25
 dw #CE26
 dw #D37D
 dw #D3DB
 dw #DB7D
 dw #E37C
 dw #E3DA
 dw #EB7C
 dw #F31D
 dw #F31E
 dw #F37B
 dw #F3D9
 dw #FB1D
 dw #FDC6
 db #01 : db 3
 dw #C37F
 dw #C624
 dw #E55D
 db #07 : db 6
 dw #C43B
 dw #CC99
 dw #D499
 dw #E439
 dw #F3DA
 dw #F438
 db #0F : db 14
 dw #C49A
 dw #C4FB
 dw #CDC7
 dw #D37F
 dw #D4A4
 dw #D4FB
 dw #E37F
 dw #E499
 dw #EC39
 dw #EC99
 dw #F499
 dw #F4FD
 dw #F505
 dw #FC38
 db #11 : db 8
 dw #CBDC
 dw #CC3A
 dw #DBDB
 dw #EBDA
 dw #F5C1
 dw #FB7B
 dw #FBD9
 dw #FC37
 db #1F : db 6
 dw #CCA5
 dw #DB80
 dw #EB80
 dw #EC43
 dw #FD06
 dw #FDC4
 db #23 : db 4
 dw #C499
 dw #D37E
 dw #DC39
 dw #EC38
 db #2D : db 1
 dw #FCFE
 db #2F : db 3
 dw #C380
 dw #D3E1
 dw #E3E1
 db #47 : db 2
 dw #D3DC
 dw #E3DB
 db #4B : db 1
 dw #E49E
 db #5A : db 3
 dw #C561
 dw #E49B
 dw #F4FF
 db #5F : db 10
 dw #CB81
 dw #CBE3
 dw #CC45
 dw #CD08
 dw #CD69
 dw #DD08
 dw #DD68
 dw #EB81
 dw #EBE3
 dw #ED08
 db #67 : db 3
 dw #C3DD
 dw #E37D
 dw #F37C
 db #6E : db 1
 dw #FDC5
 db #77 : db 1
 dw #FB1E
 db #78 : db 1
 dw #C4FD
 db #7F : db 3
 dw #DD69
 dw #FBE3
 dw #FCA7
 db #87 : db 1
 dw #EC9E
 db #88 : db 3
 dw #CD0C
 dw #FB1F
 dw #FD0A
 db #8F : db 5
 dw #DB7E
 dw #DC99
 dw #EB7D
 dw #ECFB
 dw #FB7C
 db #A5 : db 1
 dw #FCFF
 db #AE : db 2
 dw #F4AA
 dw #F50A
 db #AF : db 9
 dw #C4AA
 dw #C50B
 dw #C625
 dw #D4AA
 dw #D50B
 dw #E50A
 dw #E569
 dw #F509
 dw #F568
 db #BF : db 8
 dw #C56B
 dw #C5C9
 dw #C626
 dw #D448
 dw #D56A
 dw #D5C8
 dw #E4AA
 dw #E5C7
 db #CC : db 6
 dw #C50C
 dw #CD6B
 dw #CDC9
 dw #DDC8
 dw #E50B
 dw #F5C6
 db #CF : db 1
 dw #CB7F
 db #D2 : db 1
 dw #F49E
 db #DF : db 1
 dw #DCA7
 db #E1 : db 1
 dw #DC9D
 db #EE : db 5
 dw #DD0B
 dw #DD6A
 dw #ED69
 dw #FCAA
 dw #FD68
 db #FF : db 7
 dw #CD0B
 dw #CD6A
 dw #DCAA
 dw #ECA7
 dw #ECAA
 dw #ED0A
 dw #FD09
; Taille bloc delta = 346 octets
 DW #0000

; Delta frame 38 -> frame 39
Delta_38_39:
 db #00 : db 11
 dw #C37F
 dw #C380
 dw #C624
 dw #CB7F
 dw #CB82
 dw #CBDC
 dw #D37E
 dw #E37D
 dw #FB1E
 dw #FB1F
 dw #FB7B
 db #07 : db 1
 dw #C499
 db #0F : db 21
 dw #C3E1
 dw #C43B
 dw #C5C7
 dw #D380
 dw #D43A
 dw #D499
 dw #DB80
 dw #DC39
 dw #DC99
 dw #DCFB
 dw #DD67
 dw #E439
 dw #E566
 dw #EC38
 dw #EC43
 dw #ED06
 dw #F37F
 dw #F3DA
 dw #F438
 dw #FCFE
 dw #FD66
 db #11 : db 8
 dw #DB7E
 dw #DC38
 dw #E498
 dw #E55D
 dw #EC37
 dw #F37C
 dw #F3D9
 dw #F498
 db #1E : db 2
 dw #D49B
 dw #F4FD
 db #1F : db 5
 dw #CB81
 dw #CBE2
 dw #CD68
 dw #ED67
 dw #FB80
 db #23 : db 6
 dw #C3DD
 dw #C43A
 dw #EB7D
 dw #EBDA
 dw #EDC1
 dw #F437
 db #2F : db 6
 dw #D4A4
 dw #D506
 dw #D567
 dw #E380
 dw #F3E1
 dw #F566
 db #33 : db 1
 dw #DBDB
 db #44 : db 2
 dw #C381
 dw #C626
 db #47 : db 6
 dw #CB80
 dw #E438
 dw #FB7C
 dw #FBD9
 dw #FC37
 dw #FDC2
 db #5F : db 7
 dw #CDC9
 dw #DB81
 dw #DBE3
 dw #EC45
 dw #ED68
 dw #FB81
 dw #FDC4
 db #67 : db 2
 dw #D37F
 dw #D439
 db #6E : db 1
 dw #DDC8
 db #77 : db 1
 dw #C625
 db #7F : db 5
 dw #DCA7
 dw #ECA7
 dw #ED08
 dw #FD08
 dw #FD68
 db #88 : db 6
 dw #CCAB
 dw #CDCA
 dw #DCAB
 dw #DD0C
 dw #FD0B
 dw #FD69
 db #8C : db 1
 dw #D50C
 db #8F : db 7
 dw #CBDD
 dw #CC3A
 dw #CC99
 dw #E37E
 dw #E3DB
 dw #F37D
 dw #F5C2
 db #AE : db 3
 dw #C50C
 dw #C56C
 dw #C5CA
 db #AF : db 7
 dw #C56B
 dw #C5C9
 dw #D56A
 dw #D5C8
 dw #E4AA
 dw #E50B
 dw #F50A
 db #BF : db 4
 dw #D56B
 dw #E56A
 dw #F4AA
 dw #F569
 db #CC : db 7
 dw #CD6C
 dw #D5C9
 dw #DD6B
 dw #ED6A
 dw #EDC7
 dw #F50B
 dw #FDC5
 db #D2 : db 1
 dw #F4FF
 db #E1 : db 1
 dw #EC9E
 db #EE : db 2
 dw #CD0C
 dw #ED0B
 db #FF : db 7
 dw #CD6B
 dw #DD0B
 dw #DD6A
 dw #ED69
 dw #FC45
 dw #FCAA
 dw #FD0A
; Taille bloc delta = 318 octets
 DW #0000

; Delta frame 39 -> frame 40
Delta_39_40:
 db #00 : db 9
 dw #C381
 dw #C625
 dw #C626
 dw #CB80
 dw #CB81
 dw #D37F
 dw #D382
 dw #DB7E
 dw #F5C1
 db #01 : db 1
 dw #F3D8
 db #07 : db 1
 dw #F437
 db #0F : db 19
 dw #CBDD
 dw #CC39
 dw #CC3A
 dw #CC99
 dw #D3DC
 dw #D3E1
 dw #D4A4
 dw #DBDB
 dw #DC38
 dw #DC9E
 dw #E380
 dw #E3DB
 dw #E438
 dw #EB80
 dw #EBDA
 dw #F37D
 dw #F3D9
 dw #FB80
 dw #FBD9
 db #11 : db 10
 dw #C3DC
 dw #C4FA
 dw #CC38
 dw #D498
 dw #D5C0
 dw #DBDA
 dw #EC98
 dw #FB7B
 dw #FC98
 dw #FDC2
 db #1F : db 4
 dw #CDC8
 dw #DB81
 dw #DBE2
 dw #DDC7
 db #23 : db 2
 dw #E437
 dw #F37C
 db #2D : db 1
 dw #FCFE
 db #2F : db 6
 dw #C43A
 dw #C443
 dw #D5C7
 dw #E5C6
 dw #F380
 dw #F5C4
 db #47 : db 3
 dw #CBDC
 dw #E5C1
 dw #EC37
 db #4C : db 1
 dw #DB82
 db #5A : db 1
 dw #F4FF
 db #5F : db 5
 dw #DC45
 dw #DD69
 dw #DDC8
 dw #FBE3
 dw #FD68
 db #67 : db 7
 dw #C439
 dw #D380
 dw #D3DB
 dw #D438
 dw #DB7F
 dw #E37E
 dw #EBD9
 db #6E : db 1
 dw #EDC7
 db #78 : db 1
 dw #F49B
 db #7F : db 6
 dw #CC45
 dw #CD09
 dw #DBE4
 dw #EB82
 dw #EC45
 dw #FC45
 db #87 : db 1
 dw #EC9E
 db #88 : db 4
 dw #CD6D
 dw #D5CA
 dw #ED0C
 dw #FD6A
 db #8F : db 8
 dw #C3DD
 dw #C43B
 dw #C499
 dw #DDC1
 dw #E3DA
 dw #FB7C
 dw #FBD8
 dw #FC37
 db #AE : db 2
 dw #D50C
 dw #D56C
 db #AF : db 10
 dw #C56C
 dw #C5CA
 dw #D439
 dw #D56B
 dw #D5C9
 dw #E56A
 dw #E5C7
 dw #F4AA
 dw #F50B
 dw #F569
 db #BF : db 4
 dw #C50C
 dw #D381
 dw #E56B
 dw #F56A
 db #CC : db 7
 dw #C56D
 dw #C5CB
 dw #DD6C
 dw #DDC9
 dw #E50C
 dw #E5C8
 dw #ED6B
 db #D2 : db 1
 dw #E500
 db #EE : db 2
 dw #DD0C
 dw #FD0B
 db #FF : db 12
 dw #CD0C
 dw #CD6C
 dw #CDCA
 dw #DD6B
 dw #ECA7
 dw #ED0B
 dw #ED6A
 dw #F5C6
 dw #FCA7
 dw #FD69
 dw #FDC3
 dw #FDC4
; Taille bloc delta = 314 octets
 DW #0000

; Delta frame 40 -> frame 41
Delta_40_41:
 db #00 : db 4
 dw #D380
 dw #D381
 dw #EB83
 dw #FDC2
 db #01 : db 1
 dw #D437
 db #03 : db 2
 dw #C5C0
 dw #DC37
 db #07 : db 1
 dw #EC37
 db #0F : db 24
 dw #C3DD
 dw #C3E2
 dw #C499
 dw #CBDC
 dw #CBE2
 dw #CDC8
 dw #D3DB
 dw #D438
 dw #D439
 dw #DBDA
 dw #DDC7
 dw #E381
 dw #E3DA
 dw #E3E1
 dw #EB81
 dw #EBD9
 dw #ED67
 dw #F380
 dw #F4FD
 dw #F566
 dw #F5C4
 dw #FB7C
 dw #FC37
 dw #FCFE
 db #11 : db 4
 dw #DB7F
 dw #DC98
 dw #E3D8
 dw #EDC1
 db #1F : db 5
 dw #EBE2
 dw #EDC6
 dw #FB81
 dw #FBE2
 dw #FD67
 db #2F : db 5
 dw #C5C8
 dw #D3E2
 dw #D443
 dw #F381
 dw #F3D8
 db #33 : db 2
 dw #DBD9
 dw #FDC3
 db #47 : db 2
 dw #CBDB
 dw #E437
 db #4F : db 1
 dw #CC3A
 db #5F : db 9
 dw #CC45
 dw #DDC9
 dw #ED08
 dw #ED69
 dw #EDC7
 dw #FB82
 dw #FBD8
 dw #FBD9
 dw #FC45
 db #67 : db 5
 dw #C438
 dw #D3DA
 dw #E5C1
 dw #F3D7
 dw #F5C2
 db #7F : db 4
 dw #CC39
 dw #CDCA
 dw #ECA7
 dw #FCA7
 db #88 : db 9
 dw #D4AB
 dw #DB82
 dw #DD6D
 dw #ECAB
 dw #ED6C
 dw #F383
 dw #FC49
 dw #FD0C
 dw #FD6B
 db #8C : db 2
 dw #C5CC
 dw #E382
 db #8F : db 4
 dw #E3D9
 dw #F3DA
 dw #F437
 dw #FBD7
 db #9F : db 1
 dw #CC38
 db #AE : db 3
 dw #D448
 dw #E50C
 dw #E56C
 db #AF : db 11
 dw #C439
 dw #C43A
 dw #C43B
 dw #C50C
 dw #C5CB
 dw #D56C
 dw #D5CA
 dw #E56B
 dw #E5C8
 dw #F3D9
 dw #F56A
 db #BF : db 4
 dw #C56D
 dw #D50C
 dw #F56B
 dw #F5C6
 db #CC : db 6
 dw #D56D
 dw #D5CB
 dw #E5C9
 dw #F50C
 dw #F5C7
 dw #FBE6
 db #CF : db 5
 dw #C3DC
 dw #EB7D
 dw #EBD8
 dw #F37C
 dw #FB7B
 db #D2 : db 1
 dw #F4FF
 db #EE : db 5
 dw #CD6D
 dw #DDCA
 dw #ED0C
 dw #EDC8
 dw #FDC5
 db #FF : db 7
 dw #CD09
 dw #CDCB
 dw #DB80
 dw #DD6C
 dw #ED6B
 dw #FD0B
 dw #FD6A
; Taille bloc delta = 308 octets
 DW #0000

; Delta frame 41 -> frame 42
Delta_41_42:
 db #00 : db 11
 dw #D4AB
 dw #D5C0
 dw #DB7F
 dw #DB80
 dw #DB81
 dw #DB82
 dw #E382
 dw #EDC1
 dw #F383
 dw #FC49
 dw #FDC3
 db #01 : db 1
 dw #CDC0
 db #03 : db 1
 dw #D437
 db #07 : db 2
 dw #DDC1
 dw #E437
 db #0F : db 23
 dw #C3DC
 dw #C3E3
 dw #C438
 dw #C560
 dw #CBDB
 dw #CC38
 dw #CC39
 dw #CC3A
 dw #D3DA
 dw #D3E2
 dw #D5C7
 dw #DBD9
 dw #DBE2
 dw #E5C6
 dw #EB7D
 dw #EBE2
 dw #EDC6
 dw #F37C
 dw #F381
 dw #F3E1
 dw #FB7B
 dw #FB81
 dw #FD06
 db #11 : db 9
 dw #C3DA
 dw #C437
 dw #C498
 dw #CBD9
 dw #CC98
 dw #D3D8
 dw #F37A
 dw #F5C2
 dw #FB79
 db #1F : db 7
 dw #CBE3
 dw #CC44
 dw #DBE3
 dw #DD68
 dw #DDC8
 dw #EDC7
 dw #FB82
 db #23 : db 5
 dw #C5C0
 dw #CC37
 dw #E3D7
 dw #E5C1
 dw #F3D6
 db #2D : db 1
 dw #FCFE
 db #2E : db 1
 dw #EB82
 db #2F : db 6
 dw #E3D8
 dw #E3E2
 dw #E443
 dw #E567
 dw #F382
 dw #F5C5
 db #3F : db 1
 dw #E381
 db #47 : db 3
 dw #DBD8
 dw #DC37
 dw #FD5E
 db #4B : db 1
 dw #C561
 db #5A : db 2
 dw #E3DF
 dw #F49B
 db #5F : db 7
 dw #CBE4
 dw #CDCA
 dw #EBD8
 dw #EBD9
 dw #EC45
 dw #EDC8
 dw #FBDA
 db #77 : db 2
 dw #E37E
 dw #EB7C
 db #7F : db 11
 dw #CC46
 dw #CD6A
 dw #DD6A
 dw #DDCA
 dw #EBE4
 dw #ED08
 dw #ED69
 dw #EDC9
 dw #FBD7
 dw #FC45
 dw #FD69
 db #87 : db 1
 dw #DBE0
 db #88 : db 4
 dw #C56E
 dw #CD6E
 dw #CDCD
 dw #FD6C
 db #8C : db 4
 dw #C3E5
 dw #C5CD
 dw #F50C
 dw #F56C
 db #8F : db 11
 dw #C3DB
 dw #CBDA
 dw #D3D9
 dw #D5C1
 dw #EBD7
 dw #EC37
 dw #EDC2
 dw #F3DB
 dw #F5C3
 dw #FB7A
 dw #FBD6
 db #A5 : db 1
 dw #ED00
 db #AF : db 14
 dw #C43C
 dw #C56D
 dw #C5CC
 dw #D5CB
 dw #E37F
 dw #E3D9
 dw #E3DA
 dw #E56C
 dw #E5C9
 dw #F3D7
 dw #F3D8
 dw #F3DA
 dw #F56B
 dw #F5C6
 db #BF : db 5
 dw #D3E5
 dw #D448
 dw #D56D
 dw #E5CA
 dw #F5C7
 db #C3 : db 2
 dw #E500
 dw #F49E
 db #CC : db 4
 dw #D5CC
 dw #E56D
 dw #F5C8
 dw #FD0C
 db #EE : db 5
 dw #CBE5
 dw #DD6D
 dw #DDCB
 dw #FBE6
 dw #FDC6
 db #EF : db 1
 dw #F37B
 db #F0 : db 1
 dw #F4FF
 db #FF : db 10
 dw #CD6D
 dw #CDCC
 dw #DD0C
 dw #ECA7
 dw #ED6C
 dw #FBD8
 dw #FBD9
 dw #FCA7
 dw #FD6B
 dw #FDC5
; Taille bloc delta = 378 octets
 DW #0000

; Delta frame 42 -> frame 43
Delta_42_43:
 db #01 : db 2
 dw #E3D6
 dw #E5C1
 db #03 : db 1
 dw #CC37
 db #07 : db 2
 dw #DC37
 dw #F55E
 db #0F : db 23
 dw #C3DA
 dw #C3DB
 dw #C443
 dw #CBD9
 dw #CBDA
 dw #CBE3
 dw #CCA5
 dw #D3E3
 dw #D443
 dw #DBE3
 dw #DDC8
 dw #E3E2
 dw #EB7C
 dw #EDC7
 dw #F37B
 dw #F437
 dw #F5C5
 dw #FB79
 dw #FB7A
 dw #FBD6
 dw #FBE2
 dw #FCFE
 dw #FD67
 db #11 : db 5
 dw #CDC0
 dw #D3D7
 dw #E37C
 dw #EB7A
 dw #FBD5
 db #1E : db 1
 dw #C560
 db #1F : db 5
 dw #CBE4
 dw #CD07
 dw #CDC9
 dw #DC44
 dw #EBE3
 db #23 : db 2
 dw #C437
 dw #CBD8
 db #2D : db 1
 dw #DC9B
 db #2F : db 8
 dw #C3E4
 dw #C439
 dw #D3D8
 dw #E3D7
 dw #E3E3
 dw #E5C7
 dw #F3E2
 dw #F443
 db #3C : db 1
 dw #EBDF
 db #3F : db 1
 dw #F382
 db #44 : db 1
 dw #F5CA
 db #47 : db 4
 dw #D437
 dw #DDC1
 dw #EBD6
 dw #EDC2
 db #4B : db 2
 dw #D49D
 dw #F49E
 db #4F : db 2
 dw #DBDA
 dw #FBDB
 db #5F : db 16
 dw #CCA7
 dw #DBD8
 dw #DBD9
 dw #DBE4
 dw #DDCA
 dw #EBD7
 dw #EBDA
 dw #EBE4
 dw #ED08
 dw #ED69
 dw #EDC9
 dw #FBD7
 dw #FC45
 dw #FD08
 dw #FD69
 dw #FDC6
 db #67 : db 2
 dw #C3D9
 dw #FB78
 db #6E : db 1
 dw #CBE5
 db #77 : db 2
 dw #E37D
 dw #F379
 db #78 : db 2
 dw #F3DF
 dw #F49B
 db #7F : db 5
 dw #CD09
 dw #ECA7
 dw #FBE4
 dw #FCA7
 dw #FDC7
 db #87 : db 1
 dw #ED00
 db #88 : db 8
 dw #D4AB
 dw #D56E
 dw #E4AB
 dw #EB82
 dw #EDCB
 dw #F56D
 dw #FB83
 dw #FCAB
 db #8F : db 5
 dw #C43E
 dw #DCFB
 dw #E437
 dw #F37A
 dw #F3D6
 db #9F : db 1
 dw #FDC5
 db #AE : db 3
 dw #D448
 dw #E56D
 dw #F50C
 db #AF : db 15
 dw #C43D
 dw #C5CD
 dw #D3D9
 dw #D3DA
 dw #D50C
 dw #D56D
 dw #D5CC
 dw #E37E
 dw #E3D8
 dw #E3DB
 dw #E5CA
 dw #F3DB
 dw #F56C
 dw #F5C7
 dw #F5C8
 db #BF : db 4
 dw #E380
 dw #E50C
 dw #E5CB
 dw #F5C9
 db #C3 : db 2
 dw #DD00
 dw #F3E0
 db #CC : db 7
 dw #C3E5
 dw #C56E
 dw #C5CE
 dw #D5CD
 dw #E381
 dw #ED6D
 dw #FBE6
 db #CF : db 2
 dw #DBD7
 dw #EB7B
 db #D2 : db 1
 dw #E3E0
 db #DF : db 1
 dw #FBDA
 db #E1 : db 1
 dw #EBE0
 db #EE : db 3
 dw #FD0C
 dw #FD6C
 dw #FDC8
 db #FF : db 8
 dw #CDCD
 dw #DD6A
 dw #DD6D
 dw #DDCB
 dw #DDCC
 dw #EBD8
 dw #EBD9
 dw #EDCA
; Taille bloc delta = 378 octets
 DW #0000

; Delta frame 43 -> frame 44
Delta_43_44:
 db #00 : db 4
 dw #DBE6
 dw #E381
 dw #EB82
 dw #FB83
 db #01 : db 1
 dw #F3D5
 db #03 : db 2
 dw #C437
 dw #DDC1
 db #07 : db 2
 dw #D437
 dw #E3D6
 db #0F : db 31
 dw #C3E4
 dw #C439
 dw #C444
 dw #CBE4
 dw #CC44
 dw #D3E4
 dw #D49D
 dw #DBE4
 dw #DC9B
 dw #DCA5
 dw #DCFB
 dw #E37C
 dw #E37D
 dw #E37E
 dw #E37F
 dw #E3E3
 dw #E443
 dw #E4A4
 dw #EB7A
 dw #EB7B
 dw #EBD6
 dw #EBE3
 dw #EC37
 dw #F379
 dw #F37A
 dw #F3D6
 dw #F3E2
 dw #FB77
 dw #FB78
 dw #FDC5
 dw #FDC6
 db #11 : db 5
 dw #C3D7
 dw #D3D6
 dw #E5C1
 dw #FB76
 dw #FDC3
 db #1E : db 1
 dw #E3DF
 db #1F : db 7
 dw #CBD8
 dw #DBD7
 dw #EBE4
 dw #EC44
 dw #EDC8
 dw #FBD7
 dw #FBE3
 db #23 : db 2
 dw #DBD6
 dw #FBD5
 db #2D : db 1
 dw #FCFE
 db #2E : db 1
 dw #EB81
 db #2F : db 5
 dw #D43C
 dw #D5C8
 dw #E3E4
 dw #F3E3
 dw #F5C6
 db #33 : db 2
 dw #EB78
 dw #F377
 db #3C : db 1
 dw #FBDF
 db #47 : db 2
 dw #CBD7
 dw #CC37
 db #4B : db 1
 dw #D3E0
 db #4C : db 1
 dw #F382
 db #4F : db 3
 dw #CBDA
 dw #DBDB
 dw #EBDB
 db #5A : db 3
 dw #C561
 dw #E500
 dw #F49B
 db #5F : db 6
 dw #CBD9
 dw #CC46
 dw #DBDA
 dw #FBE4
 dw #FDC7
 dw #FDC8
 db #77 : db 2
 dw #C627
 dw #E37A
 db #78 : db 1
 dw #C441
 db #7F : db 13
 dw #CC3B
 dw #CCA7
 dw #CDCB
 dw #DBD8
 dw #DBE5
 dw #DC46
 dw #DD6A
 dw #DDCB
 dw #ED6A
 dw #EDCA
 dw #FD08
 dw #FD69
 dw #FDC9
 db #87 : db 2
 dw #DC9D
 dw #FBE1
 db #88 : db 3
 dw #DD6E
 dw #EBE6
 dw #FD6D
 db #8C : db 1
 dw #C56E
 db #8F : db 6
 dw #C3D8
 dw #C3DB
 dw #DC37
 dw #E3DC
 dw #F378
 dw #F3DC
 db #AF : db 13
 dw #C3D9
 dw #C3DA
 dw #C43E
 dw #D3D7
 dw #D3D8
 dw #D3DB
 dw #D43D
 dw #D5CD
 dw #E37B
 dw #E3D7
 dw #E5CB
 dw #F5C9
 dw #F5CA
 db #BF : db 3
 dw #C5CE
 dw #E56D
 dw #E5CC
 db #C3 : db 3
 dw #C442
 dw #C500
 dw #FC9E
 db #CC : db 5
 dw #CD6E
 dw #EDCC
 dw #F3E6
 dw #F56D
 dw #F5CB
 db #CF : db 2
 dw #EB79
 dw #FDC4
 db #D2 : db 1
 dw #E49D
 db #DD : db 1
 dw #C62A
 db #DF : db 1
 dw #FBDB
 db #E1 : db 3
 dw #DBE0
 dw #DD00
 dw #FCFF
 db #EE : db 4
 dw #CDCE
 dw #DDCD
 dw #ED6D
 dw #FDCA
 db #F0 : db 4
 dw #E3E0
 dw #EBE0
 dw #F3E0
 dw #FBE0
 db #FF : db 13
 dw #C628
 dw #C629
 dw #CC3C
 dw #CC3D
 dw #CD09
 dw #DBD9
 dw #E380
 dw #EBDA
 dw #ECA7
 dw #EDCB
 dw #FBDA
 dw #FCA7
 dw #FD6C
; Taille bloc delta = 404 octets
 DW #0000

; Delta frame 44 -> frame 45
Delta_44_45:
 db #00 : db 2
 dw #C3E5
 dw #E3E6
 db #03 : db 2
 dw #FBD5
 dw #FD5E
 db #07 : db 3
 dw #C3D7
 dw #D5C1
 dw #DBD6
 db #0F : db 28
 dw #C445
 dw #C567
 dw #C5C8
 dw #CC45
 dw #D444
 dw #DB7B
 dw #DB7C
 dw #DB7D
 dw #DC44
 dw #E379
 dw #E37A
 dw #E37B
 dw #E3E4
 dw #E49E
 dw #E5C7
 dw #EB78
 dw #EB79
 dw #EBE4
 dw #EC44
 dw #EDC8
 dw #F3E3
 dw #F3E4
 dw #F443
 dw #F5C6
 dw #FB76
 dw #FBE3
 dw #FDC4
 dw #FDC7
 db #11 : db 5
 dw #C626
 dw #CBD6
 dw #E377
 dw #EBD5
 dw #FB75
 db #1E : db 6
 dw #C441
 dw #CC41
 dw #D441
 dw #DC9B
 dw #F3DF
 dw #F4FD
 db #1F : db 6
 dw #CBD7
 dw #DC3D
 dw #DC45
 dw #DDC9
 dw #FBE4
 dw #FC44
 db #23 : db 2
 dw #D3D6
 dw #DDC1
 db #2E : db 1
 dw #FB82
 db #2F : db 7
 dw #C4A5
 dw #D3D7
 dw #D43B
 dw #E444
 dw #F377
 dw #F3D7
 dw #F5C7
 db #33 : db 2
 dw #DB79
 dw #FDC3
 db #3C : db 1
 dw #FCFE
 db #47 : db 2
 dw #C437
 dw #F376
 db #4B : db 1
 dw #D49C
 db #4C : db 2
 dw #CBE5
 dw #EB81
 db #4F : db 5
 dw #CBDB
 dw #CC3E
 dw #DC3E
 dw #FB78
 dw #FBDC
 db #5A : db 1
 dw #D3E0
 db #5F : db 11
 dw #CBD8
 dw #CCA7
 dw #DBD7
 dw #DBDB
 dw #DBE5
 dw #DC46
 dw #DCA7
 dw #EBE5
 dw #FB77
 dw #FD69
 dw #FDC9
 db #77 : db 1
 dw #CE28
 db #7F : db 9
 dw #DB7E
 dw #DD08
 dw #EC46
 dw #ECA7
 dw #ED08
 dw #FBD8
 dw #FBE5
 dw #FC46
 dw #FCA7
 db #87 : db 2
 dw #CC43
 dw #EBE1
 db #88 : db 6
 dw #C5CF
 dw #CE2B
 dw #DB7F
 dw #DDCE
 dw #EDCD
 dw #F382
 db #8C : db 2
 dw #C448
 dw #D5CE
 db #8F : db 6
 dw #D3DC
 dw #D43F
 dw #E3D6
 dw #E5C2
 dw #ED5E
 dw #F379
 db #AE : db 3
 dw #D3E5
 dw #F56D
 dw #F5CC
 db #AF : db 16
 dw #C3D8
 dw #C3DB
 dw #C5CE
 dw #C627
 dw #C628
 dw #C629
 dw #C62A
 dw #C62B
 dw #D43C
 dw #D43E
 dw #E3DC
 dw #E56D
 dw #E5CC
 dw #F378
 dw #F3DC
 dw #F5CB
 db #BF : db 1
 dw #E5CD
 db #C3 : db 5
 dw #C443
 dw #CD00
 dw #DD00
 dw #E500
 dw #F3E1
 db #CC : db 2
 dw #D56E
 dw #FD6D
 db #CF : db 2
 dw #DB7A
 dw #EB77
 db #D2 : db 1
 dw #F4FF
 db #DF : db 2
 dw #CBDA
 dw #EBDB
 db #E1 : db 1
 dw #DC9C
 db #EE : db 1
 dw #E380
 db #EF : db 1
 dw #E378
 db #F0 : db 4
 dw #C442
 dw #CC42
 dw #D442
 dw #DBE0
 db #FF : db 15
 dw #C62C
 dw #CBD9
 dw #CDCE
 dw #CE29
 dw #CE2A
 dw #DBD8
 dw #DBDA
 dw #DDCB
 dw #DDCD
 dw #ED6A
 dw #ED6D
 dw #EDCC
 dw #FBDB
 dw #FDCA
 dw #FDCB
; Taille bloc delta = 410 octets
 DW #0000

; Delta frame 45 -> frame 46
Delta_45_46:
 db #00 : db 2
 dw #CDC0
 dw #F382
 db #01 : db 4
 dw #C3D6
 dw #C5C0
 dw #D55D
 dw #EBD5
 db #03 : db 1
 dw #CBD6
 db #07 : db 3
 dw #CC37
 dw #D3D6
 dw #ECFB
 db #0F : db 28
 dw #C446
 dw #C4A5
 dw #C627
 dw #CC41
 dw #CC46
 dw #CE28
 dw #D37A
 dw #D37B
 dw #D37C
 dw #D445
 dw #D49B
 dw #D49C
 dw #DB78
 dw #DB79
 dw #DB7A
 dw #DB7E
 dw #DC45
 dw #DC9D
 dw #E377
 dw #E3D6
 dw #E444
 dw #EC9E
 dw #ECA5
 dw #F4A4
 dw #F4FD
 dw #FBD7
 dw #FBE4
 dw #FC44
 db #11 : db 5
 dw #D378
 dw #D628
 dw #DD5D
 dw #E376
 dw #E3D5
 db #1E : db 2
 dw #EBDF
 dw #FBDF
 db #1F : db 10
 dw #CC3A
 dw #CCA6
 dw #DBD7
 dw #DC46
 dw #EB77
 dw #EBD7
 dw #EBE5
 dw #EC45
 dw #F381
 dw #FDC8
 db #23 : db 2
 dw #F375
 dw #F3D5
 db #2D : db 2
 dw #DC9B
 dw #FCFE
 db #2E : db 1
 dw #E380
 db #2F : db 10
 dw #C3D7
 dw #C43A
 dw #C628
 dw #D446
 dw #D4A5
 dw #E3D7
 dw #E445
 dw #F376
 dw #F3E5
 dw #F444
 db #33 : db 1
 dw #DB77
 db #3F : db 3
 dw #C3E4
 dw #D37D
 dw #E3E5
 db #4C : db 1
 dw #FB82
 db #4F : db 3
 dw #DBDC
 dw #EBDC
 dw #FB79
 db #55 : db 1
 dw #D62B
 db #5A : db 2
 dw #E442
 dw #E49D
 db #5F : db 13
 dw #CC47
 dw #CE29
 dw #CE2A
 dw #CE2B
 dw #DC3C
 dw #DD08
 dw #EB78
 dw #EC46
 dw #ED08
 dw #EDCA
 dw #FB76
 dw #FBE5
 dw #FCA7
 db #67 : db 2
 dw #C626
 dw #FDC3
 db #6E : db 2
 dw #DB7F
 dw #DBE5
 db #78 : db 2
 dw #D442
 dw #F49B
 db #7F : db 6
 dw #CBD8
 dw #DC47
 dw #DCA8
 dw #FB77
 dw #FD69
 dw #FDCA
 db #87 : db 3
 dw #DBE1
 dw #DC43
 dw #FC9E
 db #88 : db 5
 dw #CBE5
 dw #CDCF
 dw #CE2D
 dw #E5CE
 dw #F3E6
 db #8C : db 1
 dw #D3E5
 db #8F : db 9
 dw #C43F
 dw #DBD6
 dw #E379
 dw #E3DD
 dw #E43F
 dw #EB76
 dw #F37A
 dw #F3DD
 dw #FB75
 db #A5 : db 3
 dw #DC9C
 dw #DD00
 dw #FCFF
 db #AF : db 10
 dw #C3DC
 dw #C62C
 dw #D3DC
 dw #E378
 dw #E43D
 dw #E43E
 dw #E5CD
 dw #F377
 dw #F379
 dw #F5CC
 db #BF : db 2
 dw #C62D
 dw #D5CE
 db #C3 : db 4
 dw #D443
 dw #E3E1
 dw #EBE1
 dw #FBE1
 db #CC : db 3
 dw #C5CF
 dw #D37E
 dw #F5CD
 db #D2 : db 1
 dw #C500
 db #DF : db 5
 dw #CBDB
 dw #CC3E
 dw #DBDB
 dw #DC3E
 dw #FB78
 db #E1 : db 2
 dw #CD00
 dw #EC9D
 db #EE : db 2
 dw #DDCE
 dw #FD6D
 db #EF : db 1
 dw #D379
 db #F0 : db 2
 dw #DC42
 dw #F4FF
 db #FF : db 10
 dw #CBDA
 dw #CDCB
 dw #CE27
 dw #CE2C
 dw #D629
 dw #D62A
 dw #DC3D
 dw #EBDB
 dw #EDCD
 dw #FDCC
; Taille bloc delta = 418 octets
 DW #0000

; Delta frame 46 -> frame 47
Delta_46_47:
 db #01 : db 2
 dw #E3D5
 dw #F5C2
 db #0F : db 31
 dw #C4A6
 dw #C628
 dw #CB79
 dw #CB7A
 dw #CB7B
 dw #CB7C
 dw #CCA6
 dw #CE27
 dw #CE29
 dw #D378
 dw #D37D
 dw #D441
 dw #D446
 dw #D4A5
 dw #DB77
 dw #DBD6
 dw #DC46
 dw #E445
 dw #E446
 dw #EBDF
 dw #EC45
 dw #F3D7
 dw #F444
 dw #F445
 dw #F49E
 dw #F5C3
 dw #F5C7
 dw #FB75
 dw #FBDF
 dw #FC45
 dw #FCA5
 db #11 : db 4
 dw #C379
 dw #C625
 dw #E375
 dw #FB74
 db #1E : db 1
 dw #F4FD
 db #1F : db 9
 dw #CC47
 dw #D37E
 dw #DB7F
 dw #DC3B
 dw #DCA6
 dw #DD07
 dw #EB76
 dw #EC46
 dw #FBE5
 db #23 : db 5
 dw #C3D6
 dw #CD5D
 dw #DB76
 dw #EB75
 dw #EBD5
 db #2E : db 1
 dw #C3E4
 db #2F : db 3
 dw #C447
 dw #D447
 dw #E4A5
 db #33 : db 2
 dw #CE26
 dw #D627
 db #3C : db 1
 dw #DC42
 db #3F : db 1
 dw #E380
 db #44 : db 1
 dw #C37C
 db #47 : db 2
 dw #CBD6
 dw #FDC3
 db #4B : db 3
 dw #D3E1
 dw #D49C
 dw #E49D
 db #4F : db 1
 dw #CBDC
 db #55 : db 2
 dw #C37A
 dw #C37B
 db #5F : db 8
 dw #CCA8
 dw #DC47
 dw #EB77
 dw #EB79
 dw #EC3D
 dw #EC47
 dw #ECA7
 dw #FC46
 db #67 : db 1
 dw #D377
 db #6E : db 1
 dw #CC48
 db #78 : db 2
 dw #C442
 dw #E3E0
 db #7F : db 7
 dw #CB7D
 dw #CD09
 dw #CDCB
 dw #DDCB
 dw #ED08
 dw #EDCA
 dw #FCA7
 db #87 : db 1
 dw #FD00
 db #88 : db 5
 dw #CB7E
 dw #CE2E
 dw #DB80
 dw #E56E
 dw #EDCE
 db #8F : db 8
 dw #C3DD
 dw #C626
 dw #D379
 dw #D3D6
 dw #D3DD
 dw #E376
 dw #E37A
 dw #F375
 db #AE : db 1
 dw #F5CD
 db #AF : db 16
 dw #C62D
 dw #D43B
 dw #D43F
 dw #D5CE
 dw #D628
 dw #D629
 dw #D62A
 dw #D62B
 dw #E377
 dw #E379
 dw #E43C
 dw #E43F
 dw #F376
 dw #F37A
 dw #F43E
 dw #F43F
 db #BF : db 3
 dw #C62E
 dw #D62C
 dw #F56D
 db #C3 : db 5
 dw #C500
 dw #CC43
 dw #CD00
 dw #D500
 dw #DBE1
 db #CC : db 5
 dw #D37F
 dw #D3E5
 dw #D62D
 dw #E5CE
 dw #FDCD
 db #CF : db 1
 dw #DBDC
 db #D2 : db 3
 dw #E49C
 dw #F3E1
 dw #F49D
 db #DF : db 5
 dw #EB78
 dw #EBDC
 dw #EC3E
 dw #FB79
 dw #FBDC
 db #E1 : db 4
 dw #DD00
 dw #EBE1
 dw #FBE1
 dw #FCFF
 db #EE : db 1
 dw #DC48
 db #EF : db 1
 dw #CB78
 db #FF : db 11
 dw #CBD8
 dw #CBDB
 dw #CC3B
 dw #CE2D
 dw #DBDB
 dw #DC3C
 dw #DE29
 dw #DE2A
 dw #DE2B
 dw #FB77
 dw #FB78
; Taille bloc delta = 390 octets
 DW #0000

; Delta frame 47 -> frame 48
Delta_47_48:
 db #00 : db 4
 dw #CBE5
 dw #D4AB
 dw #E4AB
 dw #EBE6
 db #03 : db 1
 dw #C3D6
 db #07 : db 3
 dw #CBD6
 dw #EB75
 dw #EDC2
 db #0F : db 33
 dw #C379
 dw #C37A
 dw #C37B
 dw #C37C
 dw #C3D7
 dw #C441
 dw #C447
 dw #C4A7
 dw #C506
 dw #C626
 dw #CB78
 dw #CB7D
 dw #CCA7
 dw #D37E
 dw #D4A6
 dw #DB76
 dw #DB7F
 dw #DC42
 dw #DC9B
 dw #DCA6
 dw #E3D7
 dw #E3DF
 dw #E4A5
 dw #E5C2
 dw #EBD7
 dw #EC46
 dw #F375
 dw #F3DF
 dw #F446
 dw #F4FD
 dw #FC46
 dw #FC9E
 dw #FD00
 db #11 : db 5
 dw #C377
 dw #D626
 dw #DBD5
 dw #DE27
 dw #F374
 db #1E : db 1
 dw #E442
 db #1F : db 8
 dw #CBE4
 dw #DC47
 dw #DCA7
 dw #E380
 dw #EC47
 dw #ECA6
 dw #ED68
 dw #FC3D
 db #23 : db 4
 dw #C625
 dw #E375
 dw #F5C2
 dw #FB74
 db #2E : db 2
 dw #D37F
 dw #E3E5
 db #2F : db 8
 dw #C4A0
 dw #C629
 dw #D377
 dw #E376
 dw #E447
 dw #E506
 dw #E5C8
 dw #F4A5
 db #3C : db 2
 dw #CC42
 dw #FCFE
 db #3F : db 1
 dw #CB7E
 db #4B : db 1
 dw #C500
 db #4C : db 1
 dw #DB80
 db #4F : db 3
 dw #EB7A
 dw #FB7A
 dw #FC3F
 db #5A : db 2
 dw #D442
 dw #E49C
 db #5F : db 13
 dw #CD09
 dw #DB77
 dw #DB78
 dw #DB79
 dw #DE29
 dw #DE2A
 dw #EB76
 dw #EC3C
 dw #ED08
 dw #EDCA
 dw #FC3E
 dw #FC47
 dw #FD69
 db #67 : db 1
 dw #D376
 db #77 : db 2
 dw #E629
 dw #FB17
 db #78 : db 5
 dw #DBE0
 dw #EBE0
 dw #F3E0
 dw #F4FE
 dw #FBE0
 db #7F : db 8
 dw #CCA9
 dw #CE2C
 dw #DE2B
 dw #EB77
 dw #EBD8
 dw #EC48
 dw #ECA8
 dw #FB76
 db #87 : db 3
 dw #CD00
 dw #DC9C
 dw #EC9D
 db #88 : db 4
 dw #C62F
 dw #DE2D
 dw #FB1A
 dw #FBE6
 db #8C : db 1
 dw #C5CF
 db #8F : db 3
 dw #DCFB
 dw #F37B
 dw #FDC3
 db #AE : db 1
 dw #E5CE
 db #AF : db 14
 dw #C378
 dw #C43F
 dw #C4A1
 dw #C62E
 dw #D378
 dw #D379
 dw #D37A
 dw #D3DD
 dw #D627
 dw #D62C
 dw #E37A
 dw #E3DD
 dw #F3DD
 dw #F43D
 db #BF : db 2
 dw #D62D
 dw #F5CD
 db #C3 : db 2
 dw #D3E1
 dw #DD00
 db #CC : db 2
 dw #CDCF
 dw #EDCE
 db #CF : db 2
 dw #CB77
 dw #CE26
 db #DD : db 1
 dw #E62B
 db #DF : db 4
 dw #CBDC
 dw #DBDC
 dw #DE28
 dw #EB79
 db #E1 : db 2
 dw #CC43
 dw #DBE1
 db #EE : db 3
 dw #CC48
 dw #CE2E
 dw #FDCD
 db #F0 : db 4
 dw #C443
 dw #E3E1
 dw #EBE1
 dw #F3E1
 db #FF : db 13
 dw #C37D
 dw #DC3E
 dw #DD6A
 dw #DDCB
 dw #DDCE
 dw #DE2C
 dw #E62A
 dw #EB78
 dw #EC3D
 dw #EC3E
 dw #FB18
 dw #FB19
 dw #FB79
; Taille bloc delta = 414 octets
 DW #0000

; Delta frame 48 -> frame 49
Delta_48_49:
 db #00 : db 2
 dw #E55D
 dw #F3E6
 db #01 : db 2
 dw #E5C1
 dw #F374
 db #03 : db 2
 dw #C55D
 dw #DDC1
 db #07 : db 1
 dw #C437
 db #0F : db 36
 dw #C37D
 dw #C4A8
 dw #C500
 dw #CB77
 dw #CB7E
 dw #CBD7
 dw #CC47
 dw #CCA8
 dw #CD07
 dw #CE26
 dw #D37F
 dw #D3D7
 dw #D447
 dw #D49C
 dw #D4A7
 dw #D506
 dw #D627
 dw #DBD7
 dw #DC43
 dw #DC47
 dw #DCA7
 dw #DE28
 dw #E380
 dw #E442
 dw #E447
 dw #E49D
 dw #E4A6
 dw #EB75
 dw #ECA6
 dw #F381
 dw #F4A5
 dw #FB17
 dw #FB18
 dw #FB19
 dw #FB1A
 dw #FDC3
 db #11 : db 5
 dw #C376
 dw #CE25
 dw #F316
 dw #FB15
 dw #FDC2
 db #1E : db 4
 dw #D3E0
 dw #D442
 dw #D49B
 dw #F4FD
 db #1F : db 8
 dw #DCA8
 dw #DE29
 dw #EB76
 dw #ECA7
 dw #ED07
 dw #FC3C
 dw #FC47
 dw #FCA6
 db #23 : db 2
 dw #CB76
 dw #DB75
 db #2E : db 1
 dw #DB80
 db #2F : db 8
 dw #C378
 dw #D4A0
 dw #D4A8
 dw #D628
 dw #E43B
 dw #E4A7
 dw #F43C
 dw #F447
 db #33 : db 1
 dw #EE29
 db #3C : db 3
 dw #DBE0
 dw #EBE0
 dw #FBE0
 db #3F : db 1
 dw #C37E
 db #47 : db 4
 dw #C3D6
 dw #E375
 dw #F55E
 dw #FBD5
 db #4B : db 2
 dw #D500
 dw #E3E2
 db #4C : db 3
 dw #CB7F
 dw #CC48
 dw #DBE5
 db #4F : db 8
 dw #CC3F
 dw #CCA1
 dw #DB7A
 dw #DBDD
 dw #DC3F
 dw #EBDD
 dw #EC3F
 dw #FBDD
 db #5A : db 2
 dw #C442
 dw #D443
 db #5F : db 8
 dw #CB78
 dw #CB79
 dw #CCA9
 dw #DCA9
 dw #DE2B
 dw #ECA8
 dw #ED68
 dw #FCA7
 db #67 : db 3
 dw #C625
 dw #D626
 dw #E628
 db #6E : db 2
 dw #DC48
 dw #EB81
 db #7F : db 15
 dw #CBD8
 dw #CCA0
 dw #DB78
 dw #DBD8
 dw #DC3B
 dw #DD09
 dw #DD6A
 dw #DDCB
 dw #EC3C
 dw #ED09
 dw #ED69
 dw #FB1B
 dw #FC3D
 dw #FCA8
 dw #FD69
 db #87 : db 4
 dw #DBE2
 dw #DD00
 dw #EBE2
 dw #FBE2
 db #88 : db 4
 dw #D3E5
 dw #D5CF
 dw #E381
 dw #F5CE
 db #8F : db 6
 dw #C377
 dw #D376
 dw #D37B
 dw #D4A2
 dw #EDC2
 dw #FB16
 db #A5 : db 1
 dw #CBE1
 db #AF : db 16
 dw #C379
 dw #C37A
 dw #C3DD
 dw #C49F
 dw #C4A0
 dw #D377
 dw #D4A1
 dw #D62D
 dw #E37B
 dw #E5C8
 dw #E629
 dw #E62A
 dw #E62B
 dw #F318
 dw #F37B
 dw #F5CD
 db #BF : db 2
 dw #E62C
 dw #F448
 db #C3 : db 1
 dw #F49D
 db #CC : db 4
 dw #C448
 dw #C62F
 dw #D62E
 dw #F31A
 db #CF : db 1
 dw #DE27
 db #D2 : db 1
 dw #D3E1
 db #DF : db 2
 dw #EB7A
 dw #FB7A
 db #E1 : db 1
 dw #FC9D
 db #EE : db 1
 dw #EE2B
 db #F0 : db 2
 dw #DBE1
 dw #FBE1
 db #FF : db 17
 dw #CC3E
 dw #CE2C
 dw #CE2E
 dw #DB79
 dw #DBDC
 dw #DE2D
 dw #EB77
 dw #EB79
 dw #EBDC
 dw #EC48
 dw #EE2A
 dw #F317
 dw #F319
 dw #FBDC
 dw #FC3E
 dw #FDCA
 dw #FDCD
; Taille bloc delta = 450 octets
 DW #0000

; Delta frame 49 -> frame 50
Delta_49_50:
 db #00 : db 4
 dw #CCAB
 dw #D4A0
 dw #DCA1
 dw #E4A2
 db #01 : db 2
 dw #D375
 dw #FDC2
 db #03 : db 3
 dw #DB75
 dw #F3D5
 dw #FB74
 db #07 : db 5
 dw #C625
 dw #D626
 dw #E375
 dw #F4A4
 dw #F55E
 db #0F : db 31
 dw #C377
 dw #C37E
 dw #C507
 dw #CC42
 dw #CD08
 dw #CD68
 dw #D376
 dw #D442
 dw #D4A8
 dw #D628
 dw #DC9C
 dw #DCA8
 dw #DD07
 dw #DE27
 dw #E4A7
 dw #EB18
 dw #EC47
 dw #EC9D
 dw #ECA7
 dw #EDC2
 dw #F317
 dw #F319
 dw #F31A
 dw #F447
 dw #F4A6
 dw #F4A7
 dw #FB16
 dw #FB1B
 dw #FC47
 dw #FCA6
 dw #FCA7
 db #11 : db 6
 dw #CDC0
 dw #DE26
 dw #EB16
 dw #EB74
 dw #ECA3
 dw #F315
 db #1E : db 6
 dw #C442
 dw #DBE0
 dw #E3E0
 dw #EBE0
 dw #F3E0
 dw #FBE0
 db #1F : db 9
 dw #CB77
 dw #CB7F
 dw #CCA9
 dw #CE2A
 dw #DB80
 dw #EC3B
 dw #ECA8
 dw #ED68
 dw #FBD8
 db #23 : db 2
 dw #C376
 dw #CE25
 db #2E : db 1
 dw #EB81
 db #2F : db 7
 dw #C49E
 dw #C4A9
 dw #D4A9
 dw #E4A0
 dw #E4A8
 dw #F3D8
 dw #F506
 db #33 : db 3
 dw #D4A1
 dw #DCA2
 dw #EE28
 db #3F : db 2
 dw #D49F
 dw #ECA1
 db #47 : db 4
 dw #C437
 dw #DDC1
 dw #E4A3
 dw #F5C2
 db #4B : db 6
 dw #C3E1
 dw #C444
 dw #D3E2
 dw #E49C
 dw #E500
 dw #F49D
 db #4C : db 1
 dw #DCA0
 db #4F : db 4
 dw #CB7A
 dw #CBDD
 dw #EB7B
 dw #FB7B
 db #5A : db 1
 dw #C560
 db #5F : db 8
 dw #CDCB
 dw #DD09
 dw #ECA9
 dw #ED69
 dw #EE2A
 dw #FCA8
 dw #FD08
 dw #FD69
 db #67 : db 1
 dw #E627
 db #6E : db 1
 dw #FB1C
 db #78 : db 1
 dw #FC9B
 db #7F : db 11
 dw #CC9F
 dw #CD0A
 dw #CE2C
 dw #DB77
 dw #DE2B
 dw #EB19
 dw #EC48
 dw #FC3C
 dw #FC48
 dw #FCA9
 dw #FDCA
 db #87 : db 2
 dw #CC44
 dw #FD00
 db #88 : db 5
 dw #CE2F
 dw #DE2E
 dw #E4A1
 dw #ECA2
 dw #F382
 db #8C : db 2
 dw #C62F
 dw #D448
 db #8F : db 8
 dw #C37B
 dw #C3DE
 dw #C4A2
 dw #CB76
 dw #CBD6
 dw #D3DE
 dw #D5C1
 dw #F316
 db #AE : db 2
 dw #D62E
 dw #E448
 db #AF : db 5
 dw #C378
 dw #D37B
 dw #E628
 dw #E62C
 dw #F43C
 db #BF : db 1
 dw #F4A2
 db #C3 : db 5
 dw #DBE2
 dw #E3E2
 dw #EBE2
 dw #F3E2
 dw #FC9D
 db #CC : db 4
 dw #C37F
 dw #D380
 dw #E381
 dw #E62D
 db #CF : db 1
 dw #FB15
 db #D2 : db 1
 dw #C4FF
 db #DD : db 1
 dw #F4A3
 db #DF : db 3
 dw #DB7A
 dw #EB17
 dw #EE29
 db #E1 : db 1
 dw #EC9C
 db #EE : db 2
 dw #EB1A
 dw #EE2C
 db #F0 : db 3
 dw #CC43
 dw #D3E1
 dw #FCFF
 db #FF : db 9
 dw #CBDC
 dw #CCA0
 dw #DD6A
 dw #DDCB
 dw #EC3C
 dw #EE2B
 dw #F31B
 dw #FB7A
 dw #FC3D
; Taille bloc delta = 430 octets
 DW #0000

; Delta frame 50 -> frame 51
Delta_50_51:
 db #00 : db 19
 dw #C49F
 dw #C4A0
 dw #C506
 dw #CC9F
 dw #CCA0
 dw #CCA1
 dw #D4A1
 dw #DCA0
 dw #DCA2
 dw #E4A0
 dw #E4A1
 dw #ECA1
 dw #ECA2
 dw #ECA3
 dw #F4A2
 dw #F4A3
 dw #FCA2
 dw #FCA3
 dw #FCAB
 db #07 : db 4
 dw #C3D6
 dw #C437
 dw #C507
 dw #F5C2
 db #0C : db 1
 dw #E381
 db #0F : db 36
 dw #C4A9
 dw #C508
 dw #C509
 dw #CB76
 dw #CB7F
 dw #CCA9
 dw #CD00
 dw #CD09
 dw #CDC9
 dw #D3E0
 dw #D49B
 dw #D500
 dw #D507
 dw #D567
 dw #DB80
 dw #DBE0
 dw #DD00
 dw #DD08
 dw #DE29
 dw #E318
 dw #E4A8
 dw #E506
 dw #EB17
 dw #EB19
 dw #EB1A
 dw #EBE0
 dw #ECA8
 dw #ED07
 dw #F316
 dw #F31B
 dw #F49D
 dw #F4A8
 dw #FB15
 dw #FB1C
 dw #FBE0
 dw #FD00
 db #11 : db 11
 dw #C624
 dw #D4A2
 dw #D625
 dw #E316
 dw #E4A3
 dw #E626
 dw #EDC1
 dw #EE27
 dw #F628
 dw #FB14
 dw #FCA4
 db #1F : db 7
 dw #CC9E
 dw #DCA9
 dw #EB81
 dw #FB16
 dw #FB76
 dw #FCA8
 dw #FD07
 db #23 : db 5
 dw #D375
 dw #E5C1
 dw #F3D5
 dw #F4A4
 dw #FDC2
 db #2D : db 2
 dw #CD61
 dw #DC9B
 db #2F : db 10
 dw #C377
 dw #C503
 dw #D49E
 dw #D508
 dw #E319
 dw #E4A9
 dw #E5C8
 dw #F376
 dw #F43B
 dw #F4A0
 db #3C : db 1
 dw #CBE1
 db #3F : db 5
 dw #C37F
 dw #C3E4
 dw #D380
 dw #E49F
 dw #FCA1
 db #44 : db 1
 dw #C505
 db #47 : db 8
 dw #C376
 dw #CCA2
 dw #CE25
 dw #DB75
 dw #DCA3
 dw #DE26
 dw #ECA4
 dw #F315
 db #4B : db 1
 dw #D444
 db #4F : db 3
 dw #CB7B
 dw #DB7B
 dw #FB18
 db #5A : db 1
 dw #C3E1
 db #5F : db 7
 dw #CB7A
 dw #CD0A
 dw #DD0A
 dw #ED09
 dw #EE29
 dw #FB17
 dw #FDCA
 db #67 : db 1
 dw #C4A1
 db #6E : db 4
 dw #DC9F
 dw #EB1B
 dw #EC48
 dw #ECA0
 db #78 : db 3
 dw #C443
 dw #D3E1
 dw #D4FD
 db #7F : db 9
 dw #CCAA
 dw #CD0B
 dw #CDCB
 dw #DD6A
 dw #DDCB
 dw #ED6A
 dw #EE2B
 dw #FD09
 dw #FD69
 db #87 : db 2
 dw #CBE2
 dw #FC9D
 db #88 : db 6
 dw #CB80
 dw #D49F
 dw #DB81
 dw #EE2D
 dw #F4A1
 dw #FB1D
 db #8F : db 16
 dw #C37C
 dw #C440
 dw #C625
 dw #D37C
 dw #D440
 dw #D4A3
 dw #D626
 dw #E375
 dw #E37C
 dw #E3DE
 dw #E4A4
 dw #EB16
 dw #EE28
 dw #F37C
 dw #F3DE
 dw #F440
 db #AE : db 1
 dw #C62F
 db #AF : db 6
 dw #C37B
 dw #E43B
 dw #E627
 dw #F317
 dw #F319
 dw #F62A
 db #BF : db 4
 dw #C49E
 dw #C504
 dw #D62E
 dw #E62D
 db #C3 : db 3
 dw #C444
 dw #C4FF
 dw #D3E2
 db #CC : db 2
 dw #DE2E
 dw #F31C
 db #CF : db 1
 dw #FB7B
 db #D2 : db 1
 dw #F3E2
 db #DD : db 1
 dw #E31A
 db #E1 : db 5
 dw #CCFF
 dw #DBE2
 dw #EBE2
 dw #FBE2
 dw #FCFF
 db #EF : db 1
 dw #E317
 db #F0 : db 1
 dw #E3E2
 db #FF : db 8
 dw #CB79
 dw #CE2C
 dw #DB78
 dw #DB7A
 dw #EB7A
 dw #EE2C
 dw #F629
 dw #F62B
; Taille bloc delta = 468 octets
 DW #0000

; Delta frame 51 -> frame 52
Delta_51_52:
 db #00 : db 21
 dw #C4A1
 dw #C504
 dw #C505
 dw #CCA2
 dw #CD04
 dw #CD05
 dw #CD06
 dw #D49F
 dw #D4A2
 dw #D505
 dw #D506
 dw #DCA3
 dw #E4A3
 dw #ECA0
 dw #F43D
 dw #F4A1
 dw #FC3D
 dw #FC3E
 dw #FC3F
 dw #FCA1
 dw #FCA4
 db #01 : db 2
 dw #C4A2
 dw #E626
 db #03 : db 3
 dw #CD07
 dw #F3D5
 dw #FDC2
 db #07 : db 1
 dw #C376
 db #0F : db 31
 dw #C37F
 dw #C442
 dw #C50A
 dw #C625
 dw #CD0A
 dw #D3D6
 dw #D4A9
 dw #D508
 dw #D509
 dw #D626
 dw #DB18
 dw #DC9B
 dw #DCA9
 dw #DD09
 dw #DD68
 dw #E317
 dw #E3E0
 dw #E49C
 dw #E500
 dw #E507
 dw #E508
 dw #E627
 dw #EB16
 dw #EB1B
 dw #ED08
 dw #EE28
 dw #F3E0
 dw #F500
 dw #FC9D
 dw #FCA8
 dw #FD07
 db #11 : db 6
 dw #CB75
 dw #E55D
 dw #F314
 dw #F43E
 dw #F4A4
 dw #FE29
 db #1E : db 3
 dw #C3E1
 dw #D443
 dw #ECFD
 db #1F : db 10
 dw #CBD8
 dw #CD69
 dw #DB19
 dw #DBD8
 dw #DC9E
 dw #DD05
 dw #EBD8
 dw #ECA9
 dw #FC3B
 dw #FCA9
 db #23 : db 8
 dw #C5C0
 dw #D4A3
 dw #D507
 dw #D625
 dw #EB15
 dw #ECA4
 dw #F374
 dw #FB14
 db #2E : db 3
 dw #CB80
 dw #E381
 dw #FB1D
 db #2F : db 15
 dw #C3D8
 dw #C49D
 dw #C502
 dw #D380
 dw #D3D8
 dw #D43A
 dw #D503
 dw #E318
 dw #E31A
 dw #E3D8
 dw #F316
 dw #F31C
 dw #F49F
 dw #F4A9
 dw #F567
 db #3C : db 2
 dw #CC43
 dw #FBE1
 db #47 : db 2
 dw #E316
 dw #E4A4
 db #4B : db 2
 dw #C4FF
 dw #D49B
 db #4C : db 2
 dw #DB81
 dw #EB1C
 db #4F : db 1
 dw #FB19
 db #5A : db 2
 dw #C443
 dw #E4FD
 db #5F : db 10
 dw #CD6A
 dw #CDCB
 dw #DB77
 dw #DB7B
 dw #DD6A
 dw #DE2B
 dw #ED0A
 dw #FB18
 dw #FD09
 dw #FD69
 db #67 : db 2
 dw #EE27
 dw #F628
 db #6E : db 4
 dw #CC9E
 dw #EC9F
 dw #FB82
 dw #FCA0
 db #78 : db 6
 dw #CCFD
 dw #DBE1
 dw #E3E1
 dw #EBE1
 dw #F3E1
 dw #FCFE
 db #7F : db 7
 dw #CD03
 dw #CD6B
 dw #CE2C
 dw #DCAA
 dw #EC3B
 dw #EDCA
 dw #FDCA
 db #87 : db 5
 dw #CCFF
 dw #CD61
 dw #EBE3
 dw #EC9C
 dw #FD00
 db #88 : db 10
 dw #C380
 dw #C448
 dw #C503
 dw #CBE5
 dw #DC9F
 dw #EB82
 dw #F31D
 dw #F4A0
 dw #FC3C
 dw #FE2B
 db #8F : db 9
 dw #CCA3
 dw #CE25
 dw #E440
 dw #E506
 dw #F315
 dw #F31A
 dw #F5C2
 dw #FC40
 dw #FCA5
 db #AF : db 8
 dw #C3DE
 dw #D37C
 dw #E319
 dw #E37C
 dw #E505
 dw #F37C
 dw #F629
 dw #F62B
 db #BF : db 3
 dw #D49E
 dw #D504
 dw #F43C
 db #C3 : db 1
 dw #D4FF
 db #CC : db 7
 dw #C49E
 dw #CE2F
 dw #D3E5
 dw #E49F
 dw #EE2D
 dw #F382
 dw #F62C
 db #CF : db 2
 dw #DE26
 dw #EBDD
 db #D2 : db 1
 dw #F49C
 db #DF : db 5
 dw #CB7A
 dw #CBDD
 dw #DBDD
 dw #EB7B
 dw #FB7B
 db #E1 : db 3
 dw #CC44
 dw #DCFF
 dw #FC9C
 db #EE : db 2
 dw #DB1A
 dw #E31B
 db #EF : db 1
 dw #F43F
 db #F0 : db 4
 dw #C444
 dw #EBE2
 dw #F3E2
 dw #FBE2
 db #FF : db 6
 dw #CB78
 dw #DB17
 dw #DD06
 dw #DDCB
 dw #EE2B
 dw #FE2A
; Taille bloc delta = 496 octets
 DW #0000

; Delta frame 52 -> frame 53
Delta_52_53:
 db #00 : db 24
 dw #C4A2
 dw #C503
 dw #CD03
 dw #D4A3
 dw #D504
 dw #DC9F
 dw #DCAB
 dw #DD04
 dw #DD05
 dw #DD06
 dw #E49F
 dw #E505
 dw #E506
 dw #EC3D
 dw #EC3E
 dw #ECAB
 dw #F43C
 dw #F43E
 dw #F43F
 dw #F4A0
 dw #F4A4
 dw #FC3C
 dw #FC40
 dw #FCA0
 db #01 : db 3
 dw #DD07
 dw #E507
 dw #EDC1
 db #07 : db 3
 dw #DB75
 dw #DDC1
 dw #FCA5
 db #0F : db 28
 dw #C3E1
 dw #C4FF
 dw #CBE1
 dw #CC43
 dw #CD69
 dw #D380
 dw #D49B
 dw #D50A
 dw #DB17
 dw #DB19
 dw #DB1A
 dw #DD0A
 dw #DE26
 dw #E316
 dw #E376
 dw #E4A9
 dw #E509
 dw #EB76
 dw #EB81
 dw #ECA9
 dw #ED00
 dw #ED09
 dw #F315
 dw #F31C
 dw #F507
 dw #F508
 dw #FD00
 dw #FD08
 db #11 : db 6
 dw #CCA3
 dw #DE25
 dw #E315
 dw #EC3F
 dw #ECA4
 dw #F627
 db #1E : db 3
 dw #C443
 dw #D3E1
 dw #F3E1
 db #1F : db 10
 dw #CB80
 dw #CC9D
 dw #CD0B
 dw #DC3A
 dw #EB17
 dw #EB1C
 dw #EC9E
 dw #ED04
 dw #FB1D
 dw #FD09
 db #23 : db 4
 dw #C624
 dw #CD07
 dw #DB16
 dw #E4A4
 db #2D : db 1
 dw #CD61
 db #2E : db 1
 dw #FB82
 db #2F : db 5
 dw #C501
 dw #C50B
 dw #E49E
 dw #E50A
 dw #F504
 db #3C : db 3
 dw #DBE1
 dw #EBE1
 dw #ECFD
 db #3F : db 1
 dw #E381
 db #47 : db 6
 dw #C507
 dw #DCA4
 dw #EB15
 dw #FB14
 dw #FD5E
 dw #FDC2
 db #4B : db 1
 dw #C445
 db #55 : db 1
 dw #E43E
 db #5A : db 1
 dw #D444
 db #5F : db 9
 dw #CD6B
 dw #EB18
 dw #ED6A
 dw #EDCA
 dw #FB16
 dw #FB19
 dw #FC3B
 dw #FC9F
 dw #FD0A
 db #67 : db 4
 dw #C4A3
 dw #D625
 dw #E626
 dw #F440
 db #6E : db 5
 dw #CD02
 dw #DB1B
 dw #DB81
 dw #DC9E
 dw #DD03
 db #77 : db 1
 dw #D317
 db #78 : db 1
 dw #EC9B
 db #7F : db 10
 dw #CB78
 dw #CD6C
 dw #CDCB
 dw #DD0B
 dw #DDCB
 dw #DE2B
 dw #EB77
 dw #ECAA
 dw #ED05
 dw #EE2B
 db #87 : db 2
 dw #E3E3
 dw #FBE3
 db #88 : db 6
 dw #C49E
 dw #D503
 dw #EB1D
 dw #EC3C
 dw #EC9F
 dw #FB1E
 db #8C : db 2
 dw #D49E
 dw #F49F
 db #8F : db 5
 dw #C376
 dw #D4A4
 dw #E31A
 dw #EC40
 dw #F4A5
 db #AF : db 11
 dw #C37C
 dw #D3DE
 dw #D502
 dw #E318
 dw #E31B
 dw #E503
 dw #E62D
 dw #F31A
 dw #F505
 dw #F506
 dw #F628
 db #BF : db 5
 dw #C4AA
 dw #D319
 dw #E43C
 dw #F43B
 dw #F62C
 db #C3 : db 3
 dw #DCFF
 dw #F3E3
 dw #F49C
 db #CC : db 6
 dw #C380
 dw #C502
 dw #CC9E
 dw #D31A
 dw #D381
 dw #E31C
 db #CF : db 1
 dw #EE27
 db #D2 : db 1
 dw #E4FF
 db #DD : db 1
 dw #E43D
 db #DF : db 5
 dw #CB7B
 dw #DB7B
 dw #EBDD
 dw #FB17
 dw #FBDD
 db #E1 : db 1
 dw #ECFF
 db #EE : db 4
 dw #DE2E
 dw #E504
 dw #EE2D
 dw #F31D
 db #F0 : db 3
 dw #D3E2
 dw #DBE2
 dw #FCFE
 db #FF : db 6
 dw #CB7A
 dw #CE2C
 dw #D318
 dw #ED06
 dw #FE29
 dw #FE2B
; Taille bloc delta = 466 octets
 DW #0000

; Delta frame 53 -> frame 54
Delta_53_54:
 db #00 : db 25
 dw #C49E
 dw #C4FA
 dw #C502
 dw #CCA3
 dw #CD02
 dw #D503
 dw #DC3D
 dw #DC3E
 dw #DD03
 dw #E43C
 dw #E43D
 dw #E43E
 dw #E43F
 dw #E504
 dw #EC3C
 dw #EC3F
 dw #EC9F
 dw #ECA4
 dw #ED04
 dw #ED05
 dw #ED06
 dw #F440
 dw #F49F
 dw #F505
 dw #F506
 db #01 : db 6
 dw #CB75
 dw #CDC0
 dw #D507
 dw #DCA4
 dw #ED07
 dw #F314
 db #03 : db 2
 dw #C507
 dw #D4A4
 db #07 : db 5
 dw #CCA4
 dw #E626
 dw #F441
 dw #F4A5
 dw #FDC2
 db #0F : db 28
 dw #C377
 dw #C569
 dw #C56A
 dw #CBE4
 dw #CCFF
 dw #CD6A
 dw #CE25
 dw #D318
 dw #D319
 dw #D443
 dw #D4FF
 dw #D5C1
 dw #DBE1
 dw #DD69
 dw #E50A
 dw #EB1C
 dw #ED0A
 dw #ED68
 dw #EE27
 dw #F376
 dw #F4A9
 dw #F509
 dw #F5C2
 dw #FB1D
 dw #FBE1
 dw #FCA9
 dw #FD09
 dw #FDC8
 db #11 : db 8
 dw #C4A3
 dw #CE24
 dw #D316
 dw #D5C0
 dw #E4A4
 dw #EC40
 dw #EE26
 dw #F5C1
 db #1E : db 2
 dw #E3E1
 dw #EBE1
 db #1F : db 10
 dw #CD6B
 dw #DB1B
 dw #DB77
 dw #DC9D
 dw #DD01
 dw #ED02
 dw #FB16
 dw #FB82
 dw #FC9E
 dw #FD68
 db #23 : db 4
 dw #DE25
 dw #E315
 dw #EDC1
 dw #FC41
 db #2F : db 11
 dw #C3E4
 dw #C56B
 dw #D31A
 dw #D377
 dw #D49D
 dw #D501
 dw #D50B
 dw #E317
 dw #E381
 dw #F49E
 dw #F50A
 db #33 : db 2
 dw #DC3F
 dw #FE28
 db #3F : db 2
 dw #DB81
 dw #F31D
 db #47 : db 7
 dw #C55D
 dw #D625
 dw #DB16
 dw #E440
 dw #E5C1
 dw #FB74
 dw #FCA5
 db #4B : db 3
 dw #D445
 dw #D561
 dw #F49C
 db #4C : db 3
 dw #EB1D
 dw #EB82
 dw #FB1E
 db #4F : db 7
 dw #CB7C
 dw #CBDE
 dw #DB7C
 dw #EB19
 dw #EB7C
 dw #FB1A
 dw #FB7C
 db #5F : db 5
 dw #CC3F
 dw #DD0B
 dw #DD6B
 dw #DE2B
 dw #FD04
 db #67 : db 2
 dw #F507
 dw #F627
 db #6E : db 3
 dw #DBE5
 dw #DD02
 dw #ED03
 db #78 : db 1
 dw #D3E2
 db #7F : db 12
 dw #CD01
 dw #CE2C
 dw #EC9E
 dw #ED0B
 dw #EDCB
 dw #FB18
 dw #FB77
 dw #FC3B
 dw #FCAA
 dw #FD05
 dw #FD6A
 dw #FE2A
 db #87 : db 4
 dw #CC45
 dw #CD61
 dw #DBE3
 dw #DCFF
 db #88 : db 6
 dw #CB81
 dw #CC9E
 dw #DB1C
 dw #E503
 dw #E62E
 dw #FE2C
 db #8C : db 1
 dw #F382
 db #8F : db 10
 dw #C37D
 dw #C568
 dw #D317
 dw #D37D
 dw #DDC1
 dw #E37D
 dw #EB15
 dw #ECA5
 dw #F31B
 dw #F37D
 db #A5 : db 1
 dw #CBE2
 db #AE : db 2
 dw #C501
 dw #E49E
 db #AF : db 9
 dw #C49D
 dw #C566
 dw #C567
 dw #D567
 dw #E31A
 dw #E3DE
 dw #E502
 dw #F3DE
 dw #F503
 db #BF : db 3
 dw #C380
 dw #E31C
 dw #E43B
 db #C3 : db 4
 dw #C445
 dw #E3E3
 dw #E4FF
 dw #EBE3
 db #CC : db 6
 dw #C448
 dw #D31B
 dw #D49E
 dw #D502
 dw #DC9E
 dw #FC9F
 db #D2 : db 2
 dw #C561
 dw #F4FF
 db #DF : db 2
 dw #FB19
 dw #FE29
 db #E1 : db 2
 dw #EC9B
 dw #FBE3
 db #EE : db 2
 dw #DC3C
 dw #F504
 db #EF : db 2
 dw #D43E
 dw #FD06
 db #F0 : db 4
 dw #CC44
 dw #CCFD
 dw #F4FE
 dw #FC9B
 db #FF : db 10
 dw #CB18
 dw #CB19
 dw #CB7B
 dw #CBDD
 dw #D43D
 dw #DB7B
 dw #DC3B
 dw #EB7B
 dw #FB17
 dw #FB7B
; Taille bloc delta = 514 octets
 DW #0000

; Delta frame 54 -> frame 55
Delta_54_55:
 db #00 : db 22
 dw #C4A3
 dw #C567
 dw #CC3E
 dw #D43D
 dw #D43E
 dw #D43F
 dw #D502
 dw #DC3C
 dw #DC3F
 dw #DCA4
 dw #DD02
 dw #E440
 dw #E4A4
 dw #E503
 dw #EC40
 dw #ED03
 dw #F504
 dw #FC41
 dw #FC9F
 dw #FD04
 dw #FD05
 dw #FD06
 db #01 : db 4
 dw #D4A4
 dw #DD5D
 dw #EB74
 dw #F441
 db #03 : db 6
 dw #CCA4
 dw #D375
 dw #EC41
 dw #FB74
 dw #FCA5
 dw #FD07
 db #07 : db 1
 dw #ECA5
 db #0F : db 26
 dw #C443
 dw #C50B
 dw #C56B
 dw #CB18
 dw #CB19
 dw #CB77
 dw #CB80
 dw #CBE2
 dw #CD0B
 dw #CD6B
 dw #D317
 dw #D3E1
 dw #D561
 dw #D569
 dw #D56A
 dw #DB1B
 dw #DCFF
 dw #DD6A
 dw #E3E1
 dw #EBE1
 dw #EC9C
 dw #ED69
 dw #F3E1
 dw #F50A
 dw #FB76
 dw #FD68
 db #11 : db 3
 dw #C4FA
 dw #C568
 dw #C68B
 db #1E : db 3
 dw #C4FC
 dw #D560
 dw #F49A
 db #1F : db 11
 dw #CD00
 dw #DB81
 dw #DD0B
 dw #DD6B
 dw #EC3A
 dw #EC9D
 dw #ED01
 dw #ED6A
 dw #EDC9
 dw #FD02
 dw #FD0A
 db #23 : db 6
 dw #C507
 dw #D316
 dw #D55D
 dw #F314
 dw #F3D5
 dw #F507
 db #2E : db 1
 dw #EB1D
 db #2F : db 10
 dw #C564
 dw #C56C
 dw #D500
 dw #D565
 dw #D56B
 dw #E43A
 dw #E49D
 dw #E50B
 dw #E566
 dw #F31D
 db #33 : db 3
 dw #CB17
 dw #DC40
 dw #EE26
 db #3C : db 2
 dw #CC44
 dw #CD60
 db #3F : db 2
 dw #C380
 dw #E3E5
 db #47 : db 2
 dw #C4A4
 dw #F4A5
 db #4B : db 3
 dw #C561
 dw #D3E3
 dw #E4FF
 db #4C : db 2
 dw #CB81
 dw #CBE5
 db #4F : db 1
 dw #DBDE
 db #55 : db 1
 dw #C68C
 db #5A : db 1
 dw #D3E2
 db #5F : db 10
 dw #CD66
 dw #CD6C
 dw #CDCB
 dw #EB19
 dw #ED0B
 dw #ED6B
 dw #FB18
 dw #FD6A
 dw #FDCA
 dw #FE29
 db #67 : db 2
 dw #C624
 dw #E315
 db #6E : db 5
 dw #DB1C
 dw #EC9E
 dw #ED02
 dw #FB1E
 dw #FD03
 db #78 : db 7
 dw #C444
 dw #C560
 dw #DBE2
 dw #DCFD
 dw #E3E2
 dw #E4FD
 dw #F3E2
 db #7F : db 12
 dw #CB1A
 dw #CBD9
 dw #CC9D
 dw #CD0C
 dw #CDCC
 dw #DD01
 dw #DD6C
 dw #DE2B
 dw #FB17
 dw #FC9E
 dw #FD0B
 dw #FD6B
 db #87 : db 3
 dw #ECFF
 dw #F49C
 dw #FC9C
 db #88 : db 8
 dw #C3E5
 dw #C501
 dw #CB1B
 dw #CC3D
 dw #D49E
 dw #DC9E
 dw #E382
 dw #F503
 db #8C : db 1
 dw #D3E5
 db #8F : db 11
 dw #C3DF
 dw #C569
 dw #D4FB
 dw #D568
 dw #D625
 dw #DB16
 dw #E441
 dw #E4A5
 dw #E626
 dw #FC42
 dw #FDC2
 db #AE : db 4
 dw #D381
 dw #D501
 dw #F382
 dw #F49E
 db #AF : db 9
 dw #C500
 dw #C565
 dw #D31A
 dw #D49D
 dw #D566
 dw #E31C
 dw #E501
 dw #E567
 dw #F502
 db #BF : db 2
 dw #D31B
 dw #D50C
 db #C3 : db 3
 dw #C4FE
 dw #F4FF
 dw #FCFF
 db #CC : db 6
 dw #CD01
 dw #D43C
 dw #E31D
 dw #E49E
 dw #E502
 dw #F31E
 db #E1 : db 3
 dw #CC45
 dw #CCFE
 dw #EBE3
 db #F0 : db 3
 dw #C445
 dw #EC9B
 dw #F3E3
 db #FF : db 6
 dw #C566
 dw #CC3F
 dw #DBDD
 dw #EDCB
 dw #EE2B
 dw #FE28
; Taille bloc delta = 486 octets
 DW #0000

; Delta frame 55 -> frame 56
Delta_55_56:
 db #00 : db 20
 dw #C43D
 dw #C43E
 dw #C501
 dw #C566
 dw #C568
 dw #CC3D
 dw #CC3F
 dw #CC9E
 dw #CD01
 dw #CD66
 dw #CD67
 dw #D43C
 dw #D49E
 dw #D4A4
 dw #DC40
 dw #E502
 dw #EC41
 dw #F441
 dw #F503
 dw #FD03
 db #01 : db 3
 dw #C4A4
 dw #CE24
 dw #F5C1
 db #03 : db 7
 dw #C5C0
 dw #CD5D
 dw #DE25
 dw #EDC1
 dw #F3D5
 dw #F4A5
 dw #FC42
 db #07 : db 4
 dw #C569
 dw #E4A5
 dw #E5C1
 dw #F442
 db #0F : db 24
 dw #C3D8
 dw #CB1A
 dw #CBD8
 dw #CDCA
 dw #D377
 dw #D4FB
 dw #D56B
 dw #DD6B
 dw #DDC9
 dw #E317
 dw #E381
 dw #E4FF
 dw #E569
 dw #E56A
 dw #EB17
 dw #ECFF
 dw #ED5E
 dw #ED6A
 dw #F316
 dw #F49C
 dw #F4FF
 dw #FB16
 dw #FD0A
 dw #FD69
 db #11 : db 7
 dw #C43F
 dw #CCA4
 dw #CD68
 dw #D440
 dw #DB15
 dw #E625
 dw #EB74
 db #1E : db 4
 dw #C55F
 dw #D3E2
 dw #D444
 dw #E49A
 db #1F : db 10
 dw #CD64
 dw #CD6C
 dw #DB1C
 dw #DD00
 dw #DD65
 dw #EB1D
 dw #EB77
 dw #ED0B
 dw #FC9D
 dw #FD01
 db #23 : db 5
 dw #CDC0
 dw #DD07
 dw #E441
 dw #ED07
 dw #EE26
 db #27 : db 1
 dw #F627
 db #2F : db 9
 dw #C378
 dw #C380
 dw #C563
 dw #D564
 dw #E377
 dw #E500
 dw #F43A
 dw #F49D
 dw #F566
 db #3C : db 4
 dw #DBE2
 dw #EBE2
 dw #FBE2
 dw #FCFD
 db #3F : db 1
 dw #F382
 db #47 : db 4
 dw #C624
 dw #DC41
 dw #ECA5
 dw #FB74
 db #4B : db 3
 dw #D49B
 dw #D561
 dw #E49B
 db #55 : db 2
 dw #C318
 dw #C68B
 db #5A : db 4
 dw #C444
 dw #D560
 dw #E445
 dw #F4FD
 db #5F : db 9
 dw #CB78
 dw #CB7C
 dw #CDCC
 dw #DD66
 dw #DD6C
 dw #DDCB
 dw #DE2B
 dw #FB1E
 dw #FD6B
 db #67 : db 2
 dw #CC40
 dw #D316
 db #6E : db 3
 dw #CB1B
 dw #CB81
 dw #EB82
 db #7F : db 10
 dw #CD00
 dw #CD65
 dw #CD6D
 dw #DB78
 dw #DC9D
 dw #DDCC
 dw #ED01
 dw #EDCB
 dw #EE2B
 dw #FD02
 db #87 : db 3
 dw #CC46
 dw #FBE4
 dw #FCFF
 db #88 : db 7
 dw #D501
 dw #DB1D
 dw #DB82
 dw #E49E
 dw #EB1E
 dw #ED02
 dw #F3E6
 db #8C : db 1
 dw #F49E
 db #8F : db 4
 dw #D3DF
 dw #D441
 dw #DCA5
 dw #E568
 db #AE : db 2
 dw #E31D
 dw #E501
 db #AF : db 14
 dw #C37D
 dw #C440
 dw #C564
 dw #D31B
 dw #D37D
 dw #D500
 dw #D565
 dw #E37D
 dw #E49D
 dw #E565
 dw #E566
 dw #F31B
 dw #F501
 dw #F567
 db #BF : db 5
 dw #C43C
 dw #C49D
 dw #C500
 dw #D381
 dw #D566
 db #C3 : db 2
 dw #CCFE
 dw #D4FE
 db #CC : db 9
 dw #C31A
 dw #C381
 dw #C565
 dw #CC3C
 dw #D31C
 dw #DD01
 dw #E382
 dw #EC9E
 dw #F502
 db #CF : db 2
 dw #CB17
 dw #D568
 db #DD : db 1
 dw #D567
 db #DF : db 3
 dw #DB7C
 dw #EB7C
 dw #FE28
 db #E1 : db 4
 dw #DBE3
 dw #DC45
 dw #DCFE
 dw #EC9B
 db #EE : db 2
 dw #F31E
 dw #FC9E
 db #F0 : db 7
 dw #C4FD
 dw #CC45
 dw #D445
 dw #DCFD
 dw #E3E3
 dw #EBE3
 dw #FBE3
 db #FF : db 6
 dw #C319
 dw #CE2C
 dw #EBDD
 dw #EC3B
 dw #FB18
 dw #FE2A
; Taille bloc delta = 492 octets
 DW #0000

; Delta frame 56 -> frame 57
Delta_56_57:
 db #00 : db 19
 dw #C43F
 dw #C565
 dw #CC40
 dw #CCA4
 dw #CD65
 dw #CD68
 dw #D440
 dw #D501
 dw #D566
 dw #D567
 dw #DC9E
 dw #E441
 dw #E49E
 dw #ED02
 dw #F3DC
 dw #F502
 dw #FBDB
 dw #FBDC
 dw #FBDD
 db #01 : db 4
 dw #D568
 dw #D5C0
 dw #EB74
 dw #FC42
 db #03 : db 2
 dw #ECA5
 dw #F507
 db #07 : db 2
 dw #CC41
 dw #D4A5
 db #0F : db 30
 dw #C319
 dw #C4FE
 dw #C561
 dw #C56C
 dw #CC44
 dw #CD61
 dw #CD6C
 dw #CDCB
 dw #D3D8
 dw #D3E2
 dw #D50B
 dw #D561
 dw #DB16
 dw #DB1C
 dw #DB77
 dw #DBD8
 dw #DBE2
 dw #DD0B
 dw #DDC1
 dw #E568
 dw #E56B
 dw #EB15
 dw #ED6B
 dw #F568
 dw #F569
 dw #F56A
 dw #FC9C
 dw #FCFF
 dw #FD6A
 dw #FDC2
 db #11 : db 7
 dw #C317
 dw #C440
 dw #C4A4
 dw #DC41
 dw #DD67
 dw #F626
 dw #FE27
 db #1E : db 6
 dw #C444
 dw #D4FC
 dw #E3E2
 dw #EBE2
 dw #F3E2
 dw #FBE2
 db #1F : db 13
 dw #CB1B
 dw #CB78
 dw #CC9C
 dw #CCFF
 dw #CD63
 dw #DD6C
 dw #DDCA
 dw #EB18
 dw #ED00
 dw #ED65
 dw #FB1E
 dw #FC3A
 dw #FD0B
 db #23 : db 6
 dw #CE24
 dw #D441
 dw #E507
 dw #F442
 dw #F4A5
 dw #FCA5
 db #2F : db 9
 dw #C49C
 dw #C4FF
 dw #D31A
 dw #D4FF
 dw #D563
 dw #D56C
 dw #E628
 dw #F500
 dw #F50B
 db #44 : db 1
 dw #C31B
 db #47 : db 7
 dw #DCA5
 dw #DE25
 dw #E315
 dw #E4A5
 dw #EC42
 dw #EE26
 dw #FD07
 db #4B : db 1
 dw #E446
 db #4C : db 2
 dw #DB1D
 dw #EB1E
 db #4F : db 3
 dw #EB1A
 dw #EBDE
 dw #ED66
 db #5F : db 6
 dw #DD64
 dw #DD65
 dw #DDCC
 dw #FB17
 dw #FB1A
 dw #FB77
 db #67 : db 1
 dw #F3DD
 db #78 : db 4
 dw #CD60
 dw #D445
 dw #E445
 dw #ECFD
 db #7F : db 11
 dw #CD64
 dw #CDCD
 dw #CE2C
 dw #DBD9
 dw #DD00
 dw #DD0C
 dw #EC9D
 dw #ED6C
 dw #FB19
 dw #FD01
 dw #FE2A
 db #87 : db 6
 dw #CCFE
 dw #D4FE
 dw #DC46
 dw #DC9B
 dw #EBE4
 dw #F3E4
 db #88 : db 10
 dw #CB1C
 dw #CC3C
 dw #D43C
 dw #DD01
 dw #EBE6
 dw #EC9E
 dw #F49E
 dw #FB1F
 dw #FB83
 dw #FD02
 db #8C : db 3
 dw #C43C
 dw #C500
 dw #E382
 db #8F : db 7
 dw #C37E
 dw #CCA5
 dw #DD68
 dw #E3DF
 dw #E442
 dw #F31C
 dw #F55E
 db #A5 : db 1
 dw #DBE3
 db #AE : db 1
 dw #D3E5
 db #AF : db 11
 dw #C563
 dw #C5C8
 dw #D381
 dw #D564
 dw #E500
 dw #E564
 dw #F37D
 dw #F49D
 dw #F565
 dw #F566
 dw #F627
 db #BF : db 6
 dw #C31A
 dw #D31C
 dw #D500
 dw #E31D
 dw #F31E
 dw #F501
 db #C3 : db 5
 dw #C446
 dw #CC46
 dw #D446
 dw #DCFE
 dw #E4FE
 db #CC : db 6
 dw #C3E5
 dw #C564
 dw #D565
 dw #DD66
 dw #E501
 dw #FC9E
 db #CF : db 1
 dw #FBDE
 db #DF : db 2
 dw #CB7C
 dw #FB7C
 db #E1 : db 3
 dw #ECFE
 dw #F4FE
 dw #FCFE
 db #EE : db 2
 dw #CD00
 dw #ED01
 db #EF : db 1
 dw #C318
 db #F0 : db 3
 dw #C560
 dw #DC45
 dw #F49B
 db #FF : db 3
 dw #EE2B
 dw #F3DB
 dw #FC3B
; Taille bloc delta = 484 octets
 DW #0000

; Delta frame 57 -> frame 58
Delta_57_58:
 db #00 : db 18
 dw #C440
 dw #C4A4
 dw #C564
 dw #D441
 dw #D565
 dw #DC41
 dw #DD01
 dw #DD66
 dw #DD67
 dw #E501
 dw #E566
 dw #EBDC
 dw #EC9E
 dw #F3DB
 dw #F3DD
 dw #FBDE
 dw #FC42
 dw #FD02
 db #01 : db 3
 dw #C507
 dw #CC41
 dw #EC42
 db #03 : db 2
 dw #DCA5
 dw #ED07
 db #07 : db 4
 dw #C4A5
 dw #C624
 dw #CCA5
 dw #FD07
 db #0F : db 26
 dw #C31A
 dw #C378
 dw #C5CA
 dw #C5CB
 dw #C5CC
 dw #CB1B
 dw #CCFE
 dw #CDCC
 dw #D31A
 dw #D3E3
 dw #D444
 dw #D49B
 dw #D4FE
 dw #D56C
 dw #DBE3
 dw #DCFB
 dw #DDCA
 dw #E377
 dw #E3E2
 dw #E626
 dw #EB18
 dw #EB1A
 dw #EBE2
 dw #EDC9
 dw #F3E2
 dw #FBE2
 db #11 : db 2
 dw #EBDD
 dw #F442
 db #1E : db 6
 dw #CCFC
 dw #D49A
 dw #E4FC
 dw #EC9A
 dw #F445
 dw #FC9A
 db #1F : db 10
 dw #CD62
 dw #DC9C
 dw #DCFF
 dw #DDCB
 dw #EDCA
 dw #FB17
 dw #FB77
 dw #FD65
 dw #FD6B
 dw #FDC9
 db #23 : db 6
 dw #E442
 dw #E4A5
 dw #E567
 dw #ECA5
 dw #F3D5
 dw #F3DE
 db #2F : db 14
 dw #C562
 dw #D31B
 dw #D49C
 dw #D5C7
 dw #E318
 dw #E3E5
 dw #E49C
 dw #E4FF
 dw #E563
 dw #E56C
 dw #F317
 dw #F377
 dw #F382
 dw #F56B
 db #3C : db 1
 dw #EC45
 db #47 : db 7
 dw #C437
 dw #C5C0
 dw #D316
 dw #D4A5
 dw #DC42
 dw #DD68
 dw #F507
 db #4B : db 2
 dw #D560
 dw #F446
 db #4C : db 1
 dw #CB1C
 db #4F : db 2
 dw #CB7D
 dw #DB7D
 db #5A : db 1
 dw #E3E3
 db #5F : db 10
 dw #CCFF
 dw #DB78
 dw #DD63
 dw #ED64
 dw #ED65
 dw #ED6C
 dw #EDCB
 dw #FB18
 dw #FB19
 dw #FD00
 db #67 : db 1
 dw #C441
 db #6E : db 3
 dw #CBE5
 dw #DB1D
 dw #EB1E
 db #78 : db 4
 dw #C445
 dw #DC45
 dw #F3E3
 dw #F4FD
 db #7F : db 16
 dw #CB79
 dw #CB81
 dw #CD63
 dw #DBE5
 dw #DD64
 dw #DD6D
 dw #DDCD
 dw #DE2B
 dw #EB78
 dw #EB82
 dw #ED00
 dw #EDCC
 dw #EE2B
 dw #FC9D
 dw #FD6C
 dw #FDCB
 db #87 : db 2
 dw #DCFE
 dw #ECFE
 db #88 : db 7
 dw #CD64
 dw #D31D
 dw #D382
 dw #DD65
 dw #E31E
 dw #ED01
 dw #FC9E
 db #8F : db 6
 dw #C318
 dw #CB17
 dw #D37E
 dw #D442
 dw #E37E
 dw #FBDF
 db #AE : db 4
 dw #C381
 dw #D500
 dw #D564
 dw #E382
 db #AF : db 8
 dw #C3DF
 dw #C4FF
 dw #C5C7
 dw #D563
 dw #D5C8
 dw #E31D
 dw #F500
 dw #F564
 db #BF : db 5
 dw #C563
 dw #D49D
 dw #E3DC
 dw #E500
 dw #E565
 db #C3 : db 8
 dw #C560
 dw #E446
 dw #EC46
 dw #EC9B
 dw #F49B
 dw #F4FE
 dw #FBE4
 dw #FCFE
 db #CC : db 8
 dw #C31B
 dw #C43C
 dw #C500
 dw #CD00
 dw #DB82
 dw #F501
 dw #FB1F
 dw #FBE6
 db #CF : db 1
 dw #EBDE
 db #DD : db 1
 dw #C68C
 db #DF : db 1
 dw #CBDE
 db #E1 : db 4
 dw #CC46
 dw #CD60
 dw #DC46
 dw #FC9B
 db #EE : db 4
 dw #DD00
 dw #EBDB
 dw #FBDA
 dw #FD01
 db #F0 : db 1
 dw #D4FD
 db #FF : db 3
 dw #CC9D
 dw #DC9D
 dw #FE2A
; Taille bloc delta = 478 octets
 DW #0000

; Delta frame 58 -> frame 59
Delta_58_59:
 db #00 : db 13
 dw #CC41
 dw #CD64
 dw #DD65
 dw #E3DC
 dw #E3DD
 dw #EBDD
 dw #EC42
 dw #ED01
 dw #F3DE
 dw #F442
 dw #F49E
 dw #F501
 dw #FC9E
 db #01 : db 5
 dw #CD07
 dw #E4A5
 dw #ECA5
 dw #F4A5
 dw #FCA5
 db #03 : db 2
 dw #CCA5
 dw #D442
 db #07 : db 4
 dw #C437
 dw #CC42
 dw #FC43
 dw #FD5E
 db #0F : db 26
 dw #C444
 dw #CB78
 dw #CE2A
 dw #D31B
 dw #D5CA
 dw #D5CB
 dw #DC9B
 dw #DCFE
 dw #DD6C
 dw #DDCB
 dw #E318
 dw #E3D8
 dw #E3E3
 dw #E4FE
 dw #E50B
 dw #EB19
 dw #EB77
 dw #EBD8
 dw #EBE4
 dw #EDCA
 dw #F317
 dw #F3E4
 dw #F56B
 dw #FB17
 dw #FD6B
 dw #FDC9
 db #11 : db 7
 dw #C441
 dw #C68A
 dw #CD68
 dw #D624
 dw #E442
 dw #E567
 dw #EBDE
 db #1E : db 3
 dw #C4A7
 dw #D55F
 dw #DCFC
 db #1F : db 10
 dw #CDCD
 dw #DB78
 dw #DD62
 dw #DDCC
 dw #EC9C
 dw #ECFF
 dw #ED6C
 dw #EDCB
 dw #EE29
 dw #FCFF
 db #23 : db 5
 dw #D4A5
 dw #D568
 dw #DC42
 dw #DCA5
 dw #FBDF
 db #2D : db 1
 dw #EBE3
 db #2F : db 11
 dw #C3D9
 dw #C56D
 dw #C5CD
 dw #D378
 dw #D5C6
 dw #D5CC
 dw #E319
 dw #E562
 dw #E5C7
 dw #F49C
 dw #F4FF
 db #3C : db 5
 dw #CC45
 dw #CD5F
 dw #DC45
 dw #FBE3
 dw #FC9A
 db #47 : db 2
 dw #C4A5
 dw #F3DF
 db #4B : db 3
 dw #C4A8
 dw #C560
 dw #F4FE
 db #4C : db 1
 dw #FB1F
 db #4F : db 3
 dw #EB7D
 dw #FB7D
 dw #FD66
 db #5A : db 1
 dw #F3E3
 db #5F : db 12
 dw #CB79
 dw #CB81
 dw #CBD9
 dw #CD6D
 dw #CE2C
 dw #DB1D
 dw #DE2B
 dw #ED63
 dw #EDCC
 dw #FD64
 dw #FD65
 dw #FDCB
 db #6E : db 2
 dw #CB1C
 dw #CC48
 db #77 : db 1
 dw #C68B
 db #78 : db 2
 dw #C55F
 dw #FCFD
 db #7F : db 8
 dw #CCFF
 dw #CD62
 dw #DCFF
 dw #EBD9
 dw #EC48
 dw #ED64
 dw #FD00
 dw #FE2A
 db #87 : db 4
 dw #CD60
 dw #EC9B
 dw #FBE4
 dw #FCFE
 db #88 : db 8
 dw #C500
 dw #CD00
 dw #D564
 dw #DC3C
 dw #E565
 dw #F383
 dw #FAB8
 dw #FD01
 db #8C : db 3
 dw #C3E5
 dw #C448
 dw #C563
 db #8F : db 7
 dw #C569
 dw #C5C9
 dw #D5C9
 dw #ECFB
 dw #F37E
 dw #F443
 dw #F567
 db #AE : db 4
 dw #C49D
 dw #D448
 dw #E500
 dw #E50C
 db #AF : db 17
 dw #C4AA
 dw #C562
 dw #C5C6
 dw #D31C
 dw #D3DF
 dw #D4FF
 dw #D562
 dw #D5C7
 dw #D62E
 dw #E43B
 dw #E4FF
 dw #E563
 dw #E5C8
 dw #F31C
 dw #F31D
 dw #F31E
 dw #F563
 db #BF : db 5
 dw #C31B
 dw #E3DB
 dw #E49D
 dw #E564
 dw #F3DA
 db #CC : db 6
 dw #D31D
 dw #D500
 dw #DD00
 dw #E31E
 dw #EBDB
 dw #FB83
 db #CF : db 1
 dw #ED67
 db #D2 : db 1
 dw #C4FD
 db #DF : db 2
 dw #DBDE
 dw #DD63
 db #E1 : db 5
 dw #CCFD
 dw #D446
 dw #E446
 dw #EC46
 dw #FC46
 db #EE : db 4
 dw #CC9D
 dw #DC9D
 dw #DD64
 dw #FC3B
 db #EF : db 1
 dw #E3DE
 db #F0 : db 3
 dw #E4FD
 dw #ECFD
 dw #F446
 db #FF : db 8
 dw #CD63
 dw #DB7C
 dw #EB7C
 dw #EC9D
 dw #ED00
 dw #ED65
 dw #ED66
 dw #FAB7
; Taille bloc delta = 490 octets
 DW #0000

; Delta frame 59 -> frame 60
Delta_59_60:
 db #00 : db 13
 dw #C441
 dw #C500
 dw #C68A
 dw #D564
 dw #DBDD
 dw #DC42
 dw #E442
 dw #E565
 dw #E56E
 dw #EBDE
 dw #ED66
 dw #FBDF
 dw #FD01
 db #01 : db 5
 dw #CD68
 dw #D442
 dw #D4A5
 dw #DCA5
 dw #F3DF
 db #03 : db 1
 dw #FC43
 db #07 : db 3
 dw #DD68
 dw #EC43
 dw #F507
 db #0F : db 21
 dw #C560
 dw #C569
 dw #C5C9
 dw #C5CD
 dw #CD60
 dw #D378
 dw #D560
 dw #D5C9
 dw #D5CC
 dw #DDCC
 dw #E319
 dw #E5C9
 dw #E5CA
 dw #E5CB
 dw #EBE3
 dw #ECFE
 dw #EDCB
 dw #F377
 dw #F4FE
 dw #F567
 dw #FD66
 db #11 : db 2
 dw #CB16
 dw #E3DE
 db #1E : db 7
 dw #C445
 dw #D445
 dw #E445
 dw #ECFC
 dw #F3E3
 dw #F4FC
 dw #FBE3
 db #1F : db 9
 dw #CB79
 dw #CBD9
 dw #CCFE
 dw #CD61
 dw #EBD8
 dw #ED62
 dw #FB18
 dw #FC9C
 dw #FDCA
 db #23 : db 3
 dw #C4A5
 dw #CC42
 dw #CCA5
 db #2D : db 2
 dw #CD5F
 dw #DC9A
 db #2F : db 14
 dw #C379
 dw #C447
 dw #C4FE
 dw #C561
 dw #D4FE
 dw #D561
 dw #E31A
 dw #E378
 dw #E381
 dw #E5C6
 dw #F318
 dw #F562
 dw #F56C
 dw #F5C7
 db #33 : db 1
 dw #FE27
 db #3C : db 5
 dw #C4FC
 dw #CCFC
 dw #DCFC
 dw #EC9A
 dw #F49A
 db #3F : db 1
 dw #C31B
 db #47 : db 4
 dw #C442
 dw #EBDF
 dw #ED07
 dw #F443
 db #4F : db 1
 dw #CBDF
 db #55 : db 1
 dw #C68B
 db #5A : db 2
 dw #C55F
 dw #D4A8
 db #5F : db 11
 dw #CC9C
 dw #CDC6
 dw #CDC7
 dw #DC9C
 dw #DE2C
 dw #EB78
 dw #EC3A
 dw #EE29
 dw #FC3A
 dw #FD63
 dw #FD6C
 db #6E : db 3
 dw #DB82
 dw #ED0C
 dw #FB1F
 db #78 : db 1
 dw #C4A8
 db #7F : db 10
 dw #CB1C
 dw #CB7B
 dw #CDCE
 dw #CE2D
 dw #DB79
 dw #DD62
 dw #EB1E
 dw #ECFF
 dw #FB78
 dw #FDCC
 db #87 : db 1
 dw #DC9B
 db #88 : db 9
 dw #C563
 dw #CB82
 dw #D500
 dw #DB1E
 dw #DD00
 dw #DD64
 dw #E3E6
 dw #EBDB
 dw #F31F
 db #8C : db 1
 dw #C43C
 db #8F : db 6
 dw #C3E0
 dw #DCFB
 dw #E31B
 dw #E443
 dw #FBE0
 dw #FD07
 db #AE : db 5
 dw #D49D
 dw #D563
 dw #E3DB
 dw #E49D
 dw #F500
 db #AF : db 10
 dw #C37E
 dw #C380
 dw #C49C
 dw #C5C5
 dw #D37E
 dw #D5C6
 dw #E562
 dw #E5C7
 dw #F382
 dw #F4FF
 db #BF : db 6
 dw #C381
 dw #D3E5
 dw #D62E
 dw #E382
 dw #E448
 dw #F49D
 db #C3 : db 4
 dw #C4FD
 dw #CC46
 dw #D446
 dw #EC9B
 db #CC : db 8
 dw #CC3C
 dw #CD63
 dw #D382
 dw #DBDC
 dw #E500
 dw #E564
 dw #ED65
 dw #F3E6
 db #DF : db 1
 dw #CB7A
 db #E1 : db 2
 dw #CCA8
 dw #DCFD
 db #EE : db 3
 dw #EC9D
 dw #ED00
 dw #FAB8
 db #F0 : db 5
 dw #E446
 dw #EC46
 dw #F4FD
 dw #FC46
 dw #FCFD
 db #FF : db 8
 dw #CCFF
 dw #CD62
 dw #DBDE
 dw #DD63
 dw #ED64
 dw #FB7C
 dw #FC9D
 dw #FD00
; Taille bloc delta = 452 octets
 DW #0000

; Delta frame 60 -> frame 61
Delta_60_61:
 db #00 : db 9
 dw #C563
 dw #CD00
 dw #D442
 dw #D500
 dw #DBDE
 dw #DD64
 dw #E3DE
 dw #ED65
 dw #F3DF
 db #01 : db 3
 dw #C442
 dw #C4A5
 dw #CCA5
 db #03 : db 4
 dw #E507
 dw #EC43
 dw #F3D5
 dw #FBE0
 db #07 : db 2
 dw #DC43
 dw #F3E0
 db #0F : db 23
 dw #C379
 dw #C446
 dw #CC45
 dw #CDCD
 dw #CE2B
 dw #DB78
 dw #DC45
 dw #DCFB
 dw #E31A
 dw #E31B
 dw #E56C
 dw #EBD8
 dw #EC45
 dw #F318
 dw #F3E3
 dw #F5C9
 dw #F5CA
 dw #FB18
 dw #FB77
 dw #FBE3
 dw #FBE4
 dw #FCFE
 dw #FDCA
 db #11 : db 8
 dw #C568
 dw #CC42
 dw #DCA5
 dw #E4A5
 dw #EBDF
 dw #ECA5
 dw #F4A5
 dw #FCA5
 db #1E : db 1
 dw #C49A
 db #1F : db 13
 dw #CBE4
 dw #CC47
 dw #CD6D
 dw #DCFE
 dw #DD61
 dw #DE2A
 dw #EB78
 dw #ECFE
 dw #EDCC
 dw #EE29
 dw #FD62
 dw #FD6C
 dw #FDCB
 db #23 : db 4
 dw #CD68
 dw #E567
 dw #F443
 dw #FC43
 db #2F : db 8
 dw #C5C4
 dw #D5CD
 dw #E31C
 dw #E4FE
 dw #E561
 dw #E5CC
 dw #F4FE
 dw #F5CB
 db #3C : db 1
 dw #DC9A
 db #3F : db 1
 dw #CB1C
 db #47 : db 3
 dw #D375
 dw #D568
 dw #E443
 db #4F : db 1
 dw #FB1A
 db #55 : db 1
 dw #D3DD
 db #5A : db 2
 dw #E49A
 dw #E4A8
 db #5F : db 14
 dw #CB7A
 dw #CB7B
 dw #CB7C
 dw #CD61
 dw #CDC5
 dw #CE2D
 dw #DB79
 dw #DDC6
 dw #DDCD
 dw #EC9C
 dw #ED62
 dw #FB1E
 dw #FC9C
 dw #FDCC
 db #67 : db 1
 dw #E3DF
 db #77 : db 1
 dw #C68B
 db #78 : db 5
 dw #C4FC
 dw #D4A8
 dw #D4FC
 dw #F49A
 dw #F4FD
 db #7F : db 8
 dw #CC3B
 dw #CC9C
 dw #DC9C
 dw #DE2C
 dw #EC3A
 dw #ED6D
 dw #FC3A
 dw #FCFF
 db #87 : db 3
 dw #CC46
 dw #CC9B
 dw #EC9B
 db #88 : db 5
 dw #C31C
 dw #CD63
 dw #DBDC
 dw #E500
 dw #EB83
 db #8C : db 1
 dw #F500
 db #8F : db 8
 dw #D443
 dw #DBDF
 dw #DD68
 dw #E5C8
 dw #ED67
 dw #F31C
 dw #F566
 dw #F5C8
 db #AE : db 2
 dw #C3E5
 dw #F49D
 db #AF : db 11
 dw #C561
 dw #D49C
 dw #D5C5
 dw #E37E
 dw #E3E5
 dw #E49C
 dw #E5C6
 dw #F43A
 dw #F49C
 dw #F562
 dw #F5C7
 db #BF : db 4
 dw #C4FF
 dw #C562
 dw #D3DC
 dw #E50C
 db #C3 : db 4
 dw #CCFD
 dw #D4FD
 dw #E49B
 dw #FC9B
 db #CC : db 3
 dw #D563
 dw #ED00
 dw #F31F
 db #DF : db 1
 dw #EB7D
 db #E1 : db 4
 dw #DCA8
 dw #E4FD
 dw #ECFD
 dw #FCFD
 db #EE : db 3
 dw #FB1F
 dw #FC9D
 dw #FD00
 db #EF : db 1
 dw #D3DE
 db #F0 : db 2
 dw #C4A8
 dw #CCA8
 db #FF : db 6
 dw #CBDE
 dw #DCFF
 dw #DD62
 dw #ED63
 dw #FAB8
 dw #FD64
; Taille bloc delta = 416 octets
 DW #0000

; Delta frame 61 -> frame 62
Delta_61_62:
 db #00 : db 11
 dw #C442
 dw #CC42
 dw #CD63
 dw #D3DD
 dw #DCA5
 dw #DD00
 dw #E4A5
 dw #E500
 dw #E564
 dw #EBDF
 dw #ECA5
 db #01 : db 4
 dw #C568
 dw #EC43
 dw #F443
 dw #FBE0
 db #03 : db 4
 dw #CD68
 dw #D375
 dw #DC43
 dw #FB74
 db #07 : db 3
 dw #D443
 dw #D568
 dw #EBE0
 db #0F : db 31
 dw #C3D9
 dw #C445
 dw #C4A7
 dw #C629
 dw #C62A
 dw #C62B
 dw #CB79
 dw #CB7D
 dw #CC46
 dw #CD5F
 dw #CE2C
 dw #D445
 dw #D55F
 dw #DD68
 dw #DE2A
 dw #E378
 dw #E5CC
 dw #ED0B
 dw #ED67
 dw #ED6C
 dw #F319
 dw #F31A
 dw #F31B
 dw #F31C
 dw #F3D8
 dw #F5C8
 dw #F5CB
 dw #FB19
 dw #FB1A
 dw #FD07
 dw #FDCB
 db #11 : db 10
 dw #C4A5
 dw #C507
 dw #C68A
 dw #CCA5
 dw #D3DE
 dw #D4A5
 dw #DD67
 dw #E3DF
 dw #FAB6
 dw #FC43
 db #1E : db 1
 dw #F438
 db #1F : db 11
 dw #CB1C
 dw #CB7A
 dw #CB80
 dw #CDC4
 dw #DB79
 dw #DBD9
 dw #DDC5
 dw #DDCD
 dw #DE2B
 dw #ED61
 dw #FCFE
 db #23 : db 4
 dw #DBDF
 dw #E443
 dw #F3D5
 dw #F3E0
 db #2F : db 11
 dw #C37A
 dw #C37F
 dw #C560
 dw #C62C
 dw #D379
 dw #D380
 dw #D3D9
 dw #D5C4
 dw #D629
 dw #F378
 dw #F561
 db #33 : db 1
 dw #ED66
 db #3C : db 1
 dw #CC9A
 db #4B : db 3
 dw #C50A
 dw #C55F
 dw #D446
 db #4F : db 2
 dw #CDC7
 dw #FD65
 db #55 : db 2
 dw #C68B
 dw #C68C
 db #5A : db 2
 dw #E446
 dw #F4A8
 db #5F : db 9
 dw #DB7C
 dw #DCFE
 dw #DE2C
 dw #EB7D
 dw #EBE5
 dw #EE2B
 dw #FB78
 dw #FB82
 dw #FD62
 db #67 : db 1
 dw #E567
 db #78 : db 3
 dw #D49A
 dw #E49A
 dw #E4A8
 db #7F : db 14
 dw #CB81
 dw #CBDA
 dw #CCFE
 dw #CD61
 dw #CE2E
 dw #DB7B
 dw #DD61
 dw #DE2D
 dw #EB79
 dw #EC9C
 dw #ED62
 dw #EDCD
 dw #FC9C
 dw #FDCC
 db #87 : db 9
 dw #C4FD
 dw #CCA9
 dw #CCFD
 dw #DC46
 dw #DCA9
 dw #E49B
 dw #F49B
 dw #FC47
 dw #FC9B
 db #88 : db 3
 dw #CB1D
 dw #DBE6
 dw #ED00
 db #8C : db 1
 dw #E49D
 db #8F : db 5
 dw #C37E
 dw #C5C8
 dw #CC43
 dw #D3E0
 dw #D5C8
 db #AE : db 2
 dw #C4FF
 dw #C562
 db #AF : db 12
 dw #C4FE
 dw #C5C4
 dw #D3E5
 dw #D4FE
 dw #D561
 dw #E43A
 dw #E561
 dw #E5C5
 dw #F37E
 dw #F3DA
 dw #F448
 dw #F5C6
 db #BF : db 2
 dw #D4FF
 dw #E563
 db #C3 : db 5
 dw #DCFD
 dw #E4FD
 dw #ECFD
 dw #F4FD
 dw #FCFD
 db #CC : db 3
 dw #C31C
 dw #F383
 dw #F500
 db #CF : db 1
 dw #FB7D
 db #DF : db 1
 dw #DB7A
 db #EE : db 5
 dw #CC48
 dw #CCFF
 dw #D31D
 dw #DD63
 dw #ED64
 db #F0 : db 2
 dw #DCA8
 dw #ECA8
 db #FF : db 5
 dw #CBE5
 dw #CC3B
 dw #ECFF
 dw #FCFF
 dw #FD63
; Taille bloc delta = 438 octets
 DW #0000

; Delta frame 62 -> frame 63
Delta_62_63:
 db #00 : db 12
 dw #C4A5
 dw #C68A
 dw #CCA5
 dw #D3DE
 dw #D4A5
 dw #E3DF
 dw #E62E
 dw #F4A5
 dw #FAB6
 dw #FBE0
 dw #FC43
 dw #FCA5
 db #01 : db 3
 dw #E443
 dw #E55D
 dw #F3E0
 db #03 : db 2
 dw #EBE0
 dw #F3D5
 db #07 : db 4
 dw #C443
 dw #E3E0
 dw #ED07
 dw #FB14
 db #0F : db 39
 dw #C37A
 dw #C37E
 dw #C4FD
 dw #C55F
 dw #C5C8
 dw #C62C
 dw #CB7A
 dw #CB7B
 dw #CB7C
 dw #CBD9
 dw #CC9B
 dw #CCFD
 dw #CDC7
 dw #D379
 dw #D446
 dw #D4FD
 dw #D5C8
 dw #D5CD
 dw #D629
 dw #D62A
 dw #DB79
 dw #DC46
 dw #DC9B
 dw #DE2B
 dw #E445
 dw #E49B
 dw #E4FD
 dw #E5C8
 dw #EB78
 dw #EC46
 dw #EC9B
 dw #EDCC
 dw #EE29
 dw #F445
 dw #F49B
 dw #F4FD
 dw #F566
 dw #FC47
 dw #FC9B
 db #11 : db 5
 dw #EB74
 dw #EC43
 dw #F443
 dw #FD06
 dw #FE27
 db #1E : db 1
 dw #C55E
 db #1F : db 7
 dw #CD60
 dw #DC47
 dw #DD60
 dw #EB81
 dw #ED0B
 dw #FB78
 dw #FD61
 db #23 : db 3
 dw #D443
 dw #DC43
 dw #DD67
 db #2D : db 1
 dw #CD0A
 db #2F : db 11
 dw #C37B
 dw #C5C3
 dw #C62D
 dw #D3E4
 dw #D447
 dw #D560
 dw #D56D
 dw #E5C4
 dw #F381
 dw #F5C5
 dw #F5CC
 db #33 : db 1
 dw #DBDF
 db #3C : db 3
 dw #E4FC
 dw #ECFC
 dw #FC38
 db #47 : db 3
 dw #CC43
 dw #CD68
 dw #FB74
 db #4B : db 1
 dw #E446
 db #5A : db 3
 dw #C50A
 dw #D50A
 dw #F446
 db #5F : db 9
 dw #CDC4
 dw #DB7A
 dw #DB7B
 dw #DB81
 dw #DDC5
 dw #EB79
 dw #ED61
 dw #FDCC
 dw #FE2A
 db #78 : db 7
 dw #C49A
 dw #C4A8
 dw #CCFC
 dw #DC9A
 dw #EC9A
 dw #F4A8
 dw #FC9A
 db #7F : db 6
 dw #CBE5
 dw #DCFE
 dw #EBE5
 dw #ECFE
 dw #FBD9
 dw #FD62
 db #87 : db 7
 dw #D4A9
 dw #DCFD
 dw #E4A9
 dw #ECA9
 dw #ECFD
 dw #FCA9
 dw #FCFD
 db #88 : db 8
 dw #CCAB
 dw #D563
 dw #DCAB
 dw #E564
 dw #EB1F
 dw #ECAB
 dw #F500
 dw #FAB9
 db #8C : db 4
 dw #D382
 dw #D49D
 dw #F3E6
 dw #F49D
 db #8F : db 10
 dw #C37D
 dw #C4A6
 dw #D37E
 dw #D4A6
 dw #D568
 dw #DCA6
 dw #E4A6
 dw #E567
 dw #F507
 dw #F5C7
 db #AE : db 4
 dw #C448
 dw #D4FF
 dw #E31E
 dw #F43B
 db #AF : db 8
 dw #C3E0
 dw #C3E4
 dw #D5C4
 dw #E381
 dw #E4FE
 dw #F3E5
 dw #F4FE
 dw #F561
 db #BB : db 1
 dw #ED65
 db #BF : db 1
 dw #E43B
 db #CC : db 4
 dw #DC9D
 dw #EBDB
 dw #EBE6
 dw #FD00
 db #CF : db 1
 dw #ED66
 db #DD : db 1
 dw #C68C
 db #DF : db 2
 dw #FB7D
 dw #FD64
 db #EE : db 2
 dw #DB82
 dw #ED0C
 db #EF : db 1
 dw #D3DF
 db #F0 : db 1
 dw #FCA8
 db #FF : db 5
 dw #CD61
 dw #DC48
 dw #ED62
 dw #ED64
 dw #FBDA
; Taille bloc delta = 434 octets
 DW #0000

; Delta frame 63 -> frame 64
Delta_63_64:
 db #00 : db 4
 dw #EC43
 dw #F3E0
 dw #F443
 dw #FAB9
 db #01 : db 2
 dw #D443
 dw #EB74
 db #03 : db 1
 dw #FB74
 db #07 : db 1
 dw #D4A6
 db #0F : db 22
 dw #C37B
 dw #C37C
 dw #C37D
 dw #C55E
 dw #C62D
 dw #D37A
 dw #D37E
 dw #D4A9
 dw #D568
 dw #D62B
 dw #DB7A
 dw #DB7C
 dw #DB7D
 dw #E446
 dw #E567
 dw #E628
 dw #ECFD
 dw #ED66
 dw #F378
 dw #F446
 dw #FCFD
 dw #FD65
 db #11 : db 7
 dw #CD07
 dw #D567
 dw #DBDF
 dw #DC43
 dw #E443
 dw #E55D
 dw #FAB6
 db #1E : db 2
 dw #D509
 dw #E438
 db #1F : db 16
 dw #CCFD
 dw #CDC3
 dw #CE2D
 dw #DB7B
 dw #DBE4
 dw #DC9B
 dw #DCFD
 dw #DDC4
 dw #DE2C
 dw #EB79
 dw #EC47
 dw #EC9B
 dw #ED60
 dw #EE2A
 dw #FC9B
 dw #FDCC
 db #23 : db 5
 dw #C568
 dw #CC43
 dw #E566
 dw #EBE0
 dw #F3D5
 db #2D : db 3
 dw #ECFC
 dw #ED0A
 dw #FC46
 db #2F : db 14
 dw #C4FD
 dw #C5CE
 dw #D49B
 dw #D4FD
 dw #D5C3
 dw #D62C
 dw #E379
 dw #E3D9
 dw #E3E4
 dw #E447
 dw #E49B
 dw #E560
 dw #E5CD
 dw #F49B
 db #3C : db 2
 dw #CCA8
 dw #EC38
 db #47 : db 6
 dw #C437
 dw #C443
 dw #DD67
 dw #E3E0
 dw #E507
 dw #FB14
 db #4B : db 1
 dw #F50A
 db #4F : db 2
 dw #DDC6
 dw #EB7D
 db #55 : db 1
 dw #C68C
 db #5A : db 1
 dw #C4A8
 db #5F : db 6
 dw #CBDA
 dw #CBE4
 dw #DE2D
 dw #EB7A
 dw #FB7D
 dw #FD61
 db #67 : db 1
 dw #D3DF
 db #69 : db 2
 dw #CCFC
 dw #DCFC
 db #6F : db 1
 dw #ED65
 db #78 : db 7
 dw #C50A
 dw #CC9A
 dw #D50A
 dw #DCA8
 dw #DD0A
 dw #E4FC
 dw #E50A
 db #7F : db 9
 dw #CD60
 dw #CDC5
 dw #DC3A
 dw #EB7B
 dw #ED61
 dw #EE2C
 dw #FB79
 dw #FBE5
 dw #FCFE
 db #87 : db 2
 dw #CD0B
 dw #F4A9
 db #88 : db 2
 dw #CDCF
 dw #F3DB
 db #8C : db 2
 dw #C4FF
 dw #E31E
 db #8F : db 9
 dw #CCA6
 dw #DBE0
 dw #E37E
 dw #E5C7
 dw #ECA6
 dw #F444
 dw #F4A6
 dw #FBE1
 dw #FC44
 db #AE : db 2
 dw #C43C
 dw #D31D
 db #AF : db 6
 dw #C560
 dw #C5C3
 dw #D380
 dw #D3E0
 dw #E563
 dw #F5C5
 db #BF : db 1
 dw #E3DB
 db #CC : db 7
 dw #C5CF
 dw #CC9D
 dw #D563
 dw #DBDC
 dw #E564
 dw #EC9D
 dw #FC9D
 db #DF : db 3
 dw #CBDF
 dw #EB7C
 dw #ED64
 db #E1 : db 2
 dw #EC9A
 dw #FC9A
 db #F0 : db 1
 dw #CD0A
 db #FF : db 9
 dw #CBE5
 dw #CC9C
 dw #CCFE
 dw #DC9C
 dw #DCFE
 dw #DD61
 dw #EC48
 dw #EC9C
 dw #FC9C
; Taille bloc delta = 396 octets
 DW #0000

; Delta frame 64 -> frame 65
Delta_64_65:
 db #00 : db 6
 dw #C507
 dw #D5CF
 dw #DC43
 dw #E443
 dw #EB1F
 dw #FAB6
 db #01 : db 1
 dw #FD06
 db #03 : db 1
 dw #C443
 db #07 : db 9
 dw #C437
 dw #C4A6
 dw #CCA6
 dw #DCA6
 dw #E4A6
 dw #ECA6
 dw #F444
 dw #FB14
 dw #FC44
 db #0F : db 25
 dw #C4A8
 dw #CCA8
 dw #CCA9
 dw #D37B
 dw #D37C
 dw #D37D
 dw #D3D9
 dw #D62C
 dw #DB7B
 dw #DCA9
 dw #E379
 dw #E37E
 dw #E4A9
 dw #E629
 dw #EB79
 dw #EB7D
 dw #ECFC
 dw #ED65
 dw #EE2A
 dw #F4A9
 dw #F5C7
 dw #F5CC
 dw #FB78
 dw #FBD8
 dw #FC46
 db #11 : db 3
 dw #D3DE
 dw #DD66
 dw #EBE0
 db #1E : db 5
 dw #C56B
 dw #D438
 dw #D56B
 dw #E509
 dw #F509
 db #1F : db 8
 dw #CC9B
 dw #DB80
 dw #EB7A
 dw #EBE4
 dw #ECFD
 dw #FB81
 dw #FC47
 dw #FCFD
 db #23 : db 2
 dw #CB75
 dw #D567
 db #2F : db 12
 dw #C3DA
 dw #C3E3
 dw #C49B
 dw #E37A
 dw #E380
 dw #E4FD
 dw #E62A
 dw #F379
 dw #F447
 dw #F4FD
 dw #F560
 dw #F5C4
 db #3C : db 1
 dw #DCA8
 db #44 : db 1
 dw #C68C
 db #47 : db 3
 dw #C568
 dw #FB74
 dw #FBE1
 db #4B : db 4
 dw #C56C
 dw #D4FC
 dw #E4FC
 dw #F4FC
 db #4F : db 2
 dw #CDC6
 dw #FB7D
 db #5A : db 1
 dw #D4A8
 db #5F : db 14
 dw #CB80
 dw #CBDF
 dw #CC47
 dw #CD60
 dw #CDC3
 dw #DD60
 dw #DDC4
 dw #EB7B
 dw #EB7C
 dw #EB81
 dw #EBD9
 dw #EE2C
 dw #FB79
 dw #FB7A
 db #78 : db 3
 dw #ECA8
 dw #F438
 dw #FC38
 db #7F : db 2
 dw #DBDA
 dw #FB82
 db #87 : db 1
 dw #CD6C
 db #88 : db 4
 dw #CD63
 dw #CE2F
 dw #DD64
 dw #FAB9
 db #8C : db 2
 dw #C49D
 dw #C62F
 db #8F : db 10
 dw #C5C7
 dw #CD68
 dw #D5C7
 dw #DD67
 dw #E444
 dw #E566
 dw #EC44
 dw #F37E
 dw #F3E1
 dw #FCA6
 db #AE : db 1
 dw #E31E
 db #AF : db 8
 dw #C447
 dw #D3DC
 dw #D3E4
 dw #D50C
 dw #D560
 dw #E560
 dw #E5C4
 dw #F381
 db #BF : db 3
 dw #C562
 dw #E564
 dw #E62D
 db #C3 : db 3
 dw #C4FC
 dw #DCFC
 dw #F49A
 db #CC : db 4
 dw #DE2E
 dw #E49D
 dw #EE2D
 dw #F500
 db #DD : db 1
 dw #D3DD
 db #DF : db 1
 dw #CDC5
 db #E1 : db 8
 dw #CC9A
 dw #CCFC
 dw #D49A
 dw #DC9A
 dw #E49A
 dw #ED0A
 dw #F50A
 dw #FD0A
 db #EE : db 3
 dw #EC3B
 dw #FBE6
 dw #FD00
 db #EF : db 1
 dw #D3DF
 db #F0 : db 1
 dw #DD0A
 db #FF : db 7
 dw #DD63
 dw #E565
 dw #EB82
 dw #ECFE
 dw #FC48
 dw #FCFE
 dw #FD62
; Taille bloc delta = 394 octets
 DW #0000

; Delta frame 65 -> frame 66
Delta_65_66:
 db #00 : db 6
 dw #C68B
 dw #C68C
 dw #D624
 dw #F626
 dw #FE27
 dw #FE2C
 db #01 : db 2
 dw #CB75
 dw #CC43
 db #03 : db 1
 dw #F3D5
 db #07 : db 6
 dw #C568
 dw #D567
 dw #EC44
 dw #ECFB
 dw #F4A6
 dw #FBE1
 db #0F : db 31
 dw #C376
 dw #C3DA
 dw #CD68
 dw #CE2D
 dw #D4A8
 dw #D509
 dw #DBD9
 dw #DBE0
 dw #DCA8
 dw #DCFC
 dw #DD67
 dw #DDC6
 dw #E37A
 dw #E37B
 dw #E37C
 dw #E37D
 dw #E4A8
 dw #E4FC
 dw #E566
 dw #E5C7
 dw #E62A
 dw #EB7A
 dw #EB7B
 dw #EB7C
 dw #ECA9
 dw #F379
 dw #F37E
 dw #F4FC
 dw #F507
 dw #FB7D
 dw #FCA9
 db #11 : db 3
 dw #CD67
 dw #D443
 dw #F506
 db #1E : db 6
 dw #C4FB
 dw #D499
 dw #D4FB
 dw #E499
 dw #F499
 dw #FD09
 db #1F : db 13
 dw #CBDA
 dw #CBE3
 dw #CCA9
 dw #CD0B
 dw #CD5F
 dw #DCA9
 dw #DD0B
 dw #DDC3
 dw #FB1D
 dw #FB79
 dw #FBE4
 dw #FC39
 dw #FD60
 db #23 : db 3
 dw #C443
 dw #EBE0
 dw #FD06
 db #27 : db 1
 dw #E3E0
 db #2D : db 1
 dw #ECA8
 db #2F : db 10
 dw #C4A9
 dw #C55F
 dw #C5C2
 dw #D37F
 dw #D3E3
 dw #E50B
 dw #E5C3
 dw #E62B
 dw #F380
 dw #F3E4
 db #33 : db 1
 dw #DBDF
 db #3C : db 3
 dw #CD6B
 dw #DC38
 dw #DD6B
 db #47 : db 9
 dw #C4A6
 dw #C624
 dw #CCA6
 dw #D375
 dw #D4A6
 dw #DCA6
 dw #E4A6
 dw #FB14
 dw #FC44
 db #4B : db 1
 dw #C4FC
 db #4F : db 2
 dw #CBDF
 dw #FD64
 db #5A : db 1
 dw #E56B
 db #5F : db 10
 dw #CBDB
 dw #CE2E
 dw #DBDA
 dw #DBE4
 dw #DC47
 dw #ED60
 dw #ED64
 dw #EDCD
 dw #FB7B
 dw #FB7C
 db #67 : db 1
 dw #EE26
 db #78 : db 3
 dw #CD0A
 dw #E438
 dw #FCA8
 db #7F : db 8
 dw #CBE4
 dw #CCFD
 dw #CD60
 dw #DB81
 dw #DCFD
 dw #DDCE
 dw #FC9B
 dw #FD61
 db #87 : db 3
 dw #CCFC
 dw #D56C
 dw #FC9A
 db #88 : db 4
 dw #C563
 dw #D564
 dw #E3DC
 dw #EB1F
 db #8C : db 3
 dw #C5CF
 dw #E31E
 dw #F500
 db #8F : db 5
 dw #C3E0
 dw #C508
 dw #E626
 dw #F565
 dw #F5C6
 db #AF : db 11
 dw #C37F
 dw #C3E3
 dw #C562
 dw #D3DF
 dw #D447
 dw #D5C3
 dw #E380
 dw #E3DB
 dw #E3E4
 dw #E564
 dw #E565
 db #BF : db 2
 dw #D3DD
 dw #D563
 db #C3 : db 5
 dw #C56C
 dw #CD6C
 dw #D49A
 dw #E49A
 dw #EC9A
 db #CC : db 1
 dw #F3DB
 db #CF : db 1
 dw #DD66
 db #E1 : db 1
 dw #FC38
 db #EE : db 2
 dw #CD63
 dw #EBDB
 db #EF : db 1
 dw #D3DE
 db #F0 : db 2
 dw #C49A
 dw #E50A
 db #FF : db 16
 dw #CB81
 dw #CCAA
 dw #CD0C
 dw #DBDC
 dw #DBE5
 dw #DCAA
 dw #DD0C
 dw #DD64
 dw #DD65
 dw #ECAA
 dw #ED61
 dw #FB82
 dw #FC3A
 dw #FCAA
 dw #FD00
 dw #FE28
; Taille bloc delta = 432 octets
 DW #0000

; Delta frame 66 -> frame 67
Delta_66_67:
 db #00 : db 3
 dw #CB16
 dw #CD07
 dw #FAB9
 db #03 : db 6
 dw #CCA6
 dw #D375
 dw #D4A6
 dw #DCA6
 dw #DE25
 dw #FB74
 db #07 : db 1
 dw #FCA6
 db #0F : db 28
 dw #C3E0
 dw #C4FC
 dw #C5C7
 dw #CBDA
 dw #CBDF
 dw #CCFC
 dw #CDC6
 dw #D4FB
 dw #D4FC
 dw #D567
 dw #D5C7
 dw #DD65
 dw #DD66
 dw #DE2C
 dw #E62B
 dw #ECA8
 dw #F37A
 dw #F37B
 dw #F37C
 dw #F37D
 dw #F3E1
 dw #F4A8
 dw #F5C6
 dw #FB79
 dw #FB7A
 dw #FB7C
 dw #FC9A
 dw #FCA8
 db #11 : db 3
 dw #D507
 dw #E3DF
 dw #F3E0
 db #1E : db 6
 dw #C438
 dw #C499
 dw #C5CC
 dw #DC99
 dw #EC99
 dw #F56A
 db #1F : db 8
 dw #CC46
 dw #DBE3
 dw #DD5F
 dw #EB80
 dw #EBD9
 dw #ECA9
 dw #EE2B
 dw #FCA9
 db #23 : db 3
 dw #CC43
 dw #CD67
 dw #EE26
 db #2F : db 11
 dw #C3DB
 dw #C446
 dw #C50B
 dw #D3DA
 dw #D4A9
 dw #D50B
 dw #D55F
 dw #D62D
 dw #E4A9
 dw #F439
 dw #F4A9
 db #47 : db 4
 dw #C443
 dw #EBE0
 dw #ECA6
 dw #FD5E
 db #4B : db 6
 dw #C439
 dw #C50A
 dw #D439
 dw #D50A
 dw #F49A
 dw #F56B
 db #4F : db 3
 dw #DDC5
 dw #ED64
 dw #FB7B
 db #5F : db 11
 dw #CBDC
 dw #CBDE
 dw #CDC5
 dw #DB80
 dw #DD64
 dw #EB1D
 dw #EBE4
 dw #EC47
 dw #ECFD
 dw #FB81
 dw #FCFD
 db #67 : db 2
 dw #D566
 dw #F627
 db #69 : db 1
 dw #CD0A
 db #78 : db 4
 dw #D56B
 dw #DD6B
 dw #E56B
 dw #EC38
 db #7F : db 13
 dw #CC47
 dw #CCAA
 dw #CD6D
 dw #CDC4
 dw #DBDB
 dw #DBE4
 dw #DC9B
 dw #DD60
 dw #EB81
 dw #EBDA
 dw #EC9B
 dw #ECAA
 dw #FDCD
 db #87 : db 5
 dw #CC39
 dw #DC39
 dw #DD6C
 dw #EC9A
 dw #FD6B
 db #88 : db 5
 dw #CD64
 dw #DD00
 dw #E4AB
 dw #FCAB
 dw #FD01
 db #8C : db 2
 dw #C563
 dw #E49D
 db #8F : db 8
 dw #C376
 dw #C568
 dw #D3E0
 dw #E565
 dw #E5C6
 dw #ECFB
 dw #ED07
 dw #FBE1
 db #AE : db 2
 dw #C4FF
 dw #E31E
 db #AF : db 14
 dw #C4FD
 dw #D3DD
 dw #D3DE
 dw #D4FD
 dw #D4FF
 dw #D563
 dw #D56D
 dw #E3E0
 dw #E447
 dw #E49B
 dw #E4FD
 dw #F3E4
 dw #F49B
 dw #F560
 db #BF : db 3
 dw #D448
 dw #D564
 dw #F500
 db #C3 : db 4
 dw #D56C
 dw #DC9A
 dw #F50A
 dw #FD0A
 db #CC : db 2
 dw #E3DC
 dw #E500
 db #CF : db 1
 dw #DBDF
 db #D2 : db 1
 dw #C49A
 db #DD : db 1
 dw #D565
 db #DF : db 2
 dw #CBDD
 dw #FD63
 db #E1 : db 3
 dw #DD0A
 dw #E50A
 dw #ED6B
 db #EE : db 6
 dw #D31D
 dw #DBDD
 dw #ED00
 dw #F62C
 dw #FC9D
 dw #FE2B
 db #FF : db 5
 dw #CD63
 dw #DBDE
 dw #EBDB
 dw #EBE5
 dw #FBE5
; Taille bloc delta = 422 octets
 DW #0000

; Delta frame 67 -> frame 68
Delta_67_68:
 db #00 : db 2
 dw #E4AB
 dw #E625
 db #01 : db 1
 dw #F506
 db #03 : db 4
 dw #C4A6
 dw #C5C0
 dw #E4A6
 dw #ECA6
 db #07 : db 3
 dw #C508
 dw #D625
 dw #ECFB
 db #0F : db 26
 dw #C3DB
 dw #C3DF
 dw #C4FB
 dw #C50A
 dw #C568
 dw #CBDB
 dw #CBDE
 dw #CD0A
 dw #D3DA
 dw #D3E0
 dw #D50A
 dw #D566
 dw #DBDF
 dw #DC99
 dw #DD0A
 dw #DDC5
 dw #E3D9
 dw #E509
 dw #E5C6
 dw #EBE0
 dw #EC99
 dw #F49A
 dw #F565
 dw #FB7B
 dw #FBE1
 dw #FD64
 db #11 : db 9
 dw #C567
 dw #CB16
 dw #CE24
 dw #D5C0
 dw #DC43
 dw #E3DE
 dw #EBDF
 dw #F5C1
 dw #FBE0
 db #1F : db 6
 dw #CDC2
 dw #DBDA
 dw #DC46
 dw #EBE3
 dw #ED6C
 dw #FB80
 db #23 : db 3
 dw #CB75
 dw #D443
 dw #DE25
 db #2F : db 10
 dw #C3DC
 dw #C3E2
 dw #C62E
 dw #D446
 dw #E37F
 dw #E3E3
 dw #E446
 dw #E55F
 dw #F31C
 dw #F3E3
 db #33 : db 2
 dw #EE26
 dw #FE28
 db #3C : db 1
 dw #FD6A
 db #3F : db 1
 dw #FD0B
 db #44 : db 1
 dw #E3DD
 db #47 : db 6
 dw #C437
 dw #CC43
 dw #F3E0
 dw #F4A6
 dw #FB74
 dw #FD06
 db #4B : db 4
 dw #D49A
 dw #D5CC
 dw #E49A
 dw #E50A
 db #5A : db 2
 dw #D438
 dw #F3D7
 db #5F : db 13
 dw #CBDD
 dw #CBE3
 dw #CCA9
 dw #CD5F
 dw #CDC4
 dw #DBDB
 dw #DCFD
 dw #EBDA
 dw #FBD9
 dw #FBE4
 dw #FC47
 dw #FD60
 dw #FD63
 db #69 : db 1
 dw #CDCC
 db #78 : db 1
 dw #C5CC
 db #7F : db 8
 dw #CC3B
 dw #CC9B
 dw #DC47
 dw #EBE4
 dw #EC47
 dw #ED60
 dw #FB81
 dw #FCAA
 db #87 : db 3
 dw #CD6C
 dw #D56C
 dw #ED0A
 db #88 : db 8
 dw #D4AB
 dw #D500
 dw #D5CF
 dw #E56E
 dw #EBDC
 dw #FAB9
 dw #FBDB
 dw #FC49
 db #8C : db 1
 dw #E31E
 db #8F : db 9
 dw #C3DE
 dw #C443
 dw #CD67
 dw #D5C6
 dw #DCFB
 dw #DDC1
 dw #E3E0
 dw #F5C5
 dw #FDC2
 db #97 : db 1
 dw #EC39
 db #AE : db 3
 dw #D31D
 dw #E500
 dw #F49D
 db #AF : db 14
 dw #C446
 dw #C4A9
 dw #C55F
 dw #C563
 dw #D3E3
 dw #D43A
 dw #D49B
 dw #D564
 dw #D565
 dw #E3DF
 dw #F380
 dw #F447
 dw #F4FD
 dw #F500
 db #BF : db 2
 dw #C4FF
 dw #E3DC
 db #C3 : db 3
 dw #C5CD
 dw #CC39
 dw #FD6B
 db #CC : db 5
 dw #C564
 dw #CDCF
 dw #DD00
 dw #F501
 dw #F62C
 db #DF : db 3
 dw #CD64
 dw #DBDE
 dw #FD61
 db #E1 : db 2
 dw #C49A
 dw #F56B
 db #EE : db 3
 dw #CD65
 dw #EC9D
 dw #FD01
 db #F0 : db 2
 dw #E56B
 dw #EC38
 db #FF : db 13
 dw #CBE4
 dw #CC47
 dw #CCAA
 dw #CCFF
 dw #CD60
 dw #CD66
 dw #DBDD
 dw #EC3A
 dw #ECAA
 dw #ED00
 dw #ED6D
 dw #FE29
 dw #FE2A
; Taille bloc delta = 424 octets
 DW #0000

; Delta frame 68 -> frame 0
Delta_68_00:
 db #00 : db 7
 dw #CB1D
 dw #D4AB
 dw #DC3C
 dw #EB1F
 dw #FAB9
 dw #FC49
 dw #FE28
 db #01 : db 4
 dw #CB75
 dw #CDC0
 dw #DC43
 dw #DD07
 db #03 : db 1
 dw #D443
 db #07 : db 2
 dw #C437
 dw #F55E
 db #0F : db 25
 dw #C3DC
 dw #C3DD
 dw #C3DE
 dw #C443
 dw #C56C
 dw #CBDC
 dw #CBDD
 dw #CD65
 dw #CD66
 dw #CD67
 dw #D3DF
 dw #D56C
 dw #DBDA
 dw #DD6C
 dw #E3E0
 dw #E444
 dw #E49A
 dw #E50A
 dw #EC9A
 dw #ED0A
 dw #F499
 dw #F50A
 dw #F5C4
 dw #F5C5
 dw #FD09
 db #11 : db 6
 dw #C442
 dw #DE25
 dw #E443
 dw #EE26
 dw #F3DF
 dw #F627
 db #1E : db 3
 dw #D5CB
 dw #E5CB
 dw #F437
 db #1F : db 6
 dw #CB7F
 dw #CCFC
 dw #EC39
 dw #EC46
 dw #EDCD
 dw #FC9A
 db #23 : db 5
 dw #C5C0
 dw #C624
 dw #E4A6
 dw #EDC1
 dw #F3D5
 db #2F : db 4
 dw #D3E2
 dw #E62C
 dw #F3D9
 dw #F446
 db #3C : db 1
 dw #CC38
 db #3F : db 1
 dw #CB1C
 db #47 : db 6
 dw #C4A6
 dw #D625
 dw #E5C1
 dw #E626
 dw #FBE0
 dw #FCA6
 db #4B : db 1
 dw #C49A
 db #4F : db 4
 dw #CDC5
 dw #DBDE
 dw #DD64
 dw #DDC4
 db #5F : db 14
 dw #CC46
 dw #CC9B
 dw #CD64
 dw #CD6D
 dw #CDCE
 dw #DBDC
 dw #DBDD
 dw #DBE3
 dw #DC3A
 dw #DC9B
 dw #DCA9
 dw #EB80
 dw #ECA9
 dw #FD0B
 db #67 : db 1
 dw #C567
 db #78 : db 1
 dw #C439
 db #7F : db 7
 dw #DCFD
 dw #EC3A
 dw #ECFD
 dw #ED6D
 dw #FBE4
 dw #FC47
 dw #FD61
 db #87 : db 4
 dw #CDCD
 dw #DC9A
 dw #DDCC
 dw #FD0A
 db #88 : db 7
 dw #C31C
 dw #C565
 dw #CD00
 dw #E4AB
 dw #EE2D
 dw #FD02
 dw #FE2B
 db #8C : db 1
 dw #F3DB
 db #8F : db 7
 dw #C5C6
 dw #CC43
 dw #CD08
 dw #D565
 dw #EC44
 dw #EE27
 dw #F3E0
 db #A5 : db 1
 dw #FBD7
 db #AE : db 2
 dw #E49D
 dw #F501
 db #AF : db 9
 dw #C3E2
 dw #C4FF
 dw #C56D
 dw #D37F
 dw #D446
 dw #D4A9
 dw #E3DC
 dw #E3DE
 dw #E3E3
 db #BF : db 3
 dw #C564
 dw #E500
 dw #F49D
 db #C3 : db 2
 dw #CC9A
 dw #D439
 db #CC : db 4
 dw #D500
 dw #EBDC
 dw #ED01
 dw #FBE6
 db #CF : db 1
 dw #EBDF
 db #D2 : db 1
 dw #D5CC
 db #DF : db 2
 dw #DD63
 dw #ED63
 db #E1 : db 1
 dw #CC39
 db #EE : db 4
 dw #D31D
 dw #DC9D
 dw #DD00
 dw #FAB8
 db #F0 : db 1
 dw #CDCC
 db #FF : db 7
 dw #DB81
 dw #DBE4
 dw #DC47
 dw #E3DD
 dw #FC9D
 dw #FCAA
 dw #FD01
; Taille bloc delta = 386 octets
 DW #0000

; Statistiques N (db N / pokeN) = min = 1, max = 43
; Taille table Delta_index = 140 octets
; Taille totale blocs deltas = 30556 octets
; Taille globale (table + deltas) = 30696 octets
delta_end
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: animation
  SELECT id INTO tag_uuid FROM tags WHERE name = 'animation';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 208: program416 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'program416',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2025-12-14T10:20:56.578000'::timestamptz,
    '2025-12-14T10:52:37.613000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'BUILDSNA
BANKSET 0

    org #8000
    run #8000
    di
    ld hl, #c9fb
    ld (#38), hl

    ld bc, #7c8c
    out (c), c

    ld hl, #c000 + 2018
    ld a, 0
    ld c, 16
    call setPalette

    ld bc, #7F10
    out (c), c
    ld c, #54
    out (c), c
wait_vblank
    ei
    halt
    ld b, #f5
.wait
    in a, (c)
    rra
    jr nc, .wait

    ld hl, #c000 + 2018
    ld a, 0
    ld c, 16
    call setPalette
    halt

    di
    ds 16 * 64 - 30

    exx
    ld hl, rasters
    ld bc, #7f00
    ld ix, .end_change
    ld a, (hl)
    inc hl
    add a
    exx

    ld e, 200
.raster_loop
    ld h, hi(jmp_table)
    ld l, a
    ld a, (hl)
    inc l
    ld h, (hl)
    ld l, a
    jp (hl)

.end_change
    ds 17
    dec e
    jr nz, .raster_loop

; #36
.end
    jp wait_vblank


no_changes
    exx
    ld a, (hl)
    add a
    inc hl
    exx 
    nop 24
    jp (ix)


changes_1
    exx
repeat 2
    inc b
    outi
rend
    nop 12
    ld a,(hl)
    add a
    inc hl
    exx
    jp (ix)


changes_2
    exx
repeat 4
    inc b
    outi
rend
    ld a,(hl)
    add a
    inc hl
    exx
    jp (ix)


setPalette:
    ld b, #7f
.loop:
    out (c), a
    inc b
    outi
    inc a
    dec c
    jr nz, .loop
    ret


align 256
jmp_table
    dw no_changes
    dw changes_1
    dw changes_2




rasters

    ; Format: For each of the 200 lines:
    ; DB #00 = no change on this line
    ; DB count, ink0, color0, [ink1, color1, ...] = count pairs of (ink, color)
    ; Colors are CPC Classic hardware values
    DB #00    ; Line 0 - no change
    DB 1, 4, #45    ; Line 1
    DB #00    ; Line 2 - no change
    DB #00    ; Line 3 - no change
    DB #00    ; Line 4 - no change
    DB #00    ; Line 5 - no change
    DB 1, 4, #46    ; Line 6
    DB #00    ; Line 7 - no change
    DB 2, 4, #4B, 8, #45    ; Line 8
    DB #00    ; Line 9 - no change
    DB #00    ; Line 10 - no change
    DB 1, 8, #46    ; Line 11
    DB 1, 3, #45    ; Line 12
    DB #00    ; Line 13 - no change
    DB 1, 12, #40    ; Line 14
    DB #00    ; Line 15 - no change
    DB #00    ; Line 16 - no change
    DB #00    ; Line 17 - no change
    DB #00    ; Line 18 - no change
    DB #00    ; Line 19 - no change
    DB #00    ; Line 20 - no change
    DB #00    ; Line 21 - no change
    DB #00    ; Line 22 - no change
    DB #00    ; Line 23 - no change
    DB 1, 8, #5B    ; Line 24
    DB #00    ; Line 25 - no change
    DB #00    ; Line 26 - no change
    DB #00    ; Line 27 - no change
    DB 1, 3, #5F    ; Line 28
    DB #00    ; Line 29 - no change
    DB #00    ; Line 30 - no change
    DB #00    ; Line 31 - no change
    DB #00    ; Line 32 - no change
    DB #00    ; Line 33 - no change
    DB 1, 3, #46    ; Line 34
    DB #00    ; Line 35 - no change
    DB 1, 13, #5F    ; Line 36
    DB 1, 3, #4C    ; Line 37
    DB 1, 8, #46    ; Line 38
    DB #00    ; Line 39 - no change
    DB #00    ; Line 40 - no change
    DB #00    ; Line 41 - no change
    DB 1, 3, #5B    ; Line 42
    DB 1, 8, #4C    ; Line 43
    DB #00    ; Line 44 - no change
    DB #00    ; Line 45 - no change
    DB 1, 8, #46    ; Line 46
    DB 1, 8, #4C    ; Line 47
    DB 1, 14, #46    ; Line 48
    DB 1, 8, #59    ; Line 49
    DB #00    ; Line 50 - no change
    DB #00    ; Line 51 - no change
    DB #00    ; Line 52 - no change
    DB #00    ; Line 53 - no change
    DB #00    ; Line 54 - no change
    DB #00    ; Line 55 - no change
    DB #00    ; Line 56 - no change
    DB #00    ; Line 57 - no change
    DB #00    ; Line 58 - no change
    DB 1, 8, #4F    ; Line 59
    DB #00    ; Line 60 - no change
    DB 1, 8, #4C    ; Line 61
    DB #00    ; Line 62 - no change
    DB 1, 8, #59    ; Line 63
    DB 1, 8, #4C    ; Line 64
    DB #00    ; Line 65 - no change
    DB #00    ; Line 66 - no change
    DB #00    ; Line 67 - no change
    DB 1, 14, #59    ; Line 68
    DB 1, 14, #46    ; Line 69
    DB #00    ; Line 70 - no change
    DB #00    ; Line 71 - no change
    DB #00    ; Line 72 - no change
    DB #00    ; Line 73 - no change
    DB #00    ; Line 74 - no change
    DB #00    ; Line 75 - no change
    DB 1, 15, #59    ; Line 76
    DB #00    ; Line 77 - no change
    DB #00    ; Line 78 - no change
    DB #00    ; Line 79 - no change
    DB #00    ; Line 80 - no change
    DB #00    ; Line 81 - no change
    DB #00    ; Line 82 - no change
    DB #00    ; Line 83 - no change
    DB #00    ; Line 84 - no change
    DB #00    ; Line 85 - no change
    DB #00    ; Line 86 - no change
    DB #00    ; Line 87 - no change
    DB #00    ; Line 88 - no change
    DB #00    ; Line 89 - no change
    DB #00    ; Line 90 - no change
    DB #00    ; Line 91 - no change
    DB #00    ; Line 92 - no change
    DB #00    ; Line 93 - no change
    DB #00    ; Line 94 - no change
    DB #00    ; Line 95 - no change
    DB #00    ; Line 96 - no change
    DB #00    ; Line 97 - no change
    DB #00    ; Line 98 - no change
    DB #00    ; Line 99 - no change
    DB #00    ; Line 100 - no change
    DB #00    ; Line 101 - no change
    DB 1, 3, #4F    ; Line 102
    DB #00    ; Line 103 - no change
    DB #00    ; Line 104 - no change
    DB #00    ; Line 105 - no change
    DB 1, 3, #5B    ; Line 106
    DB #00    ; Line 107 - no change
    DB #00    ; Line 108 - no change
    DB #00    ; Line 109 - no change
    DB #00    ; Line 110 - no change
    DB 1, 3, #4F    ; Line 111
    DB #00    ; Line 112 - no change
    DB #00    ; Line 113 - no change
    DB #00    ; Line 114 - no change
    DB #00    ; Line 115 - no change
    DB #00    ; Line 116 - no change
    DB #00    ; Line 117 - no change
    DB #00    ; Line 118 - no change
    DB 1, 15, #5B    ; Line 119
    DB #00    ; Line 120 - no change
    DB #00    ; Line 121 - no change
    DB #00    ; Line 122 - no change
    DB #00    ; Line 123 - no change
    DB #00    ; Line 124 - no change
    DB #00    ; Line 125 - no change
    DB #00    ; Line 126 - no change
    DB #00    ; Line 127 - no change
    DB #00    ; Line 128 - no change
    DB #00    ; Line 129 - no change
    DB 1, 14, #45    ; Line 130
    DB #00    ; Line 131 - no change
    DB 1, 14, #46    ; Line 132
    DB #00    ; Line 133 - no change
    DB #00    ; Line 134 - no change
    DB 1, 3, #45    ; Line 135
    DB #00    ; Line 136 - no change
    DB #00    ; Line 137 - no change
    DB 1, 11, #4F    ; Line 138
    DB #00    ; Line 139 - no change
    DB #00    ; Line 140 - no change
    DB #00    ; Line 141 - no change
    DB 1, 3, #59    ; Line 142
    DB #00    ; Line 143 - no change
    DB #00    ; Line 144 - no change
    DB #00    ; Line 145 - no change
    DB 1, 3, #45    ; Line 146
    DB #00    ; Line 147 - no change
    DB #00    ; Line 148 - no change
    DB #00    ; Line 149 - no change
    DB #00    ; Line 150 - no change
    DB #00    ; Line 151 - no change
    DB 1, 8, #59    ; Line 152
    DB #00    ; Line 153 - no change
    DB #00    ; Line 154 - no change
    DB 1, 2, #4C    ; Line 155
    DB 1, 2, #4E    ; Line 156
    DB #00    ; Line 157 - no change
    DB #00    ; Line 158 - no change
    DB #00    ; Line 159 - no change
    DB 1, 8, #4C    ; Line 160
    DB #00    ; Line 161 - no change
    DB #00    ; Line 162 - no change
    DB #00    ; Line 163 - no change
    DB #00    ; Line 164 - no change
    DB #00    ; Line 165 - no change
    DB #00    ; Line 166 - no change
    DB #00    ; Line 167 - no change
    DB #00    ; Line 168 - no change
    DB #00    ; Line 169 - no change
    DB #00    ; Line 170 - no change
    DB #00    ; Line 171 - no change
    DB #00    ; Line 172 - no change
    DB #00    ; Line 173 - no change
    DB #00    ; Line 174 - no change
    DB #00    ; Line 175 - no change
    DB #00    ; Line 176 - no change
    DB #00    ; Line 177 - no change
    DB #00    ; Line 178 - no change
    DB #00    ; Line 179 - no change
    DB 1, 8, #59    ; Line 180
    DB #00    ; Line 181 - no change
    DB #00    ; Line 182 - no change
    DB #00    ; Line 183 - no change
    DB #00    ; Line 184 - no change
    DB 2, 3, #4A, 11, #4C    ; Line 185
    DB #00    ; Line 186 - no change
    DB #00    ; Line 187 - no change
    DB #00    ; Line 188 - no change
    DB #00    ; Line 189 - no change
    DB #00    ; Line 190 - no change
    DB 1, 8, #4F    ; Line 191
    DB #00    ; Line 192 - no change
    DB #00    ; Line 193 - no change
    DB #00    ; Line 194 - no change
    DB #00    ; Line 195 - no change
    DB #00    ; Line 196 - no change
    DB 1, 7, #59    ; Line 197
    DB 1, 8, #44    ; Line 198
    DB #00    ; Line 199 - no change

    org #c000
; SCR Data created with Pixsaur - CPC Classic
; Mode 0  
; 160x200 pixels, 80x200 bytes.
; Palette data injected at offset 2000 (border at 2000, firmware colors at 2001-2016, hardware colors at 2017-2033, mode at 2034)

ImageData:
  db #00, #00, #00, #00, #54, #A0, #00, #50, #F4, #A0, #00, #00, #00, #50, #00, #00
  db #40, #40, #80, #00, #C0, #C0, #C0, #C0, #C0, #C0, #C0, #C8, #C0, #C0, #C0, #48
  db #59, #59, #48, #0C, #0C, #0C, #0C, #0C, #48, #59, #0C, #A6, #0C, #0C, #0C, #C0
  db #0C, #A7, #E2, #C0, #C0, #C0, #D1, #5B, #5B, #C0, #D0, #E0, #A8, #00, #80, #40
  db #00, #00, #00, #80, #40, #00, #80, #40, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #D4, #D4, #00, #E8, #00, #00, #00, #80, #50, #44, #00
  db #00, #40, #00, #80, #80, #C0, #40, #C0, #C0, #5B, #C0, #DC, #C0, #5B, #84, #84
  db #E2, #86, #59, #38, #30, #30, #30, #2C, #49, #0C, #49, #49, #49, #49, #08, #05
  db #86, #49, #59, #84, #D1, #4A, #E3, #A6, #E3, #C0, #C0, #42, #40, #40, #80, #80
  db #80, #00, #80, #00, #50, #00, #00, #80, #40, #00, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #00, #00, #00, #F0, #00, #00, #00, #40, #00, #00, #B1
  db #00, #40, #00, #80, #C0, #C0, #C0, #C0, #C0, #84, #C0, #01, #50, #85, #A7, #B3
  db #B2, #3C, #3C, #3C, #3C, #34, #3C, #3C, #6D, #92, #2C, #86, #86, #00, #00, #04
  db #0C, #86, #0C, #A6, #0C, #0C, #A6, #A6, #0C, #A6, #A7, #A2, #40, #C0, #40, #80
  db #00, #80, #C0, #40, #40, #40, #40, #40, #40, #40, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #50, #A8, #00, #00, #50, #A0, #00, #80, #50, #50, #00
  db #40, #00, #80, #80, #C0, #80, #C0, #63, #30, #34, #96, #22, #00, #00, #41, #18
  db #1C, #1C, #9E, #9E, #9E, #9E, #9E, #4D, #0C, #0E, #18, #08, #00, #00, #00, #49
  db #0C, #0C, #0C, #8C, #49, #0C, #D3, #D3, #0C, #59, #C0, #C0, #80, #C0, #40, #40
  db #50, #40, #00, #80, #80, #80, #42, #00, #80, #40, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #E8, #F8, #D4, #E0, #40
  db #40, #40, #80, #30, #3C, #76, #11, #33, #3C, #69, #6D, #28, #00, #00, #00, #00
  db #0C, #8E, #8E, #2C, #CB, #0C, #0C, #0D, #0D, #48, #80, #00, #00, #00, #14, #CB
  db #2C, #86, #CB, #CB, #0C, #86, #49, #0C, #86, #0C, #0C, #49, #0C, #C0, #4A, #40
  db #C0, #90, #80, #40, #40, #B0, #62, #00, #80, #40, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #B1, #40, #00
  db #80, #90, #31, #F3, #F3, #B3, #B3, #B3, #B3, #B3, #A8, #54, #00, #00, #00, #00
  db #00, #40, #0E, #0D, #0D, #0D, #87, #8D, #C0, #00, #00, #00, #00, #40, #34, #3C
  db #9E, #3C, #9E, #1C, #1C, #4D, #86, #49, #8E, #68, #C0, #85, #C0, #C0, #C0, #C0
  db #C0, #31, #40, #40, #D0, #31, #C0, #40, #C0, #40, #40, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #54, #D4, #50, #50, #D4, #D0, #F0, #D4
  db #94, #76, #37, #F3, #98, #98, #30, #64, #F3, #37, #B9, #B6, #34, #22, #00, #00
  db #00, #00, #54, #05, #C0, #08, #C0, #00, #00, #00, #00, #00, #14, #28, #4B, #3C
  db #30, #CB, #3C, #3C, #6D, #3C, #9E, #1C, #0C, #86, #07, #13, #85, #90, #60, #C0
  db #91, #D3, #80, #80, #90, #22, #C0, #80, #80, #80, #C0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #40, #40, #E8, #50, #50, #50, #50, #D0, #B1, #F0, #72
  db #27, #00, #15, #B5, #D4, #7A, #7A, #3B, #7E, #00, #41, #0F, #85, #91, #B9, #00
  db #A8, #AD, #B9, #00, #00, #80, #54, #00, #00, #00, #00, #04, #DE, #D9, #88, #3C
  db #30, #30, #3C, #3C, #3C, #3C, #3C, #3C, #3C, #2C, #49, #84, #85, #C6, #87, #C0
  db #90, #27, #C0, #C0, #71, #80, #C0, #80, #80, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #40, #50, #50, #50, #50, #50, #50, #D0, #72, #72, #B1
  db #E0, #00, #00, #00, #00, #00, #11, #A8, #00, #00, #84, #C0, #00, #00, #E5, #39
  db #00, #61, #33, #A8, #50, #4A, #00, #00, #62, #00, #40, #68, #50, #22, #3C, #38
  db #30, #3C, #1E, #3C, #9E, #38, #30, #69, #C7, #86, #86, #0E, #0C, #31, #85, #42
  db #64, #C2, #4A, #32, #62, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #D4, #D0, #50, #50, #50, #D4, #D0, #72, #F0, #72
  db #63, #54, #00, #00, #00, #00, #54, #00, #F4, #72, #5E, #00, #00, #AC, #0E, #4B
  db #80, #00, #33, #90, #30, #B1, #11, #00, #00, #00, #85, #00, #00, #04, #0C, #C7
  db #51, #3B, #F3, #F3, #6A, #6B, #9E, #38, #3C, #86, #86, #49, #0C, #B3, #09, #4B
  db #B3, #48, #46, #31, #C0, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #D4, #91, #00, #40, #B9, #B1, #D0, #72, #72, #72
  db #D2, #82, #A0, #E8, #B9, #54, #00, #73, #37, #B5, #B5, #B5, #36, #6D, #4A, #27
  db #4A, #49, #80, #A5, #63, #82, #00, #00, #85, #80, #00, #00, #00, #48, #0A, #50
  db #7A, #3B, #F9, #D9, #D9, #D9, #76, #A5, #3C, #3C, #2C, #49, #4C, #26, #49, #33
  db #26, #07, #70, #0B, #C0, #07, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #E0, #B1, #40, #40, #D0, #40, #11, #B1, #B1, #E1, #B1
  db #E1, #63, #A0, #11, #54, #A0, #00, #B9, #3B, #B3, #F3, #73, #49, #4B, #19, #19
  db #19, #80, #85, #00, #85, #80, #40, #62, #80, #40, #00, #22, #04, #80, #11, #00
  db #00, #B9, #54, #11, #3B, #F3, #B3, #7E, #00, #93, #D9, #B3, #51, #73, #33, #72
  db #49, #32, #23, #48, #48, #48, #84, #C0, #C0, #C0, #42, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #91, #B1, #40, #40, #C0, #40, #11, #B1, #B1, #72, #93
  db #93, #D2, #4B, #26, #A5, #80, #00, #50, #B9, #B9, #B5, #B4, #3C, #1C, #49, #0E
  db #26, #4A, #00, #C0, #05, #40, #40, #40, #40, #00, #00, #A8, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #A8, #3B, #00, #00, #00, #73, #99, #76, #37, #D1
  db #C4, #41, #49, #0C, #48, #48, #07, #42, #85, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #40, #40, #40, #91, #C0, #C0, #91, #E1, #E1, #E1, #63
  db #E1, #63, #E1, #61, #39, #A5, #F6, #00, #00, #A0, #76, #27, #87, #86, #86, #86
  db #26, #62, #00, #4A, #85, #85, #C0, #C0, #4A, #3B, #B3, #7A, #7A, #2A, #00, #00
  db #A8, #54, #00, #A8, #54, #00, #22, #00, #00, #76, #73, #B3, #54, #A0, #2A, #A0
  db #11, #0C, #86, #49, #09, #09, #0C, #81, #C0, #48, #4A, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #00, #C0, #C0, #85, #C0, #91, #C0, #D2, #93, #93, #93
  db #93, #C3, #93, #96, #93, #C2, #80, #B3, #00, #00, #00, #00, #86, #86, #86, #62
  db #4A, #4A, #C1, #4B, #19, #49, #0E, #87, #91, #B3, #B3, #B9, #F8, #A8, #00, #E8
  db #7E, #A0, #76, #11, #00, #C3, #39, #80, #50, #73, #A2, #11, #B9, #00, #00, #22
  db #C7, #86, #86, #49, #0C, #86, #49, #49, #0C, #0B, #0C, #0A, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #50, #4A, #D0, #48, #48, #07, #07, #85, #C3, #93, #C3
  db #C3, #92, #C3, #93, #C2, #00, #40, #62, #51, #22, #15, #00, #00, #40, #C0, #C0
  db #C0, #80, #C0, #05, #85, #A5, #C1, #91, #D4, #22, #54, #54, #00, #00, #00, #00
  db #00, #00, #91, #C1, #93, #93, #C0, #00, #55, #73, #76, #80, #A8, #22, #00, #2C
  db #86, #86, #86, #2C, #3C, #3C, #3C, #C3, #30, #30, #24, #08, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E0, #0B, #84, #A4, #C0, #0C, #0B, #49, #84, #C1, #49
  db #D7, #FB, #27, #A5, #91, #91, #62, #00, #22, #2A, #00, #00, #2C, #86, #26, #26
  db #26, #87, #87, #43, #00, #C0, #C0, #C0, #00, #00, #00, #00, #00, #00, #00, #00
  db #05, #50, #96, #92, #34, #92, #63, #90, #FB, #2A, #00, #00, #00, #11, #9E, #C7
  db #C7, #3C, #3C, #61, #30, #C9, #C3, #D2, #B4, #00, #A0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C0, #8D, #8D, #07, #84, #84, #06, #06, #86, #86, #32
  db #73, #76, #00, #00, #E8, #62, #62, #80, #00, #40, #00, #00, #40, #40, #40, #40
  db #80, #00, #00, #40, #85, #8D, #85, #D1, #73, #76, #00, #11, #A8, #00, #40, #80
  db #00, #63, #C3, #63, #93, #30, #B7, #A0, #F8, #00, #00, #00, #00, #36, #3C, #38
  db #30, #24, #30, #30, #30, #91, #D7, #00, #80, #D0, #C0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #07, #43, #84, #09, #86, #49, #0C, #49, #1C, #77, #37
  db #00, #00, #B5, #76, #A8, #00, #00, #40, #38, #75, #50, #00, #00, #40, #85, #85
  db #C0, #00, #00, #85, #85, #80, #00, #A8, #00, #00, #00, #A8, #00, #00, #40, #11
  db #50, #1A, #79, #B3, #76, #54, #00, #00, #10, #FA, #76, #22, #3C, #38, #38, #38
  db #3C, #30, #C7, #D2, #90, #F0, #D0, #D0, #C0, #E0, #A0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #C1, #49, #93, #BB, #33, #BA, #49, #12, #73, #B9, #B9
  db #50, #7A, #00, #00, #00, #00, #36, #30, #30, #30, #31, #00, #22, #00, #00, #C0
  db #80, #80, #00, #40, #C0, #C0, #00, #00, #A8, #00, #00, #00, #00, #22, #38, #31
  db #41, #87, #B1, #A8, #00, #00, #00, #00, #A8, #00, #76, #96, #3C, #30, #96, #92
  db #61, #E0, #99, #91, #E0, #E0, #62, #40, #A0, #A0, #C0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #12, #F7, #76, #11, #F9, #00, #22, #00, #B9, #50, #00
  db #A0, #00, #00, #00, #33, #30, #30, #30, #30, #10, #9A, #20, #20, #A0, #00, #00
  db #00, #00, #80, #00, #00, #00, #00, #00, #00, #00, #00, #76, #11, #B1, #30, #34
  db #A5, #E0, #00, #00, #00, #32, #74, #33, #72, #22, #36, #3C, #30, #3C, #12, #CB
  db #E1, #D2, #91, #C8, #D0, #C0, #80, #E0, #E0, #40, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #A2, #A8, #76, #A2, #BB, #A2, #50, #73, #B3, #00, #00
  db #00, #72, #38, #38, #38, #30, #30, #75, #76, #00, #00, #33, #30, #E2, #11, #A0
  db #38, #00, #50, #00, #11, #A0, #50, #11, #A0, #E8, #E8, #B9, #00, #00, #32, #30
  db #62, #C0, #00, #00, #00, #00, #00, #00, #00, #38, #3C, #34, #61, #C3, #92, #80
  db #00, #00, #00, #80, #00, #00, #00, #00, #40, #80, #D0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #96, #00, #00, #B5, #40, #F9, #22, #00, #00, #00, #96
  db #3C, #34, #30, #30, #30, #BA, #FB, #50, #00, #B9, #F9, #00, #40, #80, #6F, #22
  db #22, #A0, #40, #00, #33, #A8, #B5, #80, #76, #80, #00, #A8, #00, #00, #00, #B9
  db #32, #20, #40, #00, #00, #00, #40, #30, #30, #34, #3C, #38, #61, #30, #C2, #80
  db #80, #00, #C4, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #BA, #49, #08, #00, #00, #00, #00, #00, #3C, #3C, #3C
  db #38, #30, #30, #3C, #0A, #00, #11, #7E, #00, #00, #2A, #00, #C0, #62, #4B, #4A
  db #91, #4A, #80, #40, #11, #19, #85, #C2, #91, #C0, #A8, #00, #00, #00, #00, #00
  db #00, #00, #00, #7A, #36, #38, #38, #30, #38, #38, #38, #C3, #30, #30, #30, #20
  db #00, #00, #00, #00, #00, #40, #41, #72, #72, #72, #A5, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #93, #11, #31, #86, #AA, #63, #C9, #3C, #3C, #3C, #38
  db #75, #75, #02, #4B, #C1, #7A, #00, #00, #00, #05, #A5, #85, #4A, #85, #0E, #26
  db #4B, #4B, #4B, #19, #48, #87, #87, #84, #91, #19, #19, #19, #49, #C6, #C6, #96
  db #3C, #69, #00, #00, #00, #B9, #FB, #38, #30, #69, #92, #D0, #E1, #92, #30, #C3
  db #63, #72, #62, #72, #5A, #36, #C3, #63, #93, #93, #C3, #2A, #00, #00, #00, #00
  db #00, #00, #03, #0F, #0D, #1A, #04, #19, #01, #0E, #10, #0C, #18, #17, #06, #02
  db #05, #54, #54, #5C, #4E, #40, #4B, #58, #43, #44, #5F, #47, #5E, #4A, #5B, #4C
  db #55, #5D, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #00, #00, #E4, #54, #00, #00, #00, #54, #A0, #00
  db #00, #80, #C0, #00, #40, #C0, #C0, #C0, #40, #C0, #85, #A0, #C0, #C0, #84, #84
  db #84, #84, #0C, #0C, #0C, #0C, #0C, #0C, #24, #84, #A6, #0C, #0C, #0C, #0C, #C0
  db #59, #5B, #5B, #C0, #C0, #C0, #A7, #A7, #E2, #E2, #D0, #5A, #40, #40, #00, #80
  db #80, #00, #40, #40, #00, #80, #00, #00, #80, #00, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #54, #00, #50, #FC, #00, #00, #00, #00, #00, #50, #00
  db #50, #50, #00, #40, #40, #40, #80, #C0, #C0, #A7, #84, #EC, #40, #C0, #48, #48
  db #0C, #84, #1C, #30, #30, #30, #30, #30, #86, #86, #0C, #86, #86, #86, #0A, #40
  db #0C, #86, #59, #48, #A7, #E2, #59, #59, #59, #48, #D1, #C0, #80, #C0, #80, #80
  db #80, #80, #40, #00, #80, #80, #80, #40, #00, #80, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #A8, #00, #00, #B1, #00, #00, #00, #00, #80, #00, #50
  db #A8, #00, #40, #40, #40, #C0, #C0, #C0, #C0, #C0, #E2, #E8, #A8, #AC, #84, #84
  db #92, #3C, #9E, #3C, #34, #34, #34, #3C, #2C, #9E, #24, #49, #0C, #00, #00, #C1
  db #49, #0C, #0C, #0C, #86, #59, #48, #0C, #59, #59, #59, #80, #80, #80, #80, #80
  db #80, #40, #40, #40, #00, #80, #80, #80, #80, #80, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #D4, #A0, #00, #00, #00, #F0, #00, #50, #50, #A0, #50
  db #40, #40, #40, #40, #C0, #40, #36, #30, #30, #30, #30, #22, #00, #00, #40, #92
  db #4D, #6D, #6D, #6D, #6D, #6D, #6D, #2C, #8F, #0D, #1C, #08, #00, #00, #00, #86
  db #49, #0C, #49, #0C, #86, #49, #0C, #A6, #0C, #0D, #85, #C0, #40, #C0, #80, #80
  db #C0, #11, #80, #40, #40, #00, #20, #80, #00, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #80, #50, #E8, #F8, #00
  db #80, #80, #91, #34, #39, #E8, #A8, #33, #93, #93, #93, #28, #00, #00, #00, #00
  db #04, #4D, #4D, #4D, #86, #0D, #0C, #0E, #5B, #0E, #00, #00, #00, #00, #14, #C7
  db #2C, #CB, #0C, #2C, #49, #0C, #86, #49, #0C, #0C, #0C, #0C, #48, #91, #80, #80
  db #C0, #90, #80, #80, #C0, #90, #62, #40, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #54, #50, #50, #50, #50, #50, #80, #80
  db #C0, #32, #73, #F3, #F3, #73, #F3, #73, #73, #73, #A8, #00, #00, #00, #00, #00
  db #00, #00, #0D, #0D, #0C, #4E, #4E, #4A, #80, #00, #00, #00, #00, #11, #3C, #6D
  db #3C, #CB, #6D, #3C, #1C, #49, #CB, #8E, #2C, #85, #8D, #C4, #C0, #C0, #62, #C0
  db #C0, #71, #80, #80, #C0, #31, #80, #C0, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #A0, #E8, #E8, #A0, #E0, #F0, #D0, #50
  db #94, #22, #76, #3B, #98, #30, #30, #71, #99, #F6, #51, #12, #30, #28, #00, #00
  db #54, #00, #22, #40, #85, #48, #85, #54, #00, #00, #00, #00, #1E, #08, #A5, #3C
  db #38, #65, #3C, #6D, #3C, #9E, #6D, #2C, #86, #49, #49, #4A, #4A, #18, #A6, #C0
  db #91, #33, #80, #80, #32, #22, #C0, #40, #40, #40, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #54, #80, #E8, #E8, #E8, #A0, #F0, #F0, #B1, #F0
  db #5A, #54, #50, #7A, #6A, #B9, #B3, #B9, #A8, #00, #41, #5A, #4B, #54, #76, #D4
  db #11, #54, #00, #00, #A8, #80, #00, #00, #00, #00, #00, #85, #19, #CC, #A2, #3C
  db #30, #30, #3C, #3C, #3C, #3C, #3C, #3C, #3C, #2C, #0C, #58, #4A, #71, #C2, #48
  db #32, #62, #C0, #91, #31, #C0, #C0, #40, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #A0, #A0, #F0, #A5, #F0, #B1, #B1
  db #A5, #00, #00, #00, #00, #00, #00, #A8, #00, #00, #C2, #0A, #00, #00, #14, #39
  db #00, #32, #70, #00, #76, #48, #00, #00, #80, #00, #40, #28, #BD, #A0, #3C, #38
  db #30, #2D, #65, #6D, #6D, #38, #34, #61, #CB, #49, #0C, #86, #86, #31, #84, #85
  db #71, #27, #C0, #71, #62, #C0, #C0, #40, #80, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #A0, #E0, #E8, #A0, #A0, #E0, #E8, #E0, #B1, #B1, #B1
  db #E1, #2A, #A8, #00, #00, #00, #00, #00, #11, #AD, #B9, #22, #00, #27, #87, #0D
  db #5E, #00, #91, #A5, #33, #22, #22, #A0, #00, #40, #05, #00, #00, #85, #84, #19
  db #11, #73, #73, #CC, #76, #11, #96, #3C, #34, #86, #49, #0C, #49, #C9, #0E, #90
  db #33, #84, #90, #33, #C0, #C0, #C0, #80, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E0, #E0, #A5, #00, #00, #D0, #72, #72, #B1, #B1, #B1
  db #B1, #B1, #22, #F4, #D4, #50, #00, #73, #73, #73, #F8, #7A, #ED, #3C, #68, #4B
  db #85, #C1, #0A, #41, #92, #22, #00, #00, #C0, #80, #00, #00, #40, #62, #0A, #BD
  db #A0, #76, #73, #D9, #D9, #D9, #76, #11, #C7, #38, #2C, #0C, #49, #63, #0C, #93
  db #26, #09, #99, #13, #81, #0B, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #5A, #5A, #80, #80, #C0, #50, #50, #72, #72, #D2, #63
  db #33, #93, #A5, #95, #50, #54, #00, #11, #B5, #F3, #73, #F6, #2C, #87, #86, #26
  db #26, #80, #40, #00, #C0, #00, #40, #4A, #40, #11, #00, #00, #40, #00, #54, #00
  db #00, #FC, #A8, #54, #33, #F3, #37, #B5, #00, #73, #D9, #33, #11, #98, #B3, #B1
  db #49, #BB, #26, #06, #84, #84, #C0, #C0, #C0, #48, #81, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #62, #11, #40, #C0, #80, #C0, #72, #72, #D2, #93, #E1
  db #E1, #B1, #E1, #93, #58, #80, #00, #54, #5E, #76, #72, #3E, #3C, #2C, #87, #87
  db #19, #07, #00, #C0, #80, #C0, #80, #C0, #80, #00, #54, #11, #54, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #54, #F4, #00, #00, #20, #F9, #31, #72, #A8, #33
  db #73, #04, #86, #09, #09, #84, #81, #0B, #C0, #48, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #80, #80, #C0, #C0, #4A, #85, #91, #D2, #93, #D2, #D2
  db #93, #C3, #94, #30, #C3, #0A, #F6, #00, #00, #50, #B9, #41, #4B, #49, #4B, #49
  db #19, #48, #11, #C0, #0B, #23, #22, #C0, #80, #B1, #B3, #B5, #B5, #80, #A8, #00
  db #54, #D4, #D4, #00, #40, #00, #22, #40, #11, #A2, #B3, #B3, #54, #22, #11, #50
  db #04, #86, #49, #0C, #06, #06, #06, #07, #07, #07, #07, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #80, #C0, #80, #C0, #85, #C0, #48, #E1, #63, #63, #63
  db #C3, #C3, #93, #C3, #93, #D0, #80, #B3, #22, #00, #00, #00, #19, #19, #19, #49
  db #85, #C0, #85, #86, #86, #26, #87, #0D, #91, #B3, #B9, #B5, #B5, #80, #54, #95
  db #A0, #F8, #40, #2A, #50, #38, #93, #0A, #54, #73, #7B, #B5, #54, #00, #00, #22
  db #2C, #49, #0C, #86, #49, #49, #0C, #86, #0C, #87, #48, #08, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #40, #E0, #85, #84, #C0, #09, #0B, #0B, #63, #63, #C3
  db #C3, #92, #38, #93, #C2, #00, #00, #19, #54, #76, #50, #40, #62, #00, #40, #40
  db #00, #40, #40, #11, #48, #4A, #4A, #0B, #6A, #A8, #A8, #00, #00, #00, #00, #00
  db #00, #00, #C0, #33, #C3, #26, #A0, #80, #55, #33, #E8, #A8, #00, #00, #05, #C7
  db #C7, #1C, #1C, #1C, #3C, #3C, #C3, #38, #30, #30, #93, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #4A, #A5, #07, #13, #43, #84, #06, #0C, #C2, #48, #C3
  db #B2, #33, #72, #91, #C1, #26, #62, #80, #A8, #B5, #00, #00, #96, #4B, #19, #19
  db #19, #19, #0D, #87, #82, #40, #C0, #80, #00, #00, #00, #00, #00, #00, #00, #00
  db #C0, #91, #C3, #30, #61, #69, #C2, #32, #B3, #50, #00, #00, #00, #00, #3C, #CB
  db #CB, #3C, #38, #96, #30, #C3, #C3, #F0, #91, #50, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #62, #4E, #0B, #23, #23, #48, #4C, #49, #49, #49, #38
  db #B7, #F4, #00, #00, #73, #91, #C0, #00, #00, #40, #80, #00, #80, #80, #C0, #C0
  db #80, #00, #80, #40, #40, #4B, #4A, #95, #B3, #B9, #00, #B9, #00, #00, #05, #00
  db #40, #63, #63, #87, #32, #71, #76, #00, #A8, #00, #00, #00, #00, #36, #3C, #38
  db #30, #69, #30, #34, #C3, #41, #66, #62, #40, #40, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C2, #C2, #83, #86, #49, #84, #86, #86, #2C, #EF, #76
  db #A0, #00, #33, #3B, #A8, #00, #00, #85, #30, #31, #50, #54, #00, #00, #40, #D0
  db #80, #80, #00, #C0, #C0, #80, #00, #A8, #22, #00, #00, #00, #00, #00, #C0, #27
  db #E8, #36, #73, #73, #E8, #A8, #50, #00, #10, #37, #72, #50, #3C, #3C, #34, #38
  db #92, #65, #C3, #D2, #90, #D0, #D0, #D0, #D0, #80, #22, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #86, #84, #93, #F4, #76, #75, #8B, #75, #F2, #76, #22
  db #A8, #A0, #00, #00, #00, #00, #32, #38, #30, #30, #74, #22, #F4, #00, #00, #40
  db #C0, #00, #00, #00, #C0, #C0, #00, #54, #00, #00, #00, #00, #00, #B1, #30, #25
  db #41, #63, #7A, #A8, #A8, #00, #00, #00, #22, #51, #22, #3C, #38, #38, #3C, #92
  db #CB, #C9, #E4, #41, #E0, #80, #A0, #D0, #D0, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #5D, #F3, #BB, #54, #33, #54, #00, #00, #A0, #15, #50
  db #2A, #00, #00, #11, #B8, #30, #30, #30, #75, #11, #B2, #60, #31, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #11, #AD, #B9, #11, #30, #34
  db #D0, #4A, #54, #00, #00, #30, #B3, #73, #33, #A8, #3C, #38, #30, #96, #92, #93
  db #D8, #D8, #66, #E0, #E0, #E0, #E0, #D0, #D0, #80, #D0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #22, #A0, #72, #11, #B3, #76, #11, #73, #73, #00, #00
  db #54, #33, #38, #34, #30, #30, #30, #30, #22, #00, #00, #11, #30, #A2, #22, #22
  db #71, #00, #00, #00, #50, #2A, #11, #11, #E8, #54, #5E, #80, #00, #00, #32, #30
  db #62, #A5, #00, #00, #00, #00, #00, #00, #40, #30, #38, #34, #61, #92, #92, #40
  db #00, #00, #00, #00, #00, #00, #00, #11, #00, #40, #E0, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #19, #00, #54, #50, #15, #B1, #00, #00, #00, #40, #3C
  db #3C, #38, #38, #30, #75, #30, #22, #00, #A8, #76, #76, #22, #40, #0A, #00, #72
  db #72, #40, #40, #BC, #B9, #00, #62, #A8, #A0, #00, #00, #00, #00, #00, #11, #B1
  db #51, #AA, #D4, #80, #00, #00, #B0, #30, #30, #3C, #3C, #38, #C3, #34, #62, #80
  db #00, #40, #A1, #A0, #00, #00, #00, #50, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #31, #49, #52, #00, #00, #00, #00, #40, #3C, #3C, #3C
  db #38, #30, #34, #6C, #22, #00, #B9, #A0, #00, #00, #00, #40, #62, #0D, #9E, #87
  db #40, #19, #4B, #4A, #04, #26, #C1, #4A, #85, #82, #48, #40, #00, #00, #00, #00
  db #00, #00, #00, #11, #63, #38, #38, #30, #3C, #30, #30, #C3, #92, #30, #30, #61
  db #00, #00, #00, #00, #00, #62, #BE, #93, #B1, #B1, #D0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #72, #7B, #24, #96, #A5, #63, #3C, #3C, #3C, #3C, #30
  db #75, #BA, #00, #85, #87, #A0, #00, #00, #54, #04, #4B, #C0, #62, #C0, #4B, #19
  db #49, #49, #49, #86, #62, #19, #48, #87, #84, #26, #26, #26, #86, #C3, #C9, #69
  db #3C, #3C, #0A, #00, #00, #11, #BB, #B2, #34, #61, #96, #D0, #E1, #63, #30, #C3
  db #63, #33, #B1, #D0, #A0, #61, #93, #C3, #63, #C3, #63, #22, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #54, #88, #A8, #00, #DC, #80, #00, #00, #00, #50, #00, #00
  db #40, #40, #40, #00, #80, #C0, #C0, #C0, #C0, #C0, #C0, #C8, #40, #C0, #D1, #5B
  db #48, #D3, #86, #49, #49, #49, #49, #49, #48, #59, #86, #E3, #49, #0C, #86, #80
  db #0C, #A7, #E2, #E2, #C0, #C0, #D1, #5B, #84, #C0, #C0, #A5, #00, #80, #40, #00
  db #00, #80, #00, #80, #40, #40, #40, #00, #40, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #54, #40, #A8, #F4, #A0, #00, #00, #40, #40, #54, #00, #A0
  db #50, #00, #00, #80, #40, #80, #C0, #C0, #C0, #5B, #C0, #DC, #C8, #84, #D1, #5B
  db #5B, #0C, #92, #30, #30, #30, #34, #38, #24, #0C, #86, #49, #49, #49, #80, #04
  db #49, #0C, #D3, #84, #D1, #5B, #84, #0C, #A6, #C0, #E2, #E2, #85, #C0, #C0, #40
  db #00, #40, #00, #40, #40, #00, #40, #00, #80, #40, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #80, #00, #00, #50, #A8, #00, #00, #00, #00, #40, #B1
  db #00, #80, #40, #40, #C0, #C0, #40, #C0, #C0, #C0, #4A, #54, #54, #04, #A7, #E3
  db #34, #9E, #3C, #3C, #3C, #38, #3C, #3C, #6D, #C7, #24, #86, #58, #00, #00, #84
  db #86, #49, #0C, #A6, #0C, #86, #A6, #A6, #0C, #A6, #A6, #80, #40, #40, #40, #00
  db #40, #40, #80, #80, #80, #80, #C0, #40, #40, #00, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #50, #E8, #00, #00, #00, #A0, #A0, #80, #50, #E8, #00
  db #80, #80, #80, #C0, #C0, #C1, #30, #30, #30, #30, #30, #22, #00, #00, #00, #96
  db #4D, #1C, #9E, #9E, #9E, #9E, #CB, #8E, #0C, #0E, #1E, #0A, #00, #00, #00, #49
  db #0C, #0C, #86, #49, #0C, #86, #59, #86, #86, #59, #84, #80, #C0, #40, #C0, #40
  db #40, #91, #80, #80, #80, #50, #20, #40, #40, #00, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #A8, #80, #A0, #E0, #40
  db #40, #40, #90, #3C, #72, #44, #C4, #B1, #33, #D8, #99, #08, #00, #00, #00, #00
  db #41, #0C, #8E, #0C, #8E, #0E, #0D, #0D, #A7, #85, #00, #00, #00, #00, #94, #9E
  db #1C, #2C, #2C, #2C, #86, #49, #0C, #86, #49, #0C, #0C, #0C, #E2, #C0, #C0, #40
  db #C0, #90, #80, #40, #C0, #10, #62, #40, #00, #80, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #A0, #A0, #A0
  db #80, #32, #F9, #D9, #73, #F3, #73, #99, #B3, #B3, #A8, #A8, #00, #00, #00, #00
  db #00, #00, #85, #48, #0D, #0D, #85, #C0, #80, #00, #00, #00, #00, #14, #38, #3C
  db #9E, #6D, #3C, #2C, #2C, #2C, #2C, #C7, #5A, #48, #48, #85, #C0, #C0, #62, #C0
  db #40, #64, #40, #40, #C0, #31, #C0, #40, #80, #80, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #50, #50, #50, #50, #50, #E0, #B1, #A0
  db #B4, #54, #76, #95, #B2, #98, #30, #71, #F3, #76, #33, #65, #38, #25, #00, #00
  db #11, #11, #FC, #00, #0E, #4A, #85, #AD, #00, #00, #00, #00, #6D, #00, #11, #96
  db #3C, #34, #3C, #3C, #3C, #6D, #3C, #1C, #CB, #0C, #C2, #0C, #85, #90, #C8, #85
  db #C1, #33, #80, #40, #32, #62, #80, #C0, #80, #80, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #40, #40, #A8, #D4, #D4, #D4, #D0, #E0, #72, #F0, #B1
  db #A5, #00, #00, #A0, #BD, #D1, #F3, #11, #A8, #00, #04, #26, #85, #00, #A0, #31
  db #54, #22, #00, #50, #00, #40, #00, #A8, #00, #00, #00, #2C, #5B, #D9, #9C, #38
  db #30, #30, #3C, #9A, #3C, #3C, #3C, #3C, #3C, #2C, #49, #4A, #48, #C6, #26, #C0
  db #32, #62, #C0, #91, #31, #C0, #C0, #C0, #C0, #40, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #50, #50, #50, #50, #50, #50, #50, #D0, #B1, #F0, #72
  db #62, #00, #00, #00, #00, #00, #54, #00, #00, #00, #0E, #80, #00, #00, #4B, #9B
  db #00, #10, #61, #00, #00, #4A, #00, #00, #00, #00, #40, #0A, #50, #2F, #3C, #38
  db #34, #28, #39, #33, #9E, #9E, #30, #69, #1C, #0C, #86, #49, #0C, #31, #C0, #4A
  db #31, #62, #C0, #31, #62, #91, #C0, #C0, #40, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #50, #D4, #D0, #50, #50, #D0, #F0, #72, #72, #72
  db #33, #D4, #00, #A8, #00, #A8, #00, #00, #00, #B1, #73, #A2, #A8, #4B, #2C, #91
  db #08, #A8, #40, #90, #30, #72, #50, #40, #00, #40, #C0, #00, #00, #4A, #0D, #08
  db #51, #73, #F3, #D9, #B3, #A8, #6D, #3C, #34, #2C, #86, #86, #19, #93, #48, #4C
  db #63, #84, #1A, #AD, #42, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #D0, #91, #40, #40, #50, #B1, #B1, #F0, #72, #72
  db #D2, #C3, #50, #54, #E8, #A8, #A8, #73, #7B, #F1, #76, #B5, #14, #9E, #9B, #C0
  db #40, #85, #4A, #11, #96, #82, #80, #40, #85, #40, #00, #00, #40, #0E, #80, #76
  db #11, #54, #B9, #98, #E6, #E6, #72, #00, #96, #38, #2C, #49, #4C, #26, #86, #D8
  db #26, #19, #70, #0B, #C0, #07, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #E0, #A5, #00, #C0, #D0, #40, #11, #B1, #B1, #B1, #B1
  db #E1, #E1, #A5, #A0, #22, #E8, #A8, #50, #7B, #F1, #B3, #A2, #86, #86, #4B, #4B
  db #4B, #4A, #05, #00, #40, #00, #85, #C0, #40, #80, #54, #00, #40, #00, #00, #00
  db #00, #00, #00, #A8, #54, #73, #B3, #A2, #00, #33, #F3, #76, #11, #F3, #73, #1B
  db #86, #B3, #23, #48, #48, #48, #C0, #C0, #48, #84, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #80, #40, #40, #40, #C0, #80, #B1, #E1, #B1, #E1, #72
  db #93, #D2, #63, #C3, #62, #A0, #00, #40, #B9, #B9, #B9, #BC, #96, #49, #CB, #0B
  db #26, #62, #00, #85, #27, #C0, #C0, #05, #85, #00, #E8, #7E, #00, #A8, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #2A, #00, #11, #99, #51, #33, #B7, #22, #73
  db #33, #A4, #49, #0C, #07, #07, #07, #07, #07, #07, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #40, #40, #40, #85, #C0, #C0, #5A, #72, #72, #63, #E1
  db #63, #63, #63, #61, #93, #82, #76, #00, #00, #A8, #76, #C1, #0E, #26, #86, #87
  db #86, #4A, #85, #91, #19, #0D, #48, #40, #C0, #7B, #73, #76, #76, #A8, #00, #A8
  db #A8, #E8, #A8, #A0, #A8, #11, #00, #A5, #51, #99, #B9, #B3, #15, #50, #11, #AD
  db #41, #49, #0C, #86, #49, #49, #09, #0B, #0B, #0B, #0B, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #91, #80, #C0, #C0, #C0, #4A, #85, #13, #93, #93, #C3
  db #63, #C3, #C3, #E1, #63, #4A, #91, #73, #F6, #00, #00, #00, #87, #86, #26, #26
  db #4A, #C0, #40, #19, #19, #49, #4B, #0E, #91, #7A, #76, #72, #6A, #A8, #00, #E8
  db #B9, #54, #D1, #0A, #10, #61, #93, #80, #00, #11, #B3, #2A, #A0, #00, #00, #27
  db #86, #86, #49, #0C, #86, #86, #86, #49, #49, #0C, #0E, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #80, #58, #C0, #48, #84, #A4, #87, #13, #13, #C3, #63
  db #C3, #36, #C3, #63, #C2, #80, #00, #26, #00, #22, #54, #05, #4B, #80, #80, #80
  db #40, #27, #80, #C0, #86, #5A, #4A, #4A, #76, #D4, #00, #00, #00, #00, #00, #00
  db #00, #50, #00, #D0, #1B, #D2, #5A, #80, #11, #76, #22, #22, #11, #00, #E9, #CB
  db #CB, #CB, #8E, #3C, #3C, #38, #96, #30, #30, #98, #62, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E0, #1F, #0B, #0B, #26, #1D, #0B, #86, #0C, #A4, #C3
  db #75, #73, #33, #40, #91, #C3, #62, #80, #00, #E8, #00, #00, #87, #87, #87, #84
  db #A4, #84, #C1, #4B, #0E, #00, #80, #80, #00, #00, #00, #00, #00, #00, #00, #00
  db #4A, #27, #96, #30, #38, #C3, #63, #D5, #73, #A8, #54, #00, #00, #00, #3C, #C7
  db #96, #3C, #34, #92, #64, #C3, #D2, #E0, #62, #40, #D4, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #D0, #07, #8D, #43, #48, #49, #0D, #06, #86, #86, #BA
  db #73, #A8, #00, #11, #B3, #E8, #C0, #00, #40, #00, #C0, #00, #00, #40, #4A, #1B
  db #C0, #00, #4A, #00, #C0, #85, #8D, #91, #B9, #A8, #00, #22, #00, #A8, #80, #00
  db #50, #4B, #87, #93, #75, #F3, #22, #00, #A0, #00, #00, #00, #76, #3C, #3C, #30
  db #38, #3C, #30, #61, #CB, #91, #D8, #D0, #D0, #40, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #C1, #84, #43, #C1, #09, #86, #49, #49, #49, #FB, #76
  db #7A, #54, #37, #F4, #00, #00, #00, #11, #30, #31, #00, #A8, #00, #00, #00, #40
  db #40, #00, #00, #40, #40, #40, #00, #54, #76, #00, #00, #A8, #00, #40, #80, #78
  db #05, #61, #73, #33, #A8, #00, #00, #00, #32, #33, #76, #85, #96, #38, #30, #3C
  db #92, #61, #CB, #E4, #72, #E0, #E0, #E0, #C0, #D0, #80, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #8D, #8C, #FA, #77, #A8, #FB, #75, #9B, #FA, #B9, #A8
  db #D4, #2A, #00, #00, #00, #51, #36, #30, #30, #30, #31, #22, #B9, #00, #00, #40
  db #40, #00, #00, #00, #00, #80, #00, #00, #00, #00, #00, #00, #00, #22, #30, #31
  db #41, #87, #F4, #00, #00, #00, #00, #00, #A8, #E2, #AD, #3C, #3C, #30, #61, #38
  db #C3, #E4, #D2, #78, #D0, #C0, #00, #A0, #D0, #50, #C0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #D7, #73, #BB, #00, #F4, #80, #00, #00, #54, #22, #50
  db #00, #00, #00, #22, #30, #38, #30, #30, #75, #00, #92, #35, #32, #00, #22, #00
  db #00, #00, #A0, #A0, #00, #00, #00, #00, #00, #00, #50, #7A, #00, #72, #30, #34
  db #A5, #80, #50, #00, #00, #30, #33, #33, #76, #00, #3C, #3C, #61, #24, #38, #E0
  db #E0, #E0, #72, #D0, #D0, #C0, #D0, #D0, #50, #C0, #40, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #2A, #11, #AD, #51, #F3, #22, #00, #33, #B9, #00, #00
  db #11, #10, #34, #30, #30, #30, #75, #31, #22, #00, #00, #50, #30, #20, #22, #A0
  db #31, #00, #00, #00, #A0, #22, #00, #F4, #22, #A0, #A8, #00, #00, #00, #B8, #30
  db #78, #80, #80, #40, #00, #00, #00, #00, #41, #30, #3C, #34, #92, #61, #31, #C0
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #80, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #B3, #00, #00, #A8, #50, #2A, #54, #00, #00, #14, #3C
  db #3C, #38, #30, #30, #75, #30, #00, #00, #00, #B5, #A0, #A0, #40, #4B, #80, #00
  db #11, #54, #5E, #38, #33, #00, #B5, #00, #00, #00, #00, #00, #00, #00, #E8, #6A
  db #85, #B1, #00, #00, #80, #11, #30, #30, #30, #3C, #3C, #38, #C3, #30, #4A, #40
  db #00, #40, #C1, #88, #00, #00, #00, #E0, #A0, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #10, #A6, #86, #22, #72, #00, #00, #00, #94, #3C, #3C, #38
  db #38, #30, #3C, #3C, #80, #00, #76, #2A, #00, #00, #00, #00, #08, #C2, #4B, #49
  db #5A, #85, #8F, #A5, #26, #87, #26, #85, #87, #91, #91, #49, #49, #1B, #C0, #00
  db #00, #00, #00, #54, #33, #96, #34, #34, #34, #30, #30, #93, #B0, #30, #30, #30
  db #00, #00, #00, #00, #33, #80, #61, #63, #72, #62, #E0, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #10, #A0, #32, #C3, #89, #11, #36, #96, #3C, #3C, #3C, #38
  db #75, #71, #00, #41, #4B, #00, #00, #00, #A8, #19, #19, #C0, #4A, #0A, #19, #49
  db #19, #49, #86, #87, #48, #26, #4A, #87, #C0, #58, #19, #85, #19, #49, #C6, #C6
  db #3C, #3C, #87, #00, #00, #50, #FA, #BE, #30, #86, #92, #C0, #F0, #D2, #34, #93
  db #33, #B1, #A5, #A5, #A0, #61, #63, #93, #C3, #63, #93, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #00, #00, #A0, #A8, #00, #00, #00, #00, #A0, #00
  db #00, #80, #80, #00, #40, #C0, #C0, #C0, #40, #D1, #C0, #88, #C0, #C0, #5B, #5B
  db #0E, #A6, #49, #0C, #86, #86, #0C, #86, #59, #0C, #59, #0C, #86, #49, #0C, #80
  db #0C, #59, #5B, #C0, #C0, #D1, #5B, #48, #48, #E2, #D0, #5A, #40, #40, #00, #00
  db #40, #40, #80, #00, #00, #80, #00, #40, #00, #80, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #44, #A0, #A0, #A0, #F4, #00, #00, #00, #80, #00, #00, #00
  db #E4, #00, #00, #00, #80, #C0, #40, #C0, #C0, #E2, #5B, #52, #42, #E2, #48, #A7
  db #A6, #C3, #30, #30, #38, #30, #30, #3C, #30, #49, #49, #0C, #86, #0C, #00, #04
  db #0C, #86, #59, #48, #48, #48, #48, #59, #59, #48, #D1, #84, #8C, #84, #A0, #80
  db #80, #80, #00, #80, #50, #40, #00, #80, #40, #00, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #00, #54, #50, #A8, #00, #00, #00, #00, #54, #D4
  db #00, #00, #40, #40, #40, #C0, #C0, #C0, #C0, #C0, #85, #00, #A8, #50, #59, #73
  db #34, #9E, #9E, #3C, #3C, #3C, #3C, #3C, #6D, #0C, #61, #0C, #82, #00, #00, #4B
  db #0C, #86, #0C, #86, #86, #0C, #A6, #A6, #59, #59, #59, #80, #80, #C0, #00, #40
  db #40, #00, #80, #D0, #40, #40, #40, #80, #80, #40, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #50, #F4, #80, #00, #00, #50, #50, #E8, #E8, #A0, #50
  db #40, #00, #C0, #40, #85, #92, #34, #34, #30, #30, #34, #22, #00, #00, #00, #1C
  db #1C, #8E, #6D, #6D, #6D, #6D, #C7, #0C, #0E, #0E, #1C, #00, #00, #00, #00, #86
  db #86, #86, #0C, #86, #49, #0C, #49, #0C, #0C, #0C, #C0, #40, #48, #C0, #C0, #C0
  db #40, #90, #40, #40, #00, #91, #62, #00, #80, #40, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #54, #80, #E8, #72, #50, #00
  db #80, #C0, #10, #61, #76, #33, #F8, #D8, #76, #E4, #11, #A0, #00, #00, #00, #00
  db #05, #0C, #0C, #8E, #0C, #0D, #0C, #0E, #4A, #4A, #00, #00, #00, #00, #4B, #6D
  db #6D, #C7, #C7, #C7, #49, #0C, #49, #0C, #86, #0C, #0C, #0C, #D0, #4A, #C0, #C0
  db #C0, #90, #C0, #80, #80, #B0, #62, #40, #40, #00, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #A0, #E8, #E8, #E8, #E8, #E8, #A0, #80
  db #C0, #38, #73, #CC, #F3, #F3, #D9, #F3, #73, #73, #22, #51, #08, #00, #00, #00
  db #00, #00, #04, #0E, #84, #4A, #0B, #C0, #80, #00, #00, #00, #00, #14, #3C, #34
  db #6D, #3C, #9E, #3C, #9E, #1C, #1C, #1C, #07, #06, #84, #81, #4A, #91, #62, #80
  db #C0, #64, #80, #D0, #05, #31, #80, #C0, #40, #40, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #50, #50, #50, #54, #D4, #E0, #F0, #F0, #D0
  db #14, #54, #76, #7E, #66, #30, #30, #E6, #B3, #7E, #73, #9E, #9A, #6D, #00, #00
  db #54, #00, #22, #00, #84, #4A, #40, #15, #54, #00, #00, #00, #9E, #51, #40, #1E
  db #3C, #38, #3C, #3C, #3C, #3C, #9E, #9E, #86, #86, #C1, #48, #4A, #18, #E2, #C0
  db #90, #72, #40, #40, #32, #62, #C0, #40, #C0, #40, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #54, #80, #E8, #E8, #E8, #E8, #F8, #F0, #72, #72
  db #22, #00, #A8, #54, #D4, #7A, #73, #7A, #00, #00, #41, #4A, #4A, #00, #54, #6C
  db #50, #54, #00, #00, #22, #80, #00, #00, #00, #00, #00, #2D, #59, #E6, #B4, #3C
  db #30, #30, #3C, #9A, #34, #3C, #3C, #3C, #3C, #69, #0C, #84, #0D, #13, #C2, #48
  db #92, #E2, #C0, #91, #31, #C0, #C0, #80, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #A0, #A0, #E0, #B1, #F0, #72, #72
  db #A5, #00, #00, #00, #00, #54, #15, #00, #22, #00, #58, #80, #00, #50, #1E, #9B
  db #00, #14, #61, #62, #00, #85, #00, #A0, #00, #00, #05, #0A, #A8, #33, #9E, #3C
  db #34, #1B, #76, #33, #C7, #3C, #38, #3C, #C7, #86, #49, #48, #0C, #99, #85, #07
  db #71, #23, #4A, #31, #23, #C0, #C0, #40, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #A0, #A0, #E0, #E8, #A0, #A0, #F0, #D0, #B1, #B1, #B1
  db #B1, #80, #A8, #54, #00, #54, #00, #A8, #A8, #E8, #7B, #73, #B9, #1C, #0D, #85
  db #27, #00, #11, #62, #62, #00, #00, #40, #00, #40, #4A, #00, #00, #84, #C1, #0A
  db #B3, #B3, #F3, #F3, #F3, #2A, #63, #9E, #38, #69, #49, #0C, #49, #C9, #0C, #92
  db #33, #48, #C6, #23, #C0, #C0, #C0, #80, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E0, #E0, #72, #40, #40, #40, #72, #72, #72, #B1, #B1
  db #E1, #B1, #95, #50, #54, #D4, #00, #73, #73, #73, #F3, #7A, #AC, #3C, #6D, #80
  db #C0, #91, #08, #50, #63, #80, #00, #40, #4A, #40, #00, #00, #05, #62, #00, #76
  db #54, #AD, #F9, #98, #64, #F3, #B7, #A8, #67, #38, #3C, #0C, #18, #63, #49, #C8
  db #26, #93, #99, #07, #81, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #5A, #62, #80, #40, #11, #80, #91, #F0, #72, #D2, #D2
  db #D2, #93, #A5, #80, #A0, #54, #00, #BD, #B1, #7B, #73, #22, #69, #19, #49, #0F
  db #07, #C2, #91, #00, #00, #40, #C0, #0A, #40, #0A, #00, #00, #50, #00, #00, #00
  db #00, #00, #A8, #54, #00, #B9, #B7, #B9, #00, #F9, #73, #11, #33, #F3, #B3, #33
  db #49, #88, #86, #09, #C1, #84, #C0, #48, #85, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #22, #00, #91, #C0, #80, #C0, #5A, #72, #23, #72, #93
  db #72, #93, #C1, #C3, #C2, #80, #A0, #00, #A8, #33, #76, #63, #CB, #2C, #87, #87
  db #C1, #4A, #80, #91, #49, #4A, #C0, #C0, #4A, #00, #76, #76, #50, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #54, #00, #00, #E4, #F3, #11, #33, #F2, #A2, #33
  db #B3, #A4, #86, #49, #09, #0B, #48, #48, #48, #4A, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #80, #C0, #C0, #62, #C0, #C0, #91, #E1, #E1, #B1, #93
  db #93, #C3, #C3, #34, #C3, #62, #B9, #00, #00, #54, #11, #41, #19, #19, #49, #4B
  db #0E, #85, #C0, #4B, #49, #4B, #4B, #80, #D4, #33, #B3, #F2, #B9, #00, #A8, #54
  db #54, #D4, #50, #54, #D4, #11, #40, #0A, #11, #F3, #11, #7B, #11, #11, #50, #11
  db #84, #2C, #86, #49, #0C, #0C, #06, #06, #07, #07, #07, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #C0, #A5, #40, #4A, #85, #C1, #C0, #63, #E1, #63, #93
  db #C3, #C3, #C3, #1B, #C2, #A5, #85, #B9, #F6, #00, #00, #00, #4B, #4B, #0E, #5A
  db #48, #80, #85, #84, #26, #87, #86, #87, #91, #B5, #B1, #B9, #A8, #A8, #54, #D4
  db #5E, #91, #22, #00, #96, #61, #27, #A0, #00, #11, #F9, #A8, #00, #22, #00, #63
  db #CB, #0C, #86, #86, #49, #49, #CB, #CB, #8E, #0C, #0E, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #80, #E0, #85, #07, #07, #09, #09, #23, #4B, #93, #C3
  db #C3, #61, #61, #87, #82, #C0, #00, #85, #80, #A8, #00, #40, #2D, #87, #40, #00
  db #27, #58, #4A, #40, #4B, #0D, #85, #85, #A0, #A8, #00, #00, #00, #00, #00, #00
  db #00, #C0, #C0, #91, #93, #93, #C0, #80, #11, #A8, #A0, #3B, #11, #00, #14, #1C
  db #1C, #1C, #1C, #3C, #3C, #61, #38, #64, #92, #38, #91, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #80, #A5, #13, #13, #06, #86, #0C, #49, #49, #48, #C3
  db #71, #76, #A0, #E8, #63, #C3, #87, #80, #00, #54, #00, #00, #86, #26, #4A, #62
  db #C0, #4A, #62, #0D, #87, #82, #40, #00, #54, #00, #00, #00, #00, #A8, #00, #40
  db #C0, #B1, #C3, #38, #61, #39, #C2, #31, #F6, #22, #54, #22, #A8, #11, #1C, #3C
  db #9E, #3C, #24, #38, #61, #C9, #7A, #80, #88, #D0, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #62, #4E, #0B, #86, #49, #06, #49, #49, #0C, #0C, #75
  db #37, #A0, #00, #B9, #B7, #62, #A0, #00, #91, #00, #40, #80, #00, #85, #A4, #86
  db #C0, #00, #26, #A0, #40, #C0, #4A, #D4, #22, #00, #54, #A8, #54, #00, #00, #40
  db #05, #A5, #C3, #30, #FF, #B3, #A8, #54, #00, #00, #00, #00, #22, #3C, #38, #38
  db #38, #92, #30, #C7, #D2, #4E, #E1, #D0, #C0, #22, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #C2, #C2, #86, #83, #86, #49, #49, #49, #39, #31, #B9
  db #A0, #11, #F9, #AD, #A8, #00, #00, #90, #30, #31, #00, #A0, #00, #00, #80, #80
  db #00, #00, #00, #00, #80, #80, #00, #11, #E8, #00, #54, #00, #00, #40, #14, #20
  db #5E, #69, #BB, #F6, #D4, #00, #00, #00, #30, #33, #AD, #41, #3C, #3C, #34, #30
  db #38, #92, #C6, #D2, #66, #D0, #D0, #C0, #E0, #E0, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #4E, #4B, #35, #73, #22, #33, #F3, #73, #73, #51, #00
  db #AD, #A8, #00, #00, #00, #B9, #38, #30, #30, #30, #30, #72, #2A, #A0, #00, #00
  db #80, #00, #00, #00, #00, #40, #00, #80, #00, #00, #00, #00, #11, #B9, #30, #31
  db #41, #63, #E8, #A8, #00, #00, #00, #00, #11, #11, #A0, #3C, #38, #61, #69, #30
  db #C3, #99, #C8, #70, #D0, #D0, #00, #C0, #50, #50, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #59, #73, #72, #A8, #E8, #00, #00, #54, #80, #A8, #11
  db #00, #00, #11, #11, #30, #30, #30, #30, #71, #00, #32, #60, #B2, #22, #B5, #00
  db #00, #50, #6A, #AD, #A8, #00, #00, #00, #00, #B9, #54, #95, #50, #00, #30, #34
  db #D0, #40, #00, #00, #00, #10, #B9, #33, #A8, #05, #3C, #34, #61, #69, #61, #C0
  db #80, #80, #C2, #E0, #E0, #E0, #E0, #A5, #40, #40, #D0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #00, #50, #22, #51, #B3, #22, #A2, #76, #A8, #00, #00
  db #A8, #38, #38, #38, #30, #30, #30, #31, #00, #A8, #00, #00, #30, #20, #20, #A0
  db #20, #C0, #00, #40, #80, #22, #A8, #11, #B9, #00, #22, #00, #00, #00, #32, #30
  db #20, #C0, #00, #80, #00, #00, #00, #00, #14, #30, #3C, #38, #92, #69, #60, #D0
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #40, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #72, #00, #00, #00, #11, #A0, #11, #00, #00, #14, #3C
  db #3C, #34, #30, #30, #38, #33, #00, #00, #B9, #22, #A8, #00, #C0, #85, #4A, #80
  db #50, #2A, #10, #30, #A8, #50, #00, #00, #40, #00, #00, #00, #00, #54, #C0, #00
  db #B9, #33, #00, #00, #40, #31, #30, #30, #30, #3C, #3C, #30, #38, #30, #60, #00
  db #00, #00, #C9, #80, #00, #00, #00, #72, #5A, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #10, #86, #C3, #B5, #33, #00, #00, #00, #69, #3C, #3C, #3C
  db #30, #75, #3C, #87, #C2, #11, #B9, #00, #00, #00, #54, #40, #62, #4A, #C2, #C6
  db #86, #4A, #91, #85, #86, #62, #86, #91, #4A, #62, #0D, #86, #86, #86, #C3, #4A
  db #00, #00, #00, #05, #A5, #86, #3C, #34, #38, #30, #38, #D2, #96, #30, #30, #34
  db #40, #00, #00, #E0, #E0, #00, #61, #93, #93, #E0, #62, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #11, #B2, #49, #2D, #B9, #69, #3C, #3C, #3C, #3C, #30
  db #34, #FB, #00, #05, #87, #A0, #00, #00, #05, #26, #62, #48, #91, #C0, #4B, #49
  db #86, #C6, #C3, #4B, #C1, #4B, #91, #48, #85, #84, #26, #4B, #0E, #86, #C3, #C9
  db #3C, #3C, #69, #00, #00, #00, #33, #F5, #34, #C3, #34, #50, #C0, #93, #61, #C3
  db #C2, #33, #F0, #5A, #91, #39, #C3, #63, #93, #93, #93, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #E4, #00, #00, #F8, #00, #00, #00, #00, #50, #54, #00
  db #00, #40, #40, #00, #80, #C0, #80, #C0, #C0, #C0, #48, #D8, #C0, #C0, #A7, #A7
  db #A6, #4B, #0C, #86, #49, #49, #49, #0C, #86, #E3, #A6, #0C, #49, #0C, #87, #80
  db #0C, #0C, #E2, #48, #C0, #C0, #A7, #A6, #D1, #C0, #C0, #E0, #40, #40, #00, #00
  db #80, #80, #40, #40, #40, #00, #00, #00, #80, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #A8, #A0, #A0, #E0, #00, #00, #40, #00, #00, #A0, #00
  db #F4, #00, #00, #40, #40, #40, #C0, #C0, #C0, #5B, #85, #A1, #D0, #5B, #0E, #D1
  db #4E, #18, #34, #3C, #30, #30, #30, #3C, #38, #2C, #0C, #86, #49, #0D, #00, #41
  db #49, #0C, #49, #84, #A6, #A7, #D1, #0C, #A6, #D1, #48, #E2, #C1, #48, #00, #C0
  db #00, #80, #40, #40, #40, #00, #80, #40, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #A0, #A0, #00, #A0, #76, #00, #00, #00, #00, #50, #50
  db #00, #80, #40, #40, #C0, #C0, #40, #C0, #C0, #C0, #C0, #54, #00, #A8, #58, #0C
  db #65, #6D, #3C, #9E, #3C, #3C, #3C, #6D, #2C, #2C, #3C, #86, #80, #00, #00, #86
  db #49, #0C, #0C, #E3, #0C, #0C, #59, #0C, #0C, #0C, #B3, #80, #40, #00, #80, #80
  db #40, #40, #40, #62, #50, #40, #E8, #00, #00, #80, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #F0, #54, #00, #00, #00, #40, #00, #A0, #22, #80
  db #80, #40, #40, #C0, #10, #30, #34, #3C, #92, #34, #38, #28, #00, #00, #00, #14
  db #4D, #1C, #4D, #CB, #8E, #6D, #1C, #0C, #0E, #0E, #0E, #00, #00, #00, #40, #86
  db #49, #0C, #86, #0C, #86, #0C, #86, #0C, #0C, #49, #85, #84, #E2, #C0, #C0, #80
  db #80, #90, #C0, #00, #80, #11, #C8, #40, #00, #80, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #50, #50, #72, #50, #40
  db #40, #40, #34, #31, #33, #73, #D8, #B9, #B9, #E8, #E8, #A8, #00, #00, #00, #00
  db #00, #0C, #0C, #0C, #0D, #0C, #0E, #4A, #48, #80, #00, #00, #00, #00, #1E, #9E
  db #9E, #9E, #9E, #CB, #8E, #86, #86, #49, #4D, #C7, #0C, #48, #E0, #C0, #C0, #C0
  db #C0, #81, #C0, #40, #40, #23, #D0, #40, #40, #00, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #50, #54, #D4, #D4, #D4, #D4, #D0, #40
  db #40, #31, #F3, #D9, #F3, #D9, #E6, #99, #B3, #B3, #FC, #5B, #8A, #00, #00, #00
  db #00, #00, #40, #0D, #84, #4A, #0F, #C0, #00, #00, #00, #00, #00, #1E, #3C, #34
  db #3C, #9E, #3C, #9E, #6D, #2C, #2C, #2C, #49, #0C, #C2, #4A, #07, #91, #C2, #40
  db #C0, #64, #80, #40, #11, #31, #C0, #00, #80, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #A0, #A0, #A0, #E0, #F8, #D0, #F0, #62
  db #B4, #00, #B5, #D4, #33, #98, #30, #D9, #73, #A8, #F6, #CF, #6D, #4D, #00, #00
  db #A8, #33, #A8, #00, #05, #C0, #00, #50, #01, #00, #00, #40, #6D, #F1, #2A, #94
  db #3C, #3C, #34, #3C, #3C, #6D, #6D, #6D, #2C, #49, #0C, #84, #84, #B0, #42, #85
  db #90, #62, #4A, #40, #32, #62, #80, #C0, #40, #C0, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #80, #50, #54, #D4, #D4, #D4, #D0, #91, #B1, #F0
  db #62, #00, #54, #00, #A8, #B5, #33, #BD, #00, #00, #85, #C2, #0A, #00, #00, #6C
  db #00, #22, #00, #54, #22, #4A, #00, #54, #00, #00, #00, #2C, #91, #73, #14, #38
  db #30, #30, #6D, #38, #30, #34, #3C, #3C, #3C, #24, #86, #C2, #0C, #B3, #87, #84
  db #32, #62, #80, #90, #B3, #C0, #C0, #C0, #C0, #40, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E8, #E8, #E8, #E8, #50, #50, #50, #E0, #72, #B1, #B1
  db #B1, #00, #00, #00, #00, #54, #54, #54, #F6, #40, #0F, #00, #00, #00, #2D, #86
  db #A8, #11, #93, #93, #80, #4A, #00, #80, #00, #00, #11, #80, #54, #67, #4D, #9E
  db #3C, #11, #73, #B9, #6B, #CF, #38, #30, #1C, #49, #0C, #86, #0C, #31, #09, #0B
  db #99, #62, #85, #31, #C0, #C0, #80, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #D0, #50, #D4, #D0, #50, #E0, #F0, #72, #F0, #72
  db #72, #5E, #54, #54, #00, #A8, #00, #00, #54, #D4, #11, #F3, #37, #C7, #4A, #05
  db #07, #D4, #40, #63, #63, #22, #00, #00, #00, #80, #80, #00, #00, #4A, #48, #0A
  db #B3, #F3, #F3, #F3, #F3, #76, #91, #6D, #38, #69, #0C, #86, #5D, #E3, #0C, #4C
  db #26, #06, #32, #A5, #C0, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #D0, #D0, #00, #80, #D0, #00, #B1, #B1, #B1, #B1, #B1
  db #B1, #D2, #91, #54, #A0, #E8, #A8, #37, #B3, #F3, #73, #76, #41, #1C, #3C, #4A
  db #40, #27, #82, #80, #62, #00, #00, #C0, #4A, #40, #00, #15, #40, #48, #00, #A8
  db #B9, #A8, #33, #CC, #30, #F3, #33, #A8, #4B, #9A, #34, #59, #E4, #63, #0C, #D8
  db #0C, #90, #33, #42, #C0, #84, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #B1, #A5, #40, #00, #C0, #40, #50, #72, #72, #63, #B1
  db #63, #63, #B1, #D0, #11, #00, #A0, #54, #76, #33, #B3, #E2, #3C, #49, #4B, #19
  db #0B, #1B, #80, #80, #00, #40, #C0, #00, #40, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #51, #B3, #B9, #73, #76, #A0, #11, #A2, #66, #B3, #73, #E6, #91
  db #49, #A2, #86, #09, #0C, #C0, #48, #85, #C0, #85, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #00, #80, #D0, #40, #C0, #C0, #B1, #E1, #B1, #E1, #E1
  db #E1, #63, #E1, #C3, #93, #D4, #2A, #00, #F4, #B5, #76, #AC, #C7, #C3, #49, #4B
  db #4A, #C2, #00, #C1, #0D, #82, #C0, #C0, #85, #00, #B1, #B9, #54, #A0, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #F9, #D9, #22, #73, #37, #A2, #33
  db #22, #26, #49, #0C, #49, #06, #48, #48, #48, #42, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #40, #40, #85, #C0, #62, #4A, #91, #D2, #D2, #93, #D2
  db #C3, #93, #13, #34, #93, #C2, #F8, #22, #00, #00, #A0, #AC, #86, #26, #26, #87
  db #87, #C2, #85, #86, #87, #87, #87, #62, #11, #F1, #73, #76, #76, #A0, #00, #A8
  db #A0, #F8, #A8, #A0, #A8, #22, #41, #E0, #51, #D9, #11, #B1, #11, #E8, #15, #50
  db #4B, #0C, #49, #0C, #49, #49, #0C, #48, #09, #0B, #0B, #0A, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #50, #C0, #C0, #91, #C0, #4A, #4A, #93, #93, #93, #C3
  db #C3, #C3, #93, #A5, #A5, #D0, #91, #50, #B3, #00, #00, #00, #85, #07, #87, #87
  db #91, #80, #85, #91, #19, #49, #4B, #0B, #5A, #7A, #7A, #7E, #D4, #00, #54, #50
  db #A8, #37, #00, #11, #92, #C3, #62, #80, #00, #11, #B9, #00, #A8, #00, #11, #14
  db #0C, #86, #49, #49, #0C, #C7, #86, #C7, #0C, #69, #C3, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #A0, #C0, #C0, #0B, #0B, #26, #06, #49, #C1, #63, #C3
  db #C3, #61, #39, #C2, #C2, #22, #40, #40, #0A, #54, #00, #11, #86, #26, #26, #27
  db #13, #0D, #42, #40, #85, #26, #62, #4A, #22, #00, #00, #00, #00, #00, #00, #00
  db #00, #50, #C0, #41, #96, #93, #C2, #C0, #54, #76, #00, #22, #11, #00, #26, #2C
  db #2C, #2C, #3C, #3C, #61, #96, #30, #C3, #C9, #70, #C1, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #40, #C0, #4A, #0B, #4B, #0C, #83, #86, #0C, #86, #4B
  db #31, #B3, #A8, #A8, #C3, #96, #62, #80, #40, #00, #00, #00, #19, #48, #C0, #80
  db #80, #C0, #00, #26, #4B, #0B, #80, #D4, #11, #54, #00, #00, #54, #00, #00, #40
  db #0A, #63, #96, #98, #69, #C3, #33, #FA, #3B, #00, #00, #F4, #00, #11, #3C, #6D
  db #3C, #38, #69, #30, #C9, #C3, #E0, #11, #80, #E0, #E0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #42, #A5, #13, #06, #8D, #49, #0C, #86, #0C, #86, #FB
  db #72, #A8, #00, #73, #72, #A8, #80, #00, #14, #22, #00, #00, #00, #40, #19, #19
  db #C0, #00, #4E, #4A, #00, #C0, #C0, #54, #00, #00, #11, #00, #00, #A8, #00, #40
  db #50, #4E, #32, #FF, #F3, #33, #00, #00, #00, #00, #00, #BC, #E9, #3C, #3C, #30
  db #34, #92, #34, #CB, #C2, #72, #C8, #E0, #E0, #D0, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #C1, #C1, #C1, #49, #49, #0C, #86, #96, #5D, #B3, #76
  db #22, #11, #76, #2A, #00, #00, #00, #36, #30, #30, #A0, #2A, #00, #00, #C0, #00
  db #00, #00, #00, #00, #00, #40, #00, #50, #2A, #00, #00, #A8, #00, #00, #1E, #60
  db #E8, #C3, #BB, #B9, #A8, #00, #00, #00, #30, #B9, #76, #14, #3C, #38, #34, #61
  db #30, #6D, #C3, #E0, #70, #D0, #C0, #E0, #D0, #11, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #8D, #87, #70, #3B, #A2, #51, #33, #F1, #7A, #B7, #80
  db #F4, #80, #00, #00, #00, #B3, #30, #30, #30, #30, #B2, #33, #50, #15, #00, #00
  db #00, #00, #80, #00, #00, #00, #40, #00, #00, #00, #00, #00, #11, #B1, #30, #34
  db #41, #C2, #76, #00, #00, #00, #73, #40, #E8, #76, #63, #3C, #38, #61, #69, #61
  db #C6, #66, #72, #D2, #C0, #E0, #E0, #A0, #E0, #40, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #33, #B9, #B5, #33, #54, #00, #00, #00, #00, #00, #B5
  db #00, #00, #B4, #38, #34, #30, #30, #30, #31, #00, #10, #31, #31, #20, #A0, #00
  db #54, #D4, #95, #F4, #80, #00, #00, #00, #00, #22, #A0, #72, #15, #80, #30, #34
  db #E0, #D4, #80, #00, #00, #00, #76, #00, #00, #41, #38, #38, #61, #78, #60, #C0
  db #40, #00, #28, #00, #50, #50, #D0, #80, #E0, #80, #C0, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #00, #54, #80, #B9, #B3, #B9, #B3, #50, #00, #00, #00
  db #27, #34, #34, #30, #30, #30, #BA, #BB, #00, #00, #54, #00, #32, #20, #70, #00
  db #20, #40, #00, #00, #A0, #22, #A0, #E8, #76, #80, #A8, #00, #A8, #A8, #10, #30
  db #31, #80, #80, #80, #80, #00, #00, #00, #32, #34, #34, #38, #38, #C3, #60, #C0
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #10, #A0, #22, #00, #00, #A0, #22, #54, #00, #00, #36, #3C
  db #3C, #38, #30, #34, #71, #00, #00, #00, #51, #22, #00, #00, #91, #04, #62, #4B
  db #00, #62, #A1, #72, #00, #00, #00, #40, #62, #00, #00, #11, #00, #00, #00, #00
  db #00, #72, #00, #00, #5A, #32, #30, #30, #30, #3C, #3C, #61, #92, #30, #60, #00
  db #00, #00, #C4, #00, #00, #00, #00, #B1, #B1, #80, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #51, #49, #93, #11, #72, #22, #00, #05, #96, #3C, #3C, #38
  db #30, #75, #34, #19, #08, #B9, #76, #00, #00, #00, #00, #82, #C0, #C1, #0E, #4B
  db #1C, #87, #C0, #4B, #19, #0D, #87, #26, #C1, #94, #49, #1C, #96, #1C, #C6, #87
  db #C0, #00, #00, #00, #62, #96, #38, #3C, #30, #30, #92, #62, #93, #30, #30, #61
  db #36, #00, #11, #D0, #00, #B1, #61, #C3, #63, #63, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #33, #61, #C6, #20, #73, #9C, #3C, #3C, #3C, #38, #30
  db #2C, #BB, #00, #54, #49, #0A, #00, #54, #04, #4B, #48, #C2, #40, #C0, #85, #86
  db #86, #C3, #49, #0F, #C1, #0D, #C1, #4A, #85, #87, #C2, #C2, #58, #19, #49, #C6
  db #96, #3C, #2C, #0A, #00, #00, #72, #55, #30, #49, #61, #80, #E0, #93, #C3, #63
  db #33, #72, #62, #A5, #B8, #C3, #93, #C3, #63, #63, #63, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F8, #00, #00, #A0, #A8, #00, #00, #00, #00, #A0, #00
  db #00, #00, #40, #00, #40, #C0, #40, #C0, #C0, #84, #C0, #DC, #C0, #85, #D1, #5B
  db #5B, #0C, #86, #49, #0C, #86, #86, #49, #0C, #0C, #0C, #86, #86, #86, #0D, #40
  db #0C, #0C, #84, #D1, #C0, #E2, #59, #59, #48, #E2, #D0, #C4, #80, #80, #00, #00
  db #C0, #00, #80, #80, #00, #00, #80, #40, #00, #80, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #50, #54, #D4, #00, #00, #00, #80, #80, #00, #50
  db #E0, #00, #00, #80, #80, #80, #C0, #C0, #D1, #85, #E2, #42, #42, #84, #A7, #A7
  db #8D, #30, #3C, #34, #38, #30, #30, #3C, #3C, #61, #49, #49, #0C, #C2, #00, #04
  db #0C, #86, #59, #59, #5B, #59, #84, #A6, #59, #48, #59, #5B, #4A, #40, #40, #80
  db #C0, #00, #80, #80, #D4, #80, #40, #00, #80, #00, #A0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #00, #00, #00, #F0, #00, #00, #00, #00, #D0, #54
  db #40, #00, #40, #40, #40, #C0, #C0, #C0, #C0, #C0, #C0, #00, #54, #00, #D3, #49
  db #6D, #6D, #6D, #3C, #9E, #3C, #9E, #6D, #1C, #0C, #38, #0C, #80, #00, #00, #0E
  db #86, #0C, #49, #0C, #49, #0C, #8C, #A6, #0C, #59, #4A, #C0, #80, #80, #40, #40
  db #40, #00, #A0, #80, #80, #80, #62, #40, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #A0, #A0, #00, #00, #00, #54, #00, #50, #A0, #40
  db #40, #00, #80, #80, #30, #34, #69, #9E, #38, #34, #30, #28, #00, #00, #00, #04
  db #4D, #4D, #1C, #CF, #C7, #CB, #8E, #0C, #4A, #0D, #0D, #00, #00, #00, #11, #49
  db #0C, #2C, #49, #49, #0C, #86, #0C, #86, #0C, #0C, #0C, #0C, #48, #C0, #C0, #80
  db #C0, #10, #00, #80, #40, #11, #42, #00, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #40, #E8, #F0, #00, #80
  db #40, #80, #30, #73, #73, #33, #F6, #5E, #22, #A0, #A8, #54, #00, #00, #00, #00
  db #00, #0E, #0C, #0C, #0C, #0E, #0D, #8D, #85, #80, #00, #00, #00, #00, #C7, #6D
  db #6D, #2C, #3C, #1C, #49, #49, #0C, #86, #1C, #0C, #0C, #C0, #C0, #C0, #C0, #C0
  db #C0, #33, #C0, #40, #00, #93, #62, #80, #80, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #E8, #E8, #E8, #E8, #E8, #A0
  db #C0, #20, #E6, #E6, #E6, #F3, #98, #D9, #73, #73, #A8, #B3, #2D, #00, #00, #00
  db #00, #00, #00, #0D, #C1, #C0, #4A, #C0, #00, #00, #00, #00, #00, #6D, #3C, #38
  db #6D, #3C, #6D, #3C, #9E, #9E, #1C, #1C, #0C, #43, #84, #84, #81, #90, #62, #C0
  db #C0, #64, #80, #80, #90, #B3, #80, #80, #80, #40, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #50, #50, #50, #50, #50, #D0, #E0, #72, #B1
  db #91, #00, #76, #22, #BD, #B2, #E6, #B3, #F3, #A8, #27, #C7, #1C, #1C, #A8, #00
  db #00, #B5, #28, #00, #04, #40, #00, #54, #13, #00, #00, #05, #9E, #73, #B3, #1E
  db #3C, #6D, #3C, #3C, #3C, #3C, #9E, #3C, #86, #86, #49, #48, #4A, #92, #A7, #C0
  db #90, #72, #80, #C0, #71, #62, #C0, #80, #80, #80, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #50, #00, #A0, #A0, #E0, #F8, #E0, #F0, #72, #72
  db #22, #00, #00, #00, #54, #50, #7E, #22, #A8, #00, #26, #85, #80, #00, #54, #38
  db #54, #00, #00, #00, #76, #0D, #00, #00, #00, #00, #00, #2D, #91, #B9, #1E, #3C
  db #30, #30, #3C, #30, #38, #34, #3C, #38, #38, #69, #0D, #06, #0D, #31, #48, #48
  db #64, #62, #40, #C4, #62, #C0, #C0, #80, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #A0, #A0, #E0, #F0, #91, #B1, #F0
  db #27, #00, #00, #00, #00, #00, #11, #00, #B3, #22, #62, #A8, #A0, #00, #87, #19
  db #00, #00, #69, #96, #A0, #80, #40, #00, #00, #00, #04, #00, #54, #14, #1C, #CF
  db #2D, #B9, #7A, #76, #33, #69, #38, #34, #69, #CB, #49, #0D, #09, #D9, #07, #13
  db #31, #0B, #0B, #99, #C0, #C0, #40, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #A0, #A0, #E0, #E8, #A0, #E0, #B1, #E0, #B1, #B1, #B1
  db #E1, #33, #00, #A0, #A8, #54, #00, #B9, #B9, #54, #D4, #73, #B3, #CA, #C0, #40
  db #62, #82, #00, #62, #93, #80, #00, #00, #00, #C0, #00, #00, #00, #C2, #0E, #54
  db #73, #73, #F3, #F3, #F3, #B7, #11, #1E, #38, #3C, #49, #0C, #49, #8C, #07, #12
  db #63, #0B, #BA, #62, #42, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #E0, #A0, #22, #80, #C0, #40, #72, #72, #72, #72, #72
  db #D2, #63, #A0, #50, #50, #54, #00, #72, #F3, #B3, #F3, #F6, #04, #26, #2C, #2D
  db #85, #C0, #4A, #00, #00, #00, #00, #85, #C0, #40, #00, #72, #62, #4A, #00, #A8
  db #50, #2A, #15, #B2, #98, #F3, #B7, #A0, #11, #9E, #30, #73, #98, #63, #0C, #D8
  db #49, #4C, #B1, #48, #81, #4A, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #5A, #62, #22, #80, #80, #80, #91, #B1, #E1, #B1, #E1
  db #B1, #D2, #91, #C2, #80, #A8, #00, #A8, #33, #F9, #7B, #33, #2C, #86, #87, #86
  db #62, #C2, #40, #22, #00, #40, #80, #00, #80, #80, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #11, #76, #D4, #37, #B3, #A8, #11, #2A, #F3, #FA, #F9, #B3, #27
  db #93, #20, #86, #0C, #06, #48, #84, #C0, #C0, #4A, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #22, #80, #80, #C0, #80, #C0, #5A, #72, #D2, #D2, #93
  db #93, #D2, #4B, #69, #93, #D0, #22, #00, #11, #F8, #7B, #41, #49, #49, #49, #0D
  db #C2, #4A, #80, #26, #26, #C0, #C0, #85, #C0, #54, #37, #F4, #B5, #00, #00, #00
  db #00, #54, #00, #00, #00, #00, #00, #00, #00, #B1, #E6, #F4, #33, #B3, #A2, #76
  db #22, #86, #86, #49, #06, #48, #09, #0B, #84, #84, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #80, #C0, #C0, #E0, #C0, #C2, #91, #E1, #63, #63, #63
  db #63, #63, #C3, #69, #C3, #62, #BD, #A0, #00, #00, #54, #14, #49, #19, #19, #19
  db #19, #84, #85, #86, #4B, #49, #4B, #48, #91, #7B, #B3, #B9, #B9, #00, #54, #50
  db #7A, #54, #D4, #50, #11, #00, #27, #D4, #11, #F3, #76, #33, #11, #B9, #54, #00
  db #86, #49, #0C, #86, #0C, #86, #0C, #84, #0D, #07, #07, #02, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C0, #91, #C0, #C0, #4A, #84, #85, #43, #63, #63, #93
  db #C3, #C3, #63, #D0, #5A, #4A, #40, #80, #B3, #00, #A8, #00, #C0, #23, #0B, #4A
  db #4A, #22, #40, #C0, #87, #0D, #87, #13, #91, #B5, #B5, #A0, #A8, #00, #50, #54
  db #1B, #A8, #00, #C1, #69, #69, #87, #00, #00, #22, #54, #80, #A8, #54, #11, #14
  db #49, #49, #0C, #86, #2C, #2C, #3C, #9E, #3C, #3C, #3C, #82, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C0, #4A, #85, #85, #84, #C1, #0C, #86, #4B, #C3, #C3
  db #C3, #61, #C3, #27, #C2, #62, #40, #40, #C0, #00, #00, #05, #96, #19, #19, #0D
  db #86, #26, #27, #80, #C0, #4A, #19, #85, #A0, #00, #00, #00, #00, #00, #00, #00
  db #00, #80, #87, #96, #64, #26, #A5, #E0, #55, #76, #00, #A8, #54, #00, #3C, #1C
  db #1C, #1C, #3C, #3C, #61, #30, #61, #C9, #C6, #20, #D0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #80, #4A, #85, #C1, #84, #43, #0C, #49, #49, #49, #19
  db #71, #76, #22, #00, #63, #C3, #C2, #80, #00, #00, #00, #00, #62, #85, #80, #00
  db #40, #00, #00, #91, #0D, #87, #62, #95, #51, #A0, #22, #00, #A8, #00, #00, #05
  db #80, #E1, #C3, #30, #69, #93, #92, #B9, #B9, #A8, #00, #A8, #00, #11, #3C, #3C
  db #34, #38, #96, #30, #C6, #D2, #80, #E1, #40, #D0, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #62, #0B, #62, #49, #09, #86, #86, #49, #49, #5D, #71
  db #76, #00, #11, #F9, #37, #00, #80, #40, #14, #70, #00, #00, #00, #85, #26, #26
  db #C0, #00, #85, #48, #80, #80, #C0, #80, #00, #00, #00, #00, #A8, #00, #00, #C0
  db #05, #A5, #30, #F7, #B3, #A2, #00, #54, #00, #33, #33, #74, #1E, #3C, #34, #34
  db #34, #30, #65, #C3, #62, #70, #E0, #E0, #E0, #E0, #E0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #C2, #86, #83, #93, #69, #49, #49, #0C, #FF, #72, #7A
  db #2A, #B9, #B9, #00, #00, #00, #11, #38, #30, #30, #22, #00, #00, #00, #05, #80
  db #00, #00, #00, #00, #00, #00, #00, #11, #A8, #00, #54, #00, #00, #54, #38, #25
  db #91, #39, #F2, #7E, #D4, #00, #00, #00, #33, #76, #11, #4B, #3C, #34, #34, #69
  db #34, #CB, #E1, #E0, #72, #C0, #22, #D0, #C0, #E0, #50, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #4C, #32, #FA, #72, #A2, #51, #F6, #33, #B7, #22, #A8
  db #22, #A8, #00, #00, #54, #1A, #38, #30, #30, #30, #B2, #63, #54, #00, #22, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #11, #B1, #30, #34
  db #91, #58, #2A, #00, #00, #00, #30, #B3, #33, #B9, #14, #3C, #30, #34, #69, #61
  db #C6, #C9, #E0, #E0, #E0, #D0, #C0, #C0, #E0, #A0, #80, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #74, #72, #55, #B3, #00, #00, #00, #00, #00, #00, #22
  db #00, #00, #36, #30, #38, #30, #30, #30, #BB, #00, #10, #31, #31, #20, #B1, #B1
  db #11, #AD, #72, #11, #B5, #00, #00, #54, #5E, #95, #95, #B5, #50, #00, #BA, #34
  db #80, #E0, #80, #00, #00, #00, #00, #00, #00, #14, #34, #30, #34, #C2, #24, #33
  db #80, #80, #22, #00, #00, #00, #E0, #A0, #62, #40, #E8, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #00, #50, #00, #76, #76, #73, #B3, #54, #00, #00, #00
  db #14, #34, #34, #30, #30, #75, #75, #B3, #00, #22, #76, #00, #11, #20, #31, #00
  db #22, #00, #00, #00, #00, #22, #A8, #11, #B9, #A8, #80, #00, #54, #76, #73, #BA
  db #34, #40, #40, #40, #00, #00, #00, #00, #38, #34, #3C, #3C, #30, #92, #68, #C0
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #6A, #B3, #00, #00, #54, #00, #A0, #00, #00, #3C, #3C
  db #3C, #30, #30, #34, #39, #00, #00, #11, #B5, #F6, #00, #00, #C1, #05, #C2, #C1
  db #80, #11, #91, #A0, #A8, #80, #4A, #85, #48, #00, #54, #22, #00, #00, #00, #00
  db #40, #85, #91, #4B, #3C, #30, #30, #30, #34, #34, #3C, #61, #92, #30, #31, #00
  db #00, #00, #40, #00, #00, #00, #11, #72, #72, #11, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #86, #EA, #B9, #63, #19, #00, #14, #3C, #3C, #3C, #34
  db #30, #BA, #AE, #68, #4A, #76, #76, #00, #00, #50, #00, #19, #05, #85, #91, #84
  db #26, #96, #96, #4B, #86, #26, #C2, #87, #87, #86, #26, #69, #C9, #3C, #1C, #3C
  db #87, #00, #00, #00, #11, #26, #96, #38, #30, #34, #38, #D0, #C3, #30, #30, #38
  db #B4, #33, #62, #A0, #D4, #90, #69, #63, #93, #93, #80, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #F4, #24, #C3, #11, #63, #69, #3C, #3C, #3C, #3C, #30
  db #1C, #A2, #00, #50, #0F, #82, #00, #00, #91, #0D, #C2, #1B, #80, #62, #91, #49
  db #C9, #49, #86, #62, #C1, #4A, #26, #C0, #4A, #4B, #19, #85, #A4, #0E, #26, #C3
  db #C9, #3C, #69, #82, #00, #00, #B1, #51, #61, #96, #61, #40, #D0, #62, #93, #93
  db #93, #91, #B1, #F0, #10, #93, #C3, #63, #93, #93, #C3, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #44, #A8, #00, #F8, #00, #00, #00, #00, #50, #00, #00
  db #00, #40, #00, #80, #40, #C0, #C0, #40, #C0, #4A, #A7, #B0, #C0, #D1, #5B, #48
  db #48, #86, #49, #49, #49, #0C, #49, #0C, #49, #0C, #86, #49, #49, #49, #48, #40
  db #0C, #0C, #E2, #A7, #D1, #C0, #E3, #A6, #84, #C0, #C0, #E0, #40, #00, #00, #00
  db #80, #80, #40, #40, #40, #40, #00, #00, #40, #00, #80, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #11, #50, #00, #F0, #00, #00, #00, #40, #00, #00, #50
  db #22, #00, #00, #80, #C0, #C0, #C0, #C0, #C0, #48, #84, #A9, #D4, #C0, #59, #5B
  db #4B, #34, #3C, #38, #3C, #30, #30, #34, #6D, #30, #0C, #86, #86, #08, #00, #04
  db #86, #0C, #86, #84, #8C, #A6, #C0, #0C, #A6, #84, #A7, #A7, #80, #00, #40, #80
  db #40, #50, #40, #40, #40, #E8, #00, #80, #00, #91, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #E8, #A8, #00, #50, #72, #00, #00, #00, #A0, #F8, #00
  db #00, #80, #80, #80, #C0, #80, #C0, #C0, #C0, #C0, #C0, #02, #00, #00, #C1, #18
  db #CB, #9E, #9E, #9E, #6D, #3C, #6D, #6D, #2C, #9B, #18, #0C, #00, #00, #00, #49
  db #0C, #86, #0C, #8C, #86, #49, #59, #0C, #0C, #0C, #C0, #C0, #80, #00, #80, #80
  db #C0, #40, #40, #40, #00, #C0, #20, #80, #00, #40, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #50, #50, #00, #40, #E8, #50, #40, #F4, #22, #80
  db #80, #80, #C0, #91, #30, #3C, #33, #36, #38, #3C, #3C, #28, #00, #00, #00, #05
  db #0C, #8E, #2C, #CB, #8E, #2C, #4D, #0D, #0D, #A7, #A2, #00, #00, #00, #41, #8E
  db #C7, #49, #8E, #86, #49, #0C, #86, #0C, #86, #0C, #1C, #0C, #C2, #85, #80, #C0
  db #00, #90, #40, #40, #00, #B0, #22, #80, #00, #40, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #A0, #A0, #A0, #A0, #B1, #40, #00
  db #80, #91, #30, #73, #73, #73, #33, #B9, #72, #52, #54, #00, #00, #00, #00, #00
  db #00, #04, #0C, #0E, #0D, #0D, #0D, #4E, #4A, #80, #00, #00, #00, #00, #3C, #9E
  db #3C, #9E, #9E, #1C, #4D, #C7, #49, #0C, #C7, #4D, #62, #C0, #C0, #85, #C0, #C0
  db #C0, #63, #D4, #80, #80, #31, #D0, #40, #40, #40, #00, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #50, #50, #50, #D4, #D4, #D0, #D4, #80
  db #91, #7C, #73, #D9, #64, #E6, #B2, #99, #B3, #A3, #A0, #9C, #3C, #00, #00, #00
  db #00, #00, #00, #0E, #C0, #4A, #4A, #80, #00, #00, #00, #00, #00, #2D, #3C, #38
  db #3C, #3C, #3C, #3C, #3C, #9E, #CB, #9E, #49, #0D, #48, #48, #48, #90, #C8, #C0
  db #91, #31, #80, #80, #90, #33, #00, #80, #80, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #A0, #00, #A0, #A0, #A0, #E0, #F0, #B1, #F0
  db #91, #00, #B9, #B9, #50, #7A, #B3, #B3, #37, #50, #6B, #0C, #C7, #48, #22, #54
  db #00, #11, #30, #00, #40, #05, #00, #40, #20, #00, #00, #14, #8F, #E6, #F3, #3C
  db #3C, #3C, #38, #3C, #3C, #3C, #3C, #9E, #2C, #CB, #0C, #0C, #84, #32, #62, #85
  db #90, #62, #C0, #40, #31, #E0, #80, #C0, #40, #40, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #80, #A0, #50, #50, #50, #D0, #50, #72, #B1, #B1
  db #A5, #00, #00, #00, #00, #00, #50, #2A, #00, #00, #19, #48, #00, #00, #11, #6C
  db #00, #00, #00, #72, #6A, #0D, #00, #00, #00, #80, #00, #2C, #11, #F4, #3C, #3C
  db #30, #30, #CF, #34, #38, #30, #3C, #34, #34, #2C, #86, #0B, #0C, #31, #84, #84
  db #B2, #62, #C0, #90, #62, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #50, #50, #50, #50, #50, #D0, #E0, #F0, #72, #72
  db #33, #00, #00, #00, #00, #00, #54, #54, #73, #E2, #4A, #A8, #00, #05, #2D, #86
  db #2A, #00, #93, #69, #22, #00, #54, #00, #00, #00, #41, #00, #11, #04, #4D, #6D
  db #82, #73, #F1, #7A, #B9, #C7, #9E, #30, #2C, #C7, #86, #09, #0C, #99, #09, #4B
  db #99, #07, #13, #31, #C0, #40, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #50, #D0, #D4, #00, #D0, #50, #D0, #72, #72, #72, #72
  db #72, #82, #54, #50, #54, #00, #00, #33, #F6, #A0, #B9, #B9, #3B, #2D, #80, #85
  db #85, #82, #40, #62, #E0, #00, #00, #00, #40, #80, #80, #00, #00, #0B, #5A, #11
  db #B9, #F9, #F3, #E6, #E6, #B3, #A8, #96, #9E, #34, #0C, #86, #4C, #26, #09, #32
  db #26, #07, #71, #23, #C0, #85, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #F0, #91, #A0, #C0, #50, #40, #B1, #B1, #B1, #B1, #B1
  db #E1, #B1, #22, #22, #A8, #A0, #A8, #B9, #7B, #73, #B3, #B3, #91, #49, #4B, #49
  db #4A, #40, #62, #40, #00, #00, #00, #91, #80, #40, #00, #7B, #AC, #80, #00, #00
  db #11, #F8, #00, #73, #D9, #B3, #B3, #A8, #41, #3C, #79, #E6, #E6, #33, #4B, #33
  db #49, #59, #26, #A4, #C0, #C0, #4A, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #B1, #91, #40, #40, #40, #40, #50, #72, #72, #D2, #D2
  db #93, #93, #A5, #A5, #A0, #D4, #00, #50, #B9, #76, #33, #B3, #3C, #49, #4B, #4B
  db #4A, #4A, #80, #C2, #40, #40, #40, #00, #40, #54, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #54, #7A, #7A, #2A, #54, #A8, #E6, #B3, #11, #B3, #AC
  db #4C, #33, #49, #09, #48, #48, #48, #85, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #40, #40, #40, #C0, #C0, #C0, #91, #E1, #E1, #E1, #23
  db #63, #63, #E1, #6C, #87, #B1, #22, #00, #54, #95, #B1, #AC, #86, #86, #86, #26
  db #4B, #85, #00, #87, #48, #4A, #C0, #C0, #4A, #11, #72, #7A, #7A, #A8, #00, #00
  db #A8, #A8, #00, #00, #00, #00, #00, #00, #00, #51, #F3, #B7, #11, #F6, #28, #E8
  db #A2, #86, #49, #0C, #09, #0C, #07, #07, #42, #4A, #48, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #50, #85, #C0, #85, #85, #C0, #5A, #D2, #D2, #93, #93
  db #93, #C3, #93, #96, #93, #82, #D4, #22, #00, #00, #00, #41, #49, #49, #0E, #26
  db #26, #4A, #1B, #49, #49, #0E, #87, #87, #91, #B3, #B3, #76, #76, #22, #00, #A8
  db #A0, #A0, #E8, #A8, #AD, #40, #93, #C0, #11, #F3, #A2, #B9, #51, #00, #00, #00
  db #2C, #86, #86, #49, #49, #0C, #86, #09, #0E, #09, #0B, #0A, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #50, #C0, #40, #C0, #85, #42, #48, #D2, #93, #C3, #63
  db #C3, #C3, #C3, #62, #62, #D0, #40, #82, #7B, #00, #00, #00, #40, #85, #85, #84
  db #85, #C0, #00, #4A, #85, #A4, #0B, #62, #5E, #76, #E8, #A8, #A8, #00, #00, #22
  db #A8, #00, #40, #63, #69, #93, #C2, #00, #51, #22, #00, #A8, #A0, #22, #11, #14
  db #49, #0C, #86, #49, #1C, #1C, #3C, #3C, #3C, #3C, #38, #28, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #A0, #07, #E0, #42, #0B, #0D, #06, #0C, #84, #63, #C3
  db #92, #61, #39, #D2, #4A, #82, #C0, #00, #C0, #80, #00, #11, #86, #26, #26, #26
  db #96, #19, #19, #80, #C0, #85, #85, #C0, #22, #00, #00, #00, #00, #00, #00, #00
  db #40, #11, #63, #92, #96, #93, #C2, #80, #10, #76, #00, #0A, #00, #54, #CB, #2C
  db #2C, #6D, #3C, #38, #18, #30, #C6, #C3, #C3, #22, #E0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C0, #A5, #C0, #C2, #09, #0E, #86, #86, #86, #C7, #18
  db #BB, #F6, #00, #00, #41, #C3, #5A, #80, #00, #80, #00, #00, #C0, #80, #40, #40
  db #00, #00, #00, #C0, #26, #4B, #85, #91, #B9, #F6, #54, #00, #A0, #00, #00, #C0
  db #00, #63, #C3, #34, #93, #C3, #FF, #76, #50, #22, #00, #00, #00, #63, #3C, #3C
  db #38, #30, #96, #61, #C3, #62, #D0, #91, #D0, #D0, #D0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #13, #13, #43, #0B, #86, #49, #49, #49, #49, #5D, #BB
  db #FC, #00, #11, #33, #F8, #15, #80, #00, #90, #64, #A8, #00, #00, #11, #07, #19
  db #C0, #00, #85, #A5, #C0, #40, #40, #A8, #00, #00, #00, #54, #00, #00, #00, #80
  db #50, #4B, #71, #BB, #B3, #A8, #00, #A8, #00, #31, #33, #AD, #BC, #3C, #3C, #34
  db #61, #30, #6D, #C3, #A0, #D2, #52, #D0, #D0, #C0, #D0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #C1, #43, #19, #92, #75, #86, #86, #69, #31, #F6, #76
  db #A0, #B5, #A0, #00, #00, #00, #41, #38, #30, #30, #22, #11, #00, #00, #40, #4A
  db #00, #00, #00, #40, #80, #00, #00, #54, #80, #00, #00, #00, #00, #11, #38, #60
  db #6B, #C3, #7A, #F8, #00, #00, #00, #00, #00, #00, #00, #36, #3C, #38, #30, #3C
  db #31, #93, #C9, #B1, #C8, #E0, #60, #40, #E0, #80, #E0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #8C, #BA, #00, #76, #B3, #11, #22, #73, #B1, #A8, #A0
  db #E8, #00, #00, #00, #11, #32, #30, #30, #30, #B2, #30, #B3, #22, #A8, #50, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #B9, #33, #30, #34
  db #A5, #62, #00, #00, #00, #11, #75, #B1, #72, #72, #14, #3C, #38, #38, #92, #61
  db #99, #C9, #E1, #F0, #D0, #C0, #D0, #40, #22, #E0, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #EA, #2A, #51, #73, #00, #00, #00, #11, #76, #54, #22
  db #00, #11, #36, #30, #30, #30, #30, #30, #BB, #00, #51, #31, #71, #20, #11, #72
  db #10, #B1, #00, #00, #62, #00, #00, #11, #E8, #E8, #7A, #50, #15, #00, #30, #30
  db #40, #40, #A0, #00, #00, #00, #00, #00, #00, #14, #34, #38, #34, #C2, #36, #61
  db #C0, #E0, #00, #00, #00, #00, #00, #80, #82, #80, #D0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #0A, #00, #00, #B1, #A8, #B3, #B3, #00, #00, #00, #00
  db #38, #38, #38, #30, #30, #75, #75, #73, #00, #A8, #76, #00, #00, #20, #71, #00
  db #22, #00, #00, #00, #50, #22, #A0, #F8, #5E, #22, #00, #00, #B9, #B1, #B9, #B2
  db #30, #62, #00, #A0, #00, #00, #00, #05, #92, #34, #3C, #38, #61, #92, #4A, #80
  db #80, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #11, #63, #80, #00, #00, #A0, #00, #00, #41, #3C, #3C
  db #3C, #30, #30, #34, #28, #00, #00, #B9, #7A, #11, #00, #00, #04, #41, #19, #05
  db #82, #00, #00, #00, #00, #91, #48, #C1, #C0, #00, #11, #00, #00, #00, #00, #00
  db #4A, #4A, #62, #96, #3C, #38, #30, #30, #30, #3C, #3C, #61, #30, #30, #30, #00
  db #00, #00, #00, #00, #00, #00, #10, #B1, #B1, #91, #E0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #18, #D4, #33, #63, #39, #00, #96, #96, #3C, #3C, #38
  db #30, #BA, #BE, #0E, #A5, #B1, #A8, #00, #00, #00, #00, #26, #40, #41, #4A, #87
  db #19, #0D, #0D, #86, #4B, #C1, #4B, #4A, #48, #87, #49, #1C, #C6, #C6, #96, #96
  db #69, #0A, #00, #00, #54, #73, #36, #34, #30, #38, #92, #D0, #91, #92, #30, #69
  db #92, #C3, #62, #D4, #4A, #10, #93, #C3, #63, #C3, #22, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #32, #86, #D6, #B1, #E6, #96, #3C, #3C, #3C, #38, #34
  db #2C, #A2, #00, #01, #07, #80, #00, #02, #49, #4B, #0D, #C0, #80, #C0, #0F, #86
  db #C6, #86, #87, #48, #26, #C0, #19, #C0, #85, #A4, #26, #87, #85, #A5, #19, #19
  db #1C, #96, #3C, #0D, #00, #00, #51, #40, #BA, #92, #78, #80, #C0, #C1, #63, #63
  db #63, #B1, #E0, #62, #36, #C3, #63, #93, #C3, #63, #63, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #E8, #A8, #54, #D4, #00, #00, #00, #00, #00, #E8, #00
  db #00, #00, #80, #40, #40, #40, #80, #C0, #C0, #E2, #5B, #70, #C0, #85, #E2, #A6
  db #84, #48, #86, #C7, #96, #96, #86, #86, #86, #49, #0C, #86, #86, #86, #82, #40
  db #0C, #0C, #59, #5B, #C0, #D1, #0E, #59, #59, #C0, #C0, #C4, #80, #C0, #00, #40
  db #40, #40, #00, #80, #80, #80, #40, #40, #00, #40, #00, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #54, #50, #F4, #00, #76, #00, #00, #00, #80, #80, #00, #50
  db #A8, #00, #00, #80, #80, #C0, #C0, #C0, #84, #C0, #48, #E8, #02, #5B, #0E, #D1
  db #18, #34, #3C, #3C, #34, #30, #34, #3C, #6D, #38, #49, #49, #0C, #0A, #00, #41
  db #49, #0C, #0C, #59, #0C, #D3, #48, #0C, #59, #48, #59, #4A, #40, #40, #00, #80
  db #80, #80, #80, #80, #80, #80, #80, #40, #40, #A8, #40, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #F4, #80, #00, #00, #B9, #00, #00, #00, #50, #50, #00
  db #80, #40, #40, #40, #C0, #40, #80, #C0, #62, #62, #4A, #0A, #00, #00, #04, #92
  db #CF, #6D, #6D, #6D, #6D, #3C, #9E, #CB, #8E, #0C, #18, #19, #00, #00, #00, #86
  db #49, #0C, #0C, #49, #0C, #86, #59, #49, #0C, #0C, #C0, #C0, #80, #40, #80, #80
  db #40, #00, #C0, #00, #40, #40, #20, #40, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #D4, #D4, #A0, #F0, #A0, #80
  db #C0, #40, #40, #32, #34, #7C, #F4, #63, #3C, #3C, #38, #28, #00, #00, #00, #00
  db #4D, #4D, #1C, #CF, #C7, #0C, #0C, #0C, #5B, #0E, #0A, #00, #00, #00, #14, #1C
  db #49, #8E, #C7, #0C, #86, #49, #0C, #86, #0C, #0C, #0C, #2C, #0C, #C0, #C0, #C0
  db #40, #90, #80, #80, #80, #1A, #88, #40, #40, #00, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #50, #50, #50, #50, #50, #80, #40
  db #40, #10, #31, #B3, #F3, #73, #73, #73, #73, #76, #A8, #A8, #00, #00, #00, #00
  db #00, #05, #0D, #0D, #0C, #0E, #4E, #4A, #85, #00, #00, #00, #00, #00, #3C, #6D
  db #6D, #6D, #2C, #2C, #2C, #CB, #4D, #86, #1C, #0C, #C0, #C0, #C0, #C0, #62, #C0
  db #85, #D3, #80, #40, #40, #31, #C0, #80, #80, #80, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #A0, #00, #A0, #E0, #E8, #E0, #E8, #E8
  db #91, #7C, #33, #E6, #D9, #71, #30, #71, #73, #73, #B9, #B6, #3C, #00, #00, #00
  db #00, #00, #00, #04, #C0, #4A, #C0, #0A, #00, #54, #00, #00, #11, #9B, #C3, #3C
  db #34, #6D, #3C, #3C, #9E, #6D, #C7, #2C, #86, #09, #0E, #84, #85, #90, #89, #40
  db #91, #31, #40, #40, #90, #22, #C0, #40, #40, #40, #40, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #A0, #A0, #A0, #E0, #F8, #D0, #72, #B1
  db #B1, #00, #F8, #7A, #BD, #B5, #76, #76, #A2, #BD, #A4, #4B, #0E, #22, #76, #00
  db #11, #54, #33, #22, #A8, #40, #00, #11, #A8, #00, #00, #04, #08, #D9, #B3, #3C
  db #30, #3C, #3C, #3C, #3C, #3C, #3C, #3C, #3C, #2C, #86, #0C, #C1, #92, #62, #48
  db #90, #72, #C0, #40, #71, #C0, #C0, #40, #40, #40, #C0, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #E8, #50, #00, #A0, #A0, #A0, #F0, #B1, #F0, #72
  db #22, #00, #00, #00, #54, #00, #00, #22, #00, #00, #87, #85, #00, #00, #14, #39
  db #00, #20, #11, #B5, #B5, #48, #00, #00, #11, #00, #40, #2D, #B9, #7A, #3C, #38
  db #30, #65, #36, #65, #9A, #30, #34, #38, #69, #86, #49, #0D, #0C, #31, #84, #85
  db #71, #42, #C0, #66, #62, #C0, #C0, #C0, #80, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #E8, #E8, #A0, #A0, #A0, #A0, #E0, #F0, #B1, #B1, #B1
  db #E1, #00, #00, #00, #00, #00, #11, #00, #B9, #B9, #5E, #80, #00, #ED, #69, #0D
  db #A0, #00, #63, #93, #31, #00, #62, #2A, #00, #00, #94, #00, #00, #04, #0E, #9E
  db #28, #B7, #73, #37, #F4, #63, #9E, #30, #3C, #1C, #0C, #86, #09, #99, #0D, #13
  db #D3, #0B, #1A, #31, #C0, #C0, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #A0, #E0, #A0, #00, #50, #A0, #72, #B1, #B1, #B1, #B1
  db #E1, #22, #E8, #A8, #A0, #A8, #A8, #F1, #72, #7A, #54, #76, #B6, #CB, #4A, #40
  db #4A, #87, #54, #5A, #91, #4A, #00, #00, #40, #80, #80, #00, #00, #C2, #4A, #15
  db #B5, #F1, #73, #E6, #E6, #B3, #A8, #63, #9E, #34, #CB, #0C, #49, #A6, #86, #D3
  db #26, #09, #99, #C2, #81, #0B, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #D0, #A5, #A0, #80, #C0, #40, #D0, #72, #72, #72, #D2
  db #D2, #93, #E0, #A8, #F4, #50, #00, #B9, #F1, #F3, #73, #B3, #26, #87, #86, #26
  db #62, #00, #4A, #40, #4A, #80, #40, #4A, #80, #40, #00, #76, #62, #0A, #54, #00
  db #54, #76, #00, #B9, #E6, #F3, #37, #A0, #05, #36, #73, #D9, #66, #33, #A6, #B3
  db #0C, #C6, #C1, #48, #84, #84, #C0, #C0, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #62, #62, #00, #C0, #80, #80, #91, #B1, #E1, #B1, #E1
  db #63, #E1, #B1, #58, #5A, #40, #00, #54, #5E, #33, #B9, #3E, #3C, #86, #87, #19
  db #19, #85, #40, #85, #C0, #80, #00, #80, #80, #80, #00, #00, #54, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #15, #B5, #A8, #54, #00, #F3, #31, #A8, #B3, #11
  db #59, #11, #0C, #86, #06, #84, #81, #0B, #C0, #C0, #C0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #00, #80, #80, #80, #C0, #C0, #5A, #72, #72, #93, #13
  db #93, #93, #63, #69, #C3, #5E, #22, #00, #00, #F8, #7A, #11, #49, #49, #49, #49
  db #0D, #4A, #80, #19, #91, #85, #C0, #C0, #C0, #3B, #B7, #B5, #F4, #80, #00, #00
  db #54, #00, #A8, #00, #00, #00, #11, #40, #00, #11, #F3, #33, #11, #7A, #22, #11
  db #50, #49, #0C, #86, #06, #07, #09, #48, #84, #81, #84, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #91, #C0, #40, #C0, #C0, #C2, #C1, #E1, #63, #63, #63
  db #C3, #C3, #23, #6C, #C3, #4A, #80, #F6, #00, #00, #00, #04, #26, #87, #87, #85
  db #07, #85, #84, #86, #26, #87, #49, #4B, #91, #73, #76, #72, #B9, #00, #54, #D4
  db #50, #50, #54, #80, #22, #41, #93, #5A, #00, #F3, #22, #7A, #11, #A8, #A0, #00
  db #2C, #49, #49, #0C, #86, #49, #0C, #06, #0C, #0D, #87, #02, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #C0, #C0, #85, #85, #C0, #0B, #0B, #4B, #63, #63, #C3
  db #C3, #C3, #9C, #91, #C0, #80, #40, #08, #B9, #A8, #50, #00, #00, #C0, #4A, #4A
  db #4A, #C0, #80, #C0, #C0, #4A, #87, #0D, #B5, #A0, #A8, #A8, #54, #00, #00, #00
  db #00, #00, #40, #63, #96, #C3, #22, #80, #55, #11, #00, #00, #22, #A2, #54, #4B
  db #CB, #49, #49, #4D, #C7, #3C, #3C, #38, #69, #6C, #92, #0A, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #4A, #C0, #58, #0B, #84, #0B, #0C, #86, #48, #0D, #C3
  db #32, #33, #93, #4B, #C0, #C0, #C0, #50, #40, #80, #00, #40, #69, #19, #19, #49
  db #19, #49, #0E, #62, #40, #C0, #4A, #4A, #00, #00, #00, #00, #00, #00, #00, #00
  db #40, #11, #C3, #38, #69, #69, #62, #22, #77, #A0, #00, #00, #00, #11, #96, #CB
  db #CB, #9E, #3C, #61, #38, #61, #C9, #C6, #C6, #80, #80, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #62, #4E, #4E, #C0, #07, #43, #0C, #49, #0C, #49, #18
  db #B3, #B9, #00, #00, #11, #4B, #85, #00, #00, #C0, #00, #00, #40, #00, #80, #80
  db #00, #00, #00, #80, #19, #0D, #C2, #91, #73, #76, #A0, #11, #A8, #00, #00, #0A
  db #00, #63, #96, #C3, #63, #77, #31, #E8, #15, #00, #00, #00, #00, #BC, #3C, #3C
  db #30, #61, #69, #3C, #C3, #E0, #40, #B1, #40, #E0, #A0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #40, #23, #23, #C2, #86, #49, #06, #86, #86, #86, #D7, #70
  db #2A, #00, #B9, #B9, #76, #00, #00, #40, #32, #30, #50, #00, #00, #40, #5A, #4A
  db #4A, #00, #C0, #4A, #4A, #00, #80, #A0, #00, #00, #00, #11, #00, #00, #40, #80
  db #C0, #B0, #31, #FB, #76, #00, #00, #00, #50, #31, #33, #F4, #1E, #3C, #30, #30
  db #69, #30, #C3, #C3, #B1, #A1, #E0, #E0, #E0, #D0, #C0, #A8, #00, #00, #00, #00
  db #00, #00, #00, #00, #01, #86, #A4, #92, #BB, #B2, #25, #86, #D7, #31, #76, #72
  db #54, #72, #54, #00, #00, #00, #91, #38, #30, #30, #20, #54, #00, #00, #40, #85
  db #C0, #00, #00, #40, #C0, #00, #00, #11, #00, #00, #54, #00, #00, #50, #38, #25
  db #41, #63, #76, #22, #A0, #00, #00, #00, #00, #00, #11, #1E, #38, #38, #92, #38
  db #61, #D0, #D2, #90, #E0, #A5, #CA, #50, #C0, #22, #F0, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #93, #71, #22, #B1, #73, #00, #76, #33, #7B, #00, #00
  db #22, #00, #00, #00, #76, #30, #30, #30, #30, #10, #B2, #31, #00, #50, #00, #40
  db #00, #00, #40, #40, #00, #00, #00, #00, #00, #00, #00, #11, #11, #B1, #30, #34
  db #91, #C0, #00, #00, #00, #10, #31, #B9, #33, #B5, #94, #3C, #30, #92, #18, #C7
  db #C6, #E1, #90, #E0, #E0, #E0, #E0, #D0, #80, #80, #80, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #41, #20, #A0, #72, #B3, #11, #22, #00, #73, #B3, #40, #A8
  db #00, #11, #9A, #34, #30, #30, #30, #30, #33, #00, #00, #31, #30, #A2, #D4, #72
  db #3A, #22, #40, #00, #50, #A8, #B5, #91, #E8, #54, #22, #76, #00, #00, #B2, #34
  db #50, #91, #80, #54, #00, #00, #00, #00, #00, #32, #38, #38, #61, #D2, #C1, #82
  db #00, #40, #40, #00, #00, #00, #00, #11, #C0, #40, #E0, #A0, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #82, #54, #54, #50, #2A, #73, #B7, #00, #00, #00, #63
  db #3C, #34, #34, #30, #30, #BA, #FB, #11, #00, #B9, #F9, #00, #40, #00, #B6, #22
  db #22, #00, #50, #80, #11, #A0, #7A, #11, #B9, #00, #00, #54, #0A, #00, #B9, #73
  db #30, #22, #91, #40, #00, #00, #00, #36, #30, #38, #3C, #3C, #61, #92, #48, #C0
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #50, #32, #26, #22, #00, #54, #00, #00, #00, #94, #3C, #3C
  db #38, #38, #30, #3C, #08, #00, #54, #76, #22, #54, #A0, #00, #41, #4A, #86, #C0
  db #4A, #00, #00, #00, #40, #26, #62, #26, #80, #08, #22, #00, #00, #00, #00, #40
  db #80, #00, #40, #26, #96, #38, #30, #30, #34, #3C, #38, #93, #30, #30, #30, #22
  db #00, #00, #00, #00, #00, #50, #11, #B1, #B1, #F0, #5A, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #04, #93, #62, #B3, #C6, #93, #11, #96, #3C, #3C, #3C, #34
  db #30, #BA, #AA, #C2, #49, #7A, #A8, #00, #00, #A8, #4A, #91, #80, #85, #C1, #4A
  db #87, #86, #26, #86, #87, #C1, #4B, #4B, #4B, #0E, #26, #86, #69, #C9, #3C, #9C
  db #96, #2D, #A0, #00, #00, #73, #EB, #3C, #30, #34, #16, #E0, #E1, #32, #30, #38
  db #C3, #63, #91, #E8, #E0, #32, #63, #93, #C3, #63, #93, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #11, #BA, #49, #58, #3A, #1C, #69, #3C, #3C, #3C, #38, #34
  db #1C, #00, #00, #07, #02, #08, #00, #05, #86, #86, #62, #80, #4A, #50, #91, #49
  db #C9, #49, #19, #C0, #87, #91, #C2, #C0, #C0, #4B, #49, #C9, #4A, #5A, #0E, #26
  db #26, #96, #1C, #C3, #00, #00, #91, #00, #BA, #92, #60, #C0, #40, #E1, #63, #93
  db #93, #91, #B1, #F0, #36, #93, #C3, #63, #63, #93, #93, #80, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
  db #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: pixsaur
  SELECT id INTO tag_uuid FROM tags WHERE name = 'pixsaur';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
