-- Migration: Import z80code projects batch 48
-- Projects 95 to 96
-- Generated: 2026-01-25T21:43:30.197109

-- Project 95: saboteur2 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'saboteur2',
    'Imported from z80Code. Author: siko. Saboteur 2 - Disassembled',
    'public',
    false,
    false,
    '2020-05-24T13:56:34.217000'::timestamptz,
    '2021-08-13T19:14:22.335000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Disassembled version of saboteur2
; with Disark & z80-smart-disassembler

; TURBO VERSION : patchs by SIKO
OPTIM_ALIGN_BUFFERS EQU 1 ; Add 32 bytes  between every buffers for using Stack fast fill. requires  all code to be disassembled - doesn''t currently work
OPTIM_FAST_BUFFERS EQU 2 ; Faster buffer index increment
OPTIM_STACK_FILL EQU 4 ; Using Stack for clearing buffers
OPTIM_FAST_INT38 EQU 8 ; Less Push/Pop in Int
OPTIM_LDIR_INSTEAD_LOOP EQU 16 ; use LDIR/LDI instead loop
OPTIM_LD_INSTEAD_PUSHPOP EQU 32 ; Ld De,hL instead of Push hl:pop de
OPTIM_INC_8_INSTEAD_INC16 EQU 64 ; Ld De,hL instead of Push hl:pop de
OPTIM_USE_IY_HUD EQU 128 ;  use IY instead od DE, uses less stack...
OPTIM_USE_IY_INSTEAD_IX EQU 256 ; use IY instead of IX, less stack
OPTIM_MINOR EQU 512 ; use IY instead of IX, less stack

TURBO_MODE EQU OPTIM_FAST_INT38 | OPTIM_USE_IY_INSTEAD_IX  |  OPTIM_INC_8_INSTEAD_INC16 | OPTIM_LD_INSTEAD_PUSHPOP |  OPTIM_LDIR_INSTEAD_LOOP | OPTIM_FAST_BUFFERS | OPTIM_STACK_FILL | OPTIM_MINOR ;| OPTIM_ALIGN_BUFFERS ;| OPTIM_USE_IY_HUD

; Bug du dernier caractere en bas


DEBUG_INT38 EQU 0

; TODO:
; Déplacer les buffers
; Mais pour ca il faut d''abord désassembler toutes les routines qui dessinent le décor
; Car elle tapent directement dans certains buffers

run prestart

BUILDSNA v2
BANKSET 0

SCREEN equ #c000
BUFSIZE equ #240

if (TURBO_MODE & OPTIM_ALIGN_BUFFERS) == OPTIM_ALIGN_BUFFERS
    buf_mask equ #0400-#A0 ; Mask Buffer (01=redraw) - updated every frame
    buf_bg   equ #0640-#80 ; Background buffer
    buf_fg   equ #0880-#60 ; Foreground buffer
    buf_spr1 equ #0AC0-#40 ; Character Sprite buffer
    buf_spr2 equ #0D00-#20 ; enemy1 Sprite buffer
    buf_spr3 equ #0F40 ; enemy2 Sprite buffer
else
    buf_mask equ #0400 ; Mask Buffer (01=redraw) - updated every frame
    buf_bg   equ #0640 ; Background buffer
    buf_fg   equ #0880 ; Foreground buffer
    buf_spr1 equ #0AC0 ; Character Sprite buffer
    buf_spr2 equ #0D00 ; enemy1 Sprite buffer
    buf_spr3 equ #0F40 ; enemy2 Sprite buffer
endif

if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
    ptr0880 equ bufptr0880+1
    ptr0AC0 equ bufptr0ac0+1
    ptr0D00 equ bufptr0d00+1
    ptr0f40 equ bufptr0f40+1
else
    ptr0880 equ data43ef
    ptr0AC0 equ data43ef+2
    ptr0D00 equ data43ef+4
    ptr0f40 equ data43ef+6
endif

// Pour remplacer les addresses en dur
dbuf_mask equ buf_mask-#400
dbuf_bg   equ buf_bg-#640
dbuf_fg   equ buf_fg-#880
dbuf_spr1 equ buf_spr1-#Ac0
dbuf_spr2 equ buf_spr2-#d00
dbuf_spr3 equ buf_spr3-#f40

/*
macro bufoffset adr
    if {adr}<#0640
        dw {adr}-#400+buf_mask
    else
        if {adr}<#0880
            dw {adr}-#640+buf_bg
        else
            if {adr}<#0ac0
                dw {adr}-#880+buf_fg
            else
                if {adr}<#d00
                    dw {adr}-#ac0+buf_spr1
                else
                    if {adr}<#f40
                        dw {adr}-#d00+buf_spr2
                    else
                        dw {adr}-#f40+buf_spr3
                    endif
                endif
            endif
        endif
    endif
mend
*/

buf0400 equ buf_mask ; Mask Buffer (01=redraw) - updated every frame
buf0640 equ buf_bg   ; Background buffer
buf0880 equ buf_fg   ; Foreground buffer
buf0ac0 equ buf_spr1 ; Character Sprite buffer
buf0d00 equ buf_spr2 ; enemy1 Sprite buffer
buf0f40 equ buf_spr3 ; enemy2 Sprite buffer


LAB39f5 equ #39f5
LAB3e48 equ #3e48

;datas
lab4DB8 equ #4DB8

lab4E87 equ #4E87
LAB4EDA equ #4EDA
LAB4eaf equ #4Eaf

LAB4F04 equ #4f04
LAB4F13 equ #4f13
LAB4FA0 equ #4fa0
LAB4f1c equ #4f1c
LAB4f2e equ #4f2e
lab4F76 equ #4F76
LAB4FCA equ #4FCA

LAB509c equ #509c
lab514E equ #514E
LAB5146 equ #5146
LAB5148 equ #5148
LAB514D equ #514D

LAB58fd equ #58fd
lab590A equ #590A
LAB5918 equ #5918

LAB6386 equ #6386
LAB638d equ #638d
LAB63BD equ #63BD
lab8029 equ #8029
lab80BA equ #80BA
lab810d equ #810d
lab8137 equ #8137
LAB8aac equ #8aac

lab9298 equ #9298
LAB93ea equ #93ea
lab96E5 equ #96E5
lab969F equ #969F
LAB9799 equ #9799

labC02A equ #c02a
labC144 equ #c144
labC1C4 equ #c1c4
labC1EF equ #c1ef
labC244 equ #c244
labC350 equ #c350
labC38C equ #c38c
labC480 equ #c480
labC54A equ #c54a
labC8B6 equ #C8b6



labFB80 equ #FB80
labFDC0 equ #FDC0 ; -#240

org #40

prestart:
 di

 ld a,#c3
 ld (#38),a
 ld hl,int_manager
 ld (#39),hl

 ld hl,crtc_data
 ld b,#bc
.lp:
 ld a,(hl)
 or a
 jr z,start
 out (c),a
 inc b
 inc hl
 ld a,(hl)
 out (c),a
 dec b
 inc hl
 jr .lp

start:
   ld bc,#7f10
   out (c),c
   ld c,#54
   out (c),c

   ld b,#F5
.waitnovbl:
    in a,(c)
    rra
    jr c,.waitnovbl
.waitvbl:
    in a,(c)
    rra
    jr nc,.waitvbl
  ei

   ; ld a,#11
   ; ld (Room_X),a
   ; ld a,#4
   ; ld (Room_Y),a
;drawallscreens:
  ;call lab19CC ;lab2A07
  ;ld a,(Room_Y)
  ;inc a
  ;ld (Room_Y),a
  ;jp drawallscreens

  call draw_ninja
  jp lab906F

fast_clear_buf:
 ; Arreter les ITs pose probleme pour les rasters et pour les compteurs qui se synchronisent sur la VBL
 ; Ne pas les arreter necessite de mettre une marge dans les buffers, laisser quelques octets AVANT
 ; Ou arreter les ITs sur un temps assez court
 ; Ex: avant lab0AC0 et avant #400
 ;di

 ;ld bc,#7f10
 ;out (c),c
 ;ld c,#41
 ;out (c),c

 ld de,#ffff
 ld b,#9
 ld (.restore_sp+1),sp

	ld sp,buf_spr1+BUFSIZE
.lp
repeat 32
    push de
rend
    djnz .lp

    ld sp,buf_mask+BUFSIZE ; clear mask buffer
    ld de,0
    ld b,#9
.lp2
repeat 32
    push de
rend
    djnz .lp2

.restore_sp:
	ld sp,0
    ret

crtc_data:
	db #01,#20,#02,#2a,#05,#03,#06,#18,#07,#1f,#00




; Clear screen, avoiding data afer #c600-#c7ff, ...
; Previously located around #3FD0
clear_screen:
	ld hl,SCREEN
    ld de,SCREEN+1
.lp ld bc,#5FF
    ld (hl),l
    ldir
    ld bc,#201
    ex de,hl
    add hl,bc
    ex de,hl
    add hl,bc
    jr nc,.lp
    ret

print BUF_MASK-$,"Libres en debut de mémoire"

; Buffer , size = #240, filled with 0 or 1

; original init routine
;        di
; lab0401 ld hl,labBFFF+1
;     ld de,lab9D00
;     ld bc,lab0710
;     ldir
;     ld hl,labC800
;     ld de,labB000
;     ld bc,lab0A00
;     ldir
;     call labB000
;     ld a,#c3
;     ld (lab0038),a
;     ld hl,lab3F02
;     ld (lab0039),hl
;     ld hl,labgame_over
;     set 0,(hl)
;     im 1
;     ld sp,labBFFF
;     ld bc,labBC00
;     ld hl,data0442
; lab0435 ld a,(hl) : crtc init
;     or a
;     jr z,lab044D
;     out (c),a
;     ld a,b
;     xor 1
;     ld b,a
;     inc hl
;     jr lab0435
; crtct data
; data0442 db #1,#20,#02,#2a,#06,#18,#07,#1f,#05
; db #03,#00
; lab044D call lab0EC7
;     ld a,#1
;     call lab40D8
;     ld a,#14
;     call lab40EA
;     call lab40FE
;     ld a,(lab9C40)
;     rra
;     jr nc,lab0474
;     ld a,#1d
;     ld (lab3EE2),a
;     ld (lab3EE6),a
;     ld (lab3EEA),a
;     ld (lab3EEE),a
;     ld (data4112),a
; lab0474 ld a,(lab9C40)
;     rra
;     rra
;     jp c,lab0496
;     ld hl,lab0BC1
;     ld de,lab4000
;     ld c,#0
;     call lab1434
;     ld de,lab4800
;     call lab1434
;     ld de,lab5000
;     call lab1434
;     call lab40CB
; lab0496 call lab3FCF
;     ld c,#80
;     ld b,#0
;     ld hl,labC600
; lab04A0 ld d,#8
;     ld e,c
; lab04A3 rr e
;     rla
;     dec d
;     jr nz,lab04A3
;     ld (hl),a
;     inc hl
;     inc c
;     djnz lab04A0
;     ld a,r
;     and #7
;     jr z,lab04C4
;     ld hl,lab03C9
; lab04B7 inc h
;     dec hl
;     dec a
;     jr nz,lab04B7
;     ld de,lab94A3
;     ld bc,lab00FF
;     ldir
; lab04C4 ei
;     jp lab14BF

; Buffer; size = #240  (= 9*#40)
;lab0640  equ #640


; TODO: write FF at init
org buf_spr3
	ds BUFSIZE,#ff

org #1180
txt_press_key:
lab1180 db "PRESS ANY KEY TO CONTINUE"

db "RIN  999  STRENGTH OF MIND AND BODY   00",#00,#00,#ff,#ff
db "KYO  901     DIRECTION OF ENERGY      00",#00,#00,#ff,#fe
db "TOH  801   HARMONY WITH THE UNIVERSE  02",#02,#00,#ff,#ff
db "SHA  751  HEALING OF SELF AND OTHERS  05",#05,#00,#ee,#ff
db "KAI  701    PREMONITION OF DANGER     07",#07,#00,#ee,#ff
db "JIN  651KNOWING THE THOUGHTS OF OTHERS09",#09,#01,#ee,#ff
db "RETSU601  MASTERY OF TIME AND SPACE   11",#0b,#01,#ff,#fe
db "ZAI  551 CONTROL OF NATURES ELEMENTS  14",#0e,#01,#ff,#ff
db "ZEN  501       ENLIGHTENMENT          14",#0e,#01

lab1323 db #ee,#ff

db #99,#11,#c5,#11,#f1,#11,#1d
db #12,#49,#12,#75,#12,#a1,#12,#cd ;.I.u....
db #12,#f9,#12

lab1337 db #1
        db "MISSION   BRIEFING"
        db "LEVEL "
txt_cur_level:
        db "1"
lab1351 db "KILL ENEMY GUARDS"
        db "ESCAPE FROM BUILDING VIA TUNNELS"
        db #22,#23,"GOOD LUCK ON YOUR MISSION"
        db "PREPARE TO BEGIN"
lab13AD db "MISSION NAME"
        db #20,#27,#20
lab13BC db "COLLECT "
lab13C4 db #58
lab13C5 db #58
        db " PIECES OF PAPER TAPE"
lab13DB db "INSERT TAPE IN MISSILE CONSOLE"
lab13F9 db "DISABLE ELECTRIFIED FENCE"
lab1412 db "SMASH THROUGH FENCE ON MOTORBIKE"
lab1432 db 0,0

; Draw text
; hl=Pointer to Text
; de=Coordinates
; c= Text Length
draw_text:  ; #1434
	push de
    push hl
	; Next pos = 8*lenbgth
	ld h,0
    ld l,c
    rr d
    rr d
    rr d
    add hl,de
    rl h
    rl h
    rl h
    ; Store Next Pos
    ld (next_txt_pos),hl
    pop hl
    pop de

    push hl
    push bc
    ld h,#0
    ld a,e
    add a,a
    rl h
    ld l,a
    ld a,d
    and #18
    rrca
    rrca
    or #c0
    or h
    ld h,a
    pop bc
    pop de
    ex de,hl

lab1460
	; if <4 it''s a color
	ld a,(hl)
    cp #4
    jr nc,lab1479

	ld b,a
    xor a
    rr b
    jr nc,lab146D
    or #f
lab146D rr b
    jr nc,lab1473

    or #f0
lab1473 ld (lab14BC),a
    inc hl
    jr lab1460

lab1479 cp #60
    jr c,lab147F
    sub #20
lab147F push hl
    ld h,#0
    add a,a
    ld l,a
    add hl,hl
    add hl,hl
    push de

    ld de,font32-8*32
    add hl,de

    pop de
    push de

    ; Draw Text Char
    ld b,#8
lab148F
    push bc
    push hl
    ld l,(hl)
    ld h,#ce
    ld a,(hl)
    inc h
    ld b,(hl)
    ld hl,lab14BC
    and (hl)
    ld (de),a
    inc e
    ld a,b
    and (hl)
    ld (de),a
    dec e
    pop hl
    pop bc
    inc hl
    ld a,d
    add a,#8
    ld d,a
    djnz lab148F

    pop de
lab14AB
    ld hl,2
    add hl,de
    ex de,hl
    pop hl
    inc hl
    dec c
    jr nz,lab1460 ; next char

    ; Return with DE=next pos
    ld de,(next_txt_pos)
    ret

data14ba db #ff
        db #00
lab14BC db #ff

; Next position
next_txt_pos: dw #0

; Ancien point d''entree
	call draw_ninja
    jp lab906F


; Data for rendering, used with Index +/- 127
data14c5:
    db #3f
    db #3c,#38,#38,#31,#30,#30,#30,#23
    db #20,#20,#20,#21,#20,#20,#20,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#0f
    db #0c,#08,#08,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#1f
    db #1c,#18,#18,#11,#10,#10,#10,#03
    db #00,#00,#00,#01,#00,#00,#00,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#0f
    db #0c,#08,#08,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00
lab1545
    db #ff
    db #fc,#f8,#f8,#f1,#f0,#f0,#f0,#e3
    db #e0,#e0,#e0,#e1,#e0,#e0,#e0,#c7
    db #c4,#c0,#c0,#c1,#c0,#c0,#c0,#c3
    db #c0,#c0,#c0,#c1,#c0,#c0,#c0,#8f
    db #8c,#88,#88,#81,#80,#80,#80,#83
    db #80,#80,#80,#81,#80,#80,#80,#87
    db #84,#80,#80,#81,#80,#80,#80,#83
    db #80,#80,#80,#81,#80,#80,#80,#1f
    db #1c,#18,#18,#11,#10,#10,#10,#03
    db #00,#00,#00,#01,#00,#00,#00,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#0f
    db #0c,#08,#08,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00,#07
    db #04,#00,#00,#01,#00,#00,#00,#03
    db #00,#00,#00,#01,#00,#00,#00

; Display Mission briefing
briefing:
lab15C5
	; Black Background
	xor a
    ld e,#54
    call setInk

    call clear_screen

    ld hl,lab1337
    ld de,#4007
    ld c,#12
    call draw_text

    ; Mission number
    ld a,(cur_level)
    add a,#30
    ld (txt_cur_level),a
    ld de,#404C
    ld c,#7
    call draw_text
    ld de,#4087
    ld hl,lab13AD
    ld c,#f
    call draw_text
    ld a,(cur_level)
    add a,a
    ld l,a
    ld h,#0
    ld bc,lab1323
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld c,#5
    call draw_text

    ld de,data39C7
    ld bc,3
    ldir

    ld de,#40A1
    ld c,#1e
    call draw_text
    ld a,(hl)
    ld (lab13C4),a
    inc hl
    ld a,(hl)
    ld (lab13C5),a
    ld (lab1432),hl
    push hl
    pop ix
    ld a,(ix+1)
    ld (lab58B6),a
    or a
    jr z,lab163B
    ld hl,lab13BC
    ld de,#4800
    ld c,#1f
    call draw_text
lab163B ld a,(ix+4)
    ld (lab2096),a
    inc a
    ld a,#ff
    jr nz,lab1653
    ld hl,lab1412
    ld de,#4880
    ld c,#20
    call draw_text
    ld a,#1
lab1653 ld (lab19E1+1),a
    ld a,(ix+2)
    ld (data178f),a
    or a
    jr z,lab166A
    ld hl,lab13DB
    ld de,#4821
    ld c,#1e
    call draw_text

lab166A ld a,(ix+3)
    ld (#3130),a
    inc a
    jr z,lab167E

    ld hl,lab13F9
    ld de,#4843
    ld c,#19
    call draw_text
lab167E ld hl,lab1351
    ld de,#40E7
    ld c,#11
    call draw_text
    ld de,#4860
    ld c,#20
    call draw_text
    ld de,#40A0
    ld c,#1
    call draw_text
    inc c
    ld de,#40BF
    call draw_text
    ld de,#5003
    ld c,#19
    call draw_text
    ld de,#5048
    ld c,#10
    call draw_text

    ld hl,txt_press_key
    ld de,#50E3
    ld c,#19
    call draw_text

    call lab9346
    call lab934C

	; Game Starts
	ld hl,game_over
    res 0,(hl)

    ld b,#21
    ld de,lab279E
    ld hl,lab27A3
lab16CE
	push bc
    ld bc,5
    ldir

    ld bc,9
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl

    pop bc
    djnz lab16CE


    ; Draw HUD
    exx
    ld de,labC480
    ld h,#ce
    exx

	ld de,HUD_DATA

lab16E8 ld a,(de)
    inc de
    ld l,a
    inc a
    jp z,lab18C3 ; If #FF => exits

    ;Compute hl = lx9,  l<20
    ld h,0
    push de

	ld d,h  ; *9
    ld e,l
	add hl,hl
    add hl,hl
    add hl,hl
    add hl,de

    ld de,HUD_Tiles
    add hl,de

    pop de
    ld c,#1
    cp #11
    jr c,lab1706
    ld a,(de)
    ld c,a
    inc de
lab1706 push hl
    push de
    ld de,8
    add hl,de
    ld a,(hl)
    sbc hl,de
    pop de
    exx
    push de
    ld (data1724),a
    and #7
    jr z,lab1725
    cp #2
    jr z,lab1727
    dec a
    jr z,lab1727
    ld a,#1
    jr lab1727

data1724 db #0

lab1725 ld a,#3
lab1727 ld c,a
    xor a
    rr c
    jr nc,lab172F
    or #f
lab172F rr c
    jr nc,lab1735
    or #f0
lab1735 ld b,a
    ld a,(data1724)
    rrca
    rrca
    rrca
    and #7
    jr z,lab174B
    cp #2
    jr z,lab174D
    dec a
    jr z,lab174D
    ld a,#1
    jr lab174D
lab174B ld a,#3
lab174D ld c,a
    xor a
    rr c
    jr nc,lab1755
    or #f
lab1755 rr c
    jr nc,lab175B
    or #f0
lab175B ld c,a

if (TURBO_MODE & OPTIM_USE_IY_HUD)== OPTIM_USE_IY_HUD

    ld iy,de
    exx

; draw HUD TILE
	ld b,#8
lab175F
    ld a,(hl)
    inc hl
    exx
    ld l,a
    ld a,(hl)
    and b
    ;push de ; utiliser iy au lieu de de?
    ld e,a
    ld a,(hl)
    cpl
    and c
    or e
    ;pop de
    ;ld (de),a
    ld (iy+0),a

    inc h
    ;inc e

    ld a,(hl)
    and b
    ;push de
    ld e,a
    ld a,(hl)
    cpl
    and c
    or e
    ;pop de
    ;ld (de),a
    ld (iy+1),a

    ;dec e
    dec h
else
    exx

; draw HUD TILE
	ld b,#8
lab175F ld a,(hl)
    inc hl
    exx
    ld l,a

    ld a,(hl)
    and b
    push de ; utiliser iy au lieu de de?
    ld e,a
    ld a,(hl)
    cpl
    and c
    or e
    pop de
    ld (de),a


    inc h
    inc e

    ld a,(hl)
    and b
    push de
    ld e,a
    ld a,(hl)
    cpl
    and c
    or e
    pop de
    ld (de),a


    dec e
    dec h
endif

    ld a,d
    add a,#8
    ld d,a

    exx
    djnz lab175F


    exx
    pop de
    inc de
    inc de
lab1786
    exx
    pop hl
    dec c
    jp nz,lab1706
    jp lab16E8

assert $==#178f

data178f db #0

HUD_DATA:
    db #08, #11,#04, #0e, #11,#0e, #0e,       #11,#05,       #0e, #11,#04, #09 ; Line 1
    db #0c, #12,#04, #0c, #12,#0e, #0c, #00,#01,#01,#01,#02, #0c, #12,#04, #0c
    db #0c, #12,#04, #0c, #12,#0e, #0c, #03,  #12,#03,  #04, #0c, #12,#04, #0c
    db #0c, #12,#04, #0c, #13,#0e, #0c, #05,#06,#06,#06,#07, #0c, #12,#04, #0c
    db #0c, #12,#04, #0c, #13,#0e, #0c,       #12,#05,       #0c, #12,#04, #0c
    db #0a, #11,#04, #0f, #11,#0e, #0f,       #11,#05,       #0f, #11,#04, #0b
    db #ff ; End

;lab17E7
; 20 Tiles for the HUD (8+1 bytes=180 bytes)
HUD_tiles:
		db #00,#0f,#10,#27,#48,#50,#50,#50,#0f
		db #00,#ff,#00,#ff,#00,#00,#00,#00,#0f
		db #00,#f0,#08,#e4,#12,#0a,#0a,#0a,#0f
		db #50,#50,#50,#50,#50,#50,#50,#50,#0f
		db #0a,#0a,#0a,#0a,#0a,#0a,#0a,#0a,#0f
        db #50,#50,#50,#48,#27,#10,#0f,#00,#0f
        db #00,#00,#00,#00,#ff,#00,#ff,#00,#0f
        db #0a,#0a,#0a,#12,#e4,#08,#f0,#00,#0f
        db #00,#12,#0d,#db,#32,#29,#24,#20,#02
		db #00,#30,#40,#46,#c8,#b0,#9e,#28,#02
        db #10,#19,#f1,#33,#2f,#42,#42,#04,#02
        db #1e,#28,#98,#d8,#64,#44,#22,#20,#02
        db #10,#3e,#48,#08,#10,#7c,#12,#30,#02
        db #08,#2a,#1c,#b0,#e0,#92,#4c,#18,#02
        db #00,#22,#24,#47,#cc,#6a,#92,#10,#02
        db #10,#55,#5d,#2b,#e2,#22,#44,#00,#02
        db #10,#1e,#38,#8f,#12,#04,#78,#0c,#02

		db #00,#21,#22,#fa,#17,#12,#22,#00,#02
        db #00,#00,#00,#00,#00,#00,#00,#00,#0f
        db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#0a


lab189B db #2,"HELD","TIMER","NEAR"
lab18A9 db #1," PAY ",#24
lab18B0 db "0000000 "

lab18B8 db #58,#58,#58,#58,#58,#58,#58,#58,#58,#58,#58

assert $==#18C3
lab18C3 ld hl,(lab1432)
    inc hl
    ld a,(hl)
    or a
    jr z,lab18D2
    add a,#85
    ld l,a
    ld h,#5a
    nop
    nop
lab18D2
	; Score reset
    ld hl,lab18B0
	ld b,#6
lab18D7 ld (hl),#30
    inc hl		; INC L
    djnz lab18D7

    ld hl,lab189B
    ld de,#50C1
    ld c,#4
    call draw_text
    ld de,#50D5
    ld c,#5
    call draw_text
    ld de,#50DB
    ld c,#4
    call draw_text
    ld de,#5066
    ld c,#e
    call draw_text

    ; Full Energy
    ld a,#e
    ld (lab95C5+1),a
    ld a,#7
    ld (lab39CC),a

    ld a,#26
    ld (lab39CB),a
    ld hl,#0106
    ld (lab39CD),hl
    ld a,#11                ; Start Position X=#11
    ld (Room_X),a

    ld hl,lab5085
    ld (lab52D3),hl

    xor a
    ld (lab2B0B),a
    ld (lab52D6),a
    ld (lab52D7),a
    ld (lab21DC),a
    ld (lab39D1),a
    ld (lab4292+1),a
    ld (lab34C1),a
    ld (Room_Y),a           ; Start Position Y=0
    ld hl,lab279E
    ld (lab2968),hl
    ld hl,lab4DDE
    ld (lab39F4+1),hl
    ld hl,lab3D7F
    ld (lab2BB1+1),hl
    ld (lab3C3B),a
    ld (data39ec),a
    ld (lab42D0),a

	ld hl,room_map1           ; initial room index map
    ld (room_map_index+1),hl
    inc a
    ld (lab95D3+1),a
    ld (lab95C0+1),a
    ld (lab3495),a
    ld (lab3496),a
    ld (lab34C2),a
    ld (lab39CA),a

    ld hl,lab34CE
    ld de,12
    ld b,#65
lab1974 ld a,(hl)
    cp #5
    jr nz,lab197B
    ld (hl),#0
lab197B cp #6
    jr nz,lab1981
    ld (hl),#1
lab1981 add hl,de
    djnz lab1974

    call lab5447

lab1987
    ; Palettes
    ld a,#4c
    ld (halt_palettes+4+1),a
    ld (halt_palettes+8+1),a
    ld (halt_palettes+12+1),a
    ld a,#52
    ld (halt_palettes+4+2),a
    ld (halt_palettes+8+2),a
    ld (halt_palettes+12+2),a

    ld a,#5
    ld (lab2DE0),a
    ld a,#3
    ld (lab979A),a
    xor a
    ld (lab1CD0),a
    ld a,(lab2096)
    inc a
    jr nz,lab19CC
    ld a,(Room_Y)
    cp #13
    jr nz,lab19CC
    ld hl,lab21DC
    xor a
    cp (hl)
    jr nz,lab19CC
    ld (hl),#1

    ld de,#5066
    ld hl,lab21DD
    ld c,#e
    call draw_text

lab19CC ld b,#6
    ld hl,lab3497
    ld de,7
lab19D4 ld (hl),#0
    add hl,de
    djnz lab19D4

    ld a,(Room_X)
    dec a
    ld a,#1
    jr nz,lab19E3

lab19E1 ld a,#1
lab19E3 ld (#72E9-#72da+room_ee),a
    xor a
    ld (lab21B3),a

	; Draw new screen
    call lab4D6F
    call lab4D7D

    ; clear Buffers
    ld hl,buf_bg		; a optimiser?
    ld de,buf_bg+1
    ld bc,BUFSIZE-1
    ld (hl),#0
    ldir

    ld (hl),#ff			; a optimiser?
    ld bc,BUFSIZE-1
    ldir

    ld hl,buf_mask		; a optimiser?
    ld de,buf_mask+1
    ld bc,BUFSIZE-1
    ld (hl),#1
    ldir

; Room pointer
room_map_index: ;lab1A11
    ld hl,0                   ; Room Index Map
    ld a,(Room_Y)             ; 1st line (Y=0) => room #0
    or a
    jr z,lab1A1B
    ld a,(hl)                 ; #Room
lab1A1B
    ; Room number => data
    ld l,a
    ld h,#0
    add hl,hl                 ; x2
    ld de,room_index
    add hl,de

    ld a,(hl)                 ; get room script
    inc hl
    ld h,(hl)
    ld l,a

    ; "Buffer Script"  interpretation
lab1A27:
    ; Read Command
    ld a,(hl)
    inc a
    ; was #FF? => End of rendering
    jp z,lab2A07

    ; --- interprets command

    ; next byte
    inc hl
    push hl
    ; Command => function pointer
    ld l,a
    ld h,#0
    add hl,hl ; hl = 2.a
    ld de,render_table-2
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ; Execute command
    jp (hl)
lab1A3B
    pop hl
    inc hl
    ; Next command
    jr lab1A27

; 1a3f
assert $==#1a3f
lab1A3F
return_from_render
    jp lab1A3B ; auto modif, vaut lab1a3b ou data2a36 (return_from_render2)

; Table pour interpreter les commandes de dessin des décors
render_table:
lab1A42
    dw cmd_draw_hline               ; 0 Motif Horizontal (4 bytes)
    dw cmd_draw_vline               ; 1 Motif vertical (4 bytes)
    dw cmd_draw_rect                ; 2 Motif rectangulaire (5 bytes)
    dw cmd_fill_bg_buf              ; 3 CMD_FILL_BG : Fill BG Buffer (1 byte param)
    dw cmd_poke_byte                ; 4 CMD_POKE (3 bytes params)
    dw cmd_draw_sprite_3_4_7398     ; 5 1ebf 1 byte
    dw cmd_draw_rline               ; 6 CMD_RLINE (4 bytes)
    dw cmd_draw_lline               ; 7 CMD_LLINE (4 bytes)
    dw cmd_draw_2b_ldiag_pattern_05 ; 8 Motif #5 #6 en diagonal (3 bytes)
    dw cmd_4_3_spr_8_6              ; 9 ; remplit 4*3 fois avec des motifs 8*6
    dw lab2983                      ; a
    dw lab296b
    dw lab2970
    dw #297e
    dw cmd_draw_2b_ldiag_pattern_09 ; #0e Motif #9 #a en diagonal
    dw lab2216                      ; #0f
    dw lab1da8                      ; #10
    dw draw_spr_6_1_738c            ; #11 ; lab1f22
    dw #1e47                        ; #12
    dw cmd_draw_moon_2_2            ; #13 - Draw Moon
    dw cmd_draw_sprite_2_6_1f0a     ; #14 (2 bytes - addr)
    dw cmd_draw_sprite_2_6_1f16     ; #15 (2 bytes Addr)
    dw draw_sprite_2_3_1e77         ; #16
    dw draw_sprite_2_3_1e8B         ; #17
    dw cmd_draw_sprite_3_3_1e9f     ; #18
    dw cmd_draw_sprite_3_3_1eb6     ; #19
    dw lab21eb                      ; #1a
    dw lab21f5                      ; #1b
    dw cmd_draw_sprite_1ECD         ; #1c (2 bytes - addr)
    dw cmd_draw_sprite_3_3_1f47     ; #1d
    dw cmd_draw_2b_ldiag_pattern_25 ; #1e    #25 #26 en diagonal gauche
    dw cmd_draw_sprite_2_2_1f50     ; #1f
    dw cmd_draw_sprite_3_2_1edc     ; #20  (2 bytes - addr)
    dw cmd_draw_2b_ldiag_pattern_2c ; #21  - #2c #2d en diagonal
    dw #21b4                        ; #22
    dw #21b8                        ; #23
    dw #21bc                        ; #24
    dw lab1ff6                      ; #25
    dw cmd_draw_bureau_simple       ; #26 Bureau sans chaise 6x4
    dw #1fa4                        ; #27
    dw cmd_draw_spr_7_9_1b9e        ; #28 Sprite 7x9
    dw lab1e1a                      ; #29
    dw #1de8                        ; #2A
    dw cmd_spr_5_3_1bdd             ; #2B sprite 5x3
    dw lab1dd8                      ; #2C sprite 2x3
    dw lab1dd3                      ; #2D sprite 2x3
    dw lab1e24                      ; #2E ?
    dw lab1dc1                      ; #2F
    dw lab1d9a                      ; #30
    dw lab1d95                      ; #31
    dw lab1d88                      ; #32
    dw cmd_draw_bureau_chaise       ; #33 chaise+bureau 6x5
    dw lab1d76                      ; #34 chaise+bureau 6x5
    dw lab1dad                      ; #35 chaise+bureau 6x5
    dw lab1db2                      ; #36 chaise+bureau 6x5
    dw lab1db7                  ; #37 chaise+bureau 6x5
    dw lab1fe4                  ; #38
    dw lab1fdf                  ; #39
    dw lab1d71                  ; #3a chaise+bureau 6x5
    dw lab1d6c                  ; #3b chaise+bureau 6x5
    dw lab1da3                  ; #3c chaise+bureau 6x5
    dw lab1d67                  ; #3d chaise+bureau 6x5
    dw lab1dbc                  ; #3e chaise+bureau 6x5
    dw lab1e1f                  ; #3f sprite 7x9
    dw lab1fd4                  ; #40
    dw #1e0d                    ; #41 sprite 5x10
    dw lab1e03                  ; #42 sprite 5x10
    dw lab1e08                  ; #43 sprite 5x10
    dw #2979                    ; #44
    dw #222d                    ; #45
    dw #2031                    ; #46
    dw lab208e                  ; #47
    dw #2044                    ; #48
    dw lab2076                  ; #49 Sprite 5x1
    dw lab2068                  ; #4a Sprite 4x4
    dw lab2084                  ; #4b Sprite 5x1
    dw lab2089                  ; #4c Sprite 4x4

    dw #1fcf                  ; #4d
    dw #1fe9                  ; #4e
    dw #1fca                  ; #4f
    dw #1fc5                  ; #50
    dw #1fc0                  ; #51
    dw #1fbb                  ; #52
    dw #1fb6                  ; #53
    dw lab1d62                ; #54 chaise+bureau 6x5
    dw lab1d5d                ; #55 chaise+bureau 6x5
    dw lab1d58                ; #56 chaise+bureau 6x5
    dw lab1d53                ; #57 chaise+bureau 6x5
    dw lab1d4e                ; #58 chaise+bureau 6x5
    dw lab1d49                ; #59 chaise+bureau 6x5
    dw lab1d44                ; #5A chaise+bureau 6x5
    dw lab1d3f                ; #5B chaise+bureau 6x5
    dw lab1d3a                ; #5C chaise+bureau 6x5
    dw lab1d35                ; #5D chaise+bureau 6x5
    dw lab1d30                ; #5E chaise+bureau 6x5
    dw lab1d2b                ; #5F chaise+bureau 6x5
    dw lab1d26                ; #60 chaise+bureau 6x5
    dw #1fb1                  ; #61
    dw cmd_draw_screen3       ; #62 draw_screen 9x6
    dw cmd_draw_screen4       ; #63 draw_screen 9x6
    dw cmd_draw_screen2       ; #64 draw_screen 9x6
    dw cmd_draw_screen1       ; #65 draw_screen 9x6
    dw lab1cef                ; #66 6x6
    dw #1dce                  ; #67
    dw lab1cd3                ; #68 change palette
    dw lab1ce1                ; #69 change palette

; sprites / patterns
lab1b16
    db #2b,#2c,#2d,#2e,#2f,#30

    ; spr 5*10
spr_5_10_1b1c:
    db #ff,#ff,#ff,#31,#32
    db #ff,#ff,#ff,#33,#34
    db #35,#ff,#ff,#36,#ff
    db #37,#38,#39,#3a,#ff
    db #ff,#3b,#3c,#ff,#ff
    db #ff,#3d,#ff,#ff,#ff
    db #ff,#3e,#ff,#ff,#ff
    db #3f,#40,#ff,#ff,#ff
    db #41,#42,#ff,#ff,#ff
    db #43,#44,#ff,#ff,#ff

spr_5_8_1b4e
    db #56,#57,#58,#57,#59
    db #5a,#5c,#5b,#5c,#5d
    db #5a,#5c,#5b,#5c,#5d
    db #5a,#5e,#5f,#60,#5d
    db #5a,#5c,#5b,#5c,#5d
    db #5a,#5c,#5b,#5c,#5d
    db #5a,#5c,#5b,#5c,#5d
    db #61,#62,#62,#62,#63
spr_5_8_1B76:
    db #2e,#2f,#2f,#2f,#30
    db #31,#32,#33,#34,#35
    db #31,#36,#37,#38,#35
    db #31,#39,#39,#39,#35
    db #31,#39,#39,#3a,#35
    db #31,#39,#39,#39,#35
    db #31,#39,#39,#39,#35
    db #31,#39,#39,#39,#35
spr_7_9_1b9e:
    db #3b,#40,#44,#42,#40,#41,#3f
    db #3b,#3c,#3d,#3d,#3d,#3e,#3f
    db #3b,#43,#41,#45,#42,#44,#3f
    db #3b,#3c,#3d,#3d,#3d,#3e,#3f
    db #3b,#43,#42,#40,#45,#42,#3f
    db #3b,#3c,#3d,#3d,#3d,#3e,#3f
    db #3b,#45,#40,#44,#43,#41,#3f
    db #3b,#3c,#3d,#3d,#3d,#3e,#3f
    db #3b,#00,#00,#00,#00,#00,#3f

spr_5_3_1bdd:
    db #4c,#4c,#4c,#4c,#4c
    db #4d,#4d,#4d,#4d,#4d
    db #4e,#4e,#4e,#4e,#4e

spr_2_3_1bec:
    db #46,#47
    db #48,#49
    db #4a,#4b

spr_3_2_1bf2:
    db #65,#66,#67
    db #68,#69,#6a


;1bf8
spr_6_5_bureau_chaise
    db #00,#00,#6b,#6c,#00,#00
    db #6d,#6e,#6f,#6f,#70,#71
    db #72,#73,#74,#75,#76,#77
    db #72,#73,#78,#79,#76,#77
    db #7a,#00,#7b,#7c,#00,#7d

;1c16
spr_9_6_screen:
    db #81,#82,#82,#82,#82,#82,#82,#82,#83
    db #84,#01,#01,#01,#01,#01,#01,#01,#85
    db #84,#01,#01,#01,#01,#01,#01,#01,#85
    db #84,#01,#01,#01,#01,#01,#01,#01,#85
    db #84,#01,#01,#01,#01,#01,#01,#01,#85
    db #86,#87,#87,#87,#87,#87,#87,#87,#88

;1c4c
spr_6_6_1c4c:
    db #89,#8a,#8a,#8a,#8a,#8b
    db #8c,#a1,#a2,#a1,#a3,#8d
    db #8c,#a3,#a1,#a2,#a2,#8d
    db #8c,#a1,#a2,#a1,#a2,#8d
    db #8e,#8f,#8f,#8f,#8f,#90
    db #00,#91,#92,#93,#94,#00

; Patterns 3x4
data1c70:
    db #a1,#a1,#a1
    db #a1,#a1,#a1
    db #a1,#a1,#a1
    db #a1,#a1,#a1

    db #a2,#a2,#a2
    db #a2,#a2,#a2
    db #a2,#a2,#a2
    db #a2,#a2,#a2

    db #a3,#a3,#a3
    db #a3,#a3,#a3
    db #a3,#a3,#a3
    db #a3,#a3,#a3

    db #a1,#a2,#a3
    db #a3,#a2,#a3
    db #a1,#a3,#a1
    db #a2,#a1,#a3

data1ca0:
    db #95,#96,#97
    db #98,#99,#9a
    db #9b,#9c,#9d
    db #9e,#9f,#a0

    db #a4,#a5,#a6
    db #a7,#a8,#a9
    db #aa,#ab,#ac
    db #ad,#ae,#af

    db #b0,#b1,#b2
    db #b3,#b4,#b5
    db #b6,#b7,#b8
    db #b9,#ba,#bb

    db #bc,#bd,#01
    db #01,#be,#bf
    db #c0,#c1,#c2
    db #c3,#c4,#c5

lab1CD0 db #0
        db #00,#00 ; for ix

lab1cd3
    ld a,#b
    ld (lab3EE6+2),a
    ld (lab3EEa+2),a
    ld (lab3EEE+2),a
    jp lab1F9A
lab1ce1:
    ld a,#1e
    ld (lab3EE6+1),a
    ld (lab3EEa+1),a
    ld (lab3EEe+1),a
    jp lab1F9A

lab1cef:
    ld a,#1
    ld (lab1CD0),a
    ld hl,dbuf_bg+#6A4

    ld ix,spr_6_6_1c4c
    ld c,#6
    ld b,#6
    jr lab1D23


cmd_draw_screen1:
lab1D01
    ld hl,dbuf_bg+#671
    jr draw_screen
cmd_draw_screen2:
lab1D06
    ld hl,dbuf_bg+#663
    jr draw_screen
cmd_draw_screen3
lab1D0B
    ld hl,dbuf_bg+#668
    jr draw_screen
cmd_draw_screen4
lab1D10
    ld hl,dbuf_bg+#673
draw_screen:
lab1D13 ld a,(Room_Y)
    cp #c
    jp nc,lab1F9A
    ld ix,spr_9_6_screen
    ld c,#9
    ld b,#6
lab1D23 jp draw_sprite_c_b_ix_hl

lab1D26
    ld hl,dbuf_bg+#768
    jr draw_bureau_chaise
    ;21,#68,#07,#18,#53
lab1d2b
    ld hl,dbuf_bg+#776
    jr draw_bureau_chaise
    ;21,#76,#07,#18,#4e
lab1d30
    ld hl,dbuf_bg+#76F
    jr draw_bureau_chaise
    ;db #21,#6f,#07,#18,#49
lab1d35
    ld hl,dbuf_bg+#761
    jr draw_bureau_chaise
    ;db #21,#61,#07,#18,#44
lab1d3a
    ld hl,dbuf_bg+#78D
    jr draw_bureau_chaise
    ;db #21,#8d,#07,#18,#3f
lab1d3f:
    ld hl,dbuf_bg+#782
    jr draw_bureau_chaise
    ;db #21,#82,#07,#18,#3a
lab1d44:
    ld hl,dbuf_bg+#07D7
    jr draw_bureau_chaise
    ;db #21,#d7,#07,#18,#35
lab1d49:
    ld hl,dbuf_bg+#07CF
    jr draw_bureau_chaise
    //db #21,#cf,#07,#18,#30
lab1d4e:
    ld hl,dbuf_bg+#07C7
    jr draw_bureau_chaise
    //db #21,#c7,#07,#18,#2b
lab1d53:
    ld hl,dbuf_bg+#7B9
    jr draw_bureau_chaise
lab1d58:
    ld hl,dbuf_bg+#07B1
    jr draw_bureau_chaise
    //db #21,#b1,#07,#18,#21
lab1d5d:
    ld hl,dbuf_bg+#07a7
    jr draw_bureau_chaise
//    db #21,#a7,#07,#18,#1c
lab1d62:
    ld hl,dbuf_bg+#07A0
    jr draw_bureau_chaise
    //db #21,#a0,#07,#18,#17
lab1d67:
    ld hl,dbuf_bg+#0756
    jr draw_bureau_chaise
    //db #21,#56,#07,#18,#12
lab1d6c:
    ld hl,dbuf_bg+#074E
    jr draw_bureau_chaise
    //db #21,#4e,#07,#18,#0d
lab1d71:
    ld hl,dbuf_bg+#741
    jr draw_bureau_chaise
    //db #21,#41,#07,#18,#08
lab1d76:
    ld hl,dbuf_bg+#794
    jr draw_bureau_chaise
    //db #21,#94,#07,#18,#03

cmd_draw_bureau_chaise
lab1d7b:
   ld hl,dbuf_bg+#789
draw_bureau_chaise
;lab1D7E
    ld ix,spr_6_5_bureau_chaise
    ld c,#6
    ld b,#5
    jr lab1E00

lab1d88
    ld hl,dbuf_bg+#6D6
    ld ix,spr_3_2_1bf2
    ld c,#3
    ld b,#2
    jr lab1E00

lab1d95
    ld hl,dbuf_fg+#0A0A
    jr lab1D9D
    ;db #21,#0a,#0a,#18,#03
lab1d9a
     ld hl,dbuf_fg+#A04
lab1D9D ld ix,lab1B16
    jr lab1DEF

;    db #21,#04,#0a,#dd
;lab1d9e
 ;   db #21,#16,#1b,#18,#4c
lab1da3
    ld hl,dbuf_bg+#6E8
    jr lab1DC4
    ;db #21,#e8,#06,#18,#1c
lab1da8
    ld hl,dbuf_bg+#075A
    jr lab1DC4
    ;db #21,#5a,#07,#18,#17
lab1dad
    ld hl,dbuf_bg+#74E
    jr lab1DC4
    ;db #21,#4e,#07,#18,#12
lab1db2:
    ld hl,dbuf_bg+#0742
    jr lab1DC4
    ;db #21,#42,#07,#18,#0d
lab1db7:
    ld hl,dbuf_bg+#0734
    jr lab1DC4
    ;db #21
;lab1DB8 db #34
;    db #07,#18,#08
lab1dbc:
    ld hl,dbuf_bg+#06F5
    jr lab1DC4
lab1dc1:
    ld hl,dbuf_bg+#743

; sprite 5x8
lab1dc4:
    ld ix,spr_5_8_1b4e
    ld c,#5
    ld b,#8
    jr lab1E00

lab1DCE:
    ld hl,dbuf_bg+#07CA
    jr lab1DEB
lab1dd3
    ld hl,dbuf_bg+#07CE
    jr lab1DEB
lab1dd8
    ld hl,dbuf_bg+#07D1
    jr lab1DEB

cmd_spr_5_3_1bdd
lab1ddd
    ld hl,dbuf_bg+#7D4
    ld ix,spr_5_3_1bdd
    ld c,#5
    jr lab1DF1
lab1DE8
    ld hl,dbuf_bg+#07A9


lab1DEB ld ix,spr_2_3_1bec
lab1DEF ld c,#2
lab1DF1 ld b,#3
    jr lab1E00

lab1df5
cmd_draw_spr_7_9_1b9e
    ld hl,dbuf_bg+#072D
lab1DF8
    ld ix,spr_7_9_1b9e ;lab1B9E
    ld c,#7
    ld b,#9
lab1E00
    jp draw_sprite_c_b_ix_hl

lab1E03
    ld hl,dbuf_fg+#93A
    jr draw_spr_5_10_1b1c

lab1E08
    ld hl,dbuf_fg+#931
    jr draw_spr_5_10_1b1c

lab1E0d
    ld hl,dbuf_fg+#0925
draw_spr_5_10_1b1c:
lab1E10
    ld ix,spr_5_10_1b1c
    ld c,#5
    ld b,#a
    jr lab1E00
lab1e1a:
    ld hl,dbuf_bg+#722
    jr lab1DF8
lab1e1f:
    ld hl,dbuf_bg+#0737
    jr lab1DF8

lab1e24
    ld hl,Room_Y
    ld a,#5c
    sub (hl)
    ld (lab1E45),a
    ld b,#9
    ld de,spr_1E3E
    ld hl,dbuf_fg+#0971
    call lab43C3
    pop hl
    dec hl
    push hl
    jp lab1A3F

; Data

spr_1E3E
    db #40,#4c,#45,#56,#45,#4c,#40
lab1e45
    db #58,#40

draw_fg_tree:
draw_sprite_5_4_1e55
lab1e47:
    ld ix,spr_5_4_fg_tree
    ld c,#5
    ld b,#4
    ld hl,dbuf_fg+#933
    jp draw_sprite_c_b_ix_hl

;1e55
spr_5_4_fg_tree:
    db #0b,#0c,#0d,#0d,#0e
    db #0f,#10,#10,#10,#11
    db #0f,#10,#10,#10,#15
    db #12,#13,#14,#15,#ff

draw_sprite_2_3_1e77
lab1e69:
        ld ix,lab1E77
lab1E6D ld c,#2
lab1E6F ld b,#3
lab1E71 ld hl,dbuf_bg+#076C
        jp draw_sprite_c_b_ix_hl

lab1E77 db #f8,#f8
        db #f8,#d1
        db #d1,#00

draw_sprite_2_3_1e8B
lab1E7D
    ld ix,spr1E8B
    ld c,#2
    ld b,#3
    ld hl,dbuf_bg+#0775
    jp draw_sprite_c_b_ix_hl

spr1E8B
    db #f8,#f8
    db #d0,#f8
    db #00,#d0

cmd_draw_sprite_3_3_1e9f:
 ;1e91
    ld ix,spr_lab1E9F
    ld c,#3
    ld b,#3
    ld hl,dbuf_bg+#07CD
    jp draw_sprite_c_b_ix_hl

spr_lab1E9F
    db #00,#00,#ce
    db #00,#ce,#cf
    db #ce,#cf,#cf

cmd_draw_sprite_3_3_1eb6
;lab1ea8:
    ld ix,spr_lab1EB6
    ld c,#3
    ld b,#3
    ld hl,dbuf_bg+#07D3
    jp draw_sprite_c_b_ix_hl

spr_lab1EB6
    db #cd,#00,#00
    db #cf,#cd,#00
    db #cf,#cf,#cd

    assert $==#1ebf

; 1 param
cmd_draw_sprite_3_4_7398:
cmd_draw_sprite7398:
lab1ebf:
    ld ix,#7398
    ld c,#3
    ld b,#4
    ld hl, dbuf_bg+#06D0
    jp draw_sprite_c_b_ix_hl
spr_5_3_1ecd:
lab1ECD:
    db #01,#1f,#20,#1e,#1e
    db #21,#1e,#1e,#1e,#1e
    db #01,#22,#23,#24,#24

spr_3_2_1edc:
;lab1EDC:
    db #27,#28,#29
    db #1e,#2a,#2b

cmd_draw_sprite_3_2_1edc:
cmd_draw_sprite_1EDC
lab1EE2
    ld ix,spr_3_2_1edc
    ld d,#3
    ld b,#2
    jr draw_sprite_d_b_ix

cmd_draw_sprite_5_3_1ecd:
cmd_draw_sprite_1ECD
lab1EEC
    ld ix,spr_5_3_1eCD
    ld d,#5
    ld b,#3
    jr draw_sprite_d_b_ix

cmd_draw_sprite_2_6_1f0a:
draw_sprite_1F0A
lab1EF6
    ld ix,spr_2_6_1f0a
    ld d,#2
    ld b,#6
    jr draw_sprite_d_b_ix

cmd_draw_sprite_2_6_1f16:
cmd_draw_sprite_1F16
lab1F00
    ld ix,spr_2_6_1f16
    ld d,#2
    ld b,#6
    jr draw_sprite_d_b_ix

spr_2_6_1f0a:
;lab1F0A
    db #00,#f6
    db #f6,#f8
    db #f8,#f8
    db #f8,#f8
    db #f8,#f8
    db #d1,#00
spr_2_6_1f16:
;lab1F16
    db #f5,#00
    db #f8,#f5
    db #f8,#f8
    db #f8,#f8
    db #f8,#f8
    db #00,#d0

draw_spr_6_1_738c
lab1f22:
    ld ix,lab738C
    ld d,#6
    ld b,#1
; dessin ''sprite''
; ix: source
; b : height
; d : width
; dest == Param dans la pile
draw_sprite_d_b_ix:
draw_sprite2:
lab1F2A
    pop hl
    ld a,(hl)
    inc hl
    push hl
    ld h,(hl)
    ld l,a
.lpy
    push de
    push hl
.lpx
    ld a,(ix+0)
    ld (hl),a
    inc hl
    inc ix
    dec d
    jr nz,.lpx

    pop hl
    ld de,#20
    add hl,de
    pop de
    djnz .lpy
    jp return_from_render

spr_3_3_1f47
lab1F47 db #16,#17,#18
        db #19,#1a,#1b
        db #1c,#1d,#1e

spr_2_2_1F50
    db #1f,#1f
    db #1f,#1f

cmd_draw_sprite_2_2_1f50
lab1f54:
    ld ix,spr_2_2_1F50
    ld c,#2
    ld b,#2
    ld hl,dbuf_bg + #0A91
    jr draw_sprite_c_b_ix_hl

cmd_draw_sprite_3_3_1f47
lab1f61:
    xor a
    ld (lab95C0+1),a
    ld ix,spr_3_3_1f47
    ld c,#3
    ld b,#3
    ld hl,dbuf_bg + #0A14
    jr draw_sprite_c_b_ix_hl

cmd_draw_moon_2_2: ;lab1f72:
    ld a,#53
    ld (halt_palettes+4+1),a
    ld hl,dbuf_bg + #699
    ld a,(hl)
    dec a
    jr nz,lab1F9A

    ld ix,spr_2_2_moon
    ld c,#2
    ld b,#2

; "Sprite" render
; Width: c
; Height: b
; ix: source
; hl: destination
; 1 param en plus dans la pile (décrémenté)
; Optimisable :)
draw_sprite_c_b_ix_hl:
draw_sprite:
;lab1F86
	ld de,#20 ; largeur du buffer
.lpy
	push bc
    push hl
.lpx
    ld a,(ix+0)
    ld (hl),a
    inc hl
    inc ix
    dec c
    jr nz,.lpx
    pop hl
    pop bc
    add hl,de
    djnz .lpy
lab1F9A
	pop hl
    dec hl  ; Decremente le parametre suivant
    push hl
    jp return_from_render


; lune (2x2)
; #1fa0
spr_2_2_moon:
         db #1a,#1b
         db #1c,#1d

lab1fa4
    ld ix,spr_5_8_1B76
    ld c,#5
    ld b,#8
    ld hl,dbuf_bg+#754
    jr draw_sprite_c_b_ix_hl
data1fb1
    ld hl,dbuf_fg+#9C7
    jr lab1FF9
data1fb6
    ld hl,dbuf_fg+#A0A
    jr lab1FEC
data1fbb
	ld hl,dbuf_fg+#8A7
    jr lab1FD7
lab1fc0:
	ld hl,dbuf_fg+#9A1
    jr lab1FF9
lab1fc5:
 	ld hl,dbuf_fg+#8A1
    jr lab1FD7
lab1fca:
    ld hl,dbuf_fg+#98F
    jr lab1FF9
lab1fcf:
    ld hl,dbuf_fg+#981
    jr lab1FF9
lab1fd4:
    ld hl,dbuf_fg+#993
lab1fd7:                ; Sprite 7*10
    ld c,#a
    ld ix,#216D
    jr lab1FFF
lab1fdf:
    ld hl,dbuf_fg+#992
    jr lab1FF9

lab1fe4:
    ld hl,dbuf_fg+#983
    jr lab1FF9
lab1fe9
    ld hl,dbuf_fg+#9E9
lab1fec
    ld c,#8
    ld ix,spr_8_4_2003
    ld b,#4
    jr draw_sprite_c_b_ix_hl
lab1ff6
	ld hl,dbuf_fg+#9AA

lab1FF9 ld c,#b
lab1FFB ld ix,spr_11_7_2120
lab1FFF ld b,#7
    jr draw_sprite_c_b_ix_hl

; motif Grand rectangle 8x4
assert $==#2003
spr_8_4_2003
lab2003:
    db #02,#03,#03,#03,#03,#03,#03,#04
    db #05,#06,#06,#06,#06,#06,#06,#07
    db #05,#06,#06,#06,#06,#06,#06,#07
    db #08,#09,#09,#09,#09,#09,#09,#0a

cmd_draw_bureau_simple:
lab2023
    ld ix,spr_6_4_bureau_simple
    ld c,#6
    ld b,#4
    ld hl,dbuf_fg + #0A18
lab202E
    jp draw_sprite_c_b_ix_hl

lab2031 ld a,(lab2096)
    inc a
    jr nz,lab2050
lab2037
    ld ix,spr_11_5_209a
    ld c,#b
    ld b,#5
    ld hl,dbuf_fg + #09CC
    jr lab202E

    ld a,(lab2096)
    cp #fe
    jr nz,lab2050
    ld a,#10
    ld (lab2096),a
lab2050 jp lab1F9A
/*
db #dd,#21,#08,#21,#0e,#06
db #06,#04,#21,#18,#0a,#c3,#86,#1f
db #3a,#96,#20,#3c,#20,#19,#dd,#21
db #9a,#20,#0e,#0b,#06,#05,#21,#cc
db #09,#18,#ea,#3a,#96,#20,#fe,#fe
db #20,#05,#3e,#10,#32,#96,#20,#c3
db #9a,#1f
*/
assert $==#2053
spr_4_4_2053:
lab2053
    db #89,#8a,#8a,#8b
    db #ff,#ff,#21,#ff
    db #ff,#ff,#21,#ff
    db #ff,#ff,#21,#ff

spr_5_1_2063:
spr2063:
    db #d2,#d2,#d3,#d3,#d5

lab2068
    ld hl,dbuf_fg+#9E4
lab206B
    ld ix,spr_4_4_2053
    ld c,#4
    ld b,#4
    jp draw_sprite_c_b_ix_hl

lab2076
    ld hl,dbuf_bg+#823
lab2079
    ld ix,spr_5_1_2063
    ld c,#5
    ld b,#1
    jp draw_sprite_c_b_ix_hl
assert $==#2084
lab2084
    ld hl,dbuf_bg+#810
    jr lab2079
lab2089
    ld hl,dbuf_fg+#9D1
    jr lab206B
lab208e
    ld a,#5a
    ld (lab3C3B),a
    jp lab1F9A

lab2096
    db #00
    db #00

lab2098 dw #0000

; Utilisé pour le rendu en 1er plan
; #bx5
spr_11_5_209a:
;lab209a:
    db #ff,#ff,#62,#63,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#64,#65,#82,#83,#84,#85,#66,#ff,#ff,#ff
    db #67,#68,#69,#6a,#86,#87,#6d,#6e,#6f,#ff,#ff
    db #70,#71,#72,#73,#88,#75,#76,#77,#78,#ff,#ff
    db #79,#7a,#7b,#7c,#7d,#7e,#7f,#80,#81,#ff,#ff

; #bx5
spr_11_5_20d1:
;lab20d1:
    db #ff,#ff,#62,#63,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#64,#65,#ff,#ff,#ff,#ff,#66,#ff,#ff,#ff
    db #67,#68,#69,#6a,#6b,#6c,#6d,#6e,#6f,#ff,#ff
    db #70,#71,#72,#73,#74,#75,#76,#77,#78,#ff,#ff
    db #79,#7a,#7b,#7c,#7d,#7e,#7f,#80,#81,#ff,#ff

spr_6_4_bureau_simple:
    ;2108
    db #22,#23,#24,#24,#25,#26
    db #27,#28,#ff,#ff,#27,#28
    db #27,#28,#ff,#ff,#27,#28
    db #8c,#ff,#ff,#ff,#ff,#8d

assert $==#2120
spr_11_7_2120
db #02,#03,#04,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #05,#06,#07,#ff,#ff,#ff,#02,#03,#03,#04,#ff
db #08,#09,#0a,#ff,#ff,#ff,#05,#06,#06,#07,#ff
db #02,#03,#03,#03,#04,#ff,#08,#09,#09,#0a,#ff
db #05,#06,#06,#06,#02,#03,#04,#ff,#02,#03,#04
db #05,#06,#06,#06,#05,#06,#07,#ff,#05,#06,#07
db #08,#09,#09,#09,#08,#09,#0a,#ff,#08,#09,#0a

db #ff,#ff,#ff,#ff,#02,#03,#03,#04,#ff,#ff
db #ff,#ff,#ff,#ff,#05,#06,#06,#07
db #ff,#ff,#ff,#ff,#ff,#ff,#08,#09
db #09,#0a,#ff,#ff,#ff,#ff,#02,#03
db #03,#04,#ff,#02,#03,#04,#02,#03
db #04,#06,#06,#07,#ff,#05,#06,#07
db #05,#06,#07,#06,#06,#07,#ff,#05
db #06,#07,#08,#09,#0a,#09,#09,#0a
db #ff,#08,#09,#0a
lab21B3 db #0
db #3e,#01,#18,#06,#3e,#02,#18,#02
db #3e,#03,#32,#b3,#21,#18,#2c
lab21C3 db "COLONEL BRIGGSY  EX"
lab21D6 db "PLORER"

lab21DC db #0
lab21DD db " BIKE ARRIVED "

lab21eb:
db #af
assert $==#21ec
lab21ec:

 ld (lab42D0),a
lab21EF
    pop hl
    dec hl
    push hl
lab21F2 jp return_from_render
lab21F5 ld a,#77
    jr lab21EC

; Command 3, fill bg buffer, with a byte (param1)
cmd_fill_bg_buf:
lab21F9
    pop hl
    ld a,(hl)  ; parameter 1
    push hl

assert $==#21fc
    ; Fill Buffer 640

lab21FC
    ld hl,buf_bg
    ld (hl),a
    ld de,buf_bg+1 ; #2200
    ld bc,BUFSIZE-1
    ldir
    jp return_from_render


cmd_poke_byte:
lab220B
    pop hl
    ld a,(hl)
    inc hl
lab220E
    ld e,(hl)
    inc hl
    ld d,(hl)
    push hl
    ld (de),a
    jp return_from_render


lab2216 ld a,#ca
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    push hl
lab221D ld (de),a
    inc de
    inc a
    ld (de),a
lab2221 jp return_from_render


; Command #0
assert $==#2224
    ; Repete un motif horizontalement (+1)
cmd_draw_hline:
lab2224:
	 ld de,1
     jr draw_line_pattern ; lab223F

lab2229:
	ld b,#d6
    ld a,d
    ld b,#e1

    ld hl,lab2229
    push hl

cmd_draw_rline:
lab2232
    ; Repete un motif en diagonal (+33)
    ld de,#20+1
    jr draw_line_pattern ; lab223F

    ; Repete un motif en diagonal (+31)
cmd_draw_lline:
lab2237:
	ld de,#20-1
    jr draw_line_pattern ;lab223F

; Repete un motif verticalement (+32)
; p0: longueur ligne
; p1: pattern
: p2: addresse destination

cmd_draw_vline:
lab223c:
    ld de,#20

draw_line_pattern
lab223F
    pop hl
    ld b,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld a,(hl)
    inc hl
    push hl
    ld h,(hl)
    ld l,a
lab2249
    ld (hl),c
    add hl,de
    djnz lab2249
    jp return_from_render

;db #11,#20,#00,#e1,#46,#23,#4e ;.....F.N
;db #23,#7e,#23,#e5,#66,#6f,#71,#19 ;....foq.
;db #10,#fc,#c3,#3f,#1a

cmd_draw_2b_ldiag_pattern_2c:
lab2250
    ld c,#2c
    jr draw_2b_ldiag_pattern
cmd_draw_2b_ldiag_pattern_09:
lab2254
    ld c,#9
    jr draw_2b_ldiag_pattern
cmd_draw_2b_ldiag_pattern_25:
lab2258
	ld c,#25
    jr draw_2b_ldiag_pattern


cmd_draw_2b_ldiag_pattern_05:
lab225C
	ld c,#5
    ; p0: longueur ligne
    ; p1: addresse destination
draw_2b_ldiag_pattern:
;lab225E:
    ld de,#20-1 ; Diagonal
    pop hl
    ld b,(hl)
    inc hl
    ld a,(hl)
    inc hl
    push hl
    ld h,(hl)
    ld l,a
.lp
    ld (hl),c
    inc hl
    inc c
    ld (hl),c
    dec c
    add hl,de
    djnz .lp
    jp return_from_render

cmd_4_3_spr_8_6
lab2274:
    ld de,buf_bg
    ld b,#3
lab2279 ld c,#4
lab227B pop hl
    ld a,(hl)
    inc hl
    push hl
    push de
    exx
    ld l,a
    ld h,#0
    add hl,hl
    ld de,lab22B8
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    pop de

    ; Utilisation de l''un des 25 buffers 8x6,  22ea, 231a, 234a,...
    ld b,#6
lab2290
    ld c,#8
lab2292
    ld a,(hl)
    inc hl
    ld (de),a
    inc de
    dec c
    jr nz,lab2292
    push hl
    ld hl,#18
    add hl,de
    ex de,hl    ; de = ligne suivante (#18+8)
    pop hl
    djnz lab2290

    exx
    ld hl,#8
    add hl,de
    ex de,hl
    dec c
    jr nz,lab227B
    ld hl,#A0
    add hl,de
    ex de,hl
    djnz lab2279
    pop hl
    dec hl
    push hl
    jp return_from_render

assert $==#22b8
table_buffers_8_6
lab22b8:

aa=#22ea
repeat 25
dw aa
aa=aa+#30
rend

/*dw lab22ea
  dw lab231a
  dw lab234a
  dw lab237a
  dw lab23aa
dw lab23da
db #0a,#24
db #3a,#24
db #6a,#24
db #9a,#24
db #ca,#24
db #fa,#24
db #2a,#25
db #5a,#25
db #8a,#25
db #ba,#25
db #ea,#25
db #1a,#26
db #4a,#26
db #7a,#26
db #aa,#26
db #da,#26
db #0a,#27
db #3a,#27
db #6a,#27
*/

buffers_8_6:
assert $==#22ea
; 25 buffers de taille 8*6 = 48
buf_8_6_00:
lab22ea:
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08

buf_8_6_01:
lab231a:
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #f0,#ef,#ee,#e9,#e8,#ea,#e9,#ee
db #ed,#e7,#ec,#ea,#e7,#ee,#e7,#e7
db #e7,#e7,#eb,#e7,#e7,#e7,#e7,#e7

buf_8_6_02:
lab234a:
db #08,#08,#08,#08,#08,#e6,#e7,#e7
db #08,#08,#08,#08,#08,#e5,#e7,#e7
db #08,#08,#08,#08,#08,#e4,#e3,#e7
db #08,#08,#08,#08,#08,#e6,#e7,#e7
db #08,#08,#08,#08,#08,#e2,#e1,#e7
db #08,#08,#08,#08,#08,#e4,#e7,#e7

buf_8_6_03:
lab237a:
db #08,#08,#08,#e0,#e8,#ee,#e7,#e7
db #08,#08,#e0,#ee,#e7,#e7,#e7,#e7
db #e0,#e8,#ee,#ec,#e7,#e7,#e7,#e7
db #ee,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #ec,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#ee,#e7,#e7,#e7,#e7,#e7,#e7

buf_8_6_04:
lab23aa:
db #df,#de,#dc,#de,#db,#dd,#de,#df
db #08,#dd,#08,#dd,#08,#08,#dc,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08

buf_8_6_05:
lab23da:
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7

buf_8_6_06:
db #e7,#e7,#da,#08,#08,#08,#08,#08
db #e7,#e7,#d9,#08,#08,#08,#08,#08
db #e7,#e1,#da,#08,#08,#08,#08,#08
db #e7,#e7,#d8,#08,#08,#08,#08,#08
db #e7,#d9,#da,#08,#08,#08,#08,#08
db #e7,#e7,#d8,#08,#08,#08,#08,#08

buf_8_6_07:
db #e7
db #ec,#d8,#08,#08,#08,#08,#08,#de
db #db,#08,#08,#08,#08,#08,#08,#dd
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08

buf_8_6_08:
db #e7
db #e7,#f0,#ea,#e8,#08,#08,#08,#e7
db #e7,#f0,#e7,#e7,#ef,#08,#08,#e7
db #e7,#e7,#e7,#e7,#f0,#e8,#08,#e7
db #e7,#e7,#e7,#e7,#e7,#ed,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7

buf_8_6_09:
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #d7,#08,#08,#08,#08,#08,#08,#08
db #e7,#e9,#e8,#d7,#08,#08,#08,#08
db #e7,#e7,#ec,#df,#08,#08,#08,#08

buf_8_6_0a:
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#e0,#d7,#e0
db #08,#08,#08,#08,#08,#e2,#e1,#e7
db #08,#08,#08,#08,#08,#e4,#e7,#e7

buf_8_6_0b:
db #08,#08,#08,#08,#08,#d6,#e7,#e7
db #08,#08,#08,#08,#08,#08,#de,#db
db #08,#08,#08,#08,#08,#08,#dd,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08

buf_8_6_0c:
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#f0,#df,#dc,#db
db #e7,#e7,#e7,#e7,#df,#08,#08,#08
db #e7,#e7,#e7,#dd,#08,#08,#08,#08
db #e7,#e7,#d8,#08,#08,#08,#08,#08

buf_8_6_0d:
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #d6,#de,#e7,#e7,#e7,#e7,#e7,#e7
db #08,#dd,#db,#e7,#e7,#e7,#e7,#e7
db #08,#08,#08,#dc,#e7,#e7,#e7,#e7
db #08,#08,#08,#08,#d6,#e7,#e7,#e7
db #08,#08,#08,#08,#08,#e4,#e7,#e7

buf_8_6_0e:
db #de,#df,#df,#de,#de,#e7,#df,#de
db #dd,#08,#08,#08,#dc,#db,#08,#dd
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08

buf_8_6_0f:
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #e7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #df,#0b,#0c,#0c,#0c,#0c,#0d,#df
db #08,#08,#08,#08,#08,#08,#08,#08
db #08,#08,#08,#08,#08,#08,#08,#08

buf_8_6_10:
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01

buf_8_6_11:
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #fe,#fe,#d7,#01,#01,#01,#01,#01
db #e7,#e7,#e7,#d7,#01,#01,#01,#01
db #e7,#e7,#ec,#df,#01,#01,#01,#01

buf_8_6_12:
db #e7,#e7,#da,#01,#01,#01,#01,#01
db #e7,#e7,#d9,#01,#01,#01,#01,#01
db #e7,#e1,#da,#01,#01,#01,#01,#01
db #e7,#e7,#d8,#01,#01,#01,#01,#01
db #e7,#d9,#da,#01,#01,#01,#01,#01
db #e7,#e7,#d8,#01,#01,#01,#01,#01

buf_8_6_13:
db #e7,#e7,#da,#01,#01,#01,#01
db #01,#dc,#de,#d8,#01,#01,#01,#01
db #01,#08,#08,#12,#01,#01,#01,#01
db #01,#08,#08,#08,#11,#01,#01,#01
db #01,#08,#08,#08,#12,#01,#01,#01
db #01,#08,#08,#08,#08,#11,#01,#01
db #01

buf_8_6_14:
db #08,#08,#08,#08,#12,#01,#01
db #01,#08,#08,#08,#08,#08,#11,#01
db #01,#08,#08,#08,#08,#08,#12,#01
db #01,#e9,#e8,#e9,#e8,#e9,#e9,#e8
db #d7,#e7,#e7,#e7,#e7,#e7,#e7,#e7
db #df,#e7,#e7,#e7,#e7,#e7,#db,#df
db #01

buf_8_6_15:
db #01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#f0,#ef,#ee,#e9,#e8,#ea,#e9
db #ee,#ed,#e7,#ec,#ea,#e7,#ee,#e7
db #e7,#e7,#e7,#eb,#e7,#e7,#e7,#e7
db #e7

buf_8_6_16:
lab270a
db #01,#01,#01,#01,#01,#e2,#e1
db #e7,#01,#01,#01,#01,#01,#e4,#e7
db #e7,#01,#01,#01,#01,#01,#d6,#e7
db #e7,#01,#01,#01,#01,#01,#01
db #de
db #08,#01,#01,#01,#01,#01,#01,#dd
db #08,#01,#01,#01,#01,#01,#01,#01
db #08

buf_8_6_17:
db #01,#01,#01,#01,#01,#e6,#e7
db #e7,#01,#01,#01,#01,#01,#e5,#e7
db #e7,#01,#01,#01,#01,#01,#e4,#e3
db #e7,#01,#01,#01,#01,#01,#e6,#e7
db #e7,#01,#01,#01,#01,#01,#e2,#e1
db #e7,#01,#01,#01,#01,#01,#e4,#e7
db #e7

buf_8_6_18:
lab276a
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#e0,#fe,#fe
db #01,#01,#01,#01,#01,#e2,#e1,#e7
db #01,#01,#01,#01,#01,#e4,#e7,#e7

; --------------------------------
; 33x14 octets
; RY RX HL <10 bytes>
lab279A db #1b,#08,#54,#0a
lab279E db #01,#02,#01,#01,#02
lab27A3 db #07,#05,#07,#06,#01

db #03,#0e,#3a,#0a
db #02,#01,#03,#03,#03,#05,#02,#07,#05,#03

db #1d,#1f,#5a,#0a
db #00,#00,#00,#00,#00,#06,#05,#07,#06,#05

db #03,#0c,#8a,#0a
db #00,#00,#00,#00,#00,#07,#07,#07,#07,#03

db #02,#08,#6e,#0a
db #00,#00,#00,#00,#00,#07,#07,#04,#01,#02

db #0c,#04,#63,#09
db #00,#00,#00,#00,#00,#02,#02,#02,#07,#02

db #0c,#05,#63,#0a
db #00,#00,#00,#00,#00,#07,#02,#02,#07,#02

db #0b,#04,#6f,#0a
db #00,#00,#00,#00,#00,#05,#02,#02,#01,#02

db #0b,#05,#67,#09
db #00,#00,#00,#00,#00,#02,#02,#02,#02,#02

db #0a,#04,#44,#0a
db #00,#00,#00,#00,#00,#05,#05,#05,#04,#03

db #0a,#05,#54,#0a
db #00,#00,#00,#00,#00,#01,#02,#01,#03,#03

db #13,#05,#44,#0a
db #00,#00,#00,#00,#00,#04,#01,#01,#07,#02

db #1e,#01,#58,#0a
db #00,#00,#00,#00,#00,#06,#06,#06,#06,#04

db #18,#0d,#4a,#0a
db #00,#00,#00,#00,#00,#02,#04,#03,#03,#03

db #15,#0c,#48,#0a
db #00,#00,#00,#00,#00,#02,#05,#05,#06,#06

db #07,#1b,#47,#0a
db #00,#00,#00,#00,#00,#01,#01,#04,#01,#02

db #10,#09,#f5,#09
db #00,#00,#00,#00,#00,#05,#02,#02,#07,#07

db #10,#0c,#e7,#09
db #00,#00,#00,#00,#00,#07,#04,#01,#01,#06

db #0c,#08,#e5,#09
db #00,#00,#00,#00,#00,#06,#06,#06,#03,#03

db #09,#09,#6b,#0a
db #00,#00,#00,#00,#00,#05,#07,#07,#02,#03

db #0c,#0d,#6b,#0a
db #00,#00,#00,#00,#00,#02,#02,#02,#03,#03

db #13,#11,#78,#0a
db #00,#00,#00,#00,#00,#05,#05,#04,#07,#03

db #0e,#11,#3a,#0a
db #00,#00,#00,#00,#00,#01,#01,#06,#06,#06

db #08,#0f,#43,#09
db #00,#00,#00,#00,#00,#06,#04,#03,#03,#03

db #07,#11,#5b,#0a
db #00,#00,#00,#00,#00,#02,#02,#02,#06,#04

db #18,#13,#44,#0a
db #00,#00,#00,#00,#00,#06,#07,#06,#02,#03

db #1d,#16,#56,#0a
db #00,#00,#00,#00,#00,#07,#02,#02,#04,#01

db #1c,#18,#52,#0a
db #00,#00,#00,#00,#00,#06,#04,#03,#03,#03

db #15,#1e,#43,#0a
db #00,#00,#00,#00,#00,#06,#07,#07,#04,#02

db #0f,#17,#4a,#0a
db #00,#00,#00,#00,#00,#01,#01,#02,#05,#03

db #07,#16,#7b,#0a
db #00,#00,#00,#00,#00,#01,#04,#01,#03,#03

db #08,#1b,#49,#0a
db #00,#00,#00,#00,#00,#05,#02,#01,#07,#07

db #05,#18,#54,#0a
db #00,#00,#00,#00,#00,#07,#07,#05,#02,#05

lab2968: dw 0
lab296a: db 0

lab296B:
    ld hl,#ffe0
    jr lab2986
lab2970:
    ld hl,#ffe1
    jr lab2986
lab2975
    ld b,#e7        ; data?
    ld e,d
    ld b,#e1

    ld hl,lab2975
    push hl
    ld hl,#21
    jr lab2986

lab2983
    ld hl,#20
lab2986 ld (lab299C+1),hl
    pop hl
    ld d,(hl)
    ld b,d
    inc hl
    ld c,(hl)
    inc hl
    ld a,(hl)
    inc hl
    push hl
    ld h,(hl)
    ld l,a
lab2994 push de
    push hl
lab2996 ld (hl),c
    inc hl
    dec d
    jr nz,lab2996
    pop hl
lab299C ld de,#20
    add hl,de
    pop de
    dec d
    djnz lab2994
    jp return_from_render

assert $==#29a7
cmd_draw_rect:
lab29a7
    pop hl
    ld d,(hl) ; width
    inc hl
    ld b,(hl) ; height
    inc hl
    ld c,(hl) ; pattern
    inc hl
    ld a,(hl) ; dest
    inc hl
    push hl
    ld h,(hl) ;dest
    ld l,a
.lpy push de
    push hl
.lpx ld (hl),c
    inc hl
    dec d
    jr nz,.lpx
    pop hl
    ld de,#20 ; next line
    add hl,de
    pop de
    djnz .lpy
    jp return_from_render

; 2 premieres valeurs: coordonnées de la room
; La 3eme valeur est utilisée pour
; aller lire dans la table des fonctions
; de rendu
lab29C5
    db #1b,#07,#46
    db #00,#0c,#47
    db #1b,#00,#48
    db #16,#18,#4b
    db #16,#18,#4c
    db #1b,#0e,#4b
    db #1b,#0e,#4c
    db #0d,#0e,#5e
    db #1b,#0d,#38
    db #1b,#09,#39
    db #1b,#05,#2b
    db #07,#1b,#38
    db #12,#19,#40
    db #19,#0c,#40
    db #0f,#1c,#38
    db #0f,#05,#38
    db #0f,#1c,#40
    db #0d,#03,#43
    db #13,#1e,#41
    db #1d,#1f,#42
    db #16,#16,#44
    db #16,#16,#45


assert $==#2a07
; Appelé au changement de salle
lab2A07
    ld hl,return_from_render2
    ld (return_from_render+1),hl

    ; Dessin d''élement particuliers du décor
    ld ix,lab29C5
    ld b,#1a        ; ??? il n''y a pas 26 element dans la table mais 20
lab2A13
    ld a,(Room_Y)
    cp (ix+0)
    jr nz,lab2A3A
    ld a,(Room_X)
    cp (ix+1)
    jr nz,lab2A3A

    ; Recupere le pointer de fonction
    ld l,(ix+2)
    ld h,0
    add hl,hl
    ld de,render_table ; lab1A42
    add hl,de

    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a

    push ix
    push bc
    push hl
    jp (hl)

    ; Retour de la fonction de rendu
return_from_render2:
lab2a36
    pop hl
    pop bc
    pop ix

lab2A3A
    inc ix
    inc ix
    inc ix
    djnz lab2A13


    ; --------------------
    ld hl,lab1a3b
    ld (return_from_render+1),hl
    ld a,(Room_Y)
    cp #1f
    jr nz,lab2A66

    ld bc,#100		; a optimiser avec b=0/djnz
    ld hl,#85F
    ld de,dbuf_fg+#A9F
lab2A58
	ld a,(hl)
    cp #c7
    jr nc,lab2A5F
    xor a
    ld (de),a
lab2A5F dec hl
    dec de
    dec bc
    ld a,b			;  ld b,0 / djnz
    or c
    jr nz,lab2A58

; Parcours la table 279A, les 33 valeurs
; Compare les coordonnées avec (Room X,Y)
lab2A66 ld ix,lab279A

	ld b,#21
lab2A6C
    ld a,(Room_Y)
    cp (ix+0)
    jr nz,.next
    ld a,(Room_X)
    cp (ix+1)
    jr nz,.next
    ld l,(ix+2)
    ld h,(ix+3)
    ld a,(hl)
    inc a
    jr nz,.nonff
    ; #ff => Write #29 #2a
    ld (hl),#29
    inc hl
    ld (hl),#2a
    dec hl
.nonff:
    ; Previous buffer
    ld de,labFDC0 ; -#240 -BUFSIZE
    add hl,de
    ; Write #64 #64
    ld (hl),#64
    inc hl
    ld (hl),#64
    ; hl = ix+4
    push ix
    pop hl
    inc hl
    inc hl
    inc hl
    inc hl
    ld (lab2968),hl
.next
    ld de,14
    add ix,de
    djnz lab2A6C

    ;
    call render ; RENDER

    ld a,(lab21B3)
    dec a
    jr nz,lab2AB9

    ld hl,lab21C3
    ld de,lab5033
    ld c,#1
    jr lab2ACA

lab2AB9 dec a
    jr nz,lab2AD5

    ld hl,#40
    ld (lab14AB+1),hl
    ld hl,lab21C3+1
    ld de,#4013
    ld c,#12
lab2ACA call draw_text
    ld hl,2
    ld (lab14AB+1),hl
    jr lab2B0D
lab2AD5 dec a
    jr nz,lab2B0D
    ld hl,#0040
    ld (lab14AB+1),hl
    ld hl,lab21D6
lab2AE1 ld de,#4013
    ld c,#6
    jr lab2ACA
lab2AE8 ld hl,(data2aff)

	ld b,#4
lab2AED
    ld a,(de)   ; ex de,hl:ldir;ex de,hl
    ld (hl),a
    inc hl
    inc de
    djnz lab2AED

	ld de,labFDC0 ; -#240 -BUFSIZE
    add hl,de

    ld b,#4
lab2AF9
    dec hl
    ld (hl),#1
    djnz lab2AF9

    ret

data2aff db #4d
db #08
lab2B01 db #0
lab2B02 db #a
lab2B03 db #6f
db #6f,#6f,#6f ;ooo
lab2B07 db #d2
db #d3,#d3,#d5
lab2B0B db #0
db #00
lab2B0D call lab3E7A

if  (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
	call fast_clear_buf
else
    call lab4D6F
    ld hl,buf_mask
    ld de,buf_mask+1
    ld bc,#023F
    ld (hl),#0
    ldir
endif

org #2b20
lab2B20 ld b,#1
LAB2B22
    ld hl,buf_spr2
    ld de,#F700 ; -#900
    add hl,de
    ld a,#1
lab2B2B ld (hl),a
lab2B2C    inc hl
    djnz lab2B2B
    ld (lab2B20+1),a
    ld hl,(room_map_index+1)
    ld a,(hl)
    cp #3a                      ; Room index #3a?
    jr nz,lab2B45

    ld b,#6
    ld de,lab2DDA
    ld hl,dbuf_fg+#8e1
    call lab43C3

lab2B45
    ld a,(hl)                   ; Room #3c?
    cp #3c
    jr nz,lab2B55

    ld b,#6
    ld de,lab2DDA
    ld hl,dbuf_fg+#08EC
    call lab43C3

lab2B55
    ld a,(hl)
    cp #9e
    jr nz,lab2B92

    ld de,lab2B03
    call lab2AE8
    ld a,(lab2B01)
    or a
    ld hl,lab2B02
    jr z,lab2B7C
    inc (hl)
    ld a,#13
    cp (hl)
    ld hl,(data2aff)
    inc hl
    ld (data2aff),hl
    jr nz,lab2B8C
    ld hl,lab2B01
    dec (hl)
    jr lab2B8C
lab2B7C dec (hl)
    xor a
    cp (hl)
    ld hl,(data2aff)
    dec hl
    ld (data2aff),hl
    jr nz,lab2B8C
    ld hl,lab2B01
    inc (hl)
lab2B8C
    ld de,lab2B07
    call lab2AE8

lab2B92
    call lab8A58
    call lab39D2
    call lab8A6E
    ld b,#0
    ld a,(lab515D)
    cp #64
    jr nz,lab2BA8
    ld hl,(lab2968)
    ld b,(hl)
lab2BA8
    ld a,b
    ld hl,lab3496
    cp (hl)
    ld (hl),a
    call nz,lab541E

lab2BB1 jp 0

LAB2BB4
    call lab39ED
    call lab39D2
    call lab4D7D
    ld a,(lab39CC)
    add a,#7
    cp #8
    jr c,lab2BD7
    ld hl,(lab39CD)
    ld de,dbuf_fg+#08A2
    call lab5DAA
    add hl,de
    xor a
    cp (hl)
    ld b,#2
    call z,lab95C0
lab2BD7
	ld a,(lab8159)
    inc a
    and #3
    ld (lab8159),a
    add a,a
    ld l,a
lab2BE2 ld h,0
    ld de,lab814F
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (lab8157),hl
    ld a,(lab8160)
    inc a
    cp #3
    jr nz,lab2BF8
    xor a
lab2BF8 ld (lab8160),a
    add a,a
    ld l,a
    ld h,0
    ld de,lab815A
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (#2EEB+1),hl
    ld ix,lab34C3
    ld b,#65
lab2C10 push bc
    ld bc,#0706
    ld a,(ix+11)
    cp #1
    call z,lab3285
    cp #6
    call z,lab3285
    cp #4
    call z,lab3285
    cp #9
    call z,lab3285
lab2C2B cp #a
    call z,lab3285
    call lab3999
    call lab2D9F
    push ix
    pop hl
    inc hl
    inc hl
    inc hl
    ld (lab50D7+1),hl
    ld (lab5CFA+1),hl
    ld a,(Room_Y)
    ld b,a
    ld a,(ix+0)
    and #7f
    cp b
    jr nz,lab2C5F
    ld a,(Room_X)
    cp (ix+2)
    jr nz,lab2C5F
    call lab8A58
    call lab39A8
    call lab8A6E
lab2C5F ld a,(Room_Y)
    ld b,a
    ld a,(ix+0)
    and #7f
    sub b
    add a,#3
    cp #6
    jp nc,lab306E
    ld a,(Room_X)
    sub (ix+2)
    add a,#6
    cp #c
    jp nc,lab306E
    ld a,(ix+11)
    cp #2
    jp nc,lab2D1B
    ld a,(ix+1)
    ld b,a
    ld h,(ix+4)
    ld l,(ix+3)
    ld d,#ff
    ld a,(ix+0)
    bit 7,a
    jr z,lab2CAE
    ld a,r
    and #3
    jr z,lab2CAE
    inc d
    ld a,(ix+1)
    add a,#a
    ld e,a
    ld a,(lab39CB)
    add a,#a
    cp e
    jr nc,lab2CAE
    inc d
lab2CAE ld a,(data39ec)
    or a
    jr z,lab2CEF
    ld a,(ix+2)
    cp (ix+5)
    jr nz,lab2CDD
    ld a,(ix+6)
    cp b
    jr nz,lab2CDD
lab2CC2 dec d
    jr z,lab2CD0
    ld a,(ix+11)
    add a,a
    add a,#7
lab2CCB ld (ix+11),a
    jr lab2D1B
lab2CD0 ld a,r
    and #7
    add a,#3
    ld (lab2DE1),a
    ld a,#c
    jr lab2CCB
lab2CDD dec b
    dec hl
    ld a,#fc
    cp b
lab2CE2 jr nz,lab2D11
    ld b,#1c
    ld de,#0020
    add hl,de
    dec (ix+2)
    jr lab2D11
lab2CEF ld a,(ix+2)
    cp (ix+7)
    jr nz,lab2D01
    ld a,(ix+8)
    cp b
    jr nz,lab2D01
    inc d
    jp lab2CC2
lab2D01 inc b
    inc hl
    ld a,#1e
    cp b
    jr nz,lab2D11
    ld b,#fe
    ld de,#FFE0
    add hl,de
    inc (ix+2)
lab2D11 ld (ix+3),l
    ld (ix+4),h
    ld a,b
    ld (ix+1),a
lab2D1B ld a,(Room_Y)
    ld b,a
    ld a,(ix+0)
    and #7f
    cp b
    jp nz,lab306E
    ld a,(Room_X)
    cp (ix+2)
    jp nz,lab306E

lab2D31
	call lab8A58
    call lab39A8
    call lab8A6E
    ld a,(ix+9)
    bit 7,a
    ld a,#1
    jr z,lab2D44
    inc a
lab2D44 ld hl,lab2DE3
    cp (hl)
    jr nz,lab2D8A
    ld a,(ix+11)
    cp #5
    jr z,lab2D8A
    cp #6
    jr z,lab2D8A
    ld b,#2
    call lab8A76
    call lab979B
    ld hl,lab2DE0
    dec (hl)
    jr z,lab2D69
    ld a,r
    and #7
    jr nz,lab2D8A
lab2D69 ld a,#5
    ld (hl),a
    ld a,(ix+11)
    cp #4
    ld b,#6
    jr z,lab2D82
    cp #1
    jr z,lab2D82
    cp #9
    jr z,lab2D82
    cp #a
    jr z,lab2D82
    dec b
lab2D82 ld (ix+11),b
    ld b,#a
    call lab8A76
lab2D8A ld a,(ix+11)
    ld l,a
    ld h,#0
    add hl,hl
    ld de,data2dc0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(data39ec)
    ld b,a
    or a
    jp (hl)
lab2D9F ld a,(ix+9)
    bit 7,a
    ret z
    ld hl,lab2DE1
    ld a,(hl)
    push af
    inc hl
    ld a,(hl)
    dec hl
    ld (hl),a
    inc hl
    pop af
    ld (hl),a
    ld hl,(lab2DE4)
    push hl
    ld hl,(lab2DE6)
    ld (lab2DE4),hl
    pop hl
    ld (lab2DE6),hl
    ret

data2dc0
    dw lab2df8 ;#f8,#2d
    dw lab2EC9 ;#c9,#2e
    db #15,#2f
    db #ef,#2f
    db #1d,#30
    db #e5,#2f
    db #ea,#2f
    db #b9,#2f
    db #c2,#2f
    db #d3,#2f
    db #dc,#2f
    db #14,#30
    db #52,#2f

lab2DDA: db #40,''LIFT'',#40 ;LIFT.
lab2DE0: db #05
lab2DE1: db #00,#00
lab2de3: db #00
lab2de4: db #00,#00
lab2de6: db #00,#00

lab2de8: db #0a,#00
         db #0a,#08
         db #0a,#00
         db #08,#00
         db #08,#08
         db #09,#00
         db #09,#08
         db #09,#00

; Fonction 1 de la table 2dC0
lab2df8:
    ld hl,dbuf_spr1+#b25
    jr z,lab2E00
    ld hl,dbuf_spr1+#B20
lab2E00
    ld e,(ix+3)
    ld d,(ix+4)
    add hl,de
    ld a,(lab514E)
    inc a
    jr z,lab2E23
    ld a,(hl)
    inc a
    jr z,lab2E23
    ld (lab2DE4),hl
    ld (ix+11),#2
    ld a,#3
    ld (lab2DE1),a
    ld a,r
    rra
    jp nc,lab2EC3
lab2E23 ld a,(lab5148)
    inc a
    jr z,lab2E46
    ld a,b
    or a
lab2E2B ld hl,dbuf_spr1 + #B05
lab2E2E jr z,lab2E33
    ld hl,dbuf_spr1 + #B00
lab2E33 add hl,de
    ld a,(hl)
    inc a
    jr z,lab2E46
    ld (lab2DE4),hl
    ld a,#2
    ld (ix+11),#b
    ld (lab2DE1),a
    jr lab2EC3
lab2E46 ld a,r
    and #7
    jr nz,lab2EC0
    ld a,(lab349E)
    or a
    jr nz,lab2EC0
    ld a,(lab514D)
    inc a
    jr z,lab2EC0
    ld hl,lab39CC
    ld a,(ix+9)
    and #3f
    sub (hl)
    add a,#4
    cp #9
    jr nc,lab2EC0
    ld l,(ix+3)
    ld h,(ix+4)
    ld de,#64
    add hl,de
    ld b,#4
    ld c,#8
    ld d,#0
    ld a,(ix+1)
    add a,#a
    ld e,a
    ld a,(lab39CB)
    add a,#a
    cp e
    jr nc,lab2E8E
    ld b,#1
    ld c,#4
    ld d,#1
    dec hl
    dec hl
    dec hl
lab2E8E ld a,(#39ec)
    cp d
    jr nz,lab2EC0
    ld a,(ix+1)
    add a,b
    ld (#34A0),a
    ld (#34A0+1),hl
    ld a,c
    ld (#34A0+3),a
    ld (#34A0+4),a
    ld a,#d4
    ld (lab349E),a
    ld a,(ix+9)
    and #3f
    add a,#3
    ld (#349f),a
    ld (ix+11),#2
    ld a,#1
    ld (lab2DE1),a
    jp lab2EC3
lab2EC0 call lab2EF1
lab2EC3 ld hl,(lab8157)
    jp lab302C

; Fonction 2 de la table 2dc0
lab2EC9
    ld hl,dbuf_spr1+#AE6
    jr z,lab2ED1
    ld hl,dbuf_spr1+#0AE1
lab2ED1
    ld a,(lab5146)
    inc a
    jr z,lab2EE8
    ld e,(ix+3)
    ld d,(ix+4)
    add hl,de
    ld a,(hl)
    inc a
    jr z,lab2EE8
    ld (ix+11),#4
    jr lab2EEB

lab2EE8 call lab2EF1
lab2EEB ld hl,#0
    jp lab302C
lab2EF1 ld a,r
    and #3
    ret nz
    ld a,(lab39CB)
    add a,#4
    sub (ix+1)
    sub #4
lab2F00 ld b,#1
    jp m,lab2F06
    dec b
lab2F06 ld a,(#39ec)
    cp b
    ret z
    ld a,(ix+11)
    add a,a
    add a,#7
    ld (ix+11),a
    ret
    ld hl,lab2DE1
    ld a,#2
    cp (hl)
    jr nz,lab2F2E
    push hl
    ld hl,(lab2DE4)
    ld a,(hl)
    inc a
    jr z,lab2F2D
    call lab9799+2
    ld b,#c
    call lab95C0
lab2F2D pop hl
lab2F2E dec (hl)
    jr nz,lab2F35
    xor a
    ld (ix+11),a
lab2F35 ld hl,lab7F90
    jp lab302C

assert #2f3b==$
lab2f3b
db #a3,#a4,#a4,#a4,#a4,#a4
db #a4,#a4,#a4,#a5

lab2F45 push hl
lab2F46 ld hl,#4000
    inc hl
    nop
    nop
    ld (lab2F46+1),hl
    ld a,(hl)
    pop hl
    ret

    ld de,dbuf_spr2+#0D66
    ld c,#c
    ld a,(#39ec)
    dec a
    ld a,#23                 ; OPCODE
    jr nz,lab2F65
    ld de,dbuf_spr2+#0D5F
    inc c

    ld a,#2b                 ; OPCODE
lab2F65
    ld (lab2FA5),a
    ld (lab2B2C),a
    ld a,c
    ld (lab2FA7),a
    ld a,(ix+1)
    dec a
    ld c,a
    ld l,(ix+3)
    ld h,(ix+4)
    add hl,de
    ld (lab2B22+1),hl
    ld de,lab2F3B
    ld a,#a
    ld b,a
    ld (lab2B20+1),a
lab2F87 ld a,c
    cp #19
    jr nc,lab2FA5
    push hl
    push de
    ld de,#f940
    add hl,de
    ld a,(hl)
    pop de
    pop hl
    cp #c7
    jr nc,lab2FAA
    ld a,(de)
    ld (hl),a
    push hl
    push de
    ld de,#f700
    add hl,de
    ld (hl),#1
    pop de
    pop hl
lab2FA5
     inc hl ; Code automodifié
     inc de
lab2FA7 nop
    djnz lab2F87
lab2FAA ld hl,lab2DE1
    dec (hl)
    jr nz,lab2FB4
    ld (ix+11),#7
lab2FB4 ld hl,lab7F90
    jr lab302C
    ld (ix+11),#8
    ld hl,lab80BA+1
    jr lab302C
    ld (ix+11),#0
    ld hl,lab80BA+1
lab2FC9 ld a,(#39ec)
    xor #1
    ld (#39ec),a
    jr lab302C
    ld (ix+11),#a
lab2FD7 ld hl,lab8029
    jr lab302C
    ld (ix+11),#1
    ld hl,lab8029
    jr lab2FC9

    ld hl,lab810D
    jr lab302C

    ld hl,lab8137
    jr lab302C

/*
data2f52 db #11
db #66,#0d,#0e,#0c,#3a,#ec,#39,#3d ;f.......
db #3e,#23,#20,#06,#11,#5f,#0d,#0c
db #3e,#2b,#32,#a5,#2f,#32,#2c,#2b
db #79,#32,#a7,#2f,#dd,#7e,#01,#3d ;y.......
db #4f,#dd,#6e,#03,#dd,#66,#04,#19 ;O.n..f..
db #22,#23,#2b,#11,#3b,#2f,#3e,#0a
db #47,#32,#21,#2b,#79,#fe,#19,#30 ;G...y...
db #19,#e5,#d5,#11,#40,#f9,#19,#7e
db #d1,#e1,#fe,#c7,#30,#11,#1a,#77 ;.......w
db #e5,#d5,#11,#00,#f7,#19,#36,#01
db #d1,#e1,#23,#13,#00,#10,#dd,#21
db #e1,#2d,#35,#20,#04,#dd,#36,#0b
db #07,#21,#90,#7f,#18,#73,#dd,#36 ;.....s..
db #0b,#08,#21,#bb,#80,#18,#6a,#dd ;......j.
db #36,#0b,#00,#21,#bb,#80,#3a,#ec
db #39,#ee,#01,#32,#ec,#39,#18,#59 ;.......Y
db #dd,#36,#0b,#0a,#21,#29

lab2FD9 db #80
db #18,#50,#dd,#36,#0b,#01,#21,#29 ;.P......
db #80,#18,#e4,#21,#0d,#81,#18,#42 ;.......B
db #21,#37,#81,#18,#3d
*/

lab2FEF ld hl,lab2DE1
    ld a,#1
    cp (hl)
    jr nz,lab3008
    push hl
    ld hl,(lab2DE4)
    ld a,(hl)
    inc a
    jr z,lab3007
    call lab979B
    ld b,#7
    call lab95C0
lab3007 pop hl
lab3008 dec (hl)
    jr nz,lab300F
    xor a
    ld (ix+11),a
lab300F ld hl,#80E5
    jr lab302C
    ld (ix+11),#3
    ld hl,#7FB9
    jr lab302C
    call lab979B
lab3020 ld b,#6
    call lab95C0
    ld (ix+11),#1
    ld hl,#7FF9
lab302C ld (lab3054+1),hl
lab302F ld hl,lab397F
lab3032 ld a,(ix+9)
lab3035 bit 7,a
    jr z,lab303C
    ld hl,lab3980
lab303C ld a,(data39EC)
    ld (hl),a
    ld l,(ix+3)
    ld h,(ix+4)
    ld de,buf_spr2
    ld a,(ix+9)
    bit 7,a
    jr z,lab3053
    ld de,buf_spr3
lab3053 add hl,de
lab3054 ld de,0
lab3057 ld b,#7
lab3059 ld c,#6
    exx
    ld a,(ix+9)
    and #7f
    ld d,a
    exx
    ld a,(ix+1)
    call lab50C6
    call lab39A8
    jr lab30BD
lab306E ld a,(ix+11)
    cp #c
    jr nz,lab307B
    ld (ix+11),#7
    jr lab30BD
lab307B cp #b
    jr z,lab30B9
    cp #9
    jr nz,lab3091
    ld a,(data39ec)
    xor #1
    ld (data39ec),a
    ld (ix+11),#1
    jr lab30BD
lab3091 cp #7
    jr nz,lab309F
    ld a,(data39ec)
    xor #1
    ld (data39ec),a
    jr lab30B9
lab309F cp #6
    jr z,lab30BD
    cp #4
    jr nz,lab30AD
lab30A7 ld (ix+11),#1
    jr lab30BD
lab30AD cp #5
    jr z,lab30BD
    cp #a
    jr z,lab30A7
    cp #2
    jr c,lab30BD
lab30B9 ld (ix+11),#0
lab30BD ld hl,lab39CD
    ld (lab50D7+1),hl
    ld (lab5CFA+1),hl
    call lab3999
    call lab2D9F
    ld de,#C
    add ix,de
    ld hl,lab513C
    ld (lab5CF7+1),hl
    ld a,#5
    ld (lab5D09+1),a
    inc a
    ld (lab3059+1),a
lab30E0 ld (lab39B7+1),a
    inc a
    ld (lab3057+1),a
    inc a
    ld (lab39B5+1),a
    ld a,#c
    ld (lab5D4E+1),a
    ld (lab5D3E+1),a
    ld a,#1a
    ld (lab5D47+1),a
lab30F8 ld (lab5D38+1),a
    pop bc
    dec b
    jp nz,lab2C10
    xor a
    ld (lab2DE3),a
    ld a,(lab42D0)
    or a
    jr z,lab312B
    ld a,(lab4587)
lab310D inc a
    cp #16
    jr z,lab310D
    cp #18
    jr nz,lab3118
    ld a,#13
lab3118 ld (lab4587),a
    ld (lab4598),a
    ld (lab45A9),a
    ld a,#1
    ld hl,buf_mask+#0194
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a
lab312B
    ld hl,(#1A12)
    ld a,(hl)
    cp #ee
    jr nz,lab3160
    ld hl,buf_bg+#87
    ld de,buf_mask+#87
    ld b,#a
lab313B ld a,r
    and #3
    add a,#4f
    ld (hl),a
    inc hl
    inc hl
    ld a,#1
    ld (de),a
    inc de
    inc de
    ld (de),a
    ld a,r
    and #3
    add a,#52
    ld (hl),a
    push de
    ld de,#001E
    add hl,de
    pop de
    push hl
    ld hl,#001E
    add hl,de
    ex de,hl
    pop hl
    djnz lab313B
lab3160 ld a,(lab979A)
    or a
    jr z,lab316D
    dec a
    ld (lab979A),a
    jp lab320F
lab316D ld a,(Room_Y)
    cp #1f
    jp z,lab320F
    ld hl,(#1A12)
    ld a,(hl)
    cp #1d
    jr z,lab318E
    cp #23
    jr z,lab318E
    cp #22
    jr z,lab318E
    cp #26
    jr z,lab318E
    cp #2a
    jp nz,lab320F
lab318E call lab2F45
    and #3f
    inc a
    cp #5
    jr nc,lab31EF
    ld hl,lab349E
    ld de,7
lab319E add hl,de
    dec a
    jr nz,lab319E
    ld a,(hl)
    or a
    jr nz,lab31EF
    ld (hl),#e0
    inc hl
    ld (hl),#9
    inc hl
    ld (hl),#0
    inc hl
    ld de,#0120
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    call lab2F45
    and #7
    add a,a
    ld e,a
    ld d,#0
    ld ix,lab2DE8
    add ix,de
    ld a,(ix+0)
    ld (hl),a
    inc hl
    ld a,(ix+1)
    ld (hl),a
    call lab2F45
    and #1
    jr z,lab31EF
    ld a,(hl)
    xor #c
    ld (hl),a
    dec hl
    ld a,(hl)
    xor #c
    ld (hl),a
    dec hl
    ld d,(hl)

lab31E0 dec hl
lab31E1 ld e,(hl)
    push hl
    dec hl
    ld (hl),#1f
    ld hl,#001F
    add hl,de
    ex de,hl
    pop hl
    ld (hl),e
    inc hl
    ld (hl),d
lab31EF ld b,#4
    ld ix,lab34A5
    ld de,7
lab31F8 ld a,(ix+1)
    cp #8
    jr z,lab3203
    cp #a
    jr nz,lab320B
lab3203 ld a,(ix+5)
    xor #3
    ld (ix+5),a
lab320B add ix,de
    djnz lab31F8
lab320F ld a,#6
    ld ix,lab3497
lab3215 ld (data32b4),a
    ld a,(ix+0)
    or a
    jp z,lab32F7
    ld l,(ix+3)
    ld h,(ix+4)
    ld de,buf_mask
    add hl,de
    ld (hl),#1
    ld c,(ix+5)
    push bc
    ld b,#2
lab3231 bit 0,c
    call nz,lab3438
    bit 1,c
    call nz,lab345B
    bit 2,c
    call nz,lab346A
    bit 3,c
    call nz,lab3478
    ld l,(ix+3)
    ld h,(ix+4)
    ld de,buf_bg
    add hl,de
    ld a,(hl)
    cp #c7
    jr c,lab325C
lab3254 ld (ix+0),#0
    pop bc
    jp lab32F7
lab325C ld de,buf_bg+#080
    add hl,de
    ld a,(data32b4)
    cp #6
    jr nz,lab3272
    ld a,(hl)
    inc a
    jr z,lab3272
    ld a,#1
lab326D ld (lab2DE3),a
    jr lab3254
lab3272 ld de,BUFSIZE
    add hl,de
    ld a,(data32b4)
    cp #6
    jr nz,lab32B5
    ld a,(hl)
    inc a
    jr z,lab32B5
    ld a,#2
    jr lab326D
lab3285 ld a,#7
    push hl
    ld hl,lab513D
    ld (lab5CF7+1),hl
    pop hl
    ld (lab5D09+1),a
    inc a
    ld (lab3059+1),a
    ld (lab39B7+1),a
    ld a,#3
    ld (lab3057+1),a
    inc a
    ld (lab39B5+1),a
    ld a,#10
    ld (lab5D4E+1),a
    ld (lab5D3E+1),a
    ld a,#18
    ld (lab5D47+1),a
    ld (lab5D38+1),a
    xor a
    ret
data32b4 db #0
lab32B5 ld de,labFB80
    add hl,de
    ld a,(data32b4)
    cp #6
    jr z,lab32D6
    ld a,(hl)
    cp #e0
    jr nc,lab32D6
    ld b,#5
    call lab95C0
    call lab979B
    ld a,(ix+0)
    cp #e0
    jr c,lab3254
    jr lab32DD
lab32D6 ld c,(ix+6)
    dec b
    jp nz,lab3231
lab32DD pop bc
    ld l,(ix+3)
    ld h,(ix+4)
    ld de,buf_spr1
    add hl,de
    ld a,(ix+0)
    ld (hl),a
    xor #1			; masque
    ld (ix+0),a
    ld de,#F940
    add hl,de
    ld (hl),#1
lab32F7 ld de,7
    add ix,de
    ld a,(data32b4)
    dec a
    jp nz,lab3215
    ld a,(Room_Y)
    or a
    jr nz,lab332E
    ld d,a
    ld a,(lab39CB)
    add a,#30
    ld e,a
    ld hl,#006E
    add hl,de
    ld (lab3D08),hl
    ld a,#5
    ld (lab3D0A),a
    ld de,#3D0B
    ld bc,buf_fg
lab3322
    call lab3D37
    ld de,data4d88
    ld bc,buf_mask
    call lab3D37
lab332E ld a,(lab1CD0)
    or a
    jr z,lab3396
    ld ix,lab1CD0+1
    dec (ix+0)
    jr nz,lab3350
    call lab2F45
    ld (ix+0),a
    and #3
    jr nz,lab3357
    call lab2F45
    and #3
    add a,#4
    jr lab3364
lab3350 ld a,(ix+1)
    bit 2,a
    jr nz,lab3364
lab3357 call lab2F45
    and #3
    cp (ix+1)
    jr nz,lab3364
    inc a
    and #3
lab3364 ld (ix+1),a
    add a,a
    add a,a
    ld b,a
    add a,a
    add a,b     ; a=ax12
    ld l,a
    ld h,#0
    ld de,data1C70
    add hl,de
    ex de,hl
    ld hl,#06C5
    ld ix,#0485
    ld c,#3
lab337D ld b,#4
lab337F ld a,(de)
    ld (hl),a
    ld (ix+0),#1
    inc ix
    inc de
    inc hl
    djnz lab337F
    push de
    ld de,#001C
    add ix,de
    add hl,de
    pop de
    dec c
    jr nz,lab337D
lab3396 ld hl,(lab39CD)
    ld de,buf_fg-#880+#08E2
    add hl,de
    ld a,(hl)
    cp #8a
    ld a,#28
    jr nz,lab33A6
    ld a,#10
lab33A6 ld (#4D2A),a
    ld (#4D3B),a
    ld (#4D4C),a
    call lab4136
    ld a,(lab39D1)
    or a
    jr z,lab33CC
lab33B8 ld a,r
    and #7
    cp #1
    jr z,lab33B8
    cp #4
    jr z,lab33B8
    ld (lab4292+1),a
    ld b,#14
    call lab95C0
lab33CC ld a,(lab34C1)
    or a
    jr z,lab33EA
    ld a,(lab34C2)
    or a
    jr nz,lab33EA
    ld de,#509C
    ld a,#1
    ld (lab34C2),a
    ld hl,lab5B49
    ld (#39F4+1),de
    ld (lab2BB1+1),hl
lab33EA ld a,(lab34C1)
    cp #2
lab33EF
    jr z,lab3435
    ld hl,lab39CA
    dec (hl)
    jr nz,lab3435
    ld (hl),#14
    dec hl
    dec (hl)
    ld a,#2f
    cp (hl)
    jr nz,lab342A
    ld (hl),#39
    dec hl
    dec (hl)
    cp (hl)
    jr nz,lab342A
    ld (hl),#39
    dec hl
    dec (hl)
    ld a,(hl)
    cp #30
    jr nz,lab341F
    push af
    push hl
    ld de,#5066
    ld hl,txt_time_short
    ld c,#e
    call draw_text ; draw text?
    pop hl
    pop af
lab341F cp #2f
    jr nz,lab342A
    ld a,#2
    ld (lab34C1),a
    jr lab3435
lab342A ld de,#5096
    ld hl,data39c7
    ld c,#3
lab3432 call draw_text
lab3435 jp lab2B0D

lab3438 xor a
    cp (ix+1)
    jr z,lab3452
    dec (ix+1)
    ld de,#FFE0
lab3444 ld l,(ix+3)
    ld h,(ix+4)
    add hl,de
    ld (ix+3),l
    ld (ix+4),h
    ret
lab3452 ld (ix+0),#0
    pop de
    pop de
    jp lab32F7
lab345B ld a,#11
    cp (ix+1)
    jr z,lab3452
    inc (ix+1)
    ld de,#20
    jr lab3444
lab346A xor a
    cp (ix+2)
    jr z,lab3452
    dec (ix+2)
    ld de,#FFFF ; -1
    jr lab3444
lab3478 ld a,#1f
    cp (ix+2)
    jr z,lab3452
    inc (ix+2)
    ld de,1
    jr lab3444


txt_time_short: db "TIME IS SHORT "

assert $==#3495

lab3495 db #01
lab3496 db #00
lab3497 db #00
lab3498 db #00
lab3499 db #00
lab349a db #00,#00
lab349c db #00
lab349d db #00

lab349E
    db #00,#08,#19,#19,#01,#00,#00

lab34A5
    db #00,#08,#17,#17,#01,#00,#00
    db #00,#08,#17,#17,#01,#00,#00
    db #00,#08,#17,#17,#01,#00,#00
    db #00,#08,#17,#17,#01,#00,#00

lab34C1 db #0
lab34C2 db #0

lab34c3
    db #86,#0a,#19,#0a,#01,#19,#00,#1a,#05,#08,#00
    ;12*65
lab34CE
    db #00,#8b,#0a,#13,#0a,#01,#12,#0e,#15,#06,#08,#00
    db #00,#0b,#13,#12,#93,#01,#12,#11,#15,#06,#8c,#01
    db #01,#8b,#0a,#07,#0a,#01,#06,#0f,#08,#0f,#08,#00
    db #00,#8f,#0a,#06,#0a,#01,#04,#14,#07,#0f,#08,#00
    db #00,#1b,#0a,#04,#0a,#01,#03,#01,#0b,#0f,#88,#00
    db #00,#9b,#0a,#07,#0a,#01,#03,#02,#0a,#0f,#08,#00
    db #00,#88,#0a,#0e,#2a,#01,#0d,#05,#0f,#1b,#09,#00
    db #00,#88,#0a,#18,#2a,#01,#15,#0f,#19,#0f,#09,#00
    db #00,#12,#01,#11,#61,#01,#10,#03,#11,#17,#8b,#00
    db #01,#87,#0a,#18,#2a,#01,#17,#1a,#19,#18,#09,#00
    db #00,#07,#0a,#19,#2a,#01,#19,#02,#19,#19,#89,#00
    db #00,#09,#0a,#18,#4a,#01,#15,#1a,#19,#0e,#0a,#01
    db #01,#09,#0a,#18,#ca,#00,#15,#1a,#19,#0e,#86,#00
    db #00,#0a,#0a,#1a,#4a,#01,#18,#0e,#1b,#15,#8a,#00
    db #00,#07,#14,#17,#34,#00,#17,#0d,#18,#0e,#81,#00
    db #00,#83,#14,#0f,#34,#01,#0f,#0b,#10,#14,#09,#00
    db #00,#05,#14,#11,#34,#01,#10,#15,#11,#19,#09,#00
    db #00,#87,#14,#0f,#14,#01,#0f,#0f,#0f,#1a,#08,#00
    db #00,#82,#09,#0c,#09,#01,#0b,#10,#0c,#0c,#08,#00
    db #00,#02,#05,#0c,#05,#01,#0b,#10,#0c,#0c,#88,#00
    db #00,#8b,#14,#1c,#14,#01,#1c,#0e,#1c,#1c,#08,#00
    db #00,#84,#0a,#0e,#ea,#00,#0d,#12,#0f,#02,#07,#00
    db #00,#04,#0a,#0a,#2a,#01,#09,#0a,#0d,#0a,#89,#00
    db #00,#04,#0a,#0c,#2a,#01,#09,#0b,#0c,#18,#09,#00
    db #00,#0a,#0a,#08,#6a,#00,#08,#00,#0a,#19,#88,#00
    db #00,#0c,#06,#17,#e6,#00,#16,#16,#17,#1b,#07,#00
    db #00,#0c,#06,#17,#66,#01,#16,#16,#17,#1b,#8b,#00
    db #01,#0b,#06,#19,#66,#01,#18,#16,#1b,#19
db #0b,#00,#01,#0b,#06,#19,#e6,#00
db #18,#16,#1c,#06,#87,#00,#00,#09
db #06,#1b,#06,#01,#1a,#1a,#1b,#18
db #08,#00,#00,#0d,#06,#17,#86,#01
db #16,#10,#18,#1a,#0c,#00,#01,#8d
db #06,#17,#06,#01,#16,#10,#1a,#1a
db #88,#00,#00,#0d,#08,#1a,#08,#01
db #19,#01,#1d,#08,#08,#00,#00,#0d
db #06,#1c,#86,#01,#1b,#01,#1d,#08
db #8c,#00,#01,#8e,#06,#18,#06,#01
db #17,#10,#1c,#0b,#08,#00,#00,#0f
db #06,#1b,#06,#01,#1a,#11,#1d,#0b
db #08,#00,#00,#92,#09,#18,#09,#01
db #17,#11,#19,#1a,#08,#00,#00,#12
db #06,#18,#06,#01,#17,#11,#1d,#0c
db #88,#00,#00,#12,#06,#1b,#86,#01
db #1a,#01,#1d,#0c,#0c,#00,#01,#95
db #06,#18,#06,#01,#17,#10,#1a,#1a
db #08,#00,#00,#16,#06,#18,#06,#01
db #16,#14,#1b,#0b,#08,#00,#00,#16
db #06,#18,#86,#01,#16,#14,#1b,#0b
db #8c,#00,#01,#18,#06,#15,#86,#01
db #14,#11,#17,#1a,#0c,#00,#01,#18
db #06,#17,#06,#01,#16,#01,#18,#1a
db #88,#00,#00,#18,#06,#19,#86

db #1
db #18,#01,#1b,#1a,#0c,#00,#01,#99
db #06,#16,#06,#01,#15,#11,#18,#06
db #08,#00,#00,#9a,#06,#14,#06,#01
db #12,#10,#15,#0b,#08,#00,#00,#9b
db #06,#14,#06,#01,#13,#01,#17,#0b
db #08,#00,#00,#9b,#06,#1a,#06,#01
db #1a,#00,#1b,#0b,#08,#00,#00,#1d
db #06,#17,#06,#01,#15,#10,#1a,#08
db #08,#00,#00,#1d,#0a,#1d,#0a,#01
db #1c,#10,#1e,#1a,#88,#00,#00,#9e
db #06,#17,#06,#01,#12,#10,#1c,#0b
db #08,#00,#00,#1e,#0c,#17,#0c,#01
db #12,#10,#1c,#0b,#88,#00,#00,#0a
db #0a,#04,#0a,#01,#04,#03,#05,#15
db #08,#00,#00,#95,#06,#13,#06,#01
db #12,#00,#14,#0b,#08,#00,#00,#16
db #06,#14,#06,#01,#13,#10,#14,#0b
db #08,#00,#00,#92,#01,#11,#e1,#00
db #10,#03,#11,#17,#07,#00,#00,#1d
db #0a,#1f,#0a,#01,#1c,#0e,#20,#03
db #08,#00,#00,#1b,#0d,#02,#0d,#01
db #01,#0f,#02,#18,#88,#00,#00,#9b
db #0a,#02,#0a,#01,#01,#0f,#02,#18
db #08,#00,#00,#06,#0f,#05,#af,#00
db #05,#0a,#05,#14,#05,#00,#00,#89
db #0f,#04,#0f,#01,#04,#06,#04,#14
db #08,#00,#00,#0a,#0f,#04,#0f,#01
db #04,#01,#05,#14,#88,#00,#00,#0b
db #0f,#04,#2f,#00,#04,#01,#05,#07
db #01,#00,#00,#0b,#10,#04,#30,#01
db #04,#01,#04,#1a,#89,#00,#00,#0c
db #0f,#04,#2f,#00,#04,#01,#04,#14
db #01,#00,#00,#0c,#10,#04,#30,#01
db #04,#01,#04,#1a,#89,#00,#00,#0b
db #0a,#07,#8a,#01,#06,#0f,#08,#1b
db #8c,#00,#01,#0b,#0a,#0a,#2a,#00
db #0a,#01,#0a,#19,#01,#00,#00,#0b
db #0b,#0a,#2b,#00,#0a,#01,#0a,#19
db #81,#00,#00,#0a,#0a,#09,#6a,#00
db #08,#01,#0a,#14,#03,#00,#00,#09
db #0a,#09,#2a,#01,#08,#01,#0a,#14
db #09,#00,#00,#09,#0b,#09,#2b,#01
db #08,#01,#0a,#14,#89,#00,#00,#08
db #0a,#08,#2a,#01,#08,#01,#09,#04
db #09,#00,#00,#08,#0a,#0a,#2a,#01
db #09,#13,#0a,#14,#89,#00,#00,#07
db #0a,#08,#2a,#01,#08,#01,#08,#18
db #09,#00,#00,#07,#0a,#0a,#2a,#01
db #0a,#01,#0a,#18,#89,#00,#00,#09
db #0a,#0d,#0a,#01,#0c,#04,#11,#18
db #08,#00,#00,#0a,#0a,#11,#2a,#01
db #10,#14,#11,#18,#09,#00,#00,#0a
db #0a,#0f,#2a,#01,#0e,#14,#10,#09
db #89,#00,#00,#0a,#0a,#0d,#2a,#01
db #0c,#04,#0e,#09,#09,#00,#00,#0b
db #0a,#10,#0a,#01,#0c,#05,#11,#0b
db #08,#00,#00,#0b,#0a,#0e,#8a,#01
db #0c,#04,#10,#19,#8c,#00,#01,#0c
db #0a,#0e,#2a,#01,#0c,#04,#0f,#08
db #09,#00,#00,#0c,#0a,#10,#2a,#01
db #0f,#14,#11,#17,#89,#00,#00,#11
db #0a,#0c,#aa,#00,#0c,#05,#0e,#17
db #05,#01,#00,#0c,#0a,#09,#aa,#00
db #08,#06,#0a,#18,#05,#01,#00
lab38E3 db #d
db #0a,#09,#0a,#01,#07,#10,#0a,#18
db #08,#01,#00,#0e,#0a,#09,#aa,#00
db #08,#06,#0a,#18,#05,#01,#00,#0f
db #0a,#09,#0a,#01,#08,#01,#0a,#18
db #08,#01,#00,#10,#0a,#09,#aa,#00
db #08,#06,#0a,#18,#05,#01,#00,#11
db #0a,#09,#aa,#00,#08,#06,#0a,#18
db #05,#01,#00,#0d,#0a,#0e,#ea,#00
db #0c,#04,#10,#17,#07,#01,#00,#0d
db #0a,#11,#ea,#00,#10,#01,#11,#17
db #87,#01,#00,#0e,#0a,#0e,#ea,#00
db #0c,#04,#11,#17,#07,#01,#00,#0e
db #0a,#11,#ea,#00,#10,#01,#11,#17
db #87,#01,#00,#0f,#0a,#0d,#0a,#01
db #0b,#14,#0e,#18,#08,#01,#00,#0f
db #0a,#0d,#8a,#01,#0b,#14,#0e,#18
db #8c,#01,#01,#10,#0a,#0d,#aa,#00
db #0c,#04,#0e,#17,#05,#01,#00,#10
db #0a,#0c,#aa,#00,#0c,#05,#0e,#17
db #05,#01,#00

lab397F db #0
lab3980 db #0
lab3981 ld a,(lab397F)
    push af
    ld a,(data39ec)
    ld (lab397F),a
    jr lab39A3

lab398D ld a,(lab3980)
    push af
    ld a,(data39ec)
    ld (lab3980),a
    jr lab39A3
lab3999
    ld a,(ix+10)
    push af
    ld a,(data39ec)
    ld (ix+10),a
lab39A3
    pop af
    ld (data39ec),a
    ret

lab39A8 ld h,(ix+4)
    ld l,(ix+3)
    ld de,buf_mask
    add hl,de
    ld de,data4d88
lab39B5 ld b,#8
lab39B7 ld c,#6
    ld a,(ix+9)
    and #7f
    exx
    ld d,a
    exx
    ld a,(ix+1)
    jp lab50C6

; Compteur de temps affiché (ascii)
data39C7 db #39,#39,#39
; Compteur pour décrémenter le timer toutee les 20 trames
lab39CA db #a

lab39CB db #a
lab39CC db #a
lab39CD dw #014a

Room_Y: db #0 ; 39cf
Room_X: db #0 ; 39d0

lab39D1 db #0

lab39D2
    ld hl,(lab39CD)
    ld de,buf_mask
    add hl,de
    ld de,data4d88
    ld b,#8
    ld c,#6
    exx
lab39E1 ld a,(lab39CC)
    ld d,a
    exx
    ld a,(lab39CB)
    jp lab50C6

data39ec db #0


; Draw Sprite 6x7, position automif
lab39ED
    ld hl,(lab39CD)
    ld de,buf_spr1
    add hl,de
lab39F4
    ld de,#0    ; automodif
    ld b,#7
    ld c,#6
    exx
    ld a,(lab39CC)
    ld d,a
    exx
    ld a,(lab39CB)
    jp lab50C6

lab3A07 ld a,(#39ec)
    add a,a
    ld d,#0
    ld e,a
    dec de
    ld a,(lab39CB)
    add a,e
    ld (lab39CB),a
    ld hl,(lab39CD)
    add hl,de
    ld (lab39CD),hl
    ret
lab3A1E ld a,(#39ec)
    or a
    ld a,(lab39CB)
    jr z,lab3A2E
    cp #1d
    ret nz
    pop hl
    jp lab3C64
lab3A2E cp #fd
    ret nz
    pop hl
    jp lab3C82
lab3A35 call room_up
    call lab3A1E
    call lab3B82
    call lab3A07
    ld b,#4
    ld hl,lab5138
lab3A46 ld a,(hl)
    inc a
    cp #c8
    jr nc,lab3A67
    inc hl
    djnz lab3A46
    ld a,(lab39CC)
    dec a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
lab3A67 ld a,#4
lab3A69 ld (lab3C3B),a
    ld hl,lab3A82
    ld de,#4E00
    xor a
    ld (lab3A79),a
    jp lab5CDF

lab3A79 nop

; DATA
lab3A7A nop
    ld c,(hl)
    ld hl,#434e
    ld c,(hl)
    ld h,l
    ld c,(hl)

if  (TURBO_MODE & OPTIM_MINOR) == OPTIM_MINOR
lab3A82
    ld a,0
    inc a
    and #3
    ld (lab3A82+1),a
else

lab3A82 ld a,(lab3A79)
    inc a
    and #3
    ld (lab3A79),a
endif

    add a,a
    ld l,a
    ld h,#0
    ld de,lab3A7A
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (lab39F4+1),de
    jr lab3ABA

org #3a9c
lab3A9C
    ld hl,lab3AA5
    ld de,lab5048
    jp lab5CDF
lab3AA5 ld a,(lab513D)
    inc a
    jr z,lab3ABA
    ld de,buf_spr2+#20
    ld a,(#39ec)
    dec a
    jr nz,lab3AB7
    ld de,buf_spr2+#25
lab3AB7 call lab53A7
lab3ABA call lab3A1E
    call lab3B82
    call lab3A07
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
    ld (hl),#6
    ld hl,lab3AD2
    jp lab5CE3
lab3AD2 call lab5B1E
    call lab3A1E
    call lab3B82
    ld a,(lab5161)
    inc a
    cp #c8
    jp nc,lab5CE9
    call lab5199
    jp nz,lab5272
    call lab3A07
    ld a,(lab39CC)
    inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    ld hl,lab4FF4
lab3B01 ld (lab39F4+1),hl
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
    ld a,#19
lab3B0D ld (lab3C3B),a
    ld a,#1
    ld (lab5BB7+1),a
    ld (lab34C2),a
    ld de,#509C
    ld hl,lab3B22
    jp lab5CDF
lab3B21 nop
lab3B22 call lab5B1E
    call lab3A1E
    call lab5199
    jp nz,lab5BB7
    ld hl,lab5BB7+1
    inc (hl)
if  (TURBO_MODE & OPTIM_MINOR) == OPTIM_MINOR

old_lab3B21:
    ld a,0
    xor #1
    ld (old_lab3B21+1),a
else
    ld a,(lab3B21)
    xor #1
    ld (lab3B21),a
endif

lab3B3A jp z,lab3B4C
    call lab3B82
    ld a,(lab5161)
    inc a
    cp #c8
    jp nc,lab5CE9
    call lab3A07
lab3B4C ld a,(lab39CC)
    inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
lab3B64 ld de,#509C
    jp lab57E4

org #3B6A
lab3B6A ld b,#6
lab3B6C ld hl,lab513D
    ld de,#6
    ld c,#1
lab3B74 ld a,(hl)
    inc a
    cp #c8
    jr nc,lab3B7F
    add hl,de
    djnz lab3B74
    ld c,#0
lab3B7F dec c
    inc c
    ret
lab3B82 call lab3B6A
    ret z
    pop hl
    jr lab3B64
lab3B89 pop bc
    ld a,(lab5162)
    cp #7
    jr z,lab3BF5
    ld a,(lab5165)
    cp #7
    jr z,lab3BF5
    push bc
    ld b,#5
    call lab3B6C
    pop bc
    jp nz,lab5CE9
    ld a,(lab515B)
    inc a
    cp #c8
    jp c,lab3BBE
    ld hl,lab39CC
    dec (hl)
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
    call room_up
    jr lab3BF5
lab3BBE ld a,(lab5164)
    cp #c7
    jp nc,lab3BF5
    ld a,(lab5161)
    cp #c7
    jp nc,lab3BF5
    ld a,(lab39CC)
    inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    call lab5B1E
    push bc
    call lab8A58
    call lab39D2
    call lab8A6E
    call lab5199
    pop bc
    ld a,#5
    jp z,lab3B0D
lab3BF5 push bc
    ret
lab3BF7 call lab3A1E
    call lab3B89
    call lab3A07
lab3C00 call lab3DFB
    call lab3ECA+1
    bit 3,a
    jr z,lab3C2E
lab3C0A ld a,#1
    ld (lab34C2),a
    ld (lab5BB7+1),a
    ld a,#4
    ld (lab3C3B),a
    ld hl,lab3A35
    ld de,lab4FF4
    jp lab5CDF
lab3C20 ld a,#5
    ld (lab3C3B),a
    ld hl,lab3A9C
    ld de,lab4FF4
    jp lab5CDF
lab3C2E bit 4,a
    jp nz,lab3C20
    bit 0,a
    jp z,lab5CE9
lab3C38 jp lab2BB4
lab3C3B nop

lab3C3C
    ld a,#1e
    ld (Room_X),a
    ld a,#18
    ld (Room_Y),a
    ld a,#5
    ld (lab39CC),a
    ld a,#4
    ld (lab39CB),a
    ld hl,#00A4
    ld (lab39CD),hl
    ld hl,room_map2
    ld (room_map_index+1),hl
    ld a,#2
    ld (lab4292+1),a
    jp lab1987

room_right:
lab3C64
    ld hl,(room_map_index+1)
    ld a,(hl)
    cp #41
    jr z,lab3C3C
    ld hl,Room_X
    inc (hl)
    ld a,#fd
    ld (lab39CB),a
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld de,#1            ; Next room
    jp lab5B38

room_left:
lab3C82
    ld hl,Room_X
    dec (hl)
    ld a,#1d
    ld (lab39CB),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld de,#ffff         ; Previous Room
    jp lab5B38
lab3C98 call lab3A1E
    call lab3B89
    call lab3A07
    call lab3DFB
    ld hl,lab2096
    ld a,(hl)
    inc a
    jr z,lab3CF3
    inc a
    jr z,lab3CF3
    dec (hl)
    jp nz,lab2BB4
    ld b,#11
    ld de,lab3CD0
    ld hl,buf_fg+#0987-#880
    call lab43C3
    ld b,#12
    ld de,lab3CE1
    ld hl,buf_fg+#09E7-#880
    call lab43C3
    ld a,#c8
    ld (lab2096),a
    jp lab5CE9

assert $==#3cd0
lab3cd0 db "@EXCELLENT@VALUE@"
lab3ce1 db "@YOU@HAVE@ESCAPED@"

lab3CF3
    call lab3ECA+1
    bit 3,a
    jp nz,lab3C0A
    bit 4,a
    jp nz,lab3C20
    bit 1,a
    jp z,lab5CE9
    jp lab2BB4

lab3d08
	db #00,#00
lab3d0a
	db #00

lab3d0b
db #ff
db #ff,#ff,#ff,#45,#46,#47,#48,#49 ;...EFGHI
db #4a,#ff,#4b,#4c,#4d,#4e,#4f,#50 ;J.KLMNOP
db #51,#52,#53,#ff,#ff,#54,#55,#56 ;QRS..TUV
db #57,#58,#59,#5a,#5b,#5c,#5d,#ff ;WXYZ....
db #ff,#ff,#ff,#5e,#5f,#ff,#60,#61 ;.......a
db #ff,#ff,#ff

lab3D37 ld hl,lab3D08
    ld (lab50D7+1),hl
    ld hl,(lab3D08)
    add hl,bc
    ld b,#4
    ld c,#b
    exx
    ld a,(lab3D0A)
    ld d,a
    exx
    ld a,(lab39CB)
    sub #2
    call lab50C6
lab3d53:
    ld hl,lab39CD
    ld (lab50D7+1),hl
    ret
lab3d5a:
    ld hl,lab2098
    ld (lab50D7+1),hl
    ld hl,(lab39CD)
    push de
    ld de,#40-2
    add hl,de
    pop de
    ld (lab2098),hl
    add hl,bc
    ld b,#5
    ld c,#b
    exx
    ld d,#a
    exx
    ld a,(lab39CB)
    sub #2
    call lab50C6
    jr lab3D53

/*db #21,#98 ;....P...
db #20,#22,#d8,#50,#2a,#cd,#39,#d5 ;...P....
db #11,#3e,#00,#19,#d1,#22,#98,#20
db #09,#06,#05,#0e,#0b,#d9,#16,#0a
db #d9,#3a,#cb,#39,#d6,#02,#cd,#c6
db #50,#18,#d4 ;P..*/
lab3D7F
/*db #3a
db #cb,#39,#fe,#fd,#ca,#82,#3c,#cd
db #07,#3a,#cd,#cb,#3e,#cb,#67,#c2 ;......g.
db #99,#3d,#21,#3b,#3c,#35,#c2,#b4
db #2b,#3e,#01,#c3,#69,#3a,#00,#3a ;....i...
db #cb,#39,#fe,#fd,#ca,#82,#3c,#cd
db #07,#3a,#3a,#9e,#3d,#ee,#01,#32
db #9e,#3d,#20,#eb,#11,#d1,#20,#01
db #80,#08,#cd,#5a,#3d,#11,#88,#4d ;...Z...M
db #01,#00,#04,#cd,#5a,#3d,#21,#3b ;....Z...
db #3c,#35,#c2,#b4,#2b,#11,#9a,#20
db #01,#80,#08,#cd,#5a,#3d,#3e,#10 ;....Z...
db #32,#96,#20,#c3,#e9,#5c,#3a,#cc
db #39,#fe,#f9,#c0,#21,#cf,#39,#35
db #e1,#c6,#12,#32,#cc,#39,#2a,#cd
db #39,#11,#40,#02,#19,#11,#e0,#ff
db #c3,#38,#5b,#3a,#13,#4f,#ee,#9b ;.....O..
db #32,#13,#4f,#2a,#3d,#3e,#11,#12 ;..O.....
db #00,#19,#22,#3d,#3e,#3a,#48,#3e ;......H.
db #3c,#fe,#04,#20,#24,#21,#2e,#4f ;.......O
db #22,#3d,#3e,#0e,#01,#3a,#63,#51 ;......cQ
db #fe,#fe,#28,#09,#3a,#63,#51,#fe ;.....cQ.
db #fe,#28,#02,#0e,#02,#3a,#ea,#93
db #fe,#20,#20,#04,#79,#32,#78,#3e ;....y.x.
db #af,#32,#48,#3e,#21,#00,#00,#11 ;..H.....
db #1c,#4f
*/
ld a,(lab39CB)
    cp #fd
    jp z,lab3C82
    call lab3A07
    call lab3ECA+1
    bit 4,a
    jp nz,lab3D99
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
lab3D99 ld a,#1
    jp lab3A69
lab3D9E nop
lab3D9F ld a,(lab39CB)
    cp #fd
    jp z,lab3C82
    call lab3A07
    ld a,(lab3D9E)
    xor #1
    ld (lab3D9E),a
    jr nz,lab3D9F
    ld de,spr_11_5_20d1
    ld bc,buf_fg
    call lab3D5A
    ld de,data4D88
    ld bc,buf_mask
    call lab3D5A
    ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
    ld de,spr_11_5_209a
    ld bc,buf_fg
    call lab3D5A
    ld a,#10
    ld (lab2096),a
    jp lab5CE9

room_up:
;lab3DDE
    ld a,(lab39CC)
    cp #f9
    ret nz
    ld hl,Room_Y
    dec (hl)
    pop hl
    add a,#12
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,BUFSIZE
    add hl,de
    ld de,#ffe0         ; -32
    jp lab5B38
lab3DFB
    ld a,(lab4F13)
    xor #9b
lab3E00
    ld (lab4F13),a
    ld hl,(lab3E3C+1)
    ld de,#12
    add hl,de
    ld (lab3E3C+1),hl
    ld a,(lab3E48)
    inc a
    cp #4
    jr nz,lab3E39
    ld hl,lab4F2E
    ld (lab3E3C+1),hl
    ld c,#1
    ld a,(lab5163)
    cp #fe
    jr z,lab3E2D
    ld a,(lab5163)
    cp #fe
    jr z,lab3E2D
    ld c,#2
lab3E2D ld a,(lab93EA)
    cp #20
    jr nz,lab3E38
    ld a,c
    ld (lab3E78),a
lab3E38 xor a
lab3E39 ld (lab3E48),a
lab3E3C ld hl,#0
    ld de,lab4F1C


lab3E42
    ld bc,#0012
    ldir
    ret


db #00
lab3E49 db #2
lab3E4A db #0
lab3E4B db #0
db #00



lab3E4D:
if  (TURBO_MODE & OPTIM_FAST_INT38) == OPTIM_FAST_INT38
    ld c,a
    ld b,#f4
    out (c),d
    ld b,#f6
    in a,(c)
    or #c0
    out (c),a
    and #3f
    out (c),a
    ld b,#f4
    out (c),c
    ld b,#f6
    ld c,a
    or #80
    out (c),a
    out (c),c

else
	di 			;  called from Interuption...
    push af		; no need to keep af, de,
    push bc
    push de  ; no need to change e
    push hl  ; ?? not modified
    ld e,a
    ld c,e   ; c=e
    ld a,d   ; not needed
    ld b,#f4
    out (c),a ; out(c),d
    ld b,#f6
    in a,(c)
    or #c0
    out (c),a
    and #3f
    out (c),a
    ld b,#f4
    out (c),c
    ld b,#f6
    ld c,a
    or #80
    out (c),a
    out (c),c
    pop hl
    pop de
    pop bc
    pop af
    ei

endif
    ret

org #3e78
lab3E78: db #00
lab3e79: db #00

; check direction keys
lab3E7A ld hl,lab3EAD
    ld bc,#0500
lab3E80
    push bc
    ld e,(hl)
    ld d,#0
    ld bc,key_state
    ex de,hl
    add hl,bc
    ex de,hl
    pop bc
    ld a,(de)
    inc hl
    and (hl)
    jr z,lab3E91
    scf
lab3E91 rl c
    inc hl
    djnz lab3E80

    ld a,c
    rra
    jr nc,lab3E9C
    or #10
lab3E9C ld (curDirKey),a
    ld a,(key_state+8)
    and 4
    ret z
    ld a,1
    ld (lab34C1),a
    xor a
    ret

; Current direction key
lab3EAC
curDirKey: db #0

lab3EAD db #8
db #20,#08,#80,#05,#40,#04,#40,#05
db #80
lab3EB7 db #8
db #20,#08,#80,#05,#40,#04,#40,#05
db #80
lab3EC1 db #9
lab3EC2 db #01,#09,#02,#09,#04,#09
lab3Ec8 db #08,#09
lab3Eca db #10,#3a,#ac,#3e,#c9,#00,#fd,#01
db #08,#fe,#02,#04,#7f,#08,#02,#7f
db #04,#01,#7f,#01,#10,#00

game_over:
lab3EE0: db #1 ; Game Over?
		 db #04 ; INT Counter (same as 3f01)

; Palette for each interrupt
halt_palettes:
lab3EE2:
	db #44,#4c,#53,#54
lab3EE6:
    db #44,#4c,#52,#54
lab3EEa:
    db #44,#4c,#52,#54
lab3EEe:
    db #44,#4c,#52,#54
    db #55,#4c,#4a,#54
    db #55,#4d,#4c,#54

; ??
    db #00,#00,#00,#00
    db #00,#00
;3f00
    db #00

assert $==#3f01

lab3F01:

int_counter:
	db #01

if (TURBO_MODE & OPTIM_FAST_INT38) == OPTIM_FAST_INT38

int_manager:
    di
    push af
    push bc
    push de
    push hl


    ld hl,int_counter
	ld a,(hl)
    inc a
    cp 6
    jr nz,.noraz
    xor a
.noraz
    ld (hl),a

if DEBUG_INT38==1
	add a,a
    add a,#46
    ld bc,#7F10
    out (c),c
    out (c),a
endif

    ; check vbl, and reset counter if VBL
	; could be avoided by a correct initial synchro
    ; require a tempo
    ld b,#F5		; ld b,#f5
    in a,(c)
    rra
    jr nc,.novbl
    xor a
    ld (hl),a

.novbl:
    ld a,(hl)
    or a
    jr nz,lab3F92

.HALT0:
    ; read kb
    call read_Keyboard

    ld a,(musicOnOff)
    or a
	jr z,.sfx

.music:
    push ix
    exx
    push af
    push bc
    push de
    push hl
    ex af,af''
    push af
    call labB0C8
    pop af
    ex af,af''
    pop hl
    pop de
    pop bc
    pop af
    exx
    pop ix
    jp int_end

.sfx:
    ; Sound FX
    ld a,(lab3e78)
    dec a
    jp m,lab3F83
    ld (lab3e78),a

    ld d,#7
    ld a,#37
    call lab3E4D
    ld d,#8
    ld a,(lab3E79)
    inc a
    inc a
    cp #10
    jr c,lab3F73
    ld a,#f
lab3F73
    ld (lab3E79),a
    call lab3E4D
    ld d,#6
    ld a,#ff
    call lab3E4D
    jp int_end
lab3F83 ld d,#7
    ld a,#3f
    call lab3E4D
    ld a,#7
    ld (lab3E79),a
    jp int_end

    ; Set Palette (HUB/Main screen)
lab3F92
    ld a,(game_over)
    rra
    jr c,int_end

    ; set color
    ;ld a,(hl)
    ld a,(int_counter)
	add a,a
    add a,a
    ld l,a
    ld h,#0

    ld de,halt_palettes
    add hl,de
    ld bc,#7F00
    ld a,(hl)
    out (c),c ; outi?
    ;or #40
    out (c),a
    inc l
    inc c
    ld a,(hl)
    out (c),c
    ;or #40
    out (c),a
    inc l
    inc c
    ld a,(hl)
    out (c),c
    ;or #40
    out (c),a
    inc l
    inc c
    ld a,(hl)
    ;or #40
    out (c),c
    out (c),a
int_end:

if DEBUG_INT38==1
	; Debug Timing
	ld bc,#7F10
    out (c),c
    ld a,#54
    out (c),a
endif

    pop hl
    pop de
    pop bc
    pop af
    ei
    ret
else

; --- Original routine
int_manager:
    di
    push af
    push bc
    push de
    push hl

	ld a,(int_counter)				; #3ee1 is also a counter
    inc a
    cp 6
    jr nz,lab3F10
    xor a

lab3F10 ld (int_counter),a
	add a,a
    add a,#46
	or #40
if DEBUG_INT38==0
    ld a,#54
endif
    ld bc,#7F10
    out (c),c
    out (c),a

	; !!!!!!
    ld a,(game_over)		; ??
    xor a				; ?? Automodifie? apparemment non
    jp c,int_end

    ld hl,lab3EE0+1
    inc (hl)

    ; VBL?
    ; need a tempo...

    ld b,#F5		; ld b,#f5
    in a,(c)
    rra
    jp nc,lab3F92

    ld (hl),0

	; Play Music
    ; Test if music on/off here before?
	push ix
    exx
    push af
    push bc
    push de
    push hl
    ex af,af''
    push af

    call labB003

    pop af
    ex af,af''
    pop hl
    pop de
    pop bc
    pop af
    exx
    pop ix

    call read_Keyboard

    ld a,(#93E9+1) ; test TUNE ON / OFF .... !!!???!!!
    cp #20		   ; There''s a flag... testing TEXT!!?!
    jp nz,int_end


    ; Sound FX
    ld a,(lab3e78)
    dec a
    jp m,lab3F83
    ld (lab3e78),a

    ld d,#7
    ld a,#37
    call lab3E4D
    ld d,#8
    ld a,(lab3E79)
    inc a
    inc a
    cp #10
    jr c,lab3F73
    ld a,#f
lab3F73
    ld (lab3E79),a
    call lab3E4D
    ld d,#6
    ld a,#ff
    call lab3E4D
    jp int_end

lab3F83 ld d,#7
    ld a,#3f
    call lab3E4D
    ld a,#7
    ld (lab3E79),a
    jp int_end

    ; Set Palette (HUB/Main screen)
lab3F92
    ld a,(game_over)
    rra
    jp c,int_end

    ; set color
    ld a,(hl)
    add a,a
    add a,a
    ld l,a
    ld h,#0

    ld de,halt_palettes
    add hl,de
    ld bc,#7F00
    ld a,(hl)
    out (c),c ; outi...
    or #40    ; optim
    out (c),a
    inc hl		; inc l
    inc c
    ld a,(hl)
    or #40    ; optim
    out (c),c
    out (c),a
    inc hl 		; inc l
    inc c
    ld a,(hl)
    or #40    ; optim
    out (c),c
    out (c),a
    inc hl	 ; inc l
    inc c
    ld a,(hl)
    or #40     ; optim
    out (c),c
    out (c),a
lab3FC8
int_end:


if DEBUG_INT38==1
	; Debug Timing
	ld bc,#7F10
    out (c),c
    ld a,#54
    out (c),a
endif

    pop hl
    pop de
    pop bc
    pop af
    ei
    ret

endif


;org #3fcf


org #3fe5
; Lecture clavier
read_Keyboard:
lab3FE5
	push af
    push bc
    push hl
    ld hl,key_state
    ld bc,#F40E
    out (c),c
    ld b,#f6
    in a,(c)
    and #30
    ld c,a
    or #c0
    out (c),a
    out (c),c
    inc b
    ld a,#92
    out (c),a
    push bc
    set 6,c
lab4005
	ld b,#f6
lab4007
	out (c),c
    ld b,#f4
    in a,(c)
    cpl
    ld (hl),a
    inc hl
    inc c
    ld a,c
lab4012
	and #f
    cp 10			; 10 Keyboard lines
    jr nz,lab4005
    pop bc
    ld a,#82
    out (c),a
    dec b
    out (c),c
    pop hl
    pop bc
    pop af
lab4023 ret

; Keys State
key_state ds 10,0

; Check Key State
lab402E push bc
    push hl
    ld hl,key_state+9
    ld b,#a
lab4035 ld a,(hl)
    or a
    jr nz,lab4040
    dec hl
    djnz lab4035
    xor a
    ld c,a
    jr lab4071
lab4040
    ld c,a
    dec b
    ld a,b
    add a,a
lab4044 add a,a
    add a,a
lab4046 inc a
    rr c
    jr nc,lab4046
    dec a
lab404C ld hl,lab407B
    ld c,a
    ld b,#0
    add hl,bc
    ld c,(hl)
    ld a,(lab407A)
    cp c
    jr nz,lab406A
    cp #d
    jr z,lab4071
    ld hl,(data4078)
    dec hl
lab4062 ld (data4078),hl
    ld a,h
    or l
    ld a,c
    jr nz,lab4071
lab406A ld hl,32
    ld (data4078),hl
    scf
lab4071 ld a,c
    ld (lab407A),a
    pop hl
    pop bc
    ret

data4078 db #0
db #00
lab407A db #0
lab407B db #89
db #8e,#8a,#39,#36,#33,#0d,#2e
lab4083 db #8b
lab4084 db #88
db #37,#38
lab4087 db #35
db #31,#32,#30,#0c,#5b,#0d,#5d,#34
db #8d,#5c,#80,#5e,#2d,#40,#50,#3b ;......P.
db #3a,#2f,#2e,#30,#39,#4f,#49,#4c ;.....OIL
lab40A0 db #4b
lab40A1 db #4d
db #2c,#38,#37,#55,#59,#48,#4a,#4e ;...UYHJN
db #20,#36,#35,#52,#54,#47,#46,#42 ;...RTGFB
db #56,#34,#33,#45,#57,#53,#44,#43 ;V..EWSDC
db #58,#31,#32,#fc,#51 ;X...Q
lab40BF db #9
db #41 ;A
lab40C1 db #8c
db #5a ;Z
lab40C3 db #81
db #82,#83
lab40C6 db #84
db #85,#87,#88,#7f
lab40CB call lab402E
    jr nc,lab40CB
    ret

; Check if a Key is pressed, and Set C accordingly
lab40D1
	call lab402E
    or a
    ret z
    scf
    ret

data40d8 db #f5
db #c5,#d5,#e5,#f6,#8c,#06,#7f,#ed
db #79,#cd ;y.
lab40E3 db #cf
db #3f,#e1,#d1
lab40E7 db #c1
db #f1,#c9,#f5,#c5,#d5,#e5,#01,#10
db #7f,#f6,#40,#f3,#ed,#49,#ed,#79 ;.....I.y
db #fb,#e1,#d1,#c1,#f1,#c9

; Set Palette for Menu
setMenuPal:
    ld hl,lab4112+3
    jr setPalette

; Set palette for ??
setXXXPal:
data4103 ld hl,lab4116+3

; Set Palette
; HL = Palette ptr
setPalette:
	ld b,#4
lab4108
    ld a,b
    dec a
    ld e,(hl)
    call setInk
    dec hl
    djnz lab4108
    ret

; palettes, stored in reverse order
lab4112 db #44,#4a,#4c,#54
lab4116 db #54,#5b,#4c,#54

; Set Ink
; a: ink
; e: col (ga)
setInk:
;lab411A
    push af
    push bc
    push hl ; ?? HL not modified
    and #1f
    ld b,#7f
    di
    out (c),a

    ld a,e
    or #40  ; could be stored directly in data
    out (c),a

    ei
    pop hl
    pop bc
    pop af
    ret

data412e db #14,#04,#1c,#18
         db #16,#06,#1e,#00

; Render
Render:
lab4136
    ld hl,lab3E49
    ld a,(hl)
    xor #4
    ld (hl),a
    inc hl
    ld (hl),#0

    ; Init Buffer Pointers
    ld hl,buf_fg
    ld (ptr0880),hl
    ld hl,buf_spr1
    ld (ptr0ac0),hl
    ld hl,buf_spr2
    ld (ptr0d00),hl
    ld hl,buf_spr3
    ld (ptr0f40),hl

if (TURBO_MODE & OPTIM_USE_IY_INSTEAD_IX) == OPTIM_USE_IY_INSTEAD_IX
    ld iy,lab1545
endif

    ld hl,buf_bg
    ld de,buf_mask
    exx
    ld hl,SCREEN
    exx
    ld ix,buf_mask
    ld b,#12
lab4169 ld c,#20
lab416B push bc
    push hl
    push de
    exx
    push hl
    exx
    ld a,(ix+0)
    or a
    jp z,lab4375
    ld a,(hl)
    ld (lab4400),a
    ld h,0
    ld l,a

if (TURBO_MODE & OPTIM_LD_INSTEAD_PUSHPOP) == OPTIM_LD_INSTEAD_PUSHPOP
    ld d,h
    ld e,l
else
	push hl ; WOT?
    pop de
endif

; Draw Tile
lab4181
	add hl,hl ; x9
    add hl,hl
    add hl,hl
    add hl,de
    ld de,background_tiles
    add hl,de

    ld de,render_tile_buffer ; lab43F7
	repeat 9
	  ldi
	rend

    xor a
    ld (lab3E4A),a

if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
bufptr0d00:
    ld a,(ptr0d00)
    ;nop ; to remove
else
    ld hl,(ptr0d00)
    ld a,(hl)
endif

    ld l,a
    inc a
    jr z,lab41F8
    ld b,#0
    cp #a4
    jr c,lab41BB
    cp #a7
    jr nc,lab41BB

    ld a,(lab3E49) ; ??
    ld (lab3E4A),a ; ??

    ld b,a

lab41BB
    ld a,(lab43FF)
    and #f8
    or b
    ld (lab43FF),a

    ld h,#0         ;*8
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,lab7970 ; Sprites des ennemis
    add hl,de

    ld de,render_tile_buffer ;lab43F7
    ld b,#8
    call lab3981
lab41D5
    ld a,(de)
    ld c,a
    ld a,(hl)
    ld (lab41E1+2),a ; Change index

if (TURBO_MODE & OPTIM_USE_IY_INSTEAD_IX) == OPTIM_USE_IY_INSTEAD_IX
	;nop	; to remove
    ;nop
lab41E1
    ld a,(iy+0) 	 ;  Automodif
    ;nop ; to remove
    ;nop
else
	push ix			 ; iy is never used...
    ld ix,lab1545
lab41E1
    ld a,(ix+0) 	 ;  Automodif
    pop ix
endif

	call lab43D7
    and c
    ld c,a
    ld a,(hl)
    call lab43D7
    or c
    ld (de),a
    inc hl

if (TURBO_MODE & OPTIM_INC_8_INSTEAD_INC16) == OPTIM_INC_8_INSTEAD_INC16
	inc e
else
    inc de
endif

	djnz lab41D5
    call lab3981
lab41F8
if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
bufptr0f40:
    ld a,(ptr0f40)
    ;nop ; to remove
else
    ld hl,(ptr0f40)
    ld a,(hl)
endif

    ld l,a
    inc a
    jr z,lab423C

    ld a,(lab43FF)
    and #f8
    ld (lab43FF),a
    ld h,#0
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,lab7970 ; Sprites des ennemis
    add hl,de
    ld de,render_tile_buffer; lab43F7

    ld b,#8
    call lab398D
lab4219 ld a,(de)
    ld c,a
    ld a,(hl)
    ld (lab4225+2),a

if (TURBO_MODE & OPTIM_USE_IY_INSTEAD_IX) == OPTIM_USE_IY_INSTEAD_IX
	;nop	; to remove
    ;nop
    ld iy,lab1545 ; to remove
lab4225 ld a,(iy+0)
	;nop
    ;nop
else
    push ix
    ld ix,lab1545
lab4225 ld a,(ix+0)
    pop ix
endif


    call lab43D7
    and c
    ld c,a
    ld a,(hl)
    call lab43D7
    or c
    ld (de),a
    inc hl
    inc de
    djnz lab4219

    call lab398D
lab423C ld a,(lab4292+1)
    ld (lab3E4B),a

if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
bufptr0AC0:
    ld a,(ptr0AC0)
    ;nop ; to remove
else
    ld hl,(ptr0Ac0)
    ld a,(hl)

endif

    ld l,a
    inc a
    jp z,lab42CB
    cp #e1
    jr nc,lab4268
    cp #d3
    jr c,lab4268
    cp #d7
    jr c,lab425B
    cp #db
    jr c,lab4268

lab425B
    ld a,(lab4400)
    dec a
    jr nz,lab4268
    ld a,#7
    ld (lab4292+1),a
    jr lab428D

org #4268
lab4268 ld a,(lab4400)
    cp #4f
    jr c,lab427E
    cp #56
    jr nc,lab427E
    ld a,(lab95C0+1)
    or a
    jr z,lab427E
    ld a,#1
    ld (lab39D1),a

lab427E ld a,(lab3E4A) ; WHAT???
    or a
    jr z,lab428D
    push hl
    ld b,#3
    call lab95C0   ; ?????? Drawing life why herE?

    pop hl
    jr lab4297

org #428D
lab428D ld a,(lab43FF)
    and #f8
lab4292 or #0
    ld (lab43FF),a
lab4297
    ld a,(lab3E4B)
    ld (lab4292+1),a
    ld h,0
    add hl,hl ; *8
    add hl,hl
    add hl,hl
    ld de,lab9D00
    add hl,de
    ld de,render_tile_buffer ;lab43F7
    ld b,8
lab42AB
    ld a,(de)
    ld c,a
    ld a,(hl)
    ld (lab42B7+2),a

if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
;ds 8

;	nop	; to remove
;    nop
;    ld iy,lab1545    ; could be iniatilized once, outside the loop
lab42B7
    ld a,(iy+0) 	 ;  Automodif
;    nop ; to remove
;    nop
else
    push ix
    ld ix,lab1545
lab42B7
    ld a,(ix+0)
    pop ix
endif

    call lab43D7
    and c
    ld c,a
    ld a,(hl)
    call lab43D7
    or c
    inc hl
    ld (de),a
    inc de
    djnz lab42AB

    ; Foreground

lab42CB ld hl,lab43FF
    ld a,#10
;assert $==#42D0
lab42D0 nop
if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
bufptr0880:
    ld a,(ptr0880)
;    nop ; to remove
else
    ld hl,(ptr0880)
    ld a,(hl)
endif
    ld l,a
    inc a
    jr z,lab42FF
    ld h,#0
    push hl
    add hl,hl
    add hl,hl
    add hl,hl
    cp #e5
    jp nc,lab43A6
    add hl,hl ;x16
    pop de
    add hl,de
    ld de,lab4401
    add hl,de

    ld de,render_tile_buffer ;lab43F7 : TODO: Aligner, optimiser
    ld b,#8
lab42F0
    ld a,(de)
    and (hl)
    inc hl
    or (hl)
    inc hl          ; inc l si de (=4401) impair
    ld (de),a

if (TURBO_MODE & OPTIM_INC_8_INSTEAD_INC16) == OPTIM_INC_8_INSTEAD_INC16
    inc e
else
    inc de
endif
    djnz lab42F0

    ld a,(hl)
    cp #ff
    jr z,lab42FF
    ld (de),a

lab42FF ld a,(lab43FF)
    and #7
    jr z,lab4311
    cp #2
    jr z,lab4313
    dec a
    jr z,lab4313
    ld a,#1
    jr lab4313
lab4311 ld a,#3
lab4313 ld c,a
    xor a
    rr c
    jr nc,lab431B
    or #f
lab431B rr c
    jr nc,lab4321
    or #f0
lab4321 exx
    ld c,a
    exx
    ld a,(lab43FF)
    rrca
    rrca
    rrca
    and #7
    jr z,lab4339
    cp #2
    jr z,lab433B
    dec a
    jr z,lab433B
    ld a,#1
    jr lab433B
lab4339 ld a,#3
lab433B ld c,a
    xor a
    rr c
    jr nc,lab4343
    or #f
lab4343 rr c
    jr nc,lab4349
    or #f0
lab4349 exx
    ld b,a
    exx

    ld b,8
    ld hl,render_tile_buffer ; lab43F7 ; Buffer de  rendu
lab4351 ld a,(hl)
    exx
    ld d,#ce
    ld e,a

    ld a,(de)	; how to optimise? ld a,(de) twice
    push hl     ; push hl for keeping l ...
    and c
    ld l,a
    ld a,(de)
    cpl
    and b
    or l
    pop hl
    ld (hl),a

    inc d
    inc l

    ld a,(de)
    push hl
    and c
    ld l,a
    ld a,(de)
    cpl
    and b
    or l
    pop hl
    ld (hl),a

    dec l
    ld a,h
    add a,8
    ld h,a
    exx

if (TURBO_MODE & OPTIM_INC_8_INSTEAD_INC16) == OPTIM_INC_8_INSTEAD_INC16
    inc L
else
	inc hl
endif
    djnz lab4351

lab4375 exx
    pop hl
    inc hl
    inc hl
    exx

    ; increment buffer pointers oO
if (TURBO_MODE & OPTIM_FAST_BUFFERS) == OPTIM_FAST_BUFFERS
    ld hl,(ptr0880)
    inc hl
    ld (ptr0880),hl
    ld bc,BUFSIZE
    add hl,bc
    ld (ptr0AC0),hl
    add hl,bc
    ld (ptr0D00),hl
    add hl,bc
    ld (ptr0F40),hl
else
    ld hl,(ptr0880)
    inc hl
    ld (ptr0880),hl
    ld hl,(ptr0AC0)
    inc hl
    ld (ptr0AC0),hl

    ld hl,(ptr0D00)
    inc hl
    ld (ptr0D00),hl
    ld hl,(ptr0F40)
    inc hl
    ld (ptr0F40),hl
endif
    pop de
    pop hl
    pop bc

    inc de
    inc hl
    inc ix
    dec c
    jp nz,lab416B
    dec b
    jp nz,lab4169
    ret



org #43a6
lab43A6
    pop de
    ld de,lab91A5
    add hl,de
    cp #e5
    jr nz,lab43B2
    ; a=#e5 => fonte
    ld hl,font32

lab43B2 ld de,render_tile_buffer ;lab43F7
if (TURBO_MODE & OPTIM_LDIR_INSTEAD_LOOP) == OPTIM_LDIR_INSTEAD_LOOP
	;repeat 8
    ;LDI
    ;rend
    ld bc,7
    ldir
    ;nop
    ldi
else
	ld b,#8
lab43B7:
     ld a,(hl)
    ld (de),a
    inc de
    inc hl
    djnz lab43B7

endif
    ld a,#14
    ld (de),a
    jp lab42FF

org #43c3
lab43C3
    ld c,b
lab43C4
    ld a,(de)
    add a,#a4
    ld (hl),a
    inc de
    inc hl
    djnz lab43C4

	ld de,labFB80
    add hl,de
lab43D0 dec hl
    ld (hl),#1
    dec c
    jr nz,lab43D0
    ret

lab43D7 push bc
    ld b,a
    ld a,(data39ec)
    or a
    ld a,b
    pop bc
    ret z
    ld (lab43E9+2),a
    push ix
    ld ix,labC680
lab43E9 ld a,(ix+0)
    pop ix
    ret


org #43ef

data43ef dw #0
data43F1 dw #0
data43F3 dw #0
data43F5 dw #0

; TODO: aligner sur 8
render_tile_buffer:
lab43F7 ds 8,0

lab43FF db #2
lab4400 db #0

;table 16x
;Masque And(hl), Masque Or(hl)
lab4401 db #15
db #ea,#00,#bf,#00,#fb,#20,#df,#42 ;.......B
db #b5,#00,#ff,#08,#b7,#08,#f7,#21
db #00,#ff,#00,#81,#00,#81,#00,#81
db #00,#81,#00,#81,#00,#81,#00,#81
db #30,#00,#ff,#00,#d8,#00,#a8,#00
db #d8,#00,#ff,#00,#8a,#00,#8a,#00
db #8a,#10,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#ff,#00,#aa,#00,#aa
db #00,#aa,#10,#00,#ff,#00,#15,#00
db #1b,#00,#15,#00,#ff,#00,#b1,#00
db #b1,#00,#b1,#10,#00,#8a,#00,#8a
db #00,#8f,#00,#a8,#00,#a8,#00,#88
db #00,#8f,#00,#8a,#10,#00,#aa,#00
db #aa,#00,#ff,#00,#00,#00,#00,#00
db #00,#00,#ff,#00,#aa,#10,#00,#b1
db #00,#b1,#00,#f1,#00,#15,#00,#15
db #00,#11,#00,#f1,#00,#b1,#10,#00
db #8a,#00,#8a,#00,#8a,#00,#8f,#00
db #a8,#00,#a8,#00,#88,#00,#ff,#10
db #00,#aa,#00,#aa,#00,#aa,#00,#ff
db #00,#00,#00,#00,#00,#00,#00,#ff
db #10,#00,#b1,#00,#b1,#00,#b1,#00
db #f1,#00,#15,#00,#15,#00,#11,#00
db #ff,#10,#ff,#00,#ff,#00,#ff,#00
db #fc,#03,#fe,#01,#fe,#01,#f0,#0f
db #c0,#3a,#20,#fc,#03,#f8,#04,#c0
db #38,#00,#c0,#00,#00,#00,#00,#00
db #00,#00,#00,#20,#0e,#f1,#00,#0e
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#20,#7f,#80,#1f
db #60,#0f,#10,#0f,#10,#07,#08,#03
db #0c,#01,#02,#01,#02,#20,#80,#55 ;.......U
db #c0,#3a,#e0,#14,#c0,#3a,#00,#d4
db #c0,#2a,#c0,#37,#80,#6a,#20,#00 ;.....j..
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#20
db #00,#fe,#00,#fe,#00,#ff,#00,#ff
db #00,#fe,#00,#f8,#00,#fe,#00,#fc
db #0c,#00,#d9,#00,#aa,#00,#55,#00 ;......U.
db #aa,#00,#d9,#00,#aa,#00,#d9,#00
db #fa,#20,#00,#00,#00,#00,#00,#00
db #00,#80,#00,#50,#00,#e8,#00,#f5 ;...P....
db #00,#ea,#20,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #01,#00,#3e,#20,#00,#fe,#00,#fe
db #00,#fc,#00,#fe,#00,#fe,#00,#f8
db #00,#fc,#00,#c0,#0c,#00,#00,#00
db #0e,#00,#35,#00,#6b,#00,#6f,#00 ;....k.o.
db #de,#00,#35,#00,#ba
lab4587 db #14
db #00,#00,#00,#d6,#00,#6f,#00,#de ;.....o..
db #00,#6b,#00,#ba,#00,#6f,#00,#6b ;.k...o.k
lab4598 db #14
db #00,#00,#00,#d4,#00,#ba,#00,#de
db #00,#ba,#00,#6f,#00,#35,#00,#d6 ;...o....
lab45A9 db #14
db #00,#ff,#00,#80,#00,#80,#00,#9f
db #00,#98,#00,#98,#00,#98,#00,#98
db #30,#00,#ff,#00,#00,#00,#00,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#30,#00,#ff,#00,#01,#00,#01
db #00,#f9,#00,#09,#00,#09,#00,#09
db #00,#09,#30,#00,#98,#00,#98,#00
db #9f,#00,#9f,#00,#80,#00,#80,#00
db #80,#00,#ff,#30,#00,#00,#00,#00
db #00,#ff,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#ff,#30,#00,#09,#00
db #09,#00,#f9,#00,#f9,#00,#01,#00
db #01,#00,#01,#00,#ff,#30,#00,#ff
db #00,#ff,#00,#fd,#00,#ff,#00,#ff
db #00,#ff,#00,#ff,#00,#bf,#08,#00
db #81,#00,#ff,#00,#81,#00,#81,#00
db #81,#00,#81,#00,#81,#00,#81,#30
db #00,#17,#00,#2b,#00,#17,#00,#2b
db #00,#17,#00,#2b,#00,#17,#00,#2b
db #45,#00,#ff,#00,#80,#00,#80,#00 ;E.......
db #ff,#00,#80,#00,#80,#00,#80,#00
db #80,#28,#00,#ff,#00,#00,#00,#00
db #00,#ff,#00,#01,#00,#01,#00,#01
db #00,#01,#28,#00,#ff,#00,#00,#00
db #00,#00,#ff,#00,#00,#00,#00,#00
db #00,#00,#ff,#28,#00,#ff,#00,#00
db #00,#00,#00,#ff,#00,#80,#00,#80
db #00,#80,#00,#80,#28,#00,#ff,#00
db #01,#00,#01,#00,#ff,#00,#01,#00
db #01,#00,#01,#00,#01,#28,#00,#80
db #00,#80,#00,#80,#00,#80,#00,#80
db #00,#80,#00,#80,#00,#ff,#28,#00
db #01,#00,#01,#00,#01,#00,#01,#00
db #01,#00,#01,#00,#01,#00,#ff,#28
db #00,#ff,#00,#88,#00,#af,#00,#88
db #00,#8f,#00,#a8,#00,#8f,#00,#ff
db #10,#00,#ff,#00,#11,#00,#f5,#00
db #11,#00,#f1,#00,#15,#00,#f1,#00
db #ff,#10,#00,#ff,#00,#00,#00,#4a ;.......J
db #00,#55,#00,#4a,#00,#55,#00,#4a ;.U.J.U.J
db #00,#ff,#05,#00,#ff,#00,#06,#00
db #be,#00,#5e,#00,#be,#00,#5e,#00
db #be,#00,#ff,#0f,#00,#00,#00,#55 ;.......U
db #00,#4a,#00,#55,#00,#4a,#00,#55 ;.J.U.J.U
db #00,#ff,#00,#00,#05,#00,#06,#00
db #5e,#00,#be,#00,#5e,#00,#be,#00
db #5e,#00,#ff,#00,#06,#0f,#00,#4a ;.......J
db #00,#55,#00,#4a,#00,#55,#00,#4a ;.U.J.U.J
db #00,#ff,#00,#00,#00,#55,#05,#00 ;.....U..
db #be,#00,#5e,#00,#be,#00,#5e,#00
db #be,#00,#ff,#00,#06,#00,#5e,#0f
db #f8,#00,#30,#06,#18,#c1,#0c,#21
db #c4,#11,#80,#12,#00,#6d,#00,#8e ;.....m..
db #08,#1f,#40,#3f,#80,#7f,#00,#3f
db #00,#1f,#40,#3f,#80,#7f,#00,#ff
db #00,#08,#41,#18,#c3,#18,#83,#28 ;..A.....
db #83,#38,#81,#34,#43,#18,#02,#98 ;....C...
db #00,#55,#08,#ff,#00,#ef,#00,#c7 ;.U......
db #10,#8f,#20,#07,#70,#0f,#40,#3f ;....p...
db #80,#3f,#80,#08,#ff,#00,#ff,#00
db #ff,#00,#fb,#00,#71,#04,#01,#84 ;....q...
db #03,#78,#81,#08,#08,#00,#55,#80 ;.x....U.
db #3a,#80,#3e,#81,#3c,#83,#28,#87
db #30,#07,#70,#07,#70,#08,#80,#3e ;..p.p...
db #00,#5a,#a0,#0f,#f0,#05,#e0,#06 ;.Z......
db #80,#1f,#00,#61,#1e,#80,#08,#83 ;...a....
db #18,#07,#60,#03,#d0,#21,#8c,#33
db #80,#1f,#40,#0f,#a0,#0f,#a0,#08
db #fe,#00,#fc,#00,#dc,#01,#88,#23
db #c0,#17,#c0,#1e,#81,#34,#03,#68 ;.......h
db #08,#0f,#e0,#1f,#c0,#3f,#80,#7f
db #00,#7f,#00,#ff,#00,#ff,#00,#ff
db #00,#08,#02,#d0,#00,#6d,#00,#53 ;.....m.S
db #80,#3b,#c0,#1e,#e0,#0e,#f0,#07
db #f0,#07,#08,#07,#f0,#07


lab4800 db #f0
db #0f,#a0
lab4803 db #1f
db #c0,#3f,#80,#3f,#80,#7f,#00,#7f
db #00,#08,#f0,#05,#e0,#0d,#e0,#0d
db #e0,#0a,#c0,#1a,#c1,#1c,#c1,#1c
db #81,#34,#08,#81,#34
lab4821 db #83
lab4822 db #38
db #03,#58,#03,#68,#03,#68,#03,#e8 ;.X.h.h..
db #03,#a8,#07,#d0,#08,#fc,#01,#fc
db #01,#fc,#01,#f8,#03,#f8,#03,#f8
db #03,#f0,#05,#f0,#05,#08,#07,#d0
lab4843 db #7
db #d0,#07,#d0,#0f,#a0,#0f,#a0,#0f
db #a0,#0f,#a0,#0f,#a0,#08,#f0,#07
db #e0,#0f,#e0,#0e,#e0,#0a,#c0,#1a
db #c0,#1f,#c0,#1d
lab4860 db #80
db #3c,#08
lab4863 db #1f
db #40,#1f,#40,#1f,#c0,#1f,#c0,#1f
db #40,#1f,#40,#1f,#40,#0f,#60,#08
db #80,#3e,#80,#35,#00,#7f,#00,#7f
db #00,#76,#00,#6f ;.v.o
lab4880 db #0
db #6e,#00,#ed,#08,#0f,#a0,#1f,#40 ;n.......
db #1f,#40,#1f,#40,#0f,#a0,#07,#50 ;.......P
db #00,#a8,#00,#d7,#08,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00
lab48A2 db #0
lab48A3 db #3
db #00
lab48A5 db #7f
lab48A6 db #e
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#1f,#00,#ff,#00,#ff
db #0e,#00,#00,#00,#00,#00,#00,#00
db #07,#00,#ff,#00,#ff
lab48C4 db #0
db #ff,#00,#ff,#0e,#00,#00,#00,#00
db #00,#1f,#00,#ff,#00,#ff,#00,#ff
db #00,#ff,#00,#ff,#0e,#00,#01,#00
db #7f,#00,#ff,#00,#ff,#00,#ff,#00
db #ff,#00,#ff,#00,#ff,#0e,#00,#f8
db #00,#fc,#00,#fe,#00,#fe,#00,#ff
db #00,#ff,#00,#ff,#00,#c0,#0e,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#1f,#00,#7f,#00,#ff,#0e
db #00,#00,#00,#00,#00,#00,#00,#07
db #00,#ff,#00,#ff,#00,#ff,#00,#80
db #0e,#00,#00,#00,#01,#00,#3f,#00
db #ff,#00,#ff,#00,#ff,#00,#80,#00
db #7f,#0e,#00,#0f,#00,#ff,#00,#ff
db #00,#ff,#00,#ff,#00,#80,#00,#55 ;.......U
db #00,#ff,#06,#00,#ff,#00,#ff,#00
db #ff,#00,#ff,#00,#c0,#00,#aa,#00
db #55,#00,#ff,#06,#00,#ff,#00,#ff ;U.......
db #00,#ff,#00,#e0,#00,#15,#00,#aa
db #00,#57,#00,#ff,#06,#00,#ff,#00 ;.W......
db #ff,#00,#f0,#00,#0a,#00,#55,#00 ;......U.
db #aa,#00,#ff,#00,#ff,#06,#00,#ff
db #00,#e0,#00,#15,#00,#aa,#00,#55 ;.......U
db #00,#aa,#00,#ff,#00,#ff,#06,#00
db #e4,#00,#0c,#00,#54,#00,#ac,#00 ;....T...
db #56,#00,#be,#00,#ff,#00,#ff,#06 ;V.......
db #00,#70,#00,#0f,#00,#01,#00,#00 ;.p......
db #00,#00,#00,#00,#00,#00,#00,#00
db #0e,#00,#00,#00,#ff,#00,#f0,#00
db #0f,#00,#00,#00,#00,#00,#00,#00
db #00,#0e,#00,#00,#00,#ff,#00,#05
db #00,#ff,#00,#3f,#00,#00,#00,#00
db #00,#00,#0e,#00,#00,#00,#ff,#00
db #55,#00,#ff,#00,#ff,#00,#ff,#00 ;U.......
db #03,#00,#00,#0e,#00,#00,#00,#bf
db #00,#05,#00,#2a,#00,#6f,#00,#6f ;.....o.o
db #00,#57,#00,#00,#0e,#00,#00,#00 ;.W......
db #ff,#00,#55,#00,#aa,#00,#d5,#00 ;..U.....
db #ff,#00,#ff,#00,#ff,#06,#00,#00
db #00,#ff,#00,#55,#00,#aa,#00,#55 ;...U...U
db #00,#fa,#00,#ff,#00,#ff,#06,#00
db #00,#00,#ff,#00,#55,#00,#aa,#00 ;....U...
db #56,#00,#ac,#00,#f4,#00,#fe,#06 ;V.......
db #00,#00,#00,#ff,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #0e,#00,#40,#00,#e0,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#0e,#00,#04,#00,#08,#00,#08
db #00,#11,#00,#31,#00,#21,#00,#22
db #00,#b5,#08,#00,#a8,#00,#a8,#00
db #a4,#00,#14,#00,#14,#00,#12,#00
db #05,#00,#dd,#08,#00,#ff,#00,#01
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#0e,#00,#ff,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#0e,#f8,#01
db #f1,#06,#e2,#08,#c5,#10,#8a,#20
db #14,#40,#2a,#41,#54,#45,#08,#1f ;...ATE..
db #c0,#1f,#40,#1f,#40,#3f,#80,#3f
db #80,#3f,#80,#7f,#00,#7f,#00,#08
db #fe,#00,#fc,#01,#fc,#01,#f8,#03
db #f0,#06,#e0,#0e,#e0,#0f,#e0,#09
db #08,#a0,#81,#40,#0f,#80,#17,#40
db #3e,#00,#be,#00,#5f,#00,#df,#00
db #e7,#08,#ff,#00,#ff,#00,#ff,#00
db #ff,#00,#ff,#00,#01,#00,#00,#fe
db #00,#01,#08,#ff,#00,#ff,#00,#ff
db #00,#ff,#00,#fc,#00,#f8,#03,#f8
db #01,#f8,#02,#08,#00,#0b,#00,#0f
db #00,#07,#00,#03,#00,#fc,#00,#fd
db #00,#fd,#00,#7b,#0a,#00,#f8,#00
db #fe,#00,#ff,#00,#ff,#00,#ff,#00
db #7f,#00,#be,#00,#9f,#0a,#00,#00
db #00,#00,#00,#80,#00,#f6,#00,#f6
db #00,#f5,#00,#75,#00,#3b,#02,#00 ;...u....
db #cf,#00,#bf,#00,#7f,#00,#7f,#00
db #78,#00,#bd,#00,#bd,#00,#be,#08 ;x.......
db #00,#ff,#00,#ff,#00,#ff,#00,#80
db #00,#00,#00,#aa,#00,#d5,#00,#aa
db #10,#00,#3f,#00,#7f,#00,#ff,#00
db #fd,#00,#aa,#00,#55,#00,#ac,#00 ;....U...
db #00,#02,#00,#ff,#00,#ff,#00,#ff
db #00,#7f,#00,#bf,#00,#c3,#00,#00
db #00,#00,#02,#00,#c0,#00,#e0,#00
db #e8,#00,#e8,#00,#e0,#00,#e0,#00
db #90,#00,#50,#0a,#f0,#07,#f0,#07 ;..P.....
db #e0,#0f,#e0,#0f,#c0,#1f,#c0,#1e
db #c0,#1e,#c0,#1e,#08,#00,#9b,#00
db #c7,#10,#86,#40,#0c,#00,#2c,#00
db #5c,#80,#5a,#00,#5a,#08,#00,#6f ;..Z.Z..o
db #00,#77,#00,#fb,#00,#fd,#00,#3d ;.w......
db #80,#19,#00,#15,#80,#2d,#0a,#00
db #9d,#00,#9d,#00,#ae,#00,#ae,#00
db #b7,#00,#d7,#00,#cf,#00,#ef,#02
db #00,#5f,#00,#5e,#00,#ae,#00,#97
db #00,#57,#00,#6b,#00,#a7,#00,#cf ;.W.k....
db #28,#00,#00,#00,#fc,#00,#47,#00 ;......G.
db #ed,#00,#a5,#00,#a9,#00,#57,#00 ;......W.
db #7a,#28,#00,#d1,#00,#b8,#00,#bc ;z.......
db #00,#fe,#00,#c1,#00,#fe,#00,#c0
db #00,#aa,#28,#00,#87,#00,#87,#00
db #43,#00,#3c,#00,#e0,#00,#00,#00 ;C.......
db #15,#00,#aa,#28,#03,#b8,#03,#d8
db #01,#ec,#00,#e6,#00,#f6,#01,#f0
db #07,#f0,#07,#f0,#08,#c0,#1e,#e0
db #0f,#e0,#0f,#f0,#07,#f0,#07,#f8
db #03,#fc,#01,#fe,#00,#08,#01,#64 ;.......d
db #02,#38,#45,#00,#00,#80,#00,#ff ;..E.....
db #00,#ff,#00,#ff,#00,#7f,#08,#00
db #3c,#82,#38,#03,#78,#07,#f0,#07 ;....x...
db #f0,#0f,#e0,#1f,#c0,#3f,#00,#08
db #00,#e7,#00,#f1,#00,#7f,#00,#3f
db #00,#00,#00,#00,#00,#00,#00,#00
db #0a,#00,#e7,#00,#ff,#00,#ff,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#0a,#00,#f1,#00,#ff,#00,#ff
db #00,#fc,#00,#00,#00,#00,#00,#00
db #00,#00,#0a,#00,#55,#00,#ff,#00 ;....U...
db #7e,#00,#7f,#80,#3f,#c0,#1f,#e0
db #0f,#f0,#03,#08,#00,#57,#00,#f9 ;.....W..
db #a0,#03,#00,#0f,#00,#ff,#00,#ff
db #00,#ff,#00,#fc,#08,#07,#f0,#0f
db #e0,#0f,#e0,#1f,#c0,#1f,#c0,#3f
db #80,#7f,#00,#ff,#00,#08,#7f,#00
db #3f,#80,#07,#e0,#00,#f8,#00,#ff
db #00,#ff,#00,#ff,#00,#ff,#08,#ff
db #00,#ff,#00,#ff,#00,#ff,#00,#07
db #00,#00,#f8,#00,#ff,#00,#ff,#08
db #ff,#00,#ff,#00,#ff,#00,#ff,#00
db #ff,#00,#ff,#00,#03,#00,#00,#fc
db #08,#ff,#00,#ff,#00,#ff,#00,#ff
db #00,#ff,#00,#fc,#00,#e0,#03,#00
db #1c,#08,#00,#ff,#00,#3f,#00,#ff
db #00,#1f,#00,#67,#00,#b1,#00,#ad ;...g....
db #00,#a8,#28,#00,#f0,#00,#c0,#00
db #80,#00,#00,#00,#00,#00,#aa,#00
db #d5,#00,#aa,#10,#00,#5d,#00,#48 ;.......H
db #00,#ac,#00,#94,#00,#54,#00,#6a ;.....T.j
db #00,#aa,#00,#de,#28,#ff,#00,#00
db #ff,#00,#ff,#00,#80,#00,#bf,#00
db #81,#00,#80,#00,#ff,#28,#00,#ff
db #00,#ff,#00,#00,#00,#7e,#00,#02
db #00,#02,#00,#00,#00,#ff,#28,#00
db #ff,#00,#ff,#00,#01,#00,#fd,#00
db #05,#00,#05,#00,#01,#00,#ff,#28
db #83,#38,#83,#38,#83,#38,#83,#38
db #83,#38,#83,#38,#83,#38,#83,#38
db #20,#c1,#1c,#c1,#1c,#c1,#1c,#c1
db #1c,#c1,#1c,#c1,#1c,#c1,#1c,#c1
db #1c,#20


; Slow fill, SP can be used to make it *much* faster
lab4D6F
    ld hl,buf_spr1
    ld de,buf_spr1+1
    ld bc,#023F

fill255:
lab4D78 ld (hl),#ff
    ldir
    ret

lab4D7D
	ld hl,buf_spr2
    ld de,buf_spr2+1
    ld bc,#047F
    jr lab4D78

data4d88 db #01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01,#01,#01,#01,#01,#01,#01,#01
db #01
db #ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ce,#ff,#ff,#ff,#ff,#ff,#cf,#d0
db #d1,#ff,#ff,#ff,#d6,#d7,#d8,#d9
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff

lab4DDE db #ff
db #ff,#ff,#ff,#ff,#ff,#c6,#ff,#ff
db #ff,#ff,#ff,#c7,#c8,#c9,#ca,#cb
db #cc,#ff,#cd,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#a0,#a1,#ff,#ff,#ff,#ff,#a2
db #a3,#a4,#ff,#ff,#ff,#a5,#a6,#a7
db #ff,#ff,#ff,#ff,#a8,#a9,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#aa,#ab,#ff,#ff,#ff
db #ac,#ad,#ae,#ff,#ff,#ff,#af,#b0
db #b1,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#b2,#b3,#b4,#ff
db #ff,#ff,#b5,#b6,#b7,#ff,#ff,#ff
db #b8,#b9,#ba,#ff,#ff,#ff,#ff,#bb
db #bc,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#bd,#be
db #bf,#ff,#ff,#ff,#c0,#c1,#c2,#ff
db #ff,#ff,#c3,#c4,#c5,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #00,#01,#ff,#ff,#ff,#ff,#02,#03
db #04,#ff,#ff,#ff,#05,#06,#07,#ff
db #ff,#ff,#08,#09,#ff,#ff,#ff,#ff
db #0a,#0b,#0c,#ff,#ff,#0d,#0e,#0f
db #10,#ff,#ff,#ff,#63,#ff,#ff,#ff ;....c...
db #64,#65,#66,#ff,#ff,#ff,#67,#68 ;def...gh
db #69,#ff,#ff,#ff,#ff,#6a,#6b,#ff ;i....jk.
db #ff,#ff,#ff,#6c,#6d,#6e,#ff,#ff ;...lmn..
db #ff,#6f,#70,#ff,#ff,#ff,#ff,#71 ;.op....q
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#11,#12,#ff,#13
db #14,#15,#16,#17,#ff,#ff,#ff,#18
db #19,#1a,#ff,#ff,#ff,#08,#09,#ff
db #ff,#ff,#ff,#0a,#0b,#0c,#ff,#ff
db #0d,#0e,#0f,#10,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#1b,#ff,#ff
db #ff,#ff,#1c,#1d,#1e,#ff,#ff,#ff
db #1f,#20,#21,#ff,#ff,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#ff
db #ff,#22,#23,#ff,#ff,#ff,#ff,#24
db #25,#ff,#ff,#ff,#ff,#26,#27,#ff
db #ff,#ff,#28,#29,#2a,#ff,#ff,#ff
db #2b,#2c,#2d,#ff,#ff,#ff,#ff,#2e
db #2f,#ff,#ff,#ff,#30,#31,#32,#ff
db #ff,#ff,#33,#34,#35,#ff,#ff,#ff
db #ff,#36,#37,#38,#ff,#ff,#39,#3a
db #3b,#ff,#ff,#ff,#3c,#3d,#3e,#3f
db #ff,#ff,#40,#ff,#41,#42,#ff,#ff ;....AB..
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#11,#12,#ff,#13
db #14,#15,#16,#17,#ff,#ff,#43,#44 ;......CD
db #45,#46,#ff,#47,#48,#49,#ff,#4a ;EF.GHI.J
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#11,#12
db #ff,#ff,#ff,#02,#16,#17,#ff,#ff
db #4b,#4c,#45,#46,#ff,#ff,#4d,#4e ;KLEF..MN
db #ff,#4a,#ff,#ff,#ff,#ff,#ff,#ff ;.J......
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#4f,#50,#51 ;.....OPQ
db #12,#52

assert $==#4fe1
lab4fe1:
    db #53,#02,#16,#4a,#14,#02 ;.RS..J..
    db #17,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#ff,#ff,#ff,#ff

lab4ff4
    db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #55,#11,#ff,#ff,#ff,#ff,#56,#57

lab5004
    db #ff,#ff,#ff,#ff,#58,#59
    db #ff,#ff,#ff,#ff,#5a,#5b
;5010
    db #ff,#ff,#ff,#ff,#5c,#5d
;5016
    db #ff,#ff,#ff,#ff,#ff,#5e
;501c
    db #ff,#ff

assert $==#501e
lab501e
    db #ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#5f,#55,#11,#ff,#ff,#ff,#60 ;..U.....
    db #56,#57,#ff,#ff,#ff,#ff,#61 ;VW....a

lab5033 db #59
    db #ff,#ff,#ff,#ff,#62,#5b,#ff,#ff ;....b...
    db #ff,#ff,#5c,#5d,#ff,#ff,#ff,#ff
    db #ff,#5e,#ff,#ff
lab5048 db #ff
    db #72,#ff,#73,#74,#ff,#75,#76,#77 ;r.st.uvw
    db #78,#79,#ff,#7a,#7b,#7c,#7d,#7e ;xy.z....
    db #ff,#ff,#ff,#7f,#80,#81,#ff,#ff
    db #ff,#ff,#82,#83,#ff
    db #ff
    db #ff,#ff,#84,#ff,#ff,#ff,#ff,#ff
    db #ff,#ff,#ff

assert $==#5072
lab5072
    db #ff,#ff,#ff,#ff,#ff
    db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#ff,#ff,#ff,#ff,#ff
lab5085 db #ff
    db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #ff,#ff
    ;5090
    db #ff,#ff,#86,#ff,#ff,#ff
    db #ff,#87,#88,#89,#8a,#ff,#ff,#8b
    db #8c,#8d,#8e,#ff,#ff,#8f
    db #90
    db #91,#92,#ff,#ff,#ff,#93,#94,#95
    db #ff,#ff,#ff,#96,#97,#ff,#ff,#ff
    db #98,#99,#9a,#ff,#ff,#ff,#9b,#9c
    db #9d,#ff,#ff,#ff
lab50C1 db #ff
    db #9e,#9f
lab50C4 db #ff,#ff


lab50C6
    ld (lab50E9+1),a
    ld (lab5D12+1),a
    ld a,(data39ec)
    dec a
    jp z,lab5CF6
    exx
    ld bc,lab5137
lab50D7
    ld hl,(lab39CD) ; Automodif
    push de
    ld de,buf_bg
    add hl,de
    pop de
    exx
    ld a,c
lab50E2
    ld (lab50E5+1),a
lab50E5
    ld c,#6     ; automodif
    exx
    push hl
lab50E9
    ld e,#0     ; automodif
    exx
    push hl
lab50ED exx
    ld a,e
    exx
    cp #20
    jr nc,lab5105
    exx
    ld a,d
    exx
    cp #12
    jr nc,lab5105
    exx
    ld a,(hl)
lab50FD nop
    exx
    cp #c7
    jr nc,lab5105
    ld a,(de)
    ld (hl),a
lab5105
    exx
    inc e
    inc hl
    inc bc
    exx
    inc hl
    inc de
    dec c
    jr nz,lab50ED
    pop hl
    push de
    ld de,32
    add hl,de
    pop de
    exx
    inc d
    pop hl
    push de
    ld de,32
    add hl,de
    pop de
    exx
    djnz lab50E5
    ret

data5123
    db #00
    db #00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00
lab5137 db #0
lab5138 db #0
    db #00,#00,#00
lab513C db #0
lab513D
		db #00
lab513e
        db #00,#00
;5140
        db #00,#00,#00
lab5143: db #00,#00
        db #00,#00,#00,#00,#00,#00
lab514b:
        db #00,#00
        db #00,#00
lab514f db #00
;5150
        db #00,#00,#00,#00
        db #00,#00,#00,#00
        db #00,#00,#00
lab515b: db #00
lab515c: db #00
lab515D: db #00
lab515e: db #00,#00
        db #00
lab5161: db #00
lab5162  db #00
lab5163: db #00
lab5164: db #00
lab5165: db #00
lab5166: db #00

lab5167 call lab5199
    jr nz,lab51AD
    ld hl,(lab39CD)
    ld de,buf_fg + #08A2-#880     ; Buffer
    call lab5DAA
    add hl,de
    xor a
    cp (hl)
    ld b,#2
    call z,lab95C0
    ld hl,lab39CC
    inc (hl)
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    ld de,buf_fg + #08A2 -#880     ; Buffer ;lab08A2
    call lab5DAA



/*db #cd,#99,#51,#20,#41,#2a,#cd ;...Q.A..
db #39,#11,#a2,#08,#cd,#aa,#5d,#19
db #af,#be,#06,#02,#cc,#c0,#95,#21
db #cc,#39,#34,#2a,#cd,#39,#11,#20
db #00,#19,#22,#cd,#39,#11,#a2,#08
db #cd,#aa,#5d
*/


lab5191 add hl,de
    xor a
    cp (hl)
    jp nz,lab5CE9
    jr lab51E1
lab5199 ld hl,lab5162
    ld c,#1
    ld b,#4
lab51A0 ld a,(hl)
    inc a
    cp #c8
    jr nc,lab51AB
    inc hl
    djnz lab51A0
    dec c
    ret
lab51AB inc c
    ret
lab51AD ld a,(lab39CC)
    cp #ff
    ld de,buf_fg + #08A2-#880
    jp p,lab51BB
    ld de,buf_fg + #0942-#880
lab51BB call lab5DAA
    ld hl,(lab39CD)
    add hl,de
    ld a,(hl)
    or a
    jr z,lab51E1
    call lab3ECA+1
    bit 4,a
    jp z,lab51DC
    ld a,#1
    ld (lab3C3B),a
    ld hl,lab5236
    ld de,lab4F76
    jp lab5CDF
lab51DC bit 2,a
    jp z,lab5CE9
lab51E1 call lab3ECA+1
    bit 1,a
    jr z,lab520C
    ld a,(data39EC)
    dec a
    jr z,lab51FF
    call lab5222
    ld b,#2
    call lab95C0
    ld de,lab4FCA
    ld hl,lab5DB2
    jp lab5CDF
lab51FF ld (data39EC),a
    jp lab2BB4
lab5205 inc a
    ld (data39EC),a
    jp lab2BB4
lab520C bit 0,a
    jr z,lab5233
    ld a,(data39EC)
    or a
    jr z,lab5205
    call lab5222

    ld de,lab4FCA
    ld hl,data5D5A
    jp lab5CDF

lab5222
    ld hl,(lab39CD)
    ld de, buf_fg+#82
    call lab5DAA
    add hl,de
    xor a
    cp (hl)
    ret z
    pop hl
    jp lab2BB4
lab5233 jp lab2BB4
lab5236 ld a,(lab3C3B)
    or a
    jr z,lab5266
    ld a,(lab515B)
    inc a
    jr z,lab5251
    ld de,buf_spr2+#C0
    ld a,(data39EC)
    dec a
    jr nz,lab524E
    ld de,buf_spr2+#C5
lab524E call lab53A7
lab5251 ld a,(lab514F)
    inc a
    jr z,lab5266
    ld de,buf_spr2+#80
    ld a,(data39EC)
    dec a
    jr nz,lab5263
    ld de,buf_spr2+#85
lab5263 call lab53A7
lab5266 xor a
    ld (lab3C3B),a
    call lab3ECA+1
    bit 4,a
    jp nz,lab2BB4
lab5272 xor a
    ld (lab34C2),a
    ld hl,lab5167
    ld de,lab4FA0
    jp lab5CDF

; DATA
txt_stash_searched
    db #01
    db "STASH SEARCHED"

lab528E ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
    ld hl,(lab2968)
    ld a,(hl)
    ld (lab296A),a
    ld b,#5
lab529E inc hl
    ld a,(hl)
    dec hl
    ld (hl),a
    inc hl
    cp #3
    jr z,lab52A9
    djnz lab529E
lab52A9 dec hl
    ld a,(lab296A)
    cp #4
    jr nz,lab52D8
    ld hl,(lab52D3)
    inc hl
    ld (lab52D3),hl
    ld d,h
    ld e,l
    ld hl,lab52D6
    inc (hl)
    dec hl
    ld a,r
    and #1
    add a,#25
    ld (hl),a
    ld c,#1
    call draw_text
    ld b,#64
    call lab8A76
    jp lab5CE9

/*
lab5191 db #19
db #af,#be,#c2,#e9,#5c,#18,#48,#21 ;......H.
db #62,#51,#0e,#01,#06,#04,#7e,#3c ;bQ......
db #fe,#c8,#30,#05,#23,#10,#f7,#0d
db #c9,#0c,#c9,#3a,#cc,#39,#fe,#ff
db #11,#a2,#08,#f2,#bb,#51,#11,#42 ;.....Q.B
db #09,#cd,#aa,#5d,#2a,#cd,#39,#19
db #7e,#b7,#28,#1b,#cd,#cb,#3e,#cb
db #67,#ca,#dc,#51,#3e,#01,#32,#3b ;g..Q....
db #3c,#21,#36,#52,#11,#76,#4f,#c3 ;...R.vO.
db #df,#5c,#cb,#57,#ca,#e9,#5c,#cd ;...W....
db #cb,#3e,#cb,#4f,#28,#24,#3a,#ec ;...O....
db #39,#3d,#28,#11,#cd,#22,#52,#06 ;......R.
db #02,#cd,#c0,#95,#11,#ca,#4f,#21 ;......O.
db #b2,#5d,#c3,#df,#5c,#32,#ec,#39
db #c3,#b4,#2b,#3c,#32,#ec,#39,#c3
db #b4,#2b,#cb,#47,#28,#23,#3a,#ec ;...G....
db #39,#b7,#28,#ef,#cd,#22,#52,#11 ;......R.
db #ca,#4f,#21,#5a,#5d,#c3,#df,#5c ;.O.Z....
db #2a,#cd,#39,#11,#02,#09,#cd,#aa
db #5d,#19,#af,#be,#c8,#e1,#c3,#b4
db #2b,#c3,#b4,#2b,#3a,#3b,#3c,#b7
db #28,#2a,#3a,#5b,#51,#3c,#28,#0f ;....Q...
db #11,#c0,#0d,#3a,#ec,#39,#3d,#20
db #03,#11,#c5,#0d,#cd,#a7,#53,#3a ;......S.
db #4f,#51,#3c,#28,#0f,#11,#80,#0d ;OQ......
db #3a,#ec,#39,#3d,#20,#03,#11,#85
db #0d,#cd,#a7,#53,#af,#32,#3b,#3c ;...S....
db #cd,#cb,#3e,#cb,#67,#c2,#b4,#2b ;....g...
db #af,#32,#c2,#34,#21,#67,#51,#11 ;.....gQ.
db #a0,#4f,#c3,#df,#5c,#01,#53,#54 ;.O....ST
db #41,#53,#48,#20,#53,#45,#41,#52 ;ASH.SEAR
db #43,#48,#45,#44,#21,#3b,#3c,#35 ;CHED....
db #c2,#b4,#2b,#2a,#68,#29,#7e,#32 ;....h...
db #6a,#29,#06,#05,#23,#7e,#2b,#77 ;j......w
db #23,#fe,#03,#28,#02,#10,#f5,#2b
db #3a,#6a,#29,#fe,#04,#20,#27,#2a ;.j......
db #d3,#52,#23,#22,#d3,#52,#54,#5d ;.R...RT.
db #21,#d6,#52,#34,#2b,#ed,#5f,#e6 ;..R.....
db #01,#c6,#25,#77,#0e,#01,#cd,#34 ;...w....
db #14,#06,#64,#cd,#76,#8a,#c3,#e9 ;..d.v...
db #5c
*/

lab52D3 db #00,#00,#00
lab52D6 db #00
lab52D7 db #00


lab52D8 ld b,#0
lab52DA ld a,(lab2B0B)
    or a
    jr nz,lab52E2
    ld b,#80
lab52E2 ld a,(#3494+1)
    or a
    jr nz,lab52EC
    ld a,#3
lab52EA ld b,#0
lab52EC or b
    ld (hl),a
    dec b
    inc b
    jr z,lab52F7
    ld a,#1
    ld (lab2B0B),a
lab52F7 ld a,(lab296A)
    bit 7,a
    jr z,lab5315
    and #7f
lab5300 push af
    ld hl,labC8B6

    ld b,#8
lab5306
    inc hl
    djnz lab5306

    ld hl,txt_stash_searched
    ld c,#e
    ld de,#5066
    call draw_text
    pop af
lab5315 cp #3
    jr nz,lab531A
    xor a
lab531A ld (#3494+1),a
    call lab5447
    jp lab5CE9
lab5323 ld a,(lab5143)
    inc a
    jr z,lab5398
    ld a,(#3494+1)
    cp #0
    jr z,lab5383
    ld a,(#39ec)
    dec a
    ld bc,#0508
    ld de,#0045
    jr z,lab5342
    ld bc,#4
    ld de,#0040
lab5342 ld a,(lab39CB)
    add a,b
    ld hl,(lab39CD)
    add hl,de
    ld (lab3499),a
    ld a,(lab39CC)
    add a,#2
    ld (lab3498),a
    ld a,(#3494+1)
    add a,a
    add a,#d0
    ld (lab3497),a
    xor a
    ld (#3494+1),a
    call lab5447
    ld (lab349A),hl
    ld a,c
    ld (lab349C),a
    ld (lab349D),a
    call lab3ECA+1
    ld hl,lab349D
    bit 3,a
    jr z,lab537B
    jr lab5380
lab537B bit 2,a
    jr z,lab5398
    inc (hl)
lab5380 inc (hl)
    jr lab5398
lab5383 ld a,(lab3C3B)
    or a
    jr z,lab5398
    ld de,buf_spr2 + #20
    ld a,(#39ec)
    dec a
    jr nz,lab5395
    ld de,buf_spr2 + #25
lab5395 call lab53A7
lab5398 xor a
    ld (lab3C3B),a
    call lab3ECA+1
    bit 4,a
    jp z,lab5CE9
    jp lab2BB4
lab53A7 ld hl,(lab39CD)
    add hl,de
    ld a,(hl)
    inc a
    jr z,lab53BA
    ld a,#1
lab53B1 ld (lab2DE3),a
    ld a,#1
    ld (lab3C3B),a
    ret
lab53BA ld de,BUFSIZE
    add hl,de
    ld a,(hl)
    inc a
    ret z
    ld a,#2
    jr lab53B1
lab53C5 ld a,#2
    ld (lab3C3B),a
    ld hl,lab53D3
    ld de,lab501E
    jp lab5CDF

lab53D3 ld hl,lab3C3B
    dec (hl)
    jr nz,lab53E2
    ld hl,lab53FA
    ld de,lab4FF4
    jp lab5CDF

lab53E2 ld a,(lab513E)
    inc a
    jr z,lab53F7
    ld de,buf_spr2 + #21
    ld a,(#39ec)
    dec a
lab53EF jr nz,lab53F4
    ld de,buf_spr2 + #24
lab53F4 call lab53A7
lab53F7 jp lab2BB4
lab53FA jp lab5CE9
lab53FD ld bc,#fd21
    ld d,e
    dec (hl)
lab5402 ret nz
    ld (hl),#2
    ld a,(lab95C5+1)
    cp #e
lab540A jr nz,lab5412
    ld a,(lab95D3+1)
    cp #1
    ret z
lab5412 call lab95B5
    ld b,#1
    call lab95C4
    call lab95B5
    ret
/*
lab52D8 db #06,#00
lab52da db #3a,#0b,#2b,#b7,#20,#02
db #06,#80,#3a,#95,#34,#b7,#20,#04
db #3e,#03,#06,#00,#b0,#77,#05,#04 ;.....w..
db #28,#05,#3e,#01,#32,#0b,#2b,#3a
db #6a,#29,#cb,#7f,#28,#17,#e6,#7f ;j.......
lab5300 db #f5
db #21,#b6,#c8,#06,#08,#23,#10,#fd
db #21,#7f,#52,#0e,#0e,#11,#66,#50 ;..R...fP
db #cd,#34,#14,#f1,#fe,#03,#20,#01
db #af,#32,#95,#34,#cd,#47,#54,#c3 ;.....GT.
db #e9,#5c,#3a,#43,#51,#3c,#28,#6f ;...CQ..o
db #3a,#95,#34,#fe,#00,#28,#53,#3a ;......S.
db #ec,#39,#3d,#01,#08,#05,#11,#45 ;.......E
db #00,#28,#06,#01,#04,#00,#11,#40
db #00,#3a,#cb,#39,#80,#2a,#cd,#39
db #19,#32,#99,#34,#3a,#cc,#39,#c6
db #02,#32,#98,#34,#3a,#95,#34,#87
db #c6,#d0,#32,#97,#34,#af,#32,#95
db #34,#cd,#47,#54,#22,#9a,#34,#79 ;..GT...y
db #32,#9c,#34,#32,#9d,#34,#cd,#cb
db #3e,#21,#9d,#34,#cb,#5f,#28,#02
db #18,#05,#cb,#57,#28,#19,#34,#34 ;...W....
db #18,#15,#3a,#3b,#3c,#b7,#28,#0f
db #11,#20,#0d,#3a,#ec,#39,#3d,#20
db #03,#11,#25,#0d,#cd,#a7,#53,#af ;......S.
db #32,#3b,#3c,#cd,#cb,#3e,#cb,#67 ;.......g
db #ca,#e9,#5c,#c3,#b4,#2b,#2a,#cd
db #39,#19,#7e,#3c,#28,#0b,#3e,#01
db #32,#e3,#2d,#3e,#01,#32,#3b,#3c
db #c9,#11,#40,#02,#19,#7e,#3c,#c8
db #3e,#02,#18,#ec,#3e,#02,#32,#3b
db #3c,#21,#d3,#53,#11,#1e,#50,#c3 ;...S..P.
db #df,#5c,#21,#3b,#3c,#35,#20,#09
db #21,#fa,#53,#11,#f4,#4f,#c3,#df ;..S..O..
db #5c,#3a,#3e,#51,#3c,#28,#0f,#11 ;...Q....
db #21,#0d,#3a,#ec,#39,#3d
lab53EF db #20
db #03,#11,#24,#0d,#cd,#a7,#53,#c3 ;......S.
db #b4,#2b,#c3,#e9,#5c,#01,#21,#fd
db #53,#35,#c0,#36,#02,#3a,#c6,#95 ;S.......
db #fe,#0e,#20,#06,#3a,#d4,#95,#fe
db #01,#c8,#cd,#b5,#95,#06,#01,#cd
db #c4,#95,#cd,#b5,#95,#c9
*/
lab541E push hl
    or a
    jr nz,lab5442
    ld hl,lab2B0B
    ld a,(hl)
    or a
    jr z,lab5442
    dec (hl)
    ld hl,(lab2968)
    ld b,#5
lab542F ld a,(hl)
    and #7f
    ld (hl),a
    inc hl
    djnz lab542F
    ld hl,labC8B6
    ld b,#8
lab543B inc hl
    djnz lab543B
    call lab8A89
    xor a
lab5442 ld hl,52
    jr lab544E
lab5447 ld a,(lab3495)
    push hl
    ld hl,0
lab544E ld (lab5477+1),hl
    and #7f
lab5453: push bc
    push de
    ld l,a
    ld h,#0
    add hl,hl
    ld de,lab54CD
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld c,#18
    push de			; ????
    ld iy,#60
    add iy,de       ; ??
    pop de			; ???
    ld ix,data5497
lab546E ld b,#4
    ld l,(ix+0)
    ld h,(ix+1)
    push de
lab5477 ld de,0
    add hl,de
    pop de
    inc ix
    inc ix
lab5480 ld a,(de)
    push de
    ld d,#ce
    ld e,a
    ld a,(de)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    ld (hl),a
    pop de
    inc l
    inc de
    djnz lab5480
    dec c
    jr nz,lab546E
    pop de
    pop bc
    pop hl
    ret

data5497 db #c2
db #c4,#c2,#cc,#c2,#d4,#c2,#dc,#c2
db #e4,#c2,#ec,#c2,#f4,#c2,#fc,#02
db #c5,#02,#cd,#02,#d5,#02,#dd,#02
db #e5,#02,#ed,#02,#f5,#02,#fd,#42 ;.......B
db #c5,#42,#cd,#42,#d5,#42,#dd,#42 ;.B.B.B.B
db #e5,#42,#ed,#42,#f5,#42,#fd,#61 ;.B.B.B.a
db #5a,#81,#5a,#a1,#5a ;Z.Z.Z
lab54CD db #dd
db #54,#49,#55,#b5,#55,#21,#56,#8d ;TIU.U.V.
db #56,#65,#57,#8d,#56,#f9,#56,#00 ;VeW.V.V.
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#4b,#dd,#2a,#5e,#6a ;...K...j
db #49,#2b,#52,#6a,#49,#2b,#50,#7a ;I.RjI.Pz
db #49,#eb,#d6,#5a,#49,#2a,#d2,#5a ;I..ZI..Z
db #49,#2a,#d2,#4b,#c9,#2a,#5e,#00 ;I..K....
db #00,#00,#00,#00,#00,#00,#00,#0f
db #0f,#0f,#0f,#00,#00,#00,#00,#00
db #00,#80,#00,#00,#00,#80,#00,#00
db #00,#80,#00,#00,#01,#80,#00,#00
db #01,#80,#00,#00,#03,#c0,#00,#00
db #7f,#f0,#00,#00,#0f,#fe,#00,#00
db #03,#c0,#00,#00,#01,#80,#00,#00
db #01,#80,#00,#00,#01,#00,#00,#00
db #01,#00,#00,#00,#01,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#75,#56,#55,#d2,#45 ;...uVU.E
db #55,#55,#1a,#77,#56,#59,#9e,#15 ;UU.wVY..
db #55,#55,#16,#75,#25,#55,#d2,#00 ;UU.u.U..
db #00,#00,#00,#00,#45,#07,#00,#00 ;....E...
db #47,#05,#00,#0f,#0f,#0f,#0f,#00 ;G.......
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#e0,#00,#c0,#03,#c0,#01
db #00,#0f,#00,#01,#00,#3c,#00,#01
db #00,#f0,#00,#01,#03,#c0,#00,#01
db #0f,#00,#00,#01,#3c,#00,#00,#01
db #f0,#00,#00,#03,#c0,#00,#00,#0f
db #c0,#00,#00,#3f,#60,#00,#00,#7c
db #18,#80,#00,#70,#07,#00,#00,#00 ;...p....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#06
db #06,#47,#47,#06,#47,#47,#47,#06 ;.GG.GGG.
db #06,#06,#06,#00,#03,#c0,#00,#00
db #02,#c0,#00,#00,#02,#c0,#00,#00
db #02,#c0,#00,#00,#0f,#f0,#00,#00
db #05,#e0,#00,#00,#02,#c0,#00,#00
db #01,#80,#00,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#00,#00,#00,#00,#28
db #00,#00,#14,#48,#00,#00,#12,#0f ;...H....
db #ff,#ff,#f0,#0a,#aa,#aa,#b0,#0a
db #aa,#aa,#b0,#00,#00,#00,#00,#4b ;.......K
db #dd,#2a,#5e,#6a,#49,#2b,#52,#6a ;...jI.Rj
db #49,#2b,#50,#7a,#49,#eb,#d6,#5a ;I.PzI..Z
db #49,#2a,#d2,#5a,#49,#2a,#d2,#4b ;I..ZI..K
db #c9,#2a,#5e,#04,#04,#04,#04,#30
db #30,#30,#30,#0f,#0f,#0f,#0f,#00
db #00,#00,#00,#00,#07,#e0,#00,#00
db #1d,#78,#00,#00,#2a,#ac,#00,#00 ;.x......
db #40,#16,#00,#00,#43,#8a,#00,#00 ;....C...
db #24,#46,#00,#00,#18,#2a,#00,#00 ;.F......
db #00,#26,#00,#00,#00,#4c,#00,#00 ;.....L..
db #00,#94,#00,#00,#01,#28,#00,#00
db #02,#50,#00,#00,#04,#a0,#00,#00 ;.P......
db #05,#40,#00,#00,#04,#c0,#00,#00
db #07,#c0,#00,#00,#00,#00,#00,#00
db #03,#80,#00,#00,#06,#c0,#00,#00
db #05,#40,#00,#00,#04,#c0,#00,#00
db #03,#80,#00,#00,#00,#00,#00,#43 ;.......C
db #43,#43,#43,#43,#43,#43,#43,#43 ;CCCCCCCC
db #43,#43,#43,#00,#00,#00,#00,#00 ;CCC.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#38,#00,#00,#00,#7c,#00
db #00,#00,#e0,#00,#00,#03,#e0,#00
db #00,#0e,#e4,#00,#00,#3b,#fc,#00
db #00,#ef,#38,#00,#03,#bc,#00,#00
db #0e,#f0,#00,#00,#3b,#c0,#00,#0f
db #6f,#00,#00,#1f,#bc,#00,#00,#13 ;o.......
db #f0,#00,#00,#03,#c0,#00,#00,#03
db #80,#00,#00,#1f,#00,#00,#00,#0e
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#45,#05,#45 ;.....E.E
db #45,#05,#45,#05,#45,#00,#00,#00 ;E.E.E...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#7f
db #ff,#ff,#fe,#5f,#7f,#ff,#fe,#5f
db #07,#0f,#0e,#40,#00,#00,#02,#7f
db #ff,#ff,#fe,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#7e,#7e,#7e,#7e,#63 ;.......c
db #18,#63,#60,#63,#18,#63,#7e,#7e ;.c.c.c..
db #18,#7e,#60,#60,#18,#60,#60,#60
db #7e,#60,#7e,#00,#00,#00,#00,#47 ;.......G
db #47,#07,#07,#45,#45,#05,#05,#0f ;G..EE...
db #0f,#0f,#0f

lab57d1:
    call lab53FD+1
    call lab5199
    jr nz,lab57EA
    ld de,lab509C
    ld a,#1
    ld (lab5BB7+1),a
    ld (lab34C2),a
lab57E4 ld hl,lab5B49
    jp lab5CDF

lab57EA ld a,(lab2096)
    cp #10
    jp z,lab594A
    cp #c8
    jp z,lab9620
    call lab3ECA+1
    bit 4,a
    jp z,lab5938
    ld a,(lab514B)
    inc a
    jp z,lab5918+1
    ld hl,(lab39CD)
    ld de,buf_fg+#62 ;-#880+#08E2
    add hl,de
    ld a,(hl)
    cp #8a
    jp nz,lab5918+1
    ld hl,(room_map_index+1)
    ld a,(hl)
    cp #3d              ; Special Room?
    jr z,lab585E
    cp #4d              ; Special Room?
    jp z,lab5844

lab5820
    ld a,(lab6386)
    xor #ee
    ld (lab6386),a

    ld a,(lab63BD)
    xor #ff
    ld (lab63BD),a

    ld hl,txt_liftdown
    inc a
    jr z,lab5839

lab5836 ld hl,txt_liftup
lab5839 ld c,#e
    ld de,#5066
    call draw_text
    jp lab2BB4

lab5844 ld a,(lab19E1+1)
    inc a
    jr z,lab5820
    ld hl,#312f+1
    ld a,(hl)
    xor #11
    ld (hl),a
    ld hl,lab590A+1
    ld c,#e
    inc a
    jr z,lab5839
    ld hl,lab58FD
    jr lab5839
lab585E ld de,#5066
    ld c,#e
    ld hl,lab52D6
    ld a,(lab52D7)
    or a
    jr z,lab586D
    ld (hl),a
lab586D ld a,(hl)
    or a
    jr z,lab58A3
    ld a,(lab58B6)
    cp (hl)
    jr nc,lab58AC
lab5877 ld a,(lab52D7)
    or a
    jr nz,lab5884
    push de
    push bc
    call lab9742
    pop bc
    pop de
lab5884 ld a,(lab52D6)
    ld (lab52D7),a
    ld hl,txt_code_accepted
    call draw_text
lab5890 ld de,lab5085
    ld (lab52D3),de
    inc de
    ld hl,lab8AAC
    ld c,#e
    call draw_text
    jp lab2BB4
lab58A3 ld hl,txt_code_needed
    call draw_text
    jp lab2BB4
lab58AC jr z,lab5877
    ld hl,txt_code_rejected
    call draw_text
    jr lab5890
    /*
db #cd,#fe,#53,#cd,#99 ;.....S..
db #51,#20,#11,#11,#9c,#50,#3e,#01 ;Q....P..
db #32,#b8,#5b,#32,#c2,#34,#21,#49 ;.......I
db #5b,#c3,#df,#5c,#3a,#96,#20,#fe
db #10,#ca,#4a,#59,#fe,#c8,#ca,#20 ;..JY....
db #96,#cd,#cb,#3e,#cb,#67,#ca,#38 ;.....g..
db #59,#3a,#4b,#51,#3c,#ca,#19,#59 ;Y.KQ...Y
db #2a,#cd,#39,#11,#e2,#08,#19,#7e
db #fe,#8a,#c2,#19,#59,#2a,#12,#1a ;....Y...
db #7e,#fe,#3d,#28,#43,#fe,#4d,#ca ;....C.M.
db #44,#58,#3a,#86,#63,#ee,#ee,#32 ;DX..c...
db #86,#63,#3a,#bd,#63,#ee,#ff,#32 ;.c..c...
db #bd,#63,#21,#e1,#58,#3c,#28,#03 ;.c..X...
db #21,#ef,#58,#0e,#0e,#11,#66,#50 ;..X...fP
db #cd,#34,#14,#c3,#b4,#2b,#3a,#e2
db #19,#3c,#28,#d6,#21,#30,#31,#7e
db #ee,#11,#77,#21,#0b,#59,#0e,#0e ;..w..Y..
db #3c,#28,#e0,#21,#fd,#58,#18,#db ;.....X..
db #11,#66,#50,#0e,#0e,#21,#d6,#52 ;.fP....R
db #3a,#d7,#52,#b7,#28,#01,#77,#7e ;..R...w.
db #b7,#28,#32,#3a,#b6,#58,#be,#30 ;.....X..
db #35,#3a,#d7,#52,#b7,#20,#07,#d5 ;...R....
db #c5,#cd,#42,#97,#c1,#d1,#3a,#d6 ;..B.....
db #52,#32,#d7,#52,#21,#c5,#58,#cd ;R..R..X.
db #34,#14,#11,#85,#50,#ed,#53,#d3 ;....P.S.
db #52,#13,#21,#ac,#8a,#0e,#0e,#cd ;R.......
db #34,#14,#c3,#b4,#2b,#21,#b7,#58 ;.......X
db #cd,#34,#14,#c3,#b4,#2b,#28,#c9
db #21,#d3,#58,#cd,#34,#14,#18,#da ;..X.....
*/
lab58B6 db #0

txt_code_needed:    db " CODE  NEEDED "
txt_code_accepted   db "CODE  ACCEPTED"
txt_code_rejected:  db "CODE  REJECTED"
txt_liftdown:       db " LIFT IS DOWN "
txt_liftup:         db "  LIFT IS UP  "
txt_fenceon:        db "  FENCE IS ON "
txt_fenceoff:       db " FENCE IS OFF "

lab5919
   db #3a,#96,#34,#b7,#28,#0b

lab591F
    ld a,#2
    ld de,lab4FA0
    ld hl,lab528E
    jp lab5CDC

lab592A
    ld a,#1
    ld (lab3C3B),a
    ld hl,lab5323
    ld de,lab4EDA
    jp lab5CDF

lab5938
    bit 1,a
    jr z,lab5956
lab593C
    ld a,(#39ec)
    cp #0
    jr z,lab594A
    dec a
    ld (#39ec),a
    jp lab2BB4
lab594A
    call lab5A4D
    ld hl,lab3C98
    ld de,lab4F04
    jp lab5CDF
lab5956
    bit 2,a
    jr z,lab59B2
    ld a,(#39ec)
    cp #0
    ld a,(lab5161)
    jr z,lab5967
    ld a,(lab5166)
lab5967
    cp #d4
    jr nz,lab597B
    ld a,(#0865)
    cp #8
    jr nz,lab597B
    call lab8A89
    ld hl,lab5BDF
    jp lab5CE3

lab597B
    ld a,(#39ec)
    cp #0
    ld a,(lab5163)
    jr z,lab5988
    ld a,(lab5164)
lab5988
    cp #2c
    jr z,lab5999
    cp #25
    jr z,lab5999
    cp #9
    jr z,lab5999
    cp #5
    jp nz,lab5272
lab5999
    ld hl,lab5A60
    ld de,lab4EAF+1
    ld (lab39F4+1),de
    ld (lab2BB1+1),hl
    jp lab5B08

lab59A9
    ld hl,lab5A60
    ld de,lab4EAF+1
    jp lab5CDF

lab59B2
    bit 0,a
    jr z,lab59D0
    ld a,(#39ec)
    cp #1
    jr z,lab59C4
    inc a
    ld (#39ec),a
    jp lab2BB4
lab59C4
    call lab5A4D
    ld hl,lab3BF7
    ld de,lab4F04
    jp lab5CDF
lab59D0
    bit 3,a
    jr z,lab5A4A
    ld a,(#39ec)
    or a
    jr nz,lab59FB
    ld hl,(lab39CD)
    ld de,dbuf_fg+#08C0
    add hl,de
    ld a,(hl)
    cp #62
    jr nz,lab59FB
    ld a,#fe
    ld (lab2096),a
    ld hl,lab3D9F
    ld de,lab4DB8+2
    ld a,#fd
    ld (lab2096),a
    ld a,#6d
    jp lab5CDC
lab59FB
    ld a,(#39ec)
    or a
    ld a,(lab5161)
    jr z,lab5A07
    ld a,(lab5166)
lab5A07
    cp #d4
    jr nz,lab5A1B
    ld a,(#0865)
    cp #8
lab5A10
    jr z,lab5A1B
    call lab8A89
    ld hl,lab5C4E
    jp lab5CE3
lab5A1B
    ld a,(#39ec)
    cp #0
    ld a,(lab515D)
    jr z,lab5A28
    ld a,(lab515E)
lab5A28
    cp #9
    jp z,lab59A9
    cp #5
    jp z,lab59A9
    cp #25
    jp z,lab59A9
    cp #2c
    jp z,lab59A9
    cp #10
    jp z,lab59A9
    ld hl,lab53C5
    ld de,lab4FF4
    jp lab5CDF
lab5A4A
    jp lab2BB4
lab5A4D
    ld hl,lab4F2E
    ld (lab3E3C+1),hl
    ld de,lab4F1C
    ld bc,#12
    ldir
    xor a
    ld (lab3E48),a
    ret

lab5A60
    ld a,(#39ec)
    cp #0
    ld a,(lab515D)
    jr z,lab5A6D
    ld a,(lab515E)
lab5A6D
    cp #5
    jr z,lab5A8C
    cp #9
    jr z,lab5A8C
    cp #10
    jr z,lab5A8C
    cp #25
    jr z,lab5A8C
    cp #2c
    jr z,lab5A8C
    cp #cc
    jr z,lab5A8C
    cp #ff
    jr z,lab5A8C
    jp lab5CE9
lab5A8C
    call lab3ECA+1
    bit 0,a
    jr z,lab5A9A
    ld a,#1
    ld (#39ec),a
    jr lab5AA2
lab5A9A
    bit 1,a
    jr z,lab5AB6
    xor a
    ld (#39ec),a
lab5AA2
    ld a,(lab515C)
    cp #c7
    jp nc,lab2BB4
    ld a,(lab5162)
    inc a
    cp #c7
    jp nc,lab5CE9
    jp lab2BB4
lab5AB6
    bit 3,a
    jr z,lab5AF1
    ld a,(lab39CC)
    dec a
    jp m,lab5AD2
    ld hl,(lab39CD)
    ld de,dbuf_mask+#0622
    add hl,de
    ld a,(hl)
    cp #cc
    jr z,lab5AD2
    cp #c7
    jp nc,lab2BB4
lab5AD2 call room_up
    ld a,(lab39CC)
    dec a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
lab5AE6 ld a,(#39ec)
    xor #1
    ld (#39ec),a
    jp lab2BB4
lab5AF1 bit 2,a
    jp z,lab2BB4
    ld a,(lab5163)
    inc a
    cp #c7
    jp nc,lab5CE9
    ld a,(lab5164)
    inc a
    cp #c7
    jp nc,lab5CE9
lab5B08 call lab5B1E
    ld a,(lab39CC)
lab5B0E inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    jr lab5AE6
lab5B1E ld a,(lab39CC)
    cp #b
    ret nz
    ld hl,Room_Y
    inc (hl)
    pop hl
    sub #11
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#fde0
    add hl,de
    ld de,#20

assert $==#5b38
lab5b38
    ld (lab39CD),hl
    ld hl,(room_map_index+1)
    add hl,de
    ld (room_map_index+1),hl
    xor a
    ld (lab4292+1),a
    jp lab1987

/*#22,#cd,#39,#2a,#12,#1a,#19
db #22,#12,#1a,#af,#32,#93,#42,#c3 ;......B.
db #87,#19
*/

assert $==#5b49
lab5B49:

call lab5B1E
    call lab5199
    jr z,lab5BC2
    ld a,(lab34C1)
    or a
    jr z,lab5BB7
    ld b,#14
    ld de,lab5B8F
    ld a,(lab34C1)
    dec a
    jr nz,lab5B65
    ld de,lab5BA3
lab5B65 ld hl,dbuf_fg+#986
    call lab43C3
    ld a,(lab2096)
    cp #fd
    jr nz,lab5B7B

    ld de,spr_11_5_209a
    ld bc,buf_fg
    call lab3D5A
lab5B7B
    ld de,data4d88
    ld bc,buf_mask
    call lab3D5A
    ld de,lab5072
    ld hl,lab5CD2
    ld a,#1e
    jp lab5CDC

lab5b8f:
    db #40,"MISSION"
    db #40,"TERMINATED"
    db #40

lab5ba3:
    db #40,#40
    db "MISSION"
    db #40,#40
    db "FAILURE"
    db #40,#40

lab5BB7 ld b,#1
    call lab95C0
    call lab979B
    jp lab5272
lab5BC2 ld hl,lab5BB7+1
    ld a,#fa
    cp (hl)
    jr z,lab5BCB
    inc (hl)
lab5BCB ld a,(lab39CC)
    inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    jp lab2BB4
lab5BDF ld a,#11
    ld (lab6386),a
    xor a
    ld (lab63BD),a
    call lab53FD+1
    call lab5B1E
    ld a,(lab39CC)
    inc a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#20
    add hl,de
    ld (lab39CD),hl
    ld de,buf_bg+#700-#640
    add hl,de
    ld b,#6
lab5C05 ld (hl),#8
    inc hl
    djnz lab5C05
    ld a,(lab39CC)
    cp #b
    jr z,lab5C2B
    ld de,#1a
    add hl,de
    ld de,lab738C
    ld b,#6
lab5C1A ld a,(de)
    ld (hl),a
    inc hl
    inc de
    djnz lab5C1A
    ld de,#fdc0
    add hl,de
    ld b,#6
lab5C26 dec hl
    ld (hl),#1
    djnz lab5C26
lab5C2B call lab3ECA+1
    ld hl,lab5C4E
    bit 3,a
    jp nz,lab5CE3
    ld a,#ff
    ld (lab6386),a
    ld (lab63BD),a
    ld hl,(lab39CD)
    ld de,buf_bg+#740-#640
    add hl,de
    ld a,(hl)
    cp #fa
    jp nz,lab2BB4
    jp lab5272
lab5C4E ld a,#ff
    ld (lab6386),a
    ld (lab63BD),a
    call lab53FD+1
    call room_up
    ld a,(lab39CC)
    dec a
    ld (lab39CC),a
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
    ld a,(lab39CC)
    cp #b
    jr z,lab5CA0
    ld de,buf_bg+#0720-#640
    add hl,de
    ld b,#6
    ld de,lab738C
lab5C7D ld a,(de)
    ld (hl),a
    inc hl
    inc de
    djnz lab5C7D
    ld a,(lab39CC)
    cp #a
    jr z,lab5CA0
    ld de,#1a
    add hl,de
    ld b,#6
lab5C90 ld (hl),#8
    inc hl
    djnz lab5C90
    ld de,#fdc0
    add hl,de
    ld b,#6
lab5C9B dec hl
    ld (hl),#1
    djnz lab5C9B
lab5CA0 call lab3ECA+1
    ld hl,lab5BDF
    bit 2,a
    jp nz,lab5CE3
    ld a,#11
    ld (lab6386),a
    xor a
    ld (lab63BD),a
    ld hl,(lab39CD)
    ld de,buf_bg+#6FF-#640
    add hl,de
    ld a,(hl)
    cp #8
    jp nz,lab2BB4
    ld hl,lab39CC
    dec (hl)
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
    jp lab5CE9
lab5CD2 ld hl,lab3C3B
    dec (hl)
    jp nz,lab2BB4
    jp lab8FB0
lab5CDC
    ld (lab3C3B),a
lab5CDF
    ld (lab39F5),de
lab5CE3
    ld (lab2BB1+1),hl
    jp lab2BB4

lab5CE9 xor a
    ld (lab34C2),a
    ld hl,lab57D1
    ld de,lab4E87
    jp lab5CDF


lab5CF6 exx
lab5CF7 ld bc,lab513C
lab5CFA ld hl,(lab39CD)
    push de
    ld de,buf_bg
    add hl,de
    pop de
    exx
    ld a,c
    ld (lab5D0F+1),a
    push hl
lab5d09
	ld hl,5
    add hl,de
    ex de,hl
    pop hl
lab5D0F ld c,#6
    exx
lab5D12 ld e,#0
    exx
lab5D15 exx
    ld a,e
    exx
    cp #20
    jr nc,lab5D2D
    exx
    ld a,d
    exx
    cp #12
    jr nc,lab5D2D
    exx
    ld a,(hl)
lab5D25 nop
    exx
    cp #c7
    jr nc,lab5D2D
    ld a,(de)
    ld (hl),a

lab5D2D exx
    inc e
    inc hl
    dec bc
    exx
    inc hl
    dec de
    dec c
    jr nz,lab5D15
    push de
lab5D38 ld de,#001A
    add hl,de
    pop de
    push hl
lab5D3E
    ld hl,#000C
    add hl,de
    ex de,hl
    pop hl
    exx
    inc d
    push de
lab5D47
    ld de,#001A
    add hl,de
    push hl
    push bc
    pop hl
lab5D4E
    ld de,#000C
    add hl,de
    push hl
    pop bc
    pop hl
    pop de
    exx
    djnz lab5D0F
    ret

data5d5a
lab5D5A ld a,(lab39CB)
    cp #1d
    jp z,lab3C64
    cp #1a
    jr nc,lab5D75
    ld hl,(lab39CD)
    ld de,dbuf_bg+#706
    add hl,de
    ld a,(hl)
    cp #c7
    jr nc,lab5D80
    ld a,(lab39CB)
lab5D75 inc a
    ld (lab39CB),a
    ld hl,(lab39CD)
    inc hl
    ld (lab39CD),hl
lab5D80 call lab5DE4
    call lab3ECA+1
    bit 0,a
lab5D88
    jp z,lab5272
    ld de,dbuf_fg+#8E2
    call lab5DAA
    ld hl,(lab39CD)
    add hl,de
    ld a,(hl)
    or a
    jr nz,lab5DA7
    ld hl,lab39CC
    dec (hl)
    ld hl,(lab39CD)
    ld de,#ffe0
    add hl,de
    ld (lab39CD),hl
lab5DA7 jp lab2BB4

lab5DAA ld a,(lab39CB)
    cp #fd
    ret nz
    inc de
    ret


lab5DB2
    ld a,(lab39CB)
    cp #fd
    jp z,lab3C82
    cp #1
    jp m,lab5DCE
    ld hl,(lab39CD)
    ld de,dbuf_bg + #6FF
    add hl,de
    ld a,(hl)
    cp #c7
    jr nc,lab5DD9
    ld a,(lab39CB)
lab5DCE dec a
    ld (lab39CB),a
    ld hl,(lab39CD)
    dec hl
    ld (lab39CD),hl
lab5DD9
    call lab5DE4
    call lab3ECA+1
    bit 1,a
    jp lab5D88
lab5DE4 ld a,(lab4FE1)
    xor #7
    ld (lab4FE1),a
    ret

assert $==#5ded

PATTERN_BG EQU 1
PATTERN_TOWER1 EQU 2
PATTERN_TOWER2 EQU 3
; ...
MACRO M_END
  db #FF
MEND

MACRO M_HLINE pattern,num,addr  ;0x2224
  db #00
  db {pattern}
  db {num}
  dw {addr}
MEND
MACRO M_VLINE pattern,num,addr  ;0x223c
  db #01
  db {pattern}
  db {num}
  dw {addr}
MEND
MACRO M_RECT width,height,pattern,addr  ;0x29a7
  db #02
  db {width}
  db {height}
  db {pattern}
  dw {addr}
MEND
MACRO M_FILL_BG pattern  ;0x21f9
  db #03
  db {pattern}
MEND
MACRO M_poke_byte pattern,addr  ;0x220b
  db #04
  db {pattern}
  dw {addr}
MEND
MACRO M_draw_sprite_3x4_7398 pattern  ;0x1ebf
  db #05
  db {pattern}
MEND
MACRO M_draw_rline pattern,num,addr  ;0x2232
  db #06
  db {pattern}
  db {num}
  dw {addr}
MEND
MACRO M_draw_lline pattern,num,addr  ;0x2237
  db #07
  db {pattern}
  db {num}
  dw {addr}
MEND
MACRO M_draw_2b_ldiag_pattern_05 pattern,addr  ;0x225c
  db #08
  db {pattern}
  dw {addr}
MEND
MACRO M_4x3_spr_8x6 v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12  ;0x2274
  db #09
  db {v1}
  db {v2}
  db {v3}
  db {v4}
  db {v5}
  db {v6}
  db {v7}
  db {v8}
  db {v9}
  db {v10}
  db {v11}
  db {v12}
MEND
MACRO M_lab2983 pattern,v1,addr  ;0x2983
  db #0a
  db {pattern}
  db {v1}
  dw {addr}
MEND
MACRO M_lab296b pattern,v1,addr  ;0x296b
  db #0b
  db {pattern}
  db {v1}
  dw {addr}
MEND
MACRO M_lab2970 pattern,v1,addr  ;0x2970
  db #0c
  db {pattern}
  db {v1}
  dw {addr}
MEND
MACRO M_lab297e pattern,v1,addr  ;0x297e
  db #0d
  db {pattern}
  db {v1}
  dw {addr}
MEND
MACRO M_draw_2b_ldiag_pattern_09 pattern,addr  ;0x2254
  db #0e
  db {pattern}
  dw {addr}
MEND
MACRO M_poke_CACB addr  ;0x2216
  db #0f
  dw {addr}
MEND
MACRO M_lab1da8   ;0x1da8
  db #10
MEND
MACRO M_draw_spr_6x1_738c addr  ;0x1f22
  db #11
  dw {addr}
MEND
MACRO M_draw_spr_5x4_tree   ;0x1e47
  db #12
MEND
MACRO M_MOON   ;0x1f72
  db #13
MEND
MACRO M_draw_spr_2x6_1f0a addr  ;0x1ef6
  db #14
  dw {addr}
MEND
MACRO M_draw_spr_2x6_1f16 addr  ;0x1f00
  db #15
  dw {addr}
MEND
MACRO M_draw_spr_2x3_1e77 pattern  ;0x1e69
  db #16
  db {pattern}
MEND
MACRO M_draw_spr_2x3_1e8B   ;0x1e7d
  db #17
MEND
MACRO M_draw_spr_3x3_1e9f   ;0x1e91
  db #18
MEND
MACRO M_draw_spr_3x3_1eb6   ;0x1ea8
  db #19
MEND
MACRO M_lab21eb width,height,addr  ;0x21eb
  db #1a
  db {width}
  db {height}
  dw {addr}
MEND
MACRO M_lab21f5   ;0x21f5
  db #1b
MEND
MACRO M_draw_spr_1ECD addr  ;0x1eec
  db #1c
  dw {addr}
MEND
MACRO M_draw_spr_3x3_1f47   ;0x1f61
  db #1d
MEND
MACRO M_draw_2b_ldiag_pattern_25 pattern,addr  ;0x2258
  db #1e
  db {pattern}
  dw {addr}
MEND
MACRO M_draw_spr_2x2_1f50 width,height,addr  ;0x1f54
  db #1f
  db {width}
  db {height}
  dw {addr}
MEND
MACRO M_draw_spr_3x2_1edc addr  ;0x1ee2
  db #20
  dw {addr}
MEND
MACRO M_draw_2b_ldiag_pattern_2c pattern,addr  ;0x2250
  db #21
  db {pattern}
  dw {addr}
MEND
MACRO M_draw_21b4 pattern  ;0x21b4
  db #22
  db {pattern}
MEND
MACRO M_draw_21b8 pattern  ;0x21b8
  db #23
  db {pattern}
MEND
MACRO M_draw_21bc   ;0x21bc
  db #24
MEND
MACRO M_lab1ff6   ;0x1ff6
  db #25
MEND
MACRO M_draw_desk pattern  ;0x2023
  db #26
  db {pattern}
MEND
MACRO M_lab1fa4   ;0x1fa4
  db #27
MEND
MACRO M_draw_spr_7x9_1b9e   ;0x1df5
  db #28
MEND
MACRO M_lab1e1a   ;0x1e1a
  db #29
MEND
MACRO M_lab1de8   ;0x1de8
  db #2a
MEND
MACRO M_spr_5_3_1bdd   ;0x1ddd
  db #2b
MEND
MACRO M_lab1dd8   ;0x1dd8
  db #2c
MEND
MACRO M_lab1dd3   ;0x1dd3
  db #2d
MEND
MACRO M_lab1e24   ;0x1e24
  db #2e
MEND
MACRO M_lab1dc1   ;0x1dc1
  db #2f
MEND
MACRO M_lab1d9a   ;0x1d9a
  db #30
MEND
MACRO M_lab1d95   ;0x1d95
  db #31
MEND
MACRO M_lab1d88   ;0x1d88
  db #32
MEND
MACRO M_draw_bureau_chaise   ;0x1d7b
  db #33
MEND
MACRO M_lab1d76   ;0x1d76
  db #34
MEND
MACRO M_lab1dad   ;0x1dad
  db #35
MEND
MACRO M_lab1db2   ;0x1db2
  db #36
MEND
MACRO M_lab1db7   ;0x1db7
  db #37
MEND
MACRO M_lab1fe4   ;0x1fe4
  db #38
MEND
MACRO M_lab1fdf   ;0x1fdf
  db #39
MEND
MACRO M_lab1d71   ;0x1d71
  db #3a
MEND
MACRO M_lab1d6c   ;0x1d6c
  db #3b
MEND
MACRO M_lab1da3   ;0x1da3
  db #3c
MEND
MACRO M_lab1d67   ;0x1d67
  db #3d
MEND
MACRO M_lab1dbc   ;0x1dbc
  db #3e
MEND
MACRO M_lab1e1f   ;0x1e1f
  db #3f
MEND
MACRO M_lab1fd4   ;0x1fd4
  db #40
MEND
MACRO M_draw_1e0d   ;0x1e0d
  db #41
MEND
MACRO M_lab1e03   ;0x1e03
  db #42
MEND
MACRO M_lab1e08   ;0x1e08
  db #43
MEND
MACRO M_draw_2979   ;0x2979
  db #44
MEND
MACRO M_draw_222d   ;0x222d
  db #45
MEND
MACRO M_draw_2031   ;0x2031
  db #46
MEND
MACRO M_lab208e   ;0x208e
  db #47
MEND
MACRO M_draw_2044   ;0x2044
  db #48
MEND
MACRO M_lab2076   ;0x2076
  db #49
MEND
MACRO M_lab2068   ;0x2068
  db #4a
MEND
MACRO M_lab2084   ;0x2084
  db #4b
MEND
MACRO M_lab2089   ;0x2089
  db #4c
MEND
MACRO M_lab1fcf   ;0x1fcf
  db #4d
MEND
MACRO M_lab1fe9   ;0x1fe9
  db #4e
MEND
MACRO M_lab1fca   ;0x1fca
  db #4f
MEND
MACRO M_lab1fc5   ;0x1fc5
  db #50
MEND
MACRO M_lab1fc0   ;0x1fc0
  db #51
MEND
MACRO M_lab1fbb   ;0x1fbb
  db #52
MEND
MACRO M_lab1fb6   ;0x1fb6
  db #53
MEND
MACRO M_draw_desk_0   ;0x1d62
  db #54
MEND
MACRO M_draw_desk_1   ;0x1d5d
  db #55
MEND
MACRO M_draw_desk_2   ;0x1d58
  db #56
MEND
MACRO M_draw_desk_3   ;0x1d53
  db #57
MEND
MACRO M_draw_desk_4   ;0x1d4e
  db #58
MEND
MACRO M_draw_desk_5   ;0x1d49
  db #59
MEND
MACRO M_draw_desk_6   ;0x1d44
  db #5a
MEND
MACRO M_draw_desk_7   ;0x1d3f
  db #5b
MEND
MACRO M_draw_desk_8   ;0x1d3a
  db #5c
MEND
MACRO M_draw_desk_9   ;0x1d35
  db #5d
MEND
MACRO M_draw_desk_a   ;0x1d30
  db #5e
MEND
MACRO M_draw_desk_b   ;0x1d2b
  db #5f
MEND
MACRO M_draw_desk_c   ;0x1d26
  db #60
MEND
MACRO M_lab1fb1   ;0x1fb1
  db #61
MEND
MACRO M_draw_screen1   ;0x1d0b
  db #62
MEND
MACRO M_draw_screen2   ;0x1d10
  db #63
MEND
MACRO M_draw_screen3   ;0x1d06
  db #64
MEND
MACRO M_draw_screen4   ;0x1d01
  db #65
MEND
MACRO M_lab1cef   ;0x1cef
  db #66
MEND
MACRO M_lab1dce   ;0x1dce
  db #67
MEND
MACRO M_lab1cd3   ;0x1cd3
  db #68
MEND
MACRO M_lab1ce1   ;0x1ce1
  db #69
MEND
assert $==#5ded
room_00: ;#5ded
   M_FILL_BG #01
   M_MOON 
   M_END

assert $==#5df1
room_01: ;#5df1
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_HLINE #11,#fc,#100+buf_bg ;#740
   M_HLINE #20,#fa,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #0f,#31+buf_bg ;#671
   M_draw_screen3 
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#5e08
room_02: ;#5e08
   M_HLINE #44,#fa,#1fc+buf_bg ;#83c
   M_HLINE #02,#fa,#1de+buf_bg ;#81e
   M_RECT #04,#02,#fc,#200+buf_bg ;#840
   M_RECT #02,#05,#fa,#1e+buf_bg ;#65e
   M_draw_2b_ldiag_pattern_2c #02,#20b+buf_bg ;#84b
   M_draw_spr_7x9_1b9e 
   M_lab1e1a 
   M_lab1d88 
   M_END

assert $==#5e26
room_03: ;#5e26
   M_RECT #0a,#12,#fa,#00+buf_bg ;#640
   M_RECT #08,#08,#00,#c0+buf_bg ;#700
   M_RECT #07,#12,#fa,#19+buf_bg ;#659
   M_VLINE #02,#f7,#e9+buf_bg ;#729
   M_VLINE #02,#00,#e8+buf_bg ;#728
   M_RECT #05,#06,#fb,#12f+buf_bg ;#76f
   M_RECT #07,#02,#fb,#20e+buf_bg ;#84e
   M_HLINE #11,#f9,#29+buf_bg ;#669
   M_HLINE #03,#f8,#110+buf_bg ;#750
   M_HLINE #05,#f8,#1ef+buf_bg ;#82f
   M_poke_byte #f6,#10f+buf_bg ;#74f
   M_poke_byte #f5,#113+buf_bg ;#753
   M_poke_byte #f6,#1ee+buf_bg ;#82e
   M_poke_byte #f5,#1f4+buf_bg ;#834
   M_draw_sprite_3x4_7398 #22
   M_END

assert $==#5e70
room_04: ;#5e70
   M_FILL_BG #01
   M_MOON 
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_VLINE #0a,#02,#0c+buf_bg ;#64c
   M_VLINE #0a,#02,#17+buf_bg ;#657
   M_HLINE #0a,#f2,#12d+buf_bg ;#76d
   M_draw_lline #05,#f3,#14c+buf_bg ;#78c
   M_draw_lline #05,#03,#14b+buf_bg ;#78b
   M_draw_lline #03,#03,#155+buf_bg ;#795
   M_draw_lline #04,#f3,#156+buf_bg ;#796
   M_draw_rline #05,#f1,#157+buf_bg ;#797
   M_draw_rline #05,#04,#158+buf_bg ;#798
   M_draw_rline #04,#f1,#14d+buf_bg ;#78d
   M_draw_rline #03,#04,#14e+buf_bg ;#78e
   M_draw_2b_ldiag_pattern_05 #0f,#11+buf_bg ;#651
   M_poke_CACB #131+buf_bg ;#771
   M_lab1cd3 
   M_END

assert $==#5eb8
room_05: ;#5eb8
   M_FILL_BG #01
   M_MOON 
   M_VLINE #12,#02,#0c+buf_bg ;#64c
   M_VLINE #12,#02,#17+buf_bg ;#657
   M_HLINE #0a,#f2,#8d+buf_bg ;#6cd
   M_HLINE #0a,#f2,#1ed+buf_bg ;#82d
   M_draw_2b_ldiag_pattern_05 #12,#11+buf_bg ;#651
   M_lab1cd3 
   M_END

assert $==#5ed5
room_06: ;#5ed5
   M_FILL_BG #01
   M_MOON 
   M_VLINE #05,#02,#1ac+buf_bg ;#7ec
   M_VLINE #05,#02,#1b7+buf_bg ;#7f7
   M_VLINE #0c,#02,#16+buf_bg ;#656
   M_VLINE #0c,#02,#14+buf_bg ;#654
   M_VLINE #03,#02,#135+buf_bg ;#775
   M_HLINE #14,#f2,#187+buf_bg ;#7c7
   M_draw_2b_ldiag_pattern_05 #06,#191+buf_bg ;#7d1
   M_HLINE #07,#07,#180+buf_bg ;#7c0
   M_lab1cd3 
   M_END

assert $==#5f01
room_07: ;#5f01
   M_FILL_BG #01
   M_MOON 
   M_HLINE #20,#07,#180+buf_bg ;#7c0
   M_END

assert $==#5f0a
room_08: ;#5f0a
   M_FILL_BG #01
   M_MOON 
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_spr_5_3_1bdd 
   M_lab1dd3 
   M_END

assert $==#5f15
room_09: ;#5f15
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_HLINE #06,#fa,#100+buf_bg ;#740
   M_HLINE #1a,#fc,#106+buf_bg ;#746
   M_HLINE #14,#fa,#0c+buf_bg ;#64c
   M_draw_lline #07,#fa,#2b+buf_bg ;#66b
   M_draw_lline #07,#fa,#2c+buf_bg ;#66c
   M_lab2983 #07,#01,#05+buf_bg ;#645
   M_RECT #05,#08,#01,#00+buf_bg ;#640
   M_draw_screen4 
   M_END

assert $==#5f40
room_0A: ;#5f40
   M_FILL_BG #01
   M_MOON 
   M_HLINE #12,#fa,#1ee+buf_bg ;#82e
   M_HLINE #13,#fa,#20d+buf_bg ;#84d
   M_HLINE #14,#fa,#22c+buf_bg ;#86c
   M_lab1dd8 
   M_END

assert $==#5f54
room_0B: ;#5f54
   M_FILL_BG #01
   M_MOON 
   M_RECT #0a,#03,#fa,#1e0+buf_bg ;#820
   M_RECT #07,#03,#fa,#1f9+buf_bg ;#839
   M_HLINE #11,#f9,#209+buf_bg ;#849
   M_lab1d9a 
   M_END

assert $==#5f6a
room_0C: ;#5f6a
   M_FILL_BG #01
   M_MOON 
   M_HLINE #2c,#fc,#214+buf_bg ;#854
   M_RECT #14,#02,#fa,#200+buf_bg ;#840
   M_HLINE #07,#fa,#119+buf_bg ;#759
   M_draw_lline #07,#fa,#138+buf_bg ;#778
   M_draw_lline #07,#fa,#139+buf_bg ;#779
   M_lab2970 #06,#00,#1f4+buf_bg ;#834
   M_RECT #06,#07,#00,#13a+buf_bg ;#77a
   M_END

assert $==#5f93
room_0D: ;#5f93
   M_FILL_BG #01
   M_MOON 
   M_RECT #1d,#02,#fa,#203+buf_bg ;#843
   M_END

assert $==#5f9d
room_0E: ;#5f9d
   M_FILL_BG #01
   M_MOON 
   M_HLINE #20,#fe,#1e0+buf_bg ;#820
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_END

assert $==#5fab
room_0F: ;#5fab
   M_FILL_BG #01
   M_MOON 
   M_HLINE #20,#fe,#1e0+buf_bg ;#820
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_RECT #02,#06,#10,#133+buf_bg ;#773
   M_HLINE #05,#cc,#112+buf_bg ;#752
   M_RECT #0b,#06,#1e,#4d+buf_bg ;#68d
   M_draw_spr_5x4_tree 
   M_draw_spr_1ECD #2e+buf_bg ;#66e
   M_draw_spr_1ECD #ad+buf_bg ;#6ed
   M_draw_spr_1ECD #4c+buf_bg ;#68c
   M_draw_spr_1ECD #8b+buf_bg ;#6cb
   M_draw_spr_3x2_1edc #33+buf_bg ;#673
   M_draw_spr_3x2_1edc #96+buf_bg ;#6d6
   M_draw_spr_3x2_1edc #55+buf_bg ;#695
   M_poke_byte #7f,#1b2+buf_bg ;#7f2
   M_poke_byte #80,#1d2+buf_bg ;#812
   M_END

assert $==#5fe8
room_10: ;#5fe8
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#04,#fa,#00+buf_bg ;#640
   M_RECT #04,#06,#fa,#180+buf_bg ;#7c0
   M_HLINE #0b,#f2,#184+buf_bg ;#7c4
   M_HLINE #11,#07,#18f+buf_bg ;#7cf
   M_draw_lline #04,#03,#1a7+buf_bg ;#7e7
   M_draw_lline #05,#f3,#1a8+buf_bg ;#7e8
   M_END

assert $==#600d
room_11: ;#600d
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_END

assert $==#6017
room_12: ;#6017
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_poke_byte #fa,#204+buf_bg ;#844
   M_VLINE #0e,#01,#43+buf_bg ;#683
   M_VLINE #06,#01,#42+buf_bg ;#682
   M_RECT #02,#03,#01,#141+buf_bg ;#781
   M_END

assert $==#6035
room_13: ;#6035
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#03,#fa,#1e0+buf_bg ;#820
   M_END

assert $==#603f
room_14: ;#603f
   M_RECT #04,#0f,#01,#00+buf_bg ;#640
   M_RECT #03,#06,#fa,#03+buf_bg ;#643
   M_HLINE #1a,#fc,#06+buf_bg ;#646
   M_HLINE #08,#fa,#1e3+buf_bg ;#823
   M_HLINE #03,#fe,#1e0+buf_bg ;#820
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_VLINE #0a,#02,#a4+buf_bg ;#6e4
   M_HLINE #04,#fc,#fc+buf_bg ;#73c
   M_lab1fa4 
   M_END

assert $==#606b
room_15: ;#606b
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#02,#fa,#00+buf_bg ;#640
   M_RECT #0a,#04,#fa,#40+buf_bg ;#680
   M_RECT #08,#09,#00,#c0+buf_bg ;#700
   M_HLINE #0e,#fa,#1c0+buf_bg ;#800
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_HLINE #12,#fe,#1ee+buf_bg ;#82e
   M_VLINE #08,#20,#c8+buf_fg ;#948
   M_END

assert $==#6095
room_16: ;#6095
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#03,#fa,#00+buf_bg ;#640
   M_RECT #04,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #07,#f2,#204+buf_bg ;#844
   M_VLINE #0d,#02,#42+buf_bg ;#682
   M_END

assert $==#60af
room_17: ;#60af
   M_HLINE #3a,#fc,#206+buf_bg ;#846
   M_RECT #03,#12,#01,#00+buf_bg ;#640
   M_RECT #03,#12,#fa,#03+buf_bg ;#643
   M_draw_spr_7x9_1b9e 
   M_lab1e1f 
   M_draw_screen1 
   M_END

assert $==#60c4
room_18: ;#60c4
   M_HLINE #1a,#fc,#06+buf_bg ;#646
   M_RECT #04,#03,#fc,#1bc+buf_bg ;#7fc
   M_HLINE #27,#fc,#219+buf_bg ;#859
   M_VLINE #09,#02,#a4+buf_bg ;#6e4
   M_RECT #04,#12,#01,#00+buf_bg ;#640
   M_RECT #03,#05,#fa,#03+buf_bg ;#643
   M_RECT #03,#04,#fa,#1c3+buf_bg ;#803
   M_draw_2b_ldiag_pattern_2c #01,#236+buf_bg ;#876
   M_lab1fb1 
   M_draw_screen1 
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#60f4
room_19: ;#60f4
   M_HLINE #26,#fc,#03+buf_bg ;#643
   M_HLINE #3a,#fc,#206+buf_bg ;#846
   M_RECT #06,#08,#fa,#140+buf_bg ;#780
   M_RECT #03,#05,#01,#1a0+buf_bg ;#7e0
   M_RECT #03,#0b,#01,#00+buf_bg ;#640
   M_RECT #03,#04,#fa,#03+buf_bg ;#643
   M_draw_2b_ldiag_pattern_2c #10,#16+buf_bg ;#656
   M_draw_spr_7x9_1b9e 
   M_END

assert $==#611c
room_1A: ;#611c
   M_HLINE #06,#fc,#00+buf_bg ;#640
   M_HLINE #0a,#fc,#200+buf_bg ;#840
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_HLINE #04,#6f,#230+buf_bg ;#870
   M_draw_2b_ldiag_pattern_2c #11,#23+buf_bg ;#663
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#6137
room_1B: ;#6137
   M_HLINE #20,#fc,#1a0+buf_bg ;#7e0
   M_HLINE #06,#6f,#1b4+buf_bg ;#7f4
   M_draw_screen1 
   M_draw_screen2 
   M_MOON 
   M_lab1d71 
   M_lab1da3 
   M_lab1d6c 
   M_END

assert $==#6148
room_1C: ;#6148
   M_4x3_spr_8x6 #05,#06,#02,#05,#05,#06,#02,#05,#05,#06,#02,#05
   M_draw_2b_ldiag_pattern_09 #12,#0f+buf_bg ;#64f
   M_END

assert $==#615a
room_1D: ;#615a
   M_4x3_spr_8x6 #05,#05,#05,#05,#0e,#04,#04,#0e,#01,#01,#01,#01
   M_END

assert $==#6168
room_1E: ;#6168
   M_4x3_spr_8x6 #05,#06,#02,#05,#04,#07,#02,#05,#01,#01,#03,#05
   M_draw_2b_ldiag_pattern_09 #0f,#0f+buf_bg ;#64f
   M_END

assert $==#617a
room_1F: ;#617a
   M_4x3_spr_8x6 #05,#06,#02,#05,#05,#06,#0b,#0e,#05,#08,#01,#01
   M_draw_2b_ldiag_pattern_09 #0f,#0f+buf_bg ;#64f
   M_END

assert $==#618c
room_20: ;#618c
   M_4x3_spr_8x6 #05,#05,#05,#05,#04,#0e,#0d,#05,#01,#09,#02,#05
   M_draw_2b_ldiag_pattern_09 #0c,#cf+buf_bg ;#70f
   M_HLINE #06,#f2,#1e9+buf_bg ;#829
   M_END

assert $==#61a3
room_21: ;#61a3
   M_4x3_spr_8x6 #05,#05,#05,#05,#05,#0c,#0e,#04,#05,#06,#0a,#01
   M_draw_2b_ldiag_pattern_09 #0c,#cf+buf_bg ;#70f
   M_HLINE #05,#f2,#1f1+buf_bg ;#831
   M_END

assert $==#61ba
room_22: ;#61ba
   M_4x3_spr_8x6 #05,#06,#02,#05,#04,#07,#0b,#0e,#01,#01,#01,#01
   M_draw_2b_ldiag_pattern_09 #0f,#0f+buf_bg ;#64f
   M_END

assert $==#61cc
room_23: ;#61cc
   M_4x3_spr_8x6 #05,#05,#05,#05,#04,#0e,#04,#0e,#01,#09,#0a,#01
   M_HLINE #0d,#f2,#1e9+buf_bg ;#829
   M_draw_2b_ldiag_pattern_09 #0c,#cf+buf_bg ;#70f
   M_END

assert $==#61e3
room_24: ;#61e3
   M_4x3_spr_8x6 #05,#06,#02,#05,#05,#06,#0b,#04,#05,#06,#0a,#01
   M_draw_2b_ldiag_pattern_09 #12,#0f+buf_bg ;#64f
   M_HLINE #05,#f2,#1f1+buf_bg ;#831
   M_END

assert $==#61fa
room_25: ;#61fa
   M_4x3_spr_8x6 #05,#06,#02,#05,#0e,#07,#02,#05,#01,#09,#02,#05
   M_draw_2b_ldiag_pattern_09 #12,#0f+buf_bg ;#64f
   M_HLINE #06,#f2,#1e9+buf_bg ;#829
   M_END

assert $==#6211
room_26: ;#6211
   M_4x3_spr_8x6 #05,#06,#02,#05,#04,#07,#0b,#04,#01,#09,#0a,#01
   M_HLINE #0d,#f2,#1e9+buf_bg ;#829
   M_draw_2b_ldiag_pattern_09 #12,#0f+buf_bg ;#64f
   M_END

assert $==#6228
room_27: ;#6228
   M_4x3_spr_8x6 #05,#05,#05,#05,#05,#0c,#04,#0e,#05,#08,#01,#01
   M_END

assert $==#6236
room_28: ;#6236
   M_4x3_spr_8x6 #05,#05,#05,#05,#0e,#04,#0d,#05,#01,#01,#03,#05
   M_END

assert $==#6244
room_29: ;#6244
   M_4x3_spr_8x6 #0c,#07,#0b,#0d,#06,#00,#00,#02,#08,#01,#01,#03
   M_draw_2b_ldiag_pattern_09 #0f,#0f+buf_bg ;#64f
   M_END

assert $==#6256
room_2A: ;#6256
   M_4x3_spr_8x6 #05,#05,#05,#05,#04,#0e,#0e,#04,#01,#01,#01,#01
   M_END

assert $==#6264
room_2B: ;#6264
   M_4x3_spr_8x6 #0f,#0f,#0f,#0f,#00,#00,#00,#00,#01,#01,#01,#01
   M_lab1d9a 
   M_lab1dd8 
   M_END

assert $==#6274
room_2C: ;#6274
   M_4x3_spr_8x6 #10,#10,#10,#10,#10,#10,#10,#10,#11,#10,#10,#10
   M_MOON 
   M_END

assert $==#6283
room_2D: ;#6283
   M_4x3_spr_8x6 #12,#10,#10,#10,#12,#10,#10,#10,#12,#10,#10,#10
   M_MOON 
   M_END

assert $==#6292
room_2E: ;#6292
   M_4x3_spr_8x6 #12,#10,#10,#10,#13,#10,#10,#10,#14,#10,#10,#10
   M_MOON 
   M_END

assert $==#62a1
room_2F: ;#62a1
   M_4x3_spr_8x6 #0c,#04,#04,#0e,#07,#00,#00,#00,#01,#01,#09,#00
   M_END

assert $==#62af
room_30: ;#62af
   M_4x3_spr_8x6 #04,#0e,#04,#0e,#00,#00,#00,#00,#00,#00,#00,#00
   M_END

assert $==#62bd
room_31: ;#62bd
   M_4x3_spr_8x6 #04,#0e,#0d,#05,#00,#00,#0b,#04,#00,#00,#0a,#01
   M_END

assert $==#62cb
room_32: ;#62cb
   M_4x3_spr_8x6 #05,#05,#06,#00,#05,#0c,#07,#00,#05,#06,#00,#00
   M_END

assert $==#62d9
room_33: ;#62d9
   M_4x3_spr_8x6 #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
   M_END

assert $==#62e7
room_34: ;#62e7
   M_4x3_spr_8x6 #00,#00,#0b,#0d,#00,#00,#00,#0b,#00,#00,#00,#0a
   M_END

assert $==#62f5
room_35: ;#62f5
   M_4x3_spr_8x6 #05,#08,#09,#00,#05,#05,#08,#01,#05,#05,#05,#05
   M_END

assert $==#6303
room_36: ;#6303
   M_4x3_spr_8x6 #00,#0a,#01,#09,#01,#03,#05,#06,#05,#05,#05,#08
   M_draw_lline #05,#03,#8b+buf_bg ;#6cb
   M_draw_lline #05,#f3,#8c+buf_bg ;#6cc
   M_END

assert $==#631b
room_37: ;#631b
   M_4x3_spr_8x6 #00,#00,#00,#02,#00,#00,#00,#0b,#01,#01,#01,#01
   M_END

assert $==#6329
room_38: ;#6329
   M_FILL_BG #01
   M_MOON 
   M_HLINE #1d,#fe,#1e3+buf_bg ;#823
   M_RECT #03,#10,#fa,#00+buf_bg ;#640
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_HLINE #0e,#f2,#209+buf_bg ;#849
   M_HLINE #0a,#08,#22b+buf_bg ;#86b
   M_HLINE #0c,#01,#1ea+buf_bg ;#82a
   M_draw_2b_ldiag_pattern_09 #02,#20f+buf_bg ;#84f
   M_END

assert $==#6350
room_39: ;#6350
   M_lab1ce1 
   M_FILL_BG #01
   M_MOON 
   M_RECT #03,#0f,#fa,#00+buf_bg ;#640
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_END

assert $==#6360
room_3A: ;#6360
   M_FILL_BG #fa
   M_RECT #1f,#0c,#08,#01+buf_bg ;#641
   M_RECT #06,#06,#08,#185+buf_bg ;#7c5
   M_RECT #0f,#03,#08,#191+buf_bg ;#7d1
   M_lab297e #02,#08,#18f+buf_bg ;#7cf
   M_VLINE #06,#d5,#184+buf_bg ;#7c4
   M_draw_screen2 
   M_draw_screen3 
   M_MOON 
   M_VLINE #06,#d4,#18b+buf_bg ;#7cb
   M_draw_spr_6x1_738c #185+buf_bg ;#7c5
   M_END

assert $==#638a
room_3B: ;#638a
   M_FILL_BG #fa
   M_RECT #06,#12,#08,#05+buf_bg ;#645
   M_VLINE #12,#d5,#04+buf_bg ;#644
   M_VLINE #12,#d4,#0b+buf_bg ;#64b
   M_lab1e24 
   M_END

assert $==#639e
room_3C: ;#639e
   M_FILL_BG #fa
   M_RECT #1b,#0e,#08,#05+buf_bg ;#645
   M_HLINE #15,#fa,#0b+buf_bg ;#64b
   M_HLINE #0e,#08,#1d2+buf_bg ;#812
   M_draw_spr_6x1_738c #1a5+buf_bg ;#7e5
   M_VLINE #0e,#d5,#04+buf_bg ;#644
   M_VLINE #0d,#20,#2b+buf_fg ;#8ab
   M_HLINE #06,#08,#1a5+buf_bg ;#7e5
   M_END

assert $==#63c3
room_3D: ;#63c3
   M_RECT #0a,#12,#fa,#00+buf_bg ;#640
   M_RECT #08,#0f,#00,#20+buf_bg ;#660
   M_RECT #07,#12,#fa,#19+buf_bg ;#659
   M_VLINE #02,#f7,#129+buf_bg ;#769
   M_VLINE #02,#00,#128+buf_bg ;#768
   M_RECT #07,#12,#fb,#0e+buf_bg ;#64e
   M_HLINE #07,#f8,#1ee+buf_bg ;#82e
   M_VLINE #06,#f8,#b1+buf_bg ;#6f1
   M_draw_spr_2x6_1f0a #ac+buf_bg ;#6ec
   M_draw_spr_2x6_1f16 #b5+buf_bg ;#6f5
   M_draw_21b8 #49
   M_lab2068 
   M_END

assert $==#63f9
room_3E: ;#63f9
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_RECT #0a,#05,#fa,#00+buf_bg ;#640
   M_VLINE #0c,#f7,#89+buf_bg ;#6c9
   M_RECT #07,#05,#fa,#19+buf_bg ;#659
   M_VLINE #0c,#f7,#99+buf_bg ;#6d9
   M_RECT #06,#0a,#08,#ba+buf_bg ;#6fa
   M_RECT #07,#0c,#fb,#0e+buf_bg ;#64e
   M_RECT #03,#04,#cf,#170+buf_bg ;#7b0
   M_VLINE #08,#f8,#91+buf_bg ;#6d1
   M_draw_spr_2x6_1f0a #8c+buf_bg ;#6cc
   M_draw_spr_2x6_1f16 #95+buf_bg ;#6d5
   M_draw_spr_2x3_1e77 #17
   M_draw_spr_3x3_1e9f 
   M_draw_spr_3x3_1eb6 
   M_draw_21bc 
   M_END

assert $==#6437
room_3F: ;#6437
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#03,#fa,#1fc+buf_bg ;#83c
   M_END

assert $==#6441
room_40: ;#6441
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#12,#fa,#1c+buf_bg ;#65c
   M_END

assert $==#644b
room_41: ;#644b
   M_FILL_BG #fa
   M_RECT #1c,#0f,#01,#00+buf_bg ;#640
   M_MOON 
   M_HLINE #1c,#fe,#1e0+buf_bg ;#820
   M_RECT #04,#08,#00,#7c+buf_bg ;#6bc
   M_RECT #04,#08,#1f,#7c+buf_fg ;#8fc
   M_END

assert $==#6466
room_42: ;#6466
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_VLINE #10,#fa,#00+buf_bg ;#640
   M_HLINE #1f,#fc,#101+buf_bg ;#741
   M_lab21eb #1e,#02,#211+buf_bg ;#851
   M_draw_spr_2x2_1f50 #21,#10,#17+buf_bg ;#657
   M_lab1fc5 
   M_lab1fc0 
   M_lab1fb6 
   M_END

assert $==#6483
room_43: ;#6483
   M_HLINE #03,#fc,#100+buf_bg ;#740
   M_RECT #08,#0f,#fa,#18+buf_bg ;#658
   M_HLINE #57,#fa,#1e9+buf_bg ;#829
   M_lab2970 #0e,#fa,#1ca+buf_bg ;#80a
   M_END

assert $==#6499
room_44: ;#6499
   M_VLINE #06,#fa,#1f+buf_bg ;#65f
   M_RECT #05,#04,#fa,#1db+buf_bg ;#81b
   M_lab2970 #03,#fa,#238+buf_bg ;#878
   M_HLINE #09,#fc,#200+buf_bg ;#840
   M_HLINE #0d,#fc,#100+buf_bg ;#740
   M_draw_2b_ldiag_pattern_2c #0e,#1b+buf_bg ;#65b
   M_END

assert $==#64b8
room_45: ;#64b8
   M_VLINE #12,#fa,#00+buf_bg ;#640
   M_HLINE #1f,#fc,#101+buf_bg ;#741
   M_HLINE #1f,#fc,#201+buf_bg ;#841
   M_draw_2b_ldiag_pattern_2c #12,#17+buf_bg ;#657
   M_lab1fbb 
   M_lab1fc0 
   M_END

assert $==#64ce
room_46: ;#64ce
   M_HLINE #21,#fa,#00+buf_bg ;#640
   M_VLINE #10,#fa,#40+buf_bg ;#680
   M_HLINE #1f,#fc,#1e1+buf_bg ;#821
   M_draw_2b_ldiag_pattern_2c #03,#1f7+buf_bg ;#837
   M_lab1fcf 
   M_lab1fd4 
   M_END

assert $==#64e4
room_47: ;#64e4
   M_HLINE #20,#fa,#00+buf_bg ;#640
   M_VLINE #11,#fa,#3f+buf_bg ;#67f
   M_HLINE #1f,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #11,#3b+buf_bg ;#67b
   M_lab1fe4 
   M_lab1fca 
   M_lab1fe9 
   M_END

assert $==#64fb
room_48: ;#64fb
   M_4x3_spr_8x6 #05,#06,#02,#05,#0c,#07,#0b,#0d,#08,#01,#01,#03
   M_lab21f5 
   M_draw_spr_3x3_1f47 
   M_draw_2b_ldiag_pattern_25 #0f,#11+buf_bg ;#651
   M_END

assert $==#650f
room_49: ;#650f
   M_4x3_spr_8x6 #07,#00,#00,#02,#00,#00,#00,#0b,#01,#01,#01,#01
   M_draw_2b_ldiag_pattern_09 #0f,#16+buf_bg ;#656
   M_END

assert $==#6521
room_4A: ;#6521
   M_FILL_BG #08
   M_HLINE #20,#fa,#00+buf_bg ;#640
   M_RECT #03,#11,#fa,#3d+buf_bg ;#67d
   M_RECT #03,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1c,#f2,#1e2+buf_bg ;#822
   M_draw_2b_ldiag_pattern_09 #11,#36+buf_bg ;#676
   M_END

assert $==#653e
room_4B: ;#653e
   M_4x3_spr_8x6 #06,#00,#00,#02,#06,#00,#00,#02,#06,#00,#00,#02
   M_draw_2b_ldiag_pattern_09 #12,#16+buf_bg ;#656
   M_END

assert $==#6550
room_4C: ;#6550
   M_FILL_BG #fa
   M_RECT #1a,#0f,#08,#64+buf_bg ;#6a4
   M_HLINE #1c,#fc,#1e3+buf_bg ;#823
   M_draw_2b_ldiag_pattern_09 #0f,#7a+buf_bg ;#6ba
   M_lab1dd3 
   M_lab1dd8 
   M_END

assert $==#6564
room_4D: ;#6564
   M_FILL_BG #fa
   M_RECT #04,#0a,#08,#a0+buf_bg ;#6e0
   M_RECT #1a,#0f,#08,#04+buf_bg ;#644
   M_draw_2b_ldiag_pattern_09 #12,#1a+buf_bg ;#65a
   M_RECT #02,#03,#08,#42+buf_bg ;#682
   M_lab2084 
   M_lab2089 
   M_lab1cef 
   M_poke_byte #08,#104+buf_bg ;#744
   M_poke_byte #08,#109+buf_bg ;#749
   M_END

assert $==#6588
room_4E: ;#6588
   M_FILL_BG #fa
   M_RECT #1e,#07,#00,#140+buf_bg ;#780
   M_HLINE #1f,#fc,#220+buf_bg ;#860
   M_draw_2b_ldiag_pattern_09 #0a,#1a+buf_bg ;#65a
   M_draw_2b_ldiag_pattern_2c #07,#15a+buf_bg ;#79a
   M_END

assert $==#659e
room_4F: ;#659e
   M_HLINE #80,#fa,#1c0+buf_bg ;#800
   M_RECT #02,#06,#fa,#1e+buf_bg ;#65e
   M_lab1de8 
   M_END

assert $==#65ab
room_50: ;#65ab
   M_HLINE #80,#fa,#1c0+buf_bg ;#800
   M_END

assert $==#65b1
room_51: ;#65b1
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_RECT #20,#0a,#fa,#00+buf_bg ;#640
   M_END

assert $==#65bd
room_52: ;#65bd
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#203+buf_bg ;#843
   M_draw_screen2 
   M_MOON 
   M_draw_screen3 
   M_END

assert $==#65ca
room_53: ;#65ca
   M_HLINE #26,#fc,#1a0+buf_bg ;#7e0
   M_RECT #06,#03,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #0d,#03+buf_bg ;#643
   M_draw_screen4 
   M_lab1d6c 
   M_lab1dbc 
   M_END

assert $==#65dd
room_54: ;#65dd
   M_HLINE #0a,#fc,#00+buf_bg ;#640
   M_HLINE #20,#fc,#e0+buf_bg ;#720
   M_HLINE #07,#fa,#200+buf_bg ;#840
   M_HLINE #08,#fa,#220+buf_bg ;#860
   M_draw_2b_ldiag_pattern_2c #10,#03+buf_bg ;#643
   M_END

assert $==#65f6
room_55: ;#65f6
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_desk_0 
   M_draw_desk_1 
   M_draw_desk_2 
   M_draw_screen1 
   M_draw_screen4 
   M_END

assert $==#6601
room_56: ;#6601
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_HLINE #06,#6f,#234+buf_bg ;#874
   M_lab1cef 
   M_draw_screen4 
   M_END

assert $==#660e
room_57: ;#660e
   M_RECT #08,#0e,#fa,#00+buf_bg ;#640
   M_HLINE #80,#fa,#1c0+buf_bg ;#800
   M_lab296b #0d,#fa,#1a8+buf_bg ;#7e8
   M_END

assert $==#661f
room_58: ;#661f
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_HLINE #05,#6f,#227+buf_bg ;#867
   M_draw_screen2 
   M_draw_screen3 
   M_MOON 
   M_END

assert $==#662d
room_59: ;#662d
   M_HLINE #16,#fc,#e0+buf_bg ;#720
   M_END

assert $==#6633
room_5A: ;#6633
   M_lab2970 #03,#fa,#232+buf_bg ;#872
   M_RECT #0b,#04,#fa,#1d5+buf_bg ;#815
   M_END

assert $==#663f
room_5B: ;#663f
   M_HLINE #80,#fa,#1c0+buf_bg ;#800
   M_draw_2b_ldiag_pattern_09 #04,#1c6+buf_bg ;#806
   M_END

assert $==#6649
room_5C: ;#6649
   M_HLINE #9b,#fa,#1a5+buf_bg ;#7e5
   M_RECT #0e,#0d,#fa,#12+buf_bg ;#652
   M_lab2970 #0c,#fa,#186+buf_bg ;#7c6
   M_END

assert $==#665a
room_5D: ;#665a
   M_FILL_BG #08
   M_RECT #18,#02,#fa,#08+buf_bg ;#648
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_09 #0f,#06+buf_bg ;#646
   M_lab1dd8 
   M_lab1d95 
   M_lab2084 
   M_lab2089 
   M_END

assert $==#6670
room_5E: ;#6670
   M_FILL_BG #08
   M_HLINE #40,#fa,#00+buf_bg ;#640
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_lab1dd3 
   M_spr_5_3_1bdd 
   M_lab1d9a 
   M_END

assert $==#6680
room_5F: ;#6680
   M_FILL_BG #08
   M_RECT #04,#02,#fa,#00+buf_bg ;#640
   M_RECT #02,#02,#fa,#1e+buf_bg ;#65e
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_RECT #0c,#02,#08,#20a+buf_bg ;#84a
   M_HLINE #0e,#f2,#1e9+buf_bg ;#829
   M_draw_2b_ldiag_pattern_09 #03,#1ef+buf_bg ;#82f
   M_draw_2b_ldiag_pattern_09 #0f,#1a+buf_bg ;#65a
   M_lab1d95 
   M_END

assert $==#66a8
room_60: ;#66a8
   M_4x3_spr_8x6 #00,#00,#00,#00,#00,#00,#00,#00,#01,#01,#01,#01
   M_RECT #0e,#03,#fa,#1e0+buf_bg ;#820
   M_lab2983 #02,#fa,#1ee+buf_bg ;#82e
   M_HLINE #40,#fa,#00+buf_bg ;#640
   M_lab297e #05,#fa,#58+buf_bg ;#698
   M_RECT #03,#06,#fa,#5d+buf_bg ;#69d
   M_spr_5_3_1bdd 
   M_lab1dd8 
   M_END

assert $==#66d3
room_61: ;#66d3
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_RECT #09,#02,#fc,#200+buf_bg ;#840
   M_HLINE #1c,#fa,#04+buf_bg ;#644
   M_lab2983 #03,#fa,#30+buf_bg ;#670
   M_RECT #0b,#04,#fa,#25+buf_bg ;#665
   M_draw_2b_ldiag_pattern_2c #10,#0b+buf_bg ;#64b
   M_lab1fa4 
   M_lab1e1a 
   M_END

assert $==#66f5
room_62: ;#66f5
   M_VLINE #03,#fa,#0a+buf_bg ;#64a
   M_RECT #15,#05,#fa,#0b+buf_bg ;#64b
   M_HLINE #0f,#fc,#1a0+buf_bg ;#7e0
   M_HLINE #0a,#fa,#1af+buf_bg ;#7ef
   M_HLINE #0e,#fa,#1ce+buf_bg ;#80e
   M_RECT #11,#03,#fa,#1ef+buf_bg ;#82f
   M_lab1d71 
   M_lab1d6c 
   M_END

assert $==#6718
room_63: ;#6718
   M_lab297e #09,#fa,#13+buf_bg ;#653
   M_RECT #04,#0a,#fa,#1c+buf_bg ;#65c
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_draw_screen1 
   M_END

assert $==#672a
room_64: ;#672a
   M_FILL_BG #01
   M_MOON 
   M_RECT #07,#03,#fa,#1f9+buf_bg ;#839
   M_END

assert $==#6734
room_65: ;#6734
   M_FILL_BG #01
   M_MOON 
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_HLINE #08,#fa,#1d4+buf_bg ;#814
   M_draw_2b_ldiag_pattern_09 #04,#1d7+buf_bg ;#817
   M_lab1dd3 
   M_lab1dd8 
   M_END

assert $==#6748
room_66: ;#6748
   M_HLINE #25,#fc,#21b+buf_bg ;#85b
   M_RECT #19,#12,#01,#00+buf_bg ;#640
   M_RECT #02,#12,#fa,#19+buf_bg ;#659
   M_END

assert $==#675a
room_67: ;#675a
   M_FILL_BG #01
   M_MOON 
   M_RECT #07,#03,#fa,#19+buf_bg ;#659
   M_RECT #07,#05,#fa,#1b9+buf_bg ;#7f9
   M_HLINE #14,#07,#180+buf_bg ;#7c0
   M_HLINE #0c,#f2,#194+buf_bg ;#7d4
   M_END

assert $==#6774
room_68: ;#6774
   M_HLINE #27,#fa,#19+buf_bg ;#659
   M_HLINE #25,#fc,#21b+buf_bg ;#85b
   M_RECT #02,#10,#fa,#59+buf_bg ;#699
   M_RECT #19,#12,#01,#00+buf_bg ;#640
   M_END

assert $==#678b
room_69: ;#678b
   M_FILL_BG #01
   M_MOON 
   M_RECT #07,#0e,#fa,#19+buf_bg ;#659
   M_RECT #05,#0a,#00,#1b+buf_bg ;#65b
   M_END

assert $==#679b
room_6A: ;#679b
   M_lab1ce1 
   M_RECT #04,#10,#01,#00+buf_bg ;#640
   M_RECT #03,#03,#fa,#03+buf_bg ;#643
   M_HLINE #5d,#fa,#1e3+buf_bg ;#823
   M_VLINE #0c,#02,#64+buf_bg ;#6a4
   M_HLINE #03,#fe,#1e0+buf_bg ;#820
   M_lab1fcf 
   M_lab1fca 
   M_draw_screen1 
   M_draw_screen2 
   M_END

assert $==#67bc
room_6B: ;#67bc
   M_HLINE #73,#fa,#1cd+buf_bg ;#80d
   M_lab2970 #05,#fa,#1ae+buf_bg ;#7ee
   M_RECT #0d,#06,#fa,#113+buf_bg ;#753
   M_draw_screen3 
   M_END

assert $==#67ce
room_6C: ;#67ce
   M_RECT #20,#0a,#fa,#100+buf_bg ;#740
   M_draw_2b_ldiag_pattern_2c #08,#17+buf_bg ;#657
   M_draw_2b_ldiag_pattern_09 #09,#106+buf_bg ;#746
   M_draw_2b_ldiag_pattern_09 #09,#111+buf_bg ;#751
   M_VLINE #08,#fa,#1f+buf_bg ;#65f
   M_HLINE #1e,#00,#221+buf_bg ;#861
   M_draw_2b_ldiag_pattern_2c #01,#226+buf_bg ;#866
   M_draw_2b_ldiag_pattern_2c #01,#231+buf_bg ;#871
   M_lab1fbb 
   M_END

assert $==#67f4
room_6D: ;#67f4
   M_HLINE #3a,#fc,#146+buf_bg ;#786
   M_RECT #06,#08,#fa,#140+buf_bg ;#780
   M_RECT #03,#04,#01,#1c0+buf_bg ;#800
   M_draw_2b_ldiag_pattern_2c #0a,#14+buf_bg ;#654
   M_draw_screen3 
   M_END

assert $==#680b
room_6E: ;#680b
   M_HLINE #40,#fc,#140+buf_bg ;#780
   M_draw_screen3 
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#6814
room_6F: ;#6814
   M_HLINE #40,#fc,#140+buf_bg ;#780
   M_draw_2b_ldiag_pattern_2c #08,#157+buf_bg ;#797
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_draw_screen1 
   M_draw_screen4 
   M_END

assert $==#6825
room_70: ;#6825
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_lab1db2 
   M_lab1dad 
   M_lab1da8 
   M_END

assert $==#6833
room_71: ;#6833
   M_draw_screen2 
   M_draw_screen3 
   M_MOON 
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_lab1ff6 
   M_lab1dc1 
   M_draw_desk_3 
   M_draw_desk_2 
   M_END

assert $==#6840
room_72: ;#6840
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #12,#14+buf_bg ;#654
   M_lab1db2 
   M_END

assert $==#684b
room_73: ;#684b
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #12,#14+buf_bg ;#654
   M_lab1da8 
   M_END

assert $==#6856
room_74: ;#6856
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#214+buf_bg ;#854
   M_RECT #07,#02,#fa,#00+buf_bg ;#640
   M_END

assert $==#6866
room_75: ;#6866
   M_RECT #07,#03,#fa,#00+buf_bg ;#640
   M_RECT #05,#09,#01,#60+buf_bg ;#6a0
   M_RECT #07,#06,#fa,#180+buf_bg ;#7c0
   M_HLINE #03,#fa,#164+buf_bg ;#7a4
   M_HLINE #06,#f2,#180+buf_bg ;#7c0
   M_VLINE #09,#02,#45+buf_bg ;#685
   M_RECT #0f,#02,#fc,#211+buf_bg ;#851
   M_lab296b #05,#fc,#1f1+buf_bg ;#831
   M_RECT #0a,#02,#fc,#167+buf_bg ;#7a7
   M_END

assert $==#6899
room_76: ;#6899
   M_draw_screen4 
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #10,#09+buf_bg ;#649
   M_lab1db2 
   M_lab1dad 
   M_lab1da8 
   M_END

assert $==#68a7
room_77: ;#68a7
   M_draw_screen3 
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#209+buf_bg ;#849
   M_RECT #04,#07,#fc,#15+buf_bg ;#655
   M_VLINE #09,#7e,#f7+buf_bg ;#737
   M_END

assert $==#68bd
room_78: ;#68bd
   M_draw_screen3 
   M_RECT #1a,#02,#fc,#200+buf_bg ;#840
   M_HLINE #0a,#fc,#1f6+buf_bg ;#836
   M_VLINE #06,#fa,#1f+buf_bg ;#65f
   M_draw_2b_ldiag_pattern_2c #0f,#17+buf_bg ;#657
   M_lab1dad 
   M_lab1dc1 
   M_END

assert $==#68d5
room_79: ;#68d5
   M_draw_screen1 
   M_HLINE #3f,#fc,#200+buf_bg ;#840
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_draw_2b_ldiag_pattern_2c #12,#17+buf_bg ;#657
   M_lab1db2 
   M_lab1ff6 
   M_END

assert $==#68e7
room_7A: ;#68e7
   M_RECT #08,#06,#fa,#00+buf_bg ;#640
   M_RECT #18,#12,#01,#08+buf_bg ;#648
   M_RECT #04,#03,#01,#04+buf_bg ;#644
   M_HLINE #06,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #03,#1e2+buf_bg ;#822
   M_RECT #04,#03,#fa,#1e6+buf_bg ;#826
   M_HLINE #03,#f2,#88+buf_bg ;#6c8
   M_HLINE #0b,#f2,#1ea+buf_bg ;#82a
   M_MOON 
   M_END

assert $==#6914
room_7B: ;#6914
   M_RECT #17,#10,#01,#09+buf_bg ;#649
   M_RECT #04,#05,#fa,#06+buf_bg ;#646
   M_draw_2b_ldiag_pattern_2c #10,#02+buf_bg ;#642
   M_HLINE #04,#fa,#1e6+buf_bg ;#826
   M_HLINE #3a,#fa,#206+buf_bg ;#846
   M_RECT #06,#02,#fc,#200+buf_bg ;#840
   M_MOON 
   M_END

assert $==#6936
room_7C: ;#6936
   M_RECT #16,#10,#01,#00+buf_bg ;#640
   M_HLINE #40,#fa,#200+buf_bg ;#840
   M_lab2970 #06,#00,#1f0+buf_bg ;#830
   M_RECT #0a,#09,#fa,#16+buf_bg ;#656
   M_RECT #06,#06,#01,#16+buf_bg ;#656
   M_MOON 
   M_END

assert $==#6954
room_7D: ;#6954
   M_FILL_BG #01
   M_MOON 
   M_RECT #04,#03,#fa,#1fc+buf_bg ;#83c
   M_END

assert $==#695e
room_7E: ;#695e
   M_RECT #07,#0f,#01,#00+buf_bg ;#640
   M_RECT #03,#03,#fa,#07+buf_bg ;#647
   M_RECT #03,#06,#fa,#125+buf_bg ;#765
   M_RECT #08,#02,#fa,#1e0+buf_bg ;#820
   M_HLINE #20,#fa,#220+buf_bg ;#860
   M_RECT #03,#07,#fa,#153+buf_bg ;#793
   M_HLINE #0d,#fc,#147+buf_bg ;#787
   M_lab296b #06,#fa,#216+buf_bg ;#856
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#698e
room_7F: ;#698e
   M_FILL_BG #01
   M_MOON 
   M_RECT #19,#03,#fa,#1e7+buf_bg ;#827
   M_HLINE #09,#fa,#1c7+buf_bg ;#807
   M_lab1de8 
   M_spr_5_3_1bdd 
   M_lab1dd8 
   M_END

assert $==#69a0
room_80: ;#69a0
   M_FILL_BG #fa
   M_RECT #08,#07,#00,#38+buf_bg ;#678
   M_HLINE #e0,#00,#120+buf_bg ;#760
   M_HLINE #08,#00,#10b+buf_bg ;#74b
   M_HLINE #08,#fc,#118+buf_bg ;#758
   M_draw_2b_ldiag_pattern_2c #0f,#39+buf_bg ;#679
   M_draw_2b_ldiag_pattern_2c #0a,#10e+buf_bg ;#74e
   M_END

assert $==#69c0
room_81: ;#69c0
   M_HLINE #03,#fa,#220+buf_bg ;#860
   M_HLINE #1d,#fc,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_2c #12,#17+buf_bg ;#657
   M_draw_screen1 
   M_END

assert $==#69d0
room_82: ;#69d0
   M_HLINE #20,#fc,#220+buf_bg ;#860
   M_draw_desk_4 
   M_draw_desk_5 
   M_draw_desk_5 
   M_draw_screen2 
   M_MOON 
   M_draw_screen3 
   M_END

assert $==#69dc
room_83: ;#69dc
   M_HLINE #03,#fa,#00+buf_bg ;#640
   M_HLINE #0a,#fc,#03+buf_bg ;#643
   M_draw_2b_ldiag_pattern_2c #10,#17+buf_bg ;#657
   M_HLINE #08,#fc,#100+buf_bg ;#740
   M_RECT #02,#02,#fa,#200+buf_bg ;#840
   M_HLINE #1e,#fc,#202+buf_bg ;#842
   M_END

assert $==#69fb
room_84: ;#69fb
   M_HLINE #14,#fc,#200+buf_bg ;#840
   M_RECT #0e,#02,#fc,#1d2+buf_bg ;#812
   M_poke_byte #fc,#1f1+buf_bg ;#831
   M_draw_screen1 
   M_draw_screen2 
   M_MOON 
   M_END

assert $==#6a0e
room_85: ;#6a0e
   M_HLINE #40,#fc,#1c0+buf_bg ;#800
   M_draw_screen3 
   M_draw_screen4 
   M_END

assert $==#6a16
room_86: ;#6a16
   M_HLINE #0d,#fc,#220+buf_bg ;#860
   M_RECT #03,#0e,#fa,#13+buf_bg ;#653
   M_RECT #0a,#0e,#01,#16+buf_bg ;#656
   M_MOON 
   M_RECT #13,#04,#fa,#1cd+buf_bg ;#80d
   M_MOON 
   M_draw_screen1 
   M_END

assert $==#6a31
room_87: ;#6a31
   M_FILL_BG #01
   M_MOON 
   M_VLINE #0a,#02,#12+buf_bg ;#652
   M_RECT #16,#03,#fa,#1e0+buf_bg ;#820
   M_RECT #0e,#05,#fa,#148+buf_bg ;#788
   M_RECT #03,#04,#fa,#165+buf_bg ;#7a5
   M_lab1cd3 
   M_END

assert $==#6a4d
room_88: ;#6a4d
   M_FILL_BG #01
   M_MOON 
   M_VLINE #0b,#02,#f2+buf_bg ;#732
   M_lab1cd3 
   M_END

assert $==#6a57
room_89: ;#6a57
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_RECT #0c,#04,#fa,#1c0+buf_bg ;#800
   M_HLINE #14,#f2,#20c+buf_bg ;#84c
   M_lab1de8 
   M_END

assert $==#6a68
room_8A: ;#6a68
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_HLINE #18,#f2,#200+buf_bg ;#840
   M_HLINE #0f,#fa,#231+buf_bg ;#871
   M_lab2970 #02,#fa,#218+buf_bg ;#858
   M_draw_2b_ldiag_pattern_05 #0e,#1b+buf_bg ;#65b
   M_RECT #06,#03,#fa,#1da+buf_bg ;#81a
   M_VLINE #0e,#02,#1d+buf_bg ;#65d
   M_END

assert $==#6a8b
room_8B: ;#6a8b
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_HLINE #08,#f2,#1d8+buf_bg ;#818
   M_VLINE #03,#02,#1fd+buf_bg ;#83d
   M_draw_2b_ldiag_pattern_05 #04,#1db+buf_bg ;#81b
   M_END

assert $==#6a9e
room_8C: ;#6a9e
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_RECT #07,#03,#fa,#19+buf_bg ;#659
   M_RECT #02,#0f,#fa,#7e+buf_bg ;#6be
   M_HLINE #08,#f2,#1c0+buf_bg ;#800
   M_VLINE #03,#02,#1e3+buf_bg ;#823
   M_END

assert $==#6ab9
room_8D: ;#6ab9
   M_lab1cd3 
   M_FILL_BG #01
   M_MOON 
   M_RECT #05,#04,#fa,#1c0+buf_bg ;#800
   M_VLINE #0e,#02,#03+buf_bg ;#643
   M_RECT #02,#06,#fa,#1e+buf_bg ;#65e
   M_RECT #10,#0c,#fa,#d0+buf_bg ;#710
   M_RECT #09,#04,#01,#d0+buf_bg ;#710
   M_lab2983 #04,#01,#150+buf_bg ;#790
   M_END

assert $==#6ae0
room_8E: ;#6ae0
   M_FILL_BG #fa
   M_RECT #0b,#12,#01,#05+buf_bg ;#645
   M_RECT #0c,#08,#01,#94+buf_bg ;#6d4
   M_RECT #08,#06,#01,#194+buf_bg ;#7d4
   M_HLINE #08,#fc,#1b4+buf_bg ;#7f4
   M_draw_2b_ldiag_pattern_05 #05,#1b7+buf_bg ;#7f7
   M_END

assert $==#6afe
room_8F: ;#6afe
   M_FILL_BG #01
   M_MOON 
   M_RECT #05,#02,#fa,#00+buf_bg ;#640
   M_RECT #04,#02,#fa,#10+buf_bg ;#650
   M_RECT #03,#02,#fa,#1c+buf_bg ;#65c
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_draw_2b_ldiag_pattern_05 #10,#17+buf_bg ;#657
   M_VLINE #0e,#21,#41+buf_fg ;#8c1
   M_HLINE #1f,#fc,#200+buf_bg ;#840
   M_HLINE #1f,#00,#220+buf_bg ;#860
   M_END

assert $==#6b2c
room_90: ;#6b2c
   M_FILL_BG #01
   M_MOON 
   M_RECT #0e,#06,#fa,#11+buf_bg ;#651
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_RECT #04,#0c,#fa,#cf+buf_bg ;#70f
   M_lab2983 #03,#fa,#d3+buf_bg ;#713
   M_END

assert $==#6b46
room_91: ;#6b46
   M_FILL_BG #01
   M_MOON 
   M_VLINE #02,#fa,#1f+buf_bg ;#65f
   M_RECT #04,#07,#fa,#0f+buf_bg ;#64f
   M_RECT #04,#02,#fa,#20f+buf_bg ;#84f
   M_VLINE #09,#21,#f1+buf_fg ;#971
   M_HLINE #0d,#fc,#213+buf_bg ;#853
   M_HLINE #0d,#00,#233+buf_bg ;#873
   M_HLINE #11,#f2,#1e4+buf_bg ;#824
   M_draw_rline #02,#f1,#207+buf_bg ;#847
   M_draw_rline #02,#04,#208+buf_bg ;#848
   M_draw_2b_ldiag_pattern_2c #02,#219+buf_bg ;#859
   M_END

assert $==#6b7d
room_92: ;#6b7d
   M_RECT #0f,#12,#01,#00+buf_bg ;#640
   M_RECT #04,#12,#fa,#0f+buf_bg ;#64f
   M_draw_2b_ldiag_pattern_2c #12,#19+buf_bg ;#659
   M_draw_rline #06,#f1,#09+buf_bg ;#649
   M_draw_rline #05,#04,#0a+buf_bg ;#64a
   M_END

assert $==#6b98
room_93: ;#6b98
   M_RECT #15,#12,#01,#0b+buf_bg ;#64b
   M_RECT #03,#05,#fa,#09+buf_bg ;#649
   M_RECT #03,#04,#fa,#1c9+buf_bg ;#809
   M_RECT #09,#02,#fc,#1c0+buf_bg ;#800
   M_HLINE #16,#f2,#1a7+buf_bg ;#7e7
   M_draw_lline #03,#03,#1ce+buf_bg ;#80e
   M_draw_lline #04,#f3,#1cf+buf_bg ;#80f
   M_MOON 
   M_END

assert $==#6bc1
room_94: ;#6bc1
   M_RECT #03,#12,#fa,#09+buf_bg ;#649
   M_RECT #14,#12,#01,#0c+buf_bg ;#64c
   M_MOON 
   M_END

assert $==#6bcf
room_95: ;#6bcf
   M_RECT #15,#12,#01,#0b+buf_bg ;#64b
   M_RECT #03,#04,#fa,#09+buf_bg ;#649
   M_HLINE #0c,#fa,#220+buf_bg ;#860
   M_HLINE #0c,#fc,#160+buf_bg ;#7a0
   M_RECT #03,#05,#fa,#189+buf_bg ;#7c9
   M_HLINE #09,#f2,#18a+buf_bg ;#7ca
   M_MOON 
   M_END

assert $==#6bf2
room_96: ;#6bf2
   M_RECT #15,#0f,#01,#0b+buf_bg ;#64b
   M_RECT #0c,#02,#fa,#00+buf_bg ;#640
   M_HLINE #09,#fc,#1c0+buf_bg ;#800
   M_RECT #05,#05,#fa,#1a9+buf_bg ;#7e9
   M_RECT #12,#03,#fa,#1ee+buf_bg ;#82e
   M_MOON 
   M_spr_5_3_1bdd 
   M_END

assert $==#6c12
room_97: ;#6c12
   M_RECT #13,#12,#fa,#00+buf_bg ;#640
   M_RECT #0f,#0f,#01,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #12,#19+buf_bg ;#659
   M_END

assert $==#6c23
room_98: ;#6c23
   M_draw_screen1 
   M_draw_2b_ldiag_pattern_2c #11,#02+buf_bg ;#642
   M_HLINE #12,#fc,#220+buf_bg ;#860
   M_RECT #03,#12,#fa,#12+buf_bg ;#652
   M_RECT #0b,#02,#fa,#15+buf_bg ;#655
   M_HLINE #0b,#fc,#1d5+buf_bg ;#815
   M_draw_2b_ldiag_pattern_2c #04,#1da+buf_bg ;#81a
   M_draw_desk_4 
   M_END

assert $==#6c44
room_99: ;#6c44
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_RECT #03,#07,#fa,#12+buf_bg ;#652
   M_RECT #0e,#02,#fa,#f2+buf_bg ;#732
   M_draw_2b_ldiag_pattern_2c #10,#1a+buf_bg ;#65a
   M_draw_desk_0 
   M_draw_desk_1 
   M_draw_desk_2 
   M_END

assert $==#6c5d
room_9A: ;#6c5d
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_RECT #03,#07,#fa,#09+buf_bg ;#649
   M_RECT #0c,#02,#fa,#e0+buf_bg ;#720
   M_draw_desk_0 
   M_draw_desk_1 
   M_draw_desk_2 
   M_draw_desk_3 
   M_END

assert $==#6c73
room_9B: ;#6c73
   M_RECT #1c,#03,#fa,#04+buf_bg ;#644
   M_RECT #07,#03,#fa,#1f9+buf_bg ;#839
   M_END

assert $==#6c80
room_9C: ;#6c80
   M_draw_screen1 
   M_draw_screen4 
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#219+buf_bg ;#859
   M_END

assert $==#6c8c
room_9D: ;#6c8c
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_RECT #08,#02,#00,#205+buf_bg ;#845
   M_RECT #09,#02,#00,#212+buf_bg ;#852
   M_draw_screen2 
   M_MOON 
   M_draw_screen3 
   M_END

assert $==#6ca1
room_9E: ;#6ca1
   M_RECT #05,#04,#fc,#0d+buf_bg ;#64d
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_HLINE #13,#00,#225+buf_bg ;#865
   M_HLINE #17,#6f,#203+buf_bg ;#843
   M_END

assert $==#6cb7
room_9F: ;#6cb7
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_RECT #05,#02,#00,#20f+buf_bg ;#84f
   M_lab1db2 
   M_draw_desk_1 
   M_draw_desk_3 
   M_END

assert $==#6cc6
room_A0: ;#6cc6
   M_HLINE #3f,#fc,#200+buf_bg ;#840
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_draw_2b_ldiag_pattern_2c #10,#19+buf_bg ;#659
   M_END

assert $==#6cd5
room_A1: ;#6cd5
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_RECT #0b,#02,#fc,#1b4+buf_bg ;#7f4
   M_draw_2b_ldiag_pattern_2c #12,#19+buf_bg ;#659
   M_RECT #09,#02,#fc,#200+buf_bg ;#840
   M_HLINE #0f,#fc,#1e7+buf_bg ;#827
   M_draw_screen3 
   M_END

assert $==#6cf1
room_A2: ;#6cf1
   M_draw_screen3 
   M_draw_screen2 
   M_MOON 
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_HLINE #20,#fa,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #10,#0e+buf_bg ;#64e
   M_lab1fc0 
   M_lab1e1f 
   M_END

assert $==#6d05
room_A3: ;#6d05
   M_draw_screen1 
   M_draw_screen4 
   M_HLINE #02,#fa,#00+buf_bg ;#640
   M_RECT #06,#02,#fa,#200+buf_bg ;#840
   M_poke_byte #fc,#200+buf_bg ;#840
   M_HLINE #1b,#fc,#205+buf_bg ;#845
   M_lab1dad 
   M_lab1da8 
   M_lab1e1a 
   M_END

assert $==#6d1f
room_A4: ;#6d1f
   M_draw_screen3 
   M_draw_screen2 
   M_MOON 
   M_HLINE #20,#fc,#200+buf_bg ;#840
   M_lab1ff6 
   M_draw_desk_0 
   M_draw_desk_1 
   M_draw_desk_2 
   M_draw_desk_3 
   M_END

assert $==#6d2d
room_A5: ;#6d2d
   M_draw_screen1 
   M_draw_screen4 
   M_VLINE #0a,#7e,#11a+buf_bg ;#75a
   M_HLINE #1d,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#202+buf_bg ;#842
   M_END

assert $==#6d3e
room_A6: ;#6d3e
   M_draw_screen2 
   M_MOON 
   M_VLINE #0c,#7e,#1a+buf_bg ;#65a
   M_HLINE #05,#fc,#17b+buf_bg ;#7bb
   M_HLINE #16,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #12,#02+buf_bg ;#642
   M_HLINE #0e,#fa,#232+buf_bg ;#872
   M_RECT #03,#05,#fa,#19a+buf_bg ;#7da
   M_lab2970 #05,#fa,#215+buf_bg ;#855
   M_lab1fe4 
   M_END

assert $==#6d65
room_A7: ;#6d65
   M_RECT #02,#03,#fa,#04+buf_bg ;#644
   M_VLINE #0c,#02,#64+buf_bg ;#6a4
   M_RECT #05,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1b,#fc,#1e5+buf_bg ;#825
   M_RECT #04,#0f,#08,#00+buf_bg ;#640
   M_lab2084 
   M_lab2089 
   M_draw_screen1 
   M_draw_screen4 
   M_END

assert $==#6d86
room_A8: ;#6d86
   M_RECT #05,#06,#fa,#00+buf_bg ;#640
   M_RECT #05,#09,#08,#c0+buf_bg ;#700
   M_RECT #0a,#03,#fa,#1e0+buf_bg ;#820
   M_RECT #03,#03,#fa,#1fd+buf_bg ;#83d
   M_RECT #13,#02,#08,#20a+buf_bg ;#84a
   M_HLINE #15,#f2,#1e9+buf_bg ;#829
   M_draw_2b_ldiag_pattern_09 #03,#1f7+buf_bg ;#837
   M_END

assert $==#6dae
room_A9: ;#6dae
   M_FILL_BG #fa
   M_RECT #13,#12,#08,#0a+buf_bg ;#64a
   M_draw_2b_ldiag_pattern_09 #12,#17+buf_bg ;#657
   M_END

assert $==#6dbb
room_AA: ;#6dbb
   M_FILL_BG #fa
   M_RECT #13,#08,#08,#0a+buf_bg ;#64a
   M_HLINE #e0,#08,#100+buf_bg ;#740
   M_draw_2b_ldiag_pattern_09 #0f,#17+buf_bg ;#657
   M_lab1fdf 
   M_END

assert $==#6dce
room_AB: ;#6dce
   M_RECT #03,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1e,#fc,#1e2+buf_bg ;#822
   M_lab1fcf 
   M_END

assert $==#6ddb
room_AC: ;#6ddb
   M_RECT #03,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1e,#fc,#162+buf_bg ;#7a2
   M_VLINE #06,#7e,#19a+buf_bg ;#7da
   M_END

assert $==#6dec
room_AD: ;#6dec
   M_RECT #03,#08,#fa,#00+buf_bg ;#640
   M_VLINE #07,#08,#100+buf_bg ;#740
   M_VLINE #07,#7e,#101+buf_bg ;#741
   M_VLINE #0f,#7e,#1a+buf_bg ;#65a
   M_HLINE #5c,#fc,#1e4+buf_bg ;#824
   M_RECT #04,#03,#fa,#1e0+buf_bg ;#820
   M_lab1fe4 
   M_lab1fe9 
   M_END

assert $==#6e0f
room_AE: ;#6e0f
   M_draw_2b_ldiag_pattern_2c #0f,#06+buf_bg ;#646
   M_VLINE #06,#fa,#1f+buf_bg ;#65f
   M_RECT #03,#03,#fa,#1fd+buf_bg ;#83d
   M_HLINE #1e,#fc,#1e0+buf_bg ;#820
   M_lab1d76 
   M_lab1fe9 
   M_END

assert $==#6e26
room_AF: ;#6e26
   M_HLINE #c0,#fa,#00+buf_bg ;#640
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_VLINE #09,#7e,#c4+buf_bg ;#704
   M_VLINE #09,#7e,#dc+buf_bg ;#71c
   M_END

assert $==#6e3b
room_B0: ;#6e3b
   M_RECT #03,#02,#fa,#1d+buf_bg ;#65d
   M_HLINE #20,#fc,#160+buf_bg ;#7a0
   M_END

assert $==#6e47
room_B1: ;#6e47
   M_HLINE #60,#fc,#1e0+buf_bg ;#820
   M_lab1fca 
   M_END

assert $==#6e4e
room_B2: ;#6e4e
   M_HLINE #60,#fc,#1e0+buf_bg ;#820
   M_VLINE #0f,#7e,#04+buf_bg ;#644
   M_VLINE #0f,#7e,#1c+buf_bg ;#65c
   M_lab1fd4 
   M_lab1fcf 
   M_lab1fe9 
   M_END

assert $==#6e61
room_B3: ;#6e61
   M_HLINE #40,#fa,#00+buf_bg ;#640
   M_VLINE #10,#7e,#44+buf_bg ;#684
   M_VLINE #10,#7e,#5c+buf_bg ;#69c
   M_HLINE #20,#fc,#160+buf_bg ;#7a0
   M_END

assert $==#6e76
room_B4: ;#6e76
   M_HLINE #20,#fc,#1e0+buf_bg ;#820
   M_draw_bureau_chaise 
   M_lab1d76 
   M_END

assert $==#6e7e
room_B5: ;#6e7e
   M_RECT #04,#02,#fa,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #0b,#05+buf_bg ;#645
   M_HLINE #20,#fc,#160+buf_bg ;#7a0
   M_END

assert $==#6e8e
room_B6: ;#6e8e
   M_RECT #02,#02,#fc,#1e0+buf_bg ;#820
   M_lab2970 #03,#fa,#220+buf_bg ;#860
   M_HLINE #1a,#f2,#203+buf_bg ;#843
   M_HLINE #1a,#08,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_09 #02,#213+buf_bg ;#853
   M_RECT #02,#02,#fc,#1fe+buf_bg ;#83e
   M_lab296b #03,#fa,#23d+buf_bg ;#87d
   M_END

assert $==#6eb3
room_B7: ;#6eb3
   M_FILL_BG #fa
   M_RECT #1a,#08,#08,#03+buf_bg ;#643
   M_HLINE #00,#08,#e0+buf_bg ;#720
   M_draw_2b_ldiag_pattern_09 #0f,#13+buf_bg ;#653
   M_END

assert $==#6ec5
room_B8: ;#6ec5
   M_FILL_BG #fa
   M_RECT #17,#08,#08,#06+buf_bg ;#646
   M_RECT #1d,#09,#08,#c0+buf_bg ;#700
   M_draw_2b_ldiag_pattern_09 #0f,#16+buf_bg ;#656
   M_END

assert $==#6ed8
room_B9: ;#6ed8
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_RECT #05,#03,#fc,#1e0+buf_bg ;#820
   M_lab2970 #03,#fa,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_2c #10,#16+buf_bg ;#656
   M_HLINE #17,#f2,#206+buf_bg ;#846
   M_HLINE #17,#08,#226+buf_bg ;#866
   M_draw_2b_ldiag_pattern_09 #02,#216+buf_bg ;#856
   M_END

assert $==#6efc
room_BA: ;#6efc
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_HLINE #1e,#fc,#160+buf_bg ;#7a0
   M_draw_2b_ldiag_pattern_2c #07,#176+buf_bg ;#7b6
   M_END

assert $==#6f0c
room_BB: ;#6f0c
   M_HLINE #60,#fc,#1e0+buf_bg ;#820
   M_lab1db7 
   M_END

assert $==#6f13
room_BC: ;#6f13
   M_HLINE #20,#fc,#160+buf_bg ;#7a0
   M_END

assert $==#6f19
room_BD: ;#6f19
   M_HLINE #20,#fc,#1e0+buf_bg ;#820
   M_lab1db7 
   M_END

assert $==#6f20
room_BE: ;#6f20
   M_HLINE #20,#fc,#1e0+buf_bg ;#820
   M_draw_desk_7 
   M_draw_bureau_chaise 
   M_lab1d76 
   M_draw_screen2 
   M_MOON 
   M_draw_screen3 
   M_END

assert $==#6f2c
room_BF: ;#6f2c
   M_HLINE #04,#fa,#00+buf_bg ;#640
   M_RECT #02,#0e,#08,#20+buf_bg ;#660
   M_VLINE #0e,#02,#22+buf_bg ;#662
   M_RECT #04,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1c,#fc,#1e4+buf_bg ;#824
   M_lab1d76 
   M_END

assert $==#6f49
room_C0: ;#6f49
   M_HLINE #20,#fc,#1e0+buf_bg ;#820
   M_draw_desk_7 
   M_draw_desk_8 
   M_lab1db7 
   M_END

assert $==#6f52
room_C1: ;#6f52
   M_HLINE #20,#fc,#1e0+buf_bg ;#820
   M_RECT #03,#02,#fa,#21d+buf_bg ;#85d
   M_draw_2b_ldiag_pattern_2c #0f,#19+buf_bg ;#659
   M_draw_2b_ldiag_pattern_2c #03,#1f8+buf_bg ;#838
   M_lab2084 
   M_lab2089 
   M_lab1cef 
   M_END

assert $==#6f69
room_C2: ;#6f69
   M_HLINE #02,#fc,#1e0+buf_bg ;#820
   M_HLINE #07,#fa,#200+buf_bg ;#840
   M_HLINE #20,#fa,#220+buf_bg ;#860
   M_END

assert $==#6f79
room_C3: ;#6f79
   M_FILL_BG #fa
   M_RECT #1d,#0f,#08,#03+buf_bg ;#643
   M_RECT #04,#0a,#fa,#b3+buf_bg ;#6f3
   M_HLINE #13,#fc,#c2+buf_bg ;#702
   M_VLINE #05,#02,#15+buf_bg ;#655
   M_draw_2b_ldiag_pattern_09 #0f,#18+buf_bg ;#658
   M_END

assert $==#6f96
room_C4: ;#6f96
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#00+buf_bg ;#640
   M_VLINE #12,#02,#15+buf_bg ;#655
   M_HLINE #14,#fc,#10c+buf_bg ;#74c
   M_draw_2b_ldiag_pattern_09 #12,#18+buf_bg ;#658
   M_END

assert $==#6fad
room_C5: ;#6fad
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#00+buf_bg ;#640
   M_VLINE #12,#02,#15+buf_bg ;#655
   M_HLINE #0d,#fc,#193+buf_bg ;#7d3
   M_draw_2b_ldiag_pattern_09 #12,#18+buf_bg ;#658
   M_END

assert $==#6fc4
room_C6: ;#6fc4
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1d,#fc,#1c3+buf_bg ;#803
   M_draw_2b_ldiag_pattern_09 #04,#1d8+buf_bg ;#818
   M_VLINE #03,#02,#1f5+buf_bg ;#835
   M_draw_2b_ldiag_pattern_09 #0e,#06+buf_bg ;#646
   M_END

assert $==#6fdf
room_C7: ;#6fdf
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1d,#fc,#1e3+buf_bg ;#823
   M_draw_2b_ldiag_pattern_09 #12,#06+buf_bg ;#646
   M_lab1db7 
   M_END

assert $==#6ff2
room_C8: ;#6ff2
   M_RECT #03,#03,#fa,#01+buf_bg ;#641
   M_VLINE #0f,#08,#00+buf_bg ;#640
   M_VLINE #0c,#02,#61+buf_bg ;#6a1
   M_RECT #03,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1d,#fc,#203+buf_bg ;#843
   M_HLINE #1d,#08,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_09 #02,#206+buf_bg ;#846
   M_draw_2b_ldiag_pattern_2c #10,#10+buf_bg ;#650
   M_END

assert $==#701b
room_C9: ;#701b
   M_HLINE #03,#fa,#220+buf_bg ;#860
   M_HLINE #1d,#fc,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_2c #01,#230+buf_bg ;#870
   M_END

assert $==#702a
room_CA: ;#702a
   M_RECT #03,#06,#fa,#1d+buf_bg ;#65d
   M_RECT #03,#09,#08,#dd+buf_bg ;#71d
   M_RECT #03,#03,#fa,#1fd+buf_bg ;#83d
   M_HLINE #0b,#fc,#220+buf_bg ;#860
   M_HLINE #0b,#f2,#1f2+buf_bg ;#832
   M_HLINE #04,#f2,#21a+buf_bg ;#85a
   M_END

assert $==#704c
room_CB: ;#704c
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_VLINE #10,#02,#03+buf_bg ;#643
   M_HLINE #1d,#fc,#200+buf_bg ;#840
   M_HLINE #1d,#08,#220+buf_bg ;#860
   M_poke_byte #02,#22b+buf_bg ;#86b
   M_lab2076 
   M_lab2068 
   M_END

assert $==#7068
room_CC: ;#7068
   M_FILL_BG #08
   M_RECT #03,#06,#fa,#1d+buf_bg ;#65d
   M_RECT #03,#07,#08,#11d+buf_bg ;#75d
   M_RECT #07,#03,#fa,#1f9+buf_bg ;#839
   M_VLINE #12,#02,#0b+buf_bg ;#64b
   M_HLINE #10,#fc,#1e0+buf_bg ;#820
   M_END

assert $==#7087
room_CD: ;#7087
   M_FILL_BG #08
   M_VLINE #0e,#02,#0b+buf_bg ;#64b
   M_RECT #07,#02,#fa,#19+buf_bg ;#659
   M_RECT #03,#10,#fa,#5d+buf_bg ;#69d
   M_HLINE #1d,#fc,#1c0+buf_bg ;#800
   M_VLINE #03,#02,#1e1+buf_bg ;#821
   M_END

assert $==#70a5
room_CE: ;#70a5
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_VLINE #12,#02,#01+buf_bg ;#641
   M_HLINE #08,#fc,#180+buf_bg ;#7c0
   M_HLINE #0e,#fc,#211+buf_bg ;#851
   M_END

assert $==#70bd
room_CF: ;#70bd
   M_FILL_BG #08
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_VLINE #12,#02,#01+buf_bg ;#641
   M_HLINE #06,#fc,#100+buf_bg ;#740
   M_END

assert $==#70d0
room_D0: ;#70d0
   M_FILL_BG #08
   M_RECT #03,#06,#fa,#1d+buf_bg ;#65d
   M_RECT #03,#03,#fa,#1e0+buf_bg ;#820
   M_VLINE #0f,#02,#01+buf_bg ;#641
   M_RECT #03,#03,#fa,#1fd+buf_bg ;#83d
   M_HLINE #1c,#f2,#202+buf_bg ;#842
   M_HLINE #1a,#08,#223+buf_bg ;#863
   M_draw_2b_ldiag_pattern_09 #02,#20f+buf_bg ;#84f
   M_END

assert $==#70f8
room_D1: ;#70f8
   M_draw_2b_ldiag_pattern_2c #0e,#16+buf_bg ;#656
   M_RECT #02,#06,#fa,#1e+buf_bg ;#65e
   M_HLINE #11,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #03,#1e8+buf_bg ;#828
   M_RECT #0f,#04,#fa,#1d1+buf_bg ;#811
   M_lab1cef 
   M_END

assert $==#7113
room_D2: ;#7113
   M_HLINE #3c,#fc,#204+buf_bg ;#844
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #12,#08+buf_bg ;#648
   M_lab1da8 
   M_draw_desk_2 
   M_END

assert $==#7125
room_D3: ;#7125
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1c,#fc,#224+buf_bg ;#864
   M_draw_2b_ldiag_pattern_2c #01,#228+buf_bg ;#868
   M_draw_desk_6 
   M_draw_screen4 
   M_draw_screen1 
   M_END

assert $==#7138
room_D4: ;#7138
   M_HLINE #3e,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #02,#216+buf_bg ;#856
   M_RECT #02,#12,#fa,#1e+buf_bg ;#65e
   M_draw_spr_7x9_1b9e 
   M_draw_desk_0 
   M_draw_desk_1 
   M_END

assert $==#714b
room_D5: ;#714b
   M_HLINE #1e,#fc,#1e0+buf_bg ;#820
   M_RECT #02,#12,#fa,#1e+buf_bg ;#65e
   M_draw_2b_ldiag_pattern_2c #12,#16+buf_bg ;#656
   M_draw_desk_7 
   M_draw_desk_8 
   M_lab1cef 
   M_END

assert $==#715e
room_D6: ;#715e
   M_HLINE #3e,#fc,#200+buf_bg ;#840
   M_draw_2b_ldiag_pattern_2c #12,#16+buf_bg ;#656
   M_RECT #02,#12,#fa,#1e+buf_bg ;#65e
   M_draw_desk_0 
   M_draw_desk_1 
   M_END

assert $==#7170
room_D7: ;#7170
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_HLINE #1f,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #12,#06+buf_bg ;#646
   M_draw_2b_ldiag_pattern_2c #12,#11+buf_bg ;#651
   M_END

assert $==#7183
room_D8: ;#7183
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_HLINE #1f,#fc,#180+buf_bg ;#7c0
   M_draw_2b_ldiag_pattern_2c #12,#06+buf_bg ;#646
   M_draw_2b_ldiag_pattern_2c #12,#11+buf_bg ;#651
   M_END

assert $==#7196
room_D9: ;#7196
   M_HLINE #20,#fc,#180+buf_bg ;#7c0
   M_END

assert $==#719c
room_DA: ;#719c
   M_RECT #05,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1b,#fc,#185+buf_bg ;#7c5
   M_END

assert $==#71a8
room_DB: ;#71a8
   M_VLINE #12,#fa,#1f+buf_bg ;#65f
   M_HLINE #1f,#fc,#180+buf_bg ;#7c0
   M_draw_2b_ldiag_pattern_2c #12,#06+buf_bg ;#646
   M_draw_2b_ldiag_pattern_2c #0c,#11+buf_bg ;#651
   M_END

assert $==#71bb
room_DC: ;#71bb
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_HLINE #1e,#fc,#1e0+buf_bg ;#820
   M_draw_2b_ldiag_pattern_2c #0f,#18+buf_bg ;#658
   M_draw_bureau_chaise 
   M_END

assert $==#71cc
room_DD: ;#71cc
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1c,#fc,#184+buf_bg ;#7c4
   M_END

assert $==#71d8
room_DE: ;#71d8
   M_HLINE #1d,#fc,#180+buf_bg ;#7c0
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_draw_2b_ldiag_pattern_2c #12,#18+buf_bg ;#658
   M_END

assert $==#71e8
room_DF: ;#71e8
   M_HLINE #20,#fc,#1c0+buf_bg ;#800
   M_draw_2b_ldiag_pattern_2c #12,#19+buf_bg ;#659
   M_draw_desk_9 
   M_draw_desk_c 
   M_END

assert $==#71f4
room_E0: ;#71f4
   M_HLINE #20,#fc,#1c0+buf_bg ;#800
   M_draw_desk_b 
   M_draw_desk_c 
   M_END

assert $==#71fc
room_E1: ;#71fc
   M_HLINE #3c,#fc,#204+buf_bg ;#844
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_draw_2b_ldiag_pattern_2c #10,#08+buf_bg ;#648
   M_lab1dad 
   M_lab1da8 
   M_END

assert $==#720e
room_E2: ;#720e
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1c,#fc,#1c4+buf_bg ;#804
   M_draw_desk_a 
   M_draw_desk_c 
   M_END

assert $==#721c
room_E3: ;#721c
   M_HLINE #20,#fc,#1c0+buf_bg ;#800
   M_draw_desk_9 
   M_draw_desk_a 
   M_draw_desk_b 
   M_END

assert $==#7225
room_E4: ;#7225
   M_HLINE #3d,#fc,#200+buf_bg ;#840
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_draw_2b_ldiag_pattern_2c #12,#08+buf_bg ;#648
   M_draw_desk_2 
   M_END

assert $==#7236
room_E5: ;#7236
   M_HLINE #1d,#fc,#1c0+buf_bg ;#800
   M_draw_2b_ldiag_pattern_2c #12,#08+buf_bg ;#648
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_draw_desk_9 
   M_draw_desk_b 
   M_END

assert $==#7248
room_E6: ;#7248
   M_HLINE #1d,#fc,#1c0+buf_bg ;#800
   M_draw_2b_ldiag_pattern_2c #0e,#08+buf_bg ;#648
   M_RECT #03,#12,#fa,#1d+buf_bg ;#65d
   M_draw_desk_a 
   M_END

assert $==#7259
room_E7: ;#7259
   M_HLINE #20,#fc,#1c0+buf_bg ;#800
   M_draw_desk_9 
   M_draw_desk_a 
   M_draw_desk_b 
   M_draw_desk_c 
   M_END

assert $==#7263
room_E8: ;#7263
   M_RECT #04,#12,#fa,#00+buf_bg ;#640
   M_HLINE #1c,#fc,#1e4+buf_bg ;#824
   M_draw_2b_ldiag_pattern_2c #12,#08+buf_bg ;#648
   M_lab1d76 
   M_draw_desk_8 
   M_END

assert $==#7275
room_E9: ;#7275
   M_RECT #04,#06,#fa,#00+buf_bg ;#640
   M_RECT #04,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1d,#fc,#1e3+buf_bg ;#823
   M_draw_2b_ldiag_pattern_2c #03,#1e5+buf_bg ;#825
   M_END

assert $==#728b
room_EA: ;#728b
   M_RECT #05,#06,#fa,#00+buf_bg ;#640
   M_RECT #05,#09,#08,#c0+buf_bg ;#700
   M_RECT #05,#03,#fa,#1e0+buf_bg ;#820
   M_HLINE #1c,#fc,#1e4+buf_bg ;#824
   M_draw_bureau_chaise 
   M_lab1d76 
   M_END

assert $==#72a5
room_EB: ;#72a5
   M_draw_2b_ldiag_pattern_2c #10,#19+buf_bg ;#659
   M_HLINE #40,#fc,#200+buf_bg ;#840
   M_draw_desk #55
   M_draw_desk_2 
   M_draw_screen1 
   M_END

assert $==#72b3
room_EC: ;#72b3
   M_lab1cd3 
   M_4x3_spr_8x6 #10,#10,#10,#16,#10,#10,#10,#10,#15,#15,#15,#15
   M_MOON 
   M_VLINE #09,#08,#df+buf_bg ;#71f
   M_lab1d95 
   M_lab1dce 
   M_END

assert $==#72ca
room_ED: ;#72ca
   M_lab1cd3 
   M_4x3_spr_8x6 #10,#10,#10,#10,#10,#10,#10,#10,#15,#15,#15,#15
   M_MOON 
   M_END

assert $==#72da
room_EE: ;#72da
   M_lab1cd3 
   M_4x3_spr_8x6 #10,#10,#10,#10,#10,#10,#10,#10,#15,#15,#15,#15
   M_MOON 
   M_VLINE #0c,#c8,#68+buf_bg ;#6a8
   M_END

assert $==#72ef
room_EF: ;#72ef
   M_4x3_spr_8x6 #10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#10,#18
   M_MOON 
   M_END

assert $==#72fe
room_F0: ;#72fe
   M_4x3_spr_8x6 #10,#10,#10,#17,#10,#10,#10,#17,#10,#10,#10,#17
   M_MOON 
   M_END

assert $==#730d
room_F1: ;#730d
   M_FILL_BG #01
   M_MOON 
   M_VLINE #0c,#02,#0d+buf_bg ;#64d
   M_VLINE #0c,#02,#0f+buf_bg ;#64f
   M_VLINE #04,#02,#10e+buf_bg ;#74e
   M_HLINE #11,#f2,#18a+buf_bg ;#7ca
   M_HLINE #05,#07,#19b+buf_bg ;#7db
   M_VLINE #05,#02,#1ac+buf_bg ;#7ec
   M_VLINE #05,#02,#1b7+buf_bg ;#7f7
   M_draw_2b_ldiag_pattern_05 #06,#191+buf_bg ;#7d1
   M_lab1cd3 
   M_END

assert $==#7339
room_F2: ;#7339
   M_4x3_spr_8x6 #12,#10,#10,#10,#13,#10,#10,#10,#14,#10,#10,#10
   M_MOON 
   M_HLINE #1d,#fe,#1e3+buf_bg ;#823
   M_HLINE #60,#fa,#1e0+buf_bg ;#820
   M_HLINE #0e,#f2,#1e9+buf_bg ;#829
   M_HLINE #0a,#08,#22b+buf_bg ;#86b
   M_HLINE #0a,#08,#20b+buf_bg ;#84b
   M_draw_2b_ldiag_pattern_09 #03,#1ef+buf_bg ;#82f
   M_END

assert $==#7365
room_F3: ;#7365
   M_4x3_spr_8x6 #0f,#0f,#0f,#0f,#00,#00,#00,#00,#01,#01,#01,#01
   M_lab1dd3 
   M_END

assert $==#7374
room_F4: ;#7374
   M_4x3_spr_8x6 #0f,#0f,#0f,#0f,#00,#00,#00,#00,#01,#01,#01,#01
   M_END

assert $==#7382
room_F5: ;#7382
   M_HLINE #20,#fc,#1a0+buf_bg ;#7e0
   M_lab1d71 
   M_lab1d67 
   M_draw_screen3 
   M_draw_screen4 
   M_END


; sprite 6x1
assert $==#738c
lab738C:
	db #d4,#d2,#d2,#d3,#d3,#d5

    db #08,#08,#d4

; room index Maps
; MAP1
; 32x24
room_map1  ;#7395

                                                                db #d5,#08,#08,#00,#f4,#00,#f6,#f8,#f5,#fb,#fb,#fb,#fb,#fb,#fb
db #00,#00,#00,#00,#00,#00,#64,#65,#13,#00,#00,#00,#00,#88,#00,#00,#00,#64,#13,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#66,#79,#12,#00,#7f,#65,#08,#87,#00,#8b,#8c,#12,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#66,#78,#7a,#7d,#7e,#81,#82,#86,#89,#8a,#8d,#11,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#66,#77,#7b,#7c,#80,#83,#84,#85,#93,#90,#8e,#10,#07,#07,#07,#07,#07,#06,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#66,#76,#71,#9c,#a2,#a3,#a4,#a5,#94,#91,#8f,#11,#00,#00,#00,#00,#00,#05,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#f1,#07,#67,#75,#9d,#a1,#3a,#a7,#be,#a6,#95,#92,#01,#12,#00,#00,#00,#00,#0a,#04,#08,#0b,#13,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#05,#00,#68,#74,#9e,#a0,#3b,#d3,#82,#98,#96,#97,#9b,#16,#00,#00,#0d,#0c,#09,#01,#02,#03,#39,#13,#00,#00,#00
db #00,#00,#00,#00,#00,#05,#00,#66,#73,#9f,#70,#3b,#d2,#71,#99,#9a,#eb,#d4,#12,#00,#00,#17,#52,#55,#71,#61,#3d,#4c,#11,#00,#00,#00
db #00,#00,#00,#3f,#08,#04,#13,#66,#72,#71,#70,#3b,#e8,#be,#b4,#c0,#be,#d5,#11,#00,#00,#18,#53,#1b,#f5,#62,#3e,#4d,#11,#00,#00,#00
db #00,#00,#00,#40,#46,#47,#11,#69,#6d,#6e,#6f,#3b,#d2,#55,#9f,#71,#9f,#d6,#12,#00,#00,#19,#1a,#56,#58,#63,#51,#4e,#11,#00,#00,#00
db #00,#00,#00,#40,#45,#44,#15,#0f,#6a,#6b,#6c,#3b,#e8,#b4,#be,#c0,#b4,#d1,#15,#0f,#0e,#14,#54,#59,#5a,#50,#50,#4f,#15,#2c,#00,#00
db #00,#00,#00,#40,#42,#43,#01,#01,#da,#d9,#d8,#3b,#e1,#71,#9c,#9f,#55,#e4,#01,#01,#01,#01,#57,#5b,#5c,#4c,#01,#01,#01,#38,#2c,#00
db #00,#00,#ef,#41,#48,#01,#01,#21,#ea,#b4,#d7,#3b,#e2,#e0,#df,#e0,#e3,#e5,#01,#21,#2a,#28,#3a,#5d,#5e,#5f,#5e,#60,#23,#1e,#2d,#00
db #00,#00,#f0,#01,#01,#01,#01,#1c,#da,#d9,#d8,#3b,#e2,#e7,#df,#e0,#e7,#e6,#01,#1c,#01,#01,#3b,#21,#1d,#22,#1d,#23,#25,#01,#2d,#00
db #00,#00,#f0,#01,#21,#2a,#1d,#22,#ea,#c0,#d7,#3c,#bf,#c0,#c1,#c2,#c9,#ca,#2a,#22,#28,#01,#3b,#29,#01,#01,#21,#22,#22,#20,#2d,#00
db #00,#00,#f0,#01,#1c,#01,#01,#01,#da,#d9,#d8,#01,#dd,#d9,#de,#3a,#c8,#cb,#01,#01,#01,#01,#3b,#27,#23,#28,#1c,#01,#01,#1c,#2d,#00
db #00,#00,#f0,#01,#24,#1d,#20,#01,#da,#d9,#db,#01,#dd,#d9,#de,#3b,#c7,#cc,#2a,#1d,#20,#01,#3b,#01,#1f,#1d,#1e,#01,#27,#25,#2d,#00
db #00,#00,#f0,#01,#1c,#01,#24,#2a,#a8,#ab,#ae,#af,#e9,#bd,#dc,#3b,#c6,#cd,#01,#01,#1c,#01,#3b,#21,#1d,#2a,#1d,#2a,#1d,#1e,#2d,#00
db #00,#00,#f0,#01,#24,#28,#1c,#01,#a9,#ac,#b0,#b3,#b5,#bc,#ba,#3b,#c5,#ce,#01,#01,#1c,#01,#3b,#1c,#01,#01,#01,#21,#2a,#1d,#2e,#00
db #00,#00,#f0,#01,#1c,#01,#24,#2a,#aa,#ad,#b1,#b2,#b6,#bb,#b9,#3b,#c4,#cf,#01,#01,#1c,#01,#3b,#1c,#27,#1d,#2a,#26,#1d,#2a,#2e,#00
db #00,#00,#f0,#01,#1c,#01,#1c,#21,#1d,#2a,#23,#2a,#b7,#23,#b8,#3b,#c3,#d0,#1d,#2a,#25,#01,#3b,#24,#1d,#2a,#1d,#22,#1d,#2a,#2e,#00
db #00,#00,#f0,#01,#1c,#01,#1c,#1c,#01,#01,#1c,#01,#01,#1c,#01,#3b,#01,#1c,#01,#21,#25,#01,#3c,#26,#2a,#23,#2a,#20,#01,#01,#2d,#00
db #00,#00,#f0,#01,#24,#2a,#1e,#1c,#01,#21,#26,#2a,#1d,#1e,#01,#3b,#01,#1c,#01,#1c,#1c,#01,#01,#1c,#21,#1e,#01,#1f,#1d,#20,#2d,#00

db #00,#00,#f0,#01,#1f,#1d,#20,#1f,#2a,#1e,#1c,#01,#27,#2a,#20,#3b,#01,#1f,#2a,#1e,#1f,#1d,#2a,#26,#22,#1d,#2a,#1d,#28,#1c

assert $==#76a2
; Size #E2
room_map2
;lab76a2
db #2d,#00
db #00,#00,#f0,#01,#01,#01,#1f,#1d,#2a,#20,#1f,#1d,#2a,#1d,#25,#3c,#4a,#01,#01,#01,#01,#21,#2a,#26,#2f,#30,#31,#2a,#1d,#25,#2d,#00
db #00,#00,#f0,#01,#01,#01,#01,#01,#01,#1f,#1d,#2a,#1d,#2a,#1e,#01,#4b,#01,#21,#1d,#2a,#25,#01,#1c,#32,#33,#34,#23,#23,#1e,#2d,#00
db #ed,#ee,#ec,#2b,#f3,#f4,#2b,#f3,#2b,#f4,#2b,#f3,#f4,#f3,#2b,#f4,#49,#1d,#22,#1d,#23,#22,#1d,#25,#35,#36,#37,#25,#1f,#1d,#2e,#00
db #01,#01,#21,#2a,#1d,#20,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#01,#1c,#01,#1d,#1c,#27,#1d,#2a,#1e,#01,#01,#39,#13
db #01,#01,#1c,#01,#01,#1f,#1d,#2a,#1d,#23,#2a,#1d,#2a,#1d,#2a,#1d,#2a,#1d,#23,#1d,#1e,#27,#1d,#22,#2a,#1d,#28,#01,#21,#2a,#1d,#f2
db #ee,#21,#25,#01,#01,#01,#01,#01,#21,#22,#2a,#1d,#2a,#1d,#2a,#20,#01,#01,#1f,#2a,#1d,#2a,#1d,#2a,#1d,#23,#1d,#2a,#25,#01,#01,#1c
db #01,#29,#1f,#1d,#2a,#1d,#2a,#1d,#1e,#01,#01,#01,#01,#01,#01,#1f,#1d,#2a,#1d,#2a,#1d,#2a,#1d,#2a,#1d,#1e,#01,#01,#1f,#2a,#1d,#1e


; Room Scripts Addresses
; #5ded-738d
room_index:
lab7784
    dw room_00 ;lab5ded ; Room 0
    dw room_01 ;lab5df1 ; Room 1
    dw room_02 ;lab5e08
    dw room_03 ;lab5e26
    dw room_04 ;lab5e70
    dw room_05 ;lab5eb8
    dw room_06 ;lab5ed5
    dw room_07 ;lab5f01
    dw room_08 ;lab5f0a
    dw room_09 ;lab5f15
    dw room_0A ;lab5f40
    dw room_0B ;lab5f54
    dw room_0C ;lab5f6a
    dw room_0D ;lab5f93
    dw room_0E ;lab5f9d
    dw room_0F ;lab5fab
    dw room_10 ;lab5fe8
    dw room_11 ;lab600d
    dw room_12 ;lab6017
    dw room_13 ;lab6035
    dw room_14 ;lab603f
    dw room_15 ;lab606b
    dw room_16 ;lab6095
    dw room_17 ;lab60af
    dw room_18 ;lab60c4 ; Room #18
    dw room_19 ;lab60f4
    dw room_1a ;lab611c
    dw room_1b ;lab6137
    dw room_1c ;lab6148
    dw room_1d ;lab615a
    dw room_1e ;lab6168
    dw room_1f ;lab617a

    dw room_20 ;lab618c
    dw room_21 ;lab61a3 ;#a3,#61
    dw room_22 ;lab61ba ;#ba,#61
    dw room_23 ;lab61cc ;#cc,#61
    dw room_24 ;#61e3
    dw room_25 ;#fa,#61
    dw room_26 ;#11,#62
    dw room_27 ;#28,#62
    dw room_28 ;#36,#62
    dw room_29 ;#44,#62
    dw room_2a ;#56,#62
    dw room_2b ;#64,#62
    dw room_2c ; db #74,#62
    dw room_2d ; db #83,#62
    dw room_2e ; db #92,#62
    dw room_2f ; db #a1,#62
    dw room_30 ; db #af,#62
    dw room_31 ; db #bd,#62
    dw room_32 ; db #cb,#62
    dw room_33 ; db #d9,#62
    dw room_34 ; db #e7,#62
    dw room_35 ; db #f5,#62
    dw room_36 ; db #03,#63
    dw room_37 ; db #1b,#63
    dw room_38 ; db #29,#63
    dw room_39 ; db #50,#63
    dw room_3A ; db #60,#63
    dw room_3B ; db #8a,#63
    dw room_3C ; db #9e,#63
    dw room_3D ; db #c3,#63
    dw room_3E ; db #f9,#63
    dw room_3F ; db #37,#64
    dw room_40 ; db #41,#64
    dw room_41 ; db #4b,#64
    dw room_42 ; db #66,#64
    dw room_43 ; db #83,#64
    dw room_44 ; db #99,#64
    dw room_45 ; db #b8,#64
    dw room_46 ; db #ce,#64
    dw room_47 ; db #e4,#64
    dw room_48 ; db #fb,#64
    dw room_49 ; db #0f,#65
    dw room_4a ; db #21,#65
    dw room_4b ; db #3e,#65
    dw room_4c ; db #50,#65
    dw room_4d ; db #64,#65
    dw room_4e ; db #88,#65
    dw room_4f ; db #9e,#65
    dw room_50 ; db #ab,#65
    dw room_51 ; db #b1,#65
    dw room_52 ; db #bd,#65
    dw room_53 ; db #ca,#65
    dw room_54 ; db #dd,#65
    dw room_55 ; db #f6,#65
    dw room_56 ; db #01,#66
    dw room_57 ; db #0e,#66
    dw room_58 ; db #1f,#66
    dw room_59 ; db #2d,#66
    dw room_5a ; db #33,#66
    dw room_5b ; db #3f,#66
    dw room_5c ; db #49,#66
    dw room_5d ; db #5a,#66
    dw room_5e ; db #70,#66
    dw room_5f ; db #80,#66
    dw room_60 ; db #a8,#66
    dw room_61 ; db #d3,#66
    dw room_62 ; db #f5,#66
    dw room_63 ; db #18,#67
    dw room_64 ; db #2a,#67
    dw room_65 ; db #34,#67
    dw room_66 ; db #48,#67
    dw room_67 ; db #5a,#67
    dw room_68 ; db #74,#67
    dw room_69 ; db #8b,#67
    dw room_6a ; db #9b,#67
    dw room_6b ; db #bc,#67
    dw room_6c ; db #ce,#67
    dw room_6d ; db #f4,#67
    dw room_6e ; db #0b,#68
    dw room_6f ; db #14,#68
    dw room_70 ; db #25,#68
    dw room_71 ; db #33,#68
    dw room_72 ;db #40,#68
    dw room_73 ;db #4b,#68
    dw room_74 ;db #56,#68
    dw room_75 ;db #66,#68
    dw room_76 ;db #99,#68
    dw room_77 ;db #a7,#68
    dw room_78 ;db #bd,#68
    dw room_79 ;db #d5,#68
    dw room_7a ;db #e7,#68
    dw room_7b ;db #14,#69
    dw room_7c ;db #36,#69
    dw room_7d ;db #54,#69
    dw room_7e ;db #5e,#69
    dw room_7f ;db #8e,#69
    dw room_80 ;db #a0,#69
    dw room_81 ; db #c0,#69
    dw room_82 ; db #d0,#69
    dw room_83 ; db #dc,#69
    dw room_84 ; db #fb,#69
    dw room_85 ; db #0e,#6a
    dw room_86 ; db #16,#6a
    dw room_87 ; db #31,#6a
    dw room_88 ; db #4d,#6a
    dw room_89 ; db #57,#6a
    dw room_8a ; db #68,#6a
    dw room_8b ; db #8b,#6a
    dw room_8c ; db #9e,#6a
    dw room_8d ; db #b9,#6a
    dw room_8e ; db #e0,#6a
    dw room_8f ; db #fe,#6a
    dw room_90 ; db #2c,#6b
    dw room_91 ; db #46,#6b
    dw room_92 ; db #7d,#6b
    dw room_93 ; db #98,#6b
    dw room_94 ; db #c1,#6b
    dw room_95 ; db #cf,#6b
    dw room_96 ; db #f2,#6b
    dw room_97 ; db #12,#6c
    dw room_98 ; db #23,#6c
    dw room_99 ; db #44,#6c
    dw room_9a ; db #5d,#6c
    dw room_9b ; db #73,#6c
    dw room_9c ; db #80,#6c
    dw room_9d ; db #8c,#6c
    dw room_9e ; db #a1,#6c
    dw room_9f ; db #b7,#6c
    dw room_a0 ;db #c6,#6c
    dw room_a1 ;db #d5,#6c
    dw room_a2 ;db #f1,#6c
    dw room_a3 ;db #05,#6d
    dw room_a4 ;db #1f,#6d
    dw room_a5 ;db #2d,#6d
    dw room_a6 ;db #3e,#6d
    dw room_a7 ;db #65,#6d
    dw room_a8 ;db #86,#6d
    dw room_a9 ;db #ae,#6d
    dw room_aa ;db #bb,#6d
    dw room_ab ;db #ce,#6d
    dw room_ac ;db #db,#6d
    dw room_ad ;db #ec,#6d
    dw room_ae ;db #0f,#6e
    dw room_af ;db #26,#6e
    dw room_b0 ;db #3b,#6e
    dw room_b1 ;db #47,#6e
    dw room_b2 ;db #4e,#6e
    dw room_b3 ;db #61,#6e
    dw room_b4 ;db #76,#6e
    dw room_b5 ;db #7e,#6e
    dw room_b6 ;db #8e,#6e
    dw room_b7 ;db #b3,#6e
    dw room_b8 ;db #c5,#6e
    dw room_b9 ;db #d8,#6e
    dw room_ba ;db #fc,#6e
    dw room_bb ;db #0c,#6f
    dw room_bc ;db #13,#6f
    dw room_bd ;db #19,#6f
    dw room_be ;db #20,#6f
    dw room_bf ;db #2c,#6f
    dw room_c0 ;db #49,#6f
    dw room_c1 ;db #52,#6f
    dw room_c2 ;db #69,#6f
    dw room_c3 ;db #79,#6f
    dw room_c4 ;db #96,#6f
    dw room_c5 ;db #ad,#6f
    dw room_c6 ;db #c4,#6f
    dw room_c7 ;db #df,#6f
    dw room_c8 ;db #f2,#6f
    dw room_c9 ;db #1b,#70
    dw room_ca ;db #2a,#70
    dw room_cb ;db #4c,#70
    dw room_cc ;db #68,#70
    dw room_cd ;db #87,#70
    dw room_ce ;db #a5,#70
    dw room_cf ;db #bd,#70
    dw room_d0 ;db #d0,#70
    dw room_d1 ;db #f8,#70
    dw room_d2 ;db #13,#71
    dw room_d3 ;db #25,#71
    dw room_d4 ;db #38,#71
    dw room_d5 ;db #4b,#71
    dw room_d6 ;db #5e,#71
    dw room_d7 ;db #70,#71
    dw room_d8 ;db #83,#71
    dw room_d9 ;db #96,#71
    dw room_da ;db #9c,#71
    dw room_db ;db #a8,#71
    dw room_dc ;db #bb,#71
    dw room_dd ;db #cc,#71
    dw room_de ;db #d8,#71
    dw room_df ;db #e8,#71
    dw room_e0 ;db #f4,#71
    dw room_e1 ;db #fc,#71
    dw room_e2 ;db #0e,#72
    dw room_e3 ;db #1c,#72
    dw room_e4 ;db #25,#72
    dw room_e5 ;db #36,#72
    dw room_e6 ;db #48,#72
    dw room_e7 ;db #59,#72
    dw room_e8 ;db #63,#72
    dw room_e9 ;db #75,#72
    dw room_ea ;db #8b,#72
    dw room_eb ;db #a5,#72
    dw room_ec ;db #b3,#72
    dw room_ed ;db #ca,#72
    dw room_ee ;db #da,#72
    dw room_ef ;db #ef,#72
    dw room_f0 ;db #fe,#72
    dw room_f1 ;db #0d,#73
    dw room_f2 ;db #39,#73
    dw room_f3 ;db #65,#73
    dw room_f4 ;db #74,#73
    dw room_f5 ;db #82,#73


; sprites des ennemis
lab7970
    db #00,#00,#01,#01,#01,#01,#01,#01
    db #78,#fc,#fc,#f2,#e2,#e2,#f2,#fc
    db #38,#7c,#7d,#7e,#7b,#7b,#77,#77
    db #fc,#dc,#e0,#fe,#fe,#ff,#ff,#f7
    db #77,#77,#77,#77,#77,#77,#77,#7b
    db #f7,#7b,#7b,#7d,#7d,#bd,#be,#df
    db #7b,#7f,#39,#05,#0d,#0d,#01,#01
    db #ef,#17,#f9,#fe,#fe,#be,#fe,#bc
    db #80,#e0,#f0,#f0,#60,#00,#00,#00
    db #01,#01,#01,#03,#03,#02,#03,#06
    db #7c,#fd,#7b,#fb,#fb,#f7,#f7,#f7
    db #00,#00,#00,#80,#80,#80,#c0,#c0
    db #05,#07,#0d,#0f,#0f,#1b,#17,#1f
    db #ef,#c7,#c3,#c3,#83,#81,#01,#01
    db #e0,#e0,#e0,#e0,#e0,#e0,#f0,#f0
    db #1e,#3e,#3c,#24,#78,#7f,#7f,#0f
    db #f0,#f0,#f0,#f0,#8e,#fe,#fe,#f0
    db #38,#7c,#7d,#7e,#7b,#7b,#76,#76
    db #fc,#dc,#e0,#fc,#be,#7e,#ff,#ff
    db #76,#75,#75,#75,#75,#75,#76,#7a
    db #ff,#ff,#f7,#f7,#f7,#ee,#ee,#ee
    db #7a,#7e,#3b,#03,#03,#03,#03,#03
    db #ec,#f4,#74,#54,#78,#bc,#dc,#e0
    db #01,#01,#01,#01,#01,#01,#00,#00
    db #78,#f8,#78,#fc,#7c,#bc,#fc,#bc
    db #fc,#bc,#f8,#b8,#f8,#b8,#f8,#b8
    db #a0,#78,#78,#78,#88,#fe,#fe,#fe
    db #38,#7c,#7d,#7e,#7b,#7b,#76,#75
    db #fc,#dc,#e0,#fe,#fe,#3f,#df,#ff
    db #73,#77,#77,#6f,#6f,#6f,#6f,#6e
    db #ff,#ff,#ff,#bf,#7f,#7e,#7e,#fe
    db #00,#00,#00,#00,#00,#80,#80,#80
    db #00,#00,#00,#00,#00,#00,#01,#07
    db #00,#00,#00,#00,#0f,#7f,#ff,#ff
    db #00,#00,#00,#00,#3f,#ff,#ff,#ff
    db #00,#00,#01,#0f,#ff,#f7,#fb,#fb
    db #00,#0f,#ff,#ff,#ff,#ff,#ff,#fd
    db #60,#c0,#e0,#f0,#d0,#f0,#f8,#f0
    db #00,#00,#00,#00,#00,#03,#7f,#7e
    db #00,#00,#00,#03,#1f,#fe,#f0,#01
    db #ff,#ff,#ff,#ff,#ff,#ff,#7f,#00
    db #ff,#ff,#ff,#ff,#fe,#f8,#e0,#00
    db #d0,#e0,#f8,#fc,#fe,#1c,#3c,#38
    db #00,#00,#00,#00,#00,#01,#03,#03
    db #07,#1f,#3e,#fc,#d8,#b0,#b0,#b8
    db #fe,#c0,#00,#00,#00,#00,#00,#00
    db #f0,#c0,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#01,#07,#1e,#7d,#f1
    db #00,#07,#7f,#ff,#ff,#ff,#ff,#ff
    db #00,#80,#e0,#f8,#fe,#ff,#ff,#7f
    db #00,#00,#00,#00,#00,#00,#fe,#ff
    db #e0,#60,#30,#10,#18,#0f,#07,#00
    db #6e,#6f,#29,#0f,#0f,#06,#01,#03
    db #fd,#05,#7d,#7d,#7c,#fc,#be,#fe
    db #c0,#c0,#e0,#e0,#c0,#00,#00,#00
    db #01,#01,#02,#03,#03,#07,#07,#07
    db #be,#df,#ff,#5f,#af,#d7,#eb,#ed
    db #00,#00,#00,#80,#80,#c0,#c0,#c0
    db #07,#07,#0f,#0f,#0f,#1f,#1f,#1f
    db #e7,#c7,#c2,#c3,#83,#81,#01,#01
    db #e0,#e0,#e0,#60,#e0,#f0,#b0,#f0
    db #1e,#3e,#3c,#24,#78,#7f,#7f,#0f
    db #b0,#f0,#b0,#f0,#8e,#fe,#fe,#f0
    db #1e,#3f,#7f,#60,#40,#40,#62,#7f
    db #00,#00,#00,#80,#80,#80,#80,#80
    db #0f,#1f,#1e,#1d,#1b,#1b,#17,#17
    db #bf,#3f,#e1,#ff,#ff,#ff,#ff,#ff
    db #a0,#70,#30,#d0,#e0,#f0,#d0,#e8
    db #17,#17,#17,#17,#17,#17,#17,#17
    db #ff,#df,#df,#df,#df,#bf,#bf,#bf
    db #e8,#e8,#ec,#dc,#dc,#dc,#dc,#5c
    db #1b,#1b,#0d,#01,#00,#01,#01,#01
    db #a0,#df,#df,#af,#77,#77,#8f,#ff
    db #dc,#de,#ce,#ea,#ee,#ee,#ec,#e0
    db #01,#01,#03,#02,#03,#02,#03,#02
    db #7f,#fb,#7b,#fb,#77,#f7,#f7,#ef
    db #e0,#c0,#c0,#c0,#c0,#c0,#e0,#e0
    db #03,#02,#03,#06,#05,#07,#05,#07
    db #e7,#e7,#c7,#c3,#83,#87,#87,#87
    db #e0,#e0,#e0,#e0,#c0,#c0,#c0,#c0
    db #05,#07,#0f,#0f,#09,#0f,#0f,#0f
    db #87,#83,#03,#03,#02,#83,#83,#83
    db #c0,#c0,#c0,#c0,#40,#e0,#e0,#e0
    db #00,#00,#00,#00,#00,#00,#03,#0e
    db #03,#07,#0e,#18,#30,#00,#00,#00
    db #c3,#01,#01,#00,#00,#00,#01,#03
    db #fe,#ff,#ff,#fe,#7d,#f8,#e0,#c0
    db #ff,#7f,#7f,#fe,#fd,#7d,#0f,#01
    db #df,#df,#bf,#7f,#ff,#ff,#ff,#f3
    db #bf,#ff,#fe,#ff,#ff,#f7,#e0,#e0
    db #00,#80,#80,#c0,#c0,#80,#00,#00
    db #f8,#7c,#1c,#08,#00,#00,#00,#00
    db #01,#01,#01,#01,#03,#03,#01,#00
    db #c1,#c1,#80,#80,#80,#80,#c0,#e0
    db #e0,#f0,#fc,#7e,#1f,#07,#01,#00
    db #00,#00,#00,#00,#00,#f0,#f0,#00
    db #00,#00,#01,#07,#0f,#1f,#3f,#7f
    db #00,#00,#e0,#f0,#f0,#88,#08,#88
    db #00,#00,#01,#03,#07,#07,#07,#07
    db #00,#00,#00,#00,#70,#f0,#78,#b8
    db #00,#00,#00,#00,#00,#00,#06,#3f
    db #00,#00,#80,#c0,#c0,#c0,#e0,#e0
    db #f0,#f0,#ef,#df,#ff,#ff,#e5,#d9
    db #07,#07,#17,#03,#77,#77,#17,#77
    db #b8,#00,#00,#00,#00,#00,#00,#00
    db #ef,#7e,#fc,#f0,#c0,#00,#00,#00
    db #01,#0f,#7a,#d7,#bf,#ff,#fc,#f0
    db #e0,#e0,#e0,#c7,#3e,#f5,#bf,#7f
    db #dd,#ee,#f7,#f9,#fe,#ff,#7f,#bf
    db #77,#77,#7b,#7b,#7d,#3a,#31,#00
    db #c0,#00,#00,#00,#00,#00,#00,#00
    db #ff,#ff,#fc,#f8,#f8,#f0,#f0,#f0
    db #de,#65,#77,#07,#07,#07,#07,#03
    db #f0,#f0,#f8,#f8,#f8,#f8,#f8,#f0
    db #03,#03,#03,#03,#03,#03,#03,#01
    db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
    db #01,#01,#01,#01,#00,#00,#00,#00
    db #e0,#e0,#f0,#90,#f0,#f0,#f0,#80
    db #00,#00,#00,#00,#00,#03,#07,#07
    db #00,#0f,#1f,#3f,#3c,#38,#3c,#3f
    db #00,#00,#80,#80,#40,#40,#40,#80
    db #00,#01,#01,#00,#01,#01,#01,#01
    db #1f,#df,#3f,#ff,#ff,#ff,#f3,#ed
    db #8e,#ae,#2e,#c6,#ef,#ef,#ef,#ef
    db #01,#01,#01,#01,#01,#01,#00,#00
    db #ed,#9b,#fb,#f7,#f7,#ef,#ef,#de
    db #ef,#ef,#f6,#f9,#fb,#f7,#2f,#ff
    db #00,#00,#e0,#f0,#f0,#f8,#f8,#f8
    db #2d,#37,#3a,#03,#02,#03,#03,#01
    db #ff,#ff,#fd,#fd,#fd,#7c,#fc,#7c
    db #f8,#f8,#f8,#f0,#f0,#f0,#90,#f0
    db #01,#01,#01,#01,#01,#01,#01,#00
    db #fc,#7c,#fc,#78,#f8,#78,#b8,#f8 ;..x.x...
    db #f0,#e0,#e0,#f0,#f0,#f0,#f0,#60
    db #b8,#f8,#b8,#f8,#78,#78,#78,#78 ;...xxxxp
    db #70,#70,#70,#70,#48,#f8,#f8,#f8 ;pppH....
    db #00,#7e,#ff,#ff,#ff,#ff,#ff,#ff
    db #00,#00,#80,#f0,#fc,#ff,#ff,#ff
    db #00,#00,#00,#00,#00,#c7,#ff,#ff
    db #00,#00,#00,#00,#00,#1f,#7f,#ff
    db #00,#00,#00,#00,#00,#80,#f0,#fe
    db #1f,#21,#78,#78,#7d,#7f,#7f,#3c ;.xx.....
    db #7f,#bf,#bb,#b5,#ae,#9e,#5f,#ee
    db #ff,#fe,#fe,#83,#7d,#fe,#7e,#fd
    db #fc,#0f,#b0,#7f,#7f,#aa,#bf,#f0
    db #00,#e0,#3c,#cf,#f0,#af,#55,#ff ;.....U..
    db #00,#0e,#08,#f6,#2e,#ee,#6e,#fe ;.....n..
    db #00,#00,#00,#00,#00,#1e,#3e,#3d
    db #3c,#7e,#78,#78,#7e,#7e,#7e,#f8 ;.xx.....
    db #3d,#3d,#3b,#3b,#7b,#7b,#7b,#7b
    db #ff,#ff,#ff,#7f,#9f,#e0,#ff,#ff
    db #87,#ff,#ff,#ff,#ef,#00,#1f,#60
    db #c6,#ff,#f7,#ff,#ce,#00,#00,#00
    db #7b,#7b,#7a,#77,#77,#c7,#37,#07 ;.zww....
    db #fe,#fd,#fc,#78,#c0,#7f,#aa,#d5 ;..x.....
    db #f0,#f0,#e0,#00,#00,#e0,#f0,#70 ;......p.
    db #07,#07,#03,#00,#03,#03,#03,#03
    db #ff,#ff,#ff,#01,#f1,#f3,#f2,#e3
    db #b0,#70,#b0,#70,#a0,#60,#e0,#40 ;p.p.....
    db #00,#07,#0f,#0f,#1f,#1c,#1c,#18
    db #03,#83,#ff,#7f,#ff,#ff,#1f,#03
    db #e5,#e6,#e7,#e7,#cf,#cf,#cf,#8f
    db #c0,#80,#80,#00,#c0,#e0,#e0,#e0
    db #01,#37,#ff,#7d,#0f,#00,#00,#00 ;.......l
    db #6c,#fb,#ef,#bd,#ef,#32,#00,#00
    db #c0,#bc,#ee,#70,#a0,#70,#00,#00 ;..p.p...
    db #00,#00,#20,#40,#f0,#fc,#fc,#f4
    db #00,#00,#00,#00,#7f,#7f,#00,#00
    db #00,#03,#0f,#7f,#f8,#80,#00,#00
    db #ff,#ff,#bf,#1f,#0f,#03,#00,#00
    db #ff,#ff,#f7,#fb,#fd,#fc,#fc,#fc
    db #ff,#ff,#ff,#ff,#ff,#ff,#f8,#78 ;......x.
    db #ff,#ff,#ff,#fc,#f0,#c0,#00,#00
    db #fe,#fe,#7c,#00,#00,#00,#00,#00
    db #f8,#70,#70,#f0,#f0,#fc,#3f,#0f ;pp.....p
    db #70,#70,#70,#60,#60,#60,#b0,#f0 ;pp......
    db #1f,#3f,#ff,#ff,#bf,#7f,#ff,#ff
    db #ff,#ff,#ff,#ff,#ff,#ff,#d0,#80
    db #00,#00,#00,#03,#03,#05,#0d,#1d
    db #07,#3f,#ff,#ff,#ff,#ff,#ff,#ef
    db #80,#e0,#f0,#fc,#fe,#fb,#dd,#bd
    db #00,#00,#00,#00,#02,#84,#fc,#fe
    db #19,#30,#30,#60,#60,#c0,#c1,#01
    db #ef,#f7,#f7,#fb,#7c,#76,#76,#6c ;....vvl.
    db #7e,#7d,#7d,#7d,#be,#3f,#3f,#3e
    db #d6,#fe,#fe,#b4,#78,#80,#e0,#60 ;...x....
    db #d0,#c0,#d0,#e8,#ec,#70,#78,#78 ;....pxx.
    db #39,#39,#3b,#1b,#1d,#2c,#2c,#1c
    db #e0,#c0,#80,#80,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#f0
    db #00,#00,#00,#00,#00,#0f,#7f,#78 ;......x.
    db #00,#00,#01,#03,#07,#8f,#f7,#fb
    db #7f,#fc,#ff,#ff,#ff,#ff,#fb,#fc
    db #0f,#ff,#ff,#ff,#ff,#ff,#ff,#ff
    db #fc,#fe,#fe,#ff,#ff,#ff,#ff,#fd
    db #00,#00,#08,#fc,#fe,#ff,#ff,#ff

assert $==#7f90
lab7f90
db #ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#93,#94,#ff,#ff
db #ff,#ff,#95,#96,#97,#98,#ff,#ff
db #99,#9a,#9b,#ff,#ff,#ff,#9c,#9d
db #9e,#ff,#ff,#9f,#a0,#a1,#a2,#ff
db #77,#78,#ff,#ff,#ff,#79,#7a,#7b ;wx...yz.
db #ff,#ff,#ff,#7c,#7d,#7e,#7f,#ff
db #ff,#ff,#80,#81,#82,#ff,#ff,#ff
db #83,#84,#85,#ff,#ff,#ff,#ff,#86
db #ff,#ff,#ff,#ff,#ff,#87,#ff,#ff
db #ff,#20,#21,#22,#23,#24,#25,#26
db #27,#b0,#b1,#28,#29,#2a,#ff,#2b
db #2c,#2d,#ff,#ff,#ff,#2e,#ff,#ff
db #ff,#2f,#30,#31,#32,#53,#ff,#ff ;.....S..
db #54,#55,#56,#57,#58,#59,#5a,#ff ;TUVWXYZ.
db #ff,#ff,#5b,#5c,#5d,#5e,#5f,#ff
db #ff,#60,#88,#89,#8a,#a6,#ff,#a7
db #a8,#a9,#aa,#ab,#ac,#ad,#ff,#ff
db #ff,#ff,#ae,#af,#ff,#ff,#ff,#ff
db #ff,#b2,#b3,#b4,#b5,#ff,#ff,#ff
db #ff,#b6,#b7,#b8,#b9,#ff,#ff,#ff
db #ff,#ff,#ba,#bb,#bc,#ff,#ff,#ff
db #00,#01,#ff,#ff,#ff,#ff,#02,#03
db #ff,#ff,#ff,#ff,#04,#05,#ff,#ff
db #ff,#ff,#06,#07,#08,#ff,#ff,#ff
db #09,#0a,#0b,#ff,#ff,#ff,#0c,#0d
db #0e,#ff,#ff,#ff,#0f,#ff,#10,#ff
db #ff,#00,#01,#ff,#ff,#ff,#ff,#11
db #12,#ff,#ff,#ff,#ff,#13,#14,#ff
db #ff,#ff,#ff,#15,#16,#ff,#ff,#ff
db #ff,#17,#18,#ff,#ff,#ff,#ff,#ff
db #19,#ff,#ff,#ff,#ff,#ff,#1a,#ff
db #ff,#ff,#00,#01,#ff,#ff,#ff,#ff
db #1b,#1c,#ff,#ff,#ff,#ff,#1d,#1e
db #1f,#ff,#ff,#ff,#34,#35,#36,#ff
db #ff,#ff,#37,#38,#39,#ff,#ff,#ff
db #3a,#3b,#3c,#ff,#ff,#ff,#3d,#ff
db #3e,#ff,#ff,#3f,#40,#ff,#ff,#ff
db #41,#42,#43,#ff,#ff,#ff,#44,#45 ;ABC...DE
db #46,#ff,#ff,#ff,#47,#48,#49,#ff ;F...GHI.
db #ff,#ff,#4a,#4b,#4c,#ff,#ff,#ff ;..JKL...
db #4d,#4e,#4f,#ff,#ff,#ff,#50,#51 ;MNO...PQ
db #52,#ff,#ff,#62,#61,#ff,#ff,#ff ;R..ba...
db #ff,#67,#66,#65,#ff,#64,#63,#6d ;.gfe.dcm
db #6c,#6b,#6a,#69,#68,#ff,#70,#6f ;lkjih.po
db #6e,#ff,#ff,#ff,#72,#71,#ff,#ff ;n...rq..
db #ff

lab8103 db #ff
db #74,#73,#ff,#ff,#ff,#ff,#76,#75 ;ts....vu
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #8b,#8c,#ff,#ff,#ff,#8d,#8e,#8f
db #90,#91,#92,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #bd,#ff,#ff,#ff,#be,#bf,#c0,#c1
db #c2,#c3,#ff
lab814F db #41
db #80,#6a,#80,#93,#80,#6a,#80 ;.j...j.
lab8157 db #0
db #00
lab8159 db #0
lab815A db #e1
db #7f,#f9,#7f,#11,#80
lab8160 db #0


background_tiles: ; x9
;lab8161
db #fe,#82,#a2,#a2,#ba,#82,#fe,#00,#20
db #00,#00,#00,#00,#00,#00,#00,#00,#08
db #38,#34,#2c,#1c,#1c,#2c,#34,#38,#39
db #01,#03,#07,#0d,#19,#31,#61,#c1,#0f
db #80,#c0,#e0,#b0,#98,#8c,#86,#83,#0f
db #20,#28,#20,#27,#2f,#2f,#2f,#2f,#39 ; Echelle Gauche
db #02,#0a,#02,#e2,#f2,#f2,#f2,#f2,#39 ; Echelle Droite

db #aa,#00,#00,#00,#00,#00,#00,#00,#0a
db #ff,#40,#40,#40,#ff,#04,#04,#04,#08
db #10,#17,#1f,#1f,#10,#17,#1f,#1f,#39
db #08,#e8,#f8,#f8,#08,#e8,#f8,#f8,#39
db #ff,#ff,#ff,#ff,#ff,#87,#07,#03,#08
db #ff,#ff,#ff,#00,#ff,#00,#00,#00,#10
db #ff,#ff,#ff,#f7,#f3,#e2,#e2,#c0,#08
db #00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00,#00

db #52,#54,#55,#b5,#b6,#92,#ca,#4a,#10
db #80,#c0,#40,#60,#e0,#20,#20,#30,#08
db #f8,#4c,#44,#46,#fe,#06,#07,#05,#08
db #fe,#82,#a2,#a2,#ba,#82,#fe,#00,#20
db #00,#00,#00,#ff,#ff,#00,#ff,#00,#0e
db #00,#00,#ff,#ff,#ff,#ff,#00,#ff,#0e
db #00,#ff,#ff,#ff,#ff,#ff,#00,#ff,#0e
db #00,#f0,#fc,#fe,#ff,#ff,#20,#f0,#0e
db #80,#c0,#40,#60,#31,#1a,#0c,#00,#08
db #08,#30,#40,#80,#00,#00,#00,#00,#08
db #f8,#e0,#c1,#80,#81,#02,#01,#02,#11
db #5f,#af,#57,#ab,#55,#aa,#55,#aa,#11
db #01,#02,#01,#80,#81,#c0,#e0,#f8,#11
db #55,#aa,#55,#ab,#55,#ab,#57,#1f,#11
db #00,#00,#00,#00,#00,#00,#00,#00,#20
db #f8,#e1,#3c,#c7,#86,#f9,#22,#d4,#21
db #78,#00,#00,#e0,#00,#00,#00,#00,#21
db #f5,#ca,#e4,#1a,#f4,#f8,#94,#ea,#21
db #d0,#3e,#e5,#4a,#35,#fb,#94,#eb,#21
db #00,#00,#00,#a0,#55,#ea,#56,#f8,#21
db #00,#00,#00,#00,#00,#a8,#54,#e6,#21
db #6f,#6f,#68,#60,#6f,#64,#64,#64,#08
db #f6,#f6,#16,#46,#f6,#06,#06,#06,#08
db #bc,#00,#00,#00,#00,#00,#00,#00,#21
db #3f,#00,#00,#00,#00,#00,#00,#00,#21
db #ff,#0b,#1c,#03,#05,#3f,#01,#03,#21
db #00,#00,#00,#00,#00,#00,#0e,#03,#21
db #00,#03,#00,#00,#0f,#1b,#07,#cf,#21
db #6f,#6f,#68,#62,#6a,#62,#6e,#60,#20
db #f6,#f6,#16,#a6,#b6,#86,#f6,#06,#20
db #80,#40,#20,#1f,#10,#10,#10,#10,#38
db #00,#00,#00,#ff,#00,#00,#00,#00,#38
db #01,#02,#04,#f8,#08,#08,#08,#08,#38
db #10,#10,#10,#10,#10,#10,#10,#10,#38
db #00,#0f,#08,#0a,#08,#08,#09,#08,#39
db #00,#ff,#00,#20,#41,#a2,#41,#a0,#39
db #00,#f0,#10,#90,#50,#90,#10,#90,#39
db #08,#08,#08,#08,#08,#08,#08,#08,#38
db #09,#0a,#09,#0a,#09,#08,#0f,#00,#39
db #41,#82,#45,#02,#14,#00,#ff,#00,#39
db #10,#10,#50,#90,#50,#10,#f0,#00,#39
db #00,#00,#00,#00,#00,#00,#00,#00,#39
db #00,#06,#3e,#06,#06,#06,#06,#00,#39
db #f7,#87,#a7,#a7,#b7,#87,#f7,#07,#20
db #ff,#ff,#c0,#a2,#3a,#02,#7e,#00,#20
db #ff,#ff,#00,#a2,#ba,#82,#fe,#00,#20
db #ff,#ff,#03,#a1,#b9,#82,#fe,#00,#20
db #ee,#e2,#e2,#e2,#ea,#e2,#ee,#e0,#20
db #38,#38,#38,#38,#38,#2a,#2a,#38,#11
db #e3,#e3,#e3,#e3,#e3,#ab,#ab,#e3,#19
db #c7,#c7,#c7,#c7,#c7,#d5,#d5,#c7,#31
db #18,#18,#18,#18,#18,#5a,#5a,#18,#18
db #f3,#f3,#f3,#f3,#f3,#93,#93,#f3,#10
db #cf,#cf,#cf,#cf,#cf,#c9,#c9,#cf,#28
db #00,#ff,#b5,#aa,#b5,#aa,#b5,#00,#28
db #00,#f9,#41,#a1,#41,#a1,#41,#00,#38
db #ff,#aa,#b5,#aa,#b5,#aa,#00,#ff,#28
db #f9,#a1,#41,#a1,#41,#a1,#00,#f9,#38
db #b5,#aa,#b5,#aa,#b5,#00,#ff,#aa,#28
db #41,#a1,#41,#a1,#41,#00,#f9,#a1,#38
db #e3,#f7,#e3,#c9,#d1,#a8,#90,#be,#39
db #90,#b6,#90,#be,#90,#a0,#90,#a0,#39
db #90,#a0,#90,#a0,#90,#a0,#90,#80,#39
db #00,#00,#04,#02,#00,#00,#00,#06,#0e
db #00,#00,#02,#0c,#00,#04,#02,#00,#0d
db #00,#00,#0a,#10,#00,#0a,#04,#00,#0f
db #00,#00,#00,#00,#00,#00,#00,#00,#08
db #00,#00,#40,#30,#00,#00,#40,#00,#0e
db #00,#30,#40,#20,#00,#40,#30,#00,#0d
db #00,#00,#28,#50,#00,#00,#60,#18,#0f
db #ff,#80,#80,#80,#9f,#90,#90,#90,#28
db #ff,#00,#00,#00,#ff,#00,#00,#00,#28
db #ff,#00,#00,#00,#ff,#08,#08,#08,#28
db #ff,#01,#01,#01,#f9,#09,#09,#09,#28
db #90,#90,#90,#90,#90,#90,#90,#90,#28
db #08,#08,#08,#08,#08,#08,#08,#08,#28
db #00,#00,#00,#00,#00,#00,#00,#00,#28
db #09,#09,#09,#09,#09,#09,#09,#09,#28
db #00,#00,#00,#00,#01,#00,#00,#00,#28
db #08,#08,#08,#6b,#aa,#6b,#6b,#08,#28
db #00,#00,#00,#00,#c0,#00,#00,#00,#28
db #9f,#80,#80,#80,#80,#80,#80,#80,#28
db #ff,#00,#00,#00,#00,#00,#00,#00,#28
db #f9,#01,#01,#01,#01,#01,#01,#01,#28
db #00,#00,#00,#00,#00,#00,#00,#00,#f2
db #aa,#55,#3f,#3f,#3b,#37,#3e,#3d,#39
db #aa,#55,#ff,#ff,#bf,#7f,#ff,#ff,#39
db #aa,#55,#fe,#fd,#fe,#fd,#fe,#fd,#39
db #3b,#3f,#3f,#3f,#3f,#3f,#40,#80,#39
db #ff,#ff,#ff,#ff,#ff,#ff,#00,#00,#39
db #fe,#fd,#fe,#fd,#fe,#fd,#02,#01,#39
db #20,#40,#40,#40,#40,#40,#20,#e0,#14
db #05,#03,#03,#03,#03,#03,#05,#07,#14
db #ff,#80,#80,#ff,#80,#80,#80,#80,#28
db #ff,#00,#00,#ff,#02,#02,#02,#03,#28
db #ff,#00,#00,#ff,#00,#00,#00,#ff,#28
db #ff,#00,#00,#ff,#40,#40,#40,#c0,#28
db #ff,#01,#01,#ff,#01,#01,#01,#01,#28
db #80,#80,#80,#80,#80,#80,#80,#ff
db #28,#02,#02,#02,#02,#02,#02,#02
db #fe,#28,#f0,#50,#60,#7f,#40,#80
db #80,#c0,#14,#0f,#0d,#05,#fd,#03
db #01,#01,#03,#14,#40,#40,#40,#40
db #40,#40,#40,#7f,#28,#01,#01,#01
db #01,#01,#01,#01,#ff,#28,#c3,#81
db #a1,#a1,#b9,#81,#fd,#01,#20,#c2
db #82,#a2,#a2,#ba,#82,#be,#80,#20
db #70,#72,#72,#72,#72,#72,#76,#70
db #20,#fd,#81,#a1,#a1,#b9,#81,#e3
db #1f,#20,#be,#82,#a2,#a2,#ba,#82
db #c6,#f8,#20,#0e,#8e,#ae,#ae,#ae
db #8e,#ee,#0e,#20,#e5,#e5,#e5,#e5
db #e5,#e5,#e5,#e5,#10,#01,#01,#01
db #01,#01,#01,#01,#01,#08,#03,#03
db #03,#03,#07,#07,#0f,#1f,#08,#c0
db #bf,#df,#af,#d7,#ab,#d4,#ac,#08
db #00,#ff,#ff,#ff,#ff,#ff,#00,#00
db #08,#01,#fc,#fa,#f6,#ee,#de,#3e
db #3e,#08,#d4,#ac
db #d4,#ac,#d4,#ac,#d4,#ac,#08,#3e
db #3e,#3e,#3e,#3e,#3e,#3e,#3e,#08
db #d4,#ac,#d7,#ae,#dd,#ba,#f5,#ff
db #08,#00,#00,#ff,#aa,#55,#aa,#55
db #ff,#08,#3e,#3e,#de,#ae,#56,#aa
db #55,#ff,#08,#df,#bf,#60,#cc,#d0
db #d0,#c0,#c1,#28,#ff,#ff,#00,#66
db #44,#00,#ff,#00,#28,#fa,#fc,#02
db #0d,#11,#11,#01,#81,#28,#da,#d2
db #d2,#c2,#da,#d2,#d2,#c2,#28,#cd
db #c9,#c9,#c1,#cd,#c9,#c9,#c1,#28
db #c1,#cc,#d0,#d0,#c0,#60,#bf,#00
db #28,#ff,#ff,#00,#66,#44,#00,#ff
db #80,#28,#81,#0d,#11,#11,#02,#04
db #fa,#00,#28,#ff,#df,#f7,#fe,#ff
db #ff,#ff,#ff,#38,#ff,#aa,#ff,#7f
db #ff,#ff,#ff,#ff,#28,#ff,#ef,#ae
db #aa,#ff,#ff,#ff,#ff,#10,#ff,#bd
db #ff,#fd,#ff,#ff,#ff,#ff,#30,#ff
db #e0,#df,#df,#df,#df,#d8,#d8,#08
db #ff,#0f,#ff,#ff,#ff,#ff,#00,#aa
db #08,#fe,#fd,#fa,#ef,#fa,#f5,#fe
db #fd,#20,#20,#40,#20,#00,#82,#05
db #aa,#51,#20,#df,#db,#df,#db,#df
db #da,#d8,#d8,#08,#54,#aa,#d4,#aa
db #d4,#aa,#04,#02,#08,#df,#ff,#df
db #ff,#df,#eb,#d5,#ea,#08,#c3,#f0
db #f8,#f8,#f8,#f8,#f8,#f8,#10,#1f
db #5f,#9f,#40,#fc,#53,#f0,#03,#20
db #ff,#ff,#ff,#00,#ff,#57,#2a,#14
db #20,#c0,#c7,#c0,#20,#ff,#e0,#1f
db #00,#20,#07,#0f,#0f,#1f,#1f,#07
db #00,#00,#22,#be,#ff,#b7,#ed,#ff
db #7f,#db,#ff,#78,#fb,#df,#ff,#b7
db #fe,#ef,#fb,#7f,#78,#ef,#bf,#f5
db #7f,#ff,#d6,#ff,#bd,#78,#fd,#ff
db #ff,#ff,#ff,#cf,#fb,#ff,#08,#fb
db #fd,#7f,#f8,#c0,#80,#80,#00,#08
db #fd,#fb,#8f,#03,#03,#01,#01,#01
db #08,#fd,#f7,#ef,#7f,#ff,#fa,#ef
db #ff,#08,#ff,#ff,#5e,#eb,#ff,#ff
db #fe,#ff,#08,#aa,#ff,#55,#aa,#55
db #aa,#55,#00,#4f,#aa,#ff,#55,#aa
db #55,#aa,#55,#00,#4d,#7f,#cf,#b7
db #b7,#d7,#bb,#bb,#bb,#08,#fb,#cf
db #7f,#ff,#fe,#fc,#f8,#f5,#08,#00
db #00,#00,#00,#00,#05,#aa,#55,#08
db #00,#00,#00,#00,#2a,#55,#aa,#55
db #08,#bb,#bb,#b7,#b7,#b7,#77,#f7
db #4f,#08,#be,#57,#aa,#55,#aa,#55
db #aa,#55,#08,#aa,#d5,#ea,#5f,#ae
db #55,#ae,#55,#08,#aa,#55,#aa,#ff
db #ae,#55,#a6,#55,#08,#ae,#7d,#ea
db #df,#b2,#63,#c2,#83,#08,#aa,#55
db #aa,#55,#aa,#55,#aa,#55,#08,#ae
db #55,#af,#5c,#b8,#74,#bf,#75,#08
db #ae,#55,#fe,#07,#03,#05,#ff,#55
db #08,#82,#83,#c2,#63,#b2,#df,#ea
db #d5,#08,#aa,#55,#aa,#55,#ab,#57
db #ae,#5d,#08,#ff,#d5,#ea,#ff,#aa
db #55,#aa,#55,#08,#ff,#55,#aa,#ff
db #aa,#55,#aa,#55,#08,#ea,#75,#ea
db #f5,#ba,#5d,#ae,#57,#08,#00,#00
db #03,#07,#06,#07,#03,#00,#0d,#06
db #06,#87,#4b,#cb,#4b,#8b,#0f,#0f
db #00,#00,#00,#01,#06,#1d,#6a,#7f
db #0f,#0f,#1b,#6b,#db,#ae,#55,#aa
db #ff,#0f,#00,#ff,#aa,#55,#aa,#55
db #ae,#f8,#0f,#00,#fe,#ae,#58,#e0
db #80,#40,#40,#0f,#00,#06,#06,#06
db #05,#06,#1b,#66,#0f,#01,#06,#18
db #60,#80,#00,#ff,#00,#0f,#80,#30
db #30,#30,#33,#3f,#fc,#30,#0f,#40
db #40,#40,#c0,#c0,#40,#40,#40,#0f
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#13,#05,#13,#05,#13,#05
db #13,#05,#28,#41,#14,#81,#a8,#ba
db #ff,#ff,#ff,#28,#64,#65,#67,#67
db #67,#67,#67,#67,#39,#26,#a6,#e6
db #e6,#e6,#e6,#e6,#e6,#39,#fc,#fd
db #7f,#7f,#7f,#3f,#0f,#07,#0a,#be
db #c2,#e2,#f2,#fa,#fc,#fe,#ff,#20
db #fd,#83,#a7,#af,#9f,#bf,#7f,#ff
db #20,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#ff,#7f,#bf,#9f,#af,#87
db #fb,#01,#22,#ff,#fe,#fc,#fa,#f2
db #e2,#de,#80,#22,#00,#00,#00,#00
db #00,#00,#00,#ff,#68,#00,#00,#00 ;....h...
db #00,#00,#00,#00,#ff,#28,#e0,#e0
db #e0,#e0,#e0,#e0,#e0,#e0,#6f,#07 ;......o.
db #07,#07,#07,#07,#07,#07,#07,#28
db #7f,#7f,#3f,#3f,#37,#b3,#12,#00
db #08,#4f,#90,#f2,#fe,#fe,#bf,#bf ;.O......
db #fb,#08,#fe,#f4,#ff,#ff,#fe,#f0
db #e0,#fc,#08,#ff,#ff,#88,#fe,#ff
db #fc,#df,#fe,#08,#e0,#1e,#fe,#fe
db #00,#fc,#fe,#fe,#08,#fd,#d8,#38
db #10,#37,#14,#04,#04,#08,#7f,#17
db #4e,#16,#cc,#14,#0c,#08,#08,#5e ;N.......
db #6c,#8c,#40,#ff,#04,#04,#04,#08 ;l.......
db #ff,#bf,#ff,#df,#9e,#5e,#3e,#5e
db #08,#ff,#ff,#dd,#bd,#de,#da,#e6
db #80,#08,#43,#53,#5f,#7f,#77,#7f ;..CS..w.
db #ff,#ff,#08,#ff,#83,#7f,#ff,#f1
db #0e,#ff,#ff,#08,#7f,#3f,#c0,#ff
db #ff,#f8,#07,#3f,#08,#ff,#ff,#3f
db #e7,#ff,#ff,#ff,#bf,#08,#ff,#7f
db #04,#3f,#7f,#7f,#7f,#ff,#08,#7f
db #7f,#ff,#e7,#1b,#7f,#ff,#ff,#08
db #ff,#01,#7f,#ff,#ff,#7f,#01,#3e
db #08,#ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #08,#e0,#f9,#ff,#fe,#fe,#bd,#fd
db #fe,#08,#8d,#cd,#df,#df,#ff,#ff
db #ff,#ff,#08,#f3,#ff,#fb,#e7,#ff
db #bf,#bd,#7f,#08,#fd,#fe,#fe,#fe
db #ff,#ff,#ff,#ff,#08,#ef,#ef,#ef
db #ef,#ff,#fb,#fb,#fb,#08,#ef,#ef
db #ef,#ff,#ef,#ef,#ef,#ef,#08,#77 ;.......w
db #ff,#bf,#bf,#bf,#df,#df,#ff,#08
db #83,#f8,#ff,#ff,#ff,#df,#ff,#ff
db #08,#fc,#fe,#fd,#fd,#ff,#f7,#f7
db #f7,#08,#ff,#60,#30,#18,#0c,#06
db #03,#01,#0f,#ff,#ff,#81,#42,#24 ;......B.
db #18,#ff,#ff,#0f,#ff,#06,#0c,#18
db #30,#60,#c0,#80,#0f,#fe,#82,#a2
db #a2,#9a,#bc,#7e,#ff,#22,#be,#c2
db #e2,#f2,#fa,#fc,#fe,#ff,#22,#fd
db #83,#a7
lab8A0A db #af
db #9f,#bf,#7f,#ff,#22,#00,#00,#00
db #00,#00,#00,#00,#00,#28,#00,#00
db #00,#00,#00,#00,#00,#00,#10,#55 ;.......U
db #aa,#aa,#aa,#aa,#ff,#aa,#55,#28 ;......U.
db #ff,#ff,#fd,#ff,#ff,#ff,#ff,#bf
db #08,#00,#00,#00,#00,#00,#00,#00
db #00,#79,#08,#08,#08,#ff,#80,#80 ;.y......
db #80,#ff,#10,#80,#ff,#00,#ff,#ff
db #ff,#ff,#ff,#78,#6d,#ff,#ff,#ff ;...xm...
db #b3,#90,#04,#40,#04

lab8A58
    ld hl,lab5137
    ld de,lab5138
    ld bc,#2F
    ld (hl),#ff
    ldir
    ld a,#2
    ld (lab50FD),a
    ld (lab5D25),a
    ret
lab8A6E xor a
    ld (lab50FD),a
    ld (lab5D25),a
    ret

; Reset score 000000
lab8A76 ld hl,lab18B0+5
    ld c,#6
    ld a,#3a ; ??
lab8A7D inc (hl)
    cp (hl)
    jr nz,lab8A87
    ld (hl),''0''
    dec hl
    dec c
    jr nz,lab8A7D
lab8A87 djnz lab8A76

; Redraw Score
lab8A89
	ld de,#5066
    ld c,#e
    ld hl,lab18A9
    jp draw_text

; Erase left part of menu screen
menu_clear_screen:
lab8A94 ld hl,#c000
    xor a
lab8A98 ld c,#18
lab8A9A ld b,#2a
lab8A9C ld (hl),a
    inc l
    djnz lab8A9C
    ld de,22
    add hl,de
    dec c
    jr nz,lab8A9A
    inc h
    inc h
    jr nz,lab8A98
    ret

data8aac db #20
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20,#20,#20,#20,#20
db #20,#20,#20,#20
lab8AC1 db #ea
db #42,#00,#30,#7c,#7a,#3e,#0f,#07 ;B...z...
db #01,#ea,#2c,#00,#8f,#1f,#1f,#17
db #1f,#05,#03,#41,#49,#ea,#0f,#00 ;...AI...
db #01,#23,#03,#03,#03,#c3,#ea,#04
db #03,#01,#01,#21,#ea,#6b,#00,#98 ;.....k..
db #e4,#d2,#f3,#f9,#f8,#9c,#8c,#88
db #a1,#a3,#7f,#ea,#07,#ff,#ea,#04
db #7f,#ea,#07,#3f,#1f,#1f,#07,#01
db #ea,#08,#00,#01,#0f,#4b,#1f,#1f ;.....K..
db #1f,#ff,#fd,#fe,#fd,#e8,#d5,#f8
db #f4,#fa,#fd,#fe,#7d,#7e,#3f,#3b
db #bf,#bf,#3f,#7f,#7f,#fe,#ff,#ff
db #ff,#fa,#f1,#e0,#f5,#e8,#d5,#aa
db #d5
lab8B2B db #e8
db #f5,#f8,#fc,#fe,#dc,#fe
lab8B32 db #fd
db #fe,#ff,#7f,#3f
lab8B37 db #f
db #0f,#87,#03,#03,#03,#61,#ea,#0b ;.....a..
db #00,#01,#31,#11,#01,#ea,#52,#00 ;......R.
db #98,#a4,#74,#78,#f4,#eb,#fe,#cf ;..tx....
db #03,#00,#00,#80,#c0,#c0,#e0,#e0
db #ea,#0e,#ff,#78,#ea,#07,#00,#e0 ;...x....
db #fe,#ff,#ff,#ff,#5f,#ab,#05,#a3
db #51,#aa,#55,#aa,#55,#2a,#55,#aa ;Q.U.U.U.
db #55,#aa,#55,#aa,#55,#aa,#55,#aa ;U.U.U.U.
db #55,#aa,#55,#e8,#f5,#fa,#75,#2a ;U.U...u.
db #55,#aa,#55,#aa,#55,#aa,#55,#aa ;U.U.U.U.
db #57,#2b,#57,#2a,#55,#2a,#55,#aa ;W.W.U.U.
db #55,#aa,#d5,#ab,#df,#fe,#fd,#fa ;U.......
db #f5,#f8,#f1,#fa,#f1,#fa,#75,#fa ;......u.
db #fd,#fe,#ff,#ff,#df,#fa,#f4,#e8
db #f1,#e2,#f1,#fa,#d5,#3a,#7d,#1e
db #ea,#4d,#00,#03,#04,#84,#71,#fe ;.M....q.
db #ff,#7f,#7f,#3f,#0f,#1f,#ea,#0c
db #ff,#fe,#f8,#ea,#0d,#00,#80,#c0
db #e0,#71,#f9,#ff,#ab,#55,#ab,#55 ;.q...U.U
db #ae,#55,#aa,#55,#aa,#55,#aa,#5d ;.U.U.U..
db #aa,#55,#aa,#55,#af,#57,#ae,#5d ;.U.U.W..
db #fe,#f5,#e8,#d1,#e2,#d5,#a2,#45 ;.......E
db #aa,#45,#aa,#55,#aa,#55,#aa,#55 ;.E.U.U.U
db #aa,#55,#aa,#55,#aa,#5f,#fb,#55 ;.U.U...U
db #a2,#01,#2a,#55,#aa,#55,#aa,#55 ;...U.U.U
db #aa,#55,#aa,#55,#aa,#7d,#e8,#55 ;.U.U...U
db #ab,#5f,#bf,#55 ;...U
lab8C0C db #aa
db #55,#aa,#55,#2b,#5f,#bf,#ea,#40 ;U.U.....
db #00,#01,#03,#07,#07,#ea,#09,#0f
db #87,#87,#07,#77,#ea,#14,#ff,#7f ;...w....
db #7f,#ff,#ff,#7f,#7f,#7f,#ff,#ff
db #7f,#7f,#7f,#ff,#ff,#7f,#7f,#ea
db #0d,#ff,#7f,#bf,#5f,#af,#57,#eb ;......W.
db #75,#aa,#57,#aa,#15,#aa,#05,#22 ;u.W.....
db #51,#aa,#55,#aa,#55,#aa,#55,#aa ;Q.U.U.U.
db #55,#aa,#55,#aa,#55,#aa,#55,#aa ;U.U.U.U.
db #55,#aa,#55,#aa,#c1,#e8,#74,#aa ;U.U...t.
db #75,#aa,#55,#aa,#55,#aa,#55,#aa ;u.U.U.U.
db #55,#aa,#55,#aa,#fd,#fe,#df,#af ;U.U.....
db #f5,#e8,#f5,#fa,#d5,#fa,#fd,#fe
db #ea,#3e,#00,#1c,#7f,#ea,#07,#ff
db #87,#01,#00,#cf,#45,#c0,#ea,#3a ;....E...
db #ff,#fe,#fd,#af,#f7,#fa,#55,#aa ;......U.
db #55,#aa,#55,#aa,#55,#aa,#55,#aa ;U.U.U.U.
db #55,#aa,#55,#aa,#55,#aa,#55,#ab ;U.U.U.U.
db #57,#ae,#5c,#b8,#75,#aa,#75,#aa ;W...u.u.
db #7d,#2e,#57,#0a,#57,#aa,#57,#ab ;..W.W.W.
db #55,#aa,#55,#aa,#55,#bf,#ff,#aa ;U.U.U...
db #f5,#e8,#55,#aa,#55,#aa,#55,#ab ;..U.U.U.
db #5f,#bf,#ea,#0c,#20,#ea,#0f,#10
db #3f,#3f,#3f,#ea,#06,#09,#08,#08
db #08,#0b,#ea,#04,#07,#ea,#04,#05
db #ea,#06,#03,#07,#04,#07,#ea,#04
db #03,#07,#07,#07,#87,#c7,#c7,#e7
db #e7,#f7,#f7,#ea,#05,#ff,#7f,#ea
db #22,#ff,#df,#bf,#7f,#ea,#13,#ff
db #de,#b6,#7a,#ff,#ff,#df,#af,#55 ;..z....U
db #aa,#55,#aa,#55,#aa,#55,#aa,#55 ;.U.U.U.U
db #aa,#55,#aa,#55,#aa,#5f,#ba,#55 ;.U.U...U
db #fa,#5d,#0e,#57,#ab,#55,#aa,#55 ;...W.U.U
db #aa,#55,#aa,#55,#aa,#55,#aa,#55 ;.U.U.U.U
db #fa,#5d,#aa,#55,#aa,#55,#aa,#fd ;...U.U..
db #fe,#5d,#ae,#55,#aa,#55,#aa,#55 ;...U.U.U
db #aa,#d5,#ff,#ea,#18,#02,#fb,#c7
db #e9,#ba,#a7,#c1,#81,#a2,#92,#d2
db #c3,#87,#ea,#0b,#ff,#ea,#04,#fd
db #ea,#05,#ff,#07,#f8,#ea,#19,#ff
db #c7,#f8,#ff,#ff,#ff,#ea,#05,#fe
db #fc,#fc,#fe,#fe,#ff,#ff,#ff,#fe
db #fe,#ea,#04,#ff,#8f,#7f,#ea,#08
db #ff,#f9,#fe,#ea,#11,#ff,#ef,#df
db #ee,#f7,#bb,#5f,#be,#5f,#ab,#55 ;.......U
db #ab,#55,#aa,#55,#aa,#55,#aa,#55 ;.U.U.U.U
db #e8,#f5,#aa,#77,#bb,#57,#aa,#57 ;...w.W.W
db #aa,#55,#aa,#54,#aa,#55,#aa,#55 ;.U.T.U.U
db #aa,#55,#aa,#55,#aa,#51,#a2,#45 ;.U.U.Q.E
db #8a,#45,#aa,#45,#aa,#55,#aa,#55 ;.E.E.U.U
db #aa,#55,#aa,#55,#af,#5f,#ff,#ea ;.U.U....
db #38,#00,#80,#80,#80,#00,#00,#ea
db #0c,#80,#ea,#0a,#40,#c0,#f0,#f0
db #ea,#0a,#20,#ea,#07,#10,#d0,#fe
db #ff,#ff,#fe,#fe,#7c,#3c,#98,#ea
db #04,#90,#f8,#3c,#fc,#c8,#c8,#88
db #ea,#08,#08,#04,#04,#84,#84,#c4
db #c4,#e4,#f4,#f4,#fc,#fc,#bc,#1f
db #ef,#d7,#ef,#fd,#ff,#7d,#bf,#5f
db #fe,#7f,#e8,#f4,#e0,#c1,#8a,#15
db #8a,#15,#2a,#15,#2a,#55,#2a,#55 ;.....U.U
db #aa,#55,#aa,#55,#aa,#55,#ab,#55 ;.U.U.U.U
db #ab,#d5,#aa,#55,#aa,#57,#af,#57 ;...U.W.W
db #af,#7f,#ff,#7f,#ea,#05,#ff,#ea
db #8f,#00,#81,#f8,#fc,#fc,#f9,#57 ;.......W
db #eb,#ff,#ff,#55,#aa,#55,#00,#01 ;...U.U..
db #aa,#55,#aa,#55,#aa,#55,#aa,#55 ;.U.U.U.U
db #aa,#55,#aa,#55,#aa,#5f,#ff,#d5 ;.U.U....
db #a2,#41,#8a,#55,#ab,#5f,#ea,#0d ;.A.U....
db #ff,#ea,#90,#00,#03,#20,#00,#cc
db #6e,#fe,#fd,#ff,#fd,#bf,#5f,#ae ;n.......
db #55,#aa,#55,#aa,#55,#ab,#55,#ab ;U.U.U.U.
db #55,#ab,#57,#ab,#55,#ab,#f7,#fb ;U.W.U...
db #5f,#bf,#5f,#bf,#7f,#ea,#0f,#ff
db #ea,#1b,#0e,#ea,#05,#08,#ea,#1b
db #0e,#ea,#05,#08,#ea,#1b,#0e,#ea
db #05,#08,#ea,#1b,#0e,#08,#10,#ea
db #1e,#0e,#08,#10,#ea,#1e,#0e,#08
db #08,#ea,#1e,#0e,#08,#08,#ea,#1d
db #0e,#08,#08,#28,#08,#ea,#17,#0e
db #ea,#05,#08,#10,#08,#08,#08,#ea
db #17,#0e,#08,#10,#08,#08,#08,#10
db #10,#08,#08,#ea,#18,#0e,#ea,#06
db #08,#28,#08,#ea,#18,#0e,#ea,#08
db #08,#ea,#18,#0e,#ea,#08,#08,#ea
db #18,#0e,#ea,#08,#08,#ea,#17,#0e
db #08,#08,#10,#ea,#04,#08,#28,#08
db #ea,#17,#0e,#08,#10,#10,#10,#ea
db #05,#08,#ea,#18,#0e,#08,#10,#10
db #10,#ea,#04,#08,#ea,#17,#0e,#08
db #ea,#07,#10,#08,#08,#ea,#16,#0e
db #08,#ea,#08,#10,#08,#08,#ea,#15
db #0e,#08,#ea,#0a,#10,#ea,#16,#0e
db #08,#ea,#09,#10,#ea,#17,#0e,#ea
db #09,#10,#ea,#16,#0e,#08,#ea,#09
db #10,#ea,#17,#0e,#ea,#09,#10,#7b

draw_ninja:
	ld hl,game_over
    set 0,(hl)

    call setMenuPal

    ld hl,lab8AC1
    ld de,buf_mask
lab8F1B ld a,(hl)
    cp #7b
    jr z,lab8F33
    cp #ea
    jr z,lab8F2D
    ld b,#1
lab8F26 ld (de),a
    inc de
    djnz lab8F26
    inc hl
    jr lab8F1B
lab8F2D inc hl
    ld b,(hl)
    inc hl
    ld a,(hl)
    jr lab8F26

lab8F33
    ld hl,buf_spr1+#c55-#ac0
    ld de,buf_spr3
    ld b,#b
lab8F3B push hl
    ld c,#18
lab8F3E ld a,(hl)
    rrca
    rrca
    rrca
    and #7
    cp #5
    jr nz,lab8F4A
    ld a,#3
lab8F4A dec a
    and #3
    push bc
    ld c,a
    xor a
    rr c
    jr nc,lab8F56
    or #f
lab8F56 rr c
    jr nc,lab8F5C
    or #f0
lab8F5C pop bc
    ld (de),a
    inc de
    ld a,l
    add a,#20
    ld l,a
    jr nc,lab8F66
    inc h
lab8F66 dec c
    jr nz,lab8F3E
    pop hl
    inc hl
    djnz lab8F3B


    ld hl,#C02A ; Ninja drawing destination
    ld de,buf_mask
    exx
    ld hl,buf_spr3
    exx

    ; Draw 11 columns (11* 2 bytes/4pixels)
    ld b,#b
lab8F7A ld c,#18
    push hl
lab8F7D
    push bc
    push hl

    ; draw ninja drawing tile (menu)
    ld b,#8
lab8F81
    ld a,(de)
    push de
    ld d,#ce
    ld e,a
    ld a,(de)
    exx
    or (hl)
    exx
    ld (hl),a
    inc d
    ld a,(de)
    inc l
    exx
    or (hl)
    exx
    ld (hl),a
    pop de
    dec l
    ld a,h
    add a,#8
    ld h,a
    inc de
    djnz lab8F81

    exx
    inc hl
    exx
    pop hl
    ld bc,#40
    add hl,bc
    pop bc
    dec c
    jr nz,lab8F7D

	pop hl
    inc hl
    inc hl
    djnz lab8F7A

    call lab8A94
    ret

lab8fb0
data8fb0
    call draw_ninja ; lab8F0D
    ld b,#f
    ld hl,txt_high_score_table
lab8FB8 ld de,lab18B0
    push hl
    ld c,#6
lab8FBE ld a,(de)
    cp (hl)
    jr nz,lab8FD1
    inc hl
    inc de
    dec c
    jr nz,lab8FBE
lab8FC7 pop hl
    ld de,#11
    add hl,de
    djnz lab8FB8
    jp lab901E
lab8FD1 jr c,lab8FC7
    pop hl
    push bc
    ld de,#4043
    ld hl,txt_congrats
    ld c,#f
    call draw_text
    ld de,#40A2
    ld c,#12
    call draw_text
    ld de,#40E4
    ld c,#e
    call draw_text
    ld de,#4863
    ld c,#f
    call draw_text
    call lab92DB
    pop bc
    ld hl,lab95B3
    ld de,lab95A2
lab9002 ld c,#11
lab9004 dec hl
    dec de
    ld a,(de)
    ld (hl),a
    dec c
    jr nz,lab9004
    djnz lab9002
    ld hl,lab18B0
    ld bc,6
    ldir
    inc hl
    inc hl
    ld c,#b
    ldir
lab901B call lab8A94

lab901e:
    ld c,#b
    ld hl,txt_high_score_title
    ld de,#4063
    call draw_text
    ld b,#f
    ld hl,txt_high_score_table
    ld de,#40C1
lab9031 push bc
    ld c,#6
    call draw_text
    push hl
    ld hl,lab95B3
    ld c,#2
    call draw_text
    pop hl
    ld c,#b
    call draw_text
    push hl
    ld hl,13
    rr d
    rr d
    rr d
    add hl,de
    ex de,hl
    rl d
    rl d
    rl d
    pop hl
    pop bc
    djnz lab9031
    call lab9346
    ld bc,labC350
lab9062 push bc
    call lab40D1
    or a
    pop bc
    jr nz,lab906F
    dec bc
    ld a,b
    or c
    jr nz,lab9062

; Main Menu
lab906F
    call lab8A94
    ld hl,lab93EB
    ld c,#b
    ld de,#4083
    call draw_text
    ld c,#9
    ld de,#40C3
    call draw_text
    ld c,#b
    ld de,#4803
    call draw_text
    ld c,#10
    ld de,#4863
    call draw_text
    ld c,#10
    ld de,#48A3
    call draw_text
    ld c,#d
    ld de,#5003
    call draw_text
    call lab918F
    call lab9346
    call lab93DF
    ld bc,labC350
lab90B1 push bc
    call lab40D1
    push af
    ld a,(key_state+9)
    and #10
    jp nz,lab90E0
    pop af
    cp #4b
    jp z,lab936E
    cp #54
    jp z,lab937E
    cp #4a
    jp z,lab93BE
    cp #52
    jp z,lab919A
    cp #4d
    jp z,lab90EE
    cp #53
    jr nz,lab90E5
lab90DC pop bc
    jp lab15C5
lab90E0 call lab93C4
    jr lab90DC
lab90E5 pop bc
    dec bc
    ld a,b
    or c
    jr nz,lab90B1
    jp lab901B
lab90EE
    call lab8A94
    ld de,#4044
    ld hl,lab92A3
    ld c,#d
    call draw_text
    ld de,#4084
    ld c,#c
    call draw_text
    ld de,#40E3
    ld c,#e
    call draw_text
    ld de,#4822
    ld c,#11
    call draw_text
    call lab9346
    call lab92DB


; Check Passwords
	ld b,#9

lab911C ld hl,lvlCodes
lab911F ld de,lab18B8
        ld c,#b
        push hl
lab9125 ld a,(de)
        cp (hl)
        jr nz,lab9158
        inc hl
        inc de
lab912B dec c
        jr nz,lab9125
        pop hl
        ld a,b
        ld (cur_level),a

        add a,#30
        ld (lab914E),a

        ld hl,lab9146
        ld c,#12
        ld de,#48A2
        call draw_text
        jr lab9172

cur_level: db #1		;#9145

lab9146 db "MISSION "
lab914E db #58," SELECTED"

lab9158
    pop hl
    ld de,11
    add hl,de
    djnz lab911F
    ld hl,txt_code_not_recognised
    ld de,#48A5
    ld c,12
    call draw_text
    ld de,#48C4
    ld c,14
    call draw_text
lab9172 ld hl,lab1180
    ld de,#50A4
    ld c,#d
    call draw_text
    ld de,#50C4
    ld c,#c
    call draw_text
    call lab9346
    call lab934C
    pop bc
    jp lab906F
lab918F
    ld de,#40C6
    ld c,#8
    ld hl,data93e3
    jp draw_text
lab919A call lab8A94
    ld de,#4046
    ld hl,lab940E
    ld c,#d
lab91A5
    call draw_text
    call lab9346
    ld de,#4084
    ld hl,txt_directions
    ld b,#5
    ld ix,lab3EAD
lab91B7 push bc
    ld c,#5
    call draw_text
    push hl
    push de
lab91BF call lab402E
    or a
    jr z,lab91BF
    cp #5b
    jr nc,lab91BF
    cp #20
    jr z,lab91D9
    cp #30
    jr c,lab91BF
    cp #3a
    jr c,lab91D9
    cp #41
    jr c,lab91BF
lab91D9 ld (data9352+1),a
    ld hl,6
    add hl,de
lab91E0 ex de,hl
lab91E1 ld hl,data9352
    ld c,#3
    call draw_text
    ld a,(data9352+1)
    ld hl,lab4023
    push bc
    ld b,#ff
lab91F2 inc b
    inc hl
    ld a,(hl)
    or a
    jr z,lab91F2
    ld (ix+0),b
    ld (ix+1),a
    ld (ix+10),b
    ld (ix+11),a
    inc ix
    inc ix
    call lab9346
    pop bc
    pop de
    ld hl,#3B
    rr d
lab9212 rr d
    rr d
    add hl,de
    ex de,hl
    rl d
    rl d
    rl d
    pop hl
    pop bc
    djnz lab91B7
    pop bc
    jp lab906F

txt_code_not_recognised:
data9226 db "MISSION CODE"
         db "NOT RECOGNISED"

; codes
lvlCodes:
 db "SATORI     "
 db "DIM MAK    "
 db "MILU KATA  "
 db "GENIN      "
 db "SAIMENJITSU"
 db "KUJI KIRI  "
 db "KIME       "
 db "JONIN      "
 db "           "

assert $ == #92A3

lab92A3 db "TYPE REQUIRED"
        db "MISSION CODE"
        db "OR PRESS ENTER"
        db "FOR FIRST MISSION"

assert $ == #92DB

lab92DB ld b,#b
    ld hl,lab18B8
lab92E0 ld (hl),#20
    inc hl
    djnz lab92E0
    ld b,#1
    exx
    ld hl,labC38C
    exx
    ld de,lab48A6
    ld hl,lab18B8
lab92F2 push bc
    exx
    ld a,#ff
    ld (hl),a
    inc l
    ld (hl),a
    dec l
    exx
lab92FB call lab9346
    call lab40CB
    cp #7f
    jp z,lab9438
    cp #d
    jr z,lab933D
    pop bc
    push bc
    push de
    ld d,a
    ld a,b
    cp #c
    ld a,d
    pop de
    jr z,lab92FB
    cp #20
    jr z,lab9323
    cp #41
    jp m,lab92FB
    cp #5c
    jp p,lab92FB
lab9323 ld (hl),a
    ld c,#1
    call draw_text
    exx
    xor a
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    exx
    pop bc
    inc b
    push bc
lab9333 push de
    push hl
    call lab9346
    pop hl
    pop de
    pop bc
    jr lab92F2
lab933D pop bc
    exx
    xor a
    ld (hl),a
    inc l
    ld (hl),a
    dec l
    exx
    ret

; Wait Key
lab9346 call lab40D1
    	ret nc
    	jr lab9346

lab934C call lab40D1
    	ret c
    	jr lab934C

data9352 db #22,0,#23
txt_directions:
        db "UP   "
        db "DOWN "
        db "LEFT "
        db "RIGHT"
        db "FIRE "

lab936E
    call lab93D1
    ld hl,labC144
    xor a
    ld de,lab3EB7
    call lab93AD
    jp lab90E5
lab937E ld a,(lab93E9+1)
    cp #20
    jr nz,lab9392
    ld a,#46
    ld (lab93E9),a
    ld (lab93E9+1),a
    call labB000
    jr lab939F
lab9392 ld a,#4e
    ld (lab93E9),a
    ld a,#20
    ld (lab93E9+1),a
    call labB006
lab939F call lab918F
    call lab9346
    ld hl,labC1C4
    ld a,#2
    jp lab90E5
lab93AD push hl
    push bc
    ld hl,lab3EAD
    ex de,hl
    ld bc,10
    ldir
    pop bc
    pop hl
    call lab93DC
    ret
lab93BE call lab93C4
    jp lab90E5
lab93C4 call lab93D1
    ld hl,labC244
    ld a,#1
    ld de,lab3EC1
    jr lab93AD
lab93D1 xor a
lab93D2 ld de,labC144
    ld b,#1a
lab93D7 ld (de),a
    inc de
    djnz lab93D7
    ret
lab93DC ld (lab93D2+1),hl
lab93DF ld a,#f
    jr lab93D2
data93e3 db "TUNE O"
lab93E9 db "FF"

lab93EB db #2
    db "K  KEYBOARD"
    db "T        "
    db "J  JOYSTICK"
    db "R  "
lab940E db "REDEFINE KEYS"
        db "M  ALTER MISSIONS  "
        db "START GAME"

assert $==#9438

lab9438:
    pop bc
    ld a,b
    cp #1
    jp z,lab92F2
    dec b
    push bc
    dec hl
    dec de
    ld a,#20
    ld (hl),a
    ld c,#1
    call draw_text
    dec hl
    dec de
    exx
    xor a
    ld (hl),a
    inc l
    ld (hl),a
    dec l
    dec l
    dec l
    exx
    jp lab9333

assert $==#9459

txt_congrats:
         db "CONGRATULATIONS"  ; 9459
         db "YOU ARE NOW A TRUE"
         db "NINJA SABOTEUR"
         db "ENTER YOUR NAME" ; #9488

txt_high_score_title
lab9497 db #1
        db "HIGH SCORES"
assert $==#94a3
txt_high_score_table            ;lab94A3
    db "001000"," CLIVE     "
    db "000140","NINA JANE  "
    db "000130","W RUSSEL B "
    db "000120","MICKY!LISA "
    db "000110","LEE        "
    db "000100","DARREN     "
    db "000090","NOEL       "
    db "000080","BRAD AUSTIN"
    db "000070","NICKY      "
    db "000060","JUSTIN     "
    db "000050","CLAIRE     "
    db "000040","JOE TARAO  "
    db "000030","ALAN       "
    db "000020","RICH       "
    db "000010","DIV        "

assert $==#95a2
lab95a2:
db "SPARE SCORE"
db #2b,"NAME "

lab95B3 db #30,#20
lab95B5
    ld hl,lab95D3+1
    rrc (hl)
    ret nc
    ld hl,lab95C5+1
    inc (hl)
    ret

lab95C0 ld a,1 ; rerender?
    or a
    ret z

; Draw Life Gauge
lab95C4 push bc

lab95C5
    ld hl,0 		; Life points #0-#e
    add hl,hl
    ld de,labC54A
    add hl,de

    push hl
    ld de,#40
    add hl,de
    pop de

lab95D3 ld c,#0		; Life sub points (8 steps, for drawing)
    ld a,c
    exx
    push hl
    ld l,a
    ld h,#ce
    ld e,(hl)
    inc h
    ld d,(hl)
    pop hl
    exx
    ld b,#8
lab95E2 ld a,(hl)
    exx
    xor e
    exx
    ld (hl),a
    ld a,(de)
    exx
    xor e
    exx
    ld (de),a
    inc e
    inc l
    ld a,(hl)
    exx
    xor d
    exx
    ld (hl),a
    ld a,(de)
    exx
    xor d
    exx
    ld (de),a
    dec e
    dec l
    ld a,h
    add a,#8
    ld h,a
    ld a,d
    add a,#8
    ld d,a
    djnz lab95E2
    ld hl,lab95D3+1
    rlc (hl)
    jr nc,lab961C
    ld hl,lab95C5+1
    dec (hl)
    jr nz,lab961C
    pop bc
    ld a,#1
    ld (lab34C1),a
    dec a
    ld (lab95C0+1),a
    ret
lab961C pop bc
    djnz lab95C4
    ret
data9620
lab9620
    call lab9742

    ; Tempo
    ld bc,#ea60
lab9626
    dec bc
    ld a,#6
lab9629
    dec a
    jr nz,lab9629
    ld a,b
    or c
    jr nz,lab9626

    call draw_ninja
    ld a,(data178F)
    dec a
    ld a,(lab52D7)
    jr z,lab963F
    ld a,(lab52D6)
lab963F ld hl,lab58B6
    cp (hl)
    jp c,lab8FB0
    call lab9742
    call lab9742
    ld de,#5061
    ld hl,lab96E5
    ld c,#5
    call draw_text
    ld hl,lab974D
    ld de,#4043
    ld c,#f
    call draw_text
    ld de,#40A1
    ld c,#12
    call draw_text
    ld de,#40E0
    ld c,#15
    call draw_text
    ld a,(cur_level)
    cp #9
    jr nz,lab96EA
    ld hl,lab969F
    ld de,#4822
    ld c,#10
    call draw_text
    ld de,#4861
    ld c,#12
    call draw_text
    ld de,#48C2
    ld c,#11
    call draw_text
    ld de,#5001
    ld c,#13
    call draw_text
    jp lab9726




db "YOU HAVE REACHED"
db "THE ULTIMATE LEVEL"

db "YOU HAVE MASTERED"
db "THE ART OF NINJUTSU"
db "TOTAL"

lab96EA add a,"1"
    ld (code_stage_number),a
    ld hl,#9783 ; Text Label
    ld de,#4864
    ld c,12
    call draw_text
    ld de,#48A5
    ld c,10
    call draw_text
    ld de,#48E5
    ld c,1
    call draw_text
    push de
    ld a,(cur_level)
    ld de,#fff5
    ld hl,lab9298
lab9714 add hl,de
    dec a
    jr nz,lab9714
    pop de
    ld c,#b
    call draw_text
    ld hl,data9352+2
    ld c,#1
    call draw_text

lab9726 ld hl,lab1180
lab9729 ld de,#50A4
lab972C ld c,#d
    call draw_text
    ld de,#50C4
    ld c,#c
    call draw_text
    call lab9346
    call lab934C
    jp lab8FB0
lab9742 ld b,#fa
    call lab8A76
    ld b,#fa
    call lab8A76
    ret

lab974D
    db "CONGRATULATIONS"
    db "YOU HAVE COMPLETED"
    db "YOUR ASSIGNED MISSION"
    db "THE CODE FOR"
    db "STAGE "
code_stage_number:
    db "X IS",#22
lab979A db #0

lab979B ld a,(lab93E9+1)
    cp #20
    ret nz
    ld a,4
    ld (lab3E78),a
    ret

db #ef,#08,#08,#ef ;.x......
db #10,#04,#f7,#10,#02,#ef,#04,#01
db #ef,#01,#10,#fd,#01,#08,#fe,#02
db #04,#7f,#08,#02,#7f,#04,#01,#7f
db #01,#10

font32:
db #00,#00,#00,#00,#00,#00,#00,#00 ; SPACE
db #00,#36,#49,#41,#41,#22,#14,#08
db #0a,#0a,#00,#00,#00,#00,#00,#00
db #50,#50,#00,#00,#00,#00,#00,#00
db #00,#08,#3e,#28,#3e,#0a,#3e,#08 ; $
db #ff,#ff,#de,#ff,#ed,#bf,#ff,#00
db #ff,#be,#fb,#ff,#de,#ff,#ff,#00
db #00,#00,#08,#00,#00,#08,#00,#00
db #00,#1c,#22,#78,#20,#20,#7e,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#7e,#42,#42,#46,#46,#7e,#00 ; 0
db #00,#08,#08,#08,#18,#18,#18,#00
db #00,#7e,#02,#02,#7e,#60,#7e,#00
db #00,#7e,#02,#1e,#06,#06,#7e,#00
db #00,#42,#42,#7e,#06,#06,#06,#00
db #00,#7e,#40,#7e,#06,#06,#7e,#00
db #00,#7e,#40,#7e,#46,#46,#7e,#00
db #00,#7e,#02,#02,#06,#06,#06,#00
db #00,#7e,#42,#7e,#46,#46,#7e,#00
db #00,#7e,#42,#7e,#06,#06,#06,#00 ; 9

db #00,#00,#10,#00,#00,#10,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00

db #00,#7e,#42,#42,#7e,#46,#46,#00 ; A
db #00,#7c,#42,#7c,#46,#46,#7c,#00 ; B
db #00,#7e,#40,#40,#60,#60,#7e,#00
db #00,#7c,#42,#42,#46,#46,#7c,#00
db #00,#7e,#40,#7e,#60,#60,#7e,#00
db #00,#7e,#40,#7e,#60,#60,#60,#00
db #00,#7e,#42,#40,#4e,#46,#7e,#00
db #00,#42,#42,#7e,#46,#46,#46,#00
db #00,#08,#08,#08,#18,#18,#18,#00
db #00,#02,#02,#02,#46,#46,#7e,#00
db #00,#42,#42,#7e,#4c,#4c,#4c,#00
db #00,#40,#40,#40,#40,#40,#7e,#00
db #00,#7e,#52,#52,#56,#56,#56,#00
db #00,#72,#52,#52,#56,#56,#5e,#00
db #00,#7e,#42,#42,#46,#46,#7e,#00 ; O
db #00,#7e,#42,#42,#7e,#60,#60,#00
db #00,#7e,#42,#42,#4e,#4e,#7f,#07
db #00,#7e,#42,#42,#7e,#4c,#4c,#00
db #00,#7e,#40,#7e,#06,#06,#7e,#00
db #00,#7e,#08,#08,#18,#18,#18,#00
db #00,#42,#42,#42,#46,#46,#7e,#00
db #00,#42,#42,#42,#2c,#2c,#18,#00
db #00,#52,#52,#52,#56,#56,#7e,#00
db #00,#42,#24,#18,#18,#2c,#46,#00
db #00,#42,#42,#7e,#18,#18,#18,#00
db #00,#7e,#02,#7e,#60,#60,#7e,#00 ; Z


print #9d00-$, "Octets libres en ",$

org #9d00

; aligned on 8 bytes
lab9D00 db #0
db #00,#01,#01,#01,#01,#01,#22,#00
db #e0,#f0,#f0,#30,#f0,#f8,#96,#71 ;.......q
db #71,#63,#77,#37,#3f,#3f,#3f,#78 ;qcw....x
db #ff,#9f,#6f,#77,#b7,#dc,#ef,#00 ;..ow....
db #00,#00,#80,#80,#c0,#c0,#c0,#3d
db #39,#11,#01,#01,#03,#03,#06,#37
db #f9,#04,#7c,#fc,#fe,#f2,#ee,#c0
db #c0,#00,#00,#00,#00,#00,#00,#07
db #07,#0f,#0f,#0f,#0f,#1f,#1f,#5f
db #9f,#ff,#df,#9f,#8f,#0f,#07,#1e
db #1c,#3c,#3c,#3c,#2c,#34,#78,#07 ;......x.
db #03,#03,#03,#03,#03,#02,#01,#80
db #80,#80,#80,#80,#c0,#40,#c0,#00
db #00,#00,#00,#00,#01,#01,#07,#78 ;.......x
db #70,#60,#60,#e0,#e0,#c0,#c0,#01 ;p.......
db #00,#00,#00,#00,#00,#01,#01,#c0
db #c0,#c0,#c0,#c0,#e0,#e0,#e0,#00
db #1c,#1e,#3e,#26,#3e,#3e,#1e,#00
db #00,#00,#00,#00,#00,#00,#e0,#00
db #03,#07,#03,#00,#00,#00,#00,#00
db #9e,#ff,#ff,#0f,#00,#00,#00,#00
db #3f,#ff,#ff,#e7,#01,#01,#00,#e6
db #ff,#ff,#77,#77,#99,#ff,#ff,#f0 ;..ww....
db #70,#60,#e0,#70,#70,#70,#70,#00 ;p..pppp.
db #01,#01,#01,#01,#03,#03,#06,#ff
db #ff,#02,#f2,#fe,#fe,#f3,#ef,#f0
db #e0,#e0,#c0,#00,#00,#00,#00,#00
db #00,#00,#00,#38,#7c,#7c,#4c,#00 ;......L.
db #00,#00,#00,#00,#01,#01,#00,#7d
db #3e,#3f,#0e,#1d,#bd,#bb,#3b,#f0
db #4c,#22,#92,#ca,#c8,#c0,#c0,#03 ;L.......
db #03,#01,#00,#00,#00,#00,#00,#0f
db #ff,#ff,#3e,#05,#0f,#0f,#08,#80
db #80,#40,#c0,#80,#80,#c0,#c0,#0f
db #0f,#0f,#1f,#3f,#7f,#7f,#ff,#c0
db #c0,#c0,#c0,#c0,#80,#80,#80,#f7
db #ff,#7f,#3f,#0f,#07,#07,#0f,#80
db #00,#00,#00,#c0,#70,#f8,#3c,#09 ;....p...
db #0e,#0e,#0e,#0c,#1c,#3c,#7c,#0c
db #0c,#04,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#01,#03,#0f
db #0f,#0f,#1f,#7f,#ff,#ff,#ff,#e0
db #e0,#c0,#c0,#c0,#c0,#c0,#80,#03
db #03,#03,#01,#00,#00,#00,#00,#ef
db #c7,#c7,#e7,#d3,#53,#39,#1c,#80 ;....S...
db #80,#80,#80,#c0,#c0,#c0,#a0,#0e
db #06,#06,#02,#02,#00,#00,#00,#60
db #70,#30,#30,#18,#18,#3c,#78,#00 ;p.....x.
db #00,#00,#00,#00,#01,#03,#07,#1f
db #1f,#3f,#7f,#ff,#ff,#ff,#ff,#e0
db #e0,#e0,#e0,#c0,#c0,#c0,#c0,#07
db #07,#07,#03,#01,#00,#00,#00,#e7
db #c3,#c3,#c1,#21,#e0,#e0,#f0,#c0
db #e0,#e0,#f0,#f0,#f8,#fe,#7b,#70 ;.......p
db #38,#18,#18,#38,#30,#00,#00,#17
db #0f,#01,#00,#00,#00,#00,#00,#80
db #e0,#f0,#70,#30,#30,#30,#70,#00 ;..p...p.
db #00,#00,#00,#00,#00,#01,#01,#0f
db #0f,#1f,#3f,#7f,#ff,#ff,#ff,#e0
db #e0,#e0,#e0,#f0,#f0,#f0,#f0,#03
db #03,#03,#03,#03,#03,#02,#03,#f1
db #f0,#e0,#c0,#80,#80,#80,#00
;9ef0
db #f0,#f0,#fc,#7c,#7e,#3e,#0f,#06
db #00,#00,#00,#00,#00,#00,#80,#c0
db #07,#06,#06,#0e,#0c,#1c,#3c,#78
db #01,#00,#00,#00,#00,#00,#00,#00
db #e0,#f0,#38,#0e,#06,#02,#02,#00
db #00,#00,#00,#00,#01,#03,#07,#0f
db #00,#03,#0f,#7f,#ff,#ff,#ff,#ff
db #7f,#3f,#fe,#fe,#ff,#ff,#ff,#83
db #f0,#e0,#ec,#de,#3e,#fe,#fe,#fc
db #00,#00,#01,#03,#0f,#3f,#fc,#fc
db #1f,#7f,#fe,#f8,#c0,#00,#00,#00
db #e0,#80,#00,#00,#00,#00,#00,#00
db #3c,#38,#38,#70,#70,#e0,#f0,#fc
db #01,#03,#03,#03,#03,#01,#01,#01
db #bc,#b8,#d7,#ef,#ff,#ff,#ef,#f3
db #00,#00,#00,#00,#00,#00,#01,#03
db #f0,#f0,#f0,#e0,#e0,#70,#f0,#f0
db #00,#00,#03,#07,#07,#04,#67,#73
db #00,#00,#80,#c0,#c0,#ce,#ff,#ff
db #00,#00,#00,#00,#00,#00,#86,#ef
db #00,#00,#00,#00,#00,#00,#01,#07
db #00,#00,#00,#00,#00,#28,#82,#c0
db #00,#02,#40,#04,#00,#f8,#f0,#82
db #00,#00,#00,#00,#30,#7b,#77,#77
db #77,#2e,#0e,#1f,#1f,#df,#ef,#f0
db #66,#9b,#7d,#fd,#fb,#e7,#9f,#7e
db #fc,#fe,#fe,#ff,#7f,#57,#77,#3b
db #fc,#fc,#78,#f8,#fc,#fc,#fc,#fc
db #39,#3c,#1d,#1d,#39,#39,#73,#63
db #fc,#f8,#30,#f0,#f0,#f0,#f0,#e0
db #03,#03,#01,#01,#00,#00,#00,#00
db #e0,#c0,#e0,#90,#f0,#f8,#78,#38 ;......x.
db #3c,#1c,#1c,#0e,#0e,#0e,#7c,#f8
db #00,#00,#00,#80,#c0,#c0,#c0,#e0
db #e0,#f8,#3e,#1f,#0f,#07,#07,#03
db #fc,#7e,#7f,#3f,#1f,#0f,#07,#03
db #01,#00,#01,#01,#01,#01,#03,#03
db #f0,#f0,#f0,#70,#38,#3c,#1c,#1e ;...p....
db #00,#00,#00,#00,#01,#01,#01,#03
db #7c,#7b,#f7,#e7,#e7,#c7,#c7,#cb
db #0e,#8e,#cf,#cf,#de,#de,#de,#ac
db #03,#03,#03,#00,#00,#00,#00,#00
db #dc,#bf,#d6,#ed,#32,#3f,#1f,#1f
db #74,#d4,#e8,#90,#70,#f0,#f0,#e0 ;t...p...
db #0f,#0f,#0f,#17,#18,#1f,#1f,#0f
db #e0,#e0,#e0,#90,#70,#f0,#e8,#de ;....p...
db #0b,#1d,#1e,#1f,#1f,#3f,#3e,#3e
db #bf,#7f,#ff,#3f,#0f,#03,#07,#06
db #00,#c0,#e0,#e0,#e0,#c0,#c0,#80
db #3e,#7c,#7c,#7c,#38,#34,#2c,#1c
db #09,#1f,#1e,#3c,#78,#70,#fc,#fc
db #1e,#0e,#0e,#07,#07,#1f,#1f,#1f
db #00,#00,#00,#00,#00,#00,#06,#0f
db #00,#00,#00,#00,#00,#07,#0f,#0f
db #00,#00,#00,#00,#00,#80,#c0,#c0
db #00,#00,#00,#01,#03,#07,#0f,#0f
db #0f,#06,#03,#c1,#c0,#c0,#80,#60
db #00,#80,#e0,#fc,#ff,#7f,#1f,#03
db #09,#0f,#0f,#1f,#f7,#f8,#ff,#f8
db #c7,#ea,#f4,#fa,#ed,#d0,#f8,#fc
db #03,#00,#00,#00,#00,#00,#00,#00
db #fc,#fb,#7b,#17,#07,#01,#00,#00
db #00,#00,#c0,#f0,#fc,#fe,#7f,#3f
db #76,#36,#37,#3b,#3d,#7e,#9f,#e7
db #7e,#7f,#af,#c7,#ff,#7f,#be,#cc
db #1f,#0f,#03,#01,#00,#00,#00,#00
db #b9,#be,#bf,#bc,#73,#2f,#1f,#07
db #80,#00,#80,#80,#c0,#f0,#fc,#fe
db #01,#02,#0f,#7e,#ff,#ff,#78,#38
db #9e,#7e,#fe,#fe,#78,#40,#00,#00
db #3c,#1c,#00,#00,#00,#00,#00,#00
db #cd,#b2,#4c,#a0,#9e,#c0,#c0,#c0
db #00,#00,#00,#00,#00,#00,#00,#3c
db #00,#02,#76,#fa,#fa,#fa,#fb,#77
db #7e,#ff,#ff,#ff,#fe,#fc,#71,#be
db #fe,#7f,#b0,#b7,#bf,#bf,#7f,#fc
db #00,#e0,#30,#d0,#ae,#af,#af,#36
db #00,#00,#00,#00,#00,#01,#01,#01
db #00,#00,#70,#f0,#e0,#c0,#80,#80
db #00,#01,#01,#00,#0a,#0a,#09,#05
db #c0,#c0,#c0,#e0,#e0,#70,#70,#28
db #03,#03,#02,#01,#01,#00,#00,#00
db #80,#80,#40,#e0,#f0,#fc,#7e,#3f
db #75,#fa,#fa,#9a,#fe,#fd,#fb,#77
db #38,#38,#78,#f0,#f0,#e0,#e0,#c0
db #1f,#07,#07,#07,#03,#00,#03,#03
db #8f,#ff,#ff,#bf,#be,#c6,#fe,#fe
db #80,#80,#00,#00,#00,#00,#00,#00
db #03,#03,#02,#07,#0b,#1d,#3d,#7e
db #fc,#fc,#f8,#08,#f8,#e4,#dc,#bc
db #00,#00,#01,#01,#03,#03,#03,#03
db #fe,#ff,#fe,#f8,#f0,#c0,#c0,#e0
db #fc,#f8,#f8,#f8,#f8,#f8,#f0,#f0
db #01,#00,#00,#00,#00,#00,#00,#00
db #e0,#e0,#50,#38,#1c,#0d,#0d,#1d
db #f0,#f0,#f0,#e0,#a0,#c0,#c0,#c0
db #19,#00,#03,#03,#03,#03,#03,#03
db #c0,#c0,#40,#80,#80,#80,#80,#00
;A200
db #00,#00,#00
db #1c,#3e,#3f,#3b,#33,#00,#08,#16
db #39,#46,#b1,#ec,#d6,#17,#07,#01 ;.F......
db #01,#01,#06,#0f,#0f,#bb,#bd,#bd
db #dd,#de,#ee,#ee,#ee,#00,#80
db #80
db #c0,#c0,#e0,#e0,#d0,#0f,#0f,#06
db #01,#03,#03,#00,#00,#de,#bd,#7b
db #e7,#df,#b4,#6f,#1f,#b8,#f8,#f8 ;...o....
db #f8,#f8,#f0,#00,#80,#07,#03,#01
db #01,#00,#00,#00,#00,#80,#80,#80
db #80,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#07,#1f,#00,#00,#00
db #00,#00,#00,#80,#c0,#48,#51,#a7 ;.....HQ.
db #af,#5e,#b9,#b7,#b7,#6f,#f7,#f7 ;.....o..
db #ff,#0f,#f3,#fd,#fd,#c0,#cf,#df
db #b8,#70,#f0,#a0,#c0,#77,#38,#7f ;.p...w..
db #ff,#ec,#e4,#f0,#70,#1e,#ee,#f7 ;....p...
db #f7,#f7,#fb,#73,#03,#80,#00,#00 ;...s....
db #00,#80,#80,#80,#00,#01,#01,#01
db #01,#01,#00,#0f,#1f,#80,#80,#c0
db #e0,#f8,#f6,#2d,#fb,#00,#00,#00
db #00,#00,#00,#c0,#c0,#1f,#1f,#1f
db #1f,#1d,#0b,#07,#07,#e7,#de,#bd
db #7b,#77,#77,#77,#7b,#80,#60,#f0 ;.www....
db #f0,#f0,#f0,#60,#80,#03,#03,#01
db #01,#00,#00,#00,#01,#bb,#bd,#bd
db #bd,#dd,#6b,#37,#8d,#80,#80,#e0 ;..k.....
db #e8,#cc,#dc,#fc,#7c,#62,#9c,#68 ;.....b.h
db #10,#00,#00,#00,#00,#38,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#01,#00,#00,#00
db #00,#00,#00,#c0,#ce,#00,#00,#00
db #00,#00,#00,#0e,#0f,#01,#01,#00
db #00,#00,#01,#03,#05,#df,#ef,#ee
db #ef,#77,#78,#bf,#bf,#27,#37,#ff ;.wx.....
db #fe,#1c,#ee,#ed,#ed,#0f,#0e,#1d
db #fb,#f3,#03,#03,#01,#cf,#f0,#ff
;#a323
db #ef
db #ef,#f6,#f8,#e0,#9d,#7a,#f5,#e5 ;.....z..
db #8a,#12,#00,#00,#00,#00,#00,#01
db #7a,#fd,#ff,#de,#5e,#3d,#83,#dd ;z.......
db #1c,#01,#07,#07,#dd,#dd,#eb,#6b ;.......k
db #77,#f7,#e2,#04,#fb,#fd,#fd,#ff ;w.......
db #f0,#00,#00,#00,#f8,#ff,#ff,#ff
db #7f,#0f,#00,#00,#00,#03,#bf,#fd
db #fd,#fe,#e0,#00,#30,#f8,#fc,#fe
db #c7,#00,#00,#00,#74,#18,#00,#00 ;....t...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#07,#0f,#0f,#09,#0f
db #07,#01,#00,#00,#c0,#e0,#fc,#ff
db #f1,#d7,#2f,#5f,#00,#00,#00,#00
db #80,#c0,#c0,#e0,#10,#10,#18,#3f
db #fc,#18,#08,#08,#00,#42,#2c,#38 ;.....B..
db #1c,#34,#42,#00,#00,#00,#20,#fc ;..B.....
db #ff,#20,#00,#00,#00,#00,#20,#ff
db #fc,#20,#00,#00,#00,#83,#6c,#f7 ;......l.
db #ff,#3f,#c0,#ff,#5f,#bf,#7d,#f9
db #f1,#cf,#3c,#f3,#f0,#f8,#fe,#ff
db #ff,#0f,#ff,#ff,#00,#00,#00,#00
db #80,#c0,#c3,#dc,#00,#00,#00,#ff
db #ff,#00,#00,#00,#18,#18,#18,#18
db #18,#18,#18,#18,#00,#00,#18,#3e
db #3e,#1c,#00,#00,#00,#30,#38,#7c
db #7c,#30,#00,#00,#60,#a0,#f0,#38
db #1c,#0f,#05,#06,#06,#05,#0f,#1c
db #38,#f0,#a0,#60,#00,#00,#00,#24
db #7e,#db,#81,#00,#00,#24,#66,#e7 ;......f.
db #3c,#18,#00,#00


org #b000

; Init Music
labB000 jp labB010
; Play Music
labB003 jp labb0c3
; Stop Music
labB006 jp labB009

labB009 xor a
    ld (musicOnOff),a
    jp labB140

labB010
    xor a
    ld (musicOnOff),a

    ld c,a
    add a,a
    add a,c
    add a,a
    ld c,a
    ld b,#0

    ld hl,labB524
    add hl,bc
    ld ix,datab05f
    ld c,#21
    xor a
    ld (labB34B+1),a
    ld a,#3
labB02B ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ld (ix+16),#1
    ld (ix+0),b
    ld (ix+29),b
    ld (ix+3),e
    ld (ix+4),d
    ex de,hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (ix+5),#2
    ld (ix+6),b
    pop hl
    ld (ix+1),e
    ld (ix+2),d
    add ix,bc
    dec a
    jr nz,labB02B
    inc a
    ld (labB0C2),a
    ld (musicOnOff),a ; music on
    ret
datab05f db #1
    db #70,#b9,#2a,#b5,#02,#00,#00,#00 ;p.......
    db #00,#00,#01,#00,#00,#00,#00,#20
    db #20,#00,#00,#00,#00,#00,#00,#00
    db #00,#00,#00,#00,#00,#00,#00,#09
labB080 db #23
    db #16,#b9,#78,#b5,#02,#00,#00,#00 ;..x.....
    db #00,#00,#01,#00,#00,#00,#00,#02
    db #02,#1f,#0c,#00,#01,#01,#10,#fd
    db #0f,#00,#00,#00,#00,#01,#00,#12
labB0A1 db #21
    db #cb,#b7,#ee,#b5,#02,#00,#00,#00
    db #dd,#b4,#de,#b4,#00,#00,#00,#01
    db #01,#0d,#0f,#00,#41,#01,#05,#05 ;....A...
    db #0f,#00,#00,#00,#00,#00,#00,#24
labB0C2 db #1


; Play Music
labB0C3
	; Music enabled? => to test inside IT
    ld a,(musicOnOff)
    and a
    ret z

labB0C8 ld a,#1f
    ld (labB115+1),a
    ld hl,labB0C2
    dec (hl)
    jr nz,labB0EE
    ld b,(hl)
    ld ix,datab05f
    call labB24A
    ld ix,labB080
    call labB24A
    ld ix,labB0A1
labB0E6 call labB24A
    ld hl,labB0C2
labB0EC ld (hl),#5
labB0EE ld ix,datab05f
    call labB300
    ld (labB422),hl
    ld (labB42A),a
    ld ix,labB080
    call labB300
    ld (labB424),hl
    ld (labB42B),a
    ld ix,labB0A1
    call labB300
    ld (labB426),hl
    ld (labB42C),a
labB115 ld a,#17
    ld (labB428),a
    ld hl,labB42E
    ld d,#c
labB11F ld e,(hl)
    ld b,#f4
    out (c),d
    ld bc,#F600
    out (c),c
    ld a,#c0
    out (c),a
    out (c),c
    ld b,#f4
    out (c),e
    ld b,#f6
    add a,a
    out (c),a
    out (c),c
    dec hl
    dec d
    jp p,labB11F
    ret


labB140
    ld de,#D000
labB143
	call labB14D
    dec e
    jp p,labB143

    ld de,#073F

labB14D
	ld b,#f4
    out (c),d
    ld bc,#F600
    out (c),c
    ld a,#c0
    out (c),a
    out (c),c
    ld b,#f4
    out (c),e
    ld b,#f6
    add a,a
    out (c),a
    out (c),c
    ret


    call #B9B5 ; ??
    cp (hl)
    ld a,h
    xor e
    and (hl)
    inc de
    sub l
    adc a,l
    ld d,d
    inc a
    ld h,h
    cp d
    inc b
    pop bc
    add a,#cb			; ???

	; Disable music
	xor a
    ld (musicOnOff),a
    pop hl
    jp labB140

    ld c,(ix+5)
    ld b,(ix+6)
    ld l,(ix+3)
    ld h,(ix+4)
    add hl,bc
    inc bc
    inc bc

    ld a,(hl)
    inc hl
    ld d,(hl)
    ld e,a
    or d
    jr nz,labB1A4

    ld l,(ix+3)
    ld h,(ix+4)
    ld bc,2
    ld e,(hl)
    inc hl
    ld d,(hl)
labB1A4 ld (ix+5),c
    ld (ix+6),b
    ld b,#0
    jp labB25C
    ld a,(ix+32)
    ld c,a
    and #7
    ld hl,labB406+1
    xor (hl)
    and c
    xor (hl)
    ld (hl),a
    ld a,#1
    ld (ix+30),a
    jp labB25C
    ld a,(ix+32)
    ld c,a
    and #38
    ld hl,labB406+1
    xor (hl)
    and c
    xor (hl)
    ld (hl),a
    xor a
    ld (ix+30),a
    jp labB25C
    ld hl,labB406+1
    ld a,(ix+32)
    cpl
    and (hl)
    ld (hl),a
    ld a,#1
    ld (ix+30),a
    jr labB25C
    ld a,(de)
    inc de
    ld (ix+7),b
labB1ED ld (ix+8),b
    ld (ix+13),a
    set 2,(ix+0)
    ld a,(de)
    ld (ix+14),a
    inc de
    jr labB25C
    ld a,(de)
    inc de
    ld (labB34B+1),a
    jr labB25C
    ld a,(de)
    ld (ix+27),a
    inc de
    ld a,(de)
    ld (ix+26),a
    inc de
    ld (ix+28),a
    jr labB25C
    set 7,(ix+0)
    set 3,(ix+0)
    jr labB25C
    ld (ix+29),b
    jr labB25C
    ld (ix+29),#40
    jr labB25C
    ld (ix+29),#c0
    jr labB25C
    set 1,(ix+0)
labB233 jr labB25C
    ld (ix+19),b
    res 5,(ix+0)
    jr labB292
    set 4,(ix+0)
    jr labB25C
    set 0,(ix+31)
    jr labB25C
labB24A
    dec (ix+16)
    jr nz,labB29F
    ld (ix+0),b
    res 0,(ix+31)
    ld e,(ix+1)
    ld d,(ix+2)
labB25C ld a,(de)
    inc de
    and a
    jp m,labB2B0
    ld (ix+18),a
    bit 0,(ix+30)
    jr z,labB26E
    ld (labB0C8+1),a
labB26E bit 4,(ix+0)
    jr nz,labB292
    ld a,(ix+25)
    ld (ix+19),a
    set 5,(ix+0)
    set 6,(ix+0)
    res 4,(ix+0)
    ld a,(ix+20)
    ld (ix+22),a
    ld a,(ix+23)
    ld (ix+24),a
labB292 ld a,(ix+17)
    ld (ix+16),a
    ld (ix+2),d
    ld (ix+1),e
    ret
labB29F ld a,(ix+0)
    bit 3,a
    ret z
    rla
    jr nc,labB2AC
    inc (ix+18)
    ret
labB2AC dec (ix+18)
    ret
labB2B0 cp #b8
    jr c,labB2F8
    add a,#20
    jr c,labB2DC
    add a,#10
    jr c,labB2E3
    add a,#10
    jr nc,labB2D5
    ld c,a
    ld hl,labB4D8
    add hl,bc
    ld c,(hl)
    add hl,bc
    ld (ix+11),l
    ld (ix+9),l
    ld (ix+12),h
    ld (ix+10),h
    jr labB25C
labB2D5 add a,#9
    ld (#B0ED),a
    jr labB25C
labB2DC inc a
    ld (ix+17),a
    jp labB25C
labB2E3 ld (ix+25),a
    ld a,(de)
    inc de
    ld (ix+20),a
    ld a,(de)
    inc de
    ld (ix+21),a
    ld a,(de)
    inc de
    ld (ix+23),a
    jp labB25C
labB2F8 ld hl,labB0E6+2
    ld c,a
    add hl,bc
    ld c,(hl)
    add hl,bc
    jp (hl)
labB300
    ld c,(ix+0)
    bit 5,c
    jr z,labB34B
    ld a,(ix+22)
    sub #10
    jr nc,labB333
    bit 6,c
    jr z,labB338
    add a,(ix+19)
    jr nc,labB318
    sbc a,a
labB318 add a,#10
    ld (ix+19),a
    ld a,(ix+24)
    sub #10
    jr nc,labB32E
    res 6,c
    ld a,(ix+21)
    ld (ix+22),a
    jr labB34B
labB32E ld (ix+24),a
    jr labB34B
labB333 ld (ix+22),a
    jr labB34B
labB338 cpl
    sub #f
    add a,(ix+19)
    jr c,labB341
    sub a
labB341 ld (ix+19),a
    dec (ix+24)
    jr nz,labB34B
    res 5,c
labB34B ld a,#0
    add a,(ix+18)
    ld b,a
    ld l,(ix+11)
    ld h,(ix+12)
    ld a,(hl)
    cp #87
    jr c,labB363
    ld l,(ix+9)
    ld h,(ix+10)
    ld a,(hl)
labB363 inc hl
    ld (ix+11),l
    ld (ix+12),h
    add a,b
    ld hl,labB430
    ld d,#0
    add a,a
    ld e,a
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld l,(ix+29)
    bit 6,l
    jr z,labB3C5
    ld h,a
    ld b,(ix+26)
    sla b
    bit 7,l
    ld a,(ix+28)
    jr z,labB38E
    bit 0,c
    jr nz,labB3AC
labB38E bit 5,l
    jr nz,labB39E
    sub (ix+27)
    jr nc,labB3A9
    set 5,(ix+29)
    sub a
    jr labB3A9
labB39E add a,(ix+27)
    cp b
    jr c,labB3A9
    res 5,(ix+29)
    ld a,b
labB3A9 ld (ix+28),a
labB3AC ex de,hl
    srl b
    sub b
    ld e,a
    ld a,d
    ld d,#0
    jr nc,labB3B7
    dec d
labB3B7 add a,#a0
    jr c,labB3C3
labB3BB sla e
    rl d
    add a,#18
    jr nc,labB3BB
labB3C3 add hl,de
    ex de,hl
labB3C5 ld a,c
    xor #1
    ld (ix+0),a
    bit 2,c
    jr z,labB3F0
    ld b,(ix+14)
    djnz labB3ED
    ld c,(ix+13)
    bit 7,c
    jr z,labB3DC
    dec b
labB3DC ld l,(ix+7)
    ld h,(ix+8)
    add hl,bc
    ld (ix+7),l
    ld (ix+8),h
    add hl,de
    ex de,hl
    jr labB3F0
labB3ED ld (ix+14),b
labB3F0 bit 0,(ix+31)
    jr z,labB403
    res 0,(ix+31)
    ld a,#0
    ld (#B116),a
    ld a,#7
    jr labB414
labB403 cpl
    and #3
labB406 ld a,#2a
    jr nz,labB414
    ld a,(#B0C9)
    xor #8
    ld (#B116),a
    ld a,#7
labB414 ld hl,labB429
    xor (hl)
    and (ix+32)
    xor (hl)
    ld (hl),a
    ex de,hl
    ld a,(ix+19)
    ret

; Audio parameters
labB422 db #8
 db #07
labB424 db #2c
 db #01
labB426 db #84
 db #03
labB428 db #17
labB429 db #2a
; Chan volumes
labB42A db #0
labB42B db #0
labB42C db #0
 db #00
labB42E db #0
 db #00

labB430 db #7c
db #07,#08,#07,#b0,#06,#40,#06,#ec
db #05,#94,#05,#44,#05,#f8,#04,#b0 ;...D....
db #04,#70,#04,#2c,#04,#f0,#03,#be ;.p......
db #03,#84,#03,#58,#03,#20,#03,#f6 ;...X....
db #02,#ca,#02,#a2,#02,#7c,#02,#58 ;.......X
db #02,#38,#02,#16,#02,#f8,#01,#df
db #01,#c2,#01,#ac,#01,#90,#01,#7b
db #01,#65,#01,#51,#01,#3e,#01,#2c ;.e.Q....
db #01,#1c,#01,#0b,#01,#fc,#00,#ef
db #00,#e1,#00,#d6,#00,#c8,#00,#bd
db #00,#b2,#00,#a8,#00,#9f,#00,#96
db #00,#8e,#00,#85,#00,#7e,#00,#77 ;.......w
db #00,#70,#00,#6b,#00,#64,#00,#5e ;.p.k.d..
db #00,#59,#00,#54,#00,#4f,#00,#4b ;.Y.T.O.K
db #00,#47,#00,#42,#00,#3f,#00,#3b ;.G.B....
db #00,#38,#00,#35,#00,#32,#00,#2f
db #00,#2c,#00,#2a,#00,#27,#00,#25
db #00,#23,#00,#21,#00,#1f,#00,#1d
db #00,#1c,#00,#1a,#00,#19,#00,#17
db #00,#16,#00,#15,#00,#13,#00,#12
db #00,#11,#00,#10,#00,#0f,#00
labB4D8 db #5
db #06,#1a,#2e,#42,#00,#87,#0c,#18 ;...B....
db #0c,#0c,#0c,#08,#08,#07,#13,#07
db #00,#0c,#00,#00,#00,#08,#14,#08
db #07,#07,#87,#0b,#17,#0b,#0b,#0b
db #06,#06,#04,#10,#04,#00,#0c,#00
db #00,#00,#04,#10,#04,#06,#06,#87
db #06,#12,#06,#06,#06,#04,#04,#03
db #0f,#03,#00,#0c,#00,#00,#00,#03
db #0f,#03,#04,#04,#87,#00,#00,#00
db #0c,#87

;  Music On/OFF Flag
musicOnOff:  db #1 ; labB523
labB524 db #2a
db #b5,#78,#b5,#ee,#b5,#6d,#b9,#6d ;.x...m.m
db #b9,#95,#b6,#9f,#b6,#c5,#b6,#9f
db #b6,#d0,#b6,#db,#b6,#e7,#b6,#f8
db #b6,#e7,#b6,#00,#b7,#e7,#b6,#f8
db #b6,#03,#b7,#14,#b7,#59,#b7,#59 ;.....Y.Y
db #b7,#70,#b7,#70,#b7,#81,#b7,#81 ;.p.p....
db #b7,#92,#b7,#92,#b7,#59,#b7,#59 ;.....Y.Y
db #b7,#70,#b7,#70,#b7,#81,#b7,#81 ;.p.p....
db #b7,#92,#b7,#92,#b7,#a3,#b7,#a3
db #b7,#b3,#b7,#b3,#b7,#dd,#b9,#71 ;.......q
db #b9,#00,#00,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#49,#b9,#49,#b9,#49 ;...I.I.I
db #b9,#49,#b9,#49,#b9,#49,#b9,#49 ;.I.I.I.I
db #b9,#49,#b9,#49,#b9,#49,#b9,#49 ;.I.I.I.I
db #b9,#49,#b9,#0e,#b9,#0e,#b9,#0e ;.I......
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#49 ;.......I
db #b9,#49,#b9,#49,#b9,#49,#b9,#49 ;.I.I.I.I
db #b9,#49,#b9,#49,#b9,#49,#b9,#0e ;.I.I.I..
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#0e
db #b9,#0e,#b9,#0e,#b9,#0e,#b9,#00
db #00,#c2,#b7,#c2,#b7,#c2,#b7,#c2
db #b7,#c2,#b7,#c2,#b7,#c2,#b7,#c2
db #b7,#c2,#b7,#c2,#b7,#e5,#b7,#e5
db #b7,#01,#b8,#1d,#b8,#39,#b8,#55 ;.......U
db #b8,#c2,#b7,#c2,#b7,#e5,#b7,#e5
db #b7,#01,#b8,#1d,#b8,#71,#b8,#91 ;.....q..
db #b8,#ad,#b8,#ad,#b8,#1d,#b8,#1d
db #b8,#39,#b8,#39,#b8,#55,#b8,#55 ;.....U.U
db #b8,#ad,#b8,#c9,#b8,#ad,#b8,#1d
db #b8,#ad,#b8,#c9,#b8,#71,#b8,#39 ;.....q..
db #b8,#e5,#b8,#c2,#b7,#c2,#b7,#e5
db #b7,#e5,#b7,#39,#b8,#39,#b8,#55 ;.......U
db #b8,#55,#b8,#c2,#b7,#c2,#b7,#e5 ;.U......
db #b7,#e5,#b7,#39,#b8,#39,#b8,#55 ;.......U
db #b8,#55,#b8,#01,#b8,#01,#b8,#e5 ;.U......
db #b7,#e5,#b7,#03,#b9,#c2,#b7,#c2
db #b7,#c2,#b7,#c2,#b7,#e5,#b7,#e5
db #b7,#e5,#b7,#e5,#b7,#39,#b8,#39
db #b8,#39,#b8,#39,#b8,#55,#b8,#55 ;.....U.U
db #b8,#55,#b8,#55,#b8,#00,#00,#89 ;.U.U....
db #fc,#87,#89,#00,#87,#89,#02,#87
db #8a,#df,#00,#81,#03,#c1,#ff,#38
db #8f,#87,#c0,#88,#01,#01,#82,#e5
db #28,#e0,#27,#25,#eb,#28,#e3,#25
db #27,#28,#e5,#2a,#e0,#28,#27,#eb
db #2a,#e3,#2a,#2c,#2d,#e5,#2d,#e9
db #28,#e7,#2a,#e3,#2c,#e3,#2d,#87
db #e3,#2f,#2d,#2c,#2a,#e3,#2c,#2a
db #28,#27,#87,#e3,#2f,#2d,#2b,#2a
db #e3,#2b,#2a,#28,#26,#87,#83,#ef
db #24,#29,#ff,#2a,#ef,#2a,#2f,#ff
db #30,#87,#e1,#30,#e0,#2f,#2d,#e5
db #30,#e0,#2d,#2f,#e1,#30,#e0,#2f
db #e0,#2d,#87,#e1,#2f,#e0,#2d,#2c
db #eb,#2f,#87,#ef,#32,#87,#e1,#2f
db #e0,#2d,#2b,#e5,#2f,#e1,#2f,#e0
db #2f,#30,#e1,#32,#ef,#33,#87,#e3
db #28,#e1,#27,#e3,#23,#e1,#26,#25
db #21,#e3,#24,#e1,#23,#1f,#f7,#23
db #e3,#2f,#e1,#2e,#e3,#2a,#e1,#2d
db #2c,#28,#e3,#2b,#e1,#2a,#26,#f7
db #2a,#e3,#34,#e1,#33,#e3,#2f,#e1
db #32,#31,#2d,#e3,#30,#e1,#2f,#2b
db #f7,#2f,#e3,#3b,#e1,#3a,#e3,#36
db #e1,#39,#38,#34,#e3,#37,#e1,#36
db #32,#f7,#36,#87,#df,#00,#22,#03
db #81,#e1,#c4,#38,#34,#31,#e0,#34
db #e2,#38,#e0,#34,#31,#e1,#39,#e0
db #38,#34,#87,#e1,#39,#36,#31,#e0
db #36,#e2,#39,#e0,#36,#31,#e1,#3b
db #e0,#39,#38,#87,#e1,#36,#34,#33
db #e0,#34,#e2,#36,#e0,#34,#33,#e1
db #39,#e0,#38,#34,#87,#e1,#38,#36
db #33,#e0,#36,#e2,#38,#e0,#36,#33
db #e1,#39,#e0,#38,#36,#87,#e1,#39
db #38,#34,#e0,#37,#e2,#36,#e1,#32
db #35,#e0,#34,#e0,#31,#87,#e1,#36
db #35,#31,#e0,#34,#e2,#33,#e1,#2f
db #32,#e0,#31,#2d,#87,#c0,#8a,#df
db #00,#41,#05,#e0,#91,#0d,#19,#e1 ;.A......
db #91,#0d,#81,#e0,#91,#0d,#19,#91
db #25,#e1,#91,#0d,#e0,#19,#e1,#91
db #19,#91,#0d,#91,#e0,#19,#25,#87
db #e0,#91,#12,#1e,#e1,#91,#12,#e0
db #91,#12,#1e,#91,#2a,#e1,#91,#12
db #e0,#1e,#e1,#91,#1e,#91,#12,#91
db #e0,#1e,#2a,#87,#e0,#91,#09,#15
db #e1,#91,#09,#e0,#91,#09,#15,#91
db #21,#e1,#91,#09,#e0,#15,#e1,#91
db #15,#91,#09,#91,#e0,#15,#21,#87
db #e0,#91,#0e,#1a,#e1,#91,#0e,#e0
db #91,#0e,#1a,#91,#26,#e1,#91,#0e
db #e0,#1a,#e1,#91,#1a,#91,#0e,#91
db #e0,#1a,#26,#87,#e0,#91,#0b,#17
db #e1,#91,#0b,#e0,#91,#0b,#17,#91
db #23,#e1,#91,#0b,#e0,#17,#e1,#91
db #17,#91,#0b,#91,#e0,#17,#23,#87
db #e0,#91,#14,#20,#e1,#91,#14,#e0
db #91,#14,#20,#91,#14,#e1,#91,#14
db #e0,#20,#e1,#91,#20,#91,#14,#91
db #e0,#20,#20,#87,#e0,#91,#13,#1f
db #e1,#91,#13,#e0,#91,#13,#1f,#91
db #2b,#e1,#91,#13,#e0,#1f,#e1,#91
db #1f,#91,#13,#91,#e0,#81,#1f,#88
db #01,#01,#2b,#87,#e0,#91,#0c,#18
db #e1,#91,#0c,#e0,#91,#0c,#18,#91
db #24,#e1,#91,#0c,#e0,#18,#e1,#91
db #18,#91,#0c,#91,#e0,#18,#24,#87
db #e0,#91,#11,#1d,#e1,#91,#11,#e0
db #91,#11,#1d,#91,#29,#e1,#91,#11
db #e0,#1d,#e1,#91,#1d,#91,#11,#91
db #e0,#1d,#29,#87,#e0,#91,#10,#1c
db #e1,#91,#10,#e0,#91,#10,#1c,#91
db #28,#e1,#91,#10,#e0,#1c,#e1,#91
db #1c,#91,#10,#91,#e0,#1c,#28,#87
db #df,#00,#91,#02,#82,#ef,#10,#8f
db #8f,#ef,#12,#8f,#8f,#e7,#0b,#0d
db #e7,#0e,#0f,#ef,#10,#e7,#12,#e7
db #14,#15,#16,#17,#18,#87,#df,#00
db #91,#02,#ff,#83,#18,#17,#18,#20
db #87,#8b,#df,#00,#01,#10,#e1,#8d
db #1f,#c0,#8a,#84,#04,#01,#37,#8b
db #e2,#8d,#07,#8d,#1f,#e1,#8d,#1f
db #8d,#07,#8a,#84,#04,#01,#32,#8b
db #8d,#1f,#8a,#84,#04,#01,#32,#e2
db #8b,#8d,#07,#8d,#1f,#e1,#8a,#84
db #04,#01,#37,#8b,#8d,#07,#e0,#8d
db #07,#8d,#07,#87,#8b,#df,#00,#01
db #10,#e1,#8d,#1f,#c0,#8a,#91,#84
db #04,#01,#2b,#8b,#8d,#1f,#8a,#91
db #84,#04,#01,#2b,#91,#84,#04,#01
db #2b,#8b,#8d,#1f,#e3,#8d,#07,#87
db #bc,#ff,#80,#87,#c0,#8a,#df,#00
db #81,#03,#88,#01,#01,#82,#e3,#31
db #e1,#30,#e3,#2c,#e1,#2f,#2e,#2a
db #e3,#2d,#e1,#2c,#28,#f7,#2c,#c1
db #ef,#38,#c0,#e3,#36,#e1,#35,#e3
db #31,#e1,#34,#33,#2f,#e3,#32,#e1
db #31,#2d,#f7,#31,#ef,#c1,#36,#e3
db #c0,#34,#e1,#33,#e3,#2f,#e1,#32
db #e1,#31,#2d,#e3,#30,#e1,#2f,#e1
db #2b,#f7,#2f,#ef,#c1,#34,#c0,#e3
db #38,#e1,#36,#e3,#33,#e1,#39,#38
db #34,#e3,#38,#e1,#36,#e3,#33,#e1
db #34,#33,#31,#e3,#38,#e1,#36,#e3
db #33,#e1,#36,#34,#31,#ef,#33,#87
db #bc,#81,#c2,#8a,#df,#00,#81,#03
db #ff,#3c,#c1,#3b,#c2,#3c,#c3,#3c
db #87,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#cd,#b0,#b9,#fd,#e1
db #f3,#d9,#08,#59,#c1,#78,#06,#df ;...Y.x..
db #ed,#79,#32,#d6,#b8,#06,#7f,#7b ;.y......
db #18,#90,#f3,#e5,#d9,#d1,#18,#08
db #f3,#d9,#e1,#5e,#23,#56,#23,#e5 ;.....V..
db #08,#7a,#cb,#fa,#cb,#f2,#e6,#c0 ;.z......
db #07,#07,#21,#d9,#b8,#86,#18,#a5
db #f3,#d9,#e1,#5e,#23,#56,#cb,#91 ;.....V..
db #ed,#49,#ed,#53,#46,#ba,#d9,#fb ;.I.SF...
db #cd,#d9,#2f,#f3,#d9,#cb,#d1,#ed
db #49,#d9,#fb,#c9,#f3,#d9,#79,#cb ;I.....y.
db #91,#18,#13,#f3,#d9,#79,#cb,#d1 ;.....y..
db #18,#0c,#f3,#d9,#79,#cb,#99,#18 ;....y...
db #05,#f3,#d9,#79,#cb,#d9,#ed,#49 ;...y...I
db #d9,#fb,#c9,#f3,#d9,#a9,#e6,#0c
db #a9,#4f,#18,#f2,#cd,#5f,#ba,#18 ;.O......
db #0f,#cd,#79,#ba,#3a,#00,#c0,#2a ;..y.....
db #01,#c0,#f5,#78,#cd,#70,#ba,#f1 ;...x.p..
db #e5,#f3,#06,#df,#ed,#49,#21,#d6 ;.....I..
db #b8,#46,#71,#48,#47,#fb,#e1,#c9 ;.FqHG...
db #3a,#d6,#b8,#c9,#cd,#ad,#ba,#ed
db #b0,#c9,#cd,#ad,#ba,#ed,#b8,#c9
db #f3,#d9,#e1,#c5,#cb,#d1,#cb,#d9
db #ed,#49,#cd,#c2,#ba,#f3,#d9,#c1 ;.I......
db #ed,#49,#d9,#fb,#c9,#e5,#d9,#fb ;.I......
db #c9,#f3,#d9,#59,#cb,#d3,#cb,#db ;...Y....
db #ed,#59,#d9,#7e,#d9,#ed,#49,#d9 ;.Y....I.
db #fb,#c9,#d9,#79,#f6,#0c,#ed,#79 ;...y...y
db #dd,#7e,#00,#ed,#49,#d9,#c9,#00 ;....I...
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#cf,#5c,#9b,#cf,#98
db #9b,#cf,#bf,#9b,#cf,#c5,#9b,#cf
db #fa,#9b,#cf,#46,#9c,#cf,#b3,#9c ;...F....
db #cf,#04,#9c,#cf,#db,#9c,#cf,#e1
db #9c,#cf,#45,#9e,#cf,#38,#9d,#cf ;..E.....
db #e5,#9d,#cf,#d8,#9e,#cf,#c4,#9e
db #cf,#dd,#9e,#cf,#c9,#9e,#cf,#e2
db #9e,#cf,#ce,#9e,#cf,#34,#9e,#cf
db #2f,#9e,#cf,#f6,#9d,#cf,#f2,#9d
db #cf,#fa,#9d,#cf,#0b,#9e,#cf,#19
db #9e,#cf,#74,#90,#cf,#84,#90,#cf ;..t.....
db #59,#94,#cf,#52,#94,#cf,#fe,#93 ;Y..R....
db #cf,#35,#93,#cf,#ac,#93,#cf,#a8
db #93,#cf,#08,#92,#cf,#52,#92,#cf ;.....R..
db #4f,#95,#cf,#5a,#91,#cf,#65,#91 ;O..Z..e.
db #cf,#70,#91,#cf,#7c,#91,#cf,#86 ;.p......
db #92,#cf,#97,#92,#cf,#76,#92,#cf ;.....v..
db #7e,#92,#cf,#ca,#91,#cf,#65,#92 ;......e.
db #cf,#65,#92,#cf,#a6,#92,#cf,#ba ;.e......
db #92,#cf,#ab,#92,#cf,#c0,#92,#cf
db #c6,#92,#cf,#7b,#93,#cf,#88,#93
db #cf,#d4,#92,#cf,#f2,#92,#cf,#fe
db #92,#cf,#2b,#93,#cf,#d4,#94,#cf
db #e4,#90,#cf,#03,#91,#cf,#a8,#95
db #cf,#d7,#95,#cf,#fe,#95,#cf,#fb
db #95,#cf,#06,#96,#cf,#0e,#96,#cf
db #1c,#96,#cf,#a5,#96,#cf,#ea,#96
db #cf,#17,#97,#cf,#2d,#97,#cf,#36
db #97,#cf,#67,#97,#cf,#75,#97,#cf ;..g..u..
db #6e,#97,#cf,#7a,#97,#cf,#83,#97 ;n..z....
db #cf,#80,#97,#cf,#97,#97,#cf,#94
db #97,#cf,#a9,#97,#cf,#a6,#97,#cf
db #40,#99,#cf,#bf,#8a,#cf,#d0,#8a
db #cf,#37,#8b,#cf,#3c,#8b,#cf,#56 ;.......V
db #8b,#cf,#e9,#8a,#cf,#0c,#8b,#cf
db #17,#8b,#cf,#5d,#8b,#cf,#6a,#8b ;......j.
db #cf,#af,#8b,#cf,#05,#8c,#cf,#11
db #8c,#cf,#1f,#8c,#cf,#39,#8c,#cf
db #8e,#8c,#cf,#a7,#8c,#cf,#f2,#8c
db #cf,#1a,#8d,#cf,#f7,#8c,#cf,#1f
db #8d,#cf,#ea,#8c,#cf,#ee,#8c,#cf
db #b9,#8d,#cf,#bd,#8d,#cf,#e5,#8d
db #cf,#00,#8e,#cf,#44,#8e,#cf,#f9 ;....D...
db #8e,#cf,#2a,#8f,#cf,#55,#8c,#cf ;.....U..
db #74,#8c,#cf,#93,#8f,#cf,#9b,#8f ;t.......
db #cf,#bc,#a4,#cf,#ce,#a4,#cf,#e1
db #a4,#cf,#bb,#ab,#cf,#bf,#ab,#cf
db #c1,#ab,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#df,#8b,#a8,#df,#8b,#a8,#df
db #8b,#a8,#df,#8b,#a8,#df,#8b,#a8
db #df,#8b,#a8,#df,#8b,#a8,#df,#8b
db #a8,#cf,#af,#a9,#cf,#a6,#a9,#cf
db #c1,#a9,#cf,#e9,#9f,#cf,#14,#a1
db #cf,#ce,#a1,#cf,#eb,#a1,#cf,#ac
db #a1,#cf,#50,#a0,#cf,#6b,#a0,#cf ;..P..k..
db #95,#a4,#cf,#9a,#a4,#cf,#a6,#a4
db #cf,#ab,#a4,#cf,#5c,#80,#cf,#26
db #83,#cf,#30,#83,#cf,#a0,#82,#cf
db #b1,#82,#cf,#63,#81,#cf,#6a,#81 ;...c..j.
db #cf,#70,#81,#cf,#76,#81,#cf,#7d ;.p..v...
db #81,#cf,#83,#81,#cf,#b3,#81,#cf
db #c5,#81,#cf,#d2,#81,#cf,#e2,#81
db #cf,#27,#82,#cf,#84,#82,#cf,#55 ;.......U
db #82,#cf,#19,#82,#cf,#76,#82,#cf ;.....v..
db #94,#82,#cf,#9a,#82,#cf,#8d,#82
db #cf,#99,#80,#cf,#a3,#80,#cf,#ed
db #85,#cf,#1c,#86,#cf,#b4,#87,#cf
db #76,#87,#cf,#c0,#87,#cf,#86,#87 ;v.......
db #cf,#8c,#87,#cf,#e0,#87,#cf,#1b
db #88,#cf,#58,#88,#cf,#44,#88,#cf ;..X..D..
db #63,#88,#cf,#bd,#88,#cf,#3c,#9d ;c.......
db #cf,#fe,#9b,#cf,#60,#94,#cf,#ec
db #95,#cf,#d5,#99,#cf,#b0,#97,#cf
db #ac,#97,#cf,#2a,#96,#cf,#d9,#99
db #cf,#45,#8b,#cf,#0c,#88,#cf,#97 ;.E......
db #83,#cf,#02,#ac,#ef,#91,#2f,#ef
db #9f,#2f,#ef,#c8,#2f,#ef,#d9,#2f
db #ef,#01,#30,#ef,#14,#30,#ef,#55 ;.......U
db #30,#ef,#5f,#30,#ef,#c6,#30,#ef
db #a2,#34,#ef,#59,#31,#ef,#9e,#34 ;...Y....
db #ef,#77,#35,#ef,#04,#36,#ef,#88 ;.w......
db #31,#ef,#df,#36,#ef,#31,#37,#ef
db #27,#37,#ef,#45,#33,#ef,#73,#2f ;...E..s.
db #ef,#ac,#32,#ef,#af,#32,#ef,#b6
db #31,#ef,#b1,#31,#ef,#2f,#32,#ef
db #53,#33,#ef,#49,#33,#ef,#c8,#33 ;S..I....
db #ef,#d8,#33,#ef,#d1,#2f,#ef,#36
db #31,#ef,#43,#31,#00,#00,#00,#00 ;..C.....
db #00,#00,#00,#00,#00,#00,#00,#00
db #c3,#5f,#12,#c3,#5f,#12,#c3,#4b ;.......K
db #13,#c3,#be,#13,#c3,#0a,#14,#c3
db #86,#17,#c3,#9a,#17,#c3,#b4,#17
db #c3,#8a,#0c,#c3,#71,#0c,#c3,#17 ;....q...
db #0b,#c3,#b8,#1d,#c3,#35,#08,#c3
db #40,#1d,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#10,#a9,#90,#a8,#32
db #00,#fa,#00,#af,#0f,#0c,#07,#40
db #80,#00,#21,#00,#48,#02,#00,#21 ;....H...
db #1d,#00,#21,#07,#00,#00,#00,#00
db #00,#ff,#00,#e4,#a7,#b0,#a9,#d2
db #bf,#10,#00,#00,#fa,#00,#00,#00
db #00,#00,#00,#80,#d6,#c9,#07,#48 ;.......H
db #66,#b0,#a9,#00,#00,#00,#00,#00 ;f.......
db #00,#a7,#c9,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#f7,#00
db #f7,#49,#1d,#d2,#00,#53,#b9,#05 ;.I...S..
db #50,#26,#c9,#4c,#be,#00,#02,#b0 ;P..L....
db #ab,#00,#f7,#49,#1d,#d2,#00,#53 ;...I...S
db #b9,#05,#50,#26,#c9,#4c,#be,#00 ;..P..L..
db #21,#b0,#ab,#fc,#c8,#0a,#c9,#00
db #00,#60,#ca,#80,#00,#f2,#c8,#ce
db #c8,#45,#00,#55,#be,#00,#00,#58 ;.E.U...X
db #be,#56,#c5,#f1,#d9,#e4,#a7,#eb ;.V......
db #02,#37,#d7,#00,#f7,#49,#0f,#b1 ;.....I..
db #0f,#b1,#41,#3f,#8c,#8d,#00,#f7 ;..A.....
db #e1,#3e,#00,#f5,#09,#0f,#4d,#3f ;......M.
db #f1,#c6,#de,#00,#71,#0f,#20,#0e ;....q...
db #a0,#04,#de

; data music?
org #c600

dataC600
db #01,#81,#41 ;.......A
db #c1,#21,#a1,#61,#e1,#11,#91,#51 ;...a...Q
db #d1,#31,#b1,#71,#f1,#09,#89,#49 ;...q...I
db #c9,#29,#a9,#69,#e9,#19,#99,#59 ;...i...Y
db #d9,#39,#b9,#79,#f9,#05,#85,#45 ;...y...E
db #c5,#25,#a5,#65,#e5,#15,#95,#55 ;...e...U
db #d5,#35,#b5,#75,#f5,#0d,#8d,#4d ;...u...M
db #cd,#2d,#ad,#6d,#ed,#1d,#9d,#5d ;...m....
db #dd,#3d,#bd,#7d,#fd,#03,#83,#43 ;.......C
db #c3,#23,#a3,#63,#e3,#13,#93,#53 ;...c...S
db #d3,#33,#b3,#73,#f3,#0b,#8b,#4b ;...s...K
db #cb,#2b,#ab,#6b,#eb,#1b,#9b,#5b ;...k....
db #db,#3b,#bb,#7b,#fb,#07,#87,#47 ;.......G
db #c7,#27,#a7,#67,#e7,#17,#97,#57 ;...g...W
db #d7,#37,#b7,#77,#f7,#0f,#8f,#4f ;...w...O
db #cf,#2f,#af,#6f,#ef,#1f,#9f,#5f ;...o....
db #df,#3f,#bf,#7f,#ff

labC680
 db 0,#80,#40,#c0,#20,#a0,#60,#e0,#10
 db #90,#50,#d0,#30,#b0,#70,#f0,#08 ;.P...p..
 db #88,#48,#c8,#28,#a8,#68,#e8,#18 ;.H...h..
 db #98,#58,#d8,#38,#b8,#78,#f8,#04 ;.X...x..
 db #84,#44,#c4,#24,#a4,#64,#e4,#14 ;.D...d..
 db #94,#54,#d4,#34,#b4,#74,#f4,#0c ;.T...t..
 db #8c,#4c,#cc,#2c,#ac,#6c,#ec,#1c ;.L...l..
 db #9c,#5c,#dc,#3c,#bc,#7c,#fc,#02
 db #82,#42,#c2,#22,#a2,#62,#e2,#12 ;.B...b..
 db #92,#52,#d2,#32,#b2,#72,#f2,#0a ;.R...r..
 db #8a,#4a,#ca,#2a,#aa,#6a,#ea,#1a ;.J...j..
 db #9a,#5a,#da,#3a,#ba,#7a,#fa,#06 ;.Z...z..
 db #86,#46,#c6,#26,#a6,#66,#e6,#16 ;.F...f..
 db #96,#56,#d6,#36,#b6,#76,#f6,#0e ;.V...v..
 db #8e,#4e,#ce,#2e,#ae,#6e,#ee,#1e ;.N...n..
 db #9e,#5e,#de,#3e,#be,#7e,#fe,#00
 db #00,#00,#24,#7e,#db,#81,#00,#00
 db #24,#66,#e7,#3c,#18,#00


; Menu: Ninja tiles
org #ce00
 ds 16
 db #11,#11,#11,#11,#11,#11,#11
 db #11,#11,#11,#11,#11,#11,#11,#11
 db #11,#22,#22,#22,#22,#22,#22,#22
 db #22,#22,#22,#22,#22,#22,#22,#22
 db #22,#33,#33,#33,#33,#33,#33,#33
 db #33,#33,#33,#33,#33,#33,#33,#33
 db #33,#44,#44,#44,#44,#44,#44,#44 ;.DDDDDDD
 db #44,#44,#44,#44,#44,#44,#44,#44 ;DDDDDDDD
 db #44,#55,#55,#55,#55,#55,#55,#55 ;DUUUUUUU
 db #55,#55,#55,#55,#55,#55,#55,#55 ;UUUUUUUU
 db #55,#66,#66,#66,#66,#66,#66,#66 ;Ufffffff
 db #66,#66,#66,#66,#66,#66,#66,#66 ;ffffffff
 db #66,#77,#77,#77,#77,#77,#77,#77 ;fwwwwwww
 db #77,#77,#77,#77,#77,#77,#77,#77 ;wwwwwwww
 db #77,#88,#88,#88,#88,#88,#88,#88 ;w.......
 db #88,#88,#88,#88,#88,#88,#88,#88
 db #88,#99,#99,#99,#99,#99,#99,#99
 db #99,#99,#99,#99,#99,#99,#99,#99
 db #99,#aa,#aa,#aa,#aa,#aa,#aa,#aa
 db #aa,#aa,#aa,#aa,#aa,#aa,#aa,#aa
 db #aa,#bb,#bb,#bb,#bb,#bb,#bb,#bb
 db #bb,#bb,#bb,#bb,#bb,#bb,#bb,#bb
 db #bb,#cc,#cc,#cc,#cc,#cc,#cc,#cc
 db #cc,#cc,#cc,#cc,#cc,#cc,#cc,#cc
 db #cc,#dd,#dd,#dd,#dd,#dd,#dd,#dd
 db #dd,#dd,#dd,#dd,#dd,#dd,#dd,#dd
 db #dd,#ee,#ee,#ee,#ee,#ee,#ee,#ee
 db #ee,#ee,#ee,#ee,#ee,#ee,#ee,#ee
 db #ee,#ff,#ff,#ff,#ff,#ff,#ff,#ff
 db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff,#00,#11,#22,#33,#44,#55,#66 ;.....DUf
 db #77,#88,#99,#aa,#bb,#cc,#dd,#ee ;w.......
 db #ff


',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: disassembled-game
  SELECT id INTO tag_uuid FROM tags WHERE name = 'disassembled-game';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 96: rom-os6128 by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'rom-os6128',
    'Imported from z80Code. Author: siko. Fixed version of commented ROM',
    'public',
    false,
    false,
    '2021-07-09T01:39:31.459000'::timestamptz,
    '2021-09-22T12:37:02.964000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org 0
; Fixed Version of 6128 OS commented assembly code  found here:
; https://cpctech.cpc-live.com/docs/os.asm
; 


; Disassembly of the CPC6128 operating system ROM
START_OF_LOW_KERNEL_JUMPBLOCK_AND_ROM_START:
;;
;; firmware register assignments:
;; B'' = 0x07f - Gate Array I/O port address (upper 8 bits)
;; C'': upper/lower rom enabled state and current mode. Bit 7 = 1, Bit 6 = 0.
;----------------------------------------------------------------
RST_0__LOW_RESET_ENTRY:
lab0000: ld bc,#7f89		; select mode 1, disable upper rom, enable lower rom 
lab0003: out (c),c 		    ; select mode and rom configuration 
lab0005: jp #0591 
;----------------------------------------------------------------
lab0008: jp #b98a			; RST 1 - LOW: LOW JUMP 
;----------------------------------------------------------------
lab000b: jp #b984			; LOW: KL LOW PCHL 
;----------------------------------------------------------------
lab000e: push bc			; LOW: PCBC INSTRUCTION 
lab000f: ret 
;----------------------------------------------------------------
lab0010: jp #ba1d			; RST 2 - LOW: SIDE CALL 
;----------------------------------------------------------------
lab0013: jp #ba17			; LOW: KL SIDE PCHL 
;----------------------------------------------------------------
lab0016: push de			; LOW: PCDE INSTRUCTION 
lab0017: ret 
;----------------------------------------------------------------
lab0018: jp #b9c7			; RST 3 - LOW: FAR CALL 
;----------------------------------------------------------------
lab001b: jp #b9b9			; LOW: KL FAR PCHL 
;----------------------------------------------------------------
lab001e: jp (hl)			; LOW: PCHL INSTRUCTION 
;----------------------------------------------------------------
lab001f: nop 
;----------------------------------------------------------------
lab0020: jp #bac6			; RST 4 - LOW: RAM LAM 
;----------------------------------------------------------------
lab0023: jp #b9c1			; LOW: KL FAR ICALL 
;----------------------------------------------------------------
lab0026: nop 
lab0027: nop 
;----------------------------------------------------------------
lab0028: jp #ba35			; RST 5 - LOW: FIRM JUMP 
lab002b: nop 
lab002c: out (c),c 
lab002e: exx 
lab002f: ei 
;----------------------------------------------------------------
lab0030: di					; RST 6 - LOW: USER RESTART 
lab0031: exx 
lab0032: ld hl,#002b 
lab0035: ld (hl),c 
lab0036: jr #0040 
;----------------------------------------------------------------
lab0038: jp #b941			; RST 7 - LOW: INTERRUPT ENTRY 
;----------------------------------------------------------------
;; This is the default handler in the ROM. The user can patch the RAM version of this
;; handler.
lab003b: ret				; LOW: EXT INTERRUPT 
;----------------------------------------------------------------
lab003c: nop 
lab003d: nop 
lab003e: nop 
lab003f: nop 
END_OF_LOW_KERNEL_JUMPBLOCK:
;;----------------------------------------------------------------------------------------
lab0040: set 2,c 
lab0042: jr #002c ; (-#18) 
;;----------------------------------------------------------------------------------------
;; Setup LOW KERNEL jumpblock
;; Copy RSTs to RAM
lab0044: ld hl,#0040			; copy first #40 bytes of this rom to #0000 
                                ; in RAM, and therefore initialise low kernel jumpblock
lab0047: dec l 
lab0048: ld a,(hl)			; get byte from rom 
lab0049: ld (hl),a			; write byte to ram 
lab004a: jr nz,#0047 ; 
;; initialise USER RESTART in LOW KERNEL jumpblcok
lab004c: ld a,#c7 
lab004e: ld (#0030),a 
;; Setup HIGH KERNEL jumpblock
lab0051: ld hl,#03a6			; copy high kernel jumpblock 
lab0054: ld de,#b900 
lab0057: ld bc,#01e4 
lab005a: ldir 
;;==========================================================================
KL_CHOKE_OFF:
lab005c: di 
lab005d: ld a,(#b8d9) 
lab0060: ld de,(#b8d7) 
lab0064: ld b,#cd 
lab0066: ld hl,#b82d 
lab0069: ld (hl),#00 
lab006b: inc hl 
lab006c: djnz #0069 ; (-#05) 
lab006e: ld b,a 
lab006f: ld c,#ff 
lab0071: xor c 
lab0072: ret nz 
lab0073: ld b,a 
lab0074: ld e,a 
lab0075: ld d,a 
lab0076: ret 
;;==========================================================================
;; this is called at the very end just before BASIC is started 
;;
;; HL = address to start
;; C = rom select 
;;
;; if HL=0, then BASIC is started.
lab0077: ld a,h 
lab0078: or l 
lab0079: ld a,c 
lab007a: jr nz,#0080 ; HL=0? 
;; yes, HL = 0
lab007c: ld a,l				; A = 0 (BASIC) 
lab007d: ld hl,#c006		; execution address for BASIC 
;; A = rom select 
;; HL = address to start
lab0080: ld (#b8d6),a 
;; initialise three byte far address
lab0083: ld (#b8d9),a		; rom select byte 
lab0086: ld (#b8d7),hl		; address 
lab0089: ld hl,#abff 
lab008c: ld de,#0040 
lab008f: ld bc,#b0ff 
lab0092: ld sp,#c000 
lab0095: rst #18				; RST 3 - LOW: FAR CALL 
defw #b8d7
lab0098: rst #00				; RST 0 - LOW: RESET ENTRY 
;;==========================================================================
KL_TIME_PLEASE:
lab0099: di 
lab009a: ld de,(#b8b6) 
lab009e: ld hl,(#b8b4) 
lab00a1: ei 
lab00a2: ret 
;;==========================================================================
KL_TIME_SET:
lab00a3: di 
lab00a4: xor a 
lab00a5: ld (#b8b8),a 
lab00a8: ld (#b8b6),de 
lab00ac: ld (#b8b4),hl 
lab00af: ei 
lab00b0: ret 
;;==========================================================================
;; update TIME
lab00b1: ld hl,#b8b4 
lab00b4: inc (hl) 
lab00b5: inc hl 
lab00b6: jr z,#00b4 ; (-#04) 
;; test VSYNC state
lab00b8: ld b,#f5 
lab00ba: in a,(c) 
lab00bc: rra 
lab00bd: jr nc,#00c7 
;; VSYNC is set
lab00bf: ld hl,(#b8b9)		;; FRAME FLY events 
lab00c2: ld a,h 
lab00c3: or a 
lab00c4: call nz,#0153 
lab00c7: ld hl,(#b8bb)		;; FAST TICKER events 
lab00ca: ld a,h 
lab00cb: or a 
lab00cc: call nz,#0153 
lab00cf: call #20d7			;; process sound 
lab00d2: ld hl,#b8bf		;; keyboard scan interrupt counter 
lab00d5: dec (hl) 
lab00d6: ret nz 
lab00d7: ld (hl),#06		;; reset keyboard scan interrupt counter 
lab00d9: call #bdf4			; IND: KM SCAN KEYS 
lab00dc: ld hl,(#b8bd)		; ticker list 
lab00df: ld a,h 
lab00e0: or a 
lab00e1: ret z 
lab00e2: ld hl,#b831		; indicate there are some ticker events to process? 
lab00e5: set 0,(hl) 
lab00e7: ret 
;;------------------------------------------------------------------------------
;; these two are for queuing up normal Asynchronous events to be processed after all others
;; normal event 
lab00e8: dec hl 
lab00e9: ld (hl),#00 
lab00eb: dec hl 
;; has list been setup?
lab00ec: ld a,(#b82e) 
lab00ef: or a 
lab00f0: jr nz,#00fe ; (+#0c) 
;; add to start of list
lab00f2: ld (#b82d),hl 
lab00f5: ld (#b82f),hl 
;; signal normal event list setup
lab00f8: ld hl,#b831 
lab00fb: set 6,(hl) 
lab00fd: ret 
;; add another event to 
lab00fe: ld de,(#b82f) 
lab0102: ld (#b82f),hl 
lab0105: ex de,hl 
lab0106: ld (hl),e 
lab0107: inc hl 
lab0108: ld (hl),d 
lab0109: ret 
;;---------------------------------------------------
;; synchronous??
lab010a: ld (#b832),sp 
lab010e: ld sp,#b8b4 
lab0111: push hl 
lab0112: push de 
lab0113: push bc 
;; normal event has been setup?
lab0114: ld hl,#b831 
lab0117: bit 6,(hl) 
lab0119: jr z,#0139 ; (+#1e) 
lab011b: set 7,(hl) 
lab011d: ld hl,(#b82d) 
lab0120: ld a,h 
lab0121: or a 
lab0122: jr z,#0132 ; (+#0e) 
lab0124: ld e,(hl) 
lab0125: inc hl 
lab0126: ld d,(hl) 
lab0127: ld (#b82d),de 
lab012b: inc hl 
lab012c: call #0209			; execute event function 
lab012f: di 
lab0130: jr #011d ; (-#15) 
;;---------------------------------------------------
lab0132: ld hl,#b831 
lab0135: bit 0,(hl) 
lab0137: jr z,#0149 ; (+#10) 
lab0139: ld (hl),#00 
lab013b: scf 
lab013c: ex af,af'' 
lab013d: call #0189			;; execute ticker 
lab0140: or a 
lab0141: ex af,af'' 
lab0142: ld hl,#b831 
lab0145: ld a,(hl) 
lab0146: or a 
lab0147: jr nz,#011b ; (-#2e) 
lab0149: ld (hl),#00 
lab014b: pop bc 
lab014c: pop de 
lab014d: pop hl 
lab014e: ld sp,(#b832) 
lab0152: ret 
;;---------------------------------------------------------------------
;; loop over events
;;
;; HL = address of event list
lab0153: ld e,(hl) 
lab0154: inc hl 
lab0155: ld a,(hl) 
lab0156: inc hl 
lab0157: or a 
lab0158: jp z,#01e2			; KL EVENT 
lab015b: ld d,a 
lab015c: push de 
lab015d: call #01e2			; KL EVENT 
lab0160: pop hl 
lab0161: jr #0153 ; (-#10) 
;;==========================================================================
KL_NEW_FRAME_FLY:
lab0163: push hl 
lab0164: inc hl 
lab0165: inc hl 
lab0166: call #01d2			; KL INIT EVENT 
lab0169: pop hl 
;;==========================================================================
KL_ADD_FRAME_FLY:
lab016a: ld de,#b8b9 
lab016d: jp #0379 ;; add event to list 
;;==========================================================================
KL_DEL_FRAME_FLY:
lab0170: ld de,#b8b9 
lab0173: jp #0388 ; remove event from list 
;;==========================================================================
KL_NEW_FAST_TICKER:
lab0176: push hl 
lab0177: inc hl 
lab0178: inc hl 
lab0179: call #01d2			; KL INIT EVENT 
lab017c: pop hl 
;;==========================================================================
KL_ADD_FAST_TICKER:
;; HL = address of event block
lab017d: ld de,#b8bb 
lab0180: jp #0379 ;; add event to list 
;;==========================================================================
KL_DEL_FAST_TICKER:
;; HL = address of event block
lab0183: ld de,#b8bb 
lab0186: jp #0388 ; remove event from list 
;;==========================================================================
lab0189: ld hl,(#b8bd)			; ticker list 
lab018c: ld a,h 
lab018d: or a 
lab018e: ret z 
lab018f: ld e,(hl) 
lab0190: inc hl 
lab0191: ld d,(hl) 
lab0192: inc hl 
lab0193: ld c,(hl) 
lab0194: inc hl 
lab0195: ld b,(hl) 
lab0196: ld a,b 
lab0197: or c 
lab0198: jr z,#01b0 ; (+#16) 
lab019a: dec bc 
lab019b: ld a,b 
lab019c: or c 
lab019d: jr nz,#01ad ; (+#0e) 
lab019f: push de 
lab01a0: inc hl 
lab01a1: inc hl 
lab01a2: push hl 
lab01a3: inc hl 
lab01a4: call #01e2			; KL EVENT 
lab01a7: pop hl 
lab01a8: ld b,(hl) 
lab01a9: dec hl 
lab01aa: ld c,(hl) 
lab01ab: dec hl 
lab01ac: pop de 
lab01ad: ld (hl),b 
lab01ae: dec hl 
lab01af: ld (hl),c 
lab01b0: ex de,hl 
lab01b1: jr #018c ; (-#27) 
;;==========================================================================
KL_ADD_TICKER:
;; HL = event b lock
;; DE = initial value for counter
;; BC = reset count
lab01b3: push hl 
lab01b4: inc hl 
lab01b5: inc hl 
lab01b6: di 
lab01b7: ld (hl),e			;; initial counter 
lab01b8: inc hl 
lab01b9: ld (hl),d 
lab01ba: inc hl 
lab01bb: ld (hl),c			;; reset count 
lab01bc: inc hl 
lab01bd: ld (hl),b 
lab01be: pop hl 
lab01bf: ld de,#b8bd			;; ticker list 
lab01c2: jp #0379 ;; add event to list 
;;==========================================================================
KL_DEL_TICKER:
lab01c5: ld de,#b8bd 
lab01c8: call #0388 ; remove event from list 
lab01cb: ret nc 
lab01cc: ex de,hl 
lab01cd: inc hl 
lab01ce: ld e,(hl) 
lab01cf: inc hl 
lab01d0: ld d,(hl) 
lab01d1: ret 
;;==========================================================================
KL_INIT_EVENT:
lab01d2: di 
lab01d3: inc hl 
lab01d4: inc hl 
lab01d5: ld (hl),#00		;; tick count 
lab01d7: inc hl 
lab01d8: ld (hl),b		;; class 
lab01d9: inc hl 
lab01da: ld (hl),e		;; routine 
lab01db: inc hl 
lab01dc: ld (hl),d 
lab01dd: inc hl 
lab01de: ld (hl),c		;; rom 
lab01df: inc hl 
lab01e0: ei 
lab01e1: ret 
;;==========================================================================
KL_EVENT:
;;
;; perform event
;; DE = address of next in chain
;; HL = address of current event
lab01e2: inc hl 
lab01e3: inc hl 
lab01e4: di 
lab01e5: ld a,(hl)			;; count 
lab01e6: inc (hl) 
lab01e7: jp m,#0201			;; update count 
lab01ea: or a 
lab01eb: jr nz,#0202 ; (+#15) 
lab01ed: inc hl 
lab01ee: ld a,(hl)			; class 
lab01ef: dec hl 
lab01f0: or a 
lab01f1: jp p,#022e			; -ve (bit = 1) = Asynchronous, +ve (bit = 0) = synchronous 
;; Asynchronous
lab01f4: ex af,af'' 
lab01f5: jr nc,#0208 
lab01f7: ex af,af'' 
lab01f8: add a,a				; express = -ve (bit = 1), normal = +ve (bit = 0) 
lab01f9: jp p,#00e8			; add to normal list 
;; Asynchronous Express
lab01fc: dec (hl)				; indicate it needs processing 
lab01fd: inc hl 
lab01fe: inc hl 
; HL = routine address
lab01ff: jr #0222 ; execute event 
;; update count 
lab0201: dec (hl) 
;; done processing
lab0202: ex af,af'' 
lab0203: jr c,#0206 ; (+#01) 
lab0205: ei 
lab0206: ex af,af'' 
lab0207: ret 
lab0208: ex af,af'' 
;;--------------------------
;; execute event func
lab0209: ei 					; enable ints 
lab020a: ld a,(hl) 
lab020b: dec a 
lab020c: ret m 
lab020d: push hl 
lab020e: call #021b				; part of KL DO SYNC 
lab0211: pop hl 
lab0212: dec (hl) 
lab0213: ret z 
lab0214: jp p,#020d 
lab0217: inc (hl) 
lab0218: ret 
;;==========================================================================
KL_DO_SYNC:
;; HL = event block
;; DE = address of event
lab0219: inc hl 
lab021a: inc hl 
lab021b: inc hl 
;; near or far address?
lab021c: ld a,(hl) 
lab021d: inc hl 
lab021e: rra 
lab021f: jp nc,#b9c1			;	 LOW: KL FAR ICALL 
;; event uses near address
;; execute it.
;; note that lower rom is enabled at this point so the function can''t sit under the lower rom
lab0222: ld e,(hl) 
lab0223: inc hl 
lab0224: ld d,(hl) 
lab0225: ex de,hl 
lab0226: jp (hl) 
;;==========================================================================
KL_SYNC_RESET:
lab0227: ld hl,#0000 
lab022a: ld (#b8c1),hl 
lab022d: ret 
;;---------------------------------------------------------------------------
;; Synchronous Event
lab022e: push hl 
lab022f: ld b,a 
lab0230: ld de,#b8c3 
lab0233: ex de,hl 
lab0234: dec hl 
lab0235: dec hl 
lab0236: ld d,(hl) 
lab0237: dec hl 
lab0238: ld e,(hl) 
lab0239: ld a,d 
lab023a: or a 
lab023b: jr z,#0244 ; (+#07) 
lab023d: inc de				; count 
lab023e: inc de				; class 
lab023f: inc de 
lab0240: ld a,(de) 
lab0241: cp b 
lab0242: jr nc,#0233 ; (-#11) 
lab0244: pop de 
lab0245: dec de 
lab0246: inc hl 
lab0247: ld a,(hl) 
lab0248: ld (de),a 
lab0249: dec de 
lab024a: ld (hl),d 
lab024b: dec hl 
lab024c: ld a,(hl) 
lab024d: ld (de),a 
lab024e: ld (hl),e 
lab024f: ex af,af'' 
lab0250: jr c,#0253 ; (+#01) 
lab0252: ei 
lab0253: ex af,af'' 
lab0254: ret 
;;==========================================================================
KL_NEXT_SYNC:
lab0255: di 
lab0256: ld hl,(#b8c0)			; synchronous event list 
lab0259: ld a,h 
lab025a: or a 
lab025b: jr z,#0274 ; (+#17) 
lab025d: push hl 
lab025e: ld e,(hl) 
lab025f: inc hl 
lab0260: ld d,(hl) 
lab0261: inc hl 
lab0262: inc hl 
lab0263: ld a,(#b8c2) 
lab0266: cp (hl) 
lab0267: jr nc,#0273 ; (+#0a) 
lab0269: push af 
lab026a: ld a,(hl) 
lab026b: ld (#b8c2),a 
lab026e: ld (#b8c0),de			; synchronous event list 
lab0272: pop af 
lab0273: pop hl 
lab0274: ei 
lab0275: ret 
;;==========================================================================
KL_DONE_SYNC:
lab0276: ld (#b8c2),a 
lab0279: inc hl 
lab027a: inc hl 
lab027b: dec (hl) 
lab027c: ret z 
lab027d: di 
lab027e: jp p,#022e				;; Synchronous event 
lab0281: inc (hl) 
lab0282: ei 
lab0283: ret 
;;==========================================================================
KL_DEL_SYNCHRONOUS:
lab0284: call #028d			; KL DISARM EVENT 
lab0287: ld de,#b8c0			; synchronouse event list 
lab028a: jp #0388 ; remove event from list 
;;==========================================================================
KL_DISARM_EVENT:
lab028d: inc hl 
lab028e: inc hl 
lab028f: ld (hl),#c0 
lab0291: dec hl 
lab0292: dec hl 
lab0293: ret 
;;==========================================================================
KL_EVENT_DISABLE:
lab0294: ld hl,#b8c2 
lab0297: set 5,(hl) 
lab0299: ret 
;;==========================================================================
KL_EVENT_ENABLE:
lab029a: ld hl,#b8c2 
lab029d: res 5,(hl) 
lab029f: ret 
;;==========================================================================
KL_LOG_EXT:
;;
;; BC contains the address of the RSX''s command table
;; HL contains the address of four bytes exclusively for use by the firmware 
;; 
;; NOTES: Most recent command is added to the start of the list. The next oldest
;; is next and so on until we get to the command that was registered first and the 
;; end of the list.
;; 
;; HL can''t be in the range &0000-&3fff because the OS rom will be active in this range. 
;; Sensible range is &4000-&c000. (&c000-&ffff is normally where upper ROM is located, so it
;; is unwise to locate it here if you want to access the command from BASIC because BASIC
;; will be active in this range)
lab02a0: push hl 
lab02a1: ld de,(#b8d3) ;; get head of the list 
lab02a5: ld (#b8d3),hl ;; set new head of the list 
lab02a8: ld (hl),e ;; previous | command registered with KL LOG EXT or 0 if end of list 
lab02a9: inc hl 
lab02aa: ld (hl),d 
lab02ab: inc hl 
lab02ac: ld (hl),c ;; address of RSX''s command table 
lab02ad: inc hl 
lab02ae: ld (hl),b 
lab02af: pop hl 
lab02b0: ret 
;;==========================================================================
KL_FIND_COMMAND:
;; HL = address of command name to be found.
;; NOTEs: 
;; - last char must have bit 7 set to indicate the end of the string.
;; - up to 16 characters is compared. Name can be any length but first 16 characters must be unique.
lab02b1: ld de,#b8c3 ;; destination 
lab02b4: ld bc,#0010 ;; length 
lab02b7: call #baa1			;; HI: KL LDIR (disable upper and lower roms and perform LDIR) 
;; ensure last character has bit 7 set (indicates end of string, where length of name is longer
;; than 16 characters). If name is less than 16 characters the last char will have bit 7 set anyway.
lab02ba: ex de,hl 
lab02bb: dec hl 
lab02bc: set 7,(hl) 
lab02be: ld hl,(#b8d3) ; points to commands registered with KL LOG EXT 
lab02c1: ld a,l ; preload lower byte of address into A for comparison 
lab02c2: jr #02d4 
;; search for more | commands registered with KL LOG EXT
lab02c4: push hl 
lab02c5: inc hl ; skip pointer to next registered RSX 
lab02c6: inc hl 
lab02c7: ld c,(hl) ; fetch address of RSX table 
lab02c8: inc hl 
lab02c9: ld b,(hl) 
lab02ca: call #02f1 ; search for command 
lab02cd: pop de 
lab02ce: ret c 
lab02cf: ex de,hl 
lab02d0: ld a,(hl) ; get address of next registered RSX 
lab02d1: inc hl 
lab02d2: ld h,(hl) 
lab02d3: ld l,a 
lab02d4: or h ; if HL is zero, then this is the end of the list. 
lab02d5: jr nz,#02c4 ; loop if we didn''t get to the end of the list 
lab02d7: ld c,#ff 
lab02d9: inc c 
;; C = ROM select address of ROM to probe
lab02da: call #ba7e			;; HI: KL PROBE ROM 
;; A = ROM''s class.
;; 0 = Foreground
;; 1 = Background
;; 2 = Extension foreground ROM
lab02dd: push af 
lab02de: and #03 
lab02e0: ld b,a 
lab02e1: call z,#02f1 ; search for command 
lab02e4: call c,#061c			; MC START PROGRAM 
lab02e7: pop af 
lab02e8: add a,a 
lab02e9: jr nc,#02d9 ; (-#12) 
lab02eb: ld a,c 
lab02ec: cp #10 ; maximum rom selection scanned by firmware 
lab02ee: jr c,#02d9 ; (-#17) 
lab02f0: ret 
;;-------------------------------------------------------------------------------------------------------------
;; perform search of RSX in command-table.
;; EIther RSX in RAM or RSX in ROM.
;; HL = address of command-table in ROM
lab02f1: ld hl,#c004 
;;B=0 for RSX in ROM, B!=0 for RSX in RAM
;; This also means that ROM class must be foreground.
lab02f4: ld a,b 
lab02f5: or a 
lab02f6: jr z,#02fc 
;; HL = address of RSX table
lab02f8: ld h,b 
lab02f9: ld l,c 
;; "ROM select" for RAM 
lab02fa: ld c,#ff 
;; C = ROM select address
lab02fc: call #ba79			;; HI: KL ROM SELECT 
;; C contains the ROM select address of the previously selected ROM.
;; B contains the previous ROM state
;; preserve previous rom selection and rom state
lab02ff: push bc 
;; get address of strings from table.
lab0300: ld e,(hl) 
lab0301: inc hl 
lab0302: ld d,(hl) 
lab0303: inc hl 
;; DE = jumpblock for RSX commands
lab0304: ex de,hl 
lab0305: jr #031e ; (+#17) 
;; B8C3 = RSX command to look for stored in RAM
lab0307: ld bc,#b8c3 
lab030a: ld a,(bc) 
lab030b: cp (hl) 
lab030c: jr nz,#0316 ; (+#08) 
lab030e: inc hl 
lab030f: inc bc 
lab0310: add a,a 
lab0311: jr nc,#030a ; (-#09) 
;; if we get to here, then we found the name
lab0313: ex de,hl 
lab0314: jr #0322 ; (+#0c) 
;; char didn''t match in name
;; look for end of string, it has bit 7 set
lab0316: ld a,(hl) 
lab0317: inc hl 
;; transfer bit 7 into carry flag
lab0318: add a,a 
lab0319: jr nc,#0316 ; (-#05) 
;; update jumpblock pointer
lab031b: inc de 
lab031c: inc de 
lab031d: inc de 
;; 0 indicates end of list.
lab031e: ld a,(hl) 
lab031f: or a 
lab0320: jr nz,#0307 ; (-#1b) 
;; we got to the end of the RSX command-table and we didn''t find the command
lab0322: pop bc 
;; restore previous rom selection
lab0323: jp #ba87			;; HI: KL ROM DESELECT 
;;==========================================================================
KL_ROM_WALK:
lab0326: ld c,#0f ;; maximum number of roms that firmware supports -1 
lab0328: call #0330			; KL INIT BACK 
lab032b: dec c 
lab032c: jp p,#0328 
lab032f: ret 
;;==========================================================================
KL_INIT_BACK:
lab0330: ld a,(#b8d9) 
lab0333: cp c 
lab0334: ret z 
lab0335: ld a,c 
lab0336: cp #10 ;; maximum rom selection supported by firmware 
lab0338: ret nc 
lab0339: call #ba79		;; HI: KL ROM SELECT 
lab033c: ld a,(#c000) 
lab033f: and #03 
lab0341: dec a 
lab0342: jr nz,#0366 ; (+#22) 
lab0344: push bc 
lab0345: scf 
lab0346: call #c006 
lab0349: jr nc,#0365 ; (+#1a) 
lab034b: push de 
lab034c: inc hl 
lab034d: ex de,hl 
lab034e: ld hl,#b8da 
lab0351: ld bc,(#b8d6) 
lab0355: ld b,#00 
lab0357: add hl,bc 
lab0358: add hl,bc 
lab0359: ld (hl),e 
lab035a: inc hl 
lab035b: ld (hl),d 
lab035c: ld hl,#fffc 
lab035f: add hl,de 
lab0360: call #02a0			; KL LOG EXT 
lab0363: dec hl 
lab0364: pop de 
lab0365: pop bc 
lab0366: jp #ba87			;; HI: KL ROM DESELECT 
;;====================================================================
;; DE = address of event block
;; HL = address of event list
;; find event in list
lab0369: ld a,(hl) 
lab036a: cp e 
lab036b: inc hl 
lab036c: ld a,(hl) 
lab036d: dec hl 
lab036e: jr nz,#0373 ; (+#03) 
lab0370: cp d 
lab0371: scf 
lab0372: ret z 
lab0373: or a 
lab0374: ret z 
lab0375: ld l,(hl) 
lab0376: ld h,a 
lab0377: jr #0369 ;; find event in list ; (-#10) 
;;====================================================================
;; add event to an event list
;; HL = address of event block
;; DE = address of event list
lab0379: ex de,hl 
lab037a: di 
lab037b: call #0369 ;; find event in list 
lab037e: jr c,#0386 ; event found 
;; add to head of list
lab0380: ld (hl),e 
lab0381: inc hl 
lab0382: ld (hl),d 
lab0383: inc de 
lab0384: xor a 
lab0385: ld (de),a 
lab0386: ei 
lab0387: ret 
;;====================================================================
;; delete event from list
;; HL = address of event block
;; DE = address of event list
lab0388: ex de,hl 
lab0389: di 
lab038a: call #0369 ;; find event in list 
lab038d: jr nc,#0395 ; (+#06) 
lab038f: ld a,(de) 
lab0390: ld (hl),a 
lab0391: inc de 
lab0392: inc hl 
lab0393: ld a,(de) 
lab0394: ld (hl),a 
lab0395: ei 
lab0396: ret 
;;====================================================================
KL_BANK_SWITCH:
;;
;; A = new configuration (0-31)
;;
;; Allows any configuration to be used, so compatible with ALL Dk''Tronics RAM sizes.
lab0397: di 
lab0398: exx 
lab0399: ld hl,#b8d5 ; current bank selection 
lab039c: ld d,(hl) ; get previous 
lab039d: ld (hl),a ; set new 
lab039e: or #c0 ; bit 7 = 1, bit 6 = 1, selection in lower bits. 
lab03a0: out (c),a 
lab03a2: ld a,d ; previous bank selection 
lab03a3: exx 
lab03a4: ei 
lab03a5: ret 
;;--------------------------------------------------------------------
HIGH_KERNEL_JUMPBLOCK:
lab03a6: jp #ba5f		;; HI: KL U ROM ENABLE 
lab03a9: jp #ba66		;; HI: KL U ROM DISABLE 
lab03ac: jp #ba51		;; HI: KL L ROM ENABLE 
lab03af: jp #ba58		;; HI: KL L ROM DISABLE 
lab03b2: jp #ba70		;; HI: KL L ROM RESTORE 
lab03b5: jp #ba79		;; HI: KL ROM SELECT 
lab03b8: jp #ba9d		;; HI: KL CURR SELECTION 
lab03bb: jp #ba7e		;; HI: KL PROBE ROM 
lab03be: jp #ba87		;; HI: KL ROM DESELECT 
lab03c1: jp #baa1		;; HI: KL LDIR 
lab03c4: jp #baa7		;; HI: KL LDDR 
;;--------------------------------------------------------------------
lab03c7: ld a,(#b8c1)	;; HI: KL POLL SYNCRONOUS 
lab03ca: or a 
lab03cb: ret z 
lab03cc: push hl 
lab03cd: di 
lab03ce: jr #03d6 ; (+#06) 
lab03d0: ld hl,#b8bf		;; HI: KL SCAN NEEDED 
lab03d3: ld (hl),#01 
lab03d5: ret 
lab03d6: ld hl,(#b8c0)		; synchronouse event list 
lab03d9: ld a,h 
lab03da: or a 
lab03db: jr z,#03e4 ; (+#07) 
lab03dd: inc hl 
lab03de: inc hl 
lab03df: inc hl 
lab03e0: ld a,(#b8c2) 
lab03e3: cp (hl) 
lab03e4: pop hl 
lab03e5: ei 
lab03e6: ret 
;;============================================================================================
; RST 7 - LOW: INTERRUPT ENTRY handler
lab03e7: di 
lab03e8: ex af,af'' 
lab03e9: jr c,#041e ; detect external interrupt 
lab03eb: exx 
lab03ec: ld a,c 
lab03ed: scf 
lab03ee: ei 
lab03ef: ex af,af''			; allow interrupt function to be re-entered. This will happen if there is an external interrupt 
; source that continues to assert INT. Internal raster interrupts are acknowledged automatically and cleared.
lab03f0: di 
lab03f1: push af 
lab03f2: res 2,c				; ensure lower rom is active in range #0000-#3fff 
lab03f4: out (c),c 
lab03f6: call #00b1			; update time, execute FRAME FLY, FAST TICKER and SOUND events 
; also scan keyboard
lab03f9: or a 
lab03fa: ex af,af'' 
lab03fb: ld c,a 
lab03fc: ld b,#7f 
lab03fe: ld a,(#b831) 
lab0401: or a 
lab0402: jr z,#0418 ; quit... 
lab0404: jp m,#b972			; quit... (same as 0418, but in RAM) 
lab0407: ld a,c 
lab0408: and #0c				; %00001100 
lab040a: push af 
lab040b: res 2,c				; ensure lower rom is active in range #0000-#3fff 
lab040d: exx 
lab040e: call #010a 
lab0411: exx 
lab0412: pop hl 
lab0413: ld a,c 
lab0414: and #f3				; %11110011 
lab0416: or h 
lab0417: ld c,a 
;;
lab0418: out (c),c			;set rom config/mode etc 
lab041a: exx 
lab041b: pop af 
lab041c: ei 
lab041d: ret 
;; handle external interrupt
lab041e: ex af,af'' 
lab041f: pop hl 
lab0420: push af 
lab0421: set 2,c				; disable lower rom 
lab0423: out (c),c			; set rom config/mode etc 
lab0425: call #003b			; LOW: EXT INTERRUPT. Patchable by the user 
lab0428: jr #03f9 ; return to interrupt processing. 
;;============================================================================================
LOW_KL_LOW_PCHL:
lab042a: di 
lab042b: push hl				; store HL onto stack 
lab042c: exx 
lab042d: pop de				; get it back from stack 
lab042e: jr #0436 ; 
;;============================================================================================
RST_1__LOW_LOW_JUMP:
lab0430: di 
lab0431: exx 
lab0432: pop hl				; get return address from stack 
lab0433: ld e,(hl)			; DE = address to call 
lab0434: inc hl 
lab0435: ld d,(hl) 
;;--------------------------------------------------------------------------------------------
lab0436: ex af,af'' 
lab0437: ld a,d 
lab0438: res 7,d 
lab043a: res 6,d 
lab043c: rlca 
lab043d: rlca 
;;---------------------------------------------------------------------------------------------
lab043e: rlca 
lab043f: rlca 
lab0440: xor c 
lab0441: and #0c 
lab0443: xor c 
lab0444: push bc 
lab0445: call #b9b0 
lab0448: di 
lab0449: exx 
lab044a: ex af,af'' 
lab044b: ld a,c 
lab044c: pop bc 
lab044d: and #03 
lab044f: res 1,c 
lab0451: res 0,c 
lab0453: or c 
lab0454: jr #0457 ; (+#01) 
;;============================================================================================
;; copied to $b9b0 in RAM
lab0456: push de 
lab0457: ld c,a 
lab0458: out (c),c 
lab045a: or a 
lab045b: ex af,af'' 
lab045c: exx 
lab045d: ei 
lab045e: ret 
;;============================================================================================
LOW_KL_FAR_PCHL:
lab045f: di 
lab0460: ex af,af'' 
lab0461: ld a,c 
lab0462: push hl 
lab0463: exx 
lab0464: pop de 
lab0465: jr #047c ; (+#15) 
;;============================================================================================
LOW_KL_FAR_ICALL:
lab0467: di 
lab0468: push hl 
lab0469: exx 
lab046a: pop hl 
lab046b: jr #0476 ; (+#09) 
;;============================================================================================
RST_3__LOW_FAR_CALL:
;;
;; far call limits rom select to 251. So firmware can call functions in ROMs up to 251.
;; If you want to access ROMs above this use KL ROM SELECT.
;;
lab046d: di 
lab046e: exx 
lab046f: pop hl 
lab0470: ld e,(hl) 
lab0471: inc hl 
lab0472: ld d,(hl) 
lab0473: inc hl 
lab0474: push hl 
lab0475: ex de,hl 
lab0476: ld e,(hl) 
lab0477: inc hl 
lab0478: ld d,(hl) 
lab0479: inc hl 
lab047a: ex af,af'' 
lab047b: ld a,(hl) 
;; $fc - no change to rom select, enable upper and lower roms
;; $fd - no change to rom select, enable upper disable lower
;; $fe - no change to rom select, disable upper and enable lower
;; $ff - no change to rom select, disable upper and lower roms
lab047c: cp #fc 
lab047e: jr nc,#043e 
;; allow rom select to change
lab0480: ld b,#df			; ROM select I/O port 
lab0482: out (c),a			; select upper rom 
lab0484: ld hl,#b8d6 
lab0487: ld b,(hl) 
lab0488: ld (hl),a 
lab0489: push bc 
lab048a: push iy 
;; rom select below 16 (max for firmware 1.1)?
lab048c: cp #10 
lab048e: jr nc,#049f 
;; 16-bit table at &b8da
lab0490: add a,a 
lab0491: add a,#da 
lab0493: ld l,a 
lab0494: adc a,#b8 
lab0496: sub l 
lab0497: ld h,a 
;; get 16-bit value from this address
lab0498: ld a,(hl) 
lab0499: inc hl 
lab049a: ld h,(hl) 
lab049b: ld l,a 
lab049c: push hl 
lab049d: pop iy 
lab049f: ld b,#7f 
lab04a1: ld a,c 
lab04a2: set 2,a 
lab04a4: res 3,a 
lab04a6: call #b9b0 
lab04a9: pop iy 
lab04ab: di 
lab04ac: exx 
lab04ad: ex af,af'' 
lab04ae: ld e,c 
lab04af: pop bc 
lab04b0: ld a,b 
;; restore rom select
lab04b1: ld b,#df			; ROM select I/O port 
lab04b3: out (c),a			; restore upper rom selection 
lab04b5: ld (#b8d6),a 
lab04b8: ld b,#7f 
lab04ba: ld a,e 
lab04bb: jr #044d ; (-#70) 
;;============================================================================================
LOW_KL_SIDE_PCHL:
lab04bd: di 
lab04be: push hl 
lab04bf: exx 
lab04c0: pop de 
lab04c1: jr #04cb ; (+#08) 
;;============================================================================================
RST_2__LOW_SIDE_CALL:
lab04c3: di 
lab04c4: exx 
lab04c5: pop hl 
lab04c6: ld e,(hl) 
lab04c7: inc hl 
lab04c8: ld d,(hl) 
lab04c9: inc hl 
lab04ca: push hl 
lab04cb: ex af,af'' 
lab04cc: ld a,d 
lab04cd: set 7,d 
lab04cf: set 6,d 
lab04d1: and #c0 
lab04d3: rlca 
lab04d4: rlca 
lab04d5: ld hl,#b8d9 
lab04d8: add a,(hl) 
lab04d9: jr #0480 ; (-#5b) 
;;============================================================================================
RST_5__LOW_FIRM_JUMP:
lab04db: di 
lab04dc: exx 
lab04dd: pop hl 
lab04de: ld e,(hl) 
lab04df: inc hl 
lab04e0: ld d,(hl) 
lab04e1: res 2,c				; enable lower rom 
lab04e3: out (c),c 
lab04e5: ld (#ba46),de 
lab04e9: exx 
lab04ea: ei 
lab04eb: call #ba45 
lab04ee: di 
lab04ef: exx 
lab04f0: set 2,c				; disable lower rom 
lab04f2: out (c),c 
lab04f4: exx 
lab04f5: ei 
lab04f6: ret 
;;============================================================================================
HI_KL_L_ROM_ENABLE:
lab04f7: di 
lab04f8: exx 
lab04f9: ld a,c ; current mode/rom state 
lab04fa: res 2,c				; enable lower rom 
lab04fc: jr #0511 ; enable/disable rom common code 
;;============================================================================================
HI_KL_L_ROM_DISABLE:
lab04fe: di 
lab04ff: exx 
lab0500: ld a,c ; current mode/rom state 
lab0501: set 2,c				; disable upper rom 
lab0503: jr #0511 ; enable/disable rom common code 
;;============================================================================================
HI_KL_U_ROM_ENABLE:
lab0505: di 
lab0506: exx 
lab0507: ld a,c ; current mode/rom state 
lab0508: res 3,c				; enable upper rom 
lab050a: jr #0511 ; enable/disable rom common code 
;;============================================================================================
HI_KL_U_ROM_DISABLE:
lab050c: di 
lab050d: exx 
lab050e: ld a,c ; current mode/rom state 
lab050f: set 3,c				; disable upper rom 
;;--------------------------------------------------------------------------------------------
;; enable/disable rom common code
lab0511: out (c),c 
lab0513: exx 
lab0514: ei 
lab0515: ret 
;;============================================================================================
HI_KL_L_ROM_RESTORE:
lab0516: di 
lab0517: exx 
lab0518: xor c 
lab0519: and #0c				; %1100 
lab051b: xor c 
lab051c: ld c,a 
lab051d: jr #0511 ; enable/disable rom common code 
;;============================================================================================
HI_KL_ROM_SELECT:
;; Any value can be used from 0-255.
lab051f: call #ba5f			;; HI: KL U ROM ENABLE 
lab0522: jr #0533 ;; common upper rom selection code 
;;============================================================================================
HI_KL_PROBE_ROM:
lab0524: call #ba79			;; HI: KL ROM SELECT 
;; read rom version etc
lab0527: ld a,(#c000) 
lab052a: ld hl,(#c001) 
;; drop through to HI: KL ROM DESELECT
;;============================================================================================
HI_KL_ROM_DESELECT:
lab052d: push af 
lab052e: ld a,b 
lab052f: call #ba70			;; HI: KL L ROM RESTORE 
lab0532: pop af 
;;--------------------------------------------------------------------------------------------
;; common upper rom selection code
lab0533: push hl 
lab0534: di 
lab0535: ld b,#df			;; ROM select I/O port 
lab0537: out (c),c			;; select upper rom 
lab0539: ld hl,#b8d6 ;; previous upper rom selection 
lab053c: ld b,(hl) ;; get previous upper rom selection 
lab053d: ld (hl),c ;; store new rom selection 
lab053e: ld c,b ;; C = previous rom select 
lab053f: ld b,a ;; B = previous rom state 
lab0540: ei 
lab0541: pop hl 
lab0542: ret 
;;============================================================================================
HI_KL_CURR_SELECTION:
lab0543: ld a,(#b8d6) 
lab0546: ret 
;;============================================================================================
HI_KL_LDIR:
lab0547: call #baad			;; disable upper/lower rom.. execute code below and then restore rom state 
;; called via $baad
lab054a: ldir 
;; returns back to code after call in $baad   
lab054c: ret 
;;============================================================================================
HI_KL_LDDR:
lab054d: call #baad			;; disable upper/lower rom.. execute code below and then restore rom state 
;; called via $baad
lab0550: lddr 
;; returns back to code after call in $baad   
lab0552: ret 
;;============================================================================================
;; used by HI: KL LDIR and HI: KL LDDR
;; copied to $baad in RAM
;;
;; - disables upper and lower rom
;; - continues execution from function that called it allowing it to return back
;; - restores upper and lower rom state
lab0553: di 
lab0554: exx 
lab0555: pop hl					; return address 
lab0556: push bc					; store rom state 
lab0557: set 2,c					; disable lower rom 
lab0559: set 3,c					; disable upper rom 
lab055b: out (c),c				; set rom state 
;; jump to function on the stack, allow it to return back here
lab055d: call #bac2				; jump to function in HL 
lab0560: di 
lab0561: exx 
lab0562: pop bc					; get previous rom state 
lab0563: out (c),c				; restore previous rom state 
lab0565: exx 
lab0566: ei 
lab0567: ret 
;;============================================================================================
;; copied to $bac2 into RAM
lab0568: push hl 
lab0569: exx 
lab056a: ei 
lab056b: ret 
;;============================================================================================
RST_4__LOW_RAM_LAM:
;; HL = address to read
lab056c: di 
lab056d: exx 
lab056e: ld e,c				;; E = current rom configuration 
lab056f: set 2,e				;; disable lower rom 
lab0571: set 3,e				;; disable upper rom 
lab0573: out (c),e			;; set rom configuration 
lab0575: exx 
lab0576: ld a,(hl)			;; read byte from RAM 
lab0577: exx 
lab0578: out (c),c			;; restore rom configuration 
lab057a: exx 
lab057b: ei 
lab057c: ret 
;;============================================================================================
;; read byte from address pointed to IX with roms disabled
;;
;; (used by cassette functions to read/write to RAM)
;;
;; IX = address of byte to read
;; C'' = current rom selection and mode
lab057d: exx						;; switch to alternative register set 
lab057e: ld a,c				;; get rom configuration 
lab057f: or #0c				;; %00001100 (disable upper and lower rom) 
lab0581: out (c),a			;; set the new rom configuration 
lab0583: ld a,(ix+#00)		;; read byte from RAM 
lab0586: out (c),c			;; restore original rom configuration 
lab0588: exx						;; switch back from alternative register set 
lab0589: ret 
;;============================================================================================
lab058a: ld h,#c7 
lab058c: rst #00 
lab058d: rst #00 
lab058e: rst #00 
lab058f: rst #00 
lab0590: rst #00 
;;============================================================================================
lab0591: di 
lab0592: ld bc,#f782 
lab0595: out (c),c 
lab0597: ld bc,#f400			;; initialise PPI port A data 
lab059a: out (c),c 
lab059c: ld bc,#f600			;; initialise PPI port C data 
;; - select keyboard line 0
;; - PSG control inactive
;; - cassette motor off
;; - cassette write data "0"
lab059f: out (c),c			;; set PPI port C data 
lab05a1: ld bc,#ef7f 
lab05a4: out (c),c 
lab05a6: ld b,#f5			;; PPI port B inputs 
lab05a8: in a,(c) 
lab05aa: and #10 
lab05ac: ld hl,#05d5			;; end of CRTC data for 50Hz display 
lab05af: jr nz,#05b4 
lab05b1: ld hl,#05e5			;; end of CRTC data for 60Hz display 
;; initialise display
;; starting with register 15, then down to 0
lab05b4: ld bc,#bc0f 
lab05b7: out (c),c			; select CRTC register 
lab05b9: dec hl 
lab05ba: ld a,(hl)			; get data from table 
lab05bb: inc b 
lab05bc: out (c),a			; write data to selected CRTC register 
lab05be: dec b 
lab05bf: dec c 
lab05c0: jp p,#05b7 
;; continue with setup...
lab05c3: jr #05e5 ; (+#20) 
;; CRTC data for 50Hz display
lab05c5: defb #3f, #28, #2e, #8e, #26, #00, #19, #1e, #00, #07, #00,#00,#30,#00,#c0,#00 
;; CRTC data for 60Hz display
lab05d5: defb #3f, #28, #2e, #8e, #1f, #06, #19, #1b, #00, #07, #00,#00,#30,#00,#c0,#00 
;;========================================================
;; continue with setup...
lab05e5: ld de,#0677			; this is executed by execution address 
lab05e8: ld hl,#0000			; this will force MC START PROGRAM to start BASIC 
lab05eb: jr #061f ; mc start program 
;;========================================================
MC_BOOT_PROGRAM:
;; 
;; HL = execute address
lab05ed: ld sp,#c000 
lab05f0: push hl 
lab05f1: call #1fe9			;; SOUND RESET 
lab05f4: di 
lab05f5: ld bc,#f8ff			;; reset all peripherals 
lab05f8: out (c),c 
lab05fa: call #005c			;; KL CHOKE OFF 
lab05fd: pop hl 
lab05fe: push de 
lab05ff: push bc 
lab0600: push hl 
lab0601: call #1b98			;; KM RESET 
lab0604: call #1084			;; TXT RESET 
lab0607: call #0ad0			;; SCR RESET 
lab060a: call #ba5f			;; HI: KL U ROM ENABLE 
lab060d: pop hl 
lab060e: call #001e			;; LOW: PCHL INSTRUCTION 
lab0611: pop bc 
lab0612: pop de 
lab0613: jr c,#061c ; MC START PROGRAM 
;; display program load failed message
lab0615: ex de,hl 
lab0616: ld c,b 
lab0617: ld de,#06f9			; program load failed 
lab061a: jr #061f ; 
;;=========================================================
MC_START_PROGRAM:
;; HL = entry address
;; C = rom select 
lab061c: ld de,#0737			; RET (no message) 
; this is executed by: LOW: PCHL INSTRUCTION
;;---------------------------------------------------------
lab061f: di						; disable interrupts 
lab0620: im 1				; Z80 interrupt mode 1 
lab0622: exx 
lab0623: ld bc,#df00			; select upper ROM 0 
lab0626: out (c),c 
lab0628: ld bc,#f8ff			; reset all peripherals 
lab062b: out (c),c 
lab062d: ld bc,#7fc0			; select ram configuration 0 
lab0630: out (c),c 
lab0632: ld bc,#fa7e			; stop disc motor 
lab0635: xor a 
lab0636: out (c),a 
lab0638: ld hl,#b100			; clear memory block which will hold 
lab063b: ld de,#b101			; firmware jumpblock 
lab063e: ld bc,#07f9 
lab0641: ld (hl),a 
lab0642: ldir 
lab0644: ld bc,#7f89			; select mode 1, lower rom on, upper rom off 
lab0647: out (c),c 
lab0649: exx 
lab064a: xor a 
lab064b: ex af,af'' 
lab064c: ld sp,#c000				;; initial stack location 
lab064f: push hl 
lab0650: push bc 
lab0651: push de 
lab0652: call #0044				;; initialise LOW KERNEL and HIGH KERNEL jumpblocks 
lab0655: call #08bd				;; JUMP RESTORE 
lab0658: call #1b5c				;; KM INITIALISE 
lab065b: call #1fe9				;; SOUND RESET 
lab065e: call #0abf				;; SCR INITIALISE 
lab0661: call #1074				;; TXT INITIALISE 
lab0664: call #15a8				;; GRA INITIALISE 
lab0667: call #24bc				;; CAS INITIALISE 
lab066a: call #07e0				;; MC RESET PRINTER 
lab066d: ei 
lab066e: pop hl 
lab066f: call #001e				;; LOW: PCHL INSTRUCTION 
lab0672: pop bc 
lab0673: pop hl 
lab0674: jp #0077				;; start BASIC or program 
;;======================================================================
lab0677: ld hl,#0202 
lab067a: call #1170			; TXT SET CURSOR 
lab067d: call #0723			; get pointer to machine name (based on LK1-LK3 on PCB) 
lab0680: call #06fc			; display message 
lab0683: ld hl,#0688			; "128K Microcomputer.." message 
lab0686: jr #06fc ; 
lab0688: 
defb " 128K Microcomputer  (v3)"
defb #1f,#02,#04
defb "Copyright"
defb #1f,#02,#04
defb #a4								;; copyright symbol
defb "1985 Amstrad Consumer Electronics plc"
defb #1f,#0c,#05
defb "and Locomotive Software Ltd."
defb #1f,#01,#07
defb 0
;;-----------------------------------------------------------------------
lab06f9: ld hl,#0705			; "*** PROGRAM LOAD FAILED ***" message 
;;-----------------------------------------------------------------------
;; display a null terminated string
lab06fc: ld a,(hl)			; get message character 
lab06fd: inc hl 
lab06fe: or a 
lab06ff: ret z 
lab0700: call #13fe			; TXT OUTPUT 
lab0703: jr #06fc 
lab0705: defb "*** PROGRAM LOAD FAILED ***",13,10,0 
;;-----------------------------------------------------------------------
;; get a pointer to the machine name
;; HL = machine name
lab0723: ld b,#f5			;; PPI port B input 
lab0725: in a,(c) 
lab0727: cpl 
lab0728: and #0e				;; isolate LK1-LK3 (defines machine name on startup) 
lab072a: rrca 
;; A = machine name number
lab072b: ld hl,#0738			; table of names 
lab072e: inc a 
lab072f: ld b,a 
;; B = index of string wanted
;; keep getting bytes until end of string marker (0) is found
;; decrement string count and continue until we have got string
;; wanted
lab0730: ld a,(hl)			; get byte 
lab0731: inc hl 
lab0732: or a				; end of string? 
lab0733: jr nz,#0730 ; 
lab0735: djnz #0730 ; (-#07) 
lab0737: ret 
;; start-up names
lab0738: 
defb "Arnold",0							;; this name can''t be chosen
defb "Amstrad",0
defb "Orion",0
defb "Schneider",0
defb "Awa",0
defb "Solavox",0
defb "Saisho",0
defb "Triumph",0
defb "Isp",0
;;====================================================================
MC_SET_MODE:
;; 
;; A = mode index
;;
;; C'' = Gate Array rom and mode configuration register
;; test mode index is in range
lab0776: cp #03 
lab0778: ret nc 
;; mode index is in range: A = 0,1 or 2.
lab0779: di 
lab077a: exx 
lab077b: res 1,c				;; clear mode bits (bit 1 and bit 0) 
lab077d: res 0,c 
lab077f: or c				;; set mode bits to new mode value 
lab0780: ld c,a 
lab0781: out (c),c			;; set mode 
lab0783: ei 
lab0784: exx 
lab0785: ret 
;;====================================================================
MC_CLEAR_INKS:
lab0786: push hl 
lab0787: ld hl,#0000 
lab078a: jr #0790 
;;====================================================================
MC_SET_INKS:
lab078c: push hl 
lab078d: ld hl,#0001 
;;--------------------------------------------------------------------
;; HL = 0 for clear, 1 for set
lab0790: push de 
lab0791: push bc 
lab0792: ex de,hl 
lab0793: ld bc,#7f10			; set border colour 
lab0796: call #07aa			; set colour for PEN/border direct to hardware 
lab0799: inc hl 
lab079a: ld c,#00 
lab079c: call #07aa			; set colour for PEN/border direct to hardware 
lab079f: add hl,de 
lab07a0: inc c 
lab07a1: ld a,c 
lab07a2: cp #10 ; maximum number of colours (mode 0 has 16 colours) 
lab07a4: jr nz,#079c ; (-#0a) 
lab07a6: pop bc 
lab07a7: pop de 
lab07a8: pop hl 
lab07a9: ret 
;;====================================================================
;; set colour for a pen
;;
;; HL = address of colour for pen
;; C = pen index
lab07aa: out (c),c			; select pen 
lab07ac: ld a,(hl) 
lab07ad: and #1f 
lab07af: or #40 
lab07b1: out (c),a			; set colour for pen 
lab07b3: ret 
;;====================================================================
MC_WAIT_FLYBACK:
lab07b4: push af 
lab07b5: push bc 
lab07b6: ld b,#f5			; PPI port B I/O address 
lab07b8: in a,(c)			; read PPI port B input 
lab07ba: rra						; transfer bit 0 (VSYNC signal from CRTC) into carry flag 
lab07bb: jr nc,#07b8			; wait until VSYNC=1 
lab07bd: pop bc 
lab07be: pop af 
lab07bf: ret 
;;====================================================================
MC_SCREEN_OFFSET:
;;
;; HL = offset
;; A = base
lab07c0: push bc 
lab07c1: rrca 
lab07c2: rrca 
lab07c3: and #30 
lab07c5: ld c,a 
lab07c6: ld a,h 
lab07c7: rra 
lab07c8: and #03 
lab07ca: or c 
;; CRTC register 12 and 13 define screen base and offset
lab07cb: ld bc,#bc0c 
lab07ce: out (c),c			; select CRTC register 12 
lab07d0: inc b				; BC = bd0c 
lab07d1: out (c),a			; set CRTC register 12 data 
lab07d3: dec b				; BC = bc0c 
lab07d4: inc c				; BC = bc0d 
lab07d5: out (c),c			; select CRTC register 13 
lab07d7: inc b				; BC = bd0d 
lab07d8: ld a,h 
lab07d9: rra 
lab07da: ld a,l 
lab07db: rra 
lab07dc: out (c),a			; set CRTC register 13 data 
lab07de: pop bc 
lab07df: ret 
;;====================================================================
MC_RESET_PRINTER:
lab07e0: ld hl,#07f7 
lab07e3: ld de,#b804 
lab07e6: ld bc,#0015 
lab07e9: ldir 
lab07eb: ld hl,#07f1				;; table used to initialise printer indirections 
lab07ee: jp #0ab4				;; initialise printer indirections 
lab07f1: 
defb #03
defw #bdf1									
lab07f4: jp #0835								;; IND: MC WAIT PRINTER 
lab07f7: ld a,(bc) 
lab07f8: and b 
lab07f9: ld e,(hl) 
lab07fa: and c 
lab07fb: ld e,h 
lab07fc: and d 
lab07fd: ld a,e 
lab07fe: and e 
lab07ff: inc hl 
lab0800: and (hl) 
lab0801: ld b,b 
lab0802: xor e 
lab0803: ld a,h 
lab0804: xor h 
lab0805: ld a,l 
lab0806: xor l 
lab0807: ld a,(hl) 
lab0808: xor (hl) 
lab0809: ld e,l 
lab080a: xor a 
lab080b: ld e,e 
;;===========================================================================
MC_PRINT_TRANSLATION:
lab080c: rst #20				; RST 4 - LOW: RAM LAM 
lab080d: add a,a 
lab080e: inc a 
lab080f: ld c,a 
lab0810: ld b,#00 
lab0812: ld de,#b804 
lab0815: cp #2a 
lab0817: call c,#baa1			;; HI: KL LDIR 
lab081a: ret 
;;===========================================================================
MC_PRINT_CHAR:
lab081b: push bc 
lab081c: push hl 
lab081d: ld hl,#b804 
lab0820: ld b,(hl) 
lab0821: inc b 
lab0822: dec b 
lab0823: jr z,#082f ; (+#0a) 
lab0825: inc hl 
lab0826: cp (hl) 
lab0827: inc hl 
lab0828: jr nz,#0822 ; (-#08) 
lab082a: ld a,(hl) 
lab082b: cp #ff 
lab082d: jr z,#0832 ; (+#03) 
lab082f: call #bdf1			; IND: MC WAIT PRINTER 
lab0832: pop hl 
lab0833: pop bc 
lab0834: ret 
;;====================================================================
IND_MC_WAIT_PRINTER:
lab0835: ld bc,#0032 
lab0838: call #0858			; MC BUSY PRINTER 
lab083b: jr nc,#0844 ; MC SEND PRINTER 
lab083d: djnz #0838 
lab083f: dec c 
lab0840: jr nz,#0838 
lab0842: or a 
lab0843: ret 
;;====================================================================
MC_SEND_PRINTER:
;; 
;; NOTEs: 
;; - bits 6..0 of A contain the data
;; - bit 7 of data is /STROBE signal
;; - /STROBE signal is inverted by hardware; therefore 0->1 and 1->0
;; - data is written with /STROBE pulsed low 
lab0844: push bc 
lab0845: ld b,#ef			; printer I/O address 
lab0847: and #7f				; clear bit 7 (/STROBE) 
lab0849: out (c),a			; write data with /STROBE=1 
lab084b: or #80				; set bit 7 (/STROBE) 
lab084d: di 
lab084e: out (c),a			; write data with /STROBE=0 
lab0850: and #7f				; clear bit 7 (/STROBE) 
lab0852: ei 
lab0853: out (c),a			; write data with /STROBE=1 
lab0855: pop bc 
lab0856: scf 
lab0857: ret 
;;====================================================================
MC_BUSY_PRINTER:
;; 
;; exit:
;; carry = state of BUSY input from printer
lab0858: push bc 
lab0859: ld c,a 
lab085a: ld b,#f5			; PPI port B I/O address 
lab085c: in a,(c)			; read PPI port B input 
lab085e: rla						; transfer bit 6 into carry (BUSY input from printer) 
lab085f: rla 
lab0860: ld a,c 
lab0861: pop bc 
lab0862: ret 
;;====================================================================
MC_SOUND_REGISTER:
;; 
;; entry:
;; A = register index
;; C = register data
;; 
lab0863: di 
lab0864: ld b,#f4			; PPI port A I/O address 
lab0866: out (c),a			; write register index 
lab0868: ld b,#f6			; PPI port C I/O address 
lab086a: in a,(c)			; get current outputs of PPI port C I/O port 
lab086c: or #c0				; bit 7,6: PSG register select 
lab086e: out (c),a			; write control to PSG. PSG will select register 
; referenced by data at PPI port A output
lab0870: and #3f				; bit 7,6: PSG inactive 
lab0872: out (c),a			; write control to PSG. 
lab0874: ld b,#f4			; PPI port A I/O address 
lab0876: out (c),c			; write register data 
lab0878: ld b,#f6			; PPI port C I/O address 
lab087a: ld c,a 
lab087b: or #80				; bit 7,6: PSG write data to selected register 
lab087d: out (c),a			; write control to PSG. PSG will write the data 
; at PPI port A into the currently selected register
; bit 7,6: PSG inactive
lab087f: out (c),c			; write control to PSG 
lab0881: ei 
lab0882: ret 
;;--------------------------------------------------------------
;; scan keyboard
;;---------------------------------------------------------------------------------
;; select PSG port A register
lab0883: ld bc,#f40e			; B = I/O address for PPI port A 
; C = 14 (index of PSG I/O port A register)
lab0886: out (c),c			; write PSG register index to PPI port A 
lab0888: ld b,#f6			; B = I/O address for PPI port C 
lab088a: in a,(c)			; get current port C data 
lab088c: and #30 
lab088e: ld c,a 
lab088f: or #c0				; PSG operation: select register 
lab0891: out (c),a			; write to PPI port C 
; PSG will use data from PPI port A
; to select a register
lab0893: out (c),c 
;;---------------------------------------------------------------------------------
;; set PPI port A to input
lab0895: inc b				; B = #f7 (I/O address for PPI control) 
lab0896: ld a,#92			; PPI port A: input 
; PPI port B: input
; PPI port C (upper and lower): output
lab0898: out (c),a			; write to PPI control register 
;;---------------------------------------------------------------------------------
lab089a: push bc 
lab089b: set 6,c				; PSG: operation: read data from selected register 
lab089d: ld b,#f6			; B = I/O address for PPI port C 
lab089f: out (c),c 
lab08a1: ld b,#f4			; B = I/O address for PPI port A 
lab08a3: in a,(c)			; read selected keyboard line 
; (keyboard data->PSG port A->PPI port A)
lab08a5: ld b,(hl)			; get previous keyboard line state 
; "0" indicates a pressed key
; "1" indicates a released key
lab08a6: ld (hl),a			; store new keyboard line state 
lab08a7: and b				; a bit will be 1 where a key was not pressed 
; in the previous keyboard scan and the current keyboard scan.
; a bit will be 0 where a key has been:
; - pressed in previous keyboard scan, released in this keyboard scan
; - not pressed in previous keyboard scan, pressed in this keyboard scan
; - key has been held for previous and this keyboard scan.
lab08a8: cpl						; change so a ''1'' now indicates held/pressed key 
; ''0'' indicates a key that has not been pressed/held
lab08a9: ld (de),a			; store keybaord line data 
lab08aa: inc hl 
lab08ab: inc de 
lab08ac: inc c 
lab08ad: ld a,c 
lab08ae: and #0f				; current keyboard line 
lab08b0: cp #0a				; 10 keyboard lines 
lab08b2: jr nz,#089d 
lab08b4: pop bc 
;; B = I/O address of PPI control register
lab08b5: ld a,#82			; PPI port A: output 
; PPI port B: input
; PPI port C (upper and lower): output
lab08b7: out (c),a 
;; B = I/O address of PPI port C lower
lab08b9: dec b 
lab08ba: out (c),c 
lab08bc: ret 
;;--------------------------------------------------------------
JUMP_RESTORE:
;;
;; (restore all the firmware jump routines)
;; main firmware jumpblock
lab08bd: ld hl,#08de			; table of addressess for firmware functions 
lab08c0: ld de,#bb00			; start of firmware jumpblock 
lab08c3: ld bc,#cbcf			; B = 203 entries, C = 0x0cf -> RST 1 -> LOW: LOW JUMP 
lab08c6: call #08cc 
lab08c9: ld bc,#20ef			; B = number of entries: 32 entries 
; C=  0x0ef -> RST 5 -> LOW: FIRM JUMP
;;-------------------------------------------------------------------------------------
; C = 0x0cf -> RST 1 -> LOW: LOW JUMP
; or
; C=  0x0ef -> RST 5 -> LOW: FIRM JUMP
lab08cc: ld a,c				; write RST instruction 
lab08cd: ld (de),a 
lab08ce: inc de 
lab08cf: ldi 					; write low byte of address in ROM 
lab08d1: inc bc 
lab08d2: cpl 
lab08d3: rlca 
lab08d4: rlca 
lab08d5: and #80 
lab08d7: or (hl) 
lab08d8: ld (de),a			; write high byte of address in ROM 
lab08d9: inc de 
lab08da: inc hl 
lab08db: djnz #08cc 
lab08dd: ret 
;; each entry is an address (within this ROM) which will perform
;; the associated firmware function
lab08de:: 
defw #1b5c		;; 0 firmware function: KM INITIALISE
defw #1b98		;; 1 firmware function: KM RESET 
defw #1bbf		;; 2 firmware function: KM WAIT CHAR
defw #1bc5		;; 3 firmware function: KM READ CHAR 
defw #1bfa		;; 4 firmware function: KM CHAR RETURN
defw #1c46		;; 5 firmware function: KM SET EXPAND
defw #1cb3		;; 6 firmware function: KM GET EXPAND
defw #1c04		;; 7 firmware function: KM EXP BUFFER
defw #1cdb		;; 8 firmware function: KM WAIT KEY
defw #1ce1		;; 9 firmware function: KM READ KEY
defw #1e45		;; 10 firmware function: KM TEST KEY
defw #1d38		;; 11 firmware function: KM GET STATE
defw #1de5		;; 12 firmware function: KM GET JOYSTICK
defw #1ed8		;; 13 firmware function: KM SET TRANSLATE
defw #1ec4		;; 14 firmware function: KM GET TRANSLATE
defw #1edd		;; 15 firmware function: KM SET SHIFT
defw #1ec9		;; 16 firmware function: KM GET SHIFT
defw #1ee2		;; 17 firmware function: KM SET CONTROL 
defw #1ece		;; 18 firmware function: KM GET CONTROL 
defw #1e34		;; 19 firmware function: KM SET REPEAT
defw #1e2f		;; 20 firmware function: KM GET REPEAT
defw #1df6		;; 21 firmware function: KM SET DELAY
defw #1df2		;; 22 firmware function: KM GET DELAY
defw #1dfa		;; 23 firmware function: KM ARM BREAK
defw #1e0b		;; 24 firmware function: KM DISARM BREAK
defw #1e19		;; 25 firmware function: KM BREAK EVENT 
defw #1074		;; 26 firmware function: TXT INITIALISE
defw #1084		;; 27 firmware function: TXT RESET
defw #1459		;; 28 firmware function: TXT VDU ENABLE
defw #1452		;; 29 firmware function: TXT VDU DISABLE
defw #13fe		;; 30 firmware function: TXT OUTPUT
defw #1335		;; 31 firmware function: TXT WR CHAR
defw #13ac		;; 32 firmware function: TXT RD CHAR
defw #13a8		;; 33 firmware function: TXT SET GRAPHIC
defw #1208		;; 34 firmware function: TXT WIN ENABLE
defw #1252		;; 35 firmware function: TXT GET WINDOW
defw #154f		;; 36 firmware function: TXT CLEAR WINDOW
defw #115a		;; 37 firmware function: TXT SET COLUMN
defw #1165		;; 38 firmware function: TXT SET ROW
defw #1170		;; 39 firmware function: TXT SET CURSOR
defw #117c		;; 40 firmware function: TXT GET CURSOR
defw #1286		;; 41 firmware function: TXT CUR ENABLE
defw #1297		;; 42 firmware function: TXT CUR DISABLE
defw #1276		;; 43 firmware function: TXT CUR ON
defw #127e		;; 44 firmware function: TXT CUR OFF
defw #11ca		;; 45 firmware function: TXT VALIDATE
defw #1265		;; 46 firmware function: TXT PLACE CURSOR
defw #1265		;; 47 firmware function: TXT REMOVE CURSOR
defw #12a6		;; 48 firmware function: TXT SET PEN 
defw #12ba		;; 49 firmware function: TXT GET PEN
defw #12ab		;; 50 firmware function: TXT SET PAPER
defw #12c0		;; 51 firmware function: TXT GET PAPER
defw #12c6		;; 52 firmware function: TXT INVERSE
defw #137b		;; 53 firmware function: TXT SET BACK
defw #1388		;; 54 firmware function: TXT GET BACK
defw #12d4		;; 55 firmware function: TXT GET MATRIX
defw #12f2		;; 56 firmware function: TXT SET MATRIX
defw #12fe		;; 57 firmware function: TXT SET M TABLE
defw #132b		;; 58 firmware function: TXT GET M TABLE
defw #14d4		;; 59 firmware function: TXT GET CONTROLS
defw #10e4		;; 60 firmware function: TXT STR SELECT
defw #1103		;; 61 firmware function: TXT SWAP STREAMS
defw #15a8		;; 62 firmware function: GRA INITIALISE
defw #15d7		;; 63 firmware function: GRA RESET
defw #15fe		;; 64 firmware function: GRA MOVE ABSOLUTE
defw #15fb		;; 65 firmware function: GRA MOVE RELATIVE
defw #1606		;; 66 firmware function: GRA ASK CURSOR
defw #160e		;; 67 firmware function: GRA SET ORIGIN
defw #161c		;; 68 firmware function: GRA GET ORIGIN
defw #16a5		;; 69 firmware function: GRA WIN WIDTH
defw #16ea		;; 70 firmware function: GRA WIN HEIGHT
defw #1717		;; 71 firmware function: GRA GET W WIDTH
defw #172d		;; 72 firmware function: GRA GET W HEIGHT
defw #1736		;; 73 firmware function: GRA CLEAR WINDOW
defw #1767		;; 74 firmware function: GRA SET PEN
defw #1775		;; 75 firmware function: GRA GET PEN
defw #176e		;; 76 firmware function: GRA SET PAPER
defw #177a		;; 77 firmware function: GRA GET PAPER
defw #1783		;; 78 firmware function: GRA PLOT ABSOLUTE
defw #1780		;; 79 firmware function: GRA PLOT RELATIVE
defw #1797		;; 80 firmware function: GRA TEST ABSOLUTE
defw #1794		;; 81 firmware function: GRA TEST RELATIVE
defw #17a9		;; 82 firmware function: GRA LINE ABSOLUTE
defw #17a6		;; 83 firmware function: GRA LINE RELATIVE
defw #1940		;; 84 firmware function: GRA WR CHAR
defw #0abf		;; 85 firmware function: SCR INITIALIZE
defw #0ad0		;; 86 firmware function: SCR RESET
defw #0b37		;; 87 firmware function: SCR OFFSET
defw #0b3c		;; 88 firmware function: SCR SET BASE
defw #0b56		;; 89 firmware function: SCR GET LOCATION
defw #0ae9		;; 90 firmware function: SCR SET MODE
defw #0b0c		;; 91 firmware function: SCR GET MODE
defw #0b17		;; 92 firmware function: SCR CLEAR
defw #0b5d		;; 93 firmware function: SCR CHAR LIMITS
defw #0b6a		;; 94 firmware function: SCR CHAR POSITION
defw #0baf		;; 95 firmware function: SCR DOT POSITION
defw #0c05		;; 96 firmware function: SCR NEXT BYTE
defw #0c11		;; 97 firmware function: SCR PREV BYTE
defw #0c1f		;; 98 firmware function: SCR NEXT LINE
defw #0c39		;; 99 firmware function: SCR PREV LINE
defw #0c8e		;; 100 firmware function: SCR INK ENCODE
defw #0ca7		;; 101 firmware function: SCR INK DECODE
defw #0cf2		;; 102 firmware function: SCR SET INK
defw #0d1a		;; 103 firmware function: SCR GET INK
defw #0cf7		;; 104 firmware function: SCR SET BORDER
defw #0d1f		;; 105 firmware function: SCR GET BORDER
defw #0cea		;; 106 firmware function: SCR SET FLASHING
defw #0cee		;; 107 firmware function: SCR GET FLASHING
defw #0db9		;; 108 firmware function: SCR FILL BOX
defw #0dbd		;; 109 firmware function: SCR FLOOD BOX
defw #0de5		;; 110 firmware function: SCR CHAR INVERT
defw #0e00		;; 111 firmware function: SCR HW ROLL
defw #0e44		;; 112 firmware function: SCR SW ROLL
defw #0ef9		;; 113 firmware function: SCR UNPACK
defw #0f2a		;; 114 firmware function: SCR REPACK
defw #0c55		;; 115 firmware function: SCR ACCESS
defw #0c74		;; 116 firmware function: SCR PIXELS
defw #0f93		;; 117 firmware function: SCR HORIZONTAL
defw #0f9b		;; 118 firmware function: SCR VERTICAL
defw #24bc		;; 119 firmware function: CAS INITIALISE
defw #24ce		;; 120 firmware function: CAS SET SPEED
defw #24e1		;; 121 firmware function: CAS NOISY
defw #2bbb		;; 122 firmware function: CAS START MOTOR
defw #2bbf		;; 123 firmware function: CAS STOP MOTOR
defw #2bc1		;; 124 firmware function: CAS RESTORE MOTOR
defw #24e5		;; 125 firmware function: CAS IN OPEN
defw #2550		;; 126 firmware function: CAS IN CLOSE
defw #2557		;; 127 firmware function: CAS IN ABANDON
defw #25a0		;; 128 firmware function: CAS IN CHAR
defw #2618		;; 129 firmware function: CAS IN DIRECT
defw #2607		;; 130 firmware function: CAS RETURN
defw #2603		;; 131 firmware function: CAS TEST EOF
defw #24fe		;; 132 firmware function: CAS OUT OPEN
defw #257f		;; 133 firmware function: CAS OUT CLOSE
defw #2599		;; 134 firmware function: CAS OUT ABANDON
defw #25c6		;; 135 firmware function: CAS OUT CHAR
defw #2653		;; 136 firmware function: CAS OUT DIRECT
defw #2692		;; 137 firmware function: CAS CATALOG
defw #29af		;; 138 firmware function: CAS WRITE
defw #29a6		;; 139 firmware function: CAS READ
defw #29c1		;; 140 firmware function: CAS CHECK
defw #1fe9		;; 141 firmware function: SOUND RESET
defw #2114		;; 142 firmware function: SOUND QUEUE
defw #21ce		;; 143 firmware function: SOUND CHECK
defw #21eb		;; 144 firmware function: SOUND ARM EVENT
defw #21ac		;; 145 firmware function: SOUND RELEASE
defw #2050		;; 146 firmware function: SOUND HOLD
defw #206b		;; 147 firmware function: SOUND CONTINUE
defw #2495		;; 148 firmware function: SOUND AMPL ENVELOPE
defw #249a		;; 149 firmware function: SOUND TONE ENVELOPE
defw #24a6		;; 150 firmware function: SOUND A ADDRESS
defw #24ab		;; 151 firmware function: SOUND T ADDRESS
defw #005c		;; 152 firmware function: KL CHOKE OFF
defw #0326		;; 153 firmware function: KL ROM WALK
defw #0330		;; 154 firmware function: KL INIT BACK
defw #02a0		;; 155 firmware function: KL LOG EXT
defw #02b1		;; 156 firmware function: KL FIND COMMAND
defw #0163		;; 157 firmware function: KL NEW FRAME FLY
defw #016a		;; 158 firmware function: KL ADD FRAME FLY
defw #0170		;; 159 firmware function: KL DEL FRAME FLY
defw #0176		;; 160 firmware function: KL NEW FAST TICKER
defw #017d		;; 161 firmware function: KL ADD FAST TICKER
defw #0183		;; 162 firmware function: KL DEL FAST TICKER
defw #01b3		;; 163 firmware function: KL ADD TICKER
defw #01c5		;; 164 firmware function: KL DEL TICKER
defw #01d2		;; 165 firmware function: KL INIT EVENT
defw #01e2		;; 166 firmware function: KL EVENT
defw #0227		;; 167 firmware function: KL SYNC RESET
defw #0284		;; 168 firmware function: KL DEL SYNCHRONOUS
defw #0255		;; 169 firmware function: KL NEXT SYNC
defw #0219		;; 170 firmware function: KL DO SYNC
defw #0276		;; 171 firmware function: KL DONE SYNC
defw #0294		;; 172 firmware function: KL EVENT DISABLE
defw #029a		;; 173 firmware function: KL EVENT ENABLE
defw #028d		;; 174 firmware function: KL DISARM EVENT
defw #0099		;; 175 firmware function: KL TIME PLEASE
defw #00a3		;; 176 firmware function: KL TIME SET
defw #05ed		;; 177 firmware function: MC BOOT PROGRAM
defw #061c		;; 178 firmware function: MC START PROGRAM
defw #07b4		;; 179 firmware function: MC WAIT FLYBACK
defw #0776		;; 180 firmware function: MC SET MODE 
defw #07c0		;; 181 firmware function: MC SCREEN OFFSET
defw #0786		;; 182 firmware function: MC CLEAR INKS
defw #078c		;; 183 firmware function: MC SET INKS
defw #07e0		;; 184 firmware function: MC RESET PRINTER
defw #081b		;; 185 firmware function: MC PRINT CHAR
defw #0858		;; 186 firmware function: MC BUSY PRINTER
defw #0844		;; 187 firmware function: MC SEND PRINTER
defw #0863		;; 188 firmware function: MC SOUND REGISTER
defw #08bd		;; 189 firmware function: JUMP RESTORE
defw #1d3c		;; 190 firmware function: KM SET LOCKS
defw #1bfe		;; 191 firmware function: KM FLUSH
defw #1460		;; 192 firmware function: TXT ASK STATE
defw #15ec		;; 193 firmware function: GRA DEFAULT
defw #19d5		;; 194 firmware function: GRA SET BACK
defw #17b0		;; 195 firmware function: GRA SET FIRST
defw #17ac		;; 196 firmware function: GRA SET LINE MASK
defw #162a		;; 197 firmware function: GRA FROM USER
defw #19d9		;; 198 firmware function: GRA FILL
defw #0b45		;; 199 firmware function: SCR SET POSITION
defw #080c		;; 200 firmware function: MC PRINT TRANSLATION
defw #0397		;; 201 firmware function: KL BANK SWITCH
defw #2c02		;; 202 BD5E
defw #2f91		;; 0 BD61
defw #2f9f		;; 1 BD64
defw #2fc8		;; 2 BD67
defw #2fd9		;; 3 BD6A
defw #3001		;; 4 BD6D
defw #3014		;; 5 BD70
defw #3055		;; 6 BD73
defw #305f		;; 7 BD76
defw #30c6		;; 8 BD79
defw #34a2		;; 9 BD7C
defw #3159		;; 10 BD7F
defw #349e		;; 11 BD82
defw #3577		;; 12 BD85
defw #3604		;; 13 BD88
defw #3188		;; 14 BD8B
defw #36df		;; 15 BD8E
defw #3731		;; 16 BD91
defw #3727		;; 17 BD94
defw #3345		;; 18 BD97
defw #2f73		;; 19 BD9A
defw #32ac		;; 20 BD9D
defw #32af		;; 21 BDA0
defw #31b6		;; 22 BDA3
defw #31b1		;; 23 BDA6
defw #322f		;; 24 BDA9
defw #3353		;; 25 BDAC
defw #3349		;; 26 BDAF
defw #33c8		;; 27 BDB2
defw #33d8		;; 28 BDB5
defw #2fd1		;; 29 BDB8
defw #3136		;; 30 BDBB
defw #3143		;; 31 BDBE
;;==========================================================================
;; used to initialise the firmware indirections
;; this routine is called by each of the firmware "units"
;; i.e. screen pack, graphics pack etc.
;; HL = pointer to start of a table
;; table format:
;;
;; 0 = length of data 
;; 1,2 = destination to copy data
;; 3.. = data
lab0ab4: ld c,(hl) 
lab0ab5: ld b,#00 
lab0ab7: inc hl 
lab0ab8: ld e,(hl) 
lab0ab9: inc hl 
lab0aba: ld d,(hl) 
lab0abb: inc hl 
lab0abc: ldir 
lab0abe: ret 
;;===========================================================================
SCR_INITIALISE:
lab0abf: ld de,#1052			;; default colour palette 
lab0ac2: call #0786			;; MC CLEAR INKS 
lab0ac5: ld a,#c0 
lab0ac7: ld (#b7c6),a 
lab0aca: call #0ad0			;; SCR RESET 
lab0acd: jp #0b12 
;;===========================================================================
SCR_RESET:
lab0ad0: xor a 
lab0ad1: call #0c55			;; SCR ACCESS 
lab0ad4: ld hl,#0add			;; table used to initialise screen indirections 
lab0ad7: call #0ab4			;; initialise screen pack indirections 
lab0ada: jp #0cd8			;; restore colours and set default flashing 
lab0add: 
defb #09
defw #bde5
lab0ae0: jp #0c8a			;; IND: SCR READ 
lab0ae3: jp #0c71			;; IND: SCR WRITE 
lab0ae6: jp #0b17			;; IND: SCR MODE CLEAR 
;;===========================================================================
SCR_SET_MODE:
lab0ae9: and #03 
lab0aeb: cp #03 
lab0aed: ret nc 
lab0aee: push af 
lab0aef: call #0d55 
lab0af2: pop de 
lab0af3: call #10b3 
lab0af6: push af 
lab0af7: call #15ce 
lab0afa: push hl 
lab0afb: ld a,d 
lab0afc: call #0b31 
lab0aff: call #bdeb			; IND: SCR MODE CLEAR 
lab0b02: pop hl 
lab0b03: call #15ae 
lab0b06: pop af 
lab0b07: call #10d1 
lab0b0a: jr #0b2e ; (+#22) 
;;===========================================================================
SCR_GET_MODE:
lab0b0c: ld a,(#b7c3) 
lab0b0f: cp #01 
lab0b11: ret 
lab0b12: ld a,#01 
lab0b14: call #0b31 
;;===========================================================================
IND_SCR_MODE_CLEAR:
lab0b17: call #0d55 
lab0b1a: ld hl,#0000 
lab0b1d: call #0b37			;; SCR OFFSET 
lab0b20: ld hl,(#b7c5) 
lab0b23: ld l,#00 
lab0b25: ld d,h 
lab0b26: ld e,#01 
lab0b28: ld bc,#3fff 
lab0b2b: ld (hl),l 
lab0b2c: ldir 
lab0b2e: jp #0d42 
;;===========================================================================
lab0b31: ld (#b7c3),a 
lab0b34: jp #0776			; MC SET MODE 
;;===========================================================================
SCR_OFFSET:
lab0b37: ld a,(#b7c6) 
lab0b3a: jr #0b3f ; (+#03) 
;;===========================================================================
SCR_SET_BASE:
lab0b3c: ld hl,(#b7c4) 
lab0b3f: call #0b45			; SCR SET POSITION 
lab0b42: jp #07c0			; MC SCREEN OFFSET 
;;===========================================================================
SCR_SET_POSITION:
lab0b45: and #c0 
lab0b47: ld (#b7c6),a 
lab0b4a: push af 
lab0b4b: ld a,h 
lab0b4c: and #07 
lab0b4e: ld h,a 
lab0b4f: res 0,l 
lab0b51: ld (#b7c4),hl 
lab0b54: pop af 
lab0b55: ret 
;;===========================================================================
SCR_GET_LOCATION:
lab0b56: ld hl,(#b7c4) 
lab0b59: ld a,(#b7c6) 
lab0b5c: ret 
;;======================================================================================
SCR_CHAR_LIMITS:
lab0b5d: call #0b0c			;; SCR GET MODE 
lab0b60: ld bc,#1318			;; B = 19, C = 24 
lab0b63: ret c 
lab0b64: ld b,#27			;; 39 
lab0b66: ret z 
lab0b67: ld b,#4f			;; 79 
;; B = x limit-1
;; C = y limit-1
lab0b69: ret 
;;======================================================================================
SCR_CHAR_POSITION:
lab0b6a: push de 
lab0b6b: call #0b0c			;; SCR GET MODE 
lab0b6e: ld b,#04 
lab0b70: jr c,#0b77 ; (+#05) 
lab0b72: ld b,#02 
lab0b74: jr z,#0b77 ; (+#01) 
lab0b76: dec b 
lab0b77: push bc 
lab0b78: ld e,h 
lab0b79: ld d,#00 
lab0b7b: ld h,d 
lab0b7c: push de 
lab0b7d: ld d,h 
lab0b7e: ld e,l 
lab0b7f: add hl,hl 
lab0b80: add hl,hl 
lab0b81: add hl,de 
lab0b82: add hl,hl 
lab0b83: add hl,hl 
lab0b84: add hl,hl 
lab0b85: add hl,hl 
lab0b86: pop de 
lab0b87: add hl,de 
lab0b88: djnz #0b87 ; (-#03) 
lab0b8a: ld de,(#b7c4) 
lab0b8e: add hl,de 
lab0b8f: ld a,h 
lab0b90: and #07 
lab0b92: ld h,a 
lab0b93: ld a,(#b7c6) 
lab0b96: add a,h 
lab0b97: ld h,a 
lab0b98: pop bc 
lab0b99: pop de 
lab0b9a: ret 
lab0b9b: ld a,e 
lab0b9c: sub l 
lab0b9d: inc a 
lab0b9e: add a,a 
lab0b9f: add a,a 
lab0ba0: add a,a 
lab0ba1: ld e,a 
lab0ba2: ld a,d 
lab0ba3: sub h 
lab0ba4: inc a 
lab0ba5: ld d,a 
lab0ba6: call #0b6a			; SCR CHAR POSITION 
lab0ba9: xor a 
lab0baa: add a,d 
lab0bab: djnz #0baa ; (-#03) 
lab0bad: ld d,a 
lab0bae: ret 
;;======================================================================================
SCR_DOT_POSITION:
lab0baf: push de 
lab0bb0: ex de,hl 
lab0bb1: ld hl,#00c7 
lab0bb4: or a 
lab0bb5: sbc hl,de 
lab0bb7: ld a,l 
lab0bb8: and #07 
lab0bba: add a,a 
lab0bbb: add a,a 
lab0bbc: add a,a 
lab0bbd: ld c,a 
lab0bbe: ld a,l 
lab0bbf: and #f8 
lab0bc1: ld l,a 
lab0bc2: ld d,h 
lab0bc3: ld e,l 
lab0bc4: add hl,hl 
lab0bc5: add hl,hl 
lab0bc6: add hl,de 
lab0bc7: add hl,hl 
lab0bc8: pop de 
lab0bc9: push bc 
lab0bca: call #0bf6 
lab0bcd: ld a,b 
lab0bce: and e 
lab0bcf: jr z,#0bd6 ; (+#05) 
lab0bd1: rrc c 
lab0bd3: dec a 
lab0bd4: jr nz,#0bd1 ; (-#05) 
lab0bd6: ex (sp),hl 
lab0bd7: ld h,c 
lab0bd8: ld c,l 
lab0bd9: ex (sp),hl 
lab0bda: ld a,b 
lab0bdb: rrca 
lab0bdc: srl d 
lab0bde: rr e 
lab0be0: rrca 
lab0be1: jr c,#0bdc ; (-#07) 
lab0be3: add hl,de 
lab0be4: ld de,(#b7c4) 
lab0be8: add hl,de 
lab0be9: ld a,h 
lab0bea: and #07 
lab0bec: ld h,a 
lab0bed: ld a,(#b7c6) 
lab0bf0: add a,h 
lab0bf1: add a,c 
lab0bf2: ld h,a 
lab0bf3: pop de 
lab0bf4: ld c,d 
lab0bf5: ret 
;;---------------------------------------------------------------------
lab0bf6: call #0b0c			;; SCR GET MODE 
lab0bf9: ld bc,#01aa 
lab0bfc: ret c 
lab0bfd: ld bc,#0388 ; remove event from list 
lab0c00: ret z 
lab0c01: ld bc,#0780 
lab0c04: ret 
;;---------------------------------------------------------------------
;; firmware function: SCR NEXT BYTE
;;
;; Entry conditions:
;; HL = screen address
;; Exit conditions:
;; HL = updated screen address
;; AF corrupt
;;
;; Assumes:
;; - 16k screen
lab0c05: inc l 
lab0c06: ret nz 
lab0c07: inc h 
lab0c08: ld a,h 
lab0c09: and #07 
lab0c0b: ret nz 
;; at this point the address has incremented over a 2048
;; byte boundary.
;;
;; At this point, the next byte on screen is *not* previous byte plus 1.
;;
;; The following is true:
;; 07ff->0000  
;; 0Fff->0800 
;; 17ff->1000 
;; 1Fff->1800 
;; 27ff->2000 
;; 2Fff->2800 
;; 37ff->3000 
;; 3Fff->3800 
;;
;; The following code adjusts for this case.
lab0c0c: ld a,h 
lab0c0d: sub #08 
lab0c0f: ld h,a 
lab0c10: ret 
;;---------------------------------------------------------------------
;; firmware function: SCR PREV BYTE
;;
;; Entry conditions:
;; HL = screen address
;; Exit conditions:
;; HL = updated screen address
;; AF corrupt
;;
;; Assumes:
;; - 16k screen
lab0c11: ld a,l 
lab0c12: dec l 
lab0c13: or a 
lab0c14: ret nz 
lab0c15: ld a,h 
lab0c16: dec h 
lab0c17: and #07 
lab0c19: ret nz 
lab0c1a: ld a,h 
lab0c1b: add a,#08 
lab0c1d: ld h,a 
lab0c1e: ret 
;;---------------------------------------------------------------------
;; firmware function: SCR NEXT LINE
;;
;; Entry conditions:
;; HL = screen address
;; Exit conditions:
;; HL = updated screen address
;; AF corrupt
;;
;; Assumes:
;; - 16k screen
;; - 80 bytes per line (40 CRTC characters per line)
lab0c1f: ld a,h 
lab0c20: add a,#08 
lab0c22: ld h,a 
lab0c23: and #38 
lab0c25: ret nz 
;; 
lab0c26: ld a,h 
lab0c27: sub #40 
lab0c29: ld h,a 
lab0c2a: ld a,l 
lab0c2b: add a,#50			;; number of bytes per line 
lab0c2d: ld l,a 
lab0c2e: ret nc 
lab0c2f: inc h 
lab0c30: ld a,h 
lab0c31: and #07 
lab0c33: ret nz 
lab0c34: ld a,h 
lab0c35: sub #08 
lab0c37: ld h,a 
lab0c38: ret 
;;---------------------------------------------------------------------
;; firmware function: SCR PREV LINE
;;
;; Entry conditions:
;; HL = screen address
;; Exit conditions:
;; HL = updated screen address
;; AF corrupt
;;
;; Assumes:
;; - 16k screen
;; - 80 bytes per line (40 CRTC characters per line)
lab0c39: ld a,h 
lab0c3a: sub #08 
lab0c3c: ld h,a 
lab0c3d: and #38 
lab0c3f: cp #38 
lab0c41: ret nz 
lab0c42: ld a,h 
lab0c43: add a,#40 
lab0c45: ld h,a 
lab0c46: ld a,l 
lab0c47: sub #50				;; number of bytes per line 
lab0c49: ld l,a 
lab0c4a: ret nc 
lab0c4b: ld a,h 
lab0c4c: dec h 
lab0c4d: and #07 
lab0c4f: ret nz 
lab0c50: ld a,h 
lab0c51: add a,#08 
lab0c53: ld h,a 
lab0c54: ret 
;;============================================================================
SCR_ACCESS:
;;
;; A = write mode:
;; 0 -> fill
;; 1 -> xor
;; 2 -> and
;; 3 -> or
lab0c55: and #03 
lab0c57: ld hl,#0c74			; SCR PIXELS 
lab0c5a: jr z,#0c68 ; (+#0c) 
lab0c5c: cp #02 
lab0c5e: ld l,#7a 
lab0c60: jr c,#0c68 ; (+#06) 
lab0c62: ld l,#7f 
lab0c64: jr z,#0c68 ; (+#02) 
lab0c66: ld l,#85 
;; HL = address of screen write function 
;; initialise jump for IND: SCR WRITE
lab0c68: ld a,#c3 
lab0c6a: ld (#b7c7),a 
lab0c6d: ld (#b7c8),hl 
lab0c70: ret 
;;==================================================================================
IND_SCR_WRITE:
;; jump initialised by SCR ACCESS
lab0c71: jp #b7c7 
;;============================================================================
SCR_PIXELS:
;; (write mode fill)
lab0c74: ld a,b 
lab0c75: xor (hl) 
lab0c76: and c 
lab0c77: xor (hl) 
lab0c78: ld (hl),a 
lab0c79: ret 
;;----------------------------------------------------------------------------
;; screen write access mode
;; (write mode XOR)
lab0c7a: ld a,b 
lab0c7b: and c 
lab0c7c: xor (hl) 
lab0c7d: ld (hl),a 
lab0c7e: ret 
;;----------------------------------------------------------------------------
;; screen write access mode
;;
;; (write mode AND)
lab0c7f: ld a,c 
lab0c80: cpl 
lab0c81: or b 
lab0c82: and (hl) 
lab0c83: ld (hl),a 
lab0c84: ret 
;;----------------------------------------------------------------------------
;; screen write access mode
;;
;; (write mode OR)
lab0c85: ld a,b 
lab0c86: and c 
lab0c87: or (hl) 
lab0c88: ld (hl),a 
lab0c89: ret 
;;==================================================================================
IND_SCR_READ:
lab0c8a: ld a,(hl) 
lab0c8b: jp #0cb2 
;;==================================================================================
SCR_INK_ENCODE:
lab0c8e: push bc 
lab0c8f: push de 
lab0c90: call #0cc8 
lab0c93: ld e,a 
lab0c94: call #0bf6 
lab0c97: ld b,#08 
lab0c99: rrc e 
lab0c9b: rla 
lab0c9c: rrc c 
lab0c9e: jr c,#0ca2 ; (+#02) 
lab0ca0: rlc e 
lab0ca2: djnz #0c99 ; (-#0b) 
lab0ca4: pop de 
lab0ca5: pop bc 
lab0ca6: ret 
;;============================================================================
SCR_INK_DECODE:
lab0ca7: push bc 
lab0ca8: push af 
lab0ca9: call #0bf6 
lab0cac: pop af 
lab0cad: call #0cb2 
lab0cb0: pop bc 
lab0cb1: ret 
;;-----------------------------------------------------------------------------
lab0cb2: push de 
lab0cb3: ld de,#0008 
lab0cb6: rrca 
lab0cb7: rl d 
lab0cb9: rrc c 
lab0cbb: jr c,#0cbf ; (+#02) 
lab0cbd: rr d 
lab0cbf: dec e 
lab0cc0: jr nz,#0cb6 ; (-#0c) 
lab0cc2: ld a,d 
lab0cc3: call #0cc8 
lab0cc6: pop de 
lab0cc7: ret 
;;-----------------------------------------------------------------------------
lab0cc8: ld d,a 
lab0cc9: call #0b0c			;; SCR GET MODE 
lab0ccc: ld a,d 
lab0ccd: ret nc 
lab0cce: rrca 
lab0ccf: rrca 
lab0cd0: adc a,#00 
lab0cd2: rrca 
lab0cd3: sbc a,a 
lab0cd4: and #06 
lab0cd6: xor d 
lab0cd7: ret 
;;-----------------------------------------------------------------------------
;; restore colours and set default flashing
lab0cd8: ld hl,#1052					;; default colour palette 
lab0cdb: ld de,#b7d4 
lab0cde: ld bc,#0022 
lab0ce1: ldir 
lab0ce3: xor a 
lab0ce4: ld (#b7f6),a 
lab0ce7: ld hl,#0a0a 
;;============================================================================
SCR_SET_FLASHING:
lab0cea: ld (#b7d2),hl 
lab0ced: ret 
;;============================================================================
SCR_GET_FLASHING:
lab0cee: ld hl,(#b7d2) 
lab0cf1: ret 
;;============================================================================
SCR_SET_INK:
lab0cf2: and #0f ; keep pen within 0-15 range 
lab0cf4: inc a 
lab0cf5: jr #0cf8 
;;============================================================================
SCR_SET_BORDER:
lab0cf7: xor a 
;;----------------------------------------------------------------------------
SCR_SET_INK_SCR_SET_BORDER:
;;
;; A = internal pen number
;; B = ink 1 (firmware colour number)
;; C = ink 2 (firmware colour number)
;; 0 = border
;; 1 = colour 0
;; 2 = colour 1
;; ...
;; 16 = colour 15
lab0cf8: ld e,a 
lab0cf9: ld a,b 
lab0cfa: call #0d10		; lookup address of hardware colour number in conversion 
; table using software colour number
lab0cfd: ld b,(hl)		; get hardware colour number for ink 1 
lab0cfe: ld a,c 
lab0cff: call #0d10		; lookup address of hardware colour number in conversion 
; table using software colour number
lab0d02: ld c,(hl)		; get hardware colour number for ink 2 
lab0d03: ld a,e 
lab0d04: call #0d35		; get address of pen in both palette''s in RAM 
lab0d07: ld (hl),c		; write ink 2 
lab0d08: ex de,hl 
lab0d09: ld (hl),b		; write ink 1 
lab0d0a: ld a,#ff 
lab0d0c: ld (#b7f7),a 
lab0d0f: ret 
;;============================================================================
;; input:
;; A = software colour number
;; output:
;; HL = address of element in table. Element is corresponding hardware colour number.
lab0d10: and #1f 
lab0d12: add a,#99 
lab0d14: ld l,a 
lab0d15: adc a,#0d 
lab0d17: sub l 
lab0d18: ld h,a 
lab0d19: ret 
;;============================================================================
SCR_GET_INK:
lab0d1a: and #0f ; keep pen within range 0-15. 
lab0d1c: inc a 
lab0d1d: jr #0d20 
;;============================================================================
SCR_GET_BORDER:
lab0d1f: xor a 
;;----------------------------------------------------------------------------
SCR_GET_INK_SCR_GET_BORDER:
;; entry:
;; A = internal pen number
;; 0 = border
;; 1 = colour 0
;; 2 = colour 1
;; ...
;; 16 = colour 15
;; exit:
;; B = ink 1 (software colour number)
;; C = ink 2 (software colour number)
lab0d20: call #0d35			; get address of pen in both palette''s in RAM 
lab0d23: ld a,(de)			; ink 2 
lab0d24: ld e,(hl)			; ink 1 
lab0d25: call #0d2a			; lookup hardware colour number for ink 2 
lab0d28: ld b,c 
;; lookup hardware colour number for ink 1
lab0d29: ld a,e 
;;----------------------------------------------------------------------------
;; lookup software colour number which corresponds to the hardware colour number
;; entry:
;; A = hardware colour number
;; exit:
;; C = index in table (same as software colour number)
lab0d2a: ld c,#00 
lab0d2c: ld hl,#0d99			; table to convert from software colour 
; number to hardware colour number
;;----------
lab0d2f: cp (hl)				; same as this entry in the table? 
lab0d30: ret z				; zero set if entry is the same, zero clear if entry is different 
lab0d31: inc hl 
lab0d32: inc c 
lab0d33: jr #0d2f 
;;============================================================================
;;
;; The firmware stores two palette''s in RAM, this allows a pen to have a flashing ink.
;;
;; get address of palette entry for corresponding ink for both palettes in RAM.
;;
;; entry:
;; A = pen number
;; 0 = border
;; 1 = colour 0
;; 2 = colour 1
;; ...
;; 16 = colour 15
;; 
;; exit:
;; HL = address of element in palette 2
;; DE = address of element in palette 1
lab0d35: ld e,a 
lab0d36: ld d,#00 
lab0d38: ld hl,#b7e5			; palette 2 start 
lab0d3b: add hl,de 
lab0d3c: ex de,hl 
lab0d3d: ld hl,#ffef			; palette 1 start (B7D4) 
lab0d40: add hl,de 
lab0d41: ret 
;;============================================================================
lab0d42: ld hl,#b7f9 
lab0d45: push hl 
lab0d46: call #0170			; KL DEL FRAME FLY 
lab0d49: call #0d73 
lab0d4c: ld de,#0d61 
lab0d4f: ld b,#81 
lab0d51: pop hl 
lab0d52: jp #0163			; KL NEW FRAME FLY 
;;==================================================================================
lab0d55: ld hl,#b7f9 
lab0d58: call #0170			; KL DEL FRAME FLY 
lab0d5b: call #0d87 
lab0d5e: jp #0786			; MC CLEAR INKS 
;;---------------------------------------------------------
;; frame flyback routine for changing colours
lab0d61: ld hl,#b7f8 
lab0d64: dec (hl) 
lab0d65: jr z,#0d73 ; (+#0c) 
lab0d67: dec hl 
lab0d68: ld a,(hl) 
lab0d69: or a 
lab0d6a: ret z 
lab0d6b: call #0d87 
lab0d6e: call #078c			; MC SET INKS 
lab0d71: jr #0d82 ; (+#0f) 
;;==================================================================================
lab0d73: call #0d87 
lab0d76: ld (#b7f8),a 
lab0d79: call #078c			; MC SET INKS 
lab0d7c: ld hl,#b7f6 
lab0d7f: ld a,(hl) 
lab0d80: cpl 
lab0d81: ld (hl),a 
lab0d82: xor a 
lab0d83: ld (#b7f7),a 
lab0d86: ret 
;;===========================================================================
lab0d87: ld de,#b7e5 
lab0d8a: ld a,(#b7f6) 
lab0d8d: or a 
lab0d8e: ld a,(#b7d3) 
lab0d91: ret z 
;;===========================================================================
lab0d92: ld de,#b7d4 
lab0d95: ld a,(#b7d2) 
lab0d98: ret 
;;---------------------------------------------------------------------------
;; table to convert from software colour number to hardware colour number
lab0d99: 
defb #14,#04,#15,#1c,#18,#1d,#0c,#05,#0d,#16,#06,#17,#1e,#00,#1f,#0e,#07,#0f
defb #12,#02,#13,#1a,#19,#1b,#0a,#03,#0b,#01,#08,#09,#10,#11
;;============================================================================
SCR_FILL_BOX:
lab0db9: ld c,a 
lab0dba: call #0b9b 
;;============================================================================
SCR_FLOOD_BOX:
lab0dbd: push hl 
lab0dbe: ld a,d 
lab0dbf: call #0eee 
lab0dc2: jr nc,#0dcd ; (+#09) 
lab0dc4: ld b,d 
lab0dc5: ld (hl),c 
lab0dc6: call #0c05			; SCR NEXT BYTE 
lab0dc9: djnz #0dc5 ; (-#06) 
lab0dcb: jr #0ddd ; (+#10) 
lab0dcd: push bc 
lab0dce: push de 
lab0dcf: ld (hl),c 
lab0dd0: dec d 
lab0dd1: jr z,#0ddb ; (+#08) 
lab0dd3: ld c,d 
lab0dd4: ld b,#00 
lab0dd6: ld d,h 
lab0dd7: ld e,l 
lab0dd8: inc de 
lab0dd9: ldir 
lab0ddb: pop de 
lab0ddc: pop bc 
lab0ddd: pop hl 
lab0dde: call #0c1f			; SCR NEXT LINE 
lab0de1: dec e 
lab0de2: jr nz,#0dbd ; (-#27) 
lab0de4: ret 
;;============================================================================
SCR_CHAR_INVERT:
lab0de5: ld a,b 
lab0de6: xor c 
lab0de7: ld c,a 
lab0de8: call #0b6a			; SCR CHAR POSITION 
lab0deb: ld d,#08 
lab0ded: push hl 
lab0dee: push bc 
lab0def: ld a,(hl) 
lab0df0: xor c 
lab0df1: ld (hl),a 
lab0df2: call #0c05			; SCR NEXT BYTE 
lab0df5: djnz #0def ; (-#08) 
lab0df7: pop bc 
lab0df8: pop hl 
lab0df9: call #0c1f			; SCR NEXT LINE 
lab0dfc: dec d 
lab0dfd: jr nz,#0ded ; (-#12) 
lab0dff: ret 
;;============================================================================
SCR_HW_ROLL:
lab0e00: ld c,a 
lab0e01: push bc 
lab0e02: ld de,#ffd0 
lab0e05: ld b,#30 
lab0e07: call #0e2a 
lab0e0a: pop bc 
lab0e0b: call #07b4			; MC WAIT FLYBACK 
lab0e0e: ld a,b 
lab0e0f: or a 
lab0e10: jr nz,#0e1f ; (+#0d) 
lab0e12: ld de,#ffb0 
lab0e15: call #0e3d 
lab0e18: ld de,#0000 
lab0e1b: ld b,#20 
lab0e1d: jr #0e2a ; (+#0b) 
lab0e1f: ld de,#0050 
lab0e22: call #0e3d 
lab0e25: ld de,#ffb0 
lab0e28: ld b,#20 
lab0e2a: ld hl,(#b7c4) 
lab0e2d: add hl,de 
lab0e2e: ld a,h 
lab0e2f: and #07 
lab0e31: ld h,a 
lab0e32: ld a,(#b7c6) 
lab0e35: add a,h 
lab0e36: ld h,a 
lab0e37: ld d,b 
lab0e38: ld e,#08 
lab0e3a: jp #0dbd			;; SCR FLOOD BOX 
lab0e3d: ld hl,(#b7c4) 
lab0e40: add hl,de 
lab0e41: jp #0b37			;; SCR OFFSET 
;;============================================================================
SCR_SW_ROLL:
lab0e44: push af 
lab0e45: ld a,b 
lab0e46: or a 
lab0e47: jr z,#0e79 ; (+#30) 
lab0e49: push hl 
lab0e4a: call #0b9b 
lab0e4d: ex (sp),hl 
lab0e4e: inc l 
lab0e4f: call #0b6a			; SCR CHAR POSITION 
lab0e52: ld c,d 
lab0e53: ld a,e 
lab0e54: sub #08 
lab0e56: ld b,a 
lab0e57: jr z,#0e70 ; (+#17) 
lab0e59: pop de 
lab0e5a: call #07b4			; MC WAIT FLYBACK 
lab0e5d: push bc 
lab0e5e: push hl 
lab0e5f: push de 
lab0e60: call #0eaa 
lab0e63: pop hl 
lab0e64: call #0c1f			; SCR NEXT LINE 
lab0e67: ex de,hl 
lab0e68: pop hl 
lab0e69: call #0c1f			; SCR NEXT LINE 
lab0e6c: pop bc 
lab0e6d: djnz #0e5d ; (-#12) 
lab0e6f: push de 
lab0e70: pop hl 
lab0e71: ld d,c 
lab0e72: ld e,#08 
lab0e74: pop af 
lab0e75: ld c,a 
lab0e76: jp #0dbd			;; SCR FLOOD BOX 
lab0e79: push hl 
lab0e7a: push de 
lab0e7b: call #0b9b 
lab0e7e: ld c,d 
lab0e7f: ld a,e 
lab0e80: sub #08 
lab0e82: ld b,a 
lab0e83: pop de 
lab0e84: ex (sp),hl 
lab0e85: jr z,#0e70 ; (-#17) 
lab0e87: push bc 
lab0e88: ld l,e 
lab0e89: ld d,h 
lab0e8a: inc e 
lab0e8b: call #0b6a			; SCR CHAR POSITION 
lab0e8e: ex de,hl 
lab0e8f: call #0b6a			; SCR CHAR POSITION 
lab0e92: pop bc 
lab0e93: call #07b4			; MC WAIT FLYBACK 
lab0e96: call #0c39			; SCR PREV LINE 
lab0e99: push hl 
lab0e9a: ex de,hl 
lab0e9b: call #0c39			; SCR PREV LINE 
lab0e9e: push hl 
lab0e9f: push bc 
lab0ea0: call #0eaa 
lab0ea3: pop bc 
lab0ea4: pop de 
lab0ea5: pop hl 
lab0ea6: djnz #0e96 ; (-#12) 
lab0ea8: jr #0e70 ; (-#3a) 
lab0eaa: ld b,#00 
lab0eac: call #0eec 
lab0eaf: jr c,#0ec7 ; (+#16) 
lab0eb1: call #0eec 
lab0eb4: jr nc,#0edb ; (+#25) 
lab0eb6: push bc 
lab0eb7: xor a 
lab0eb8: sub l 
lab0eb9: ld c,a 
lab0eba: ldir 
lab0ebc: pop bc 
lab0ebd: cpl 
lab0ebe: inc a 
lab0ebf: add a,c 
lab0ec0: ld c,a 
lab0ec1: ld a,h 
lab0ec2: sub #08 
lab0ec4: ld h,a 
lab0ec5: jr #0edb ; (+#14) 
lab0ec7: call #0eec 
lab0eca: jr c,#0ede ; (+#12) 
lab0ecc: push bc 
lab0ecd: xor a 
lab0ece: sub e 
lab0ecf: ld c,a 
lab0ed0: ldir 
lab0ed2: pop bc 
lab0ed3: cpl 
lab0ed4: inc a 
lab0ed5: add a,c 
lab0ed6: ld c,a 
lab0ed7: ld a,d 
lab0ed8: sub #08 
lab0eda: ld d,a 
lab0edb: ldir 
lab0edd: ret 
lab0ede: ld b,c 
lab0edf: ld a,(hl) 
lab0ee0: ld (de),a 
lab0ee1: call #0c05			; SCR NEXT BYTE 
lab0ee4: ex de,hl 
lab0ee5: call #0c05			; SCR NEXT BYTE 
lab0ee8: ex de,hl 
lab0ee9: djnz #0edf 
lab0eeb: ret 
;;============================================================================
lab0eec: ld a,c 
lab0eed: ex de,hl 
lab0eee: dec a 
lab0eef: add a,l 
lab0ef0: ret nc 
lab0ef1: ld a,h 
lab0ef2: and #07 
lab0ef4: xor #07 
lab0ef6: ret nz 
lab0ef7: scf 
lab0ef8: ret 
;;============================================================================
SCR_UNPACK:
lab0ef9: call #0b0c			;; SCR GET MODE 
lab0efc: jr c,#0f0b ; mode 0 
lab0efe: jr z,#0f06 ; mode 1 
lab0f00: ld bc,#0008 
lab0f03: ldir 
lab0f05: ret 
;;-----------------------------------------------------------------------------
;; SCR UNPACK: mode 1
lab0f06: ld bc,#0288 
lab0f09: jr #0f0e ; 0x088 is the pixel mask 
;;-----------------------------------------------------------------------------
;; SCR UNPACK: mode 0
lab0f0b: ld bc,#04aa ;; 0x0aa is the pixel mask 
;;-----------------------------------------------------------------------------
;; routine used by mode 0 and mode 1 for SCR UNPACK
lab0f0e: ld a,#08 
lab0f10: push af 
lab0f11: push hl 
lab0f12: ld l,(hl) 
lab0f13: ld h,b 
lab0f14: xor a 
lab0f15: rlc l 
lab0f17: jr nc,#0f1a ; (+#01) 
lab0f19: or c 
lab0f1a: rrc c 
lab0f1c: jr nc,#0f15 ; (-#09) 
lab0f1e: ld (de),a 
lab0f1f: inc de 
lab0f20: djnz #0f14 ; (-#0e) 
lab0f22: ld b,h 
lab0f23: pop hl 
lab0f24: inc hl 
lab0f25: pop af 
lab0f26: dec a 
lab0f27: jr nz,#0f10 ; (-#19) 
lab0f29: ret 
;;============================================================================
SCR_REPACK:
lab0f2a: ld c,a 
lab0f2b: call #0b6a			; SCR CHAR POSITION 
lab0f2e: call #0b0c			; SCR GET MODE 
lab0f31: ld b,#08 
lab0f33: jr c,#0f6b ; mode 0 
lab0f35: jr z,#0f42 ; mode 1 
;;----------------------------------------------------------------------------------------
;; SCR REPACK: mode 2
lab0f37: ld a,(hl) 
lab0f38: xor c 
lab0f39: cpl 
lab0f3a: ld (de),a 
lab0f3b: inc de 
lab0f3c: call #0c1f			; SCR NEXT LINE 
lab0f3f: djnz #0f37 
lab0f41: ret 
;;----------------------------------------------------------------------------------------
;; SCR REPACK: mode 1
lab0f42: push bc 
lab0f43: push hl 
lab0f44: push de 
lab0f45: call #0f5a ; mode 1 
lab0f48: call #0c05			; SCR NEXT BYTE 
lab0f4b: call #0f5a ; mode 1 
lab0f4e: ld a,e 
lab0f4f: pop de 
lab0f50: ld (de),a 
lab0f51: inc de 
lab0f52: pop hl 
lab0f53: call #0c1f			; SCR NEXT LINE 
lab0f56: pop bc 
lab0f57: djnz #0f42 
lab0f59: ret 
;;----------------------------------------------------------------------------------------
;; SCR REPACK: mode 1 (part)
lab0f5a: ld d,#88 ; pixel mask 
lab0f5c: ld b,#04 
lab0f5e: ld a,(hl) 
lab0f5f: xor c 
lab0f60: and d 
lab0f61: jr nz,#0f64 ; (+#01) 
lab0f63: scf 
lab0f64: rl e 
lab0f66: rrc d 
lab0f68: djnz #0f5e 
lab0f6a: ret 
;;----------------------------------------------------------------------------------------
;; SCR REPACK: mode 0
lab0f6b: push bc 
lab0f6c: push hl 
lab0f6d: push de 
lab0f6e: ld b,#04 
lab0f70: ld a,(hl) 
lab0f71: xor c 
lab0f72: and #aa ; left pixel mask 
lab0f74: jr nz,#0f77 
lab0f76: scf 
lab0f77: rl e 
lab0f79: ld a,(hl) 
lab0f7a: xor c 
lab0f7b: and #55 ; right pixel mask 
lab0f7d: jr nz,#0f80 
lab0f7f: scf 
lab0f80: rl e 
lab0f82: call #0c05			; SCR NEXT BYTE 
lab0f85: djnz #0f70 
lab0f87: ld a,e 
lab0f88: pop de 
lab0f89: ld (de),a 
lab0f8a: inc de 
lab0f8b: pop hl 
lab0f8c: call #0c1f			; SCR NEXT LINE 
lab0f8f: pop bc 
lab0f90: djnz #0f6b 
lab0f92: ret 
;;============================================================================
SOUND_ARM_EVENT1:
lab0f93: call #0fad 
lab0f96: call #0fc2 
lab0f99: jr #0fa1 ; (+#06) 
;;============================================================================
SCR_VERTICAL:
lab0f9b: call #0fad 
lab0f9e: call #1016 
lab0fa1: ld hl,(#b802) 
lab0fa4: ld a,l 
lab0fa5: ld (#b6a3),a		; graphics pen 
lab0fa8: ld a,h 
lab0fa9: ld (#b6b3),a		; graphics line mask 
lab0fac: ret 
;;============================================================================
lab0fad: push hl 
lab0fae: ld hl,(#b6a3)		; L = graphics pen, H = graphics paper 
lab0fb1: ld (#b6a3),a		; graphics pen 
lab0fb4: ld a,(#b6b3)		; graphics line mask 
lab0fb7: ld h,a 
lab0fb8: ld a,#ff 
lab0fba: ld (#b6b3),a		; graphics line mask 
lab0fbd: ld (#b802),hl 
lab0fc0: pop hl 
lab0fc1: ret 
lab0fc2: scf 
lab0fc3: call #103b 
lab0fc6: rlc b 
lab0fc8: ld a,c 
lab0fc9: jr nc,#0fde ; (+#13) 
lab0fcb: dec e 
lab0fcc: jr nz,#0fd1 ; (+#03) 
lab0fce: dec d 
lab0fcf: jr z,#0ffd ; (+#2c) 
lab0fd1: rrc c 
lab0fd3: jr c,#0ffd ; (+#28) 
lab0fd5: bit 7,b 
lab0fd7: jr z,#0ffd ; (+#24) 
lab0fd9: or c 
lab0fda: rlc b 
lab0fdc: jr #0fcb ; (-#13) 
lab0fde: dec e 
lab0fdf: jr nz,#0fe4 ; (+#03) 
lab0fe1: dec d 
lab0fe2: jr z,#0ff1 ; (+#0d) 
lab0fe4: rrc c 
lab0fe6: jr c,#0ff1 ; (+#09) 
lab0fe8: bit 7,b 
lab0fea: jr nz,#0ff1 ; (+#05) 
lab0fec: or c 
lab0fed: rlc b 
lab0fef: jr #0fde ; (-#13) 
lab0ff1: push bc 
lab0ff2: ld c,a 
lab0ff3: ld a,(#b6a4)		; graphics paper 
lab0ff6: ld b,a 
lab0ff7: ld a,(#b6b4) 
lab0ffa: or a 
lab0ffb: jr #1004 ; (+#07) 
lab0ffd: push bc 
lab0ffe: ld c,a 
lab0fff: ld a,(#b6a3)		; graphics pen 
lab1002: ld b,a 
lab1003: xor a 
lab1004: call z,#bde8			; IND: SCR WRITE 
lab1007: pop bc 
lab1008: bit 7,c 
lab100a: call nz,#0c05			; SCR NEXT BYTE 
lab100d: ld a,d 
lab100e: or e 
lab100f: jr nz,#0fc6 ; (-#4b) 
lab1011: ld a,b 
lab1012: ld (#b6b3),a		; graphics line mask 
lab1015: ret 
lab1016: or a 
lab1017: call #103b 
lab101a: rlc b 
lab101c: ld a,(#b6a3)		; graphics pen 
lab101f: jr c,#102a ; (+#09) 
lab1021: ld a,(#b6b4) 
lab1024: or a 
lab1025: jr nz,#1030 ; (+#09) 
lab1027: ld a,(#b6a4)		; graphics paper 
lab102a: push bc 
lab102b: ld b,a 
lab102c: call #bde8			; IND: SCR WRITE 
lab102f: pop bc 
lab1030: call #0c39			; SCR PREV LINE 
lab1033: dec e 
lab1034: jr nz,#101a ; (-#1c) 
lab1036: dec d 
lab1037: jr nz,#101a ; (-#1f) 
lab1039: jr #1011 ; (-#2a) 
lab103b: push hl 
lab103c: jr nc,#1040 ; (+#02) 
lab103e: ld h,d 
lab103f: ld l,e 
lab1040: or a 
lab1041: sbc hl,bc 
lab1043: call #1939			; HL = -HL 
lab1046: inc h 
lab1047: inc l 
lab1048: ex (sp),hl 
lab1049: call #0baf			; SCR DOT POSITION 
lab104c: ld a,(#b6b3)		; graphics line mask 
lab104f: ld b,a 
lab1050: pop de 
lab1051: ret 
;;---------------------------------------------------------------------------
;; default colour palette
;; uses hardware colour numbers
;; 
;; There are two palettes here; so that flashing colours can be defined.
lab1052: 
defb #04,#04,#0a,#13,#0c,#0b,#14,#15,#0d,#06,#1e,#1f,#07,#12,#19,#04,#17
defb #04,#04,#0a,#13,#0c,#0b,#14,#15,#0d,#06,#1e,#1f,#07,#12,#19,#0a,#07
;;===========================================================================
TXT_INITIALISE:
lab1074: call #1084			;; TXT RESET 
lab1077: xor a 
lab1078: ld (#b735),a 
lab107b: ld hl,#0001 
lab107e: call #1139 
lab1081: jp #109f 
;;===========================================================================
TXT_RESET:
lab1084: ld hl,#108d			;; table used to initialise text vdu indirections 
lab1087: call #0ab4			;; initialise text vdu indirections 
lab108a: jp #1464			;; initialise control code handler functions 
lab108d: 
defb #f
defw #bdcd
lab1090: jp		#125f							;; IND: TXT DRAW CURSOR 
lab1093: jp #125f							;; IND: TXT UNDRAW CURSOR 
lab1096: jp #134b							;; IND: TXT WRITE CHAR 
lab1099: jp #13be							;; IND: TXT UNWRITE 
lab109C: jp #140a							;; IND: TXT OUT ACTION 
;;===========================================================================
lab109f: ld a,#08 
lab10a1: ld de,#b6b6 
lab10a4: ld hl,#b726 
lab10a7: ld bc,#000e 
lab10aa: ldir 
lab10ac: dec a 
lab10ad: jr nz,#10a4 ; (-#0b) 
lab10af: ld (#b6b5),a 
lab10b2: ret 
;;==================================================================================
lab10b3: ld a,(#b6b5) 
lab10b6: ld c,a 
lab10b7: ld b,#08 
lab10b9: ld a,b 
lab10ba: dec a 
lab10bb: call #10e4			; TXT STR SELECT 
lab10be: call #bdd0			; IND: TXT UNDRAW CURSOR 
lab10c1: call #12c0			; TXT GET PAPER 
lab10c4: ld (#b730),a 
lab10c7: call #12ba			; TXT GET PEN 
lab10ca: ld (#b72f),a 
lab10cd: djnz #10b9 ; (-#16) 
lab10cf: ld a,c 
lab10d0: ret 
;;==================================================================================
lab10d1: ld c,a 
lab10d2: ld b,#08 
lab10d4: ld a,b 
lab10d5: dec a 
lab10d6: call #10e4			; TXT STR SELECT 
lab10d9: push bc 
lab10da: ld hl,(#b72f) 
lab10dd: call #1139 
lab10e0: pop bc 
lab10e1: djnz #10d4 ; (-#0f) 
lab10e3: ld a,c 
;;==================================================================================
TXT_STR_SELECT:
lab10e4: and #07 
lab10e6: ld hl,#b6b5 
lab10e9: cp (hl) 
lab10ea: ret z 
lab10eb: push bc 
lab10ec: push de 
lab10ed: ld c,(hl) 
lab10ee: ld (hl),a 
lab10ef: ld b,a 
lab10f0: ld a,c 
lab10f1: call #1126 
lab10f4: call #111e 
lab10f7: ld a,b 
lab10f8: call #1126 
lab10fb: ex de,hl 
lab10fc: call #111e 
lab10ff: ld a,c 
lab1100: pop de 
lab1101: pop bc 
lab1102: ret 
;;===========================================================================
TXT_SWAP_STREAMS:
lab1103: ld a,(#b6b5) 
lab1106: push af 
lab1107: ld a,c 
lab1108: call #10e4 
lab110b: ld a,b 
lab110c: ld (#b6b5),a 
lab110f: call #1126 
lab1112: push de 
lab1113: ld a,c 
lab1114: call #1126 
lab1117: pop hl 
lab1118: call #111e 
lab111b: pop af 
lab111c: jr #10e4 ; (-#3a) 
;;===========================================================================
lab111e: push bc 
lab111f: ld bc,#000e 
lab1122: ldir 
lab1124: pop bc 
lab1125: ret 
;;===========================================================================
lab1126: and #07 
lab1128: ld e,a 
lab1129: add a,a 
lab112a: add a,e 
lab112b: add a,a 
lab112c: add a,e 
lab112d: add a,a 
lab112e: add a,#b6 
lab1130: ld e,a 
lab1131: adc a,#b6 
lab1133: sub e 
lab1134: ld d,a 
lab1135: ld hl,#b726 
lab1138: ret 
;;===========================================================================
lab1139: ex de,hl 
lab113a: ld a,#83 
lab113c: ld (#b72e),a 
lab113f: ld a,d 
lab1140: call #12ab			; TXT SET PAPER 
lab1143: ld a,e 
lab1144: call #12a6			; TXT SET PEN 
lab1147: xor a 
lab1148: call #13a8			; TXT SET GRAPHIC 
lab114b: call #137b			; TXT SET BACK 
lab114e: ld hl,#0000 
lab1151: ld de,#7f7f 
lab1154: call #1208			; TXT WIN ENABLE 
lab1157: jp #1459			; TXT VDU ENABLE 
;;===========================================================================
TXT_SET_COLUMN:
lab115a: dec a 
lab115b: ld hl,#b72a 
lab115e: add a,(hl) 
lab115f: ld hl,(#b726) 
lab1162: ld h,a 
lab1163: jr #1173 ;; undraw cursor, set cursor position and draw it 
;;===========================================================================
TXT_SET_ROW:
lab1165: dec a 
lab1166: ld hl,#b729 
lab1169: add a,(hl) 
lab116a: ld hl,(#b726) 
lab116d: ld l,a 
lab116e: jr #1173 ;; undraw cursor, set cursor position and draw it 
;;===========================================================================
TXT_SET_CURSOR:
lab1170: call #1186 
;; undraw cursor, set cursor position and draw it
lab1173: call #bdd0			; IND: TXT UNDRAW CURSOR 
;; set cursor position and draw it
lab1176: ld (#b726),hl 
lab1179: jp #bdcd			; IND: TXT DRAW CURSOR 
;;===========================================================================
TXT_GET_CURSOR:
lab117c: ld hl,(#b726) 
lab117f: call #1193 
lab1182: ld a,(#b72d) 
lab1185: ret 
;;===========================================================================
lab1186: ld a,(#b729) 
lab1189: dec a 
lab118a: add a,l 
lab118b: ld l,a 
lab118c: ld a,(#b72a) 
lab118f: dec a 
lab1190: add a,h 
lab1191: ld h,a 
lab1192: ret 
;;====================================================================
lab1193: ld a,(#b729) 
lab1196: sub l 
lab1197: cpl 
lab1198: inc a 
lab1199: inc a 
lab119a: ld l,a 
lab119b: ld a,(#b72a) 
lab119e: sub h 
lab119f: cpl 
lab11a0: inc a 
lab11a1: inc a 
lab11a2: ld h,a 
lab11a3: ret 
;;====================================================================
lab11a4: call #bdd0				;; IND: TXT UNDRAW CURSOR 
;;--------------------------------------------------------------------
lab11a7: ld hl,(#b726) 
lab11aa: call #11d6 
lab11ad: ld (#b726),hl 
lab11b0: ret c 
lab11b1: push hl 
lab11b2: ld hl,#b72d 
lab11b5: ld a,b 
lab11b6: add a,a 
lab11b7: inc a 
lab11b8: add a,(hl) 
lab11b9: ld (hl),a 
lab11ba: call #1252				;; TXT GET WINDOW 
lab11bd: ld a,(#b730) 
lab11c0: push af 
lab11c1: call c,#0e44				;; SCR SW ROLL 
lab11c4: pop af 
lab11c5: call nc,#0e00				;; SCR HW ROLL 
lab11c8: pop hl 
lab11c9: ret 
;;===========================================================================
TXT_VALIDATE:
lab11ca: call #1186 
lab11cd: call #11d6 
lab11d0: push af 
lab11d1: call #1193 
lab11d4: pop af 
lab11d5: ret 
;;===========================================================================
lab11d6: ld a,(#b72c) 
lab11d9: cp h 
lab11da: jp p,#11e2 
lab11dd: ld a,(#b72a) 
lab11e0: ld h,a 
lab11e1: inc l 
lab11e2: ld a,(#b72a) 
lab11e5: dec a 
lab11e6: cp h 
lab11e7: jp m,#11ef 
lab11ea: ld a,(#b72c) 
lab11ed: ld h,a 
lab11ee: dec l 
lab11ef: ld a,(#b729) 
lab11f2: dec a 
lab11f3: cp l 
lab11f4: jp p,#1202 
lab11f7: ld a,(#b72b) 
lab11fa: cp l 
lab11fb: scf 
lab11fc: ret p 
lab11fd: ld l,a 
lab11fe: ld b,#ff 
lab1200: or a 
lab1201: ret 
;;===========================================================================
lab1202: inc a 
lab1203: ld l,a 
lab1204: ld b,#00 
lab1206: or a 
lab1207: ret 
;;===========================================================================
TXT_WIN_ENABLE:
lab1208: call #0b5d			;; SCR CHAR LIMITS 
lab120b: ld a,h 
lab120c: call #1240 
lab120f: ld h,a 
lab1210: ld a,d 
lab1211: call #1240 
lab1214: ld d,a 
lab1215: cp h 
lab1216: jr nc,#121a ; (+#02) 
lab1218: ld d,h 
lab1219: ld h,a 
lab121a: ld a,l 
lab121b: call #1249 
lab121e: ld l,a 
lab121f: ld a,e 
lab1220: call #1249 
lab1223: ld e,a 
lab1224: cp l 
lab1225: jr nc,#1229 ; (+#02) 
lab1227: ld e,l 
lab1228: ld l,a 
lab1229: ld (#b729),hl 
lab122c: ld (#b72b),de 
lab1230: ld a,h 
lab1231: or l 
lab1232: jr nz,#123a ; (+#06) 
lab1234: ld a,d 
lab1235: xor b 
lab1236: jr nz,#123a ; (+#02) 
lab1238: ld a,e 
lab1239: xor c 
lab123a: ld (#b728),a 
lab123d: jp #1173			;; undraw cursor, set cursor position and draw it 
;;===========================================================================
lab1240: or a 
lab1241: jp p,#1245 
lab1244: xor a 
lab1245: cp b 
lab1246: ret c 
lab1247: ld a,b 
lab1248: ret 
lab1249: or a 
lab124a: jp p,#124e 
lab124d: xor a 
lab124e: cp c 
lab124f: ret c 
lab1250: ld a,c 
lab1251: ret 
;;===========================================================================
TXT_GET_WINDOW:
lab1252: ld hl,(#b729) 
lab1255: ld de,(#b72b) 
lab1259: ld a,(#b728) 
lab125c: add a,#ff 
lab125e: ret 
;;===========================================================================
IND_TXT_UNDRAW_CURSOR:
lab125f: ld a,(#b72e) 
lab1262: and #03 
lab1264: ret nz 
;;===========================================================================
TXT_PLACE_CURSOR:
TXT_REMOVE_CURSOR:
lab1265: push bc 
lab1266: push de 
lab1267: push hl 
lab1268: call #11a7 
lab126b: ld bc,(#b72f) 
lab126f: call #0de5				;; SCR CHAR INVERT 
lab1272: pop hl 
lab1273: pop de 
lab1274: pop bc 
lab1275: ret 
;;===========================================================================
TXT_CUR_ON:
lab1276: push af 
lab1277: ld a,#fd 
lab1279: call #1288 
lab127c: pop af 
lab127d: ret 
;;===========================================================================
TXT_CUR_OFF:
lab127e: push af 
lab127f: ld a,#02 
lab1281: call #1299 
lab1284: pop af 
lab1285: ret 
;;===========================================================================
TXT_CUR_ENABLE:
lab1286: ld a,#fe 
;;---------------------------------------------------------------------------
lab1288: push af 
lab1289: call #bdd0				;; IND: TXT UNDRAW CURSOR 
lab128c: pop af 
lab128d: push hl 
lab128e: ld hl,#b72e 
lab1291: and (hl) 
lab1292: ld (hl),a 
lab1293: pop hl 
lab1294: jp #bdcd				;; IND: TXT DRAW CURSOR 
;;===========================================================================
TXT_CUR_DISABLE:
lab1297: ld a,#01 
;;---------------------------------------------------------------------------
lab1299: push af 
lab129a: call #bdd0				;; IND: TXT UNDRAW CURSOR 
lab129d: pop af 
lab129e: push hl 
lab129f: ld hl,#b72e 
lab12a2: or (hl) 
lab12a3: ld (hl),a 
lab12a4: pop hl 
lab12a5: ret 
;;===========================================================================
TXT_SET_PEN:
lab12a6: ld hl,#b72f 
lab12a9: jr #12ae ; (+#03) 
;;===========================================================================
TXT_SET_PAPER:
lab12ab: ld hl,#b730 
;;---------------------------------------------------------------------------
lab12ae: push af 
lab12af: call #bdd0				;; IND: TXT UNDRAW CURSOR 
lab12b2: pop af 
lab12b3: call #0c8e				;; SCR INK ENCODE 
lab12b6: ld (hl),a 
lab12b7: jp #bdcd				;; IND: TXT DRAW CURSOR 
;;===========================================================================
TXT_GET_PEN:
lab12ba: ld a,(#b72f) 
lab12bd: jp #0ca7			; SCR INK DECODE 
;;===========================================================================
TXT_GET_PAPER:
lab12c0: ld a,(#b730) 
lab12c3: jp #0ca7			; SCR INK DECODE 
;;===========================================================================
TXT_INVERSE:
lab12c6: call #bdd0				;; IND: TXT UNDRAW CURSOR 
lab12c9: ld hl,(#b72f) 
lab12cc: ld a,h 
lab12cd: ld h,l 
lab12ce: ld l,a 
lab12cf: ld (#b72f),hl 
lab12d2: jr #12b7 ; (-#1d) 
;;===========================================================================
TXT_GET_MATRIX:
lab12d4: push de 
lab12d5: ld e,a 
lab12d6: call #132b			; TXT GET M TABLE 
lab12d9: jr nc,#12e4 ; get pointer to character graphics 
lab12db: ld d,a 
lab12dc: ld a,e 
lab12dd: sub d 
lab12de: ccf 
lab12df: jr nc,#12e4 ; get pointer to character graphics 
lab12e1: ld e,a 
lab12e2: jr #12e7 ; (+#03) 
;;-------------------------------------------------------------------
;; get pointer to graphics for character in font
;;
;; Entry conditions:
;; A = character code
;; Exit conditions:
;; HL = pointer to graphics for character
lab12e4: ld hl,#3800			; font graphics 
lab12e7: push af 
lab12e8: ld d,#00 
lab12ea: ex de,hl 
lab12eb: add hl,hl			; x2 
lab12ec: add hl,hl			; x4 
lab12ed: add hl,hl			; x8 
lab12ee: add hl,de 
lab12ef: pop af 
lab12f0: pop de 
lab12f1: ret 
;;===========================================================================
TXT_SET_MATRIX:
lab12f2: ex de,hl 
lab12f3: call #12d4			; TXT GET MATRIX 
lab12f6: ret nc 
lab12f7: ex de,hl 
;;---------------------------------------------------------------------------
lab12f8: ld bc,#0008 
lab12fb: ldir 
lab12fd: ret 
;;===========================================================================
TXT_SET_M_TABLE:
lab12fe: push hl 
lab12ff: ld a,d 
lab1300: or a 
lab1301: ld d,#00 
lab1303: jr nz,#131e ; (+#19) 
lab1305: dec d 
lab1306: push de 
lab1307: ld c,e 
lab1308: ex de,hl 
lab1309: ld a,c 
lab130a: call #12d4			; TXT GET MATRIX 
lab130d: ld a,h 
lab130e: xor d 
lab130f: jr nz,#1315 ; (+#04) 
lab1311: ld a,l 
lab1312: xor e 
lab1313: jr z,#131d ; (+#08) 
lab1315: push bc 
lab1316: call #12f8 
lab1319: pop bc 
lab131a: inc c 
lab131b: jr nz,#1309 ; (-#14) 
lab131d: pop de 
lab131e: call #132b			; TXT GET M TABLE 
lab1321: ld (#b734),de 
lab1325: pop de 
lab1326: ld (#b736),de 
lab132a: ret 
;;===========================================================================
TXT_GET_M_TABLE:
lab132b: ld hl,(#b734) 
lab132e: ld a,h 
lab132f: rrca 
lab1330: ld a,l 
lab1331: ld hl,(#b736) 
lab1334: ret 
;;===========================================================================
TXT_WR_CHAR:
lab1335: ld b,a 
lab1336: ld a,(#b72e) 
lab1339: rlca 
lab133a: ret c 
lab133b: push bc 
lab133c: call #11a4 
lab133f: inc h 
lab1340: ld (#b726),hl 
lab1343: dec h 
lab1344: pop af 
lab1345: call #bdd3				;; IND: TXT WRITE CURSOR 
lab1348: jp #bdcd				;; IND: TXT DRAW CURSOR 
;;===========================================================================
IND_TXT_WRITE_CHAR:
lab134b: push hl 
lab134c: call #12d4			; TXT GET MATRIX 
lab134f: ld de,#b738 
lab1352: push de 
lab1353: call #0ef9			; SCR UNPACK 
lab1356: pop de 
lab1357: pop hl 
lab1358: call #0b6a			; SCR CHAR POSITION 
lab135b: ld c,#08 
lab135d: push bc 
lab135e: push hl 
lab135f: push bc 
lab1360: push de 
lab1361: ex de,hl 
lab1362: ld c,(hl) 
lab1363: call #1377 
lab1366: call #0c05			; SCR NEXT BYTE 
lab1369: pop de 
lab136a: inc de 
lab136b: pop bc 
lab136c: djnz #135f ; (-#0f) 
lab136e: pop hl 
lab136f: call #0c1f			; SCR NEXT LINE 
lab1372: pop bc 
lab1373: dec c 
lab1374: jr nz,#135d ; (-#19) 
lab1376: ret 
;;===========================================================================
lab1377: ld hl,(#b731) 
lab137a: jp (hl) 
;;===========================================================================
TXT_SET_BACK:
lab137b: ld hl,#1392 
lab137e: or a 
lab137f: jr z,#1384 ; (+#03) 
lab1381: ld hl,#13a0 
lab1384: ld (#b731),hl 
lab1387: ret 
;;===========================================================================
TXT_GET_BACK:
lab1388: ld hl,(#b731) 
lab138b: ld de,#ec6e 
lab138e: add hl,de 
lab138f: ld a,h 
lab1390: or l 
lab1391: ret 
;;===========================================================================
lab1392: ld hl,(#b72f) 
lab1395: ld a,c 
lab1396: cpl 
lab1397: and h 
lab1398: ld b,a 
lab1399: ld a,c 
lab139a: and l 
lab139b: or b 
lab139c: ld c,#ff 
lab139e: jr #13a3 ; (+#03) 
;;===========================================================================
lab13a0: ld a,(#b72f) 
;;---------------------------------------------------------------------------
lab13a3: ld b,a 
lab13a4: ex de,hl 
lab13a5: jp #0c74			; SCR PIXELS 
;;===========================================================================
TXT_SET_GRAPHIC:
lab13a8: ld (#b733),a 
lab13ab: ret 
;;===========================================================================
TXT_RD_CHAR:
lab13ac: push hl 
lab13ad: push de 
lab13ae: push bc 
lab13af: call #11a4 
lab13b2: call #bdd6			; IND: TXT UNWRITE 
lab13b5: push af 
lab13b6: call #bdcd			; IND: TXT DRAW CURSOR 
lab13b9: pop af 
lab13ba: pop bc 
lab13bb: pop de 
lab13bc: pop hl 
lab13bd: ret 
;;===========================================================================
IND_TXT_UNWRITE:
lab13be: ld a,(#b730) 
lab13c1: ld de,#b738 
lab13c4: push hl 
lab13c5: push de 
lab13c6: call #0f2a			; SCR REPACK 
lab13c9: pop de 
lab13ca: push de 
lab13cb: ld b,#08 
lab13cd: ld a,(de) 
lab13ce: cpl 
lab13cf: ld (de),a 
lab13d0: inc de 
lab13d1: djnz #13cd ; (-#06) 
lab13d3: call #13e1 
lab13d6: pop de 
lab13d7: pop hl 
lab13d8: jr nc,#13db ; (+#01) 
lab13da: ret nz 
lab13db: ld a,(#b72f) 
lab13de: call #0f2a			; SCR REPACK 
lab13e1: ld c,#00 
lab13e3: ld a,c 
lab13e4: call #12d4			; TXT GET MATRIX 
lab13e7: ld de,#b738 
lab13ea: ld b,#08 
lab13ec: ld a,(de) 
lab13ed: cp (hl) 
lab13ee: jr nz,#13f9 ; (+#09) 
lab13f0: inc hl 
lab13f1: inc de 
lab13f2: djnz #13ec ; (-#08) 
lab13f4: ld a,c 
lab13f5: cp #8f 
lab13f7: scf 
lab13f8: ret 
lab13f9: inc c 
lab13fa: jr nz,#13e3 ; (-#19) 
lab13fc: xor a 
lab13fd: ret 
;;===========================================================================
TXT_OUTPUT:
lab13fe: push af 
lab13ff: push bc 
lab1400: push de 
lab1401: push hl 
lab1402: call #bdd9			; IND: TXT OUT ACTION 
lab1405: pop hl 
lab1406: pop de 
lab1407: pop bc 
lab1408: pop af 
lab1409: ret 
;;===========================================================================
IND_TXT_OUT_ACTION:
lab140a: ld c,a 
lab140b: ld a,(#b733) 
lab140e: or a 
lab140f: ld a,c 
lab1410: jp nz,#1940			; GRA WR CHAR 
lab1413: ld hl,#b758 
lab1416: ld b,(hl) 
lab1417: ld a,b 
lab1418: cp #0a 
lab141a: jr nc,#144d ; (+#31) 
lab141c: or a 
lab141d: jr nz,#1425 ; (+#06) 
lab141f: ld a,c 
lab1420: cp #20 
lab1422: jp nc,#1335			; TXT WR CHAR 
lab1425: inc b 
lab1426: ld (hl),b 
lab1427: ld e,b 
lab1428: ld d,#00 
lab142a: add hl,de 
lab142b: ld (hl),c 
;; b759 = control code character
lab142c: ld a,(#b759) 
lab142f: ld e,a 
;; start of control code table in RAM
;; each entry is 3 bytes
lab1430: ld hl,#b763 
;; this effectively multiplies E by 3
;; and adds it onto the base address of the table
lab1433: add hl,de 
lab1434: add hl,de 
lab1435: add hl,de		;; 3 bytes per entry 
lab1436: ld a,(hl) 
lab1437: and #0f 
lab1439: cp b 
lab143a: ret nc 
lab143b: ld a,(#b72e) 
lab143e: and (hl) 
lab143f: rlca 
lab1440: jr c,#144d ; (+#0b) 
lab1442: inc hl 
lab1443: ld e,(hl)			;; function to execute 
lab1444: inc hl 
lab1445: ld d,(hl) 
lab1446: ld hl,#b759 
lab1449: ld a,c 
lab144a: call #0016			; LOW: PCDE INSTRUCTION 
lab144d: xor a 
lab144e: ld (#b758),a 
lab1451: ret 
;;===========================================================================
TXT_VDU_DISABLE:
lab1452: ld a,#81 
lab1454: call #1299 
lab1457: jr #144d ; (-#0c) 
;;===========================================================================
TXT_VDU_ENABLE:
lab1459: ld a,#7e 
lab145b: call #1288 
lab145e: jr #144d ; (-#13) 
;;===========================================================================
TXT_ASK_STATE:
lab1460: ld a,(#b72e) 
lab1463: ret 
;;===========================================================================
;; initialise control code functions
lab1464: xor a 
lab1465: ld (#b758),a 
lab1468: ld hl,#1474 
lab146b: ld de,#b763 
lab146e: ld bc,#0060 
lab1471: ldir 
lab1473: ret 
;;===========================================================================
;; control code handler functions
;; (see SOFT968	for a description of the control character operations)
;; byte 0: bits 3..0: number of parameters expected
;; byte 1,2: handler function
lab1474: 
defb #80
defw #1513				;; NUL:
defb #81
defw #1335				;; SOH: firmware function: TXT WR CHAR
defb #80
defw #1297				;; STX: firmware function: TXT CUR DISABLE
defb #80
defw #1286				;; ETX: firmware function: TXT CUR ENABLE
defb #81
defw #0ae9				;; EOT: firmware function: SCR SET MODE
defb #81
defw #1940				;; ENQ: firmware function: GRA WR CHAR
defb #00
defw #1459				;; ACK: firmware function: TXT VDU ENABLE
defb #80
defw #14e1				;; BEL:
defb #80
defw #1519				;; BS:
defb #80
defw #151e				;; TAB:
defb #80
defw #1523				;; LF:
defb #80
defw #1528				;; VT:
defb #80
defw #154f				;; FF: firmware function: TXT CLEAR WINDOW
defb #80
defw #153f				;; CR:
defb #81
defw #12ab				;; SO: firmware function: TXT SET PAPER
defb #81
defw #12a6				;; SI: firmware function: TXT SET PEN
defb #80
defw #155e				;; DLE:
defb #80
defw #1599				;; DC1:
defb #80
defw #158f				;; DC2:
defb #80
defw #1578				;; DC3:
defb #80
defw #1565				;; DC4:
defb #80
defw #1452				;; NAK: firmware function: TXT VDU DISABLE
defb #81
defw #14ec				;; SYN:
defb #81
defw #0c55				;; ETB: firmware function: SCR ACCESS
defb #80
defw #12c6				;; CAN: firmware function: TXT INVERSE
defb #89
defw #150d				;; EM:
defb #84
defw #1501				;; SUB:
defb #00
defw #14eb				;; ESC
defb #83
defw #14f1				;; FS:
defb #82
defw #14fa				;; GS:
defb #80
defw #1539				;; RS:
defb #82
defw #1547				;; US:
;; =============================================================================
TXT_GET_CONTROLS:
lab14d4: ld hl,#b763 
lab14d7: ret 
;; =============================================================================
;; data for control character ''BEL'' sound
lab14d8: 
defb #87 ;; channel status byte
defb #00 ;; volume envelope to use
defb #00 ;; tone envelope to use
defb #5a ;; tone period low
defb #00 ;; tone period high
defb #00 ;; noise period
defb #0b ;; start volume
defb #14 ;; envelope repeat count low
defb #00 ;; envelope repeat count high
;; =============================================================================
;; performs control character ''BEL'' function
lab14e1: push ix 
lab14e3: ld hl,#14d8			; 
lab14e6: call #2114			; SOUND QUEUE 
lab14e9: pop ix 
;; performs control character ''ESC'' function
lab14eb: ret 
;; =============================================================================
;; performs control character ''SYN'' function
lab14ec: rrca 
lab14ed: sbc a,a 
lab14ee: jp #137b			; TXT SET BACK 
;; =============================================================================
;; performs control character ''FS'' function
lab14f1: inc hl 
lab14f2: ld a,(hl)			; pen number 
lab14f3: inc hl 
lab14f4: ld b,(hl)			; ink 1 
lab14f5: inc hl 
lab14f6: ld c,(hl)			; ink 2 
lab14f7: jp #0cf2			; SCR SET INK 
;;====================================================================
;; performs control character ''GS'' instruction
lab14fa: inc hl 
lab14fb: ld b,(hl)			; ink 1 
lab14fc: inc hl 
lab14fd: ld c,(hl)			; ink 2 
lab14fe: jp #0cf7			; SCR SET BORDER 
;;====================================================================
;; performs control character ''SUB'' function
lab1501: inc hl 
lab1502: ld d,(hl)			; left column 
lab1503: inc hl 
lab1504: ld a,(hl)			; right column 
lab1505: inc hl 
lab1506: ld e,(hl)			; top row 
lab1507: inc hl 
lab1508: ld l,(hl)			; bottom row 
lab1509: ld h,a 
lab150a: jp #1208			; TXT WIN ENABLE 
;;====================================================================
;; performs control character ''EM'' function
lab150d: inc hl 
lab150e: ld a,(hl)			; character index 
lab150f: inc hl 
lab1510: jp #12f2			; TXT SET MATRIX 
;;====================================================================
;; performs control character ''NUL'' function
lab1513: call #11a4 
lab1516: jp #bdcd			; IND: TXT DRAW CURSOR 
;;====================================================================
;; performs control character ''BS'' function
lab1519: ld de,#ff00 
lab151c: jr #152b ; (+#0d) 
;;====================================================================
;; performs control character ''TAB'' function
lab151e: ld de,#0100 
lab1521: jr #152b ; (+#08) 
;;====================================================================
;; performs control character ''LF'' function
lab1523: ld de,#0001 
lab1526: jr #152b ; (+#03) 
;;====================================================================
;; performs control character ''VT'' function
lab1528: ld de,#00ff 
;;--------------------------------------------------------------------
;; D = column adjustment
;; E = row adjustment
lab152b: push de 
lab152c: call #11a4 
lab152f: pop de 
;; adjust row 
lab1530: ld a,l 
lab1531: add a,e 
lab1532: ld l,a 
;; adjust column
lab1533: ld a,h 
lab1534: add a,d 
lab1535: ld h,a 
lab1536: jp #1176			; set cursor position and draw it 
;;====================================================================
;; performs control character ''RS'' function
lab1539: ld hl,(#b729) 
lab153c: jp #1173			;; undraw cursor, set cursor position and draw it 
;;===========================================================================
;; performs control character ''CR'' function
lab153f: call #11a4 
lab1542: ld a,(#b72a) 
lab1545: jr #1535 ; (-#12) 
;;===========================================================================
;; performs control character ''US'' function
lab1547: inc hl 
lab1548: ld d,(hl)			; column 
lab1549: inc hl 
lab154a: ld e,(hl)			; row 
lab154b: ex de,hl 
lab154c: jp #1170			; TXT SET CURSOR 
;;===========================================================================
TXT_CLEAR_WINDOW:
lab154f: call #bdd0			; IND: TXT UNDRAW CURSOR 
lab1552: ld hl,(#b729) 
lab1555: ld (#b726),hl 
lab1558: ld de,(#b72b) 
lab155c: jr #15a2 ; (+#44) 
;;===========================================================================
;; performs control character ''DLE'' function
lab155e: call #11a4 
lab1561: ld d,h 
lab1562: ld e,l 
lab1563: jr #15a2 ; (+#3d) 
;;===========================================================================
;; performs control character ''DC4'' function
lab1565: call #158f			; control character ''DC2'' 
lab1568: ld hl,(#b729) 
lab156b: ld de,(#b72b) 
lab156f: ld a,(#b726) 
lab1572: ld l,a 
lab1573: inc l 
lab1574: cp e 
lab1575: ret nc 
lab1576: jr #1589 ; (+#11) 
;;===========================================================================
;; performs control character ''DC3'' function
lab1578: call #1599			; control character ''DC1'' function 
lab157b: ld hl,(#b729) 
lab157e: ld a,(#b72c) 
lab1581: ld d,a 
lab1582: ld a,(#b726) 
lab1585: dec a 
lab1586: ld e,a 
lab1587: cp l 
lab1588: ret c 
lab1589: ld a,(#b730) 
lab158c: jp #0db9			; SCR FILL BOX 
;;===========================================================================
;; performs control character ''DC2'' function
lab158f: call #11a4 
lab1592: ld e,l 
lab1593: ld a,(#b72c) 
lab1596: ld d,a 
lab1597: jr #15a2 ; (+#09) 
;;===========================================================================
;; performs control character ''DC1'' function
lab1599: call #11a4 
lab159c: ex de,hl 
lab159d: ld l,e 
lab159e: ld a,(#b72a) 
lab15a1: ld h,a 
;;---------------------------------------------------------------------------
lab15a2: call #1589 
lab15a5: jp #bdcd			; IND: TXT DRAW CURSOR 
;;===========================================================================
GRA_INITIALISE:
lab15a8: call #15d7			; GRA RESET 
lab15ab: ld hl,#0001 
lab15ae: ld a,h 
lab15af: call #176e			; GRA SET PAPER 
lab15b2: ld a,l 
lab15b3: call #1767			; GRA SET PEN 
lab15b6: ld hl,#0000 
lab15b9: ld d,h 
lab15ba: ld e,l 
lab15bb: call #160e			; GRA SET ORIGIN 
lab15be: ld de,#8000 
lab15c1: ld hl,#7fff 
lab15c4: push hl 
lab15c5: push de 
lab15c6: call #16a5			; GRA WIN WIDTH 
lab15c9: pop hl 
lab15ca: pop de 
lab15cb: jp #16ea			; GRA WIN HEIGHT 
;;===========================================================================
lab15ce: call #177a			; GRA GET PAPER 
lab15d1: ld h,a 
lab15d2: call #1775			; GRA GET PEN 
lab15d5: ld l,a 
lab15d6: ret 
;;===========================================================================
GRA_RESET:
lab15d7: call #15f0 
lab15da: ld hl,#15e0			;; table used to initialise graphics pack indirections 
lab15dd: jp #0ab4			;; initialise graphics pack indirections 
lab15e0: 
defb #09
defw #bddc
lab15e3: jp #1786							;; IND: GRA PLOT 
lab15e6: jp #179a							;; IND: GRA TEXT 
lab15e9: jp #17b4							;; IND: GRA LINE 
;;===========================================================================
GRA_DEFAULT:
lab15ec: xor a 
lab15ed: call #0c55			; SCR ACCESS 
lab15f0: xor a 
lab15f1: call #19d5			; GRA SET BACK 
lab15f4: cpl 
lab15f5: call #17b0			; GRA SET FIRST 
lab15f8: jp #17ac			; GRA SET LINE MASK 
;;===========================================================================
GRA_MOVE_RELATIVE:
lab15fb: call #165d			; convert relative graphics coordinate to 
; absolute graphics coordinate
;;---------------------------------------------------------------------------
GRA_MOVE_ABSOLUTE:
lab15fe: ld (#b697),de		; absolute x 
lab1602: ld (#b699),hl		; absolute y 
lab1605: ret 
;;===========================================================================
GRA_ASK_CURSOR:
lab1606: ld de,(#b697)		; absolute x 
lab160a: ld hl,(#b699)		; absolute y 
lab160d: ret 
;;===========================================================================
GRA_SET_ORIGIN:
lab160e: ld (#b693),de		; origin x 
lab1612: ld (#b695),hl		; origin y 
;;===========================================================================
;; set absolute position to origin
lab1615: ld de,#0000			; x = 0 
lab1618: ld h,d 
lab1619: ld l,e				; y = 0 
lab161a: jr #15fe ; GRA MOVE ABSOLUTE 
;;===========================================================================
GRA_GET_ORIGIN:
lab161c: ld de,(#b693)		; origin x 
lab1620: ld hl,(#b695)		; origin y 
lab1623: ret 
;;===========================================================================
;; get cursor absolute user coordinate
lab1624: call #1606			; GRA ASK CURSOR 
;;----------------------------------------------------------------------------
;; get absolute user coordinate
lab1627: call #15fe			; GRA MOVE ABSOLUTE 
;;===========================================================================
GRA_FROM_USER:
;; DE = X user coordinate
;; HL = Y user coordinate
;; out:
;; DE = x base coordinate
;; HL = y base coordinate
lab162a: push hl 
lab162b: call #0b0c			; SCR GET MODE 
lab162e: neg 
lab1630: defd sbc a,#fd 
lab1632: ld h,#00 
lab1634: ld l,a 
lab1635: bit 7,d 
lab1637: jr z,#163c ; (+#03) 
lab1639: ex de,hl 
lab163a: add hl,de 
lab163b: ex de,hl 
lab163c: cpl 
lab163d: and e 
lab163e: ld e,a 
lab163f: ld a,l 
lab1640: ld hl,(#b693)		; origin x 
lab1643: add hl,de 
lab1644: rrca 
lab1645: call c,#16e5			; HL = HL/2 
lab1648: rrca 
lab1649: call c,#16e5			; HL = HL/2 
lab164c: pop de 
lab164d: push hl 
lab164e: ld a,d 
lab164f: rlca 
lab1650: jr nc,#1653 
lab1652: inc de 
lab1653: res 0,e 
lab1655: ld hl,(#b695)		; origin y 
lab1658: add hl,de 
lab1659: pop de 
lab165a: jp #16e5			; HL = HL/2 
;;==================================================================================
;; convert relative graphics coordinate to absolute graphics coordinate
;; DE = relative X
;; HL = relative Y
lab165d: push hl 
lab165e: ld hl,(#b697)		; absolute x 
lab1661: add hl,de 
lab1662: pop de 
lab1663: push hl 
lab1664: ld hl,(#b699)		; absolute y 
lab1667: add hl,de 
lab1668: pop de 
lab1669: ret 
;;==================================================================================
;; X graphics coordinate within window
;; DE = x coordinate
lab166a: ld hl,(#b69b)		; graphics window left edge 
lab166d: scf 
lab166e: sbc hl,de 
lab1670: jp p,#167e 
lab1673: ld hl,(#b69d)		; graphics window right edge 
lab1676: or a 
lab1677: sbc hl,de 
lab1679: scf 
lab167a: ret p 
lab167b: or #ff 
lab167d: ret 
lab167e: xor a 
lab167f: ret 
;;==================================================================================
;; y graphics coordinate within window
;; DE = y coordinate
lab1680: ld hl,(#b69f)		; graphics window top edge 
lab1683: or a 
lab1684: sbc hl,de 
lab1686: jp m,#167b 
lab1689: ld hl,(#b6a1)		; graphics window bottom edge 
lab168c: scf 
lab168d: sbc hl,de 
lab168f: jp p,#167e 
lab1692: scf 
lab1693: ret 
;;==================================================================================
;; current point within graphics window
lab1694: call #1627			; get absolute user coordinate 
;; point in graphics window?
;; HL = x coordinate
;; DE = y coordinate
lab1697: push hl 
lab1698: call #166a			; X graphics coordinate within window 
lab169b: pop hl 
lab169c: ret nc 
lab169d: push de 
lab169e: ex de,hl 
lab169f: call #1680			; Y graphics coordinate within window 
lab16a2: ex de,hl 
lab16a3: pop de 
lab16a4: ret 
;;==================================================================================
GRA_WIN_WIDTH:
;; DE = left edge
;; HL = right edge
lab16a5: push hl 
lab16a6: call #16d1			;; Make X coordinate within range 0-639 
lab16a9: pop de 
lab16aa: push hl 
lab16ab: call #16d1			;; Make X coordinate within range 0-639 
lab16ae: pop de 
lab16af: ld a,e 
lab16b0: sub l 
lab16b1: ld a,d 
lab16b2: sbc a,h 
lab16b3: jr c,#16b6 
lab16b5: ex de,hl 
lab16b6: ld a,e 
lab16b7: and #f8 
lab16b9: ld e,a 
lab16ba: ld a,l 
lab16bb: or #07 
lab16bd: ld l,a 
lab16be: call #0b0c			; SCR GET MODE 
lab16c1: dec a 
lab16c2: call m,#16e1			; DE = DE/2 and HL = HL/2 
lab16c5: dec a 
lab16c6: call m,#16e1			; DE = DE/2 and HL = HL/2 
lab16c9: ld (#b69b),de		; graphics window left edge 
lab16cd: ld (#b69d),hl		; graphics window right edge 
lab16d0: ret 
;;==================================================================================
;; Make X coordinate within range 0-639
lab16d1: ld a,d 
lab16d2: or a 
lab16d3: ld hl,#0000 
lab16d6: ret m 
lab16d7: ld hl,#027f			; 639 
lab16da: ld a,e 
lab16db: sub l 
lab16dc: ld a,d 
lab16dd: sbc a,h 
lab16de: ret nc 
lab16df: ex de,hl 
lab16e0: ret 
;;==================================================================================
;; DE = de/2
;; HL = hl/2
lab16e1: sra d 
lab16e3: rr e 
;;----------------------------------------------------------------------------------
;; Hl = Hl/2
lab16e5: sra h 
lab16e7: rr l 
lab16e9: ret 
;;==================================================================================
GRA_WIN_HEIGHT:
lab16ea: push hl 
lab16eb: call #1703			;; make Y coordinate in range 0-199 
lab16ee: pop de 
lab16ef: push hl 
lab16f0: call #1703			;; make Y coordinate in range 0-199 
lab16f3: pop de 
lab16f4: ld a,l 
lab16f5: sub e 
lab16f6: ld a,h 
lab16f7: sbc a,d 
lab16f8: jr c,#16fb ; (+#01) 
lab16fa: ex de,hl 
lab16fb: ld (#b69f),de		; graphics window top edge 
lab16ff: ld (#b6a1),hl		; graphics window bottom edge 
lab1702: ret 
;;==================================================================================
;; make Y coordinate in range 0-199
lab1703: ld a,d 
lab1704: or a 
lab1705: ld hl,#0000 
lab1708: ret m 
lab1709: srl d 
lab170b: rr e 
lab170d: ld hl,#00c7		; 199 
lab1710: ld a,e 
lab1711: sub l 
lab1712: ld a,d 
lab1713: sbc a,h 
lab1714: ret nc 
lab1715: ex de,hl 
lab1716: ret 
;;==================================================================================
GRA_GET_W_WIDTH:
lab1717: ld de,(#b69b)		; graphics window left edge 
lab171b: ld hl,(#b69d)		; graphics window right edge 
lab171e: call #0b0c			; SCR GET MODE 
lab1721: dec a 
lab1722: call m,#1727 
lab1725: dec a 
lab1726: ret p 
;; HL = (hl*2)+1
lab1727: add hl,hl 
lab1728: inc hl 
;; de = de * 2
lab1729: ex de,hl 
lab172a: add hl,hl 
lab172b: ex de,hl 
lab172c: ret 
;;==================================================================================
GRA_GET_W_HEIGHT:
lab172d: ld de,(#b69f)		; graphics window top edge 
lab1731: ld hl,(#b6a1)		; graphics window bottom edge 
lab1734: jr #1727 
;;==================================================================================
GRA_CLEAR_WINDOW:
lab1736: call #1717			; GRA GET W WIDTH 
lab1739: or a 
lab173a: sbc hl,de 
lab173c: inc hl 
lab173d: call #16e5			; HL = HL/2 
lab1740: call #16e5			; HL = HL/2 
lab1743: srl l 
lab1745: ld b,l 
lab1746: ld de,(#b6a1)		; graphics window bottom edge 
lab174a: ld hl,(#b69f)		; graphics window top edge 
lab174d: push hl 
lab174e: or a 
lab174f: sbc hl,de 
lab1751: inc hl 
lab1752: ld c,l 
lab1753: ld de,(#b69b)		; graphics window left edge 
lab1757: pop hl 
lab1758: push bc 
lab1759: call #0baf			;; SCR DOT POSITION 
lab175c: pop de 
lab175d: ld a,(#b6a4)		; graphics paper 
lab1760: ld c,a 
lab1761: call #0dbd			;; SCR FLOOD BOX 
lab1764: jp #1615			;; set absolute position to origin 
;;==================================================================================
GRA_SET_PEN:
lab1767: call #0c8e				;; SCR INK ENCODE 
lab176a: ld (#b6a3),a		; graphics pen 
lab176d: ret 
;;==================================================================================
GRA_SET_PAPER:
lab176e: call #0c8e				;; SCR INK ENCODE 
lab1771: ld (#b6a4),a		; graphics paper 
lab1774: ret 
;;==================================================================================
GRA_GET_PEN:
lab1775: ld a,(#b6a3)		; graphics pen 
lab1778: jr #177d ; do SCR INK ENCODE 
;;==================================================================================
GRA_GET_PAPER:
lab177a: ld a,(#b6a4)		; graphics paper 
lab177d: jp #0ca7			;; SCR INK DECODE 
;;==================================================================================
GRA_PLOT_RELATIVE:
lab1780: call #165d			; convert relative graphics coordinate to 
; absolute graphics coordinate
;;----------------------------------------------------------------------------------
GRA_PLOT_ABSOLUTE:
lab1783: jp #bddc			; IND: GRA PLOT 
;;============================================================================
IND_GRA_PLOT:
lab1786: call #1694			; test if current coordinate within graphics window 
lab1789: ret nc 
lab178a: call #0baf			;; SCR DOT POSITION 
lab178d: ld a,(#b6a3)		; graphics pen 
lab1790: ld b,a 
lab1791: jp #bde8			; IND: SCR WRITE 
;;===========================================================================
GRA_TEST_RELATIVE:
lab1794: call #165d			; convert relative graphics coordinate to 
; absolute graphics coordinate
;;---------------------------------------------------------------------------
GRA_TEST_ABSOLUTE:
lab1797: jp #bddf			; IND: GRA TEST 
;;===========================================================================
IND_GRA_TEXT:
lab179a: call #1694			; test if current coordinate within graphics window 
lab179d: jp nc,#177a			; GRA GET PAPER 
lab17a0: call #0baf			; SCR DOT POSITION 
lab17a3: jp #bde5			; IND: SCR READ 
;;===========================================================================
GRA_LINE_RELATIVE:
lab17a6: call #165d			; convert relative graphics coordinate to 
; absolute graphics coordinate
;;---------------------------------------------------------------------------
GRA_LINE_ABSOLUTE:
lab17a9: jp #bde2			; IND: GRA LINE 
;;===========================================================================
GRA_SET_LINE_MASK:
lab17ac: ld (#b6b3),a		; gra line mask 
lab17af: ret 
;;===========================================================================
GRA_SET_FIRST:
lab17b0: ld (#b6b2),a 
lab17b3: ret 
;;===========================================================================
IND_GRA_LINE:
lab17b4: push hl 
lab17b5: call #188b			; get cursor absolute position 
lab17b8: pop hl 
lab17b9: call #1627			; get absolute user coordinate 
;; remember Y coordinate
lab17bc: push hl 
;; DE = X coordinate
;;-------------------------------------------
;; calculate dx
lab17bd: ld hl,(#b6a5)		; absolute user X coordinate 
lab17c0: or a 
lab17c1: sbc hl,de 
;; this will record the fact of dx is +ve or negative
lab17c3: ld a,h 
lab17c4: ld (#b6ad),a 
;; if dx is negative, make it positive
lab17c7: call m,#1939			; HL = -HL 
;; HL = abs(dx)
;;-------------------------------------------
;; calculate dy
lab17ca: pop de 
;; DE = Y coordinate
lab17cb: push hl 
lab17cc: ld hl,(#b6a7)		; absolute user Y coordinate 
lab17cf: or a 
lab17d0: sbc hl,de 
;; this stores the fact of dy is +ve or negative
lab17d2: ld a,h 
lab17d3: ld (#b6ae),a 
;; if dy is negative, make it positive
lab17d6: call m,#1939			; HL = -HL 
;; HL = abs(dy)
lab17d9: pop de 
;; DE = abs(dx)
;; HL = abs(dy)
;;-------------------------------------------
;; is dx or dy largest?
lab17da: or a 
lab17db: sbc hl,de			; dy-dx 
lab17dd: add hl,de			; and return it back to their original values 
lab17de: sbc a,a 
lab17df: ld (#b6af),a		; remembers which of dy/dx was largest 
lab17e2: ld a,(#b6ae)		; dy is negative 
lab17e5: jr z,#17eb ; depends on result of dy-dx 
;; if yes, then swap dx/dy
lab17e7: ex de,hl 
;; DE = abs(dy)
;; HL = abs(dx)
lab17e8: ld a,(#b6ad)		; dx is negative 
;;-------------------------------------------
lab17eb: push af 
lab17ec: ld (#b6ab),de 
lab17f0: ld b,h 
lab17f1: ld c,l 
lab17f2: ld a,(#b6b2) 
lab17f5: or a 
lab17f6: jr z,#17f9 ; (+#01) 
lab17f8: inc bc 
lab17f9: ld (#b6b0),bc 
lab17fd: call #1939			; HL = -HL 
lab1800: push hl 
lab1801: add hl,de 
lab1802: ld (#b6a9),hl 
lab1805: pop hl 
lab1806: sra h				;; /2 for y coordinate (0-400 GRA coordinates, 0-200 actual number of lines) 
lab1808: rr l 
lab180a: pop af 
lab180b: rlca 
lab180c: jr c,#1820 ; (+#12) 
lab180e: push hl 
lab180f: call #188b			; get cursor absolute position 
lab1812: ld hl,(#b6ad) 
lab1815: ld a,h 
lab1816: cpl 
lab1817: ld h,a 
lab1818: ld a,l 
lab1819: cpl 
lab181a: ld l,a 
lab181b: ld (#b6ad),hl 
lab181e: jr #1832 ; (+#12) 
lab1820: ld a,(#b6b2) 
lab1823: or a 
lab1824: jr nz,#1833 ; (+#0d) 
lab1826: add hl,de 
lab1827: push hl 
lab1828: ld a,(#b6af)		; dy or dx was biggest? 
lab182b: rlca 
lab182c: call c,#18da			; plot a pixel moving up 
lab182f: call nc,#1928			; plot a pixel moving right 
lab1832: pop hl 
lab1833: ld a,d 
lab1834: or e 
lab1835: jp z,#1898 
lab1838: push ix 
lab183a: ld bc,#0000 
lab183d: push bc 
lab183e: pop ix 
lab1840: push ix 
lab1842: pop de 
lab1843: or a 
lab1844: adc hl,de 
lab1846: ld de,(#b6ab) 
lab184a: jp p,#1853 
lab184d: inc bc 
lab184e: add ix,de 
lab1850: add hl,de 
lab1851: jr nc,#184d ; (-#06) 
; DE = -de
lab1853: xor a 
lab1854: sub e 
lab1855: ld e,a 
lab1856: sbc a,a 
lab1857: sub d 
lab1858: ld d,a 
lab1859: add hl,de 
lab185a: jr nc,#1861 ; (+#05) 
lab185c: add ix,de 
lab185e: dec bc 
lab185f: jr #1859 ; (-#08) 
lab1861: ld de,(#b6a9) 
lab1865: add hl,de 
lab1866: push bc 
lab1867: push hl 
lab1868: ld hl,(#b6b0) 
lab186b: or a 
lab186c: sbc hl,bc 
lab186e: jr nc,#1876 ; (+#06) 
lab1870: add hl,bc 
lab1871: ld b,h 
lab1872: ld c,l 
lab1873: ld hl,#0000 
lab1876: ld (#b6b0),hl 
lab1879: call #1898			; plot with clip 
lab187c: pop hl 
lab187d: pop bc 
lab187e: jr nc,#1888 ; (+#08) 
lab1880: ld de,(#b6b0) 
lab1884: ld a,d 
lab1885: or e 
lab1886: jr nz,#1840 ; (-#48) 
lab1888: pop ix 
lab188a: ret 
;;==================================================================================
lab188b: push de 
lab188c: call #1624			;; get cursor absolute user coordinate 
lab188f: ld (#b6a5),de 
lab1893: ld (#b6a7),hl 
lab1896: pop de 
lab1897: ret 
;;==================================================================================
lab1898: ld a,(#b6af) 
lab189b: rlca 
lab189c: jr c,#18eb ; (+#4d) 
lab189e: ld a,b 
lab189f: or c 
lab18a0: jr z,#18da ; (+#38) 
lab18a2: ld hl,(#b6a7) 
lab18a5: add hl,bc 
lab18a6: dec hl 
lab18a7: ld b,h 
lab18a8: ld c,l 
lab18a9: ex de,hl 
lab18aa: call #1680			; Y graphics coordinate within window 
lab18ad: ld hl,(#b6a7) 
lab18b0: ex de,hl 
lab18b1: inc hl 
lab18b2: ld (#b6a7),hl 
lab18b5: jr c,#18bd ; 
lab18b7: jr z,#18da ; 
lab18b9: ld bc,(#b69f)		; graphics window top edge 
lab18bd: call #1680			; Y graphics coordinate within window 
lab18c0: jr c,#18c7 ; (+#05) 
lab18c2: ret nz 
lab18c3: ld de,(#b6a1)		; graphics window bottom edge 
lab18c7: push de 
lab18c8: ld de,(#b6a5) 
lab18cc: call #166a			; graphics x coordinate within window 
lab18cf: pop hl 
lab18d0: jr c,#18d7 ; (+#05) 
lab18d2: ld hl,#b6ad 
lab18d5: xor (hl) 
lab18d6: ret p 
lab18d7: call c,#1016			; plot a pixel, going up a line 
lab18da: ld hl,(#b6a5) 
lab18dd: ld a,(#b6ad) 
lab18e0: rlca 
lab18e1: inc hl 
lab18e2: jr c,#18e6 ; (+#02) 
lab18e4: dec hl 
lab18e5: dec hl 
lab18e6: ld (#b6a5),hl 
lab18e9: scf 
lab18ea: ret 
;; we work with coordinates...
;; this performs the clipping to find if the coordinates are within rnage
lab18eb: ld a,b 
lab18ec: or c 
lab18ed: jr z,#1928 ; (+#39) 
lab18ef: ld hl,(#b6a5) 
lab18f2: add hl,bc 
lab18f3: dec hl 
lab18f4: ld b,h 
lab18f5: ld c,l 
lab18f6: ex de,hl 
lab18f7: call #166a			; x graphics coordinate within window 
lab18fa: ld hl,(#b6a5) 
lab18fd: ex de,hl 
lab18fe: inc hl 
lab18ff: ld (#b6a5),hl 
lab1902: jr c,#190a 
lab1904: jr z,#1928 
lab1906: ld bc,(#b69d)		; graphics window right edge 
lab190a: call #166a			; x graphics coordinate within window 
lab190d: jr c,#1914 
lab190f: ret nz 
lab1910: ld de,(#b69b)		; graphics window left edge 
lab1914: push de 
lab1915: ld de,(#b6a7) 
lab1919: call #1680			; Y graphics coordinate within window 
lab191c: pop hl 
lab191d: jr c,#1924 ; (+#05) 
lab191f: ld hl,#b6ae 
lab1922: xor (hl) 
lab1923: ret p 
lab1924: ex de,hl 
lab1925: call c,#0fc2			; plot a pixel moving right 
lab1928: ld hl,(#b6a7) 
lab192b: ld a,(#b6ae) 
lab192e: rlca 
lab192f: inc hl 
lab1930: jr c,#1934 ; (+#02) 
lab1932: dec hl 
lab1933: dec hl 
lab1934: ld (#b6a7),hl 
lab1937: scf 
lab1938: ret 
;;==================================================================================
; HL = -hl
lab1939: xor a 
lab193a: sub l 
lab193b: ld l,a 
lab193c: sbc a,a 
lab193d: sub h 
lab193e: ld h,a 
lab193f: ret 
;;===========================================================================
GRA_WR_CHAR:
lab1940: push ix 
lab1942: call #12d4			; TXT GET MATRIX 
lab1945: push hl 
lab1946: pop ix 
lab1948: call #1624			;; get cursor absolute user coordinate 
lab194b: call #1697			;; point in graphics window 
lab194e: jr nc,#199b ; (+#4b) 
lab1950: push hl 
lab1951: push de 
lab1952: ld bc,#0007 
lab1955: ex de,hl 
lab1956: add hl,bc 
lab1957: ex de,hl 
lab1958: or a 
lab1959: sbc hl,bc 
lab195b: call #1697			;; point in graphics window 
lab195e: pop de 
lab195f: pop hl 
lab1960: jr nc,#199b ; (+#39) 
lab1962: call #0baf			;; SCR DOT POSITION 
lab1965: ld d,#08 
lab1967: push hl 
lab1968: ld e,(ix+#00) 
lab196b: scf 
lab196c: rl e 
lab196e: call #19c4 
lab1971: rrc c 
lab1973: call c,#0c05			; SCR NEXT BYTE 
lab1976: sla e 
lab1978: jr nz,#196e ; (-#0c) 
lab197a: pop hl 
lab197b: call #0c1f			; SCR NEXT LINE 
lab197e: inc ix 
lab1980: dec d 
lab1981: jr nz,#1967 ; (-#1c) 
lab1983: pop ix 
lab1985: call #1606			; GRA ASK CURSOR 
lab1988: ex de,hl 
lab1989: call #0b0c			; SCR GET MODE 
lab198c: ld bc,#0008 
lab198f: jr z,#1995 ; (+#04) 
lab1991: jr nc,#1996 ; (+#03) 
lab1993: add hl,bc 
lab1994: add hl,bc 
lab1995: add hl,bc 
lab1996: add hl,bc 
lab1997: ex de,hl 
lab1998: jp #15fe			; GRA MOVE ABSOLUTE 
;;==================================================================================
lab199b: ld b,#08 
lab199d: push bc 
lab199e: push de 
lab199f: ld a,(ix+#00) 
lab19a2: scf 
lab19a3: adc a,a 
lab19a4: push hl 
lab19a5: push de 
lab19a6: push af 
lab19a7: call #1697			;; point in graphics window 
lab19aa: jr nc,#19b4 ; (+#08) 
lab19ac: call #0baf			;; SCR DOT POSITION 
lab19af: pop af 
lab19b0: push af 
lab19b1: call #19c4 
lab19b4: pop af 
lab19b5: pop de 
lab19b6: pop hl 
lab19b7: inc de 
lab19b8: add a,a 
lab19b9: jr nz,#19a4 ; (-#17) 
lab19bb: pop de 
lab19bc: dec hl 
lab19bd: inc ix 
lab19bf: pop bc 
lab19c0: djnz #199d ; (-#25) 
lab19c2: jr #1983 ; (-#41) 
;;==================================================================================
lab19c4: ld a,(#b6a3)		; graphics pen 
lab19c7: jr c,#19d1 ; (+#08) 
lab19c9: ld a,(#b6b4) 
lab19cc: or a 
lab19cd: ret nz 
lab19ce: ld a,(#b6a4)		; graphics paper 
lab19d1: ld b,a 
lab19d2: jp #bde8			; IND: SCR WRITE 
;;===========================================================================
GRA_SET_BACK:
lab19d5: ld (#b6b4),a 
lab19d8: ret 
;;===========================================================================
GRA_FILL:
;; HL = buffer
;; A = pen to fill
;; DE = length of buffer
lab19d9: ld (#b6a5),hl 
lab19dc: ld (hl),#01 
lab19de: dec de 
lab19df: ld (#b6a7),de 
lab19e3: call #0c8e				;; SCR INK ENCODE 
lab19e6: ld (#b6aa),a 
lab19e9: call #1624			;; get cursor absolute user coordinate 
lab19ec: call #1697			;; point in graphics window 
lab19ef: call c,#1b42 
lab19f2: ret nc 
lab19f3: push hl 
lab19f4: call #1ae7 
lab19f7: ex (sp),hl 
lab19f8: call #1b15 
lab19fb: pop bc 
lab19fc: ld a,#ff 
lab19fe: ld (#b6a9),a 
lab1a01: push hl 
lab1a02: push de 
lab1a03: push bc 
lab1a04: call #1a0b 
lab1a07: pop bc 
lab1a08: pop de 
lab1a09: pop hl 
lab1a0a: xor a 
lab1a0b: ld (#b6ab),a 
lab1a0e: call #1ade 
lab1a11: call #1697			;; point in graphics window 
lab1a14: call c,#1a50 
lab1a17: jr c,#1a0e ; (-#0b) 
lab1a19: ld hl,(#b6a5)		; graphics fill buffer 
lab1a1c: rst #20				; RST 4 - LOW: RAM LAM 
lab1a1d: cp #01 
lab1a1f: jr z,#1a4b ; (+#2a) 
lab1a21: ld (#b6ab),a 
lab1a24: ex de,hl 
lab1a25: ld hl,(#b6a7) 
lab1a28: ld bc,#0007 
lab1a2b: add hl,bc 
lab1a2c: ld (#b6a7),hl 
lab1a2f: ex de,hl 
lab1a30: dec hl 
lab1a31: rst #20				; RST 4 - LOW: RAM LAM 
lab1a32: ld b,a 
lab1a33: dec hl 
lab1a34: rst #20				; RST 4 - LOW: RAM LAM 
lab1a35: ld c,a 
lab1a36: dec hl 
lab1a37: rst #20				; RST 4 - LOW: RAM LAM 
lab1a38: ld d,a 
lab1a39: dec hl 
lab1a3a: rst #20				; RST 4 - LOW: RAM LAM 
lab1a3b: ld e,a 
lab1a3c: push de 
lab1a3d: dec hl 
lab1a3e: rst #20				; RST 4 - LOW: RAM LAM 
lab1a3f: ld d,a 
lab1a40: dec hl 
lab1a41: rst #20				; RST 4 - LOW: RAM LAM 
lab1a42: ld e,a 
lab1a43: dec hl 
lab1a44: ld (#b6a5),hl		; graphics fill buffer 
lab1a47: ex de,hl 
lab1a48: pop de 
lab1a49: jr #1a11 ; (-#3a) 
lab1a4b: ld a,(#b6a9) 
lab1a4e: rrca 
lab1a4f: ret 
;;==================================================================================
lab1a50: ld (#b6ac),bc 
lab1a54: call #1b42 
lab1a57: jr c,#1a62 ; (+#09) 
lab1a59: call #1af1 
lab1a5c: ret nc 
lab1a5d: ld (#b6ae),hl 
lab1a60: jr #1a73 ; (+#11) 
lab1a62: push hl 
lab1a63: call #1b15 
lab1a66: ld (#b6ae),hl 
lab1a69: pop bc 
lab1a6a: ld a,l 
lab1a6b: sub c 
lab1a6c: ld a,h 
lab1a6d: sbc a,b 
lab1a6e: call c,#1acb 
lab1a71: ld h,b 
lab1a72: ld l,c 
lab1a73: call #1ae7 
lab1a76: ld (#b6b0),hl 
lab1a79: ld bc,(#b6ac) 
lab1a7d: or a 
lab1a7e: sbc hl,bc 
lab1a80: add hl,bc 
lab1a81: jr z,#1a94 ; (+#11) 
lab1a83: jr nc,#1a8d ; (+#08) 
lab1a85: call #1af1 
lab1a88: call c,#1a9d 
lab1a8b: jr #1a94 ; (+#07) 
lab1a8d: push hl 
lab1a8e: ld h,b 
lab1a8f: ld l,c 
lab1a90: pop bc 
lab1a91: call #1acb 
lab1a94: ld hl,(#b6ae) 
lab1a97: ld bc,(#b6b0) 
lab1a9b: scf 
lab1a9c: ret 
lab1a9d: push de 
lab1a9e: push hl 
lab1a9f: ld hl,(#b6a7) 
lab1aa2: ld de,#fff9 
lab1aa5: add hl,de 
lab1aa6: pop de 
lab1aa7: jr nc,#1ac5 ; (+#1c) 
lab1aa9: ld (#b6a7),hl 
lab1aac: ld hl,(#b6a5)		; graphics fill buffer 
lab1aaf: inc hl 
lab1ab0: ld (hl),e 
lab1ab1: inc hl 
lab1ab2: ld (hl),d 
lab1ab3: inc hl 
lab1ab4: pop de 
lab1ab5: ld (hl),e 
lab1ab6: inc hl 
lab1ab7: ld (hl),d 
lab1ab8: inc hl 
lab1ab9: ld (hl),c 
lab1aba: inc hl 
lab1abb: ld (hl),b 
lab1abc: inc hl 
lab1abd: ld a,(#b6ab) 
lab1ac0: ld (hl),a 
lab1ac1: ld (#b6a5),hl				; graphics fill buffer 
lab1ac4: ret 
lab1ac5: xor a 
lab1ac6: ld (#b6a9),a 
lab1ac9: pop de 
lab1aca: ret 
lab1acb: call #1ad7 
lab1ace: call #1b42 
lab1ad1: call nc,#1af1 
lab1ad4: call c,#1a9d 
lab1ad7: ld a,(#b6ab) 
lab1ada: cpl 
lab1adb: ld (#b6ab),a 
lab1ade: dec de 
lab1adf: ld a,(#b6ab) 
lab1ae2: or a 
lab1ae3: ret z 
lab1ae4: inc de 
lab1ae5: inc de 
lab1ae6: ret 
lab1ae7: xor a 
lab1ae8: ld bc,(#b69f)		; graphics window top edge 
lab1aec: call #1af3 
lab1aef: dec hl 
lab1af0: ret 
;;==================================================================================
lab1af1: ld a,#ff 
lab1af3: push bc 
lab1af4: push de 
lab1af5: push hl 
lab1af6: push af 
lab1af7: call #1b4f 
lab1afa: pop af 
lab1afb: ld b,a 
lab1afc: call #1b34 
lab1aff: inc b 
lab1b00: djnz #1b06 ; (+#04) 
lab1b02: jr nc,#1b4b ; (+#47) 
lab1b04: xor (hl) 
lab1b05: ld (hl),a 
lab1b06: jr c,#1b4b ; (+#43) 
lab1b08: ex (sp),hl 
lab1b09: inc hl 
lab1b0a: ex (sp),hl 
lab1b0b: sbc hl,de 
lab1b0d: jr z,#1b4b ; (+#3c) 
lab1b0f: add hl,de 
lab1b10: call #0c39			; SCR PREV LINE 
lab1b13: jr #1afc ; (-#19) 
lab1b15: push bc 
lab1b16: push de 
lab1b17: push hl 
lab1b18: ld bc,(#b6a1)		; graphics window bottom edge 
lab1b1c: call #1b4f 
lab1b1f: or a 
lab1b20: sbc hl,de 
lab1b22: jr z,#1b4b ; (+#27) 
lab1b24: add hl,de 
lab1b25: call #0c1f			; SCR NEXT LINE 
lab1b28: call #1b34 
lab1b2b: jr z,#1b4b ; (+#1e) 
lab1b2d: xor (hl) 
lab1b2e: ld (hl),a 
lab1b2f: ex (sp),hl 
lab1b30: dec hl 
lab1b31: ex (sp),hl 
lab1b32: jr #1b1f ; (-#15) 
;;==================================================================================
lab1b34: ld a,(#b6a3)		; graphics pen 
lab1b37: xor (hl) 
lab1b38: and c 
lab1b39: ret z 
lab1b3a: ld a,(#b6aa) 
lab1b3d: xor (hl) 
lab1b3e: and c 
lab1b3f: ret z 
lab1b40: scf 
lab1b41: ret 
;;==================================================================================
lab1b42: push bc 
lab1b43: push de 
lab1b44: push hl 
lab1b45: call #0baf			;; SCR DOT POSITION 
lab1b48: call #1b34 
lab1b4b: pop hl 
lab1b4c: pop de 
lab1b4d: pop bc 
lab1b4e: ret 
;;==================================================================================
lab1b4f: push bc 
lab1b50: push de 
lab1b51: call #0baf			;; SCR DOT POSITION 
lab1b54: pop de 
lab1b55: ex (sp),hl 
lab1b56: call #0baf			;; SCR DOT POSITION 
lab1b59: ex de,hl 
lab1b5a: pop hl 
lab1b5b: ret 
;;===========================================================================
KM_INITIALISE:
lab1b5c: ld hl,#1e02 
lab1b5f: call #1df6			; KM SET DELAY 
lab1b62: xor a 
lab1b63: ld (#b655),a 
lab1b66: ld h,a 
lab1b67: ld l,a 
lab1b68: ld (#b631),hl 
lab1b6b: ld bc,#ffb0 
lab1b6e: ld de,#b5d6 
lab1b71: ld hl,#b692 
lab1b74: ld a,#04 
lab1b76: ex de,hl 
lab1b77: add hl,bc 
lab1b78: ex de,hl 
lab1b79: ld (hl),d 
lab1b7a: dec hl 
lab1b7b: ld (hl),e 
lab1b7c: dec hl 
lab1b7d: dec a 
lab1b7e: jr nz,#1b76 ; (-#0a) 
;;-------------------------------------------
;; copy keyboard translation table
lab1b80: ld hl,#1eef 
lab1b83: ld bc,#00fa 
lab1b86: ldir 
;;-------------------------------------------
lab1b88: ld b,#0a 
lab1b8a: ld de,#b635 
lab1b8d: ld hl,#b63f 
lab1b90: xor a 
lab1b91: ld (de),a 
lab1b92: inc de 
lab1b93: ld (hl),#ff 
lab1b95: inc hl 
lab1b96: djnz #1b91 ; (-#07) 
;;-------------------------------------------
;;===========================================================================
KM_RESET:
lab1b98: call #1e75 
lab1b9b: call #1bf8			; reset returned key (KM CHAR RETURN) 
lab1b9e: ld de,#b590 
lab1ba1: ld hl,#0098 
lab1ba4: call #1c0a 
lab1ba7: ld hl,#1bb3			; table used to initialise keyboard manager indirections 
lab1baa: call #0ab4			; initialise keyboard manager indirections (KM TEST BREAK) 
lab1bad: call #0ab4			; initialise keyboard manager indirections (KM SCAN KEYS) 
lab1bb0: jp #1e0b			; KM DISARM BREAK 
lab1bb3:: 
defb #3
defw #bdee								; IND: KM TEST BREAK
lab1bb6: jp #1db8 
defb #3
defw #bdf4								; IND: KM SCAN KEYS
lab1bbc: jp		#1d40 
;;===========================================================================
KM_WAIT_CHAR:
lab1bbf: call #1bc5			; KM READ CHAR 
lab1bc2: jr nc,#1bbf 
lab1bc4: ret 
;;===========================================================================
KM_READ_CHAR:
lab1bc5: push hl 
lab1bc6: ld hl,#b62a			; returned char 
lab1bc9: ld a,(hl)			; get char 
lab1bca: ld (hl),#ff			; reset state 
lab1bcc: cp (hl)				; was a char returned? 
lab1bcd: jr c,#1bf6 ; a key was put back into buffer, return without expanding it 
;; are we expanding?
lab1bcf: ld hl,(#b628) 
lab1bd2: ld a,h 
lab1bd3: or a 
lab1bd4: jr nz,#1be7			; continue expansion 
lab1bd6: call #1ce1			; KM READ KEY 
lab1bd9: jr nc,#1bf6 ; (+#1b) 
lab1bdb: cp #80 
lab1bdd: jr c,#1bf6 ; (+#17) 
lab1bdf: cp #a0 
lab1be1: ccf 
lab1be2: jr c,#1bf6 ; (+#12) 
;; begin expansion
lab1be4: ld h,a 
lab1be5: ld l,#00 
;; continue expansion
lab1be7: push de 
lab1be8: call #1cb3			; KM GET EXPAND 
lab1beb: jr c,#1bef 
;; write expansion pointer
lab1bed: ld h,#00 
lab1bef: inc l 
lab1bf0: ld (#b628),hl 
lab1bf3: pop de 
lab1bf4: jr nc,#1bd6 
lab1bf6: pop hl 
lab1bf7: ret 
;===========================================================================
;; reset returned key
lab1bf8: ld a,#ff 
;;===========================================================================
KM_CHAR_RETURN:
lab1bfa: ld (#b62a),a 
lab1bfd: ret 
;;===========================================================================
KM_FLUSH:
lab1bfe: call #1bc5			; KM READ CHAR 
lab1c01: jr c,#1bfe 
lab1c03: ret 
;;===========================================================================
KM_EXP_BUFFER:
lab1c04: call #1c0a 
lab1c07: ccf 
lab1c08: ei 
lab1c09: ret 
;;===========================================================================
lab1c0a: di 
lab1c0b: ld a,l 
lab1c0c: sub #31 
lab1c0e: ld a,h 
lab1c0f: sbc a,#00 
lab1c11: ret c 
lab1c12: add hl,de 
lab1c13: ld (#b62d),hl 
lab1c16: ex de,hl 
lab1c17: ld (#b62b),hl 
lab1c1a: ld bc,#0a30 
lab1c1d: ld (hl),#01 
lab1c1f: inc hl 
lab1c20: ld (hl),c 
lab1c21: inc hl 
lab1c22: inc c 
lab1c23: djnz #1c1d ; (-#08) 
lab1c25: ex de,hl 
lab1c26: ld hl,#1c3c					;; default expansion values 
lab1c29: ld c,#0a 
lab1c2b: ldir 
lab1c2d: ex de,hl 
lab1c2e: ld b,#13 
lab1c30: xor a 
lab1c31: ld (hl),a 
lab1c32: inc hl 
lab1c33: djnz #1c31 ; (-#04) 
lab1c35: ld (#b62f),hl 
lab1c38: ld (#b629),a 
lab1c3b: ret 
lab1c3c: 
defb #01
defb "."
defb #01
defb 13
defb #5
defb "RUN",#22,13
;;===========================================================================
KM_SET_EXPAND:
lab1c46: 	 ld 		a,b 
lab1c47: call #1cc3 
lab1c4a: ret nc 
lab1c4b: push bc 
lab1c4c: push de 
lab1c4d: push hl 
lab1c4e: call #1c6a 
lab1c51: ccf 
lab1c52: pop hl 
lab1c53: pop de 
lab1c54: pop bc 
lab1c55: ret nc 
lab1c56: dec de 
lab1c57: ld a,c 
lab1c58: inc c 
lab1c59: ld (de),a 
lab1c5a: inc de 
lab1c5b: rst #20				; RST 4 - LOW: RAM LAM 
lab1c5c: inc hl 
lab1c5d: dec c 
lab1c5e: jr nz,#1c59 ; (-#07) 
lab1c60: ld hl,#b629 
lab1c63: ld a,b 
lab1c64: xor (hl) 
lab1c65: jr nz,#1c68 ; (+#01) 
lab1c67: ld (hl),a 
lab1c68: scf 
lab1c69: ret 
;;===========================================================================
lab1c6a: ld b,#00 
lab1c6c: ld h,b 
lab1c6d: ld l,a 
lab1c6e: ld a,c 
lab1c6f: sub l 
lab1c70: ret z 
lab1c71: jr nc,#1c82 ; (+#0f) 
lab1c73: ld a,l 
lab1c74: ld l,c 
lab1c75: ld c,a 
lab1c76: add hl,de 
lab1c77: ex de,hl 
lab1c78: add hl,bc 
lab1c79: call #1ca7 
lab1c7c: jr z,#1ca1 ; (+#23) 
lab1c7e: ldir 
lab1c80: jr #1ca1 ; (+#1f) 
lab1c82: ld c,a 
lab1c83: add hl,de 
lab1c84: push hl 
lab1c85: ld hl,(#b62f) 
lab1c88: add hl,bc 
lab1c89: ex de,hl 
lab1c8a: ld hl,(#b62d) 
lab1c8d: ld a,l 
lab1c8e: sub e 
lab1c8f: ld a,h 
lab1c90: sbc a,d 
lab1c91: pop hl 
lab1c92: ret c 
lab1c93: call #1ca7 
lab1c96: ld hl,(#b62f) 
lab1c99: jr z,#1ca1 ; (+#06) 
lab1c9b: push de 
lab1c9c: dec de 
lab1c9d: dec hl 
lab1c9e: lddr 
lab1ca0: pop de 
lab1ca1: ld (#b62f),de 
lab1ca5: or a 
lab1ca6: ret 
;;===========================================================================
lab1ca7: ld a,(#b62f) 
lab1caa: sub l 
lab1cab: ld c,a 
lab1cac: ld a,(#b630) 
lab1caf: sbc a,h 
lab1cb0: ld b,a 
lab1cb1: or c 
lab1cb2: ret 
;;===========================================================================
KM_GET_EXPAND:
lab1cb3: call #1cc3 
lab1cb6: ret nc 
lab1cb7: cp l 
lab1cb8: ret z 
lab1cb9: ccf 
lab1cba: ret nc 
lab1cbb: push hl 
lab1cbc: ld h,#00 
lab1cbe: add hl,de 
lab1cbf: ld a,(hl) 
lab1cc0: pop hl 
lab1cc1: scf 
lab1cc2: ret 
;;===========================================================================
;; keycode above &7f not defineable?
lab1cc3: and #7f 
;; keys between &20-&7f are not defineable?
lab1cc5: cp #20 
lab1cc7: ret nc 
lab1cc8: push hl 
lab1cc9: ld hl,(#b62b) 
lab1ccc: ld de,#0000 
lab1ccf: inc a 
lab1cd0: add hl,de 
lab1cd1: ld e,(hl) 
lab1cd2: inc hl 
lab1cd3: dec a 
lab1cd4: jr nz,#1cd0 ; (-#06) 
lab1cd6: ld a,e 
lab1cd7: ex de,hl 
lab1cd8: pop hl 
lab1cd9: scf 
lab1cda: ret 
;;===========================================================================
KM_WAIT_KEY:
lab1cdb: call #1ce1			; KM READ KEY 
lab1cde: jr nc,#1cdb 
lab1ce0: ret 
;;===========================================================================
KM_READ_KEY:
lab1ce1: push hl 
lab1ce2: push bc 
lab1ce3: call #1e9d 
lab1ce6: jr nc,#1d22 ; (+#3a) 
lab1ce8: ld a,c 
lab1ce9: cp #ef 
lab1ceb: jr z,#1d21 ; (+#34) 
lab1ced: and #0f 
lab1cef: add a,a 
lab1cf0: add a,a 
lab1cf1: add a,a 
lab1cf2: dec a 
lab1cf3: inc a 
lab1cf4: rrc b 
lab1cf6: jr nc,#1cf3 ; (-#05) 
lab1cf8: call #1d25 
lab1cfb: ld hl,#b632 
lab1cfe: bit 7,(hl) 
lab1d00: jr z,#1d0c ; (+#0a) 
lab1d02: cp #61 
lab1d04: jr c,#1d0c ; (+#06) 
lab1d06: cp #7b 
lab1d08: jr nc,#1d0c ; (+#02) 
lab1d0a: add a,#e0 
lab1d0c: cp #ff 
lab1d0e: jr z,#1ce3 ; (-#2d) 
lab1d10: cp #fe 
lab1d12: ld hl,#b631 
lab1d15: jr z,#1d1c ; (+#05) 
lab1d17: cp #fd 
lab1d19: inc hl 
lab1d1a: jr nz,#1d21 ; (+#05) 
lab1d1c: ld a,(hl) 
lab1d1d: cpl 
lab1d1e: ld (hl),a 
lab1d1f: jr #1ce3 ; (-#3e) 
lab1d21: scf 
lab1d22: pop bc 
lab1d23: pop hl 
lab1d24: ret 
;;===========================================================================
lab1d25: rl c 
lab1d27: jp c,#1ece			; KM GET CONTROL 
lab1d2a: ld b,a 
lab1d2b: ld a,(#b631) 
lab1d2e: or c 
lab1d2f: and #40 
lab1d31: ld a,b 
lab1d32: jp nz,#1ec9			; KM GET SHIFT 
lab1d35: jp #1ec4			; KM GET TRANSLATE 
;;===========================================================================
KM_GET_STATE:
lab1d38: ld hl,(#b631) 
lab1d3b: ret 
;;===========================================================================
KM_SET_LOCKS:
lab1d3c: ld (#b631),hl 
lab1d3f: ret 
;;===========================================================================
IND_KM_SCAN_KEYS:
lab1d40: ld de,#b649			; buffer for keys that have changed 
lab1d43: ld hl,#b63f			; buffer for current state of key matrix 
; if a bit is ''0'' then key is pressed,
; if a bit is ''1'' then key is released.
lab1d46: call #0883			; scan keyboard 
;;b635-b63e
;;b63f-b648
;;b649-b652 (keyboard line 0-10 inclusive)
lab1d49: ld a,(#b64b)		; keyboard line 2 
lab1d4c: and #a0				; isolate change state of CTRL and SHIFT keys 
lab1d4e: ld c,a 
lab1d4f: ld hl,#b637 
lab1d52: or (hl) 
lab1d53: ld (hl),a 
;;----------------------------------------------------------------------
lab1d54: ld hl,#b649 
lab1d57: ld de,#b635 
lab1d5a: ld b,#00 
lab1d5c: ld a,(de) 
lab1d5d: xor (hl) 
lab1d5e: and (hl) 
lab1d5f: call nz,#1dd1 
lab1d62: ld a,(hl) 
lab1d63: ld (de),a 
lab1d64: inc hl 
lab1d65: inc de 
lab1d66: inc c 
lab1d67: ld a,c 
lab1d68: and #0f 
lab1d6a: cp #0a 
lab1d6c: jr nz,#1d5c ; (-#12) 
;;---------------------------------------------------------------------
lab1d6e: ld a,c 
lab1d6f: and #a0 
lab1d71: bit 6,c 
lab1d73: ld c,a 
lab1d74: call nz,#bdee			; IND: KM TEST BREAK 
lab1d77: ld a,b 
lab1d78: or a 
lab1d79: ret nz 
lab1d7a: ld hl,#b653 
lab1d7d: dec (hl) 
lab1d7e: ret nz 
lab1d7f: ld hl,(#b654) 
lab1d82: ex de,hl 
lab1d83: ld b,d 
lab1d84: ld d,#00 
lab1d86: ld hl,#b635 
lab1d89: add hl,de 
lab1d8a: ld a,(hl) 
lab1d8b: ld hl,(#b691) 
lab1d8e: add hl,de 
lab1d8f: and (hl) 
lab1d90: and b 
lab1d91: ret z 
lab1d92: ld hl,#b653 
lab1d95: inc (hl) 
lab1d96: ld a,(#b68a) 
lab1d99: or a 
lab1d9a: ret nz 
lab1d9b: ld a,c 
lab1d9c: or e 
lab1d9d: ld c,a 
lab1d9e: ld a,(#b633) 
lab1da1: ld (#b653),a 
lab1da4: call #1e86 
lab1da7: ld a,c 
lab1da8: and #0f 
lab1daa: ld l,a 
lab1dab: ld h,b 
lab1dac: ld (#b654),hl 
lab1daf: cp #08 
lab1db1: ret nz 
lab1db2: bit 4,b 
lab1db4: ret nz 
lab1db5: set 6,c 
lab1db7: ret 
;;=====================================================================================
IND_KM_TEST_BREAK:
lab1db8: ld hl,#b63d 
lab1dbb: bit 2,(hl) 
lab1dbd: ret z 
lab1dbe: ld a,c 
lab1dbf: xor #a0 
lab1dc1: jr nz,#1e19 ; KM BREAK EVENT 
lab1dc3: push bc 
lab1dc4: inc hl 
lab1dc5: ld b,#0a 
lab1dc7: adc a,(hl) 
lab1dc8: dec hl 
lab1dc9: djnz #1dc7 ; (-#04) 
lab1dcb: pop bc 
lab1dcc: cp #a4 
lab1dce: jr nz,#1e19 ; KM BREAK EVENT 
;; do reset
lab1dd0: rst #00 
;;====================================================================
lab1dd1: push hl 
lab1dd2: push de 
lab1dd3: ld e,a 
lab1dd4: cpl 
lab1dd5: inc a 
lab1dd6: and e 
lab1dd7: ld b,a 
lab1dd8: ld a,(#b634) 
lab1ddb: call #1da1 
lab1dde: ld a,b 
lab1ddf: xor e 
lab1de0: jr nz,#1dd3 ; (-#0f) 
lab1de2: pop de 
lab1de3: pop hl 
lab1de4: ret 
;;===========================================================================
KM_GET_JOYSTICK:
lab1de5: ld a,(#b63b) 
lab1de8: and #7f 
lab1dea: ld l,a 
lab1deb: ld a,(#b63e) 
lab1dee: and #7f 
lab1df0: ld h,a 
lab1df1: ret 
;;===========================================================================
KM_GET_DELAY:
lab1df2: ld hl,(#b633) 
lab1df5: ret 
;;===========================================================================
KM_SET_DELAY:
lab1df6: ld (#b633),hl 
lab1df9: ret 
;;===========================================================================
KM_ARM_BREAK:
lab1dfa: call #1e0b			; KM DISARM BREAK 
lab1dfd: ld hl,#b657 
lab1e00: ld b,#40 
lab1e02: call #01d2			; KL INIT EVENT 
lab1e05: ld a,#ff 
lab1e07: ld (#b656),a 
lab1e0a: ret 
;;===========================================================================
KM_DISARM_BREAK:
lab1e0b: push bc 
lab1e0c: push de 
lab1e0d: ld hl,#b656 
lab1e10: ld (hl),#00 
lab1e12: inc hl 
lab1e13: call #0284			; KL DEL SYNCHRONOUS 
lab1e16: pop de 
lab1e17: pop bc 
lab1e18: ret 
;;===========================================================================
KM_BREAK_EVENT:
lab1e19: ld hl,#b656 
lab1e1c: ld a,(hl) 
lab1e1d: ld (hl),#00 
lab1e1f: cp (hl) 
lab1e20: ret z 
lab1e21: push bc 
lab1e22: push de 
lab1e23: inc hl 
lab1e24: call #01e2			; KL EVENT 
lab1e27: ld c,#ef 
lab1e29: call #1e86 
lab1e2c: pop de 
lab1e2d: pop bc 
lab1e2e: ret 
;;===========================================================================
KM_GET_REPEAT:
lab1e2f: ld hl,(#b691) 
lab1e32: jr #1e50 ; (+#1c) 
;;===========================================================================
KM_SET_REPEAT:
lab1e34: cp #50 
lab1e36: ret nc 
lab1e37: ld hl,(#b691) 
lab1e3a: call #1e55 
lab1e3d: cpl 
lab1e3e: ld c,a 
lab1e3f: ld a,(hl) 
lab1e40: xor b 
lab1e41: and c 
lab1e42: xor b 
lab1e43: ld (hl),a 
lab1e44: ret 
;;===========================================================================
KM_TEST_KEY:
lab1e45: push af 
lab1e46: ld a,(#b637) 
lab1e49: and #a0 
lab1e4b: ld c,a 
lab1e4c: pop af 
lab1e4d: ld hl,#b635 
lab1e50: call #1e55 
lab1e53: and (hl) 
lab1e54: ret 
;;===========================================================================
lab1e55: push de 
lab1e56: push af 
lab1e57: and #f8 
lab1e59: rrca 
lab1e5a: rrca 
lab1e5b: rrca 
lab1e5c: ld e,a 
lab1e5d: ld d,#00 
lab1e5f: add hl,de 
lab1e60: pop af 
lab1e61: push hl 
lab1e62: ld hl,#1e6d 
lab1e65: and #07 
lab1e67: ld e,a 
lab1e68: add hl,de 
lab1e69: ld a,(hl) 
lab1e6a: pop hl 
lab1e6b: pop de 
lab1e6c: ret 
;;===========================================================================
;; table to convert from bit index (0-7) to bit OR mask (1<<bit index)
lab1e6d: 
defb #01,#02,#04,#08,#10,#20,#40,#80
;;===========================================================================
lab1e75: di 
lab1e76: ld hl,#b686 
lab1e79: ld (hl),#15 
lab1e7b: inc hl 
lab1e7c: xor a 
lab1e7d: ld (hl),a 
lab1e7e: inc hl 
lab1e7f: ld (hl),#01 
lab1e81: inc hl 
lab1e82: ld (hl),a 
lab1e83: inc hl 
lab1e84: ld (hl),a 
lab1e85: ret 
;;===========================================================================
lab1e86: ld hl,#b686 
lab1e89: or a 
lab1e8a: dec (hl) 
lab1e8b: jr z,#1e9b ; (+#0e) 
lab1e8d: call #1eb4 
lab1e90: ld (hl),c 
lab1e91: inc hl 
lab1e92: ld (hl),b 
lab1e93: ld hl,#b68a 
lab1e96: inc (hl) 
lab1e97: ld hl,#b688 
lab1e9a: scf 
lab1e9b: inc (hl) 
lab1e9c: ret 
;;===========================================================================
lab1e9d: ld hl,#b688 
lab1ea0: or a 
lab1ea1: dec (hl) 
lab1ea2: jr z,#1eb2 ; (+#0e) 
lab1ea4: call #1eb4 
lab1ea7: ld c,(hl) 
lab1ea8: inc hl 
lab1ea9: ld b,(hl) 
lab1eaa: ld hl,#b68a 
lab1ead: dec (hl) 
lab1eae: ld hl,#b686 
lab1eb1: scf 
lab1eb2: inc (hl) 
lab1eb3: ret 
;;===========================================================================
lab1eb4: inc hl 
lab1eb5: inc (hl) 
lab1eb6: ld a,(hl) 
lab1eb7: cp #14 
lab1eb9: jr nz,#1ebd ; (+#02) 
lab1ebb: xor a 
lab1ebc: ld (hl),a 
lab1ebd: add a,a 
lab1ebe: add a,#5e 
lab1ec0: ld l,a 
lab1ec1: ld h,#b6 
lab1ec3: ret 
;;===========================================================================
KM_GET_TRANSLATE:
lab1ec4: ld hl,(#b68b) 
lab1ec7: jr #1ed1 ; (+#08) 
;;===========================================================================
KM_GET_SHIFT:
lab1ec9: ld hl,(#b68d) 
lab1ecc: jr #1ed1 ; (+#03) 
;;===========================================================================
KM_GET_CONTROL:
lab1ece: ld hl,(#b68f) 
lab1ed1: add a,l 
lab1ed2: ld l,a 
lab1ed3: adc a,h 
lab1ed4: sub l 
lab1ed5: ld h,a 
lab1ed6: ld a,(hl) 
lab1ed7: ret 
;;===========================================================================
KM_SET_TRANSLATE:
lab1ed8: ld hl,(#b68b) 
lab1edb: jr #1ee5 ; (+#08) 
;;===========================================================================
KM_SET_SHIFT:
lab1edd: ld hl,(#b68d) 
lab1ee0: jr #1ee5 ; (+#03) 
;;===========================================================================
KM_SET_CONTROL:
lab1ee2: ld hl,(#b68f) 
lab1ee5: cp #50 
lab1ee7: ret nc 
lab1ee8: add a,l 
lab1ee9: ld l,a 
lab1eea: adc a,h 
lab1eeb: sub l 
lab1eec: ld h,a 
lab1eed: ld (hl),b 
lab1eee: ret 
;;------------------------------------------------------
;; keyboard translation table
lab1eef: ret p 
lab1ef0: di 
lab1ef1: pop af 
lab1ef2: adc a,c 
lab1ef3: add a,(hl) 
lab1ef4: add a,e 
lab1ef5: adc a,e 
lab1ef6: adc a,d 
lab1ef7: jp p,#87e0 
lab1efa: adc a,b 
lab1efb: add a,l 
lab1efc: add a,c 
lab1efd: add a,d 
lab1efe: add a,b 
lab1eff: djnz #1f5c ; (+#5b) 
lab1f01: dec c 
lab1f02: ld e,l 
lab1f03: add a,h 
lab1f04: rst #38 
lab1f05: ld e,h 
lab1f06: rst #38 
lab1f07: ld e,(hl) 
lab1f08: dec l 
lab1f09: ld b,b 
lab1f0a: ld (hl),b 
lab1f0b: dec sp 
lab1f0c: ld a,(#2e2f) 
lab1f0f: jr nc,#1f4a ; (+#39) 
lab1f11: ld l,a 
lab1f12: ld l,c 
lab1f13: ld l,h 
lab1f14: ld l,e 
lab1f15: ld l,l 
lab1f16: inc l 
lab1f17: jr c,#1f50 ; (+#37) 
lab1f19: ld (hl),l 
lab1f1a: ld a,c 
lab1f1b: ld l,b 
lab1f1c: ld l,d 
lab1f1d: ld l,(hl) 
lab1f1e: jr nz,#1f56 ; (+#36) 
lab1f20: dec (hl) 
lab1f21: ld (hl),d 
lab1f22: ld (hl),h 
lab1f23: ld h,a 
lab1f24: ld h,(hl) 
lab1f25: ld h,d 
lab1f26: halt 
lab1f27: inc (hl) 
lab1f28: inc sp 
lab1f29: ld h,l 
lab1f2a: ld (hl),a 
lab1f2b: ld (hl),e 
lab1f2c: ld h,h 
lab1f2d: ld h,e 
lab1f2e: ld a,b 
lab1f2f: ld sp,#fc32 
lab1f32: ld (hl),c 
lab1f33: add hl,bc 
lab1f34: ld h,c 
lab1f35: defb #fd,#7a ;ld a,d 
lab1f37: dec bc 
lab1f38: ld a,(bc) 
lab1f39: ex af,af'' 
lab1f3a: add hl,bc 
lab1f3b: ld e,b 
lab1f3c: ld e,d 
lab1f3d: rst #38 
lab1f3e: ld a,a 
lab1f3f: call p,#f5f7 
lab1f42: adc a,c 
lab1f43: add a,(hl) 
lab1f44: add a,e 
lab1f45: adc a,e 
lab1f46: adc a,d 
lab1f47: or #e0 
lab1f49: add a,a 
lab1f4a: adc a,b 
lab1f4b: add a,l 
lab1f4c: add a,c 
lab1f4d: add a,d 
lab1f4e: add a,b 
lab1f4f: djnz #1fcc ; (+#7b) 
lab1f51: dec c 
lab1f52: ld a,l 
lab1f53: add a,h 
lab1f54: rst #38 
lab1f55: ld h,b 
lab1f56: rst #38 
lab1f57: and e 
lab1f58: dec a 
lab1f59: ld a,h 
lab1f5a: ld d,b 
lab1f5b: dec hl 
lab1f5c: ld hl,(#3e3f) 
lab1f5f: ld e,a 
lab1f60: add hl,hl 
lab1f61: ld c,a 
lab1f62: ld c,c 
lab1f63: ld c,h 
lab1f64: ld c,e 
lab1f65: ld c,l 
lab1f66: inc a 
lab1f67: jr z,#1f90 ; (+#27) 
lab1f69: ld d,l 
lab1f6a: ld e,c 
lab1f6b: ld c,b 
lab1f6c: ld c,d 
lab1f6d: ld c,(hl) 
lab1f6e: jr nz,#1f96 ; (+#26) 
lab1f70: dec h 
lab1f71: ld d,d 
lab1f72: ld d,h 
lab1f73: ld b,a 
lab1f74: ld b,(hl) 
lab1f75: ld b,d 
lab1f76: ld d,(hl) 
lab1f77: inc h 
lab1f78: inc hl 
lab1f79: ld b,l 
lab1f7a: ld d,a 
lab1f7b: ld d,e 
lab1f7c: ld b,h 
lab1f7d: ld b,e 
lab1f7e: ld e,b 
lab1f7f: ld hl,#fc22 
lab1f82: ld d,c 
lab1f83: add hl,bc 
lab1f84: ld b,c 
lab1f85: defb #fd,#5a ;ld e,d 
lab1f87: dec bc 
lab1f88: ld a,(bc) 
lab1f89: ex af,af'' 
lab1f8a: add hl,bc 
lab1f8b: ld e,b 
lab1f8c: ld e,d 
lab1f8d: rst #38 
lab1f8e: ld a,a 
lab1f8f: ret m 
lab1f90: ei 
lab1f91: ld sp,hl 
lab1f92: adc a,c 
lab1f93: add a,(hl) 
lab1f94: add a,e 
lab1f95: adc a,h 
lab1f96: adc a,d 
lab1f97: jp m,#87e0 
lab1f9a: adc a,b 
lab1f9b: add a,l 
lab1f9c: add a,c 
lab1f9d: add a,d 
lab1f9e: add a,b 
lab1f9f: djnz #1fbc ; (+#1b) 
lab1fa1: dec c 
lab1fa2: dec e 
lab1fa3: add a,h 
lab1fa4: rst #38 
lab1fa5: inc e 
lab1fa6: rst #38 
lab1fa7: ld e,#ff 
lab1fa9: nop 
lab1faa: djnz #1fab ; (-#01) 
lab1fac: rst #38 
lab1fad: rst #38 
lab1fae: rst #38 
lab1faf: rra 
lab1fb0: rst #38 
lab1fb1: rrca 
lab1fb2: add hl,bc 
lab1fb3: inc c 
lab1fb4: dec bc 
lab1fb5: dec c 
lab1fb6: rst #38 
lab1fb7: rst #38 
lab1fb8: rst #38 
lab1fb9: dec d 
lab1fba: add hl,de 
lab1fbb: ex af,af'' 
lab1fbc: ld a,(bc) 
lab1fbd: ld c,#ff 
lab1fbf: rst #38 
lab1fc0: rst #38 
lab1fc1: ld (de),a 
lab1fc2: inc d 
lab1fc3: rlca 
lab1fc4: ld b,#02 
lab1fc6: ld d,#ff 
lab1fc8: rst #38 
lab1fc9: dec b 
lab1fca: rla 
lab1fcb: inc de 
lab1fcc: inc b 
lab1fcd: inc bc 
lab1fce: jr #1fcf ; (-#01) 
lab1fd0: ld a,(hl) 
lab1fd1: call m,#e111 
lab1fd4: ld bc,#1afe 
lab1fd7: rst #38 
lab1fd8: rst #38 
lab1fd9: rst #38 
lab1fda: rst #38 
lab1fdb: rst #38 
lab1fdc: rst #38 
lab1fdd: rst #38 
lab1fde: ld a,a 
lab1fdf: rlca 
lab1fe0: inc bc 
lab1fe1: ld c,e 
lab1fe2: rst #38 
lab1fe3: rst #38 
lab1fe4: rst #38 
lab1fe5: rst #38 
lab1fe6: rst #38 
lab1fe7: xor e 
lab1fe8: adc a,a 
;;============================================================================
SOUND_RESET:
;; for each channel:
;; $00 - channel number (0,1,2)
;; $01 - mixer value for tone (also used for active mask)
;; $02 - mixer value for noise
;; $03 - status
;; status bit 0=rendezvous channel A
;; status bit 1=rendezvous channel B
;; status bit 2=rendezvous channel C
;; status bit 3=hold
;; $04 - bit 0 = tone envelope active
;; $07 - bit 0 = volume envelope active
;; $08,$09 - duration of sound or envelope repeat count
;; $0a,$0b - volume envelope pointer reload
;; $0c - volume envelope step down count
;; $0d,$0e - current volume envelope pointer
;; $0f - current volume for channel (bit 7 set if has noise)
;; $10 - volume envelope current step down count
;; $11,$12 - tone envelope pointer reload
;; $13 - number of sections in tone remaining
;; $14,$15 - current tone pointer
;; $16 - low byte tone for channel
;; $17 - high byte tone for channel
;; $18 - tone envelope current step down count
;; $19 - read position in queue
;; $1a - number of items in the queue
;; $1b - write position in queue
;; $1c - number of items free in queue
;; $1d - low byte event 
;; $1e - high byte event (set to 0 to disarm event)
lab1fe9: ld hl,#b1ed			; channels active at SOUND HOLD 
;; clear flags
;; b1ed - channels active at SOUND HOLD
;; b1ee - sound channels active
;; b1ef - sound timer?
;; b1f0 - ??
lab1fec: ld b,#04 
lab1fee: ld (hl),#00 
lab1ff0: inc hl 
lab1ff1: djnz #1fee 
;; HL  = event block (b1f1)
lab1ff3: ld de,#208b			;; sound event function 
lab1ff6: ld b,#81			;; asynchronous event, near address 
;; C = rom select, but unused because it''s a near address
lab1ff8: call #01d2			; KL INIT EVENT 
lab1ffb: ld a,#3f			; default mixer value (noise/tone off + I/O) 
lab1ffd: ld (#b2b5),a 
lab2000: ld hl,#b1f8			;; data for channel A 
lab2003: ld bc,#003d			;; size of data for each channel 
lab2006: ld de,#0108			;; D = mixer value for tone (channel A) 
;; E = mixer value for noise (channel A)
;; initialise channel data
lab2009: xor a 
lab200a: ld (hl),a 			;; channel number 
lab200b: inc hl 
lab200c: ld (hl),d			;; mixer tone for channel 
lab200d: inc hl 
lab200e: ld (hl),e			;; mixer noise for channel 
lab200f: add hl,bc			;; update channel data pointer 
lab2010: inc a				;; increment channel number 
lab2011: ex de,hl			;; update tone/noise mixer for next channel shifting it left once 
lab2012: add hl,hl 
lab2013: ex de,hl 
lab2014: cp #03				;; setup all channels? 
lab2016: jr nz,#200a 
lab2018: ld c,#07			; all channels active 
lab201a: push ix 
lab201c: push hl 
lab201d: ld hl,#b1f0 
lab2020: inc (hl) 
lab2021: push hl 
lab2022: ld ix,#b1b9 
lab2026: ld a,c				; channels active 
lab2027: call #2209			;; get next active channel 
lab202a: push af 
lab202b: push bc 
lab202c: call #2286			;; update channels that are active 
lab202f: call #23e7			;; disable channel 
lab2032: push ix 
lab2034: pop de 
lab2035: inc de 
lab2036: inc de 
lab2037: inc de 
lab2038: ld l,e 
lab2039: ld h,d 
lab203a: inc de 
lab203b: ld bc,#003b 
lab203e: ld (hl),#00 
lab2040: ldir 
lab2042: ld (ix+#1c),#04		;; number of spaces in queue 
lab2046: pop bc 
lab2047: pop af 
lab2048: jr nz,#2027 ; (-#23) 
lab204a: pop hl 
lab204b: dec (hl) 
lab204c: pop hl 
lab204d: pop ix 
lab204f: ret 
;;==========================================================================
SOUND_HOLD:
;;
;; - Stop firmware handling sound
;; - turn off all volume registers
;;
;; carry false - already stopped
;; carry true - sound has been held
lab2050: ld hl,#b1ee				;; sound channels active 
lab2053: di 
lab2054: ld a,(hl)				;; get channels that were active 
lab2055: ld (hl),#00 			;; no channels active 
lab2057: ei 
lab2058: or a					;; already stopped? 
lab2059: ret z 
lab205a: dec hl 
lab205b: ld (hl),a				;; channels held 
;; set all AY volume registers to zero to silence sound
lab205c: ld l,#03 
lab205e: ld c,#00			; set zero volume 
lab2060: ld a,#07			; AY Mixer register 
lab2062: add a,l				; add on value to get volume register 
; A = AY volume register (10,9,8)
lab2063: call #0863			; MC SOUND REGISTER 
lab2066: dec l 
lab2067: jr nz,#2060 
lab2069: scf 
lab206a: ret 
;;==========================================================================
SOUND_CONTINUE:
lab206b: ld de,#b1ed	;; channels active at SOUND HELD 
lab206e: ld a,(de) 
lab206f: or a 
lab2070: ret z 
;; at least one channel was held
lab2071: push de 
lab2072: ld ix,#b1b9 
lab2076: call #2209			; get next active channel 
lab2079: push af 
lab207a: ld a,(ix+#0f)		; volume for channel 
lab207d: call c,#23de			; set channel volume 
lab2080: pop af 
lab2081: jr nz,#2076 ;repeat next held channel 
lab2083: ex (sp),hl 
lab2084: ld a,(hl) 
lab2085: ld (hl),#00 
lab2087: inc hl 
lab2088: ld (hl),a 
lab2089: pop hl 
lab208a: ret 
;;===============================================================================
;; sound processing function
lab208b: push ix 
lab208d: ld a,(#b1ee)		; sound channels active 
lab2090: or a 
lab2091: jr z,#20d0 
;; A = channel to process
lab2093: push af 
lab2094: ld ix,#b1b9 
lab2098: ld bc,#003f 
lab209b: add ix,bc 
lab209d: srl a 
lab209f: jr nc,#209b 
lab20a1: push af 
lab20a2: ld a,(ix+#04) 
lab20a5: rra 
lab20a6: call c,#241f			; update tone envelope 
lab20a9: ld a,(ix+#07) 
lab20ac: rra 
lab20ad: call c,#231f			; update volume envelope 
lab20b0: call c,#2213			; process queue 
lab20b3: pop af 
lab20b4: jr nz,#2098 ;; process next..? 
lab20b6: pop bc 
lab20b7: ld a,(#b1ee)		; sound channels active 
lab20ba: cpl 
lab20bb: and b 
lab20bc: jr z,#20d0 ; (+#12) 
lab20be: ld ix,#b1b9 
lab20c2: ld de,#003f 
lab20c5: add ix,de 
lab20c7: srl a 
lab20c9: push af 
lab20ca: call c,#23e7			; mixer 
lab20cd: pop af 
lab20ce: jr nz,#20c5 ; (-#0b) 
;; ???
lab20d0: xor a 
lab20d1: ld (#b1f0),a 
lab20d4: pop ix 
lab20d6: ret 
;;------------------------------------------------------------------
;; process sound
lab20d7: ld hl,#b1ee		;; sound active flag? 
lab20da: ld a,(hl) 
lab20db: or a 
lab20dc: ret z 
;; sound is active
lab20dd: inc hl			;; sound timer? 
lab20de: dec (hl) 
lab20df: ret nz 
lab20e0: ld b,a 
lab20e1: inc (hl) 
lab20e2: inc hl 
lab20e3: ld a,(hl)		;; b1f0 
lab20e4: or a 
lab20e5: ret nz 
lab20e6: dec hl 
lab20e7: ld (hl),#03 
lab20e9: ld hl,#b1be 
lab20ec: ld de,#003f 
lab20ef: xor a 
lab20f0: add hl,de 
lab20f1: srl b 
lab20f3: jr nc,#20f0 ; (-#05) 
lab20f5: dec (hl) 
lab20f6: jr nz,#20fd ; (+#05) 
lab20f8: dec hl 
lab20f9: rlc (hl) 
lab20fb: adc a,d 
lab20fc: inc hl 
lab20fd: inc hl 
lab20fe: dec (hl) 
lab20ff: jr nz,#2106 ; (+#05) 
lab2101: inc hl 
lab2102: rlc (hl) 
lab2104: adc a,d 
lab2105: dec hl 
lab2106: dec hl 
lab2107: inc b 
lab2108: djnz #20f0 ; (-#1a) 
lab210a: or a 
lab210b: ret z 
lab210c: ld hl,#b1f0 
lab210f: ld (hl),a 
lab2110: inc hl 
;; HL = event block
;; kick off event
lab2111: jp #01e2			; KL EVENT 
;;============================================================================
SOUND_QUEUE:
;; HL = sound data
;;byte 0 - channel status byte 
;; bit 0 = send sound to channel A
;; bit 1 = send sound to channel B
;; bit 2 = send sound to channel C
;; bit 3 = rendezvous with channel A
;; bit 4 = rendezvous with channel B
;; bit 5 = rendezvous with channel C
;; bit 6 = hold sound channel
;; bit 7 = flush sound channel
;;byte 1 - volume envelope to use 
;;byte 2 - tone envelope to use 
;;bytes 3&4 - tone period (0 = no tone)
;;byte 5 - noise period (0 = no noise)
;;byte 6 - start volume 
;;bytes 7&8 - duration of the sound, or envelope repeat count 
lab2114: call #206b			; SOUND CONTINUE 
lab2117: ld a,(hl)			; channel status byte 
lab2118: and #07 
lab211a: scf 
lab211b: ret z 
lab211c: ld c,a 
lab211d: or (hl) 
lab211e: call m,#201a 
lab2121: ld b,c 
lab2122: ld ix,#b1b9 
;; get channel address
lab2126: ld de,#003f 
lab2129: xor a 
lab212a: add ix,de 
lab212c: srl b 
lab212e: jr nc,#212a ; (-#06) 
lab2130: ld (ix+#1e),d		;; disarm event 
lab2133: cp (ix+#1c)			;; number of spaces in queue 
lab2136: ccf 
lab2137: sbc a,a 
lab2138: inc b 
lab2139: djnz #212a 
lab213b: or a 
lab213c: ret nz 
lab213d: ld b,c 
lab213e: ld a,(hl)			;; channel status 
lab213f: rra 
lab2140: rra 
lab2141: rra 
lab2142: or b 
lab2143: and #0f 
lab2145: ld c,a 
lab2146: push hl 
lab2147: ld hl,#b1f0 
lab214a: inc (hl) 
lab214b: ex (sp),hl 
lab214c: inc hl 
lab214d: ld ix,#b1b9 
lab2151: ld de,#003f 
lab2154: add ix,de 
lab2156: srl b 
lab2158: jr nc,#2154 ; (-#06) 
lab215a: push hl 
lab215b: push bc 
lab215c: ld a,(ix+#1b)		; write pointer in queue 
lab215f: inc (ix+#1b)			; increment for next item 
lab2162: dec (ix+#1c)			;; number of spaces in queue 
lab2165: ex de,hl 
lab2166: call #219c		;; get sound queue slot 
lab2169: push hl 
lab216a: ex de,hl 
lab216b: ld a,(ix+#01)		;; channel''s active flag 
lab216e: cpl 
lab216f: and c 
lab2170: ld (de),a 
lab2171: inc de 
lab2172: ld a,(hl) 
lab2173: inc hl 
lab2174: add a,a 
lab2175: add a,a 
lab2176: add a,a 
lab2177: add a,a 
lab2178: ld b,a 
lab2179: ld a,(hl) 
lab217a: inc hl 
lab217b: and #0f 
lab217d: or b 
lab217e: ld (de),a 
lab217f: inc de 
lab2180: ld bc,#0006 
lab2183: ldir 
lab2185: pop hl 
lab2186: ld a,(ix+#1a)		;; number of items in the queue 
lab2189: inc (ix+#1a) 
lab218c: or (ix+#03)			;; status 
lab218f: call z,#221f 
lab2192: pop bc 
lab2193: pop hl 
lab2194: inc b 
lab2195: djnz #2151 
lab2197: ex (sp),hl 
lab2198: dec (hl) 
lab2199: pop hl 
lab219a: scf 
lab219b: ret 
;; A = index in queue
lab219c: and #03 
lab219e: add a,a 
lab219f: add a,a 
lab21a0: add a,a 
lab21a1: add a,#1f 
lab21a3: push ix 
lab21a5: pop hl 
lab21a6: add a,l 
lab21a7: ld l,a 
lab21a8: adc a,h 
lab21a9: sub l 
lab21aa: ld h,a 
lab21ab: ret 
;;==========================================================================
SOUND_RELEASE:
lab21ac: ld l,a 
lab21ad: call #206b			; SOUND CONTINUE 
lab21b0: ld a,l 
lab21b1: and #07 
lab21b3: ret z 
lab21b4: ld hl,#b1f0 
lab21b7: inc (hl) 
lab21b8: push hl 
lab21b9: ld ix,#b1b9 
lab21bd: call #2209			; get next active channel 
lab21c0: push af 
lab21c1: bit 3,(ix+#03)		 ; held? 
lab21c5: call nz,#2219			 ; process queue item 
lab21c8: pop af 
lab21c9: jr nz,#21bd ; (-#0e) 
lab21cb: pop hl 
lab21cc: dec (hl) 
lab21cd: ret 
;;============================================================================
SOUND_CHECK:
;; in:
;; bit 0 = channel 0
;; bit 1 = channel 1
;; bit 2 = channel 2
;;
;; result:
;; xxxxx000 - not allowed
;; xxxxx001 - 0
;; xxxxx010 - 1
;; xxxxx011 - 0
;; xxxxx100 - 2
;; xxxxx101 - 0
;; xxxxx110 - 1
;; xxxxx111 - 2
;; out:
;;bits 0 to 2 - the number of free spaces in the sound queue 
;;bit 3 - trying to rendezvous with channel A 
;;bit 4 - trying to rendezvous with channel B 
;;bit 5 - trying to rendezvous with channel C 
;;bit 6 - holding the channel 
;;bit 7 - producing a sound 
lab21ce: and #07 
lab21d0: ret z 
lab21d1: ld hl,#b1bc			;; sound data - 63 
lab21d4: ld de,#003f			;; 63 
lab21d7: add hl,de 
lab21d8: rra 
lab21d9: jr nc,#21d7 ;; bit a zero? 
lab21db: di 
lab21dc: ld a,(hl) 
lab21dd: add a,a		;; x2 
lab21de: add a,a		;; x4 
lab21df: add a,a		;; x8 
lab21e0: ld de,#0019 
lab21e3: add hl,de 
lab21e4: or (hl) 
lab21e5: inc hl 
lab21e6: inc hl 
lab21e7: ld (hl),#00 
lab21e9: ei 
lab21ea: ret 
;;============================================================================
SOUND_ARM_EVENT:
;; 
;; Sets up an event which will be activated when a space occurs in a sound queue.
;; if there is space the event is kicked immediately.
;;
;;
;; a:
;; bit 0 = channel 0
;; bit 1 = channel 1
;; bit 2 = channel 2
;; 
;; result:
;; xxxxx000 - not allowed
;; xxxxx001 - 0
;; xxxxx010 - 1
;; xxxxx011 - 0
;; xxxxx100 - 2
;; xxxxx101 - 0
;; xxxxx110 - 1
;; xxxxx111 - 2
;;
;; HL = event function
lab21eb: and #07 
lab21ed: ret z 
lab21ee: ex de,hl			;; DE = event function 
;; get address of data
lab21ef: ld hl,#b1d5 
lab21f2: ld bc,#003f 
lab21f5: add hl,bc 
lab21f6: rra 
lab21f7: jr nc,#21f5 
lab21f9: xor a				;; 0=no space in queue. !=0 space in the queue 
lab21fa: di 					;; stop event processing changing the value (this is a data fence) 
lab21fb: cp (hl)				;; +#1c -> number of events remaining in queue 
lab21fc: jr nz,#21ff ;; if it has space, disarm and call 
;; no space in the queue, arm the event
lab21fe: ld a,d 
;; write function
lab21ff: inc hl 
lab2200: ld (hl),e			;; +#1d 
lab2201: inc hl 
lab2202: ld (hl),a			;; +#1e if zero means event is disarmed 
lab2203: ei 
lab2204: ret z				;; queue is full 
;; queue has space
lab2205: ex de,hl 
lab2206: jp #01e2			; KL EVENT 
;;==================================================================================
;; get next active channel
;; A = channel mask (updated)
;; IX = channel pointer
lab2209: ld de,#003f			; 63 
lab220c: add ix,de 
lab220e: srl a 
lab2210: ret c 
lab2211: jr #220c ; (-#07) 
;;==================================================================================
lab2213: ld a,(ix+#1a)		; has items in the queue 
lab2216: or a 
lab2217: jr z,#2286 
;; process queue item
lab2219: ld a,(ix+#19)		; read pointer in queue 
lab221c: call #219c			; get sound queue slot 
;;----------------------------
lab221f: ld a,(hl)			; channel status byte 
;; bit 0=rendezvous channel A
;; bit 1=rendezvous channel B
;; bit 2=rendezvous channel C
;; bit 3=hold
lab2220: or a 
lab2221: jr z,#2230 
lab2223: bit 3,a				; hold channel? 
lab2225: jr nz,#2280 ; 
lab2227: push hl 
lab2228: ld (hl),#00 
lab222a: call #2290			; process rendezvous 
lab222d: pop hl 
lab222e: jr nc,#2286 
lab2230: ld (ix+#03),#10		; playing 
lab2234: inc hl 
lab2235: ld a,(hl)			; 
lab2236: and #f0 
lab2238: push af 
lab2239: xor (hl) 
lab223a: ld e,a				; tone envelope number 
lab223b: inc hl 
lab223c: ld c,(hl)			; tone low 
lab223d: inc hl 
lab223e: ld d,(hl)			; tone period high 
lab223f: inc hl 
lab2240: or d				; tone period set? 
lab2241: or c 
lab2242: jr z,#224c 
;; 
lab2244: push hl 
lab2245: call #2408			; set tone and tone envelope 
lab2248: ld d,(ix+#01)		; tone mixer value 
lab224b: pop hl 
lab224c: ld c,(hl)			; noise 
lab224d: inc hl 
lab224e: ld e,(hl)			; start volume 
lab224f: inc hl 
lab2250: ld a,(hl)			; duration of sound or envelope repeat count 
lab2251: inc hl 
lab2252: ld h,(hl) 
lab2253: ld l,a 
lab2254: pop af 
lab2255: call #22de			;; set noise 
lab2258: ld hl,#b1ee			;; channel active flag 
lab225b: ld b,(ix+#01)		;; channels'' active flag 
lab225e: ld a,(hl) 
lab225f: or b 
lab2260: ld (hl),a 
lab2261: xor b 
lab2262: jr nz,#2267 ; (+#03) 
lab2264: inc hl 
lab2265: ld (hl),#03 
lab2267: inc (ix+#19)			;; increment read position in queue 
lab226a: dec (ix+#1a)			;; number of items in the queue 
;; 
lab226d: inc (ix+#1c)			;; increase space in the queue 
;; there is a space in the queue...
lab2270: ld a,(ix+#1e)		;; high byte of event (0=disarmed) 
lab2273: ld (ix+#1e),#00		;; disarm event 
lab2277: or a 
lab2278: ret z 
;; event is armed, kick it off.
lab2279: ld h,a 
lab227a: ld l,(ix+#1d) 
lab227d: jp #01e2			; KL EVENT 
;;=============================================================================
;; ?
lab2280: res 3,(hl) 
lab2282: ld (ix+#03),#08		;; held 
;; stop sound?
lab2286: ld hl,#b1ee			;; sound channels active flag 
lab2289: ld a,(ix+#01)		;; channels'' active flag 
lab228c: cpl 
lab228d: and (hl) 
lab228e: ld (hl),a 
lab228f: ret 
;;==============================================================
;; process rendezvous
lab2290: push ix 
lab2292: ld b,a 
lab2293: ld c,(ix+#01)		;; channels'' active flag 
lab2296: ld ix,#b1f8			;; channel A''s data 
lab229a: bit 0,a 
lab229c: jr nz,#22aa 
lab229e: ld ix,#b237			;; channel B''s data 
lab22a2: bit 1,a 
lab22a4: jr nz,#22aa 
lab22a6: ld ix,#b276			;; channel C''s data 
lab22aa: ld a,(ix+#03)		; channels'' rendezvous flags 
lab22ad: and c				; ignore rendezvous with self. 
lab22ae: jr z,#22d7 
lab22b0: ld a,b 
lab22b1: cp (ix+#01)			; channels'' active flag 
lab22b4: jr z,#22cf ; ignore rendezvous with self (process own queue) 
lab22b6: push ix 
lab22b8: ld ix,#b276			; channel C''s data 
lab22bc: bit 2,a				; rendezvous channel C 
lab22be: jr nz,#22c4 
lab22c0: ld ix,#b237			; channel B''s data 
lab22c4: ld a,(ix+#03)		; channels'' rendezvous flags 
lab22c7: and c				; ignore rendezvous with self. 
lab22c8: jr z,#22d6 
;; process us/other
lab22ca: call #2219			; process queue item 
lab22cd: pop ix 
lab22cf: call #2219			; process queue item 
lab22d2: pop ix 
lab22d4: scf 
lab22d5: ret 
lab22d6: pop hl 
lab22d7: pop ix 
lab22d9: ld (ix+#03),b		; status 
lab22dc: or a 
lab22dd: ret 
;;=================================================================================
;; set initial values
;; C = noise value
;; E = initial volume
;; HL = duration of sound or envelope repeat count
lab22de: set 7,e 
lab22e0: ld (ix+#0f),e		;; volume for channel? 
lab22e3: ld e,a 
;; duration of sound or envelope repeat count
lab22e4: ld a,l 
lab22e5: or h 
lab22e6: jr nz,#22e9 
lab22e8: dec hl 
lab22e9: ld (ix+#08),l		; duration of sound or envelope repeat count 
lab22ec: ld (ix+#09),h 
lab22ef: ld a,c				; if zero do not set noise 
lab22f0: or a 
lab22f1: jr z,#22fb 
lab22f3: ld a,#06			; PSG noise register 
lab22f5: call #0863			; MC SOUND REGISTER 
lab22f8: ld a,(ix+#02) 
lab22fb: or d 
lab22fc: call #23e8			; mixer for channel 
lab22ff: ld a,e 
lab2300: or a 
lab2301: jr z,#230d 
lab2303: ld hl,#b2a6 
lab2306: ld d,#00 
lab2308: add hl,de 
lab2309: ld a,(hl) 
lab230a: or a 
lab230b: jr nz,#2310 
lab230d: ld hl,#231b			; default volume envelope 
lab2310: ld (ix+#0a),l 
lab2313: ld (ix+#0b),h 
lab2316: call #23cd			; set volume envelope? 
lab2319: jr #2328 ; (+#0d) 
;;=================================================================================
;; default volume envelope
lab231b: 
defb 1 ;; step count
defb 1 ;; step size
defb 0 ;; pause time
;; unused?
defb #c8
;;=================================================================================
;; update volume envelope
lab231f: ld l,(ix+#0d)		; volume envelope pointer 
lab2322: ld h,(ix+#0e) 
lab2325: ld e,(ix+#10)		; step count 
lab2328: ld a,e 
lab2329: cp #ff 
lab232b: jr z,#23a2 ; no tone/volume envelopes active 
lab232d: add a,a 
lab232e: ld a,(hl)			; reload envelope shape/step count 
lab232f: inc hl 
lab2330: jr c,#237b ; set hardware envelope (HL) = hardware envelope value 
lab2332: jr z,#2340 ; set volume 
lab2334: dec e				; decrease step count 
lab2335: ld c,(ix+#0f)		;; 
lab2338: or a 
lab2339: jr nz,#233f ; 
lab233b: bit 7,c				; has noise 
lab233d: jr z,#2345 		; 
;; 
lab233f: add a,c 
lab2340: and #0f 
lab2342: call #23db			; write volume for channel and store 
lab2345: ld c,(hl) 
lab2346: ld a,(ix+#09) 
lab2349: ld b,a 
lab234a: add a,a 
lab234b: jr c,#2368 ; (+#1b) 
lab234d: xor a 
lab234e: sub c 
lab234f: add a,(ix+#08) 
lab2352: jr c,#2360 ; (+#0c) 
lab2354: dec b 
lab2355: jp p,#235d 
lab2358: ld c,(ix+#08) 
lab235b: xor a 
lab235c: ld b,a 
lab235d: ld (ix+#09),b 
lab2360: ld (ix+#08),a 
lab2363: or b 
lab2364: jr nz,#2368 ; (+#02) 
lab2366: ld e,#ff 
lab2368: ld a,e 
lab2369: or a 
lab236a: call z,#23ae 
lab236d: ld (ix+#10),e 
lab2370: di 
lab2371: ld (ix+#06),c 
lab2374: ld (ix+#07),#80		; has tone envelope 
lab2378: ei 
lab2379: or a 
lab237a: ret 
;; E = hardware envelope shape
;; D = hardware envelope period low
;; (HL) = hardware envelope period high
;; DE = hardware envelope period
lab237b: ld d,a 
lab237c: ld c,e 
lab237d: ld a,#0d			; PSG hardware volume shape register 
lab237f: call #0863			; MC SOUND REGISTER 
lab2382: ld c,d 
lab2383: ld a,#0b			; PSG hardware volume period low 
lab2385: call #0863			; MC SOUND REGISTER 
lab2388: ld c,(hl) 
lab2389: ld a,#0c			; PSG hardware volume period high 
lab238b: call #0863			; MC SOUND REGISTER 
lab238e: ld a,#10			; use hardware envelope 
lab2390: call #23db			; write volume for channel and store 
lab2393: call #23ae 
lab2396: ld a,e 
lab2397: inc a 
lab2398: jr nz,#2328 
lab239a: ld hl,#231b			; default volume envelope 
lab239d: call #23cd			; set volume envelope 
lab23a0: jr #2328 ; 
;;=======================================================================
lab23a2: xor a 
lab23a3: ld (ix+#03),a		; no rendezvous/hold and not playing 
lab23a6: ld (ix+#07),a		; no tone envelope active 
lab23a9: ld (ix+#04),a		; no volume envelope active 
lab23ac: scf 
lab23ad: ret 
;;=======================================================================
lab23ae: dec (ix+#0c) 
lab23b1: jr nz,#23d1 ; (+#1e) 
lab23b3: ld a,(ix+#09) 
lab23b6: add a,a 
lab23b7: ld hl,#231b			; 
lab23ba: jr nc,#23cd ; set volume envelope 
lab23bc: inc (ix+#08) 
lab23bf: jr nz,#23c7 ; (+#06) 
lab23c1: inc (ix+#09) 
lab23c4: ld e,#ff 
lab23c6: ret z 
;; reload?
lab23c7: ld l,(ix+#0a) 
lab23ca: ld h,(ix+#0b) 
;; set volume envelope
lab23cd: ld a,(hl) 
lab23ce: ld (ix+#0c),a		;; step count 
lab23d1: inc hl 
lab23d2: ld e,(hl)			;; step size 
lab23d3: inc hl 
lab23d4: ld (ix+#0d),l		;; current volume envelope pointer 
lab23d7: ld (ix+#0e),h 
lab23da: ret 
;;----------------------------
;; write volume 0 = channel, 15 = value
lab23db: ld (ix+#0f),a 
;;----------------------------
;; set volume for channel
;; IX = pointer to channel data
;;
;; A = volume
lab23de: ld c,a 
lab23df: ld a,(ix+#00) 
lab23e2: add a,#08			; PSG volume register for channel A 
lab23e4: jp #0863			; MC SOUND REGISTER 
;;----------------------------
;; disable channel
lab23e7: xor a 
;;-------------------------
;; update mixer for channel
lab23e8: ld b,a 
lab23e9: ld a,(ix+#01)		; tone mixer value 
lab23ec: or (ix+#02)			; noise mixer value 
lab23ef: ld hl,#b2b5			 ; mixer value 
lab23f2: di 
lab23f3: or (hl)				 ; combine with current 
lab23f4: xor b 
lab23f5: cp (hl) 
lab23f6: ld (hl),a 
lab23f7: ei 
lab23f8: jr nz,#23fd ; this means tone and noise disabled 
lab23fa: ld a,b 
lab23fb: or a 
lab23fc: ret nz 
lab23fd: xor a				; silence sound 
lab23fe: call #23de			; set channel volume 
lab2401: di 
lab2402: ld c,(hl) 
lab2403: ld a,#07			; PSG mixer register 
lab2405: jp #0863			; MC SOUND REGISTER 
;;------------------------------------------------------------------------
;; set tone and get tone envelope
;; E = tone envelope number
lab2408: call #2481			; write tone to psg registers 
lab240b: ld a,e 
lab240c: call #24ab			; SOUND T ADDRESS 
lab240f: ret nc 
lab2410: ld a,(hl)			; number of sections in tone 
lab2411: and #7f 
lab2413: ret z 
lab2414: ld (ix+#11),l		; set tone envelope pointer reload 
lab2417: ld (ix+#12),h 
lab241a: call #2470 
lab241d: jr #2428			; initial update tone envelope 
;;====================================================================================
lab241f: ld l,(ix+#14)			; current tone pointer? 
lab2422: ld h,(ix+#15) 
lab2425: ld e,(ix+#18)			; step count 
;; update tone envelope
lab2428: ld c,(hl)				; step size 
lab2429: inc hl 
lab242a: ld a,e 
lab242b: sub #f0 
lab242d: jr c,#2433 ; increase/decrease tone 
lab242f: ld e,#00 
lab2431: jr #2441 
;;-------------------------------------
lab2433: dec e				; decrease step count 
lab2434: ld a,c 
lab2435: add a,a 
lab2436: sbc a,a 
lab2437: ld d,a 
lab2438: ld a,(ix+#16)		;; low byte tone 
lab243b: add a,c 
lab243c: ld c,a 
lab243d: ld a,(ix+#17)		;; high byte tone 
lab2440: adc a,d 
lab2441: ld d,a 
lab2442: call #2481			; write tone to psg registers 
lab2445: ld c,(hl)			; pause time 
lab2446: ld a,e 
lab2447: or a 
lab2448: jr nz,#2463 ; (+#19) 
;; step count done..
lab244a: ld a,(ix+#13)		; number of tone sections remaining.. 
lab244d: dec a 
lab244e: jr nz,#2460 
;; reload
lab2450: ld l,(ix+#11) 
lab2453: ld h,(ix+#12) 
lab2456: ld a,(hl)			; number of sections. 
lab2457: add a,#80 
lab2459: jr c,#2460 
lab245b: ld (ix+#04),#00		; no volume envelope 
lab245f: ret 
;;====================================================
lab2460: call #2470 
lab2463: ld (ix+#18),e 
lab2466: di 
lab2467: ld (ix+#05),c			; pause 
lab246a: ld (ix+#04),#80			; has volume envelope 
lab246e: ei 
lab246f: ret 
;;=====================================================================
lab2470: ld (ix+#13),a 	;; number of sections remaining in envelope 
lab2473: inc hl 
lab2474: ld e,(hl)		;; step count 
lab2475: inc hl 
lab2476: ld (ix+#14),l 
lab2479: ld (ix+#15),h 
lab247c: ld a,e 
lab247d: or a 
lab247e: ret nz 
lab247f: inc e 
lab2480: ret 
;;===========================================================================
;; write tone to PSG
;; C = tone low byte
;; D = tone high byte
lab2481: ld a,(ix+#00)		;; sound channel 0 = A, 1 = B, 2 =C 
lab2484: add a,a 
;; A = 0/2/4
lab2485: push af 
lab2486: ld (ix+#16),c 
lab2489: call #0863			; MC SOUND REGISTER 
lab248c: pop af 
lab248d: inc a 
;; A = 1/3/5
lab248e: ld c,d 
lab248f: ld (ix+#17),c 
lab2492: jp #0863			; MC SOUND REGISTER 
;;==========================================================================
SOUND_AMPL_ENVELOPE:
;; sets up a volume envelope
;; A = envelope 1-15
lab2495: ld de,#b2a6 
lab2498: jr #249d ; (+#03) 
;;==========================================================================
SOUND_TONE_ENVELOPE:
;; sets up a tone envelope
;; A = envelope 1-15
lab249a: ld de,#b396 
lab249d: ex de,hl 
lab249e: call #24ae			;; get envelope 
lab24a1: ex de,hl 
lab24a2: ret nc 
;; +0 - number of sections in the envelope 
;; +1..3 - first section of the envelope 
;; +4..6 - second section of the envelope 
;; +7..9 - third section of the envelope 
;; +10..12 - fourth section of the envelope 
;; +13..15 = fifth section of the envelope 
;;
;; Each section of the envelope has three bytes set out as follows 
;; non-hardware envelope:
;;byte 0 - step count (with bit 7 set) 
;;byte 1 - step size 
;;byte 2 - pause time 
;; hardware-envelope:
;;byte 0 - envelope shape (with bit 7 not set)
;;bytes 1 and 2 - envelope period 
lab24a3: ldir 
lab24a5: ret 
;;==========================================================================
SOUND_A_ADDRESS:
;; Gets the address of the data block associated with the amplitude/volume envelope
;; A = envelope number (1-15)
lab24a6: ld hl,#b2a6			; first amplitude envelope - #10 
lab24a9: jr #24ae ; get envelope 
;;==========================================================================
SOUND_T_ADDRESS:
;; Gets the address of the data block associated with the tone envelope
;; A = envelope number (1-15)
lab24ab: ld hl,#b396		;; first tone envelope - #10 
;; get envelope
lab24ae: or a			;; 0 = invalid envelope number 
lab24af: ret z 
lab24b0: cp #10			;; >=16 invalid envelope number 
lab24b2: ret nc 
lab24b3: ld bc,#0010		;; 16 bytes per envelope (5 sections + count) 
lab24b6: add hl,bc 
lab24b7: dec a 
lab24b8: jr nz,#24b6 ; (-#04) 
lab24ba: scf 
lab24bb: ret 
;;============================================================================
CAS_INITIALISE:
lab24bc: call #2557			; CAS IN ABANDON 
lab24bf: call #2599			; CAS OUT ABANDON 
;; enable cassette messages
lab24c2: xor a 
lab24c3: call #24e1			; CAS NOISY 
;; stop cassette motor
lab24c6: call #2bbf			; CAS STOP MOTOR 
;; set default speed for writing
lab24c9: ld hl,#014d 
lab24cc: ld a,#19 
;;============================================================================
CAS_SET_SPEED:
lab24ce: add hl,hl			; x2 
lab24cf: add hl,hl			; x4 
lab24d0: add hl,hl			; x8 
lab24d1: add hl,hl			; x32 
lab24d2: add hl,hl			; x64 
lab24d3: add hl,hl			; x128 
lab24d4: rrca 
lab24d5: rrca 
lab24d6: and #3f 
lab24d8: ld l,a 
lab24d9: ld (#b1e9),hl 
lab24dc: ld a,(#b1e7) 
lab24df: scf 
lab24e0: ret 
;;============================================================================
CAS_NOISY:
lab24e1: ld (#b118),a 
lab24e4: ret 
;;============================================================================
CAS_IN_OPEN:
;; 
;; B = length of filename
;; HL = filename
;; DE = address of 2K buffer
;;
;; NOTEs:
;; - first block of file *must* be 2K long
lab24e5: ld ix,#b11a			;; input header 
lab24e9: call #2502			;; initialise header 
lab24ec: push hl 
lab24ed: call c,#26ac			;; read a block 
lab24f0: pop hl 
lab24f1: ret nc 
lab24f2: ld de,(#b134)		;; load address 
lab24f6: ld bc,(#b137)		;; execution address 
lab24fa: ld a,(#b131)		;; file type from header 
lab24fd: ret 
;;============================================================================
CAS_OUT_OPEN:
lab24fe: ld ix,#b15f 
;;----------------------------------------------------------------------------
;; DE = address of 2k buffer
;; HL = address of filename
;; B = length of filename
lab2502: ld a,(ix+#00) 
lab2505: or a 
lab2506: ld a,#0e 
lab2508: ret nz 
lab2509: push ix 
lab250b: ex (sp),hl 
lab250c: inc (hl) 
lab250d: inc hl 
lab250e: ld (hl),e 
lab250f: inc hl 
lab2510: ld (hl),d 
lab2511: inc hl 
lab2512: ld (hl),e 
lab2513: inc hl 
lab2514: ld (hl),d 
lab2515: inc hl 
lab2516: ex de,hl 
lab2517: pop hl 
lab2518: push de 
;; length of header
lab2519: ld c,#40 
;; clear header
lab251b: xor a 
lab251c: ld (de),a 
lab251d: inc de 
lab251e: dec c 
lab251f: jr nz,#251c ; (-#05) 
;; write filename
lab2521: pop de 
lab2522: push de 
;;-----------------------------------------------------
;; copy filename into buffer
lab2523: ld a,b 
lab2524: cp #10 
lab2526: jr c,#252a ; (+#02) 
lab2528: ld b,#10 
lab252a: inc b 
lab252b: ld c,b 
lab252c: jr #2535 ; (+#07) 
;; read character from RAM
lab252e: rst #20				; RST 4 - LOW: RAM LAM 
lab252f: inc hl 
lab2530: call #2926			; convert character to upper case 
lab2533: ld (de),a			; store character 
lab2534: inc de 
lab2535: djnz #252e 
;; pad with spaces
lab2537: dec c 
lab2538: jr z,#2543 ; (+#09) 
lab253a: dec de 
lab253b: ld a,(de) 
lab253c: xor #20 
lab253e: jr nz,#2543 ; 
lab2540: ld (de),a			; write character 
lab2541: jr #2537 ; 
;;------------------------------------------------------
lab2543: pop hl 
lab2544: inc (ix+#15)			; set block index 
lab2547: ld (ix+#17),#16		; set initial file type 
lab254b: dec (ix+#1c)			; set first block flag 
lab254e: scf 
lab254f: ret 
;;============================================================================
CAS_IN_CLOSE:
lab2550: ld a,(#b11a)		; get current read function 
lab2553: or a 
lab2554: ld a,#0e 
lab2556: ret z 
;;============================================================================
CAS_IN_ABANDON:
lab2557: ld hl,#b11a			; get current read function 
lab255a: ld b,#01 
lab255c: ld a,(hl) 
lab255d: ld (hl),#00			; clear function allowing other functions to proceed 
lab255f: push bc 
lab2560: call #256d 
lab2563: pop af 
lab2564: ld hl,#b1e4 
lab2567: xor (hl) 
lab2568: scf 
lab2569: ret nz 
lab256a: ld (hl),a 
lab256b: sbc a,a 
lab256c: ret 
;;============================================================================
;; A = function code
;; hl = ?
lab256d: cp #04 
lab256f: ret c 
;; clear
lab2570: inc hl 
lab2571: ld e,(hl) 
lab2572: inc hl 
lab2573: ld d,(hl) 
lab2574: ld l,e 
lab2575: ld h,d 
lab2576: inc de 
lab2577: ld (hl),#00 
lab2579: ld bc,#07ff 
lab257c: jp #baa1				;; HI: KL LDIR 
;;============================================================================
CAS_OUT_CLOSE:
lab257f: ld a,(#b15f) 
lab2582: cp #03 
lab2584: jr z,#2599 ; (+#13) 
lab2586: add a,#ff 
lab2588: ld a,#0e 
lab258a: ret nc 
lab258b: ld hl,#b175 
lab258e: dec (hl) 
lab258f: inc hl 
lab2590: inc hl 
lab2591: ld a,(hl) 
lab2592: inc hl 
lab2593: or (hl) 
lab2594: scf 
lab2595: call nz,#2786			;; write a block 
lab2598: ret nc 
;;============================================================================
CAS_OUT_ABANDON:
lab2599: ld hl,#b15f 
lab259c: ld b,#02 
lab259e: jr #255c ; (-#44) 
;;============================================================================
CAS_IN_CHAR:
lab25a0: push hl 
lab25a1: push de 
lab25a2: push bc 
lab25a3: ld b,#05 
lab25a5: call #25f6			;; set cassette input function 
lab25a8: jr nz,#25c4 ; (+#1a) 
lab25aa: ld hl,(#b132) 
lab25ad: ld a,h 
lab25ae: or l 
lab25af: scf 
lab25b0: call z,#26ac			;; read a block 
lab25b3: jr nc,#25c4 ; (+#0f) 
lab25b5: ld hl,(#b132) 
lab25b8: dec hl 
lab25b9: ld (#b132),hl 
lab25bc: ld hl,(#b11d) 
lab25bf: rst #20				; RST 4 - LOW: RAM LAM 
lab25c0: inc hl 
lab25c1: ld (#b11d),hl 
lab25c4: jr #25f2 ; (+#2c) 
;;============================================================================
CAS_OUT_CHAR:
lab25c6: push hl 
lab25c7: push de 
lab25c8: push bc 
lab25c9: ld c,a 
lab25ca: ld hl,#b15f 
lab25cd: ld b,#05 
lab25cf: call #25f9 
lab25d2: jr nz,#25f2 ; (+#1e) 
lab25d4: ld hl,(#b177) 
lab25d7: ld de,#0800 
lab25da: sbc hl,de 
lab25dc: push bc 
lab25dd: call nc,#2786			;; write a block 
lab25e0: pop bc 
lab25e1: jr nc,#25f2 ; (+#0f) 
lab25e3: ld hl,(#b177) 
lab25e6: inc hl 
lab25e7: ld (#b177),hl 
lab25ea: ld hl,(#b162) 
lab25ed: ld (hl),c 
lab25ee: inc hl 
lab25ef: ld (#b162),hl 
lab25f2: pop bc 
lab25f3: pop de 
lab25f4: pop hl 
lab25f5: ret 
;;============================================================================
;; attempt to set cassette input function
;; entry:
;; B = function code
;;
;; 0 = no function active
;; 1 = opened using CAS IN OPEN or CAS OUT OPEN
;; 2 = reading with CAS IN DIRECT
;; 3 = broken into with ESC
;; 4 = catalog
;; 5 = reading with CAS IN CHAR
;;
;; exit:
;; zero set = no error. function has been set or function is already set
;; zero clear = error. A = error code
;;
lab25f6: ld hl,#b11a 
lab25f9: ld a,(hl)			;; get current function code 
lab25fa: cp b				;; same as existing code? 
lab25fb: ret z 
;; function codes are different
lab25fc: xor #01				;; just opened? 
lab25fe: ld a,#0e 
lab2600: ret nz 
;; must be just opened for this to succeed
;;
;; set new function
lab2601: ld (hl),b 
lab2602: ret 
;;============================================================================
CAS_TEST_EOF:
lab2603: call #25a0 
lab2606: ret nc 
;;============================================================================
CAS_RETURN:
lab2607: push hl 
lab2608: ld hl,(#b132) 
lab260b: inc hl 
lab260c: ld (#b132),hl 
lab260f: ld hl,(#b11d) 
lab2612: dec hl 
lab2613: ld (#b11d),hl 
lab2616: pop hl 
lab2617: ret 
;;============================================================================
CAS_IN_DIRECT:
;; 
;; HL = load address
;;
;; Notes:
;; - file must be contiguous;
;; - load address of first block is important, load address of subsequent blocks 
;;   is ignored and can be any value
;; - first block of file must be 2k long; subsequent blocks can be any length
;; - execution address is taken from header of last block
;; - filename of each block must be the same
;; - block numbers are consecutive and increment
;; - first block number is *not* important; it can be any value!
lab2618: ex de,hl 
lab2619: ld b,#02			;; IN direct 
lab261b: call #25f6			;; set cassette input function 
lab261e: ret nz 
;; set initial load address
lab261f: ld (#b134),de 
;; transfer first block to destination
lab2623: call #263c			;; transfer loaded block to destination location 
;; update load address
lab2626: ld hl,(#b134)		;; load address from in memory header 
lab2629: ld de,(#b132)		;; length from loaded header 
lab262d: add hl,de 
lab262e: ld (#b134),hl 
lab2631: call #26ac			;; read a block 
lab2634: jr c,#2626 ; (-#10) 
lab2636: ret z 
lab2637: ld hl,(#b1be)		;; execution address 
lab263a: scf 
lab263b: ret 
;;============================================================================
;; transfer loaded block to destination location
lab263c: ld hl,(#b11b) 
lab263f: ld bc,(#b132) 
lab2643: ld a,e 
lab2644: sub l 
lab2645: ld a,d 
lab2646: sbc a,h 
lab2647: jp c,#baa1				;; HI: KL LDIR 
lab264a: add hl,bc 
lab264b: dec hl 
lab264c: ex de,hl 
lab264d: add hl,bc 
lab264e: dec hl 
lab264f: ex de,hl 
lab2650: jp #baa7				;; HI: KL LDDR 
;;============================================================================
CAS_OUT_DIRECT:
;; 
;; HL = load address
;; DE = length
;; BC = execution address
;; A = file type
lab2653: push hl 
lab2654: push bc 
lab2655: ld c,a 
lab2656: ld hl,#b15f 
lab2659: ld b,#02 
lab265b: call #25f9 
lab265e: jr nz,#268d ; (+#2d) 
lab2660: ld a,c 
lab2661: pop bc 
lab2662: pop hl 
;; setup header
lab2663: ld (#b176),a 
lab2666: ld (#b17c),de		; length 
lab266a: ld (#b17e),bc		; execution address 
lab266e: ld (#b160),hl		; load address 
lab2671: ld (#b177),de		; length 
lab2675: ld hl,#f7ff			; #f7ff = -#800 
lab2678: add hl,de 
lab2679: ccf 
lab267a: ret c 
lab267b: ld hl,#0800 
lab267e: ld (#b177),hl		; length of this block 
lab2681: ex de,hl 
lab2682: sbc hl,de 
lab2684: push hl 
lab2685: ld hl,(#b160) 
lab2688: add hl,de 
lab2689: push hl 
lab268a: call #2786			; write block 
lab268d: pop hl 
lab268e: pop de 
lab268f: ret nc 
lab2690: jr #266e ; (-#24) 
;;============================================================================
CAS_CATALOG:
;;
;; DE = address of 2k buffer
lab2692: ld hl,#b11a 
lab2695: ld a,(hl) 
lab2696: or a 
lab2697: ld a,#0e 
lab2699: ret nz 
lab269a: ld (hl),#04			; set catalog function 
lab269c: ld (#b11b),de		; buffer to load blocks to 
lab26a0: xor a 
lab26a1: call #24e1			;; CAS NOISY 
lab26a4: call #26b3			; read block 
lab26a7: jr c,#26a4 ; loop if cassette not pressed 
lab26a9: jp #2557			;; CAS IN ABANDON 
;;=================================================================================
;; read a block
;; 
;; 
;; notes:
;;
lab26ac: ld a,(#b130)		; last block flag 
lab26af: or a 
lab26b0: ld a,#0f			; "hard end of file" 
lab26b2: ret nz 
lab26b3: ld bc,#8301			; Press PLAY then any key 
lab26b6: call #27e5			; display message if required 
lab26b9: jr nc,#271a 
lab26bb: ld hl,#b1a4			; location to load header 
lab26be: ld de,#0040			; header length 
lab26c1: ld a,#2c			; header marker byte 
lab26c3: call #29a6			; cas read: read header 
lab26c6: jr nc,#271a 
lab26c8: ld b,#8b			; no message 
lab26ca: call #292f			; catalog? 
lab26cd: jr z,#26d6 
;; not catalog, so compare filenames
lab26cf: call #2737			; compare filenames 
lab26d2: jr nz,#2727 ; if nz, display "Found xxx block x" 
lab26d4: ld b,#89			; "Loading" 
lab26d6: call #2804			; display "Loading xxx block x" 
lab26d9: ld de,(#b1b7)		; length from loaded header 
lab26dd: ld hl,(#b134)		; location from in-memory header 
lab26e0: ld a,(#b11a)		; 
lab26e3: cp #02				; in direct? 
lab26e5: jr z,#26f5 ; 
;; not in direct, so is:
;; 1. catalog
;; 2. opening file for read
;; 3. reading file char by char
;;
;; check the block is no longer than $800 bytes
;; if it is report a "read error d"
lab26e7: ld hl,#f7ff			; #f7ff = -#800 
lab26ea: add hl,de			; add length from header 
lab26eb: ld a,#04			; code for ''read error d'' 
lab26ed: jr c,#271a ; (+#2b) 
lab26ef: ld hl,(#b11b)		; 2k buffer 
lab26f2: ld (#b11d),hl 
lab26f5: ld a,#16			; data marker 
lab26f7: call #29a6			; cas read: read data 
lab26fa: jr nc,#271a ; 
;; increment block number in internal header
lab26fc: ld hl,#b12f			; block number 
lab26ff: inc (hl)				; increment block number 
;; get last block flag from loaded header and store into
;; internal header
lab2700: ld a,(#b1b5) 
lab2703: inc hl 
lab2704: ld (hl),a 
;; clear first block flag
lab2705: xor a 
lab2706: ld (#b136),a 
lab2709: ld hl,(#b1b7)		; get length from loaded header 
lab270c: ld (#b132),hl		; store in internal header 
lab270f: call #292f			; catalog? 
;; if catalog display OK message
lab2712: ld a,#8c			; "OK" 
lab2714: call z,#287e			; display message 
;; 
lab2717: scf 
lab2718: jr #277f ; (+#65) 
;;===========================================================================
;; A = code (A=0: no error; A<>0: error)
lab271a: or a 
lab271b: ld hl,#b11a 
lab271e: jr z,#2778 ; 
;; A = error code
lab2720: ld b,#85			; "Read error" 
lab2722: call #2885			; display message with code 
;; .. retry
lab2725: jr #26bb 
;;===========================================================================
lab2727: push af 
lab2728: ld b,#88			; "Found " 
lab272a: call #2804			; "Found xxx block x" 
lab272d: pop af 
lab272e: jr nc,#26bb ; (-#75) 
lab2730: ld b,#87			; "Rewind tape" 
lab2732: call #2883 
lab2735: jr #26bb ; (-#7c) 
;;========================================================================
;; compare filenames
;;
;; if not first block:
;; compare names
;; if first block:
;; - compare filenames if a filename was specified
;; - copy loaded header into ram
lab2737: ld a,(#b136)		; first block flag in internal header? 
lab273a: or a 
lab273b: jr z,#2758 
lab273d: ld a,(#b1bb)		; first block flag in loaded header? 
lab2740: cpl 
lab2741: or a 
lab2742: ret nz 
;; if user specified a filename, compare it against the filename in the loaded
;; header, otherwise accept the file
lab2743: ld a,(#b11f)		; did user specify a filename? 
; e.g. LOAD"bob"
lab2746: or a 
lab2747: call nz,#2760			; compare filenames and block number 
lab274a: ret nz				; if filenames do not match, quit 
;; gets here if:
;; 1. if a filename was specified by user and filename matches with 
;; filename in loaded header
;;
;; 2. no filename was specified by user
;; copy loaded header to in-memory header
lab274b: ld hl,#b1a4 
lab274e: ld de,#b11f 
lab2751: ld bc,#0040 
lab2754: ldir 
lab2756: xor a 
lab2757: ret 
;;=========================================================================
;; compare name and block number
lab2758: call #2760			; compare filenames 
lab275b: ret nz 
;; compare block number
lab275c: ex de,hl 
lab275d: ld a,(de) 
lab275e: cp (hl) 
lab275f: ret 
;;============================================================================
;; compare two filenames; one filename is in the loaded header
;; the second filename is in the in-memory header
;;
;; nz = filenames are different
;; z = filenames are identical
lab2760: ld hl,#b11f			; in-memory header 
lab2763: ld de,#b1a4			; loaded header 
;; compare filenames
lab2766: ld b,#10			; 16 characters 
lab2768: ld a,(de)			; get character from loaded header 
lab2769: call #2926			; convert character to upper case 
lab276c: ld c,a 
lab276d: ld a,(hl)			; get character from in-memory header 
lab276e: call #2926			; convert character to upper case 
lab2771: xor c				; result will be 0 if the characters are identical. 
; will be <>0 if the characters are different
lab2772: ret nz				; quit if characters are not the same 
lab2773: inc hl				; increment pointer 
lab2774: inc de				; increment pointer 
lab2775: djnz #2768 
;; if control gets to here, then the filenames are identical
lab2777: ret 
;;============================================================================
lab2778: ld a,(hl) 
lab2779: ld (hl),#03			; 
lab277b: call #256d 
lab277e: or a 
;;----------------------------------------------------------------------------
;; quit loading block
lab277f: sbc a,a 
lab2780: push af 
lab2781: call #2bbf			; CAS STOP MOTOR 
lab2784: pop af 
lab2785: ret 
;;============================================================================
;; write a block
lab2786: ld bc,#8402			; press rec 
lab2789: call #27e5			; display message if required 
lab278c: jr nc,#27d8 ; (+#4a) 
lab278e: ld b,#8a 
lab2790: ld de,#b164 
lab2793: call #2807 
lab2796: ld hl,#b17b 
lab2799: call #27fa 
lab279c: jr nc,#27d8 ; (+#3a) 
lab279e: ld hl,(#b160) 
lab27a1: ld (#b162),hl 
lab27a4: ld (#b179),hl 
lab27a7: push hl 
;; write header for this block
lab27a8: ld hl,#b164 
lab27ab: ld de,#0040 
lab27ae: ld a,#2c			; header marker 
lab27b0: call #29af			; cas write: write header 
lab27b3: pop hl 
lab27b4: jr nc,#27d8 ; (+#22) 
;; write data for this block
lab27b6: ld de,(#b177) 
lab27ba: ld a,#16			; data marker 
lab27bc: call #29af			; cas write: write data block 
lab27bf: ld hl,#b175 
lab27c2: call c,#27fa 
lab27c5: jr nc,#27d8 ; (+#11) 
lab27c7: ld hl,#0000 
lab27ca: ld (#b177),hl 
lab27cd: ld hl,#b174 
lab27d0: inc (hl) 
lab27d1: xor a 
lab27d2: ld (#b17b),a 
lab27d5: scf 
lab27d6: jr #277f ; (-#59) 
;;=======================================================================
;; A = code (A=0: no error; A<>0: error)
lab27d8: or a 
lab27d9: ld hl,#b15f 
lab27dc: jr z,#2778 ; (-#66) 
;; a = code
lab27de: ld b,#86			; "Write error" 
lab27e0: call #2885			; display message with code 
lab27e3: jr #279e ; (-#47) 
;;========================================================================
;; C = message code
;; exit:
;; A = 0: no error
;; A <>0: error
lab27e5: ld hl,#b1e4 
lab27e8: ld a,c 
lab27e9: cp (hl) 
lab27ea: ld (hl),c 
lab27eb: scf 
lab27ec: push hl 
lab27ed: push bc 
lab27ee: call nz,#28d2			; Press play then any key 
lab27f1: pop bc 
lab27f2: pop hl 
lab27f3: sbc a,a 
lab27f4: ret nc 
lab27f5: call #2bbb			; CAS START MOTOR 
lab27f8: sbc a,a 
lab27f9: ret 
;;========================================================================
lab27fa: ld a,(hl) 
lab27fb: or a 
lab27fc: scf 
lab27fd: ret z 
lab27fe: ld bc,#012c			; delay in 1/100ths of a second 
lab2801: jp #2be2			; delay for 3 seconds 
;;===================================================================================
lab2804: ld de,#b1a4 
lab2807: ld a,(#b118)		; cassette messages enabled? 
lab280a: or a 
lab280b: ret nz 
lab280c: ld (#b119),a 
lab280f: call #28f3 
lab2812: call #2898			; display message 
lab2815: ld a,(de)			; is first character of filename = 0? 
lab2816: or a 
lab2817: jr nz,#2823 ; 
;; unnamed file
lab2819: ld a,#8e			; "Unnamed file" 
lab281b: call #2899			; display message 
lab281e: ld bc,#0010 
lab2821: jr #2851 ; (+#2e) 
;;-----------------------------
;; named file
lab2823: call #292f 
lab2826: ld bc,#1000 
lab2829: jr z,#2838 ; (+#0d) 
lab282b: ld l,e 
lab282c: ld h,d 
lab282d: ld a,(hl) 
lab282e: or a 
lab282f: jr z,#2835 ; (+#04) 
lab2831: inc c 
lab2832: inc hl 
lab2833: djnz #282d ; (-#08) 
lab2835: ld a,b 
lab2836: ld b,c 
lab2837: ld c,a 
lab2838: call #28fd			; insert new-line if word 
; can''t fit onto current-line
lab283b: ld a,(de)			; get character from filename 
lab283c: call #2926			; convert character to upper case 
lab283f: or a				; zero? 
lab2840: jr nz,#2844 
;; display a space if a zero is found
lab2842: ld a,#20			; display a space 
lab2844: push bc 
lab2845: push de 
lab2846: call #1335			; TXT WR CHAR 
lab2849: pop de 
lab284a: pop bc 
lab284b: inc de 
lab284c: djnz #283b ; (-#13) 
lab284e: call #28ce			; display space 
lab2851: ex de,hl 
lab2852: add hl,bc 
lab2853: ex de,hl 
lab2854: ld a,#8d			; "block " 
lab2856: call #2899			; display message 
lab2859: ld b,#02			; length of word 
lab285b: call #28fd			; insert new-line if word 
; can''t fit onto current-line
lab285e: ld a,(de) 
lab285f: call #2914			; display decimal number 
lab2862: call #28ce			; display space 
lab2865: inc de 
lab2866: call #292f 
lab2869: jr nz,#2876 ; (+#0b) 
lab286b: inc de 
lab286c: ld a,(de) 
lab286d: and #0f 
lab286f: add a,#24 
lab2871: call #28f0 
lab2874: jr #28ce ; display space 
;;=========================================================================
lab2876: ld a,(de) 
lab2877: ld hl,#b119 
lab287a: or (hl) 
lab287b: ret z 
lab287c: jr #28eb ; (+#6d) 
;;=========================================================================
;; A = message code
lab287e: call #2899			; display message 
lab2881: jr #28eb ; (+#68) 
;;=========================================================================
lab2883: ld a,#ff 
;; display message with code on end (e.g. "Read error x" or "Write error x"
;; A = code (1,2,3)
lab2885: push af 
lab2886: call #2891 
lab2889: pop af 
lab288a: add a,#60			; ''a''-1 
lab288c: call nc,#28f0			; display character 
lab288f: jr #28eb 
;;=========================================================================
lab2891: call #117c			; TXT GET CURSOR 
lab2894: dec h 
lab2895: call nz,#28eb 
lab2898: ld a,b 
;;=========================================================================
;; display message
;;
;; - message is displayed using word-wrap
;;
;; a = message number (&80-&FF)
lab2899: push hl 
lab289a: and #7f				; get message index (0-127) 
lab289c: ld b,a 
lab289d: ld hl,#2935			; start of message list (points to first message) 
;; first message in list? (message 0?)
lab28a0: jr z,#28a9 
;; not first. 
;; 
;; - each message is terminated by a zero byte
;; - keep fetching bytes until a zero is found.
;; - if a zero is found, decrement count. If count reaches zero, then 
;; the first byte following the zero, is the start of the message we want
lab28a2: ld a,(hl)			; get byte 
lab28a3: inc hl				; increment pointer 
lab28a4: or a				; is it zero (0) ? 
lab28a5: jr nz,#28a2 ; if zero, it is the end of this string 
;; got a zero byte, so at end of the current string
lab28a7: djnz #28a2 ; decrement message count 
;; HL = start of message to display
;; this part is looped; message may contain multiple strings
;; end of message?
lab28a9: ld a,(hl) 
lab28aa: or a 
lab28ab: jr z,#28b2 ; (+#05) 
;; display message
lab28ad: call #28b5			; display message with word-wrap 
;; at this point there might be a end of string marker (0), the start
;; of another string (next byte will have bit 7=0) or a continuation string
;; (next byte will have bit 7=1)
lab28b0: jr #28a9 ; continue displaying string 
;; finished displaying complete string , or displayed part of string sequence
lab28b2: pop hl 
lab28b3: inc hl				; if part of a complete message, go to next sub-string or word 
lab28b4: ret 
;;=========================================================================
;; display message with word wrap
;; HL = address of message
;; A = first character in message
;; if -ve, then bit 7 is set. Bit 6..0 define the ID of the message to display
;; if +ve, then this is the first character in the message
lab28b5: jp m,#2899 
;;-------------------------------------
;; count number of letters in word
lab28b8: push hl			;; store start of word 
;; count number of letters in world
lab28b9: ld b,#00 
lab28bb: inc b 
lab28bc: ld a,(hl)		;; get character 
lab28bd: inc hl			;; increment pointer 
lab28be: rlca					;; if bit 7 is set, then this is the last character of the current word 
lab28bf: jr nc,#28bb 
;; B = number of letters
;; if word will not fit onto end of current line, insert
;; a line break, and display on next line
lab28c1: call #28fd 
lab28c4: pop hl			;; restore start of word 
;;------------------------------------
;; display word
;; HL = location of characters
;; B = number of characters 
lab28c5: ld a,(hl)			; get byte 
lab28c6: inc hl				; increment counter 
lab28c7: and #7f				; isolate byte 
lab28c9: call #28f0			; display char (txt output?) 
lab28cc: djnz #28c5 
;; display space
lab28ce: ld a,#20			; " " (space) character 
lab28d0: jr #28f0 ; display character 
;;=========================================================================
lab28d2: ld a,(#b118)		; cassette messages enabled? 
lab28d5: or a 
lab28d6: scf 
lab28d7: ret nz 
lab28d8: call #2891			; display message 
lab28db: call #1bfe			; KM FLUSH 
lab28de: call #1276			; TXT CUR ON 
lab28e1: call #1cdb			; KM WAIT KEY 
lab28e4: call #127e			; TXT CUR OFF 
lab28e7: cp #fc 
lab28e9: ret z 
lab28ea: scf 
;;-----------------------------------------------------------------------
lab28eb: call #28f3 
;; display cr
lab28ee: ld a,#0a 
lab28f0: jp #13fe			; TXT OUTPUT 
;;==========================================================================
lab28f3: push af 
lab28f4: push hl 
lab28f5: ld a,#01 
lab28f7: call #115a			; TXT SET COLUMN 
lab28fa: pop hl 
lab28fb: pop af 
lab28fc: ret 
;;==========================================================================
;; determine if word can be displayed on this line
lab28fd: push de 
lab28fe: call #1252			; TXT GET WINDOW 
lab2901: ld e,h 
lab2902: call #117c			; TXT GET CURSOR 
lab2905: ld a,h 
lab2906: dec a 
lab2907: add a,e 
lab2908: add a,b 
lab2909: dec a 
lab290a: cp d 
lab290b: pop de 
lab290c: ret c 
lab290d: ld a,#ff 
lab290f: ld (#b119),a 
lab2912: jr #28eb ; (-#29) 
;;============================================================================
;; divide by 10
lab2914: ld b,#ff 
lab2916: inc b 
lab2917: sub #0a 
lab2919: jr nc,#2916 ; (-#05) 
;; B = result of division by 10
;; a = <10
lab291b: add a,#3a			; convert to ASCII digit 
lab291d: push af 
lab291e: ld a,b 
lab291f: or a 
lab2920: call nz,#2914			; continue with division 
lab2923: pop af 
lab2924: jr #28f0 ; display character 
;;============================================================================
;; convert character to upper case
lab2926: cp #61				; "a" 
lab2928: ret c 
lab2929: cp #7b				; "z" 
lab292b: ret nc 
lab292c: add a,#e0 
lab292e: ret 
;;============================================================================
;; test if read function is CATALOG
;;
;; zero set = catalog
;; zero clear = not catalog
lab292f: ld a,(#b11a)		; get current read function 
lab2932: cp #04				; catalog function? 
lab2934: ret 
;;============================================================================
;; cassette messages
;; - a zero (0) byte indicates end of complete message
;; - a byte with bit 7 set indicates:
;;	 end of a word, the id of another continuing string
;; 0: "Press"
;; 1: "PLAY then any key:"
;; 2: "error"
;; 3: "Press PLAY then any key:"
;; 4: "Press REC and PLAY then any key:"
;; 5: "Read error"
;; 6: "Write error"
;; 7: "Rewind tape"
;; 8: "Found  "
;; 9: "Loading"
;; 10: "Saving"
;; 11: <blank>
;; 12: "Ok"
;; 13: "block"
;; 14: "Unnamed file"
defb "Pres","s"+#80,0
defb "PLA","Y"+#80,"the","n"+#80,"an","y"+#80,"key",":"+#80,0
defb "erro","r"+#80,0
defb 0+#80,1+#80,0
defb #80,"RE","C"+#80,"an","d"+#80,#81, 0
defb "Rea","d"+#80,#82,0
defb "Writ","e"+#80,#82,0
defb "Rewin","d"+#80,"tap","e"+#80,0
defb "Found "," "+#80,0
defb "Loadin","g"+#80,0
defb "Savin","g"+#80,0
defb 0
defb "O","k"+#80,0
defb "bloc","k"+#80,0
defb "Unname","d"+#80,"file   "," "+#80,0
;;=========================================================================
CAS_READ:
;; A = sync byte
;; HL = location of data
;; DE = length of data
lab29a6: call #29e3			; enable key checking and start the cassette motor 
lab29a9: push af 
lab29aa: ld hl,#2a28			; read block of data 
lab29ad: jr #29c8 ; do read 
;;=========================================================================
CAS_WRITE:
;; A = sync byte
;; HL = destination location for data
;; DE = length of data
lab29af: call #29e3			; enable key checking and start the cassette motor 
lab29b2: push af 
lab29b3: call #2ad4			;; write start of block (pilot and syncs) 
lab29b6: ld hl,#2a67			;; write block of data 
lab29b9: call c,#2a0d			;; read/write 256 byte blocks 
lab29bc: call c,#2ae9			;; write trailer 
lab29bf: jr #29d0 ;; 
;;=========================================================================
CAS_CHECK:
lab29c1: call #29e3			; enable key checking and start the cassette motor 
lab29c4: push af 
lab29c5: ld hl,#2a37			;; check stored block with block in memory 
;;------------------------------------------------------
;; do read
;; cas check or cas read
lab29c8: push hl 
lab29c9: call #2a89			;; read pilot and sync 
lab29cc: pop hl 
lab29cd: call c,#2a0d			;; read/write 256 byte blocks 
;;----------------------------------------------------------------
;; cas check, cas read or cas write
lab29d0: pop de 
lab29d1: push af 
lab29d2: ld bc,#f782			;; set PPI port A to output 
lab29d5: out (c),c 
lab29d7: ld bc,#f610			;; cassette motor on 
lab29da: out (c),c 
;; if cassette motor is stopped, then it will stop immediatly
;; if cassette motor is running, then there will not be any pause.
lab29dc: ei						;; enable interrupts 
lab29dd: ld a,d 
lab29de: call #2bc1			;; CAS RESTORE MOTOR 
lab29e1: pop af 
lab29e2: ret 
;;=========================================================================
;; enable key checking and start the cassette motor
;; store marker
lab29e3: ld (#b1e5),a 
lab29e6: dec de 
lab29e7: inc e 
lab29e8: push hl 
lab29e9: push de 
lab29ea: call #1fe9			; SOUND RESET 
lab29ed: pop de 
lab29ee: pop ix 
lab29f0: call #2bbb			; CAS START MOTOR 
lab29f3: di					;; disable interrupts 
;; select PSG register 14 (PSG port A)
;; (keyboard data is connected to PSG port A)
lab29f4: ld bc,#f40e		;; select keyboard line 14 
lab29f7: out (c),c 
lab29f9: ld bc,#f6d0		;; cassette motor on + PSG select register operation 
lab29fc: out (c),c 
lab29fe: ld c,#10 
lab2a00: out (c),c		;; cassette motor on + PSG inactive operation 
lab2a02: ld bc,#f792		;; set PPI port A to input 
lab2a05: out (c),c 
;; PSG port A data can be read through PPI port A now
lab2a07: ld bc,#f658		;; cassette motor on + PSG read data operation + select keyboard line 8 
lab2a0a: out (c),c 
lab2a0c: ret 
;;========================================================================================
;; read/write blocks
;; DE = number of bytes to read/write
;; D = number of 256 blocks to read/write 
;; if D = 0, then there is a single block to write, which has E bytes
;; in it.
;; if D!=0, then there is more than one block to write, write 256 bytes
;; for each block except the last. Then write final block with remaining
;; bytes.
lab2a0d: ld a,d 
lab2a0e: or a 
lab2a0f: jr z,#2a1e ; (+#0d) 
;; do each complete 256 byte block
lab2a11: push hl 
lab2a12: push de 
lab2a13: ld e,#00			; number of bytes 
lab2a15: call #2a1e			; read/write block 
lab2a18: pop de 
lab2a19: pop hl 
lab2a1a: ret nc 
lab2a1b: dec d 
lab2a1c: jr nz,#2a11 ; (-#0d) 
;; E = number of bytes in last block to write
;;------------------------------------
;; initialise crc
lab2a1e: ld bc,#ffff 
lab2a21: ld (#b1eb),bc		; crc 
;; do function
lab2a25: ld d,#01 
lab2a27: jp (hl) 
;;========================================================================================
;; IX = address to load data to 
;; read data
;; input:
;; D = block size
;; E = actual data size
;; output:
;; D = bytes remaining in block (block size - actual data size)
lab2a28: call #2b20			; read byte from cassette 
lab2a2b: ret nc 
lab2a2c: ld (ix+#00),a		; store byte 
lab2a2f: inc ix				; increment pointer 
lab2a31: dec d				; decrement block count 
lab2a32: dec e 
lab2a33: jr nz,#2a28 ; decrement actual data count 
;; D = number of bytes remaining in block
;; read remaining bytes in block; but ignore
lab2a35: jr #2a49 ; (+#12) 
;;========================================================================================
;; check stored block with block in memory
lab2a37: call #2b20			; read byte from cassette 
lab2a3a: ret nc 
lab2a3b: ld b,a 
lab2a3c: call #bad7			; get byte from IX with roms disabled 
lab2a3f: xor b 
lab2a40: ld a,#03			; 
lab2a42: ret nz 
lab2a43: inc ix 
lab2a45: dec d 
lab2a46: dec e 
lab2a47: jr nz,#2a37 ; (-#12) 
;; any more bytes remaining in block??
lab2a49: dec d 
lab2a4a: jr z,#2a52 ; 
;; bytes remaining
;; read the remaining bytes but ignore
lab2a4c: call #2b20			; read byte from cassette 
lab2a4f: ret nc 
lab2a50: jr #2a49 ; 
;;-----------------------------------------------------
lab2a52: call #2b16			; get 1''s complemented crc 
lab2a55: call #2b20			; read crc byte1 from cassette 
lab2a58: ret nc 
lab2a59: xor d 
lab2a5a: jr nz,#2a63 ; 
lab2a5c: call #2b20			; read crc byte2 from cassette 
lab2a5f: ret nc 
lab2a60: xor e 
lab2a61: scf 
lab2a62: ret z 
lab2a63: ld a,#02 
lab2a65: or a 
lab2a66: ret 
;;========================================================================================
;; write block of data (pad with 0''s if less than block size)
;; IX = address of data
;; E = actual byte count
;; D = block size count
lab2a67: call #bad7			; get byte from IX with roms disabled 
lab2a6a: call #2b68			; write data byte 
lab2a6d: ret nc 
lab2a6e: inc ix				; increment pointer 
lab2a70: dec d				; decrement block size count 
lab2a71: dec e				; decrement actual count 
lab2a72: jr nz,#2a67 ; (-#0d) 
;; actual byte count = block size count?
lab2a74: dec d 
lab2a75: jr z,#2a7e 
;; no, actual byte count was less than block size
;; pad up to block size with zeros
lab2a77: xor a 
lab2a78: call #2b68			; write data byte 
lab2a7b: ret nc 
lab2a7c: jr #2a74 ; (-#0a) 
;; get 1''s complemented crc
lab2a7e: call #2b16 
;; write crc 1
lab2a81: call #2b68			; write data byte 
lab2a84: ret nc 
;; write crc 2
lab2a85: ld a,e 
lab2a86: jp #2b68			; write data byte 
;;========================================================================================
;; read pilot and sync
lab2a89: push de 
lab2a8a: call #2a93			; read pilot and sync 
lab2a8d: pop de 
lab2a8e: ret c 
lab2a8f: or a 
lab2a90: ret z 
lab2a91: jr #2a89 ; (-#0a) 
;;==========================================================================
;; read pilot and sync
;;---------------------------------
;; wait for start of leader/pilot
lab2a93: ld l,#55			; %01010101 
; this is used to generate the cassette input data comparison
; used in the edge detection
lab2a95: call #2b3d			; sample edge 
lab2a98: ret nc 
;;------------------------------------------
;; get 256 pulses of leader/pilot
lab2a99: ld de,#0000			; initial total 
lab2a9c: ld h,d 
lab2a9d: call #2b3d			; sample edge 
lab2aa0: ret nc 
lab2aa1: ex de,hl 
;; C = measured time
;; add measured time to total
lab2aa2: ld b,#00 
lab2aa4: add hl,bc 
lab2aa5: ex de,hl 
lab2aa6: dec h 
lab2aa7: jr nz,#2a9d ; (-#0c) 
;; C = duration of last pulse read
;; look for sync bit
;; and adjust the average for every non-sync
;; DE = sum of 256 edges
;; D:E forms a 8.8 fixed point number
;; D = integer part of number (integer average of 256 pulses)
;; E = fractional part of number
lab2aa9: ld h,c				; time of last pulse 
lab2aaa: ld a,c 
lab2aab: sub d				; subtract initial average 
lab2aac: ld c,a 
lab2aad: sbc a,a 
lab2aae: ld b,a 
;; if C>D then BC is +ve; BC = +ve delta
;; if C<D then BC is -ve; BC = -ve delta
;; adjust average
lab2aaf: ex de,hl 
lab2ab0: add hl,bc			; DE = DE + BC 
lab2ab1: ex de,hl 
lab2ab2: call #2b3d			; sample edge 
lab2ab5: ret nc 
; A = d * 5/4
lab2ab6: ld a,d				; average so far 
lab2ab7: srl a				; /2 
lab2ab9: srl a				; /4 
; A = D * 1/4
lab2abb: adc a,d				; A = D + (D*1/4) 
;; sync pulse will have a duration which is half that of a pulse in a 1 bit
;; average<previous 
lab2abc: sub h				; time of last pulse 
lab2abd: jr c,#2aa9 ; carry set if H>A 
;; average>=previous (possibly read first pulse of sync or second of sync)
lab2abf: sub c				; time of current pulse 
lab2ac0: jr c,#2aa9 ; carry set if C>(A-H) 
;; to get here average>=(previous*2)
;; and this means we have just read the second pulse of the sync bit
;; calculate bit 1 timing
lab2ac2: ld a,d				; average 
lab2ac3: rra						; /2 
; A = D/2
lab2ac4: adc a,d				; A = D + (D/2) 
; A = D * (3/2)
lab2ac5: ld h,a 
; this is the middle time
; to calculate difference between 0 and 1 bit
;; if pulse measured is > this time, then we have a 1 bit
;; if pulse measured is < this time, then we have a 0 bit
;; H = timing constant
;; L = initial cassette data input state
lab2ac6: ld (#b1e6),hl 
;; read marker
lab2ac9: call #2b20			; read data-byte 
lab2acc: ret nc 
lab2acd: ld hl,#b1e5			; marker 
lab2ad0: xor (hl) 
lab2ad1: ret nz 
lab2ad2: scf 
lab2ad3: ret 
;;========================================================================================
;; write start of block
lab2ad4: call #2bf9		;; 1/100th of a second delay 
;; write leader
lab2ad7: ld hl,#0801		;; 2049 
lab2ada: call #2aec		;; write leader (2049 1 bits; 4096 pulses) 
lab2add: ret nc 
;; write sync bit
lab2ade: or a 
lab2adf: call #2b78		;; write data-bit 
lab2ae2: ret nc 
;; write marker
lab2ae3: ld a,(#b1e5) 
lab2ae6: jp #2b68		;; write data byte 
;;=============================================================================
;; write trailer = 33 "1" bits
;;
;; carry set = trailer written successfully
;; zero set = escape was pressed
lab2ae9: ld hl,#0021		;; 33 
;; check for escape
lab2aec: ld b,#f4		;; PPI port A 
lab2aee: in a,(c)		;; read keyboard data through PPI port A (connected to PSG port A) 
lab2af0: and #04			;; escape key pressed? 
;; bit 2 is 0 if escape key pressed
lab2af2: ret z 
;; write trailer bit
lab2af3: push hl 
lab2af4: scf					;; a "1" bit 
lab2af5: call #2b78		;; write data-bit 
lab2af8: pop hl 
lab2af9: dec hl			;; decrement trailer bit count 
lab2afa: ld a,h 
lab2afb: or l 
lab2afc: jr nz,#2aec ;; 
lab2afe: scf 
lab2aff: ret 
;;=============================================================================
;; update crc
lab2b00: ld hl,(#b1eb)		;; get crc 
lab2b03: xor h 
lab2b04: jp p,#2b10 
lab2b07: ld a,h 
lab2b08: xor #08 
lab2b0a: ld h,a 
lab2b0b: ld a,l 
lab2b0c: xor #10 
lab2b0e: ld l,a 
lab2b0f: scf 
lab2b10: adc hl,hl 
lab2b12: ld (#b1eb),hl		;; store crc 
lab2b15: ret 
;;========================================================================================
;; get stored data crc and 1''s complement it
;; initialise ready to write to cassette or to compare against crc from cassette
lab2b16: ld hl,(#b1eb)		;; block crc 
;; 1''s complement crc
lab2b19: ld a,l 
lab2b1a: cpl 
lab2b1b: ld e,a 
lab2b1c: ld a,h 
lab2b1d: cpl 
lab2b1e: ld d,a 
lab2b1f: ret 
;;========================================================================================
;; read data-byte
lab2b20: push de 
lab2b21: ld e,#08			;; number of data-bits 
lab2b23: ld hl,(#b1e6) 
;; H = timing constant
;; L = initial cassette data input state
lab2b26: call #2b44			;; get edge 
lab2b29: call c,#2b4d			;; get edge 
lab2b2c: jr nc,#2b3b 
lab2b2e: ld a,h				;; ideal time 
lab2b2f: sub c				;; subtract measured time 
;; -ve (1 pulse) or +ve (0 pulse)
lab2b30: sbc a,a 
;; if -ve, set carry
;; if +ve, clear carry
;; carry flag = bit state: carry set = 1 bit, carry clear = 0 bit
lab2b31: rl d				;; shift carry state into bit 0 
;; updating data-byte
lab2b33: call #2b00			;; update crc 
lab2b36: dec e 
lab2b37: jr nz,#2b23 ; 
lab2b39: ld a,d 
lab2b3a: scf 
lab2b3b: pop de 
lab2b3c: ret 
;;========================================================================================
;; sample edge and check for escape
;; L = bit-sequence which is shifted after each edge detected
;; starts of as &55 (%01010101)
;; check for escape
lab2b3d: ld b,#f4		;; PPI port A 
lab2b3f: in a,(c)		;; read keyboard data through PPI port A (connected to PSG port A) 
lab2b41: and #04			;; escape key pressed? 
;; bit 2 is 0 if escape key pressed
lab2b43: ret z 
;; precompensation?
lab2b44: ld a,r 
;; round up to divisible by 4
;; i.e.
;; 0->0, 
;; 1->4, 
;; 2->4, 
;; 3->4, 
;; 4->8, 
;; 5->8
;; etc
lab2b46: add a,#03 
lab2b48: rrca					;; /2 
lab2b49: rrca					;; /4 
lab2b4a: and #1f			;; 
lab2b4c: ld c,a 
lab2b4d: ld b,#f5		; PPI port B input (includes cassette data input) 
;; -----------------------------------------------------
;; loop to count time between edges
;; C = time in 17us units (68T states)
;; carry set = edge arrived within time
;; carry clear = edge arrived too late
lab2b4f: ld a,c		; [1] update edge timer 
lab2b50: add a,#02		; [2] 
lab2b52: ld c,a		; [1] 
lab2b53: jr c,#2b63 ; [3] overflow? 
lab2b55: in a,(c)		; [4] read cassette input data 
lab2b57: xor l		; [1] 
lab2b58: and #80		; [2] isolate cassette input in bit 7 
lab2b5a: jr nz,#2b4f ; [3] has bit 7 (cassette data input) changed state? 
;; pulse successfully read
lab2b5c: xor a 
lab2b5d: ld r,a 
lab2b5f: rrc l		; toggles between 0 and 1 
lab2b61: scf 
lab2b62: ret 
;; time-out
lab2b63: xor a 
lab2b64: ld r,a 
lab2b66: inc a		; "read error a" 
lab2b67: ret 
;;========================================================================================
;; write data byte to cassette
;; A = data byte
lab2b68: push de 
lab2b69: ld e,#08			;; number of bits 
lab2b6b: ld d,a 
lab2b6c: rlc d				;; shift bit state into carry 
lab2b6e: call #2b78			;; write bit to cassette 
lab2b71: jr nc,#2b76 
lab2b73: dec e 
lab2b74: jr nz,#2b6c ;; loop for next bit 
lab2b76: pop de 
lab2b77: ret 
;;========================================================================================
;; write bit to cassette
;;
;; carry flag = state of bit
;; carry set = 1 data bit
;; carry clear = 0 data bit
lab2b78: ld bc,(#b1e8) 
lab2b7c: ld hl,(#b1ea) 
lab2b7f: sbc a,a 
lab2b80: ld h,a 
lab2b81: jr z,#2b8a ; (+#07) 
lab2b83: ld a,l 
lab2b84: add a,a 
lab2b85: add a,b 
lab2b86: ld l,a 
lab2b87: ld a,c 
lab2b88: sub b 
lab2b89: ld c,a 
lab2b8a: ld a,l 
lab2b8b: ld (#b1e8),a 
;; write a low level
lab2b8e: ld l,#0a			; %00001010 = clear bit 5 (cassette write data) 
lab2b90: call #2ba7 
lab2b93: jr c,#2b9b ; (+#06) 
lab2b95: sub c 
lab2b96: jr nc,#2ba4 ; (+#0c) 
lab2b98: cpl 
lab2b99: inc a 
lab2b9a: ld c,a 
lab2b9b: ld a,h 
lab2b9c: call #2b00			; update crc 
;; write a high level
lab2b9f: ld l,#0b			; %00001011 = set bit 5 (cassette write data) 
lab2ba1: call #2ba7 
lab2ba4: ld a,#01 
lab2ba6: ret 
;;=====================================================================
;; write level to cassette
;; uses PPI control bit set/clear function
;; L = PPI Control byte 
;;   bit 7 = 0
;;   bit 3,2,1 = bit index
;;   bit 0: 1=bit set, 0=bit clear
lab2ba7: ld a,r 
lab2ba9: srl a 
lab2bab: sub c 
lab2bac: jr nc,#2bb1 ; 
;; delay in 4us (16T-state) units
;; total delay = ((A-1)*4) + 3
lab2bae: inc a				; [1] 
lab2baf: jr nz,#2bae ; [3] 
;; set low/high level
lab2bb1: ld b,#f7			; PPI control 
lab2bb3: out (c),l			; set control 
lab2bb5: push af 
lab2bb6: xor a 
lab2bb7: ld r,a 
lab2bb9: pop af 
lab2bba: ret 
;;=====================================================================
CAS_START_MOTOR:
;;
;; start cassette motor (if cassette motor was previously off
;; allow to to achieve full rotational speed)
lab2bbb: ld a,#10			; start cassette motor 
lab2bbd: jr #2bc1 ; CAS RESTORE MOTOR 
;;=====================================================================
CAS_STOP_MOTOR:
lab2bbf: ld a,#ef			; stop cassette motor 
;;=====================================================================
CAS_RESTORE_MOTOR:
;;
;; - if motor was switched from off->on, delay for a time to allow
;; cassette motor to achieve full rotational speed
;; - if motor was switched from on->off, do nothing
;; bit 4 of register A = cassette motor state
lab2bc1: push bc 
lab2bc2: ld b,#f6		; B = I/O address for PPI port C 
lab2bc4: in c,(c)		; read current inputs (includes cassette input data) 
lab2bc6: inc b			; B = I/O address for PPI control 
lab2bc7: and #10			; isolate cassette motor state from requested 
; cassette motor status
lab2bc9: ld a,#08		; %00001000	= cassette motor off 
lab2bcb: jr z,#2bce 
lab2bcd: inc a			; %00001001 = cassette motor on 
lab2bce: out (c),a		; set the requested motor state 
; (uses PPI Control bit set/reset feature)
lab2bd0: scf 
lab2bd1: jr z,#2bdf 
lab2bd3: ld a,c 
lab2bd4: and #10			; previous state 
lab2bd6: push bc 
lab2bd7: ld bc,#00c8		; delay in 1/100ths of a second 
lab2bda: scf 
lab2bdb: call z,#2be2		; delay for 2 seconds 
lab2bde: pop bc 
lab2bdf: ld a,c 
lab2be0: pop bc 
lab2be1: ret 
;;=================================================================
;; delay & check for escape; allows cassette motor to achieve full
;; rotational speed
;; entry conditions:
;; B = delay factor in 1/100ths of a second
;; exit conditions:
;; c = delay completed and escape was not pressed
;; nc = escape was pressed
lab2be2: push bc 
lab2be3: push hl 
lab2be4: call #2bf9		;; 1/100th of a second delay 
lab2be7: ld a,#42		;; keycode for escape key 
lab2be9: call #1e45		;; check for escape pressed (km test key) 
;; if non-zero then escape key has been pressed
;; if zero, then escape key is not pressed
lab2bec: pop hl 
lab2bed: pop bc 
lab2bee: jr nz,#2bf7		;; escape key pressed? 
;; continue delay
lab2bf0: dec bc 
lab2bf1: ld a,b 
lab2bf2: or c 
lab2bf3: jr nz,#2be2 
;; delay completed successfully and escape was not pressed
lab2bf5: scf 
lab2bf6: ret 
;; escape was pressed
lab2bf7: xor a 
lab2bf8: ret 
;;========================================================================================
;; 1/10th of a second delay
lab2bf9: ld bc,#0682			; [3] 
;; total delay is ((BC-1)*(2+1+1+3)) + (2+1+1+2) + 3 + 3 = 11667 microseconds
;; there are 1000000 microseconds in a second
;; therefore delay is 11667/1000000 = 0.01 seconds or 1/100th of a second
lab2bfc: dec bc				; [2] 
lab2bfd: ld a,b				; [1] 
lab2bfe: or c				; [1] 
lab2bff: jr nz,#2bfc ; [3] 
lab2c01: ret						; [3] 
;;========================================================================================
EDIT:
;; HL = address of buffer
lab2c02: push bc 
lab2c03: push de 
lab2c04: push hl 
lab2c05: call #2df2			; reset relative cursor pos 
lab2c08: ld bc,#00ff 
; B = position in edit buffer
; C = number of characters remaining in buffer
;; if there is a number at the start of the line then skip it
lab2c0b: ld a,(hl) 
lab2c0c: cp #30				; ''0'' 
lab2c0e: jr c,#2c17 ; (+#07) 
lab2c10: cp #3a				; ''9''+1 
lab2c12: call c,#2c42 
lab2c15: jr c,#2c0b 
;;--------------------------------------------------------------------
;; all other characters
lab2c17: ld a,b 
lab2c18: or a 
;; zero flag set if start of buffer, zero flag clear if not start of buffer
lab2c19: ld a,(hl) 
lab2c1a: call nz,#2c42 
lab2c1d: push hl 
lab2c1e: inc c 
lab2c1f: ld a,(hl) 
lab2c20: inc hl 
lab2c21: or a 
lab2c22: jr nz,#2c1e ; (-#06) 
lab2c24: ld (#b115),a		; insert/overwrite mode 
lab2c27: pop hl 
lab2c28: call #2ee4 
lab2c2b: push bc 
lab2c2c: push hl 
lab2c2d: call #2f56 
lab2c30: pop hl 
lab2c31: pop bc 
lab2c32: call #2c48			; process key 
lab2c35: jr nc,#2c2b ; (-#0c) 
lab2c37: push af 
lab2c38: call #2e4f 
lab2c3b: pop af 
lab2c3c: pop hl 
lab2c3d: pop de 
lab2c3e: pop bc 
lab2c3f: cp #fc 
lab2c41: ret 
;;--------------------------------------------------------------------
;; used to skip characters in input buffer
lab2c42: inc c 
lab2c43: inc b		; increment pos 
lab2c44: inc hl		; increment position in buffer 
lab2c45: jp #2f25 
;;--------------------------------------------------------------------
lab2c48: push hl 
lab2c49: ld hl,#2c72 
lab2c4c: ld e,a 
lab2c4d: ld a,b 
lab2c4e: or c 
lab2c4f: ld a,e 
lab2c50: jr nz,#2c5d ; (+#0b) 
lab2c52: cp #f0				; 
lab2c54: jr c,#2c5d ; (+#07) 
lab2c56: cp #f4 
lab2c58: jr nc,#2c5d ; (+#03) 
;; cursor keys
lab2c5a: ld hl,#2cae 
;;--------------------------------------------------------------------
lab2c5d: ld d,(hl) 
lab2c5e: inc hl 
lab2c5f: push hl 
lab2c60: inc hl 
lab2c61: inc hl 
lab2c62: cp (hl) 
lab2c63: inc hl 
lab2c64: jr z,#2c6a ; (+#04) 
lab2c66: dec d 
lab2c67: jr nz,#2c60 ; (-#09) 
lab2c69: ex (sp),hl 
lab2c6a: pop af 
lab2c6b: ld a,(hl) 
lab2c6c: inc hl 
lab2c6d: ld h,(hl) 
lab2c6e: ld l,a 
lab2c6f: ld a,e 
lab2c70: ex (sp),hl 
lab2c71: ret 
;; keys for editing an existing line
lab2c72: 
defb #13
defw #2d8a
defb #fc								; ESC key
defw #2cd0								
defb #ef
defw #2cce
defb #0d								; RETURN key
defw #2cf2
defb #f0								; up cursor key
defw #2d3c
defb #f1								; down cursor key
defw #2d0a
defb #f2								; left cursor key
defw #2d34
defb #f3								; right cursor key
defw #2d02
defb #f8								; CTRL key + up cursor key
defw #2d4f
defb #f9								; CTRL key + down cursor key
defw #2d1d
defb #fa								; CTRL key + left cursor key
defw #2d45
defb #fb								; CTRL key + right cursor key
defw #2d14
defb #f4								; SHIFT key + up cursor key
defw #2e21
defb #f5								; SHIFT key + down cursor key
defw #2e26
defb #f6								; SHIFT key + left cursor key
defw #2e1c
defb #f7								; SHIFT key + right cursor key
defw #2e17								
defb #e0								; COPY key
defw #2e65
defb #7f								; ESC key
defw #2dc3
defb #10								; CLR key
defw #2dcd
defb #e1								; CTRL key+TAB key (toggle insert/overwrite)
defw #2d81
;;--------------------------------------------------------------------
;; keys for 
lab2cae:: 
defb #04
defw #2cfe								; Sound bleeper
defb #f0								; up cursor key
defw #2cbd								; Move cursor up a line
defb #f1								; down cursor key
defw #2cc1								; Move cursor down a line
defb #f2								; left cursor key
defw #2cc9								; Move cursor back one character
defb #f3								; right cursor key
defw #2cc5								; Move cursor forward one character
;;--------------------------------------------------------------------
;; up cursor key pressed
lab2cbd: ld a,#0b			; VT (Move cursor up a line) 
lab2cbf: jr #2ccb ; 
;;--------------------------------------------------------------------
;; down cursor key pressed
lab2cc1: ld a,#0a			; LF (Move cursor down a line) 
lab2cc3: jr #2ccb 
;;--------------------------------------------------------------------
;; right cursor key pressed
lab2cc5: ld a,#09			; TAB (Move cursor forward one character) 
lab2cc7: jr #2ccb ; 
;;--------------------------------------------------------------------
;; left cursor key pressed
lab2cc9: ld a,#08			; BS (Move character back one character) 
;;--------------------------------------------------------------------
lab2ccb: call #13fe			; TXT OUTPUT 
;;--------------------------------------------------------------------
lab2cce: or a 
lab2ccf: ret 
;;--------------------------------------------------------------------
lab2cd0: call #2cf2			; display message 
lab2cd3: push af 
lab2cd4: ld hl,#2cea			; "*Break*" 
lab2cd7: call #2cf2			; display message 
lab2cda: call #117c			; TXT GET CURSOR 
lab2cdd: dec h 
lab2cde: jr z,#2ce8 
;; go to next line
lab2ce0: ld a,#0d			; CR (Move cursor to left edge of window on current line) 
lab2ce2: call #13fe			; TXT OUTPUT 
lab2ce5: call #2cc1			; Move cursor down a line 
lab2ce8: pop af 
lab2ce9: ret 
;;--------------------------------------------------------------------
lab2cea: 
defb "*Break*",0
;;--------------------------------------------------------------------
;; display 0 terminated string
lab2cf2: push af 
lab2cf3: ld a,(hl)			; get character 
lab2cf4: inc hl 
lab2cf5: or a				; end of string marker? 
lab2cf6: call nz,#2f25			; display character 
lab2cf9: jr nz,#2cf3 ; loop for next character 
lab2cfb: pop af 
lab2cfc: scf 
lab2cfd: ret 
;;===========================================================================
lab2cfe: ld a,#07			; BEL (Sound bleeper) 
lab2d00: jr #2ccb 
;;===========================================================================
;; right cursor key pressed
lab2d02: ld d,#01 
lab2d04: call #2d1e 
lab2d07: jr z,#2cfe ; (-#0b) 
lab2d09: ret 
;;===========================================================================
;; down cursor key pressed
lab2d0a: call #2d73 
lab2d0d: ld a,c 
lab2d0e: sub b 
lab2d0f: cp d 
lab2d10: jr c,#2cfe ; (-#14) 
lab2d12: jr #2d1e ; (+#0a) 
;;--------------------------------------------------------------------
;; CTRL key + right cursor key pressed
;; 
;; go to end of current line
lab2d14: call #2d73 
lab2d17: ld a,d 
lab2d18: sub e 
lab2d19: ret z 
lab2d1a: ld d,a 
lab2d1b: jr #2d1e ; (+#01) 
;;--------------------------------------------------------------------
;; CTRL key + down cursor key pressed
;;
;; go to end of text 
lab2d1d: ld d,c 
;;--------------------------------------------------------------------
lab2d1e: ld a,b 
lab2d1f: cp c 
lab2d20: ret z 
lab2d21: push de 
lab2d22: call #2ecd 
lab2d25: ld a,(hl) 
lab2d26: call nc,#2f25 
lab2d29: inc b 
lab2d2a: inc hl 
lab2d2b: call nc,#2ee4 
lab2d2e: pop de 
lab2d2f: dec d 
lab2d30: jr nz,#2d1e ; (-#14) 
lab2d32: jr #2d70 ; (+#3c) 
;;===========================================================================
;; left cursor key pressed
lab2d34: ld d,#01 
lab2d36: call #2d50 
lab2d39: jr z,#2cfe ; (-#3d) 
lab2d3b: ret 
;;===========================================================================
;; up cursor key pressed
lab2d3c: call #2d73 
lab2d3f: ld a,b 
lab2d40: cp d 
lab2d41: jr c,#2cfe ; (-#45) 
lab2d43: jr #2d50 ; (+#0b) 
;;===========================================================================
;; CTRL key + left cursor key pressed
;;
;; go to start of current line
lab2d45: call #2d73 
lab2d48: ld a,e 
lab2d49: sub #01 
lab2d4b: ret z 
lab2d4c: ld d,a 
lab2d4d: jr #2d50 ; (+#01) 
;;===========================================================================
;; CTRL key + up cursor key pressed
;; go to start of text
lab2d4f: ld d,c 
lab2d50: ld a,b 
lab2d51: or a 
lab2d52: ret z 
lab2d53: call #2ec7 
lab2d56: jr nc,#2d5f ; (+#07) 
lab2d58: dec b 
lab2d59: dec hl 
lab2d5a: dec d 
lab2d5b: jr nz,#2d50 ; (-#0d) 
lab2d5d: jr #2d70 ; (+#11) 
;;===========================================================================
lab2d5f: ld a,b 
lab2d60: or a 
lab2d61: jr z,#2d6d ; (+#0a) 
lab2d63: dec b 
lab2d64: dec hl 
lab2d65: push de 
lab2d66: call #2ea2 
lab2d69: pop de 
lab2d6a: dec d 
lab2d6b: jr nz,#2d5f ; (-#0e) 
lab2d6d: call #2ee4 
lab2d70: or #ff 
lab2d72: ret 
;;--------------------------------------------------------------------
lab2d73: push hl 
lab2d74: call #1252			; TXT GET WINDOW 
lab2d77: ld a,d 
lab2d78: sub h 
lab2d79: inc a 
lab2d7a: ld d,a 
lab2d7b: call #117c			; TXT GET CURSOR 
lab2d7e: ld e,h 
lab2d7f: pop hl 
lab2d80: ret 
;;--------------------------------------------------------------------
;; CTRL key + TAB key
;; 
;; toggle insert/overwrite mode
lab2d81: ld a,(#b115)		; insert/overwrite mode 
lab2d84: cpl 
lab2d85: ld (#b115),a 
lab2d88: or a 
lab2d89: ret 
;;--------------------------------------------------------------------
lab2d8a: or a 
lab2d8b: ret z 
lab2d8c: ld e,a 
lab2d8d: ld a,(#b115)		; insert/overwrite mode 
lab2d90: or a 
lab2d91: ld a,c 
lab2d92: jr z,#2d9f ; (+#0b) 
lab2d94: cp b 
lab2d95: jr z,#2d9f ; (+#08) 
lab2d97: ld (hl),e 
lab2d98: inc hl 
lab2d99: inc b 
lab2d9a: or a 
lab2d9b: ld a,e 
lab2d9c: jp #2f25 
lab2d9f: cp #ff 
lab2da1: jp z,#2cfe 
lab2da4: xor a 
lab2da5: ld (#b114),a 
lab2da8: call #2d9b 
lab2dab: inc c 
lab2dac: push hl 
lab2dad: ld a,(hl) 
lab2dae: ld (hl),e 
lab2daf: ld e,a 
lab2db0: inc hl 
lab2db1: or a 
lab2db2: jr nz,#2dad ; (-#07) 
lab2db4: ld (hl),a 
lab2db5: pop hl 
lab2db6: inc b 
lab2db7: inc hl 
lab2db8: call #2ee4 
lab2dbb: ld a,(#b114) 
lab2dbe: or a 
lab2dbf: call nz,#2ea2 
lab2dc2: ret 
;; ESC key pressed
lab2dc3: ld a,b 
lab2dc4: or a 
lab2dc5: call nz,#2ec7 
lab2dc8: jp nc,#2cfe 
lab2dcb: dec b 
lab2dcc: dec hl 
;; CLR key pressed
lab2dcd: ld a,b 
lab2dce: cp c 
lab2dcf: jp z,#2cfe 
lab2dd2: push hl 
lab2dd3: inc hl 
lab2dd4: ld a,(hl) 
lab2dd5: dec hl 
lab2dd6: ld (hl),a 
lab2dd7: inc hl 
lab2dd8: or a 
lab2dd9: jr nz,#2dd3 ; (-#08) 
lab2ddb: dec hl 
lab2ddc: ld (hl),#20 
lab2dde: ld (#b114),a 
lab2de1: ex (sp),hl 
lab2de2: call #2ee4 
lab2de5: ex (sp),hl 
lab2de6: ld (hl),#00 
lab2de8: pop hl 
lab2de9: dec c 
lab2dea: ld a,(#b114) 
lab2ded: or a 
lab2dee: call nz,#2ea6 
lab2df1: ret 
;;--------------------------------------------------------------------
;; initialise relative copy cursor position to origin
lab2df2: xor a 
lab2df3: ld (#b116),a 
lab2df6: ld (#b117),a 
lab2df9: ret 
;;--------------------------------------------------------------------
;; compare copy cursor relative position
;; HL = cursor position
lab2dfa: ld de,(#b116) 
lab2dfe: ld a,h 
lab2dff: xor d 
lab2e00: ret nz 
lab2e01: ld a,l 
lab2e02: xor e 
lab2e03: ret nz 
lab2e04: scf 
lab2e05: ret 
;;--------------------------------------------------------------------
lab2e06: ld c,a 
lab2e07: call #2ec1			; get copy cursor position 
lab2e0a: ret z				; quit if not active 
;; adjust y position
lab2e0b: ld a,l 
lab2e0c: add a,c 
lab2e0d: ld l,a 
;; validate new position
lab2e0e: call #11ca			; TXT VALIDATE 
lab2e11: jr nc,#2df2 ; reset relative cursor pos 
;; set cursor position
lab2e13: ld (#b116),hl 
lab2e16: ret 
;;--------------------------------------------------------------------
;; SHIFT key + left cursor key
;; 
;; move copy cursor left
lab2e17: ld de,#0100 
lab2e1a: jr #2e29 ; (+#0d) 
;;--------------------------------------------------------------------
;; SHIFT key + right cursor pressed
;; 
;; move copy cursor right
lab2e1c: ld de,#ff00 
lab2e1f: jr #2e29 ; (+#08) 
;;--------------------------------------------------------------------
;; SHIFT key + up cursor pressed
;;
;; move copy cursor up
lab2e21: ld de,#00ff 
lab2e24: jr #2e29 ; (+#03) 
;;--------------------------------------------------------------------
;; SHIFT key + left cursor pressed
;;
;; move copy cursor down
lab2e26: ld de,#0001 
;;--------------------------------------------------------------------
;; D = column increment
;; E = row increment
lab2e29: push bc 
lab2e2a: push hl 
lab2e2b: call #2ec1			; get copy cursor position 
;; get cursor position
lab2e2e: call z,#117c			; TXT GET CURSOR 
;; adjust cursor position
;; adjust column
lab2e31: ld a,h 
lab2e32: add a,d 
lab2e33: ld h,a 
;; adjust row
lab2e34: ld a,l 
lab2e35: add a,e 
lab2e36: ld l,a 
;; validate the position
lab2e37: call #11ca			; TXT VALIDATE 
lab2e3a: jr nc,#2e47 ; position invalid? 
;; position is valid
lab2e3c: push hl 
lab2e3d: call #2e4f 
lab2e40: pop hl 
;; store new position
lab2e41: ld (#b116),hl 
lab2e44: call #2e4a 
;;----------------
lab2e47: pop hl 
lab2e48: pop bc 
lab2e49: ret 
;;--------------------------------------------------------------------
lab2e4a: ld de,#1265			; TXT PLACE CURSOR/TXT REMOVE CURSOR 
lab2e4d: jr #2e52 
;;--------------------------------------------------------------------
lab2e4f: ld de,#1265			; TXT PLACE CURSOR/TXT REMOVE CURSOR 
;;--------------------------------------------------------------------
lab2e52: call #2ec1			; get copy cursor position 
lab2e55: ret z 
lab2e56: push hl 
lab2e57: call #117c			; TXT GET CURSOR 
lab2e5a: ex (sp),hl 
lab2e5b: call #1170			; TXT SET CURSOR 
lab2e5e: call #0016			; LOW: PCDE INSTRUCTION 
lab2e61: pop hl 
lab2e62: jp #1170			; TXT SET CURSOR 
;;--------------------------------------------------------------------
;; COPY key pressed
lab2e65: push bc 
lab2e66: push hl 
lab2e67: call #117c			; TXT GET CURSOR 
lab2e6a: ex de,hl 
lab2e6b: call #2ec1 
lab2e6e: jr nz,#2e7c ; perform copy 
lab2e70: ld a,b 
lab2e71: or c 
lab2e72: jr nz,#2e9a ; (+#26) 
lab2e74: call #117c			; TXT GET CURSOR 
lab2e77: ld (#b116),hl 
lab2e7a: jr #2e82 ; (+#06) 
;;--------------------------------------------------------------------
lab2e7c: call #1170			; TXT SET CURSOR 
lab2e7f: call #1265			; TXT PLACE CURSOR/TXT REMOVE CURSOR 
lab2e82: call #13ac			; TXT RD CHAR 
lab2e85: push af 
lab2e86: ex de,hl 
lab2e87: call #1170			; TXT SET CURSOR 
lab2e8a: ld hl,(#b116) 
lab2e8d: inc h 
lab2e8e: call #11ca			; TXT VALIDATE 
lab2e91: jr nc,#2e96 ; (+#03) 
lab2e93: ld (#b116),hl 
lab2e96: call #2e4a 
lab2e99: pop af 
lab2e9a: pop hl 
lab2e9b: pop bc 
lab2e9c: jp c,#2d8a 
lab2e9f: jp #2cfe 
;;--------------------------------------------------------------------
lab2ea2: ld d,#01 
lab2ea4: jr #2ea8 ; (+#02) 
;;--------------------------------------------------------------------
lab2ea6: ld d,#ff 
;;--------------------------------------------------------------------
lab2ea8: push bc 
lab2ea9: push hl 
lab2eaa: push de 
lab2eab: call #2e4f 
lab2eae: pop de 
lab2eaf: call #2ec1 
lab2eb2: jr z,#2ebd ; (+#09) 
lab2eb4: ld a,h 
lab2eb5: add a,d 
lab2eb6: ld h,a 
lab2eb7: call #2e0e 
lab2eba: call #2e4a 
lab2ebd: pop hl 
lab2ebe: pop bc 
lab2ebf: or a 
lab2ec0: ret 
;;--------------------------------------------------------------------
;; get copy cursor position
;; this is relative to the actual cursor pos
;;
;; zero flag set if cursor is not active
lab2ec1: ld hl,(#b116) 
lab2ec4: ld a,h 
lab2ec5: or l 
lab2ec6: ret 
;;--------------------------------------------------------------------
;; try to move cursor left?
lab2ec7: push de 
lab2ec8: ld de,#ff08 
lab2ecb: jr #2ed1 ; (+#04) 
;;--------------------------------------------------------------------
;; try to move cursor right?
lab2ecd: push de 
lab2ece: ld de,#0109 
;;--------------------------------------------------------------------
;; D = column increment
;; E = character to plot
lab2ed1: push bc 
lab2ed2: push hl 
;; get current cursor position
lab2ed3: call #117c			; TXT GET CURSOR 
;; adjust cursor position
lab2ed6: ld a,d				; column increment 
lab2ed7: add a,h				; add on column 
lab2ed8: ld h,a				; final column 
;; validate this new position
lab2ed9: call #11ca			; TXT VALIDATE 
;; if valid then output character, otherwise report error
lab2edc: ld a,e 
lab2edd: call c,#13fe			; TXT OUTPUT 
lab2ee0: pop hl 
lab2ee1: pop bc 
lab2ee2: pop de 
lab2ee3: ret 
;;--------------------------------------------------------------------
lab2ee4: push bc 
lab2ee5: push hl 
lab2ee6: ex de,hl 
lab2ee7: call #117c			; TXT GET CURSOR 
lab2eea: ld c,a 
lab2eeb: ex de,hl 
lab2eec: ld a,(hl) 
lab2eed: inc hl 
lab2eee: or a 
lab2eef: call nz,#2f02 
lab2ef2: jr nz,#2eec ; (-#08) 
lab2ef4: call #117c			; TXT GET CURSOR 
lab2ef7: sub c 
lab2ef8: ex de,hl 
lab2ef9: add a,l 
lab2efa: ld l,a 
lab2efb: call #1170			; TXT SET CURSOR 
lab2efe: pop hl 
lab2eff: pop bc 
lab2f00: or a 
lab2f01: ret 
lab2f02: push af 
lab2f03: push bc 
lab2f04: push de 
lab2f05: push hl 
lab2f06: ld b,a 
lab2f07: call #117c			; TXT GET CURSOR 
lab2f0a: sub c 
lab2f0b: add a,e 
lab2f0c: ld e,a 
lab2f0d: ld c,b 
lab2f0e: call #11ca			; TXT VALIDATE 
lab2f11: jr c,#2f18 ; (+#05) 
lab2f13: ld a,b 
lab2f14: add a,a 
lab2f15: inc a 
lab2f16: add a,e 
lab2f17: ld e,a 
lab2f18: ex de,hl 
lab2f19: call #11ca			; TXT VALIDATE 
lab2f1c: ld a,c 
lab2f1d: call c,#2f25 
lab2f20: pop hl 
lab2f21: pop de 
lab2f22: pop bc 
lab2f23: pop af 
lab2f24: ret 
lab2f25: push af 
lab2f26: push bc 
lab2f27: push de 
lab2f28: push hl 
lab2f29: ld b,a 
lab2f2a: call #117c			; TXT GET CURSOR 
lab2f2d: ld c,a 
lab2f2e: push bc 
lab2f2f: call #11ca			; TXT VALIDATE 
lab2f32: pop bc 
lab2f33: call c,#2dfa 
lab2f36: push af 
lab2f37: call c,#2e4f 
lab2f3a: ld a,b 
lab2f3b: push bc 
lab2f3c: call #1335			; TXT WR CHAR 
lab2f3f: pop bc 
lab2f40: call #117c			; TXT GET CURSOR 
lab2f43: sub c 
lab2f44: call nz,#2e06 
lab2f47: pop af 
lab2f48: jr nc,#2f51 ; (+#07) 
lab2f4a: sbc a,a 
lab2f4b: ld (#b114),a 
lab2f4e: call #2e4a 
lab2f51: pop hl 
lab2f52: pop de 
lab2f53: pop bc 
lab2f54: pop af 
lab2f55: ret 
lab2f56: call #117c			; TXT GET CURSOR 
lab2f59: ld c,a 
lab2f5a: call #11ca			; TXT VALIDATE 
lab2f5d: call #2dfa 
lab2f60: jp c,#1bbf			; KM WAIT CHAR 
lab2f63: call #1276			; TXT CUR ON 
lab2f66: call #117c			; TXT GET CURSOR 
lab2f69: sub c 
lab2f6a: call nz,#2e06 
lab2f6d: call #1bbf			; KM WAIT CHAR 
lab2f70: jp #127e			; TXT CUR OFF 
;;===========================================================================================
MATHS_FUNCTIONS:
REAL_PI:
lab2f73: ld de,#2f78 
lab2f76: jr #2f91 
lab2f78: 
defb #a2,#da,#0f,#49,#82				;; PI in floating point format
;;===========================================================================================
REAL_ONE:
lab2f7d: ld de,#2f82 
lab2f80: jr #2f91 ; (+#0f) 
lab2f82: 
defb #00,#00,#00,#00,#81			;; 1 in floating point format
;;===========================================================================================
lab2f87: ex de,hl 
lab2f88: ld hl,#b10e 
lab2f8b: jr #2f91 ; (+#04) 
;;===========================================================================================
lab2f8d: ld de,#b104 
lab2f90: ex de,hl 
;; REAL move
;; HL = points to address to write floating point number to
;; DE = points to address of a floating point number
lab2f91: push hl 
lab2f92: push de 
lab2f93: push bc 
lab2f94: ex de,hl 
lab2f95: ld bc,#0005 
lab2f98: ldir 
lab2f9a: pop bc 
lab2f9b: pop de 
lab2f9c: pop hl 
lab2f9d: scf 
lab2f9e: ret 
;; INT to real
lab2f9f: push de 
lab2fa0: push bc 
lab2fa1: or #7f 
lab2fa3: ld b,a 
lab2fa4: xor a 
lab2fa5: ld (de),a 
lab2fa6: inc de 
lab2fa7: ld (de),a 
lab2fa8: inc de 
lab2fa9: ld c,#90 
lab2fab: or h 
lab2fac: jr nz,#2fbb ; (+#0d) 
lab2fae: ld c,a 
lab2faf: or l 
lab2fb0: jr z,#2fbf ; (+#0d) 
lab2fb2: ld l,h 
lab2fb3: ld c,#88 
lab2fb5: jr #2fbb ; (+#04) 
lab2fb7: dec c 
lab2fb8: sla l 
lab2fba: adc a,a 
lab2fbb: jp p,#2fb7 
lab2fbe: and b 
lab2fbf: ex de,hl 
lab2fc0: ld (hl),e 
lab2fc1: inc hl 
lab2fc2: ld (hl),a 
lab2fc3: inc hl 
lab2fc4: ld (hl),c 
lab2fc5: pop bc 
lab2fc6: pop hl 
lab2fc7: ret 
;; BIN to real
lab2fc8: push bc 
lab2fc9: ld bc,#a000 
lab2fcc: call #2fd3 
lab2fcf: pop bc 
lab2fd0: ret 
lab2fd1: ld b,#a8 
lab2fd3: push de 
lab2fd4: call #379c 
lab2fd7: pop de 
lab2fd8: ret 
;; REAL to int
lab2fd9: push hl 
lab2fda: pop ix 
lab2fdc: xor a 
lab2fdd: sub (ix+#04) 
lab2fe0: jr z,#2ffd ; (+#1b) 
lab2fe2: add a,#90 
lab2fe4: ret nc 
lab2fe5: push de 
lab2fe6: push bc 
lab2fe7: add a,#10 
lab2fe9: call #373d 
lab2fec: sla c 
lab2fee: adc hl,de 
lab2ff0: jr z,#2ffa ; (+#08) 
lab2ff2: ld a,(ix+#03) 
lab2ff5: or a 
lab2ff6: ccf 
lab2ff7: pop bc 
lab2ff8: pop de 
lab2ff9: ret 
lab2ffa: sbc a,a 
lab2ffb: jr #2ff6 ; (-#07) 
lab2ffd: ld l,a 
lab2ffe: ld h,a 
lab2fff: scf 
lab3000: ret 
;; REAL to bin
lab3001: call #3014 
lab3004: ret nc 
lab3005: ret p 
lab3006: push hl 
lab3007: ld a,c 
lab3008: inc (hl) 
lab3009: jr nz,#3011 ; (+#06) 
lab300b: inc hl 
lab300c: dec a 
lab300d: jr nz,#3008 ; (-#07) 
lab300f: inc (hl) 
lab3010: inc c 
lab3011: pop hl 
lab3012: scf 
lab3013: ret 
;; REAL fix
lab3014: push hl 
lab3015: push de 
lab3016: push hl 
lab3017: pop ix 
lab3019: xor a 
lab301a: sub (ix+#04) 
lab301d: jr nz,#3029 ; (+#0a) 
lab301f: ld b,#04 
lab3021: ld (hl),a 
lab3022: inc hl 
lab3023: djnz #3021 ; (-#04) 
lab3025: ld c,#01 
lab3027: jr #3051 ; (+#28) 
lab3029: add a,#a0 
lab302b: jr nc,#3052 ; (+#25) 
lab302d: push hl 
lab302e: call #373d 
lab3031: xor a 
lab3032: cp b 
lab3033: adc a,a 
lab3034: or c 
lab3035: ld c,l 
lab3036: ld b,h 
lab3037: pop hl 
lab3038: ld (hl),c 
lab3039: inc hl 
lab303a: ld (hl),b 
lab303b: inc hl 
lab303c: ld (hl),e 
lab303d: inc hl 
lab303e: ld e,a 
lab303f: ld a,(hl) 
lab3040: ld (hl),d 
lab3041: and #80 
lab3043: ld b,a 
lab3044: ld c,#04 
lab3046: xor a 
lab3047: or (hl) 
lab3048: jr nz,#304f ; (+#05) 
lab304a: dec hl 
lab304b: dec c 
lab304c: jr nz,#3047 ; (-#07) 
lab304e: inc c 
lab304f: ld a,e 
lab3050: or a 
lab3051: scf 
lab3052: pop de 
lab3053: pop hl 
lab3054: ret 
;; REAL int
lab3055: call #3014 
lab3058: ret nc 
lab3059: ret z 
lab305a: bit 7,b 
lab305c: ret z 
lab305d: jr #3006 ; (-#59) 
lab305f: call #3727 
lab3062: ld b,a 
lab3063: jr z,#30b7 ; (+#52) 
lab3065: call m,#3734 
lab3068: push hl 
lab3069: ld a,(ix+#04) 
lab306c: sub #80 
lab306e: ld e,a 
lab306f: sbc a,a 
lab3070: ld d,a 
lab3071: ld l,e 
lab3072: ld h,d 
lab3073: add hl,hl 
lab3074: add hl,hl 
lab3075: add hl,hl 
lab3076: add hl,de 
lab3077: add hl,hl 
lab3078: add hl,de 
lab3079: add hl,hl 
lab307a: add hl,hl 
lab307b: add hl,de 
lab307c: ld a,h 
lab307d: sub #09 
lab307f: ld c,a 
lab3080: pop hl 
lab3081: push bc 
lab3082: call nz,#30c8 
lab3085: ld de,#30bc 
lab3088: call #36e2 
lab308b: jr nc,#3098 ; (+#0b) 
lab308d: ld de,#30f5			; start of power''s of ten 
lab3090: call #3577 
lab3093: pop de 
lab3094: dec e 
lab3095: push de 
lab3096: jr #3085 ; (-#13) 
lab3098: ld de,#30c1 
lab309b: call #36e2 
lab309e: jr c,#30ab ; (+#0b) 
lab30a0: ld de,#30f5			; start of power''s of ten 
lab30a3: call #3604 
lab30a6: pop de 
lab30a7: inc e 
lab30a8: push de 
lab30a9: jr #3098 ; (-#13) 
lab30ab: call #3001 
lab30ae: ld a,c 
lab30af: pop de 
lab30b0: ld b,d 
lab30b1: dec a 
lab30b2: add a,l 
lab30b3: ld l,a 
lab30b4: ret nc 
lab30b5: inc h 
lab30b6: ret 
lab30b7: ld e,a 
lab30b8: ld (hl),a 
lab30b9: ld c,#01 
lab30bb: ret 
lab30bc: 
defb #f0,#1f,#bc,#3e,#96
lab30c1: 
defb #fe,#27,#7b,#6e,#9e
;; REAL exp A
lab30c6: cpl 
lab30c7: inc a 
lab30c8: or a 
lab30c9: scf 
lab30ca: ret z 
lab30cb: ld c,a 
lab30cc: jp p,#30d1 
lab30cf: cpl 
lab30d0: inc a 
lab30d1: ld de,#3131 
lab30d4: sub #0d 
lab30d6: jr z,#30ed ; (+#15) 
lab30d8: jr c,#30e3 ; (+#09) 
lab30da: push bc 
lab30db: push af 
lab30dc: call #30ed 
lab30df: pop af 
lab30e0: pop bc 
lab30e1: jr #30d1 ; (-#12) 
lab30e3: ld b,a 
lab30e4: add a,a 
lab30e5: add a,a 
lab30e6: add a,b 
lab30e7: add a,e 
lab30e8: ld e,a 
lab30e9: ld a,#ff 
lab30eb: adc a,d 
lab30ec: ld d,a 
lab30ed: ld a,c 
lab30ee: or a 
lab30ef: jp p,#3604 
lab30f2: jp #3577 
;;===========================================================================================
;; power''s of 10 in internal floating point representation
;;
lab30f5: 
defb #00,#00,#00,#00,#84			;; 10 (10^1)
defb #00,#00,#00,#48,#87			;; 100 (10^2)
defb #00,#00,#00,#7A,#8A			;; 1000 (10^3)
defb #00,#00,#40,#1c,#8e			;; 10000 (10^4) (1E+4)
defb #00,#00,#50,#43,#91			;; 100000 (10^5) (1E+5)
defb #00,#00,#24,#74,#94			;; 1000000 (10^6) (1E+6)
defb #00,#80,#96,#18,#98			;; 10000000 (10^7) (1E+7)
defb #00,#20,#bc,#3e,#9b			;; 100000000 (10^8) (1E+8)
defb #00,#28,#6b,#6e,#9e			;; 1000000000 (10^9) (1E+9)
defb #00,#f9,#02,#15,#a2			;; 10000000000 (10^10) (1E+10)
defb #40,#b7,#43,#3a,#a5			;; 100000000000 (10^11) (1E+11)
defb #10,#a5,#d4,#68,#a8			;; 1000000000000 (10^12) (1E+12)
defb #2a,#e7,#84,#11,#ac			;; 10000000000000 (10^13) (1E+13)
;;===========================================================================================
lab3136: ld hl,#8965 
lab3139: ld (#b102),hl 
lab313c: ld hl,#6c07 
lab313f: ld (#b100),hl 
lab3142: ret 
;; RANDOMIZE seed
lab3143: ex de,hl 
lab3144: call #3136 
lab3147: ex de,hl 
lab3148: call #3727 
lab314b: ret z 
lab314c: ld de,#b100 
lab314f: ld b,#04 
lab3151: ld a,(de) 
lab3152: xor (hl) 
lab3153: ld (de),a 
lab3154: inc de 
lab3155: inc hl 
lab3156: djnz #3151 ; (-#07) 
lab3158: ret 
;; REAL rnd
lab3159: push hl 
lab315a: ld hl,(#b102) 
lab315d: ld bc,#6c07 
lab3160: call #319c 
lab3163: push hl 
lab3164: ld hl,(#b100) 
lab3167: ld bc,#8965 
lab316a: call #319c 
lab316d: push de 
lab316e: push hl 
lab316f: ld hl,(#b102) 
lab3172: call #319c 
lab3175: ex (sp),hl 
lab3176: add hl,bc 
lab3177: ld (#b100),hl 
lab317a: pop hl 
lab317b: ld bc,#6c07 
lab317e: adc hl,bc 
lab3180: pop bc 
lab3181: add hl,bc 
lab3182: pop bc 
lab3183: add hl,bc 
lab3184: ld (#b102),hl 
lab3187: pop hl 
;; REAL rnd0
lab3188: push hl 
lab3189: pop ix 
lab318b: ld hl,(#b100) 
lab318e: ld de,(#b102) 
lab3192: ld bc,#0000 
lab3195: ld (ix+#04),#80 
lab3199: jp #37ac 
lab319c: ex de,hl 
lab319d: ld hl,#0000 
lab31a0: ld a,#11 
lab31a2: dec a 
lab31a3: ret z 
lab31a4: add hl,hl 
lab31a5: rl e 
lab31a7: rl d 
lab31a9: jr nc,#31a2 ; (-#09) 
lab31ab: add hl,bc 
lab31ac: jr nc,#31a2 ; (-#0c) 
lab31ae: inc de 
lab31af: jr #31a2 ; (-#0f) 
;; REAL log10
lab31b1: ld de,#322a 
lab31b4: jr #31b9 ; (+#03) 
;; REAL log
lab31b6: ld de,#3225 
lab31b9: call #3727 
lab31bc: dec a 
lab31bd: cp #01 
lab31bf: ret nc 
lab31c0: push de 
lab31c1: call #36d3 
lab31c4: push af 
lab31c5: ld (ix+#04),#80 
lab31c9: ld de,#3220 
lab31cc: call #36df 
lab31cf: jr nc,#31d7 ; (+#06) 
lab31d1: inc (ix+#04) 
lab31d4: pop af 
lab31d5: dec a 
lab31d6: push af 
lab31d7: call #2f87 
lab31da: push de 
lab31db: ld de,#2f82 
lab31de: push de 
lab31df: call #34a2 
lab31e2: pop de 
lab31e3: ex (sp),hl 
lab31e4: call #349a 
lab31e7: pop de 
lab31e8: call #3604 
lab31eb: call #3440 
lab31ee: inc b 
lab31ef: ld c,h 
lab31f0: ld c,e 
lab31f1: ld d,a 
lab31f2: ld e,(hl) 
lab31f3: ld a,a 
lab31f4: dec c 
lab31f5: ex af,af'' 
lab31f6: sbc a,e 
lab31f7: inc de 
lab31f8: add a,b 
lab31f9: inc hl 
lab31fa: sub e 
lab31fb: jr c,#3273 ; (+#76) 
lab31fd: add a,b 
lab31fe: jr nz,#323b ; (+#3b) 
lab3200: xor d 
lab3201: jr c,#3185 ; (-#7e) 
lab3203: push de 
lab3204: call #3577 
lab3207: pop de 
lab3208: ex (sp),hl 
lab3209: ld a,h 
lab320a: or a 
lab320b: jp p,#3210 
lab320e: cpl 
lab320f: inc a 
lab3210: ld l,a 
lab3211: ld a,h 
lab3212: ld h,#00 
lab3214: call #2f9f 
lab3217: ex de,hl 
lab3218: pop hl 
lab3219: call #34a2 
lab321c: pop de 
lab321d: jp #3577 
lab3220: 
defb #34,#f3,#04,#35,#80			;; 0.707106781
defb #f8,#17,#72,#31,#80			;; 0.693147181
defb #85,#9a,#20,#1a,#7f			;; 0.301029996
;; REAL exp
lab322f: ld b,#e1 
lab3231: call #3492 
lab3234: jp nc,#2f7d 
lab3237: ld de,#32a2 
lab323a: call #36df 
lab323d: jp p,#37e8 
lab3240: ld de,#32a7 
lab3243: call #36df 
lab3246: jp m,#37e2 
lab3249: ld de,#329d 
lab324c: call #3469 
lab324f: ld a,e 
lab3250: jp p,#3255 
lab3253: neg 
lab3255: push af 
lab3256: call #3570 
lab3259: call #2f8d 
lab325c: push de 
lab325d: call #3443 
lab3260: inc bc 
lab3261: call p,#eb32 
lab3264: rrca 
lab3265: ld (hl),e 
lab3266: ex af,af'' 
lab3267: cp b 
lab3268: push de 
lab3269: ld d,d 
lab326a: ld a,e 
lab326b: nop 
lab326c: nop 
lab326d: nop 
lab326e: nop 
lab326f: add a,b 
lab3270: ex (sp),hl 
lab3271: call #3443 
lab3274: ld (bc),a 
lab3275: add hl,bc 
lab3276: ld h,b 
lab3277: sbc a,#01 
lab3279: ld a,b 
lab327a: ret m 
lab327b: rla 
lab327c: ld (hl),d 
lab327d: ld sp,#cd7e 
lab3280: ld (hl),a 
lab3281: dec (hl) 
lab3282: pop de 
lab3283: push hl 
lab3284: ex de,hl 
lab3285: call #349a 
lab3288: ex de,hl 
lab3289: pop hl 
lab328a: call #3604 
lab328d: ld de,#326b 
lab3290: call #34a2 
lab3293: pop af 
lab3294: scf 
lab3295: adc a,(ix+#04) 
lab3298: ld (ix+#04),a 
lab329b: scf 
lab329c: ret 
lab329d: add hl,hl 
lab329e: dec sp 
lab329f: xor d 
lab32a0: jr c,#3223 ; (-#7f) 
lab32a2: rst #00 
lab32a3: inc sp 
lab32a4: rrca 
lab32a5: jr nc,#322e ; (-#79) 
lab32a7: ret m 
lab32a8: rla 
lab32a9: ld (hl),d 
lab32aa: or c 
lab32ab: add a,a 
;; REAL sqr
lab32ac: ld de,#326b 
;; REAL power
lab32af: ex de,hl 
lab32b0: call #3727 
lab32b3: ex de,hl 
lab32b4: jp z,#2f7d 
lab32b7: push af 
lab32b8: call #3727 
lab32bb: jr z,#32e2 ; (+#25) 
lab32bd: ld b,a 
lab32be: call m,#3734 
lab32c1: push hl 
lab32c2: call #3324 
lab32c5: pop hl 
lab32c6: jr c,#32ed ; (+#25) 
lab32c8: ex (sp),hl 
lab32c9: pop hl 
lab32ca: jp m,#32ea 
lab32cd: push bc 
lab32ce: push de 
lab32cf: call #31b6 
lab32d2: pop de 
lab32d3: call c,#3577 
lab32d6: call c,#322f 
lab32d9: pop bc 
lab32da: ret nc 
lab32db: ld a,b 
lab32dc: or a 
lab32dd: call m,#3731 
lab32e0: scf 
lab32e1: ret 
lab32e2: pop af 
lab32e3: scf 
lab32e4: ret p 
lab32e5: call #37e8 
lab32e8: xor a 
lab32e9: ret 
lab32ea: xor a 
lab32eb: inc a 
lab32ec: ret 
lab32ed: ld c,a 
lab32ee: pop af 
lab32ef: push bc 
lab32f0: push af 
lab32f1: ld a,c 
lab32f2: scf 
lab32f3: adc a,a 
lab32f4: jr nc,#32f3 ; (-#03) 
lab32f6: ld b,a 
lab32f7: call #2f8d 
lab32fa: ex de,hl 
lab32fb: ld a,b 
lab32fc: add a,a 
lab32fd: jr z,#3314 ; (+#15) 
lab32ff: push af 
lab3300: call #3570 
lab3303: jr nc,#331b ; (+#16) 
lab3305: pop af 
lab3306: jr nc,#32fc ; (-#0c) 
lab3308: push af 
lab3309: ld de,#b104 
lab330c: call #3577 
lab330f: jr nc,#331b ; (+#0a) 
lab3311: pop af 
lab3312: jr #32fc ; (-#18) 
lab3314: pop af 
lab3315: scf 
lab3316: call m,#35fb 
lab3319: jr #32d9 ; (-#42) 
lab331b: pop af 
lab331c: pop af 
lab331d: pop bc 
lab331e: jp m,#37e2 
lab3321: jp #37ea 
lab3324: push bc 
lab3325: call #2f88 
lab3328: call #3014 
lab332b: ld a,c 
lab332c: pop bc 
lab332d: jr nc,#3331 ; (+#02) 
lab332f: jr z,#3334 ; (+#03) 
lab3331: ld a,b 
lab3332: or a 
lab3333: ret 
lab3334: ld c,a 
lab3335: ld a,(hl) 
lab3336: rra 
lab3337: sbc a,a 
lab3338: and b 
lab3339: ld b,a 
lab333a: ld a,c 
lab333b: cp #02 
lab333d: sbc a,a 
lab333e: ret nc 
lab333f: ld a,(hl) 
lab3340: cp #27 
lab3342: ret c 
lab3343: xor a 
lab3344: ret 
lab3345: ld (#b113),a 
lab3348: ret 
;; REAL cosine
lab3349: call #3727 
lab334c: call m,#3734 
lab334f: or #01 
lab3351: jr #3354 ; (+#01) 
;; REAL sin
lab3353: xor a 
lab3354: push af 
lab3355: ld de,#33b4 
lab3358: ld b,#f0 
lab335a: ld a,(#b113) 
lab335d: or a 
lab335e: jr z,#3365 ; (+#05) 
lab3360: ld de,#33b9 
lab3363: ld b,#f6 
lab3365: call #3492 
lab3368: jr nc,#33a4 ; (+#3a) 
lab336a: pop af 
lab336b: call #346a 
lab336e: ret nc 
lab336f: ld a,e 
lab3370: rra 
lab3371: call c,#3734 
lab3374: ld b,#e8 
lab3376: call #3492 
lab3379: jp nc,#37e2 
lab337c: inc (ix+#04) 
lab337f: call #3440 
lab3382: ld b,#1b 
lab3384: dec l 
lab3385: ld a,(de) 
lab3386: and #6e 
lab3388: ret m 
lab3389: ei 
lab338a: rlca 
lab338b: jr z,#3401 ; (+#74) 
lab338d: ld bc,#6889 
lab3390: sbc a,c 
lab3391: ld a,c 
lab3392: pop hl 
lab3393: rst #18 
lab3394: dec (hl) 
lab3395: inc hl 
lab3396: ld a,l 
lab3397: jr z,#3380 ; (-#19) 
lab3399: ld e,l 
lab339a: and l 
lab339b: add a,b 
lab339c: and d 
lab339d: jp c,#490f 
lab33a0: add a,c 
lab33a1: jp #3577 
lab33a4: pop af 
lab33a5: jp nz,#2f7d 
lab33a8: ld a,(#b113) 
lab33ab: cp #01 
lab33ad: ret c 
lab33ae: ld de,#33be 
lab33b1: jp #3577 
lab33b4: ld l,(hl) 
lab33b5: add a,e 
lab33b6: ld sp,hl 
lab33b7: ld (#b67f),hl 
lab33ba: ld h,b 
lab33bb: dec bc 
lab33bc: ld (hl),#79 
lab33be: inc de 
lab33bf: dec (hl) 
lab33c0: jp m,#7b0e 
lab33c3: out (#e0),a 
lab33c5: ld l,#65 
lab33c7: add a,(hl) 
;; REAL tan
lab33c8: call #2f8d 
lab33cb: push de 
lab33cc: call #3349 
lab33cf: ex (sp),hl 
lab33d0: call c,#3353 
lab33d3: pop de 
lab33d4: jp c,#3604 
lab33d7: ret 
;; REAL arctan
lab33d8: call #3727 
lab33db: push af 
lab33dc: call m,#3734 
lab33df: ld b,#f0 
lab33e1: call #3492 
lab33e4: jr nc,#3430 ; (+#4a) 
lab33e6: dec a 
lab33e7: push af 
lab33e8: call p,#35fb 
lab33eb: call #3440 
lab33ee: dec bc 
lab33ef: rst #38 
lab33f0: pop bc 
lab33f1: inc bc 
lab33f2: rrca 
lab33f3: ld (hl),a 
lab33f4: add a,e 
lab33f5: call m,#ebe8 
lab33f8: ld a,c 
lab33f9: ld l,a 
lab33fa: jp z,#3678 
lab33fd: ld a,e 
lab33fe: push de 
lab33ff: ld a,#b0 
lab3401: or l 
lab3402: ld a,h 
lab3403: or b 
lab3404: pop bc 
lab3405: adc a,e 
lab3406: add hl,bc 
lab3407: ld a,l 
lab3408: xor a 
lab3409: ret pe 
lab340a: ld (#7db4),a 
lab340d: ld (hl),h 
lab340e: ld l,h 
lab340f: ld h,l 
lab3410: ld h,d 
lab3411: ld a,l 
lab3412: pop de 
lab3413: push af 
lab3414: scf 
lab3415: sub d 
lab3416: ld a,(hl) 
lab3417: ld a,d 
lab3418: jp #4ccb 
lab341b: ld a,(hl) 
lab341c: add a,e 
lab341d: and a 
lab341e: xor d 
lab341f: xor d 
lab3420: ld a,a 
lab3421: cp #ff 
lab3423: rst #38 
lab3424: ld a,a 
lab3425: add a,b 
lab3426: call #3577 
lab3429: pop af 
lab342a: ld de,#339c 
lab342d: call p,#349e 
lab3430: ld a,(#b113) 
lab3433: or a 
lab3434: ld de,#33c3 
lab3437: call nz,#3577 
lab343a: pop af 
lab343b: call m,#3734 
lab343e: scf 
lab343f: ret 
lab3440: call #3570 
lab3443: call #2f87 
lab3446: pop hl 
lab3447: ld b,(hl) 
lab3448: inc hl 
lab3449: call #2f90 
lab344c: inc de 
lab344d: inc de 
lab344e: inc de 
lab344f: inc de 
lab3450: inc de 
lab3451: push de 
lab3452: ld de,#b109 
lab3455: dec b 
lab3456: ret z 
lab3457: push bc 
lab3458: ld de,#b10e 
lab345b: call #3577 
lab345e: pop bc 
lab345f: pop de 
lab3460: push de 
lab3461: push bc 
lab3462: call #34a2 
lab3465: pop bc 
lab3466: pop de 
lab3467: jr #344c ; (-#1d) 
lab3469: xor a 
lab346a: push af 
lab346b: call #3577 
lab346e: pop af 
lab346f: ld de,#326b 
lab3472: call nz,#34a2 
lab3475: push hl 
lab3476: call #2fd9 
lab3479: jr nc,#348e ; (+#13) 
lab347b: pop de 
lab347c: push hl 
lab347d: push af 
lab347e: push de 
lab347f: ld de,#b109 
lab3482: call #2f9f 
lab3485: ex de,hl 
lab3486: pop hl 
lab3487: call #349a 
lab348a: pop af 
lab348b: pop de 
lab348c: scf 
lab348d: ret 
lab348e: pop hl 
lab348f: xor a 
lab3490: inc a 
lab3491: ret 
lab3492: call #36d3 
lab3495: ret p 
lab3496: cp b 
lab3497: ret z 
lab3498: ccf 
lab3499: ret 
lab349a: ld a,#01 
lab349c: jr #34a3 ; (+#05) 
;; REAL reverse subtract
lab349e: ld a,#80 
lab34a0: jr #34a3 ; (+#01) 
;; REAL addition
lab34a2: xor a 
lab34a3: push hl 
lab34a4: pop ix 
lab34a6: push de 
lab34a7: pop iy 
lab34a9: ld b,(ix+#03) 
lab34ac: ld c,(iy+#03) 
lab34af: or a 
lab34b0: jr z,#34bc ; (+#0a) 
lab34b2: jp m,#34ba 
lab34b5: rrca 
lab34b6: xor c 
lab34b7: ld c,a 
lab34b8: jr #34bc ; (+#02) 
lab34ba: xor b 
lab34bb: ld b,a 
lab34bc: ld a,(ix+#04) 
lab34bf: cp (iy+#04) 
lab34c2: jr nc,#34d8 ; (+#14) 
lab34c4: ld d,b 
lab34c5: ld b,c 
lab34c6: ld c,d 
lab34c7: or a 
lab34c8: ld d,a 
lab34c9: ld a,(iy+#04) 
lab34cc: ld (ix+#04),a 
lab34cf: jr z,#3525 ; (+#54) 
lab34d1: sub d 
lab34d2: cp #21 
lab34d4: jr nc,#3525 ; (+#4f) 
lab34d6: jr #34e9 ; (+#11) 
lab34d8: xor a 
lab34d9: sub (iy+#04) 
lab34dc: jr z,#3537 ; (+#59) 
lab34de: add a,(ix+#04) 
lab34e1: cp #21 
lab34e3: jr nc,#3537 ; (+#52) 
lab34e5: push hl 
lab34e6: pop iy 
lab34e8: ex de,hl 
lab34e9: ld e,a 
lab34ea: ld a,b 
lab34eb: xor c 
lab34ec: push af 
lab34ed: push bc 
lab34ee: ld a,e 
lab34ef: call #3743 
lab34f2: ld a,c 
lab34f3: pop bc 
lab34f4: ld c,a 
lab34f5: pop af 
lab34f6: jp m,#353c 
lab34f9: ld a,(iy+#00) 
lab34fc: add a,l 
lab34fd: ld l,a 
lab34fe: ld a,(iy+#01) 
lab3501: adc a,h 
lab3502: ld h,a 
lab3503: ld a,(iy+#02) 
lab3506: adc a,e 
lab3507: ld e,a 
lab3508: ld a,(iy+#03) 
lab350b: set 7,a 
lab350d: adc a,d 
lab350e: ld d,a 
lab350f: jp nc,#37b7 
lab3512: rr d 
lab3514: rr e 
lab3516: rr h 
lab3518: rr l 
lab351a: rr c 
lab351c: inc (ix+#04) 
lab351f: jp nz,#37b7 
lab3522: jp #37ea 
lab3525: ld a,(iy+#02) 
lab3528: ld (ix+#02),a 
lab352b: ld a,(iy+#01) 
lab352e: ld (ix+#01),a 
lab3531: ld a,(iy+#00) 
lab3534: ld (ix+#00),a 
lab3537: ld (ix+#03),b 
lab353a: scf 
lab353b: ret 
lab353c: xor a 
lab353d: sub c 
lab353e: ld c,a 
lab353f: ld a,(iy+#00) 
lab3542: sbc a,l 
lab3543: ld l,a 
lab3544: ld a,(iy+#01) 
lab3547: sbc a,h 
lab3548: ld h,a 
lab3549: ld a,(iy+#02) 
lab354c: sbc a,e 
lab354d: ld e,a 
lab354e: ld a,(iy+#03) 
lab3551: set 7,a 
lab3553: sbc a,d 
lab3554: ld d,a 
lab3555: jr nc,#356d ; (+#16) 
lab3557: ld a,b 
lab3558: cpl 
lab3559: ld b,a 
lab355a: xor a 
lab355b: sub c 
lab355c: ld c,a 
lab355d: ld a,#00 
lab355f: sbc a,l 
lab3560: ld l,a 
lab3561: ld a,#00 
lab3563: sbc a,h 
lab3564: ld h,a 
lab3565: ld a,#00 
lab3567: sbc a,e 
lab3568: ld e,a 
lab3569: ld a,#00 
lab356b: sbc a,d 
lab356c: ld d,a 
lab356d: jp #37ac 
lab3570: ld de,#b109 
lab3573: call #2f90 
lab3576: ex de,hl 
;; REAL multiplication
lab3577: push de 
lab3578: pop iy 
lab357a: push hl 
lab357b: pop ix 
lab357d: ld a,(iy+#04) 
lab3580: or a 
lab3581: jr z,#35ad ; (+#2a) 
lab3583: dec a 
lab3584: call #36af 
lab3587: jr z,#35ad ; (+#24) 
lab3589: jr nc,#35aa ; (+#1f) 
lab358b: push af 
lab358c: push bc 
lab358d: call #35b0 
lab3590: ld a,c 
lab3591: pop bc 
lab3592: ld c,a 
lab3593: pop af 
lab3594: bit 7,d 
lab3596: jr nz,#35a3 ; (+#0b) 
lab3598: dec a 
lab3599: jr z,#35ad ; (+#12) 
lab359b: sla c 
lab359d: adc hl,hl 
lab359f: rl e 
lab35a1: rl d 
lab35a3: ld (ix+#04),a 
lab35a6: or a 
lab35a7: jp nz,#37b7 
lab35aa: jp #37ea 
lab35ad: jp #37e2 
lab35b0: ld hl,#0000 
lab35b3: ld e,l 
lab35b4: ld d,h 
lab35b5: ld a,(iy+#00) 
lab35b8: call #35f3 
lab35bb: ld a,(iy+#01) 
lab35be: call #35f3 
lab35c1: ld a,(iy+#02) 
lab35c4: call #35f3 
lab35c7: ld a,(iy+#03) 
lab35ca: or #80 
lab35cc: ld b,#08 
lab35ce: rra 
lab35cf: ld c,a 
lab35d0: jr nc,#35e6 ; (+#14) 
lab35d2: ld a,l 
lab35d3: add a,(ix+#00) 
lab35d6: ld l,a 
lab35d7: ld a,h 
lab35d8: adc a,(ix+#01) 
lab35db: ld h,a 
lab35dc: ld a,e 
lab35dd: adc a,(ix+#02) 
lab35e0: ld e,a 
lab35e1: ld a,d 
lab35e2: adc a,(ix+#03) 
lab35e5: ld d,a 
lab35e6: rr d 
lab35e8: rr e 
lab35ea: rr h 
lab35ec: rr l 
lab35ee: rr c 
lab35f0: djnz #35d0 ; (-#22) 
lab35f2: ret 
lab35f3: or a 
lab35f4: jr nz,#35cc ; (-#2a) 
lab35f6: ld l,h 
lab35f7: ld h,e 
lab35f8: ld e,d 
lab35f9: ld d,a 
lab35fa: ret 
lab35fb: call #2f87 
lab35fe: ex de,hl 
lab35ff: push de 
lab3600: call #2f7d 
lab3603: pop de 
lab3604: push de 
lab3605: pop iy 
lab3607: push hl 
lab3608: pop ix 
lab360a: xor a 
lab360b: sub (iy+#04) 
lab360e: jr z,#366a ; (+#5a) 
lab3610: call #36af 
lab3613: jp z,#37e2 
lab3616: jr nc,#3667 ; (+#4f) 
lab3618: push bc 
lab3619: ld c,a 
lab361a: ld e,(hl) 
lab361b: inc hl 
lab361c: ld d,(hl) 
lab361d: inc hl 
lab361e: ld a,(hl) 
lab361f: inc hl 
lab3620: ld h,(hl) 
lab3621: ld l,a 
lab3622: ex de,hl 
lab3623: ld b,(iy+#03) 
lab3626: set 7,b 
lab3628: call #369d 
lab362b: jr c,#3633 ; (+#06) 
lab362d: ld a,c 
lab362e: or a 
lab362f: jr nz,#3639 ; (+#08) 
lab3631: jr #3666 ; (+#33) 
lab3633: dec c 
lab3634: add hl,hl 
lab3635: rl e 
lab3637: rl d 
lab3639: ld (ix+#04),c 
lab363c: call #3672 
lab363f: ld (ix+#03),c 
lab3642: call #3672 
lab3645: ld (ix+#02),c 
lab3648: call #3672 
lab364b: ld (ix+#01),c 
lab364e: call #3672 
lab3651: ccf 
lab3652: call c,#369d 
lab3655: ccf 
lab3656: sbc a,a 
lab3657: ld l,c 
lab3658: ld h,(ix+#01) 
lab365b: ld e,(ix+#02) 
lab365e: ld d,(ix+#03) 
lab3661: pop bc 
lab3662: ld c,a 
lab3663: jp #37b7 
lab3666: pop bc 
lab3667: jp #37ea 
lab366a: ld b,(ix+#03) 
lab366d: call #37ea 
lab3670: xor a 
lab3671: ret 
lab3672: ld c,#01 
lab3674: jr c,#367e ; (+#08) 
lab3676: ld a,d 
lab3677: cp b 
lab3678: call z,#36a0 
lab367b: ccf 
lab367c: jr nc,#3691 ; (+#13) 
lab367e: ld a,l 
lab367f: sub (iy+#00) 
lab3682: ld l,a 
lab3683: ld a,h 
lab3684: sbc a,(iy+#01) 
lab3687: ld h,a 
lab3688: ld a,e 
lab3689: sbc a,(iy+#02) 
lab368c: ld e,a 
lab368d: ld a,d 
lab368e: sbc a,b 
lab368f: ld d,a 
lab3690: scf 
lab3691: rl c 
lab3693: sbc a,a 
lab3694: add hl,hl 
lab3695: rl e 
lab3697: rl d 
lab3699: inc a 
lab369a: jr nz,#3674 ; (-#28) 
lab369c: ret 
lab369d: ld a,d 
lab369e: cp b 
lab369f: ret nz 
lab36a0: ld a,e 
lab36a1: cp (iy+#02) 
lab36a4: ret nz 
lab36a5: ld a,h 
lab36a6: cp (iy+#01) 
lab36a9: ret nz 
lab36aa: ld a,l 
lab36ab: cp (iy+#00) 
lab36ae: ret 
lab36af: ld c,a 
lab36b0: ld a,(ix+#03) 
lab36b3: xor (iy+#03) 
lab36b6: ld b,a 
lab36b7: ld a,(ix+#04) 
lab36ba: or a 
lab36bb: ret z 
lab36bc: add a,c 
lab36bd: ld c,a 
lab36be: rra 
lab36bf: xor c 
lab36c0: ld a,c 
lab36c1: jp p,#36cf 
lab36c4: set 7,(ix+#03) 
lab36c8: sub #7f 
lab36ca: scf 
lab36cb: ret nz 
lab36cc: cp #01 
lab36ce: ret 
lab36cf: or a 
lab36d0: ret m 
lab36d1: xor a 
lab36d2: ret 
lab36d3: push hl 
lab36d4: pop ix 
lab36d6: ld a,(ix+#04) 
lab36d9: or a 
lab36da: ret z 
lab36db: sub #80 
lab36dd: scf 
lab36de: ret 
lab36df: push hl 
lab36e0: pop ix 
lab36e2: push de 
lab36e3: pop iy 
lab36e5: ld a,(ix+#04) 
lab36e8: cp (iy+#04) 
lab36eb: jr c,#3719 ; (+#2c) 
lab36ed: jr nz,#3722 ; (+#33) 
lab36ef: or a 
lab36f0: ret z 
lab36f1: ld a,(ix+#03) 
lab36f4: xor (iy+#03) 
lab36f7: jp m,#3722 
lab36fa: ld a,(ix+#03) 
lab36fd: sub (iy+#03) 
lab3700: jr nz,#3719 ; (+#17) 
lab3702: ld a,(ix+#02) 
lab3705: sub (iy+#02) 
lab3708: jr nz,#3719 ; (+#0f) 
lab370a: ld a,(ix+#01) 
lab370d: sub (iy+#01) 
lab3710: jr nz,#3719 ; (+#07) 
lab3712: ld a,(ix+#00) 
lab3715: sub (iy+#00) 
lab3718: ret z 
lab3719: sbc a,a 
lab371a: xor (iy+#03) 
lab371d: add a,a 
lab371e: sbc a,a 
lab371f: ret c 
lab3720: inc a 
lab3721: ret 
lab3722: ld a,(ix+#03) 
lab3725: jr #371d ; (-#0a) 
lab3727: push hl 
lab3728: pop ix 
lab372a: ld a,(ix+#04) 
lab372d: or a 
lab372e: ret z 
lab372f: jr #3722 ; (-#0f) 
lab3731: push hl 
lab3732: pop ix 
lab3734: ld a,(ix+#03) 
lab3737: xor #80 
lab3739: ld (ix+#03),a 
lab373c: ret 
lab373d: cp #21 
lab373f: jr c,#3743 ; (+#02) 
lab3741: ld a,#21 
lab3743: ld e,(hl) 
lab3744: inc hl 
lab3745: ld d,(hl) 
lab3746: inc hl 
lab3747: ld c,(hl) 
lab3748: inc hl 
lab3749: ld h,(hl) 
lab374a: ld l,c 
lab374b: ex de,hl 
lab374c: set 7,d 
lab374e: ld bc,#0000 
lab3751: jr #375e ; (+#0b) 
lab3753: ld c,a 
lab3754: ld a,b 
lab3755: or l 
lab3756: ld b,a 
lab3757: ld a,c 
lab3758: ld c,l 
lab3759: ld l,h 
lab375a: ld h,e 
lab375b: ld e,d 
lab375c: ld d,#00 
lab375e: sub #08 
lab3760: jr nc,#3753 ; (-#0f) 
lab3762: add a,#08 
lab3764: ret z 
lab3765: srl d 
lab3767: rr e 
lab3769: rr h 
lab376b: rr l 
lab376d: rr c 
lab376f: dec a 
lab3770: jr nz,#3765 ; (-#0d) 
lab3772: ret 
lab3773: jr nz,#378c ; (+#17) 
lab3775: ld d,a 
lab3776: ld a,e 
lab3777: or h 
lab3778: or l 
lab3779: or c 
lab377a: ret z 
lab377b: ld a,d 
lab377c: sub #08 
lab377e: jr c,#379a ; (+#1a) 
lab3780: ret z 
lab3781: ld d,e 
lab3782: ld e,h 
lab3783: ld h,l 
lab3784: ld l,c 
lab3785: ld c,#00 
lab3787: inc d 
lab3788: dec d 
lab3789: jr z,#377c ; (-#0f) 
lab378b: ret m 
lab378c: dec a 
lab378d: ret z 
lab378e: sla c 
lab3790: adc hl,hl 
lab3792: rl e 
lab3794: rl d 
lab3796: jp p,#378c 
lab3799: ret 
lab379a: xor a 
lab379b: ret 
lab379c: push hl 
lab379d: pop ix 
lab379f: ld (ix+#04),b 
lab37a2: ld b,a 
lab37a3: ld e,(hl) 
lab37a4: inc hl 
lab37a5: ld d,(hl) 
lab37a6: inc hl 
lab37a7: ld a,(hl) 
lab37a8: inc hl 
lab37a9: ld h,(hl) 
lab37aa: ld l,a 
lab37ab: ex de,hl 
lab37ac: ld a,(ix+#04) 
lab37af: dec d 
lab37b0: inc d 
lab37b1: call p,#3773 
lab37b4: ld (ix+#04),a 
lab37b7: sla c 
lab37b9: jr nc,#37cd ; (+#12) 
lab37bb: inc l 
lab37bc: jr nz,#37cd ; (+#0f) 
lab37be: inc h 
lab37bf: jr nz,#37cd ; (+#0c) 
lab37c1: inc de 
lab37c2: ld a,d 
lab37c3: or e 
lab37c4: jr nz,#37cd ; (+#07) 
lab37c6: inc (ix+#04) 
lab37c9: jr z,#37ea ; (+#1f) 
lab37cb: ld d,#80 
lab37cd: ld a,b 
lab37ce: or #7f 
lab37d0: and d 
lab37d1: ld (ix+#03),a 
lab37d4: ld (ix+#02),e 
lab37d7: ld (ix+#01),h 
lab37da: ld (ix+#00),l 
lab37dd: push ix 
lab37df: pop hl 
lab37e0: scf 
lab37e1: ret 
lab37e2: xor a 
lab37e3: ld (ix+#04),a 
lab37e6: jr #37dd ; (-#0b) 
lab37e8: ld b,#00 
lab37ea: push ix 
lab37ec: pop hl 
lab37ed: ld a,b 
lab37ee: or #7f 
lab37f0: ld (ix+#03),a 
lab37f3: or #ff 
lab37f5: ld (ix+#04),a 
lab37f8: ld (hl),a 
lab37f9: ld (ix+#01),a 
lab37fc: ld (ix+#02),a 
lab37ff: ret 
;; font graphics
lab3800: 
;--------------------------
;; character 0
;;
defb %11111111
defb %11000011
defb %11000011
defb %11000011
defb %11000011
defb %11000011
defb %11000011
defb %11111111
;--------------------------
;; character 1
;;
defb %11111111
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
;--------------------------
;; character 2
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %11111111
;--------------------------
;; character 3
;;
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %11111111
;--------------------------
;; character 4
;;
defb %00001100
defb %00011000
defb %00110000
defb %01111110
defb %00001100
defb %00011000
defb %00110000
defb %00000000
;--------------------------
;; character 5
;;
defb %11111111
defb %11000011
defb %11100111
defb %11011011
defb %11011011
defb %11100111
defb %11000011
defb %11111111
;--------------------------
;; character 6
;;
defb %00000000
defb %00000001
defb %00000011
defb %00000110
defb %11001100
defb %01111000
defb %00110000
defb %00000000
;--------------------------
;; character 7
;;
defb %00111100
defb %01100110
defb %11000011
defb %11000011
defb %11111111
defb %00100100
defb %11100111
defb %00000000
;--------------------------
;; character 8
;;
defb %00000000
defb %00000000
defb %00110000
defb %01100000
defb %11111111
defb %01100000
defb %00110000
defb %00000000
;--------------------------
;; character 9
;;
defb %00000000
defb %00000000
defb %00001100
defb %00000110
defb %11111111
defb %00000110
defb %00001100
defb %00000000
;--------------------------
;; character 10
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %11011011
defb %01111110
defb %00111100
defb %00011000
;--------------------------
;; character 11
;;
defb %00011000
defb %00111100
defb %01111110
defb %11011011
defb %00011000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 12
;;
defb %00011000
defb %01011010
defb %00111100
defb %10011001
defb %11011011
defb %01111110
defb %00111100
defb %00011000
;--------------------------
;; character 13
;;
defb %00000000
defb %00000011
defb %00110011
defb %01100011
defb %11111110
defb %01100000
defb %00110000
defb %00000000
;--------------------------
;; character 14
;;
defb %00111100
defb %01100110
defb %11111111
defb %11011011
defb %11011011
defb %11111111
defb %01100110
defb %00111100
;--------------------------
;; character 15
;;
defb %00111100
defb %01100110
defb %11000011
defb %11011011
defb %11011011
defb %11000011
defb %01100110
defb %00111100
;--------------------------
;; character 16
;;
defb %11111111
defb %11000011
defb %11000011
defb %11111111
defb %11000011
defb %11000011
defb %11000011
defb %11111111
;--------------------------
;; character 17
;;
defb %00111100
defb %01111110
defb %11011011
defb %11011011
defb %11011111
defb %11000011
defb %01100110
defb %00111100
;--------------------------
;; character 18
;;
defb %00111100
defb %01100110
defb %11000011
defb %11011111
defb %11011011
defb %11011011
defb %01111110
defb %00111100
;--------------------------
;; character 19
;;
defb %00111100
defb %01100110
defb %11000011
defb %11111011
defb %11011011
defb %11011011
defb %01111110
defb %00111100
;--------------------------
;; character 20
;;
defb %00111100
defb %01111110
defb %11011011
defb %11011011
defb %11111011
defb %11000011
defb %01100110
defb %00111100
;--------------------------
;; character 21
;;
defb %00000000
defb %00000001
defb %00110011
defb %00011110
defb %11001110
defb %01111011
defb %00110001
defb %00000000
;--------------------------
;; character 22
;;
defb %01111110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %11100111
;--------------------------
;; character 23
;;
defb %00000011
defb %00000011
defb %00000011
defb %11111111
defb %00000011
defb %00000011
defb %00000011
defb %00000000
;--------------------------
;; character 24
;;
defb %11111111
defb %01100110
defb %00111100
defb %00011000
defb %00011000
defb %00111100
defb %01100110
defb %11111111
;--------------------------
;; character 25
;;
defb %00011000
defb %00011000
defb %00111100
defb %00111100
defb %00111100
defb %00111100
defb %00011000
defb %00011000
;--------------------------
;; character 26
;;
defb %00111100
defb %01100110
defb %01100110
defb %00110000
defb %00011000
defb %00000000
defb %00011000
defb %00000000
;--------------------------
;; character 27
;;
defb %00111100
defb %01100110
defb %11000011
defb %11111111
defb %11000011
defb %11000011
defb %01100110
defb %00111100
;--------------------------
;; character 28
;;
defb %11111111
defb %11011011
defb %11011011
defb %11011011
defb %11111011
defb %11000011
defb %11000011
defb %11111111
;--------------------------
;; character 29
;;
defb %11111111
defb %11000011
defb %11000011
defb %11111011
defb %11011011
defb %11011011
defb %11011011
defb %11111111
;--------------------------
;; character 30
;;
defb %11111111
defb %11000011
defb %11000011
defb %11011111
defb %11011011
defb %11011011
defb %11011011
defb %11111111
;--------------------------
;; character 31
;;
defb %11111111
defb %11011011
defb %11011011
defb %11011011
defb %11011111
defb %11000011
defb %11000011
defb %11111111
;--------------------------
;; character 32
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 33
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00000000
defb %00011000
defb %00000000
;--------------------------
;; character 34
;;
defb %01101100
defb %01101100
defb %01101100
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 35
;;
defb %01101100
defb %01101100
defb %11111110
defb %01101100
defb %11111110
defb %01101100
defb %01101100
defb %00000000
;--------------------------
;; character 36
;;
defb %00011000
defb %00111110
defb %01011000
defb %00111100
defb %00011010
defb %01111100
defb %00011000
defb %00000000
;--------------------------
;; character 37
;;
defb %00000000
defb %11000110
defb %11001100
defb %00011000
defb %00110000
defb %01100110
defb %11000110
defb %00000000
;--------------------------
;; character 38
;;
defb %00111000
defb %01101100
defb %00111000
defb %01110110
defb %11011100
defb %11001100
defb %01110110
defb %00000000
;--------------------------
;; character 39
;;
defb %00011000
defb %00011000
defb %00110000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 40
;;
defb %00001100
defb %00011000
defb %00110000
defb %00110000
defb %00110000
defb %00011000
defb %00001100
defb %00000000
;--------------------------
;; character 41
;;
defb %00110000
defb %00011000
defb %00001100
defb %00001100
defb %00001100
defb %00011000
defb %00110000
defb %00000000
;--------------------------
;; character 42
;;
defb %00000000
defb %01100110
defb %00111100
defb %11111111
defb %00111100
defb %01100110
defb %00000000
defb %00000000
;--------------------------
;; character 43
;;
defb %00000000
defb %00011000
defb %00011000
defb %01111110
defb %00011000
defb %00011000
defb %00000000
defb %00000000
;--------------------------
;; character 44
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00110000
;--------------------------
;; character 45
;;
defb %00000000
defb %00000000
defb %00000000
defb %01111110
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 46
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 47
;;
defb %00000110
defb %00001100
defb %00011000
defb %00110000
defb %01100000
defb %11000000
defb %10000000
defb %00000000
;--------------------------
;; character 48
;;
defb %01111100
defb %11000110
defb %11001110
defb %11010110
defb %11100110
defb %11000110
defb %01111100
defb %00000000
;--------------------------
;; character 49
;;
defb %00011000
defb %00111000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %01111110
defb %00000000
;--------------------------
;; character 50
;;
defb %00111100
defb %01100110
defb %00000110
defb %00111100
defb %01100000
defb %01100110
defb %01111110
defb %00000000
;--------------------------
;; character 51
;;
defb %00111100
defb %01100110
defb %00000110
defb %00011100
defb %00000110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 52
;;
defb %00011100
defb %00111100
defb %01101100
defb %11001100
defb %11111110
defb %00001100
defb %00011110
defb %00000000
;--------------------------
;; character 53
;;
defb %01111110
defb %01100010
defb %01100000
defb %01111100
defb %00000110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 54
;;
defb %00111100
defb %01100110
defb %01100000
defb %01111100
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 55
;;
defb %01111110
defb %01100110
defb %00000110
defb %00001100
defb %00011000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 56
;;
defb %00111100
defb %01100110
defb %01100110
defb %00111100
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 57
;;
defb %00111100
defb %01100110
defb %01100110
defb %00111110
defb %00000110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 58
;;
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00000000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 59
;;
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00000000
defb %00011000
defb %00011000
defb %00110000
;--------------------------
;; character 60
;;
defb %00001100
defb %00011000
defb %00110000
defb %01100000
defb %00110000
defb %00011000
defb %00001100
defb %00000000
;--------------------------
;; character 61
;;
defb %00000000
defb %00000000
defb %01111110
defb %00000000
defb %00000000
defb %01111110
defb %00000000
defb %00000000
;--------------------------
;; character 62
;;
defb %01100000
defb %00110000
defb %00011000
defb %00001100
defb %00011000
defb %00110000
defb %01100000
defb %00000000
;--------------------------
;; character 63
;;
defb %00111100
defb %01100110
defb %01100110
defb %00001100
defb %00011000
defb %00000000
defb %00011000
defb %00000000
;--------------------------
;; character 64
;;
defb %01111100
defb %11000110
defb %11011110
defb %11011110
defb %11011110
defb %11000000
defb %01111100
defb %00000000
;--------------------------
;; character 65
;;
defb %00011000
defb %00111100
defb %01100110
defb %01100110
defb %01111110
defb %01100110
defb %01100110
defb %00000000
;--------------------------
;; character 66
;;
defb %11111100
defb %01100110
defb %01100110
defb %01111100
defb %01100110
defb %01100110
defb %11111100
defb %00000000
;--------------------------
;; character 67
;;
defb %00111100
defb %01100110
defb %11000000
defb %11000000
defb %11000000
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 68
;;
defb %11111000
defb %01101100
defb %01100110
defb %01100110
defb %01100110
defb %01101100
defb %11111000
defb %00000000
;--------------------------
;; character 69
;;
defb %11111110
defb %01100010
defb %01101000
defb %01111000
defb %01101000
defb %01100010
defb %11111110
defb %00000000
;--------------------------
;; character 70
;;
defb %11111110
defb %01100010
defb %01101000
defb %01111000
defb %01101000
defb %01100000
defb %11110000
defb %00000000
;--------------------------
;; character 71
;;
defb %00111100
defb %01100110
defb %11000000
defb %11000000
defb %11001110
defb %01100110
defb %00111110
defb %00000000
;--------------------------
;; character 72
;;
defb %01100110
defb %01100110
defb %01100110
defb %01111110
defb %01100110
defb %01100110
defb %01100110
defb %00000000
;--------------------------
;; character 73
;;
defb %01111110
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %01111110
defb %00000000
;--------------------------
;; character 74
;;
defb %00011110
defb %00001100
defb %00001100
defb %00001100
defb %11001100
defb %11001100
defb %01111000
defb %00000000
;--------------------------
;; character 75
;;
defb %11100110
defb %01100110
defb %01101100
defb %01111000
defb %01101100
defb %01100110
defb %11100110
defb %00000000
;--------------------------
;; character 76
;;
defb %11110000
defb %01100000
defb %01100000
defb %01100000
defb %01100010
defb %01100110
defb %11111110
defb %00000000
;--------------------------
;; character 77
;;
defb %11000110
defb %11101110
defb %11111110
defb %11111110
defb %11010110
defb %11000110
defb %11000110
defb %00000000
;--------------------------
;; character 78
;;
defb %11000110
defb %11100110
defb %11110110
defb %11011110
defb %11001110
defb %11000110
defb %11000110
defb %00000000
;--------------------------
;; character 79
;;
defb %00111000
defb %01101100
defb %11000110
defb %11000110
defb %11000110
defb %01101100
defb %00111000
defb %00000000
;--------------------------
;; character 80
;;
defb %11111100
defb %01100110
defb %01100110
defb %01111100
defb %01100000
defb %01100000
defb %11110000
defb %00000000
;--------------------------
;; character 81
;;
defb %00111000
defb %01101100
defb %11000110
defb %11000110
defb %11011010
defb %11001100
defb %01110110
defb %00000000
;--------------------------
;; character 82
;;
defb %11111100
defb %01100110
defb %01100110
defb %01111100
defb %01101100
defb %01100110
defb %11100110
defb %00000000
;--------------------------
;; character 83
;;
defb %00111100
defb %01100110
defb %01100000
defb %00111100
defb %00000110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 84
;;
defb %01111110
defb %01011010
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00111100
defb %00000000
;--------------------------
;; character 85
;;
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 86
;;
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00011000
defb %00000000
;--------------------------
;; character 87
;;
defb %11000110
defb %11000110
defb %11000110
defb %11010110
defb %11111110
defb %11101110
defb %11000110
defb %00000000
;--------------------------
;; character 88
;;
defb %11000110
defb %01101100
defb %00111000
defb %00111000
defb %01101100
defb %11000110
defb %11000110
defb %00000000
;--------------------------
;; character 89
;;
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00011000
defb %00011000
defb %00111100
defb %00000000
;--------------------------
;; character 90
;;
defb %11111110
defb %11000110
defb %10001100
defb %00011000
defb %00110010
defb %01100110
defb %11111110
defb %00000000
;--------------------------
;; character 91
;;
defb %00111100
defb %00110000
defb %00110000
defb %00110000
defb %00110000
defb %00110000
defb %00111100
defb %00000000
;--------------------------
;; character 92
;;
defb %11000000
defb %01100000
defb %00110000
defb %00011000
defb %00001100
defb %00000110
defb %00000010
defb %00000000
;--------------------------
;; character 93
;;
defb %00111100
defb %00001100
defb %00001100
defb %00001100
defb %00001100
defb %00001100
defb %00111100
defb %00000000
;--------------------------
;; character 94
;;
defb %00011000
defb %00111100
defb %01111110
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 95
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %11111111
;--------------------------
;; character 96
;;
defb %00110000
defb %00011000
defb %00001100
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 97
;;
defb %00000000
defb %00000000
defb %01111000
defb %00001100
defb %01111100
defb %11001100
defb %01110110
defb %00000000
;--------------------------
;; character 98
;;
defb %11100000
defb %01100000
defb %01111100
defb %01100110
defb %01100110
defb %01100110
defb %11011100
defb %00000000
;--------------------------
;; character 99
;;
defb %00000000
defb %00000000
defb %00111100
defb %01100110
defb %01100000
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 100
;;
defb %00011100
defb %00001100
defb %01111100
defb %11001100
defb %11001100
defb %11001100
defb %01110110
defb %00000000
;--------------------------
;; character 101
;;
defb %00000000
defb %00000000
defb %00111100
defb %01100110
defb %01111110
defb %01100000
defb %00111100
defb %00000000
;--------------------------
;; character 102
;;
defb %00011100
defb %00110110
defb %00110000
defb %01111000
defb %00110000
defb %00110000
defb %01111000
defb %00000000
;--------------------------
;; character 103
;;
defb %00000000
defb %00000000
defb %00111110
defb %01100110
defb %01100110
defb %00111110
defb %00000110
defb %01111100
;--------------------------
;; character 104
;;
defb %11100000
defb %01100000
defb %01101100
defb %01110110
defb %01100110
defb %01100110
defb %11100110
defb %00000000
;--------------------------
;; character 105
;;
defb %00011000
defb %00000000
defb %00111000
defb %00011000
defb %00011000
defb %00011000
defb %00111100
defb %00000000
;--------------------------
;; character 106
;;
defb %00000110
defb %00000000
defb %00001110
defb %00000110
defb %00000110
defb %01100110
defb %01100110
defb %00111100
;--------------------------
;; character 107
;;
defb %11100000
defb %01100000
defb %01100110
defb %01101100
defb %01111000
defb %01101100
defb %11100110
defb %00000000
;--------------------------
;; character 108
;;
defb %00111000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00111100
defb %00000000
;--------------------------
;; character 109
;;
defb %00000000
defb %00000000
defb %01101100
defb %11111110
defb %11010110
defb %11010110
defb %11000110
defb %00000000
;--------------------------
;; character 110
;;
defb %00000000
defb %00000000
defb %11011100
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %00000000
;--------------------------
;; character 111
;;
defb %00000000
defb %00000000
defb %00111100
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 112
;;
defb %00000000
defb %00000000
defb %11011100
defb %01100110
defb %01100110
defb %01111100
defb %01100000
defb %11110000
;--------------------------
;; character 113
;;
defb %00000000
defb %00000000
defb %01110110
defb %11001100
defb %11001100
defb %01111100
defb %00001100
defb %00011110
;--------------------------
;; character 114
;;
defb %00000000
defb %00000000
defb %11011100
defb %01110110
defb %01100000
defb %01100000
defb %11110000
defb %00000000
;--------------------------
;; character 115
;;
defb %00000000
defb %00000000
defb %00111100
defb %01100000
defb %00111100
defb %00000110
defb %01111100
defb %00000000
;--------------------------
;; character 116
;;
defb %00110000
defb %00110000
defb %01111100
defb %00110000
defb %00110000
defb %00110110
defb %00011100
defb %00000000
;--------------------------
;; character 117
;;
defb %00000000
defb %00000000
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %00111110
defb %00000000
;--------------------------
;; character 118
;;
defb %00000000
defb %00000000
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00011000
defb %00000000
;--------------------------
;; character 119
;;
defb %00000000
defb %00000000
defb %11000110
defb %11010110
defb %11010110
defb %11111110
defb %01101100
defb %00000000
;--------------------------
;; character 120
;;
defb %00000000
defb %00000000
defb %11000110
defb %01101100
defb %00111000
defb %01101100
defb %11000110
defb %00000000
;--------------------------
;; character 121
;;
defb %00000000
defb %00000000
defb %01100110
defb %01100110
defb %01100110
defb %00111110
defb %00000110
defb %01111100
;--------------------------
;; character 122
;;
defb %00000000
defb %00000000
defb %01111110
defb %01001100
defb %00011000
defb %00110010
defb %01111110
defb %00000000
;--------------------------
;; character 123
;;
defb %00001110
defb %00011000
defb %00011000
defb %01110000
defb %00011000
defb %00011000
defb %00001110
defb %00000000
;--------------------------
;; character 124
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 125
;;
defb %01110000
defb %00011000
defb %00011000
defb %00001110
defb %00011000
defb %00011000
defb %01110000
defb %00000000
;--------------------------
;; character 126
;;
defb %01110110
defb %11011100
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 127
;;
defb %11001100
defb %00110011
defb %11001100
defb %00110011
defb %11001100
defb %00110011
defb %11001100
defb %00110011
;--------------------------
;; character 128
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 129
;;
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 130
;;
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 131
;;
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 132
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %11110000
defb %11110000
defb %11110000
defb %11110000
;--------------------------
;; character 133
;;
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %11110000
;--------------------------
;; character 134
;;
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %11110000
defb %11110000
defb %11110000
defb %11110000
;--------------------------
;; character 135
;;
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %11110000
defb %11110000
defb %11110000
defb %11110000
;--------------------------
;; character 136
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00001111
defb %00001111
defb %00001111
defb %00001111
;--------------------------
;; character 137
;;
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %00001111
defb %00001111
defb %00001111
defb %00001111
;--------------------------
;; character 138
;;
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %00001111
;--------------------------
;; character 139
;;
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %00001111
defb %00001111
defb %00001111
defb %00001111
;--------------------------
;; character 140
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %11111111
defb %11111111
defb %11111111
defb %11111111
;--------------------------
;; character 141
;;
defb %11110000
defb %11110000
defb %11110000
defb %11110000
defb %11111111
defb %11111111
defb %11111111
defb %11111111
;--------------------------
;; character 142
;;
defb %00001111
defb %00001111
defb %00001111
defb %00001111
defb %11111111
defb %11111111
defb %11111111
defb %11111111
;--------------------------
;; character 143
;;
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %11111111
defb %11111111
;--------------------------
;; character 144
;;
defb %00000000
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 145
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 146
;;
defb %00000000
defb %00000000
defb %00000000
defb %00011111
defb %00011111
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 147
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011111
defb %00001111
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 148
;;
defb %00000000
defb %00000000
defb %00000000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 149
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 150
;;
defb %00000000
defb %00000000
defb %00000000
defb %00001111
defb %00011111
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 151
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011111
defb %00011111
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 152
;;
defb %00000000
defb %00000000
defb %00000000
defb %11111000
defb %11111000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 153
;;
defb %00011000
defb %00011000
defb %00011000
defb %11111000
defb %11110000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 154
;;
defb %00000000
defb %00000000
defb %00000000
defb %11111111
defb %11111111
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 155
;;
defb %00011000
defb %00011000
defb %00011000
defb %11111111
defb %11111111
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 156
;;
defb %00000000
defb %00000000
defb %00000000
defb %11110000
defb %11111000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 157
;;
defb %00011000
defb %00011000
defb %00011000
defb %11111000
defb %11111000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 158
;;
defb %00000000
defb %00000000
defb %00000000
defb %11111111
defb %11111111
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 159
;;
defb %00011000
defb %00011000
defb %00011000
defb %11111111
defb %11111111
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 160
;;
defb %00010000
defb %00111000
defb %01101100
defb %11000110
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 161
;;
defb %00001100
defb %00011000
defb %00110000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 162
;;
defb %01100110
defb %01100110
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 163
;;
defb %00111100
defb %01100110
defb %01100000
defb %11111000
defb %01100000
defb %01100110
defb %11111110
defb %00000000
;--------------------------
;; character 164
;;
defb %00111000
defb %01000100
defb %10111010
defb %10100010
defb %10111010
defb %01000100
defb %00111000
defb %00000000
;--------------------------
;; character 165
;;
defb %01111110
defb %11110100
defb %11110100
defb %01110100
defb %00110100
defb %00110100
defb %00110100
defb %00000000
;--------------------------
;; character 166
;;
defb %00011110
defb %00110000
defb %00111000
defb %01101100
defb %00111000
defb %00011000
defb %11110000
defb %00000000
;--------------------------
;; character 167
;;
defb %00011000
defb %00011000
defb %00001100
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 168
;;
defb %01000000
defb %11000000
defb %01000100
defb %01001100
defb %01010100
defb %00011110
defb %00000100
defb %00000000
;--------------------------
;; character 169
;;
defb %01000000
defb %11000000
defb %01001100
defb %01010010
defb %01000100
defb %00001000
defb %00011110
defb %00000000
;--------------------------
;; character 170
;;
defb %11100000
defb %00010000
defb %01100010
defb %00010110
defb %11101010
defb %00001111
defb %00000010
defb %00000000
;--------------------------
;; character 171
;;
defb %00000000
defb %00011000
defb %00011000
defb %01111110
defb %00011000
defb %00011000
defb %01111110
defb %00000000
;--------------------------
;; character 172
;;
defb %00011000
defb %00011000
defb %00000000
defb %01111110
defb %00000000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 173
;;
defb %00000000
defb %00000000
defb %00000000
defb %01111110
defb %00000110
defb %00000110
defb %00000000
defb %00000000
;--------------------------
;; character 174
;;
defb %00011000
defb %00000000
defb %00011000
defb %00110000
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 175
;;
defb %00011000
defb %00000000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %00000000
;--------------------------
;; character 176
;;
defb %00000000
defb %00000000
defb %01110011
defb %11011110
defb %11001100
defb %11011110
defb %01110011
defb %00000000
;--------------------------
;; character 177
;;
defb %01111100
defb %11000110
defb %11000110
defb %11111100
defb %11000110
defb %11000110
defb %11111000
defb %11000000
;--------------------------
;; character 178
;;
defb %00000000
defb %01100110
defb %01100110
defb %00111100
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 179
;;
defb %00111100
defb %01100000
defb %01100000
defb %00111100
defb %01100110
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 180
;;
defb %00000000
defb %00000000
defb %00011110
defb %00110000
defb %01111100
defb %00110000
defb %00011110
defb %00000000
;--------------------------
;; character 181
;;
defb %00111000
defb %01101100
defb %11000110
defb %11111110
defb %11000110
defb %01101100
defb %00111000
defb %00000000
;--------------------------
;; character 182
;;
defb %00000000
defb %11000000
defb %01100000
defb %00110000
defb %00111000
defb %01101100
defb %11000110
defb %00000000
;--------------------------
;; character 183
;;
defb %00000000
defb %00000000
defb %01100110
defb %01100110
defb %01100110
defb %01111100
defb %01100000
defb %01100000
;--------------------------
;; character 184
;;
defb %00000000
defb %00000000
defb %00000000
defb %11111110
defb %01101100
defb %01101100
defb %01101100
defb %00000000
;--------------------------
;; character 185
;;
defb %00000000
defb %00000000
defb %00000000
defb %01111110
defb %11011000
defb %11011000
defb %01110000
defb %00000000
;--------------------------
;; character 186
;;
defb %00000011
defb %00000110
defb %00001100
defb %00111100
defb %01100110
defb %00111100
defb %01100000
defb %11000000
;--------------------------
;; character 187
;;
defb %00000011
defb %00000110
defb %00001100
defb %01100110
defb %01100110
defb %00111100
defb %01100000
defb %11000000
;--------------------------
;; character 188
;;
defb %00000000
defb %11100110
defb %00111100
defb %00011000
defb %00111000
defb %01101100
defb %11000111
defb %00000000
;--------------------------
;; character 189
;;
defb %00000000
defb %00000000
defb %01100110
defb %11000011
defb %11011011
defb %11011011
defb %01111110
defb %00000000
;--------------------------
;; character 190
;;
defb %11111110
defb %11000110
defb %01100000
defb %00110000
defb %01100000
defb %11000110
defb %11111110
defb %00000000
;--------------------------
;; character 191
;;
defb %00000000
defb %01111100
defb %11000110
defb %11000110
defb %11000110
defb %01101100
defb %11101110
defb %00000000
;--------------------------
;; character 192
;;
defb %00011000
defb %00110000
defb %01100000
defb %11000000
defb %10000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 193
;;
defb %00011000
defb %00001100
defb %00000110
defb %00000011
defb %00000001
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 194
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000001
defb %00000011
defb %00000110
defb %00001100
defb %00011000
;--------------------------
;; character 195
;;
defb %00000000
defb %00000000
defb %00000000
defb %10000000
defb %11000000
defb %01100000
defb %00110000
defb %00011000
;--------------------------
;; character 196
;;
defb %00011000
defb %00111100
defb %01100110
defb %11000011
defb %10000001
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 197
;;
defb %00011000
defb %00001100
defb %00000110
defb %00000011
defb %00000011
defb %00000110
defb %00001100
defb %00011000
;--------------------------
;; character 198
;;
defb %00000000
defb %00000000
defb %00000000
defb %10000001
defb %11000011
defb %01100110
defb %00111100
defb %00011000
;--------------------------
;; character 199
;;
defb %00011000
defb %00110000
defb %01100000
defb %11000000
defb %11000000
defb %01100000
defb %00110000
defb %00011000
;--------------------------
;; character 200
;;
defb %00011000
defb %00110000
defb %01100000
defb %11000001
defb %10000011
defb %00000110
defb %00001100
defb %00011000
;--------------------------
;; character 201
;;
defb %00011000
defb %00001100
defb %00000110
defb %10000011
defb %11000001
defb %01100000
defb %00110000
defb %00011000
;--------------------------
;; character 202
;;
defb %00011000
defb %00111100
defb %01100110
defb %11000011
defb %11000011
defb %01100110
defb %00111100
defb %00011000
;--------------------------
;; character 203
;;
defb %11000011
defb %11100111
defb %01111110
defb %00111100
defb %00111100
defb %01111110
defb %11100111
defb %11000011
;--------------------------
;; character 204
;;
defb %00000011
defb %00000111
defb %00001110
defb %00011100
defb %00111000
defb %01110000
defb %11100000
defb %11000000
;--------------------------
;; character 205
;;
defb %11000000
defb %11100000
defb %01110000
defb %00111000
defb %00011100
defb %00001110
defb %00000111
defb %00000011
;--------------------------
;; character 206
;;
defb %11001100
defb %11001100
defb %00110011
defb %00110011
defb %11001100
defb %11001100
defb %00110011
defb %00110011
;--------------------------
;; character 207
;;
defb %10101010
defb %01010101
defb %10101010
defb %01010101
defb %10101010
defb %01010101
defb %10101010
defb %01010101
;--------------------------
;; character 208
;;
defb %11111111
defb %11111111
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 209
;;
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
defb %00000011
;--------------------------
;; character 210
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %11111111
defb %11111111
;--------------------------
;; character 211
;;
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
defb %11000000
;--------------------------
;; character 212
;;
defb %11111111
defb %11111110
defb %11111100
defb %11111000
defb %11110000
defb %11100000
defb %11000000
defb %10000000
;--------------------------
;; character 213
;;
defb %11111111
defb %01111111
defb %00111111
defb %00011111
defb %00001111
defb %00000111
defb %00000011
defb %00000001
;--------------------------
;; character 214
;;
defb %00000001
defb %00000011
defb %00000111
defb %00001111
defb %00011111
defb %00111111
defb %01111111
defb %11111111
;--------------------------
;; character 215
;;
defb %10000000
defb %11000000
defb %11100000
defb %11110000
defb %11111000
defb %11111100
defb %11111110
defb %11111111
;--------------------------
;; character 216
;;
defb %10101010
defb %01010101
defb %10101010
defb %01010101
defb %00000000
defb %00000000
defb %00000000
defb %00000000
;--------------------------
;; character 217
;;
defb %00001010
defb %00000101
defb %00001010
defb %00000101
defb %00001010
defb %00000101
defb %00001010
defb %00000101
;--------------------------
;; character 218
;;
defb %00000000
defb %00000000
defb %00000000
defb %00000000
defb %10101010
defb %01010101
defb %10101010
defb %01010101
;--------------------------
;; character 219
;;
defb %10100000
defb %01010000
defb %10100000
defb %01010000
defb %10100000
defb %01010000
defb %10100000
defb %01010000
;--------------------------
;; character 220
;;
defb %10101010
defb %01010100
defb %10101000
defb %01010000
defb %10100000
defb %01000000
defb %10000000
defb %00000000
;--------------------------
;; character 221
;;
defb %10101010
defb %01010101
defb %00101010
defb %00010101
defb %00001010
defb %00000101
defb %00000010
defb %00000001
;--------------------------
;; character 222
;;
defb %00000001
defb %00000010
defb %00000101
defb %00001010
defb %00010101
defb %00101010
defb %01010101
defb %10101010
;--------------------------
;; character 223
;;
defb %00000000
defb %10000000
defb %01000000
defb %10100000
defb %01010000
defb %10101000
defb %01010100
defb %10101010
;--------------------------
;; character 224
;;
defb %01111110
defb %11111111
defb %10011001
defb %11111111
defb %10111101
defb %11000011
defb %11111111
defb %01111110
;--------------------------
;; character 225
;;
defb %01111110
defb %11111111
defb %10011001
defb %11111111
defb %11000011
defb %10111101
defb %11111111
defb %01111110
;--------------------------
;; character 226
;;
defb %00111000
defb %00111000
defb %11111110
defb %11111110
defb %11111110
defb %00010000
defb %00111000
defb %00000000
;--------------------------
;; character 227
;;
defb %00010000
defb %00111000
defb %01111100
defb %11111110
defb %01111100
defb %00111000
defb %00010000
defb %00000000
;--------------------------
;; character 228
;;
defb %01101100
defb %11111110
defb %11111110
defb %11111110
defb %01111100
defb %00111000
defb %00010000
defb %00000000
;--------------------------
;; character 229
;;
defb %00010000
defb %00111000
defb %01111100
defb %11111110
defb %11111110
defb %00010000
defb %00111000
defb %00000000
;--------------------------
;; character 230
;;
defb %00000000
defb %00111100
defb %01100110
defb %11000011
defb %11000011
defb %01100110
defb %00111100
defb %00000000
;--------------------------
;; character 231
;;
defb %00000000
defb %00111100
defb %01111110
defb %11111111
defb %11111111
defb %01111110
defb %00111100
defb %00000000
;--------------------------
;; character 232
;;
defb %00000000
defb %01111110
defb %01100110
defb %01100110
defb %01100110
defb %01100110
defb %01111110
defb %00000000
;--------------------------
;; character 233
;;
defb %00000000
defb %01111110
defb %01111110
defb %01111110
defb %01111110
defb %01111110
defb %01111110
defb %00000000
;--------------------------
;; character 234
;;
defb %00001111
defb %00000111
defb %00001101
defb %01111000
defb %11001100
defb %11001100
defb %11001100
defb %01111000
;--------------------------
;; character 235
;;
defb %00111100
defb %01100110
defb %01100110
defb %01100110
defb %00111100
defb %00011000
defb %01111110
defb %00011000
;--------------------------
;; character 236
;;
defb %00001100
defb %00001100
defb %00001100
defb %00001100
defb %00001100
defb %00111100
defb %01111100
defb %00111000
;--------------------------
;; character 237
;;
defb %00011000
defb %00011100
defb %00011110
defb %00011011
defb %00011000
defb %01111000
defb %11111000
defb %01110000
;--------------------------
;; character 238
;;
defb %10011001
defb %01011010
defb %00100100
defb %11000011
defb %11000011
defb %00100100
defb %01011010
defb %10011001
;--------------------------
;; character 239
;;
defb %00010000
defb %00111000
defb %00111000
defb %00111000
defb %00111000
defb %00111000
defb %01111100
defb %11010110
;--------------------------
;; character 240
;;
defb %00011000
defb %00111100
defb %01111110
defb %11111111
defb %00011000
defb %00011000
defb %00011000
defb %00011000
;--------------------------
;; character 241
;;
defb %00011000
defb %00011000
defb %00011000
defb %00011000
defb %11111111
defb %01111110
defb %00111100
defb %00011000
;--------------------------
;; character 242
;;
defb %00010000
defb %00110000
defb %01110000
defb %11111111
defb %11111111
defb %01110000
defb %00110000
defb %00010000
;--------------------------
;; character 243
;;
defb %00001000
defb %00001100
defb %00001110
defb %11111111
defb %11111111
defb %00001110
defb %00001100
defb %00001000
;--------------------------
;; character 244
;;
defb %00000000
defb %00000000
defb %00011000
defb %00111100
defb %01111110
defb %11111111
defb %11111111
defb %00000000
;--------------------------
;; character 245
;;
defb %00000000
defb %00000000
defb %11111111
defb %11111111
defb %01111110
defb %00111100
defb %00011000
defb %00000000
;--------------------------
;; character 246
;;
defb %10000000
defb %11100000
defb %11111000
defb %11111110
defb %11111000
defb %11100000
defb %10000000
defb %00000000
;--------------------------
;; character 247
;;
defb %00000010
defb %00001110
defb %00111110
defb %11111110
defb %00111110
defb %00001110
defb %00000010
defb %00000000
;--------------------------
;; character 248
;;
defb %00111000
defb %00111000
defb %10010010
defb %01111100
defb %00010000
defb %00101000
defb %00101000
defb %00101000
;--------------------------
;; character 249
;;
defb %00111000
defb %00111000
defb %00010000
defb %11111110
defb %00010000
defb %00101000
defb %01000100
defb %10000010
;--------------------------
;; character 250
;;
defb %00111000
defb %00111000
defb %00010010
defb %01111100
defb %10010000
defb %00101000
defb %00100100
defb %00100010
;--------------------------
;; character 251
;;
defb %00111000
defb %00111000
defb %10010000
defb %01111100
defb %00010010
defb %00101000
defb %01001000
defb %10001000
;--------------------------
;; character 252
;;
defb %00000000
defb %00111100
defb %00011000
defb %00111100
defb %00111100
defb %00111100
defb %00011000
defb %00000000
;--------------------------
;; character 253
;;
defb %00111100
defb %11111111
defb %11111111
defb %00011000
defb %00001100
defb %00011000
defb %00110000
defb %00011000
;--------------------------
;; character 254
;;
defb %00011000
defb %00111100
defb %01111110
defb %00011000
defb %00011000
defb %01111110
defb %00111100
defb %00011000
;--------------------------
;; character 255
;;
defb %00000000
defb %00100100
defb %01100110
defb %11111111
defb %01100110
defb %00100100
defb %00000000
defb %00000000',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: rom
  SELECT id INTO tag_uuid FROM tags WHERE name = 'rom';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
