-- Migration: Import z80code projects batch 71
-- Projects 141 to 142
-- Generated: 2026-01-25T21:43:30.203624

-- Project 141: julia-fractal by optimus
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'julia-fractal',
    'Imported from z80Code. Author: optimus. Julia Effect with interactive controls',
    'public',
    false,
    false,
    '2022-12-10T16:36:38.430000'::timestamptz,
    '2022-12-10T16:39:41.969000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Port of the Julia Fractal effect from Fractoid/Osmium Path
; Press SPACE to stop the sine movement and use arrows.

org #2200

ESCAPE equ 480

FX_WIDTH equ 48
FX_HEIGHT equ 48

X_FX_POS equ 8
Y_FX_POS equ 0

TAB_LEFT_X equ FX_WIDTH
TAB_LEFT_Y equ 32

MULTAB_SHR_ADDR equ #0000
ESCTAB_ADDR equ #8000
ESCTAB_OFF_ADDR equ #A000

VRAMLINES_ADDR equ #C400
BASESINE_DATA_ADDR equ #C600


LPIX_ADDR equ #DA00

VRAM_UPDOWN_LINES_ADDR equ #D000
VRAM_UPDOWN_LINES_ALT_ADDR equ #D100
POWTAB_SHR_ADDR_ORIG equ #D200
POWTAB_SHR_ADDR equ #D300
JULIA_QUARTER_ADDR equ #D400
JULIA_QUARTER_SKIP_ADDR equ #D600

renderJuliaPixelFinal equ #D800

JULIA_QUARTER_SKIP_VALUE equ 42

PLOT_CENTER_X equ 64
PLOT_CENTER_Y equ 144
POS_RANGE equ 24

main:
	call initInterruptCode

	call init_vram
	call init_base_sine

	ld sp,#2200

	call demo_init

	loop:
		call moveTheJul
	jr loop


interruptCodeStart:
	push hl
	ld hl,(timer):inc hl:ld (timer),hl
	pop hl
	ei:ret
interruptCodeEnd:

initInterruptCode:
	di
	ld hl,interruptCodeStart
	ld bc,interruptCodeEnd-interruptCodeStart
	ld de,#38
	ldir
	ei
ret

timer:
dw 0

; a shift, hl result
getTimer:
	ld hl,(timer)
	or a:ret z
	timerShift:
		srl h:rr l
	dec a
	jr nz,timerShift
ret

moveJulia:
	ld a,2:call getTimer
	ld h,BASESINE_DATA_ADDR/256:push hl
	ld a,l:add a,64:ld l,a:ld a,(hl):sub 128:ld c,a
	pop hl:ld a,(hl):sub 128:ld e,a

	ld a,3:call getTimer:push hl:srl h:rr l
	ld h,BASESINE_DATA_ADDR/256:ld a,(hl):srl a

	add a,128:ld b,a
	pop hl:ld h,BASESINE_DATA_ADDR/256:ld a,(hl):srl a

	add a,96:ld d,a

	call mul8Ux8_16
	ld b,d:ld c,e
	ld d,h:sra d:sra d:sra d
	call mul8Ux8_16
	ld e,h:sra e:sra e:sra e
ret

keyscan:
    di
    ld hl,keymap
    ld bc,#f782:out (c),c
    ld bc,#f40e:ld e,b:out (c),c
    ld bc,#f6c0:ld d,b:out (c),c
    ld c,0:out (c),c
    ld bc,#f792:out (c),c

    ld a,#40:ld c,#4a
    keyscan_loop:
    ld b,d:out (c),a
    ld b,e:ini
    inc a:cp c
    jr c,keyscan_loop
    ld bc,#f782:out (c),c
    ei
ret


    keymap:
    ds 10,0	; 10 lines

    ;;Line 	7 	6 	5 	4 	3 	2 	1 	 0
    ;;#40 	F. 	ENTER 	F3 	F6 	F9 	CURDOWN CURRIGHT CURUP
    ;;#41 	F0 	F2 	F1 	F5 	F8 	F7 	COPY 	CURLEFT
    ;;#42 	CTRL 	\ 	SHIFT 	F4 	] 	RETURN 	[ 	CLR
    ;;#43 	. 	/ 	 : 	 ; 	P 	@ 	- 	^
    ;;#44 	, 	M 	K 	L 	I 	O 	9 	0
    ;;#45 	SPACE 	N 	J 	H 	Y 	U 	7 	8
    ;;#46 	V 	B 	F 	G 	T 	R 	5 	6
    ;;#47 	X 	C 	D 	S 	W 	E 	3 	4
    ;;#48 	Z 	CAPSLOCK 	A 	TAB 	Q 	ESC 	2 	1
    ;;#49 	DEL Unused JoyFire2 JoyFire1 JoyRight JoyLeft JoyDown JoyUp

holdedKeyAction:
db 0

positionXP:
db 0
positionYP:
db 0

inputScript:
    call keyscan
	push ix
    ld ix,keymap

    bit 0,(ix+0)		    ; check up arrow
    jr nz,no_keyaction_forward
	ld a,(positionYP):cp -POS_RANGE+2:jr z,no_keyaction_forward
		dec a:ld (positionYP),a
    no_keyaction_forward:

    bit 2,(ix+0)		    ; check down arrow
    jr nz,no_keyaction_back
	ld a,(positionYP):cp POS_RANGE-2:jr z,no_keyaction_back
		inc a:ld (positionYP),a
    no_keyaction_back:

    bit 0,(ix+1)		    ; check left arrow
    jr nz,no_keyaction_left
	ld a,(positionXP):cp -POS_RANGE+2:jr z,no_keyaction_left
		dec a:ld (positionXP),a
    no_keyaction_left:

    bit 1,(ix+0)		    ; check right arrow
    jr nz,no_keyaction_right
	ld a,(positionXP):cp POS_RANGE-2:jr z,no_keyaction_right
		inc a:ld (positionXP),a
    no_keyaction_right:

    bit 7,(ix+5)		    ; check Space
    jr nz,no_keyaction_action
	ld a,(holdedKeyAction):dec a:jr z,yes_keyaction_action
	ld a,(noAutoMove):xor 1:ld (noAutoMove),a
	ld a,1:ld (holdedKeyAction),a
	jr yes_keyaction_action
    no_keyaction_action:
	xor a:ld (holdedKeyAction),a
    yes_keyaction_action:
	pop ix
ret


moveTheJul:
		call inputScript
		ld a,(noAutoMove):or a:jr nz,noMoveJulia
			call moveJulia
			jr afterMoveJulia
		noMoveJulia:
			ld a,(positionXP):ld d,a
			ld a,(positionYP):ld e,a
		afterMoveJulia:
		call prepRenderJuliaAutoM
		call renderJulia
	noStartPart:
ret

noAutoMove:
db 0

juliaCols:
db 0,192,12,204,48,240,60,252,3,195,15

; will be copied by initJuliaGenerateAuto
renderJuliaPixelBlockStart:

	ld b,l	; but 	ld l,b (#68)in first iter (autogen later)
	ld h,d:ld a,(hl)
	dec h:ld l,c:sub (hl)
	ld l,a	; x1
	ld a,(bc)
autom_yp0:
autom_ypBase:
	add a,0
	ld c,a	; y1

	sra a:add a,e:ld h,a
	cp a,(hl)
autom_colBase:
ld a,0
	ret z
renderJuliaPixelBlockEnd:

iters:
db 10

prevXY:
dw 0

; D=xp, E=yp
plotMovement:
	push de

	ld a,(prevXY+1):ld b,a
	ld a,(prevXY):ld c,a
	ld a,2:push af:inc sp
	push bc
	call plotPixel
	pop	af
	inc	sp

	pop de
	push de

	ld a,e:add a,PLOT_CENTER_Y:ld b,a:ld (prevXY+1),a
	ld a,d:add a,PLOT_CENTER_X:ld c,a:ld (prevXY),a
	ld a,10:push af:inc sp
	push bc
	call plotPixel
	pop	af
	inc	sp

	pop de
ret

; D=xp, E=yp
prepRenderJuliaAutoM:
	call plotMovement

	ld b,d

	ld hl,POWTAB_SHR_ADDR_ORIG + 256 - 32
	ld c,2*TAB_LEFT_X
addXpLoopPos:
	ld a,(hl):add a,b:inc h:ld (hl),a:inc l:dec h
	dec c
	jr nz,addXpLoopPos

	ld hl,renderJuliaPixelFinal + autom_ypBase-renderJuliaPixelBlockStart+1
	ld bc,renderJuliaPixelBlockEnd-renderJuliaPixelBlockStart
	ld a,(iters):ld d,a
	ld a,e

autom_ypLoop:
	ld (hl),a
	add hl,bc
	dec d
	jr nz,autom_ypLoop
ret

initJuliaGenerateAuto:
	ld a,(iters)
	ld de,renderJuliaPixelFinal
	copyJuliaGenerateLoop:
		ld hl,renderJuliaPixelBlockStart
		ld bc,renderJuliaPixelBlockEnd - renderJuliaPixelBlockStart
		ldir
	dec a
	jr nz,copyJuliaGenerateLoop
	ex de,hl:ld (hl),#3e:inc hl:push hl:inc hl:ld (hl),#c9
	ld a,#68:ld (renderJuliaPixelFinal),a

	ld hl,renderJuliaPixelFinal + autom_colBase-renderJuliaPixelBlockStart+1
	ld bc,renderJuliaPixelBlockEnd-renderJuliaPixelBlockStart
	ld de,juliaCols
	ld a,(iters):ld iyl,a
autom_colGenLoop:
	ld a,(de):inc de
	ld (hl),a
	add hl,bc
	dec iyl
	jr nz,autom_colGenLoop
	ld a,(de):pop hl:ld (hl),a
ret


renderJuliaFromQuarter:

	ld ix,VRAM_UPDOWN_LINES_ADDR
	ld iy,JULIA_QUARTER_ADDR

	ld c,-FX_HEIGHT/2
	juliaFromQuarterLoopY:
		ld l,(ix):ld h,(ix+1)
		ld e,(ix+2):ld d,(ix+3)
		ld a,ixl:add a,8:ld ixl,a

		ld b,-FX_WIDTH/2
		juliaFromQuarterLoopX:

			ld a,(iy)
			ld (hl),a:ld (de),a

			cp (iy+FX_WIDTH/2+1)
			jr nz,notSame
			cp (iy+FX_WIDTH/2)
			jr nz,notSame
			cp (iy+1)
			jr nz,notSame
			test:
				set 4,h:ld (hl),a:inc l:ld (hl),a:res 4,h:ld (hl),a:inc l
				res 4,d:ld (de),a:dec e:ld (de),a:set 4,d:ld (de),a:dec e
				jr afterNotSame
			notSame:

			inc c
			ld a,b:exx:ld b,a:exx
			ld a,c:exx:ld c,a
				call renderJuliaPixelFinal
			exx
			set 4,h:ld (hl),a:res 4,d:ld (de),a

			inc b
			ld a,b:exx:ld b,a:exx
			ld a,c:exx:ld c,a
				call renderJuliaPixelFinal
			exx
			inc l:ld (hl),a:dec e:ld (de),a

			dec c
			ld a,b:exx:ld b,a:exx
			ld a,c:exx:ld c,a
				call renderJuliaPixelFinal
			exx
			res 4,h:ld (hl),a:set 4,d:ld (de),a:inc l:dec e
			dec b

			afterNotSame:
			inc iy
						
		inc b:inc b:ld a,b:cp FX_WIDTH/2
		jr nz,juliaFromQuarterLoopX
	inc c:inc c
	jr nz,juliaFromQuarterLoopY
ret


renderJuliaQuarter:
	ld hl,JULIA_QUARTER_ADDR
	ld de,JULIA_QUARTER_SKIP_ADDR

	ld c,-FX_HEIGHT/2
	juliaQuarterLoopY:

		ld b,-FX_WIDTH/2
		juliaQuarterLoopX:

			ld a,(de):inc de
			cp JULIA_QUARTER_SKIP_VALUE
			ld a,0:jr z,skipThisBlock

			ld a,b:exx:ld b,a:exx
			ld a,c:exx:ld c,a
				call renderJuliaPixelFinal
			exx

			skipThisBlock:
			ld (hl),a:inc hl

		inc b:inc b:ld a,b:cp FX_WIDTH/2
		jr nz,juliaQuarterLoopX
	inc c:inc c
	jr nz,juliaQuarterLoopY
ret

renderJulia:
	exx
		ld d,POWTAB_SHR_ADDR/256
		ld e,ESCTAB_OFF_ADDR/256
	exx

	call renderJuliaQuarter
	call renderJuliaFromQuarter
ret

initPowTab:
	ld d,POWTAB_SHR_ADDR_ORIG/256
	ld e,256-TAB_LEFT_X

	initPowTabLoop:

		ld a,e
		call pow8
		srl h:rr l
		srl h:rr l
		srl h:rr l
		srl h:rr l
		ld a,l:ld (de),a

		inc e
		ld a,e:cp TAB_LEFT_X
	jr nz,initPowTabLoop
ret

initMulShrTab:
	ld b,-TAB_LEFT_Y
	initMulTabShrLoopY:
		ld c,-TAB_LEFT_X
		initMulTabShrLoopX:

			call mul8x8_16
			srl h:rr l
			srl h:rr l
			srl h:rr l
			ld a,l:ld (bc),a

		inc c:ld a,c:cp TAB_LEFT_X
		jr nz,initMulTabShrLoopX
	inc b:ld a,b:cp TAB_LEFT_Y
	jr nz,initMulTabShrLoopY
ret

initEscTab:
	ld b,-TAB_LEFT_Y
	initEscTabLoopY:
		ld c,-TAB_LEFT_X
		initEscTabLoopX:

			ld a,c:call pow8:ex de,hl
			ld a,b:add a,a:call pow8:add hl,de

			or a	; clear carry
			ld a,128
			ld de,ESCAPE
			sbc hl,de
			jr c,noEscapePrec
				ld a,b:add a,ESCTAB_OFF_ADDR/256
			noEscapePrec:
			ld l,a

			ld a,b:add a,ESCTAB_ADDR/256 + TAB_LEFT_Y:ld d,a:ld e,c
			ld a,l:ld (de),a

		inc c:ld a,c:cp TAB_LEFT_X
		jr nz,initEscTabLoopX
	inc b:ld a,b:cp TAB_LEFT_Y
	jr nz,initEscTabLoopY
ret

blankJuliaQuarter:
	ld hl,JULIA_QUARTER_SKIP_ADDR
	ld de,FX_WIDTH/2

	exx:ld a,b:exx
	or a:jr z,afterPreLoopToBringY
	preLoopToBringY:
		add hl,de
	dec a
	jr nz,preLoopToBringY
afterPreLoopToBringY:

	ld b,0:exx:ld a,c:exx:ld c,a:add hl,bc

	exx:ld a,e:exx:ld e,a:inc e
	exx:ld a,d:exx:ld d,a:inc d
	exx:ld a,b:exx:ld b,a
	blankJuliaQuarterLoopY:
		exx:ld a,c:exx:ld c,a
		push hl
		blankJuliaQuarterLoopX:
			ld (hl),JULIA_QUARTER_SKIP_VALUE:inc hl
		inc c:ld a,c:cp e
		jr c,blankJuliaQuarterLoopX
		pop hl
		push de:ld de,FX_WIDTH/2:add hl,de:pop de
	inc b:ld a,b:cp d
	jr c,blankJuliaQuarterLoopY
ret

initJuliaQuarterSkipEdges:

	exx:ld c,0:ld e,3:ld b,0:ld d,3:exx
	call blankJuliaQuarter

	exx:ld c,FX_WIDTH/2-4:ld e,FX_WIDTH/2-1:ld b,0:ld d,3:exx
	call blankJuliaQuarter

	exx:ld c,FX_WIDTH/4-3:ld e,FX_WIDTH/4+3:ld b,0:ld d,0:exx
	call blankJuliaQuarter

	exx:ld c,0:ld e,0:ld b,0:ld d,FX_HEIGHT/2-1:exx
	call blankJuliaQuarter
ret

initVramUpDownLines:
	ld iy,VRAM_UPDOWN_LINES_ADDR

	ld c,0
	vramLinesUpDownLoop:
		ld a,c:add a,Y_FX_POS:ld h,0:ld l,a:add hl,hl:ld a,h:add a,VRAMLINES_ADDR/256:ld h,a
		ld e,(hl):inc hl:ld d,(hl):ld h,0:ld l,X_FX_POS:add hl,de
		ld (iy),l:inc iy:ld (iy),h:inc iy

		ld a,2*FX_HEIGHT-2+Y_FX_POS:sub c:ld h,0:ld l,a:add hl,hl:ld a,h:add a,VRAMLINES_ADDR/256:ld h,a
		ld e,(hl):inc hl:ld d,(hl):ld h,0:ld l,X_FX_POS+FX_WIDTH-1:add hl,de
		ld (iy),l:inc iy:ld (iy),h:inc iy
		
		inc c:inc c:ld a,c:cp FX_HEIGHT
	jr nz,vramLinesUpDownLoop
ret

init_julia_precalcs:
	call initVramUpDownLines
	call initPowTab
	call initMulShrTab
	call initEscTab
	call initJuliaQuarterSkipEdges
	call initJuliaGenerateAuto
ret

plotPixel:
	push ix
	ld ix,0
	add ix,sp
		ld h,LPIX_ADDR/256:ld a,(ix+6):and 15:ld l,a:ld b,(hl)

		ld hl,VRAMLINES_ADDR:ld d,0:ld e,(ix+5):add hl,de:add hl,de
		ld c,(ix+4):ld a,c:srl a:add a,(hl):inc hl:ld h,(hl):ld l,a

		ld a,c:and 1:jr z,noRightPix
			srl b
			ld d,170
			jr noLeftPix
		noRightPix:
			ld d,85
		noLeftPix:
			ld a,(hl):and d:or b:ld (hl),a
	pop ix
ret

drawPlotSquare:
	ld c,-POS_RANGE
	drawPlotSquareLoopY:
		ld b,-POS_RANGE
		drawPlotSquareLoopX:
		ld a,-POS_RANGE:cp c:jr z,doThatPix:cp b:jr z,doThatPix
		neg:cp c:jr z,doThatPix:cp b:jr z,doThatPix
			jr skipThatPix
		doThatPix:

		push bc
			ld a,c:add a,PLOT_CENTER_Y:ld d,a
			ld a,b:add a,PLOT_CENTER_X:ld e,a
			ld a,1:push af:inc sp
			push de
			call plotPixel
			pop	af
			inc	sp
		pop bc

	skipThatPix:
		inc b:ld a,POS_RANGE+1:cp b
		jr nz,drawPlotSquareLoopX
	inc c:ld a,POS_RANGE+1:cp c
	jr nz,drawPlotSquareLoopY
ret

demo_init:

	ld bc,#7f8c: out (c),c	; mode 0

	call init_julia_precalcs

	ld hl,palJulia:xor a:ld d,10:call palchange

	call drawPlotSquare
ret


generate_vram64:
	ld b,25
	rows25:
		ld c,8
		lines8:
			ld (hl),e:inc hl:ld (hl),d:inc hl
			ld a,d:add 8:ld d,a
		dec c
		jr nz,lines8
	ld a,d:sub 64:ld d,a
	ld a,e:add 64:jr nc,no256
	inc d
	no256:
	ld e,a
	dec b
	jr nz,rows25
ret

blackout:
	ld bc,#7f00
	nextblackout:
		out (c),c:ld a,#54:out (c),a:inc c
	ld a,c:cp 17
	jr nz,nextblackout
ret

init_vram:
	call blackout

	ld hl,#4000:ld de,#4001:ld bc,16383:ld (hl),0:ldir	; clear screen

	ld de,#4000: ld hl,VRAMLINES_ADDR: call generate_vram64

	ld hl,palJulia+4:ld a,4:ld d,12:call palchange

	call set_screen_dimensions
	call select_page_4000
ret

select_page_4000:
	ld bc,#bc0c:out (c),c
	ld bc,#bd10:out (c),c
ret

; C=reg, A=value
setMyCRTC:
	ld b,#bc:out (c),c:inc b:out (c),a
ret

set_screen_dimensions:
	ld c,1:ld a,32:call setMyCRTC
	ld c,2:ld a,42:call setMyCRTC
	ld c,6:ld a,32:call setMyCRTC
	ld c,7:ld a,33:call setMyCRTC
ret

; HL=palTab, D=inkEnd+1, A=inkStart
palchange:
	ld b,#7f
	palchangeloop:
		ld c,a
		out (c),c
		ld c,(hl):out (c),c
		inc hl
	inc a
	cp d
	jr nz,palchangeloop
ret

palJulia:
db #54,#44,#55,#58
db #5d,#4c,#4e,#4f
db #4a,#43,#4b,#54
db #54,#54,#54,#54,#54

;0,1,2,4, 5,6,15,16, 24,25,26,0, 0,0,0,22
;db #54,#44,#55,#5c
;db #58,#5d,#4c,#45
;db #4d,#56,#46,#57
;db #5e,#40,#5f,#4e
;db #47,#4f,#52,#42
;db #53,#5a,#59,#5b
;db #4a,#43,#4b


nolist

; ===== Data Precs Sines =====

init_base_sine:
	ld hl,basesine_quarter
	ld bc,BASESINE_DATA_ADDR
	ld de,BASESINE_DATA_ADDR+127
	exx
	ld bc,BASESINE_DATA_ADDR+128
	ld de,BASESINE_DATA_ADDR+255
	exx

	ld ixl,64
	loop_sine_make:
		ld a,(hl):inc hl
		;sub 129 ; we did a hack where we sub 128
			; to bring sine from 0-255 (where 128 was origin Y) to -128 to 127 space.

		ld (bc),a:inc c
		ld (de),a:dec e

		exx
		ld l,a:ld a,255:sub l
		ld (bc),a:inc c
		ld (de),a:dec e
		exx

	dec ixl
	jr nz,loop_sine_make
ret

basesine_quarter:
db 128,131,134,137,140,143,146,149,152,155,158,162,165,167,170,173
db 176,179,182,185,188,190,193,196,198,201,203,206,208,211,213,215
db 218,220,222,224,226,228,230,232,234,235,237,238,240,241,243,244
db 245,246,248,249,250,250,251,252,253,253,254,254,254,255,255,255


nolist

; Expects A as 8bit input, HL output
pow8:
	push bc
	cp a,128
	jr c,powNotNeg
		neg
	powNotNeg:
	ld hl,0
	ld b,h:ld c,a
	powMulLoop:
		add hl,bc
	dec a
	jr nz,powMulLoop
	pop bc
ret

; Expects B and C as signed 8bit input, HL signed output
mul8x8_16:
	push bc
	push de

	ld d,0
	ld a,b:cp 128
	jr c,mulNotNegB
		neg:ld b,a:inc d
	mulNotNegB:

	ld a,c:cp 128
	jr c,mulNotNegC
		neg:ld c,a:inc d
	mulNotNegC:

	ld a,b:cp c
	jr c,smallerBmul
		ld a,c
		ld c,b
	smallerBmul:

	ld hl,0
	or a:jr z,zeroMuled

	ld b,h
	mul8x8_16_Loop:
		add hl,bc
	dec a
	jr nz,mul8x8_16_Loop

	dec d
	jr nz,shouldNotNegResult
		or a
		ex de,hl
		ld hl,65536
		sbc hl,de
	shouldNotNegResult:

	zeroMuled:
	pop de
	pop bc
ret

; Expects B as unsigned 8bit and C as signed 8bit input, HL signed output
mul8Ux8_16:
	push bc
	push de

	ld d,0
	ld a,c:cp 128
	jr c,mulNotNegCU
		neg:ld c,a:inc d
	mulNotNegCU:

	ld a,b:cp c
	jr c,smallerBmulU
		ld a,c
		ld c,b
	smallerBmulU:

	ld hl,0
	or a:jr z,zeroMuledU

	ld b,h
	mul8Ux8_16_Loop:
		add hl,bc
	dec a
	jr nz,mul8Ux8_16_Loop

	dec d
	jr nz,shouldNotNegResultU
		or a
		ex de,hl
		ld hl,65536
		sbc hl,de
	shouldNotNegResultU:

	zeroMuledU:
	pop de
	pop bc
ret

org LPIX_ADDR
db #00, #80, #08, #88, #20, #A0, #28, #A8, #02, #82, #0A, #8A, #22, #A2, #2A, #AA
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: fractals
  SELECT id INTO tag_uuid FROM tags WHERE name = 'fractals';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 142: transition-r2 by gurneyh
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'transition-r2',
    'Imported from z80Code. Author: gurneyh. transition horizontale propre',
    'public',
    false,
    false,
    '2020-12-07T00:07:14.839000'::timestamptz,
    '2021-06-18T13:52:23.613000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '


macro DELAY val
              ld b, {val}
@b1 ds 60 
              djnz @b1
endm

macro WRITE_CRTC reg, val		; 14 nops
              ld bc, #bc00 + {reg}
              ld a, {val}
              out (c), c
              inc b
              out (c), a
endm

macro WAIT_VBL
              ld b,#f5 
@vsync        in a,(c) 
              rra
              jr nc, @vsync
endm


              org #1000
	      	  run #1000
     		  
              di 
              ld hl, #c9fb 
              ld (#38), hl

	
main 
	         WAIT_VBL 

              DELAY 4 * 8 ; attente de 32 lignes (4x8)

              WRITE_CRTC 7, #7F
              ; 1er écran
              WRITE_CRTC 4, 8 - 1	; ecran de 64 lignes

              ei
              halt	; 		; on a parcouru 20 lignes du premier ecran
              delay 5 * 8 + 1 ; attente 41 lignes
	          ; 1 ligne pour la transition du r2
 	          ; transition de r2 = 46 => r2 = 49
	          ; attendre hbl C0 = r2 = 46
              ; r0 <- 63 - 3
              ; attendre nouvelle ligne
	          ; r0 <= 61, r2 <= 49
	          ; hcc = 9
              ds 46 - 9 - 14        ; attente hbl (ancienne valeur de r2)
	      	  WRITE_CRTC 0, 63 - 3  ; compensation
	      	  ds 10					; attente début nouvelle ligne	
	      	  WRITE_CRTC 0, 63      ; rétablissement r0 
              WRITE_CRTC 2, 49      ; nouvelle valeur r2 
     	      WRITE_CRTC 4, 0		; VCC = 0; VLC = 0
              WRITE_CRTC 9, 0		;
	      
              ld d, 20 * 8 - 1		; 160 ecrans de 1 lignes 
loop:								; equivalent a 20 - 1
				ds 64 - 4
				dec d				
              	jr nz, loop
                ; 1 ligne pour la transition du r2
 	      	    ; transition de r2 = 49 => r2 = 46
	            ; attendre hbl C0 = r2 = 49
                ; r0 <- 63 + 3
                ; attendre nouvelle ligne
	            ; r0 <= 63, r2 <= 46
	            ; hcc = #2f
              	ds #3F - #0c - 14	; attente hbl (ancienne valeur de r2)
		        WRITE_CRTC 0, 63 + 3; compensation 
                ds 7                ; attente début nouvelle ligne  
              	WRITE_CRTC 0, 63	; rétablissement r0 
                WRITE_CRTC 2, 46	; nouvelle valeur r2 
              	; 3ème écran		  ;
              	WRITE_CRTC 4, 11 - 1
              	WRITE_CRTC 9, 7
              	WRITE_CRTC 7, 11 - 4

              	jp main 
              
              
              
 org #c000 
 repeat 8,c3   
  repeat 25,c2
   repeat 80,c1
    if (c1>3.2*c2)
     db c3 and %01010101
    else
     db #aa | c3
    endif
   rend
  rend
  ds 48,0
 rend

',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: crtc
  SELECT id INTO tag_uuid FROM tags WHERE name = 'crtc';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
