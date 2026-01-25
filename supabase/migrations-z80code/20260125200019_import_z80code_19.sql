-- Migration: Import z80code projects batch 19
-- Projects 37 to 38
-- Generated: 2026-01-25T21:43:30.185285

-- Project 37: gen-motif by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'gen-motif',
    'Imported from z80Code. Author: tronic. dessine des trucs...',
    'public',
    false,
    false,
    '2021-10-08T11:54:31.962000'::timestamptz,
    '2021-10-08T13:59:12.296000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; génération d''un motif (symétrie) en fonction du temps écoulé (TIME=vecteur système #bd0d)
; avec une valeur forcée dès le départ/amorçage, en dur (48 en b8b4)
; Sur émulateur (cpcec, winape, autres ?), en fonction de la vitesse à laquelle il tournera
; (càd realtime, 100%, 200%... etc...)
; le motif sera différent du résultat d''un vrai cpc (ou du mode vitesse "normal" de l''émulateur)
; Ceci est absolument inutile et sans intérêt... mais rigolo ^^
; Tronic/GPA

org #1000
run #1000

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

v_origin equ #bbc9 ; x=de et y=hl
v_plot equ #bbea ; x=de et y=hl
v_gpen equ #bbde ; a=couleur
v_pen equ #bb90 ; a=couleur

macro origin
ld de,(org_x)
ld hl,(org_y)
call v_origin
mend

macro plot_v1 x,y,_pen
ld a,{_pen}
call v_gpen
ld de,{x}
ld hl,{y}
call v_plot
mend

ld bc,0
call #bc38

ld a,0
ld bc,0
call #bc32

ld a,0
ld b,0
ld c,0
call #bc32

ld a,1
ld b,24
ld c,24
call #bc32

ld a,2
ld b,20
ld c,20
call #bc32

ld a,3
ld b,02
ld c,02
call #bc32

ld a,1
call #bc0e

;jp dessine

calcul

ei
ld de,table	
        ; table de valeurs de 256 octets...
modif
ld a,48	
        ; valeur au pif (48) forcée dès le départ...

ld (#b8b4),a	
        ; met en dur dans la ram (TIME=vecteur #bd0d)
		; a ces endroits, la valeur change toutes les 300e/s
		; rapide = #b8b4
		; moyen = #b8b5
		; lent = #b8b6
		; escargot = #b8b7

loop
ld a,(#b8b4)	
        ; on la reprend...

        ; on fait nimportenawak
bit 7,a
jp p,hop
add a,h
add a,h
add a,h
add a,h
add a,h
add a,c

hop
ld (de),a	
        ; on la stock dans la table

saut1
ld a,(#b8b4)	
        ; on la reprend...
ld b,a		
        ; bcl tempo...
djnz $

bit 1,a		
        ; on test des bit (au pif)
jr z,saut1	
ld hl,modif+1	
        ; on modifie la valeur initiale (48+1)
inc (hl)
bit 1,a		
        ; on test des bit (au pif)
jr z,saut1

bit 3,a	
        ; on test des bit (au pif)
jr nz,saut2
halt	
        ; tempo (au pif)
saut2

inc e		
ld a,e
or a
jp z,fini
        ; test si arrive en fin de table (256 octets)

jp p,modif
        ; jump test bidon, direction modif a nouveau
jp loop	
        ; on boucle

fini
ld hl,modif+1
inc (hl)	
        ; incremente pour le fun et pour avoir
		; une autre valeur pour le prochain appel

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; dessine...

dessine
        ; on dessine ce qu''on a récolté dans la table...

origin

xor a
ld (valx),a
ld (valx+1),a

pool
ld h,table/256
modif2
ld l,0

ld de,valy
ldi

ld a,l
or a
jr nz,saute666
xor a
ld (modif2+1),a

jp finito

saute666
ld (modif2+1),a

ld hl,(valx)
ld b,h
ld c,l
or a
sbc hl,bc
or a
sbc hl,bc
ld (valx2),hl

ld hl,(valy)
ld b,h
ld c,l
or a
sbc hl,bc
or a
sbc hl,bc
ld (valy2),hl

plot_v1 (valy),(valx),(_pen)

plot_v1 (valy),(valx2),(_pen)

plot_v1 (valy2),(valx2),(_pen)

plot_v1 (valy2),(valx),(_pen)

plot_v1 (valx),(valy),(_pen)

plot_v1 (valx2),(valy2),(_pen)

ld hl,valx
inc (hl)

jp pool

finito
ld a,(_pen)
inc a
cp 4
jr nz,saute
xor a
saute
ld (_pen),a
jp calcul

_pen
db 0
org_x
dw 320
org_y
dw 200
valx
dw 0
valy
dw 0

valx2
dw 0
valy2
dw 0

fuck
align 256
table

_END:',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: dessine-des-trucs
  SELECT id INTO tag_uuid FROM tags WHERE name = 'dessine-des-trucs';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 38: restorefirmware by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'restorefirmware',
    'Imported from z80Code. Author: siko. Restore Firmware',
    'public',
    false,
    false,
    '2020-08-06T17:52:36.033000'::timestamptz,
    '2021-10-09T19:19:40.294000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org #4000
run #4000

 ld sp,#c000

 ld bc,#7f80 | %1001
 out (c),c
 
 exx
 xor a
 ex af,af''

 call #44  ; Restore #00-#40 and 
 call #8bd ; Restore vectors
     
; Other calls made by the ROM
; call #1b5c
; call #1fe9 
; call #0abf
; call #1074
; call #15a8
; call #24bc
; call #07e0

 ld bc,#7f80 | %1101
 out (c),c


 ; Now we can use system vectors 
 ; Tu use #bb06 for example, we need to init KB manager
 call #bb00                
 call #b909 
 call #bb06
 
 ld hl,#8000
 ld de,#c000
 ld bc,#4000
 ldir

 ; now we also can reset 
 rst 0

 jr $




',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rasm
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rasm';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
