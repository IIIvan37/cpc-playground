-- Migration: Import z80code projects batch 65
-- Projects 129 to 130
-- Generated: 2026-01-25T21:43:30.202139

-- Project 129: player-ayc (ym2ayc) by Madram
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'player-ayc (ym2ayc)',
    'Imported from z80Code. Author: Madram. ayc player for rasmlive',
    'public',
    false,
    false,
    '2021-10-17T01:07:03.919000'::timestamptz,
    '2021-10-17T01:07:03.930000'::timestamptz
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

wantloop equ 1 ; 0 = la musique ne boucle pas (routine + rapide) label fin / 1 = boucle
decrubuf equ #c000 ; doit valoir x000 ou x800 (cf attribu) / Là, ça décrunch dans l''écran...
duree equ ymlz ; indiquée dans le header

run start

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
db #c0,#1c,#01,#2e,#00,#01,#d5,#03
db #01,#11,#04,#01,#e5,#07,#01,#28
db #09,#01,#04,#0a,#01,#a6,#0a,#01
db #82,#0b,#01,#aa,#0c,#01,#a8,#0e
db #01,#61,#0f,#01,#90,#10,#01,#8c
db #12,#01,#c8,#12,#ff,#ff,#ff,#ff
db #ff,#ff,#00,#c9,#00,#00,#b2,#00
db #77,#3c,#cb,#4f,#86,#43,#f3,#86
db #24,#96,#4b,#f8,#95,#c9,#64,#c6
db #9f,#ef,#77,#99,#f8,#db,#e1,#71
db #f8,#e5,#ec,#c7,#b3,#59,#f8,#03
db #3e,#9f,#50,#f8,#0d,#f6,#95,#f6
db #1f,#f6,#8a,#f6,#7b,#64,#4f,#32
db #f8,#3f,#71,#38,#ee,#49,#f6,#03
db #d8,#65,#ec,#49,#f9,#d8,#a1,#f6
db #35,#f6,#2b,#ce,#5d,#f6,#0f,#e1
db #71,#f8,#1b,#32,#c9,#64,#f8,#25
db #ec,#07,#9f,#50,#f8,#43,#96,#7c
db #4b,#f8,#4d,#f6,#d5,#f6,#5f,#f6
db #cb,#f6,#c1,#59,#2d,#9f,#f8,#7f
db #64,#32,#ee,#89,#f6,#6b,#a1,#a5
db #f1,#5b,#f6,#4d,#c9,#f6,#25,#ce
db #27,#ef,#77,#f8,#5b,#e1,#71,#f8
db #65,#93,#ec,#47,#b3,#59,#f8,#83
db #9f,#50,#f8,#8d,#f6,#15,#e4,#f6
db #9f,#f6,#0a,#f6,#fb,#64,#32,#f8
db #bf,#71,#38,#ff,#ee,#c9,#f6,#83
db #d8,#e5,#ec,#c9,#d8,#21,#f6,#b5
db #f6,#ab,#f6,#bf,#ff,#d8,#67,#ec
db #4b,#fa,#a5,#fc,#a9,#f6,#9b,#e2
db #b7,#f6,#91,#e2,#df,#cf,#f6,#a5
db #d8,#07,#c9,#64,#f8,#31,#e2,#91
db #ce,#31,#d8,#4f,#32,#8e,#47,#f8
db #b3,#ec,#c3,#b3,#59,#f8,#d1,#71
db #7f,#38,#f8,#db,#ec,#9f,#ce,#d1
db #ce,#ef,#f6,#8b,#d8,#8b,#c4,#67
db #9f,#d8,#8f,#8e,#47,#f8,#f3,#f6
db #e9,#ce,#2b,#ce,#11,#ce,#2f,#cf
db #f6,#cb,#ec,#a5,#9f,#50,#f8,#bb
db #f6,#75,#f6,#d5,#d8,#d7,#fc,#88
db #b1,#f6,#65,#f6,#5b,#f6,#51,#fa
db #97,#de,#9b,#77,#3c,#f9,#cb,#bf
db #f1,#af,#f6,#8d,#ce,#1f,#f6,#3f
db #ef,#77,#f8,#4b,#3e,#e1,#71,#f8
db #55,#ec,#37,#e2,#79,#f6,#8f,#ec
db #b5,#64,#4f,#32,#f8,#af,#71,#38
db #ee,#b9,#f6,#73,#d8,#d5,#ec,#b9
db #f9,#d8,#11,#f6,#a5,#f6,#9b,#ce
db #cd,#f6,#7f,#e1,#71,#f8,#8b,#32
db #c9,#64,#f8,#95,#ec,#77,#9f,#50
db #f8,#b3,#96,#7c,#4b,#f8,#bd,#f6
db #45,#f6,#cf,#f6,#3b,#f6,#31,#59
db #2d,#9f,#f8,#ef,#64,#32,#ee,#f9
db #f6,#db,#a1,#15,#f1,#cb,#f6,#bd
db #c9,#f6,#95,#ce,#97,#ef,#77,#f8
db #cb,#e1,#71,#f8,#d5,#93,#ec,#b7
db #b3,#59,#f8,#f3,#9f,#50,#f8,#fd
db #f6,#85,#e4,#f6,#0f,#f6,#7a,#f6
db #6b,#64,#32,#f8,#2f,#71,#38,#ff
db #ee,#39,#f6,#f3,#d8,#55,#ec,#39
db #d8,#91,#f6,#25,#f6,#1b,#f6,#2f
db #ff,#d8,#d7,#ec,#bb,#fa,#15,#fc
db #19,#f6,#0b,#e2,#27,#f6,#01,#e2
db #4f,#cf,#f6,#15,#d8,#77,#c9,#64
db #f8,#a1,#e2,#01,#ce,#a1,#d8,#bf
db #32,#8e,#47,#f8,#23,#ec,#33,#b3
db #59,#f8,#41,#71,#7f,#38,#f8,#4b
db #ec,#0f,#ce,#41,#ce,#5f,#f6,#fb
db #d8,#fb,#c4,#d7,#9f,#d8,#ff,#8e
db #47,#f8,#63,#f6,#59,#ce,#9b,#ce
db #81,#ce,#9f,#cf,#f6,#3b,#ec,#15
db #9f,#50,#f8,#2b,#f6,#e5,#f6,#45
db #d8,#47,#fc,#88,#21,#f6,#d5,#f6
db #cb,#f6,#c1,#fa,#07,#de,#0b,#77
db #3c,#f9,#cb,#2f,#f1,#1f,#f6,#fd
db #ce,#8f,#f6,#af,#ef,#77,#f8,#bb
db #3e,#e1,#71,#f8,#c5,#ec,#a7,#e2
db #e9,#f6,#ff,#ec,#25,#64,#4f,#32
db #f8,#1f,#71,#38,#ee,#29,#f6,#e3
db #d8,#45,#ec,#29,#f9,#d8,#81,#f6
db #15,#f6,#0b,#ce,#3d,#f6,#ef,#e1
db #71,#f8,#fb,#32,#c9,#64,#f8,#05
db #ec,#e7,#9f,#50,#f8,#23,#96,#7c
db #4b,#f8,#2d,#f6,#b5,#f6,#3f,#f6
db #ab,#f6,#a1,#59,#2d,#9f,#f8,#5f
db #64,#32,#ee,#69,#f6,#4b,#a1,#85
db #f1,#3b,#f6,#2d,#c9,#f6,#05,#ce
db #07,#ef,#77,#f8,#3b,#e1,#71,#f8
db #45,#93,#ec,#27,#b3,#59,#f8,#63
db #9f,#50,#f8,#6d,#f6,#f5,#e4,#f6
db #7f,#f6,#ea,#f6,#db,#64,#32,#f8
db #9f,#71,#38,#ff,#ee,#a9,#f6,#63
db #d8,#c5,#ec,#a9,#d8,#01,#f6,#95
db #f6,#8b,#ce,#bd,#93,#f6,#6f,#e1
db #71,#f8,#7b,#c9,#64,#f8,#85,#ec
db #67,#27,#9f,#50,#f8,#a3,#96,#4b
db #f8,#ad,#f6,#35,#f6,#bf,#c9,#f6
db #2b,#f6,#21,#59,#2d,#f8,#df,#64
db #32,#ee,#e9,#f2,#f6,#cb,#d8,#05
db #f6,#d5,#d3,#37,#7f,#3f,#f3,#66
db #8e,#49,#47,#f8,#75,#be,#5f,#c6
db #7f,#e1,#71,#f8,#bb,#32,#d5,#6a
db #f8,#c5,#ec,#a7,#a9,#54,#f8,#e3
db #96,#7c,#4b,#f8,#ed,#f6,#75,#f6
db #ff,#f6,#6a,#f6,#5b,#5f,#2f,#9f
db #f8,#1f,#6a,#35,#ee,#29,#f6,#e3
db #d8,#45,#ec,#29,#d8,#81,#f2,#f6
db #15,#f6,#0b,#ce,#3d,#f6,#ef,#d5
db #6a,#f8,#fb,#be,#64,#5f,#f8,#05
db #ec,#e7,#96,#4b,#f8,#23,#8e,#47
db #f9,#f8,#2d,#f6,#b5,#f6,#3f,#f6
db #ab,#f6,#a1,#54,#2a,#f8,#5f,#3f
db #5f,#2f,#ee,#69,#f6,#4b,#a1,#85
db #f1,#3b,#f6,#2d,#f6,#05,#93,#ce
db #07,#e1,#71,#f8,#3b,#d5,#6a,#f8
db #45,#ec,#27,#27,#a9,#54,#f8,#63
db #96,#4b,#f8,#6d,#f6,#f5,#f6,#7f
db #c9,#f6,#ea,#f6,#db,#5f,#2f,#f8
db #9f,#6a,#35,#ee,#a9,#ff,#f6,#63
db #d8,#c5,#ec,#a9,#d8,#01,#f6,#95
db #f6,#8b,#f6,#9f,#d8,#47,#ff,#ec
db #2b,#fa,#85,#fc,#89,#f6,#7b,#e2
db #97,#f6,#71,#e2,#bf,#f6,#85,#c0
db #a1,#e7,#88,#47,#00,#ff,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#ff,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #f8,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#00,#00,#aa,#70,#00,#2d
db #fb,#91,#de,#fd,#97,#3f,#fb,#9b
db #fa,#aa,#fd,#a1,#66,#fb,#a5,#38
db #fd,#ab,#92,#fb,#af,#7e,#95,#fc
db #b5,#9f,#64,#f9,#bb,#18,#fb,#c3
db #53,#fd,#c9,#dd,#fc,#97,#fe,#d0
db #f6,#fd,#d3,#ce,#af,#f6,#ff,#c3
db #fb,#13,#71,#cc,#fd,#19,#f6,#f5
db #f6,#eb,#53,#d5,#86,#f9,#33,#66
db #c9,#fb,#3b,#fb,#9c,#50,#32,#f9
db #47,#f6,#91,#de,#3a,#77,#4b,#f9
db #5b,#ec,#d7,#38,#4f,#0c,#fb,#3f
db #aa,#95,#fc,#45,#6a,#43,#f9,#4b
db #66,#fb,#53,#38,#fc,#59,#3d,#8e
db #59,#f9,#5f,#38,#3f,#fe,#2f,#fc
db #30,#7e,#fc,#35,#6a,#9f,#fc,#3b
db #fc,#3e,#18,#fb,#43,#53,#fc,#49
db #d5,#6a,#86,#f9,#4f,#d8,#2f,#2d
db #fb,#7f,#de,#fc,#85,#77,#54,#4b
db #f9,#8b,#3f,#fb,#93,#fa,#fc,#99
db #7f,#50,#f5,#f9,#9f,#d8,#1b,#ec
db #7f,#24,#bb,#c3,#fb,#bf,#cc,#fc
db #c5,#2a,#b3,#71,#f9,#cb,#5a,#fb
db #d3,#bc,#fc,#d9,#ef,#75,#96,#f9
db #df,#88,#bf,#b0,#6f,#18,#fb,#af
db #53,#fc,#b5,#2a,#d5,#86,#f9,#bb
db #66,#fb,#c3,#38,#fc,#c9,#8e,#6a
db #59,#f9,#cf,#ec,#9b,#0c,#fb,#eb
db #aa,#fc,#f1,#6a,#7f,#43,#f9,#f7
db #c4,#5f,#fe,#3a,#fa,#27,#fb,#42
db #f3,#36,#de,#2d,#ff,#f1,#61,#e7
db #85,#ec,#eb,#fe,#b2,#fa,#9f,#fb
db #ba,#f6,#ab,#f9,#b4,#55,#66,#fb
db #d1,#38,#fd,#d7,#3f,#fb,#db,#fa
db #fd,#e1,#f5,#f6,#4f,#ce,#9f,#e2
db #20,#ce,#4f,#92,#fb,#71,#7e,#fd
db #77,#ff,#e2,#d1,#d8,#49,#e2,#c0
db #ce,#ef,#e2,#7b,#ce,#df,#e2,#60
db #c8,#8f,#ea,#fc,#86,#f6,#1b,#f6
db #11,#92,#fb,#cf,#7e,#fc,#d5,#9f
db #7f,#64,#f7,#db,#fa,#cf,#f8,#ea
db #fc,#d6,#f6,#ed,#88,#b1,#f6,#65
db #d4,#f6,#5b,#f6,#51,#0c,#fb,#97
db #aa,#fc,#9d,#6a,#43,#e3,#f9,#a3
db #ec,#1f,#f6,#8d,#de,#77,#4b,#f9
db #cb,#24,#ab,#52,#0c,#fb,#af,#aa
db #fc,#b5,#6a,#43,#f9,#bb,#66,#a7
db #fb,#c3,#38,#fc,#c9,#8e,#59,#f9
db #cf,#38,#af,#fe,#9f,#ad,#fc,#a0
db #7e,#fc,#a5,#9f,#fc,#ab,#fc,#ae
db #18,#fb,#b3,#4d,#53,#fc,#b9,#d5
db #86,#f9,#bf,#d8,#9f,#2d,#fb,#ef
db #4a,#de,#fc,#f5,#77,#4b,#f9,#fb
db #3f,#fb,#03,#fa,#9e,#fc,#09,#7f
db #50,#f9,#0f,#d8,#8b,#ec,#ef,#24
db #2b,#c3,#a5,#fb,#2f,#cc,#fc,#35
db #b3,#71,#f9,#3b,#5a,#fb,#43,#4e
db #bc,#fc,#49,#ef,#96,#f9,#4f,#88
db #2f,#b0,#df,#18,#a5,#fb,#1f,#53
db #fc,#25,#d5,#86,#f9,#2b,#66,#fb
db #33,#4d,#38,#fc,#39,#8e,#59,#f9
db #3f,#ec,#0b,#0c,#fb,#5b,#4f,#aa
db #fc,#61,#6a,#43,#f9,#67,#c4,#cf
db #fe,#aa,#fa,#97,#ff,#fb,#b2,#f3
db #a6,#de,#9d,#f1,#d1,#e7,#f5,#ec
db #5b,#fe,#22,#fa,#0f,#ea,#fb,#2a
db #f6,#1b,#f9,#24,#66,#fb,#41,#38
db #fd,#47,#3f,#be,#fb,#4b,#fa,#fd
db #51,#f6,#bf,#ce,#0f,#e2,#90,#ce
db #bf,#92,#bf,#fb,#e1,#7e,#fd,#e7
db #e2,#41,#d8,#b9,#e2,#30,#ce,#5f
db #e2,#eb,#fd,#ce,#4f,#e2,#d0,#c8
db #ff,#fc,#f6,#f6,#8b,#f6,#81,#92
db #fb,#3f,#4f,#7e,#fc,#45,#9f,#64
db #f7,#4b,#fa,#3f,#f8,#5a,#fc,#46
db #fa,#f6,#5d,#88,#21,#f6,#d5,#f6
db #cb,#f6,#c1,#0c,#fb,#07,#aa,#9c
db #fc,#0d,#6a,#43,#f9,#13,#ec,#8f
db #f6,#fd,#de,#77,#6a,#4b,#f9,#3b
db #24,#1b,#0c,#fb,#1f,#aa,#fc,#25
db #6a,#54,#43,#f9,#2b,#66,#fb,#33
db #38,#fc,#39,#8e,#59,#f5,#f9,#3f
db #38,#1f,#fe,#0f,#fc,#10,#7e,#fc
db #15,#9f,#fc,#1b,#a9,#fc,#1e,#18
db #fb,#23,#53,#fc,#29,#d5,#86,#f9
db #2f,#a9,#d8,#0f,#2d,#fb,#5f,#de
db #fc,#65,#77,#4b,#f9,#6b,#53,#3f
db #fb,#73,#fa,#fc,#79,#7f,#50,#f9
db #7f,#d8,#fb,#d4,#ec,#5f,#24,#9b
db #0c,#fb,#9f,#aa,#fc,#a5,#6a,#43
db #a9,#f9,#ab,#66,#fb,#b3,#38,#fc
db #b9,#8e,#59,#f9,#bf,#eb,#38,#9f
db #fe,#8f,#fc,#90,#7e,#fc,#95,#9f
db #fc,#9b,#fc,#9e,#53,#18,#fb,#a3
db #53,#fc,#a9,#d5,#86,#f9,#af,#d8
db #8f,#52,#2d,#fb,#df,#de,#fc,#e5
db #77,#4b,#f9,#eb,#3f,#a6,#fb,#f3
db #fa,#fc,#f9,#7f,#50,#f9,#ff,#ec
db #7b,#7b,#a5,#fb,#1b,#5a,#fc,#21
db #96,#5f,#f9,#27,#1c,#fb,#2f,#4d
db #c3,#fc,#35,#71,#47,#f9,#3b,#24
db #1b,#fd,#fb,#1f,#4a,#92,#fc,#25
db #64,#3f,#f9,#2b,#52,#fb,#33,#18
db #9e,#fc,#39,#86,#54,#f9,#3f,#38
db #1f,#fe,#0f,#fc,#10,#5a,#b5,#fc
db #15,#96,#fc,#1b,#fc,#1e,#fa,#fb
db #23,#24,#fc,#29,#35,#c9,#7f,#f9
db #2f,#d8,#0f,#1c,#fb,#5f,#c3,#fc
db #65,#2a,#71,#47,#f9,#6b,#2d,#fb
db #73,#de,#fc,#79,#77,#7a,#4b,#f9
db #7f,#d8,#fb,#ec,#5f,#24,#9b,#aa
db #fb,#9f,#a4,#95,#fc,#a5,#a9,#6a
db #f9,#ab,#38,#fb,#b3,#86,#fc,#b9
db #3a,#e1,#8e,#f9,#bf,#88,#9f,#b0
db #4f,#fa,#fb,#8f,#24,#95,#fc,#95
db #c9,#7f,#f9,#9b,#52,#fb,#a3,#18
db #fc,#a9,#35,#86,#54,#f9,#af,#ec
db #7b,#fd,#fb,#cb,#92,#fc,#d1,#3f
db #64,#3f,#f9,#d7,#ec,#67,#fe,#f2
db #fa,#df,#fb,#fa,#f6,#eb,#f5,#f4
db #f4,#e7,#15,#fe,#2f,#fc,#30,#86
db #fc,#35,#e1,#fc,#3b,#fc,#fa,#3e
db #fa,#2f,#fb,#4a,#f6,#3b,#f4,#44
db #a6,#65,#00,#ad,#70,#00,#01,#e7
db #91,#02,#fd,#ab,#f6,#a5,#02,#f7
db #88,#9e,#fb,#b5,#02,#03,#fd,#c9
db #c4,#a5,#e2,#ff,#f6,#eb,#03,#ff
db #ec,#82,#ec,#88,#f1,#46,#f2,#dd
db #00,#4f,#42,#4f,#f2,#21,#fb,#35
db #3f,#02,#03,#fc,#49,#c9,#26,#ec
db #0d,#ca,#0d,#aa,#df,#60,#fd,#cf
db #f2,#b1,#fb,#c5,#02,#03,#fc,#d9
db #79,#b6,#b6,#75,#d8,#23,#ff,#d2
db #73,#ca,#65,#ec,#25,#d8,#27,#f1
db #61,#dc,#85,#d3,#5a,#fc,#1a,#ff
db #b4,#8b,#a6,#87,#e7,#d7,#79,#fa
db #ba,#d1,#b0,#c7,#ec,#b6,#f6,#17
db #bf,#fc,#cb,#02,#e7,#a0,#f2,#cb
db #88,#b1,#dc,#47,#fb,#9c,#f1,#2c
db #f9,#f2,#25,#00,#97,#1a,#97,#f2
db #91,#fb,#a5,#02,#03,#fc,#b9,#fe
db #c9,#96,#ec,#7d,#ca,#7d,#aa,#4f
db #60,#6d,#f2,#21,#fb,#35,#02,#7f
db #03,#fc,#49,#79,#26,#b6,#e5,#d8
db #93,#d2,#e3,#ca,#d5,#ec,#95,#ff
db #d8,#97,#f1,#d1,#dc,#f5,#d3,#ca
db #fc,#8a,#b4,#fb,#a6,#f7,#e7,#47
db #fd,#79,#6a,#ba,#41,#b0,#37,#ec
db #26,#f6,#87,#fc,#3b,#02,#e7,#10
db #ff,#f2,#3b,#88,#21,#dc,#b7,#fb
db #0c,#f1,#9c,#f2,#95,#00,#07,#1a
db #07,#cf,#f2,#01,#fb,#15,#02,#03
db #fc,#29,#c9,#06,#ec,#ed,#ca,#ed
db #f9,#aa,#bf,#00,#dd,#70,#dd,#f2
db #81,#fb,#95,#02,#03,#fc,#a9,#ff
db #c9,#86,#ec,#6d,#ca,#6d,#aa,#3f
db #66,#5d,#f5,#05,#1b,#02,#e6,#fb
db #7f,#03,#fc,#29,#c9,#06,#ec,#ed
db #c4,#ed,#d8,#79,#38,#b5,#f2,#91
db #9f,#fb,#a5,#02,#03,#fc,#b9,#79
db #96,#b0,#55,#de,#09,#ec,#a3,#fb
db #f5,#b1,#e3,#5e,#dd,#dd,#e7,#15
db #fb,#bd,#02,#f2,#95,#fe,#42,#f0
db #fa,#2f,#f0,#bd,#f5,#45,#a6,#65
db #00,#83,#f1,#00,#85,#1b,#7f,#e3
db #47,#f1,#14,#60,#10,#3f,#e5,#d1
db #ee,#c5,#00,#b0,#00,#b0,#26,#b0
db #fb,#94,#f6,#b2,#ff,#fb,#c0,#f6
db #b7,#2e,#e0,#00,#7a,#98,#7a,#fb
db #ec,#f6,#0a,#f1,#18,#ff,#ec,#14
db #ec,#3b,#ec,#d8,#f6,#63,#f1,#00
db #dd,#37,#00,#50,#00,#50,#ff,#da
db #50,#f6,#a8,#ec,#80,#ec,#c6,#e2
db #80,#88,#c6,#ec,#bc,#e2,#8e,#ff
db #d8,#70,#00,#c0,#00,#c0,#c6,#c0
db #fb,#04,#f6,#22,#fb,#30,#f6,#27
db #ff,#2e,#50,#00,#ea,#98,#ea,#fb
db #5c,#f6,#7a,#f1,#88,#ec,#84,#ec
db #ab,#ff,#ec,#48,#f6,#d3,#f1,#70
db #dd,#a7,#00,#c0,#00,#c0,#da,#c0
db #f6,#18,#ff,#ec,#f0,#ec,#36,#e2
db #f0,#88,#36,#ec,#2c,#e2,#fe,#d8
db #e0,#00,#30,#ff,#00,#30,#c6,#30
db #fb,#74,#f6,#92,#fb,#a0,#f6,#97
db #2e,#c0,#00,#5a,#ff,#70,#5a,#fb
db #f4,#f6,#12,#fb,#20,#f6,#17,#2e
db #40,#00,#da,#70,#da,#ff,#fb,#74
db #f6,#92,#fb,#a0,#f6,#97,#2e,#c0
db #00,#5a,#98,#5a,#fc,#e0,#7f,#e3
db #f6,#cc,#f1,#ea,#ec,#cc,#fb,#08
db #f6,#1c,#ec,#b3,#e7,#30,#f0,#fb
db #f9,#ec,#b8,#dd,#4e,#d4,#93,#00
db #97,#f1,#00,#01,#02,#fe,#11,#03
db #f1,#14,#60,#10,#f0,#00,#ff,#e8
db #0c,#00,#c4,#00,#c4,#3a,#c4,#ec
db #94,#24,#d6,#00,#7a,#98,#7a,#ff
db #ec,#ec,#ce,#1d,#ec,#d8,#f6,#63
db #d8,#00,#f6,#6e,#00,#50,#00,#50
db #ff,#da,#50,#ec,#6c,#f6,#d9,#ce
db #6c,#88,#c6,#ce,#8d,#d8,#70,#00
db #c0,#ff,#00,#c0,#c6,#c0,#ec,#04
db #24,#46,#00,#ea,#98,#ea,#ec,#5c
db #ce,#8d,#ff,#ec,#48,#f6,#d3,#d8
db #70,#f6,#de,#00,#c0,#00,#c0,#da
db #c0,#ec,#dc,#ff,#f6,#49,#ce,#dc
db #88,#36,#ce,#fd,#d8,#e0,#00,#30
db #00,#30,#c6,#30,#ff,#ec,#74,#24
db #b6,#00,#5a,#70,#5a,#ec,#f4,#24
db #36,#00,#da,#70,#da,#fb,#ec,#74
db #24,#b6,#00,#5a,#98,#5a,#fc,#e0
db #02,#f2,#d6,#f5,#ee,#fe,#d8,#07
db #f1,#b8,#e7,#30,#fb,#f9,#ec,#b8
db #dd,#4e,#d4,#93,#00,#b2,#f2,#00
db #01,#f1,#00,#5b,#0b,#02,#03,#fe
db #af,#01,#ff,#f8,#c8,#00,#a9,#00
db #a9,#20,#a9,#fa,#93,#f6,#b2,#fb
db #c0,#f6,#b7,#ff,#2f,#e0,#00,#79
db #98,#79,#fa,#eb,#f6,#0a,#f1,#f1
db #ed,#14,#ec,#3a,#ff,#e5,#34,#ed
db #fc,#e8,#2d,#f5,#6d,#00,#50,#00
db #50,#da,#50,#f6,#a8,#ff,#ec,#8a
db #ed,#c6,#e1,#7f,#88,#c6,#f7,#6d
db #d7,#83,#d8,#70,#00,#c0,#ff,#00
db #c0,#c7,#c0,#fa,#03,#f6,#22,#fb
db #30,#f6,#27,#2f,#50,#00,#e9,#ff
db #98,#e9,#fa,#5b,#f6,#7a,#f1,#61
db #ed,#84,#ec,#aa,#e5,#a4,#ed,#6c
db #ff,#e8,#9d,#f5,#dd,#00,#c0,#00
db #c0,#da,#c0,#f6,#18,#ec,#fa,#ed
db #36,#ff,#e1,#ef,#88,#36,#f7,#dd
db #d7,#f3,#d8,#e0,#00,#30,#00,#30
db #c7,#30,#ff,#fa,#73,#f6,#92,#fb
db #a0,#f6,#97,#2f,#c0,#00,#59,#70
db #59,#fa,#f3,#ff,#f6,#12,#fb,#20
db #f6,#17,#2f,#40,#00,#d9,#70,#d9
db #fa,#73,#f6,#92,#ff,#fb,#a0,#f6
db #97,#2f,#c0,#00,#59,#98,#59,#fb
db #df,#f5,#cb,#f1,#ea,#ff,#ec,#cc
db #fb,#08,#f6,#1c,#f5,#10,#f3,#e1
db #ec,#34,#fa,#f8,#ec,#b8,#c0,#de
db #4e,#d3,#92,#3f,#9a,#f2,#00,#1f
db #3b,#fc,#10,#84,#01,#3d,#f7,#91
db #1d,#71,#39,#fc,#9c,#f6,#91,#e7
db #97,#19,#19,#1d,#fe,#c2,#ca,#f8
db #c8,#82,#a9,#1c,#38,#fc,#50,#3c
db #f3,#55,#1c,#1f,#18,#18,#1c,#fe
db #62,#f8,#68,#f9,#5d,#00,#50,#00
db #50,#ff,#c7,#50,#fa,#93,#f6,#b2
db #fb,#c0,#f6,#b7,#2f,#e0,#00,#79
db #98,#79,#ff,#fa,#eb,#f6,#0a,#f1
db #f1,#ed,#14,#ec,#3a,#ec,#d7,#ec
db #45,#f2,#27,#4f,#3e,#f1,#85,#1e
db #3a,#fc,#96,#fc,#91,#ca,#4f,#e5
db #ad,#ff,#00,#50,#2a,#50,#f6,#a8
db #ed,#80,#ec,#c5,#e1,#7f,#88,#c6
db #f7,#b2,#ff,#d7,#83,#d8,#70,#00
db #c0,#00,#c0,#c7,#c0,#fa,#03,#f6
db #22,#fb,#30,#ff,#f6,#27,#2f,#50
db #00,#e9,#98,#e9,#fa,#5b,#f6,#7a
db #f1,#61,#ed,#84,#f4,#ec,#aa,#ec
db #47,#ec,#b5,#f2,#97,#3e,#f1,#f5
db #1e,#3a,#ff,#fc,#06,#fc,#01,#ca
db #bf,#e5,#1d,#00,#c0,#2a,#c0,#f6
db #18,#ed,#f0,#ff,#ec,#35,#e1,#ef
db #88,#36,#f7,#22,#d7,#f3,#d8,#e0
db #00,#30,#00,#30,#ff,#c7,#30,#fa
db #73,#f6,#92,#fb,#a0,#f6,#97,#2f
db #c0,#00,#59,#70,#59,#ff,#fa,#f3
db #f6,#12,#fb,#20,#f6,#17,#2f,#40
db #00,#d9,#70,#d9,#fa,#73,#ff,#f6
db #92,#fb,#a0,#f6,#97,#2f,#c0,#00
db #59,#98,#59,#fb,#df,#f5,#cb,#d0
db #f1,#ea,#f3,#cc,#3e,#fb,#15,#1e
db #1a,#1a,#1e,#f4,#f4,#1a,#fc,#2a
db #f1,#b7,#f6,#2f,#3d,#fc,#48,#1d
db #39,#e9,#fc,#4e,#f7,#49,#f7,#4d
db #3f,#f6,#65,#1f,#3b,#fc,#71,#e0
db #f7,#6c,#f6,#70,#c9,#88,#00,#d5
db #00,#00,#b2,#00,#0e,#fa,#4f,#0d
db #fa,#56,#0c,#fb,#5d,#e5,#dd,#4f
db #e7,#77,#ec,#63,#0c,#0b,#fa,#b4
db #0a,#fa,#bb,#55,#09,#fa,#c2,#08
db #fa,#c9,#07,#fa,#d0,#06,#fd,#d7
db #fe,#ec,#95,#e2,#63,#c4,#e5,#d8
db #4f,#e2,#b3,#d8,#49,#e2,#a3,#0f
db #f7,#fa,#d5,#f9,#cb,#d2,#61,#fa
db #10,#06,#fd,#17,#ce,#35,#c4,#25
db #fe,#d8,#a3,#e2,#f3,#d8,#89,#f1
db #e3,#e7,#f7,#ce,#9d,#fa,#50,#06
db #fd,#fd,#57,#ce,#75,#c4,#65,#d8
db #cf,#e2,#33,#d8,#c9,#0f,#fa,#37
db #ff,#f3,#23,#d8,#b5,#d8,#f1,#c4
db #4b,#e2,#37,#e2,#19,#ba,#73,#92
db #4f,#ff,#ec,#f5,#de,#a9,#fa,#c8
db #ce,#db,#d8,#f9,#c4,#bd,#92,#8f
db #ce,#67,#e5,#f6,#04,#66,#a3,#fa
db #ab,#0c,#0b,#fa,#e4,#0a,#fa,#eb
db #57,#09,#fa,#f2,#08,#fa,#f9,#07
db #88,#b1,#ba,#01,#ec,#97,#f7,#dd
db #bf,#e7,#e7,#ce,#1f,#fa,#40,#06
db #fd,#47,#d8,#83,#ba,#4b,#f7,#d8
db #bf,#e2,#23,#d8,#b9,#e2,#13,#0f
db #fa,#45,#f9,#3b,#d2,#d1,#bf,#fa
db #80,#06,#fd,#87,#ce,#a5,#c4,#95
db #d8,#13,#e2,#63,#d8,#f9,#f7,#f1
db #53,#e7,#67,#ce,#0d,#fa,#c0,#06
db #fd,#c7,#ce,#e5,#c4,#d5,#ef,#d8
db #3f,#e2,#a3,#d8,#39,#0f,#fa,#a7
db #f3,#93,#d8,#25,#d8,#61,#ff,#c4
db #bb,#e2,#a7,#e2,#89,#ba,#e3,#92
db #bf,#ec,#65,#de,#19,#fa,#38,#ff
db #ce,#4b,#d8,#69,#c4,#2d,#92,#ff
db #ce,#d7,#f6,#74,#66,#13,#fa,#1b
db #2a,#0c,#0b,#fa,#54,#0a,#fa,#5b
db #09,#fa,#62,#08,#bf,#fa,#69,#07
db #88,#21,#ba,#71,#ec,#07,#dd,#2f
db #e7,#57,#ce,#8f,#bf,#fa,#b0,#06
db #fd,#b7,#d8,#f3,#ba,#bb,#d8,#2f
db #e2,#93,#d8,#29,#bd,#e2,#83,#0f
db #fa,#b5,#f9,#ab,#d2,#41,#fa,#f0
db #06,#fd,#f7,#ff,#ce,#15,#c4,#05
db #d8,#83,#e2,#d3,#d8,#69,#f1,#c3
db #e7,#d7,#ce,#7d,#bf,#fa,#30,#06
db #fd,#37,#ce,#55,#c4,#45,#d8,#af
db #e2,#13,#d8,#a9,#bd,#e2,#03,#0f
db #fa,#35,#f9,#2b,#d2,#c1,#fa,#70
db #06,#fd,#77,#ff,#ce,#95,#c4,#85
db #d8,#03,#e2,#53,#d8,#e9,#f1,#43
db #e7,#57,#ce,#fd,#bf,#fa,#b0,#06
db #fd,#b7,#ce,#d5,#c4,#c5,#d8,#2f
db #e2,#93,#d8,#29,#bd,#e2,#83,#0f
db #fa,#b5,#f9,#ab,#d2,#41,#fa,#f0
db #06,#fd,#f7,#ff,#ce,#15,#c4,#05
db #d8,#83,#e2,#d3,#d8,#69,#f1,#c3
db #e7,#d7,#ce,#7d,#bf,#fa,#30,#06
db #fd,#37,#ce,#55,#c4,#45,#d8,#af
db #e2,#13,#d8,#a9,#7f,#0f,#fa,#17
db #f3,#03,#d8,#95,#d8,#d1,#c4,#2b
db #e2,#17,#e2,#f9,#d5,#e2,#53,#fa
db #10,#06,#fa,#17,#05,#fa,#1e,#04
db #fa,#25,#55,#03,#fa,#2c,#02,#fa
db #33,#01,#fa,#3a,#00,#82,#41,#00
db #ae,#70,#00,#10,#fb,#91,#0d,#fd
db #97,#e2,#91,#fe,#b8,#0c,#9f,#fb
db #bb,#0b,#0b,#ba,#9b,#c4,#91,#00
db #31,#00,#31,#00,#31,#ea,#00,#31
db #0a,#31,#fc,#3a,#0a,#fb,#3f,#09
db #fb,#45,#08,#ea,#fd,#4b,#d8,#27
db #fe,#76,#07,#fb,#79,#06,#fb,#7f
db #00,#ff,#e7,#85,#ce,#4f,#f6,#9f
db #e2,#d1,#00,#59,#0c,#59,#d8,#b1
db #9c,#c5,#fe,#ce,#01,#00,#97,#00
db #97,#00,#97,#00,#97,#00,#97,#fc
db #aa,#0a,#ae,#fb,#af,#09,#fb,#b5
db #08,#fd,#bb,#d8,#97,#fe,#e6,#07
db #af,#fb,#e9,#06,#fb,#ef,#00,#e7
db #f5,#ce,#bf,#f6,#0f,#e2,#41,#ff
db #00,#c9,#0c,#c9,#d8,#21,#9c,#35
db #ce,#71,#00,#07,#00,#07,#00,#07
db #fe,#00,#07,#00,#07,#00,#07,#00
db #07,#00,#07,#00,#07,#36,#07,#0e
db #ea,#fb,#e5,#f2,#d1,#fc,#f8,#0a
db #fb,#fd,#09,#fb,#03,#08,#ae,#fb
db #09,#07,#fb,#0f,#00,#e7,#15,#ec
db #cb,#e4,#f9,#06,#e0,#fb,#5f,#e6
db #15,#bf,#7e,#00,#81,#f2,#00,#0f
db #0e,#0d,#0c,#0b,#0a,#52,#01,#c0
db #fe,#b0,#fe,#b3,#09,#09,#08,#07
db #06,#05,#1f,#04,#03,#01,#00,#a8
db #00,#a8,#1f,#a8,#fe,#a9,#fe,#96
db #7f,#08,#fb,#93,#f6,#93,#f6,#b6
db #2e,#df,#00,#79,#98,#79,#fb,#eb
db #ff,#f6,#09,#f1,#f0,#ec,#13,#ec
db #3a,#ec,#d7,#ec,#45,#e2,#27,#f6
db #6d,#ff,#00,#4f,#00,#4f,#da,#4f
db #f6,#a7,#ec,#7f,#fe,#cf,#fd,#d2
db #fe,#c8,#f7,#fd,#cb,#d8,#75,#88
db #c5,#fe,#b0,#02,#f9,#b3,#ec,#a7
db #ec,#83,#fe,#ec,#6f,#ea,#97,#00
db #c1,#00,#c1,#c8,#c1,#fe,#19,#fe
db #06,#08,#ff,#fb,#03,#f6,#03,#f6
db #26,#2e,#4f,#00,#e9,#98,#e9,#fb
db #5b,#f6,#79,#ff,#f1,#60,#ec,#83
db #ec,#aa,#ec,#47,#ec,#b5,#e2,#97
db #f6,#dd,#00,#bf,#ff,#00,#bf,#da
db #bf,#f6,#17,#ec,#ef,#fe,#3f,#fd
db #42,#fe,#38,#fd,#3b,#ef,#d8,#e5
db #88,#35,#fe,#20,#02,#f9,#23,#ec
db #17,#ec,#f3,#ec,#df,#fd,#ea,#07
db #00,#31,#00,#31,#c8,#31,#fe,#89
db #fe,#76,#08,#fb,#73,#fe,#f6,#73
db #f6,#96,#2e,#bf,#00,#59,#70,#59
db #fe,#09,#fe,#f6,#08,#ff,#fb,#f3
db #f6,#f3,#f6,#16,#2e,#3f,#00,#d9
db #70,#d9,#fe,#89,#fe,#76,#7f,#08
db #fb,#73,#f6,#73,#f6,#96,#2e,#bf
db #00,#59,#a2,#59,#fc,#b9,#ff,#fe
db #d0,#fa,#c7,#fd,#e0,#fe,#ea,#fd
db #e2,#fb,#d1,#fb,#e9,#f6,#cb,#ff
db #ec,#cb,#fb,#07,#fb,#1b,#fe,#b7
db #fd,#fa,#fd,#f0,#fe,#0e,#f1,#b7
db #bf,#fb,#30,#09,#f7,#35,#f6,#2f
db #fb,#4e,#ea,#b7,#f8,#40,#f9,#f8
db #c0,#f3,#40,#ce,#8d,#00,#b6,#70
db #00,#13,#fb,#91,#fc,#8d,#14,#fb
db #9b,#fc,#97,#16,#db,#fb,#a5,#fc
db #a1,#19,#fb,#af,#f2,#83,#22,#fb
db #c3,#fc,#bf,#77,#1e,#fb,#cd,#ca
db #ab,#f6,#ff,#1c,#fb,#13,#f2,#f1
db #f6,#eb,#be,#f6,#30,#0d,#fb,#3b
db #e8,#83,#f6,#58,#ec,#d7,#38,#4f
db #11,#df,#fb,#3f,#f2,#31,#16,#fb
db #53,#2a,#31,#fe,#2f,#fc,#30,#f2
db #21,#6d,#22,#fb,#43,#ca,#21,#13
db #fb,#7f,#f2,#71,#14,#fb,#93,#ed
db #ca,#0d,#ec,#7f,#24,#bb,#1c,#fb
db #bf,#f2,#b1,#26,#fb,#d3,#db,#7a
db #b1,#b0,#6f,#22,#fb,#af,#f2,#a1
db #16,#fb,#c3,#de,#8d,#7f,#11,#fb
db #eb,#b6,#51,#ec,#3a,#d8,#27,#d8
db #76,#ec,#eb,#e2,#b2,#6f,#16,#fb
db #d1,#fc,#cd,#14,#fb,#db,#f2,#4b
db #ce,#9f,#b0,#31,#7f,#19,#fb,#71
db #de,#cd,#ba,#98,#ce,#ef,#e2,#7b
db #ce,#df,#e2,#60,#f7,#ce,#8f,#f6
db #7f,#f6,#1b,#f6,#11,#19,#fb,#cf
db #e8,#99,#f6,#cf,#fb,#f6,#ed,#88
db #b1,#f6,#65,#f6,#5b,#f6,#51,#11
db #fb,#97,#e8,#2f,#ed,#f6,#b4,#f6
db #8d,#1a,#a1,#11,#fb,#af,#f2,#a1
db #16,#fb,#c3,#f6,#2a,#a1,#fe,#9f
db #fc,#a0,#f2,#91,#22,#fb,#b3,#ca
db #91,#13,#de,#fb,#ef,#f2,#e1,#14
db #fb,#03,#ca,#7d,#ec,#ef,#24,#2b
db #1c,#dd,#fb,#2f,#f2,#21,#26,#fb
db #43,#7a,#21,#b0,#df,#22,#fb,#1f
db #b7,#f2,#11,#16,#fb,#33,#de,#fd
db #11,#fb,#5b,#b6,#c1,#ec,#aa,#f6
db #d8,#97,#d8,#e6,#ec,#5b,#e2,#22
db #16,#fb,#41,#fc,#3d,#14,#f7,#fb
db #4b,#f2,#bb,#ce,#0f,#b0,#a1,#19
db #fb,#e1,#de,#3d,#ba,#08,#ff,#ce
db #5f,#e2,#eb,#ce,#4f,#e2,#d0,#ce
db #ff,#f6,#ef,#f6,#8b,#f6,#81,#7f
db #19,#fb,#3f,#e8,#09,#f6,#3f,#f6
db #5d,#88,#21,#f6,#d5,#f6,#cb,#be
db #f6,#c1,#11,#fb,#07,#e8,#9f,#f6
db #24,#f6,#fd,#1a,#11,#11,#df,#fb
db #1f,#f2,#11,#16,#fb,#33,#2a,#11
db #fe,#0f,#fc,#10,#f2,#01,#6d,#22
db #fb,#23,#ca,#01,#13,#fb,#5f,#f2
db #51,#14,#fb,#73,#ed,#ca,#ed,#ec
db #5f,#24,#9b,#11,#fb,#9f,#f2,#91
db #16,#fb,#b3,#f6,#2a,#91,#fe,#8f
db #fc,#90,#f2,#81,#22,#fb,#a3,#ca
db #81,#13,#db,#fb,#df,#f2,#d1,#14
db #fb,#f3,#de,#6d,#18,#fb,#1b,#f2
db #0d,#6d,#12,#fb,#2f,#16,#0d,#10
db #fb,#1f,#f2,#11,#15,#fb,#33,#f6
db #2a,#11,#fe,#0f,#fc,#10,#f2,#01
db #20,#fb,#23,#ca,#01,#12,#de,#fb
db #5f,#f2,#51,#13,#fb,#73,#ca,#ed
db #ec,#5f,#24,#9b,#1b,#dd,#fb,#9f
db #f2,#91,#24,#fb,#b3,#7a,#91,#b0
db #4f,#20,#fb,#8f,#b7,#f2,#81,#15
db #fb,#a3,#de,#6d,#10,#fb,#cb,#de
db #59,#c4,#f2,#f0,#fe,#2f,#fc,#30
db #b6,#e5,#bf,#7e,#00,#ff,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#ff,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #f8,#00,#00,#00,#00,#00,#00,#00
db #00,#41,#00,#00,#5f,#ff,#71,#01
db #0a,#fb,#8c,#fc,#00,#e2,#91,#d8
db #87,#ce,#87,#ff,#ce,#c3,#00,#31
db #00,#31,#00,#31,#00,#31,#0a,#31
db #ec,#3a,#d8,#27,#ff,#d8,#76,#ce
db #4f,#f6,#9f,#e2,#d1,#00,#59,#0c
db #59,#d8,#b1,#9c,#c5,#ff,#ce,#01
db #00,#97,#00,#97,#00,#97,#00,#97
db #00,#97,#ec,#aa,#d8,#97,#ff,#d8
db #e6,#ce,#bf,#f6,#0f,#e2,#41,#00
db #c9,#0c,#c9,#d8,#21,#9c,#35,#ff
db #ce,#71,#00,#07,#00,#07,#00,#07
db #00,#07,#00,#07,#00,#07,#00,#07
db #fc,#00,#07,#00,#07,#28,#07,#c4
db #f2,#b0,#df,#bf,#7e

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

  -- Add category tag: music-player-ym2ayc
  SELECT id INTO tag_uuid FROM tags WHERE name = 'music-player-ym2ayc';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 130: test-fugitif by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test-fugitif',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-10-04T22:10:41.874000'::timestamptz,
    '2021-10-04T22:10:41.887000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';Sample Test
loop:
 LD A,R
 AND 31
 OR #40
 ld bc, #7f10
 Out (c),c
 out (c),a
 jr loop
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
