-- Migration: Import z80code projects batch 55
-- Projects 109 to 110
-- Generated: 2026-01-25T21:43:30.200286

-- Project 109: head_over_heels by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'head_over_heels',
    'Imported from z80Code. Author: siko. Head Over Heels Disassembled',
    'public',
    false,
    false,
    '2020-03-02T13:56:42.292000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Head Over Heels 
; partialy disassembler with disark

org #100
run #100

; 0100		: Entry point
; 0110-011b : Some variables
; 011c-		: main loops (gameloop, wait frames..)
; 04ab      : interrupt manager
; 04f8      : Palettes, colors
; 05e5      : Sprites/Tiles rendering
; 0b00		: Gesion du clavier niveau PPI
; 3131		: Textes
; 3539      : buffer managements

; 6600-6a00 : Buffers de travail, taille #100 chaacun
; Data

lab6FC0 equ #6fc0
LAB192F equ #192f
LAB19B2 equ #19b2
LAB197d equ #197d
LAB19B4 equ #19b4
LAB3dea equ #3dea
LAB24AB equ #24AB
LAB439E equ #439E
LAB459C equ #459C
LAB4659 equ #4659
lab4ABE equ #4ABE
lab4ABD equ #4ABD
lab4B7C equ #4B7c
lab4BB3 equ #4BB3
lab4BC4 equ #4BC4
lab4B9f equ #4B9f
lab4B8a equ #4B8a
lab4399 equ #4399

lab8270 equ #8270
lab8a50 equ #8a50
lab8bd0 equ #8bd0


labAA30 equ #aa30

LAB1C9b equ #1c9b
LAB3C48 equ #3c48
LAB3C47 equ #3c47
LAB3C46 equ #3c46
LAB39B1 equ #39B1
LAB39a9 equ #39a9
LAB39b9 equ #39b9
LAB39b5 equ #39b5
LAB39ad equ #39ad


; data
lab70d7 equ #70d7
;lab8D30 equ #8d30
lab8f30 equ #8f30

labA800 equ #a800
labB4B0 equ #b4b0

labBA68 equ #BA68
labB600 equ #B600
labB630 equ #B630
labB847 equ #B847
labB877 equ #B877
labB897 equ #B897
labB898 equ #B898
labB8D0 equ #B8D0
labB9BF equ #B9BF
labBB10 equ #BB10

 di
 ld sp,#0100
 call init			; init Interrupts, some buffers
 call PPI_End
 jr lab011C
 
 nop
 nop
 
; Quelques variables (10e-119)

lab010E:
db #00,#00

lab0110:
    db #00

; Direction du personnage
char_dir:
lab0111: db #EF
; Direction du personnage pour le mouvement (FF = ne bouge pas)
lab0112: db #FF
LAB0113:
	db #00
lab0114:
    db #00,#00
; Compteur utilisé pour le rendu. décrémenté/mis a 0 dans le gestionnaire d''interruption
frame_cnt:
lab0116:
    db #01
    db #FB,#FB
    
lab0119:
    db #CD,#20,#30

; Once inititialized, starts here
lab011c:
    ld sp,#0100
    call lab2F24
    jr nc,lab0129
    call lab22ED
    jr lab012F

lab0129 call lab0BA5
lab012C call lab234A

lab012F call lab4541
lab0132 ld a,64
lab0134 ld (lab4C28),a

lab0137 xor a
lab0138 ld (lab0110),a

lab013B call lab2370

lab013E
gameloop
	call wait_frame_ready ; Attente que le compteur de trame ==0
    call lab0212
    call lab0168
    call lab042B
    call lab01D0
    call lab0276
    ld hl,lab24AE
    ld a,(hl)
    sub 1
    ld (hl),0
    ld b,a
    call nc,lab0D91
    jr gameloop

lab015E
    ld hl,(lab010E)
    ld bc,lab8D30
    xor a
    sbc hl,bc
    ret

lab0168:
    call lab015E
    ret nz
    ld (lab0114),a
    dec a
    ld (lab0112),a
    ld hl,lab4C28
    dec (hl)
    ld a,(hl)
    inc a
lab0179
    jp z,lab0119
    ld b,193
    cp 48
    push af
    call z,lab0D91
    pop af
    and 1
    ld a,201
    call z,lab4AC2
    ret

lab018D:
	ld hl,#010F
    ld a,(lab4658)
    dec a
    cp 6
    jr z,lab01BF
    jr nc,lab01B9
    cp 4
    jr c,lab01A2
    add a,a
lab019F xor 2
    dec hl
lab01A2 ld c,1
    bit 1,a
    jr nz,lab01AA
    ld c,255
lab01AA rra 
    jr c,lab01B4
    rld 
    add a,c
    rrd 
    jr lab01B9
lab01B4 rrd 
    add a,c
    rld 
lab01B9 ld sp,#100
    jp lab0137
lab01BF call lab346A
    jr lab01B9
    
;Attente de la fin de la 4eme trame
lab01C4:
wait_frame_ready
.wait:
	ld a,(frame_cnt)
    and a
    jr nz,.wait
	; Prépare attente de 4 trames		
.turbo:
    ld a,4               ; ici on peut accelerer le jeu
    ld (frame_cnt),a
    ret

lab01D0 call lab0B2F
lab01D3 ret nz
    ld b,192
    call lab0D91
    call lab0A36
    ld a,172
    call lab4AC2
lab01E1 call lab0A3C
    jr c,lab01E1
    dec c
    jp z,lab0119
    call lab0A36
    call lab2392
lab01F0 ld hl,lab4C50
lab01F3 push hl
lab01F4 ld de,lab6088
    call lab1CEE
    pop hl
    ld a,l
    ld h,a
    add a,20
lab01FF ld l,a
lab0200 cp 181
lab0202 jr c,lab01F3
    ret 
lab0205 ld hl,lab023C
    and a
    jr z,lab020E
    ld hl,lab0249
lab020E ld (lab0231+1),hl
    ret 
    

lab0212:
	call lab0B01
lab0215 bit 7,a
lab0217 ld hl,lab0113
   	call lab0262
    bit 5,a
    call lab0261
lab0222 bit 6,a
    call lab0261
    ld c,a
    rra
    call lab440F
    cp 255
    jr z,lab025C
    rra

; Applique les changements de direction
lab0231 jp c,lab0249
    ld a,c
    ld (char_dir),a
    ld (char_dir+1),a
    ret

lab023C:
    ld a,(char_dir)
    xor c
    cpl 
    xor c
    and 254
    xor c
    ld (char_dir+1),a
    ret 

lab0249 ld a,(char_dir)
    xor c
    and 254
    xor c
    ld b,a
    or c
    cp b
    jr z,lab0258
    ld a,b
    xor 254
lab0258 ld (char_dir+1),a
    ret 
    
lab025C ld a,c
    ld (char_dir+1),a
    ret
    
lab0261 inc hl
lab0262 res 0,(hl)
    jr z,lab0269
    res 1,(hl)
    ret 
lab0269 bit 1,(hl)
    ret nz
    set 1,(hl)
    set 0,(hl)
    ret 
    
lab0271
    ld b,196
    jp lab0D91
lab0276 ld a,(lab0114)
    rra 
    ret nc
lab027B ld a,(lab24AC)
    ld hl,lab4659
    or (hl)
    ld hl,(lab2486)
    or h
    or l
    jr nz,lab0271
    ld hl,(lab2480)
    cp h
    jr z,lab0271
    cp l
    jr z,lab0271
lab0292 call lab036A
    ld bc,(lab24AB)
    jr nc,lab029C
    ld (hl),c
lab029C inc hl
    rra 
    jr nc,lab02A1
lab02A0 ld (hl),c
lab02A1 ld hl,lab0114
    ld iy,lab24B0
lab02A8 ld a,e
    cp 3
    jr z,lab02FC
    ld a,(lab2485)
    and a
    jr z,lab02FC
    ld a,(iy+5)
    inc a
    sub (iy+23)
    cp 3
    jr nc,lab02FC
    ld c,a
    ld a,(iy+6)
    inc a
    sub (iy+24)
    cp 3
    jr nc,lab02FC
    ld b,a
    ld a,(iy+7)
    sub 6
lab02D0 cp (iy+25)
    jr nz,lab02FC
    ld e,255
    rr b
    jr c,lab02E1
    rr b
    ccf 
    call lab0320
lab02E1 rr c
    jr c,lab02EC
    rr c
lab02E7 call lab0320
    jr lab02F0
lab02EC rlc e
    rlc e
lab02F0 ld a,3
    inc e
    jr z,lab0307
    dec e
    ld (iy+30),e
    res 1,(hl)
    ret 
lab02FC ld a,4
    xor (hl)
lab02FF ld (hl),a
lab0300 and 4
lab0302 ld a,2
    jr z,lab0307
lab0306 dec a
lab0307 ld (lab2484),a
    call lab032F
    call lab036A
    jr c,lab0313
    inc hl
lab0313 ld a,(hl)
    ld (lab24AB),a
    ld a,(lab2485)
    and a
lab031B jp nz,lab459C
lab031E jr lab0384
lab0320 push af
    rl e
    pop af
    ccf 
    rl e
    ret 


lab0328: 
	ld iy,lab24B0
    ld a,(lab2484)
lab032F 
	ld (iy+10),0
    res 3,(iy+4)
lab0337 
	bit 0,a
    jr nz,lab033F
lab033B ld (iy+10),1
lab033F ld (iy+28),0
    res 3,(iy+22)
    bit 1,a
    jr nz,lab034F
    ld (iy+28),1

lab034F:
	res 1,(iy+27)
    cp 3
    ret nz
lab0356 set 3,(iy+4)
    set 1,(iy+27)
    ret 

lab035F ld hl,(lab010E)
    ld de,(labBB10)
    and a
    sbc hl,de
    ret 

lab036A:
	ld a,(lab2484)
    ld hl,lab0116+1
    ld e,a
    rra 
    ret 

lab0373

db #AF,#18,#06,#3E,#FF,#21,#D8,#03,#E5,#21,#28,#04,#11 
db #BE,#03,#18,#0B ;380

lab0384:
 db #AF,#21,#57,#23,#E5,#21,#1E,#04,#11,#C6,#03,#D5
db #22,#1C,#04,#CD,#E7,#03,#22,#C3,#03,#A7,#21,#10,#BB,#20,#01,#EB ; #390 "....."...!.. ..
db #08,#CD,#F4,#03,#04,#00,#0E,#01,#CD,#F4,#03,#1D,#00,#A2,#39,#CD ; #3a0 ..............9.
db #F4,#03,#19,#00,#92,#24,#CD,#F4,#03,#F0,#03,#40,#6A,#C9,#CD,#F4 ; #3b0 .....$.....@j...
db #03,#12,#00,#B0,#24,#C9,#D5,#CD,#3B,#2B,#EB,#01,#12,#00,#C5,#ED ; #3c0 ....$...;+......
db #B0,#CD,#E7,#03,#C1,#D1,#ED,#B0,#2A,#BD,#39,#22,#A3,#39,#21,#AD ; #3d0 ........*.9".9!.
db #39,#01,#08,#00,#C3,#67,#24,#21,#84,#24,#CB,#46,#21,#B0,#24,#C8 ; #3e0 9....g$!.$.F!.$.
db #21,#C2,#24,#C9

lab03F4 pop ix
    ld c,(ix+0)
    inc ix
    ld b,(ix+0)
lab03FE inc ix
lab0400 ex af,af''
lab0401 and a
lab0402 jr z,lab040E
    ld e,(ix+0)
    inc ix
    ld d,(ix+0)
    jr lab0416
lab040E ld l,(ix+0)
    inc ix
    ld h,(ix+0)
lab0416 inc ix
    ex af,af''
    push ix
lab041B jp lab0428
lab041E ld a,(de)
    ldi
    dec hl
    ld (hl),a
    inc hl
    jp pe,lab041E
    ret 
lab0428 ldir
    ret 

LAB042B: 
	ld a,(lab0110)
    xor 128
    ld (lab0110),a
    call lab2551
    ld hl,(lab39AB)
    jr lab0458
lab043B push hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex (sp),hl
lab0441 ex de,hl
    ld hl,#000A
    add hl,de
    ld a,(lab0110)
    xor (hl)
    cp 128
    jr c,lab0457
    ld a,(hl)
    xor 128
    ld (hl),a
    and 127
	call nz,lab3764
lab0457 pop hl
lab0458 ld a,h
    or l
    jr nz,lab043B
    ret 

lab045D    
  db #FE,#03,#D8,#3D,#C9


; init_hw (its, crtc, ...)
init_hw:
lab0462:

    di
    
    ;copie gros bloc => réalisé dans le source
    ;ld de,#B897	; #70d7
    ;ld hl,#ADBF	; #65ff->70d7 , #adbf->b897 , #ad8 octets (2776)
    ;ld bc,#47C0
    ;lddr

    ld hl,buf6800
    ld bc,#0100
    call fill_zero
    
    ; Installs IT handler
    ld a,195 ; ''jp''
    ld hl,lab04BB+1
    ld (#38),a
    ld (#38+1),hl

	ld hl,#0100
    ld (0),a
    ld (1),hl
    
    im 1
    
    ; buffer 6600-66ff
    call fill_buffer_rot
    
    ld bc,#7F8D
    out (c),c
    
    ; config crtc
    ld hl,crtc_regs
    ld bc,#BC00
.loop out (c),c
    ld a,(hl)
    inc b
    out (c),a
    dec b
    inc hl
    inc c
    ld a,c
    cp 16
	jr nz,.loop
    
    ei
    ret 

    
org #04ab

crtc_regs:
	db #3F,#28,#2E,#8E,#26,#00,#19,#21,#00,#07,#0F,#0F,#30,#00,#30,#00

it_counter:
lab04BB: db #06

lab04BC:
it_manager:
    push AF
    push bc
    push hl
    ld hl,it_counter
    ld b,#f5		; vbl?
    in c,(c)
    rr c
    jr c,.vbl
    dec (hl)
    jr nz,.it_end
.vbl
	; Fin cycle de 6 Interruptions ou vbl
    push de
    ld (hl),6
    push ix
    push iy
    call lab0BB0
    pop iy
    pop ix   
	; Décrémente le compteur de trame si >0
	ld a,(frame_cnt)
    and a
	jr z,.nodec
    dec a
    ld (frame_cnt),a
.nodec:
	pop de
.it_end:
	pop hl
    pop bc
    pop af
    ei
    ret

; Rempli #6600-66ff avec un motif par 4 rotations de l
; 0,#10,#20,...#e0,#f0,#01,#11,#21...#2f,#02,#12,#22 ...
fill_buffer_rot:
lab04EB:
	ld hl,buf6600
.fill:
	ld a,l
    rrca 
    rrca 
    rrca 
    rrca 
    ld (hl),a
    inc l
    jr nz,.fill
    ret 

; ----------------- Palettes ----------------------

lab04F8 
	; Palette 8 (black)
    ld a,8
    call setPal
    ld hl,#3040
	ld de,#4057
lab0503 push hl
    push de
    call lab1CDE
    pop de
    pop hl
    ld h,l
    ld a,l
lab050C add a,24
    ld l,a
    cp 209
    jr c,lab0503
    ld hl,#3040
    ld d,e
    ld a,e
    add a,42
    ld e,a
    jr nc,lab0503
    ret 



; Pas de point d''entree?
    call getPal
    inc hl
    inc hl
    inc hl
    ld bc,#7F03
    ld e,1
    jp setCols
    
    
setPal:
lab052C:
    ; Applique une palette avec le meme bord que le fond
    call getPal
    ld bc,#7F10
    ld e,1
    call setCols
    dec hl
    ld e,4
    ld bc,#7f00

setCols:
lab053D:
    out (c),c
    inc c
    ld a,(hl)
    or #40
    out (c),a
    inc hl
    dec e
    jr nz,setCols
    ret 

getPal:
lab054A: 
    add a,a	; hl = a*4+palettes
    add a,a
    ld de,palettes
    ld l,a
    ld h,0
    add hl,de
    ret    

palettes:
lab0554: 
	db #14,#15,#0C,#03
    db #14,#0C,#1D,#03
    db #14,#18,#16,#03 
	db #14,#00,#05,#03
    db #14,#16,#0C,#0B
    db #14,#0C,#16,#0B
    db #14,#06,#0E,#0B 
	db #14,#0C,#15,#03
	;Black: (pal 8)
	db #14,#14,#14,#14
lab0578:
db #00,#04,#1C,#0A,#1C,#0A,#13,#07 


lab0580 cp 8
    jr c,lab058C
    sub 4
    cp 24
    jr c,lab058C
    sub 4
lab058C add a,a
    add a,a
    ld l,a
    ld h,0
lab0591 add hl,hl
    ld de,labB630
    add hl,de
    ex de,hl
    ret 

; Effacer buffer 6700-67ff
; Effectué régulierement, donc optimisation possible ici
clear6700
lab0598 
	ld hl,buf6700

; Effacer buffer h.l - h.#ff
; l multiple de 4
clear_buffer:
lab059b:
	xor a
.loop
	ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    jr nz,.loop
    ret 

; ----------------------------- RENDU ----------------------------------

; calcul des tiles a afficher
lab05A7:
	ld hl,(lab1C98)
    ld a,h
    sub 48
    ld c,a
    ld a,l
    sub h
    rra 
    rra 
    and 7
    
    dec a
    add a,a	
    ld e,a
    ld d,0
    ld hl,table_blitf
    add hl,de
    ld de,lab0598
    push de
	ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    ld hl,(lab1C9A)
    ld a,l
    sub h
    ex af,af''
    ld a,h
lab05CC sub 64
    ld b,a
    call lab084B
    ex af,af''
    ld b,102
    ld hl,buf6700
    ret 
   
; Table des fonctions de blit avec masquage
table_blitf: dw blit_1col,blit_2cols,blit_3cols,blit_4cols,blit_5cols,blit_6cols

; -------------- rendu des sprites ---------------------

; le blit consiste en cette operation de base:
; il y a un buffer pour le fond
macro APPLY_MASK_DE
    ld c,(hl)
    ld a,(bc)

	inc h				; #6800
    xor (hl)
    and #0F
    xor (hl)
    ld (de),a    
    inc e
    
    ld c,(hl)
    ld a,(bc)

   	dec h				; #6700    
    xor (hl)
    and #F0
    xor (hl)
        
    ld (de),a
mend


; CE: 
;  hl: #6700	; buffer
;  bc: #6600	; buffer source
;  de: destination (coordonées ecran, pair)

blit_1col: 
lab05e5: 
    ex af,af''
	APPLY_MASK_DE (void)
    inc l			; TODO: optim
    inc l
    inc l
    inc l
    inc l
    inc l
	
    ld bc,#ffff		; TODO: optim
	ex de,hl
 	add hl,bc
    ex de,hl
    
    ld b,102
    ld a,d	; ligne suivante
	add a,8
    ld d,a
    jr c,lab0610
    ex af,af''		; repetition plus bas 
    dec a
    jr nz,lab05E5
    ret 
    
lab0610 ld a,e	; bloc suivant
    add a,80
    ld e,a
    adc a,d
    sub e
    sub 64
    ld d,a
    ex af,af''
    dec a
    jr nz,lab05E5
    ret 

blit_2cols: 
lab061E 
	ex af,af''
    APPLY_MASK_DE (void)      
    inc l
    inc de    
    APPLY_MASK_DE (void)   
    
    inc l
    inc l
    inc l
    inc l
    inc l
    ld bc,#fffd
    ex de,hl
    add hl,bc
    ex de,hl
    ld b,102
    
    ld a,d	; ligne suivante
    add a,8
    ld d,a
    
    jr c,lab065B
    
    ex af,af''
    dec a
    jr nz,lab061E
    ret 
    
lab065B ld a,e
    add a,80
    ld e,a
    adc a,d
    sub e
    sub 64
    ld d,a
    ex af,af''
    dec a
    jr nz,lab061E
    ret 
    
blit_3cols: 
    
lab0669 
	ex af,af''

    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc l
    inc l
    inc l
lab06A5 ld bc,#fffb
    ex de,hl
    add hl,bc
    ex de,hl
    ld b,102
    ld a,d
    add a,8
    ld d,a
    jr c,lab06B8
    ex af,af''
    dec a
lab06B5 jr nz,lab0669
    ret 
lab06B8 ld a,e
    add a,80
    ld e,a
    adc a,d
    sub e
lab06BE sub 64
    ld d,a
    ex af,af''
    dec a
    jr nz,lab0669
    ret 

blit_4cols:    
lab06C6 
	ex af,af''
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc l
    inc l
    ld bc,#fff9
    ex de,hl
    add hl,bc
    ex de,hl
    ld b,102
    ld a,d
    add a,8
    ld d,a
    jr c,lab0727
    ex af,af''
    dec a
    jr nz,lab06C6
    ret 

lab0727 ld a,e
    add a,80
    ld e,a
    adc a,d
    sub e
    sub 64
    ld d,a
    ex af,af''
    dec a
    jr nz,lab06C6
    ret 
    
blit_5cols: 
lab0735 ex af,af''
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc de
    APPLY_MASK_DE (void)      
	inc l
    inc de
    APPLY_MASK_DE (void)      
    inc l
    inc l
lab0795 ld bc,#fff7
    ex de,hl
    add hl,bc
    ex de,hl
lab079B ld b,102
    ld a,d
    add a,8
    ld d,a
    jr c,lab07A8
    ex af,af''
    dec a
    jr nz,lab0735
    ret 
lab07A8 ld a,e
    add a,80
    ld e,a
    adc a,d
    sub e
    sub 64
    ld d,a
    ex af,af''
    dec a
    jr nz,lab0735
    ret 

blit_6cols: 
lab07b6:
    ex af,af''
    
repeat 6,cnt
	; lecture via 2 buffers (hl, et bc)
    APPLY_MASK_DE (void)         
    inc l    
    if (cnt!=6)
    inc de
    endif  
rend

    ; hl -= 11
    ld bc,-11
    ex de,hl
    add hl,bc
    ex de,hl
    
    ld b,#66 
    
    ld a,d	; ligne suivante
    add a,8
    ld d,a
    
    assert $==#834

lab0834 jr c,lab083C
    
    ex af,af''
    dec a
    jp nz,lab07B6
    ret 

lab083C 
	ld a,e
    add a,80
    ld e,a
    adc a,d
    sub e
    sub 64
    ld d,a
    
    ex af,af''
    dec a
    jp nz,lab07B6
    ret 

org #84b
lab084B 

db #78,#E6,#F8,#5F,#0F 
db #0F,#83,#87,#CB,#10,#87,#CB,#10,#87,#CB,#10,#CB,#39,#81,#5F,#88 ; #850 ............9._.
db #93,#F6,#C0,#57,#C9


; ----------------------------------


assert $==#865

; Effacement en colimacon
fancy_clear:
lab0865 ld e,3

lab0867:
    ld hl,#C000
    ld bc,#4000
    ld d,l
lab086E 
    ld a,(hl)
    rra 
    and 119
    rr d
    jr nc,lab0878
    or 8
lab0878 bit 3,d
    jr z,lab087E
    or 128
lab087E:
    ld d,(hl)
    and d
    ld (hl),a
    inc hl

	dec bc
    ld a,b
    or c
    jr nz,lab086E


	ld d,c
	ld bc,#4000
lab088B 
    dec hl
    ld a,(hl)
    rla 
    and 238
    rl d
    jr nc,lab0896
    or 16
lab0896 
    bit 4,d
    jr z,lab089C
    or 1
lab089C 
    ld d,(hl)
    and d
    ld (hl),a
    
    dec bc
    ld a,b
	or c
    jr nz,lab088B   
    
    dec e
    jr nz,lab0867   
    
    ; Clear (slow)
simple_clear:
	ld hl,#c000
    ld bc,#4000
    jp fill_zero



lab08B0 push de
    push af
lab08B2 ld a,248
    ld (lab05CC+1),a
    ld d,b
    ld a,b
    add a,h
    ld e,a
    ld (lab1C9A),de
    ld a,c
    ld b,c
    add a,l
    ld c,a
    ld (lab1C98),bc
    ld a,l
    rrca 
    rrca 
    and 7
    ld c,a
    pop af
    ld de,buf6700
    cp 3
    ccf 
    jr c,lab08DB
    cp 1
    jr nz,lab08DB
    inc d
lab08DB 
	ld a,h
    ex af,af''
	; clear 6800-68ff
	ld hl,buf6800
	call clear_buffer
    ex af,af''
    ex de,hl
    pop de
lab08E6 ex af,af''
    ld b,c
lab08E8 ld a,(de)
    ld (hl),a
    ex af,af''
    jr nc,lab08F2
    inc h
    ex af,af''
    ld (hl),a
    ex af,af''
    dec h
lab08F2 ex af,af''
    inc l
    inc de
    djnz lab08E8
    ld a,6
    sub c
    add a,l
    ld l,a
    ex af,af''
    dec a
    jr nz,lab08E6
lab0900 call lab05A7
    ld a,64
    ld (lab05CC+1),a
    ret 


texts_kb:
lab0909
	db #FF,''RETURN'' 
	db #FF,#83,''LOCK'',#FF,#83,''ESC'',#FF,#83,''TAB''
db #FF,#83,"DEL",#FF,#83,"CTRL",#FF,#83,"COPY"
db #FF,#83,"CLR",#FF,#81,"JOY",#FF,#E8,"F",#FF,#E8 
db "U",#FF,#E8,"D",#FF,#E8,"R",#FF,#E8,"L",#FF,#83,"SPACE"
db #FF,#5E,#60,#5F,#39,#36,#33,#8C,#2E,#61,#E6,#37,#38,#35,#31 ; #950 .^`_963..a.7851
db #32,#30,#E7,#5B,#8C,#5D,#34,#8D,#5C,#E5,#5E,#2D,#40,#50,#3B,#3A ; #960 20.[.]4.\.^-@P;:
db #2F,#2E,#30,#39,#4F,#49,#4C,#4B,#4D,#2C,#38,#37,#55,#59,#48,#4A ; #970 /.09OILKM,87UYHJ
db #4E,#EE,#36,#35,#52,#54,#47,#46,#42,#56,#34,#33,#45,#57,#53,#44 ; #980 N.65RTGFBV43EWSD
db #43,#58,#31,#32,#E2,#51,#E3,#41,#E1,#5A,#EA,#EB,#ED,#EC,#E9,#E9 ; #990 CX12.Q.A.Z......
db #58,#E4

; Table pour le test clavier
lab09A2:
 db #FF,#FD,#FB,#FE,#FF,#1F,#EF,#F7
 db #FE,#FF,#FF,#FF,#FD,#1F,#EF,#F3
 db #FF,#FF,#FF,#FF,#FF,#FF,#EF,#FF
 db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF
 db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF
 db #FF,#FF,#FF,#FF,#7F,#7F,#FF,#FF
 db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF
 db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF
 db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF
 db #FB,#F7,#FD,#FE,#EF,#FF,#FF,#FF

; Lecture clavier
lab09F2: 
    ld hl,lab6FC0
    call PPI_Start 
    ld c,64
lab09FA ld b,#F6
    out (c),c
    ld b,#F4
lab0A00 
    in a,(c)
    inc a
    jr nz,lab0A13	; Si un touche est enfoncée => gestionnaire
    inc hl
    inc c
    ld a,c
    and 15
    cp 10
    jr c,lab09FA
    call PPI_End
    inc a
    ret 
    
; clavier (menu)
lab0A13:
    dec a
    ld bc,#ff7f
lab0A17 rlc c
    inc b
    rra 
    jr c,lab0A17
    ld a,l
    sub 192
    add a,a
    add a,a
    add a,a
    add a,b
    ld b,a
    exx
    call PPI_End
    exx
    xor a
    ret 
    
lab0A2C ld a,b
    add a,82
    ld l,a
    adc a,9
    sub l
    ld h,a
    ld a,(hl)
    ret 
    
lab0A36 
	call lab09F2
    jr z,lab0A36
    ret 
lab0A3C call lab09F2
    scf
lab0A40 ret nz
lab0A41 ld a,b
    ld c,0
    cp 18
    ret z
    inc c
    cp 21
    ret z
    inc c
    xor a
    ret 
    
lab0A4E 
    ld de,lab09A2
    ld l,a
    ld h,0
    add hl,de
    ret 

lab0A56 
    call lab0A4E
    ld c,0
lab0A5B ld a,(hl)
lab0A5C ld b,255
lab0A5E cp 255
    jr z,lab0A78
lab0A62 inc b
    scf
    rra 
    jr c,lab0A62
    push hl
    push af
    ld a,c
    add a,b
    push bc
    ld b,a
    call lab0A2C
    call lab0AEC
    pop bc
    pop af
    pop hl
    jr lab0A5E
lab0A78 ld de,8
    add hl,de
    ld a,c
    add a,8
    ld c,a
    cp 80
    jr c,lab0A5B
    ret 
lab0A85 call lab0A4E
    push hl
    call lab0A36
    ld hl,lab6FC0
    ld e,255
    ld bc,10
    call lab2469
lab0A97 call lab09F2
    jr nz,lab0A97
    ld a,b
    cp 18
    jr z,lab0AC4
lab0AA1 ld a,c
    and (hl)
    cp (hl)
    ld (hl),a
    jr z,lab0A97
    call lab0A2C
    call lab0AEC
    ld hl,(lab4ABE)
    push hl
    ld a,165
    call lab4AC2
    call lab0A36
    pop hl
    ld (lab4ABE),hl
    ld a,192
    sub l
    cp 20
lab0AC2 jr nc,lab0A97
lab0AC4 exx
    ld hl,lab6FC0
lab0AC8 ld a,255
    ld b,10
lab0ACC cp (hl)
    inc hl
    jr nz,lab0AD7
    djnz lab0ACC
    exx
    ld a,18
    jr lab0AA1
lab0AD7 pop hl
    ld bc,8
    ld a,10
    ld de,lab6FC0
lab0AE0 ex af,af''
    ld a,(de)
    ld (hl),a
    inc de
    add hl,bc
    ex af,af''
    dec a
    jr nz,lab0AE0
    jp lab0A36
lab0AEC push af
    ld a,b
    cp 20
    jr z,lab0AF8
    cp 16
    ld a,130
    jr nc,lab0AFA
lab0AF8 ld a,131
lab0AFA call lab4AC2
    pop af
lab0AFE jp lab4AC2

; acquisition clavier.Analyse des 8 bits es 10 octets d''état
lab0B01 
	call PPI_Start 
    ld c,#40	; #40-#49
    ld a,255
    ld hl,lab09A2
    ex af,af''
.loop 
	ld b,#f6
    out (c),c
    ld b,#f4
    in e,(c)
    ld b,8
.loop8
	ld a,(hl)
 	or e
    cp 255
    ccf 
    rl d
    inc hl
    djnz .loop8
    
    ex af,af''
    and d
    ex af,af''
    inc c
    ld a,c
    cp #4a
    jr c,.loop
    ex af,af''
    rrca 
    rrca 
    rrca 
    jr PPI_End

; Attente clavier
lab0B2F call PPI_Start
    ld bc,#f648
    out (c),c
    ld b,#f4
    in a,(c)
    and 4
    jr PPI_End


; Debut de la manipulation du PPI, 
; désactivation des ITs
PPI_Start:    
lab0B3F di
lab0B40 ld bc,#f40e
    out (c),c
    ld bc,#f600
    ld a,#c0
    out (c),a
    out (c),c
    inc b
    ld a,146
    out (c),a
    ret
    
; Fin de la manipulation du PPI, 
; rétablissement des ITs
PPI_End:
lab0B54 ld bc,#f782
    out (c),c
    ld bc,#f600
    out (c),c
    ei
    ret 
    
lab0B60:
    ld hl,lab10A2
    ld d,0
lab0B65 ld e,(hl)
    inc hl
lab0B67 call lab0B71
    inc d
    ld a,d
    cp 11
    jr nz,lab0B65
    ret 
    
lab0B71 ld b,#f4
    out (c),d
    ld bc,#f600
    ld a,192
    out (c),a
    out (c),c
    ld a,128
    ld b,#f4
    out (c),e
    ld b,#f6
    out (c),a
    out (c),c
    ret 
    
lab0B8B
db #EE,#0E,#18,#0E,#4D 
db #0D,#8E,#0C,#DA,#0B,#2F,#0B,#8F,#0A,#F7,#09,#68,#09,#E1,#08,#61 ; #b90 ...../.....h...a
db #08,#E9,#07,#77,#07

lab0BA5
db #3A,#50,#10,#FE,#80,#C8,#06,#C3,#C3,#91,#0D ; #ba0 ...w.:P.........

; Appelé a chaque trame par l''interruption
lab0BB0:
	ld a,(lab1054)
    rla 
    ret nc
    call lab0C53
    xor a
    ld (lab1053),a
    ld a,63
    ld (lab10A9),a
    ld hl,lab1053
lab0BC4 
    ld b,(hl)
    call lab0C69
    jr c,lab0C1D
    call lab0E9B
    push hl
    pop ix
    bit 5,(hl)
    jr nz,lab0C1D
    ld iy,lab10A2
    ld e,a
    ld d,0
    push de
    sla e
    add iy,de
    ld hl,lab10AA
    pop de
    add hl,de
    ld a,(ix+8)
    ld (iy+0),a
    ld a,(ix+9)
    ld (iy+1),a
    ld b,d
    ld e,(ix+1)
    ld d,(ix+2)
    ex de,hl
    ld c,(ix+3)
lab0BFC add hl,bc
    ex de,hl
lab0BFE ld a,(de)
lab0BFF and 15
    jr z,lab0C0C
    add a,(ix+11)
    cp 16
    jr c,lab0C0C
    ld a,15
lab0C0C ld (hl),a
    ld a,(lab1053)
    ld b,a
    inc b
    ld a,255
    and a
lab0C15 rla 
    djnz lab0C15
    ld hl,lab10A9
    and (hl)
    ld (hl),a
lab0C1D ld hl,lab1053
lab0C20 ld a,2
    cp (hl)
    jp z,lab0C29
    inc (hl)
    jr lab0BC4
lab0C29 ld hl,lab1061
    ld a,8
    xor (hl)
    and 40
    jp nz,lab0B60
    ld a,(lab1054)
    rra 
    jp c,lab0B60
    ld hl,lab10A8
    ld iy,lab109A
    ld a,(iy+7)
    ld (hl),a
    inc hl
    ld a,(iy+0)
    and 1
    or (hl)
    and 247
    ld (hl),a
    jp lab0B60
lab0C53 xor a
    ld (lab1053),a
lab0C57 ld b,a
    call lab0C69
    call nc,lab0C71
	ld hl,lab1053
    ld a,(hl)
    cp 2
    ret z
    inc a
    ld (hl),a
    jr lab0C57
lab0C69 ld a,(lab1054)
    inc b
lab0C6D 
	rrca 
    djnz lab0C6D
    ret 

lab0C71 
ld hl,lab1053
lab0C74 ld l,(hl)
    ld de,lab105B
    ld h,0
    add hl,hl
    add hl,de
    ld (lab104E),hl
    ld e,(hl)
lab0C80 inc hl
    ld d,(hl)
    push de
    pop ix
    call lab0E9B
    push hl
lab0C89 pop iy
    bit 1,(hl)
    jp nz,lab0E33
    dec (iy+13)
    jr nz,lab0CA8
    call lab0E74
    bit 3,(iy+0)
    ret z
    ld iy,lab109A
    xor a
    ld (iy+3),a
lab0CA5 jp lab0D2A
lab0CA8 dec (iy+4)
    call z,lab0D46
    ld l,(iy+8)
    ld h,(iy+9)
lab0CB4 bit 7,(iy+0)
    jr z,lab0CE5
    ld a,1
    bit 7,(iy+12)
lab0CC0 jr z,lab0CC4
    ld a,255
lab0CC4 add a,(iy+15)
    ld (iy+15),a
    ld b,a
lab0CCB ld a,(iy+12)
    cp b
    jr nz,lab0CD8
    neg
    ld (iy+12),a
    neg
lab0CD8 ld e,(iy+14)
    ld d,0
    rlca 
    jr c,lab0CE4
lab0CE0 sbc hl,de
    jr lab0CE5
lab0CE4 add hl,de
lab0CE5 ld a,(iy+0)
    and 80
    cp 64
    jr nz,lab0D17
    ld e,(iy+17)
    ld d,(iy+18)
    add hl,de
    ld d,h
    ld e,l
    ld c,(iy+6)
    ld b,(iy+7)
    xor a
    sbc hl,bc
lab0D00 rla 
    xor (iy+0)
    and 1
    ex de,hl
    jr nz,lab0D17
    set 4,(iy+0)
    xor a
    ld (iy+15),a
    ld l,(iy+6)
    ld h,(iy+7)
lab0D17 
    ld (iy+8),l
    ld (iy+9),h
    bit 3,(iy+0)
    ret z
lab0D22 ld iy,lab109A
    dec (iy+4)
    ret nz
lab0D2A call lab0D46
    and a
    jr nz,lab0D34
    or (iy+3)
    ret nz
lab0D34 ld a,(hl)
    and 15
    bit 7,(iy+0)
    jr z,lab0D3F
    neg
lab0D3F add a,(iy+6)
    ld (iy+7),a
    ret 
lab0D46 

	ld l,(iy+1)
    ld h,(iy+2)
    ld e,(iy+3)
    xor a
    ld d,a
    add hl,de
    bit 7,(hl)
    jr nz,lab0D73
    bit 6,(hl)
    jr z,lab0D6D
    bit 2,(iy+0)
    set 2,(iy+0)
    jr z,lab0D70
    res 2,(iy+0)
    ld (iy+3),a
    jr lab0D70
lab0D6D inc (iy+3)
lab0D70 ld a,(iy+5)
lab0D73 ld (iy+4),a
    ret 
lab0D77 ld hl,lab1050
    ld a,(lab1053)
    ld e,a
    ld d,0
    add hl,de
    ld (hl),255
    ld b,a
lab0D84 inc b
    ld hl,lab1054
    xor a
    scf
lab0D8A rla 
    djnz lab0D8A
    ld b,a
    or (hl)
    ld (hl),a
    ret 
lab0D91 ld a,b
    and 63
    cp 63
    jr nz,lab0D9A
    ld a,255
lab0D9A ld c,a
    ld a,b
    rlca 
    rlca 
    and 3
    ld b,a
    cp 3
    jr z,lab0DEB
    ld hl,lab1050
    ld e,b
    ld d,0
    add hl,de
    ld a,(hl)
    cp c
    ret z
    cp 128
    ret z
    ld (hl),c
    ld a,c
    inc a
    jr z,lab0D84
    ld hl,lab124C
    sla e
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
lab0DC0 ld l,a
    ld e,c
    sla e
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    ld hl,lab1055
    ld e,b
    sla e
    add hl,de
    push hl
    ld a,b
    call lab0E9E
    ld d,h
    ld e,l
    ld b,a
    call lab0D84
    ld a,b
    pop hl
    pop bc
    ld (hl),c
    inc hl
    ld (hl),b
    ex de,hl
    set 1,(hl)
    ld hl,lab1054
    xor (hl)
    ld (hl),a
    ret 
lab0DEB ld h,0
    ld l,c
    add hl,hl
    ld d,h
    ld e,l
    add hl,hl
    add hl,de
    ld de,lab1111
    add hl,de
    ld a,3
lab0DF9 ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de
    push hl
    dec a
lab0E00 call lab0E9E
    pop de
    push hl
    ex de,hl
    and a
    jr nz,lab0DF9
lab0E09 ld hl,lab1054
    ld a,7
    or (hl)
    ld (hl),a
lab0E10 ld hl,lab1050
    ld bc,#0380
    ld a,b
lab0E17 ld (hl),c
    inc hl
    djnz lab0E17
    ld hl,lab1055
lab0E1E pop de
    pop bc
    ld (hl),c
    inc hl
lab0E22 ld (hl),b
    inc hl
    ex de,hl
    set 1,(hl)
    ex de,hl
    dec a
    jr nz,lab0E1E
    ld hl,lab1054
    ld a,248
lab0E30 and (hl)
    ld (hl),a
    ret 
lab0E33 call lab0E4C
    ld bc,#0203
lab0E39 call lab0F84
    ld (iy+10),d
lab0E3F ld (iy+11),e
    inc ix
    call lab0F93
    inc ix
    jp lab0E74
lab0E4C ld hl,(lab104E)
    ld de,#fffa
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de
    pop ix
lab0E59 ret 
lab0E5A call lab0E4C
lab0E5D inc ix
    jr lab0E6F
lab0E61 inc ix
    cp (ix+0)
    jr z,lab0E5A
    dec a
    cp (ix+0)
    jp z,lab0D77
lab0E6F call lab0F93
    inc ix
lab0E74 res 4,(iy+0)
    ld a,(ix+0)
    inc a
    jp z,lab0E61
    ld bc,lab0307
    call lab0F84
    ld c,d
    ld hl,lab10B0
    ld d,0
    add hl,de
    ld a,(hl)
    ld (iy+13),a
    xor a
    cp c
    jr nz,lab0EAB
    set 5,(iy+0)
    jp lab0F70
lab0E9B ld a,(lab1053)
lab0E9E ld hl,lab1061
    and a
    ret z
    ld de,#0013
    ld b,a
lab0EA7 add hl,de
    djnz lab0EA7
    ret 
lab0EAB res 5,(iy+0)
    ld a,(iy+10)
    add a,c
    ld bc,#ff0c
lab0EB6 inc b
    sub c
    jr nc,lab0EB6
    add a,c
    add a,a
    ld e,a
    ld d,0
    ld hl,lab0B8B
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld a,(hl)
    inc b
    jr lab0ED5
lab0ECD srl a
    rr c
    srl d
    rr e
lab0ED5 djnz lab0ECD
    ld b,a
    ld a,(iy+0)
    and 66
    cp 64
    jr nz,lab0EE9
lab0EE1 ld (iy+6),e
    ld (iy+7),d
    jr lab0EEF
lab0EE9 ld (iy+8),e
    ld (iy+9),d
lab0EEF bit 7,(iy+0)
    jr z,lab0F1C
    ex de,hl
    and a
    sbc hl,bc
    srl l
    srl l
    ld a,(iy+16)
lab0F00 and a
lab0F01 jr z,lab0F15
    ld h,a
    ld a,l
    jp m,lab0F10
lab0F08 rrc h
    jr c,lab0F14
lab0F0C add a,a
    jr lab0F08
lab0F0F rra 
lab0F10 rrc h
lab0F12 jr nc,lab0F0F
lab0F14 ld l,a
lab0F15 ld (iy+14),l
    xor a
    ld (iy+15),a
lab0F1C ld a,(iy+0)
    bit 6,a
    jr z,lab0F66
    bit 1,a
    jr z,lab0F2D
lab0F27 set 4,(iy+0)
    jr lab0F66
lab0F2D ld l,(iy+6)
    ld h,(iy+7)
    ld e,(iy+8)
    ld d,(iy+9)
    rr (iy+0)
    xor a
    sbc hl,de
    rl (iy+0)
    ld c,(iy+13)
    ld e,128
    ld b,8
lab0F4B ld a,e
    and c
    jr nz,lab0F53
    rrc e
    djnz lab0F4B
lab0F53 rrca 
    jr c,lab0F5C
    sra h
    rr l
    jr lab0F53
lab0F5C ld (iy+17),l
    ld (iy+18),h
    res 4,(iy+0)
lab0F66 ld (iy+3),0
    ld a,(iy+5)
    ld (iy+4),a
lab0F70 res 1,(iy+0)
    push ix
    pop de
    inc de
    ld hl,(lab104E)
    ld (hl),e
    inc hl
    ld (hl),d
    ret 

lab0f7f: 
 	ld bc,#040f
    jr lab0F87
lab0F84 ld d,(ix+0)
lab0F87 ld a,d
    and c
    ld e,a
    ld a,c
    cpl 
    and d
    ld d,a
lab0F8E rrc d
    djnz lab0F8E
    ret 
lab0F93 ld bc,#040F
lab0F96 call lab0F84
    ld a,2
    and (iy+0)
    ld (iy+0),a
    bit 2,d
    jr z,lab0FA9
    set 6,(iy+0)
lab0FA9 ld a,3
    and d
    jr z,lab0FDC
    push de
    dec a
    ld hl,lab10AD
    ld e,a
    ld d,0
    add hl,de
    ld d,(hl)
    call lab0F7F
    ld (iy+12),e
    ld a,d
    cp e
    ld a,0
    jr z,lab0FD4
    jr nc,lab0FCB
    ld a,d
    ld d,e
    ld e,a
    ld a,128
lab0FCB rr e
    jr c,lab0FD3
    rrc d
    jr lab0FCB
lab0FD3 or d
lab0FD4 ld (iy+16),a
    set 7,(iy+0)
    pop de
lab0FDC ld hl,lab10BE
lab0FDF ld d,0
    add hl,de
    ld d,(hl)
    call lab0F7F
    ld (iy+5),d
    ld (iy+4),d
    call lab103F
lab0FEF ld a,(lab1053)
    and a
    jr nz,lab0FF9
    res 3,(iy+0)
lab0FF9 bit 7,(ix+0)
lab0FFD ret z
    inc ix
    and a
    ret nz
lab1002 set 3,(iy+0)

lab1006:
	push iy
    ld iy,lab109A
    ld e,(ix+0)
    ld a,192
    and e
    rlca 
    ld (iy+0),a
    ld a,15
    and e
    ld e,a
    ld hl,lab10B8
    rlc e
    ld d,0
    add hl,de
    ld d,(hl)
    call lab0F7F
    ld (iy+4),d
    ld (iy+5),d
    inc hl
    ld a,(hl)
    ld (iy+6),a
    call lab103F
    add a,(hl)
    ld (iy+7),a
    xor a
    ld (iy+3),a
    pop iy
    ret 
    
lab103F ld hl,lab10CE
    ld d,0
    add hl,de
    ld e,(hl)
    add hl,de
    ld (iy+1),l
    ld (iy+2),h
    ret 


lab104E
	db #00,#00 

org #1050

; Some variables...
lab1050: db #FF,#FF,#FF
lab1053: db #00
lab1054: db #C7
lab1055: db #00,#00,#00,#00,#00,#00
lab105b: db #00,#00,#00,#00,#00 

db #00 ; 1060
lab1061: 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1070
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1080
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00

; 8 octets
lab109a:
	db #00,#00,#00,#00,#00,#00,#00,#00


org #10a2

lab10A2: db #00,#00,#00,#00,#00,#00
lab10a8: db #00
lab10A9: db #3F
lab10AA: db #00,#00,#00
lab10AD: db #81,#42,#48 

lab10b0:
db #01,#02,#04,#06,#08,#0C,#10,#20

lab10B8:
db #12,#14,#10,#0C,#36,#00
lab10BE:
db #22,#10 
db #42,#11,#24,#12,#41,#16,#25,#13,#34,#17,#26,#44,#29 ;#10c0
lab10cd: db #18

lab10ce: db #10,#09 
db #0F,#10,#12,#1D,#20,#2A,#2C,#2E,#04,#05,#07,#09,#0A,#0B,#8C,#0C ; #10d0
db #08,#04,#01,#80,#08,#00,#0C,#00,#07,#00,#04,#00,#02,#00,#01,#80 ; #10e0
db #0C,#0A,#08,#45,#02,#00,#00,#04,#00,#00,#06,#00,#00,#09,#00,#0C ; #10f0
db #00,#40,#08,#0A,#0C,#0C,#0B,#0A,#09,#08,#07,#06,#05,#04,#03,#02 ; #1100
db #81
lab1111 db #4A,#13,#4A,#13,#4A,#13,#BE,#13,#D2,#13,#E7,#13,#FC,#13,#18 ; #1110
db #14,#34,#14,#91,#11,#F4,#11,#28,#12,#34,#12,#3C,#12,#44,#12,#42 ; #1120
db #14,#55,#14,#66,#14,#88,#11,#7B,#11,#69,#11,#47,#11,#51,#11,#5E ; #1130
db #11,#77,#14,#81,#14,#8E,#14,#A0,#7C,#30,#3E,#FF,#7B,#5E,#FE,#FF ; #1140
db #FF,#B8,#7C,#31,#3E,#FF,#7B,#5E,#CE,#FF,#52,#AE,#FF,#FF,#C3,#7C ; #1150 ..|1>.{^..R....|
db #30,#3E,#FF,#FB,#44,#5E,#CE,#FF,#FF,#93,#00,#95,#6A,#62,#6A,#7D ; #1160 0>..D^......jbj}
db #6D,#FF,#82,#C0,#15,#FF,#03,#8D,#96,#FF,#FF,#90,#23,#F5,#CA,#C2 ; #1170 m...........#...
db #CA,#DD,#CD,#05,#5D,#6E,#FF,#FF,#60,#03,#07,#06,#05,#A5,#B6,#FF ; #1180 ....]n..`.......
db #FF,#90,#41,#31,#91,#95,#97,#84,#94,#FF,#22,#96,#06,#CE,#06,#FF ; #1190 ..A1......".....
db #41,#51,#B1,#B5,#B7,#A4,#B4,#FF,#22,#B6,#06,#CE,#06,#FF,#41,#59 ; #11a0 AQ......".....AY
db #B9,#BD,#BF,#AC,#BC,#FF,#22,#BE,#06,#F6,#06,#FF,#41,#31,#91,#95 ; #11b0 ......".....A1..
db #97,#84,#94,#FF,#22,#96,#06,#CE,#06,#FF,#41,#CA,#CD,#CF,#BC,#CC ; #11c0 ....".....A.....
db #FF,#22,#CE,#06,#EE,#06,#FF,#41,#C9,#F1,#F3,#03,#C9,#F1,#F3,#03 ; #11d0 .".....A........
db #07,#C9,#F1,#F3,#03,#FF,#55,#F2,#CA,#EA,#DA,#B2,#CA,#BA,#92,#B2 ; #11e0 ......U.........
db #A4,#6A,#FF,#00,#62,#08,#36,#56,#6E,#7E,#86,#7E,#6E,#56,#36,#56 ; #11f0 .j..b.6Vn~.~nV6V
db #6E,#7E,#86,#7E,#6E,#56,#5E,#7E,#96,#A6,#AE,#A6,#96,#7E,#36,#56 ; #1200 n~.~nV^~.....~6V
db #6E,#7E,#86,#7E,#6E,#56,#6E,#8E,#A6,#B6,#BE,#B6,#A6,#8E,#96,#7E ; #1210 n~.~nVn........~
db #6E,#56,#6E,#7E,#86,#8E,#FF,#00,#93,#05,#34,#94,#54,#B4,#6C,#CC ; #1220 nVn~......4.T.l.
db #7C,#DC,#FF,#00,#60,#51,#32,#B5,#55,#32,#FF,#FF,#C0,#51,#92,#CD ; #1230 |...`Q2.U2...Q..
db #95,#92,#FF,#FF,#60,#51,#92,#6D,#95,#92,#FF,#FF
lab124c: db #76,#12,#64,#12 ; #1240 ....`Q.m....v.d.
db #52,#12,#4E,#13,#64,#13,#74,#13,#88,#13,#94,#13,#A2,#13,#A7,#13 ; #1250 R.N.d.t.........
db #AC,#13,#B7,#13,#82,#12,#8F,#12,#A2,#12,#C5,#12,#E1,#12,#F0,#12 ; #1260 ................
db #04,#13,#13,#13,#1C,#13,#47,#13,#41,#13,#5C,#13,#30,#13,#25,#13 ; #1270 ......G.A.\.0.%.
db #3A,#13,#C0,#0E,#34,#4E,#5C,#6C,#74,#6C,#5E,#44,#26,#FF,#FF,#D0 ; #1280 :...4N\ltl^D&...
db #0E,#6E,#96,#6E,#56,#FF,#01,#34,#36,#FF,#0E,#7C,#6C,#54,#6E,#47 ; #1290 .n.nV..46..|lTnG
db #FF,#FF,#C3,#03,#94,#8C,#94,#8C,#FF,#26,#76,#FF,#61,#6A,#72,#8A ; #12a0 .........&v.ajr.
db #FF,#22,#8A,#FF,#03,#94,#8C,#74,#8C,#94,#AC,#A4,#94,#FF,#26,#8F ; #12b0 .".....t......&.
db #FF,#22,#80,#FF,#FF,#60,#02,#6C,#96,#04,#96,#8C,#96,#94,#96,#FF ; #12c0 ."...`.l........
db #0F,#8C,#FF,#01,#AA,#FF,#41,#B2,#FF,#22,#B4,#FF,#02,#04,#96,#FF ; #12d0 ......A.."......
db #FF,#A8,#0F,#35,#35,#55,#6D,#6E,#04,#55,#56,#04,#35,#36,#FF,#FF ; #12e0 ...55Umn.UV.56..
db #90,#0E,#0C,#36,#24,#35,#45,#4E,#44,#4D,#35,#26,#34,#25,#0D,#FF ; #12f0 ...6$5ENDM5&4%..
db #0E,#27,#FF,#FF,#40,#02,#36,#0C,#24,#36,#0C,#24,#34,#4C,#0C,#4C ; #1300 .''..@.6.$6.$4L.L
db #36,#FF,#FF,#F0,#67,#10,#F6,#06,#16,#07,#FF,#FF,#27,#50,#51,#BB ; #1310 6...g.......''PQ.
db #FF,#5D,#97,#FF,#FF,#03,#CA,#44,#F0,#0F,#FF,#8C,#01,#0C,#FF,#FF ; #1320 .].....D........
db #A0,#40,#30,#6C,#31,#6C,#41,#6C,#FF,#FF,#B3,#47,#10,#43,#00,#FF ; #1330 .@0l1lAl...G.C..
db #FF,#00,#86,#82,#12,#FF,#FF,#03,#86,#41,#11,#03,#FF,#FF,#D3,#29 ; #1340 .........A.....)
db #31,#51,#01,#41,#29,#01,#31,#19,#01,#29,#41,#01,#FF,#00,#F3,#EB ; #1350 1Q.A).1..)A.....
db #E3,#DB,#FF,#FF,#D3,#09,#31,#51,#00,#41,#29,#00,#31,#19,#00,#29 ; #1360 ......1Q.A).1..)
db #41,#00,#FF,#00,#D3,#09,#F3,#EB,#E3,#DB,#EB,#E3,#DB,#D3,#E3,#DB ; #1370 A...............
db #D3,#CB,#DB,#D3,#CB,#C3,#FF,#00,#D3,#09,#BB,#A3,#8B,#73,#5B,#43 ; #1380 .............s[C
db #2B,#23,#FF,#00,#D3,#09,#13,#33,#53,#73,#93,#B3,#D3,#DB,#E3,#EE ; #1390 +#.....3Ss......
db #FF,#00,#78,#05,#33,#FF,#FF,#60,#25,#33,#FF,#FF,#D3,#60,#34,#6A ; #13a0 ..x.3..`%3...`4j
db #FF,#09,#01,#BA,#BA,#FF,#FF,#90,#44,#10,#43,#00,#FF,#FF,#90,#41 ; #13b0 ........D.C....A
db #0C,#36,#FF,#02,#35,#35,#35,#45,#35,#45,#FF,#41,#56,#FF,#21,#57 ; #13c0 .6..555E5E.AV.!W
db #FF,#FF,#90,#41,#0C,#6E,#FF,#02,#6D,#6D,#6D,#7D,#6D,#7D,#FF,#41 ; #13d0 ...A.n..mmm}m}.A
db #D5,#FF,#21,#D2,#D7,#FF,#FF,#90,#41,#0C,#E6,#FF,#02,#B5,#B5,#B5 ; #13e0 ..!.....A.......
db #C5,#B5,#C5,#FF,#41,#8D,#FF,#21,#8A,#8F,#FF,#FF,#63,#02,#B2,#BA ; #13f0 ....A..!....c...
db #CC,#34,#34,#6A,#5A,#52,#6A,#92,#8A,#94,#C2,#CA,#DC,#44,#44,#A2 ; #1400 .44jZRj......DD.
db #92,#8A,#92,#8A,#7A,#6E,#FF,#FF,#C0,#03,#92,#8A,#94,#34,#54,#6A ; #1410 ....zn.......4Tj
db #5A,#52,#6A,#92,#8A,#94,#8A,#92,#A4,#44,#64,#A2,#92,#8A,#92,#8A ; #1420 ZRj......Dd.....
db #7A,#6D,#FF,#FF,#30,#02,#04,#36,#0E,#56,#36,#46,#1E,#64,#54,#47 ; #1430 zm..0..6.V6F.dTG
db #FF,#FF,#33,#43,#09,#33,#FF,#08,#36,#56,#5E,#66,#6C,#0C,#04,#FF ; #1440 ..3C.3..6V^fl...
db #02,#32,#37,#FF,#FF,#F0,#08,#04,#96,#86,#7E,#76,#6C,#06,#FF,#41 ; #1450 .27.......~vl..A
db #94,#FF,#3E,#97,#FF,#FF,#C0,#22,#04,#96,#86,#7E,#76,#6C,#06,#FF ; #1460 ..>...."...~vl..
db #41,#6C,#FF,#2E,#6F,#FF,#FF,#A0,#7B,#F0,#A6,#5E,#FF,#7C,#3E,#FF ; #1470 Al..o...{..^.|>.
db #FF,#B8,#7B,#C0,#A6,#5E,#FF,#7C,#3E,#FF,#52,#27,#FF,#FF,#C3,#FC ; #1480 ..{..^.|>.R''....
db #02,#C0,#A6,#5E,#FF,#FB,#44,#3E,#FF,#FF


;db #D9,#0A,#A6,#EB,#B6,#02 ; #1490 ...^..D>........
; dessin des elements  du decor
MACRO APPLY_MASK
    ld a,(bc)
    and (hl)
    ex de,hl
    or (hl)
    ld (bc),a
    inc b
    ld a,(bc)
    or (hl)
    ex de,hl
    and (hl)
    ld (bc),a
    dec b
MEND

draw_1col:
lab149A: 
    exx
    APPLY_MASK (void)    
    inc hl
    inc de

    ld a,c
    add a,6
    ld c,a
    
    inc hl
    inc de
    inc hl
    inc de
    exx
    djnz lab149A
    ret 
    
    
draw_2cols:
lab14B5:
    exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    ld a,c
    add a,5
    ld c,a
    inc hl
    inc de
    exx
    djnz lab14B5
    ret 

draw_3cols:
lab14DD
    exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)    
    inc c
    inc hl
    inc de
    APPLY_MASK (void)   
    inc hl
    inc de
    ld a,c
    add a,4
    ld c,a
    exx
    djnz lab14DD
    ret 

draw_1col_b:
lab1512 exx

	APPLY_MASK (void)    
    
    inc hl
    inc de
    ld a,c
    add a,6
    ld c,a
    inc hl
    inc de
    inc hl
    inc de
    inc hl
    inc de
    exx
    djnz lab1512
    ret 

draw_2cols_b:
lab152F exx
    
    APPLY_MASK (void)    
    
    inc c
    inc hl
    inc de
    
    APPLY_MASK (void)    
    
    inc hl
    inc de
    ld a,c
    add a,5
    ld c,a
    inc hl
    inc de
    inc hl
    inc de
lab1555 exx
    djnz lab152F
    ret 

draw_3cols_b:
lab1559 exx
    APPLY_MASK (void)    
    inc c
    inc hl
    inc de

    APPLY_MASK (void)    
    inc c
    inc hl
    inc de

    APPLY_MASK (void)    
    inc hl
    inc de
    
    ld a,c
    add a,4
    ld c,a
    inc hl
    inc de
    exx
    djnz lab1559
    ret 


draw_4cols_b:
lab1590 exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    inc c
    inc c
    inc c
    exx
    djnz lab1590
    ret 
draw_1col_c:
lab15D3:
    exx
    APPLY_MASK (void)
    inc hl
    inc de
    ld a,c
    add a,6
    ld c,a
    inc hl
    inc de
    inc hl
    inc de
    inc hl
    inc de
    inc hl
    inc de
    exx
    djnz lab15D3
    ret 
draw_2cols_c:    
lab15F2 exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    ld a,c
    add a,5
    ld c,a
    
    inc hl
    inc de
    inc hl
    inc de
    inc hl
    inc de
    exx
    djnz lab15F2
    ret 

draw_3cols_c:
lab161E exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    ld a,c
    add a,4
    ld c,a
    inc hl
    inc de
    inc hl
    inc de
    exx
    djnz lab161E
    ret 


draw_4cols_c:
lab1657 exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    inc c
    inc c
    inc c
    inc hl
    inc de
    exx
    djnz lab1657
    ret 
    
draw_5cols_c:
lab169C exx
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc c
    inc hl
    inc de
    APPLY_MASK (void)
    inc hl
    inc de
    inc c
    inc c
    exx
    djnz lab169C
    ret 
   

lab16ED db #00

lab16EE 
    push de
    push bc
    push hl
    ld a,(lab16ED)
    call lab16FE
    pop hl
    pop bc
    pop de
    ret 
    
lab16FB ld (lab16ED),a
lab16FE 
	push af
	ld hl,labB898
    ld bc,#128
    call fill_zero
    xor a
    ld (lab1AC0),a
    dec a
    ld (lab1941),a
    pop af
    and a
    ret z
    ld de,labB9BF
    ld hl,labB897
    ld bc,#20
    lddr
lab171E 
    sub 6
	jr z,lab172C
    ld hl,labB877
    ld bc,#0030
    lddr
    jr lab171E
lab172C 
	ld hl,labB847
    ld bc,#48
    lddr
    ret

lab1735:
    ld hl,(lab1C98)
    ld a,h
    rra 
    rra 
    ld c,a
    and 62
    exx
    ld l,a
    ld h,106
    exx
    ld a,l
    sub h
    rra 
    rra 
    and 7
    sub 2
    ld de,buf6800
    rr c
    jr nc,lab1767
    ld iy,lab19B6
    ld ix,lab1A67
    ld hl,lab1A31
    call lab178D
    cp 255
    ret z
    sub 1
    jr lab1778
lab1767 ld iy,lab19C5
    ld ix,lab1A80
    ld hl,lab1A04
    call lab178D
    inc e
    sub 2
lab1778 jr nc,lab1767
    inc a
    ret nz
    ld iy,lab19B6
lab1780 ld ix,lab1A6C
lab1784 ld hl,lab1A3E
    ld (lab1848+1),hl
    exx
    jr lab179F
lab178D ld (lab1848+1),hl
    push de
    push af
    exx
    push hl
    call lab179F
    pop hl
    inc l
    inc l
lab179A exx
    pop af
lab179C pop de
    inc e
    ret 
lab179F ld de,(lab1C9A)
    ld a,e
    sub d
    ld e,a
    ld a,(hl)
    and a
    jr z,lab17F6
    ld a,d
    sub (hl)
    ld d,a
    jr nc,lab17F9
    inc hl
    ld c,56
    bit 2,(hl)
lab17B4 jr z,lab17B8
    ld c,74
lab17B8 add a,c
    jr nc,lab17C6
    add a,a
    call lab192F
    exx
lab17C0 ld a,d
    neg
    jp lab17E2
lab17C6 neg
    cp e
    jr nc,lab17F6
    ld b,a
lab17CC neg
    add a,e
    ld e,a
    ld a,b
    call lab19B4
    ld a,(hl)
    exx
    call lab197D
    exx
    ld a,56
    bit 2,(hl)
    jr z,lab17E2
    ld a,74
lab17E2 cp e
    jr nc,lab17F3
    ld b,a
    neg
    add a,e
    ex af,af''
    ld a,b
    call lab19B2
    ex af,af''
    ld d,0
    jr lab17FB
lab17F3 ld a,e
    jp (ix)
lab17F6 ld a,e
    jp (iy)
lab17F9 ld a,e
    inc hl
lab17FB ld b,a
    dec hl
    ld a,l
lab17FE add a,a
    add a,a
lab1800 add a,4
lab1802 cp 0
    jr c,lab1812
    ld e,0
    jr nz,lab180C
    ld e,5
lab180C sub 4
lab180E add a,0
    jr lab181A
lab1812 add a,4
    neg
lab1816 add a,0
lab1818 ld e,8
lab181A neg
    add a,11
    ld c,a
lab181F ld a,e
    ld (lab186D+1),a
    ld a,(hl)
    add a,d
    inc hl
    sub c
    jr nc,lab1841
    add a,11
    jr nc,lab1844
    ld e,a
    sub 11
    add a,b
    jr c,lab1836
    ld a,b
    jr lab1863
lab1836 push af
    sub b
    neg
lab183A call lab1863
    pop af
    ret z
lab183F jp (iy)

lab1841 ld a,b
    jp (iy)
lab1844 add a,b
    jr c,lab184B
    ld a,b

lab1848 jp 0
; Dessins de bords de terrain
lab184B push af
    sub b
lab184D neg
    call lab1848
    pop af
    ret z
    sub 11
    ld e,0
    jr nc,lab185E
    add a,11
    jr lab1863
lab185E push af
    ld a,11
    jr lab183A
lab1863 
    push de
    exx
    pop hl
    
    ld h,0
    add hl,hl
    add hl,hl
    ;ld bc,lab18D3
    ld bc,lab187B
lab186D jr lab1877

    ld bc,lab18A7
    jr lab1877

    ld bc,lab18D3
    ;ld bc,lab187B
lab1877 
	add hl,bc
    exx
    jp (ix)
    
lab187B
db #00,#40,#00,#00
db #00,#70,#00,#00
db #04,#74,#00,#00
db #07,#77,#00,#00
db #07,#37,#00,#40
db #07,#07,#00,#70
db #03,#03,#04,#74
db #00,#00,#07,#77
db #00,#00,#07,#37
db #00,#00,#07,#07
db #00,#00,#03,#03

lab18A7:
db #00,#00,#03,#03
db #00,#00,#0F,#0F
db #00,#00,#1F,#1F
db #00,#00,#5F,#1F
db #03,#03,#5C,#1C
db #0F,#0F,#50,#10
db #1F,#1F,#40,#00
db #5F,#1F,#00,#00
db #5C,#1C,#00,#00
db #50,#10,#00,#00
db #40,#00,#00,#00

lab18D3:
db #00,#40,#03,#03,#00,#70,#0F,#0F,#04,#74,#1F,#1F,#07 
db #77,#5F,#1F,#07,#37,#5C,#1C,#07,#07,#50,#10,#03,#03,#40,#00,#00 ; #18e0 w_..7\...P...@..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#2A ; #18f0 ...............*
db #E8,#19,#01,#0A,#00,#09,#0E,#10,#3A,#C1,#1E,#1F,#E5,#30,#02,#09 ; #1900 ........:....0..
db #E3,#09,#1F,#30,#03,#A7,#ED,#42,#11,#A7,#18,#CD,#23,#19,#E1,#23 ; #1910 ...0...B....#..#
db #11,#7D,#18,#3E,#04,#ED,#A0,#23,#13,#13,#13,#3D,#20,#F7,#C9,#F5 ; #1920 .}.>...#...= ...
db #7E,#D9,#CD,#7D,#19,#F1,#87,#F5,#85,#6F,#8C,#95,#67,#F1,#D0,#24 ; #1930 ~..}.....o..g..$
db #C9

lab1941:
db #00,#3A,#41,#19,#A7,#21,#98,#B8,#C8,#E5,#C5,#D5,#01,#28,#01 ; #1940 ..:A..!.......(.
db #CD,#67,#24,#D1,#C1,#E1,#AF,#32,#41,#19,#C9,#CB,#47,#20,#E3,#6F ; #1950 .g$....2A...G .o
db #3A,#41,#19,#A7,#CC,#EE,#16,#3A,#C0,#1A,#AD,#17,#21,#98,#B8,#D0 ; #1960 :A.....:....!...
db #3A,#C0,#1A,#EE,#80,#32,#C0,#1A,#06,#4A,#C3,#9C,#1A,#CB,#57,#20 ; #1970 :....2...J....W
db #DA,#F5,#CD,#8F,#19,#08,#F1,#CD,#C1,#1A,#08,#D0,#C3,#9A,#1A,#4F ; #1980 ...............O
db #2A,#44,#3C,#E6,#03,#47,#04,#3E,#01,#0F,#10,#FD,#47,#A6,#20,#08 ; #1990 *D<..G.>....G. .
db #CB,#11,#D0,#78,#B6,#77,#37,#C9,#CB,#11,#3F,#D0,#78,#2F,#A6,#77 ; #19a0 ...x.w7...?.x/.w
db #37,#C9,#DD,#E9,#FD,#E9

lab19B6 exx
    ld b,a
    ex de,hl
    ld e,0
lab19BB ld (hl),e
    ld a,l
    add a,6
    ld l,a
    djnz lab19BB
    ex de,hl
    exx
    ret


lab19C5 
    exx
    ld b,a
    ex de,hl
    ld e,0
lab19CA 
    ld (hl),e
    inc l
    ld (hl),e
    ld a,l
    add a,5
    ld l,a
    djnz lab19CA
    ex de,hl
    exx
    ret 
    
lab19D6 
    ld c,a
    add a,a
    add a,c
    add a,a
    add a,a
    add a,a ; ax24
    ld l,a
    ld h,0
    add hl,hl ; hl=ax48
    ld de,labB4B0
    add hl,de
    ld (lab19E8),hl
    ret
    

lab19E8: db #E0,#B4

lab19EA push af
    exx
    ld a,(hl)
    or 250
    inc a
    exx
    jr z,lab19FF
    ld a,c
    ld bc,(lab19E8)
    add a,c
    ld c,a
    adc a,b
    sub c
    ld b,a
    pop af
    ret 

lab19FF ld bc,labB600
    pop af
    ret 

lab1A04 ld b,a
    ld a,d
    bit 7,(hl)
    exx
    ld c,0
    jr z,lab1A0F
    ld c,16
lab1A0F call lab19EA
    and 15
    add a,a
    ld h,0
lab1A17 ld l,a
    exx
lab1A19 exx
    push hl
    add hl,bc
    ld a,(hl)
    ld (de),a
    inc hl
    inc e
    ld a,(hl)
    ld (de),a
    ld a,e
    add a,5
    ld e,a
    pop hl
    ld a,l
    add a,2
    and 31
    ld l,a
    exx
    djnz lab1A19
    ret 

lab1A31 ld b,a
    ld a,d
    bit 7,(hl)
    exx
    ld c,1
    jr z,lab1A49
    ld c,17
    jr lab1A49
lab1A3E ld b,a
    ld a,d
    bit 7,(hl)
    exx
    ld c,0
    jr z,lab1A49
    ld c,16
lab1A49 call lab19EA
    and 15
    add a,a
    ld h,0
    ld l,a
    exx
lab1A53:
    exx
    push hl
    add hl,bc
    ld a,(hl)
    ld (de),a
    ld a,e
    add a,6
    ld e,a
    pop hl
    
    ld a,l
    add a,2
    and 31
    ld l,a
    exx
    djnz lab1A53
    ret 
lab1A67:    
     exx
    inc hl
    inc hl
    jr lab1A6D
lab1A6C exx
lab1A6D ld b,a
lab1A6E ld a,(hl)
    ld (de),a
    inc hl
    dec d
    ld a,(hl)
    ld (de),a
    inc d
    inc hl
    inc hl
    inc hl
    ld a,e
    add a,6
    ld e,a
    djnz lab1A6E
    exx
    ret 
lab1A80 exx
    ld b,a
lab1A82 ld a,(hl)
    ld (de),a
    inc hl
    dec d
    ld a,(hl)
    ld (de),a
    inc hl
    ld c,(hl)
    inc hl
    inc e
    ld a,(hl)
    ld (de),a
    inc hl
    inc d
    ld a,c
    ld (de),a
    ld a,e
    add a,5
    ld e,a
    djnz lab1A82
    exx
    ret 

lab1A9A ld b,56
lab1A9C
	push de
    ld d,#69 ;105 = 0110 1001
    push hl
lab1AA0 
	ld (lab1AB7+1),hl
    ld e,(hl)
    ld a,(de)
    inc hl
    ld e,(hl)
    ld (lab1AB2+1),hl
    inc hl
    ld c,(hl)
    ld (hl),a
    inc hl
    ld a,(de)
    ld e,(hl)
lab1AB0 ld (hl),a
    ld a,(de)
lab1AB2 ld (0),a	; Auto modifie
    ld e,c
    ld a,(de)
lab1AB7 ld (0),a ; Auto modifie
    inc hl
    djnz lab1AA0
    
    pop hl
    pop de
    ret 

lab1AC0:
	db #00
    
; calcule 224*a, avec a dans [0;3]
lab1AC1 and 3
    add a,a
    add a,a ; a*4
    ld c,a  ; c=4*a
    add a,a
    add a,a
    add a,a ; a*32
    sub c   ; a*32-4*a = 28*a 
    add a,a ; 56*a
    ld l,a
    ld h,0
    add hl,hl ; hl = 4*56*a = 224*a
    add hl,hl
    ; 
    ld bc,(lab3C42)
    add hl,bc
    ret 


; modifie le code de facon a appeler les bones fonctions
; pour les étapes d''animation des sprites et en 
; fonction de la taille des sprites
poke_func:
lab1ad6:
 	dec a
    add a,a
    exx
    ld c,a
lab1ADA 
    ld b,0
    ld a,(lab3537)
    inc a
    ld (lab3537),a
    cp 5    
    ld hl,lab1B1C
    jr nz,lab1AED    
    ld hl,lab1B22		; optim ld l,
lab1AED 
    add hl,bc
    ld a,(hl)
    inc hl				; Optim: inc l
    ld h,(hl)
    ld l,a
    ld (lab1B05+1),hl
    ld (lab1B10+1),hl
    exx
    ex af,af''
    push af
    ld a,(lab1C9D)
    push de
lab1AFF ld de,lab6FC0
    ld b,0
    di
lab1B05 call 0 ; Code auto modifie
    ex de,hl
    pop hl
    push de
    ld a,(lab1C9D)
lab1B0E ld b,255
lab1B10 call 0	; Code auto modifie
    ld hl,lab6FC0
    pop de
    ei
    pop af
    inc a
    ex af,af''
    ret 

lab1B1C
	dw lab1B2A,lab1BE0,lab1B85
lab1b22: 
	dw lab1c03,lab1c71,lab1c3A
lab1b28:     
    db #00,#00
lab1b2a:
ld (lab1B28),sp
    ld c,62
    ld (lab1B49),bc
    ld (lab1B63),bc
    ld sp,hl
    ex de,hl
    srl a
    jr nc,lab1B46
    inc a
    ex af,af''
    pop bc
    ld b,c
    dec sp
    jp lab1B62
lab1B46 ex af,af''
    pop de
    pop bc
lab1B49 ld a,0
    rrca 
    rr e
    rr d
    rr c
    rra 
    rr e
    rr d
    rr c
    rra 
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),c
    inc hl
lab1B60 ld (hl),a
    inc hl
lab1B62 pop de
lab1B63 ld a,0
    rrca 
    rr b
    rr e
    rr d
    rra 
    rr b
    rr e
    rr d
    rra 
    ld (hl),b
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),a
lab1B7B inc hl
    ex af,af''
    dec a
    jr nz,lab1B46
    ld sp,(lab1B28)
    ret 
lab1b85:    
    ld (lab1B28),sp
    ld c,62
    ld (lab1BA4),bc
lab1B8F ld (lab1BBE),bc
    ld sp,hl
    ex de,hl
    srl a
    jr nc,lab1BA1
    inc a
    ex af,af''
    pop bc
    ld b,c
    dec sp
    jp lab1BBD
lab1BA1 ex af,af''
    pop de
    pop bc
lab1BA4 ld a,0
    rlca 
    rl c
    rl d
    rl e
    rla 
    rl c
    rl d
    rl e
    rla 
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),c
    inc hl
lab1BBD pop de
lab1BBE ld a,0
    rlca 
    rl d
    rl e
    rl b
    rla 
lab1BC8 rl d
    rl e
    rl b
lab1BCE rla 
    ld (hl),a
    inc hl
    ld (hl),b
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ex af,af''
    dec a
    jr nz,lab1BA1
    ld sp,(lab1B28)
    ret 
lab1be0:
	ld c,b
    ld b,a
    ld a,c
    push bc
    ld c,255
    push de
lab1BE7 ldi
    ldi
    ldi
    ld (de),a
    inc de
lab1BEF djnz lab1BE7
    pop hl
    pop bc
    ld a,c
lab1BF4 rrd 
    inc hl
    rrd 
    inc hl
    rrd 
    inc hl
    rrd 
    inc hl
lab1C00 djnz lab1BF4
    ret 

lab1c03:    
    ld (lab1B28),sp
    ld c,62
    ld (lab1C12),bc
    ld sp,hl
    ex de,hl
lab1C0F ex af,af''
    pop de
    pop bc
lab1C12 ld a,0
    rrca 
    rr e
    rr d
    rr c
    rr b
lab1C1D rra 
    rr e
    rr d
    rr c
    rr b
    rra 
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
lab1C2B ld (hl),c
    inc hl
    ld (hl),b
    inc hl
    ld (hl),a
    inc hl
    ex af,af''
    dec a
    jr nz,lab1C0F
    ld sp,(lab1B28)
    ret 
lab1C3A ld (lab1B28),sp
    ld c,62
    ld (lab1C49),bc
    ld sp,hl
    ex de,hl
lab1C46 ex af,af''
    pop de
    pop bc
lab1C49 ld a,0
    rlca 
    rl b
    rl c
    rl d
    rl e
    rla 
    rl b
    rl c
    rl d
    rl e
    rla 
    ld (hl),a
    inc hl
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),c
    inc hl
    ld (hl),b
    inc hl
    ex af,af''
    dec a
    jr nz,lab1C46
    ld sp,(lab1B28)
    ret 

lab1c71    
    ld c,b
    ld b,a
    ld a,c
    push bc
    ld c,255
    push de
lab1C78 
	ldi
    ldi
    ldi
    ldi
    ld (de),a
    inc de
    djnz lab1C78
    pop hl
    pop bc
lab1C86 rrd 
    inc hl
    rrd 
    inc hl
    rrd 
    inc hl
    rrd 
    inc hl
    rrd 
    inc hl
    djnz lab1C86
    ret 
    
lab1c98 db #66,#60
lab1c9a db #70,#50 
lab1c9c: db #00
lab1C9D: db #00,#00,#00 

db #00,#00 ; #1ca0
lab1CA2: db #00,#23,#23,#CD,#1E,#1E,#ED,#43,#9E,#1C,#22,#A0,#1C,#C9 

lab1CB0 
db #23,#23,#CD,#1E,#1E,#ED,#5B,#A0,#1C,#7C,#BA,#30,#01,#54,#7B,#BD ; #1cb0 ##....[..|.0.T{.
db #30,#01,#5D,#2A,#9E,#1C,#78,#BC,#30,#01,#60,#7D,#B9,#D0,#69,#C9 ; #1cc0 0.]*..x.0.`}..i.

lab1CD0 
    ld a,l
    add a,3
    and 252
    ld l,a
    ld a,h
    and 252
    ld h,a
    ld (lab1C98),hl
    ret 


lab1CDE:
    call lab1CD0
    jr lab1CF5
    
lab1CE3 ld a,64
    cp e
    ret nc
    ld d,64
    jr lab1CFC
lab1CEB call lab1CB0
lab1CEE call lab1CD0
    ld a,e
    cp 241
    ret nc
lab1CF5 
    ld a,d
    cp e
    ret nc
    cp 64
    jr c,lab1CE3
lab1CFC ld (lab1C9A),de
lab1D00 call lab1735
    ld a,(lab1EC0)
    and 12
lab1D08 jr z,lab1D4F
    ld e,a
lab1D0B and 8
    jr z,lab1D32
    ld bc,(lab1C98)
    ld hl,lab3C48
    ld a,b
    cp (hl)
lab1D18 jr nc,lab1D32
    ld a,(lab1C9B)
    add a,b
    rra 
    ld d,a
lab1D20 ld a,(lab3C46)
    cp d
lab1D24 jr c,lab1D32
    ld hl,lab39AD
    push de
    call lab1D64
    pop de
    bit 2,e
    jr z,lab1D4F
lab1D32 ld bc,(lab1C98)
    ld a,(lab3C48)
    cp c
    jr nc,lab1D4F
    ld a,(lab1C9B)
    sub c
lab1D40 ccf 
    rra 
    ld d,a
    ld a,(lab3C47)
    cp d
    jr c,lab1D4F
    ld hl,lab39B1
    call lab1D64
lab1D4F ld hl,lab39B5
    call lab1D64
    ld hl,lab39A9
lab1D58 call lab1D64
    ld hl,lab39B9
    call lab1D64
    jp lab05A7
    
lab1d64: 
	ld a,(hl)
    inc hl
    ld h,(hl)
lab1D67 
	ld l,a
    or h
    ret z
    
    ld (lab1D70+1),hl	
    call lab1D75
lab1D70 ld hl,0		; code automodifié
    jr lab1D64

lab1D75 
    call lab1E03
    ret nc
    ld (lab1C9D),a
    ld a,h
    add a,a
    add a,h
    add a,a
    exx
    srl h
    srl h
    add a,h
    ld e,a
    ld d,103
    push de
    push hl
    exx
    ld a,l
    neg
    ld b,a
    ld a,(lab3537)
    and 4
    ld a,b
    jr nz,lab1D9C
    add a,a
    add a,b
    jr lab1D9E
lab1D9C add a,a
    add a,a
lab1D9E push af
    call lab35B3
    pop bc
    ld c,b
    ld b,0
    add hl,bc
    ex de,hl
    add hl,bc
    ld a,(lab1C9C)
    and 3
    call nz,lab1AD6
    pop bc
    ld a,c
    neg
    add a,3
    rrca 
lab1DB8 rrca 
    and 7
    ld c,a
    ld b,0
    add hl,bc
    ex de,hl
lab1DC0 add hl,bc
    pop bc
    exx
	; calcul de la fonction a appeler pour le rendu
	ld a,(lab3537)
    sub 3
    add a,a
    ld e,a
    ld d,0
    ld hl,tab_drawfunc
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex af,af''
    dec a
    rra 
    and 14
    ld l,a
    ld h,0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(lab1C9D)
    ld b,a
    jp (hl)

;lab1DE5
tab_drawfunc: dw lab1deb,lab1dF1,lab1dF9
lab1deb: dw draw_1col,draw_2cols,draw_3cols
lab1df1: dw draw_1col_b,draw_2cols_b,draw_3cols_b,draw_4cols_b
lab1df9: dw draw_1col_c,draw_2cols_c,draw_3cols_c,draw_4cols_c,draw_5cols_c


lab1E03:
db #CD,#36,#1E,#78,#32,#9C,#1C,#E5,#ED,#5B,#98,#1C,#CD 
db #52,#1E,#D9,#C1,#D0,#08,#ED,#5B,#9A,#1C,#CD,#52,#1E,#C9,#23,#23 ; #1e10 R......[...R..##
db #7E,#CB,#5F,#28,#14,#CD,#39,#1E,#3A,#A2,#1C,#CB,#6F,#3E,#F0,#28 ; #1e20 ~._(..9.:...o>.(
db #02,#3E,#F4,#84,#67,#C9,#23,#23,#7E,#CB,#67,#3E,#00,#28,#02,#3E ; #1e30 .>..g.##~.g>.(.>
db #80,#08,#23,#CD,#77,#1E,#23,#23,#7E,#32,#A2,#1C,#2B,#08,#AE,#C3 ; #1e40 ..#.w.##~2..+...
db #4A,#35,#7A,#91,#D0,#78,#93,#D0,#ED,#44,#6F,#78,#92,#38,#0B,#67 ; #1e50 J5z..x...Dox.8.g
db #79,#90,#4D,#2E,#00,#B9,#D8,#79,#37,#C9,#6F,#79,#92,#4F,#7B,#92 ; #1e60 y.M....y7.oy.O{.
db #B9,#26,#00,#D8,#79,#37,#C9 ; #1e70 .&..y7.~W#^...O#

lab1E77: 
    ld a,(hl)
    ld d,a
    inc hl
    ld e,(hl)
    sub e
    add a,128
    ld c,a
    inc hl
lab1E80 
    ld a,(hl)
    add a,a
    sub e
    sub d
    add a,127
    ld b,a
    ret 
    
lab1E88
    db #8A,#1E,#00,#00,#00,#00,#00,#00 

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #1e90 
db #00,#00,#00,#FF,#FF,#00,#00,#00,#00,#00,#00,#0E,#CD,#05,#00,#00 ; #1ea0 

db #00,#27,#26,#17,#15,#05,#04,#36,#34
lab1eb9: db #00,#00,#00,#00,#00 ; #1eb0
lab1EBE: db #00,#00 

lab1ec0:
db #00,#00,#3A,#8A,#40,#32,#85,#40,#47,#C9,#F5,#11,#2C,#41,#08,#08 ; #1ec0 ..:.@2.@G...,A..
db #48,#48,#08,#10,#48,#40,#08,#18,#48,#38,#08,#20,#48,#30,#10,#08 ; #1ed0 HH..H@..H8. H0..
db #40,#48,#18,#08,#38,#48,#20,#08,#30,#48,#10,#10,#40,#40,#00,#00 ; #1ee0 @H..8H .0H..@@..

db #00,#00,#00,#00,#00,#00,#C0; #1ef0 .......>.2...!..
lab1EF7:
db #3E,#FF,#32,#BD,#1E,#FD,#21,#C2,#1E 
db #21,#D0,#30,#22,#98,#1C,#21,#FF,#00,#22,#9A,#1C,#21,#C0,#C0,#22 ; #1f00 !.0"..!.."..!.."
db #F2,#1E,#22,#F4,#1E,#21,#00,#00,#ED,#4B,#0E,#01,#CD,#B8,#1F,#AF ; #1f10 .."..!...K......
db #32,#BD,#1E,#32,#F6,#1E,#2A,#A3,#39,#22,#BD,#39,#3A,#BA,#1E,#32 ; #1f20 2..2..*.9".9:..2
db #B9,#1E,#11,#EE,#1E,#21,#F2,#1E,#01,#04,#00,#ED,#B0,#21,#00,#6A ; #1f30 .....!.......!.j
db #01,#40,#00,#CD,#67,#24,#CD,#D0,#22,#CD,#D8,#21,#3E,#00,#17,#32 ; #1f40 .@..g$.."..!>..2
db #BC,#1E,#CD,#4A,#3C,#2A,#C0,#1E,#E5,#7D,#E6,#08,#28,#1C,#3E,#01 ; #1f50 ...J<*...}..(.>.
db #CD,#C1,#39,#ED,#4B,#0E,#01,#78,#3C,#A8,#E6,#0F,#A8,#47,#3A,#C5 ; #1f60 ..9.K..x<....G:.
db #1E,#67,#2E,#00,#CD,#B8,#1F,#CD,#D0,#22,#FD,#21,#CA,#1E,#E1,#E5 ; #1f70 .g.......".!....
db #7D,#E6,#04,#28,#1D,#3E,#02,#CD,#C1,#39,#ED,#4B,#0E,#01,#78,#C6 ; #1f80 }..(.>...9.K..x.
db #10,#A8,#E6,#F0,#A8,#47,#3A,#C4,#1E,#6F,#26,#00,#CD,#B8,#1F,#CD ; #1f90 .....G:..o&.....
db #D0,#22,#3A,#F6,#1E,#2A,#AF,#1E,#F5,#CD,#E8,#34,#F1,#CD,#FB,#16 ; #1fa0 .":..*.....4....
db #E1,#22,#C0,#1E,#AF,#C3,#C1,#39,#22,#8A,#1E,#AF,#32,#8C,#1E,#C5 ; #1fb0 .".....9"...2...
db #CD,#EF,#21,#06,#03,#CD,#B2,#22,#32,#BA,#1E,#87,#87,#C6,#CE,#6F ; #1fc0 ..!...."2......o
db #CE,#1E,#95,#67,#06,#02,#DD,#21,#8A,#1E,#4E,#DD,#7E,#00,#A7,#28 ; #1fd0 ...g...!..N.~..(
db #0B,#91,#5F,#1F,#1F,#1F,#E6,#1F,#DD,#77,#00,#7B,#81,#FD,#77,#00 ; #1fe0 .._......w.{..w.
db #23,#DD,#23,#FD,#23,#10,#E3,#06,#02,#DD,#7E,#FE,#87,#87,#87,#86 ; #1ff0 #.#.#.....~.....
db #FD,#77,#00,#FD,#23,#DD,#23,#23,#10,#EF,#06,#03,#CD,#B2,#22,#32 ; #2000 .w..#.##......"2
db #BE,#1E,#06,#03,#CD,#B2,#22,#32,#BF,#1E,#CD,#DE,#20,#06,#03,#CD ; #2010 ......"2.... ...
db #B2,#22,#32,#BB,#1E,#CD,#D6,#19,#CD,#7E,#20,#30,#FB,#C1,#C3,#F7 ; #2020 ."2......~ 0....
db #3E,#CB,#57,#28,#02,#F6,#F8,#86,#C9,#08,#CD,#9D,#22,#2A,#88,#1E ; #2030 >.W(........"*..
db #F5,#78,#CD,#31,#20,#47,#23,#79,#CD,#31,#20,#4F,#23,#F1,#D6,#07 ; #2040 .x.1 G#y.1 O#...
db #86,#23,#22,#88,#1E,#70,#23,#71,#23,#77,#3A,#AD,#1E,#2A,#AB,#1E ; #2050 .#"..p#q#w:..*..
db #F5,#E5,#CD,#C6,#21,#22,#AB,#1E,#CD,#7E,#20,#30,#FB,#2A,#88,#1E ; #2060 ....!"...~ 0.*..
db #2B,#2B,#2B,#22,#88,#1E,#E1,#F1,#22,#AB,#1E,#32,#AD,#1E,#06,#08 ; #2070 +++"...."..2....
db #CD,#B2,#22,#FE,#FF,#37,#C8,#FE,#C0,#30,#AE,#FD,#E5,#FD,#21,#98 ; #2080 .."..7...0....!.
db #1E,#CD,#F5,#36,#FD,#E1,#06,#02,#CD,#B2,#22,#CB,#4F,#20,#04,#3E ; #2090 ...6......".O .>
db #01,#18,#0A,#F5,#06,#01,#CD,#B2,#22,#C1,#07,#07,#B0,#32,#AA,#1E ; #20a0 ........"....2..
db #CD,#37,#22,#CD,#6B,#22,#3A,#AA,#1E,#1F,#30,#0B,#3A,#AE,#1E,#3C ; #20b0 .7".k":...0.:..<
db #A7,#C8,#CD,#CC,#20,#18,#E9,#CD,#CC,#20,#A7,#C9,#21,#98,#1E,#01 ; #20c0 .... .... ..!...
db #12,#00,#FD,#E5,#3A,#BD,#1E,#A7,#CC,#F1,#39,#FD,#E1,#C9,#06,#03 ; #20d0 ....:.....9.....
db #CD,#B2,#22,#CD,#5D,#04,#87,#6F,#67,#24,#22,#AF,#1E,#DD,#21,#B1 ; #20e0 ..".]..og$"...!.
db #1E,#21,#F2,#1E,#D9,#FD,#7E,#FF,#C6,#04,#CD,#5B,#21,#21,#F3,#1E ; #20f0 .!....~....[!!..
db #D9,#FD,#7E,#FE,#C6,#04,#CD,#4F,#21,#21,#F4,#1E,#D9,#FD,#7E,#FD ; #2100 ..~....O!!....~.
db #D6,#04,#CD,#5B,#21,#21,#F5,#1E,#D9,#FD,#7E,#FC,#D6,#04,#C3,#4F ; #2110 ...[!!....~....O
db #21,#06,#03,#CD,#B2,#22,#21,#C0,#1E,#D6,#02,#38,#17,#CB,#16,#23 ; #2120 !...."!....8...#
db #37,#CB,#16,#D6,#07,#ED,#44,#4F,#87,#81,#87,#C6,#96,#32,#9F,#1E ; #2130 7.....DO.....2..
db #37,#D9,#77,#C9,#FE,#FF,#3F,#CB,#16,#A7,#23,#CB,#16,#A7,#C9,#32 ; #2140 7.w...?...#....2
db #9D,#1E,#21,#9E,#1E,#3A,#8B,#1E,#C3,#64,#21,#32,#9E,#1E,#21,#9D ; #2150 ..!..:...d!2..!.
db #1E,#3A,#8A,#1E,#87,#87,#87,#F5,#C6,#24,#77,#E5,#CD,#21,#21,#30 ; #2160 .:.......$w..!!0
db #4E,#DD,#7E,#00,#32,#9C,#1E,#DD,#23,#3A,#AF,#1E,#32,#A0,#1E,#CD ; #2170 N.~.2...#:..2...
db #95,#21,#DD,#7E,#00,#32,#9C,#1E,#DD,#23,#3A,#B0,#1E,#32,#A0,#1E ; #2180 .!.~.2...#:..2..
db #E1,#F1,#C6,#2C,#77,#CD,#CC,#20,#3A,#9C,#1E,#4F,#E6,#30,#E0,#E6 ; #2190 ...,w.. :..O.0..
db #10,#F6,#01,#32,#9C,#1E,#3A,#9F,#1E,#FE,#C0,#C8,#F5,#C6,#06,#32 ; #21a0 ...2..:........2
db #9F,#1E,#3E,#54,#32,#A0,#1E,#CD,#CC,#20,#F1,#32,#9F,#1E,#C9,#E1 ; #21b0 ..>T2.... .2....
db #F1,#DD,#23,#DD,#23,#C9,#3E,#80,#32,#AD,#1E,#21,#D0,#50,#08,#16 ; #21c0 ..#.#.>.2..!.P..
db #00,#5E,#23,#BE,#C8,#19,#18,#F9,#ED,#4B,#0E,#01,#79,#3D,#E6,#F0 ; #21d0 .^#......K..y=..
db #4F,#CD,#F8,#21,#D8,#13,#13,#13,#1A,#F6,#F1,#3C,#C8,#37,#C9,#CD ; #21e0 O..!.......<.7..
db #F8,#21,#D9,#79,#B6,#77,#D9,#C9,#16,#00,#21,#41,#52,#CD,#06,#22 ; #21f0 .!.y.w....!AR.."
db #D0,#21,#E6,#60,#18,#07,#D9,#21,#61,#42,#0E,#01,#D9,#5E,#1C,#1D ; #2200 .!.`...!aB...^..
db #37,#C8,#23,#78,#BE,#28,#0A,#19,#D9,#CB,#01,#30,#01,#23,#D9,#18 ; #2210 7.#x.(.....0.#..
db #EC,#23,#1D,#7E,#E6,#F0,#B9,#20,#EE,#2B,#22,#AB,#1E,#3E,#80,#32 ; #2220 .#.~... .+"..>.2
db #AD,#1E,#06,#04,#C3,#B2,#22,#3A,#AA,#1E,#1F,#1F,#38,#05,#06,#01 ; #2230 ......":....8...
db #CD,#B2,#22,#E6,#01,#07,#07,#07,#07,#E6,#10,#4F,#3A,#97,#1E,#A9 ; #2240 .."........O:...
db #32,#9C,#1E,#ED,#4B,#96,#1E,#CB,#67,#28,#0B,#CB,#4F,#28,#05,#EE ; #2250 2...K...g(..O(..
db #01,#32,#9C,#1E,#0D,#0D,#79,#32,#A8,#1E,#C9,#CD,#9D,#22,#08,#2A ; #2260 .2....y2.....".*
db #88,#1E,#11,#9D,#1E,#78,#CD,#95,#22,#12,#79,#CD,#95,#22,#13,#12 ; #2270 .....x..".y.."..
db #08,#F5,#86,#6F,#87,#85,#87,#C6,#96,#13,#12,#F1,#2F,#A1,#A0,#F6 ; #2280 ...o......../...
db #F8,#32,#AE,#1E,#C9,#86,#23,#07,#07,#07,#C6,#0C,#C9,#06,#03,#CD ; #2290 .2....#.........
db #B2,#22,#F5,#06,#03,#CD,#B2,#22,#F5,#06,#03,#CD,#B2,#22,#E1,#C1 ; #22a0 ."....."....."..
db #4C,#C9,#11,#AD,#1E,#1A,#2A,#AB,#1E,#4F,#AF,#CB,#11,#28,#06,#17 ; #22b0 L.....*..O...(..
db #10,#F9,#EB,#71,#C9,#23,#22,#AB,#1E,#4E,#37,#CB,#11,#C3,#BF,#22 ; #22c0 ...q.#"..N7...."
db #2A,#F2,#1E,#7D,#BC,#38,#01,#7C,#ED,#44,#C6,#C0,#21,#F6,#1E,#BE ; #22d0 *..}.8.|.D..!...
db #38,#01,#77,#7E,#C3,#63,#3C

init: 
	; init ints, copy memory blocs
	call init_hw
    jp fill_buff69
    
lab22ED:
db #AF,#32,#EA
db #3D,#32,#58,#46,#32,#94,#41,#3E,#18,#32,#B8,#24,#3E,#1F,#32,#CA ; #22f0 =2XF2.A>.2.$>.2.
db #24,#CD,#C6,#43,#CD,#55,#24,#71,#24,#CD,#50,#3F,#21,#40,#89,#22 ; #2300 $..C.U$q$.P?!@."
db #0E,#01,#3E,#01,#CD,#22,#23,#21,#40,#8A,#22,#0E,#01,#AF,#32,#58 ; #2310 ..>.."#!@."...2X
db #46,#C9,#32,#84,#24,#F5,#32,#10,#BB,#CD,#9E,#23,#AF,#32,#87,#24 ; #2320 F.2.$.2....#.2.$
db #CD,#48,#2B,#18,#03,#CD,#51,#25,#3A,#AC,#24,#A7,#20,#F7,#F1,#EE ; #2330 .H+...Q%:.$. ...
db #03,#32,#84,#24,#CD,#7B,#27,#C3,#73,#03,

LAB234A:
	call lab2455
lab234D ld (hl),c
    inc h
    ld a,8
    call lab052C
lab2354 jp lab4085
lab2357 call lab1EF7
    call lab2455
    adc a,d
    inc h
    call lab0328
    call lab23F9
    call lab04F8
    xor a
    ld (lab2485),a
    jr lab2392

lab236E db 0,0

lab2370:
db #CD,#9E,#23,#3A,#86,#2F,#A7,#20,#13,#3A,#BF,#1E,#FE,#07,#20,#03 ; #2370 ..#:./. .:.... .
db #3A,#6F,#23,#32,#6F,#23,#F6,#40,#47,#CD,#91,#0D,#CD,#F8,#04,#CD ; #2380 :o#2o#.@G.......
db #48,#2B ; #2390 H+:...,..QA..E.U

lab2392:
	ld a,(lab1EBE)
    call lab052C
    call lab4151
    jp lab459C

lab239E
  db #CD,#55 
  db #24,#86,#39,#CD,#55,#24,#8A,#24,#3A,#84,#24,#FE,#03,#20,#0C,#21 ; #23a0 $.9.U$.$:.$.. .!
  db #10,#BB,#CB,#C6,#CD,#FC,#1E,#3E,#01,#18,#38,#CD,#5F,#03,#20,#2F ; #23b0 .......>..8._. /
  db #CD,#76,#03,#CD,#F7,#1E,#21,#B0,#24,#CD,#2F,#3B,#D9,#21,#C2,#24 ; #23c0 .v....!.$./;.!.$
  db #CD,#2F,#3B,#CD,#C6,#2E,#30,#13,#3A,#84,#24,#1F,#38,#01,#D9,#78 ; #23d0 ./;...0.:.$.8..x
  db #C6,#05,#D9,#B8,#38,#05,#3E,#FF,#32,#6E,#23,#3E,#01,#18,#04,#CD ; #23e0 ....8.>.2n#>....
  db #FC,#1E,#AF,#32,#85,#24,#C3,#F9,#23

lab23f9: 
  db #2A,#C2,#1E,#3A,#C1,#1E,#F5 
  db #CB,#4F,#28,#04,#25,#25,#25,#25,#1F,#7D,#30,#03,#D6,#04,#6F,#94 ; #2400 .O(.%%%%.}0...o.
  db #C6,#80,#32,#03,#18,#4F,#3E,#FC,#94,#95,#47,#ED,#44,#5F,#81,#32 ; #2410 ..2..O>...G.D_.2
  db #17,#18,#79,#ED,#44,#83,#32,#0F,#18,#CD,#FF,#18,#F1,#1F,#F5,#D4 ; #2420 ..y.D.2.........
  db #4A,#24,#F1,#1F,#D8,#21,#3E,#6A,#7E,#A7,#20,#04,#2B,#2B,#18,#F8 ; #2430 J$...!>j~. .++..
  db #23,#7E,#F6,#FA,#3C,#C0,#77,#2B,#77,#C9,#21,#00,#6A,#7E,#A7,#20 ; #2440 #~..<.w+w.!.j~.

db #EF,#23,#23,#18,#F8

lab2455:
db #E1,#5E,#23,#56,#23,#E5,#EB,#4E,#06,#00,#23 ; #2450 .##...^#V#..N..#
db #54,#5D,#09,#EB,#ED,#B0,#C9

; fill HL area, BC bytes with 0
; slow
fill_zero:
lab2467 ld e,0
lab2469 ld (hl),e
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,lab2469
    ret 

db #09,#00,#00,#00,#00,#00,#08,#08,#00,#00,#00,#00,#00,#00,#00 ; #2471 
LAB2480:
	db #04,#04,#00,#00
LAB2484: db #03
LAB2485: db #01
LAB2486: db #00,#00,#03,#02,#03,#00,#00,#FF,#00,#00 
db #FF,#02,#00,#00,#00,#00,#03,#00,#00,#00,#00,#00,#00,#20,#28,#0B ; #2490 

db #C0,#24,#08,#12,#FF,#FF,#00,#00,#08,#00,#00,#0F
LAB24AC:
	db #00,#00
LAB24AE:
	db #00,#FF

LAB24B0:
db #00,#00,#00,#00,#08,#28,#0B,#C0,#18,#21,#00,#FF,#FF,#00,#00,#00  
db #00,#00,#00,#00,#00,#00,#08,#28,#0B,#C0,#1F,#25,#00,#FF,#FF,#00 
db #00,#00,#00,#00,#00,#18,#19,#18,#1A,#00,#00,#1B,#1C,#1B,#1D,#00  
db #00,#1E,#1F,#1E,#20,#00,#00,#21,#22,#21,#23,#00,#00,#24,#A4,#A5  
db #25,#A5,#A6,#26,#26,#A6,#A6,#26,#26,#00,#00,#26,#A6,#26,#A6,#A5 
db #25,#24,#A5,#00,#00,#40,#21,#04,#25,#3E,#80,#AE,#77,#3A,#E3,#70 ; #2500
db #CB,#47,#21,#CD,#8F,#11,#45,#25,#28,#04,#2B,#11,#39,#25,#D5,#E5 
db #CD,#29,#25,#11,#48,#00,#E1,#19,#D1,#0E,#06,#06,#02,#1A,#AE,#77 ; #2520
db #13,#23,#10,#F9,#23,#0D,#20,#F3,#C9,#00,#C0,#01,#D8,#00,#1C,#00 ; #2530
db #84,#00,#10,#00,#20,#03,#00,#1B,#80,#38,#00,#21,#00,#08,#00,#04 ; #2540
db #00

lab2551: db #3A,#04,#25,#17,#DC,#06,#25,#21,#59,#46,#7E,#A7,#28,#0F,#D9 ; #2550
db #21,#84,#24,#3A,#5A,#46,#A6,#D9,#C2,#A8,#26,#CD,#A8,#26,#21,#86 ; #2560
db #24,#7E,#A7,#C2,#99,#26,#23,#B6,#C2,#92,#26,#21,#88,#24,#35,#20 ; #2570
db #17,#36,#03,#2A,#84,#24,#7C,#87,#B4,#B5,#1F,#F5,#3E,#02,#DC,#43 ; #2580
db #41,#F1,#1F,#3E,#03,#DC,#43,#41,#3E,#FF,#32,#AF,#24,#3A,#58,#46 ; #2590
db #A7,#28,#13,#3A,#AC,#24,#A7,#28,#0A,#3A,#AB,#24,#37,#17,#32,#12 ; #25a0
db #01,#18,#03,#32,#58,#46,#CD,#87,#27,#CD,#3B,#2B,#E5,#FD,#E1,#FD ; #25b0
db #7E,#07,#FE,#84,#30,#0F,#AF,#32,#8F,#24,#3A,#BC,#1E,#A7,#20,#05 ; #25c0
db #3E,#06,#32,#58,#46,#3A,#15,#01,#1F,#30,#66,#3A,#84,#24,#F6,#FD ; #25d0
db #3C,#21,#AC,#24,#B6,#20,#57,#3A,#7B,#24,#F6,#F9,#3C,#20,#4F,#3A ; #25e0
db #A8,#24,#FE,#08,#20,#48,#21,#C7,#24,#11,#9E,#24,#01,#03,#00,#ED ; #25f0
db #B0,#21,#99,#24,#E5,#FD,#E1,#3A,#10,#01,#F6,#19,#32,#A3,#24,#FD ; #2600
db #36,#04,#00,#3A,#AB,#24,#32,#A4,#24,#FD,#36,#0C,#FF,#FD,#36,#0F ; #2610
db #20,#CD,#66,#3A,#3E,#06,#CD,#43,#41,#06,#48,#CD,#91,#0D,#3A,#82 ; #2620
db #24,#A7,#20,#0D,#21,#7B,#24,#CB,#96,#CD,#9C,#45,#18,#03,#CD,#71 ; #2630
db #02,#21,#58,#46,#7E,#E6,#7F,#C8,#3A,#59,#46,#A7,#28,#03,#36,#00 ; #2640
db #C9,#3A,#85,#24,#A7,#28,#32,#CD,#3B,#2B,#E5,#FD,#E1,#CD,#F1,#3A ; #2650
db #3A,#84,#24,#FE,#03,#28,#22,#21,#96,#24,#BE,#28,#05,#EE,#03,#77 ; #2660
db #18,#0B,#21,#31,#BB,#11,#92,#24,#01,#05,#00,#ED,#B0,#21,#00,#00 ; #2670 ..!1...$.....!..
db #22,#BD,#24,#22,#CF,#24,#CD,#73,#03,#21,#00,#00,#22,#97,#24,#C3 ; #2680 ".$".$.s.!..".$.
db #8D,#01,#35,#2A,#84,#24,#C3,#33,#27,#35,#2A,#84,#24,#C2,#3C,#27 ; #2690 ..5*.$.3''5*.$.<''
db #3E,#07,#32,#58,#46,#C3,#B9,#25,#35,#C2,#39,#27,#21,#00,#00,#22 ; #26a0 >.2XF..%5.9''!.."
db #97,#24,#21,#80,#24,#ED,#4B,#5A,#46,#06,#02,#16,#FF,#CB,#19,#30 ; #26b0 .$!.$.KZF......0
db #09,#7E,#D6,#01,#27,#77,#20,#02,#16,#00,#23,#10,#F0,#2B,#7E,#2B ; #26c0 .~..''w ...#..+~+
db #B6,#CA,#19,#01,#7A,#A7,#20,#39,#21,#80,#24,#3A,#85,#24,#A7,#28 ; #26d0 ....z. 9!.$:.$.(
db #1E,#3A,#96,#24,#FE,#03,#20,#0C,#7E,#A7,#3E,#01,#20,#01,#3C,#32 ; #26e0 .:.$.. .~.>. .<2
db #96,#24,#18,#1D,#1F,#38,#01,#23,#7E,#A7,#20,#12,#32,#85,#24,#CD ; #26f0 .$...8.#~. .2.$.
db #92,#02,#21,#00,#00,#22,#59,#46,#21,#10,#BB,#CB,#C6,#C9,#CD,#08 ; #2700 ..!.."YF!.......
db #27,#3A,#96,#24,#32,#84,#24,#CD,#7B,#27,#CD,#3B,#2B,#11,#05,#00 ; #2710 '':.$2.$.{''.;+...
db #19,#EB,#21,#93,#24,#01,#03,#00,#ED,#B0,#3A,#92,#24,#32,#58,#46 ; #2720 ..!.$.....:.$2XF
db #C3,#B9,#01,#E5,#21,#FA,#24,#18,#07,#2A,#5A,#46,#E5,#21,#EC,#24 ; #2730 ....!.$..*ZF.!.$
db #FD,#21,#B0,#24,#CD,#6F,#44,#E1,#E5,#CB,#4D,#28,#15,#F5,#32,#CA ; #2740 .!.$.oD...M(..2.
db #24,#FD,#CB,#16,#9E,#21,#C2,#24,#CD,#A3,#1C,#21,#C2,#24,#CD,#EB ; #2750 $....!.$...!.$..
db #1C,#F1,#E1,#CB,#1D,#D0,#EE,#80,#32,#B8,#24,#FD,#CB,#04,#9E,#21 ; #2760 ........2.$....!
db #B0,#24,#CD,#A3,#1C,#21,#B0,#24,#C3,#EB,#1C,#E6,#01,#07,#07,#21 ; #2770 .$...!.$.......!
db #14,#01,#CB,#96,#B6,#77,#C9,#CD,#3B,#2B,#E5,#FD,#E1,#3E,#3F,#32 ; #2780 .....w..;+...>?2
db #AD,#24,#3A,#AC,#24,#CD,#C1,#39,#CD,#3B,#2B,#CD,#A3,#1C,#21,#8F ; #2790 .$:.$..9.;+...!.
db #24,#7E,#A7,#28,#53,#3A,#AC,#24,#A7,#28,#04,#36,#00,#18,#49,#35 ; #27a0 $~.(S:.$.(.6..I5
db #CD,#3B,#2B,#CD,#31,#2E,#38,#0A,#FD,#35,#07,#3E,#84,#CD,#21,#2B ; #27b0 .;+.1.8..5.>..!+
db #18,#11,#08,#3E,#88,#FD,#CB,#0B,#66,#FD,#CB,#0B,#E6,#CC,#21,#2B ; #27c0 ...>....f.....!+
db #08,#28,#0B,#FD,#CB,#0B,#A6,#FD,#CB,#0B,#EE,#FD,#35,#07,#3A,#84 ; #27d0 .(..........5.:.
db #24,#E6,#02,#20,#06,#3A,#AB,#24,#C3,#59,#28,#3A,#12,#01,#1F,#CD ; #27e0 $.. .:.$.Y(:....
db #0F,#44,#3C,#C2,#55,#28,#18,#ED,#FD,#CB,#0B,#E6,#FD,#CB,#0C,#EE ; #27f0 .D<.U(..........
db #CD,#3B,#2B,#3A,#58,#46,#A7,#20,#09,#CD,#64,#2C,#D2,#14,#29,#C2 ; #2800 .;+:XF. ..d,..).
db #02,#29,#3A,#58,#46,#17,#30,#04,#FD,#36,#0C,#FF,#3E,#86,#FD,#CB ; #2810 .):XF.0..6..>...
db #0B,#6E,#FD,#CB,#0B,#EE,#CC,#21,#2B,#FD,#CB,#0C,#66,#FD,#CB,#0C ; #2820 .n.....!+...f...
db #E6,#20,#18,#CD,#3B,#2B,#CD,#31,#2E,#30,#09,#20,#07,#3E,#88,#CD ; #2830 . ..;+.1.0. .>..
db #21,#2B,#18,#07,#FD,#35,#07,#FD,#CB,#0B,#A6,#AF,#32,#8E,#24,#CD ; #2840 !+...5......2.$.
db #8A,#2A,#CD,#10,#2A,#3A,#12,#01,#1F,#CD,#78,#29,#CD,#64,#29,#08 ; #2850 .*..*:....x).d).
db #3A,#90,#24,#3C,#20,#26,#AF,#21,#84,#24,#CB,#46,#28,#06,#32,#D4 ; #2860 :.$< &.!.$.F(.2.
db #24,#32,#DA,#24,#CB,#4E,#28,#06,#32,#E0,#24,#32,#E6,#24,#08,#01 ; #2870 $2.$.N(.2.$2.$..
db #21,#1B,#38,#38,#CD,#F0,#28,#01,#1F,#18,#18,#30,#08,#21,#D4,#24 ; #2880 !.88..(....0.!.$
db #11,#E0,#24,#30,#06,#21,#DA,#24,#11,#E6,#24,#D5,#3A,#84,#24,#1F ; #2890 ..$0.!.$..$.:.$.
db #30,#06,#CD,#6F,#44,#32,#B8,#24,#E1,#3A,#84,#24,#E6,#02,#28,#06 ; #28a0 0..oD2.$.:.$..(.
db #CD,#6F,#44,#32,#CA,#24,#FD,#CB,#0B,#EE,#18,#18,#FD,#CB,#0B,#EE ; #28b0 .oD2.$..........
db #3A,#84,#24,#1F,#30,#03,#FD,#70,#08,#3A,#84,#24,#E6,#02,#28,#04 ; #28c0 :.$.0..p.:.$..(.
db #79,#32,#CA,#24,#3A,#AF,#24,#FD,#77,#0C,#CD,#3B,#2B,#CD,#E9,#3A ; #28d0 y2.$:.$.w..;+..:
db #CD,#32,#2C,#AF,#CD,#C1,#39,#CD,#3B,#2B,#CD,#EB,#1C,#C3,#28,#2B ; #28e0 .2,...9.;+....(+
db #21,#05,#25,#35,#3E,#03,#96,#D8,#28,#05,#FE,#03,#C0,#36,#40,#C3 ; #28f0 !.%5>...(....6@.
db #06,#25,#21,#8E,#24,#7E,#A7,#36,#FF,#28,#0E,#CD,#8A,#2A,#CD,#10 ; #2900 .%!.$~.6.(...*..
db #2A,#AF,#18,#05,#AF,#32,#8E,#24,#3C,#4F,#CD,#0A,#2A,#FD,#CB,#0B ; #2910 *....2.$<O..*...
db #AE,#3A,#84,#24,#E6,#02,#20,#06,#0D,#20,#1B,#FD,#34,#07,#FD,#34 ; #2920 .:.$.. .. ..4..4
db #07,#A7,#20,#15,#3E,#82,#CD,#21,#2B,#21,#83,#24,#7E,#A7,#28,#15 ; #2930 .. .>..!+!.$~.(.
db #35,#3A,#AB,#24,#18,#0C,#FD,#34,#07,#3E,#83,#CD,#21,#2B,#3A,#12 ; #2940 5:.$...4.>..!+:.
db #01,#1F,#CD,#78,#29,#CD,#64,#29,#01,#21,#1B,#DA,#C0,#28,#01,#4D ; #2950 ...x).d).!...(.M
db #18,#C3,#C0,#28,#3A,#AB,#24,#CD,#0F,#44,#1F,#FD,#CB,#04,#A6,#1F ; #2960 ...(:.$..D......
db #38,#04,#FD,#CB,#04,#E6,#1F,#C9,#F6,#F0,#FE,#FF,#32,#90,#24,#28 ; #2970 8...........2.$(
db #12,#08,#AF,#32,#90,#24,#3E,#80,#CD,#21,#2B,#08,#21,#AB,#24,#BE ; #2980 ...2.$>..!+.!.$.
db #77,#28,#05,#CD,#0A,#2A,#3E,#FF,#F5,#FD,#A6,#0C,#CD,#0F,#44,#FE ; #2990 w(...*>.......D.
db #FF,#28,#13,#CD,#3B,#2B,#CD,#5C,#46,#30,#15,#FD,#7E,#0B,#F6,#F0 ; #29a0 .(..;+.\F0..~...
db #3C,#3E,#88,#C4,#21,#2B,#F1,#FD,#7E,#0B,#F6,#0F,#FD,#77,#0B,#C9 ; #29b0 <>..!+..~....w..
db #CD,#3B,#2B,#CD,#55,#44,#C1,#21,#91,#24,#7E,#A7,#28,#02,#35,#C9 ; #29c0 .;+.UD.!.$~.(.5.
db #21,#7C,#24,#3A,#84,#24,#E6,#01,#B6,#C8,#21,#89,#24,#35,#C5,#20 ; #29d0 !|$:.$....!.$5.
db #0D,#36,#02,#3A,#84,#24,#1F,#38,#05,#3E,#00,#CD,#43,#41,#3E,#81 ; #29e0 .6.:.$.8.>..CA>.
db #CD,#21,#2B,#F1,#CD,#0F,#44,#FE,#FF,#C8,#CD,#3B,#2B,#E5,#CD,#5C ; #29f0 .!+...D....;+..\
db #46,#E1,#D2,#55,#44,#3E,#88,#C3,#21,#2B,#3E,#02,#32,#91,#24,#C9 ; #2a00 F..UD>..!+>.2.$.
db #3A,#84,#24,#47,#3D,#20,#04,#AF,#32,#83,#24,#3A,#AC,#24,#A7,#C0 ; #2a10 :.$G= ..2.$:.$..
db #3A,#12,#01,#1F,#D8,#0E,#00,#FD,#6E,#0D,#FD,#66,#0E,#7C,#B5,#28 ; #2a20 :.......n..f.|.(
db #22,#E5,#DD,#E1,#DD,#CB,#09,#46,#28,#07,#DD,#7E,#0B,#F6,#CF,#3C ; #2a30 "......F(..~...<
db #C0,#DD,#7E,#08,#E6,#7F,#FE,#57,#28,#35,#FE,#2B,#28,#04,#FE,#2C ; #2a40 ..~....W(5.+(..,
db #20,#01,#0C,#3A,#84,#24,#E6,#02,#20,#09,#C5,#3E,#01,#CD,#43,#41 ; #2a50  ..:.$.. ..>..CA
db #C1,#28,#01,#0C,#79,#87,#87,#C6,#04,#FE,#0C,#20,#02,#3E,#0A,#32 ; #2a60 .(..y...... .>.2
db #8F,#24,#3E,#85,#05,#20,#05,#21,#83,#24,#36,#07,#C3,#21,#2B,#21 ; #2a70 .$>.. .!.$6..!+!
db #0C,#08,#22,#86,#24,#06,#C7,#C3,#91,#0D,#3A,#13,#01,#1F,#D0,#3A ; #2a80 ..".$.....:....:
db #7B,#24,#1F,#D2,#71,#02,#3A,#84,#24,#E6,#01,#28,#F6,#3E,#87,#CD ; #2a90 {$..q.:.$..(.>..
db #21,#2B,#3A,#98,#24,#A7,#20,#1B,#CD,#3B,#2B,#CD,#02,#2E,#30,#E3 ; #2aa0 !+:.$. ..;+...0.
db #DD,#7E,#08,#E5,#22,#97,#24,#01,#B0,#D8,#F5,#CD,#F3,#45,#F1,#E1 ; #2ab0 .~..".$......E..
db #C3,#CA,#44,#3A,#AC,#24,#A7,#C2,#71,#02,#FD,#4E,#07,#06,#03,#CD ; #2ac0 ..D:.$..q..N....
db #3B,#2B,#C5,#CD,#31,#2E,#C1,#38,#3D,#FD,#35,#07,#FD,#35,#07,#10 ; #2ad0 ;+..1..8=.5..5..
db #EE,#2A,#97,#24,#E5,#11,#07,#00,#19,#E5,#CD,#3B,#2B,#11,#06,#00 ; #2ae0 .*.$.......;+...
db #19,#EB,#E1,#71,#EB,#1B,#ED,#A8,#ED,#A8,#E1,#CD,#FE,#44,#21,#00 ; #2af0 ...q.........D!.
db #00,#22,#97,#24,#01,#B0,#D8,#CD,#11,#46,#CD,#3B,#2B,#CD,#64,#2C ; #2b00 .".$.....F.;+.d,
db #CD,#3B,#2B,#C3,#A3,#1C,#FD,#71,#07,#C3,#71,#02,#21,#AE,#24,#18 ; #2b10 .;+....q..q.!.$.
db #03,#21,#AD,#24,#BE,#D8,#77,#C9,#3A,#AD,#24,#F6,#80,#47,#FE,#85 ; #2b20 .!.$..w.:.$..G..
db #D2,#91,#0D,#3A,#86,#2F,#A7,#C0,#C3,#91,#0D,#21,#84,#24,#CB,#46 ; #2b30 ...:./.....!.$.F
db #21,#B0,#24,#C0,#21,#C2,#24,#C9,#AF,#32,#EC,#24,#32,#86,#24,#32 ; #2b40 !.$.!.$..2.$2.$2
db #FA,#24,#3E,#08,#32,#A8,#24,#CD,#28,#03,#3A,#84,#24,#32,#96,#24 ; #2b50 .$>.2.$.(.:.$2.$
db #CD,#3B,#2B,#E5,#E5,#E5,#FD,#E1,#3A,#58,#46,#32,#92,#24,#F5,#D6 ; #2b60 .;+.....:XF2.$..
db #01,#F5,#FE,#04,#30,#17,#EE,#01,#5F,#16,#00,#21,#EE,#1E,#19,#4E ; #2b70 ....0..._..!...N
db #21,#5E,#2C,#19,#3A,#C0,#1E,#A6,#20,#03,#FD,#71,#07,#CD,#3B,#2B ; #2b80 !^,.:... ..q..;+
db #11,#05,#00,#19,#EB,#F1,#38,#4A,#FE,#06,#28,#2E,#30,#3F,#FE,#04 ; #2b90 ......8J..(.0?..
db #30,#13,#21,#C2,#1E,#0E,#FD,#1F,#30,#02,#13,#23,#1F,#38,#3E,#0E ; #2ba0 0.!.....0..#.8>.
db #03,#23,#23,#18,#38,#13,#13,#1F,#3E,#84,#30,#0A,#3A,#6E,#23,#A7 ; #2bb0 .##.8...>.0.:n#.
db #3E,#BA,#28,#02,#3E,#B4,#12,#F1,#18,#32,#13,#13,#3A,#6E,#23,#A7 ; #2bc0 >.(.>....2..:n#.
db #28,#04,#1A,#D6,#06,#12,#06,#C8,#CD,#91,#0D,#18,#13,#21,#5E,#42 ; #2bd0 (............!^B
db #18,#03,#21,#54,#2C,#ED,#A0,#ED,#A0,#ED,#A0,#18,#03,#7E,#81,#12 ; #2be0 ..!T,........~..
db #F1,#C6,#57,#6F,#CE,#2C,#95,#67,#7E,#32,#AB,#24,#3E,#80,#32,#58 ; #2bf0 ..Wo.,.g~2.$>.2X
db #46,#E1,#11,#05,#00,#19,#11,#93,#24,#01,#03,#00,#ED,#B0,#FD,#36 ; #2c00 F.......$......6
db #0D,#00,#FD,#36,#0E,#00,#FD,#36,#0B,#FF,#FD,#36,#0C,#FF,#E1,#CD ; #2c10 ...6...6...6....
db #3B,#3A,#CD,#32,#2C,#AF,#32,#59,#46,#32,#5A,#46,#32,#6E,#23,#C3 ; #2c20 ;:.2,.2YF2ZF2n#.
db #C1,#39,#3A,#A2,#39,#32,#AC,#24,#C9,#3A,#84,#24,#21,#85,#24,#1F ; #2c30 .9:.92.$.:.$!.$.
db #B6,#1F,#D0,#2A,#97,#24,#24,#25,#C8,#11,#08,#00,#19,#7E,#01,#B0 ; #2c40 ...*.$$%.....~..
db #D8,#C3,#F3,#45,#28,#28,#C0,#FD,#FD,#FB,#FE,#F7,#FD,#FD,#08,#04 ; #2c50 ...E((..........
db #02,#01,#00,#00,#CD,#6E,#2C,#FD,#7E,#07,#91,#C3,#FB,#2C,#0E,#C0 ; #2c60 .....n,.~....,..
db #3A,#AC,#24,#A7,#C8,#DD,#21,#EE,#1E,#DD,#4E,#00,#3A,#C5,#1E,#D6 ; #2c70 :.$...!...N.:...
db #03,#FD,#BE,#06,#D8,#DD,#4E,#02,#3A,#C3,#1E,#C6,#02,#FD,#BE,#06 ; #2c80 ......N.:.......
db #D0,#DD,#4E,#01,#3A,#C4,#1E,#D6,#03,#FD,#BE,#05,#D8,#DD,#4E,#03 ; #2c90 ..N.:.........N.
db #C9,#FE,#FF,#37,#FD,#77,#0D,#FD,#77,#0E,#C0,#FD,#CB,#09,#46,#28 ; #2ca0 ...7.w..w.....F(
db #38,#3A,#AC,#24,#A7,#20,#2F,#3A,#BB,#1E,#FE,#06,#28,#1F,#FE,#07 ; #2cb0 8:.$. /:....(...
db #20,#24,#CD,#3B,#2B,#FD,#E5,#D1,#A7,#ED,#52,#28,#09,#21,#14,#01 ; #2cc0  $.;+.....R(.!..
db #7E,#F6,#03,#77,#18,#10,#3E,#05,#32,#58,#46,#A7,#C9,#FD,#4E,#09 ; #2cd0 ~..w..>.2XF...N.
db #FD,#46,#04,#CD,#38,#47,#AF,#37,#C9,#3A,#BB,#1E,#FE,#07,#20,#F6 ; #2ce0 .F..8G.7.:.... .
db #FD,#36,#0A,#22,#18,#F0,#FD,#7E,#07,#D6,#C0,#01,#00,#00,#ED,#43 ; #2cf0 .6."...~.......C
db #62,#2C,#28,#9F,#3C,#28,#9A,#CD,#24,#3B,#48,#0C,#D9,#FD,#7E,#0E ; #2d00 b,(.<(..$;H...~.
db #A7,#28,#41,#67,#FD,#6E,#0D,#E5,#DD,#E1,#DD,#CB,#04,#7E,#20,#34 ; #2d10 .(Ag.n.......~ 4
db #DD,#7E,#07,#D6,#06,#D9,#B8,#D9,#20,#2A,#CD,#C3,#2E,#30,#25,#DD ; #2d20 .~...... *...0%.
db #CB,#09,#4E,#28,#09,#DD,#CB,#FA,#AE,#DD,#7E,#F9,#18,#07,#DD,#CB ; #2d30 ..N(......~.....
db #0C,#AE,#DD,#7E,#0B,#F6,#E0,#4F,#FD,#7E,#0C,#A1,#FD,#77,#0C,#AF ; #2d40 ...~...O.~...w..
db #37,#C3,#FF,#46,#21,#AB,#39,#7E,#23,#66,#6F,#B4,#28,#38,#E5,#DD ; #2d50 7..F!.9~#fo.(8..
db #E1,#DD,#CB,#04,#7E,#20,#F0,#DD,#7E,#07,#D6,#06,#D9,#B8,#20,#10 ; #2d60 ....~ ..~..... .
db #D9,#E5,#CD,#C3,#2E,#E1,#30,#DF,#FD,#75,#0D,#FD,#74,#0E,#18,#AF ; #2d70 ......0..u..t...
db #B9,#D9,#20,#D3,#3A,#63,#2C,#A7,#20,#CD,#E5,#CD,#C3,#2E,#E1,#30 ; #2d80 .. .:c,. ......0
db #C6,#22,#62,#2C,#18,#C1,#3A,#AC,#24,#A7,#28,#3B,#CD,#9F,#2E,#3A ; #2d90 ."b,..:.$.(;...:
db #84,#24,#FE,#03,#3E,#F4,#28,#02,#3E,#FA,#DD,#86,#07,#D9,#B8,#20 ; #2da0 .$..>.(.>......
db #0A,#D9,#E5,#CD,#C3,#2E,#E1,#30,#1E,#18,#BD,#B9,#D9,#20,#18,#3A ; #2db0 .......0..... .:
db #63,#2C,#A7,#20,#12,#CD,#9F,#2E,#CD,#C3,#2E,#30,#0A,#FD,#36,#0D ; #2dc0 c,. .......0..6.
db #00,#FD,#36,#0E,#00,#18,#27,#2A,#62,#2C,#FD,#36,#0D,#00,#FD,#36 ; #2dd0 ..6...''*b,.6...6
db #0E,#00,#7C,#A7,#C8,#E5,#DD,#E1,#DD,#CB,#09,#4E,#28,#06,#DD,#CB ; #2de0 ..|........N(...
db #F9,#66,#18,#04,#DD,#CB,#0B,#66,#20,#04,#FD,#CB,#0C,#A6,#AF,#D6 ; #2df0 .f.....f .......
db #01,#C9,#CD,#24,#3B,#78,#C6,#06,#47,#3C,#4F,#D9,#21,#AB,#39,#7E ; #2e00 ...$;x..G<O.!.9~
db #23,#66,#6F,#B4,#C8,#E5,#DD,#E1,#DD,#CB,#04,#76,#28,#F1,#DD,#7E ; #2e10 #fo........v(..~
db #07,#D9,#B8,#28,#01,#B9,#D9,#20,#E6,#E5,#CD,#C3,#2E,#E1,#30,#DF ; #2e20 ...(... ......0.
db #C9,#CD,#24,#3B,#41,#05,#D9,#AF,#32,#62,#2C,#21,#AB,#39,#7E,#23 ; #2e30 ..$;A...2b,!.9~#
db #66,#6F,#B4,#28,#42,#E5,#DD,#E1,#DD,#CB,#04,#7E,#20,#F0,#DD,#7E ; #2e40 fo.(B......~ ..~
db #07,#D9,#B9,#20,#1A,#D9,#E5,#CD,#C3,#2E,#E1,#30,#E1,#FD,#7E,#0B ; #2e50 ... .......0..~.
db #F6,#E0,#E6,#EF,#4F,#DD,#7E,#0C,#A1,#DD,#77,#0C,#C3,#4F,#2D,#B8 ; #2e60 ....O.~...w..O-.
db #D9,#20,#CB,#3A,#62,#2C,#A7,#20,#C5,#E5,#CD,#C3,#2E,#E1,#30,#BE ; #2e70 . .:b,. ......0.
db #3E,#FF,#32,#62,#2C,#18,#B7,#3A,#AC,#24,#A7,#28,#2F,#CD,#9F,#2E ; #2e80 >.2b,..:.$.(/...
db #DD,#7E,#07,#D9,#B9,#20,#0F,#D9,#CD,#C3,#2E,#30,#1F,#18,#BE,#CD ; #2e90 .~... .....0....
db #3B,#2B,#E5,#DD,#E1,#C9,#B8,#D9,#20,#12,#3A,#62,#2C,#A7,#20,#0C ; #2ea0 ;+...... .:b,. .
db #CD,#9F,#2E,#CD,#C3,#2E,#30,#04,#3E,#FF,#18,#03,#3A,#62,#2C,#A7 ; #2eb0 ......0.>...:b,.
db #C8,#37,#C9,#CD,#D6,#2E,#7B,#D9,#BA,#7B,#D9,#D0,#BA,#D0,#7D,#D9 ; #2ec0 .7....{..{....}.
db #BC,#7D,#D9,#D0,#BC,#C9,#DD,#7E,#04,#CB,#4F,#20,#16,#1F,#3E,#03 ; #2ed0 .}.....~..O ..>.
db #CE,#00,#4F,#DD,#86,#05,#57,#91,#91,#5F,#79,#DD,#86,#06,#67,#91 ; #2ee0 ..O...W.._y...g.
db #91,#6F,#C9,#1F,#38,#10,#DD,#7E,#05,#C6,#04,#57,#D6,#08,#5F,#DD ; #2ef0 .o..8..~...W.._.
db #6E,#06,#65,#24,#2D,#C9,#DD,#7E,#06,#C6,#04,#67,#D6,#08,#6F,#DD ; #2f00 n.e$-..~...g..o.
db #5E,#05,#53,#14,#1D,#C9; #2f10 ^.S......``..`/`

lab2f16: db #00,#00,#1E,#60,#60,#98,#8C,#60,#2F,#60 
db #48,#AF,#8C,#48
lab2F24
db #3E,#99,#CD,#C2,#4A,#DD,#21,#62,#2F,#DD,#36,#00 ; #2f20 H..H>...J.!b/.6.
db #00,#CD,#5A,#2F,#CD,#BC,#30,#CD,#97,#44,#CD,#9F,#30,#38,#F8,#DD ; #2f30 ..Z/..0..D..08..
db #7E,#00,#FE,#01,#DA,#F6,#2F,#20,#05,#CD,#8B,#2F,#18,#D6,#FE,#03 ; #2f40 ~...../ .../....

db #21,#24,#2F,#E5,#CA,#DA,#2F,#C3,#67,#2F	; #2f50 !$/.../.g/..!./.
lab2F5A:
db #1E,#03,#21,#18,#2F,#C3 
db #AF,#45,#00,#04,#05,#89,#9A,#3E,#A9,#CD,#C2,#4A,#DD,#21,#86,#2F ; #2f60 .E.....>...J.!./
db #CD,#BC,#30,#CD,#9F,#30,#38,#FB,#3A,#86,#2F,#FE,#02,#21,#54,#10 ; #2f70 ..0..08.:./..!T.
db #CB,#FE,#C0,#CB,#BE,#C9,#00,#03,#07,#08,#96


lab2F8B ld a,166
    call lab4AC2
    ld ix,lab2FD5
    call lab30BC
    ld b,8
lab2F99 push bc
    ld a,b
    dec a
    call lab307E
    pop bc
    push bc
    ld a,b
    dec a
    call lab0A56
    pop bc
    djnz lab2F99
lab2FA9 call lab3094
    jr c,lab2FA9
    ret nz
    ld a,168
    call lab4AC2
    ld a,(ix+0)
    add a,(ix+4)
    call lab4AC2
    ld a,2
    call lab4AC2
    ld a,(ix+0)
    call lab307E
    ld a,(ix+0)
    call lab0A85
    ld a,167
    call lab4AC2
    jr lab2FA9

lab2FD5
db #00,#08,#00,#85,#8E,#3E,#AA,#CD,#C2,#4A,#DD 
db #21,#F1,#2F,#CD,#BC,#30,#CD,#9F,#30,#38,#FB,#DD,#7E,#00,#C3,#05 ; #2fe0 !./..0..08..~...
db #02,#01,#02,#05,#09,#9E,#3A,#94,#41,#FE,#01,#D8,#3E,#AB,#CD,#C2 ; #2ff0 ......:.A...>...
db #4A,#DD,#21,#1B,#30,#DD,#36,#00,#00,#CD,#BC,#30,#CD,#9F,#30,#38 ; #3000 J.!.0.6....0..08
db #FB,#DD,#7E,#00,#FE,#02,#CA,#24,#2F,#1F,#C9,#00,#03,#09,#09,#A0 ; #3010 ..~....$/.......
lab3020 call lab0BA5    
    call fancy_clear    
    ld a,186
    call lab4AC2
    call lab2F5A
    call lab43CF
    push hl
lab3032 ld a,(lab3DEA)
    or 224
lab3037 inc a
    ld a,196
    jr z,lab3049
lab303C ld a,h
    add a,16
lab303F jr nc,lab3042
    ld a,h
lab3042 rlca 
    rlca 
    rlca 
    and 7
    add a,191
lab3049 call lab4AC2
    ld a,187
    call lab4AC2
    call lab439E
    call lab4BB3
    ld a,188
    call lab4AC2
    pop de
    call lab4BB3
    ld a,189
    call lab4AC2
    call lab4399
    ld a,e
    call lab4BC4
    ld a,190
    call lab4AC2
lab3071 call lab0BA5
    call lab0A3C
    jr c,lab3071
    ld b,192
lab307B jp lab0D91
lab307E add a,a
lab307F add a,(ix+3)
    and 127
    ld b,a
    ld c,11
    push bc
    call lab4B7C
lab308B ld a,2
    call lab4AC2
    pop bc
    jp lab4B7C
lab3094 call lab0A3C
    ret c
    ld a,c
    cp 1
    jr nz,lab30A4
    and a
    ret 
lab309F call lab0A3C
    ret c
    ld a,c
lab30A4 and a
    ret z
    ld a,(ix+0)
    inc a
    cp (ix+1)
    jr c,lab30B0
    xor a
lab30B0 ld (ix+0),a
lab30B3 push ix
    ld b,136
    call lab0D91
    pop ix
lab30BC ld b,(ix+3)
    res 7,b
    ld c,(ix+2)
    ld (lab2F16),bc
    call lab4B7C
    ld b,(ix+1)
lab30CE ld c,(ix+0)
    inc c
lab30D2 ld a,175
    dec c
    push bc
    jr nz,lab30EE
    bit 7,(ix+3)
    jr nz,lab30E7
    ld a,4
lab30E0 call lab4AC2
    ld a,174
    jr lab30EE
lab30E7 ld a,3
    call lab4AC2
    ld a,174
lab30EE call lab4AC2
    ld a,(ix+1)
    pop bc
    push bc
    sub b
    add a,(ix+4)
    call lab4AC2
    pop hl
lab30FE push hl
    ld bc,(lab2F16)
    ld a,l
    and a
    jr nz,lab310E
    bit 7,(ix+3)
lab310B jr nz,lab310E
    inc b
lab310E inc b
    push bc
    call lab4B7C
    ld a,3
    call lab4AC2
lab3118 bit 7,(ix+3)
    jr nz,lab3123
    ld a,2
    call lab4AC2
lab3123 pop bc
    inc b
    ld (lab2F16),bc
    call lab4B7C
    pop bc
    djnz lab30D2
    scf
    ret 
lab3131 

db #FF,"PLAY",#FF,#05,#01,#FF,#05,#02,#FF,#05,#03,#FF ; #3130 
db " THE ",#FF,"GAME",#FF,"SELEC" ; #3140  
db "T",#FF,"KEY",#FF,"ANY ",#87,#FF,"SENS" ; #3150 
db "ITIVITY",#FF,#82,"PRESS ",#FF ; #3160 
db #82,#20,#54,#4F,#20,#FF,#83,#E0,#FF,#83,#53,#48,#49,#46,#54,#FF ; #3170 . TO .....SHIFT.
db #4C,#45,#46,#54,#FF,#52,#49,#47,#48,#54,#FF,#44,#4F,#57,#4E,#FF ; #3180 LEFT.RIGHT.DOWN.
db #55,#50,#FF,#4A,#55,#4D,#50,#FF,#43,#41,#52,#52,#59,#FF,#46,#49 ; #3190 UP.JUMP.CARRY.FI
db #52,#45,#FF,#53,#57,#4F,#50,#FF,#4C,#4F,#54,#53,#20,#4F,#46,#20 ; #31a0 RE.SWOP.LOTS OF
db #49,#54,#FF,#4E,#4F,#54,#20,#53,#4F,#20,#4D,#55,#43,#48,#FF,#50 ; #31b0 IT.NOT SO MUCH.P
db #41,#52,#44,#4F,#4E,#FF,#00,#C5,#A3,#FF,#80,#84,#85,#FF,#86,#84 ; #31c0 ARDON...........
db #87,#53,#FF,#41,#44,#4A,#55,#53,#54,#84,#53,#4F,#55,#4E,#44,#FF ; #31d0 .S.ADJUST.SOUND.
db #43,#4F,#4E,#54,#52,#4F,#4C,#20,#89,#FF,#48,#49,#47,#48,#20,#89 ; #31e0 CONTROL ..HIGH .
db #FF,#4C,#4F,#57,#20,#89,#FF,#4F,#4C,#44,#20,#85,#FF,#4E,#45,#57 ; #31f0 .LOW ..OLD ..NEW
db #20,#85,#FF,#4D,#41,#49,#4E,#20,#4D,#45,#4E,#55,#FF,#B9,#02,#15 ; #3200  ..MAIN MENU....
db #8A,#83,#88,#8B,#4D,#4F,#56,#45,#20,#43,#55,#52,#53,#4F,#52,#06 ; #3210 ....MOVE CURSOR.
db #01,#17,#20,#8A,#8C,#8B,#86,#20,#4F,#50,#54,#49,#4F,#4E,#02,#FF ; #3220 .. .... OPTION..
db #06,#05,#03,#8A,#8D,#8B,#C8,#02,#FF,#06,#05,#03,#8A,#8C,#8B,#C8 ; #3230 ................
db #02,#FF,#B0,#08,#00,#81,#9B,#A7,#FF,#A3,#06,#05,#03,#8A,#81,#8D ; #3240 ................
db #8B,#C8,#02,#FF,#06,#05,#03,#02,#06,#01,#15,#02,#06,#01,#17,#8A ; #3250 ................
db #83,#87,#53,#82,#20,#52,#45,#51,#55,#49,#52,#45,#44,#20,#46,#4F ; #3260 ..S. REQUIRED FO
db #52,#20,#83,#FF,#B0,#08,#00,#82,#9C,#A3,#06,#06,#03,#05,#00,#4D ; #3270 R .............M
db #55,#53,#49,#43,#20,#42,#59,#20,#47,#55,#59,#20,#53,#54,#45,#56 ; #3280 USIC BY GUY STEV
db #45,#4E,#53,#FF,#B0,#06,#00,#82,#9D,#A3,#FF,#B0,#09,#00,#82,#9A ; #3290 ENS.............
db #A3,#FF,#04,#82,#06,#03,#03,#8A,#83,#8D,#8B,#C8,#20,#85,#06,#04 ; #32a0 ............ ...
db #06,#8A,#83,#88,#8B,#52,#45,#53,#54,#41,#52,#54,#FF,#20,#20,#20 ; #32b0 .....RESTART.
db #FF,#83,#21,#22,#AD,#FF,#03,#81,#23,#24,#AD,#FF,#00,#07,#09,#04 ; #32c0 ..!"....#$......
db #06,#FF,#B9,#05,#14,#FF,#B9,#19,#14,#FF,#B9,#19,#17,#FF,#B9,#05 ; #32d0 ................
db #17,#FF,#04,#06,#12,#16,#FF,#04,#06,#0C,#16,#FF,#B9,#01,#11,#FF ; #32e0 ................
db #03,#82,#06,#1A,#13,#26,#06,#1A,#16,#82,#27,#06,#06,#13,#82,#25 ; #32f0 .....&....''....%
db #06,#06,#16,#82,#27,#FF,#03,#06,#FF,#C5,#06,#0A,#08,#82,#04,#05 ; #3300 ....''...........
db #00,#FF,#B9,#06,#11,#81,#45,#58,#50,#4C,#4F,#52,#45,#44,#20,#FF ; #3310 ......EXPLORED .
db #20,#52,#4F,#4F,#4D,#53,#06,#09,#0E,#82,#53,#43,#4F,#52,#45,#20 ; #3320  ROOMS....SCORE
db #FF,#30,#06,#05,#14,#83,#4C,#49,#42,#45,#52,#41,#54,#45,#44,#20 ; #3330 .0....LIBERATED
db #FF,#20,#50,#4C,#41,#4E,#45,#54,#53,#FF,#20,#20,#44,#55,#4D,#4D ; #3340 . PLANETS.  DUMM
db #59,#FF,#20,#20,#4E,#4F,#56,#49,#43,#45,#FF,#20,#20,#20,#53,#50 ; #3350 Y.  NOVICE.   SP
db #59,#20,#20,#20,#20,#FF,#4D,#41,#53,#54,#45,#52,#20,#53,#50,#59 ; #3360 Y    .MASTER SPY
db #FF,#20,#20,#20,#48,#45,#52,#4F,#FF,#20,#45,#4D,#50,#45,#52,#4F ; #3370 .   HERO. EMPERO
db #52,#FF,#07,#0A,#04,#06,#08,#00,#82,#48,#45,#41,#44,#20,#20,#20 ; #3380 R........HEAD
db #20,#20,#20,#48,#45,#45,#4C,#53,#B9,#0C,#01,#05,#00,#20,#4F,#56 ; #3390    HEELS..... OV
db #45,#52,#20,#06,#01,#00,#20,#20,#20,#20,#06,#01,#02,#20,#20,#20 ; #33a0 ER ...    ...
db #20,#20,#20,#06,#19,#00,#20,#20,#20,#20,#20,#20,#06,#18,#02,#20 ; #33b0    ...      ...
db #20,#20,#20,#20,#20,#20,#20,#FF,#00,#07,#06,#06,#05,#00,#04,#83 ; #33c0        .........
db #84,#C7,#20,#45,#4D,#50,#49,#52,#45,#03,#06,#03,#09,#81,#45,#47 ; #33d0 .. EMPIRE.....EG
db #59,#50,#54,#55,#53,#06,#15,#17,#42,#4F,#4F,#4B,#20,#57,#4F,#52 ; #33e0 YPTUS...BOOK WOR
db #4C,#44,#06,#03,#17,#53,#41,#46,#41,#52,#49,#06,#14,#09,#50,#45 ; #33f0 LD...SAFARI...PE
db #4E,#49,#54,#45,#4E,#54,#49,#41,#52,#59,#06,#0B,#10,#C7,#FF,#42 ; #3400 NITENTIARY.....B
db #4C,#41,#43,#4B,#54,#4F,#4F,#54,#48,#FF,#46,#49,#4E,#49,#53,#48 ; #3410 LACKTOOTH.FINISH
db #FF,#B6,#05,#00,#46,#52,#45,#45,#44,#4F,#4D,#20,#FF,#00,#07,#06 ; #3420 ....FREEDOM ....
db #B9,#00,#0A,#82,#84,#50,#45,#4F,#50,#4C,#45,#20,#53,#41,#4C,#55 ; #3430 .....PEOPLE SALU
db #54,#45,#20,#59,#4F,#55,#52,#20,#48,#45,#52,#4F,#49,#53,#4D,#06 ; #3440 TE YOUR HEROISM.
db #08,#0C,#41,#4E,#44,#20,#50,#52,#4F,#43,#4C,#41,#49,#4D,#20,#59 ; #3450 ..AND PROCLAIM Y
db #4F,#55,#04,#06,#0B,#10,#05,#00,#C4,#FF ; OU
lab346A
db #ED,#4B,#0E,#01,#21,#90 ; #3460 
db #34,#CD,#79,#34,#ED,#53,#0E,#01,#C9,#CD,#86,#34,#28,#08,#D5,#CD ; #3470 
db #86,#34,#D1,#20,#F4,#C9,#79,#5E,#23,#56,#23,#BB,#C0,#78,#BA,#C9 ; #3480 
db #40,#8A,#50,#71,#40,#89,#80,#04,#70,#BA,#00,#13,#00,#41,#80,#29 ; #3490 
db #00,#A1,#00,#26,#00,#81,#80,#E9,#00,#84,#00,#B1,#00,#85,#20,#EF ; #34a0 
db #00,#A4,#F0,#00,#00,#A5,#D0,#88,#D0,#BC,#D0,#DE,#B0,#2D,#D0,#8B ; #34b0 
db #90,#11,#C0,#E1,#B0,#00,#C0,#E2,#B0,#10,#00,#C1,#F0,#8B,#F0,#00 ; #34c0 
db #30,#97,#20,#EF,#00,#1D,#00,#A8,#70,#BA,#00,#4E,#00,#88,#30,#1B ; #34d0 
db #00,#4C,#30,#39,#30,#8B,#30,#8D,#F5,#7D,#26,#00,#32,#38,#35,#CD ; #34e0 
db #FA,#35,#EB,#11,#C0,#B9,#D5,#01,#50,#01,#ED,#B0,#E1,#F1,#87,#C6 ; #34f0 
db #08,#FE,#39,#38,#02,#3E,#38,#47,#87,#80,#5F,#16,#00,#19,#EB,#21 ; #3500 
db #A8,#00,#19,#78,#ED,#44,#C6,#39,#47,#0E,#FC,#18,#13,#1A,#A1,#12 ; #3510 
db #13,#13,#13,#79,#2F,#B6,#77,#23,#23,#23,#A7,#CB,#11,#A7,#CB,#11 ; #3520 
	db #10,#EB,#AF,#32,#ED,#36,#C9

lab3537: db #04
LAB3538: db #00

fill_buff69
lab3539:
	ld hl,buf6900
lab353C 
    ld c,l
    ld a,1
    and a
lab3540 
    rra 
    rl c
    jr nz,lab3540
    ld (hl),a
    inc l
    jr nz,lab353C
    ret 

; code appelé souvent
lab354A 
	ld (lab3538),a
    and 127
    cp 16
    jr c,lab3587
    ld de,#0606
    ld h,18
    cp 84
    jr c,lab3561
    ld de,#0808
    ld h,20
lab3561 cp 24
    jr nc,lab3574
    ld a,(lab1CA2)
    and 2
    ld d,4
    ld h,12
    jr z,lab3574
    ld d,0
    ld h,16
lab3574 
    ld a,b
    add a,d
    ld l,a
    sub d
    sub h
    ld h,a
    ld a,c
    add a,e
    ld c,a
    sub e
    sub e
    ld b,a
    ld a,e
    and a
    rra 
    ld (lab3537),a
    ret 

lab3587:
 ld hl,(lab1D70+1)
    inc hl
    inc hl
    bit 5,(hl)
    ex af,af''
    ld a,(hl)
    sub 16
    cp 32
    ld l,4
    jr nc,lab359A
    ld l,8
lab359A ld a,b
    add a,l
    ld l,a
    sub 56
    ld h,a
    ex af,af''
    ld a,c
    ld b,8
    jr nz,lab35A8
    ld b,4
lab35A8 add a,b
    ld c,a
    sub 12
    ld b,a
    ld a,3
    ld (lab3537),a
    ret 

lab35b3:
	ld a,(lab3538)
    and 127
    cp 84
    jp nc,lab367C
    cp 24
    jr nc,lab363F
    cp 16
    ld h,0
    jr nc,lab3612
    ld l,a
    ld de,(lab1D70+1)
    inc de
    inc de
    ld a,(de)
    or 252
    inc a
    jr nz,lab35FA
    ld a,(lab3538)
    ld c,a
    rla 
    ld a,(lab1EB9)
    jr c,lab35E2
    cp 6
    jr lab35E4
lab35E2 cp 3
lab35E4 jr z,lab35FA
    ld a,(lab36ED)
    xor c
    rla 
    ld de,labB9BF+1
    ld hl,labBA68
    ret nc
    ld a,c
    ld (lab36ED),a
    ld b,112
    jr lab3660
lab35FA ld a,l
    ld e,a
    add a,a
    add a,a
    add a,e
    add a,a
lab3600 ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,e
    add a,h
    ld h,a
    ld de,lab8270
    add hl,de
    ld de,#A8
    ld b,112
    jr lab3658

lab3612 
    sub 16
    ld l,a
    add a,a
    add a,l
    ld l,a
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,lab8A50
    add hl,de
    ld de,#60
    ld b,64
    ex de,hl
    add hl,de
    exx
    call lab36BE
    exx
    call nc,lab3660
    ld a,(lab1CA2)
lab3634 and 2
    ret nz
lab3637 
    ld bc,#30
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl
    ret 
    
lab363F sub 24
    ld d,a
    ld e,0
    ld h,e
    add a,a
    add a,a
    ld l,a
    add hl,hl
    add hl,hl
    srl d
    rr e
    add hl,de
    ld de,lab8BD0
    add hl,de
    ld de,#48
    ld b,48
lab3658 ex de,hl
    add hl,de
    exx
    call lab36BE
    exx
    ret c
lab3660 push hl
    push de
    ex de,hl
    ld d,105
lab3665 ld c,(hl)
    ld (lab3670+1),hl
    inc hl
    ld e,(hl)
    ld a,(de)
    ld (hl),a
    inc hl
    ld e,(hl)
    ld a,(de)
lab3670 ld (0),a
    ld e,c
    ld a,(de)
    ld (hl),a
    inc hl
    djnz lab3665
    pop de
    pop hl
    ret 
    
lab367C sub 84
    ld d,a
    rlca 
    rlca 
    ld h,0
    ld l,a
    ld e,h
    add hl,hl
    add hl,hl
    add hl,hl
    ex de,hl
    sbc hl,de
    ld de,labAA30
    add hl,de
    ld de,#70
    ld b,56
    ex de,hl
    add hl,de
    exx
    call lab36BE
    exx
    ret c
    push hl
    push de
    ex de,hl
    ld d,105
lab36A1 ld c,(hl)
    ld (lab36B2+1),hl
    inc hl
    ld e,(hl)
    inc hl
    ld a,(de)
    ld e,(hl)
    ld (hl),a
    dec hl
    ld a,(de)
    ld (hl),a
    inc hl
    inc hl
    ld e,(hl)
    ld a,(de)
lab36B2 ld (0),a
    ld e,c
    ld a,(de)
    ld (hl),a
    inc hl
    djnz lab36A1
    pop de
    pop hl
    ret 
lab36BE 

db #3A,#38 ; #36b0 ^.2..Y.w#.....:8
db #35,#4F,#E6,#07,#3C,#47,#3E,#01,#0F,#10,#FD,#47,#79,#1F,#1F,#1F ; #36c0 5O..<G>....Gy...
db #E6,#0F,#5F,#16,#00,#21,#E0,#70,#19,#78,#A6,#28,#08,#CB,#11,#D8 ; #36d0 .._..!.p.x.(....
db #78,#2F,#A6,#77,#C9,#CB,#11,#3F,#D8,#78,#B6,#77,#C9
lab36ED:
db #00,#0B,#23 ; #36e0 x/.w...?.x.w...#
db #FF,#00,#3D,#8E,#3D,#FD,#36,#09,#00,#6F,#5F,#16,#00,#62,#29,#19 ; #36f0 ..=.=.6..o_..b).
db #11,#C9,#38,#19,#46,#23,#7E,#E6,#3F,#FD,#77,#0A,#7E,#23,#07,#07 ; #3700 ..8.F#~.?.w.~#..
db #E6,#03,#28,#13,#C6,#F1,#5F,#CE,#36,#93,#57,#1A,#FD,#CB,#09,#EE ; #3710 ..(..._.6.W.....
db #CB,#56,#28,#03,#48,#47,#79,#32,#F1,#36,#78,#CD,#4E,#37,#7E,#F6 ; #3720 .V(.HGy2.6x.N7~.
db #9F,#3C,#7E,#20,#06,#FD,#CB,#09,#FE,#E6,#BF,#E6,#FB,#FE,#80,#CB ; #3730 .<~ ............
db #BF,#FD,#77,#FF,#FD,#36,#FE,#02,#D8,#FD,#CB,#09,#E6,#C9,#FD,#36 ; #3740
db #0F,#00,#FD,#77,#08,#FE,#80,#D8,#87,#87,#87,#FD,#77,#0F,#E5,#CD ; #3750
db #AB,#37,#E1,#C9 ; #3760 
lab3764:
 db #ED,#53,#EE,#36,#D5,#FD,#E1,#3D,#87,#C6,#7F,#6F 
db #CE,#38,#95,#67,#7E,#23,#66,#6F,#AF,#32,#E8,#4B,#FD,#7E,#0B,#32 ; #3770 .8.g~#fo.2.K.~.2
db #F0,#36,#FD,#36,#0B,#FF,#FD,#CB,#09,#76,#C0,#E9,#FD,#CB,#09,#6E ; #3780 .6.6.....v.....n
db #28,#19,#CD,#AB,#37,#08,#FD,#4E,#10,#11,#12,#00,#FD,#E5,#FD,#19 ; #3790 (...7..N........
db #CD,#9D,#50,#CD,#AB,#37,#FD,#E1,#D8,#08,#C9,#FD,#4E,#0F,#79,#E6 ; #37a0 ..P..7......N.y.
db #F8,#FE,#08,#3F,#D0,#0F,#0F,#D6,#02,#C6,#F3,#6F,#CE,#37,#95,#67 ; #37b0 ...?.......o.7.g
db #79,#3C,#E6,#07,#47,#86,#5F,#23,#8E,#93,#57,#1A,#A7,#20,#07,#06 ; #37c0 y<..G._#..W.. ..
db #00,#7E,#2B,#6E,#67,#7E,#FD,#77,#08,#78,#A9,#E6,#07,#A9,#FD,#77 ; #37d0 .~+ng~.w.x.....w
db #0F,#E6,#F0,#FE,#80,#0E,#02,#28,#04,#FE,#90,#0E,#01,#79,#CC,#1C ; #37e0 .......(.....y..
db #2B,#37,#C9,#31,#38,#36,#38,#38,#38,#3A,#38,#3A,#38,#3F,#38,#3F ; #37f0 +7.186888:8:8?8?
db #38,#44,#38,#44,#38,#47,#38,#47,#38,#4D,#38,#52,#38,#57,#38,#57 ; #3800 8D8D8G8G8M8R8W8W
db #38,#5E,#38,#60,#38,#62,#38,#62,#38,#67,#38,#67,#38,#6A,#38,#6C ; #3810 8^8`8b8b8g8g8j8l
db #38,#6E,#38,#70,#38,#72,#38,#74,#38,#76,#38,#78,#38,#7A,#38,#7A ; #3820 8n8p8r8t8v8x8z8z
db #38,#A4,#24,#25,#26,#00,#10,#00,#11,#00,#24,#25,#25,#24,#00,#2D ; #3830 8.$%&.....$%%$.-
db #2D,#2E,#2E,#00,#57,#D7,#00,#2B,#2B,#2C,#2B,#2C,#00,#32,#32,#33 ; #3840 -...W..++,+,.223
db #33,#00,#34,#34,#35,#35,#00,#26,#25,#26,#A6,#A5,#A6,#00,#36,#00 ; #3850 3.4455.&%&....6.
db #37,#00,#38,#39,#B9,#B8,#00,#3A,#BA,#00,#3B,#00,#3C,#00,#3E,#00 ; #3860 7.89...:..;.<.>.
db #3F,#00,#40,#00,#41,#00,#42,#00,#43,#00,#44,#45,#C5,#C4,#00,#DC ; #3870 ?.@.A.B.C.DE....
db #4D,#46,#4D,#4A,#4D,#4E,#4D,#52,#4D,#F3,#4D,#F8,#4D,#FD,#4D,#11 ; #3880 MFMJMNMRM.M.M.M.
db #4E,#86,#4C,#02,#4E,#07,#4E,#0C,#4E,#D6,#4C,#16,#4E,#82,#4E,#80 ; #3890 N.L.N.N.N.L.N.N.
db #4D,#31,#4D,#3B,#4D,#66,#4D,#ED,#4D,#E7,#4D,#2E,#4D,#63,#4D,#76 ; #38a0 M1M;MfM.M.M.McMv
db #4C,#CF,#4D,#18,#4C,#98,#4D,#FB,#4B,#EB,#4B,#5C,#4D,#5E,#4C,#36 ; #38b0 L.M.L.M.K.K\M^L6
db #4F,#92,#4D,#3F,#4C,#29,#4C,#1B,#4E,#88,#1B,#01,#2B,#1C,#40,#31 ; #38c0 O.M?L)L.N...+.@1
db #00,#02,#4A,#01,#40,#9E,#17,#00,#5D,#00,#01,#56,#02,#11,#56,#03 ; #38d0 ..J.@...]..V..V.
db #11,#56,#04,#01,#56,#05,#01,#46,#01,#40,#4B,#01,#40,#90,#8F,#6C ; #38e0 .V..V..F.@K.@..l
db #4C,#0A,#00,#58,#00,#21,#5E,#00,#21,#30,#0E,#00,#94,#09,#60,#96 ; #38f0 L..X.!^.!0....`.
db #4F,#6C,#9A,#DD,#0C,#49,#1E,#00,#5A,#01,#01,#5F,#00,#01,#5F,#14 ; #3900 Ol...I..Z.._.._.
db #01,#48,#00,#00,#92,#0B,#60,#31,#18,#02,#82,#06,#68,#84,#CC,#6C ; #3910 .H....`1....h..l
db #47,#0A,#20,#5C,#1F,#01,#55,#15,#01,#96,#CD,#6C,#5B,#00,#21,#5D ; #3920 G. \..U....l[.!]
db #14,#01,#59,#14,#01,#59,#00,#01,#3D,#20,#60,#92,#21,#60,#9E,#12 ; #3930 ..Y..Y..= `.!`..
db #00,#55,#01,#01,#5F,#13,#01,#8C,#07,#60,#5A,#16,#01,#5D,#08,#01 ; #3940 .U.._....`Z..]..
db #55,#23,#01,#9C,#CD,#6C,#42,#00,#20,#47,#0A,#00,#2D,#00,#20,#56 ; #3950 U#...lB. G..-. V
db #14,#01,#5D,#0A,#01,#5D,#01,#01,#98,#4F,#6C,#98,#CD,#6C,#82,#08 ; #3960 ..]..]...Ol..l..
db #68,#36,#00,#20,#37,#00,#20,#1E,#00,#00,#18,#00,#00,#4C,#24,#00 ; #3970 h6. 7. ......L$.
db #4C,#A5,#2C,#84,#21,#60,#1B,#00,#40,#6A,#A9,#39,#AB,#39,#00,#00 ; #3980 L.,.!`..@j.9.9..
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #3990 ................
db #00,#00,#00,#40,#6A,#A9,#39,#AB,#39,#00,#00 ; #39a0 

LAB39AB: db #00,#00,#00,#00,#00 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#40,#6A,#00 ; #39b0 .............@j.
db #00,#32,#A2,#39,#87,#87,#C6,#A9,#6F,#CE,#39,#95,#67,#22,#A5,#39 ; #39c0 .2.9....o.9.g".9
db #23,#23,#22,#A7,#39,#C9,#21,#12,#00,#19,#E5,#EB,#01,#05,#00,#ED ; #39d0 ##".9.!.........
db #B0,#7E,#D6,#06,#12,#13,#23,#23,#CB,#6E,#20,#03,#2B,#ED,#A0,#E1 ; #39e0 .~....##.n .+...
db #C9,#E5,#C5,#23,#23,#CD,#03,#1E,#C1,#E1,#D0,#ED,#5B,#A3,#39,#D5 ; #39f0 ...##.......[.9.
db #ED,#B0,#ED,#53,#A3,#39,#E1,#E5,#FD,#E1,#FD,#CB,#04,#5E,#28,#2B ; #3a00 ...S.9.......^(+
db #01,#09,#00,#E5,#ED,#B0,#EB,#1A,#F6,#02,#77,#23,#36,#00,#11,#08 ; #3a10 ..........w#6...
db #00,#19,#22,#A3,#39,#FD,#CB,#09,#6E,#28,#0F,#FD,#E5,#11,#12,#00 ; #3a20 ..".9...n(......
db #FD,#19,#3A,#F1,#36,#CD,#4E,#37,#FD,#E1,#E1,#3A,#A2,#39,#3D,#FE ; #3a30 ..:.6.N7...:.9=.
db #02,#30,#23,#23,#23,#FD,#CB,#04,#5E,#28,#14,#E5,#CD,#5F,#3A,#D1 ; #3a40 .0###...^(..._:.
db #CD,#D6,#39,#E5,#CD,#31,#3B,#D9,#FD,#E5,#E1,#23,#23,#18,#51,#E5 ; #3a50 ..9..1;....##.Q.
db #CD,#31,#3B,#D9,#18,#47,#23,#23,#FD,#CB,#04,#5E,#28,#14,#E5,#CD ; #3a60 .1;..G##...^(...
db #82,#3A,#D1,#CD,#D6,#39,#E5,#CD,#31,#3B,#D9,#FD,#E5,#E1,#23,#23 ; #3a70 .:...9..1;....##
db #18,#2E,#E5,#CD,#31,#3B,#3E,#03,#08,#3A,#C4,#1E,#BA,#38,#19,#3A ; #3a80 ....1;>..:...8.:
db #C5,#1E,#BC,#38,#13,#3E,#04,#08,#3A,#C2,#1E,#3D,#BB,#30,#09,#3A ; #3a90 ...8.>..:..=.0.:
db #C3,#1E,#3D,#BD,#30,#02,#AF,#08,#D9,#08,#CD,#C1,#39,#2A,#A5,#39 ; #3aa0 ..=.0.......9*.9
db #22,#BF,#39,#7E,#23,#66,#6F,#B4,#28,#0D,#E5,#CD,#31,#3B,#CD,#A5 ; #3ab0 ".9~#fo.(...1;..
db #3B,#E1,#30,#EC,#A7,#20,#EC,#2A,#BF,#39,#D1,#7E,#ED,#A0,#4F,#7E ; #3ac0 ;.0.. .*.9.~..O~
db #12,#1B,#72,#2B,#73,#69,#67,#B1,#20,#05,#2A,#A7,#39,#23,#23,#2B ; #3ad0 ..r+sig. .*.9##+
db #1B,#ED,#A8,#7E,#12,#73,#23,#72,#C9,#E5,#CD,#F1,#3A,#E1,#C3,#66 ; #3ae0 ...~.s#r....:..f
db #3A,#FD,#CB,#04,#5E,#28,#09,#E5,#CD,#00,#3B,#D1,#21,#12,#00,#19 ; #3af0 :...^(....;.!...
db #5E,#23,#56,#23,#D5,#7A,#B3,#13,#13,#20,#04,#ED,#5B,#A5,#39,#7E ; #3b00 ^#V#.z... ..[.9~
db #ED,#A0,#4F,#7E,#12,#67,#69,#B1,#2B,#20,#04,#2A,#A7,#39,#23,#D1 ; #3b10 ..O~.gi.+ .*.9#.
db #72,#2B,#73,#C9,#CD,#2F,#3B,#E6,#08,#C8,#79,#D6,#06,#4F,#C9,#23 ; #3b20 r+s../;...y..O.#
db #23,#23,#23,#7E,#23,#4F,#08,#79,#CB,#57,#20,#42,#CB,#4F,#20,#1A ; #3b30 ###~#O.y.W B.O .
db #E6,#01,#C6,#03,#47,#87,#4F,#7E,#80,#57,#91,#5F,#23,#7E,#23,#80 ; #3b40 ....G.O~.W._#~#.
db #46,#67,#91,#6F,#78,#D6,#06,#4F,#08,#C9,#1F,#38,#11,#7E,#C6,#04 ; #3b50 Fg.ox..O...8.~..
db #57,#D6,#08,#5F,#23,#7E,#23,#46,#67,#6F,#24,#2D,#18,#E6,#56,#5A ; #3b60 W.._#~#Fgo$-..VZ
db #14,#1D,#23,#7E,#23,#C6,#04,#46,#67,#D6,#08,#6F,#18,#D6,#7E,#CB ; #3b70 ..#~#..Fg..o..~.
db #19,#38,#06,#5F,#C6,#04,#57,#18,#04,#57,#D6,#04,#5F,#23,#7E,#23 ; #3b80 .8._..W..W.._#~#
db #46,#CB,#19,#38,#06,#6F,#C6,#04,#67,#18,#04,#67,#D6,#04,#6F,#78 ; #3b90 F..8.o..g..g..ox
db #D6,#12,#4F,#08,#C9,#7D,#D9,#BC,#7D,#D9,#30,#03,#BC,#38,#37,#7B ; #3ba0 ..O..}..}.0..87{
db #D9,#BA,#7B,#D9,#30,#03,#BA,#38,#64,#79,#D9,#B8,#79,#D9,#30,#03 ; #3bb0 ..{.0..8dy..y.0.
db #B8,#38,#17,#7D,#83,#81,#6F,#CE,#00,#95,#67,#D9,#7D,#83,#81,#D9 ; #3bc0 .8.}..o...g.}...
db #5F,#CE,#00,#93,#57,#ED,#52,#3E,#FF,#C9,#7D,#83,#6F,#D9,#7D,#83 ; #3bd0 _...W.R>..}.o.}.
db #D9,#BD,#3F,#3E,#FF,#C9,#7B,#D9,#BA,#7B,#D9,#30,#03,#BA,#38,#26 ; #3be0 ..?>..{..{.0..8&
db #79,#D9,#B8,#79,#D9,#30,#03,#B8,#38,#15,#D9,#83,#D9,#6F,#CE,#00 ; #3bf0 y..y.0..8....o..
db #95,#67,#79,#83,#5F,#CE,#00,#93,#57,#ED,#52,#3F,#3E,#FF,#C9,#7B ; #3c00 .gy._...W.R?>..{
db #D9,#BB,#D9,#3E,#00,#C9,#79,#D9,#B9,#D9,#3E,#00,#C9,#79,#D9,#B8 ; #3c10 ...>..y...>..y..
db #79,#D9,#30,#03,#B8,#38,#14,#D9,#85,#D9,#5F,#CE,#00,#93,#57,#79 ; #3c20 y.0..8...._...Wy
db #85,#6F,#CE,#00,#95,#67,#ED,#52,#3E,#FF,#C9,#7D,#D9,#BD,#D9,#3E ; #3c30 .o...g.R>..}...>
db #00,#C9

lab3c42: 
db #00,#00,#00,#00,#00,#00,#00,#00,#CD,#82,#3D,#79,#D6,#06
db #4F,#80,#1F,#32,#46,#3C,#78,#ED,#44,#81,#1F,#32,#47,#3C,#78,#32 ; #3c50 O..2F<x.D..2G<x2
db #48,#3C,#C9,#32,#49,#3C,#CD,#85,#3C,#3A,#C0,#1E,#E6,#04,#C0,#06 ; #3c60 H<.2I<..<:......
db #04,#D9,#3E,#80,#32,#11,#3D,#CD,#82,#3D,#11,#02,#00,#FD,#7E,#FF ; #3c70 ..>.2.=..=....~.
db #FD,#96,#FD,#18,#1B,#3A,#C0,#1E,#E6,#08,#C0,#06,#08,#D9,#AF,#32 ; #3c80 .....:.........2
db #11,#3D,#CD,#82,#3D,#2D,#2D,#11,#FE,#FF,#FD,#7E,#FE,#FD,#96,#FC ; #3c90 .=..=--....~....
db #1F,#1F,#1F,#1F,#E6,#0F,#E5,#DD,#E1,#D9,#4F,#3A,#C1,#1E,#A0,#FE ; #3ca0 ..........O:....
db #01,#08,#3A,#BF,#1E,#47,#C6,#D8,#6F,#CE,#70,#95,#67,#22,#44,#3C ; #3cb0 ..:..G..o.p.g"D<
db #78,#87,#47,#87,#87,#C6,#A9,#6F,#CE,#3D,#95,#67,#22,#AB,#1E,#3E ; #3cc0 x.G....o.=.g"..>
db #80,#32,#AD,#1E,#3E,#9A,#80,#6F,#CE,#3D,#95,#67,#7E,#23,#66,#6F ; #3cd0 .2..>..o.=.g~#fo
db #22,#42,#3C,#3E,#FF,#08,#79,#F5,#D6,#04,#06,#01,#28,#0C,#06,#0F ; #3ce0 "B<>..y.....(...
db #3C,#28,#07,#06,#19,#3C,#28,#02,#06,#1F,#F1,#38,#06,#79,#87,#80 ; #3cf0 <(...<(....8.y..
db #47,#79,#08,#CD,#7A,#3D,#10,#FB,#41,#CB,#20,#08,#3D,#28,#32,#08 ; #3d00 Gy..z=..A. .=(2.
db #F6,#00,#DD,#77,#01,#D9,#79,#C6,#08,#DD,#71,#00,#4F,#DD,#19,#D9 ; #3d10 ...w..y...q.O...
db #CD,#7A

lab3d22:
	db #3D,#10,#E6,#D9,#DD,#E5,#E1,#7D,#FE,#40,#D0,#DD,#7E,#00 ; #3d20 .z=......}.@..~.

db #A7,#C0,#3A,#11,#3D,#F6,#05,#DD,#77,#01,#79,#D6,#10,#DD,#77,#00 ; #3d30 ..:.=...w.y...w.
db #C9,#D9,#3A,#49,#3C,#A7,#79,#28,#03,#C6,#10,#4F,#D6,#10,#DD,#77 ; #3d40 ..:I<.y(...O...w
db #00,#3A,#11,#3D,#F6,#04,#DD,#77,#01,#DD,#19,#DD,#77,#01,#79,#D6 ; #3d50 .:.=...w....w.y.
db #08,#DD,#77,#00,#C6,#18,#4F,#3A,#49,#3C,#A7,#28,#04,#79,#D6,#10 ; #3d60 ..w...O:I<.(.y..
db #4F,#DD,#19,#3E,#FF,#08,#D9,#05,#18,#A9,#C5,#06,#02,#CD,#B2,#22 ; #3d70 O..>..........."
db #C1,#C9,#FD,#7E,#FE,#57,#FD,#5E,#FF,#93,#C6,#80,#47,#1F,#1F,#E6 ; #3d80 ...~.W.^....G...
db #3E,#6F,#26,#6A,#3E,#07,#93,#92,#4F,#C9,#F0,#70,#90,#73,#30,#76 ; #3d90 >o&j>...O..p.s0v
db #F0,#77,#B0,#79,#30,#7D,#F0,#7E,#90,#81,#46,#91,#65,#94,#A1,#69 ; #3da0 .w.y0}.~..F.e..i
db #69,#AA,#49,#24,#51,#49,#12,#44,#92,#A4,#04,#10,#10,#41,#04,#00 ; #3db0 i.I$QI.D.....A..
db #44,#00,#04,#10,#10,#41,#04,#00,#10,#00,#4E,#31,#B4,#E7,#4E,#42 ; #3dc0 D....A....N1..NB
db #E4,#99,#45,#51,#50,#51,#54,#55,#55,#55,#64,#19,#65,#11,#A4,#41 ; #3dd0 ..EQPQTUUUd.e..A
db #28,#55,#00,#00,#00,#00,#00,#00,#00,#00,#00,#70,#14,#00,#72,#60 ; #3de0 (U.........p..r`
db #30,#01,#40,#B0,#2E,#09,#34,#B0,#00,#1A,#00,#F0,#9A,#0B,#70,#40 ; #3df0 0.@...4.......p@
db #A7,#1C
lab3e02:
	db #44,#30,#37,#7D,#37,#70,#15,#68,#34,#60,#89,#48,#47,#60 ; #3e00 
db #C5,#68,#76,#80,#1B,#68,#76,#D0,#BC,#28,#35,#D0,#1C,#28,#71,#F0 ; #3e10 .hv..hv..(5..(q.
db #87,#38,#74,#20,#FB,#28,#71,#60,#31,#48,#05,#C0,#E2,#38,#54,#20 ; #3e20 .8t .(q`1H...8T
db #69,#68,#07,#60,#52,#62,#77,#60,#47,#72,#27,#C0,#E3,#42,#07,#F0 ; #3e30 ih.`Rbw`Gr''..B..
db #63,#12,#70,#20,#AA,#22,#05,#30,#6C,#22,#46,#60,#47,#73,#57,#80 ; #3e40 c.p .".0l"F`GsW.
db #FA,#63,#67,#F0,#70,#13,#60,#10,#7B,#73,#31,#60,#64,#74,#70,#80 ; #3e50 .cg.p.`.{s1`dtp.
db #1A,#44,#45,#F0,#46,#74,#74,#60,#C5,#66,#74,#70,#98,#76,#00,#00 ; #3e60 .DE.Ftt`.ftp.v..
db #32,#76,#50,#80,#29,#76,#40,#A0,#E0,#16,#40,#A0,#0F,#66,#47,#B0 ; #3e70 2vP.)v@...@..fG.
db #03,#26,#44,#F0,#83,#36,#17,#40,#8A,#06,#06,#20,#99,#76,#14,#60 ; #3e80 .&D..6.@... .v.`
db #C5,#65,#75,#60,#77,#75,#44,#00,#36,#75,#66,#A0,#FE,#75,#22,#F0 ; #3e90 .eu`wuD.6uf..u".
db #42,#65,#61,#20,#AE,#75,#04,#30,#8D,#7E,#47,#30,#8D,#6E,#17,#30 ; #3ea0 Bea .u.0.~G0.n.0
db #8D,#7E,#07,#30,#8D,#6E,#37,#30,#8D,#3E,#27,#27,#28,#29,#2A,#2A ; #3eb0 .~.0.n70.>''''()**
db #2A,#2A,#00,#86,#2F,#2F,#2F,#2F,#2F,#2F,#ED,#4B,#0E,#01,#21,#EB ; #3ec0 **..//////.K..!.
db #3D,#1E,#34,#79,#BE,#23,#20,#03,#78,#BE,#C8,#23,#23,#23,#1D,#20 ; #3ed0 =.4y.# .x..###.
db #F2,#1D,#C9,#23,#AF,#ED,#6F,#5F,#ED,#6F,#57,#ED,#6F,#23,#ED,#6F ; #3ee0 ...#..o_.oW.o#.o

db #47,#ED,#6F,#4F,#ED,#6F,#C9,#C5,#21,#A7,#3E,#3A,#EA,#3D,#2F,#06 ; #3ef0 G.oO.o..!.>:.=/.
db #05,#11,#04,#00,#CB,#1E,#1F,#CB,#16,#19,#10,#F8,#C1,#CD,#CE,#3E ; #3f00 ...............>
db #C0,#E5,#D5,#C5,#FD,#E5,#CD,#E3,#3E,#FD,#21,#98,#1E,#7A,#FE,#0E ; #3f10 ........>.!..z..
db #3E,#60,#20,#01,#AF,#FD,#77,#04,#FD,#72,#11,#FD,#36,#0A,#1A,#7A ; #3f20 >` ...w..r..6..z
db #C6,#BB,#6F,#CE,#3E,#95,#67,#7E,#C5,#D5,#CD,#4E,#37,#D1,#C1,#FD ; #3f30 ..o.>.g~...N7...
db #E1,#7B,#CD,#6E,#22,#CD,#CC,#20,#C1,#D1,#E1,#CD,#DB,#3E,#18,#C0 ; #3f40 .{.n".. .....>..
db #21,#EB,#3D,#11,#04,#00,#06,#34,#CB,#86,#19,#10,#FB,#C9,#57,#CD ; #3f50 !.=....4......W.
db #CA,#3E,#C0,#23,#7E,#2B,#E6,#0F,#BA,#28,#05,#CD,#DB,#3E,#18,#F2 ; #3f60 .>.#~+...(...>..
db #2B,#CB,#C6,#87,#C6,#89,#6F,#CE,#3F,#95,#67,#5E,#23,#66,#6B,#DD ; #3f70 +.....o.?.g^#fk.
db #21,#84,#3F,#E9,#06,#C5,#C3,#91,#0D,#A5,#3F,#A5,#3F,#B4,#3F,#C3 ; #3f80 !.?.......?.?.?.
db #3F,#CC,#3F,#D8,#3F,#DC,#3F,#00,#00,#25,#40,#14,#40,#14,#40,#14 ; #3f90 ?.?.?.?..%@.@.@.
db #40,#14,#40,#14,#40,#7A,#21,#7B,#24,#CD,#39,#41,#CD,#9C,#45,#06 ; #3fa0 @.@.@z!{$.9A..E.
db #C2,#C3,#91,#0D,#3A,#84,#24,#E6,#02,#C8,#3E,#06,#CD,#F2,#3F,#3E ; #3fb0 ....:.$...>...?>
db #02,#18,#E3,#3A,#84,#24,#E6,#02,#C8,#AF,#18,#26,#3A,#84,#24,#E6 ; #3fc0 ...:.$.....&:.$.
db #01,#C8,#18,#1E,#DD,#21,#E2,#3E,#0E,#02,#18,#02,#0E,#04,#3A,#84 ; #3fd0 .....!.>......:.
db #24,#FE,#03,#28,#06,#1F,#E6,#01,#81,#18,#07,#79,#F5,#CD,#F7,#3F ; #3fe0 $..(.......y...?
db #F1,#3C,#F5,#CD,#B2,#19,#F1,#CD,#78,#41,#CD,#66,#41

lab3FFD:
db #F5,#C5,#A7 ; #3ff0 .<......xA.fA...
db #3E,#81,#28,#02,#3E,#83,#CD,#C2,#4A,#C1,#79,#C6,#B1,#CD,#C2,#4A ; #4000 >.(.>...J.y....J
db #F1,#C3,#BF,#4B,#7A,#D6,#09,#21,#EA,#3D,#CD,#39,#41,#06,#C1,#CD ; #4010 ...Kz..!.=.9A...
db #91,#0D,#C3,#1D,#45,#06,#C2,#CD,#91,#0D,#CD,#2A,#41,#DD,#21,#EB ; #4020 ....E......*A.!.
db #3D,#11,#04,#00,#06,#06,#36,#80,#DD,#7E,#00,#DD,#19,#1F,#CB,#1E ; #4030 =.....6..~......
db #30,#F6,#23,#10,#F1,#EB,#21,#94,#41,#34,#21,#84,#24,#7E,#ED,#A0 ; #4040 0.#...!.A4!.$~..
db #21,#80,#24,#ED,#A0,#ED,#A0,#FE,#03,#28,#13,#21,#96,#24,#BE,#20 ; #4050 !.$......(.!.$.
db #0D,#21,#31,#BB,#01,#04,#00,#ED,#B0,#21,#10,#BB,#18,#0B,#21,#92 ; #4060 .!1......!....!.
db #24,#01,#04,#00,#ED,#B0,#21,#0E,#01,#ED,#A0,#ED,#A0,#21,#0E,#01 ; #4070 $.....!......!..

db #ED,#A0,#ED,#A0,#C9
lab4085:
	db #21,#94,#41,#35,#CD,#2A,#41,#7E,#E6,#03,#32 ; #4085
db #7B,#24,#7E,#1F,#1F,#E6,#1F,#32,#EA,#3D,#E5,#DD,#E1,#21,#EB,#3D ; #4090 {$~....2.=...!.=
db #11,#04,#00,#06,#2F,#CB,#1E,#18,#0A,#CB,#1E,#DD,#CB,#00,#3E,#20 ; #40a0 ..../.........>
db #07,#DD,#23,#37,#DD,#CB,#00,#1E,#CB,#16,#19,#10,#EC,#DD,#E5,#E1 ; #40b0 ..#7............
db #23,#11,#84,#24,#7E,#ED,#A0,#11,#80,#24,#ED,#A0,#ED,#A0,#11,#58 ; #40c0 #..$~....$.....X
db #46,#ED,#A0,#CB,#47,#11,#B5,#24,#28,#03,#11,#C7,#24,#01,#03,#00 ; #40d0 F...G..$(...$...
db #ED,#B0,#11,#0E,#01,#ED,#A0,#ED,#A0,#FE,#03,#28,#16,#ED,#4B,#80 ; #40e0 ...........(..K.
db #24,#05,#FA,#03,#41,#0D,#FA,#03,#41,#EE,#03,#32,#10,#BB,#E5,#CD ; #40f0 $...A...A..2....
db #22,#23,#E1,#11,#0E,#01,#ED,#A0,#ED,#A0,#ED,#4B,#0E,#01,#CB,#C1 ; #4100 "#.........K....
db #CD,#CE,#3E,#CD,#E3,#3E,#7B,#08,#11,#5E,#42,#21,#5B,#42,#CD,#75 ; #4110 ..>..>{..^B![B.u
db #22,#3E,#08,#32,#58,#46,#32,#87,#24,#C9,#3A,#94,#41,#47,#04,#21 ; #4120 ">.2XF2.$.:.AG.!
db #83,#41,#11,#12,#00,#19,#10,#FD,#C9,#47,#04,#3E,#80,#07,#10,#FD ; #4130 .A.......G.>....
db #B6,#77,#C9,#CD,#78,#41,#CD,#6E,#41,#C8,#7E,#CD,#FD,#3F,#F6,#FF ; #4140 .w..xA.nA.~..?..
db #C9

lab4151:
    ld a,184
    call lab4AC2
    
    ld a,7
.loop 
    push af
    dec a
    call lab4178
    ld a,(hl)
    call lab3FFD
    pop af
    dec a				; TODO OPTIM: 1 dec en trop!
    jr nz,.loop
    ret 
lab4166

db #86,#27,#77,#D0,#3E,#99,#77,#C9,#7E,#A7 ; #4160 ?.= ...''w.>.w.~.
db #C8,#D6,#01,#27,#77,#F6,#FF,#C9 ; #4170 

lab4178:
db #4F,#06,#00,#21,#8D,#41,#09,#3A 
db #58,#46,#A7,#7E,#28,#02,#3E,#03,#21,#7C,#24,#09,#C9,#99,#10,#99 ; #4180 XF.~(.>.!|$.....
db #99,#02,#02,#06,#00,#FF,#21,#00,#F8,#CD,#41,#4D,#F6,#01,#D1,#C9 ; #4190 ......!...AM....
db #CD,#17,#28,#C3,#34,#6C,#CD,#67,#1D,#21,#DA,#76,#CD,#AD,#6A,#CD ; #41a0 ..(.4l.g.!.v..j.
db #87,#55,#CD,#67,#1D,#CD,#88,#43,#CD,#AF,#5F,#21,#00,#00,#22,#73 ; #41b0 .U.g...C.._!.."s
db #76,#C3,#67,#1D,#3A,#74,#76,#B7,#FA,#D6,#4B,#3A,#73,#76,#FE,#F3 ; #41c0 v.g.:tv...K:sv..
db #DA,#D6,#4B,#37,#C9,#E6,#7F,#E5,#21,#73,#76,#CD,#00,#00

lab41c2:
ds 27*16

lab438E:
db #21,#7B ; #4380 ..............!{
db #24,#CB,#96,#D9,#01,#01,#00,#18,#0C,#21,#EA,#3D,#18,#F5,#21,#61 ; #4390 $........!.=..!a
db #42,#D9,#01,#2D,#01,#D9,#11,#00,#00,#D9,#D9,#4E,#37,#CB,#11,#7B ; #43a0 B..-.......N7..{
db #CE,#00,#27,#5F,#7A,#CE,#00,#27,#57,#CB,#21,#20,#F2,#23,#D9,#0B ; #43b0 ..''_z..''W.! .#..
db #78,#B1,#20,#E6,#D9,#C9,#21,#61,#42,#01,#2D,#01,#C3,#67,#24 ; #43c0 x. ...!aB.-..g$
lab43CF:
db #CD 
db #5E,#01,#F5,#CD,#9E,#43,#F1,#21,#00,#00,#20,#0C,#21,#01,#05,#3A ; #43d0 ^....C.!.. .!..:
db #85,#24,#A7,#28,#03,#21,#02,#10,#01,#10,#00,#CD,#01,#44,#E5,#CD ; #43e0 .$.(.!.......D..
db #8E,#43,#E1,#01,#F4,#01,#CD,#01,#44,#E5,#CD,#99,#43,#E1,#01,#7C ; #43f0 .C......D...C..|
db #02,#7B,#85,#27,#6F,#7C,#8A,#27,#67,#0B,#78,#B1,#20,#F3,#C9 ; #4400 .{.''o|.''g.x. ...

lab440F:
	and 15
    add a,26
    ld l,a
    adc a,68
    sub l
    ld h,a
    ld a,(hl)
    ret 
    
db #FF,#00,#04,#FF,#06,#07 ; #441A
db #05,#06,#02,#01,#03,#02,#FF,#00,#04,#FF,#6F,#87,#85,#C6,#3A,#6F ; #4420 ..........o...:o
db #CE,#44,#95,#67,#4E,#23,#46,#23,#7E,#C9,#FF,#00,#0D,#FF,#FF,#09 ; #4430 .D.gN#F#~.......
db #00,#FF,#0B,#01,#FF,#0A,#01,#00,#0E,#01,#01,#06,#00,#01,#07,#FF ; #4440 ................
db #01,#05,#2A,#EE,#36,#E5,#CD,#2A,#44,#11,#0B,#00,#E1,#19,#AE,#E6 ; #4450 ..*.6..*D.......
db #0F,#AE,#77,#11,#FA,#FF,#19,#7E,#81,#77,#23,#7E,#80,#77,#C9,#34 ; #4460 ..w....~.w#~.w.4
db #7E,#85,#5F,#8C,#93,#57,#1A,#A7,#C0,#36,#01,#23,#7E,#C9,#7E,#34 ; #4470 ~._..W...6.#~.~4
db #87,#85,#5F,#8C,#93,#57,#13,#1A,#A7,#28,#05,#EB,#5F,#23,#56,#C9 ; #4480 .._..W...(.._#V.
db #36,#01,#23,#5E,#23,#56,#C9,#2A,#C8,#44,#55,#29,#ED,#6A,#4C,#2A ; #4490 6.#^#V.*.DU).jL*
db #C6,#44,#44,#CB,#10,#5C,#CB,#13,#CB,#12,#09,#22,#C6,#44,#2A,#C8 ; #44a0 .DD..\.....".D*.
db #44,#ED,#5A,#CB,#BC,#22,#C8,#44,#FA,#C2,#44,#21,#C6,#44,#34,#23 ; #44b0 D.Z..".D..D!.D4#
db #28,#FC,#2A,#C6,#44,#C9,#4A,#6F,#6E,#21,#E5,#E5,#FD,#E5,#E5,#FD ; #44c0 (.*.D.Jon!......
db #E1,#CD,#F1,#3A,#FD,#E1,#E1,#CD,#EE,#44,#DD,#E1,#DD,#CB,#04,#FE ; #44d0 ...:.....D......
db #3A,#10,#01,#DD,#4E,#0A,#A9,#E6,#80,#A9,#DD,#77,#0A,#C9,#FD,#E5 ; #44e0 :...N......w....
db #23,#23,#CD,#1E,#1E,#EB,#60,#69,#CD,#EE,#1C,#FD,#E1,#C9,#E5,#E5 ; #44f0 ##....`i........
db #FD,#E5,#E5,#FD,#E1,#CD,#66,#3A,#FD,#E1,#E1,#CD,#EE,#44,#DD,#E1 ; #4500 ......f:.....D..
db #DD,#CB,#04,#BE,#DD,#36,#0B,#FF,#DD,#36,#0C,#FF,#C9,#3A,#EA,#3D ; #4510 .....6...6...:.=
db #FE,#1F,#20,#14,#3E,#CA,#CD,#C2,#4A,#CD,#A5,#0B,#11,#0F,#04,#21 ; #4520 .. .>...J......!
db #18,#2F,#CD,#B1,#45,#CD,#5E,#45,#CD,#41,#45,#CD,#F8,#04,#C3,#92 ; #4530 ./..E.^E.AE.....
db #23
lab4541:
	ld a,198
    call lab4AC2
    call lab0BA5
    ld hl,lab457E
    ld de,#05FF
    call lab45B1
    ld hl,lab458D
    ld de,(lab3DEA)
    ld d,5
    call lab45B1
lab455E 
    call lab0A36
    call lab456C    
    call fancy_clear ; Effacement apres la page des niveaux
    ld b,193
    jp lab0D91
lab456C ld hl,labA800
lab456F push hl
    call lab0BA5
    call lab0A3C
    pop hl
    ret nc
    dec hl
    ld a,h
    or l
    jr nz,lab456F
    ret 
lab457E
db #4C,#54
db #78,#4C,#A4,#78,#4C,#54,#E8,#4C,#A4,#E8,#4C,#7C,#B0 ; #4580

lab458D: 
db #2F,#54,#60 
db #2F,#A4,#60,#2F,#54,#D0,#2F,#A4,#D0,#2F,#7C,#98,#CD,#39,#2C,#21 ; #4590 
db #CD,#45,#ED,#5B,#7B,#24,#16,#03,#CD,#B1,#45,#ED,#5B,#84,#24,#16 ; #45a0 
db #02
lab45b1: 
db #7E,#23,#4E,#23,#46,#23,#E5,#CB,#1B,#D5,#30,#09,#CD,#F3,#45 ; #45b0 .~#N#F#....0...E
db #D1,#E1,#15,#20,#EC,#C9,#16,#01,#CD,#DE,#45,#18,#F3,#27,#B0,#F0 ; #45c0 ... ......E..''..
db #28,#44,#F0,#29,#44,#D8,#98,#94,#F0,#1E,#60,#F0,#16,#03,#32,#38 ; #45d0 (D.)D.....`...28
db #35,#78,#D6,#48,#47,#D5,#C5,#CD,#B3,#35,#21,#0C,#18,#C1,#F1,#A7 ; #45e0 5x.HG....5!.....
db #C3,#B0,#08,#2E,#01,#2D,#2C,#28,#E3,#32,#38,#35,#CD,#1A,#46,#CD ; #45f0 .....-,(.285..F.
db #4E,#46,#CD,#B3,#35,#01,#00,#67,#D9,#06,#18,#CD,#DD,#14,#C3,#A7 ; #4600 NF..5..g........
db #05,#CD,#1A,#46,#CD,#4E,#46,#C3,#A7,#05 ; #4610 ...F.NF...a|..o"

lab461a: 
	ld h,c
    ld a,h
    add a,12
    ld l,a
    ld (lab1C98),hl
    ld a,b
    add a,24
    ld c,a
    ld (lab1C9A),bc
    ret 

    ld (lab3538),a
    call lab461A
    ld a,b
    add a,32
    ld (lab1C9A),a
    call lab464E
    ld a,2
    ld (lab1CA2),a
    call lab35B3
    ld bc,buf6700
    exx
    ld b,32
    call lab14DD
    jp lab05A7
lab464E 
    ld hl,buf6800
    ld bc,#0100
    jp fill_zero

lab4657 db #00
lab4658:
db #00,#00,#00,#00,#F5,#CD,#24,#3B ; #4650 h....g$.......$;
db #D9,#F1,#32,#5B,#46,#CD,#6C,#46,#3A,#5B,#46,#C9,#11,#8B,#46,#D5 ; #4660 ..2[F.lF:[F...F.
db #4F,#87,#87,#81,#C6,#B7,#6F,#CE,#47,#95,#67,#7E,#32,#57,#46,#23 ; #4670 O.....o.G.g~2WF#
db #5E,#23,#56,#23,#7E,#23,#66,#6F,#D5,#D9,#C9,#D9,#C8,#E5,#DD,#E1 ; #4680 ^#V#~#fo........
db #CB,#51,#20,#15,#21,#A9,#39,#7E,#23,#66,#6F,#B4,#28,#24,#E5,#CD ; #4690 .Q .!.9~#fo.($..
db #B2,#19,#E1,#38,#3B,#20,#F0,#18,#19,#21,#AB,#39,#7E,#23,#66,#6F ; #46a0 ...8; ...!.9~#fo
db #B4,#28,#09,#E5,#CD,#B2,#19,#E1,#38,#28,#20,#F0,#CD,#3B,#2B,#5D ; #46b0 .(......8( ..;+]
db #18,#06,#CD,#3B,#2B,#5D,#23,#23,#FD,#CB,#09,#46,#28,#04,#FD,#7D ; #46c0 ...;+]##...F(..}
db #BB,#C8,#3A,#AC,#24,#A7,#C8,#CD,#B2,#19,#D0,#CD,#3B,#2B,#23,#23 ; #46d0 ..:.$.......;+##
db #2B,#2B,#E5,#DD,#E1,#3A,#57,#46,#DD,#CB,#09,#4E,#28,#08,#DD,#A6 ; #46e0 ++...:WF...N(...
db #FA,#DD,#77,#FA,#18,#06,#DD,#A6,#0C,#DD,#77,#0C,#AF,#D6,#01,#F5 ; #46f0 ..w.......w.....
db #DD,#E5,#FD,#E5,#CD,#0D,#47,#FD,#E1,#DD,#E1,#F1,#C9,#FD,#CB,#09 ; #4700 ......G.........
db #46,#20,#0C,#DD,#CB,#09,#46,#28,#76,#FD,#E5,#DD,#E3,#FD,#E1,#FD ; #4710 F ....F(v.......
db #4E,#09,#FD,#46,#04,#DD,#CB,#04,#6E,#C8,#DD,#CB,#04,#76,#20,#43 ; #4720 N..F....n....v C
db #A7,#28,#05,#DD,#CB,#09,#66,#C0,#CB,#58,#06,#03,#20,#06,#05,#CB ; #4730 .(....f..X.. ...
db #51,#20,#01,#05,#AF,#21,#7E,#24,#BE,#28,#02,#CB,#80,#23,#BE,#28 ; #4740 Q ...!~$.(...#.(
db #02,#CB,#88,#78,#A7,#C8,#21,#5A,#46,#B6,#77,#2B,#7E,#A7,#C0,#3A ; #4750 ...x..!ZF.w+~..:
db #EA,#3D,#FE,#1F,#C8,#36,#0C,#3A,#58,#46,#A7,#C4,#D4,#3F,#06,#C6 ; #4760 .=...6.:XF...?..
db #C3,#91,#0D,#DD,#36,#0F,#08,#DD,#36,#04,#80,#DD,#7E,#0A,#E6,#80 ; #4770 ....6...6...~...
db #F6,#11,#DD,#77,#0A,#DD,#CB,#09,#B6,#DD,#7E,#11,#C3,#5E,#3F,#FD ; #4780 ...w......~..^?.
db #CB,#09,#5E,#20,#09,#DD,#CB,#09,#5E,#C8,#FD,#E5,#DD,#E1,#DD,#CB ; #4790 ..^ ....^.......
db #09,#4E,#28,#05,#11,#EE,#FF,#DD,#19,#DD,#CB,#09,#7E,#C8,#DD,#CB ; #47a0 .N(.........~...
db #09,#F6,#DD,#36,#0B,#FF,#C9,#FD,#FE,#48,#C4,#48,#FF,#DF,#47,#00 ; #47b0 ...6.....H.H..G.
db #00,#FB,#55,#49,#E2,#48,#FF,#00,#48,#00,#00,#FE,#A5,#49,#68,#48 ; #47c0 ..UI.H..H....IhH
db #FF,#24,#48,#00,#00,#F7,#ED,#49,#A9,#48,#FF,#47,#48,#00,#00,#D9 ; #47d0 .$H....I.H.GH...
db #E1,#D1,#AF,#CD,#65,#46,#38,#0E,#D9,#15,#1D,#D9,#3E,#02,#CD,#65 ; #47e0 ....eF8.....>..e
db #46,#3E,#01,#D0,#AF,#C9,#3E,#02,#CD,#65,#46,#D8,#A7,#3E,#02,#C9 ; #47f0 F>....>..eF..>..
db #D9,#E1,#D1,#3E,#04,#CD,#65,#46,#38,#10,#D9,#14,#1C,#D9,#3E,#02 ; #4800 ...>..eF8.....>.
db #CD,#65,#46,#3E,#03,#D0,#3E,#04,#A7,#C9,#3E,#02,#CD,#65,#46,#D8 ; #4810 .eF>..>...>..eF.
db #A7,#3E,#02,#C9,#D9,#E1,#D1,#3E,#04,#CD,#65,#46,#38,#10,#D9,#14 ; #4820 .>.....>..eF8...
db #1C,#D9,#3E,#06,#CD,#65,#46,#3E,#05,#D0,#3E,#04,#A7,#C9,#3E,#06 ; #4830 ..>..eF>..>...>.
db #CD,#65,#46,#D8,#3E,#06,#C9,#D9,#E1,#D1,#AF,#CD,#65,#46,#38,#0E ; #4840 .eF.>.......eF8.
db #D9,#15,#1D,#D9,#3E,#06,#CD,#65,#46,#3E,#07,#D0,#AF,#C9,#3E,#06 ; #4850 ....>..eF>....>.
db #CD,#65,#46,#D8,#A7,#3E,#06,#C9,#23,#23,#CD,#90,#4A,#7E,#91,#D9 ; #4860 .eF..>..##..J~..
db #BA,#D9,#38,#31,#20,#1D,#23,#7E,#90,#D9,#BC,#7D,#D9,#30,#26,#90 ; #4870 ..81 .#~...}.0&.
db #BE,#30,#22,#23,#D9,#79,#D9,#BE,#30,#1B,#7E,#93,#D9,#B8,#D9,#30 ; #4880 .0"#.y..0.~....0
db #14,#37,#C9,#23,#7E,#90,#D9,#BC,#D9,#38,#0A,#23,#7E,#93,#D9,#B8 ; #4890 .7.#~....8.#~...
db #D9,#38,#02,#AF,#C9,#3E,#FF,#A7,#C9,#23,#23,#CD,#90,#4A,#7E,#91 ; #48a0 .8...>...##..J~.
db #D9,#BA,#7B,#D9,#30,#DD,#91,#BE,#30,#EB,#23,#7E,#90,#D9,#BC,#D9 ; #48b0 ..{.0...0.#~....
db #28,#C1,#18,#E1,#CD,#90,#4A,#D9,#7B,#D9,#91,#BE,#38,#D7,#23,#28 ; #48c0 (.....J.{...8.#(
db #A6,#D9,#7D,#D9,#90,#BE,#38,#CD,#23,#7E,#83,#D9,#B8,#D9,#30,#C5 ; #48d0 ..}...8.#~....0.
db #AF,#C9,#CD,#90,#4A,#D9,#7B,#D9,#91,#BE,#23,#30,#E4,#2B,#7E,#91 ; #48e0 ....J.{...#0.+~.
db #D9,#BA,#7D,#D9,#30,#AF,#23,#90,#BE,#CA,#83,#48,#18,#A7,#CD,#7D ; #48f0 ..}.0.#....H...}
db #4A,#28,#33,#CD,#35,#4A,#3E,#24,#38,#2F,#DD,#CB,#FF,#46,#28,#14 ; #4900 J(3.5J>$8/...F(.
db #3A,#F1,#1E,#CD,#69,#4A,#38,#1E,#CD,#59,#4A,#38,#20,#3A,#C2,#1E ; #4910 :...iJ8..YJ8 :..
db #D6,#04,#18,#09,#DD,#CB,#FE,#46,#28,#0C,#3A,#C2,#1E,#BB,#C0,#3E ; #4920 .......F(.:....>
db #01,#32,#58,#46,#37,#C9,#3A,#C2,#1E,#BB,#C0,#37,#C9,#CD,#61,#4A ; #4930 .2XF7.:....7..aJ
db #38,#F4,#CD,#36,#49,#C0,#7D,#FE,#25,#3E,#F7,#38,#02,#3E,#FB,#32 ; #4940 8..6I.}.%>.8.>.2
db #AF,#24,#AF,#37,#C9,#CD,#7D,#4A,#28,#30,#CD,#3F,#4A,#3E,#24,#38 ; #4950 .$.7..}J(0.?J>$8
db #2C,#DD,#CB,#FF,#4E,#28,#14,#3A,#F0,#1E,#CD,#69,#4A,#38,#1B,#CD ; #4960 ,...N(.:...iJ8..
db #49,#4A,#38,#1D,#3A,#C3,#1E,#D6,#04,#18,#09,#DD,#CB,#FE,#4E,#28 ; #4970 IJ8.:.........N(
db #09,#3A,#C3,#1E,#BD,#C0,#3E,#02,#18,#A7,#3A,#C3,#1E,#BD,#C0,#37 ; #4980 .:....>...:....7
db #C9,#CD,#51,#4A,#38,#F4,#CD,#8A,#49,#C0,#7B,#FE,#25,#3E,#FE,#38 ; #4990 ..QJ8...I.{.%>.8
db #AE,#3E,#FD,#18,#AA,#CD,#7D,#4A,#28,#31,#CD,#35,#4A,#3E,#2C,#38 ; #49a0 .>....}J(1.5J>,8
db #2D,#DD,#CB,#FF,#56,#28,#14,#3A,#EF,#1E,#CD,#69,#4A,#38,#1C,#CD ; #49b0 -...V(.:...iJ8..
db #59,#4A,#38,#1E,#3A,#C4,#1E,#C6,#04,#18,#09,#DD,#CB,#FE,#56,#28 ; #49c0 YJ8.:.........V(
db #0A,#3A,#C4,#1E,#BA,#C0,#3E,#03,#C3,#31,#49,#3A,#C4,#1E,#BA,#C0 ; #49d0 .:....>..1I:....
db #37,#C9,#CD,#61,#4A,#38,#F4,#CD,#DB,#49,#C3,#45,#49,#CD,#7D,#4A ; #49e0 7..aJ8...I.EI.}J
db #28,#31,#CD,#3F,#4A,#3E,#2C,#38,#2D,#DD,#CB,#FF,#5E,#28,#14,#3A ; #49f0 (1.?J>,8-...^(.:
db #EE,#1E,#CD,#69,#4A,#38,#1C,#CD,#49,#4A,#38,#1E,#3A,#C5,#1E,#C6 ; #4a00 ...iJ8..IJ8.:...
db #04,#18,#09,#DD,#CB,#FE,#5E,#28,#0A,#3A,#C5,#1E,#BC,#C0,#3E,#04 ; #4a10 ......^(.:....>.
db #C3,#31,#49,#3A,#C5,#1E,#BC,#C0,#37,#C9,#CD,#51,#4A,#38,#F4,#CD ; #4a20 .1I:....7..QJ8..
db #23,#4A,#C3,#99,#49,#3A,#C5,#1E,#BC,#D8,#7D,#DD,#BE,#01,#C9,#3A ; #4a30 #J..I:....}....:
db #C4,#1E,#BA,#D8,#7B,#DD,#BE,#00,#C9,#3E,#2C,#BA,#D8,#7B,#FE,#24 ; #4a40 ....{....>,..{.$
db #C9,#3E,#30,#BA,#D8,#7B,#FE,#20,#C9,#3E,#2C,#BC,#D8,#7D,#FE,#24 ; #4a50 .>0..{. .>,..}.$
db #C9,#3E,#30,#BC,#D8,#7D,#FE,#20,#C9,#90,#D8,#F5,#3A,#84,#24,#FE ; #4a60 .>0..}. ....:.$.
db #03,#20,#05,#F1,#FE,#03,#3F,#C9,#F1,#FE,#09,#3F,#C9,#DD,#21,#C2 ; #4a70 . ....?....?..!.
db #1E,#FD,#CB,#09,#46,#C8,#FD,#7E,#0A,#E6,#7F,#D6,#01,#D8,#AF,#C9 ; #4a80 ....F..~........
db #23,#23,#7E,#23,#1E,#06,#CB,#4F,#20,#08,#1F,#3E,#03,#CE,#00,#47 ; #4a90 ##~#...O ..>...G
db #4F,#C9,#1F,#38,#04,#01,#04,#01,#C9,#01,#01,#04,#C9,#00,#00,#00 ; #4aa0 O..8............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#02,#40,#80 ; #4ab0 ..............@.

LAB4AC0: db #00
LAB4AC1: db #FF

LAB4AC2:
     jp lab4AC5	; code auto modifié, #4b51, peut contenir #4b55, #4b68
lab4AC5 cp 128
    jr nc,lab4AFA
    sub 32    
    jr c,lab4B0B
    call lab0580
    ld hl,#0804
    ld a,(lab4AC0)
    and a
    call nz,lab4B9F
    ld bc,(lab4ABE)
    ld a,c
    add a,4
    ld (lab4ABE),a
    ld a,(lab4AC1)
    and a
    ld a,(lab4ABD)
    jr nz,lab4AF7
    inc a
    and 3
    scf
    jr nz,lab4AF4
    inc a
lab4AF4 ld (lab4ABD),a
lab4AF7 jp lab08B0

lab4AFA and 127
    call lab4B8A
lab4AFF ld a,(hl)
    cp 255
    ret z
    inc hl
    push hl
    call lab4AC2
    pop hl
    jr lab4AFF

lab4B0B
	add a,32
    cp 5
    jr nc,lab4B42
    and a
	
    ; Effacement avant affichage du menu
    jp z,simple_clear
    
    sub 2
    jr c,lab4B2D
    jr z,lab4B20
    dec a
    ld (lab4AC0),a
    ret 
    
lab4B20 
db #3A,#BE,#4A,#FE,#C0,#D0,#3E,#20,#CD,#C2,#4A,#18,#F3

lab4b2d: 
db #2A,#BE,#4A 
db #3A,#C0,#4A,#A7,#7C,#28,#02,#C6,#08,#C6,#08,#67,#2E,#40,#22,#BE ; #4b30 :.J.|(.....g.@".
db #4A,#C9
lab4b42: db #21,#5A,#4B,#28,#0A,#FE,#07,#21,#55,#4B,#28,#03,#21,#68 ; #4b40 J.!ZK(...!UK(.!h
db #4B,#22,#C3,#4A,#C9 ; #4b50 

lab4b55: db #CD,#2C,#05,#18,#09,#A7,#32,#C1,#4A,#28,#03 
db #32,#BD,#4A,#21,#C5,#4A,#18,#E9 ; #4b60 2.J!.J..!tK...@2

lab4b68:
db #21,#74,#4B,#87,#87,#C6,#40,#32 
db #BE,#4A,#18,#DD,#87,#87,#87,#32,#BF,#4A,#18,#E7,#ED,#43,#87,#4B ; #4b70 .J.....2.J...C.K
db #21,#86,#4B,#C3,#FF,#4A,#06,#00,#00,#FF,#47,#21,#31,#31,#D6,#60 ; #4b80 !.K..J....G!11.`
db #38,#04,#21,#09,#09,#47,#04,#3E,#FF,#4F,#ED,#B1,#10,#FB,#C9,#06 ; #4b90 8.!..G.>.O......
db #08,#21,#AD,#4A,#1A,#77,#23,#77,#23,#13,#10,#F8,#21,#04,#10,#11 ; #4ba0 .!.J.w#w#...!...
db #AD,#4A,#C9,#01,#F8,#00,#D5,#7A,#CD,#C7,#4B,#D1,#7B,#18,#08,#01 ; #4bb0 .J.....z..K.{...
db #FE,#FF,#18,#03,#01,#FE,#00,#F5,#1F,#1F,#1F,#1F,#CD,#D0,#4B,#F1 ; #4bc0 ..............K.
db #E6,#0F,#20,#09,#CB,#09,#38,#05,#CB,#08,#D0,#3E,#F0,#0E,#FF,#C6 ; #4bd0 .. ...8....>....
db #30,#C5,#CD,#C2,#4A,#C1,#37,#C9,#00,#FF,#FF,#FD,#7E,#0C,#FD,#36 ; #4be0 0...J.7.....~..6
db #0C,#FF,#F6,#F0,#FE,#FF,#C8,#32,#EA,#4B,#C9,#CD,#29,#50,#21,#EA ; #4bf0 .......2.K..)P!.
db #4B,#7E,#36,#FF,#F5,#CD,#0F,#44,#3C,#D6,#01,#D4,#2B,#4F,#F1,#CD ; #4c00 K~6....D<...+O..
db #EF,#4F,#CD,#DF,#4F,#C3,#C7,#4F,#FD,#CB,#0C,#6E,#C0,#CD,#DF,#4F ; #4c10 .O..O..O...n...O
db #CD,#C7,#4F,#06,#47,#C3,#91,#0D
lab4C28
db #60,#21,#28,#4C,#7E,#A7,#C0,#36
db #60,#FD,#36,#0B,#F7,#FD,#36,#0A,#19,#3E,#05,#C3,#1C,#2B,#00,#21 ; #4c30 `.6...6..>...+.!
db #3E,#4C,#36,#FF,#E5,#CD,#4C,#4C,#E1,#36,#00,#C9,#3A,#F0,#36,#3C ; #4c40 >L6...LL.6..:.6<
lab4c50
db #20,#40,#FD,#7E,#0C,#E6,#20,#C0,#ED,#4B,#AB,#24,#18,#13,#3A,#F0 ; #4c50  @.~.. ..K.$..:.
db #36,#3C,#20,#2E,#CD,#79,#4F,#F6,#F3,#B9,#28,#05,#79,#F6,#FC,#B9 ; #4c60 6< ..yO...(.y...
db #C0,#FD,#71,#0C,#18,#1C,#CD,#E2,#4F,#CD,#A7,#4C,#38,#03,#CD,#A7 ; #4c70 ..q.....O..L8...
db #4C,#DA,#6D,#4D,#18,#12,#3A,#F0,#36,#3C,#20,#06,#FD,#7E,#0C,#3C ; #4c80 L.mM..:.6< ..~.<
db #28,#09,#CD,#29,#50,#CD,#A7,#4C,#C3,#C7,#4F,#FD,#E5,#CD,#DC,#4D ; #4c90 (..)P..L..O....M
db #FD,#E1,#FD,#36,#0B,#FF,#C9,#3A,#F0,#36,#FD,#A6,#0C,#CD,#0F,#44 ; #4ca0 ...6...:.6.....D
db #FE,#FF,#37,#C8,#CD,#D0,#4C,#D8,#F5,#CD,#B6,#4F,#F1,#F5,#CD,#52 ; #4cb0 ..7...L....O...R
db #44,#F1,#2A,#3E,#4C,#2C,#C8,#CD,#D0,#4C,#D8,#CD,#52,#44,#A7,#C9 ; #4cc0 D.*>L,...L..RD..
db #2A,#EE,#36,#C3,#5C,#46,#FD,#7E,#0C,#F6,#C0,#3C,#20,#04,#FD,#77 ; #4cd0 *.6.\F.~...< ..w
db #11,#C9,#FD,#7E,#11,#A7,#28,#05,#FD,#36,#0C,#FF,#C9,#FD,#35,#11 ; #4ce0 ...~..(..6....5.
db #CD,#24,#50,#21,#AB,#39,#7E,#23,#66,#6F,#B4,#28,#0A,#E5,#E5,#DD ; #4cf0 .$P!.9~#fo.(....
db #E1,#CD,#15,#4D,#E1,#18,#EF,#CD,#E6,#4F,#FD,#7E,#04,#EE,#10,#FD ; #4d00 ...M.....O.~....
db #77,#04,#C3,#C7,#4F,#DD,#7E,#0A,#E6,#7F,#FE,#0E,#C8,#FE,#11,#C8 ; #4d10 w...O.~.........
db #DD,#7E,#09,#4F,#E6,#09,#C0,#79,#EE,#40,#DD,#77,#09,#C9,#3E,#90 ; #4d20 .~.O...y.@.w..>.
db #01,#3E,#52,#FD,#77,#11,#FD,#36,#0A,#10,#C9,#FD,#CB,#0C,#6E,#C0 ; #4d30 .>R.w..6......n.
db #CD,#2F,#50,#C3,#C7,#4F,#3E,#FE,#18,#0A,#3E,#FD,#18,#06,#3E,#F7 ; #4d40 ./P..O>...>...>.
db #18,#02,#3E,#FB,#FD,#77,#0B,#FD,#36,#0A,#00,#C9,#3A,#84,#24,#E6 ; #4d50 ..>..w..6...:.$.
db #02,#18,#09,#3E,#C0,#01,#3E,#CF,#FD,#B6,#0C,#3C,#C8,#3E,#05,#CD ; #4d60 ...>..>....<.>..
db #1C,#2B,#FD,#7E,#0A,#E6,#80,#F6,#11,#FD,#77,#0A,#FD,#36,#0F,#08 ; #4d70 .+.~......w..6..
db #FD,#36,#04,#80,#CD,#B6,#4F,#CD,#E2,#4F,#FD,#7E,#0F,#E6,#07,#C2 ; #4d80 .6....O..O.~....
db #C7,#4F,#2A,#EE,#36,#C3,#CA,#44,#FD,#46,#08,#FD,#CB,#0C,#6E,#FD ; #4d90 .O*.6..D.F....n.
db #CB,#0C,#EE,#3E,#2C,#28,#1C,#FD,#7E,#0F,#A7,#20,#10,#3E,#2C,#B8 ; #4da0 ...>,(..~.. .>,.
db #20,#2A,#FD,#36,#0F,#50,#3E,#04,#CD,#1C,#2B,#18,#19,#E6,#07,#20 ; #4db0  *.6.P>...+....
db #15,#3E,#2B,#FD,#77,#08,#FD,#36,#0F,#00,#B8,#28,#0F,#18,#07,#FD ; #4dc0 .>+.w..6...(....
db #7E,#0F,#E6,#F0,#28,#06,#CD,#B6,#4F,#CD,#E2,#4F,#CD,#29,#50,#3E ; #4dd0 ~...(...O..O.)P>
db #FF,#CD,#EF,#4F,#C3,#C7,#4F,#21,#2F,#4F,#C3,#2B,#4E,#21,#1D,#4F ; #4de0 ...O..O!/O.+N!.O
db #C3,#2B,#4E,#21,#2F,#4F,#18,#39,#21,#1D,#4F,#18,#34,#21,#24,#4F ; #4df0 .+N!/O.9!.O.4!$O
db #18,#2F,#21,#10,#4F,#18,#2A,#21,#10,#4F,#18,#59,#21,#F4,#4E,#18 ; #4e00 ./!.O.*!.O.Y!.N.
db #54,#21,#01,#4F,#18,#4F,#21,#55,#4F,#18,#36,#3A,#EA,#3D,#F6,#F0 ; #4e10 T!.O.O!UO.6:.=..
db #3C,#21,#6D,#4F,#28,#03,#21,#74,#4F,#18,#26,#E5,#CD,#DF,#4F,#18 ; #4e20 <!mO(.!tO.&...O.
db #0B,#E5,#CD,#DF,#4F,#CD,#29,#50,#3E,#FF,#38,#03,#CD,#7A,#50,#CD ; #4e30 ....O.)P>.8..zP.
db #EF,#4F,#E1,#3A,#E9,#4B,#3C,#CA,#C7,#4F,#CD,#50,#4E,#C3,#C7,#4F ; #4e40 .O.:.K<..O.PN..O
db #E9,#E5,#CD,#29,#50,#E1,#CD,#50,#4E,#CD,#DF,#4F,#CD,#7A,#50,#CD ; #4e50 ...)P..PN..O.zP.
db #EF,#4F,#C3,#C7,#4F,#E5,#CD,#97,#44,#7D,#E6,#0F,#20,#C4,#CD,#29 ; #4e60 .O..O...D}.. ..)
db #50,#E1,#CD,#50,#4E,#CD,#DF,#4F,#CD,#7A,#50,#CD,#EF,#4F,#C3,#C7 ; #4e70 P..PN..O.zP..O..
db #4F,#00,#3E,#01,#CD,#1C,#2B,#CD,#DF,#4F,#FD,#7E,#11,#47,#CB,#5F ; #4e80 O.>...+..O.~.G._
db #28,#3C,#1F,#1F,#E6,#3C,#4F,#0F,#81,#ED,#44,#C6,#C0,#FD,#BE,#07 ; #4e90 (<...<O...D.....
db #30,#16,#2A,#EE,#36,#CD,#31,#2E,#FD,#CB,#0B,#A6,#30,#02,#28,#41 ; #4ea0 0.*.6.1.....0.(A
db #CD,#B6,#4F,#FD,#35,#07,#18,#39,#21,#81,#4E,#7E,#A7,#20,#02,#36 ; #4eb0 ..O.5..9!.N~. .6
db #02,#35,#20,#2D,#78,#EE,#08,#FD,#77,#11,#E6,#08,#18,#23,#E6,#07 ; #4ec0 .5 -x...w....#..
db #87,#4F,#87,#81,#ED,#44,#C6,#BF,#FD,#BE,#07,#38,#DB,#2A,#EE,#36 ; #4ed0 .O...D.....8.*.6
db #CD,#F6,#2C,#30,#02,#28,#0A,#CD,#B6,#4F,#FD,#CB,#0B,#AE,#FD,#34 ; #4ee0 ..,0.(...O.....4
db #07,#C3,#C7,#4F,#CD,#97,#44,#7D,#E6,#06,#FD,#BE,#10,#28,#F5,#18 ; #4ef0 ...O..D}.....(..
db #2A,#CD,#97,#44,#7D,#E6,#06,#F6,#01,#FD,#BE,#10,#28,#F3,#18,#1B ; #4f00 *..D}.......(...
db #CD,#97,#44,#7D,#E6,#07,#FD,#BE,#10,#28,#F5,#18,#0E,#FD,#7E,#10 ; #4f10 ..D}.....(....~.
db #D6,#02,#18,#05,#FD,#7E,#10,#C6,#02,#E6,#07,#FD,#77,#10,#C9,#FD ; #4f20 .....~......w...
db #7E,#10,#C6,#04,#18,#F3,#CD,#29,#50,#CD,#79,#4F,#3E,#18,#BA,#38 ; #4f30 ~......)P.yO>..8
db #0E,#BB,#DA,#4F,#4F,#79,#CD,#0F,#44,#FD,#77,#10,#C3,#59,#4E,#CD ; #4f40 ...OOy..D.w..YN.
db #DF,#4F,#C3,#C7,#4F,#CD,#79,#4F,#7A,#BB,#06,#F3,#38,#03,#7B,#06 ; #4f50 .O..O.yOz...8.{.
db #FC,#A7,#78,#20,#02,#EE,#0F,#B1,#CD,#0F,#44,#18,#BE,#CD,#79,#4F ; #4f60 ..x ......D...yO
db #EE,#0F,#18,#F4,#CD,#79,#4F,#18,#EF,#CD,#3B,#2B,#11,#05,#00,#19 ; #4f70 .....yO...;+....
db #7E,#23,#66,#6F,#0E,#FF,#7C,#FD,#96,#06,#57,#28,#0D,#30,#04,#ED ; #4f80 ~#fo..|...W(.0..
db #44,#57,#37,#F5,#CB,#11,#F1,#3F,#CB,#11,#FD,#7E,#05,#95,#5F,#28 ; #4f90 DW7....?...~.._(
db #0F,#30,#04,#ED,#44,#5F,#37,#F5,#CB,#11,#F1,#3F,#CB,#11,#79,#C9 ; #4fa0 .0..D_7....?..y.
db #CB,#01,#CB,#01,#79,#C9,#3A,#E8,#4B,#CB,#47,#C0,#F6,#01,#32,#E8 ; #4fb0 ....y.:.K.G...2.
db #4B,#2A,#EE,#36,#C3,#A3,#1C,#FD,#36,#0C,#FF,#3A,#E8,#4B,#A7,#C8 ; #4fc0 K*.6....6..:.K..
db #CD,#B6,#4F,#2A,#EE,#36,#CD,#E9,#3A,#2A,#EE,#36,#C3,#EB,#1C,#CD ; #4fd0 ..O*.6..:*.6....
db #8E,#50,#CD,#8C,#37,#D0,#3A,#E8,#4B,#F6,#02,#32,#E8,#4B,#C9,#FD ; #4fe0 .P..7.:.K..2.K..
db #A6,#0C,#FE,#FF,#32,#E9,#4B,#C8,#CD,#0F,#44,#FE,#FF,#32,#E9,#4B ; #4ff0 ....2.K...D..2.K
db #C8,#F5,#32,#E9,#4B,#CD,#D0,#4C,#C1,#3F,#D2,#1F,#50,#F5,#B8,#20 ; #5000 ..2.K..L.?..P..
db #05,#3E,#FF,#32,#E9,#4B,#CD,#B6,#4F,#F1,#CD,#52,#44,#37,#C9,#3A ; #5010 .>.2.K..O..RD7.:
db #F0,#36,#3C,#C8,#3E,#06,#C3,#1C,#2B,#FD,#CB,#0C,#66,#28,#35,#2A ; #5020 .6<.>...+...f(5*
db #EE,#36,#CD,#F6,#2C,#30,#16,#3F,#20,#07,#FD,#CB,#0C,#66,#C0,#18 ; #5030 .6..,0.? ....f..
db #23,#FD,#CB,#0C,#66,#37,#20,#05,#FD,#CB,#0B,#A6,#C9,#F5,#CD,#B6 ; #5040 #...f7 .........
db #4F,#FD,#CB,#0B,#AE,#FD,#34,#07,#3E,#03,#CD,#1C,#2B,#F1,#D8,#FD ; #5050 O.....4.>...+...
db #34,#07,#37,#C9,#2A,#EE,#36,#CD,#31,#2E,#FD,#CB,#0B,#A6,#30,#02 ; #5060 4.7.*.6.1.....0.
db #3F,#C8,#CD,#B6,#4F,#FD,#35,#07,#37,#C9,#FD,#7E,#10,#C6,#86,#6F ; #5070 ?...O.5.7..~...o
db #CE,#50,#95,#67,#7E,#C9,#FD,#F9,#FB,#FA,#FE,#F6,#F7,#F5,#FD,#4E ; #5080 .P.g~..........N
db #10,#CB,#49,#FD,#CB,#04,#A6,#20,#04,#FD,#CB,#04,#E6,#FD,#7E,#0F ; #5090 ..I.... ......~.
db #A7,#C8,#CB,#51,#4F,#28,#07,#CB,#59,#C0,#3E,#08,#18,#04,#CB,#59 ; #50a0 ...QO(..Y.>....Y
db #C8,#AF,#A9,#E6,#0F,#A9,#FD,#77,#0F,#C9,#FD,#CB,#0C,#66,#C0,#18 ; #50b0 .......w.....f..
db #23,#FD,#CB,#0C,#66,#37,#20,#05,#FD,#CB,#0B,#A6,#C9,#F5,#CD,#B6 ; #50c0 #...f7 .........
db #0C,#C0,#02,#CE,#77,#33,#96,#4F,#26,#92,#FE,#3F,#C0,#07,#C1,#C0 ; #50d0 ....w3.O&..?....
db #43,#E0,#01,#FF,#C0,#12,#C2,#16,#D2,#FB,#3C,#7D,#CF,#27,#FC,#0A ; #50e0 C.........<}.''..
db #69,#75,#9A,#3C,#E6,#FC,#7F,#80,#08,#C3,#16,#CA,#77,#3C,#9F,#F1 ; #50f0 iu.<........w<..
db #FE,#0B,#C4,#C3,#23,#E1,#E1,#C5,#B6,#9F,#CF,#F8,#FF,#0C,#C5,#0E ; #5100 ....#...........
db #C6,#75,#3B,#9E,#4F,#67,#D3,#FE,#3F,#C0,#08,#C6,#17,#D2,#79,#34 ; #5110 .u;.Og..?.....y4
db #97,#F1,#FE,#0E,#C7,#0E,#CB,#73,#79,#5D,#1F,#4F,#CB,#EB,#EE,#FF ; #5120 .......sy].O....
db #8F,#F0,#0E,#C8,#0E,#CA,#74,#FB,#5E,#2F,#5F,#B3,#CB,#DD,#FF,#8F ; #5130 ......t.^/_.....
db #F0,#0C,#C9,#C8,#03,#87,#62,#79,#DF,#6F,#8F,#FC,#7F,#80,#08,#CA ; #5140 ......by.o......
db #18,#D2,#79,#34,#97,#F1,#FE,#09,#CB,#00,#CE,#79,#3C,#7D,#BF,#F8 ; #5150 ..y4.......y<}..
db #FF,#0C,#CC,#16,#D0,#F8,#BC,#7E,#4F,#2F,#9B,#FE,#3F,#C0,#0F,#CD ; #5160 .......~O/..?...
db #02,#F2,#F9,#74,#B6,#3F,#1E,#8E,#C9,#E4,#D2,#5F,#C7,#F8,#08,#CE ; #5170 ...t.?....._....
db #1E,#D1,#F9,#34,#B7,#F1,#FE,#10,#CF,#30,#CC,#F7,#BA,#BD,#DF,#2F ; #5180 ...4.....0...../
db #33,#D9,#DC,#ED,#F6,#BF,#E3,#FC,#12,#D0,#CA,#AB,#E5,#5B,#F2,#95 ; #5190 3............[..
db #F9,#49,#70,#DD,#B4,#C6,#13,#0E,#9F,#8F,#F0,#08,#D1,#24,#D2,#79 ; #51a0 .Ip..........$.y
db #34,#97,#F1,#FE,#0B,#D2,#CC,#63,#E6,#41,#F1,#03,#F8,#82,#7F,#F0 ; #51b0 4......c.A......
db #0E,#D3,#0E,#D0,#F8,#BC,#7E,#4F,#2F,#9B,#CF,#E0,#FF,#8F,#F0,#08 ; #51c0 ......~O/.......
db #D4,#05,#D2,#79,#34,#93,#F1,#FE,#0A,#D5,#0F,#4E,#75,#9F,#1F,#CB ; #51d0 ...y4......Nu...
db #DF,#8F,#F0,#0E,#D6,#38,#F1,#E9,#34,#BB,#F0,#1F,#A3,#F2,#79,#7F ; #51e0 .....8..4.....y.
db #E3,#FC,#0E,#D7,#39,#F1,#E9,#34,#BB,#F0,#1F,#A3,#F2,#79,#7F,#E3 ; #51f0 ....9..4.....y..
db #FC,#0B,#D8,#D7,#8B,#EB,#CB,#F5,#9D,#FA,#CD,#7F,#F0,#10,#DA,#39 ; #5200 ...............9
db #CA,#67,#34,#9A,#CD,#F8,#0F,#EA,#77,#3C,#9E,#CF,#F8,#FF,#10,#D9 ; #5210 .g4.....w<......
db #38,#CA,#67,#34,#9A,#CD,#F8,#0F,#EA,#77,#3C,#9E,#CF,#F8,#FF,#10 ; #5220 8.g4.....w<.....
db #DB,#3A,#FC,#EE,#B6,#5F,#4F,#F8,#3B,#FD,#EF,#36,#3F,#3F,#F8,#FF ; #5230 .:..._O.;..6??..
db #00,#1A,#12,#01,#61,#FC,#05,#92,#07,#20,#CA,#FA,#BF,#E0,#93,#0F ; #5240 ....a.... ......
db #CF,#CB,#D7,#E7,#33,#A9,#DC,#E7,#73,#FF,#1F,#E0,#0B,#1D,#01,#E1 ; #5250 ....3...s.......
db #08,#05,#B0,#07,#CB,#03,#FF,#80,#0C,#22,#05,#21,#08,#24,#4B,#95 ; #5260 .........".!.$K.
db #F1,#7D,#7F,#E3,#FC,#1D,#24,#00,#E1,#10,#3C,#3F,#38,#E2,#73,#FC ; #5270 .}....$...<?8.s.
db #03,#3C,#F8,#57,#72,#1D,#16,#87,#11,#FF,#FF,#81,#6D,#17,#0F,#89 ; #5280 .<.Wr.......m...
db #FF,#1F,#E0,#08,#26,#0F,#A1,#08,#05,#96,#07,#FF,#10,#2D,#03,#A1 ; #5290 ....&........-..
db #04,#25,#B4,#2F,#0C,#97,#70,#FB,#77,#D9,#EB,#FF,#80,#1A,#32,#00 ; #52a0 .%./..p.w.....2.
db #E1,#08,#24,#4B,#AF,#F0,#7F,#C0,#76,#EB,#D3,#D9,#EC,#76,#FC,#7E ; #52b0 ..$K....v....v.~
db #BF,#A7,#D7,#CB,#E7,#FF,#8F,#F0,#12,#35,#0F,#E1,#21,#85,#8A,#3E ; #52c0 .........5..!..>
db #C5,#1F,#85,#64,#79,#3C,#CE,#6F,#FC,#7F,#80,#09,#36,#0F,#E1,#00 ; #52d0 ...dy<.o....6...
db #A4,#25,#0E,#FF,#E0,#0B,#3C,#03,#A1,#28,#05,#B4,#2F,#D9,#0B,#FF ; #52e0 .%....<..(../...
db #80,#12,#3D,#03,#A1,#40,#94,#19,#36,#E7,#10,#ED,#B4,#2F,#0F,#E7 ; #52f0 ..=..@..6..../..
db #7D,#BF,#E3,#FC,#08,#3E,#0B,#61,#09,#05,#B2,#1F,#FF,#10,#43,#0C ; #5300 }....>.a......C.
db #21,#C1,#05,#9D,#D7,#CE,#0B,#8F,#69,#EC,#DA,#5F,#F8,#FF,#0E,#45 ; #5310 !.......i.._...E
db #09,#32,#40,#0B,#81,#87,#C1,#03,#80,#EC,#3F,#E3,#FC,#0F,#46,#0E ; #5320 .2@.......?...F.
db #72,#41,#0A,#5D,#09,#E5,#FB,#4F,#1F,#53,#FE,#3F,#C0,#1F,#47,#08 ; #5330 rA.]...O.S.?..G.
db #32,#01,#0A,#09,#37,#E2,#33,#5E,#15,#33,#E3,#B0,#CF,#82,#07,#0E ; #5340 2...7.3^.3......
db #C9,#F4,#BF,#E0,#0B,#19,#8C,#AA,#55,#32,#9F,#F1,#FE,#0D,#4C,#0E ; #5350 ........U2....L.
db #21,#00,#25,#B2,#17,#DA,#17,#E5,#81,#FF,#C0,#0D,#4E,#0F,#21,#00 ; #5360 !.%.........N.!.
db #25,#B2,#17,#DA,#17,#E5,#81,#FF,#C0,#08,#81,#0F,#61,#40,#05,#96 ; #5370 %...........a@..
db #07,#FF,#10,#82,#01,#E1,#1F,#8C,#1F,#38,#24,#9B,#85,#C4,#F2,#31 ; #5380 .........8$....1
db #3F,#1F,#E0,#0D,#84,#03,#E1,#08,#05,#AF,#0F,#D7,#9B,#E5,#81,#FF ; #5390 ?...............
db #C0,#0B,#85,#01,#A1,#08,#05,#B0,#07,#CB,#0F,#FF,#80,#06,#87,#0F ; #53a0 ................
db #E1,#48,#05,#FE,#08,#88,#0F,#A1,#01,#05,#96,#07,#FF,#06,#92,#07 ; #53b0 .H..............
db #61,#48,#25,#FE,#08,#93,#0C,#61,#41,#05,#AF,#C7,#FF,#08,#94,#00 ; #53c0 aH%....aA.......
db #A1,#49,#25,#9E,#47,#FF,#08,#95,#00,#E1,#49,#25,#9E,#47,#FF,#0B ; #53d0 .I%.G.....I%.G..
db #96,#0D,#21,#41,#04,#1F,#1A,#FA,#FC,#7F,#F0,#06,#97,#07,#61,#09 ; #53e0 ..!A..........a.
db #25,#FE,#08,#A1,#0F,#61,#40,#05,#96,#07,#FF,#0D,#A2,#00,#21,#03 ; #53f0 %....a@.......!.
db #25,#86,#24,#CC,#9E,#67,#45,#FF,#C0,#0D,#A4,#02,#61,#00,#25,#AC ; #5400 %.$..gE.....a.%.
db #CF,#D6,#7B,#E5,#81,#FF,#C0,#0B,#A5,#01,#61,#00,#25,#B0,#07,#CB ; #5410 ..{.......a.%...
db #03,#FF,#80,#0B,#A7,#0E,#21,#C0,#24,#19,#31,#F9,#C0,#FF,#F0,#0B ; #5420 ......!.$.1.....
db #A8,#00,#61,#01,#05,#B0,#07,#CB,#03,#FF,#80,#08,#B1,#02,#5B,#08 ; #5430 ..a...........[.
db #07,#96,#07,#FF,#19,#C1,#00,#1B,#FC,#26,#23,#1E,#B9,#CF,#72,#4C ; #5440 .........&#...rL
db #C7,#83,#B3,#E1,#F3,#CF,#23,#F1,#E8,#F7,#7B,#7E,#3F,#C0,#1A,#C2 ; #5450 ......#...{~?...
db #01,#5B,#81,#8C,#3F,#08,#E1,#F8,#FC,#7F,#FC,#08,#6F,#F8,#1F,#F0 ; #5460 .[..?.......o...
db #49,#BC,#EF,#F9,#FC,#1D,#8F,#F8,#FF,#14,#C3,#0F,#1B,#01,#06,#43 ; #5470 I..............C
db #A6,#EF,#7F,#C1,#26,#38,#3C,#4E,#6B,#5D,#76,#D7,#F1,#FE,#1E,#D1 ; #5480 ....&8<Nk]v.....
db #0B,#DB,#00,#26,#03,#2A,#01,#F9,#2E,#8F,#B3,#FE,#08,#F2,#59,#1D ; #5490 ...&.*........Y.
db #65,#B7,#7E,#09,#35,#46,#85,#4B,#BF,#D7,#3F,#1F,#E0,#19,#89,#41 ; #54a0 e.~.5F.K..?....A
db #78,#40,#02,#1D,#38,#E0,#10,#0F,#82,#47,#C1,#A3,#83,#68,#3E,#1E ; #54b0 x@..8....G...h>.
db #8E,#C7,#43,#91,#FF,#1F,#E0,#10,#8A,#43,#F8,#01,#02,#01,#3E,#E0 ; #54c0 ..C......C....>.
db #58,#62,#33,#1A,#8D,#FF,#1F,#E0,#0B,#61,#59,#38,#14,#0E,#2D,#B3 ; #54d0 Xb3......aY8..-.
db #FA,#7F,#C7,#F8,#0E,#64,#51,#78,#10,#0E,#2D,#3B,#E2,#F3,#DE,#09 ; #54e0 .....dQx..-;....
db #3F,#FF,#E0,#09,#71,#53,#40,#00,#22,#01,#3E,#FF,#E0,#11,#74,#54 ; #54f0 ?...qS@.".>...tT
db #80,#04,#3C,#03,#A3,#E9,#FF,#C0,#B6,#CF,#F7,#C3,#FF,#8F,#F0,#0F ; #5500 ..<.............
db #84,#54,#80,#80,#1C,#2F,#13,#E2,#DA,#5F,#1F,#0F,#FE,#3F,#C0,#06 ; #5510 .T.../..._...?..
db #85,#5E,#00,#09,#03,#FE,#11,#95,#55,#00,#08,#22,#1B,#0A,#E2,#13 ; #5520 .^......U.."....
db #AE,#37,#9D,#F2,#7A,#BF,#E3,#FC,#0B,#A5,#5E,#F8,#00,#3E,#2D,#8B ; #5530 .7..z.....^..>-.
db #E6,#7F,#C7,#F8,#0E,#24,#6F,#00,#A4,#03,#8E,#07,#16,#CF,#79,#BB ; #5540 .....$o.......y.
db #DB,#F1,#FE,#08,#25,#62,#78,#01,#8F,#88,#2F,#FF,#15,#30,#61,#C0 ; #5550 ....%bx.../..0a.
db #80,#0D,#8C,#FF,#C6,#1F,#E2,#07,#C5,#B7,#F7,#FD,#07,#83,#41,#7F ; #5560 ..............A.
db #1F,#E0,#0D,#31,#65,#40,#11,#02,#03,#1D,#F9,#50,#F1,#18,#EE,#FF ; #5570 ...1e@.....P....
db #0D,#34,#6F,#00,#14,#13,#8E,#07,#0A,#CD,#F9,#3F,#E3,#FC,#06,#41 ; #5580 .4o........?...A
db #66,#40,#48,#23,#FE,#08,#42,#6E,#00,#21,#03,#8A,#07,#FF,#08,#43 ; #5590 f@H#..Bn.!.....C
db #6E,#00,#40,#83,#8A,#3F,#FF,#13,#44,#61,#F8,#49,#2B,#88,#05,#C4 ; #55a0 n.@..?..Da.I+...
db #1E,#E2,#03,#F1,#01,#D8,#83,#6C,#41,#BF,#F8,#12,#45,#6C,#C0,#E3 ; #55b0 .......lA...El..
db #8C,#2F,#9C,#92,#4F,#C0,#B6,#7E,#4F,#18,#90,#4F,#C7,#F8,#08,#46 ; #55c0 ./..O..~O..O...F
db #6F,#C0,#49,#03,#8E,#07,#FF,#16,#47,#69,#80,#01,#02,#33,#1F,#E3 ; #55d0 o.I.....Gi...3..
db #51,#4D,#82,#07,#02,#CA,#55,#39,#94,#CC,#67,#FC,#7F,#80,#0B,#51 ; #55e0 QM....U9..g....Q
db #66,#C0,#48,#22,#1F,#94,#E9,#FF,#C7,#F8,#19,#52,#60,#80,#01,#8C ; #55f0 f.H".......R`...
db #23,#03,#C2,#10,#6C,#2F,#BB,#FC,#7F,#C0,#B6,#FF,#8D,#C3,#E0,#76 ; #5600 #...l/.........v
db #3C,#1F,#F1,#FE,#06,#54,#67,#00,#08,#23,#FE,#06,#56,#67,#40,#08 ; #5610 <....Tg..#..Vg@.
db #23,#FE,#09,#61,#69,#00,#00,#22,#09,#33,#FF,#E0,#0E,#64,#61,#40 ; #5620 #..ai..".3...da@
db #00,#22,#19,#18,#E2,#32,#7E,#09,#3F,#FF,#E0,#11,#66,#61,#00,#40 ; #5630 ."...2~.?...fa.@
db #22,#39,#C7,#FF,#FE,#3F,#E0,#77,#37,#E4,#FF,#8F,#F0,#0B,#67,#6F ; #5640 "9...?.w7.....go
db #C0,#25,#02,#33,#0C,#F9,#00,#7F,#F0,#08,#68,#6F,#C0,#40,#83,#90 ; #5650 .%.3......ho.@..
db #07,#FF,#1C,#69,#61,#80,#1D,#02,#0D,#16,#80,#91,#1F,#95,#B7,#CA ; #5660 ...ia...........
db #CB,#8A,#E4,#DA,#8D,#57,#F8,#16,#C9,#44,#E2,#91,#59,#F8,#FF,#08 ; #5670 .....W...D..Y...
db #77,#6F,#C0,#40,#13,#90,#07,#FF,#10,#78,#68,#80,#C1,#02,#37,#64 ; #5680 wo.@.....xh...7d
db #E1,#72,#3A,#0B,#A3,#F1,#EF,#C7,#F8,#06,#79,#6F,#C0,#09,#23,#FE ; #5690 .r:.......yo..#.
db #15,#89,#60,#00,#10,#3C,#2F,#26,#F9,#41,#FC,#41,#38,#B6,#8F,#F9 ; #56a0 ..`..</&.A.A8...
db #FB,#E2,#70,#FF,#E3,#FC,#0B,#99,#6E,#78,#00,#4E,#2D,#8C,#E5,#FF ; #56b0 ..p.....nx.N-...
db #C7,#F8,#12,#A5,#6E,#C0,#FC,#02,#09,#0B,#E2,#32,#4E,#17,#92,#F5 ; #56c0 ....n......2N...
db #7B,#7A,#BF,#F1,#FE,#06,#A6,#6D,#80,#41,#03,#FE,#0B,#A7,#6D,#C0 ; #56d0 {z.....m.A....m.
db #41,#02,#03,#21,#E3,#76,#3F,#FE,#0B,#A8,#6E,#38,#01,#8E,#2D,#99 ; #56e0 A..!.v?...n8..-.
db #F0,#FF,#C7,#F8,#1D,#B5,#63,#40,#04,#3C,#0D,#A5,#F6,#FF,#7E,#BF ; #56f0 ......c@.<....~.
db #F0,#13,#8B,#F1,#F8,#7F,#E0,#23,#13,#D9,#FF,#81,#6C,#1F,#13,#FE ; #5700 .......#....l...
db #3F,#C0,#1C,#C5,#63,#40,#00,#1C,#2D,#BE,#FE,#FF,#3F,#E0,#23,#69 ; #5710 ?...c@..-...?.#i
db #F3,#F9,#7C,#7C,#3D,#3E,#AF,#FC,#03,#64,#79,#BC,#5F,#F8,#FF,#16 ; #5720 ..||=>...dy._...
db #05,#7F,#78,#10,#0E,#09,#0E,#E1,#3B,#6F,#9F,#D3,#EB,#FF,#00,#D9 ; #5730 ..x.....;o......
db #EF,#37,#BB,#FE,#3F,#C0,#1A,#14,#70,#80,#80,#0C,#17,#39,#F8,#79 ; #5740 .7..?...p....9.y
db #7C,#3C,#7E,#20,#7C,#4E,#47,#C5,#21,#D8,#27,#75,#79,#BC,#5F,#C7 ; #5750 |<~ |NG.!.''uy._.
db #F8,#0B,#15,#74,#00,#15,#22,#15,#02,#E2,#B1,#CF,#FE,#0B,#25,#72 ; #5760 ...t..".......%r
db #40,#00,#22,#19,#31,#E0,#93,#91,#FE,#15,#98,#70,#C8,#48,#0A,#1D ; #5770 @.".1......p.H..
db #3F,#E2,#FB,#FC,#06,#FC,#0B,#60,#79,#1F,#7F,#F7,#FC,#7F,#80,#06 ; #5780 ?......`y.......
db #99,#7E,#48,#01,#0B,#FE,#09,#A8,#7E,#08,#14,#2A,#17,#09,#FF,#E0 ; #5790 .~H.....~..*....
db #14,#B8,#70,#48,#10,#3C,#27,#38,#F8,#49,#7C,#2B,#78,#B6,#F3,#FB ; #57a0 ..pH.<''8.I|+x...
db #C2,#E1,#FF,#C7,#F8,#08,#BA,#73,#F8,#08,#0B,#96,#07,#FF,#06,#C8 ; #57b0 .......s........
db #76,#C8,#40,#2B,#FE,#10,#C9,#7D,#88,#41,#0A,#1D,#9B,#ED,#E8,#F4 ; #57c0 v.@+...}.A......
db #99,#CC,#E7,#FC,#7F,#80,#0E,#CA,#70,#88,#41,#2A,#19,#3C,#E3,#38 ; #57d0 ........p.A*.<.8
db #0E,#3F,#FC,#7F,#80,#08,#CB,#7E,#08,#09,#0B,#92,#07,#FF,#10,#DB ; #57e0 .?.....~........
db #72,#48,#08,#2A,#4D,#23,#E4,#39,#EF,#37,#2F,#E7,#FF,#1F,#E0,#0B ; #57f0 rH.*M#.9.7/.....
db #EB,#78,#38,#00,#3E,#2D,#8C,#E5,#FF,#C7,#F8,#0B,#04,#81,#80,#A0 ; #5800 .x8.>-..........
db #02,#03,#24,#E0,#10,#0F,#FE,#0E,#05,#8F,#40,#01,#02,#1D,#31,#E1 ; #5810 ..$.......@...1.
db #33,#2C,#09,#0E,#1F,#E0,#19,#09,#83,#B8,#10,#1C,#0D,#06,#F9,#8C ; #5820 3,..............
db #71,#79,#4F,#25,#8E,#EC,#CA,#39,#0E,#67,#B3,#9D,#EA,#FF,#C7,#F8 ; #5830 qyO%...9.g......
db #19,#0B,#83,#38,#04,#3C,#2D,#39,#E0,#33,#1F,#99,#07,#06,#D3,#7B ; #5840 ...8.<-9.3.....{
db #BF,#DF,#6F,#F8,#0B,#C4,#F4,#7F,#E3,#FC,#1D,#19,#81,#F8,#48,#61 ; #5850 ..o...........Ha
db #99,#04,#0E,#C4,#92,#08,#1F,#F0,#0B,#89,#44,#22,#79,#38,#9A,#4C ; #5860 ..........D"y8.L
db #25,#B1,#D0,#C4,#52,#1F,#E3,#FC,#17,#1A,#8D,#78,#E1,#01,#9C,#07 ; #5870 %...R......x....
db #CE,#E3,#93,#49,#39,#1E,#7E,#4F,#3F,#04,#99,#E9,#34,#FC,#7F,#80 ; #5880 ...I9.~O?...4...
db #18,#1B,#83,#38,#01,#9D,#88,#2F,#17,#87,#70,#68,#37,#01,#D3,#7F ; #5890 ...8.../..ph7...
db #7F,#E0,#5B,#7D,#D6,#F1,#7F,#C7,#F8,#0F,#29,#80,#80,#00,#21,#9B ; #58a0 ..[}......)...!.
db #EF,#C1,#3F,#E5,#B7,#F2,#DD,#FF,#E0,#08,#E9,#81,#00,#48,#01,#96 ; #58b0 ..?..........H..
db #07,#FF,#15,#EA,#8C,#78,#43,#0A,#43,#98,#F0,#7F,#C0,#B6,#6F,#B7 ; #58c0 .....xC.C.....o.
db #9B,#91,#D8,#E4,#7A,#3F,#F8,#FF,#09,#EB,#88,#38,#09,#0A,#09,#0B ; #58d0 ....z?.....8....
db #FF,#E0,#10,#F9,#8F,#B8,#24,#3C,#0D,#36,#E2,#D8,#BE,#67,#3B,#9B ; #58e0 ......$<.6...g;.
db #FF,#1F,#E0,#19,#FA,#89,#B8,#00,#8C,#2F,#27,#F9,#88,#F2,#59,#0E ; #58f0 ........./''...Y.
db #C5,#17,#E6,#53,#C2,#36,#1F,#F0,#2D,#88,#FF,#8F,#F0,#13,#FB,#84 ; #5900 ...S.6..-.......
db #F8,#1C,#21,#9C,#FF,#11,#9E,#E0,#A9,#EF,#1E,#DE,#7F,#37,#7F,#F1 ; #5910 ..!..........7..
db #FE,#09,#03,#91,#9B,#0C,#0E,#09,#1C,#FF,#E0,#11,#11,#9B,#1B,#08 ; #5920 ................
db #07,#98,#7C,#00,#94,#30,#3C,#BF,#A3,#DF,#FF,#1F,#E0,#06,#13,#96 ; #5930 ..|..0<.........
db #9B,#08,#27,#FE,#0F,#20,#9D,#DB,#A0,#0F,#99,#CF,#CC,#07,#8E,#E6 ; #5940 ..''.. ..........
db #B4,#5B,#F1,#FE,#0E,#21,#90,#1B,#43,#67,#9D,#3F,#16,#CC,#76,#23 ; #5950 .[...!..Cg.?..v#
db #1B,#F1,#FE,#13,#22,#9D,#DB,#81,#8C,#5B,#1E,#E1,#DA,#3F,#1E,#6F ; #5960 ...."....[...?.o
db #7E,#05,#B3,#FD,#8F,#F8,#FF,#13,#23,#91,#9B,#01,#BC,#5B,#0C,#E1 ; #5970 ~.......#....[..
db #D9,#FC,#FF,#E3,#7E,#05,#B4,#1C,#4F,#F8,#FF,#11,#03,#A1,#99,#00 ; #5980 ....~...O.......
db #0E,#09,#1C,#FA,#40,#71,#7D,#27,#B3,#E9,#FF,#1F,#E0,#0C,#0D,#A3 ; #5990 ....@q}''........
db #D3,#80,#0E,#2D,#86,#F3,#77,#BF,#E3,#FC,#09,#0E,#A8,#53,#41,#28 ; #59a0 ...-..w......SA(
db #63,#24,#FF,#E0,#0F,#0F,#A8,#93,#01,#28,#23,#77,#D8,#A0,#FC,#50 ; #59b0 c$.......(#w...P
db #BE,#28,#7F,#FC,#14,#20,#AD,#DB,#00,#0E,#07,#21,#D9,#9F,#FC,#C1 ; #59c0 .(... .....!....
db #F8,#EE,#77,#3B,#65,#D2,#DF,#C7,#F8,#0D,#D0,#A8,#D3,#09,#08,#23 ; #59d0 ..w;e..........#
db #4C,#E3,#31,#CF,#82,#37,#FF,#11,#DE,#A1,#D3,#80,#0E,#2F,#2F,#E2 ; #59e0 L.1..7.......//.
db #DA,#7E,#FF,#FF,#FB,#C7,#FF,#8F,#F0,#06,#DF,#AD,#93,#41,#09,#FE ; #59f0 .~...........A..
db #1F,#E0,#A8,#53,#08,#29,#8A,#37,#C5,#13,#E2,#8B,#C5,#E5,#0B,#31 ; #5a00 ...S.).7.......1
db #75,#8C,#9E,#21,#D7,#F7,#FF,#E0,#5B,#40,#B7,#EB,#E5,#FF,#E3,#FC ; #5a10 u..!....[@......
db #08,#F0,#AE,#93,#01,#29,#8E,#07,#FF,#0D,#FE,#A0,#13,#90,#0C,#2F ; #5a20 .....)........./
db #3E,#F9,#8F,#FC,#40,#FF,#F8,#06,#FF,#AB,#53,#49,#09,#FE,#18,#03 ; #5a30 >...@.....SI....
db #B1,#99,#00,#0E,#47,#20,#1A,#40,#72,#4D,#1B,#91,#FE,#05,#F4,#26 ; #5a40 ....G .@rM.....&
db #24,#E4,#52,#99,#BF,#1F,#E0,#09,#0D,#B3,#D3,#00,#0E,#09,#06,#FF ; #5a50 $.R.............
db #E0,#0B,#10,#B0,#9B,#08,#27,#A0,#07,#CB,#17,#FF,#80,#12,#20,#BD ; #5a60 ......''....... .
db #DB,#00,#26,#23,#20,#F9,#9C,#BC,#C0,#58,#EE,#69,#44,#BF,#1F,#E0 ; #5a70 ..&# ....X.iD...
db #0C,#2C,#B7,#D3,#80,#0E,#47,#83,#EE,#79,#3F,#E3,#FC,#0B,#2D,#B0 ; #5a80 .,....G..y?...-.
db #13,#41,#09,#A0,#07,#CB,#03,#FF,#80,#16,#2E,#B1,#93,#01,#08,#49 ; #5a90 .A.............I
db #1C,#21,#71,#B9,#A3,#C4,#D1,#FF,#E8,#F1,#C4,#77,#7C,#3F,#F8,#FF ; #5aa0 .!q........w|?..
db #17,#DE,#B1,#D3,#00,#0E,#09,#3D,#E0,#59,#FA,#F9,#7D,#FE,#05,#B7 ; #5ab0 .......=.Y..}...
db #97,#AC,#38,#3F,#F1,#FF,#1F,#E0,#1D,#03,#C1,#9B,#00,#3E,#55,#3E ; #5ac0 ..8?.........>U>
db #C1,#53,#FC,#2F,#09,#FA,#40,#71,#6C,#7C,#5E,#F0,#79,#7D,#3E,#EF ; #5ad0 .S./..@ql|^.y}>.
db #73,#B6,#FD,#FC,#7F,#80,#0B,#0C,#CD,#13,#E0,#0E,#2D,#9F,#93,#CF ; #5ae0 s...........-...
db #C7,#F8,#0B,#0D,#C3,#D3,#01,#08,#39,#03,#E0,#90,#6F,#FE,#0B,#2C ; #5af0 ........9...o..,
db #C7,#D3,#00,#0E,#09,#03,#F8,#80,#7F,#F0,#0B,#D1,#C1,#DB,#10,#0F ; #5b00 ................
db #88,#07,#C4,#1F,#FF,#80,#0C,#D4,#C6,#5B,#10,#0E,#49,#BC,#FD,#F8 ; #5b10 .........[..I...
db #FF,#E3,#FC,#08,#DC,#CF,#93,#10,#0F,#98,#87,#FF,#14,#DE,#C1,#D3 ; #5b20 ................
db #14,#0E,#09,#38,#E2,#DB,#AC,#78,#1C,#BF,#47,#63,#FF,#37,#7B,#F1 ; #5b30 ...8...x..Gc.7{.
db #FE,#10,#E1,#C8,#1B,#20,#26,#01,#28,#62,#D2,#F8,#2F,#2E,#99,#87 ; #5b40 ..... &.(b../...
db #CF,#F0,#12,#E2,#C8,#1B,#80,#86,#07,#13,#E0,#12,#F7,#98,#7C,#17 ; #5b50 ..............|.
db #D7,#CB,#A7,#E3,#FC,#12,#E3,#C0,#DB,#4B,#07,#A3,#1F,#C3,#12,#0F ; #5b60 .........K......
db #32,#20,#9B,#07,#00,#EF,#C7,#F8,#0B,#E4,#CE,#1B,#01,#26,#63,#36 ; #5b70 2 ...........&c6
db #9A,#29,#7F,#F0,#12,#EC,#CF,#53,#20,#3C,#1D,#15,#E0,#70,#AC,#55 ; #5b80 .).....S <...p.U
db #56,#F9,#88,#7C,#CA,#3F,#F8,#0E,#ED,#CF,#53,#80,#8D,#98,#87,#16 ; #5b90 V..|.?....S.....
db #C4,#F9,#BB,#DF,#F1,#FE,#06,#EE,#CE,#D3,#03,#29,#FE,#0E,#F3,#C4 ; #5ba0 ...........)....
db #5B,#14,#26,#15,#1C,#E2,#39,#BF,#27,#FC,#7F,#80,#16,#03,#DF,#99 ; #5bb0 [.&...9.''.......
db #00,#06,#23,#23,#C0,#31,#CC,#17,#92,#F5,#75,#7B,#7E,#3F,#27,#73 ; #5bc0 ..##.1....u{~?''s
db #FE,#3F,#C0,#06,#0C,#DD,#13,#08,#09,#FE,#16,#1C,#D3,#93,#08,#28 ; #5bd0 .?.............(
db #23,#26,#FA,#2E,#F0,#D8,#8E,#24,#DC,#CE,#5A,#3D,#9F,#8F,#FC,#7F ; #5be0 #&.....$..Z=....
db #80,#1C,#2C,#D7,#D3,#00,#28,#03,#14,#41,#51,#BE,#1F,#AC,#5A,#3F ; #5bf0 ..,...(..AQ...Z?
db #27,#77,#F0,#49,#94,#6E,#39,#27,#9F,#4D,#65,#FC,#7F,#80,#08,#88 ; #5c00 ''w.I.n9''.Me.....
db #D0,#13,#40,#09,#96,#07,#FF,#19,#89,#D1,#93,#E1,#88,#03,#1E,#79 ; #5c10 ..@............y
db #C0,#71,#1C,#D7,#8B,#FE,#09,#33,#1E,#0E,#F4,#9A,#3F,#27,#9F,#8F ; #5c20 .q.....3....?''..
db #F0,#09,#8A,#DC,#D3,#C1,#08,#03,#24,#FF,#E0,#0F,#8B,#D0,#93,#09 ; #5c30 ........$.......
db #09,#A0,#07,#16,#CE,#79,#3B,#7E,#3F,#F8,#FF,#08,#9B,#DF,#13,#48 ; #5c40 .....y;~?......H
db #29,#8E,#07,#FF,#0E,#9C,#D1,#93,#1D,#09,#95,#C7,#28,#CE,#44,#BA ; #5c50 )...........(.D.
db #5B,#F1,#FE,#15,#AB,#D1,#93,#E0,#6C,#53,#80,#94,#4F,#E7,#53,#89 ; #5c60 [.......lS..O.S.
db #F8,#16,#CF,#C9,#E0,#90,#39,#F8,#FF,#0D,#AC,#D1,#D3,#09,#29,#A0 ; #5c70 ......9.......).
db #07,#11,#CA,#7B,#3F,#E3,#FC,#10,#BC,#D4,#53,#08,#28,#07,#3A,#E2 ; #5c80 ...{?.....S.(.:.
db #D0,#46,#01,#04,#58,#80,#BF,#F0,#12,#CC,#D1,#53,#FC,#28,#3D,#3C ; #5c90 .F..X......S.(=<
db #99,#CF,#7C,#30,#E0,#B6,#5F,#2F,#FF,#1F,#E0,#06,#CD,#DC,#93,#41 ; #5ca0 ..|0.._/.......A
db #09,#FE,#18,#CE,#D1,#13,#1D,#08,#09,#07,#E5,#12,#66,#27,#17,#D8 ; #5cb0 ............f''..
db #A1,#CC,#2F,#F8,#76,#9A,#2F,#CF,#FF,#8F,#F0,#11,#D1,#D1,#DB,#00 ; #5cc0 ../.v./.........
db #0E,#09,#03,#F8,#81,#F0,#BD,#FE,#DF,#5F,#BF,#1F,#E0,#09,#D4,#D6 ; #5cd0 ........._......
db #5B,#00,#0E,#09,#23,#FF,#E0,#19,#DC,#DF,#93,#00,#28,#43,#31,#E0 ; #5ce0 [...#.......(C1.
db #33,#10,#2F,#B1,#BA,#3F,#C0,#B6,#C4,#E7,#32,#59,#6D,#BE,#9B,#F1 ; #5cf0 3./..?....2Ym...
db #FE,#15,#DE,#D1,#D3,#00,#28,#2D,#07,#20,#30,#70,#2B,#01,#E4,#F0 ; #5d00 ......(-. 0p+...
db #0A,#01,#04,#59,#90,#BF,#F0,#17,#8A,#E0,#B2,#80,#0E,#43,#1C,#C2 ; #5d10 ...Y.........C..
db #FA,#4F,#67,#7B,#FE,#05,#B6,#9D,#CE,#EF,#7F,#CF,#FF,#1F,#E0,#10 ; #5d20 .Og{............
db #8B,#E0,#32,#01,#8F,#A6,#47,#2D,#97,#E1,#6D,#FF,#63,#FE,#3F,#C0 ; #5d30 ..2...G-..m.c.?.
db #0F,#C3,#EF,#1B,#A0,#0E,#57,#4C,#D8,#A0,#72,#4D,#8F,#FC,#7F,#80 ; #5d40 ......WL..rM....
db #11,#C4,#E8,#1B,#1D,#06,#39,#B5,#F9,#FF,#C1,#26,#D3,#E9,#B4,#9F ; #5d50 ......9....&....
db #8F,#F0,#1E,#D1,#E1,#DB,#00,#0F,#86,#9B,#17,#88,#E2,#A9,#FE,#D2 ; #5d60 ................
db #03,#85,#E2,#61,#37,#F0,#2D,#BF,#8F,#A5,#D0,#E0,#F2,#4E,#FC,#7F ; #5d70 ...a7.-......N..
db #80,#14,#D4,#E6,#5B,#00,#26,#49,#A3,#15,#9C,#DF,#6D,#4B,#F8,#0A ; #5d80 ....[.&I....mK..
db #CA,#45,#32,#9F,#F1,#FE,#08,#00,#F2,#72,#08,#0B,#96,#07,#FF,#1E ; #5d90 .E2......r......
db #10,#F1,#B2,#14,#3C,#3F,#4F,#E2,#D8,#4E,#1F,#9F,#F9,#BB,#DF,#80 ; #5da0 ....<?O..N......
db #EC,#06,#23,#01,#C7,#E3,#E1,#B7,#1D,#CE,#D7,#FC,#7F,#80,#10,#20 ; #5db0 ..#............
db #F5,#72,#1C,#7C,#09,#23,#E2,#DB,#BF,#E7,#13,#87,#FF,#1F,#E0,#13 ; #5dc0 .r.|.#..........
db #30,#F0,#B2,#FC,#2A,#23,#27,#C2,#D9,#FB,#3F,#7F,#3F,#FB,#FD,#EE ; #5dd0 0...*#''...?.?...
db #E7,#E3,#FC,#0B,#31,#FA,#32,#C1,#0B,#9D,#D7,#CE,#0B,#FF,#80,#13 ; #5de0 ....1.2.........
db #32,#FF,#B2,#25,#8C,#2F,#1C,#E2,#DB,#6E,#F7,#2F,#99,#C9,#F0,#F6 ; #5df0 2..%./...n./....
db #7F,#E3,#FC,#18,#33,#FF,#B2,#10,#8C,#2F,#8C,#F9,#FB,#7F,#E0,#5B ; #5e00 ....3..../.....[
db #63,#F5,#EE,#F7,#B9,#DC,#AE,#D7,#67,#FE,#3F,#C0,#11,#40,#F6,#F2 ; #5e10 c.......g.?..@..
db #04,#5C,#2D,#BC,#FA,#7B,#3B,#75,#3A,#5D,#0E,#FE,#3F,#C0,#11,#42 ; #5e20 .\-..{;u:]..?..B
db #FF,#B2,#80,#1C,#2F,#1C,#E2,#DB,#1F,#57,#6B,#BD,#CE,#FF,#8F,#F0 ; #5e30 ..../....Wk.....
db #10,#43,#FE,#F2,#81,#BD,#98,#07,#17,#89,#F1,#6C,#DF,#2F,#FE,#3F ; #5e40 .C.........l./.?
db #C0,#06,#44,#FD,#32,#61,#8B,#FE,#10,#45,#F9,#32,#E3,#0E,#5B,#10 ; #5e50 ..D.2a...E.2..[.
db #9A,#78,#51,#6C,#FC,#62,#7E,#3F,#C0,#15,#46,#F1,#B2,#41,#0A,#15 ; #5e60 .xQl.b~?..F..A..
db #3C,#A3,#BB,#DF,#DF,#FC,#0B,#6F,#77,#9B,#4F,#DE,#FC,#7F,#80,#12 ; #5e70 <......ow.O.....
db #47,#F8,#32,#12,#0E,#2F,#B5,#F8,#FF,#C0,#B6,#83,#E1,#F3,#FB,#FF ; #5e80 G.2../..........
db #C7,#F8,#14,#50,#F6,#F2,#10,#1C,#2F,#A4,#FA,#7B,#3A,#9F,#F0,#2D ; #5e90 ...P..../..{:..-
db #BC,#EE,#73,#38,#9F,#F1,#FE,#12,#57,#F4,#72,#04,#2A,#37,#B2,#F1 ; #5ea0 ..s8....W.r.*7..
db #F5,#3F,#E0,#3B,#6B,#E5,#EA,#FF,#C7,#F8,#06,#60,#FB,#B2,#24,#2B ; #5eb0 .?.;k......`..$+
db #FE,#0D,#61,#FB,#B2,#40,#8A,#15,#14,#C2,#31,#4F,#83,#CF,#FF,#06 ; #5ec0 ..a..@....1O....
db #62,#F4,#B2,#49,#0B,#FE,#17,#63,#F1,#F2,#01,#0A,#23,#24,#E2,#F3 ; #5ed0 b..I...c....#$..
db #98,#4B,#AA,#F2,#F4,#FF,#E0,#5B,#70,#BC,#BF,#EF,#C7,#F8,#13,#67 ; #5ee0 .K.....[p......g
db #F4,#72,#08,#1A,#23,#24,#C4,#3A,#AF,#AF,#93,#AB,#CC,#E5,#76,#FF ; #5ef0 .r..#$.:......v.
db #E3,#FC,#18,#70,#F9,#B2,#08,#1A,#03,#26,#D9,#4A,#4C,#A5,#38,#56 ; #5f00 ...p.....&.JL.8V
db #BB,#3D,#BF,#02,#D9,#EF,#37,#BB,#FE,#3F,#C0,#0B,#72,#F6,#72,#08 ; #5f10 .=....7..?..r.r.
db #2A,#23,#23,#F8,#A0,#7F,#F0,#14,#77,#F4,#B2,#08,#2B,#8A,#0F,#1B ; #5f20 *##.....w...+...
db #BA,#70,#EC,#5F,#8B,#A7,#DB,#F5,#FC,#FF,#E3,#FC,#0E,#80,#F1,#72 ; #5f30 .p._...........r
db #A0,#5C,#2F,#23,#E2,#DA,#7E,#1F,#FC,#7F,#80,#17,#81,#F9,#F2,#A1 ; #5f40 .\/#..~.........
db #8C,#5B,#18,#E1,#DA,#CF,#66,#D3,#29,#CC,#CA,#6F,#C0,#B6,#67,#BF ; #5f50 .[....f.)..o..g.
db #BF,#1F,#E0,#08,#82,#FE,#32,#41,#2B,#92,#07,#FF,#10,#83,#F9,#B2 ; #5f60 ......2A+.......
db #05,#0A,#2D,#0F,#81,#D3,#2F,#81,#87,#C1,#03,#FF,#80,#0D,#87,#F0 ; #5f70 ..-.../.........
db #F2,#48,#6B,#9D,#EF,#C4,#1E,#62,#01,#3F,#C0,#1A,#88,#F1,#32,#E1 ; #5f80 .Hk....b.?....2.
db #8C,#27,#36,#C1,#50,#4D,#84,#AF,#D3,#83,#E2,#85,#C5,#B5,#1D,#8F ; #5f90 .''6.PM..........
db #07,#9F,#3F,#BF,#1F,#E0,#06,#89,#FC,#F2,#41,#0B,#FE,#19,#8B,#F0 ; #5fa0 ..?.......A.....
db #32,#01,#0A,#15,#01,#F8,#80,#4C,#50,#38,#24,#FF,#80,#68,#FB,#7F ; #5fb0 2......LP8$..h..
db #F0,#1D,#84,#FE,#7F,#C7,#F8,#17,#93,#F9,#B2,#40,#1A,#1B,#29,#F8 ; #5fc0 ...........@..).
db #18,#7C,#10,#38,#76,#CB,#D5,#DB,#ED,#E6,#EA,#3C,#AF,#F8,#FF,#10 ; #5fd0 .|.8v......<....
db #94,#F8,#32,#C3,#0A,#5D,#24,#E0,#31,#BE,#33,#A3,#EE,#7F,#C7,#F8 ; #5fe0 ..2..]$.1.3.....
db #0B,#95,#F0,#32,#41,#0A,#63,#1C,#C1,#D1,#CF,#FE,#0F,#96,#F0,#72 ; #5ff0 ...2A.c........r
db #41,#0A,#19,#3F,#E1,#D8,#BE,#1F,#4B,#FE,#3F,#C0,#06,#97,#F6,#B2 ; #6000 A..?....K.?.....
db #03,#AB,#FE,#11,#C3,#FF,#19,#00,#0E,#47,#33,#44,#9B,#11,#B5,#D9 ; #6010 .........G3D....
db #DD,#CE,#FF,#8F,#F0,#1A,#D1,#F9,#D9,#00,#0E,#09,#10,#F9,#94,#7C ; #6020 ...............|
db #C4,#38,#1E,#DB,#6F,#BF,#02,#DA,#AF,#BF,#C3,#91,#CF,#FF,#8F,#F0 ; #6030 .8..o...........
db #0F,#41,#01,#E1,#40,#05,#AF,#2F,#D7,#8B,#E5,#B7,#F2,#DD,#FF,#E0 ; #6040 .A..@../........
db #12,#42,#01,#21,#41,#65,#AC,#EF,#D6,#6B,#8B,#60,#E0,#50,#2E,#16 ; #6050 .B.!Ae...k.`.P..
db #FC,#7F,#80,#0B,#44,#02,#61,#01,#25,#B2,#17,#25,#9D,#FF,#F0,#08 ; #6060 ....D.a.%..%....
db #34,#04,#A1,#48,#25,#B4,#37,#FF,#0D,#14,#09,#61,#19,#05,#B2,#1F ; #6070 4..H%.7....a....
db #11,#98,#7C,#E5,#FF,#F8,#0B,#13

LAB6088:
db #01,#A1,#41,#05,#B0,#07,#CB,#03 ; #6080 ..|.......A.....
db #FF,#80,#25,#9A,#F1,#B2,#00,#2A,#37,#17,#DA,#2E,#4D,#17,#38,#BC ; #6090 ..%....*7...M.8.
db #87,#E5,#75,#F3,#37,#F9,#80,#F1,#5D,#C1,#AF,#FE,#02,#B3,#FB,#F0 ; #60a0 ..u.7...].......
db #2D,#A0,#EF,#F5,#BA,#FF,#F1,#FE,#12,#8A,#F0,#B2,#FD,#0A,#5D,#24 ; #60b0 -.............]$
db #E2,#B8,#9F,#F8,#16,#CF,#D7,#FB,#FB,#F1,#FE,#19,#00,#B1,#9B,#0C ; #60c0 ................
db #07,#A3,#24,#03,#9C,#42,#88,#FA,#D1,#93,#80,#4B,#D9,#26,#23,#F1 ; #60d0 ..$..B.....K.&#.
db #67,#6F,#BF,#C7,#F8,#00,#06,#79,#11,#E8,#60,#0F,#FE,#0B,#7A,#18 ; #60e0 go.....y..`...z.
db #68,#21,#01,#8A,#0F,#C5,#1F,#FF,#80,#0B,#7B,#18,#68,#40,#80,#6F ; #60f0 h!........{.h@.o
db #0B,#F8,#A0,#7F,#F0,#0B,#7C,#1A,#28,#82,#00,#23,#9C,#F1,#FF,#C7 ; #6100 ......|.(..#....
db #F8,#0B,#7D,#11,#A8,#02,#8E,#09,#1B,#FA,#40,#7F,#F0,#15,#77,#29 ; #6110 ..}.......@...w)
db #28,#FC,#00,#23,#09,#E0,#B9,#FA,#FE,#7F,#FE,#00,#F6,#3D,#3F,#27 ; #6120 (..#.........=?''
db #FC,#7F,#80,#14,#78,#21,#68,#43,#80,#03,#39,#62,#73,#D5,#85,#57 ; #6130 ....x!hC..9bs..W
db #05,#DC,#CE,#A7,#73,#D7,#F8,#FF,#08,#79,#21,#E8,#19,#01,#9C,#F7 ; #6140 ....s....y!.....
db #FF,#0F,#7D,#21,#A8,#04,#0D,#AB,#FF,#D5,#FF,#02,#46,#FE,#90,#1F ; #6150 ..}!........F...
db #FC,#0D,#87,#26,#A8,#08,#20,#1F,#9C,#F2,#76,#FC,#7F,#F1,#FE,#19 ; #6160 ...&.. ...v.....
db #89,#27,#A8,#04,#20,#69,#2B,#BA,#87,#FD,#42,#39,#16,#CE,#69,#3F ; #6170 .''.. i+...B9..i?
db #00,#BA,#3F,#65,#EE,#79,#3F,#1F,#E0,#06,#97,#21,#E8,#00,#7F,#FE ; #6180 ..?e.y?....!....
db #19,#99,#27,#A8,#08,#11,#A9,#87,#34,#D5,#E4,#F7,#E0,#17,#57,#CB ; #6190 ..''.....4.....W.
db #81,#C3,#20,#91,#3A,#A5,#4F,#FE,#3F,#C0,#08,#9D,#27,#28,#08,#61 ; #61a0 .. .:.O.?...''(.a
db #A9,#3F,#FF,#08,#A9,#2E,#68,#48,#61,#9D,#7F,#FF,#0D,#AA,#24,#E8 ; #61b0 .?....hHa.....$.
db #41,#00,#23,#3D,#E0,#B0,#5F,#A9,#0E,#FF,#06,#AB,#2D,#68,#41,#01 ; #61c0 A.#=.._.....-hA.
db #FE,#16,#AC,#28,#E8,#82,#0C,#5B,#1F,#E0,#B9,#BE,#C7,#FC,#07,#E3 ; #61d0 ...(...[........
db #F1,#1B,#5D,#BF,#73,#FE,#3F,#C0,#06,#AD,#2E,#A8,#E1,#21,#FE,#17 ; #61e0 ..].s.?......!..
db #AE,#26,#68,#09,#00,#45,#03,#A0,#72,#BE,#1F,#03,#E0,#B8,#CA,#24 ; #61f0 .&h..E..r......$
db #2F,#17,#CC,#C6,#7F,#C7,#F8,#12,#B9,#27,#E8,#08,#20,#37,#73,#E1 ; #6200 /........''.. 7s.
db #FA,#4C,#E6,#B3,#C9,#DC,#EA,#7F,#C7,#F8,#12,#BE,#20,#28,#08,#40 ; #6210 .L.......... (.@
db #4B,#20,#E6,#72,#9E,#0B,#AF,#EB,#76,#FE,#3F,#F1,#FE,#14,#C9,#23 ; #6220 K .r....v.?....#
db #28,#10,#4C,#45,#A9,#94,#DA,#75,#3F,#9D,#CF,#FC,#02,#E0,#FF,#9F ; #6230 (.LE...u?.......
db #F1,#FE,#15,#CB,#24,#68,#B4,#00,#1F,#05,#E6,#75,#BC,#2B,#AC,#F2 ; #6240 ....$h.....u.+..
db #7F,#C0,#2E,#6F,#F7,#FF,#1F,#E0,#09,#CD,#23,#E8,#61,#80,#6B,#23 ; #6250 ...o......#.a.k#
db #FF,#E0,#09,#CE,#2B,#A8,#41,#20,#67,#23,#FF,#E0,#12,#CF,#21,#68 ; #6260 ....+.A g#....!h
db #0B,#00,#17,#9B,#EE,#7F,#C0,#2E,#62,#21,#10,#A8,#7F,#C7,#F8,#0E ; #6270 ........b!......
db #D8,#29,#A8,#C0,#00,#03,#1A,#E2,#3A,#0E,#DF,#FC,#7F,#80,#06,#D9 ; #6280 .)......:.......
db #24,#A8,#09,#21,#FE,#0B,#DB,#25,#A8,#08,#20,#33,#A4,#ED,#FF,#C7 ; #6290 $..!...%.. 3....
db #F8,#08,#DF,#25,#28,#08,#61,#9D,#3F,#FF,#11,#E9,#20,#28,#14,#5C ; #62a0 ...%(.a.?... (.\
db #45,#80,#EC,#7E,#3F,#E0,#17,#77,#C4,#FF,#8F,#F0,#0B,#EB,#27,#28 ; #62b0 E..~?..w......''(
db #D8,#20,#0B,#BB,#DD,#FF,#C7,#F8,#0B,#EC,#28,#E8,#42,#00,#6D,#B3 ; #62c0 . ........(.B.m.
db #E6,#7F,#C7,#F8,#24,#ED,#2E,#A8,#22,#8C,#65,#0B,#E1,#F8,#DB,#B5 ; #62d0 ....$...".e.....
db #26,#FE,#01,#F6,#BE,#DF,#2F,#57,#BB,#FF,#00,#D9,#9E,#8F,#27,#FE ; #62e0 &...../W......''.
db #02,#71,#BC,#CE,#57,#DB,#FE,#3F,#C0,#1E,#EE,#2E,#A8,#A0,#8C,#65 ; #62f0 .q..W..?.......e
db #34,#E1,#FB,#1B,#95,#BA,#ED,#7F,#01,#3B,#1F,#97,#CF,#EB,#F6,#FF ; #6300 4........;......
db #80,#6D,#77,#9B,#BD,#FF,#1F,#E0,#0B,#EF,#20,#68,#03,#21,#A9,#E7 ; #6310 .mw....... h.!..
db #CB,#0F,#FF,#80,#18,#F9,#21,#A8,#40,#21,#82,#17,#0F,#D1,#F7,#3F ; #6320 ......!.@!.....?
db #E0,#47,#37,#E4,#FF,#80,#2E,#BD,#5F,#2F,#FF,#1F,#E0,#06,#FA,#2D ; #6330 .G7....._/.....-
db #E8,#41,#01,#FE,#13,#FB,#23,#68,#01,#20,#17,#3E,#E2,#B2,#4E,#0B ; #6340 .A....#h. .>..N.
db #B9,#FC,#EE,#6F,#33,#97,#F8,#FF,#1A,#97,#31,#E8,#00,#0E,#0D,#8F ; #6350 ...o3.....1.....
db #E3,#FF,#C0,#46,#03,#83,#C2,#E1,#F1,#38,#BC,#6F,#F8,#00,#CF,#F9 ; #6360 ...F.....8.o....
db #FF,#E3,#FC,#09,#97,#41,#E8,#08,#00,#09,#00,#FF,#E0,#1C,#A7,#43 ; #6370 .....A.........C
db #A8,#00,#20,#05,#24,#E6,#72,#3F,#A8,#06,#11,#D0,#F9,#7F,#E0,#0F ; #6380 .. .$.r?........
db #03,#F9,#FF,#80,#5D,#22,#92,#7E,#3F,#C0,#06,#3B,#33,#00,#09,#23 ; #6390 ....]".~?..;3..#
db #FE,#08,#1B,#3F,#80,#08,#03,#96,#07,#FF,#08,#39,#3E,#00,#40,#03 ; #63a0 ...?.......9>.@.
db #96,#07,#FF,#09,#2B,#37,#40,#08,#22,#55,#24,#FF,#E0,#16,#4A,#37 ; #63b0 ....+7@."U$...J7
db #C0,#14,#23,#86,#FE,#C3,#63,#07,#6B,#2D,#92,#C7,#5B,#FC,#0B,#6A ; #63c0 ..#...c.k-..[..j
db #FD,#9F,#F1,#FE,#15,#4B,#31,#40,#E0,#7D,#8C,#DF,#C6,#7B,#E3,#19 ; #63d0 .....K1@.}...{..
db #F1,#A4,#E2,#DA,#78,#1C,#12,#7E,#3F,#C0,#17,#4C,#30,#80,#09,#02 ; #63e0 ....x..~?..L0...
db #55,#3A,#E6,#F1,#2F,#8E,#07,#0E,#CB,#6C,#B4,#7D,#CE,#BE,#EB,#7E ; #63f0 U:../....l.}...~
db #3F,#C0,#14,#5C,#32,#C0,#10,#33,#8A,#2F,#C5,#0B,#87,#67,#7C,#5F ; #6400 ?..\2..3./...g|_
db #F0,#23,#A5,#ED,#7F,#C7,#F8,#13,#6C,#3F,#40,#03,#A2,#6D,#24,#E2 ; #6410 .#......l?@..m$.
db #D1,#97,#98,#03,#0B,#C7,#76,#7E,#BF,#F1,#FE,#24,#69,#31,#80,#FC ; #6420 ......v~...$i1..
db #02,#23,#24,#E2,#D0,#8E,#2B,#08,#C5,#70,#9C,#09,#09,#E2,#D9,#7E ; #6430 .#$...+..p.....~
db #FD,#EE,#79,#08,#FF,#80,#EC,#0F,#07,#15,#CA,#C8,#F4,#77,#E3,#FC ; #6440 ..y..........w..
db #1B,#8A,#39,#80,#41,#02,#37,#DA,#F2,#FF,#C0,#76,#B7,#39,#F3,#E6 ; #6450 ..9.A.7....v.9..
db #74,#B4,#7F,#2E,#97,#2B,#9B,#ED,#FA,#FF,#C7,#F8,#17,#58,#30,#C0 ; #6460 t....+.......X0.
db #83,#0C,#17,#3C,#E2,#F8,#4E,#E7,#73,#7E,#05,#B4,#11,#88,#07,#7F ; #6470 ...<..N.s~......
db #CF,#FF,#1F,#E0,#19,#57,#31,#00,#40,#72,#6D,#38,#C3,#12,#3A,#17 ; #6480 .....W1.@rm8..:.
db #A3,#5C,#7F,#C0,#B6,#11,#86,#E3,#71,#C8,#F4,#7F,#F1,#FE,#09,#47 ; #6490 .\......q......G
db #34,#40,#08,#22,#7B,#1B,#FF,#E0,#14,#3A,#31,#80,#DB,#82,#03,#00 ; #64a0 4@."{....:1.....
db #58,#82,#31,#6D,#3F,#7F,#BF,#9E,#F3,#D9,#F7,#E3,#FC,#1D,#8E,#35 ; #64b0 X.1m?..........5
db #F9,#00,#86,#76,#8D,#E5,#7A,#5E,#77,#AD,#FE,#FF,#AE,#FC,#1D,#23 ; #64c0 ...v..z^w......#
db #71,#5C,#97,#1D,#CB,#77,#AD,#EF,#3F,#1F,#E0,#19,#5A,#38,#40,#0B ; #64d0 q\...w..?...Z8@.
db #22,#17,#30,#E2,#32,#2E,#2D,#A0,#8C,#4F,#C0,#76,#CB,#D5,#E3,#ED ; #64e0 ".0.2.-..O.v....
db #F4,#B9,#5F,#F1,#FE,#2B,#8D,#31,#F9,#20,#06,#2B,#10,#E7,#55,#8C ; #64f0 .._..+.1. .+..U.
db #77,#58,#F9,#8F,#FD,#B0,#FE,#D8,#FC,#5B,#1F,#D7,#EB,#E7,#FF,#FF ; #6500 wX.......[......
db #EF,#F8,#3C,#C8,#E4,#72,#39,#1C,#8E,#47,#7E,#09,#32,#19,#1D,#F8 ; #6510 ..<..r9..G~.2...
db #FF,#1B,#59,#3B,#80,#41,#02,#35,#14,#82,#B1,#BF,#80,#44,#C1,#E3 ; #6520 ..Y;.A.5.....D..
db #85,#EA,#FA,#87,#F0,#05,#94,#4E,#25,#1B,#93,#F1,#FE,#10,#79,#34 ; #6530 .......N%.....y4
db #00,#08,#22,#6F,#64,#F9,#00,#70,#ED,#57,#B7,#FE,#3F,#C0,#0D,#69 ; #6540 .."od..p.W..?..i
db #21,#80,#00,#0E,#2D,#07,#E2,#F0,#6F,#88,#2F,#FF,#12,#6A,#38,#80 ; #6550 !...-...o./..j8.
db #C1,#62,#23,#AF,#F8,#7F,#C0,#B6,#7E,#CF,#6F,#DB,#FF,#C7,#F8,#1A ; #6560 .b#.....~.o.....
db #37,#31,#80,#0C,#02,#23,#1B,#E7,#D1,#EC,#1D,#8F,#E7,#7B,#FD,#DD ; #6570 71...#.......{..
db #EF,#36,#9F,#2D,#97,#CF,#D7,#F7,#E3,#FC,#22,#6B,#39,#00,#83,#0D ; #6580 .6.-......"k9...
db #98,#8F,#1E,#C8,#54,#74,#9D,#4E,#97,#FC,#07,#6D,#E6,#D7,#5B,#F8 ; #6590 ....Tt.N...m..[.
db #16,#D8,#F6,#24,#11,#FF,#3F,#CE,#E6,#F3,#DF,#8F,#F0,#08,#CC,#2C ; #65a0 ...$..?........,
db #28,#C1,#01,#9C,#17,#FF,#19,#89,#31,#C0,#E0,#22,#23,#3E,#C2,#73 ; #65b0 (.......1.."#>.s
db #88,#57,#3E,#E2,#D3,#8B,#88,#1F,#14,#C8,#FA,#7D,#9D,#4F,#F8,#FF ; #65c0 .W>........}.O..
db #25,#8B,#30,#40,#01,#8D,#8D,#CF,#C6,#67,#E1,#89,#C0,#22,#F8,#7B ; #65d0 %.0@.....g...".{
db #01,#C3,#E3,#E1,#F8,#DF,#F0,#2D,#B8,#FC,#6E,#25,#1D,#7F,#F8,#24 ; #65e0 .......-..n%...$
db #C7,#D5,#AB,#F7,#F1,#FE,#08,#8D,#21,#A8,#14,#1D,#88,#07,#FF
db #00 

; ------------------------ DATA ---------------------

org #6600
buf6600 ;rempli de motifs par rotation (l ror 4)
	ds 256,0
buf6700
	ds 256,0
buf6800
	ds 256,0
buf6900 ;autre motif par rotation

ds 2008,0

db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #70d8 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#03,#03,#03,#03,#FF,#FF  
db #0E,#0E,#00,#00,#39,#38,#55,#00,#E2,#E0,#2B,#00,#85,#80,#55,#00 
db #82,#98,#2B,#00,#01,#3C,#55,#00,#00,#24,#00,#00,#49,#09,#15,#15 
db #9E,#1E,#80,#80,#57,#17,#55,#40,#AF,#2F,#4B,#40,#33,#33,#A5,#A0 
db #AC,#2C,#AB,#A0,#2F,#2F,#45,#40,#96,#16,#B3,#B0,#40,#00,#50,#50 
db #9E,#1E,#E9,#E9,#2F,#2F,#E8,#E8,#6F,#6F,#6B,#68,#9F,#1F,#65,#60 
db #6F,#6F,#6B,#68,#6F,#6F,#65,#60,#6F,#6F,#6B,#68,#5F,#5F,#49,#48 
db #9F,#1F,#48,#48,#4E,#4E,#89,#89,#9E,#1E,#40,#40,#41,#41,#C9,#C8 
db #5F,#5F,#93,#90,#5F,#5F,#59,#58,#42,#42,#C3,#C0,#1D,#1D,#C5,#C0 
db #5D,#5D,#CB,#C0,#2D,#2D,#C0,#C0,#6D,#6D,#D5,#D5,#9D,#1D,#80,#80 
db #3C,#3C,#0B,#00,#39,#39,#95,#80,#02,#02,#0B,#00,#1B,#1B,#95,#80 
db #23,#23,#80,#8A,#3B,#3B,#80,#95,#3B,#3B,#80,#8B,#3B,#3B,#80,#95 
db #3B,#3B,#00,#2B,#38,#38,#C0,#C5,#3B,#3B,#F0,#F0,#20,#20,#60,#60 
db #1C,#1C,#00,#00,#1E,#1E,#00,#00,#0C,#0C,#00,#00,#00,#00,#00,#00 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#03,#03,#00,#00,#07,#07 
db #00,#00,#30,#30,#00,#00,#D7,#D0,#03,#03,#D7,#D0,#0F,#0F,#17,#10 ; #71d8
db #3C,#3C,#D7,#10,#53,#50,#D7,#10,#8F,#80,#DB,#18,#1F,#00,#D4,#14 
db #9F,#00,#33,#33,#9C,#00,#D4,#D0,#93,#03,#17,#10,#8C,#0C,#D7,#10 
db #B3,#30,#D7,#10,#8F,#00,#D7,#10,#1F,#00,#D7,#10,#9F,#80,#D3,#10 
db #1F,#00,#D4,#14,#9F,#00,#33,#33,#9C,#00,#D4,#D0,#93,#03,#17,#10 
db #8C,#0C,#D7,#10,#B3,#30,#D7,#10,#8F,#00,#D7,#10,#1F,#00,#D7,#10 
db #9F,#80,#D3,#10,#1F,#00,#D4,#14,#9F,#00,#33,#33,#9C,#00,#D4,#D0 
db #93,#03,#17,#10,#8C,#0C,#D7,#10,#B3,#30,#D7,#10,#8F,#00,#D7,#10 
db #1F,#00,#D7,#10,#9F,#80,#DB,#18,#1F,#00,#D4,#14,#9F,#00,#33,#33 
db #9C,#00,#D4,#D0,#93,#03,#17,#10,#8C,#0C,#D7,#10,#B3,#30,#D7,#10 
db #8F,#00,#D7,#10,#1F,#00,#C0,#00,#9F,#80,#00,#0B,#1C,#00,#00,#2D  
db #90,#00,#00,#BD,#80,#02,#00,#DD,#80,#0B,#00,#DA,#80,#2D,#00,#D8  
db #00,#3D,#00,#A0,#00,#DD,#00,#80,#00,#DA,#00,#00,#00,#D8,#00,#00  
db #00,#A0,#00,#00,#00,#80,#00,#00,#00,#00,#03,#03,#00,#00,#07,#07 
db #00,#00,#30,#30,#00,#00,#D7,#D0,#03,#03,#D7,#D0,#0F,#0F,#17,#10 
db #3C,#3C,#D7,#10,#53,#50,#D7,#10,#8F,#80,#DB,#18,#1F,#00,#D4,#14 
db #9F,#00,#33,#33,#9C,#00,#C4,#C0,#93,#03,#17,#10,#8C,#0C,#C7,#00 ; #72d8
db #B3,#30,#17,#10,#8C,#00,#67,#60,#10,#00,#87,#80,#87,#87,#83,#80 
db #1F,#1F,#84,#84,#99,#19,#83,#93,#93,#13,#84,#B0,#9B,#1B,#07,#70 
db #9E,#1E,#07,#F0,#9C,#1D,#07,#E0,#90,#13,#07,#C0,#00,#0F,#07,#80 
db #80,#9F,#03,#00,#00,#1E,#84,#84,#81,#19,#83,#83,#87,#07,#84,#80 
db #9D,#1D,#87,#80,#9C,#1C,#87,#80,#99,#19,#87,#80,#8D,#0D,#97,#90 
db #0F,#0F,#97,#90,#83,#83,#5B,#18,#18,#00,#D4,#14,#9F,#00,#33,#33 
db #9C,#00,#D4,#D0,#93,#03,#17,#10,#8C,#0C,#D7,#10,#B3,#30,#D7,#10 
db #8F,#00,#D7,#10,#1F,#00,#C0,#00,#9F,#80,#00,#0B,#1C,#00,#00,#2D 
db #90,#00,#00,#BD,#80,#02,#00,#DD,#80,#0B,#00,#DA,#80,#2D,#00,#D8 
db #00,#3D,#00,#A0,#00,#DD,#00,#80,#00,#DA,#00,#00,#00,#D8,#00,#00 
db #00,#A0,#00,#00,#00,#80,#00,#00,#00,#00,#03,#00,#00,#00,#0F,#00 
db #00,#00,#3E,#00,#00,#00,#D9,#00,#03,#00,#67,#00,#0D,#00,#95,#00 
db #36,#00,#76,#00,#D9,#00,#F0,#01,#E7,#00,#E0,#07,#97,#00,#80,#1F 
db #76,#00,#60,#6F,#D1,#01,#F0,#F7,#67,#07,#F8,#FB,#9F,#1F,#FC,#FD 
db #0F,#6F,#FC,#FC,#07,#F7,#F2,#F2,#03,#FB,#CE,#CE,#01,#FD,#3E,#3E 
db #00,#FC,#FE,#FE,#00,#F2,#FC,#FC,#00,#CE,#79,#79,#00,#3E,#05,#05 ; #73d8
db #00,#FE,#1A,#1A,#00,#FC,#DD,#DD,#00,#7A,#A3,#A3,#00,#01,#5D,#5D 
db #00,#00,#3A,#BA,#C0,#00,#1D,#5D,#C0,#00,#0B,#2B,#DC,#1C,#03,#13 
db #DA,#1A,#01,#09,#DD,#1D,#C0,#C4,#C3,#03,#A0,#A3,#DD,#1D,#C0,#CC 
db #DA,#1A,#02,#30,#DC,#1C,#0E,#C0,#C0,#03,#2E,#00,#C0,#0C,#EE,#00 
db #C2,#10,#ED,#00,#CE,#00,#E1,#00,#DE,#00,#C5,#00,#DE,#00,#05,#10 
db #DC,#00,#65,#00,#C1,#00,#F5,#00,#C3,#00,#F5,#00,#C0,#00,#F1,#00 
db #C0,#00,#0D,#0C,#C0,#00,#39,#38,#C0,#00,#E5,#E0,#C3,#03,#80,#80 
db #CE,#0E,#00,#00,#D8,#18,#00,#00,#C0,#00,#00,#00,#C0,#00,#00,#00 
db #C0,#00,#00,#00,#80,#00,#00,#00,#00,#00,#03,#00,#00,#00,#0F,#00 
db #00,#00,#3E,#00,#00,#00,#D9,#00,#03,#00,#67,#00,#0D,#00,#95,#00 
db #36,#00,#76,#00,#D9,#00,#F0,#01,#E7,#00,#E0,#07,#97,#00,#80,#1F 
db #76,#00,#60,#6F,#D1,#01,#F0,#F7,#67,#07,#F8,#FB,#9F,#1F,#FC,#FD 
db #0F,#6F,#FC,#FC,#07,#F7,#F2,#F2,#03,#FB,#CE,#CE,#01,#FD,#3E,#3E 
db #00,#FC,#FE,#FE,#00,#F2,#FC,#FC,#00,#CE,#79,#78,#00,#3E,#05,#00 
db #00,#FE,#05,#00,#00,#FC,#05,#00,#00,#7A,#05,#00,#00,#01,#05,#00 
db #00,#00,#05,#80,#C0,#C0,#05,#40,#A0,#A0,#05,#20,#DC,#DC,#05,#10 ; #74d8
db #3A,#3A,#01,#08,#DD,#DD,#C1,#C4,#A3,#A3,#A0,#A2,#DD,#DD,#C0,#CC 
db #3A,#3A,#02,#30,#DC,#DC,#0E,#C0,#A0,#A3,#2E,#00,#C0,#CC,#EE,#00 
db #02,#30,#ED,#00,#0E,#C0,#E1,#00,#2E,#00,#C5,#00,#EE,#00,#05,#10 
db #EC,#00,#65,#00,#E1,#00,#F5,#00,#C3,#00,#F5,#00,#00,#00,#F1,#00 
db #80,#00,#0D,#0C,#80,#00,#39,#38,#80,#00,#E5,#E0,#83,#03,#80,#80 
db #8E,#0E,#00,#00,#B8,#38,#00,#00,#A0,#20,#00,#00,#80,#00,#00,#00 
db #80,#00,#00,#00,#80,#00,#00,#00,#00,#00,#03,#00,#00,#00,#0F,#00 
db #00,#00,#3E,#00,#00,#00,#D9,#00,#03,#00,#67,#00,#0D,#00,#95,#00 
db #36,#00,#76,#00,#D9,#00,#F0,#01,#E7,#00,#E0,#07,#8F,#00,#80,#1F 
db #6E,#00,#60,#6F,#C9,#01,#F0,#F7,#67,#07,#F8,#FB,#9F,#1F,#FC,#FD 
db #0F,#6F,#FC,#FC,#07,#F7,#F2,#F2,#03,#FB,#CE,#CE,#01,#FD,#3E,#3E 
db #00,#FC,#FE,#FE,#00,#F2,#FC,#FC,#00,#CE,#78,#78,#00,#3E,#06,#00 
db #00,#FE,#06,#00,#00,#FC,#06,#00,#00,#78,#36,#00,#00,#00,#76,#00 
db #01,#00,#36,#00,#85,#00,#C6,#00,#85,#00,#E6,#00,#89,#00,#E6,#00 
db #AE,#00,#62,#00,#AF,#00,#04,#04,#8F,#00,#4A,#0A,#B3,#00,#1C,#1C 
db #BC,#00,#6A,#68,#80,#00,#B6,#B0,#DB,#1B,#66,#60,#AD,#2D,#96,#80 ; #75d8
db #DB,#1B,#36,#00,#80,#00,#16,#80,#BE,#00,#06,#60,#BF,#00,#86,#10 
db #BF,#00,#E6,#00,#8F,#00,#F6,#00,#83,#00,#F6,#00,#80,#00,#F6,#00 
db #80,#00,#36,#00,#80,#00,#08,#00,#80,#00,#06,#00,#80,#00,#00,#00 
db #80,#00,#00,#00,#80,#00,#00,#00,#80,#00,#00,#00,#80,#00,#00,#00 
db #80,#00,#00,#00,#80,#00,#00,#00,#00,#00,#03,#03,#00,#00,#0E,#0E 
db #00,#00,#38,#38,#00,#00,#E0,#E6,#03,#03,#80,#9E,#0E,#0E,#00,#7C 
db #38,#39,#02,#E0,#E0,#E7,#1E,#C0,#80,#9E,#3C,#00,#01,#7C,#F2,#02 
db #03,#E0,#CC,#0C,#1F,#C0,#32,#30,#3C,#00,#CE,#C0,#F3,#03,#3E,#00 
db #CC,#0C,#F2,#00,#33,#30,#F6,#00,#CF,#C0,#3A,#00,#3E,#00,#16,#40 
db #FE,#00,#3A,#00,#EB,#00,#D6,#00,#A7,#00,#3E,#00,#CF,#00,#DE,#00 
db #EF,#00,#3A,#00,#D7,#00,#FE,#00,#DF,#00,#FC,#00,#F7,#00,#F2,#02 
db #CF,#00,#CC,#0C,#FF,#00,#32,#30,#FC,#00,#CE,#C0,#F3,#03,#3E,#00 
db #CC,#0C,#FE,#00,#33,#30,#FE,#00,#CF,#C0,#FE,#00,#3E,#00,#7E,#00 
db #FC,#00,#3E,#80,#F8,#00,#1E,#C0,#F0,#01,#0E,#E0,#E0,#01,#06,#F0 
db #C0,#01,#06,#E0,#C0,#03,#1E,#80,#E0,#02,#7C,#00,#F9,#00,#F2,#02 
db #FF,#00,#CC,#0C,#FF,#00,#32,#30,#FC,#00,#CE,#C0,#F3,#03,#3E,#00 ; #76d8
db #CC,#0C,#FC,#00,#33,#30,#E0,#02,#CF,#C0,#C0,#1E,#3E,#00,#00,#3C 
db #FC,#01,#00,#F0,#E0,#03,#00,#C0,#C0,#1F,#00,#00,#00,#3C,#00,#00 
db #00,#F0,#00,#00,#00,#C0,#00,#00,#00,#00,#FF,#FF,#03,#03,#80,#80 
db #0E,#0E,#00,#2A,#38,#39,#00,#54,#E0,#E2,#2A,#00,#81,#94,#54,#00 
db #8A,#A0,#2A,#00,#15,#40,#54,#00,#20,#00,#2A,#2A,#1F,#1F,#94,#80 
db #7F,#7F,#CA,#C0,#7E,#7E,#54,#40,#F9,#F8,#AA,#20,#F7,#F0,#24,#20 
db #F1,#F0,#AA,#20,#F7,#F0,#B0,#30,#F7,#F0,#A2,#20,#F3,#F0,#00,#18 
db #30,#34,#02,#B8,#00,#C7,#00,#F8,#00,#7F,#02,#F8,#00,#FF,#00,#F8 
db #00,#FF,#02,#78,#00,#FB,#00,#B8,#00,#EF,#02,#BA,#00,#F7,#00,#78 
db #00,#EF,#02,#50,#00,#FF,#00,#E0,#00,#FD,#02,#F0,#00,#FB,#04,#F0 
db #00,#FF,#0A,#E0,#00,#EF,#04,#E0,#00,#7F,#0A,#E0,#00,#FF,#04,#E0  
db #00,#7F,#0A,#E0,#00,#BF,#14,#C0,#00,#7F,#0A,#C0,#00,#BF,#14,#C0  
db #00,#7D,#0A,#C0,#00,#BF,#14,#C0,#00,#7D,#0A,#CA,#00,#BF,#14,#C0  
db #00,#7D,#0A,#C0,#00,#BF,#14,#C0,#00,#7D,#0A,#C0,#00,#BF,#04,#E0  
db #00,#7E,#00,#F2,#00,#BF,#00,#F4,#00,#5F,#00,#F0,#00,#AF,#00,#F0  

assert $==#77d8
db #00,#5F,#00,#E0,#00,#AF,#00,#80,#00,#5E,#00,#00,#00,#18,#00,#00 ; #77d8
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#02,#02,#00,#00,#06,#06 
db #00,#00,#28,#28,#00,#00,#66,#60,#02,#02,#9C,#80,#06,#06,#72,#00 
db #29,#28,#D4,#00,#67,#60,#AA,#00,#9D,#80,#54,#00,#7A,#00,#A8,#00 
db #D5,#00,#50,#00,#AA,#00,#A6,#00,#D5,#00,#1C,#00,#AA,#00,#7A,#00 
db #D0,#00,#C4,#00,#A6,#00,#92,#10,#1C,#00,#64,#60,#71,#01,#80,#90 
db #C6,#06,#00,#70,#98,#19,#06,#F0,#D0,#17,#04,#00,#90,#14,#02,#D0 
db #D1,#15,#00,#68,#90,#12,#80,#A8,#10,#16,#80,#AC,#61,#0D,#00,#4C 
db #C0,#0C,#00,#0C,#80,#18,#A0,#0C,#C1,#18,#00,#18,#80,#18,#42,#18 
db #C0,#18,#80,#30,#80,#0C,#02,#70,#00,#0F,#04,#E0,#60,#07,#0A,#80 
db #D0,#00,#10,#00,#AA,#00,#A6,#00,#D4,#00,#1C,#00,#AA,#00,#7A,#00 
db #D1,#00,#D4,#00,#A7,#00,#AA,#00,#1D,#00,#04,#00,#78,#00,#00,#F0 
db #D0,#03,#00,#0C,#A0,#0C,#20,#24,#C1,#19,#20,#2A,#81,#31,#20,#2A 
db #81,#21,#20,#2A,#09,#69,#20,#2A,#09,#49,#20,#22,#09,#C9,#00,#4C 
db #08,#4A,#00,#30,#08,#C8,#00,#C0,#00,#B3,#00,#00,#00,#8C,#00,#00 
db #00,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#22,#22,#02,#02,#76,#76 
db #06,#06,#88,#88,#29,#28,#54,#00,#62,#60,#22,#00,#95,#80,#4C,#0C ; #78d8
db #2A,#00,#1E,#1E,#51,#00,#0A,#2A,#A6,#06,#00,#30,#5F,#1F,#80,#80 
db #3F,#3F,#D2,#D0,#BC,#BC,#98,#98,#D8,#D8,#92,#90,#DD,#DD,#48,#48 
db #46,#46,#52,#50,#1B,#9B,#98,#98,#08,#08,#50,#50,#87,#87,#B0,#B0 
db #C8,#C8,#26,#20,#64,#64,#C4,#C0,#4B,#4B,#22,#20,#1D,#1D,#C4,#C0 
db #21,#21,#22,#20,#1D,#1D,#C4,#C0,#21,#21,#20,#20,#1D,#1D,#C0,#C0 
db #22,#22,#0E,#00,#1C,#1C,#14,#00,#00,#00,#2A,#00,#0C,#0C,#14,#00 
db #03,#03,#8A,#80,#1B,#1B,#C4,#C0,#3E,#3E,#C8,#C0,#6E,#6E,#C0,#C0 
db #67,#67,#8E,#80,#7F,#7F,#14,#00,#1A,#1A,#8A,#80,#69,#69,#84,#80 
db #31,#31,#CA,#C0,#38,#38,#C4,#C0,#18,#18,#80,#80,#1C,#1C,#66,#60 
db #08,#88,#44,#40,#04,#64,#22,#20,#0C,#4C,#C4,#C0,#10,#51,#0A,#00 
db #18,#1B,#14,#80,#10,#51,#0A,#00,#02,#E2,#80,#80,#03,#43,#E0,#E0 
db #80,#80,#C0,#C0,#E0,#E0,#00,#00,#78,#78,#00,#00,#30,#30,#00,#00 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#0F,#00,#00,#00,#36,#30 
db #00,#00,#F8,#F9,#03,#03,#E0,#E7,#0D,#01,#80,#9E,#1E,#00,#00,#58 
db #38,#01,#03,#D0,#60,#07,#0C,#80,#80,#1E,#39,#00,#00,#58,#F2,#00 
db #03,#D0,#D0,#00,#0E,#80,#D4,#00,#3F,#00,#B8,#00,#C7,#00,#F6,#00 ; #79d8
db #9B,#00,#B7,#00,#6D,#00,#EE,#00,#3D,#00,#BE,#00,#B5,#00,#FD,#00 
db #99,#00,#F7,#00,#93,#00,#7F,#00,#8F,#00,#C6,#00,#7B,#00,#3A,#00 
db #BE,#00,#F0,#01,#FC,#00,#20,#06,#EB,#00,#01,#19,#F6,#00,#07,#67 
db #B0,#01,#07,#B7,#E0,#06,#43,#5B,#81,#19,#E0,#EC,#07,#67,#F0,#F7 
db #07,#B7,#C0,#CE,#43,#5B,#01,#38,#E0,#EC,#07,#E0,#F0,#F7,#1F,#80 
db #C0,#CE,#73,#00,#01,#38,#C3,#08,#07,#E0,#03,#08,#1C,#80,#23,#28 
db #71,#01,#83,#88,#C2,#02,#23,#28,#D9,#19,#83,#88,#C2,#02,#23,#28 
db #D9,#19,#83,#88,#C2,#02,#03,#30,#D8,#18,#0F,#C0,#C0,#03,#3E,#00 
db #C0,#0C,#F9,#01,#C3,#10,#E6,#06,#CF,#00,#98,#1B,#FE,#00,#60,#6C 
db #F9,#01,#80,#B0,#E6,#06,#00,#C0,#98,#1B,#00,#00,#60,#6C,#00,#00 
db #80,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#0F,#00,#00,#00,#36,#30 
db #00,#00,#F8,#F9,#03,#03,#E0,#E7,#0D,#01,#80,#9E,#1E,#00,#00,#58 
db #38,#01,#03,#D0,#60,#07,#0F,#80,#80,#1E,#38,#00,#00,#58,#F6,#00 
db #03,#D0,#AF,#00,#00,#80,#E7,#00,#17,#00,#22,#00,#49,#00,#D1,#00 
db #12,#00,#6B,#00,#48,#00,#25,#00,#01,#00,#6B,#00,#00,#00,#DD,#00 
db #01,#00,#CF,#00,#03,#00,#36,#00,#0E,#00,#DF,#00,#F4,#00,#FE,#00 ; #7ad8
db #DA,#00,#E8,#01,#DB,#00,#60,#06,#ED,#00,#81,#19,#FE,#00,#07,#67  
db #B8,#01,#07,#B7,#E0,#06,#43,#5B,#81,#19,#E0,#EC,#07,#67,#F0,#F7  
db #07,#B7,#C0,#CE,#43,#5B,#01,#38,#E0,#EC,#07,#E0,#F0,#F7,#1F,#80  
db #C0,#CE,#73,#00,#01,#38,#C3,#08,#07,#E0,#03,#08,#1C,#80,#23,#28  
db #71,#01,#83,#88,#C2,#02,#23,#28,#D9,#19,#83,#88,#C2,#02,#23,#28  
db #D9,#19,#83,#88,#C2,#02,#03,#30,#D8,#18,#0F,#C0,#C0,#03,#3E,#00  
db #C0,#0C,#F9,#01,#C3,#10,#E6,#06,#CF,#00,#98,#1B,#FE,#00,#60,#6C  
db #F9,#01,#80,#B0,#E6,#06,#00,#C0,#98,#1B,#00,#00,#60,#6C,#00,#00  
db #80,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#0F,#00,#00,#00,#36,#30  
db #00,#00,#F8,#F9,#03,#03,#E0,#E7,#0D,#01,#80,#9E,#1E,#00,#00,#58  
db #38,#01,#03,#D0,#60,#07,#05,#80,#80,#1E,#02,#00,#00,#58,#00,#00  
db #02,#D0,#01,#00,#0F,#80,#06,#00,#36,#00,#DB,#00,#FD,#00,#BF,#00  
db #8F,#00,#F6,#00,#77,#00,#FD,#00,#FA,#00,#E0,#00,#FB,#00,#D8,#00 
db #67,#00,#D1,#00,#47,#00,#40,#00,#8D,#00,#E2,#00,#FF,#00,#FE,#00 
db #73,#00,#F8,#01,#ED,#00,#60,#06,#DE,#00,#81,#19,#D8,#00,#07,#67 
db #E0,#01,#07,#B7,#E0,#06,#43,#5B,#81,#19,#E0,#EC,#07,#67,#F0,#F7 ; #7Bd8
db #07,#B7,#C0,#CE,#43,#5B,#01,#38,#E0,#EC,#07,#E0,#F0,#F7,#1F,#80 
db #C0,#CE,#73,#00,#01,#38,#C3,#08,#07,#E0,#03,#08,#1C,#80,#23,#28 
db #71,#01,#83,#88,#C2,#02,#23,#28,#D9,#19,#83,#88,#C2,#02,#23,#28 
db #D9,#19,#83,#88,#C2,#02,#03,#30,#D8,#18,#0F,#C0,#C0,#03,#3E,#00 
db #C0,#0C,#F9,#01,#C3,#10,#E6,#06,#CF,#00,#98,#1B,#FE,#00,#60,#6C 
db #F9,#01,#80,#B0,#E6,#06,#00,#C0,#98,#1B,#00,#00,#60,#6C,#00,#00 
db #80,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#0F,#00,#00,#00,#36,#30 
db #00,#00,#F8,#F9,#03,#03,#E0,#E7,#0D,#01,#80,#9E,#1E,#00,#00,#58 
db #38,#01,#00,#D0,#60,#07,#08,#80,#80,#1E,#1C,#00,#00,#58,#0E,#60 
db #00,#D1,#06,#B0,#0E,#80,#06,#D0,#07,#20,#06,#50,#03,#58,#06,#50 
db #03,#48,#06,#50,#13,#50,#06,#50,#1B,#58,#06,#50,#1B,#58,#06,#50 
db #1B,#58,#06,#50,#1B,#58,#06,#50,#0B,#68,#06,#50,#03,#70,#06,#50 
db #03,#58,#06,#50,#03,#48,#02,#50,#13,#50,#06,#40,#1B,#58,#06,#00 
db #1A,#58,#16,#10,#1A,#58,#E6,#E0,#1A,#58,#16,#10,#0A,#E8,#E6,#E0 
db #02,#B0,#16,#10,#42,#58,#E2,#E0,#E2,#E8,#0E,#00,#F2,#F0,#06,#30 
db #C2,#C8,#06,#D0,#03,#38,#06,#50,#03,#E0,#06,#50,#1B,#80,#06,#50 ; #7Cd8
db #73,#00,#06,#50,#C3,#00,#06,#50,#DB,#18,#06,#50,#C3,#00,#06,#50 
db #DB,#18,#06,#50,#C3,#00,#06,#50,#DB,#18,#06,#50,#C3,#00,#04,#50 
db #C3,#08,#01,#51,#C3,#10,#06,#46,#CB,#00,#18,#1B,#F6,#00,#60,#6C 
db #F1,#01,#80,#B0,#E6,#06,#00,#C0,#98,#1B,#00,#00,#60,#6C,#00,#00 
db #80,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#03,#00,#00,#00,#0C,#00 
db #00,#00,#38,#01,#00,#00,#E0,#05,#03,#00,#80,#15,#0E,#00,#00,#59 
db #38,#01,#00,#DD,#60,#07,#00,#04,#80,#14,#00,#01,#00,#30,#00,#01 
db #07,#B0,#00,#01,#0B,#A0,#80,#01,#0C,#A0,#40,#01,#1E,#80,#C0,#01 
db #1F,#80,#D0,#00,#27,#00,#98,#01,#08,#88,#48,#41,#31,#81,#18,#01 
db #3C,#80,#70,#01,#0F,#80,#C0,#01,#20,#A0,#00,#01,#19,#99,#A0,#A0 
db #1E,#1E,#08,#01,#2D,#8D,#94,#81,#50,#00,#0C,#41,#28,#03,#3C,#81 
db #74,#00,#78,#01,#7F,#00,#B8,#81,#5F,#00,#98,#00,#5E,#00,#70,#05 
db #4D,#00,#A0,#85,#0F,#00,#98,#19,#64,#00,#2C,#2D,#43,#1B,#0C,#4D 
db #06,#B6,#48,#E9,#06,#96,#00,#40,#07,#07,#B0,#81,#32,#82,#78,#01 
db #38,#A0,#D8,#01,#3E,#80,#3C,#01,#3F,#90,#7C,#01,#1F,#80,#BC,#01 
db #0F,#84,#B8,#00,#0F,#00,#D0,#01,#07,#82,#C0,#01,#07,#80,#D0,#01 ; #7DD8
db #07,#82,#C0,#01,#07,#80,#D8,#01,#13,#90,#B8,#01,#2C,#A0,#00,#00 
db #13,#10,#40,#00,#07,#80,#E0,#00,#01,#80,#E0,#00,#00,#80,#00,#00 
db #00,#80,#00,#00,#00,#80,#00,#00,#00,#00,#E3,#E0,#00,#00,#30,#34 
db #08,#08,#30,#37,#11,#10,#B0,#37,#37,#30,#C0,#0B,#33,#30,#C0,#1D 
db #35,#34,#C0,#11,#1D,#1C,#80,#0C,#02,#00,#00,#33,#00,#3C,#00,#C7 
db #00,#B3,#10,#07,#00,#8C,#A0,#07,#00,#B0,#00,#07,#08,#80,#A0,#03 
db #05,#80,#50,#04,#08,#00,#A0,#07,#04,#80,#10,#07,#01,#81,#C0,#C7 
db #07,#87,#E0,#E7,#0F,#8F,#F0,#F3,#37,#B7,#F8,#F9,#3B,#BB,#FC,#FC 
db #3D,#3D,#FE,#FE,#3E,#BE,#F0,#F1,#3F,#BF,#4E,#4E,#3F,#BF,#B0,#B1 
db #3C,#BC,#40,#4D,#3B,#BB,#00,#32,#24,#A4,#00,#4C,#10,#13,#00,#33 
db #00,#8C,#00,#C3,#00,#B3,#10,#01,#00,#8C,#68,#61,#01,#B0,#18,#01 
db #05,#80,#F8,#01,#1A,#98,#F0,#00,#06,#00,#08,#09,#3E,#80,#F0,#F1 
db #3C,#80,#08,#01,#02,#82,#F8,#01,#3C,#BC,#F8,#01,#02,#80,#F8,#01 
db #3E,#80,#F0,#00,#3E,#00,#08,#09,#3E,#80,#F0,#F1,#3C,#80,#08,#01 
db #02,#82,#F8,#01,#3C,#BC,#F0,#05,#02,#80,#00,#03,#3E,#80,#00,#CC 
db #3C,#01,#00,#30,#00,#80,#00,#C0,#00,#B3,#00,#00,#00,#8C,#00,#00 ; #7ED8
db #00,#B0,#00,#00,#00,#C0,#00,#00,#00,#00,#00,#10,#01,#00,#80,#18 
db #01,#00,#80,#38,#01,#00,#80,#1C,#02,#12,#40,#5C,#07,#17,#C0,#CE 
db #07,#37,#A0,#AE,#0B,#2B,#E0,#E0,#09,#69,#B2,#B0,#09,#69,#D2,#D0 
db #11,#D1,#CA,#C8,#18,#58,#DA,#D8,#9C,#1C,#E8,#E8,#9E,#1E,#D4,#D4 
db #AE,#2E,#E4,#E4,#AF,#2F,#C4,#C4,#A7,#27,#EC,#EC,#23,#23,#F6,#F6 
db #A1,#21,#EA,#EA,#B1,#31,#F6,#F6,#7C,#7C,#EA,#EA,#7F,#7F,#F6,#F6 
db #7F,#7F,#EA,#EA,#5F,#5F,#F2,#F2,#47,#47,#E2,#E2,#43,#43,#F6,#F6 
db #40,#40,#EA,#EA,#40,#40,#76,#76,#47,#47,#EA,#EA,#5F,#5F,#F6,#F6 
db #7F,#7F,#E2,#E2,#7C,#7C,#72,#72,#50,#50,#EA,#EA,#41,#41,#F6,#F6 
db #41,#41,#EA,#EA,#47,#47,#F6,#F6,#47,#47,#EA,#EA,#5F,#5F,#F4,#F4 
db #5F,#5F,#EC,#EC,#7E,#7E,#E4,#E4,#7C,#7C,#E4,#E4,#B8,#38,#D8,#D8 
db #B1,#31,#EA,#E8,#A1,#21,#DA,#D8,#B3,#33,#EA,#E8,#93,#13,#D2,#D0 
db #93,#13,#F2,#F0,#9B,#1B,#D2,#D0,#AF,#0F,#A4,#A0,#AF,#0F,#E6,#E0 
db #A7,#07,#C8,#C0,#AA,#02,#40,#40,#54,#01,#00,#80,#D4,#01,#00,#80 
db #78,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#00,#00,#00,#38 
db #00,#00,#00,#38,#00,#00,#00,#3C,#00,#10,#00,#5C,#00,#18,#00,#7E ; #7FD8
db #00,#38,#00,#BE,#00,#3C,#00,#78,#00,#5C,#82,#00,#00,#7E,#AA,#00 
db #00,#BE,#AA,#00,#00,#78,#DA,#00,#82,#00,#AE,#00,#AA,#00,#78,#00 
db #AA,#00,#86,#00,#DA,#00,#FA,#00,#AE,#00,#AA,#00,#78,#00,#D6,#00 
db #86,#00,#56,#00,#FC,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00 
db #B6,#00,#D6,#00,#AA,#00,#D4,#00,#AA,#00,#AA,#00,#56,#00,#AA,#00 
db #DA,#00,#EA,#00,#AA,#00,#5A,#00,#B4,#00,#AA,#00,#B6,#00,#AA,#00 
db #AA,#00,#AA,#00,#AA,#00,#DC,#00,#AA,#00,#AA,#00,#B4,#00,#AA,#00 
db #56,#00,#AE,#00,#6A,#00,#78,#00,#AA,#00,#86,#00,#AA,#00,#FA,#00 
db #AE,#00,#AA,#00,#78,#00,#AA,#00,#86,#00,#AA,#00,#FA,#00,#B4,#00 
db #AA,#00,#B6,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00,#B4,#00,#AA,#00 
db #B6,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00,#54,#00,#AA,#00,#D6,#00 
db #AA,#00,#78,#00,#AA,#00,#00,#00,#54,#00,#00,#00,#D6,#00,#00,#00 
db #78,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#00,#00,#00,#18 
db #00,#00,#00,#38,#00,#00,#00,#3C,#00,#10,#00,#5C,#00,#18,#00,#7E 
db #00,#38,#00,#BE,#00,#3C,#00,#78,#00,#5C,#82,#00,#00,#7E,#AA,#00 
db #00,#BE,#AA,#00,#00,#78,#DA,#00,#82,#00,#AE,#00,#AA,#00,#F8,#00 ; #80d8
db #AA,#00,#80,#04,#DA,#00,#00,#7C,#AE,#00,#00,#78,#78,#00,#00,#38 
db #00,#84,#00,#30,#00,#7C,#00,#10,#00,#78,#00,#00,#00,#38,#00,#00 
db #00,#30,#00,#00,#00,#10,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#10,#00,#00,#00,#18 
db #00,#00,#00,#38,#00,#00,#00,#3C,#00,#10,#00,#5C,#00,#18,#00,#7E 
db #00,#38,#00,#BE,#00,#3C,#00,#78,#00,#5C,#86,#00,#00,#7E,#FA,#00 
db #00,#BE,#AA,#00,#00,#78,#AA,#00,#86,#00,#AA,#00,#FA,#00,#B4,#00 
db #AA,#00,#B6,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00,#B4,#00,#AA,#00 
db #B6,#00,#AA,#00,#AA,#00,#AA,#00,#AA,#00,#54,#00,#AA,#00,#D6,#00 
db #AA,#00,#78,#00,#AA,#00,#00,#00,#54,#00,#00,#00,#D6,#00,#00,#00 
db #78,#00,#00,#00,#00,#00,#00,#00,#01,#01,#83,#83,#01,#01,#0F,#4F 
db #00,#03,#3C,#BC,#00,#01,#30,#B3,#02,#02,#40,#4C,#0F,#0F,#00,#31 
db #3C,#3C,#08,#C1,#F0,#F3,#10,#01,#C0,#CC,#28,#81,#00,#31,#10,#81 
db #08,#C1,#28,#81,#10,#01,#10,#81,#28,#81,#28,#81,#10,#81,#10,#81 
db #28,#81,#28,#81,#10,#81,#10,#81,#28,#81,#28,#81,#10,#81,#10,#81 
db #28,#81,#28,#81,#10,#81,#10,#81,#28,#81,#20,#81,#10,#81,#0C,#81 ; #81d8
db #28,#81,#3C,#81,#10,#81,#0E,#80,#20,#81,#33,#B0,#0C,#81,#0C,#8C 
db #34,#81,#33,#83,#3E,#80,#7D,#01,#3F,#80,#FD,#01,#3F,#80,#F1,#01 
db #3F,#80,#CD,#01,#7F,#00,#3D,#01,#EC,#00,#FD,#01,#F3,#00,#FD,#01 
db #4F,#00,#FD,#01,#3F,#00,#FD,#01,#7F,#00,#F3,#03,#7F,#00,#CC,#0C 
db #7F,#00,#33,#30,#3C,#00,#CF,#C0,#73,#03,#3F,#00,#4D,#0D,#7F,#00 
db #31,#31,#7F,#00,#CD,#C1,#6E,#00,#3D,#01,#79,#01,#FD,#01,#67,#07 
db #FD,#01,#10,#10,#FC,#00,#70,#73,#F9,#01,#00,#09,#E7,#07,#00,#3A 
db #90,#10,#00,#90,#70,#73,#00,#A0,#00,#09,#00,#00,#00,#3A,#00,#00 
db #00,#90,#00,#00,#00,#A0,#00,#00,#00,#00,#CC,#00,#03,#F3,#00,#0C 
db #CD,#00,#3F,#3D,#00,#4C,#DE,#00,#F3,#D9,#01,#ED,#E6,#0D,#DD,#9C 
db #3A,#BE,#6F,#4B,#79,#8E,#31,#66,#B8,#1C,#18,#E4,#7F,#7B,#9E,#3C 
db #1E,#3F,#0E,#39,#73,#03,#63,#7B,#38,#14,#36,#1E,#F3,#8E,#2E,#E7 
db #DC,#72,#EC,#D8,#2C,#ED,#B0,#0A,#CE,#60,#62,#D7,#E0,#78,#DB,#C0 
db #3E,#B3,#C0,#3F,#2F,#80,#4F,#1F,#80,#73,#5F,#80,#2C,#53,#00,#0B 
db #6B,#00,#62,#7B,#00,#79,#7B,#00,#3E,#7B,#00,#3F,#6B,#00,#4F,#53 
db #00,#73,#5F,#00,#2C,#5F,#00,#0B,#67,#00,#62,#5F,#00,#79,#5F,#00 ; #82d8
db #3E,#53,#00,#3F,#6B,#00,#4F,#7B,#00,#73,#7B,#00,#2C,#7B,#00,#0B 
db #6B,#00,#62,#53,#00,#79,#5F,#00,#3E,#5F,#00,#3F,#67,#00,#4F,#7B 
db #00,#63,#7B,#00,#38,#74,#00,#0E,#70,#00,#03,#40,#00,#00,#00,#00 
db #FF,#FC,#C0,#FF,#F3,#F3,#FF,#C0,#C1,#FF,#80,#01,#FF,#40,#C0,#FC 
db #F3,#C1,#F1,#E1,#E6,#CD,#C1,#9C,#B8,#80,#6F,#48,#01,#8E,#B0,#06 
db #B8,#9C,#18,#E4,#7F,#7B,#9E,#BC,#1E,#3F,#CE,#38,#73,#C3,#60,#7B 
db #B8,#10,#36,#DE,#F3,#8E,#8E,#E7,#DD,#02,#EC,#DB,#00,#ED,#B7,#80 
db #CE,#6F,#60,#C7,#EF,#78,#C3,#DF,#BE,#83,#DF,#BF,#0F,#BF,#0F,#1F 
db #BF,#03,#1F,#BF,#00,#13,#7F,#80,#03,#7F,#60,#03,#7F,#78,#03,#7F 
db #BE,#03,#7F,#BF,#03,#7F,#0F,#13,#7F,#03,#1F,#7F,#00,#1F,#7F,#80 
db #07,#7F,#60,#1F,#7F,#78,#1F,#7F,#BE,#13,#7F,#BF,#03,#7F,#0F,#03 
db #7F,#03,#03,#7F,#00,#03,#7F,#80,#03,#7F,#60,#13,#7F,#78,#1F,#7F 
db #BE,#1F,#7F,#BF,#07,#7F,#0F,#03,#7F,#03,#03,#7F,#80,#04,#FF,#C0 
db #03,#FF,#F0,#0F,#FF,#FC,#BF,#FF,#00,#00,#00,#00,#03,#C0,#00,#0C 
db #D0,#00,#3F,#38,#00,#CC,#DC,#03,#F3,#D8,#0C,#CD,#E4,#33,#3D,#98 
db #7C,#DE,#70,#F3,#59,#BC,#CF,#66,#38,#1F,#9A,#E4,#1E,#63,#9C,#19 ; #83d8
db #EE,#7C,#06,#39,#3C,#1C,#63,#DC,#7F,#9D,#CC,#FE,#7E,#F4,#00,#E6 
db #10,#00,#DE,#EC,#00,#DD,#F4,#00,#61,#B6,#00,#7D,#B6,#00,#1E,#76 
db #00,#27,#EE,#00,#09,#E6,#00,#62,#FA,#00,#78,#FA,#00,#3E,#6A,#00 
db #3F,#66,#00,#4F,#6E,#00,#73,#66,#00,#2C,#6A,#00,#0B,#6C,#00,#62 
db #7C,#00,#79,#7A,#00,#3E,#7C,#00,#3F,#6C,#00,#4F,#6A,#00,#73,#66 
db #00,#2C,#6E,#00,#0B,#66,#00,#62,#6A,#00,#79,#7A,#00,#3E,#7A,#00 
db #3F,#66,#00,#4F,#6E,#00,#63,#6E,#00,#38,#6C,#00,#0E,#70,#00,#03 
db #40,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #FF,#FC,#3F,#FF,#F0,#0F,#FF,#CC,#17,#FF,#3F,#3B,#FC,#0C,#1D,#F0 
db #00,#19,#CC,#0C,#05,#03,#3C,#1B,#70,#1E,#71,#F3,#19,#BD,#C1,#06 
db #39,#01,#1A,#E5,#00,#63,#9D,#01,#EE,#7D,#06,#38,#3D,#1C,#60,#1D 
db #7F,#9C,#0D,#FE,#7E,#05,#00,#E6,#01,#FE,#DE,#E1,#FE,#DD,#F1,#FF 
db #61,#B0,#FF,#7D,#B0,#FF,#1E,#70,#FF,#87,#E0,#FF,#81,#E0,#FF,#60 
db #F8,#FF,#78,#F8,#FF,#BE,#68,#FF,#BF,#60,#FF,#0F,#60,#FF,#03,#60 
db #FF,#80,#68,#FF,#80,#6C,#FF,#60,#7C,#FF,#78,#78,#FF,#BE,#7C,#FF 
db #BF,#6C,#FF,#0F,#68,#FF,#03,#60,#FF,#80,#60,#FF,#80,#60,#FF,#60 ; #84d8
db #68,#FF,#78,#78,#FF,#BE,#78,#FF,#BF,#60,#FF,#0F,#60,#FF,#03,#60 
db #FF,#80,#61,#FF,#C0,#73,#FF,#F0,#4F,#FF,#FC,#BF,#FF,#FF,#FF,#FF 
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#0E,#00,#00,#38,#00,#00 
db #E2,#00,#03,#9B,#00,#0E,#3B,#00,#39,#BB,#00,#F3,#BB,#03,#6B,#B8 
db #0C,#5B,#B3,#11,#5B,#8C,#27,#5B,#33,#2F,#58,#CA,#73,#53,#38,#4C 
db #4C,#D0,#43,#73,#E0,#44,#CC,#C0,#46,#BF,#00,#4A,#8F,#00,#4C,#B2 
db #00,#4E,#BC,#00,#52,#8D,#00,#4C,#B0,#C0,#52,#87,#20,#4C,#B8,#E0 
db #52,#87,#C0,#5C,#BF,#80,#5E,#BF,#00,#5E,#BE,#00,#5E,#BC,#00,#5E 
db #B8,#00,#5E,#B3,#00,#5E,#A8,#C0,#5E,#87,#20,#4E,#B8,#E0,#50,#87 
db #C0,#5C,#BF,#80,#5E,#BF,#00,#5E,#BE,#00,#5E,#BC,#00,#5E,#B8,#00 
db #5E,#B3,#00,#5E,#A8,#C0,#5E,#87,#20,#4E,#B8,#E0,#50,#87,#C0,#5C 
db #BF,#80,#5E,#BF,#00,#5E,#BE,#00,#5E,#BC,#00,#5E,#B8,#00,#5E,#B4 
db #00,#4E,#A6,#00,#32,#8C,#00,#0C,#B0,#00,#03,#C0,#00,#00,#00,#00 
db #FF,#FF,#CE,#FF,#FF,#38,#FF,#FC,#E0,#FF,#F3,#98,#FF,#CE,#38,#FF 
db #38,#38,#FC,#F0,#38,#F3,#68,#38,#EC,#58,#33,#D0,#58,#0C,#A0,#58 
db #30,#A0,#58,#C0,#70,#53,#01,#4C,#4C,#07,#53,#70,#0F,#50,#C0,#1F ; #85d8
db #50,#80,#3F,#40,#80,#7F,#40,#80,#FF,#40,#80,#FF,#40,#81,#3F,#40 
db #80,#DF,#50,#87,#2F,#4C,#B8,#EF,#52,#87,#DF,#5C,#BF,#BF,#5E,#BF 
db #7F,#5E,#BE,#FF,#5E,#BD,#FF,#5E,#B8,#FF,#5E,#B3,#3F,#5E,#A0,#DF 
db #5E,#87,#2F,#4E,#B8,#EF,#50,#87,#DF,#5C,#BF,#BF,#5E,#BF,#7F,#5E 
db #BE,#FF,#5E,#BD,#FF,#5E,#B8,#FF,#5E,#B3,#3F,#5E,#A0,#DF,#5E,#87 
db #2F,#4E,#B8,#EF,#50,#87,#DF,#5C,#BF,#BF,#5E,#BF,#7F,#5E,#BE,#FF 
db #5E,#BD,#FF,#5E,#BB,#FF,#5E,#B5,#FF,#4E,#A6,#FF,#B2,#8D,#FF,#CC 
db #B3,#FF,#F3,#CF,#FF,#FC,#3F,#FF,#00,#00,#00,#00,#00,#00,#00,#00 
db #00,#00,#03,#C0,#00,#0E,#30,#00,#38,#C8,#00,#E6,#74,#03,#8F,#3A 
db #0E,#67,#92,#38,#F3,#CE,#66,#79,#32,#1F,#3C,#C2,#0F,#93,#02,#07 
db #CC,#62,#13,#33,#72,#18,#C6,#EA,#67,#2E,#DA,#FC,#6D,#DA,#00,#5D 
db #B2,#00,#03,#4A,#00,#28,#32,#00,#5C,#CA,#00,#B3,#3A,#00,#CC,#FA 
db #00,#33,#FA,#00,#0F,#FA,#00,#03,#FA,#00,#04,#FA,#00,#08,#32,#00 
db #14,#8A,#00,#2D,#32,#00,#5C,#CA,#00,#B3,#3A,#00,#CC,#FA,#00,#33 
db #FA,#00,#0F,#FA,#00,#03,#FA,#00,#04,#FA,#00,#08,#32,#00,#14,#8A 
db #00,#2D,#32,#00,#5C,#CA,#00,#B3,#3A,#00,#CC,#FA,#00,#33,#FA,#00 ; #86d8
db #0F,#FA,#00,#03,#FA,#00,#08,#F2,#00,#18,#0C,#00,#06,#B0,#00,#01 
db #C0,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FC,#3F,#FF,#F3,#CF,#FF,#CE,#37,#FF 
db #38,#CB,#FC,#E0,#75,#F3,#80,#3A,#CE,#60,#12,#38,#F0,#0E,#60,#78 
db #32,#00,#3C,#CA,#00,#13,#1A,#00,#0C,#0A,#10,#30,#02,#18,#C0,#02 
db #67,#00,#02,#FC,#00,#02,#00,#00,#02,#FF,#80,#0A,#FF,#A8,#32,#FF 
db #5C,#CA,#FE,#B3,#3A,#FE,#CC,#FA,#FF,#33,#FA,#FF,#CF,#FA,#FF,#F3 
db #FA,#FF,#F4,#FA,#FF,#E8,#32,#FF,#D4,#0A,#FF,#AC,#32,#FF,#5C,#CA 
db #FE,#B3,#3A,#FE,#CC,#FA,#FF,#33,#FA,#FF,#CF,#FA,#FF,#F3,#FA,#FF 
db #F4,#FA,#FF,#E8,#32,#FF,#D4,#0A,#FF,#AC,#32,#FF,#5C,#CA,#FE,#B3 
db #3A,#FE,#CC,#FA,#FF,#33,#FA,#FF,#CF,#FA,#FF,#F3,#FA,#FF,#E8,#F2 
db #FF,#D8,#0D,#FF,#E6,#B3,#FF,#F9,#CF,#FF,#FE,#3F,#FF,#FF,#FF,#FF 
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#FC,#00,#01,#FA,#00,#0B 
db #F6,#00,#1B,#E3,#00,#2B,#EC,#00,#ED,#E8,#03,#96,#E6,#0E,#7B,#75 
db #19,#E5,#B9,#27,#9E,#1E,#1E,#79,#E1,#39,#E7,#1F,#67,#DE,#FE,#1F 
db #BD,#C5,#3C,#3B,#BB,#03,#7B,#7D,#3E,#7B,#7D,#6D,#7B,#BE,#56,#BD ; #87d8
db #DE,#6F,#B6,#2E,#3C,#1F,#F6,#03,#CF,#F2,#3E,#E3,#C0,#6D,#78,#00 
db #56,#E5,#00,#6F,#9A,#00,#3C,#6D,#00,#03,#D6,#00,#3E,#80,#00,#6D 
db #7A,#00,#56,#FD,#00,#6F,#7E,#00,#3C,#FF,#F8,#03,#7D,#F0,#3E,#9F 
db #F8,#6D,#63,#E8,#56,#E5,#F0,#6F,#9A,#B0,#3C,#6D,#20,#03,#D6,#00 
db #3E,#EC,#00,#6D,#7A,#00,#56,#E5,#00,#6F,#9A,#00,#38,#6D,#00,#07 
db #D6,#00,#3E,#EC,#00,#6D,#7A,#00,#56,#E5,#00,#6F,#9A,#00,#38,#6D 
db #00,#06,#D6,#00,#3D,#6C,#00,#0E,#F0,#00,#01,#80,#00,#00,#00,#00 
db #FF,#FE,#FC,#FF,#F1,#F8,#FF,#E3,#F0,#FF,#C3,#E3,#FF,#03,#E0,#FC 
db #01,#E0,#F0,#10,#E0,#E0,#78,#70,#C1,#E0,#38,#87,#80,#1E,#DE,#01 
db #E0,#B8,#07,#00,#60,#1E,#00,#80,#3C,#01,#80,#38,#3B,#C0,#78,#7D 
db #80,#78,#7D,#01,#78,#3E,#10,#3C,#1E,#00,#36,#2E,#80,#1F,#F6,#C0 
db #0F,#F2,#80,#03,#CD,#01,#00,#3F,#10,#00,#7F,#00,#02,#7F,#80,#00 
db #7F,#C0,#10,#FF,#80,#01,#FF,#01,#78,#FF,#10,#FC,#7F,#00,#7E,#07 
db #80,#FF,#FB,#C0,#7D,#F7,#80,#1F,#FB,#01,#03,#EB,#10,#01,#F7,#00 
db #02,#B7,#80,#00,#2F,#C0,#10,#DF,#80,#01,#FF,#01,#00,#FF,#10,#00 
db #7F,#00,#02,#7F,#80,#00,#7F,#C0,#10,#FF,#80,#01,#FF,#01,#00,#FF ; #88d8
db #10,#00,#7F,#00,#02,#7F,#80,#00,#7F,#C0,#10,#FF,#81,#01,#FF,#C0 
db #03,#FF,#F0,#0F,#FF,#FE,#7F,#FF,#00,#00,#00,#00,#01,#CE,#00,#0F 
db #3C,#00,#3C,#F0,#00,#CB,#CE,#07,#37,#3C,#1F,#D8,#F8,#7F,#ED,#E4 
db #3C,#35,#86,#00,#DA,#7A,#00,#AA,#FC,#00,#6D,#1C,#00,#14,#EE,#00 
db #35,#F6,#00,#53,#36,#00,#6E,#D6,#00,#9D,#EE,#00,#73,#EC,#00,#ED 
db #F4,#00,#DE,#F0,#00,#3E,#74,#00,#DF,#32,#00,#CF,#54,#00,#E3,#4A 
db #00,#ED,#2C,#00,#6C,#D0,#00,#AA,#EC,#00,#8D,#DA,#00,#DF,#1E,#00 
db #70,#DE,#00,#0F,#BE,#00,#7C,#7E,#00,#D9,#EC,#00,#A7,#FC,#00,#D5 
db #F8,#00,#73,#FA,#00,#06,#78,#00,#79,#90,#00,#DA,#64,#00,#AD,#8A 
db #00,#DF,#34,#00,#70,#DA,#00,#0F,#AC,#00,#7D,#D8,#00,#DA,#F4,#00 
db #AD,#CA,#00,#DF,#34,#00,#70,#DA,#00,#0D,#AC,#00,#7A,#D8,#00,#1D 
db #E0,#00,#03,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #FF,#FE,#31,#FF,#F0,#0E,#FF,#C0,#3C,#FF,#00,#F1,#F8,#03,#C0,#E7 
db #07,#01,#9F,#C0,#03,#7F,#E0,#01,#3C,#30,#00,#00,#18,#78,#00,#08 
db #FD,#00,#0C,#1D,#00,#04,#0E,#00,#04,#06,#00,#00,#06,#00,#00,#C6 
db #00,#01,#EE,#00,#03,#ED,#00,#0D,#F5,#00,#1E,#F3,#00,#3E,#71,#00 ; #89d8
db #DF,#30,#FE,#CF,#14,#FE,#E3,#00,#FE,#E1,#21,#FF,#60,#01,#FE,#22 
db #0D,#FE,#00,#1A,#FE,#00,#1E,#FF,#00,#1E,#FF,#80,#3E,#FF,#00,#7E 
db #FE,#01,#ED,#FE,#27,#FC,#FE,#05,#F8,#FF,#03,#F8,#FF,#86,#79,#FF 
db #01,#93,#FE,#02,#61,#FE,#20,#00,#FE,#00,#04,#FF,#00,#00,#FF,#80 
db #21,#FF,#00,#03,#FE,#02,#01,#FE,#20,#00,#FE,#00,#04,#FF,#00,#00 
db #FF,#80,#21,#FF,#02,#03,#FF,#80,#07,#FF,#E0,#1F,#FF,#FC,#FF,#FF 
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#18,#00,#01,#E7 
db #00,#07,#F9,#C0,#01,#FE,#E0,#1C,#7F,#70,#3F,#3F,#B0,#3F,#9F,#CC 
db #5F,#CF,#3E,#4F,#EC,#FA,#33,#E3,#E2,#4D,#CF,#86,#72,#3E,#02,#7C 
db #F8,#06,#5D,#C4,#02,#46,#E8,#06,#76,#C8,#46,#3D,#E0,#EE,#1E,#C8 
db #FC,#06,#E1,#70,#09,#E3,#F4,#06,#FF,#0C,#0B,#3C,#38,#0D,#C0,#F0 
db #2E,#F7,#C4,#47,#7F,#12,#33,#9C,#4C,#0C,#C1,#30,#03,#18,#C0,#00 
db #C3,#00,#00,#3C,#00,#00,#00,#00,#FF,#E7,#FF,#FE,#00,#FF,#F8,#00 
db #3F,#F0,#00,#1F,#E0,#00,#0F,#C0,#00,#07,#80,#00,#03,#80,#00,#0D 
db #40,#00,#3E,#40,#00,#FA,#30,#03,#E2,#0C,#0F,#86,#02,#3E,#02,#00 
db #F8,#06,#01,#C0,#02,#00,#E0,#06,#00,#C0,#46,#81,#E0,#EE,#C0,#C0 ; #8ad8
db #FD,#E0,#E1,#73,#E1,#E3,#F1,#F0,#FF,#01,#E0,#3C,#03,#C0,#00,#03 
db #A0,#00,#05,#40,#00,#02,#B0,#00,#0D,#CC,#00,#33,#F3,#00,#CF,#FC 
db #C3,#3F,#FF,#3C,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#1C,#00,#00,#E3 
db #80,#03,#FC,#E0,#04,#7F,#70,#0F,#1F,#B8,#0F,#CF,#DC,#1F,#E7,#EC 
db #5F,#F3,#EA,#6F,#FB,#F2,#57,#F9,#E4,#69,#FD,#9A,#56,#38,#66,#59 
db #C3,#9E,#5E,#3C,#7E,#5B,#C3,#E6,#58,#FF,#DE,#2E,#FF,#FC,#07,#FF 
db #F8,#29,#FF,#E4,#30,#3F,#18,#3F,#C0,#F0,#0F,#1F,#E0,#00,#7F,#90 
db #27,#F8,#74,#47,#FB,#E2,#33,#FF,#CC,#0C,#FF,#30,#03,#18,#C0,#00 
db #C3,#00,#00,#3C,#00,#00,#00,#00,#FF,#E3,#FF,#FF,#00,#7F,#FC,#00 
db #1F,#F8,#00,#0F,#F0,#00,#07,#E0,#00,#03,#C0,#00,#01,#80,#00,#01 
db #40,#00,#02,#60,#00,#02,#50,#00,#04,#68,#00,#18,#46,#00,#60,#41 
db #C3,#80,#40,#3C,#00,#40,#00,#00,#40,#00,#00,#A0,#00,#01,#C0,#00 
db #03,#80,#00,#01,#80,#00,#03,#80,#00,#07,#C0,#00,#0F,#C0,#00,#03 
db #A0,#00,#05,#40,#00,#02,#B0,#00,#0D,#CC,#00,#33,#F3,#00,#CF,#FC 
db #C3,#3F,#FF,#3C,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#3E,#00,#01,#F9 
db #C0,#07,#C6,#F0,#0F,#BE,#F8,#0F,#C1,#8C,#1F,#FD,#AC,#1B,#CF,#76 ; #8bd8
db #07,#97,#46,#3F,#BA,#0A,#3F,#A1,#BC,#7F,#83,#DC,#77,#9B,#D4,#0F 
db #7A,#BC,#09,#FC,#68,#02,#EF,#70,#0F,#FB,#0E,#1F,#6E,#FA,#1F,#B9 
db #6C,#07,#C7,#B0,#01,#FD,#D0,#00,#76,#C0,#00,#18,#00,#00,#00,#00 
db #FF,#C1,#FF,#FE,#3E,#3F,#F9,#F9,#CF,#F7,#C0,#F7,#EF,#80,#FB,#EF 
db #C1,#8D,#DF,#FD,#8D,#DB,#CF,#36,#C7,#87,#06,#BF,#9A,#0A,#BF,#80 
db #3D,#7F,#80,#1D,#77,#98,#15,#8F,#78,#3D,#E9,#FC,#6B,#F2,#EF,#71 
db #EF,#FB,#0E,#DF,#6E,#FA,#DF,#B9,#6D,#E7,#C7,#B3,#F9,#FD,#D7,#FE 
db #76,#CF,#FF,#99,#3F,#FF,#E7,#FF,#00,#00,#00,#00,#3E,#00,#01,#F9 
db #C0,#07,#C6,#F0,#0F,#BE,#F8,#0F,#C1,#8C,#1F,#FD,#AC,#0B,#CF,#76 
db #37,#97,#46,#7F,#BA,#0A,#7F,#A1,#BC,#37,#83,#DC,#0F,#9B,#D4,#0F 
db #7A,#BC,#09,#FC,#68,#02,#EF,#74,#07,#FB,#08,#0F,#6E,#60,#0F,#B9 
db #80,#03,#C7,#C0,#00,#FE,#E0,#00,#3B,#60,#00,#0C,#00,#00,#00,#00 
db #FF,#C1,#FF,#FE,#3E,#3F,#F9,#F9,#CF,#F7,#C0,#F7,#EF,#80,#FB,#EF 
db #C1,#8D,#DF,#FD,#8D,#CB,#CF,#36,#B7,#87,#06,#7F,#9A,#0A,#7F,#80 
db #3D,#B7,#80,#1D,#CF,#98,#15,#EF,#78,#3D,#E9,#FC,#6B,#F2,#EF,#75 
db #F7,#FB,#0B,#EF,#6E,#67,#EF,#B9,#9F,#F3,#C7,#DF,#FC,#FE,#EF,#FF ; #8cd8
db #3B,#6F,#FF,#CC,#9F,#FF,#F3,#FF,#00,#00,#00,#00,#3E,#00,#01,#F9 
db #C0,#07,#C6,#F0,#0F,#BE,#F8,#0F,#C1,#8C,#1F,#FD,#AC,#1B,#CF,#76 
db #67,#97,#46,#7F,#BA,#0A,#7F,#A1,#BC,#2F,#83,#DC,#07,#9B,#D4,#0F 
db #7A,#BC,#09,#FC,#68,#16,#EF,#70,#3F,#FB,#0E,#1F,#6E,#FA,#0F,#B8 
db #EC,#03,#C7,#70,#00,#DB,#30,#00
lab8d30:
db #60,#00,#00,#00,#00,#00,#00,#00 
db #FF,#C1,#FF,#FE,#3E,#3F,#F9,#F9,#CF,#F7,#C0,#F7,#EF,#80,#FB,#EF ; #8d38
db #C1,#8D,#DF,#FD,#8D,#9B,#CF,#36,#67,#87,#06,#7F,#9A,#0A,#7F,#80 
db #3D,#AF,#80,#1D,#D7,#98,#15,#EF,#78,#3D,#E9,#FC,#6B,#D6,#EF,#71 
db #BF,#FB,#0E,#DF,#6E,#FA,#EF,#B8,#ED,#F3,#C7,#73,#FC,#DB,#37,#FF 
db #64,#CF,#FF,#9F,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#34,#00,#01,#E7 
db #00,#06,#1F,#C0,#0F,#FB,#E8,#0F,#FF,#F4,#1F,#FE,#F4,#1F,#FD,#38 
db #3F,#FC,#D8,#2E,#FE,#E8,#1F,#1E,#E8,#3F,#EF,#60,#2F,#77,#60,#3F 
db #B7,#B0,#16,#4F,#C0,#0F,#BF,#20,#17,#F0,#F0,#39,#F7,#70,#1E,#7B 
db #F8,#07,#BD,#F8,#03,#FC,#70,#00,#FC,#00,#00,#38,#00,#00,#00,#00 
db #FF,#CB,#FF,#FE,#04,#FF,#F8,#07,#3F,#F6,#1F,#D7,#EF,#FB,#EB,#EF 
db #FF,#F5,#DF,#FE,#F5,#DF,#FC,#3B,#BF,#FC,#1B,#AE,#FE,#0B,#DF,#1E ; #8dd8
db #0B,#BF,#EF,#07,#AF,#77,#07,#BF,#B7,#87,#D6,#4F,#CF,#EF,#BF,#2F 
db #D7,#F0,#F7,#B9,#F7,#77,#DE,#7B,#FB,#E7,#BD,#FB,#FB,#FC,#77,#FC 
db #FD,#8F,#FF,#3B,#FF,#FF,#C7,#FF,#00,#00,#00,#00,#34,#00,#01,#E7 
db #00,#06,#1F,#CC,#0F,#FB,#EC,#0F,#FF,#F0,#1F,#FE,#F0,#1F,#FD,#38
db #3F,#FC,#D8,#2E,#CE,#E8,#1F,#36,#E8,#3F,#F7,#70,#2F,#6F,#98,#3F
db #9F,#E0,#16,#5F,#C0,#2F,#BF,#20,#57,#E0,#E0,#79,#F6,#F0,#3E,#7B
db #70,#0F,#FB,#F8,#03,#F8,#F8,#00,#70,#30,#00,#00,#00,#00,#00,#00
db #FF,#CB,#FF,#FE,#04,#FF,#F8,#07,#33,#F6,#1F,#CD,#EF,#FB,#ED,#EF
db #FF,#F3,#DF,#FE,#F7,#DF,#FC,#3B,#BF,#FC,#1B,#AE,#CE,#0B,#DF,#36
db #0B,#BF,#F7,#07,#AF,#6F,#83,#BF,#9F,#E7,#D6,#5F,#DF,#AF,#BF,#2F
db #57,#E0,#EF,#79,#F6,#F7,#BE,#7B,#77,#CF,#FB,#FB,#F3,#F8,#FB,#FC
db #77,#37,#FF,#8F,#CF,#FF,#FF,#FF,#00,#00,#00,#00,#34,#00,#01,#E7
db #00,#06,#1F,#D0,#0F,#FB,#E0,#0F,#FF,#F0,#1F,#FE,#F0,#1F,#FD,#38
db #3F,#FC,#D8,#2E,#7D,#D8,#1F,#BD,#D8,#3F,#DD,#D0,#2E,#5D,#B0,#3F
db #BB,#60,#16,#BA,#C0,#0F,#7D,#00,#03,#F0,#C0,#04,#FB,#C0,#0B,#3D
db #80,#0F,#EE,#00,#03,#FF,#00,#00,#7F,#00,#00,#0E,#00,#00,#00,#00 ; #8ed8
db #FF,#CB,#FF,#FE,#04,#FF,#F8,#07,#2F,#F6,#1F,#D7,#EF,#FB,#EF,#EF
db #FF,#F7,#DF,#FE,#F7,#DF,#FC,#3B,#BF,#FC,#1B,#AE,#7C,#1B,#DF,#BC
db #1B,#BF,#DC,#17,#AE,#5C,#37,#BF,#B8,#6F,#D6,#B8,#DF,#EF,#7D,#3F
db #F3,#F0,#DF,#F4,#FB,#DF,#EB,#3D,#BF,#EF,#EE,#7F,#F3,#FF,#7F,#FC
db #7F,#7F,#FF,#8E,#FF,#FF,#F1,#FF,#00,#00,#00,#00,#7C,#00,#01,#FF
db #00,#03,#FF,#80,#07,#FE,#40,#07,#F3,#C0,#0F,#EF,#E0,#0F,#FF,#78
db #0F,#FB,#44,#0F,#FB,#82,#17,#FF,#82,#1B,#FF,#02,#37,#FE,#82,#77
db #7E,#04,#2F,#76,#04,#2E,#E7,#1C,#2F,#38,#FC,#77,#CF,#98,#1B,#B6
db #00,#0C,#F8,#00,#08,#58,#00,#00,#30,#00,#00,#00,#00,#00,#00,#00
db #FF,#83,#FF,#FE,#7C,#FF,#FD,#FF,#7F,#FB,#FF,#BF,#F7,#FE,#5F,#F7
db #F3,#DF,#EF,#EF,#EF,#EF,#FF,#7F,#EF,#FB,#47,#EF,#FB,#83,#C7,#FF
db #83,#C3,#FF,#03,#87,#FE,#83,#07,#7E,#07,#8F,#76,#07,#8E,#E7,#19
db #8F,#38,#E1,#07,#CF,#83,#83,#86,#67,#E0,#81,#FF,#E3,#03,#FF,#F7
db #87,#FF,#FF,#CF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#7C,#00,#01,#FF
db #00,#03,#FF,#80,#07,#FC,#80,#07,#E7,#C0,#0F,#DF,#C0,#0F,#FE,#F0
db #0F,#F6,#88,#0F,#F7,#04,#17,#FF,#04,#77,#FE,#04,#2F,#FD,#04,#2E ; #8fd8
db #FC,#08,#2E,#EC,#0C,#5D,#CF,#3E,#1E,#F0,#DE,#0F,#3F,#8C,#16,#DE
db #00,#1B,#E0,#00,#05,#60,#00,#00,#C0,#00,#00,#00,#00,#00,#00,#00
db #FF,#83,#FF,#FE,#7C,#FF,#FD,#FF,#7F,#FB,#FF,#BF,#F7,#FC,#BF,#F7
db #E7,#DF,#EF,#DF,#DF,#EF,#FE,#FF,#EF,#F6,#8F,#EF,#F7,#07,#87,#FF
db #07,#07,#FE,#07,#8F,#FD,#07,#8E,#FC,#0B,#8E,#EC,#09,#1D,#CF,#30
db #9E,#F0,#C0,#EF,#3F,#A1,#C6,#1E,#73,#C2,#01,#FF,#E0,#0F,#FF,#FA ; #8560 ....?...s.......
db #1F,#FF,#FF,#3F,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#7C,#00,#01,#FF ; #8570 ...?........|...
db #00,#03,#FF,#80,#07,#FF,#40,#07,#F9,#C0,#0F,#F7,#E0,#0F,#FF,#BC ; #8580 ......@.........
db #0F,#FD,#A2,#0F,#FD,#C1,#07,#FF,#C1,#09,#FF,#81,#0B,#FF,#41,#1B ; #8590 ..............A.
db #BF,#02,#0B,#BB,#02,#0B,#B3,#8C,#0B,#BC,#78,#1B,#DF,#80,#05,#E6 ; #85a0 ..........x.....
db #00,#06,#D8,#00,#07,#7C,#00,#00,#2C,#00,#00,#18,#00,#00,#00,#00 ; #85b0 .....|..,.......
db #FF,#83,#FF,#FE,#7C,#FF,#FD,#FF,#7F,#FB,#FF,#BF,#F7,#FF,#5F,#F7 ; #85c0 ....|........._.
db #F9,#DF,#EF,#F7,#EF,#EF,#FF,#BF,#EF,#FD,#A3,#EF,#FD,#C1,#F7,#FF ; #85d0 ................
db #C1,#E1,#FF,#81,#E3,#FF,#41,#C3,#BF,#03,#E3,#BB,#03,#E3,#B3,#8F ; #85e0 ......A.........
db #E3,#BC,#73,#C3,#DF,#87,#E1,#E6,#7F,#F0,#C1,#FF,#F0,#41,#FF,#F8 ; #85f0 ..s..........A..
db #81,#FF,#FF,#C3,#FF,#FF,#E7,#FF,#00,#00,#00,#00,#00,#00,#0F,#3E ; #8600 ...............>
db #00,#10,#FF,#80,#21,#FF,#C0,#23,#FF,#E0,#23,#FF,#E0,#27,#FE,#F0 ; #8610 ....!..#..#..''..
db #17,#BF,#F0,#17,#5F,#F0,#0C,#DF,#F4,#03,#6F,#F0,#07,#77,#F0,#07 ; #8620 ...._.....o..w..
db #6F,#F0,#0B,#6F,#F4,#3F,#6F,#E8,#7E,#F7,#E0,#69,#CF,#C0,#37,#BF ; #8630 o..o.?o.~..i..7.
db #80,#01,#3E,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8640 ..>.............
db #FF,#FF,#FF,#FF,#C1,#FF,#FF,#3E,#7F,#F0,#FF,#BF,#E1,#FF,#DF,#E3 ; #8650 .......>........
db #FF,#EF,#E3,#FF,#EF,#E7,#FE,#F7,#F7,#BF,#F7,#F7,#1F,#F3,#FC,#1F ; #8660 ................
db #F1,#FB,#0F,#F3,#F7,#07,#F7,#F7,#0F,#F3,#CB,#0F,#F1,#8F,#0F,#E3 ; #8670 ................
db #06,#07,#E7,#00,#0F,#DF,#80,#3F,#BF,#C8,#3E,#7F,#FE,#C1,#FF,#FF ; #8680 .......?..>.....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#1E,#3E ; #8690 ...............>
db #00,#21,#FF,#80,#41,#FF,#C0,#43,#FF,#E0,#43,#FF,#E0,#47,#7F,#70 ; #86a0 .!..A..C..C..G.p
db #26,#BF,#F0,#25,#CF,#F0,#14,#77,#F0,#0B,#B7,#F0,#03,#D7,#F0,#03 ; #86b0 &..%...w........
db #D7,#F0,#01,#DB,#F0,#07,#B7,#E0,#0F,#6F,#E0,#1E,#EF,#C0,#1A,#2F ; #86c0 .........o...../
db #80,#0C,#1E,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #86d0 ................
db #FF,#FF,#FF,#FF,#C1,#FF,#FE,#3E,#7F,#E1,#FF,#BF,#C1,#FF,#DF,#C3 ; #86e0 .......>........
db #FF,#EF,#C3,#FF,#EF,#C7,#7F,#77,#E6,#3F,#F7,#E4,#0F,#F7,#F4,#07 ; #86f0 .......w.?......
db #F7,#FB,#87,#F7,#FB,#C7,#F7,#FB,#C7,#F7,#F9,#C3,#F7,#F7,#87,#EF ; #8700 ................
db #E3,#0F,#EF,#C0,#0F,#DF,#C0,#0F,#BF,#E1,#DE,#7F,#F3,#E1,#FF,#FF ; #8710 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#07,#3E ; #8720 ...............>
db #00,#08,#FF,#80,#11,#FF,#C0,#13,#FF,#E0,#13,#FF,#E8,#17,#FD,#F0 ; #8730 ................
db #0F,#7F,#F0,#0E,#BF,#F6,#01,#BF,#F4,#06,#DF,#F0,#0E,#EF,#F4,#0E ; #8740 ................
db #DF,#F6,#2E,#DF,#F4,#7E,#DF,#E8,#6D,#EF,#E0,#33,#1F,#C0,#02,#FF ; #8750 .....~..m..3....
db #80,#00,#3E,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8760 ..>.............
db #FF,#FF,#FF,#FF,#C1,#FF,#FF,#3E,#7F,#F8,#FF,#BF,#F1,#FF,#DF,#F3 ; #8770 .......>........
db #FF,#E7,#F3,#FF,#E3,#F7,#FD,#F7,#FF,#7F,#F1,#FE,#3F,#F0,#F8,#3F ; #8780 ............?..?
db #F1,#F6,#1F,#F3,#EE,#0F,#F1,#CE,#1F,#F0,#8E,#1F,#F1,#0E,#1F,#E3 ; #8790 ................
db #0C,#0F,#E7,#80,#1F,#DF,#C8,#FF,#BF,#FD,#3E,#7F,#FF,#C1,#FF,#FF ; #87a0 ..........>.....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#1D ; #87b0 ................
db #80,#07,#BE,#80,#0F,#DE,#78,#0F,#C0,#FC,#0F,#9C,#7C,#0F,#7B,#BC ; #87c0 ......x.....|.{.
db #06,#F7,#DC,#18,#F7,#D8,#3D,#FB,#A4,#3D,#9C,#6E,#38,#6F,#EE,#17 ; #87d0 ......=..=.n8o..
db #AF,#0E,#0F,#DE,#F4,#0F,#DD,#F8,#2F,#DD,#F8,#2F,#D1,#F8,#07,#AD ; #87e0 ......../../....
db #F8,#30,#5E,#F0,#36,#DF,#00,#03,#0E,#00,#00,#00,#00,#00,#00,#00 ; #87f0 .0^.6...........
db #FF,#FF,#FF,#FF,#E2,#7F,#F8,#5C,#3F,#F7,#BE,#07,#EF,#DE,#7B,#EF ; #8800 .......\?.....{.
db #C0,#FD,#EF,#94,#7D,#EF,#2B,#BD,#E6,#57,#DD,#C0,#A7,#DB,#81,#53 ; #8810 ....}.+..W.....S
db #81,#80,#88,#20,#80,#65,#40,#C7,#AA,#00,#EF,#D4,#F1,#CF,#C9,#FB ; #8820 ... .e@.........
db #AF,#D5,#FB,#AF,#C1,#FB,#C7,#A1,#FB,#B0,#40,#F7,#B0,#C0,#0F,#C8 ; #8830 ..........@.....
db #20,#FF,#FC,#F1,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #8840  ...............
db #00,#00,#1C,#80,#03,#BE,#00,#07,#DE,#70,#07,#C0,#F8,#07,#BB,#78 ; #8850 .........p.....x
db #03,#77,#B8,#00,#F7,#B0,#18,#FB,#08,#3C,#50,#3C,#3C,#2F,#BC,#1B ; #8860 .w.......<P<</..
db #9F,#D8,#07,#DF,#00,#07,#DE,#E0,#27,#CD,#F0,#03,#81,#F0,#00,#0C ; #8870 ........''.......
db #E0,#13,#5E,#00,#03,#0C,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8880 ..^.............
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#E3,#7F,#FC,#5C,#3F,#FB,#BE,#0F,#F7 ; #8890 ..........\?....
db #DE,#77,#F7,#C0,#FB,#F7,#AB,#7B,#FB,#57,#BB,#E4,#A7,#B7,#C2,#53 ; #88a0 .w.....{.W.....S
db #43,#81,#00,#01,#80,#25,#01,#C3,#8A,#83,#E7,#D5,#07,#D7,#CA,#EF ; #88b0 C....%..........
db #A7,#C5,#F7,#DB,#B1,#F7,#EC,#20,#EF,#D0,#40,#1F,#E8,#21,#FF,#FC ; #88c0 ....... ..@..!..
db #F3,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #88d0 ................
db #00,#00,#08,#00,#00,#1C,#00,#01,#08,#00,#03,#80,#20,#01,#00,#70 ; #88e0 ............ ..p
db #00,#33,#20,#00,#7B,#00,#00,#78,#00,#18,#30,#18,#18,#03,#18,#00 ; #88f0 .3 .{..x..0.....
db #07,#80,#01,#07,#80,#03,#83,#00,#01,#00,#C0,#00,#00,#C0,#00,#0C ; #8900 ................
db #00,#01,#0C,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #8910 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#F7,#FF,#FF,#EB,#FF,#FE,#DD,#FF,#FD ; #8920 ................
db #6B,#DF,#FB,#B7,#AF,#FD,#4C,#77,#FE,#A3,#2F,#FF,#53,#5F,#E7,#28 ; #8930 k.....Lw../.S_.(
db #E7,#C3,#94,#C3,#C3,#C9,#43,#E6,#F2,#A7,#FD,#75,#3F,#FB,#BA,#3F ; #8940 ......C....u?..?
db #FD,#7C,#DF,#FE,#F2,#DF,#FE,#E1,#3F,#FC,#61,#FF,#FE,#F3,#FF,#FF ; #8950 .|......?.a.....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#13 ; #8960 ................
db #00,#00,#38,#E0,#00,#3B,#F0,#01,#D7,#10,#07,#3C,#E0,#0C,#F3,#F0 ; #8970 ..8..;.....<....
db #0B,#CF,#F4,#0B,#BE,#74,#0B,#7D,#B6,#2B,#3D,#AE,#2B,#5E,#6E,#6F ; #8980 .....t.}.+=.+^no
db #67,#9D,#6B,#38,#71,#66,#BF,#C2,#80,#DF,#0E,#88,#5C,#3C,#7E,#20 ; #8990 g.k8qf......\<~
db #F8,#3F,#A3,#E0,#3F,#DF,#80,#1F,#BC,#00,#07,#40,#00,#00,#00,#00 ; #89a0 .?..?......@....
db #FF,#FF,#FF,#FF,#EC,#FF,#FF,#D3,#1F,#FF,#B8,#EF,#FE,#3B,#F7,#F9 ; #89b0 .............;..
db #D7,#17,#F7,#3C,#0F,#EC,#F0,#03,#EB,#C0,#01,#EB,#80,#01,#CB,#01 ; #89c0 ...<............
db #80,#8B,#01,#80,#8B,#00,#00,#0F,#00,#00,#0B,#00,#00,#06,#00,#00 ; #89d0 ................
db #00,#00,#00,#00,#00,#01,#00,#00,#03,#80,#00,#07,#80,#00,#1F,#C0 ; #89e0 ................
db #00,#7F,#E0,#03,#FF,#F8,#BF,#FF,#00,#00,#00,#03,#C0,#00,#07,#F0 ; #89f0 ................
db #00,#16,#78,#00,#20,#B8,#00,#20,#3C,#00,#10,#DD,#00,#2D,#99,#80 ; #8a00 ..x. .. <....-..
db #20,#E7,#00,#11,#30,#80,#2C,#CF,#00,#21,#1E,#F8,#11,#DD,#8C,#11 ; #8a10  ...0.,..!......
db #DF,#3E,#0F,#EA,#5E,#01,#F6,#DA,#01,#FA,#3E,#01,#FB,#76,#01,#FD ; #8a20 .>..^.....>..v..
db #8C,#00,#FE,#F8,#01,#3C,#00,#00,#C3,#00,#00,#3C,#00,#00,#00,#00 ; #8a30 .....<.....<....
db #FC,#3F,#FF,#FB,#CF,#FF,#F7,#F7,#FF,#F6,#7B,#FF,#E0,#BB,#FF,#E0 ; #8a40 .?........{.....
db #3C,#FF,#F0,#1C,#7F,#EC,#18,#3F,#E0,#00,#7F,#F1,#00,#BF,#EC,#CF ; #8a50 <......?........
db #07,#E0,#1E,#FB,#F0,#1D,#8D,#F0,#1F,#3E,#FE,#0A,#1E,#FC,#06,#1A ; #8a60 .........>......
db #FC,#02,#3E,#FC,#03,#76,#FC,#01,#8D,#FE,#00,#FB,#FD,#00,#07,#FE ; #8a70 ..>..v..........
db #C3,#7F,#FF,#3C,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #8a80 ...<............
db #00,#00,#00,#00,#00,#03,#80,#01,#E6,#60,#03,#B0,#30,#01,#2F,#30 ; #8a90 .........`..0./0
db #1E,#DD,#80,#3A,#19,#78,#31,#EE,#EC,#2E,#30,#CC,#59,#AF,#7A,#72 ; #8aa0 ...:.x1...0.Y.zr
db #DD,#A6,#38,#D9,#9C,#4E,#DE,#72,#73,#89,#CE,#1C,#E7,#38,#07,#3C ; #8ab0 ..8..N.rs....8.<
db #E0,#01,#C3,#80,#00,#7E,#00,#00,#18,#00,#00,#00,#00,#00,#00,#00 ; #8ac0 .....~..........
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FC,#7F,#FE,#18,#1F,#FD ; #8ad0 ................
db #E0,#0F,#FB,#B0,#87,#E1,#2F,#07,#DE,#DD,#87,#BA,#19,#7B,#B1,#EE ; #8ae0 ....../......{..
db #ED,#A0,#30,#CD,#00,#2F,#78,#02,#1D,#A0,#80,#19,#81,#00,#1E,#00 ; #8af0 ..0../x.........
db #00,#08,#00,#80,#00,#01,#E0,#00,#07,#F8,#00,#1F,#FE,#00,#7F,#FF ; #8b00 ................
db #81,#FF,#FF,#E7,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#3C,#00,#00,#F8 ; #8b10 ............<...
db #00,#01,#F0,#F0,#01,#CF,#38,#03,#BF,#D8,#02,#3F,#00,#01,#F8,#FE ; #8b20 ......8....?....
db #07,#F7,#FC,#0F,#EF,#F0,#1B,#FF,#C8,#19,#78,#38,#17,#3D,#F0,#21 ; #8b30 ..........x8.=.!
db #FF,#7C,#28,#FE,#76,#31,#9F,#0E,#5B,#DF,#BE,#6B,#BB,#BC,#30,#71 ; #8b40 .|(.v1..[..k..0q
db #9C,#00,#0F,#80,#00,#77,#00,#00,#7E,#00,#00,#38,#00,#00,#00,#00 ; #8b50 .....w..~..8....
db #FF,#C3,#FF,#FF,#3D,#FF,#FE,#FB,#0F,#FD,#F0,#F7,#FD,#CF,#3B,#FB ; #8b60 ....=.........;.
db #BF,#DB,#FA,#3F,#01,#F9,#F8,#FE,#F7,#F7,#FD,#EF,#EF,#F3,#DB,#FF ; #8b70 ...?............
db #CB,#D9,#78,#3B,#D7,#3D,#F3,#A1,#FF,#7D,#A0,#FE,#76,#B1,#9F,#0E ; #8b80 ..x;.=...}..v...
db #5B,#DF,#BE,#6B,#BB,#BD,#B4,#71,#9D,#CF,#8F,#A3,#FF,#77,#7F,#FF ; #8b90 [..k...q.....w..
db #7E,#FF,#FF,#B9,#FF,#FF,#C7,#FF,#00,#00,#00,#00,#3C,#00,#01,#FF ; #8ba0 ~...........<...
db #80,#07,#FF,#E0,#0F,#FF,#F0,#1F,#FF,#F8,#0F,#FF,#F0,#17,#FF,#E8 ; #8bb0 ................
db #09,#FF,#90,#06,#3C,#68,#19,#C3,#8C,#30,#3C,#6C,#30,#40,#1C,#19 ; #8bc0 ....<h...0<l0@..
db #CE,#38,#0E,#01,#E4,#13,#CF,#06,#30,#78,#66,#30,#00,#0C,#18,#00 ; #8bd0 .8......0xf0....
db #38,#0E,#01,#E4,#03,#CF,#0C,#00,#78,#00,#00,#00,#00,#00,#00,#00 ; #8be0 8.......x.......
db #FF,#C3,#FF,#FE,#3C,#7F,#F9,#DB,#9F,#F6,#A5,#6F,#ED,#5A,#B7,#DA ; #8bf0 ....<......o.Z..
db #A5,#5B,#ED,#5A,#B7,#C6,#A5,#63,#E1,#DB,#87,#E0,#3C,#0B,#D8,#00 ; #8c00 .[.Z...c....<...
db #0D,#B6,#00,#6D,#B6,#41,#9D,#D9,#CE,#3B,#EE,#31,#E5,#D3,#CF,#16 ; #8c10 ...m.A...;.1....
db #B4,#78,#66,#B7,#87,#8D,#D9,#FE,#3B,#EE,#31,#E5,#F3,#CF,#0D,#FC ; #8c20 .xf.....;.1.....
db #78,#F3,#FF,#87,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #8c30 x...............
db #00,#00,#3C,#00,#01,#FF,#80,#07,#FF,#E0,#0F,#FF,#F0,#1F,#FF,#F8 ; #8c40 ..<.............
db #0F,#FF,#F0,#17,#FF,#E8,#09,#FF,#90,#16,#3C,#6C,#31,#C3,#8C,#32 ; #8c50 ..........<l1..2
db #3C,#1C,#18,#00,#38,#0E,#01,#E2,#33,#CF,#06,#30,#78,#0C,#18,#00 ; #8c60 <...8...3..0x...
db #38,#0E,#01,#E4,#03,#CF,#0C,#00,#78,#00,#00,#00,#00,#00,#00,#00 ; #8c70 8.......x.......
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#C3,#FF,#FE,#3C,#7F,#F9,#DB,#9F,#F6 ; #8c80 ..........<.....
db #A5,#6F,#ED,#5A,#B7,#DA,#A5,#5B,#ED,#5A,#B7,#C6,#A5,#63,#E1,#DB ; #8c90 .o.Z...[.Z...c..
db #83,#D0,#3C,#0D,#B0,#00,#0D,#B2,#00,#5D,#D9,#C2,#39,#CE,#31,#E2 ; #8ca0 ..<......]..9.1.
db #B3,#CF,#16,#B4,#78,#CD,#D9,#86,#3B,#EE,#31,#E5,#F3,#CF,#0D,#FC ; #8cb0 ....x...;.1.....
db #78,#F3,#FF,#87,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#38,#6C,#00,#F8 ; #8cc0 x...........8l..
db #96,#00,#DD,#8C,#71,#6D,#80,#19,#AD,#A0,#6D,#03,#58,#34,#F8,#D8 ; #8cd0 ....qm....m.X4..
db #7B,#E0,#64,#77,#DF,#2E,#77,#FF,#B6,#2F,#18,#B0,#2E,#36,#B6,#36 ; #8ce0 {.dw..w../...6.6
db #2F,#98,#36,#3E,#3E,#3B,#29,#BA,#31,#B3,#30,#20,#DC,#64,#21,#67 ; #8cf0 /.6>>;).1.0 .d!g
db #CC,#07,#98,#B8,#03,#67,#00,#00,#E0,#00,#00,#60,#00,#00,#00,#00 ; #8d00 .....g.....`....
db #FF,#C7,#93,#FF,#03,#61,#FE,#02,#84,#8E,#01,#A1,#74,#01,#93,#98 
db #01,#A7,#0C,#03,#5B,#84,#F8,#DB,#03,#E0,#65,#07,#DF,#2E,#07,#FF 
db #B6,#8F,#18,#B1,#8E,#36,#B6,#86,#2F,#99,#86,#3E,#3E,#83,#29,#BA 
db #85,#B3,#31,#8E,#DC,#65,#88,#67,#CD,#D0,#18,#BB,#F8,#07,#47,#FC ; #8d40 ..1..e.g......G.
db #08,#FF,#FF,#0F,#FF,#FF,#9F,#FF,#00,#00,#00,#00,#38,#68,#00,#F8 ; #8d50 ............8h..
db #94,#18,#DD,#9C,#31,#6D,#88,#19,#AD,#A0,#2D,#03,#58,#34,#F8,#D8 ; #8d60 ....1m....-.X4..
db #3B,#E0,#64,#37,#DF,#2E,#17,#FF,#B6,#2F,#18,#B0,#2E,#36,#B6,#36 ; #8d70 ;.d7...../...6.6
db #2F,#98,#36,#3E,#3E,#3B,#29,#BA,#21,#B3,#30,#18,#DC,#64,#03,#67 ; #8d80 /.6>>;).!.0..d.g
db #D8,#03,#18,#B0,#02,#E7,#00,#01,#C0,#00,#00,#80,#00,#00,#00,#00 
db #FF,#C7,#97,#FF,#03,#63,#E6,#02,#81,#DA,#01,#89,#B4,#01,#83,#D8 
db #01,#A7,#8C,#03,#5B,#84,#F8,#DB,#83,#E0,#65,#87,#DF,#2E,#C7,#FF 
db #B6,#8F,#18,#B1,#8E,#36,#B6,#86,#2F,#99,#86,#3E,#3E,#83,#29,#BA 
db #85,#B3,#31,#C0,#DC,#65,#E0,#67,#DB,#F8,#18,#B7,#F8,#07,#4F,#FC 
db #18,#FF,#FE,#3F,#FF,#FF,#7F,#FF,#00,#00,#00,#02,#70,#00,#05,#FC 
db #00,#07,#FE,#00,#09,#BE,#10,#3E,#7E,#7C,#63,#BD,#C6,#40,#5A,#02 
db #47,#66,#E2,#4F,#99,#F2,#6F,#AD,#F6,#2F,#BD,#F4,#2F,#AD,#F4,#2F ; #8e00 Gf.O..o../../../
db #DB,#F4,#4F,#DB,#F2,#77,#DB,#EE,#73,#DB,#CE,#6C,#99,#36,#2F,#5A 
db #F4,#0F,#66,#F0,#03,#7E,#C0,#00,#7E,#00,#00,#3C,#00,#00,#00,#00 
db #FD,#8F,#FF,#F8,#03,#FF,#F0,#01,#FF,#F0,#00,#EF,#C8,#00,#93,#BE 
db #00,#7D,#63,#81,#C6,#58,#42,#1A,#51,#66,#8A,#44,#18,#22,#61,#0C 
db #86,#A4,#1C,#25,#A1,#0C,#85,#A4,#4A,#25,#01,#08,#82,#30,#4A,#06 
db #30,#08,#06,#24,#08,#36,#87,#0A,#71,#C7,#26,#73,#F3,#3E,#0F,#FC 
db #3E,#3F,#FF,#9D,#FF,#FF,#C3,#FF,#00,#00,#00,#07,#00,#00,#0B,#80 
db #00,#0F,#80,#00,#07,#3E,#00,#00,#DF,#80,#06,#EF,#E0,#0F,#70,#F0 
db #1F,#00,#F8,#1F,#FF,#F8,#2F,#FF,#F4,#2F,#FF,#F4,#13,#FF,#C8,#4C 
db #7E,#32,#73,#81,#CE,#7C,#7E,#3E,#7F,#00,#FE,#7F,#C3,#FE,#3F,#E7 
db #FC,#0F,#E7,#F0,#03,#E7,#C0,#00,#E7,#00,#00,#24,#00,#00,#00,#00 
db #F8,#FF,#FF,#F7,#7F,#FF,#EB,#BF,#FF,#EF,#81,#FF,#F7,#00,#7F,#F8 
db #C0,#1F,#F0,#E0,#0F,#E0,#70,#07,#C0,#00,#03,#C0,#00,#03,#A0,#00 
db #05,#A0,#00,#05,#90,#00,#09,#0C,#00,#30,#03,#81,#C0,#00,#7E,#00 
db #00,#00,#00,#00,#00,#00,#80,#00,#01,#C0,#00,#03,#F0,#00,#0F,#FC 
db #00,#3F,#FF,#00,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#00,#20,#00,#00 ; #8f00 .?........... ..
db #F0,#00,#03,#C8,#00,#0F,#38,#00,#3C,#C8,#00,#F3,#28,#03,#CC,#28 
db #0F,#34,#28,#14,#C4,#28,#1B,#14,#28,#1A,#14,#28,#1A,#14,#28,#1A 
db #14,#C8,#1A,#15,#30,#1A,#14,#C0,#1A,#37,#00,#1A,#CC,#00,#1A,#30 
db #00,#1A,#C0,#00,#0B,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 
db #FF,#FF,#DF,#FF,#FF,#0F,#FF,#FC,#07,#FF,#F0,#03,#FF,#C0,#03,#FF 
db #00,#03,#FC,#00,#23,#F0,#00,#A3,#E0,#01,#A3,#C0,#01,#A3,#D0,#11 
db #A3,#C8,#D1,#A3,#D0,#D1,#23,#C8,#D0,#C3,#D0,#D1,#07,#C8,#D0,#0F 
db #D0,#30,#3F,#C8,#C0,#FF,#D0,#03,#FF,#C8,#0F,#FF,#E0,#3F,#FF,#F0 
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#01,#20,#00,#07,#C8 
db #00,#0C,#72,#00,#13,#9C,#00,#17,#E3,#E0,#2F,#EF,#FC,#6F,#DF,#F8 
db #5F,#BF,#C4,#47,#7C,#2E,#3B,#02,#36,#3F,#75,#96,#7E,#F5,#14,#7E 
db #F4,#10,#7E,#FA,#24,#1D,#7D,#9C,#65,#80,#78,#79,#9F,#F4,#7E,#47 
db #CC,#6A,#F0,#38,#3C,#7C,#00,#00,#6A,#00,#00,#3C,#00,#00,#00,#00 
db #FE,#DF,#FF,#F9,#07,#FF,#F7,#C1,#FF,#EC,#70,#FF,#D0,#1C,#1F,#D0 
db #00,#03,#A0,#00,#01,#60,#00,#01,#40,#00,#05,#40,#00,#0E,#80,#00 
db #06,#80,#71,#86,#00,#F1,#05,#00,#F0,#01,#00,#F8,#01,#80,#7C,#01 
db #60,#00,#03,#78,#00,#05,#7E,#40,#0D,#6A,#F0,#3B,#BD,#7D,#C7,#C3 ; #9010 `..x..~@.j.;.}..
db #6A,#FF,#FF,#BD,#FF,#FF,#C3,#FF,#00,#00,#00,#01,#20,#00,#07,#C8 ; #9020 j........... ...
db #00,#0C,#72,#00,#13,#9C,#00,#17,#E3,#E0,#2F,#EF,#FC,#6F,#DF,#F8 ; #9030 ..r......./..o..
db #5F,#BF,#C4,#47,#7C,#2E,#3B,#02,#36,#3F,#75,#96,#7E,#F5,#14,#7E ; #9040 _..G|.;.6?u.~..~
db #F4,#10,#7E,#FA,#24,#0D,#7D,#9C,#71,#80,#7A,#3D,#9F,#F6,#3E,#67 ; #9050 ..~.$.}.q.z=..>g
db #CA,#35,#78,#1C,#1E,#FC,#00,#00,#D4,#00,#00,#78,#00,#00,#00,#00 ; #9060 .5x........x....
db #FE,#DF,#FF,#F9,#07,#FF,#F7,#C1,#FF,#EC,#70,#FF,#D0,#1C,#1F,#D0 ; #9070 ..........p.....
db #00,#03,#A0,#00,#01,#60,#00,#01,#40,#00,#05,#40,#00,#0E,#80,#00 ; #9080 .....`..@..@....
db #06,#80,#71,#86,#00,#F1,#05,#00,#F0,#01,#00,#F8,#01,#80,#7C,#01 ; #9090 ..q...........|.
db #70,#00,#02,#BC,#00,#06,#BE,#60,#0A,#B5,#78,#1D,#DE,#FD,#E3,#E0 ; #90a0 p......`..x.....
db #D5,#FF,#FF,#7B,#FF,#FF,#87,#FF,#00,#00,#00,#00,#00,#00,#00,#3E ; #90b0 ...{...........>
db #00,#00,#07,#80,#07,#79,#A0,#1C,#FE,#D0,#3B,#FE,#D8,#37,#FF,#68 ; #90c0 .....y....;..7.h
db #4F,#FF,#6C,#6F,#FF,#B4,#2F,#FF,#B6,#43,#FF,#B6,#2F,#E3,#B4,#1F ; #90d0 O.lo../..C../...
db #DF,#34,#3D,#FF,#B2,#3D,#FF,#B4,#31,#BF,#B2,#0D,#BF,#4E,#1C,#81 ; #90e0 .4=..=..1....N..
db #3E,#0E,#7E,#1C,#00,#F4,#00,#00,#FC,#00,#00,#78,#00,#00,#00,#00 ; #90f0 >.~........x....
db #FF,#FF,#FF,#FF,#C1,#FF,#FF,#BE,#7F,#F8,#07,#9F,#E0,#01,#8F,#C0 ; #9100 ................
db #00,#C7,#80,#00,#C3,#80,#00,#63,#40,#00,#61,#60,#00,#31,#A0,#00 ; #9110 .......c@.a`.1..
db #30,#00,#00,#30,#80,#00,#31,#C0,#00,#31,#80,#00,#30,#80,#00,#31 ; #9120 0..0..1..1..0..1
db #80,#00,#32,#CC,#00,#4E,#DC,#00,#3E,#EE,#7E,#DD,#F0,#F5,#E3,#FE ; #9130 ..2..N..>.~.....
db #FD,#FF,#FF,#7B,#FF,#FF,#87,#FF,#00,#00,#00,#00,#00,#00,#00,#3E ; #9140 ...{...........>
db #00,#00,#07,#80,#07,#79,#A0,#1C,#FE,#D0,#3B,#FE,#D8,#37,#FF,#68 ; #9150 .....y....;..7.h
db #4F,#FF,#6C,#6F,#FF,#B4,#2F,#FF,#B6,#43,#FF,#B6,#2F,#E3,#B4,#1F ; #9160 O.lo../..C../...
db #DF,#34,#3D,#FF,#B2,#3D,#FF,#B4,#0D,#BF,#B2,#31,#BF,#4C,#3C,#81 ; #9170 .4=..=.....1.L<.
db #3C,#1C,#3E,#78,#00,#7A,#00,#00,#7E,#00,#00,#3C,#00,#00,#00,#00 ; #9180 <.>x.z..~..<....
db #FF,#FF,#FF,#FF,#C1,#FF,#FF,#BE,#7F,#F8,#07,#9F,#E0,#01,#8F,#C0 ; #9190 ................
db #00,#C7,#80,#00,#C3,#80,#00,#63,#40,#00,#61,#60,#00,#31,#A0,#00 ; #91a0 .......c@.a`.1..
db #30,#00,#00,#30,#80,#00,#31,#C0,#00,#31,#80,#00,#30,#80,#00,#31 ; #91b0 0..0..1..1..0..1
db #C0,#00,#32,#B0,#00,#4D,#BC,#00,#3D,#DD,#3E,#7B,#E3,#7A,#87,#FF ; #91c0 ..2..M..=.>{.z..
db #7E,#FF,#FF,#BD,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#3C,#00,#01,#E7 ; #91d0 ~...........<...
db #00,#03,#F9,#C0,#06,#7E,#E0,#05,#BF,#50,#35,#B9,#A8,#76,#74,#98 ; #91e0 .....~...P5..vt.
db #7B,#F9,#D8,#24,#FF,#E8,#5E,#1F,#F0,#5E,#C0,#08,#5E,#FF,#F8,#5C ; #91f0 {..$..^..^..^..\
db #7F,#B4,#5B,#1F,#8A,#2F,#CE,#7A,#4F,#01,#F6,#73,#6F,#90,#34,#F7 ; #9200 ..[../.zO..so.4.
db #60,#03,#76,#E0,#03,#71,#C0,#01,#B7,#00,#00,#4C,#00,#00,#00,#00 ; #9210 `.v..q.....L....
db #FF,#C3,#FF,#FE,#00,#FF,#FC,#00,#3F,#F8,#00,#1F,#F0,#00,#0F,#C1 ; #9220 ........?.......
db #80,#07,#B1,#80,#23,#70,#04,#03,#78,#00,#03,#A4,#00,#03,#1E,#00 ; #9230 ....#p..x.......
db #07,#1E,#C0,#0B,#1E,#FF,#FB,#1C,#7F,#B1,#1B,#1F,#88,#8F,#CE,#78 ; #9240 ...............x
db #4F,#01,#F0,#73,#0F,#90,#B4,#07,#6F,#CB,#06,#EF,#FB,#01,#DF,#FD ; #9250 O..s....o.......
db #87,#3F,#FE,#4C,#FF,#FF,#B3,#FF,#00,#00,#00,#00,#3C,#00,#00,#C7 ; #9260 .?.L........<...
db #80,#03,#F9,#C0,#05,#FE,#E0,#09,#9F,#60,#1F,#6F,#60,#0F,#6F,#60 ; #9270 .........`.o`.o`
db #07,#9F,#DC,#01,#FE,#3E,#06,#39,#DE,#0D,#83,#EC,#0B,#CB,#E2,#0B ; #9280 .....>.9........
db #C9,#CE,#03,#CA,#2E,#2F,#AB,#EE,#2F,#AB,#EC,#37,#6B,#E2,#38,#E9 ; #9290 ...../../..7k.8.
db #DE,#1B,#EA,#2C,#01,#EB,#E0,#00,#75,#C0,#00,#00,#00,#00,#00,#00 ; #92a0 ...,....u.......
db #FF,#C3,#FF,#FF,#00,#7F,#FC,#00,#3F,#F8,#00,#1F,#F4,#00,#0F,#E0 ; #92b0 ........?.......
db #00,#0F,#C0,#60,#0F,#E0,#60,#03,#F0,#00,#1D,#F8,#00,#3E,#F6,#01 ; #92c0 ...`..`......>..
db #DE,#ED,#83,#ED,#EB,#C3,#E0,#EB,#C1,#C0,#D3,#C0,#00,#8F,#A0,#00 ; #92d0 ................
db #8F,#A0,#01,#87,#60,#02,#80,#E0,#1E,#C3,#E2,#2D,#E5,#E3,#E3,#FE ; #92e0 ....`......-....
db #71,#DF,#FF,#8A,#3F,#FF,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #92f0 q...?...........
db #00,#00,#0C,#00,#00,#0E,#00,#00,#0C,#00,#38,#08,#00,#6E,#00,#00 ; #9300 ..........8..n..
db #3F,#DB,#FC,#00,#00,#76,#0D,#91,#9C,#10,#32,#00,#20,#54,#04,#46 ; #9310 ?....v....2. T.F
db #74,#62,#4D,#28,#B2,#49,#18,#92,#46,#3C,#62,#20,#24,#04,#38,#C3 ; #9320 tbM(.I..F<b $.8.
db #1C,#0F,#3C,#F0,#03,#FF,#C0,#00,#E7,#00,#00,#3C,#00,#00,#00,#00 ; #9330 ..<........<....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#F1,#FF,#FF,#EC,#FF,#FF,#EE,#FF,#C3 ; #9340 ................
db #ED,#FF,#B8,#EB,#FF,#6E,#00,#03,#BF,#C3,#FD,#C0,#00,#76,#E0,#10 ; #9350 .....n.......v..
db #1D,#C0,#30,#03,#80,#50,#01,#06,#70,#60,#0D,#20,#B0,#09,#00,#90 ; #9360 ..0..P..p`. ....
db #06,#00,#60,#80,#00,#01,#80,#00,#01,#C0,#00,#03,#F0,#00,#0F,#FC ; #9370 ..`.............
db #00,#3F,#FF,#00,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #9380 .?..............
db #00,#00,#00,#00,#1C,#01,#C0,#17,#03,#40,#0F,#87,#80,#00,#E6,#00 ; #9390 .........@......
db #00,#18,#00,#02,#26,#00,#0C,#E3,#C0,#13,#C0,#F8,#25,#A4,#6C,#47 ; #93a0 ....&.......%.lG
db #24,#3A,#40,#18,#82,#49,#18,#92,#46,#3C,#62,#20,#24,#04,#38,#C3 ; #93b0 $:@..I..F<b $.8.
db #1C,#0F,#3C,#F0,#03,#FF,#C0,#00,#E7,#00,#00,#3C,#00,#00,#00,#00 ; #93c0 ..<........<....
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#E3,#FE,#3F,#DC,#FD,#DF,#D7 ; #93d0 ...........?....
db #7B,#5F,#EF,#97,#BF,#F0,#E6,#7F,#FC,#00,#7F,#F0,#26,#3F,#E0,#E3 ; #93e0 {_..........&?..
db #C7,#C3,#C0,#FB,#85,#80,#6D,#07,#00,#38,#00,#00,#80,#09,#00,#90 ; #93f0 ......m..8......
db #06,#00,#60,#80,#00,#01,#80,#00,#01,#C0,#00,#03,#F0,#00,#0F,#FC ; #9400 ..`.............
db #00,#3F,#FF,#00,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#7E,#00,#01,#E7 ; #9410 .?..........~...
db #80,#03,#99,#C0,#07,#C3,#E0,#07,#FF,#E0,#07,#FF,#E0,#0B,#FF,#D0 ; #9420 ................
db #0D,#FF,#90,#0C,#3C,#50,#0C,#C0,#D0,#12,#CC,#A8,#13,#4D,#28,#39 ; #9430 ....<P.......M(9
db #33,#1C,#2E,#30,#74,#5B,#C3,#DA,#66,#FF,#66,#79,#BD,#9E,#3E,#66 ; #9440 3..0t[..f.fy..>f
db #7C,#0F,#99,#F0,#03,#E7,#C0,#00,#FF,#00,#00,#3C,#00,#00,#00,#00 ; #9450 |..........<....
db #FF,#81,#FF,#FE,#00,#7F,#FC,#00,#3F,#F8,#18,#1F,#F0,#00,#0F,#F0 ; #9460 ........?.......
db #00,#0F,#F0,#00,#0F,#E8,#00,#17,#EC,#00,#17,#EC,#00,#57,#EC,#C0 ; #9470 .............W..
db #D7,#C2,#CC,#A3,#C3,#4D,#23,#81,#33,#01,#80,#30,#01,#40,#00,#02 ; #9480 .....M#.3..0.@..
db #60,#00,#06,#78,#00,#1E,#BE,#00,#7D,#CF,#81,#F3,#F3,#E7,#CF,#FC ; #9490 `..x....}.......
db #FF,#3F,#FF,#3C,#FF,#FF,#C3,#FF,#00,#00,#00,#00,#1E,#60,#00,#E1 ; #94a0 .?.<.........`..
db #F0,#03,#07,#F8,#04,#1F,#E4,#08,#7F,#94,#11,#FE,#54,#22,#F8,#EA ; #94b0 ............T"..
db #23,#22,#AA,#43,#D7,#6A,#41,#D5,#1A,#41,#D3,#64,#54,#E8,#9E,#48 ; #94c0 #".C.jA..A.dT..H
db #EF,#7E,#48,#74,#FE,#48,#3B,#C2,#24,#37,#92,#26,#37,#4E,#11,#B6 ; #94d0 .~Ht.H;.$7.&7N..
db #3C,#0C,#36,#F0,#03,#37,#C0,#00,#D7,#00,#00,#2C,#00,#00,#00,#00 ; #94e0 <.6..7.....,....
db #FF,#FF,#9F,#FF,#E0,#6F,#FF,#01,#F7,#FC,#07,#FB,#F8,#1F,#E5,#F0 ; #94f0 .....o..........
db #7F,#85,#E1,#FE,#05,#C2,#F8,#42,#C3,#20,#A2,#83,#C2,#42,#81,#C5 ; #9500 .......B. ...B..
db #02,#81,#C2,#05,#80,#E0,#1E,#80,#E0,#7E,#80,#70,#FE,#80,#3B,#C2 ; #9510 .........~.p..;.
db #C0,#37,#82,#C0,#37,#0E,#E0,#36,#3D,#F0,#36,#F3,#FC,#37,#CF,#FF ; #9520 .7..7..6=.6..7..
db #17,#3F,#FF,#EC,#FF,#FF,#F3,#FF,#00,#00,#00,#00,#07,#00,#00,#3F ; #9530 .?.............?
db #C0,#01,#FE,#30,#07,#F1,#C0,#1F,#8E,#10,#1E,#70,#08,#21,#80,#04 ; #9540 ...0.......p.!..
db #3A,#00,#04,#3A,#00,#02,#74,#00,#02,#74,#00,#02,#68,#00,#02,#42 ; #9550 :..:..t..t..h..B
db #00,#02,#42,#00,#02,#46,#00,#02,#5C,#00,#04,#50,#00,#24,#10,#03 ; #9560 ..B..F..\..P.$..
db #C8,#0C,#01,#30,#03,#00,#C0,#00,#E7,#00,#00,#18,#00,#00,#00,#00 ; #9570 ...0............
db #FF,#F8,#FF,#FF,#C7,#3F,#FE,#3F,#CF,#F9,#FE,#37,#E7,#F1,#CF,#DF ; #9580 .....?.?...7....
db #8E,#0F,#DE,#70,#07,#A1,#80,#03,#BA,#00,#03,#BA,#00,#01,#74,#00 ; #9590 ...p..........t.
db #01,#74,#00,#01,#68,#00,#01,#40,#00,#01,#40,#00,#01,#40,#00,#01 ; #95a0 .t..h..@..@..@..
db #40,#00,#03,#40,#00,#03,#80,#00,#07,#F0,#00,#0F,#FC,#00,#3F,#FF ; #95b0 @..@..........?.
db #00,#FF,#FF,#E7,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#3C,#00,#01,#C3 ; #95c0 ............<...
db #80,#06,#3C,#60,#0D,#C3,#B0,#1A,#24,#58,#0C,#5A,#30,#16,#24,#68 ; #95d0 ..<`....$X.Z0.$h
db #09,#C3,#90,#06,#3C,#60,#09,#C3,#90,#14,#3C,#28,#19,#00,#98,#36 ; #95e0 ....<`....<(...6
db #24,#6C,#23,#C3,#C4,#6B,#66,#D6,#36,#24,#6C,#5E,#A5,#7A,#27,#66 ; #95f0 $l#..kf.6$l^.z''f
db #E4,#19,#E7,#98,#06,#24,#60,#01,#DB,#80,#00,#3C,#00,#00,#00,#00 ; #9600 .....$`....<....
db #FF,#C3,#FF,#FE,#3C,#7F,#F9,#C3,#9F,#F6,#00,#6F,#EC,#00,#37,#D8 ; #9610 ....<......o..7.
db #00,#1B,#EC,#18,#37,#C6,#00,#63,#E1,#C3,#87,#F0,#3C,#0F,#E8,#00 ; #9620 ....7..c....<...
db #17,#C4,#00,#23,#C1,#00,#83,#80,#24,#01,#80,#00,#01,#08,#00,#10 ; #9630 ...#....$.......
db #80,#00,#01,#40,#81,#02,#A0,#00,#05,#D8,#00,#1B,#E6,#00,#67,#F9 ; #9640 ...@..........g.
db #DB,#9F,#FE,#3C,#7F,#FF,#C3,#FF,#00,#3C,#00,#00,#C3,#00,#01,#00 ; #9650 ...<.....<......
db #00,#02,#00,#C0,#02,#03,#20,#04,#1C,#A0,#04,#33,#00,#04,#49,#E0 ; #9660 ...... ....3..I.
db #18,#77,#80,#14,#34,#A0,#0E,#02,#F0,#04,#0F,#E0,#02,#0F,#90,#02 ; #9670 .w..4...........
db #00,#70,#01,#07,#E0,#0B,#03,#D0,#1A,#00,#18,#0C,#00,#30,#16,#00 ; #9680 .p...........0..
db #68,#09,#C3,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #9690 h....<`....<....
db #FF,#C3,#FF,#FF,#00,#FF,#FE,#00,#3F,#FC,#00,#DF,#FC,#03,#2F,#F8 ; #96a0 ........?...../.
db #1C,#2F,#F8,#33,#1F,#E0,#41,#EF,#C0,#77,#8F,#C4,#34,#AF,#EE,#02 ; #96b0 ./.3..A..w..4...
db #F7,#F4,#0F,#EF,#F8,#0F,#97,#FC,#00,#77,#F0,#07,#EF,#E8,#03,#D7 ; #96c0 .........w......
db #D8,#00,#1B,#EC,#00,#37,#C6,#00,#63,#E1,#C3,#87,#F0,#3C,#0F,#F8 ; #96d0 .....7..c....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#3C,#00,#00,#C3,#00,#01,#00 ; #96e0 .........<......
db #80,#02,#00,#40,#00,#00,#20,#04,#00,#20,#0C,#00,#10,#00,#00,#18 ; #96f0 ...@.. .. ......
db #0C,#00,#18,#18,#40,#10,#18,#A0,#10,#08,#E0,#20,#10,#40,#20,#08 ; #9700 ....@...... .@ .
db #00,#40,#00,#00,#40,#08,#00,#B0,#18,#00,#58,#0C,#00,#30,#16,#00 ; #9710 .@..@.....X..0..
db #68,#09,#C3,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #9720 h....<`....<....
db #FF,#C3,#FF,#FF,#00,#FF,#FE,#00,#7F,#FC,#00,#3F,#F8,#00,#1F,#F4 ; #9730 ...........?....
db #00,#0F,#EC,#00,#07,#F0,#00,#03,#EC,#00,#03,#D8,#00,#07,#D8,#80 ; #9740 ................
db #0F,#E8,#C0,#1F,#D0,#00,#1F,#E8,#00,#3F,#F0,#00,#0F,#E8,#00,#37 ; #9750 .........?.....7
db #D8,#00,#1B,#EC,#00,#37,#C6,#00,#63,#E1,#C3,#87,#F0,#3C,#0F,#F8 ; #9760 .....7..c....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#00,#00,#00,#7E,#30,#01,#81 ; #9770 ............~0..
db #48,#02,#03,#B8,#04,#7F,#98,#34,#FE,#58,#49,#8D,#D0,#75,#74,#50 ; #9780 H......4.XI..utP
db #65,#C5,#80,#35,#B4,#40,#1F,#C6,#C0,#0B,#BF,#40,#07,#F7,#80,#03 ; #9790 e..5.@.....@....
db #EF,#80,#03,#F0,#40,#0B,#FD,#D0,#1B,#EE,#D8,#0D,#CF,#B0,#16,#76 ; #97a0 ....@..........v
db #68,#09,#81,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #97b0 h....<`....<....
db #FF,#FF,#CF,#FF,#80,#B7,#FE,#01,#4B,#FC,#03,#BB,#C8,#7F,#9B,#B0 ; #97c0 ........K.......
db #FE,#5B,#49,#8D,#D7,#75,#74,#57,#65,#C4,#0F,#B5,#84,#5F,#DF,#C6 ; #97d0 .[I..utWe...._..
db #DF,#EB,#BF,#5F,#F7,#F7,#BF,#FB,#EF,#BF,#F3,#F0,#4F,#EB,#FD,#D7 ; #97e0 ..._........O...
db #DB,#EE,#DB,#ED,#CF,#B7,#C6,#76,#63,#E1,#81,#87,#F0,#3C,#0F,#F8 ; #97f0 .......vc....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#00,#00,#00,#7E,#00,#01,#81 ; #9800 ............~...
db #B0,#02,#00,#78,#02,#00,#38,#04,#40,#B8,#18,#61,#B0,#3C,#3F,#20 ; #9810 ...x..8.@..a.<?
db #3C,#08,#20,#3E,#00,#20,#1E,#00,#20,#0E,#86,#40,#07,#CF,#C0,#03 ; #9820 <. >. .. ..@....
db #FF,#C0,#03,#FF,#C0,#0B,#FF,#D0,#1B,#FE,#D8,#0D,#F9,#B0,#16,#7E ; #9830 ...............~
db #68,#09,#81,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #9840 h....<`....<....
db #FF,#FF,#FF,#FF,#81,#CF,#FE,#00,#37,#FC,#00,#3B,#FC,#00,#1B,#E0 ; #9850 ........7..;....
db #00,#1B,#D8,#00,#17,#BC,#00,#0F,#BC,#00,#1F,#BE,#00,#1F,#DE,#00 ; #9860 ................
db #1F,#EE,#86,#5F,#F7,#CF,#DF,#FB,#FF,#DF,#F3,#FF,#CF,#EB,#FF,#D7 ; #9870 ..._............
db #DB,#FE,#DB,#ED,#F9,#B7,#C6,#7E,#63,#E1,#81,#87,#F0,#3C,#0F,#F8 ; #9880 .......~c....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#00,#00,#00,#0E,#60,#00,#7F ; #9890 .............`..
db #B0,#01,#FC,#C8,#03,#CB,#58,#1B,#B2,#68,#3D,#A4,#70,#63,#C7,#B0 ; #98a0 ......X..h=.pc..
db #5B,#EF,#D0,#3F,#FF,#EC,#1B,#FB,#DA,#0B,#F3,#F2,#01,#F0,#FC,#00 ; #98b0 [..?............
db #E6,#38,#01,#39,#80,#0B,#CF,#50,#1B,#F0,#D8,#0D,#FF,#B0,#16,#3C ; #98c0 .8.9...P.......<
db #68,#09,#C3,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #98d0 h....<`....<....
db #FF,#F1,#9F,#FF,#80,#0F,#FE,#00,#07,#FC,#00,#0B,#E0,#03,#1B,#C0 ; #98e0 ................
db #32,#0B,#80,#20,#07,#00,#00,#07,#18,#00,#03,#BC,#00,#01,#D8,#00 ; #98f0 2.. ............
db #00,#E8,#00,#00,#F4,#00,#01,#FC,#06,#03,#F0,#00,#07,#E8,#00,#17 ; #9900 ................
db #D8,#00,#1B,#EC,#00,#37,#C6,#00,#63,#E1,#C3,#87,#F0,#3C,#0F,#F8 ; #9910 .....7..c....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#00,#00,#18,#06,#70,#3C,#3F ; #9920 .............p<?
db #B0,#3E,#FB,#D8,#3D,#FF,#E8,#1D,#FF,#E8,#1A,#FF,#F0,#07,#FF,#F0 ; #9930 .>..=...........
db #07,#FF,#F0,#0F,#FF,#F0,#0F,#BF,#E0,#06,#7F,#E0,#01,#FF,#40,#01 ; #9940 ..............@.
db #FE,#80,#01,#BE,#40,#0C,#7D,#D0,#1B,#BF,#D8,#0D,#FF,#B0,#16,#3C ; #9950 ....@.}........<
db #68,#09,#C3,#90,#06,#3C,#60,#01,#C3,#80,#00,#3C,#00,#00,#00,#00 ; #9960 h....<`....<....
db #E7,#F9,#8F,#C3,#C0,#07,#81,#00,#07,#80,#00,#03,#80,#00,#03,#C0 ; #9970 ................
db #00,#03,#C0,#00,#07,#E0,#00,#07,#F0,#00,#07,#E0,#00,#07,#E0,#00 ; #9980 ................
db #0F,#F0,#00,#0F,#F8,#00,#1F,#FC,#00,#1F,#F0,#00,#0F,#EC,#00,#17 ; #9990 ................
db #D8,#00,#1B,#CC,#00,#33,#C6,#00,#63,#E1,#C3,#87,#F0,#3C,#0F,#F8 ; #99a0 .....3..c....<..
db #00,#1F,#FE,#00,#7F,#FF,#C3,#FF,#00,#00,#00,#00,#3C,#00,#00,#E7 ; #99b0 ............<...
db #00,#03,#81,#C0,#0E,#3C,#70,#38,#E7,#1C,#63,#81,#C6,#38,#E7,#1C ; #99c0 .....<p8..c..8..
db #4E,#3C,#72,#73,#81,#CE,#5C,#E7,#3A,#47,#3C,#E2,#36,#C3,#6C,#4E ; #99d0 N<rs..\.:G<.6.lN
db #24,#70,#73,#A5,#CC,#7C,#E7,#1E,#0F,#24,#E2,#00,#01,#FE,#00,#70 ; #99e0 $ps..|...$.....p
db #1E,#00,#60,#00,#00,#20,#00,#00,#60,#00,#00,#60,#00,#00,#00,#00 ; #99f0 ..`.. ..`..`....
db #FF,#C3,#FF,#FF,#3C,#FF,#FC,#E7,#3F,#F3,#81,#CF,#CE,#00,#73,#B8 ; #9a00 ....<...?.....s.
db #00,#1D,#60,#00,#06,#B8,#00,#1D,#0E,#00,#70,#03,#81,#C0,#00,#E7 ; #9a10 ..`.......p.....
db #00,#00,#3C,#00,#80,#00,#01,#40,#00,#03,#70,#00,#0D,#7C,#00,#1E ; #9a20 ..<....@..p..|..
db #8F,#00,#E2,#F0,#01,#FE,#FF,#76,#1E,#FF,#6F,#E1,#FF,#AF,#FF,#FF ; #9a30 .......v..o.....
db #6F,#FF,#FF,#6F,#FF,#FF,#9F,#FF,#00,#00,#00,#00,#3C,#00,#00,#E7 ; #9a40 o..o........<...
db #00,#03,#81,#C0,#0E,#3C,#70,#38,#E7,#1C,#63,#81,#C6,#38,#E7,#1C ; #9a50 .....<p8..c..8..
db #4E,#3C,#72,#73,#81,#CE,#5C,#E7,#3A,#47,#3C,#E2,#36,#C3,#6C,#0E ; #9a60 N<rs..\.:G<.6.l.
db #24,#70,#13,#A5,#C0,#0C,#E7,#00,#00,#25,#E0,#01,#C2,#70,#03,#B7 ; #9a70 $p.......%...p..
db #98,#07,#61,#E0,#06,#C0,#78,#01,#80,#18,#07,#00,#00,#00,#00,#00 ; #9a80 ..a...x.........
db #FF,#C3,#FF,#FF,#3C,#FF,#FC,#E7,#3F,#F3,#81,#CF,#CE,#00,#73,#B8 ; #9a90 ....<...?.....s.
db #00,#1D,#60,#00,#06,#B8,#00,#1D,#0E,#00,#70,#03,#81,#C0,#00,#E7 ; #9aa0 ..`.......p.....
db #00,#00,#3C,#00,#80,#00,#01,#C0,#00,#03,#D0,#00,#0F,#EC,#00,#1F ; #9ab0 ..<.............
db #F2,#01,#EF,#FD,#C2,#77,#FB,#B7,#9B,#F7,#69,#E7,#F6,#DE,#7B,#F9 ; #9ac0 .....w....i...{.
db #BF,#9B,#F7,#7F,#E7,#F8,#FF,#FF,#00,#00,#00,#00,#00,#00,#00,#7E ; #9ad0 ...............~
db #00,#03,#FF,#C0,#0F,#FF,#F0,#1F,#FF,#F8,#3F,#FF,#FC,#3F,#FF,#FC ; #9ae0 ..........?..?..
db #5F,#FF,#FA,#7F,#FF,#FE,#37,#FF,#EC,#7E,#FF,#7E,#47,#DB,#E2,#21 ; #9af0 _.....7..~.~G..!
db #FF,#84,#2C,#E7,#34,#57,#6A,#EA,#17,#B5,#E8,#4B,#42,#D2,#2A,#99 ; #9b00 ..,.4Wj....KB.*.
db #54,#15,#3C,#A8,#06,#7E,#60,#01,#81,#80,#00,#7E,#00,#00,#00,#00 ; #9b10 T.<..~`....~....
db #FF,#FF,#FF,#FF,#81,#FF,#FC,#7E,#3F,#F3,#FF,#CF,#EF,#FF,#F7,#DF ; #9b20 .......~?.......
db #FF,#FB,#BF,#FF,#FD,#BF,#FF,#FD,#5F,#FF,#FA,#7F,#FF,#FE,#B7,#FF ; #9b30 ........_.......
db #ED,#5E,#FF,#7E,#47,#DB,#E2,#A1,#FF,#85,#A0,#E7,#05,#10,#6A,#08 ; #9b40 .^.~G.........j.
db #90,#34,#09,#48,#42,#12,#A8,#81,#15,#D5,#00,#AB,#E6,#00,#67,#F9 ; #9b50 .4.HB.........g.
db #81,#9F,#FE,#7E,#7F,#FF,#81,#FF,#00,#00,#00,#00,#7E,#00,#03,#FF ; #9b60 ...~........~...
db #C0,#0F,#FF,#F0,#1F,#FF,#F8,#3F,#FF,#FC,#3F,#FF,#FC,#3F,#FF,#FC ; #9b70 .......?..?..?..
db #5F,#FF,#FA,#4F,#FF,#F2,#33,#FF,#CC,#54,#7E,#2A,#8D,#81,#B1,#81 ; #9b80 _..O..3..T~*....
db #BD,#81,#98,#3C,#11,#AA,#80,#A9,#51,#55,#52,#5A,#AA,#A2,#28,#55 ; #9b90 ...<....QURZ..(U
db #04,#12,#00,#48,#0C,#54,#30,#03,#81,#C0,#00,#7E,#00,#00,#00,#00 ; #9ba0 ...H.T0....~....
db #FF,#81,#FF,#FC,#7E,#3F,#F3,#FF,#CF,#EF,#FF,#F7,#DF,#FF,#FB,#BF ; #9bb0 ....~?..........
db #FF,#FD,#BF,#FF,#FD,#BF,#FF,#FD,#5F,#FF,#FA,#4F,#FF,#F2,#B3,#FF ; #9bc0 ........_..O....
db #CD,#D4,#7E,#2B,#AD,#81,#B5,#A1,#BD,#8D,#98,#3C,#05,#88,#00,#01 ; #9bd0 ..~+.......<....
db #D0,#00,#03,#D8,#00,#03,#E8,#00,#07,#F2,#00,#0F,#FC,#00,#3F,#FF ; #9be0 ..............?.
db #81,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#7E,#00,#03,#BD ; #9bf0 ............~...
db #C0,#0F,#81,#F0,#14,#7E,#28,#3B,#7E,#DC,#3B,#00,#DC,#14,#00,#28 ; #9c00 .....~(;~.;....(
db #2F,#81,#F4,#23,#7E,#C4,#2C,#7E,#34,#0F,#00,#F0,#2F,#7E,#F4,#33 ; #9c10 /..#~.,~4.../~.3
db #7E,#CC,#38,#7E,#1C,#1B,#00,#D8,#2B,#E7,#D4,#23,#E7,#C4,#2C,#E7 ; #9c20 ~.8~....+..#..,.
db #34,#0F,#00,#F0,#0F,#7E,#F0,#03,#7E,#C0,#00,#7E,#00,#00,#00,#00 ; #9c30 4....~..~..~....
db #FF,#81,#FF,#FC,#7E,#3F,#F3,#BD,#CF,#EF,#81,#F7,#D4,#00,#2B,#B8 ; #9c40 ....~?........+.
db #00,#1D,#B8,#00,#1D,#94,#00,#29,#8F,#81,#F1,#83,#7E,#C1,#80,#7E ; #9c50 .......)....~..~
db #01,#C0,#00,#03,#80,#00,#01,#80,#00,#01,#80,#00,#01,#C0,#00,#03 ; #9c60 ................
db #80,#00,#01,#80,#00,#01,#80,#00,#01,#C0,#00,#03,#E0,#00,#07,#F0 ; #9c70 ................
db #00,#0F,#FC,#00,#3F,#FF,#81,#FF,#00,#7E,#00,#03,#81,#C0,#0C,#00 ; #9c80 ....?....~......
db #30,#10,#00,#08,#20,#00,#04,#20,#00,#04,#40,#00,#02,#50,#00,#0A ; #9c90 0... .. ..@..P..
db #40,#00,#02,#40,#00,#02,#22,#00,#44,#21,#81,#84,#10,#7E,#08,#0C ; #9ca0 @..@..".D!...~..
db #00,#30,#03,#81,#C0,#04,#7E,#20,#1A,#00,#58,#3A,#00,#5C,#1D,#81 ; #9cb0 .0....~ ..X:.\..
db #B8,#06,#7E,#60,#01,#81,#80,#00,#7E,#00,#00,#18,#00,#00,#00,#00 ; #9cc0 ..~`....~.......
db #FF,#81,#FF,#FC,#00,#3F,#F0,#00,#0F,#E0,#00,#07,#C0,#00,#03,#C0 ; #9cd0 .....?..........
db #00,#03,#80,#00,#01,#80,#00,#01,#80,#00,#01,#80,#00,#01,#C0,#00 ; #9ce0 ................
db #03,#C0,#00,#03,#E0,#00,#07,#F0,#00,#0F,#F8,#00,#1F,#E4,#00,#27 ; #9cf0 ...............''
db #D8,#00,#1B,#B8,#00,#1D,#DC,#00,#3B,#E6,#00,#67,#F9,#81,#9F,#FE ; #9d00 ........;..g....
db #7E,#7F,#FF,#99,#FF,#FF,#E7,#FF,#00,#00,#00,#00,#3C,#00,#00,#C3 ; #9d10 ~...........<...
db #00,#01,#00,#80,#0F,#00,#F0,#30,#DB,#0C,#40,#24,#02,#40,#DB,#02 ; #9d20 .......0..@$.@..
db #71,#00,#8E,#3E,#00,#7C,#3D,#00,#BC,#4D,#81,#B2,#71,#E7,#8E,#5C ; #9d30 q..>.|=..M..q..\
db #FF,#3A,#37,#3C,#EC,#4D,#C3,#B2,#73,#7E,#CE,#7C,#DB,#3E,#3D,#3C ; #9d40 .:7<.M..s~.|.>=<
db #BC,#05,#C3,#A0,#01,#FF,#80,#00,#FF,#00,#00,#18,#00,#00,#00,#00 ; #9d50 ................
db #FF,#FF,#FF,#FF,#C3,#FF,#FF,#00,#FF,#FE,#00,#7F,#F0,#00,#0F,#C0 ; #9d60 ................
db #18,#03,#00,#24,#00,#00,#18,#00,#00,#00,#00,#80,#00,#01,#80,#00 ; #9d70 ...$............
db #01,#40,#00,#02,#70,#00,#0E,#5C,#00,#3A,#B7,#00,#ED,#0D,#C3,#B0 ; #9d80 .@..p..\.:......
db #03,#7E,#C0,#00,#DB,#00,#80,#3C,#01,#C0,#00,#03,#F8,#00,#1F,#FE ; #9d90 .~.....<........
db #00,#7F,#FF,#00,#FF,#FF,#E7,#FF,#00,#00,#00,#00,#18,#00,#00,#66 ; #9da0 ...............f
db #00,#01,#89,#80,#06,#54,#60,#18,#AA,#98,#35,#55,#4C,#32,#AA,#AC ; #9db0 .....T`...5UL2..
db #39,#55,#1C,#5E,#2A,#7A,#67,#91,#E6,#79,#E7,#9E,#1E,#7E,#78,#67 ; #9dc0 9U.^*zg..y...~xg
db #99,#E6,#79,#E7,#9E,#1E,#7E,#78,#27,#99,#E4,#39,#E7,#9C,#1E,#7E ; #9dd0 ..y...~x''..9...~
db #78,#07,#99,#E0,#01,#E7,#80,#00,#7E,#00,#00,#18,#00,#00,#00,#00 ; #9de0 x.......~.......
db #FF,#E7,#FF,#FF,#81,#FF,#FE,#00,#7F,#F8,#08,#1F,#E0,#54,#07,#C0 ; #9df0 .............T..
db #AA,#83,#85,#55,#41,#82,#AA,#A1,#81,#55,#01,#40,#2A,#02,#60,#10 ; #9e00 ...UA....U.@*.`.
db #06,#78,#00,#1E,#9E,#00,#79,#67,#81,#E6,#79,#E7,#9E,#9E,#7E,#79 ; #9e10 .x....yg..y...~y
db #87,#99,#E1,#81,#E7,#81,#C0,#7E,#03,#E0,#18,#07,#F8,#00,#1F,#FE ; #9e20 .......~........
db #00,#7F,#FF,#81,#FF,#FF,#E7,#FF,#00,#00,#00,#00,#7E,#00,#01,#FF ; #9e30 ............~...
db #80,#07,#FF,#E0,#0F,#FF,#F0,#1D,#FF,#F8,#1B,#FF,#F8,#33,#FF,#FC ; #9e40 .............3..
db #37,#FF,#FC,#77,#FF,#FE,#7F,#FF,#FE,#77,#FF,#FE,#7F,#FF,#FE,#7F ; #9e50 7..w.....w......
db #FF,#FE,#7F,#FF,#FE,#3F,#FF,#FC,#3F,#FF,#FC,#1F,#FF,#F8,#1F,#FF ; #9e60 .....?..?.......
db #F8,#0F,#FF,#F0,#07,#FF,#E0,#01,#FF,#80,#00,#7E,#00,#00,#00,#00 ; #9e70 ...........~....
db #FF,#81,#FF,#FE,#00,#7F,#F8,#00,#1F,#F0,#00,#0F,#E0,#00,#07,#C0 ; #9e80 ................
db #00,#03,#C0,#00,#03,#80,#00,#01,#80,#00,#01,#00,#00,#00,#00,#00 ; #9e90 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#80,#00,#01 ; #9ea0 ................
db #80,#00,#01,#C0,#00,#03,#C0,#00,#03,#E0,#00,#07,#F0,#00,#0F,#F8 ; #9eb0 ................
db #00,#1F,#FE,#00,#7F,#FF,#81,#FF,#00,#00,#00,#00,#1F,#00,#00,#7F ; #9ec0 ................
db #C0,#00,#FF,#E0,#01,#FF,#20,#01,#F9,#F0,#03,#F7,#F0,#03,#FF,#BC ; #9ed0 ...... .........
db #03,#FD,#A2,#25,#FD,#C1,#1D,#FF,#C1,#0B,#FF,#81,#17,#9F,#41,#37 ; #9ee0 ...%..........A7
db #3F,#02,#67,#BF,#02,#1B,#9B,#CE,#0D,#6C,#3C,#0A,#F6,#60,#10,#B7 ; #9ef0 ?.g......l<..`..
db #80,#00,#60,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #9f00 ..`.............
db #FF,#E0,#FF,#FF,#9F,#3F,#FF,#7F,#DF,#FE,#FF,#EF,#FD,#FF,#2F,#FD ; #9f10 .....?......../.
db #F9,#F7,#FB,#F7,#F7,#FB,#FF,#BF,#DB,#FD,#A3,#81,#FD,#C1,#C1,#FF ; #9f20 ................
db #C1,#E3,#FF,#81,#C7,#9F,#41,#87,#3F,#03,#07,#BF,#02,#83,#9B,#CC ; #9f30 ......A.?.......
db #E1,#0C,#31,#E0,#06,#63,#C4,#07,#9F,#EF,#08,#7F,#FF,#9F,#FF,#FF ; #9f40 ..1..c..........
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#03,#C0,#00 ; #9f50 ................
db #00,#0E,#70,#00,#00,#38,#1C,#00,#00,#E7,#C7,#00,#03,#9F,#F7,#80 ; #9f60 ..p..8..........
db #0E,#7F,#FC,#00,#38,#FF,#FB,#80,#38,#FF,#C1,#00,#4E,#7F,#BB,#80 ; #9f70 ....8...8...N...
db #73,#9C,#11,#00,#4C,#FB,#BB,#80,#53,#01,#10,#00,#4C,#BB,#B8,#00 ; #9f80 s...L...S...L...
db #32,#91,#00,#00,#0C,#BB,#80,#00,#03,#90,#00,#00,#00,#B8,#00,#00 ; #9f90 2...............
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #9fa0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00 ; #9fb0 ................
db #00,#00,#00,#00,#00,#00,#00,#00,#FF,#FC,#3F,#FF,#FF,#F0,#0F,#FF ; #9fc0 ..........?.....
db #FF,#C0,#03,#FF,#FF,#00,#00,#FF,#FC,#00,#00,#3F,#F0,#00,#00,#3F ; #9fd0 ...........?...?
db #C0,#00,#00,#3F,#80,#00,#03,#BF,#00,#00,#01,#3F,#00,#00,#3B,#BF ; #9fe0 ...?.......?..;.
db #00,#00,#11,#3F,#00,#03,#BB,#BF,#10,#01,#10,#7F,#0C,#3B,#BB,#FF ; #9ff0 ...?.........;..
db #02,#11,#07,#FF,#C0,#3B,#BF,#FF,#F0,#10,#7F,#FF,#FC,#3B,#FF,#FF ; #a000 .....;.......;..
db #FF,#07,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #a010 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF ; #a020 ................
db #FF,#FF,#FF,#FF,#FF,#FF,#FF,#FF,#00,#00,#00,#00,#00,#07,#80,#00 ; #a030 ................
db #00,#1F,#C0,#00,#00,#7F,#B8,#00,#01,#FD,#FF,#00,#07,#FF,#FF,#C0 ; #a040 ................
db #1F,#DF,#FF,#F0,#3F,#FF,#FF,#FC,#4F,#7F,#FF,#F2,#73,#FF,#FF,#CE ; #a050 ....?...O...s...
db #7C,#FF,#FF,#3E,#3B,#3F,#FC,#FC,#0B,#CF,#F3,#F0,#31,#F3,#CF,#CC ; #a060 |..>;?......1...
db #0E,#FC,#3F,#30,#11,#3F,#FC,#C8,#2E,#4F,#F3,#34,#47,#92,#CC,#E2 ; #a070 ..?0.?...O.4G...
db #77,#EC,#33,#EE,#77,#F3,#CF,#EE,#37,#81,#81,#EC,#0B,#4C,#32,#D0 ; #a080 w.3.w...7....L2.
db #02,#F3,#CF,#40,#00,#FC,#3F,#00,#00,#3F,#FC,#00,#00,#0F,#F0,#00 ; #a090 ...@..?..?......
db #00,#02,#C0,#00,#00,#00,#00,#00,#FF,#F8,#7F,#FF,#FF,#E7,#BF,#FF ; #a0a0 ................
db #FF,#9F,#C7,#FF,#FE,#7F,#B8,#FF,#F9,#FD,#FF,#3F,#E7,#FF,#FF,#CF ; #a0b0 ...........?....
db #DF,#DF,#FF,#F3,#BF,#FF,#FF,#FD,#0F,#7F,#FF,#F0,#03,#FF,#FF,#C0 ; #a0c0 ................
db #00,#FF,#FF,#00,#80,#3F,#FC,#01,#C0,#0F,#F0,#03,#B0,#03,#C0,#0D ; #a0d0 .....?..........
db #CE,#00,#00,#33,#D1,#00,#00,#CB,#A4,#40,#03,#25,#02,#90,#0C,#40 ; #a0e0 ...3.....@.%...@
db #05,#4C,#32,#A0,#02,#A3,#C5,#40,#85,#01,#80,#A1,#C2,#0C,#30,#43 ; #a0f0 .L2....@......0C
db #F0,#03,#C0,#0F,#FC,#00,#00,#3F,#FF,#00,#00,#FF,#FF,#C0,#03,#FF ; #a100 .......?........
db #FF,#F0,#0F,#FF,#FF,#FD,#3F,#FF,#00,#00,#00,#00,#00,#01,#80,#00 ; #a110 ......?.........
db #00,#06,#C0,#00,#00,#19,#E0,#00,#00,#67,#CC,#00,#01,#9F,#36,#00 ; #a120 .........g....6.
db #06,#7C,#CF,#00,#19,#F3,#3E,#70,#3D,#CC,#F9,#98,#26,#33,#E6,#7C ; #a130 .|....>p=...&3.|
db #1A,#CF,#99,#FC,#35,#EE,#67,#FC,#35,#31,#9F,#FA,#32,#D6,#7F,#E2 ; #a140 ....5.g.51..2...
db #35,#AF,#7F,#8A,#31,#A9,#BE,#3A,#35,#96,#B8,#FA,#31,#AD,#A3,#FA ; #a150 5...1..:5...1...
db #35,#8D,#4F,#FA,#31,#AC,#BF,#F8,#19,#8D,#BF,#F8,#01,#AC,#BF,#F0 ; #a160 5.O.1...........
db #01,#8D,#BF,#C0,#00,#CC,#BF,#00,#00,#0D,#BC,#00,#00,#0C,#B0,#00 ; #a170 ................
db #00,#06,#40,#00,#00,#00,#00,#00,#FF,#FE,#7F,#FF,#FF,#F9,#BF,#FF ; #a180 ..@.............
db #FF,#E6,#DF,#FF,#FF,#99,#E3,#FF,#FE,#67,#CD,#FF,#F9,#9F,#36,#FF ; #a190 .........g....6.
db #E6,#7C,#CF,#0F,#D9,#F3,#3E,#77,#BD,#CC,#F9,#9B,#A6,#33,#E6,#7D ; #a1a0 .|....>w.....3.}
db #C2,#CF,#99,#FD,#85,#EE,#67,#FD,#85,#31,#9F,#F8,#80,#16,#7F,#E0 ; #a1b0 ......g..1......
db #80,#2F,#7F,#80,#80,#29,#BE,#00,#80,#00,#B8,#00,#80,#01,#A0,#00 ; #a1c0 ./...)..........
db #80,#01,#40,#00,#80,#00,#00,#01,#C0,#00,#00,#03,#E4,#00,#00,#07 ; #a1d0 ..@.............
db #FC,#00,#00,#0F,#FE,#00,#00,#3F,#FF,#20,#00,#FF,#FF,#E0,#03,#FF ; #a1e0 .......?. ......
db #FF,#F0,#0F,#FF,#FF,#F9,#BF,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #a1f0 ................
db #00,#03,#C0,#00,#00,#1C,#38,#00,#00,#62,#46,#00,#01,#9E,#29,#80 ; #a200 ......8..bF...).
db #03,#7E,#54,#C0,#06,#FC,#2A,#60,#0C,#01,#80,#30,#15,#54,#3F,#A8 ; #a210 .~T...*`...0.T?.
db #26,#AA,#7F,#64,#33,#54,#7E,#CC,#5D,#8A,#79,#BA,#5E,#60,#46,#7A ; #a220 &..d3T~.].y.^`Fz
db #6F,#9C,#39,#F6,#6F,#E3,#C7,#F6,#77,#F8,#1F,#EE,#77,#FD,#BF,#EE ; #a230 o.9.o...w...w...
db #78,#01,#80,#1E,#7A,#A9,#95,#5E,#39,#55,#AA,#9C,#0E,#A9,#95,#70 ; #a240 x...z..^9U.....p
db #03,#55,#AA,#C0,#00,#E9,#97,#00,#00,#35,#AC,#00,#00,#0D,#B0,#00 ; #a250 .U.......5......
db #00,#03,#C0,#00,#00,#00,#00,#00,#FF,#FF,#FF,#FF,#FF,#FC,#3F,#FF ; #a260 ..............?.
db #FF,#E0,#07,#FF,#FF,#80,#01,#FF,#FE,#00,#40,#7F,#FC,#00,#28,#3F ; #a270 ..........@...(?
db #F8,#00,#54,#1F,#F0,#00,#2A,#0F,#E0,#01,#80,#07,#C1,#54,#00,#03 ; #a280 ..T...*......T..
db #A0,#AA,#00,#05,#B0,#54,#00,#0D,#5C,#0A,#00,#3A,#5E,#00,#00,#7A ; #a290 .....T..\..:^..z
db #6F,#80,#01,#F6,#6F,#E0,#07,#F6,#77,#F8,#1F,#EE,#77,#FC,#3F,#EE ; #a2a0 o...o...w...w.?.
db #78,#00,#00,#1E,#7A,#A8,#15,#5E,#B9,#54,#2A,#9D,#CE,#A8,#15,#73 ; #a2b0 x...z..^.T*....s
db #F3,#54,#2A,#CF,#FC,#E8,#17,#3F,#FF,#34,#2C,#FF,#FF,#CC,#33,#FF ; #a2c0 .T*....?.4,...3.
db #FF,#F0,#0F,#FF,#FF,#FC,#3F,#FF,#00,#00,#00,#00,#00,#03,#C0,#00 ; #a2d0 ......?.........
db #00,#1C,#38,#00,#00,#61,#C6,#00,#01,#8A,#B9,#80,#03,#2A,#AE,#C0 ; #a2e0 ..8..a.......*..
db #06,#55,#56,#60,#0B,#2A,#AE,#D0,#12,#8A,#B9,#D8,#36,#E1,#47,#6C ; #a2f0 .UV`.*......6.Gl
db #2C,#DC,#3D,#74,#1D,#97,#E5,#B8,#5B,#76,#B6,#DA,#67,#64,#B3,#66 ; #a300 ,.=t....[v..gd.f
db #32,#ED,#9B,#8C,#5C,#D9,#DD,#3A,#27,#1B,#68,#E4,#69,#E3,#C7,#96 ; #a310 2...\..:''.h.i...
db #5C,#3C,#3C,#32,#5B,#47,#E2,#DA,#33,#68,#16,#CC,#0E,#6D,#76,#70 ; #a320 \<<2[G..3h...mvp
db #02,#CD,#BB,#40,#00,#D9,#BB,#00,#00,#33,#9C,#00,#00,#0E,#D0,#00 ; #a330 ...@.....3......
db #00,#02,#C0,#00,#00,#00,#00,#00,#FF,#FC,#3F,#FF,#FF,#E3,#C7,#FF ; #a340 ..........?.....
db #FF,#9C,#39,#FF,#FE,#60,#06,#7F,#FD,#80,#01,#BF,#FB,#00,#00,#DF ; #a350 ..9..`..........
db #F6,#00,#00,#6F,#EB,#00,#00,#D7,#D2,#80,#01,#DB,#B6,#E0,#07,#6D ; #a360 ...o...........m
db #AC,#DC,#3D,#75,#9D,#97,#E5,#B9,#1B,#76,#B6,#D8,#07,#64,#B3,#60 ; #a370 ..=u.....v...d.`
db #82,#ED,#9B,#81,#40,#D9,#DD,#02,#A0,#1B,#68,#05,#68,#03,#C0,#16 ; #a380 ....@.....h.h...
db #5C,#00,#00,#32,#5B,#40,#02,#DA,#B3,#68,#16,#CD,#CE,#6D,#76,#73 ; #a390 \..2[@...h...mvs
db #F2,#CD,#BB,#4F,#FC,#D9,#BB,#3F,#FF,#33,#9C,#FF,#FF,#CE,#D3,#FF ; #a3a0 ...O...?.3......
db #FF,#F2,#CF,#FF,#FF,#FD,#3F,#FF,#00,#00,#00,#00,#00,#03,#C0,#00 ; #a3b0 ......?.........
db #00,#0E,#70,#00,#00,#39,#9C,#00,#00,#E6,#67,#00,#03,#99,#99,#C0 ; #a3c0 ..p..9....g.....
db #0E,#67,#E6,#70,#39,#8C,#31,#9C,#39,#60,#06,#9C,#0E,#58,#1A,#70 ; #a3d0 .g.p9.1.9`...X.p
db #33,#96,#69,#CC,#1C,#E5,#A7,#38,#23,#39,#9C,#C4,#41,#CE,#73,#82 ; #a3e0 3.i....8#9..A.s.
db #7A,#33,#CC,#5E,#34,#1C,#38,#2C,#47,#A3,#C5,#E2,#7B,#41,#82,#DE ; #a3f0 z3.^4.8,G...{A..
db #34,#7A,#5E,#2C,#47,#B4,#2D,#E2,#33,#47,#E2,#CC,#0C,#7B,#DE,#30 ; #a400 4z^,G.-.3G...{.0
db #03,#34,#2C,#C0,#00,#C7,#E3,#00,#00,#33,#CC,#00,#00,#0C,#30,#00 ; #a410 .4,......3....0.
db #00,#03,#C0,#00,#00,#00,#00,#00,#FF,#FC,#3F,#FF,#FF,#F3,#CF,#FF ; #a420 ..........?.....
db #FF,#CE,#73,#FF,#FF,#38,#1C,#FF,#FC,#E0,#07,#3F,#F3,#80,#01,#CF ; #a430 ..s..8.....?....
db #CE,#00,#00,#73,#B8,#00,#00,#1D,#B8,#00,#00,#1D,#CE,#00,#00,#73 ; #a440 ...s...........s
db #83,#80,#01,#C1,#C0,#E0,#07,#03,#80,#38,#1C,#01,#00,#0E,#70,#00 ; #a450 .........8....p.
db #00,#03,#C0,#00,#80,#00,#00,#01,#40,#00,#00,#02,#78,#00,#00,#1E ; #a460 ........@...x...
db #B4,#00,#00,#2D,#07,#80,#01,#E0,#83,#40,#02,#C1,#C0,#78,#1E,#03 ; #a470 ...-.....@...x..
db #F0,#34,#2C,#0F,#FC,#07,#E0,#3F,#FF,#03,#C0,#FF,#FF,#C0,#03,#FF ; #a480 .4,....?........
db #FF,#F0,#0F,#FF,#FF,#FC,#3F,#FF,#00,#00,#00,#00,#00,#03,#C0,#00 ; #a490 ......?.........
db #00,#0C,#30,#00,#00,#33,#CC,#00,#00,#CC,#33,#00,#03,#33,#CC,#C0 ; #a4a0 ..0..3....3..3..
db #0C,#CC,#33,#30,#33,#33,#CC,#CC,#33,#33,#CC,#CC,#1C,#CC,#33,#38 ; #a4b0 ..3033..33....38
db #07,#33,#CC,#E0,#03,#CC,#33,#80,#03,#F3,#CE,#40,#0B,#FC,#39,#B0 ; #a4c0 .3....3....@..9.
db #37,#F7,#E7,#CC,#5F,#F0,#01,#9A,#67,#F0,#00,#66,#59,#F8,#01,#9A ; #a4d0 7..._...g..fY...
db #56,#78,#06,#6A,#55,#9E,#19,#AA,#35,#67,#E6,#AC,#0D,#59,#9A,#B0 ; #a4e0 Vx.jU...5g...Y..
db #03,#56,#6A,#C0,#00,#D5,#AB,#00,#00,#35,#AC,#00,#00,#0D,#B0,#00 ; #a4f0 .Vj......5......
db #00,#03,#C0,#00,#00,#00,#00,#00,#FF,#FC,#3F,#FF,#FF,#F3,#CF,#FF ; #a500 ..........?.....
db #FF,#CC,#33,#FF,#FF,#30,#0C,#FF,#FC,#C0,#03,#3F,#F3,#03,#C0,#CF ; #a510 ..3..0.....?....
db #CC,#0C,#30,#33,#B0,#30,#0C,#0D,#B0,#30,#0C,#0D,#DC,#0C,#30,#3B ; #a520 ..03.0...0....0;
db #E7,#03,#C0,#E7,#FB,#C0,#03,#9F,#F3,#F0,#0E,#4F,#CB,#FC,#39,#B3 ; #a530 ...........O..9.
db #B7,#F7,#E7,#CD,#1F,#F0,#19,#98,#07,#F7,#FE,#60,#01,#FB,#F9,#80 ; #a540 ...........`....
db #00,#79,#E6,#00,#00,#1E,#18,#00,#80,#07,#E0,#01,#C0,#01,#80,#03 ; #a550 .y..............
db #F0,#00,#00,#0F,#FC,#00,#00,#3F,#FF,#00,#00,#FF,#FF,#C0,#03,#FF ; #a560 .......?........
db #FF,#F0,#0F,#FF,#FF,#FC,#3F,#FF,#00,#00,#00,#00,#00,#00,#00,#00 ; #a570 ......?.........
db #00,#08,#10,#00,#00,#08,#10,#00,#00,#8C,#31,#00,#00,#9C,#39,#00 ; #a580 ..........1...9.
db #08,#DD,#BB,#10,#09,#DE,#7B,#90,#09,#DE,#7B,#90,#15,#EE,#77,#A8 ; #a590 ......{...{...w.
db #15,#AE,#75,#A8,#0D,#4E,#72,#B0,#2E,#48,#12,#74,#6E,#C4,#23,#76 ; #a5a0 ..u..Nr..H.tn.#v
db #32,#E4,#27,#4C,#0C,#EC,#37,#30,#13,#2E,#74,#C8,#1C,#CE,#73,#38 ; #a5b0 2.''L..70..t...s8
db #5D,#32,#4C,#BA,#6D,#CC,#33,#B6,#31,#D3,#CB,#8C,#0E,#DC,#3B,#70 ; #a5c0 ]2L.m.3.1.....;p
db #03,#1E,#78,#C0,#00,#EC,#37,#00,#00,#32,#4C,#00,#00,#0F,#F0,#00 ; #a5d0 ..x...7..2L.....
db #00,#03,#C0,#00,#00,#00,#00,#00,#FF,#FF,#FF,#FF,#FF,#F7,#EF,#FF ; #a5e0 ................
db #FF,#EB,#D7,#FF,#FF,#6B,#D6,#FF,#FE,#AD,#B5,#7F,#F6,#9C,#39,#6F ; #a5f0 .....k........9o
db #EA,#DC,#3B,#57,#E9,#DE,#7B,#97,#E9,#DE,#7B,#97,#D5,#EE,#77,#AB ; #a600 ..;W..{...{...w.
db #D5,#AE,#75,#AB,#CD,#4E,#72,#B3,#8E,#48,#12,#71,#0E,#C4,#23,#70 ; #a610 ..u..Nr..H.q..#p
db #82,#E4,#27,#41,#C0,#EC,#37,#03,#D0,#2E,#74,#0B,#9C,#0E,#70,#39 ; #a620 ..''A..7...t...p9
db #1D,#02,#40,#B8,#0D,#C0,#03,#B0,#81,#D0,#0B,#81,#C0,#DC,#3B,#03 ; #a630 ..@...........;.
db #F0,#1E,#78,#0F,#FC,#0C,#30,#3F,#FF,#00,#00,#FF,#FF,#C0,#03,#FF ; #a640 ..x...0?........
db #FF,#F0,#0F,#FF,#FF,#FC,#3F,#FF,#00,#00,#00,#00,#00,#01,#C0,#00 ; #a650 ......?.........
db #00,#07,#F0,#00,#00,#0F,#F8,#00,#00,#1F,#F7,#00,#00,#7C,#3F,#C0 ; #a660 .............|?.
db #01,#F0,#0F,#E0,#1C,#20,#07,#F4,#3F,#C0,#07,#F6,#63,#F8,#0F,#78 ; #a670 ..... ..?...c..x
db #6F,#FE,#3E,#F8,#1E,#7F,#7E,#F8,#1B,#7F,#1E,#FC,#35,#E7,#EF,#7C ; #a680 o.>...~.....5..|
db #31,#F7,#F7,#3E,#3B,#DE,#7A,#4E,#3F,#AF,#79,#F6,#51,#8F,#B3,#FE ; #a690 1..>;.zN?.y.Q...
db #52,#DF,#8B,#FE,#58,#FF,#BD,#FC,#2B,#F6,#5D,#F8,#03,#F1,#FD,#70 ; #a6a0 R...X...+.]....p
db #00,#E7,#FD,#40,#00,#0F,#F8,#00,#00,#0B,#F0,#00,#00,#0A,#E0,#00 ; #a6b0 ...@............
db #00,#02,#80,#00,#00,#00,#00,#00,#FF,#FE,#3F,#FF,#FF,#F8,#0F,#FF ; #a6c0 ..........?.....
db #FF,#F0,#07,#FF,#FF,#E0,#00,#FF,#FF,#80,#00,#3F,#FE,#00,#00,#0F ; #a6d0 ...........?....
db #E0,#00,#00,#03,#C0,#00,#00,#05,#80,#00,#00,#06,#00,#00,#00,#01 ; #a6e0 ................
db #00,#00,#00,#03,#80,#00,#00,#03,#C0,#00,#00,#01,#84,#00,#00,#01 ; #a6f0 ................
db #80,#00,#00,#00,#80,#00,#00,#40,#80,#20,#01,#F0,#40,#00,#03,#F8 ; #a700 .......@. ..@...
db #42,#00,#03,#FC,#40,#00,#01,#FD,#A0,#00,#41,#FB,#D0,#01,#F1,#77
db #FC,#07,#F1,#4F,#FF,#0F,#FA,#BF,#FF,#EB,#F7,#FF,#FF,#EA,#EF,#FF
db #FF,#F2,#9F,#FF,#FF,#FD,#7F,#FF,#00,#00,#00,#00,#00,#03,#C0,#00
db #00,#0E,#70,#00,#00,#39,#9C,#00,#00,#E6,#67,#00,#03,#99,#99,#C0
db #0E,#67,#E6,#70,#1D,#9F,#F9,#BC,#1E,#67,#E6,#7E,#27,#99,#99,#F8
db #39,#E6,#67,#E0,#76,#79,#9F,#86,#75,#9E,#7E,#18,#6D,#E7,#F8,#66
db #6B,#D9,#E1,#98,#6B,#D6,#86,#66,#6B,#B7,#19,#98,#6B,#AE,#66,#66
db #2B,#AC,#99,#98,#2B,#AC,#66,#66,#0B,#AD,#99,#9C,#05,#AC,#66,#70
db #01,#AD,#99,#C0,#00,#AC,#67,#00,#00,#16,#9C,#00,#00,#07,#70,#00
db #00,#01,#C0,#00,#00,#00,#00,#00,#FF,#FC,#3F,#FF,#FF,#F0,#0F,#FF
db #FF,#C0,#03,#FF,#FF,#01,#80,#FF,#FC,#06,#60,#3F,#F0,#18,#18,#0F
db #E0,#60,#06,#03,#C1,#80,#01,#81,#C0,#60,#06,#00,#80,#18,#18,#01
db #80,#06,#60,#01,#06,#01,#80,#06,#04,#00,#00,#19,#0C,#00,#00,#66
db #08,#18,#01,#99,#08,#10,#06,#66,#08,#30,#19,#99,#08,#20,#66,#66 
db #88,#20,#99,#99,#88,#20,#66,#60,#C8,#21,#99,#81,#F4,#20,#66,#03 
db #F8,#21,#98,#0F,#FE,#20,#60,#3F,#FF,#10,#80,#FF,#FF,#E0,#03,#FF ; #a800 .!... `?........
db #FF,#F8,#0F,#FF,#FF,#FE,#3F,#FF,#00,#00,#00,#00,#00,#03,#80,#00
db #00,#0F,#E0,#00,#00,#3C,#78,#00,#00,#F9,#9E,#00,#03,#FC,#67,#80
db #0F,#1F,#19,#E0,#1E,#67,#C6,#78,#3F,#19,#F1,#BC,#1F,#C6,#7C,#7C
db #67,#F1,#9F,#FE,#79,#FC,#6F,#CE,#7E,#7F,#1F,#B6,#7F,#9F,#FF,#96
db #5F,#E7,#F3,#B6,#77,#F9,#6D,#96,#5D,#FE,#65,#96,#57,#7F,#6D,#86
db #65,#DF,#65,#9A,#39,#77,#65,#B2,#1E,#5D,#61,#CC,#07,#97,#66,#F0
db #01,#E5,#6C,#C0,#00,#79,#73,#00,#00,#1E,#BC,#00,#00,#07,#B0,#00
db #00,#01,#C0,#00,#00,#00,#00,#00,#FF,#FC,#7F,#FF,#FF,#F0,#1F,#FF
db #FF,#C0,#07,#FF,#FF,#00,#01,#FF,#FC,#01,#80,#7F,#F0,#00,#60,#1F
db #E0,#00,#18,#07,#C0,#60,#06,#03,#80,#18,#01,#81,#80,#06,#00,#01
db #60,#01,#80,#00,#78,#00,#60,#00,#7E,#00,#00,#00,#7F,#80,#00,#00
db #5F,#E0,#00,#00,#77,#F8,#00,#00,#5D,#FE,#00,#00,#57,#7F,#00,#00
db #65,#DF,#00,#18,#B9,#77,#00,#30,#DE,#5D,#00,#01,#E7,#97,#06,#03
db #F9,#E5,#0C,#0F,#FE,#79,#00,#3F,#FF,#9E,#80,#FF,#FF,#E7,#83,#FF
db #FF,#F9,#CF,#FF,#FF,#FE,#3F,#FF,#00,#00,#00,#00,#00,#02,#C0,#00
db #00,#0D,#30,#00,#00,#33,#CC,#00,#00,#CF,#F3,#00,#03,#3F,#FC,#C0 ; #a900 ..0..3.......?..
db #0C,#FF,#FF,#30,#33,#FF,#FF,#CC,#4F,#FF,#FF,#F2,#33,#FF,#FF,#CC
db #6C,#FF,#FF,#36,#2B,#3F,#FC,#D4,#4B,#4F,#F3,#52,#72,#B3,#CF,#CE
db #1C,#F4,#2D,#38,#67,#2D,#74,#E2,#31,#CB,#53,#94,#6A,#72,#CE,#56
db #4D,#9C,#39,#5A,#5B,#47,#E6,#AA,#33,#68,#12,#CC,#0E,#6A,#B6,#70
db #02,#DD,#B3,#40,#00,#D5,#9B,#00,#00,#39,#CC,#00,#00,#0B,#70,#00
db #00,#03,#40,#00,#00,#00,#00,#00,#FF,#FD,#3F,#FF,#FF,#F0,#0F,#FF
db #FF,#C0,#03,#FF,#FF,#01,#40,#FF,#FC,#0A,#A0,#3F,#F0,#15,#54,#0F
db #C0,#AA,#AA,#03,#81,#55,#55,#41,#0A,#AA,#AA,#A0,#81,#55,#55,#41
db #00,#AA,#AA,#00,#80,#15,#54,#01,#40,#0A,#A0,#02,#70,#01,#40,#0E
db #9C,#00,#00,#39,#07,#00,#00,#E0,#81,#C0,#03,#81,#00,#70,#0E,#00
db #00,#1C,#38,#00,#00,#07,#E0,#00,#80,#00,#00,#01,#C0,#00,#00,#03
db #F0,#00,#00,#0F,#FC,#00,#00,#3F,#FF,#00,#00,#FF,#FF,#C0,#03,#FF
db #FF,#F0,#0F,#FF,#FF,#FC,#3F,#FF,#30,#00,#C4,#00,#2D,#00,#0B,#40
db #02,#D0,#00,#B8,#00,#23,#00,#0C,#00,#0C,#00,#23,#00,#B4,#02,#D0
db #0B,#40,#1D,#00,#C4,#00,#30,#00,#30,#00,#C4,#00,#2D,#00,#0B,#40
db #02,#D0,#00,#B8,#00,#23,#00,#0C,#E0,#03,#78,#0C,#1E,#10,#07,#80 ; #aa00 .....#....x.....
db #01,#E0,#08,#78,#30,#1E,#C0,#07,#C0,#07,#30,#1E,#08,#78,#01,#E0
db #07,#80,#1E,#10,#78,#0C,#E0,#03,#E0,#03,#78,#0C,#1E,#10,#07,#80
db #01,#E0,#08,#78,#30,#1E,#C0,#07,#07,#FC,#03,#F3,#01,#CF,#F0,#7F
db #FE,#0F,#F3,#80,#CF,#C0,#3F,#E0,#3F,#E0,#CF,#C0,#F3,#80,#FE,#0F
db #F0,#7F,#01,#CF,#03,#F3,#07,#FC,#07,#FC,#03,#F3,#01,#CF,#F0,#7F
db #FE,#0F,#F3,#80,#CF,#C0,#3F,#E0,#07,#00,#03,#80,#01,#C0,#F0,#78
db #1E,#0F,#03,#80,#01,#C0,#00,#E0,#00,#E0,#01,#C0,#03,#80,#1E,#0F 
db #F0,#78,#01,#C0,#03,#80,#07,#00,#07,#00,#03,#80,#01,#C0,#F0,#78 
db #1E,#0F,#03,#80,#01,#C0,#00,#E0,#E0,#70,#78,#1C,#1E,#07,#07,#81 
db #81,#E0,#E0,#78,#38,#1E,#0E,#07,#0E,#07,#38,#1E,#E0,#78,#81,#E0 
db #07,#81,#1E,#07,#78,#1C,#E0,#70,#E0,#70,#78,#1C,#1E,#07,#07,#81 
db #81,#E0,#E0,#78,#38,#1E,#0E,#07,#00,#00,#41,#02,#00,#00,#00,#00 
db #00,#81,#20,#08,#02,#00,#00,#00,#10,#00,#00,#00,#00,#10,#42,#00 
db #00,#02,#00,#00,#00,#10,#48,#00,#00,#00,#04,#01,#00,#00,#00,#80 
db #20,#00,#00,#08,#00,#00,#21,#04,#C4,#00,#3C,#00,#0E,#00,#03,#10 
db #00,#F0,#00,#38,#00,#0C,#00,#03,#00,#23,#00,#3C,#00,#70,#08,#C0 ; #ab00 ...8.....#.<.p..
db #0F,#00,#1C,#00,#30,#00,#C0,#00,#C4,#00,#3C,#00,#0E,#00,#03,#10
db #00,#F0,#00,#38,#00,#0C,#00,#03,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
db #88,#CC,#EE,#77,#77,#EE,#CC,#88,#88,#CC,#EE,#77,#77,#EE,#CC,#88
db #4E,#67,#73,#01,#4E,#67,#73,#01,#72,#E6,#CE,#80,#72,#E6,#CE,#80
db #C0,#70,#3C,#18,#3C,#0E,#03,#00,#06,#03,#3B,#66,#3D,#42,#3C,#00
db #FE,#EE,#C6,#6C,#6C,#38,#10,#00,#00,#00,#00,#00,#38,#38,#18,#30
db #00,#00,#7E,#7E,#7E,#7E,#00,#00,#00,#00,#00,#00,#00,#38,#38,#38
db #3E,#3E,#7E,#7E,#FC,#FC,#F8,#F8,#7C,#FE,#FE,#EE,#EE,#FE,#FE,#7C
db #7C,#FC,#7C,#7C,#7C,#FE,#FE,#FE,#FE,#FE,#BE,#7C,#F8,#FE,#FE,#FE
db #FE,#FE,#3E,#FE,#FE,#3E,#FE,#FE,#E0,#EC,#EC,#EC,#FE,#FE,#FE,#0C
db #FE,#FE,#F8,#FE,#FE,#1E,#FE,#FC,#FE,#FE,#F8,#FE,#FE,#EE,#FE,#FE
db #FE,#FE,#1C,#3C,#78,#78,#F0,#F0,#FE,#FE,#EE,#7C,#FE,#EE,#FE,#FE
db #FE,#FE,#EE,#FE,#FE,#1E,#FE,#FE,#00,#38,#38,#38,#00,#38,#38,#38 ; #ac00 .........888.888
db #38,#38,#38,#00,#38,#38,#18,#30,#00,#FE,#C6,#BA,#AA,#BE,#C0,#FC
db #FE,#FE,#EE,#FE,#FE,#FE,#EE,#EE,#FE,#F6,#FE,#FC,#FE,#F6,#F6,#FE
db #FE,#FE,#FE,#F8,#F8,#FE,#FE,#FE,#FC,#FE,#FE,#EE,#EE,#FE,#FE,#FC
db #FE,#FE,#F8,#FC,#FC,#F8,#FE,#FE,#FE,#FE,#F8,#FC,#FC,#F8,#F8,#F8
db #FE,#FE,#FE,#F0,#F6,#FE,#FE,#FE,#EE,#EE,#FE,#FE,#FE,#FE,#EE,#EE
db #FE,#FE,#7C,#7C,#7C,#7C,#FE,#FE,#1E,#1E,#1E,#1E,#DE,#DE,#FE,#FE
db #E6,#EE,#FE,#FC,#FC,#FE,#EE,#E6,#F8,#F8,#F8,#F8,#F8,#FE,#FE,#FE
db #EE,#FE,#FE,#FE,#FE,#FE,#D6,#C6,#F6,#F6,#FE,#FE,#FE,#FE,#DE,#DE
db #FE,#FE,#FE,#EE,#EE,#FE,#FE,#FE,#FE,#FE,#EE,#FE,#FE,#F8,#F8,#F8
db #FC,#FC,#FC,#EC,#EC,#FC,#FE,#FE,#FE,#FE,#EE,#FE,#FC,#FE,#FE,#EE
db #FE,#FE,#F8,#FE,#FE,#3E,#FE,#FE,#FE,#FE,#FE,#7C,#7C,#7C,#7C,#7C
db #EE,#EE,#EE,#EE,#FE,#FE,#FE,#FE,#EE,#EE,#EE,#EE,#FE,#FE,#7C,#7C
db #C6,#D6,#FE,#FE,#FE,#FE,#FE,#EE,#EE,#FE,#FE,#7C,#7C,#FE,#FE,#EE
db #EE,#EE,#FE,#FE,#7C,#7C,#7C,#7C,#FE,#FE,#FE,#3C,#78,#FE,#FE,#FE
db #FE,#FE,#F8,#F8,#F8,#F8,#FE,#FE,#F8,#F8,#FC,#FC,#7E,#7E,#3E,#3E
db #FE,#FE,#3E,#3E,#3E,#3E,#FE,#FE,#10,#38,#7C,#FE,#7C,#7C,#7C,#7C
db #7C,#7C,#7C,#7C,#FE,#7C,#38,#10,#00,#10,#F8,#FC,#FE,#FC,#F8,#10
db #00,#10,#3E,#7E,#FE,#7E,#3E,#10,#00,#00,#00,#03,#00,#00,#00,#03
db #00,#00,#00,#3C,#00,#00,#00,#CF,#00,#01,#00,#F3,#00,#0E,#00,#7C
db #00,#3F,#00,#9F,#00,#FF,#00,#3C,#00,#FC,#03,#F3,#00,#F3,#0F,#CF
db #00,#CF,#3E,#3E,#00,#3C,#F8,#F8,#03,#F3,#E4,#E0,#0F,#CF,#9C,#80
db #3E,#3E,#78,#00,#79,#78,#F8,#00,#67,#60,#F0,#00,#07,#00,#C0,#08
db #00,#78,#00,#3C,#00,#1F,#00,#F0,#20,#07,#08,#C0,#38,#00,#38,#00
db #5F,#40,#F4,#04,#4C,#40,#64,#04,#73,#73,#9C,#9C,#1E,#1E,#F0,#F0
db #23,#03,#88,#80,#3C,#00,#78,#00,#1F,#00,#F0,#00,#07,#20,#C0,#08
db #00,#78,#00,#3C,#00,#7F,#00,#FC,#00,#3F,#00,#F8,#00,#0F,#00,#E0
db #00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00,#00
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

-- Project 110: generated_labels by Unknown
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'generated_labels',
    'Imported from z80Code. Author: Unknown. Example of generated labels',
    'public',
    false,
    false,
    '2019-11-13T16:46:54.881000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Exemples de labels générés dans des blocs macro et repeat

macro test id
 module{id}
 repeat 4,v
 .label{v}:
 nop
 rend
mend

test 1
test 2
test 3
test 4

print module1.label1
print module3.label2
fail
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
