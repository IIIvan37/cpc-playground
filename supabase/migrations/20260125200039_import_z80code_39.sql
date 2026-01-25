-- Migration: Import z80code projects batch 39
-- Projects 77 to 78
-- Generated: 2026-01-25T21:43:30.194414

-- Project 77: test by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test',
    'Imported from z80Code. Author: fma.',
    'public',
    false,
    false,
    '2022-01-09T20:41:12.618000'::timestamptz,
    '2022-01-09T23:08:01.523000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'ORG #40


CRTC_SELECT EQU #BC00               

MACRO LOADCRTC register,value
        LD   BC,CRTC_SELECT+{register}
        OUT  (C),C
        INC  B
        LD   A,{value}
        OUT  (C),A
MEND


start
        ; Inhibit RST 38 interrupt vector
        DI
        LD   HL,#C9FB
        LD   (#38),HL
        EI

        LD  SP,#C000

        ; Shift image up
        LOADCRTC 7,34               ; 34 (default 30)

        ; Extend screen vert.
        LOADCRTC 6,32               ; 32 (default 25)

mainLoop
        ; Wait for CRTC vbl
        LD   B,#F5
.waitVbl
        HALT
        IN   A,(C)
        RRA
        JR   NC,.waitVbl

        ; Wait for start of visible zone
REPEAT 32*64
        NOP
REND

        ; Wait for start of screen
REPEAT 5*64+16
        NOP
REND

        LD   B,#7F                  ; Gate Array
        LD   C,16                   ; border

        LD   A,#40+00
        OUT  (C),C                  ; select border
        OUT  (C),A                  ; set border color

        LD   D,201                  ; lines counter (201th line for hud colors)
        LD   HL,table
        LD   B,#7F                  ; Gate Array
        LD   C,16                   ; border
.loop
        OUT  (C),C                  ; select border
        INC  B                      ; correct B
        OUTI                        ; set color pointed by HL

        ; Fine delay
REPEAT 50
        NOP
REND

        DEC  D                      ; decrement line
        JR   NZ,.loop               ; loop on all lines

        ; Wait for end of visible zone
REPEAT 23*64+54                     ; = max working value; we want 54*64+1
        NOP
REND

        OUT  (C),C                  ; select border
        INC  B                      ; correct B
        OUTI                        ; set color pointed by HL

        JP   mainLoop

table
REPEAT 200
        DEFB #40+02                 ; screen color (green)
REND
        DEFB #40+03                 ; hud color (yellow)
        DEFB #40+05                 ; vbl color (red)
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

-- Project 78: triangulart by demoniak
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'triangulart',
    'Imported from z80Code. Author: demoniak. Demo Triangul''Art du groupe Impact',
    'public',
    false,
    false,
    '2021-06-05T18:37:24.407000'::timestamptz,
    '2021-06-18T14:08:40.720000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'TpsWaitImage1	EQU	#7780		; Temps de pause entre chaque images (première partie)

StartCharAscii	EQU	48		; début des caractères ASCII dans la police

	ORG	#38
    DB	#C3					; Nécessaire
    
	ORG	#200
	RUN	$

	DI
	LD	SP,#8000				; Effacer 2 buffers video


; calculer adresse ecran pour chaque ligne
	LD	BC,#C0			; 256 lignes, c=adresse haute a ne pas depasser
 	LD	DE,#8000		; adresse de depart
	LD	HL,TabAdr
CalcAdr:
	LD	(HL),E			; Poids faibles
	INC	H
	LD	(HL),D			; Poids forts
	DEC	H
	INC	HL
	LD	A,D
	ADD	A,8
	LD	D,A
	CP	C
	JR	C,CalcSuite
	PUSH	BC
	LD	BC,#C040
	EX	DE,HL
	ADD	HL,BC
	EX	DE,HL
	POP	BC
CalcSuite:
	DJNZ	CalcAdr
	
; calculer points a afficher en fonction de la couleur
	LD	DE,pen1
	LD	HL,PtMode1C1 
	LD	B,32			; Tableau structure {Point} (32 valeurs)
InitPen:
	CALL	Set3Pen			; Ecriture Masque + premier octet a ecrire
	LD	A,(DE)			; Octet suivant = nbre de pixels a soustraire
	LD	(HL),A
	INC	H
	LD	(HL),A
	INC	H
	LD	(HL),A
	INC	H
	LD	(HL),A
	DEC	H
	DEC	H
	DEC	H
	INC	L
	INC	DE
	CALL	Set3Pen			; Ecriture Masque + dernier octet a ecrire
	INC	L
	INC	L
	INC	L			; 3 valeurs a zeros pour aligner sur 8 octets
	DJNZ	InitPen
	LD	HL,NewIrq
	LD	(#39),HL


;
; Formater ecran en 256x256 pixels, mode 1
;
Debut
	DI
	CALL	Init			; Initialisation de la musique
	EI
	LD	HL,CrtcValues
InitCrtc:
	LD	B,#BD
	OUTI
	LD	B,#BE
	OUTI
	LD	A,(HL)
	AND	A
	JR	NZ,InitCrtc
	LD	HL,Impact
	CALL	SetPalette		; Fond violet
	LD	A,#8D
	OUT	(C),A			; Mode 1
	CALL	CopyAndClearScreen
;
; Debut, premiere image = logo impact
;
	LD	IX,Impact
	LD	A,#C0
	LD	(OffsetVideo+1),A	; Trace de triangles en #C000
	INC	A			; LD	A,#C1
	LD	(LogoBarre),A		; Pause entre la croix et le logo Apple
	LD	A,#FF
	LD	(Glaive),A		; Ne pas afficher le glaive
BoucleNormale
	PUSH	IX
	POP	HL	
	CALL	SetPalette		; Palette de l''image
	LD	A,(HL)
	INC	HL
	LD	(TpsWaitTriangle+1),A	; Temps de pause entre chaque triangles
	PUSH	HL
	CALL	ClearScreen		; Effacer ecran
	LD	BC,#BD30
	OUT	(C),C
	POP	IX
BoucleNorm2
	CALL	DrawImage		; Afficher image
	LD	C,A			; memo octet de fin (pour logo apple barre)
	LD	HL,TpsWaitImage1	; Temps de pause pour affichage image
Wait1
	DEC	HL
	LD	B,16
Wait2
	DJNZ	Wait2
	LD	A,H
	OR	L
	JR	NZ,Wait1		; Boucle pour temps de pause
	LD	A,C			; Recupere octet de fin
	RLA
	JR	NC,Wait3		; Si bit 6=1 => croix sur logo Apple
	DEC	IX				
	JR	BoucleNorm2		; Affichage croix sans effacer ecran
Wait3:
	LD	A,(IX+0)
	INC	A
	JR	NZ,BoucleNormale	; Si pas fin des images, on continue
;
; Message "We want true speed"
;
	XOR	A
	LD	(DoWait+1),A		; ne plus faire de pauses entre chaque triangles
	CALL	CopyAndClearScreen	; Copier ecran en #8000 et effacer #C000
	CALL	WaitVBL
	LD	BC,#BD30
	OUT (C),C
	LD	HL,Message1		; message "WE WANT TRUE SPEED NOW"
	CALL	PrintMess
	LD	B,4
WaitMess1
	XOR	A
	LD	(CntIrq+1),A
WaitMess2
	LD	A,(CntIrq+1)		; Attendre 256 interruptions (a peu pres 0.8 secondes)
	INC	A
	JR	NZ,WaitMess2
	DJNZ	WaitMess1		; Boucler 4 fois (soit 3.2 secondes)
;
; Affichage rapide des images
;
	
	LD	A,1
	LD	(LogoBarre),A		; supprimer la pause de la croix sur le logo pour l''option rapide
	LD	A,"K"
	LD	(Glaive),A		; Afficher le glaive
	LD	IX,Triangle
BoucleRapide
	CALL	CopyAndClearScreen	; Copier ecran en #8000 et basculer video en #8000
	PUSH	IX
	LD	BC,5
	ADD	IX,BC
	CALL	DrawImage		; Afficher l''image en #C000
	CALL	ClearScroll		; Efface image en #8000 et bascule video en #C000
BoucleRapide2
	LD	A,0
	INC	A
	LD	(BoucleRapide2+1),A
	CP	7			; Une fois sur 7, flash de l''ecran
	JR	C,BoucleRapide3
	XOR A				
	LD	(BoucleRapide2+1),A
	LD	HL,PaletteBlack		; Passe l''ecran en noir
	CALL	SetPalette
	CALL	WaitVbl
	CALL	SetPalette		; Passe l''ecran en blanc
	CALL	WaitVbl
	LD	HL,PaletteBlack		; Passe l''ecren en noir
	CALL	SetPalette
BoucleRapide3	
	POP	HL			; Recupere palette de l''image
	CALL	SetPalette
	LD	A,(IX+0)
	INC	A
	JR	NZ,BoucleRapide		; Boucler tant qu''il y a des images

	LD	B,10
WaitForMess:
	PUSH	BC
	CALL	WaitVbl
	POP	BC
	DJNZ	WaitForMess		; Pause pour affichage derniere image
;
; Message de fin...
;
	XOR	A
	LD	(CntVblMess+1),A
	CALL	CopyAndClearScreen
	CALL	WaitVBL
	LD	BC,#BD30
	OUT	(C),C
	LD	HL,Message2
BclEndMess
	CALL	PrintMess		; Affichage page complete
	LD	B,8
WaitReadMess
	XOR	A
	LD	(CntIrq+1),A
WaitReadMess2
	LD	A,(CntIrq+1)
	INC	A
	JR	NZ,WaitReadMess2	
	DJNZ	WaitReadMess		; 8 x 256 IRQ pour le temps de pause (6.8 sec)
	PUSH	HL
	CALL	CopyAndClearScreen
	CALL	ClearScroll
	POP	HL
	INC	HL
	LD	A,(HL)
	INC	A
	JR	NZ,BclEndMess		; Tant qu''il y a des pages a afficher...		
;
; Animation rotation 3D
;
	LD	HL,PalAnim
	CALL	SetPalette
	LD	A,#2E
	LD	BC,#BC02		; Decentrer ecran (anim calculee en 320x200....)
	OUT	(C),C
	INC	B
	OUT	(C),A
	LD	BC,#BC0C
	OUT	(C),C
	LD	HL,0
	LD	(IrqSwapColor+1),HL	; Plus de clignottement de couleurs
	CALL	CopyAndClearScreen
	LD	HL,MessageEnd1		; Message "THE END" en #C000
	CALL	PrintMess
	LD	A,#80
	LD	(OffsetVideo+1),A
	LD	HL,MessageEnd2		; Message "THE END" en #8000
	CALL	PrintMess

	LD	IY,Frame_58		; Avant derniere frame
InitAnim:
	LD	IX,Frame_0		; Premiere frame
BclAnim
	CALL	WaitVbl
MemVideo:
	LD	A,#C0			; Memoire ecran
	LD	(OffsetVideo+1),A
	LD	(OffsetVideoClear+1),A
	XOR	#40			; Swap memoire ecran
	LD	(MemVideo+1),A
	RRA
	RRA
	LD	B,#BD
	OUT	(C),A			; Selection memoire video a afficher
BclClearFrame:
	LD	A,(ZoneYmin+1)
	LD	C,(IY+1)
	CP	C
	JR	C,CalcCoord2
	LD	A,C
	LD	(ZoneYmin+1),A
CalcCoord2:
	LD	A,(ZoneYmax+1)
	LD	L,(IY+5)
	CP	L
	JR	NC,CalcCoord3
	LD	A,L
	LD	(ZoneYmax+1),A
CalcCoord3:
	LD	D,(IY+0)
	LD	A,D
	LD	B,(IY+2)
	CP	B
	JR	NC,CalcCoord4		; si B<D
	LD	D,B			; Sinon on inverse B et D
	LD	B,A
CalcCoord4:
	LD	A,D
	LD	H,(IY+4)
	CP	H
	JR	C,CalcCoord5		; si D<H
	LD	D,H			; sinon on inverse D et H
	LD	H,A
CalcCoord5:
	LD	A,(ZoneXmax+1)
	CP	H
	JR	NC,CalcCoord6
	LD	A,H
	LD	(ZoneXmax+1),A
CalcCoord6:
	LD	A,(ZoneXmin+1)
	CP	B
	JR	C,CalcCoord7
	LD	A,B
	LD	(ZoneXmin+1),A
CalcCoord7:		
	LD	A,(IY+6)
	LD	BC,7
	ADD	IY,BC
	RLA
	JR	NC,BclClearFrame
	XOR	A
	LD	B,A			; Parce que A vaut zero
ZoneXMin:
	LD	A,0
	LD	C,A
	RRA
	AND	A
	RRA
	LD	(OffsetClear+1),A	; X/4 = debut a effacer
ZoneXMax:
	LD	A,0
	SUB	C
	ADD	A,7
	RRA
	AND	A
	RRA
	LD	(BclClearZone+1),A	; Nbre d''octets a effacer
ZoneYMin:
	LD	A,0			; Position y de depart

BclClearZone:
	LD	C,0			; Nbre d''octets a effacer
	LD	L,A			; Reg.L = y
	EX	AF,AF''			; Sauvegarde position Y
	LD	H,TabAdr/256
	LD	A,(HL)			; Poids faible adresse ecran
	INC	H
OffsetClear:
	OR	#F6			; Sera remplacé par #80 ou #C0
	LD	E,A
	LD	A,(HL)			; Poids fort adresse ecran
OffsetVideoClear:
	OR	#C0
	LD	H,A
	LD	L,E			; Reg HL = adresse memoire ecran (x,y)
	LD	(HL),B			; Efface premier octet
	DEC	C			; Si un seul octet a effacer
	JR	Z,FinClear		; Alors on a fini
	LD	D,H
	INC	DE
	LDIR
FinClear:
	EX	AF,AF''			; Recupere position Y
	INC	A
ZoneYMax:
	CP	0			; Y = Ymax ?
	JR	NZ,BclClearZone
	XOR	A			; Mettre les "max" a Zero
	LD	(ZoneYmax+1),A
	LD	(ZoneXmax+1),A
	DEC	A			; Mettre les "min" a 255
	LD	(ZoneYmin+1),A
	LD	(ZoneXmin+1),A
	LD	A,(IY+0)
	INC	A
	JR	NZ,BclDrawFrame
	LD	IY,Frame_0		; Si A=#FF, fin des frames, on recommence
BclDrawFrame:
	CALL	DrawTriangleParam
	LD	A,(IX+6)
	LD	BC,7
	ADD	IX,BC
	RLA
	JR	NC,BclDrawFrame
	LD	A,(IX+0)
	INC	A
	JP	NZ,BclAnim
NbBclAnim:
	LD	A,0
	INC	A
	LD	(NbBclAnim+1),A
	CP	9
	JP	C,InitAnim
	XOR	A
	LD	(NbBclAnim+1),A
	CALL	ClearScreen
	JP	Debut

;
; Fonctions
;
SetPalette
	CALL	WaitVBL
	LD	BC,#7F10
	LD	A,(HL)
	OUT	(C),C
	OUT	(C),A	
	XOR	A
BclPalette
	OUT	(C),A
	INC	B	
	OUTI
	INC	A
	CP	4
	JR	NZ,BclPalette
	RET

CopyAndClearScreen
	LD	HL,#C000
	LD	DE,#8000
	LD	BC,#3FFF
	LDIR
	
ClearScreen
	LD	BC,#BC0C
	OUT	(C),C
	LD	BC,#BD20
	OUT	(C),C
	CALL	WaitVBL
	LD	HL,#C000
	LD	DE,#C001
	LD	BC,#3FFF
	LD	(HL),L
	LDIR
	RET
	
WaitVbl
	LD	B,#F5
	IN	A,(C)
	RRA
	JR	NC,WaitVbl
WaitEndVBL
	IN	A,(C)
	RRA
	JR	C,WaitEndVBL
	RET

ClearScroll
	LD	A,0
	XOR	1			; Une fois scrollV, une fois scrollH
	LD	(ClearScroll+1),A
	JR	Z,ClearScroll2
	CALL	ClearScrollH		; Efface image en #8000 et bascule video en #C000
	JR	ClearScroll3
ClearScroll2
	CALL	ClearScrollV		; Efface image en #8000 et bascule video en #C000
ClearScroll3
	LD	BC,#BC0C
	LD	HL,#3000		; Memoire video en #C000
	OUT	(C),C
	INC	B
	OUT	(C),H
	DEC	B
	INC	C
	OUT	(C),C
	INC	B
	OUT	(C),L
	RET

ClearScrollV:
	LD	HL,#20
	XOR	A
BclClearScrollV:
	PUSH	AF
	PUSH	HL
	LD	E,A
	LD	BC,#BC0C
	OUT	(C),C
	LD	A,H
	OR	#20			; Memoire video en #8000
	INC	B
	OUT	(C),A
	DEC	B
	INC	C
	OUT	(C),C
	INC	B
	OUT	(C),L
	LD	D,8
BclClearScrollV2:
	PUSH	DE
	LD	H,TabAdr/256		; Adresse des poids faibles
	LD	L,E
	LD	E,(HL)
	INC	H			; Adresse des poids forts
	LD	D,(HL)
	LD	H,D
	LD	L,E
	LD	BC,63
	LD	(HL),B			; effacer 64 lignes
	INC DE
	LDIR
	POP	DE
	LD	B,64
BclClearScrollV3:
	DJNZ	BclClearScrollV3
	INC	E
	DEC	D
	JR	NZ,BclClearScrollV2
	POP	HL
	POP	AF
	LD	BC,#20
	ADD	HL,BC
	ADD	A,8
	JR	NZ,BclClearScrollV
	RET
	
ClearScrollH:
	XOR	A
BclClearScrollH:
	PUSH	AF
	LD	BC,#BC0D
	OUT	(C),C
	INC	B
	OUT	(C),A			; Decalage seulement registre 13 crtc
	LD	B,0			; 256 lignes a effacer
	LD	C,A			; C=numero ligne
BclClearScrollH2:
	LD	H,TabAdr/256		; Adresse des poids faibles
	LD	L,B
	LD	E,(HL)
	INC	H			; Adresse des poids forts
	LD	D,(HL)
	EX	DE,HL
	LD	D,0
	LD	A,C
	ADD	A,A
	LD	E,A
	ADD	HL,DE
	LD	(HL),D
	INC	HL
	LD	(HL),D
	DJNZ	BclClearScrollH2
	POP	AF
	INC	A
	CP	32
	JR	NZ,BclClearScrollH
	RET
	
;
; Dessine les triangles d''une image
;
DrawImage
	LD	A,(IX+0)		; Mode de trace
	LD	(ModeDraw+1),A
	INC	IX
BclDrawImage
	XOR	A
	LD	(CntIrq+1),A
	CALL	DrawTriangleParam
ModeDraw
	LD	A,0
	AND	A
	JR	Z,WaitTriangle
	LD	L,255
	LD	A,L
	SUB	(IX+0)
	LD	B,A
	LD	C,(IX+1)
	LD	A,L
	SUB	(IX+2)
	LD	D,A
	LD	E,(IX+3)
	LD	A,L
	SUB	(IX+4)
	LD	H,A
	LD	L,(IX+5)
	CALL	DrawTriangle
DoWait
	LD	A,1
	AND	A
	JR	Z,EndWait	

WaitTriangle
	LD	A,(CntIrq+1)
TpsWaitTriangle
	CP	0
	JR	C,WaitTriangle

EndWait
	LD	A,(IX+6)
	LD	BC,7
	ADD	IX,BC
	RLA
	JR	NC,BclDrawImage
	RET

;----------------------------
;-                          -
;- Fonctions du text-writer -
;-                          -
;----------------------------

;
; Initialise la couleur 
;
PrintMessColor
	INC	HL
	LD	A,(HL)
	PUSH	HL
	CALL	SetTriangleColor
	POP	HL
	INC	HL
	JR	PrintMess

;
; Positionne les coordonnees du message a afficher
;
PrintMessPos
	INC	HL
	LD	A,(HL)
	LD	(PrintMessX+1),A
	INC	HL
	LD	A,(HL)
	LD	(PrintMessY+1),A
	INC	HL
	JR	PrintMess
	
;
; Changement de palette
;
PrintMessPalette
	INC	HL
	CALL	SetPalette
	JR	PrintMess
	
;
; Swap de 2 couleurs pendant le message (Pen 2 & 3)
;
PrintMessSwapInk
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	E,(HL)
	INC	HL
	LD	(IrqSwapColor+1),DE
	JR	PrintMess
	
PrintMessAutoCenter
	INC	HL
	LD	A,(HL)
	LD	(PrintMessY+1),A
	INC	HL
	PUSH	HL
	LD	B,0
PrintMessAutoCenter1
	LD	A,(HL)
	CP	32
	JR	C,PrintMessAutoCenterOk
	EXX
	JR	Z,PrintMessAutoCenterSpace	
	SUB	StartCharAscii
	ADD	A,A
	LD	HL,Alphabet
	LD	C,A
	LD	B,0
	ADD	HL,BC
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	PUSH	DE
	POP	IX
PrintMessAutoCenter2
	LD	A,(IX+6)
	SUB	#80
	JR	NC,PrintMessAutoCenterAdd
	LD	BC,6
	ADD	IX,BC
	JR	PrintMessAutoCenter2
PrintMessAutoCenterSpace:
	LD	A,12
PrintMessAutoCenterAdd
	EXX
	ADD	A,B
	LD	B,A
	INC	HL
	JR	PrintMessAutoCenter1
PrintMessAutoCenterOk:	
	POP	HL
	LD	A,B
	NEG
	SRL	A
	LD	(PrintMessX+1),A
	JR	PrintMess
	
PrintMessSetSwapInk
	INC	HL
	LD	A,(HL)
	LD	(PrintSwapInk+1),A
	INC	HL
;
; Affiche un message avec des lettres en triangle
; HL = adresse du message
; B = posX depart, C = posY depart
;
PrintMess
	LD	A,(HL)
	AND	A
	RET	Z
	DEC	A
	JR	Z,PrintMessColor
	DEC	A
	JR	Z,PrintMessPos
	DEC	A
	JR	Z,PrintMessPalette
	DEC	A
	JR	Z,PrintMessSwapInk
	DEC	A
	JR	Z,PrintMessAutoCenter
	DEC	A
	JR	Z,PrintMessSetSwapInk
	LD	B,12
	LD	A,(HL)
	CP	32
	JR	Z,PrintSpace
	SUB	StartCharAscii
	ADD	A,A
	PUSH	HL
	LD	HL,Alphabet
	LD	C,A
	LD	B,0
	ADD	HL,BC
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	PUSH	DE
	POP	IX
PrintSwapInk:
	LD	A,0
	AND	A
	JR	Z,PrintMessX
	XOR	1
	LD	(PrintSwapInk+1),A
	CALL	SetTriangleColor
PrintMessX
	LD	B,0			; Position X
PrintMessY
	LD	C,0			; Position Y
	LD	H,(IX+2)		; X2
	LD	L,(IX+3)		; Y2
	ADD	HL,BC
	EX	DE,HL
	LD	H,(IX+4)		; X3
	LD	L,(IX+5)		; Y3
	ADD	HL,BC
	LD	A,(IX+0)		; X1
	ADD	A,B
	LD	B,A	
	LD	A,(IX+1)		; Y1
	ADD	A,C
	LD	C,A	
	CALL	DrawTriangle
	LD	A,(IX+6)
	LD	BC,6
	ADD	IX,BC
	LD	A,(IX+0)
	BIT	7,A
	JR	Z,PrintMessX
	AND	#3F
	LD	B,A			; Largeur lettre
	POP	HL
PrintSpace
	INC	HL
	LD	A,(PrintMessX+1)
	ADD	A,B
	LD	(PrintMessX+1),A
	JR	PrintMess

;
; Initialise la couleur du trace du triangle
;
SetTriangleColor
	AND	3
	ADD	A,PtMode1C1/256
	LD	(DrawLigneCoul+1),A
	LD	(DrawLigneCoul3+1),A
	LD	H,A
	LD	L,#61
	LD	A,(HL)
	LD	(DrawLigneCoul2+1),A	; Initialisation couleur du triangle
	RET

DrawTriangleParam:
	LD	A,(IX+6)		; Couleur
	CALL	SetTriangleColor	
	LD	B,(IX+0)		; X1
	LD	C,(IX+1)		; Y1
	LD	D,(IX+2)		; X2
	LD	E,(IX+3)		; Y2
	LD	H,(IX+4)		; X3
	LD	L,(IX+5)		; Y3
;
; Dessine un triangle - (B=X1 C=Y1), (D=X2 E=Y2), (H=X3 L=Y3)
;
DrawTriangle
	LD	A,H
	SUB	B
	JR	C,SetDx1Neg
	LD	(DX1+1),A
	LD	A,#04			; INC B
	JR	SetSgn1
SetDx1Neg:
	NEG
	LD	(DX1+1),A
	LD	A,#05			; DEC B
SetSgn1:
	LD	(Sgn1),A
	LD	A,H
	SUB	D
	JR	C,SetDx3Neg
	LD	(DX3+1),A
	LD	A,#0C			; INC C
	JR	SetSgn3
SetDx3Neg:
	NEG
	LD	(DX3+1),A
	LD	A,#0D			; DEC C
SetSgn3:
	LD	(Sgn3+1),A
	LD	A,L
	LD	(Ymax+1),A
	SUB	C
	LD	H,A			; Reg.H = DY1
	LD	A,L
	SUB	E
	LD	(DY3+1),A
	LD	A,E
	LD	(Y2+1),A
	SUB	C
	LD	L,A			; Reg.L = DY2
	LD	A,D
	SUB	B
	JR	C,SetDx2Neg
	LD	(DX2+1),A
	LD	A,#0C			; INC C
	JR	SetSgn2
SetDx2Neg:
	NEG
	LD	(DX2+1),A
	LD	A,#0D			; DEC C
SetSgn2:
	LD	(Sgn2),A
	LD	A,C			; Y de depart = Reg.C
	CP	E
	LD	C,D
	LD	DE,0			; Reg.D = Err2, Reg.E = Err1
	JR	Z,BclDrawTriangle
	LD	C,B
;
; Boucle principale du remplissage du triangle
; on trace des lignes horizontales du haut vers le bas
; Reg.A = y
; Reg.B = x1
; Reg.C = x2
;
BclDrawTriangle:
	PUSH	BC
	EXX
	POP	BC
	LD	L,A			; Reg.L = y
	EX	AF,AF''
	LD	A,B			; x
	CP	C
	JR	Z,LigneVide		; Si B = C, rien a faire
	JR	C,DrawLigneCoordOk	; Si B < C, ok
	LD	B,C			; Sinon on inverse
	LD	C,A
	LD	A,B			; x
DrawLigneCoordOk:
	LD	H,TabAdr/256		; Adresse des poids faibles
	AND	A
	RRA
	AND	A
	RRA				; x/4
	ADD	A,(HL)
	LD	E,A
	INC	H			; Adresse des poids forts
	LD	A,(HL)			; Reg.DE = adresse memoire ecran (0,y)
OffsetVideo
	OR	#F6			; Sera remplacé par #80 ou #C0
	LD	D,A
	
	LD	A,B			; x
	AND	3
	LD	L,A			; Reg.L = position fine x (0 a 3)
	LD	A,C			; xfin
	SUB	B
	LD	B,A			; Reg.B = nbre de points en x
	DEC	A
	CP	7
	JR	C,DrawLigneOk
	OR	4
	AND	7
DrawLigneOk:
	RLCA
	RLCA
	OR	L
	RLCA
	RLCA
	RLCA				; 8 octets par structure
	LD	L,A
DrawLigneCoul:
	LD	H,PtMode1C1/256
	LD	A,(DE)			; Octet memoire ecran
	AND	(HL)			; Masque
	INC	L
	OR	(HL)			; Premier octet
	LD	(DE),A
	INC	L
	INC	DE
	LD	A,B			; Nbre de points
	SUB	(HL)			; Nbre de points a soustraire
	JR	C,DrawLigneFin
	INC	A
	RRA
	AND	A
	RRA
	LD	C,A
DrawLigneCoul2:
	LD	A,#3E			; Octet du milieu (4 pixels allumes)
	LD	(DE),A
	LD	H,D
	LD	A,L
	LD	L,E
	INC	DE
	DEC	C
	JR	Z,DrawLigneCoul3
	LD	B,0
	LDIR
DrawLigneCoul3:
	LD	H,PtMode1C1/256
	LD	L,A

DrawLigneFin:
	INC	L
	LD	A,(DE)			; Octet memoire ecran
	AND	(HL)			; Masque
	INC	L
	OR	(HL)			; Dernier octet
	LD	(DE),A
LigneVide:
	EXX
;
; Fin trace de ligne
;
	LD	A,E			; Err1
DX1:
	ADD	A,0			; Err1=Err1+Dx1
	JR	C,ForceErr1
DY1:
	CP	H
	JR	C,SetErr1		; Si Err1<Dy1, arret de la boucle
ForceErr1:
	SUB	H			; - DY1
SGN1:
	INC	B			; OU DEC B (B=xl)
	JR	DY1
SetErr1:
	LD	E,A			; Sauvegarde Err1
	EX	AF,AF''			; Recupere ordonnee de la ligne en cours (Y)
Y2:
	CP	0			; Y==E ?
	JR	Z,SetErr3		; Il est moins couteux en tps de faire
					; un saut conditionnel dont la condition
					; arrive peu frequement (ici le JR Z ne
					; peut arriver qu''une seule fois)
	EX	AF,AF''			; Re-sauvegarde Y
	LD	A,D			; Err2
DX2:
	ADD	A,0
	JR	C,ForceErr2
DY2:
	CP	L
	JR	C,SetErr2
ForceErr2:
	SUB	L			; -DY2
SGN2:
	INC	C			; OU DEC C(C=xr)
	JR	DY2
SetErr2:
	LD	D,A
	EX	AF,AF''			; Recupere ordonee de la ligne en cours
	INC	A
Ymax:
	CP	0			; Arrive en bas ?
	JP	C,BclDrawTriangle
	JR	FinTriangle
;
; Parametres pour tracer le deuxieme triangle
;
SetErr3:
	EX	AF,AF''
DX3:
	LD	A,0
	LD	(DX2+1),A
Sgn3:
	LD	A,0
	LD	(Sgn2),A
DY3:
	LD	L,0
	XOR	A
	LD	D,A
	JR	DX2
FinTriangle:	
	RET	

;
; Creation donnees pixels couleurs trace ligne mode 1
;
Set3Pen:
	LD	A,(DE)			; Point en Pen 1
	LD	C,A
	RRCA
	RRCA
	RRCA
	RRCA
	OR	C
	CPL				; Creation du masque
	LD	(HL),A
	INC	H
	LD	(HL),A
	INC	H
	LD	(HL),A
	INC	H
	LD	(HL),A			; Stockage du masque pour les 3 pens
	DEC	H
	DEC	H
	DEC	H
	INC	L
	LD	(HL),0			; Pen 0
	INC	H
	LD	(HL),C			; Pen 1
	INC	H
	LD	A,C
	RRCA
	RRCA
	RRCA
	RRCA
	LD	(HL),A			; Pen 2
	INC	H
	OR	C
	LD	(HL),A			; Pen 3
	DEC	H
	DEC	H
	DEC	H
	INC	L
	INC	DE
	RET
	
;
; IRQ
;
NewIrq
	PUSH	AF
	PUSH	BC
	PUSH	DE
	LD	B,#F5
	IN	A,(C)
	RRA
	JR	NC,CntIrq

	PUSH	HL
	PUSH	IX
	EX	AF,AF''
	PUSH	AF
	CALL	Play			; Jouer la musique sur detection VBL
	POP	AF
	EX	AF,AF''
	POP	IX
	POP	HL
	
IrqSwapColor:	
	LD	DE,0
	LD	A,D
	XOR	E
	AND	A			; Si demande swap couleur
	JR	Z,CntIrq
CntVblMess:
	LD	A,0
	INC	A
	LD	(CntVblMess+1),A
	CP	20			; Attendre 20 VBL
	JR	C,CntIrq
	XOR	A
	LD	(CntVblMess+1),A
	LD	BC,#7F02		; Swap PEN 2 et PEN 3
	OUT	(C),C
	OUT	(C),D
	INC	C
	OUT	(C),C
	OUT	(C),E
	LD	A,D
	LD	D,E
	LD	E,A
	LD	(IrqSwapColor+1),DE
	
CntIrq
	LD	A,0
	INC	A
	LD	(CntIrq+1),A		; Compter les IRQ
	POP	DE
	POP	BC
	POP	AF
	EI
	RET

PaletteBlack
	DB	84,84,84,84
;PaletteWhite
	DB	75,75,75,75
PalAnim
	DB	84,85,87,83

; Généré par TriangulArt le 08/05/2021 (18 13 34)
Impact
	DB	88,77,79,67
	DB	#04			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#4E,#17,#03,#26,#03,#2F,#03
	DB	#4E,#14,#4E,#17,#03,#26,#03
	DB	#32,#20,#22,#25,#2A,#6D,#03
	DB	#22,#25,#2A,#6D,#25,#6F,#03
	DB	#54,#56,#56,#5C,#03,#79,#03
	DB	#56,#5C,#03,#79,#06,#AD,#03
	DB	#3C,#31,#44,#59,#39,#5D,#03
	DB	#4B,#1E,#3C,#31,#44,#59,#03
	DB	#69,#07,#5C,#10,#5C,#30,#03
	DB	#69,#07,#5C,#30,#60,#86,#03
	DB	#6E,#14,#74,#49,#6B,#4D,#03
	DB	#75,#0D,#6E,#14,#74,#49,#03
	DB	#96,#05,#75,#0D,#96,#12,#03
	DB	#75,#0D,#96,#12,#75,#1E,#03
	DB	#96,#12,#96,#26,#8E,#2B,#03
	DB	#96,#12,#8C,#14,#8E,#2B,#03
	DB	#8E,#23,#74,#2D,#74,#3B,#03
	DB	#8E,#23,#8E,#2B,#74,#3B,#03
	DB	#A9,#02,#92,#70,#84,#70,#03
	DB	#A9,#02,#A4,#04,#84,#70,#03
	DB	#9E,#34,#B8,#37,#9C,#3F,#03
	DB	#B7,#28,#9E,#34,#B8,#37,#03
	DB	#A8,#04,#B6,#06,#A7,#0B,#03
	DB	#B6,#01,#A8,#04,#A7,#0B,#03
	DB	#B0,#02,#B8,#89,#C6,#92,#03
	DB	#B5,#01,#B0,#02,#C6,#92,#03
	DB	#D2,#00,#B8,#02,#D6,#0A,#03
	DB	#B8,#02,#D6,#0A,#B9,#0D,#03
	DB	#B9,#0D,#C4,#65,#D3,#75,#03
	DB	#BD,#0B,#B9,#0D,#D3,#75,#03
	DB	#DE,#5B,#CE,#62,#E5,#6B,#03
	DB	#CE,#62,#E5,#6B,#D1,#74,#03
	DB	#FF,#00,#D8,#02,#FF,#0E,#03
	DB	#D8,#00,#FF,#0E,#C9,#24,#03
	DB	#E3,#19,#E0,#58,#F7,#8D,#03
	DB	#EE,#12,#E3,#19,#F7,#8D,#03
	DB	#4B,#1E,#48,#30,#52,#38,#03
	DB	#52,#1A,#4B,#1F,#52,#38,#03
	DB	#51,#1B,#5C,#24,#52,#36,#03
	DB	#5C,#0F,#51,#1B,#5C,#24,#03
	DB	#A7,#7F,#7D,#8F,#9A,#D3,#02
	DB	#7D,#8F,#9A,#D3,#8B,#DB,#02
	DB	#A3,#DA,#88,#E7,#AB,#F3,#02
	DB	#88,#E7,#AB,#F3,#88,#F8,#02
	DB	#AE,#6F,#A7,#7F,#7D,#90,#01
	DB	#AE,#6F,#83,#81,#7D,#90,#01
	DB	#AE,#6F,#9F,#D0,#9A,#D3,#01
	DB	#AE,#6F,#A7,#7F,#9A,#D3,#01
	DB	#A6,#D1,#8C,#DE,#88,#E7,#01
	DB	#A6,#D1,#A3,#DA,#88,#E7,#01
	DB	#A3,#DA,#AF,#EE,#AB,#F3,#01
	DB	#A6,#D1,#A3,#DA,#AF,#EE,#81
; Taille 364 octets
;Triangulart
	DB	''XCSL''
	DB	#16			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#0B,#4D,#29,#4D,#06,#57,#01
	DB	#29,#4D,#24,#57,#06,#57,#01
	DB	#10,#57,#1A,#57,#01,#75,#01
	DB	#1A,#57,#0B,#75,#01,#75,#01
	DB	#1C,#61,#12,#75,#17,#75,#01
	DB	#1C,#61,#21,#61,#17,#75,#01
	DB	#21,#61,#2E,#61,#1E,#66,#01
	DB	#2E,#61,#2B,#66,#1B,#66,#01
	DB	#33,#61,#29,#75,#2E,#75,#01
	DB	#33,#61,#38,#61,#2E,#75,#01
	DB	#38,#57,#3D,#57,#35,#5C,#01
	DB	#3D,#57,#3A,#5C,#35,#5C,#01
	DB	#3D,#61,#35,#70,#3A,#70,#01
	DB	#3D,#61,#3F,#66,#3A,#70,#01
	DB	#3D,#61,#47,#61,#3F,#66,#01
	DB	#47,#61,#49,#66,#3F,#66,#01
	DB	#44,#66,#49,#66,#44,#70,#01
	DB	#49,#66,#44,#70,#49,#70,#01
	DB	#4C,#61,#49,#66,#49,#70,#01
	DB	#4C,#61,#51,#61,#49,#70,#01
	DB	#35,#70,#4E,#70,#38,#75,#01
	DB	#4E,#70,#4C,#75,#38,#75,#01
	DB	#5B,#61,#51,#75,#56,#75,#01
	DB	#5B,#61,#60,#61,#56,#75,#01
	DB	#60,#61,#5D,#66,#67,#66,#01
	DB	#60,#61,#6A,#61,#67,#66,#01
	DB	#6A,#61,#6C,#66,#67,#66,#01
	DB	#6C,#66,#67,#66,#60,#75,#01
	DB	#6C,#66,#65,#75,#60,#75,#01
	DB	#7B,#70,#79,#75,#6F,#75,#01
	DB	#7B,#70,#71,#70,#6F,#75,#01
	DB	#74,#61,#6C,#70,#6F,#75,#01
	DB	#74,#61,#76,#66,#6F,#75,#01
	DB	#74,#61,#76,#66,#85,#66,#01
	DB	#74,#61,#83,#61,#85,#66,#01
	DB	#80,#66,#85,#66,#76,#7A,#01
	DB	#85,#66,#7B,#7A,#76,#7A,#01
	DB	#71,#7A,#7B,#7A,#6F,#7F,#01
	DB	#7B,#7A,#79,#7F,#6F,#7F,#01
	DB	#8D,#61,#92,#61,#85,#70,#01
	DB	#92,#61,#8A,#70,#85,#70,#01
	DB	#85,#70,#94,#70,#88,#75,#01
	DB	#94,#70,#92,#75,#88,#75,#01
	DB	#9C,#61,#97,#75,#92,#75,#01
	DB	#9C,#61,#A1,#61,#97,#75,#01
	DB	#AB,#57,#9E,#70,#A3,#70,#01
	DB	#AB,#57,#B0,#57,#A3,#70,#01
	DB	#9E,#70,#A8,#70,#9C,#75,#01
	DB	#A8,#70,#A6,#75,#9C,#75,#01
	DB	#B5,#57,#B0,#61,#B5,#61,#01
	DB	#B5,#57,#BA,#57,#B5,#61,#01
	DB	#C9,#4D,#AB,#75,#C9,#75,#01
	DB	#C9,#4D,#D3,#4D,#C9,#75,#01
	DB	#C7,#5C,#C1,#75,#B5,#75,#00
	DB	#D8,#61,#CE,#75,#D3,#75,#01
	DB	#D8,#61,#DD,#61,#D3,#75,#01
	DB	#DD,#61,#E9,#61,#DA,#66,#01
	DB	#E9,#61,#E7,#66,#DA,#66,#01
	DB	#F6,#57,#FB,#57,#F9,#5C,#01
	DB	#F6,#57,#F4,#5C,#F9,#5C,#01
	DB	#EF,#5C,#FE,#5C,#EC,#61,#01
	DB	#FE,#5C,#FB,#61,#EC,#61,#01
	DB	#F1,#61,#F6,#61,#EA,#70,#01
	DB	#F6,#61,#EF,#70,#EA,#70,#01
	DB	#EA,#70,#F4,#70,#EC,#75,#01
	DB	#F4,#70,#F1,#75,#EC,#75,#81
; Taille 462 octets

Triangle
	DB	''T'',92,''LN''
	DB	#16			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#28,#00,#00,#14,#F0,#64,#01
	DB	#00,#14,#A0,#64,#F0,#64,#01
	DB	#00,#14,#A0,#64,#78,#78,#02
	DB	#00,#14,#28,#50,#78,#78,#02
	DB	#00,#14,#00,#DC,#28,#F0,#02
	DB	#00,#14,#28,#50,#28,#F0,#02
	DB	#28,#50,#50,#64,#28,#F0,#03
	DB	#50,#64,#50,#B4,#28,#F0,#03
	DB	#F0,#64,#50,#B4,#28,#F0,#03
	DB	#F0,#64,#F0,#8C,#28,#F0,#03
	DB	#A0,#64,#F0,#64,#50,#8C,#01
	DB	#F0,#64,#50,#8C,#50,#B4,#81
; Taille 84 octets
;TriTriangle
	DB	''TNL'',92
	DB	#07			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#55,#00,#69,#00,#00,#AA,#01
	DB	#69,#00,#1E,#96,#00,#AA,#01
	DB	#1E,#96,#96,#AA,#00,#AA,#01
	DB	#1E,#96,#8C,#96,#96,#AA,#01
	DB	#91,#00,#5A,#96,#46,#96,#01
	DB	#91,#00,#A5,#00,#5A,#96,#01
	DB	#B4,#96,#C8,#96,#BE,#AA,#01
	DB	#C8,#96,#D2,#AA,#BE,#AA,#01
	DB	#32,#BE,#28,#D2,#3C,#D2,#01
	DB	#32,#BE,#46,#BE,#3C,#D2,#01
	DB	#28,#D2,#AA,#D2,#1E,#E6,#01
	DB	#AA,#D2,#B4,#E6,#1E,#E6,#01
	DB	#69,#28,#5F,#3C,#69,#50,#02
	DB	#69,#28,#73,#3C,#69,#50,#02
	DB	#A5,#28,#9B,#3C,#F0,#BE,#02
	DB	#9B,#3C,#D2,#AA,#F0,#BE,#02
	DB	#D2,#AA,#C8,#BE,#F0,#BE,#02
	DB	#D2,#AA,#BE,#AA,#C8,#BE,#02
	DB	#87,#64,#7D,#78,#D2,#FA,#02
	DB	#7D,#78,#B4,#E6,#D2,#FA,#02
	DB	#B4,#E6,#28,#FA,#D2,#FA,#02
	DB	#B4,#E6,#1E,#E6,#28,#FA,#02
	DB	#00,#AA,#0A,#BE,#A0,#BE,#02
	DB	#00,#AA,#96,#AA,#A0,#BE,#02
	DB	#69,#00,#69,#28,#32,#96,#03
	DB	#69,#00,#1E,#96,#32,#96,#03
	DB	#69,#00,#69,#28,#73,#3C,#03
	DB	#69,#00,#7D,#28,#73,#3C,#03
	DB	#A5,#00,#6E,#96,#5A,#96,#03
	DB	#A5,#00,#A5,#28,#6E,#96,#03
	DB	#A5,#00,#A5,#28,#F0,#BE,#03
	DB	#A5,#00,#FA,#AA,#F0,#BE,#03
	DB	#91,#50,#87,#64,#D2,#FA,#03
	DB	#91,#50,#DC,#E6,#D2,#FA,#03
	DB	#46,#BE,#5A,#BE,#3C,#D2,#03
	DB	#5A,#BE,#50,#D2,#3C,#D2,#83
; Taille 252 octets
;Pyramide
	DB	'']C^N''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#C6,#9D,#2B,#A5,#2B,#B0,#01
	DB	#C6,#9D,#C6,#A7,#2B,#B0,#01
	DB	#85,#14,#D0,#99,#C7,#9C,#01
	DB	#91,#14,#85,#16,#D0,#99,#01
	DB	#91,#0D,#91,#14,#85,#16,#02
	DB	#91,#0D,#91,#14,#D0,#99,#02
	DB	#91,#14,#D1,#96,#D0,#99,#02
	DB	#79,#17,#1B,#A2,#26,#A8,#01
	DB	#CB,#A0,#B8,#DA,#AF,#DB,#01
	DB	#79,#17,#82,#1D,#26,#A8,#01
	DB	#D1,#A0,#CB,#A0,#B8,#DA,#01
	DB	#B8,#DA,#AF,#DB,#AF,#E7,#01
	DB	#B8,#DA,#B9,#E7,#AF,#E7,#01
	DB	#D1,#9F,#B8,#DA,#B9,#E7,#02
	DB	#D1,#9F,#D1,#A7,#B9,#E7,#02
	DB	#27,#AA,#1F,#AE,#A7,#E4,#01
	DB	#1F,#AE,#A7,#E4,#A1,#E9,#01
	DB	#A7,#E4,#A1,#E9,#A1,#F4,#01
	DB	#A7,#E4,#A7,#EE,#A1,#F4,#01
	DB	#1F,#AE,#A1,#E9,#A1,#F4,#02
	DB	#1F,#AE,#1F,#B8,#A1,#F4,#02
	DB	#90,#14,#83,#16,#A6,#E1,#01
	DB	#90,#14,#B2,#DF,#A6,#E1,#01
	DB	#90,#14,#B4,#D1,#B2,#DF,#02
	DB	#90,#14,#94,#1A,#B4,#D1,#82
; Taille 175 octets
;Pyramides
	DB	''KJLN''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#CF,#5A,#98,#AC,#E7,#C3,#03
	DB	#CF,#5A,#FE,#9A,#E7,#C3,#01
	DB	#3A,#73,#01,#C4,#52,#DC,#03
	DB	#3A,#73,#69,#B2,#52,#DC,#01
	DB	#55,#6C,#A5,#85,#6B,#D4,#03
	DB	#A5,#85,#D3,#C2,#6B,#D4,#01
	DB	#BD,#5B,#A5,#85,#D3,#C2,#01
	DB	#BD,#5B,#54,#6C,#A5,#85,#02
	DB	#A5,#85,#A6,#85,#D3,#C2,#03
	DB	#8C,#00,#53,#51,#A5,#69,#03
	DB	#8C,#00,#BB,#40,#A5,#69,#01
	DB	#AE,#97,#75,#E6,#C6,#FF,#03
	DB	#AE,#97,#DD,#D5,#C6,#FF,#01
	DB	#AE,#97,#DD,#D5,#DE,#D5,#03
	DB	#AE,#97,#AE,#98,#DD,#D5,#83
; Taille 105 octets
;Tricubes
	DB	''@SUD''
	DB	#06			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#C4,#69,#9E,#69,#89,#8B,#03
	DB	#C4,#69,#89,#8B,#B1,#8B,#03
	DB	#A6,#78,#91,#9B,#A6,#BD,#01
	DB	#A6,#78,#BB,#9B,#A6,#BD,#01
	DB	#A6,#78,#BB,#9B,#E1,#9B,#02
	DB	#A6,#78,#CE,#78,#E1,#9B,#02
	DB	#E1,#9B,#BB,#9B,#A6,#BD,#03
	DB	#E1,#9B,#A6,#BD,#CE,#BD,#03
	DB	#C3,#AA,#AE,#CD,#C3,#EF,#01
	DB	#C3,#AA,#D8,#CD,#C3,#EF,#01
	DB	#C3,#AA,#D8,#CD,#FE,#CD,#02
	DB	#C3,#AA,#EB,#AA,#FE,#CD,#02
	DB	#FE,#CD,#D8,#CD,#C3,#EF,#03
	DB	#FE,#CD,#C3,#EF,#EB,#EF,#03
	DB	#89,#AA,#74,#CD,#89,#EF,#01
	DB	#89,#AA,#9E,#CD,#89,#EF,#01
	DB	#89,#AA,#9E,#CD,#C4,#CD,#02
	DB	#89,#AA,#B1,#AA,#C4,#CD,#02
	DB	#C4,#CD,#9E,#CD,#89,#EF,#03
	DB	#C4,#CD,#89,#EF,#B1,#EF,#03
	DB	#4F,#AA,#3A,#CD,#4F,#EF,#01
	DB	#4F,#AA,#64,#CD,#4F,#EF,#01
	DB	#4F,#AA,#64,#CD,#8A,#CD,#02
	DB	#4F,#AA,#77,#AA,#8A,#CD,#02
	DB	#8A,#CD,#64,#CD,#4F,#EF,#03
	DB	#8A,#CD,#4F,#EF,#77,#EF,#03
	DB	#15,#AA,#00,#CD,#15,#EF,#01
	DB	#15,#AA,#2A,#CD,#15,#EF,#01
	DB	#15,#AA,#2A,#CD,#50,#CD,#02
	DB	#15,#AA,#3D,#AA,#50,#CD,#02
	DB	#50,#CD,#2A,#CD,#15,#EF,#03
	DB	#50,#CD,#15,#EF,#3D,#EF,#03
	DB	#32,#78,#1D,#9B,#32,#BD,#01
	DB	#32,#78,#47,#9B,#32,#BD,#01
	DB	#32,#78,#47,#9B,#6D,#9B,#02
	DB	#32,#78,#5A,#78,#6D,#9B,#02
	DB	#6D,#9B,#47,#9B,#32,#BD,#03
	DB	#6D,#9B,#32,#BD,#5A,#BD,#03
	DB	#4F,#46,#3A,#69,#4F,#8B,#01
	DB	#4F,#46,#64,#69,#4F,#8B,#01
	DB	#4F,#46,#64,#69,#8A,#69,#02
	DB	#4F,#46,#77,#46,#8A,#69,#02
	DB	#8A,#69,#64,#69,#4F,#8B,#03
	DB	#8A,#69,#4F,#8B,#77,#8B,#03
	DB	#6C,#14,#57,#37,#6C,#59,#01
	DB	#6C,#14,#81,#37,#6C,#59,#01
	DB	#6C,#14,#81,#37,#A7,#37,#02
	DB	#6C,#14,#94,#14,#A7,#37,#02
	DB	#A7,#37,#81,#37,#6C,#59,#03
	DB	#A7,#37,#6C,#59,#94,#59,#03
	DB	#89,#46,#9E,#69,#89,#8B,#01
	DB	#89,#46,#74,#69,#89,#8B,#01
	DB	#89,#46,#9E,#69,#C4,#69,#02
	DB	#89,#46,#B1,#46,#C4,#69,#82
; Taille 378 octets
;Tricube
	DB	''KVNT''
	DB	#01			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#B9,#1E,#B9,#36,#A0,#43,#02
	DB	#80,#00,#80,#19,#46,#1E,#01
	DB	#80,#19,#46,#1E,#61,#2A,#01
	DB	#80,#00,#80,#19,#B9,#1E,#01
	DB	#80,#19,#B9,#1E,#A0,#2A,#01
	DB	#46,#1E,#46,#34,#61,#43,#03
	DB	#47,#83,#47,#9B,#61,#AA,#03
	DB	#3B,#24,#54,#30,#01,#41,#01
	DB	#54,#30,#34,#41,#01,#41,#01
	DB	#53,#96,#34,#A6,#34,#C0,#02
	DB	#34,#87,#1A,#94,#1A,#CC,#02
	DB	#C5,#23,#AD,#30,#FF,#41,#01
	DB	#34,#87,#34,#C0,#1A,#CC,#02
	DB	#AD,#30,#CC,#40,#FF,#41,#01
	DB	#53,#96,#53,#AF,#34,#C0,#02
	DB	#AD,#50,#AD,#6A,#C5,#77,#03
	DB	#CC,#3F,#FE,#41,#AD,#50,#01
	DB	#FE,#41,#AD,#50,#C5,#5C,#01
	DB	#A0,#56,#B9,#63,#47,#83,#01
	DB	#B9,#63,#47,#83,#61,#90,#01
	DB	#3A,#89,#34,#8D,#34,#A6,#01
	DB	#3A,#89,#53,#96,#34,#A6,#01
	DB	#53,#B6,#3B,#C3,#3B,#DC,#02
	DB	#53,#B6,#53,#CF,#3B,#DC,#02
	DB	#34,#A6,#1A,#B3,#53,#B6,#01
	DB	#1A,#B3,#53,#B6,#3B,#C3,#01
	DB	#61,#BC,#47,#C9,#66,#D9,#01
	DB	#AD,#B6,#AD,#D0,#C6,#DD,#03
	DB	#61,#BC,#66,#BF,#66,#D9,#01
	DB	#A0,#BB,#99,#C0,#B9,#C9,#01
	DB	#99,#C0,#B9,#C9,#99,#D9,#01
	DB	#E5,#B3,#AD,#B6,#C6,#C3,#01
	DB	#CC,#A6,#E5,#B3,#AD,#B6,#01
	DB	#C6,#89,#CC,#8D,#CC,#A6,#01
	DB	#80,#46,#66,#53,#80,#60,#01
	DB	#80,#46,#99,#53,#80,#60,#01
	DB	#1A,#7A,#01,#87,#1A,#94,#01
	DB	#1A,#7A,#34,#87,#1A,#94,#01
	DB	#80,#AB,#66,#B8,#80,#C5,#01
	DB	#80,#AB,#99,#B8,#80,#C5,#01
	DB	#E5,#7A,#CC,#87,#E5,#94,#01
	DB	#E5,#7A,#FE,#87,#E5,#94,#01
	DB	#80,#19,#61,#2A,#61,#43,#02
	DB	#80,#19,#80,#33,#61,#43,#02
	DB	#B9,#1E,#A0,#2A,#A0,#43,#02
	DB	#99,#26,#80,#33,#80,#54,#02
	DB	#99,#26,#99,#46,#80,#54,#02
	DB	#B9,#63,#B9,#7D,#61,#AA,#02
	DB	#B9,#83,#A0,#90,#A0,#AA,#02
	DB	#B9,#83,#B9,#9E,#A0,#AA,#02
	DB	#C6,#89,#AD,#96,#CC,#A6,#01
	DB	#B9,#63,#61,#90,#61,#AA,#02
	DB	#99,#8D,#80,#9A,#80,#B9,#02
	DB	#34,#41,#34,#7A,#1A,#86,#02
	DB	#99,#8D,#99,#AD,#80,#B9,#02
	DB	#52,#50,#52,#6A,#3B,#77,#02
	DB	#46,#64,#B9,#83,#A0,#90,#01
	DB	#61,#57,#46,#64,#B9,#83,#01
	DB	#99,#53,#80,#60,#80,#80,#02
	DB	#34,#41,#1A,#4E,#1A,#86,#02
	DB	#99,#53,#99,#73,#80,#80,#02
	DB	#54,#30,#54,#4A,#34,#58,#02
	DB	#54,#30,#34,#41,#34,#58,#02
	DB	#01,#41,#52,#50,#3B,#5E,#01
	DB	#34,#41,#01,#41,#52,#50,#01
	DB	#52,#50,#3B,#5D,#3B,#77,#02
	DB	#99,#B8,#80,#C5,#80,#FF,#02
	DB	#99,#B8,#99,#F3,#80,#FF,#02
	DB	#B9,#C9,#99,#D9,#99,#F3,#02
	DB	#B9,#C9,#B9,#E2,#99,#F3,#02
	DB	#FE,#87,#E5,#94,#FE,#BE,#02
	DB	#E5,#94,#FE,#BE,#E5,#CC,#02
	DB	#E5,#B3,#C6,#C3,#C6,#DD,#02
	DB	#E5,#B3,#E5,#CC,#C6,#DD,#02
	DB	#E5,#4C,#C5,#5C,#C5,#77,#02
	DB	#FE,#40,#FE,#79,#E5,#87,#02
	DB	#FE,#40,#E5,#4C,#E5,#87,#02
	DB	#E5,#4C,#E5,#66,#C5,#77,#02
	DB	#80,#19,#A0,#2A,#80,#33,#03
	DB	#A0,#2A,#80,#33,#A0,#43,#03
	DB	#AD,#30,#CC,#40,#AD,#4A,#03
	DB	#CC,#40,#AD,#4A,#B3,#4D,#03
	DB	#01,#41,#3B,#5E,#3B,#78,#03
	DB	#01,#41,#1A,#4E,#1A,#86,#03
	DB	#01,#41,#01,#79,#1A,#86,#03
	DB	#01,#41,#01,#5C,#3B,#78,#03
	DB	#66,#53,#80,#60,#66,#74,#03
	DB	#80,#60,#66,#74,#80,#80,#03
	DB	#80,#80,#80,#9A,#A0,#AA,#03
	DB	#80,#80,#A0,#90,#A0,#AA,#03
	DB	#46,#64,#68,#74,#46,#7C,#03
	DB	#66,#74,#46,#7C,#4D,#80,#03
	DB	#47,#83,#61,#90,#61,#AA,#03
	DB	#80,#9A,#66,#AC,#80,#B9,#03
	DB	#80,#9A,#66,#A7,#66,#AC,#03
	DB	#80,#33,#66,#47,#80,#54,#03
	DB	#80,#33,#66,#40,#66,#47,#03
	DB	#E5,#66,#CC,#79,#E5,#86,#03
	DB	#E5,#66,#CC,#73,#CC,#79,#03
	DB	#46,#1E,#61,#2A,#61,#43,#03
	DB	#AD,#50,#C5,#5C,#C5,#77,#03
	DB	#AD,#96,#CC,#A6,#AD,#AF,#03
	DB	#CC,#A6,#AD,#AF,#B3,#B3,#03
	DB	#AD,#B6,#C6,#C3,#C6,#DD,#03
	DB	#CC,#87,#E5,#94,#E5,#B3,#03
	DB	#CC,#87,#CC,#A6,#E5,#B3,#03
	DB	#66,#B8,#80,#C5,#80,#FF,#03
	DB	#66,#B8,#66,#F2,#80,#FF,#03
	DB	#47,#C8,#47,#E2,#80,#FF,#03
	DB	#47,#C9,#66,#D9,#66,#F0,#03
	DB	#01,#87,#1A,#94,#1A,#CC,#03
	DB	#01,#87,#01,#BF,#1A,#CC,#03
	DB	#3B,#C3,#1A,#CC,#3B,#DC,#03
	DB	#1A,#B3,#3B,#C3,#1A,#CC,#83
; Taille 798 octets
;Batman
	DB	''KTSL''
	DB	#0F			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#04,#57,#58,#57,#18,#62,#01
	DB	#58,#57,#18,#62,#23,#6C,#01
	DB	#58,#57,#23,#6C,#29,#76,#01
	DB	#58,#57,#29,#76,#28,#88,#01
	DB	#58,#57,#28,#88,#49,#89,#01
	DB	#58,#57,#49,#89,#58,#8B,#01
	DB	#58,#57,#58,#8B,#6D,#94,#01
	DB	#58,#57,#67,#69,#6D,#94,#01
	DB	#67,#69,#80,#6A,#6D,#94,#01
	DB	#80,#6A,#6D,#94,#76,#9B,#01
	DB	#80,#6A,#76,#9B,#80,#AF,#01
	DB	#7C,#56,#77,#6A,#80,#6A,#81
; Taille 84 octets
;Batman2
	DB	''KUTN''
	DB	#07			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#80,#00,#19,#C4,#80,#C4,#01
	DB	#60,#0C,#74,#17,#69,#2C,#01
	DB	#19,#C4,#2C,#C4,#23,#D2,#01
	DB	#2C,#C4,#3F,#C4,#36,#D2,#01
	DB	#3F,#C4,#52,#C4,#49,#D2,#01
	DB	#52,#C4,#65,#C4,#5C,#D2,#01
	DB	#65,#C4,#78,#C4,#6F,#D2,#01
	DB	#78,#C4,#80,#C4,#80,#D2,#01
	DB	#67,#1A,#70,#1C,#6A,#27,#02
	DB	#80,#18,#6A,#2D,#80,#2D,#02
	DB	#50,#9B,#58,#A1,#48,#C4,#02
	DB	#48,#9F,#40,#A5,#48,#A6,#02
	DB	#48,#A6,#40,#AB,#48,#AC,#02
	DB	#48,#AC,#40,#B2,#48,#B2,#02
	DB	#6B,#32,#7C,#35,#74,#38,#00
	DB	#60,#44,#80,#44,#80,#71,#00
	DB	#80,#73,#4F,#73,#6B,#9F,#00
	DB	#80,#73,#6B,#9F,#80,#9F,#00
	DB	#4F,#73,#59,#75,#4B,#9D,#00
	DB	#5C,#88,#50,#9C,#54,#9E,#00
	DB	#50,#73,#5E,#88,#50,#9C,#00
	DB	#50,#82,#51,#9D,#49,#9F,#00
	DB	#6D,#A8,#7E,#C3,#65,#F3,#00
	DB	#7B,#CA,#70,#E1,#71,#E2,#02
	DB	#67,#CA,#69,#CA,#67,#D8,#02
	DB	#6D,#D5,#62,#D9,#67,#F4,#01
	DB	#6D,#D5,#75,#DF,#67,#F4,#02
	DB	#6C,#EF,#6E,#F7,#4F,#FE,#01
	DB	#80,#7E,#7E,#88,#80,#88,#02
	DB	#80,#88,#7C,#88,#80,#96,#02
	DB	#72,#7C,#7D,#87,#76,#92,#02
	DB	#72,#7C,#6F,#86,#74,#86,#02
	DB	#80,#52,#7F,#53,#80,#63,#03
	DB	#80,#4D,#80,#50,#75,#50,#03
	DB	#5E,#9D,#6A,#9D,#6A,#A6,#03
	DB	#5E,#9D,#6A,#A6,#5E,#A6,#03
	DB	#6C,#9E,#6C,#A7,#78,#A7,#03
	DB	#6C,#9E,#78,#9E,#78,#A7,#03
	DB	#7A,#9E,#80,#9E,#80,#A8,#03
	DB	#7A,#9E,#80,#A8,#7A,#A8,#83
; Taille 280 octets
;Piece
	DB	''@TDL''
	DB	#0F			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#80,#01,#71,#04,#80,#2C,#01
	DB	#71,#04,#63,#0E,#80,#2C,#01
	DB	#63,#0E,#5A,#1A,#80,#2C,#01
	DB	#5A,#1A,#56,#2B,#80,#2C,#01
	DB	#80,#2C,#5A,#3B,#63,#48,#01
	DB	#56,#2B,#80,#2C,#5A,#3B,#01
	DB	#80,#2C,#63,#48,#69,#4E,#01
	DB	#80,#2C,#69,#4E,#80,#5C,#01
	DB	#69,#4E,#4F,#5C,#80,#5C,#01
	DB	#4F,#5C,#80,#5C,#6B,#66,#01
	DB	#80,#5C,#6B,#66,#64,#A4,#01
	DB	#80,#5C,#57,#C2,#80,#FF,#01
	DB	#5F,#AF,#56,#B6,#58,#C2,#01
	DB	#57,#C2,#3B,#EC,#80,#FF,#01
	DB	#3B,#EC,#3F,#FD,#80,#FF,#01
	DB	#57,#C2,#3C,#DF,#40,#E7,#01
	DB	#3B,#E8,#80,#EB,#80,#EE,#02
	DB	#57,#C3,#7E,#C6,#80,#C8,#02
	DB	#6A,#4E,#80,#50,#80,#53,#02
	DB	#6B,#65,#80,#67,#80,#69,#82
; Taille 140 octets
;ChessBoard
	DB	''@KT[''
	DB	#03			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#F9,#4F,#3B,#50,#EB,#9E,#02
	DB	#3B,#50,#00,#9B,#EB,#9E,#02
	DB	#3B,#50,#52,#50,#4D,#58,#01
	DB	#3B,#50,#4D,#58,#35,#58,#01
	DB	#68,#50,#80,#50,#7C,#58,#01
	DB	#68,#50,#7C,#58,#64,#58,#01
	DB	#98,#50,#AF,#50,#AC,#58,#01
	DB	#98,#50,#AC,#58,#94,#58,#01
	DB	#C7,#50,#E1,#50,#DD,#58,#01
	DB	#4D,#58,#64,#58,#5E,#61,#01
	DB	#C7,#50,#DE,#58,#C5,#58,#01
	DB	#4D,#58,#5E,#61,#46,#61,#01
	DB	#7C,#58,#94,#58,#90,#61,#01
	DB	#7C,#58,#90,#61,#77,#61,#01
	DB	#AC,#58,#C5,#58,#C2,#61,#01
	DB	#2F,#61,#46,#61,#40,#69,#01
	DB	#AC,#58,#C2,#61,#A9,#61,#01
	DB	#2F,#61,#40,#69,#28,#69,#01
	DB	#DE,#58,#F7,#58,#F5,#5F,#01
	DB	#5E,#61,#77,#61,#72,#69,#01
	DB	#DE,#58,#F5,#5F,#DB,#5F,#01
	DB	#5E,#61,#72,#69,#59,#69,#01
	DB	#90,#61,#A9,#61,#A5,#69,#01
	DB	#90,#61,#A5,#69,#8C,#69,#01
	DB	#DC,#5F,#C2,#61,#DA,#69,#01
	DB	#40,#69,#59,#69,#54,#72,#01
	DB	#C2,#61,#DA,#69,#C0,#69,#01
	DB	#40,#69,#54,#72,#3A,#72,#01
	DB	#72,#69,#8C,#69,#87,#72,#01
	DB	#72,#69,#87,#72,#6D,#72,#01
	DB	#A5,#69,#C0,#69,#BC,#72,#01
	DB	#21,#72,#3A,#72,#34,#7B,#01
	DB	#A5,#69,#BC,#72,#A2,#72,#01
	DB	#21,#72,#34,#7B,#19,#7B,#01
	DB	#DA,#69,#F5,#69,#F3,#72,#01
	DB	#54,#72,#6D,#72,#68,#7B,#01
	DB	#DA,#69,#F3,#72,#D7,#72,#01
	DB	#54,#72,#68,#7B,#4E,#7B,#01
	DB	#87,#72,#A2,#72,#9E,#7C,#01
	DB	#87,#72,#82,#7B,#9E,#7C,#01
	DB	#BC,#72,#D7,#72,#D5,#7C,#01
	DB	#34,#7B,#4E,#7B,#48,#85,#01
	DB	#BC,#72,#D5,#7C,#B9,#7C,#01
	DB	#34,#7B,#48,#85,#2C,#85,#01
	DB	#68,#7B,#82,#7B,#7D,#86,#01
	DB	#68,#7B,#7D,#86,#62,#86,#01
	DB	#9E,#7C,#B9,#7C,#B6,#86,#01
	DB	#12,#85,#2C,#85,#25,#90,#01
	DB	#9E,#7C,#B6,#86,#9A,#86,#01
	DB	#12,#85,#25,#90,#09,#90,#01
	DB	#D5,#7C,#F1,#7C,#EF,#86,#01
	DB	#48,#85,#62,#86,#5D,#90,#01
	DB	#D5,#7C,#EF,#86,#D2,#86,#01
	DB	#48,#85,#5D,#90,#40,#90,#01
	DB	#7D,#86,#9A,#86,#95,#91,#01
	DB	#7D,#86,#78,#90,#95,#91,#01
	DB	#B6,#86,#D2,#86,#D0,#91,#01
	DB	#25,#90,#40,#90,#39,#9C,#01
	DB	#B6,#86,#D0,#91,#B3,#91,#01
	DB	#25,#90,#39,#9C,#1D,#9C,#01
	DB	#5D,#90,#78,#90,#73,#9D,#01
	DB	#5D,#90,#57,#9C,#73,#9D,#01
	DB	#95,#91,#B3,#91,#AF,#9E,#01
	DB	#95,#91,#91,#9D,#AF,#9E,#01
	DB	#D0,#91,#EE,#91,#EB,#9E,#01
	DB	#D0,#91,#CD,#9D,#EB,#9E,#81
; Taille 462 octets
;Montagne
	DB	''S@KL''
	DB	#06			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#1C,#89,#00,#A4,#12,#A4,#01
	DB	#48,#6F,#1C,#87,#12,#A4,#01
	DB	#30,#73,#39,#78,#27,#82,#01
	DB	#5D,#5A,#6C,#69,#12,#A4,#01
	DB	#74,#62,#84,#73,#12,#A4,#01
	DB	#8D,#70,#84,#70,#12,#A4,#01
	DB	#8D,#70,#A1,#82,#12,#A4,#01
	DB	#A1,#82,#B5,#A3,#12,#A4,#01
	DB	#AF,#7C,#A1,#82,#B5,#A3,#01
	DB	#AF,#7C,#B5,#7F,#B5,#A3,#01
	DB	#C1,#77,#B5,#7F,#B5,#A3,#01
	DB	#C1,#77,#B5,#A3,#FF,#A4,#01
	DB	#CE,#73,#C1,#79,#E1,#8E,#01
	DB	#11,#93,#0D,#97,#28,#A0,#02
	DB	#1A,#8B,#15,#8F,#25,#99,#02
	DB	#27,#79,#34,#87,#2A,#96,#02
	DB	#32,#73,#3D,#78,#37,#8D,#02
	DB	#3D,#78,#45,#8C,#37,#8D,#02
	DB	#47,#7F,#41,#83,#45,#8C,#02
	DB	#45,#8C,#37,#8D,#3C,#90,#02
	DB	#31,#8C,#39,#94,#29,#96,#02
	DB	#4F,#6D,#55,#70,#4E,#7D,#02
	DB	#4E,#7D,#4D,#8D,#59,#9A,#02
	DB	#4E,#7D,#5E,#8D,#59,#9A,#02
	DB	#5E,#66,#6C,#6B,#55,#70,#02
	DB	#75,#62,#69,#69,#7F,#7A,#02
	DB	#84,#6F,#8F,#70,#7B,#83,#02
	DB	#8F,#70,#7B,#83,#8E,#8F,#02
	DB	#7F,#85,#8E,#8F,#79,#99,#02
	DB	#8E,#8F,#79,#99,#84,#A0,#02
	DB	#8E,#8F,#9D,#9F,#84,#A0,#02
	DB	#8E,#8F,#9B,#95,#9D,#9F,#02
	DB	#8F,#71,#8E,#85,#9B,#8B,#02
	DB	#8F,#71,#A3,#83,#9B,#8B,#02
	DB	#AF,#7C,#A3,#83,#AF,#8B,#02
	DB	#AF,#7C,#AF,#8B,#C1,#90,#02
	DB	#AF,#8B,#C1,#90,#BC,#9C,#02
	DB	#55,#7A,#78,#85,#65,#95,#02
	DB	#7C,#78,#55,#7A,#76,#84,#02
	DB	#5E,#6F,#55,#7A,#78,#85,#02
	DB	#6C,#6B,#5E,#6E,#76,#72,#02
	DB	#D0,#75,#D9,#82,#C7,#85,#02
	DB	#D9,#82,#C7,#85,#CD,#92,#02
	DB	#D9,#82,#E1,#8E,#CD,#92,#02
	DB	#E1,#8E,#CD,#92,#DD,#9B,#02
	DB	#E1,#8E,#FF,#A4,#D9,#A4,#02
	DB	#5E,#5A,#6E,#6A,#5D,#6E,#82
; Taille 329 octets
;Floral
	DB	''CYSO''
	DB	#03			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#18,#00,#00,#00,#00,#18,#01
	DB	#00,#E7,#00,#FF,#18,#FF,#01
	DB	#30,#00,#00,#30,#30,#30,#02
	DB	#00,#CF,#30,#CF,#30,#FF,#02
	DB	#48,#18,#18,#48,#48,#48,#03
	DB	#18,#B7,#48,#B7,#48,#E7,#03
	DB	#60,#30,#60,#60,#30,#60,#01
	DB	#30,#9F,#60,#9F,#60,#CF,#01
	DB	#78,#48,#78,#78,#48,#78,#02
	DB	#48,#87,#78,#87,#78,#B7,#02
	DB	#80,#6F,#70,#7F,#80,#8E,#03
	DB	#48,#6B,#33,#80,#48,#94,#03
	DB	#32,#6B,#1D,#80,#32,#94,#01
	DB	#1C,#6B,#08,#80,#1C,#94,#82
; Taille 98 octets
;Apple
	DB	''LTWK''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#00,#00,#6C,#7F,#00,#FF,#02
	DB	#00,#00,#85,#00,#6C,#7F,#02
	DB	#6C,#7F,#8E,#7F,#00,#FF,#02
	DB	#8E,#7F,#00,#FF,#99,#FF,#02
	DB	#85,#00,#FF,#00,#6C,#7F,#03
	DB	#FF,#00,#FF,#7F,#6C,#7F,#03
	DB	#8E,#7F,#FF,#FF,#99,#FF,#03
	DB	#8E,#7F,#FF,#7F,#FF,#FF,#03
	DB	#47,#44,#42,#49,#4D,#49,#01
	DB	#42,#49,#4C,#49,#4D,#5D,#01
	DB	#42,#49,#4D,#5D,#42,#5D,#01
	DB	#42,#5D,#4C,#5D,#48,#62,#01
	DB	#B8,#43,#B3,#48,#BE,#48,#01
	DB	#B3,#48,#BD,#48,#BD,#5C,#01
	DB	#B3,#48,#B3,#5C,#BE,#5C,#01
	DB	#B3,#5C,#BD,#5C,#B9,#61,#01
	DB	#36,#9E,#30,#A4,#44,#B7,#01
	DB	#36,#9E,#48,#AF,#44,#B7,#01
	DB	#48,#AF,#44,#B7,#58,#C1,#01
	DB	#48,#AF,#5B,#B8,#58,#C1,#01
	DB	#5B,#B8,#58,#C1,#6E,#C5,#01
	DB	#5B,#B8,#70,#BD,#6E,#C5,#01
	DB	#70,#BD,#6E,#C5,#8D,#C5,#01
	DB	#70,#BD,#8D,#BD,#8D,#C5,#01
	DB	#8D,#BD,#A5,#C0,#8D,#C5,#01
	DB	#A2,#B8,#8D,#BD,#A5,#C0,#01
	DB	#A2,#B8,#B7,#B8,#A5,#C0,#01
	DB	#B3,#B1,#B7,#B8,#A2,#B8,#01
	DB	#C9,#9E,#B3,#B1,#B7,#B8,#01
	DB	#C9,#9E,#CF,#A4,#B7,#B8
;
LogoBarre
	DB	#C1
; Croix pour barrer le logo
	DB	#28,#18,#E8,#D8,#D8,#E8,#00
	DB	#28,#18,#18,#28,#D8,#E8,#00
	DB	#D8,#18,#E8,#28,#28,#E8,#00
	DB	#D8,#18,#18,#D8,#28,#E8,#80
; Taille 238 octets
;Amstrad
	DB	''@EKL''
	DB	#01			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#9F,#4C,#DF,#4C,#AC,#B3,#01
	DB	#9F,#4C,#AC,#B3,#6B,#B3,#01
	DB	#07,#5D,#00,#A1,#0F,#A1,#02
	DB	#07,#5D,#11,#5D,#0F,#A1,#02
	DB	#1B,#5D,#11,#5D,#14,#A1,#02
	DB	#1B,#5D,#23,#A1,#14,#A1,#02
	DB	#0E,#88,#13,#88,#0E,#94,#02
	DB	#13,#88,#13,#94,#0E,#94,#02
	DB	#25,#5D,#33,#5D,#33,#A1,#02
	DB	#25,#5D,#33,#A1,#25,#A1,#02
	DB	#33,#5D,#39,#5D,#3B,#6E,#02
	DB	#33,#5D,#3C,#6E,#33,#92,#02
	DB	#3E,#5D,#3B,#6E,#44,#92,#02
	DB	#3E,#5D,#44,#5D,#44,#92,#02
	DB	#44,#5D,#52,#5D,#52,#A1,#02
	DB	#44,#5D,#52,#A1,#44,#A1,#02
	DB	#33,#92,#36,#A1,#41,#A1,#02
	DB	#33,#92,#44,#92,#41,#A1,#02
	DB	#3B,#6C,#44,#92,#33,#92,#02
	DB	#5A,#5D,#6E,#5D,#53,#64,#02
	DB	#6E,#5D,#53,#64,#75,#64,#02
	DB	#65,#64,#65,#75,#75,#75,#02
	DB	#65,#64,#75,#64,#75,#75,#02
	DB	#63,#64,#65,#64,#65,#6A,#02
	DB	#63,#64,#65,#6A,#63,#6A,#02
	DB	#53,#64,#63,#64,#63,#73,#02
	DB	#53,#64,#63,#73,#53,#79,#02
	DB	#63,#73,#53,#79,#75,#81,#02
	DB	#53,#79,#75,#81,#65,#86,#02
	DB	#75,#81,#65,#86,#75,#9A,#02
	DB	#65,#86,#65,#93,#75,#9A,#02
	DB	#65,#93,#75,#9A,#6E,#A1,#02
	DB	#65,#93,#5A,#A1,#6E,#A1,#02
	DB	#65,#93,#53,#9B,#5A,#A1,#02
	DB	#53,#86,#63,#86,#63,#96,#02
	DB	#53,#85,#63,#94,#53,#9B,#02
	DB	#75,#5D,#93,#5D,#93,#69,#02
	DB	#75,#5D,#93,#69,#75,#69,#02
	DB	#7C,#69,#7B,#A1,#8C,#A1,#02
	DB	#7C,#69,#8C,#69,#8C,#A1,#02
	DB	#95,#5D,#A5,#5D,#A5,#A1,#02
	DB	#95,#5D,#A5,#A1,#95,#A1,#02
	DB	#A5,#5D,#B0,#5D,#A7,#6C,#02
	DB	#A5,#5D,#A5,#69,#A7,#6C,#02
	DB	#B0,#5D,#B7,#64,#A7,#6C,#02
	DB	#B7,#64,#A8,#6B,#B7,#7A,#02
	DB	#A8,#6B,#A6,#7A,#B7,#7A,#02
	DB	#A5,#7A,#B7,#7A,#A5,#85,#02
	DB	#B7,#7A,#A5,#85,#A8,#89,#02
	DB	#B4,#7D,#B7,#84,#A8,#88,#02
	DB	#B7,#84,#A8,#88,#B7,#A1,#02
	DB	#A8,#88,#B7,#A1,#A8,#A1,#02
	DB	#C0,#5D,#B9,#A1,#C8,#A1,#02
	DB	#C0,#5D,#CA,#5D,#C8,#A1,#02
	DB	#D4,#5D,#CA,#5D,#CD,#A1,#02
	DB	#D4,#5D,#DC,#A1,#CD,#A1,#02
	DB	#C7,#88,#CC,#88,#C7,#94,#02
	DB	#CC,#88,#CC,#94,#C7,#94,#02
	DB	#DD,#5D,#F8,#5D,#F8,#A1,#02
	DB	#DD,#5D,#F8,#A1,#DD,#A1,#02
	DB	#ED,#6A,#EF,#6A,#EF,#95,#00
	DB	#ED,#6A,#EF,#95,#ED,#95,#00
	DB	#F8,#5D,#FF,#64,#FF,#9B,#02
	DB	#F8,#5D,#FF,#9B,#F8,#A1,#82
; Taille 448 octets
;Bidul
	DB	''CNL'',92
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#43,#A7,#6C,#D7,#5B,#E0,#01
	DB	#28,#68,#1D,#7B,#43,#A7,#02
	DB	#92,#2D,#E3,#44,#C0,#56,#03
	DB	#E3,#44,#C0,#56,#D4,#96,#03
	DB	#D4,#96,#AE,#AF,#C3,#EC,#03
	DB	#AE,#AF,#6C,#D7,#C3,#EC,#03
	DB	#34,#37,#13,#C0,#6C,#D7,#03
	DB	#3D,#14,#67,#3D,#28,#68,#03
	DB	#3D,#14,#92,#2D,#67,#3D,#03
	DB	#AA,#10,#67,#3D,#96,#6B,#01
	DB	#AA,#10,#C0,#56,#96,#6B,#02
	DB	#C0,#56,#96,#6B,#F3,#84,#01
	DB	#96,#6B,#F3,#84,#AE,#AF,#02
	DB	#96,#6B,#AE,#AF,#82,#CB,#01
	DB	#96,#6B,#53,#97,#82,#CB,#02
	DB	#53,#97,#82,#CB,#6C,#D7,#02
	DB	#36,#51,#96,#6B,#53,#97,#01
	DB	#67,#3D,#36,#51,#96,#6B,#82
; Taille 126 octets
;Etoile
	DB	''@OMX''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#4E,#07,#A6,#53,#53,#8E,#02
	DB	#50,#56,#75,#56,#00,#99,#03
	DB	#5C,#88,#A0,#99,#7A,#B1,#03
	DB	#A2,#00,#C4,#74,#49,#8D,#02
	DB	#B9,#4A,#53,#7C,#D5,#E3,#02
	DB	#4E,#07,#7F,#2C,#7C,#30,#03
	DB	#A2,#00,#7B,#31,#69,#5C,#03
	DB	#B5,#3F,#FF,#40,#B6,#43,#03
	DB	#5B,#41,#75,#42,#6A,#56,#01
	DB	#5B,#41,#6A,#56,#59,#5E,#01
	DB	#80,#74,#77,#98,#00,#99,#01
	DB	#69,#5C,#80,#74,#00,#99,#01
	DB	#FF,#40,#B5,#43,#B0,#68,#01
	DB	#FF,#40,#B0,#68,#C2,#7C,#01
	DB	#AE,#54,#C5,#64,#AB,#6A,#01
	DB	#C5,#64,#AB,#6A,#B5,#7D,#01
	DB	#88,#62,#92,#72,#80,#7B,#01
	DB	#92,#72,#80,#7B,#92,#8A,#01
	DB	#88,#62,#76,#6A,#80,#7B,#02
	DB	#76,#6A,#80,#7B,#6A,#7D,#02
	DB	#80,#7B,#6A,#7D,#92,#8A,#03
	DB	#A2,#00,#A4,#70,#A6,#70,#03
	DB	#A4,#70,#A6,#70,#D5,#E3,#03
	DB	#AE,#54,#C5,#64,#C5,#65,#03
	DB	#C5,#64,#C5,#65,#B5,#7D,#03
	DB	#C5,#64,#C5,#66,#B5,#7D,#83
; Taille 182 octets
;Bouboule
	DB	''K_WU''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#8A,#00,#6E,#0F,#BB,#19,#03
	DB	#8A,#00,#6C,#0F,#3D,#11,#03
	DB	#6D,#10,#3E,#12,#1F,#3D,#03
	DB	#3C,#12,#1D,#3E,#09,#4B,#03
	DB	#1E,#3E,#09,#4C,#00,#83,#03
	DB	#00,#84,#0A,#AC,#1D,#D1,#03
	DB	#1E,#D1,#42,#E9,#6E,#FF,#03
	DB	#AA,#DA,#BA,#EE,#6E,#FF,#03
	DB	#EF,#B5,#AB,#D9,#BB,#EE,#03
	DB	#F0,#59,#F7,#7B,#F0,#B4,#03
	DB	#BD,#1A,#DB,#2E,#F0,#59,#03
	DB	#BD,#1B,#AB,#46,#EE,#58,#02
	DB	#AC,#47,#EF,#59,#CE,#8F,#02
	DB	#EF,#5A,#CE,#90,#EF,#B3,#02
	DB	#CE,#91,#EF,#B4,#AD,#D7,#02
	DB	#5A,#D3,#A9,#DA,#6E,#FE,#02
	DB	#1E,#D1,#59,#D2,#6C,#FD,#02
	DB	#2A,#92,#1E,#D1,#58,#D1,#02
	DB	#01,#85,#29,#91,#1D,#D0,#02
	DB	#1F,#3E,#01,#84,#29,#90,#02
	DB	#20,#3F,#5A,#4F,#2A,#8E,#02
	DB	#6C,#12,#1F,#3E,#59,#4E,#02
	DB	#6D,#11,#AB,#45,#5A,#4F,#02
	DB	#6D,#10,#BC,#1A,#AB,#44,#02
	DB	#AB,#46,#CD,#90,#83,#95,#01
	DB	#CD,#91,#84,#96,#AB,#D8,#01
	DB	#82,#95,#5B,#D2,#AB,#D9,#01
	DB	#2A,#91,#81,#95,#5A,#D2,#01
	DB	#5A,#50,#2A,#90,#81,#94,#01
	DB	#AA,#46,#5B,#50,#82,#95,#81
; Taille 210 octets
;Donut
	DB	''XCSL''
	DB	#06			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#55,#A2,#81,#A2,#8C,#C6,#03
	DB	#8C,#C6,#3E,#EA,#97,#EA,#03
	DB	#C4,#A2,#EA,#B4,#97,#EA,#03
	DB	#B8,#7F,#C4,#A2,#81,#A2,#03
	DB	#C4,#A2,#8C,#C6,#97,#EA,#01
	DB	#81,#A2,#C4,#A2,#8C,#C6,#01
	DB	#55,#A2,#60,#C6,#8C,#C6,#01
	DB	#60,#C6,#8C,#C6,#3E,#EA,#01
	DB	#34,#7F,#55,#A2,#60,#C6,#03
	DB	#34,#7F,#02,#90,#55,#A2,#01
	DB	#B8,#7F,#CE,#80,#C4,#A2,#01
	DB	#CE,#80,#C4,#A2,#EA,#B4,#01
	DB	#C4,#5C,#B8,#7F,#CE,#80,#03
	DB	#FF,#6E,#CE,#80,#EA,#B4,#03
	DB	#0D,#B4,#60,#C6,#3E,#EA,#03
	DB	#02,#90,#0D,#B4,#3E,#EA,#01
	DB	#34,#7F,#3E,#A2,#60,#C6,#01
	DB	#3E,#A2,#0D,#B4,#60,#C6,#01
	DB	#CF,#37,#F5,#4A,#FF,#6E,#01
	DB	#AE,#5B,#FF,#6E,#CE,#80,#01
	DB	#18,#49,#02,#90,#0D,#B4,#03
	DB	#C4,#15,#CF,#37,#F5,#4A,#03
	DB	#23,#6D,#3E,#A2,#0D,#B4,#03
	DB	#CF,#37,#AE,#5B,#FF,#6E,#03
	DB	#23,#6D,#4A,#80,#3E,#A2,#01
	DB	#18,#49,#23,#6D,#0D,#B4,#01
	DB	#CF,#37,#AE,#5B,#82,#5B,#01
	DB	#6C,#14,#18,#49,#23,#6D,#03
	DB	#C4,#15,#CF,#37,#77,#37,#01
	DB	#6C,#14,#C4,#15,#77,#37,#03
	DB	#77,#37,#82,#5B,#4A,#80,#01
	DB	#CF,#37,#77,#37,#82,#5B,#03
	DB	#77,#37,#23,#6D,#4A,#80,#03
	DB	#6C,#14,#77,#37,#23,#6D,#81
; Taille 238 octets
;Cylindre
	DB	''DUWL''
	DB	#03			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#8B,#ED,#5A,#F1,#7A,#F1,#02
	DB	#0D,#53,#08,#64,#02,#6E,#01
	DB	#15,#45,#0D,#53,#08,#64,#01
	DB	#18,#CA,#22,#CD,#3C,#E5,#01
	DB	#18,#CA,#30,#DF,#3C,#E5,#01
	DB	#02,#6E,#05,#88,#01,#8F,#02
	DB	#08,#64,#02,#6E,#05,#88,#02
	DB	#8B,#ED,#6C,#ED,#5A,#F1,#02
	DB	#01,#8F,#0F,#AD,#08,#AF,#01
	DB	#05,#88,#01,#8F,#0F,#AD,#01
	DB	#3C,#E5,#6C,#ED,#5A,#F1,#01
	DB	#4D,#DF,#3C,#E5,#6C,#ED,#01
	DB	#2B,#2E,#25,#40,#15,#45,#01
	DB	#3B,#28,#2B,#2E,#25,#40,#01
	DB	#67,#16,#5C,#1E,#4C,#23,#02
	DB	#67,#16,#57,#1B,#4C,#23,#02
	DB	#9C,#E6,#6C,#ED,#8B,#ED,#01
	DB	#08,#AF,#18,#CA,#22,#CD,#02
	DB	#15,#45,#19,#60,#08,#64,#02
	DB	#25,#40,#15,#45,#19,#60,#02
	DB	#22,#CD,#4D,#DF,#3C,#E5,#02
	DB	#33,#C8,#22,#CD,#4D,#DF,#02
	DB	#3B,#28,#36,#3A,#25,#40,#02
	DB	#4C,#23,#3B,#28,#36,#3A,#02
	DB	#F4,#50,#FD,#74,#A3,#74,#01
	DB	#08,#64,#17,#84,#05,#88,#01
	DB	#19,#60,#08,#64,#17,#84,#01
	DB	#0F,#AD,#33,#C8,#22,#CD,#01
	DB	#20,#A8,#0F,#AD,#33,#C8,#01
	DB	#9C,#E6,#7C,#E6,#6C,#ED,#02
	DB	#0F,#AD,#08,#AF,#22,#CD,#02
	DB	#A3,#74,#FD,#74,#FC,#98,#02
	DB	#05,#88,#20,#A8,#0F,#AD,#02
	DB	#17,#84,#05,#88,#20,#A8,#02
	DB	#E1,#2F,#F4,#50,#A3,#74,#02
	DB	#79,#10,#67,#16,#5C,#1E,#01
	DB	#79,#10,#6E,#17,#5C,#1E,#01
	DB	#AC,#E2,#7C,#E6,#9C,#E6,#02
	DB	#A3,#74,#FC,#98,#EE,#B7,#01
	DB	#57,#1B,#4C,#23,#3B,#28,#01
	DB	#4D,#DF,#7C,#E6,#6C,#ED,#02
	DB	#5C,#DA,#4D,#DF,#7C,#E6,#02
	DB	#A9,#0B,#C7,#18,#A3,#74,#02
	DB	#25,#40,#2A,#5A,#19,#60,#01
	DB	#36,#3A,#25,#40,#2A,#5A,#01
	DB	#33,#C8,#5C,#DA,#4D,#DF,#01
	DB	#43,#C2,#33,#C8,#5C,#DA,#01
	DB	#AC,#E2,#8D,#E2,#7C,#E6,#02
	DB	#4C,#23,#47,#36,#36,#3A,#01
	DB	#5C,#1E,#4C,#23,#47,#36,#01
	DB	#19,#60,#28,#7F,#17,#84,#02
	DB	#2A,#5A,#19,#60,#28,#7F,#02
	DB	#5C,#DA,#8D,#E2,#7C,#E6,#01
	DB	#6E,#D5,#5C,#DA,#8D,#E2,#01
	DB	#A9,#0B,#89,#0B,#A3,#74,#01
	DB	#C7,#18,#E1,#2F,#A3,#74,#01
	DB	#A3,#74,#EE,#B7,#DA,#CF,#02
	DB	#20,#A8,#43,#C2,#33,#C8,#02
	DB	#30,#A3,#20,#A8,#43,#C2,#02
	DB	#BC,#DB,#8D,#E2,#AC,#E2,#01
	DB	#A3,#74,#DA,#CF,#BC,#DB,#01
	DB	#28,#7F,#17,#84,#30,#A3,#01
	DB	#89,#0B,#79,#10,#6E,#17,#01
	DB	#17,#84,#30,#A3,#20,#A8,#01
	DB	#36,#3A,#3A,#55,#2A,#5A,#02
	DB	#47,#36,#36,#3A,#3A,#55,#02
	DB	#43,#C2,#6E,#D5,#5C,#DA,#02
	DB	#55,#BD,#43,#C2,#6E,#D5,#02
	DB	#BC,#DB,#9E,#DC,#8D,#E2,#01
	DB	#5C,#1E,#58,#2F,#47,#36,#02
	DB	#6E,#17,#5C,#1E,#58,#2F,#02
	DB	#2A,#5A,#38,#79,#28,#7F,#01
	DB	#3A,#55,#2A,#5A,#38,#79,#01
	DB	#30,#A3,#55,#BD,#43,#C2,#01
	DB	#41,#9D,#30,#A3,#55,#BD,#01
	DB	#28,#7F,#41,#9D,#30,#A3,#02
	DB	#38,#79,#28,#7F,#41,#9D,#02
	DB	#6E,#17,#58,#2F,#A3,#74,#01
	DB	#6E,#D5,#9E,#DC,#8D,#E2,#02
	DB	#7E,#CF,#6E,#D5,#9E,#DC,#02
	DB	#89,#0B,#6E,#17,#A3,#74,#02
	DB	#A3,#74,#BC,#DB,#9E,#DC,#02
	DB	#47,#36,#4B,#4F,#3A,#55,#01
	DB	#58,#2F,#47,#36,#4B,#4F,#01
	DB	#A3,#74,#7E,#CF,#9E,#DC,#01
	DB	#55,#BD,#7E,#CF,#6E,#D5,#01
	DB	#64,#B8,#55,#BD,#7E,#CF,#01
	DB	#A3,#74,#64,#B8,#7E,#CF,#02
	DB	#4B,#4F,#A3,#74,#4A,#74,#01
	DB	#3A,#55,#4A,#74,#38,#79,#02
	DB	#4B,#4F,#3A,#55,#4A,#74,#02
	DB	#41,#9D,#64,#B8,#55,#BD,#02
	DB	#52,#98,#41,#9D,#64,#B8,#02
	DB	#58,#2F,#4B,#4F,#A3,#74,#02
	DB	#38,#79,#52,#98,#41,#9D,#01
	DB	#4A,#74,#38,#79,#52,#98,#01
	DB	#A3,#74,#52,#98,#64,#B8,#01
	DB	#A3,#74,#4A,#74,#52,#98,#82
; Taille 686 octets
;Hex
	DB	''DUWS''
	DB	#02			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#52,#17,#95,#24,#21,#3D,#01
	DB	#21,#3D,#34,#72,#77,#7F,#01
	DB	#95,#23,#A7,#57,#77,#7F,#01
	DB	#95,#23,#21,#3D,#77,#7F,#01
	DB	#21,#3D,#34,#72,#34,#81,#02
	DB	#21,#3D,#21,#51,#34,#81,#02
	DB	#57,#26,#63,#3F,#34,#41,#02
	DB	#63,#3F,#34,#41,#41,#66,#03
	DB	#63,#3F,#41,#66,#70,#70,#02
	DB	#63,#3F,#7E,#4A,#70,#70,#00
	DB	#7E,#4A,#88,#5D,#70,#70,#00
	DB	#63,#3F,#7B,#41,#7E,#4A,#00
	DB	#57,#26,#85,#2E,#85,#2F,#00
	DB	#85,#2E,#85,#2F,#63,#3F,#00
	DB	#63,#41,#94,#53,#94,#54,#00
	DB	#94,#54,#70,#6D,#70,#70,#00
	DB	#84,#2E,#85,#2F,#94,#54,#00
	DB	#85,#2C,#7C,#41,#7B,#41,#00
	DB	#7C,#41,#94,#53,#94,#54,#00
	DB	#A8,#57,#EB,#64,#77,#7D,#01
	DB	#77,#7D,#8A,#B2,#CD,#BF,#01
	DB	#EB,#63,#FD,#97,#CD,#BF,#01
	DB	#EB,#63,#77,#7D,#CD,#BF,#01
	DB	#8A,#B2,#CD,#BF,#8A,#C1,#02
	DB	#CD,#BF,#8A,#C1,#CD,#CE,#02
	DB	#FD,#97,#CD,#BF,#CD,#CE,#02
	DB	#FD,#97,#FD,#A6,#CD,#CE,#02
	DB	#AD,#66,#B9,#7F,#8A,#81,#02
	DB	#B9,#7F,#8A,#81,#97,#A6,#03
	DB	#B9,#7F,#97,#A6,#C6,#B0,#02
	DB	#B9,#7F,#D4,#8A,#C6,#B0,#00
	DB	#D4,#8A,#DE,#9D,#C6,#B0,#00
	DB	#B9,#7F,#D1,#81,#D4,#8A,#00
	DB	#AD,#66,#DB,#6E,#DB,#6F,#00
	DB	#DB,#6E,#DB,#6F,#B9,#7F,#00
	DB	#B9,#81,#EA,#93,#EA,#94,#00
	DB	#EA,#94,#C6,#AD,#C6,#B0,#00
	DB	#DA,#6E,#DB,#6F,#EA,#94,#00
	DB	#DB,#6C,#D2,#81,#D1,#81,#00
	DB	#D2,#81,#EA,#93,#EA,#94,#00
	DB	#35,#72,#78,#7F,#04,#98,#01
	DB	#04,#98,#17,#CD,#5A,#DA,#01
	DB	#78,#7E,#8A,#B2,#5A,#DA,#01
	DB	#78,#7E,#04,#98,#5A,#DA,#01
	DB	#04,#98,#17,#CD,#17,#DC,#02
	DB	#04,#98,#04,#AC,#17,#DC,#02
	DB	#17,#CD,#5A,#DA,#17,#DC,#02
	DB	#5A,#DA,#17,#DC,#5A,#E9,#02
	DB	#8A,#B2,#5A,#DA,#5A,#E9,#02
	DB	#8A,#B2,#8A,#C1,#5A,#E9,#02
	DB	#3A,#81,#46,#9A,#17,#9C,#02
	DB	#46,#9A,#17,#9C,#24,#C1,#03
	DB	#46,#9A,#24,#C1,#53,#CB,#02
	DB	#46,#9A,#61,#A5,#53,#CB,#00
	DB	#61,#A5,#6B,#B8,#53,#CB,#00
	DB	#46,#9A,#5E,#9C,#61,#A5,#00
	DB	#3A,#81,#68,#89,#68,#8A,#00
	DB	#68,#89,#68,#8A,#46,#9A,#00
	DB	#46,#9C,#77,#AE,#77,#AF,#00
	DB	#77,#AF,#53,#C8,#53,#CB,#00
	DB	#67,#89,#68,#8A,#77,#AF,#00
	DB	#68,#87,#5F,#9C,#5E,#9C,#00
	DB	#5F,#9C,#77,#AE,#77,#AF,#80
; Taille 441 octets
;World
	DB	''DVNK''
	DB	#06			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#D6,#21,#E0,#2C,#D7,#2D,#01
	DB	#D7,#2D,#D2,#44,#D6,#4E,#01
	DB	#D6,#21,#C2,#2B,#D2,#45,#01
	DB	#C5,#1E,#D6,#21,#AE,#22,#01
	DB	#D6,#21,#AE,#22,#C2,#2B,#01
	DB	#C3,#2C,#AD,#3B,#CC,#4B,#01
	DB	#C3,#2C,#D2,#46,#CC,#4B,#01
	DB	#CD,#4B,#A7,#66,#B5,#70,#01
	DB	#AD,#3B,#CD,#4B,#A8,#67,#01
	DB	#AF,#22,#A7,#2A,#AD,#3C,#01
	DB	#AF,#22,#C4,#2D,#AD,#3C,#01
	DB	#8F,#46,#97,#58,#A8,#67,#01
	DB	#AD,#3C,#8F,#46,#A8,#67,#01
	DB	#8F,#29,#A8,#2A,#AD,#3C,#01
	DB	#8F,#29,#AE,#3C,#8F,#47,#01
	DB	#9C,#21,#B0,#22,#98,#28,#01
	DB	#B0,#22,#98,#28,#A8,#2C,#01
	DB	#7E,#1E,#8B,#25,#6D,#31,#01
	DB	#8B,#25,#6E,#32,#90,#47,#01
	DB	#6F,#32,#68,#34,#6B,#41,#01
	DB	#6F,#32,#6C,#42,#72,#43,#01
	DB	#6F,#33,#74,#44,#7A,#47,#01
	DB	#6F,#33,#87,#42,#7A,#47,#01
	DB	#87,#42,#82,#4E,#7A,#4E,#01
	DB	#87,#42,#7A,#47,#7A,#4E,#01
	DB	#5F,#40,#6D,#42,#67,#46,#01
	DB	#62,#34,#5F,#40,#6D,#43,#01
	DB	#68,#34,#62,#35,#62,#36,#01
	DB	#68,#35,#63,#36,#6D,#43,#01
	DB	#6D,#24,#68,#2E,#6F,#33,#01
	DB	#6D,#24,#67,#2A,#68,#2E,#01
	DB	#7E,#1F,#74,#20,#6F,#33,#01
	DB	#7E,#1F,#78,#2A,#70,#34,#01
	DB	#CD,#4B,#D2,#51,#CF,#62,#01
	DB	#CE,#4D,#BF,#60,#D0,#63,#01
	DB	#BF,#61,#B6,#71,#C8,#77,#01
	DB	#C0,#62,#D1,#71,#C8,#78,#01
	DB	#C0,#62,#CA,#62,#D1,#72,#01
	DB	#C9,#78,#CA,#7F,#C4,#83,#01
	DB	#BB,#76,#BE,#84,#C5,#84,#01
	DB	#BB,#76,#C9,#79,#C5,#84,#01
	DB	#B6,#72,#A9,#74,#AF,#7E,#01
	DB	#A9,#68,#B6,#72,#A9,#74,#01
	DB	#91,#47,#85,#52,#8A,#58,#01
	DB	#91,#47,#8A,#58,#98,#58,#01
	DB	#D6,#77,#D0,#7D,#D1,#88,#01
	DB	#D6,#88,#DD,#94,#DD,#A2,#01
	DB	#D6,#88,#D6,#9B,#DD,#A2,#01
	DB	#D7,#89,#D3,#90,#D7,#9C,#01
	DB	#E3,#92,#E8,#92,#E5,#9D,#01
	DB	#E9,#92,#F2,#9B,#E6,#9D,#01
	DB	#F2,#9B,#E7,#9E,#F0,#A1,#01
	DB	#53,#6A,#62,#7B,#5A,#82,#01
	DB	#62,#7B,#5A,#83,#6A,#87,#01
	DB	#7A,#6E,#63,#7E,#83,#95,#01
	DB	#68,#83,#84,#96,#6E,#A2,#01
	DB	#84,#96,#6E,#A3,#7F,#A9,#01
	DB	#7B,#6F,#88,#79,#84,#97,#01
	DB	#8B,#9E,#85,#A5,#8E,#A5,#01
	DB	#8E,#A5,#86,#A6,#88,#AD,#01
	DB	#3E,#15,#2E,#16,#3C,#1C,#01
	DB	#2E,#16,#38,#1B,#37,#25,#01
	DB	#30,#16,#22,#1E,#37,#26,#01
	DB	#11,#16,#23,#20,#0B,#2B,#01
	DB	#02,#15,#12,#17,#0B,#2A,#01
	DB	#0C,#2B,#03,#3E,#25,#4E,#01
	DB	#23,#1F,#0C,#2B,#25,#4D,#01
	DB	#23,#20,#31,#23,#25,#4D,#01
	DB	#31,#23,#35,#2E,#25,#4E,#01
	DB	#32,#24,#46,#28,#35,#2E,#01
	DB	#46,#28,#35,#2F,#46,#32,#01
	DB	#04,#3E,#26,#4E,#1D,#55,#01
	DB	#04,#3E,#1E,#57,#22,#73,#01
	DB	#23,#73,#0D,#8A,#14,#9A,#01
	DB	#23,#74,#14,#9B,#33,#A9,#01
	DB	#23,#75,#38,#93,#34,#AA,#01
	DB	#3B,#86,#41,#94,#35,#AA,#01
	DB	#2A,#7E,#3B,#87,#38,#93,#01
	DB	#16,#9B,#33,#B8,#27,#C4,#01
	DB	#16,#9B,#35,#AA,#34,#B9,#01
	DB	#19,#BC,#27,#C5,#17,#D1,#01
	DB	#8B,#58,#98,#59,#9A,#69,#02
	DB	#8B,#59,#85,#61,#92,#74,#02
	DB	#8B,#5A,#9A,#69,#92,#74,#02
	DB	#9B,#6A,#93,#74,#9B,#76,#02
	DB	#F5,#A3,#EE,#AD,#F9,#B2,#02
	DB	#F9,#B2,#FE,#BF,#EB,#C8,#02
	DB	#EF,#AE,#F9,#B3,#EB,#C9,#02
	DB	#E0,#AC,#F0,#AE,#EB,#C9,#02
	DB	#E1,#AD,#D5,#B9,#EB,#CA,#02
	DB	#D6,#BA,#EB,#CA,#DC,#CF,#02
	DB	#FF,#BE,#EC,#C8,#F0,#CF,#02
	DB	#FF,#BE,#F1,#CF,#FA,#DE,#02
	DB	#70,#4B,#58,#53,#53,#68,#02
	DB	#70,#4B,#53,#68,#61,#7E,#02
	DB	#70,#4B,#79,#6E,#62,#7E,#02
	DB	#6F,#A3,#80,#AB,#75,#B3,#02
	DB	#6F,#A4,#6B,#B5,#76,#B5,#02
	DB	#70,#4B,#7C,#55,#7A,#6F,#02
	DB	#7C,#55,#86,#62,#7A,#6F,#02
	DB	#86,#63,#7B,#6F,#88,#78,#02
	DB	#88,#79,#92,#7E,#84,#97,#02
	DB	#15,#9B,#17,#BB,#26,#C4,#02
	DB	#5F,#0E,#43,#0F,#57,#26,#03
	DB	#4C,#15,#58,#1D,#46,#1F,#03
	DB	#B1,#E7,#8A,#F1,#C3,#F1,#03
	DB	#28,#E6,#1C,#F1,#22,#F1,#83
; Taille 749 octets
;Linux
	DB	''WKTL''
	DB	#08			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#7C,#01,#72,#04,#90,#23,#01
	DB	#7B,#01,#93,#10,#90,#23,#01
	DB	#92,#10,#A1,#12,#8F,#2A,#01
	DB	#A1,#12,#AC,#19,#80,#37,#01
	DB	#81,#21,#A0,#21,#80,#36,#01
	DB	#AC,#19,#80,#36,#BF,#3F,#01
	DB	#80,#36,#BF,#3E,#AA,#54,#01
	DB	#80,#36,#AA,#54,#9A,#5C,#01
	DB	#81,#37,#6F,#57,#9A,#5C,#01
	DB	#6F,#57,#9A,#5C,#63,#8F,#01
	DB	#9A,#5C,#62,#8F,#99,#91,#01
	DB	#62,#8F,#9A,#91,#64,#B8,#01
	DB	#99,#91,#64,#B8,#A6,#C0,#01
	DB	#64,#B8,#A6,#C0,#6E,#E4,#01
	DB	#A5,#C0,#B9,#D1,#6E,#E4,#01
	DB	#B9,#D1,#6E,#E4,#8A,#F8,#01
	DB	#B7,#D2,#8A,#F8,#A5,#FE,#01
	DB	#6E,#E4,#5F,#F3,#89,#F7,#01
	DB	#5F,#F3,#89,#F7,#67,#F8,#01
	DB	#8B,#F8,#88,#FE,#A5,#FE,#01
	DB	#AA,#F0,#A6,#FC,#AC,#FE,#01
	DB	#72,#04,#90,#23,#82,#23,#02
	DB	#81,#37,#63,#55,#6F,#58,#02
	DB	#63,#55,#53,#89,#62,#8E,#02
	DB	#63,#55,#6F,#58,#63,#8F,#02
	DB	#52,#88,#63,#8E,#54,#B7,#02
	DB	#63,#8E,#54,#B7,#64,#C0,#02
	DB	#BF,#3E,#A8,#55,#D1,#76,#02
	DB	#A8,#55,#D1,#76,#D1,#A4,#02
	DB	#A8,#55,#9A,#5C,#99,#90,#02
	DB	#A8,#55,#99,#91,#A6,#C1,#02
	DB	#A8,#55,#D1,#A4,#A5,#C0,#02
	DB	#D1,#A3,#A5,#C0,#BB,#D3,#02
	DB	#D1,#A3,#D1,#B9,#BB,#D3,#02
	DB	#9B,#19,#99,#1D,#9B,#20,#02
	DB	#9B,#19,#A1,#19,#A3,#1D,#02
	DB	#A3,#1D,#9B,#20,#A1,#21,#02
	DB	#9B,#19,#A3,#1D,#9B,#20,#82
; Taille 266 octets
;Hippo
	DB	''D@T'',92
	DB	#08			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#65,#0A,#80,#0F,#80,#34,#01
	DB	#65,#0A,#4B,#0E,#80,#34,#01
	DB	#4B,#0E,#36,#34,#80,#34,#01
	DB	#44,#02,#30,#02,#4B,#0E,#01
	DB	#30,#02,#4B,#0E,#30,#14,#01
	DB	#4B,#0E,#30,#14,#43,#1D,#01
	DB	#36,#34,#80,#34,#44,#78,#01
	DB	#80,#34,#44,#78,#48,#B0,#01
	DB	#44,#78,#48,#B0,#21,#BE,#01
	DB	#80,#34,#21,#BE,#73,#FF,#01
	DB	#80,#34,#80,#FF,#73,#FF,#01
	DB	#3A,#48,#49,#4D,#42,#53,#02
	DB	#59,#AC,#47,#B1,#63,#BF,#02
	DB	#47,#B1,#63,#BF,#4E,#C4,#02
	DB	#21,#BE,#2D,#E4,#73,#FF,#01
	DB	#91,#61,#96,#7F,#94,#94,#03
	DB	#7D,#F1,#83,#F2,#60,#F5,#03
	DB	#34,#05,#42,#0B,#45,#17,#03
	DB	#38,#37,#4A,#39,#4E,#3D,#03
	DB	#4C,#38,#4B,#3B,#52,#47,#03
	DB	#50,#67,#43,#7B,#41,#80,#03
	DB	#33,#AE,#2D,#C0,#2E,#C2,#03
	DB	#5A,#AF,#65,#BF,#64,#C1,#83
; Taille 161 octets
;Elephant
	DB	''TFLN''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#7F,#12,#61,#1B,#6E,#65,#02
	DB	#7F,#12,#9F,#1B,#93,#65,#02
	DB	#93,#65,#93,#9E,#70,#A3,#02
	DB	#93,#65,#6E,#65,#70,#A3,#03
	DB	#7F,#12,#6E,#65,#93,#65,#03
	DB	#61,#1B,#4F,#2E,#6E,#65,#03
	DB	#9F,#1B,#B1,#2E,#93,#65,#03
	DB	#4F,#2E,#50,#59,#6E,#65,#01
	DB	#B1,#2E,#AF,#59,#93,#65,#01
	DB	#93,#9E,#70,#A3,#73,#C1,#03
	DB	#93,#9E,#73,#C1,#88,#E2,#01
	DB	#73,#C1,#70,#E1,#88,#E2,#03
	DB	#70,#E1,#88,#E2,#84,#F3,#01
	DB	#70,#E1,#84,#F3,#6F,#F5,#03
	DB	#6E,#65,#56,#9B,#70,#A3,#01
	DB	#93,#65,#AA,#9B,#93,#9E,#01
	DB	#50,#59,#6E,#65,#61,#78,#03
	DB	#AF,#59,#93,#65,#9F,#78,#03
	DB	#80,#53,#6E,#65,#93,#65,#01
	DB	#31,#11,#61,#1B,#4F,#2E,#01
	DB	#CE,#11,#9F,#1B,#B1,#2E,#01
	DB	#31,#11,#14,#2B,#4F,#2E,#03
	DB	#CE,#11,#EB,#2B,#B1,#2E,#03
	DB	#14,#2B,#4F,#2E,#01,#5C,#01
	DB	#EB,#2B,#B1,#2E,#FE,#5C,#01
	DB	#50,#59,#01,#5C,#10,#73,#03
	DB	#AF,#59,#FE,#5C,#EF,#73,#03
	DB	#50,#59,#10,#73,#25,#7C,#01
	DB	#AF,#59,#EF,#73,#DA,#7C,#01
	DB	#50,#59,#25,#7C,#45,#9B,#03
	DB	#AF,#59,#DA,#7C,#BB,#9B,#03
	DB	#50,#59,#56,#9B,#45,#9B,#01
	DB	#AF,#59,#AA,#9B,#BB,#9B,#01
	DB	#56,#9B,#70,#A3,#64,#A8,#03
	DB	#AA,#9B,#93,#9E,#9B,#A8,#03
	DB	#5B,#A0,#64,#A8,#56,#C5,#02
	DB	#A3,#A1,#9B,#A8,#A9,#C5,#02
	DB	#5B,#A0,#4C,#C2,#56,#C5,#03
	DB	#A3,#A1,#B3,#C2,#A9,#C5,#03
	DB	#4C,#C2,#56,#C5,#56,#CF,#02
	DB	#B3,#C2,#A9,#C5,#AA,#CF,#82
; Taille 287 octets
;Elephant2
	DB	''O_[K''
	DB	#07			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#92,#2C,#85,#37,#9F,#57,#01
	DB	#92,#2C,#A6,#36,#9E,#57,#01
	DB	#AB,#3A,#9D,#57,#AE,#62,#01
	DB	#A6,#36,#AB,#3A,#9E,#56,#01
	DB	#B5,#39,#C3,#3C,#AC,#69,#01
	DB	#C3,#3C,#AC,#6A,#B1,#6E,#01
	DB	#C2,#3C,#CA,#4D,#B1,#6E,#01
	DB	#B9,#79,#BF,#81,#B2,#88,#01
	DB	#BF,#81,#B2,#88,#BC,#96,#01
	DB	#BD,#92,#BB,#95,#C2,#9F,#01
	DB	#D4,#80,#BF,#84,#DC,#A4,#01
	DB	#D2,#7F,#E3,#95,#DC,#A4,#01
	DB	#F0,#60,#EF,#67,#F7,#68,#01
	DB	#F6,#60,#EF,#60,#F7,#68,#01
	DB	#88,#40,#8E,#72,#7A,#7F,#01
	DB	#88,#40,#7A,#68,#7A,#7F,#01
	DB	#63,#3E,#44,#40,#58,#78,#01
	DB	#5B,#7F,#71,#90,#66,#99,#01
	DB	#5B,#7F,#7A,#81,#71,#90,#01
	DB	#33,#74,#58,#7B,#3F,#95,#01
	DB	#33,#49,#10,#58,#33,#6E,#01
	DB	#20,#7E,#11,#87,#3F,#98,#01
	DB	#11,#87,#3F,#98,#37,#A0,#01
	DB	#07,#78,#12,#83,#04,#87,#01
	DB	#18,#8E,#20,#A0,#15,#B3,#01
	DB	#19,#8E,#0C,#9E,#15,#B3,#01
	DB	#74,#95,#86,#BB,#75,#BD,#01
	DB	#7B,#88,#8A,#9D,#85,#BB,#01
	DB	#7B,#88,#73,#97,#85,#BA,#01
	DB	#A5,#90,#89,#9E,#9D,#B3,#01
	DB	#A5,#90,#AE,#AB,#9B,#B2,#01
	DB	#B6,#3C,#A9,#3D,#AF,#58,#02
	DB	#C6,#51,#B0,#6C,#C1,#82,#02
	DB	#C6,#54,#D2,#7A,#C3,#7D,#02
	DB	#E4,#94,#EA,#95,#DC,#A6,#02
	DB	#EA,#94,#F5,#A1,#DD,#A4,#02
	DB	#F7,#75,#EA,#95,#F3,#A0,#02
	DB	#F1,#74,#F7,#76,#EA,#95,#02
	DB	#F9,#66,#F1,#68,#F7,#74,#02
	DB	#F9,#66,#FE,#73,#F6,#75,#02
	DB	#AB,#5D,#95,#6D,#A8,#7F,#02
	DB	#AB,#5D,#B7,#6C,#AA,#7F,#02
	DB	#A8,#5F,#8D,#63,#97,#6D,#02
	DB	#87,#46,#A8,#5E,#8E,#61,#02
	DB	#8F,#73,#A2,#79,#79,#84,#02
	DB	#78,#87,#A9,#8F,#8E,#9A,#02
	DB	#97,#7F,#77,#88,#A9,#8F,#02
	DB	#AB,#AD,#9B,#B2,#A3,#C5,#02
	DB	#AB,#AD,#B1,#BF,#A2,#C5,#02
	DB	#B7,#BF,#9F,#C6,#A2,#CD,#02
	DB	#B7,#BF,#B5,#C8,#A2,#CC,#02
	DB	#85,#BD,#76,#BF,#73,#C8,#02
	DB	#85,#BC,#74,#C7,#85,#CB,#02
	DB	#85,#BC,#8B,#C6,#85,#CB,#02
	DB	#86,#43,#67,#46,#7C,#6C,#02
	DB	#63,#47,#7C,#6C,#58,#80,#02
	DB	#75,#74,#62,#7A,#74,#82,#02
	DB	#44,#42,#3A,#71,#58,#78,#02
	DB	#45,#42,#2D,#44,#3A,#71,#02
	DB	#13,#5B,#31,#70,#0A,#77,#02
	DB	#2C,#70,#0A,#77,#13,#85,#02
	DB	#31,#72,#23,#7E,#41,#99,#02
	DB	#59,#80,#3F,#94,#55,#A0,#02
	DB	#59,#83,#64,#97,#57,#99,#02
	DB	#1A,#8F,#2B,#B0,#3D,#C0,#02
	DB	#19,#8F,#38,#A1,#3D,#C0,#02
	DB	#0B,#A3,#01,#BA,#08,#C3,#02
	DB	#0B,#A3,#08,#C4,#1E,#C5,#02
	DB	#24,#AA,#24,#BE,#2D,#C6,#02
	DB	#23,#AA,#2D,#C6,#46,#C9,#82
; Taille 490 octets
;Girafe
	DB	''WJNT''
	DB	#07			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#61,#01,#54,#0E,#5E,#37,#01
	DB	#61,#01,#74,#04,#5E,#37,#01
	DB	#74,#04,#5E,#37,#6A,#43,#02
	DB	#5E,#37,#6A,#43,#54,#4C,#01
	DB	#6A,#43,#54,#4C,#80,#53,#02
	DB	#54,#4C,#80,#53,#56,#63,#01
	DB	#80,#53,#56,#63,#72,#7C,#02
	DB	#56,#63,#55,#73,#72,#7C,#01
	DB	#55,#73,#72,#7C,#60,#87,#01
	DB	#55,#73,#52,#82,#60,#87,#01
	DB	#52,#82,#60,#87,#4A,#8D,#01
	DB	#60,#87,#4A,#8D,#52,#96,#01
	DB	#56,#63,#55,#73,#46,#7B,#01
	DB	#4E,#6E,#2F,#73,#46,#7B,#01
	DB	#33,#54,#4E,#6E,#2F,#73,#01
	DB	#45,#4C,#33,#54,#4E,#6E,#03
	DB	#45,#4C,#56,#63,#4E,#6E,#02
	DB	#30,#47,#45,#4C,#33,#54,#03
	DB	#1A,#43,#30,#47,#33,#54,#03
	DB	#1A,#43,#1B,#4E,#33,#54,#01
	DB	#1B,#4E,#33,#54,#2F,#74,#01
	DB	#54,#73,#46,#7B,#4A,#84,#03
	DB	#54,#73,#52,#82,#4A,#84,#03
	DB	#52,#82,#4A,#85,#4A,#8E,#01
	DB	#80,#53,#72,#7C,#80,#9A,#02
	DB	#72,#7C,#80,#9A,#74,#A1,#01
	DB	#80,#9A,#74,#A1,#73,#C8,#01
	DB	#80,#9A,#73,#C8,#80,#CC,#02
	DB	#73,#C8,#80,#CC,#78,#E1,#03
	DB	#80,#CC,#78,#E1,#80,#FA,#02
	DB	#78,#E1,#68,#EA,#80,#FA,#01
	DB	#68,#EA,#70,#FA,#80,#FA,#02
	DB	#66,#D2,#78,#E1,#68,#EA,#01
	DB	#74,#C8,#66,#D2,#78,#E1,#02
	DB	#74,#A2,#74,#C8,#66,#D2,#02
	DB	#74,#A2,#58,#C3,#66,#D2,#01
	DB	#57,#A0,#74,#A2,#58,#C3,#02
	DB	#68,#81,#57,#A0,#74,#A2,#01
	DB	#72,#7B,#68,#81,#74,#A2,#02
	DB	#68,#81,#52,#94,#57,#A0,#81
; Taille 280 octets
;Rhino
	DB	''N@KT''
	DB	#09			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#5D,#00,#29,#0F,#89,#27,#01
	DB	#29,#0F,#89,#27,#0A,#38,#01
	DB	#89,#27,#0A,#38,#00,#6E,#01
	DB	#89,#27,#00,#6E,#0C,#B7,#01
	DB	#89,#27,#0C,#B7,#20,#D3,#01
	DB	#89,#27,#20,#D3,#57,#EC,#01
	DB	#89,#27,#60,#EC,#57,#EC,#01
	DB	#89,#27,#72,#E7,#57,#EC,#01
	DB	#89,#27,#83,#D6,#72,#E7,#01
	DB	#89,#27,#9B,#31,#83,#D6,#01
	DB	#9B,#31,#AE,#48,#83,#D6,#01
	DB	#AE,#48,#D0,#94,#83,#D6,#01
	DB	#D0,#94,#83,#D6,#9D,#F0,#01
	DB	#D0,#94,#9D,#F0,#B4,#FD,#01
	DB	#D0,#94,#CE,#F8,#B4,#FD,#01
	DB	#D0,#94,#DE,#EB,#CE,#F8,#01
	DB	#D0,#94,#E6,#DD,#DE,#EB,#01
	DB	#D7,#97,#C8,#CF,#E0,#D4,#01
	DB	#CA,#90,#D7,#97,#CF,#DE,#01
	DB	#A8,#19,#9B,#31,#AE,#48,#01
	DB	#A8,#19,#B7,#3B,#AE,#48,#01
	DB	#B8,#0E,#A8,#19,#B7,#3B,#01
	DB	#B8,#0E,#CB,#18,#B7,#3B,#01
	DB	#C7,#63,#B1,#81,#B9,#92,#02
	DB	#C7,#63,#CF,#81,#B9,#92,#02
	DB	#CF,#81,#CC,#92,#B9,#92,#02
	DB	#F9,#67,#F0,#79,#FF,#84,#02
	DB	#F0,#79,#FF,#84,#E1,#92,#02
	DB	#FF,#84,#E1,#92,#FC,#A6,#02
	DB	#E1,#92,#D9,#98,#FC,#A6,#02
	DB	#D9,#98,#FC,#A6,#E1,#CD,#02
	DB	#D9,#98,#E1,#CD,#D6,#CF,#02
	DB	#D9,#98,#C3,#C4,#D6,#CF,#02
	DB	#D9,#98,#BF,#B2,#C3,#C4,#02
	DB	#D9,#98,#C7,#9B,#BF,#B2,#02
	DB	#A5,#E3,#B2,#E3,#B9,#EB,#03
	DB	#A5,#E3,#AC,#EA,#B9,#EB,#03
	DB	#98,#A9,#8A,#AB,#93,#AE,#03
	DB	#83,#9D,#98,#A9,#8A,#AB,#03
	DB	#5B,#10,#5C,#10,#69,#3F,#03
	DB	#5B,#10,#3E,#18,#3E,#19,#03
	DB	#3E,#19,#53,#37,#54,#37,#03
	DB	#58,#38,#57,#39,#4B,#74,#03
	DB	#4A,#74,#4B,#74,#4E,#9A,#03
	DB	#4C,#9B,#69,#C6,#6A,#C6,#03
	DB	#69,#C6,#82,#D6,#83,#D6,#83
; Taille 322 octets
;Dolphin
	DB	''D_ST''
	DB	#09			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#82,#A3,#74,#AC,#82,#BC,#01
	DB	#BF,#29,#DF,#4C,#CC,#5C,#01
	DB	#DE,#4C,#CC,#5C,#E0,#74,#01
	DB	#D4,#21,#B5,#22,#CD,#37,#01
	DB	#D2,#2C,#C6,#32,#DE,#4B,#01
	DB	#BF,#28,#CD,#5D,#B6,#66,#01
	DB	#99,#0F,#D4,#21,#B4,#25,#01
	DB	#9B,#0F,#E2,#12,#D2,#23,#01
	DB	#D6,#02,#99,#10,#E2,#12,#01
	DB	#82,#A3,#A6,#A8,#83,#BB,#01
	DB	#A6,#A7,#81,#BB,#96,#C4,#01
	DB	#A6,#A6,#B8,#BA,#94,#C6,#01
	DB	#B8,#BA,#95,#C5,#B5,#D3,#01
	DB	#95,#C5,#B6,#D2,#91,#D7,#01
	DB	#93,#D5,#9B,#EA,#AE,#EC,#01
	DB	#B5,#D2,#93,#D6,#AE,#ED,#01
	DB	#9C,#EA,#AE,#EC,#98,#FD,#01
	DB	#AC,#9B,#A5,#A6,#B9,#BB,#01
	DB	#D9,#97,#AC,#9C,#B4,#BC,#01
	DB	#CA,#5A,#E1,#73,#D8,#95,#01
	DB	#CC,#5D,#B6,#66,#D9,#99,#01
	DB	#B8,#67,#D9,#98,#B2,#9B,#01
	DB	#97,#0F,#C0,#29,#B7,#64,#01
	DB	#71,#00,#A9,#0A,#84,#3B,#01
	DB	#9D,#15,#84,#39,#B0,#50,#01
	DB	#74,#00,#58,#05,#84,#3A,#01
	DB	#87,#39,#85,#4E,#71,#51,#01
	DB	#86,#4E,#6F,#50,#81,#6A,#01
	DB	#84,#4F,#91,#68,#81,#6A,#01
	DB	#58,#05,#87,#3B,#6F,#52,#01
	DB	#58,#05,#68,#39,#45,#43,#01
	DB	#58,#04,#3B,#1B,#4B,#38,#01
	DB	#3B,#19,#32,#2E,#4C,#37,#01
	DB	#32,#2E,#47,#35,#23,#3E,#01
	DB	#34,#2E,#1E,#38,#25,#3E,#01
	DB	#4A,#36,#45,#45,#2B,#48,#01
	DB	#21,#45,#35,#47,#2C,#4C,#01
	DB	#56,#06,#77,#0B,#54,#11,#02
	DB	#56,#07,#4D,#0F,#56,#11,#02
	DB	#5B,#39,#4E,#41,#6B,#43,#02
	DB	#67,#39,#5B,#3A,#6A,#43,#02
	DB	#87,#3A,#86,#45,#B1,#50,#02
	DB	#86,#45,#AF,#4F,#B8,#65,#02
	DB	#A3,#56,#B8,#64,#B7,#81,#02
	DB	#B7,#82,#B4,#9F,#A6,#A6,#02
	DB	#B4,#7A,#B9,#82,#B2,#8C,#02
	DB	#55,#28,#59,#2F,#50,#30,#03
	DB	#55,#28,#5D,#28,#59,#2F,#83
; Taille 336 octets
;Goupil
	DB	''JKNT''
	DB	#0F			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#16,#00,#40,#21,#37,#28,#02
	DB	#16,#00,#37,#28,#1F,#39,#01
	DB	#72,#00,#48,#21,#51,#28,#02
	DB	#72,#00,#51,#28,#69,#39,#01
	DB	#44,#1E,#00,#4D,#43,#56,#01
	DB	#11,#6E,#77,#6E,#44,#E0,#02
	DB	#44,#1E,#87,#4D,#43,#56,#01
	DB	#44,#44,#11,#6E,#44,#95,#01
	DB	#44,#44,#77,#6E,#44,#95,#01
	DB	#44,#1E,#24,#34,#44,#77,#02
	DB	#44,#1E,#64,#34,#44,#77,#02
	DB	#44,#1E,#35,#6B,#44,#6D,#02
	DB	#44,#1E,#53,#6B,#44,#6D,#02
	DB	#32,#41,#3C,#41,#3D,#4B,#03
	DB	#4C,#41,#57,#41,#4C,#4B,#03
	DB	#44,#6C,#3C,#77,#44,#77,#03
	DB	#41,#6C,#3C,#77,#4C,#77,#03
	DB	#41,#6C,#47,#6C,#4C,#77,#03
	DB	#35,#6B,#3A,#70,#3C,#77,#03
	DB	#53,#6C,#4E,#70,#4B,#77,#03
	DB	#29,#80,#5F,#80,#45,#E0,#01
	DB	#64,#88,#89,#96,#45,#E0,#02
	DB	#89,#96,#A6,#AE,#45,#E0,#02
	DB	#A6,#AE,#A6,#E0,#45,#E0,#02
	DB	#DA,#7A,#A6,#86,#A6,#E0,#02
	DB	#DA,#4C,#DA,#7A,#A6,#86,#02
	DB	#DA,#4C,#FF,#79,#DA,#7A,#02
	DB	#FF,#79,#DA,#7A,#A6,#E0,#02
	DB	#FF,#4B,#DA,#4C,#FF,#79,#81
; Taille 203 octets
;Cerf
	DB	''V'',92,''NT''
	DB	#0F			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#33,#00,#2D,#22,#37,#29,#01
	DB	#2D,#22,#37,#29,#1A,#30,#01
	DB	#37,#29,#1A,#30,#21,#38,#01
	DB	#19,#02,#1A,#2F,#10,#36,#01
	DB	#1A,#2F,#10,#36,#35,#62,#01
	DB	#1A,#2F,#3B,#55,#35,#62,#01
	DB	#64,#39,#3B,#55,#49,#5A,#01
	DB	#3B,#55,#35,#62,#5F,#71,#01
	DB	#3B,#55,#6F,#66,#5F,#71,#01
	DB	#6F,#66,#5F,#71,#63,#7E,#01
	DB	#6F,#66,#7B,#78,#63,#7E,#01
	DB	#80,#76,#59,#80,#68,#F2,#02
	DB	#80,#76,#68,#F2,#80,#FF,#02
	DB	#4D,#72,#62,#7F,#4B,#81,#02
	DB	#62,#7F,#4B,#81,#5B,#99,#02
	DB	#63,#9D,#6A,#A6,#66,#AA,#03
	DB	#31,#6F,#4D,#73,#2B,#79,#02
	DB	#4D,#73,#2B,#79,#55,#8E,#02
	DB	#2C,#79,#37,#8B,#58,#8E,#02
	DB	#4E,#79,#4B,#7B,#5A,#81,#03
	DB	#35,#75,#4D,#7A,#4B,#7B,#03
	DB	#61,#B8,#62,#D6,#68,#EE,#02
	DB	#74,#EC,#6F,#ED,#75,#F1,#03
	DB	#6F,#ED,#75,#F1,#72,#F2,#83
; Taille 168 octets
;Loup
	DB	''DT'',92,''L''
	DB	#08			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#77,#1C,#99,#22,#73,#38,#02
	DB	#98,#22,#9D,#37,#73,#38,#02
	DB	#D9,#1E,#D7,#39,#CD,#3B,#01
	DB	#8F,#27,#8F,#2D,#7E,#2F,#01
	DB	#89,#26,#8F,#27,#7E,#2F,#01
	DB	#CE,#00,#C5,#06,#D8,#0B,#01
	DB	#CD,#00,#D7,#04,#D7,#0A,#01
	DB	#C7,#05,#99,#22,#9E,#37,#02
	DB	#C7,#05,#D7,#0B,#9E,#37,#02
	DB	#D7,#0B,#D9,#1E,#9E,#37,#02
	DB	#D9,#1E,#9E,#37,#CD,#3A,#02
	DB	#78,#1C,#5F,#25,#45,#50,#02
	DB	#77,#1D,#46,#4D,#6E,#5E,#02
	DB	#DE,#37,#E4,#3F,#C4,#71,#02
	DB	#DF,#37,#C8,#3D,#C4,#70,#02
	DB	#73,#37,#CC,#38,#65,#F1,#02
	DB	#49,#47,#A9,#6F,#10,#73,#02
	DB	#2E,#71,#15,#A0,#DF,#B9,#02
	DB	#B9,#56,#82,#A6,#DF,#B8,#02
	DB	#C7,#40,#B7,#58,#C4,#73,#02
	DB	#6F,#6F,#2E,#72,#6D,#8C,#02
	DB	#DF,#B8,#C4,#F5,#D8,#FE,#02
	DB	#DE,#B9,#64,#E6,#B8,#F6,#02
	DB	#8B,#AC,#DE,#B9,#6B,#E7,#02
	DB	#7E,#EB,#B7,#F5,#A2,#F9,#02
	DB	#86,#DA,#97,#F4,#84,#F9,#02
	DB	#8F,#C3,#67,#ED,#80,#F2,#02
	DB	#15,#A0,#96,#AD,#21,#AE,#02
	DB	#63,#A6,#20,#AE,#46,#F5,#02
	DB	#7C,#C8,#49,#EC,#55,#F8,#02
	DB	#72,#5F,#6A,#D5,#49,#EB,#82
; Taille 217 octets
;Panda
	DB	''VKTL''
	DB	#08			; Tps d''affichage
	DB	#00			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#17,#A7,#75,#AE,#36,#B0,#01
	DB	#03,#8B,#17,#A7,#75,#AE,#01
	DB	#04,#75,#03,#8B,#75,#AE,#01
	DB	#0E,#54,#04,#75,#75,#AE,#01
	DB	#2A,#3D,#0E,#54,#75,#AE,#01
	DB	#6A,#3C,#2A,#3D,#75,#AE,#01
	DB	#6A,#3C,#98,#5A,#75,#AE,#01
	DB	#9D,#4E,#DA,#AE,#75,#AE,#01
	DB	#9D,#4E,#F1,#A5,#DA,#AE,#01
	DB	#9D,#4E,#FF,#8D,#F1,#A5,#01
	DB	#AC,#48,#9D,#4E,#EE,#84,#01
	DB	#AC,#48,#CA,#55,#EE,#84,#01
	DB	#CA,#55,#DA,#6B,#F0,#77,#01
	DB	#DA,#6B,#F0,#77,#EE,#84,#01
	DB	#0E,#4D,#14,#50,#0D,#57,#02
	DB	#0E,#4D,#05,#55,#0D,#57,#02
	DB	#05,#55,#0E,#57,#09,#66,#02
	DB	#20,#66,#03,#75,#03,#8C,#02
	DB	#20,#66,#2C,#6D,#03,#8C,#02
	DB	#2C,#6D,#39,#82,#03,#8C,#02
	DB	#39,#82,#2E,#88,#03,#8C,#02
	DB	#2E,#88,#03,#8C,#22,#98,#02
	DB	#03,#8C,#22,#98,#17,#A7,#02
	DB	#22,#98,#17,#A7,#3C,#B2,#02
	DB	#2F,#9B,#32,#A7,#3C,#B2,#02
	DB	#37,#8C,#2F,#9B,#3C,#B2,#02
	DB	#43,#87,#37,#8C,#3C,#B2,#02
	DB	#43,#87,#52,#9E,#3C,#B2,#02
	DB	#52,#9E,#42,#B0,#3C,#B2,#02
	DB	#69,#3B,#59,#88,#8E,#92,#02
	DB	#59,#88,#8E,#92,#61,#9D,#02
	DB	#8E,#92,#61,#9D,#71,#AF,#02
	DB	#8E,#92,#71,#AF,#99,#BA,#02
	DB	#8E,#92,#A4,#9B,#99,#BA,#02
	DB	#A4,#9B,#B7,#AB,#99,#BA,#02
	DB	#B7,#AB,#BF,#BA,#99,#BA,#02
	DB	#9E,#4F,#95,#5E,#A1,#66,#02
	DB	#9E,#4F,#AF,#58,#A1,#66,#02
	DB	#AB,#47,#9E,#4F,#AF,#58,#02
	DB	#AB,#47,#B3,#4C,#AF,#58,#02
	DB	#B7,#48,#B3,#4C,#C9,#55,#02
	DB	#C4,#47,#B7,#48,#C9,#55,#02
	DB	#C4,#47,#CA,#4C,#C9,#55,#02
	DB	#BA,#90,#DB,#98,#C6,#9C,#02
	DB	#D9,#79,#BA,#90,#DB,#98,#02
	DB	#D9,#79,#C4,#7E,#BA,#90,#02
	DB	#D9,#79,#E2,#89,#DB,#98,#02
	DB	#F7,#8E,#FF,#8E,#F7,#9C,#82
; Taille 336 octets
;Lion
	DB	''TJLK''
	DB	#09			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#48,#16,#3A,#21,#4A,#24,#01
	DB	#3A,#21,#4A,#24,#2C,#27,#01
	DB	#6C,#47,#5E,#4A,#65,#5D,#01
	DB	#6C,#47,#76,#5C,#65,#5D,#01
	DB	#76,#5C,#6C,#5D,#6D,#6B,#01
	DB	#61,#53,#65,#5B,#52,#6F,#01
	DB	#56,#71,#52,#76,#57,#78,#01
	DB	#52,#76,#5A,#79,#5C,#87,#01
	DB	#62,#75,#6D,#77,#69,#88,#01
	DB	#7B,#67,#6D,#72,#75,#83,#01
	DB	#76,#81,#6C,#8E,#6F,#9F,#01
	DB	#7B,#67,#80,#82,#6F,#9F,#01
	DB	#80,#82,#80,#9D,#6F,#9F,#01
	DB	#6D,#91,#66,#97,#6F,#9D,#01
	DB	#5E,#8D,#66,#97,#5A,#98,#01
	DB	#66,#97,#5A,#98,#60,#A8,#01
	DB	#66,#97,#69,#A4,#60,#A8,#01
	DB	#69,#A4,#60,#A8,#5D,#B7,#01
	DB	#69,#A4,#5D,#B7,#70,#BF,#01
	DB	#69,#A4,#80,#AC,#70,#BF,#01
	DB	#80,#C2,#67,#C6,#6E,#D8,#01
	DB	#80,#C2,#80,#D6,#6E,#D8,#01
	DB	#62,#D9,#56,#DF,#5D,#E6,#01
	DB	#56,#DF,#5D,#E6,#52,#EC,#01
	DB	#5B,#EC,#58,#F1,#5A,#F5,#01
	DB	#58,#F1,#5A,#F5,#50,#F6,#01
	DB	#45,#D8,#39,#E1,#42,#E5,#01
	DB	#39,#E1,#42,#E5,#39,#EF,#01
	DB	#2F,#CB,#36,#D1,#30,#D8,#01
	DB	#2C,#CB,#1F,#D1,#28,#D5,#01
	DB	#2B,#BF,#31,#C8,#21,#D0,#01
	DB	#27,#B8,#2A,#BE,#21,#CA,#01
	DB	#49,#9F,#26,#B6,#31,#C9,#01
	DB	#20,#A4,#40,#A5,#1C,#BD,#01
	DB	#3D,#8E,#1F,#A4,#3D,#A5,#01
	DB	#3A,#88,#2D,#8B,#11,#B2,#01
	DB	#2D,#8B,#13,#9C,#11,#B2,#01
	DB	#07,#77,#2D,#8A,#00,#AA,#01
	DB	#06,#7D,#00,#84,#00,#AA,#01
	DB	#30,#71,#06,#76,#2D,#8A,#01
	DB	#3A,#65,#30,#71,#06,#76,#01
	DB	#3A,#65,#20,#65,#06,#74,#01
	DB	#26,#50,#31,#5B,#06,#74,#01
	DB	#1F,#42,#27,#51,#20,#53,#01
	DB	#80,#08,#71,#0B,#72,#14,#02
	DB	#71,#0B,#5C,#1D,#74,#2C,#02
	DB	#68,#08,#6D,#0E,#5C,#1D,#02
	DB	#60,#08,#65,#0D,#62,#13,#02
	DB	#56,#0C,#62,#13,#5D,#1C,#02
	DB	#4F,#0B,#50,#18,#5A,#1D,#02
	DB	#4A,#16,#5C,#1D,#4C,#26,#02
	DB	#5C,#1D,#4C,#26,#73,#2C,#02
	DB	#4B,#26,#6A,#2A,#6A,#32,#02
	DB	#4B,#26,#6A,#32,#5C,#36,#02
	DB	#45,#23,#2E,#29,#57,#3E,#02
	DB	#45,#23,#5E,#3D,#56,#3F,#02
	DB	#2E,#29,#57,#3E,#3F,#59,#02
	DB	#25,#28,#2E,#29,#3F,#59,#02
	DB	#25,#28,#1E,#3B,#28,#3E,#02
	DB	#1E,#3B,#28,#3E,#23,#4E,#02
	DB	#2C,#34,#23,#4E,#40,#58,#02
	DB	#34,#54,#47,#5C,#2C,#63,#02
	DB	#47,#5C,#3A,#60,#36,#6D,#02
	DB	#35,#6D,#4D,#85,#2E,#89,#02
	DB	#56,#6D,#69,#83,#50,#86,#02
	DB	#70,#83,#3B,#88,#3E,#A4,#02
	DB	#6B,#72,#73,#7D,#6A,#89,#02
	DB	#60,#60,#64,#64,#55,#6C,#02
	DB	#6D,#5D,#60,#60,#6B,#6A,#02
	DB	#78,#5D,#6E,#68,#75,#70,#02
	DB	#79,#5E,#80,#67,#80,#75,#02
	DB	#6D,#46,#7C,#47,#78,#5E,#02
	DB	#79,#43,#5D,#45,#80,#47,#02
	DB	#7C,#36,#80,#3A,#78,#42,#02
	DB	#75,#94,#80,#97,#80,#9C,#02
	DB	#16,#95,#00,#AB,#0E,#B2,#02
	DB	#00,#AB,#07,#AF,#00,#B1,#02
	DB	#1F,#A3,#0E,#B2,#19,#BA,#02
	DB	#0E,#B2,#0E,#BA,#19,#BA,#02
	DB	#28,#B7,#19,#BB,#20,#D0,#02
	DB	#51,#9D,#43,#A8,#4B,#B5,#02
	DB	#43,#A8,#4B,#B5,#3C,#B9,#02
	DB	#3C,#B9,#32,#CC,#3E,#D3,#02
	DB	#5E,#BB,#41,#CD,#4C,#D8,#02
	DB	#41,#CD,#41,#D8,#4C,#D8,#02
	DB	#51,#D1,#45,#E5,#4D,#F0,#02
	DB	#51,#D1,#68,#D1,#4D,#F0,#02
	DB	#68,#D1,#6E,#D7,#4D,#F0,#02
	DB	#74,#E0,#71,#E3,#77,#E6,#02
	DB	#7A,#E1,#80,#E1,#80,#EB,#02
	DB	#64,#6B,#62,#6C,#66,#6E,#02
	DB	#66,#6B,#68,#6C,#64,#6E,#02
	DB	#6D,#6C,#70,#70,#6C,#71,#03
	DB	#5D,#6D,#5C,#71,#5F,#73,#03
	DB	#5E,#6E,#61,#75,#69,#76,#03
	DB	#69,#9A,#6B,#A0,#69,#A1,#03
	DB	#76,#A8,#6F,#AB,#76,#AE,#03
	DB	#76,#AE,#69,#B0,#75,#B3,#03
	DB	#7E,#B0,#67,#B7,#74,#BF,#03
	DB	#7E,#B0,#80,#B5,#74,#BF,#03
	DB	#75,#C3,#69,#C6,#69,#CF,#03
	DB	#75,#C3,#7E,#C6,#69,#CF,#03
	DB	#7E,#C6,#69,#CF,#73,#D4,#03
	DB	#7E,#C6,#80,#D3,#73,#D4,#83
; Taille 728 octets

Glaive
	DB	''K@FN''
	DB	#09			; Tps d''affichage
	DB	#01			; Mode rendu (0=normal, 1=miroir horizontal, 2=miroir vertical)
	DB	#80,#00,#7D,#01,#80,#0A,#01
	DB	#7D,#01,#79,#08,#80,#0A,#01
	DB	#79,#08,#80,#0A,#76,#11,#01
	DB	#80,#0A,#76,#11,#80,#1A,#01
	DB	#76,#11,#74,#1A,#80,#1A,#01
	DB	#74,#1A,#80,#1A,#80,#83,#01
	DB	#74,#1A,#74,#82,#80,#83,#01
	DB	#75,#82,#80,#83,#75,#BA,#01
	DB	#80,#83,#75,#BA,#80,#C2,#01
	DB	#75,#BA,#80,#C2,#72,#CC,#02
	DB	#75,#BA,#69,#CC,#72,#CC,#02
	DB	#6E,#C3,#67,#C9,#69,#CC,#02
	DB	#6F,#B7,#74,#B9,#6E,#C3,#02
	DB	#68,#AF,#6F,#B7,#6E,#C3,#02
	DB	#68,#AF,#5F,#AF,#6E,#C3,#02
	DB	#5F,#AF,#6E,#C3,#67,#C9,#02
	DB	#6E,#C3,#67,#C9,#69,#CC,#02
	DB	#80,#C2,#75,#CA,#77,#CD,#02
	DB	#80,#C2,#80,#CD,#77,#CD,#02
	DB	#77,#CD,#80,#CD,#77,#EF,#03
	DB	#80,#CD,#77,#EF,#80,#F0,#03
	DB	#77,#EF,#80,#F0,#79,#F5,#03
	DB	#80,#F0,#79,#F5,#80,#F9,#03
	DB	#79,#F5,#80,#F9,#78,#FE,#03
	DB	#80,#F9,#78,#FE,#80,#FF,#83
; Taille 175 octets

	DB	#FF

; Frame 0 - Nb triangles 2
Frame_0:
        DB      #77, #64, #C8, #64, #A0, #B4, #01
        DB      #A0, #14, #77, #64, #C8, #64, #82

; Frame 1 - Nb triangles 4
        DB      #95, #16, #80, #64, #72, #6D, #01
        DB      #80, #64, #72, #6D, #AA, #B4, #03
        DB      #95, #16, #CF, #5B, #80, #64, #02
        DB      #CF, #5B, #80, #64, #AA, #B4, #81

; Frame 2 - Nb triangles 4
        DB      #89, #1A, #89, #61, #6E, #77, #01
        DB      #89, #61, #6E, #77, #B7, #B0, #03
        DB      #89, #1A, #D2, #51, #89, #61, #02
        DB      #D2, #51, #89, #61, #B7, #B0, #81

; Frame 3 - Nb triangles 4
        DB      #7B, #21, #92, #5C, #6F, #81, #01
        DB      #7B, #21, #D0, #48, #92, #5C, #02
        DB      #92, #5C, #6F, #81, #C5, #A9, #03
        DB      #D0, #48, #92, #5C, #C5, #A9, #81

; Frame 4 - Nb triangles 4
        DB      #6C, #2C, #CA, #40, #99, #55, #02
        DB      #6C, #2C, #99, #55, #75, #89, #01
        DB      #CA, #40, #99, #55, #D4, #9E, #01
        DB      #99, #55, #75, #89, #D4, #9E, #83

; Frame 5 - Nb triangles 4
        DB      #5F, #3A, #C1, #3B, #9E, #4E, #02
        DB      #5F, #3A, #9E, #4E, #7E, #8F, #01
        DB      #C1, #3B, #9E, #4E, #E1, #90, #01
        DB      #9E, #4E, #7E, #8F, #E1, #90, #83

; Frame 6 - Nb triangles 4
        DB      #B4, #39, #A1, #46, #56, #4B, #02
        DB      #B4, #39, #A1, #46, #EA, #7F, #01
        DB      #A1, #46, #56, #4B, #8A, #92, #01
        DB      #A1, #46, #EA, #7F, #8A, #92, #83

; Frame 7 - Nb triangles 3
        DB      #A7, #3B, #A0, #3F, #EF, #6D, #01
        DB      #A0, #3F, #50, #5C, #98, #90, #01
        DB      #A0, #3F, #EF, #6D, #98, #90, #83

; Frame 8 - Nb triangles 3
        DB      #50, #6D, #A7, #8A, #A1, #8F, #02
        DB      #9E, #39, #EF, #5C, #A7, #8A, #03
        DB      #9E, #39, #50, #6D, #A7, #8A, #81

; Frame 9 - Nb triangles 4
        DB      #E9, #4F, #B4, #80, #A5, #93, #01
        DB      #55, #7B, #B4, #80, #A5, #93, #02
        DB      #9A, #35, #E9, #4F, #B4, #80, #03
        DB      #9A, #35, #55, #7B, #B4, #80, #81

; Frame 10 - Nb triangles 3
        DB      #94, #32, #DF, #45, #C0, #74, #03
        DB      #C0, #74, #5E, #85, #AB, #96, #02
        DB      #94, #32, #C0, #74, #5E, #85, #81

; Frame 11 - Nb triangles 3
        DB      #8E, #32, #D2, #41, #C8, #66, #03
        DB      #C8, #66, #6A, #8A, #B1, #96, #02
        DB      #8E, #32, #C8, #66, #6A, #8A, #81

; Frame 12 - Nb triangles 4
        DB      #87, #33, #C4, #43, #CC, #58, #03
        DB      #87, #33, #74, #70, #79, #89, #02
        DB      #CC, #58, #79, #89, #B7, #96, #02
        DB      #87, #33, #CC, #58, #79, #89, #81

; Frame 13 - Nb triangles 3
        DB      #81, #35, #73, #7D, #88, #81, #02
        DB      #CD, #4C, #88, #81, #BD, #93, #02
        DB      #81, #35, #CD, #4C, #88, #81, #81

; Frame 14 - Nb triangles 4
        DB      #95, #75, #74, #86, #C3, #90, #01
        DB      #7C, #38, #95, #75, #74, #86, #02
        DB      #CB, #42, #95, #75, #C3, #90, #02
        DB      #7C, #38, #CB, #42, #95, #75, #81

; Frame 15 - Nb triangles 4
        DB      #C7, #3C, #77, #3D, #A0, #64, #01
        DB      #77, #3D, #A0, #64, #78, #8D, #02
        DB      #A0, #64, #C8, #8C, #78, #8D, #01
        DB      #C7, #3C, #A0, #64, #C8, #8C, #82

; Frame 16 - Nb triangles 4
        DB      #C3, #3B, #74, #41, #A6, #52, #01
        DB      #C3, #3B, #A6, #52, #CB, #88, #02
        DB      #74, #41, #A6, #52, #7C, #8F, #02
        DB      #A6, #52, #CB, #88, #7C, #8F, #81

; Frame 17 - Nb triangles 4
        DB      #BF, #3C, #AA, #41, #71, #46, #01
        DB      #BF, #3C, #AA, #41, #CE, #84, #02
        DB      #AA, #41, #71, #46, #80, #8E, #02
        DB      #AA, #41, #CE, #84, #80, #8E, #81

; Frame 18 - Nb triangles 4
        DB      #D0, #7F, #83, #89, #96, #95, #03
        DB      #A9, #31, #BB, #41, #D0, #7F, #02
        DB      #A9, #31, #6F, #4B, #83, #89, #02
        DB      #A9, #31, #D0, #7F, #83, #89, #81

; Frame 19 - Nb triangles 3
        DB      #D1, #79, #84, #81, #98, #A2, #03
        DB      #A7, #24, #6F, #50, #84, #81, #02
        DB      #A7, #24, #D1, #79, #84, #81, #81

; Frame 20 - Nb triangles 3
        DB      #D1, #74, #82, #79, #9B, #AB, #03
        DB      #A4, #1B, #6F, #56, #82, #79, #02
        DB      #A4, #1B, #D1, #74, #82, #79, #81

; Frame 21 - Nb triangles 3
        DB      #A1, #16, #72, #5C, #7F, #70, #02
        DB      #CF, #6E, #7F, #70, #9E, #B1, #03
        DB      #A1, #16, #CF, #6E, #7F, #70, #81

; Frame 22 - Nb triangles 3
        DB      #A0, #14, #76, #62, #7A, #68, #02
        DB      #7A, #68, #CB, #68, #9F, #B4, #03
        DB      #A0, #14, #7A, #68, #CB, #68, #81

; Frame 23 - Nb triangles 4
        DB      #A0, #15, #C5, #62, #CA, #67, #02
        DB      #C5, #62, #CA, #67, #9F, #B5, #01
        DB      #A0, #15, #74, #62, #C5, #62, #01
        DB      #74, #62, #C5, #62, #9F, #B5, #83

; Frame 24 - Nb triangles 4
        DB      #A1, #16, #BD, #5C, #D0, #6B, #02
        DB      #BD, #5C, #D0, #6B, #9E, #B4, #01
        DB      #A1, #16, #BD, #5C, #6E, #5E, #01
        DB      #BD, #5C, #6E, #5E, #9E, #B4, #83

; Frame 25 - Nb triangles 4
        DB      #A4, #18, #B3, #58, #D4, #6C, #02
        DB      #A4, #18, #B3, #58, #6A, #5D, #01
        DB      #B3, #58, #D4, #6C, #9B, #B3, #01
        DB      #B3, #58, #6A, #5D, #9B, #B3, #83

; Frame 26 - Nb triangles 4
        DB      #A7, #19, #A7, #55, #D7, #6C, #02
        DB      #A7, #19, #A7, #55, #67, #5D, #01
        DB      #A7, #55, #D7, #6C, #98, #B2, #01
        DB      #A7, #55, #67, #5D, #98, #B2, #83

; Frame 27 - Nb triangles 4
        DB      #A9, #18, #9A, #55, #68, #5F, #01
        DB      #A9, #18, #9A, #55, #D8, #6A, #02
        DB      #9A, #55, #68, #5F, #96, #B2, #03
        DB      #9A, #55, #D8, #6A, #96, #B2, #81

; Frame 28 - Nb triangles 4
        DB      #A9, #17, #8D, #58, #6B, #62, #01
        DB      #8D, #58, #6B, #62, #96, #B3, #03
        DB      #A9, #17, #8D, #58, #D5, #67, #02
        DB      #8D, #58, #D5, #67, #96, #B3, #81

; Frame 29 - Nb triangles 4
        DB      #A6, #16, #81, #5D, #71, #64, #01
        DB      #81, #5D, #71, #64, #99, #B4, #03
        DB      #A6, #16, #81, #5D, #D0, #65, #02
        DB      #81, #5D, #D0, #65, #99, #B4, #81

; Frame 30 - Nb triangles 2
        DB      #C8, #64, #77, #65, #A0, #B4, #01
        DB      #9F, #14, #C8, #64, #77, #65, #82

; Frame 31 - Nb triangles 4
        DB      #CD, #5C, #BF, #65, #AA, #B3, #03
        DB      #95, #15, #CD, #5C, #BF, #65, #01
        DB      #BF, #65, #70, #6E, #AA, #B3, #01
        DB      #95, #15, #BF, #65, #70, #6E, #82

; Frame 32 - Nb triangles 4
        DB      #D1, #52, #B6, #68, #B6, #AF, #03
        DB      #88, #19, #D1, #52, #B6, #68, #01
        DB      #B6, #68, #6D, #78, #B6, #AF, #01
        DB      #88, #19, #B6, #68, #6D, #78, #82

; Frame 33 - Nb triangles 4
        DB      #D0, #48, #AD, #6D, #C4, #A8, #03
        DB      #AD, #6D, #6F, #81, #C4, #A8, #01
        DB      #7A, #20, #D0, #48, #AD, #6D, #01
        DB      #7A, #20, #AD, #6D, #6F, #81, #82

; Frame 34 - Nb triangles 4
        DB      #A6, #74, #75, #89, #D3, #9D, #01
        DB      #CA, #40, #A6, #74, #D3, #9D, #03
        DB      #6B, #2B, #A6, #74, #75, #89, #02
        DB      #6B, #2B, #CA, #40, #A6, #74, #81

; Frame 35 - Nb triangles 4
        DB      #A1, #7B, #7E, #8E, #E0, #8F, #01
        DB      #C1, #3A, #A1, #7B, #E0, #8F, #03
        DB      #5E, #39, #A1, #7B, #7E, #8E, #02
        DB      #5E, #39, #C1, #3A, #A1, #7B, #81

; Frame 36 - Nb triangles 4
        DB      #E9, #7E, #9E, #83, #8B, #90, #01
        DB      #55, #4A, #9E, #83, #8B, #90, #02
        DB      #B5, #37, #E9, #7E, #9E, #83, #03
        DB      #B5, #37, #55, #4A, #9E, #83, #81

; Frame 37 - Nb triangles 3
        DB      #50, #5C, #9F, #8A, #98, #8E, #02
        DB      #A7, #39, #EF, #6D, #9F, #8A, #03
        DB      #A7, #39, #50, #5C, #9F, #8A, #81

; Frame 38 - Nb triangles 3
        DB      #9E, #3A, #98, #3F, #EF, #5C, #01
        DB      #98, #3F, #50, #6D, #A1, #90, #01
        DB      #98, #3F, #EF, #5C, #A1, #90, #83

; Frame 39 - Nb triangles 4
        DB      #9A, #36, #8B, #49, #56, #7A, #02
        DB      #9A, #36, #8B, #49, #EA, #4E, #01
        DB      #8B, #49, #56, #7A, #A5, #94, #01
        DB      #8B, #49, #EA, #4E, #A5, #94, #83

; Frame 40 - Nb triangles 3
        DB      #7F, #55, #60, #84, #AB, #97, #01
        DB      #94, #33, #E1, #44, #7F, #55, #01
        DB      #E1, #44, #7F, #55, #AB, #97, #83

; Frame 41 - Nb triangles 3
        DB      #77, #63, #6D, #88, #B1, #97, #01
        DB      #8E, #33, #D5, #3F, #77, #63, #01
        DB      #D5, #3F, #77, #63, #B1, #97, #83

; Frame 42 - Nb triangles 4
        DB      #73, #71, #7B, #86, #B8, #96, #01
        DB      #C6, #40, #CB, #59, #B8, #96, #01
        DB      #88, #33, #C6, #40, #73, #71, #01
        DB      #C6, #40, #73, #71, #B8, #96, #83

; Frame 43 - Nb triangles 4
        DB      #82, #36, #B7, #48, #CC, #4C, #03
        DB      #B7, #48, #CC, #4C, #BE, #94, #01
        DB      #82, #36, #B7, #48, #72, #7D, #01
        DB      #B7, #48, #72, #7D, #BE, #94, #83

; Frame 44 - Nb triangles 4
        DB      #7C, #39, #CB, #43, #AA, #54, #03
        DB      #CB, #43, #AA, #54, #C3, #91, #01
        DB      #7C, #39, #AA, #54, #74, #87, #01
        DB      #AA, #54, #74, #87, #C3, #91, #83

; Frame 45 - Nb triangles 4
        DB      #C7, #3C, #77, #3D, #9F, #65, #03
        DB      #77, #3D, #9F, #65, #78, #8D, #01
        DB      #9F, #65, #C8, #8C, #78, #8D, #03
        DB      #C7, #3C, #9F, #65, #C8, #8C, #81

; Frame 46 - Nb triangles 4
        DB      #99, #77, #CB, #88, #7C, #8E, #03
        DB      #74, #41, #99, #77, #7C, #8E, #01
        DB      #C3, #3A, #99, #77, #CB, #88, #01
        DB      #C3, #3A, #74, #41, #99, #77, #83

; Frame 47 - Nb triangles 4
        DB      #CE, #83, #95, #88, #80, #8D, #03
        DB      #71, #45, #95, #88, #80, #8D, #01
        DB      #BF, #3B, #CE, #83, #95, #88, #01
        DB      #BF, #3B, #71, #45, #95, #88, #83

; Frame 48 - Nb triangles 4
        DB      #A9, #34, #BC, #40, #6F, #4A, #01
        DB      #6F, #4A, #84, #88, #96, #98, #01
        DB      #BC, #40, #D0, #7E, #96, #98, #01
        DB      #BC, #40, #6F, #4A, #96, #98, #83

; Frame 49 - Nb triangles 3
        DB      #A7, #27, #BB, #48, #6E, #50, #01
        DB      #BB, #48, #D0, #79, #98, #A5, #01
        DB      #BB, #48, #6E, #50, #98, #A5, #83

; Frame 50 - Nb triangles 3
        DB      #A4, #1E, #BD, #50, #6E, #55, #01
        DB      #BD, #50, #D0, #73, #9B, #AE, #01
        DB      #BD, #50, #6E, #55, #9B, #AE, #83

; Frame 51 - Nb triangles 3
        DB      #C0, #59, #CD, #6D, #9E, #B3, #01
        DB      #A1, #18, #C0, #59, #70, #5B, #01
        DB      #C0, #59, #70, #5B, #9E, #B3, #83

; Frame 52 - Nb triangles 3
        DB      #C5, #61, #C9, #67, #9F, #B5, #01
        DB      #A0, #15, #74, #61, #C5, #61, #01
        DB      #74, #61, #C5, #61, #9F, #B5, #83

; Frame 53 - Nb triangles 3
        DB      #A0, #14, #75, #62, #7A, #67, #02
        DB      #7A, #67, #CB, #67, #9F, #B4, #03
        DB      #A0, #14, #7A, #67, #CB, #67, #81

; Frame 54 - Nb triangles 4
        DB      #6F, #5E, #82, #6D, #9E, #B3, #01
        DB      #A1, #15, #6F, #5E, #82, #6D, #02
        DB      #D1, #6B, #82, #6D, #9E, #B3, #03
        DB      #A1, #15, #D1, #6B, #82, #6D, #81

; Frame 55 - Nb triangles 4
        DB      #6B, #5D, #8C, #71, #9B, #B1, #01
        DB      #D5, #6C, #8C, #71, #9B, #B1, #03
        DB      #A4, #16, #6B, #5D, #8C, #71, #02
        DB      #A4, #16, #D5, #6C, #8C, #71, #81

; Frame 56 - Nb triangles 4
        DB      #68, #5D, #98, #74, #98, #B0, #01
        DB      #D8, #6C, #98, #74, #98, #B0, #03
        DB      #A7, #17, #68, #5D, #98, #74, #02
        DB      #A7, #17, #D8, #6C, #98, #74, #81

; Frame 57 - Nb triangles 4
        DB      #D7, #6A, #A5, #74, #96, #B1, #03
        DB      #67, #5F, #A5, #74, #96, #B1, #01
        DB      #A9, #17, #D7, #6A, #A5, #74, #01
        DB      #A9, #17, #67, #5F, #A5, #74, #82

; Frame 58 - Nb triangles 4
Frame_58:
        DB      #D4, #67, #B2, #71, #96, #B2, #03
        DB      #A9, #16, #D4, #67, #B2, #71, #01
        DB      #6A, #62, #B2, #71, #96, #B2, #01
        DB      #A9, #16, #6A, #62, #B2, #71, #82

; Frame 59 - Nb triangles 4
        DB      #CE, #65, #BE, #6C, #99, #B3, #03
        DB      #A6, #15, #CE, #65, #BE, #6C, #01
        DB      #6F, #64, #BE, #6C, #99, #B3, #01
        DB      #A6, #15, #6F, #64, #BE, #6C, #82
        DB      #FF ; fin des frames

	
CrtcValues
	DB	1,#20,2,#2A,6,#20,7,#22,12,#30,13,0,0

;
; Structure
; octet 0 = premier octet de la ligne
; octet 1 = nbre d''octets a soustraire+1 du nombre de pixels
; octet 2 = dernier octet de la ligne
;
pen1:
	DB	#80,#02,#00
	DB	#40,#02,#00
	DB	#20,#02,#00
	DB	#10,#02,#00
	DB	#C0,#03,#00
	DB	#60,#03,#00
	DB	#30,#03,#00
	DB	#10,#03,#80
	DB	#E0,#04,#00
	DB	#70,#04,#00
	DB	#30,#04,#80
	DB	#10,#04,#C0
	DB	#F0,#05,#00
	DB	#70,#05,#80
	DB	#30,#05,#C0
	DB	#10,#05,#E0
	DB	#F0,#06,#80
	DB	#70,#06,#C0
	DB	#30,#06,#E0
	DB	#10,#06,#F0
	DB	#F0,#07,#C0
	DB	#70,#07,#E0
	DB	#30,#07,#F0
	DB	#10,#03,#80
	DB	#F0,#08,#E0
	DB	#70,#08,#F0
	DB	#30,#04,#80
	DB	#10,#04,#C0
	DB	#F0,#09,#F0
	DB	#70,#05,#80
	DB	#30,#05,#C0
	DB	#10,#05,#E0

CHAR_DeuxPoint
	DB	#00,#07,#03,#07,#03,#0C
	DB	#00,#07,#03,#0C,#00,#0C
	DB	#00,#0E,#03,#0E,#03,#13
	DB	#00,#0E,#03,#13,#00,#13
	DB	128+4
; Taille 24 octets
CHAR_Apostrophe
	DB	#00,#00,#03,#00,#00,#06
	DB	128+2
; Taille 6 octets
Char_Etoile
	DB	#0F,#06,#04,#07,#00,#13
	DB	#0F,#06,#00,#07,#07,#0E
	DB	#07,#00,#0A,#0B,#00,#13
	DB	#07,#00,#03,#0B,#0D,#13
	DB	128+16
; Taille 24 octets
Char_OpenTab
	DB	#00,#00,#07,#00,#04,#0F
	DB	#00,#00,#05,#0F,#04,#0F
	DB	#02,#12,#02,#15,#05,#15
	DB	#05,#12,#02,#12,#05,#15
	DB	128+8
; Taille 24 octets
CHAR_Smiley
	DB	#04,#04,#0C,#04,#00,#08
	DB	#0C,#04,#00,#08,#10,#08
	DB	#00,#08,#02,#08,#02,#0C
	DB	#00,#08,#02,#0C,#00,#0C
	DB	#06,#08,#0A,#08,#0A,#0C
	DB	#06,#08,#0A,#0C,#06,#0C
	DB	#0E,#08,#10,#08,#10,#0C
	DB	#0E,#08,#10,#0C,#0E,#0C
	DB	#00,#0C,#02,#0C,#03,#0F
	DB	#00,#0C,#03,#0F,#00,#10
	DB	#02,#0C,#0E,#0C,#0D,#0F
	DB	#02,#0C,#0D,#0F,#03,#0F
	DB	#0E,#0C,#10,#0C,#10,#10
	DB	#0E,#0C,#0D,#0F,#10,#10
	DB	#03,#0F,#00,#10,#06,#12
	DB	#00,#10,#06,#12,#04,#14
	DB	#06,#12,#0A,#12,#0C,#14
	DB	#06,#12,#0C,#14,#04,#14
	DB	#0D,#0F,#10,#10,#0C,#14
	DB	#0D,#0F,#0A,#12,#0C,#14
	DB	128+17
; Taille 120 octets
CHAR_1
	DB	#00,#12,#0C,#12,#0C,#15
	DB	#00,#12,#0C,#15,#00,#15
	DB	#04,#00,#07,#00,#07,#12
	DB	#04,#00,#07,#12,#04,#12
	DB	#04,#00,#07,#00,#00,#07
	DB	#04,#00,#00,#04,#00,#07
	DB	128+13
; Taille 36 octets
CHAR_3
	DB	#09,#03,#0C,#03,#0C,#12
	DB	#09,#03,#0C,#12,#09,#12
	DB	#03,#09,#09,#09,#09,#0C
	DB	#03,#09,#09,#0C,#03,#0C
	DB	#00,#12,#0C,#12,#09,#15
	DB	#00,#12,#09,#15,#03,#15
	DB	#03,#00,#09,#00,#0C,#03
	DB	#03,#00,#0C,#03,#00,#03
	DB	128+13
; Taille 48 octets
CHAR_8
	DB	#03,#09,#09,#09,#09,#0C
	DB	#03,#09,#09,#0C,#03,#0C
	DB	#00,#03,#03,#03,#03,#12
	DB	#00,#03,#03,#12,#00,#12
	DB	#09,#03,#0C,#03,#0C,#12
	DB	#09,#03,#0C,#12,#09,#12
	DB	#03,#00,#09,#00,#0C,#03
	DB	#03,#00,#0C,#03,#00,#03
	DB	#00,#12,#0C,#12,#09,#15
	DB	#00,#12,#09,#15,#03,#15
	DB	128+13
; Taille 60 octets
Char_A
	DB	#06,#00,#09,#00,#02,#15
	DB	#06,#00,#02,#15,#00,#15
	DB	#06,#00,#09,#00,#11,#15
	DB	#06,#00,#11,#15,#0E,#15
	DB	#05,#0C,#0B,#0C,#0D,#0F
	DB	#05,#0C,#0D,#0F,#03,#0F
	DB	128+17
; Taille 36 octets
Char_B
	DB	#00,#00,#0C,#00,#0F,#03
	DB	#00,#00,#00,#03,#0F,#03
	DB	#00,#03,#03,#03,#03,#12
	DB	#00,#03,#03,#12,#00,#12
	DB	#00,#12,#0F,#12,#0C,#15
	DB	#00,#12,#0C,#15,#00,#15
	DB	#0C,#03,#0F,#09,#0C,#0C
	DB	#0C,#03,#0F,#03,#0F,#09
	DB	#0C,#09,#0F,#0C,#0C,#12
	DB	#0F,#0C,#0F,#12,#0C,#12
	DB	#03,#09,#0C,#09,#0C,#0C
	DB	#03,#09,#0C,#0C,#03,#0C
	DB	128+16
; Taille 72 octets
Char_C
	DB	#03,#00,#00,#12,#03,#15
	DB	#03,#00,#00,#03,#00,#12
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#0F,#03,#03,#03
	DB	#03,#12,#0F,#12,#0C,#15
	DB	#03,#12,#0C,#15,#03,#15
	DB	128+16
; Taille 36 octets
Char_D
	DB	#00,#00,#0C,#00,#0F,#03
	DB	#00,#00,#12,#03,#00,#03
	DB	#00,#03,#03,#03,#03,#12
	DB	#00,#03,#03,#12,#00,#12
	DB	#00,#12,#0F,#12,#0C,#15
	DB	#00,#12,#0F,#15,#00,#15
	DB	#0C,#03,#0F,#03,#0F,#12
	DB	#0C,#03,#0F,#12,#0C,#12
	DB	128+16
; Taille 48 octets
Char_E
	DB	#00,#00,#0F,#00,#0F,#03
	DB	#00,#00,#12,#03,#00,#03
	DB	#00,#03,#03,#03,#03,#15
	DB	#00,#03,#03,#15,#00,#15
	DB	#03,#09,#09,#09,#09,#0C
	DB	#03,#09,#09,#0C,#03,#0C
	DB	#03,#12,#0F,#12,#0F,#15
	DB	#03,#12,#12,#15,#03,#15
	DB	128+16
; Taille 48 octets
Char_F
	DB	#00,#00,#0F,#00,#0F,#03
	DB	#00,#00,#0F,#03,#00,#03
	DB	#00,#03,#03,#03,#03,#15
	DB	#00,#03,#03,#15,#00,#15
	DB	#03,#09,#09,#09,#09,#0C
	DB	#03,#09,#09,#0C,#03,#0C
	DB	128+16
; Taille 36 octets
Char_G
	DB	#03,#00,#00,#12,#03,#15
	DB	#03,#00,#00,#03,#00,#12
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#03,#03
	DB	#03,#12,#0F,#12,#0C,#15
	DB	#03,#12,#0F,#15,#03,#15
	DB	#06,#09,#0F,#09,#0F,#0C
	DB	#06,#09,#0F,#0C,#06,#0C
	DB	#0C,#0C,#0F,#0C,#0F,#12
	DB	#0C,#0C,#0F,#12,#0C,#12
	DB	128+16
; Taille 60 octets
Char_H
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#0C,#00,#0F,#00,#0F,#15
	DB	#0C,#00,#0F,#15,#0C,#15
	DB	#03,#09,#0C,#09,#0C,#0C
	DB	#03,#09,#0C,#0C,#03,#0C
	DB	128+16
; Taille 36 octets
Char_I
	DB	#00,#00,#0C,#00,#0C,#03
	DB	#00,#00,#0C,#03,#00,#03
	DB	#00,#12,#0C,#12,#0C,#15
	DB	#00,#12,#0C,#15,#00,#15
	DB	#04,#03,#07,#03,#07,#12
	DB	#04,#03,#07,#12,#04,#12
	DB	128+13
; Taille 36 octets
Char_J
	DB	#03,#00,#0F,#00,#0F,#03
	DB	#03,#00,#0F,#03,#03,#03
	DB	#09,#03,#0C,#03,#0C,#12
	DB	#09,#03,#0C,#12,#09,#15
	DB	#00,#12,#09,#12,#09,#15
	DB	#00,#12,#09,#15,#03,#15
	DB	#00,#0F,#03,#0F,#03,#12
	DB	#00,#0F,#03,#12,#00,#12
	DB	128+16
; Taille 48 octets
Char_K
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#0C,#00,#0F,#00,#03,#0C
	DB	#0C,#00,#03,#0C,#00,#0C
	DB	#00,#09,#03,#09,#0F,#15
	DB	#00,#09,#0F,#15,#0C,#15
	DB	128+16
; Taille 36 octets
Char_L
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#03,#12,#03,#15,#0E,#15
	DB	#03,#12,#0E,#12,#0E,#15
	DB	128+15
; Taille 24 octets
Char_M
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#0F,#00,#12,#00,#12,#15
	DB	#0F,#00,#12,#15,#0F,#15
	DB	#03,#00,#0A,#06,#0A,#09
	DB	#03,#00,#03,#03,#0A,#09
	DB	#0F,#00,#0F,#04,#09,#07
	DB	#0F,#04,#09,#07,#09,#0A
	DB	128+19
; Taille 48 octets
Char_N
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#0C,#00,#0F,#00,#0F,#15
	DB	#0C,#00,#0F,#15,#0C,#15
	DB	#03,#00,#0F,#0C,#0F,#0F
	DB	#03,#00,#03,#03,#0F,#0F
	DB	128+16
; Taille 36 octets
Char_O
	DB	#03,#00,#00,#12,#03,#15
	DB	#03,#00,#00,#03,#00,#12
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#03,#03
	DB	#03,#12,#0F,#12,#0C,#15
	DB	#03,#12,#0F,#15,#03,#15
	DB	#0C,#03,#0F,#03,#0F,#12
	DB	#0C,#03,#0F,#12,#0C,#12
	DB	128+16
; Taille 48 octets
Char_P
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#03,#03
	DB	#0C,#03,#0F,#03,#0F,#09
	DB	#0C,#03,#0F,#09,#0C,#09
	DB	#03,#09,#0F,#09,#0C,#0C
	DB	#03,#09,#0F,#0C,#03,#0C
	DB	128+16
; Taille 48 octets
Char_Q
	DB	#03,#00,#00,#12,#03,#15
	DB	#03,#00,#00,#03,#00,#12
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#03,#03
	DB	#03,#12,#0F,#12,#0C,#15
	DB	#03,#12,#0F,#15,#03,#15
	DB	#0C,#03,#0F,#03,#0F,#12
	DB	#0C,#03,#0F,#12,#0C,#12
	DB	#09,#0C,#0F,#12,#0C,#15
	DB	#09,#0C,#06,#0F,#0C,#15
	DB	128+16
; Taille 60 octets
Char_R
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#03,#03
	DB	#0C,#03,#0F,#03,#0F,#09
	DB	#0C,#03,#0F,#09,#0C,#09
	DB	#03,#09,#0F,#09,#0C,#0C
	DB	#03,#09,#0F,#0C,#03,#0C
	DB	#03,#0C,#06,#0C,#0F,#15
	DB	#03,#0C,#0F,#15,#0C,#15
	DB	128+16
; Taille 60 octets
Char_S
	DB	#03,#00,#0C,#00,#0F,#03
	DB	#03,#00,#12,#03,#00,#03
	DB	#00,#03,#03,#03,#03,#09
	DB	#00,#03,#03,#09,#00,#09
	DB	#00,#09,#0C,#09,#0F,#0C
	DB	#00,#09,#12,#0C,#03,#0C
	DB	#0C,#0C,#0F,#0C,#0F,#12
	DB	#0C,#0C,#0F,#12,#0C,#12
	DB	#00,#12,#0F,#12,#0C,#15
	DB	#00,#12,#0F,#15,#03,#15
	DB	128+16
; Taille 60 octets
Char_T
	DB	#00,#00,#0F,#00,#0F,#03
	DB	#00,#00,#0F,#03,#00,#03
	DB	#06,#03,#09,#03,#09,#15
	DB	#06,#03,#09,#15,#06,#15
	DB	128+16
; Taille 24 octets
Char_U
	DB	#03,#00,#00,#12,#03,#15
	DB	#03,#00,#00,#00,#00,#12
	DB	#03,#12,#0F,#12,#0C,#15
	DB	#03,#12,#0F,#15,#03,#15
	DB	#0C,#00,#0F,#00,#0F,#12
	DB	#0C,#00,#0F,#12,#0C,#12
	DB	128+16
; Taille 36 octets
Char_V
	DB	#00,#00,#03,#00,#09,#15
	DB	#00,#00,#09,#15,#06,#15
	DB	#0C,#00,#0F,#00,#0A,#15
	DB	#0C,#00,#0A,#15,#06,#15
	DB	128+16
; Taille 24 octets
Char_W
	DB	#00,#00,#03,#00,#03,#15
	DB	#00,#00,#03,#15,#00,#15
	DB	#0D,#00,#10,#00,#10,#15
	DB	#0D,#00,#10,#15,#0D,#15
	DB	#09,#0C,#03,#12,#03,#15
	DB	#08,#0C,#08,#0F,#03,#15
	DB	#08,#0C,#0E,#12,#0E,#15
	DB	#08,#0C,#08,#0F,#0E,#15
	DB	128+17
; Taille 48 octets
Char_X
	DB	#00,#00,#03,#00,#0F,#15
	DB	#00,#00,#0F,#15,#0C,#15
	DB	#0C,#00,#0F,#00,#03,#15
	DB	#0C,#00,#03,#15,#00,#15
	DB	128+16
; Taille 24 octets
Char_Y
	DB	#00,#00,#03,#00,#08,#06
	DB	#00,#00,#08,#06,#08,#0A
	DB	#0D,#00,#10,#00,#08,#0A
	DB	#0D,#00,#08,#06,#08,#0C
	DB	#07,#06,#0A,#06,#0A,#15
	DB	#07,#06,#0A,#15,#07,#15
	DB	128+17
; Taille 36 octets
Char_Z
	DB	#00,#00,#0F,#00,#0F,#03
	DB	#00,#00,#0F,#03,#00,#03
	DB	#0C,#03,#0F,#03,#03,#12
	DB	#0C,#03,#03,#12,#00,#12
	DB	#00,#12,#0F,#12,#0F,#15
	DB	#00,#12,#0F,#15,#00,#15
	DB	128+16
; Taille 36 octets

Alphabet
	DW	0,CHAR_1,0,CHAR_3,0,0,0,0,CHAR_8,0
	DW	CHAR_DeuxPoint,CHAR_Apostrophe,0,Char_Etoile,0,Char_OpenTab,CHAR_Smiley
	DW	Char_A,Char_B,Char_C,Char_D,Char_E,Char_F,Char_G,Char_H
	DW	Char_I,Char_J,Char_K,Char_L,Char_M,Char_N,Char_O,Char_P
	DW	Char_Q,Char_R,Char_S,Char_T,Char_U,Char_V,Char_W,Char_X
	DW	Char_Y,Char_Z
	

Message1
	DB	1,1
	DB	2,0,96
	DB	''WE WANT''
	DB	1,2
	DB	2,32,128
	DB	''TRUE SPEED''
	DB	2,64,160
	DB	1,3
	DB	''NOW ?????'',0

message2
	DB	3,''TKUD''
	DB	4,''DU''
	DB	1,2
	DB	2,0,8
	DB	6,3
	DB	''================''
	DB	6,2
	DB	2,0,32,''=''
	DB	2,240,32,''=''
	DB	6,3
	DB	2,0,56,''=''
	DB	2,240,56,''=''
	DB	6,2
	DB	2,0,80,''=''
	DB	2,240,80,''=''
	DB	6,3
	DB	2,0,104,''=''
	DB	2,240,104,''=''
	DB	6,2
	DB	2,0,128,''=''
	DB	2,240,128,''=''
	DB	6,3
	DB	2,0,152,''=''
	DB	2,240,153,''=''
	DB	6,2
	DB	2,0,176,''=''
	DB	2,240,176,''=''
	DB	6,3
	DB	2,0,200,''=''
	DB	2,240,200,''=''
	DB	6,2
	DB	2,0,224
	DB	''================''
	DB	6,0
	DB	1,1
	DB	5,58,''YOU''
	DB	5,106,''WATCHED''
	DB	1,3
	DB	2,34,153,''TRIANGUL;ART''
	DB	1,2
	DB	2,36,156,''TRIANGUL;ART''
	DB	1,1
	DB	2,38,159,''TRIANGUL;ART''
	DB	0
	
	DB	3,''T@KS''
	DB	4,''SK''
	DB	1,1
	DB	5,15
	DB	''ALL THE''
	DB	5,55
	DB	''GRAPHICS''
	DB	5,95
	DB	''IN THIS DEMO''
	DB	5,135
	DB	''ARE DRAWN ONLY''
	DB	5,175
	DB	''WITH''
	DB	6,3
	DB	5,215
	DB	''TRIANGLES''
	DB	6,0
	DB	0
	
	DB	3,''TD@K''
	DB	4,4,4
	DB	5,35
	DB	''CODE BY''
	DB	1,1
	DB	5,74
	DB	''DEMONIAK''
	DB	1,2
	DB	5,76
	DB	''DEMONIAK''
	DB	1,3
	DB	5,78
	DB	''DEMONIAK''
	DB	1,2
	DB	5,115
	DB	''MORAL SUPPORT''
	DB	5,155
	DB	''OF THE WHOLE''
	DB	1,1
	DB	5,195
	DB	''IMPACT TEAM''
	DB	1,2
	DB	5,197
	DB	''IMPACT TEAM''
	DB	1,3
	DB	5,199
	DB	''IMPACT TEAM''
	DB	0
	
	DB	3,''D@Y[''
	DB	4,''[Y''
	DB	1,1
	DB	5,0
	DB	''GREETINGS ARE''
	DB	5,25
	DB	''GOING TO''
	DB	6,3
	DB	5,50
	DB	''ARKOS''
	DB	5,75
	DB	''BARJACK  BEB''
	DB	5,100
	DB	''BENEDICTION''
	DB	5,125
	DB	''BOISSETAR''
	DB	5,150
	DB	''BSC  CED  CHANY''
	DB	5,175
	DB	''CHESHIRECAT''
	DB	5,200
	DB	''CONDENSE''
	DB	5,225
	DB	''DECKARD''
	DB	0	
	
	DB	5,0
	DB	''DIRTY MINDS''
	DB	5,25
	DB	''DLFRSILVER''
	DB	5,50
	DB	''DUFFY  ELIOT''
	DB	5,75
	DB	''EMERIC''
	DB	5,100
	DB	''EXECUTIONER''
	DB	5,125
	DB	''FLOWER CORP''
	DB	5,150
	DB	''FUTURESOFT''
	DB	5,175
	DB	''FUTURS  GGP''
	DB	5,200
	DB	''GOLEM13  GPA''
	DB	5,225
	DB	''GRIM  GYNECEON''
	DB	0
	
	DB	5,0
	DB	''HERMOL  HICKS''
	DB	5,25
	DB	''HLIDE  HWIKAA''
	DB	5,50
	DB	''JB LE DARON''
	DB	5,75
	DB	''KHOMENOR''
	DB	5,100
	DB	''KRUSTY''
	DB	5,125
	DB	''KUKULCAN''
	DB	5,150
	DB	''LOGON SYSTEM''
	DB	5,175
	DB	''LONE  MADE''
	DB	5,200
	DB	''MADRAM''
	DB	5,225
	DB	''MCDEATH''
	DB	0
	
	DB	5,0
	DB	''MEGACHUR''
	DB	5,25
	DB	''MORTEL''
	DB	5,50
	DB	''MVKTHEBOSS''
	DB	5,75
	DB	''NORECESS''
	DB	5,100
	DB	''ODIESOFT''
	DB	5,125
	DB	''OFFSET''
	DB	5,150
	DB	''OPTIMUS''
	DB	5,175
	DB	''OVERFLOW''
	DB	5,200
	DB	''OVERLANDERS''
	DB	5,225
	DB	''PRALINE''
	DB	0
	
	DB	5,0
	DB	''PRODATRON''
	DB	5,25
	DB	''ROUDOUDOU''
	DB	5,50
	DB	''SHINRA''
	DB	5,75
	DB	''SOLORENZO''
	DB	5,100
	DB	''SPECTRO88''
	DB	5,125
	DB	''STEPH''
	DB	5,150
	DB	''TARGHAN''
	DB	5,175
	DB	''THE DOCTOR''
	DB	5,200
	DB	''TITAN  TOMS''
	DB	5,225
	DB	''TOTO  VANITY''
	DB	0

	DB	5,0
	DB	''VOXY  XTRABET''
	DB	5,25
	DB	''ZIK''
	DB	6,0,1,1
	DB	5,105
	DB	''AND OF COURSE''
	DB	5,135
	DB	''THE WHOLE''
	DB	6,3
	DB	5,165,''@ IMPACT TEAM @''
	DB	6,0
	DB	1,1,5,167,''IMPACT TEAM''
	DB	5,195
	DB	''MEMBERS''
	DB	0
	
	DB	1,1
	DB	5,0,''IMPACT TEAM:''
	DB	6,3
	DB	2,0,32
	DB	''= AST''
	DB	6,2
	DB	2,0,64
	DB	''= CMP''
	DB	6,3
	DB	2,0,96
	DB	''= DEMONIAK''
	DB	2,0,128
	DB	''= DEVILMARKUS''
	DB	2,0,160
	DB	6,3
	DB	''= DRILL''
	DB	2,0,192
	DB	6,2	
	DB	''= KRIS''
	DB	2,0,224
	DB	''= SID''
	DB	6,0
	DB	0
	DB	#FF
	
MessageEnd1
	DB	2,100,225,1,1,''T'',1,2,''H'',1,1,''E'','' '',1,2,''E'',1,1,''N'',1,2,''D''
	DB	0
MessageEnd2
	DB	2,100,225,1,2,''T'',1,1,''H'',1,2,''E'','' '',1,1,''E'',1,2,''N'',1,1,''D''
	DB	0
	
	
MDLADDR:
	DB	#03,#2F,#00,#00,#00,#30,#13,#4A,#13,#67,#13,#7E,#13,#A7,#13,#F4
	DB	#13,#89,#14,#4B,#15,#83,#15,#45,#16,#5C,#16,#85,#16,#AE,#16,#D7
	DB	#16,#DC,#16,#E1,#16,#7C,#17,#AE,#17,#E3,#17,#09,#18,#0E,#18,#13
	DB	#18,#18,#18,#1D,#18,#22,#18,#27,#18,#2C,#18,#31,#18,#36,#18,#3B
	DB	#18,#40,#18,#45,#18,#48,#18,#50,#18,#59,#18,#5F,#18,#65,#18,#7A
	DB	#18,#89,#18,#92,#18,#97,#18,#9C,#18,#A1,#18,#A6,#18,#AB,#18,#B0
	DB	#18,#B5,#18,#B3,#00,#54,#48,#49,#53,#20,#53,#48,#49,#54,#54,#49
	DB	#4E,#47,#20,#4E,#4F,#49,#53,#45,#20,#42,#59,#20,#2D,#4C,#41,#56
	DB	#2D,#20,#20,#00,#14,#01,#01,#02,#02,#02,#10,#03,#03,#19,#19,#04
	DB	#04,#1B,#11,#06,#06,#06,#06,#0F,#07,#08,#09,#0A,#0B,#0C,#0D,#0E
	DB	#12,#0E,#13,#15,#1A,#02,#02,#10,#03,#03,#19,#19,#17,#04,#04,#04
	DB	#04,#16,#FF,#5D,#01,#87,#01,#05,#02,#13,#02,#3B,#02,#BC,#02,#CD
	DB	#02,#A1,#03,#DA,#03,#00,#04,#E3,#04,#20,#05,#00,#04,#AA,#05,#20
	DB	#05,#00,#04,#1D,#06,#20,#05,#00,#04,#90,#06,#20,#05,#C8,#06,#0B
	DB	#07,#4F,#07,#92,#07,#D5,#07,#1B,#08,#5E,#08,#A1,#08,#E7,#08,#2A
	DB	#09,#A1,#08,#6D,#09,#B0,#09,#D6,#09,#1C,#0A,#B0,#09,#D6,#09,#85
	DB	#0A,#E5,#0A,#27,#0B,#BD,#0B,#11,#0C,#52,#0C,#E8,#0C,#4D,#0D,#78
	DB	#0D,#98,#0D,#CD,#02,#A1,#03,#A9,#0D,#00,#04,#D9,#0D,#20,#05,#4C
	DB	#0E,#8D,#0E,#23,#0F,#4C,#0E,#69,#0F,#23,#0F,#13,#02,#87,#01,#F9
	DB	#0F,#10,#10,#1F,#10,#35,#10,#4E,#10,#60,#10,#6F,#10,#4D,#0D,#78
	DB	#0D,#7B,#10,#9A,#10,#9A,#10,#9A,#10,#9D,#10,#70,#11,#20,#05,#AD
	DB	#11,#81,#12,#DA,#03,#00,#04,#BD,#12,#20,#05,#00,#00,#25,#E7,#7F
	DB	#66,#1F,#0F,#03,#B2,#1E,#B2,#1D,#B2,#1C,#B2,#23,#1E,#B0,#B3,#25
	DB	#1F,#B2,#1E,#B2,#23,#1D,#B2,#21,#1F,#B3,#1A,#B2,#1F,#B3,#1A,#B3
	DB	#1F,#B3,#B0,#1A,#B0,#B3,#00,#20,#E5,#7F,#67,#1F,#A6,#1A,#70,#1F
	DB	#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#1F,#B2,#1A,#70,#1F
	DB	#A6,#1A,#70,#1F,#A6,#1A,#70,#21,#1F,#B2,#20,#A6,#1A,#70,#1F,#B2
	DB	#A6,#A6,#1A,#70,#1F,#A6,#1A,#70,#21,#1F,#B2,#20,#A6,#1A,#70,#1F
	DB	#A6,#1A,#70,#21,#1F,#B2,#20,#A6,#1A,#70,#1F,#B2,#1A,#70,#1F,#A6
	DB	#1A,#70,#1F,#A6,#1A,#70,#1F,#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6
	DB	#1A,#70,#21,#1F,#B2,#20,#A7,#1A,#70,#1F,#B3,#1A,#70,#1F,#A7,#1A
	DB	#70,#1F,#A7,#1A,#70,#1F,#B3,#1A,#70,#1F,#A7,#1A,#70,#1F,#A7,#1A
	DB	#70,#21,#1F,#B3,#00,#55,#70,#20,#E6,#7F,#65,#A6,#A6,#21,#A6,#9F
	DB	#9D,#9C,#00,#25,#E7,#7F,#66,#1F,#B2,#1E,#B2,#1D,#B2,#1C,#B2,#23
	DB	#1E,#B0,#B3,#25,#1F,#B2,#1E,#B2,#23,#1D,#B2,#21,#1F,#B3,#1A,#B2
	DB	#1F,#B3,#1A,#B3,#1F,#B3,#B0,#1A,#B0,#B3,#00,#20,#E5,#7F,#67,#1F
	DB	#A6,#1A,#70,#1F,#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#1F
	DB	#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#21,#1F,#B2,#20,#A6
	DB	#1A,#70,#1F,#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#1F,#B2
	DB	#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#21,#1F,#B2,#20,#A6,#1A
	DB	#70,#1F,#B2,#1A,#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#1F,#B2,#1A
	DB	#70,#1F,#A6,#1A,#70,#1F,#A6,#1A,#70,#21,#1F,#B2,#20,#A7,#1A,#70
	DB	#1F,#B3,#1A,#70,#1F,#A7,#1A,#70,#1F,#A7,#1A,#70,#1F,#B3,#1A,#70
	DB	#1F,#A7,#1A,#70,#1F,#A7,#1A,#70,#21,#1F,#B3,#00,#23,#70,#27,#F1
	DB	#7F,#60,#1F,#D6,#D6,#D6,#D6,#D6,#D6,#D6,#23,#D6,#00,#20,#E1,#7F
	DB	#62,#1F,#BE,#63,#1A,#70,#62,#1F,#B2,#63,#1A,#70,#E2,#62,#1F,#B9
	DB	#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#62,#1F,#B7,#63,#1A,#70
	DB	#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2,#63,#1A,#70,#E1,#62,#1F
	DB	#B7,#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#62,#1F,#B2,#63,#1A,#70
	DB	#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#62,#1F
	DB	#B7,#63,#1A,#70,#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2,#63,#1A
	DB	#70,#E1,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#62,#1F
	DB	#B2,#63,#1A,#70,#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63
	DB	#1A,#70,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BC,#63,#1A,#70,#E2,#62
	DB	#1F,#B2,#63,#1A,#70,#E1,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BA,#63
	DB	#1A,#70,#62,#1F,#B3,#63,#1A,#70,#E2,#62,#1F,#AE,#63,#1A,#70,#E1
	DB	#62,#1F,#BF,#63,#1A,#70,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BC,#63
	DB	#1A,#70,#E2,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70
	DB	#00,#21,#E5,#7F,#60,#1F,#BE,#B2,#6A,#B2,#60,#BE,#B2,#6B,#B0,#60
	DB	#BE,#B2,#6A,#B2,#60,#B2,#B2,#BE,#6A,#B2,#60,#B2,#BC,#6B,#B0,#60
	DB	#BE,#B2,#6A,#B2,#60,#BE,#B2,#6B,#B0,#60,#BE,#B2,#BF,#B3,#6B,#B3
	DB	#60,#BF,#B3,#6B,#B3,#60,#BC,#6B,#B3,#00,#21,#ED,#7F,#60,#1F,#8E
	DB	#8E,#9A,#8E,#9A,#8E,#8E,#9A,#8E,#8E,#9A,#8E,#9A,#8E,#8E,#9A,#8E
	DB	#8E,#9A,#8E,#9A,#8E,#8E,#9A,#8F,#8F,#9B,#8F,#9B,#8F,#8F,#9B,#00
	DB	#20,#EA,#7F,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#B2,#63,#1A,#70
	DB	#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#EA,#62
	DB	#1F,#B7,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2
	DB	#63,#1A,#70,#E1,#62,#1F,#B7,#63,#1A,#70,#EA,#62,#1F,#BE,#63,#1A
	DB	#70,#E1,#62,#1F,#B2,#63,#1A,#70,#E2,#62,#1F,#B9,#63,#1A,#70,#E1
	DB	#62,#1F,#BE,#63,#1A,#70,#EA,#62,#1F,#B7,#63,#1A,#70,#E1,#62,#1F
	DB	#BC,#63,#1A,#70,#E2,#62,#1F,#B2,#63,#1A,#70,#E1,#62,#1F,#B7,#63
	DB	#1A,#70,#EA,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#B2,#63,#1A,#70
	DB	#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#EA,#62
	DB	#1F,#B7,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2
	DB	#63,#1A,#70,#E1,#62,#1F,#B7,#63,#1A,#70,#EA,#62,#1F,#BA,#63,#1A
	DB	#70,#E1,#62,#1F,#B3,#63,#1A,#70,#E2,#62,#1F,#AE,#63,#1A,#70,#E1
	DB	#62,#1F,#BF,#63,#1A,#70,#EA,#62,#1F,#B7,#63,#1A,#70,#E1,#62,#1F
	DB	#BC,#63,#1A,#70,#E2,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#BC,#63
	DB	#1A,#70,#00,#21,#E4,#7F,#69,#1A,#D6,#B2,#1F,#B2,#1A,#B2,#B2,#B2
	DB	#1F,#B2,#1A,#B2,#1F,#B2,#1A,#B2,#B2,#1F,#B2,#1A,#B2,#B2,#1F,#B0
	DB	#1A,#B0,#68,#B2,#B2,#1F,#B2,#1A,#B2,#1F,#B2,#B2,#1A,#B2,#B2,#6B
	DB	#1F,#B3,#B3,#B3,#1A,#B3,#6D,#1F,#BF,#1A,#BF,#1F,#BF,#1A,#BF,#00
	DB	#21,#FA,#7C,#6B,#00,#60,#A6,#E4,#7F,#8E,#7C,#35,#00,#C5,#7F,#8E
	DB	#FA,#7C,#6B,#00,#95,#E4,#7C,#35,#00,#C5,#FA,#7C,#6B,#00,#95,#E4
	DB	#7C,#36,#00,#8E,#7C,#35,#00,#C5,#7F,#8E,#FA,#7C,#6A,#00,#86,#E4
	DB	#7C,#35,#00,#C5,#FA,#7C,#6A,#00,#AD,#E4,#7F,#8E,#7C,#3C,#00,#C3
	DB	#FA,#7C,#78,#00,#AB,#7C,#6B,#00,#A6,#E4,#7F,#8E,#7C,#35,#00,#C5
	DB	#7F,#8E,#FA,#7C,#6B,#00,#95,#E4,#7C,#35,#00,#C5,#FA,#7C,#6B,#00
	DB	#95,#E4,#7C,#36,#00,#8E,#7C,#32,#00,#C3,#FA,#7C,#64,#00,#AE,#E4
	DB	#7C,#64,#00,#AE,#7C,#32,#00,#C3,#FA,#7C,#64,#00,#AE,#E4,#7F,#8F
	DB	#7C,#32,#00,#C3,#FA,#7C,#64,#00,#AE,#00,#21,#E4,#7F,#61,#1F,#A6
	DB	#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61
	DB	#1F,#BC,#BE,#69,#1A,#B2,#61,#1F,#BE,#B9,#69,#1A,#B2,#61,#1F,#B7
	DB	#69,#1A,#B2,#61,#1F,#B9,#69,#1A,#B0,#20,#E5,#60,#1B,#9A,#9D,#9F
	DB	#1C,#A1,#E4,#1F,#CA,#E5,#1C,#A6,#1D,#A9,#AB,#E4,#1F,#CA,#E5,#1E
	DB	#B0,#B2,#B5,#E4,#1F,#C8,#E5,#1E,#B9,#E4,#1F,#CB,#E5,#BE,#BF,#BC
	DB	#E4,#CB,#E5,#B7,#E4,#CD,#E5,#1A,#B0,#AE,#1D,#AB,#E4,#1F,#CA,#E5
	DB	#1D,#A4,#A2,#9F,#E4,#1F,#C8,#E5,#1C,#9D,#9F,#A2,#00,#21,#E4,#7F
	DB	#61,#1F,#A6,#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61,#1F,#BE,#69
	DB	#1A,#B2,#61,#1F,#BC,#BE,#69,#1A,#B2,#61,#1F,#BE,#B9,#69,#1A,#B2
	DB	#61,#1F,#BC,#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B0,#20,#E5,#60,#1B
	DB	#9A,#9D,#9F,#1C,#A1,#E4,#1F,#CA,#E5,#1C,#A6,#1D,#A9,#AB,#E4,#1F
	DB	#CA,#E5,#1E,#B0,#B2,#B5,#E4,#1F,#C8,#E5,#1E,#B9,#E4,#1F,#CB,#E5
	DB	#BE,#BF,#BC,#E4,#CB,#E5,#B7,#E4,#CD,#E5,#1A,#B0,#AE,#1D,#AB,#E4
	DB	#1F,#CA,#E5,#1D,#A4,#A2,#9F,#E4,#1F,#C8,#E5,#1C,#9D,#9F,#A2,#00
	DB	#23,#1F,#70,#E4,#7F,#69,#B2,#F2,#60,#A4,#21,#E4,#69,#B2,#23,#F2
	DB	#60,#A4,#21,#A4,#23,#69,#B2,#60,#A4,#27,#E4,#6B,#B0,#23,#69,#B2
	DB	#F2,#60,#A4,#21,#E4,#69,#B2,#23,#F2,#60,#A4,#21,#A4,#23,#E4,#69
	DB	#B3,#F2,#60,#A4,#E4,#6D,#BF,#00,#21,#E8,#7F,#6F,#1F,#B7,#67,#B7
	DB	#6F,#B7,#B7,#20,#67,#B2,#6F,#B7,#21,#B7,#B7,#67,#B7,#6B,#B2,#67
	DB	#B6,#6B,#B2,#B2,#67,#B7,#6F,#B2,#B2,#67,#B6,#6F,#B5,#67,#B5,#6F
	DB	#B5,#B5,#20,#67,#B7,#6F,#B5,#21,#B5,#B5,#B5,#67,#BC,#6F,#B0,#6D
	DB	#B5,#67,#B7,#6F,#B0,#B0,#67,#BC,#6B,#B0,#00,#21,#EB,#7F,#64,#1F
	DB	#93,#E1,#60,#93,#9F,#93,#9F,#EB,#64,#93,#93,#E1,#60,#9F,#EB,#64
	DB	#8E,#E1,#60,#8E,#9A,#8E,#9A,#EB,#64,#8E,#EC,#8E,#EB,#9A,#91,#91
	DB	#E1,#60,#9D,#91,#EC,#64,#9D,#E1,#60,#91,#91,#EB,#64,#9D,#8C,#8C
	DB	#E1,#60,#98,#8C,#EC,#64,#98,#E1,#60,#8C,#8C,#EB,#64,#98,#00,#21
	DB	#E9,#7F,#67,#1F,#0F,#04,#AF,#1A,#AF,#20,#1F,#AB,#1A,#70,#1F,#AF
	DB	#1A,#AB,#1F,#A6,#1A,#AF,#23,#1F,#B2,#AD,#21,#1D,#B2,#23,#AD,#21
	DB	#1A,#B2,#AD,#20,#1F,#AD,#1A,#70,#1F,#AB,#1A,#AD,#23,#1F,#AD,#21
	DB	#1A,#AD,#25,#1F,#AB,#27,#A8,#21,#1D,#A6,#23,#A8,#21,#1A,#A6,#23
	DB	#A8,#00,#21,#E8,#7F,#6F,#1F,#B7,#67,#B7,#6F,#B7,#B7,#20,#67,#B2
	DB	#6F,#B7,#21,#B7,#B7,#67,#B7,#6B,#B2,#67,#B6,#6B,#B2,#B2,#67,#B7
	DB	#6F,#B2,#B2,#67,#B6,#6F,#B5,#67,#B5,#6F,#B5,#B5,#20,#67,#B7,#6F
	DB	#B5,#21,#B5,#B5,#B5,#67,#B4,#6F,#B0,#6D,#B5,#67,#B0,#6F,#B0,#B0
	DB	#67,#B4,#6B,#B0,#00,#21,#EB,#7F,#64,#1F,#93,#E1,#60,#93,#9F,#93
	DB	#EC,#64,#9F,#EB,#93,#93,#E1,#60,#9F,#EB,#64,#8E,#E1,#60,#8E,#9A
	DB	#8E,#EC,#64,#9A,#EB,#8E,#EC,#8E,#EB,#9A,#91,#91,#E1,#60,#9D,#91
	DB	#EC,#64,#9D,#E1,#60,#91,#91,#EB,#64,#9D,#8C,#8C,#E1,#60,#98,#8C
	DB	#EC,#64,#98,#E1,#60,#8C,#8C,#EB,#64,#98,#00,#21,#E9,#7F,#67,#1F
	DB	#0F,#04,#AF,#1A,#AF,#20,#1F,#AB,#1A,#70,#1F,#AF,#1A,#AB,#1F,#A6
	DB	#1A,#AF,#23,#1F,#B2,#AD,#21,#1D,#B2,#23,#AD,#21,#1A,#B2,#AD,#20
	DB	#1F,#AD,#1A,#70,#1F,#AF,#1A,#AD,#23,#1F,#B0,#21,#1A,#B0,#25,#1F
	DB	#B2,#27,#B7,#21,#1D,#B0,#23,#B7,#21,#1A,#B0,#23,#B7,#00,#21,#E8
	DB	#7F,#6F,#1F,#B9,#67,#B9,#6F,#B9,#B9,#20,#67,#B4,#6F,#B9,#21,#B9
	DB	#B9,#67,#B9,#6B,#B4,#67,#B8,#6B,#B4,#B4,#67,#B9,#6F,#B4,#B4,#67
	DB	#B8,#6F,#B7,#67,#B7,#6F,#B7,#B7,#20,#67,#B9,#6F,#B7,#21,#B7,#B7
	DB	#B7,#67,#BE,#6F,#B2,#6D,#B7,#67,#B9,#6F,#B2,#B2,#67,#BE,#6B,#B2
	DB	#00,#21,#EB,#7F,#64,#1F,#95,#E1,#60,#95,#A1,#95,#EC,#64,#A1,#EB
	DB	#95,#95,#E1,#60,#A1,#EB,#64,#90,#E1,#60,#90,#9C,#90,#EC,#64,#9C
	DB	#EB,#90,#EC,#90,#EB,#9C,#93,#93,#E1,#60,#9F,#93,#EC,#64,#9F,#E1
	DB	#60,#93,#93,#EB,#64,#9F,#8E,#8E,#E1,#60,#9A,#8E,#EC,#64,#9A,#E1
	DB	#60,#8E,#8E,#EB,#64,#9A,#00,#21,#E9,#7F,#67,#1F,#0F,#04,#B1,#1A
	DB	#B1,#20,#1F,#AD,#1A,#70,#1F,#B1,#1A,#AD,#1F,#A8,#1A,#B1,#23,#1F
	DB	#B4,#AF,#21,#1D,#B4,#23,#AF,#21,#1A,#B4,#AF,#20,#1F,#AF,#1A,#70
	DB	#1F,#AD,#1A,#AF,#23,#1F,#AF,#21,#1A,#AF,#25,#1F,#AD,#27,#AA,#21
	DB	#1D,#A8,#23,#AA,#21,#1A,#A8,#23,#AA,#00,#21,#E8,#7F,#6F,#1F,#B9
	DB	#67,#B9,#6F,#B9,#B9,#20,#67,#B4,#6F,#B9,#21,#B9,#B9,#67,#B9,#6B
	DB	#B4,#67,#B8,#6B,#B4,#B4,#67,#B9,#6F,#B4,#B4,#67,#B8,#6F,#B7,#67
	DB	#B7,#6F,#B7,#B7,#20,#67,#B9,#6F,#B7,#21,#B7,#B7,#B7,#67,#B6,#6F
	DB	#B2,#6D,#B7,#67,#B2,#6F,#B2,#B2,#67,#B6,#6B,#B2,#00,#21,#E9,#7F
	DB	#67,#1F,#0F,#04,#B1,#1A,#B1,#20,#1F,#AD,#1A,#70,#1F,#B1,#1A,#AD
	DB	#1F,#A8,#1A,#B1,#23,#1F,#B4,#AF,#21,#1D,#B4,#23,#AF,#21,#1A,#B4
	DB	#AF,#20,#1F,#AF,#1A,#70,#1F,#B1,#1A,#AF,#23,#1F,#B2,#21,#1A,#B2
	DB	#25,#1F,#B4,#27,#B9,#21,#1D,#B2,#23,#B9,#21,#1A,#B2,#23,#B9,#00
	DB	#21,#E8,#7F,#67,#1F,#A3,#AA,#AF,#AA,#B3,#AA,#AF,#AA,#A5,#AA,#AE
	DB	#AA,#B1,#AA,#AE,#AA,#A8,#AD,#B1,#AD,#B4,#AD,#B1,#AD,#A8,#AC,#AF
	DB	#AC,#B4,#AC,#AF,#AC,#00,#21,#EB,#7F,#64,#1F,#97,#E1,#60,#97,#A3
	DB	#97,#EC,#64,#A3,#EB,#97,#97,#E1,#60,#A3,#EB,#64,#92,#E1,#60,#92
	DB	#9E,#92,#EC,#64,#9E,#EB,#92,#EC,#92,#EB,#9E,#95,#95,#E1,#60,#A1
	DB	#95,#EC,#64,#A1,#E1,#60,#95,#95,#EB,#64,#A1,#90,#90,#E1,#60,#9C
	DB	#90,#EC,#64,#9C,#E1,#60,#90,#90,#EB,#64,#9C,#00,#21,#E9,#7F,#67
	DB	#1F,#0F,#04,#B3,#1A,#B3,#20,#1F,#AF,#1A,#70,#1F,#B3,#1A,#AF,#1F
	DB	#AA,#1A,#B3,#23,#1F,#B6,#22,#B1,#20,#0E,#06,#70,#21,#1D,#B6,#22
	DB	#B1,#20,#0E,#06,#70,#21,#1A,#B6,#B1,#20,#1F,#B1,#1A,#70,#1F,#AF
	DB	#1A,#B1,#22,#1F,#B1,#20,#0E,#05,#70,#21,#1A,#B1,#24,#1F,#AF,#20
	DB	#0E,#05,#70,#24,#AC,#20,#0E,#05,#70,#A8,#1A,#70,#1F,#AA,#1A,#A8
	DB	#1F,#AC,#1A,#AA,#1F,#AF,#1A,#A8,#1F,#AC,#1A,#B4,#1F,#AF,#1A,#AC
	DB	#1F,#B1,#1A,#AF,#00,#21,#E9,#7F,#67,#1F,#0F,#04,#B3,#1A,#B3,#20
	DB	#1F,#AF,#1A,#70,#1F,#B3,#1A,#AF,#1F,#AA,#1A,#B3,#23,#1F,#B6,#22
	DB	#B1,#20,#0E,#05,#70,#21,#1D,#B6,#22,#B1,#20,#0E,#05,#70,#21,#1A
	DB	#B6,#B1,#20,#1F,#B1,#1A,#70,#1F,#B3,#1A,#B1,#22,#1F,#B4,#20,#0E
	DB	#05,#70,#21,#1A,#B4,#23,#1F,#B6,#21,#0E,#05,#70,#25,#BB,#0E,#05
	DB	#70,#20,#E5,#64,#1A,#C0,#1B,#BF,#1C,#BB,#1D,#B8,#1E,#C0,#1D,#BF
	DB	#1C,#BB,#1B,#B8,#00,#21,#E8,#7F,#6E,#1F,#B6,#67,#B6,#6E,#B6,#B6
	DB	#20,#67,#B1,#6B,#B6,#21,#B6,#B6,#67,#B6,#6F,#BB,#67,#B3,#6D,#BB
	DB	#BB,#67,#AF,#6D,#BB,#BB,#67,#B3,#6A,#B1,#67,#B4,#6A,#B1,#B1,#20
	DB	#67,#B8,#6A,#B1,#21,#B1,#B1,#B1,#67,#B3,#6C,#B8,#B8,#67,#B8,#6C
	DB	#B8,#B8,#67,#B3,#6C,#B8,#00,#20,#EB,#1F,#92,#1E,#70,#E1,#1F,#92
	DB	#1E,#70,#1F,#9E,#1E,#70,#1F,#92,#1E,#70,#EC,#1F,#9E,#1E,#70,#EB
	DB	#1F,#92,#1E,#70,#EC,#1F,#92,#1E,#70,#EB,#1F,#9E,#1E,#70,#7F,#60
	DB	#1F,#97,#1E,#70,#E1,#1F,#97,#1E,#70,#1F,#A3,#1E,#70,#1F,#97,#1E
	DB	#70,#EC,#1F,#A3,#1E,#70,#E1,#1F,#97,#1E,#70,#EB,#1F,#97,#1E,#70
	DB	#E1,#1F,#A3,#1E,#70,#1F,#8D,#1E,#70,#1F,#8D,#1E,#70,#1F,#99,#1E
	DB	#70,#1F,#8D,#1E,#70,#EC,#1F,#99,#1E,#70,#E1,#1F,#8D,#1E,#70,#1F
	DB	#8D,#1E,#70,#EB,#1F,#99,#1E,#70,#1F,#94,#1E,#70,#1F,#94,#1E,#70
	DB	#E1,#1F,#A0,#1E,#70,#1F,#94,#1E,#70,#EC,#1F,#A0,#1E,#70,#E1,#1F
	DB	#94,#1E,#70,#1F,#94,#1E,#70,#EB,#1F,#A0,#1E,#70,#00,#21,#E9,#7F
	DB	#67,#1F,#0F,#04,#B6,#1A,#B6,#20,#1F,#B1,#1A,#70,#1F,#B6,#1A,#70
	DB	#1F,#AE,#1A,#70,#23,#1F,#B6,#22,#B3,#20,#0E,#04,#70,#21,#1D,#B6
	DB	#22,#B1,#20,#0E,#04,#70,#21,#1A,#B6,#B1,#20,#1F,#B1,#1A,#70,#1F
	DB	#B3,#1A,#B1,#22,#1F,#B4,#20,#0E,#05,#70,#21,#B3,#B4,#B1,#22,#B8
	DB	#20,#0E,#05,#70,#25,#BD,#23,#0E,#01,#70,#27,#0D,#07,#0E,#00,#BB
	DB	#00,#21,#E8,#7F,#6B,#1F,#B4,#67,#B4,#6B,#B4,#B4,#20,#67,#B4,#6B
	DB	#B4,#21,#B4,#B4,#67,#B4,#6F,#BB,#67,#B3,#6D,#BB,#BB,#67,#AF,#6D
	DB	#BB,#BB,#67,#BB,#6A,#B1,#67,#B1,#6A,#B1,#B1,#20,#67,#B1,#6A,#B1
	DB	#21,#B1,#B1,#B1,#6D,#BB,#BB,#BB,#67,#BB,#6D,#BB,#BB,#67,#BB,#6D
	DB	#BB,#00,#20,#EB,#1F,#90,#1E,#70,#E1,#1F,#90,#1E,#70,#1F,#9C,#1E
	DB	#70,#1F,#90,#1E,#70,#EC,#1F,#9C,#1E,#70,#EB,#1F,#90,#1E,#70,#EC
	DB	#1F,#90,#1E,#70,#EB,#1F,#9C,#1E,#70,#7F,#60,#1F,#97,#1E,#70,#E1
	DB	#1F,#97,#1E,#70,#1F,#A3,#1E,#70,#1F,#97,#1E,#70,#EC,#1F,#A3,#1E
	DB	#70,#E1,#1F,#97,#1E,#70,#EB,#1F,#97,#1E,#70,#E1,#1F,#A3,#1E,#70
	DB	#15,#8D,#1E,#70,#1F,#8D,#1E,#70,#1F,#99,#1E,#70,#1F,#8D,#1E,#70
	DB	#EC,#1F,#99,#1E,#70,#E1,#1F,#8D,#1E,#70,#1F,#8D,#1E,#70,#EB,#1F
	DB	#99,#1E,#70,#1F,#8F,#1E,#70,#1F,#8F,#1E,#70,#E1,#1F,#9B,#1E,#70
	DB	#1F,#8F,#1E,#70,#EC,#1F,#9B,#1E,#70,#E1,#1F,#8F,#1E,#70,#1F,#8F
	DB	#1E,#70,#EB,#1F,#9B,#1E,#70,#00,#21,#E9,#7F,#67,#1F,#0F,#04,#BB
	DB	#1A,#BB,#20,#1F,#B8,#1A,#70,#1F,#BB,#1A,#70,#1F,#B4,#1A,#70,#22
	DB	#1F,#BB,#20,#0E,#04,#70,#23,#B6,#21,#1D,#BB,#23,#B6,#21,#1A,#BB
	DB	#B6,#20,#64,#1F,#B8,#1A,#70,#1F,#BA,#1A,#B8,#21,#1F,#0F,#04,#BB
	DB	#1A,#BB,#20,#1F,#B8,#1A,#BB,#1F,#BB,#1A,#B8,#1F,#B4,#1A,#B8,#23
	DB	#1F,#BB,#22,#B6,#20,#0E,#04,#70,#21,#60,#1D,#BB,#23,#B6,#21,#1A
	DB	#BB,#B6,#20,#67,#1F,#B8,#1A,#70,#1F,#BA,#1A,#B8,#00,#21,#EA,#7F
	DB	#69,#1F,#BE,#1E,#70,#20,#1D,#70,#BE,#21,#1C,#70,#1B,#70,#1A,#BE
	DB	#19,#70,#20,#18,#70,#BE,#21,#17,#70,#16,#70,#15,#70,#14,#70,#13
	DB	#70,#20,#12,#70,#24,#11,#70,#00,#21,#E4,#7F,#67,#1F,#BE,#1A,#70
	DB	#1C,#BC,#23,#1B,#BE,#21,#1A,#BC,#23,#19,#BE,#21,#18,#BC,#23,#17
	DB	#BE,#21,#16,#BC,#27,#14,#BE,#00,#24,#E4,#7C,#6A,#00,#60,#C5,#19
	DB	#B9,#23,#1A,#AD,#16,#8E,#2D,#E0,#00,#21,#ED,#7F,#60,#1F,#8E,#8E
	DB	#9A,#8E,#9A,#8E,#8E,#9A,#8E,#8E,#9A,#8E,#9A,#8E,#8E,#9A,#EB,#64
	DB	#8E,#F3,#60,#1A,#A6,#A6,#1B,#A6,#A6,#1C,#A6,#1D,#A6,#1E,#A6,#1F
	DB	#A6,#A6,#A6,#A6,#A6,#A6,#A6,#A6,#00,#21,#E4,#7F,#61,#1F,#A6,#69
	DB	#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61,#1F
	DB	#BC,#BE,#69,#1A,#B2,#61,#1F,#BE,#C1,#69,#1A,#B2,#61,#1F,#C3,#69
	DB	#1A,#B2,#61,#1F,#C5,#69,#1A,#B0,#20,#E5,#60,#1B,#9A,#9D,#9F,#1C
	DB	#A1,#E4,#1F,#CA,#E5,#1C,#A6,#1D,#A9,#AB,#E4,#1F,#CA,#E5,#1E,#B0
	DB	#B2,#B5,#E4,#1F,#C8,#E5,#1E,#B9,#E4,#1F,#CB,#E5,#BE,#BF,#BC,#E4
	DB	#CB,#E5,#B7,#E4,#CD,#E5,#1A,#B0,#AE,#1D,#AB,#E4,#1F,#CF,#E5,#1D
	DB	#A4,#A2,#9F,#E4,#1F,#D2,#E5,#1C,#9D,#9F,#A2,#00,#21,#E8,#7F,#6B
	DB	#1F,#B4,#67,#B4,#6B,#B4,#B4,#20,#67,#B4,#6B,#B4,#21,#B4,#B4,#67
	DB	#B4,#6F,#BB,#67,#B3,#6D,#BB,#BB,#67,#B6,#6D,#BB,#BB,#67,#B3,#6A
	DB	#B1,#67,#BB,#6A,#B1,#B1,#20,#67,#BB,#6A,#B1,#21,#B1,#B1,#B1,#6E
	DB	#B6,#B6,#B6,#67,#BB,#6B,#B6,#B6,#67,#BA,#6B,#B6,#00,#20,#EB,#1F
	DB	#90,#1E,#70,#E1,#1F,#90,#1E,#70,#1F,#9C,#1E,#70,#1F,#90,#1E,#70
	DB	#EC,#1F,#9C,#1E,#70,#EB,#1F,#90,#1E,#70,#EC,#1F,#90,#1E,#70,#EB
	DB	#1F,#9C,#1E,#70,#7F,#60,#1F,#97,#1E,#70,#E1,#1F,#97,#1E,#70,#1F
	DB	#A3,#1E,#70,#1F,#97,#1E,#70,#EC,#1F,#A3,#1E,#70,#E1,#1F,#97,#1E
	DB	#70,#EB,#1F,#97,#1E,#70,#E1,#1F,#A3,#1E,#70,#1F,#8D,#1E,#70,#1F
	DB	#8D,#1E,#70,#1F,#99,#1E,#70,#1F,#8D,#1E,#70,#EC,#1F,#99,#1E,#70
	DB	#E1,#1F,#8D,#1E,#70,#1F,#8D,#1E,#70,#EB,#1F,#99,#1E,#70,#1F,#92
	DB	#1E,#70,#1F,#92,#1E,#70,#E1,#1F,#9E,#1E,#70,#1F,#92,#1E,#70,#EC
	DB	#1F,#9E,#1E,#70,#E1,#1F,#92,#1E,#70,#1F,#92,#1E,#70,#EB,#1F,#9E
	DB	#1E,#70,#00,#21,#E9,#7F,#67,#1F,#0F,#04,#BB,#1A,#BB,#20,#1F,#B8
	DB	#1A,#70,#1F,#BB,#1A,#70,#1F,#B4,#1A,#70,#22,#1F,#BB,#20,#0E,#04
	DB	#70,#23,#B6,#21,#1D,#BB,#B6,#1F,#AF,#B3,#20,#1A,#70,#21,#1F,#B6
	DB	#20,#1A,#70,#1F,#BB,#1D,#70,#29,#1F,#BF,#21,#0E,#FF,#70,#C0,#BF
	DB	#25,#BF,#21,#0E,#01,#70,#27,#BD,#00,#20,#EB,#1F,#90,#1E,#70,#E1
	DB	#1F,#90,#1E,#70,#1F,#9C,#1E,#70,#1F,#90,#1E,#70,#EC,#1F,#9C,#1E
	DB	#70,#EB,#1F,#90,#1E,#70,#EC,#1F,#90,#1E,#70,#EB,#1F,#9C,#1E,#70
	DB	#7F,#60,#1F,#97,#1E,#70,#E1,#1F,#97,#1E,#70,#1F,#A3,#1E,#70,#1F
	DB	#97,#1E,#70,#EC,#1F,#A3,#1E,#70,#E1,#1F,#97,#1E,#70,#EB,#1F,#97
	DB	#1E,#70,#E1,#1F,#A3,#1E,#70,#21,#EB,#8D,#20,#E3,#1F,#A8,#1B,#70
	DB	#1F,#AC,#1B,#70,#1F,#A8,#1B,#70,#1F,#B1,#1B,#70,#1F,#A8,#1B,#70
	DB	#1F,#AC,#1B,#70,#1F,#A8,#1B,#70,#1F,#9E,#1B,#70,#1F,#A5,#1B,#70
	DB	#1F,#AA,#1B,#70,#1F,#A5,#1B,#70,#1F,#AF,#1B,#70,#1F,#AE,#1B,#70
	DB	#1F,#AA,#1B,#70,#1F,#A5,#1B,#70,#00,#23,#9A,#1D,#9A,#1C,#9A,#49
	DB	#1A,#9A,#20,#E6,#7F,#65,#1E,#A6,#A6,#21,#1F,#A6,#9F,#9D,#9C,#00
	DB	#23,#E8,#7F,#6D,#1F,#BB,#27,#F0,#DB,#DB,#DB,#23,#E8,#BC,#00,#20
	DB	#E3,#7F,#60,#1F,#A3,#22,#1B,#70,#21,#0E,#1D,#70,#35,#E0,#20,#1F
	DB	#A4,#22,#1B,#70,#00,#21,#E9,#7F,#67,#1F,#0F,#03,#BB,#1A,#BB,#18
	DB	#BB,#16,#BB,#33,#12,#BB,#21,#1F,#0F,#03,#BC,#1A,#BC,#00,#21,#EB
	DB	#7F,#69,#1F,#B2,#E1,#1D,#B2,#1A,#B2,#17,#B2,#23,#13,#B2,#E0,#00
	DB	#21,#7F,#61,#1F,#BE,#1A,#BE,#BE,#18,#BE,#23,#15,#BE,#E0,#00,#23
	DB	#ED,#7C,#6A,#00,#60,#0F,#03,#A6,#2B,#E0,#00,#24,#E4,#7C,#6A,#00
	DB	#60,#C5,#19,#B9,#23,#1A,#AD,#21,#16,#8E,#F3,#7F,#1A,#A6,#1B,#A6
	DB	#1C,#A6,#1D,#A6,#1F,#A6,#A6,#A6,#A6,#00,#5F,#70,#00,#20,#EA,#7F
	DB	#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#B2,#63,#1A,#70,#62,#1F,#B9
	DB	#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#EA,#62,#1F,#B7,#63,#1A,#70
	DB	#E1,#62,#1F,#BC,#63,#1A,#70,#62,#1F,#B2,#63,#1A,#70,#62,#1F,#B7
	DB	#63,#1A,#70,#EA,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#B2,#63,#1A
	DB	#70,#62,#1F,#B9,#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#EA,#62,#1F
	DB	#B7,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70,#62,#1F,#B2,#63,#1A
	DB	#70,#62,#1F,#B7,#63,#1A,#70,#EA,#62,#1F,#BE,#63,#1A,#70,#E1,#62
	DB	#1F,#B2,#63,#1A,#70,#62,#1F,#B9,#63,#1A,#70,#62,#1F,#BE,#63,#1A
	DB	#70,#EA,#62,#1F,#B7,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70,#62
	DB	#1F,#B2,#63,#1A,#70,#62,#1F,#B7,#63,#1A,#70,#EA,#62,#1F,#BA,#63
	DB	#1A,#70,#E1,#62,#1F,#B3,#63,#1A,#70,#62,#1F,#AE,#63,#1A,#70,#62
	DB	#1F,#BF,#63,#1A,#70,#EA,#62,#1F,#B7,#63,#1A,#70,#E1,#62,#1F,#BC
	DB	#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#62,#1F,#BC,#63,#1A,#70,#00
	DB	#21,#E4,#7F,#69,#1A,#B2,#B2,#1F,#B2,#1A,#B2,#B2,#B2,#1F,#B2,#1A
	DB	#B2,#1F,#B2,#1A,#B2,#B2,#1F,#B2,#1A,#B2,#B2,#1F,#B0,#1A,#B0,#6E
	DB	#B2,#B2,#1F,#B2,#1A,#B2,#1F,#B2,#B2,#1A,#B2,#B2,#6D,#1F,#BF,#BF
	DB	#BF,#1A,#BF,#6B,#1F,#B3,#1A,#B3,#1F,#B3,#1A,#B3,#00,#20,#E3,#7F
	DB	#60,#1F,#A6,#1A,#70,#E1,#62,#1F,#B2,#63,#1A,#70,#E2,#62,#1F,#B9
	DB	#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#62,#1F,#B7,#63,#1A,#70
	DB	#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2,#63,#1A,#70,#E1,#62,#1F
	DB	#B7,#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#62,#1F,#B2,#63,#1A,#70
	DB	#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63,#1A,#70,#62,#1F
	DB	#B7,#63,#1A,#70,#62,#1F,#BC,#63,#1A,#70,#E2,#62,#1F,#B2,#63,#1A
	DB	#70,#E1,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BE,#63,#1A,#70,#62,#1F
	DB	#B2,#63,#1A,#70,#E2,#62,#1F,#B9,#63,#1A,#70,#E1,#62,#1F,#BE,#63
	DB	#1A,#70,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BC,#63,#1A,#70,#E2,#62
	DB	#1F,#B2,#63,#1A,#70,#E1,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BA,#63
	DB	#1A,#70,#62,#1F,#B3,#63,#1A,#70,#E2,#62,#1F,#AE,#63,#1A,#70,#E1
	DB	#62,#1F,#BF,#63,#1A,#70,#62,#1F,#B7,#63,#1A,#70,#62,#1F,#BC,#63
	DB	#1A,#70,#E2,#62,#1F,#BE,#63,#1A,#70,#E1,#62,#1F,#BC,#63,#1A,#70
	DB	#00,#21,#E9,#7F,#67,#1F,#BE,#1C,#BE,#1A,#BE,#E5,#60,#1F,#BE,#B2
	DB	#6B,#B0,#60,#BE,#B2,#6A,#B2,#60,#B2,#B2,#BE,#6A,#B2,#60,#B2,#BC
	DB	#6B,#B0,#60,#BE,#B2,#6A,#B2,#60,#BE,#B2,#6B,#B0,#60,#BE,#B2,#BF
	DB	#B3,#6B,#B3,#60,#BF,#B3,#6B,#B3,#60,#BC,#6B,#B3,#00,#21,#E4,#7F
	DB	#61,#1F,#A6,#69,#1A,#B2,#61,#1F,#BE,#69,#1A,#B2,#61,#1F,#BE,#69
	DB	#1A,#B2,#61,#1F,#BC,#BE,#69,#1A,#B2,#61,#1F,#BE,#B9,#69,#1A,#B2
	DB	#61,#1F,#B7,#69,#1A,#B2,#61,#1F,#B9,#69,#1A,#B0,#20,#E5,#60,#1B
	DB	#9A,#9D,#9F,#1C,#A1,#F2,#1F,#CA,#E5,#1C,#A6,#1D,#A9,#AB,#F2,#1F
	DB	#CA,#E5,#1E,#B0,#B2,#B5,#F2,#1F,#C8,#E5,#1E,#B9,#F2,#1F,#CB,#E5
	DB	#BE,#BF,#BC,#F2,#CB,#E5,#B7,#F2,#CD,#E5,#1A,#B0,#AE,#1D,#AB,#F2
	DB	#1F,#CA,#E5,#1D,#A4,#A2,#9F,#F2,#1F,#C8,#E5,#1C,#9D,#9F,#A2,#00
	DB	#08,#04,#08,#D0,#00,#01,#D0,#00,#01,#D0,#00,#01,#D0,#00,#01,#D0
	DB	#00,#01,#D0,#00,#01,#D0,#00,#01,#D0,#00,#09,#08,#08,#D0,#00,#08
	DB	#D0,#00,#08,#D0,#00,#01,#D0,#00,#01,#D0,#00,#01,#D0,#00,#01,#D0
	DB	#00,#01,#D0,#00,#01,#D0,#00,#07,#06,#89,#C0,#00,#61,#C0,#00,#21
	DB	#C0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00,#0D,#0C
	DB	#01,#E0,#00,#01,#E0,#00,#01,#D0,#00,#01,#D0,#00,#01,#C0,#00,#01
	DB	#C0,#00,#01,#B0,#00,#01,#B0,#00,#01,#A0,#00,#01,#A0,#00,#01,#90
	DB	#00,#01,#90,#00,#01,#80,#00,#19,#18,#01,#D0,#00,#01,#C0,#00,#01
	DB	#B0,#00,#01,#A0,#00,#01,#80,#00,#01,#50,#00,#01,#30,#00,#01,#00
	DB	#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00
	DB	#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01
	DB	#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00
	DB	#00,#01,#00,#00,#31,#30,#38,#D0,#02,#28,#C0,#02,#20,#A0,#02,#18
	DB	#80,#02,#14,#70,#02,#0C,#60,#02,#0C,#60,#02,#0C,#60,#02,#08,#50
	DB	#02,#01,#30,#02,#01,#20,#02,#03,#00,#02,#05,#00,#02,#05,#00,#02
	DB	#05,#00,#02,#05,#00,#02,#01,#00,#02,#01,#00,#02,#01,#00,#02,#01
	DB	#00,#02,#05,#00,#02,#05,#00,#02,#05,#00,#02,#05,#00,#02,#01,#00
	DB	#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00
	DB	#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#01,#00,#00,#03
	DB	#00,#00,#03,#00,#00,#02,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
	DB	#00,#00,#00,#00,#00,#00,#00,#00,#00,#40,#3F,#00,#E0,#00,#01,#E0
	DB	#00,#01,#D0,#00,#01,#D0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00
	DB	#01,#C0,#00,#01,#C0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01
	DB	#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#A0,#00,#01,#A0,#00,#01,#A0
	DB	#00,#01,#A0,#00,#01,#A0,#00,#01,#A0,#00,#01,#A0,#00,#01,#A0,#00
	DB	#01,#A0,#00,#01,#A0,#00,#01,#90,#00,#01,#90,#00,#01,#90,#00,#01
	DB	#90,#00,#01,#90,#00,#01,#90,#00,#01,#90,#00,#01,#90,#00,#01,#90
	DB	#00,#01,#90,#00,#01,#90,#00,#01,#90,#00,#01,#90,#00,#01,#90,#00
	DB	#01,#80,#00,#01,#80,#00,#01,#80,#00,#01,#80,#00,#01,#80,#00,#01
	DB	#80,#00,#01,#80,#00,#01,#80,#00,#01,#80,#00,#01,#70,#00,#01,#70
	DB	#00,#01,#70,#00,#01,#70,#00,#01,#70,#00,#01,#70,#00,#01,#60,#00
	DB	#01,#60,#00,#01,#60,#00,#01,#60,#00,#01,#60,#00,#01,#60,#00,#01
	DB	#60,#00,#01,#50,#00,#01,#40,#00,#01,#30,#00,#12,#11,#09,#D0,#00
	DB	#01,#C0,#00,#01,#B0,#00,#01,#A0,#00,#01,#A0,#01,#01,#A0,#01,#05
	DB	#90,#01,#05,#80,#01,#01,#80,#00,#01,#70,#00,#01,#70,#00,#01,#60
	DB	#00,#01,#50,#00,#01,#40,#00,#01,#40,#00,#01,#30,#00,#01,#10,#00
	DB	#01,#00,#00,#40,#3F,#01,#F0,#00,#01,#D0,#00,#01,#D0,#00,#01,#D0
	DB	#00,#01,#D0,#00,#01,#D0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00
	DB	#01,#C0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00,#01
	DB	#C0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0
	DB	#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00
	DB	#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01,#B0,#00,#01
	DB	#B0,#00,#01,#B0,#00,#01,#B0,#02,#01,#B0,#02,#01,#B0,#02,#05,#B0
	DB	#02,#05,#B0,#02,#05,#B0,#02,#05,#A0,#02,#01,#A0,#02,#01,#A0,#02
	DB	#01,#A0,#02,#01,#A0,#02,#05,#A0,#02,#05,#A0,#02,#05,#A0,#02,#05
	DB	#A0,#02,#01,#90,#02,#01,#90,#02,#01,#90,#02,#01,#90,#02,#05,#90
	DB	#02,#05,#90,#02,#05,#90,#02,#05,#90,#02,#01,#90,#02,#01,#90,#02
	DB	#01,#90,#02,#01,#90,#02,#05,#90,#02,#05,#90,#02,#05,#90,#02,#01
	DB	#90,#02,#01,#90,#00,#07,#06,#74,#F1,#00,#05,#F2,#80,#05,#E3,#80
	DB	#01,#C0,#00,#01,#E0,#00,#01,#E0,#00,#01,#E0,#00,#0D,#0C,#FC,#F1
	DB	#00,#05,#E2,#80,#05,#D3,#80,#01,#C0,#00,#01,#C0,#00,#01,#C0,#00
	DB	#01,#B0,#00,#01,#B0,#00,#01,#A0,#00,#01,#A0,#00,#01,#90,#00,#01
	DB	#90,#00,#01,#80,#00,#0D,#0C,#1C,#F0,#80,#0C,#E1,#00,#0C,#D1,#80
	DB	#00,#D0,#00,#01,#C0,#00,#01,#C0,#00,#01,#B0,#00,#01,#B0,#00,#01
	DB	#A0,#00,#01,#A0,#00,#01,#90,#00,#01,#90,#00,#01,#80,#00,#0D,#0C
	DB	#01,#E0,#00,#01,#E0,#00,#01,#D0,#00,#01,#D0,#00,#01,#C0,#00,#01
	DB	#C0,#00,#01,#B0,#00,#01,#B0,#00,#01,#A0,#00,#01,#A0,#00,#01,#90
	DB	#00,#01,#90,#00,#01,#80,#00,#01,#00,#00,#00,#00,#01,#00,#00,#00
	DB	#00,#33,#32,#00,#D0,#00,#02,#90,#00,#02,#50,#00,#02,#20,#00,#03
	DB	#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00
	DB	#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00
	DB	#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03
	DB	#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00
	DB	#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00
	DB	#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03
	DB	#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00
	DB	#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00
	DB	#03,#00,#00,#03,#00,#00,#03,#00,#00,#03,#00,#00,#10,#0F,#02,#D0
	DB	#00,#02,#C0,#00,#02,#B0,#00,#02,#B0,#00,#02,#A0,#00,#02,#A0,#00
	DB	#02,#90,#00,#02,#90,#00,#02,#80,#00,#02,#80,#00,#02,#60,#00,#02
	DB	#50,#00,#02,#30,#00,#02,#10,#00,#02,#00,#00,#02,#00,#00,#11,#10
	DB	#FA,#E0,#00,#FA,#D0,#01,#FA,#C0,#00,#FA,#B0,#01,#FA,#A0,#00,#FA
	DB	#90,#01,#FA,#80,#00,#FA,#70,#01,#FA,#60,#00,#FA,#50,#01,#FA,#40
	DB	#00,#FA,#30,#01,#FA,#20,#00,#FA,#00,#01,#FA,#00,#00,#00,#00,#01
	DB	#00,#00,#00,#0C,#0B,#24,#F2,#01,#05,#D2,#C2,#05,#B4,#01,#05,#84
	DB	#C1,#05,#65,#81,#05,#06,#41,#05,#07,#01,#05,#07,#40,#05,#08,#41
	DB	#05,#08,#80,#05,#09,#09,#00,#00,#00,#01,#00,#00,#00,#00,#01,#00
	DB	#00,#00,#00,#01,#00,#00,#00,#00,#01,#00,#00,#00,#00,#01,#00,#00
	DB	#00,#00,#01,#00,#00,#00,#00,#01,#00,#03,#00,#00,#01,#00,#00,#00
	DB	#00,#01,#00,#00,#00,#00,#01,#00,#00,#00,#00,#01,#00,#00,#00,#00
	DB	#01,#00,#00,#00,#00,#01,#00,#00,#06,#05,#0C,#13,#00,#00,#00,#00
	DB	#07,#06,#00,#18,#07,#00,#00,#00,#00,#04,#02,#00,#F4,#0C,#00,#04
	DB	#03,#18,#18,#00,#00,#13,#12,#00,#FE,#FC,#FA,#F8,#F6,#F4,#F2,#F0
	DB	#EE,#EC,#EA,#E6,#E4,#E2,#E0,#DE,#DC,#DA,#0D,#0C,#18,#13,#0C,#07
	DB	#00,#F4,#0C,#07,#00,#F4,#07,#00,#F4,#07,#06,#24,#0C,#0C,#00,#F4
	DB	#00,#00,#03,#00,#00,#05,#0C,#03,#00,#00,#07,#0C,#03,#00,#00,#03
	DB	#07,#03,#00,#07,#04,#00,#03,#00,#F7,#FB,#00,#03,#00,#F8,#FB,#00
	DB	#03,#00,#00,#05,#07,#03,#00,#FB,#00,#04
; Taille totale 6330 octets


;
; PT2 PLAYER
;
TonA    EQU 0
TonB    EQU 2
TonC    EQU 4
Noise    EQU 6
Mixer    EQU 7
AmplA    EQU 8
AmplB    EQU 9
AmplC    EQU 10
Env    EQU 11
EnvTp    EQU 13


INIT:
		LD	HL,MdlAddr
        LD A,(HL)
        LD (PL1D+1),A
        PUSH HL
        INC HL
        INC HL
        LD A,(HL)
        EX AF,AF''
        INC HL
        LD (SamPtrs+1),HL
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD A,E
        OR D
        CALL NZ,PhF2PT
        LD DE,63
        ADD HL,DE
        LD (OrnPtrs+1),HL
        LD E,32
        ADD HL,DE
        LD C,(HL)
        INC HL
        LD B,(HL)
        LD E,30
        ADD HL,DE
        LD (CrPsPtr+1),HL
        INC HL
        EX AF,AF''
        LD E,A
        ADD HL,DE
        LD (LPosPtr+1),HL
        POP HL
        ADD HL,BC
        LD (PatsPtr+1),HL
        LD HL,VARS
        LD (HL),D
        LD DE,VARS+1
        LD BC,VAR0END-VARS-1
        LDIR
        LD (AdInPtA+1),HL ;ptr to zero
        LD HL,#F01 ;H - Volume, L - SkpCnt
        LD (ChanA+SkpCnt),HL
        LD (ChanB+SkpCnt),HL
        LD (ChanC+SkpCnt),HL
        LD A,L
        LD (DelyCnt),A
        LD HL,EMPTYORN
        LD (ChanA+OrnPtr),HL
        LD (ChanB+OrnPtr),HL
        LD (ChanC+OrnPtr),HL

;note table creator (same as PT3 table #1)
;(c)Ivan Roshin

        LD HL,NTBL
        LD DE,NT_
        LD B,12
L1:
        PUSH BC
        LD C,(HL)
        INC HL
        PUSH HL
        LD B,(HL)
        PUSH DE
        EX DE,HL
        LD DE,23
        DB #DD:LD H,8
L2:
        SRL B
        RR C
        LD (HL),C
        INC HL
        LD (HL),B
        ADD HL,DE
        DB #DD:DEC H
        JR NZ,L2
        POP DE
        INC DE
        INC DE
        POP HL
        INC HL
        POP BC
        DJNZ L1
        LD A,#FD
        LD (NT_+#2E),A
        LD A,#0A
        LD (NT_+#5C),A

;vol table creator (same as PT3.5+ table)
;(c)Ivan Roshin

        LD HL,#11
        LD D,H
        LD E,H
        LD IX,VT_+16
        LD C,#10
INITV2:
        PUSH HL
        ADD HL,DE
        EX DE,HL
        SBC HL,HL
INITV1:
        LD A,L
        RLA
        LD A,H
        ADC A,0
        LD (IX+0),A
        INC IX
        ADD HL,DE
        INC C
        LD A,C
        AND 15
        JR NZ,INITV1
        POP HL
        LD A,E
        CP #77
        JR NZ,M3
        INC E
M3:
        LD A,C
        AND A
        JR NZ,INITV2
        JP ROUT_A0

PhF2PT:
;Convert PT v2.4 Phantom Family to standard PT2
;No integrity checking (can deadlock)

        PUSH HL
        DEC HL
        LD B,32+16
        CALL SUBAREA
        LD C,(HL)
        INC HL
        LD B,(HL)
        PUSH BC
        LD BC,31
        ADD HL,BC
MFLP:
        LD A,(HL)
        ADD A,A
        JR C,MFOUND
        INC HL
        RRCA
        CP B
        JR C,MFLP
        LD B,A
        JR MFLP
MFOUND:
        INC B
        LD A,B
        ADD A,A
        ADD A,B
        LD HL,(MODADDR+1)
        POP BC
        ADD HL,BC
        LD B,A
        CALL SUBAREA
        POP HL
        RET

SUBAREA:
        LD A,(HL)
        SUB E
        LD (HL),A
        INC HL
        LD A,(HL)
        SBC A,D
        LD (HL),A
        INC HL
        DJNZ SUBAREA
        RET

PD_SAM:
        ADD A,A
        LD E,A
        LD D,0
SamPtrs:
        LD HL,#2121
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
MODADDR:
        LD HL,MdlAddr
        ADD HL,DE
        LD (IX+SamPtr),L
        LD (IX+SamPtr+1),H
        JR PD_LOOP

PD_EOff:
        LD (IX+Env_En),A
        JR PD_LOOP

PD_ENV:
        LD (IX+Env_En),16
        LD (AYREGS+EnvTp),A
        LD A,(BC)
        INC BC
        LD L,A
        LD A,(BC)
        INC BC
        LD H,A
        LD (AYREGS+Env),HL
        JR PD_LOOP

PD_ORN:
        ADD A,A
        LD E,A
        LD D,0
OrnPtrs:
        LD HL,#2121
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD HL,MdlAddr
        ADD HL,DE
        LD (IX+OrnPtr),L
        LD (IX+OrnPtr+1),H
        JR PD_LOOP

PD_SKIP:
        INC A
        LD (IX+Skip),A
        JR PD_LOOP

PD_VOL:
        LD (IX+Volume),A
        JR PD_LOOP

PD_DEL:
        LD A,(BC)
        INC BC
        LD (PL1D+1),A
        JR PD_LOOP

PD_GLIS:
        SET 2,(IX+Flags)
        SET 1,(IX+Flags)
        LD A,(BC)
        INC BC
        LD (IX+TSlStp),A
        ADD A,A
        SBC A,A
        LD (IX+TSlStp+1),A
        SCF
        JR PD_LP2

PTDECOD:
        AND A

PD_LP2:
        EX AF,AF''

PD_LOOP:
        LD A,(BC)
        INC BC
        ADD A,#20
        JR Z,PD_REL
        JR C,PD_SAM
        ADD A,96
        JR C,PD_NOTE
        INC A
        JR Z,PD_EOff
        ADD A,15
        JP Z,PD_QUIT
        JR C,PD_ENV
        ADD A,#10
        JR C,PD_ORN
        ADD A,#40
        JR C,PD_SKIP
        ADD A,#10
        JR C,PD_VOL
        INC A
        JR Z,PD_DEL
        INC A
        JR Z,PD_GLIS
        INC A
        JR Z,PD_PORT
        INC A
        JR Z,PD_STOP
        LD A,(BC)
        INC BC
        LD (IX+AddToN),A
        JR PD_LOOP

PD_PORT:
        RES 2,(IX+Flags)
        SET 1,(IX+Flags)
        LD A,(BC)
        INC BC
        INC BC ;ignoring precalc delta to right sound
        INC BC
        SCF
        JR PD_LP2

PD_STOP:
        RES 1,(IX+Flags)
        JR PD_LOOP

PD_REL:
        LD (IX+Flags),A
        JR PD_EXIT

PD_NOTE:
        LD L,A
        SET 0,(IX+Flags)
        EX AF,AF''
        JR NC,NOGLISS
        BIT 2,(IX+Flags)
        JR NZ,NOPORT
        LD (IX+SlToNt),L

        PUSH BC
        LD DE,NT_
        SLA L
        LD H,0
        ADD HL,DE
        LD C,(HL)
        INC HL
        LD B,(HL)
        LD L,(IX+Note)
        SLA L
        LD H,0
        ADD HL,DE
        LD E,(HL)
        INC HL
        LD D,(HL)
        LD L,C
        LD H,B
        SBC HL,DE
        LD (IX+TnDelt),L
        LD (IX+TnDelt+1),H
        JP P,DELTP
        AND A
        JP M,SET_STP
        JR NEG_STP
DELTP:
        AND A
        JP P,SET_STP
NEG_STP:
        NEG
SET_STP:
        LD (IX+TSlStp),A
        ADD A,A
        SBC A,A
        LD (IX+TSlStp+1),A
        POP BC
        JR PD_EX1

NOGLISS:
        RES 1,(IX+Flags)
NOPORT:
        LD (IX+Note),L

PD_EX1:
        XOR A

PD_EXIT:
        LD (IX+PsInSm),A
        LD (IX+PsInOr),A
        LD (IX+CrTnSl),A
        LD (IX+CrTnSl+1),A
PD_QUIT:
        LD A,(IX+Skip)
        LD (IX+SkpCnt),A
        RET

CHREGS:
        XOR A
        LD (Ampl),A
        PUSH HL
        BIT 0,(IX+Flags)
        JP Z,CH_EXIT
        LD (CSP_+1),SP
        LD L,(IX+OrnPtr)
        LD H,(IX+OrnPtr+1)
        LD SP,HL
        POP DE
        LD H,A
        LD A,(IX+PsInOr)
        LD L,A
        ADD HL,SP
        INC A
        CP E
        JR C,CH_ORPS
        LD A,D
CH_ORPS:
        LD (IX+PsInOr),A
        LD A,(IX+Note)
        ADD A,(HL)
        JP P,CH_NTP
        XOR A
CH_NTP:
        CP 96
        JR C,CH_NOK
        LD A,95
CH_NOK:
        ADD A,A
        EX AF,AF''
        LD L,(IX+SamPtr)
        LD H,(IX+SamPtr+1)
        LD SP,HL
        POP DE
        LD H,0
        LD A,(IX+PsInSm)
        LD B,A
        ADD A,A
        ADD A,B
        LD L,A
        ADD HL,SP
        LD SP,HL
        LD A,B
        INC A
        CP E
        JR C,CH_SMPS
        LD A,D
CH_SMPS:
        LD (IX+PsInSm),A
        POP BC
        POP DE
        LD D,B
        LD L,(IX+CrTnSl)
        LD H,(IX+CrTnSl+1)
        BIT 2,C
        JR Z,TSUB
        ADD HL,DE
        ADD HL,DE
TSUB:
        EX AF,AF''
        SBC HL,DE
        EX DE,HL
        LD L,A
        LD H,0
        LD SP,NT_
        ADD HL,SP
        LD SP,HL
        POP HL
        ADD HL,DE
CSP_:
        LD SP,#3131
        EX (SP),HL

        BIT 1,(IX+Flags)
        JR Z,CH_AMP
        LD L,(IX+CrTnSl)
        LD H,(IX+CrTnSl+1)
        LD E,(IX+TSlStp)
        LD D,(IX+TSlStp+1)
        ADD HL,DE
        LD (IX+CrTnSl),L
        LD (IX+CrTnSl+1),H
        BIT 2,(IX+Flags)
        JR NZ,CH_AMP
        LD E,(IX+TnDelt)
        LD D,(IX+TnDelt+1)
        LD A,(IX+TSlStp+1)
        AND A
        JR Z,CH_STPP
        EX DE,HL
CH_STPP:
        SBC HL,DE
        JP M,CH_AMP
        LD A,(IX+SlToNt)
        LD (IX+Note),A
        XOR A
        RES 1,(IX+Flags)
        LD (IX+CrTnSl),A
        LD (IX+CrTnSl+1),A

CH_AMP:
        LD A,B
        AND #F0
        OR (IX+Volume)
        RRCA
        RRCA
        RRCA
        RRCA
        LD L,A
        LD H,0
        LD DE,VT_
        ADD HL,DE
        LD A,(HL)
        OR (IX+Env_En)
        LD (Ampl),A
        RRC C
        SBC A,A
        AND #40
        JR NZ,NONS
        LD A,C
        RRCA
        RRCA
        ADD A,(IX+AddToN)
        LD (AYREGS+Noise),A
        XOR A
NONS:
        RRC C
        JR NC,CH_EXIT
        OR 8

CH_EXIT:
        LD HL,AYREGS+Mixer
        OR (HL)
        RRCA
        LD (HL),A
        POP HL
        RET

PLAY:
        XOR A
        LD (AYREGS+Mixer),A
        DEC A
        LD (AYREGS+EnvTp),A
        LD HL,DelyCnt
        DEC (HL)
        JR NZ,PL2
        LD HL,ChanA+SkpCnt
        DEC (HL)
        JR NZ,PL1B
AdInPtA:
        LD BC,#0101
        LD A,(BC)
        AND A
        JR NZ,PL1A
        LD D,A
CrPsPtr
        LD HL,0
        INC HL
        LD A,(HL)
        ADD A,A
        JR NC,PLNLP
LPosPtr:
        LD HL,#2121
        LD A,(HL)
        ADD A,A
PLNLP:
        LD (CrPsPtr+1),HL
        ADD A,(HL)
        ADD A,A
        LD E,A
        RL D
PatsPtr:
        LD HL,#2121
        ADD HL,DE
        LD DE,(MODADDR+1)
        LD (PSP_+1),SP
        LD SP,HL
        POP HL
        ADD HL,DE
        LD B,H
        LD C,L
        POP HL
        ADD HL,DE
        LD (AdInPtB+1),HL
        POP HL
        ADD HL,DE
        LD (AdInPtC+1),HL
PSP_:
        LD SP,#3131
PL1A:
        LD IX,ChanA
        CALL PTDECOD
        LD (AdInPtA+1),BC

PL1B:
        LD HL,ChanB+SkpCnt
        DEC (HL)
        JR NZ,PL1C
        LD IX,ChanB
AdInPtB:
        LD BC,#0101
        CALL PTDECOD
        LD (AdInPtB+1),BC

PL1C:
        LD HL,ChanC+SkpCnt
        DEC (HL)
        JR NZ,PL1D
        LD IX,ChanC
AdInPtC:
        LD BC,#0101
        CALL PTDECOD
        LD (AdInPtC+1),BC

PL1D:
        LD A,#3E
        LD (DelyCnt),A

PL2:
        LD IX,ChanA
        LD HL,(AYREGS+TonA)
        CALL CHREGS
        LD (AYREGS+TonA),HL
        LD A,(Ampl)
        LD (AYREGS+AmplA),A
        LD IX,ChanB
        LD HL,(AYREGS+TonB)
        CALL CHREGS
        LD (AYREGS+TonB),HL
        LD A,(Ampl)
        LD (AYREGS+AmplB),A
        LD IX,ChanC
        LD HL,(AYREGS+TonC)
        CALL CHREGS
        LD (AYREGS+TonC),HL
        XOR     A
ROUT_A0:
        LD      DE,#0DF4
        LD      HL,AYREGS
Rout1:
        LD      B,E
        OUT     (C),A
        LD      BC,#F6C0
        OUT     (C),C
        DB      #ED,#71     ; OUT   (C),0
        DEC     B
        OUTI
        LD      BC,#F680
        OUT     (C),C
        DB      #ED,#71     ; OUT   (C),0
        INC     A
        CP      D
        JR      NZ,Rout1
        LD      B,E
        OUT     (C),A
        LD      A,(HL)
        AND     A
        RET     M
        LD      BC,#F6C0
        OUT     (C),C
        DB      #ED,#71     ; OUT   (C),0
        LD      B,E
        OUT     (C),A
        LD      BC,#F680
        OUT     (C),C
        DB      #ED,#71     ; OUT   (C),0
        RET

NTBL:

        DW      #10E0, #0FD0, #0F10, #0E10, #0D50, #0C90
        DW      #0BE0, #0B30, #0A90, #0A00, #0960, #08E0

VARS

DelyCnt DB 0

PsInSm  EQU     0
PsInOr  EQU     1
CrTnSl  EQU     2
Flags   EQU     4
TSlStp  EQU     5
SamPtr  EQU     7
OrnPtr  EQU     9
SlToNt  EQU     11
Note    EQU     12
TnDelt  EQU     13
Skip    EQU     15
SkpCnt  EQU     16
Volume  EQU     17
Env_En  EQU     18
AddToN  EQU     19

ChanA   DS      21
ChanB   DS      21
ChanC   DS      21

AYREGS  DS      14

Ampl    EQU     AYREGS+AmplC

VT_     DS      256

VAR0END EQU     VT_+16 ;zeroing area end

EMPTYORN EQU    VT_+31 ;1,0,0 sequence

NT_     DS      192

	align	256
TabAdr
	DS	512
PtMode1C1
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: demo
  SELECT id INTO tag_uuid FROM tags WHERE name = 'demo';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
