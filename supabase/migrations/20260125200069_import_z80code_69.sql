-- Migration: Import z80code projects batch 69
-- Projects 137 to 138
-- Generated: 2026-01-25T21:43:30.203389

-- Project 137: overscan-megatext-intro by matahari
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'overscan-megatext-intro',
    'Imported from z80Code. Author: matahari. https://www.cpcwiki.eu/index.php/256_byte_Overscan_MEGATEXT_Intro_-_(features_50Hz_fullscreen_scroll)',
    'public',
    false,
    false,
    '2021-04-25T13:53:27.511000'::timestamptz,
    '2021-06-18T13:55:54.298000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '

	;---------------------------------------------------------------------
	;	256 byte Overscan MegaText Intro v1.1b
	;	(7DX Demo Party 2011 Release)
	;
	;	for Amstrad 464/664/6128 computers
	;
	;	by matahari - (Dec 24, 2011)
	;
	;	Featuring;
	;	 - Greetings message via 50Hz hardware scroll
	;	 - 100% overscan (full) screen size
	;	 - Complete Amstrad palette (27 colours) on screen at once
	;	 - And, all in 256 bytes!
	;---------------------------------------------------------------------
    ; 
    ; https://www.cpcwiki.eu/index.php/256_byte_Overscan_MEGATEXT_Intro_-_(features_50Hz_fullscreen_scroll)

		LET ADDR_Start 		= #400
		LET ADDR_TextMap		= ADDR_Start + 256

		LET CONST_TotalRasterLines	= 269

		LET VAR_BgrndColour		= ADDR_Start - 1
		LET VAR_FlipFlop		= VAR_BgrndColour - 1
		LET VAR_LineSkipMinus		= CONST_TotalRasterLines * -9
		LET VAR_LineSkipPlus		= CONST_TotalRasterLines * 9

		VAR_XOR			equ 1 xor 0

		run start
		org ADDR_Start
_start

start:	;---------	Generate a dummy interrupt handler ---------------------------

		ld	hl,#c9fb
		ld	(#0038),hl

	;---------	Set CRTC Registers -------------------------------------------

		ld	hl,CRTC_Data
loopCRTC:		ld	a,(hl)
		ld	b,#bc + 1
		outi
		ld	b,#bd + 1
		outi
		inc	a
		jr	nz,loopCRTC

	;---------	Display text message -----------------------------------------

		ld	hl,ADDR_TextMap 
		ld	de,Message

loopText:		push	de
		push	hl
		ld	a,2
		call	#bc0e
		pop	hl
		pop	de

		ld	a,(de)
		cp	255
		jr	z,loopExec

		call	#bb5a

		inc	de
		push	de

	;---------	Grab pixels of displayed char --------------------------------

		ld	de,#c000
		ld	a,8
		ld	c,#40
outer:		ex	af,af''
		ld	iy,vangelis + 1
		ld	(iy),%10000000
		call	Proc_FlipFlop
inner:		call	Proc_FlipFlop
		or	a
		jr	z,bitBckgrndA
		ld	a,#55
		jr	bitBckgrndB
bitBckgrndA:	ld	a,#57
bitBckgrndB:	ld	(VAR_BgrndColour),a
		ld	a,(de)
vangelis:		and	0
		jr	z,blit
		ld	a,c

		;*********************************

blit:		push	hl
		push	de
		push	bc
		ld	de,9
		ld	b,26
blitText:		add	hl,de
		or	a
		jr	z,blitBckgrnd
		ld	(hl),c
		inc	c
		jr	blitSkip

blitBckgrnd:	push	af
		ld	a,(VAR_BgrndColour)
		ld	(hl),a
		pop	af

blitSkip:		djnz	blitText
		pop	bc
		pop	de
		pop	hl

		;*********************************

		inc	hl
		rr	(iy)
		jr	nc,inner

		inc	hl
		
		ld	a,8
		add	a,d
		ld	d,a

		push	bc
		ld	bc,25*9
		add	hl,bc
		pop	bc

		ex	af,af''
		dec	a
		jr	nz,outer

		pop	de
		jr	loopText

	;*********************************************************************
	;	MAIN LOOP - INITIALIZE!
	;*********************************************************************

loopExec:		ld	hl,ADDR_TextMap + VAR_LineSkipPlus

					; Checking VBlanking only for once!
					; Rest of the code will be manually synced
					; via precise t-state calculations.
		ld	b,#f5
waitVBlanking:	in	a,(c)
		rra
		jr	nc,waitVBlanking

		halt
		di

	;---------	X-Pos Alignment ----------------------------------------------

		ld	a,(hl)		; waste time! => 7 cycles
					; Aligns perfect on WinApe.

					; If you need precise
					; alignment on an original Amstrad,
					; you need to comment out this line
					; OR replace it with a NOP!

					; No worries, intro size will not
					; exceed 256 bytes either way ;-)

	;*********************************************************************
	;	MAIN LOOP - BEGIN
	;*********************************************************************

loopBegin:		ld	de,VAR_LineSkipMinus + 9
		add	hl,de

	;---------	Wait for perfect sync! ---------------------------------------

		ld	b,203		; waste time!
waste1:		nop			; waste time!
		add	ix,ix		; waste time!
		djnz	waste1		; waste time!

	;---------	Start Gate Array code ----------------------------------------

		ld	de,CONST_TotalRasterLines
		ld	bc,#7f00
		out	(c),c

crash:		
		inc	b	; Fixes, as outi decreases B first (Siko)
        outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		inc	b
		outi
		

		ld	a,(hl)		; waste time!
		nop			; waste time!

		dec	de
		ld	a,d
		or	e
		jr	nz,crash

	;---------	Raster colour = Black ----------------------------------------

		ld	a,#54
		out	(c),a

		nop			; waste time!
		ld	b,(hl)		; waste time!
		ld	b,224		; waste time!
waste2:		djnz	waste2		; waste time!

loopEnd:		jr	loopBegin

	;*********************************************************************
	;	MAIN LOOP - END
	;*********************************************************************


	;---------	Procedure for Flip/Flop --------------------------------------

Proc_FlipFlop:	ld	a,(VAR_FlipFlop)
		xor	VAR_XOR
		ld	(VAR_FlipFlop),a
		ret

	;---------	CRTC Data ----------------------------------------------------

CRTC_Data:		db	1,54		; set display width
		db	2,50		; set horizontal sync
		db	6,34		; set display height
		db	7,35		; set vertical sync
		db	255		; => EXIT LOOP

Message:		db	''  WELCOME TO 7DX2011 '',255


_end
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: effects
  SELECT id INTO tag_uuid FROM tags WHERE name = 'effects';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 138: init-sys disk by T&J
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'init-sys disk',
    'Imported from z80Code. Author: T&J. http://tj.gpa.free.fr/html/coding/sources.htm',
    'public',
    false,
    false,
    '2022-03-14T15:06:12.005000'::timestamptz,
    '2022-03-14T15:06:12.016000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; http://tj.gpa.free.fr/html/coding/sources.htm
; Initialisation du système disque (Another World), maj du 07/02/2006
; Le Saint-Graal de tout déplombeur CPC ! La routine qui permet de "remettre en service"
; les vecteurs du CPC lorsque la mémoire système a été altérée. Trés utile pour des programmes
; utilisant toute la mémoire du CPC et nécessitant des rechargements avec les vecteurs système. 


; Routine d''initialisation du systeme (c) T#J pour l''article, Amstrad pour la
; -----------------------------------     routines !
; 
; Maj du 23/01/2006 ! La, ca en devient genant, j''ai encore oublie des EXX
; dans le source ! Cette fois-ci, cela devrait tourner correctement...

; Lors de l''AFC Expo 2000, j''ai ete fort surpris de constater qu''il existe
; encore des adeptes du cpc ne connaissant pas le moyen d''initialiser proprement
; le systeme disque du cpc (hello Mr Ghan !).

; Ce genre de routine est utile lorsque l''on veut charger un fichier via
; l''Amsdos apres avoir utilise la memoire habituellement reservee au systeme
; (en gros, de #A67B a #BFFF).

; La technique la plus ''bateau'' consiste a copier ailleurs en ram le contenu de
; ces zones dans une bank memoire supplementaire, puis de les restaurer lorque
; l''on veut retourner au systeme. Cette methode a malheureusement des
; inconvenients : elle est couteuse en ram, non utilisable sur CPC 464 et 664
; sans extension, et parfois (en fonction de ce qui a ete fait avant), ca ne
; marche pas trop bien !

; L''autre methode part d''un principe. Il doit bien exister quelque part dans
; les rom du cpc des routines chargees d''initialiser le systeme (au hasard, le
; RST #0). Il suffit alors de reutiliser ces routines, et le tour est joue !

; Effectivement, si l''on etudie consciencieusement la rom ''inferieure'' (#0000 a
; #3FFF), on trouve a partir de #061F sur un cpc 6128 des routines regenerant
; la zone ram du systeme. Une fois les routines utiles isolees, on peut donc
; creer une routine d''initialisation !

; Les premiers utilisateurs de cette routine ont ete les crackers lorsque
; les editeurs se sont mis a faire des jeux utilisant toute la ram et effectuant
; des rechargements (niveaux). De nos jours (heureux ?), c''est plutot les
; demo-makers qui auraient tendance a avoir besoin des services de ce bout de
; code.

; Passons sans tarder au source de la bete pour un 6128 ou un plus.


        DI   
        LD SP,#C000  ; On remet la pile a sa valeur initiale
;       IM 1         ; on restaure le mode d''interruption standard (pas utile
                     ; la plupart du temps... ).    

        EXX          ; On preserve les registre normaux

        LD BC,#7F88  ; connexion sur ROM inferieure
        OUT (C),C

        EXX

        XOR A        ; utile ?
        EX AF,AF'' 

        CALL #0044   ; Restore ''High Kernel jump'' 
                     ; Init zones ram #0 a #3f, #B900 a #BAE4

        CALL #08BD   ; Restore ''Main Jump adress''
                     ; Init zone ram #BB00 a ?

        CALL #1B5C   ; Init gestion clavier
        CALL #1074   ; Init du ''pack'' texte

        EXX  
        LD BC,#7F8D  ; On deconnecte la rom inferieure
        OUT (C),C    ; et on se met accessoirement en mode 1
        EXX

        EI           ; hop, on n''oublie pas de remettre les interruptions

        LD HL,#ABFF  ; Init classique du systeme disque
        LD DE,#0040  ; via le vecteur Amsdos regenere !
        LD C,#07
        CALL #BCCE

; Seule obligation, tellement evidente qu''on peut l''oublier : la routine ne doit
; pas etre logee dans la zone ram #0000-#3fff (on connecte sur cette page
; memoire la rom !). 

; Cette routine n''est malheureusement pas compatible avec tous les cpc. Les
; 464 et 664 ont des roms un peu differentes. Voici donc un tableau des
; adresses a changer en fonction des modeles :

;        CPC 464           CPC 664           CPC 6128 et +


;        #0888             #08BB             #08BD
;        #19E0             #1B5C             #1B5C
;        #1078             #1070             #1074


; Il suffit alors de poker les adresses correspondant au type de machine avant
; d''utiliser la routine. Mais, comment differencier les modeles de cpc ??
; Grace a leurs rom ! Il faut juste trouver un vecteur cpc different sur chaque
; modele. Celui utilise habituellement est #BD37. Il suffit de tester l''adresse
; #BD38 :

;      CPC 464             CPC 664          CPC 6128

;       #88                 #BB               #BD

; Ca vous rappelle rien ? (cf premiere table !).


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
