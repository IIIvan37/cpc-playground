-- Migration: Import z80code projects batch 17
-- Projects 33 to 34
-- Generated: 2026-01-25T21:43:30.185014

-- Project 33: test_interuptions by Longshot
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'test_interuptions',
    'Imported from z80Code. Author: Longshot. Test for showing how Interruption counter (R52) behaves',
    'public',
    false,
    false,
    '2022-02-11T17:22:30.428000'::timestamptz,
    '2023-01-09T20:57:16.384000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '        org #a000
        run $


;See Compendium Chapter 25.2

;Si les interruptions ne sont pas autorisees, le compteur continue a s''incrementer, mais
;l''interruption reste armee (le GATE ARRAY maintient alors son signal INT). Lorsque
;l''interruption est autorisee (via l''instruction EI du Z80A) alors :

;- Une interruption se produit apres l''instruction qui suit le EI. Un HALT
;suivant un EI dans cette circonstance sera considere comme 1 NOP.

;Cela a pour effet de decaler le moment ou la prochaine interruption pourra
;se produire.

;Ce mecanisme empeche que moins de 20 lignes separent 2 interruption


        di
        ld hl,#c9fb
        ld (#38),hl
        ei
        halt
        halt
        di
        ld bc,#7f10
        out (c),c

main
        ld b,#f5
ws
        in a,(c)
        rra
        jr nc,ws
        
        ld bc,#7F00+#59
        out (c),c
modifie:

        ld b,54+52+31   ; <<<<<<< 32 pour R52>=32
wait_1
        defs 60,0
        djnz wait_1
        ei
        nop
        
        ld bc,#7f4b
        out (c),c
        halt
        
        ld a,#4c
        out (c),a
        halt
        
        di
        ld a,#54
        out (c),a
        
        ld a,(cnt)
        inc a
        and 63
        ld (cnt),a
        add 54+52
        ld (modifie+1),a
        
        jr main
        
        
 cnt: db 0
       ',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: technical
  SELECT id INTO tag_uuid FROM tags WHERE name = 'technical';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 34: _line-x1,y1,x2,y2 by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    '_line-x1,y1,x2,y2',
    'Imported from z80Code. Author: tronic. draw',
    'public',
    false,
    false,
    '2021-02-06T02:21:41.297000'::timestamptz,
    '2021-06-18T13:51:54.847000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Essai de tracé de lignes.
;
; _line x1,y1,x2,y2 (les x & y sont 16bits et donc dans l''intervalle [0..#ffff] = ça laisse de la marge pour une config écran large, exotique...)
; fonctionne dans les 8 octants (càd dans tous les sens \o/)
; L''origine (0,0) est en #c000 (en haut à gauche) mais elle pourrait-être ailleurs & notemment en bas à gauche ou ailleurs en ram (voir y_table, basée sur BC26 à transposer en BC29 ou ailleurs qu''en #c000)
; Dans ce cadre, nous sommes en mode 1 (x1,x2=[0..319] et y1,y2=[0..199])=ok fait
; pen0 (efface...)=pas fait
; pen1=ok
; pen2=pas fait
; pen3=pas fait
; Une version mode 1 full screen (384x272) serait intéressante (à changer plot routine : "ld l,y1"+ytables+cheat_table...)
; "FastPlot" mode 1 / Pen x routine (allumage de bits) min=21nop le plot
; Certainement des optimisations en pagaille encore à trouver/faire mais fait le job en l''état...
; Sympa? Utile? Pour par avance, précalculer/afficher des "motifs, dessins, objets", par la suite animés (delta? flipping? moiré?)... ou pas animés (gfx procédural?)...

; ALGO sélectionné dans ce cas (y en a d''autres...): http://rosettacode.org/wiki/Bitmap/Bresenham%27s_line_algorithm#BASIC
;1500 REM === DRAW a LINE. Ported from C version
;1510 REM Inputs are X1, Y1, X2, Y2: Destroys value of X1, Y1
;1520 DX = ABS(X2 - X1):SX = -1:IF X1 < X2 THEN SX = 1
;1530 DY = ABS(Y2 - Y1):SY = -1:IF Y1 < Y2 THEN SY = 1
;1540 ER = -DY:IF DX > DY THEN ER = DX
;1550 ER = INT(ER / 2)
;1560 PLOT X1,Y1:REM This command may differ depending ON BASIC dialect
;1570 IF X1 = X2 AND Y1 = Y2 THEN RETURN
;1580 E2 = ER
;1590 IF E2 > -DX THEN ER = ER - DY:X1 = X1 + SX
;1600 IF E2 < DY THEN ER = ER + DX:Y1 = Y1 + SY
;1610 GOTO 1560

; Version (excellente!) et "quasi-identique" de FGBRAIN sur cpcwiki (a beaucoup aidé à comprendre et débugguer celle-ci !) :
; http://www.cpcwiki.eu/forum/programming/fast-line-draw-in-assembly-(breseham-algorithm)/
; Sauf que lui : mode 0, 160x200, "slow-plot-masking", limitation [0-255] sur x1=x1+sx & y1=y1+sy avec inc (hl) et dec (hl)

; J''aime bien cet algo aussi (fait, opérationnel et testé) mais il ne gère hélas pas tous les octants et donc il faut adapter/ré-écrire le truc... Casse-couille ^^ :
; https://www.youtube.com/watch?v=RGB-wlatStc
;
; x=x1
; y=y1
; dx=x2-x1
; dy=y2-y1
; p=(2*dy)-dx
; while(x<=x2) do begin
;	putpixel(x,y)
;	x++
;	if (p<0) then begin
;		p=p+(2*dy)
;   end
;	else begin
;		p=p+(2*dy)-(2*dx)
;		y++
;   end;
; end;

; Tchin ! ;)
; Tronic/GPA




BUILDSNA
BANKSET 0
SNASET CPC_TYPE,2

macro _brk
    db #ed, #ff
mend

macro _line x1,y1,x2,y2
    ld hl,{y2}
    ld (backup_y2+1),hl
    ld de,{y1}
    ld (backup_y1+1),de
    exx
    ld hl,{x2}
    ld (backup_x2+1),hl
    ld de,{x1}
    ld (backup_x1+1),de
    ld iy,@backline
    jp draw
@backline
mend

org #40
run $

start
    di
    ld hl,#c9fb
    ld (#38),hl
    ei

    ld bc,#7f10
    out (c),c
    ld a,#54
    out (c),a

mainloop
    ld b,#f5
sync
    in a,(c)
    rra
    jp nc,sync

    di
    ld (stack+1),sp

	; 8 octants
    _line 0,0,160,100
    _line 319,199,160,100
    _line 0,199,160,100
    _line 319,0,160,100

    _line 0,0,319,0
    _line 319,0,319,199
    _line 319,199,0,199
    _line 0,199,0,0


	; triangle simple
	; point A=(10,10)
	; point B=(20,20)
	; point C=(5,30)
	; A->B
	_line 10,10,20,20
	; B->C
	_line 20,20,5,30
	; C->A
	_line 5,30,10,10
	; Une macro serait bien, à faire à l''occasion...

	; triangle rectangle plein
	pas1=0
	repeat 50
	_line 5,120+pas1,110,120
	pas1=pas1+1
	rend

	; rectangle plein
	pas=0
	repeat 50
	_line 5,50+pas,70,50+pas
	pas=pas+1
	rend

	; cercle
	i=0
	repeat 360
	_line 160+40*cos(i),100+40*sin(i),160+40*cos(i),100+40*sin(i)
	i=i+1
	rend

	; cercle plein
	i=0
	repeat 360
	_line 160,100,160+10*cos(i),100+10*sin(i)
	i=i+1
	rend
    
    
    ; forme...
	i=0
	repeat 90
	_line 160+40*cos(i),100+40*sin(i),160+10*cos(i),100+70*sin(i)
	i=i+4
	rend


    ; forme...
	i=0
	repeat 360
	_line 140+80*cos(i),100+50*sin(i),180+80*cos(i),100+50*sin(i)
	i=i+1
	rend 


	; etc...

    ld sp,(stack+1)
    ei

    jp mainloop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1520 DX = ABS(X2 - X1):SX = -1:IF X1 < X2 THEN SX = 1

    or a
	sbc hl,de
	ld b,1
	jr nc,no_abs_hl_dx

abs_hl_dx
	xor a
	sub l
	ld l,a
	sbc a,a
	sub h
	ld h,a

	ld b,-1

no_abs_hl_dx
	ld sp,hl
	ld a,b	
	ld (backup_sx+1),a

	exx

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1530 DY = ABS(Y2 - Y1):SY = -1:IF Y1 < Y2 THEN SY = 1

	or a
	sbc hl,de

	ld b,1
	jr nc,no_abs_hl_dy

abs_hl_dy
	xor a
	sub l
	ld l,a
	sbc a,a
	sub h
	ld h,a

	ld b,-1

no_abs_hl_dy
	ld (backup_dy+1),hl
	ld a,b	
	ld (backup_sy+1),a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1540 ER = -DY:IF DX > DY THEN ER = DX
;1550 ER = INT(ER / 2)

	ld b,h
	ld c,l

	or a
	sbc hl,sp
	jr nc,else_er_neg_dy_div2

then_er_dx_div2
	exx
	srl h
	rr l
	ld (backup_er+1),hl
	exx
	jr plotx1y1

else_er_neg_dy_div2
	ld a,b
	cpl
	ld b,a
	ld a,c
	cpl
	ld c,a
	inc bc	
	srl b
	rr c
	set 7,b	; rhaaa !
	ld (backup_er+1),bc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1560 PLOT X1,Y1:REM This command may differ depending ON BASIC dialect

plotx1y1
	ld hl,(backup_x1+1)     ; hl=x1
	add hl,hl
    add hl,hl
    add hl,hl               ; x8
    ld bc,cheat_table_pen1  ; setbit_table for pen1
    add hl,bc               ; +cheat_table_penX
    ex de,hl                ; de=(x1*8)+cheat_table_penX
    
	ld hl,(backup_y1+1)     ; l=y1 (h=osef dans ce cadre de plot 320x200...)
    
    ld ix,backplot             

	ld h,hi(y_table)        ; y range =[0-255] in this case, aligned table, l=y1=byte...
                            ; normal screen = 200 lines so 255 is enough...
    ld b,(hl)			    ; but could be adapted in case of fullscreen > 200 lines...
    inc h               
    ld c,(hl)           
    ex de,hl			
    jp (hl)
backplot

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1570 IF X1 = X2 AND Y1 = Y2 THEN RETURN

backup_x1
	ld hl,0

backup_x2	
	ld de,0
	or a
	sbc hl,de
	jr nz,continue

backup_y1	
	ld hl,0

backup_y2	
	ld de,0
	or a
	sbc hl,de
	jr z,line_finished
continue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1580 E2 = ER

backup_er
	ld hl,0
	ld b,h
	ld c,l

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1590 IF E2 > -DX THEN ER = ER - DY:X1 = X1 + SX

    adc hl,sp
	jp m,else1

then1
	ld h,b
	ld l,c

backup_dy
	ld de,0
	or a
	sbc hl,de
	ld (backup_er+1),hl

	ld hl,(backup_x1+1)	; portion à revoir...

backup_sx		
	ld a,0		; sx variant. 1 ou -1.
	cp 1
	jr z,incx1

decx1
	dec hl		; au lieu de dec(hl) version cpcwiki...
	jr next1

incx1
	inc hl		; au lieu de inc(hl) version cpcwiki...

next1
	ld (backup_x1+1),hl	; portion à revoir...

else1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1600 IF E2 < DY THEN ER = ER + DX:Y1 = Y1 + SY

	ld h,b
	ld l,c
	or a
	sbc hl,de
    jp p,else2

then2	
	ld hl,(backup_er+1)
	add hl,sp
	ld (backup_er+1),hl

	ld hl,(backup_y1+1)	; portion à revoir...

backup_sy
	ld a,0		; sy variant. 1 ou -1.
	cp 1
	jr z,incy1

decy1
	dec hl		; au lieu de dec(hl) version cpcwiki...
	jr next2

incy1
	inc hl		; au lieu de inc(hl) version cpcwiki...

next2
	ld (backup_y1+1),hl	; portion à revoir...

else2
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;1610 GOTO 1560
	jr plotx1y1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
line_finished
	jp (iy)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 256
cheat_table_pen1
xval=0
repeat 80					; 80*8/2=320
    ld hl,#0000+xval
    add hl,bc
    set 7,(hl)				; mode1, pen1
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 6,(hl)				; mode1, pen1
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 5,(hl)				; mode1, pen1
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 4,(hl)				; mode1, pen1
    jp (ix)
    xval=xval+1
rend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;((ligne div $8)*$50+((ligne mod $8)*$800));
align 256
y_table
adr=#c000					
ligne=0
repeat 200
db hi(adr)
ligne=ligne+1
bc26=floor(ligne/8)*#50+((ligne mod #8)*#800)
adr=#c000+bc26
rend

align 256
adr=#c000
ligne=0
repeat 200
db lo(adr)
ligne=ligne+1
bc26=floor(ligne/8)*#50+((ligne mod #8)*#800)
adr=#c000+bc26
rend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stack
    dw 0
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: still-not-in-pdro
  SELECT id INTO tag_uuid FROM tags WHERE name = 'still-not-in-pdro';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
