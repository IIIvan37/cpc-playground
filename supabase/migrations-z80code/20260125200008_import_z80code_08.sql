-- Migration: Import z80code projects batch 8
-- Projects 15 to 16
-- Generated: 2026-01-25T21:43:30.183506

-- Project 15: deltabulus by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'deltabulus',
    'Imported from z80Code. Author: tronic. Un truc sans importance...',
    'public',
    false,
    false,
    '2021-03-27T00:04:25.607000'::timestamptz,
    '2021-06-18T13:53:32.717000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Tour nebulus sur la hauteur de l''écran (test...)
; animation delta (2 blocs=8+8=16 lignes x128pixels de large) - 8 frames - 50hz ou 25hz...
; delta élaboré via un tool perso...
; les 2 blocs/animations sont en fait les mêmes en terme de delta, mais décalées
; tant en hauteur (+#50) qu''en offset/pointeur de frames
; Frames = 1,2,3,4,5,6,7,8 pour le 1er bloc de 8 lignes et 5,6,7,8,1,2,3,4 pour le 2nd bloc de 8 lignes
; les octets delta sont directement pokés en ram écran via ld (nn),a un peu à la manière de sprites autogen...
; ce genre de delta "semble" plus rapide (moins de 16RL ici) comparativement 
; à du delta typé "deltavoxel" (voir sur rasmlive)
; Les appels sont effectués via des ret via l''utilisation d''une table de pile...
; Rupture de 16 lignes qui semble fonctionner ici...
; (à re-vérifier selon les cpc, crtc, émulateurs...)
; permettant la duplication en hauteur sur tout l''écran (classique & rien de nouveau...)
; mais, duplication, qui peut-être contrecarrée par le dessin de "motifs" déroulants la vbl...
; Pas de test vsync (19968 nops) - temps fixe - jouer avec ticker à l''occaz
; Vu qu''il reste 262RL+58nop de libres, pour faire autre chose... (-8*24RL avec les motifs...)
; mettre des rasters ou splits sur tout l''écran ?
; une musique ? Un scroll ? Un logo ? Autre ? Ou rien...
; ...
; Tronic/GPA

BUILDSNA
BANKSET 0
SNASET CPC_TYPE,2


org #40
nolist
run $

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

macro	wline num
 		ld bc,{num}*8-1
@loop 	nop
 		dec bc
 		ld a,b
 		or c
 		jr nz,@loop
 		bit 0,(ix)
mend


macro	wait32		; 1/2 ligne (32nop)
		ld hl,@next	
		ex (sp),ix
		ex (sp),ix
		ex (sp),ix
		ex (sp),ix
		jp (hl)
@next
mend


macro	rastline
		ld bc,#7f00
		ld hl,#535c
		out (c),c
		out (c),h
		defs 46,0
		out (c),l
mend   


start
		di:ld hl,#c9fb:ld (#38),hl
		ld bc,#7f00:ld a,ink03:out (c),c:out (c),a
		ld bc,#7f01:ld a,ink00:out (c),c:out (c),a
		ld bc,#7f02:ld a,ink26:out (c),c:out (c),a
		ld bc,#7f03:ld a,ink06:out (c),c:out (c),a
		ld bc,#7f10:ld a,ink03:out (c),c:out (c),a    
        
        ld bc,#bc01
        out (c),c
        ld bc,#bd00+40	; changer R1 (...37,38,39,40,41,42,43...) pour décallage horizontal
        out (c),c 
        
        ;jr $
        

		ld b,#f5
		vbl in a,(c) : rra : jr nc,vbl
		novbl in a,(c) : rra : jr c,novbl        
		; vbl hors mainloop

mainloop
		; pas de test vsync (19968 nop - temps fixe)
	
		wline 32

		ld bc,#bc07
		out (c),c
		ld bc,#bd00+#ff
		out (c),c

		ld bc,#bc04
		out (c),c
		ld bc,#bd00+#01
		out (c),c


pile	
		ld sp,table
		ret
    
nxt1
		nop:nop:nop
		ld (pile+1),sp
		jp cont
nxt2
		ld sp,table
		ld (pile+1),sp
		jp cont

cont

		; test de dessins de "motifs" (logo?trame?autre?) suivant/contrecarrant la vbl qui se déroule...
        ; évitant ainsi les répétitions de 8+8=16 lignes provoquées par la rupture...
        ; ptet pas encore bien synchro niveau "placement écran", à vérifier...
        
        ; le tracé de motifs (côté droit+gauche) faisant 64nop+64nop
        ; avec 10 nop de marge encore d''où out/raster (2+4=6), pour faire un "joli" dégradé+trames...
        
       
        ld bc,#7f03	; 
        out (c),c	; 
        			; 4+3=7

		; tester plus large...
		;* (63+1)
        ;ld sp,#c050:ld hl,#aaff:ld de,#ffff:repeat 6:push hl:push de:rend:ld a,INK01 : out (c),a : nop

		;** (64)
        ;ld sp,#c050:ld hl,#aaff:ld de,#ffff:repeat 6:push hl:push de:rend:ld a,INK01 : out (c),a ; + exx à caser/voir... ?
        
        ld sp,#c050:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ;wline 8
        ld sp,#c018:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#aaff:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#ffaa:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0      
        
       
        ld sp,#c050:ld hl,#caca:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#caca:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#caca:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#caca:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#caca:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#caca:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#caca:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#caca:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0 
        ;wline 8
        ld sp,#c018:ld hl,#caca:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#caca:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#caca:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#caca:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#caca:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#caca:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#caca:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#caca:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        

        ld sp,#c050:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ;wline 8
        ld sp,#c018:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#bbff:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#ffbb:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        
       
        ld sp,#c050:ld hl,#beef:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#beef:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#beef:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#beef:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#beef:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#beef:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#beef:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#beef:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0     
        ;wline 8 
        ld sp,#c018:ld hl,#beef:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#beef:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#beef:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#beef:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#beef:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#beef:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#beef:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#beef:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0 
        
       
        ld sp,#c050:ld hl,#dead:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#dead:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#dead:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#dead:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#dead:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#dead:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#dead:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#dead:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0    
		;wline 8
        ld sp,#c018:ld hl,#dead:repeat 12:push hl:rend:ld a,INk19 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#dead:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#dead:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#dead:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#dead:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#dead:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#dead:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#dead:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0 
        
       
        ld sp,#c050:ld hl,#0800:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#0080:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#0008:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#8000:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#0800:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#0080:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#0008:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#8000:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0 
		;wline 8
        ld sp,#c018:ld hl,#0800:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#0080:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#0008:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#8000:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#0800:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#0080:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#0008:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#8000:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0         
        

        ld sp,#c050:ld hl,#4545:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#5454:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#4545:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#5454:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#4545:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#5454:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#4545:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#5454:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ;wline 8
        ld sp,#c018:ld hl,#4545:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#5454:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#4545:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#5454:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#4545:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#5454:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#4545:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#5454:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        
       
        ld sp,#c050:ld hl,#1767:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#1676:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#1767:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#1676:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#1767:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#1676:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#1767:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#1676:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
		;wline 8
        ld sp,#c018:ld hl,#1767:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#1676:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#1767:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#1676:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#1767:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#1676:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#1767:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#1676:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        

        ld sp,#c050:ld hl,#990b:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#990b:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#990b:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#990b:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
		;wline 8 
        ld sp,#c018:ld hl,#990b:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#990b:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#990b:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#990b:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#0b99:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0

       
        ld sp,#c050:ld hl,#1973:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#2021:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#1973:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#2021:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#1973:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#2021:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#1973:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#2021:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0    
		;wline 8
        ld sp,#c018:ld hl,#1973:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#2021:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#1973:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#2021:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#1973:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#2021:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#1973:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#2021:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        
       
        ld sp,#c050:ld hl,#1418:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#3940:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#1418:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#3940:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#1418:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#3940:repeat 12:push hl:rend:ld a,INK04 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#1418:repeat 12:push hl:rend:ld a,INK05 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#3940:repeat 12:push hl:rend:ld a,INK06 : out (c),a : defs 4,0   
		;wline 8  
        ld sp,#c018:ld hl,#1418:repeat 12:push hl:rend:ld a,INK07 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#3940:repeat 12:push hl:rend:ld a,INK08 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#1418:repeat 12:push hl:rend:ld a,INK09 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#3940:repeat 12:push hl:rend:ld a,INK10 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#1418:repeat 12:push hl:rend:ld a,INK11 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#3940:repeat 12:push hl:rend:ld a,INK12 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#1418:repeat 12:push hl:rend:ld a,INK13 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#3940:repeat 12:push hl:rend:ld a,INK14 : out (c),a : defs 4,0
        
       
        ld sp,#c050:ld hl,#0000:repeat 12:push hl:rend:ld a,INK15 : out (c),a : defs 4,0
        ld sp,#c850:ld hl,#0000:repeat 12:push hl:rend:ld a,INK16 : out (c),a : defs 4,0
        ld sp,#d050:ld hl,#0000:repeat 12:push hl:rend:ld a,INK17 : out (c),a : defs 4,0
        ld sp,#d850:ld hl,#0000:repeat 12:push hl:rend:ld a,INK18 : out (c),a : defs 4,0
        ld sp,#e050:ld hl,#0000:repeat 12:push hl:rend:ld a,INK19 : out (c),a : defs 4,0
        ld sp,#e850:ld hl,#0000:repeat 12:push hl:rend:ld a,INK20 : out (c),a : defs 4,0
        ld sp,#f050:ld hl,#0000:repeat 12:push hl:rend:ld a,INK21 : out (c),a : defs 4,0
        ld sp,#f850:ld hl,#0000:repeat 12:push hl:rend:ld a,INK22 : out (c),a : defs 4,0
		;wline 8
        ld sp,#c018:ld hl,#0000:repeat 12:push hl:rend:ld a,INK23 : out (c),a : defs 4,0
        ld sp,#c818:ld hl,#0000:repeat 12:push hl:rend:ld a,INK24 : out (c),a : defs 4,0
        ld sp,#d018:ld hl,#0000:repeat 12:push hl:rend:ld a,INK25 : out (c),a : defs 4,0
        ld sp,#d818:ld hl,#0000:repeat 12:push hl:rend:ld a,INK26 : out (c),a : defs 4,0
        ld sp,#e018:ld hl,#0000:repeat 12:push hl:rend:ld a,INK00 : out (c),a : defs 4,0
        ld sp,#e818:ld hl,#0000:repeat 12:push hl:rend:ld a,INK01 : out (c),a : defs 4,0
        ld sp,#f018:ld hl,#0000:repeat 12:push hl:rend:ld a,INK02 : out (c),a : defs 4,0
        ld sp,#f818:ld hl,#0000:repeat 12:push hl:rend:ld a,INK03 : out (c),a : defs 4,0
        

		rastline
        
		wline (262-1-8*24)	; -1=rastline & -8*24=les motifs... 
        defs 51,0			; 58-7=51

		;wline 262		; 262RL+58nop de libres, pour faire autre chose :)
		;defs 58,0


		ld bc,#bc04
		out (c),c
		ld bc,#bd00+4	; vite fait, à revérifier...
		out (c),c

		ld bc,#bc07
		out (c),c
		ld bc,#bd00+2	; vite fait, à revérifier...
		out (c),c

	
		jp mainloop

table
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p1to2,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p2to3,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p3to4,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p4to5,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p5to6,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p6to7,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p7to8,nxt1
dw slow,nxt1	; ligne à virer/mettre pour du 50hz/25hz
dw p8to1,nxt2
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

slow
		; l''animation delta pousse à 1014 nop au max
        ; +3 nop de ret...
        ; soit 1017 nop au total
	    ; 15*64+32+22+3(ret)=1017/64=15.89RL
        
		wline 15
        wait32
        defs 22,0
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; delta en ld (nn),a
p1to2
defs 104,0		
			; rajout ou pas de nop pour compenser (temps fixe)
			; (jouer avec ticker à l''occaz)
            ; ou faire macro dédiée au cas ptet mieux...

ld a,#0f
ld (#C019),a
ld (#C01D),a
ld (#C022),a
ld (#C822),a
ld (#C828),a
ld (#C82E),a
ld (#C833),a
ld (#D01C),a
ld (#D832),a
ld (#D836),a
ld (#E01B),a
ld (#E025),a
ld (#E031),a
ld (#E035),a
ld a,#1e
ld (#C029),a
ld (#C02F),a
ld (#C819),a
ld (#C81D),a
ld (#D028),a
ld (#D02E),a
ld (#D033),a
ld (#D819),a
ld (#D821),a
ld (#D827),a
ld (#D82D),a
ld (#E02C),a
ld (#E82A),a
ld a,#2d
ld (#C023),a
ld (#C034),a
ld (#D022),a
ld (#D81C),a
ld (#D828),a
ld (#D82E),a
ld (#E020),a
ld (#E026),a
ld (#E032),a
ld a,#3C
ld (#C829),a
ld (#C82F),a
ld (#E836),a
ld a,#4B
ld (#E02D),a
ld (#E82C),a
ld a,#5A
ld (#C037),a
ld (#C837),a
ld (#D01D),a
ld (#D822),a
ld (#D837),a
ld (#E832),a
ld a,#69
ld (#C823),a
ld (#C834),a
ld (#D034),a
ld (#E81C),a
ld a,#78
ld (#D029),a
ld (#D02F),a
ld (#E01D),a
ld (#E036),a
ld (#E821),a
ld (#E822),a
ld (#E827),a
ld (#E828),a
ld (#E82E),a
ld (#F02A),a
ld a,#87
ld (#C01A),a
ld (#C01E),a
ld (#C81A),a
ld (#C81E),a
ld (#D01A),a
ld (#D01E),a
ld (#D818),a
ld (#D81A),a
ld (#D81E),a
ld (#D833),a
ld (#E01A),a
ld (#E01E),a
ld a,#96
ld (#E018),a
ld (#E81E),a
ld (#E820),a
ld (#E826),a
ld a,#a5
ld (#E021),a
ld (#E027),a
ld (#E818),a
ld a,#b4
ld (#D81D),a
ld (#E022),a
ld (#E82D),a
ld (#E833),a
ld (#F01E),a
ld a,#d2
ld (#D037),a
ld (#E01C),a
ld (#E028),a
ld (#E02E),a
ld (#E037),a
ld a,#e1
ld (#D023),a
ld (#D823),a
ld (#D834),a
ld (#E023),a
ld (#E034),a
ld (#E823),a
ld (#E834),a
ld (#F023),a
ld a,#f0
ld (#D829),a
ld (#D82F),a
ld (#E029),a
ld (#E02F),a
ld (#E81D),a
ld (#E829),a
ld (#E82F),a
ld (#E837),a
ld (#F029),a
ld (#F02F),a

;;;;

ld a,#0F
ld (#C025+#50),a
ld (#C031+#50),a
ld (#C035+#50),a
ld (#C81F+#50),a
ld (#C825+#50),a
ld (#C82B+#50),a
ld (#C831+#50),a
ld (#C835+#50),a
ld (#D024+#50),a
ld (#D030+#50),a
ld (#D035+#50),a
ld (#D823+#50),a
ld (#E022+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E033+#50),a
ld (#E82D+#50),a
ld a,#1E
ld (#C01B+#50),a
ld (#C02C+#50),a
ld (#D01F+#50),a
ld (#D02B+#50),a
ld (#D031+#50),a
ld (#D81E+#50),a
ld (#D82A+#50),a
ld (#E019+#50),a
ld (#E01D+#50),a
ld (#E037+#50),a
ld a,#2D
ld (#C020+#50),a
ld (#C026+#50),a
ld (#D025+#50),a
ld (#D81A+#50),a
ld (#D81F+#50),a
ld (#D82B+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld (#E81D+#50),a
ld (#E823+#50),a
ld a,#3C
ld (#C81B+#50),a
ld (#C82C+#50),a
ld a,#4B
ld (#C032+#50),a
ld (#C036+#50),a
ld (#E034+#50),a
ld a,#5A
ld (#D825+#50),a
ld (#E023+#50),a
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E035+#50),a
ld a,#69
ld (#C820+#50),a
ld (#C826+#50),a
ld (#E01E+#50),a
ld a,#78
ld (#D02C+#50),a
ld (#D81B+#50),a
ld (#D831+#50),a
ld (#E81A+#50),a
ld (#E81F+#50),a
ld (#E82A+#50),a
ld (#E82B+#50),a
ld (#F02D+#50),a
ld a,#87
ld (#C018+#50),a
ld (#C818+#50),a
ld a,#96
ld (#E829+#50),a
ld (#E82F+#50),a
ld a,#A5
ld (#D818+#50),a
ld (#E02A+#50),a
ld a,#B4
ld (#D835+#50),a
ld (#E025+#50),a
ld (#E031+#50),a
ld (#E81E+#50),a
ld (#E834+#50),a
ld a,#C3
ld (#C832+#50),a
ld (#C836+#50),a
ld (#D032+#50),a
ld (#D036+#50),a
ld (#D832+#50),a
ld (#D836+#50),a
ld (#E032+#50),a
ld (#E036+#50),a
ld (#E819+#50),a
ld (#E832+#50),a
ld a,#D2
ld (#E01A+#50),a
ld (#E01F+#50),a
ld (#E02B+#50),a
ld a,#E1
ld (#D020+#50),a
ld (#D026+#50),a
ld (#D820+#50),a
ld (#D826+#50),a
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E820+#50),a
ld (#E824+#50),a
ld (#E826+#50),a
ld (#E830+#50),a
ld (#F020+#50),a
ld (#F026+#50),a
ld a,#F0
ld (#D01B+#50),a
ld (#D82C+#50),a
ld (#E01B+#50),a
ld (#E02C+#50),a
ld (#E81B+#50),a
ld (#E82C+#50),a
ld (#E831+#50),a
ld (#E836+#50),a
ld (#F02C+#50),a
ld (#F031+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p2to3
defs 62,0

ld a,#0f
ld (#C023),a
ld (#C029),a
ld (#C02F),a
ld (#C034),a
ld (#C819),a
ld (#C81D),a
ld (#C823),a
ld (#C829),a
ld (#C82F),a
ld (#D022),a
ld (#D028),a
ld (#D02E),a
ld (#D033),a
ld (#D819),a
ld (#D81C),a
ld (#D821),a
ld (#D827),a
ld (#D82D),a
ld (#D833),a
ld (#E020),a
ld (#E026),a
ld (#E02C),a
ld (#E032),a
ld a,#1e
ld (#C834),a
ld (#D019),a
ld (#D01D),a
ld (#E036),a
ld a,#2d
ld (#C01E),a
ld (#C02A),a
ld (#C81E),a
ld (#D029),a
ld (#D02F),a
ld (#E01C),a
ld (#E821),a
ld (#E827),a
ld a,#3c
ld (#C037),a
ld (#C837),a
ld (#D037),a
ld (#D834),a
ld (#E022),a
ld (#E02D),a
ld a,#4b
ld (#C01A),a
ld (#C024),a
ld (#C030),a
ld (#C81A),a
ld (#D822),a
ld (#E832),a
ld a,#5a
ld (#D023),a
ld (#D034),a
ld (#D829),a
ld (#D82F),a
ld (#E021),a
ld (#E027),a
ld (#E028),a
ld (#E02E),a
ld (#E81C),a
ld a,#69
ld (#C82A),a
ld (#D01E),a
ld (#E833),a
ld a,#78
ld (#D837),a
ld (#E019),a
ld (#E023),a
ld (#E837),a
ld a,#87
ld (#C035),a
ld (#C835),a
ld (#D035),a
ld (#D81D),a
ld (#D835),a
ld (#E018),a
ld (#E035),a
ld (#E82D),a
ld a,#b4
ld (#D823),a
ld (#E029),a
ld (#E02F),a
ld (#E033),a
ld (#E81D),a
ld a,#c3
ld (#C824),a
ld (#C830),a
ld (#D01A),a
ld (#D024),a
ld (#D030),a
ld (#D81A),a
ld (#D824),a
ld (#D830),a
ld (#E01A),a
ld (#E024),a
ld (#E030),a
ld (#E81A),a
ld (#E824),a
ld (#E830),a
ld a,#d2
ld (#E819),a
ld (#E822),a
ld (#F01A),a
ld (#F024),a
ld (#F030),a
ld a,#e1
ld (#D02A),a
ld (#D81E),a
ld (#D82A),a
ld (#E01E),a
ld (#E02A),a
ld (#E81E),a
ld (#E828),a
ld (#E82A),a
ld (#E82E),a
ld (#F01E),a
ld (#F02A),a
ld a,#f0
ld (#E034),a
ld (#E037),a
ld (#E823),a
ld (#E834),a
ld (#F023),a

;;;;

ld a,#0F
ld (#C01B+#50),a
ld (#C020+#50),a
ld (#C026+#50),a
ld (#C02C+#50),a
ld (#C81B+#50),a
ld (#C820+#50),a
ld (#C826+#50),a
ld (#C82C+#50),a
ld (#D01F+#50),a
ld (#D025+#50),a
ld (#D02B+#50),a
ld (#D031+#50),a
ld (#D81A+#50),a
ld (#D81E+#50),a
ld (#D824+#50),a
ld (#D82A+#50),a
ld (#D830+#50),a
ld (#E01D+#50),a
ld (#E023+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld a,#1E
ld (#C032+#50),a
ld (#D837+#50),a
ld (#E01E+#50),a
ld (#E034+#50),a
ld a,#2D
ld (#C02D+#50),a
ld (#C036+#50),a
ld (#D02C+#50),a
ld (#D835+#50),a
ld (#E82A+#50),a
ld a,#3C
ld (#C832+#50),a
ld (#D01B+#50),a
ld (#E01A+#50),a
ld (#E037+#50),a
ld a,#4B
ld (#C01C+#50),a
ld (#C021+#50),a
ld (#C027+#50),a
ld (#D825+#50),a
ld a,#5A
ld (#D020+#50),a
ld (#D026+#50),a
ld (#D81B+#50),a
ld (#D82C+#50),a
ld (#D831+#50),a
ld (#E01F+#50),a
ld (#E02A+#50),a
ld (#E02B+#50),a
ld (#E81A+#50),a
ld (#E824+#50),a
ld (#E830+#50),a
ld (#E837+#50),a
ld a,#69
ld (#C82D+#50),a
ld (#C836+#50),a
ld (#D836+#50),a
ld a,#78
ld (#D832+#50),a
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E81B+#50),a
ld (#E835+#50),a
ld a,#87
ld (#C019+#50),a
ld (#C819+#50),a
ld (#D019+#50),a
ld (#D819+#50),a
ld (#E019+#50),a
ld a,#96
ld (#C818+#50),a
ld (#D018+#50),a
ld a,#A5
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E031+#50),a
ld (#E81E+#50),a
ld (#E834+#50),a
ld a,#B4
ld (#D818+#50),a
ld (#D820+#50),a
ld (#D826+#50),a
ld (#E01B+#50),a
ld (#E02C+#50),a
ld a,#C3
ld (#C81C+#50),a
ld (#C821+#50),a
ld (#C827+#50),a
ld (#D01C+#50),a
ld (#D021+#50),a
ld (#D027+#50),a
ld (#D81C+#50),a
ld (#D821+#50),a
ld (#D827+#50),a
ld (#E01C+#50),a
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E81C+#50),a
ld (#E821+#50),a
ld (#E827+#50),a
ld a,#D2
ld (#E018+#50),a
ld (#E035+#50),a
ld (#E825+#50),a
ld (#F021+#50),a
ld (#F027+#50),a
ld a,#E1
ld (#D02D+#50),a
ld (#D036+#50),a
ld (#D82D+#50),a
ld (#E02D+#50),a
ld (#E036+#50),a
ld (#E81F+#50),a
ld (#E82B+#50),a
ld (#E82D+#50),a
ld a,#F0
ld (#D032+#50),a
ld (#E032+#50),a
ld (#E818+#50),a
ld (#E820+#50),a
ld (#E826+#50),a
ld (#E832+#50),a
ld (#F020+#50),a
ld (#F026+#50),a
ld (#F02D+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p3to4
defs 34,0

ld a,#0F
ld (#C01E),a
ld (#C024),a
ld (#C02A),a
ld (#C030),a
ld (#C81E),a
ld (#C82A),a
ld (#C834),a
ld (#D019),a
ld (#D01D),a
ld (#D023),a
ld (#D029),a
ld (#D02F),a
ld (#D81D),a
ld (#D822),a
ld (#D828),a
ld (#D82E),a
ld (#D834),a
ld (#E021),a
ld (#E027),a
ld (#E02D),a
ld (#E036),a
ld a,#1E
ld (#C01A),a
ld (#C037),a
ld (#C81A),a
ld (#C824),a
ld (#C830),a
ld (#C837),a
ld (#D01E),a
ld (#D034),a
ld (#E019),a
ld (#E01C),a
ld a,#3C
ld (#D01A),a
ld (#D837),a
ld (#E822),a
ld (#E833),a
ld a,#4B
ld (#C01F),a
ld (#C02B),a
ld (#C035),a
ld (#C835),a
ld (#D829),a
ld (#D82F),a
ld (#E033),a
ld (#E81C),a
ld a,#5A
ld (#D02A),a
ld (#E828),a
ld (#E82E),a
ld a,#69
ld (#E023),a
ld (#E81D),a
ld a,#78
ld (#D81E),a
ld (#D824),a
ld (#D830),a
ld (#E01A),a
ld (#E02A),a
ld (#E037),a
ld a,#87
ld (#C025),a
ld (#C031),a
ld (#C825),a
ld (#C831),a
ld (#D025),a
ld (#D031),a
ld (#D825),a
ld (#D831),a
ld (#E025),a
ld (#E031),a
ld (#E825),a
ld a,#96
ld (#D823),a
ld (#E831),a
ld a,#A5
ld (#E028),a
ld (#E02E),a
ld a,#B4
ld (#D024),a
ld (#D030),a
ld (#D82A),a
ld (#E01D),a
ld (#E01E),a
ld (#E823),a
ld (#E834),a
ld (#F025),a
ld (#F031),a
ld a,#C3
ld (#C018),a
ld (#C818),a
ld (#C81F),a
ld (#C82B),a
ld (#D018),a
ld (#D01F),a
ld (#D02B),a
ld (#D035),a
ld (#D818),a
ld (#D81F),a
ld (#D82B),a
ld (#D835),a
ld (#E018),a
ld (#E01F),a
ld (#E02B),a
ld (#E035),a
ld (#E81F),a
ld (#E82B),a
ld (#E835),a
ld a,#D2
ld (#E022),a
ld (#E829),a
ld (#E82F),a
ld (#F01F),a
ld (#F02B),a
ld (#F035),a
ld a,#E1
ld (#E818),a
ld (#E819),a
ld a,#F0
ld (#D81A),a
ld (#E024),a
ld (#E030),a
ld (#E81A),a
ld (#E81E),a
ld (#E824),a
ld (#E82A),a
ld (#E830),a
ld (#E837),a
ld (#F01A),a
ld (#F01E),a
ld (#F024),a
ld (#F02A),a
ld (#F030),a

;;;;

ld a,#0F
ld (#C021+#50),a
ld (#C027+#50),a
ld (#C02D+#50),a
ld (#C032+#50),a
ld (#C832+#50),a
ld (#D01B+#50),a
ld (#D020+#50),a
ld (#D026+#50),a
ld (#D02C+#50),a
ld (#D81F+#50),a
ld (#D825+#50),a
ld (#D82B+#50),a
ld (#D835+#50),a
ld (#E01A+#50),a
ld (#E01E+#50),a
ld (#E02A+#50),a
ld (#E034+#50),a
ld a,#1E
ld (#C01C+#50),a
ld (#C036+#50),a
ld (#C821+#50),a
ld (#C827+#50),a
ld (#C82D+#50),a
ld (#C836+#50),a
ld (#D831+#50),a
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E037+#50),a
ld a,#2D
ld (#D032+#50),a
ld (#E01B+#50),a
ld a,#3C
ld (#C81C+#50),a
ld (#D836+#50),a
ld (#E035+#50),a
ld a,#4B
ld (#C019+#50),a
ld (#C033+#50),a
ld (#C819+#50),a
ld (#D82C+#50),a
ld (#E824+#50),a
ld (#E830+#50),a
ld a,#5A
ld (#D02D+#50),a
ld (#D832+#50),a
ld (#E025+#50),a
ld (#E81F+#50),a
ld (#E82B+#50),a
ld (#E835+#50),a
ld a,#69
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E031+#50),a
ld a,#78
ld (#D036+#50),a
ld (#D81C+#50),a
ld (#D821+#50),a
ld (#D827+#50),a
ld (#E02D+#50),a
ld (#E832+#50),a
ld (#E836+#50),a
ld a,#87
ld (#C022+#50),a
ld (#C028+#50),a
ld (#C02E+#50),a
ld (#C818+#50),a
ld (#C822+#50),a
ld (#C828+#50),a
ld (#C82E+#50),a
ld (#D022+#50),a
ld (#D028+#50),a
ld (#D02E+#50),a
ld (#D822+#50),a
ld (#D828+#50),a
ld (#D82E+#50),a
ld (#E022+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E828+#50),a
ld (#E82E+#50),a
ld a,#96
ld (#D820+#50),a
ld (#D826+#50),a
ld (#E018+#50),a
ld (#E822+#50),a
ld a,#A5
ld (#D818+#50),a
ld (#E01F+#50),a
ld (#E02B+#50),a
ld a,#B4
ld (#D021+#50),a
ld (#D027+#50),a
ld (#D82D+#50),a
ld (#E032+#50),a
ld (#E820+#50),a
ld (#E825+#50),a
ld (#E826+#50),a
ld (#E831+#50),a
ld (#F028+#50),a
ld (#F02E+#50),a
ld a,#C3
ld (#C833+#50),a
ld (#D019+#50),a
ld (#D033+#50),a
ld (#D819+#50),a
ld (#D833+#50),a
ld (#E019+#50),a
ld (#E033+#50),a
ld (#E833+#50),a
ld a,#D2
ld (#E81B+#50),a
ld (#E82C+#50),a
ld (#F033+#50),a
ld a,#F0
ld (#D01C+#50),a
ld (#E01C+#50),a
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E036+#50),a
ld (#E81C+#50),a
ld (#E821+#50),a
ld (#E827+#50),a
ld (#E82D+#50),a
ld (#F021+#50),a
ld (#F027+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p4to5
; nowaste valueref 1014

ld a,#0F
ld (#C01A),a
ld (#C01F),a
ld (#C02B),a
ld (#C81A),a
ld (#C824),a
ld (#C830),a
ld (#D01A),a
ld (#D01E),a
ld (#D02A),a
ld (#D034),a
ld (#D829),a
ld (#D82F),a
ld (#E01C),a
ld a,#1E
ld (#C025),a
ld (#C035),a
ld (#C81F),a
ld (#C82B),a
ld (#C835),a
ld (#D024),a
ld (#D030),a
ld (#D037),a
ld (#D823),a
ld (#E028),a
ld (#E02E),a
ld (#E033),a
ld (#E822),a
ld (#E826),a
ld a,#2D
ld (#C031),a
ld (#C831),a
ld (#D824),a
ld (#D830),a
ld (#E019),a
ld (#E022),a
ld (#E833),a
ld a,#3C
ld (#C825),a
ld (#D035),a
ld (#E034),a
ld (#E81D),a
ld a,#4B
ld (#C01B),a
ld (#E01D),a
ld (#E828),a
ld (#E82E),a
ld a,#5A
ld (#D81E),a
ld (#E01A),a
ld (#E029),a
ld (#E02F),a
ld a,#69
ld (#D031),a
ld (#E02A),a
ld a,#78
ld (#D025),a
ld (#D81F),a
ld (#D82B),a
ld (#E035),a
ld (#E823),a
ld (#E824),a
ld (#E830),a
ld (#E837),a
ld (#F026),a
ld a,#87
ld (#C020),a
ld (#C02C),a
ld (#C820),a
ld (#C82C),a
ld (#D020),a
ld (#D02C),a
ld (#D820),a
ld (#D82C),a
ld (#E020),a
ld (#E02C),a
ld (#E82C),a
ld a,#96
ld (#D82A),a
ld a,#A5
ld (#C018),a
ld (#C818),a
ld (#D018),a
ld (#E01E),a
ld (#E023),a
ld a,#B4
ld (#D01F),a
ld (#D02B),a
ld (#D81A),a
ld (#E829),a
ld (#E82A),a
ld (#E82F),a
ld (#F02C),a
ld a,#C3
ld (#C81B),a
ld (#D01B),a
ld (#D81B),a
ld (#E01B),a
ld a,#D2
ld (#E024),a
ld (#E030),a
ld (#E037),a
ld (#E819),a
ld (#E81B),a
ld a,#E1
ld (#D818),a
ld (#D831),a
ld (#E018),a
ld (#E031),a
ld (#E831),a
ld (#E834),a
ld (#F031),a
ld a,#F0
ld (#D825),a
ld (#D835),a
ld (#E01F),a
ld (#E025),a
ld (#E02B),a
ld (#E81F),a
ld (#E825),a
ld (#E82B),a
ld (#E835),a
ld (#F01F),a
ld (#F025),a
ld (#F02B),a
ld (#F035),a

;;;;

ld a,#0F
ld (#C01C+#50),a
ld (#C028+#50),a
ld (#C02E+#50),a
ld (#C033+#50),a
ld (#C036+#50),a
ld (#C81C+#50),a
ld (#C821+#50),a
ld (#C827+#50),a
ld (#C82D+#50),a
ld (#C836+#50),a
ld (#D021+#50),a
ld (#D027+#50),a
ld (#D02D+#50),a
ld (#D032+#50),a
ld (#D036+#50),a
ld (#D81B+#50),a
ld (#D820+#50),a
ld (#D826+#50),a
ld (#D82C+#50),a
ld (#D831+#50),a
ld (#E01F+#50),a
ld (#E024+#50),a
ld (#E02B+#50),a
ld (#E030+#50),a
ld a,#1E
ld (#C019+#50),a
ld (#C022+#50),a
ld (#C828+#50),a
ld (#C82E+#50),a
ld (#C833+#50),a
ld (#D01C+#50),a
ld (#E025+#50),a
ld (#E035+#50),a
ld (#E823+#50),a
ld a,#2D
ld (#C01D+#50),a
ld (#D832+#50),a
ld (#E031+#50),a
ld (#E81F+#50),a
ld (#E824+#50),a
ld (#E82B+#50),a
ld (#E830+#50),a
ld a,#3C
ld (#C819+#50),a
ld (#C822+#50),a
ld (#D019+#50),a
ld (#E01B+#50),a
ld a,#4B
ld (#E825+#50),a
ld a,#5A
ld (#D033+#50),a
ld (#D82D+#50),a
ld (#D836+#50),a
ld (#E01C+#50),a
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E81B+#50),a
ld (#E81E+#50),a
ld (#E82C+#50),a
ld (#E831+#50),a
ld a,#69
ld (#C81D+#50),a
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E832+#50),a
ld a,#78
ld (#D819+#50),a
ld (#D822+#50),a
ld (#D828+#50),a
ld (#D82E+#50),a
ld (#E033+#50),a
ld (#F023+#50),a
ld a,#87
ld (#C029+#50),a
ld (#C02F+#50),a
ld (#C034+#50),a
ld (#C829+#50),a
ld (#C82F+#50),a
ld (#C834+#50),a
ld (#D018+#50),a
ld (#D029+#50),a
ld (#D02F+#50),a
ld (#D034+#50),a
ld (#D829+#50),a
ld (#D82F+#50),a
ld (#D834+#50),a
ld (#E018+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld (#E034+#50),a
ld (#E829+#50),a
ld (#E82F+#50),a
ld (#E834+#50),a
ld a,#96
ld (#C037+#50),a
ld (#C837+#50),a
ld (#D037+#50),a
ld (#D818+#50),a
ld (#D821+#50),a
ld (#D827+#50),a
ld (#D837+#50),a
ld (#E037+#50),a
ld (#E82A+#50),a
ld a,#A5
ld (#D81C+#50),a
ld (#E02C+#50),a
ld (#E02D+#50),a
ld (#E81A+#50),a
ld (#E835+#50),a
ld a,#B4
ld (#D028+#50),a
ld (#D02E+#50),a
ld (#D833+#50),a
ld (#E036+#50),a
ld (#E818+#50),a
ld (#E821+#50),a
ld (#E827+#50),a
ld (#E837+#50),a
ld (#F029+#50),a
ld (#F02F+#50),a
ld a,#D2
ld (#E032+#50),a
ld (#E82D+#50),a
ld a,#E1
ld (#D01D+#50),a
ld (#D81D+#50),a
ld (#E01D+#50),a
ld (#E81D+#50),a
ld a,#F0
ld (#D022+#50),a
ld (#E019+#50),a
ld (#E022+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E819+#50),a
ld (#E822+#50),a
ld (#E828+#50),a
ld (#E82E+#50),a
ld (#E833+#50),a
ld (#F028+#50),a
ld (#F02E+#50),a
ld (#F033+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p5to6
defs 104,0

ld a,#0F
ld (#C025),a
ld (#C031),a
ld (#C035),a
ld (#C81F),a
ld (#C825),a
ld (#C82B),a
ld (#C831),a
ld (#C835),a
ld (#D024),a
ld (#D030),a
ld (#D035),a
ld (#D823),a
ld (#E022),a
ld (#E028),a
ld (#E02E),a
ld (#E033),a
ld (#E82D),a
ld a,#1E
ld (#C01B),a
ld (#C02C),a
ld (#D01F),a
ld (#D02B),a
ld (#D031),a
ld (#D81E),a
ld (#D82A),a
ld (#E019),a
ld (#E01D),a
ld (#E037),a
ld a,#2D
ld (#C020),a
ld (#C026),a
ld (#D025),a
ld (#D81A),a
ld (#D81F),a
ld (#D82B),a
ld (#E029),a
ld (#E02F),a
ld (#E81D),a
ld (#E823),a
ld a,#3C
ld (#C81B),a
ld (#C82C),a
ld a,#4B
ld (#C032),a
ld (#C036),a
ld (#E034),a
ld a,#5A
ld (#D825),a
ld (#E023),a
ld (#E024),a
ld (#E030),a
ld (#E035),a
ld a,#69
ld (#C820),a
ld (#C826),a
ld (#E01E),a
ld a,#78
ld (#D02C),a
ld (#D81B),a
ld (#D831),a
ld (#E81A),a
ld (#E81F),a
ld (#E82A),a
ld (#E82B),a
ld (#F02D),a
ld a,#87
ld (#C018),a
ld (#C818),a
ld a,#96
ld (#E829),a
ld (#E82F),a
ld a,#A5
ld (#D818),a
ld (#E02A),a
ld a,#B4
ld (#D835),a
ld (#E025),a
ld (#E031),a
ld (#E81E),a
ld (#E834),a
ld a,#C3
ld (#C832),a
ld (#C836),a
ld (#D032),a
ld (#D036),a
ld (#D832),a
ld (#D836),a
ld (#E032),a
ld (#E036),a
ld (#E819),a
ld (#E832),a
ld a,#D2
ld (#E01A),a
ld (#E01F),a
ld (#E02B),a
ld a,#E1
ld (#D020),a
ld (#D026),a
ld (#D820),a
ld (#D826),a
ld (#E020),a
ld (#E026),a
ld (#E820),a
ld (#E824),a
ld (#E826),a
ld (#E830),a
ld (#F020),a
ld (#F026),a
ld a,#F0
ld (#D01B),a
ld (#D82C),a
ld (#E01B),a
ld (#E02C),a
ld (#E81B),a
ld (#E82C),a
ld (#E831),a
ld (#E836),a
ld (#F02C),a
ld (#F031),a

;;;;

ld a,#0f
ld (#C019+#50),a
ld (#C01D+#50),a
ld (#C022+#50),a
ld (#C822+#50),a
ld (#C828+#50),a
ld (#C82E+#50),a
ld (#C833+#50),a
ld (#D01C+#50),a
ld (#D832+#50),a
ld (#D836+#50),a
ld (#E01B+#50),a
ld (#E025+#50),a
ld (#E031+#50),a
ld (#E035+#50),a
ld a,#1e
ld (#C029+#50),a
ld (#C02F+#50),a
ld (#C819+#50),a
ld (#C81D+#50),a
ld (#D028+#50),a
ld (#D02E+#50),a
ld (#D033+#50),a
ld (#D819+#50),a
ld (#D821+#50),a
ld (#D827+#50),a
ld (#D82D+#50),a
ld (#E02C+#50),a
ld (#E82A+#50),a
ld a,#2d
ld (#C023+#50),a
ld (#C034+#50),a
ld (#D022+#50),a
ld (#D81C+#50),a
ld (#D828+#50),a
ld (#D82E+#50),a
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E032+#50),a
ld a,#3C
ld (#C829+#50),a
ld (#C82F+#50),a
ld (#E836+#50),a
ld a,#4B
ld (#E02D+#50),a
ld (#E82C+#50),a
ld a,#5A
ld (#C037+#50),a
ld (#C837+#50),a
ld (#D01D+#50),a
ld (#D822+#50),a
ld (#D837+#50),a
ld (#E832+#50),a
ld a,#69
ld (#C823+#50),a
ld (#C834+#50),a
ld (#D034+#50),a
ld (#E81C+#50),a
ld a,#78
ld (#D029+#50),a
ld (#D02F+#50),a
ld (#E01D+#50),a
ld (#E036+#50),a
ld (#E821+#50),a
ld (#E822+#50),a
ld (#E827+#50),a
ld (#E828+#50),a
ld (#E82E+#50),a
ld (#F02A+#50),a
ld a,#87
ld (#C01A+#50),a
ld (#C01E+#50),a
ld (#C81A+#50),a
ld (#C81E+#50),a
ld (#D01A+#50),a
ld (#D01E+#50),a
ld (#D818+#50),a
ld (#D81A+#50),a
ld (#D81E+#50),a
ld (#D833+#50),a
ld (#E01A+#50),a
ld (#E01E+#50),a
ld a,#96
ld (#E018+#50),a
ld (#E81E+#50),a
ld (#E820+#50),a
ld (#E826+#50),a
ld a,#a5
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E818+#50),a
ld a,#b4
ld (#D81D+#50),a
ld (#E022+#50),a
ld (#E82D+#50),a
ld (#E833+#50),a
ld (#F01E+#50),a
ld a,#d2
ld (#D037+#50),a
ld (#E01C+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E037+#50),a
ld a,#e1
ld (#D023+#50),a
ld (#D823+#50),a
ld (#D834+#50),a
ld (#E023+#50),a
ld (#E034+#50),a
ld (#E823+#50),a
ld (#E834+#50),a
ld (#F023+#50),a
ld a,#f0
ld (#D829+#50),a
ld (#D82F+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld (#E81D+#50),a
ld (#E829+#50),a
ld (#E82F+#50),a
ld (#E837+#50),a
ld (#F029+#50),a
ld (#F02F+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p6to7
defs 62,0

ld a,#0F
ld (#C01B),a
ld (#C020),a
ld (#C026),a
ld (#C02C),a
ld (#C81B),a
ld (#C820),a
ld (#C826),a
ld (#C82C),a
ld (#D01F),a
ld (#D025),a
ld (#D02B),a
ld (#D031),a
ld (#D81A),a
ld (#D81E),a
ld (#D824),a
ld (#D82A),a
ld (#D830),a
ld (#E01D),a
ld (#E023),a
ld (#E029),a
ld (#E02F),a
ld a,#1E
ld (#C032),a
ld (#D837),a
ld (#E01E),a
ld (#E034),a
ld a,#2D
ld (#C02D),a
ld (#C036),a
ld (#D02C),a
ld (#D835),a
ld (#E82A),a
ld a,#3C
ld (#C832),a
ld (#D01B),a
ld (#E01A),a
ld (#E037),a
ld a,#4B
ld (#C01C),a
ld (#C021),a
ld (#C027),a
ld (#D825),a
ld a,#5A
ld (#D020),a
ld (#D026),a
ld (#D81B),a
ld (#D82C),a
ld (#D831),a
ld (#E01F),a
ld (#E02A),a
ld (#E02B),a
ld (#E81A),a
ld (#E824),a
ld (#E830),a
ld (#E837),a
ld a,#69
ld (#C82D),a
ld (#C836),a
ld (#D836),a
ld a,#78
ld (#D832),a
ld (#E020),a
ld (#E026),a
ld (#E81B),a
ld (#E835),a
ld a,#87
ld (#C019),a
ld (#C819),a
ld (#D019),a
ld (#D819),a
ld (#E019),a
ld a,#96
ld (#C818),a
ld (#D018),a
ld a,#A5
ld (#E024),a
ld (#E030),a
ld (#E031),a
ld (#E81E),a
ld (#E834),a
ld a,#B4
ld (#D818),a
ld (#D820),a
ld (#D826),a
ld (#E01B),a
ld (#E02C),a
ld a,#C3
ld (#C81C),a
ld (#C821),a
ld (#C827),a
ld (#D01C),a
ld (#D021),a
ld (#D027),a
ld (#D81C),a
ld (#D821),a
ld (#D827),a
ld (#E01C),a
ld (#E021),a
ld (#E027),a
ld (#E81C),a
ld (#E821),a
ld (#E827),a
ld a,#D2
ld (#E018),a
ld (#E035),a
ld (#E825),a
ld (#F021),a
ld (#F027),a
ld a,#E1
ld (#D02D),a
ld (#D036),a
ld (#D82D),a
ld (#E02D),a
ld (#E036),a
ld (#E81F),a
ld (#E82B),a
ld (#E82D),a
ld a,#F0
ld (#D032),a
ld (#E032),a
ld (#E818),a
ld (#E820),a
ld (#E826),a
ld (#E832),a
ld (#F020),a
ld (#F026),a
ld (#F02D),a

;;;;

ld a,#0f
ld (#C023+#50),a
ld (#C029+#50),a
ld (#C02F+#50),a
ld (#C034+#50),a
ld (#C819+#50),a
ld (#C81D+#50),a
ld (#C823+#50),a
ld (#C829+#50),a
ld (#C82F+#50),a
ld (#D022+#50),a
ld (#D028+#50),a
ld (#D02E+#50),a
ld (#D033+#50),a
ld (#D819+#50),a
ld (#D81C+#50),a
ld (#D821+#50),a
ld (#D827+#50),a
ld (#D82D+#50),a
ld (#D833+#50),a
ld (#E020+#50),a
ld (#E026+#50),a
ld (#E02C+#50),a
ld (#E032+#50),a
ld a,#1e
ld (#C834+#50),a
ld (#D019+#50),a
ld (#D01D+#50),a
ld (#E036+#50),a
ld a,#2d
ld (#C01E+#50),a
ld (#C02A+#50),a
ld (#C81E+#50),a
ld (#D029+#50),a
ld (#D02F+#50),a
ld (#E01C+#50),a
ld (#E821+#50),a
ld (#E827+#50),a
ld a,#3c
ld (#C037+#50),a
ld (#C837+#50),a
ld (#D037+#50),a
ld (#D834+#50),a
ld (#E022+#50),a
ld (#E02D+#50),a
ld a,#4b
ld (#C01A+#50),a
ld (#C024+#50),a
ld (#C030+#50),a
ld (#C81A+#50),a
ld (#D822+#50),a
ld (#E832+#50),a
ld a,#5a
ld (#D023+#50),a
ld (#D034+#50),a
ld (#D829+#50),a
ld (#D82F+#50),a
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E81C+#50),a
ld a,#69
ld (#C82A+#50),a
ld (#D01E+#50),a
ld (#E833+#50),a
ld a,#78
ld (#D837+#50),a
ld (#E019+#50),a
ld (#E023+#50),a
ld (#E837+#50),a
ld a,#87
ld (#C035+#50),a
ld (#C835+#50),a
ld (#D035+#50),a
ld (#D81D+#50),a
ld (#D835+#50),a
ld (#E018+#50),a
ld (#E035+#50),a
ld (#E82D+#50),a
ld a,#b4
ld (#D823+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld (#E033+#50),a
ld (#E81D+#50),a
ld a,#c3
ld (#C824+#50),a
ld (#C830+#50),a
ld (#D01A+#50),a
ld (#D024+#50),a
ld (#D030+#50),a
ld (#D81A+#50),a
ld (#D824+#50),a
ld (#D830+#50),a
ld (#E01A+#50),a
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E81A+#50),a
ld (#E824+#50),a
ld (#E830+#50),a
ld a,#d2
ld (#E819+#50),a
ld (#E822+#50),a
ld (#F01A+#50),a
ld (#F024+#50),a
ld (#F030+#50),a
ld a,#e1
ld (#D02A+#50),a
ld (#D81E+#50),a
ld (#D82A+#50),a
ld (#E01E+#50),a
ld (#E02A+#50),a
ld (#E81E+#50),a
ld (#E828+#50),a
ld (#E82A+#50),a
ld (#E82E+#50),a
ld (#F01E+#50),a
ld (#F02A+#50),a
ld a,#f0
ld (#E034+#50),a
ld (#E037+#50),a
ld (#E823+#50),a
ld (#E834+#50),a
ld (#F023+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p7to8
defs 34,0

ld a,#0F
ld (#C021),a
ld (#C027),a
ld (#C02D),a
ld (#C032),a
ld (#C832),a
ld (#D01B),a
ld (#D020),a
ld (#D026),a
ld (#D02C),a
ld (#D81F),a
ld (#D825),a
ld (#D82B),a
ld (#D835),a
ld (#E01A),a
ld (#E01E),a
ld (#E02A),a
ld (#E034),a
ld a,#1E
ld (#C01C),a
ld (#C036),a
ld (#C821),a
ld (#C827),a
ld (#C82D),a
ld (#C836),a
ld (#D831),a
ld (#E024),a
ld (#E030),a
ld (#E037),a
ld a,#2D
ld (#D032),a
ld (#E01B),a
ld a,#3C
ld (#C81C),a
ld (#D836),a
ld (#E035),a
ld a,#4B
ld (#C019),a
ld (#C033),a
ld (#C819),a
ld (#D82C),a
ld (#E824),a
ld (#E830),a
ld a,#5A
ld (#D02D),a
ld (#D832),a
ld (#E025),a
ld (#E81F),a
ld (#E82B),a
ld (#E835),a
ld a,#69
ld (#E020),a
ld (#E026),a
ld (#E031),a
ld a,#78
ld (#D036),a
ld (#D81C),a
ld (#D821),a
ld (#D827),a
ld (#E02D),a
ld (#E832),a
ld (#E836),a
ld a,#87
ld (#C022),a
ld (#C028),a
ld (#C02E),a
ld (#C818),a
ld (#C822),a
ld (#C828),a
ld (#C82E),a
ld (#D022),a
ld (#D028),a
ld (#D02E),a
ld (#D822),a
ld (#D828),a
ld (#D82E),a
ld (#E022),a
ld (#E028),a
ld (#E02E),a
ld (#E828),a
ld (#E82E),a
ld a,#96
ld (#D820),a
ld (#D826),a
ld (#E018),a
ld (#E822),a
ld a,#A5
ld (#D818),a
ld (#E01F),a
ld (#E02B),a
ld a,#B4
ld (#D021),a
ld (#D027),a
ld (#D82D),a
ld (#E032),a
ld (#E820),a
ld (#E825),a
ld (#E826),a
ld (#E831),a
ld (#F028),a
ld (#F02E),a
ld a,#C3
ld (#C833),a
ld (#D019),a
ld (#D033),a
ld (#D819),a
ld (#D833),a
ld (#E019),a
ld (#E033),a
ld (#E833),a
ld a,#D2
ld (#E81B),a
ld (#E82C),a
ld (#F033),a
ld a,#F0
ld (#D01C),a
ld (#E01C),a
ld (#E021),a
ld (#E027),a
ld (#E036),a
ld (#E81C),a
ld (#E821),a
ld (#E827),a
ld (#E82D),a
ld (#F021),a
ld (#F027),a

;;;;

ld a,#0F
ld (#C01E+#50),a
ld (#C024+#50),a
ld (#C02A+#50),a
ld (#C030+#50),a
ld (#C81E+#50),a
ld (#C82A+#50),a
ld (#C834+#50),a
ld (#D019+#50),a
ld (#D01D+#50),a
ld (#D023+#50),a
ld (#D029+#50),a
ld (#D02F+#50),a
ld (#D81D+#50),a
ld (#D822+#50),a
ld (#D828+#50),a
ld (#D82E+#50),a
ld (#D834+#50),a
ld (#E021+#50),a
ld (#E027+#50),a
ld (#E02D+#50),a
ld (#E036+#50),a
ld a,#1E
ld (#C01A+#50),a
ld (#C037+#50),a
ld (#C81A+#50),a
ld (#C824+#50),a
ld (#C830+#50),a
ld (#C837+#50),a
ld (#D01E+#50),a
ld (#D034+#50),a
ld (#E019+#50),a
ld (#E01C+#50),a
ld a,#3C
ld (#D01A+#50),a
ld (#D837+#50),a
ld (#E822+#50),a
ld (#E833+#50),a
ld a,#4B
ld (#C01F+#50),a
ld (#C02B+#50),a
ld (#C035+#50),a
ld (#C835+#50),a
ld (#D829+#50),a
ld (#D82F+#50),a
ld (#E033+#50),a
ld (#E81C+#50),a
ld a,#5A
ld (#D02A+#50),a
ld (#E828+#50),a
ld (#E82E+#50),a
ld a,#69
ld (#E023+#50),a
ld (#E81D+#50),a
ld a,#78
ld (#D81E+#50),a
ld (#D824+#50),a
ld (#D830+#50),a
ld (#E01A+#50),a
ld (#E02A+#50),a
ld (#E037+#50),a
ld a,#87
ld (#C025+#50),a
ld (#C031+#50),a
ld (#C825+#50),a
ld (#C831+#50),a
ld (#D025+#50),a
ld (#D031+#50),a
ld (#D825+#50),a
ld (#D831+#50),a
ld (#E025+#50),a
ld (#E031+#50),a
ld (#E825+#50),a
ld a,#96
ld (#D823+#50),a
ld (#E831+#50),a
ld a,#A5
ld (#E028+#50),a
ld (#E02E+#50),a
ld a,#B4
ld (#D024+#50),a
ld (#D030+#50),a
ld (#D82A+#50),a
ld (#E01D+#50),a
ld (#E01E+#50),a
ld (#E823+#50),a
ld (#E834+#50),a
ld (#F025+#50),a
ld (#F031+#50),a
ld a,#C3
ld (#C018+#50),a
ld (#C818+#50),a
ld (#C81F+#50),a
ld (#C82B+#50),a
ld (#D018+#50),a
ld (#D01F+#50),a
ld (#D02B+#50),a
ld (#D035+#50),a
ld (#D818+#50),a
ld (#D81F+#50),a
ld (#D82B+#50),a
ld (#D835+#50),a
ld (#E018+#50),a
ld (#E01F+#50),a
ld (#E02B+#50),a
ld (#E035+#50),a
ld (#E81F+#50),a
ld (#E82B+#50),a
ld (#E835+#50),a
ld a,#D2
ld (#E022+#50),a
ld (#E829+#50),a
ld (#E82F+#50),a
ld (#F01F+#50),a
ld (#F02B+#50),a
ld (#F035+#50),a
ld a,#E1
ld (#E818+#50),a
ld (#E819+#50),a
ld a,#F0
ld (#D81A+#50),a
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E81A+#50),a
ld (#E81E+#50),a
ld (#E824+#50),a
ld (#E82A+#50),a
ld (#E830+#50),a
ld (#E837+#50),a
ld (#F01A+#50),a
ld (#F01E+#50),a
ld (#F024+#50),a
ld (#F02A+#50),a
ld (#F030+#50),a

ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p8to1
; nowaste valueref 1014

ld a,#0F
ld (#C01C),a
ld (#C028),a
ld (#C02E),a
ld (#C033),a
ld (#C036),a
ld (#C81C),a
ld (#C821),a
ld (#C827),a
ld (#C82D),a
ld (#C836),a
ld (#D021),a
ld (#D027),a
ld (#D02D),a
ld (#D032),a
ld (#D036),a
ld (#D81B),a
ld (#D820),a
ld (#D826),a
ld (#D82C),a
ld (#D831),a
ld (#E01F),a
ld (#E024),a
ld (#E02B),a
ld (#E030),a
ld a,#1E
ld (#C019),a
ld (#C022),a
ld (#C828),a
ld (#C82E),a
ld (#C833),a
ld (#D01C),a
ld (#E025),a
ld (#E035),a
ld (#E823),a
ld a,#2D
ld (#C01D),a
ld (#D832),a
ld (#E031),a
ld (#E81F),a
ld (#E824),a
ld (#E82B),a
ld (#E830),a
ld a,#3C
ld (#C819),a
ld (#C822),a
ld (#D019),a
ld (#E01B),a
ld a,#4B
ld (#E825),a
ld a,#5A
ld (#D033),a
ld (#D82D),a
ld (#D836),a
ld (#E01C),a
ld (#E020),a
ld (#E026),a
ld (#E81B),a
ld (#E81E),a
ld (#E82C),a
ld (#E831),a
ld a,#69
ld (#C81D),a
ld (#E021),a
ld (#E027),a
ld (#E832),a
ld a,#78
ld (#D819),a
ld (#D822),a
ld (#D828),a
ld (#D82E),a
ld (#E033),a
ld (#F023),a
ld a,#87
ld (#C029),a
ld (#C02F),a
ld (#C034),a
ld (#C829),a
ld (#C82F),a
ld (#C834),a
ld (#D018),a
ld (#D029),a
ld (#D02F),a
ld (#D034),a
ld (#D829),a
ld (#D82F),a
ld (#D834),a
ld (#E018),a
ld (#E029),a
ld (#E02F),a
ld (#E034),a
ld (#E829),a
ld (#E82F),a
ld (#E834),a
ld a,#96
ld (#C037),a
ld (#C837),a
ld (#D037),a
ld (#D818),a
ld (#D821),a
ld (#D827),a
ld (#D837),a
ld (#E037),a
ld (#E82A),a
ld a,#A5
ld (#D81C),a
ld (#E02C),a
ld (#E02D),a
ld (#E81A),a
ld (#E835),a
ld a,#B4
ld (#D028),a
ld (#D02E),a
ld (#D833),a
ld (#E036),a
ld (#E818),a
ld (#E821),a
ld (#E827),a
ld (#E837),a
ld (#F029),a
ld (#F02F),a
ld a,#D2
ld (#E032),a
ld (#E82D),a
ld a,#E1
ld (#D01D),a
ld (#D81D),a
ld (#E01D),a
ld (#E81D),a
ld a,#F0
ld (#D022),a
ld (#E019),a
ld (#E022),a
ld (#E028),a
ld (#E02E),a
ld (#E819),a
ld (#E822),a
ld (#E828),a
ld (#E82E),a
ld (#E833),a
ld (#F028),a
ld (#F02E),a
ld (#F033),a

;;;;

ld a,#0F
ld (#C01A+#50),a
ld (#C01F+#50),a
ld (#C02B+#50),a
ld (#C81A+#50),a
ld (#C824+#50),a
ld (#C830+#50),a
ld (#D01A+#50),a
ld (#D01E+#50),a
ld (#D02A+#50),a
ld (#D034+#50),a
ld (#D829+#50),a
ld (#D82F+#50),a
ld (#E01C+#50),a
ld a,#1E
ld (#C025+#50),a
ld (#C035+#50),a
ld (#C81F+#50),a
ld (#C82B+#50),a
ld (#C835+#50),a
ld (#D024+#50),a
ld (#D030+#50),a
ld (#D037+#50),a
ld (#D823+#50),a
ld (#E028+#50),a
ld (#E02E+#50),a
ld (#E033+#50),a
ld (#E822+#50),a
ld (#E826+#50),a
ld a,#2D
ld (#C031+#50),a
ld (#C831+#50),a
ld (#D824+#50),a
ld (#D830+#50),a
ld (#E019+#50),a
ld (#E022+#50),a
ld (#E833+#50),a
ld a,#3C
ld (#C825+#50),a
ld (#D035+#50),a
ld (#E034+#50),a
ld (#E81D+#50),a
ld a,#4B
ld (#C01B+#50),a
ld (#E01D+#50),a
ld (#E828+#50),a
ld (#E82E+#50),a
ld a,#5A
ld (#D81E+#50),a
ld (#E01A+#50),a
ld (#E029+#50),a
ld (#E02F+#50),a
ld a,#69
ld (#D031+#50),a
ld (#E02A+#50),a
ld a,#78
ld (#D025+#50),a
ld (#D81F+#50),a
ld (#D82B+#50),a
ld (#E035+#50),a
ld (#E823+#50),a
ld (#E824+#50),a
ld (#E830+#50),a
ld (#E837+#50),a
ld (#F026+#50),a
ld a,#87
ld (#C020+#50),a
ld (#C02C+#50),a
ld (#C820+#50),a
ld (#C82C+#50),a
ld (#D020+#50),a
ld (#D02C+#50),a
ld (#D820+#50),a
ld (#D82C+#50),a
ld (#E020+#50),a
ld (#E02C+#50),a
ld (#E82C+#50),a
ld a,#96
ld (#D82A+#50),a
ld a,#A5
ld (#C018+#50),a
ld (#C818+#50),a
ld (#D018+#50),a
ld (#E01E+#50),a
ld (#E023+#50),a
ld a,#B4
ld (#D01F+#50),a
ld (#D02B+#50),a
ld (#D81A+#50),a
ld (#E829+#50),a
ld (#E82A+#50),a
ld (#E82F+#50),a
ld (#F02C+#50),a
ld a,#C3
ld (#C81B+#50),a
ld (#D01B+#50),a
ld (#D81B+#50),a
ld (#E01B+#50),a
ld a,#D2
ld (#E024+#50),a
ld (#E030+#50),a
ld (#E037+#50),a
ld (#E819+#50),a
ld (#E81B+#50),a
ld a,#E1
ld (#D818+#50),a
ld (#D831+#50),a
ld (#E018+#50),a
ld (#E031+#50),a
ld (#E831+#50),a
ld (#E834+#50),a
ld (#F031+#50),a
ld a,#F0
ld (#D825+#50),a
ld (#D835+#50),a
ld (#E01F+#50),a
ld (#E025+#50),a
ld (#E02B+#50),a
ld (#E81F+#50),a
ld (#E825+#50),a
ld (#E82B+#50),a
ld (#E835+#50),a
ld (#F01F+#50),a
ld (#F025+#50),a
ld (#F02B+#50),a
ld (#F035+#50),a

ret

;;;;;;;;;;;;; ne reprendre que les 8*2 premières lignes...
;;;;;;;;;;;;; là, il y a l''écran entier...
;;;;;;;;;;;;; Pour conserver ce qui ne change pas dans le delta... (qques octets...)

org #c000
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #1e, #0f, #0f, #0f, #2d, #0f, #0f
db #0f, #0f, #1e, #0f, #0f, #0f, #0f, #0f
db #0f, #87, #0f, #0f, #0f, #0f, #0f, #87
db #0f, #0f, #0f, #0f, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #0f, #69, #0f, #0f
db #0f, #0f, #3c, #0f, #0f, #0f, #0f, #0f
db #1e, #87, #0f, #0f, #0f, #0f, #1e, #87
db #0f, #0f, #0f, #1e, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #3c, #0f, #0f, #1e, #e1, #0f, #0f
db #0f, #0f, #f0, #0f, #0f, #0f, #0f, #0f
db #b4, #87, #0f, #0f, #0f, #0f, #b4, #87
db #0f, #0f, #0f, #5a, #87, #0f, #0f, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #96, #78, #0f, #0f, #a5, #e1, #0f, #0f
db #0f, #96, #78, #0f, #0f, #0f, #0f, #96
db #78, #87, #0f, #0f, #0f, #5a, #78, #87
db #0f, #0f, #2d, #b4, #87, #0f, #5a, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #87, #f0, #0f, #3c, #5a, #e1, #0f, #0f
db #5a, #69, #f0, #0f, #0f, #1e, #5a, #69
db #f0, #87, #0f, #0f, #a5, #a5, #f0, #87
db #0f, #2d, #d2, #78, #87, #1e, #b4, #96
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #b4, #f0, #a5, #5a, #f0, #e1, #5a, #2d
db #b4, #b4, #f0, #1e, #2d, #4b, #b4, #b4
db #f0, #87, #96, #2d, #5a, #d2, #f0, #87
db #2d, #5a, #69, #f0, #87, #a5, #78, #b4
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #78, #f0, #f0, #f0, #f0
db #f0, #b4, #f0, #f0, #f0, #f0, #f0, #b4
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
db #00, #00, #00, #00, #00, #00, #00, #00
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: allez-10-mn-tout-au-plus
  SELECT id INTO tag_uuid FROM tags WHERE name = 'allez-10-mn-tout-au-plus';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 16: square by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'square',
    'Imported from z80Code. Author: gurneyh.',
    'public',
    false,
    false,
    '2021-02-21T09:24:18.759000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '    			org #4000
				run #4000
                di
                ld hl, #c9fb
                ld (#38), hl
                ei

                call init
loop:

                ld b, #f5
.vsync:         in a, (c)
                rra
                jr nc, .vsync

    
                
             
                call updateSquares

                halt
    			jp loop
                
                
                

init:
				ld bc, #bc06
                ld a, 23
                out (c), c
                inc b
                out (c), a

                ld bc, #7f8d
                out (c),c 
          
             	ld hl, palette
                xor a
                ld c, 4
                call setPalette
                
                ld hl, #1054
                ld bc, #7f10
                out (c), h
                out (c), l
                ret


updateSquares:
.frameCounter:  ld a, 0
                inc a
                and 3
                ld (.frameCounter + 1), a
                or a
                ret nz


.offset:
                ld hl, #3000
                ld bc, #bc0c
                out (c), c
                inc b
                out (c), h
                dec b : inc c
               	out (c),c
                inc b
                out (c), l
                
.count1:        ld a, 0
.count2:        ld hl, 0 

                ld hl, #3000
                ld de, (.count2 + 1)
                add hl, de
             	res 2, h
          
                ld (.offset + 1), hl

                ld hl, #c000
                ld de, (.count2 + 1)
         
                add hl, de
				add hl, de
                ld de, 60
                add hl, de                 	
              
                ex hl, de
                
                ld hl, square_ptr
                ld a, (.count1 + 1)
                add a
                ld c, a : ld b, 0 
                add hl, bc
                ld a, (hl)
                inc hl
                ld h, (hl)
                ld l, a
                
                
                ld b, 200
.fillY:         
                push de
repeat 10
                ldi
rend 
                pop de
                
                ld a, d
                add 8
                ld d, a
                and #38
                jr nz, .next
                ld a, e
                add #50
                ld e, a
                ld a, #c0
                adc d
                ld d, a
.next
                djnz .fillY

                ld hl, (.count2 + 1)
				ld de, 5
                add hl, de
                res 2, h
				ld (.count2 + 1), hl
                ld a, (.count1 + 1)

                inc a
   				and 7
                ld (.count1 + 1), a
                ret


setPaletteToBlack:
                ld c, #10
                ld hl, #54
                ld b, #7f
.loop:         
                out (c), h
                out (c), l
                inc h 
                dec c 
                jr nz, .loop
                ret
            
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

palette: db #54, #4b, #54, #4c

square_ptr:
dw square_0
dw square_1
dw square_2
dw square_3
dw square_4
dw square_5
dw square_6
dw square_7


squares:
; Data created with Img2CPC - (c) Retroworks - 2007-2015
; Tile square_0 - 40x200 pixels, 10x200 bytes.
square_0:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #30, #f0, #f0, #f0, #e0, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #30, #f0, #f0, #f0, #e0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #e0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #90, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #10, #e0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #e0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #30, #c0, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #30, #c0, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #c0, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #50, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #d0, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #c0, #00, #80, #00, #00
DEFB #00, #00, #00, #30, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #e0, #00, #00
DEFB #00, #00, #00, #00, #80, #10, #e0, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_1 - 40x200 pixels, 10x200 bytes.
square_1:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #c0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #30, #f0, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #f0, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #70, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #e0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #f0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #f0, #c0, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #30, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #c0, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #50, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #d0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #e0, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #70, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #30, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #e0, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #70, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #30, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #f0, #c0, #00, #00
DEFB #00, #00, #00, #70, #f0, #c0, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #30, #f0, #e0, #00, #00
DEFB #00, #00, #00, #30, #f0, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_2 - 40x200 pixels, 10x200 bytes.
square_2:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #70, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #30, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #e0, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #c0, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #10, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #c0, #00, #00
DEFB #00, #00, #00, #00, #30, #f0, #c0, #40, #00, #00
DEFB #00, #00, #00, #70, #c0, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #f0, #00, #00
DEFB #00, #00, #00, #10, #10, #f0, #e0, #00, #00, #00
DEFB #00, #00, #00, #10, #e0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #f0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #f0, #f0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #f0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #70, #80, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #70, #f0, #80, #40, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #70, #c0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_3 - 40x200 pixels, 10x200 bytes.
square_3:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #50, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #c0, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #30, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #e0, #80, #00, #00
DEFB #00, #00, #00, #00, #10, #e0, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #e0, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #e0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #70, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #70, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #70, #80, #00, #00, #00
DEFB #00, #00, #00, #10, #70, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #30, #f0, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #20, #00, #10, #f0, #e0, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #70, #f0, #80, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #00, #70, #f0, #c0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #30, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #70, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #e0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #30, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #70, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #e0, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #d0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_4 - 40x200 pixels, 10x200 bytes.
square_4:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #50, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #c0, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #d0, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #c0, #00, #80, #00, #00
DEFB #00, #00, #00, #30, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #e0, #00, #00
DEFB #00, #00, #00, #00, #80, #10, #e0, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #30, #f0, #f0, #f0, #e0, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #30, #f0, #f0, #f0, #e0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #b0, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #30, #c0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #30, #c0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #30, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #e0, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #10, #e0, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #e0, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #30, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_5 - 40x200 pixels, 10x200 bytes.
square_5:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #d0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #70, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #30, #80, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #70, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #e0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #10, #c0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #b0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #c0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #f0, #c0, #00, #00
DEFB #00, #00, #00, #70, #f0, #c0, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #30, #f0, #e0, #00, #00
DEFB #00, #00, #00, #30, #f0, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #c0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #30, #f0, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #f0, #80, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #70, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #e0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #f0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #f0, #c0, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #30, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #30, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #30, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_6 - 40x200 pixels, 10x200 bytes.
square_6:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #10, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #70, #80, #00, #00
DEFB #00, #00, #00, #00, #70, #f0, #80, #80, #00, #00
DEFB #00, #00, #00, #70, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #f0, #00, #00
DEFB #00, #00, #00, #00, #80, #f0, #f0, #00, #00, #00
DEFB #00, #00, #00, #00, #f0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #f0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #f0, #f0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #f0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #70, #80, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #70, #f0, #80, #40, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #70, #c0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #70, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #30, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #c0, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #e0, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #c0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #c0, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #30, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

; Tile square_7 - 40x200 pixels, 10x200 bytes.
square_7:
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #e0, #80, #00, #00
DEFB #00, #00, #00, #00, #10, #e0, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #e0, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #e0, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #70, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #70, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #70, #80, #00, #00, #00
DEFB #00, #00, #00, #10, #70, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #30, #f0, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #20, #00, #10, #f0, #e0, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #70, #f0, #80, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #00, #70, #f0, #c0, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #e0, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #90, #e0, #00, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #10, #e0, #00, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #e0, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #70, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #70, #80, #00, #80, #00, #00
DEFB #00, #00, #00, #00, #00, #70, #90, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #70, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #c0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #30, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #c0, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #30, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #c0, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #30, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #20, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #50, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #80, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #10, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #a0, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #40, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #40, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #10, #a0, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #60, #20, #00, #00, #00
DEFB #00, #00, #00, #00, #10, #80, #10, #00, #00, #00
DEFB #00, #00, #00, #00, #60, #00, #10, #00, #00, #00
DEFB #00, #00, #00, #10, #80, #00, #00, #80, #00, #00
DEFB #00, #00, #00, #60, #00, #00, #00, #80, #00, #00
DEFB #00, #00, #10, #80, #00, #00, #00, #40, #00, #00
DEFB #00, #00, #20, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #20, #00, #00
DEFB #00, #00, #10, #00, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #10, #00, #00
DEFB #00, #00, #00, #80, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #80, #00
DEFB #00, #00, #00, #40, #00, #00, #00, #00, #40, #00
DEFB #00, #00, #00, #20, #00, #00, #00, #10, #80, #00
DEFB #00, #00, #00, #10, #00, #00, #00, #60, #00, #00
DEFB #00, #00, #00, #10, #00, #00, #10, #80, #00, #00
DEFB #00, #00, #00, #00, #80, #00, #60, #00, #00, #00
DEFB #00, #00, #00, #00, #80, #10, #80, #00, #00, #00
DEFB #00, #00, #00, #00, #40, #60, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #50, #80, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #20, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00
DEFB #00, #00, #00, #00, #00, #00, #00, #00, #00, #00

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
