-- Migration: Import z80code projects batch 2
-- Projects 3 to 4
-- Generated: 2026-01-25T21:43:30.182476

-- Project 3: sprite-drawing by Axelay
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'sprite-drawing',
    'Imported from z80Code. Author: Axelay. Re: Mode 3',
    'public',
    false,
    false,
    '2021-05-21T19:45:25.378000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; https://www.cpcwiki.eu/forum/programming/mode-3/msg22570/#msg22570

; 4065 nops for restore/render 6x21 sprite

org #8000

run start
SpriteAddr equ #200+16
BGSave equ #300
SpriteData equ #400
SpritesYX
   defb 115,46
SpritesYXMv
   defb 1,1
Mode1Pal
defb #55,#5f,#4e,#54

start
di      ;; disable interrupts
im 1     ;; interrupt mode 1 (CPU will jump to #0038 when a interrupt occrs)
ld hl,#c9fb    ;; C9 FB are the bytes for the Z80 opcodes EI:RET
ld (#0038),hl   ;; setup interrupt handler
ei      ;; re-enable interrupts
; set colours 0-3
    ld a,3
    ld hl,Mode1Pal
    call SetColours
; fill the screen with the background block
call PrintBlocks
; copy the Y address table to #100
ld hl,YTable
ld de,#100
ld bc,232
ldir
; copy the sprite to #400 Sprite is 6 bytes by 21 = 126 bytes, but contains mask data
; which doubles it''s size
ld hl,Sprite
ld de,SpriteData
ld bc,252
ldir
; fill the sprite address list with dummy values for first frame
ld hl,#cfd0
ld (SpriteAddr),hl
ld hl,SpriteAddr
ld de,SpriteAddr+2
ld bc,21*2-2
ldir
main
; wait for vsync
call FrameFlyB
; wait to start code at same time every frame
; un-comment additional halts to see entire execution
; time, though sprite will disappear during this time
halt
;halt
;halt
; set border to different blues for each stage
ld bc,#7f10
out (c),c
ld bc,#7f55
out (c),c
; restore the background from last frame
; (requires the dummy addresses for the first frame, set previously)
call RestoreBlock
ld bc,#7f10
out (c),c
ld bc,#7f44
out (c),c
; generate a new list of screen addresses based on current XY coord (in bytes)
call CalcSpriteAddr
ld bc,#7f10
out (c),c
ld bc,#7f5d
out (c),c
; save the background for the new position of the sprite
call SaveBlock
ld bc,#7f10
out (c),c
ld bc,#7f5b
out (c),c
; finaly
call PrintSprite
; and now set border back to black
ld bc,#7f10
out (c),c
ld bc,#7f54
out (c),c
; now move the sprite about
call MoveSprite
; repeat
jr main
RestoreBlock
; is the last time the address list is used, so SP can be used to pop the addresses
    ld (SaveSP+1),sp
    ld sp,SpriteAddr ; load SP with top of address list
    ld bc,21*#100+#ff ; ld b with 21 and c with dummy to stop ldi corrupting b
    ld hl,BGsave ; load hl with saved background data
ResBlkLp
; restore each line by popping address of screen to de and copying back the screen data
    pop de
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    djnz ResBlkLp
SaveSP
    ld sp,0
    ret

SaveBlock
; with interrupts enabled, is generally not possible unless writing code with fixed
; execution times to assume can still use SP to pop the address list without an interupt
; corrupting the address list if it happens along while reading it
; so for this example a much lousier (slower) method is used
    ld hl,SpriteAddr ; ld hl with pointer to screen address list of sprite
    ld b,21 ; height of sprite
    exx
    ld de,BGsave ; load de'' with destination to back up screen data to
    exx
SavBlkLp
; instead of pop, ugly code using a and a'' to get (hl) into hl''
    ld a,(hl)
    inc l
    ex af,af''
    ld a,(hl)
    inc l
    exx
    ld h,a
    ex af,af''
    ld l,a
    ldi
    ldi
    ldi
    ldi
    ldi
    ldi
    exx
    djnz SavBlkLp
    ret
PrintSprite
    ld ix,SpriteAddr ; use ix register to read address list this time
    ld hl,SpriteData ; hl points to sprite data, which includes the mask byte
                     ; mask precedes the data byte it relates to
    ld b,21 ; pixel lines to print
PrnSprLp
; normally I''d use the alternate registers to work out what frame to print
; so assuming the alt registers are not available, IX is used to read address
; list instead
    ld e,(ix+0)
    inc ixl
    ld d,(ix+0)
    inc ixl ; de now has screen address for this row
; for each byte, read the screen data from (de), ''and'' with (hl) and ''or'' with (hl+1)
; then write back to (de)
; 1
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    inc de
; 2
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    inc de
; 3
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    inc de
; 4
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    inc de
; 5
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    inc de
; 6
    ld a,(de)
    and (hl)
    inc l
    or (hl)
    ld (de),a
    inc l
    djnz PrnSprLp
    ret
; YTable contains only the odd address lines, so the table fits in one 256 byte page
; however, both odd and even addresses are determined from this table
CalcSpriteAddr
; write screen addresses with SP, possible interrupts are no problem as they are being
; written, not read
    ld (SaveSPCalc+1),sp
    ld sp,SpriteAddr+42 ; set SP to ''bottom'' of address list
    ld hl,SpritesYX+1 ; set hl to point to sprite co-ord, stored y first
    exx
    ld h,1 ; base ytable is at #100, so preload h'' with 1
    exx
    ld b,1 ; only 1 sprite to print
CalcSprLoop
    ld a,(hl) ; ld x co-ord into a
    dec l
    ex af,af''
    ld a,(hl) ; ld y co-ord into a''
    add a,20 ; start from bottom of y and work up
    dec l
    exx
    ld l,a ; ld l with y co-ord
    ex af,af''
    ld b,#c0 ; if screen flipping, this value would change to base of current screen
    ld c,a   ; ld c'' with x co-ord
             ; now bc'' contains what needs to be added to the base screen address
    bit 0,l ; if y address is even, need to start with single address
    jr z,EvenYAddr
    ld iy,OddAddrExit
    jr OddYAddr
EvenYAddr
    ld iy,EvenAddrExit
    inc l ; need to bump up to high byte from address table
    ld d,(hl) ; get contents of (hl), add bc, and put result in de
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    res 3,d ; only want even address
    push de
    dec l
OddYAddr
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de ; de contains odd address, so push
    res 3,d ; move to even line above it
    push de ; and push that as well
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    dec l
;
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    res 3,d
    push de
    jp (iy) ; skip the last line if y co-ord was even
OddAddrExit ; if y co-ord was odd, get one last address line
    dec l
    ld d,(hl)
    dec l
    ld a,(hl)
    add a,c
    ld e,a
    ld a,b
    adc a,d
    ld d,a
    push de
    dec l
EvenAddrExit
    exx
    dec b
    jp nz,CalcSprLoop
;
SaveSPCalc
    ld sp,0
    ret
MoveSprite
    ld hl,SpritesYXMv+1
; x first
    ld a,(hl)
    res 1,l
    add a,(hl)
    ld (hl),a
    set 1,l
    cp a,0
    jr z,SwapXDir
    cp a,74
    jr nz,DontSwapXDir
SwapXDir
    ld a,(hl)
    neg
    ld (hl),a
DontSwapXDir
    dec l
; now y move
    ld a,(hl)
    res 1,l
    add a,(hl)
    ld (hl),a
    set 1,l
    cp a,16
    jr z,SwapYDir
    cp a,195
    jr nz,DontSwapYDir
SwapYDir
    ld a,(hl)
    neg
    ld (hl),a
DontSwapYDir
    ret
FrameFlyB
    ld b,#f5    ;; B = I/O address of PPI port B
vsync
    in a,(c)    ;; read PPI port B input
    rra      ;; transfer bit 0 into carry
    jr nc,vsync    ;; if carry=0 then vsync= 0 (inactive),
      ;; if carry=1 then vsync=1 (active)
    ret
list
SetColours
nolist
; HL points to list, A holds 15 or 3
    ld b,#7f
    ld c,(hl)
    out (c),a
    out (c),c
    inc hl
    or a
    jr z,SetColEnd
    dec a
    jr SetColours
SetColEnd
    ld a,#10 ; set border same as ink 0
    out (c),a
    out (c),c
    ret
PrintBlocks
    ld de,#c000
    ld c,20
PBsLpOuter
    push de
    ld b,13
PBsLLpInner
    push bc
    ld a,1
    cp a,b
    jr nz,PrintBlock
    jr PrintHalfBlock
PrintBlockReturn
    pop bc
    djnz PBsLLpInner
    pop de
    inc de
    inc de
    inc de
    inc de
    dec c
    jr nz,PBsLpOuter
    ret
PrintHalfBlock
    ld c,1+32
    jr PrnBlkCommon
PrintBlock
    ld c,2+64
PrnBlkCommon
    ld hl,BackGndBlock
PBLpO
    ld b,8
PBLpI
    ldi
    ldi
    ldi
    ldi
    ex de,hl
    push de
    ld de,#800-4
    add hl,de
    pop de
    ex de,hl
    djnz PBLpI
    ex de,hl
    push de
    ld de,#c000+#50
    add hl,de
    pop de
    ex de,hl
    dec c
    jr nz,PBLpO
    jr PrintBlockReturn
BackGndBlock
    defb 143,15,15,15
    defb 71,15,15,15
    defb 239,175,175,143
    defb 119,95,95,79
    defb 239,143,15,143
    defb 119,95,79,79
    defb 239,239,175,143
    defb 119,95,79,79
    defb 239,239,175,143
    defb 119,95,79,79
    defb 239,255,239,143
    defb 119,95,95,79
    defb 239,175,175,143
    defb 119,255,255,207
    defb 255,255,255,239
    defb 85,85,85,85
Sprite
    defb 238,0,119,0,0,240,0,240,238,0,119,0
    defb 204,1,0,56,0,75,0,30,0,193,51,8
    defb 136,19,0,60,0,225,0,135,0,211,17,12
    defb 0,103,0,158,0,210,0,90,0,167,0,142
    defb 0,87,0,79,0,240,0,180,0,223,0,78
    defb 136,51,0,175,0,240,0,224,0,175,17,172
    defb 136,64,0,222,0,240,0,240,0,119,17,96
    defb 0,176,0,48,0,240,0,240,0,128,0,240
    defb 0,208,0,240,0,195,0,60,0,240,0,180
    defb 0,160,0,240,0,167,0,30,0,240,0,30
    defb 0,144,0,112,0,71,0,30,0,225,0,150
    defb 0,160,0,176,0,39,0,158,0,240,0,90
    defb 0,144,0,80,0,147,0,124,0,240,0,180
    defb 0,128,0,176,0,192,0,112,0,240,0,210
    defb 136,64,0,6,0,240,0,240,0,150,17,224
    defb 136,99,0,175,0,176,0,224,0,207,17,44
    defb 0,87,0,79,0,80,0,96,0,175,0,142
    defb 0,103,0,174,0,32,0,176,0,87,0,78
    defb 136,51,0,76,0,0,0,80,0,35,17,140
    defb 204,17,0,184,0,0,0,32,0,209,51,8
    defb 238,0,119,0,0,240,0,240,238,0,119,0
YTable
    defw #fd0,#1fd0,#2fd0,#3fd0
    defw #fd0,#1fd0,#2fd0,#3fd0
;
    defw #800,#1800,#2800,#3800
    defw #850,#1850,#2850,#3850
    defw #8a0,#18a0,#28a0,#38a0
    defw #8f0,#18f0,#28f0,#38f0
;
    defw #940,#1940,#2940,#3940
    defw #990,#1990,#2990,#3990
    defw #9e0,#19e0,#29e0,#39e0
    defw #a30,#1a30,#2a30,#3a30
;
    defw #a80,#1a80,#2a80,#3a80
    defw #ad0,#1ad0,#2ad0,#3ad0
    defw #b20,#1b20,#2b20,#3b20
    defw #b70,#1b70,#2b70,#3b70
;
    defw #bc0,#1bc0,#2bc0,#3bc0
    defw #c10,#1c10,#2c10,#3c10
    defw #c60,#1c60,#2c60,#3c60
    defw #cb0,#1cb0,#2cb0,#3cb0
;
    defw #d00,#1d00,#2d00,#3d00
    defw #d50,#1d50,#2d50,#3d50
    defw #da0,#1da0,#2da0,#3da0
    defw #df0,#1df0,#2df0,#3df0
;
    defw #e40,#1e40,#2e40,#3e40
    defw #e90,#1e90,#2e90,#3e90
    defw #ee0,#1ee0,#2ee0,#3ee0
    defw #f30,#1f30,#2f30,#3f30
;
    defw #f80,#1f80,#2f80,#3f80
;
    defw #fd0,#1fd0,#2fd0,#3fd0
    defw #fd0,#1fd0,#2fd0,#3fd0',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: affichage-de-sprite
  SELECT id INTO tag_uuid FROM tags WHERE name = 'affichage-de-sprite';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 4: tarzan-le roi de jungle ! by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'tarzan-le roi de jungle !',
    'Imported from z80Code. Author: tronic. wav2ay (Roudoudou)',
    'public',
    false,
    false,
    '2021-01-10T21:44:53.764000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Tarzan, le roi de la Jungle ^^		
		
		BUILDSNA
		BANKSET 0
        
        org #100
		run $
start
		di
		ld hl,#c9fb
		ld (#38),hl

		ld (pile+1),sp
        
		ld sp,wav2ay
		pop hl
		     
        ld b,#f4:out (c),l
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0
		
        ld de,((wav2ay_tarzan_fin-wav2ay_tarzan_debut)/9)/2

main
		ld b,#f5
sync	in a,(c)
		rra
		jr nc,sync
        
		ei:halt:halt:di

		ld bc,#7f10:out (c),c:ld a,#6c:out (c),a

		repeat 9
	  	pop hl
		ld b,#f4:out (c),l
		ld bc,#f6c0:out (c),c
		out (c),0
		ld b,#f4:out (c),h
		ld bc,#f680:out (c),c
		out (c),0
        rend
        
		ld bc,#7f10:out (c),c:ld a,#54:out (c),a        

		ei:halt:halt:di

        dec de
		ld a,d
		or e

		jp nz,main

pile	ld sp,0
		ei
		jr $


wav2ay
db #07,#38
wav2ay_tarzan_debut
db 8,5,0,68,1,3,9,3,2,243,3,1,10,3,4,224,5,0
db 8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,3,0,210,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,5,0,111,1,0,9,5,2,54,3,1,10,5,4,183,5,0
db 8,12,0,134,1,0,9,11,2,112,3,0,10,10,4,112,5,1
db 8,14,0,125,1,0,9,11,2,118,3,0,10,10,4,9,5,1
db 8,14,0,110,1,0,9,8,2,74,3,0,10,5,4,54,5,0
db 8,12,0,113,1,0,9,11,2,101,3,0,10,10,4,217,5,0
db 8,13,0,102,1,0,9,11,2,67,3,0,10,10,4,214,5,0
db 8,13,0,103,1,0,9,11,2,208,3,0,10,10,4,68,5,0
db 8,12,0,103,1,0,9,11,2,69,3,0,10,10,4,203,5,0
db 8,12,0,69,1,0,9,11,2,104,3,0,10,10,4,214,5,0
db 8,13,0,103,1,0,9,12,2,68,3,0,10,11,4,208,5,0
db 8,14,0,102,1,0,9,11,2,202,3,0,10,8,4,67,5,0
db 8,13,0,101,1,0,9,9,2,67,3,0,10,7,4,193,5,0
db 8,11,0,102,1,0,9,10,2,67,3,0,10,8,4,196,5,0
db 8,13,0,102,1,0,9,11,2,68,3,0,10,8,4,212,5,0
db 8,14,0,102,1,0,9,11,2,205,3,0,10,9,4,68,5,0
db 8,14,0,102,1,0,9,12,2,208,3,0,10,8,4,69,5,0
db 8,14,0,102,1,0,9,12,2,208,3,0,10,7,4,51,5,0
db 8,13,0,101,1,0,9,10,2,205,3,0,10,8,4,67,5,0
db 8,12,0,100,1,0,9,9,2,66,3,0,10,5,4,205,5,0
db 8,12,0,101,1,0,9,9,2,198,3,0,10,8,4,67,5,0
db 8,11,0,100,1,0,9,10,2,200,3,0,10,8,4,67,5,0
db 8,12,0,101,1,0,9,10,2,68,3,0,10,9,4,196,5,0
db 8,12,0,101,1,0,9,10,2,204,3,0,10,7,4,67,5,0
db 8,12,0,101,1,0,9,10,2,205,3,0,10,7,4,67,5,0
db 8,12,0,100,1,0,9,10,2,203,3,0,10,8,4,66,5,0
db 8,11,0,100,1,0,9,10,2,204,3,0,10,7,4,67,5,0
db 8,10,0,101,1,0,9,9,2,198,3,0,10,9,4,67,5,0
db 8,10,0,67,1,0,9,7,2,103,3,0,10,6,4,67,5,0
db 8,10,0,67,1,0,9,7,2,49,3,1,10,5,4,33,5,0
db 8,11,0,102,1,0,9,10,2,202,3,0,10,9,4,67,5,0
db 8,12,0,102,1,0,9,10,2,207,3,0,10,8,4,68,5,0
db 8,12,0,101,1,0,9,10,2,205,3,0,10,7,4,67,5,0
db 8,11,0,101,1,0,9,10,2,200,3,0,10,7,4,67,5,0
db 8,10,0,66,1,0,9,10,2,196,3,0,10,9,4,100,5,0
db 8,10,0,67,1,0,9,7,2,104,3,0,10,5,4,189,5,0
db 8,10,0,66,1,0,9,7,2,67,3,0,10,5,4,193,5,0
db 8,10,0,67,1,0,9,9,2,101,3,0,10,9,4,209,5,0
db 8,12,0,68,1,0,9,10,2,30,3,1,10,7,4,224,5,0
db 8,13,0,65,1,0,9,5,2,32,3,0,10,3,4,243,5,1
db 8,13,0,63,1,0,9,7,2,64,3,0,10,5,4,56,5,0
db 8,13,0,62,1,0,9,6,2,64,3,0,10,4,4,94,5,0
db 8,14,0,62,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,13,0,63,1,0,9,8,2,64,3,0,10,6,4,56,5,0
db 8,12,0,62,1,0,9,11,2,92,3,0,10,9,4,64,5,0
db 8,13,0,91,1,0,9,10,2,45,3,0,10,10,4,92,5,0
db 8,13,0,91,1,0,9,8,2,92,3,0,10,8,4,45,5,0
db 8,12,0,91,1,0,9,9,2,45,3,0,10,6,4,92,5,0
db 8,13,0,89,1,0,9,10,2,44,3,0,10,5,4,227,5,0
db 8,13,0,90,1,0,9,10,2,45,3,0,10,7,4,45,5,0
db 8,13,0,90,1,0,9,9,2,92,3,0,10,8,4,63,5,0
db 8,14,0,65,1,0,9,7,2,250,3,0,10,7,4,91,5,1
db 8,14,0,65,1,0,9,6,2,215,3,0,10,5,4,146,5,0
db 8,14,0,65,1,0,9,6,2,157,3,0,10,3,4,189,5,0
db 8,14,0,66,1,0,9,7,2,67,3,0,10,5,4,63,5,0
db 8,13,0,90,1,0,9,10,2,45,3,0,10,9,4,74,5,1
db 8,12,0,91,1,0,9,10,2,45,3,0,10,8,4,92,5,0
db 8,12,0,91,1,0,9,10,2,45,3,0,10,6,4,92,5,0
db 8,13,0,90,1,0,9,10,2,45,3,0,10,9,4,92,5,0
db 8,11,0,85,1,0,9,9,2,92,3,0,10,8,4,234,5,0
db 8,12,0,88,1,0,9,7,2,44,3,0,10,5,4,59,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,0,4,0,5,0
db 8,14,0,87,1,0,9,6,2,43,3,0,10,5,4,43,5,0
db 8,14,0,87,1,0,9,5,2,43,3,0,10,3,4,156,5,1
db 8,14,0,87,1,0,9,5,2,44,3,0,10,3,4,29,5,0
db 8,14,0,88,1,0,9,3,2,44,3,0,10,0,4,0,5,0
db 8,14,0,88,1,0,9,5,2,44,3,0,10,5,4,180,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,7,4,179,5,0
db 8,14,0,87,1,0,9,5,2,43,3,0,10,5,4,64,5,1
db 8,14,0,87,1,0,9,5,2,44,3,0,10,0,4,0,5,0
db 8,14,0,87,1,0,9,3,2,43,3,0,10,0,4,0,5,0
db 8,14,0,87,1,0,9,4,2,29,3,0,10,0,4,0,5,0
db 8,14,0,88,1,0,9,4,2,220,3,0,10,3,4,43,5,0
db 8,13,0,88,1,0,9,3,2,168,3,1,10,3,4,43,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,5,2,44,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,0,4,0,5,0
db 8,13,0,86,1,0,9,6,2,43,3,0,10,3,4,66,5,0
db 8,13,0,86,1,0,9,6,2,43,3,0,10,5,4,43,5,0
db 8,13,0,87,1,0,9,6,2,43,3,0,10,5,4,182,5,0
db 8,13,0,86,1,0,9,7,2,43,3,0,10,3,4,66,5,0
db 8,13,0,87,1,0,9,5,2,43,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,3,4,161,5,0
db 8,13,0,87,1,0,9,5,2,43,3,0,10,5,4,43,5,0
db 8,13,0,87,1,0,9,4,2,43,3,0,10,0,4,0,5,0
db 8,13,0,86,1,0,9,7,2,43,3,0,10,5,4,43,5,0
db 8,13,0,86,1,0,9,8,2,43,3,0,10,3,4,177,5,0
db 8,13,0,88,1,0,9,9,2,79,3,0,10,5,4,43,5,0
db 8,13,0,86,1,0,9,6,2,43,3,0,10,5,4,43,5,0
db 8,13,0,87,1,0,9,7,2,43,3,0,10,5,4,43,5,0
db 8,13,0,87,1,0,9,6,2,43,3,0,10,5,4,174,5,0
db 8,12,0,85,1,0,9,10,2,86,3,0,10,7,4,42,5,0
db 8,12,0,86,1,0,9,8,2,43,3,0,10,5,4,174,5,0
db 8,12,0,86,1,0,9,7,2,42,3,0,10,3,4,65,5,0
db 8,13,0,87,1,0,9,4,2,52,3,1,10,0,4,0,5,0
db 8,14,0,88,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,14,0,87,1,0,9,0,2,0,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,4,2,43,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,3,2,43,3,0,10,0,4,0,5,0
db 8,13,0,87,1,0,9,7,2,44,3,0,10,5,4,59,5,0
db 8,12,0,88,1,0,9,7,2,44,3,0,10,5,4,59,5,0
db 8,12,0,89,1,0,9,9,2,102,3,0,10,9,4,45,5,0
db 8,12,0,90,1,0,9,9,2,45,3,0,10,8,4,92,5,0
db 8,12,0,91,1,0,9,10,2,45,3,0,10,5,4,92,5,0
db 8,12,0,91,1,0,9,10,2,45,3,0,10,7,4,92,5,0
db 8,12,0,67,1,0,9,9,2,89,3,0,10,8,4,96,5,0
db 8,13,0,66,1,0,9,10,2,67,3,0,10,5,4,156,5,0
db 8,13,0,66,1,0,9,9,2,67,3,0,10,5,4,61,5,0
db 8,13,0,66,1,0,9,9,2,67,3,0,10,6,4,154,5,0
db 8,11,0,66,1,0,9,11,2,89,3,0,10,10,4,92,5,0
db 8,12,0,91,1,0,9,8,2,45,3,0,10,7,4,92,5,0
db 8,12,0,91,1,0,9,9,2,45,3,0,10,5,4,92,5,0
db 8,12,0,91,1,0,9,9,2,46,3,0,10,8,4,92,5,0
db 8,11,0,92,1,0,9,8,2,46,3,0,10,7,4,92,5,0
db 8,12,0,92,1,0,9,8,2,45,3,0,10,7,4,92,5,0
db 8,12,0,93,1,0,9,9,2,46,3,0,10,7,4,47,5,0
db 8,13,0,63,1,0,9,7,2,74,3,1,10,5,4,56,5,0
db 8,12,0,63,1,0,9,9,2,64,3,0,10,3,4,58,5,0
db 8,13,0,63,1,0,9,5,2,64,3,0,10,4,4,60,5,0
db 8,13,0,63,1,0,9,10,2,64,3,0,10,0,4,0,5,0
db 8,12,0,64,1,0,9,4,2,32,3,0,10,3,4,33,5,0
db 8,12,0,67,1,0,9,6,2,33,3,0,10,5,4,72,5,0
db 8,11,0,66,1,0,9,10,2,3,3,1,10,9,4,22,5,1
db 8,9,0,67,1,0,9,8,2,217,3,0,10,5,4,100,5,0
db 8,10,0,66,1,0,9,7,2,98,3,0,10,5,4,67,5,0
db 8,10,0,66,1,0,9,8,2,100,3,0,10,6,4,189,5,0
db 8,10,0,99,1,0,9,10,2,66,3,0,10,7,4,204,5,0
db 8,11,0,99,1,0,9,9,2,66,3,0,10,8,4,201,5,0
db 8,11,0,99,1,0,9,10,2,201,3,0,10,6,4,67,5,0
db 8,10,0,100,1,0,9,9,2,67,3,0,10,9,4,201,5,0
db 8,11,0,66,1,0,9,7,2,100,3,0,10,7,4,200,5,0
db 8,11,0,66,1,0,9,7,2,195,3,0,10,6,4,98,5,0
db 8,10,0,66,1,0,9,9,2,99,3,0,10,7,4,198,5,0
db 8,11,0,100,1,0,9,9,2,204,3,0,10,8,4,66,5,0
db 8,12,0,100,1,0,9,10,2,199,3,0,10,7,4,66,5,0
db 8,12,0,99,1,0,9,9,2,66,3,0,10,5,4,197,5,0
db 8,11,0,100,1,0,9,10,2,203,3,0,10,6,4,67,5,0
db 8,11,0,99,1,0,9,9,2,201,3,0,10,7,4,67,5,0
db 8,10,0,100,1,0,9,9,2,66,3,0,10,7,4,67,5,0
db 8,10,0,99,1,0,9,9,2,66,3,0,10,4,4,191,5,0
db 8,12,0,100,1,0,9,8,2,66,3,0,10,7,4,208,5,0
db 8,12,0,100,1,0,9,9,2,66,3,0,10,8,4,199,5,0
db 8,13,0,101,1,0,9,10,2,202,3,0,10,7,4,66,5,0
db 8,13,0,101,1,0,9,10,2,198,3,0,10,7,4,67,5,0
db 8,12,0,100,1,0,9,9,2,198,3,0,10,5,4,67,5,0
db 8,11,0,99,1,0,9,8,2,67,3,0,10,3,4,210,5,0
db 8,10,0,100,1,0,9,9,2,67,3,0,10,5,4,205,5,0
db 8,11,0,101,1,0,9,7,2,67,3,0,10,5,4,203,5,0
db 8,13,0,101,1,0,9,9,2,67,3,0,10,7,4,194,5,0
db 8,12,0,103,1,0,9,11,2,68,3,0,10,10,4,204,5,0
db 8,11,0,69,1,0,9,11,2,104,3,0,10,10,4,206,5,0
db 8,11,0,104,1,0,9,10,2,69,3,0,10,10,4,210,5,0
db 8,13,0,103,1,0,9,11,2,68,3,0,10,10,4,206,5,0
db 8,12,0,103,1,0,9,10,2,68,3,0,10,9,4,202,5,0
db 8,11,0,107,1,0,9,9,2,68,3,0,10,8,4,207,5,0
db 8,13,0,111,1,0,9,5,2,215,3,0,10,3,4,75,5,0
db 8,12,0,118,1,0,9,7,2,83,3,0,10,7,4,231,5,0
;
db 8,0,0,0,1,0,9,0,2,0,3,0,10,0,4,0,5,0	; Mais tu vas la fermer ta gueule !
;
wav2ay_tarzan_fin
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: wav2ay-roudoudou
  SELECT id INTO tag_uuid FROM tags WHERE name = 'wav2ay-roudoudou';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
