-- Migration: Import z80code projects batch 58
-- Projects 115 to 116
-- Generated: 2026-01-25T21:43:30.200768

-- Project 115: fux_line&plot by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'fux_line&plot',
    'Imported from z80Code. Author: tronic. ...',
    'public',
    false,
    false,
    '2021-02-06T02:28:23.445000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; some plots & lines (still buggy -pas tous les octants- à finir, un jour...) - Tronic/GPA
; l''origine (0,0) est en haut à gauche (&c000)
; 
; macro : 
; miniplot x1,y1
;
; macros : 
; plotpen1 x,y
; plotpen2 x,y
; plotpen3 x,y
;
; macros :
; objetplotpen1 objet1_start,(objet1_end-objet1_start)/4
; objetplotpen2 objet1_start,(objet1_end-objet1_start)/4
; objetplotpen3 objet1_start,(objet1_end-objet1_start)/4
;
; macros (à debuguer...) :
; line x1,y1,x2,y2 (x1<x2 et y1<y2) (pen1)
; linepen2 (pas fait)
; linepen3 (pas fait)
; 
; algo line Basé sur :
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
;
; (aucune optimisation!)



BUILDSNA
BANKSET 0
SNASET CPC_TYPE,2
org #40
run start

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro WBRK
    db #ed, #ff
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro miniplot x1,y1
    ld de,{x1}*8+cheat_table_pen1
    ld l,{y1}
    ld ix,@next
    jp plotxy
    @next
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro plotpen1 ptx,pty
    ld hl,{ptx}
    add hl,hl
    add hl,hl
    add hl,hl   ; x8
    ld bc,cheat_table_pen1
    add hl,bc
    ex de,hl
    ld l,{pty}
    ld ix,@next
    jp plotxy
  	@next    
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro plotpen2 ptx,pty
    ld hl,{ptx}
    add hl,hl
    add hl,hl
    add hl,hl   ; x8
    ld bc,cheat_table_pen2
    add hl,bc
    ex de,hl
    ld l,{pty}
    ld ix,@next
    jp plotxy
  	@next    
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro plotpen3 ptx,pty
    ld hl,{ptx}
    add hl,hl
    ld b,h
    ld c,l
    add hl,hl
    add hl,hl   ; x8
    add hl,bc   ; x10
    ld bc,cheat_table_pen3
    add hl,bc
    ex de,hl
    ld l,{pty}
    ld ix,@next
    jp plotxy
  	@next    
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro objetplotpen1 tab, qty    ; pen1
	ld (stack),sp
    ld sp,{tab}
  	ld a,{qty}
   	@loop
    pop hl
    add hl,hl
    add hl,hl
    add hl,hl   ; x8
    ld bc,cheat_table_pen1
    add hl,bc
    ex de,hl
   	pop hl
   	ld ix,@next
   	jp plotxy
  	@next
    dec a
    jr nz,@loop
    ld sp,(stack)	        
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro objetplotpen2 tab, qty    ; pen2
	ld (stack),sp
    ld sp,{tab}
  	ld a,{qty}
   	@loop
    pop hl
    add hl,hl
    add hl,hl
    add hl,hl   ; x8
    ld bc,cheat_table_pen2
    add hl,bc
    ex de,hl
   	pop hl
   	ld ix,@next
   	jp plotxy
  	@next
    dec a
    jr nz,@loop
    ld sp,(stack)	        
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro objetplotpen3 tab, qty    ; pen3
	ld (stack),sp
    ld sp,{tab}
  	ld a,{qty}
   	@loop
    pop hl
    add hl,hl
    ld b,h
    ld c,l
    add hl,hl
    add hl,hl
    add hl,bc   ; x10
    ld bc,cheat_table_pen3
    add hl,bc
    ex de,hl
   	pop hl
   	ld ix,@next
   	jp plotxy
  	@next
    dec a
    jr nz,@loop
    ld sp,(stack)	        
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro line valx1,valy1,valx2,valy2  ; word,byte,word,byte
    ld hl,{valx1}
    ld (stx1),hl   
    ld a,{valy1}
    ld (sty1),a
    ld hl,{valx2}
    ld (stx2),hl
    ld a,{valy2}
    ld (sty2),a
    
    ; x=x1
    ld hl,{valx1}
    ld (stx),hl
    
    ; y=y1
    ld a,{valy1}
    ld (sty),a
    call drawline
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro time_on
	ld bc,#7f10:ld a,#6c:out (c),c:out (c),a
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
macro time_off
	ld bc,#7f10:ld a,#54:out (c),c:out (c),a
mend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start
	di:ld hl,#c9fb:ld (#38),hl

	ld a,ink00:ld bc,#7f10:out (c),c:out (c),a
    ld a,ink18:ld bc,#7f01:out (c),c:out (c),a
    ld a,ink06:ld bc,#7f02:out (c),c:out (c),a
    ld a,ink15:ld bc,#7f03:out (c),c:out (c),a

main
	ld b,#f5
sync
    in a,(c)
	rra
	jp nc,sync

	;time_on

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; plotpen
    plotpen1 0,0            ; (0,0) = en haut, à gauche
    plotpen2 160,100        ; (160,100) = au milieu
    plotpen3 319,199        ; (319,199) = en bas à droite
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; miniplot
    orgx=100
    orgy=100
    mag=50
    i=0
    repeat 180*3
    	xval=int((cos(2*i)*sin(2*i))*mag)+orgx
    	yval=int((sin(2*i))*mag)+orgy
    	i=i+0.333
    	miniplot xval,yval
    rend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; objetplotpen mouaif, bof...
   objetplotpen3 objet1_start,(objet1_end-objet1_start)/4
   objetplotpen2 objet2_start,(objet2_end-objet2_start)/4
   objetplotpen1 objet3_start,(objet3_end-objet3_start)/4
   objetplotpen1 objet4_start,(objet4_end-objet4_start)/4
   objetplotpen2 objet5_start,(objet5_end-objet5_start)/4
   objetplotpen3 objet6_start,(objet6_end-objet6_start)/4    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; line
    line 0,0,160,100 ; ok
    plotpen2 161,101

    line 0,0,317,0 ; ok
    plotpen2 319,0

    line 1,1,8,5 ; ok
    plotpen2 8,5
    
    line 0,0,319,199 ; ok
    
    line 0,199,319,199 ; ok
    
   
    line 1,1,129,197 ; bing... ça merde, pas tous les octants... Faut refaire :/
    plotpen2 129,197
    
	ang=0
    repeat 30
    line 20,20,80,256*sin(ang)
    ang=ang+360/256
    rend    


    i=0
    j=0
    repeat 80
    line 200,50+i,300,50+j
    i=i+1
    j=j+2
    rend
    

    i=0
    j=0
    repeat 40
    line 100-i,50-i,300-j,50+j
    i=i+1
    j=j+4
    rend

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       
    ;time_off

	repeat 10
    ld hl,#c000
	ld de,#c001
	ld bc,#3fff
	ld (hl),0
	ldir
    rend


    jp main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet1_start    
    x=0
    y=150
    i=0
    repeat 160 : dw x : db y : db #bb   ; #bb ne sert à rien
    x=x+1
    y=y+0.25*sin(i*10)+0.50*sin(i*3)
    i=i+1
    rend
objet1_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet2_start
    i=0
    repeat 160  
    dw x : db y : db #bb    ; #bb ne sert à rien
    x=x+1
    y=y+0.80*sin(i*3)-0.25*sin(i*10)
    i=i+1
    rend
objet2_end      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet3_start
    x=160
    y=25
    i=0
    repeat 90
    dw x : db y : db #bb    ; #bb ne sert à rien
    x=x+1*cos(i*5)
    y=y+1*sin(i*5)
    i=i+1
    rend
objet3_end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet4_start
    x=30
    y=50
    i=0
    repeat 180
    dw x : db y : db #bb    ; #bb ne sert à rien 
    x=x+2*cos(i*10)
    y=y+2*sin(i*10)
    i=i+1
    rend
objet4_end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet5_start
    x=240
    y=20
    repeat 127
    dw x : db y : db #bb    ; #bb ne sert à rien
    x=x-0.5
    y=y+0.8
    rend
objet5_end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
objet6_start
    x=180
    y=150
    repeat 127  
    dw x : db y : db #bb    ; #bb ne sert à rien  
    x=x-1
    y=y-0.25
    rend
objet6_end 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; serait mieux dans une structure...
stx 	dw 0
sty 	db 0
stx1	dw 0
sty1	db 0
stx2	dw 0
sty2	db 0
stdx	dw 0
stdy	dw 0
stp	    dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drawline
    ; dx=(x2-x1)
    ld hl,(stx2)
    ld bc,(stx1)
    or a
    sbc hl,bc
    ld (stdx),hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; dy=y2-y1
    ld a,(sty1)
    ld b,a
    ld a,(sty2)
    sub b
    ld h,0
    ld l,a
    ld (stdy),hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; p=(2*dy)-dx
    ld hl,(stdy)
    add hl,hl
    ld de,(stdx)
    or a
    sbc hl,de
    ld (stp),hl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; while (x <= x2) do
; transformé en : while (x2 >= x) do
    _while
        loop
        ld hl,(stx2)
        ld de,(stx)
        or a
        sbc hl,de           
        jr c,_exit
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ; plot
        ld hl,(stx)
        add hl,hl
        add hl,hl
        add hl,hl   ; x8
        ld bc,cheat_table_pen1
        add hl,bc
        ex de,hl
        ld a,(sty)
        ld l,a
        ld ix,next
        jp plotxy
        next  
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;x=x+1
        ld hl,(stx)
        inc hl
        ld (stx),hl
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;if p<0
        _if
        ld hl,(stp)
        bit 7,h
        jr z,_else
            _then
                ;p=p+(2*dy)
                ld hl,(stdy)
                add hl,hl
                ex de,hl 
                ld hl,(stp) 
                add hl,de
                ld (stp),hl
            	jr _endif
            
            _else
                ;p=p+((2*dy)-(2*dx))
                ld hl,(stdx)
                add hl,hl
                ld d,h      
                ld e,l
                ld hl,(stdy)
                add hl,hl
                or a
                sbc hl,de
                ld d,h
                ld e,l
                ld hl,(stp)
                add hl,de
                ld (stp),hl

                ;y=y+1
                ld a,(sty)
                inc a
                ld (sty),a
        _endif
        jp loop
    _exit
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plotxy
    ld h,hi(y_table)
    ld b,(hl)			
    inc h               
    ld c,(hl)           
    ex de,hl			
    jp (hl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 256
cheat_table_pen2
xval=0
repeat 80					; 80*8/2=320
    ld hl,#0000+xval
    add hl,bc
    set 3,(hl)				; mode1, pen2
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 2,(hl)				; mode1, pen2
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 1,(hl)				; mode1, pen2
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 0,(hl)				; mode1, pen2
    jp (ix)
    xval=xval+1
rend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 256
cheat_table_pen3
xval=0
repeat 80					; 80*10/2=320
    ld hl,#0000+xval
    add hl,bc
    set 7,(hl)
    set 3,(hl)				; mode1, pen3
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 6,(hl)
    set 2,(hl)				; mode1, pen3
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 5,(hl)
    set 1,(hl)				; mode1, pen3
    jp (ix)
    ld hl,#0000+xval
    add hl,bc
    set 4,(hl)
    set 0,(hl)				; mode1, pen3
    jp (ix)
    xval=xval+1
rend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
stack
    dw 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

-- Project 116: thanatos by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'thanatos',
    'Imported from z80Code. Author: siko. Thanatos Disarked',
    'public',
    false,
    false,
    '2020-02-10T20:43:02.124000'::timestamptz,
    '2021-06-16T12:16:43.681000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    'org 0
run START

SHOW_BACK_BUFFER = 1


lab0000 ld bc,lab7F88+1
lab0003 out (c),c
lab0005 jp lab0590+1
lab0008 jp labB98A
lab000B jp labB984
    push bc
lab000F ret 
lab0010 jp labBA1D
lab0013 jp labBA17
lab0016 push de
lab0017 ret 
lab0018 jp labB9C7
lab001B jp labB9B9
lab001E jp (hl)
    nop
lab0020 jp labBAC6
    jp labB9C1
    nop
lab0027 nop
    jp labBA35
lab002B nop
    out (c),c
    exx
    ei
    rst 0
    exx
lab0032 ld hl,lab002B
    ld (hl),c
lab0036 jr lab0040
lab0038 jp labB941
lab003B ret 
    nop
    nop
    nop
lab003F nop
lab0040 nop
    add a,b
lab0042 ret nz
lab0043 ret po
lab0044 ret p
lab0045 ret m
lab0046 call m,labFFFE
lab0049 ld a,a
lab004A ccf 
lab004B rra 
lab004C rrca 
    rlca 
lab004E inc bc
lab004F ld bc,lab0056+2
lab0052 ld bc,labCB08
    inc h
lab0056 ld bc,lab1B20
    ld c,a
    ld c,b
lab005B scf
lab005C ld d,(hl)
lab005D ld h,16
    ld b,d
    ld d,c
    ld c,41
    dec de
    ld h,l
    daa
    ld de,lab0911
lab0069 inc d
    rlca 
    inc h
lab006C call nc,lab2526+1
    inc e
lab0070 ld h,c
    rla 
    djnz lab008B+1
    ret po
    jr z,lab0017
    add a,e
    ld a,(hl)
    ld h,80
    ld c,h
lab007C ld h,c
    dec hl
lab007E jr lab009D
lab0080 ld d,107
lab0082 ld c,24
    ld c,c
    inc l
lab0086 ld (de),a
    ex af,af''
    ld c,h
lab0089 rra 
    inc l
lab008B jr nz,lab00D5+2
    dec l
lab008E ld (lab2244),a
lab0091 ld (hl),44
    inc l
    add a,b
    ld l,32
    ld (de),a
    ld c,c
    sub l
    ld c,23
lab009C ret 
lab009D cpl 
    ld a,(bc)
lab009F ld sp,lab38BA
    inc d
    ld l,b
    sbc a,d
lab00A5 ld sp,lab2C5F
lab00A8 inc h
    nop
    and l
    jr c,lab00FF
    inc sp
    nop
lab00AF nop
lab00B0 nop
lab00B1 ld a,h
    ld b,(hl)
    ld a,(lab3488)
    jr c,lab0107+1
    ld d,e
    rla 
    inc d
lab00BB inc hl
    jp c,lab2134+1
    dec d
lab00C0 ld d,47
    jr nc,lab0117
    ld d,a
    scf
lab00C6 inc c
    inc sp
    ccf 
    jr nc,lab00DE
    inc d
lab00CC ld b,a
    jr c,lab0109
lab00CF ld e,d
lab00D0 add a,(hl)
    cpl 
    ld a,78
    cp (hl)
lab00D5 ld a,(lab363E)
    inc hl
    inc hl
    dec hl
    halt
    add a,d
    inc a
lab00DE ld c,l
    xor (hl)
lab00E0 ld hl,lab2525
lab00E3 daa
    rla 
    ld a,8
lab00E7 dec b
lab00E8 scf
    ld c,l
    ld c,b
    ld l,82
    ccf 
lab00EE ld a,(lab2D1D+2)
    daa
    daa
    inc a
lab00F4 adc a,a
    ld b,b
    ld b,d
    ld c,c
lab00F8 cpl 
    ld c,h
    scf
    ld l,l
lab00FC sub d
    ld b,d
lab00FE ld e,l
lab00FF nop
lab0100 rst 56
lab0101 rst 56
lab0102 nop
lab0103 rst 56
lab0104 rst 56
lab0105 jr nz,lab0127
lab0107 jr nz,lab0129
lab0109 jr nz,lab0129+2
lab010B jr nz,lab012D
lab010D jr nz,lab012D+2
lab010F jr nz,lab0131
lab0111 nop
    nop
lab0113 nop
lab0114 nop
    nop
lab0116 nop
lab0117 ld hl,lab0000
lab011A call labA776
lab011D ld hl,(labA751)
    ld a,(labB79B)
lab0123 bit 4,a
    jr z,lab0129
lab0127 ld l,0
lab0129 ld ix,lab13A8
lab012D ld a,(lab0117)
    ld e,a
lab0131 res 6,e
    ld a,(lab0117+2)
    cp 6
    jr nz,lab0145
    push hl
    ld hl,(lab2474)
    bit 2,(hl)
    pop hl
    jr nz,lab0145
    set 6,e
lab0145 bit 2,e
lab0147 jp nz,lab074D
    ld a,l
    and 19
    cp 18
    jp z,lab0700
    bit 6,e
    jr z,lab0178
    bit 0,e
    jr z,lab0178
    ld a,(labA750)
    add a,a
    jr c,lab0178
    push hl
    ld hl,(lab8FFA)
    ld a,(labB793)
    add a,a
    add a,a
    add a,a
    add a,l
    ld l,a
    jr nc,lab016F
    inc h
lab016F ld bc,lab097F+1
    sbc hl,bc
    pop hl
    jp nc,lab0700
lab0178 ld a,(lab13F4)
    cp 154
    jr nz,lab0188
lab017F ld a,(labA750)
    add a,a
lab0183 jp c,lab0700
    jr lab0193
lab0188 cp 188
    jr nz,lab0193
    ld a,(labA750)
    add a,a
lab0190 jp nc,lab0700
lab0193 call lab0607+1
    bit 4,l
    jp z,lab02AB
    bit 7,e
lab019D call nz,lab08A2
lab01A0 bit 3,e
    jr nz,lab01E5
    ld a,(labB600)
    cp 13
    jp z,lab02AB
lab01AC call lab8E3A
    ld bc,lab0407+2
    set 3,(ix+2)
lab01B6 set 3,(ix+14)
    ld (ix+12),37
lab01BE set 3,(ix+8)
    ld (ix+6),82
    res 3,(ix+17)
    ld (ix+15),71
    ld a,(ix+0)
    ld c,a
    ld b,16
    ld a,(bc)
    ld (ix+0),80
    ld (lab1050),a
    ld a,133
lab01DE ld (lab1052),a
    set 3,e
    jr lab0253
lab01E5 ld a,(labB600)
    cp 13
    jp z,lab02AB
    call lab8E3A
    ld bc,lab09A8+1
    ld a,1
    call labB671
    bit 0,e
    jr nz,lab0201
    ld a,254
lab01FE call lab6151
lab0201 ld b,130
lab0203 bit 3,l
lab0205 jr z,lab0219
lab0207 res 3,l
    bit 4,e
lab020B jr z,lab0211
    bit 2,l
lab020F jr nz,lab0219
lab0211 ld b,128
lab0213 bit 2,l
    jr z,lab0219
lab0217 ld b,132
lab0219 ld a,(lab1050)
    cp b
    jr z,lab0224
    jr nc,lab0223
    inc a
lab0222 inc a
lab0223 dec a
lab0224 ld (lab1050),a
    cp 130
    jr z,lab023D
lab022B jr c,lab0233
    ld a,168
    ld b,84
    jr lab0241
lab0233 ld a,170
    ld b,84
    set 6,(ix+16)
    jr lab0245
lab023D ld a,133
    ld b,73
lab0241 res 6,(ix+16)
lab0245 ld c,a
    ld a,(lab1052)
lab0249 cp c
    jr z,lab0253
    ld a,c
lab024D ld (ix+15),b
    ld (lab1052),a
lab0253 ld a,(lab13B7)
    exx
    ld l,a
    call lab08DC
    ld a,(lab13B8)
    push ix
    ld ix,labB792
    call lab0270
    pop ix
    ld (lab0103),bc
    exx
    jr lab02B2
lab0270 ld h,16
    ex af,af''
    ld a,(hl)
    sub 177
    cp 6
    jr nc,lab02A8
    ld hl,lab08E5
    call labA6F8
lab0280 bit 7,(ix+9)
    jr z,lab0288
lab0286 neg
lab0288 call lab6790
    ld a,c
    cp 32
    jr nc,lab02A8
lab0290 add a,a
    add a,a
    add a,a
    or e
    ld c,a
    inc hl
    ex af,af''
    bit 6,a
    ld a,(hl)
    jr z,lab02A0
    neg
    add a,224
lab02A0 add a,b
lab02A1 cp 124
    ld b,a
    ret c
    ld b,124
    ret 
lab02A8 ld b,255
    ret 
lab02AB bit 3,e
    jr z,lab02B2
lab02AF call lab047C
lab02B2 ld a,(labB79B)
    bit 4,a
    jr nz,lab02D6
    bit 3,e
    jr nz,lab02D6
    bit 0,e
    jr z,lab02D2
lab02C1 ld a,(ix+32)
    cp 17
    jr nz,lab02D6
    call lab8E3A
    ld (bc),a
    add hl,bc
    djnz lab02DB+1
    inc b
    jr lab02D6
lab02D2 bit 1,e
    jr nz,lab02C1
lab02D6 bit 0,e
    jp z,lab04B0
lab02DB ld a,(lab0116)
    ld c,a
lab02DF bit 3,l
    jr z,lab02EE
    bit 2,l
    jr z,lab02F8
    cp 4
    jr z,lab02FE
    inc a
    jr lab02FD
lab02EE or a
lab02EF jr z,lab02FE
    bit 7,a
    jr z,lab02FC
    inc a
    jr lab02FD
lab02F8 cp 252
    jr z,lab02FE
lab02FC dec a
lab02FD ld c,a
lab02FE ld a,(labB794)
    add a,c
lab0302 ld b,a
lab0303 ld a,(labA750)
    add a,a
lab0307 bit 7,e
    jr z,lab030F
    cp 40
    jr lab0311
lab030F cp 16
lab0311 ld a,b
lab0312 jr nc,lab0315
    inc a
lab0315 cp 28
    jr nc,lab031D
    ld a,28
    ld c,0
lab031D bit 7,e
    jr z,lab0353
    ex af,af''
    ld a,(labB79B)
    bit 4,a
    jr nz,lab0344
    ld a,(lab010B+1)
lab032C cp 104
    jr nz,lab0347
    ld a,(lab010D)
    cp 18
    jr nz,lab0347
    ex af,af''
    cp 70
    jr c,lab0350
    ex af,af''
    ld a,(lab0117+2)
    cp 1
    jr z,lab0347
lab0344 ex af,af''
    jr lab0350
lab0347 ld a,(lab0111)
    ld b,a
    ex af,af''
    cp b
    jp c,lab03CE
lab0350 call lab08A2
lab0353 cp 90
    jr c,lab03B3
lab0357 bit 1,e
    jr nz,lab0375
    set 1,e
    res 3,(ix+24)
    ld (ix+19),98
    res 2,(ix+21)
    ld (ix-10),54
    ld (ix-5),6
    ld (ix-4),154
lab0375 cp 115
    jr c,lab03C9
    ex af,af''
    ld a,(labB793)
    call lab07FE
lab0380 jr nz,lab038E
    ex af,af''
    jr z,lab03C9
lab0385 call lab07ED
    cp b
    jr c,lab03CE
    ld a,b
    jr lab0390
lab038E ld a,115
lab0390 ex af,af''
    res 0,e
    ld (ix-4),153
    ld (ix+22),138
lab039B set 3,(ix+24)
    ld (ix-10),95
    ld (ix+19),92
    res 2,(ix-5)
    call lab0569
    ex af,af''
    ld c,0
    jr lab03CE
lab03B3 bit 1,e
    jr z,lab03CE
    cp 80
    jr nc,lab03CE
    res 1,e
    ld (ix+19),109
lab03C1 ld (ix+22),128
    ld (ix+21),6
lab03C9 bit 4,e
    call nz,lab07F7
lab03CE ld (labB794),a
    ld a,e
    ld (lab0117),a
    ld a,c
    ld (lab0116),a
    ld a,(labA750)
    bit 4,e
    jr z,lab03E4
    sra a
    and 191
lab03E4 ld (lab13F2+1),a
    and 56
    cp 32
    jr c,lab03EF
    ld a,24
lab03EF ld hl,lab0689
    add a,l
    ld l,a
    jr nc,lab03F7
    inc h
lab03F7 ld e,(hl)
lab03F8 inc hl
    ld d,(hl)
    inc hl
    ld (lab1021),de
lab03FF ld a,(lab0117)
lab0402 bit 5,a
lab0404 jr z,lab040F
lab0406 push hl
lab0407 ld hl,lab3636
    add hl,de
    ld (lab1097),hl
    pop hl
lab040F ld de,lab1012
    call lab067C
    ld de,lab101A
    call lab067C
    ld a,(lab13F2+1)
lab041E rra 
    rra 
    bit 5,a
    jr z,lab042A
    and 15
    add a,22
    jr lab0478
lab042A push af
    ld a,(lab0117)
    bit 6,a
    jr z,lab0471
    rra 
    jr c,lab0471
    ld hl,(lab8FFA)
    ld de,lab09A8
    or a
    sbc hl,de
    jr c,lab0471
    ld (lab8FFA),de
    pop af
    call lab08DC
    ld a,(labA750)
    cp 10
    jr c,lab0451
    ld a,8
lab0451 ld d,a
    ld a,16
    cp c
    ld a,d
    jr nc,lab0459
    xor a
lab0459 ld (labA750),a
    srl a
    srl a
    and 2
    call lab6790
    ld (labB792),a
    ld a,c
    ld (labB793),a
    xor a
    ld (lab13F2+1),a
    ret 
lab0471 pop af
    and 15
    neg
    add a,10
lab0478 call lab06A9
    ret 
lab047C call lab8E3A
    ld bc,lab1009
lab0482 res 3,(ix+2)
lab0486 res 3,(ix+14)
    res 3,(ix+8)
    set 3,(ix+17)
lab0492 ld (ix+6),11
    ld a,(lab1050)
    add a,128
    bit 4,e
    jr z,lab04A1
    ld a,7
lab04A1 ld (ix+0),a
    ld (ix+15),37
    ld a,255
    ld (lab0104),a
    res 3,e
    ret 
lab04B0 bit 3,l
    jr z,lab04FC
    bit 2,l
    jr nz,lab04FC
    bit 1,e
    jr nz,lab04D0
    ld (ix+32),17
    ld (ix+34),2
    ld (ix+35),25
    ld (ix+37),2
lab04CC set 1,e
    jr lab0512
lab04D0 ld a,(ix+19)
    cp 92
    jr nz,lab0512
    ld a,(labA750)
    and 127
    cp 8
    jr c,lab0512
    set 0,e
    ld (ix+19),100
    ld (ix-10),54
    ld (ix-5),6
    ld (ix-4),154
    ld (ix+22),106
    ld (ix+24),2
    jr lab0512
lab04FC bit 1,e
    jr z,lab0512
    ld (ix+32),139
lab0504 ld (ix+34),6
lab0508 ld (ix+35),144
lab050C ld (ix+37),6
    res 1,e
lab0512 ld a,(labB793)
    call lab07FE
    jr z,lab051F
lab051A call lab07F7
    jr lab0522
lab051F call lab07ED
lab0522 ld a,e
    ld (lab0117),a
    ld a,(ix+19)
    cp 92
    call z,lab0569
    ld hl,(lab0565)
    ld a,(hl)
    cp 32
    jr nz,lab053A
    ld hl,(lab0567)
    ld a,(hl)
lab053A add a,b
    ld (labB794),a
    inc hl
    ld b,(hl)
    inc hl
    ld (lab0565),hl
    ld a,(labA750)
    and 128
    or b
    ld (lab13F2+1),a
    ld a,(lab0117)
    ld e,a
    ld a,(labA750)
    sra a
    sra a
    and 159
    bit 0,e
    jp z,lab041E
    ld (labA750),a
    jp lab041E
lab0565 nop
    nop
lab0567 nop
    nop
lab0569 push de
lab056A ld a,(labA750)
    rra 
    rra 
    and 14
    cp 10
    jr c,lab0577
    ld a,8
lab0577 ld hl,lab8D8C
    or a
    jr nz,lab0588
    set 3,(ix+21)
    set 3,(ix-5)
    inc l
    jr lab0590
lab0588 res 3,(ix+21)
    res 3,(ix-5)
lab0590 ld (lab1021),hl
    bit 5,e
    jr z,lab059E
    ld de,lab3636
    add hl,de
    ld (lab1097),hl
lab059E ld hl,lab05C4
    add a,l
    ld l,a
    jr nc,lab05A6
    inc h
lab05A6 ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,lab105B
    push bc
    ld b,3
lab05B0 ld a,(hl)
    inc hl
    ld (de),a
    inc e
    inc e
    djnz lab05B0
    pop bc
    pop de
    ld (lab0565),hl
    ld (lab0567),hl
    ld (ix-10),95
    ret 
lab05C4 adc a,5
    call nc,labE405
    dec b
    jp p,labFE05
    dec b
    sub l
    sbc a,b
    sub e
    nop
    nop
    jr nz,lab056A
    sbc a,b
    sub e
    cp 2
    rst 56
    ld (bc),a
    nop
    ld (bc),a
    cp 2
    rst 56
lab05E0 ld (bc),a
    nop
    ld (bc),a
    jr nz,lab05EC
    sbc a,b
    sub e
    cp 2
    rst 56
    ld (bc),a
    nop
lab05EC ld (bc),a
    cp 2
    rst 56
lab05F0 inc b
    jr nz,lab05F9+1
    rlca 
    sub e
    cp 4
    nop
    ld (bc),a
lab05F9 cp 2
    rst 56
    inc b
    jr nz,lab0606
lab05FF rlca 
lab0600 rlca 
    cp 4
    nop
    inc b
    rst 56
lab0606 inc b
lab0607 jr nz,lab0642+1
    ld d,b
    and a
    ld d,0
    ld c,a
lab060E or a
    jp p,lab0616
    set 7,d
    res 7,c
lab0616 ld a,(lab0117+1)
    bit 1,l
    jr z,lab062F
    bit 0,l
    jr z,lab0628
    cp 2
    jr z,lab0639
    inc a
    jr lab0639
lab0628 cp 253
    jr z,lab0639
    dec a
    jr lab0639
lab062F or a
lab0630 jp m,lab0638
    jr z,lab0639
    dec a
    jr lab0639
lab0638 inc a
lab0639 ld b,a
    add a,c
    jp p,lab0642
    xor a
    ld b,a
    jr lab064A
lab0642 cp 40
    jr c,lab064A
    ld a,40
    ld b,0
lab064A or d
    ld c,b
    ld (labA750),a
    ld b,a
    ld a,c
    ld (lab0117+1),a
    ld a,b
    and 127
    ld b,255
    cp 40
    jr z,lab0662
    or a
    jr z,lab0662
    ld b,0
lab0662 ld c,a
    ld a,(lab0117)
    rra 
    jr c,lab0674
    ld a,c
    inc b
    cp 8
    jr nc,lab0670
    inc b
lab0670 ld a,b
    jp lab6151
lab0674 ld a,(lab13E5)
    and 3
    ret nz
    jr lab0670
lab067C ld a,(hl)
    inc hl
    ld (de),a
    inc de
lab0680 ld a,(hl)
    inc hl
    ld (de),a
    inc de
    inc de
    ld a,(hl)
    inc hl
    ld (de),a
lab0688 ret 
lab0689 adc a,l
    adc a,l
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    adc a,h
    adc a,l
    rlca 
    nop
    rlca 
    rlca 
    ld a,b
    rlca 
    adc a,e
    adc a,h
    rlca 
    nop
    nop
    rlca 
    ld a,b
    ld a,b
    adc a,d
    adc a,e
    ld a,l
    nop
    nop
    ld a,c
    ld a,b
    ld a,b
lab06A9 add a,10
    ld c,a
    ld a,(labB793)
    ld b,a
    add a,10
    cp c
    ld a,(labB792)
    jr nz,lab06E1
    or a
    ret z
    dec a
    dec a
    ld d,2
lab06BE and 6
    ld (labB792),a
lab06C3 ld a,(lab13F2+1)
    ld c,a
    and 127
    add a,d
    bit 7,c
    jr z,lab06D0
    sub d
    sub d
lab06D0 or a
    jp p,lab06D8
    neg
    set 7,a
lab06D8 ld b,a
    ld a,c
    and 128
    xor b
    ld (lab13F2+1),a
    ret 
lab06E1 jr c,lab06F3
    dec a
    dec a
    ld d,2
    jp p,lab06BE
    dec b
    ld c,6
lab06ED ld (labB792),bc
    jr lab06C3
lab06F3 inc a
    inc a
    ld d,254
    cp 8
    jr nz,lab06BE
    inc b
lab06FC ld c,0
    jr lab06ED
lab0700 bit 7,e
lab0702 call nz,lab08A2
lab0705 set 2,e
    bit 3,e
    call nz,lab047C
lab070C ld a,e
lab070D ld (lab0117),a
    call lab64BB
    ld a,111
    ld (lab074D+1),a
    ld a,(labA750)
    and 128
    ld (lab075C+1),a
    bit 0,e
    jr nz,lab072C
    ld de,labBCBD
    ld hl,lab07B1
    jr lab0746
lab072C ld de,labBABA
    ld a,(labA750)
    and 56
    cp 25
    jr c,lab073A
    ld a,24
lab073A ld b,a
    srl b
    add a,b
lab073E ld hl,lab07BD
    add a,l
    ld l,a
    jr nc,lab0746
    inc h
lab0746 ld (lab1095),de
    ld (lab0761+1),hl
lab074D ld a,112
    inc a
    ld (lab074D+1),a
    push af
    srl a
    ld hl,lab0CBD
    call lab15E0
lab075C ld d,0
    ld (labB799),hl
lab0761 ld hl,lab07BD
    ld a,(hl)
    and 15
    bit 3,a
    jr z,lab076D
    or 240
lab076D bit 7,d
    jr z,lab0773
    neg
lab0773 ld c,a
    ld a,(labB793)
    add a,c
    ld (labB793),a
    ld a,(hl)
    xor d
    and 128
    ld d,a
    ld a,(hl)
    rra 
    rra 
    rra 
    and 14
lab0786 or d
    ld (lab13F2+1),a
    inc hl
    ld (lab0761+1),hl
    pop af
lab078F cp 122
    ret nz
    xor a
    ld (lab0116),a
    ld a,(lab0117)
    res 2,a
    ld (lab0117),a
lab079E ld a,(labA750)
    xor 128
    ld (labA750),a
    ld a,(labB79B)
    xor 192
    ld (labB79B),a
    jp lab011A
lab07B1 nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    nop
    rrca 
    nop
    inc b
    nop
lab07BD ld (bc),a
    ld (bc),a
    ld bc,lab0101
    nop
    nop
    nop
    rrca 
    rrca 
    inc bc
    nop
    inc bc
    inc bc
    ld (bc),a
    ld bc,lab0101
    nop
    rrca 
    rrca 
    ld c,2
    nop
    dec b
    inc b
    inc bc
lab07D8 ld (bc),a
    ld bc,lab0000+1
    rrca 
    ld c,13
    ld bc,lab0600
    dec b
    inc bc
    ld (bc),a
    ld (bc),a
    ld bc,lab0EFF+1
    ld c,11
    rrca 
    nop
lab07ED set 4,e
    push af
    ld a,7
lab07F2 ld (lab100A),a
    pop af
    ret 
lab07F7 res 4,e
    push af
    ld a,0
    jr lab07F2
lab07FE ld (lab0824+1),a
lab0801 ld a,(lab0117+2)
lab0804 ld b,135
lab0806 cp 1
    ret z
    ld b,115
lab080B cp 4
lab080D jr z,lab0812
lab080F cp 7
    ret nz
lab0812 push de
    push hl
    ld b,a
lab0815 ld hl,(lab8FFA)
    srl h
lab081A rr l
lab081C srl h
    rr l
    srl h
    rr l
lab0824 ld a,0
    add a,10
    add a,l
    ld l,a
    jr nc,lab082D
    inc h
lab082D ld de,labFFF5+1
    add hl,de
    srl h
    rr l
    ld de,lab00AF
    bit 1,b
    jr z,lab083E
    dec de
    ex de,hl
lab083E or a
    sbc hl,de
    jr c,lab0855
    ld a,h
    or a
    jr nz,lab084C
    ld a,l
    cp 20
    jr c,lab084E
lab084C ld a,20
lab084E add a,115
    ld b,a
    xor a
lab0852 pop hl
    pop de
    ret 
lab0855 ld b,114
    inc b
    jr lab0852
lab085A bit 7,(ix+9)
    jr z,lab0861
    ld l,d
lab0861 ld a,(labA750)
    add a,a
    jr nc,lab086B
    ld a,l
    sub 25
    ld l,a
lab086B ld (lab0114),hl
    ld a,(lab0117)
    set 7,a
    ld (lab0117),a
    ld a,(labB794)
lab0879 ld (lab0111),a
    ld a,155
lab087E ld (lab13BD+1),a
    ld a,158
    ld (lab13BB),a
    push ix
    pop hl
    ld de,lab0105
    ld bc,lab000B+1
    ldir
    ld a,252
    ld (lab0116),a
    ld a,255
    ld (lab0101),a
    ld bc,lab3001
lab089E call lab8E85
    ret 
lab08A2 res 7,e
    ld (ix+22),106
    ld (ix+19),100
lab08AC push af
    push ix
    ld ix,lab0105
    exx
    call lab6533
    call lab08CB
    call lab08DC
    ld hl,(lab0114)
    call lab6907
    call lab6786
    exx
lab08C7 pop ix
    pop af
    ret 
lab08CB ld a,(lab0102)
    neg
    ld c,a
    sra a
    add a,c
    ld (ix+11),a
    ld (ix+10),1
    ret 
lab08DC ld bc,(labB793)
    ld a,(labB792)
    ld e,a
    ret 
lab08E5 ld (hl),e
    rst 48
    ld l,c
    rst 48
    ld e,a
    rst 48
lab08EB ld l,h
    dec d
    ld h,d
    rrca 
    ld e,b
    rlca 
lab08F1 ld a,(labB79B)
    bit 4,a
    ret nz
    or 16
    ld (labB79B),a
    xor a
    ld (labB79D),a
lab0900 ret 
lab0901 ld h,255
    ld a,(lab0117)
lab0906 and 135
lab0908 cp 3
    jr nz,lab092A
    ld a,(labB79B)
    and 48
lab0911 jr nz,lab092A
    ld a,(lab010D+1)
    bit 5,a
    jr z,lab092A
    ld ix,labB792
    call lab08DC
    ld hl,lab0815
    call lab690A
    call lab691D
lab092A ld (lab0100),hl
    ld a,(lab13F2+1)
    or a
    jp p,lab0938
lab0934 res 7,a
    neg
lab0938 neg
    ld (lab0102),a
    ret 
lab093E ld hl,lab0082+1
    ld de,lab0005+2
    xor a
    ld b,16
    ;ld a,b    
lab0947 ld (hl),a
    add hl,de
    djnz lab0947
    ret 
lab094C ld ix,lab0080
    ld b,16
lab0952 push bc
    call lab095F
    ld bc,lab0005+2
    add ix,bc
    pop bc
    djnz lab0952
    ret 
lab095F ld a,(ix+3)
    or a
    jr nz,lab09A5
    ld a,r
    ld d,a
    and 112
    ret nz
    ld a,(lab61AA)
    bit 5,a
    ret z
    ld bc,(lab61E5)
    ld e,c
    ld c,b
    ld b,110
    ld a,d
    and 7
    add a,a
    add a,17
lab097F call lab6790
    call lab6786
    ld (ix+3),2
    ld (ix+4),0
lab098D ld a,r
lab098F and 3
lab0991 ld hl,lab0A9B
    call labA6F9
    ld (ix+6),a
    bit 3,d
    ret z
    set 7,(ix+4)
lab09A1 inc (ix+3)
    ret 
lab09A5 call lab677C
lab09A8 ld d,(ix+4)
    inc (ix+5)
    bit 0,d
    jr z,lab09DC
lab09B2 ld a,(ix+5)
    cp 3
    jr nz,lab09BE
    ld (ix+3),0
    ret 
lab09BE add a,92
lab09C0 ld (lab12A8),a
    ld hl,lab12A4+2
    ld a,(ix+6)
    srl a
    and 3
    cp 3
    jr nz,lab09D2
    dec a
lab09D2 ld (hl),a
    push ix
    ld a,e
    call lab1446
    pop ix
    ret 
lab09DC ld a,r
    and 120
    jr nz,lab0A39
    push bc
    bit 0,(ix+3)
    jr z,lab09F1
    ld bc,lab1004
    call lab8E7E
    jr lab09F6
lab09F1 ld b,15
    call lab8E6F
lab09F6 pop bc
lab09F7 set 0,(ix+4)
lab09FB ld (ix+5),0
    ld d,3
lab0A01 push de
lab0A02 push bc
    call lab0A74
lab0A06 pop bc
    pop de
    jr nz,lab0A36
    ld (iy+0),e
lab0A0D ld (iy+1),c
    ld (iy+2),b
    ld a,(ix+3)
    dec a
    ld (iy+3),a
    ld (iy+4),0
    ld a,r
    bit 3,a
    jr z,lab0A28
lab0A24 set 7,(iy+4)
lab0A28 and 7
    ld hl,lab0A9B
    call labA6F9
    ld (iy+6),a
    dec d
    jr nz,lab0A01
lab0A36 jp lab09B2
lab0A39 ld l,(ix+6)
    ld h,254
lab0A3E ld a,(hl)
    inc l
    cp 128
    jr nz,lab0A47
    ld l,(hl)
    jr lab0A3E
lab0A47 bit 7,d
    jr z,lab0A4D
    neg
lab0A4D call lab6790
lab0A50 ld a,c
    add a,5
    cp 42
    jr nc,lab0A62
    ld a,(hl)
    inc l
    ld (ix+6),l
    add a,b
    ld b,a
    cp 124
    jr c,lab0A67
lab0A62 ld (ix+3),0
    ret 
lab0A67 call lab6786
lab0A6A ld a,(ix+5)
    and 3
lab0A6F add a,88
    jp lab09C0
lab0A74 ld hl,lab0082+1
    ld c,(hl)
    push hl
    ld de,lab0005+2
    add hl,de
    ld b,15
lab0A7F ld a,(hl)
    cp c
    jr nc,lab0A87
    inc sp
    inc sp
    push hl
    ld c,a
lab0A87 add hl,de
    djnz lab0A7F
    pop iy
    ld de,labFFFD
lab0A8F add iy,de
    ld a,c
    cp (ix+3)
    jr c,lab0A99
    inc a
    ret 
lab0A99 xor a
    ret 
lab0A9B djnz lab0AA1
    ex af,af''
    inc c
    inc l
    inc d
lab0AA1 inc e
    jr lab0A6F
    ld (hl),a
    jr z,lab0AAE
    ld a,d
    neg
    ld d,a
    ld a,(lab0046)
lab0AAE xor b
    ld (lab0046+1),a
    ld a,c
    ld (lab0046+2),a
    ld a,0
    ld bc,lab0000
    add a,e
    ld e,a
    sra a
    sra a
    sra a
    add a,c
    ld c,a
    ld a,d
    add a,b
    ld b,a
    ld a,e
    and 7
    call lab165B
lab0ACE dec (ix-3)
    pop hl
    jp nz,lab1474
    ret 
    ld e,a
    ld a,0
    cp 203
lab0ADB jr nc,lab0AE7
    push de
    push bc
    push af
    ld a,e
    call lab165B
    pop af
    pop bc
    pop de
lab0AE7 ld hl,lab0B18
    call lab15E0
    inc hl
    ld a,(hl)
    call lab6790
    inc hl
    ld a,(hl)
    add a,b
    ld b,a
    inc hl
    ld a,e
    jp lab165B
    push de
    push bc
    ld d,a
lab0AFE and 248
    nop
    add a,b
    ret nz
    ret po
lab0B04 ret p
    ret m
    call m,labFFFE
    ld a,a
lab0B0A ccf 
    rra 
    rrca 
lab0B0D rlca 
    inc bc
    ld bc,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
lab0B18 sla h
    ld bc,lab1B20
    ld c,a
    ld c,b
    scf
    ld d,(hl)
    ld h,16
    ld b,d
    ld d,c
    ld c,41
    dec de
    ld h,l
    daa
    ld de,lab0911
    inc d
    rlca 
    inc h
    call nc,lab2526+1
    inc e
    ld h,c
    rla 
    djnz lab0B4F+1
    ret po
    jr z,lab0ADB
    add a,e
    ld a,(hl)
    ld h,80
    ld c,h
    ld h,c
    dec hl
    jr lab0B61
    ld d,107
    ld c,24
    ld c,c
    inc l
    ld (de),a
    ex af,af''
    ld c,h
    rra 
    inc l
lab0B4F jr nz,lab0B99+2
    dec l
    ld (lab2244),a
    ld (hl),44
    inc l
    add a,b
    ld l,32
    ld (de),a
    ld c,c
    sub l
    ld c,23
    ret 
lab0B61 cpl 
    ld a,(bc)
    ld sp,lab38BA
    inc d
    ld l,b
    sbc a,d
    ld sp,lab2C5F
    inc h
    nop
    and l
    jr c,lab0BC3
    inc sp
    nop
    nop
    nop
    ld a,h
    ld b,(hl)
    ld a,(lab3488)
    jr c,lab0BCC
    ld d,e
    rla 
    inc d
    inc hl
    jp c,lab2134+1
    dec d
lab0B84 ld d,47
    jr nc,lab0BDA+1
    ld d,a
    scf
    inc c
    inc sp
    ccf 
    jr nc,lab0BA2
    inc d
    ld b,a
    jr c,lab0BCC+1
    ld e,d
    add a,(hl)
    cpl 
    ld a,78
    cp (hl)
lab0B99 ld a,(lab363E)
    inc hl
    inc hl
    dec hl
    halt
    add a,d
    inc a
lab0BA2 ld c,l
    xor (hl)
    ld hl,lab2525
    daa
    rla 
    ld a,8
    dec b
    scf
    ld c,l
    ld c,b
    ld l,82
    ccf 
    ld a,(lab2D1D+2)
    daa
    daa
    inc a
    adc a,a
    ld b,b
    ld b,d
    ld c,c
    cpl 
    ld c,h
    scf
    ld l,l
lab0BC0 sub d
    ld b,d
    ld e,l
lab0BC3 nop
    ld c,c
    ld a,(de)
    ld (labD636),hl
    ld b,e
    jr z,lab0C2C
lab0BCC jr c,lab0C16
    adc a,l
    ld h,e
    ld c,a
    ld b,(hl)
    adc a,c
    ld (hl),c
    ld (lab032C+1),hl
    inc e
    rst 24
    ld b,a
lab0BDA ld d,19
    add hl,de
    inc de
    dec h
    nop
    ld e,c
    ld c,b
    dec h
    inc (hl)
    ld a,a
    add a,h
    ld d,e
    ld c,e
    sbc a,(hl)
    ld c,d
    ld b,d
    inc hl
    dec h
    nop
    nop
    nop
    ld l,l
    ld h,l
    jr nz,lab0C69
    ld (hl),e
    ld h,l
    jr nz,lab0C67
    ld l,(hl)
    ld l,h
    ld a,c
lab0BFB ld l,32
    ld b,c
    ld l,h
    ld l,h
lab0C00 add a,(hl)
    ld c,e
    ld bc,lab1330
lab0C05 add a,e
lab0C06 add a,e
    add a,e
lab0C08 sub 77
    rlca 
    inc (hl)
lab0C0C dec a
lab0C0D inc (hl)
lab0C0E ld (hl),64
    jr c,lab0C61
    ld b,b
    ld b,b
    dec hl
    dec hl
lab0C16 dec hl
    ld l,132
    ld d,b
lab0C1A ld e,19
    inc de
    ld d,40
    ld d,43
    ld d,c
    dec h
    ld b,7
    inc c
    ld (labC108),hl
    ld d,c
    dec h
    add hl,de
lab0C2C scf
    inc (hl)
    ld hl,(labDD2A)
    ld d,d
    ld (labB631),hl
    sub (hl)
    sub l
    jr c,lab0CAB+2
    ld d,l
    ld b,e
    inc (hl)
    ld d,l
    ld l,l
    jr nc,lab0C6E
    ld d,c
    ld d,a
    jr z,lab0C79+1
    ld l,d
    ld h,c
    ld b,l
    ld a,61
    ld e,c
    ld sp,lab312C
    jr z,lab0CA5
    ld (lab5AD7),hl
    nop
    nop
    nop
    nop
    nop
    nop
    add hl,hl
    ld e,e
    jr z,lab0CAB+1
    ld c,d
    ld d,h
    push hl
    ld l,c
    ld l,(hl)
lab0C61 ld h,a
    inc l
    jr nz,lab0CCA
    ld a,b
    ld h,e
lab0C67 ld l,b
    ld h,c
lab0C69 ld l,(hl)
    ld h,a
    ld l,c
    ld l,(hl)
    ld h,a
lab0C6E inc l
    rra 
    add hl,bc
    inc c
    ld l,b
    ld l,c
    ld (hl),d
    ld l,c
    ld l,(hl)
    ld h,a
    inc l
lab0C79 jr nz,lab0CE6+1
    ld h,l
lab0C7C ld l,(hl)
    ld h,h
    ld l,c
    ld l,(hl)
lab0C80 ld h,a
    inc l
    jr nz,lab0CF4
    ld (hl),l
    ld h,d
    ld l,h
    ld l,c
    ld h,e
    jr nz,lab0CF9+2
    ld h,l
    ld (hl),d
    ld h,(hl)
    ld l,a
    ld (hl),d
lab0C90 ld l,l
    dec l
    rra 
    ld hl,lab610C+1
    ld l,(hl)
    ld h,e
    ld h,l
    ld (hl),e
    pop af
    pop af
    ret p
    inc e
lab0C9E ex af,af''
    ld a,(de)
    inc (hl)
    ld bc,lab1300
    nop
lab0CA5 inc b
    ld b,16
    dec (hl)
    nop
    nop
lab0CAB ld (lab171B+1),hl
    inc c
    inc (hl)
    ld b,c
    jr lab0CBD
    ld (lab1B00),hl
    nop
    adc a,c
    nop
    inc de
    nop
    ret p
    pop af
lab0CBD djnz lab0CCC
    ld a,(bc)
    djnz lab0CCF+1
    ld b,30
    add hl,hl
    adc a,(hl)
    dec c
    add hl,bc
    ld b,14
lab0CCA ld a,(bc)
    ld a,(bc)
lab0CCC ld b,203
    dec c
lab0CCF ld b,8
    ex af,af''
    ld bc,lab0A06
    ret m
    dec c
    ld b,10
    ex af,af''
    inc de
    dec bc
    ld b,58
    ld c,8
    nop
    inc b
    ex af,af''
    rrca 
    ld b,122
lab0CE6 ld c,13
    dec d
    inc b
    ld bc,lab0109+1
    cp c
    ld c,1
    ld de,lab0F01
    nop
lab0CF4 nop
    xor d
    ld (de),a
    dec h
    dec l
lab0CF9 ld sp,lab3737
    nop
    nop
    nop
    nop
    nop
    nop
lab0D02 nop
    nop
    nop
    nop
    nop
    nop
lab0D08 nop
    nop
    nop
    nop
    nop
lab0D0D nop
    nop
    nop
    nop
    add a,e
    ld bc,lab01FE+2
    ld (bc),a
    inc bc
    ld (bc),a
    inc b
    inc h
    nop
    ld b,1
    nop
    ld (bc),a
    ld (bc),a
    ld b,2
    dec b
    inc b
    ld (bc),a
    ld (bc),a
    ex af,af''
    ld (bc),a
    dec bc
    ld (bc),a
    nop
    add a,e
    inc de
    nop
    ld b,34
    nop
    dec b
    inc bc
    ld b,h
    ld (de),a
    dec b
    inc bc
    ld b,h
    nop
    ld bc,lab0018+1
    jr lab0D40
    nop
    nop
lab0D40 jr nz,lab0D43
    sub c
lab0D43 add a,c
    ld a,(bc)
    nop
    inc bc
    jp po,lab01FE+2
    nop
    nop
    ld (bc),a
    inc d
    nop
    add a,c
    or 0
    inc b
    jp po,lab01FE+2
    nop
    nop
    ld bc,lab0013+1
    ld d,h
    nop
    nop
    nop
    ld bc,lab8097+1
    ld a,b
    nop
    ld (bc),a
    jr z,lab0D67
lab0D67 inc bc
    ld d,b
    nop
    inc bc
lab0D6B ld e,0
    ld (bc),a
    or 0
    ld (bc),a
    call pe,lab8000
    ld e,d
    nop
    ld (bc),a
    jr z,lab0D79
lab0D79 inc bc
    ld d,b
    nop
    inc bc
    ld e,0
    ld (bc),a
    or 0
    ld (bc),a
    call pe,lab8000
    ld bc,lab005C
    ld e,l
    inc bc
    jp nz,lab001B+1
    nop
    ld bc,lab005D
    ld e,(hl)
    inc bc
    jp nz,lab0018+2
    nop
    ld bc,lab0036
    inc sp
    ld (bc),a
    add a,b
    add a,e
    inc de
    nop
    inc bc
    ld (lab051A+1),hl
    inc bc
    ld b,h
    dec hl
    dec b
    inc bc
    ld b,h
    ex af,af''
    inc bc
    jr nc,lab0DAF
lab0DAF inc de
    ld (bc),a
    inc bc
    ld (bc),a
    ld sp,lab8804
    inc bc
    jr nc,lab0DB9
lab0DB9 inc de
    ld (bc),a
    ld b,2
    ld sp,lab0804
    ld bc,lab001B
    dec sp
    ld (bc),a
    ex af,af''
    ld bc,lab001B
    add hl,sp
    ld (bc),a
    ex af,af''
    ld bc,lab001E
    jr c,lab0DD3
    ex af,af''
    ld (bc),a
lab0DD3 ld e,0
    inc a
    ld (bc),a
    ld a,(lab0801+1)
    ld (bc),a
    ld d,l
    add a,b
    ld d,h
    ld (bc),a
    ld d,l
    ld (bc),a
    jr lab0D6B
    ld bc,lab0052
    ld d,(hl)
    ld (bc),a
    ex af,af''
    inc bc
    add hl,bc
    nop
    ld a,(bc)
    ld (bc),a
    add hl,bc
    ld (bc),a
    ex af,af''
    ld (bc),a
lab0DF2 ld (bc),a
lab0DF3 ld bc,lab0043
    ld c,c
    inc b
    ld (bc),a
    ld bc,lab004A
    ld c,h
    inc b
    ld (bc),a
    inc bc
lab0E00 ld c,d
    add a,b
    ld b,d
    ld (bc),a
lab0E04 ld b,e
lab0E05 ld (bc),a
    ld c,c
lab0E07 inc b
lab0E08 ld (bc),a
    ld (bc),a
    ld d,c
    nop
    ld c,d
    ld (bc),a
lab0E0E ld b,d
    ld (bc),a
    ld (bc),a
    ld b,80
    inc bc
    jp nz,labFCF0
    ld b,l
    nop
    ld c,l
    ld (bc),a
    ld b,(hl)
    inc b
    ld c,l
    ld (bc),a
    ld b,b
    ld (bc),a
    ld c,h
    inc b
    ld (bc),a
    ld (bc),a
    ld d,b
    ld bc,labECC2
    nop
    ld d,b
    ld (bc),a
    ld d,c
    ld (bc),a
    ld (bc),a
    ld bc,lab004F+2
    ld d,c
    add a,d
    ld (bc),a
    ld bc,lab004F+2
    ld b,d
    ld (bc),a
    ex af,af''
    ld (bc),a
    ld a,(bc)
    nop
    dec bc
    ld (bc),a
    add hl,bc
    ld (bc),a
    ld (bc),a
    nop
    ld l,h
    nop
    ld (bc),a
    ld (bc),a
    ld (hl),d
    nop
    ld (hl),d
    add a,d
    ld l,(hl)
    nop
    ld bc,lab7103+1
    nop
    ld (hl),b
    inc b
    ld (hl),c
    add a,d
    ld (hl),b
    add a,e
    jp nz,labF833
    ld l,l
    nop
    ex af,af''
    ld bc,lab005B
    dec b
    ld (bc),a
    ex af,af''
    nop
    inc d
    ld bc,lab808C
    nop
    nop
    ld (bc),a
    nop
    nop
    ld (bc),a
    ld (lab01FE+2),a
    ld (lab8000),a
    ld (lab03FF+1),a
    nop
    nop
    nop
    inc b
    inc l
    ld bc,lab2A48
    ld (bc),a
    dec l
    ld (bc),a
    add hl,hl
    ld (bc),a
    ld l,2
    nop
    ld b,44
    ld bc,lab2C48
lab0E8D inc bc
    ld c,c
    jp nz,lab00F4
    ld l,2
    ld hl,(lab2D02)
    ld (bc),a
    ld hl,(lab2E02)
    ld (bc),a
    nop
    nop
    add hl,hl
    nop
    ld e,b
    ex af,af''
    inc bc
    ld h,d
    nop
    ld h,c
    ld (bc),a
    ld h,b
    ld (bc),a
    ld h,e
    ld (bc),a
    ld e,b
    ex af,af''
    inc bc
    ld e,h
    inc bc
    jp nz,lab009C
    ld e,l
    ld (bc),a
    ld e,(hl)
    ld (bc),a
    add hl,sp
    nop
    ld e,b
    ex af,af''
    dec b
    ld h,l
    inc bc
    jp nz,lab0091+1
    ld h,b
    ld (bc),a
    ld h,d
    inc b
    ld h,h
    ld (bc),a
    ld h,c
    inc b
    ld h,e
    ld (bc),a
    sbc a,b
    ex af,af''
    inc b
    ld h,(hl)
    inc bc
    jp nz,lab00A5+1
    ld l,e
    inc b
lab0ED5 ld l,d
    ld (bc),a
    ld l,b
    inc b
    ld l,c
    ld (bc),a
    ld d,(hl)
    ld d,(hl)
    rrca 
    ei
    ld c,d
    ld c,d
    dec c
    ld sp,hl
    ccf 
    ccf 
    dec bc
    rst 48
    inc (hl)
    inc (hl)
    add hl,bc
    push af
    jr z,lab0F15
    rlca 
    di
    inc e
    inc e
    ld (bc),a
    rst 40
    ld c,14
    nop
    ex de,hl
    nop
    nop
    ld l,a
    ld (hl),d
    ld h,a
    ld h,l
    ld (hl),d
    ld a,c
lab0EFF ld l,18
lab0F01 djnz lab0F15
    nop
    rst 56
    ex af,af''
    db 253
lab0F07 db 0
lab0F08 cp 1
    inc (hl)
lab0F0B dec c
    dec d
lab0F0D inc c
lab0F0E dec c
lab0F0F djnz lab0F0E
    nop
    nop
    db 253
    db 18
lab0F15 nop
    nop
lab0F17 ld c,17
    db 253
    db 18
    ld (de),a
    nop
    rst 56
lab0F1E ld hl,lab1BFD
    cp 1
    and a
    dec c
    ld l,12
lab0F27 dec c
    djnz lab0F27
lab0F2A dec de
    nop
    dec iy
    nop
    nop
    ld c,17
    dec iy
    inc bc
    inc b
    dec b
    ld b,253
    inc (hl)
    dec de
    dec e
    db 253
    db 58
    dec c
    ld c,16
    ld de,lab3EFD
    add hl,de
    ld a,(de)
    ld b,iyh
    nop
    rst 56
    ld c,l
    db 253
    db 72
    cp 1
    add a,17
    ld e,e
    inc c
    dec c
    djnz lab0F66+2
    db 253
    db 72
    nop
    db 253
    db 88
    nop
    nop
    ld c,17
lab0F5F db 253
    db 88
    ld h,40
    add hl,hl
    ld iyh,c
lab0F66 ld a,(lab3838+1)
    ld (hl),53
    ld h,(iy+72)
    ld c,c
    ld c,d
    ld iyl,iyl
    ld b,d
    ld b,e
    ld (iy+68),d
    ld b,l
    ld b,(hl)
    db 253
    db 118
    inc sp
    ld (lab7BFB+2),a
    ld (hl),h
lab0F80 ld l,c
    ld l,a
    ld l,(hl)
lab0F83 ld l,15
    inc bc
    rra 
    inc e
    ld (de),a
    ld d,b
    ld (hl),d
    ld h,l
    ld (hl),e
    ld (hl),e
    jr nz,lab0FF1
    ld l,(hl)
    ld a,c
    jr nz,lab0FFF
    ld h,l
    ld a,c
    jr nz,lab100C
    ld l,a
    jr nz,lab0FFE
    ld l,a
    ld l,(hl)
    ld (hl),h
    ld l,c
    ld l,(hl)
    ld (hl),l
    ld h,l
    ld l,0
    inc a
    ld b,d
    sbc a,c
    and c
    and c
    sbc a,c
    ld b,d
    inc a
    call m,labC6C6
    add a,198
    add a,198
    call m,labC2C2
    jp nz,labC2C2
    jp nz,lab3844
    call m,labC6C6
    add a,252
    ret c
    call z,labFEC6
    ret nz
    ret nz
    ret nz
lab0FC8 cp 192
    ret nz
    cp 192
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    cp 0
    nop
    nop
    ld (hl),b
    add a,c
    ld (hl),c
    add hl,bc
    ld (hl),b
    ld bc,lab0201+1
    ex (sp),hl
lab0FE0 ld (de),a
    ld (de),a
    ld (de),a
    jp po,lab00C0
    nop
    sbc a,h
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    nop
    nop
    nop
    sub c
    sub c
lab0FF1 ld c,d
    ld e,d
    inc h
    nop
    nop
    nop
    ex af,af''
    inc d
    inc e
    ld (lab0020+2),hl
    nop
lab0FFE nop
lab0FFF ld (hl),c
lab1000 add a,b
    add a,c
lab1002 add a,d
lab1003 add a,e
lab1004 add a,h
lab1005 add a,e
lab1006 add a,d
    add a,c
lab1008 add a,b
lab1009 db 253
lab100A db 0
lab100B add a,l
lab100C add a,(hl)
    adc a,b
    add a,(hl)
    db 253
lab1010 db 11
    ld a,d
lab1012 rlca 
    rlca 
    ld a,e
    rlca 
    ld a,l
    db 253
    db 17
lab1019 ld a,(hl)
lab101A rlca 
    rlca 
    ld a,h
lab101D rlca 
    ld a,c
lab101F add iy,de
lab1021 adc a,d
    adc a,e
    ld iy,labFF00
    ld hl,(lab25FD)
    adc a,(hl)
    adc a,(hl)
    sub b
    sub c
    rst 56
    ld (lab2CFD),a
    adc a,(hl)
    adc a,(hl)
    dec iyh
    sub h
    sub h
    sub e
    sub e
    ld (iy-99),158
    and b
    sbc a,(hl)
    db 253
lab1041 db 60
    and c
    and d
    and e
    and d
    db 253
    db 66
    nop
    nop
    or c
    or d
    or e
    or d
    db 253
    db 74
lab1050 nop
    nop
lab1052 nop
    nop
lab1054 or l
    or (hl)
    or l
    or h
    ld d,iyh
    sub h
lab105B sub l
    sub (hl)
    sbc a,b
    sub d
    sub e
    db 253
    db 90
    sub h
    sub l
    sub (hl)
    ld iyh,iyh
    sbc a,h
    sbc a,d
    sbc a,c
    cp e
    ld iyl,d
    sbc a,b
    sub d
    sub e
    cp 4
    sbc a,(hl)
    inc de
    dec h
    and e
    inc de
    ex af,af''
    and h
    inc de
    nop
    cp l
    inc de
    ld b,253
    ld (hl),153
    sbc a,d
    sbc a,e
    cp 1
    ret nz
    inc de
    ld a,(bc)
lab1088 ld iyh,a
    sbc a,c
    ld a,l
    ld a,l
    nop
    db 253
    db 139
    ld a,c
    ld a,c
    ld a,b
    db 253
    db 144
lab1095 cp h
    cp l
lab1097 ret nz
    pop bc
    db 253
    db 151
    sbc a,d
    db 253
    db 155
    sub e
    sbc a,(iy+12)
    dec c
    djnz lab10B7
    nop
    ld c,17
    nop
    add a,l
    xor b
    add a,l
    xor d
    db 253
    db 169
    add a,l
lab10B0 add a,(hl)
    adc a,b
    add a,(hl)
    rst 56
    or a
    db 253
    db 175
lab10B7 and l
    and (hl)
    and (hl)
    and l
    db 253
    db 175
    ld a,d
    ld a,e
    ld a,l
    cp iyl
    ld a,(hl)
    ld a,h
    ld a,c
    db 253
    db 194
    sbc a,e
    rst 56
    call z,labC7FD
    sbc a,h
    sbc a,d
    sbc a,c
    sbc a,d
    sbc a,h
    db 253
    db 199
lab10D3 ex af,af''
    inc b
    ld hl,lab21FE+2
    ld (bc),a
    inc hl
    ld (bc),a
    ld (lab2300+2),hl
    ld (bc),a
lab10DF nop
    nop
    nop
    ld bc,lab808D+1
    nop
    nop
    nop
    nop
    ld e,5
    nop
    ld a,(lab0005)
    ld l,128
    nop
    nop
    dec b
    nop
    ld (bc),a
    dec b
    nop
lab10F8 ld (bc),a
lab10F9 nop
    nop
    ld hl,(labC203)
lab10FE nop
lab10FF ld bc,lab0000
lab1102 dec hl
lab1103 nop
lab1104 ld (bc),a
    add hl,bc
lab1106 inc h
lab1107 nop
    dec h
    inc b
    jr z,lab1114
    inc h
    ld (bc),a
lab110E ld h,6
lab1110 jr z,lab111A
    jr z,lab111D+1
lab1114 inc h
    ld (bc),a
    dec h
    inc b
    jr z,lab1124
lab111A ex af,af''
    ld b,117
lab111D ld bc,lab7440
    ld bc,lab8A85+1
    nop
lab1124 inc b
    nop
    nop
    ld h,h
    nop
    nop
    add hl,de
    ld (hl),e
    nop
    ld (hl),e
    ld (bc),a
    halt
    ld b,d
    ld (hl),e
    ld (bc),a
    halt
    nop
lab1135 ld (de),a
    inc b
    nop
    inc (hl)
    nop
lab113A dec b
lab113B ld bc,lab01A0+1
    ld (bc),a
lab113F and l
lab1140 ld bc,lab1102
    add a,c
lab1144 inc c
    adc a,c
    nop
    nop
    dec b
    nop
    xor c
    dec b
    nop
    ld d,e
    dec c
    dec bc
    ld c,b
    nop
    dec b
    ld bc,lab28C4
    or 175
    dec b
    nop
    ld c,b
    dec c
    dec bc
    ld c,b
    ld (hl),129
    ld b,199
    add hl,bc
    ld (bc),a
    cp l
    add a,c
lab1166 ld (bc),a
    jp nz,lab0203
    inc a
    ld bc,lab4200
    dec bc
    inc b
lab1170 nop
    ld (bc),a
    ex af,af''
    nop
    add hl,bc
    ld (bc),a
lab1176 ld a,(bc)
    dec b
    ld b,h
lab1179 ld de,lab0080+1
    inc (hl)
lab117D ld bc,lab1202
    add a,d
    ld bc,lab8402
lab1184 ld bc,lab1102
    add a,c
    ld bc,lab0005+1
    inc c
    nop
    ld de,lab2080+1
    ld b,0
lab1192 ld de,lab017F+2
    ld a,1
    ld (bc),a
    ld b,h
lab1199 ld bc,lab1102
    add a,c
    ld bc,lab001B+1
lab11A0 ld a,(lab0203)
lab11A3 ld de,lab2181
    inc e
    nop
    dec e
    ld (bc),a
lab11AA ld de,lab0000+1
    ret nc
    nop
    ld (de),a
    ld (bc),a
    nop
    ret nc
    nop
lab11B4 ld bc,labD201
    nop
lab11B8 pop de
    nop
lab11BA ld bc,labD204
    nop
lab11BE nop
    nop
    out (1),a
    ld c,b
    ld c,b
    inc bc
    ld (bc),a
    ld e,b
    inc bc
    ld (bc),a
lab11C9 ld de,lab8081
    ld a,1
    ld (bc),a
    ld de,lab017F+2
    jr lab11D4
lab11D4 ld (de),a
    ld (bc),a
    ld de,lab017F+2
    jr lab11DB
lab11DB dec d
    ld (bc),a
lab11DD ld de,lab017F+2
    jr lab11E2
lab11E2 inc de
    ld (bc),a
    ld de,lab017F+2
    jr lab11E9
lab11E9 inc d
    ld (bc),a
    ld de,lab0280+1
lab11EE jr lab11F0
lab11F0 inc de
    ld (bc),a
    jr nz,lab1216
    ld de,lab017F+2
    ld d,0
    ld (de),a
    ld (bc),a
    ld de,lab017F+2
    ld d,0
lab1200 dec d
    ld (bc),a
lab1202 ld de,lab2080+1
lab1205 ld e,0
    ld de,lab2080+1
    jr nz,lab120C
lab120C ld de,lab2080+1
    ld hl,lab10FF+1
    add a,c
    jr nz,lab1237
    nop
lab1216 ld de,lab2080+1
    inc hl
    nop
    ld de,lab2080+1
    inc h
    nop
lab1220 ld de,lab2080+1
    dec h
    nop
    ld de,lab0080+1
    ld h,c
lab1229 ld bc,lab1102
    add a,c
    nop
lab122E nop
    nop
lab1230 ld (de),a
    add a,d
lab1232 add a,b
lab1233 ld h,(hl)
lab1234 ld bc,lab1202
lab1237 add a,d
    nop
lab1239 nop
    nop
    ld (de),a
    add a,d
    jr nz,lab127B+2
    nop
lab1240 ld (de),a
    add a,d
    inc bc
    ld d,b
    nop
    ld d,b
    ld (bc),a
    ld d,b
    ld (bc),a
    ld d,b
    ld (bc),a
lab124B ld (de),a
    add a,d
    inc bc
    ld d,b
    nop
    ld d,b
    ld (bc),a
    ld c,(hl)
    ld (bc),a
    ld c,(hl)
    ld (bc),a
lab1256 ld (de),a
    add a,d
    ld bc,lab024D
    ld c,h
lab125C ld (bc),a
lab125D ld (de),a
    add a,d
    nop
    ld l,l
lab1261 ld bc,lab1202
    add a,d
    nop
    ld c,e
    nop
    ld (de),a
    add a,d
    inc h
    ld c,d
    nop
    ld d,b
    inc bc
    jp nz,lab2830
    ld c,(hl)
    ld (bc),a
    ld d,b
    add a,e
    jp nz,lab28EE
    ld c,(hl)
    add a,e
lab127B jp nz,lab10FE
lab127E ld bc,lab0000+1
    nop
lab1282 nop
    nop
lab1284 ld de,lab8281
    ld b,c
    nop
    ld (hl),d
    add a,e
    jp lab07F2+2
    ld (bc),a
    ld (hl),e
    inc bc
    jp lab0705
    ld (bc),a
lab1295 ld de,lab8081
    halt
    ld bc,lab1102
    add a,c
    jr nz,lab12E4
    nop
    ld (de),a
    add a,d
    add a,b
    ld a,e
lab12A4 ld bc,lab0102
    nop
lab12A8 nop
    nop
    ld (de),a
    add a,d
    ld a,(bc)
    xor (hl)
    add a,e
    jp nz,labEF37+1
    cp b
    nop
    sub l
    inc bc
    ex af,af''
    sub (hl)
    dec b
    ex af,af''
lab12BA call nz,lab4401
    and l
    ld b,140
    inc bc
    jp nz,labF125
    xor h
    ex af,af''
    and e
    ex af,af''
    or b
    inc bc
    jp nz,labF114
    xor (hl)
    ld a,(bc)
    ld (de),a
    add a,d
    dec bc
    xor (hl)
    add a,e
    jp nz,labEE3F+1
    cp c
    nop
lab12D9 call nz,lab450B
    jp z,lab00F8
    sub (hl)
    inc bc
    ex af,af''
    sub l
    dec b
lab12E4 ex af,af''
    adc a,l
    inc bc
    jp nz,labF020
    and (hl)
    ld b,141
    inc hl
lab12EE jp nz,labF01A
    xor e
    ex af,af''
    and h
    ex af,af''
    xor l
    inc bc
    jp nz,labF10A
    xor (hl)
    ld a,(bc)
    ld (de),a
    add a,d
    ld a,(bc)
    xor l
lab1300 add a,e
lab1301 jp nz,labF030
    xor (hl)
    add a,e
lab1306 jp nz,labED48
    cp c
    nop
lab130B call nz,lab450B
    jp z,lab00F8
    sub l
    inc bc
    ex af,af''
    sub (hl)
    dec b
    ex af,af''
    xor l
    inc bc
    jp nz,labF107
    xor (hl)
    ld a,(bc)
    adc a,l
    inc bc
    jp nz,labF00C
    adc a,l
    inc bc
    jp nz,labF016
    and (hl)
    add a,a
    add a,8
    push af
    ld (de),a
    add a,d
lab132F ld a,(bc)
lab1330 xor l
    inc bc
    jp nz,labF10A
    xor (hl)
    ld a,(bc)
    cp c
    add a,b
lab1339 call nz,lab458B
    jp z,lab00E8
    sub (hl)
    add a,e
    add hl,bc
    jp nz,lab0CF9+1
    sub l
    add a,l
    add hl,bc
    call nz,lab0C05
    and d
    add a,e
    jp nz,labF630
    xor l
    add a,e
    jp nz,labF12E
    xor (hl)
    add a,e
    jp nz,labEE45+1
    and l
    add a,e
    jp nz,labF5E9
    adc a,h
    and e
    jp nz,labF1FE
    ld (de),a
    add a,d
    ld a,(bc)
    add a,d
    add a,e
    jp nz,labF4F8
    cp b
    add a,b
lab136E call nz,lab458B
    jp z,lab00E7
    sub l
    add a,e
    add hl,bc
    jp nz,lab0C06
    sub (hl)
    add a,l
    ex af,af''
    add a,l
    add a,e
    jp nz,labF1E0
    adc a,e
    add a,e
    jp nz,labF1F6
    xor h
    add a,e
    jp nz,labF630
    and h
    add a,e
    jp nz,labF538
    xor (hl)
    add a,e
    jp nz,labF130
    or b
    add a,e
    jp nz,labF418
lab139B ld (de),a
    add a,d
    rrca 
    dec h
    add a,e
    jp labFF00
    ex af,af''
    nop
    ex af,af''
    adc a,c
    nop
lab13A8 nop
    dec b
lab13AA ld bc,lab28C4
lab13AD or 11
    dec b
lab13B0 nop
    ld hl,lab0205
lab13B4 dec h
    rlca 
lab13B6 ld (bc),a
lab13B7 ld d,c
lab13B8 dec c
    dec bc
    ld b,h
lab13BB ld (hl),129
lab13BD ld b,103
    add hl,bc
    ld a,(bc)
lab13C1 cp (hl)
    ld bc,lab9743+1
    ld bc,lab0245
    ld de,lab0280+1
    add hl,de
    inc bc
    ld (bc),a
    inc a
    ld bc,lab4200
    dec bc
    inc b
lab13D4 ex af,af''
    dec hl
    dec c
    sbc a,(hl)
    dec c
    rl c
    dec sp
    ld de,lab1232
    add a,(hl)
    ld (de),a
    sub a
    ld (de),a
    and d
    ld (de),a
lab13E5 nop
lab13E6 nop
    nop
lab13E8 nop
lab13E9 nop
lab13EA nop
lab13EB nop
    nop
lab13ED nop
    nop
lab13EF nop
lab13F0 cp 0
lab13F2 cp 0
lab13F4 sbc a,e
    inc c
lab13F6 nop
lab13F7 nop
lab13F8 push bc
    call lab8E6D
    pop bc
    ret 
lab13FE ld e,0
    ld (lab159D+1),bc
lab1404 ld (lab159B+1),a
    ld a,e
    push af
    and 7
    add a,200
    ld (lab15BC+1),a
    ld bc,lab15BB
    ld (lab15B0+1),bc
    call lab144D
    ld hl,lab165B
    ld (lab15B0+1),hl
lab1420 ld a,(lab159D+1)
    add a,5
    cp 42
    jr nc,lab143E
lab1429 pop af
    push af
    sub 3
    jr nc,lab1431
    neg
lab1431 add a,3
    ld c,62
    srl a
    rr c
    ld b,35
    call lab8E4F
lab143E pop af
    inc a
    ld e,a
    and 7
lab1443 cp 7
    ret 
lab1446 ld (lab159D+1),bc
    ld (lab159B+1),a
lab144D ld ix,lab0046+2
    ld a,(hl)
    and 240
    ld c,a
    ld a,(hl)
    and 3
    ld (lab1474+1),a
    inc hl
    bit 4,c
    jr z,lab1461
    inc hl
lab1461 ld a,(hl)
    rlca 
    rlca 
    and 3
    or c
    set 6,(hl)
    ld (lab0046),a
    ld a,(hl)
    and 31
    inc a
    ld (lab0045),a
    inc hl
lab1474 ld e,0
    ld c,(hl)
    inc hl
    ld a,(hl)
    bit 0,a
    jp z,lab1522
    push af
    ld (lab14BC+1),hl
lab1482 inc hl
    ld a,(hl)
    ld d,a
    and 192
    jp nz,lab14F6
    ld a,(lab0046)
    and 3
    cp 3
    ld a,(hl)
    ld d,b
lab1493 ld b,15
    jr z,lab14EC
    bit 3,a
    jr nz,lab14EC
    and 6
    jr nz,lab14A7
    ld a,r
    and 14
    jr nz,lab14EC
    jr lab14BB
lab14A7 bit 2,a
    jr z,lab14BB
    bit 1,a
    ld a,(lab13E5)
    jr nz,lab14B7
    rra 
    jr nc,lab14BB
    jr lab14EC
lab14B7 and 3
    jr nz,lab14EC
lab14BB push hl
lab14BC ld hl,lab0000
    dec hl
lab14C0 inc c
lab14C1 ld a,(bc)
    cp 7
    jr z,lab14C0
    cp 253
    jr c,lab14EA
    jr z,lab14E5
    inc a
    jr z,lab14DB
    inc c
    push hl
    ld l,c
    ld h,b
    call lab15FD
    ld c,l
    ld b,h
    pop hl
    jr lab14C1
lab14DB ld a,r
    and 14
    jr z,lab14E5
    inc c
    inc c
    jr lab14C1
lab14E5 inc c
    ld a,(bc)
    ld c,a
    jr lab14C1
lab14EA ld (hl),c
    pop hl
lab14EC ld a,(bc)
    cp 7
    jr z,lab14BB
    ld c,a
    ld b,d
    ld d,(hl)
    jr lab151C
lab14F6 bit 6,a
    jr z,lab1519
    bit 7,a
    jr z,lab1511
    ld a,(hl)
lab14FF and 30
    add a,0
    push de
    ld e,a
    ld d,13
    inc hl
    ld a,(hl)
    ld (de),a
    inc e
    inc hl
    ld a,(hl)
    ld (de),a
    pop de
    jr lab151C
lab1511 ld a,(hl)
    rra 
    rra 
    and 3
    ld e,a
    jr lab151C
lab1519 call lab160C
lab151C bit 0,d
    jp nz,lab1482
    pop af
lab1522 inc hl
    ld d,a
    push de
    ex de,hl
    and 30
lab1528 add a,0
    ld l,a
    ld h,13
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ex de,hl
    ld a,c
    exx
lab1534 ld hl,lab0B18
    call lab15E0
    ld a,(hl)
    or a
    jp p,lab156C
    inc hl
    ld c,a
    and 15
    jr z,lab155C
    ld b,a
    ld d,13
lab1548 ld a,(hl)
    add a,0
    ld e,a
    inc hl
    exx
    ld a,e
    exx
    add a,(hl)
    ld (de),a
    inc e
    inc hl
    exx
    ld a,d
    exx
    add a,(hl)
    ld (de),a
    inc hl
    djnz lab1548
lab155C bit 4,c
    jr z,lab156C
    ld a,(hl)
    exx
    add a,e
    ld e,a
    exx
    inc hl
    ld a,(hl)
    inc hl
    exx
    add a,d
    ld d,a
    exx
lab156C exx
    pop bc
    push hl
    exx
    push hl
    exx
    pop hl
    ld a,(lab0046)
    or a
    jp p,lab1588
    inc hl
    ld a,(hl)
    dec hl
    add a,7
    and 56
    add a,e
    neg
    ld e,a
    ld a,(lab0046)
lab1588 bit 6,a
    jr z,lab1593
    ld a,d
    neg
    ld d,a
    ld a,(lab0046)
lab1593 xor b
    ld (lab0046+1),a
    ld a,c
    ld (lab0046+2),a
lab159B ld a,0
lab159D ld bc,lab0000
    add a,e
    ld e,a
    sra a
    sra a
    sra a
    add a,c
    ld c,a
    ld a,d
    add a,b
    ld b,a
    ld a,e
lab15AE and 7
lab15B0 call lab165B
    dec (ix-3)
    pop hl
    jp nz,lab1474
    ret 
lab15BB ld e,a
lab15BC ld a,0
    cp 203
    jr nc,lab15CC
    push de
    push bc
    push af
    ld a,e
    call lab165B
    pop af
    pop bc
    pop de
lab15CC ld hl,lab0B18
    call lab15E0
    inc hl
    ld a,(hl)
    call lab6790
    inc hl
    ld a,(hl)
    add a,b
    ld b,a
    inc hl
    ld a,e
    jp lab165B
lab15E0 push de
    push bc
    ld d,a
    and 248
    add a,l
    ld l,a
    ld e,(hl)
    inc l
    ld a,d
    ld d,(hl)
    and 7
    jr z,lab15F9
    ld b,a
    ld a,e
lab15F1 inc l
    add a,(hl)
    jr nc,lab15F6
    inc d
lab15F6 djnz lab15F1
    ld e,a
lab15F9 ex de,hl
    pop bc
    pop de
    ret 
lab15FD ld a,(hl)
    inc hl
lab15FF ex af,af''
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld a,(hl)
    inc hl
    ld (bc),a
    ex af,af''
lab1608 dec a
    jr nz,lab15FF
    ret 
lab160C push bc
    push de
    ld a,(hl)
    rra 
    and 15
lab1612 ld b,a
    ld a,(lab0046+2)
    push af
    ld a,e
    ld (lab0046+2),a
lab161B push bc
    inc hl
    ld a,(hl)
    add a,a
    jr c,lab1637
    sra a
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    push hl
    ex de,hl
    call labAE0C
lab162C pop hl
    pop bc
    djnz lab161B
    pop af
lab1631 ld (lab0046+2),a
    pop de
    pop bc
    ret 
lab1637 sra a
    ld c,a
    inc hl
    ld e,(hl)
    ld d,0
    bit 7,e
    jr z,lab1643
    dec d
lab1643 push hl
lab1644 ld hl,(lab13E6)
    add hl,de
    ex (sp),hl
    inc hl
    ld a,(lab13E8)
    add a,(hl)
    ld b,a
    ld a,(lab13E9)
    add a,c
    ld c,a
    ex (sp),hl
    ex de,hl
    call labAEDB
    jr lab162C
lab165B ld ix,lab0046+2
    ld e,(ix-1)
    ld (lab1709+1),a
    bit 7,e
    jr z,lab166D
    cpl 
    and 7
    inc a
lab166D ld (lab186D+1),a
    ld (lab193D+1),a
    inc a
    ld (lab1A74+1),a
    ld a,e
    and 224
    ld e,a
    ld a,(lab0046+2)
    add a,a
    bit 7,e
    jr z,lab1684
    inc a
lab1684 add a,a
    add a,a
    add a,a
    add a,198
    ld (lab1A9C+1),a
    ld a,(hl)
    or a
    ret z
    bit 6,e
    jr z,lab16C8
    ld d,20
    ld a,b
    or a
    jp p,lab16AF
    add a,(hl)
    ret m
    ret z
    dec a
    ret z
    inc a
    ld (lab004A),a
    ld a,b
    neg
    ld (lab0049),a
    ld b,0
    set 1,e
    jr lab16F5
lab16AF ld a,(hl)
    ld (lab004A),a
    add a,b
    sub 128
    jr c,lab16F5
    ld (lab0049),a
    neg
    add a,(hl)
    ld (lab004A),a
    ret z
    dec a
    ret z
    set 0,e
    jr lab16F5
lab16C8 sub 2
    ld d,0
    cp b
    ld a,(hl)
    jr c,lab16DB
    sub b
    dec a
    ld (lab0049),a
    ld a,b
    or a
    ret z
    inc a
    set 0,e
lab16DB ld (lab004A),a
    ld a,b
lab16DF cp 128
    jr c,lab16F5
lab16E3 ld b,127
    sub b
    cp (hl)
    ret nc
    ld (lab0049),a
    sub (hl)
    neg
    ld (lab004A),a
    dec a
    ret z
    set 1,e
lab16F5 ld a,d
    ld (lab87D3+1),a
    inc hl
    ld a,(hl)
    dec a
    and 7
    ld d,a
    bit 7,e
    jr z,lab1708
    cpl 
    and 7
    jr lab1709
lab1708 xor a
lab1709 add a,0
    add a,d
    ld d,0
    bit 3,a
    jr nz,lab1713
    inc d
lab1713 ld a,(hl)
    ld (lab17EA+1),hl
    and 63
    add a,15
lab171B and 56
    rra 
    rra 
    rra 
    ld (lab004B),a
    dec a
    ld (lab004F),a
    ld l,a
    ld a,c
    cp 32
    jr c,lab174A
    neg
    ld (lab004C),a
    inc l
    sub l
    ret nc
    neg
    ld (lab004B),a
    ld c,0
    set 2,e
    set 4,e
    bit 7,e
    jr z,lab1768
    res 2,e
    set 3,e
    jr lab1768
lab174A add a,l
    sub 32
    jr c,lab1768
    inc a
    ld (lab004C),a
    dec a
    sub l
    neg
    ld (lab004B),a
    ld d,0
    set 4,e
    set 3,e
    bit 7,e
    jr z,lab1768
    res 3,e
    set 2,e
lab1768 ld a,(lab004B)
    sub d
    ret z
    ld (ix-1),e
    ld a,(lab004B)
    bit 4,e
    jr z,lab1778
    inc a
lab1778 ld hl,lab0ED5
    add a,a
    add a,a
    add a,l
    ld l,a
    ld a,(hl)
    ld (lab1A5D+1),a
    inc l
    ld a,(hl)
    ld (lab1A8C+1),a
    bit 4,e
    jr z,lab179F
    bit 3,e
    jr nz,lab1795
    dec l
    dec l
    dec l
    jr lab17A0
lab1795 xor a
    ld (lab1AFF),a
    ld (lab1AFA),a
    ld (lab1B73),a
lab179F inc l
lab17A0 ld a,(hl)
    ld (lab1A9E+1),a
    inc l
    ld a,(hl)
    ld (lab1B15+1),a
    bit 7,e
    jr z,lab17B2
    ld a,117
    ld (lab1A9E+1),a
lab17B2 ld hl,lab0000
    bit 4,e
    jr z,lab17BD
    ld l,(ix+4)
    dec l
lab17BD ld (lab1B07+1),hl
    push bc
    ld a,(lab004A)
    bit 6,e
    jr z,lab17DB
    add a,b
    ld b,a
    dec b
    ld a,(lab004A)
    bit 0,e
    jr nz,lab17D4
    dec a
    dec b
lab17D4 ld d,a
    bit 1,e
    jr nz,lab17E7
    jr lab17E6
lab17DB bit 1,e
    jr nz,lab17E1
    dec a
    dec b
lab17E1 ld d,a
    bit 0,e
    jr nz,lab17E7
lab17E6 dec d
lab17E7 ld (ix+6),d
lab17EA ld hl,lab0000
    pop bc
    ex de,hl
    call lab87B7
    bit 7,(ix-1)
    jr z,lab17FF
    ld a,(ix+3)
    add a,a
    add a,l
    dec a
    ld l,a
lab17FF ex de,hl
lab1800 push de
    bit 7,(hl)
    jp z,lab19DF
    exx
    ld h,11
    ld bc,lab0008
    exx
    ld a,(lab004B)
lab1810 ex af,af''
    xor a
    bit 2,(ix-1)
    jr z,lab181B
    ld a,(lab004C)
lab181B bit 6,(hl)
    inc hl
    jp z,lab18EB
    ld (lab18C6+1),a
    or a
    ex af,af''
    ld (lab1863+1),a
    ld a,44
    ld b,230
    bit 7,(ix-1)
lab1831 jr z,lab1836
    inc a
    ld b,238
lab1836 ld (lab187A),a
    ld (lab187B),a
    ld (lab18A3),a
    ld (lab189A),a
    ld (lab18C0),a
    bit 1,(ix-1)
    jr z,lab1851
    ld e,(ix+1)
    ld d,0
    add hl,de
lab1851 bit 5,(ix-1)
    jr z,lab1860
    ld e,(ix+2)
    ld d,0
    add hl,de
    jp lab18D6
lab1860 ex de,hl
    pop hl
    push hl
lab1863 ld a,0
    ld iyh,a
    ld a,(de)
    or a
    jr z,lab18CB
    and 7
lab186D add a,0
    push hl
    cp 8
    jr c,lab1880
    sub 8
    ex af,af''
    jr nz,lab18E6
    ex af,af''
lab187A inc l
lab187B inc l
    dec iyh
    jr z,lab18C6
lab1880 exx
    ld iyl,a
    or b
    ld l,a
    ld a,(hl)
    exx
    ld c,a
    ld a,(de)
    rra 
    rra 
    rra 
    and 31
    add a,iyl
lab1890 sub 8
    jr c,lab18B0
    ex af,af''
    jr nz,lab18AA
    ld a,(bc)
    and (hl)
    ld (hl),a
lab189A inc l
    inc b
    ld a,(bc)
    and (hl)
    ld (hl),a
    dec b
    xor a
    ld c,a
    ex af,af''
lab18A3 inc l
    dec iyh
    jr nz,lab1890
    jr lab18C6
lab18AA dec a
    ex af,af''
    ld c,0
    jr lab1890
lab18B0 add a,8
    exx
    or c
    ld l,a
    ld a,(hl)
    exx
    or c
    ex af,af''
    jr nz,lab18C6
    ex af,af''
    ld c,a
    ld a,(bc)
    and (hl)
    ld (hl),a
lab18C0 inc l
    inc b
    ld a,(bc)
    and (hl)
    ld (hl),a
    dec b
lab18C6 ld a,0
    or a
    ex af,af''
    pop hl
lab18CB inc de
    call lab87D3
    dec (ix+2)
    jp nz,lab1863
    ex de,hl
lab18D6 bit 0,(ix-1)
    jp z,lab1A20
    ld d,0
    ld e,(ix+1)
    add hl,de
    jp lab1A20
lab18E6 dec a
    ex af,af''
    jp lab1880
lab18EB ld (lab19B4+1),a
    or a
    ex af,af''
    ld (lab1937+1),a
    ld a,44
    ld b,230
    bit 7,(ix-1)
    jr z,lab1900
    inc a
    ld b,238
lab1900 ld (lab194E),a
    ld (lab194F),a
    ld (lab197E),a
    ld (lab1975),a
    ld (lab19A9),a
    bit 1,(ix-1)
    call nz,lab19D2
    bit 5,(ix-1)
    jr z,lab1925
    ld c,(ix+2)
    call lab19D5
    jp lab19BF
lab1925 xor a
    bit 2,(ix-1)
    jr z,lab1930
    ld a,(lab004C)
    or a
lab1930 ld (lab19B4+1),a
    ex af,af''
    ex de,hl
    pop hl
    push hl
lab1937 ld a,0
    ld iyh,a
    ld a,(de)
    inc de
lab193D add a,0
    ld c,255
    push hl
lab1942 cp 8
    jr c,lab195D
    sub 8
    ex af,af''
    jr nz,lab1957
    ex af,af''
    ld c,255
lab194E inc l
lab194F inc l
    dec iyh
    jp nz,lab1942
    jr lab19C9
lab1957 dec a
    ex af,af''
    ld c,255
    jr lab1942
lab195D exx
    ld iyl,a
    or b
    ld l,a
    ld a,(hl)
    exx
    and c
    ld c,a
    ld a,(de)
    res 7,a
    add a,iyl
lab196B sub 8
    jr c,lab198B
    ex af,af''
    jr nz,lab1985
    ld a,(bc)
    and (hl)
    ld (hl),a
lab1975 inc l
    inc b
    ld a,(bc)
    and (hl)
    ld (hl),a
    dec b
    xor a
    ld c,a
    ex af,af''
lab197E inc l
lab197F dec iyh
    jr nz,lab196B
    jr lab19C9
lab1985 dec a
    ex af,af''
    ld c,0
    jr lab196B
lab198B add a,8
    exx
    ld iyl,a
    or c
    ld l,a
    ld a,(hl)
    exx
    or c
    ld c,a
    ld a,(de)
    or a
    jp p,lab19A3
    inc de
    ld a,(de)
    inc de
    add a,iyl
    jp lab1942
lab19A3 ex af,af''
    jr nz,lab19AF
    ld a,(bc)
    and (hl)
    ld (hl),a
lab19A9 inc l
    inc b
    ld a,(bc)
    and (hl)
    ld (hl),a
    dec b
lab19AF pop hl
    call lab87D3
    inc de
lab19B4 ld a,0
    or a
    ex af,af''
    dec (ix+2)
    jp nz,lab1937
    ex de,hl
lab19BF bit 0,(ix-1)
    call nz,lab19D2
    jp lab1A20
lab19C9 ld a,(de)
    or a
lab19CB jp p,lab19AF
    inc de
    inc de
    jr lab19C9
lab19D2 ld c,(ix+1)
lab19D5 inc hl
    bit 7,(hl)
    inc hl
    jr nz,lab19D5
    dec c
    jr nz,lab19D5
    ret 
lab19DF bit 6,(hl)
    inc hl
    jp z,lab1A20
    ld a,(lab004A)
    ld iyh,a
    ld a,255
    ld (lab1A71+1),a
    ld a,182
    ld d,166
    call lab1B88
    inc (ix+1)
    pop de
    push de
    call lab1A45
    ld a,166
    ld d,182
lab1A02 call lab1B88
    xor a
    ld (lab1A71+1),a
    bit 3,(ix-1)
    jr nz,lab1A16
    ld bc,(lab1B07+1)
    or a
    sbc hl,bc
lab1A16 bit 0,(ix-1)
    call nz,lab1B7B
    dec (ix+1)
lab1A20 ld a,(lab004E)
    ld iyh,a
    pop de
    bit 1,(ix-1)
    jr nz,lab1A31
    ex de,hl
    call lab87D3
    ex de,hl
lab1A31 call lab1A45
    bit 3,(ix-1)
    ret z
    ld a,119
    ld (lab1AFF),a
    ld (lab1AFA),a
    ld (lab1B73),a
    ret 
lab1A45 bit 1,(ix-1)
    call nz,lab1B7B
    bit 2,(ix-1)
    jr z,lab1A59
    ld b,0
    ld c,(ix+4)
    dec c
    add hl,bc
lab1A59 ld (lab1A94+1),de
lab1A5D jr lab1A5D
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    push hl
    ld h,(hl)
    ld l,b
lab1A71 ld a,0
    rlca 
lab1A74 ld b,0
    jp lab1A8C
    exx
    rr e
    exx
    exx
    rr d
    exx
    rr e
    rr d
    rr c
    rr l
    rr h
    rra 
lab1A8C djnz lab1A8C
    ld b,l
    ld (lab1AF6+1),a
    ld a,h
    ex af,af''
lab1A94 ld hl,lab0000
    push hl
    ld ixl,e
    ld ixh,d
lab1A9C ld d,230
lab1A9E jr lab1AF6
    exx
    ld a,e
    exx
    ld e,a
lab1AA4 ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    exx
    ld a,d
    exx
    ld e,a
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    ld e,ixl
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    ld e,ixh
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    ld e,c
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    ld e,b
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
    ex af,af''
    ld e,a
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    inc l
    dec d
lab1AF6 ld e,0
lab1AF8 ld a,(de)
    or (hl)
lab1AFA ld (hl),a
    inc l
    inc d
    ld a,(de)
    or (hl)
lab1AFF ld (hl),a
lab1B00 pop hl
lab1B01 call lab87D3
    ex de,hl
    pop hl
    inc hl
lab1B07 ld bc,lab0000
lab1B0A add hl,bc
    dec iyh
    jp nz,lab1A59
    ld ix,lab0046+2
    ret 
lab1B15 jr lab1B15
    exx
    ld a,e
    exx
    ld e,a
lab1B1B ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
lab1B20 ld a,(de)
    or (hl)
    ld (hl),a
lab1B23 dec l
    dec d
    exx
    ld a,d
    exx
    ld e,a
    ld a,(de)
lab1B2A or (hl)
lab1B2B ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
    ld e,ixl
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
lab1B3F ld e,ixh
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
    ld e,c
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
    ld e,b
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
    ex af,af''
    ld e,a
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    ld (hl),a
    dec l
    dec d
    ld a,(lab1AF6+1)
    ld e,a
    ld a,(de)
    or (hl)
lab1B73 ld (hl),a
    dec l
    inc d
    ld a,(de)
    or (hl)
    jp lab1AFF
lab1B7B ld a,(lab0049)
    ld b,0
    ld c,(ix+7)
lab1B83 dec a
    ret z
    add hl,bc
    jr lab1B83
lab1B88 push hl
    ld hl,lab1AA4
    bit 7,(ix-1)
    jr z,lab1B95
    ld hl,lab1B1B
lab1B95 ld b,7
    ld (hl),d
lab1B98 inc hl
    cp (hl)
    jr nz,lab1B98
    ld (hl),d
    djnz lab1B98
    pop hl
    ret 
lab1BA1 ld a,128
lab1BA3 ld (lab16DF+1),a
    dec a
    ld (lab16E3+1),a
    ret 
lab1BAB ld hl,lab13D4
    ld b,(hl)
lab1BAF inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    res 6,(hl)
    ex de,hl
    djnz lab1BAF
    ret 
    cp e
lab1BBB ld a,(lab0117+2)
    cp 2
    ret z
    cp 6
    jr z,lab1BC9
    cp 9
    jr nz,lab1BDD
lab1BC9 ld hl,(lab8FFA)
    ld de,lab098D
    or a
    sbc hl,de
    jr c,lab1BF7
    ld de,lab006C
    or a
    sbc hl,de
    jr nc,lab1BF7
    ret 
lab1BDD cp 5
    jr z,lab1BE5
    cp 8
    jr nz,lab1BF7
lab1BE5 ld hl,(lab8FFA)
    ld de,lab0AE7+1
    cp 5
    jr z,lab1BF3
    ex de,hl
    ld hl,lab08AC
lab1BF3 or a
    sbc hl,de
    ret nc
lab1BF7 ld hl,lab338A
    ld bc,lab101D
lab1BFD ld a,1
    ld (lab0046+2),a
    xor a
    ld (lab0046+1),a
lab1C06 call lab165B
    ld a,(lab0117+2)
    cp 1
    jr z,lab1C29
    cp 4
    jr z,lab1C17
    cp 7
    ret nz
lab1C17 ld hl,(lab8FFA)
    ld de,lab0A02
    cp 4
    jr z,lab1C25
    ex de,hl
    ld hl,lab0991+1
lab1C25 or a
    sbc hl,de
    ret c
lab1C29 ld hl,lab33AA+2
    ld bc,lab801D
    ld a,(lab13E5)
    rra 
    jr nc,lab1C3A
    ld a,128
    ld (lab0046+1),a
lab1C3A xor a
    jp lab165B
lab1C3E xor a
    ld (lab13E8),a
    ld hl,(lab13ED)
    ld de,(lab13F0+1)
    exx
    ld hl,(lab13EB)
    ld de,(lab13EF)
    ld ix,lab0178
lab1C55 ld (lab13E9),a
    ld c,a
    call lab8F8F
    ld a,c
lab1C5D call lab0000
    ld c,a
    call lab1C7F
    exx
    ld c,a
    call lab1C7F
    exx
    ld bc,labE6AA
    add ix,bc
    jr c,lab1C76
    ld bc,lab02EF+1
    add ix,bc
lab1C76 ld a,(lab13E9)
    inc a
    cp 12
    jr nz,lab1C55
    ret 
lab1C7F ld a,(hl)
lab1C80 and 15
    cp c
    ld a,c
    jr z,lab1C8C
    ld bc,lab0BC0
    add ix,bc
    ret 
lab1C8C push af
    ld a,(iy+3)
    push af
lab1C91 ld a,(hl)
    bit 7,a
    jr z,lab1C9D
    inc hl
    ld a,(hl)
    ld (iy+3),a
    inc hl
    ld a,(hl)
lab1C9D rra 
lab1C9E rra 
    rra 
    rra 
    and 7
    ld c,a
    inc hl
    ld b,3
lab1CA7 call lab1CD5
    djnz lab1CA7
    ld a,(lab13EA)
    rra 
    jr nc,lab1CBC
    push bc
    ld bc,lab02EF+1
    add ix,bc
    inc de
    pop bc
    jr lab1CBF
lab1CBC call lab1CD5
lab1CBF ld b,0
    add hl,bc
    ld a,(hl)
    cp 192
    jr nz,lab1CCF
    inc hl
    ld bc,labF440
    add ix,bc
    jr lab1C91
lab1CCF pop af
    ld (iy+3),a
    pop af
    ret 
lab1CD5 inc e
    ld a,(de)
    and 192
    ld a,(de)
    push de
    jr z,lab1D11
    and 15
lab1CDF cp c
    jr c,lab1CE5
    sub c
    jr lab1CDF
lab1CE5 push hl
    add a,l
    ld l,a
    jr nc,lab1CEB
    inc h
lab1CEB ld a,(hl)
    push ix
    pop de
    push de
    ld (lab13E6),de
    or a
    jp p,lab1D05
    and 127
    ld hl,lab0B18
    call lab15E0
    call lab1D34
    jr lab1D0E
lab1D05 ld hl,lab0CBD
    call lab15E0
    call lab1D18
lab1D0E pop ix
    pop hl
lab1D11 ld de,lab02EF+1
    add ix,de
    pop de
    ret 
lab1D18 push de
    push bc
    exx
    push hl
    push de
    exx
    push iy
    push hl
    call lab8F45
    pop hl
    ld b,(iy+3)
lab1D28 call nc,lab1446
lab1D2B pop iy
    exx
    pop de
    pop hl
    exx
    pop bc
    pop de
    ret 
lab1D34 push de
    push bc
    exx
    push hl
    ld bc,lab8000
    push de
    ld (lab0046+1),bc
    exx
    push iy
    push hl
    call lab8F45
    pop hl
    jr c,lab1D68
    bit 7,(hl)
    jr z,lab1D62
    ex af,af''
    ld a,(hl)
    bit 4,a
    jr z,lab1D56
    inc hl
    inc hl
lab1D56 and 15
    jr z,lab1D60
lab1D5A inc hl
    inc hl
    inc hl
    dec a
    jr nz,lab1D5A
lab1D60 inc hl
    ex af,af''
lab1D62 ld b,(iy+3)
    call lab165B
lab1D68 jr lab1D2B
lab1D6A adc a,d
    dec e
    dec c
    ld e,52
    ld e,95
    ld e,170
    dec e
    dec c
    ld e,52
    ld e,95
    ld e,213
    dec e
    inc sp
    ld e,52
lab1D7F ld e,95
    ld e,242
    dec e
    jr nz,lab1DA4
    inc (hl)
    ld e,95
    ld e,64
    ld b,8
    call c,lab2225+1
    or e
    sub (hl)
    inc h
    or e
    sub (hl)
    dec h
    sbc a,e
    or h
    ld (hl),152
    sub (hl)
    or (hl)
    ld b,a
    sbc a,l
    inc bc
    sbc a,e
    or l
    ld c,b
    sbc a,d
    sbc a,b
lab1DA4 sbc a,(hl)
    or d
    add hl,hl
    sbc a,d
    add a,h
    rrca 
    ld h,b
    ld (bc),a
    ld a,(bc)
    cp l
    ld a,(bc)
    ld (bc),a
    ld h,66
    sub l
    sbc a,e
    or e
    adc a,e
    inc (hl)
    dec bc
    inc c
    sub l
    ld h,(hl)
    inc c
    dec bc
    inc c
    sub l
    sbc a,c
    sbc a,b
    scf
    dec bc
    sbc a,(hl)
    sbc a,b
    ld c,b
    dec c
    ld c,16
    or d
    ld c,c
    djnz lab1DDE
    sbc a,d
    or l
    ld c,d
    ld c,17
    sbc a,d
    sbc a,(hl)
    rrca 
    ld d,b
    nop
    ld bc,lab0005
    dec h
    ld b,h
lab1DDC adc a,e
    sub l
lab1DDE or e
    inc b
    ld b,(hl)
    inc de
    inc d
    sbc a,b
    sub 71
    inc d
    inc de
    sbc a,b
    jp nc,lab8428
    sbc a,d
    add hl,sp
    add a,h
    sbc a,d
    ld (de),a
    rrca 
    ld b,b
    dec d
    jr nz,lab1D7F+1
    adc a,c
    ld (labB395),hl
    ld (hl),h
    dec e
    ld d,24
    dec e
    ld a,(de)
    add hl,de
    dec e
    ld h,(hl)
    add hl,de
    ld d,28
    jr lab1E20+2
    sbc a,b
    add hl,hl
    dec de
    add a,b
    rrca 
    jr nc,lab1E13+2
    add a,b
    ex af,af''
    inc hl
    add a,b
lab1E13 call pe,lab0934+1
    dec bc
    add a,b
    ld (hl),11
    inc c
    add a,b
    daa
    inc c
    add a,b
    rrca 
lab1E20 ld (lab8022),hl
    inc h
    inc h
    add a,b
    dec h
    inc h
    add a,b
    ld h,35
    add a,b
    daa
    inc hl
    add a,b
    jr z,lab1E53+1
    add a,b
    rrca 
    rrca 
    add a,a
    ld b,c
    jr nz,lab1E6B
    ld (lab6488),a
    jr nz,lab1E6E+2
    ld (lab80C0),a
    ld e,32
    ld (lab8933),a
    ld a,b
    jr nc,lab1E76
    ld sp,labC02B+1
    add a,b
    rst 56
    jr nc,lab1E7A+2
    dec hl
    jr nc,lab1DDC
    ld a,b
lab1E53 jr nc,lab1E7F+2
    ld l,49
    ret nz
    add a,b
    rst 56
    jr nc,lab1E8A+2
    dec hl
    dec l
    rrca 
    jr nc,lab1E89
    add hl,hl
    ld hl,(lab1644+1)
    dec e
    jr lab1E86
    scf
    jr lab1E87
lab1E6B ld d,15
    push af
lab1E6E call lab1E89
    jr z,lab1E75
    pop af
    ret 
lab1E75 push hl
lab1E76 push de
    ld de,lab0040
lab1E7A call lab1F2B
    jr nc,lab1E82
lab1E7F call lab1F4A
lab1E82 call lab1F59
    pop de
lab1E86 pop hl
lab1E87 pop af
    ret 
lab1E89 ld c,a
lab1E8A ld a,(lab13E5)
    srl a
    xor c
    bit 0,a
    ret 
    push de
    push hl
    push af
    or a
    jr nz,lab1E9F
    ld hl,lab1F6C
    ld (lab1F69+2),hl
lab1E9F call lab1E89
    jr nz,lab1EDA
    ld de,lab0A47+1
    call lab8F45
    jr c,lab1ECA
    ld a,c
    or a
    jp m,lab1ECC
    add a,2
    cp 32
    jr nc,lab1ED7
    neg
    add a,32
    add a,a
    ld b,a
    ld de,lab003F
lab1EC0 call lab1F2B
    jr nc,lab1ED7
    call lab1F3C
    jr lab1ED7
lab1ECA jr z,lab1EF8
lab1ECC ld de,lab0040
    call lab1F2B
    jr nc,lab1ED7
    call lab1F4A
lab1ED7 call lab1F59
lab1EDA ld de,lab0A47+1
    ld hl,(lab1F69+2)
    inc hl
    ld (lab1F69+2),hl
    ld a,(hl)
    ld hl,lab0B18
    call lab15E0
    inc (iy+3)
    push ix
    call lab1D34
    pop ix
    dec (iy+3)
lab1EF8 pop af
    pop hl
    pop de
    ret 
    push de
    push hl
    push af
    or a
lab1F00 jr nz,lab1F08
    ld hl,lab1F6C
    ld (lab1F69+2),hl
lab1F08 call lab1E89
    jr nz,lab1EDA
    ld de,lab0A47+1
    call lab8F45
    jr c,lab1F27
    ld a,c
    sub 2
    jp m,lab1ED7
    cp 32
    jr nc,lab1ECC
    add a,a
    ld b,a
    inc b
    ld d,0
lab1F24 ld e,a
    jr lab1EC0
lab1F27 jr z,lab1ECC
    jr lab1EF8
lab1F2B ld a,(iy+3)
    cp 128
    ret nc
    push bc
    ld b,a
    ld c,0
    call lab87B7
    add hl,de
    pop bc
    scf
    ret 
lab1F3C ld de,(lab1F69)
lab1F40 ld (hl),e
    dec l
    djnz lab1F45
    ret 
lab1F45 ld (hl),d
    dec l
    djnz lab1F40
    ret 
lab1F4A ld de,(lab1F69)
    ld b,16
lab1F50 sla b
lab1F52 dec hl
    ld (hl),d
    dec l
    ld (hl),e
    djnz lab1F52
    ret 
lab1F59 ld hl,(lab1F69)
    ld a,l
    srl a
    jr nc,lab1F63
    ld a,8
lab1F63 ld l,h
    ld h,a
    ld (lab1F69),hl
    ret 
lab1F69 ld bc,lab0000
lab1F6C nop
    inc e
    dec de
    inc e
    dec e
    dec e
    ld a,(de)
    ld a,(de)
    inc b
    ld e,30
    inc b
    inc b
    ld e,183
    ret nz
    push af
    push hl
    push de
lab1F7F ld bc,lab8000
    call lab87B7
    ld de,lab0F0F
    ld b,11
lab1F8A push bc
    push hl
    ld b,16
    call lab1F50
    pop hl
    call lab87E9
    pop bc
    djnz lab1F8A
    ld hl,lab5444
    jr lab1FA0
lab1F9D ld hl,lab4455
lab1FA0 ld (lab8EB3+1),hl
    pop de
    pop hl
    pop af
    ret 
    cp 10
    ret nz
    push af
    push hl
    push de
    ld de,lab098D-1
    ld hl,lab10D3
    set 7,(hl)
    ld a,35
    jr lab1FC8
    cp 10
    ret nz
    push af
    push hl
    push de
    ld de,lab0B04
    ld hl,lab10D3
    res 7,(hl)
    xor a
lab1FC8 ld (lab1FD7+1),a
    push ix
    push de
    call lab1D18
    pop de
    pop ix
    call lab8F45
lab1FD7 jr lab1FFC
    jr c,lab202E
    rra 
    rra 
    rra 
    ld a,c
    adc a,a
    dec a
    jp m,lab1F7F
    cp 63
    jr nc,lab1F9D
    ld e,a
    ld b,79
    call lab87B7
    ld a,e
    inc a
lab1FF0 inc a
    bit 0,a
    jr nz,lab201A
    inc l
    jr lab201A
lab1FF8 jr z,lab1F7F
    jr lab1F9D
lab1FFC jr c,lab1FF8
    rra 
    rra 
lab2000 rra 
lab2001 ld a,c
    adc a,a
    dec a
    jp m,lab1F9D
    cp 63
    jp nc,lab1F7F
    ld e,a
    ld bc,lab4F1F
lab2010 call lab87B7
    inc l
    ld a,e
    inc a
    neg
lab2018 add a,64
lab201A ld c,a
    ld b,41
    ld de,lab0F0F
lab2020 push bc
lab2021 push hl
lab2022 ld b,c
    call lab1F40
    pop hl
    call lab87E9
    pop bc
    djnz lab2020
    inc b
lab202E jp nz,lab1F7F
lab2031 jp lab1F9D
    or a
    ret nz
    push hl
    push af
    push de
    call lab2040
    pop de
    pop af
    pop hl
    ret 
lab2040 ld de,lab0040
    call lab1F2B
    call lab87D5
    ld b,8
lab204B push bc
    push hl
    ld b,16
    ld de,lab0F0F
    call lab1F50
    pop hl
    call lab87D5
    pop bc
    djnz lab204B
    ret 
    or a
    ret nz
    push af
lab2060 push hl
    push de
    call lab2157
    ld de,lab0A24
    call lab8F45
    jr c,lab2088
    ld a,c
    or a
    jp m,lab20CC
    cp 32
    jr nc,lab20C9
    ld b,0
    push bc
    ld de,lab0000
    call lab1F2B
    pop bc
lab2080 sla c
    inc c
    add hl,bc
    ld b,c
    inc b
    jr lab20B3
lab2088 jr z,lab20C9
    jr lab20CC
    or a
    ret nz
    push af
    push hl
    push de
    call lab2157
    ld de,lab0A6A+2
    call lab8F45
lab209A jr c,lab20C7
    ld a,c
    or a
    jp m,lab20C9
    cp 32
    jr nc,lab20CC
    push af
    ld de,lab003F
    call lab1F2B
    pop af
    add a,a
    neg
    add a,64
    ld b,a
lab20B3 ld c,8
lab20B5 push bc
    call lab87D5
    push hl
    ld de,lab0F0F
    call lab1F40
lab20C0 pop hl
    pop bc
    dec c
    jr nz,lab20B5
lab20C5 jr lab20CC
lab20C7 jr z,lab20CC
lab20C9 call lab2040
lab20CC push iy
    ld iy,lab8FEE
    ld de,lab0A24
    push ix
    ld hl,(lab2474)
    bit 2,(hl)
    jr z,lab20F5
lab20DE ld hl,lab1104
lab20E1 call lab1D18
    ld hl,lab1104
    ld de,lab0A47+1
lab20EA call lab1D18
lab20ED pop ix
    pop iy
    pop de
    pop hl
    pop af
    ret 
lab20F5 inc hl
    ld a,(hl)
    or a
    jr z,lab211A
    ld bc,(lab0103)
    inc b
lab20FF jr z,lab2106
    ld a,c
    cp 230
    jr nc,lab2110
lab2106 ld a,2
lab2108 ld (lab111A),a
    ld hl,lab111A
    jr lab20EA
lab2110 dec (hl)
    ld a,12
    call labB671
    ld a,2
    jr lab2108
lab211A inc hl
    ld a,(hl)
    ld (lab13FE+1),a
    push hl
lab2120 cp 4
    jr c,lab212C
    push de
    ld hl,lab1104
    call lab1D18
    pop de
lab212C ld hl,lab13FE
    ld (lab1D28+1),hl
    ld a,0
lab2134 ld (lab111A),a
    ld a,66
    ld (lab111D+1),a
    ld hl,lab111A
    call lab1D18
    ld hl,lab1446
    ld (lab1D28+1),hl
    pop hl
    ld (hl),a
    jr nz,lab20ED
    dec hl
    dec hl
    set 2,(hl)
    ld a,64
    ld (lab111D+1),a
    jr lab20ED
lab2157 ld de,lab0A24
    call lab21DF
    ld de,lab8A6C
    call lab21DF
    push ix
    push iy
    ld iy,lab8FEE
    ld de,lab0A24
    call lab8F45
    jr c,lab21DA
    ld b,a
    ld a,c
    cp 32
    ld e,64
    jr nc,lab2188
    cp 24
    jr c,lab219D
    add a,a
    add a,a
lab2181 add a,a
    or b
    neg
    ld e,a
    jr lab219D
lab2188 or a
    jp p,lab21DA
    add a,8
    jp m,lab21DA
    add a,a
    add a,a
    add a,a
    or b
    jp z,lab21DA
    ld e,a
    ld b,0
    ld c,0
lab219D ld a,b
    push af
    ld b,115
    call lab87B7
    pop af
    bit 2,a
    jr z,lab21AA
    inc l
lab21AA and 3
    or 0
    ld c,a
    ld b,190
    ld a,(bc)
    ld c,a
    ld b,15
    ld d,115
lab21B7 push hl
    push bc
    push de
    ld d,e
lab21BB ld a,c
    and b
    or (hl)
    ld (hl),a
    rrc c
    jr nc,lab21CE
lab21C3 inc l
    ld a,d
    sub 5
    jr c,lab21CE
    ld d,a
    inc d
    ld (hl),b
    jr lab21C3
lab21CE dec d
    jr nz,lab21BB
    pop de
    pop bc
    pop hl
    call lab87D5
    dec d
    jr nz,lab21B7
lab21DA pop iy
    pop ix
    ret 
lab21DF push de
    ld hl,(lab8FFA)
    bit 7,d
    jr z,lab21EA
    ex de,hl
    res 7,h
lab21EA or a
    sbc hl,de
    pop de
    ret nc
    push iy
    push ix
    push de
    res 7,d
    push de
    ld (lab13E6),de
    ld hl,lab10DF
lab21FE call lab1D18
    pop de
lab2202 push de
    call lab8F45
    pop de
    jp c,lab229E
    ld b,a
    ld a,c
    cp 32
    jp nc,lab229E
    ld a,b
    sla c
    sla c
    sla c
    or c
    push af
    ld iy,lab8FEE
    call lab8F45
lab2221 jr c,lab222C
    ld b,a
    ld a,c
lab2225 cp 32
    ld a,b
    jr c,lab2236
    bit 7,c
lab222C ld c,0
    ld a,0
    jr nz,lab2236
lab2232 ld c,31
    ld a,7
lab2236 ld b,c
    sla c
    sla c
    sla c
    or c
    ld c,a
    pop af
    cp c
    ld de,lab2C07+2
lab2244 jr nc,lab2249
    inc d
    ld e,1
lab2249 ld a,e
    ld (lab228A+1),a
    ld a,d
    ld (lab228E),a
    ld a,c
    push af
    ld c,b
    ld b,128
    call lab87B7
    pop af
    bit 2,a
    jr z,lab225F
    inc l
lab225F and 3
    or 0
    ld c,a
    ld b,190
    ld a,(bc)
    ld c,a
    ld e,128
lab226A call lab87D5
    dec e
    ld a,(hl)
    and c
    jr z,lab226A
    ld b,15
lab2274 call lab87D5
    dec e
    ld a,(hl)
    and c
    jr z,lab2284
    ld a,e
    cp 76
    jp c,lab229E
    jr lab2274
lab2284 push hl
    push bc
lab2286 ld a,c
    and b
    or (hl)
    ld (hl),a
lab228A rlc c
    jr nc,lab2296
lab228E dec l
    ld a,(hl)
    or a
    jr nz,lab2296
    ld (hl),b
    jr lab228E
lab2296 ld a,(hl)
    and c
    jr z,lab2286
    pop bc
    pop hl
    jr lab2274
lab229E pop de
    push de
    ld iy,lab8FC6
    ld hl,lab10F9
    res 7,(hl)
    bit 7,d
    jr z,lab22B1
    res 7,d
    set 7,(hl)
lab22B1 call lab1D18
    pop de
    ld iy,lab8FD8+2
    ld hl,lab10FF+1
    res 7,(hl)
    bit 7,d
    jr z,lab22C6
    set 7,(hl)
    res 7,d
lab22C6 call lab1D18
    pop ix
    pop iy
    ret 
lab22CE ld bc,lab0000
lab22D1 ld a,(lab22CE+1)
    ld e,a
    ld hl,(lab13F4)
    ld a,(lab22CE)
    ld c,a
    ld a,(lab13F2+1)
    bit 7,a
    jr nz,lab22F6
    inc c
    inc e
    call lab2436+1
    cp c
    jr nz,lab2303
    inc l
    call lab2436+1
    ld c,1
    ld (lab13F4),hl
    jr lab2303
lab22F6 dec e
    dec c
    jr nz,lab2303
    dec l
    call lab2436+1
    ld c,a
    dec c
lab2300 ld (lab13F4),hl
lab2303 ld b,a
    ld d,246
    ld a,c
    ld (lab22CE),a
    ld a,e
    ld (lab22CE+1),a
    ld a,(hl)
    and 15
    ld c,a
    ld a,(de)
    and 252
    xor c
    push af
    ld a,(lab22CE)
    inc a
    inc e
    cp b
    jr nz,lab2320
    inc l
lab2320 ld a,(hl)
    and 15
    ld c,a
    ld a,(de)
    and 252
    xor c
    pop bc
    ld c,a
    push bc
    ld a,b
    ld (lab13EF),a
    and 15
    ld e,a
    and 3
    ld b,a
    ld a,c
    ld c,0
    ld (lab13F0+1),a
    and 15
    ld d,a
    and 3
    cp b
    jr z,lab234C
    inc c
    or a
    jr nz,lab234A
    ld a,b
    add a,3
lab234A add a,3
lab234C ld (lab0117+2),a
    add a,a
    ld hl,lab2423
    add a,l
    ld l,a
    jr nc,lab2358
    inc h
lab2358 ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (lab1C5D+1),hl
    ld a,c
    ld (lab13EA),a
    ld a,e
    call lab2415
    ld (lab13EB),hl
    ld a,d
    call lab2415
    ld (lab13ED),hl
    pop bc
    ld a,b
    or c
    and 3
    cp 3
    jr z,lab23D2
lab237A ld a,0
    or a
    jr z,lab2390
    xor a
    ld (lab237A+1),a
    ld a,(lab13F2+1)
    add a,a
    jr nc,lab2390
    ld a,(lab2473)
    dec a
    ld (lab2473),a
lab2390 ld a,b
    and 3
    xor c
    and 3
    ld (lab2472),a
    ret nz
    ld a,(lab246F+2)
    or a
    ret nz
    ld a,(lab22CE+1)
    ld (lab22CE+2),a
    ld a,(lab22CE)
    add a,a
    add a,a
    and 12
    xor b
    and 15
    ld hl,lab2441
    call labA6F9
    ld (lab246F+2),a
    ld hl,lab0000
    ld (lab13F6),hl
lab23BE ld hl,lab244F+2
    add a,a
    call labA6F8
    inc hl
    ld d,(hl)
    ld e,a
    ld (lab7AB7+1),de
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp (hl)
lab23D2 ld a,(lab237A+1)
    or a
    jr nz,lab2390
    inc a
    ld (lab237A+1),a
    ld a,(lab13F2+1)
lab23DF bit 7,a
    ld a,(lab2473)
    jr nz,lab23E7
    inc a
lab23E7 ld (lab2473),a
    ld hl,lab2476
    push bc
    ld b,3
lab23F0 cp (hl)
    jr z,lab23FA
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    djnz lab23F0
lab23FA inc hl
    ld (lab2474),hl
    pop bc
    inc hl
    inc hl
lab2401 inc hl
    ld a,(hl)
    or a
    jr z,lab2390
    ld (lab6D83+1),a
    ld hl,lab6CB3
    ld (lab7ABA+1),hl
    call lab6C8E
    jp lab2390
lab2415 ld hl,lab1D6A
    add a,a
    add a,l
    ld l,a
    jr nc,lab241E
    inc h
lab241E ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
lab2422 ret 
lab2423 ld (lab6D23+1),hl
    ld e,122
    rra 
    inc (hl)
    jr nz,lab23BE+1
    ld e,185
lab242E rra 
    adc a,h
    jr nz,lab242E
    ld e,167
    rra 
    ld e,l
lab2436 jr nz,lab24B6
    rra 
    rra 
    rra 
    rra 
    and 15
    inc a
    inc a
    ret 
lab2441 inc bc
    dec b
    ld b,2
    rlca 
    dec b
    ld b,2
    inc bc
    dec b
    ld bc,lab0402
    dec b
lab244F ld bc,lab2202
    inc h
    ld (lab4724),hl
    ld a,b
    jr nz,lab24D1
    or b
    ld l,(hl)
    ld c,d
    ld l,(hl)
    or b
    ld l,(hl)
    ld b,a
    ld l,(hl)
    ld c,e
    ld (hl),c
    jp m,lab7B6F+1
    ld l,c
    ld c,c
    ld l,c
    ld e,l
    ld l,e
lab246B add hl,hl
    ld l,e
    ld c,e
    ld (hl),c
lab246F call pe,lab0070
lab2472 nop
lab2473 nop
lab2474 nop
    nop
lab2476 ld bc,lab2001
    nop
lab247A nop
    ld (bc),a
    ld (bc),a
    jr nc,lab247F
lab247F inc bc
lab2480 inc bc
    inc bc
    ld e,d
    nop
lab2484 inc c
    nop
    inc b
    nop
    nop
    nop
lab248A xor a
    ld (lab2473),a
    ld hl,lab24B7
    ld de,lab2476
    ld bc,lab0013+1
    ldir
lab2499 ld a,(labB601)
    ld b,a
    add a,3
    ld (lab2484),a
    ld a,b
    srl a
    ld (lab247F),a
lab24A8 srl a
    ld (lab247A),a
    ld a,b
    cp 6
    ret c
    ld a,4
    ld (lab2480),a
lab24B6 ret 
lab24B7 ld bc,lab2001
    nop
    nop
    ld (bc),a
    ld (bc),a
    jr nc,lab24C0
lab24C0 inc bc
    inc bc
    inc bc
    ld e,d
    nop
    inc c
    nop
    inc b
    nop
    nop
    nop
    nop
    add a,c
    ld (bc),a
    djnz lab24D0
lab24D0 rrca 
lab24D1 djnz lab24A8
    ld e,a
    ld l,d
    cp a
    dec h
    cp 19
    rst 56
    dec bc
    call m,labFC0D
    ld b,252
    inc bc
    ld a,h
    ld bc,lab019D+1
    ld c,a
    nop
    rst 32
    nop
    ld (hl),e
    nop
    ld bc,lab0280+1
    jr lab24F0
lab24F0 add hl,bc
    jr lab2499+2
    nop
    xor d
    ld d,h
    nop
    ld (hl),a
    and b
    nop
    inc e
    ld d,b
    ccf 
    call nc,labC0BF
    dec h
    ld b,b
    nop
    ld (bc),a
    nop
    nop
    ld bc,lab0280+2
    jr lab250B
lab250B inc b
    nop
    rst 40
    inc de
    ret c
    nop
    ret nz
    ret nz
    ret nz
    cp b
    or b
    xor b
    xor b
    xor b
    and b
    sbc a,b
    sub b
    sub b
    sub b
    sub b
    adc a,b
    adc a,b
    ld h,b
    ld e,b
    cp a
    cp a
lab2525 and l
lab2526 sbc a,223
    ld e,d
    ld l,a
    ld l,(hl)
    xor h
    sbc a,e
    or l
    jr lab24B7+2
    ld e,e
    sub b
    add a,a
    xor a
    ret nc
    ld c,e
    rst 16
    ret nc
    sub (hl)
    xor e
    ret po
    xor l
    ld a,l
    ret nz
    ld e,d
    adc a,(hl)
    add a,b
    cp a
    rra 
    add a,b
    cp (hl)
    cpl 
    add a,b
    ld c,h
    ld (hl),a
    add a,b
    ld (hl),235
    nop
    ld l,e
    pop de
    nop
    rst 16
    ret po
    nop
    cp e
    ret nz
    nop
    sub b
    ret p
    nop
    dec bc
    and a
    add hl,bc
    djnz lab2564+1
    ld (de),a
    inc b
    ld e,1
    ld h,0
lab2564 jr z,lab2566
lab2566 jr z,lab2568
lab2568 jr z,lab256A
lab256A jr z,lab256C+1
lab256C ld h,3
    ld (lab1608),hl
    nop
    ccf 
    sbc a,l
    nop
    nop
    nop
    push de
    ld c,(hl)
    nop
    nop
    rlca 
    dec hl
    rst 56
    ex (sp),hl
    add a,b
lab2580 jr c,lab2580
    xor e
    cp (hl)
    ld a,h
    ld e,a
    ld d,l
    rst 56
    sbc a,a
    xor 106
    xor e
    rst 56
    jp z,lab3F86
    rst 56
    rst 56
    rst 56
    call m,labFF0F
    rst 56
    rst 56
    ret p
    nop
    ld a,a
    ret p
    ret m
    nop
    sub b
    cp 0
    dec de
    rrca 
    cpl 
    ret p
    dec l
    ret p
    inc h
    ret po
    inc d
    ret po
    inc d
    ret po
    ld d,96
    ld d,96
    rla 
    ret po
    rla 
    ret po
    rla 
    ret po
    rla 
    ret po
    rla 
    ld h,b
lab25BB ld d,32
    dec d
    ld (hl),b
    ld l,a
    ld a,b
    sbc a,a
    call m,lab3C9C
    sbc a,118
    cp (hl)
    call p,labEC3F
    rla 
    ret c
    inc hl
    or b
    ld a,(lab05F0)
    ld b,b
    rlca 
    nop
    add a,e
    ld (bc),a
    jr nz,lab25D9
lab25D9 inc b
    dec bc
    jp (hl)
    ld b,27
    call pe,labE018+1
    nop
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ld sp,hl
    ld sp,hl
    ld sp,hl
    jp p,labD6EB
    sub 214
    sub 207
    rst 8
    rst 8
    jp m,labFFEF
lab25FD ret nz
    adc a,l
    ld d,l
    push af
    or c
    sbc a,202
    ld a,b
    ex (sp),hl
    rst 56
lab2607 ld h,a
    inc l
    ld a,a
    push af
    or e
    and 63
    ld a,d
    sub 239
    sbc a,a
    or a
    ld l,a
    ld e,a
    db 253
    db 90
    adc a,e
    cp d
    ret m
    xor l
    ld a,l
    ld (ix+87),b
    xor (hl)
    jp pe,labAEB2
    call nc,lab7A75
    dec (hl)
    cp 122
    cp b
    ld l,221
    dec a
    ld d,d
    dec (hl)
    ld l,(hl)
    sbc a,(hl)
    and (hl)
    ld a,(de)
    or a
    ld l,a
    rst 24
    add hl,bc
    ld e,e
    cp a
    rst 56
    ld bc,labDD5F
    ld b,a
    ld bc,labEE36+1
    daa
    ld bc,labDE9F
    daa
    ld bc,labEEDA
    daa
    nop
    in a,(126)
    ld e,0
    ld c,c
    ld d,h
    ld b,0
    ld l,c
    xor b
    ld b,129
    ld (bc),a
    dec c
    nop
    rlca 
    dec c
lab265C ld d,b
    ld c,b
    cpl 
    ret m
    dec h
    ret p
    rlca 
    and b
    inc bc
    nop
    add a,c
    ld (bc),a
    jr lab266A
lab266A ld d,24
    call nc,lab699A
    call m,lab4996
    ld c,d
    ld a,(de)
    ld a,a
    dec h
    ld (hl),105
    dec hl
    ld l,d
    ld a,d
    rra 
    or (hl)
    ld b,h
    nop
    ld hl,(lab0040)
    ld (hl),64
    nop
    ld hl,(lab00C0)
    scf
    ld b,b
    nop
    ld hl,(lab00C0)
    ld (hl),64
    nop
    ld hl,(lab0040)
    ld (hl),64
    nop
    dec a
    ret nz
    nop
    dec d
    ld b,b
    nop
    ld a,(bc)
    add a,b
    nop
    dec b
    nop
    nop
    dec b
    nop
    nop
    ld (bc),a
    nop
    add a,c
    ld (bc),a
    jr z,lab26AC
lab26AC ld de,lab0628
    xor l
    ld a,(de)
    add a,(hl)
    pop de
    inc b
    xor d
    sub l
    ld b,l
    ld d,c
    cp 79
    rst 56
    cp 241
    adc a,l
    inc b
    ld hl,(lab0385)
    ld e,a
    cp 85
    ld e,131
    ld hl,(labE249)
    cp a
    ld b,l
    dec b
    ld (de),a
    ld b,l
    ld l,a
    xor d
    inc b
    and h
    jr z,lab265C
    ld d,h
    inc bc
    inc d
    djnz lab271D
    xor b
    ld bc,lab00A8
    ld e,a
    ret z
    nop
    ret nc
    nop
    ld h,c
    ret nc
    nop
    jr nz,lab26E8
lab26E8 ld b,b
    ret po
    nop
    jr nz,lab26ED
lab26ED nop
    ld b,b
    nop
    jr nz,lab26F2
lab26F2 nop
    nop
    nop
    jr nz,lab26F7
lab26F7 nop
    nop
    sub c
    ld (bc),a
    djnz lab26FD
lab26FD rlca 
    nop
    ex af,af''
lab2700 ld b,48
    djnz lab273C
    call nc,lab1C06+2
lab2707 sub b
    rst 56
    rst 56
    inc d
    djnz lab271C
    ld h,b
    dec c
    ld h,b
    dec d
    or b
    ld h,232
    ld (bc),a
    call po,labC347
lab2718 push bc
    ex (sp),hl
    rst 8
    ret p
lab271C ld a,(de)
lab271D ret z
    dec de
    ld b,b
    inc de
lab2721 ld h,b
    ld b,224
    inc b
    ret pe
    nop
    ld l,b
    ld bc,lab0344
    inc b
    inc bc
    nop
    ld (bc),a
    nop
    sub b
    ld (bc),a
    rst 56
    jr lab273D
    dec sp
    dec sp
    cpl 
    ld l,(hl)
    ld (hl),30
    ld d,h
lab273C sub (hl)
lab273D cp d
    ld sp,lab1831-1
    ld c,b
    ld b,b
    add a,h
    add a,d
    inc bc
    ld bc,lab2000
    jr nc,lab275B
    sub b
    jp m,lab09FB-1
    jr lab2751
lab2751 nop
    ld b,b
    inc b
    nop
    nop
    nop
    nop
    nop
    djnz lab275B
lab275B ex af,af''
    ld b,b
    nop
    nop
    ret nz
    nop
    ld (bc),a
    nop
    nop
    ld bc,lab0290
    rst 56
    ld c,8
    ld a,e
    ld e,e
    sbc a,118
    inc (hl)
    djnz lab27C0+1
    ld (bc),a
    ld (lab1010),hl
    djnz lab2707
    ret m
    rst 48
    dec b
lab277A ld e,8
    nop
    nop
    nop
    add a,b
    nop
    nop
    inc b
    nop
    nop
    nop
    jr nz,lab2718
    ld (bc),a
    rst 56
    ld b,7
    or (hl)
    add a,100
    ld b,d
    add a,c
    ld (bc),a
    ex af,af''
    nop
    ex af,af''
    ret z
    nop
    ld b,b
    ld b,b
    add hl,sp
    add hl,sp
    ld (lab1631+1),a
    xor d
    ld (hl),a
    ld a,(lab132F)
    ld bc,lab008E+2
    ld (bc),a
    inc b
    ex af,af''
lab27A9 jr lab27A9+1
    ld a,(bc)
    rst 16
    ld d,a
    or c
    or c
    cp c
    ret nz
    ret nz
    cp b
    xor c
    ld a,d
    ld c,l
    nop
    sub c
    nop
    inc h
    sbc a,c
    inc h
    inc d
    ld d,l
    ld b,h
lab27C0 ld hl,(labAAAA)
    ld d,l
    ld d,l
    ld d,h
    ld hl,(labA8AA)
    dec d
    ld d,l
    nop
    ld (bc),a
    ex af,af''
    nop
    dec b
    ex af,af''
    ld d,255
    jr nc,lab27E2
    rst 8
    jr nz,lab2800
    jr nc,lab2813
    ld h,d
    ld (hl),d
    add a,b
    add a,b
    ld (hl),b
    ld (hl),b
    ld l,b
    ld l,b
lab27E2 cpl 
    ld h,b
    nop
    jr nc,lab27E7
lab27E7 jr lab27E9
lab27E9 ld c,0
    rlca 
    sbc a,b
    add hl,de
    ld h,(hl)
    jp (hl)
    sub b
    ld a,(de)
    ld c,b
    add hl,hl
    jr nz,lab283A
    djnz lab27F8
lab27F8 jr nz,lab277A+1
    ld (bc),a
    nop
    db 253
    db 7
    rst 16
    ccf 
lab2800 ld l,l
    cp b
    cp b
    cp b
    xor b
    ld d,l
    nop
    ret m
    nop
    inc bc
    rst 56
    add a,b
    ld a,a
    rst 56
    call m,labFF3F
    ret p
    inc bc
lab2813 call m,lab0EFF+1
    and l
    ex af,af''
    add hl,bc
    rlca 
    ld d,3
    inc e
    ld (bc),a
    ld (lab2401),hl
    nop
    dec h
    nop
    dec h
    nop
    inc h
lab2827 ld bc,lab0222
    rra 
    ld (bc),a
    add hl,de
    ld (bc),a
    dec d
    inc bc
lab2830 ld de,lab0E04
    dec b
    inc b
    nop
    ld e,a
    nop
    nop
    nop
lab283A nop
    xor a
    sbc a,b
    ret p
    nop
    rrca 
lab2840 ld e,a
    ld a,iyh
    nop
    rla 
    xor l
    cp 191
    ret po
    dec hl
    sbc a,63
    ld e,(hl)
    ld (hl),b
    ld d,a
    xor e
    rst 8
    call m,lab2BE0
    call c,labF17F
    ret nz
    dec d
    rst 40
    rst 56
    rst 56
    nop
lab285D dec bc
    rst 24
    rst 56
    ret nz
    nop
    rla 
    rst 56
    call m,lab0000
    rrca 
    rst 8
    ret po
    nop
    nop
    rlca 
    add a,a
    add a,b
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    add a,c
    ld (bc),a
    inc bc
    call m,labCE07
    ld e,81
    ld a,b
    ld a,b
    ld a,b
    ld l,c
    ld e,d
    ld bc,lab2B00
    ret nz
    ld d,l
lab2888 call m,labC82B
    rla 
    jr nc,lab2894
    rst 8
    inc sp
    ld a,b
    ld a,b
    ld (hl),b
    ld h,c
lab2894 ld c,d
    rrca 
    nop
    ld e,(hl)
    ret m
    dec l
    ret p
    jr lab285D
    rlca 
    rst 16
    inc h
    xor e
    cp c
    ret nz
    cp b
    and b
    sub c
    ld b,0
    ret po
    rrca 
    cp e
    cp 63
    rst 48
    call m,labEF7F
    ret po
    ccf 
    add a,c
    ret nz
    add a,c
    ld (bc),a
    dec b
    ei
    add hl,bc
    rst 24
    call nz,labF8EA
    ret m
    ret m
    jp (hl)
    pop de
    or d
    ld e,l
lab28C4 ld (bc),a
    cp b
    rlca 
    ret po
    dec d
    ld a,a
    rst 40
    call m,labBF69+1
    rst 24
    cp 53
    ld a,a
lab28D2 cp a
    ret m
    ld a,188
    ld a,a
    ret nz
    rra 
    ld (hl),e
    cp 0
    ld (bc),a
    ld c,0
    nop
    sub b
    ret pe
    ld bc,lab2721
    nop
    nop
    rra 
    ld l,b
    nop
    nop
    dec c
    xor a
    ld b,(hl)
lab28EE add a,b
    rlca 
    rst 48
    rst 16
    ld h,e
    ld d,b
    cp e
    db 237
    db 175
    jp nz,labFF67+1
    or a
    rst 16
    jp pe,labBB6A
    db 237
    db 175
    out (74),a
    rst 56
    or l
    rst 16
    ei
    ld c,(hl)
    cp e
    cp a
    xor a
    jp nc,labEE7A
    db 237
    db 215
    rst 32
    jp m,labA4D1
    xor (hl)
    rst 24
    xor 175
    call nc,labFBDE
    ld c,d
    rst 16
    and h
    xor (hl)
    xor 222
lab2921 sbc a,e
    call nc,labDBD7
    ld l,d
    and 164
    xor a
    adc a,202
    rst 56
    cp a
    rst 40
    ex de,hl
    ld e,d
    cp a
    jp pe,lab56BB
    jp m,labA25F
    add a,b
    ld l,e
    ld l,d
    ld e,a
    xor e
    rst 56
    in a,(218)
    cpl 
    inc hl
    xor a
    ex de,hl
    ld c,d
    ld l,55
    sub a
    ei
    ld c,d
    ld d,191
    rst 24
    and e
    jp z,labA116
    rst 24
    ld a,(lab0ACE)
    inc hl
    ld l,a
    ld h,74
    ld a,(de)
    or l
    cp 38
    call nz,lab6B0A+1
    ld e,h
    inc d
    ld b,2
    xor d
    inc d
    ex af,af''
    nop
    ld bc,labFA5B
    jr lab296C
lab296C nop
    adc a,d
    call m,lab0008
    ld bc,labF081
    nop
    nop
    nop
    add a,c
    ld (hl),b
    nop
    nop
    nop
    nop
    ret po
lab297E nop
    nop
    sub c
    ld (bc),a
    dec d
    exx
    nop
    ld (bc),a
    dec hl
    jr lab297E
    nop
    nop
    jp m,lab0008
    db 253
    db 4
    nop
    cp 170
    add a,b
    rst 56
    ld d,h
    ld b,b
    rst 56
    ld hl,(labFF20)
    sub h
lab299C djnz lab299C+1
    jp nz,labFF28
    ret po
lab29A2 djnz lab29A2+1
    jp po,labFF28
    push af
lab29A8 djnz lab29A8+1
    jp m,labFF88
    call m,labFF7F+1
    call m,labFF7F+1
    rst 56
    ld b,b
    rst 56
    cp 184
    rst 56
    rst 56
lab29BA djnz lab29BA+1
    cp 160
    rst 56
    rst 56
    ld d,b
    rst 56
    rst 56
lab29C3 jr nz,lab29C3+1
    rst 56
lab29C6 djnz lab29C6+1
    rst 56
    ld h,b
    rst 56
    rst 56
    or b
    rst 56
    rst 56
    sbc a,b
    rst 56
    rst 56
    and h
    rst 56
    rst 56
    ret c
    rst 56
    rst 56
    ret z
    rst 56
    rst 56
    ret nc
    rst 56
    rst 56
    ret pe
    rst 56
    rst 56
    call po,labFFFE+1
    ret pe
    rst 56
    rst 56
    call p,labFFFE+1
    jp m,labFFFE+1
    or 255
lab29EF rst 56
    jp m,labFFFE+1
    or 255
    rst 56
    ld sp,hl
    rst 56
    rst 56
    db 253
    db 255
    rst 56
    ei
    rst 56
    rst 56
    db 253
    db 255
    rst 56
lab2A02 jp m,lab0280+1
    jr nz,lab29EF
    ld a,(de)
    jr z,lab2A55+1
    add a,b
    nop
    nop
    nop
    ld hl,(lab0080)
    nop
    nop
    inc d
    add a,b
    nop
    nop
    nop
    cpl 
    add a,b
    nop
    nop
    nop
    ld d,h
    ld a,b
    nop
    nop
    nop
    ld (hl),164
    nop
    nop
    nop
    rra 
    ld e,d
    nop
lab2A2A nop
    nop
    dec bc
    dec h
    nop
    nop
    nop
    inc de
    cp d
    add a,b
    nop
    nop
    add hl,bc
    push de
    ld b,b
    nop
    nop
    ld b,146
    ret po
    nop
    nop
    inc bc
    ld c,c
    jr nc,lab2A44
lab2A44 nop
    inc b
    and (hl)
    sbc a,(hl)
lab2A48 nop
    nop
    inc bc
    rla 
    jp (hl)
    nop
    nop
    inc b
    adc a,e
    ld d,128
    nop
lab2A54 ld (bc),a
lab2A55 jp z,lab4089
    nop
    ld bc,lab44F4+1
    and (hl)
    nop
    nop
    dec c
    ld b,d
    ld e,l
    nop
    nop
    ld b,161
    ex (sp),hl
    nop
    nop
    inc bc
    cp e
    add a,e
    ld h,b
    nop
    ld bc,lab3B66
    or b
    nop
    nop
    add a,b
    db 221
    db 120
    nop
    nop
    nop
    ld b,28
    nop
    nop
    nop
lab2A7F ld bc,lab812E
    ld (bc),a
    ld b,240
    ld (de),a
    dec c
    xor d
    nop
    ld d,l
    nop
    ld h,l
    nop
    ld h,l
    nop
    ld h,d
    add a,b
    ld (lab2A7F+1),a
    add a,b
    dec h
    add a,b
    dec d
    ld b,b
    ld a,(bc)
    and b
    add hl,bc
    ld h,b
    dec b
    and b
    dec b
lab2AA0 ld b,b
    add hl,bc
    and b
    ld b,112
    ld (bc),a
    ld c,b
    sub l
lab2AA8 ld (bc),a
    nop
    ret c
    inc b
    add hl,bc
    ret m
    ld b,11
    call p,lab0307+1
    call p,lab1B0A
    call p,labFE00
    ld de,lab3F20
    ret nz
    ld bc,lab10F8
    nop
    ld bc,lab101F+1
    nop
lab2AC5 ld bc,lab3F20
    call m,labFE3F
    inc b
    jr nz,lab2AD6
lab2ACE ld (bc),a
    inc b
    jr nz,lab2ADA
    ld (bc),a
    rst 56
    ld sp,hl
    rst 56
lab2AD6 rst 56
    ld (bc),a
    nop
    add a,b
lab2ADA ld b,c
    ld (bc),a
    nop
    add a,b
    ld b,c
    rst 56
    rst 56
    cp a
    rst 56
    djnz lab2AED
    ld de,labFF04
    cp 255
    rst 56
    nop
    ld b,b
lab2AED inc b
    jr nz,lab2AF1
    rst 56
lab2AF1 cp 0
    nop
    ex af,af''
    ld b,b
    nop
    ld a,(de)
lab2AF8 call lab6800
    ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld l,b
lab2B00 ld l,b
    ld l,b
lab2B02 ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld e,c
    ld c,d
    ld c,d
    ld c,d
    inc sp
    inc h
    dec e
    dec e
    ld c,14
    nop
    rst 56
    ret m
    call po,labAA48
    xor b
    or c
    jr lab2AC5+1
    xor b
    call po,labAA48
    xor b
    or c
    jr lab2ACE
    xor b
    call po,labAA48
    xor b
    or c
    jr lab2AD6
    xor b
    call po,lab5A58
    or b
    add hl,sp
    jr nz,lab2B5E
    and b
    inc l
    ld h,b
    ld d,192
    add hl,bc
    add a,b
    rlca 
    nop
    dec b
    nop
    ld (bc),a
    nop
    ld (bc),a
    nop
    rrca 
    ret z
    nop
    inc de
    ld (lab3829),hl
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    add hl,sp
    ld hl,(lab0C1A+1)
    nop
    jr lab2B82
    ld d,d
    and c
    and c
    and c
    and c
    and c
    and c
    ld h,c
lab2B5E ld (lab081C),a
    inc c
    jp lab1800
    jr lab2B7F
    jr lab2B81
    jr lab2B82+1
    jr lab2B85
    add hl,bc
    nop
    ret po
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    ld b,b
    sub c
    ld (bc),a
    ld b,0
    nop
    ret m
lab2B7F rla 
    ex af,af''
lab2B81 ret m
lab2B82 call p,labF4F8
lab2B85 ret m
    call nc,labF4F8
    ret m
    or h
    ret m
    add a,h
    ld a,b
    ld a,b
    jr nc,lab2BBF+2
    jr nz,lab2BB3
    jr nz,lab2BD1
    scf
    sub c
    ld (bc),a
    ld b,0
    nop
    ret m
    djnz lab2BA3+1
    ret m
    call p,labF4F8
    ret m
lab2BA3 call p,labF4F8
    ret m
    call nc,labF4D8
    ret m
    or h
    sub b
    nop
    ret c
    inc h
    rla 
    rra 
    rst 56
lab2BB3 jp pe,labFE1F
    call nc,labFF1F
    jp pe,labFF1F
    or h
    rra 
    rst 56
lab2BBF jp pe,labFE1F
    call nc,labFF1F
    jp pe,labFF1F
    or h
    rra 
    rst 56
    jp pe,labFE1F
    call nc,labFF1F
lab2BD1 jp pe,labFF17
    or h
    rla 
    rst 56
    jp pe,labFE17
    call nc,labFF17
    jp pe,labFF17
lab2BE0 or h
    rra 
    rst 56
    jp pe,labFE1F
    call nc,labFF1F
    jp pe,lab7F1E+1
    or h
    rra 
    ld a,a
    jp pe,lab7E1D+2
    call nc,lab7F1E+1
    jp pe,labFF1F
    or h
    rra 
    rst 56
    jp pe,labFE1F
    call nc,labFF1F
    jp pe,labFF1F
    or h
    rra 
    rst 56
lab2C07 jp pe,labFE1F
    call nc,labFF1D
    call po,labF104
    and b
    nop
    pop af
    ret nz
    nop
    jr nc,lab2C17
lab2C17 add a,c
    ld (bc),a
    ret m
    nop
    ld a,(bc)
    ex af,af''
    cp 254
    cp 254
    ld a,h
    ld a,h
    jr c,lab2C35
    sub c
    ld (bc),a
    djnz lab2C29
lab2C29 nop
    ret m
lab2C2B ld a,(bc)
lab2C2C djnz lab2C2C+1
    db 253
    db 255
    cp 255
    db 253
    db 237
    cp (hl)
lab2C35 db 237
    db 189
    rst 56
    cp 255
    ld iyl,iyl
    or (hl)
    sub c
    ld (bc),a
    ex af,af''
    nop
    nop
    ret m
    ld b,8
    rst 56
    rst 56
    rst 56
lab2C48 ld l,l
    add a,c
    ld (bc),a
    ei
    cp 4
    jp c,labAE47
    ret c
    nop
    nop
    dec bc
    call m,lab4100
    ld e,a
    rst 56
    ret nz
    inc b
    ret z
    nop
    nop
lab2C5F ld b,b
    add hl,sp
    rst 56
    ld a,20
    ret c
    adc a,a
    ld l,l
    ld l,l
    ld e,(hl)
    ld c,(hl)
    ld b,a
    ld d,a
    ld e,a
    ld e,a
    add a,a
    adc a,a
    sbc a,l
    and h
    ret nz
    ret nz
    xor b
    adc a,b
    add a,c
    ld (hl),d
    ld h,e
    inc bc
    call m,lab017F+1
    ei
    nop
    ld bc,lab00F4
    nop
    or h
    nop
    nop
    ld l,b
    nop
    nop
    ld d,h
    nop
    nop
    ld c,e
    nop
    nop
    xor h
    add a,b
    nop
    ld d,d
    add a,b
    nop
    ld e,d
    ld h,h
    nop
    xor l
    cp 3
    ld c,l
    in a,(4)
    adc a,d
    ld l,(hl)
    ex de,hl
    inc b
    djnz lab2D20
    inc e
    nop
    inc l
    ccf 
    nop
    jr lab2CC1
    nop
    ex af,af''
    inc e
    nop
    dec bc
    call lab3500
    inc a
    ld d,c
    ld e,b
    ld h,b
    ld (hl),b
    ld l,c
    ld h,d
    scf
    cpl 
    inc bc
    ld b,b
    ld (bc),a
    add a,b
    dec b
lab2CC1 add a,b
    add hl,hl
    ld b,b
    ld a,l
    ld b,b
    ld a,(lab1420)
    ld a,b
    nop
    ld (hl),b
    nop
    jr nz,lab2CDB
    call nc,lab997C
    xor b
    xor b
    xor b
    and b
    sub d
    adc a,d
    ld a,e
    ld h,h
    scf
lab2CDB cpl 
    rlca 
    rst 48
    ret nz
    ccf 
    xor a
    and b
    rst 56
    ld e,a
    ld d,b
    ld a,(hl)
    cp a
    and b
    dec d
    ld a,(hl)
    and b
    ld (de),a
    db 221
    db 64
    dec c
    ei
    add a,b
    rlca 
    xor 0
    nop
    ret nc
    nop
    nop
    ld h,b
    nop
    add hl,bc
    ret c
    add a,a
lab2CFD ret nz
    ret nz
    ret nz
    ret nz
    ret nz
lab2D02 and d
    ld e,l
    cpl 
    nop
    jr c,lab2D2C
    ld h,h
    ld c,h
    jp c,labB39B
    ld de,lab246B
    and 30
    exx
    ret c
    inc bc
    ld d,(hl)
    nop
    nop
    jr nz,lab2D1A
lab2D1A add a,c
    ld (bc),a
    inc c
lab2D1D jp m,labE00A
lab2D20 jp (hl)
    ret m
    ret m
    ret m
    ret m
    ret m
    pop af
    pop hl
    xor a
    sbc a,a
    ld a,13
lab2D2C ld d,h
    jr z,lab2DAC+2
    cp 175
    call nc,lab5F7F
    ld c,a
    rst 16
    ld a,(hl)
    cp (hl)
    cp a
    xor d
    inc a
    rst 40
    rst 24
    ld e,h
    dec sp
    rla 
    rrca 
    sub b
    inc c
    nop
    inc bc
    ret po
    nop
    nop
    ld bc,lab197F+1
    ret z
    rrca 
    jr c,lab2D8F
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    jr c,lab2D97
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    jr c,lab2D95
    jr c,lab2D97
    jr nc,lab2D91
    jr nc,lab2D8C
    ld (labAC1A+1),hl
    call c,labDFAE
    xor a
    rst 24
    xor (hl)
    call nc,labD4AC
    xor (hl)
    rst 16
    ld c,(hl)
    inc (hl)
    ld l,h
    sbc a,h
    ld a,h
    ld e,b
    ld a,b
    ld e,b
    jr c,lab2D93
    ex af,af''
    ld (lab0FC8),hl
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    jr c,lab2DC0
    jr c,lab2DC0+2
    jr c,lab2DC4
lab2D8C jr c,lab2DCE
    ld b,b
lab2D8F ld b,b
    ld b,b
lab2D91 ld b,b
    ld b,b
lab2D93 jr c,lab2DC5
lab2D95 jr nc,lab2DCE+1
lab2D97 ld b,b
    ld b,b
    ld b,b
    ld b,b
    add hl,sp
    add hl,sp
    ld (lab1B2A),a
    rst 56
    rst 24
    xor (hl)
    ld e,(hl)
    ld a,122
    cp b
    call m,labBCFC
    inc e
    cp h
lab2DAC call m,labFCB6+2
    cp (hl)
    ld a,(hl)
    ld l,94
    ld a,h
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    sbc a,h
    cp (hl)
    ld e,a
    cpl 
    scf
    ld a,(de)
    inc d
    ex af,af''
lab2DC0 ld de,lab0FC8
    ld b,b
lab2DC4 ld b,b
lab2DC5 ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
lab2DCE jr lab2DE8
    jr lab2DEA
    jr lab2E02
    ld e,(hl)
    ld l,(hl)
    ld e,(hl)
    ld l,d
    ld d,h
    ld l,d
    ld d,(hl)
    ld a,d
    ld l,d
    ld b,(hl)
    ld b,d
    ld b,d
    ld b,b
    ld b,b
    dec de
    ret z
    rrca 
    ld b,b
    ld b,b
    ld b,b
lab2DE8 ld b,b
    ld b,b
lab2DEA ld b,b
    ld b,b
    ld b,b
    jr c,lab2E27
    ld sp,lab3131
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld (lab1C29+2),a
    rst 16
    bit 6,l
lab2E02 ld c,(hl)
lab2E03 halt
    ld c,(hl)
    ld a,d
    xor h
    ld a,h
lab2E08 inc a
    inc a
    inc a
    inc a
    inc a
    ld a,63
    scf
    dec hl
    ld b,l
    xor b
    call c,lab1C9E
    ld a,(bc)
    inc b
    add a,c
    ld (bc),a
    inc bc
    call p,labD00E
    ld c,a
    add a,b
    add a,b
    add a,b
    ld a,c
    ld (hl),d
    ld l,e
    ld l,d
    ld h,d
lab2E27 ld h,d
    ld h,d
    ld h,d
    ld d,e
    ld b,h
    xor d
    xor a
    ld d,l
lab2E2F ld d,a
    ld hl,(lab15AE)
    sbc a,10
    cp (hl)
    dec b
    ld e,h
    dec bc
    xor b
    dec d
    ld e,b
    dec bc
    jr c,lab2E54
    ld a,b
    ld a,(bc)
    ret p
    dec b
    ret po
    ld a,(bc)
    ret po
    rst 8
    ret m
    ret m
    ret m
    ret m
    ret m
    ret p
    xor b
    sbc a,c
    ld sp,hl
    ld d,a
    rst 56
    rst 56
    rst 56
lab2E54 sbc a,e
    rst 56
    cp 190
    xor l
    cp a
    rst 56
    ld a,b
    ld e,e
    ld e,a
    di
    cp h
    ld d,(hl)
    xor a
    xor (hl)
    jr lab2ED4
    rra 
    ld d,b
    nop
    ld a,15
    and b
    nop
    jr lab2E7C+1
    ret nz
    nop
    ld b,206
    ld c,a
    ld a,b
    ld a,b
    ld a,b
    ld (hl),c
    ld h,e
    cpl 
lab2E79 call m,lab9C5F
lab2E7C jr nc,lab2E79+1
    rrca 
    inc e
    add a,c
    inc b
    dec b
    jp m,labD608
    nop
    cp b
    cp b
    cp b
    cp b
    ld a,e
    ld d,l
    cpl 
    ld e,a
    ld a,a
    call m,labFC32
    inc a
    ld (hl),e
    call m,lab0C7C
    inc hl
    add a,b
    inc bc
    cp h
    nop
    nop
    ld h,b
    nop
    add hl,bc
    rst 0
    rrca 
    ld b,b
    ld b,b
    jr c,lab2EDE+1
    add hl,hl
    add hl,hl
    ld a,(de)
    ld a,(de)
    cp 124
    ld e,h
    jr z,lab2ED8
    djnz lab2EC2
    add a,c
    ld (bc),a
    inc e
    nop
    rrca 
    ret po
    call z,labF9F9
    ld sp,hl
    ld sp,hl
    jp pe,labCCDB
    cp l
    xor (hl)
lab2EC2 sbc a,a
    sub a
    ld e,a
    ld d,a
    ld c,a
    rlca 
    rst 56
    rst 56
    ret p
    ld a,l
    cp l
    rst 56
    ld e,a
    ld hl,(labDFDC+1)
    ld e,(hl)
    rra 
lab2ED4 cp l
    cp iyh
    ld a,(bc)
lab2ED8 rst 24
    rst 56
    ret m
    dec b
    ld l,a
    push af
lab2EDE djnz lab2EE1+1
    cp a
lab2EE1 jp pe,lab01A0
    ld hl,(lab4025)
    nop
    dec d
    ld b,d
    add a,b
    nop
    ld a,(bc)
    add a,c
    nop
    nop
    inc c
    add a,b
    nop
    nop
    dec b
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    add a,d
    inc b
    ld d,239
    ld (bc),a
    ld (lab1300),a
    or b
    inc bc
    dec l
    nop
    jr nc,lab2F09
lab2F09 jr nc,lab2F0B
lab2F0B jr nc,lab2F0D
lab2F0D jr nc,lab2F0F
lab2F0F jr nc,lab2F11
lab2F11 jr nc,lab2F13
lab2F13 jr nc,lab2F15
lab2F15 jr nc,lab2F17
lab2F17 jr nc,lab2F19
lab2F19 cpl 
    ld bc,lab022B+1
    dec hl
    ld (bc),a
    dec hl
    inc bc
    ld hl,(lab2607)
    ex af,af''
    inc h
    djnz lab2F43
    ld de,lab0F17+1
    sbc a,a
    ret po
    ld l,e
    ei
    rlca 
    push af
    ld c,c
    cp 171
    sbc a,e
    or a
    push de
    xor c
    rst 56
    ld l,e
    cp e
    ld d,l
    or l
    ld e,c
    xor 171
    in a,(183)
    db 221
lab2F43 db 175
    rst 40
    ld l,e
    cp a
    ld c,a
    xor l
    ld d,a
    xor 171
    rst 24
    rst 56
    push de
    xor e
    rst 56
    ld l,e
    rst 56
    ld b,c
    rst 56
    ret p
    nop
    xor e
    jp nc,lab5580+2
    xor a
    rst 56
    ld (hl),a
    xor a
    call m,lab5F28+2
    jp m,labFFFE+1
    djnz lab2F79
    cp a
    rst 48
    ld a,a
    ei
    sub b
    inc d
    rst 56
    xor 159
    ei
    ld d,b
    rrca 
    ld d,d
    sbc a,a
    ld a,a
    cp a
    ld (hl),b
    nop
lab2F79 xor c
    ld a,(hl)
    sbc a,a
    sbc a,h
    sub b
    nop
    ld a,a
    cp e
    ld e,a
    db 253
    db 32
    nop
    nop
    ld d,(hl)
    sbc a,e
    xor (hl)
    ld b,b
    nop
    nop
    ccf 
    ld e,e
    pop de
    nop
    add a,c
    ld (bc),a
    nop
    cp 4
    adc a,53
    ld (hl),b
    ld (hl),b
    ld c,a
    inc bc
    ret nz
    ld d,l
    ret m
    add a,d
    ld (bc),a
    rst 56
    db 253
    db 4
    dec c
    rst 56
    dec b
    sub 79
    adc a,h
    or c
    cp b
    nop
    nop
    cp 0
    dec b
    ld a,a
    ret p
    ld hl,(labFCFF)
    ld a,(bc)
    ret z
    nop
    jr nc,lab2FEA
    jr nc,lab2FEC
    jr nc,lab2FEE
    jr nc,lab2FD2
    nop
    call m,lab8484
    add a,h
    add a,h
    add a,h
    call z,lab8130
    ld (bc),a
    nop
    rst 56
    inc bc
    add a,56
    jr c,lab2FE1
lab2FD2 ld a,h
    ld de,lab4FCE
    ld a,b
    ld a,b
    ld (hl),b
    ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld e,c
    ld c,d
    dec sp
    inc l
lab2FE1 inc l
    inc l
    inc l
    dec e
    dec e
    ld d,d
    inc (hl)
    ld l,e
    ld a,b
lab2FEA ld d,e
    ld (hl),b
lab2FEC ld l,a
    ret p
lab2FEE ld e,a
    ret p
    ld a,a
    ret p
    dec hl
    ret po
    rla 
    ret nz
    dec bc
    add a,b
    dec b
    nop
    ld (bc),a
    nop
    ld (bc),a
    nop
    rlca 
    nop
lab3000 ld (bc),a
lab3001 nop
    ld (bc),a
    nop
    add a,d
    ld (bc),a
    add hl,hl
    nop
    inc b
    ld a,(de)
    jp (hl)
    add hl,de
lab300C xor b
    inc b
    inc h
    ld bc,lab0027
    jr z,lab3014
lab3014 jr z,lab3016
lab3016 jr z,lab3018
lab3018 jr z,lab301A
lab301A jr z,lab301C
lab301C jr z,lab301E
lab301E jr z,lab3021
lab3020 daa
lab3021 ld (bc),a
    ld h,1
    ld h,1
    dec h
    ld bc,lab0123+1
    inc hl
    ld bc,lab0123+1
    dec h
lab302F ld bc,lab0188+1
lab3032 dec de
    ld (bc),a
    add a,a
    inc bc
    ld a,(de)
    inc bc
    add a,l
    ex af,af''
    ld d,4
    add a,e
    add hl,bc
    ld d,4
    add a,e
    add hl,bc
    ld d,4
    add a,e
    add hl,bc
    ld d,16
    ld d,16
    ld d,7
    ret m
    call m,labFEF0+1
    ld a,(labBAFA)
    xor (hl)
    cp c
    rst 56
    ld (hl),l
    cp d
    ld l,a
    add hl,hl
    cp d
    cp 184
    xor a
    add hl,sp
    ld a,a
    ld (hl),l
    cp a
    ld l,(hl)
    sbc a,c
    cp d
    rst 56
    rst 56
    xor a
    db 253
    db 95
    ld (hl),b
    rst 32
    ld l,a
    ld c,e
    ld hl,(labFFFE+1)
    xor (hl)
    and (hl)
    rrca 
    ld a,a
    rst 56
    ld a,(hl)
    jp nc,labBA0D+1
    ld bc,lab7CBF
    rra 
    ld h,l
    rst 56
    ld e,a
    jr z,lab30B2
    ex de,hl
    rst 56
    cp (hl)
    sub b
    dec a
    rst 56
    rst 56
    ld (hl),a
    ld h,b
    dec l
    and d
    inc b
    ex de,hl
    ret nz
    dec (hl)
    sub l
    db 253
    db 247
    ret po
    cpl 
    adc a,e
    ex de,hl
    rst 56
    ret p
    rla 
    rlca 
    push bc
    ld d,a
    ret m
    ld a,(bc)
    nop
    ccf 
    ret p
    ex af,af''
    inc b
    nop
    ld l,d
    xor a
    ret m
    inc b
    nop
    ld d,l
    ld d,l
    ld e,b
    inc b
    nop
    ld l,d
lab30B2 xor e
    ret m
    nop
    nop
    ld e,a
    ld a,l
    ret m
    nop
    nop
    ld a,c
    rst 32
    sbc a,b
    add a,c
    ld (bc),a
    nop
    ret p
    ld (de),a
    ld c,79
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
lab30D0 ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld l,c
    ld c,a
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    dec hl
    call m,labFC55
    ld a,(bc)
    push bc
    rrca 
    jr nc,lab312B
    jr nc,lab312C+1
lab30FD jr nc,lab312F
    add hl,hl
    ld (lab081A+1),hl
    adc a,b
    ret z
    cp b
    ld l,b
    jr c,lab3121
    ex af,af''
    add a,c
    ld (bc),a
    nop
    ret pe
    ld a,(de)
    rst 16
    nop
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
lab3121 or c
    or c
    or c
    or c
    or c
    or c
    or c
    or c
    nop
    ld d,l
lab312B ld a,a
lab312C cp 42
    cp a
lab312F cp 85
lab3131 ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 85
    ld a,a
    cp 42
    cp a
    cp 129
    ld (bc),a
    nop
    ret p
    ld (de),a
    rst 0
    rrca 
    jr c,lab31B3
    jr c,lab31B5
    jr c,lab31B7
    jr c,lab31B9
    jr c,lab31BB
    jr c,lab31BD
    jr c,lab31BF
    jr c,lab31C0+1
    rrca 
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    cp (hl)
    ld a,(hl)
    add a,d
    ld (bc),a
    add hl,de
    nop
    inc b
    djnz lab31A4
    rla 
    ret c
    ld h,a
lab31A4 ld a,a
    sub (hl)
    xor e
    cp c
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
lab31B3 ret nz
    cp b
lab31B5 xor c
    sbc a,d
lab31B7 ld (hl),e
    ld c,h
lab31B9 dec h
    nop
lab31BB rlca 
    ret nz
lab31BD nop
    dec a
lab31BF ret z
lab31C0 ld bc,labCFE8+2
    rrca 
    ld d,l
    rst 8
    ld a,(labC9A9+1)
    ld d,l
    ld d,l
    ld sp,hl
    ld l,d
    cp d
    rst 56
    ld d,l
    ld d,l
    rst 56
    ld l,d
    cp d
    rst 56
    ld e,l
    ld d,l
    rst 8
    ld l,d
    xor d
    rst 8
    ld e,l
    ld d,l
    rst 56
    ld l,d
    xor a
    ld l,a
lab31E1 ld d,l
    rst 56
    or c
    ld l,a
    rst 56
    cp (hl)
    ld a,a
    rst 56
    call c,labFF3F
    ret pe
    rra 
    rst 56
    ret p
    rrca 
    rst 56
    nop
    rlca 
    ret p
    nop
    inc bc
    nop
lab31F8 nop
    add a,c
    ld (bc),a
    djnz lab31FD
lab31FD ld c,207
    ld c,l
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld a,b
    ld l,c
    ld a,(labF803)
    cp 190
    push de
    ld a,(hl)
    xor d
    cp (hl)
    push de
    halt
    xor d
    or (hl)
    push de
    ld a,(hl)
    rst 56
    sbc a,255
    xor 127
    call pe,labF83F
    rra 
    nop
    add a,c
    ld (bc),a
    inc d
    rst 56
    add hl,bc
    rst 16
    ret nz
    ret nz
    ret nz
    or c
    and d
    sub e
    ld l,l
lab3232 ld e,(hl)
    scf
    ld a,(hl)
    ld bc,lab3FFA
    nop
    call p,lab831E+1
    ret pe
    rrca 
    rst 8
    ret p
    inc bc
    rst 56
    add a,b
    ld bc,lab00FE
    nop
    ld (hl),b
    nop
    add a,c
    ld (bc),a
    jr z,lab324E
    rla 
lab324E xor b
    nop
    jr z,lab3252
lab3252 jr z,lab3254
lab3254 jr z,lab3256
lab3256 jr z,lab3258
lab3258 jr z,lab325A
lab325A jr z,lab325C
lab325C jr z,lab325E
lab325E jr z,lab3260
lab3260 jr z,lab3262
lab3262 jr z,lab3264
lab3264 jr z,lab3266
lab3266 jr z,lab3268
lab3268 jr z,lab326A
lab326A jr z,lab326C
lab326C jr z,lab326E
lab326E jr z,lab3270
lab3270 jr z,lab3272
lab3272 jr z,lab3274
lab3274 sub l
    dec b
    ld c,2
    sub c
    ex af,af''
    dec bc
    inc b
    adc a,(hl)
    dec bc
    ex af,af''
    ld b,139
    ld c,5
    ex af,af''
    ld b,0
    inc b
    inc d
    nop
    ld (bc),a
    nop
    jr z,lab32E2
    ld b,b
    inc b
    ld bc,lab5551
    ld d,b
    jr z,lab329E+1
    xor c
    rst 56
    ld d,b
    ld d,h
    dec d
    ld d,h
    cp 80
    xor d
lab329E ld hl,(lab7EAA)
    pop de
    ld d,h
    dec d
    ld d,l
    dec hl
    ld d,b
    xor d
    add a,d
    xor b
    ld a,177
    ld d,h
    push bc
    ld d,b
    ld a,a
    ld d,b
    xor b
    ld h,b
    ld hl,labB8FF
    ld b,b
    cp b
    inc bc
    rst 56
    ld a,h
    ld bc,lab0F5F
    and 190
    inc bc
    xor a
    sbc a,a
    rst 24
    rst 56
    rra 
    rst 48
    rst 56
    rra 
    rst 56
    cp 251
    call m,labDFBF
    ld sp,hl
    ex (sp),iy
    ld a,a
    ccf 
    rst 32
    ld a,a
    call c,lab1FF0
    sbc a,31
    or e
    ret nz
    rrca 
    ret m
    rlca 
    rst 40
    add a,b
lab32E2 inc bc
    ret p
    ld bc,lab00FF
    nop
    ret po
    nop
    ld a,b
    nop
    nop
    nop
    add a,c
    ld (bc),a
lab32F0 djnz lab32F0+1
    ld (de),a
    ret nc
    ld l,b
    ld (hl),b
    ld (hl),b
    add a,b
    add a,b
    add a,b
    add a,b
    ld a,b
    ld (hl),b
    ld l,b
    ld h,b
    ld e,b
    ld d,b
    ld c,b
    ld b,b
    jr nc,lab332D
    jr lab3307
lab3307 ret p
    ld hl,(labABE8)
    ret c
    xor a
    cp c
    xor (hl)
    ld (hl),d
    cp l
    call po,labE8BB
    or 208
    pop bc
    and b
    xor a
    ld b,b
    ld e,128
    ld a,a
    nop
    cp 0
    ret m
    nop
lab3322 ret p
    nop
    ret nz
    nop
    add a,c
    ld (bc),a
    inc d
    rst 56
    dec bc
    ret c
    ret nz
lab332D ret nz
    ret nz
    ret nz
    cp b
    or b
    and b
    sub c
    ld a,d
    ld l,e
    ld e,h
    jp m,labEB00
    cp 0
    call nc,lab0178+2
    jr c,lab33B5+1
    ld (bc),a
    ret po
    dec hl
    push hl
    ret nz
    dec d
    in a,(0)
    dec bc
    and 0
    rlca 
    call c,lab0000
    jr c,lab3352
lab3352 add a,c
    ld (bc),a
    ex af,af''
    call p,labD60E
    cp b
    cp b
    cp b
    or b
    and c
    sub d
    adc a,e
    adc a,e
    add a,e
    ld a,h
    ld a,h
    ld l,l
    ld l,l
    adc a,a
    rst 56
    rst 56
    call m,lab5355
    ret m
    ld hl,(labF093)
    dec d
    ld d,e
    ret po
    ld a,(bc)
    or e
    ret po
    dec c
    ld a,a
    ret po
    ld a,(bc)
    ccf 
    ret nz
    dec b
    ld e,a
    ret nz
    dec b
    cpl 
    ret nz
    ld (bc),a
    rst 16
    add a,b
    ld (bc),a
    xor e
    add a,b
    ld bc,lab807F
lab338A ld (de),a
    djnz lab338E
    ret nz
lab338E rlca 
    ret p
    rrca 
    ret m
    ld a,(bc)
    call m,labFE15
    ld hl,(lab3DFD+1)
    ld a,a
    ld a,(lab3FBF)
    rst 16
    ccf 
    xor e
    ccf 
    ld d,h
    rra 
    xor d
    rra 
    ld d,h
    rrca 
    ret m
    rlca 
    ret p
lab33AA ld bc,lab127E+2
    djnz lab33AF
lab33AF inc d
    nop
    xor b
    ld bc,lab0A50
lab33B5 jr nz,lab33CB
    ld d,b
    jr z,lab33D9+1
    ld d,h
    ld d,b
    ld hl,(lab1528)
    inc d
    ld a,(bc)
    adc a,d
    ld bc,lab0205
    adc a,d
    ld bc,lab0213+1
    jr z,lab33D0
lab33CB ld b,b
    ld a,(bc)
    nop
    add a,c
    ld (bc),a
lab33D0 ld b,(hl)
    nop
    inc c
    sbc a,a
    jr nz,lab33D6
lab33D6 ld bc,lab011D+1
lab33D9 ld e,3
    dec de
    inc b
    add hl,de
    dec b
    rla 
    rlca 
    inc d
lab33E2 ex af,af''
    djnz lab33EE
    dec c
    ld a,(bc)
    ld a,(bc)
    dec bc
    rlca 
    inc c
    dec b
    ccf 
    db 253
lab33EE db 127
    ld d,h
    rrca 
    ld a,255
    xor b
    rlca 
    sbc a,a
    rst 56
    ld d,b
    inc bc
    adc a,a
    jp m,lab009F+1
    xor a
    push af
    ret nz
    nop
    ld (hl),a
    and 0
    nop
    dec sp
    ret m
    nop
    nop
    rra 
    ret po
    nop
    nop
    rrca 
    add a,b
    nop
    nop
    rlca 
    nop
    nop
    add a,c
    ld (bc),a
    ld b,c
    nop
    ld a,(bc)
    sbc a,l
    jr nz,lab341C
lab341C nop
    ld e,0
    ld e,1
    inc e
    ld (bc),a
    ld d,4
    ld (de),a
    ld b,15
    ex af,af''
    dec bc
    dec bc
    ld b,12
    inc b
    ld a,a
    rst 56
    ld d,l
    ld e,b
    ccf 
lab3433 rst 24
    xor e
    ret p
    rra 
    xor a
    sub 0
    rlca 
    ld d,a
    ret pe
    nop
    ld bc,labB0EF
    nop
    nop
    ld a,(hl)
    ret nz
    nop
    nop
    rrca 
    nop
    nop
    nop
    ld b,0
    nop
    add a,c
    ld (bc),a
    ld c,e
    nop
    ld a,(bc)
    sbc a,a
    jr nz,lab3456
lab3456 nop
    jr nz,lab3459
lab3459 jr nz,lab345B+1
lab345B ld e,2
    inc e
    inc b
    add hl,de
    dec b
    ld d,6
    ld de,lab0B0A
    inc c
    dec b
    ld a,a
    rst 40
    rst 56
    ld d,d
    inc a
    rst 48
    jp m,lab1F24
    cpl 
    call po,lab07D8
    rst 16
    rst 8
    jr nc,lab347C
    rst 0
    or e
    ret nz
lab347C ld bc,lab4CF8
    nop
    nop
    rra 
    ret p
    nop
    nop
    rlca 
    nop
    nop
lab3488 add a,c
    ld (bc),a
    nop
    ret p
    ld (de),a
    rlc b
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld d,c
    ld d,c
    ld c,c
    ld d,c
    ld e,c
    ld d,d
    ld d,d
    ld e,c
    ld e,c
    ld d,c
    ld c,d
    dec sp
    nop
    ccf 
    add a,b
    ld c,a
    ret nz
    ld e,a
    ret nz
    cpl 
    ret nz
    daa
    ret nz
    rla 
    add a,b
    cpl 
    nop
    daa
    add a,b
    rla 
    ret nz
    dec bc
    ret po
    dec bc
    ret po
    dec d
    ret po
    daa
    ret nz
    rla 
    ret nz
    rrca 
    add a,b
    rlca 
    nop
    add a,c
    ld (bc),a
    nop
    ret pe
    ld a,(de)
    jp z,lab4900
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld e,b
    ld d,b
    ld d,b
    ld c,c
    ld b,c
    ld a,(lab0038+2)
    rra 
    nop
    ccf 
    add a,b
    ld c,a
    ret nz
    ccf 
    ret nz
    ld l,a
    ret nz
    ld d,a
    ret nz
    ld l,a
    add a,b
    ld e,a
    add a,b
    cpl 
    add a,b
    cpl 
    add a,b
    rla 
    add a,b
    rla 
    add a,b
    rra 
    nop
    daa
    add a,b
    cpl 
    ret nz
    ccf 
    ret nz
lab3500 ld l,a
    ret nz
    ld e,a
    add a,b
    ld a,a
    add a,b
    ccf 
    add a,b
    cpl 
    nop
    rra 
    nop
    rra 
    nop
    ld c,0
    add a,d
    ld (bc),a
    inc b
    ret pe
    inc b
    ld a,0
    ld a,(de)
    adc a,0
    ld a,b
    ld a,b
    ld (hl),c
    ld l,c
    ld l,b
    ld l,b
    ld l,b
    ld h,b
    ld h,b
    ld e,c
    ld e,c
    ld e,c
    ld e,d
    ld e,d
    ld d,e
    ld d,e
    ld d,e
    ld e,d
    ld d,d
    ld d,d
    ld d,d
    ld d,d
    ld d,d
    ld c,e
    nop
    ld d,a
    call m,labFC3B
    rla 
    ret m
    cpl 
    ret p
    daa
    ret p
    ld l,a
    ret p
    ld e,a
    ret po
    ld c,a
    ret po
    ccf 
    ret nz
    cpl 
    ret po
    ccf 
    ret nz
    rra 
    ret po
    rra 
    ret po
    rrca 
    ret p
    rrca 
    ret p
    rlca 
    ret po
    rlca 
    ret p
    add hl,bc
    ret po
    inc de
    ret po
    add hl,bc
    ret nz
    dec bc
    ret po
lab355D rla 
    ret po
    dec bc
    ret po
    rrca 
    ret nz
    sub b
    inc bc
    nop
    ld a,(bc)
    push bc
    nop
    jr z,lab359B
    jr nc,lab359D
    add hl,hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,(de)
    ld (hl),b
    ld (hl),b
    ld a,b
    jr c,lab35AF
    jr c,lab35B1
    djnz lab3585
    rst 0
    nop
    jr c,lab35B7
    jr nc,lab35B9
    ld sp,lab3232
    dec hl
lab3585 inc e
    ld a,h
    ld a,b
    ld (hl),b
    jr z,lab359F
    inc d
    ld a,(bc)
    inc b
    add a,d
    ld (bc),a
    dec b
    ret m
    inc b
    ld c,d
    nop
    ld a,(bc)
    rst 8
    nop
    add a,b
    add a,b
    ld (hl),c
lab359B ld h,d
    ld h,d
lab359D ld d,e
    ld d,e
lab359F ld c,e
    nop
    ld l,a
    sbc a,47
    or h
    rla 
    ret z
    rra 
    sbc a,b
    rrca 
    ld d,b
    ld c,176
    rrca 
    ret po
lab35AF rlca 
    ret po
lab35B1 add a,d
    ld (bc),a
    ld a,(bc)
    ret p
    inc b
    ld b,c
lab35B7 ld a,(bc)
    ld (de),a
lab35B9 dec c
    ld b,b
    nop
    jr nz,lab35BE
lab35BE ld (de),a
    nop
    cpl 
    nop
    dec d
    add a,b
    ld a,(bc)
    ret nz
    dec d
    ld b,b
    ld a,(bc)
    ret nz
    dec b
    add a,b
    dec b
    and b
    ld (bc),a
    ret nc
    ld bc,lab0147+1
    jr nc,lab35D5
lab35D5 xor b
    nop
    ld d,b
    nop
    jr nz,lab355D
    ld (bc),a
    ld de,lab03FF+1
    ld (hl),2
    ld a,(bc)
    jr lab35E4
lab35E4 nop
    ld a,c
    jr nz,lab3627
    and (hl)
    dec d
    ld d,l
    ld e,b
    rra 
    xor d
    add a,b
    ld h,l
    ld d,l
    nop
    xor d
    add a,b
    nop
    ld d,b
    nop
    nop
    jr nz,lab35FA
lab35FA nop
    sub b
    nop
    ex af,af''
    ld a,(bc)
    rrca 
    nop
    ld c,0
    inc d
    nop
    jr z,lab3607
lab3607 ld d,b
    ld bc,lab079E+2
    ld b,b
    ld a,d
    nop
    sbc a,h
    nop
    add a,c
    ld (bc),a
    rlca 
    ret p
    ld (de),a
    ex af,af''
    or b
    ret po
    or b
    ret po
    or b
    ret po
    and b
    ret nz
    and b
    ld h,b
    ld d,b
    jr z,lab3637
    ld a,(bc)
    dec b
    ld (bc),a
    add a,d
lab3627 ld (bc),a
    inc c
    db 237
    db 4
    ld c,(hl)
    call p,lab0F15
    jr nz,lab3631
lab3631 ld d,b
    nop
    or b
    nop
    ld e,b
lab3636 nop
lab3637 jr z,lab3639
lab3639 inc (hl)
    nop
    inc d
    nop
    ld a,(bc)
lab363E nop
    ld b,0
    dec b
    add a,b
    inc bc
    ld b,b
    ld (bc),a
    and b
    ld bc,lab0190
    ld l,b
    nop
    sub h
    nop
    jp c,lab4BFF+1
    nop
    ld l,(hl)
    nop
    inc a
    dec c
    rst 16
    adc a,e
    xor c
    cp b
    cp b
    cp b
    cp b
    cp b
    ld c,(hl)
    ld c,(hl)
    ld c,(hl)
    ld c,(hl)
    ld (hl),47
    ld a,(bc)
    xor d
    and b
    scf
    rst 56
    ret c
    ld l,b
    ld a,h
    inc l
    ld e,a
    dec l
    call p,lab3870
    inc e
    nop
    ret m
    nop
    ld bc,lab00F8
    ld bc,lab00FC
    ld bc,lab00FC
    ld bc,lab00E0
    nop
    and b
    nop
    sub b
    inc d
    call m,labD515
    nop
    nop
    nop
    ld l,a
    add a,h
    adc a,e
    sub d
    sbc a,c
    sub c
    sbc a,c
    and b
    xor b
    or b
    or b
    or b
    xor b
    sub c
    ld a,c
    ld e,d
    ld c,e
    ld b,h
    nop
    nop
    jr nc,lab36A3
lab36A3 ld sp,lab00E0
    ccf 
    ret po
    nop
    rst 56
    ld h,b
    rlca 
    rst 48
    ld h,b
    rrca 
    or 224
    rra 
    ld l,(hl)
    ret nz
    ld a,(labC0ED)
    ld (hl),221
    ret nz
    dec (hl)
    sbc a,224
    ld l,l
    xor 224
    ld l,(hl)
    rst 40
    ld (hl),b
    ld l,(hl)
    rst 48
    ld a,b
    ld (hl),a
    ld (hl),a
    ret p
    scf
    ld a,a
    ret nz
    dec sp
    cp 0
    rra 
    ret p
    nop
    rrca 
    and b
    nop
    inc b
    jr nz,lab36D8
lab36D8 sub b
    inc d
    ei
    ld a,(de)
    sbc a,0
    nop
    nop
    nop
    and a
    or l
    cp e
    jp z,labD1C9+1
    exx
    ret po
    ret pe
    ret pe
    ret p
    ret p
    ret p
    ret p
    ret pe
    ret c
    ret 
    cp c
    or c
    sbc a,d
    sub d
    ld h,(hl)
    nop
    ld bc,labE081
    nop
    ld bc,labC09F
    nop
    ld bc,labC0FE
    nop
    rrca 
    db 253
    db 192
    nop
    ld a,a
    cp e
    add a,b
    inc bc
    rst 56
    cp e
    add a,b
    rrca 
    rst 40
    ld a,e
    add a,b
    rra 
    rst 24
    ld (hl),a
    ret nz
    dec e
    rst 24
    ld (hl),a
    ret nz
    dec sp
    sbc a,251
    ret nz
    dec sp
    cp (hl)
    ei
    ret po
    ld a,e
    cp a
    ld a,l
    ret po
    ld (hl),a
    cp a
    ld a,l
    ret p
    ld (hl),a
    rst 24
    cp (hl)
    ret p
    ld (hl),a
    rst 24
    cp a
    ret m
    ld a,e
    rst 40
    rst 24
    ret pe
lab3737 ld a,e
    rst 40
    rst 56
    or b
    ld a,l
    rst 48
    ret m
    ld b,b
    dec a
    rst 56
    add a,c
    add a,b
    ld a,254
    add a,d
    nop
    ccf 
    ret p
    adc a,h
    nop
    rra 
    add a,d
    sub b
    nop
    ld e,3
    ret po
    nop
    ld bc,lab80FD
    nop
    ld b,200
    nop
    ld sp,lab3131
    add hl,hl
    ld a,(de)
    jr c,lab3775
    jr z,lab3773
    add a,d
    ld (bc),a
    inc e
    nop
    inc b
    ld (bc),a
    ret m
    ld a,(bc)
    sbc a,191
    call nc,labE9E2
    ret p
    ret p
    ret p
lab3773 ld h,c
    rst 8
lab3775 rst 8
    nop
    inc a
    di
    call po,lab8F00
    rst 48
    call pe,lab5704+1
    rst 56
    call m,labFF1A
    rst 56
    call m,labDE25
    nop
    inc b
    ld e,d
    cp b
    rst 56
    call p,lab702E
    nop
    inc b
    ld c,0
    nop
    nop
    add a,c
    ld (bc),a
    jr nz,lab379A
lab379A dec c
    ret po
    sub 221
    ex de,hl
    jp p,labF9F9
    ld sp,hl
    ld sp,hl
    ld sp,hl
    xor b
    add a,b
    jr z,lab37C0+1
    ld bc,lab71F2+1
    adc a,(hl)
    ld (bc),a
    sub l
    ld e,a
    rst 56
    dec c
    dec a
    exx
    sbc a,c
    ld (de),a
    ld l,d
    xor a
    rst 56
    ld l,149
    ld b,a
    rst 56
    dec (hl)
    rrca 
    ret m
lab37C0 ld bc,labF32B
    ei
    rst 56
    inc hl
    db 253
    db 240
    ld bc,labFE4B+2
    nop
    ld bc,lab00B0
    nop
    nop
    ld b,b
    nop
    nop
    nop
    sub c
    ld (bc),a
    nop
    ret c
    ld b,253
    ld hl,(lab8108)
    add a,c
    ld bc,lab0000+1
    add a,b
    add a,b
    add a,c
    ld bc,lab8180+1
    add a,c
    add a,c
    add a,b
    ld bc,lab0101
    ld bc,lab8100+1
    add a,b
    add a,b
    add a,b
    add a,b
    nop
    add a,b
    add a,b
    add a,b
    add a,c
    add a,c
    ld bc,lab0101
    add a,b
    add a,b
lab3800 add a,b
    add a,c
    add a,c
    add a,c
    add a,c
    sub b
    nop
    sub h
    djnz lab3811+1
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld h,b
lab3811 jr nz,lab3833
    jr nz,lab3845
    djnz lab382D+2
    inc c
    sub b
    ld (bc),a
    inc bc
    rlca 
    jr lab381E
lab381E ld bc,lab00FF
    rrca 
    rst 56
lab3823 ld bc,labFFEF
    rlca 
    rst 40
lab3828 rst 56
lab3829 rst 48
    rst 40
    rst 56
    sub b
lab382D ld bc,lab0DF2
lab3830 djnz lab383A
    nop
lab3833 sbc a,(hl)
    nop
    sub a
    rra 
    cp a
lab3838 cp 255
lab383A cp h
    rst 56
    ret m
    rst 56
    ret nz
    rst 48
    nop
    cp (hl)
    nop
    sbc a,h
lab3844 nop
lab3845 adc a,b
    nop
    sub b
lab3848 ld bc,lab09F6
    and h
    ld c,11
    ld b,23
lab3850 nop
    rra 
    nop
    inc h
    nop
    inc h
    inc bc
    ld hl,lab1B07+1
    ld c,17
    inc d
    add hl,bc
    nop
    ld bc,lab00FF
    nop
    ld bc,labFFFE+1
    ret p
    nop
    ld a,a
    rst 56
    rst 56
    call m,lab0F1E+2
    rst 56
    rst 56
lab3870 rst 56
    and b
    nop
    ld a,a
    rst 56
    rst 56
    ld b,b
    nop
    ld bc,labFCFF
    nop
    nop
    nop
    rlca 
    ret p
    nop
    djnz lab3823
    jr nz,lab3885
lab3885 nop
    jr nz,lab3888
lab3888 jr nz,lab388A
lab388A jr nz,lab388C
lab388C ld e,2
    inc e
    inc bc
    dec de
    inc b
    ld a,(de)
    inc b
    add hl,de
    inc b
    add hl,de
    inc b
    jr lab389E+1
    rla 
    ex af,af''
    inc de
    ld a,(bc)
lab389E djnz lab38AC
    inc c
    inc c
    ex af,af''
    rra 
    xor d
lab38A5 xor e
    db 253
    db 255
    push de
    ld a,(hl)
    cp d
    ld h,l
lab38AC ld a,a
    push de
    ld l,b
    ld a,(de)
    xor d
    xor d
    ret c
    dec c
    ld d,l
    ld d,l
    xor b
    ld b,170
    xor e
lab38BA ld e,b
    inc bc
    ld d,l
    ld e,(hl)
    or b
    ld (bc),a
    xor d
    push af
    ld d,b
    rlca 
    rst 56
    xor d
    and b
    inc bc
    push de
    ld d,l
    ld h,b
    nop
    ld l,d
lab38CD xor d
    ret nz
    nop
    dec e
    ld d,l
    add a,b
    nop
    ld b,190
    nop
    nop
    rlca 
    ret po
    nop
    sub c
    ld (bc),a
    ld (bc),a
    rst 16
    ex af,af''
    or 33
    ret c
    nop
    nop
    ld e,52
    ld b,e
    adc a,e
    sub e
    adc a,h
    add a,l
    add a,l
    add a,l
    add a,h
    add a,h
    add a,h
    add a,h
    adc a,e
    adc a,e
    adc a,e
    adc a,e
    adc a,d
    adc a,d
    adc a,d
    adc a,d
    sub c
    sbc a,c
    sbc a,c
    and c
    and c
    xor c
    cp b
    ret nz
    ret nz
    adc a,a
    inc bc
    add a,b
    nop
    inc c
    ld b,b
    nop
    dec d
    jr z,lab38CD
    inc de
    or e
    and b
    inc de
    adc a,80
    dec c
    db 253
    db 208
    ld bc,labB0FA
    ld (bc),a
    push af
    ld d,b
    inc bc
    ld l,d
    or b
    ld (bc),a
    push af
    ld h,b
    inc bc
    ld l,d
    and b
    ld b,181
    ld h,b
    dec b
    ld l,d
    and b
    ld b,213
    ld h,b
    dec b
    ld l,d
    and b
    ld a,(bc)
lab3932 push de
    ld h,b
    dec c
    xor d
    and b
    dec bc
    ld d,l
lab3939 ld b,b
    dec c
    xor d
    ret nz
    dec de
    ld d,l
    ld b,b
    ld d,170
    ret nz
    dec e
    ld d,l
    ld b,b
    ld d,170
    ret nz
    dec a
    ld d,l
    ld b,b
    ld hl,(labA0AA)
    dec a
    ld d,l
    ld h,b
    ld a,(de)
    xor d
    or b
    dec (hl)
    ld d,l
    ld d,b
    ld hl,(labA8AA)
    ld (hl),l
    ld d,l
    ld d,h
    ld l,d
    xor d
    xor e
    sub c
    ld (bc),a
    inc bc
    ld bc,labF909
    add hl,bc
    sub (hl)
    jr lab396B
lab396B nop
    ld d,0
    ld d,2
    ld (de),a
    inc bc
    ld de,lab1103
    inc b
    djnz lab397D
    rrca 
    rlca 
    rlca 
    ld a,h
    rlca 
lab397D ret m
    rra 
    rst 56
    ret po
    rrca 
    rst 56
    ret nz
    rrca 
    rst 56
    ret po
    rlca 
    rst 56
    ret po
    inc bc
    rst 56
    ret po
    nop
    ret m
    nop
    ld a,(bc)
    and e
    dec c
    dec bc
    dec bc
    djnz lab39A0
    inc d
    dec b
    add hl,de
    dec b
    ld a,(de)
    inc bc
    jr nz,lab399F
lab399F inc hl
lab39A0 nop
    inc hl
    nop
    inc hl
    jr z,lab39A6
lab39A6 nop
    inc bc
    cp 0
    nop
    nop
    rrca 
    rst 56
    ret nz
    nop
    nop
    ccf 
lab39B2 rst 56
    ret p
    nop
    inc bc
    ret po
    ccf 
    ret m
    nop
    ld bc,labC0FF
    inc e
    nop
    rrca 
    rst 56
    rst 56
    and 64
    ld a,(hl)
    rrca 
    rst 56
    di
    ld b,b
    ld bc,lab3FF0
    adc a,(hl)
    add a,b
    sub c
    ld (bc),a
    ld (bc),a
    push hl
    ex af,af''
    or 19
    ret c
    nop
    nop
    ld e,52
    ld b,e
    adc a,e
    sub e
    adc a,h
    adc a,h
    adc a,h
    adc a,e
    adc a,e
    sub d
    sbc a,d
    and c
    xor c
    ret nz
    ret nz
    adc a,a
    inc bc
    add a,b
    nop
    inc c
    ld b,b
    nop
    dec d
    jr c,lab39B2
    inc de
    rst 0
    and b
    inc de
    rst 56
    ld d,b
    dec c
    jp m,lab02AF+1
    push af
    ld d,b
    inc bc
    ld l,d
    or b
    ld b,181
    ld h,b
    dec b
    ld l,d
    and b
    ld a,(bc)
    push de
    ld h,b
    dec c
    xor d
    and b
    dec de
    ld d,l
    ld h,b
    ld d,170
    or b
    dec l
    ld d,l
    ld d,b
    ld a,(labA8AA)
    ld (hl),l
    ld d,l
    ld d,(hl)
    inc e
    and b
    jr nz,lab3A20
lab3A20 ld (bc),a
    ld e,0
    jr nz,lab3A25
lab3A25 jr nz,lab3A27
lab3A27 ld e,0
    ld e,0
    ld e,2
    inc e
    inc b
    ld a,(de)
    dec b
    add hl,de
    ld b,24
    ld b,24
    dec b
    add hl,de
    dec b
    add hl,de
lab3A3A dec b
    jr lab3A41
    add hl,de
    inc b
    add hl,de
    inc b
lab3A41 jr lab3A48
    rla 
    ld b,21
    ex af,af''
    inc de
lab3A48 ld a,(bc)
    rrca 
    dec bc
    ld c,11
    inc c
    inc c
    dec bc
    inc c
    ld a,(bc)
    inc c
    rlca 
    inc c
    dec b
    rlca 
    ld d,l
    ld d,l
    db 253
    db 26
    xor d
    xor a
    jp m,lab5F73+2
    db 253
    db 120
    rst 56
    jp m,labD8AA
    ld (hl),l
    ld d,l
    ld d,l
    xor b
    ld a,(de)
    xor d
    xor e
    ld e,b
    dec b
    ld d,l
    ld d,(hl)
    xor b
    ld (bc),a
    xor d
    xor l
    ld e,b
    ld bc,lab7A53+2
    xor b
    ld bc,labF5AA
    ld e,b
    ld bc,labAA55
    xor b
    ld bc,lab55AB
    ld e,b
    inc bc
    ld e,(hl)
    xor d
    or b
    ld (bc),a
    or l
    ld d,l
    ld d,b
    inc bc
    jp pe,labB0AA
    rlca 
    ld d,l
    ld d,l
    ld h,b
    ld (bc),a
    xor d
    xor d
    and b
    ld bc,lab55D5
    ld b,b
    nop
    ld l,d
    xor d
    ret nz
    nop
    dec d
    ld d,l
    nop
    nop
    ld a,(bc)
    xor e
    nop
    nop
    dec c
    ld d,h
    nop
    nop
    ld b,172
    nop
    nop
    dec b
    ld a,b
    nop
    nop
    ld b,192
    nop
    nop
    rlca 
    nop
    nop
    add a,c
    inc b
lab3AC0 ld c,250
    rrca 
    adc a,(hl)
    nop
    dec b
    nop
    ex af,af''
    nop
    add hl,bc
    nop
    ld a,(bc)
    nop
    dec c
    nop
    ld c,0
    ld c,0
    ld c,0
    ld c,0
    ld c,0
    ld c,3
    dec bc
    ex af,af''
    ld b,10
    inc b
    dec bc
    inc bc
    ld d,b
    nop
    xor d
    nop
    push af
    nop
    jp m,labFF7F+1
    ld d,b
    rst 56
    xor b
    rst 56
    call nc,labF8FF
    rst 8
    call m,labFC0F
    nop
    ld a,h
    nop
    inc e
    nop
    inc c
    add a,c
    inc b
    rrca 
    call m,lab8F0D
    nop
    dec b
    nop
    ld a,(bc)
    nop
    dec c
    nop
    ld c,0
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    inc bc
    inc b
    inc b
    inc c
    inc bc
    ld d,b
    nop
    xor d
    add a,b
    push af
    ld d,b
    rst 56
    xor b
lab3B24 rst 56
    call p,labFAFF
    rst 56
    cp 255
    cp 199
    cp 6
    ld a,0
    ld b,129
    inc b
lab3B34 djnz lab3B34
    dec bc
    ret nc
    jr c,lab3BAA
lab3B3A add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld b,b
    ld d,h
    nop
    xor d
    xor b
    rst 56
    ld d,l
    rst 56
    jp m,labFFFE+1
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    add a,7
    add a,c
    inc b
    djnz lab3B59
lab3B59 dec bc
    ret nc
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld c,b
    ld b,b
lab3B66 ld d,l
    ld d,l
    xor d
    xor d
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    di
    rst 56
    nop
    add a,0
    sub c
    inc b
    rrca 
    ld (bc),a
    nop
    ld (bc),a
    dec c
    rst 8
    nop
    ld b,a
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld h,b
    ld c,b
    ld b,b
    jr lab3B8E
lab3B8E inc b
    nop
    xor d
    ld d,l
    ld d,(hl)
    xor d
    cp 255
    cp 255
    cp 255
    jp m,labE0FF
    rst 56
    nop
    cp 0
    ret nz
    nop
    sub e
    ld b,12
    db 253
    db 4
    ld b,255
lab3BAA inc c
    jr lab3BAF+1
    nop
    dec b
lab3BAF ld d,147
    dec c
    inc bc
    inc c
    dec b
    dec bc
    ld b,9
    ex af,af''
    rlca 
    ld a,(bc)
    nop
    djnz lab3BBE
lab3BBE djnz lab3BC0
lab3BC0 rrca 
    nop
    ld c,0
    rrca 
    nop
    djnz lab3BC8
lab3BC8 inc d
    nop
    inc d
    nop
    inc d
    nop
    inc d
    nop
    inc de
    ld bc,lab0111
    ld c,1
    inc b
    ld bc,lab0104
    inc b
    ld (bc),a
    inc bc
    nop
    ld (bc),a
    nop
    nop
    rlca 
    nop
    nop
    rrca 
    nop
    nop
    inc a
    nop
    nop
    jp m,lab5700
    ld (hl),h
    nop
    xor b
    ret pe
    nop
    rst 56
    ret nc
    nop
    rst 56
    xor b
    nop
lab3BF8 rst 56
    call nc,labFF00
    jp pe,labAF00
    call m,labD7A0
    rst 56
    ret po
    ld l,a
    rst 56
    ld b,b
    ld e,103
    add a,b
    add hl,de
    call z,lab3000
    nop
    nop
    jr nc,lab3C12
lab3C12 nop
    jr nc,lab3C15
lab3C15 nop
    djnz lab3C18
lab3C18 nop
    sub d
    ld b,12
    db 253
    db 4
    ld b,255
    nop
    inc bc
    inc d
    sub e
    ld c,3
    inc c
    ld b,10
    ex af,af''
    nop
    ld (de),a
    nop
    ld (de),a
    nop
    djnz lab3C31
lab3C31 rrca 
    nop
    djnz lab3C35
lab3C35 inc d
    nop
    inc d
    nop
    inc d
    nop
lab3C3B inc d
    nop
    inc de
    nop
    ld (de),a
    ld (bc),a
    ld c,2
    dec b
    ld (bc),a
    dec b
    ld (bc),a
    dec b
    inc bc
    inc b
    inc b
    inc bc
    nop
    ld bc,lab0000
    rlca 
    add a,b
    nop
    ld e,128
    ld d,a
    ld a,d
    nop
    xor b
    call p,labFF00
    ret pe
    nop
    rst 56
    sub h
    nop
    rst 56
    jp pe,labFF00
    db 253
    db 32
    xor a
    rst 56
    ret po
    rst 16
    rst 56
    ld b,b
    ld l,a
    inc sp
    add a,b
    dec c
    and 0
    inc e
    nop
    nop
    jr lab3C78
lab3C78 nop
    jr lab3C7B
lab3C7B nop
    inc c
lab3C7D nop
    nop
    inc b
    nop
    nop
    sub d
    ld b,12
    db 253
    db 4
    ld b,255
    nop
    ld bc,labD412
    nop
    sbc a,b
    sbc a,b
    sbc a,b
    sbc a,b
    sub b
    xor b
    xor b
    xor b
    xor b
    and b
    sbc a,b
    ld (hl),e
    inc hl
    dec hl
lab3C9C dec hl
    inc h
    dec e
    nop
    inc bc
    add a,b
    ld d,a
    ccf 
    ret nz
    xor b
    db 253
    db 64
    rst 56
    jp pe,labFF00
    sub h
    nop
    rst 56
    jp pe,labFF7F+1
    rst 56
    ld d,b
    rst 16
    rst 56
    ret p
    ex de,hl
    rst 56
    and b
    ld (hl),a
lab3CBB sbc a,c
    ret nz
    dec c
    di
    nop
    inc c
    nop
    nop
    inc c
    nop
    nop
    inc c
    nop
    nop
lab3CC9 ld b,0
    nop
    ld (bc),a
    nop
    nop
    add a,c
    inc b
    jr nc,lab3CC9
    jr lab3C7D
    ld de,lab0E05
    dec c
    dec bc
    inc de
    ex af,af''
    add hl,de
    rlca 
    dec de
    inc b
    rra 
    inc bc
    ld hl,lab2700
    nop
    jr z,lab3CE8
lab3CE8 jr z,lab3CEA
lab3CEA jr z,lab3CEC
lab3CEC jr z,lab3CEE
lab3CEE jr z,lab3CF0
lab3CF0 jr z,lab3CF2
lab3CF2 jr z,lab3CF4
lab3CF4 jr z,lab3CF6
lab3CF6 jr z,lab3CF8
lab3CF8 jr z,lab3CFA
lab3CFA add a,e
    inc h
    nop
    inc b
    inc h
    inc b
    and b
    ld bc,lab0801+2
    add a,(hl)
    ld (bc),a
    ld (de),a
    ex af,af''
    add a,h
    inc b
    add a,(hl)
    ld (bc),a
    inc b
    djnz lab3D13
    nop
    nop
    jr z,lab3D13
lab3D13 nop
    nop
    ld bc,lab4055
    nop
    nop
    ld a,(bc)
    xor d
    xor b
    nop
    nop
    ld d,l
    ld d,l
    ld d,l
    nop
    nop
    xor d
    xor d
    xor d
    add a,b
    dec b
    ld d,l
    ld d,l
    ld d,l
    ld b,b
    ld a,(bc)
    xor d
lab3D2F xor d
    xor d
    and b
    ld d,l
    ld d,l
    push af
    ld d,l
    ld d,h
    xor d
    cp a
    rst 56
    jp pe,lab55AA
    rst 56
    rst 56
    rst 56
    ld d,l
    xor e
    rst 56
    rst 56
    rst 56
    xor (hl)
    rst 16
    rst 56
    rst 56
    rst 56
    ld e,a
    ei
    rst 56
    rst 56
    cp 255
    db 253
    db 255
    rst 56
    db 253
    db 255
    rst 56
    rst 56
    cp 63
    rst 56
    cp a
    rst 56
    ret m
    rra 
    rst 56
    rst 0
    rst 56
    ret po
    rst 56
    rst 56
    inc bc
    cp a
    rst 56
    rst 56
    pop de
    ld b,22
    rst 56
    call p,lab00E3
    jr c,lab3D87
    add hl,sp
    add a,b
    nop
    ld h,b
    jr c,lab3DD7
    nop
    nop
    nop
    ld h,b
    nop
    nop
    sub b
    call p,lab0806
    adc a,h
    ld bc,lab0005
    add hl,bc
    nop
lab3D87 dec bc
    nop
    inc c
    inc bc
    ld a,(bc)
    rlca 
    rlca 
    add hl,bc
    dec b
    ld a,(bc)
    inc b
    jr c,lab3D94
lab3D94 ld a,a
    nop
    rrca 
    ret nz
    nop
    ret po
    nop
    jr nc,lab3D9D
lab3D9D jr lab3D2F
    rst 48
    ld a,(bc)
    inc c
    jp z,lab3828
    ld b,b
    ld c,b
    ld b,c
lab3DA8 inc (hl)
    dec l
    ld l,46
    daa
    daa
    daa
    ld (hl),b
    nop
    ld a,h
    nop
    ld a,0
    rlca 
    nop
    inc bc
    nop
    ld bc,lab017F+1
    add a,b
    nop
    ret nz
    nop
    ret nz
    nop
    ld b,b
    sub b
    jp m,lab110E+1
    ret z
    add hl,de
    jr nz,lab3DF3
    jr z,lab3DF5
    jr nc,lab3DF7+1
    ld (lab2A2A),hl
    inc hl
    inc hl
    dec hl
    dec hl
    inc h
lab3DD7 inc h
    inc h
    jr nz,lab3E3B
    ld (hl),b
    ld (hl),b
    jr nc,lab3DF7
    jr lab3DF9
    inc c
    inc c
    inc c
    inc c
    ld b,6
    ld b,144
    cp 16
    ld (de),a
    call nz,lab2018+1
    jr z,lab3E19
    jr z,lab3E1B
lab3DF3 jr z,lab3E14+1
lab3DF5 jr nz,lab3E16+1
lab3DF7 jr nz,lab3E19
lab3DF9 jr nz,lab3E1B
    jr nz,lab3E1D
lab3DFD jr nz,lab3E1E+1
    jr nz,lab3E61
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
    ld h,b
lab3E0D ld h,b
    ld h,b
    sub b
    nop
    ld bc,lab0504+1
lab3E14 djnz lab3DF5+1
lab3E16 jr lab3DA8
    nop
lab3E19 ld (bc),a
    dec b
lab3E1B ex af,af''
    inc bc
lab3E1D inc a
lab3E1E jp nz,lab0804+1
    ex (sp),hl
    inc e
    inc bc
    sub c
    ex af,af''
    dec c
    ld b,6
    ld b,17
    ret nc
    ld c,a
    ld (hl),54
    ld (hl),79
    ld d,(hl)
    ld a,c
    add a,b
    add a,b
    ld a,b
    ld a,b
    ld (hl),b
    ld l,b
    ld d,b
    ld b,c
lab3E3B add hl,sp
    ld (lab4000+1),hl
lab3E3F ld bc,lab00E0
    ret po
    nop
    ret po
    nop
    pop af
    ld bc,lab2AF8+2
    cp 93
    ld a,h
    xor (hl)
    call p,labC85F
    rst 56
    ret p
    ld a,(hl)
    add a,b
    add hl,de
    nop
    ld a,0
    jr lab3E5B
lab3E5B sub c
    ex af,af''
    dec bc
    inc b
    nop
    inc b
lab3E61 rrca 
    sub l
    jr lab3E65
lab3E65 add hl,bc
    ld b,9
    rlca 
    ld a,(bc)
    rlca 
    inc b
    inc bc
    ld bc,lab0114
    inc d
    nop
    dec d
    nop
    inc d
    nop
    inc de
    nop
    ld (de),a
    ld bc,lab020F+1
    ld c,2
    ex af,af''
    inc bc
    dec b
    nop
    inc (hl)
    nop
    nop
    inc e
    nop
    nop
    ld e,0
    nop
    rrca 
    nop
    inc b
    cpl 
    nop
    dec hl
    ld d,a
    sub b
    dec d
    xor e
    ret po
    ld l,a
    rst 24
    ret nz
    ld a,a
    db 253
    db 128
    ccf 
    di
    nop
    ld c,222
    nop
    add hl,de
    add a,b
    nop
    ld c,0
    nop
    sub c
    ex af,af''
    dec c
    inc bc
    nop
    inc bc
    ld c,149
    jr lab3EB2
lab3EB2 ex af,af''
    rlca 
    ex af,af''
    ex af,af''
    inc b
    inc bc
    ld bc,lab010F+1
    ld de,lab14FF+1
    nop
    dec d
    nop
    dec d
    nop
    inc d
    ld bc,lab0211+1
    djnz lab3ECB
    rrca 
    inc bc
lab3ECB dec b
    nop
    ld l,b
    nop
    nop
    inc a
    nop
    nop
    ld a,0
    inc b
    rra 
    nop
    ld hl,(lab00CF)
    dec d
    rst 16
    add a,b
    ld a,d
    ex de,hl
    ret nc
    ld a,a
    rst 56
    ret po
    ccf 
    rst 56
    ld b,b
    ld c,124
    add a,b
    dec e
    cp a
    nop
    ld c,14
    nop
    sub c
    ex af,af''
lab3EF2 ld de,lab0702+1
    inc bc
    ld c,208
    ld c,a
    ld (hl),d
    ld (hl),d
    ld a,c
    add a,b
lab3EFD add a,b
lab3EFE ld a,b
    ld a,b
lab3F00 ld (hl),b
    ld l,b
    ld d,b
    ld b,c
    add hl,sp
    ld (lab801B),hl
    rrca 
    pop hl
    inc bc
    jp m,labFE29+1
    ld e,l
    call m,labF4AE
    ld e,a
    ret z
    rst 56
    ret p
    ld a,(hl)
    add a,b
    add hl,de
    nop
    ld a,0
    jr lab3F1E
lab3F1E sub c
    ex af,af''
lab3F20 inc d
    dec b
    add hl,bc
    dec b
    djnz lab3EF2+2
    ld c,a
    ld b,c
    ld d,c
    ld l,d
    ld h,e
    ld l,d
    ld l,c
    ld (hl),b
    ld (hl),b
    ld l,b
    ld h,b
    ld e,b
    ld d,c
    ld b,d
    inc sp
    dec hl
    inc (hl)
    nop
    rra 
    nop
    rrca 
    call nz,labE407
    ld (bc),a
    ret m
    dec d
    ret c
    ld hl,(lab5DD8)
    or b
    cpl 
    ret po
    ld e,a
    add a,b
    ld a,192
    inc e
    add a,b
    rlca 
    nop
    ld c,0
    sub c
    ex af,af''
    ld de,lab0806+1
    rlca 
    ld (de),a
    ret nc
    ld c,a
    inc (hl)
    inc a
    inc a
    dec a
    ld e,l
    ld e,l
    ld (hl),d
    ld a,c
    ld a,b
    ld (hl),b
    ld (hl),b
    ld l,b
    ld h,b
    ld e,c
    ld c,d
    dec sp
    dec hl
    dec b
    nop
    rlca 
    add a,b
    inc bc
    ret nz
    inc bc
    ret nz
    ld bc,lab01DE+2
    jp p,labFE02
    dec d
    call m,labE82A
    ld e,l
    ld l,b
    cpl 
    ret p
    ld e,a
    ret nz
    ccf 
    ld h,b
lab3F86 ld e,64
    rlca 
    add a,b
    ld c,0
    sub b
    ld sp,hl
    inc b
    ld b,147
    nop
    add a,h
    ld a,(bc)
    dec b
    nop
    inc de
    nop
    inc de
    ld bc,lab0312
    djnz lab3FB6
    nop
    ld h,b
    ld bc,lab3AC0
    cp a
lab3FA4 nop
    dec c
    ld a,b
    ld b,b
lab3FA8 ld (bc),a
    rst 0
    add a,b
    sub b
    ei
    rlca 
    add hl,bc
    adc a,l
    ex af,af''
    inc bc
    ld bc,lab0482+1
    inc b
lab3FB6 nop
    add a,h
    inc b
    inc b
    nop
    add a,h
    inc b
    inc b
    nop
lab3FBF add a,(hl)
    ld bc,lab0005+1
    dec c
    ld bc,lab020B+1
    dec bc
lab3FC8 djnz lab3FCA
lab3FCA nop
    ld b,b
    jr nz,lab3FED+1
    ld b,b
    ld h,b
    ld h,b
    ld b,b
    jr c,lab3FA4
    dec d
    sub b
    dec bc
    ld h,b
    sub b
    call m,lab0906+1
    adc a,l
    dec b
    inc b
    ld bc,lab000B
    dec c
    nop
    dec c
    nop
    add a,l
    ld (bc),a
    ld b,0
    dec c
    nop
    inc c
lab3FED ld bc,lab100A
lab3FF0 nop
    inc bc
    nop
    dec (hl)
    and b
    ld h,b
    ret nc
    ld h,b
    ld d,b
    ld d,b
lab3FFA ret po
    dec hl
    ret nz
    rla 
    nop
    sub b
lab4000 call m,lab0906+1
    adc a,h
    inc b
    inc b
    inc b
    rlca 
    ld bc,lab000B
    inc c
    nop
    add a,l
    ld bc,lab0005+1
    inc c
    nop
    inc c
    ld bc,lab100A
    nop
    ld b,0
    inc bc
    ld b,b
    ld sp,lab6120
    and b
    ld (hl),b
    ret po
    dec hl
    ret nz
    dec d
lab4025 add a,b
    sub c
    ld a,(bc)
lab4028 ret po
    rst 48
    ret po
    ld sp,hl
    ld a,(bc)
    and b
    ld b,13
    inc bc
    rla 
    nop
    jr nz,lab4035
lab4035 jr nz,lab4037
lab4037 jr nz,lab4039
lab4039 jr nz,lab403B
lab403B jr nz,lab403D
lab403D ex af,af''
    nop
    dec b
lab4040 nop
    ld (bc),a
    ld bc,lab4055
    nop
    ld a,(bc)
    xor d
    xor d
    add a,b
    ld d,a
    rst 56
    push af
    ld d,l
    cp a
    rst 56
    rst 56
    xor d
    rst 56
    rst 56
    rst 56
lab4055 rst 56
    cp 3
    rst 56
    rst 56
    ret p
    nop
    rra 
    rst 56
    add a,b
    nop
    nop
    rst 56
    sub c
    ld a,(bc)
    ret po
    push af
    ret po
    rst 48
    add hl,bc
    ret po
    rst 8
    db 221
    db 248
    ret m
    ret m
    ret m
    ret m
    ret m
    ld d,b
    nop
    dec d
    dec b
    ld d,l
    ld (bc),a
    xor d
    xor d
    xor d
    ld d,l
    ld d,l
    ld e,a
    rst 56
    xor a
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
lab4089 rst 56
    rst 56
    rst 56
    add a,c
    rst 56
    ret nz
lab408F sub c
    ld a,(bc)
    ret po
    ret m
    ret po
    ret m
    dec bc
    and b
    nop
    inc b
    nop
    rlca 
    nop
    inc c
    nop
lab409E jr nz,lab40A0
lab40A0 jr nz,lab40A2
lab40A2 jr nz,lab40A4
lab40A4 jr nz,lab40A6
lab40A6 jr nz,lab40AD
    dec de
    ld a,(bc)
    inc d
    rrca 
    add hl,bc
lab40AD and b
    nop
    nop
    nop
    ld d,h
    nop
    nop
    ld d,l
    jp pe,lab2AA0
    xor d
    ld d,iyl
    ld d,l
    ld a,a
    rst 56
    jp pe,labFFBF
    ld a,a
    rst 56
    rst 56
    rst 56
    inc bc
    rst 56
    rst 56
    rst 56
    nop
    rra 
    rst 56
    ret m
    nop
    nop
    cp 0
    sub b
    jp pe,lab0E05
    sub (hl)
    nop
    rlca 
    nop
    rlca 
    nop
    rlca 
    nop
    rlca 
    nop
    ld a,(bc)
    nop
    adc a,h
    rlca 
    inc bc
    nop
    adc a,l
    dec b
    inc b
    inc b
    ld (de),a
    dec b
    ld de,lab1006
    rlca 
    rrca 
    ex af,af''
    ld c,10
    inc c
    inc c
    rlca 
    nop
    nop
    nop
    ld a,h
    nop
    nop
    ld (hl),b
    nop
lab40FE nop
    ld e,b
lab4100 nop
    nop
    ld e,h
    nop
    nop
    ld c,a
    nop
    nop
    rlca 
    and b
    ex af,af''
    inc bc
    ret nc
    inc d
    ld bc,labACE9+1
    nop
    push af
    ld a,h
    nop
    ld a,a
    call m,lab1F00
    ret m
    sub b
    ret pe
    inc b
    inc c
    ret c
    ld hl,lab4028
    ld e,b
    add a,b
    ret nz
    cp c
    cp c
    or d
    adc a,a
    adc a,a
    adc a,a
    jr nc,lab412D
lab412D nop
    ld h,b
    nop
    nop
    jp pe,lab0000
    ld (hl),l
    ld b,b
    nop
    ccf 
    xor d
    ld a,(bc)
    daa
    push af
    ld d,l
    ld de,labAFFE
    nop
    ld a,a
    rst 56
    nop
    rrca 
    rst 56
    nop
    ld bc,lab90F0
    ret pe
    nop
    rrca 
    sbc a,b
    ld de,lab0E07
    ld a,(bc)
    dec bc
    dec c
    ld a,(bc)
lab4155 ld c,9
    rrca 
    rlca 
    ld de,lab1205+1
    dec b
    ld a,(bc)
    nop
    add a,e
    ld bc,lab0008+1
    dec bc
    nop
    add hl,bc
    ld bc,lab0107+1
    ex af,af''
    ld (bc),a
    dec b
    ld (bc),a
    inc bc
    nop
    nop
    ld hl,(lab0100)
    ld d,l
    nop
    ld a,(bc)
    rst 56
    nop
    rla 
    rst 56
    nop
    cpl 
    add a,a
    nop
    call c,lab0100
    ld (hl),b
    nop
    ld (bc),a
    ret nz
    nop
    ld b,a
    nop
    nop
    ld l,0
    nop
    ccf 
    nop
    nop
    inc e
    nop
    nop
    djnz lab4194
lab4194 nop
    sub b
    call p,lab1200
    call lab4B44
    ld d,d
    ld e,c
    ld e,c
    ld h,b
    ld h,b
    jr z,lab41CB
    jr z,lab41D5
    add hl,hl
    ld b,c
    ld a,(lab3A3A)
    ld a,(lab053A)
    ld d,b
    ld a,(bc)
    and b
    rla 
    ret p
    ccf 
    ret p
    inc a
    ld (hl),b
    ld (hl),b
    nop
    ld (hl),b
    nop
    ld h,b
    nop
    ld d,b
    nop
    jr nc,lab41C0
lab41C0 jr z,lab41C2
lab41C2 djnz lab41C4
lab41C4 dec e
    nop
    rrca 
    nop
    rlca 
    nop
    rra 
lab41CB nop
    sub b
    nop
    dec b
    ld d,146
    inc c
    inc bc
    dec bc
    dec b
lab41D5 ld a,(bc)
    ld b,9
    rlca 
    rlca 
    add hl,bc
    nop
    djnz lab41DE
lab41DE djnz lab41E0
lab41E0 rrca 
    nop
    rrca 
    nop
    rrca 
    nop
    djnz lab41E8
lab41E8 ld (de),a
    nop
    inc de
    nop
    inc de
    nop
    inc de
    nop
    ld (de),a
    ld bc,lab010F+1
    add hl,bc
    ld bc,lab0107
    rlca 
    ld bc,lab0207
    ld b,0
    inc b
    nop
lab4200 nop
    ld c,0
    nop
    ld e,0
    nop
    inc a
    nop
    nop
    jp m,lab55FF+1
    call p,labA900
    call po,labFF00
    ret z
    nop
    rst 56
    adc a,b
    nop
    rst 56
    call nz,labFF00
    jp po,labAF00
    db 253
    db 128
    rst 16
    rst 56
    ret nz
    ld l,a
    db 253
    db 128
    inc a
    rst 40
    nop
    dec de
    adc a,h
    nop
    jr nc,lab422F
lab422F nop
    ld (hl),0
    nop
    ld (hl),0
    nop
    ld (de),a
    nop
    nop
    sub b
    nop
    dec b
    ld d,143
    ex af,af''
    inc b
    rlca 
    ld b,6
    rlca 
    dec b
    add hl,bc
    inc bc
    dec bc
    nop
    ld c,0
    ld c,0
    rrca 
lab424E nop
    rrca 
lab4250 nop
    rrca 
    nop
    rrca 
    nop
    djnz lab4257
lab4257 djnz lab4259
lab4259 djnz lab425B
lab425B djnz lab425D
lab425D rrca 
    ld bc,lab010D
    inc c
    ld bc,lab0104
    inc b
    ld bc,lab0203+1
    inc bc
    nop
    ld h,b
    nop
    ret p
    ld bc,lab03CE+2
    ret z
    rrca 
    ld c,b
    ld d,a
    ex af,af''
    xor (hl)
    ex af,af''
    call m,labFC04
    inc b
    cp 4
    rst 56
    ld b,h
    ld e,a
    add a,191
    cp 95
    call nc,labF839
    scf
    or b
    jr nc,lab428C
lab428C jr nc,lab424E
    jr nc,lab4250
    djnz lab42D2
    sub d
    inc b
    inc bc
    ld (bc),a
    inc c
    dec d
    inc b
    nop
    add hl,bc
    ld d,211
    scf
    ccf 
    ccf 
    ccf 
    ld a,69
    ld d,e
    ld l,b
    ld (hl),b
    adc a,b
    and b
    and b
    and b
    and b
    sbc a,b
    sub b
    add a,b
    dec hl
    inc sp
    inc (hl)
    dec l
    ld h,0
    jr nc,lab42B6
lab42B6 nop
    ld a,b
    nop
    nop
    ld h,b
    nop
    nop
    ret nc
    nop
    ld bc,lab00E0
    inc bc
    ret nc
    nop
    dec c
    and b
    nop
    ld d,c
    ret nc
    nop
    xor a
    xor b
    nop
    rst 56
    push de
    nop
    rst 56
lab42D2 cp 160
    rst 56
    rst 56
    ret po
    cp a
    rst 56
    ld b,b
    ld e,a
    inc sp
    add a,b
    xor l
    and 0
    inc c
    nop
    nop
    ld c,0
    nop
    ld b,0
    nop
    inc bc
    nop
    nop
    ld bc,lab0080
    sub d
    inc b
    dec b
    db 253
    db 12
    dec d
    ret z
    nop
    rst 56
lab42F8 ld de,lab28D2
    jr nc,lab428C+1
    sub b
    sub b
    sub b
    add a,b
    ld a,b
    ld a,b
    ld a,b
    add a,b
    adc a,b
    sbc a,b
    sbc a,b
    ld (hl),l
    ld e,a
    ld d,a
    ld d,b
    nop
    nop
    xor b
    rrca 
    nop
    rst 16
    ld a,a
    add a,b
    ret m
    call m,labFF7F+1
    jp pe,labFF00
    call nc,lab5F00
    xor b
    nop
    xor a
    call nc,lab5F00
    ret pe
    nop
    ccf 
    call p,lab7EFF+1
    jp m,labEC00
    db 253
    db 0
    jp lab409E
    add a,b
    dec e
    add a,b
    add a,b
    scf
    nop
    sub c
    ex af,af''
    ret m
    nop
    ret m
    nop
    ld a,(bc)
    ret z
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld (lab5524),a
    xor d
    rst 56
    rst 56
    rst 56
    rst 56
    rra 
    rlca 
    sub c
    ex af,af''
    ret p
    nop
    ret p
    nop
    ld a,(bc)
    ret nc
    ld d,(hl)
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld c,a
    ld bc,labAA55
    xor d
    ld d,l
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    nop
    ccf 
    sub c
    ld a,(bc)
    ret po
    call m,lab00E0
    add hl,bc
    and b
    dec e
    inc bc
    ld d,10
    ld bc,lab0003
    jr nz,lab4385
lab4385 jr nz,lab4387
lab4387 jr nz,lab4389
lab4389 jr nz,lab438B
lab438B jr lab438D
lab438D ld c,0
    nop
    nop
    ld (bc),a
    nop
    nop
    ld bc,lab20FF
    ccf 
    rst 56
    rst 56
    rst 24
    rst 56
    rst 56
    rst 56
    cp a
    rst 56
    rst 56
    cp 255
    rst 56
    cp 0
    rst 56
    ret m
    nop
    nop
    sub b
    ret pe
    inc bc
    add hl,bc
    sbc a,b
    nop
    dec b
    nop
    dec bc
    nop
    ld de,lab1800
    ld bc,lab0217
    ld d,4
    inc d
    ex af,af''
    djnz lab43CE
    ld a,(bc)
    ret p
    nop
    nop
    ld a,a
    ret nz
    nop
    ccf 
    rst 56
    nop
    rra 
    rst 56
    rst 56
    rlca 
lab43CE rst 56
    rst 56
    nop
    ld a,a
    rst 56
    nop
    ld bc,lab91FF
    ld a,(bc)
    ret p
    cp 240
    nop
    add hl,bc
    sub b
    dec c
    inc bc
    inc b
    inc bc
    nop
lab43E3 djnz lab43E5
lab43E5 djnz lab43E7
lab43E7 djnz lab43E9
lab43E9 djnz lab43EB
lab43EB ld c,0
    dec bc
    nop
    inc b
    nop
    ld (bc),a
    inc b
    ccf 
    db 253
    db 255
    ei
    cp 255
    ret m
    rst 56
    ret nz
    ret po
    nop
lab43FE ld de,lab009F+1
lab4401 dec b
    nop
    ld de,lab1300
    ld (bc),a
    ld d,2
    rla 
    ld bc,lab0018
    add hl,de
    nop
    dec de
    nop
    dec e
    ld b,14
    ld b,16
    dec bc
    dec c
    ld c,18
    djnz lab442C
    inc de
    dec c
    ld d,10
    inc e
    inc b
    ld (hl),c
    ret nz
    nop
    nop
    rra 
    ccf 
    nop
    nop
    rlca 
    ld sp,hl
lab442C ret nz
    nop
    ld bc,lab3EFE
    nop
    rra 
    sbc a,a
    pop af
    nop
    ccf 
    ret po
    ld h,b
    nop
    rst 56
    rra 
    cp (hl)
    nop
    ld bc,lab83FE+1
    ret nz
    nop
    ld a,(hl)
    ret nz
    ret p
    nop
    rrca 
    ret po
    nop
    nop
    ld bc,lab03F8
    nop
    nop
    ld a,(hl)
    ld b,0
    nop
    rrca 
lab4455 sbc a,h
    nop
    nop
    ld bc,lab00F8
    nop
    nop
    ld b,12
    sbc a,b
    ld a,(bc)
    dec b
    ld b,18
    ld (bc),a
    ld d,1
    rla 
    ld bc,lab0111
    inc de
    nop
    inc d
    nop
    inc d
    nop
    ld (de),a
    dec b
    rrca 
    ld a,(bc)
    ld a,(bc)
    djnz lab447C
    nop
    inc e
    ld e,1
lab447C pop af
    ret m
    rra 
lab447F ccf 
    add a,(hl)
    jr nc,lab447F
lab4483 nop
    inc bc
    rst 8
    nop
    rlca 
    call m,lab7EE0
    jr nc,lab448D
lab448D inc bc
    cp 0
    nop
    rra 
    add a,b
    nop
    nop
    ld h,b
    dec c
    and b
    dec d
    rlca 
    ld c,17
    dec bc
    dec d
    dec b
    dec de
    ld (bc),a
    djnz lab44A3
lab44A3 rrca 
    nop
    djnz lab44A7
lab44A7 djnz lab44AB+1
    dec d
    rlca 
lab44AB ld de,lab1107
    rlca 
    ld de,lab0B0A
    nop
    nop
    inc bc
    ld h,b
    nop
    ld bc,labFCFC
    nop
    rrca 
    add a,a
    rst 0
    inc bc
    call m,lab6000
    rra 
    call p,lab3800
    ld a,h
    jr c,lab4500+1
    inc c
    rrca 
    add a,6
    nop
    nop
    cp 0
    nop
    nop
    inc a
    call m,lab0000
    rst 32
    ld e,0
    jr c,lab44F8+1
    ret p
    nop
    sub b
    nop
    rla 
    jr lab4483
    ld a,(de)
    inc bc
    add hl,de
    inc b
    ld (de),a
    inc bc
    djnz lab44F0
    rrca 
    ld b,13
    add hl,bc
    dec bc
lab44F0 dec d
    ld a,(bc)
    inc d
    add hl,bc
lab44F4 ld de,lab1009
    ex af,af''
lab44F8 djnz lab4502
    rrca 
    rlca 
    djnz lab4505
    rrca 
    dec b
lab4500 djnz lab4505
lab4502 ld de,lab1102
lab4505 ld bc,lab0010
    djnz lab450A
lab450A dec c
lab450B nop
    inc bc
    inc b
    dec b
    inc b
    inc b
    inc b
    inc bc
    nop
    nop
    nop
    djnz lab4518
lab4518 nop
    nop
    jr nz,lab451C
lab451C nop
    djnz lab453F
    nop
    nop
    ld h,b
    ld b,b
    nop
    nop
    ret nz
    ld b,(hl)
    nop
    inc bc
    adc a,b
    ret m
    nop
    rrca 
    ld de,lab0080
    ld e,99
    nop
    nop
    ld a,198
    nop
    nop
    dec (hl)
    adc a,h
    nop
    nop
    ld l,l
    inc e
    nop
lab453F nop
    ld a,e
lab4541 jr c,lab4543
lab4543 nop
    rst 24
    ld (hl),b
    nop
    nop
    cp h
    ret po
    nop
    inc bc
lab454C ld a,c
    ret nz
    nop
    rrca 
    rst 16
    nop
    nop
    add hl,de
    cp (hl)
    nop
    nop
    ld sp,lab00EE+2
    nop
    ld b,e
    add a,b
    nop
    nop
    inc bc
    nop
    nop
    nop
    ld (bc),a
    nop
    nop
    nop
    inc b
    nop
    nop
    nop
    sub b
    nop
    dec d
    inc d
    sbc a,b
    djnz lab4575
    rrca 
    inc b
    dec bc
lab4575 ex af,af''
    ld a,(bc)
    dec bc
    add hl,bc
    rrca 
    ex af,af''
    djnz lab4584
    ld de,lab1106
    dec b
    ld de,lab1005
lab4584 dec b
    ld c,5
    inc c
    inc bc
    dec c
    ld (bc),a
lab458B ex af,af''
    ld bc,lab0008
    ex af,af''
    nop
    rlca 
    nop
    ld b,2
    inc b
    ld (bc),a
    inc bc
    nop
    nop
    ld b,b
    nop
    nop
    add a,b
    nop
    inc c
    nop
    nop
    jr lab45B4
    nop
    ld sp,lab0020+2
    ld h,d
    inc c
    nop
    add a,88
    ld bc,labF0C4
    inc bc
    adc a,c
    ret nz
    inc bc
lab45B4 and e
    nop
    ld bc,lab00C6
    inc bc
    adc a,b
    nop
    rrca 
    nop
    nop
    ld e,0
    nop
    inc (hl)
    nop
    nop
    ld b,b
    nop
    nop
    ex af,af''
    nop
    nop
    djnz lab45CD
lab45CD nop
    sub b
    nop
    jr lab45EC
    sbc a,b
    dec d
    inc bc
    inc d
    inc b
    inc de
    dec b
    ld de,lab0F07
    add hl,bc
    ld c,10
    inc c
    inc c
    dec bc
lab45E2 dec c
    add hl,bc
    ex af,af''
    ex af,af''
    ld c,7
    ld c,6
    ld c,6
lab45EC rlca 
    dec b
    rrca 
    inc b
    djnz lab45F4+1
    djnz lab45F7
lab45F4 ld c,2
    inc c
lab45F7 ld bc,lab010B+1
    dec bc
    nop
    dec bc
    nop
    inc b
    nop
    inc bc
    nop
    ld (bc),a
    inc b
    inc b
    inc b
    inc bc
    nop
    nop
    ld (bc),a
    nop
    nop
    ld b,0
    nop
    inc c
    nop
    nop
    jr c,lab4614
lab4614 nop
    cp 0
    ld bc,lab00CF
    rlca 
    nop
    nop
    inc c
    ex af,af''
    nop
    inc a
    djnz lab4623
lab4623 ld l,b
    add a,b
    nop
    pop af
    nop
    ld bc,lab20C0
    ld bc,lab60AF+1
    inc bc
    ld (hl),h
    ret nz
    rlca 
    db 237
    db 0
    dec c
    ret m
    nop
    dec bc
    or b
    nop
    dec e
    ld h,b
    nop
    add hl,sp
    ret nz
    nop
    ld hl,lab0080
    ld b,c
    add a,b
    nop
    add a,e
    nop
    nop
    ld (bc),a
    nop
    nop
    inc b
    nop
    nop
    add a,h
    ld (bc),a
    dec b
    inc c
    inc b
    inc c
    inc c
    ld b,32
    di
    ex af,af''
    nop
    push af
    ld a,(de)
    ret po
    cpl 
    ld (hl),118
    sub l
    and h
    or e
    set 2,e
    jp (hl)
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ret m
    ex de,hl
    ex (sp),hl
    out (175),a
    ld e,a
    nop
    nop
    ret po
    nop
    nop
    ld bc,lab80E0
    nop
    ld bc,lab209A
    nop
    inc bc
    ld (hl),l
    inc d
    nop
    rlca 
    ld l,d
    xor d
    nop
    rrca 
    db 253
    db 21
    nop
    rrca 
    rst 56
    xor d
    and b
    dec bc
    rst 56
    sub l
    ld d,b
    dec h
    call c,labA8AA
    ld d,e
    ld h,(hl)
    dec d
    ld d,h
    xor b
    dec a
    jp pe,lab5FAA
    jp lab54FB+2
    xor a
    rst 56
    rst 56
    xor d
    rst 24
    rst 56
    rst 56
    push de
    rst 56
    rst 56
    rst 56
    jp pe,labFFFE+1
    rst 56
    db 253
    db 127
    rst 56
    rst 32
    rst 56
    sbc a,a
    rst 56
    add a,e
    rst 56
    rrca 
    cp 31
    rst 56
    inc c
    rst 56
    rst 56
    call pe,lab2E08
    ld a,l
    jr nc,lab46CD
lab46CD ld sp,lab20C5+1
    nop
    ld h,c
    add a,h
    nop
    nop
    inc bc
    nop
    nop
    add a,h
    ld (bc),a
    ld (bc),a
    inc c
    inc b
    dec c
    inc c
    ld b,24
    di
    ex af,af''
    nop
    push af
    ld a,(de)
    ret c
    inc sp
    ld a,(labA192)
    xor c
    cp b
    cp b
    cp b
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    or c
    xor c
    add a,l
    ld h,l
    nop
    rrca 
    nop
    nop
    inc e
    nop
    jr nz,lab4722
    adc a,d
    add a,b
    add hl,sp
    ld d,l
    ld d,b
    ld (hl),170
    xor b
    ld a,l
    ld h,l
    ld d,h
    ld a,(hl)
    jp pe,lab3FA8
    push hl
    ld d,h
    dec a
    jp pe,lab56A9+1
    ld d,l
    ld d,h
    add a,e
    cp d
    xor d
lab4722 ld e,h
    ld a,a
lab4724 ld d,h
    cp a
    rst 56
    xor d
    rst 56
    rst 56
    push af
    rst 56
    rst 56
    ei
    rst 56
    rst 56
    db 253
    db 255
    ld sp,hl
    rst 56
    ld a,a
    ret po
    cp 191
    rst 0
    cp 47
    rst 56
    call po,labE622
    ld e,b
    inc bc
    add hl,sp
    sub b
    ld (bc),a
    ld sp,lab0000
    jr nz,lab4749
lab4749 sub b
    nop
    call m,labCD0B
    jr nz,lab4790
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    add hl,sp
    ld hl,(lab0F2A)
    ld h,b
    nop
    ld (hl),0
    ld a,(de)
    nop
    ld c,d
    nop
    ld l,(hl)
    nop
    ld a,0
    inc e
    nop
    inc e
    nop
    inc e
lab476A nop
    sub b
    ei
    ld b,11
    sub b
    nop
    inc bc
    nop
    inc bc
    nop
    dec b
    nop
    ld b,0
    dec bc
    ld bc,lab020F
    ld c,8
    ex af,af''
    ex af,af''
    ex af,af''
    ld a,(bc)
    ld b,12
    inc b
    ld b,b
    nop
    ld b,b
    nop
    ld (hl),b
    nop
    jr z,lab478E
lab478E dec d
    ret nz
lab4790 dec bc
    di
    nop
    ld l,h
    nop
    add hl,de
    nop
    ld b,144
    nop
    db 253
    db 15
    dec c
    nop
    ret nz
    ld bc,lab0380
    jr lab476A
    ld (hl),b
    ld a,a
    ret nz
    ld e,0
    inc e
    nop
    inc e
    nop
    inc e
    nop
    inc a
    nop
    inc a
    nop
    ld a,h
    nop
    ld a,h
    nop
    sub b
    ld (lab0DF3+1),hl
    ret 
    ld a,(bc)
    add hl,de
    jr nc,lab47F1
    dec hl
    dec hl
    ld sp,lab5050
    ld c,c
    ld b,c
    ld a,(lab2000)
    nop
lab47CB ld (hl),b
    nop
    inc e
    nop
    ld (bc),a
    nop
    ld c,0
    inc e
    add a,b
    ld a,b
    add a,b
    ld (hl),c
    add a,b
    dec a
    nop
    rra 
    nop
    ld c,0
    sub b
lab47E0 jr nz,lab47CB
    rlca 
    rlc b
    ld (hl),75
    ld e,c
    ld (hl),b
    ld l,b
lab47EA jr nc,lab47EC
lab47EC ret nz
    ld bc,lab0FE0
    ret po
lab47F1 ccf 
    ret nz
    ld a,b
    nop
    sub b
    jr nz,lab47E0+1
    ld b,203
    jr z,lab485B+1
    ld h,b
    ld e,c
    ld d,d
    dec (hl)
    ld (hl),b
    ret nz
    ccf 
    ret po
    rra 
    ret po
    inc bc
    ret nz
    sub b
    ld (lab08EB),hl
    jp z,lab1810
    jr z,lab4861
    ld c,c
    ld c,c
    ld b,d
    inc l
    ld b,b
    nop
    ld h,b
    nop
    dec sp
    nop
    ccf 
    add a,b
    rra 
    add a,b
    rlca 
    nop
    sub b
    inc h
    ex de,hl
    ex af,af''
    ret z
    nop
lab4827 jr lab4849
    ld b,b
    ld b,b
    ld b,b
lab482C add hl,sp
    ld hl,(labC080)
    ld (hl),h
    ld a,(hl)
    ld a,28
    sub b
    jr lab4827+1
    ld de,lab08C7+1
    djnz lab4854
    jr nz,lab4867
    jr c,lab487F+1
    ld b,b
    ld b,b
    add hl,sp
    jr c,lab487D
    jr c,lab487F
    jr c,lab487A
lab4849 ld (labC080),hl
    ld h,b
    jr nc,lab48C3
    db 237
    db 235
    ld a,d
    ld a,60
lab4854 cp h
    ret m
    ld a,h
    inc a
    jr lab47EA
    ld (bc),a
lab485B cp 12
    rr a
    dec (hl)
    ld b,e
lab4861 ld e,b
    ld h,b
    ld h,b
    ld h,b
    ld d,c
    dec sp
lab4867 dec sp
    inc l
    dec e
    nop
    add a,b
    ld (bc),a
    ld b,b
    add hl,bc
    nop
    ld (lab5100),hl
    jr nz,lab489F
    add a,b
    inc b
    nop
    ex af,af''
    add a,b
lab487A dec b
    nop
    ld (bc),a
lab487D nop
    sub b
lab487F cp 0
    ld de,lab5CD0
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld a,c
    ld (hl),d
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld a,b
    ld c,b
    ld b,c
    inc b
    inc d
    ld d,b
    add a,b
    xor b
    ld hl,lab1054
    ld hl,(lab1429)
lab489F djnz lab48AB
    jr z,lab48A7
    ld d,d
    ld b,d
    add a,b
    and c
lab48A7 inc d
    ld d,c
    jr z,lab482C
lab48AB ld d,d
    ld d,d
    add a,h
    add hl,hl
    nop
    inc d
    nop
    sub b
    jp m,lab1A02
    ret po
    ld d,a
    or a
    cp a
    rst 0
    sub 221
    db 221
    db 221
    sub 228
    ld sp,hl
    ld sp,hl
lab48C3 ld sp,hl
    ret p
    ret p
    ret c
    ret z
    ret nc
    ret nc
    ret nc
    ret nc
    ret 
    pop bc
    cp c
    xor d
    dec a
    nop
    dec b
    nop
    nop
    nop
    ex af,af''
    jr nz,lab4929
    nop
    ld d,b
    ld (bc),a
    adc a,b
    nop
    xor d
    add a,b
    add a,b
    ld bc,lab4155
    ld b,d
    ld (bc),a
    xor d
    and b
    and c
    ld bc,lab4155
    ld d,b
    nop
    xor d
    and b
    and c
    nop
    ld d,l
    ld b,c
    ld d,b
    dec b
    ld a,(bc)
    and d
    and b
    jr z,lab4900
    ld b,l
    ld b,d
    inc h
    ld (bc),a
    xor d
lab4900 add a,b
    ld d,h
    inc b
    ld d,l
    ex af,af''
    ld hl,(lab2A02)
    add a,b
    ld d,l
    dec b
    dec d
    nop
    xor d
    add a,d
    ld a,(bc)
    nop
    ld b,l
    ld b,l
    dec d
    nop
    and d
    adc a,d
    ex af,af''
    add a,b
    ld d,c
    dec b
    inc d
    nop
    ld (lab2888+2),hl
    add a,b
    dec d
    inc d
    ld d,h
    nop
lab4925 ld hl,(lab2AA8)
    nop
lab4929 dec d
    ld d,b
    inc d
    nop
    ld (bc),a
    and b
    nop
    nop
    sub b
    jp m,lab1B01+1
    ret po
    ld a,a
    sub a
    sbc a,a
    sbc a,a
    jp nz,labD0C9
    ret c
    ret p
    ret p
    ret m
    ret m
    ret m
    ld sp,hl
    jp p,labE4EB
    rst 0
    cp a
    or a
    sbc a,a
    ld l,a
    ld h,a
lab494D ld e,a
    ld c,a
    ld c,a
    ld b,a
    nop
    nop
    xor b
    nop
    nop
    inc b
    ld bc,lab0000
    dec b
    ld b,b
    add a,b
    nop
    ld a,(bc)
    and b
    nop
    dec b
    ld d,l
    ld d,b
    add a,b
    jr nz,lab4969
    and c
    nop
lab4969 ld d,c
    ld bc,lab0042
    xor d
    add a,b
    and l
    ld b,b
    ld b,l
    ld d,b
    ld b,d
    ex af,af''
    add a,d
    xor b
    inc b
    nop
    ld d,c
    ld d,c
    ld a,(bc)
lab497C add a,d
    jr z,lab4925+2
    dec d
    ld b,c
    ld de,lab2A54
    xor b
    ex af,af''
    xor c
    dec d
    ld d,c
    dec b
    ld d,d
    ld hl,(lab009F+1)
    and l
    dec d
    ld d,b
    nop
    djnz lab49BE
    xor b
    nop
lab4996 ld a,(bc)
    sub l
    ld d,b
    nop
    djnz lab49E6
    add a,b
    nop
    jr z,lab49A0
lab49A0 nop
    nop
    ld d,h
    ld b,b
    nop
    nop
    xor b
    add a,b
    nop
    nop
    ld d,h
    nop
    nop
    nop
    ld hl,(lab0000)
    nop
    inc d
    nop
    nop
    sub b
    jp m,lab14FF+1
    ret c
    dec sp
    ld e,d
    cp c
    ret nz
lab49BE ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    cp c
    add a,(hl)
    add a,a
    sbc a,l
    and h
    or d
    or d
    or d
    xor d
    and d
    adc a,e
    ld a,(bc)
    add a,b
    nop
    djnz lab49E4
    djnz lab4A00
    ld bc,lab4541+1
    djnz lab497C
    and d
    adc a,c
    ld d,b
    ld d,c
    ld b,d
    xor c
    and d
    adc a,c
    ld d,h
lab49E4 ld d,l
    ld b,b
lab49E6 xor c
    ld hl,(lab529F+1)
    ld bc,lab2840
    nop
    nop
    nop
    nop
    nop
    jr nz,lab49F4
lab49F4 nop
    ld b,h
    ld (bc),a
    ld b,b
    add a,d
    inc b
    ld hl,lab1041
    add a,d
    and c
    ex af,af''
lab4A00 ld bc,lab1443+1
    add a,b
    xor b
    ld a,(bc)
    nop
    ld d,b
    sub b
    cp 254
lab4A0B inc de
    ret c
    ld d,e
    ld d,e
    ld d,e
    and d
    xor d
    or d
    or d
    or d
    sbc a,l
    ret nz
    cp b
    or b
    add a,b
    add a,b
    add a,b
    ld c,a
    ld b,a
    ccf 
    ccf 
lab4A20 ld a,(bc)
    ld b,b
    nop
    inc b
    jr nz,lab4A26
lab4A26 ld a,(bc)
    nop
    nop
    dec d
    nop
    jr z,lab4A37
    sub c
    ld b,b
    dec d
    ld (lab02A1+1),hl
    add a,c
    ld d,c
    nop
    nop
lab4A37 xor d
    ld b,b
    nop
    ld d,h
    add a,b
    nop
    jr z,lab4A8F
    nop
    nop
    add a,b
    jr nz,lab4A44
lab4A44 ld b,b
    inc b
    nop
    nop
    ld d,d
    nop
    nop
    xor b
    nop
    nop
    ld d,b
    nop
    nop
    jr z,lab4A53
lab4A53 sub b
    nop
    nop
    rrca 
    sub b
    add hl,bc
    inc bc
    add hl,bc
    ld b,0
    add a,e
    ld b,6
    nop
    add a,h
    dec b
    ld b,0
    add a,h
    dec b
    dec b
    nop
    add a,h
    ld b,3
    ld bc,lab1003
    nop
    dec c
    inc bc
    inc c
    inc b
    inc bc
    add a,e
    ld b,4
    inc bc
    add a,(hl)
    inc bc
    inc b
    inc bc
    add a,(hl)
    inc bc
    inc b
    inc bc
    ld b,3
    dec b
    nop
    jr nz,lab4A87
lab4A87 inc d
    ld b,b
    jr z,lab4A0B
    djnz lab4AAD
    nop
    nop
lab4A8F nop
    nop
    nop
    nop
    nop
    nop
    ld (bc),a
    nop
    dec b
    ex af,af''
    ld (bc),a
    dec b
    nop
    ld a,(bc)
    nop
    ld c,142
    add hl,bc
    inc b
    add hl,bc
    dec b
    dec b
    add a,h
    ld bc,lab0303+2
    add a,l
    ld (bc),a
    inc b
    inc bc
lab4AAD add a,l
    ld (bc),a
    inc b
    inc bc
    add a,l
    ld (bc),a
    inc b
    ld bc,lab0286+1
    inc b
    nop
    adc a,b
    ld bc,lab0005
    ld c,0
    ld c,0
    ld c,1
    dec c
    inc bc
    ld a,(bc)
    dec b
    rlca 
    nop
    jr nc,lab4ACB
lab4ACB jr lab4ACF
    jr lab4AD9
lab4ACF jr lab4ADB
    jr lab4ADD
    jr lab4B07
    jr lab4B51
    jr c,lab4B58
lab4AD9 ret m
    ccf 
lab4ADB ret m
    rrca 
lab4ADD ret p
    inc bc
    ret po
    sub b
lab4AE1 call m,lab09F7+2
lab4AE4 out (48),a
    add a,b
    adc a,b
    adc a,c
    adc a,d
    adc a,e
    add a,h
    ld a,l
    ld e,a
    ld (hl),d
    call z,lab3F00
    ld a,(hl)
    nop
    rra 
    cp a
    nop
    rrca 
    rst 24
    add a,b
    rlca 
    rst 40
    ret nz
    inc bc
    rst 48
    ret po
    nop
lab4B01 ex (sp),hl
    add a,b
    dec c
    jp z,lab5048
lab4B07 ld e,b
    ld d,c
    ld c,d
    ld c,d
    ld c,d
    ld c,d
    ld c,d
    ld c,d
    ld c,d
    ld b,e
    inc a
    ld a,a
    nop
    ccf 
    add a,b
    ld de,lab1B3F+1
    ld b,b
    dec de
    ld b,b
    ld de,lab1B3F+1
    ld b,b
    rra 
    ld b,b
    djnz lab4AE4
    ex af,af''
    ret nz
    rlca 
    ret nz
    sub c
    ld (bc),a
    inc d
    db 237
    db 16
    ld (bc),a
    rla 
    call nc,lab3B24
    ld (hl),e
    adc a,e
    adc a,e
    adc a,e
    sub d
    sbc a,c
    xor b
    xor b
    xor b
    xor b
    xor b
    xor b
    xor b
    and c
    and b
    and b
    sbc a,b
    adc a,c
lab4B44 adc a,d
    sub d
    ld a,(lab0005+1)
    nop
lab4B4A dec c
    add a,(hl)
    nop
lab4B4D ld bc,lab0069
    rrca 
lab4B51 xor (hl)
    and b
    rlca 
    ld d,a
    ret nz
    ld a,(bc)
    xor a
lab4B58 ret nz
    dec d
    ld e,a
    ret po
    ld hl,(labE0BF)
    ld d,l
    ld e,a
    ret p
    ld l,d
    cp a
    ret p
    ld d,l
    ld a,a
    ret p
    ld l,d
    ld a,a
    ret p
    ld e,a
    rst 56
    ret p
    jr nc,lab4BEF
    ret p
    rrca 
    sbc a,a
    ret po
    dec a
    ld h,a
    ret po
    ld l,d
    cp e
    ret nz
    add hl,sp
    dec a
    add a,b
    ld b,95
    nop
    dec c
    rst 56
    add a,b
    rra 
    rlca 
    ret nz
    nop
    jr lab4B4D+2
    dec bc
    ld a,(de)
    add hl,hl
    ld (lab2827+2),hl
    jr z,lab4BB9+1
    add hl,hl
    ld hl,(lab3131)
    ld sp,lab3131
    jr c,lab4BD2
    jr c,lab4BCD
    ld sp,lab3830+1
    jr c,lab4BD8+1
    djnz lab4BDB
    jr lab4BDB+2
    ld (hl),b
    ld (hl),b
    jr c,lab4BE1
    inc e
    inc a
    inc a
    inc a
    inc a
    inc e
    jr lab4C2D
    inc a
    jr lab4BC4
lab4BB4 jr c,lab4BE1+1
    ld h,h
    dec b
    rst 24
lab4BB9 jr nz,lab4BB4
    ld sp,hl
    ld sp,hl
    jr nz,lab4C1F
    nop
    nop
    nop
    rst 56
    rst 56
lab4BC4 rst 56
    cp 96
    nop
    nop
    nop
    add a,d
    ld (bc),a
    dec c
lab4BCD rst 48
    inc b
    ret p
    db 237
    db 26
lab4BD2 ret po
    rst 8
    rst 8
    ret m
    ret m
    ld sp,hl
lab4BD8 jp pe,labD4E3
lab4BDB call nc,labC4CC
    call po,labD6DD
lab4BE1 sub 248
    ret p
    ret pe
    ret po
    ld a,b
    ld l,b
    ld h,b
    ld c,c
    ld a,(lab1B2B)
    nop
    nop
lab4BEF inc bc
    nop
    ld h,b
    nop
    ld bc,lab300C
    nop
    ld bc,lab1C06
    add a,b
    ld bc,lab0F83+1
    add a,b
lab4BFF ld bc,lab070C
    nop
    inc bc
    jr lab4C0D
    add a,b
    ld (bc),a
    ld a,b
    rlca 
    ret po
    dec b
    ret p
lab4C0D inc b
    ret p
    inc bc
    ret po
    ld b,245
    ld b,a
    ret nz
    inc bc
    ld a,d
    xor a
    ret po
    nop
    push af
    rst 56
    di
    nop
    rst 56
lab4C1F rst 56
    rst 48
    ld bc,labFFFE+1
    cp 1
    rst 56
    rst 56
    ret m
    ld b,e
    rst 56
    rst 56
    ret p
lab4C2D rst 32
    rst 56
    rst 56
    ret po
    rst 56
    call m,lab801E+1
    ld a,a
    ret p
    nop
    nop
    ld a,a
    ret po
    nop
    nop
    cpl 
    add a,b
    nop
    nop
    rra 
    nop
    nop
    nop
    ld c,0
    nop
    nop
    ex af,af''
lab4C4A nop
    nop
    nop
lab4C4D add a,d
    ld (bc),a
    dec c
    or 4
lab4C52 ret p
lab4C53 call pe,labE01A
    rst 8
    ld d,a
    ld d,a
    ld d,a
    ret m
    ret m
    ld sp,hl
lab4C5D jp p,labDCEB
    push de
    add a,183
    cp (hl)
    sub 221
    ret m
    ret m
    ret m
    ret m
    ld l,b
    ld h,b
    ld c,c
    ld a,(lab1B2B)
    nop
    inc bc
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    ld b,0
    nop
    ld h,b
    ld b,0
    ld bc,lab0630
    nop
    inc bc
    jr lab4C92
    nop
    ld b,14
    inc c
    nop
    rrca 
    rlca 
    inc e
    nop
    inc a
    inc bc
    ret c
lab4C92 nop
    ld a,h
    ld bc,lab81B8+2
    ret m
    nop
    ld (hl),l
    ld d,l
    ret po
    nop
    jp m,labE0EB
    nop
    rst 56
    rst 56
    ret p
    ld bc,labFFFE+1
    ret p
    ld bc,labFFFE+1
    pop af
    ld b,e
    rst 56
    rst 56
    di
    rst 32
    rst 56
    rst 56
    rst 56
    rst 56
    ret m
    ld a,a
    xor 127
    ret p
lab4CBA rra 
    nop
    ld a,a
    ret po
    nop
    nop
    cpl 
    add a,b
    nop
    nop
    rra 
    nop
    nop
    nop
    ld c,0
    nop
    nop
    ex af,af''
    nop
    nop
    nop
    add a,d
    ld (bc),a
    ld c,247
    inc b
    pop af
    db 237
    db 26
    ret po
    ld h,a
    ld h,a
    ld h,a
    ld h,a
    ld e,a
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    rst 8
    sub 248
    ret m
    ret pe
    ret c
    ld (hl),b
    ld l,b
    ld e,c
    ld b,d
    inc sp
    dec de
    nop
    nop
    ret nz
    nop
    nop
lab4CF8 djnz lab4CBA
    nop
    nop
    ld sp,lab0080
    nop
    ld h,e
    nop
    ld a,(bc)
    nop
    rst 0
    nop
    ld e,0
    add a,0
    inc d
    nop
    ld l,(hl)
    nop
    inc e
    nop
    ld (hl),h
    nop
    inc c
    nop
    ld a,b
    nop
    ld a,(hl)
    nop
    ld a,d
    and c
    cp 0
    dec a
    ld d,l
    ret p
    nop
    ld a,e
    rst 56
    ld sp,hl
    nop
    ld a,a
    rst 56
    ei
    nop
    rst 56
    rst 56
    ei
    nop
    rst 56
    rst 56
    rst 56
    ld bc,labFFFE+1
    cp 65
    rst 56
    rst 56
    ret p
    di
    cp 15
    ret nz
    rst 56
    ret m
    nop
    nop
    ld a,a
    ret p
    nop
    nop
    cpl 
    ret po
    nop
    nop
    rra 
    add a,b
    nop
    nop
    rrca 
    nop
    nop
    nop
    ex af,af''
    nop
    nop
    nop
    add a,d
    ld (bc),a
    dec c
    rst 48
    inc b
    ret p
lab4D59 db 237
    db 26
    rst 24
    rst 8
    rst 8
    rst 8
    and (hl)
    or l
    or l
    or l
    or l
    push de
    db 221
    db 214
    rst 8
    rst 8
    rst 8
    adc a,248
    ret p
    ret pe
    ret po
    ret 
    ld a,c
    ld h,c
    ld c,d
    ld a,(lab1B23)
    nop
    nop
    inc bc
    nop
    nop
    nop
    ld bc,lab0000
    nop
    ld bc,lab017F+1
    nop
    inc c
    add a,b
    inc bc
    jr nc,lab4D90
    ret nz
    ld (bc),a
    ld l,b
    inc bc
    ret nz
    ld (bc),a
    ld b,b
lab4D90 ld bc,lab03C1-1
    ld h,b
    ld bc,lab01BE+2
    or b
    inc bc
    call nz,labC800
    rlca 
    and 0
    ld (hl),l
    ld b,a
    and 0
    ld a,d
    xor a
    or 0
    rst 56
    rst 56
    call m,labFF00
    rst 56
    call m,labFF00+1
    rst 56
    ret m
    ld h,c
    rst 56
    rst 56
    ret p
    ld (hl),e
    rst 56
    rst 56
    ret po
    dec sp
    rst 56
    rst 56
    add a,b
    ccf 
    cp 0
    nop
    cpl 
    ret p
    nop
    nop
    rra 
    ret nz
    nop
    nop
    rra 
    nop
    nop
    nop
    inc c
    nop
    nop
    nop
    ex af,af''
    nop
    nop
    nop
    add a,d
    ld (bc),a
    inc de
    nop
    inc b
    dec b
    nop
    ld a,(de)
    push bc
    jr z,lab4E10+1
lab4DE1 jr nc,lab4E13
lab4DE3 jr nc,lab4E15
    jr nc,lab4E17
    jr nc,lab4E19
    jr nc,lab4E1B
    jr nc,lab4E1D
    jr nc,lab4E1F
    jr nc,lab4E21
    jr nc,lab4E23
    jr nc,lab4E25
    jr nc,lab4E27
    jr nc,lab4E22
    ld (hl),b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld l,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld l,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
lab4E10 jr z,lab4E27
    ret nc
lab4E13 inc (hl)
    dec sp
lab4E15 ld b,e
    ld b,e
lab4E17 ld b,e
    inc a
lab4E19 ld b,e
    ld b,e
lab4E1B dec sp
    dec sp
lab4E1D dec sp
    ld b,c
lab4E1F ld d,b
    ld l,b
lab4E21 ld (hl),b
lab4E22 ld a,b
lab4E23 add a,b
    ld l,e
lab4E25 inc sp
    inc sp
lab4E27 inc h
    inc b
    add a,b
    rrca 
    nop
    rrca 
    ret nz
    rlca 
    ret nz
    rlca 
    ret nz
    rlca 
    ret nz
    rrca 
    add a,b
    rrca 
    add a,b
    rrca 
    add a,b
    rrca 
    nop
    rlca 
    nop
    daa
    nop
    ld a,a
    add a,b
    rst 24
    ret p
    add a,a
lab4E45 ret m
    rrca 
    adc a,h
    dec c
    ld (bc),a
    add hl,bc
    nop
    ld b,0
    ld (de),a
    rst 8
    ld d,h
    ld e,e
    ld e,e
    ld c,e
    ld b,e
    inc a
    dec (hl)
    ld l,54
    ld b,l
    ld e,e
    ld h,d
    ld (hl),c
    ld a,c
    add a,b
    add a,b
    add a,b
    jr lab4E6A
    ret m
    rrca 
    ret po
    rrca 
    add a,b
    rlca 
    ret nz
lab4E6A inc bc
    ret nz
    ld bc,lab01BE+2
    ret nz
    ld bc,lab01BE+2
    ret po
    inc bc
    ret p
    rrca 
    ret m
    rra 
    ret m
    dec (hl)
    call z,labC629
    ld b,a
    add a,d
    ld b,e
    ld bc,labDF0C
    nop
    xor (hl)
    xor (hl)
    xor (hl)
    xor (hl)
    xor (hl)
    xor (hl)
    xor (hl)
    adc a,214
    sub 0
    nop
    jr nc,lab4EAC
    add a,b
    nop
    jr lab4EA2+1
    ret nz
    nop
    jr lab4E9F
    ret nz
    nop
    inc e
    inc b
lab4E9F ret nz
    nop
    inc a
lab4EA2 ld b,192
    nop
    ld a,b
    rlca 
    ret nz
    nop
    ld e,b
    dec b
    ret nz
lab4EAC nop
    ld e,b
    inc bc
    ret nz
    nop
    ld a,b
    inc bc
    call nz,lab77FF+1
    rlca 
    and 22
    rst 8
    nop
    ld hl,(lab6B29+1)
    ld l,e
    ld l,e
    ld h,e
    ld d,e
    ld d,e
    ld b,h
    dec a
    ld b,e
    ld b,e
    ld b,e
    ld b,e
    ld b,e
    dec sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc h
    jr lab4ED2
lab4ED2 inc c
    ld (bc),a
    inc c
    ld b,12
    ld e,12
    inc a
    ld c,112
    rrca 
    ld (hl),b
    rlca 
    ret po
    inc bc
    ret po
    inc bc
    ret nz
    inc bc
    ret nz
    rrca 
    ret nz
    rlca 
    add a,b
    rrca 
    ret nz
    rrca 
    add a,b
    rlca 
    nop
    ld b,0
    rrca 
    nop
    rrca 
    nop
    ld b,0
    ld d,206
    dec h
    dec l
    dec l
    inc (hl)
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld b,h
    ld b,h
    ld e,b
    ld d,b
    ld d,b
    ld e,c
    ld d,d
    ld c,e
    ld b,e
    dec sp
    inc sp
    inc sp
    inc sp
    inc h
    inc bc
    nop
    ld bc,lab0380
    add a,b
    rlca 
    inc b
    ld c,60
    ld c,124
    rlca 
    ld h,b
    rlca 
lab4F1F ret po
    inc bc
    ret nz
    inc bc
    add a,b
    ld h,e
    add a,b
    ccf 
    add a,b
    rra 
    add a,b
    rrca 
    ld h,b
    rrca 
    ret nz
    rrca 
    add a,b
    ld b,0
    rrca 
    nop
    rrca 
    nop
    ld b,0
    ld d,204
    ld h,46
    ld l,67
    ld c,d
    ld c,d
    ld c,d
    ld c,d
    ld b,e
    inc a
    ld b,l
    ld c,h
    ld l,b
    ld l,b
    ld l,b
    ld l,b
    ld c,e
    dec sp
    inc sp
    inc sp
    inc sp
    inc h
    ld bc,lab0080
    ret nz
    nop
    ret nz
    rrca 
    ret nz
    rra 
    ret nz
    dec e
    add a,b
    rrca 
    add a,b
    rlca 
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    sub b
    rlca 
    sub b
    ld a,a
    sub b
    ld a,a
    ret p
    rrca 
    ret po
    rlca 
    add a,b
    ld b,0
    rrca 
    nop
    rrca 
    nop
    ld b,0
    ld d,206
    ld b,a
    ld d,l
    ld d,l
    ld d,l
    ld e,h
    ld e,e
    ld e,e
    ld d,e
    ld c,h
    dec a
    dec (hl)
    ld e,c
    ld h,c
    ld h,c
    ld h,c
    ld c,e
    ld b,e
    dec sp
    inc sp
    inc sp
    inc sp
    inc h
    nop
    inc e
    inc bc
    adc a,h
    ld bc,lab039B+1
    jr lab4F9F
    jr c,lab4FA9
    ld (hl),b
    rlca 
    ld (hl),b
    inc bc
lab4F9F ret po
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    add a,b
    ccf 
    ret po
    ccf 
lab4FA9 or b
    rlca 
    ret po
    rrca 
    ret nz
    rrca 
    add a,b
    ld b,0
    rrca 
    nop
    rrca 
    nop
    ld b,0
    sub b
    ret m
    ld bc,labCE0E
    jr lab4FD7
    jr nz,lab5039
    ld (hl),c
    ld (hl),c
    ld (hl),c
    ld l,d
    ld l,d
    ld h,d
    ld e,e
    ld e,e
    ld c,h
    inc h
    jr nc,lab4FCD
lab4FCD inc l
lab4FCE ld a,h
lab4FCF inc hl
    ld a,h
    jr nz,lab4FCF
    inc hl
    call m,labFC17
lab4FD7 inc e
    cp h
    add hl,sp
    jr nc,lab5025
    ld a,b
    dec b
    ld a,b
    ld b,48
    ld (bc),a
    nop
    sub c
    ld (bc),a
    ld bc,labFCF3
    nop
    dec c
    ret nc
    nop
    dec (hl)
    dec (hl)
    ld c,d
    ld l,c
    ld a,b
    add a,b
    add a,b
    ld c,l
    ld b,l
    ld b,l
    ld h,128
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    rra 
    ret nz
    ccf 
    ret m
    ld h,c
    call m,lab86C1
    inc bc
    jp labC701+2
    ld bc,lab0086
    nop
    sub b
    ei
    ld bc,labCA0E
    nop
    add hl,hl
    ld d,c
    ld c,d
    ld b,e
    ld c,d
    ld c,c
    ld d,b
    ld d,b
    ld d,b
    inc (hl)
    inc (hl)
    dec h
    add a,b
    jr nc,lab5023
lab5023 dec de
    ret nz
lab5025 rrca 
    ret nz
    rlca 
    ret nz
    rrca 
    add a,b
    rra 
    add a,b
    inc sp
    add a,b
    ld h,e
    nop
    ld b,a
    add a,b
    rlca 
    add a,b
    inc bc
    nop
    nop
    nop
lab5039 sub b
lab503A ret m
    ld bc,labCE0F
    ld hl,lab7131
    ld (hl),c
    ld (hl),c
    ld (hl),c
    ld (hl),c
    ld (hl),c
lab5046 ld a,b
    ld (hl),b
lab5048 ld (hl),b
    ld d,h
    ld c,h
    dec e
    add a,b
    ld b,b
    nop
    ld b,b
lab5050 ld a,h
lab5051 jr nz,lab50CF
    jr nz,lab5051
    inc hl
    call m,labFC17
    inc e
    inc a
    jr lab508D
    ex af,af''
    ld a,b
    ex af,af''
    ld a,b
    inc b
    jr nc,lab5068
    nop
    ld (bc),a
    nop
    add a,c
lab5068 ld (bc),a
    inc b
    ld sp,hl
    add hl,bc
    bit 4,b
    ld h,b
    ld h,b
    ld e,c
    ld e,c
    ld b,c
    ld c,c
    ld c,c
    nop
    ld (hl),e
    jr nz,lab50AC
    ret po
    inc sp
    ret po
    dec sp
    nop
    rra 
    nop
    rrca 
    nop
    rlca 
    add a,b
    add a,c
    ld (bc),a
    ld bc,lab0DF3+2
    ret z
    inc h
    ld b,b
    ld b,b
lab508D ld b,b
    ld b,b
    ld b,b
    ld b,b
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    nop
    rlca 
    ex (sp),hl
    ld h,e
    ld h,e
    ld (hl),a
    ld (hl),54
    ld a,62
    inc a
    ld e,144
    inc bc
    jp p,labC808
    ld d,29
    dec e
    ld b,b
    ld b,b
lab50AC ld b,b
    jr c,lab50D8
    ld bc,lab2E03
    ld a,(hl)
    ld a,h
    jr c,lab5046
    inc bc
    ret p
    ld b,203
    nop
    ld h,b
    ld h,b
    ld e,b
    ld d,b
    ld sp,labE030
    ld a,a
    ret nz
    ld a,a
    add a,b
    inc a
    nop
    ex af,af''
    call lab68FE+2
    ld l,c
    ld l,c
    ld l,c
lab50CF ld h,d
    scf
    nop
    dec de
    ret c
    scf
    ret c
    scf
    ret c
lab50D8 dec de
    sbc a,b
    inc c
    jr nc,lab50DD
lab50DD ld h,b
    add a,c
    ld (bc),a
lab50E0 call m,lab12EE+2
    ret z
    inc hl
    ld b,b
    ld b,b
    ld b,b
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    add hl,sp
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    nop
    inc c
    ld h,(hl)
    ld (hl),54
    ld (hl),54
    ld (hl),62
    ld a,60
lab5100 inc e
    dec e
    dec a
    ld a,(hl)
    cp 251
    ex af,af''
    adc a,0
    ld l,c
    ld l,c
    ld a,b
    ld a,b
    ld a,b
    nop
    nop
    inc de
    ret nc
    scf
    ret c
    daa
    ret z
    ld h,e
    adc a,h
    ld b,b
    inc b
    nop
    inc b
    sub b
    nop
    inc bc
    ld b,200
    dec e
    dec hl
    add hl,sp
    jr c,lab514E
    jr lab512B
    inc c
    jr nc,lab516B
lab512B sub b
    nop
    ld b,9
    adc a,a
    inc c
    inc b
    ld a,(bc)
    ld b,8
    ex af,af''
    ld b,8
    inc b
    ex af,af''
    ld (bc),a
    ex af,af''
    nop
    ex af,af''
    nop
    ld b,0
    inc b
    nop
    ld b,0
    jr lab5147
lab5147 ld h,b
    ld bc,lab0680
    nop
    jr lab514E
lab514E ld h,b
    nop
    inc bc
    ret z
    ld b,b
    ld b,b
    ld b,b
    rst 56
    inc bc
    ret nc
    add a,b
    add a,b
    add a,b
    rst 56
    rst 56
    ld b,200
    jr lab5188+1
    jr c,lab519C
lab5163 dec hl
    dec e
    ret nz
    jr nc,lab5174
    ld (bc),a
    add hl,bc
    adc a,a
lab516B nop
    inc b
    nop
    ld b,0
    ex af,af''
    ld (bc),a
    ex af,af''
    inc b
lab5174 ex af,af''
    ld b,8
    ex af,af''
    ex af,af''
    ld a,(bc)
    ld b,12
    inc b
    ld h,b
    nop
    jr lab5181
lab5181 ld b,0
    ld bc,lab0080
    ld h,b
    nop
lab5188 jr lab518A
lab518A ld b,4
    jp lab2020
    jr nz,lab51B1
    ld h,b
    ld h,b
    djnz lab5163
    inc e
    ld h,b
    ld a,b
    ld a,b
    ld (hl),c
    ld e,e
    inc a
lab519C inc a
    inc a
    inc a
    dec (hl)
    dec (hl)
    dec (hl)
    dec l
    ld h,38
    inc b
    nop
    ld a,a
    ret po
    ccf 
    call m,labF80F
    rlca 
    ret nz
    rlca 
    ret nz
lab51B1 rlca 
    ret nz
    rlca 
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    add a,b
    ld bc,lab017F+1
    add a,b
    dec c
    adc a,28
    ld h,b
    ld a,b
    ld a,b
    ld (hl),c
    ld e,e
    inc a
    inc a
    inc a
    inc (hl)
    inc (hl)
    inc l
    dec e
    inc b
    nop
    ld a,a
    ret po
    ccf 
    call m,labF80F
    rlca 
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    rlca 
    add a,b
    rlca 
    add a,b
    rlca 
    nop
    ld (bc),a
    nop
    add hl,bc
    adc a,42
    ld (lab3B3A),a
    ld a,b
    ld a,b
    ld a,b
    ld l,c
    ld c,e
    inc e
    nop
    ld c,0
    rrca 
    nop
    rlca 
    add a,b
    ld a,a
    call m,labF83F
    rrca 
    ret po
    inc de
    adc a,39
    daa
    cpl 
    ld (hl),96
    ld a,b
    ld a,b
    ld (hl),c
    ld e,e
    inc a
    inc a
    inc a
    inc a
    dec (hl)
    dec (hl)
    dec (hl)
    ld l,46
    daa
    nop
    ret nz
    nop
    ret nz
    nop
    ret po
    ld bc,lab7FDE+2
    ret po
    ccf 
    call m,labF80F
    rlca 
    ret nz
    rlca 
    ret nz
    rlca 
    ret nz
    rlca 
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    inc bc
    ret nz
    ld bc,lab01BE+2
    ret nz
    nop
    ret nz
    ld (de),a
    adc a,71
    ld b,a
    ld b,a
    ld b,a
    ld (hl),b
    ld (hl),b
    ld h,b
    ld h,b
    ld c,e
    ld b,e
    ld d,d
    ld d,d
    ld d,d
    ld d,d
lab5246 ld l,46
    rra 
    rra 
    nop
    inc c
    nop
    inc e
    nop
    jr c,lab5271
    ret m
    ld a,a
    ret po
    ld a,a
    ret po
    rrca 
    ret po
    rrca 
    ret nz
    rrca 
    ret nz
    rrca 
    ret nz
    dec de
    ret po
    add hl,de
    ret po
    ld bc,lab01BE+2
    ret nz
    nop
    add a,b
    nop
    add a,b
    dec d
    rst 0
    inc h
    inc h
    dec hl
    dec hl
    dec hl
lab5271 ld (lab3232),a
    ld (lab4039),a
    ld b,b
    ld b,b
    ld b,b
    jr c,lab52B4
    add hl,hl
    add hl,hl
    add hl,hl
    ld a,(de)
    ld a,(de)
    ld b,6
    ld c,14
    ld c,28
    inc e
    ld e,30
    ld a,126
    cp 252
    ld a,h
    jr c,lab52C9
    jr c,lab52A3
    djnz lab52A9+1
    push bc
    ld a,(de)
    ld a,(de)
    ld hl,lab2120+1
    ld hl,lab2921
    add hl,hl
lab529F jr nc,lab52D9
    jr c,lab52DB
lab52A3 jr c,lab52DD
    jr c,lab52D8
    add hl,hl
    add hl,hl
lab52A9 ld hl,lab1019
    djnz lab52DE
    jr nc,lab52DE+2
    jr nc,lab52E2
    jr c,lab52EC
lab52B4 ld a,b
    ld a,h
    ld a,h
    ld e,h
    ld e,h
    inc e
    jr lab52F4
    jr nc,lab52DE
    dec bc
    adc a,71
    ld h,e
    ld h,e
    ld h,d
    ld c,d
    ld c,d
    ld c,c
    ld d,b
    ld c,b
lab52C9 jr c,lab52F3
    nop
    call m,labF809
    rrca 
    ret nz
    rra 
    ret nz
    rrca 
    add a,b
    rra 
    add a,b
    ccf 
lab52D8 nop
lab52D9 ld a,h
    nop
lab52DB ld (hl),b
    nop
lab52DD inc c
lab52DE call z,lab3020
    ld b,b
lab52E2 ld d,b
    ld d,c
    ld c,d
    ld h,b
    ld l,b
    ld l,b
    ld h,c
    ld d,e
    dec h
    ld h,b
lab52EC nop
    ld a,b
    nop
    ld a,0
    rra 
    add a,b
lab52F3 rrca 
lab52F4 ret nz
    rrca 
    ret nz
    ld a,a
    ld h,b
    ccf 
    or b
    rrca 
    sub b
    inc bc
    nop
    ld de,lab19CB+2
    ld hl,lab5838
    ld (hl),b
    ld (hl),b
    ld h,d
    ld e,d
    ld b,d
    ld b,d
    ld c,c
    ld d,c
    ld d,c
    ld d,c
    ld d,c
    ld (lab2022),hl
    nop
    jr nc,lab5316
lab5316 ld a,h
    nop
    ld a,a
    ret nz
    rra 
    ret m
    rra 
    ret p
    rra 
    nop
    rra 
    nop
    rra 
    add a,b
    rra 
    add a,b
    dec a
    add a,b
    dec a
    ret nz
    inc a
    ret nz
    jr lab532E
lab532E jr lab5330
lab5330 dec e
    sbc a,e
    ex af,af''
    inc bc
    ex af,af''
    inc b
    ld b,6
    ld bc,lab0183+1
    rlca 
    nop
    ld c,0
    rrca 
    nop
    djnz lab5343
lab5343 ld (de),a
    nop
    ld (de),a
    nop
    ld (de),a
    ld bc,lab0492
    inc bc
    ld bc,lab0219
    ld a,(de)
    inc bc
    add hl,de
    ld (bc),a
    ld a,(de)
    ld (bc),a
lab5355 ld a,(de)
    ld (bc),a
    ld a,(de)
lab5358 inc bc
    jr lab535E+1
    ld d,5
    dec d
lab535E ld b,20
    dec b
    dec d
    inc b
    jr lab5369
    adc a,c
    dec b
    ld a,(bc)
    inc bc
lab5369 adc a,c
    rlca 
    add hl,bc
    inc bc
    adc a,b
    dec bc
    dec b
    inc bc
    add a,a
    inc c
    dec b
    inc bc
    add a,(hl)
    ld c,4
    inc b
    inc bc
    nop
    ld b,b
    nop
    nop
    nop
    ld h,b
    nop
    nop
    ld bc,lab009F+1
    nop
    jr nc,lab5358
    nop
    nop
    ld a,h
    ld e,b
    nop
    nop
    ld a,a
    jr z,lab5391
lab5391 nop
    ld a,c
    xor d
    nop
    nop
    ld (hl),c
    ld sp,hl
    nop
    nop
    inc hl
    db 253
    db 0
    nop
    cpl 
    dec (hl)
    add a,b
    nop
    ld e,124
    ld b,b
    add a,b
    dec c
    and 79
    nop
    ld b,251
    ret c
    ld h,b
    rrca 
    rst 56
    ret c
    ret nz
    rra 
    rst 56
    rst 48
    and b
    rrca 
    ei
    call m,lab073E+2
    rst 48
    db 253
    db 128
    inc bc
    rst 8
    cp 0
    nop
    ccf 
    ld a,a
    add a,b
    nop
    jp m,lab807F
    ld bc,labFFF9
    add a,b
    inc bc
    ret p
    dec e
    add a,b
    rlca 
    ret po
    rrca 
    ret po
    rlca 
    ret nz
    ld bc,lab0EFF+1
    add a,b
    ld bc,lab0F80
    nop
    nop
    ret nz
    inc b
    nop
    nop
    nop
    add hl,de
    sbc a,h
    rlca 
    inc bc
    rlca 
    inc b
    nop
    adc a,h
    inc bc
    inc bc
    nop
    adc a,l
    ld bc,lab0005
    inc d
    nop
    inc d
    nop
    inc d
    nop
    inc d
    nop
    sub h
    ld (bc),a
    inc bc
    ld bc,lab0117+1
    dec de
    ld (bc),a
    ld a,(de)
    inc bc
    add hl,de
    dec b
    ld d,6
    dec d
    rlca 
    inc de
    ex af,af''
    ld (de),a
    add hl,bc
    ld de,lab0F0B
    dec c
    ld c,15
    ld c,18
    dec bc
    inc de
    ld a,(bc)
    ld d,5
    rla 
    inc b
    nop
    add a,b
    nop
    nop
    nop
    ret nz
    nop
    nop
    ld sp,lab805F+1
    nop
    ld a,h
    pop de
    ret nz
    nop
    ld a,a
    ld d,e
    ret po
    nop
    ld a,c
    xor e
    ret po
    nop
    ld (hl),c
    ei
    ret po
    nop
    inc hl
    ei
    ret po
    nop
    cpl 
    scf
    pop hl
    nop
lab5444 ld e,95
    adc a,0
    dec c
    rst 0
    ret c
    ld h,b
    inc bc
    sbc a,e
    out (128),a
    ld bc,labD63E+1
    ld b,b
lab5454 nop
    rst 56
    call p,lab0080
    ld a,e
    rst 56
    nop
    nop
    scf
    rst 56
    nop
    nop
    rrca 
    cp a
    add a,b
    nop
    inc bc
    ccf 
    add a,b
    nop
    nop
    rst 56
    add a,b
    nop
    nop
    dec e
    ret nz
    nop
    nop
    rrca 
    or b
    nop
    nop
    ld bc,lab0000
    nop
    nop
    ret nz
    sub b
    ei
    nop
    ld a,(de)
    sbc a,b
    dec bc
    add a,e
    dec b
    inc b
    inc bc
    add a,e
    inc b
    add a,h
    inc bc
    rlca 
    inc bc
    adc a,e
    ld (bc),a
    ex af,af''
    inc bc
    adc a,d
    ld (bc),a
    add hl,bc
    inc b
    adc a,d
    ld bc,lab0407+2
    inc d
    inc b
    inc d
    inc b
    inc d
    inc b
    inc de
    dec b
    inc de
    dec b
    inc de
    ld b,18
    dec b
    ld (de),a
    inc b
    inc de
    inc bc
    inc de
    ld (bc),a
    inc d
    ld bc,lab0016
    rla 
    nop
    rla 
    nop
    adc a,h
    ld (bc),a
    add hl,bc
    nop
    adc a,d
    inc b
    ld a,(bc)
    nop
    adc a,b
    rlca 
    add hl,bc
    nop
    add a,a
    add hl,bc
    ex af,af''
    ld de,lab1107
    rlca 
    ld de,lab0005+1
    ex af,af''
    inc c
    ex af,af''
    djnz lab550D
    dec b
    sub b
    ld a,a
    rlca 
    ret nc
    rst 56
    rlca 
    ret pe
    rst 56
    rlca 
    add hl,de
    cp 6
    dec a
    call m,lab6700+2
    ret m
    inc bc
    rst 8
lab54E3 ret m
    ld bc,labF2BB
    nop
    rst 48
    call p,lab65FE+2
    call po,labFD03
    ret c
    rlca 
    ei
    djnz lab5501+2
    cp 112
    rra 
    db 253
    db 248
    ccf 
    rst 48
lab54FB call m,labE17F
    call m,lab817E+1
lab5501 call m,lab007E
    call p,lab007C
    ld a,(hl)
    nop
    nop
    ld (de),a
    nop
    nop
lab550D ld (de),a
    nop
    nop
    inc h
    rrca 
    ret c
    cpl 
    scf
    ccf 
    ccf 
    ld c,(hl)
    ld d,l
    and h
    xor e
    ret nz
    or b
    xor b
    and b
    sbc a,b
    ld h,(hl)
    ld b,a
    nop
    ret po
lab5524 nop
    nop
    ld (hl),b
    nop
    nop
    jr c,lab552B
lab552B nop
    jr lab552E
lab552E ld bc,lab009C
    inc bc
    call m,lab0702+1
    cp 14
    rrca 
    cp 24
    rst 56
    rst 56
lab553C jr nc,lab553C+1
    rst 56
    ld h,b
    ld a,a
    rst 56
    ret nz
lab5543 ld hl,lab80FE+1
    nop
    ld a,h
    nop
    sub b
    nop
    call m,labD80B
    ld b,a
    ld e,h
    ld l,e
lab5551 or d
    ret nz
    ret nz
    sbc a,b
lab5555 sub b
    sub b
    ld d,a
    ccf 
    nop
    ld a,h
    nop
    rlca 
    ret p
    nop
    rrca 
    cp 28
    rra 
    cp 98
    rst 56
    rst 56
    pop bc
    rst 56
    rst 56
    add a,b
    ld a,a
    rst 56
    add a,b
lab556E djnz lab556E+1
    nop
    nop
    jr c,lab5574
lab5574 sub b
    db 253
    db 255
    ld c,221
    ld a,(de)
    ld (lab503A),hl
    add a,b
    adc a,b
    ret pe
lab5580 jp po,labE2E2
    jp c,labA4BB
    nop
    djnz lab5589
lab5589 nop
    nop
    jr lab558D
lab558D nop
    nop
    rrca 
    nop
    nop
    nop
    ld b,a
    add a,b
    nop
    nop
    ld a,a
    cp 0
    nop
    rra 
    rst 56
    nop
    nop
    inc bc
    rst 56
    ret m
    djnz lab55C3
    rst 56
    rst 56
    ret m
    rra 
    rst 56
    rst 56
lab55AA ret p
lab55AB rrca 
    rst 56
    rst 56
    add a,b
    inc b
    ld bc,lab00FE
    nop
    nop
    jr c,lab55B7
lab55B7 sub b
    call m,lab0BFB+1
    rst 24
    jr z,lab5605+1
    cp b
    ret po
    ld sp,hl
    ex de,hl
    ex de,hl
lab55C3 out (179),a
    ld b,h
    dec e
    ld d,b
    nop
    nop
    nop
    ld a,a
    nop
    nop
    nop
    ccf 
    cp (hl)
    inc a
    nop
    rlca 
    rst 56
lab55D5 rst 56
    ret po
    inc bc
    rst 56
    rst 56
    cp 15
    rst 56
    rst 56
    ret p
    rrca 
    rst 56
    rst 56
    nop
    rlca 
    ret po
    inc e
    nop
    ld (bc),a
    nop
    nop
    nop
    sub b
    rst 56
    cp 14
    and b
    ld d,3
    dec b
    inc bc
    nop
lab55F5 ex af,af''
    nop
    adc a,c
    ex af,af''
    inc c
    nop
    adc a,l
    inc bc
    djnz lab55FF
lab55FF jr nz,lab5602
    rra 
lab5602 ld (bc),a
    ld e,0
lab5605 ld e,0
    dec de
    nop
    rla 
    nop
    ld c,1
    ex af,af''
    ld (bc),a
    inc bc
    nop
    nop
    ld bc,lab01FE+2
    nop
    inc bc
    nop
    ld b,(hl)
    nop
    rrca 
    jr nc,lab5682+2
    nop
    inc a
    ld h,b
    dec sp
    ret p
    ld a,a
    pop bc
    rra 
    rst 56
    rst 56
    add a,(hl)
    rlca 
    rst 56
    rst 56
    ld a,b
    rrca 
    rst 56
    rst 56
    ret nz
    ld a,a
    rst 56
lab5632 call m,lab7EFF+1
    ret m
    nop
    nop
    ccf 
    nop
    nop
    nop
    djnz lab563E
lab563E nop
    nop
    sub b
    ei
    nop
    ld (de),a
    sbc a,l
    inc d
    inc bc
    ld (de),a
    ex af,af''
    djnz lab5659
    rrca 
    rrca 
    ld c,16
    ld c,15
    ld (bc),a
    add a,e
    rlca 
    rrca 
    ld (bc),a
    add a,h
    ld (bc),a
    ld (de),a
lab5659 nop
    add hl,de
    nop
    rla 
    nop
    dec d
    ld bc,lab0211+1
    rrca 
    inc b
    dec bc
    inc b
    add hl,bc
    inc b
    rlca 
    dec b
    dec b
    ld b,3
    nop
    nop
    inc b
    nop
    nop
    nop
    jr lab55F5
    nop
    nop
    ld (hl),a
    jr lab567A
lab567A nop
    xor 112
    nop
    ld bc,labC0FC
    nop
lab5682 ld bc,lab80FD
    djnz lab568E
    rst 56
    nop
    jr lab570A
    call m,lab6700
lab568E rst 56
    ret p
    nop
    ccf 
    rst 56
    ret nz
    nop
    rra 
    rst 56
    nop
    nop
    ld bc,lab00FC
    nop
    rlca 
    ret p
    nop
    nop
    rlca 
    ret nz
    nop
    nop
    inc bc
    add a,b
    nop
    nop
lab56A9 ld bc,lab0000
    nop
lab56AD dec c
    push de
    ld a,(de)
    jr nc,lab5632
    adc a,b
    xor b
    xor c
lab56B5 sbc a,e
    and d
    and d
    sbc a,d
    sub d
    add a,e
lab56BB nop
    djnz lab56BE
lab56BE nop
    ld e,b
    inc b
    nop
    ld l,h
    ld d,0
    ccf 
    dec de
    nop
    rrca 
    db 237
    db 144
    rlca 
    di
    ret z
    inc bc
    rst 56
    ret c
    rra 
    rst 56
    ret p
    rra 
    rst 56
    ret po
    rrca 
    rst 56
    ret nz
    inc b
    rra 
    add a,b
lab56DD djnz lab56AD
    ld c,l
    ld e,e
    ld h,d
    ld h,c
    ld (hl),b
    ld a,b
    ld a,b
    ld a,b
    ld a,b
    ld l,c
    ld l,d
    ld h,e
    ld d,l
    ld b,a
    ccf 
    daa
    inc bc
    sbc a,b
    ld c,112
    jr lab56B5
    ccf 
    sub b
    ld a,h
    ld e,b
    ld e,a
    ld l,h
    ld l,h
    call m,labF833
    rra 
lab5700 ret m
    rrca 
    ret m
    inc bc
lab5704 call pe,lab03FF+1
    nop
    jr c,lab570A
lab570A ret nz
    rrca 
    adc a,a
    ld bc,lab0103
    add a,l
    dec b
    inc bc
    ld bc,lab0385
    dec b
    ld bc,lab0385
    dec b
    ld bc,lab0385
    rlca 
    ld bc,lab0385
    rlca 
    nop
    add a,a
    ld (bc),a
    rlca 
    nop
    djnz lab572A
lab572A djnz lab572C
lab572C djnz lab572E
lab572E rrca 
    nop
    rrca 
    nop
    ld c,3
    ld a,(bc)
    dec b
    ld b,32
    nop
    jr z,lab5743
    jr z,lab5763+2
    jr z,lab5766+1
    jr z,lab576A+1
    jr c,lab576C+1
lab5743 ld e,h
    ld a,(lab7AFE)
    rst 56
    call m,labFCFF
    ld a,a
    ret m
    rrca 
    ret p
    inc bc
    ret nz
    ld c,208
    jr nc,lab57B5
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld a,b
    add a,b
    add a,b
    add a,b
    add a,b
lab575F add a,b
    nop
    ret z
    nop
lab5763 call z,lab661F+1
lab5766 ld sp,lab737E
    ld a,a
lab576A xor 127
lab576C call m,labF0FF
    rst 56
    ret m
    cp a
    rst 56
    adc a,a
    rst 56
    ld h,b
    ld a,(hl)
    djnz lab577B+2
    dec de
    ret z
lab577B ld (lab3932),a
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld sp,lab1220+2
    ld (de),a
    inc h
    ld a,(hl)
    ld a,(hl)
    rst 32
    in a,(219)
    ld h,(hl)
    cp l
    ld d,d
    xor l
    inc (hl)
    xor l
    inc (hl)
    xor l
    inc (hl)
    xor l
    jr lab5810
    ld b,d
    ld e,d
    ld e,d
    inc h
    jr lab57D4
    ret nc
    jr nz,lab57F2+1
    ld d,b
    ld c,d
lab57B5 ld l,39
    daa
    daa
    daa
    daa
    daa
    ld b,a
    ld b,a
    ld c,(hl)
    ld c,l
    ld d,h
    ld c,h
    ld d,e
    ld c,e
    dec sp
    dec hl
    dec de
    dec hl
    dec sp
    ld c,e
    ld d,e
    ld d,h
    ld e,h
    ld d,l
    ld c,(hl)
    ld c,(hl)
    ld c,(hl)
    ld h,45
    dec h
lab57D4 dec e
    ld h,b
    nop
    ld e,0
    ld bc,lab0080
    ld b,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    ld b,h
    nop
    ld b,h
    nop
    adc a,b
    ld bc,lab0207+1
lab57F2 djnz lab57F7+1
    djnz lab57FE
    ld h,b
lab57F7 ld de,lab0680
    nop
    jr lab57FD
lab57FD nop
lab57FE nop
    jr lab5801
lab5801 ld b,0
    ld de,lab087E+2
    ld h,b
    inc b
    djnz lab580B+1
    ex af,af''
lab580B ld bc,lab0003+1
    add a,h
    nop
lab5810 add a,h
    nop
    add a,h
    nop
    add a,b
    ld bc,lab01FE+2
    nop
    sub b
    nop
    call m,labD020
    ld hl,(lab4040)
    dec h
    dec h
    ld h,38
    daa
    daa
    ld b,a
    ld b,a
    ld b,a
    ld c,(hl)
    ld c,l
    ld e,e
    ld d,e
    ld d,e
    ld c,e
    dec hl
    inc sp
    ld c,e
    ld d,e
    ld e,e
    inc e
    inc h
    inc l
lab5838 dec h
    ld e,30
    inc l
    inc l
    inc h
    inc e
    nop
    jp po,lab01FE+2
    nop
    ld bc,lab0100
    nop
lab5848 nop
    add a,b
    nop
    add a,b
    nop
    ld b,b
    nop
    ld b,b
    nop
    inc h
    nop
    inc h
    nop
    ld c,b
    ld bc,lab0688
    djnz lab5873
    djnz lab585E
    ret po
lab585E ld e,0
    nop
    nop
    jr lab5864
lab5864 rlca 
    nop
    djnz lab5848
    ex af,af''
    djnz lab586F
    ex af,af''
    inc b
    inc b
    ld (bc),a
lab586F ld (bc),a
    ld bc,lab0101
lab5873 nop
    ld bc,lab0100
    nop
    ld b,0
    rrca 
    ret po
    nop
    rst 8
    db 221
    db 221
    db 221
    db 248
    ret m
    ret pe
    pop de
    ret 
    or c
    xor c
    ld e,e
    ccf 
    scf
    nop
    nop
    ld bc,lab0008
    nop
    rlca 
    ld a,c
    ld (bc),a
    ld c,a
    ld a,h
    jp lab1B01
    rst 40
    add a,(hl)
    ld b,b
    and (hl)
    di
    inc e
    ld h,b
    ld a,a
    ld a,(hl)
    ld (hl),b
    jr nc,lab5924
    ld l,(hl)
    ret nz
    inc e
    sbc a,247
    add a,b
    daa
    adc a,(hl)
    ld a,h
    nop
    jr c,lab58BC+1
    jr c,lab58B3
lab58B3 rrca 
    adc a,b
    nop
lab58B6 nop
    nop
    ret m
lab58B9 nop
    nop
    nop
lab58BC jr nc,lab58BE
lab58BE nop
    sub b
    nop
    rst 56
    dec c
    sbc a,0
    sub (hl)
    sub (hl)
    pop af
    pop af
    pop af
    jp (hl)
    ret p
    ret pe
    ret pe
    jp nc,lab25BB
    nop
    nop
    ld b,0
    ld bc,lab7C10-1
    nop
    jr nz,lab58B6
    call pe,lab2010
    ld h,242
    inc h
    jr nc,lab5962
    ld a,h
    jr z,lab58F6
    ld a,a
    ld l,a
    jr z,lab5902
    sbc a,246
    ret nc
    ld h,h
    sbc a,(hl)
    ld a,h
    djnz lab5904+1
    inc l
    jr c,lab5955
    inc c
lab58F6 ret nz
    add hl,bc
    add a,b
    inc bc
    nop
    ld b,0
    ld c,221
    nop
    or a
    or a
lab5902 out (211),a
lab5904 call nc,labF0F0
    ret pe
    exx
    exx
    jp z,lab3CBB
    nop
    nop
    djnz lab5930+1
    nop
    add a,b
    ex af,af''
    djnz lab591E
    ld b,b
    ex af,af''
    djnz lab591E
    daa
    ld a,h
    jr nz,lab591F+1
lab591E dec sp
lab591F and 32
    ld b,c
    ld d,250
lab5924 ret z
    ld h,b
    cp a
    ld a,a
    djnz lab595A
    ld a,a
    ld l,(hl)
    jr nz,lab595A
    sbc a,246
lab5930 jr nz,lab5949
    sbc a,(hl)
    ld a,h
    ld b,b
    ex af,af''
    inc l
    jr c,lab58B9
    rlca 
    ret nz
    rlca 
    nop
    dec bc
    db 221
    db 240
    ret p
    ret p
    pop hl
    jp nc,labB4C3
    and l
    add a,a
    ld (hl),a
lab5949 ld h,a
    ld a,h
lab594B inc e
    ld (hl),b
    ret m
    ld a,15
    pop hl
    ret p
    dec de
    or c
    dec de
lab5955 ret po
    dec c
    jp labC08F
lab595A rlca 
    call p,lab805F
    inc bc
    rst 56
    rst 56
    nop
lab5962 nop
    rst 56
    call m,lab0000
    ccf 
    ret p
    nop
    nop
    rlca 
    ret nz
    nop
    ld a,(bc)
    db 221
    db 240
    ret p
    ret p
    pop hl
    res 7,h
    and l
    adc a,a
    add a,a
    ld h,a
    ld a,b
    rra 
    ret nz
    ret m
    ld a,10
    ld h,l
    ret p
    rrca 
    or d
    ld d,e
    ret po
    rlca 
    call po,labC0CF
    inc bc
    rst 56
    rst 56
    nop
    nop
    ld a,(iy+0)
    nop
    ccf 
    call m,lab0000
    rlca 
    ret nz
    nop
    dec bc
    call c,labE8E8
    ret pe
    exx
    jp nc,labB4C3
    and l
    add a,a
    ld (hl),a
    ld e,a
    ld a,h
    jr c,lab59C1+1
    ret p
    ld a,7
    pop hl
    and b
    rra 
    sbc a,c
    ld d,e
    ld h,b
    rrca 
    jp po,labC04F
    rlca 
    jp m,lab803F
    inc bc
    cp 255
    nop
    nop
    rst 56
lab59C1 call m,lab0000
    ccf 
    ret p
    nop
    nop
    rlca 
    add a,b
    nop
    dec bc
    push de
    ld a,b
    adc a,b
    and b
    and c
    and d
    sbc a,e
    sub h
    adc a,l
    ld (hl),a
    ld l,a
    ld h,a
    ld a,h
    inc e
    nop
    ld a,15
    nop
    dec de
    or c
    ret po
    dec c
    jp lab078F+1
    call p,lab0357+1
    rst 56
    ret m
    nop
    rst 56
    ret p
    nop
    ccf 
    ret po
    nop
    rlca 
    ret nz
    sub c
    ld (bc),a
    ret m
    di
    rst 48
    nop
    dec d
    ret c
    nop
    ld l,(hl)
    sub l
    and h
    xor e
    or d
    cp c
    ret nz
    cp b
    or b
    and b
    sbc a,b
    sub b
    add a,b
    ld a,b
    ld (hl),b
    ld e,d
    ld c,d
    ld c,d
    inc sp
    dec e
    nop
    adc a,a
    add a,b
    ld bc,lab408F
    inc bc
    ld e,a
    xor h
    ld b,158
    out (13),a
    ld a,a
    dec h
    ld a,(de)
    cp (hl)
    jp z,lab7F34+1
    inc (hl)
    ld l,d
    cp 88
    ld d,a
    db 253
    db 160
    ret 
    jp m,labB940
    db 253
    db 128
    and c
    jp p,labC100
    call nc,lab4100
    ret pe
    nop
    dec d
    ret p
    nop
    rra 
    ret nz
    nop
    dec e
    ret nz
    nop
    dec bc
    nop
    nop
    ld (bc),a
    nop
    nop
    sub c
    ld (bc),a
    ei
    ret m
    ei
    nop
    ld a,(bc)
    call lab5B00
    ld e,e
    ld e,e
    ld e,d
    ld h,c
    ld h,b
lab5A58 ld h,b
    ld e,b
    nop
    dec b
    ret m
    ex af,af''
    ret m
    dec c
    ret p
    dec bc
    ret p
    add hl,de
    ret po
    scf
    ret po
    ld h,e
    ret nz
    ld d,a
    add a,b
    sub c
    ld (bc),a
    call pe,labECF0
    nop
    ld (de),a
    sbc a,h
    jr nz,lab5A75
lab5A75 ld (de),a
    dec bc
    ld (de),a
    dec bc
    ld de,lab100B
    inc c
    ld c,14
    ex af,af''
lab5A80 inc de
    ld b,21
    inc b
    ld d,3
    ld d,3
    dec d
    ld (bc),a
    dec d
    ld (bc),a
    inc d
    ld bc,lab0113
    ld de,lab0E00
    nop
    inc c
    jr nz,lab5A97
lab5A97 nop
    nop
    add hl,bc
    ret p
    nop
    nop
    dec d
    ret po
    nop
    nop
    inc de
    ret po
    nop
    nop
    dec sp
    ret po
    nop
    nop
    ld c,a
    ret nz
    nop
    ld bc,labC0AF
    nop
    ld a,(hl)
    rra 
    add a,b
    ld bc,lab3FC8+1
    nop
    rlca 
    ld b,h
    cp 0
    dec c
    daa
    call m,lab0900
    ld a,a
    ret m
    nop
lab5AC3 jr lab5AC3+1
    ret po
    nop
    inc d
    rst 56
    add a,b
    nop
    inc hl
    ret m
    nop
    nop
    daa
    ret po
    nop
    nop
    ld d,a
    ret nz
    nop
    nop
lab5AD7 sub c
    ld (bc),a
    ret m
    ret pe
    ret m
    nop
    ld a,(de)
    ret nc
    nop
    ld e,l
    ld e,l
    ld h,h
    ld l,e
    ld (hl),d
    ld l,d
    ld l,c
    ld l,c
    ld l,b
    ld h,b
    ld e,b
    ld e,b
    ld e,b
    ld d,b
    ld d,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    ld c,b
    nop
    ld bc,lab02DF
    ld e,a
    ld (bc),a
    ld a,5
lab5B00 ld a,12
    ld a,h
    ld a,(de)
    ret m
    ld de,lab3BF8
    ret p
    daa
    ret po
    ld b,e
    ret nz
    ld (hl),a
    ret nz
    ld c,a
    ret nz
    rst 40
    add a,b
    sbc a,a
    add a,b
    rst 40
    nop
    sbc a,a
    nop
    adc a,a
    nop
    adc a,a
    nop
    rst 40
    nop
    sbc a,a
    nop
    adc a,a
    nop
    rst 40
    nop
    sbc a,a
    nop
    rst 24
    nop
    sub b
    nop
    cp 13
    adc a,30
    ld e,106
    ld l,d
    ld e,e
    ld c,h
    ld e,c
    ld d,c
    ld e,c
    ld d,e
    ld e,e
    ld e,e
    rra 
    ld bc,lab10FF+1
    inc b
    ex af,af''
    ex af,af''
    ld bc,lab0700
    and b
    inc bc
    ret nz
    cpl 
    add a,b
    inc bc
    ret nz
    ld bc,lab089E+2
    sub b
    nop
    adc a,b
    ld de,lab098F+1
    inc bc
    ex af,af''
    add a,h
    ld (bc),a
    inc bc
    ex af,af''
    add a,h
    ld (bc),a
    inc bc
    inc bc
    add a,e
    ld (bc),a
    add a,l
    ld bc,lab0302
    add a,h
lab5B65 ld bc,lab0303+2
    ld a,(bc)
    inc bc
    add hl,bc
    inc bc
    add hl,bc
    ld (bc),a
    ld a,(bc)
    ld bc,lab000B+1
    dec c
    nop
    dec c
    dec b
    ex af,af''
    dec b
    add a,(hl)
    ld (bc),a
    inc bc
    dec b
    add a,e
    dec b
    inc bc
    dec c
    inc bc
    ld c,2
    nop
    jr nz,lab5B86
lab5B86 ld b,c
    nop
    nop
    ex af,af''
    jr nc,lab5B98
    ld h,b
    rrca 
    ld h,b
    inc bc
    ret po
    inc bc
    ret nz
    ld de,lab23DF+1
    ret p
    ld b,e
lab5B98 ld d,b
    inc bc
    ld b,b
    ld (bc),a
    nop
    nop
    ld (bc),a
    nop
    ld bc,lab8E11
    nop
    ld (bc),a
    nop
    inc bc
    nop
    add a,e
    inc bc
    ex af,af''
    nop
    inc c
    ld (bc),a
    ld a,(bc)
    ld (bc),a
    ld a,(bc)
    ld (bc),a
    inc c
    ld (bc),a
    inc c
    ld (bc),a
    inc c
    ld (bc),a
    ld a,(bc)
    nop
    add a,d
    ld (bc),a
    add hl,bc
    nop
    add a,d
    ld (bc),a
    add hl,bc
    nop
    add a,d
    ld (bc),a
    add hl,bc
    rlca 
    inc bc
    inc b
    ld b,4
    inc bc
    inc b
    inc bc
    add a,b
    nop
    ld b,b
    nop
    ld (bc),a
    nop
    ld (de),a
    jr nz,lab5BE0
    ld h,b
    ld b,192
    rlca 
    ret m
    dec de
    add a,b
    inc bc
    ld h,b
    ld (bc),a
lab5BE0 jr nz,lab5B65+1
    djnz lab5BE4
lab5BE4 add a,b
    nop
    add a,b
    nop
    nop
    inc b
    nop
    ld de,lab0A8F+1
    inc bc
    ld a,(bc)
    inc bc
    add hl,bc
    inc b
    ld (bc),a
    add a,e
    inc b
    inc b
    ld (bc),a
    add a,e
    ld bc,lab0205+1
    add a,e
    ld bc,lab0504+2
    rlca 
    inc bc
    add hl,bc
    ld (bc),a
    adc a,c
    ld bc,lab0203+1
    adc a,c
    ld bc,lab0203+1
    adc a,c
    ld bc,lab0404
    rlca 
    ld bc,lab0008+1
    add a,h
    ld bc,lab0005
    add a,h
    ld bc,lab0003
    add a,e
    ld (bc),a
    inc bc
    dec b
    inc bc
    nop
    djnz lab5C24
lab5C24 djnz lab5C26
lab5C26 jr nz,lab5C38
    nop
    ld bc,lab0100
    jr nz,lab5C31
    ld b,b
    rrca 
    add a,b
lab5C31 inc de
    add a,(hl)
    inc bc
    ret nz
    inc b
    add a,b
    nop
lab5C38 add a,b
    jr nz,lab5C3B
lab5C3B ld b,d
    nop
    ld (bc),a
    nop
    sub b
    ret m
    ex af,af''
    jr nz,lab5BE4
    rrca 
    inc bc
    rrca 
    inc bc
    rrca 
    add a,e
    ex af,af''
    inc bc
    ld c,132
    ld b,5
    inc b
    add a,e
    rlca 
    add a,h
    dec b
    ld b,4
    add a,h
    ld b,132
    inc b
    ld b,4
    add a,(hl)
    inc b
    add a,h
    ld (bc),a
    rlca 
    inc b
    adc a,b
    ld (bc),a
    add a,h
    ld bc,lab0508
    dec d
    ld b,19
    rlca 
    ld (de),a
    rlca 
    ld de,lab0F08
    add hl,bc
    rrca 
    inc b
    add hl,de
    inc b
    inc e
    inc b
    inc e
    rlca 
    add hl,de
    add hl,bc
    ld de,lab1008
    rlca 
    ld de,lab1306
    dec b
    adc a,(hl)
    ld bc,lab0406
    adc a,(hl)
    inc bc
    dec b
    inc b
    adc a,b
    ld bc,lab0486-1
    dec b
    inc bc
    adc a,b
    inc bc
    add a,l
    dec b
    inc b
    ld (bc),a
    add a,a
    dec b
    add a,e
    rlca 
    inc bc
    ld (bc),a
    add a,(hl)
    ld b,3
    ld bc,lab0786
    inc bc
    nop
    ld b,0
    dec b
    nop
    inc b
    nop
    nop
    add a,b
    nop
    nop
    nop
    add a,b
    nop
    nop
    nop
    add a,b
    djnz lab5CB9
lab5CB9 ld bc,lab607F+1
    inc b
    ld bc,labC080
    ld b,1
    add a,c
    ret nz
    inc bc
    add a,c
    add a,a
    add a,b
    ld bc,lab8FE1
    nop
    nop
    di
    sbc a,a
    nop
lab5CD0 nop
    ei
    cp 0
    nop
    ld a,a
    call m,lab0000
    ccf 
    ret m
    nop
    nop
    rra 
    ret p
    nop
    nop
    rra 
    cp 0
    rlca 
    rst 56
    rst 56
    ret p
    nop
    rst 56
    rst 56
    rst 56
    nop
    ccf 
    rst 56
    add a,b
    nop
    rra 
    call m,lab0000
    ccf 
    call c,lab0000
    ld a,a
    adc a,0
    nop
    rst 56
    add a,0
    ld bc,lab83FB
    nop
    inc bc
    ex (sp),hl
    add a,c
    add a,b
    rlca 
    jp lab8080
    rlca 
    ld bc,lab4000
    ld c,1
    nop
    nop
    inc e
    ld bc,lab0000
    jr lab5D1A
lab5D1A nop
    nop
    jr nc,lab5D1E
lab5D1E nop
    nop
    ld h,b
    nop
    nop
    nop
    sub b
    nop
    inc b
    jr lab5CB9
    dec bc
    inc bc
    ld a,(bc)
    inc b
    inc b
    add a,e
lab5D2F ld (bc),a
    dec b
    nop
    adc a,b
    ld bc,lab0005
    dec c
    nop
    dec c
    ld bc,lab020B+1
    ld c,2
    ld c,0
    djnz lab5D42
lab5D42 rrca 
    nop
    djnz lab5D46
lab5D46 djnz lab5D4B
    dec c
    ld (bc),a
    ld a,(bc)
lab5D4B ld (bc),a
    dec bc
    ld (bc),a
    dec bc
    ld (bc),a
    add a,l
    ld (bc),a
    inc b
    ld bc,lab0486-1
    inc bc
    ld bc,lab0105
    dec b
    ld bc,lab0104
    inc bc
    ld bc,lab0003
    ex af,af''
    nop
    jr lab5D6A
    jr nc,lab5DA8+2
    jr nc,lab5D9C+1
lab5D6A ld (hl),b
    dec e
    ret po
    rlca 
    ret nz
    rlca 
    cp 31
    ret m
    ld a,a
    ret p
    rst 32
    call z,labC20F
    ld c,224
    inc c
    ld h,b
    inc e
    ld h,b
    inc e
    jr nc,lab5D9A
    djnz lab5D9C
    nop
    jr c,lab5D87
lab5D87 jr nc,lab5D89
lab5D89 jr nz,lab5D8B
lab5D8B jr nz,lab5D8D
lab5D8D sub b
    inc b
    call m,labC80A
    ld a,(de)
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
lab5D9A jr nc,lab5DCC
lab5D9C djnz lab5D2F
    ld d,(hl)
    call m,lab3E3F
    ld c,b
    adc a,b
lab5DA4 di
    ld hl,lab7B52
lab5DA8 ld de,lab0100
    ld bc,lab09A1+2
    ldir
    ld sp,lab0052+1
    ld hl,lab8600
    ld de,lab8000
    ld bc,lab2000
    ldir
    ld b,8
    ld de,labBFFF
    ld hl,lab9FFF
lab5DC6 push bc
    ld bc,lab03FF+1
    lddr
lab5DCC ld a,d
    sub 4
    ld d,a
    pop bc
    djnz lab5DC6
    ld a,195
    ld (lab0038),a
lab5DD8 ld sp,labC000
    call lab9600
    call labBE0A
    call lab8752
    add a,d
    rst 56
    rrca 
    add a,h
    nop
    add a,c
    jp nz,lab43E3+1
    ld c,a
    ld d,b
    ld e,c
    ld d,d
    ld c,c
    ld b,a
    ld c,b
    ld d,h
    jr nz,lab5E3B
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,lab5E51
    ld c,a
    ld b,(hl)
    ld d,h
    ld d,a
    ld b,c
    ld d,d
    ld b,l
    jr nz,lab5E38
    add hl,sp
    jr c,lab5E40
    add a,c
    call nz,lab50E0+1
    ld d,d
    ld c,a
    ld b,a
    ld d,d
    ld b,c
    ld c,l
    ld c,l
    ld c,c
    ld c,(hl)
    ld b,a
    add a,c
    add a,h
    jp po,lab5246+1
    ld b,c
    ld d,b
    ld c,b
    ld c,c
    ld b,e
    ld d,e
    add a,c
    call nz,lab4DE3
    ld d,l
    ld d,e
    ld c,c
    ld b,e
    add a,d
    ret p
    ret p
    add a,c
    call c,lab4DE1
    ld c,c
    ld c,e
    ld b,l
    jr nz,lab5E88+1
    ld c,c
lab5E38 ld b,e
    ld c,b
    ld b,c
lab5E3B ld d,d
    ld b,h
    ld d,e
    ld c,a
    ld c,(hl)
lab5E40 add a,c
    sbc a,h
    jp po,lab494D
    ld c,e
    ld b,l
    jr nz,lab5E88+2
    ld c,(hl)
    ld b,h
    jr nz,lab5E95+2
    ld b,c
    ld c,(hl)
    ld b,l
    add a,c
lab5E51 inc e
    ex (sp),hl
    ld d,d
    ld c,c
    ld b,e
    ld c,b
    ld b,c
    ld d,d
    ld b,h
    ld d,e
    ld c,a
    ld c,(hl)
    add a,c
    call c,lab4AE1+2
    ld d,l
    ld c,h
    ld c,c
    ld b,c
    ld c,(hl)
    jr nz,lab5EAA
    ld d,d
    ld b,l
    ld b,l
    ld e,d
    ld b,l
    add a,b
    ld de,lab4C53+2
    ld c,82
    call labBF5A
    jp lab5F69
lab5E79 ld hl,(labBE06+2)
    ld (labBEA4),hl
    ld de,(labBEAE)
    or a
    push hl
    sbc hl,de
    pop hl
lab5E88 jp c,lab5F69
    ld de,lab0008+2
    ld b,6
    ld ix,labBEA4+2
lab5E94 ld a,l
lab5E95 sub (ix+8)
    ld a,h
    sbc a,(ix+9)
    jr c,lab5EA2
    add ix,de
    djnz lab5E94
lab5EA2 push hl
    push ix
    pop hl
    or a
    sbc hl,de
    push hl
lab5EAA ld de,labBEA4+2
    ld a,6
    sub b
    add a,a
    ld b,a
    add a,a
    add a,a
    add a,b
    jr z,lab5EBF
    ld hl,labBEAE+2
    ld c,a
    ld b,0
    ldir
lab5EBF call labBE0A
    call lab8752
    add a,c
    inc c
    jp po,labF082
    rst 56
    add a,h
    nop
    ld d,h
    ld c,b
    ld c,a
    ld d,l
    jr nz,lab5F1B
    ld b,c
lab5ED4 ld d,e
    ld d,h
    jr nz,lab5F1C
    ld c,a
    ld c,(hl)
    ld b,l
    jr nz,lab5F33+1
    ld b,l
    ld c,h
    ld c,h
    add a,c
    call z,lab45E2
    ld c,(hl)
    ld d,h
    ld b,l
    ld d,d
    jr nz,lab5F31+1
    ld b,l
    ld d,d
    ld b,l
    jr nz,lab5F43
    ld c,b
    ld e,c
    jr nz,lab5F41
    ld b,c
    ld c,l
    ld b,l
    add a,c
    ret c
    ex (sp),hl
    add a,b
    call lab6100
    ld de,lab575F
lab5F00 ld c,71
    call lab8738
    pop hl
    ld b,8
lab5F08 push hl
    push bc
lab5F0A call labA668+2
    pop bc
    pop hl
    cp 146
    jr nz,lab5F2D
    ld a,b
    cp 8
    jr z,lab5F08
    dec hl
    push hl
    inc b
lab5F1B push bc
lab5F1C call lab6109
    call lab8752
    add a,e
    cp 32
    add a,e
    cp 128
lab5F28 call lab6100
    jr lab5F0A
lab5F2D cp 13
    jr z,lab5F59
lab5F31 cp 32
lab5F33 jr z,lab5F3D
    cp 65
    jr c,lab5F08
    cp 91
    jr nc,lab5F08
lab5F3D inc b
    dec b
    jr z,lab5F08
lab5F41 dec b
    ld (hl),a
lab5F43 inc hl
    push hl
    push bc
    ld (lab5F52),a
    call lab6109
    call lab8752
    add a,d
    rrca 
    rst 56
lab5F52 jr nz,lab5ED4
    call lab6100
    jr lab5F0A
lab5F59 ld a,b
    or a
    jr z,lab5F62
lab5F5D ld (hl),32
    inc hl
    djnz lab5F5D
lab5F62 pop de
    ld (hl),e
    inc hl
    ld (hl),d
lab5F66 call labBEE0+2
lab5F69 call labBE0A
    call lab8752
    add a,d
    rst 56
    ret p
    add a,c
lab5F73 jp z,lab31E1
    jr nz,lab5F98
    ld b,c
    ld c,h
    ld d,h
    ld b,l
    ld d,d
    jr nz,lab5FD1+1
lab5F7F ld c,e
    ld c,c
    ld c,h
    ld c,h
    jr nz,lab5FA5
lab5F85 inc (hl)
    add a,c
    ld c,d
    jp po,lab2031+1
    jr nz,lab5FCE
    ld c,h
    ld d,h
    ld b,l
    ld d,d
    jr nz,lab5FE2+1
    ld c,h
    ld b,c
    ld e,c
    ld c,c
    ld c,(hl)
lab5F98 ld b,a
    jr nz,lab5FE5+1
    ld b,l
    ld e,c
    ld d,e
    add a,c
    jp z,lab33E2
    jr nz,lab5FC4
    ld d,(hl)
lab5FA5 ld c,c
    ld b,l
    ld d,a
    jr nz,lab5FFD
lab5FAA ld b,e
    ld c,a
    ld d,d
    ld b,l
    jr nz,lab6003+1
    ld b,c
    ld b,d
    ld c,h
    ld b,l
    add a,c
    ld c,d
    ex (sp),hl
    inc (hl)
    jr nz,lab5FD9+1
    ld d,b
    ld c,h
    ld b,c
    ld e,c
    add a,c
    sub b
    call po,lab4E45
    ld d,h
lab5FC4 ld b,l
    ld d,d
    jr nz,lab5FF8+1
    jr nz,lab601E
    ld c,a
    jr nz,lab6000+1
    add a,d
lab5FCE ret p
    ret p
lab5FD0 add a,b
lab5FD1 ld de,lab4C4A
    ld c,77
    call lab8738
lab5FD9 call labA668+2
    sub 49
    jr c,lab5FD9
    cp 4
lab5FE2 jr nc,lab5FD9
    or a
lab5FE5 jr nz,lab6024
    call labBE0A
    call lab8752
    add a,c
    inc c
    ex (sp),hl
    add a,d
    rst 56
    rrca 
    ld b,l
    ld c,(hl)
    ld d,h
    ld b,l
    ld d,d
lab5FF8 jr nz,lab604D
    ld c,e
    ld c,c
    ld c,h
lab5FFD ld c,h
    jr nz,lab6031
lab6000 jr nz,lab6056
    ld c,a
lab6003 jr nz,lab603D
    add a,b
    ld de,lab4D59
    ld c,74
    call lab8738
lab600E call labA668+2
    cp 49
    jr c,lab600E
    cp 57
    jr nc,lab600E
    ld (lab5F85),a
    sub 49
lab601E ld (labB601),a
    jp lab5F69
lab6024 dec a
    jp nz,lab60F0
    call labBE0A
    call lab8752
    add a,d
    rst 56
    rst 56
lab6031 add a,c
    ld c,226
    ld sp,lab4A20
    ld c,a
    ld e,c
    ld d,e
    ld d,h
    ld c,c
    ld b,e
lab603D ld c,e
    add a,c
    adc a,(hl)
    jp po,lab2031+1
    ld d,e
    ld d,h
    ld b,c
    ld c,(hl)
    ld b,h
    ld b,c
    ld d,d
    ld b,h
    jr nz,lab6098
lab604D ld b,l
    ld e,c
    ld d,e
    add a,c
    ld c,227
    inc sp
    jr nz,lab609A
lab6056 ld b,l
    ld b,(hl)
    ld c,c
    ld c,(hl)
    ld b,l
    jr nz,lab60A8
    ld b,l
    ld e,c
    ld d,e
    add a,c
    ld d,d
    call po,lab4E45
    ld d,h
    ld b,l
    ld d,d
    jr nz,lab609A+1
    jr nz,lab60C0
    ld c,a
    jr nz,lab60A1+1
    add a,b
    ld de,lab4B4A
    ld c,82
    call lab8738
lab6078 call labA668+2
    sub 49
    jr c,lab6078
lab607F cp 3
    jr nc,lab6078
    or a
lab6084 jr nz,lab6094
    ld hl,labA7F1
lab6089 ld de,labA7D9
    ld bc,lab000B+1
    ldir
    jp lab5F69
lab6094 ld hl,labA7E5
    dec a
lab6098 jr z,lab6089
lab609A call labBE0A
    call lab8752
    add a,c
lab60A1 djnz lab6084+1
    add a,d
    rrca 
    rst 56
    ld d,b
    ld d,d
lab60A8 ld b,l
    ld d,e
    ld d,e
    jr nz,lab60ED+1
    ld c,(hl)
    ld e,c
lab60AF jr nz,lab60FA+2
    ld b,l
    ld e,c
    jr nz,lab60FA+1
    ld c,a
    ld d,d
    add a,b
    ld de,lab4C4D
    ld c,85
    call lab8738
lab60C0 ld hl,lab6112
    ld de,labA7D9
    ld b,6
lab60C8 push bc
    push de
    ld de,lab60D7+2
    ld bc,lab0005
    ldir
    push hl
    call lab8752
    add a,c
lab60D7 call c,lab20E1+2
    jr nz,lab60FA+2
    jr nz,lab60FD+1
    add a,b
    call labA668+2
    pop hl
    ex (sp),hl
    ld (hl),b
    inc hl
    ld (hl),d
    inc hl
    ex de,hl
    pop hl
    pop bc
    djnz lab60C8
lab60ED jp lab5F69
lab60F0 dec a
    jp z,lab5F66
    ld hl,lab865D
    ld (lab8646+1),hl
lab60FA call lab78D4
lab60FD jp lab5E79
lab6100 ld hl,(lab86EB)
    ld (hl),255
    inc l
    ld (hl),255
    ret 
lab6109 ld hl,(lab86EB)
lab610C ld (hl),0
    inc l
    ld (hl),0
    ret 
lab6112 jr nz,lab615A
    ld c,c
    ld d,d
    ld b,l
    jr nz,lab6139
    jr nz,lab6170
    ld d,b
    jr nz,lab6162
    ld c,a
    ld d,a
lab6120 ld c,(hl)
    jr nz,lab616F
    ld b,l
    ld b,(hl)
    ld d,h
    ld d,d
    ld c,c
    ld b,a
    ld c,b
    ld d,h
    ld d,b
    ld b,c
    ld d,l
    ld d,e
    ld b,l
lab6130 ex af,af''
    ld a,(labB601)
    push bc
    ld b,a
    ld a,(lab2473)
lab6139 add a,a
    add a,b
    ld b,a
    ld a,(lab0117)
    rra 
    jr c,lab6144
    sla b
lab6144 ex af,af''
    bit 7,a
    jr z,lab614D
    res 7,a
    sla b
lab614D add a,b
    pop bc
    neg
lab6151 push hl
    push de
    ld e,a
    or a
lab6155 ld a,255
    jp m,lab616F
lab615A add a,e
    jr nc,lab615F
    ld a,255
lab615F ld de,lab454C
lab6162 cp 20
    jr c,lab6177
    cp 50
    jr nc,lab617F
    ld de,lab5543+2
    jr lab617F
lab616F add a,e
lab6170 jr c,lab6173
    xor a
lab6173 cp 20
    jr nc,lab615F
lab6177 call lab08F1
    ld de,lab5555
    ld a,15
lab617F ld (lab6155+1),a
    srl a
    ld l,a
    srl a
    srl a
    adc a,0
    ld h,a
    sub l
    neg
    ld l,a
    di
    ld a,(labB7F2)
    bit 3,a
    jr z,lab619E
    ld a,l
    ld l,h
    ld h,a
    ld a,e
    ld e,d
    ld d,a
lab619E ld (labB7D0+1),hl
    ld (labB7C4+1),de
    ei
    pop de
    pop hl
    ret 
lab61A9 nop
lab61AA nop
lab61AB and e
lab61AC ret nz
    dec bc
    ex af,af''
    ld a,(bc)
    nop
    ret m
lab61B2 and e
lab61B3 ld de,lab0000+1
lab61B6 nop
lab61B7 ld hl,lab0000
    ld (lab61A9),hl
    ld hl,lab0BC0
    ld (lab61AC),hl
    ld a,163
    ld (lab61AB),a
    ld a,1
    ld (lab61B3+1),a
    xor a
    ld (lab11BE),a
    ld a,209
    ld (lab11B8),a
    ld a,(labB601)
    cp 6
    ld a,181
    jr c,lab61E1
    ld a,185
lab61E1 ld (lab620B+1),a
    ret 
lab61E5 nop
    nop
lab61E7 nop
    nop
lab61E9 call lab7B34
    ld ix,lab61AB
    ld a,(lab61AA)
    and 215
    ld (lab61AA),a
    ld de,lab01AC+1
    ld hl,lab11B4
    call lab64FB
    jr nz,lab620B
    set 3,(ix-1)
    ld (lab61E7),de
lab620B ld de,lab01B6-1
    ld hl,lab11BA
    call lab64FB
    jr nz,lab621E
    set 5,(ix-1)
lab621A ld (lab61E5),de
lab621E call lab7B39
    bit 4,(ix-1)
    jr z,lab625F
    bit 0,(ix-2)
    jr z,lab6236
    call lab094C
    ld ix,lab61AB
    jr lab625F
lab6236 ld hl,lab0089
    ld de,lab000B+1
    ld b,4
lab623E bit 4,(hl)
    jr nz,lab624A
    set 4,(hl)
    inc hl
    inc hl
    ld (hl),0
    dec hl
    dec hl
lab624A add hl,de
    djnz lab623E
    ld a,(lab246F+2)
    or a
    jr nz,lab625F
    ld a,20
    ld (lab246F+2),a
    call lab093E
    set 0,(ix-2)
lab625F bit 5,(ix+9)
    ret nz
    ld d,(ix-1)
    bit 7,d
    jr nz,lab6291
    ld a,(lab13F4)
    cp (ix+0)
    ret nz
    ld a,(lab22CE)
    cp (ix+9)
    ret nz
    ld de,(lab61AC)
    ld hl,lab00D0
    add hl,de
    ex de,hl
    call lab689F
    ret c
    ld (ix+9),128
    set 7,(ix-1)
    jp lab6786
lab6291 bit 0,d
    jr z,lab62BD
    bit 1,d
    ret z
lab6298 ld a,0
    or a
    jr z,lab62A1
    dec a
    ld (lab6298+1),a
lab62A1 ld a,(lab0117)
    rra 
    ret c
    bit 5,d
    jr nz,lab62B0
    bit 2,d
    ret nz
    bit 3,d
    ret z
lab62B0 call lab642C
    res 0,d
    set 6,d
    ld (ix-1),d
    jp lab63AC
lab62BD call lab677C
    ld a,c
    call lab07FE
    ld a,7
    add a,b
    cp 140
    jr c,lab62CD
    ld a,139
lab62CD ld b,a
    bit 5,d
    jr z,lab62D6
    bit 2,d
    jr nz,lab6336
lab62D6 bit 3,d
    jr z,lab62DF
    bit 2,d
    jp z,lab635F
lab62DF ld a,(lab0117)
    rra 
    jp nc,lab6384
lab62E6 xor a
    ld hl,lab1199+2
lab62EA call lab67A2
    call lab6786
    ld a,123
    call lab1BA3
    bit 7,(ix+9)
    jr z,lab62FC
    inc hl
lab62FC push hl
    ld hl,lab11AA
    ld (lab61B2),hl
    ld d,2
    ld hl,lab1301+2
    xor a
    call lab6813
    pop hl
    call lab677C
    call lab68DC
    call lab1BA1
    call lab677C
    ld a,c
    add a,10
    cp 52
    ret c
    call lab68C0
    ld (lab61AC),hl
    ld a,(lab13F4)
    ld (lab61AB),a
    ld a,(lab22CE)
    ld (lab61B3+1),a
    res 7,(ix-1)
    ret 
lab6336 bit 6,d
    jr nz,lab63AC
    bit 4,d
    jr nz,lab62E6
    ld a,8
    ld hl,lab61E5
    call lab647C
    jr nz,lab62EA
    ld a,209
    ld (lab11BE),a
    set 4,(ix-1)
    push bc
    ld bc,lab2080
    ld a,7
    call lab8E4F
    pop bc
    ld a,3
    jr lab62EA
lab635F bit 6,d
    jr nz,lab63AC
    ld a,0
    ld hl,lab61E7
    call lab647C
    jp nz,lab62EA
    xor a
    ld (lab11B8),a
    set 2,(ix-1)
    push bc
    ld bc,lab2000
    ld a,5
    call lab8E4F
    pop bc
    xor a
    jp lab62EA
lab6384 bit 6,d
    jr nz,lab63D9
    ld a,(labA750)
    add a,a
    ld a,216
    jr nc,lab6392
    ld a,40
lab6392 ld hl,labB792
    call lab647C
    jp nz,lab62EA
    ld a,(lab0117)
    bit 2,a
    ld a,3
    jp nz,lab62EA
    set 6,(ix-1)
    jp lab62EA
lab63AC call lab6450
    ld a,(ix+2)
    add a,3
    ld (ix+2),a
    push bc
    ld bc,lab40FE
    sub 110
    srl a
    rr c
    call lab8E4F
    pop bc
    xor a
    call lab67A2
    ld a,b
    ld b,(ix+2)
    cp b
    jp nc,lab62E6
    ld b,a
    res 6,(ix-1)
    jp lab62E6
lab63D9 ld a,(lab0117)
    bit 2,a
    jr z,lab63E9
    ld b,123
    res 6,(ix-1)
    jp lab62E6
lab63E9 call lab6450
    ld a,(ix+2)
    ld b,a
    bit 4,(ix+9)
    jp nz,lab62E6
    sub 3
    ld b,a
    push bc
    ld bc,lab30FD+1
    sub 110
    srl a
    rr c
    call lab8E4F
    pop bc
    ld a,(labB794)
    cp b
    jp c,lab62E6
    set 0,d
    set 1,d
    ld (ix-1),d
    jp lab6419
lab6419 ld a,196
    ld hl,labC1C0
    ld e,190
    call lab6465
    ld a,(lab0117)
    set 5,a
lab6428 ld (lab0117),a
    ret 
lab642C call lab08DC
    ld a,(labA750)
    add a,a
    ld a,210
    jr c,lab6439
    ld a,42
lab6439 call lab6790
    call lab6786
lab643F xor a
    ld e,a
    ld hl,lab0000
    ld a,l
    ld e,l
    call lab6465
    ld a,(lab0117)
    res 5,a
    jr lab6428
lab6450 ld a,b
    ex af,af''
    call lab08DC
    ld a,(labA750)
    add a,a
    ld a,216
    jr c,lab645F
    ld a,40
lab645F call lab6790
    ex af,af''
    ld b,a
    ret 
lab6465 ld (lab12BA),a
    ld (lab12D9),a
    ld (lab130B),a
    ld (lab1339),a
    ld (lab136E),a
    ld (lab1097),hl
    ld a,e
    ld (lab13C1),a
    ret 
lab647C inc hl
    push bc
    call lab6790
    ld a,c
    add a,10
    ld c,a
    ld a,(hl)
    add a,10
lab6488 cp c
    pop bc
    jr z,lab64AC
    jr c,lab6496
    bit 6,(ix+9)
    jr z,lab64A4
    jr lab649C
lab6496 bit 6,(ix+9)
    jr nz,lab64A4
lab649C ld a,192
    xor (ix+9)
    ld (ix+9),a
lab64A4 xor a
    inc a
lab64A6 ld hl,lab1192
    ld a,4
    ret 
lab64AC dec hl
    ld a,(hl)
    sub e
    jp p,lab64B4
    neg
lab64B4 cp 5
    jr nc,lab64A4
    xor a
    jr lab64A6
lab64BB ld a,(lab61AA)
    and 3
    cp 3
    ret nz
    ld a,(lab6298+1)
    or a
    jr nz,lab64D3
    ld a,(labB601)
    add a,a
    add a,10
    ld (lab6298+1),a
    ret 
lab64D3 push ix
    push hl
    push de
    push bc
    ld hl,lab11A3
    ld (lab61B2),hl
    ld ix,lab61AB
    call lab08CB
    call lab642C
    res 1,(ix-1)
    call lab6533
    ld bc,lab8001
    call lab8E7E
    pop bc
    pop de
    pop hl
    pop ix
    ret 
lab64FB ld a,(lab13F4)
    cp e
    ret nz
    ld a,(lab22CE)
    cp d
    ret nz
    push hl
    ld de,lab0BC0
    call lab689F
    pop hl
    ret c
    ld b,122
    push ix
    ld d,c
    push de
    call lab1446
    pop de
    pop ix
    xor a
    ret 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab652F nop
lab6530 cpl 
    ld h,l
lab6532 nop
lab6533 ld a,(lab6532)
    inc a
    ld (lab6532),a
    ld hl,(lab6530)
    ld a,ixl
    ld (hl),a
    dec hl
    ld a,ixh
    ld (hl),a
    dec hl
    ld (lab6530),hl
    ld a,(ix+9)
    and 193
    ld (ix+9),a
    ret 
lab6551 ld a,(lab6532)
    or a
    ret z
    ld b,a
    ld a,124
    call lab1BA3
    ld hl,lab652F
lab655F ld e,(hl)
    dec hl
    ld d,(hl)
    dec hl
    push de
    pop ix
    push bc
    push hl
    call lab677C
    bit 4,(ix+9)
    jr nz,lab65E6
    ld a,(lab0102)
    ld d,a
    ld a,(ix+11)
    inc a
    jr z,lab657C
    dec a
lab657C sra a
    ld l,a
    inc a
    jr z,lab6583
    dec a
lab6583 sra a
    add a,l
    ld (ix+11),a
    add a,d
    call lab6790
    ld a,(ix+10)
    add a,a
    ld (ix+10),a
    add a,b
    cp 123
    jr nc,lab65C9
    ld b,a
lab659A call lab675B
    call lab666B
    call lab6679
    call lab7B34
lab65A6 pop hl
    pop bc
    djnz lab655F
    call lab1BA1
    ret 
lab65AE ld a,(lab61AA)
    and 190
    ld (lab61AA),a
    res 4,(ix+9)
    ret 
lab65BB ld (ix+2),b
    call lab65AE
    call lab6606
    call lab677C
    jr lab659A
lab65C9 set 4,(ix+9)
    ld (ix+11),0
    ld b,123
    ld a,(ix+1)
    push bc
    call lab07FE
    pop bc
    jr z,lab6631
    ld a,163
    cp (ix+7)
    jr z,lab65BB
    jr lab65F2
lab65E6 ld a,(lab0102)
    call lab6790
    bit 2,(ix+9)
    jr nz,lab6642
lab65F2 call lab6786
    call lab676F
    call lab666B
    call lab68DC
lab65FE call z,lab6606
    call lab7B34
    jr lab65A6
lab6606 ld a,(lab6532)
    dec a
    ld (lab6532),a
    ld hl,(lab6530)
    inc hl
    inc hl
    ld (lab6530),hl
    pop iy
    pop hl
    pop bc
    push bc
    ld e,l
    ld d,h
    inc de
    inc de
    push de
lab661F push iy
    ld a,b
    dec a
    ret z
    add a,a
    ld c,a
    ld b,0
    lddr
    ret 
lab662B call lab6606
    jp lab65A6
lab6631 set 2,(ix+9)
    ld a,160
    ld (lab113B+1),a
    ld a,164
    ld (lab113F),a
    call lab6786
lab6642 ld hl,lab113A
    ld a,e
    push ix
    call lab1446
    pop ix
    ld a,(lab113B+1)
    cp 164
    jp nz,lab65A6
    ld a,163
    cp (ix+7)
    jr z,lab6662
    set 5,(ix+9)
    jr lab662B
lab6662 call lab65AE
lab6665 res 5,(ix+9)
    jr lab662B
lab666B push hl
    bit 4,(hl)
    jr z,lab6671
    inc hl
lab6671 inc hl
    bit 5,(hl)
    call nz,lab7B39
    pop hl
    ret 
lab6679 call lab6786
    call lab676F
    ld a,e
    jp lab1446
lab6683 ld a,(lab6532)
    or a
    ret z
lab6688 push hl
    push de
    push bc
    ld b,a
    ld hl,lab652F
lab668F ld e,(hl)
    dec hl
    ld d,(hl)
    dec hl
    push bc
    push hl
    ld a,(ix+2)
    sub (ix+4)
    ld b,(ix+6)
    push ix
    push de
    pop ix
    cp (ix+2)
    jr c,lab66B4
    add a,b
    ld b,a
    ld a,(ix+10)
    add a,a
    add a,(ix+2)
    cp b
    jr nc,lab66B8
lab66B4 pop ix
    jr lab66ED
lab66B8 call lab6867
    ld a,10
    add a,c
    ld c,a
    ld l,c
    ld h,e
    ld a,(ix+3)
    ex af,af''
lab66C5 pop ix
    call lab6867
    ld a,10
lab66CC add a,c
    ld c,a
    ld b,e
    push bc
    ld a,(ix+3)
    call lab6790
    ld a,l
    cp c
    jr nz,lab66DC
    ld a,h
    cp e
lab66DC ld e,h
    ld c,l
    pop hl
    jr nc,lab66ED
    ex af,af''
    call lab6790
    ld a,l
    cp c
    jr nz,lab66EB
    ld a,h
    cp e
lab66EB jr c,lab66F4
lab66ED pop hl
lab66EE pop bc
    djnz lab668F
    xor a
    jr lab66F6
lab66F4 pop hl
    pop bc
lab66F6 pop bc
    pop de
    pop hl
    ret 
lab66FA nop
    inc a
    ld a,e
    dec bc
    inc b
    ld (bc),a
lab6700 call m,lab1135
    nop
    nop
    nop
lab6706 ld ix,lab66FA
    ld a,(lab0102)
    ld d,a
    call lab677C
    ld a,c
    add a,10
    cp 52
    jr c,lab6735
    ld a,r
    and 90
    ret nz
    ld a,(lab0117+2)
    cp 1
    ret z
    cp 4
    ret z
    cp 7
    ret z
    ld (ix+1),41
    bit 7,d
    ret nz
    ld (ix+1),247
    ret 
lab6735 ld a,d
    call lab6790
    call lab6786
    ld hl,(lab0100)
    call lab67CD
    jr nz,lab674E
    call lab677C
    ld a,e
    ld hl,lab1135
    jp lab1446
lab674E ld d,234
    ld hl,lab1003
    call lab085A
    ld (ix+1),50
    ret 
lab675B ld l,(ix+7)
    ld h,(ix+8)
    bit 7,(ix+9)
    ret z
    inc hl
    ret 
lab6768 ld (ix+7),l
    ld (ix+8),h
    ret 
lab676F ld l,(ix+7)
    ld h,(ix+8)
    bit 7,(ix+9)
    jr z,lab677C
    inc hl
lab677C ld e,(ix+0)
    ld c,(ix+1)
    ld b,(ix+2)
    ret 
lab6786 ld (ix+0),e
    ld (ix+1),c
    ld (ix+2),b
    ret 
lab6790 add a,e
    ld e,a
    cp 8
    ret c
    sra a
    sra a
    sra a
    add a,c
    ld c,a
    ld a,e
    and 7
    ld e,a
    ret 
lab67A2 bit 6,(ix+9)
    jr z,lab67AA
    neg
lab67AA ld (lab67B0+1),a
    ld a,(lab0102)
lab67B0 add a,0
    jr lab6790
lab67B4 ld hl,(lab0103)
    inc h
    ret z
    dec h
    push bc
    push de
    push hl
    call lab67CD
    pop hl
    pop de
    pop bc
    ret nz
    ld a,246
    add a,h
    ld h,a
    jr lab67CD
lab67CA ld hl,(lab0100)
lab67CD inc h
    ret z
    dec h
    ld a,(ix+6)
    add a,b
    sub h
    jr c,lab67F4
    cp (ix+4)
    jr nc,lab67F4
    call lab6867
    bit 7,c
    jr nz,lab67F6
    ld a,l
    rra 
    rra 
    rra 
    and 31
    cp c
    jr c,lab67F4
    jr nz,lab67F6
    ld a,l
    and 7
    cp e
    jr nc,lab67F6
lab67F4 xor a
    ret 
lab67F6 ld a,(ix+3)
    call lab6790
    bit 7,c
    jr nz,lab67F4
lab6800 ld a,l
    rra 
    rra 
    rra 
    and 31
    cp c
    jr c,lab6811
    jr nz,lab67F4
    ld a,l
    and 7
    cp e
    jr nc,lab67F4
lab6811 inc a
    ret 
lab6813 bit 4,(ix+9)
    ret nz
    bit 5,(ix+9)
    ret nz
    push af
    push hl
    push de
    call lab67CA
    pop de
    pop hl
    jr z,lab6843
    call lab085A
    set 5,(ix+9)
    set 4,(ix+9)
    pop af
    call lab8602
    xor a
    ret 
lab6838 bit 4,(ix+9)
    ret nz
    bit 5,(ix+9)
    ret nz
    push af
lab6843 call lab67B4
    jr z,lab685B
    ld a,4
    call labB671
    pop af
lab684E set 4,(ix+9)
    ld (ix+11),0
    call lab8602
    xor a
    ret 
lab685B call lab6683
    jr nz,lab6863
    pop af
    inc a
    ret 
lab6863 pop af
    add a,a
    jr lab684E
lab6867 call lab677C
    ld a,(ix+5)
    bit 7,(ix+9)
    jr z,lab6878
    neg
    sub (ix+3)
lab6878 jp lab6790
    ld de,lab0080
    pop hl
    ld b,(hl)
    inc hl
    ld c,(hl)
    inc hl
    push hl
lab6884 pop hl
    push hl
    push bc
    ld b,c
    ld a,(hl)
    inc hl
    ld c,(hl)
    inc hl
lab688C srl c
    rra 
    jr nc,lab6896
    ex af,af''
    ld a,(hl)
    ld (de),a
    inc hl
    ex af,af''
lab6896 inc de
    djnz lab688C
    pop bc
    djnz lab6884
    pop bc
    push hl
    ret 
lab689F ld hl,(lab8FFA)
    or a
    ex de,hl
    sbc hl,de
    ret c
    ld de,lab01A0
    ex de,hl
    sbc hl,de
    ret c
    ld a,e
    srl d
    rra 
    srl d
    rra 
    srl d
    rra 
    sub 10
    ld c,a
    ld a,e
    and 7
    ld e,a
    ret 
lab68C0 push de
    ld a,c
    add a,20
    ld d,0
    or a
    rla 
    rl d
    rla 
    rl d
    rla 
    rl d
    or e
    ld e,a
    ld hl,(lab8FFA)
    add hl,de
    ld de,labFEE0
    add hl,de
    pop de
    ret 
lab68DC bit 5,(ix+9)
    ret nz
    push ix
    bit 4,(ix+9)
    jr nz,lab68F2
    ld a,e
    call lab1446
    pop ix
    xor a
    inc a
    ret 
lab68F2 ld a,(ix+11)
    ld (lab13FE+1),a
    ld a,e
    call lab13FE
    pop ix
lab68FE ld (ix+11),e
    ret nz
    set 5,(ix+9)
    ret 
lab6907 ld a,l
    jr lab6913
lab690A ld a,l
    bit 7,(ix+9)
    jr z,lab6913
    neg
lab6913 call lab6790
    ld a,h
    add a,b
    ld b,a
    ret 
lab691A call lab690A
lab691D ld h,255
    ld a,c
    cp 32
    ret nc
    add a,a
    add a,a
    add a,a
    or e
    ld l,a
    bit 7,b
    ret nz
    ld h,b
    ret 
lab692D ld a,(labB79B)
    xor 16
    bit 4,a
    ret z
    call lab691A
    push ix
    ld ix,labB792
    call lab677C
    call lab67CD
    pop ix
    jp lab677C
    ld de,lab0080
    ld a,2
lab694E ld hl,lab6963
    ld bc,lab0018
lab6954 ldir
    dec a
    jr nz,lab694E
    ld a,(labB601)
    add a,a
    add a,8
    ld (lab13F6),a
    ret 
lab6963 nop
    nop
    nop
    djnz lab697B
    ret m
    ret m
    nop
    nop
    jr nz,lab696E
lab696E nop
    nop
    nop
    nop
    inc c
    rlca 
    ld b,255
    ld l,b
    ld (de),a
    ld (lab0000),hl
lab697B ld b,4
    call lab6E85
    ld a,123
    call lab1BA3
    ld ix,lab0080
    ld b,4
lab698B push bc
    call lab699B
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab698B
    call lab1BA1
lab699A ret 
lab699B ld d,(ix+9)
    bit 5,d
    jr z,lab69E9
    ld a,(lab13F7)
    or a
    ret nz
    ld a,r
    bit 6,a
    ret z
    and 30
    add a,8
    ld (ix+1),a
    bit 1,d
    jr nz,lab69E0
    ld a,r
    and 15
    ld l,a
    ld a,(labB794)
    cp 70
    ld a,l
    jr nc,lab69CA
    cp 7
    jr nc,lab69CA
    add a,9
lab69CA add a,a
    add a,4
    ld (ix+10),a
    ld (ix+2),244
    ld (ix+9),0
    bit 2,a
    ret z
    ld (ix+9),192
    ret 
lab69E0 ld (ix+9),2
    ld (ix+2),131
    ret 
lab69E9 call lab677C
    bit 3,d
    jp nz,lab6AEF
    bit 1,d
    jp nz,lab6AA0
    ld a,238
    bit 0,d
    jr nz,lab69FE
    ld a,248
lab69FE call lab67A2
    ld a,(ix+10)
    bit 0,d
    jr nz,lab6A27
    ld l,a
    srl a
    srl a
    inc a
    neg
    add a,l
    jr c,lab6A14
    xor a
lab6A14 ld (ix+10),a
    ld a,l
    neg
    jr nz,lab6A24
    set 0,(ix+9)
    ld (ix+10),1
lab6A24 add a,b
    jr lab6A42
lab6A27 add a,a
    jr nz,lab6A2B
    inc a
lab6A2B ld (ix+10),a
    add a,b
    jr c,lab6A35
    cp 224
    jr c,lab6A42
lab6A35 call lab6ADB
    ret nz
    ld hl,labFFC4
    call lab690A
    jp lab6AF3
lab6A42 ld b,a
    call lab6786
    ld hl,lab1240
    bit 0,d
    jr z,lab6A50
    ld hl,lab124B
lab6A50 bit 7,d
    jr z,lab6A55
    inc hl
lab6A55 call lab68DC
    ld hl,(lab0D02)
    call lab677C
    push bc
    push de
    call lab690A
    call lab6786
    ld a,4
    call lab6838
    pop de
    pop bc
    call lab6786
    ld a,(ix+11)
    push af
    ld hl,lab1256
    bit 7,(ix+9)
    jr z,lab6A7E
    inc hl
lab6A7E call lab68DC
    pop af
    ld (ix+11),a
    call lab677C
    ld hl,(lab0D02)
    call lab692D
    ret z
    ld a,158
    call lab6130
    call lab13F8
    set 0,(ix+9)
    ld (ix+10),1
    ret 
lab6AA0 ld a,b
    cp 123
    jr z,lab6AA6
    dec b
lab6AA6 xor a
    call lab67A2
    call lab6786
    ld a,r
    and 30
    jr nz,lab6AB7
    set 2,(ix+9)
lab6AB7 ld a,3
    ld hl,lab1000
    ld d,0
    call lab6813
    call z,lab7284
    call lab677C
    ld hl,lab125D
    bit 2,(ix+9)
    jr z,lab6AD3
    ld hl,lab1261+2
lab6AD3 call lab726D
    bit 2,(ix+9)
    ret z
lab6ADB bit 4,(ix+9)
    jr z,lab6AE6
    set 5,(ix+9)
    ret 
lab6AE6 set 3,(ix+9)
    ld (ix+10),0
    ret 
lab6AEF xor a
    call lab67A2
lab6AF3 ld b,123
    call lab6786
    ld a,(ix+10)
    inc (ix+10)
    cp 4
    jr nz,lab6B07
    set 5,(ix+9)
    ret 
lab6B07 call lab7B34
lab6B0A ld hl,lab6B21
    call labA6F8
    ld (lab127E+2),a
    inc hl
    ld a,(hl)
    ld (lab1282),a
    ld hl,lab127E
    call lab68DC
    jp lab7B39
lab6B21 inc c
    nop
    dec c
    ld c,16
    ld de,lab0010+2
lab6B29 ld de,lab0080
    ld a,2
lab6B2E ld bc,lab0018
    ld hl,lab6B45
    ldir
    dec a
    jr nz,lab6B2E
    ld a,(labB601)
    srl a
    inc a
    add a,10
    ld (lab13F6),a
    ret 
lab6B45 nop
    nop
    nop
    inc c
    add hl,de
    call m,lab0000
    nop
    jr nz,lab6B50
lab6B50 nop
    nop
    nop
    ld a,e
    inc c
    ex af,af''
    ld b,254
    sbc a,e
    ld (de),a
    ld hl,lab0000
    ld b,4
    call lab6E85
    ld ix,lab0080
    ld b,4
lab6B68 push bc
    call lab6B75
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab6B68
    ret 
lab6B75 ld d,(ix+9)
    bit 5,d
    jr z,lab6BC2
    ld a,(lab13F7)
    or a
    ret nz
    ld a,r
    and 14
    ret nz
    bit 0,d
    jr nz,lab6BAA
    ld a,r
    and 31
    ld b,a
    ld a,(labB794)
    sub 16
    add a,b
    ld (ix+2),a
    ld (ix+9),0
    ld (ix+1),40
    ld a,(labA750)
    add a,a
    ret nc
    ld (ix+1),248
    ret 
lab6BAA ld a,(lab61AA)
    bit 7,a
    ret z
    bit 0,a
    ret nz
    ld a,(lab61B3+1)
    and 48
    ret nz
    call lab7194
    xor 129
    ld (ix+9),a
    ret 
lab6BC2 call lab677C
    bit 0,d
    jr nz,lab6C37
    bit 4,d
    jr nz,lab6BD6
    ld a,(labB794)
    sub 25
    cp b
    call lab77CF
lab6BD6 xor a
    call lab67A2
    call lab6786
    ld a,2
    call lab6838
    call z,lab7284
    call lab677C
    ld hl,lab0404
    call lab692D
    jr z,lab6BFB
    ld a,16
    call lab6130
    call lab13F8
    call lab64BB
lab6BFB call lab677C
    ld hl,lab1284
    call lab726D
    call lab677C
    ld a,b
    sub 25
    ret c
    ret z
    ld b,a
    ld a,4
    call lab6790
    ld a,e
    ld hl,labBE00
    call labA6F9
    ld d,a
    ld a,c
    cp 32
    ret nc
    ld a,d
    push af
    push bc
    call lab87B7
    pop bc
    pop af
    and 15
    bit 2,e
    jr z,lab6C2D
    inc l
lab6C2D ld c,a
lab6C2E ld a,(hl)
    or c
    ld (hl),a
    call lab87D5
    djnz lab6C2E
    ret 
lab6C37 ld a,(labB601)
    srl a
    inc a
    ld l,a
    ld a,(lab13F7)
    or a
    ld a,l
    jr z,lab6C46
    xor a
lab6C46 call lab67A2
    ld a,(lab61AA)
    bit 7,a
    jr z,lab6C75
    and 65
    jr nz,lab6C75
    ld a,(lab61B3+1)
    ld h,a
    bit 4,a
    jr nz,lab6C75
    ld a,(lab61AC)
    ld l,a
    ld a,c
    bit 7,d
    jr z,lab6C67
    dec a
    dec a
lab6C67 inc a
    cp l
    jr nz,lab6C75
    ld a,h
    set 4,a
    ld (lab61B3+1),a
    xor a
    ld (lab61B6),a
lab6C75 call lab6786
    ld a,3
    ld hl,lab1000
    ld d,26
lab6C7F call lab6813
    call z,lab7284
    call lab677C
    ld hl,lab1295
    jp lab726D
lab6C8E ld a,32
    ld (lab6CA4),a
    ld (lab6CB0),a
    xor a
    ld (lab6CBE+1),a
    ret 
lab6C9B nop
    nop
    nop
    djnz lab6CA6
    inc b
    ei
    dec sp
    ld (de),a
lab6CA4 jr nz,lab6CA6
lab6CA6 nop
    nop
    nop
    nop
    djnz lab6CB2
    inc b
    ei
    dec sp
    ld (de),a
lab6CB0 jr nz,lab6CB2
lab6CB2 nop
lab6CB3 ld a,(lab2472)
    cp 3
    jr z,lab6CBE
    inc a
    ld (lab6CBE+1),a
lab6CBE ld a,0
    or a
    jr z,lab6CE0
    ld a,(lab6CA4)
    ld c,a
    ld a,(lab6CB0)
    and c
    bit 5,a
lab6CCD jr z,lab6CE0
    ld hl,lab2422
    ld (lab7ABA+1),hl
    ld a,(lab6D83+1)
    ld hl,(lab2474)
    inc hl
    inc hl
    inc hl
    ld (hl),a
    ret 
lab6CE0 ld ix,lab6C9B
    ld b,2
lab6CE6 push bc
    call lab6CF3
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab6CE6
    ret 
lab6CF3 call lab677C
    ld d,(ix+9)
    bit 5,d
    jr z,lab6D21
    ld a,(lab0117)
    rra 
    ret c
    ld a,r
    and 14
    ret nz
    ld a,(lab6CBE+1)
    or a
    ret nz
    ld a,(labB601)
    add a,11
    ld (ix+10),a
    ld (ix+2),123
    call lab7194
    xor 128
    ld (ix+9),a
    ret 
lab6D21 bit 0,d
lab6D23 jp nz,lab6DB1
    ld a,(ix+10)
    call lab67A2
    bit 4,d
    jr nz,lab6D74
    ld a,(labA750)
    add a,a
    ld a,(labB793)
    jr c,lab6D3B
    add a,5
lab6D3B add a,2
    ld l,a
    ld a,c
    bit 6,d
    jr z,lab6D46
    cp l
    jr lab6D4A
lab6D46 add a,10
    cp l
    ccf 
lab6D4A jr nc,lab6D57
    ld a,(labB794)
    cp 80
    jr c,lab6D57
    bit 2,d
    jr z,lab6D9B
lab6D57 ld a,(lab0117)
    rra 
    jr nc,lab6D74
    ld a,(labA750)
    ld l,a
    ld a,d
    add a,a
    xor l
    jp m,lab6D74
    ld a,(lab1233)
    cp 104
    jr nz,lab6D74
    ld a,r
    and 8
    jr z,lab6DA1
lab6D74 call lab6786
    ld a,4
    ld hl,lab1404+1
    ld d,22
    call lab6813
    jr nz,lab6D92
lab6D83 ld a,0
    or a
    jr z,lab6D92
    dec a
    ld (lab6D83+1),a
    jr nz,lab6D92
    inc a
    ld (lab6CBE+1),a
lab6D92 call lab677C
    ld hl,lab1230
    jp lab726D
lab6D9B set 1,d
    set 2,d
    jr lab6DA5
lab6DA1 res 1,d
    res 2,d
lab6DA5 set 0,d
    ld (ix+9),d
    ld (ix+11),0
    call lab677C
lab6DB1 ld a,(ix+11)
    inc (ix+11)
    bit 1,d
    jr z,lab6DF9
    ld hl,lab6E26
    call labA6F9
    or a
    jr nz,lab6DCA
    res 0,(ix+9)
    inc hl
    ld a,(hl)
lab6DCA bit 7,a
    ld a,252
    jr z,lab6DD2
    neg
lab6DD2 add a,b
    ld b,a
    ld a,(hl)
    res 7,a
    ld (lab1239),a
    ld a,(ix+10)
    call lab67A2
    call lab6786
    ld hl,labF600
    call lab692D
    jr z,lab6DF3
    ld a,12
    call lab6130
    call lab13F8
lab6DF3 ld hl,lab1234+2
    jp lab726D
lab6DF9 ld hl,lab6E1F
    call labA6F8
    call lab67A2
    call lab6786
    inc hl
    ld a,(hl)
    ld (lab1239),a
    push hl
    ld hl,lab1234+2
    call lab726D
    pop hl
    inc hl
    ld a,(hl)
    or a
    ret nz
    ld a,(ix+9)
    xor 193
    ld (ix+9),a
    ret 
lab6E1F rlca 
    inc a
    inc b
    dec a
    ld bc,lab0040
lab6E26 dec sp
    dec sp
    dec sp
    ld a,(labB8B9)
    cp b
    nop
    or l
lab6E2F nop
    nop
    nop
    inc b
    inc b
    nop
    nop
    ld (bc),a
    ld (de),a
    jr nz,lab6E3A
lab6E3A nop
lab6E3B nop
    ld hl,(lab0879+2)
    ld a,(bc)
    inc bc
    rst 48
    xor d
    ld de,lab00FF
    nop
    call lab7342+2
    ld a,4
    ld de,lab0080
lab6E4F ld hl,lab6E3B
    ld bc,lab000B+1
    ldir
    dec a
    jr nz,lab6E4F
    ld a,6
lab6E5C ld hl,lab6E2F
    ld bc,lab000B+1
    ldir
    dec a
    jr nz,lab6E5C
    ld a,(labB601)
    ld b,a
    srl a
    add a,3
    ld (lab6FA0+1),a
    ld a,b
    inc a
    srl a
    srl a
    add a,2
    ld (lab6EB9+1),a
    ld a,b
    add a,a
    add a,10
    ld (lab13F6),a
    ret 
lab6E85 ld hl,(lab13F6)
    ld a,h
    or a
    jr nz,lab6EA0
    ld a,(lab61AA)
    bit 4,a
    jr nz,lab6E9D
    ld a,(lab2472)
    or a
    jr nz,lab6E9D
    ld a,l
    or a
    ret nz
    inc a
lab6E9D ld (lab13F7),a
lab6EA0 ld hl,lab0089
    ld de,lab000B+1
lab6EA6 bit 5,(hl)
    ret z
    add hl,de
    djnz lab6EA6
    pop hl
    jp lab73B8
    ld b,10
    call lab6E85
    ld ix,lab0080
lab6EB9 ld b,4
lab6EBB push bc
    call lab6EDA
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab6EBB
    ld ix,lab00B0
    ld b,6
lab6ECD push bc
    call lab704A+1
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab6ECD
    ret 
lab6EDA call lab677C
    ld d,(ix+9)
    bit 5,d
    jr z,lab6EF8
    ld a,(lab13F7)
    or a
    ret nz
    call lab7194
    xor 128
    ld l,a
    ld a,r
    and 6
    or l
    ld (ix+9),a
    ret 
lab6EF8 bit 0,d
    jp nz,lab6F82
    ld a,(lab13F7)
    or a
    jr z,lab6F1A
    ld a,(labA750)
    add a,a
    jr c,lab6F0F
    bit 6,d
    jr z,lab6F13
    jr lab6F1A
lab6F0F bit 6,d
    jr z,lab6F1A
lab6F13 ld a,192
    xor d
    ld (ix+9),a
    ld d,a
lab6F1A ld hl,lab11C9
    ld a,r
    and 13
    jr nz,lab6F5C
    ld a,(labB793)
    add a,10
    ld b,a
    ld a,c
    add a,10
    sub b
    bit 6,(ix+9)
    jr z,lab6F35
    neg
lab6F35 or a
    jp p,lab6F5C
    ld hl,lab702B
    ld a,d
    and 6
    ld b,a
    srl a
    add a,b
    call labA6F8
    ld (ix+5),a
    inc hl
    ld a,(hl)
    ld (ix+6),a
    inc hl
    inc hl
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    set 0,d
    res 3,d
    ld (ix+9),d
lab6F5C ld b,123
    ld a,5
lab6F60 bit 0,(ix+9)
    jr z,lab6F67
lab6F66 xor a
lab6F67 call lab67A2
    call lab6786
    push hl
    ld d,2
    ld hl,lab1301+2
    ld a,2
    call lab6813
    call z,lab7284
    pop hl
    call lab677C
    jp lab726D
lab6F82 bit 3,d
    jr nz,lab6F98
lab6F86 ld hl,lab7041+2
    ld a,d
    and 6
    call labA6F9
    inc hl
    ld h,(hl)
    ld l,a
    set 3,(ix+9)
    jr lab6F66
lab6F98 push bc
    ld iy,lab00B0
    ld bc,lab000B+1
lab6FA0 ld a,6
lab6FA2 bit 5,(iy+9)
    jr nz,lab6FB0
    add iy,bc
    dec a
    jr nz,lab6FA2
    pop bc
    jr lab6F86
lab6FB0 ld (ix+5),3
    ld (ix+6),247
    ld hl,lab702C+1
    ld a,d
    and 6
    ld b,a
    srl a
    add a,b
    call labA6F8
    pop bc
    inc hl
    push hl
    ld h,(hl)
    ld l,a
    call lab690A
    ld (iy+0),e
    ld (iy+1),c
    ld (iy+2),b
    ld bc,lab080F+1
    call lab8E85
    call lab677C
    pop hl
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    res 0,(ix+9)
    ld a,d
    xor 128
    and 198
    ld (iy+9),a
    ld a,r
    and 7
    add a,5
    neg
    ld (iy+10),a
    ld a,r
    rra 
    rra 
    and 7
    add a,10
    ld (iy+11),a
    ld a,(labB794)
    cp 70
    jr c,lab7018
    ld a,(labA750)
    and 127
    cp 24
    jp c,lab6F66
lab7018 ld a,(iy+10)
    sub 6
    ld (iy+10),a
    ld a,(iy+11)
    sub 5
    ld (iy+11),a
    jp lab6F66
lab702B nop
lab702C or 0
lab702E rst 40
    sub 17
    nop
    or 0
    rst 40
    call po,lab0311
    jp m,labF300
    ei
    ld de,labF600
    nop
    rst 40
lab7041 call po,labCF11
    ld de,lab11DD
    call p,labEB11
lab704A ld de,lab56DD
    add hl,bc
    bit 5,d
    ret nz
    bit 0,d
    ret nz
    ld b,0
    ld a,r
    and 6
    ld a,(ix+10)
    jr z,lab7060
    inc a
lab7060 or a
    jp m,lab706C
    cp 3
    jr nc,lab7074
    ld b,8
    jr lab7074
lab706C ld b,8
    cp 254
    jr nc,lab7074
    ld b,16
lab7074 ld (ix+10),a
    add a,(ix+2)
    ld (ix+2),a
    cp 123
    jr c,lab7087
    ld a,123
    set 5,(ix+9)
lab7087 ld a,d
    and 6
    or b
    ld hl,lab70C8
    call labA6F9
    inc hl
    ld h,(hl)
    ld l,a
    call lab6768
    ld a,(ix+11)
    call lab677C
    call lab67A2
    call lab6786
    push hl
    ld hl,lab0000
    call lab692D
    pop hl
    jr nz,lab70B0
    jp lab726D
lab70B0 call lab13F8
    ld a,10
    call lab6130
    call lab6533
    ld (ix+10),1
    ld (ix+11),0
    set 0,(ix+9)
    ret 
lab70C8 ld (bc),a
    ld (de),a
    jr nz,lab70DE
    ld (bc),a
    ld (de),a
    rlca 
    ld (de),a
    inc c
    ld (de),a
    jr nz,lab70E6
    inc c
    ld (de),a
    ld de,lab1612
    ld (de),a
    jr nz,lab70EC+2
    ld d,18
lab70DE dec de
    ld (de),a
lab70E0 nop
    jr z,lab7106+2
    ld (de),a
    inc bc
    ld a,(bc)
lab70E6 ld bc,labA014
    ld (de),a
    ld (bc),a
    ld (bc),a
lab70EC call lab7342+2
    ld hl,lab70E6
    ld de,lab1B1B
    ld bc,lab8211+1
    jr lab7106
    call lab7342+2
    ld hl,lab70E0
    ld de,lab1010
lab7103 ld bc,lab8110+1
lab7106 ld (lab7142),de
    ld (lab7163+2),hl
    ld (lab1229+2),bc
    push hl
    pop iy
    ld de,lab0080
    ld a,7
lab7119 ld bc,lab000B+1
    ld hl,lab713F
    ldir
    dec a
    jr nz,lab7119
    ld a,(labB601)
    ld b,a
    add a,a
    add a,6
    ld (lab13F6),a
    ld a,b
    srl a
lab7131 add a,4
    bit 0,(iy+0)
    jr z,lab713B
    sub 2
lab713B ld (lab7154+1),a
    ret 
lab713F nop
    nop
    nop
lab7142 djnz lab7154
    nop
    nop
    nop
    nop
    jr nz,lab714A
lab714A nop
    ld b,7
    call lab6E85
    ld ix,lab0080
lab7154 ld b,5
lab7156 push bc
    call lab7163
    ld bc,lab000B+1
    add ix,bc
    pop bc
    djnz lab7156
    ret 
lab7163 ld iy,lab70E0
    ld d,(ix+9)
    call lab677C
    bit 5,d
    jr z,lab71A8
    ld a,(lab13F7)
    or a
    ret nz
    ld a,(labA750)
    and 127
    jr nz,lab717E
    inc a
lab717E ld (ix+10),a
    ld a,r
    and 31
    ld l,a
    ld a,(labB794)
    sub l
    jr nc,lab718D
    xor a
lab718D ld (ix+2),a
    ld (ix+11),0
lab7194 ld (ix+1),248
    ld a,r
    and 64
    jr z,lab71A4
    set 7,a
    ld (ix+1),40
lab71A4 ld (ix+9),a
    ret 
lab71A8 bit 4,d
    jp nz,lab7267
    bit 0,d
    jp nz,lab72AC
    ld a,(lab13F7)
    or a
    jr z,lab71C2
    ld a,(labA750)
    and 127
    add a,15
    ld (ix+10),a
lab71C2 ld a,r
    and 62
    jr nz,lab71CF
    ld a,4
    xor d
    ld d,a
    ld (ix+9),d
lab71CF bit 2,d
    jr nz,lab7226
    ld a,(labB794)
    sub (iy+1)
    jr nc,lab71DC
    xor a
lab71DC cp b
    call lab77CF
    ld a,(labA750)
    ld l,a
    xor d
    jp m,lab729D
    ld a,(ix+10)
    or a
    jr nz,lab71F5
    ld a,r
    and 6
lab71F2 jp z,lab7297
lab71F5 ld a,(labB793)
    bit 7,l
    jr nz,lab7205
    add a,11
    ld l,a
    ld a,c
    add a,10
    cp l
    jr lab720E
lab7205 add a,9
    ld l,a
    ld a,10
    add a,c
    ld h,a
    ld a,l
    cp h
lab720E jr nz,lab7221
    ex af,af''
    bit 0,(iy+0)
    jr nz,lab7220
    ld a,(labB794)
    sub 20
    cp b
    jp nc,lab72A1
lab7220 ex af,af''
lab7221 call lab77EE
    jr lab723E
lab7226 ld a,(ix+10)
    call lab67A2
    ld a,r
    and 15
    add a,15
    ld l,a
    ld a,(labB794)
    sub l
    jr nc,lab723A
    xor a
lab723A cp b
    call lab77CF
lab723E call lab6786
    bit 0,(iy+0)
    jr z,lab725B
    ld hl,labFC10
    call lab692D
    jr z,lab7258
    ld a,(iy+5)
    call lab6130
    call lab13F8
lab7258 call lab677C
lab725B ld a,(iy+4)
    call lab6838
    call z,lab7284
    call lab677C
lab7267 ld h,(iy+3)
    ld l,(iy+2)
lab726D bit 7,(ix+9)
    jr z,lab7274
    inc hl
lab7274 call lab68DC
    ld a,(ix+1)
    add a,10
    cp 52
    ret c
    set 5,(ix+9)
    ret 
lab7284 ld a,(lab13F6)
    or a
    ret z
    dec a
    ld (lab13F6),a
    ret nz
    inc a
    ld (lab13F7),a
    ld a,50
    jp lab8602
lab7297 ld (ix+10),10
    set 2,d
lab729D set 1,d
    jr lab72A3
lab72A1 res 1,d
lab72A3 set 0,d
    ld (ix+9),d
    ld (ix+11),0
lab72AC bit 1,d
    jr nz,lab72B8
    ld a,(ix+10)
    ld hl,lab7333
    jr lab72E0
lab72B8 ld a,(ix+11)
    bit 0,(iy+0)
    jr z,lab72CD
    ld hl,lab732D+1
    ld a,(ix+11)
    cp 1
    jr z,lab72D4
    jr lab72DB
lab72CD ld hl,lab7325
    cp 2
    jr nz,lab72DB
lab72D4 ld a,d
    xor 192
    ld d,a
    ld (ix+9),d
lab72DB ld a,(ix+10)
    srl a
lab72E0 call lab67A2
    ld a,(ix+11)
    inc (ix+11)
    call labA6F8
    or a
    jr nz,lab72F9
    res 0,(ix+9)
    ld (ix+11),0
    inc hl
    ld a,(hl)
lab72F9 ld (lab122E),a
    inc hl
    ld a,(hl)
    add a,b
    cp 220
    jr c,lab7304
    xor a
lab7304 cp 130
    jr c,lab730A
    ld a,130
lab730A ld b,a
    call lab6786
    ld hl,lab0000
    call lab692D
    jr z,lab731F
    ld a,(iy+5)
    call lab6130
    call lab13F8
lab731F ld hl,lab1229+2
    jp lab726D
lab7325 jr nc,lab7325
    ld sp,lab31F8
    jp m,lab3000
lab732D call m,lab0032+2
    nop
    inc (hl)
    nop
lab7333 ld hl,(lab2B02)
    dec b
    inc l
    ex af,af''
    dec l
    ex af,af''
    dec l
    ex af,af''
    ld l,4
lab733F jr nc,lab733F
    nop
lab7342 ld sp,lab3EFE
lab7345 nop
    or a
    jr nz,lab735F
    ld a,(lab2473)
    cp 2
    jr c,lab735F
    ld a,1
    ld (lab7345),a
    call lab75D9
    ld hl,lab75F6
    ld a,18
    jr lab7375
lab735F ld a,(labB600)
    cp 13
    ret nz
    ld hl,lab737E
    ld de,lab0080
    ld bc,lab0016
    ldir
    ld hl,lab7392+2
    ld a,17
lab7375 ld (lab246F+2),a
    ld (lab7AB7+1),hl
    pop hl
    ret 
    ret 
lab737E nop
    jr z,lab73FA+1
    djnz lab738B
    ex af,af''
    or 141
    ld de,lab0000
    nop
    nop
lab738B ex af,af''
    ld a,d
    dec b
    rrca 
    ld c,240
    xor a
lab7392 ld de,labDD00
    ld hl,lab0080
    ld a,(lab13F6)
    ld d,a
    set 3,d
    ld a,(lab22CE+2)
    ld e,a
    ld a,(lab22CE+1)
    cp e
    jr z,lab73C3
    bit 0,d
    jr z,lab73B8
    bit 4,d
    jr nz,lab73FA
    set 4,d
    ld a,d
    ld (lab13F6),a
    jr lab73FA
lab73B8 xor a
    ld (lab246F+2),a
    ld hl,lab2422
    ld (lab7AB7+1),hl
    ret 
lab73C3 ld b,d
    ld de,lab0C90
    call lab689F
    ld d,b
    jr c,lab73FA
    ld b,123
    ld a,(lab13E5)
    bit 1,a
    ld hl,lab0508+2
    jr z,lab73DB
    ld h,133
lab73DB bit 2,d
    jr z,lab73E8
    ld hl,lab050C-1
    bit 1,d
    jr z,lab73E8
    ld l,0
lab73E8 ld (lab1176),hl
    ld hl,lab1170
    push ix
    push de
    ld a,e
    call lab1446
    pop de
    pop ix
    res 3,d
lab73FA bit 1,d
    jp nz,lab7496
    bit 2,d
    jp z,lab7496
    bit 6,d
    jr nz,lab7447
    bit 3,d
    jp nz,lab7496
    ld a,(lab0117)
    rra 
    jp c,lab7496
    ld a,(lab13A8)
    cp 4
    jr z,lab7425
    jr c,lab741F
    dec a
    dec a
lab741F inc a
    ld (lab13A8),a
    jr lab7496
lab7425 set 6,d
    ld a,9
    ld (lab13AA),a
    ld a,82
    ld (lab13AD+1),a
    ld a,8
    ld (lab13B0),a
    ld a,37
    ld (lab13B4),a
    ld a,10
    ld (lab13B6),a
lab7440 ld a,168
    ld (lab1052),a
    jr lab7496
lab7447 ld a,(lab0117)
    rra 
    jr c,lab7481
    bit 1,a
    jr nz,lab7481
    bit 3,d
    jr nz,lab7481
    push de
    call lab08DC
    call lab68C0
    ld de,lab0B84
    ld a,(lab13F2+1)
    add a,a
    jr nc,lab7468
    ld de,lab0C0E
lab7468 or a
    sbc hl,de
    pop de
    jr c,lab7496
    ld a,l
    cp 4
    jr nc,lab7496
    set 1,d
    xor a
    ld (labB600),a
    push bc
    ld bc,lab2800
    call lab8E85
    pop bc
lab7481 ld a,1
    ld (lab13AA),a
    ld a,11
    ld (lab13AD+1),a
    xor a
    ld (lab13B0),a
    ld a,2
    ld (lab13B6),a
    res 6,d
lab7496 ld a,d
    ld (lab13F6),a
    call lab677C
    bit 0,d
    jr nz,lab74D5
    ld a,d
    and 12
    ret nz
    ld a,(lab0117)
    bit 0,a
    ret nz
    ld a,(labB601)
    ld l,a
    ld a,(lab2473)
    add a,l
    add a,10
    ld (ix+9),128
    ld (ix+21),128
    bit 7,c
    jr nz,lab74CB
    neg
    ld (ix+9),64
    ld (ix+21),64
lab74CB ld (lab74DC+1),a
    set 0,d
    ld a,d
    ld (lab13F6),a
    ret 
lab74D5 ld a,(lab0102)
    bit 4,d
    jr nz,lab74DE
lab74DC add a,246
lab74DE call lab6790
    ld a,c
    add a,10
    cp 52
    jr c,lab74EF
    ld a,d
    and 110
    ld (lab13F6),a
    ret 
lab74EF call lab6786
    bit 5,d
    jr nz,lab7533
    bit 2,d
    jr z,lab751C
    call lab6683
    jr z,lab7507
    set 4,(ix+9)
    ld (ix+11),0
lab7507 push de
    call lab67CA
    pop de
    jr z,lab751C
    set 5,d
    push de
    ld d,28
    ld hl,lab1AF8
    call lab085A
    pop de
    jr lab7533
lab751C ld hl,lab1184+2
    bit 4,d
    jr nz,lab7529
    ld hl,lab1179
    call lab75AC
lab7529 call lab677C
    call lab75C1
    jr nz,lab7533
    set 5,d
lab7533 ld ix,lab008B+1
    call lab6786
    ld a,d
    ld (lab13F6),a
    bit 2,d
    ret nz
    push de
    bit 7,d
    jr nz,lab7565
    ld hl,labEEEC
    call lab692D
    jr z,lab7565
    ld b,5
lab7550 ld a,148
    call lab6130
    djnz lab7550
    ld b,(ix+2)
    call lab13F8
    pop de
    set 7,d
    ld a,d
    ld (lab13F6),a
    push de
lab7565 call lab6683
    jr z,lab757A
    set 4,(ix+9)
    ld (ix+11),0
    set 4,(ix-3)
    ld (ix-1),0
lab757A call lab67CA
    pop de
    jr z,lab7594
    set 2,d
    ld a,10
    call lab8602
    ld a,d
    ld (lab13F6),a
    ld d,2
    ld hl,lab1301+2
    call lab085A
    ret 
lab7594 call lab677C
    ld hl,lab117D+2
    call lab75C1
    ret nz
    set 5,d
    set 2,d
    ld a,d
    ld (lab13F6),a
    ld a,20
    call lab8602
    ret 
lab75AC ld a,(lab13E5)
    neg
    and 3
    ret z
    srl a
    ld bc,lab01FE+2
    srl a
    rr c
    inc a
    jp lab8E4F
lab75C1 bit 7,(ix+9)
    jr z,lab75C8
    inc hl
lab75C8 push de
    push bc
    push ix
    push iy
    ld a,e
    call lab68DC
    pop iy
    pop ix
    pop bc
    pop de
    ret 
lab75D9 ld a,32
    ld (lab75F2+1),a
    ld a,(labB601)
    add a,a
    add a,a
    add a,8
    ld (lab75E9),a
    ret 
lab75E9 ld bc,lab0000
    rst 56
    ld b,b
    ld a,(bc)
    call p,lab42F8
lab75F2 ld de,lab0000
    nop
lab75F6 ld iy,lab1140+1
    ld ix,lab75E9+1
    call lab677C
    ld d,(ix+9)
    bit 5,d
    jp nz,lab7794
    ld a,r
    and 60
    jr nz,lab7613
    ld a,4
    xor d
    ld d,a
lab7613 bit 1,d
    jr z,lab761F
    ld a,r
    and 63
    add a,20
    jr lab7635
lab761F ld a,(labB794)
    bit 2,d
    jr nz,lab762D
    sub 30
    jr nc,lab7635
    xor a
    jr lab7635
lab762D add a,50
    cp 106
    jr c,lab7635
    ld a,100
lab7635 bit 4,d
    jr nz,lab763D
    cp b
    call lab77CF
lab763D ld a,c
    add a,10
    ld l,a
    bit 1,d
    jr z,lab764F
    ld a,53
    bit 6,d
    jr z,lab766F
    ld a,0
    jr lab767B
lab764F ld a,(ix+10)
    or a
    jr z,lab765B
    ld a,r
    and 127
    jr nz,lab765D
lab765B set 1,d
lab765D ld a,(labA750)
    bit 7,a
    ld a,(labB793)
    jr nz,lab7673
    bit 6,d
    jr z,lab766D
    set 1,d
lab766D add a,3
lab766F cp l
lab7670 ccf 
    jr lab767C
lab7673 bit 6,d
    jr nz,lab7679
    set 1,d
lab7679 add a,17
lab767B cp l
lab767C call lab77EE
    ld a,16
    ld (lab1493+1),a
    ld (ix+9),d
    call lab6786
    bit 3,(iy+14)
    jr z,lab76BB
    ld a,r
    and 4
    jr nz,lab76E8
    ld a,(labB794)
    ld (iy+13),13
    cp b
    ld a,170
    ld (iy+13),13
    jr nc,lab76AC
    ld a,172
    ld (iy+13),77
lab76AC cp (iy+9)
    jr nz,lab76E8
    res 3,(iy+14)
    set 3,(iy+11)
    jr lab76E8
lab76BB ld hl,lab125C
    bit 6,(iy+26)
    jr z,lab76C6
    ld h,203
lab76C6 call lab692D
    jr z,lab76D3
    ld a,168
    call lab6130
    call lab13F8
lab76D3 call lab677C
    ld a,r
    and 22
    jr nz,lab76E8
    set 3,(iy+14)
    ld (iy+12),83
    res 3,(iy+11)
lab76E8 bit 3,(iy+27)
    jr z,lab7705
    ld a,r
    and 8
    jr nz,lab772A
    ld a,(iy+22)
    cp 175
    jr nz,lab772A
    set 3,(iy+24)
    res 3,(iy+27)
    jr lab772A
lab7705 ld hl,labF762
    call lab692D
    jr z,lab7715
    ld a,158
    call lab6130
    call lab13F8
lab7715 call lab677C
    ld a,r
    and 98
    jr nz,lab772A
    res 3,(iy+24)
    set 3,(iy+27)
    ld (iy+25),72
lab772A call lab7B34
    call lab67B4
    jr z,lab7751
    ld a,8
    call labB671
    ld bc,lab1000
    ld a,3
    call lab8E4F
    ld a,3
    call lab8602
    dec (ix-1)
    jr nz,lab7751
    set 4,(ix+9)
    ld (ix+11),0
lab7751 call lab677C
    call lab6683
    jr z,lab7776
    call lab13F8
    ld a,12
    call lab8602
    ld a,(ix-1)
    sub 5
    ld (ix-1),a
    jr nc,lab7773
    set 4,(ix+9)
    ld (ix+11),0
lab7773 inc (ix-1)
lab7776 call lab677C
    call lab675B
    call lab68DC
    ld a,15
    ld (lab1493+1),a
    call lab7B39
    ld a,(ix+1)
    add a,10
    cp 52
    ret c
    set 5,(ix+9)
    ret 
lab7794 bit 4,d
    jp nz,lab73B8
    ld a,r
    and 6
    ret nz
    ld a,(labA750)
    ld e,a
    and 127
    ld (ix+10),a
    ld a,(labB794)
    sub 10
    ld (ix+2),a
    bit 7,c
    jr nz,lab77BF
    ld (ix+1),40
    ld d,192
    bit 7,e
    jr z,lab77C9
    jr lab77CB
lab77BF ld (ix+1),248
    ld d,0
    bit 7,e
    jr z,lab77CB
lab77C9 set 1,d
lab77CB ld (ix+9),d
    ret 
lab77CF ld a,(ix+11)
    jr c,lab77E2
    cp 4
    jr z,lab77D9
    inc a
lab77D9 ld (ix+11),a
    add a,b
    cp 112
    ret nc
    ld b,a
    ret 
lab77E2 cp 252
    jr z,lab77E7
    dec a
lab77E7 ld (ix+11),a
    add a,b
    ret m
    ld b,a
    ret 
lab77EE ld a,(ix+10)
    jr c,lab77FE
    or a
    jr z,lab7810
    dec a
    cp 20
    jr c,lab7810
    dec a
    jr lab7810
lab77FE ld l,a
lab77FF ld a,(labA750)
    and 127
    add a,5
    cp l
    ld a,l
    jr z,lab7810
    inc a
    cp 25
    jr nc,lab7810
    inc a
lab7810 ld (ix+10),a
    call lab67A2
    ret 
    ld a,c
    add a,9
    cp 52
    ret c
    ld b,255
    ret 
    ld de,lab0080
    ld a,6
lab7825 ld bc,lab000B+1
    ld hl,lab783B
    ldir
    dec a
    jr nz,lab7825
    ld a,(labB601)
    add a,a
    add a,a
    add a,30
    ld (lab13F6),a
    ret 
lab783B nop
    nop
    nop
    dec bc
    inc b
    ld (bc),a
    call m,lab1135
    jr nc,lab7846
lab7846 nop
    ld a,(lab2472)
    or a
    jr z,lab7855
    ld a,(lab6532)
    or a
    jp z,lab73B8
    ret 
lab7855 ld a,(lab6532)
    cp 6
    jr nc,lab78A8
    ld a,r
    and 64
    jr z,lab78A8
    ld a,(lab0117)
    rra 
    jr c,lab786F
    ld a,(labA750)
lab786B and 127
    jr z,lab78A8
lab786F ld ix,lab0080
    ld de,lab000B+1
lab7876 bit 5,(ix+9)
    jr nz,lab7880
    add ix,de
    jr lab7876
lab7880 ld (ix+2),0
    ld (ix+10),1
    ld (ix+9),0
    ld a,r
    and 31
    ld (ix+1),a
    call lab6533
    ld a,(lab13F6)
    dec a
    ld (lab13F6),a
    jr nz,lab78A8
    ld a,5
    ld (lab2472),a
    call lab8602
    ret 
lab78A8 ld ix,labB792
    call lab6683
    ret z
    ld a,(lab0116)
    add a,2
    cp 5
    jr c,lab78BB
    ld a,4
lab78BB ld (lab0116),a
    ld a,(lab0117+1)
    sub 3
    cp 253
    jr nc,lab78C9
    ld a,253
lab78C9 ld (lab0117+1),a
    call lab13F8
    ld a,12
    jp lab6130
lab78D4 di
    ld hl,lab7B40
    ld b,9
    call lab8E00
    call lab248A
    xor a
    ld (lab7345),a
    ld (labA750),a
    ld (lab22CE+1),a
    ld (lab13F2+1),a
    inc a
    ld (lab22CE),a
    ld a,157
    ld (lab13F4),a
    ld hl,lab4455
    ld (lab8EB3+1),hl
    ld a,(labB601)
    ld b,a
    srl b
    add a,b
    add a,a
    add a,a
    add a,a
    and 240
    ld c,a
    ld b,8
    ld hl,lab0C9E
    ld de,lab0003+1
lab7911 ld a,(hl)
    and 15
    or c
    ld (hl),a
    add hl,de
    djnz lab7911
    call lab61B7
    ld a,32
    ld (lab010D+1),a
    ld a,(lab0117)
    and 11
    ld (lab0117),a
    ld hl,lab139B
    ld (labB799),hl
    call lab643F
    call lab22D1
    call lab73B8
    ld b,8
    ld hl,lab8400
    ld de,labC400
lab7940 push bc
    ld bc,lab01FE+2
    ldir
    ld bc,lab0600
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl
    pop bc
    djnz lab7940
    ld hl,lab8000
    ld b,0
lab7955 ld (hl),0
    inc hl
    djnz lab7955
    ld hl,lab0000
    ld (labBE06+2),hl
    ld a,l
    call lab8602
    xor a
    ld (lab6532),a
    ld (labB600),a
    ld a,(labB79B)
    and 15
    ld (labB79B),a
    ld a,255
    ld (lab6155+1),a
    xor a
    call lab6151
    ld hl,lab652F
    ld (lab6530),hl
    ld a,10
    ld (labB793),a
    ld hl,lab7B33
    ld (lab7ABA+1),hl
    ld hl,labAF55
    ld (lab0038+1),hl
    ei
lab7994 call lab7A57
    ld a,(labB79B)
    ld bc,lab2001
    bit 5,a
    jr nz,lab79B0
    ld a,(lab61B3+1)
    inc c
    bit 5,a
    jr nz,lab79B0
    ld a,(lab61A9)
    inc c
    or a
    jr z,lab7994
lab79B0 push bc
    call lab7A57
    pop bc
    djnz lab79B0
    push bc
lab79B8 call lab7A57
lab79BB ld a,(labAF6A+1)
    or a
    jr nz,lab79BB
    ld a,(SCREEN_BUFFER)
    bit 6,a
    jr nz,lab79B8
    call lab9600
    pop bc
    dec c
    jp z,lab7A56
    push bc
    ld hl,lab0402
    call labBE0A
    pop bc
    dec c
    jr nz,lab7A13
    call lab8752
    add a,c
    ld d,226
    add a,d
    rst 56
    ret p
    add a,h
    nop
    ld b,c
    ld c,h
    ld c,h
    jr nz,lab7A34
    ld d,e
    jr nz,lab7A39+1
    ld c,a
    ld d,e
    ld d,h
    add a,c
    call nz,lab54E3
    ld c,b
    ld b,l
    jr nz,lab7A4C
    ld c,a
    ld d,d
lab79FB ld b,e
    ld b,l
    ld d,d
    ld b,l
    ld d,e
    ld d,e
    jr nz,lab7A4B
    ld b,c
    ld d,e
    jr nz,lab7A49
    ld b,l
    ld b,l
    ld c,(hl)
    jr nz,lab7A5E+1
    ld c,h
    ld b,c
    ld c,c
    ld c,(hl)
    add a,b
    jr lab7A4E
lab7A13 call lab8752
    add a,c
    djnz lab79FB
    add a,d
    rrca 
    ret p
    add a,h
    nop
    ld c,b
    ld b,c
    ld c,c
    ld c,h
    jr nz,lab7A70+1
    ld c,c
    ld b,a
    ld c,b
    ld d,h
    ld e,c
    jr nz,lab7A7A
    ld c,(hl)
    ld b,l
    add a,c
    jp nz,lab54E3
    ld c,b
    ld c,a
    ld d,l
lab7A34 jr nz,lab7A7D+1
    ld b,c
    ld d,e
    ld d,h
lab7A39 jr nz,lab7A8E+1
    ld c,b
    ld e,c
    jr nz,lab7A8E+2
    ld d,l
    ld b,l
    ld d,e
    ld d,h
    jr nz,lab7A88
    ld c,a
    ld c,l
    ld d,b
    ld c,h
lab7A49 ld b,l
    ld d,h
lab7A4B ld b,l
lab7A4C ld b,h
    add a,b
lab7A4E ld de,lab594B
    ld c,76
lab7A53 call labBF5A
lab7A56 ret 
lab7A57 ld a,(lab13E5)
    inc a
    ld (lab13E5),a
lab7A5E call lab1BAB
    call lab011A
    call lab0901
    call labB602
    ld a,(lab13F2+1)
    ld e,a
    ld d,0
lab7A70 ld hl,(lab8FFA)
    bit 7,a
lab7A75 jr z,lab7A8D
    and 127
    ld e,a
lab7A7A or a
    sbc hl,de
lab7A7D ld (lab8FFA),hl
    ld de,lab05E0
    or a
    sbc hl,de
    jr nc,lab7AA3
lab7A88 ld de,lab11A0
    jr lab7A9C
lab7A8D add hl,de
lab7A8E ld (lab8FFA),hl
    ld de,lab11A0
    or a
    sbc hl,de
    jr c,lab7AA3
    ld de,lab05E0
lab7A9C add hl,de
    ld (lab8FFA),hl
    call lab22D1
lab7AA3 call lab8EC3
    call lab1BBB
    ld a,15
    ld (lab1493+1),a
    call lab1C3E
    call lab7B39
    call lab61E9
lab7AB7 call lab7B33
lab7ABA call lab7B33
    ld a,16
    ld (lab1493+1),a
    call lab7B34
    call lab6706
    call lab6551
    ld a,124
    call lab1BA3
    ld ix,labB792
    call lab676F
    ld a,(lab0117)
    add a,a
    jr nc,lab7AFE
    push ix
    push de
    push bc
    push hl
    ld ix,lab0105
    ld hl,(lab0114)
    call lab6907
    call lab675B
    call lab666B
    ld a,e
    call lab1446
    call lab7B34
    pop hl
    pop bc
    pop de
    pop ix
lab7AFE call lab68DC
    call lab1BA1
    ld a,1
    ld (labAF6A+1),a
    call labA7CA
    ret nz
    ld b,127
    ld a,16
    out (c),a
    ld a,68
    out (c),a
lab7B17 halt
    call labA7CA
    jr z,lab7B17
lab7B1D halt
    call labA7CA
    jr nz,lab7B1D
lab7B23 halt
    call labA7CA
    jr z,lab7B23
    ld b,127
    ld a,16
    out (c),a
    ld a,84
    out (c),a
lab7B33 ret 
lab7B34 ld hl,lab0B18
    jr lab7B3C
lab7B39 ld hl,lab0C00
lab7B3C ld (lab1534+1),hl
    ret 
lab7B40 nop
    nop
    ld bc,lab0700
    ld l,8
    nop
    add hl,bc
    djnz lab7B55
    nop
    ld b,31
    dec bc
    ld h,h
    inc c
    nop
lab7B52 rst 56
    rst 56
    nop
lab7B55 rst 56
    rst 56
    jr nz,lab7B79
    jr nz,lab7B7B
    jr nz,lab7B7B+2
    jr nz,lab7B7F
    jr nz,lab7B7F+2
    jr nz,lab7B83
    nop
    nop
    nop
    nop
    nop
    nop
    ld hl,lab0000
    call labA776
lab7B6F ld hl,(labA751)
    ld a,(labB79B)
    bit 4,a
    jr z,lab7B7B
lab7B79 ld l,0
lab7B7B ld ix,lab13A8
lab7B7F ld a,(lab0117)
    ld e,a
lab7B83 res 6,e
    ld a,(lab0117+2)
    cp 6
    jr nz,lab7B97
    push hl
    ld hl,(lab2474)
    bit 2,(hl)
    pop hl
    jr nz,lab7B97
    set 6,e
lab7B97 bit 2,e
    jp nz,lab074D
    ld a,l
    and 19
    cp 18
    jp z,lab0700
    bit 6,e
    jr z,lab7BCA
    bit 0,e
    jr z,lab7BCA
    ld a,(labA750)
    add a,a
    jr c,lab7BCA
    push hl
    ld hl,(lab8FFA)
    ld a,(labB793)
    add a,a
    add a,a
    add a,a
    add a,l
    ld l,a
    jr nc,lab7BC1
    inc h
lab7BC1 ld bc,lab097F+1
    sbc hl,bc
    pop hl
    jp nc,lab0700
lab7BCA ld a,(lab13F4)
    cp 154
    jr nz,lab7BDA
    ld a,(labA750)
    add a,a
    jp c,lab0700
    jr lab7BE5
lab7BDA cp 188
    jr nz,lab7BE5
    ld a,(labA750)
    add a,a
    jp nc,lab0700
lab7BE5 call lab0607+1
    bit 4,l
    jp z,lab02AB
    bit 7,e
    call nz,lab08A2
    bit 3,e
    jr nz,lab7C37
    ld a,(labB600)
    cp 13
lab7BFB jp z,lab02AB
    call lab8E3A
    ld bc,lab0407+2
    set 3,(ix+2)
    set 3,(ix+14)
    ld (ix+12),37
lab7C10 set 3,(ix+8)
    ld (ix+6),82
    res 3,(ix+17)
    ld (ix+15),71
    ld a,(ix+0)
    ld c,a
    ld b,16
    ld a,(bc)
    ld (ix+0),80
    ld (lab1050),a
    ld a,133
    ld (lab1052),a
    set 3,e
    jr lab7CA5
lab7C37 ld a,(labB600)
    cp 13
    jp z,lab02AB
    call lab8E3A
    ld bc,lab09A8+1
    ld a,1
    call labB671
    bit 0,e
    jr nz,lab7C53
    ld a,254
    call lab6151
lab7C53 ld b,130
    bit 3,l
    jr z,lab7C6B
    res 3,l
    bit 4,e
    jr z,lab7C63
    bit 2,l
    jr nz,lab7C6B
lab7C63 ld b,128
    bit 2,l
    jr z,lab7C6B
    ld b,132
lab7C6B ld a,(lab1050)
    cp b
    jr z,lab7C76
    jr nc,lab7C75
    inc a
    inc a
lab7C75 dec a
lab7C76 ld (lab1050),a
    cp 130
    jr z,lab7C8F
    jr c,lab7C85
    ld a,168
    ld b,84
    jr lab7C93
lab7C85 ld a,170
    ld b,84
    set 6,(ix+16)
    jr lab7C97
lab7C8F ld a,133
    ld b,73
lab7C93 res 6,(ix+16)
lab7C97 ld c,a
    ld a,(lab1052)
    cp c
    jr z,lab7CA5
    ld a,c
    ld (ix+15),b
    ld (lab1052),a
lab7CA5 ld a,(lab13B7)
    exx
    ld l,a
    call lab08DC
    ld a,(lab13B8)
    push ix
    ld ix,labB792
    call lab0270
    pop ix
    ld (lab0103),bc
lab7CBF exx
    jr lab7D04
    ld h,16
    ex af,af''
    ld a,(hl)
    sub 177
    cp 6
    jr nc,lab7CFA
    ld hl,lab08E5
    call labA6F8
    bit 7,(ix+9)
    jr z,lab7CDA
    neg
lab7CDA call lab6790
    ld a,c
    cp 32
    jr nc,lab7CFA
    add a,a
    add a,a
    add a,a
    or e
    ld c,a
    inc hl
    ex af,af''
    bit 6,a
    ld a,(hl)
    jr z,lab7CF2
    neg
    add a,224
lab7CF2 add a,b
    cp 124
    ld b,a
    ret c
    ld b,124
    ret 
lab7CFA ld b,255
    ret 
    bit 3,e
    jr z,lab7D04
    call lab047C
lab7D04 ld a,(labB79B)
    bit 4,a
    jr nz,lab7D28
    bit 3,e
    jr nz,lab7D28
    bit 0,e
    jr z,lab7D24
lab7D13 ld a,(ix+32)
    cp 17
    jr nz,lab7D28
    call lab8E3A
    ld (bc),a
    add hl,bc
    djnz lab7D2D+1
    inc b
    jr lab7D28
lab7D24 bit 1,e
    jr nz,lab7D13
lab7D28 bit 0,e
    jp z,lab04B0
lab7D2D ld a,(lab0116)
    ld c,a
    bit 3,l
    jr z,lab7D40
    bit 2,l
    jr z,lab7D4A
    cp 4
    jr z,lab7D50
    inc a
    jr lab7D4F
lab7D40 or a
    jr z,lab7D50
    bit 7,a
    jr z,lab7D4E
    inc a
    jr lab7D4F
lab7D4A cp 252
    jr z,lab7D50
lab7D4E dec a
lab7D4F ld c,a
lab7D50 ld a,(labB794)
    add a,c
    ld b,a
    ld a,(labA750)
    add a,a
    bit 7,e
    jr z,lab7D61
    cp 40
    jr lab7D63
lab7D61 cp 16
lab7D63 ld a,b
    jr nc,lab7D67
    inc a
lab7D67 cp 28
    jr nc,lab7D6F
    ld a,28
    ld c,0
lab7D6F bit 7,e
    jr z,lab7DA5
    ex af,af''
    ld a,(labB79B)
    bit 4,a
    jr nz,lab7D96
    ld a,(lab010B+1)
    cp 104
    jr nz,lab7D99
    ld a,(lab010D)
    cp 18
    jr nz,lab7D99
    ex af,af''
    cp 70
    jr c,lab7DA2
    ex af,af''
    ld a,(lab0117+2)
    cp 1
    jr z,lab7D99
lab7D96 ex af,af''
    jr lab7DA2
lab7D99 ld a,(lab0111)
    ld b,a
    ex af,af''
    cp b
    jp c,lab03CE
lab7DA2 call lab08A2
lab7DA5 cp 90
    jr c,lab7E05
    bit 1,e
    jr nz,lab7DC7
    set 1,e
    res 3,(ix+24)
    ld (ix+19),98
    res 2,(ix+21)
    ld (ix-10),54
    ld (ix-5),6
    ld (ix-4),154
lab7DC7 cp 115
    jr c,lab7E1B
    ex af,af''
    ld a,(labB793)
    call lab07FE
    jr nz,lab7DE0
    ex af,af''
    jr z,lab7E1B
    call lab07ED
    cp b
    jr c,lab7E20
    ld a,b
    jr lab7DE2
lab7DE0 ld a,115
lab7DE2 ex af,af''
    res 0,e
    ld (ix-4),153
    ld (ix+22),138
    set 3,(ix+24)
    ld (ix-10),95
    ld (ix+19),92
    res 2,(ix-5)
    call lab0569
    ex af,af''
    ld c,0
    jr lab7E20
lab7E05 bit 1,e
    jr z,lab7E20
    cp 80
    jr nc,lab7E20
    res 1,e
    ld (ix+19),109
    ld (ix+22),128
    ld (ix+21),6
lab7E1B bit 4,e
lab7E1D call nz,lab07F7
lab7E20 ld (labB794),a
    ld a,e
    ld (lab0117),a
    ld a,c
    ld (lab0116),a
    ld a,(labA750)
    bit 4,e
    jr z,lab7E36
    sra a
    and 191
lab7E36 ld (lab13F2+1),a
    and 56
    cp 32
    jr c,lab7E41
    ld a,24
lab7E41 ld hl,lab0689
    add a,l
    ld l,a
    jr nc,lab7E49
    inc h
lab7E49 ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld (lab1021),de
    ld a,(lab0117)
    bit 5,a
    jr z,lab7E61
    push hl
    ld hl,lab3636
    add hl,de
    ld (lab1097),hl
    pop hl
lab7E61 ld de,lab1012
    call lab067C
    ld de,lab101A
    call lab067C
    ld a,(lab13F2+1)
    rra 
    rra 
    bit 5,a
    jr z,lab7E7C
    and 15
    add a,22
    jr lab7ECA
lab7E7C push af
    ld a,(lab0117)
    bit 6,a
    jr z,lab7EC3
    rra 
    jr c,lab7EC3
    ld hl,(lab8FFA)
    ld de,lab09A8
    or a
    sbc hl,de
    jr c,lab7EC3
    ld (lab8FFA),de
    pop af
    call lab08DC
    ld a,(labA750)
    cp 10
    jr c,lab7EA3
    ld a,8
lab7EA3 ld d,a
    ld a,16
    cp c
    ld a,d
    jr nc,lab7EAB
lab7EAA xor a
lab7EAB ld (labA750),a
    srl a
    srl a
    and 2
    call lab6790
    ld (labB792),a
    ld a,c
    ld (labB793),a
    xor a
    ld (lab13F2+1),a
    ret 
lab7EC3 pop af
    and 15
    neg
    add a,10
lab7ECA call lab06A9
    ret 
    call lab8E3A
    ld bc,lab1009
    res 3,(ix+2)
    res 3,(ix+14)
    res 3,(ix+8)
lab7EE0 set 3,(ix+17)
    ld (ix+6),11
    ld a,(lab1050)
    add a,128
    bit 4,e
    jr z,lab7EF3
    ld a,7
lab7EF3 ld (ix+0),a
    ld (ix+15),37
    ld a,255
    ld (lab0104),a
lab7EFF res 3,e
    ret 
    bit 3,l
    jr z,lab7F4E
    bit 2,l
    jr nz,lab7F4E
    bit 1,e
    jr nz,lab7F22
    ld (ix+32),17
    ld (ix+34),2
    ld (ix+35),25
    ld (ix+37),2
lab7F1E set 1,e
    jr lab7F64
lab7F22 ld a,(ix+19)
    cp 92
    jr nz,lab7F64
    ld a,(labA750)
    and 127
    cp 8
    jr c,lab7F64
    set 0,e
lab7F34 ld (ix+19),100
    ld (ix-10),54
    ld (ix-5),6
    ld (ix-4),154
    ld (ix+22),106
    ld (ix+24),2
    jr lab7F64
lab7F4E bit 1,e
    jr z,lab7F64
    ld (ix+32),139
    ld (ix+34),6
    ld (ix+35),144
    ld (ix+37),6
    res 1,e
lab7F64 ld a,(labB793)
    call lab07FE
    jr z,lab7F71
    call lab07F7
    jr lab7F74
lab7F71 call lab07ED
lab7F74 ld a,e
    ld (lab0117),a
    ld a,(ix+19)
    cp 92
    call z,lab0569
    ld hl,(lab0565)
    ld a,(hl)
    cp 32
    jr nz,lab7F8C
lab7F88 ld hl,(lab0567)
    ld a,(hl)
lab7F8C add a,b
    ld (labB794),a
    inc hl
    ld b,(hl)
    inc hl
    ld (lab0565),hl
    ld a,(labA750)
    and 128
    or b
    ld (lab13F2+1),a
    ld a,(lab0117)
    ld e,a
    ld a,(labA750)
    sra a
    sra a
    and 159
    bit 0,e
    jp z,lab041E
    ld (labA750),a
    jp lab041E
    nop
    nop
    nop
    nop
    push de
    ld a,(labA750)
    rra 
    rra 
    and 14
    cp 10
    jr c,lab7FC9
    ld a,8
lab7FC9 ld hl,lab8D8C
    or a
    jr nz,lab7FDA
    set 3,(ix+21)
    set 3,(ix-5)
    inc l
    jr lab7FE2
lab7FDA res 3,(ix+21)
lab7FDE res 3,(ix-5)
lab7FE2 ld (lab1021),hl
lab7FE5 bit 5,e
    jr z,lab7FF0
    ld de,lab3636
    add hl,de
    ld (lab1097),hl
lab7FF0 ld hl,lab05C4
    add a,l
    ld l,a
    jr nc,lab7FF8
    inc h
lab7FF8 ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,lab105B
    push bc
lab8000 nop
lab8001 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8018 nop
lab8019 nop
    nop
lab801B nop
    nop
lab801D nop
lab801E ld (hl),45
lab8020 dec de
lab8021 nop
lab8022 ld (bc),a
    inc b
    nop
    ld a,(bc)
    inc d
    add a,b
    add a,b
    add a,b
    exx
    rst 40
    dec c
    or 246
    rst 48
    nop
    nop
    nop
lab8033 ld bc,lab0101
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0101
lab803F nop
    nop
    nop
    inc bc
    inc c
    rrca 
    rrca 
    rrca 
lab8047 rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    ld bc,lab0F0D
    rrca 
    rrca 
    dec bc
    ex af,af''
    rrca 
    ex af,af''
    nop
    ret nz
    jr nc,lab8019
lab8059 ret p
    ret p
    jr nc,lab806B+2
    ld b,b
    ld (hl),b
lab805F djnz lab8021
    ret nz
    ld h,b
    jr nc,lab7FE5
    ret po
    jr nc,lab8018
    ret nz
    jr nc,lab806B
lab806B ld bc,lab010F
    dec c
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    inc c
    nop
lab807F nop
lab8080 nop
lab8081 ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab808A nop
    rlca 
lab808C rlca 
lab808D ld bc,lab0D0D
    dec bc
    ex af,af''
    ld c,15
    dec bc
    ex af,af''
    nop
lab8097 djnz lab8059
    ret po
    jr nc,lab80DC
    nop
    djnz lab809F
lab809F nop
    add a,b
    nop
    djnz lab8033+1
    nop
    djnz lab8047
    ret po
    jr nc,lab808A
    ld bc,lab0F0D
    rlca 
    ld bc,lab0B0D
    dec bc
    ex af,af''
    ld c,14
    nop
    ld (bc),a
    ld bc,lab0F0F
    nop
    ex af,af''
    nop
    rlca 
    rlca 
    nop
lab80C0 rlca 
    ld b,0
    nop
    ld d,l
    rst 56
    xor 170
    rst 56
    rst 56
    adc a,b
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    nop
    nop
lab80DC nop
    nop
    nop
    nop
lab80E0 nop
    nop
    nop
    nop
    nop
    nop
    dec c
    inc c
    ret p
lab80E9 ld bc,lab0C0D
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    ret nc
    jr nc,lab80E9
lab80F9 ret p
    sub b
    ld h,b
    nop
lab80FD nop
lab80FE ld b,14
lab8100 ld c,12
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    rst 56
lab8108 rst 56
    rst 56
    xor d
    nop
    nop
    inc bc
    dec bc
    ex af,af''
lab8110 ld c,14
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ld bc,lab0F0D
    dec c
    inc c
    nop
    nop
    nop
lab812E rlca 
    rlca 
lab8130 ld bc,lab0C0D
    nop
    nop
    nop
    nop
    ret nc
    ld (hl),b
    ret p
    ld h,b
    nop
    nop
    nop
    inc bc
    rlca 
    rlca 
    ld b,0
    nop
    nop
    ld de,labFF76+1
    rst 56
    call z,lab0000
    inc bc
    dec bc
    add hl,bc
    rlca 
    ld (bc),a
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    inc b
    ld c,9
    dec c
    inc c
    nop
    nop
    nop
    nop
    ld (hl),b
    ret nz
    nop
    nop
    nop
    nop
lab817E ld b,14
lab8180 ld bc,lab0C0D
    nop
    nop
    nop
    nop
    ld de,lab0000
    nop
    inc bc
    dec bc
    ex af,af''
    rrca 
    rlca 
    rlca 
    ld bc,lab0D0D
    dec c
    inc c
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    nop
    inc bc
    dec bc
    dec bc
    dec bc
    ex af,af''
    ld c,14
    rrca 
    ld bc,lab0C0D
    nop
    nop
    nop
lab81B8 ld bc,lab0008
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    rrca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    ld c,14
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    rlca 
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    ld (bc),a
    nop
    nop
    ld bc,lab0F0E
    nop
    nop
    nop
    nop
    push hl
    push de
    push bc
    push iy
    ld hl,(labBE06+2)
    ld e,a
    ld d,0
    add hl,de
    ld (labBE06+2),hl
lab8211 ld de,labBD1A
    call lab8626
    ld de,labFD1A
    ld hl,(labBE06+2)
    call lab8626
    pop iy
    pop bc
    pop de
    pop hl
    ret 
    push de
    ld iy,lab8651
lab822B ld e,(iy+0)
    ld d,(iy+1)
    bit 7,d
    jr nz,lab824F
    ld bc,labFF00
lab8238 inc b
    or a
    sbc hl,de
    jr nc,lab8238
    add hl,de
    inc iy
    inc iy
    ld a,b
    ex (sp),hl
    push hl
    call lab865D
    pop hl
    inc l
    inc l
    ex (sp),hl
    jr lab822B
lab824F pop bc
    ret 
    djnz lab8278+2
    ret pe
    inc bc
    ld h,h
    nop
    ld a,(bc)
    nop
    ld bc,labFF00
    rst 56
    push hl
    ld hl,labFE5D
    ld e,a
    ld d,0
    ld b,9
lab8266 add hl,de
    djnz lab8266
    ex de,hl
    pop hl
    ld b,5
    ld a,(lab8601)
    call lab8678
    ld b,4
    ld a,(lab8600)
lab8278 ld (lab86C3+1),a
    ld (lab86D1+1),a
lab827E call lab868A
lab8281 bit 0,c
    call nz,lab868A
    inc de
    djnz lab827E
    ret 
    ld a,(de)
    bit 1,c
    jr nz,lab829A
    call lab86B5
lab8292 bit 3,c
    jp nz,lab87E9
    jp lab87D5
lab829A rra 
    rra 
    rra 
    rra 
    call lab86AB
    inc l
    inc l
    ld a,(de)
    call lab86AB
    dec l
    dec l
    jr lab8292
    and 15
    push hl
    ld hl,lab86DA
    call labA6F9
    pop hl
    push hl
    ld h,230
    bit 2,c
    jr z,lab82C1
    pop hl
    inc l
    push hl
    ld h,238
lab82C1 ld l,a
    ld a,(hl)
    and 255
    ex (sp),hl
    ld (hl),a
    bit 2,c
    jr z,lab82CD
    dec l
    dec l
lab82CD inc l
    ex (sp),hl
    inc h
    ld a,(hl)
    and 255
    pop hl
    ld (hl),a
    bit 2,c
    ret nz
    dec l
    ret 
    nop
    inc bc
    inc c
    rrca 
    jr nc,lab8312+1
    inc a
    ccf 
    ret nz
    jp labCFCC
    ret p
    di
    call m,lab21FE+1
    nop
    ld d,b
    call lab865D
    ld de,labFFF2
    bit 6,c
    jr z,lab8302
    ld de,labFFA1
    bit 7,c
    jr z,lab8302
    res 6,c
    res 7,c
lab8302 ld b,4
    call lab8675
    ld hl,(lab86EB)
    inc l
    inc l
    bit 1,c
    jr z,lab8312
    inc l
    inc l
lab8312 ld (lab86EB),hl
    ret 
    ld c,84
    ld de,lab5454
    call lab8738
lab831E ld a,8
    ld hl,labC000
    ld de,labC001
lab8326 ld bc,lab05FF
    ld (hl),0
    ldir
    ld bc,lab0201
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl
    dec a
    jr nz,lab8326
    ret 
    ld b,127
    ld a,3
    out (c),a
    out (c),d
    dec a
    out (c),a
    out (c),e
    dec a
    out (c),a
    out (c),c
    dec a
    out (c),a
    ld a,84
    out (c),a
    ret 
    ld c,0
lab8354 pop hl
lab8355 ld a,(hl)
    inc hl
    or a
    jp m,lab8778
    push hl
    call lab8761
    jr lab8354
    cp 58
    jr nc,lab8373
    cp 32
    jr nz,lab836F
    ld a,84
    set 7,c
    set 6,c
lab836F sub 48
    jr lab8375
lab8373 sub 55
lab8375 jp lab86E8+2
    and 127
    jr nz,lab837E
    push hl
    ret 
lab837E dec a
    jr nz,lab838B
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (lab86EB),de
lab8388 inc hl
    jr lab8355
lab838B dec a
    jr nz,lab8397
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (lab8600),de
    jr lab8388
lab8397 dec a
    jr nz,lab83A3
    ld a,(lab86EB)
    add a,(hl)
    ld (lab86EB),a
    jr lab8388
lab83A3 dec a
    jr nz,lab83AD
    ld a,(hl)
    ld (lab8752+1),a
    ld c,a
    jr lab8388
lab83AD push hl
    push bc
    call lab8716
    pop bc
    pop hl
    jp lab8755
    sla c
    ld a,b
    add a,a
    add a,a
    add a,a
    ld h,a
    and 192
    add a,c
    ld l,a
    ld a,h
    and 56
    ld h,a
    ld a,b
    rlca 
    rlca 
    rlca 
    and 7
    or h
    or 128
    ld h,a
    sra c
    ret 
    jr lab83D5
lab83D5 ld a,h
    sub 8
    ld h,a
    and 56
    cp 56
    ret nz
    ld a,h
    add a,64
    ld h,a
    ld a,l
    sub 64
lab83E5 ld l,a
    ret nc
    dec h
    ret 
    ld a,h
    add a,8
    ld h,a
    and 56
    ret nz
    ld a,h
    sub 64
    ld h,a
    ld a,l
    add a,64
    ld l,a
    ret nc
    inc h
    ret 
lab83FB dec bc
    inc c
    dec c
lab83FE ld c,15
lab8400 nop
    nop
lab8402 nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8409 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8418 nop
lab8419 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8421 nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8428 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8434 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    inc c
    rrca 
    rrca 
    rrca 
lab8447 rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    ld bc,lab0F0D
    rrca 
    rrca 
    dec bc
    ex af,af''
    rrca 
    ex af,af''
    nop
    ret nz
    jr nc,lab8419
lab8459 ret p
    ret p
    jr nc,lab846B+2
    ld b,b
    ld (hl),b
    djnz lab8421
    ret nz
    ld h,b
    jr nc,lab83E5
    ret po
    jr nc,lab8418
    ret nz
    jr nc,lab846B
lab846B ld bc,lab010F
    dec c
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    inc c
    nop
    nop
    nop
    ld c,14
    nop
lab8484 nop
    nop
    nop
    nop
    nop
    nop
lab848A nop
    rlca 
    rlca 
    ld bc,lab0D0D
lab8490 dec bc
    ex af,af''
    ld c,15
    dec bc
    ex af,af''
    nop
    djnz lab8459
    ret po
    jr nc,lab84DC
    nop
    djnz lab849F
lab849F nop
    add a,b
    nop
    djnz lab8434
    nop
    djnz lab8447
    ret po
    jr nc,lab848A
    ld bc,lab0F0D
    rlca 
    ld bc,lab0B0D
    dec bc
    ex af,af''
    ld c,14
    nop
    ld (bc),a
    ld bc,lab0F0F
    nop
    ex af,af''
    nop
    rlca 
    rlca 
    nop
    rlca 
    ld b,0
    nop
    ld d,l
    rst 56
    xor 170
    rst 56
    rst 56
    adc a,b
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    nop
    nop
lab84DC nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec c
    inc c
    ret p
lab84E9 ld bc,lab0C0D
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    ret nc
    jr nc,lab84E9
    ret p
    sub b
    ld h,b
    nop
    nop
    ld b,14
    ld c,12
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    rst 56
    rst 56
    rst 56
    xor d
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ret po
    ld bc,lab0F0D
    dec c
    inc c
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    ret nc
    ld (hl),b
    ret p
    ld h,b
    nop
    nop
    nop
    inc bc
    rlca 
    rlca 
    ld b,0
    nop
    nop
    ld de,labFF76+1
    rst 56
    call z,lab0000
    inc bc
    dec bc
    add hl,bc
    rlca 
    ld (bc),a
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    inc b
    ld c,9
    dec c
    inc c
    nop
    nop
    nop
    nop
    ld (hl),b
    ret nz
    nop
    nop
    nop
    nop
    ld b,14
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    ld de,lab0000
    nop
    inc bc
    dec bc
    ex af,af''
    rrca 
    rlca 
    rlca 
    ld bc,lab0D0D
    dec c
    inc c
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    nop
    inc bc
    dec bc
    dec bc
    dec bc
    ex af,af''
    ld c,14
    rrca 
    ld bc,lab0C0D
    nop
    nop
    nop
    ld bc,lab0008
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    rrca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    ld c,14
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    rlca 
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
lab85F6 nop
    nop
    ld (bc),a
    nop
    nop
    ld bc,lab0F0E
    nop
    nop
lab8600 ret p
lab8601 ret p
lab8602 push hl
    push de
    push bc
    push iy
    ld hl,(labBE06+2)
    ld e,a
    ld d,0
    add hl,de
    ld (labBE06+2),hl
    ld de,labBD1A
    call lab8626
    ld de,labFD1A
    ld hl,(labBE06+2)
    call lab8626
    pop iy
    pop bc
    pop de
    pop hl
    ret 
lab8626 push de
    ld iy,lab8651
lab862B ld e,(iy+0)
    ld d,(iy+1)
    bit 7,d
    jr nz,lab864F
    ld bc,labFF00
lab8638 inc b
    or a
    sbc hl,de
    jr nc,lab8638
    add hl,de
    inc iy
    inc iy
    ld a,b
    ex (sp),hl
    push hl
lab8646 call lab865D
    pop hl
    inc l
    inc l
    ex (sp),hl
    jr lab862B
lab864F pop bc
    ret 
lab8651 djnz lab8678+2
    ret pe
    inc bc
    ld h,h
    nop
    ld a,(bc)
    nop
    ld bc,labFF00
    rst 56
lab865D push hl
    ld hl,labFE5D
    ld e,a
    ld d,0
    ld b,9
lab8666 add hl,de
    djnz lab8666
    ex de,hl
    pop hl
    ld b,5
    ld a,(lab8601)
    call lab8678
    ld b,4
lab8675 ld a,(lab8600)
lab8678 ld (lab86C3+1),a
    ld (lab86D1+1),a
lab867E call lab868A
    bit 0,c
    call nz,lab868A
    inc de
    djnz lab867E
    ret 
lab868A ld a,(de)
    bit 1,c
    jr nz,lab869A
    call lab86B5
lab8692 bit 3,c
    jp nz,lab87E9
    jp lab87D5
lab869A rra 
    rra 
    rra 
    rra 
    call lab86AB
    inc l
    inc l
    ld a,(de)
    call lab86AB
    dec l
    dec l
    jr lab8692
lab86AB and 15
    push hl
    ld hl,lab86DA
    call labA6F9
    pop hl
lab86B5 push hl
    ld h,230
    bit 2,c
    jr z,lab86C1
    pop hl
    inc l
    push hl
    ld h,238
lab86C1 ld l,a
    ld a,(hl)
lab86C3 and 240
    ex (sp),hl
    ld (hl),a
    bit 2,c
    jr z,lab86CD
    dec l
    dec l
lab86CD inc l
    ex (sp),hl
    inc h
    ld a,(hl)
lab86D1 and 240
    pop hl
    ld (hl),a
    bit 2,c
    ret nz
    dec l
    ret 
lab86DA nop
    inc bc
    inc c
    rrca 
    jr nc,lab8712+1
    inc a
    ccf 
    ret nz
    jp labCFCC
    ret p
    di
lab86E8 call m,lab21FE+1
lab86EB or 227
    call lab865D
    ld de,labFFF2
    bit 6,c
    jr z,lab8702
    ld de,labFFA1
    bit 7,c
    jr z,lab8702
    res 6,c
    res 7,c
lab8702 ld b,4
    call lab8675
    ld hl,(lab86EB)
    inc l
    inc l
    bit 1,c
    jr z,lab8712
    inc l
    inc l
lab8712 ld (lab86EB),hl
    ret 
lab8716 ld c,84
    ld de,lab5454
    call lab8738
    ld a,8
    ld hl,labC000
    ld de,labC001
lab8726 ld bc,lab05FF
    ld (hl),0
    ldir
    ld bc,lab0201
    add hl,bc
    ex de,hl
    add hl,bc
    ex de,hl
    dec a
    jr nz,lab8726
    ret 
lab8738 ld b,127
    ld a,3
    out (c),a
    out (c),d
    dec a
    out (c),a
    out (c),e
    dec a
    out (c),a
    out (c),c
    dec a
    out (c),a
    ld a,84
    out (c),a
    ret 
lab8752 ld c,0
lab8754 pop hl
lab8755 ld a,(hl)
    inc hl
    or a
lab8758 jp m,lab8778
    push hl
    call lab8761
    jr lab8754
lab8761 cp 58
    jr nc,lab8773
    cp 32
    jr nz,lab876F
    ld a,84
    set 7,c
    set 6,c
lab876F sub 48
    jr lab8775
lab8773 sub 55
lab8775 jp lab86E8+2
lab8778 and 127
    jr nz,lab877E
    push hl
    ret 
lab877E dec a
    jr nz,lab878B
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (lab86EB),de
lab8788 inc hl
    jr lab8755
lab878B dec a
    jr nz,lab8797
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld (lab8600),de
    jr lab8788
lab8797 dec a
    jr nz,lab87A3
    ld a,(lab86EB)
    add a,(hl)
    ld (lab86EB),a
    jr lab8788
lab87A3 dec a
    jr nz,lab87AD
    ld a,(hl)
    ld (lab8752+1),a
    ld c,a
    jr lab8788
lab87AD push hl
    push bc
    call lab8716
    pop bc
    pop hl
    jp lab8755
lab87B7 sla c
    ld a,b
    add a,a
    add a,a
    add a,a
    ld h,a
    and 192
    add a,c
    ld l,a
    ld a,h
    and 56
    ld h,a
    ld a,b
    rlca 
    rlca 
    rlca 
    and 7
    or h

lab87CD or 128
SCREEN_BUFFER EQU lab87CD+1
    ld h,a
    sra c
    ret 
lab87D3 jr lab87D5
lab87D5 ld a,h
    sub 8
    ld h,a
    and 56
    cp 56
    ret nz
    ld a,h
    add a,64
    ld h,a
    ld a,l
    sub 64
    ld l,a
    ret nc
    dec h
    ret 
lab87E9 ld a,h
    add a,8
    ld h,a
    and 56
    ret nz
    ld a,h
    sub 64
    ld h,a
    ld a,l
    add a,64
    ld l,a
    ret nc
    inc h
    ret 
    dec bc
    inc c
    dec c
    ld c,15
    nop
    nop
    nop
    nop
lab8804 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8811 nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8818 nop
lab8819 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8829 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8831 nop
lab8832 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    djnz lab8819
    ret po
    jr nc,lab888C
    ret p
    ret po
    ld (hl),b
    djnz lab8831
    ret p
    ret p
    sub b
    add a,b
    ret po
    djnz lab8818
    add a,b
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0F0E
    nop
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
lab888C dec bc
    ex af,af''
    ld c,14
    rrca 
    ld bc,lab0D0D
    dec c
    inc c
    nop
    jr nc,lab8829
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h,b
    ret p
    add a,b
    ret nz
    inc bc
    dec bc
    dec bc
lab88AD dec bc
    ex af,af''
lab88AF rrca 
    rlca 
lab88B1 rlca 
lab88B2 ld bc,lab0C0D
lab88B5 nop
    inc b
    nop
    nop
    nop
    nop
    inc b
    nop
    inc bc
    dec bc
    ex af,af''
    rlca 
    ld b,0
    nop
    ld d,l
    rst 56
    xor 187
    rst 56
    rst 56
    call z,lab02FE+2
    dec bc
    inc b
    ld c,9
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    add hl,bc
    rlca 
    ld (bc),a
    dec c
    inc c
    nop
    nop
    ld d,b
    ld d,b
    ret nz
    ld (hl),b
    ret p
    ld b,b
    nop
    nop
    ld b,14
    ld c,12
lab8902 nop
    nop
    ld de,labFF76+1
    rst 56
    rst 56
    ld (hl),a
    adc a,b
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    sub b
    jr nz,lab88AD
    jr nz,lab88AF
    jr nz,lab88B1
    jr nz,lab88B2+1
    jr nz,lab88B5
    jr nz,lab8928
    dec c
lab8928 rrca 
    dec c
    inc c
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
lab8933 nop
    nop
    nop
    nop
    jr nc,lab89A9
    ret nc
    add a,b
    nop
    nop
    nop
    inc bc
    rlca 
    rlca 
    ld b,0
    nop
    nop
    nop
    ld d,l
    rst 56
    rst 56
    adc a,b
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    add hl,bc
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    add hl,bc
    dec c
    inc c
    ld c,14
    nop
    nop
    nop
    nop
    inc (hl)
    add a,h
    nop
    nop
    nop
    nop
    ld b,14
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0B0D
    dec bc
    ex af,af''
    ld c,15
    dec bc
    ex af,af''
    ld bc,lab000F
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
lab89A9 ex af,af''
    ld bc,lab0F0D
    rlca 
    ld bc,lab0D0D
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    inc bc
    inc c
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    ld bc,lab0F0D
    rrca 
    rrca 
    dec bc
    ex af,af''
    rrca 
    ex af,af''
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    ld bc,lab010F
    dec c
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    inc c
    nop
    nop
    di
    ld hl,labF6D9
    ld de,labF6EF
    ld bc,labF70C+1
    ld (lab9654),hl
    ld (lab965B),de
    ld (lab9662),bc
    xor a
    ld (lab9635),a
    ld de,lab801E
    ld hl,lab9650
    call lab9636
    ld de,lab801E+1
    ld hl,lab9657
    call lab9636
    ld de,lab8020
    ld hl,lab965E
    call lab9636
    ret 
    nop
    ld b,7
    push de
    pop ix
lab8A3B ld a,(hl)
    inc hl
    ld (de),a
    inc de
    inc de
    inc de
    djnz lab8A3B
    ld (ix+21),1
    ld (ix+30),1
    ld (ix+33),0
    ret 
    ld (hl),0
    nop
    add a,b
    nop
    nop
    nop
    dec l
    ld (bc),a
    ld a,(bc)
    add a,b
    nop
    nop
    nop
    dec de
    inc b
    inc d
    add a,b
    nop
    nop
    nop
    ld l,(ix+9)
    ld h,(ix+12)
lab8A6B ld a,(hl)
lab8A6C or a
    jp m,lab9677
    ld (ix+18),a
    inc hl
    jp lab97CD
    and 127
    jr nz,lab8AA1
    bit 1,(ix+15)
    jr nz,lab8A96
    set 1,(ix+15)
lab8A85 ld (ix+9),l
    ld (ix+12),h
    ld a,(lab9635)
    ld (lab9635),a
    cp 3
    pop bc
    ret z
    push bc
lab8A96 ld (ix+27),1
    ld (ix+18),1
    jp lab9F42
lab8AA1 dec a
    jr nz,lab8AAC
    inc hl
    ld a,(hl)
    ld (ix+21),a
    inc hl
    jr lab8A6B
lab8AAC dec a
    jr nz,lab8ABA
    inc hl
    ld a,(hl)
    inc hl
    add a,(ix+21)
    ld (ix+21),a
    jr lab8A6B
lab8ABA dec a
    jr nz,lab8AC5
    inc hl
    ld a,(hl)
    inc hl
    ld (ix+24),a
    jr lab8A6B
lab8AC5 dec a
    jr nz,lab8AD4
    inc hl
    ld a,(hl)
    inc hl
    add a,(ix+24)
    ld (ix+24),a
    jp lab966B
lab8AD4 dec a
    jr nz,lab8ADF
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp lab966B
lab8ADF dec a
    jr nz,lab8AFD
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de
    ex de,hl
    ld l,(ix+3)
    ld h,(ix+6)
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (ix+3),l
    ld (ix+6),h
    pop hl
    jp lab966B
lab8AFD dec a
    jr nz,lab8B14
    ld l,(ix+3)
    ld h,(ix+6)
    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)
    ld (ix+3),l
    ld (ix+6),h
    ex de,hl
    jp lab966B
lab8B14 dec a
    jp nz,lab979C
    ld a,(ix+15)
    and 15
    ld d,a
    inc hl
    ld a,(hl)
    inc hl
    or a
    jp m,lab9780
    set 4,d
lab8B27 cp 16
    jr nc,lab8B41
    ld (ix+15),d
    call lab9734
    jp lab966B
    ld e,a
    ld a,(ix+0)
    srl a
    add a,8
    ld d,a
    ld a,e
    jp lab9F59
lab8B41 cp 24
    set 6,d
    jr nc,lab8B75
    and 7
    push hl
    ld hl,lab976D
    add a,l
    ld l,a
    jr nc,lab8B52
    inc h
lab8B52 ld a,(hl)
    ld (ix+42),a
    set 7,d
    ld (ix+15),d
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ex de,hl
    ld d,11
    call lab9F88
    pop hl
    ld a,16
    jp lab972E
    nop
    inc b
    ex af,af''
    ld a,(bc)
    inc c
    dec c
    ld c,11
lab8B75 ld (ix+15),d
    and 7
    ld (ix+42),a
    jp lab966B
    push af
    push de
    ld a,(hl)
    ld d,6
    call lab9F59
    inc hl
    pop de
    pop af
    set 5,d
    bit 6,a
    jr z,lab8B93
    set 4,d
lab8B93 and 63
    cp 16
    jp nz,lab0000
    jr lab8B27
    dec a
    jr nz,lab8BB7
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld b,(hl)
    ld a,(ix+30)
    or a
    jr nz,lab8BAC
    ld a,b
lab8BAC dec a
    ld (ix+30),a
    inc hl
    jr z,lab8BB4
    ex de,hl
lab8BB4 jp lab966B
lab8BB7 inc hl
    ld a,(hl)
    inc hl
    cp 255
    jr z,lab8BC7
    ld (ix+54),a
    set 3,(ix+15)
    jr lab8BB4
lab8BC7 res 3,(ix+15)
    jr lab8BB4
    ld a,(hl)
    inc hl
    ld (ix+9),l
    ld (ix+12),h
    res 2,(ix+15)
    ld c,a
    rra 
    rra 
    rra 
    rra 
    rra 
    and 7
    ld e,a
    ld d,0
lab8BE4 ld hl,lab9FE3
    add hl,de
    ld e,(hl)
    ld b,(ix+24)
    xor a
lab8BED add a,e
    djnz lab8BED
    ld (ix+27),a
    ld a,c
    and 31
    jp nz,lab9E00
    set 2,(ix+15)
    jp lab9F42
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8C18 nop
lab8C19 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab8C21 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    dec bc
    rrca 
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    add hl,bc
lab8C4D dec c
    inc c
    nop
    inc bc
    dec bc
    add hl,bc
    rrca 
    inc c
    nop
    add a,b
    jr nc,lab8C19
    ret p
    ld (hl),b
    jr nc,lab8C4D
    ret po
    ld (hl),b
    djnz lab8C21
    ret p
    ret nc
    jr nc,lab8BE4+1
    ret po
    jr nc,lab8C18
    add a,b
lab8C69 nop
    nop
    inc bc
    rrca 
    add hl,bc
    dec c
    inc c
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    nop
    nop
    nop
lab8C7A nop
    rrca 
    dec c
    ld c,0
    nop
    nop
    ld c,12
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    dec bc
    add hl,bc
    dec c
    dec c
    dec c
    inc c
    nop
    djnz lab8C69
    ret nz
    djnz lab8C9C
lab8C9C nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz lab8CA5
lab8CA5 nop
    ret nz
    ret p
    sub b
    add a,b
    inc bc
    dec bc
    dec bc
    dec bc
    add hl,bc
    dec c
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    ld b,0
    nop
    nop
    nop
    inc c
    nop
    inc bc
    rlca 
    nop
    rlca 
    ld b,0
    nop
    xor d
    rst 56
    ld d,ixl
    rst 56
    rst 56
    adc a,b
    nop
    inc bc
    dec bc
    ld bc,lab0D0D
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    dec bc
    dec bc
    ex af,af''
    dec c
    inc c
    nop
    nop
    ld b,b
    add a,b
    jr nc,lab8C7A
lab8CFA jr nc,lab8D3C
    nop
    nop
    ld b,14
    ld c,12
    nop
    nop
    ld (labFFFE+1),hl
    rst 56
    rst 56
    rst 56
    adc a,b
    nop
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    nop
    nop
    ld bc,lab000B+1
    rlca 
    nop
    ret nz
    and b
    ret nz
    and b
    ret nz
    and b
    ret nz
    and b
    ret nz
    and b
    ret nz
    and b
    nop
    ld c,0
    inc bc
    ex af,af''
    nop
    nop
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    nop
    nop
    nop
    ld h,b
    ret p
    ret po
    ret nz
    nop
lab8D3C nop
    nop
    inc bc
    rlca 
    rlca 
    ld b,0
    nop
    nop
    nop
    cp e
    rst 56
    rst 56
    call z,lab0000
    inc bc
    dec bc
    dec bc
    dec bc
    ex af,af''
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    ld bc,lab0D0D
    dec c
    inc c
    nop
    nop
    nop
    nop
    jr nc,lab8CFA
    nop
    nop
    nop
    nop
    ld b,14
    nop
    ld c,12
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
lab8D8C dec bc
    add hl,bc
    dec c
    inc bc
    dec bc
    add hl,bc
    dec c
    dec c
    dec c
    inc c
    ld bc,lab000F
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    ex af,af''
    inc bc
    dec bc
    dec bc
    dec bc
    add hl,bc
    dec c
    inc c
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    inc bc
    rlca 
    nop
    nop
    nop
    rlca 
    dec bc
    rrca 
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    inc bc
    dec bc
    add hl,bc
    rrca 
    inc c
    ld bc,lab0F0D
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    inc bc
    rrca 
    add hl,bc
    dec c
    inc c
    nop
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    nop
    nop
    nop
    nop
    nop
    rrca 
    dec c
    ld c,0
    nop
lab8E00 push bc
    ld d,(hl)
    inc hl
    bit 7,d
    jr nz,lab8E10
    ld a,(hl)
lab8E08 call lab9F59
lab8E0B inc hl
    pop bc
    djnz lab8E00
    ret 
lab8E10 ld a,d
lab8E11 ld e,a
    and 15
    ld d,a
    bit 6,e
    jr nz,lab8E28
    call lab9F6B
    cp (hl)
lab8E1D jr z,lab8E0B
    bit 5,e
    jr nz,lab8E25
    dec a
    dec a
lab8E25 inc a
    jr lab8E08
lab8E28 bit 5,e
    ld d,7
    jr nz,lab8E34
    call lab9F6B
    and (hl)
    jr lab8E08
lab8E34 call lab9F6B
    or (hl)
    jr lab8E08
lab8E3A ex (sp),hl
    push de
    push bc
    ld b,(hl)
    inc hl
    ld a,1
    ld (labB7F3),a
    call lab8E00
    xor a
    ld (labB7F3),a
    pop bc
    pop de
    ex (sp),hl
    ret 
lab8E4F ld (lab8E61),a
    ld a,c
    ld (lab8E61+2),a
    call lab8E3A
    dec b
    ret po
    jr nz,lab8E1D
    ld a,e
    ld a,(bc)
    dec c
    dec b
lab8E61 ld bc,lab0104
    xor a
    ld (labAFEA+1),a
    ld a,b
    ld (labAFC6+1),a
    ret 
lab8E6D ld b,30
lab8E6F call lab8E3A
    inc bc
    ret po
    inc b
    ret nz
    rra 
    ld a,(bc)
    dec c
    ld a,b
    ld (labAFC6+1),a
    ret 
lab8E7E push hl
    ld hl,lab8EAE
    xor a
    jr lab8E8B
lab8E85 push hl
    ld hl,lab8EB0
    ld a,255
lab8E8B ld (lab8E97),a
    ld a,c
    ld (lab8E99),a
    call lab8E3A
    dec b
    inc b
lab8E97 rst 56
    dec b
lab8E99 ld bc,lab20DE+2
    ret nz
    ld a,e
    ld a,(bc)
    dec c
    ld (labAFF0+1),hl
    ld a,1
    ld (labAFEA+1),a
    ld a,b
    ld (labAFC6+1),a
    pop hl
    ret 
lab8EAE and h
    rst 56
lab8EB0 add a,h
    nop
lab8EB2 push hl
lab8EB3 ld hl,lab4455
    ld a,l
    ld (labB788),a
    ld (labB78C),a
    ld a,h
    ld (labB78A),a
    pop hl
    ret 
lab8EC3 ld a,(labAF6A+1)
    or a
    jr nz,lab8EC3
lab8EC9 ld a,(labAF64+1)
    cp 8
    jr c,lab8EC9
    xor a
    ld (labAF64+1),a
	; Effacement de l''écran a la pile
	ld (lab8F15+1),sp
    ld ix,lab8F2D
    ld de,#0000      
    ld c,8
lab8EE1 ld a,(SCREEN_BUFFER)
    or (ix+1)
    ld h,a
    ld l,(ix+0)
    ld b,(ix+2)    
    ld sp,hl
lab8EEF push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
lab8F00 push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
    push de
lab8F0D push de
    push de
    djnz lab8EEF
    ld (lab8F18+1),sp
lab8F15 ld sp,lab0000

; Effactement de la bande en haut de l''écran
lab8F18 ld hl,lab0000
    ld b,64
    xor a
lab8F1E dec hl
    ld (hl),0
    djnz lab8F1E    
    inc ix
    inc ix
    inc ix
    dec c
    jr nz,lab8EE1
    ret 
    
lab8F2D ld b,b
    inc b
    djnz lab8F70+1
    inc c
    djnz lab8F73+1
    inc d
    djnz lab8F37
lab8F37 inc e
    rrca 
    nop
    inc h
    rrca 
    nop
    inc l
    rrca 
    nop
    inc (hl)
    rrca 
    nop
    inc a
    rrca 
lab8F45 ld hl,(lab8FFA)
    ld c,(iy+0)
    ld b,(iy+1)
    or a
    sbc hl,bc
    ex de,hl
    or a
    sbc hl,de
    ret c
    sbc hl,bc
    jr c,lab8F62
    sbc hl,bc
    jr c,lab8F61
    xor a
    scf
    ret 
lab8F61 add hl,bc
lab8F62 add hl,bc
    ld b,8
    ld c,(iy+2)
    ex de,hl
    xor a
    ld l,a
    ld h,a
lab8F6C add hl,hl
    adc a,a
    rl c
lab8F70 jr nc,lab8F75
    add hl,de
lab8F73 adc a,0
lab8F75 djnz lab8F6C
    add hl,hl
    adc a,a
    ld l,h
    ld h,a
    ld de,lab009F+1
    sbc hl,de
    ld a,l
    srl h
    rra 
    srl h
    rra 
    srl h
    rra 
    ld c,a
    ld a,l
    and 7
    ret 
lab8F8F ld iy,lab8FC6
    add a,a
    add a,a
    add a,iyl
    ld iyl,a
    ret nc
    inc iyh
    ret 
lab8F9D ld e,b
    ld hl,lab0000
    ld d,h
    ld a,(iy+2)
    ld b,8
lab8FA7 rla 
    jr nc,lab8FAB
    add hl,de
lab8FAB add hl,hl
lab8FAC djnz lab8FA7
    ld a,h
    neg
    add a,(iy+3)
    ld b,a
    ret 
lab8FB6 ld a,c
    call lab8F8F
    push de
    call lab8F9D
    pop de
    push bc
    call lab8F45
    pop de
    ld b,d
    ret 
lab8FC6 add a,b
    inc b
    jr nz,lab9019
    dec e
    inc b
    inc hl
    ld d,c
    sbc a,b
    inc bc
    ld h,82
    ld b,(hl)
    inc bc
    inc l
    ld d,l
    pop hl
    ld (bc),a
lab8FD8 ld (lab8758),a
    ld (bc),a
    add hl,sp
    ld e,e
    cpl 
    ld (bc),a
    ld b,d
lab8FE1 ld h,b
    call pe,lab4B01
    ld h,h
    or a
    ld bc,lab6954
    ld a,h
    ld bc,lab6F60+1
lab8FEE ld c,c
    ld bc,lab7670
    jr nz,lab8FF5
    add a,b
lab8FF5 ld a,a
    nop
lab8FF7 ld bc,lab8490
lab8FFA call c,lab0303+2
    dec bc
    rlca 
lab8FFF rrca 
    nop
    nop
    nop
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
lab9011 rrca 
    ld c,2
    nop
    nop
    nop
    ret p
    ret p
lab9019 ld h,b
    jr nc,lab8FAC
    ret p
    djnz lab8FFF
    ret p
    sub b
    ret p
    sub b
    ret p
    ret po
lab9025 ret p
    ld (hl),b
    nop
    ld (hl),b
    ret po
    nop
    nop
    inc b
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,3
    rrca 
    rrca 
    rrca 
    rrca 
lab9039 rrca 
    rrca 
    inc c
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    ld a,(bc)
    ld c,0
    nop
    djnz lab9039
    ret po
    jr nc,lab908B+1
    nop
    ret nz
    ld h,b
    jr nc,lab9011
    add a,b
    ld h,b
    djnz lab9025
    ret po
    jr nc,lab8FF7+1
    ret nz
    nop
    nop
    rlca 
    dec b
    inc c
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    nop
    rlca 
    rlca 
    dec c
    inc c
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    ld bc,lab080B
    nop
    ld de,labFF55
    nop
    ld (hl),a
    adc a,b
    nop
lab908B ld bc,lab0C0D
    rlca 
    rlca 
    ld b,3
    dec bc
    ex af,af''
    ld c,14
    nop
    ld (hl),b
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld (hl),b
    nop
    ret po
    rlca 
    rlca 
    ld bc,lab0C0D
    ld b,14
    ld c,3
    dec bc
    ex af,af''
    nop
    inc c
    nop
    nop
    nop
    nop
    ld b,0
    ld bc,lab080D
    ld b,12
    nop
    nop
    ld d,l
    rst 56
    ld (ix-1),a
    xor 238
    nop
    ld bc,lab0E0E
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    nop
    jr nz,lab90DD
lab90DD jr nz,lab90DF
lab90DF jr nz,lab90E1
lab90E1 jr nz,lab90E3
lab90E3 jr nz,lab90E5
lab90E5 jr nz,lab90ED+1
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
lab90ED ld bc,lab0C0D
lab90F0 ld c,7
    rlca 
    ex af,af''
    nop
    nop
    jr nz,lab9146+2
    ret p
    ret p
    ret po
    add a,b
    nop
    nop
    inc bc
    ld b,14
    inc c
    nop
    nop
    ld de,labFF55
    rst 56
    rst 56
    cp e
    adc a,b
    nop
    nop
    ld c,14
    inc b
    dec bc
    dec bc
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    dec c
    dec c
    ld (bc),a
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    ret p
    ret po
    nop
    nop
    nop
    nop
    inc bc
    rlca 
    inc bc
    dec bc
    nop
    nop
    nop
    nop
lab9146 ld de,labEE76+1
    nop
    nop
    nop
    ld c,14
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab0F0D
    rrca 
    rrca 
    rrca 
    rrca 
    add hl,bc
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    rrca 
    ld (bc),a
    nop
    nop
    nop
    nop
    dec c
    inc c
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    rlca 
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    nop
    ld c,14
    ld c,3
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
lab91FF nop
    ld b,16
lab9202 push bc
    ld ix,lab8021
    ld b,3
lab9209 push bc
    bit 3,(ix+15)
    jr z,lab9223
    dec (ix+63)
    jr nz,lab9223
    ld a,(ix+66)
    ld (ix+63),a
    ld a,(ix+51)
    call lab9E90
    jr lab9229
lab9223 ld bc,lab0032
    call lab9FEB
lab9229 pop bc
    inc ix
    djnz lab9209
    ld bc,lab004F+1
    call lab9FEB
    pop bc
lab9235 djnz lab9202
    ret 
    ld hl,lab621A
    add hl,de
    xor d
    jr lab9235
    rla 
    ld b,a
    rla 
    sbc a,l
    ld d,249
    dec d
    ld e,b
    dec d
    cp l
    inc d
    ld h,20
    sub e
    inc de
    inc b
    inc de
    ld a,d
    ld (de),a
    di
    ld de,lab1170
    pop af
    djnz lab92CF
lab9259 djnz lab9259
    rrca 
    adc a,c
    rrca 
    jr lab926F
    xor d
    ld c,63
    ld c,215
    dec c
    ld (hl),d
    dec c
    ld de,lab3E0D
    ld bc,labF232
    sbc a,a
lab926F ld hl,lab9FF2+1
    ld (lab0038+1),hl
    ei
lab9276 halt
    ld b,245
    in a,(c)
    rra 
    jr nc,lab9276
    di
lab927F call lab9F07
    call labA600
    ld a,(lab9FF2)
    or a
    jr z,lab9296
    call labA6BF
    jr c,lab927F
    xor a
    ld (lab9FF2),a
    jr lab927F
lab9296 call labA6BF
    jr nc,lab927F
    ld hl,labA6A3
    ld (lab0038+1),hl
    ei
    ret 
    push af
    push hl
    push de
    push bc
    ld b,245
    in a,(c)
    rra 
    jr nc,lab92B9
    push ix
    ex af,af''
    push af
    call lab9F07
    pop af
    ex af,af''
    pop ix
lab92B9 pop bc
    pop de
    pop hl
    pop af
    ei
    ret 
    call labA753
    ld a,73
    push af
    out (c),a
    ld a,244
    in a,(0)
    inc a
    jr nz,lab92D8
    pop af
lab92CF dec a
    jp p,labA6C4
    call labA76C
    xor a
    ret 
lab92D8 dec a
    ld e,a
    cpl 
    ld d,a
    ld a,255
lab92DE inc a
    srl e
    jr c,lab92DE
    ld e,a
    pop af
    ld c,a
    add a,a
    add a,a
    add a,a
    or e
    ld hl,labA700
    call labA6F9
    push af
    call labA76C
    pop af
    ld b,c
    scf
    ret 
    add a,a
    add a,l
    ld l,a
    ld a,(hl)
    ret nc
    inc h
    ld a,(hl)
    ret 
    add a,b
    add a,c
    add a,d
    add hl,sp
    ld (hl),51
    dec c
    ld l,131
    add a,h
    scf
    jr c,lab9340+2
    ld sp,lab3032
    add a,l
    ld e,e
    dec c
    ld e,l
    inc (hl)
    add a,(hl)
    ld e,h
    add a,a
    ld e,(hl)
    dec l
    ld b,b
    ld d,b
    dec sp
    ld a,(lab2E2F)
    jr nc,lab935A+1
    ld c,a
    ld c,c
    ld c,h
    ld c,e
    ld c,l
    inc l
    jr c,lab9360+1
    ld d,l
    ld e,c
    ld c,b
    ld c,d
    ld c,(hl)
    jr nz,lab9366+1
    dec (hl)
    ld d,d
    ld d,h
    ld b,a
    ld b,(hl)
    ld b,d
    ld d,(hl)
    inc (hl)
    inc sp
    ld b,l
    ld d,a
    ld d,e
    ld b,h
    ld b,e
    ld e,b
lab9340 ld sp,lab8832
    ld d,c
    adc a,c
    ld b,c
    adc a,d
    ld e,d
    adc a,e
    adc a,h
    adc a,l
    adc a,(hl)
    adc a,a
    sub b
    sub c
    sub d
    nop
    nop
    nop
    ld b,244
    ld a,14
    ld (labB7F3),a
lab935A out (c),a
    ld b,246
    ld a,192
lab9360 out (c),a
    xor a
    out (c),a
    inc b
lab9366 ld a,146
    out (c),a
    dec b
    ret 
    inc b
    ld a,130
    out (c),a
    xor a
    ld (labB7F3),a
    ret 
    call labA753
    ld hl,labA7D9
    ld c,0
    call labA7BB
    jr nz,lab9385
    set 4,c
lab9385 call labA7BB
    jr nz,lab938C
    set 3,c
lab938C call labA7BB
    jr nz,lab9395
    ld a,12
    xor c
    ld c,a
lab9395 call labA7BB
    jr nz,lab939C
    set 1,c
lab939C call labA7BB
    jr nz,lab93A5
    ld a,3
    xor c
    ld c,a
lab93A5 call labA76C
    ld a,(labA750)
    add a,a
    jr nc,lab93B2
    ld a,1
    xor c
    ld c,a
lab93B2 ld a,(labA751)
    ld b,a
    ld (labA751),bc
    ret 
    ld a,(hl)
    inc hl
    out (c),a
    ld a,244
    in a,(0)
    and (hl)
    inc hl
    ld a,0
    out (c),a
    ret 
    call labA753
    ld hl,labA7E3
    call labA7BB
    push af
    call labA76C
    pop af
    ret 
    ld b,l
    add a,b
    ld c,b
    jr nz,lab9426
    add a,b
    ld b,l
    ld b,b
    ld b,h
    ld b,b
    ld b,e
    ex af,af''
    ld b,l
    add a,b
    ld c,b
    jr nz,lab9432
    add a,b
    ld b,l
    ld b,b
    ld b,h
    ld b,b
    ld b,e
    ex af,af''
    ld c,c
    djnz lab943D
    ld bc,lab0249
    ld c,c
    inc b
    ld c,c
    ex af,af''
    ld b,e
    ex af,af''
    db 221
    db 238
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9418 nop
lab9419 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9426 nop
    nop
    nop
lab9429 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9431 nop
lab9432 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab943D nop
    nop
    nop
    nop
    nop
    rrca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    djnz lab9419
    ret po
    jr nc,lab948C
    ret p
    ret po
    ld (hl),b
    djnz lab9431
    ret p
    ret p
    sub b
    add a,b
    ret po
    djnz lab9418
    add a,b
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0F0E
    nop
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
lab948C dec bc
    ex af,af''
    ld c,14
    rrca 
    ld bc,lab0D0D
    dec c
    inc c
    nop
    jr nc,lab9429
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h,b
    ret p
    add a,b
    ret nz
    inc bc
    dec bc
    dec bc
lab94AD dec bc
    ex af,af''
lab94AF rrca 
    rlca 
lab94B1 rlca 
lab94B2 ld bc,lab0C0D
lab94B5 nop
    inc b
    nop
    nop
    nop
    nop
    inc b
    nop
    inc bc
    dec bc
    ex af,af''
    rlca 
    ld b,0
    nop
    ld d,l
    rst 56
    xor 187
    rst 56
    rst 56
    call z,lab02FE+2
    dec bc
    inc b
    ld c,9
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    add hl,bc
    rlca 
    ld (bc),a
    dec c
    inc c
    nop
    nop
    ld d,b
    ld d,b
    ret nz
    ld (hl),b
    ret p
    ld b,b
    nop
    nop
    ld b,14
    ld c,12
    nop
    nop
    ld de,labFF76+1
    rst 56
    rst 56
    ld (hl),a
    adc a,b
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    sub b
    jr nz,lab94AD
    jr nz,lab94AF
    jr nz,lab94B1
    jr nz,lab94B2+1
    jr nz,lab94B5
    jr nz,lab9528
    dec c
lab9528 rrca 
    dec c
    inc c
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    nop
    jr nc,lab95A9
    ret nc
    add a,b
    nop
    nop
    nop
    inc bc
    rlca 
    rlca 
    ld b,0
    nop
    nop
    nop
    ld d,l
    rst 56
    rst 56
    adc a,b
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    add hl,bc
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    add hl,bc
    dec c
    inc c
    ld c,14
    nop
    nop
    nop
    nop
    inc (hl)
    add a,h
    nop
    nop
    nop
    nop
    ld b,14
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0B0D
    dec bc
    ex af,af''
    ld c,15
    dec bc
    ex af,af''
    ld bc,lab000F
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
lab95A9 ex af,af''
    ld bc,lab0F0D
    rlca 
    ld bc,lab0D0D
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    inc bc
    inc c
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    ld bc,lab0F0D
    rrca 
    rrca 
    dec bc
    ex af,af''
    rrca 
    ex af,af''
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab95E1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    ld bc,lab010F
    dec c
    rrca 
lab95F0 rrca 
    rrca 
    dec bc
    ex af,af''
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    inc c
    nop
    nop
lab9600 di
    ld hl,labF6D9
    ld de,labF6EF
    ld bc,labF70C+1
    ld (lab9654),hl
    ld (lab965B),de
    ld (lab9662),bc
    xor a
    ld (lab9635),a
    ld de,lab801E
    ld hl,lab9650
    call lab9636
    ld de,lab801E+1
    ld hl,lab9657
    call lab9636
    ld de,lab8020
    ld hl,lab965E
    call lab9636
    ret 
lab9635 nop
lab9636 ld b,7
    push de
    pop ix
lab963B ld a,(hl)
    inc hl
    ld (de),a
    inc de
    inc de
    inc de
    djnz lab963B
    ld (ix+21),1
    ld (ix+30),1
    ld (ix+33),0
    ret 
lab9650 ld (hl),0
    nop
    add a,b
lab9654 exx
    or 0
lab9657 dec l
    ld (bc),a
    ld a,(bc)
    add a,b
lab965B rst 40
    or 0
lab965E dec de
    inc b
    inc d
    add a,b
lab9662 dec c
    rst 48
    nop
lab9665 ld l,(ix+9)
    ld h,(ix+12)
lab966B ld a,(hl)
    or a
    jp m,lab9677
    ld (ix+18),a
    inc hl
    jp lab97CD
lab9677 and 127
    jr nz,lab96A1
    bit 1,(ix+15)
    jr nz,lab9696
    set 1,(ix+15)
    ld (ix+9),l
    ld (ix+12),h
    ld a,(lab9635)
    ld (lab9635),a
    cp 3
    pop bc
    ret z
    push bc
lab9696 ld (ix+27),1
    ld (ix+18),1
    jp lab9F42
lab96A1 dec a
    jr nz,lab96AC
    inc hl
    ld a,(hl)
    ld (ix+21),a
    inc hl
    jr lab966B
lab96AC dec a
    jr nz,lab96BA
    inc hl
    ld a,(hl)
    inc hl
    add a,(ix+21)
    ld (ix+21),a
    jr lab966B
lab96BA dec a
    jr nz,lab96C5
    inc hl
    ld a,(hl)
    inc hl
    ld (ix+24),a
    jr lab966B
lab96C5 dec a
    jr nz,lab96D4
    inc hl
    ld a,(hl)
    inc hl
    add a,(ix+24)
    ld (ix+24),a
    jp lab966B
lab96D4 dec a
    jr nz,lab96DF
    inc hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp lab966B
lab96DF dec a
    jr nz,lab96FD
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push de
    ex de,hl
    ld l,(ix+3)
    ld h,(ix+6)
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (ix+3),l
    ld (ix+6),h
    pop hl
    jp lab966B
lab96FD dec a
    jr nz,lab9714
    ld l,(ix+3)
    ld h,(ix+6)
    dec hl
    ld d,(hl)
    dec hl
    ld e,(hl)
    ld (ix+3),l
    ld (ix+6),h
    ex de,hl
    jp lab966B
lab9714 dec a
    jp nz,lab979C
    ld a,(ix+15)
    and 15
    ld d,a
    inc hl
    ld a,(hl)
    inc hl
    or a
    jp m,lab9780
    set 4,d
lab9727 cp 16
    jr nc,lab9741
    ld (ix+15),d
lab972E call lab9734
    jp lab966B
lab9734 ld e,a
    ld a,(ix+0)
    srl a
    add a,8
    ld d,a
    ld a,e
    jp lab9F59
lab9741 cp 24
lab9743 set 6,d
    jr nc,lab9775
    and 7
    push hl
    ld hl,lab976D
    add a,l
    ld l,a
    jr nc,lab9752
    inc h
lab9752 ld a,(hl)
    ld (ix+42),a
    set 7,d
    ld (ix+15),d
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ex de,hl
    ld d,11
    call lab9F88
    pop hl
    ld a,16
    jp lab972E
lab976D nop
    inc b
    ex af,af''
    ld a,(bc)
    inc c
    dec c
    ld c,11
lab9775 ld (ix+15),d
    and 7
    ld (ix+42),a
    jp lab966B
lab9780 push af
    push de
    ld a,(hl)
    ld d,6
    call lab9F59
    inc hl
    pop de
    pop af
    set 5,d
    bit 6,a
    jr z,lab9793
    set 4,d
lab9793 and 63
    cp 16
    jp nz,lab0000
    jr lab9727
lab979C dec a
    jr nz,lab97B7
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld b,(hl)
    ld a,(ix+30)
    or a
    jr nz,lab97AC
    ld a,b
lab97AC dec a
    ld (ix+30),a
    inc hl
    jr z,lab97B4
    ex de,hl
lab97B4 jp lab966B
lab97B7 inc hl
    ld a,(hl)
    inc hl
    cp 255
    jr z,lab97C7
    ld (ix+54),a
    set 3,(ix+15)
    jr lab97B4
lab97C7 res 3,(ix+15)
    jr lab97B4
lab97CD ld a,(hl)
    inc hl
    ld (ix+9),l
    ld (ix+12),h
    res 2,(ix+15)
    ld c,a
    rra 
    rra 
    rra 
    rra 
    rra 
    and 7
lab97E1 ld e,a
    ld d,0
lab97E4 ld hl,lab9FE3
    add hl,de
    ld e,(hl)
    ld b,(ix+24)
    xor a
lab97ED add a,e
    djnz lab97ED
    ld (ix+27),a
    ld a,c
    and 31
    jp nz,lab9E00
    set 2,(ix+15)
    jp lab9F42
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    ld c,3
lab980D ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    ld (hl),b
    ret p
    ret po
    ret p
    ld (hl),b
    jr nc,lab980D
    add a,b
    ld (hl),b
    djnz lab97E1
    ret p
    ret nz
    jr nc,lab97E4+1
    ret p
    ld (hl),b
    sub b
    ret po
    ld (hl),b
    add a,b
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    nop
    nop
lab9839 nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    rlca 
    nop
    nop
    jr nc,lab9839
    ret p
    or b
    ld h,b
    nop
    ld h,b
    ld b,b
    jr nz,lab98D1
    nop
    ld (hl),b
    djnz lab97E4+1
    ld (hl),b
    jr nc,lab9868
lab9868 ret p
    nop
    nop
    ld c,14
    ld c,3
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    nop
    ld bc,lab000B+1
    nop
    rlca 
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    ld (ix-18),a
    nop
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    ret nz
lab9898 ld bc,lab0F0D
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    jr lab9898+1
    ret nz
    ld c,14
    nop
    ld c,14
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    nop
    add a,b
    ret p
    ret p
    ret p
lab98BA ret po
    jr nz,lab98BD
lab98BD nop
    dec c
    inc c
    ld c,12
    nop
    nop
    ld d,l
    rst 56
    xor 255
    rst 56
    rst 56
    ld h,(hl)
    nop
    nop
    dec c
    dec c
    ld (bc),a
    rlca 
lab98D1 rlca 
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    ld c,14
    inc b
    dec bc
    dec bc
    nop
    nop
    nop
    djnz lab9948
    ret p
    ret p
    ret nc
    nop
    nop
    nop
    inc bc
    rlca 
    ld b,12
    nop
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    rst 56
    db 221
    db 136
    nop
    ld bc,lab0C0D
    ld c,7
    rlca 
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab0E0E
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    jr nc,lab98BA
    nop
    nop
    nop
    nop
    inc bc
    ld b,1
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    ld (hl),a
lab9948 call z,lab0000
    ld bc,lab0C0D
    ld b,14
    ld c,3
    dec bc
    ex af,af''
    ld c,14
    nop
    inc b
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    add hl,bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    ld (bc),a
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    rlca 
    rlca 
    ld b,3
    dec bc
    ex af,af''
    nop
    nop
    nop
    rrca 
    ld c,0
    nop
lab997C nop
    ld bc,lab080D
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    ld a,(bc)
    ld c,0
    rlca 
    dec b
    inc c
lab9999 nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld a,(bc)
    ld c,0
    rlca 
    dec b
    inc c
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    inc bc
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,3
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    nop
    nop
    nop
    nop
    nop
    inc b
    ld a,(labB600)
    cp 0
    ret z
    ld a,(labB605+1)
    jr c,lab9A16
    inc a
    ld (labB605+1),a
    ld hl,labB6A1
    jr lab9A2D
lab9A16 ld hl,labB68E
    dec a
    ld (labB605+1),a
    jr z,lab9A2D
    ld b,a
lab9A20 ld a,(hl)
    and 7
    ld d,a
    add a,a
    add a,d
    inc a
    ld e,a
    ld d,0
    add hl,de
    djnz lab9A20
lab9A2D ex de,hl
    ld a,(de)
    rra 
    rra 
    rra 
    and 31
    add a,154
    ld b,a
    ld c,27
    call lab87B7
    ld a,(de)
    inc de
    and 7
    ld c,a
    push hl
    push de
    push bc
    call labB656
    pop bc
    pop de
    pop hl
    ld a,64
    xor h
    ld h,a
    call labB656
    ld (labB611+1),de
    ret 
lab9A56 push hl
    ld b,3
lab9A59 ld a,(de)
    push de
    ld d,214
    ld e,a
    ld a,(de)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    ld (hl),a
    pop de
    inc de
    inc l
    djnz lab9A59
    pop hl
    call lab87D5
    dec c
    jr nz,lab9A56
    ret 
    neg
    add a,8
    ld (labB673+1),a
    ret c
    ld a,(labB601)
    add a,a
    neg
    add a,18
    add a,a
    add a,a
    ld (labB673+1),a
    ld a,(labB600)
    inc a
    ld (labB600),a
    ret 
    ld b,85
    rst 0
    call p,lab3848
    inc (hl)
    out (255),a
    sub (hl)
    cp a
    rst 56
    jp m,labFF8E+1
    jp po,labFC80
    ld (bc),a
    rrca 
    ld l,e
    rst 56
    call pe,labC755
    call p,lab3848
    inc (hl)
    out (255),a
    sub (hl)
    xor a
    rst 56
    jp po,labFC80
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    rla 
    dec h
    rst 56
    ret pe
    ld l,e
    rst 0
    call pe,lab3850
    ld (hl),h
    ld b,a
    rst 56
    sub h
    rst 24
    rst 56
    or 128
    rst 56
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    ld d,37
    rst 0
    ret pe
    ld l,b
    jr c,lab9B40
    ld b,e
    rst 56
    sub h
    ld e,a
    rst 56
    call p,labFFC0
    ld b,128
    nop
    ld (bc),a
    ld e,51
    rst 56
    ret c
    dec h
    add a,c
    ret pe
    ld h,b
    ld a,(hl)
    inc c
    ld e,a
    rst 56
    call p,labFF40
    inc b
    ret nz
    nop
    ld b,38
    dec d
    rst 56
    ret nc
    inc sp
    add a,c
    ret c
    inc h
    ld a,(hl)
    jr z,lab9B6D
    rst 56
    call pe,labFF40
    inc b
    ld b,b
    nop
    inc b
    ld l,26
    rst 56
    or b
    dec d
    jp lab30D0
    inc a
    jr lab9B38
    rst 56
    ret pe
    ld h,b
    ld a,(hl)
    inc c
    ld b,b
    nop
    inc b
    ld (hl),13
    ld a,a
    ld h,b
    ld a,(de)
    jp lab10B0
    inc a
    djnz lab9B5A+1
    rst 56
    ret c
    jr nz,lab9BA6
    ex af,af''
    ld h,b
    nop
    inc c
    dec (hl)
    dec c
    ld (hl),c
    ld h,b
    jr lab9B40
    jr nc,lab9B4B
    rst 56
    ret nc
    jr nc,lab9B70
lab9B38 jr lab9B5A
    nop
    ex af,af''
    dec a
    ld b,254
    ret nz
lab9B40 dec c
    ret m
    ld h,b
    jr lab9BC4
    or b
    djnz lab9B48
lab9B48 djnz lab9B7A
    nop
lab9B4B jr lab9B89
    ld b,254
    ret nz
    dec c
    ld a,a
    ld h,b
    jr lab9B55
lab9B55 jr nc,lab9B67
    nop
    djnz lab9BA6
lab9B5A ld bc,lab00BB
    inc bc
    ld a,l
    add a,b
    ld b,0
    ret nz
    inc c
    nop
    ld h,b
    ld l,(hl)
lab9B67 nop
    jr c,lab9B6A
lab9B6A nop
    jr c,lab9B6D
lab9B6D nop
    ld a,h
    nop
lab9B70 nop
    cp 0
    ld bc,lab0082+1
    inc bc
    ld bc,lab6C7F+1
lab9B7A nop
    jr z,lab9B7D
lab9B7D nop
    jr z,lab9B80
lab9B80 nop
    ld l,h
    nop
    nop
    add a,0
    ld d,h
    ld d,e
    ld b,a
lab9B89 ld d,d
    ld b,h
    ld d,e
    ld b,a
    ld d,d
    ld d,h
    ld c,d
    ld c,l
    ld b,l
    nop
    ex af,af''
    ld d,b
    jr c,lab9B9E+1
    ret m
    rst 48
    nop
    nop
    nop
    nop
    nop
lab9B9E ld a,1
    dec a
    jr nz,lab9BD9
    ld a,(labB7F3)
lab9BA6 or a
    ret nz
    ld a,16
    ld (labB7F1),a
lab9BAD ld a,(labB7F2)
    xor 8
    ld (labB7F2),a
    ld b,a
    ld a,(labB79B)
    bit 4,a
    ld a,b
    jr z,lab9BBF
    xor a
lab9BBF ld d,1
    call lab9F59
lab9BC4 ld hl,lab4C5D
    ld a,l
    ld l,h
    ld h,a
    ld (labB7C4+1),hl
    ld (labB791),a
    ld hl,lab2060
    ld a,l
    ld l,h
    ld h,a
    ld (labB7D0+1),hl
lab9BD9 ld (labB79E+1),a
lab9BDC ld a,(labB7F1)
    or a
    ret z
    dec a
    ld (labB7F1),a
    ld b,a
    ld a,(labB7F3)
    or a
lab9BEA ret nz
    ld a,b
    ld d,8
    jp lab9F59
    nop
    rrca 
    nop
    cp 9
    call nz,lab04CC+1
    jp lab38A5
    ex (sp),hl
    inc hl
    inc hl
    ld e,(hl)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9C09 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9C11 nop
lab9C12 nop
    nop
lab9C14 nop
    nop
    nop
lab9C17 jr nc,lab9C09
    and b
    djnz lab9BDC
    ret po
lab9C1D jr nc,lab9BAD+2
    ret po
    jr nc,lab9C12
    jr nc,lab9C14
    ret p
    ld (hl),b
    and b
    nop
    jr nc,lab9BEA
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
lab9C39 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0E0E
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    ld a,(bc)
    ld c,0
    nop
    djnz lab9C39
    ret po
    jr nc,lab9C8B+1
    djnz lab9C1D+1
    ld h,b
lab9C5F djnz lab9C11
    ret p
    ret p
    ret nc
    add a,b
    ret po
    djnz lab9C17+1
    ret nz
    nop
    nop
    rlca 
    dec b
    inc c
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    ld b,3
    ex af,af''
    inc c
    nop
    rlca 
    rlca 
    ex af,af''
    nop
    ld bc,lab080D
    nop
    nop
    ld (lab00CC),hl
    nop
    nop
    nop
lab9C8B ld bc,lab0C0D
    ld c,14
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    jr nc,lab9C99
lab9C99 rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld h,b
    nop
    ret po
    rlca 
    rlca 
lab9CAC ld bc,lab0C0D
lab9CAF ld c,7
lab9CB1 rlca 
    inc bc
lab9CB3 dec bc
    ex af,af''
lab9CB5 nop
    inc b
    nop
    nop
    nop
    nop
    inc b
    nop
    ld bc,lab080B
    ld b,14
    nop
    nop
    xor d
    rst 56
    xor 187
    rst 56
    rst 56
    call z,lab0100
    ld c,6
    rrca 
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    nop
    djnz lab9CDD
lab9CDD djnz lab9CDF
lab9CDF djnz lab9CE1
lab9CE1 djnz lab9CE3
lab9CE3 djnz lab9CE5
lab9CE5 djnz lab9CED+1
    rlca 
    nop
lab9CE9 rlca 
    rlca 
    nop
    nop
lab9CED ld bc,lab0D0D
    rrca 
    ld b,7
    ex af,af''
    nop
    nop
    ld h,b
    or b
    ret p
    ret p
    ret po
    ret nz
    nop
    nop
    rlca 
    ld b,14
    inc c
    nop
    nop
    ld (labFFBB),hl
    rst 56
    rst 56
    cp e
    adc a,b
    nop
    nop
    rlca 
    rlca 
    dec b
    dec bc
    ex af,af''
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    sub b
    jr nz,lab9CAC+1
    jr nz,lab9CAF
    jr nz,lab9CB1
    jr nz,lab9CB3
    jr nz,lab9CB5
    jr nz,lab9D28
    dec c
lab9D28 rrca 
    dec c
    inc c
    nop
    nop
    nop
    ld bc,lab0A0D
    ld c,14
    nop
    nop
    nop
    nop
    djnz lab9CE9
    or b
    nop
    nop
    nop
    nop
    inc bc
    rlca 
    inc bc
    rlca 
    nop
    nop
    nop
    nop
    ld (labFFFE+1),hl
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    nop
    ld bc,lab0C0D
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    nop
    ld e,6
    nop
    nop
    nop
    nop
    ld c,12
    nop
    rlca 
    ld b,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    ld c,15
    dec bc
    ex af,af''
    inc bc
    rrca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0E+1
    ld bc,lab0F0D
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    ld c,14
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    ld b,14
    nop
    nop
    nop
    ld bc,lab010F
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    rrca 
    ex af,af''
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    ld bc,lab030F
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ex af,af''
    rrca 
    ex af,af''
    nop
    nop
lab9E00 add a,(ix+21)
    ld (ix+51),a
    bit 3,(ix+15)
    jr z,lab9E30
    push af
    ld a,(ix+54)
    add a,a
    ld hl,labF76A
    add a,l
    ld l,a
    jr nc,lab9E19
    inc h
lab9E19 ld e,(hl)
    inc hl
    ld d,(hl)
    ld a,(de)
    inc de
    ld (ix+57),e
    ld (ix+60),d
    ld (ix+63),1
    ld (ix+66),a
    ld (ix+39),0
    pop af
lab9E30 call lab9E90
    bit 5,(ix+15)
    jr z,lab9E48
    ld a,(ix-3)
    or 7
    ld e,a
    ld d,7
    call lab9F6B
    and e
    call lab9F59
lab9E48 bit 4,(ix+15)
    jr z,lab9E5D
    ld a,(ix-3)
    or 56
    ld e,a
    ld d,7
    call lab9F6B
    and e
    call lab9F59
lab9E5D bit 6,(ix+15)
    jp z,lab9F42
    bit 7,(ix+15)
    jr z,lab9E75
    ld a,(ix+42)
    ld d,13
    call lab9F59
    jp lab9F42
lab9E75 ld a,(ix+42)
    add a,a
    ld hl,labF71F
    add a,l
    ld l,a
    jr nc,lab9E81
    inc h
lab9E81 ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    ld a,(hl)
    ld (ix+48),a
    inc hl
    call lab9FB3
    jp lab9F42
lab9E90 push af
    ld a,64
    bit 3,(ix+15)
    jr z,lab9EA8
    ld l,(ix+57)
    ld h,(ix+60)
    call lab9FC3
    ld (ix+57),l
    ld (ix+60),h
lab9EA8 ld e,a
    rra 
    rra 
    rra 
    and 15
    ld c,a
    pop af
    add a,a
    add a,c
    sub 8
    ld d,a
    push de
    ld b,255
    ld c,24
lab9EBA inc b
    sub c
    jr nc,lab9EBA
    add a,c
    add a,a
    ld e,a
    ld d,0
    ld hl,labA638
    add hl,de
    ld a,b
    ex af,af''
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    pop hl
    ex de,hl
    push hl
    or a
    sbc hl,bc
    ex de,hl
    ld a,l
    ld b,h
    ld hl,lab0000
    and 7
    jr z,lab9EF0
lab9EE0 add hl,de
    dec a
    jr nz,lab9EE0
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
lab9EF0 pop de
    add hl,de
    ex af,af''
    ld b,a
    or a
    jr z,lab9F00
lab9EF7 srl h
    rr l
    djnz lab9EF7
    jr nc,lab9F00
    inc hl
lab9F00 ld d,(ix+0)
    call lab9F88
    ret 
lab9F07 ld ix,lab8021
    ld b,3
lab9F0D push bc
    ld a,(ix+15)
    and 192
    cp 64
    jr nz,lab9F1D
    dec (ix+45)
    call z,lab9FAA
lab9F1D dec (ix+27)
    jp nz,lab9F42
    ld a,(ix-3)
    or 192
    cpl 
    ld d,7
    ld e,a
    call lab9F6B
    or e
    call lab9F59
    dec (ix+18)
    ld l,(ix+9)
    ld h,(ix+12)
    jp nz,lab97CD
    jp lab9665
lab9F42 pop bc
    inc ix
    djnz lab9F0D
    ld a,1
    or a
    ret 
lab9F4B ld b,244
    out (c),d
    ld b,246
    ld a,192
    out (c),a
    xor a
    out (c),a
    ret 
lab9F59 ld c,a
    call lab9F4B
    ld b,244
    out (c),c
    ld b,246
    ld a,128
    out (c),a
    xor a
    out (c),a
    ret 
lab9F6B call lab9F4B
    ld a,146
    inc b
    out (c),a
    dec b
    ld a,64
    out (c),a
    ld b,244
    in c,(c)
    ld b,246
    xor a
    out (c),a
    inc b
    ld a,130
    out (c),a
    ld a,c
    ret 
lab9F88 call lab9F4B
    ld b,244
    out (c),l
    ld b,246
    ld a,128
    out (c),a
    xor a
    out (c),a
    inc d
    call lab9F4B
    ld b,244
    out (c),h
    ld b,246
    ld a,128
    out (c),a
    xor a
    out (c),a
    ret 
lab9FAA ld l,(ix+33)
lab9FAD ld h,(ix+36)
    ld a,(ix+48)
lab9FB3 ld (ix+45),a
    call lab9FC3
    ld (ix+33),l
    ld (ix+36),h
    call lab9734
    ret 
lab9FC3 ld a,(hl)
    inc hl
    or a
    ret p
    rra 
    ld e,(hl)
    inc hl
    ld d,(hl)
    jr c,lab9FD0
    ex de,hl
    jr lab9FC3
lab9FD0 inc hl
    ld b,(hl)
    ld a,(ix+39)
    or a
    jr nz,lab9FD9
    ld a,b
lab9FD9 dec a
    ld (ix+39),a
    inc hl
    jr z,lab9FC3
    ex de,hl
    jr lab9FC3
lab9FE3 ld bc,lab0307+1
    inc b
    ld (bc),a
    ld b,64
    add a,b
lab9FEB inc b
lab9FEC dec c
    jr nz,lab9FEC
    djnz lab9FEC
    ret 
lab9FF2 ld bc,labC9FB
    and b
    ld h,b
    ret po
    djnz lab9F88+2
    ld d,b
    ret nc
    jr nc,lab9FAD+1
    ld (hl),b
lab9FFF ret p
    nop
    inc b
    ld a,(labB600)
    cp 0
    ret z
    ld a,(labB605+1)
    jr c,labA016
    inc a
    ld (labB605+1),a
    ld hl,labB6A1
labA014 jr labA02D
labA016 ld hl,labB68E
    dec a
    ld (labB605+1),a
    jr z,labA02D
    ld b,a
labA020 ld a,(hl)
    and 7
    ld d,a
    add a,a
    add a,d
    inc a
    ld e,a
    ld d,0
    add hl,de
    djnz labA020
labA02D ex de,hl
    ld a,(de)
    rra 
    rra 
    rra 
    and 31
    add a,154
    ld b,a
    ld c,27
    call lab87B7
    ld a,(de)
    inc de
    and 7
    ld c,a
    push hl
    push de
    push bc
    call labB656
    pop bc
    pop de
    pop hl
    ld a,64
    xor h
    ld h,a
    call labB656
    ld (labB611+1),de
    ret 
labA056 push hl
    ld b,3
labA059 ld a,(de)
    push de
    ld d,214
    ld e,a
    ld a,(de)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    ld (hl),a
    pop de
    inc de
    inc l
    djnz labA059
    pop hl
    call lab87D5
    dec c
    jr nz,labA056
    ret 
    neg
    add a,8
    ld (labB673+1),a
    ret c
    ld a,(labB601)
    add a,a
    neg
    add a,18
    add a,a
    add a,a
    ld (labB673+1),a
    ld a,(labB600)
    inc a
    ld (labB600),a
    ret 
    ld b,85
    rst 0
    call p,lab3848
    inc (hl)
    out (255),a
    sub (hl)
    cp a
    rst 56
    jp m,labFF8E+1
    jp po,labFC80
    ld (bc),a
    rrca 
    ld l,e
    rst 56
    call pe,labC755
    call p,lab3848
labA0AA inc (hl)
    out (255),a
    sub (hl)
    xor a
    rst 56
    jp po,labFC80
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    rla 
    dec h
    rst 56
    ret pe
    ld l,e
    rst 0
    call pe,lab3850
    ld (hl),h
    ld b,a
    rst 56
    sub h
    rst 24
    rst 56
    or 128
    rst 56
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    ld d,37
    rst 0
    ret pe
    ld l,b
    jr c,labA140
    ld b,e
    rst 56
    sub h
    ld e,a
    rst 56
    call p,labFFC0
    ld b,128
    nop
    ld (bc),a
    ld e,51
    rst 56
    ret c
    dec h
    add a,c
    ret pe
    ld h,b
    ld a,(hl)
    inc c
    ld e,a
    rst 56
    call p,labFF40
    inc b
    ret nz
    nop
    ld b,38
    dec d
    rst 56
    ret nc
    inc sp
    add a,c
    ret c
    inc h
    ld a,(hl)
    jr z,labA16D
    rst 56
    call pe,labFF40
    inc b
    ld b,b
    nop
    inc b
    ld l,26
    rst 56
    or b
    dec d
    jp lab30D0
    inc a
    jr labA138
    rst 56
    ret pe
    ld h,b
    ld a,(hl)
    inc c
labA116 ld b,b
    nop
    inc b
    ld (hl),13
    ld a,a
    ld h,b
    ld a,(de)
    jp lab10B0
    inc a
    djnz labA15A+1
    rst 56
    ret c
    jr nz,labA1A6
    ex af,af''
    ld h,b
    nop
    inc c
    dec (hl)
    dec c
    ld (hl),c
    ld h,b
    jr labA140
    jr nc,labA14B
    rst 56
    ret nc
    jr nc,labA170
labA138 jr labA15A
    nop
    ex af,af''
    dec a
    ld b,254
    ret nz
labA140 dec c
    ret m
    ld h,b
    jr labA1C4
    or b
    djnz labA148
labA148 djnz labA17A
    nop
labA14B jr labA189
    ld b,254
    ret nz
    dec c
    ld a,a
    ld h,b
    jr labA155
labA155 jr nc,labA167
    nop
    djnz labA1A6
labA15A ld bc,lab00BB
    inc bc
    ld a,l
    add a,b
    ld b,0
    ret nz
    inc c
    nop
    ld h,b
    ld l,(hl)
labA167 nop
    jr c,labA16A
labA16A nop
    jr c,labA16D
labA16D nop
    ld a,h
    nop
labA170 nop
    cp 0
    ld bc,lab0082+1
    inc bc
    ld bc,lab6C7F+1
labA17A nop
    jr z,labA17D
labA17D nop
    jr z,labA180
labA180 nop
    ld l,h
    nop
    nop
    add a,0
    ld d,h
    ld d,e
    ld b,a
labA189 ld d,d
    ld b,h
    ld d,e
    ld b,a
    ld d,d
    ld d,h
    ld c,d
    ld c,l
    ld b,l
labA192 nop
    ex af,af''
    ld d,b
    jr c,labA19E+1
    ret m
    rst 48
    nop
    nop
    nop
    nop
    nop
labA19E ld a,1
    dec a
    jr nz,labA1D9
labA1A3 ld a,(labB7F3)
labA1A6 or a
    ret nz
    ld a,16
labA1AA ld (labB7F1),a
    ld a,(labB7F2)
    xor 8
    ld (labB7F2),a
    ld b,a
labA1B6 ld a,(labB79B)
    bit 4,a
    ld a,b
    jr z,labA1BF
    xor a
labA1BF ld d,1
    call lab9F59
labA1C4 ld hl,lab4C5D
    ld a,l
    ld l,h
    ld h,a
    ld (labB7C4+1),hl
labA1CD ld (labB791),a
    ld hl,lab2060
    ld a,l
    ld l,h
    ld h,a
    ld (labB7D0+1),hl
labA1D9 ld (labB79E+1),a
    ld a,(labB7F1)
    or a
    ret z
labA1E1 dec a
    ld (labB7F1),a
    ld b,a
    ld a,(labB7F3)
    or a
    ret nz
    ld a,b
    ld d,8
    jp lab9F59
    nop
    rrca 
    nop
    cp 9
    call nz,lab04CC+1
    jp lab38A5
    ex (sp),hl
    inc hl
    inc hl
    ld e,(hl)
    nop
    nop
    ld bc,lab010F
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    rrca 
    ex af,af''
    nop
    ret p
    ld (hl),b
labA218 ret nz
    ret p
    ret p
    jr nc,labA1CD
    add a,b
    ld (hl),b
    djnz labA1E1
    ret po
    ret nz
    jr nc,labA1A3+2
    ret p
    jr nc,labA1B6+2
    ret nz
    jr nc,labA1AA+1
    ld bc,lab030F
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ex af,af''
    rrca 
    ex af,af''
    nop
    nop
    nop
labA241 rlca 
    ld b,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    ld c,15
    dec bc
    ex af,af''
    nop
    ld h,b
    ret po
    ret p
    jr nc,labA2BC
    nop
    jr nc,labA29F
labA25F jr nz,labA241
    nop
    jr nc,labA273+1
    add a,b
    jr nc,labA287
    ld b,b
    ld (hl),b
    ret nz
    ld bc,lab0F0D
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
labA273 ld c,14
    nop
    inc bc
    rlca 
    inc bc
    add hl,bc
    dec c
    ex af,af''
    nop
    ld b,14
    nop
    inc bc
    rlca 
    nop
    nop
    ld (labFFFE+1),hl
labA287 ld h,(hl)
    rst 56
    rst 56
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    inc bc
    dec bc
    jr labA218
labA298 inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
labA29F rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    inc e
    ret p
    add a,c
    dec c
    inc c
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    nop
    nop
    or b
    ret p
    ret p
    ret p
labA2BA ret p
    and b
labA2BC nop
    nop
    ld c,12
    ld c,12
    nop
    nop
    xor d
    rst 56
    xor 255
    rst 56
    rst 56
    ld h,(hl)
    nop
    nop
    ld bc,lab0A0D
    ld c,14
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld bc,lab0F0D
    dec c
    inc c
    nop
    nop
    nop
    rlca 
    rlca 
    dec b
    dec bc
    ex af,af''
    nop
    nop
    nop
    djnz labA298
    ret p
    ret p
    or b
    nop
    nop
    nop
    inc bc
    rlca 
    ld b,14
    nop
    nop
    nop
    ld (labFFBB),hl
    rst 56
    xor 136
    nop
    ld bc,lab0D0D
    rlca 
    ld b,7
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab060E
    ld c,11
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    jr nc,labA2BA
    nop
    nop
    nop
    nop
    rlca 
    ld b,1
    dec c
    ex af,af''
    nop
    nop
    nop
    nop
    inc sp
    adc a,b
    nop
    nop
    ld bc,lab0C0D
    ld c,7
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    ld c,0
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    dec c
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    rlca 
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    ld bc,lab080B
    nop
    ld bc,lab0E0E
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    ld a,(bc)
    ld c,0
    ld c,14
    ld c,0
    nop
    nop
    nop
    nop
    rlca 
    nop
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    rlca 
    nop
    rlca 
labA3AC dec b
    inc c
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    ld (bc),a
    nop
    nop
    nop
    rlca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA3F8 nop
    nop
    nop
    nop
    nop
    nop
    nop
labA3FF nop
    nop
    nop
    nop
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
labA411 rrca 
    ld c,2
    nop
    nop
    nop
    ret p
    ret p
    ld h,b
    jr nc,labA3AC
    ret p
    djnz labA3FF
    ret p
    sub b
    ret p
    sub b
    ret p
    ret po
labA425 ret p
    ld (hl),b
    nop
    ld (hl),b
    ret po
    nop
    nop
    inc b
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,3
    rrca 
    rrca 
    rrca 
    rrca 
labA439 rrca 
    rrca 
    inc c
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    ld a,(bc)
    ld c,0
    nop
    djnz labA439
    ret po
    jr nc,labA48B+1
    nop
    ret nz
    ld h,b
    jr nc,labA411
    add a,b
    ld h,b
    djnz labA425
    ret po
    jr nc,labA3F8
    ret nz
    nop
    nop
    rlca 
    dec b
    inc c
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    nop
    rlca 
    rlca 
    dec c
    inc c
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    ld bc,lab080B
    nop
    ld de,labFF55
    nop
    ld (hl),a
    adc a,b
    nop
labA48B ld bc,lab0C0D
    rlca 
    rlca 
    ld b,3
    dec bc
    ex af,af''
    ld c,14
    nop
    ld (hl),b
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld (hl),b
    nop
    ret po
    rlca 
    rlca 
    ld bc,lab0C0D
    ld b,14
    ld c,3
    dec bc
    ex af,af''
    nop
    inc c
    nop
    nop
    nop
    nop
labA4BB ld b,0
    ld bc,lab080D
    ld b,12
    nop
    nop
    ld d,l
    rst 56
    ld (ix-1),a
    xor 238
    nop
    ld bc,lab0E0E
    rlca 
    inc bc
labA4D1 dec bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    nop
    jr nz,labA4DD
labA4DD jr nz,labA4DF
labA4DF jr nz,labA4E1
labA4E1 jr nz,labA4E3
labA4E3 jr nz,labA4E5
labA4E5 jr nz,labA4ED+1
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
labA4ED ld bc,lab0C0D
    ld c,7
    rlca 
    ex af,af''
    nop
    nop
    jr nz,labA546+2
    ret p
    ret p
    ret po
    add a,b
    nop
    nop
    inc bc
    ld b,14
    inc c
    nop
    nop
    ld de,labFF55
    rst 56
    rst 56
    cp e
    adc a,b
    nop
    nop
    ld c,14
    inc b
    dec bc
    dec bc
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    and b
    ld h,b
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    dec c
    dec c
    ld (bc),a
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    ret p
    ret po
    nop
    nop
    nop
    nop
    inc bc
    rlca 
    inc bc
    dec bc
    nop
    nop
    nop
    nop
labA546 ld de,labEE76+1
    nop
    nop
    nop
    ld c,14
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab0F0D
    rrca 
    rrca 
    rrca 
    rrca 
    add hl,bc
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    rrca 
    ld (bc),a
    nop
    nop
    nop
    nop
    dec c
    inc c
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    rlca 
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    nop
    ld c,14
    ld c,3
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
labA5FF nop
labA600 ld b,16
labA602 push bc
    ld ix,lab8021
    ld b,3
labA609 push bc
    bit 3,(ix+15)
    jr z,labA623
    dec (ix+63)
    jr nz,labA623
    ld a,(ix+66)
    ld (ix+63),a
    ld a,(ix+51)
    call lab9E90
    jr labA629
labA623 ld bc,lab0032
    call lab9FEB
labA629 pop bc
    inc ix
    djnz labA609
    ld bc,lab004F+1
    call lab9FEB
    pop bc
labA635 djnz labA602
    ret 
labA638 ld hl,lab621A
    add hl,de
    xor d
    jr labA635
    rla 
    ld b,a
    rla 
    sbc a,l
    ld d,249
    dec d
    ld e,b
    dec d
    cp l
    inc d
    ld h,20
    sub e
    inc de
    inc b
    inc de
    ld a,d
    ld (de),a
    di
    ld de,lab1170
    pop af
    djnz labA6CF
labA659 djnz labA659
    rrca 
    adc a,c
    rrca 
    jr labA66F
    xor d
    ld c,63
    ld c,215
    dec c
    ld (hl),d
    dec c
labA668 ld de,lab3E0D
    ld bc,labF232
    sbc a,a
labA66F ld hl,lab9FF2+1
    ld (lab0038+1),hl
    ei
labA676 halt
    ld b,245
    in a,(c)
    rra 
    jr nc,labA676
    di
labA67F call lab9F07
    call labA600
    ld a,(lab9FF2)
    or a
    jr z,labA696
    call labA6BF
    jr c,labA67F
    xor a
    ld (lab9FF2),a
    jr labA67F
labA696 call labA6BF
    jr nc,labA67F
    ld hl,labA6A3
    ld (lab0038+1),hl
    ei
    ret 
labA6A3 push af
    push hl
    push de
    push bc
    ld b,245
    in a,(c)
    rra 
    jr nc,labA6B9
    push ix
    ex af,af''
    push af
    call lab9F07
    pop af
    ex af,af''
    pop ix
labA6B9 pop bc
    pop de
    pop hl
    pop af
    ei
    ret 
labA6BF call labA753
    ld a,73
labA6C4 push af
    out (c),a
    ld a,244
    in a,(0)
    inc a
    jr nz,labA6D8
    pop af
labA6CF dec a
    jp p,labA6C4
    call labA76C
    xor a
    ret 
labA6D8 dec a
    ld e,a
    cpl 
    ld d,a
    ld a,255
labA6DE inc a
    srl e
    jr c,labA6DE
    ld e,a
    pop af
    ld c,a
    add a,a
    add a,a
    add a,a
    or e
    ld hl,labA700
    call labA6F9
    push af
    call labA76C
    pop af
    ld b,c
    scf
    ret 
labA6F8 add a,a
labA6F9 add a,l
    ld l,a
    ld a,(hl)
    ret nc
    inc h
    ld a,(hl)
    ret 
labA700 add a,b
    add a,c
    add a,d
    add hl,sp
    ld (hl),51
    dec c
    ld l,131
    add a,h
    scf
    jr c,labA740+2
    ld sp,lab3032
    add a,l
    ld e,e
    dec c
    ld e,l
    inc (hl)
    add a,(hl)
    ld e,h
    add a,a
    ld e,(hl)
    dec l
    ld b,b
    ld d,b
    dec sp
    ld a,(lab2E2F)
    jr nc,labA75A+1
    ld c,a
    ld c,c
    ld c,h
    ld c,e
    ld c,l
    inc l
    jr c,labA760+1
    ld d,l
    ld e,c
    ld c,b
    ld c,d
    ld c,(hl)
    jr nz,labA766+1
    dec (hl)
    ld d,d
    ld d,h
    ld b,a
    ld b,(hl)
    ld b,d
    ld d,(hl)
    inc (hl)
    inc sp
    ld b,l
    ld d,a
    ld d,e
    ld b,h
    ld b,e
    ld e,b
labA740 ld sp,lab8832
    ld d,c
    adc a,c
    ld b,c
    adc a,d
    ld e,d
    adc a,e
    adc a,h
    adc a,l
    adc a,(hl)
    adc a,a
    sub b
    sub c
    sub d
labA750 nop
labA751 nop
    nop
labA753 ld b,244
    ld a,14
    ld (labB7F3),a
labA75A out (c),a
    ld b,246
    ld a,192
labA760 out (c),a
    xor a
    out (c),a
    inc b
labA766 ld a,146
    out (c),a
    dec b
    ret 
labA76C inc b
    ld a,130
    out (c),a
    xor a
    ld (labB7F3),a
    ret 
labA776 call labA753
    ld hl,labA7D9
    ld c,0
    call labA7BB
    jr nz,labA785
    set 4,c
labA785 call labA7BB
    jr nz,labA78C
    set 3,c
labA78C call labA7BB
    jr nz,labA795
    ld a,12
    xor c
    ld c,a
labA795 call labA7BB
    jr nz,labA79C
    set 1,c
labA79C call labA7BB
    jr nz,labA7A5
    ld a,3
    xor c
    ld c,a
labA7A5 call labA76C
    ld a,(labA750)
    add a,a
    jr nc,labA7B2
    ld a,1
    xor c
    ld c,a
labA7B2 ld a,(labA751)
    ld b,a
    ld (labA751),bc
    ret 
labA7BB ld a,(hl)
    inc hl
    out (c),a
    ld a,244
    in a,(0)
    and (hl)
    inc hl
    ld a,0
    out (c),a
    ret 
labA7CA call labA753
    ld hl,labA7E3
    call labA7BB
    push af
    call labA76C
    pop af
    ret 
labA7D9 ld b,l
    add a,b
    ld c,b
    jr nz,labA826
    add a,b
    ld b,l
    ld b,b
    ld b,h
    ld b,b
labA7E3 ld b,e
    ex af,af''
labA7E5 ld b,l
    add a,b
    ld c,b
    jr nz,labA832
    add a,b
    ld b,l
    ld b,b
    ld b,h
    ld b,b
    ld b,e
    ex af,af''
labA7F1 ld c,c
    djnz labA83D
    ld bc,lab0249
    ld c,c
    inc b
    ld c,c
    ex af,af''
    ld b,e
    ex af,af''
    db 221
    db 238
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA819 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA826 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA832 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA83D nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA85A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 8
    push hl
    and h
    rst 8
    ld d,b
    and l
    rst 8
    ld d,a
    and l
    rst 8
    and b
    and l
    rst 8
    jr labA819
    rst 8
    rlca 
    and (hl)
    rst 8
    inc bc
    and (hl)
    rst 8
    cp 164
    rst 8
    ld a,a
    and l
    rst 8
    sbc a,c
    and l
    rst 8
    add a,165
    rst 8
    ld d,e
    and (hl)
    rst 8
    sub d
    and (hl)
    jr nc,labA85A
    rlca 
    nop
    nop
    inc h
    nop
    inc bc
    rlca 
    nop
    or e
    nop
    ccf 
    nop
    ret nz
    nop
    djnz labA89D
labA89D nop
    nop
    pop bc
    add hl,bc
    ld hl,(labE552)
    ld (bc),a
    inc b
    dec bc
    rst 56
    nop
    add a,(hl)
labA8AA add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    ret m
    nop
    nop
    nop
labA8C3 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc h
    nop
    inc bc
labA8D3 rlca 
    nop
    xor d
    nop
    ccf 
    nop
    ret nz
    nop
    djnz labA8DD
labA8DD ld (bc),a
    nop
    ld b,c
    add hl,bc
    ld hl,(labE552)
    ld (bc),a
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labA900 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    nop
    nop
    nop
    nop
    nop
    jr nc,labA8C3
    sub b
    xor b
    xor c
    xor b
    cp c
    xor b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,labA8D3
    ret nc
    xor b
    jp (hl)
    xor b
    ld sp,hl
    xor b
    nop
    ld d,h
    ld c,b
    ld b,c
    ld c,(hl)
    ld b,c
    ld d,h
    ld c,a
    ld d,e
    ld b,d
    ld c,c
    ld c,(hl)
    nop
    nop
    nop
    ld h,a
    ld (bc),a
    inc bc
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,0
    nop
    nop
    nop
    ld d,h
    ld c,b
    ld b,c
    ld c,(hl)
    ld b,c
    ld d,h
    ld c,a
    ld d,e
    ld c,d
    push bc
    ld d,l
    nop
    nop
    nop
    add a,b
    rrca 
    djnz labA974
    ld (de),a
    inc de
    inc d
    dec d
    ld d,23
    jr labA983+1
    ld a,(de)
    dec de
    inc e
    dec e
    ld e,0
    ld d,h
    ld c,b
    ld b,c
labA974 ld c,(hl)
    ld b,c
    ld d,h
    ld c,a
    ld d,e
    ld c,d
    push bc
    ld d,l
    ld bc,lab0000
    add a,b
    rra 
    jr nz,labA9A3+1
labA983 ld (lab2423),hl
    dec h
    ld h,39
    jr z,labA9B4
    ld hl,(lab2C2B)
    dec l
    ld l,0
    ld d,h
    ld c,b
    ld b,c
    ld c,(hl)
    ld b,c
    ld d,h
    ld c,a
    ld d,e
    ld c,d
    push bc
    ld d,l
    ld (bc),a
    nop
    nop
    ld l,47
    jr nc,labA9D2+2
labA9A3 ld (lab3433),a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    ld c,7
labA9B4 rlca 
    inc bc
    inc bc
    ld bc,lab0000+1
    nop
    rst 56
    rst 56
    nop
    rst 56
    rst 56
    ld e,b
    ld c,(hl)
    nop
    inc b
    ld a,b
    adc a,h
    ld (bc),a
    ld bc,lab4025
    push de
    ex de,hl
    ld a,e
    and 31
    dec de
    cp 4
labA9D2 ld hl,lab95F0
    ld de,labBE7F+1
    ld bc,lab0080
    ldir
    jp labBE7F+1
    ld hl,labA5FF
    ld ix,lab95E1
    ld bc,lab0AFE+1
labA9EA ld a,(ix-3)
    cp 88
    jr z,labAA22
labA9F1 ld a,(ix+0)
    ld (hl),a
    dec hl
labA9F6 dec ix
    push af
    ld a,h
    cp b
    jr nz,labAA01
    ld a,l
    cp c
    jr z,labAA04
labAA01 pop af
    jr labA9EA
labAA04 pop af
    jp lab5DA4
    ld de,lab0040
    ld b,8
    call labBC77
    push de
    push hl
    pop ix
    ld b,(ix+27)
    ld c,(ix+26)
    pop hl
    push bc
    call labBC83
    jp labBC7A
labAA22 ld a,(ix-2)
    cp 78
    jr nz,labA9F1
    push bc
    ld b,(ix+0)
    ld a,(ix-1)
labAA30 ld (hl),a
    dec hl
    djnz labAA30
    pop bc
    dec ix
    dec ix
    dec ix
    jr labA9F6
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labAA48 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labAA55
    
    START:
	ld bc,#7f8d
  	out (c),c
	ld hl,crtc_regs
    ld b,#bc
.lp
	ld a,(hl)
    or a
    jr z,.end
    out (c),a
    inc b
    inc hl
    ld a,(hl)
    out (c),a
    dec b
    inc hl
    jp .lp	
.end	
	jp #5e6e
    
crtc_regs:
	db 1,#20,2,#2b,6,24,7,#1d

org #AAAA
labAAAA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labABCC nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labABE1 nop
    nop
    nop
    nop
    nop
    nop
    nop
labABE8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0F0F
    rrca 
    rrca 
labAC08 rrca 
    rrca 
    rrca 
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,7
    nop
    nop
    jr nc,labAC08
    ret po
    ret po
labAC1A jr nc,labABCC
    ret p
    add a,b
    ret p
    jr nc,labABE1
    ret p
    ret nz
    ld (hl),b
    ret po
labAC25 ret p
    ld (hl),b
    nop
    ret p
    ret p
    nop
    nop
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
labAC39 rrca 
    rrca 
    rrca 
    ex af,af''
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    rlca 
    rlca 
    nop
    ld c,14
    rlca 
    rlca 
    rlca 
    nop
    nop
    jr nc,labAC39
    ret po
    or b
    ld (hl),b
    nop
    ret po
    ld h,b
    jr nc,labACD1
    nop
    ld (hl),b
    djnz labAC25
    ld h,b
    jr nc,labAC76+2
    ret po
    nop
    nop
    ld c,14
    ld c,7
    rlca 
    nop
    ld c,14
    rlca 
    rlca 
    nop
labAC76 ld bc,lab080B
    inc bc
    dec bc
    nop
    ld bc,lab0C0D
    nop
    inc bc
    dec bc
    nop
    nop
    ld (labFFBB),hl
    adc a,b
    cp e
    call z,lab0000
    ld c,14
    rlca 
    rlca 
    ld (bc),a
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    ret po
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    jr c,labAC39
    ret nz
    ld c,14
    nop
    ld c,14
    inc b
    ld c,14
    rlca 
    rlca 
    nop
    nop
    add a,b
    nop
    ret p
    ret nz
    nop
    jr nz,labACBD
labACBD nop
    dec c
    inc c
    ld c,12
    nop
    nop
    xor d
    rst 56
    rst 56
    ld (hl),a
    rst 56
    xor 238
    nop
    nop
    inc c
    rrca 
    rlca 
    rlca 
labACD1 rlca 
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    inc bc
    dec bc
    ex af,af''
labACE9 ld c,14
    nop
    nop
    nop
    ld c,14
    ld c,15
    inc bc
    nop
    nop
    nop
    jr nc,labAD28
    ret p
    ret p
    ret nc
    add a,b
    nop
    nop
    inc bc
    rlca 
    ld c,12
    nop
    nop
    nop
    xor d
    rst 56
    rst 56
    rst 56
    db 221
    db 136
    nop
    nop
    ld c,14
    ld c,15
    inc bc
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ret po
    ld h,b
    ret po
    ld h,b
    ret po
    ld h,b
    ret po
    ld h,b
    ret po
    ld h,b
    ret po
    ld h,b
    inc bc
    dec bc
labAD28 ex af,af''
    ld c,14
    nop
    nop
    nop
    inc c
    rrca 
    rlca 
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    ret nz
    nop
    nop
    nop
    nop
    inc bc
    rlca 
    inc bc
    dec bc
    nop
    nop
    nop
    nop
    nop
    rst 56
    xor 0
    nop
    nop
    ld c,14
    inc b
    ld c,14
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    dec bc
    ld a,(bc)
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    rlca 
    rlca 
    ld (bc),a
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    rrca 
    ld a,(bc)
    nop
    nop
    nop
    nop
    dec c
    inc c
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    rlca 
    rlca 
    nop
    ld c,14
    rlca 
    rlca 
    rlca 
    nop
    rlca 
    dec b
    inc c
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld a,(bc)
    ld c,0
    ld c,14
    ld c,7
    rlca 
    nop
    ld c,14
    rlca 
    rlca 
    nop
    nop
    nop
    inc bc
    nop
    nop
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    ld bc,lab0F0F
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,7
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,12
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,7
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ex af,af''
    nop
    nop
    nop
labAE00 nop
    nop
labAE02 nop
    nop
labAE04 nop
    nop
labAE06 nop
    nop
labAE08 nop
labAE09 nop
labAE0A nop
labAE0B nop
labAE0C push hl
    ld h,0
    bit 7,l
    jr z,labAE14
    dec h
labAE14 ld de,(labAE00)
    add hl,de
    ld (labAE00),hl
    ld de,(labAE02)
    add a,e
    ld c,a
    pop af
    add a,d
    ld b,a
    ld (labAE02),bc
    ex de,hl
    call lab8FB6
    jr nc,labAE35
    ld a,64
    ld (labAE09),a
    ret 
labAE35 ld l,c
    ld h,0
    bit 7,l
    jr z,labAE3D
    dec h
labAE3D add hl,hl
    add hl,hl
    add hl,hl
    or l
    ld l,a
    ld a,c
    cp 64
    jr c,labAE4E
labAE47 ld a,(labAE09)
    cp 64
    ccf 
    ret c
labAE4E ld de,(labAE04)
    ld (labAE04),hl
    or a
    sbc hl,de
    ld de,labAF3C
    jp p,labAE65
    ld de,labAF42
    ld a,l
    neg
    ld l,a
labAE65 ld a,(labAE0A)
    ld c,a
    ld a,b
    ld (labAE0A),a
    sub c
    ld bc,labAF4D
    jr nc,labAE78
    ld bc,labAF48
    neg
labAE78 exx
    ld hl,(labAE06)
    ld bc,(labAE08)
    exx
    ex af,af''
    ld a,(labAE0B)
    ld iyl,a
    ex af,af''
    cp l
    jr nc,labAE97
    ld (labAEB5+1),de
    ld (labAEB2+1),bc
    ld b,l
    ld l,a
    jr labAEA0
labAE97 ld (labAEB5+1),bc
    ld (labAEB2+1),de
    ld b,a
labAEA0 ld h,b
    ld c,b
    srl c
    inc b
    exx
    jr labAEB8
labAEA8 add a,l
    jr c,labAEAE
    cp h
    jr c,labAEB0
labAEAE sub h
    or a
labAEB0 ld c,a
    exx
labAEB2 call nc,lab0000
labAEB5 call lab0000
labAEB8 ld a,b
    cp 64
    jr nc,labAEC8
    ld a,iyl
    cp 131
    jr nc,labAEC8
    ld a,c
labAEC4 and 255
    or (hl)
    ld (hl),a
labAEC8 exx
    ld a,c
    djnz labAEA8
    exx
    ld (labAE06),hl
    ld (labAE08),bc
    ld a,iyl
    ld (labAE0B),a
    or a
    ret 
labAEDB ld (labAE00),de
    ld (labAE02),bc
    ld a,(lab0046+2)
    ld hl,labAF52
    call labA6F9
    ld (labAEC4+1),a
    call lab8FB6
    ret c
    ld l,c
    sla c
    bit 2,a
    jr z,labAEFB
    inc c
labAEFB ld (labAE09),bc
    ld c,l
labAF00 ld h,0
    bit 7,l
    jr z,labAF07
    dec h
labAF07 add hl,hl
    add hl,hl
    add hl,hl
    or l
    ld l,a
    ld (labAE04),hl
    and 7
    or 0
    ld l,a
    ex af,af''
    ld h,190
    ld a,(hl)
    ld (labAE08),a
    call lab87B7
    ld a,l
    sla c
    sub c
    ld l,a
    ld b,0
    bit 7,c
    jr z,labAF2A
    dec b
labAF2A add hl,bc
    ex af,af''
    bit 2,a
    jr z,labAF31
    inc l
labAF31 ld (labAE06),hl
    ld a,(labAE0A)
    ld (labAE0B),a
    or a
    ret 
labAF3C rrc c
    ret nc
    inc b
    inc hl
    ret 
labAF42 rlc c
    ret nc
    dec b
    dec hl
    ret 
labAF48 dec iyl
    jp lab87D5
labAF4D inc iyl
    jp lab87E9
labAF52 rrca 
    ret p
    rst 56
labAF55 push af
    push bc
    push hl
    ld hl,labB786
    ld b,245
    in a,(c)
    rra 
labAF60 ld a,0
    jr nc,labAF98
labAF64 ld a,0
    inc a
    ld (labAF64+1),a
labAF6A ld a,0
    or a
    jr z,labAF8B
    ld b,188
    ld a,12
    out (c),a
    inc b
    ld a,(SCREEN_BUFFER)
    xor 64
    ld (SCREEN_BUFFER),a
    rrca 
    rrca 
    if SHOW_BACK_BUFFER!=1
    xor 16			; Show Back Buffer
    endif 
    out (c),a
    if SHOW_BACK_BUFFER==1
    xor 16			; Show Back Buffer
	endif 
    xor a
    ld (labAF6A+1),a
    call lab8EB2
labAF8B push de
    push hl
    call labB79E
    pop hl
    pop de
    xor a
    ld (labAF60+1),a
    jr labAFA8
labAF98 inc a
    ld (labAF60+1),a
    ld l,138
    cp 3
    jr z,labAFA8
    cp 4
    jr nz,labAFC5
    ld l,142
labAFA8 ld b,127
    xor a
    out (c),a
    ld c,(hl)
    out (c),c
    inc l
    inc a
    out (c),a
    ld c,(hl)
    out (c),c
    inc l
    inc a
    out (c),a
    ld c,(hl)
    out (c),c
    inc l
    inc a
    out (c),a
    ld c,(hl)
    out (c),c
labAFC5 push de
labAFC6 ld a,0
    or a
    jr z,labAFFA
    dec a
    ld (labAFC6+1),a
    jr nz,labAFEA
    ld a,(labB7F3)
    or a
    jr z,labAFDE
    ld a,1
    ld (labAFC6+1),a
    jr labAFFA
labAFDE ld d,7
    call lab9F6B
    or 36
    call lab9F59
    jr labAFFA
labAFEA ld a,0
    or a
    jr z,labAFFA
    ld b,a
labAFF0 ld hl,lab0000
    ld a,(labB7F3)
    or a
    call z,lab8E00
labAFFA pop de
    pop hl
    pop bc
    pop af
labAFFE ei
    ret 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    xor (hl)
    ld a,e
    sub (hl)
    ld a,e
    sub (hl)
    dec b
    ld a,h
    sub (hl)
    ld a,h
    and (hl)
    nop
    ret p
    ld a,(hl)
    or b
    ex af,af''
    ld b,d
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ex af,af''
    ld b,d
    nop
    inc bc
    ld a,(hl)
    or b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB0AA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB0EF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB0FA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b,83
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,c
    adc a,e
    jr nz,labB1F8
labB1F8 nop
    ld bc,lab0008
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab1002
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (bc),a
    inc b
    jr nz,labB27A
labB27A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ccf 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB395 nop
    nop
    nop
    nop
    nop
    nop
labB39B nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB3E1 nop
    nop
    nop
    nop
labB3E5 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    ld c,3
labB40D ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    ld (hl),b
    ret p
    ret po
    ret p
    ld (hl),b
    jr nc,labB40D
    add a,b
    ld (hl),b
    djnz labB3E1
    ret p
    ret nz
    jr nc,labB3E5
    ret p
    ld (hl),b
    sub b
    ret po
    ld (hl),b
    add a,b
    nop
    ld c,3
    ex af,af''
    nop
    nop
    nop
    ld bc,lab070C
    nop
    nop
    nop
    nop
labB439 nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    rlca 
    nop
    nop
    jr nc,labB439
    ret p
    or b
    ld h,b
    nop
    ld h,b
    ld b,b
    jr nz,labB4D1
    nop
    ld (hl),b
    djnz labB3E5
    ld (hl),b
    jr nc,labB468
labB468 ret p
    nop
    nop
    ld c,14
    ld c,3
    dec bc
    add hl,bc
    dec c
    inc c
    rlca 
    rlca 
    nop
    ld bc,lab000B+1
    nop
    rlca 
    nop
    nop
    ld c,14
    nop
    inc bc
    dec bc
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    ld (ix-18),a
    nop
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    ret nz
labB498 ld bc,lab0F0D
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec bc
    jr labB498+1
    ret nz
    ld c,14
    nop
    ld c,14
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    nop
    add a,b
    ret p
    ret p
    ret p
labB4BA ret po
    jr nz,labB4BD
labB4BD nop
    dec c
    inc c
    ld c,12
    nop
labB4C3 nop
    ld d,l
    rst 56
    xor 255
    rst 56
    rst 56
    ld h,(hl)
    nop
    nop
    dec c
    dec c
    ld (bc),a
    rlca 
labB4D1 rlca 
    nop
    nop
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    nop
    nop
    ld c,14
    inc b
    dec bc
    dec bc
    nop
    nop
    nop
    djnz labB548
    ret p
    ret p
    ret nc
    nop
    nop
    nop
    inc bc
    rlca 
    ld b,12
    nop
    nop
    nop
    ld d,l
    ld (hl),a
    rst 56
    rst 56
    db 221
    db 136
    nop
    ld bc,lab0C0D
    ld c,7
    rlca 
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab0E0E
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    jr nc,labB4BA
    nop
    nop
    nop
    nop
    inc bc
    ld b,1
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    ld (hl),a
labB548 call z,lab0000
    ld bc,lab0C0D
    ld b,14
    ld c,3
    dec bc
    ex af,af''
    ld c,14
    nop
    inc b
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc bc
    add hl,bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    ld (bc),a
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    rlca 
    rlca 
    ld b,3
    dec bc
    ex af,af''
    nop
    nop
    nop
    rrca 
    ld c,0
    nop
    nop
    ld bc,lab080D
    nop
    ld bc,lab0C0D
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    ld a,(bc)
    ld c,0
    rlca 
    dec b
    inc c
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld a,(bc)
    ld c,0
    rlca 
    dec b
    inc c
    rlca 
    rlca 
    nop
    ld c,14
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    inc bc
    nop
    nop
    nop
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    inc bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,3
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    inc c
    nop
    nop
    nop
    nop
labB600 nop
labB601 inc b
labB602 ld a,(labB600)
labB605 cp 0
    ret z
    ld a,(labB605+1)
    jr c,labB616
    inc a
    ld (labB605+1),a
labB611 ld hl,labB6A1
    jr labB62D
labB616 ld hl,labB68E
    dec a
    ld (labB605+1),a
    jr z,labB62D
    ld b,a
labB620 ld a,(hl)
    and 7
    ld d,a
    add a,a
    add a,d
    inc a
    ld e,a
    ld d,0
    add hl,de
    djnz labB620
labB62D ex de,hl
    ld a,(de)
    rra 
    rra 
labB631 rra 
    and 31
    add a,154
    ld b,a
    ld c,27
    call lab87B7
    ld a,(de)
    inc de
    and 7
    ld c,a
    push hl
    push de
    push bc
    call labB656
    pop bc
    pop de
    pop hl
    ld a,64
    xor h
    ld h,a
    call labB656
    ld (labB611+1),de
    ret 
labB656 push hl
    ld b,3
labB659 ld a,(de)
    push de
    ld d,214
    ld e,a
    ld a,(de)
    ld (hl),a
    inc l
    inc d
    ld a,(de)
    ld (hl),a
    pop de
    inc de
    inc l
    djnz labB659
    pop hl
    call lab87D5
    dec c
    jr nz,labB656
    ret 
labB671 neg
labB673 add a,8
    ld (labB673+1),a
    ret c
    ld a,(labB601)
    add a,a
    neg
    add a,18
    add a,a
    add a,a
    ld (labB673+1),a
    ld a,(labB600)
    inc a
    ld (labB600),a
    ret 
labB68E ld b,85
    rst 0
    call p,lab3848
    inc (hl)
    out (255),a
    sub (hl)
    cp a
    rst 56
    jp m,labFF8E+1
    jp po,labFC80
    ld (bc),a
labB6A1 rrca 
    ld l,e
    rst 56
    call pe,labC755
    call p,lab3848
    inc (hl)
    out (255),a
    sub (hl)
    xor a
    rst 56
    jp po,labFC80
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    rla 
    dec h
    rst 56
    ret pe
    ld l,e
    rst 0
    call pe,lab3850
    ld (hl),h
    ld b,a
    rst 56
    sub h
    rst 24
    rst 56
    or 128
    rst 56
    ld (bc),a
    add a,b
    nop
    ld (bc),a
    ld d,37
    rst 0
    ret pe
    ld l,b
    jr c,labB740
    ld b,e
    rst 56
    sub h
    ld e,a
    rst 56
    call p,labFFC0
    ld b,128
    nop
    ld (bc),a
    ld e,51
    rst 56
    ret c
    dec h
    add a,c
    ret pe
    ld h,b
    ld a,(hl)
    inc c
    ld e,a
    rst 56
    call p,labFF40
    inc b
    ret nz
    nop
    ld b,38
    dec d
    rst 56
    ret nc
    inc sp
    add a,c
    ret c
    inc h
    ld a,(hl)
    jr z,labB76D
    rst 56
    call pe,labFF40
    inc b
    ld b,b
    nop
    inc b
    ld l,26
    rst 56
    or b
    dec d
    jp lab30D0
    inc a
    jr labB738
    rst 56
    ret pe
    ld h,b
    ld a,(hl)
    inc c
    ld b,b
    nop
    inc b
    ld (hl),13
    ld a,a
    ld h,b
    ld a,(de)
    jp lab10B0
    inc a
    djnz labB75A+1
    rst 56
    ret c
    jr nz,labB7A6
    ex af,af''
    ld h,b
    nop
    inc c
    dec (hl)
    dec c
    ld (hl),c
    ld h,b
    jr labB740
    jr nc,labB74B
    rst 56
    ret nc
    jr nc,labB770
labB738 jr labB75A
    nop
    ex af,af''
    dec a
    ld b,254
    ret nz
labB740 dec c
    ret m
    ld h,b
    jr labB7C4
    or b
    djnz labB748
labB748 djnz labB77A
    nop
labB74B jr labB789
    ld b,254
    ret nz
    dec c
    ld a,a
    ld h,b
    jr labB755
labB755 jr nc,labB767
    nop
    djnz labB7A6
labB75A ld bc,lab00BB
    inc bc
    ld a,l
    add a,b
    ld b,0
    ret nz
    inc c
    nop
    ld h,b
    ld l,(hl)
labB767 nop
    jr c,labB76A
labB76A nop
    jr c,labB76D
labB76D nop
    ld a,h
    nop
labB770 nop
    cp 0
    ld bc,lab0082+1
    inc bc
    ld bc,lab6C7F+1
labB77A nop
    jr z,labB77D
labB77D nop
    jr z,labB780
labB780 nop
    ld l,h
    nop
    nop
    add a,0
labB786 ld d,h
    ld d,e
labB788 ld b,a
labB789 ld d,d
labB78A ld b,h
    ld d,e
labB78C ld b,a
    ld d,d
    ld d,h
    ld c,d
    ld c,l
labB791 ld b,l
labB792 nop
labB793 ex af,af''
labB794 ld d,b
    jr c,labB79E+1
    ret m
    rst 48
labB799 nop
    nop
labB79B nop
    nop
labB79D nop
labB79E ld a,1
    dec a
    jr nz,labB7D9
    ld a,(labB7F3)
labB7A6 or a
    ret nz
    ld a,16
    ld (labB7F1),a
    ld a,(labB7F2)
    xor 8
    ld (labB7F2),a
    ld b,a
    ld a,(labB79B)
    bit 4,a
    ld a,b
    jr z,labB7BF
    xor a
labB7BF ld d,1
    call lab9F59
labB7C4 ld hl,lab4C5D
    ld a,l
    ld l,h
    ld h,a
    ld (labB7C4+1),hl
    ld (labB791),a
labB7D0 ld hl,lab2060
    ld a,l
    ld l,h
    ld h,a
    ld (labB7D0+1),hl
labB7D9 ld (labB79E+1),a
    ld a,(labB7F1)
    or a
    ret z
    dec a
    ld (labB7F1),a
    ld b,a
    ld a,(labB7F3)
    or a
    ret nz
    ld a,b
    ld d,8
    jp lab9F59
labB7F1 nop
labB7F2 rrca 
labB7F3 nop
    cp 9
    call nz,lab04CC+1
    jp lab38A5
    ex (sp),hl
    inc hl
    inc hl
    ld e,(hl)
    dec c
    nop
    nop
    nop
    ld a,(bc)
    and b
    ld e,(hl)
    and c
    ld e,h
    and d
    ld a,e
    and e
    inc hl
    and (hl)
    ld b,b
    xor e
    ld a,h
    xor h
    ld a,l
    xor l
    ld a,(hl)
    xor (hl)
    ld e,l
    xor a
    ld e,e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ei
    or a
labB831 nop
    ret p
    cp a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,l
    inc bc
    rlc c
    sbc a,a
    rlca 
    rst 56
    ld a,(bc)
    call nc,labF8B7
    or a
    ld a,h
    dec c
    ld de,labFD02
    or a
    cpl 
    ld bc,lab0AFE+1
    nop
    cp a
    ret nc
    inc c
    ld c,a
    add hl,bc
    nop
    nop
    nop
labB8B9 ld sp,hl
    or a
    nop
    nop
    nop
    nop
labB8BF inc bc
labB8C0 nop
labB8C1 nop
labB8C2 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call m,lab00A5+1
labB8D6 rst 56
    dec l
    and d
labB8D9 rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    and a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labB8FF nop
    jp labBA5F
    jp labBA66
    jp labBA51
    jp labBA58
    jp labBA70
    jp labBA79
    jp labBA9D
    jp labBA7E
    jp labBA87
    jp labBAA1
    jp labBAA7
    ld a,(labB8C1)
    or a
    ret z
    push hl
    di
    jr labB930
    ld hl,labB8BF
    ld (hl),1
    ret 
labB930 ld hl,(labB8C0)
    ld a,h
    or a
    jr z,labB93E
    inc hl
    inc hl
    inc hl
    ld a,(labB8C2)
    cp (hl)
labB93E pop hl
    ei
labB940 ret 
labB941 di
    ex af,af''
    jr c,labB978
    exx
    ld a,c
    scf
    ei
    ex af,af''
    di
    push af
    res 2,c
    out (c),c
    call lab00B1
labB953 or a
    ex af,af''
    ld c,a
    ld b,127
    ld a,(labB831)
    or a
    jr z,labB972
    jp m,labB972
    ld a,c
    and 12
    push af
    res 2,c
    exx
    call lab0109+1
    exx
    pop hl
    ld a,c
    and 243
    or h
    ld c,a
labB972 out (c),c
    exx
    pop af
    ei
    ret 
labB978 ex af,af''
    pop hl
    push af
    set 2,c
    out (c),c
    call lab003B
    jr labB953
labB984 di
    push hl
    exx
    pop de
    jr labB990
labB98A di
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
labB990 ex af,af''
    ld a,d
    res 7,d
    res 6,d
    rlca 
    rlca 
labB998 rlca 
    rlca 
    xor c
    and 12
    xor c
    push bc
    call labB9B0
    di
    exx
    ex af,af''
    ld a,c
    pop bc
labB9A7 and 3
    res 1,c
    res 0,c
    or c
    jr labB9B1
labB9B0 push de
labB9B1 ld c,a
    out (c),c
    or a
    ex af,af''
    exx
    ei
    ret 
labB9B9 di
    ex af,af''
    ld a,c
    push hl
    exx
    pop de
    jr labB9D6
labB9C1 di
    push hl
    exx
    pop hl
    jr labB9D0
labB9C7 di
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
    ex de,hl
labB9D0 ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ex af,af''
    ld a,(hl)
labB9D6 cp 252
    jr nc,labB998
labB9DA ld b,223
    out (c),a
    ld hl,labB8D6
    ld b,(hl)
    ld (hl),a
    push bc
    push iy
    cp 16
    jr nc,labB9F9
    add a,a
    add a,218
    ld l,a
    adc a,184
    sub l
    ld h,a
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    push hl
    pop iy
labB9F9 ld b,127
    ld a,c
    set 2,a
    res 3,a
    call labB9B0
    pop iy
    di
    exx
    ex af,af''
    ld e,c
    pop bc
    ld a,b
    ld b,223
labBA0D out (c),a
    ld (labB8D6),a
    ld b,127
    ld a,e
    jr labB9A7
labBA17 di
    push hl
    exx
    pop de
    jr labBA25
labBA1D di
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    push hl
labBA25 ex af,af''
    ld a,d
    set 7,d
    set 6,d
    and 192
    rlca 
    rlca 
    ld hl,labB8D9
    add a,(hl)
    jr labB9DA
labBA35 di
    exx
    pop hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    res 2,c
    out (c),c
    ld (labBA45+1),de
    exx
    ei
labBA45 call labBA45
    di
    exx
    set 2,c
    out (c),c
    exx
    ei
    ret 
labBA51 di
    exx
    ld a,c
    res 2,c
    jr labBA6B
labBA58 di
    exx
    ld a,c
    set 2,c
    jr labBA6B
labBA5F di
    exx
    ld a,c
    res 3,c
    jr labBA6B
labBA66 di
    exx
    ld a,c
    set 3,c
labBA6B out (c),c
    exx
    ei
    ret 
labBA70 di
    exx
    xor c
    and 12
    xor c
    ld c,a
    jr labBA6B
labBA79 call labBA5F
    jr labBA8D
labBA7E call labBA79
    ld a,(labC000)
    ld hl,(labC001)
labBA87 push af
    ld a,b
    call labBA70
    pop af
labBA8D push hl
    di
    ld b,223
    out (c),c
    ld hl,labB8D6
    ld b,(hl)
    ld (hl),c
    ld c,b
    ld b,a
    ei
    pop hl
    ret 
labBA9D ld a,(labB8D6)
    ret 
labBAA1 call labBAAD
    ldir
    ret 
labBAA7 call labBAAD
    lddr
    ret 
labBAAD di
    exx
    pop hl
    push bc
    set 2,c
    set 3,c
    out (c),c
    call labBAC2
labBABA di
    exx
    pop bc
    out (c),c
    exx
    ei
labBAC1 ret 
labBAC2 push hl
    exx
    ei
    ret 
labBAC6 di
    exx
    ld e,c
    set 2,e
    set 3,e
    out (c),e
    exx
    ld a,(hl)
    exx
    out (c),c
    exx
    ei
    ret 
    exx
    ld a,c
    or 12
    out (c),a
    ld a,(ix+0)
    out (c),c
    exx
    ret 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labBAFA nop
    nop
    nop
    nop
    nop
    nop
    rst 8
    ld e,h
    sbc a,e
    rst 8
    sbc a,b
    sbc a,e
    rst 8
    cp a
    sbc a,e
    rst 8
    push bc
    sbc a,e
    rst 8
    jp m,labCF9B
    ld b,(hl)
    sbc a,h
    rst 8
    or e
    sbc a,h
    rst 8
    inc b
    sbc a,h
    rst 8
    in a,(156)
    rst 8
    pop hl
    sbc a,h
    rst 8
    ld b,l
    sbc a,(hl)
    rst 8
    jr c,labBAC1
    rst 8
    push hl
    sbc a,l
    rst 8
    ret c
    sbc a,(hl)
    rst 8
    call nz,labCF9E
    sbc a,(ix-49)
    ret 
    sbc a,(hl)
    rst 8
    jp po,labCF9E
    adc a,158
    rst 8
    inc (hl)
    sbc a,(hl)
    rst 8
    cpl 
    sbc a,(hl)
    rst 8
    or 157
    rst 8
    jp p,labCF9D
    jp m,labCF9D
    dec bc
    sbc a,(hl)
    rst 8
    add hl,de
    sbc a,(hl)
    rst 8
    ld (hl),h
    sub b
    rst 8
    add a,h
    sub b
    rst 8
    ld e,c
    sub h
    rst 8
    ld d,d
    sub h
    rst 8
    cp 147
    rst 8
    dec (hl)
    sub e
    rst 8
    xor h
    sub e
    rst 8
    xor b
    sub e
    rst 8
    ex af,af''
    sub d
    rst 8
labBB6A ld d,d
    sub d
    rst 8
    ld c,a
    sub l
    rst 8
    ld e,d
    sub c
    rst 8
    ld h,l
    sub c
    rst 8
    ld (hl),b
    sub c
    rst 8
    ld a,h
    sub c
    rst 8
    add a,(hl)
    sub d
    rst 8
    sub a
    sub d
    rst 8
    halt
    sub d
    rst 8
    ld a,(hl)
    sub d
    rst 8
    jp z,labCF91
    ld h,l
    sub d
    rst 8
    ld h,l
    sub d
    rst 8
    and (hl)
    sub d
    rst 8
    cp d
    sub d
    rst 8
    xor e
    sub d
    rst 8
    ret nz
    sub d
    rst 8
    add a,146
    rst 8
    ld a,e
    sub e
    rst 8
    adc a,b
    sub e
labBBA5 rst 8
    call nc,labCF92
labBBA9 jp p,labCF92
    cp 146
    rst 8
    dec hl
    sub e
    rst 8
    call nc,labCF94
    call po,labCF90
labBBB8 inc bc
    sub c
    rst 8
    xor b
    sub l
    rst 8
    rst 16
    sub l
    rst 8
    cp 149
    rst 8
    ei
    sub l
    rst 8
    ld b,150
    rst 8
    ld c,150
    rst 8
labBBCD inc e
    sub (hl)
    rst 8
    and l
    sub (hl)
    rst 8
    jp pe,labCF96
    rla 
    sub a
    rst 8
    dec l
    sub a
    rst 8
    ld (hl),151
    rst 8
    ld h,a
    sub a
labBBE1 rst 8
    ld (hl),l
    sub a
    rst 8
    ld l,(hl)
    sub a
    rst 8
    ld a,d
    sub a
    rst 8
    add a,e
    sub a
    rst 8
    add a,b
    sub a
    rst 8
    sub a
    sub a
    rst 8
    sub h
    sub a
    rst 8
    xor c
    sub a
    rst 8
    and (hl)
    sub a
    rst 8
    ld b,b
    sbc a,c
    rst 8
    nop
    nop
    ld bc,lab010F
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    rrca 
    ex af,af''
    nop
    ret p
    ld (hl),b
labBC18 ret nz
    ret p
    ret p
    jr nc,labBBCD
    add a,b
    ld (hl),b
    djnz labBBE1
    ret po
    ret nz
    jr nc,labBBA5
    ret p
    jr nc,labBBB8
    ret nz
    jr nc,labBBA9+2
    ld bc,lab030F
    dec bc
    rrca 
    rrca 
    rrca 
    dec c
    inc c
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ex af,af''
    rrca 
    ex af,af''
    nop
    nop
    nop
labBC41 rlca 
    ld b,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
    ld c,15
    dec bc
    ex af,af''
    nop
    ld h,b
    ret po
    ret p
    jr nc,labBCBC
    nop
    jr nc,labBC9F
    jr nz,labBC41
    nop
    jr nc,labBC73+1
    add a,b
    jr nc,labBC87
    ld b,b
    ld (hl),b
    ret nz
    ld bc,lab0F0D
    rlca 
    inc bc
    dec bc
    add hl,bc
    dec c
    inc c
labBC73 ld c,14
    nop
    inc bc
labBC77 rlca 
    inc bc
    add hl,bc
labBC7A dec c
    ex af,af''
    nop
    ld b,14
    nop
    inc bc
    rlca 
    nop
labBC83 nop
    ld (labFFFE+1),hl
labBC87 ld h,(hl)
    rst 56
    rst 56
    nop
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    inc bc
    dec bc
    jr labBC18
labBC98 inc bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
labBC9F rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    inc e
    ret p
    add a,c
    dec c
    inc c
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    nop
    nop
    or b
    ret p
    ret p
    ret p
labBCBA ret p
    and b
labBCBC nop
labBCBD nop
    ld c,12
    ld c,12
    nop
    nop
    xor d
    rst 56
    xor 255
    rst 56
    rst 56
    ld h,(hl)
    nop
    nop
    ld bc,lab0A0D
    ld c,14
    nop
    nop
    nop
    inc bc
    dec bc
    rrca 
    dec bc
    ex af,af''
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld bc,lab0F0D
    dec c
    inc c
    nop
    nop
    nop
    rlca 
    rlca 
    dec b
    dec bc
    ex af,af''
    nop
    nop
    nop
    djnz labBC98
    ret p
    ret p
    or b
    nop
labBCFC nop
    nop
    inc bc
    rlca 
    ld b,14
    nop
    nop
    nop
    ld (labFFBB),hl
    rst 56
    xor 136
    nop
    ld bc,lab0D0D
    rlca 
    ld b,7
    ex af,af''
    nop
    nop
    ld c,14
    nop
    ld c,14
labBD1A ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    rlca 
    rlca 
    nop
    rlca 
    rlca 
    nop
    nop
    ld bc,lab060E
    ld c,11
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    jr nc,labBCBA
    nop
    nop
    nop
    nop
    rlca 
    ld b,1
    dec c
    ex af,af''
    nop
    nop
    nop
    nop
    inc sp
    adc a,b
    nop
    nop
    ld bc,lab0C0D
    ld c,7
    rlca 
    inc bc
    dec bc
    ex af,af''
    ld c,14
    nop
    ld c,0
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    dec c
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    rlca 
    nop
    rlca 
    rlca 
    ld bc,lab0C0D
    ld c,14
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    ld bc,lab080B
    nop
    ld bc,lab0E0E
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0C0D
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    ld a,(bc)
    ld c,0
    ld c,14
    ld c,0
    nop
    nop
    nop
    nop
    rlca 
    nop
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    rlca 
    nop
    rlca 
    dec b
    inc c
    ld c,14
    nop
    rlca 
    rlca 
    inc bc
    dec bc
    ex af,af''
    nop
    nop
    ld (bc),a
    nop
    nop
    nop
    rlca 
    rlca 
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labBE00 adc a,b
    ld b,h
    ld (lab8811),hl
    ld b,h
labBE06 ld (lab0010+1),hl
    nop
labBE0A call lab8752
    add a,l
    add a,c
    ld d,b
    ret po
    add a,h
    ld (bc),a
    add a,d
    ret p
    ret p
    ld d,h
    ld c,b
    ld b,c
    ld c,(hl)
    ld b,c
    ld d,h
    ld c,a
    ld d,e
    add a,d
    rrca 
    rrca 
    add a,c
    adc a,b
    ret z
    add a,h
    ld c,b
    ld e,h
    ld e,(hl)
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    add a,c
    ret z
    ret nc
    ld e,l
    ld e,a
    add a,c
    or h
    ret z
    add a,h
    ld c,h
    ld e,(hl)
    ld e,h
    add a,c
    call p,lab5FD0
    ld e,l
    add a,c
    ret nz
    push bc
    add a,h
    ld b,b
    ld e,h
    ld e,(hl)
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    ld h,e
    add a,h
    ld b,h
    ld e,(hl)
    ld e,h
    add a,c
    ld a,h
    db 253
    db 95
    ld e,l
    add a,c
    ret po
    push af
    ld h,b
    add a,c
    and b
labBE7F out (c),h
    add a,c
    ld h,b
    push hl
    ld h,d
    add a,h
    ld b,b
    add a,c
    sbc a,245
    ld h,b
    add a,c
    sbc a,(hl)
    out (c),h
    add a,c
    ld e,(hl)
    push hl
    ld h,d
    add a,c
    ld b,b
    ld e,iyl
    ld e,a
    add a,h
    nop
    add a,b
    ret 
    ld c,h
    ld b,c
    ld d,e
    ld d,h
    jr nz,labBEC2
    jr nz,labBEC2+2
labBEA4 ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBECC+2
labBEAE ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBED6+2
    ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBEE0+2
labBEC2 ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBEEB+1
labBECC ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBEF6
labBED6 ld bc,lab43FE+2
    ld d,l
    ld d,d
    ld b,l
    ld c,h
    ld c,h
    jr nz,labBF00
labBEE0 ld bc,labCD00
    ld a,(bc)
    cp (hl)
    ld hl,lab86E8+2
    ld (lab8646+1),hl
labBEEB call lab8752
    add a,c
    adc a,d
    pop hl
    add a,d
    rst 56
    rrca 
    add a,h
    nop
labBEF6 add a,b
    ld hl,labBED6+2
    ld bc,lab0700
labBEFD push bc
    push hl
    ld a,b
labBF00 neg
    add a,8
    cp 7
    jr nz,labBF0C
    ld a,36
    ld c,192
labBF0C call lab86E8+2
    call lab8752
    jr nz,labBF33+1
    add a,b
    pop hl
    ld b,8
labBF18 ld a,(hl)
    inc hl
    push hl
labBF1B push bc
    call lab8761
    pop bc
    pop hl
    djnz labBF18
    ld a,(lab86EB)
    add a,10
    ld (lab86EB),a
    ld e,(hl)
    inc hl
    ld d,(hl)
    push hl
    ex de,hl
    call lab8626
labBF33 ld a,48
    ld c,0
    call lab8761
    ld hl,(lab86EB)
    ld b,16
labBF3F call lab87E9
    djnz labBF3F
    ld a,l
    and 192
    or 10
    ld l,a
    ld (lab86EB),hl
    pop hl
    ld de,labFFED
    add hl,de
    pop bc
    djnz labBEFD
    ld de,lab4C52
    ld c,85
labBF5A call lab8738
    jp labA668+2
    call nz,lab786B+1
    jr nc,labBF95
    jr nc,labBF97
    jr nc,labBF1B
labBF69 cp 254
    ld a,h
    xor 198
    add a,198
    add a,198
    ld h,(hl)
    ld (lab1010),a
    jr c,labBFB0
    ld l,h
    ld l,h
    add a,102
    ld (labFE6B+1),a
    sub 214
    add a,198
    add a,102
    ld (lab66C5+1),a
    inc a
    jr labBFC7
    ld l,h
    add a,102
    ld (labE0C0),a
    jr nc,labBFAB
    inc a
    ld l,h
labBF95 add a,102
labBF97 ld (labC6FC),a
    ld h,b
    jr nc,labBFB5
    inc c
    add a,254
    ld a,(hl)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
labBFAB rst 56
    ld (hl),b
    ld (hl),a
    dec sp
    dec sp
labBFB0 dec e
    dec e
    ld c,15
    rlca 
labBFB5 rlca 
    inc bc
    inc bc
    ld bc,lab0000
    nop
    rst 56
    rst 56
    nop
    rst 56
    cp a
    cp b
    ld (hl),b
    ld (hl),b
    ret po
    ret po
    ret nz
labBFC7 ret nz
    add a,b
    add a,b
    nop
    nop
    nop
    nop
    ld bc,lab0702+1
    ld c,29
    dec sp
    rst 48
    rst 40
    nop
    rst 56
    rst 56
    ld (hl),b
    dec sp
    dec sp
    dec e
    dec e
    ld c,14
    ld c,7
    rlca 
    inc bc
    inc bc
    ld bc,lab0000+1
    nop
    rst 56
    rst 56
    nop
    rst 56
    rst 56
    or h
    add a,(hl)
    ld b,e
    db 221
    db 245
    jp labC3B5
    sub d
    add a,(hl)
    add a,c
    add a,(hl)
    rlca 
    add a,a
    ld e,a
    add a,a
    ld l,(hl)
labBFFF ld e,(hl)
labC000 nop
labC001 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,labC015
labC015 nop
    nop
    jr nc,labC019
labC019 nop
    nop
    jr nc,labC01D
labC01D nop
    nop
labC01F jr nc,labC021
labC021 nop
    nop
    jr nc,labC025
labC025 nop
    nop
    jr nc,labC029
labC029 nop
    nop
labC02B jr nc,labC02D
labC02D nop
    nop
    jr nc,labC031
labC031 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC046 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC04F nop
    nop
    ret p
    nop
    nop
    jr nc,labC046
    ret p
    ret nz
    ret p
    ret p
    ret p
    ret nz
    ret p
    ret p
    jr nc,labC01F+1
    ret p
    ret p
    ret p
    ret nz
    nop
    ret p
    nop
    nop
    ret p
    nop
    jr nc,labC02B+1
    nop
    ret p
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC080 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC08F nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC09F nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC0AF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC0BF nop
    nop
    nop
    nop
    nop
    nop
    nop
labC0C6 nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
labC0CF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC0ED nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,11
    ex af,af''
    nop
    nop
    nop
    nop
labC0FC nop
    nop
labC0FE nop
labC0FF nop
labC100 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC108 nop
    
   
    
    org #c160
labC160 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC16A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab0000
    nop
    djnz labC19F
labC19F djnz labC1A1
labC1A1 djnz labC1A3
labC1A3 djnz labC1A5
labC1A5 nop
    nop
    djnz labC1A9
labC1A9 djnz labC1AB
labC1AB djnz labC1AD
labC1AD djnz labC1AF
labC1AF djnz labC1B1
labC1B1 djnz labC1B3
labC1B3 djnz labC1B5
labC1B5 djnz labC1B7
labC1B7 djnz labC1B9
labC1B9 djnz labC1BB
labC1BB nop
    nop
    nop
    nop
    nop
labC1C0 nop
    nop
    nop
    nop
    rrca 
    inc c
    rrca 
    inc c
    inc c
    ld b,12
    nop
    rrca 
    inc c
    rrca 
    ld c,15
    ld b,15
    ld b,1
    ex af,af''
    rrca 
    ld b,12
    nop
    nop
    nop
    ret p
    ld h,b
    djnz labC160
    ret p
    nop
    ret p
    add a,b
    nop
    nop
    ret p
    ret nz
    djnz labC16A
    ret nz
    nop
    ld (hl),b
    ret po
    ret p
    ret po
    ret p
    ret nz
    ret nz
    ld h,b
    jr nc,labC1B5+1
    ret nz
    ld h,b
    ret p
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC203 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC20F nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC220 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC25F
labC25F djnz labC261
labC261 djnz labC263
labC263 djnz labC265
labC265 nop
    nop
    djnz labC269
labC269 djnz labC26B
labC26B djnz labC26D
labC26D nop
    nop
    djnz labC271
labC271 djnz labC273
labC273 djnz labC275
labC275 djnz labC277
labC277 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    rrca 
    inc c
    rrca 
    ld c,15
    inc c
    rlca 
    ld c,1
    ex af,af''
    inc c
    nop
    inc bc
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ld h,b
    djnz labC220
labC2A0 ret p
    nop
    ret p
    add a,b
    nop
    nop
    ret p
    ret po
    ret p
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    ret nz
    ret p
    ret po
    ret p
    ld h,b
    ret p
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC2C2 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC2DF
labC2DF djnz labC2E1
labC2E1 djnz labC2E3
labC2E3 djnz labC2E5
labC2E5 djnz labC2E7
labC2E7 djnz labC2E9
labC2E9 djnz labC2EB
labC2EB djnz labC2ED
labC2ED djnz labC2EF
labC2EF djnz labC2F1
labC2F1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ret nz
    djnz labC2A0
    ret nz
    nop
    ld (hl),b
    ret po
    ret p
    ret po
    ret p
    ret nz
    ret nz
    ld h,b
    jr nc,labC2EB+1
    ret nz
    ld h,b
    ret p
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC347 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC364 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC374 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labC39F
labC39F djnz labC3A1
labC3A1 djnz labC3A3
labC3A3 djnz labC3A5
labC3A5 djnz labC3A7
labC3A7 djnz labC3A9
labC3A9 nop
    nop
    djnz labC3AD
labC3AD djnz labC3AF
labC3AF djnz labC3B1
labC3B1 djnz labC3B3
labC3B3 djnz labC3B5
labC3B5 djnz labC3B7
labC3B7 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    ld b,12
    ld b,3
    inc c
    ld bc,lab0C08
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    djnz labC364
    ret p
    ret po
    ret p
    ld h,b
    nop
    nop
    ret p
    ret nz
    ret p
    ret nz
    ret p
    add a,b
    ret p
    add a,b
    djnz labC374
    ret p
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC400 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab0000
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    nop
    nop
    ld de,lab10FF+1
    nop
    ld de,lab10FF+1
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    ld b,15
    inc c
    inc bc
    inc c
    rrca 
    inc c
labC4CC ld bc,lab0C08
    nop
    rlca 
    ld c,3
    nop
    nop
    nop
    inc c
    ld b,12
    ld b,15
    inc c
    rrca 
    ex af,af''
    inc c
    nop
    inc c
    nop
    nop
    nop
    inc bc
    inc c
    inc c
    ld b,15
    ex af,af''
    inc bc
    nop
    inc c
    ld b,15
    ld c,15
    inc c
    rrca 
    ex af,af''
    nop
    nop
    ld bc,lab0307+1
    ld c,6
    inc c
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0B0D
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rlca 
    ld c,15
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0201+1
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
labC629 ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
labC6C6 inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
labC6CE inc c
    inc c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
labC6FC rrca 
    rrca 
    rrca 
    rrca 
    nop
labC701 ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
labC755 dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
    dec c
    ld c,15
    nop
    ld bc,lab0302
    inc b
    dec b
    ld b,7
    ex af,af''
    add hl,bc
    ld a,(bc)
    dec bc
    inc c
labC7FD dec c
    ld c,15
labC800 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC808 nop
    nop
labC80A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    nop
    nop
labC816 nop
    ret nz
labC818 nop
    nop
    nop
    ret nz
labC81C nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    ret nz
labC824 nop
    nop
    nop
    ret nz
    nop
    nop
    nop
labC82B ret nz
labC82C nop
    nop
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    nop
    nop
    jr nc,labC816
    jr nc,labC818
    ret p
    nop
    jr nc,labC81C
    ret p
    jr nc,labC88F
labC85F ret nz
    ret p
    nop
    jr nc,labC824
    nop
    ret p
    nop
    nop
    ret p
    nop
    jr nc,labC82C
    nop
    nop
    ret p
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
labC88F rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC960 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labC96A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab0000),hl
    nop
    jr nz,labC99F
labC99F jr nz,labC9A1
labC9A1 jr nz,labC9A3
labC9A3 jr nz,labC9A5
labC9A5 nop
    nop
    jr nz,labC9A9
labC9A9 jr nz,labC9AB
labC9AB jr nz,labC9AD
labC9AD jr nz,labC9AF
labC9AF jr nz,labC9B1
labC9B1 jr nz,labC9B3
labC9B3 jr nz,labC9B5
labC9B5 jr nz,labC9B7
labC9B7 jr nz,labC9B9
labC9B9 jr nz,labC9BB
labC9BB nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    ex af,af''
    rrca 
    ex af,af''
    inc c
    ld b,13
    ld c,15
    ex af,af''
    inc c
    ld b,13
    ld b,13
    ld b,1
    ex af,af''
    dec c
    ld b,13
    ld c,0
    nop
    ret nc
    ld h,b
    djnz labC960
    ret p
    add a,b
    ret nz
    add a,b
    nop
    nop
    ret p
    add a,b
    djnz labC96A
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret p
    add a,b
    ret nz
    ld h,b
    nop
    ret po
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
labC9FB nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCA0E nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCA20 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz,labCA5F
labCA5F jr nz,labCA61
labCA61 jr nz,labCA63
labCA63 jr nz,labCA65
labCA65 nop
    nop
    jr nz,labCA69
labCA69 jr nz,labCA6B
labCA6B jr nz,labCA6D
labCA6D nop
    nop
    jr nz,labCA71
labCA71 jr nz,labCA73
labCA73 jr nz,labCA75
labCA75 jr nz,labCA77
labCA77 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec c
    ld c,15
    ex af,af''
    inc c
    ld b,15
    ex af,af''
    ld b,6
    ld bc,lab0C08
    nop
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nc
    ld h,b
    djnz labCA20
labCAA0 ret p
    add a,b
    ret nz
    add a,b
    nop
    nop
    ret nz
    ld h,b
    ret nc
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nc
    ld h,b
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz,labCADF
labCADF jr nz,labCAE1
labCAE1 jr nz,labCAE3
labCAE3 jr nz,labCAE5
labCAE5 jr nz,labCAE7
labCAE7 jr nz,labCAE9
labCAE9 jr nz,labCAEB
labCAEB jr nz,labCAED
labCAED jr nz,labCAEF
labCAEF jr nz,labCAF1
labCAF1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCB08 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    add a,b
    djnz labCAA0
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret p
    add a,b
    ret nz
    ld h,b
    nop
    ret po
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCB64 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab0000),hl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz,labCB9F
labCB9F jr nz,labCBA1
labCBA1 jr nz,labCBA3
labCBA3 jr nz,labCBA5
labCBA5 jr nz,labCBA7
labCBA7 jr nz,labCBA9
labCBA9 nop
    nop
    jr nz,labCBAD
labCBAD jr nz,labCBAF
labCBAF jr nz,labCBB1
labCBB1 jr nz,labCBB3
labCBB3 jr nz,labCBB5
labCBB5 jr nz,labCBB7
labCBB7 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec c
    ld b,12
    ld b,0
    ld c,1
    ex af,af''
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    djnz labCB64
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
    nop
    ret nz
    ret po
    ret p
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    jr nc,labCBF4
labCBF4 ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC44 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC66 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCC77 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
labCC87 ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab0000),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    nop
    nop
    ld (lab21FE+2),hl
    nop
    ld (lab21FE+2),hl
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    ld b,15
    ex af,af''
    ld bc,lab0F08
    ex af,af''
labCCCC ld bc,lab0D08
    ld c,6
    ld b,3
    nop
    nop
    nop
    inc c
    ld b,12
    ld b,15
labCCDB ex af,af''
    inc c
    ex af,af''
    inc c
    nop
    inc c
    nop
    nop
    nop
    nop
    ld c,12
    ld b,12
    ex af,af''
    inc bc
    nop
    dec c
labCCED ld b,12
    ld b,15
    ex af,af''
    inc c
    ex af,af''
    nop
    nop
    ld bc,lab0008
    ld b,12
    ld b,12
    ld b,0
labCCFF nop
labCD00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCD0B nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,11
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labCE07 nop
    nop
    nop
    nop
    nop
    nop
    nop
labCE0E nop
labCE0F nop
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    ex af,af''
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld (bc),a
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld a,(bc)
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld b,6
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
    ld c,14
labCE7C ld c,14
    ld c,14
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0101
    ld bc,lab0908+1
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    add hl,bc
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    dec bc
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
labCF11 ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
labCF90 nop
labCF91 ex af,af''
labCF92 inc b
    inc c
labCF94 ld (bc),a
    ld a,(bc)
labCF96 ld b,14
    ld bc,lab0508+1
labCF9B dec c
    inc bc
labCF9D dec bc
labCF9E rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
labCFCC inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
labCFE8 ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    ex af,af''
    inc b
    inc c
    ld (bc),a
    ld a,(bc)
    ld b,14
    ld bc,lab0508+1
    dec c
    inc bc
    dec bc
    rlca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD00E nop
    nop
    ret nz
    nop
    ret p
    nop
    ret nz
    nop
labD016 ret p
    nop
labD018 ret nz
    nop
    ret p
    nop
labD01C ret nz
    nop
    ret p
    nop
labD020 ret nz
    nop
    ret p
    nop
labD024 ret nz
    nop
    ret p
    nop
    ret nz
    nop
    ret p
    nop
labD02C ret nz
    nop
    ret p
    nop
labD030 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    nop
    nop
    jr nc,labD016
    jr nc,labD018
    ret p
    nop
    jr nc,labD01C
    ret p
    jr nc,labD08F
    ret nz
    ret p
    nop
    jr nc,labD024
    nop
    ret p
    nop
    nop
    ret p
    nop
    jr nc,labD02C
    ret p
    nop
    jr nc,labD030
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
labD08F rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD0C9 rrca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD160 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD16A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,lab0000
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    inc c
    inc c
labD1C9 ld b,12
    ld b,12
    inc c
    inc c
    ld b,12
    ld b,12
    ld b,1
    ex af,af''
    dec c
    ld b,12
    ld b,0
    nop
    ret nz
    ld h,b
    djnz labD160
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ret nz
    ret nz
    djnz labD16A
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret nz
    ret nz
    ret po
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD201 nop
    nop
    nop
labD204 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD220 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    ld b,12
    inc c
    inc c
    ld b,12
    nop
    ld b,6
    ld bc,lab0C08
    nop
    inc c
    ld b,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld h,b
    djnz labD220
labD2A0 ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ret nz
    ld h,b
    ret nc
    ld h,b
    ret nz
    ret po
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nc
    ld h,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    djnz labD2A0
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret nz
    ret nz
    ret po
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD364 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    add a,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    ld b,12
    ld b,12
    ld b,1
    ex af,af''
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    djnz labD364
    ret nz
    ld h,b
    ret nc
    ld h,b
    nop
    nop
    ret nz
    ld h,b
    ret nz
    ret nz
    ret nz
    nop
    ret nz
    nop
    ld h,b
    nop
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD412 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,lab0000
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
labD4AC adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    nop
    nop
    adc a,b
    call z,labCC87+1
    adc a,b
    call z,labCC87+1
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    ld b,12
    nop
    inc bc
    nop
    inc c
    inc c
    ld bc,lab0C08
    ld b,6
    ld b,3
    nop
    nop
    nop
    inc c
    ld c,12
    ld b,12
    inc c
    inc c
    nop
    inc c
    nop
    inc c
    nop
    nop
labD4E3 nop
    inc c
    ld b,12
    ld b,12
    nop
    inc bc
    nop
    dec c
    ld b,12
    ld b,12
    inc c
    inc c
    nop
    nop
    nop
    ld bc,lab0008
    ld b,12
    ld b,12
    ld b,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD515 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ex af,af''
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,11
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0B0D
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD608 nop
    nop
    nop
    nop
    nop
    nop
labD60E nop
    nop
    djnz labD622
    djnz labD624
    djnz labD626
    djnz labD628
    djnz labD62A
    djnz labD62C
    djnz labD62E
    djnz labD630
    jr nz,labD642
labD622 jr nz,labD644
labD624 jr nz,labD646
labD626 jr nz,labD648
labD628 jr nz,labD64A
labD62A jr nz,labD64C
labD62C jr nz,labD64E
labD62E jr nz,labD650
labD630 jr nc,labD662
    jr nc,labD664
    jr nc,labD666
labD636 jr nc,labD668
    jr nc,labD66A
    jr nc,labD66C
    jr nc,labD66E
labD63E jr nc,labD670
    ld b,b
    ld b,b
labD642 ld b,b
    ld b,b
labD644 ld b,b
    ld b,b
labD646 ld b,b
    ld b,b
labD648 ld b,b
    ld b,b
labD64A ld b,b
    ld b,b
labD64C ld b,b
    ld b,b
labD64E ld b,b
    ld b,b
labD650 ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld h,b
    ld h,b
labD662 ld h,b
    ld h,b
labD664 ld h,b
    ld h,b
labD666 ld h,b
    ld h,b
labD668 ld h,b
    ld h,b
labD66A ld h,b
    ld h,b
labD66C ld h,b
    ld h,b
labD66E ld h,b
    ld h,b
labD670 ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    sub b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    or b
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
labD6DD ret nc
    ret nc
    ret nc
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
labD6EB ret po
    ret po
    ret po
    ret po
    ret po
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    ret p
    nop
    djnz labD723
    jr nc,labD745
    ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD733
    jr nc,labD755
    ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD743
labD723 jr nc,labD765
    ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD753
labD733 jr nc,labD775
    ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD763
labD743 jr nc,labD785
labD745 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD773
labD753 jr nc,labD795
labD755 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD783
labD763 jr nc,labD7A5
labD765 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD793
labD773 jr nc,labD7B5
labD775 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD7A3
labD783 jr nc,labD7C5
labD785 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD7B3
labD793 jr nc,labD7D5
labD795 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
labD7A0 nop
    djnz labD7C3
labD7A3 jr nc,labD7E5
labD7A5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD7D3
labD7B3 jr nc,labD7F5
labD7B5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD7E3
labD7C3 jr nc,labD805
labD7C5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD7F3
labD7D3 jr nc,labD814+1
labD7D5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD803
labD7E3 jr nc,labD824+1
labD7E5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    djnz labD813
labD7F3 jr nc,labD835
labD7F5 ld d,b
    ld h,b
    ld (hl),b
    add a,b
    sub b
    and b
    or b
    ret nz
    ret nc
    ret po
    ret p
    nop
    nop
labD802 nop
labD803 nop
    nop
labD805 nop
labD806 nop
    nop
    nop
    nop
labD80A nop
labD80B nop
    nop
    nop
labD80E nop
    nop
    jr nc,labD802
labD812 ret nz
labD813 nop
labD814 jr nc,labD806
labD816 ret nz
    nop
labD818 jr nc,labD80A
labD81A ret nz
    nop
labD81C jr nc,labD80E
labD81E ret nz
    nop
    jr nc,labD812
    ret nz
    nop
labD824 jr nc,labD816
    ret nz
    nop
    jr nc,labD81A
    ret nz
    nop
    jr nc,labD81E
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
labD835 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD84F nop
    nop
    ret p
    nop
    nop
    jr nc,labD816
    jr nc,labD818
    ret p
    nop
    jr nc,labD81C
    ret p
    jr nc,labD84F
    ret nz
    ret p
    nop
    jr nc,labD824
    nop
    ret p
    nop
    nop
    ret p
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD8AA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD960 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labD96A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    ld b,14
    ld c,14
    ld b,12
    ld b,12
    ld b,12
    ld b,12
    ld b,1
    ex af,af''
    dec c
    ld c,14
    ld b,0
    nop
    ret nz
    ld h,b
    djnz labD960
    ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    ret nz
    ld h,b
    djnz labD96A
    ret po
    ld h,b
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret p
    ret nz
    ret po
    ret po
    ret po
    ret po
    ret nc
    ret po
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDA20 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,6
    inc c
    ld b,12
    ld b,12
    nop
    ld b,6
    ld bc,lab0E08
    ld b,14
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld h,b
    djnz labDA20
labDAA0 ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    ret nz
    ld h,b
    ret nc
    ret po
    ret p
    ret nz
    nop
    nop
    ret nz
    ret nz
    ret nz
    ld h,b
    ret nc
    ret po
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld h,b
    djnz labDAA0
    ret po
    ld h,b
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret p
    ret nz
    ret po
    ret po
    ret po
    ret po
    ret nc
    ret po
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDB64 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    ld (hl),b
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    ld b,14
    ld c,14
    ld c,1
    ex af,af''
    ld c,6
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDBD7 nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ret po
    ret po
    ret nz
    ld h,b
    djnz labDB64
    ret nz
    ld h,b
    ret nc
    ret po
    nop
    nop
    ret nz
    ret po
    ret nz
    ld h,b
    ret po
    ld h,b
    ret po
    ld h,b
    ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    ld (hl),a
    adc a,b
    nop
    nop
    nop
    nop
    ld c,6
    ld c,14
    inc c
    nop
    ld c,0
    inc c
    ld b,1
    ex af,af''
    ld c,6
    ld b,6
    inc bc
    nop
    nop
    nop
    rrca 
    inc c
    ld c,14
    inc c
    ld b,14
    ld b,12
    ld b,12
    ld b,0
    nop
    ld c,14
    ld c,14
    inc c
    nop
    inc bc
labDCEB nop
    rrca 
    ld c,12
    ld b,12
    ld b,14
    ld b,0
    nop
    inc bc
    ex af,af''
    inc c
    ld c,14
    ld c,14
    ld c,0
    nop
labDD00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDD2A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDD5F rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab000B+1
    inc bc
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    nop
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0D0D
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labDDDD nop
    nop
    ld c,7
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    add a,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
labDE25 ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ld b,b
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    ret nz
    jr nz,labDE62
    jr nz,labDE64
    jr nz,labDE66
    jr nz,labDE68
    jr nz,labDE6A
    jr nz,labDE6C
    jr nz,labDE6E
    jr nz,labDE70
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    and b
    ld h,b
    ld h,b
labDE62 ld h,b
    ld h,b
labDE64 ld h,b
    ld h,b
labDE66 ld h,b
    ld h,b
labDE68 ld h,b
    ld h,b
labDE6A ld h,b
    ld h,b
labDE6C ld h,b
    ld h,b
labDE6E ld h,b
    ld h,b
labDE70 ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    ret po
    djnz labDE92
    djnz labDE94
    djnz labDE96
    djnz labDE98
    djnz labDE9A
    djnz labDE9C
    djnz labDE9E
    djnz labDEA0
    sub b
    sub b
labDE92 sub b
    sub b
labDE94 sub b
    sub b
labDE96 sub b
    sub b
labDE98 sub b
    sub b
labDE9A sub b
    sub b
labDE9C sub b
    sub b
labDE9E sub b
labDE9F sub b
labDEA0 ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
labDEA6 ld d,b
    ld d,b
    ld d,b
    ld d,b
labDEAA ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ld d,b
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
    ret nc
labDEB6 ret nc
    ret nc
    ret nc
    ret nc
labDEBA ret nc
    ret nc
    ret nc
    ret nc
labDEBE ret nc
    ret nc
    jr nc,labDEF2
    jr nc,labDEF4
    jr nc,labDEF6
labDEC6 jr nc,labDEF8
    jr nc,labDEFA
labDECA jr nc,labDEFC
    jr nc,labDEFE
labDECE jr nc,labDF00
    or b
    or b
    or b
    or b
    or b
    or b
labDED6 or b
    or b
    or b
    or b
labDEDA or b
    or b
    or b
    or b
labDEDE or b
    or b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
labDEE6 ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
labDEEA ld (hl),b
    ld (hl),b
    ld (hl),b
    ld (hl),b
labDEEE ld (hl),b
    ld (hl),b
    ret p
    ret p
labDEF2 ret p
    ret p
labDEF4 ret p
    ret p
labDEF6 ret p
    ret p
labDEF8 ret p
    ret p
labDEFA ret p
    ret p
labDEFC ret p
    ret p
labDEFE ret p
    ret p
labDF00 nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDEA6
labDF06 ld h,b
    ret po
    djnz labDE9A
labDF0A ld d,b
    ret nc
labDF0C jr nc,labDEBE
labDF0E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDEB6
labDF16 ld h,b
    ret po
    djnz labDEAA
labDF1A ld d,b
    ret nc
    jr nc,labDECE
labDF1E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDEC6
labDF26 ld h,b
    ret po
    djnz labDEBA
labDF2A ld d,b
    ret nc
    jr nc,labDEDE
labDF2E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDED6
labDF36 ld h,b
    ret po
    djnz labDECA
labDF3A ld d,b
    ret nc
    jr nc,labDEEE
labDF3E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDEE6
labDF46 ld h,b
    ret po
    djnz labDEDA
labDF4A ld d,b
    ret nc
    jr nc,labDEFE
labDF4E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDEF6
labDF56 ld h,b
    ret po
    djnz labDEEA
labDF5A ld d,b
    ret nc
    jr nc,labDF0E
labDF5E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF06
labDF66 ld h,b
    ret po
    djnz labDEFA
labDF6A ld d,b
    ret nc
    jr nc,labDF1E
labDF6E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF16
labDF76 ld h,b
    ret po
    djnz labDF0A
labDF7A ld d,b
    ret nc
    jr nc,labDF2E
labDF7E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF26
labDF86 ld h,b
    ret po
    djnz labDF1A
labDF8A ld d,b
    ret nc
    jr nc,labDF3E
labDF8E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF36
labDF96 ld h,b
    ret po
    djnz labDF2A
    ld d,b
    ret nc
    jr nc,labDF4E
labDF9E ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF46
    ld h,b
    ret po
    djnz labDF3A
    ld d,b
    ret nc
    jr nc,labDF5E
labDFAE ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF56
    ld h,b
    ret po
    djnz labDF4A
    ld d,b
    ret nc
    jr nc,labDF6E
    ld (hl),b
labDFBF ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF66
    ld h,b
    ret po
    djnz labDF5A
    ld d,b
    ret nc
    jr nc,labDF7E
    ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF76
    ld h,b
    ret po
labDFD8 djnz labDF6A
labDFDA ld d,b
    ret nc
labDFDC jr nc,labDF8E
    ld (hl),b
    ret p
    nop
    add a,b
labDFE2 ld b,b
    ret nz
    jr nz,labDF86
    ld h,b
    ret po
    djnz labDF7A
labDFEA ld d,b
    ret nc
    jr nc,labDF9E
labDFEE ld (hl),b
    ret p
    nop
    add a,b
    ld b,b
    ret nz
    jr nz,labDF96
    ld h,b
    ret po
    djnz labDF8A
    ld d,b
    ret nc
    jr nc,labDFAE
    ld (hl),b
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE00A nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ret p
    ret p
    ret nz
    nop
    ret p
labE016 jr nc,labDFD8
labE018 jr nc,labDFDA
labE01A ret p
    nop
    nop
    ret p
    nop
    ret nz
    jr nc,labDFE2
    ret p
    nop
    ret p
    ret p
    ret p
    ret nz
    jr nc,labDFEA
    ret p
    nop
    jr nc,labDFEE
    ret p
    nop
labE030 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE042 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,labE042
    ret nz
    nop
    jr nc,labE016
labE056 ret p
    ret nz
    ret p
    nop
labE05A ret p
    ret nz
    ret p
    nop
labE05E ret p
    ret nz
    ret p
    nop
    ret p
    ret nz
    jr nc,labE056
    ret nz
    nop
    jr nc,labE05A
    ret p
    nop
    jr nc,labE05E
    ret p
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE081 nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE0BF nop
labE0C0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE0EB nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE0FF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE17F nop
    nop
    nop
    nop
    nop
    rst 56
    call z,labCCFF
    ld h,(hl)
    call z,labCC77
    rst 56
    call z,labCC66
    inc sp
    ld (lab2232+1),hl
    inc sp
    nop
    inc sp
    ld (labCC77),hl
    nop
    nop
    jr nc,labE1BE
    jr nc,labE1A0
labE1A0 jr nc,labE1C2
    ld (hl),b
    ret nz
    nop
    nop
    ret p
    ret nz
    jr nc,labE1AA
labE1AA ld (hl),b
    ret nz
    jr nc,labE20E
    ld h,b
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    jr nc,labE1DA
    nop
    nop
    nop
    nop
labE1BE nop
    nop
    nop
    nop
labE1C2 nop
    nop
    ld c,0
    ld c,6
    rlca 
    inc c
    rlca 
    inc c
    ld c,6
    inc c
    ld c,12
    ld c,12
    ld c,3
    inc c
    inc c
    ld c,7
    inc c
labE1DA nop
    nop
    ret nz
    ret po
    jr nc,labE1A0
    ret nz
    ld h,b
    ret p
    ret nz
    nop
    nop
    ret po
    ld h,b
    jr nc,labE1AA
    ld (hl),b
    ret nz
    ld h,b
    ret po
    ret nz
    ret po
    ret po
    ld h,b
    ret p
    add a,b
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ret nz
    ret po
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE20E nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    call z,labCCFF
    ld h,(hl)
labE249 call z,labCCFF
    inc sp
    ld h,(hl)
    inc sp
    nop
    ld (hl),a
    call z,labCC66
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,labE27E
    jr nc,labE260
labE260 jr nc,labE282
    ld (hl),b
    ret nz
    nop
    nop
    ld h,b
    ret nz
    jr nc,labE289+1
    ret p
    ret nz
    nop
    nop
    jr nc,labE270
labE270 ld h,b
    ret nz
    jr nc,labE294
    ld (hl),b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE27E nop
    nop
    nop
    nop
labE282 nop
    nop
    rlca 
    inc c
    ld c,6
    inc c
labE289 ld c,14
    nop
    ld b,14
    inc bc
    inc c
    rlca 
    inc c
    rlca 
    inc c
labE294 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret po
    jr nc,labE260
    ret nz
    ld h,b
    ret p
    ret nz
    nop
    nop
    ret nz
    ret po
    ret nz
    ret po
    ret p
    add a,b
    nop
    nop
    ld (hl),b
    add a,b
    ret nz
    ret po
    ret nz
    ret po
    ret p
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ret nz
    jr nc,labE2E0
labE2E0 ld (hl),b
    ret nz
labE2E2 jr nc,labE344
    ld h,b
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    jr nc,labE310
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE310 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret po
    ld h,b
    jr nc,labE2E0
    ld (hl),b
    ret nz
    ld h,b
    ret po
    ret nz
    ret po
    ret po
    ld h,b
    ret p
    add a,b
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ret nz
    ret po
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE344 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc sp
    ld (lab2232+1),hl
    ld h,(hl)
    call z,lab0032+1
    ld (hl),a
    call z,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc,labE39E
labE39E jr nc,labE3C0
    jr nc,labE3A2
labE3A2 jr nc,labE3A4
labE3A4 ld h,b
    ret nz
    jr nc,labE3C8
    nop
    nop
    ret p
    ret nz
    ret p
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret nz
    ld (hl),b
    ret po
    ld (hl),b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE3C0 nop
    nop
    nop
    nop
    inc c
    ld c,7
    inc c
labE3C8 rlca 
    inc c
    inc bc
    inc c
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),b
    add a,b
    ld (hl),b
    ret nz
    ret p
    ret nz
    jr nc,labE3A4
    ret nz
    ret po
    ret nz
    ret po
    nop
    nop
    ret p
    ret nz
    ret po
    ld h,b
    ret p
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    ret p
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE405 nop
    nop
labE407 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld (hl),a
    call z,labCC66
    rst 56
    call z,lab2232+1
    rst 56
    call z,lab0032+1
    ld (hl),a
    call z,lab6631+2
    rst 56
    xor 0
    nop
    rst 56
    call z,lab2232+1
    rst 56
    call z,labCC77
    inc sp
    nop
    inc sp
    nop
    nop
    nop
    ld h,(hl)
    call z,labCC66
    ld (hl),a
    call z,labEEFF
    inc sp
    ld (labCC66),hl
    rst 56
    call z,labCC77
    nop
    nop
    ld d,l
    adc a,b
    ld h,(hl)
    call z,labCC66
    inc sp
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    rlca 
    inc c
    ld c,0
    inc c
    nop
    ld c,6
    inc bc
    inc c
    rlca 
    inc c
    ld b,14
    rlca 
    ex af,af''
    nop
    nop
    rrca 
    ex af,af''
    rlca 
    inc c
    ld c,6
    rrca 
    inc c
    rrca 
    inc c
    rrca 
    inc c
    nop
    nop
    rlca 
    inc c
    rlca 
    inc c
    ld c,0
    rlca 
labE4EB ex af,af''
    ld b,12
    inc c
    ld c,14
    ld b,15
    inc c
    nop
    nop
    rlca 
    ex af,af''
    rlca 
    inc c
    rlca 
    inc c
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE552 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,7
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab000B+1
    inc bc
    dec bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    dec c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab2221+1
labE622 ld (lab2221+1),hl
    ld (lab2221+1),hl
    ld (lab2221+1),hl
    ld (lab2221+1),hl
    ld (lab3322),hl
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
labE6AA xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    call z,labCCCC
    call z,labCCCC
    call z,labCCCC
    call z,labCCCC
    call z,labCCCC
    call z,labDDDD
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    xor 238
    xor 238
    xor 238
    xor 238
    xor 238
    xor 238
    xor 238
    xor 238
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
labE6FC rst 56
    rst 56
    rst 56
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
labE7D6 ld h,(hl)
    ld (hl),a
labE7D8 adc a,b
    sbc a,c
    xor d
    cp e
labE7DC call z,labEEDD
    rst 56
labE7E0 nop
    ld de,lab3322
labE7E4 ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
labE7EC call z,labEEDD
    rst 56
    nop
    ld de,lab3322
    ld b,h
    ld d,l
    ld h,(hl)
    ld (hl),a
    adc a,b
    sbc a,c
    xor d
    cp e
    call z,labEEDD
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret p
    ret p
    ret p
    ret nz
    jr nc,labE7D6
    jr nc,labE7D8
    ret p
    nop
    jr nc,labE7DC
    jr nc,labE7DC+2
    jr nc,labE7E0
    ret p
    nop
    jr nc,labE7E4
    ret p
    ret p
    ret p
    ret nz
    ret p
    nop
labE82A jr nc,labE7EC
    ret p
    nop
    jr nc,labE830
labE830 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec bc
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    dec c
    dec c
    inc c
    nop
    nop
    nop
labE8BB nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE8E8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab000B+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE920 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE92A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCCED+1
    xor 204
    ld h,(hl)
    xor 102
    call z,labCCED+1
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld de,lab6688
    ld h,(hl)
    xor 102
    nop
    nop
    ld h,b
    ld h,b
    djnz labE920
    ld h,b
    ld h,b
    ret po
    ld h,b
    nop
    nop
    ret nz
    ret po
    djnz labE92A
    ret po
    ld h,b
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ld b,b
    ret nz
    ld h,b
    ld h,b
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE9E0 nop
    nop
labE9E2 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labE9F0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xor 102
    call z,labCCED+1
    ld h,(hl)
    call z,lab66EE
    ld h,(hl)
    ld de,labEE86+2
    ld h,(hl)
    call z,lab0044
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h,b
    ld h,b
    djnz labE9E0
labEA60 ld h,b
    ld h,b
    ret po
    ld h,b
    nop
    nop
    ret nz
    ld h,b
    ld h,b
    ld h,b
    ret nz
    ret po
    nop
    nop
    djnz labE9F0
    ret nz
    ld h,b
    ld h,b
    ld h,b
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret po
    djnz labEA60
    ret po
    ld h,b
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret po
    ret nz
    ret po
    ret nz
    ld b,b
    ret nz
    ld h,b
    ld h,b
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labEB00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labEB11 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labEB1E nop
    nop
    nop
    nop
    nop
    nop
labEB24 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    call z,lab1144
    adc a,b
    xor 102
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    djnz labEB1E
    ld h,b
    ld h,b
    ld h,b
    nop
    djnz labEB24
    ret nz
    ld h,b
    ld h,b
    ld h,b
    nop
    nop
    ret nz
    ret nz
    ret nz
    ret po
    ret po
    ld h,b
    ret po
    ld h,b
    ret p
    ret po
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labEC00 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labEC3F nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    xor 102
    call z,labCC66
    xor 102
    ld h,(hl)
    call z,lab11EE
    adc a,b
    xor 102
    ld h,(hl)
    ld h,(hl)
    rst 56
    xor 0
    nop
    call z,lab66EE
    ld h,(hl)
    call z,labEEEE
    ld h,(hl)
    ld h,(hl)
    nop
    ld h,(hl)
    nop
    nop
    nop
    call z,labCC44
    ld h,(hl)
    xor 102
    rst 56
    xor 102
    ld h,(hl)
    call z,labCC66
    xor 238
    ld h,(hl)
    nop
    nop
    ld de,labCC87+1
    ld h,(hl)
    call z,lab6665+1
    nop
    nop
    nop
    nop
    nop
labECC2 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labECF0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
labED48 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,7
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld c,0
    rlca 
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,14
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    adc a,b
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    ld b,h
    call z,labCCCC
    call z,labCCCC
labEE36 call z,labCCCC
    call z,labCCCC
    call z,labCCCC
labEE3F call z,lab2221+1
    ld (lab2221+1),hl
labEE45 ld (lab2221+1),hl
    ld (lab2221+1),hl
    ld (lab2221+1),hl
    ld (labAA22),hl
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    xor d
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    xor 238
    xor 238
    xor 238
labEE76 xor 238
    xor 238
labEE7A xor 238
labEE7C xor 238
    xor 238
    ld de,lab1110+1
    ld de,lab1110+1
labEE86 ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab1110+1
    ld de,lab9999
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    sbc a,c
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    ld d,l
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    db 221
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
    inc sp
labEECC inc sp
    inc sp
    inc sp
    inc sp
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
    cp e
labEEDA cp e
    cp e
    cp e
labEEDD cp e
    cp e
    cp e
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
    ld (hl),a
labEEEC ld (hl),a
    ld (hl),a
labEEEE ld (hl),a
    ld (hl),a
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
    rst 56
labEEFF rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
labEF37 xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
labEF7F rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
labEFD6 ld h,(hl)
labEFD7 xor 17
    sbc a,c
    ld d,l
    db 221
labEFDC db 51
    cp e
    ld (hl),a
    rst 56
labEFE0 nop
    adc a,b
    ld b,h
labEFE3 call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
labEFEC db 51
    cp e
    ld (hl),a
    rst 56
    nop
    adc a,b
    ld b,h
    call z,labAA22
    ld h,(hl)
    xor 17
    sbc a,c
    ld d,l
    db 221
    db 51
    cp e
    ld (hl),a
    rst 56
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF00C nop
    nop
    nop
    nop
    ret nz
    ret p
    nop
    ret nz
    jr nc,labEFD6
labF016 jr nc,labEFD7+1
    ret p
    nop
labF01A jr nc,labEFDC
    ret p
    nop
    jr nc,labEFE0
labF020 ret p
    nop
    jr nc,labEFE3+1
    ret nz
    ret p
    nop
    ret nz
    ret p
    nop
    jr nc,labEFEC
    ret p
    ret nz
    nop
    nop
labF030 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF081 nop
labF082 nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    dec bc
    dec bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF093 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0D0D
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF0C4 nop
    nop
    nop
    nop
    nop
    inc bc
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF0F0 nop
    nop
    nop
    nop
    nop
    ld bc,lab000B+1
labF0F8 nop
    nop
    nop
    nop
    nop
    nop
    nop
labF0FF nop
    nop
    nop
    nop
    nop
labF104 nop
    nop
    nop
labF107 nop
    nop
    nop
labF10A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF114 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF120 nop
    nop
    nop
    nop
    nop
labF125 nop
    nop
    nop
    nop
    nop
labF12A nop
    nop
    nop
    nop
labF12E nop
    nop
labF130 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF17F nop
    nop
    nop
    nop
    nop
    call z,labCC66
    ld h,(hl)
    call z,labCC66
    nop
    call z,labCC66
    ld h,(hl)
    call z,labCCED+1
    xor 17
    adc a,b
    call z,labCC66
    nop
    nop
    nop
    ret nz
    ret po
    djnz labF120
    ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ret nz
    ld h,b
    djnz labF12A
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret po
    nop
    ret nz
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF1E0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF1F6 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF1FE nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF232 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCC00
    ld h,(hl)
    call z,labCC66
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld de,labCC87+1
    nop
    xor 0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret po
    djnz labF1E0
labF260 ret nz
    ret nz
    ret nz
    nop
    nop
    nop
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF2BB nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ld h,b
    djnz labF260
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret nz
    ld h,b
    ret po
    nop
    ret nz
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF300 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF324 nop
    nop
    nop
    nop
    nop
    nop
    nop
labF32B nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCCED+1
    ld h,(hl)
    xor 0
    ld de,labCC87+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    djnz labF324
    ret nz
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    ret nz
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    ret nz
    nop
    ret nz
    ld h,b
    ret nz
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF418 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF440 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCC00
    ld h,(hl)
    call z,labCC66
    ld h,(hl)
    call z,lab1166
    adc a,b
    call z,lab65FE+2
    ld h,(hl)
    cp e
    ld (lab0000),hl
    call z,labCC66
    ld h,(hl)
    call z,labCC66
    nop
    call z,labCC00
    nop
    nop
    nop
    xor 0
    call z,labCC66
    nop
    cp e
    ld (lab66CC),hl
labF4AE call z,labCC66
    ld h,(hl)
    call z,lab0000
    nop
    ld de,labCC87+1
    ld h,(hl)
    xor 238
    ld h,(hl)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF4D8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF4F8 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0008
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF538 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,7
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld c,0
    rlca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF58E nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF5AA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0008
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF5E9 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF600 inc bc
    ex af,af''
    add hl,bc
    djnz labF58E
    nop
    or 3
    rrca 
    ex af,af''
    add hl,bc
    sub b
    ex af,af''
    add hl,bc
    djnz labF616
    ex af,af''
    djnz labF619
    ex af,af''
labF614 djnz labF61C
labF616 ex af,af''
    jr nc,labF61C
labF619 ld bc,lab0901+1
labF61C adc a,c
    jr labF614+1
    inc bc
    rrca 
    ld bc,lab8902
    ld bc,lab0901+1
    ld b,8
    dec c
    ld b,8
    dec c
    ld b,8
    dec l
labF630 add a,a
    add a,d
    ei
    djnz labF63B
    rlca 
    djnz labF63D+1
    rlca 
    djnz labF641
labF63B rlca 
    ld (de),a
labF63D ld b,7
    ld c,6
labF641 rlca 
    ld (de),a
    dec bc
    adc a,c
    inc sp
    or 3
    inc c
    djnz labF658
    add hl,bc
    inc b
    dec c
    add hl,bc
    inc b
    ld bc,lab0E8D
    adc a,l
    ld c,c
    add a,d
    dec b
    add a,a
labF658 ld h,6
    dec c
    ld (hl),d
    adc a,l
    ld b,13
labF65F ld (hl),d
    adc a,l
    inc b
    dec bc
    ld (hl),b
    adc a,e
    inc b
labF666 dec bc
    ld (de),a
    sub h
    djnz labF676
    dec c
    ld c,21
    ld a,d
    sub l
    ld c,21
    ld a,d
    sub l
    dec c
labF675 inc d
labF676 ld a,c
    sub h
    dec c
    djnz labF694
    sub a
labF67C inc d
    djnz labF68C
    add a,a
    add hl,de
    ld c,e
labF682 ld d,a
    adc a,e
    ld c,e
    ld d,a
    adc a,e
    ld c,c
    ld d,l
    adc a,c
    ld c,c
    ld d,l
labF68C adc a,c
    ld c,b
    ld d,h
    adc a,b
    ld c,b
    ld d,h
    adc a,b
    ld c,l
labF694 rrca 
    ld d,b
    dec c
    ld l,l
    adc a,l
    adc a,l
labF69A add a,a
    ld a,(de)
    ld b,9
    ld l,(hl)
    adc a,c
    ld b,(hl)
    ld b,d
    add a,(hl)
    inc b
    add hl,bc
    ld l,l
    adc a,c
    and h
    ld bc,lab0203+1
    add hl,bc
    ld l,e
    add a,d
    ld c,c
    ld c,e
    add a,a
    ld b,c
    ld b,h
    add a,(hl)
    ld l,e
    ld l,c
    add a,a
    jr nz,labF6BF+1
    add hl,bc
    ld l,e
    sub b
    ld d,d
    ld d,e
    sub b
labF6BF ld c,16
    ld (hl),d
    adc a,(hl)
    ld c,e
    ld c,c
    add a,(hl)
    and h
    ld c,13
    ld c,c
    ld b,a
    add a,h
    dec c
    add hl,bc
    inc b
    ld bc,lab0407+2
    ld bc,lab8409
    ld b,132
    ld b,c
    add a,a
labF6D9 add a,c
    jr c,labF65F
    djnz labF666
    ld a,(de)
    adc a,d
    ld (bc),a
    add a,(hl)
    nop
    or 134
    nop
    or 129
    ld b,h
    add a,(hl)
    ld sp,lab85F6
    db 221
    db 246
labF6EF add a,c
    jr nz,labF675
    djnz labF67C
    djnz labF6F6
labF6F6 jr nc,labF682
    rst 56
    add a,(hl)
labF6FA ld e,b
    or 138
    nop
    add a,(hl)
    ld e,b
    or 138
    ld bc,lab1088
    nop
    ld c,b
    add a,(hl)
    add a,b
    or 133
    di
labF70C or 129
    inc sp
    add a,e
    djnz labF69A
    jr labF69A
    sbc a,e
    or 134
    sbc a,e
    or 134
    or a
    or 133
    inc de
    rst 48
labF71F dec h
    rst 48
    dec a
    rst 48
    ld e,(hl)
    rst 48
    ld (bc),a
    ld b,8
    ld a,(bc)
    inc c
    ld c,14
    ld c,13
    inc c
    inc c
    dec bc
    dec bc
    ld a,(bc)
    ld a,(bc)
    add hl,bc
    ex af,af''
    rlca 
    rlca 
    add a,b
    scf
    rst 48
    scf
    rst 48
    ld bc,lab0C08
    ld c,15
    ld c,12
    rlca 
    dec bc
    ld c,11
    ld b,10
    dec c
    ld a,(bc)
    dec b
    inc b
    inc bc
    ld b,8
    ld b,5
    ld b,5
    inc b
    inc bc
    inc b
    inc bc
    ld (bc),a
    ld bc,lab5A80
    rst 48
    ld b,14
    rrca 
    dec c
labF762 dec bc
    ld a,(bc)
    add hl,bc
    add hl,bc
    ld a,(bc)
    add a,b
    ld h,(hl)
    rst 48
labF76A ld (hl),d
    rst 48
    sbc a,a
    rst 48
    or d
    rst 48
    cp a
    rst 48
    inc b
    jr c,labF7AF
    inc a
    ld a,64
    add a,c
    ld (hl),a
    rst 48
    ld c,b
    ccf 
    ld a,61
    inc a
    dec sp
    ld a,(lab3838+1)
    scf
    ld (hl),53
    inc (hl)
    inc sp
    ld (lab302F+2),a
    cpl 
    ld l,45
    inc l
    dec hl
    ld hl,(lab2827+2)
    daa
    ld h,37
    inc h
    inc hl
    ld (lab2021),hl
    add a,b
    sbc a,e
    rst 48
    djnz labF7E1
    add a,c
    and b
    rst 48
    inc e
    ld b,b
    ld b,b
    ld b,c
    ld b,d
    ld b,c
    ld b,b
    ld b,b
    ccf 
    ld a,63
labF7AF add a,b
    and l
    rst 48
    jr z,labF7F4
    add a,c
    or e
    rst 48
    ld b,64
    ld b,c
    ld b,b
    ccf 
    add a,b
    cp b
    rst 48
    inc bc
    ld b,b
    add a,c
    ret nz
    rst 48
    ld e,d
    ld a,60
    dec sp
    ld a,(lab3939)
    jr c,labF805
    jr c,labF807
    add hl,sp
    add hl,sp
    ld a,(lab3C3B)
    ld a,64
labF7D6 ld b,d
    ld b,h
labF7D8 ld b,l
    ld b,(hl)
    ld b,a
    ld b,a
labF7DC ld c,b
    ld c,b
    ld c,b
    ld c,b
labF7E0 ld b,a
labF7E1 ld b,a
    ld b,(hl)
    ld b,l
labF7E4 ld b,h
    ld b,d
    ld b,b
    add a,b
    push bc
    rst 48
    inc l
labF7EB jp z,lab38A5
    ld a,b
    cp 32
    jp z,lab38A5
labF7F4 cp 9
    call nz,lab04CC+1
    jp lab38A5
    ex (sp),hl
    inc hl
    inc hl
    ld e,(hl)
    nop
    nop
    nop
labF803 nop
    nop
labF805 nop
    nop
labF807 nop
    nop
labF809 nop
    nop
    nop
    nop
    nop
    nop
labF80F nop
    nop
    ret p
    nop
    nop
    jr nc,labF7D6
    jr nc,labF7D8
    ret p
    nop
    jr nc,labF7DC
    ret p
    ret nz
labF81E jr nc,labF7E0
    ret p
    nop
    jr nc,labF7E4
    nop
    ret p
    nop
    nop
    ret p
    nop
    jr nc,labF7EB+1
    jr nc,labF81E
    ret nz
    nop
    nop
    nop
    nop
labF833 nop
    nop
    nop
    nop
    nop
    nop
labF839 nop
    nop
    nop
    nop
    nop
    nop
labF83F nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab070D
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c,11
labF8B7 ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF8EA nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF8FF nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF909 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF920 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF92A nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCCED+1
    xor 204
    ld h,(hl)
    call z,labCC00
    xor 204
    ld h,(hl)
    rst 56
    xor 255
    xor 17
    adc a,b
    xor 102
    call z,lab0000
    nop
    ret p
    ret po
    djnz labF920
    ret nc
    add a,b
    ret nz
    add a,b
    nop
    nop
    ret nz
    ret po
    djnz labF92A
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret po
    ret nz
    ld h,b
    ld (hl),b
    add a,b
    ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF9E0 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labF9F9 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFA06 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call z,labCC00
    xor 204
    ld h,(hl)
    call z,lab66EE
    ld h,(hl)
    ld de,labCC87+1
    nop
    ld (hl),a
    adc a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFA5B nop
    ret p
    ret po
    djnz labF9E0
labFA60 ret nc
    add a,b
    ret nz
    add a,b
    nop
    nop
    ret nz
    ld h,b
    ret po
    ld h,b
    ret nz
    ld h,b
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret po
    ld h,b
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret po
    djnz labFA60
    ret nz
    nop
    ld h,b
    ld h,b
    ret nz
    ld h,b
    ret nz
    ret po
    ret nz
    ld h,b
    ld (hl),b
    add a,b
    ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFAFF nop

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFB24 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
    xor 204
    ld h,(hl)
    ld (hl),a
    adc a,b
    ld de,labCC87+1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz
    ret nz
    ld h,b
    ret nz
    nop
    djnz labFB24
    ret nz
    ld h,b
    ret po
    ld h,b
    nop
    nop
    ret p
    add a,b
    ret nz
    ret po
    ret nz
    add a,b
    ret nz
    add a,b
    nop
    ret nz
    ret nz
    add a,b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFBDE nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC04 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC0D nop
    nop
labFC0F nop
labFC10 nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC17 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC32 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC3B nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC55 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFC80 nop
    nop
    call z,labCC00
    ld h,(hl)
    call z,lab66EE
    call z,labEECC
    ld de,labCC87+1
    nop
    ld h,(hl)
    ld h,(hl)
    inc sp
    nop
    nop
    nop
    call z,labCC66
    ld h,(hl)
    call z,labCCED+1
    adc a,b
    call z,labCC00
    nop
    nop
    nop
    ld (hl),a
    adc a,b
    call z,labCC66
    adc a,b
    inc sp
    nop
    call z,labCC66
    ld h,(hl)
    call z,labCCED+1
    adc a,b
    nop
    nop
labFCB6 ld de,lab6688
    xor 119
    call z,labCC77
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFCCC nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFCF0 nop
    nop
    nop
labFCF3 nop
    nop
    nop
    nop
    nop
labFCF8 nop
    nop
    nop
    nop
labFCFC nop
    nop
    nop
labFCFF nop
    nop
    nop
labFD02 nop
labFD03 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFD1A nop
    nop
    nop
    nop
    nop
    ld bc,lab0008
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca 
    ld c,0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc,lab0B0D
    ex af,af''
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca 
    rrca 
    nop
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    ld c,15
    rrca 
    rlca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    rrca 
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
labFE00 ld b,254
labFE02 add a,b
    nop
    nop
labFE05 ret m
    add a,b
    inc b
    ld bc,lab80F9
    ex af,af''
    ld (bc),a
    jp m,lab0C80
    inc bc
    ei
    add a,b
    djnz labFE1B+1
labFE15 nop
    add a,b
labFE17 inc d
    ex af,af''
    ld (bc),a
    add a,b
labFE1B jr labFE21
    or 250
labFE1F or 242
labFE21 nop
    or 6
    cp 10
    ld a,(bc)
    inc b
    ld a,(bc)
labFE29 jp m,lab1C80
    ret m
    nop
    jp m,lab06FC
    jp m,labFA06
    call m,labF6FA
    cp 128
    inc l
    pop af
    pop af
    ret p
    inc e
    ex af,af''
labFE3F ld a,(de)
    inc (hl)
    ld bc,lab1300
    nop
    inc b
    ld b,16
    dec (hl)
    nop
    nop
labFE4B ld (lab171B+1),hl
    inc c
    inc (hl)
    ld b,c
    jr labFE5D
    ld (lab1B00),hl
    nop
    adc a,c
    nop
    inc de
    nop
    ret p
    pop af
labFE5D ld a,h
    xor 230
    and (hl)
    sub d
    sub d
    jp z,lab6CCD+1
    ld a,b
    jr c,labFE81
    jr labFE83
labFE6B jr labFE84+1
    jr labFEC6+1
    cp 226
    ld a,b
    inc e
    ld c,6
    ld b,142
    call c,labCE7C
    ld b,14
    inc a
    ld h,b
    jr nc,labFE88
    inc a
labFE81 inc c
    inc c
labFE83 ld a,(hl)
labFE84 cp 198
    ld h,(hl)
    ld h,b
labFE88 jr nc,labFEB9+1
    ld a,h
    adc a,6
    ld b,14
    inc a
    ld h,b
    ld h,b
    jr nc,labFF0F+1
    xor 198
    add a,238
    ld a,h
    ld h,b
    ld h,b
    jr nc,labFE5D
    ret nz
    ld h,b
    jr nc,labFEB9
    inc c
    ld b,134
    cp 124
    xor 198
    add a,108
    ld a,h
    xor 198
    ld l,h
    ld a,h
    adc a,6
    ld b,62
    ld l,(hl)
    add a,198
    ld l,h
    adc a,198
labFEB9 add a,198
    cp 198
    add a,198
    ld l,h
    call m,labC6CE
    adc a,252
    ret m
labFEC6 call z,labFCCC
    ld a,h
    and 192
    ret nz
    ret nz
    ret nz
    ret nz
    and 124
    ret m
    call m,labC6CE
    add a,198
    add a,206
    call m,labE6FC
    ret nz
    ret z
    ret m
labFEE0 ret z
    ret nz
    and 124
    ret po
    ret nz
    ret nz
    ret z
    ret m
    ret z
    ret nz
    and 124
    ld a,h
    and 198
labFEF0 sbc a,192
labFEF2 ret nz
    ret nz
    and 124
    ld l,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld a,(hl)
    ld h,(hl)
    ld h,(hl)
    ld h,(hl)
    ld (hl),60
labFF00 jr labFF1A
    jr labFF1A+2
labFF04 jr labFF1E
    jr labFF37+1
    ld a,b
    call z,lab0C0C
    inc c
    inc c
    inc c
labFF0F jr labFF41
    add a,198
    call z,labF0F8
    ret c
labFF17 call z,lab3266
labFF1A call m,labC0C6
labFF1D ret nz
labFF1E ret nz
labFF1F ret nz
labFF20 ret nz
    ld h,b
    jr nc,labFEF2
    add a,198
    sub 246
labFF28 cp 206
    ld h,(hl)
    ld (labDECE),a
    sub 214
    or 230
    add a,102
    ld (labEE7C),a
labFF37 add a,198
    add a,198
    add a,198
    ld l,h
    ret po
labFF3F ret nz
labFF40 ret nz
labFF41 ret m
    call m,labC6CE
    adc a,252
    ld b,120
    xor 214
    sub 198
    add a,198
    ld l,h
    and 198
    call z,labFCF8
labFF55 adc a,198
    adc a,252
    ld a,h
    xor 198
    ld c,60
    ld a,b
    ret po
    call nz,lab786B+1
    jr nc,labFF95
    jr nc,labFF97
labFF67 jr nc,labFF1A+1
    cp 254
    ld a,h
    xor 198
    add a,198
    add a,198
    ld h,(hl)
    ld (lab1010),a
labFF76 jr c,labFFB0
    ld l,h
    ld l,h
    add a,102
    ld (labFE6B+1),a
labFF7F sub 214
    add a,198
    add a,102
    ld (lab66C5+1),a
labFF88 inc a
    jr labFFC7
    ld l,h
    add a,102
labFF8E ld (labE0C0),a
    jr nc,labFFAB
    inc a
    ld l,h
labFF95 add a,102
labFF97 ld (labC6FC),a
    ld h,b
    jr nc,labFFB5
    inc c
    add a,254
    ld a,(hl)
labFFA1 nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst 56
labFFAB rst 56
    ld (hl),b
    ld (hl),a
    dec sp
    dec sp
labFFB0 dec e
    dec e
    ld c,15
    rlca 
labFFB5 rlca 
    inc bc
    inc bc
    ld bc,lab0000
labFFBB nop
    rst 56
    rst 56
    nop
labFFBF rst 56
labFFC0 cp a
    cp b
    ld (hl),b
    ld (hl),b
labFFC4 ret po
    ret po
    ret nz
labFFC7 ret nz
    add a,b
    add a,b
    nop
    nop
    nop
    nop
    ld bc,lab0702+1
    ld c,29
    dec sp
    rst 48
    rst 40
    nop
    rst 56
    rst 56
    ld (hl),b
    dec sp
    dec sp
    dec e
    dec e
    ld c,14
    ld c,7
    rlca 
    inc bc
    inc bc
    ld bc,lab0000+1
    nop
    rst 56
    rst 56
    nop
    rst 56
labFFED rst 56
    nop
labFFEF nop
    nop
    nop
labFFF2 ld a,b
    adc a,h
    ld (bc),a
labFFF5 ld bc,lab4025
    push de
labFFF9 ex de,hl
    ld a,e
    and 31
labFFFD dec de
labFFFE db 254
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
