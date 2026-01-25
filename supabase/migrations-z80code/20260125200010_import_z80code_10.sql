-- Migration: Import z80code projects batch 10
-- Projects 19 to 20
-- Generated: 2026-01-25T21:43:30.183994

-- Project 19: logondule by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'logondule',
    'Imported from z80Code. Author: tronic. vieillerie...',
    'public',
    false,
    false,
    '2020-01-28T13:58:16.444000'::timestamptz,
    '2021-06-18T22:29:23.818000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Warning ! Vieillerie inside et posée en l''état...
; Source d''un "gros" logo (GPA) qui ondule avec tendresse par dessus une grille.
; Devait-être utilisé pour la end-part de la cuddly demo / GPA... Paix à son âme...
; ébauche démo DSK dispo là : https://index.amstrad.info/wp-content/uploads/martine/gpa.dsk
; L''utilisation des macros ou autres optim'' n''étant pas franchement courantes ni dispo à l''époque,
; ptet judicieux de dépoluer tout (*bug*) ca (*bug*) à la sauce Rasm pour une meilleure lisibilité
; car en l''état c''est juste "infecte" ni plus très compréhensible... Bref...
; Bon courage aux courageux...
; Tronic/GPA.

; (*bug*) ca (*bug*) :
; @siko : quand on met un "c cédille" dans le texte d''un commentaire,
; visiblement l''assemblage ne se fait/lance pas ?!
; Inadmissible !!! Remboursez ! Remboursez ! ^^


	org #100
	nolist
	run $

grille	equ #55
fond	equ #44

	jr debut

sinus
; table sinus de taille 79 (maxi 255) doit se situer
; en memoire en #XX+[0-79-255] de facon a pouvoir faire 
; du ''inc l''...
		; 
	db 0,0
	db 0,0
	db 2,2
	db 2,2
	db 4,4,4
	db 6,6
	db 8,8
	db 10,10
	db 12,12
	db 14,14
	db 16,16
	db 18,18
	db 20,20
	db 22,22
	db 24,24
	db 26,26
	db 28,28,28
	db 30,30
	db 30,30
	db 32,32
	db 32,32,32,32
	db 32,32
	db 32,32
	db 30,30
	db 30,30
	db 28,28,28
	db 26,26
	db 24,24
	db 22,22
	db 20,20
	db 18,18
	db 16,16
	db 14,14
	db 12,12
	db 10,10
	db 8,8
	db 6,6
	db 4,4,4
	db 2,2
	db 2,2
	db 0,0
	db 0,0,0,0
	db #ff
sinus_end

debut	

; routine qui colle le sprite bien la ou il faut dans les cases... spr1,spr2 etc...
	ld hl,sprite
	ld de,spr1+32	; 8+8+8+8...
	ld b,32
bc1
	push bc
	push de
	push hl
	ld b,47
bc0	
	push hl
	push bc
	ld a,(hl)
	ld (de),a
	inc de
	ld bc,47
	add hl,bc
	ld a,(hl)
	ld (de),a
	inc de
	pop bc
	pop hl
	inc hl
	djnz bc0
	pop hl
	ld bc,94
	add hl,bc
	pop de
	ld bc,158
	ex de,hl
	add hl,bc
	ex de,hl
	pop bc
	djnz bc1

; RaZ scrs

	ld hl,#4000
	ld de,#4001
	ld bc,#3fff
	ld (hl),0
	ldir

	ld hl,#c000
	ld de,#c001
	ld bc,#3fff
	ld (hl),0
	ldir

; Affichage grillage vertical
	call grillage

; Colore le monde, sans feutre, sans epreuves ni bombes...

	ld bc,#7f10
	ld a,fond
	out (c),c
	out (c),a
	ld c,0
	out (c),c
	out (c),a
	inc c
	ld a,#4b
	out (c),c
	out (c),a
	inc c
	ld a,#5c
	out (c),c
	out (c),a
	inc c
	ld a,#43
	out (c),c
	out (c),a
	inc c
	ld a,#4e
	out (c),c
	out (c),a
	inc c
	ld a,#4a
	out (c),c
	out (c),a

; ints...
	DI	
	LD	HL,(#38)
	LD	(INTER+1),HL
	LD	HL,#C9FB
	LD	(#38),HL
	EXX	
	EX	AF,AF''
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
	EI	
	
prg	halt	
	ld b,#f5
sync	in a,(c)
	rra
	jr nc,sync

flipp
	ld a,#ff	; pork code follow... jetez moi des cailloux !
	xor #ff
	ld (flipp+1),a
	or a
	jr z,ecr2
ecr1
	ld bc,#7fc3	; je poke le logo en ''#c000''
	out (c),c
	ld a,#10	; je montre #4000
	ld bc,#bc0c
	out (c),c
	inc b
	out (c),a
	jr go

ecr2	
	ld bc,#7fc0	; je poke le logo en ''#4000''
	out (c),c
	ld a,#30	; je montre #c000
	ld bc,#bc0c
	out (c),c
	inc b
	out (c),a

go	
	ld bc,#7f10
	ld a,#6c
	out (c),c
	out (c),a
	
	call routine1
			; j''affiche les colonnes du sprite
	ld bc,#7f10
	ld a,#4b
	out (c),c
	out (c),a
	call routine2
			; je change les pointeurs des colonnes du sprite 
			; au sein de la routine2 via une table sinus multiple de 2...

	ld bc,#7f10
	ld a,fond
	out (c),c
	out (c),a
	ld bc,#7f08
	out (c),c
	ld a,grille
	out (c),a


	ld bc,#7f8c
	out (c),c
;


key     LD   bc,#f40e                  ; Teste la barre Espace
        OUT  (c),c
        LD   bc,#f6c0
        OUT  (c),c
        XOR  a
        OUT  (c),a
        LD   bc,#f792
        OUT  (c),c
        LD   bc,#f645
        OUT  (c),c
        LD   b,#f4
        IN   a,(c)
        LD   bc,#f782
        OUT  (c),c
        LD   bc,#f600
        OUT  (c),c
        RLA 
        JP   c,prg                    ; Boucle si non 
FIN
	DI	
INTER	LD	HL,0
	LD	(#38),HL
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	EX	AF,AF''
	EXX	
	EI	
	call 0


grillage
	
	ld hl,#4005
	ld bc,#8000

	ld a,81
bgrill2
	push af
	push hl
	ld a,18
bgrill1
	ld (hl),#01
	push hl
	add hl,bc
	ld (hl),#01
	pop hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec a
	jr nz,bgrill1
	pop hl
	call bc26hl
	pop af
	dec a
	jr nz,bgrill2
	ret

bc26hl  LD A,H
        ADD A,#08
        LD H,A
        AND #38
        RET NZ
        LD A,H
        SUB #40
        LD H,A
        LD A,L
        ADD A,#50
        LD L,A
        RET NC
        INC H
        LD A,H
        AND #07
        RET NZ
        LD A,H
        SUB #08
        LD H,A
        RET  
	

routine2
	ld d,0
	ld b,#ff
c1
	ld hl,sinus
	ld a,(hl)
	cp b
	jr nz,suite1
	ld hl,sinus
	ld a,(hl)
suite1
	inc l
	ld (c1+1),hl

	ld hl,spr1
	ld e,a
	add hl,de
	ld (col1+1),hl

c2
	ld hl,sinus+2
	ld a,(hl)
	cp b
	jr nz,suite2
	ld hl,sinus
	ld a,(hl)
suite2
	inc l
	ld (c2+1),hl

	ld hl,spr2
	ld e,a
	add hl,de
	ld (col2+1),hl

c3
	ld hl,sinus+4
	ld a,(hl)
	cp b
	jr nz,suite3
	ld hl,sinus
	ld a,(hl)
suite3
	inc l
	ld (c3+1),hl

	ld hl,spr3
	ld e,a
	add hl,de
	ld (col3+1),hl

c4
	ld hl,sinus+6
	ld a,(hl)
	cp b
	jr nz,suite4
	ld hl,sinus
	ld a,(hl)
suite4
	inc l
	ld (c4+1),hl

	ld hl,spr4
	ld e,a
	add hl,de
	ld (col4+1),hl

c5
	ld hl,sinus+8
	ld a,(hl)
	cp b
	jr nz,suite5
	ld hl,sinus
	ld a,(hl)
suite5
	inc l
	ld (c5+1),hl

	ld hl,spr5
	ld e,a
	add hl,de
	ld (col5+1),hl

c6
	ld hl,sinus+10
	ld a,(hl)
	cp b
	jr nz,suite6
	ld hl,sinus
	ld a,(hl)
suite6
	inc l
	ld (c6+1),hl

	ld hl,spr6
	ld e,a
	add hl,de
	ld (col6+1),hl

c7
	ld hl,sinus+12
	ld a,(hl)
	cp b
	jr nz,suite7
	ld hl,sinus
	ld a,(hl)
suite7
	inc l
	ld (c7+1),hl

	ld hl,spr7
	ld e,a
	add hl,de
	ld (col7+1),hl

c8
	ld hl,sinus+14
	ld a,(hl)
	cp b
	jr nz,suite8
	ld hl,sinus
	ld a,(hl)
suite8
	inc l
	ld (c8+1),hl

	ld hl,spr8
	ld e,a
	add hl,de
	ld (col8+1),hl

c9
	ld hl,sinus+16
	ld a,(hl)
	cp b
	jr nz,suite9
	ld hl,sinus
	ld a,(hl)
suite9
	inc l
	ld (c9+1),hl

	ld hl,spr9
	ld e,a
	add hl,de
	ld (col9+1),hl

c10
	ld hl,sinus+18
	ld a,(hl)
	cp b
	jr nz,suite10
	ld hl,sinus
	ld a,(hl)
suite10
	inc l
	ld (c10+1),hl

	ld hl,spr10
	ld e,a
	add hl,de
	ld (col10+1),hl

c11
	ld hl,sinus+20
	ld a,(hl)
	cp b
	jr nz,suite11
	ld hl,sinus
	ld a,(hl)
suite11
	inc l
	ld (c11+1),hl

	ld hl,spr11
	ld e,a
	add hl,de
	ld (col11+1),hl

c12
	ld hl,sinus+22
	ld a,(hl)
	cp b
	jr nz,suite12
	ld hl,sinus
	ld a,(hl)
suite12
	inc l
	ld (c12+1),hl

	ld hl,spr12
	ld e,a
	add hl,de
	ld (col12+1),hl

c13
	ld hl,sinus+24
	ld a,(hl)
	cp b
	jr nz,suite13
	ld hl,sinus
	ld a,(hl)
suite13
	inc l
	ld (c13+1),hl

	ld hl,spr13
	ld e,a
	add hl,de
	ld (col13+1),hl

c14
	ld hl,sinus+26
	ld a,(hl)
	cp b
	jr nz,suite14
	ld hl,sinus
	ld a,(hl)
suite14
	inc l
	ld (c14+1),hl

	ld hl,spr14
	ld e,a
	add hl,de
	ld (col14+1),hl

c15
	ld hl,sinus+28
	ld a,(hl)
	cp b
	jr nz,suite15
	ld hl,sinus
	ld a,(hl)
suite15
	inc l
	ld (c15+1),hl

	ld hl,spr15
	ld e,a
	add hl,de
	ld (col15+1),hl


c16
	ld hl,sinus+30
	ld a,(hl)
	cp b
	jr nz,suite16
	ld hl,sinus
	ld a,(hl)
suite16
	inc l
	ld (c16+1),hl

	ld hl,spr16
	ld e,a
	add hl,de
	ld (col16+1),hl

c17
	ld hl,sinus+32
	ld a,(hl)
	cp b
	jr nz,suite17
	ld hl,sinus
	ld a,(hl)
suite17
	inc l
	ld (c17+1),hl

	ld hl,spr17
	ld e,a
	add hl,de
	ld (col17+1),hl


c18
	ld hl,sinus+34
	ld a,(hl)
	cp b
	jr nz,suite18
	ld hl,sinus
	ld a,(hl)
suite18
	inc l
	ld (c18+1),hl

	ld hl,spr18
	ld e,a
	add hl,de
	ld (col18+1),hl

c19
	ld hl,sinus+36
	ld a,(hl)
	cp b
	jr nz,suite19
	ld hl,sinus
	ld a,(hl)
suite19
	inc l
	ld (c19+1),hl

	ld hl,spr19
	ld e,a
	add hl,de
	ld (col19+1),hl

c20
	ld hl,sinus+38
	ld a,(hl)
	cp b
	jr nz,suite20
	ld hl,sinus
	ld a,(hl)
suite20
	inc l
	ld (c20+1),hl

	ld hl,spr20
	ld e,a
	add hl,de
	ld (col20+1),hl

c21
	ld hl,sinus+40
	ld a,(hl)
	cp b
	jr nz,suite21
	ld hl,sinus
	ld a,(hl)
suite21
	inc l
	ld (c21+1),hl

	ld hl,spr21
	ld e,a
	add hl,de
	ld (col21+1),hl

c22
	ld hl,sinus+42
	ld a,(hl)
	cp b
	jr nz,suite22
	ld hl,sinus
	ld a,(hl)
suite22
	inc l
	ld (c22+1),hl

	ld hl,spr22
	ld e,a
	add hl,de
	ld (col22+1),hl

c23
	ld hl,sinus+44
	ld a,(hl)
	cp b
	jr nz,suite23
	ld hl,sinus
	ld a,(hl)
suite23
	inc l
	ld (c23+1),hl

	ld hl,spr23
	ld e,a
	add hl,de
	ld (col23+1),hl

c24
	ld hl,sinus+46
	ld a,(hl)
	cp b
	jr nz,suite24
	ld hl,sinus
	ld a,(hl)
suite24
	inc l
	ld (c24+1),hl

	ld hl,spr24
	ld e,a
	add hl,de
	ld (col24+1),hl

c25
	ld hl,sinus+48
	ld a,(hl)
	cp b
	jr nz,suite25
	ld hl,sinus
	ld a,(hl)
suite25
	inc l
	ld (c25+1),hl

	ld hl,spr25
	ld e,a
	add hl,de
	ld (col25+1),hl

c26
	ld hl,sinus+50
	ld a,(hl)
	cp b
	jr nz,suite26
	ld hl,sinus
	ld a,(hl)
suite26
	inc l
	ld (c26+1),hl

	ld hl,spr26
	ld e,a
	add hl,de
	ld (col26+1),hl

c27
	ld hl,sinus+52
	ld a,(hl)
	cp b
	jr nz,suite27
	ld hl,sinus
	ld a,(hl)
suite27
	inc l
	ld (c27+1),hl

	ld hl,spr27
	ld e,a
	add hl,de
	ld (col27+1),hl

c28
	ld hl,sinus+54
	ld a,(hl)
	cp b
	jr nz,suite28
	ld hl,sinus
	ld a,(hl)
suite28
	inc l
	ld (c28+1),hl

	ld hl,spr28
	ld e,a
	add hl,de
	ld (col28+1),hl

c29
	ld hl,sinus+56
	ld a,(hl)
	cp b
	jr nz,suite29
	ld hl,sinus
	ld a,(hl)
suite29
	inc l
	ld (c29+1),hl

	ld hl,spr29
	ld e,a
	add hl,de
	ld (col29+1),hl

c30
	ld hl,sinus+58
	ld a,(hl)
	cp b
	jr nz,suite30
	ld hl,sinus
	ld a,(hl)
suite30
	inc l
	ld (c30+1),hl

	ld hl,spr30
	ld e,a
	add hl,de
	ld (col30+1),hl

c31
	ld hl,sinus+60
	ld a,(hl)
	cp b
	jr nz,suite31
	ld hl,sinus
	ld a,(hl)
suite31
	inc l
	ld (c31+1),hl

	ld hl,spr31
	ld e,a
	add hl,de
	ld (col31+1),hl

c32
	ld hl,sinus+62
	ld a,(hl)
	cp b
	jr nz,suite32
	ld hl,sinus
	ld a,(hl)
suite32
	inc l
	ld (c32+1),hl

	ld hl,spr32
	ld e,a
	add hl,de
	ld (col32+1),hl

	ret


routine1
	ld (pile+1),sp
	di
	ld bc,#7f00
	out (c),c
	ld a,grille
	ld e,fond

col1 
ld sp,spr1
pop hl
ld (#C000+7+#50-#8000),hl		; au debut je faisais des tests uniquement en #c000... sans flipping...
pop hl					; avec le flipping (out #7fc3) j''ai du remettre tout en #4000
ld (#C800+7+#50-#8000),hl		; donc chq adr ecr #c000 - #8000 revient en #4000...
					; de memoire, il me semble avoir optimise la chose en virant certaines
					; portions qui au final n''ont aucun impact visuel et donc sont inutiles...
					; du coup ca fait baisser le TM (mais attention au rasters qui se decalent...)
					; bref ^^
pop hl
ld (#D000+7+#50-#8000),hl
pop hl
ld (#D800+7+#50-#8000),hl
pop hl
ld (#E000+7+#50-#8000),hl
pop hl
ld (#E800+7+#50-#8000),hl
pop hl
ld (#F000+7+#50-#8000),hl
pop hl
ld (#F800+7+#50-#8000),hl
pop hl
ld (#C050+7+#50-#8000),hl
pop hl
ld (#C850+7+#50-#8000),hl
pop hl
ld (#D050+7+#50-#8000),hl
pop hl
ld (#D850+7+#50-#8000),hl
pop hl
ld (#E050+7+#50-#8000),hl
pop hl
ld (#E850+7+#50-#8000),hl
pop hl
ld (#F050+7+#50-#8000),hl
pop hl
ld (#F850+7+#50-#8000),hl
pop hl
ld (#C0A0+7+#50-#8000),hl
pop hl
ld (#C8A0+7+#50-#8000),hl
pop hl
ld (#D0A0+7+#50-#8000),hl
pop hl
ld (#D8A0+7+#50-#8000),hl
pop hl
ld (#E0A0+7+#50-#8000),hl
pop hl
ld (#E8A0+7+#50-#8000),hl
pop hl
ld (#F0A0+7+#50-#8000),hl
pop hl
ld (#F8A0+7+#50-#8000),hl
pop hl
ld (#C0F0+7+#50-#8000),hl
pop hl
ld (#C8F0+7+#50-#8000),hl
pop hl
ld (#D0F0+7+#50-#8000),hl
pop hl
ld (#D8F0+7+#50-#8000),hl
pop hl
ld (#E0F0+7+#50-#8000),hl
pop hl
ld (#E8F0+7+#50-#8000),hl
pop hl
ld (#F0F0+7+#50-#8000),hl
pop hl
ld (#F8F0+7+#50-#8000),hl
pop hl
ld (#C140+7+#50-#8000),hl
pop hl
ld (#C940+7+#50-#8000),hl
pop hl
ld (#D140+7+#50-#8000),hl
pop hl
ld (#D940+7+#50-#8000),hl
pop hl
ld (#E140+7+#50-#8000),hl
pop hl
ld (#E940+7+#50-#8000),hl
pop hl
ld (#F140+7+#50-#8000),hl
pop hl
ld (#F940+7+#50-#8000),hl
pop hl
ld (#C190+7+#50-#8000),hl
pop hl
ld (#C990+7+#50-#8000),hl
pop hl
ld (#D190+7+#50-#8000),hl
pop hl
ld (#D990+7+#50-#8000),hl
pop hl
ld (#E190+7+#50-#8000),hl
pop hl
ld (#E990+7+#50-#8000),hl
pop hl
ld (#F190+7+#50-#8000),hl
pop hl
ld (#F990+7+#50-#8000),hl
pop hl
ld (#C1E0+7+#50-#8000),hl
pop hl
ld (#C9E0+7+#50-#8000),hl
pop hl
ld (#D1E0+7+#50-#8000),hl
pop hl
ld (#D9E0+7+#50-#8000),hl
pop hl
ld (#E1E0+7+#50-#8000),hl
pop hl
ld (#E9E0+7+#50-#8000),hl
pop hl
ld (#F1E0+7+#50-#8000),hl
pop hl
ld (#F9E0+7+#50-#8000),hl
pop hl
ld (#C230+7+#50-#8000),hl
pop hl
ld (#CA30+7+#50-#8000),hl
pop hl
ld (#D230+7+#50-#8000),hl
pop hl
ld (#DA30+7+#50-#8000),hl
pop hl
ld (#E230+7+#50-#8000),hl
pop hl
ld (#EA30+7+#50-#8000),hl
pop hl
ld (#F230+7+#50-#8000),hl


col2 
ld sp,spr2
pop hl
ld (#C002+7+#50-#8000),hl
pop hl
ld (#C802+7+#50-#8000),hl
pop hl
ld (#D002+7+#50-#8000),hl
pop hl
ld (#D802+7+#50-#8000),hl
pop hl
ld (#E002+7+#50-#8000),hl
pop hl
ld (#E802+7+#50-#8000),hl
pop hl
ld (#F002+7+#50-#8000),hl
pop hl
ld (#F802+7+#50-#8000),hl
pop hl
ld (#C052+7+#50-#8000),hl
pop hl
ld (#C852+7+#50-#8000),hl
pop hl
ld (#D052+7+#50-#8000),hl
pop hl
ld (#D852+7+#50-#8000),hl
pop hl
ld (#E052+7+#50-#8000),hl
pop hl
ld (#E852+7+#50-#8000),hl
pop hl
ld (#F052+7+#50-#8000),hl
pop hl
ld (#F852+7+#50-#8000),hl
pop hl
ld (#C0A2+7+#50-#8000),hl
pop hl
ld (#C8A2+7+#50-#8000),hl
pop hl
ld (#D0A2+7+#50-#8000),hl
pop hl
ld (#D8A2+7+#50-#8000),hl
pop hl
ld (#E0A2+7+#50-#8000),hl
pop hl
ld (#E8A2+7+#50-#8000),hl
pop hl
ld (#F0A2+7+#50-#8000),hl
pop hl
ld (#F8A2+7+#50-#8000),hl
pop hl
ld (#C0F2+7+#50-#8000),hl
pop hl
ld (#C8F2+7+#50-#8000),hl
pop hl
ld (#D0F2+7+#50-#8000),hl
pop hl
ld (#D8F2+7+#50-#8000),hl
pop hl
ld (#E0F2+7+#50-#8000),hl
pop hl
ld (#E8F2+7+#50-#8000),hl
pop hl
ld (#F0F2+7+#50-#8000),hl
pop hl
ld (#F8F2+7+#50-#8000),hl
pop hl
ld (#C142+7+#50-#8000),hl
pop hl
ld (#C942+7+#50-#8000),hl
pop hl
ld (#D142+7+#50-#8000),hl
pop hl
ld (#D942+7+#50-#8000),hl
pop hl
ld (#E142+7+#50-#8000),hl
pop hl
ld (#E942+7+#50-#8000),hl
pop hl
ld (#F142+7+#50-#8000),hl
pop hl
ld (#F942+7+#50-#8000),hl
pop hl
ld (#C192+7+#50-#8000),hl
pop hl
ld (#C992+7+#50-#8000),hl
pop hl
ld (#D192+7+#50-#8000),hl
pop hl
ld (#D992+7+#50-#8000),hl
pop hl
ld (#E192+7+#50-#8000),hl
pop hl
ld (#E992+7+#50-#8000),hl
pop hl
ld (#F192+7+#50-#8000),hl
pop hl
ld (#F992+7+#50-#8000),hl
pop hl
ld (#C1E2+7+#50-#8000),hl
pop hl
ld (#C9E2+7+#50-#8000),hl
pop hl
ld (#D1E2+7+#50-#8000),hl
pop hl
ld (#D9E2+7+#50-#8000),hl
pop hl
ld (#E1E2+7+#50-#8000),hl
pop hl
ld (#E9E2+7+#50-#8000),hl
pop hl
ld (#F1E2+7+#50-#8000),hl
pop hl
ld (#F9E2+7+#50-#8000),hl
pop hl
ld (#C232+7+#50-#8000),hl
pop hl
ld (#CA32+7+#50-#8000),hl
pop hl
ld (#D232+7+#50-#8000),hl
pop hl
ld (#DA32+7+#50-#8000),hl
pop hl
ld (#E232+7+#50-#8000),hl
pop hl
ld (#EA32+7+#50-#8000),hl
pop hl
ld (#F232+7+#50-#8000),hl

col3 
ld sp,spr3
pop hl
ld (#C004+7+#50-#8000),hl
pop hl
ld (#C804+7+#50-#8000),hl
pop hl
ld (#D004+7+#50-#8000),hl
pop hl
ld (#D804+7+#50-#8000),hl
pop hl
ld (#E004+7+#50-#8000),hl
pop hl
ld (#E804+7+#50-#8000),hl
pop hl
ld (#F004+7+#50-#8000),hl
pop hl
ld (#F804+7+#50-#8000),hl
pop hl
ld (#C054+7+#50-#8000),hl
pop hl
ld (#C854+7+#50-#8000),hl
pop hl
ld (#D054+7+#50-#8000),hl
pop hl
ld (#D854+7+#50-#8000),hl
pop hl
ld (#E054+7+#50-#8000),hl
pop hl
ld (#E854+7+#50-#8000),hl
pop hl
ld (#F054+7+#50-#8000),hl
pop hl
ld (#F854+7+#50-#8000),hl
pop hl
ld (#C0A4+7+#50-#8000),hl
pop hl
ld (#C8A4+7+#50-#8000),hl
pop hl
ld (#D0A4+7+#50-#8000),hl
pop hl
ld (#D8A4+7+#50-#8000),hl
pop hl
ld (#E0A4+7+#50-#8000),hl
pop hl
ld (#E8A4+7+#50-#8000),hl
pop hl
ld (#F0A4+7+#50-#8000),hl
pop hl
ld (#F8A4+7+#50-#8000),hl
pop hl
ld (#C0F4+7+#50-#8000),hl
pop hl
ld (#C8F4+7+#50-#8000),hl
pop hl
ld (#D0F4+7+#50-#8000),hl
pop hl
ld (#D8F4+7+#50-#8000),hl
pop hl
ld (#E0F4+7+#50-#8000),hl
pop hl
ld (#E8F4+7+#50-#8000),hl
pop hl
ld (#F0F4+7+#50-#8000),hl
pop hl
ld (#F8F4+7+#50-#8000),hl
pop hl
ld (#C144+7+#50-#8000),hl
pop hl
ld (#C944+7+#50-#8000),hl
pop hl
ld (#D144+7+#50-#8000),hl
pop hl
ld (#D944+7+#50-#8000),hl
pop hl
ld (#E144+7+#50-#8000),hl
pop hl
ld (#E944+7+#50-#8000),hl
pop hl
ld (#F144+7+#50-#8000),hl
pop hl
ld (#F944+7+#50-#8000),hl
pop hl
ld (#C194+7+#50-#8000),hl
pop hl
ld (#C994+7+#50-#8000),hl
pop hl
ld (#D194+7+#50-#8000),hl
pop hl
ld (#D994+7+#50-#8000),hl
pop hl
ld (#E194+7+#50-#8000),hl
pop hl
ld (#E994+7+#50-#8000),hl
pop hl
ld (#F194+7+#50-#8000),hl
pop hl
ld (#F994+7+#50-#8000),hl
pop hl
ld (#C1E4+7+#50-#8000),hl
pop hl
ld (#C9E4+7+#50-#8000),hl
pop hl
ld (#D1E4+7+#50-#8000),hl
pop hl
ld (#D9E4+7+#50-#8000),hl
pop hl
ld (#E1E4+7+#50-#8000),hl
pop hl
ld (#E9E4+7+#50-#8000),hl
pop hl
ld (#F1E4+7+#50-#8000),hl
pop hl
ld (#F9E4+7+#50-#8000),hl
pop hl
ld (#C234+7+#50-#8000),hl
pop hl
ld (#CA34+7+#50-#8000),hl
pop hl
ld (#D234+7+#50-#8000),hl
pop hl
ld (#DA34+7+#50-#8000),hl
pop hl
ld (#E234+7+#50-#8000),hl
pop hl
ld (#EA34+7+#50-#8000),hl
pop hl
ld (#F234+7+#50-#8000),hl


col4 
ld sp,spr4
pop hl
ld (#C006+7+#50-#8000),hl
pop hl
ld (#C806+7+#50-#8000),hl
pop hl
ld (#D006+7+#50-#8000),hl
pop hl
ld (#D806+7+#50-#8000),hl
pop hl
ld (#E006+7+#50-#8000),hl
pop hl
ld (#E806+7+#50-#8000),hl
pop hl
ld (#F006+7+#50-#8000),hl
pop hl
ld (#F806+7+#50-#8000),hl
pop hl
ld (#C056+7+#50-#8000),hl
pop hl
ld (#C856+7+#50-#8000),hl
pop hl
ld (#D056+7+#50-#8000),hl
pop hl
ld (#D856+7+#50-#8000),hl
pop hl
ld (#E056+7+#50-#8000),hl
pop hl
ld (#E856+7+#50-#8000),hl
pop hl
ld (#F056+7+#50-#8000),hl
pop hl
ld (#F856+7+#50-#8000),hl
pop hl
ld (#C0A6+7+#50-#8000),hl
pop hl
ld (#C8A6+7+#50-#8000),hl
pop hl
ld (#D0A6+7+#50-#8000),hl
pop hl
ld (#D8A6+7+#50-#8000),hl
pop hl
ld (#E0A6+7+#50-#8000),hl
pop hl
ld (#E8A6+7+#50-#8000),hl
pop hl
ld (#F0A6+7+#50-#8000),hl
pop hl
ld (#F8A6+7+#50-#8000),hl
pop hl
ld (#C0F6+7+#50-#8000),hl
pop hl
ld (#C8F6+7+#50-#8000),hl
pop hl
ld (#D0F6+7+#50-#8000),hl
pop hl
ld (#D8F6+7+#50-#8000),hl
pop hl
ld (#E0F6+7+#50-#8000),hl
pop hl
ld (#E8F6+7+#50-#8000),hl
pop hl
ld (#F0F6+7+#50-#8000),hl
pop hl
ld (#F8F6+7+#50-#8000),hl
pop hl
ld (#C146+7+#50-#8000),hl
pop hl
ld (#C946+7+#50-#8000),hl
pop hl
ld (#D146+7+#50-#8000),hl
pop hl
ld (#D946+7+#50-#8000),hl
pop hl
ld (#E146+7+#50-#8000),hl
pop hl
ld (#E946+7+#50-#8000),hl
pop hl
ld (#F146+7+#50-#8000),hl
pop hl
ld (#F946+7+#50-#8000),hl
pop hl
ld (#C196+7+#50-#8000),hl
pop hl
ld (#C996+7+#50-#8000),hl
pop hl
ld (#D196+7+#50-#8000),hl
pop hl
ld (#D996+7+#50-#8000),hl
pop hl
ld (#E196+7+#50-#8000),hl
pop hl
ld (#E996+7+#50-#8000),hl
pop hl
ld (#F196+7+#50-#8000),hl
pop hl
ld (#F996+7+#50-#8000),hl
pop hl
ld (#C1E6+7+#50-#8000),hl
pop hl
ld (#C9E6+7+#50-#8000),hl
pop hl
ld (#D1E6+7+#50-#8000),hl
pop hl
ld (#D9E6+7+#50-#8000),hl
pop hl
ld (#E1E6+7+#50-#8000),hl
pop hl
ld (#E9E6+7+#50-#8000),hl
pop hl
ld (#F1E6+7+#50-#8000),hl
pop hl
ld (#F9E6+7+#50-#8000),hl
pop hl
ld (#C236+7+#50-#8000),hl
pop hl
ld (#CA36+7+#50-#8000),hl
pop hl
ld (#D236+7+#50-#8000),hl
pop hl
ld (#DA36+7+#50-#8000),hl
pop hl
ld (#E236+7+#50-#8000),hl
pop hl
ld (#EA36+7+#50-#8000),hl
pop hl
ld (#F236+7+#50-#8000),hl


col5 
ld sp,spr5
pop hl
ld (#C008+7+#50-#8000),hl
pop hl
ld (#C808+7+#50-#8000),hl
pop hl
ld (#D008+7+#50-#8000),hl
pop hl
ld (#D808+7+#50-#8000),hl
pop hl
ld (#E008+7+#50-#8000),hl
pop hl
ld (#E808+7+#50-#8000),hl
pop hl
ld (#F008+7+#50-#8000),hl
pop hl
ld (#F808+7+#50-#8000),hl
pop hl
ld (#C058+7+#50-#8000),hl
pop hl
ld (#C858+7+#50-#8000),hl
pop hl
ld (#D058+7+#50-#8000),hl
pop hl
ld (#D858+7+#50-#8000),hl
pop hl
ld (#E058+7+#50-#8000),hl
pop hl
ld (#E858+7+#50-#8000),hl
pop hl
ld (#F058+7+#50-#8000),hl
pop hl
ld (#F858+7+#50-#8000),hl
pop hl
ld (#C0A8+7+#50-#8000),hl
pop hl
ld (#C8A8+7+#50-#8000),hl
pop hl
ld (#D0A8+7+#50-#8000),hl
pop hl
ld (#D8A8+7+#50-#8000),hl
pop hl
ld (#E0A8+7+#50-#8000),hl
pop hl
ld (#E8A8+7+#50-#8000),hl
pop hl
ld (#F0A8+7+#50-#8000),hl
pop hl
ld (#F8A8+7+#50-#8000),hl
pop hl
ld (#C0F8+7+#50-#8000),hl
pop hl
ld (#C8F8+7+#50-#8000),hl
pop hl
ld (#D0F8+7+#50-#8000),hl
pop hl
ld (#D8F8+7+#50-#8000),hl
pop hl
ld (#E0F8+7+#50-#8000),hl
pop hl
ld (#E8F8+7+#50-#8000),hl
pop hl
ld (#F0F8+7+#50-#8000),hl
pop hl
ld (#F8F8+7+#50-#8000),hl
pop hl
ld (#C148+7+#50-#8000),hl
pop hl
ld (#C948+7+#50-#8000),hl
pop hl
ld (#D148+7+#50-#8000),hl
pop hl
ld (#D948+7+#50-#8000),hl
pop hl
ld (#E148+7+#50-#8000),hl
pop hl
ld (#E948+7+#50-#8000),hl
pop hl
ld (#F148+7+#50-#8000),hl
pop hl
ld (#F948+7+#50-#8000),hl
pop hl
ld (#C198+7+#50-#8000),hl
pop hl
ld (#C998+7+#50-#8000),hl
pop hl
ld (#D198+7+#50-#8000),hl
pop hl
ld (#D998+7+#50-#8000),hl
pop hl
ld (#E198+7+#50-#8000),hl
pop hl
ld (#E998+7+#50-#8000),hl
pop hl
ld (#F198+7+#50-#8000),hl
pop hl
ld (#F998+7+#50-#8000),hl
pop hl
ld (#C1E8+7+#50-#8000),hl
pop hl
ld (#C9E8+7+#50-#8000),hl
pop hl
ld (#D1E8+7+#50-#8000),hl
pop hl
ld (#D9E8+7+#50-#8000),hl
pop hl
ld (#E1E8+7+#50-#8000),hl
pop hl
ld (#E9E8+7+#50-#8000),hl
pop hl
ld (#F1E8+7+#50-#8000),hl
pop hl
ld (#F9E8+7+#50-#8000),hl
pop hl
ld (#C238+7+#50-#8000),hl
pop hl
ld (#CA38+7+#50-#8000),hl
pop hl
ld (#D238+7+#50-#8000),hl
pop hl
ld (#DA38+7+#50-#8000),hl
pop hl
ld (#E238+7+#50-#8000),hl
pop hl
ld (#EA38+7+#50-#8000),hl
pop hl
ld (#F238+7+#50-#8000),hl


col6 
ld sp,spr6
pop hl
ld (#C00A+7+#50-#8000),hl
pop hl
ld (#C80A+7+#50-#8000),hl
pop hl
ld (#D00A+7+#50-#8000),hl
pop hl
ld (#D80A+7+#50-#8000),hl
pop hl
ld (#E00A+7+#50-#8000),hl
pop hl
ld (#E80A+7+#50-#8000),hl
pop hl
ld (#F00A+7+#50-#8000),hl
pop hl
ld (#F80A+7+#50-#8000),hl
pop hl
ld (#C05A+7+#50-#8000),hl
pop hl
ld (#C85A+7+#50-#8000),hl
pop hl
ld (#D05A+7+#50-#8000),hl
pop hl
ld (#D85A+7+#50-#8000),hl
pop hl
ld (#E05A+7+#50-#8000),hl
pop hl
ld (#E85A+7+#50-#8000),hl
pop hl
ld (#F05A+7+#50-#8000),hl
pop hl
ld (#F85A+7+#50-#8000),hl
pop hl
ld (#C0AA+7+#50-#8000),hl
pop hl
ld (#C8AA+7+#50-#8000),hl
pop hl
ld (#D0AA+7+#50-#8000),hl
pop hl
ld (#D8AA+7+#50-#8000),hl
pop hl
ld (#E0AA+7+#50-#8000),hl
pop hl
ld (#E8AA+7+#50-#8000),hl
pop hl
ld (#F0AA+7+#50-#8000),hl
pop hl
ld (#F8AA+7+#50-#8000),hl
pop hl
ld (#C0FA+7+#50-#8000),hl
pop hl
ld (#C8FA+7+#50-#8000),hl
pop hl
ld (#D0FA+7+#50-#8000),hl
pop hl
ld (#D8FA+7+#50-#8000),hl
pop hl
ld (#E0FA+7+#50-#8000),hl
pop hl
ld (#E8FA+7+#50-#8000),hl
pop hl
ld (#F0FA+7+#50-#8000),hl
pop hl
ld (#F8FA+7+#50-#8000),hl
pop hl
ld (#C14A+7+#50-#8000),hl
pop hl
ld (#C94A+7+#50-#8000),hl
pop hl
ld (#D14A+7+#50-#8000),hl
pop hl
ld (#D94A+7+#50-#8000),hl
pop hl
ld (#E14A+7+#50-#8000),hl
pop hl
ld (#E94A+7+#50-#8000),hl
pop hl
ld (#F14A+7+#50-#8000),hl
pop hl
ld (#F94A+7+#50-#8000),hl
pop hl
ld (#C19A+7+#50-#8000),hl
pop hl
ld (#C99A+7+#50-#8000),hl
pop hl
ld (#D19A+7+#50-#8000),hl
pop hl
ld (#D99A+7+#50-#8000),hl
pop hl
ld (#E19A+7+#50-#8000),hl
pop hl
ld (#E99A+7+#50-#8000),hl
pop hl
ld (#F19A+7+#50-#8000),hl
pop hl
ld (#F99A+7+#50-#8000),hl
pop hl
ld (#C1EA+7+#50-#8000),hl
pop hl
ld (#C9EA+7+#50-#8000),hl
pop hl
ld (#D1EA+7+#50-#8000),hl
pop hl
ld (#D9EA+7+#50-#8000),hl
pop hl
ld (#E1EA+7+#50-#8000),hl
pop hl
ld (#E9EA+7+#50-#8000),hl
pop hl
ld (#F1EA+7+#50-#8000),hl
pop hl
ld (#F9EA+7+#50-#8000),hl
pop hl
ld (#C23A+7+#50-#8000),hl
pop hl
ld (#CA3A+7+#50-#8000),hl
pop hl
ld (#D23A+7+#50-#8000),hl
pop hl
ld (#DA3A+7+#50-#8000),hl
pop hl
ld (#E23A+7+#50-#8000),hl
pop hl
ld (#EA3A+7+#50-#8000),hl
pop hl
ld (#F23A+7+#50-#8000),hl


col7 
ld sp,spr7
pop hl
ld (#C00C+7+#50-#8000),hl
pop hl
ld (#C80C+7+#50-#8000),hl
pop hl
ld (#D00C+7+#50-#8000),hl
pop hl
ld (#D80C+7+#50-#8000),hl
pop hl
ld (#E00C+7+#50-#8000),hl
pop hl
ld (#E80C+7+#50-#8000),hl
pop hl
ld (#F00C+7+#50-#8000),hl
pop hl
ld (#F80C+7+#50-#8000),hl
pop hl
ld (#C05C+7+#50-#8000),hl
pop hl
ld (#C85C+7+#50-#8000),hl
pop hl
ld (#D05C+7+#50-#8000),hl
pop hl
ld (#D85C+7+#50-#8000),hl
pop hl
ld (#E05C+7+#50-#8000),hl
pop hl
ld (#E85C+7+#50-#8000),hl
pop hl
ld (#F05C+7+#50-#8000),hl
pop hl
ld (#F85C+7+#50-#8000),hl
pop hl
ld (#C0AC+7+#50-#8000),hl
pop hl
ld (#C8AC+7+#50-#8000),hl
pop hl
ld (#D0AC+7+#50-#8000),hl
pop hl
ld (#D8AC+7+#50-#8000),hl
pop hl
ld (#E0AC+7+#50-#8000),hl
pop hl
ld (#E8AC+7+#50-#8000),hl
pop hl
ld (#F0AC+7+#50-#8000),hl
pop hl
ld (#F8AC+7+#50-#8000),hl
pop hl
ld (#C0FC+7+#50-#8000),hl
pop hl
ld (#C8FC+7+#50-#8000),hl
pop hl
ld (#D0FC+7+#50-#8000),hl
pop hl
ld (#D8FC+7+#50-#8000),hl
pop hl
ld (#E0FC+7+#50-#8000),hl
pop hl
ld (#E8FC+7+#50-#8000),hl
pop hl
ld (#F0FC+7+#50-#8000),hl
pop hl
ld (#F8FC+7+#50-#8000),hl
pop hl
ld (#C14C+7+#50-#8000),hl
pop hl
ld (#C94C+7+#50-#8000),hl
pop hl
ld (#D14C+7+#50-#8000),hl
pop hl
ld (#D94C+7+#50-#8000),hl
pop hl
ld (#E14C+7+#50-#8000),hl
pop hl
ld (#E94C+7+#50-#8000),hl
pop hl
ld (#F14C+7+#50-#8000),hl
pop hl
ld (#F94C+7+#50-#8000),hl
pop hl
ld (#C19C+7+#50-#8000),hl
pop hl
ld (#C99C+7+#50-#8000),hl
pop hl
ld (#D19C+7+#50-#8000),hl
pop hl
ld (#D99C+7+#50-#8000),hl
pop hl
ld (#E19C+7+#50-#8000),hl
pop hl
ld (#E99C+7+#50-#8000),hl
pop hl
ld (#F19C+7+#50-#8000),hl
pop hl
ld (#F99C+7+#50-#8000),hl
pop hl
ld (#C1EC+7+#50-#8000),hl
pop hl
ld (#C9EC+7+#50-#8000),hl
pop hl
ld (#D1EC+7+#50-#8000),hl
pop hl
ld (#D9EC+7+#50-#8000),hl
pop hl
ld (#E1EC+7+#50-#8000),hl
pop hl
ld (#E9EC+7+#50-#8000),hl
pop hl
ld (#F1EC+7+#50-#8000),hl
pop hl
ld (#F9EC+7+#50-#8000),hl
pop hl
ld (#C23C+7+#50-#8000),hl
pop hl
ld (#CA3C+7+#50-#8000),hl
pop hl
ld (#D23C+7+#50-#8000),hl
pop hl
ld (#DA3C+7+#50-#8000),hl
pop hl
ld (#E23C+7+#50-#8000),hl
pop hl
ld (#EA3C+7+#50-#8000),hl
pop hl
ld (#F23C+7+#50-#8000),hl


col8 
ld sp,spr8
pop hl
ld (#C00E+7+#50-#8000),hl
pop hl
ld (#C80E+7+#50-#8000),hl
pop hl
ld (#D00E+7+#50-#8000),hl
pop hl
ld (#D80E+7+#50-#8000),hl
pop hl
ld (#E00E+7+#50-#8000),hl
pop hl
ld (#E80E+7+#50-#8000),hl
pop hl
ld (#F00E+7+#50-#8000),hl
pop hl
ld (#F80E+7+#50-#8000),hl
pop hl
ld (#C05E+7+#50-#8000),hl
pop hl
ld (#C85E+7+#50-#8000),hl
pop hl
ld (#D05E+7+#50-#8000),hl
pop hl
ld (#D85E+7+#50-#8000),hl
pop hl
ld (#E05E+7+#50-#8000),hl
pop hl
ld (#E85E+7+#50-#8000),hl
pop hl
ld (#F05E+7+#50-#8000),hl
pop hl
ld (#F85E+7+#50-#8000),hl
pop hl
ld (#C0AE+7+#50-#8000),hl
pop hl
ld (#C8AE+7+#50-#8000),hl
pop hl
ld (#D0AE+7+#50-#8000),hl
pop hl
ld (#D8AE+7+#50-#8000),hl
pop hl
ld (#E0AE+7+#50-#8000),hl
pop hl
ld (#E8AE+7+#50-#8000),hl
pop hl
ld (#F0AE+7+#50-#8000),hl
pop hl
ld (#F8AE+7+#50-#8000),hl
pop hl
ld (#C0FE+7+#50-#8000),hl
pop hl
ld (#C8FE+7+#50-#8000),hl
pop hl
ld (#D0FE+7+#50-#8000),hl
pop hl
ld (#D8FE+7+#50-#8000),hl
pop hl
ld (#E0FE+7+#50-#8000),hl
pop hl
ld (#E8FE+7+#50-#8000),hl
pop hl
ld (#F0FE+7+#50-#8000),hl
pop hl
ld (#F8FE+7+#50-#8000),hl
pop hl
ld (#C14E+7+#50-#8000),hl
pop hl
ld (#C94E+7+#50-#8000),hl
pop hl
ld (#D14E+7+#50-#8000),hl
pop hl
ld (#D94E+7+#50-#8000),hl
pop hl
ld (#E14E+7+#50-#8000),hl
pop hl
ld (#E94E+7+#50-#8000),hl
pop hl
ld (#F14E+7+#50-#8000),hl
pop hl
ld (#F94E+7+#50-#8000),hl
pop hl
ld (#C19E+7+#50-#8000),hl
pop hl
ld (#C99E+7+#50-#8000),hl
pop hl
ld (#D19E+7+#50-#8000),hl
pop hl
ld (#D99E+7+#50-#8000),hl
pop hl
ld (#E19E+7+#50-#8000),hl
pop hl
ld (#E99E+7+#50-#8000),hl
pop hl
ld (#F19E+7+#50-#8000),hl
pop hl
ld (#F99E+7+#50-#8000),hl
pop hl
ld (#C1EE+7+#50-#8000),hl
pop hl
ld (#C9EE+7+#50-#8000),hl
pop hl
ld (#D1EE+7+#50-#8000),hl 
pop hl
ld (#D9EE+7+#50-#8000),hl
pop hl
ld (#E1EE+7+#50-#8000),hl
pop hl
ld (#E9EE+7+#50-#8000),hl
pop hl
ld (#F1EE+7+#50-#8000),hl
pop hl
ld (#F9EE+7+#50-#8000),hl
pop hl
ld (#C23E+7+#50-#8000),hl
pop hl
ld (#CA3E+7+#50-#8000),hl
pop hl
ld (#D23E+7+#50-#8000),hl
pop hl
ld (#DA3E+7+#50-#8000),hl
pop hl
ld (#E23E+7+#50-#8000),hl
pop hl
ld (#EA3E+7+#50-#8000),hl
pop hl
ld (#F23E+7+#50-#8000),hl


col9 
ld sp,spr9
pop hl
ld (#C010+7+#50-#8000),hl
pop hl
ld (#C810+7+#50-#8000),hl
pop hl
ld (#D010+7+#50-#8000),hl
pop hl
ld (#D810+7+#50-#8000),hl
pop hl
ld (#E010+7+#50-#8000),hl
pop hl
ld (#E810+7+#50-#8000),hl
pop hl
ld (#F010+7+#50-#8000),hl
pop hl
ld (#F810+7+#50-#8000),hl
pop hl
ld (#C060+7+#50-#8000),hl
pop hl
ld (#C860+7+#50-#8000),hl
pop hl
ld (#D060+7+#50-#8000),hl
pop hl
ld (#D860+7+#50-#8000),hl
pop hl
ld (#E060+7+#50-#8000),hl
pop hl
ld (#E860+7+#50-#8000),hl
pop hl
ld (#F060+7+#50-#8000),hl
pop hl
ld (#F860+7+#50-#8000),hl
pop hl
ld (#C0B0+7+#50-#8000),hl
pop hl
ld (#C8B0+7+#50-#8000),hl
pop hl
ld (#D0B0+7+#50-#8000),hl
pop hl
ld (#D8B0+7+#50-#8000),hl
pop hl
ld (#E0B0+7+#50-#8000),hl
pop hl
ld (#E8B0+7+#50-#8000),hl
pop hl
ld (#F0B0+7+#50-#8000),hl
pop hl
ld (#F8B0+7+#50-#8000),hl
pop hl
ld (#C100+7+#50-#8000),hl
pop hl
ld (#C900+7+#50-#8000),hl
pop hl
ld (#D100+7+#50-#8000),hl
pop hl
ld (#D900+7+#50-#8000),hl
pop hl
ld (#E100+7+#50-#8000),hl
pop hl
ld (#E900+7+#50-#8000),hl
pop hl
ld (#F100+7+#50-#8000),hl
pop hl
ld (#F900+7+#50-#8000),hl
pop hl
ld (#C150+7+#50-#8000),hl
pop hl
ld (#C950+7+#50-#8000),hl
pop hl
ld (#D150+7+#50-#8000),hl
pop hl
ld (#D950+7+#50-#8000),hl
pop hl
ld (#E150+7+#50-#8000),hl
pop hl
ld (#E950+7+#50-#8000),hl
pop hl
ld (#F150+7+#50-#8000),hl
pop hl
ld (#F950+7+#50-#8000),hl
pop hl
ld (#C1A0+7+#50-#8000),hl
pop hl
ld (#C9A0+7+#50-#8000),hl
pop hl
ld (#D1A0+7+#50-#8000),hl
pop hl
ld (#D9A0+7+#50-#8000),hl
pop hl
ld (#E1A0+7+#50-#8000),hl
pop hl
ld (#E9A0+7+#50-#8000),hl
pop hl
ld (#F1A0+7+#50-#8000),hl
pop hl
ld (#F9A0+7+#50-#8000),hl
pop hl
ld (#C1F0+7+#50-#8000),hl
pop hl
ld (#C9F0+7+#50-#8000),hl
pop hl
ld (#D1F0+7+#50-#8000),hl
pop hl
ld (#D9F0+7+#50-#8000),hl
pop hl
ld (#E1F0+7+#50-#8000),hl
pop hl
ld (#E9F0+7+#50-#8000),hl
pop hl
ld (#F1F0+7+#50-#8000),hl
pop hl
ld (#F9F0+7+#50-#8000),hl
pop hl
ld (#C240+7+#50-#8000),hl
pop hl
ld (#CA40+7+#50-#8000),hl
pop hl
ld (#D240+7+#50-#8000),hl
pop hl
ld (#DA40+7+#50-#8000),hl
pop hl
ld (#E240+7+#50-#8000),hl
pop hl
ld (#EA40+7+#50-#8000),hl
pop hl
ld (#F240+7+#50-#8000),hl


col10 
ld sp,spr10
pop hl
ld (#C012+7+#50-#8000),hl
pop hl
ld (#C812+7+#50-#8000),hl
pop hl
ld (#D012+7+#50-#8000),hl
pop hl
ld (#D812+7+#50-#8000),hl
pop hl
ld (#E012+7+#50-#8000),hl
pop hl
ld (#E812+7+#50-#8000),hl
pop hl
ld (#F012+7+#50-#8000),hl
pop hl
ld (#F812+7+#50-#8000),hl
pop hl
ld (#C062+7+#50-#8000),hl
pop hl
ld (#C862+7+#50-#8000),hl
pop hl
ld (#D062+7+#50-#8000),hl
pop hl
ld (#D862+7+#50-#8000),hl
pop hl
ld (#E062+7+#50-#8000),hl
pop hl
ld (#E862+7+#50-#8000),hl
pop hl
ld (#F062+7+#50-#8000),hl
pop hl
ld (#F862+7+#50-#8000),hl
pop hl
ld (#C0B2+7+#50-#8000),hl
pop hl
ld (#C8B2+7+#50-#8000),hl
pop hl
ld (#D0B2+7+#50-#8000),hl
pop hl
ld (#D8B2+7+#50-#8000),hl
pop hl
ld (#E0B2+7+#50-#8000),hl
pop hl
ld (#E8B2+7+#50-#8000),hl
pop hl
ld (#F0B2+7+#50-#8000),hl
pop hl
ld (#F8B2+7+#50-#8000),hl
pop hl
ld (#C102+7+#50-#8000),hl
pop hl
ld (#C902+7+#50-#8000),hl
pop hl
ld (#D102+7+#50-#8000),hl
pop hl
ld (#D902+7+#50-#8000),hl
pop hl
ld (#E102+7+#50-#8000),hl
pop hl
ld (#E902+7+#50-#8000),hl
pop hl
ld (#F102+7+#50-#8000),hl
pop hl
ld (#F902+7+#50-#8000),hl
pop hl
ld (#C152+7+#50-#8000),hl
pop hl
ld (#C952+7+#50-#8000),hl
pop hl
ld (#D152+7+#50-#8000),hl
pop hl
ld (#D952+7+#50-#8000),hl
pop hl
ld (#E152+7+#50-#8000),hl
pop hl
ld (#E952+7+#50-#8000),hl
pop hl
ld (#F152+7+#50-#8000),hl
pop hl
ld (#F952+7+#50-#8000),hl
pop hl
ld (#C1A2+7+#50-#8000),hl
pop hl
ld (#C9A2+7+#50-#8000),hl
pop hl
ld (#D1A2+7+#50-#8000),hl
pop hl
ld (#D9A2+7+#50-#8000),hl
pop hl
ld (#E1A2+7+#50-#8000),hl
pop hl
ld (#E9A2+7+#50-#8000),hl
pop hl
ld (#F1A2+7+#50-#8000),hl
pop hl
ld (#F9A2+7+#50-#8000),hl
pop hl
ld (#C1F2+7+#50-#8000),hl
pop hl

out (c),a
; paf ! un raster (ligne grille horizontale)

ld (#C9F2+7+#50-#8000),hl
pop hl
ld (#D1F2+7+#50-#8000),hl
pop hl
ld (#D9F2+7+#50-#8000),hl
pop hl
ld (#E1F2+7+#50-#8000),hl
pop hl
ld (#E9F2+7+#50-#8000),hl
pop hl
ld (#F1F2+7+#50-#8000),hl
pop hl
ld (#F9F2+7+#50-#8000),hl
pop hl

out (c),e
; paf ! fin du raster (ligne grille horizontale)


ld (#C242+7+#50-#8000),hl
pop hl
ld (#CA42+7+#50-#8000),hl
pop hl
ld (#D242+7+#50-#8000),hl
pop hl
ld (#DA42+7+#50-#8000),hl
pop hl
ld (#E242+7+#50-#8000),hl
pop hl
ld (#EA42+7+#50-#8000),hl
pop hl
ld (#F242+7+#50-#8000),hl

col11 
ld sp,spr11
pop hl
ld (#C014+7+#50-#8000),hl
pop hl
ld (#C814+7+#50-#8000),hl
pop hl
ld (#D014+7+#50-#8000),hl
pop hl
ld (#D814+7+#50-#8000),hl
pop hl
ld (#E014+7+#50-#8000),hl
pop hl
ld (#E814+7+#50-#8000),hl
pop hl
ld (#F014+7+#50-#8000),hl
pop hl
ld (#F814+7+#50-#8000),hl
pop hl
ld (#C064+7+#50-#8000),hl
pop hl
ld (#C864+7+#50-#8000),hl
pop hl
ld (#D064+7+#50-#8000),hl
pop hl
ld (#D864+7+#50-#8000),hl
pop hl
ld (#E064+7+#50-#8000),hl
pop hl
ld (#E864+7+#50-#8000),hl
pop hl
ld (#F064+7+#50-#8000),hl
pop hl
ld (#F864+7+#50-#8000),hl
pop hl
ld (#C0B4+7+#50-#8000),hl
pop hl
ld (#C8B4+7+#50-#8000),hl
pop hl
ld (#D0B4+7+#50-#8000),hl
pop hl
ld (#D8B4+7+#50-#8000),hl
pop hl
ld (#E0B4+7+#50-#8000),hl
pop hl
ld (#E8B4+7+#50-#8000),hl
pop hl
ld (#F0B4+7+#50-#8000),hl
pop hl
ld (#F8B4+7+#50-#8000),hl
pop hl
ld (#C104+7+#50-#8000),hl
pop hl
ld (#C904+7+#50-#8000),hl
pop hl
ld (#D104+7+#50-#8000),hl
pop hl
ld (#D904+7+#50-#8000),hl
pop hl
ld (#E104+7+#50-#8000),hl
pop hl
ld (#E904+7+#50-#8000),hl
pop hl
ld (#F104+7+#50-#8000),hl
pop hl
ld (#F904+7+#50-#8000),hl
pop hl
ld (#C154+7+#50-#8000),hl
pop hl
					out (c),a
ld (#C954+7+#50-#8000),hl
pop hl
ld (#D154+7+#50-#8000),hl
pop hl
ld (#D954+7+#50-#8000),hl
pop hl
ld (#E154+7+#50-#8000),hl
pop hl
ld (#E954+7+#50-#8000),hl
pop hl
ld (#F154+7+#50-#8000),hl
pop hl
ld (#F954+7+#50-#8000),hl
pop hl
ld (#C1A4+7+#50-#8000),hl
pop hl
					out (c),e
ld (#C9A4+7+#50-#8000),hl
pop hl
ld (#D1A4+7+#50-#8000),hl
pop hl
ld (#D9A4+7+#50-#8000),hl
pop hl
ld (#E1A4+7+#50-#8000),hl
pop hl
ld (#E9A4+7+#50-#8000),hl
pop hl
ld (#F1A4+7+#50-#8000),hl
pop hl
ld (#F9A4+7+#50-#8000),hl
pop hl
ld (#C1F4+7+#50-#8000),hl
pop hl
ld (#C9F4+7+#50-#8000),hl
pop hl
ld (#D1F4+7+#50-#8000),hl
pop hl
ld (#D9F4+7+#50-#8000),hl
pop hl
ld (#E1F4+7+#50-#8000),hl
pop hl
ld (#E9F4+7+#50-#8000),hl
pop hl
ld (#F1F4+7+#50-#8000),hl
pop hl
ld (#F9F4+7+#50-#8000),hl
pop hl
ld (#C244+7+#50-#8000),hl
pop hl
ld (#CA44+7+#50-#8000),hl
pop hl
ld (#D244+7+#50-#8000),hl
pop hl
ld (#DA44+7+#50-#8000),hl
pop hl
ld (#E244+7+#50-#8000),hl
pop hl
ld (#EA44+7+#50-#8000),hl
pop hl
ld (#F244+7+#50-#8000),hl


col12 
ld sp,spr12
pop hl
ld (#C016+7+#50-#8000),hl
pop hl
ld (#C816+7+#50-#8000),hl
pop hl
ld (#D016+7+#50-#8000),hl
pop hl
ld (#D816+7+#50-#8000),hl
pop hl
ld (#E016+7+#50-#8000),hl
pop hl
ld (#E816+7+#50-#8000),hl
pop hl
ld (#F016+7+#50-#8000),hl
pop hl
ld (#F816+7+#50-#8000),hl
pop hl
ld (#C066+7+#50-#8000),hl
pop hl
ld (#C866+7+#50-#8000),hl
pop hl
ld (#D066+7+#50-#8000),hl
pop hl
ld (#D866+7+#50-#8000),hl
pop hl
ld (#E066+7+#50-#8000),hl
pop hl
ld (#E866+7+#50-#8000),hl
pop hl
ld (#F066+7+#50-#8000),hl
pop hl
ld (#F866+7+#50-#8000),hl
					out (c),a
pop hl
ld (#C0B6+7+#50-#8000),hl
pop hl
ld (#C8B6+7+#50-#8000),hl
pop hl
ld (#D0B6+7+#50-#8000),hl
pop hl
ld (#D8B6+7+#50-#8000),hl
pop hl
ld (#E0B6+7+#50-#8000),hl
pop hl
ld (#E8B6+7+#50-#8000),hl
pop hl
ld (#F0B6+7+#50-#8000),hl
pop hl
					out (c),e
ld (#F8B6+7+#50-#8000),hl
pop hl
ld (#C106+7+#50-#8000),hl
pop hl
ld (#C906+7+#50-#8000),hl
pop hl
ld (#D106+7+#50-#8000),hl
pop hl
ld (#D906+7+#50-#8000),hl
pop hl
ld (#E106+7+#50-#8000),hl
pop hl
ld (#E906+7+#50-#8000),hl
pop hl
ld (#F106+7+#50-#8000),hl
pop hl
ld (#F906+7+#50-#8000),hl
pop hl
ld (#C156+7+#50-#8000),hl
pop hl
ld (#C956+7+#50-#8000),hl
pop hl
ld (#D156+7+#50-#8000),hl
pop hl
ld (#D956+7+#50-#8000),hl
pop hl
ld (#E156+7+#50-#8000),hl
pop hl
ld (#E956+7+#50-#8000),hl
pop hl
ld (#F156+7+#50-#8000),hl
pop hl
ld (#F956+7+#50-#8000),hl
pop hl
ld (#C1A6+7+#50-#8000),hl
pop hl
ld (#C9A6+7+#50-#8000),hl
pop hl
ld (#D1A6+7+#50-#8000),hl
pop hl
ld (#D9A6+7+#50-#8000),hl
pop hl
ld (#E1A6+7+#50-#8000),hl
pop hl
ld (#E9A6+7+#50-#8000),hl
pop hl
ld (#F1A6+7+#50-#8000),hl
pop hl
ld (#F9A6+7+#50-#8000),hl
pop hl
ld (#C1F6+7+#50-#8000),hl
pop hl
ld (#C9F6+7+#50-#8000),hl
pop hl
ld (#D1F6+7+#50-#8000),hl
pop hl
ld (#D9F6+7+#50-#8000),hl
pop hl
ld (#E1F6+7+#50-#8000),hl
pop hl
ld (#E9F6+7+#50-#8000),hl
pop hl
ld (#F1F6+7+#50-#8000),hl
pop hl
ld (#F9F6+7+#50-#8000),hl
pop hl
ld (#C246+7+#50-#8000),hl
pop hl
ld (#CA46+7+#50-#8000),hl
pop hl
ld (#D246+7+#50-#8000),hl
pop hl
ld (#DA46+7+#50-#8000),hl
pop hl
ld (#E246+7+#50-#8000),hl
pop hl
ld (#EA46+7+#50-#8000),hl
pop hl
ld (#F246+7+#50-#8000),hl


col13 
ld sp,spr13
pop hl
ld (#C018+7+#50-#8000),hl
pop hl
ld (#C818+7+#50-#8000),hl
					out (c),a
pop hl
ld (#D018+7+#50-#8000),hl
pop hl
ld (#D818+7+#50-#8000),hl
pop hl
ld (#E018+7+#50-#8000),hl
pop hl
ld (#E818+7+#50-#8000),hl
pop hl
ld (#F018+7+#50-#8000),hl
pop hl
ld (#F818+7+#50-#8000),hl
pop hl
ld (#C068+7+#50-#8000),hl
					out (c),e
pop hl
ld (#C868+7+#50-#8000),hl
pop hl
ld (#D068+7+#50-#8000),hl
pop hl
ld (#D868+7+#50-#8000),hl
pop hl
ld (#E068+7+#50-#8000),hl
pop hl
ld (#E868+7+#50-#8000),hl
pop hl
ld (#F068+7+#50-#8000),hl
pop hl
ld (#F868+7+#50-#8000),hl
pop hl
ld (#C0B8+7+#50-#8000),hl
pop hl
ld (#C8B8+7+#50-#8000),hl
pop hl
ld (#D0B8+7+#50-#8000),hl
pop hl
ld (#D8B8+7+#50-#8000),hl
pop hl
ld (#E0B8+7+#50-#8000),hl
pop hl
ld (#E8B8+7+#50-#8000),hl
pop hl
ld (#F0B8+7+#50-#8000),hl
pop hl
ld (#F8B8+7+#50-#8000),hl
pop hl
ld (#C108+7+#50-#8000),hl
pop hl
ld (#C908+7+#50-#8000),hl
pop hl
ld (#D108+7+#50-#8000),hl
pop hl
ld (#D908+7+#50-#8000),hl
pop hl
ld (#E108+7+#50-#8000),hl
pop hl
ld (#E908+7+#50-#8000),hl
pop hl
ld (#F108+7+#50-#8000),hl
pop hl
ld (#F908+7+#50-#8000),hl
pop hl
ld (#C158+7+#50-#8000),hl
pop hl
ld (#C958+7+#50-#8000),hl
pop hl
ld (#D158+7+#50-#8000),hl
pop hl
ld (#D958+7+#50-#8000),hl
pop hl
ld (#E158+7+#50-#8000),hl
pop hl
ld (#E958+7+#50-#8000),hl
pop hl
ld (#F158+7+#50-#8000),hl
pop hl
ld (#F958+7+#50-#8000),hl
pop hl
ld (#C1A8+7+#50-#8000),hl
pop hl
ld (#C9A8+7+#50-#8000),hl
pop hl
ld (#D1A8+7+#50-#8000),hl
pop hl
ld (#D9A8+7+#50-#8000),hl
pop hl
ld (#E1A8+7+#50-#8000),hl
pop hl
ld (#E9A8+7+#50-#8000),hl
pop hl
ld (#F1A8+7+#50-#8000),hl
pop hl
ld (#F9A8+7+#50-#8000),hl
pop hl
ld (#C1F8+7+#50-#8000),hl
					out (c),a
pop hl
ld (#C9F8+7+#50-#8000),hl
pop hl
ld (#D1F8+7+#50-#8000),hl
pop hl
ld (#D9F8+7+#50-#8000),hl
pop hl
ld (#E1F8+7+#50-#8000),hl
pop hl
ld (#E9F8+7+#50-#8000),hl
pop hl
ld (#F1F8+7+#50-#8000),hl
					out (c),e
pop hl
ld (#F9F8+7+#50-#8000),hl
pop hl
ld (#C248+7+#50-#8000),hl
pop hl
ld (#CA48+7+#50-#8000),hl
pop hl
ld (#D248+7+#50-#8000),hl
pop hl
ld (#DA48+7+#50-#8000),hl
pop hl
ld (#E248+7+#50-#8000),hl
pop hl
ld (#EA48+7+#50-#8000),hl
pop hl
ld (#F248+7+#50-#8000),hl


col14 
ld sp,spr14
pop hl
ld (#C01A+7+#50-#8000),hl
pop hl
ld (#C81A+7+#50-#8000),hl
pop hl
ld (#D01A+7+#50-#8000),hl
pop hl
ld (#D81A+7+#50-#8000),hl
pop hl
ld (#E01A+7+#50-#8000),hl
pop hl
ld (#E81A+7+#50-#8000),hl
pop hl
ld (#F01A+7+#50-#8000),hl
pop hl
ld (#F81A+7+#50-#8000),hl
pop hl
ld (#C06A+7+#50-#8000),hl
pop hl
ld (#C86A+7+#50-#8000),hl
pop hl
ld (#D06A+7+#50-#8000),hl
pop hl
ld (#D86A+7+#50-#8000),hl
pop hl
ld (#E06A+7+#50-#8000),hl
pop hl
ld (#E86A+7+#50-#8000),hl
pop hl
ld (#F06A+7+#50-#8000),hl
pop hl
ld (#F86A+7+#50-#8000),hl
pop hl
ld (#C0BA+7+#50-#8000),hl
pop hl
ld (#C8BA+7+#50-#8000),hl
pop hl
ld (#D0BA+7+#50-#8000),hl
pop hl
ld (#D8BA+7+#50-#8000),hl
pop hl
ld (#E0BA+7+#50-#8000),hl
pop hl
ld (#E8BA+7+#50-#8000),hl
pop hl
ld (#F0BA+7+#50-#8000),hl
pop hl
ld (#F8BA+7+#50-#8000),hl
pop hl
ld (#C10A+7+#50-#8000),hl
pop hl
ld (#C90A+7+#50-#8000),hl
pop hl
ld (#D10A+7+#50-#8000),hl
pop hl
ld (#D90A+7+#50-#8000),hl
pop hl
ld (#E10A+7+#50-#8000),hl
pop hl
ld (#E90A+7+#50-#8000),hl
pop hl
ld (#F10A+7+#50-#8000),hl
pop hl
ld (#F90A+7+#50-#8000),hl
					out (c),a
pop hl
ld (#C15A+7+#50-#8000),hl
pop hl
ld (#C95A+7+#50-#8000),hl
pop hl
ld (#D15A+7+#50-#8000),hl
pop hl
ld (#D95A+7+#50-#8000),hl
pop hl
ld (#E15A+7+#50-#8000),hl
pop hl
ld (#E95A+7+#50-#8000),hl
pop hl
					out (c),e
ld (#F15A+7+#50-#8000),hl
pop hl
ld (#F95A+7+#50-#8000),hl
pop hl
ld (#C1AA+7+#50-#8000),hl
pop hl
ld (#C9AA+7+#50-#8000),hl
pop hl
ld (#D1AA+7+#50-#8000),hl
pop hl
ld (#D9AA+7+#50-#8000),hl
pop hl
ld (#E1AA+7+#50-#8000),hl
pop hl
ld (#E9AA+7+#50-#8000),hl
pop hl
ld (#F1AA+7+#50-#8000),hl
pop hl
ld (#F9AA+7+#50-#8000),hl
pop hl
ld (#C1FA+7+#50-#8000),hl
pop hl
ld (#C9FA+7+#50-#8000),hl
pop hl
ld (#D1FA+7+#50-#8000),hl
pop hl
ld (#D9FA+7+#50-#8000),hl
pop hl
ld (#E1FA+7+#50-#8000),hl
pop hl
ld (#E9FA+7+#50-#8000),hl
pop hl
ld (#F1FA+7+#50-#8000),hl
pop hl
ld (#F9FA+7+#50-#8000),hl
pop hl
ld (#C24A+7+#50-#8000),hl
pop hl
ld (#CA4A+7+#50-#8000),hl
pop hl
ld (#D24A+7+#50-#8000),hl
pop hl
ld (#DA4A+7+#50-#8000),hl
pop hl
ld (#E24A+7+#50-#8000),hl
pop hl
ld (#EA4A+7+#50-#8000),hl
pop hl
ld (#F24A+7+#50-#8000),hl

col15 
ld sp,spr15
pop hl
ld (#C01C+7+#50-#8000),hl
pop hl
ld (#C81C+7+#50-#8000),hl
pop hl
ld (#D01C+7+#50-#8000),hl
pop hl
ld (#D81C+7+#50-#8000),hl
pop hl
ld (#E01C+7+#50-#8000),hl
pop hl
ld (#E81C+7+#50-#8000),hl
pop hl
ld (#F01C+7+#50-#8000),hl
pop hl
ld (#F81C+7+#50-#8000),hl
pop hl
ld (#C06C+7+#50-#8000),hl
pop hl
ld (#C86C+7+#50-#8000),hl
pop hl
ld (#D06C+7+#50-#8000),hl
pop hl
ld (#D86C+7+#50-#8000),hl
pop hl
ld (#E06C+7+#50-#8000),hl
pop hl
ld (#E86C+7+#50-#8000),hl
pop hl
ld (#F06C+7+#50-#8000),hl
pop hl
					out (c),a
ld (#F86C+7+#50-#8000),hl
pop hl
ld (#C0BC+7+#50-#8000),hl
pop hl
ld (#C8BC+7+#50-#8000),hl
pop hl
ld (#D0BC+7+#50-#8000),hl
pop hl
ld (#D8BC+7+#50-#8000),hl
pop hl
ld (#E0BC+7+#50-#8000),hl
pop hl
ld (#E8BC+7+#50-#8000),hl
					out (c),e
pop hl
ld (#F0BC+7+#50-#8000),hl
pop hl
ld (#F8BC+7+#50-#8000),hl
pop hl
ld (#C10C+7+#50-#8000),hl
pop hl
ld (#C90C+7+#50-#8000),hl
pop hl
ld (#D10C+7+#50-#8000),hl
pop hl
ld (#D90C+7+#50-#8000),hl
pop hl
ld (#E10C+7+#50-#8000),hl
pop hl
ld (#E90C+7+#50-#8000),hl
pop hl
ld (#F10C+7+#50-#8000),hl
pop hl
ld (#F90C+7+#50-#8000),hl
pop hl
ld (#C15C+7+#50-#8000),hl
pop hl
ld (#C95C+7+#50-#8000),hl
pop hl
ld (#D15C+7+#50-#8000),hl
pop hl
ld (#D95C+7+#50-#8000),hl
pop hl
ld (#E15C+7+#50-#8000),hl
pop hl
ld (#E95C+7+#50-#8000),hl
pop hl
ld (#F15C+7+#50-#8000),hl
pop hl
ld (#F95C+7+#50-#8000),hl
pop hl
ld (#C1AC+7+#50-#8000),hl
pop hl
ld (#C9AC+7+#50-#8000),hl
pop hl
ld (#D1AC+7+#50-#8000),hl
pop hl
ld (#D9AC+7+#50-#8000),hl
pop hl
ld (#E1AC+7+#50-#8000),hl
pop hl
ld (#E9AC+7+#50-#8000),hl
pop hl
ld (#F1AC+7+#50-#8000),hl
pop hl
ld (#F9AC+7+#50-#8000),hl
pop hl
ld (#C1FC+7+#50-#8000),hl
pop hl
ld (#C9FC+7+#50-#8000),hl
pop hl
ld (#D1FC+7+#50-#8000),hl
pop hl
ld (#D9FC+7+#50-#8000),hl
pop hl
ld (#E1FC+7+#50-#8000),hl
pop hl
ld (#E9FC+7+#50-#8000),hl
pop hl
ld (#F1FC+7+#50-#8000),hl
pop hl
ld (#F9FC+7+#50-#8000),hl
pop hl
ld (#C24C+7+#50-#8000),hl
pop hl
ld (#CA4C+7+#50-#8000),hl
pop hl
ld (#D24C+7+#50-#8000),hl
pop hl
ld (#DA4C+7+#50-#8000),hl
pop hl
ld (#E24C+7+#50-#8000),hl
pop hl
ld (#EA4C+7+#50-#8000),hl
pop hl
ld (#F24C+7+#50-#8000),hl
				out (c),a

col16 
ld sp,spr16
pop hl
ld (#C01E+7+#50-#8000),hl
pop hl
ld (#C81E+7+#50-#8000),hl
pop hl
ld (#D01E+7+#50-#8000),hl
pop hl
ld (#D81E+7+#50-#8000),hl
pop hl
ld (#E01E+7+#50-#8000),hl
					out (c),e
pop hl
ld (#E81E+7+#50-#8000),hl
pop hl
ld (#F01E+7+#50-#8000),hl
pop hl
ld (#F81E+7+#50-#8000),hl
pop hl
ld (#C06E+7+#50-#8000),hl
pop hl
ld (#C86E+7+#50-#8000),hl
pop hl
ld (#D06E+7+#50-#8000),hl
pop hl
ld (#D86E+7+#50-#8000),hl
pop hl
ld (#E06E+7+#50-#8000),hl
pop hl
ld (#E86E+7+#50-#8000),hl
pop hl
ld (#F06E+7+#50-#8000),hl
pop hl
ld (#F86E+7+#50-#8000),hl
pop hl
ld (#C0BE+7+#50-#8000),hl
pop hl
ld (#C8BE+7+#50-#8000),hl
pop hl
ld (#D0BE+7+#50-#8000),hl
pop hl
ld (#D8BE+7+#50-#8000),hl
pop hl
ld (#E0BE+7+#50-#8000),hl
pop hl
ld (#E8BE+7+#50-#8000),hl
pop hl
ld (#F0BE+7+#50-#8000),hl
pop hl
ld (#F8BE+7+#50-#8000),hl
pop hl
ld (#C10E+7+#50-#8000),hl
pop hl
ld (#C90E+7+#50-#8000),hl
pop hl
ld (#D10E+7+#50-#8000),hl
pop hl
ld (#D90E+7+#50-#8000),hl
pop hl
ld (#E10E+7+#50-#8000),hl
pop hl
ld (#E90E+7+#50-#8000),hl
pop hl
ld (#F10E+7+#50-#8000),hl
pop hl
ld (#F90E+7+#50-#8000),hl
pop hl
ld (#C15E+7+#50-#8000),hl
pop hl
ld (#C95E+7+#50-#8000),hl
pop hl
ld (#D15E+7+#50-#8000),hl
pop hl
ld (#D95E+7+#50-#8000),hl
pop hl
ld (#E15E+7+#50-#8000),hl
pop hl
ld (#E95E+7+#50-#8000),hl
pop hl
ld (#F15E+7+#50-#8000),hl
pop hl
ld (#F95E+7+#50-#8000),hl
pop hl
ld (#C1AE+7+#50-#8000),hl
pop hl
ld (#C9AE+7+#50-#8000),hl
pop hl
ld (#D1AE+7+#50-#8000),hl
pop hl
ld (#D9AE+7+#50-#8000),hl
pop hl
ld (#E1AE+7+#50-#8000),hl
pop hl
ld (#E9AE+7+#50-#8000),hl
pop hl
ld (#F1AE+7+#50-#8000),hl
					out (c),a
pop hl
ld (#F9AE+7+#50-#8000),hl
pop hl
ld (#C1FE+7+#50-#8000),hl
pop hl
ld (#C9FE+7+#50-#8000),hl
pop hl
ld (#D1FE+7+#50-#8000),hl
pop hl
ld (#D9FE+7+#50-#8000),hl
pop hl
ld (#E1FE+7+#50-#8000),hl
pop hl
					out (c),e
ld (#E9FE+7+#50-#8000),hl
pop hl
ld (#F1FE+7+#50-#8000),hl
pop hl
ld (#F9FE+7+#50-#8000),hl
pop hl
ld (#C24E+7+#50-#8000),hl
pop hl
ld (#CA4E+7+#50-#8000),hl
pop hl
ld (#D24E+7+#50-#8000),hl
pop hl
ld (#DA4E+7+#50-#8000),hl
pop hl
ld (#E24E+7+#50-#8000),hl
pop hl
ld (#EA4E+7+#50-#8000),hl
pop hl
ld (#F24E+7+#50-#8000),hl


col17 
ld sp,spr17
pop hl
ld (#C020+7+#50-#8000),hl
pop hl
ld (#C820+7+#50-#8000),hl
pop hl
ld (#D020+7+#50-#8000),hl
pop hl
ld (#D820+7+#50-#8000),hl
pop hl
ld (#E020+7+#50-#8000),hl
pop hl
ld (#E820+7+#50-#8000),hl
pop hl
ld (#F020+7+#50-#8000),hl
pop hl
ld (#F820+7+#50-#8000),hl
pop hl
ld (#C070+7+#50-#8000),hl
pop hl
ld (#C870+7+#50-#8000),hl
pop hl
ld (#D070+7+#50-#8000),hl
pop hl
ld (#D870+7+#50-#8000),hl
pop hl
ld (#E070+7+#50-#8000),hl
pop hl
ld (#E870+7+#50-#8000),hl
pop hl
ld (#F070+7+#50-#8000),hl
pop hl
ld (#F870+7+#50-#8000),hl
pop hl
ld (#C0C0+7+#50-#8000),hl
pop hl
ld (#C8C0+7+#50-#8000),hl
pop hl
ld (#D0C0+7+#50-#8000),hl
pop hl
ld (#D8C0+7+#50-#8000),hl
pop hl
ld (#E0C0+7+#50-#8000),hl
pop hl
ld (#E8C0+7+#50-#8000),hl
pop hl
ld (#F0C0+7+#50-#8000),hl
pop hl
ld (#F8C0+7+#50-#8000),hl
pop hl
ld (#C110+7+#50-#8000),hl
pop hl
ld (#C910+7+#50-#8000),hl
pop hl
ld (#D110+7+#50-#8000),hl
pop hl
ld (#D910+7+#50-#8000),hl
pop hl
ld (#E110+7+#50-#8000),hl
pop hl
ld (#E910+7+#50-#8000),hl
pop hl
					out (c),a
ld (#F110+7+#50-#8000),hl
pop hl
ld (#F910+7+#50-#8000),hl
pop hl
ld (#C160+7+#50-#8000),hl
pop hl
ld (#C960+7+#50-#8000),hl
pop hl
ld (#D160+7+#50-#8000),hl
pop hl
ld (#D960+7+#50-#8000),hl
pop hl
ld (#E160+7+#50-#8000),hl
pop hl
					out (c),e
ld (#E960+7+#50-#8000),hl
pop hl
ld (#F160+7+#50-#8000),hl
pop hl
ld (#F960+7+#50-#8000),hl
pop hl
ld (#C1B0+7+#50-#8000),hl
pop hl
ld (#C9B0+7+#50-#8000),hl
pop hl
ld (#D1B0+7+#50-#8000),hl
pop hl
ld (#D9B0+7+#50-#8000),hl
pop hl
ld (#E1B0+7+#50-#8000),hl
pop hl
ld (#E9B0+7+#50-#8000),hl
pop hl
ld (#F1B0+7+#50-#8000),hl
pop hl
ld (#F9B0+7+#50-#8000),hl
pop hl
ld (#C200+7+#50-#8000),hl
pop hl
ld (#CA00+7+#50-#8000),hl
pop hl
ld (#D200+7+#50-#8000),hl
pop hl
ld (#DA00+7+#50-#8000),hl
pop hl
ld (#E200+7+#50-#8000),hl
pop hl
ld (#EA00+7+#50-#8000),hl
pop hl
ld (#F200+7+#50-#8000),hl
pop hl
ld (#FA00+7+#50-#8000),hl
pop hl
ld (#C250+7+#50-#8000),hl
pop hl
ld (#CA50+7+#50-#8000),hl
pop hl
ld (#D250+7+#50-#8000),hl
pop hl
ld (#DA50+7+#50-#8000),hl
pop hl
ld (#E250+7+#50-#8000),hl
pop hl
ld (#EA50+7+#50-#8000),hl
pop hl
ld (#F250+7+#50-#8000),hl


col18 
ld sp,spr18
pop hl
ld (#C022+7+#50-#8000),hl
pop hl
ld (#C822+7+#50-#8000),hl
pop hl
ld (#D022+7+#50-#8000),hl
pop hl
ld (#D822+7+#50-#8000),hl
pop hl
ld (#E022+7+#50-#8000),hl
pop hl
ld (#E822+7+#50-#8000),hl
pop hl
ld (#F022+7+#50-#8000),hl
pop hl
ld (#F822+7+#50-#8000),hl
pop hl
ld (#C072+7+#50-#8000),hl
pop hl
ld (#C872+7+#50-#8000),hl
pop hl
ld (#D072+7+#50-#8000),hl
pop hl
ld (#D872+7+#50-#8000),hl
pop hl
ld (#E072+7+#50-#8000),hl
pop hl
ld (#E872+7+#50-#8000),hl
					out (c),a
pop hl
ld (#F072+7+#50-#8000),hl
pop hl
ld (#F872+7+#50-#8000),hl
pop hl
ld (#C0C2+7+#50-#8000),hl
pop hl
ld (#C8C2+7+#50-#8000),hl
pop hl
ld (#D0C2+7+#50-#8000),hl
pop hl
ld (#D8C2+7+#50-#8000),hl
pop hl
					out (c),e
ld (#E0C2+7+#50-#8000),hl
pop hl
ld (#E8C2+7+#50-#8000),hl
pop hl
ld (#F0C2+7+#50-#8000),hl
pop hl
ld (#F8C2+7+#50-#8000),hl
pop hl
ld (#C112+7+#50-#8000),hl
pop hl
ld (#C912+7+#50-#8000),hl
pop hl
ld (#D112+7+#50-#8000),hl
pop hl
ld (#D912+7+#50-#8000),hl
pop hl
ld (#E112+7+#50-#8000),hl
pop hl
ld (#E912+7+#50-#8000),hl
pop hl
ld (#F112+7+#50-#8000),hl
pop hl
ld (#F912+7+#50-#8000),hl
pop hl
ld (#C162+7+#50-#8000),hl
pop hl
ld (#C962+7+#50-#8000),hl
pop hl
ld (#D162+7+#50-#8000),hl
pop hl
ld (#D962+7+#50-#8000),hl
pop hl
ld (#E162+7+#50-#8000),hl
pop hl
ld (#E962+7+#50-#8000),hl
pop hl
ld (#F162+7+#50-#8000),hl
pop hl
ld (#F962+7+#50-#8000),hl
pop hl
ld (#C1B2+7+#50-#8000),hl
pop hl
ld (#C9B2+7+#50-#8000),hl
pop hl
ld (#D1B2+7+#50-#8000),hl
pop hl
ld (#D9B2+7+#50-#8000),hl
pop hl
ld (#E1B2+7+#50-#8000),hl
pop hl
ld (#E9B2+7+#50-#8000),hl
pop hl
ld (#F1B2+7+#50-#8000),hl
pop hl
ld (#F9B2+7+#50-#8000),hl
pop hl
ld (#C202+7+#50-#8000),hl
pop hl
ld (#CA02+7+#50-#8000),hl
pop hl
ld (#D202+7+#50-#8000),hl
pop hl
ld (#DA02+7+#50-#8000),hl
pop hl
ld (#E202+7+#50-#8000),hl
pop hl
ld (#EA02+7+#50-#8000),hl
pop hl
ld (#F202+7+#50-#8000),hl
pop hl
ld (#FA02+7+#50-#8000),hl
pop hl
ld (#C252+7+#50-#8000),hl
pop hl
ld (#CA52+7+#50-#8000),hl
pop hl
ld (#D252+7+#50-#8000),hl
pop hl
ld (#DA52+7+#50-#8000),hl
pop hl
					out (c),a
ld (#E252+7+#50-#8000),hl
pop hl
ld (#EA52+7+#50-#8000),hl
pop hl
ld (#F252+7+#50-#8000),hl


col19 
ld sp,spr19
pop hl
ld (#C024+7+#50-#8000),hl
pop hl
ld (#C824+7+#50-#8000),hl
pop hl
ld (#D024+7+#50-#8000),hl
pop hl
ld (#D824+7+#50-#8000),hl
pop hl
					out (c),e
ld (#E024+7+#50-#8000),hl
pop hl
ld (#E824+7+#50-#8000),hl
pop hl
ld (#F024+7+#50-#8000),hl
pop hl
ld (#F824+7+#50-#8000),hl
pop hl
ld (#C074+7+#50-#8000),hl
pop hl
ld (#C874+7+#50-#8000),hl
pop hl
ld (#D074+7+#50-#8000),hl
pop hl
ld (#D874+7+#50-#8000),hl
pop hl
ld (#E074+7+#50-#8000),hl
pop hl
ld (#E874+7+#50-#8000),hl
pop hl
ld (#F074+7+#50-#8000),hl
pop hl
ld (#F874+7+#50-#8000),hl
pop hl
ld (#C0C4+7+#50-#8000),hl
pop hl
ld (#C8C4+7+#50-#8000),hl
pop hl

ld (#D0C4+7+#50-#8000),hl
pop hl
ld (#D8C4+7+#50-#8000),hl
pop hl
ld (#E0C4+7+#50-#8000),hl
pop hl
ld (#E8C4+7+#50-#8000),hl
pop hl
ld (#F0C4+7+#50-#8000),hl
pop hl
ld (#F8C4+7+#50-#8000),hl
pop hl
ld (#C114+7+#50-#8000),hl
pop hl
ld (#C914+7+#50-#8000),hl
pop hl
ld (#D114+7+#50-#8000),hl
pop hl
ld (#D914+7+#50-#8000),hl
pop hl
ld (#E114+7+#50-#8000),hl
pop hl
ld (#E914+7+#50-#8000),hl
pop hl
ld (#F114+7+#50-#8000),hl
pop hl
ld (#F914+7+#50-#8000),hl
pop hl
ld (#C164+7+#50-#8000),hl
pop hl
ld (#C964+7+#50-#8000),hl
pop hl
ld (#D164+7+#50-#8000),hl
pop hl
ld (#D964+7+#50-#8000),hl
pop hl
ld (#E164+7+#50-#8000),hl
pop hl
ld (#E964+7+#50-#8000),hl
pop hl
ld (#F164+7+#50-#8000),hl
pop hl
ld (#F964+7+#50-#8000),hl
pop hl
ld (#C1B4+7+#50-#8000),hl
pop hl
ld (#C9B4+7+#50-#8000),hl
pop hl
ld (#D1B4+7+#50-#8000),hl
pop hl
ld (#D9B4+7+#50-#8000),hl
pop hl
ld (#E1B4+7+#50-#8000),hl
pop hl
ld (#E9B4+7+#50-#8000),hl
pop hl
ld (#F1B4+7+#50-#8000),hl
pop hl
ld (#F9B4+7+#50-#8000),hl
pop hl
ld (#C204+7+#50-#8000),hl
pop hl
ld (#CA04+7+#50-#8000),hl
pop hl
ld (#D204+7+#50-#8000),hl
pop hl
ld (#DA04+7+#50-#8000),hl
pop hl
ld (#E204+7+#50-#8000),hl
pop hl
ld (#EA04+7+#50-#8000),hl
pop hl
ld (#F204+7+#50-#8000),hl
pop hl
ld (#FA04+7+#50-#8000),hl
pop hl
ld (#C254+7+#50-#8000),hl
pop hl
ld (#CA54+7+#50-#8000),hl
pop hl
ld (#D254+7+#50-#8000),hl
pop hl
ld (#DA54+7+#50-#8000),hl
pop hl
ld (#E254+7+#50-#8000),hl
pop hl
ld (#EA54+7+#50-#8000),hl
pop hl
ld (#F254+7+#50-#8000),hl



col20 
ld sp,spr20
pop hl
ld (#C026+7+#50-#8000),hl
pop hl
ld (#C826+7+#50-#8000),hl
pop hl
ld (#D026+7+#50-#8000),hl
pop hl
ld (#D826+7+#50-#8000),hl
pop hl
ld (#E026+7+#50-#8000),hl
pop hl
ld (#E826+7+#50-#8000),hl
pop hl
ld (#F026+7+#50-#8000),hl
pop hl
ld (#F826+7+#50-#8000),hl
pop hl
ld (#C076+7+#50-#8000),hl
pop hl
ld (#C876+7+#50-#8000),hl
pop hl
ld (#D076+7+#50-#8000),hl
pop hl
ld (#D876+7+#50-#8000),hl
pop hl
ld (#E076+7+#50-#8000),hl
pop hl
ld (#E876+7+#50-#8000),hl
pop hl
ld (#F076+7+#50-#8000),hl
pop hl
ld (#F876+7+#50-#8000),hl
pop hl
ld (#C0C6+7+#50-#8000),hl
pop hl
ld (#C8C6+7+#50-#8000),hl
pop hl
ld (#D0C6+7+#50-#8000),hl
pop hl
ld (#D8C6+7+#50-#8000),hl
pop hl
ld (#E0C6+7+#50-#8000),hl
pop hl
ld (#E8C6+7+#50-#8000),hl
pop hl
ld (#F0C6+7+#50-#8000),hl
pop hl
ld (#F8C6+7+#50-#8000),hl
pop hl
ld (#C116+7+#50-#8000),hl
pop hl
ld (#C916+7+#50-#8000),hl
pop hl
ld (#D116+7+#50-#8000),hl
pop hl
ld (#D916+7+#50-#8000),hl
pop hl
ld (#E116+7+#50-#8000),hl
pop hl
ld (#E916+7+#50-#8000),hl
pop hl
ld (#F116+7+#50-#8000),hl
pop hl
ld (#F916+7+#50-#8000),hl
pop hl
ld (#C166+7+#50-#8000),hl
pop hl
ld (#C966+7+#50-#8000),hl
pop hl
ld (#D166+7+#50-#8000),hl
pop hl
ld (#D966+7+#50-#8000),hl
pop hl
ld (#E166+7+#50-#8000),hl
pop hl
ld (#E966+7+#50-#8000),hl
pop hl
ld (#F166+7+#50-#8000),hl
pop hl
ld (#F966+7+#50-#8000),hl
pop hl
ld (#C1B6+7+#50-#8000),hl
pop hl
ld (#C9B6+7+#50-#8000),hl
pop hl
ld (#D1B6+7+#50-#8000),hl
pop hl
ld (#D9B6+7+#50-#8000),hl
pop hl
ld (#E1B6+7+#50-#8000),hl
pop hl
ld (#E9B6+7+#50-#8000),hl
pop hl
ld (#F1B6+7+#50-#8000),hl
pop hl
ld (#F9B6+7+#50-#8000),hl
pop hl
ld (#C206+7+#50-#8000),hl
pop hl
ld (#CA06+7+#50-#8000),hl
pop hl
ld (#D206+7+#50-#8000),hl
pop hl
ld (#DA06+7+#50-#8000),hl
pop hl
ld (#E206+7+#50-#8000),hl
pop hl
ld (#EA06+7+#50-#8000),hl
pop hl
ld (#F206+7+#50-#8000),hl
pop hl
ld (#FA06+7+#50-#8000),hl
pop hl
ld (#C256+7+#50-#8000),hl
pop hl
ld (#CA56+7+#50-#8000),hl
pop hl
ld (#D256+7+#50-#8000),hl
pop hl
ld (#DA56+7+#50-#8000),hl
pop hl
ld (#E256+7+#50-#8000),hl
pop hl
ld (#EA56+7+#50-#8000),hl
pop hl
ld (#F256+7+#50-#8000),hl


col21 
ld sp,spr21
pop hl
ld (#C028+7+#50-#8000),hl
pop hl
ld (#C828+7+#50-#8000),hl
pop hl
ld (#D028+7+#50-#8000),hl
pop hl
ld (#D828+7+#50-#8000),hl
pop hl
ld (#E028+7+#50-#8000),hl
pop hl
ld (#E828+7+#50-#8000),hl
pop hl
ld (#F028+7+#50-#8000),hl
pop hl
ld (#F828+7+#50-#8000),hl
pop hl
ld (#C078+7+#50-#8000),hl
pop hl
ld (#C878+7+#50-#8000),hl
pop hl
ld (#D078+7+#50-#8000),hl
pop hl
ld (#D878+7+#50-#8000),hl
pop hl
ld (#E078+7+#50-#8000),hl
pop hl
ld (#E878+7+#50-#8000),hl
pop hl
ld (#F078+7+#50-#8000),hl
pop hl
ld (#F878+7+#50-#8000),hl
pop hl
ld (#C0C8+7+#50-#8000),hl
pop hl
ld (#C8C8+7+#50-#8000),hl
pop hl
ld (#D0C8+7+#50-#8000),hl
pop hl
ld (#D8C8+7+#50-#8000),hl
pop hl
ld (#E0C8+7+#50-#8000),hl
pop hl
ld (#E8C8+7+#50-#8000),hl
pop hl
ld (#F0C8+7+#50-#8000),hl
pop hl
ld (#F8C8+7+#50-#8000),hl
pop hl
ld (#C118+7+#50-#8000),hl
pop hl
ld (#C918+7+#50-#8000),hl
pop hl
ld (#D118+7+#50-#8000),hl
pop hl
ld (#D918+7+#50-#8000),hl
pop hl
ld (#E118+7+#50-#8000),hl
pop hl
ld (#E918+7+#50-#8000),hl
pop hl
ld (#F118+7+#50-#8000),hl
pop hl
ld (#F918+7+#50-#8000),hl
pop hl
ld (#C168+7+#50-#8000),hl
pop hl
ld (#C968+7+#50-#8000),hl
pop hl
ld (#D168+7+#50-#8000),hl
pop hl
ld (#D968+7+#50-#8000),hl
pop hl
ld (#E168+7+#50-#8000),hl
pop hl
ld (#E968+7+#50-#8000),hl
pop hl
ld (#F168+7+#50-#8000),hl
pop hl
ld (#F968+7+#50-#8000),hl
pop hl
ld (#C1B8+7+#50-#8000),hl
pop hl
ld (#C9B8+7+#50-#8000),hl
pop hl
ld (#D1B8+7+#50-#8000),hl
pop hl
ld (#D9B8+7+#50-#8000),hl
pop hl
ld (#E1B8+7+#50-#8000),hl
pop hl
ld (#E9B8+7+#50-#8000),hl
pop hl
ld (#F1B8+7+#50-#8000),hl
pop hl
ld (#F9B8+7+#50-#8000),hl
pop hl
ld (#C208+7+#50-#8000),hl
pop hl
ld (#CA08+7+#50-#8000),hl
pop hl
ld (#D208+7+#50-#8000),hl
pop hl
ld (#DA08+7+#50-#8000),hl
pop hl
ld (#E208+7+#50-#8000),hl
pop hl
ld (#EA08+7+#50-#8000),hl
pop hl
ld (#F208+7+#50-#8000),hl
pop hl
ld (#FA08+7+#50-#8000),hl
pop hl
ld (#C258+7+#50-#8000),hl
pop hl
ld (#CA58+7+#50-#8000),hl
pop hl
ld (#D258+7+#50-#8000),hl
pop hl
ld (#DA58+7+#50-#8000),hl
pop hl
ld (#E258+7+#50-#8000),hl
pop hl
ld (#EA58+7+#50-#8000),hl
pop hl
ld (#F258+7+#50-#8000),hl


col22 
ld sp,spr22
pop hl
ld (#C02A+7+#50-#8000),hl
pop hl
ld (#C82A+7+#50-#8000),hl
pop hl
ld (#D02A+7+#50-#8000),hl
pop hl
ld (#D82A+7+#50-#8000),hl
pop hl
ld (#E02A+7+#50-#8000),hl
pop hl
ld (#E82A+7+#50-#8000),hl
pop hl
ld (#F02A+7+#50-#8000),hl
pop hl
ld (#F82A+7+#50-#8000),hl
pop hl
ld (#C07A+7+#50-#8000),hl
pop hl
ld (#C87A+7+#50-#8000),hl
pop hl
ld (#D07A+7+#50-#8000),hl
pop hl
ld (#D87A+7+#50-#8000),hl
pop hl
ld (#E07A+7+#50-#8000),hl
pop hl
ld (#E87A+7+#50-#8000),hl
pop hl
ld (#F07A+7+#50-#8000),hl
pop hl
ld (#F87A+7+#50-#8000),hl
pop hl
ld (#C0CA+7+#50-#8000),hl
pop hl
ld (#C8CA+7+#50-#8000),hl
pop hl
ld (#D0CA+7+#50-#8000),hl
pop hl
ld (#D8CA+7+#50-#8000),hl
pop hl
ld (#E0CA+7+#50-#8000),hl
pop hl
ld (#E8CA+7+#50-#8000),hl
pop hl
ld (#F0CA+7+#50-#8000),hl
pop hl
ld (#F8CA+7+#50-#8000),hl
pop hl
ld (#C11A+7+#50-#8000),hl
pop hl
ld (#C91A+7+#50-#8000),hl
pop hl
ld (#D11A+7+#50-#8000),hl
pop hl
ld (#D91A+7+#50-#8000),hl
pop hl
ld (#E11A+7+#50-#8000),hl
pop hl
ld (#E91A+7+#50-#8000),hl
pop hl
ld (#F11A+7+#50-#8000),hl
pop hl
ld (#F91A+7+#50-#8000),hl
pop hl
ld (#C16A+7+#50-#8000),hl
pop hl
ld (#C96A+7+#50-#8000),hl
pop hl
ld (#D16A+7+#50-#8000),hl
pop hl
ld (#D96A+7+#50-#8000),hl
pop hl
ld (#E16A+7+#50-#8000),hl
pop hl
ld (#E96A+7+#50-#8000),hl
pop hl
ld (#F16A+7+#50-#8000),hl
pop hl
ld (#F96A+7+#50-#8000),hl
pop hl
ld (#C1BA+7+#50-#8000),hl
pop hl
ld (#C9BA+7+#50-#8000),hl
pop hl
ld (#D1BA+7+#50-#8000),hl
pop hl
ld (#D9BA+7+#50-#8000),hl
pop hl
ld (#E1BA+7+#50-#8000),hl
pop hl
ld (#E9BA+7+#50-#8000),hl
pop hl
ld (#F1BA+7+#50-#8000),hl
pop hl
ld (#F9BA+7+#50-#8000),hl
pop hl
ld (#C20A+7+#50-#8000),hl
pop hl
ld (#CA0A+7+#50-#8000),hl
pop hl
ld (#D20A+7+#50-#8000),hl
pop hl
ld (#DA0A+7+#50-#8000),hl
pop hl
ld (#E20A+7+#50-#8000),hl
pop hl
ld (#EA0A+7+#50-#8000),hl
pop hl
ld (#F20A+7+#50-#8000),hl
pop hl
ld (#FA0A+7+#50-#8000),hl
pop hl
ld (#C25A+7+#50-#8000),hl
pop hl
ld (#CA5A+7+#50-#8000),hl
pop hl
ld (#D25A+7+#50-#8000),hl
pop hl
ld (#DA5A+7+#50-#8000),hl
pop hl
ld (#E25A+7+#50-#8000),hl
pop hl
ld (#EA5A+7+#50-#8000),hl
pop hl
ld (#F25A+7+#50-#8000),hl

col23 
ld sp,spr23
pop hl
ld (#C02C+7+#50-#8000),hl
pop hl
ld (#C82C+7+#50-#8000),hl
pop hl
ld (#D02C+7+#50-#8000),hl
pop hl
ld (#D82C+7+#50-#8000),hl
pop hl
ld (#E02C+7+#50-#8000),hl
pop hl
ld (#E82C+7+#50-#8000),hl
pop hl
ld (#F02C+7+#50-#8000),hl
pop hl
ld (#F82C+7+#50-#8000),hl
pop hl
ld (#C07C+7+#50-#8000),hl
pop hl
ld (#C87C+7+#50-#8000),hl
pop hl
ld (#D07C+7+#50-#8000),hl
pop hl
ld (#D87C+7+#50-#8000),hl
pop hl
ld (#E07C+7+#50-#8000),hl
pop hl
ld (#E87C+7+#50-#8000),hl
pop hl
ld (#F07C+7+#50-#8000),hl
pop hl
ld (#F87C+7+#50-#8000),hl
pop hl
ld (#C0CC+7+#50-#8000),hl
pop hl
ld (#C8CC+7+#50-#8000),hl
pop hl
ld (#D0CC+7+#50-#8000),hl
pop hl
ld (#D8CC+7+#50-#8000),hl
pop hl
ld (#E0CC+7+#50-#8000),hl
pop hl
ld (#E8CC+7+#50-#8000),hl
pop hl
ld (#F0CC+7+#50-#8000),hl
pop hl
ld (#F8CC+7+#50-#8000),hl
pop hl
ld (#C11C+7+#50-#8000),hl
pop hl
ld (#C91C+7+#50-#8000),hl
pop hl
ld (#D11C+7+#50-#8000),hl
pop hl
ld (#D91C+7+#50-#8000),hl
pop hl
ld (#E11C+7+#50-#8000),hl
pop hl
ld (#E91C+7+#50-#8000),hl
pop hl
ld (#F11C+7+#50-#8000),hl
pop hl
ld (#F91C+7+#50-#8000),hl
pop hl
ld (#C16C+7+#50-#8000),hl
pop hl
ld (#C96C+7+#50-#8000),hl
pop hl
ld (#D16C+7+#50-#8000),hl
pop hl
ld (#D96C+7+#50-#8000),hl
pop hl
ld (#E16C+7+#50-#8000),hl
pop hl
ld (#E96C+7+#50-#8000),hl
pop hl
ld (#F16C+7+#50-#8000),hl
pop hl
ld (#F96C+7+#50-#8000),hl
pop hl
ld (#C1BC+7+#50-#8000),hl
pop hl
ld (#C9BC+7+#50-#8000),hl
pop hl
ld (#D1BC+7+#50-#8000),hl
pop hl
ld (#D9BC+7+#50-#8000),hl
pop hl
ld (#E1BC+7+#50-#8000),hl
pop hl
ld (#E9BC+7+#50-#8000),hl
pop hl
ld (#F1BC+7+#50-#8000),hl
pop hl
ld (#F9BC+7+#50-#8000),hl
pop hl
ld (#C20C+7+#50-#8000),hl
pop hl
ld (#CA0C+7+#50-#8000),hl
pop hl
ld (#D20C+7+#50-#8000),hl
pop hl
ld (#DA0C+7+#50-#8000),hl
pop hl
ld (#E20C+7+#50-#8000),hl
pop hl
ld (#EA0C+7+#50-#8000),hl
pop hl
ld (#F20C+7+#50-#8000),hl
pop hl
ld (#FA0C+7+#50-#8000),hl
pop hl
ld (#C25C+7+#50-#8000),hl
pop hl
ld (#CA5C+7+#50-#8000),hl
pop hl
ld (#D25C+7+#50-#8000),hl
pop hl
ld (#DA5C+7+#50-#8000),hl
pop hl
ld (#E25C+7+#50-#8000),hl
pop hl
ld (#EA5C+7+#50-#8000),hl
pop hl
ld (#F25C+7+#50-#8000),hl


col24 
ld sp,spr24
pop hl
ld (#C02E+7+#50-#8000),hl
pop hl
ld (#C82E+7+#50-#8000),hl
pop hl
ld (#D02E+7+#50-#8000),hl
pop hl
ld (#D82E+7+#50-#8000),hl
pop hl
ld (#E02E+7+#50-#8000),hl
pop hl
ld (#E82E+7+#50-#8000),hl
pop hl
ld (#F02E+7+#50-#8000),hl
pop hl
ld (#F82E+7+#50-#8000),hl
pop hl
ld (#C07E+7+#50-#8000),hl
pop hl
ld (#C87E+7+#50-#8000),hl
pop hl
ld (#D07E+7+#50-#8000),hl
pop hl
ld (#D87E+7+#50-#8000),hl
pop hl
ld (#E07E+7+#50-#8000),hl
pop hl
ld (#E87E+7+#50-#8000),hl
pop hl
ld (#F07E+7+#50-#8000),hl
pop hl
ld (#F87E+7+#50-#8000),hl
pop hl
ld (#C0CE+7+#50-#8000),hl
pop hl
ld (#C8CE+7+#50-#8000),hl
pop hl
ld (#D0CE+7+#50-#8000),hl
pop hl
ld (#D8CE+7+#50-#8000),hl
pop hl
ld (#E0CE+7+#50-#8000),hl
pop hl
ld (#E8CE+7+#50-#8000),hl
pop hl
ld (#F0CE+7+#50-#8000),hl
pop hl
ld (#F8CE+7+#50-#8000),hl
pop hl
ld (#C11E+7+#50-#8000),hl
pop hl
ld (#C91E+7+#50-#8000),hl
pop hl
ld (#D11E+7+#50-#8000),hl
pop hl
ld (#D91E+7+#50-#8000),hl
pop hl
ld (#E11E+7+#50-#8000),hl
pop hl
ld (#E91E+7+#50-#8000),hl
pop hl
ld (#F11E+7+#50-#8000),hl
pop hl
ld (#F91E+7+#50-#8000),hl
pop hl
ld (#C16E+7+#50-#8000),hl
pop hl
ld (#C96E+7+#50-#8000),hl
pop hl
ld (#D16E+7+#50-#8000),hl
pop hl
ld (#D96E+7+#50-#8000),hl
pop hl
ld (#E16E+7+#50-#8000),hl
pop hl
ld (#E96E+7+#50-#8000),hl
pop hl
ld (#F16E+7+#50-#8000),hl
pop hl
ld (#F96E+7+#50-#8000),hl
pop hl
ld (#C1BE+7+#50-#8000),hl
pop hl
ld (#C9BE+7+#50-#8000),hl
pop hl
ld (#D1BE+7+#50-#8000),hl
pop hl
ld (#D9BE+7+#50-#8000),hl
pop hl
ld (#E1BE+7+#50-#8000),hl
pop hl
ld (#E9BE+7+#50-#8000),hl
pop hl
ld (#F1BE+7+#50-#8000),hl
pop hl
ld (#F9BE+7+#50-#8000),hl
pop hl
ld (#C20E+7+#50-#8000),hl
pop hl
ld (#CA0E+7+#50-#8000),hl
pop hl
ld (#D20E+7+#50-#8000),hl
pop hl
ld (#DA0E+7+#50-#8000),hl
pop hl
ld (#E20E+7+#50-#8000),hl
pop hl
ld (#EA0E+7+#50-#8000),hl
pop hl
ld (#F20E+7+#50-#8000),hl
pop hl
ld (#FA0E+7+#50-#8000),hl
pop hl
ld (#C25E+7+#50-#8000),hl
pop hl
ld (#CA5E+7+#50-#8000),hl
pop hl
ld (#D25E+7+#50-#8000),hl
pop hl
ld (#DA5E+7+#50-#8000),hl
pop hl
ld (#E25E+7+#50-#8000),hl
pop hl
ld (#EA5E+7+#50-#8000),hl
pop hl
ld (#F25E+7+#50-#8000),hl



col25 
ld sp,spr25
pop hl
ld (#C030+7+#50-#8000),hl
pop hl
ld (#C830+7+#50-#8000),hl
pop hl
ld (#D030+7+#50-#8000),hl
pop hl
ld (#D830+7+#50-#8000),hl
pop hl
ld (#E030+7+#50-#8000),hl
pop hl
ld (#E830+7+#50-#8000),hl
pop hl
ld (#F030+7+#50-#8000),hl
pop hl
ld (#F830+7+#50-#8000),hl
pop hl
ld (#C080+7+#50-#8000),hl
pop hl
ld (#C880+7+#50-#8000),hl
pop hl
ld (#D080+7+#50-#8000),hl
pop hl
ld (#D880+7+#50-#8000),hl
pop hl
ld (#E080+7+#50-#8000),hl
pop hl
ld (#E880+7+#50-#8000),hl
pop hl
ld (#F080+7+#50-#8000),hl
pop hl
ld (#F880+7+#50-#8000),hl
pop hl
ld (#C0D0+7+#50-#8000),hl
pop hl
ld (#C8D0+7+#50-#8000),hl
pop hl
ld (#D0D0+7+#50-#8000),hl
pop hl
ld (#D8D0+7+#50-#8000),hl
pop hl
ld (#E0D0+7+#50-#8000),hl
pop hl
ld (#E8D0+7+#50-#8000),hl
pop hl
ld (#F0D0+7+#50-#8000),hl
pop hl
ld (#F8D0+7+#50-#8000),hl
pop hl
ld (#C120+7+#50-#8000),hl
pop hl
ld (#C920+7+#50-#8000),hl
pop hl
ld (#D120+7+#50-#8000),hl
pop hl
ld (#D920+7+#50-#8000),hl
pop hl
ld (#E120+7+#50-#8000),hl
pop hl
ld (#E920+7+#50-#8000),hl
pop hl
ld (#F120+7+#50-#8000),hl
pop hl
ld (#F920+7+#50-#8000),hl
pop hl
ld (#C170+7+#50-#8000),hl
pop hl
ld (#C970+7+#50-#8000),hl
pop hl
ld (#D170+7+#50-#8000),hl
pop hl
ld (#D970+7+#50-#8000),hl
pop hl
ld (#E170+7+#50-#8000),hl
pop hl
ld (#E970+7+#50-#8000),hl
pop hl
ld (#F170+7+#50-#8000),hl
pop hl
ld (#F970+7+#50-#8000),hl
pop hl
ld (#C1C0+7+#50-#8000),hl
pop hl
ld (#C9C0+7+#50-#8000),hl
pop hl
ld (#D1C0+7+#50-#8000),hl
pop hl
ld (#D9C0+7+#50-#8000),hl
pop hl
ld (#E1C0+7+#50-#8000),hl
pop hl
ld (#E9C0+7+#50-#8000),hl
pop hl
ld (#F1C0+7+#50-#8000),hl
pop hl
ld (#F9C0+7+#50-#8000),hl
pop hl
ld (#C210+7+#50-#8000),hl
pop hl
ld (#CA10+7+#50-#8000),hl
pop hl
ld (#D210+7+#50-#8000),hl
pop hl
ld (#DA10+7+#50-#8000),hl
pop hl
ld (#E210+7+#50-#8000),hl
pop hl
ld (#EA10+7+#50-#8000),hl
pop hl
ld (#F210+7+#50-#8000),hl
pop hl
ld (#FA10+7+#50-#8000),hl
pop hl
ld (#C260+7+#50-#8000),hl
pop hl
ld (#CA60+7+#50-#8000),hl
pop hl
ld (#D260+7+#50-#8000),hl
pop hl
ld (#DA60+7+#50-#8000),hl
pop hl
ld (#E260+7+#50-#8000),hl
pop hl
ld (#EA60+7+#50-#8000),hl
pop hl
ld (#F260+7+#50-#8000),hl


col26 
ld sp,spr26
pop hl
ld (#C032+7+#50-#8000),hl
pop hl
ld (#C832+7+#50-#8000),hl
pop hl
ld (#D032+7+#50-#8000),hl
pop hl
ld (#D832+7+#50-#8000),hl
pop hl
ld (#E032+7+#50-#8000),hl
pop hl
ld (#E832+7+#50-#8000),hl
pop hl
ld (#F032+7+#50-#8000),hl
pop hl
ld (#F832+7+#50-#8000),hl
pop hl
ld (#C082+7+#50-#8000),hl
pop hl
ld (#C882+7+#50-#8000),hl
pop hl
ld (#D082+7+#50-#8000),hl
pop hl
ld (#D882+7+#50-#8000),hl
pop hl
ld (#E082+7+#50-#8000),hl
pop hl
ld (#E882+7+#50-#8000),hl
pop hl
ld (#F082+7+#50-#8000),hl
pop hl
ld (#F882+7+#50-#8000),hl
pop hl
ld (#C0D2+7+#50-#8000),hl
pop hl
ld (#C8D2+7+#50-#8000),hl
pop hl
ld (#D0D2+7+#50-#8000),hl
pop hl
ld (#D8D2+7+#50-#8000),hl
pop hl
ld (#E0D2+7+#50-#8000),hl
pop hl
ld (#E8D2+7+#50-#8000),hl
pop hl
ld (#F0D2+7+#50-#8000),hl
pop hl
ld (#F8D2+7+#50-#8000),hl
pop hl
ld (#C122+7+#50-#8000),hl
pop hl
ld (#C922+7+#50-#8000),hl
pop hl
ld (#D122+7+#50-#8000),hl
pop hl
ld (#D922+7+#50-#8000),hl
pop hl
ld (#E122+7+#50-#8000),hl
pop hl
ld (#E922+7+#50-#8000),hl
pop hl
ld (#F122+7+#50-#8000),hl
pop hl
ld (#F922+7+#50-#8000),hl
pop hl
ld (#C172+7+#50-#8000),hl
pop hl
ld (#C972+7+#50-#8000),hl
pop hl
ld (#D172+7+#50-#8000),hl
pop hl
ld (#D972+7+#50-#8000),hl
pop hl
ld (#E172+7+#50-#8000),hl
pop hl
ld (#E972+7+#50-#8000),hl
pop hl
ld (#F172+7+#50-#8000),hl
pop hl
ld (#F972+7+#50-#8000),hl
pop hl
ld (#C1C2+7+#50-#8000),hl
pop hl
ld (#C9C2+7+#50-#8000),hl
pop hl
ld (#D1C2+7+#50-#8000),hl
pop hl
ld (#D9C2+7+#50-#8000),hl
pop hl
ld (#E1C2+7+#50-#8000),hl
pop hl
ld (#E9C2+7+#50-#8000),hl
pop hl
ld (#F1C2+7+#50-#8000),hl
pop hl
ld (#F9C2+7+#50-#8000),hl
pop hl
ld (#C212+7+#50-#8000),hl
pop hl
ld (#CA12+7+#50-#8000),hl
pop hl
ld (#D212+7+#50-#8000),hl
pop hl
ld (#DA12+7+#50-#8000),hl
pop hl
ld (#E212+7+#50-#8000),hl
pop hl
ld (#EA12+7+#50-#8000),hl
pop hl
ld (#F212+7+#50-#8000),hl
pop hl
ld (#FA12+7+#50-#8000),hl
pop hl
ld (#C262+7+#50-#8000),hl
pop hl
ld (#CA62+7+#50-#8000),hl
pop hl
ld (#D262+7+#50-#8000),hl
pop hl
ld (#DA62+7+#50-#8000),hl
pop hl
ld (#E262+7+#50-#8000),hl
pop hl
ld (#EA62+7+#50-#8000),hl
pop hl
ld (#F262+7+#50-#8000),hl


col27 
ld sp,spr27
pop hl
ld (#C034+7+#50-#8000),hl
pop hl
ld (#C834+7+#50-#8000),hl
pop hl
ld (#D034+7+#50-#8000),hl
pop hl
ld (#D834+7+#50-#8000),hl
pop hl
ld (#E034+7+#50-#8000),hl
pop hl
ld (#E834+7+#50-#8000),hl
pop hl
ld (#F034+7+#50-#8000),hl
pop hl
ld (#F834+7+#50-#8000),hl
pop hl
ld (#C084+7+#50-#8000),hl
pop hl
ld (#C884+7+#50-#8000),hl
pop hl
ld (#D084+7+#50-#8000),hl
pop hl
ld (#D884+7+#50-#8000),hl
pop hl
ld (#E084+7+#50-#8000),hl
pop hl
ld (#E884+7+#50-#8000),hl
pop hl
ld (#F084+7+#50-#8000),hl
pop hl
ld (#F884+7+#50-#8000),hl
pop hl
ld (#C0D4+7+#50-#8000),hl
pop hl
ld (#C8D4+7+#50-#8000),hl
pop hl
ld (#D0D4+7+#50-#8000),hl
pop hl
ld (#D8D4+7+#50-#8000),hl
pop hl
ld (#E0D4+7+#50-#8000),hl
pop hl
ld (#E8D4+7+#50-#8000),hl
pop hl
ld (#F0D4+7+#50-#8000),hl
pop hl
ld (#F8D4+7+#50-#8000),hl
pop hl
ld (#C124+7+#50-#8000),hl
pop hl
ld (#C924+7+#50-#8000),hl
pop hl
ld (#D124+7+#50-#8000),hl
pop hl
ld (#D924+7+#50-#8000),hl
pop hl
ld (#E124+7+#50-#8000),hl
pop hl
ld (#E924+7+#50-#8000),hl
pop hl
ld (#F124+7+#50-#8000),hl
pop hl
ld (#F924+7+#50-#8000),hl
pop hl
ld (#C174+7+#50-#8000),hl
pop hl
ld (#C974+7+#50-#8000),hl
pop hl
ld (#D174+7+#50-#8000),hl
pop hl
ld (#D974+7+#50-#8000),hl
pop hl
ld (#E174+7+#50-#8000),hl
pop hl
ld (#E974+7+#50-#8000),hl
pop hl
ld (#F174+7+#50-#8000),hl
pop hl
ld (#F974+7+#50-#8000),hl
pop hl
ld (#C1C4+7+#50-#8000),hl
pop hl
ld (#C9C4+7+#50-#8000),hl
pop hl
ld (#D1C4+7+#50-#8000),hl
pop hl
ld (#D9C4+7+#50-#8000),hl
pop hl
ld (#E1C4+7+#50-#8000),hl
pop hl
ld (#E9C4+7+#50-#8000),hl
pop hl
ld (#F1C4+7+#50-#8000),hl
pop hl
ld (#F9C4+7+#50-#8000),hl
pop hl
ld (#C214+7+#50-#8000),hl
pop hl
ld (#CA14+7+#50-#8000),hl
pop hl
ld (#D214+7+#50-#8000),hl
pop hl
ld (#DA14+7+#50-#8000),hl
pop hl
ld (#E214+7+#50-#8000),hl
pop hl
ld (#EA14+7+#50-#8000),hl
pop hl
ld (#F214+7+#50-#8000),hl
pop hl
ld (#FA14+7+#50-#8000),hl
pop hl
ld (#C264+7+#50-#8000),hl
pop hl
ld (#CA64+7+#50-#8000),hl
pop hl
ld (#D264+7+#50-#8000),hl
pop hl
ld (#DA64+7+#50-#8000),hl
pop hl
ld (#E264+7+#50-#8000),hl
pop hl
ld (#EA64+7+#50-#8000),hl
pop hl
ld (#F264+7+#50-#8000),hl


col28 
ld sp,spr28
pop hl
ld (#C036+7+#50-#8000),hl
pop hl
ld (#C836+7+#50-#8000),hl
pop hl
ld (#D036+7+#50-#8000),hl
pop hl
ld (#D836+7+#50-#8000),hl
pop hl
ld (#E036+7+#50-#8000),hl
pop hl
ld (#E836+7+#50-#8000),hl
pop hl
ld (#F036+7+#50-#8000),hl
pop hl
ld (#F836+7+#50-#8000),hl
pop hl
ld (#C086+7+#50-#8000),hl
pop hl
ld (#C886+7+#50-#8000),hl
pop hl
ld (#D086+7+#50-#8000),hl
pop hl
ld (#D886+7+#50-#8000),hl
pop hl
ld (#E086+7+#50-#8000),hl
pop hl
ld (#E886+7+#50-#8000),hl
pop hl
ld (#F086+7+#50-#8000),hl
pop hl
ld (#F886+7+#50-#8000),hl
pop hl
ld (#C0D6+7+#50-#8000),hl
pop hl
ld (#C8D6+7+#50-#8000),hl
pop hl
ld (#D0D6+7+#50-#8000),hl
pop hl
ld (#D8D6+7+#50-#8000),hl
pop hl
ld (#E0D6+7+#50-#8000),hl
pop hl
ld (#E8D6+7+#50-#8000),hl
pop hl
ld (#F0D6+7+#50-#8000),hl
pop hl
ld (#F8D6+7+#50-#8000),hl
pop hl
ld (#C126+7+#50-#8000),hl
pop hl
ld (#C926+7+#50-#8000),hl
pop hl
ld (#D126+7+#50-#8000),hl
pop hl
ld (#D926+7+#50-#8000),hl
pop hl
ld (#E126+7+#50-#8000),hl
pop hl
ld (#E926+7+#50-#8000),hl
pop hl
ld (#F126+7+#50-#8000),hl
pop hl
ld (#F926+7+#50-#8000),hl
pop hl
ld (#C176+7+#50-#8000),hl
pop hl
ld (#C976+7+#50-#8000),hl
pop hl
ld (#D176+7+#50-#8000),hl
pop hl
ld (#D976+7+#50-#8000),hl
pop hl
ld (#E176+7+#50-#8000),hl
pop hl
ld (#E976+7+#50-#8000),hl
pop hl
ld (#F176+7+#50-#8000),hl
pop hl
ld (#F976+7+#50-#8000),hl
pop hl
ld (#C1C6+7+#50-#8000),hl
pop hl
ld (#C9C6+7+#50-#8000),hl
pop hl
ld (#D1C6+7+#50-#8000),hl
pop hl
ld (#D9C6+7+#50-#8000),hl
pop hl
ld (#E1C6+7+#50-#8000),hl
pop hl
ld (#E9C6+7+#50-#8000),hl
pop hl
ld (#F1C6+7+#50-#8000),hl
pop hl
ld (#F9C6+7+#50-#8000),hl
pop hl
ld (#C216+7+#50-#8000),hl
pop hl
ld (#CA16+7+#50-#8000),hl
pop hl
ld (#D216+7+#50-#8000),hl
pop hl
ld (#DA16+7+#50-#8000),hl
pop hl
ld (#E216+7+#50-#8000),hl
pop hl
ld (#EA16+7+#50-#8000),hl
pop hl
ld (#F216+7+#50-#8000),hl
pop hl
ld (#FA16+7+#50-#8000),hl
pop hl
ld (#C266+7+#50-#8000),hl
pop hl
ld (#CA66+7+#50-#8000),hl
pop hl
ld (#D266+7+#50-#8000),hl
pop hl
ld (#DA66+7+#50-#8000),hl
pop hl
ld (#E266+7+#50-#8000),hl
pop hl
ld (#EA66+7+#50-#8000),hl
pop hl
ld (#F266+7+#50-#8000),hl


col29 
ld sp,spr29
pop hl
ld (#C038+7+#50-#8000),hl
pop hl
ld (#C838+7+#50-#8000),hl
pop hl
ld (#D038+7+#50-#8000),hl
pop hl
ld (#D838+7+#50-#8000),hl
pop hl
ld (#E038+7+#50-#8000),hl
pop hl
ld (#E838+7+#50-#8000),hl
pop hl
ld (#F038+7+#50-#8000),hl
pop hl
ld (#F838+7+#50-#8000),hl
pop hl
ld (#C088+7+#50-#8000),hl
pop hl
ld (#C888+7+#50-#8000),hl
pop hl
ld (#D088+7+#50-#8000),hl
pop hl
ld (#D888+7+#50-#8000),hl
pop hl
ld (#E088+7+#50-#8000),hl
pop hl
ld (#E888+7+#50-#8000),hl
pop hl
ld (#F088+7+#50-#8000),hl
pop hl
ld (#F888+7+#50-#8000),hl
pop hl
ld (#C0D8+7+#50-#8000),hl
pop hl
ld (#C8D8+7+#50-#8000),hl
pop hl
ld (#D0D8+7+#50-#8000),hl
pop hl
ld (#D8D8+7+#50-#8000),hl
pop hl
ld (#E0D8+7+#50-#8000),hl
pop hl
ld (#E8D8+7+#50-#8000),hl
pop hl
ld (#F0D8+7+#50-#8000),hl
pop hl
ld (#F8D8+7+#50-#8000),hl
pop hl
ld (#C128+7+#50-#8000),hl
pop hl
ld (#C928+7+#50-#8000),hl
pop hl
ld (#D128+7+#50-#8000),hl
pop hl
ld (#D928+7+#50-#8000),hl
pop hl
ld (#E128+7+#50-#8000),hl
pop hl
ld (#E928+7+#50-#8000),hl
pop hl
ld (#F128+7+#50-#8000),hl
pop hl
ld (#F928+7+#50-#8000),hl
pop hl
ld (#C178+7+#50-#8000),hl
pop hl
ld (#C978+7+#50-#8000),hl
pop hl
ld (#D178+7+#50-#8000),hl
pop hl
ld (#D978+7+#50-#8000),hl
pop hl
ld (#E178+7+#50-#8000),hl
pop hl
ld (#E978+7+#50-#8000),hl
pop hl
ld (#F178+7+#50-#8000),hl
pop hl
ld (#F978+7+#50-#8000),hl
pop hl
ld (#C1C8+7+#50-#8000),hl
pop hl
ld (#C9C8+7+#50-#8000),hl
pop hl
ld (#D1C8+7+#50-#8000),hl
pop hl
ld (#D9C8+7+#50-#8000),hl
pop hl
ld (#E1C8+7+#50-#8000),hl
pop hl
ld (#E9C8+7+#50-#8000),hl
pop hl
ld (#F1C8+7+#50-#8000),hl
pop hl
ld (#F9C8+7+#50-#8000),hl
pop hl
ld (#C218+7+#50-#8000),hl
pop hl
ld (#CA18+7+#50-#8000),hl
pop hl
ld (#D218+7+#50-#8000),hl
pop hl
ld (#DA18+7+#50-#8000),hl
pop hl
ld (#E218+7+#50-#8000),hl
pop hl
ld (#EA18+7+#50-#8000),hl
pop hl
ld (#F218+7+#50-#8000),hl
pop hl
ld (#FA18+7+#50-#8000),hl
pop hl
ld (#C268+7+#50-#8000),hl
pop hl
ld (#CA68+7+#50-#8000),hl
pop hl
ld (#D268+7+#50-#8000),hl
pop hl
ld (#DA68+7+#50-#8000),hl
pop hl
ld (#E268+7+#50-#8000),hl
pop hl
ld (#EA68+7+#50-#8000),hl
pop hl
ld (#F268+7+#50-#8000),hl


col30 
ld sp,spr30
pop hl
ld (#C03A+7+#50-#8000),hl
pop hl
ld (#C83A+7+#50-#8000),hl
pop hl
ld (#D03A+7+#50-#8000),hl
pop hl
ld (#D83A+7+#50-#8000),hl
pop hl
ld (#E03A+7+#50-#8000),hl
pop hl
ld (#E83A+7+#50-#8000),hl
pop hl
ld (#F03A+7+#50-#8000),hl
pop hl
ld (#F83A+7+#50-#8000),hl
pop hl
ld (#C08A+7+#50-#8000),hl
pop hl
ld (#C88A+7+#50-#8000),hl
pop hl
ld (#D08A+7+#50-#8000),hl
pop hl
ld (#D88A+7+#50-#8000),hl
pop hl
ld (#E08A+7+#50-#8000),hl
pop hl
ld (#E88A+7+#50-#8000),hl
pop hl
ld (#F08A+7+#50-#8000),hl
pop hl
ld (#F88A+7+#50-#8000),hl
pop hl
ld (#C0DA+7+#50-#8000),hl
pop hl
ld (#C8DA+7+#50-#8000),hl
pop hl
ld (#D0DA+7+#50-#8000),hl
pop hl
ld (#D8DA+7+#50-#8000),hl
pop hl
ld (#E0DA+7+#50-#8000),hl
pop hl
ld (#E8DA+7+#50-#8000),hl
pop hl
ld (#F0DA+7+#50-#8000),hl
pop hl
ld (#F8DA+7+#50-#8000),hl
pop hl
ld (#C12A+7+#50-#8000),hl
pop hl
ld (#C92A+7+#50-#8000),hl
pop hl
ld (#D12A+7+#50-#8000),hl
pop hl
ld (#D92A+7+#50-#8000),hl
pop hl
ld (#E12A+7+#50-#8000),hl
pop hl
ld (#E92A+7+#50-#8000),hl
pop hl
ld (#F12A+7+#50-#8000),hl
pop hl
ld (#F92A+7+#50-#8000),hl
pop hl
ld (#C17A+7+#50-#8000),hl
pop hl
ld (#C97A+7+#50-#8000),hl
pop hl
ld (#D17A+7+#50-#8000),hl
pop hl
ld (#D97A+7+#50-#8000),hl
pop hl
ld (#E17A+7+#50-#8000),hl
pop hl
ld (#E97A+7+#50-#8000),hl
pop hl
ld (#F17A+7+#50-#8000),hl
pop hl
ld (#F97A+7+#50-#8000),hl
pop hl
ld (#C1CA+7+#50-#8000),hl
pop hl
ld (#C9CA+7+#50-#8000),hl
pop hl
ld (#D1CA+7+#50-#8000),hl
pop hl
ld (#D9CA+7+#50-#8000),hl
pop hl
ld (#E1CA+7+#50-#8000),hl
pop hl
ld (#E9CA+7+#50-#8000),hl
pop hl
ld (#F1CA+7+#50-#8000),hl
pop hl
ld (#F9CA+7+#50-#8000),hl
pop hl
ld (#C21A+7+#50-#8000),hl
pop hl
ld (#CA1A+7+#50-#8000),hl
pop hl
ld (#D21A+7+#50-#8000),hl
pop hl
ld (#DA1A+7+#50-#8000),hl
pop hl
ld (#E21A+7+#50-#8000),hl
pop hl
ld (#EA1A+7+#50-#8000),hl
pop hl
ld (#F21A+7+#50-#8000),hl
pop hl
ld (#FA1A+7+#50-#8000),hl
pop hl
ld (#C26A+7+#50-#8000),hl
pop hl
ld (#CA6A+7+#50-#8000),hl
pop hl
ld (#D26A+7+#50-#8000),hl
pop hl
ld (#DA6A+7+#50-#8000),hl
pop hl
ld (#E26A+7+#50-#8000),hl
pop hl
ld (#EA6A+7+#50-#8000),hl
pop hl
ld (#F26A+7+#50-#8000),hl


col31 
ld sp,spr31
pop hl
ld (#C03C+7+#50-#8000),hl
pop hl
ld (#C83C+7+#50-#8000),hl
pop hl
ld (#D03C+7+#50-#8000),hl
pop hl
ld (#D83C+7+#50-#8000),hl
pop hl
ld (#E03C+7+#50-#8000),hl
pop hl
ld (#E83C+7+#50-#8000),hl
pop hl
ld (#F03C+7+#50-#8000),hl
pop hl
ld (#F83C+7+#50-#8000),hl
pop hl
ld (#C08C+7+#50-#8000),hl
pop hl
ld (#C88C+7+#50-#8000),hl
pop hl
ld (#D08C+7+#50-#8000),hl
pop hl
ld (#D88C+7+#50-#8000),hl
pop hl
ld (#E08C+7+#50-#8000),hl
pop hl
ld (#E88C+7+#50-#8000),hl
pop hl
ld (#F08C+7+#50-#8000),hl
pop hl
ld (#F88C+7+#50-#8000),hl
pop hl
ld (#C0DC+7+#50-#8000),hl
pop hl
ld (#C8DC+7+#50-#8000),hl
pop hl
ld (#D0DC+7+#50-#8000),hl
pop hl
ld (#D8DC+7+#50-#8000),hl
pop hl
ld (#E0DC+7+#50-#8000),hl
pop hl
ld (#E8DC+7+#50-#8000),hl
pop hl
ld (#F0DC+7+#50-#8000),hl
pop hl
ld (#F8DC+7+#50-#8000),hl
pop hl
ld (#C12C+7+#50-#8000),hl
pop hl
ld (#C92C+7+#50-#8000),hl
pop hl
ld (#D12C+7+#50-#8000),hl
pop hl
ld (#D92C+7+#50-#8000),hl
pop hl
ld (#E12C+7+#50-#8000),hl
pop hl
ld (#E92C+7+#50-#8000),hl
pop hl
ld (#F12C+7+#50-#8000),hl
pop hl
ld (#F92C+7+#50-#8000),hl
pop hl
ld (#C17C+7+#50-#8000),hl
pop hl
ld (#C97C+7+#50-#8000),hl
pop hl
ld (#D17C+7+#50-#8000),hl
pop hl
ld (#D97C+7+#50-#8000),hl
pop hl
ld (#E17C+7+#50-#8000),hl
pop hl
ld (#E97C+7+#50-#8000),hl
pop hl
ld (#F17C+7+#50-#8000),hl
pop hl
ld (#F97C+7+#50-#8000),hl
pop hl
ld (#C1CC+7+#50-#8000),hl
pop hl
ld (#C9CC+7+#50-#8000),hl
pop hl
ld (#D1CC+7+#50-#8000),hl
pop hl
ld (#D9CC+7+#50-#8000),hl
pop hl
ld (#E1CC+7+#50-#8000),hl
pop hl
ld (#E9CC+7+#50-#8000),hl
pop hl
ld (#F1CC+7+#50-#8000),hl
pop hl
ld (#F9CC+7+#50-#8000),hl
pop hl
ld (#C21C+7+#50-#8000),hl
pop hl
ld (#CA1C+7+#50-#8000),hl
pop hl
ld (#D21C+7+#50-#8000),hl
pop hl
ld (#DA1C+7+#50-#8000),hl
pop hl
ld (#E21C+7+#50-#8000),hl
pop hl
ld (#EA1C+7+#50-#8000),hl
pop hl
ld (#F21C+7+#50-#8000),hl
pop hl
ld (#FA1C+7+#50-#8000),hl
pop hl
ld (#C26C+7+#50-#8000),hl
pop hl
ld (#CA6C+7+#50-#8000),hl
pop hl
ld (#D26C+7+#50-#8000),hl
pop hl
ld (#DA6C+7+#50-#8000),hl
pop hl
ld (#E26C+7+#50-#8000),hl
pop hl
ld (#EA6C+7+#50-#8000),hl
pop hl
ld (#F26C+7+#50-#8000),hl


col32 
ld sp,spr32
pop hl
ld (#C03E+7+#50-#8000),hl
pop hl
ld (#C83E+7+#50-#8000),hl
pop hl
ld (#D03E+7+#50-#8000),hl
pop hl
ld (#D83E+7+#50-#8000),hl
pop hl
ld (#E03E+7+#50-#8000),hl
pop hl
ld (#E83E+7+#50-#8000),hl
pop hl
ld (#F03E+7+#50-#8000),hl
pop hl
ld (#F83E+7+#50-#8000),hl
pop hl
ld (#C08E+7+#50-#8000),hl
pop hl
ld (#C88E+7+#50-#8000),hl
pop hl
ld (#D08E+7+#50-#8000),hl
pop hl
ld (#D88E+7+#50-#8000),hl
pop hl
ld (#E08E+7+#50-#8000),hl
pop hl
ld (#E88E+7+#50-#8000),hl
pop hl
ld (#F08E+7+#50-#8000),hl
pop hl
ld (#F88E+7+#50-#8000),hl
pop hl
ld (#C0DE+7+#50-#8000),hl
pop hl
ld (#C8DE+7+#50-#8000),hl
pop hl
ld (#D0DE+7+#50-#8000),hl
pop hl
ld (#D8DE+7+#50-#8000),hl
pop hl
ld (#E0DE+7+#50-#8000),hl
pop hl
ld (#E8DE+7+#50-#8000),hl
pop hl
ld (#F0DE+7+#50-#8000),hl
pop hl
ld (#F8DE+7+#50-#8000),hl
pop hl
ld (#C12E+7+#50-#8000),hl
pop hl
ld (#C92E+7+#50-#8000),hl
pop hl
ld (#D12E+7+#50-#8000),hl
pop hl
ld (#D92E+7+#50-#8000),hl
pop hl
ld (#E12E+7+#50-#8000),hl
pop hl
ld (#E92E+7+#50-#8000),hl
pop hl
ld (#F12E+7+#50-#8000),hl
pop hl
ld (#F92E+7+#50-#8000),hl
pop hl
ld (#C17E+7+#50-#8000),hl
pop hl
ld (#C97E+7+#50-#8000),hl
pop hl
ld (#D17E+7+#50-#8000),hl
pop hl
ld (#D97E+7+#50-#8000),hl
pop hl
ld (#E17E+7+#50-#8000),hl
pop hl
ld (#E97E+7+#50-#8000),hl
pop hl
ld (#F17E+7+#50-#8000),hl
pop hl
ld (#F97E+7+#50-#8000),hl
pop hl
ld (#C1CE+7+#50-#8000),hl
pop hl
ld (#C9CE+7+#50-#8000),hl
pop hl
ld (#D1CE+7+#50-#8000),hl
pop hl
ld (#D9CE+7+#50-#8000),hl
pop hl
ld (#E1CE+7+#50-#8000),hl
pop hl
ld (#E9CE+7+#50-#8000),hl
pop hl
ld (#F1CE+7+#50-#8000),hl
pop hl
ld (#F9CE+7+#50-#8000),hl
pop hl
ld (#C21E+7+#50-#8000),hl
pop hl
ld (#CA1E+7+#50-#8000),hl
pop hl
ld (#D21E+7+#50-#8000),hl
pop hl
ld (#DA1E+7+#50-#8000),hl
pop hl
ld (#E21E+7+#50-#8000),hl
pop hl
ld (#EA1E+7+#50-#8000),hl
pop hl
ld (#F21E+7+#50-#8000),hl
pop hl
ld (#FA1E+7+#50-#8000),hl
pop hl
ld (#C26E+7+#50-#8000),hl
pop hl
ld (#CA6E+7+#50-#8000),hl
pop hl
ld (#D26E+7+#50-#8000),hl
pop hl
ld (#DA6E+7+#50-#8000),hl
pop hl
ld (#E26E+7+#50-#8000),hl
pop hl
ld (#EA6E+7+#50-#8000),hl
pop hl
ld (#F26E+7+#50-#8000),hl

pile ld sp,0
ei
ret

;
spr1	
	ds 16,#00
	ds 16,#00	; 8*2
	ds 94,#00	; 56-8=48*2
	ds 16,#00
	ds 16,#00	; 8*2
spr2	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr3	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr4	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr5	
	ds 16,#00
	ds 16,#00
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr6	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr7	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr8	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr9	
	ds 16,#00 
	ds 16,#00	
	ds 94,#00
	ds 16,#00 
	ds 16,#00
spr10	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr11	
	ds 16,#00
	ds 16,#00
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr12	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr13	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr14	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr15	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr16	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr17	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr18	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr19	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr20	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr21	
	ds 16,#00 
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr22	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr23	
	ds 16,#00 
	ds 16,#00	
	ds 94,#00
	ds 16,#00 
	ds 16,#00
spr24	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr25	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00 
	ds 16,#00
spr26	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr27	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr28	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr29	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr30	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
spr31	
	ds 16,#00
	ds 16,#00	
	ds 94,#00
	ds 16,#00
	ds 16,#00
spr32	
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

	ds 94,#00

	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001
	dw #0001

sprite
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#50
db #44,#4c,#64,#e4,#cc,#cc,#cc,#cc
db #d8,#cc,#f0,#70,#18,#50,#10,#04
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#50,#40,#c8,#c0,#c4,#c8
db #c4,#cc,#cc,#cc,#cc,#cc,#cc,#d8
db #e4,#f0,#70,#b0,#70,#30,#30,#24
db #18,#04,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#01,#01
db #01,#01,#01,#01,#01,#01,#10,#60
db #c8,#c0,#c0,#c0,#c8,#c4,#c8,#c4
db #cc,#cc,#cc,#cc,#cc,#cc,#d8,#e4
db #f0,#70,#b0,#70,#30,#30,#24,#18
db #0c,#0c,#0c,#0c,#04,#01,#01,#01
db #01,#01,#01,#01,#01,#00,#00,#00
db #00,#00,#00,#10,#60,#c0,#c0,#c0
db #c0,#c0,#c0,#c8,#c4,#c8,#c4,#cc
db #d8,#cc,#cc,#cc,#cc,#cc,#e4,#e4
db #64,#b0,#70,#30,#30,#24,#18,#0c
db #0c,#0c,#0c,#0c,#0c,#04,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #10,#64,#c0,#c0,#c0,#c0,#c0,#c0
db #d0,#90,#98,#70,#b0,#f0,#f0,#d8
db #e4,#cc,#cc,#cc,#cc,#cc,#cc,#c8
db #c4,#c8,#e0,#64,#24,#18,#0c,#0c
db #0c,#0c,#0c,#0c,#0c,#0c,#04,#00
db #00,#00,#00,#00,#00,#00,#10,#c8
db #c0,#c0,#c0,#c0,#d0,#8c,#18,#24
db #30,#30,#70,#b0,#f0,#f0,#d8,#e4
db #cc,#cc,#cc,#cc,#cc,#cc,#c8,#c4
db #c8,#c4,#c0,#c0,#c8,#4c,#0c,#0c
db #0c,#0c,#0c,#0c,#0c,#0c,#04,#00
db #00,#00,#01,#01,#10,#c8,#c0,#c0
db #c0,#d0,#a4,#0c,#0c,#18,#24,#30
db #30,#70,#b0,#f0,#f0,#d8,#e4,#cc
db #cc,#cc,#cc,#cc,#cc,#c8,#c4,#c8
db #c4,#c0,#c0,#c0,#c0,#c0,#48,#0c
db #0c,#0c,#0c,#0c,#0c,#0c,#04,#01
db #01,#00,#00,#cc,#c0,#c0,#c0,#8c
db #0c,#0c,#0c,#0c,#18,#24,#30,#30
db #24,#a4,#a0,#a0,#20,#08,#08,#08
db #20,#a0,#88,#88,#98,#d0,#c4,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#4c
db #0c,#0c,#0c,#0c,#0c,#0c,#04,#00
db #00,#70,#c0,#c0,#c0,#a4,#0c,#0c
db #0c,#0c,#0c,#0c,#20,#08,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#20,#88
db #d0,#c0,#c0,#c0,#c0,#c0,#c0,#e4
db #0c,#0c,#0c,#0c,#0c,#0c,#00,#00
db #e4,#c0,#c0,#d8,#0c,#0c,#0c,#0c
db #0c,#08,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #a0,#d0,#c0,#c0,#c0,#c0,#c0,#f0
db #0c,#0c,#0c,#0c,#0c,#04,#01,#cc
db #c0,#c0,#24,#0c,#0c,#0c,#0c,#09
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #21,#cc,#c0,#c0,#c0,#c0,#cc,#0c
db #0c,#0c,#0c,#0c,#0c,#00,#cc,#c0
db #c0,#0c,#0c,#0c,#0c,#0c,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #b0,#c0,#c0,#c0,#c0,#c0,#0c,#0c
db #0c,#0c,#0c,#0c,#00,#cc,#c0,#c0
db #0c,#0c,#0c,#0c,#0c,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#30
db #c0,#c0,#c0,#c0,#c4,#0c,#0c,#0c
db #0c,#0c,#0c,#00,#cc,#c0,#c0,#70
db #0c,#0c,#0c,#0c,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#70,#c0
db #c0,#c0,#c0,#d8,#0c,#0c,#0c,#0c
db #0c,#0c,#01,#f0,#c0,#c0,#c8,#0c
db #0c,#0c,#0c,#0c,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#10,#cc,#c0,#c0
db #c0,#c4,#24,#0c,#0c,#0c,#0c,#0c
db #01,#00,#20,#c4,#c0,#c0,#e4,#0c
db #0c,#0c,#0c,#04,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#e4,#c0,#c4,#c0,#c4
db #b0,#0c,#0c,#0c,#0c,#0c,#0c,#00
db #00,#00,#98,#c0,#c0,#c0,#70,#0c
db #0c,#0c,#0c,#04,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #70,#cc,#c4,#c8,#c4,#c0,#cc,#0c
db #0c,#0c,#0c,#0c,#0c,#00,#00,#00
db #00,#00,#98,#c0,#c0,#c8,#4c,#0c
db #0c,#0c,#0c,#04,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#10,#70,#e4,#cc
db #cc,#c4,#c8,#c4,#c0,#cc,#0c,#0c
db #0c,#0c,#0c,#0c,#00,#00,#01,#01
db #01,#01,#98,#c4,#c0,#c0,#64,#18
db #0c,#0c,#0c,#0c,#04,#01,#01,#01
db #01,#01,#01,#01,#01,#04,#04,#10
db #18,#70,#f0,#e4,#d8,#cc,#cc,#cc
db #c4,#c8,#c4,#c0,#cc,#70,#0c,#0c
db #0c,#0c,#0c,#01,#01,#00,#00,#00
db #00,#00,#20,#90,#c0,#c0,#70,#30
db #30,#18,#18,#18,#00,#00,#00,#00
db #70,#e4,#70,#30,#70,#30,#70,#b0
db #70,#f0,#e4,#d8,#cc,#cc,#cc,#c4
db #c8,#c4,#c0,#c0,#cc,#18,#0c,#0c
db #0c,#0c,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#80,#c0,#f0,#30,#30
db #20,#20,#00,#00,#00,#00,#00,#c8
db #c0,#c8,#e0,#c0,#e0,#c8,#cc,#c8
db #cc,#c8,#c4,#c8,#c4,#c8,#c4,#c8
db #c0,#c0,#c0,#c0,#e4,#0c,#0c,#0c
db #0c,#0c,#04,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#20,#20,#00,#00
db #00,#00,#00,#00,#00,#00,#d8,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#64,#0c,#0c,#0c
db #0c,#0c,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#21,#a1,#89
db #89,#89,#a1,#21,#21,#09,#09,#09
db #09,#09,#09,#21,#21,#a1,#a1,#89
db #89,#84,#d0,#cc,#64,#30,#30,#30
db #21,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#20,#88,#20,#20,#00,#00
db #00,#c8,#64,#18,#0c,#0c,#0c,#04
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #10,#70,#30,#0c,#0c,#04,#00,#00
db #c0,#c0,#c8,#64,#0c,#0c,#18,#44
db #44,#40,#44,#40,#44,#40,#40,#44
db #40,#44,#44,#44,#44,#44,#44,#44
db #50,#44,#50,#50,#10,#50,#10,#10
db #04,#10,#04,#04,#04,#10,#70,#e4
db #cc,#e4,#30,#0c,#0c,#04,#01,#c0
db #c0,#c0,#cc,#18,#64,#cc,#c8,#c4
db #c8,#c0,#c8,#c0,#c0,#c0,#c0,#c8
db #c4,#cc,#cc,#cc,#cc,#cc,#cc,#d8
db #e4,#f0,#70,#b0,#70,#30,#30,#24
db #18,#0c,#0c,#0c,#0c,#24,#b0,#d8
db #b0,#0c,#0c,#0c,#0c,#00,#c0,#c0
db #c0,#cc,#cc,#c8,#c4,#c8,#c0,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c8,#c4
db #cc,#cc,#cc,#cc,#cc,#cc,#d8,#e4
db #f0,#70,#b0,#70,#30,#30,#24,#18
db #0c,#0c,#0c,#0c,#0c,#0c,#24,#0c
db #0c,#0c,#0c,#0c,#00,#c0,#c0,#c0
db #cc,#c4,#cc,#c4,#cc,#c4,#c4,#c4
db #c4,#c4,#c4,#c4,#c4,#cc,#c4,#cc
db #cc,#cc,#cc,#cc,#cc,#cc,#e4,#e4
db #64,#e4,#64,#64,#64,#64,#4c,#4c
db #4c,#4c,#4c,#4c,#58,#0c,#0c,#0c
db #0c,#0c,#0c,#00,#c0,#c0,#c0,#cc
db #0c,#24,#b0,#d8,#cc,#cc,#cc,#c4
db #c8,#c4,#c8,#c4,#c8,#c4,#c0,#c0
db #c0,#c0,#cc,#30,#0c,#24,#b0,#d8
db #cc,#cc,#cc,#c4,#c8,#c4,#c0,#c0
db #c0,#c0,#c0,#cc,#18,#0c,#0c,#0c
db #0c,#0c,#01,#c0,#c0,#c0,#cc,#0c
db #0c,#0c,#24,#b0,#d8,#cc,#cc,#cc
db #c4,#c8,#c4,#c8,#c4,#c0,#c0,#c0
db #c0,#cc,#30,#0c,#0c,#0c,#24,#b0
db #d8,#cc,#cc,#cc,#c4,#c8,#c4,#c0
db #c0,#c0,#c0,#e4,#0c,#0c,#0c,#0c
db #0c,#00,#c0,#c0,#c0,#cc,#0c,#0c
db #0c,#08,#08,#20,#a0,#88,#88,#88
db #88,#88,#88,#88,#88,#c0,#c0,#c0
db #cc,#30,#0c,#0c,#0c,#08,#08,#20
db #a0,#88,#88,#88,#88,#80,#8c,#c0
db #c0,#c0,#c8,#30,#18,#18,#0c,#0c
db #00,#c0,#c0,#c0,#cc,#0c,#0c,#0c
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#c0,#c0,#cc
db #30,#0c,#0c,#0c,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#80
db #c0,#c0,#f0,#30,#30,#30,#20,#00
db #c0,#c0,#c0,#cc,#0c,#0c,#0c,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#c0,#c0,#c0,#cc,#30
db #0c,#0c,#0c,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #80,#a0,#20,#20,#00,#00,#01,#c0
db #c0,#c0,#cc,#0c,#0c,#0c,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#c0,#c0,#c0,#cc,#30,#0c
db #0c,#0c,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#00,#c0,#c0
db #c0,#cc,#0c,#0c,#0c,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #58,#c0,#c0,#c0,#cc,#30,#0c,#0c
db #0c,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#cc,#c0,#c0
db #cc,#0c,#0c,#0c,#04,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#c8
db #c0,#c0,#c0,#cc,#30,#0c,#0c,#0c
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#cc,#c0,#c0,#cc
db #0c,#0c,#0c,#0c,#04,#00,#00,#00
db #00,#00,#00,#00,#10,#c8,#c0,#c0
db #c0,#c0,#d8,#24,#0c,#0c,#0c,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#01,#f0,#c0,#c0,#c8,#30
db #0c,#0c,#0c,#0c,#0c,#04,#04,#04
db #10,#44,#e0,#c4,#c0,#c0,#c0,#c0
db #d8,#24,#0c,#0c,#0c,#0c,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#00,#20,#c4,#c0,#c0,#cc,#0c
db #0c,#0c,#0c,#0c,#0c,#18,#f0,#cc
db #cc,#c8,#c4,#c0,#c0,#c0,#d8,#24
db #0c,#0c,#0c,#0c,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#98,#c0,#c0,#c0,#c8,#58
db #0c,#0c,#0c,#0c,#30,#f0,#cc,#cc
db #c8,#c4,#c0,#c0,#d8,#24,#0c,#0c
db #0c,#0c,#08,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#98,#c0,#c0,#c0,#c0,#e0
db #4c,#58,#4c,#70,#e0,#cc,#cc,#c8
db #c4,#98,#d8,#18,#0c,#0c,#0c,#0c
db #08,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #64,#58,#0c,#0c,#04,#00,#01,#01
db #01,#01,#98,#c4,#c0,#c0,#c0,#c0
db #c0,#c0,#c4,#c8,#cc,#cc,#d8,#f0
db #b0,#70,#18,#0c,#0c,#0c,#09,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#10,#50,#64,#e4,#cc
db #cc,#f0,#0c,#0c,#04,#00,#00,#00
db #00,#00,#20,#90,#c4,#c0,#c0,#c0
db #c0,#c4,#c8,#cc,#cc,#d8,#f0,#b0
db #70,#18,#0c,#08,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#10,#50
db #64,#e4,#d8,#e4,#d8,#e4,#cc,#b0
db #24,#0c,#0c,#0c,#00,#00,#00,#00
db #00,#00,#00,#20,#88,#d0,#c4,#c4
db #c4,#cc,#cc,#cc,#d8,#b0,#a4,#20
db #08,#00,#00,#00,#00,#00,#00,#00
db #10,#50,#64,#e4,#cc,#cc,#cc,#d8
db #e4,#d8,#e4,#d8,#e4,#b0,#0c,#0c
db #0c,#0c,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#08,#08
db #08,#08,#08,#00,#00,#00,#00,#00
db #00,#00,#10,#50,#44,#60,#e0,#cc
db #c8,#cc,#cc,#cc,#cc,#cc,#d8,#e4
db #d8,#e4,#cc,#cc,#0c,#0c,#0c,#0c
db #00,#00,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#10,#50,#64
db #e0,#c8,#c0,#c0,#c0,#c8,#c4,#c8
db #cc,#cc,#d8,#98,#cc,#d8,#e4,#d8
db #e4,#c8,#c4,#18,#0c,#0c,#0c,#01
db #01,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#10
db #50,#64,#e0,#c8,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c8,#c4,#98,#a4
db #24,#18,#30,#64,#d8,#e4,#cc,#c8
db #c0,#c0,#e4,#0c,#0c,#0c,#04,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#10,#50,#64,#e0,#c8,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c4,#d0,#c0,#cc,#30,#0c,#0c,#24
db #18,#30,#24,#88,#88,#84,#c0,#c0
db #c0,#cc,#70,#18,#18,#0c,#04,#00
db #00,#00,#00,#00,#10,#50,#44,#60
db #e0,#c8,#c0,#c0,#c0,#c0,#c0,#c0
db #c0,#c0,#c4,#d0,#90,#d8,#b0,#f0
db #cc,#c0,#cc,#30,#0c,#0c,#24,#08
db #00,#00,#00,#00,#00,#00,#80,#c0
db #c0,#cc,#64,#30,#30,#18,#01,#10
db #50,#64,#e0,#c8,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c4,#d0,#8c,#a4
db #18,#24,#30,#30,#70,#b0,#cc,#c0
db #c0,#cc,#30,#0c,#0c,#0c,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#81
db #81,#89,#21,#21,#01,#00,#e4,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c4,#d0
db #8c,#a4,#0c,#0c,#0c,#0c,#0c,#18
db #24,#30,#30,#20,#a0,#c0,#c0,#c0
db #cc,#30,#0c,#0c,#0c,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#c0,#c0,#c0
db #c0,#c4,#8c,#a4,#0c,#0c,#0c,#0c
db #0c,#0c,#0c,#0c,#0c,#0c,#08,#20
db #00,#00,#00,#00,#c0,#c0,#c0,#cc
db #30,#0c,#0c,#0c,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#c0,#c0,#c0,#c0
db #e0,#4c,#58,#0c,#0c,#0c,#0c,#0c
db #0c,#0c,#0c,#0c,#0c,#10,#04,#00
db #00,#00,#00,#c0,#c0,#c0,#cc,#30
db #0c,#0c,#0c,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#01,#d8,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c8,#e0,#48,#4c,#58
db #0c,#0c,#0c,#0c,#18,#24,#30,#30
db #50,#10,#c4,#c0,#c0,#cc,#30,#0c
db #0c,#0c,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#10,#10,#04,#04,#01
db #01,#00,#20,#a0,#98,#d0,#c4,#c0
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c8,#e0,#48,#48,#64,#30,#30,#70
db #b0,#d8,#c4,#c0,#cc,#30,#0c,#0c
db #0c,#10,#00,#00,#00,#00,#00,#00
db #10,#70,#cc,#e4,#58,#0c,#0c,#04
db #00,#00,#00,#00,#00,#20,#a0,#88
db #90,#d0,#c4,#c0,#c0,#c0,#c0,#c0
db #c0,#c0,#c0,#c0,#c0,#c8,#c8,#e0
db #e4,#cc,#c0,#cc,#30,#0c,#0c,#24
db #18,#24,#30,#18,#10,#18,#70,#e4
db #cc,#cc,#d8,#b0,#0c,#0c,#0c,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#20,#a0,#88,#90,#d0,#c4
db #c0,#c0,#c0,#c0,#c0,#c0,#c0,#c0
db #c8,#c0,#c8,#e4,#4c,#58,#24,#18
db #24,#30,#30,#30,#30,#30,#b0,#d8
db #98,#24,#0c,#0c,#0c,#00,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#21
db #a1,#89,#90,#d0,#c4,#c0,#c0,#c0
db #c0,#c8,#c4,#c8,#cc,#cc,#e4,#64
db #64,#70,#30,#30,#30,#30,#30,#0c
db #0c,#0c,#0c,#01,#01,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#20,#a0,#88,#90,#d0
db #cc,#c4,#c8,#cc,#cc,#cc,#cc,#cc
db #cc,#c8,#c4,#c8,#60,#64,#0c,#0c
db #0c,#0c,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #20,#a0,#98,#d8,#cc,#cc,#cc,#cc
db #c8,#c4,#c8,#c0,#c8,#70,#0c,#0c
db #0c,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#20,#a0,#98,#d8
db #c4,#c8,#c0,#c0,#c8,#70,#0c,#0c
db #0c,#00,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#21
db #89,#90,#c4,#c0,#c8,#cc,#30,#18
db #18,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#20,#88,#90,#c4,#cc,#30,#20
ze_end',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: gros-sprite
  SELECT id INTO tag_uuid FROM tags WHERE name = 'gros-sprite';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 20: fade-in by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fade-in',
    'Imported from z80Code. Author: gurneyh. Transition "circulaire"',
    'public',
    false,
    false,
    '2019-11-20T18:36:52.405000'::timestamptz,
    '2021-06-18T14:09:01.927000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; ==============================================================================
; CRTC
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc



; ------------------------------------------------------------------------------
;  I/O port address
CRTC_SELECT         equ #BC00
CRTC_WRITE          equ #BD00
CRTC_STATUS         equ #BE00
CRTC_READ           equ #BF00


macro WRITE_CRTC reg, val
                ld bc, CRTC_SELECT + {reg}
                ld a, {val}
                out (c), c
                inc b
                out (c), a
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
 
                di 
                ld hl, #c9fb
                ld (#38), hl
                ei

                SET_MODE 0
                WRITE_CRTC 1, 32
                WRITE_CRTC 2, 42
                WRITE_CRTC 6, 22

; ==============================================================================
; PPI
; ==============================================================================
; http://www.cpcwiki.eu/index.php/CRTC
; http://quasar.cpcscene.net/doku.php?id=assem:crtc


macro WAIT_VBL
                ld b, hi(PPI_B)
@wait
                in a, (c)
                rra
                jr nc, @wait
endm


; ------------------------------------------------------------------------------
;  I/O port address
PPI_A               equ #f400
PPI_B               equ #f500
PPI_C               equ #f600
PPI_CONTROL         equ #f700



main_loop:
                WAIT_VBL

                SET_BORDER Color.fm_6
                ld b, 192                       
                ld ixh, 3       ; 256 * 3 + 192
                ld iy, .next 
                ld de, #c000

                exx
                ld hl, table
                exx
.loop:        
                exx
                ld a, (hl)
                inc (hl)
                inc hl
                cp 16
                exx
                jr nc, .next_chr
                
                ld h, hi(patterns)
                add a, a 
                ld l, a
                ld a, (hl)
                inc l
                ld h, (hl)
                ld l, a 
               
                jp (hl)
.next:          
                add hl, de  
               	
                res 7, h
                ld a, (hl) 
                and c
                set 7, h
                or (hl)
                ld (hl), a 

                ld a, h 
                add a, 8 
                ld h, a 
                
                res 7, h
                ld a, (hl)
                and c
                set 7, h
                or (hl)
                ld (hl), a
             
.next_chr:     
                inc e : inc de 
                djnz .loop
                dec ixh

                jp nz, .loop

                jr main_loop

align 256
patterns:
dw pattern_0
dw pattern_1
dw pattern_2
dw pattern_3
dw pattern_4
dw pattern_5
dw pattern_6
dw pattern_7
dw pattern_8
dw pattern_9
dw pattern_10
dw pattern_11
dw pattern_12
dw pattern_13
dw pattern_14
dw pattern_15


pattern_0:
ld hl, 0x0
ld c, 170
jp (iy)

pattern_1:
ld hl, 0x2001
ld c, 170
jp (iy)

pattern_2:
ld hl, 0x1
ld c, 170
jp (iy)

pattern_3:
ld hl, 0x2000
ld c, 170
jp (iy)

pattern_4:
ld hl, 0x1000
ld c, 85
jp (iy)

pattern_5:
ld hl, 0x3001
ld c, 85
jp (iy)

pattern_6:
ld hl, 0x1001
ld c, 85
jp (iy)

pattern_7:
ld hl, 0x3000
ld c, 85
jp (iy)

pattern_8:
ld hl, 0x0
ld c, 85
jp (iy)

pattern_9:
ld hl, 0x2001
ld c, 85
jp (iy)

pattern_10:
ld hl, 0x1
ld c, 85
jp (iy)

pattern_11:
ld hl, 0x2000
ld c, 85
jp (iy)

pattern_12:
ld hl, 0x1000
ld c, 170
jp (iy)

pattern_13:
ld hl, 0x3001
ld c, 170
jp (iy)

pattern_14:
ld hl, 0x1001
ld c, 170
jp (iy)

pattern_15:
ld hl, 0x3000
ld c, 170
jp (iy)



table:
db 145, 150, 155, 159, 163, 167, 171, 175, 178, 182, 184, 187, 189, 191, 192, 193, 193, 193, 192, 191, 189, 187, 184, 182, 178, 175, 171, 167, 163, 159, 155, 150
db 149, 153, 158, 163, 167, 171, 175, 179, 183, 186, 189, 192, 194, 196, 198, 199, 199, 199, 198, 196, 194, 192, 189, 186, 183, 179, 175, 171, 167, 163, 158, 153
db 151, 156, 161, 166, 170, 175, 179, 183, 187, 191, 194, 197, 200, 202, 203, 204, 204, 204, 203, 202, 200, 197, 194, 191, 187, 183, 179, 175, 170, 166, 161, 156
db 154, 159, 164, 169, 174, 178, 183, 187, 191, 195, 199, 202, 205, 207, 209, 210, 210, 210, 209, 207, 205, 202, 199, 195, 191, 187, 183, 178, 174, 169, 164, 159
db 157, 162, 167, 172, 177, 182, 186, 191, 195, 199, 203, 207, 210, 212, 214, 215, 216, 215, 214, 212, 210, 207, 203, 199, 195, 191, 186, 182, 177, 172, 167, 162
db 159, 164, 169, 174, 179, 184, 189, 194, 199, 203, 207, 211, 215, 217, 220, 221, 221, 221, 220, 217, 215, 211, 207, 203, 199, 194, 189, 184, 179, 174, 169, 164
db 161, 166, 171, 177, 182, 187, 192, 197, 202, 207, 211, 215, 219, 222, 225, 227, 227, 227, 225, 222, 219, 215, 211, 207, 202, 197, 192, 187, 182, 177, 171, 166
db 162, 168, 173, 178, 184, 189, 194, 200, 205, 210, 215, 219, 223, 227, 230, 232, 233, 232, 230, 227, 223, 219, 215, 210, 205, 200, 194, 189, 184, 178, 173, 168
db 163, 169, 174, 180, 185, 191, 196, 202, 207, 212, 217, 222, 227, 231, 235, 238, 238, 238, 235, 231, 227, 222, 217, 212, 207, 202, 196, 191, 185, 180, 174, 169
db 164, 170, 175, 181, 187, 192, 198, 203, 209, 214, 220, 225, 230, 235, 239, 243, 244, 243, 239, 235, 230, 225, 220, 214, 209, 203, 198, 192, 187, 181, 175, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 215, 221, 227, 232, 238, 243, 247, 250, 247, 243, 238, 232, 227, 221, 215, 210, 204, 199, 193, 187, 182, 176, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 216, 221, 227, 233, 238, 244, 250, 255, 250, 244, 238, 233, 227, 221, 216, 210, 204, 199, 193, 187, 182, 176, 170
db 165, 170, 176, 182, 187, 193, 199, 204, 210, 215, 221, 227, 232, 238, 243, 247, 250, 247, 243, 238, 232, 227, 221, 215, 210, 204, 199, 193, 187, 182, 176, 170
db 164, 170, 175, 181, 187, 192, 198, 203, 209, 214, 220, 225, 230, 235, 239, 243, 244, 243, 239, 235, 230, 225, 220, 214, 209, 203, 198, 192, 187, 181, 175, 170
db 163, 169, 174, 180, 185, 191, 196, 202, 207, 212, 217, 222, 227, 231, 235, 238, 238, 238, 235, 231, 227, 222, 217, 212, 207, 202, 196, 191, 185, 180, 174, 169
db 162, 168, 173, 178, 184, 189, 194, 200, 205, 210, 215, 219, 223, 227, 230, 232, 233, 232, 230, 227, 223, 219, 215, 210, 205, 200, 194, 189, 184, 178, 173, 168
db 161, 166, 171, 177, 182, 187, 192, 197, 202, 207, 211, 215, 219, 222, 225, 227, 227, 227, 225, 222, 219, 215, 211, 207, 202, 197, 192, 187, 182, 177, 171, 166
db 159, 164, 169, 174, 179, 184, 189, 194, 199, 203, 207, 211, 215, 217, 220, 221, 221, 221, 220, 217, 215, 211, 207, 203, 199, 194, 189, 184, 179, 174, 169, 164
db 157, 162, 167, 172, 177, 182, 186, 191, 195, 199, 203, 207, 210, 212, 214, 215, 216, 215, 214, 212, 210, 207, 203, 199, 195, 191, 186, 182, 177, 172, 167, 162
db 154, 159, 164, 169, 174, 178, 183, 187, 191, 195, 199, 202, 205, 207, 209, 210, 210, 210, 209, 207, 205, 202, 199, 195, 191, 187, 183, 178, 174, 169, 164, 159
db 151, 156, 161, 166, 170, 175, 179, 183, 187, 191, 194, 197, 200, 202, 203, 204, 204, 204, 203, 202, 200, 197, 194, 191, 187, 183, 179, 175, 170, 166, 161, 156
db 149, 153, 158, 163, 167, 171, 175, 179, 183, 186, 189, 192, 194, 196, 198, 199, 199, 199, 198, 196, 194, 192, 189, 186, 183, 179, 175, 171, 167, 163, 158, 153

macro fill_pattern col,lin
  repeat 8,c3   
   repeat {lin},c2
    repeat {col},c1
     if (c1>{col}/{lin}*c2)
      db #82  + #41
     else
      db #02 + #01
     endif
    rend
   rend
   ds 2048-{lin}*{col},0
  rend
mend


; Donnees directement ecrite en memoire video
 org #4000
 fill_pattern 64,22

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: transtion
  SELECT id INTO tag_uuid FROM tags WHERE name = 'transtion';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
