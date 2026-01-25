-- Migration: Import z80code projects batch 15
-- Projects 29 to 30
-- Generated: 2026-01-25T21:43:30.184801

-- Project 29: cycle-pattern by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'cycle-pattern',
    'Imported from z80Code. Author: siko. Pattern+Animation from Still Scrolling',
    'public',
    false,
    false,
    '2020-02-05T23:29:10.945000'::timestamptz,
    '2021-06-18T22:38:07.073000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'LINEWIDTH EQU 96
PATTERN_H EQU floor(8*2048/(LINEWIDTH*2))
COL1 equ #5b
COL2 equ #54
CWIDTH equ 7



di
ld hl,#c9fb
ld (#38),hl

ld bc,#7f8c
out (c),c

ld bc,#BC01
out (c),c
ld a,LINEWIDTH>>1
inc b
out (c),a
dec b
inc c
out (c),c
ld a,46+(LINEWIDTH-80)/4
inc B
out (c),a

ld bc,#BC06
out (c),c
ld a,PATTERN_H>>2
inc b
out (c),a	



; Remplissage de l''ecran avec un motif
; Utilisation de la pile pour faire le motif symmetrique
macro fill_screen:
	ld hl,#c000
	ld a, PATTERN_H+1
fslp0:
	ex af,af''
	ld a,LINEWIDTH
fsstartp:
	ld de, #400 ; #900
	push hl
fslp1:
	push af
		push hl
		ld hl,tabmode0_2px
		ld a,d
		cp 14
		jP M, no0
		sub 14
		ld d,a
no0:
		; inversion palette
		ld c,a
		ld a,13
		sub c		
		ld c,a		
		ld b,0
		add hl,bc
		ld a,(hl)
		pop hl

		ex de,hl
fsincrement:	
		ld bc,#05f; #3f - #ff  pour avoir des bandes plus ou moins larges
		add hl,bc
		ex de,hl		
fsmoire:
		and #55
		ld (hl),a		
		inc hl

	pop af
	dec a
	jr nz, fslp1
	
	ld hl,(fsincrement+1)
	inc hL	; l''un des 2 inc hl peut etre remplacé par un inc l, selon la parité de 
	inc hl  ; la valeur en fsincrement
	ld (fsincrement+1),hl

	ld hl,(fsstartp+1)
	ld de,2*LINEWIDTH/2
	sbc hl,de
	ld (fsstartp+1),HL
	
	pop hl
	push hl ; On stocke l''adresse de la ligne
	call NXT_LINE

	ld a,(fsmoire+1)
	cpl 
	ld (fsmoire+1),a
	
	ex af,af''
	dec a
	jr nz, fslp0
	
	; Ensuite on depile 	
	ld a,PATTERN_H
	ld de,#c000+LINEWIDTH*(PATTERN_H>>3)
lpmirror:	
	pop hl
	push de	
	ld bc,LINEWIDTH
	ldir
	pop hl
	ex af,af''
	call nxt_line	
	ex af,af''
	ex de,hl
	dec a
	jr nz, lpmirror
	pop HL
mend	

	fill_screen


mainloop:

	ld b,#f5
vbl:
	in a,(c)
    rra
    jr nc,vbl
    
    ei
    halt
    halt
    halt
    halt
    halt
    halt
    di
    
    
  ld hl,(pcoltab)
  inc hl
  ld a,(hl)
  or a
  jr nz,.setpcol
  ld hl,coltab
.setpcol:
  ld (pcoltab),hl

  ld bc,#7f0f

lpcol:
	ld a,(hl)
    or a
    jr nz, .setcol
    ld hl,coltab
    ld a,(hl)
.setcol    
	out (c),c
	out (c),a
    inc hl
    dec c
    jr nz, lpcol


  jr mainloop
    
    

;genere une fonction nextline en fonction de la largeur de l.ecran
;CS: modifie AF, duree variable
MACRO NEXTLINE LW
        LD      a,h  ; h+=#800
        ADD     a,8 
        LD      h,a 
        AND     #38 
        RET     nz 	; <- RET si on n edeborde pas
        LD      a,h 
        SUB     #40 
        LD      h,a 
        LD      a,l 
        ADD     a,{LW}
        LD      l,a 
        RET     nc  ; <- RET
        INC     h 
        RES     3,H 
		ret			; <- RET
		
MEND

NXT_LINE : NEXTLINE LINEWIDTH 

MACRO DBPIXM0 COL2,COL1
	db ({COL1}&8)/8 | (({COL1}&4)*4) | (({COL1}&2)*2) | (({COL1}&1)*64) | (({COL2}&8)/4) | (({COL2}&4)*8) | (({COL2}&2)*4) | (({COL2}&1)*128)
MEND

ALIGN 256
tabmode0:
v=0
tabmode0_2px:
  repeat 3
    v=15
    repeat 14
        DBPIXM0 v,v
        v=v-1
    rend	
  rend



pcoltab dw coltab

coltab:
	ds CWIDTH,COL1,14-CWIDTH,COL2
    db 0
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: color-cycling
  SELECT id INTO tag_uuid FROM tags WHERE name = 'color-cycling';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 30: mic-second comming (zx) by mic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'mic-second comming (zx)',
    'Imported from z80Code. Author: mic. testzic',
    'public',
    false,
    false,
    '2022-03-25T20:14:33.336000'::timestamptz,
    '2022-03-25T20:14:33.346000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Dès fois que... Peut s''avérer être utile pour une utilisation dans rasmlive...
; https://www.cpcwiki.eu/index.php/AYC
; https://cpcrulez.fr/coding_src-music-kitay.htm
; https://cpcrulez.fr/emulateurs_UTIL-MUSIC-YMCruncher.htm

; play-ay.sce overlanders 24/5/2000
; v0.5
; pour placer manuellement ses tampons de decompression, definir oftab0 etc,
; mettre les bons jump en v0 etc et enlever call attribu

 buildsna
 bankset 0
 run start

wantloop equ 1 ; 0 = la musique ne boucle pas (routine + rapide) label fin / 1 = boucle
decrubuf equ #c000 ; doit valoir x000 ou x800 (cf attribu) / Là, ça décrunch dans l''écran...
duree equ ymlz ; indiquée dans le header

 org #38
 jp #0000

start
 org #40

 di
 ld hl,#c9fb
 ld (#38),hl
 ei

 call init_music

main
 ld b,#f5
sync
 in a,(c)
 rra
 jr nc,sync
 halt
 halt
 halt

 ld bc,#7f10
 ld a,#6c
 out (c),c
 out (c),a

 call play_music
 
 ld bc,#7f10
 ld a,#54
 out (c),c
 out (c),a
 
 jp main

fin     ; si wantloop=0 (une fois la musique terminée)
 jr $   

;---------------------------------------------------------------------

init_music
 call readhead
 call attribu
 call creeplay
 call pokecode
 call razvar
 call raz_psg

; il faut preparer quelques donnees d''avance

 ld a,(nbr_reg)
amorce
 push af
 call getreg
 pop af
 dec a
 jr nz,amorce

 ret

play_music
 call getreg
 call playreg
 if wantloop
 else
mesure 
 ld hl,0
 dec hl
 ld (mesure+1),hl
 ld a,h
 or l
 jr z,fin
 endif
 ret

raz_psg
; la routine de play ne met pas a jour les registres s''ils ne sont pas modifies.
; or, ils sont consideres a 0 lors de la 1er interation.
; on doit donc reelement les mettre a 0. (nb 7 a 0 : canaux et bruit ouverts)
 ld b,14
 ld c,13 ; volumes raz avant reg 7
 xor a
rp_lp
 push bc
 call psg
 pop bc
 dec c
 djnz rp_lp
 ret

psg
 ld b,#f4
 out (c),c
 ld bc,#f6c0
 out (c),c
 out (c),0
 ld b,#f4
 out (c),a
 ld bc,#f680
 out (c),c
 out (c),0
 ret

modele
 ld a,(hl)
 cp 0
 jr z,mo_same
 ld (0),a ; 0 remplace dans creeplay
mo_suite
 out (c),c ; registre
 exx
 out (c),0
 ld b,h
 out (c),a
 ld b,l
 out (c),e
 out (c),d
 exx
mo_same
 inc c
mo_end

mo2
 inc de
 ld a,d
 and #3
 ld d,a
 ld (playplag+1),de
 ret
mo2_end

playreg
 ld de,#c080
 ld hl,#f4f6
 ld b,l
 out (c),d
 exx
playplag
 ld de,0 ;fourni poids faible (sur 8 et 10 bits)
; playplag est remis a jour la fin
 ld l,e
 ld b,#f4
 ld c,0

; partie cree par creeplay
playcode
 ds (mo_end-modele+4)*14,0
 ds (mo2_end-mo2),0

getreg
 di
 ld (savetmp+1),sp
 ld a,(nbr_reg) ; necessaire pour v1 a v13
 dec a ; mais pas pour vmesure/v0

 if wantloop
decaleh
 ld ixh,0
 endif

 ld iy,get_ret
getwitch
 jp v0 ; quelle routine ?
get_ret
 ld hl,(getwitch+1)
 dec hl
 ld d,(hl) ; recupere adresse
 dec hl
 ld e,(hl)
 ld (getwitch+1),de
savetmp
 ld sp,0
 ei
 ret

 dw v1 ; adresse prochaine routine
vmesure
 if wantloop
; s''il reste moins que "nbr_reg" donnees a recuperer,
; on recupere ces quelques donnees, on reset (methode brute pour l''instant),
; puis on recupere qq donnees complementaire.
; sinon, on saute normallement a v0, et le test ne sera pas effectue
; de v1 a v13 ...
mesure
 ld hl,0
 ld c,l
 ld d,0
 ld a,(nbr_reg)
 ld e,a
 or a
 sbc hl,de
 ld (mesure+1),hl
 dec a
 jp nc,v0

; pour v1 etc..., on ne refera pas le test precedent

 ld b,d
 ld de,retient
 ld (getwitch+1),de
 ld de,(duree)
 add hl,de
 ld (mesure+1),hl
 ld a,c
 ld (complete+1),a
 ld (retient+1),a

; on doit determiner la position destination dans les buffers

 ld hl,(playplag+1)
 add hl,bc
 ld a,(nbr_reg)
 ld c,a
 add hl,bc
 ld a,h
 and #3
 ld (decaleh+2),a
 ld a,l
 ld (decalel+1),a

retient
 ld a,0
 dec a
 jp m,cas0 ; 0 data ? il faut reseter
 ld iy,get_ret_
getwitc_
 jp v0

cas0
 ld a,(nbr_reg)
 jr _reset

get_ret_
 ld a,(nbr_reg)
complete
 ld b,0
 sub b
;
_reset
 ld hl,(getwitc_+1)
 inc hl
 ld e,(hl) ; plage de variable
 inc hl
 ld d,(hl)
 inc de
 inc de
 inc de
 inc de
 ld hl,regscopy-regs+1
 add hl,de
 ex de,hl
decalel
 ld (hl),0
 inc hl
 ex de,hl
 ldi
 ldi
 ldi
 ldi
 ldi

 ld iy,get_ret2
 dec a
 jr getwitc_
get_ret2
 ld hl,(getwitc_+1)
 dec hl
 ld d,(hl) ; recupere adresse
 dec hl
 ld e,(hl)
 ld hl,-vmesure-1 ; pour redirection, il faut boucler sur
 add hl,de ; v0
 jr c,reglp_ok
 ld hl,vmesure
 ld (getwitch+1),de
 ld de,v0
reglp_ok
 ld (getwitc_+1),de
 ld sp,(savetmp+1)
 ei
 ret

 dw v1
 endif

v0
 ld sp,regs ; !!! placer le ld sp apres le label !!!
vrout:
 jp decomp4 ; attention ! l''ecart doit rester
 dw v2
v1
 ld sp,regs+10
vrout_
 jp decomp0 ; constant pour les modifs d''attribu
 dw v3
v2
 ld sp,regs+20
 jp decomp4
 dw v4
v3
 ld sp,regs+30
 jp decomp0
 dw v5
v4
 ld sp,regs+40
 jp decomp4
 dw v6
v5
 ld sp,regs+50
 jp decomp0
 dw v7
v6
 ld sp,regs+60
 jp decomp0
 dw v8
v7
 ld sp,regs+70
 jp decomp0
 dw v9
v8
 ld sp,regs+80
 jp decomp0
 dw v10
v9
 ld sp,regs+90
 jp decomp0
 dw v11
v10
 ld sp,regs+100
 jp decomp0
 dw v12
v11
 ld sp,regs+110
 jp decomp0
 dw v13
v12
 ld sp,regs+120
 jp decomp0
 dw vmesure ; !!! boucle en concordance avec nbr_reg
v13
 ld sp,regs+130
 jp decomp0
 dw v15
v14
 ld sp,regs+140
 jp decomp0
 dw v0
v15
 ld sp,regs+150
 jp decomp0

d0_chr

; place en premier pour etre atteint par jr

 ex af,af''
 ld a,(hl)
 inc hl
 exx
 ld (de),a
 inc e
 ex af,af''

; on decremente nbr de caracteres restants.

 dec a
 exx
 jp p,d0_next

 push hl
 push bc
 exx

 push bc ; b doit etre nul ici
 push hl ; bidon
 push de
 jp (iy)

decomp0
; entree : a = nbr de donnees a decompacter - 1
; iy = adr de retour
; on suppose que longueur est code en negatif (ie -2 -> 2 caracteres)
; on recupere adr destination dans tous les cas
; (remarque : d ne change pas, il y a peut etre moyen d''optimiser cela)

 pop de
 pop hl ; adresse source pour copie chaine

; on recupere b = nbr de caracteres a copier c est inutilise
 pop bc
 inc b
 dec b
 jr z,d0_flag

d0_mesur
; on regarde si longueur de chaine restante > nbr de donnees a fournir
 if wantloop
 exx
 ld d,a
 exx
 add a,b ; longueur codee en negatif
 jr nc,d0_al_
 else
 add a,b
 jr nc,d0_all
 endif

 ex af,af''
d0_lp1
 ld a,(hl)
 inc l
 ld (de),a
 inc e
 inc b
 jr nz,d0_lp1
 ex af,af''

d0_flag
; on recupere flags et pointeur donnees compressees
; (b inutilise)
 exx
 pop bc
 pop hl

; on extrait nouveau flag
d0_next
 sla c
 jr nz,d0_flgok
 ld c,(hl)
 inc hl
 sll c
d0_flgok
 jr nc,d0_chr

; test similaire au precedent
 ld b,(hl)
 inc hl
 ld d,a ; sauve pour d0_left
 add a,b
 jr nc,d0_left

; il restera (a+1) donnees a fournir apres copie de la chaine
 ex af,af''
 ld a,b
 exx
 ld b,a
 exx
 ld a,(hl)
 inc hl
 exx
 if wantloop
 add a,c
 endif
 ld l,a
d0_lp2
 ld a,(hl)
 inc l
 ld (de),a
 inc e
 inc b
 jr nz,d0_lp2
 ex af,af''
 exx
 jr d0_next

d0_left
; idem que d0_all mais sur moins de donnees.
 ex af,af'' ; pour l''instant on conserve a-b
 ld a,d ; nombre de valeur restantes a copier-1
 exx
 ld b,a
 inc b
 exx
 ld a,(hl)
 inc hl
 push hl
 push bc
 exx
 if wantloop
 add a,c
 endif
 ld l,a
d0_lp3
 ld a,(hl)
 inc l
 ld (de),a
 inc e
 djnz d0_lp3
 ex af,af''
 ld b,a
 inc b ; longueur restante pour prochaine fois
 push bc
 push hl
 push de
 jp (iy)

 if wantloop
d0_al_
; d0_all ne convient pas quand on veut changer dynamiquement le nombre
; de valeurs a recuperer (c''est le cas pour le bouclage).
 inc a
 ld b,a
 push bc
 exx
 ld a,d
 exx
 ld b,a
 inc b

d0_al_lp
 ld a,(hl)
 ld (de),a
 inc l
 inc e
 djnz d0_al_lp
 push hl
 push de
 jp (iy)

 else
d0_all
; la chaine a copier fournie toutes les donnees
 inc a
 ld b,a ; longueur restante pour prochaine fois
 push bc

d0_copy
 ld a,(hl)
 ld (de),a
 inc l
 inc e
 ds 80,0 ; place pour nbr_reg copies
 ds 5,0 ; place pour d0_model

d0_model
 ; sera copie a la suite des ldi
 push hl
 push de
 jp (iy)
d0_mode_
 endif

d4_chr
; place en premier pour etre atteint par jr
 ex af,af''
 ld a,(hl)
 inc hl
 exx
 ld (de),a
 inc de
 res 2,d
 ex af,af''

; on decremente nbr de caracteres restants.
 dec a
 exx
 jp p,d4_next
 push hl
 push bc
 exx
 push bc ; b doit etre nul ici
 push hl ; bidon
 push de
 jp (iy)

decomp4
; base sur decomp0
; entree : a = nbr de donnees a decompacter - 1
; iy = adr de retour
; on suppose que longueur est code en negatif (ie -2 -> 2 caracteres)
; on recupere adr destination dans tous les cas
; (remarque : d ne change pas, il y a peut etre moyen d''optimiser cela)
 pop de
 pop hl ; adresse source pour copie chaine
; on recupere b = nbr de caracteres a copier c est inutilise
 pop bc
 inc b
 dec b
 jr z,d4_flag

d4_mesur
; on regarde si longueur de chaine restante > nbr de donnees a fournir
 if wantloop
 exx
 ld d,a
 exx
 add a,b ; longueur codee en negatif
 jr nc,d4_al_
 else
 add a,b
 jr nc,d4_all
 endif

 ex af,af''
d4_lp1
 ld a,(hl)
 inc hl
 res 2,h
 ld (de),a
 inc de
 res 2,d
 inc b
 jr nz,d4_lp1
 ex af,af''

d4_flag
; on recupere flags et pointeur donnees compressees
; (b inutilise)
 exx
 pop bc
 pop hl

; on extrait nouveau flag
d4_next
 sla c
 jr nz,d4_flgok
 ld c,(hl)
 inc hl
 sll c
d4_flgok
 jr nc,d4_chr

; test similaire au precedent
 ld b,(hl)
 inc hl
 ld d,a ; sauve pour d4_left
 add a,b
 jr nc,d4_left

; il restera (a+1) donnees a fournir apres copie de la chaine
 ex af,af''
 ld a,b
 exx
 ld b,a
 exx
 ld a,(hl)
 inc hl
 exx
 if wantloop
 add a,c
 ld l,a
 ld a,d
 res 0,a
 res 1,a
 exx
 adc a,(hl)
 add ixh
 and #fb
 else
 ld l,a
 ld a,d
 and #fc
 exx
 or (hl)
 endif
 inc hl
 exx
 ld h,a
d4_lp2
 ld a,(hl)
 inc hl
 res 2,h
 ld (de),a
 inc de
 res 2,d
 inc b
 jr nz,d4_lp2
 ex af,af''
 exx
 jr d4_next

d4_left
; idem que d4_all mais sur moins de donnees.
 ex af,af'' ; pour l''instant on conserve a-b
 ld a,d ; nombre de valeur restantes a copier-1
 exx
 ld b,a
 inc b
 exx
 ld a,(hl)
 inc hl
 exx

 if wantloop
 add a,c
 ld l,a
 ld a,d
 res 0,a
 res 1,a
 exx
 adc a,(hl)
 add ixh
 and #fb
 else
 ld l,a
 ld a,d
 and #fc
 exx
 or (hl)
 endif

 inc hl
 push hl
 push bc
 exx
 ld h,a

d4_lp3
 ld a,(hl)
 inc hl
 res 2,h
 ld (de),a
 inc de
 res 2,d
 djnz d4_lp3
 ex af,af''
 ld b,a
 inc b ; longueur restante pour prochaine fois
 push bc
 push hl
 push de
 jp (iy)

 if wantloop
d4_al_
; d0_all ne convient pas quand on veut changer dynamiquement le nombre
; de valeurs a recuperer (c''est le cas pour le bouclage).
 inc a
 ld b,a
 push bc
 exx
 ld a,d
 exx
 ld b,a
 inc b

d4_al_lp
 ld a,(hl)
 ld (de),a
 inc hl
 res 2,h
 inc de
 res 2,d
 djnz d4_al_lp
 push hl
 push de
 jp (iy)
 else

d4_all
;la chaine a copier fournie toutes les donnees
 inc a
 ld b,a ; longueur restante pour prochaine fois
 push bc

d4_copy
 ld a,(hl)
 ld (de),a
 inc hl
 res 2,h
 inc de
 res 2,d
 ds 154,0 ; place pour nbr_reg copies
 ds 5,0 ; place pour d0_model

d4_model ; sera copie a la suite des ldi
 push hl
 push de
 jp (iy)
d4_mode_
 endif

readhead
;on va analyser le header
 ld hl,(duree)
 ld (mesure+1),hl
 ret

attribu
; on reparti les tampons de decompressions. ceux de #400 de long se placent
; en #?000 ou #?800 pour faciliter le modulo, et la routine intercale
; ceux de #100 dans les trous (pile poil).
; on place d''abord ceux de #400
 ld hl,ofbuf0
 ld d,decrubuf/#100
 exx
 ld hl,(adrtemp)
 inc hl
 inc hl ; flag decomp400 ou decomp100
 push hl
 ld de,3
 ld a,(nbr_reg)
 ld b,a ; b=cpt loop, c = nbr de buffer400
 ld c,0
att_lp
 ld a,(hl)
 cp 1
 jr z,att_buf1
 exx
 ld (hl),d
 inc hl
 ld (hl),4
 dec hl
 ld a,d
 add a,8
 ld d,a
 exx
 inc c
att_buf1
 exx
 inc hl
 inc hl
 exx
 add hl,de
 djnz att_lp

; maintenant on va placer les buffer100
 ld hl,ofbuf0
 ld d,decrubuf/#100
 ld b,3 ;pour intercaler 4 buffer100
 exx
 pop hl
 push hl
 ld de,3
 ld a,(nbr_reg)
 ld b,a
att_lp2
 ld a,(hl)
 cp 4 ; on l''a deja traite
 jr z,att_buf4
 exx
 ld a,b
 inc a
 and 3
 ld b,a
 jr nz,att_ok ; on est pas sur une adr congrue a #400
 ld a,c
 or a
 jr z,att_ok ; on a passe tout les buffer #100
 dec c
 ld a,d ; sinon on saute buffer #400
 add a,4
 ld d,a
att_ok
 ld (hl),d
 inc hl
 ld (hl),1
 dec hl
 inc d
 exx
att_buf4
 exx
 inc hl
 inc hl
 exx
 add hl,de
 djnz att_lp2

; un dernier passage pour passer les bons jump
 ld hl,vrout+1
 ld bc,vrout_-vrout-1
 exx
 pop hl
 ld de,3
 ld a,(nbr_reg)
 ld b,a

att_lp3
 ld a,(hl)
 cp 1
 exx
 ld de,decomp0
 jr z,att_r1
 ld de,decomp4

att_r1
 ld (hl),e
 inc hl
 ld (hl),d
 add hl,bc
 exx
 add hl,de
 djnz att_lp3
 ret

pokecode
; code bon nombre de ldis dans routines de decompression
 if wantloop
 else
 ld a,(nbr_reg)
 dec a
 sla a
 sla a
 ld c,a
 ld b,0
 ld hl,d0_copy
 ld de,d0_copy+4
 ldir
 ld hl,d0_model
 ld bc,d0_mode_-d0_model
 ldir
 ld a,(nbr_reg)
 dec a
 sla a
 sla a
 sla a
 ld c,a
 ld b,0
 ld hl,d4_copy
 ld de,d4_copy+8
 ldir
 ld hl,d4_model
 ld bc,d4_mode_-d4_model
 ldir
 endif
 ret

creeplay
; cree routine playreg suivant taille des buffers
 ld hl,ofbuf0
 ld de,playcode
 ld b,(hl) ; poids fort du 1er tampon
 inc hl
 ld a,(hl) ; taille
 inc hl
 cp 1
 call z,cp_1
 call nz,cp_4
 ld b,13 ; 13 premiers registre

cp_lp
 push bc
 call cp_copy
 ld b,(hl)
 inc hl
 ld a,(hl)
 cp 4
 call z,cp_4
 jr z,cp_sui

; on verifie si buffer precedent etait de taille 1,
; et s''il etait place cote @ cote, pour pouvoir mettre inc l
 dec hl
 dec hl
 cp (hl)
 call nz,cp_1
 jr nz,cp_sui0
 dec hl
 ld a,(hl) ; adr precedente buffer
 inc hl
 sub b
 inc a
 call z,cp_1inc
 call nz,cp_1

cp_sui0
 inc hl
 inc hl

cp_sui
 inc hl
 pop bc
 djnz cp_lp

; le registre 13 a un traitement different
; on le joue meme en cas de valeur identique, sauf si c''est #ff
 ex de,hl
 ld (hl),#7e ; ld a,(hl)
 inc hl
 ld (hl),#3c ; inc a
 inc hl
 ld (hl),#28 ; jr z,
 inc hl
 ld (hl),mo_same-mo_suite+1
 inc hl
 ld (hl),#3d ; dec a
 inc hl
 ex de,hl
 ld hl,mo_suite
 ld bc,mo_end-mo_suite
 ldir
 dec de ; on ecrase dernier inc c
 ld hl,mo2
 ld bc,mo2_end-mo2
 ldir
 ret

cp_copy
; on copie partie outs
 push hl
 ld hl,modele
 ldi ; ld a,(hl)
 ldi ; cp 0
 ld b,d ; on stocke nn...
 ld c,#ff ; pour que ldi ne modifisse pas b !
 ld a,e
 ldi
 ldi ; jr z,mo_same
 ldi
 ldi ; ld (nn),a
 ld (de),a ; ...et ici on copie nn !
 inc de
 ld a,b
 ld (de),a
 inc de

cp_copy2
 ld hl,mo_suite
 ld bc,mo_end-mo_suite
 ldir
 pop hl
 ret

cp_1
; si tampon de taille #100 on code
; ld h,n
 ex de,hl
 ld (hl),#26
 inc hl
 ld (hl),b
 inc hl
 ex de,hl
 ret

cp_1inc
; quand 2 tampon de taille #100 successif, on code
; inc h
 ld a,#24
 ld (de),a
 inc de
 ret

cp_4
; si c''est un tampon de taille #400, on code "ld a,n + or d + ld h,a"
 ex de,hl
 ld (hl),#3e
 inc hl
 ld (hl),b
 inc hl
 ld (hl),#b2
 inc hl
 ld (hl),#67
 inc hl
 ex de,hl
 ret

razvar
; toutes les auto-modifs pour la gestion
 ld hl,vmesure
 ld (getwitch+1),hl
 if wantloop
 ld hl,v0
 ld (getwitc_+1),hl
 xor a
 ld (decaleh+2),a
 endif
 ld hl,0
 ld (playplag+1),hl
 call setvar
 ld hl,regs ; on copie variable pour reset/bouclage
 ld de,regscopy
 ld bc,16*10
 ldir
 ret

setvar
; init variables regs pour la decompression.
 ld hl,ofbuf0
 exx
 ld a,(nbr_reg)
 ld b,a ; nombre registres traites
 ld de,(adrtemp) ; pointe sur donnees (en relatif)
 inc de
 inc de ; saute "longueur"
 ld hl,regs

razloop
 push bc
; on place adr dest
 exx
 ld a,(hl)
 inc hl
 inc hl
 exx
 ld (hl),0
 inc hl
 ld (hl),a
 inc hl

; adr source pour copie chaine : forcement meme poids fort qd fenetre #100
 inc hl
 ld (hl),a
 inc hl

; valeur decalage (quand boucle, les donnees ne sont plus placees a partir de 0,
; les references absolues doivent etre corrigees)
 ld (hl),0
 inc hl

; on place nbr de chr restant a copier = 0
 ld (hl),0
 inc hl

; octet flag a #40 pour copie 1er octet et enclencher lecture nouveaux flags
 ld (hl),#40
 inc hl
 inc hl

; maintenant il faut lire adr debut donnees compresses,
; donnees en relatif par rapport a position courante dans header
 ex de,hl
 inc hl ; on saute type compression
 ld c,(hl)
 inc hl
 ld b,(hl)
 push hl
 add hl,bc
 ld b,h
 ld c,l
 pop hl
 inc hl
 ex de,hl
 ld (hl),c
 inc hl
 ld (hl),b
 inc hl
 pop bc
 djnz razloop
 ret

var 
; variables de travail
regs 
 ds 16*10,0 ; variables pour chaque registre
regscopy 
 ds 16*10,0 ; pour reset lors du bouclage

; pour chaque registre, on a :
; adresse destination (de)
; adresse source chaine (hl) ne sert pas forcement
; flag/compteur chaine (bc) c : poids faible decalage
; octet flags (bc'') b'' inutilise
; source data compresses (hl'')

data
; nbr_reg est une constante qui permet de determiner combien recuperer
; de donnees a la fois. si nbr_reg = 14, on recupere 14 donnees par registre et
; par vbl. au bout de 14 vbl, on peut jouer 14 fois tous les reg., le temps de
; recuperer 14*14 nouvelles donnees.
nbr_reg
 db 14,0 ; !!! modifier (v14-2) en consequence !!

adrtemp
 dw ymlz

ofbuf0 
 db #c0 ;poids fort adresse
 db 4 ; taille (1 ou 4) pour creeplay

; attention les tampons de #400 doivent commencer en #x000 ou #x800
 db #c4,1,#c8,4,#c5,1,#d0,4
 db #c6,1,#c7,1,#cc,1,#cd,1
 db #ce,1,#cf,1,#d4,1,#d5,1
 db #d6,1,#d7,1,#d8,1
player_end

ymlz 
; incbin "carlos.ayc" ; fichier ayc sans en-tête amsdos hein ^^
; dump hexa follow...
db #00,#3c,#01,#2e,#00,#01,#e9,#08
db #01,#56,#0b,#01,#a2,#1b,#04,#71
db #1c,#01,#d5,#28,#01,#88,#29,#01
db #88,#2b,#01,#c7,#32,#01,#2e,#36
db #01,#05,#39,#01,#3c,#3c,#01,#02
db #3e,#01,#80,#3e,#ff,#ff,#ff,#ff
db #ff,#ff,#99,#0b,#2a,#4a,#23,#79
db #ed,#04,#e3,#fb,#18,#ee,#0c,#57
db #71,#f5,#30,#1c,#fb,#3c,#87,#ef
db #42,#f4,#30,#b8,#00,#1b,#51,#e2
db #72,#fd,#aa,#fd,#a8,#02,#fe,#88
db #fd,#ae,#ee,#fa,#b4,#fd,#b1,#fa
db #60,#0f,#fb,#c6,#fa,#84,#fa,#c6
db #cd,#38,#15,#5d,#f7,#7b,#fa,#d2
db #fa,#8a,#91,#22,#43,#e7,#fd,#99
db #fa,#e4,#f4,#9c,#09,#51,#fe,#c0
db #fe,#bd,#fa,#f6,#fd,#fa,#96,#fa
db #0e,#a6,#c0,#fa,#79,#6d,#c0,#fd
db #07,#10,#fe,#16,#55,#11,#fe,#19
db #14,#fe,#1c,#16,#fe,#1f,#19,#fe
db #22,#55,#1b,#fe,#25,#1e,#fe,#28
db #21,#fe,#2b,#24,#fe,#2e,#55,#28
db #fe,#31,#2d,#fe,#34,#32,#fe,#37
db #35,#fe,#3a,#7f,#3c,#fe,#3d,#6d
db #80,#d9,#73,#fa,#f9,#00,#40,#20
db #40,#a0,#df,#ff,#a0,#80,#a6,#40
db #fa,#f9,#00,#40,#00,#40,#00,#40
db #00,#40,#00,#40,#ff,#f0,#a0,#fa
db #c8,#fa,#15,#fd,#e0,#fd,#1c,#f4
db #10,#fa,#04,#f4,#22,#b7,#f4,#34
db #64,#fb,#4c,#f7,#f2,#93,#fe,#5b
db #f4,#4c,#fd,#5b,#fd,#fd,#6c,#fd
db #b0,#fd,#6d,#f4,#64,#fa,#d4,#f4
db #c8,#5f,#fb,#94,#f8,#ee,#da,#ac
db #4c,#00,#40,#00,#40,#f0,#a0,#01
db #49,#91,#ff,#f7,#b3,#fa,#c8,#f4
db #c2,#fa,#2d,#64,#74,#d0,#70,#00
db #40,#00,#40,#f7,#d5,#a0,#eb,#28
db #fa,#e0,#ee,#45,#e3,#fb,#58,#ee
db #4c,#fa,#22,#ae,#fa,#75,#1c,#fb
db #7c,#87,#ef,#82,#f4,#70,#b8,#40
db #26,#00,#27,#2a,#2f,#2f,#36,#3a
db #3d,#42,#00,#48,#4e,#52,#55,#5a
db #5c,#61,#67,#13,#6c,#72,#77,#fe
db #c8,#78,#78,#fa,#a0,#fa,#16,#c7
db #fa,#c4,#fa,#06,#cd,#15,#5d,#f7
db #bb,#fa,#12,#fa,#ca,#18,#91,#22
db #43,#fd,#d9,#fa,#24,#3d,#cd,#ee
db #76,#c7,#f8,#e0,#f4,#00,#fd,#30
db #1b,#f8,#34,#dc,#00,#2f,#19,#c0
db #e0,#b9,#ec,#28,#f4,#dc,#09,#51
db #fe,#60,#7f,#02,#f9,#71,#f4,#d0
db #00,#00,#aa,#00,#fd,#e0,#f4,#16
db #fd,#e3,#c7,#f1,#16,#fa,#34,#a7
db #38,#59,#c4,#80,#fe,#c0,#fc,#7d
db #97,#fa,#c2,#09,#51,#fe,#40,#02
db #f9,#63,#fd,#73,#f7,#73,#ff,#a6
db #40,#fa,#f9,#00,#40,#00,#40,#00
db #40,#00,#40,#00,#40,#f0,#a0,#ff
db #fa,#c8,#fa,#15,#fd,#e0,#fd,#1c
db #f4,#10,#fa,#04,#f1,#10,#c7,#83
db #0e,#3d,#cd,#ee,#c7,#f8,#c0,#f4
db #40,#fd,#70,#1b,#87,#d4,#d8,#2f
db #c0,#e0,#b9,#ec,#68,#fe,#80,#fc
db #dd,#ff,#fa,#82,#fa,#34,#fa,#d6
db #fd,#d3,#f7,#f6,#00,#40,#00,#40
db #f0,#40,#f1,#fa,#e0,#f7,#10,#fa
db #1c,#fd,#19,#51,#e2,#72,#fe,#6c
db #fe,#f0,#27,#fd,#3a,#70,#80,#f4
db #70,#fe,#80,#fc,#dd,#fa,#82,#09
db #7f,#51,#fe,#a0,#fe,#37,#fa,#d6
db #fd,#d3,#f7,#f6,#40,#40,#fd,#78
db #1d,#ed,#c6,#3c,#fa,#c0,#fd,#cb
db #f1,#c6,#b3,#fe,#de,#5a,#a0,#fe
db #e1,#97,#fe,#e4,#fd,#81,#5a,#fe
db #ea,#50,#b5,#fe,#ed,#4b,#fe,#f0
db #fd,#d5,#2d,#fe,#f6,#28,#fe,#f9
db #55,#25,#fe,#fc,#1e,#fe,#ff,#16
db #fe,#02,#14,#fe,#05,#6f,#13,#fe
db #08,#fd,#b1,#0b,#fe,#0e,#fd,#0b
db #fd,#08,#fd,#05,#ff,#fd,#02,#fd
db #ff,#fd,#fc,#fd,#f9,#fd,#f6,#fd
db #f3,#fd,#f0,#fd,#ed,#fe,#fd,#ea
db #fd,#e7,#fd,#e4,#fd,#e1,#fd,#de
db #fd,#38,#fd,#bd,#64,#eb,#fe,#47
db #fd,#32,#fd,#2c,#38,#fe,#50,#32
db #fe,#53,#fd,#26,#dd,#fd,#20,#fd
db #9f,#19,#fe,#5f,#fd,#1a,#fd,#14
db #0e,#fe,#68,#fe,#fd,#65,#fd,#62
db #fd,#5f,#fd,#5c,#fd,#59,#fd,#56
db #fd,#53,#c3,#0f,#0b,#53,#e3,#bc
db #f9,#7f,#f7,#7d,#f7,#8c,#fd,#41
db #ba,#fd,#a5,#7f,#fe,#a4,#fd,#47
db #fd,#4d,#43,#fe,#ad,#3f,#eb,#fe
db #b0,#fd,#95,#fd,#77,#21,#fe,#b9
db #20,#fe,#bc,#fd,#71,#ab,#fd,#6b
db #10,#fb,#c5,#0c,#fe,#cb,#09,#fe
db #ce,#fd,#cb,#ff,#fa,#c5,#fd,#c2
db #fd,#bf,#fd,#bc,#fd,#b9,#fd,#b6
db #fd,#b3,#fd,#b0,#fe,#fd,#ad,#fd
db #aa,#fd,#a7,#fd,#a4,#fd,#a1,#fd
db #9e,#fd,#f8,#5f,#ba,#fe,#04,#55
db #fe,#07,#fd,#f2,#fd,#ec,#2f,#fe
db #10,#2a,#eb,#fe,#13,#fd,#e6,#fd
db #e0,#18,#fe,#1c,#15,#fe,#1f,#fa
db #c2,#fe,#fa,#d1,#fd,#22,#fd,#1f
db #fd,#1c,#fd,#19,#fd,#16,#fd,#13
db #cd,#07,#15,#5d,#ed,#c6,#3c,#fa
db #40,#fd,#4b,#f1,#46,#5a,#b3,#fe
db #5e,#a0,#fe,#61,#fd,#fe,#79,#fe
db #67,#5a,#bd,#fe,#6a,#50,#fe,#6d
db #fd,#0a,#fd,#55,#fd,#7a,#28,#fe
db #79,#ab,#fd,#3a,#1e,#fe,#7f,#16
db #fe,#82,#14,#fe,#85,#fd,#2e,#5f
db #0f,#fe,#8b,#0b,#fe,#8e,#fd,#8b
db #fd,#88,#fd,#85,#fd,#82,#ff,#fd
db #7f,#fd,#7c,#fd,#79,#fd,#76,#fd
db #73,#fd,#70,#fd,#6d,#fd,#6a,#fb
db #fd,#67,#fd,#64,#fd,#61,#fd,#5e
db #fd,#b8,#71,#fe,#c4,#fd,#f5,#de
db #fd,#b2,#fd,#ac,#38,#fe,#d0,#fd
db #e9,#fd,#a6,#fd,#a0,#1c,#bb,#fe
db #dc,#19,#fe,#df,#fd,#9a,#fd,#94
db #0e,#fe,#e8,#fd,#e5,#fc,#fd,#e2
db #fd,#df,#fd,#dc,#fd,#d9,#fd,#d6
db #fd,#d3,#c3,#0b,#1e,#53,#e3,#bc
db #f9,#ff,#f7,#fd,#f7,#0c,#fd,#c1
db #87,#ba,#fe,#21,#7f,#fe,#24,#fd
db #c7,#fd,#cd,#43,#fe,#2d,#3f,#eb
db #fe,#30,#fd,#15,#fd,#f7,#21,#fe
db #39,#20,#fe,#3c,#fd,#f1,#ab,#fd
db #eb,#10,#fb,#45,#0c,#fe,#4b,#09
db #fe,#4e,#fd,#4b,#ff,#fa,#45,#fd
db #42,#fd,#3f,#fd,#3c,#fd,#39,#fd
db #36,#fd,#33,#fd,#30,#fe,#fd,#2d
db #fd,#2a,#fd,#27,#fd,#24,#fd,#21
db #fd,#1e,#fd,#78,#5f,#b8,#fe,#84
db #55,#fe,#87,#fd,#72,#fd,#6c,#c9
db #11,#59,#80,#fd,#18,#bd,#05,#4d
db #b6,#fe,#46,#ad,#00,#f5,#3d,#a9
db #f1,#3a,#a6,#ef,#37,#03,#a3,#eb
db #33,#9e,#e7,#2f,#fd,#a5,#fd,#a2
db #f8,#fd,#9f,#fd,#9c,#fd,#99,#fd
db #96,#fd,#93,#09,#51,#99,#14,#2a
db #02,#79,#f4,#c5,#0f,#fb,#d2,#cd
db #15,#3c,#5d,#e3,#fe,#db,#f4,#cc
db #fd,#db,#fd,#ec,#91,#22,#30,#43
db #71,#fe,#f3,#fa,#e4,#3d,#cd,#ee
db #c7,#39,#1c,#1c,#fd,#7b,#fd,#04
db #fe,#c2,#4a,#23,#f8,#e2,#b7,#fd
db #f0,#1b,#f8,#f4,#f4,#08,#e2,#fb
db #2c,#f4,#d2,#fa,#2c,#0f,#2f,#c0
db #e0,#b9,#f8,#2a,#f4,#f0,#fd,#7e
db #fd,#5e,#fc,#fa,#4a,#fa,#c0,#fa
db #56,#f4,#c6,#00,#c0,#80,#c0,#17
db #5f,#1b,#a7,#38,#10,#fa,#82,#f9
db #0a,#10,#fb,#12,#fd,#00,#ff,#fe
db #80,#f9,#81,#fa,#12,#fd,#1b,#fd
db #2c,#fa,#d0,#fa,#24,#f4,#7c,#1b
db #5f,#f0,#80,#fd,#04,#fa,#36,#43
db #fb,#54,#ee,#9a,#7f,#f1,#fb,#6c
db #f4,#b2,#fa,#6c,#fa,#c4,#fa,#7e
db #fd,#60,#fd,#fd,#be,#fa,#72,#40
db #fb,#9c,#fa,#8a,#fa,#e8,#fd,#90
db #fd,#ae,#71,#07,#01,#22,#fa,#50
db #50,#fa,#60,#f4,#60,#fa,#fa,#ff
db #f4,#72,#f4,#cc,#fd,#db,#fd,#ec
db #fa,#30,#fa,#e4,#f4,#3c,#f4,#c0
db #bf,#fd,#f0,#1b,#f8,#f4,#dc,#c0
db #fa,#84,#ee,#ea,#fe,#00,#fc,#5d
db #ff,#fa,#02,#fa,#a8,#fa,#56,#fd
db #53,#f7,#76,#00,#c0,#00,#c0,#00
db #c0,#ed,#40,#c0,#fa,#28,#fa,#45
db #64,#fb,#4c,#f7,#f2,#93,#fe,#5b
db #ff,#f4,#4c,#fd,#5b,#fd,#6c,#fd
db #10,#fd,#6d,#f4,#64,#f4,#3a,#fa
db #76,#7e,#5f,#fb,#94,#ee,#da,#ac
db #4c,#00,#40,#00,#40,#f0,#a0,#01
db #3f,#49,#91,#f7,#b3,#fa,#c8,#f4
db #c2,#fa,#2d,#64,#74,#d0,#70,#fe
db #00,#40,#00,#40,#d5,#a0,#eb,#28
db #f4,#e0,#fa,#86,#f7,#f2,#e3,#fe
db #fe,#5b,#f4,#4c,#fd,#5b,#fd,#6c
db #fd,#10,#fd,#25,#fa,#64,#3d,#03
db #cd,#ee,#c7,#1c,#1c,#87,#fb,#82
db #f4,#40,#b0,#fd,#70,#1b,#f8,#74
db #dc,#40,#2f,#c0,#e0,#b9,#f9,#ec
db #68,#fe,#80,#fc,#dd,#fa,#82,#fd
db #3d,#2a,#02,#f9,#b1,#ff,#fa,#22
db #fa,#f9,#00,#40,#00,#40,#f0,#40
db #fa,#e0,#f7,#10,#fa,#1c,#8f,#fd
db #19,#51,#e2,#72,#fe,#6c,#f0,#27
db #fd,#3a,#70,#80,#f3,#f4,#70,#fe
db #80,#fc,#dd,#fa,#82,#09,#51,#fe
db #a0,#fe,#37,#ff,#fa,#d6,#fd,#d3
db #f7,#f6,#00,#40,#00,#40,#c0,#40
db #fa,#28,#f4,#45,#bf,#a6,#92,#e2
db #fb,#ac,#f4,#52,#fa,#ac,#fa,#04
db #fa,#be,#f4,#70,#7e,#97,#fb,#dc
db #fa,#ca,#f4,#28,#f4,#46,#00,#40
db #80,#40,#17,#0d,#5f,#a7,#38,#10
db #fa,#02,#f9,#8a,#10,#fb,#92,#ff
db #fd,#80,#fe,#00,#f9,#01,#fa,#92
db #fd,#9b,#fd,#ac,#fa,#50,#fa,#a4
db #8d,#f4,#fc,#5f,#f0,#80,#fd,#84
db #fa,#b6,#43,#fb,#d4,#bf,#ee,#1a
db #f1,#fb,#ec,#f4,#32,#fa,#ec,#fa
db #44,#fa,#fe,#fd,#e0,#df,#fd,#7d
db #fa,#f2,#40,#fb,#1c,#fa,#0a,#fa
db #68,#fd,#10,#fd,#2e,#03,#71,#01
db #22,#fa,#50,#50,#fa,#e0,#fd,#f8
db #1d,#ed,#c6,#3c,#fa,#40,#fd,#4b
db #f1,#46,#b3,#fe,#5e,#5b,#a0,#fe
db #61,#97,#fe,#64,#fd,#13,#5a,#fe
db #6a,#fe,#38,#35,#50,#4b,#fe,#70
db #fd,#55,#2d,#fe,#76,#28,#fe,#79
db #55,#25,#fe,#7c,#1e,#fe,#7f,#16
db #fe,#82,#14,#fe,#85,#6f,#13,#fe
db #88,#fd,#19,#0b,#fe,#8e,#fd,#8b
db #fd,#88,#fd,#85,#ff,#fd,#82,#fd
db #7f,#fd,#7c,#fd,#79,#fd,#76,#fd
db #73,#fd,#70,#fd,#6d,#fd,#fd,#6a
db #fd,#67,#fd,#64,#fd,#61,#fd,#5e
db #fd,#b8,#71,#fe,#c4,#75,#64,#fe
db #c7,#fd,#b2,#fd,#ac,#38,#fe,#d0
db #32,#fe,#d3,#d7,#fd,#a6,#fd,#a0
db #1c,#fe,#dc,#19,#fe,#df,#fd,#9a
db #fd,#94,#7f,#0e,#fe,#e8,#fd,#e5
db #fd,#e2,#fd,#df,#fd,#dc,#fd,#d9
db #fd,#d6,#83,#fd,#d3,#c3,#0b,#53
db #e3,#bc,#f9,#ff,#f7,#fd,#d7,#f7
db #0c,#fd,#c1,#87,#fe,#21,#7f,#fe
db #24,#fd,#c7,#fd,#cd,#5d,#43,#fe
db #2d,#3f,#fe,#30,#fd,#15,#fd,#f7
db #21,#fe,#39,#75,#20,#fe,#3c,#fd
db #f1,#fd,#eb,#10,#fb,#45,#0c,#fe
db #4b,#7f,#09,#fe,#4e,#fd,#4b,#fa
db #45,#fd,#42,#fd,#3f,#fd,#3c,#fd
db #39,#ff,#fd,#36,#fd,#33,#fd,#30
db #fd,#2d,#fd,#2a,#fd,#27,#fd,#24
db #fd,#21,#d7,#fd,#1e,#fd,#78,#5f
db #fe,#84,#55,#fe,#87,#fd,#72,#fd
db #6c,#10,#c9,#11,#59,#fd,#18,#bd
db #05,#4d,#b6,#00,#fe,#46,#ad,#f5
db #3d,#a9,#f1,#3a,#00,#a6,#ef,#37
db #a3,#eb,#33,#9e,#e7,#7f,#2f,#fd
db #a5,#fd,#a2,#fd,#9f,#fd,#9c,#fd
db #99,#fd,#96,#fd,#93,#03,#cd,#15
db #5d,#ed,#c6,#3c,#fa,#c0,#fd,#cb
db #ad,#f1,#c6,#b3,#fe,#de,#a0,#fe
db #e1,#fd,#7e,#79,#fe,#e7,#5e,#5a
db #fe,#ea,#50,#fe,#ed,#fd,#8a,#fd
db #d5,#fd,#fa,#28,#d5,#fe,#f9,#fd
db #66,#1e,#fe,#ff,#16,#fe,#02,#14
db #fe,#05,#af,#fd,#5a,#0f,#fe,#0b
db #0b,#fe,#0e,#fd,#0b,#fd,#08,#fd
db #05,#ff,#fd,#02,#fd,#ff,#fd,#fc
db #fd,#f9,#fd,#f6,#fd,#f3,#fd,#f0
db #fd,#ed,#fd,#fd,#ea,#fd,#e7,#fd
db #e4,#fd,#e1,#fd,#de,#fd,#38,#71
db #fe,#44,#ef,#fd,#75,#fd,#32,#fd
db #2c,#38,#fe,#50,#fd,#69,#fd,#26
db #fd,#20,#5d,#1c,#fe,#5c,#19,#fe
db #5f,#fd,#1a,#fd,#14,#0e,#fe,#68
db #ff,#fd,#65,#fd,#62,#fd,#5f,#fd
db #5c,#fd,#59,#fd,#56,#fd,#53,#fd
db #bd,#3d,#e3,#bc,#f9,#7f,#f7,#7d
db #f7,#8c,#fd,#41,#87,#fe,#a1,#75
db #7f,#fe,#a4,#fd,#47,#fd,#4d,#43
db #fe,#ad,#3f,#fe,#b0,#d7,#fd,#95
db #fd,#77,#21,#fe,#b9,#20,#fe,#bc
db #fd,#71,#fd,#6b,#57,#10,#fb,#c5
db #0c,#fe,#cb,#09,#fe,#ce,#fd,#cb
db #fa,#c5,#ff,#fd,#c2,#fd,#bf,#fd
db #bc,#fd,#b9,#fd,#b6,#fd,#b3,#fd
db #b0,#fd,#ad,#fd,#fd,#aa,#fd,#a7
db #fd,#a4,#fd,#a1,#fd,#9e,#fd,#f8
db #5f,#fe,#04,#71,#55,#fe,#07,#fd
db #f2,#fd,#ec,#c9,#11,#59,#fd,#98
db #00,#bd,#05,#4d,#b6,#fe,#46,#ad
db #f5,#00,#3d,#a9,#f1,#3a,#a6,#ef
db #37,#a3,#07,#eb,#33,#9e,#e7,#2f
db #fd,#25,#fd,#22,#fd,#1f,#f1,#fd
db #1c,#fd,#19,#fd,#16,#fd,#13,#ae
db #f6,#3f,#d0,#40,#1e,#cf,#a7,#1e
db #fa,#70,#fd,#7b,#dc,#76,#a3,#a2
db #01,#0b,#02,#03,#04,#00,#ed,#04
db #01,#fb,#18,#e2,#0c,#7f,#02,#fb
db #3c,#ec,#04,#f5,#20,#b9,#01,#fe
db #8e,#fc,#9e,#fd,#a8,#7f,#03,#fb
db #a6,#fa,#b4,#fc,#b1,#e9,#61,#fa
db #89,#ee,#7e,#fb,#bb,#ff,#eb,#95
db #f4,#f0,#de,#56,#1c,#d8,#dc,#1b
db #64,#80,#00,#7c,#00,#7c,#ff,#9c
db #db,#a0,#80,#00,#40,#00,#40,#00
db #40,#00,#40,#00,#40,#8f,#40,#ff
db #f5,#c9,#fd,#12,#fc,#1c,#ef,#c9
db #f3,#10,#e9,#c9,#e5,#98,#f7,#5b
db #ff,#fa,#6b,#b1,#c2,#d0,#71,#00
db #41,#00,#41,#f0,#a1,#e9,#bd,#57
db #68,#ff,#d0,#71,#00,#41,#00,#41
db #d6,#a1,#ea,#2a,#e9,#e1,#f4,#1c
db #e8,#52,#7f,#02,#fb,#7c,#eb,#e4
db #df,#d7,#a0,#58,#fa,#c9,#ee,#be
db #fd,#00,#af,#f7,#21,#03,#fe,#02
db #05,#f8,#e0,#f4,#00,#e8,#48,#e8
db #0c,#ff,#fa,#2f,#ee,#2a,#f4,#dc
db #f2,#8e,#00,#f6,#a0,#f6,#fd,#10
db #f4,#16,#ff,#fd,#e3,#f1,#16,#f1
db #19,#ca,#86,#fe,#c0,#fc,#7d,#f7
db #64,#f5,#71,#ff,#f5,#60,#00,#41
db #00,#41,#00,#41,#00,#41,#00,#41
db #90,#41,#f5,#c9,#fa,#fd,#12,#fc
db #1c,#ef,#c9,#f1,#10,#c7,#83,#03
db #fe,#42,#05,#ff,#f7,#c0,#f5,#41
db #e8,#88,#e8,#4c,#fa,#6f,#ee,#6a
db #fe,#80,#fc,#dd,#ff,#ee,#2e,#f3
db #ad,#00,#41,#00,#41,#ee,#41,#fd
db #e3,#f7,#10,#fa,#1c,#ff,#fc,#19
db #f9,#05,#f3,#2a,#fc,#3a,#6e,#81
db #f7,#b0,#fe,#80,#fc,#dd,#ff,#f7
db #b3,#f5,#d1,#f5,#af,#41,#41,#fb
db #a7,#f8,#bf,#f7,#be,#f4,#cd,#ff
db #61,#e1,#00,#c1,#00,#c1,#ee,#f1
db #f9,#90,#fe,#96,#e1,#99,#fb,#94
db #bc,#fc,#19,#03,#e9,#ed,#fc,#97
db #f1,#cf,#f3,#c1,#03,#03,#1b,#04
db #05,#02,#f9,#1c,#fd,#f0,#04,#f7
db #e2,#e9,#09,#ff,#e8,#cc,#f4,#ef
db #e9,#c2,#fc,#38,#eb,#51,#00,#c0
db #68,#c0,#fc,#00,#ff,#f8,#80,#fa
db #23,#fd,#1b,#fd,#2c,#e7,#70,#e9
db #d0,#c4,#a0,#fb,#79,#ff,#f7,#7d
db #fc,#90,#fd,#aa,#fa,#ae,#fd,#92
db #fa,#60,#dc,#60,#f4,#96,#ff,#e7
db #30,#f5,#c1,#e8,#08,#e2,#6c,#ee
db #ea,#fe,#00,#fc,#5d,#f4,#a2,#ff
db #ed,#27,#00,#c1,#00,#c1,#00,#c1
db #40,#c1,#e9,#29,#e5,#98,#f5,#fb
db #ff,#f4,#fa,#e9,#2a,#dd,#e1,#c3
db #64,#00,#41,#00,#41,#f0,#a1,#e9
db #bd,#ff,#57,#68,#d0,#71,#00,#41
db #00,#41,#d6,#a1,#ea,#2a,#ce,#e1
db #f7,#61,#47,#03,#fe,#42,#05,#02
db #02,#ee,#da,#e8,#88,#e8,#4c,#ff
db #fa,#6f,#ee,#6a,#fe,#80,#fc,#dd
db #f7,#b3,#f5,#d1,#f5,#af,#00,#41
db #ff,#00,#41,#ee,#41,#fd,#e3,#f7
db #10,#fa,#1c,#fc,#19,#f9,#05,#f3
db #2a,#ff,#fc,#3a,#6e,#81,#f7,#b0
db #fe,#80,#fc,#dd,#f7,#b3,#f5,#d1
db #f5,#af,#ff,#00,#41,#00,#41,#c0
db #41,#e9,#29,#8e,#98,#f7,#9a,#e8
db #a4,#00,#2b,#ff,#53,#2b,#fc,#80
db #f8,#00,#fa,#a3,#fd,#9b,#fd,#ac
db #e7,#f0,#e9,#50,#ff,#c4,#20,#fb
db #f9,#f7,#fd,#fc,#10,#fd,#2a,#fa
db #2e,#fd,#12,#f9,#e0,#ff,#fc,#28
db #f8,#3f,#f7,#3e,#f4,#4d,#61,#61
db #70,#41,#fe,#1a,#f9,#90,#ff,#fe
db #96,#e1,#99,#f8,#91,#72,#03,#ce
db #61,#72,#c3,#fe,#9a,#f9,#10,#ff
db #fe,#16,#e1,#19,#d9,#14,#ef,#5f
db #fb,#9b,#f7,#9a,#dc,#78,#a5,#a4
db #79,#b7,#fb,#00,#b3,#fe,#06,#fd
db #03,#97,#fe,#0c,#fd,#06,#fd,#11
db #ed,#fd,#0c,#fa,#03,#5e,#06,#3c
db #fe,#b2,#fd,#c0,#5a,#fe,#bb,#bf
db #fd,#c3,#4b,#fe,#be,#fd,#c6,#fd
db #cf,#fd,#cc,#fa,#c3,#5e,#c6,#80
db #70,#7f,#cd,#52,#6b,#dc,#28,#28
db #1e,#00,#1e,#3c,#3c,#2d,#2d,#c9
db #4e,#68,#00,#da,#25,#25,#1c,#1c
db #38,#38,#2a,#42,#2a,#f4,#10,#d3
db #59,#70,#e2,#fe,#32,#21,#05,#21
db #43,#43,#32,#32,#fe,#79,#2d,#f1
db #40,#13,#a9,#55,#2a,#f1,#4c,#c9
db #64,#f9,#3f,#f7,#64,#8c,#f4,#73
db #e2,#71,#38,#fa,#7f,#f7,#88,#be
db #5f,#7f,#2f,#fa,#91,#fd,#9a,#fd
db #85,#fa,#9d,#f1,#49,#fd,#b2,#f7
db #b8,#c7,#f4,#58,#e2,#70,#0e,#87
db #43,#fa,#eb,#fd,#f4,#fd,#6d,#e0
db #fd,#f7,#00,#40,#20,#40,#2a,#2b
db #2e,#2f,#2b,#12,#2d,#2d,#2b,#fe
db #e4,#2e,#2e,#fb,#e5,#2d,#36,#2f
db #2f,#b4,#ec,#fe,#c6,#16,#f1,#40
db #fe,#9c,#15,#dd,#f1,#4c,#fe,#ae
db #19,#f1,#5e,#f4,#73,#fe,#d8,#1c
db #fa,#7f,#df,#f7,#88,#fe,#de,#18
db #fa,#91,#fd,#9a,#fd,#85,#fa,#9d
db #f1,#49,#f1,#fd,#b2,#f7,#b8,#f4
db #58,#e2,#70,#87,#43,#21,#fa,#eb
db #ff,#fd,#f4,#fd,#6d,#fd,#f7,#00
db #40,#00,#40,#00,#40,#00,#40,#00
db #40,#c7,#de,#40,#e2,#1f,#4b,#3f
db #32,#00,#40,#00,#40,#30,#40,#00
db #27,#4e,#44,#39,#2e,#55,#4b,#40
db #00,#34,#5c,#52,#46,#3b,#63,#59
db #4d,#00,#42,#69,#5f,#54,#49,#70
db #66,#5b,#00,#50,#77,#6d,#62,#56
db #7e,#74,#68,#00,#5d,#85,#7a,#6f
db #64,#8b,#81,#76,#02,#6b,#92,#86
db #79,#6c,#21,#fe,#40,#20,#38,#1f
db #1e,#fa,#45,#fa,#43,#fd,#4c,#1d
db #1c,#1b,#1d,#19,#18,#17,#fd,#5a
db #f9,#43,#fd,#55,#1a,#fd,#58,#7f
db #15,#fd,#6c,#fd,#64,#fd,#72,#f4
db #64,#fd,#77,#fd,#84,#fa,#55,#1e
db #16,#15,#14,#fd,#90,#fd,#79,#fd
db #96,#fa,#79,#14,#38,#13,#12,#fd
db #a2,#fa,#58,#fa,#8b,#13,#11,#10
db #f7,#fd,#b4,#fa,#7c,#fa,#9d,#fe
db #b3,#0f,#fd,#c6,#fd,#bf,#fd,#cc
db #be,#f8,#bf,#0e,#fd,#d8,#fd,#d1
db #fd,#de,#fb,#b0,#fe,#d7,#0d,#7a
db #0c,#fd,#ea,#fd,#e3,#fd,#f0,#f8
db #e3,#0b,#fd,#fc,#11,#bd,#fe,#e1
db #15,#fc,#b4,#fa,#07,#fc,#a2,#fc
db #0c,#0c,#fe,#fa,#3d,#0a,#08,#fd
db #1a,#fe,#c8,#fc,#f0,#fc,#1e,#0b
db #fe,#fb,#3c,#08,#07,#fd,#2c,#fa
db #1e,#fe,#da,#fe,#12,#0a,#0b,#1e
db #0a,#07,#06,#fd,#3e,#fc,#36,#fe
db #45,#f4,#36,#0d,#69,#0d,#fc,#c6
db #fc,#54,#09,#fe,#19,#06,#05,#fd
db #62,#f3,#ee,#54,#fe,#ec,#fc,#d8
db #fc,#78,#08,#09,#fa,#72,#fe,#fe
db #e0,#fe,#6c,#fe,#8d,#fd,#8a,#14
db #15,#1c,#22,#26,#00,#2c,#33,#3a
db #40,#3b,#38,#34,#31,#00,#30,#2d
db #31,#33,#32,#34,#34,#36,#00,#39
db #3b,#3f,#40,#40,#41,#41,#43,#00
db #46,#48,#4c,#4e,#4d,#4f,#4f,#51
db #00,#54,#56,#5a,#5b,#5b,#5c,#5c
db #5e,#02,#1f,#20,#23,#25,#22,#25
db #fa,#c5,#20,#e0,#fe,#96,#fd,#ce
db #fd,#cc,#29,#25,#28,#29,#29,#70
db #2a,#fd,#da,#fa,#cc,#fe,#c4,#29
db #2b,#27,#2a,#1e,#2b,#2b,#2d,#fd
db #ec,#fd,#e4,#fd,#f2,#f4,#e4,#24
db #62,#26,#fc,#da,#fd,#02,#2d,#29
db #2c,#fe,#00,#2e,#98,#fd,#10,#27
db #29,#fc,#fe,#fd,#14,#2f,#2c,#2f
db #1b,#30,#30,#31,#fd,#22,#fe,#f8
db #2f,#fd,#28,#fd,#26,#02,#32,#2e
db #31,#32,#32,#33,#fd,#34,#2b,#71
db #2e,#fe,#32,#fe,#3b,#fd,#38,#34
db #30,#33,#fd,#a5,#9c,#fd,#46,#2e
db #30,#fe,#44,#fe,#4d,#fd,#4a,#37
db #33,#0e,#36,#37,#37,#38,#fd,#58
db #fa,#4a,#fe,#a2,#37,#47,#3a,#fe
db #a7,#3a,#3a,#3b,#fd,#6a,#fd,#62
db #fd,#70,#c7,#f4,#62,#fe,#43,#37
db #39,#36,#fc,#58,#fd,#88,#fe,#45
db #e0,#fe,#7a,#fe,#8f,#fd,#8c,#3c
db #39,#3c,#3d,#3d,#7c,#3e,#fd,#9a
db #fe,#76,#fe,#98,#fe,#a1,#fd,#9e
db #40,#3c,#c8,#fb,#aa,#fe,#ad,#3b
db #3d,#f9,#ac,#44,#40,#43,#18,#44
db #44,#45,#fd,#be,#fa,#b0,#3e,#40
db #44,#02,#46,#43,#46,#47,#47,#48
db #fd,#d0,#42,#40,#44,#f9,#d0,#4a
db #47,#4a,#4b,#4b,#4c,#90,#fd,#e2
db #46,#48,#f9,#e2,#4e,#4b,#4e,#4f
db #30,#4f,#50,#fd,#f4,#fa,#e6,#4a
db #4c,#50,#52,#07,#4f,#52,#53,#53
db #54,#fd,#06,#fd,#fe,#fd,#0c,#11
db #4f,#51,#55,#fd,#12,#53,#56,#5a
db #fd,#18,#11,#59,#5b,#5f,#fd,#1e
db #5e,#60,#64,#fd,#24,#00,#63,#65
db #69,#69,#6c,#70,#70,#72,#00,#76
db #78,#7a,#7e,#7e,#80,#84,#86,#00
db #88,#8c,#8d,#8f,#93,#95,#98,#9c
db #02,#cd,#15,#5d,#ed,#c6,#3c,#d6
db #45,#10,#aa,#f5,#70,#0f,#fb,#7c
db #0e,#fb,#82,#0d,#fb,#88,#0c,#af
db #f5,#8e,#0b,#fb,#9a,#0a,#a1,#a0
db #00,#40,#00,#40,#ed,#70,#88,#d3
db #10,#5a,#2d,#16,#f1,#40,#55,#2a
db #15,#8c,#f1,#4c,#64,#32,#19,#f1
db #5e,#f4,#73,#71,#38,#63,#1c,#fa
db #7f,#f7,#88,#5f,#2f,#18,#fa,#91
db #fd,#9a,#fe,#fd,#85,#fa,#9d,#f1
db #49,#fd,#b2,#f7,#b8,#f4,#58,#e2
db #70,#87,#3f,#43,#21,#fa,#eb,#fd
db #f4,#fd,#6d,#fd,#f7,#00,#40,#00
db #40,#f9,#00,#40,#00,#40,#00,#40
db #de,#40,#e2,#1f,#43,#87,#fe,#7d
db #88,#fe,#41,#3c,#79,#79,#fd,#43
db #2d,#5a,#5a,#8f,#fd,#46,#1e,#3c
db #3c,#fd,#4c,#fd,#49,#fd,#52,#5e
db #46,#11,#38,#71,#71,#fd,#00,#32
db #64,#64,#fd,#03,#11,#25,#4b,#4b
db #fd,#06,#19,#32,#32,#fd,#0c,#e0
db #fd,#09,#fd,#12,#be,#06,#3f,#7f
db #7f,#1c,#38,#e3,#fe,#64,#fe,#52
db #fd,#60,#2a,#55,#55,#fd,#66,#fd
db #63,#ff,#fd,#6c,#b8,#60,#fd,#f1
db #fd,#c0,#d6,#d6,#70,#d8,#fd,#b7
db #fd,#80,#11,#32,#64,#64,#fd,#83
db #25,#4b,#4b,#fd,#86,#1e,#19,#32
db #32,#fd,#8c,#fd,#89,#fd,#92,#be
db #86,#3f,#0e,#7f,#7f,#1c,#38,#fe
db #e4,#fe,#d2,#fd,#e0,#2a,#3c,#55
db #55,#fd,#e6,#fd,#e3,#fd,#ec,#b8
db #e0,#5a,#b3,#01,#b3,#50,#a0,#a0
db #4b,#97,#97,#fd,#77,#8c,#fd,#7d
db #28,#50,#50,#fd,#dd,#fd,#7a,#16
db #2d,#00,#2d,#14,#28,#28,#13,#25
db #25,#0f,#00,#1e,#1e,#0b,#16,#16
db #0a,#14,#14,#00,#09,#13,#13,#08
db #0f,#0f,#08,#0b,#7f,#0b,#fd,#6d
db #fd,#6a,#fd,#67,#fd,#64,#fd,#61
db #fd,#5e,#fd,#5b,#ff,#fd,#58,#fd
db #55,#fd,#52,#fd,#4f,#fd,#4c,#fd
db #49,#fd,#46,#fd,#43,#ff,#fd,#40
db #fd,#9a,#fd,#37,#fd,#d7,#fd,#94
db #fd,#8e,#fd,#3a,#fd,#da,#c0,#fd
db #88,#fd,#82,#0e,#1c,#1c,#0c,#19
db #19,#cf,#fd,#7c,#fc,#6a,#0e,#0e
db #fd,#c7,#fd,#c4,#fd,#c1,#fd,#be
db #ff,#fd,#bb,#fd,#b8,#fd,#b5,#fd
db #b2,#fd,#af,#fd,#ac,#fd,#a9,#fd
db #a6,#c0,#fd,#a3,#fd,#a0,#64,#c9
db #c9,#71,#e2,#e2,#75,#97,#fe,#dd
db #40,#40,#fe,#b5,#b3,#fe,#5e,#a0
db #fe,#b2,#55,#97,#fe,#58,#79,#fe
db #a9,#5a,#fe,#52,#50,#fe,#a6,#55
db #4b,#fe,#4c,#3c,#fe,#be,#2d,#fe
db #46,#28,#fe,#9a,#55,#25,#fe,#40
db #1e,#fe,#91,#16,#fe,#3a,#14,#fe
db #8e,#57,#13,#fe,#34,#0f,#fe,#31
db #0b,#fd,#ed,#fd,#ea,#fd,#e7,#ff
db #fd,#e4,#fd,#e1,#fd,#de,#fd,#db
db #fd,#d8,#fd,#d5,#fd,#d2,#fd,#cf
db #fe,#fd,#cc,#fd,#c9,#fd,#c6,#fd
db #c3,#fd,#c0,#fd,#1a,#fe,#af,#71
db #ba,#fe,#ac,#64,#fd,#14,#fd,#0e
db #fe,#a3,#38,#fe,#a0,#32,#eb,#fd
db #08,#fd,#02,#fe,#97,#1c,#fe,#94
db #19,#fd,#fc,#fd,#f6,#bf,#fe,#8b
db #0e,#fd,#47,#fd,#44,#fd,#41,#fd
db #3e,#fd,#3b,#fd,#38,#ff,#fd,#35
db #fd,#32,#fd,#2f,#fd,#2c,#fd,#29
db #fd,#26,#fd,#23,#fd,#20,#ad,#fe
db #b8,#c9,#fe,#bb,#e2,#fd,#5c,#fd
db #71,#87,#fe,#83,#75,#7f,#fe,#86
db #fd,#6b,#fd,#65,#43,#fe,#8f,#3f
db #fe,#92,#d7,#fd,#5f,#fd,#59,#21
db #fe,#9b,#20,#fe,#9e,#fd,#53,#fd
db #4d,#57,#10,#fb,#a7,#0c,#fe,#ad
db #09,#fe,#b0,#fd,#ad,#fa,#a7,#ff
db #fd,#a4,#fd,#a1,#fd,#9e,#fd,#9b
db #fd,#98,#fd,#95,#fd,#92,#fd,#8f
db #fd,#fd,#8c,#fd,#89,#fd,#86,#fd
db #83,#fd,#80,#fd,#da,#5f,#fe,#e6
db #75,#55,#fe,#e9,#fd,#d4,#fd,#ce
db #2f,#fe,#f2,#2a,#fe,#f5,#d7,#fd
db #c8,#fd,#c2,#18,#fe,#fe,#15,#fe
db #01,#fa,#a4,#fa,#b3,#ff,#fd,#04
db #fd,#01,#fd,#fe,#fd,#fb,#fd,#f8
db #fd,#f5,#fd,#f2,#fd,#ef,#fa,#fd
db #ec,#fd,#e9,#fd,#e6,#fd,#e3,#fd
db #e0,#a9,#fe,#37,#be,#b6,#fe,#3a
db #fe,#fe,#3d,#fd,#74,#a0,#fe,#43
db #fd,#34,#79,#db,#fe,#49,#fd,#68
db #50,#fe,#4f,#fd,#28,#3c,#fe,#55
db #fd,#7d,#6a,#28,#fe,#5b,#fd,#1c
db #1e,#fe,#61,#16,#fe,#64,#14,#d7
db #fe,#67,#fd,#10,#0f,#fe,#6d,#0b
db #fe,#70,#fd,#6d,#fd,#6a,#ff,#fd
db #67,#fd,#64,#fd,#61,#fd,#5e,#fd
db #5b,#fd,#58,#fd,#55,#fd,#52,#fe
db #fd,#4f,#fd,#4c,#fd,#49,#fd,#46
db #fd,#43,#fd,#40,#fd,#9a,#71,#f7
db #fe,#a6,#fd,#d7,#fd,#94,#fd,#8e
db #38,#fe,#b2,#fd,#cb,#fd,#88,#ae
db #fd,#82,#1c,#fe,#be,#19,#fe,#c1
db #fd,#7c,#fd,#76,#0e,#ff,#fe,#ca
db #fd,#c7,#fd,#c4,#fd,#c1,#fd,#be
db #fd,#bb,#fd,#b8,#fd,#b5,#fe,#fd
db #b2,#fd,#af,#fd,#ac,#fd,#a9,#fd
db #a6,#fd,#a3,#fd,#a0,#c9,#bb,#fe
db #f7,#e2,#fe,#fa,#fd,#dc,#fd,#f1
db #87,#fe,#03,#fd,#31,#de,#fd,#eb
db #fd,#e5,#43,#fe,#0f,#fd,#25,#fd
db #df,#fd,#d9,#21,#ba,#fe,#1b,#20
db #fe,#1e,#fd,#d3,#fd,#cd,#10,#fb
db #27,#0c,#bf,#fe,#2d,#09,#fe,#30
db #fd,#2d,#fa,#27,#fd,#24,#fd,#21
db #fd,#1e,#ff,#fd,#1b,#fd,#18,#fd
db #15,#fd,#12,#fd,#0f,#fd,#0c,#fd
db #09,#fd,#06,#eb,#fd,#03,#fd,#00
db #fd,#5a,#5f,#fe,#66,#55,#fe,#69
db #fd,#54,#ae,#fd,#4e,#2f,#fe,#72
db #2a,#fe,#75,#fd,#48,#fd,#42,#18
db #bf,#fe,#7e,#15,#fe,#81,#fa,#24
db #fa,#33,#fd,#84,#fd,#81,#fd,#7e
db #ff,#fd,#7b,#fd,#78,#fd,#75,#fd
db #72,#fd,#6f,#fd,#6c,#fd,#69,#fd
db #66,#d5,#fd,#63,#fd,#60,#a9,#fe
db #b7,#be,#fe,#ba,#fe,#fe,#bd,#02
db #67,#b3,#5a,#40,#a0,#50,#fe,#ff
db #4b,#15,#f1,#79,#3c,#fe,#c1,#2d
db #fe,#c4,#28,#fe,#c7,#55,#25,#fe
db #ca,#1e,#fe,#cd,#16,#fe,#d0,#14
db #fe,#d3,#55,#13,#fe,#d6,#0f,#fe
db #d9,#0b,#fe,#dc,#0a,#fe,#df,#57
db #09,#fe,#e2,#08,#fe,#e5,#08,#fd
db #ed,#fd,#ea,#fd,#e7,#ff,#fd,#e4
db #fd,#e1,#fd,#de,#fd,#db,#fd,#d8
db #fd,#d5,#fd,#d2,#fd,#cf,#fc,#fd
db #cc,#fd,#c9,#fd,#c6,#fd,#c3,#fd
db #c0,#fd,#1a,#e2,#71,#0a,#38,#c9
db #64,#32,#fb,#21,#25,#fe,#27,#1c
db #ba,#fe,#2a,#19,#fd,#08,#fd,#02
db #fe,#33,#0e,#fe,#36,#0c,#ff,#fd
db #fc,#fd,#f6,#fe,#3f,#fc,#f5,#fd
db #44,#fd,#41,#fd,#3e,#fd,#3b,#ff
db #fd,#38,#fd,#35,#fd,#32,#fd,#2f
db #fd,#2c,#fd,#29,#fd,#26,#fd,#2e
db #af,#fd,#20,#93,#fe,#6b,#c3,#fe
db #6e,#fd,#2d,#00,#c0,#80,#c0,#bb
db #fe,#d7,#87,#fd,#fa,#fd,#f4,#fe
db #01,#43,#f7,#a6,#fe,#0a,#6d,#21
db #f7,#b2,#fe,#16,#10,#f7,#be,#fe
db #22,#08,#fd,#ca,#ff,#fd,#2d,#f7
db #76,#fd,#24,#fd,#7f,#fd,#21,#fa
db #d9,#fd,#18,#fd,#15,#e8,#fa,#e5
db #fd,#0c,#fd,#97,#e3,#fe,#5d,#ab
db #d6,#6b,#1d,#7c,#be,#5f,#fd,#9d
db #fd,#5d,#fe,#64,#35,#fe,#67,#75
db #2f,#fd,#91,#fd,#8b,#fe,#70,#1b
db #fe,#73,#18,#fd,#85,#d6,#fd,#42
db #fe,#7c,#0d,#fe,#7f,#0c,#fd,#39
db #fe,#85,#08,#ff,#fd,#8d,#fd,#8a
db #fd,#87,#fd,#84,#fd,#81,#fd,#7e
db #fd,#7b,#fd,#78,#ff,#fd,#75,#fd
db #72,#fd,#6f,#fd,#6c,#fd,#69,#fd
db #66,#fd,#63,#f4,#bf,#8c,#fd,#4b
db #0b,#16,#2d,#fa,#cc,#fd,#a8,#0f
db #1e,#62,#3c,#dc,#d8,#fd,#1b,#0c
db #19,#32,#f4,#02,#55,#07,#2a,#15
db #0a,#15,#2a,#ee,#14,#d9,#cc,#fd
db #50,#ed,#fd,#32,#fd,#56,#fd,#4b
db #08,#fd,#4d,#fb,#5d,#b3,#fd,#59
db #ff,#fe,#31,#fa,#68,#fd,#53,#fd
db #6e,#fa,#32,#f4,#7f,#00,#cc,#00
db #cc,#81,#cc,#cc,#cd,#15,#5d,#ed
db #c6,#3c,#d6,#c5,#55,#10,#f5,#f0
db #0f,#fb,#fc,#0e,#fb,#02,#0d,#fb
db #08,#56,#0c,#f5,#0e,#0b,#fb,#1a
db #0a,#a1,#20,#40,#c0,#4b,#38,#3f
db #32,#00,#40,#00,#40,#30,#40,#27
db #4e,#44,#00,#39,#2e,#55,#4b,#40
db #34,#5c,#52,#00,#46,#3b,#63,#59
db #4d,#42,#69,#5f,#00,#54,#49,#70
db #66,#5b,#50,#77,#6d,#00,#62,#56
db #7e,#74,#68,#5d,#85,#7a,#00,#6f
db #64,#8b,#81,#76,#6b,#92,#86,#11
db #79,#6c,#21,#fe,#40,#20,#1f,#1e
db #fa,#45,#c0,#fa,#43,#fd,#4c,#1d
db #1c,#1b,#19,#18,#17,#eb,#fd,#5a
db #f9,#43,#fd,#55,#1a,#fd,#58,#15
db #fd,#6c,#fd,#64,#f8,#fd,#72,#f4
db #64,#fd,#77,#fd,#84,#fa,#55,#16
db #15,#14,#f1,#fd,#90,#fd,#79,#fd
db #96,#fa,#79,#14,#13,#12,#fd,#a2
db #c7,#fa,#58,#fa,#8b,#13,#11,#10
db #fd,#b4,#fa,#7c,#fa,#9d,#bd,#fe
db #b3,#0f,#fd,#c6,#fd,#bf,#fd,#cc
db #f8,#bf,#0e,#fd,#d8,#f3,#fd,#d1
db #fd,#de,#fb,#b0,#fe,#d7,#0d,#0c
db #fd,#ea,#fd,#e3,#d5,#fd,#f0,#f8
db #e3,#0b,#fd,#fc,#11,#fe,#e1,#15
db #fc,#b4,#e9,#fa,#07,#fc,#a2,#fc
db #0c,#0c,#fe,#fa,#0a,#08,#fd,#1a
db #e9,#fe,#c8,#fc,#f0,#fc,#1e,#0b
db #fe,#fb,#08,#07,#fd,#2c,#e0,#fa
db #1e,#fe,#da,#fe,#12,#0a,#0b,#0a
db #07,#06,#f3,#fd,#3e,#fc,#36,#fe
db #45,#f4,#36,#0d,#0d,#fc,#c6,#fc
db #54,#4f,#09,#fe,#19,#06,#05,#fd
db #62,#ee,#54,#fe,#ec,#fc,#d8,#9f
db #fc,#78,#08,#09,#fa,#72,#fe,#fe
db #fe,#6c,#fe,#8d,#fd,#8a,#00,#14
db #15,#1c,#22,#26,#2c,#33,#3a,#00
db #40,#3b,#38,#34,#31,#30,#2d,#31
db #00,#33,#32,#34,#34,#36,#39,#3b
db #3f,#00,#40,#40,#41,#41,#43,#46
db #48,#4c,#00,#4e,#4d,#4f,#4f,#51
db #54,#56,#5a,#00,#5b,#5b,#5c,#5c
db #5e,#1f,#20,#23,#17,#25,#22,#25
db #fa,#c5,#20,#fe,#96,#fd,#ce,#fd
db #cc,#03,#29,#25,#28,#29,#29,#2a
db #fd,#da,#fa,#cc,#80,#fe,#c4,#29
db #2b,#27,#2a,#2b,#2b,#2d,#f3,#fd
db #ec,#fd,#e4,#fd,#f2,#f4,#e4,#24
db #26,#fc,#da,#fd,#02,#14,#2d,#29
db #2c,#fe,#00,#2e,#fd,#10,#27,#29
db #c0,#fc,#fe,#fd,#14,#2f,#2c,#2f
db #30,#30,#31,#d8,#fd,#22,#fe,#f8
db #2f,#fd,#28,#fd,#26,#32,#2e,#31
db #13,#32,#32,#33,#fd,#34,#2b,#2e
db #fe,#32,#fe,#3b,#8c,#fd,#38,#34
db #30,#33,#fd,#a5,#fd,#46,#2e,#30
db #e0,#fe,#44,#fe,#4d,#fd,#4a,#37
db #33,#36,#37,#37,#72,#38,#fd,#58
db #fa,#4a,#fe,#a2,#37,#3a,#fe,#a7
db #3a,#3e,#3a,#3b,#fd,#6a,#fd,#62
db #fd,#70,#f4,#62,#fe,#43,#37,#3f
db #39,#36,#fc,#58,#fd,#88,#fe,#45
db #fe,#7a,#fe,#8f,#fd,#8c,#03,#3c
db #39,#3c,#3d,#3d,#3e,#fd,#9a,#fe
db #76,#e6,#fe,#98,#fe,#a1,#fd,#9e
db #40,#3c,#fb,#aa,#fe,#ad,#3b,#40
db #3d,#f9,#ac,#44,#40,#43,#44,#44
db #45,#c0,#fd,#be,#fa,#b0,#3e,#40
db #44,#46,#43,#46,#12,#47,#47,#48
db #fd,#d0,#42,#44,#f9,#d0,#4a,#04
db #47,#4a,#4b,#4b,#4c,#fd,#e2,#46
db #48,#81,#f9,#e2,#4e,#4b,#4e,#4f
db #4f,#50,#fd,#f4,#80,#fa,#e6,#4a
db #4c,#50,#52,#4f,#52,#53,#38,#53
db #54,#fd,#06,#fd,#fe,#fd,#0c,#4f
db #51,#55,#88,#fd,#12,#53,#56,#5a
db #fd,#18,#59,#5b,#5f,#88,#fd,#1e
db #5e,#60,#64,#fd,#24,#63,#65,#69
db #00,#69,#6c,#70,#70,#72,#76,#78
db #7a,#00,#7e,#7e,#80,#84,#86,#88
db #8c,#8d,#00,#8f,#93,#95,#98,#9c
db #43,#87,#87,#8b,#fd,#40,#3c,#79
db #79,#fd,#43,#2d,#fe,#1a,#fd,#46
db #1e,#1e,#3c,#3c,#fd,#4c,#fd,#49
db #fd,#52,#5e,#46,#38,#2c,#71,#71
db #fd,#00,#32,#fe,#26,#fd,#03,#25
db #4b,#47,#4b,#fd,#06,#19,#32,#32
db #fd,#0c,#fd,#09,#fd,#12,#83,#be
db #06,#3f,#7f,#7f,#1c,#38,#fe,#64
db #fe,#52,#8f,#fd,#60,#2a,#55,#55
db #fd,#66,#fd,#63,#fd,#6c,#b8,#60
db #fc,#fd,#f1,#fd,#c0,#d6,#d6,#70
db #d8,#fd,#b7,#fd,#80,#32,#64,#44
db #64,#fd,#83,#25,#4b,#4b,#fd,#86
db #19,#32,#78,#32,#fd,#8c,#fd,#89
db #fd,#92,#be,#86,#3f,#7f,#7f,#38
db #1c,#38,#fe,#e4,#fe,#d2,#fd,#e0
db #2a,#55,#55,#f0,#fd,#e6,#fd,#e3
db #fd,#ec,#b8,#e0,#5a,#b3,#b3,#50
db #06,#a0,#a0,#4b,#97,#97,#fd,#77
db #fd,#7d,#28,#30,#50,#50,#fd,#dd
db #fd,#7a,#16,#2d,#2d,#14,#00,#28
db #28,#13,#25,#25,#0f,#1e,#1e,#00
db #0b,#16,#16,#0a,#14,#14,#09,#13
db #01,#13,#08,#0f,#0f,#08,#0b,#0b
db #fd,#6d,#ff,#fd,#6a,#fd,#67,#fd
db #64,#fd,#61,#fd,#5e,#fd,#5b,#fd
db #58,#fd,#55,#ff,#fd,#52,#fd,#4f
db #fd,#4c,#fd,#49,#fd,#46,#fd,#43
db #fd,#40,#fd,#9a,#ff,#fd,#37,#fd
db #d7,#fd,#94,#fd,#8e,#fd,#3a,#fd
db #da,#fd,#88,#fd,#82,#03,#0e,#1c
db #1c,#0c,#19,#19,#fd,#7c,#fc,#6a
db #3f,#0e,#0e,#fd,#c7,#fd,#c4,#fd
db #c1,#fd,#be,#fd,#bb,#fd,#b8,#ff
db #fd,#b5,#fd,#b2,#fd,#af,#fd,#ac
db #fd,#a9,#fd,#a6,#fd,#a3,#fd,#a0
db #01,#64,#c9,#c9,#71,#e2,#e2,#97
db #fe,#dd,#e0,#00,#40,#00,#40,#c0
db #40,#67,#b3,#5a,#40,#a0,#82,#fe
db #d3,#97,#4b,#f1,#79,#3c,#fe,#41
db #2d,#aa,#fe,#44,#28,#fe,#47,#25
db #fe,#4a,#1e,#fe,#4d,#16,#aa,#fe
db #50,#14,#fe,#53,#13,#fe,#56,#0f
db #fe,#59,#0b,#aa,#fe,#5c,#0a,#fe
db #5f,#09,#fe,#62,#08,#fe,#65,#08
db #ff,#fd,#6d,#fd,#6a,#fd,#67,#fd
db #64,#fd,#61,#fd,#5e,#fd,#5b,#fd
db #58,#ff,#fd,#55,#fd,#52,#fd,#4f
db #fd,#4c,#fd,#49,#fd,#46,#fd,#43
db #fd,#40,#81,#fd,#9a,#e2,#71,#38
db #c9,#64,#32,#fb,#a1,#57,#25,#fe
db #a7,#1c,#fe,#aa,#19,#fd,#88,#fd
db #82,#fe,#b3,#5f,#0e,#fe,#b6,#0c
db #fd,#7c,#fd,#76,#fe,#bf,#fc,#75
db #fd,#c4,#ff,#fd,#c1,#fd,#be,#fd
db #bb,#fd,#b8,#fd,#b5,#fd,#b2,#fd
db #af,#fd,#ac,#f5,#fd,#a9,#fd,#a6
db #fd,#ae,#fd,#a0,#93,#fe,#eb,#c3
db #fe,#ee,#f7,#fd,#ad,#00,#40,#80
db #40,#fe,#57,#87,#fd,#7a,#fd,#74
db #fe,#81,#6d,#43,#f7,#26,#fe,#8a
db #21,#f7,#32,#fe,#96,#10,#f7,#3e
db #bf,#fe,#a2,#08,#fd,#4a,#fd,#ad
db #f7,#f6,#fd,#a4,#fd,#ff,#fd,#a1
db #fd,#fa,#59,#fd,#98,#fd,#95,#fa
db #65,#fd,#8c,#fd,#17,#e3,#fe,#dd
db #03,#ab,#d6,#6b,#7c,#be,#5f,#fd
db #1d,#fd,#dd,#ae,#fe,#e4,#35,#fe
db #e7,#2f,#fd,#11,#fd,#0b,#fe,#f0
db #1b,#ba,#fe,#f3,#18,#fd,#05,#fd
db #c2,#fe,#fc,#0d,#fe,#ff,#0c,#df
db #fd,#b9,#fe,#05,#08,#fd,#0d,#fd
db #0a,#fd,#07,#fd,#04,#fd,#01,#ff
db #fd,#fe,#fd,#fb,#fd,#f8,#fd,#f5
db #fd,#f2,#fd,#ef,#fd,#ec,#fd,#e9
db #d5,#fd,#e6,#fd,#e3,#b3,#fe,#40
db #a0,#fe,#43,#97,#fe,#46,#55,#79
db #fe,#49,#5a,#fe,#4c,#50,#fe,#4f
db #4b,#fe,#52,#55,#3c,#fe,#55,#2d
db #fe,#58,#28,#fe,#5b,#25,#fe,#5e
db #55,#1e,#fe,#61,#16,#fe,#64,#14
db #fe,#67,#13,#fe,#6a,#5f,#0f,#fe
db #6d,#0b,#fe,#70,#fd,#6d,#fd,#6a
db #fd,#67,#fd,#64,#ff,#fd,#61,#fd
db #5e,#fd,#5b,#fd,#58,#fd,#55,#fd
db #52,#fd,#4f,#fd,#4c,#fa,#fd,#49
db #fd,#46,#fd,#43,#fd,#40,#fd,#9a
db #71,#fe,#a6,#64,#eb,#fe,#a9,#fd
db #94,#fd,#8e,#38,#fe,#b2,#32,#fe
db #b5,#fd,#88,#ae,#fd,#82,#1c,#fe
db #be,#19,#fe,#c1,#fd,#7c,#fd,#76
db #0e,#ff,#fe,#ca,#fd,#c7,#fd,#c4
db #fd,#c1,#fd,#be,#fd,#bb,#fd,#b8
db #fd,#b5,#fe,#fd,#b2,#fd,#af,#fd
db #ac,#fd,#a9,#fd,#a6,#fd,#a3,#fd
db #a0,#c9,#ba,#fe,#f7,#e2,#fe,#fa
db #fd,#dc,#fd,#f1,#87,#fe,#03,#7f
db #eb,#fe,#06,#fd,#eb,#fd,#e5,#43
db #fe,#0f,#3f,#fe,#12,#fd,#df,#ae
db #fd,#d9,#21,#fe,#1b,#20,#fe,#1e
db #fd,#d3,#fd,#cd,#10,#af,#fb,#27
db #0c,#fe,#2d,#09,#fe,#30,#fd,#2d
db #fa,#27,#fd,#24,#ff,#fd,#21,#fd
db #1e,#fd,#1b,#fd,#18,#fd,#15,#fd
db #12,#fd,#0f,#fd,#0c,#fa,#fd,#09
db #fd,#06,#fd,#03,#fd,#00,#fd,#5a
db #5f,#fe,#66,#55,#eb,#fe,#69,#fd
db #54,#fd,#4e,#2f,#fe,#72,#2a,#fe
db #75,#fd,#48,#af,#fd,#42,#18,#fe
db #7e,#15,#fe,#81,#fa,#24,#fa,#33
db #fd,#84,#ff,#fd,#81,#fd,#7e,#fd
db #7b,#fd,#78,#fd,#75,#fd,#72,#fd
db #6f,#fd,#6c,#f5,#fd,#69,#fd,#66
db #fd,#63,#fd,#60,#a9,#fe,#b7,#be
db #fe,#ba,#6d,#fe,#fe,#bd,#fd,#f4
db #a0,#fe,#c3,#fd,#b4,#79,#fe,#c9
db #b6,#fd,#e8,#50,#fe,#cf,#fd,#a8
db #3c,#fe,#d5,#fd,#fd,#28,#d5,#fe
db #db,#fd,#9c,#1e,#fe,#e1,#16,#fe
db #e4,#14,#fe,#e7,#af,#fd,#90,#0f
db #fe,#ed,#0b,#fe,#f0,#fd,#ed,#fd
db #ea,#fd,#e7,#ff,#fd,#e4,#fd,#e1
db #fd,#de,#fd,#db,#fd,#d8,#fd,#d5
db #fd,#d2,#fd,#cf,#fd,#fd,#cc,#fd
db #c9,#fd,#c6,#fd,#c3,#fd,#c0,#fd
db #1a,#71,#fe,#26,#ef,#fd,#57,#fd
db #14,#fd,#0e,#38,#fe,#32,#fd,#4b
db #fd,#08,#fd,#02,#5d,#1c,#fe,#3e
db #19,#fe,#41,#fd,#fc,#fd,#f6,#0e
db #fe,#4a,#ff,#fd,#47,#fd,#44,#fd
db #41,#fd,#3e,#fd,#3b,#fd,#38,#fd
db #35,#fd,#32,#fd,#fd,#2f,#fd,#2c
db #fd,#29,#fd,#26,#fd,#23,#fd,#20
db #c9,#fe,#77,#77,#e2,#fe,#7a,#fd
db #5c,#fd,#71,#87,#fe,#83,#fd,#b1
db #fd,#6b,#bd,#fd,#65,#43,#fe,#8f
db #fd,#a5,#fd,#5f,#fd,#59,#21,#fe
db #9b,#75,#20,#fe,#9e,#fd,#53,#fd
db #4d,#10,#fb,#a7,#0c,#fe,#ad,#7f
db #09,#fe,#b0,#fd,#ad,#fa,#a7,#fd
db #a4,#fd,#a1,#fd,#9e,#fd,#9b,#ff
db #fd,#98,#fd,#95,#fd,#92,#fd,#8f
db #fd,#8c,#fd,#89,#fd,#86,#fd,#83
db #d7,#fd,#80,#fd,#da,#5f,#fe,#e6
db #55,#fe,#e9,#fd,#d4,#fd,#ce,#5d
db #2f,#fe,#f2,#2a,#fe,#f5,#fd,#c8
db #fd,#c2,#18,#fe,#fe,#7f,#15,#fe
db #01,#fa,#a4,#fa,#b3,#fd,#04,#fd
db #01,#fd,#fe,#fd,#fb,#ff,#fd,#f8
db #fd,#f5,#fd,#f2,#fd,#ef,#fd,#ec
db #fd,#e9,#fd,#e6,#fd,#e3,#aa,#fd
db #e0,#a9,#fe,#37,#be,#fe,#3a,#fe
db #fe,#3d,#0f,#43,#0f,#fe,#0b,#0a
db #0a,#08,#08,#c0,#40,#88,#87,#00
db #ef,#00,#00,#00,#00,#f0,#00,#01
db #fe,#11,#d3,#08,#52,#64,#f8,#e9
db #ff,#f7,#ee,#00,#40,#00,#40,#00
db #ff,#00,#ff,#00,#ff,#00,#ff,#00
db #ff,#ff,#00,#ff,#00,#ff,#00,#ff
db #00,#ff,#00,#ff,#00,#ff,#00,#ff
db #bf,#ff,#5f,#01,#fe,#41,#02,#00
db #85,#00,#85,#34,#85,#fe,#82,#d2
db #10,#ff,#00,#40,#00,#40,#00,#40
db #00,#40,#00,#40,#00,#40,#00,#40
db #00,#40,#cf,#00,#40,#43,#40,#01
db #01,#00,#40,#81,#41,#42,#bf,#40
db #3c,#7e,#01,#fe,#fd,#3f,#3d,#f8
db #be,#a6,#6f,#b2,#c6,#f4,#1a,#02
db #ff,#fe,#7a,#00,#c0,#80,#c0,#a3
db #3d,#9d,#97,#00,#bf,#00,#bf,#00
db #bf,#2f,#00,#01,#fe,#c1,#02,#00
db #05,#00,#c4,#00,#c4,#00,#c4,#ff
db #00,#c4,#00,#c4,#00,#c4,#00,#c4
db #00,#c4,#00,#c4,#00,#c4,#c7,#c4
db #3f,#01,#01,#00,#40,#00,#40,#c0
db #40,#fd,#7f,#fa,#40,#ae,#ed,#df
db #f5,#98,#a9,#4f,#02,#fe,#fa,#00
db #40,#80,#40,#a3,#bd,#9d,#17,#bb
db #43,#3f,#01,#fe,#fd,#41,#3e,#42
db #be,#01,#fe,#7d,#03,#80,#80,#7d
db #7c,#00,#c4,#00,#00,#00,#81,#00
db #01,#3c,#79,#79,#fd,#80,#01,#5a
db #b3,#47,#b3,#fd,#83,#01,#4b,#97
db #97,#fd,#86,#01,#fd,#8f,#01,#fd
db #8c,#01,#c0,#fa,#83,#01,#be,#86
db #01,#43,#87,#87,#64,#c9,#c9,#c7
db #fd,#e3,#01,#fd,#e0,#01,#55,#a9
db #a9,#fa,#e3,#01,#fd,#ec,#01,#b8
db #e0,#01,#80,#70,#3f,#02,#cd,#52
db #6b,#dc,#28,#28,#1e,#00,#1e,#3c
db #3c,#2d,#2d,#c9,#4e,#68,#00,#da
db #25,#25,#1c,#1c,#38,#38,#2a,#40
db #2a,#f4,#d0,#02,#d3,#59,#70,#e2
db #2d,#2d,#03,#21,#21,#43,#43,#32
db #32,#ec,#f8,#02,#84,#13,#03,#c0
db #00,#d0,#02,#b0,#d0,#03,#57,#59
db #5b,#5c,#58,#5a,#00,#5a,#59,#59
db #5a,#5b,#5b,#5a,#5a,#4e,#58,#fd
db #e4,#00,#5c,#5c,#b4,#ec,#00,#a0
db #e0,#00,#d0,#98,#01,#62,#30,#63
db #66,#fd,#40,#01,#fd,#d0,#01,#67
db #63,#64,#64,#00,#63,#63,#64,#66
db #66,#6f,#70,#72,#00,#74,#6f,#71
db #71,#70,#70,#71,#72,#08,#72,#71
db #71,#6f,#fd,#e6,#01,#76,#78,#7a
db #00,#7b,#77,#79,#7b,#7d,#80,#84
db #88,#00,#8b,#b1,#b2,#b5,#b6,#b2
db #b3,#b3,#04,#b2,#b2,#b3,#b5,#b5
db #fb,#05,#02,#b3,#b6,#40,#b6,#84
db #0c,#02,#b5,#b7,#bb,#bc,#bc,#bd
db #00,#bd,#bf,#c3,#c4,#c8,#ca,#c9
db #cb,#00,#cb,#cd,#d0,#d2,#d6,#d7
db #d7,#d9,#00,#d9,#da,#de,#df,#e3
db #e5,#e4,#e6,#00,#e6,#e8,#eb,#ed
db #f1,#f2,#f2,#f4,#00,#f4,#f5,#f9
db #fa,#fd,#fd,#fa,#fa,#20,#f9,#f9
db #40,#40,#01,#52,#53,#56,#57,#53
db #01,#55,#55,#53,#53,#55,#56,#56
db #fb,#85,#03,#10,#55,#57,#57,#84
db #8c,#03,#56,#58,#5c,#5e,#00,#5d
db #5f,#5f,#60,#64,#65,#69,#6b,#00
db #6b,#6c,#6c,#6e,#71,#73,#77,#79
db #00,#78,#7a,#7a,#7b,#7f,#81,#85
db #86,#00,#86,#87,#87,#89,#8c,#8e
db #92,#94,#00,#93,#95,#95,#97,#9a
db #9c,#9e,#9e,#0c,#9c,#9c,#9a,#9a
db #40,#c0,#02,#fa,#f4,#00,#79,#78
db #01,#78,#79,#7a,#7a,#79,#79,#77
db #fd,#04,#01,#20,#7b,#7b,#84,#0c
db #01,#7a,#7c,#80,#82,#81,#00,#83
db #83,#85,#88,#8a,#8e,#8f,#8f,#01
db #90,#90,#92,#95,#97,#9b,#9d,#fd
db #39,#00,#00,#a0,#a3,#a5,#a9,#aa
db #aa,#ab,#ab,#00,#ad,#b0,#b2,#b6
db #b8,#b7,#b9,#b9,#00,#bb,#be,#c0
db #c2,#c2,#c0,#c0,#be,#40,#be,#40
db #40,#00,#45,#46,#49,#4a,#45,#47
db #00,#47,#46,#46,#47,#49,#49,#47
db #47,#60,#45,#fd,#84,#02,#82,#8a
db #02,#49,#4a,#4e,#50,#50,#20,#51
db #51,#dd,#0f,#00,#90,#90,#8e,#8e
db #8c,#08,#8c,#32,#64,#21,#fd,#40
db #03,#4b,#97,#32,#8f,#fd,#43,#03
db #3f,#7f,#2a,#fd,#46,#03,#fd,#4f
db #03,#fd,#4c,#03,#fa,#43,#03,#81
db #be,#46,#03,#38,#71,#25,#55,#a9
db #38,#fd,#a3,#03,#8f,#fd,#a0,#03
db #47,#8e,#2f,#fa,#a3,#03,#fd,#ac
db #03,#b8,#a0,#03,#00,#40,#03,#c2
db #00,#40,#00,#ed,#e8,#01,#72,#74
db #3d,#78,#fd,#79,#02,#7e,#00,#80
db #82,#83,#85,#87,#88,#8a,#8c,#00
db #8e,#8f,#91,#93,#94,#96,#98,#99
db #00,#9b,#9d,#9e,#a0,#a2,#a4,#a5
db #a7,#00,#a9,#aa,#ac,#ae,#af,#b1
db #b3,#b4,#22,#b6,#b8,#fd,#3c,#02
db #64,#32,#19,#fd,#40,#02,#97,#23
db #4b,#25,#fd,#43,#02,#7f,#3f,#20
db #fd,#46,#02,#fd,#4f,#02,#e0,#fd
db #4c,#02,#fa,#43,#02,#be,#46,#02
db #71,#38,#1c,#a9,#55,#63,#2a,#fd
db #a3,#02,#fd,#a0,#02,#8e,#47,#24
db #fa,#a3,#02,#fd,#ac,#02,#f0,#b8
db #a0,#02,#00,#40,#02,#00,#40,#03
db #ea,#e8,#00,#15,#2a,#55,#a9,#44
db #52,#db,#13,#01,#87,#43,#21,#fd
db #40,#01,#79,#3c,#44,#1e,#fd,#43
db #01,#5a,#2d,#16,#fd,#46,#01,#3c
db #1e,#7c,#0f,#fd,#4c,#01,#fd,#49
db #01,#fd,#52,#01,#5d,#46,#01,#fb
db #00,#02,#79,#79,#44,#79,#fd,#03
db #02,#5a,#5a,#5a,#fd,#06,#02,#3c
db #3c,#7e,#3c,#fd,#0c,#02,#fd,#09
db #02,#fd,#12,#02,#5b,#06,#02,#00
db #03,#02,#83,#ab,#03,#57,#00,#59
db #5b,#5c,#58,#5a,#5a,#59,#59,#02
db #5a,#5b,#5b,#5a,#5a,#58,#fd,#44
db #00,#5c,#46,#5c,#84,#4c,#00,#62
db #63,#66,#fd,#40,#00,#fd,#d0,#00
db #67,#00,#63,#64,#64,#63,#63,#64
db #66,#66,#00,#6f,#70,#72,#74,#6f
db #71,#71,#70,#01,#70,#71,#72,#72
db #71,#71,#6f,#fd,#e6,#00,#00,#76
db #78,#7a,#7b,#77,#79,#7b,#7d,#00
db #80,#84,#88,#8b,#b1,#b2,#b5,#b6
db #00,#b2,#b3,#b3,#b2,#b2,#b3,#b5
db #b5,#88,#fb,#05,#01,#b3,#b6,#b6
db #84,#0c,#01,#b5,#b7,#bb,#00,#bc
db #bc,#bd,#bd,#bf,#c3,#c4,#c8,#00
db #ca,#c9,#cb,#cb,#cd,#d0,#d2,#d6
db #00,#d7,#d7,#d9,#d9,#da,#de,#df
db #e3,#00,#e5,#e4,#e6,#e6,#e8,#eb
db #ed,#f1,#00,#f2,#f2,#f4,#f4,#f5
db #f9,#fa,#fd,#04,#fd,#fa,#fa,#f9
db #f9,#40,#40,#00,#52,#53,#00,#56
db #57,#53,#55,#55,#53,#53,#55,#22
db #56,#56,#fb,#85,#02,#55,#57,#57
db #84,#8c,#02,#56,#00,#58,#5c,#5e
db #5d,#5f,#5f,#60,#64,#00,#65,#69
db #6b,#6b,#6c,#6c,#6e,#71,#00,#73
db #77,#79,#78,#7a,#7a,#7b,#7f,#00
db #81,#85,#86,#86,#87,#87,#89,#8c
db #00,#8e,#92,#94,#93,#95,#95,#97
db #9a,#01,#9c,#9e,#9e,#9c,#9c,#9a
db #9a,#40,#c0,#01,#80,#fa,#f4,#03
db #79,#78,#78,#79,#7a,#7a,#79,#24
db #79,#77,#fd,#04,#00,#7b,#7b,#84
db #0c,#00,#7a,#7c,#00,#80,#82,#81
db #83,#83,#85,#88,#8a,#00,#8e,#8f
db #8f,#90,#90,#92,#95,#97,#20,#9b
db #9d,#fd,#39,#03,#a0,#a3,#a5,#a9
db #aa,#00,#aa,#ab,#ab,#ad,#b0,#b2
db #b6,#b8,#00,#b7,#b9,#b9,#bb,#be
db #c0,#c2,#c2,#08,#c0,#c0,#be,#be
db #40,#40,#03,#45,#46,#49,#00,#4a
db #45,#47,#47,#46,#46,#47,#49,#0c
db #49,#47,#47,#45,#fd,#84,#01,#82
db #8a,#01,#49,#4a,#04,#4e,#50,#50
db #51,#51,#dd,#0f,#03,#90,#90,#00
db #8e,#8e,#8c,#8c,#ea,#42,#54,#ba
db #22,#16,#2d,#fa,#40,#02,#5a,#b3
db #5a,#e2,#46,#02,#09,#00,#5a,#5a
db #2a,#2b,#2e,#2e,#27,#27,#00,#26
db #26,#27,#26,#20,#20,#24,#24,#40
db #25,#fd,#7e,#02,#21,#21,#22,#21
db #1b,#1b,#00,#20,#1f,#20,#20,#19
db #19,#1d,#1d,#00,#1e,#1d,#17,#17
db #1c,#1b,#1c,#1c,#00,#15,#15,#1a
db #19,#1b,#1c,#17,#19,#c0,#d3,#40
db #02,#fd,#c4,#02,#14,#15,#18,#17
db #11,#11,#00,#11,#10,#11,#11,#0b
db #0b,#10,#0f,#00,#10,#10,#0a,#0a
db #0f,#0e,#0f,#0f,#00,#08,#08,#0e
db #0d,#0e,#0e,#07,#07,#00,#0c,#0c
db #0d,#0c,#06,#06,#0c,#0b,#40,#0c
db #fd,#f1,#02,#0b,#0a,#0b,#0c,#08
db #0a,#02,#db,#3b,#51,#b8,#13,#25
db #fa,#00,#03,#4b,#22,#97,#4b,#e2
db #06,#03,#fa,#4b,#4b,#fd,#70,#02
db #2d,#00,#26,#26,#2b,#2a,#2a,#29
db #22,#22,#20,#2e,#2d,#fc,#3d,#03
db #30,#2f,#30,#2f,#28,#00,#27,#34
db #33,#33,#32,#2b,#2b,#38,#00,#37
db #37,#36,#2f,#2f,#3b,#3a,#3a,#00
db #39,#32,#32,#3f,#3d,#3e,#3f,#3b
db #01,#3c,#e5,#40,#53,#ba,#15,#2a
db #fa,#60,#03,#18,#55,#a9,#55,#df
db #66,#03,#fd,#d0,#02,#16,#0f,#0e
db #00,#13,#11,#11,#0f,#08,#07,#14
db #12,#00,#12,#10,#09,#08,#15,#14
db #14,#12,#00,#0b,#0a,#17,#15,#15
db #14,#0c,#0b,#00,#19,#17,#17,#15
db #0e,#0d,#1b,#19,#03,#19,#17,#10
db #0f,#1c,#1b,#cf,#9c,#02,#00,#6d
db #02,#e3,#74,#6d,#03,#fd,#78,#01
db #fd,#fc,#03,#24,#1e,#1e,#fd,#02
db #00,#fd,#84,#01,#f9,#f7,#08,#00
db #fd,#90,#01,#f7,#14,#00,#fd,#9c
db #01,#c0,#20,#00,#10,#10,#ea,#62
db #00,#30,#0c,#0c,#fa,#7a,#00,#40
db #40,#01,#b1,#b2,#b5,#b6,#00,#b2
db #b3,#b3,#b2,#b2,#b3,#b5,#b5,#80
db #fd,#c5,#02,#b3,#b3,#b3,#a0,#a0
db #a0,#97,#00,#97,#97,#79,#79,#79
db #5a,#5a,#5a,#00,#50,#50,#50,#4b
db #4b,#4b,#3c,#3c,#46,#3c,#fd,#bf
db #00,#28,#28,#28,#fd,#ff,#03,#fd
db #51,#02,#16,#00,#16,#16,#14,#14
db #14,#13,#13,#13,#03,#0f,#0f,#0f
db #0b,#0b,#0b,#fd,#fc,#02,#fd,#f9
db #02,#ff,#fd,#f6,#02,#fd,#f3,#02
db #fd,#f0,#02,#fd,#ed,#02,#fd,#ea
db #02,#fd,#e7,#02,#fd,#e4,#02,#fd
db #e1,#02,#fe,#fd,#de,#02,#fd,#db
db #02,#fd,#d8,#02,#fd,#d5,#02,#fd
db #d2,#02,#fd,#cf,#02,#fd,#29,#03
db #71,#06,#71,#71,#64,#64,#64,#fd
db #23,#03,#fd,#1d,#03,#38,#06,#38
db #38,#32,#32,#32,#fd,#17,#03,#fd
db #11,#03,#1c,#06,#1c,#1c,#19,#19
db #19,#fd,#0b,#03,#fd,#05,#03,#0e
db #3f,#0e,#0e,#fd,#56,#03,#fd,#53
db #03,#fd,#50,#03,#fd,#4d,#03,#fd
db #4a,#03,#fd,#47,#03,#fc,#fd,#44
db #03,#fd,#41,#03,#fd,#3e,#03,#fd
db #3b,#03,#fd,#38,#03,#fd,#35,#03
db #94,#95,#00,#98,#99,#95,#97,#97
db #95,#95,#97,#30,#98,#98,#fd,#85
db #03,#fd,#32,#03,#87,#87,#87,#7f
db #30,#7f,#7f,#fd,#7a,#03,#fd,#74
db #03,#43,#43,#43,#3f,#32,#3f,#3f
db #fd,#6e,#03,#fb,#ff,#03,#21,#20
db #fc,#4a,#02,#19,#c8,#fd,#5c,#03
db #fc,#9e,#02,#10,#10,#fd,#b7,#02
db #09,#09,#09,#ff,#fd,#bc,#03,#fa
db #b6,#03,#fd,#b3,#03,#fd,#b0,#03
db #fd,#ad,#03,#fd,#aa,#03,#fd,#a7
db #03,#fd,#a4,#03,#ff,#fd,#a1,#03
db #fd,#9e,#03,#fd,#9b,#03,#fd,#98
db #03,#fd,#95,#03,#fd,#92,#03,#fd
db #8f,#03,#fd,#e9,#03,#03,#5f,#5f
db #5f,#55,#55,#55,#fd,#e3,#03,#fd
db #dd,#03,#03,#2f,#2f,#2f,#2a,#2a
db #2a,#fd,#d7,#03,#fd,#d1,#03,#03
db #18,#18,#18,#15,#15,#15,#fa,#b3
db #03,#fa,#c2,#03,#ff,#fd,#13,#00
db #fd,#10,#00,#fd,#0d,#00,#fd,#0a
db #00,#fd,#07,#00,#fd,#04,#00,#fd
db #01,#00,#fd,#fe,#03,#fc,#fd,#fb
db #03,#fd,#f8,#03,#fd,#f5,#03,#00
db #c0,#02,#80,#c0,#03,#f4,#bf,#01
db #5a,#4b,#3f,#3c,#2d,#f2,#cc,#01
db #b8,#cc,#01,#fa,#22,#02,#fc,#bf
db #00,#fc,#25,#01,#fc,#2c,#02,#fe
db #fa,#2c,#02,#f4,#2c,#02,#fa,#42
db #02,#fc,#b6,#00,#fc,#46,#02,#f6
db #50,#02,#ee,#50,#02,#f1,#01,#f1
db #c9,#c9,#a0,#a0,#79,#79,#f0,#74
db #02,#c0,#00,#cc,#01,#80,#cc,#02
db #87,#87,#71,#71,#5a,#5a,#3f,#43
db #43,#fc,#0c,#00,#fa,#0c,#00,#f4
db #0c,#00,#fa,#22,#00,#dc,#1e,#00
db #fc,#b3,#00,#c0,#fc,#ec,#03,#f0
db #54,#00,#79,#79,#5f,#5f,#50,#50
db #3c,#3c,#3c,#fc,#6c,#00,#fa,#6c
db #00,#f4,#6c,#00,#fa,#82,#00,#87
db #87,#f3,#fd,#4a,#03,#fb,#4f,#00
db #f8,#92,#00,#ee,#90,#00,#b3,#b3
db #fa,#aa,#00,#fc,#b4,#00,#10,#5a
db #5a,#2d,#d3,#c0,#00,#64,#64,#32
db #5f,#38,#5f,#2f,#fd,#ed,#00,#fa
db #f3,#00,#af,#fc,#00,#50,#50,#28
db #1f,#55,#55,#2a,#fd,#4d,#01,#fa
db #53,#01,#af,#5c,#01,#00,#f0,#00
db #00,#f0,#01,#fa,#f0,#ad,#03,#fc
db #a0,#00,#fc,#b6,#00,#fd,#8f,#00
db #fd,#bf,#00,#5a,#fd,#c6,#03,#3c
db #3e,#3c,#3c,#fd,#cc,#03,#fd,#c9
db #03,#fd,#d2,#03,#5b,#c6,#03,#43
db #c3,#03,#32,#22,#64,#21,#fd,#40
db #01,#4b,#97,#32,#fd,#43,#01,#3f
db #3e,#7f,#2a,#fd,#46,#01,#fd,#4f
db #01,#fd,#4c,#01,#fa,#43,#01,#be
db #46,#01,#38,#06,#71,#25,#55,#a9
db #38,#fd,#a3,#01,#fd,#a0,#01,#47
db #3f,#8e,#2f,#fa,#a3,#01,#fd,#ac
db #01,#b8,#a0,#01,#00,#40,#01,#00
db #40,#02,#ed,#e8,#03,#00,#72,#74
db #3d,#78,#79,#7b,#7d,#7e,#00,#80
db #82,#83,#85,#87,#88,#8a,#8c,#00
db #8e,#8f,#91,#93,#94,#96,#98,#99
db #00,#9b,#9d,#9e,#a0,#a2,#a4,#a5
db #a7,#00,#a9,#aa,#ac,#ae,#af,#b1
db #b3,#b4,#22,#b6,#b8,#fd,#3c,#00
db #64,#32,#19,#fd,#40,#00,#97,#23
db #4b,#25,#fd,#43,#00,#7f,#3f,#20
db #fd,#46,#00,#fd,#4f,#00,#e0,#fd
db #4c,#00,#fa,#43,#00,#be,#46,#00
db #71,#38,#1c,#a9,#55,#63,#2a,#fd
db #a3,#00,#fd,#a0,#00,#8e,#47,#24
db #fa,#a3,#00,#fd,#ac,#00,#f0,#b8
db #a0,#00,#00,#40,#00,#00,#40,#01
db #ea,#e8,#02,#15,#2a,#55,#a9,#40
db #52,#db,#13,#03,#ea,#42,#54,#ba
db #16,#2d,#88,#fa,#40,#03,#5a,#b3
db #5a,#e2,#46,#03,#09,#5a,#5a,#00
db #2a,#2b,#2e,#2e,#27,#27,#26,#26
db #01,#27,#26,#20,#20,#24,#24,#25
db #fd,#7e,#03,#00,#21,#21,#22,#21
db #1b,#1b,#20,#1f,#00,#20,#20,#19
db #19,#1d,#1d,#1e,#1d,#00,#17,#17
db #1c,#1b,#1c,#1c,#15,#15,#03,#1a
db #19,#1b,#1c,#17,#19,#d3,#40,#03
db #fd,#c4,#03,#00,#14,#15,#18,#17
db #11,#11,#11,#10,#00,#11,#11,#0b
db #0b,#10,#0f,#10,#10,#00,#0a,#0a
db #0f,#0e,#0f,#0f,#08,#08,#00,#0e
db #0d,#0e,#0e,#07,#07,#0c,#0c,#01
db #0d,#0c,#06,#06,#0c,#0b,#0c,#fd
db #f1,#03,#00,#0b,#0a,#0b,#0c,#08
db #0a,#db,#3b,#08,#51,#b8,#13,#25
db #fa,#00,#00,#4b,#97,#4b,#88,#e2
db #06,#00,#fa,#4b,#4b,#fd,#70,#03
db #2d,#26,#26,#00,#2b,#2a,#2a,#29
db #22,#22,#2e,#2d,#80,#fc,#3d,#00
db #30,#2f,#30,#2f,#28,#27,#34,#00
db #33,#33,#32,#2b,#2b,#38,#37,#37
db #00,#36,#2f,#2f,#3b,#3a,#3a,#39
db #32,#00,#32,#3f,#3d,#3e,#3f,#3b
db #3c,#e5,#04,#40,#53,#ba,#15,#2a
db #fa,#60,#00,#55,#a9,#60,#55,#df
db #66,#00,#fd,#d0,#03,#16,#0f,#0e
db #13,#11,#00,#11,#0f,#08,#07,#14
db #12,#12,#10,#00,#09,#08,#15,#14
db #14,#12,#0b,#0a,#00,#17,#15,#15
db #14,#0c,#0b,#19,#17,#00,#17,#15
db #0e,#0d,#1b,#19,#19,#17,#0f,#10
db #0f,#1c,#1b,#cf,#9c,#03,#00,#6d
db #03,#74,#6d,#00,#fd,#78,#02,#8f
db #fd,#fc,#00,#24,#1e,#1e,#fd,#02
db #01,#fd,#84,#02,#f7,#08,#01,#fd
db #90,#02,#e4,#f7,#14,#01,#fd,#9c
db #02,#c0,#20,#01,#10,#10,#ea,#62
db #01,#0c,#0c,#f0,#fa,#7a,#01,#00
db #40,#02,#00,#40,#03,#c0,#40,#00
db #0a,#08,#08,#0a,#20,#0b,#0b,#fb
db #3f,#01,#0a,#5a,#4b,#3c,#2d,#e0
db #f2,#4c,#01,#b8,#4c,#01,#fa,#a2
db #01,#4b,#4b,#38,#38,#32,#1e,#32
db #25,#25,#fc,#ac,#01,#fa,#ac,#01
db #f4,#ac,#01,#fa,#c2,#01,#71,#1c
db #71,#64,#64,#fc,#c6,#01,#f6,#d0
db #01,#ee,#d0,#01,#f1,#f1,#03,#c9
db #c9,#a0,#a0,#79,#79,#f0,#f4,#01
db #00,#4c,#01,#80,#80,#4c,#02,#87
db #87,#71,#71,#5a,#5a,#43,#7c,#43
db #fc,#8c,#03,#fa,#8c,#03,#f4,#8c
db #03,#fa,#a2,#03,#dc,#9e,#03,#97
db #97,#c0,#fa,#6a,#03,#f0,#d4,#03
db #79,#79,#5f,#5f,#50,#50,#3c,#3c
db #3c,#fc,#ec,#03,#fa,#ec,#03,#f4
db #ec,#03,#fa,#02,#00,#87,#87,#f3
db #fd,#ca,#02,#fb,#cf,#03,#f8,#12
db #00,#ee,#10,#00,#b3,#b3,#fa,#2a
db #00,#fc,#34,#00,#00,#b1,#b2,#b5
db #b6,#b2,#b3,#b3,#b2,#08,#b2,#b3
db #b5,#b5,#fd,#45,#00,#b3,#b3,#b3
db #01,#a0,#a0,#a0,#97,#97,#97,#79
db #fc,#38,#00,#00,#5a,#50,#50,#50
db #4b,#4b,#4b,#3c,#00,#3c,#3c,#2d
db #2d,#2d,#28,#28,#28,#10,#25,#25
db #25,#fd,#d1,#00,#16,#16,#16,#14
db #00,#14,#14,#13,#13,#13,#0f,#0f
db #0f,#1f,#0b,#0b,#0b,#fd,#7c,#00
db #fd,#79,#00,#fd,#76,#00,#fd,#73
db #00,#fd,#70,#00,#ff,#fd,#6d,#00
db #fd,#6a,#00,#fd,#67,#00,#fd,#64
db #00,#fd,#61,#00,#fd,#5e,#00,#fd
db #5b,#00,#fd,#58,#00,#fb,#fd,#55
db #00,#fd,#52,#00,#fd,#4f,#00,#fd
db #a9,#00,#fb,#61,#03,#64,#fd,#a3
db #00,#fd,#9d,#00,#58,#38,#fc,#48
db #03,#32,#fd,#97,#00,#fd,#91,#00
db #1c,#1c,#1c,#18,#19,#19,#19,#fd
db #8b,#00,#fd,#85,#00,#0e,#0e,#0e
db #ff,#fd,#d6,#00,#fd,#d3,#00,#fd
db #d0,#00,#fd,#cd,#00,#fd,#ca,#00
db #fd,#c7,#00,#fd,#c4,#00,#fd,#c1
db #00,#f0,#fd,#be,#00,#fd,#bb,#00
db #fd,#b8,#00,#fd,#b5,#00,#94,#95
db #98,#99,#00,#95,#97,#97,#95,#95
db #97,#98,#98,#e3,#fd,#05,#01,#fd
db #b2,#00,#fd,#21,#00,#7f,#7f,#7f
db #fd,#fa,#00,#fd,#f4,#00,#03,#43
db #43,#43,#3f,#3f,#3f,#fd,#ee,#00
db #fd,#e8,#00,#03,#21,#21,#21,#20
db #20,#20,#fd,#e2,#00,#fd,#dc,#00
db #40,#10,#fb,#36,#01,#0c,#0c,#0c
db #09,#09,#09,#ff,#fd,#3c,#01,#fa
db #36,#01,#fd,#33,#01,#fd,#30,#01
db #fd,#2d,#01,#fd,#2a,#01,#fd,#27
db #01,#fd,#24,#01,#ff,#fd,#21,#01
db #fd,#1e,#01,#fd,#1b,#01,#fd,#18
db #01,#fd,#15,#01,#fd,#12,#01,#fd
db #0f,#01,#fd,#69,#01,#03,#5f,#5f
db #5f,#55,#55,#55,#fd,#63,#01,#fd
db #5d,#01,#03,#2f,#2f,#2f,#2a,#2a
db #2a,#fd,#57,#01,#fd,#51,#01,#03
db #18,#18,#18,#15,#15,#15,#fa,#33
db #01,#fa,#42,#01,#ff,#fd,#93,#01
db #fd,#90,#01,#fd,#8d,#01,#fd,#8a
db #01,#fd,#87,#01,#fd,#84,#01,#fd
db #81,#01,#fd,#7e,#01,#fc,#fd,#7b
db #01,#fd,#78,#01,#fd,#75,#01,#00
db #40,#00,#80,#40,#01,#d0,#3f,#03
db #2a,#2b,#00,#2e,#2f,#2b,#2d,#2d
db #2b,#2b,#2d,#40,#2e,#7b,#7a,#03
db #00,#ef,#00,#00,#00,#00,#30,#00
db #01,#fe,#d1,#d3,#c8,#00,#41,#00
db #41,#ff,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#fb,#00,#00,#00,#00,#00
db #00,#00,#00,#e7,#00,#01,#d9,#13
db #00,#41,#ff,#00,#41,#00,#41,#00
db #41,#00,#41,#00,#41,#00,#41,#00
db #41,#01,#41,#77,#01,#fe,#41,#f7
db #3e,#e0,#44,#02,#a1,#0e,#f9,#c4
db #00,#74,#b7,#e7,#cb,#02,#41,#2e
db #40,#4d,#02,#00,#ae,#ad,#ae,#00
db #c0,#ff,#00,#c0,#00,#c0,#00,#c0
db #00,#c0,#00,#c0,#00,#c0,#00,#c0
db #00,#c0,#ff,#00,#c0,#00,#c0,#00
db #c0,#00,#c0,#00,#c0,#00,#c0,#00
db #c0,#a7,#c0,#5d,#01,#da,#13,#01
db #fe,#41,#f7,#3e,#e0,#44,#02,#cc
db #e7,#f6,#d5,#42,#f8,#32,#00,#75
db #e8,#cc,#02,#41,#2e,#40,#4d,#02
db #ff,#00,#ae,#00,#ae,#2d,#ae,#00
db #40,#00,#40,#00,#40,#00,#40,#00
db #40,#c0,#00,#40,#41,#40,#00,#9c
db #58,#00,#02,#02,#f3,#a5,#fa,#b5
db #e5,#bd,#04,#05,#d8,#d2,#7b,#fd
db #d9,#05,#d4,#da,#28,#d9,#03,#03
db #00,#26,#01,#01,#fc,#13,#02,#02
db #db,#10,#71,#81,#02,#bc,#fe,#35
db #02,#fe,#3b,#fc,#d5,#fe,#3e,#dc
db #d0,#03,#05,#0f,#07,#0a,#0b,#0b
db #00,#46,#0d,#46,#a0,#f8,#a0,#99
db #fe,#00,#59,#00,#59,#00,#59,#00
db #59,#00,#59,#a8,#59,#fa,#c9,#06
db #7f,#06,#fc,#16,#dc,#0b,#ee,#23
db #82,#93,#d0,#71,#00,#41,#00,#41
db #ff,#ee,#e9,#fd,#12,#f9,#0b,#fb
db #11,#fa,#21,#fa,#1c,#fe,#8a,#f6
db #2f,#fe,#69,#7a,#d0,#71,#00,#41
db #00,#41,#d5,#d1,#e8,#29,#f7,#84
db #07,#00,#08,#00,#0b,#0c,#00,#0e
db #0f,#00,#4f,#11,#e6,#0f,#01,#01
db #c5,#70,#f7,#6f,#ec,#ae,#ca,#ca
db #ff,#58,#41,#fa,#01,#00,#ef,#ad
db #ef,#ee,#72,#d3,#11,#e5,#51,#d3
db #5b,#bf,#fd,#59,#05,#d4,#5a,#00
db #59,#00,#59,#00,#59,#00,#59,#00
db #59,#cc,#a8,#59,#fa,#c9,#06,#06
db #fc,#16,#dd,#0b,#02,#03,#0f,#03
db #02,#01,#01,#fa,#40,#fd,#4b,#df
db #46,#d2,#9b,#fc,#fe,#9d,#b7,#40
db #fa,#35,#a6,#8f,#00,#89,#20,#89
db #02,#02,#e1,#ed,#25,#fe,#3b,#57
db #80,#04,#05,#00,#05,#fe,#ea,#f5
db #a6,#8f,#89,#89,#fd,#a8,#fd,#c2
db #04,#fb,#c1,#06,#fe,#cc,#ff,#f1
db #c6,#5e,#dd,#00,#c0,#00,#c0,#f0
db #7f,#fd,#18,#d3,#90,#fd,#00,#7f
db #00,#fd,#fe,#fe,#16,#fc,#c6,#f4
db #cc,#fd,#c1,#a3,#db,#d0,#d9,#f3
db #fa,#c1,#e8,#57,#00,#c7,#3e,#c7
db #02,#02,#8a,#8b,#b8,#61,#f9,#d0
db #08,#00,#79,#00,#79,#78,#79,#fa
db #a9,#06,#06,#fc,#c6,#00,#07,#08
db #00,#0b,#0c,#00,#0e,#0f,#27,#00
db #11,#e6,#8f,#01,#01,#c5,#f0,#f7
db #ef,#ec,#2e,#ff,#00,#8b,#fe,#48
db #f1,#35,#d3,#5b,#e8,#29,#e5,#71
db #bb,#5c,#00,#41,#ff,#00,#41,#ee
db #e9,#fd,#12,#f9,#0b,#fb,#11,#fa
db #21,#fa,#1c,#fe,#8a,#fe,#f6,#2f
db #69,#7a,#d0,#71,#00,#41,#00,#41
db #d5,#d1,#ec,#29,#02,#07,#03,#03
db #02,#01,#01,#fa,#40,#fd,#4b,#df
db #46,#f7,#d2,#fb,#fe,#9d,#b7,#40
db #fd,#3b,#05,#ed,#fa,#00,#40,#00
db #40,#9c,#d7,#a0,#02,#02,#ed,#25
db #fe,#3b,#57,#80,#04,#05,#3e,#00
db #05,#fe,#ea,#a6,#8f,#00,#89,#09
db #89,#f9,#28,#06,#7e,#06,#fc,#46
db #f1,#35,#a3,#5b,#d0,#59,#00,#29
db #20,#29,#02,#6d,#02,#88,#0b,#fd
db #42,#04,#fb,#41,#fe,#8a,#06,#f1
db #46,#ff,#5e,#5d,#70,#40,#fd,#18
db #d3,#90,#70,#00,#d0,#4f,#70,#c0
db #fd,#98,#f0,#a3,#10,#e2,#80,#eb
db #85,#fc,#a2,#07,#08,#09,#0b,#01
db #0c,#0e,#0e,#0f,#10,#11,#00,#b2
db #b1,#24,#02,#3c,#3c,#2c,#3d,#3d
db #2d,#fb,#04,#2c,#f8,#fd,#01,#fe
db #0d,#f4,#06,#be,#0c,#b8,#00,#24
db #34,#35,#de,#fc,#5d,#fe,#a9,#25
db #fb,#ac,#fa,#b4,#fc,#b1,#fb,#61
db #24,#77,#35,#f6,#98,#fa,#c6,#fe
db #ba,#34,#f6,#9f,#f4,#c7,#ef,#df
db #bc,#f8,#a2,#34,#fc,#b7,#ee,#c7
db #a7,#c1,#fa,#96,#10,#38,#00,#38
db #18,#39,#39,#10,#31,#39,#19,#b8
db #fe,#84,#18,#fd,#81,#fe,#8d,#fa
db #86,#10,#30,#30,#fe,#fa,#8c,#f7
db #8f,#f9,#9e,#ef,#9f,#f9,#aa,#fe
db #99,#fe,#c8,#31,#c2,#ed,#86,#d1
db #81,#00,#28,#28,#08,#d4,#11,#20
db #aa,#fe,#0e,#28,#fe,#08,#20,#fe
db #05,#29,#fe,#44,#28,#ef,#fd,#41
db #fe,#4d,#fa,#46,#20,#fe,#f9,#fa
db #4c,#f7,#4f,#f9,#5e,#f6,#ef,#5f
db #f9,#6a,#fe,#59,#fe,#88,#31,#ed
db #46,#d1,#41,#00,#10,#18,#18,#08
db #fe,#d1,#00,#11,#19,#09,#31,#19
db #19,#fd,#d3,#f7,#dc,#00,#10,#10
db #fe,#e8,#7e,#11,#f4,#d6,#fd,#f1
db #fd,#fa,#fc,#d0,#fe,#07,#f2,#a6
db #3d,#00,#2d,#3d,#3d,#24,#34,#34
db #2c,#3c,#4f,#3c,#fa,#1b,#24,#35
db #fc,#14,#f9,#1e,#ef,#1f,#f9,#2a
db #df,#fe,#19,#fe,#48,#35,#f3,#24
db #fb,#4f,#fc,#30,#fd,#5e,#ee,#4f
db #ed,#e9,#19,#00,#d0,#b0,#d0,#00
db #fe,#87,#fd,#e2,#30,#bc,#e1,#de
db #fa,#28,#f1,#19,#00,#fd,#8d,#fe
db #3e,#f2,#86,#fc,#48,#20,#3f,#30
db #30,#fa,#4c,#f7,#4f,#f9,#5e,#ef
db #5f,#f9,#6a,#fe,#59,#bb,#fe,#88
db #31,#ed,#46,#d1,#41,#fd,#40,#08
db #fd,#ce,#f5,#c5,#ff,#fd,#d3,#f1
db #85,#fa,#e2,#fd,#f1,#fd,#fa,#70
db #40,#d6,#30,#6a,#fa,#bf,#fd,#c0
db #08,#fd,#4e,#f5,#45,#fd,#53,#f1
db #05,#fa,#62,#6a,#ba,#ef,#d6,#b0
db #6a,#7a,#fd,#40,#08,#fd,#ce,#f5
db #c5,#fd,#d3,#f1,#85,#fb,#fa,#e2
db #6a,#3a,#d6,#30,#6a,#fa,#fd,#c0
db #08,#fd,#4e,#f5,#45,#f9,#fd,#53
db #f1,#05,#fa,#62,#6a,#ba,#fa,#c8
db #21,#31,#fc,#15,#fd,#fd,#e0,#fc
db #1c,#f4,#11,#fe,#05,#fc,#2e,#f5
db #23,#00,#fe,#35,#9e,#fe,#40,#31
db #01,#fe,#3e,#fd,#46,#fd,#74,#fa
db #53,#09,#ff,#fd,#7e,#fe,#41,#fa
db #4c,#f7,#4f,#f9,#5e,#ef,#5f,#f9
db #6a,#fb,#41,#ff,#f3,#64,#fa,#53
db #fd,#95,#fd,#9e,#ee,#8f,#b8,#59
db #00,#41,#00,#41,#ef,#f0,#a1,#fe
db #f9,#fe,#0e,#38,#fe,#cc,#fe,#08
db #fe,#19,#fe,#11,#bf,#fd,#1d,#31
db #fd,#13,#fc,#13,#fb,#1d,#fa,#2d
db #f9,#22,#fb,#17,#a3,#fd,#10,#10
db #fe,#3a,#13,#33,#33,#fd,#46,#fd
db #0d,#16,#1a,#3a,#3a,#fd,#04,#19
db #fe,#3e,#fe,#43,#30,#de,#fd,#4f
db #f4,#4c,#18,#fa,#5f,#ef,#5f,#f9
db #5e,#fb,#41,#10,#8f,#fe,#77,#1b
db #3b,#3b,#f3,#4c,#fd,#95,#fe,#92
db #fd,#9a,#ff,#fa,#91,#fd,#7c,#fa
db #8e,#fd,#88,#fa,#7f,#f7,#af,#f9
db #94,#ef,#bf,#c7,#f9,#be,#fe,#b9
db #12,#32,#33,#eb,#a6,#6a,#43,#fa
db #39,#ff,#f7,#9c,#fd,#18,#fa,#4b
db #f7,#99,#fa,#ae,#67,#00,#f7,#47
db #f9,#3e,#8e,#fe,#39,#12,#32,#33
db #eb,#26,#70,#c3,#fd,#0d,#20,#cd
db #fe,#05,#fe,#08,#3b,#28,#fe,#11
db #fe,#14,#3a,#fa,#1c,#60,#20,#fe
db #f9,#eb,#28,#00,#28,#28,#08,#29
db #10,#2b,#0b,#2b,#fc,#45,#0a,#2a
db #2a,#0a,#8b,#fe,#41,#09,#29,#29
db #fd,#52,#08,#fd,#41,#fc,#59,#7f
db #3a,#fd,#13,#fd,#07,#fd,#64,#fd
db #61,#fc,#fb,#fb,#59,#f2,#52,#ff
db #e4,#72,#fb,#40,#fc,#9c,#f7,#8b
db #e8,#88,#fe,#4f,#fc,#00,#fa,#cd
db #fb,#fd,#dd,#fd,#d6,#fb,#d0,#fc
db #6c,#fd,#e2,#12,#fb,#e3,#ee,#eb
db #92,#fa,#40,#02,#23,#f6,#48,#00
db #21,#fb,#9c,#20,#4f,#20,#f7,#5b
db #12,#33,#f6,#66,#fc,#00,#f7,#10
db #fb,#a1,#ff,#fa,#be,#fa,#3c,#f4
db #36,#ee,#4e,#f9,#42,#f3,#13,#f6
db #44,#fa,#ca,#49,#10,#fb,#d1,#10
db #31,#ef,#d8,#32,#32,#fe,#a8,#7f
db #33,#f4,#24,#fd,#b1,#fd,#ba,#00
db #00,#bf,#00,#fd,#4a,#fc,#50,#bf
db #f9,#5a,#38,#f9,#b0,#f2,#14,#fc
db #e3,#ef,#14,#f9,#37,#fe,#0e,#57
db #28,#fe,#08,#20,#fe,#57,#29,#fe
db #44,#fe,#02,#fe,#42,#c7,#fe,#4d
db #fa,#46,#20,#30,#30,#fa,#4c,#f7
db #4f,#f9,#5e,#f7,#ef,#5f,#f9,#6a
db #fe,#59,#fe,#88,#31,#ed,#46,#d1
db #41,#fd,#40,#7f,#08,#fd,#ce,#f5
db #c5,#fd,#d3,#f1,#85,#fa,#e2,#fd
db #f1,#fd,#fa,#f7,#70,#40,#d6,#30
db #6a,#fa,#fd,#c0,#08,#fd,#4e,#f5
db #45,#fd,#53,#fd,#f1,#05,#fa,#62
db #6a,#ba,#d6,#b0,#6a,#7a,#fd,#40
db #08,#fd,#ce,#ff,#f5,#c5,#fd,#d3
db #f1,#85,#fa,#e2,#6a,#3a,#d6,#30
db #6a,#fa,#fd,#c0,#7f,#08,#fd,#4e
db #f5,#45,#fd,#53,#f1,#05,#fa,#62
db #6a,#ba,#fa,#c8,#3f,#21,#31,#fc
db #15,#fd,#e0,#fc,#1c,#f4,#11,#fe
db #05,#fc,#2e,#80,#f5,#23,#00,#18
db #18,#08,#19,#19,#00,#17,#11,#19
db #09,#fe,#44,#08,#fd,#41,#fe,#4d
db #fa,#46,#1e,#00,#10,#10,#fa,#4c
db #f7,#4f,#f9,#5e,#fb,#0b,#00,#c3
db #fb,#05,#fd,#70,#2c,#3d,#3d,#08
db #fa,#71,#fb,#e1,#ff,#f7,#76,#f6
db #8b,#dc,#41,#fb,#a1,#ee,#6a,#fa
db #82,#f9,#82,#fb,#35,#bf,#f4,#d6
db #09,#fe,#f2,#d8,#9d,#00,#65,#11
db #65,#f7,#d2,#fe,#17,#6e,#20,#f7
db #c6,#fe,#6c,#21,#ef,#26,#fc,#6b
db #c8,#81,#2d,#e3,#fe,#c0,#fa,#22
db #fd,#c2,#2c,#3c,#3c,#f7,#d4,#f7
db #79,#fe,#f9,#8e,#cd,#e1,#fb,#74
db #fd,#dd,#fa,#82,#fd,#dc,#fc,#d3
db #30,#6e,#30,#fc,#3d,#f5,#d7,#09
db #fe,#f2,#fd,#f1,#40,#40,#10,#df
db #fe,#a9,#fe,#c2,#31,#fc,#c1,#fe
db #c4,#fd,#cb,#f1,#c6,#fe,#b5,#fd
db #60,#df,#00,#c0,#00,#c0,#f0,#7f
db #fb,#18,#d5,#94,#20,#fc,#be,#36
db #31,#21,#fe,#16,#fd,#c6,#28,#fe
db #8e,#fd,#cc,#20,#07,#31,#39,#29
db #39,#39,#fd,#c0,#fa,#cc,#f7,#cf
db #ff,#f9,#de,#f4,#cd,#fd,#f1,#f4
db #e8,#fd,#fa,#f5,#f7,#ee,#0e,#e7
db #cc,#ff,#f1,#fd,#f2,#e2,#f9,#4a
db #fb,#c1,#f4,#56,#fd,#71,#fa,#35
db #00,#c3,#ff,#3a,#c3,#fd,#04,#f7
db #98,#f4,#4f,#b2,#a1,#fb,#8e,#f9
db #60,#fb,#b5,#00,#12,#3a,#3a,#1a
db #3b,#3b,#12,#33,#2a,#3b,#1b,#fe
db #c4,#08,#fe,#bb,#18,#fe,#cd,#00
db #af,#fe,#97,#19,#fe,#be,#00,#fe
db #a9,#fd,#cf,#f4,#cc,#f9,#de,#ff
db #f4,#cd,#fd,#f1,#f4,#e8,#fd,#fa
db #f5,#f7,#ee,#0e,#e7,#cc,#f2,#fd
db #dd,#fd,#4a,#fd,#32,#09,#f8,#48
db #f9,#4a,#fe,#39,#10,#fe,#ac,#fe
db #f7,#26,#fd,#74,#fd,#59,#fd,#71
db #00,#c0,#00,#c0,#c0,#c0,#00,#00
db #28,#28,#08,#29,#2b,#02,#23,#2b
db #01,#0b,#2b,#2b,#0a,#2a,#2a,#0a
db #fe,#c1,#00,#00,#21,#29,#09,#29
db #29,#00,#20,#2f,#20,#08,#fd,#c1
db #28,#fe,#02,#fe,#01,#fa,#06,#fd
db #e1,#f7,#fd,#ea,#fc,#c0,#f7,#d0
db #fc,#c1,#29,#fb,#db,#fe,#f5,#fb
db #fd,#fe,#f4,#f6,#ee,#0e,#f9,#02
db #f3,#d3,#f6,#04,#fe,#cf,#fc,#a4
db #10,#be,#fb,#a3,#10,#fb,#af,#fd
db #53,#fe,#5c,#fc,#ec,#fc,#e1,#32
db #5e,#32,#fe,#68,#33,#f4,#e4,#fd
db #71,#fd,#7a,#3f,#c0,#30,#45,#30
db #fe,#40,#31,#01,#31,#fc,#45,#08
db #fe,#1d,#af,#fd,#4c,#00,#fe,#17
db #09,#fe,#1a,#fd,#40,#fa,#4c,#f7
db #4f,#ff,#f9,#5e,#ef,#5f,#f9,#6a
db #fb,#41,#f3,#64,#fa,#53,#fd,#95
db #fd,#9e,#fe,#ee,#8f,#b8,#59,#00
db #41,#00,#41,#f0,#a1,#fe,#f9,#fe
db #0e,#38,#fb,#fe,#cc,#fe,#08,#fe
db #19,#fe,#11,#fd,#1d,#31,#fd,#13
db #fc,#13,#fa,#fb,#1d,#fa,#2d,#f9
db #22,#fb,#17,#fd,#10,#10,#fe,#3a
db #13,#31,#33,#33,#fd,#46,#fd,#0d
db #1a,#3a,#3a,#fd,#04,#6d,#19,#fe
db #3e,#fe,#43,#30,#fd,#4f,#f4,#4c
db #18,#fa,#5f,#e8,#ef,#5f,#f9,#5e
db #fb,#41,#10,#fe,#77,#1b,#3b,#3b
db #ff,#f3,#4c,#fd,#95,#fe,#92,#fd
db #9a,#fa,#91,#fd,#7c,#fa,#8e,#fd
db #88,#fc,#fa,#7f,#f7,#af,#f9,#94
db #ef,#bf,#f9,#be,#fe,#b9,#12,#32
db #7f,#33,#eb,#a6,#6a,#43,#fa,#39
db #f7,#9c,#fd,#18,#fa,#4b,#f7,#99
db #f8,#fa,#ae,#67,#00,#f7,#47,#f9
db #3e,#fe,#39,#12,#32,#33,#ec,#eb
db #26,#70,#c3,#fd,#0d,#20,#fe,#05
db #fe,#08,#3b,#28,#d6,#fe,#11,#fe
db #14,#3a,#fa,#1c,#20,#fe,#f9,#eb
db #28,#00,#00,#18,#18,#08,#19,#19
db #00,#11,#19,#5c,#09,#fe,#44,#08
db #fd,#41,#fe,#4d,#fa,#46,#00,#10
db #7e,#10,#fa,#4c,#f7,#4f,#f9,#5e
db #fe,#23,#fd,#22,#fd,#e6,#29,#c7
db #fe,#de,#fd,#70,#2c,#3d,#3d,#fd
db #0a,#fc,#73,#fd,#83,#ff,#fd,#7a
db #f8,#77,#f6,#8b,#dc,#41,#fb,#a1
db #ee,#6a,#fa,#82,#f9,#82,#af,#fc
db #3b,#31,#f4,#d6,#09,#fe,#f2,#d8
db #9d,#00,#65,#11,#65,#db,#f7,#d2
db #fe,#17,#20,#f7,#c6,#fe,#6c,#21
db #ef,#26,#fc,#6b,#b8,#c8,#81,#2d
db #fe,#c0,#fa,#22,#fd,#c2,#2c,#3c
db #3c,#ff,#f7,#d4,#f7,#79,#f9,#8e
db #cd,#e1,#fb,#74,#fd,#dd,#fa,#82
db #fd,#dc,#9b,#fc,#d3,#30,#30,#fc
db #3d,#f5,#d7,#09,#fe,#f2,#fd,#f1
db #f9,#00,#40,#00,#40,#c0,#40,#fe
db #2b,#fc,#2a,#21,#31,#fc,#45,#df
db #fd,#25,#fd,#4c,#20,#fb,#2f,#fd
db #40,#fa,#4c,#f7,#4f,#f9,#5e,#ff
db #f4,#4d,#fb,#d5,#f6,#6a,#fd,#7a
db #f5,#77,#ee,#8e,#e7,#4c,#f1,#7d
db #ff,#f2,#62,#f9,#ca,#fb,#41,#f4
db #d6,#fd,#f1,#00,#3d,#34,#3d,#fd
db #84,#fd,#f7,#18,#f4,#cf,#b2,#21
db #fb,#0e,#f9,#e0,#fb,#35,#10,#fe
db #29,#bf,#fe,#42,#31,#fc,#41,#fe
db #44,#fd,#4b,#f1,#46,#fe,#3b,#60
db #5f,#ff,#70,#40,#fb,#18,#d5,#94
db #70,#00,#d0,#4f,#70,#c0,#fb,#98
db #d5,#14,#6e,#34,#d1,#40,#f4,#80
db #35,#fe,#7c,#fb,#6b,#fd,#7c,#35
db #5f,#36,#fc,#88,#37,#fd,#8d,#ee
db #88,#f9,#a2,#fb,#9a,#f5,#ae,#40
db #3f,#bb,#ba,#0f,#a8,#fd,#00,#1b
db #fc,#04,#00,#fe,#09,#1f,#1f,#19
db #0f,#17,#15,#14,#10,#fe,#12,#f7
db #09,#c1,#0c,#fd,#5c,#8c,#b8,#00
db #0f,#0d,#0a,#fd,#99,#fd,#a8,#07
db #1c,#79,#1b,#fd,#ae,#fa,#b4,#fc
db #b1,#fb,#61,#0e,#0e,#fc,#65,#ff
db #fa,#a2,#fa,#c6,#fd,#c1,#fd,#cc
db #f4,#cc,#f9,#a2,#fb,#d9,#f4,#e4
db #ff,#f7,#ea,#fe,#0a,#fe,#f6,#ec
db #c7,#a9,#c3,#fd,#96,#fd,#7c,#6a
db #c0,#ef,#d6,#13,#6a,#80,#dc,#76
db #10,#fb,#fa,#00,#40,#20,#40,#b5
db #da,#f7,#fa,#28,#f1,#19,#a0,#80
db #a6,#40,#10,#fb,#fa,#00,#40,#00
db #40,#fa,#00,#40,#00,#40,#00,#40
db #ed,#a0,#fc,#cb,#0d,#fe,#17,#0c
db #7f,#0c,#fb,#10,#fa,#20,#f9,#15
db #fd,#04,#fd,#2e,#ef,#10,#f9,#39
db #ff,#79,#8c,#cf,#73,#00,#44,#00
db #44,#e8,#a4,#fa,#c8,#f3,#c2,#ec
db #87,#fa,#67,#83,#d8,#7c,#00,#44
db #00,#44,#d9,#a4,#0a,#fe,#2b,#0b
db #df,#fe,#2e,#fe,#8a,#0c,#fd,#87
db #fd,#cd,#fb,#c8,#fb,#3e,#fc,#18
db #37,#1b,#00,#fe,#49,#fa,#22,#10
db #fe,#52,#f7,#49,#c1,#4c,#ea,#fd
db #9c,#b8,#40,#fe,#e2,#1e,#fd,#ea
db #1d,#fb,#ee,#1c,#ff,#f5,#f4,#fa
db #a0,#f4,#16,#fa,#06,#fd,#01,#fd
db #0c,#f4,#0c,#fa,#1e,#ff,#fa,#18
db #f7,#12,#fd,#03,#f7,#2a,#f7,#03
db #e8,#48,#e8,#0c,#f1,#3c,#ef,#f7
db #33,#f4,#dc,#fc,#84,#0f,#fe,#96
db #f5,#97,#fd,#d6,#fd,#bc,#ff,#00
db #00,#aa,#00,#fb,#68,#f5,#1a,#fa
db #de,#e8,#2b,#c8,#84,#fa,#6a,#bb
db #f6,#fe,#0f,#fe,#76,#ec,#47,#a9
db #43,#10,#fb,#fa,#00,#40,#fd,#00
db #40,#00,#40,#00,#40,#00,#40,#ed
db #a0,#fc,#cb,#0d,#fe,#17,#3f,#0c
db #0c,#fb,#10,#fa,#20,#f9,#15,#fd
db #04,#fd,#2e,#f0,#10,#ff,#c8,#84
db #fa,#40,#f6,#0a,#f8,#44,#e8,#88
db #e8,#4c,#f1,#7c,#f7,#73,#ef,#fa
db #ca,#f3,#0a,#f5,#d7,#10,#fb,#fa
db #00,#40,#00,#40,#ed,#40,#f0,#fd
db #07,#f6,#10,#fa,#1f,#fd,#1a,#0d
db #0a,#07,#1c,#fd,#f0,#27,#fc,#3a
db #6e,#81,#f7,#73,#fa,#ca,#f6,#be
db #0f,#fe,#d6,#ba,#f5,#d7,#10,#fb
db #fa,#3c,#40,#fe,#ac,#0d,#fc,#c6
db #0c,#1c,#0c,#0b,#0b,#fe,#cb,#fd
db #d0,#fe,#cd,#0a,#0a,#e7,#fe,#d4
db #fd,#d9,#fe,#d6,#0a,#09,#61,#de
db #00,#c0,#00,#c0,#af,#f0,#7d,#08
db #fb,#90,#09,#fb,#96,#fd,#1d,#fd
db #9e,#fb,#18,#a7,#fa,#0e,#0c,#fb
db #06,#0d,#0e,#fb,#b4,#fb,#00,#fa
db #be,#c0,#fe,#b8,#fb,#08,#1f,#1f
db #19,#17,#15,#14,#bf,#fe,#c5,#1b
db #fd,#d4,#fd,#c2,#fd,#cc,#f4,#cc
db #fa,#de,#fa,#d8,#bf,#f7,#d2,#0f
db #f5,#e8,#fd,#ff,#f4,#f6,#ee,#0e
db #e8,#cc,#f1,#fc,#fb,#f7,#f3,#fa
db #4a,#f6,#3e,#fd,#c4,#f5,#57,#10
db #fb,#7a,#00,#c0,#87,#37,#c0,#0d
db #0a,#07,#1c,#f9,#a5,#f4,#4e,#b2
db #a0,#ff,#fb,#a8,#fb,#b2,#f8,#5e
db #dc,#60,#db,#24,#f5,#c1,#e8,#08
db #be,#6c,#bf,#f4,#56,#10,#fb,#7a
db #00,#c0,#00,#c0,#00,#c0,#3c,#c0
db #fd,#2c,#4f,#0d,#fe,#47,#0c,#0c
db #d0,#8c,#e2,#1c,#d6,#da,#c0,#64
db #ff,#00,#44,#00,#44,#e8,#a4,#fa
db #c8,#f3,#c2,#ec,#87,#67,#83,#d8
db #7c,#eb,#00,#44,#00,#44,#d9,#a4
db #0a,#fe,#2b,#0b,#fe,#2e,#fe,#8a
db #7f,#0c,#fd,#87,#fd,#cd,#fb,#c8
db #fb,#3e,#c8,#e4,#fa,#40,#f6,#c2
db #ff,#f8,#44,#e8,#88,#e8,#4c,#f1
db #7c,#e8,#13,#fe,#ea,#fd,#37,#f6
db #d8,#7f,#10,#fb,#fa,#00,#40,#00
db #40,#ed,#40,#fd,#07,#f6,#10,#fa
db #1f,#87,#fd,#1a,#0d,#0a,#07,#1c
db #f0,#27,#fc,#3a,#6e,#81,#ed,#f7
db #73,#fa,#ca,#f6,#be,#0f,#fe,#d6
db #f5,#d7,#10,#fb,#fa,#f4,#00,#40
db #00,#40,#bc,#40,#fd,#2c,#0d,#fe
db #47,#0c,#0c,#e1,#00,#8c,#00,#8c
db #83,#8c,#0d,#0a,#07,#1c,#f9,#25
db #ff,#f4,#ce,#b2,#20,#fb,#28,#fb
db #32,#f8,#de,#fa,#28,#fd,#87,#fc
db #88,#39,#0b,#0b,#fe,#4b,#fd,#50
db #fe,#4d,#0a,#0a,#fe,#54,#cd,#fd
db #59,#fe,#56,#0a,#09,#61,#5e,#70
db #40,#08,#fb,#90,#7d,#09,#fb,#96
db #fd,#1d,#fd,#9e,#fb,#18,#fa,#0e
db #0c,#fb,#06,#3f,#0d,#0e,#fb,#b4
db #fb,#00,#fa,#be,#75,#05,#d0,#4d
db #70,#c0,#5f,#08,#fb,#10,#09,#fb
db #16,#fd,#9d,#fd,#1e,#fb,#98,#fa
db #8e,#4f,#0c,#fb,#86,#0d,#0e,#fb
db #34,#fb,#80,#fe,#84,#fe,#40,#fb
db #fb,#88,#fd,#93,#fb,#9c,#fe,#4f
db #fd,#13,#07,#fb,#55,#fa,#13,#ff
db #fa,#1f,#fa,#2b,#f8,#37,#e6,#85
db #f9,#1a,#fc,#50,#fb,#17,#fb,#53
db #55,#06,#fc,#a4,#05,#fe,#a9,#04
db #fc,#ac,#00,#b2,#b1,#0d,#06,#0c
db #0b,#0a,#09,#08,#00,#00,#86,#00
db #07,#9d,#71,#80,#0f,#0e,#f6,#11
db #d9,#10,#fe,#7c,#0a,#fd,#7a,#ff
db #fd,#7e,#fa,#46,#e2,#40,#e8,#52
db #e8,#64,#00,#40,#00,#40,#c0,#40
db #af,#fe,#d8,#09,#fd,#e2,#08,#ef
db #e6,#fc,#e2,#f8,#fb,#fe,#e0,#af
db #f6,#05,#0b,#f5,#10,#0c,#dd,#1c
db #a0,#80,#00,#40,#00,#40,#fe,#00
db #40,#00,#40,#00,#40,#90,#40,#fe
db #0e,#fc,#0f,#fe,#0d,#08,#8f,#fd
db #16,#0a,#09,#09,#fd,#1c,#fd,#07
db #fd,#22,#fe,#0b,#68,#0b,#fd,#28
db #fe,#0a,#0c,#fd,#2e,#0e,#0d,#0d
db #fe,#fd,#34,#fd,#04,#fa,#3a,#73
db #83,#00,#70,#00,#70,#bd,#70,#0d
db #f0,#fd,#0a,#fe,#16,#fe,#08,#db
db #1a,#1f,#1e,#1e,#1d,#1e,#1d,#1c
db #00,#fb,#46,#fd,#40,#fa,#49,#fd
db #43,#1b,#fe,#fe,#58,#5a,#49,#fd
db #f4,#fb,#ef,#fa,#fd,#f7,#fd,#fe
db #f7,#1d,#df,#82,#09,#fd,#98,#1c
db #dd,#9c,#67,#00,#d6,#47,#70,#c3
db #e8,#0d,#a2,#eb,#28,#0f,#fc,#40
db #0e,#0e,#0d,#fe,#47,#0c,#ae,#fc
db #4a,#0b,#fe,#4f,#0a,#fc,#52,#fa
db #86,#ed,#5c,#07,#1b,#06,#05,#08
db #fe,#70,#fd,#73,#09,#fe,#76,#fd
db #79,#76,#0a,#fe,#7c,#fd,#7f,#fe
db #51,#09,#fd,#85,#fe,#4e,#0a,#db
db #fd,#8b,#fe,#49,#0b,#fd,#91,#fe
db #46,#0c,#fd,#97,#fe,#44,#71,#0d
db #fd,#9d,#fa,#8e,#fd,#82,#07,#05
db #00,#fa,#a7,#11,#06,#04,#00,#fa
db #b0,#05,#03,#00,#fa,#b9,#3e,#04
db #02,#e7,#57,#e2,#e1,#00,#40,#00
db #40,#f0,#a0,#04,#aa,#fe,#10,#05
db #fb,#13,#06,#fb,#19,#07,#fb,#1f
db #08,#bf,#fb,#25,#09,#fe,#2b,#fd
db #94,#fd,#8f,#fd,#8c,#fd,#87,#fe
db #85,#7f,#0e,#fa,#81,#fd,#91,#fd
db #e6,#fd,#fa,#fa,#46,#e2,#40,#e8
db #52,#ff,#e8,#64,#00,#40,#00,#40
db #00,#40,#00,#40,#00,#40,#90,#40
db #fe,#0e,#d1,#fc,#0f,#fe,#0d,#08
db #fd,#16,#0a,#09,#09,#fd,#1c,#ed
db #fd,#07,#fd,#22,#fe,#0b,#0b,#fd
db #28,#fe,#0a,#0c,#fd,#2e,#1f,#0e
db #0d,#0d,#fd,#34,#fd,#04,#fd,#3a
db #fd,#0a,#fe,#1f,#7c,#08,#00,#40
db #00,#40,#03,#40,#00,#40,#83,#40
db #0e,#0e,#71,#0d,#00,#c0,#00,#c0
db #03,#c0,#0d,#0c,#0b,#00,#c0,#d0
db #00,#c0,#03,#c0,#00,#f5,#c0,#0f
db #0e,#0e,#0d,#e6,#fe,#bd,#fe,#d0
db #fe,#be,#0b,#0a,#f4,#cc,#fc,#e0
db #0a,#4f,#09,#fc,#e6,#09,#08,#ee
db #d8,#dc,#f0,#ee,#ea,#e4,#14,#fe
db #fe,#3f,#f6,#50,#ec,#30,#f4,#56
db #00,#c0,#00,#c0,#c0,#c0,#0f,#ff
db #fc,#c0,#fc,#bb,#fd,#b7,#fd,#cb
db #fe,#b1,#fd,#8a,#fd,#d3,#f4,#00
db #87,#f3,#e2,#07,#06,#05,#08,#fe
db #f0,#fd,#f3,#fe,#8e,#6e,#07,#fd
db #f9,#fe,#8c,#08,#fd,#ff,#fe,#d1
db #fd,#89,#09,#d7,#fe,#ce,#fd,#83
db #0a,#fe,#c9,#0b,#fd,#11,#fd,#b6
db #fd,#17,#b8,#fe,#c4,#0d,#fd,#1d
db #fa,#0e,#fd,#02,#07,#05,#00,#88
db #fa,#27,#06,#04,#00,#fa,#30,#05
db #03,#00,#9f,#fa,#39,#04,#02,#e7
db #d7,#e2,#61,#3f,#c0,#fe,#85,#fd
db #91,#ff,#fd,#e6,#fd,#02,#fa,#46
db #e2,#40,#e8,#52,#e8,#64,#00,#40
db #00,#40,#bc,#8d,#40,#0d,#fd,#0a
db #fe,#16,#fe,#08,#db,#1a,#1f,#1e
db #07,#1e,#1d,#1d,#1c,#00,#fb,#46
db #fd,#40,#fa,#49,#bf,#fd,#43,#1b
db #fe,#58,#5a,#49,#fd,#f4,#fb,#ef
db #fa,#fd,#f7,#fd,#b7,#fe,#f7,#1d
db #82,#09,#fd,#98,#1c,#dd,#9c,#67
db #00,#d6,#47,#e0,#70,#c3,#e8,#0d
db #eb,#28,#0d,#0c,#0b,#0a,#09,#7f
db #08,#00,#40,#00,#40,#03,#40,#00
db #40,#00,#40,#00,#40,#00,#40,#c7
db #00,#40,#03,#40,#0e,#0e,#0d,#00
db #40,#00,#40,#03,#40,#00,#0a,#0b
db #0c,#0d,#0c,#0b,#0a,#09,#aa,#fe
db #47,#08,#fe,#4a,#07,#fd,#4d,#06
db #fd,#51,#05,#aa,#fd,#55,#04,#fd
db #59,#03,#d6,#5d,#00,#89,#88,#00
db #c0,#00,#00,#81,#00,#0d,#0c,#0b
db #0a,#09,#08,#a7,#46,#80,#07,#71
db #40,#0f,#0e,#f6,#d1,#dc,#d0,#fb
db #ff,#71,#00,#76,#05,#00,#d0,#b0
db #8f,#0a,#0a,#09,#fd,#e2,#7d,#08
db #ef,#e6,#fc,#e2,#f8,#fb,#fe,#e0
db #f6,#05,#0b,#f5,#10,#57,#0c,#dd
db #1c,#0f,#fb,#74,#0d,#fb,#46,#dc
db #1c,#a0,#6f,#fd,#fd,#40,#fa,#d0
db #f7,#43,#ee,#40,#e2,#d6,#7f,#11
db #0b,#fb,#93,#55,#0a,#fb,#99,#09
db #fb,#9f,#08,#fe,#a5,#07,#fe,#a8
db #55,#06,#fe,#ab,#05,#fe,#ae,#03
db #fe,#b1,#01,#fe,#b4,#7f,#00,#f8
db #b7,#70,#00,#fd,#c0,#fa,#50,#f7
db #c3,#ee,#c0,#e2,#56,#aa,#7f,#91
db #0b,#fb,#13,#0a,#fb,#19,#09,#fb
db #1f,#08,#aa,#fe,#25,#07,#fe,#28
db #06,#fe,#2b,#05,#fe,#2e,#03,#af
db #fe,#31,#01,#fe,#34,#00,#f8,#37
db #70,#80,#fd,#40,#fa,#d0,#f5,#f7
db #43,#ee,#40,#e2,#d6,#7f,#11,#0b
db #fb,#93,#0a,#fb,#99,#55,#09,#fb
db #9f,#08,#fe,#a5,#07,#fe,#a8,#06
db #fe,#ab,#55,#05,#fe,#ae,#03,#fe
db #b1,#01,#fe,#b4,#00,#f8,#b7,#fe
db #70,#00,#fd,#c0,#fa,#50,#f7,#c3
db #ee,#c0,#e2,#56,#7f,#91,#0b,#aa
db #fb,#13,#0a,#fb,#19,#09,#fb,#1f
db #08,#fe,#25,#07,#aa,#fe,#28,#06
db #fe,#2b,#05,#fe,#2e,#03,#fe,#31
db #01,#bf,#fe,#34,#00,#f8,#37,#fe
db #8b,#fe,#18,#fe,#24,#00,#40,#00
db #40,#fd,#32,#40,#d4,#13,#30,#44
db #00,#0a,#00,#0a,#fa,#0a,#0a,#fe
db #16,#7e,#07,#fe,#19,#dc,#16,#2e
db #44,#00,#0c,#00,#0c,#d2,#0c,#0f
db #2b,#0f,#0e,#fd,#42,#0d,#fb,#46
db #0c,#7d,#4c,#fd,#40,#fa,#fa,#d0
db #f7,#43,#ee,#40,#e2,#d6,#7f,#11
db #0b,#fb,#93,#0a,#aa,#fb,#99,#09
db #fb,#9f,#08,#fe,#a5,#07,#fe,#a8
db #06,#aa,#fe,#ab,#05,#fe,#ae,#03
db #fe,#b1,#01,#fe,#b4,#00,#ff,#f8
db #b7,#70,#00,#fd,#c0,#fa,#50,#f7
db #c3,#ee,#c0,#e2,#56,#7f,#91,#55
db #0b,#fb,#13,#0a,#fb,#19,#09,#fb
db #1f,#08,#fe,#25,#55,#07,#fe,#28
db #06,#fe,#2b,#05,#fe,#2e,#03,#fe
db #31,#5f,#01,#fe,#34,#00,#f8,#37
db #70,#80,#fd,#40,#fa,#d0,#f7,#43
db #ea,#ee,#40,#e2,#d6,#7f,#11,#0b
db #fb,#93,#0a,#fb,#99,#09,#aa,#fb
db #9f,#08,#fe,#a5,#07,#fe,#a8,#06
db #fe,#ab,#05,#ab,#fe,#ae,#03,#fe
db #b1,#01,#fe,#b4,#00,#f8,#b7,#70
db #00,#fd,#fd,#c0,#fa,#50,#f7,#c3
db #ee,#c0,#e2,#56,#7f,#91,#0b,#fb
db #13,#55,#0a,#fb,#19,#09,#fb,#1f
db #08,#fe,#25,#07,#fe,#28,#55,#06
db #fe,#2b,#05,#fe,#2e,#03,#fe,#31
db #01,#fe,#34,#7f,#00,#f8,#37,#fb
db #81,#fe,#85,#f1,#0a,#f7,#16,#f7
db #1c,#fb,#22,#8f,#fd,#43,#1f,#1f
db #1e,#fd,#72,#f7,#70,#fd,#3d,#f1
db #70,#ff,#f1,#8b,#c1,#40,#df,#d9
db #00,#40,#00,#40,#87,#40,#f4,#bf
db #e5,#79,#fa,#c1,#e0,#f4,#91,#eb
db #d3,#40,#40,#fa,#ba,#1d,#fb,#c6
db #1c,#f2,#fe,#cc,#fd,#6e,#52,#cf
db #fb,#ca,#1c,#1b,#fb,#86,#1a,#f4
db #fe,#8c,#00,#cf,#00,#cf,#cf,#8c
db #0a,#f5,#c0,#08,#09,#44,#0a,#fe
db #bf,#09,#08,#07,#fe,#d3,#06,#06
db #cb,#f9,#cc,#f5,#cd,#06,#05,#fd
db #eb,#04,#ca,#de,#fd,#25,#78,#03
db #fe,#29,#00,#cc,#00,#cc,#6c,#cc
db #0f,#0e,#0e,#bf,#fe,#b7,#0a,#d3
db #c0,#fa,#f0,#d0,#c3,#00,#c9,#00
db #c9,#66,#c9,#1a,#0c,#0b,#0b,#00
db #c0,#86,#c0,#0d,#fe,#3d,#0a,#3f
db #09,#08,#00,#40,#00,#40,#32,#40
db #d4,#13,#30,#44,#00,#0a,#d6,#00
db #0a,#fa,#0a,#0a,#fe,#16,#07,#fe
db #19,#dc,#16,#0f,#77,#0e,#fc,#41
db #fe,#10,#f8,#47,#0b,#f8,#50,#fd
db #3a,#fa,#5b,#48,#09,#f8,#62,#08
db #08,#fd,#43,#1f,#1f,#1e,#df,#fd
db #72,#f7,#70,#00,#fe,#7f,#f1,#70
db #f1,#8b,#c1,#40,#df,#d9,#ff,#00
db #40,#00,#40,#87,#40,#f4,#bf,#e5
db #79,#c1,#e0,#f4,#91,#eb,#d3,#ea
db #00,#40,#00,#40,#c0,#40,#1d,#fb
db #40,#1c,#fb,#46,#0a,#3e,#0b,#0c
db #fe,#e6,#fe,#f8,#fb,#08,#f9,#4c
db #f5,#4d,#08,#5b,#07,#fd,#6b,#06
db #ca,#5e,#fd,#a5,#05,#fe,#a9,#00
db #4c,#c5,#00,#4c,#6c,#4c,#1f,#1f
db #1e,#fd,#42,#1d,#fb,#46,#5c,#1c
db #fe,#4c,#0c,#fe,#38,#52,#4f,#fb
db #4a,#1c,#1b,#bd,#fb,#06,#1a,#fe
db #0c,#00,#4f,#00,#4f,#cf,#0c,#00
db #d1,#40,#e0,#f4,#80,#d0,#40,#ac
db #ab,#5a,#b5,#f5,#00,#2d,#f5,#0c
db #e8,#06,#2a,#f5,#30,#63,#fb,#3c
db #6f,#33,#f5,#42,#fa,#3c,#2b,#f5
db #54,#00,#00,#4d,#00,#fa,#da,#6f
db #2c,#fe,#19,#fa,#04,#2e,#f5,#22
db #fa,#1c,#fd,#19,#fa,#13,#fb,#fd
db #10,#6d,#80,#00,#73,#00,#73,#f3
db #73,#3c,#a1,#e0,#a0,#80,#fd,#00
db #40,#00,#40,#00,#40,#00,#40,#00
db #40,#60,#40,#4c,#f5,#40,#6e,#26
db #f5,#4c,#e8,#46,#24,#f5,#70,#fa
db #6a,#f4,#10,#48,#ff,#fb,#8e,#ee
db #70,#00,#46,#00,#46,#00,#46,#00
db #46,#00,#46,#78,#46,#ae,#ee,#2d
db #5a,#f5,#40,#2d,#f5,#4c,#e8,#46
db #f4,#34,#63,#b6,#fb,#7c,#33,#f5
db #82,#fa,#7c,#2b,#f5,#94,#b8,#40
db #00,#ff,#e9,#e8,#58,#40,#00,#48
db #00,#48,#00,#48,#00,#48,#00,#48
db #00,#48,#f7,#00,#48,#38,#48,#f4
db #5e,#4c,#1c,#2a,#f5,#30,#4c,#dc
db #f4,#de,#bf,#4c,#9c,#2a,#f5,#b0
db #4c,#5c,#f4,#5e,#00,#1c,#bc,#1c
db #f4,#90,#be,#4c,#cb,#25,#41,#80
db #c0,#40,#80,#7f,#c0,#00,#80,#3f
db #5a,#ea,#f5,#c0,#f4,#f4,#e8,#c6
db #2a,#f5,#f0,#63,#fb,#fc,#33,#d5
db #f5,#02,#fa,#fc,#2b,#f5,#14,#38
db #f5,#20,#1c,#f5,#2c,#ba,#c4,#26
db #1e,#f5,#74,#00,#c0,#80,#c0,#44
db #f5,#00,#22,#da,#f5,#0c,#e8,#06
db #3a,#f5,#30,#e8,#18,#25,#f5,#54
db #3d,#ed,#f5,#60,#f4,#f4,#dc,#66
db #29,#fb,#9c,#ee,#7e,#2d,#f5,#b4
db #75,#5a,#f5,#c0,#ee,#b4,#ee,#cc
db #2a,#f5,#f0,#63,#fb,#fc,#6f,#33
db #f5,#02,#fa,#fc,#2b,#f5,#14,#00
db #c0,#00,#c0,#00,#c0,#d6,#00,#c0
db #e0,#c0,#4c,#f5,#40,#26,#f5,#4c
db #e8,#46,#24,#ef,#f5,#70,#fa,#6a
db #f4,#10,#48,#fb,#8e,#ee,#70,#00
db #46,#00,#46,#fa,#00,#46,#00,#46
db #00,#46,#78,#46,#ee,#2d,#5a,#f5
db #40,#2d,#d6,#f5,#4c,#dc,#46,#63
db #fb,#7c,#33,#f5,#82,#fa,#7c,#2b
db #fd,#f5,#94,#70,#40,#f4,#34,#4c
db #dc,#f4,#de,#4c,#9c,#2a,#f5,#b0
db #fb,#4c,#5c,#f4,#5e,#00,#1c,#00
db #1c,#0c,#1c,#2a,#f5,#70,#dc,#1c
db #5b,#38,#f5,#a0,#1c,#f5,#ac,#c4
db #a6,#1e,#f5,#f4,#00,#40,#ad,#80
db #40,#44,#f5,#80,#22,#f5,#8c,#e8
db #86,#3a,#f5,#b0,#ae,#e8,#98,#25
db #f5,#d4,#3d,#f5,#e0,#f4,#74,#dc
db #e6,#29,#d7,#fb,#1c,#ee,#fe,#2d
db #35,#34,#25,#41,#00,#c0,#c0,#80
db #ff,#f0,#c0,#80,#50,#bf,#f0,#70
db #80,#7f,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#ff,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#ff,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#ff,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#f0,#00,#00,#00,#00,#00
db #00,#01,#00,#0c,#7f,#ff,#f6,#01
db #ee,#00,#b8,#0c,#00,#06,#53,#06
db #d0,#10,#70,#83,#ff,#00,#73,#00
db #73,#e7,#7f,#ac,#eb,#94,#80,#00
db #4c,#00,#4c,#00,#4c,#ff,#00,#4c
db #00,#4c,#00,#4c,#00,#4c,#00,#4c
db #00,#4c,#00,#4c,#00,#4c,#ef,#7e
db #4c,#ee,#2d,#58,#80,#0e,#41,#29
db #00,#48,#00,#48,#00,#48,#ff,#00
db #48,#00,#48,#00,#48,#00,#48,#00
db #48,#00,#48,#00,#48,#00,#48,#ff
db #00,#48,#dc,#48,#4c,#cb,#00,#c0
db #00,#c0,#b4,#c0,#ee,#c0,#b8,#cc
db #ff,#00,#c6,#00,#c6,#00,#c6,#00
db #c6,#00,#c6,#00,#c6,#00,#c6,#00
db #c6,#ff,#00,#c6,#00,#c6,#00,#c6
db #00,#c6,#00,#c6,#e6,#25,#52,#80
db #00,#8e,#ff,#00,#8e,#00,#8e,#00
db #8e,#00,#8e,#00,#8e,#00,#8e,#00
db #8e,#a2,#8e,#f0,#4c,#4b,#00,#40
db #00,#40,#00,#10



ymlz_end

;--------------------------------------------------------------------- print infos...

print ''debut player : '',{int}init_music,''/'',{hex}init_music
print ''fin player :'',{int}player_end-1,''/'',{hex}player_end-1
print ''taille player :'',{int}player_end-init_music,''/'',{hex}player_end-init_music
print ''initialise musique call at :'',{int}init_music,''/'',{hex}init_music
print ''play musique call at :'',{int}play_music,''/'',{hex}play_music
print ''debut buffer (#100) decompression :'',{int}decrubuf,''/'',{hex}decrubuf
print ''fin buffer (#100) decompression :'',{int}decrubuf+(14*#100)-1,''/'',{hex}decrubuf+(14*#100)-1
print ''taille buffer (#100) decompression :'',{int}(decrubuf+(14*#100))-decrubuf,''/'',{hex}(decrubuf+(14*#100))-decrubuf
print ''debut data musique :'',{int}(ymlz),''/'',{hex}ymlz
print ''fin data musique :'',{int}ymlz_end-1,''/'',{hex}ymlz_end-1
print ''taille musique :'',{int}ymlz_end-ymlz,''/'',{hex}ymlz_end-ymlz',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: testzic
  SELECT id INTO tag_uuid FROM tags WHERE name = 'testzic';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
