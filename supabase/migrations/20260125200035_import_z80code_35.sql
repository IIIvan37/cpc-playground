-- Migration: Import z80code projects batch 35
-- Projects 69 to 70
-- Generated: 2026-01-25T21:43:30.193459

-- Project 69: savage-v3 by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'savage-v3',
    'Imported from z80Code. Author: tronic. P''tite zic...',
    'public',
    false,
    false,
    '2022-05-12T12:10:42.430000'::timestamptz,
    '2022-05-12T12:10:42.443000'::timestamptz
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
; dump hexa follow...
db #c0,#12,#01,#2e,#00,#01,#e3,#03
db #01,#2c,#06,#01,#f5,#08,#01,#4b
db #09,#01,#a4,#0a,#01,#fe,#0a,#01
db #53,#0b,#01,#b0,#0b,#01,#26,#0d
db #01,#97,#0e,#01,#5a,#0f,#01,#81
db #0f,#01,#a8,#0f,#ff,#ff,#ff,#ff
db #ff,#ff,#18,#38,#18,#7b,#fd,#02
db #f4,#00,#fa,#11,#1c,#2d,#3f,#11
db #66,#7b,#c3,#fa,#18,#5a,#5a,#aa
db #fd,#26,#f4,#f4,#0c,#ee,#24,#f4
db #18,#fe,#53,#3f,#fd,#56,#92,#92
db #78,#1c,#fd,#5c,#ee,#00,#fa,#6c
db #f4,#48,#cc,#cc,#fa,#e3,#fd,#86
db #fa,#36,#fa,#8f,#0c,#0c,#be,#fd
db #98,#e8,#3c,#18,#31,#31,#f6,#fd
db #b6,#fa,#9c,#24,#24,#38,#f3,#f1
db #c2,#fa,#5a,#e8,#48,#f4,#ef,#52
db #8e,#f6,#fd,#f4,#d8,#fe,#fa,#c0
db #fa,#ea,#ac,#c0,#f4,#6e,#fa,#ba
db #f4,#80,#ee,#a2,#5a,#3f,#5a,#aa
db #fd,#a6,#f4,#8c,#ee,#a4,#e8,#38
db #ee,#80,#fa,#ec,#8e,#f4,#c8,#cc
db #cc,#fa,#fd,#06,#fa,#b6,#fa,#0f
db #0c,#31,#0c,#be,#fd,#18,#e8,#bc
db #31,#31,#f6,#fd,#36,#8f,#fa,#1c
db #24,#24,#38,#f1,#42,#fa,#da,#e8
db #c8,#f4,#6f,#3f,#52,#8e,#f6,#7d
db #f4,#58,#fa,#40,#fa,#6a,#ac,#40
db #f4,#ee,#e3,#fa,#3a,#f4,#00,#ee
db #22,#5a,#5a,#aa,#fd,#26,#f4,#0c
db #f8,#ee,#24,#e8,#b8,#ee,#00,#fa
db #6c,#f4,#48,#cc,#cc,#fa,#e3,#fd
db #86,#fa,#36,#fa,#8f,#0c,#0c,#be
db #fd,#98,#e8,#3c,#18,#31,#31,#f6
db #fd,#b6,#fa,#9c,#24,#24,#38,#f3
db #f1,#c2,#fa,#5a,#e8,#48,#f4,#ef
db #52,#8e,#f6,#fd,#f4,#d8,#fe,#fa
db #c0,#fa,#ea,#ac,#c0,#f4,#6e,#fa
db #ba,#f4,#80,#ee,#a2,#5a,#3f,#5a
db #aa,#fd,#a6,#f4,#8c,#ee,#a4,#e8
db #38,#ee,#80,#fa,#ec,#8e,#f4,#c8
db #cc,#cc,#fa,#fd,#06,#fa,#b6,#fa
db #0f,#0c,#31,#0c,#be,#fd,#18,#e8
db #bc,#31,#31,#f6,#fd,#36,#8f,#fa
db #1c,#24,#24,#38,#f1,#42,#fa,#da
db #e8,#c8,#f4,#6f,#3f,#52,#8e,#f6
db #7d,#f4,#58,#fa,#40,#fa,#6a,#ac
db #40,#f4,#ee,#e3,#fa,#3a,#f4,#00
db #ee,#22,#5a,#5a,#aa,#fd,#26,#f4
db #0c,#f8,#ee,#24,#e8,#b8,#ee,#00
db #fa,#6c,#f4,#48,#cc,#cc,#fa,#e3
db #fd,#86,#fa,#36,#fa,#8f,#0c,#0c
db #be,#fd,#98,#e8,#3c,#18,#31,#31
db #f6,#fd,#b6,#fa,#9c,#24,#24,#38
db #f3,#f1,#c2,#fa,#5a,#e8,#48,#f4
db #ef,#52,#8e,#f6,#fd,#f4,#d8,#fe
db #fa,#c0,#fa,#ea,#ac,#c0,#f4,#6e
db #fa,#ba,#f4,#80,#ee,#a2,#5a,#3f
db #5a,#aa,#fd,#a6,#f4,#8c,#ee,#a4
db #e8,#38,#ee,#80,#fa,#ec,#8e,#f4
db #c8,#cc,#cc,#fa,#fd,#06,#fa,#b6
db #fa,#0f,#0c,#31,#0c,#be,#fd,#18
db #e8,#bc,#31,#31,#f6,#fd,#36,#8f
db #fa,#1c,#24,#24,#38,#f1,#42,#fa
db #da,#e8,#c8,#f4,#6f,#3f,#52,#8e
db #f6,#7d,#f4,#58,#fa,#40,#fa,#6a
db #ac,#40,#f4,#ee,#e3,#fa,#3a,#f4
db #00,#ee,#22,#5a,#5a,#aa,#fd,#26
db #f4,#0c,#f8,#ee,#24,#e8,#b8,#ee
db #00,#fa,#6c,#f4,#48,#cc,#cc,#fa
db #e3,#fd,#86,#fa,#36,#fa,#8f,#0c
db #0c,#be,#fd,#98,#e8,#3c,#18,#31
db #31,#f6,#fd,#b6,#fa,#9c,#24,#24
db #38,#f3,#f1,#c2,#fa,#5a,#e8,#48
db #f4,#ef,#52,#8e,#f6,#fd,#f4,#d8
db #fe,#fa,#c0,#fa,#ea,#ac,#c0,#f4
db #6e,#fa,#ba,#f4,#80,#ee,#a2,#5a
db #3f,#5a,#aa,#fd,#a6,#f4,#8c,#ee
db #a4,#e8,#38,#ee,#80,#fa,#ec,#8e
db #f4,#c8,#cc,#cc,#fa,#fd,#06,#fa
db #b6,#fa,#0f,#0c,#31,#0c,#be,#fd
db #18,#e8,#bc,#31,#31,#f6,#fd,#36
db #8f,#fa,#1c,#24,#24,#38,#f1,#42
db #fa,#da,#e8,#c8,#f4,#6f,#3f,#52
db #8e,#f6,#7d,#f4,#58,#fa,#40,#fa
db #6a,#ac,#40,#f4,#ee,#e3,#fa,#3a
db #f4,#00,#ee,#22,#5a,#5a,#aa,#fd
db #26,#f4,#0c,#f8,#ee,#24,#e8,#b8
db #ee,#00,#fa,#6c,#f4,#48,#cc,#cc
db #fa,#e3,#fd,#86,#fa,#36,#fa,#8f
db #0c,#0c,#be,#fd,#98,#e8,#3c,#18
db #31,#31,#f6,#fd,#b6,#fa,#9c,#24
db #24,#38,#f3,#f1,#c2,#fa,#5a,#e8
db #48,#f4,#ef,#52,#8e,#f6,#fd,#f4
db #d8,#fe,#fa,#c0,#fa,#ea,#ac,#c0
db #f4,#6e,#fa,#ba,#f4,#80,#ee,#a2
db #5a,#3f,#5a,#aa,#fd,#a6,#f4,#8c
db #ee,#a4,#e8,#38,#ee,#80,#fa,#ec
db #8e,#f4,#c8,#cc,#cc,#fa,#fd,#06
db #fa,#b6,#fa,#0f,#0c,#31,#0c,#be
db #fd,#18,#e8,#bc,#31,#31,#f6,#fd
db #36,#8f,#fa,#1c,#24,#24,#38,#f1
db #42,#fa,#da,#e8,#c8,#f4,#6f,#3f
db #52,#8e,#f6,#7d,#f4,#58,#fa,#40
db #fa,#6a,#ac,#40,#f4,#ee,#e3,#fa
db #3a,#f4,#00,#ee,#22,#5a,#5a,#aa
db #fd,#26,#f4,#0c,#f8,#ee,#24,#e8
db #b8,#ee,#00,#fa,#6c,#f4,#48,#cc
db #cc,#fa,#e3,#fd,#86,#fa,#36,#fa
db #8f,#0c,#0c,#be,#fd,#98,#e8,#3c
db #1c,#31,#31,#f6,#fd,#b6,#e8,#60
db #52,#12,#24,#24,#79,#38,#f1,#82
db #fa,#1a,#e8,#08,#f4,#af,#52,#8e
db #f6,#bd,#f8,#f4,#98,#fa,#80,#fa
db #aa,#ac,#80,#f4,#2e,#de,#de,#52
db #ff,#fd,#42,#f4,#40,#fa,#51,#f4
db #34,#fa,#7a,#f4,#4c,#ee,#64,#f4
db #58,#8f,#fa,#0a,#66,#66,#fd,#fd
db #9c,#ee,#40,#fa,#ac,#f4,#88,#38
db #7e,#7e,#fd,#03,#f9,#63,#fa,#cf
db #ef,#ef,#a9,#c6,#fd,#d8,#e8,#7c
db #bc,#bc,#a4,#fd,#f6,#fa,#dc,#cc
db #3c,#cc,#fa,#f1,#02,#fa,#9a,#e8
db #88,#f4,#2f,#52,#8e,#fc,#f6,#3d
db #f4,#18,#fa,#00,#fa,#2a,#ac,#00
db #f4,#ae,#02,#3f,#02,#01,#fd,#02
db #f4,#00,#ee,#11,#ee,#06,#e2,#06
db #e8,#18,#d9,#e8,#36,#ec,#6c,#00
db #fd,#98,#e8,#3c,#04,#04,#fe,#9c
db #cf,#fc,#b7,#fc,#b0,#03,#03,#fa
db #b6,#f6,#c7,#de,#3e,#f3,#8f,#ff
db #f9,#00,#f4,#f1,#fa,#c0,#f4,#0e
db #b2,#c6,#e8,#78,#e8,#30,#ee,#86
db #fc,#e2,#86,#e2,#74,#ee,#bc,#ec
db #ec,#fc,#64,#e8,#bc,#04,#04,#e7
db #fe,#1c,#fc,#37,#fc,#30,#03,#03
db #fa,#36,#f6,#47,#de,#be,#ff,#f3
db #0f,#f9,#80,#f4,#71,#fa,#40,#f4
db #8e,#b2,#46,#e8,#f8,#e8,#b0,#fe
db #ee,#06,#e2,#06,#e2,#f4,#ee,#3c
db #ec,#6c,#fc,#e4,#e8,#3c,#04,#73
db #04,#fe,#9c,#fc,#b7,#fc,#b0,#03
db #03,#fa,#b6,#f6,#c7,#ff,#de,#3e
db #f3,#8f,#f9,#00,#f4,#f1,#fa,#c0
db #f4,#0e,#b2,#c6,#e8,#78,#ff,#e8
db #30,#ee,#86,#e2,#86,#e2,#74,#ee
db #bc,#ec,#ec,#fc,#64,#e8,#bc,#39
db #04,#04,#fe,#1c,#fc,#37,#fc,#30
db #03,#03,#fa,#36,#ff,#f6,#47,#de
db #be,#f3,#0f,#f9,#80,#f4,#71,#fa
db #40,#f4,#8e,#b2,#46,#ff,#e8,#f8
db #e8,#b0,#ee,#06,#e2,#06,#e2,#f4
db #ee,#3c,#ec,#6c,#fc,#e4,#9c,#e8
db #3c,#04,#04,#fe,#9c,#fc,#b7,#fc
db #b0,#03,#03,#ff,#fa,#b6,#f6,#c7
db #de,#3e,#f3,#8f,#f9,#00,#f4,#f1
db #fa,#c0,#f4,#0e,#ff,#b2,#c6,#e8
db #78,#e8,#30,#ee,#86,#e2,#86,#e2
db #74,#ee,#bc,#ec,#ec,#ce,#fc,#64
db #e8,#bc,#04,#04,#fe,#1c,#fc,#37
db #fc,#30,#03,#7f,#03,#fa,#36,#f6
db #47,#de,#be,#f3,#0f,#f9,#80,#f4
db #71,#fa,#40,#ff,#f4,#8e,#b2,#46
db #e8,#f8,#e8,#b0,#ee,#06,#e2,#06
db #e2,#f4,#ee,#3c,#e7,#ec,#6c,#fc
db #e4,#e8,#3c,#04,#04,#fe,#9c,#fc
db #b7,#fc,#b0,#3f,#03,#03,#fa,#b6
db #f6,#c7,#de,#3e,#f3,#8f,#f9,#00
db #f4,#f1,#ff,#fa,#c0,#f4,#0e,#b2
db #c6,#e8,#78,#e8,#30,#ee,#86,#e2
db #86,#e2,#74,#f3,#ee,#bc,#ec,#ec
db #fc,#64,#e8,#bc,#04,#04,#fe,#1c
db #fc,#37,#9f,#fc,#30,#03,#03,#fa
db #36,#f6,#47,#de,#be,#f3,#0f,#f9
db #80,#ff,#f4,#71,#fa,#40,#f4,#8e
db #b2,#46,#e8,#f8,#e8,#b0,#ee,#06
db #e2,#06,#f9,#e2,#f4,#ee,#3c,#ec
db #6c,#fc,#e4,#e8,#3c,#04,#04,#fe
db #9c,#cf,#fc,#b7,#fc,#b0,#03,#03
db #fa,#b6,#f6,#c7,#de,#3e,#f3,#8f
db #ff,#f9,#00,#f4,#f1,#fa,#c0,#f4
db #0e,#b2,#c6,#e8,#78,#e8,#30,#ee
db #86,#fc,#e2,#86,#e2,#74,#ee,#bc
db #ec,#ec,#fc,#64,#e8,#bc,#04,#04
db #e7,#fe,#1c,#fc,#37,#fc,#30,#03
db #03,#fa,#36,#f6,#47,#de,#be,#ff
db #f3,#0f,#f9,#80,#f4,#71,#fa,#40
db #f4,#8e,#b2,#46,#e8,#f8,#e8,#b0
db #fe,#ee,#06,#e2,#06,#e2,#f4,#ee
db #3c,#ec,#6c,#fc,#e4,#e8,#3c,#04
db #73,#04,#fe,#9c,#fc,#b7,#3c,#fc
db #03,#03,#fa,#76,#f6,#87,#ff,#de
db #fe,#f3,#4f,#f9,#c0,#f4,#b1,#fa
db #80,#f4,#ce,#b2,#86,#d0,#33,#fc
db #ee,#f0,#da,#f0,#d8,#24,#fa,#76
db #f4,#76,#e2,#22,#03,#03,#ff,#fe
db #ca,#f8,#ca,#ec,#76,#e8,#d8,#fa
db #d6,#f6,#31,#f4,#2b,#ec,#6a,#e0
db #fc,#44,#ac,#00,#f4,#b3,#00,#e1
db #00,#00,#00,#00,#01,#00,#fd,#fd
db #7f,#7f,#fe,#00,#86,#fa,#00,#d5
db #d5,#6a,#6a,#fe,#0c,#fa,#0c,#be
db #1c,#be,#5f,#5f,#fe,#18,#fa,#18
db #f4,#0c,#9f,#9f,#38,#50,#50,#fe
db #30,#f4,#30,#f4,#18,#1c,#1c,#8e
db #7e,#8e,#fe,#4e,#fa,#2a,#f4,#00
db #dc,#06,#ee,#30,#fe,#50,#47,#73
db #47,#fe,#9c,#fa,#9c,#fe,#68,#3f
db #3f,#fe,#a8,#fa,#a8,#98,#fe,#86
db #35,#35,#fe,#b4,#fa,#b4,#71,#71
db #38,#7f,#38,#fe,#c0,#f4,#c0,#f4
db #9c,#fa,#d8,#fd,#96,#ee,#d2,#f1
db #f3,#ff,#e8,#90,#ee,#b4,#f4,#a8
db #fa,#38,#e2,#14,#fa,#5c,#fa,#56
db #fe,#80,#33,#2f,#2f,#fe,#6e,#f4
db #6e,#fd,#fd,#fe,#42,#fe,#80,#9c
db #fa,#80,#d5,#d5,#fe,#6c,#fe,#8c
db #fa,#8c,#be,#be,#fe,#fe,#7e,#fe
db #98,#fa,#98,#f4,#8c,#f4,#08,#fa
db #b6,#f4,#98,#1c,#7f,#1c,#fe,#4e
db #fe,#ce,#fa,#aa,#f4,#80,#dc,#86
db #ee,#b0,#f4,#44,#f3,#f4,#38,#f4
db #50,#ee,#6e,#fe,#24,#24,#24,#fe
db #52,#f7,#52,#bb,#fe,#18,#28,#f1
db #52,#eb,#6d,#fd,#61,#28,#fe,#88
db #fa,#88,#8d,#f4,#7c,#71,#71,#38
db #f7,#34,#fd,#a0,#38,#fe,#ac,#ff
db #fa,#ac,#f4,#28,#ee,#8e,#fa,#d0
db #f4,#f8,#f4,#1c,#f4,#dc,#fd,#a9
db #ff,#f1,#40,#f4,#88,#fa,#09,#fa
db #a3,#fa,#be,#f4,#03,#f7,#a3,#f7
db #27,#ff,#fa,#48,#fa,#42,#fa,#36
db #ee,#12,#f4,#60,#f4,#66,#ee,#6c
db #f4,#d0,#c3,#ee,#48,#fa,#b4,#71
db #71,#38,#38,#fe,#c0,#f4,#c0,#ff
db #f4,#b4,#e8,#ba,#ee,#f0,#fa,#ae
db #f4,#cc,#f4,#08,#f4,#0e,#f4,#20
db #fe,#f4,#9c,#f4,#44,#fa,#2c,#f4
db #8a,#fa,#50,#fa,#5c,#f4,#2c,#54
db #3f,#54,#2a,#f7,#90,#fa,#6e,#ee
db #8c,#70,#80,#f1,#56,#f7,#4a,#c2
db #e8,#1c,#d0,#40,#7f,#7f,#3f,#3f
db #fe,#94,#77,#03,#77,#3c,#71,#71
db #38,#38,#fe,#9d,#f7,#9d,#e6,#fa
db #34,#fa,#ac,#f4,#9d,#9f,#9f,#fe
db #88,#fe,#c4,#8e,#7c,#8e,#fe,#91
db #fe,#ca,#f4,#ca,#f4,#7c,#f4,#d0
db #92,#92,#bf,#fe,#f2,#1c,#fd,#f8
db #fc,#f6,#fd,#b2,#f1,#76,#f7,#13
db #fd,#15,#ff,#f4,#2e,#fa,#94,#f4
db #03,#f4,#ac,#fa,#2a,#fa,#48,#fa
db #42,#f7,#82,#f9,#f1,#15,#f4,#60
db #f4,#66,#ee,#6c,#fe,#f0,#24,#24
db #fe,#9c,#f3,#fa,#9c,#ee,#48,#fa
db #b4,#fe,#c2,#38,#38,#fe,#c0,#f4
db #c0,#ff,#f4,#b4,#e8,#ba,#ee,#f0
db #fa,#ae,#f4,#cc,#f4,#08,#f4,#0e
db #f4,#20,#fe,#f4,#9c,#f4,#44,#fa
db #2c,#f4,#8a,#fa,#50,#fa,#5c,#f4
db #2c,#54,#3f,#54,#2a,#f7,#90,#fa
db #6e,#ee,#8c,#70,#80,#f1,#56,#f7
db #4a,#c2,#e8,#1c,#d0,#40,#7f,#7f
db #3f,#3f,#fe,#94,#77,#03,#77,#3c
db #71,#71,#38,#38,#fe,#9d,#f7,#9d
db #e6,#fa,#34,#fa,#ac,#f4,#9d,#9f
db #9f,#fe,#88,#fe,#c4,#8e,#7c,#8e
db #fe,#91,#fe,#ca,#f4,#ca,#f4,#7c
db #f4,#d0,#92,#92,#ba,#fe,#f2,#1c
db #fd,#f8,#fc,#f6,#fe,#98,#fd,#fe
db #e6,#be,#ea,#fd,#96,#fd,#e4,#4c
db #00,#f4,#fe,#c0,#f6,#fe,#c3,#fa
db #ab,#fe,#c6,#7b,#fe,#c9,#be,#f5
db #cc,#d5,#f5,#d8,#f4,#cc,#7f,#9f
db #f5,#f0,#fe,#fc,#f6,#fd,#f4,#f9
db #ee,#f6,#fa,#25,#fe,#b7,#af,#f6
db #2d,#71,#f5,#38,#6a,#f5,#44,#f4
db #2c,#f4,#44,#fe,#b4,#7c,#7f,#f4
db #38,#fd,#76,#fa,#56,#c4,#84,#7c
db #b0,#fa,#fa,#00,#f4,#7b,#7b,#f6
db #fd,#fd,#fa,#be,#0c,#be,#7b,#38
db #38,#fe,#78,#f8,#4c,#47,#47,#37
db #8e,#8e,#f8,#58,#fd,#3a,#7f,#fe
db #64,#f4,#4c,#ee,#72,#0d,#35,#35
db #6a,#6a,#f8,#88,#fd,#3d,#5f,#fe
db #94,#3e,#24,#24,#fe,#60,#f2,#9a
db #fa,#94,#fa,#ae,#f4,#7a,#50,#1f
db #50,#9f,#9f,#fe,#c4,#f4,#58,#00
db #d2,#54,#d2,#00,#81,#c0,#00,#81
db #c2,#81,#00,#f3,#00,#00,#00,#00
db #00,#00,#b3,#00,#01,#01,#fa,#4c
db #00,#55,#9f,#88,#55,#01,#01,#fa
db #cc,#00,#d5,#00,#d5,#00,#d5,#00
db #d5,#9f,#e2,#d5,#01,#01,#fc,#f2
db #fa,#f4,#0c,#00,#00,#f3,#00,#f3
db #3a,#01,#01,#fc,#f2,#fa,#f4,#40
db #34,#03,#fe,#c0,#02,#f1,#fe,#c3
db #fc,#f8,#3e,#fe,#4c,#8b,#01,#01
db #03,#fe,#40,#7f,#02,#fd,#3e,#fb
db #46,#00,#4d,#00,#4d,#00,#4d,#00
db #4d,#8e,#4d,#52,#57,#8e,#fc,#01
db #be,#fb,#06,#7b,#fb,#0c,#fa,#06
db #ee,#17,#e4,#fa,#0c,#00,#00,#b0
db #00,#a9,#47,#fe,#54,#47,#47,#3f
db #5f,#5f,#fe,#78,#fc,#86,#fc,#60
db #f8,#86,#f6,#96,#f4,#86,#df,#00
db #80,#b0,#80,#52,#fe,#d2,#fd,#02
db #fe,#fe,#fc,#07,#fe,#fc,#de,#fc
db #0d,#fd,#09,#d5,#f8,#15,#fa,#06
db #f4,#06,#eb,#00,#9f,#fd,#fe,#45
db #f4,#1e,#df,#24,#d0,#15,#fb,#91
db #fc,#a9,#7f,#fb,#ae,#bf,#df,#84
db #71,#fe,#d5,#f7,#a5,#f1,#c3,#e2
db #90,#fd,#45,#f7,#45,#fa,#e2,#ba
db #fd,#37,#fa,#ae,#d9,#b1,#fd,#67
db #6a,#fb,#6b,#5f,#df,#fe,#71,#df
db #44,#d5,#f8,#95,#fa,#86,#df,#74
db #f7,#11,#d9,#9e,#fb,#d0,#95,#fb
db #11,#fc,#29,#d9,#3e,#fd,#71,#47
db #f5,#58,#df,#34,#b7,#f7,#5b,#50
db #fb,#8e,#df,#64,#71,#f8,#b5,#d6
db #2e,#fa,#e7,#f7,#fa,#28,#dc,#c4
db #fa,#8e,#d9,#8e,#6a,#f8,#45,#d6
db #be,#d3,#18,#6f,#47,#f8,#a5,#d9
db #4e,#71,#fe,#d5,#f7,#45,#fd,#e0
db #df,#b4,#ff,#fa,#04,#fa,#ae,#fd
db #d5,#dc,#24,#fd,#11,#f7,#3a,#dc
db #54,#f7,#75,#fa,#fd,#ab,#d9,#e4
db #f1,#9a,#00,#7a,#95,#7a,#5f,#fe
db #15,#50,#d6,#f5,#18,#df,#f4,#6a
db #f8,#45,#7f,#fb,#4e,#af,#f4,#47
db #df,#f8,#a5,#d9,#4e,#71,#fe,#d5
db #f7,#45,#fd,#e0,#df,#b4,#fa,#04
db #ff,#fa,#ae,#fd,#d5,#dc,#24,#fd
db #11,#f7,#3a,#dc,#54,#f7,#75,#fd
db #ab,#ff,#d9,#e4,#f1,#9a,#00,#7a
db #00,#7a,#00,#7a,#00,#7a,#a4,#7a
db #fa,#05,#c8,#fa,#fa,#52,#fa,#a9
db #47,#fe,#b2,#47,#47,#5f,#7f,#5f
db #fe,#f8,#fc,#c6,#fc,#e0,#f8,#c6
db #f6,#d6,#f4,#c6,#00,#c0,#bd,#b0
db #c0,#52,#fe,#12,#fd,#42,#fe,#3e
db #fc,#47,#52,#fb,#4c,#78,#a9,#e9
db #52,#fa,#4c,#00,#40,#b0,#40,#01
db #5f,#00,#f6,#01,#01,#fb,#0c,#f5
db #01,#f3,#1c,#fa,#0c,#00,#00,#ff
db #b0,#00,#f0,#6c,#e8,#62,#ea,#8a
db #00,#8e,#be,#8e,#f4,#df,#fe,#fc
db #ff,#fc,#0d,#e6,#e4,#f0,#0d,#00
db #0c,#00,#0c,#00,#0c,#00,#0c,#00
db #0c,#ff,#00,#0c,#00,#0c,#00,#0c
db #00,#0c,#00,#0c,#00,#0c,#2a,#0c
db #52,#fa,#ff,#f0,#ec,#e8,#e2,#ea
db #ca,#00,#ce,#be,#ce,#f4,#1f,#fe
db #3c,#fc,#4d,#f0,#e6,#24,#f0,#4d
db #00,#4c,#bc,#4c,#00,#bf,#e8,#00
db #0c,#f5,#14,#dc,#24,#00,#19,#d4
db #19,#dc,#39,#34,#a9,#ff,#70,#35
db #dc,#b9,#34,#29,#70,#b5,#dc,#39
db #34,#a9,#70,#35,#dc,#b9,#ff,#34
db #29,#70,#b5,#dc,#39,#34,#a9,#70
db #35,#dc,#b9,#34,#29,#70,#b5,#ff
db #dc,#39,#34,#a9,#70,#35,#dc,#b9
db #34,#29,#70,#b5,#dc,#39,#34,#a9
db #ff,#70,#35,#dc,#b9,#34,#29,#00
db #b5,#b0,#b5,#dc,#f9,#34,#69,#70
db #f5,#80,#f5,#af,#3a,#bf,#e8,#00
db #32,#f5,#14,#dc,#24,#00,#19,#d4
db #19,#dc,#39,#34,#a9,#d7,#70,#35
db #f5,#ef,#38,#e8,#00,#30,#f5,#14
db #dc,#24,#00,#19,#ff,#d4,#19,#dc
db #39,#34,#a9,#70,#35,#dc,#b9,#34
db #29,#70,#b5,#dc,#39,#ff,#34,#a9
db #70,#35,#dc,#b9,#34,#29,#70,#b5
db #dc,#39,#34,#a9,#70,#35,#ff,#dc
db #b9,#34,#29,#70,#b5,#dc,#39,#34
db #a9,#70,#35,#dc,#b9,#34,#29,#fc
db #00,#b5,#b0,#b5,#dc,#f9,#34,#69
db #70,#f5,#f5,#af,#0b,#05,#0b,#0a
db #0a,#09,#09,#f4,#00,#07,#fb,#12
db #47,#0c,#fe,#0d,#09,#08,#06,#fa
db #18,#ee,#06,#d6,#06,#fd,#e8,#5a
db #b2,#18,#fa,#a2,#f4,#90,#e2,#78
db #fa,#f5,#0d,#fb,#de,#03,#07,#06
db #05,#04,#03,#02,#94,#a8,#dc,#08
db #fe,#e2,#38,#d6,#86,#e8,#da,#b2
db #98,#f4,#50,#dc,#f2,#fa,#75,#0d
db #81,#fb,#5e,#07,#06,#05,#04,#03
db #02,#94,#28,#ff,#dc,#88,#e2,#b8
db #d6,#06,#e8,#5a,#b2,#18,#f4,#d0
db #dc,#72,#fa,#f5,#40,#0d,#fb,#de
db #07,#06,#05,#04,#03,#02,#ff,#94
db #a8,#dc,#08,#e2,#38,#d6,#86,#e8
db #da,#b2,#98,#f4,#50,#dc,#f2,#a0
db #fa,#75,#0d,#fb,#5e,#07,#06,#05
db #04,#03,#7f,#02,#94,#28,#dc,#88
db #e2,#b8,#d6,#06,#e8,#5a,#b2,#18
db #f4,#d0,#d0,#dc,#72,#fa,#f5,#0d
db #fb,#de,#07,#06,#05,#04,#3f,#03
db #02,#94,#a8,#dc,#08,#e2,#38,#d6
db #86,#e8,#da,#b2,#98,#e8,#f4,#50
db #dc,#f2,#fa,#75,#0d,#fb,#5e,#07
db #06,#05,#1f,#04,#03,#02,#94,#28
db #dc,#88,#e2,#b8,#d6,#06,#e8,#5a
db #f4,#b2,#18,#f4,#d0,#dc,#72,#fa
db #f5,#0d,#fb,#de,#07,#06,#0f,#05
db #04,#03,#02,#94,#a8,#dc,#08,#e2
db #38,#d6,#86,#fa,#e8,#da,#b2,#98
db #f4,#50,#dc,#f2,#fa,#75,#0d,#fb
db #5e,#07,#07,#06,#05,#04,#03,#02
db #94,#28,#dc,#88,#e2,#b8,#fd,#d6
db #06,#e8,#5a,#b2,#18,#f4,#d0,#dc
db #72,#fa,#f5,#0d,#fb,#de,#03,#07
db #06,#05,#04,#03,#02,#94,#a8,#dc
db #08,#fe,#e2,#38,#d6,#86,#e8,#da
db #b2,#98,#f4,#50,#dc,#f2,#fa,#75
db #0d,#81,#fb,#5e,#07,#06,#05,#04
db #03,#02,#94,#28,#ff,#dc,#88,#e2
db #b8,#d6,#06,#e8,#5a,#a6,#18,#4c
db #12,#fa,#62,#f4,#50,#d0,#e2,#38
db #fa,#b5,#0d,#fb,#9e,#07,#06,#05
db #04,#3f,#03,#02,#94,#68,#dc,#c8
db #e2,#f8,#d6,#46,#e8,#9a,#b2,#58
db #e8,#f4,#10,#dc,#b2,#fa,#35,#0d
db #fb,#1e,#07,#06,#05,#18,#04,#03
db #02,#94,#e8,#f4,#ae,#00,#ea,#00
db #00,#00,#00,#01,#00,#0c,#fe,#00
db #0b,#fe,#03,#0a,#b7,#fe,#06,#09
db #fe,#09,#d0,#00,#08,#fe,#3c,#eb
db #21,#ee,#4e,#ff,#dc,#12,#dc,#30
db #d0,#1e,#f7,#cc,#ee,#d2,#f1,#f3
db #9a,#60,#be,#8a,#ff,#dc,#6e,#ee
db #ce,#9a,#4a,#ee,#16,#fd,#4c,#fd
db #52,#ee,#40,#ee,#70,#8f,#e8,#34
db #0e,#0d,#0c,#fd,#a0,#fc,#99,#fe
db #a9,#f7,#a3,#ff,#f1,#a9,#c1,#04
db #ee,#52,#f1,#eb,#ee,#1e,#df,#e2
db #e5,#27,#ca,#ca,#ff,#e8,#ac,#f4
db #b4,#d6,#ba,#ee,#f5,#fa,#e4,#e8
db #08,#ee,#02,#fa,#37,#fd,#e2,#9c
db #dc,#56,#fd,#3e,#f7,#3e,#fa,#83
db #f4,#3e,#08,#fe,#9e,#f3,#fd,#9b
db #6d,#80,#f7,#1f,#ac,#c8,#0e,#0d
db #fe,#8d,#fb,#92,#ff,#fa,#94,#f7
db #a2,#f4,#9d,#ee,#ac,#f1,#9d,#f7
db #6d,#fa,#7c,#f4,#dc,#df,#fc,#ec
db #fe,#f2,#07,#fb,#fa,#f4,#88,#fa
db #7f,#ee,#dc,#ee,#1e,#ff,#ee,#e2
db #e2,#12,#ee,#4e,#f1,#7c,#df,#33
db #e2,#ac,#f4,#c5,#dc,#c0,#ff,#ee
db #f5,#fa,#e4,#e8,#08,#ee,#02,#fa
db #37,#e2,#9c,#dc,#56,#fd,#3e,#ef
db #f7,#3e,#fa,#83,#f4,#3e,#08,#fe
db #9e,#fd,#9b,#6d,#80,#f7,#1f,#9f
db #ac,#c8,#0e,#0d,#fe,#8d,#fb,#92
db #fa,#94,#f7,#a2,#f4,#9d,#fe,#ee
db #ac,#f1,#9d,#f7,#6d,#fa,#7c,#f4
db #dc,#fc,#ec,#fe,#f2,#07,#ff,#fb
db #fa,#fd,#cb,#e5,#00,#fd,#cc,#e5
db #1e,#fe,#3a,#fe,#f3,#e6,#3d,#b6
db #fe,#58,#08,#e5,#5a,#fe,#76,#07
db #e5,#78,#fe,#94,#06,#fe,#d9,#96
db #f4,#6c,#e8,#dc,#d9,#d8,#f7,#fc
db #fa,#0b,#f4,#fc,#08,#fb,#fe,#26
db #ca,#d5,#eb,#ff,#fa,#23,#fa,#6b
db #0d,#fe,#7c,#e5,#80,#f6,#fe,#9c
db #fe,#13,#e6,#9f,#fe,#ba,#09,#e5
db #bc,#fe,#d8,#08,#db,#e5,#da,#fe
db #f6,#07,#e5,#f8,#fe,#14,#06,#d9
db #16,#f4,#ec,#ff,#e5,#50,#fd,#5b
db #f1,#6b,#f1,#73,#dc,#58,#c4,#4c
db #00,#e2,#00,#e2,#c0,#00,#e2,#28
db #e2,#0d,#02,#0c,#0b,#0a,#09,#08
db #0b,#fd,#06,#09,#4f,#09,#fc,#02
db #07,#07,#fa,#0c,#f4,#17,#f4,#0c
db #00,#00,#ff,#c8,#00,#fd,#62,#fa
db #68,#f4,#5f,#25,#8d,#42,#28,#fe
db #15,#fd,#f1,#7b,#06,#fe,#1b,#fa
db #15,#dc,#f4,#f7,#15,#05,#fe,#51
db #ac,#f4,#ff,#6d,#18,#f7,#05,#d3
db #14,#fd,#6b,#49,#84,#76,#9b,#fc
db #ad,#fd,#8b,#ff,#fe,#bb,#fa,#b5
db #4f,#04,#c7,#15,#d9,#be,#fd,#cd
db #fa,#ae,#fa,#dd,#ff,#de,#84,#fd
db #a8,#fe,#08,#fa,#d8,#fc,#f3,#b0
db #b5,#f7,#0b,#d9,#0e,#fd,#fa,#05
db #f7,#9a,#00,#74,#8e,#74,#fb,#15
db #fd,#f1,#06,#fe,#1e,#7f,#05,#fe
db #21,#dc,#f4,#fa,#1b,#fa,#45,#a6
db #f4,#fc,#9d,#fe,#ac,#ff,#df,#84
db #fd,#cd,#fa,#ae,#fa,#dd,#de,#84
db #fd,#a8,#fe,#08,#fa,#d8,#ff,#fc
db #f3,#b0,#b5,#f7,#0b,#d9,#0e,#fa
db #05,#f7,#9a,#00,#74,#00,#74,#e0
db #00,#74,#00,#74,#9e,#74,#07,#06
db #05,#04,#03,#7c,#02,#46,#f4,#d0
db #d6,#00,#c6,#00,#c6,#36,#c6,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#ff,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#e0,#00,#00,#00,#00,#41
db #00,#00,#ff,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#e0,#00,#00,#00
db #00,#41,#00,#00,#7f,#ff,#00,#01
db #00,#01,#00,#01,#00,#01,#00,#01
db #00,#01,#00,#01,#ff,#00,#01,#00
db #01,#00,#01,#00,#01,#00,#01,#00
db #01,#00,#01,#00,#01,#f0,#00,#01
db #00,#01,#00,#01,#42,#01

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

  -- Add category tag: ptite-zic
  SELECT id INTO tag_uuid FROM tags WHERE name = 'ptite-zic';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 70: simple_raster by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'simple_raster',
    'Imported from z80Code. Author: Unknown.',
    'public',
    false,
    false,
    '2019-09-08T10:08:27.959000'::timestamptz,
    '2023-02-09T01:48:42.359000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Simple Raster
 DI

; Synchro ecran
 MACRO WAITVBL 
  LD      b,#f5
 @SYNC   
  IN      A,(C) 
  RRA 
  JR      NC,@SYNC 
 MEND

 LD HL,#c9fb	
 LD (#38),HL 

loop:
 ei
 WAITVBL
 halt
 halt
 di
  ds 24

 
 ld a,(loop0+1)
 inc a
 ld (loop0+1),a

 ld e,100
 
loop0: 
 LD A,0
loop1:
 inc A
 ;ld (loop0+1),a
 AND 31
 OR #40
 ld bc, #7f00
 Out (c),c
 out (c),a
 ds 64-20,0

 dec e
 jr nz,loop1
 
 ld a,#41
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

  -- Add category tag: raster
  SELECT id INTO tag_uuid FROM tags WHERE name = 'raster';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
