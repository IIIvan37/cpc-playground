-- Migration: Import z80code projects batch 49
-- Projects 97 to 98
-- Generated: 2026-01-25T21:43:30.198029

-- Project 97: ukernel by fma
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'ukernel',
    'Imported from z80Code. Author: fma. Preemptive multi-tasking micro kernel',
    'public',
    false,
    false,
    '2021-10-15T15:43:22.617000'::timestamptz,
    '2024-01-31T07:17:39.633000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; ***************************************************
; *****           Noyau multitaches             *****
; ***************************************************

;NOLIST
;SETCRTC 0
BUILDSNA
BANKSET 0
RUN initSystem                          ; Init du système multitaches


; Définition des labels système

KERN_START_ADD  EQU     #0038           ; adresse du noyau multitaches
KERN_STACK      EQU     #0180           ; pile du noyau (#0100 -> #017f)
PROC_TABLE      EQU     #0200           ; zone sauvegarde environnement process (#0180 -> #01ff)
PROC_START_ADD  EQU     #0800           ; adresse de départ des process


; ***************************************************
; *****   Implantation des différents process   *****
; ***************************************************

ORG PROC_START_ADD

; Configuration du système en fonction des process

nbProc      EQU     2                   ; Nombre de process actifs.
firstProc   EQU     2                   ; No du premier process à activer.


; **************************************************
; *****      Premier process : counterProc     *****
; **************************************************

; Definition des labels


; Corps du process

counter
            LD   BC,#0200               ; tempo ~3.4s (512 * 1/300 / 2)
.loop1
            HALT
            DEC  C
            JR   NZ,.loop1
            DJNZ .loop1

            LD   A,#ff
            LD   (flag),A

.loop2
            JR   .loop2


; Pile du process

            DEFS 254                    ; réserve de la place pour la pile du process
            DEFW counter                ; place l''adresse de depart du process
Stack1                                  ; pour la première commutation de process par le noyau.


; **************************************************
; *****      Deuxième process : testFlag       *****
; **************************************************

; Definition des labels


; Corps du process

testFlag
.loop1
            LD   A,(flag)
            CP   #FF
            JR   NZ,.loop1

            ; Set border color
            LD   BC,#7F00+16
            OUT  (C),C
            LD   A,#40+0
            OUT  (C),A
.loop2
            JR   .loop2


flag        DEFB 0


; Pile du process

            DEFS 254                    ; réserve de la place pour la pile du process
            DEFW testFlag               ; place l''adresse de départ du process
Stack2                                  ; pour la première commutation de process par le noyau




; ***************************************************
; *****                Kernel                   *****
; ***************************************************

ORG KERN_START_ADD

kernel
            DI
            EXX
            EX   AF,AF''
            LD   HL,#0000
            ADD  HL,SP
            EX   DE,HL
            LD   SP,HL
            PUSH DE
            EX   AF,AF''
            EXX
            PUSH AF
            PUSH BC
            PUSH DE
            PUSH HL
            PUSH IX
            PUSH IY
            DEC  SP
            DEC  SP
            POP  BC
            LD   A,B
            CP   #FF
            JR   NZ,.next1
            CP   C
            JR   NZ,.next1
            LD   SP,PROC_TABLE
.next1
            LD   B,14
.loop
            DEC  SP
            DJNZ .loop
.entry
            POP  IY
            POP  IX
            POP  HL
            POP  DE
            POP  BC
            POP  AF
            EXX
            EX   AF,AF''
            POP  DE
            LD   HL,#0000
            ADD  HL,SP
            EX   DE,HL
            LD   SP,HL
            EX   AF,AF''
            EXX
            EI
            RETI


; Initialisation du système

initSystem
            DI
            LD   SP,KERN_STACK          ; init pointeur pile du noyau
            ; Des init additionnelles peuvent être faites ici

            LD   SP,PROC_TABLE - (firstProc * 14)
                                        ; fait pointer SP sur la table du
                                        ; 1er process a activer

            JP   kernel.entry           ; lance le premier process


; Zone de sauvegarde des registres de chaque tache

ORG PROC_TABLE - ((nbProc * 14) + 2)

            DEFW #ffff                  ; fin de la table.

            DEFS 12                     ; table du deuxième process
            DEFW Stack2 - 2             ; SP du deuxieme process

            DEFS 12                     ; table du premier process
            DEFW Stack1 - 2             ; SP du premier process
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

-- Project 98: deltadotplasma-(variante) by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'deltadotplasma-(variante)',
    'Imported from z80Code. Author: tronic. ...',
    'public',
    false,
    false,
    '2021-04-22T15:23:52.440000'::timestamptz,
    '2021-06-18T13:53:23.618000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Rigolo...
; Mais dieu que c''est moche ^^
;
; Tronic/GPA


BUILDSNA
BANKSET 0

org #40
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


start
		di:ld hl,#c9fb:ld (#38),hl
		ld bc,#7f00:ld a,ink03:out (c),c:out (c),a
		ld bc,#7f01:ld a,ink00:out (c),c:out (c),a
		ld bc,#7f02:ld a,ink06:out (c),c:out (c),a
		ld bc,#7f03:ld a,ink15:out (c),c:out (c),a
		ld bc,#7f10:ld a,ink00:out (c),c:out (c),a
        
        ld (pilorg+1),sp	; on sauvegarde le contexte de pile "standard"
        ei
        ld bc,#7fc6			; zik en bank #c6
        out (c),c
        call #5400			; initzik ayc player / mdr / ovl
        ld bc,#7fc0
        out (c),c
        di

mainloop

		ld b,#f5
vbl 	in a,(c)
		rra
		jp nc,vbl
        
        wline 1
        
        ld bc,#bc07
        out (c),c
        ld bc,#bd00+#ff
        out (c),c
        
        ld bc,#bc04
        out (c),c
        ld bc,#bd00+9
        out (c),c
        
		ld bc,#7f10
		ld a,INK01
		out (c),c
		out (c),a        
        
        ; ici on recopie en X... ldi, ldir, pile.... 
        ; on pourrait même inverser le motif ^^
        ; voir caser du split raster/border (un logo ?)

; move ; ici pour monter sinon ça descend...

ld hl,#C000 : move ld de,#C000+20 : repeat 20: ldi : rend 
ld hl,#D000 : ld de,#D000+20 : repeat 20: ldi : rend 
ld hl,#E000 : ld de,#E000+20 : repeat 20: ldi : rend 
ld hl,#F000 : ld de,#F000+20 : repeat 20: ldi : rend 
ld hl,#F280 : ld de,#C050+20 : repeat 20: ldi : rend 
ld hl,#E280 : ld de,#D050+20 : repeat 20: ldi : rend 
ld hl,#D280 : ld de,#E050+20 : repeat 20: ldi : rend 
ld hl,#C280 : ld de,#F050+20 : repeat 20: ldi : rend 
ld hl,#C0A0 : ld de,#C0A0+20 : repeat 20: ldi : rend 
ld hl,#D0A0 : ld de,#D0A0+20 : repeat 20: ldi : rend 
ld hl,#E0A0 : ld de,#E0A0+20 : repeat 20: ldi : rend 
ld hl,#F0A0 : ld de,#F0A0+20 : repeat 20: ldi : rend 
ld hl,#F1E0 : ld de,#C0F0+20 : repeat 20: ldi : rend 
ld hl,#E1E0 : ld de,#D0F0+20 : repeat 20: ldi : rend 
ld hl,#D1E0 : ld de,#E0F0+20 : repeat 20: ldi : rend 
ld hl,#C1E0 : ld de,#F0F0+20 : repeat 20: ldi : rend 
ld hl,#C140 : ld de,#C140+20 : repeat 20: ldi : rend 
ld hl,#D140 : ld de,#D140+20 : repeat 20: ldi : rend 
ld hl,#E140 : ld de,#E140+20 : repeat 20: ldi : rend 
ld hl,#F140 : ld de,#F140+20 : repeat 20: ldi : rend 
ld hl,#F140 : ld de,#C190+20 : repeat 20: ldi : rend 
ld hl,#E140 : ld de,#D190+20 : repeat 20: ldi : rend 
ld hl,#D140 : ld de,#E190+20 : repeat 20: ldi : rend 
ld hl,#C140 : ld de,#F190+20 : repeat 20: ldi : rend 
ld hl,#C1E0 : ld de,#C1E0+20 : repeat 20: ldi : rend 
ld hl,#D1E0 : ld de,#D1E0+20 : repeat 20: ldi : rend 
ld hl,#E1E0 : ld de,#E1E0+20 : repeat 20: ldi : rend 
ld hl,#F1E0 : ld de,#F1E0+20 : repeat 20: ldi : rend 
ld hl,#F0A0 : ld de,#C230+20 : repeat 20: ldi : rend 
ld hl,#E0A0 : ld de,#D230+20 : repeat 20: ldi : rend 
ld hl,#D0A0 : ld de,#E230+20 : repeat 20: ldi : rend 
ld hl,#C0A0 : ld de,#F230+20 : repeat 20: ldi : rend 
ld hl,#C280 : ld de,#C280+20 : repeat 20: ldi : rend 
ld hl,#D280 : ld de,#D280+20 : repeat 20: ldi : rend 
ld hl,#E280 : ld de,#E280+20 : repeat 20: ldi : rend 
ld hl,#F280 : ld de,#F280+20 : repeat 20: ldi : rend 
ld hl,#F000 : ld de,#C2D0+20 : repeat 20: ldi : rend 
ld hl,#E000 : ld de,#D2D0+20 : repeat 20: ldi : rend 
ld hl,#D000 : ld de,#E2D0+20 : repeat 20: ldi : rend 
ld hl,#C000 : ld de,#F2D0+20 : repeat 20: ldi : rend 


ld hl,#C000 : ld de,#C000+40 : repeat 20: ldi : rend 
ld hl,#D000 : ld de,#D000+40 : repeat 20: ldi : rend 
ld hl,#E000 : ld de,#E000+40 : repeat 20: ldi : rend 
ld hl,#F000 : ld de,#F000+40 : repeat 20: ldi : rend 
ld hl,#F280 : ld de,#C050+40 : repeat 20: ldi : rend 
ld hl,#E280 : ld de,#D050+40 : repeat 20: ldi : rend 
ld hl,#D280 : ld de,#E050+40 : repeat 20: ldi : rend 
ld hl,#C280 : ld de,#F050+40 : repeat 20: ldi : rend 
ld hl,#C0A0 : ld de,#C0A0+40 : repeat 20: ldi : rend 
ld hl,#D0A0 : ld de,#D0A0+40 : repeat 20: ldi : rend 
ld hl,#E0A0 : ld de,#E0A0+40 : repeat 20: ldi : rend 
ld hl,#F0A0 : ld de,#F0A0+40 : repeat 20: ldi : rend 
ld hl,#F1E0 : ld de,#C0F0+40 : repeat 20: ldi : rend 
ld hl,#E1E0 : ld de,#D0F0+40 : repeat 20: ldi : rend 
ld hl,#D1E0 : ld de,#E0F0+40 : repeat 20: ldi : rend 
ld hl,#C1E0 : ld de,#F0F0+40 : repeat 20: ldi : rend 
ld hl,#C140 : ld de,#C140+40 : repeat 20: ldi : rend 
ld hl,#D140 : ld de,#D140+40 : repeat 20: ldi : rend 
ld hl,#E140 : ld de,#E140+40 : repeat 20: ldi : rend 
ld hl,#F140 : ld de,#F140+40 : repeat 20: ldi : rend 
ld hl,#F140 : ld de,#C190+40 : repeat 20: ldi : rend 
ld hl,#E140 : ld de,#D190+40 : repeat 20: ldi : rend 
ld hl,#D140 : ld de,#E190+40 : repeat 20: ldi : rend 
ld hl,#C140 : ld de,#F190+40 : repeat 20: ldi : rend 
ld hl,#C1E0 : ld de,#C1E0+40 : repeat 20: ldi : rend 
ld hl,#D1E0 : ld de,#D1E0+40 : repeat 20: ldi : rend 
ld hl,#E1E0 : ld de,#E1E0+40 : repeat 20: ldi : rend 
ld hl,#F1E0 : ld de,#F1E0+40 : repeat 20: ldi : rend 
ld hl,#F0A0 : ld de,#C230+40 : repeat 20: ldi : rend 
ld hl,#E0A0 : ld de,#D230+40 : repeat 20: ldi : rend 
ld hl,#D0A0 : ld de,#E230+40 : repeat 20: ldi : rend 
ld hl,#C0A0 : ld de,#F230+40 : repeat 20: ldi : rend 
ld hl,#C280 : ld de,#C280+40 : repeat 20: ldi : rend 
ld hl,#D280 : ld de,#D280+40 : repeat 20: ldi : rend 
ld hl,#E280 : ld de,#E280+40 : repeat 20: ldi : rend 
ld hl,#F280 : ld de,#F280+40 : repeat 20: ldi : rend 
ld hl,#F000 : ld de,#C2D0+40 : repeat 20: ldi : rend 
ld hl,#E000 : ld de,#D2D0+40 : repeat 20: ldi : rend 
ld hl,#D000 : ld de,#E2D0+40 : repeat 20: ldi : rend 
ld hl,#C000 : ld de,#F2D0+40 : repeat 20: ldi : rend 


ld hl,#F2D0 : ld de,#C000+60 : repeat 20: ldi : rend 
ld hl,#E2D0 : ld de,#D000+60 : repeat 20: ldi : rend 
ld hl,#D2D0 : ld de,#E000+60 : repeat 20: ldi : rend 
ld hl,#C2D0 : ld de,#F000+60 : repeat 20: ldi : rend 
ld hl,#F280 : ld de,#C050+60 : repeat 20: ldi : rend 
ld hl,#E280 : ld de,#D050+60 : repeat 20: ldi : rend 
ld hl,#D280 : ld de,#E050+60 : repeat 20: ldi : rend 
ld hl,#C280 : ld de,#F050+60 : repeat 20: ldi : rend 
ld hl,#F230 : ld de,#C0A0+60 : repeat 20: ldi : rend 
ld hl,#E230 : ld de,#D0A0+60 : repeat 20: ldi : rend 
ld hl,#D230 : ld de,#E0A0+60 : repeat 20: ldi : rend 
ld hl,#C230 : ld de,#F0A0+60 : repeat 20: ldi : rend 
ld hl,#F1E0 : ld de,#C0F0+60 : repeat 20: ldi : rend 
ld hl,#E1E0 : ld de,#D0F0+60 : repeat 20: ldi : rend 
ld hl,#D1E0 : ld de,#E0F0+60 : repeat 20: ldi : rend 
ld hl,#C1E0 : ld de,#F0F0+60 : repeat 20: ldi : rend 
ld hl,#F190 : ld de,#C140+60 : repeat 20: ldi : rend 
ld hl,#E190 : ld de,#D140+60 : repeat 20: ldi : rend 
ld hl,#D190 : ld de,#E140+60 : repeat 20: ldi : rend 
ld hl,#C190 : ld de,#F140+60 : repeat 20: ldi : rend 
ld hl,#F140 : ld de,#C190+60 : repeat 20: ldi : rend 
ld hl,#E140 : ld de,#D190+60 : repeat 20: ldi : rend 
ld hl,#D140 : ld de,#E190+60 : repeat 20: ldi : rend 
ld hl,#C140 : ld de,#F190+60 : repeat 20: ldi : rend 
ld hl,#F0F0 : ld de,#C1E0+60 : repeat 20: ldi : rend 
ld hl,#E0F0 : ld de,#D1E0+60 : repeat 20: ldi : rend 
ld hl,#D0F0 : ld de,#E1E0+60 : repeat 20: ldi : rend 
ld hl,#C0F0 : ld de,#F1E0+60 : repeat 20: ldi : rend 
ld hl,#F0A0 : ld de,#C230+60 : repeat 20: ldi : rend 
ld hl,#E0A0 : ld de,#D230+60 : repeat 20: ldi : rend 
ld hl,#D0A0 : ld de,#E230+60 : repeat 20: ldi : rend 
ld hl,#C0A0 : ld de,#F230+60 : repeat 20: ldi : rend 
ld hl,#F050 : ld de,#C280+60 : repeat 20: ldi : rend 
ld hl,#E050 : ld de,#D280+60 : repeat 20: ldi : rend 
ld hl,#D050 : ld de,#E280+60 : repeat 20: ldi : rend 
ld hl,#C050 : ld de,#F280+60 : repeat 20: ldi : rend 
ld hl,#F000 : ld de,#C2D0+60 : repeat 20: ldi : rend 
ld hl,#E000 : ld de,#D2D0+60 : repeat 20: ldi : rend 
ld hl,#D000 : ld de,#E2D0+60 : repeat 20: ldi : rend 
ld hl,#C000 : ld de,#F2D0+60 : repeat 20: ldi : rend 


		 
		ld bc,#7f10
		ld a,INK03
		out (c),c
		out (c),a


pile	
		ld sp,table
		ret
    
nxt1
		ld b,#7f
        ld a,#c0
		out (c),a        
		nop:nop:nop
		ld (pile+1),sp
		jp cont

nxt2
		ld b,#7f
        ld a,#c4
		out (c),a        
		nop:nop:nop
		ld (pile+1),sp
		jp cont

nxt3
		ld b,#7f
        ld a,#c5
		out (c),a        
		nop:nop:nop
		ld (pile+1),sp
		jp cont

nxt4
		ld b,#7f
        ld a,#c0
		out (c),a
		ld sp,table
		ld (pile+1),sp
		jp cont

cont

		ld bc,#7f10
		ld l,INK04
		out (c),c
		out (c),l

		ld (stack+1),sp		; save contexte de pile (table de ret...)
        
pilorg	ld sp,0				; set contexte de pile "standard"
		ei					; 
		ld (bnk+1),a
        ld bc,#7fc6
        out (c),c			; zik en bank #c6
        call #541E			; car le player AYC bien sûr balance des ret en pagaille ^^
        ld b,#7f
bnk		ld a,0        		; Et il faut en plus retomber sur nos pas en terme de bank...
	    out (c),a
        di 					; Ptet pas meilleure solution mon truc, mais pfiou, ça marche ^^

stack	ld sp,0				; on revient dans notre contexte de pile (table de ret)      

		ld bc,#7f10
		ld a,INK00
		out (c),c
		out (c),a   

		wline 40		; il en reste, on peut rajouter des trucs ^^     
        
        
sloww ld a,0        
	 xor #ff
     ld (sloww+1),a
     or a
     jp z,hop
        
; Quick''n''dirty scroll ^^        

ld bc,#2e
ld de,move+#01
ld hl,move+#2f

ld a,(move+#01)
ld (_sauve+1),a
ld a,(move+#02)
ld (_sauve+2),a

repeat 79

ld a,(hl)
ld (de),a
inc de
inc hl
ld a,(hl)
ld (de),a

dec hl
dec de

add hl,bc
ex hl,de
add hl,bc
ex hl,de


rend

_sauve
ld hl,0
ex de,hl
ld (hl),e
inc hl
ld (hl),d
ex de,hl

hop

; Quick''n''dirty scroll ^^  

        
        ld bc,#bc07
        out (c),c
        ld bc,#bd00+4	; vite fait... à revérifier...
        
        out (c),c
        ld bc,#bc04
        out (c),c
        ld bc,#bd00+2	; vite fait... à revérifier...
    

		jp mainloop

table
dw slow,nxt1	
dw p1to2,nxt1
dw slow,nxt1	
dw p2to3,nxt1
dw slow,nxt1	
dw p3to4,nxt1
dw slow,nxt1	
dw p4to5,nxt1
dw slow,nxt1	
dw p5to6,nxt1
dw slow,nxt1	
dw p6to7,nxt1
dw slow,nxt1	
dw p7to8,nxt1
dw slow,nxt1
dw p8to9,nxt1
dw slow,nxt1	
dw p9to10,nxt1
dw slow,nxt1	
dw p10to11,nxt1
dw slow,nxt1	
dw p11to12,nxt1
dw slow,nxt1	
dw p12to13,nxt1
dw slow,nxt1	
dw p13to14,nxt1
dw slow,nxt1	
dw p14to15,nxt1
dw slow,nxt1	
dw p15to16,nxt1
dw slow,nxt1	
dw p16to17,nxt1
dw slow,nxt1	
dw p17to18,nxt1
dw slow,nxt1	
dw p18to19,nxt1
dw slow,nxt1	
dw p19to20,nxt1
dw slow,nxt1	
dw p20to21,nxt1
dw slow,nxt1	
dw p21to22,nxt1
dw slow,nxt1	
dw p22to23,nxt1
dw slow,nxt1	
dw p23to24,nxt1
dw slow,nxt1	
dw p24to25,nxt1
dw slow,nxt1	
dw p25to26,nxt1
dw slow,nxt1	
dw p26to27,nxt1
dw slow,nxt1
dw p27to28,nxt1
dw slow,nxt1
dw p28to29,nxt1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c4
dw slow,nxt2
dw p30to31,nxt2
dw slow,nxt2
dw p31to32,nxt2
dw slow,nxt2
dw p32to33,nxt2
dw slow,nxt2
dw p33to34,nxt2
dw slow,nxt2
dw p34to35,nxt2
dw slow,nxt2
dw p35to36,nxt2
dw slow,nxt2
dw p36to37,nxt2
dw slow,nxt2
dw p37to38,nxt2
dw slow,nxt2
dw p38to39,nxt2
dw slow,nxt2
dw p39to40,nxt2
dw slow,nxt2
dw p40to41,nxt2
dw slow,nxt2
dw p41to42,nxt2
dw slow,nxt2
dw p42to43,nxt2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;c5
dw slow,nxt3
dw p43to44,nxt3
dw slow,nxt3
dw p44to45,nxt3
dw slow,nxt3
dw p45to46,nxt3
dw slow,nxt3
dw p46to47,nxt3
dw slow,nxt3
dw p47to48,nxt3
dw slow,nxt3
dw p48to49,nxt3
dw slow,nxt3
dw p49to50,nxt3
dw slow,nxt3
dw p50to51,nxt3
dw slow,nxt3
dw p51to52,nxt3
dw slow,nxt3
dw p52to53,nxt3
dw slow,nxt3
dw p53to1,nxt4

 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

slow
  
	wline 20	; 20 lignes approx (au pifomètre) car aucune idée encore 
    			; à ce stade combien de maxnop... '' verra plus tard...
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; delta en ld (nn),a 
; "poutraillage de pixels!" mais ça doit bien se compresser...
p1to2
ld a,#00
ld (#C00B),a
ld (#E006),a
ld (#E011),a
ld (#F00B),a
ld (#C058),a
ld (#C059),a
ld (#C05E),a
ld (#D053),a
ld (#F059),a
ld (#C0A7),a
ld (#D0A8),a
ld (#D0AB),a
ld (#D0AE),a
ld (#F0A0),a
ld (#C0F1),a
ld (#C0F9),a
ld (#F0F2),a
ld (#C142),a
ld (#F144),a
ld (#C199),a
ld (#D19F),a
ld (#D1F1),a
ld (#E1E0),a
ld (#E1E1),a
ld (#E1E2),a
ld (#F1E1),a
ld (#F1F0),a
ld (#E239),a
ld (#E293),a
ld (#F28B),a
ld (#C2D4),a
ld (#E2D5),a
ld (#E2E1),a
ld a,#01
ld (#E010),a
ld (#E051),a
ld (#E062),a
ld (#C0A8),a
ld (#C0F7),a
ld (#F0F6),a
ld (#F100),a
ld (#D1F0),a
ld (#D241),a
ld (#F293),a
ld (#C2DE),a
ld a,#02
ld (#F056),a
ld (#F063),a
ld (#E0B3),a
ld (#D0F1),a
ld (#D0F8),a
ld (#E0FC),a
ld (#C14E),a
ld (#C23E),a
ld (#D243),a
ld (#F232),a
ld (#C280),a
ld (#F282),a
ld a,#03
ld (#D0B3),a
ld (#F0FD),a
ld a,#04
ld (#D054),a
ld (#F0A2),a
ld (#D0F9),a
ld (#E242),a
ld (#C284),a
ld (#F2DC),a
ld a,#05
ld (#E191),a
ld (#C28E),a
ld (#E28C),a
ld (#E2D6),a
ld a,#06
ld (#E195),a
ld (#E280),a
ld a,#08
ld (#C00E),a
ld (#E005),a
ld (#E060),a
ld (#E063),a
ld (#E0A6),a
ld (#E0B0),a
ld (#E1F3),a
ld (#F1F3),a
ld (#D2E0),a
ld a,#09
ld (#E0A1),a
ld (#C0F0),a
ld (#E1EC),a
ld (#D286),a
ld (#F2DB),a
ld a,#0A
ld (#F050),a
ld (#F051),a
ld (#D149),a
ld (#D19A),a
ld (#F1E0),a
ld (#F1F2),a
ld (#F230),a
ld (#D293),a
ld a,#0C
ld (#C148),a
ld (#F196),a
ld (#C243),a
ld a,#0D
ld (#E050),a
ld (#C242),a
ld a,#10
ld (#C005),a
ld (#C00F),a
ld (#E057),a
ld (#E061),a
ld (#D0AC),a
ld (#E0B1),a
ld (#C140),a
ld (#C149),a
ld (#C19A),a
ld (#C1A0),a
ld (#F19F),a
ld (#C1F2),a
ld (#E1E3),a
ld (#E233),a
ld (#E23D),a
ld (#E283),a
ld (#E28D),a
ld (#F285),a
ld (#C2DF),a
ld (#D2D7),a
ld (#F2D3),a
ld a,#12
ld (#D00F),a
ld (#F006),a
ld (#D05F),a
ld (#F0B1),a
ld (#D1A0),a
ld (#E287),a
ld (#F28D),a
ld (#D2D4),a
ld a,#14
ld (#E012),a
ld a,#15
ld (#F0A1),a
ld a,#16
ld (#C1E7),a
ld a,#18
ld (#D055),a
ld (#F052),a
ld (#F140),a
ld (#F190),a
ld (#C230),a
ld (#D230),a
ld (#C288),a
ld a,#19
ld (#F146),a
ld a,#1A
ld (#D1EB),a
ld (#F2DD),a
ld a,#1C
ld (#C063),a
ld a,#1E
ld (#C2D1),a
ld a,#22
ld (#C197),a
ld (#F241),a
ld a,#23
ld (#C012),a
ld (#D001),a
ld (#E013),a
ld (#E19B),a
ld a,#26
ld (#E001),a
ld (#D280),a
ld a,#27
ld (#D052),a
ld a,#2A
ld (#D012),a
ld (#E0A5),a
ld (#C0F2),a
ld (#E243),a
ld (#D28F),a
ld a,#2B
ld (#F2D0),a
ld a,#2E
ld (#F013),a
ld a,#33
ld (#E0F3),a
ld a,#37
ld (#E0A2),a
ld a,#3A
ld (#E0F5),a
ld (#F0F7),a
ld a,#40
ld (#D003),a
ld (#F005),a
ld (#E05D),a
ld (#F055),a
ld (#D0A7),a
ld (#F0AF),a
ld (#E0FB),a
ld (#E153),a
ld (#C19E),a
ld (#C1F3),a
ld (#E1EB),a
ld (#F1EC),a
ld (#C233),a
ld (#C23D),a
ld (#C28D),a
ld (#C290),a
ld (#E286),a
ld (#C2DD),a
ld (#D2DD),a
ld (#E2E2),a
ld a,#41
ld (#E292),a
ld (#C2E1),a
ld (#E2D0),a
ld a,#42
ld (#E05B),a
ld (#C0B3),a
ld (#D0AD),a
ld (#C147),a
ld (#D1E8),a
ld (#D2E3),a
ld a,#44
ld (#F009),a
ld (#C0A9),a
ld (#F0F3),a
ld (#D239),a
ld a,#47
ld (#D242),a
ld a,#48
ld (#E100),a
ld (#F193),a
ld (#C286),a
ld a,#49
ld (#E14B),a
ld a,#4A
ld (#C00D),a
ld (#F103),a
ld (#F153),a
ld (#E1A1),a
ld (#C2D3),a
ld a,#4B
ld (#E055),a
ld a,#50
ld (#D00C),a
ld (#E002),a
ld (#E00B),a
ld (#E00D),a
ld (#E00E),a
ld (#F00F),a
ld (#F010),a
ld (#F011),a
ld (#F012),a
ld (#E059),a
ld (#C0B1),a
ld (#E0A7),a
ld (#E0B2),a
ld (#F0A8),a
ld (#F0A9),a
ld (#C0FF),a
ld (#C101),a
ld (#C103),a
ld (#D0FD),a
ld (#C153),a
ld (#D142),a
ld (#D153),a
ld (#D1A1),a
ld (#E196),a
ld (#C1E0),a
ld (#D1E0),a
ld (#D1E2),a
ld (#E237),a
ld (#F240),a
ld (#D28E),a
ld (#C2D6),a
ld (#C2DC),a
ld (#D2D8),a
ld a,#52
ld (#C00C),a
ld (#D00A),a
ld (#E00A),a
ld (#F142),a
ld (#F152),a
ld (#F1E2),a
ld (#F1E6),a
ld (#F28A),a
ld (#D2DE),a
ld a,#58
ld (#D002),a
ld (#D010),a
ld (#C054),a
ld (#D060),a
ld (#C0A2),a
ld (#E0F1),a
ld (#D1EC),a
ld (#F23E),a
ld (#F284),a
ld (#F28E),a
ld (#D2E2),a
ld (#F2DE),a
ld a,#5A
ld (#D005),a
ld (#E008),a
ld (#F061),a
ld (#F102),a
ld (#C152),a
ld (#D1EA),a
ld (#D1F2),a
ld (#E23A),a
ld (#F233),a
ld (#C28F),a
ld (#D285),a
ld a,#62
ld (#C292),a
ld a,#66
ld (#E19C),a
ld a,#6A
ld (#D2DF),a
ld a,#72
ld (#C0FA),a
ld (#C0FD),a
ld (#E0FF),a
ld (#D194),a
ld (#F237),a
ld a,#7A
ld (#D143),a
ld (#C235),a
ld (#D23A),a
ld a,#88
ld (#D0A2),a
ld (#D14B),a
ld a,#8A
ld (#C23F),a
ld (#E28B),a
ld a,#8B
ld (#F19D),a
ld (#C241),a
ld a,#8C
ld (#D063),a
ld a,#8D
ld (#C1F0),a
ld a,#8E
ld (#F001),a
ld (#F280),a
ld a,#98
ld (#E0F6),a
ld (#C2D0),a
ld (#D2D1),a
ld (#F2E3),a
ld a,#9A
ld (#F0A7),a
ld (#F0F0),a
ld a,#9B
ld (#C198),a
ld a,#9C
ld (#E0A3),a
ld (#C2E2),a
ld a,#9D
ld (#D0FB),a
ld a,#AA
ld (#D0A1),a
ld (#E0A0),a
ld (#E0F4),a
ld (#F1ED),a
ld (#F242),a
ld (#F243),a
ld a,#AE
ld (#D0A3),a
ld a,#BA
ld (#E1F1),a
ld a,#CA
ld (#C003),a
ld (#D0F3),a
ld (#F1E3),a
ld a,#D8
ld (#F0FE),a
ld a,#DA
ld (#C05D),a
ld (#F062),a
ld (#F0F1),a
ld (#E14D),a
ld (#F14F),a
ld (#D19B),a
ld (#E1A0),a
ld (#D2D5),a
ld a,#DE
ld (#E052),a
ld a,#EE
ld (#F292),a
ld a,#FA
ld (#F007),a
ld (#C0A1),a
ld (#E0AF),a
ld (#D0F2),a
ld (#D23B),a
ret

p2to3
ld a,#00
ld (#C004),a
ld (#C009),a
ld (#C00E),a
ld (#E005),a
ld (#F00C),a
ld (#C052),a
ld (#D05E),a
ld (#E060),a
ld (#E061),a
ld (#E062),a
ld (#D0A7),a
ld (#E0AC),a
ld (#E0B1),a
ld (#D0F1),a
ld (#E0F0),a
ld (#F100),a
ld (#F101),a
ld (#E140),a
ld (#F151),a
ld (#C1F1),a
ld (#E1F3),a
ld (#F1F3),a
ld (#C233),a
ld (#C23B),a
ld (#C23E),a
ld (#C243),a
ld (#C284),a
ld (#D289),a
ld (#D293),a
ld (#E286),a
ld (#D2D9),a
ld (#E2DC),a
ld (#E2DD),a
ld a,#01
ld (#F00B),a
ld (#D053),a
ld (#F0A1),a
ld (#C142),a
ld (#C283),a
ld (#C28E),a
ld (#D286),a
ld (#E28C),a
ld a,#02
ld (#C053),a
ld (#D05F),a
ld (#F0B1),a
ld (#C0F2),a
ld (#F0FD),a
ld (#F28D),a
ld (#F293),a
ld (#E2E3),a
ld (#F2DD),a
ld a,#03
ld (#D2E1),a
ld a,#04
ld (#E011),a
ld (#F009),a
ld (#D0A4),a
ld (#C0F1),a
ld (#F0F3),a
ld (#C148),a
ld (#C199),a
ld (#E191),a
ld (#E195),a
ld (#C1E9),a
ld (#D1E9),a
ld (#D236),a
ld (#D242),a
ld (#E28D),a
ld a,#05
ld (#C0A9),a
ld (#D0AE),a
ld (#F0F6),a
ld (#D1F0),a
ld (#C242),a
ld (#E293),a
ld (#E2D5),a
ld a,#06
ld (#D054),a
ld (#D280),a
ld a,#08
ld (#C05E),a
ld (#F0A0),a
ld (#F193),a
ld (#F1EE),a
ld (#F1F2),a
ld (#C2D3),a
ld a,#09
ld (#C19F),a
ld a,#0A
ld (#C050),a
ld (#C057),a
ld (#C0A0),a
ld (#D0A2),a
ld (#E0A0),a
ld (#E0B0),a
ld (#D243),a
ld (#E242),a
ld (#F282),a
ld a,#0C
ld (#D0F9),a
ld a,#0D
ld (#F2DB),a
ld a,#0E
ld (#D063),a
ld (#F050),a
ld a,#10
ld (#C000),a
ld (#C05F),a
ld (#D0A5),a
ld (#D0A9),a
ld (#D0AF),a
ld (#D0FF),a
ld (#E101),a
ld (#D14F),a
ld (#E151),a
ld (#F143),a
ld (#E1A2),a
ld (#C1EB),a
ld (#E1E6),a
ld (#E1ED),a
ld (#F2D6),a
ld a,#11
ld (#D241),a
ld a,#12
ld (#F056),a
ld (#C1E7),a
ld (#D1F1),a
ld a,#14
ld (#D000),a
ld (#E23D),a
ld (#F2D9),a
ld a,#15
ld (#E051),a
ld a,#18
ld (#D05B),a
ld (#F283),a
ld (#E2D1),a
ld a,#1A
ld (#F006),a
ld (#F0F0),a
ld (#E145),a
ld (#F23D),a
ld (#C28F),a
ld a,#1D
ld (#F146),a
ld a,#22
ld (#D004),a
ld (#F013),a
ld (#F0A6),a
ld a,#23
ld (#D012),a
ld (#F241),a
ld a,#2A
ld (#F14E),a
ld (#F1ED),a
ld (#C23F),a
ld a,#2F
ld (#F2D0),a
ld a,#32
ld (#F147),a
ld (#C197),a
ld a,#33
ld (#C012),a
ld a,#36
ld (#E14C),a
ld a,#3A
ld (#C002),a
ld a,#3B
ld (#E0F3),a
ld a,#3E
ld (#C063),a
ld a,#40
ld (#D00D),a
ld (#E000),a
ld (#E00F),a
ld (#D05D),a
ld (#F05F),a
ld (#F063),a
ld (#C0A6),a
ld (#D0AD),a
ld (#F0A5),a
ld (#D0F7),a
ld (#E103),a
ld (#C141),a
ld (#C147),a
ld (#E143),a
ld (#F1A1),a
ld (#C1E3),a
ld (#F1E6),a
ld (#F1F0),a
ld (#C23A),a
ld (#E23B),a
ld (#F23C),a
ld (#D283),a
ld (#D288),a
ld (#E285),a
ld (#C2E1),a
ld (#D2D3),a
ld (#E2DF),a
ld (#F2D5),a
ld a,#41
ld (#D2D0),a
ld a,#42
ld (#F14D),a
ld (#F230),a
ld a,#43
ld (#F2E2),a
ld a,#48
ld (#C00D),a
ld (#E05F),a
ld (#E2DB),a
ld (#F2D8),a
ld a,#4A
ld (#D238),a
ld (#D2DF),a
ld a,#4E
ld (#E19C),a
ld a,#50
ld (#C005),a
ld (#D002),a
ld (#D006),a
ld (#D007),a
ld (#D00A),a
ld (#E009),a
ld (#C054),a
ld (#C062),a
ld (#D051),a
ld (#E057),a
ld (#F052),a
ld (#E0A4),a
ld (#C0FB),a
ld (#C102),a
ld (#E0F1),a
ld (#C140),a
ld (#C14F),a
ld (#C151),a
ld (#D148),a
ld (#E14F),a
ld (#C194),a
ld (#C1A2),a
ld (#E193),a
ld (#C1F2),a
ld (#C1F3),a
ld (#E1E3),a
ld (#E1EB),a
ld (#D237),a
ld (#F23B),a
ld (#E282),a
ld (#E283),a
ld (#F284),a
ld (#F285),a
ld (#C2D5),a
ld (#C2D7),a
ld (#C2D9),a
ld (#C2DB),a
ld (#D2DD),a
ld (#D2DE),a
ld a,#52
ld (#C056),a
ld (#D0AA),a
ld (#C0FA),a
ld (#F192),a
ld (#C237),a
ld (#D235),a
ld (#E237),a
ld (#E23A),a
ld (#F237),a
ld (#D284),a
ld (#C2D2),a
ld a,#58
ld (#E008),a
ld (#D0B0),a
ld (#C0F3),a
ld (#D0F4),a
ld (#C152),a
ld (#D144),a
ld (#F140),a
ld (#D1F3),a
ld (#E230),a
ld (#F2D1),a
ld a,#5A
ld (#F062),a
ld (#E0AF),a
ld (#F0B3),a
ld (#E150),a
ld (#F142),a
ld (#E1A0),a
ld (#C235),a
ld (#D28B),a
ld (#D28C),a
ld (#F28E),a
ld (#D2D5),a
ld (#F2D7),a
ld (#F2DE),a
ld a,#62
ld (#E19B),a
ld (#D28F),a
ld a,#63
ld (#E2D0),a
ld a,#6A
ld (#E0F2),a
ld (#C292),a
ld a,#6E
ld (#E001),a
ld a,#72
ld (#F1E2),a
ld a,#7A
ld (#F007),a
ld (#C05A),a
ld (#D0F2),a
ld (#F0F1),a
ld (#E2DA),a
ld a,#7F
ld (#C240),a
ld a,#88
ld (#F001),a
ld (#F1E0),a
ld (#E28B),a
ld (#C2D0),a
ld (#D2E0),a
ld a,#89
ld (#C1F0),a
ld a,#8A
ld (#C003),a
ld (#E055),a
ld (#E243),a
ld (#C293),a
ld (#D290),a
ld a,#8B
ld (#E0A1),a
ld a,#8C
ld (#F2E3),a
ld a,#8E
ld (#C241),a
ld a,#98
ld (#E0A3),a
ld (#D291),a
ld (#D2E2),a
ld a,#99
ld (#D0FB),a
ld (#C198),a
ld a,#9A
ld (#F280),a
ld a,#9E
ld (#E052),a
ld (#E280),a
ld (#C2E2),a
ld a,#AB
ld (#F19D),a
ld a,#BA
ld (#F0F7),a
ld (#F242),a
ld a,#C8
ld (#E100),a
ld a,#C9
ld (#C1E8),a
ld a,#CA
ld (#F1A0),a
ld a,#D8
ld (#C013),a
ld (#F0A7),a
ld (#F14F),a
ld (#C238),a
ld (#F23E),a
ld a,#DA
ld (#D010),a
ld (#F000),a
ld (#C0AD),a
ld (#E1F1),a
ld (#D23C),a
ld (#E2D8),a
ld a,#EA
ld (#E0A5),a
ld (#F1F1),a
ld (#D285),a
ld a,#EF
ld (#D052),a
ld (#C291),a
ld (#F292),a
ld a,#FA
ld (#C05D),a
ld (#F0B2),a
ld (#E0F5),a
ld (#E28A),a
ret

p3to4
ld a,#00
ld (#C00F),a
ld (#D003),a
ld (#E010),a
ld (#F005),a
ld (#C05F),a
ld (#D057),a
ld (#D05F),a
ld (#E063),a
ld (#C0A8),a
ld (#D0AF),a
ld (#F0B1),a
ld (#C0F0),a
ld (#E0FC),a
ld (#E101),a
ld (#C143),a
ld (#E191),a
ld (#C1E3),a
ld (#D1E9),a
ld (#D1F0),a
ld (#F1F2),a
ld (#C239),a
ld (#D236),a
ld (#E236),a
ld (#C283),a
ld (#D283),a
ld (#D286),a
ld (#E285),a
ld (#E28C),a
ld (#E28D),a
ld (#C2DE),a
ld (#D2D3),a
ld (#D2D6),a
ld (#E2D5),a
ld (#E2D6),a
ld (#F2D5),a
ld (#F2DC),a
ld a,#01
ld (#C001),a
ld (#C058),a
ld (#E0B3),a
ld (#D0FE),a
ld (#C23E),a
ld (#D241),a
ld (#D292),a
ld (#E2DC),a
ld (#F2DB),a
ld a,#02
ld (#D00F),a
ld (#D054),a
ld (#C199),a
ld (#C23A),a
ld (#F23D),a
ld (#F241),a
ld a,#03
ld (#E013),a
ld a,#04
ld (#E012),a
ld (#F00C),a
ld (#C059),a
ld (#E061),a
ld (#C0A9),a
ld (#D0A9),a
ld (#C0F7),a
ld (#F196),a
ld (#C242),a
ld (#D289),a
ld (#E286),a
ld (#C2DF),a
ld (#E2DD),a
ld a,#05
ld (#C233),a
ld (#D293),a
ld a,#06
ld (#F0F6),a
ld (#C280),a
ld a,#07
ld (#E050),a
ld a,#08
ld (#D051),a
ld (#C0AE),a
ld (#C19F),a
ld (#F190),a
ld (#C1EA),a
ld (#C23B),a
ld a,#0A
ld (#C003),a
ld (#D004),a
ld (#C05E),a
ld (#D050),a
ld (#F0A0),a
ld (#D0F8),a
ld (#D1EB),a
ld (#C23F),a
ld (#C292),a
ld (#C293),a
ld (#F293),a
ld (#E2DB),a
ld a,#0C
ld (#E055),a
ld (#E23D),a
ld a,#0D
ld (#F050),a
ld (#D0A8),a
ld (#D0F9),a
ld a,#10
ld (#C004),a
ld (#D000),a
ld (#D011),a
ld (#C053),a
ld (#E056),a
ld (#F059),a
ld (#F060),a
ld (#C0AB),a
ld (#C0AF),a
ld (#E0A6),a
ld (#E0B2),a
ld (#E141),a
ld (#F191),a
ld (#C230),a
ld (#E239),a
ld (#F2D9),a
ld a,#12
ld (#F152),a
ld (#C1E4),a
ld (#C28F),a
ld a,#14
ld (#E1E6),a
ld a,#17
ld (#E051),a
ld a,#18
ld (#E0F6),a
ld a,#1A
ld (#F00D),a
ld (#F102),a
ld (#D23C),a
ld (#F232),a
ld (#C2D1),a
ld (#D2D4),a
ld (#F2D6),a
ld (#F2DE),a
ld a,#1C
ld (#F051),a
ld a,#22
ld (#C063),a
ld (#C197),a
ld (#F1ED),a
ld a,#23
ld (#F013),a
ld (#E2D0),a
ld a,#26
ld (#D001),a
ld a,#2A
ld (#C002),a
ld (#C0A1),a
ld (#E1EC),a
ld (#D243),a
ld (#E242),a
ld a,#2B
ld (#E0F3),a
ld a,#2E
ld (#D063),a
ld a,#2F
ld (#F292),a
ld a,#32
ld (#C1E7),a
ld (#E287),a
ld a,#33
ld (#C1EF),a
ld a,#3A
ld (#F0B2),a
ld (#F147),a
ld (#F28E),a
ld a,#3B
ld (#E144),a
ld a,#3F
ld (#E0A2),a
ld (#C291),a
ld a,#40
ld (#C00B),a
ld (#E05B),a
ld (#C0B3),a
ld (#D0B3),a
ld (#F0F5),a
ld (#D14E),a
ld (#D199),a
ld (#E1A3),a
ld (#F19C),a
ld (#D1E8),a
ld (#C232),a
ld (#D240),a
ld (#E231),a
ld (#F234),a
ld (#E284),a
ld (#E2D4),a
ld (#F2E2),a
ld a,#41
ld (#C147),a
ld a,#42
ld (#E004),a
ld (#C056),a
ld (#E0F2),a
ld (#C14E),a
ld (#C282),a
ld (#D28F),a
ld (#D2DF),a
ld a,#43
ld (#C012),a
ld a,#44
ld (#F19E),a
ld a,#46
ld (#E14C),a
ld a,#48
ld (#E1A1),a
ld (#D1E5),a
ld (#E1F2),a
ld (#C290),a
ld (#F288),a
ld a,#49
ld (#C2D0),a
ld a,#4A
ld (#F008),a
ld (#F142),a
ld (#F1E3),a
ld (#D235),a
ld (#E243),a
ld a,#4B
ld (#D238),a
ld a,#50
ld (#C000),a
ld (#D005),a
ld (#D00D),a
ld (#E007),a
ld (#E008),a
ld (#E00F),a
ld (#D055),a
ld (#D062),a
ld (#E05D),a
ld (#E05E),a
ld (#E05F),a
ld (#F057),a
ld (#F058),a
ld (#F05F),a
ld (#D0A5),a
ld (#C0FA),a
ld (#D103),a
ld (#C141),a
ld (#C149),a
ld (#C152),a
ld (#E143),a
ld (#E14E),a
ld (#E153),a
ld (#F140),a
ld (#C1A0),a
ld (#C1A3),a
ld (#D195),a
ld (#E194),a
ld (#E19D),a
ld (#E19F),a
ld (#D1F3),a
ld (#E1E5),a
ld (#F1F0),a
ld (#C23D),a
ld (#D230),a
ld (#E233),a
ld (#E23A),a
ld (#E23B),a
ld (#F235),a
ld (#F23C),a
ld (#C285),a
ld (#C286),a
ld (#C28D),a
ld (#F283),a
ld (#F28A),a
ld (#F291),a
ld (#C2DD),a
ld (#E2DF),a
ld (#F2D1),a
ld (#F2D2),a
ld (#F2D3),a
ld (#F2DA),a
ld a,#52
ld (#E054),a
ld (#E0A4),a
ld (#C0FD),a
ld (#E0FF),a
ld (#D194),a
ld (#D1EA),a
ld (#D234),a
ld (#C2E3),a
ld a,#58
ld (#C00D),a
ld (#D013),a
ld (#E00B),a
ld (#F0A7),a
ld (#C195),a
ld (#E1A0),a
ld (#D1F2),a
ld (#D28D),a
ld (#E2D1),a
ld (#E2D8),a
ld a,#5A
ld (#F007),a
ld (#F00E),a
ld (#D060),a
ld (#D0B0),a
ld (#E0A0),a
ld (#F0F0),a
ld (#F153),a
ld (#D23B),a
ld a,#62
ld (#F14D),a
ld a,#63
ld (#D2D0),a
ld a,#6A
ld (#C2D2),a
ld a,#72
ld (#D143),a
ld (#D28A),a
ld a,#7A
ld (#D0AA),a
ld (#F192),a
ld (#F1E2),a
ld (#E28A),a
ld a,#88
ld (#F1EE),a
ld a,#89
ld (#D0AB),a
ld (#F2D8),a
ld a,#8A
ld (#F000),a
ld (#D0A3),a
ld (#E0A1),a
ld (#E0A5),a
ld (#F1A0),a
ld (#F243),a
ld (#D2E0),a
ld a,#8D
ld (#E19C),a
ld (#C241),a
ld a,#8E
ld (#F2E3),a
ld a,#98
ld (#C013),a
ld (#F001),a
ld (#E052),a
ld (#E280),a
ld (#F280),a
ld a,#99
ld (#C1E8),a
ld a,#9A
ld (#F056),a
ld (#E0F4),a
ld (#D19B),a
ld a,#9D
ld (#C198),a
ld a,#9E
ld (#D280),a
ld a,#AA
ld (#D0F3),a
ld a,#AE
ld (#F2D0),a
ld a,#C8
ld (#C238),a
ld a,#CA
ld (#E100),a
ld (#F1F1),a
ld (#D285),a
ld a,#D8
ld (#C0A2),a
ld (#D1EC),a
ld a,#DA
ld (#C05D),a
ld (#F0F7),a
ld (#F23E),a
ld a,#EA
ld (#D0A1),a
ld (#E0F5),a
ld (#F19D),a
ld a,#EB
ld (#D0A2),a
ld (#E14B),a
ld a,#EE
ld (#E001),a
ld (#D052),a
ld (#C2E2),a
ld a,#FA
ld (#C050),a
ld (#C05A),a
ld (#D23A),a
ld (#F242),a
ld (#D284),a
ld (#D28B),a
ld (#D28C),a
ld (#F2D7),a
ret

p4to5
ld a,#00
ld (#C008),a
ld (#E00C),a
ld (#E00D),a
ld (#E012),a
ld (#F009),a
ld (#C056),a
ld (#C057),a
ld (#D058),a
ld (#F055),a
ld (#F05C),a
ld (#C0A0),a
ld (#C0A9),a
ld (#C0AF),a
ld (#D0A4),a
ld (#D0AE),a
ld (#E0B0),a
ld (#E0B2),a
ld (#E0B3),a
ld (#F0A1),a
ld (#D0F9),a
ld (#F0F3),a
ld (#E195),a
ld (#F190),a
ld (#E235),a
ld (#C28E),a
ld (#E284),a
ld (#F285),a
ld (#F28D),a
ld (#C2D3),a
ld (#E2D4),a
ld (#F2DB),a
ld a,#01
ld (#C00F),a
ld (#E000),a
ld (#C0A6),a
ld (#C0F2),a
ld (#C147),a
ld (#C1E3),a
ld (#C232),a
ld a,#02
ld (#C001),a
ld (#F00D),a
ld (#D063),a
ld (#D0A0),a
ld (#D0A7),a
ld (#F102),a
ld (#C148),a
ld (#D14A),a
ld (#F152),a
ld (#F1A3),a
ld (#D1EB),a
ld (#F1E1),a
ld (#F1ED),a
ld (#D242),a
ld (#D283),a
ld (#E28D),a
ld (#D2D3),a
ld (#F2D5),a
ld a,#03
ld (#F013),a
ld a,#04
ld (#F051),a
ld (#D0FF),a
ld (#E0FC),a
ld (#D14F),a
ld (#C233),a
ld a,#05
ld (#E011),a
ld (#E061),a
ld (#D241),a
ld (#E285),a
ld (#C2DF),a
ld (#E2DC),a
ld (#E2DD),a
ld a,#06
ld (#C28F),a
ld a,#07
ld (#F050),a
ld (#D293),a
ld a,#08
ld (#D011),a
ld (#C05E),a
ld (#E0B1),a
ld (#E101),a
ld (#E145),a
ld (#E151),a
ld (#E1F2),a
ld (#F1E0),a
ld (#E23D),a
ld a,#09
ld (#D051),a
ld (#E050),a
ld a,#0A
ld (#C002),a
ld (#C0A1),a
ld (#C0AE),a
ld (#C199),a
ld (#F231),a
ld (#F243),a
ld (#D2E1),a
ld a,#0B
ld (#D19A),a
ld (#C293),a
ld a,#0C
ld (#F19E),a
ld (#E293),a
ld a,#0E
ld (#C23F),a
ld a,#10
ld (#C010),a
ld (#E006),a
ld (#C060),a
ld (#E0AC),a
ld (#C0F8),a
ld (#E0F6),a
ld (#E102),a
ld (#F0F2),a
ld (#F140),a
ld (#D195),a
ld (#E19D),a
ld (#C1F1),a
ld (#D1E9),a
ld (#E1E2),a
ld (#C23C),a
ld (#D233),a
ld (#D236),a
ld (#E232),a
ld (#E28E),a
ld (#F286),a
ld (#C2D4),a
ld (#E2D7),a
ld (#E2DE),a
ld a,#11
ld (#C058),a
ld a,#12
ld (#D0F2),a
ld (#F191),a
ld a,#13
ld (#E144),a
ld a,#16
ld (#E063),a
ld a,#18
ld (#E0FD),a
ld (#F0F0),a
ld (#C28C),a
ld (#F282),a
ld (#D2DD),a
ld a,#1A
ld (#D054),a
ld (#D060),a
ld (#D0B0),a
ld (#F0B2),a
ld (#D19B),a
ld (#F28E),a
ld a,#1C
ld (#C280),a
ld a,#22
ld (#F005),a
ld a,#23
ld (#C063),a
ld (#C1EF),a
ld (#F292),a
ld (#D2D0),a
ld a,#26
ld (#E2D0),a
ld a,#2A
ld (#F0A6),a
ld (#D0F3),a
ld (#F19D),a
ld a,#2B
ld (#E0A2),a
ld a,#37
ld (#E051),a
ld (#C291),a
ld a,#3A
ld (#D010),a
ld (#D0FA),a
ld a,#3F
ld (#C240),a
ld a,#40
ld (#C00E),a
ld (#C012),a
ld (#E004),a
ld (#D056),a
ld (#D0A6),a
ld (#E0AB),a
ld (#F0AC),a
ld (#C0F6),a
ld (#C143),a
ld (#C192),a
ld (#F195),a
ld (#C1E2),a
ld (#C1E6),a
ld (#E1E5),a
ld (#D238),a
ld (#E23C),a
ld (#F241),a
ld (#C2DE),a
ld (#D2D6),a
ld (#F2D4),a
ld a,#41
ld (#D288),a
ld (#C2D0),a
ld a,#42
ld (#E013),a
ld (#F0FD),a
ld (#D2DC),a
ld a,#44
ld (#C059),a
ld (#E14C),a
ld (#D289),a
ld a,#45
ld (#F146),a
ld a,#48
ld (#C007),a
ld (#E00B),a
ld (#F008),a
ld (#C0FE),a
ld (#E0FB),a
ld (#F1E3),a
ld (#C282),a
ld (#E28B),a
ld a,#4A
ld (#F0B3),a
ld (#E100),a
ld (#C14E),a
ld (#D285),a
ld a,#4D
ld (#C198),a
ld a,#50
ld (#C00C),a
ld (#C00D),a
ld (#D00E),a
ld (#F059),a
ld (#F060),a
ld (#F061),a
ld (#F063),a
ld (#C0AB),a
ld (#C0AC),a
ld (#F0AF),a
ld (#C0F9),a
ld (#D0F0),a
ld (#D0F7),a
ld (#C19A),a
ld (#D199),a
ld (#E192),a
ld (#E1A0),a
ld (#E1A3),a
ld (#F194),a
ld (#D1E8),a
ld (#D1EA),a
ld (#E1F0),a
ld (#F1EC),a
ld (#C230),a
ld (#E230),a
ld (#E237),a
ld (#E239),a
ld (#F233),a
ld (#F234),a
ld (#D28F),a
ld (#F28B),a
ld (#F28C),a
ld (#C2E1),a
ld (#D2D7),a
ld (#D2DF),a
ld (#E2D1),a
ld (#E2E2),a
ld a,#52
ld (#E0A0),a
ld (#E0A8),a
ld (#E0AF),a
ld (#E0F2),a
ld (#D143),a
ld (#D148),a
ld (#F141),a
ld (#D1E4),a
ld (#C28B),a
ld (#F287),a
ld a,#58
ld (#C000),a
ld (#F00F),a
ld (#D061),a
ld (#F062),a
ld (#D0B1),a
ld (#E0A3),a
ld (#F0FE),a
ld (#F14F),a
ld (#C194),a
ld (#D1EC),a
ld (#F1E7),a
ld (#D23D),a
ld (#C290),a
ld (#F28F),a
ld (#D2D1),a
ld (#D2D5),a
ld (#F2DF),a
ld a,#5A
ld (#C006),a
ld (#F006),a
ld (#C05D),a
ld (#F0A0),a
ld (#D100),a
ld (#E0F9),a
ld (#E0FA),a
ld (#F1E2),a
ld (#D23A),a
ld (#D284),a
ld (#E28A),a
ld (#D2D4),a
ld a,#62
ld (#E054),a
ld (#C197),a
ld (#E1EC),a
ld a,#6A
ld (#E0A1),a
ld a,#6E
ld (#D001),a
ld (#C2E2),a
ld a,#72
ld (#C0AA),a
ld (#F14D),a
ld (#C2E3),a
ld a,#7A
ld (#C05A),a
ld (#D0A1),a
ld (#E150),a
ld (#D234),a
ld (#F23E),a
ld (#D28A),a
ld a,#89
ld (#D0FB),a
ld (#E19C),a
ld a,#8A
ld (#D235),a
ld (#D291),a
ld (#E2DB),a
ld a,#8B
ld (#C292),a
ld (#F2D8),a
ld a,#8E
ld (#D052),a
ld a,#98
ld (#F0F7),a
ld (#F1A0),a
ld (#D280),a
ld a,#9A
ld (#D004),a
ld a,#9C
ld (#D2E2),a
ld a,#9E
ld (#E001),a
ld a,#AA
ld (#D050),a
ld (#F293),a
ld (#D2E0),a
ld a,#BA
ld (#F00E),a
ld (#E0F4),a
ld (#E242),a
ld a,#C8
ld (#D14B),a
ld a,#CA
ld (#F142),a
ld (#C2D2),a
ld a,#D8
ld (#D013),a
ld (#D28D),a
ld a,#DA
ld (#F056),a
ld (#D243),a
ld a,#EA
ld (#F103),a
ld (#E14B),a
ld (#F242),a
ld a,#EE
ld (#F2D0),a
ld (#F2E3),a
ld a,#FA
ld (#C0AD),a
ld (#F147),a
ld (#F192),a
ld (#D290),a
ld a,#FB
ld (#D0A2),a
ret

p5to6
ld a,#00
ld (#D000),a
ld (#E00E),a
ld (#C05E),a
ld (#D056),a
ld (#E055),a
ld (#C0A6),a
ld (#D0A0),a
ld (#E0B1),a
ld (#F0A5),a
ld (#C0F1),a
ld (#C0F2),a
ld (#C0FF),a
ld (#D0FF),a
ld (#E102),a
ld (#C143),a
ld (#D14F),a
ld (#E14A),a
ld (#E152),a
ld (#F152),a
ld (#C192),a
ld (#E1A2),a
ld (#D1EB),a
ld (#F1ED),a
ld (#C232),a
ld (#C233),a
ld (#C242),a
ld (#E234),a
ld (#E285),a
ld (#E28D),a
ld (#E2DD),a
ld (#F2DD),a
ld a,#01
ld (#E004),a
ld (#E00D),a
ld (#E011),a
ld (#C058),a
ld (#E061),a
ld (#F050),a
ld (#E0B3),a
ld (#C1E2),a
ld (#C2DF),a
ld (#E2E3),a
ld a,#02
ld (#C00F),a
ld (#D003),a
ld (#D060),a
ld (#F055),a
ld (#C0A1),a
ld (#D0A4),a
ld (#D0B0),a
ld (#F285),a
ld (#F28E),a
ld a,#03
ld (#C063),a
ld (#D063),a
ld (#E144),a
ld (#C1EF),a
ld a,#04
ld (#C009),a
ld (#E062),a
ld (#F05C),a
ld (#E0B2),a
ld (#C1E3),a
ld (#C239),a
ld (#C23F),a
ld (#D239),a
ld (#D241),a
ld (#E236),a
ld (#C28F),a
ld (#D293),a
ld (#E2DC),a
ld (#E2DE),a
ld a,#05
ld (#C059),a
ld (#D053),a
ld (#D057),a
ld (#D058),a
ld (#C293),a
ld a,#06
ld (#C1E9),a
ld a,#08
ld (#C003),a
ld (#C0FE),a
ld (#D1E5),a
ld (#F243),a
ld (#C282),a
ld (#C288),a
ld (#C28C),a
ld a,#09
ld (#D0A8),a
ld (#C23B),a
ld a,#0A
ld (#C006),a
ld (#C007),a
ld (#F000),a
ld (#F00E),a
ld (#D0A7),a
ld (#F0B2),a
ld (#F0B3),a
ld (#E0F9),a
ld (#E101),a
ld (#C148),a
ld (#F1E0),a
ld (#F1E1),a
ld (#D23C),a
ld (#E23D),a
ld (#C28B),a
ld (#E293),a
ld (#F2D5),a
ld (#F2DE),a
ld a,#10
ld (#F009),a
ld (#C05C),a
ld (#D059),a
ld (#C0B0),a
ld (#E0F0),a
ld (#C149),a
ld (#C14F),a
ld (#F148),a
ld (#D19B),a
ld (#E1E6),a
ld (#C234),a
ld (#C284),a
ld (#C2E0),a
ld a,#12
ld (#D100),a
ld (#F0F0),a
ld (#D242),a
ld (#D283),a
ld a,#13
ld (#C240),a
ld a,#15
ld (#E000),a
ld a,#18
ld (#F001),a
ld (#D1EC),a
ld (#E1ED),a
ld (#F232),a
ld (#E280),a
ld a,#1A
ld (#F005),a
ld (#F153),a
ld a,#22
ld (#F0F6),a
ld (#F19D),a
ld (#D2D0),a
ld (#D2D3),a
ld a,#2A
ld (#E0A2),a
ld (#F103),a
ld (#C23A),a
ld (#F231),a
ld (#D2DC),a
ld (#D2E0),a
ld a,#2F
ld (#C2E2),a
ld a,#32
ld (#D0FA),a
ld (#D233),a
ld a,#33
ld (#C291),a
ld a,#3A
ld (#F23E),a
ld (#F286),a
ld (#C2E3),a
ld a,#3B
ld (#D051),a
ld a,#3F
ld (#E051),a
ld a,#40
ld (#D002),a
ld (#D006),a
ld (#D00F),a
ld (#E010),a
ld (#E013),a
ld (#F004),a
ld (#F008),a
ld (#C055),a
ld (#D05E),a
ld (#E060),a
ld (#E0B0),a
ld (#F0A1),a
ld (#F0B0),a
ld (#C0F0),a
ld (#D0F1),a
ld (#F100),a
ld (#F144),a
ld (#F14C),a
ld (#D199),a
ld (#E1E0),a
ld (#F1EA),a
ld (#D232),a
ld (#F23D),a
ld (#C28E),a
ld (#D282),a
ld (#D288),a
ld (#E292),a
ld (#F281),a
ld (#F284),a
ld (#F28D),a
ld (#D2D2),a
ld (#D2E3),a
ld (#E2E0),a
ld a,#42
ld (#E054),a
ld (#C197),a
ld a,#43
ld (#D012),a
ld (#F013),a
ld (#C2D0),a
ld a,#44
ld (#E0FC),a
ld (#F146),a
ld a,#45
ld (#C198),a
ld a,#4A
ld (#E0A8),a
ld (#E1A1),a
ld (#D28C),a
ld a,#4D
ld (#E14C),a
ld a,#50
ld (#C000),a
ld (#C004),a
ld (#C00B),a
ld (#C00E),a
ld (#E006),a
ld (#F007),a
ld (#C05B),a
ld (#D05D),a
ld (#E056),a
ld (#F062),a
ld (#D0AD),a
ld (#E0A0),a
ld (#E0A3),a
ld (#E0A6),a
ld (#E0AE),a
ld (#E0AF),a
ld (#F0A7),a
ld (#C0F8),a
ld (#E0F2),a
ld (#E0F6),a
ld (#C144),a
ld (#F150),a
ld (#C194),a
ld (#C195),a
ld (#C1E5),a
ld (#D1F2),a
ld (#F1E4),a
ld (#C235),a
ld (#C243),a
ld (#E231),a
ld (#E232),a
ld (#E23C),a
ld (#C290),a
ld (#D287),a
ld (#E288),a
ld (#F282),a
ld (#C2D4),a
ld (#D2D1),a
ld (#D2D5),a
ld (#D2D6),a
ld (#E2D7),a
ld (#E2D8),a
ld a,#52
ld (#C005),a
ld (#D05A),a
ld (#F05D),a
ld (#C0AA),a
ld (#F0FD),a
ld (#D150),a
ld (#E19B),a
ld (#F197),a
ld (#E287),a
ld (#E28A),a
ld a,#58
ld (#F006),a
ld (#E052),a
ld (#F056),a
ld (#F05F),a
ld (#C0A2),a
ld (#E0A9),a
ld (#D101),a
ld (#D14B),a
ld (#F1A0),a
ld (#F1E3),a
ld (#D23B),a
ld (#E237),a
ld (#F280),a
ld (#D2D4),a
ld a,#5A
ld (#F05E),a
ld (#D0B1),a
ld (#E0A1),a
ld (#F0F1),a
ld (#E150),a
ld (#D1E4),a
ld (#E1F1),a
ld (#D285),a
ld (#D2DB),a
ld (#F2D6),a
ld (#F2D7),a
ld (#F2DF),a
ld a,#6E
ld (#E2D0),a
ld (#F2E3),a
ld a,#72
ld (#E0A4),a
ld (#C237),a
ld a,#7A
ld (#C0AD),a
ld (#E0FA),a
ld (#F141),a
ld (#F191),a
ld (#F287),a
ld a,#88
ld (#F19E),a
ld (#C1F0),a
ld (#F1F1),a
ld (#F288),a
ld a,#89
ld (#C238),a
ld a,#8A
ld (#E050),a
ld (#D0F8),a
ld (#E0F3),a
ld (#C2D2),a
ld a,#8B
ld (#E19C),a
ld a,#8C
ld (#D052),a
ld (#E0A5),a
ld a,#8E
ld (#C292),a
ld (#F2D0),a
ld a,#98
ld (#D004),a
ld (#D013),a
ld (#E001),a
ld a,#99
ld (#C241),a
ld a,#9A
ld (#D054),a
ld a,#9D
ld (#C1E8),a
ld a,#9E
ld (#D2E2),a
ld a,#AA
ld (#F0A6),a
ld (#E0F5),a
ld (#F14E),a
ld (#F1EE),a
ld a,#BB
ld (#D0A2),a
ld a,#BE
ld (#D001),a
ld a,#C8
ld (#D011),a
ld (#E00B),a
ld (#E0FB),a
ld a,#CA
ld (#D0FB),a
ld (#D235),a
ld (#F242),a
ld (#E2DB),a
ld (#F2D8),a
ld a,#D8
ld (#C051),a
ld (#D061),a
ld (#F28F),a
ld a,#DA
ld (#F00F),a
ld (#F0A0),a
ld (#F192),a
ld (#E242),a
ld (#D28B),a
ld (#D28D),a
ld (#D2DD),a
ld a,#DE
ld (#C013),a
ld a,#EA
ld (#F147),a
ld a,#FA
ld (#E0F4),a
ld (#D234),a
ret

p6to7
ld a,#00
ld (#C001),a
ld (#C00F),a
ld (#D002),a
ld (#D006),a
ld (#D007),a
ld (#D00D),a
ld (#F00C),a
ld (#C058),a
ld (#C060),a
ld (#D059),a
ld (#E061),a
ld (#C0B0),a
ld (#D0A8),a
ld (#C100),a
ld (#D0FE),a
ld (#E101),a
ld (#E103),a
ld (#C142),a
ld (#D14A),a
ld (#E19B),a
ld (#F193),a
ld (#F198),a
ld (#F199),a
ld (#C1E3),a
ld (#C1EB),a
ld (#E1E5),a
ld (#F1EA),a
ld (#D232),a
ld (#D239),a
ld (#D241),a
ld (#F235),a
ld (#F243),a
ld (#C289),a
ld (#D282),a
ld (#E286),a
ld (#F284),a
ld (#E2DC),a
ld (#E2DE),a
ld (#F2D4),a
ld a,#01
ld (#C0A1),a
ld (#F0A2),a
ld (#C192),a
ld (#D1EB),a
ld (#D2E3),a
ld a,#02
ld (#D010),a
ld (#D056),a
ld (#F05D),a
ld (#C0F7),a
ld (#D100),a
ld (#F153),a
ld (#F190),a
ld (#D23C),a
ld (#C28A),a
ld (#F292),a
ld (#F2DE),a
ld a,#03
ld (#C240),a
ld (#C2D0),a
ld (#C2DF),a
ld a,#04
ld (#C010),a
ld (#E004),a
ld (#E00E),a
ld (#C059),a
ld (#D053),a
ld (#C0A6),a
ld (#C193),a
ld (#D19B),a
ld (#C282),a
ld (#C293),a
ld a,#05
ld (#C008),a
ld (#E00C),a
ld (#E00D),a
ld (#E062),a
ld (#F05C),a
ld (#D0A9),a
ld (#C1E2),a
ld (#C23F),a
ld (#E235),a
ld a,#06
ld (#C198),a
ld a,#08
ld (#F0B3),a
ld (#C1F0),a
ld (#F1F1),a
ld (#E243),a
ld (#D293),a
ld (#E28E),a
ld (#C2D2),a
ld a,#09
ld (#D057),a
ld (#C28F),a
ld (#D292),a
ld a,#0A
ld (#E0F3),a
ld (#F103),a
ld (#E151),a
ld (#D291),a
ld (#F285),a
ld a,#0C
ld (#E0A5),a
ld a,#0E
ld (#F000),a
ld a,#10
ld (#C003),a
ld (#D00E),a
ld (#E005),a
ld (#E00F),a
ld (#E058),a
ld (#E05C),a
ld (#C0A7),a
ld (#F0AD),a
ld (#E153),a
ld (#C1E4),a
ld (#D1EC),a
ld (#E1E1),a
ld (#F1EB),a
ld (#E23E),a
ld (#C290),a
ld (#C2D3),a
ld a,#12
ld (#D0A1),a
ld (#D0FA),a
ld (#D150),a
ld (#F140),a
ld a,#14
ld (#E0AC),a
ld a,#17
ld (#E000),a
ld a,#18
ld (#D0A4),a
ld (#E0A9),a
ld (#C280),a
ld (#D280),a
ld a,#1A
ld (#E14D),a
ld (#F1E1),a
ld (#D233),a
ld (#D283),a
ld (#D28D),a
ld (#F286),a
ld (#D2D3),a
ld a,#1D
ld (#C1E8),a
ld a,#22
ld (#D003),a
ld a,#26
ld (#D2D0),a
ld a,#2A
ld (#C050),a
ld (#F1EE),a
ld (#E23D),a
ld (#E293),a
ld a,#2B
ld (#E051),a
ld a,#2E
ld (#F2E3),a
ld a,#32
ld (#F055),a
ld (#F19D),a
ld a,#33
ld (#C2E2),a
ld a,#3A
ld (#F00F),a
ld (#E0FA),a
ld (#F2DF),a
ld a,#40
ld (#D005),a
ld (#F00B),a
ld (#F013),a
ld (#C05E),a
ld (#D05F),a
ld (#C141),a
ld (#C191),a
ld (#D19F),a
ld (#C1E1),a
ld (#D1E2),a
ld (#F1F2),a
ld (#C231),a
ld (#C23E),a
ld (#F234),a
ld (#F23B),a
ld (#E283),a
ld (#E2D3),a
ld (#F2DB),a
ld a,#41
ld (#C055),a
ld (#C063),a
ld (#C0F6),a
ld (#D288),a
ld a,#42
ld (#D012),a
ld (#E057),a
ld (#F0B2),a
ld (#E233),a
ld (#C281),a
ld a,#44
ld (#C239),a
ld a,#45
ld (#E0FC),a
ld a,#46
ld (#F146),a
ld a,#48
ld (#D235),a
ld (#F2D8),a
ld a,#4A
ld (#C005),a
ld (#F00E),a
ld (#C0AE),a
ld (#F142),a
ld a,#4B
ld (#E054),a
ld a,#50
ld (#D00F),a
ld (#F001),a
ld (#F006),a
ld (#C05D),a
ld (#D05E),a
ld (#E052),a
ld (#E060),a
ld (#C0A8),a
ld (#C0AA),a
ld (#C0B3),a
ld (#D0A6),a
ld (#D0B3),a
ld (#F0B0),a
ld (#F0B1),a
ld (#C0F0),a
ld (#C0F3),a
ld (#D0F4),a
ld (#D0FC),a
ld (#E0FE),a
ld (#E0FF),a
ld (#D14B),a
ld (#D14E),a
ld (#F144),a
ld (#F19C),a
ld (#F1A1),a
ld (#C1F1),a
ld (#D1E9),a
ld (#E1E2),a
ld (#F1E3),a
ld (#D23A),a
ld (#D23B),a
ld (#E241),a
ld (#F232),a
ld (#F241),a
ld (#C284),a
ld (#D285),a
ld (#E289),a
ld (#E28A),a
ld (#E28B),a
ld (#E28C),a
ld (#F280),a
ld (#F281),a
ld (#F28D),a
ld (#C2DE),a
ld (#D2D4),a
ld (#E2D6),a
ld (#E2E0),a
ld (#E2E1),a
ld (#F2DD),a
ld (#F2E2),a
ld a,#52
ld (#E0A1),a
ld (#D0F7),a
ld (#F0F0),a
ld (#E150),a
ld (#D1E3),a
ld (#C2D5),a
ld (#C2DC),a
ld (#F2D6),a
ld a,#58
ld (#D004),a
ld (#E0AA),a
ld (#E100),a
ld (#D151),a
ld (#D1A1),a
ld (#E1F1),a
ld (#F23F),a
ld (#E280),a
ld (#F28F),a
ld (#C2DD),a
ld (#D2DE),a
ld a,#5A
ld (#C0AD),a
ld (#D101),a
ld (#F191),a
ld (#F192),a
ld (#F197),a
ld (#D234),a
ld (#D243),a
ld (#D28B),a
ld (#D28C),a
ld (#C2D6),a
ld a,#5D
ld (#E14C),a
ld a,#62
ld (#E0A4),a
ld (#C1E7),a
ld a,#6A
ld (#D0F3),a
ld (#C2D1),a
ld a,#72
ld (#D2DA),a
ld a,#7A
ld (#D05A),a
ld (#D061),a
ld (#E0F4),a
ld (#D194),a
ld (#D242),a
ld (#F237),a
ld (#D290),a
ld (#D2DD),a
ld a,#88
ld (#D052),a
ld (#D0AB),a
ld (#D1E5),a
ld (#E1ED),a
ld a,#8A
ld (#E00B),a
ld (#E0A2),a
ld (#F0A6),a
ld (#E0F5),a
ld (#F19E),a
ld (#F231),a
ld (#F242),a
ld (#C28B),a
ld (#C2E3),a
ld (#D2E1),a
ld a,#8D
ld (#C241),a
ld (#C292),a
ld a,#98
ld (#D05B),a
ld a,#99
ld (#C238),a
ld a,#9A
ld (#F005),a
ld a,#9E
ld (#D001),a
ld (#F2D0),a
ld a,#AB
ld (#D0A2),a
ld (#E19C),a
ld a,#AE
ld (#C013),a
ld (#D2E2),a
ld a,#BA
ld (#F293),a
ld a,#BE
ld (#E2D0),a
ld a,#C8
ld (#C051),a
ld (#D0FB),a
ld (#E2DB),a
ld a,#CA
ld (#C0FE),a
ld (#F147),a
ld (#F14E),a
ld a,#D8
ld (#D054),a
ld a,#DA
ld (#D011),a
ld (#F05F),a
ld (#D0F8),a
ld (#F0F1),a
ld (#D2DC),a
ld a,#EA
ld (#D050),a
ld (#E0FB),a
ld a,#FA
ld (#F05E),a
ld (#F141),a
ld (#D1E4),a
ld (#D28A),a
ld (#F287),a
ld (#D2DB),a
ld a,#FB
ld (#D051),a
ret

p7to8
ld a,#00
ld (#C005),a
ld (#D008),a
ld (#E00D),a
ld (#E011),a
ld (#C059),a
ld (#E05C),a
ld (#E05D),a
ld (#E05E),a
ld (#F050),a
ld (#D0A9),a
ld (#D0B0),a
ld (#E0B3),a
ld (#F0B3),a
ld (#D100),a
ld (#F0F5),a
ld (#F102),a
ld (#C14F),a
ld (#E144),a
ld (#E145),a
ld (#E153),a
ld (#C193),a
ld (#F1A3),a
ld (#C1E1),a
ld (#C1E2),a
ld (#C1EF),a
ld (#D1E2),a
ld (#E1E4),a
ld (#C23C),a
ld (#E243),a
ld (#F234),a
ld (#F23B),a
ld (#C282),a
ld (#C290),a
ld (#E283),a
ld (#F28E),a
ld (#C2D8),a
ld (#D2D2),a
ld a,#01
ld (#E00E),a
ld (#C055),a
ld (#E0B2),a
ld (#C0F6),a
ld (#F145),a
ld (#C197),a
ld (#E1E5),a
ld (#F1ED),a
ld (#C240),a
ld (#D23C),a
ld (#E235),a
ld (#C28C),a
ld a,#02
ld (#C006),a
ld (#F0A5),a
ld (#D150),a
ld (#C1E9),a
ld (#D232),a
ld (#F23E),a
ld (#D282),a
ld (#D293),a
ld (#F284),a
ld (#C2DF),a
ld (#E2DE),a
ld a,#04
ld (#F000),a
ld (#D059),a
ld (#E0A5),a
ld (#C100),a
ld (#C147),a
ld (#C2E0),a
ld a,#05
ld (#D006),a
ld (#D007),a
ld (#F051),a
ld (#C192),a
ld (#D2D9),a
ld a,#06
ld (#E063),a
ld (#F19D),a
ld a,#08
ld (#C010),a
ld (#D057),a
ld (#E058),a
ld (#C0FF),a
ld (#D149),a
ld (#D14A),a
ld (#E152),a
ld (#E1A2),a
ld (#D1E5),a
ld (#C231),a
ld (#E233),a
ld (#F242),a
ld a,#09
ld (#E054),a
ld a,#0A
ld (#D00D),a
ld (#C050),a
ld (#E051),a
ld (#E0A9),a
ld (#F190),a
ld (#C2DC),a
ld a,#0B
ld (#D000),a
ld a,#0C
ld (#C001),a
ld (#D292),a
ld a,#10
ld (#F00D),a
ld (#E055),a
ld (#E05F),a
ld (#C0B1),a
ld (#C101),a
ld (#C150),a
ld (#E14D),a
ld (#D1A0),a
ld (#E191),a
ld (#E1A3),a
ld (#C242),a
ld (#D239),a
ld (#F23C),a
ld (#C283),a
ld (#C28D),a
ld (#E2D5),a
ld (#E2DF),a
ld a,#12
ld (#F0AD),a
ld (#D2E0),a
ld a,#13
ld (#C291),a
ld a,#14
ld (#D1EC),a
ld a,#15
ld (#C008),a
ld a,#18
ld (#D00E),a
ld (#F0F7),a
ld (#D23D),a
ld (#C2DD),a
ld a,#1A
ld (#F00F),a
ld (#D0B1),a
ld (#C0F7),a
ld (#D101),a
ld (#E0FA),a
ld (#F231),a
ld (#F236),a
ld (#F2DF),a
ld a,#22
ld (#E23D),a
ld (#C28A),a
ld (#F2D4),a
ld a,#23
ld (#F2E3),a
ld a,#26
ld (#D053),a
ld (#F146),a
ld a,#2A
ld (#D003),a
ld (#D19A),a
ld (#C2D1),a
ld a,#2B
ld (#D0A2),a
ld a,#2E
ld (#C013),a
ld a,#32
ld (#F14D),a
ld a,#37
ld (#E000),a
ld a,#3A
ld (#D061),a
ld (#D0AA),a
ld (#E14B),a
ld (#F140),a
ld (#F1EE),a
ld a,#40
ld (#C00F),a
ld (#E003),a
ld (#C05F),a
ld (#C063),a
ld (#D055),a
ld (#C0A5),a
ld (#F0F3),a
ld (#F101),a
ld (#D192),a
ld (#F1E9),a
ld (#F233),a
ld (#F23A),a
ld (#D288),a
ld (#E28D),a
ld (#F283),a
ld (#F292),a
ld (#F2DE),a
ld a,#41
ld (#E2D3),a
ld (#E2E3),a
ld a,#42
ld (#D00C),a
ld (#E05B),a
ld (#C14E),a
ld a,#43
ld (#D063),a
ld a,#44
ld (#C009),a
ld a,#48
ld (#D012),a
ld (#E013),a
ld (#C051),a
ld (#C0AE),a
ld (#E0AB),a
ld (#E0F3),a
ld (#F142),a
ld (#E1F2),a
ld (#E2DB),a
ld a,#4A
ld (#E057),a
ld (#C281),a
ld (#C2D5),a
ld (#C2D7),a
ld a,#50
ld (#C012),a
ld (#E005),a
ld (#E010),a
ld (#F008),a
ld (#F009),a
ld (#C053),a
ld (#C05C),a
ld (#C05E),a
ld (#D05F),a
ld (#F056),a
ld (#C0A2),a
ld (#C0A9),a
ld (#D0AE),a
ld (#E0B0),a
ld (#F0A1),a
ld (#F0B2),a
ld (#E100),a
ld (#F0F2),a
ld (#F100),a
ld (#C143),a
ld (#F143),a
ld (#F14F),a
ld (#C19E),a
ld (#D195),a
ld (#F193),a
ld (#C1E4),a
ld (#C1E6),a
ld (#E1E0),a
ld (#E1E1),a
ld (#E1F1),a
ld (#F1E2),a
ld (#F1E6),a
ld (#F1F2),a
ld (#C234),a
ld (#D280),a
ld (#D284),a
ld (#D286),a
ld (#E280),a
ld (#E287),a
ld (#E2D9),a
ld (#F2D6),a
ld (#F2DB),a
ld (#F2DC),a
ld a,#52
ld (#D00A),a
ld (#C05A),a
ld (#C0AD),a
ld (#E0A7),a
ld (#D193),a
ld (#D1F1),a
ld (#E1EC),a
ld (#D28C),a
ld (#C2DB),a
ld (#E2DA),a
ld (#F2D7),a
ld a,#58
ld (#F010),a
ld (#D062),a
ld (#F060),a
ld (#D0B2),a
ld (#D102),a
ld (#D243),a
ld (#D28E),a
ld (#F2D5),a
ld (#F2E0),a
ld a,#5A
ld (#F00E),a
ld (#D050),a
ld (#E0AA),a
ld (#F0AE),a
ld (#F0AF),a
ld (#D151),a
ld (#D194),a
ld (#D1E3),a
ld (#D233),a
ld (#E242),a
ld (#F230),a
ld (#D283),a
ld (#F286),a
ld (#D2DC),a
ld (#D2DD),a
ld a,#5D
ld (#C1E8),a
ld a,#6A
ld (#E050),a
ld (#F055),a
ld (#E0A8),a
ld (#E0F4),a
ld a,#6B
ld (#E0A4),a
ld a,#72
ld (#D0F7),a
ld (#D242),a
ld (#D290),a
ld a,#7A
ld (#F0F0),a
ld (#D28A),a
ld (#F28F),a
ld (#D2DA),a
ld a,#88
ld (#F0A6),a
ld (#F147),a
ld a,#89
ld (#C292),a
ld a,#8A
ld (#D0A7),a
ld (#C148),a
ld (#C199),a
ld (#C23A),a
ld (#C2D6),a
ld a,#8B
ld (#C2E3),a
ld a,#8C
ld (#E0F5),a
ld (#C241),a
ld a,#8E
ld (#D2D0),a
ld a,#98
ld (#D001),a
ld (#D0A4),a
ld (#F2D0),a
ld a,#9A
ld (#D2D3),a
ld a,#9D
ld (#E14C),a
ld a,#9E
ld (#D013),a
ld (#E2D0),a
ld a,#AA
ld (#F0F6),a
ld (#F19E),a
ld (#F293),a
ld a,#AB
ld (#D051),a
ld a,#BA
ld (#E293),a
ld (#D2E1),a
ld a,#CA
ld (#E00B),a
ld (#D0AB),a
ld a,#D8
ld (#D05B),a
ld (#F23F),a
ld (#D2DE),a
ld a,#DA
ld (#F005),a
ld (#E0A2),a
ld (#F141),a
ld (#F14E),a
ld a,#EA
ld (#E19C),a
ld a,#FA
ld (#D011),a
ld (#F05F),a
ld (#F197),a
ret

p8to9
ld a,#00
ld (#C006),a
ld (#C007),a
ld (#D005),a
ld (#E004),a
ld (#E00E),a
ld (#D057),a
ld (#D05E),a
ld (#F05C),a
ld (#C0A1),a
ld (#C0F6),a
ld (#C0FF),a
ld (#C141),a
ld (#C150),a
ld (#D150),a
ld (#E152),a
ld (#C191),a
ld (#C192),a
ld (#C197),a
ld (#D192),a
ld (#D1A0),a
ld (#E1A3),a
ld (#F1E9),a
ld (#C231),a
ld (#C23B),a
ld (#C240),a
ld (#E233),a
ld (#E235),a
ld (#E236),a
ld (#F233),a
ld (#F23E),a
ld (#C293),a
ld (#F285),a
ld (#F28C),a
ld (#C2D2),a
ld (#D2D5),a
ld (#D2D6),a
ld (#E2D3),a
ld (#E2DE),a
ld a,#01
ld (#C008),a
ld (#D058),a
ld (#E062),a
ld (#C100),a
ld (#C2D8),a
ld a,#02
ld (#C050),a
ld (#C060),a
ld (#F0AD),a
ld (#C147),a
ld (#D1E2),a
ld (#F234),a
ld (#D2D2),a
ld (#F2DF),a
ld a,#03
ld (#C28F),a
ld (#F2E3),a
ld a,#04
ld (#C009),a
ld (#D008),a
ld (#E00C),a
ld (#E00F),a
ld (#C055),a
ld (#E054),a
ld (#E05F),a
ld (#E0AC),a
ld (#E0B3),a
ld (#E103),a
ld (#C142),a
ld (#F19D),a
ld (#D1EC),a
ld (#C289),a
ld (#C290),a
ld (#D289),a
ld (#D2D9),a
ld a,#05
ld (#E05C),a
ld (#E05D),a
ld (#E05E),a
ld (#C1E8),a
ld (#E1E5),a
ld a,#06
ld (#F196),a
ld (#C239),a
ld a,#08
ld (#C002),a
ld (#E007),a
ld (#C14F),a
ld (#F288),a
ld (#C2DD),a
ld a,#09
ld (#C010),a
ld (#D1EB),a
ld (#C281),a
ld (#C288),a
ld (#D2E3),a
ld a,#0A
ld (#D00C),a
ld (#F00F),a
ld (#D056),a
ld (#E058),a
ld (#D0B1),a
ld (#D101),a
ld (#C23A),a
ld (#F235),a
ld (#D28D),a
ld (#E28E),a
ld (#F284),a
ld (#C2D1),a
ld (#C2D5),a
ld (#F2D4),a
ld a,#0B
ld (#C2D0),a
ld a,#0C
ld (#C1F0),a
ld (#C2E0),a
ld a,#0D
ld (#C001),a
ld (#D006),a
ld a,#0F
ld (#E000),a
ld a,#10
ld (#D009),a
ld (#C061),a
ld (#E0A5),a
ld (#E0FD),a
ld (#F0F7),a
ld (#C151),a
ld (#C193),a
ld (#C1A0),a
ld (#F1F1),a
ld (#C233),a
ld (#D23D),a
ld (#F243),a
ld (#E286),a
ld (#C2D9),a
ld (#D2D7),a
ld a,#12
ld (#D290),a
ld (#D293),a
ld a,#14
ld (#C149),a
ld a,#18
ld (#E059),a
ld (#E19D),a
ld (#E23E),a
ld (#F2D0),a
ld a,#1A
ld (#D061),a
ld (#D151),a
ld (#F140),a
ld (#C280),a
ld a,#1D
ld (#C23F),a
ld a,#22
ld (#C198),a
ld a,#2A
ld (#D053),a
ld (#D0A2),a
ld (#D0A3),a
ld (#E0FA),a
ld (#C1E9),a
ld (#F1E0),a
ld (#C28A),a
ld a,#2B
ld (#C013),a
ld (#D2E2),a
ld a,#32
ld (#D0AA),a
ld (#F146),a
ld (#F28F),a
ld a,#3A
ld (#D003),a
ld (#D00E),a
ld (#D011),a
ld (#D050),a
ld (#F236),a
ld a,#3B
ld (#D000),a
ld a,#40
ld (#C004),a
ld (#D010),a
ld (#D05D),a
ld (#D060),a
ld (#E061),a
ld (#F050),a
ld (#E0B1),a
ld (#D0FB),a
ld (#D0FE),a
ld (#E101),a
ld (#F0FC),a
ld (#C146),a
ld (#D142),a
ld (#E151),a
ld (#F151),a
ld (#D191),a
ld (#E194),a
ld (#E19A),a
ld (#D1E1),a
ld (#D1EA),a
ld (#D1F0),a
ld (#E1EC),a
ld (#F1E5),a
ld (#F1E8),a
ld (#F1ED),a
ld (#D231),a
ld (#D235),a
ld (#D281),a
ld (#E2DD),a
ld (#E2E3),a
ld (#F2D3),a
ld (#F2D8),a
ld a,#41
ld (#D063),a
ld (#C0A5),a
ld (#F0AC),a
ld (#C291),a
ld a,#42
ld (#E006),a
ld (#D148),a
ld (#E1A1),a
ld (#C2D4),a
ld (#C2DF),a
ld (#D2E0),a
ld a,#44
ld (#D059),a
ld a,#4A
ld (#C0FE),a
ld (#E1E3),a
ld (#D2DD),a
ld a,#4C
ld (#E0F5),a
ld a,#50
ld (#C003),a
ld (#C00A),a
ld (#D004),a
ld (#F00E),a
ld (#C057),a
ld (#C05A),a
ld (#C05F),a
ld (#D055),a
ld (#C0A7),a
ld (#C0AD),a
ld (#C0AE),a
ld (#D0AC),a
ld (#D0AF),a
ld (#E0A1),a
ld (#D0F1),a
ld (#D0FA),a
ld (#E0F0),a
ld (#F101),a
ld (#E141),a
ld (#E150),a
ld (#F148),a
ld (#E191),a
ld (#F192),a
ld (#F1A0),a
ld (#E237),a
ld (#F23D),a
ld (#C283),a
ld (#C28E),a
ld (#D28B),a
ld (#D28C),a
ld (#E28D),a
ld (#C2D3),a
ld (#E2D5),a
ld (#F2D7),a
ld a,#52
ld (#D0A6),a
ld (#F286),a
ld a,#53
ld (#C2E2),a
ld a,#58
ld (#D012),a
ld (#E001),a
ld (#E013),a
ld (#F005),a
ld (#D054),a
ld (#F0B0),a
ld (#D0F9),a
ld (#F0F1),a
ld (#D152),a
ld (#F142),a
ld (#D1A2),a
ld (#F1E1),a
ld (#F1EF),a
ld (#D234),a
ld (#E242),a
ld (#F231),a
ld (#D283),a
ld (#E2DB),a
ld a,#5A
ld (#C00D),a
ld (#D00B),a
ld (#F010),a
ld (#F05E),a
ld (#F05F),a
ld (#F0A0),a
ld (#D102),a
ld (#F141),a
ld (#D1A1),a
ld (#D1E4),a
ld (#D28A),a
ld (#F287),a
ld a,#62
ld (#E23D),a
ld a,#6A
ld (#E057),a
ld (#C2DB),a
ld a,#72
ld (#F004),a
ld (#F0A5),a
ld a,#7A
ld (#D00A),a
ld (#E050),a
ld (#E0AA),a
ld (#D0F3),a
ld (#D193),a
ld (#D242),a
ld a,#88
ld (#D001),a
ld (#E051),a
ld a,#89
ld (#F147),a
ld a,#8A
ld (#E1ED),a
ld (#C2D7),a
ld (#C2DC),a
ld a,#8B
ld (#D291),a
ld a,#8D
ld (#C292),a
ld a,#8E
ld (#D292),a
ld (#C2E3),a
ld a,#98
ld (#F0A6),a
ld (#C0F7),a
ld (#E2D0),a
ld a,#99
ld (#E14C),a
ld a,#9A
ld (#C199),a
ld a,#9D
ld (#C238),a
ld a,#9E
ld (#D2D0),a
ld a,#AA
ld (#E19C),a
ld (#C2D6),a
ld a,#AB
ld (#E0A4),a
ld a,#BE
ld (#D013),a
ld a,#C8
ld (#C000),a
ld (#E0AB),a
ld a,#CA
ld (#F055),a
ld (#D0F8),a
ld (#C148),a
ld (#F293),a
ld a,#D8
ld (#D062),a
ld (#D0A4),a
ld (#E0A2),a
ld (#D2D3),a
ld (#F2E0),a
ld a,#DA
ld (#F060),a
ld (#D0A7),a
ld (#D194),a
ld (#F1E7),a
ld (#E293),a
ld (#D2DE),a
ld a,#EA
ld (#F197),a
ld (#F19E),a
ld a,#FA
ld (#F0AE),a
ld (#F0AF),a
ld (#F0F0),a
ld (#F14E),a
ld (#F237),a
ret

p9to10
ld a,#00
ld (#C002),a
ld (#C008),a
ld (#D009),a
ld (#E00C),a
ld (#E00F),a
ld (#C060),a
ld (#D058),a
ld (#D05D),a
ld (#E05E),a
ld (#E062),a
ld (#F051),a
ld (#C0A6),a
ld (#C0B1),a
ld (#E0AD),a
ld (#E0AE),a
ld (#E0AF),a
ld (#E0B2),a
ld (#C100),a
ld (#F103),a
ld (#C151),a
ld (#D142),a
ld (#F145),a
ld (#C1A0),a
ld (#D191),a
ld (#E194),a
ld (#E1A2),a
ld (#D1E1),a
ld (#E1E3),a
ld (#F1E3),a
ld (#F1E4),a
ld (#F1E5),a
ld (#F1E8),a
ld (#D231),a
ld (#D23C),a
ld (#F23A),a
ld (#F242),a
ld (#C28C),a
ld (#C291),a
ld (#D289),a
ld (#D28D),a
ld (#F283),a
ld (#C2D9),a
ld (#C2DD),a
ld (#D2D7),a
ld (#D2D9),a
ld (#F2DF),a
ld a,#01
ld (#D007),a
ld (#E003),a
ld (#E05F),a
ld (#E103),a
ld (#F19D),a
ld (#C23B),a
ld (#F23E),a
ld (#D2D5),a
ld a,#02
ld (#C010),a
ld (#D005),a
ld (#D05E),a
ld (#E063),a
ld (#D0B1),a
ld (#D101),a
ld (#E0F9),a
ld (#D151),a
ld (#F233),a
ld (#F235),a
ld (#F2E3),a
ld a,#03
ld (#C050),a
ld a,#04
ld (#C101),a
ld (#E0F5),a
ld (#E145),a
ld (#E195),a
ld (#F198),a
ld (#C1E8),a
ld (#C1F0),a
ld (#C231),a
ld (#C240),a
ld (#E2D3),a
ld a,#05
ld (#D008),a
ld (#D059),a
ld (#C141),a
ld (#C150),a
ld (#C2D8),a
ld (#D2D6),a
ld a,#06
ld (#F14D),a
ld a,#08
ld (#D006),a
ld (#C0A0),a
ld (#F234),a
ld (#C281),a
ld (#F284),a
ld (#E2DF),a
ld a,#0A
ld (#C00D),a
ld (#E000),a
ld (#D061),a
ld (#D192),a
ld (#C280),a
ld (#C28B),a
ld (#F293),a
ld (#C2D4),a
ld a,#0B
ld (#E058),a
ld (#D291),a
ld (#C2D1),a
ld a,#0C
ld (#D19B),a
ld a,#0E
ld (#C2D0),a
ld a,#10
ld (#C011),a
ld (#E008),a
ld (#F00C),a
ld (#C052),a
ld (#C056),a
ld (#D05F),a
ld (#E059),a
ld (#E060),a
ld (#F05D),a
ld (#D0A1),a
ld (#C149),a
ld (#E140),a
ld (#C1E3),a
ld (#E236),a
ld (#C293),a
ld (#E284),a
ld (#E28F),a
ld (#F28D),a
ld (#E2D4),a
ld (#F2D0),a
ld a,#12
ld (#D050),a
ld (#E0A7),a
ld (#F0FD),a
ld (#D1F1),a
ld (#F1E6),a
ld (#C2DA),a
ld a,#14
ld (#C061),a
ld a,#16
ld (#F28F),a
ld a,#18
ld (#C00E),a
ld (#F0A6),a
ld a,#19
ld (#C23F),a
ld (#C288),a
ld a,#1A
ld (#F010),a
ld (#D1A1),a
ld (#F190),a
ld (#D1E2),a
ld (#D232),a
ld (#F236),a
ld (#D282),a
ld (#D2DE),a
ld a,#1B
ld (#E0A4),a
ld a,#1D
ld (#C238),a
ld a,#22
ld (#C28F),a
ld (#E28E),a
ld (#D2D2),a
ld a,#2A
ld (#E057),a
ld (#E0F4),a
ld (#E19C),a
ld a,#2E
ld (#D013),a
ld (#D051),a
ld a,#33
ld (#C013),a
ld a,#36
ld (#E14B),a
ld (#F1EE),a
ld a,#3A
ld (#D053),a
ld (#F060),a
ld (#E0AA),a
ld (#F146),a
ld (#C198),a
ld (#D2E1),a
ld a,#40
ld (#E011),a
ld (#C058),a
ld (#D063),a
ld (#E053),a
ld (#D0A0),a
ld (#D0A8),a
ld (#D0B0),a
ld (#F0A2),a
ld (#C0F0),a
ld (#D0F1),a
ld (#E0F3),a
ld (#C140),a
ld (#D141),a
ld (#C190),a
ld (#E1A1),a
ld (#C1E0),a
ld (#E232),a
ld (#E282),a
ld (#F28B),a
ld (#F28E),a
ld (#C2DF),a
ld (#D2D1),a
ld (#D2D4),a
ld (#D2E0),a
ld (#E2DE),a
ld a,#41
ld (#C004),a
ld a,#42
ld (#F00F),a
ld (#C1E7),a
ld (#E1E2),a
ld (#C230),a
ld (#E23D),a
ld (#D290),a
ld a,#43
ld (#C2E2),a
ld a,#44
ld (#E0AC),a
ld (#C289),a
ld a,#48
ld (#C000),a
ld (#C0FE),a
ld (#D1E5),a
ld (#F288),a
ld a,#4A
ld (#E006),a
ld (#E0A8),a
ld (#E1F2),a
ld (#C2D6),a
ld a,#50
ld (#C00F),a
ld (#E001),a
ld (#F00D),a
ld (#F013),a
ld (#D054),a
ld (#E055),a
ld (#F050),a
ld (#F05B),a
ld (#C0AF),a
ld (#E0B1),a
ld (#F0B3),a
ld (#C0FD),a
ld (#D0FB),a
ld (#E101),a
ld (#F0F3),a
ld (#F102),a
ld (#F142),a
ld (#F151),a
ld (#E190),a
ld (#C1EE),a
ld (#D1EA),a
ld (#F1E1),a
ld (#C233),a
ld (#C23E),a
ld (#C242),a
ld (#D234),a
ld (#D235),a
ld (#D236),a
ld (#D238),a
ld (#D239),a
ld (#D243),a
ld (#E242),a
ld (#F243),a
ld (#D28A),a
ld (#E285),a
ld (#E286),a
ld (#F285),a
ld (#F286),a
ld (#F292),a
ld (#E2DA),a
ld (#E2DB),a
ld (#E2DC),a
ld (#E2DD),a
ld (#F2D3),a
ld (#F2D5),a
ld (#F2D9),a
ld (#F2DE),a
ld a,#52
ld (#C00C),a
ld (#E056),a
ld (#D0AA),a
ld (#E193),a
ld (#C284),a
ld (#E292),a
ld (#D2DD),a
ld a,#58
ld (#D00F),a
ld (#F061),a
ld (#D0A7),a
ld (#E0A2),a
ld (#D0F4),a
ld (#F0F9),a
ld (#F0FF),a
ld (#F191),a
ld (#F19F),a
ld (#D1F2),a
ld (#D233),a
ld (#F290),a
ld (#D2D3),a
ld (#D2DC),a
ld (#F2E0),a
ld a,#5A
ld (#D00E),a
ld (#E050),a
ld (#D0F3),a
ld (#F0F0),a
ld (#D152),a
ld (#F140),a
ld (#D1A2),a
ld (#D242),a
ld (#F23F),a
ld (#C286),a
ld (#D293),a
ld a,#5D
ld (#E0FC),a
ld a,#62
ld (#F004),a
ld (#F0A5),a
ld (#D0F7),a
ld (#C237),a
ld a,#6A
ld (#D19A),a
ld a,#72
ld (#D0A6),a
ld a,#7A
ld (#D0B2),a
ld (#D143),a
ld a,#88
ld (#E19D),a
ld (#E23E),a
ld (#C2E0),a
ld a,#89
ld (#C292),a
ld (#D2E3),a
ld a,#8A
ld (#D00C),a
ld (#E007),a
ld (#D056),a
ld (#F055),a
ld (#D0F8),a
ld (#D1EB),a
ld a,#8B
ld (#F0F6),a
ld a,#8D
ld (#F147),a
ld (#C2E3),a
ld a,#98
ld (#D2D0),a
ld a,#9A
ld (#D003),a
ld (#F1E0),a
ld a,#AA
ld (#E1ED),a
ld a,#AB
ld (#D000),a
ld (#E14C),a
ld a,#C8
ld (#E00B),a
ld (#E051),a
ld (#D0AB),a
ld a,#CA
ld (#F197),a
ld a,#D8
ld (#C0F7),a
ld (#F1EF),a
ld a,#DA
ld (#D012),a
ld (#D062),a
ld (#F0FE),a
ld (#D2DB),a
ld (#F2D4),a
ld a,#EA
ld (#E0AB),a
ld a,#FA
ld (#D00B),a
ld (#F0B0),a
ld (#C285),a
ld (#C2DB),a
ld (#D2DA),a
ret

p10to11
ld a,#00
ld (#C004),a
ld (#C009),a
ld (#D006),a
ld (#D007),a
ld (#E008),a
ld (#D059),a
ld (#D05C),a
ld (#C0A0),a
ld (#C0A5),a
ld (#D0B1),a
ld (#C0F0),a
ld (#C101),a
ld (#C140),a
ld (#C141),a
ld (#C142),a
ld (#C149),a
ld (#C14F),a
ld (#D141),a
ld (#D149),a
ld (#F153),a
ld (#C190),a
ld (#C19F),a
ld (#C1A1),a
ld (#F195),a
ld (#C1E0),a
ld (#C1E8),a
ld (#C1F0),a
ld (#E1E5),a
ld (#C230),a
ld (#C231),a
ld (#E232),a
ld (#F235),a
ld (#F239),a
ld (#C28D),a
ld (#D281),a
ld (#D285),a
ld (#F28B),a
ld (#C2D1),a
ld (#C2D4),a
ld (#D2D8),a
ld (#F2DD),a
ld a,#01
ld (#C050),a
ld (#E0AF),a
ld (#C150),a
ld (#E14A),a
ld (#E194),a
ld (#F23A),a
ld (#D28D),a
ld (#C2DD),a
ld a,#02
ld (#D002),a
ld (#D011),a
ld (#E00F),a
ld (#D05D),a
ld (#D061),a
ld (#C0F6),a
ld (#F0FD),a
ld (#D142),a
ld (#D191),a
ld (#D1A1),a
ld (#D1E1),a
ld (#F1E5),a
ld (#C239),a
ld (#D231),a
ld (#C280),a
ld (#C2D5),a
ld a,#04
ld (#C001),a
ld (#D009),a
ld (#E05D),a
ld (#E0AE),a
ld (#F14D),a
ld (#C1A0),a
ld (#D23D),a
ld (#F23B),a
ld (#C281),a
ld (#F28C),a
ld (#D2D7),a
ld a,#05
ld (#C151),a
ld (#D2D5),a
ld a,#06
ld (#E054),a
ld (#E14B),a
ld (#F1EE),a
ld (#F28F),a
ld a,#08
ld (#C00E),a
ld (#D001),a
ld (#D00D),a
ld (#C061),a
ld (#F199),a
ld (#C1EF),a
ld (#E1E2),a
ld (#F1EA),a
ld (#C23A),a
ld (#E2D6),a
ld a,#09
ld (#F000),a
ld (#E0B3),a
ld a,#0A
ld (#E007),a
ld (#D052),a
ld (#D05E),a
ld (#E058),a
ld (#F060),a
ld (#E193),a
ld (#C1E9),a
ld (#D1EB),a
ld (#C2D7),a
ld (#C2DC),a
ld a,#0B
ld (#E0A9),a
ld (#E0F4),a
ld (#C23F),a
ld a,#0C
ld (#C241),a
ld (#C290),a
ld (#C292),a
ld (#F293),a
ld a,#0D
ld (#E0A4),a
ld (#C238),a
ld a,#0E
ld (#E059),a
ld (#E0FA),a
ld a,#10
ld (#E004),a
ld (#E010),a
ld (#E0B0),a
ld (#C0F8),a
ld (#C102),a
ld (#C152),a
ld (#C1F1),a
ld (#C232),a
ld (#C282),a
ld (#D286),a
ld (#D289),a
ld (#D28E),a
ld (#C2D2),a
ld (#C2DE),a
ld (#C2E1),a
ld a,#11
ld (#F19D),a
ld a,#12
ld (#F0AD),a
ld a,#13
ld (#C013),a
ld a,#15
ld (#D008),a
ld a,#16
ld (#E0F5),a
ld a,#18
ld (#C0A6),a
ld (#E0A5),a
ld (#D0F9),a
ld (#D14A),a
ld (#E28F),a
ld (#F284),a
ld (#E2D0),a
ld a,#1A
ld (#D05F),a
ld (#E057),a
ld (#D0B2),a
ld (#D102),a
ld (#D152),a
ld (#D192),a
ld (#F23F),a
ld a,#1C
ld (#D292),a
ld a,#1D
ld (#C288),a
ld a,#22
ld (#C010),a
ld (#F283),a
ld a,#2A
ld (#D051),a
ld (#F19E),a
ld (#E1ED),a
ld (#C284),a
ld a,#2B
ld (#D013),a
ld a,#32
ld (#C147),a
ld (#F196),a
ld (#C2DA),a
ld a,#36
ld (#E19C),a
ld a,#3A
ld (#D05A),a
ld (#D0A2),a
ld (#F1E6),a
ld (#D2D2),a
ld a,#40
ld (#C007),a
ld (#D004),a
ld (#F00F),a
ld (#C051),a
ld (#C054),a
ld (#C060),a
ld (#D057),a
ld (#F057),a
ld (#C0B0),a
ld (#D0A9),a
ld (#F0AC),a
ld (#E102),a
ld (#F103),a
ld (#F152),a
ld (#D190),a
ld (#F1A2),a
ld (#C1E7),a
ld (#D1E0),a
ld (#E1F2),a
ld (#F1E2),a
ld (#D23C),a
ld (#F232),a
ld (#D284),a
ld (#D290),a
ld (#F288),a
ld (#C2E2),a
ld (#E2D2),a
ld (#E2D5),a
ld (#F2DC),a
ld (#F2E3),a
ld a,#41
ld (#E053),a
ld (#D199),a
ld (#E19A),a
ld (#E282),a
ld a,#42
ld (#E056),a
ld (#F0F5),a
ld a,#44
ld (#E145),a
ld a,#45
ld (#E0AC),a
ld a,#48
ld (#E00B),a
ld (#D0AB),a
ld a,#4A
ld (#C000),a
ld (#F004),a
ld (#E05B),a
ld (#D19A),a
ld a,#4C
ld (#F147),a
ld a,#50
ld (#C006),a
ld (#E00A),a
ld (#E011),a
ld (#F00B),a
ld (#F00C),a
ld (#C056),a
ld (#C058),a
ld (#C059),a
ld (#C063),a
ld (#D060),a
ld (#E061),a
ld (#F05E),a
ld (#D0A8),a
ld (#D0B0),a
ld (#C0F2),a
ld (#C0FE),a
ld (#D0FE),a
ld (#D0FF),a
ld (#D100),a
ld (#F0F7),a
ld (#D144),a
ld (#E140),a
ld (#E151),a
ld (#E1A1),a
ld (#F191),a
ld (#C1E3),a
ld (#D1E5),a
ld (#F1EB),a
ld (#D233),a
ld (#F231),a
ld (#D283),a
ld (#E284),a
ld (#C2DF),a
ld (#D2DC),a
ld (#D2DD),a
ld (#F2D0),a
ld (#F2D8),a
ld a,#52
ld (#D055),a
ld (#E050),a
ld (#F054),a
ld (#F0A9),a
ld (#C14E),a
ld (#E192),a
ld (#F230),a
ld (#F287),a
ld a,#58
ld (#C05E),a
ld (#D0A4),a
ld (#F0A0),a
ld (#D103),a
ld (#D153),a
ld (#F141),a
ld (#F14F),a
ld (#D194),a
ld (#D1A3),a
ld (#D1E4),a
ld (#D243),a
ld (#D2DF),a
ld a,#5A
ld (#E05A),a
ld (#F058),a
ld (#E0A8),a
ld (#F0AF),a
ld (#F0FE),a
ld (#F0FF),a
ld (#F100),a
ld (#D193),a
ld (#D1F2),a
ld (#F236),a
ld (#E293),a
ld (#C2D6),a
ld (#D2DB),a
ld (#F2E0),a
ld a,#62
ld (#D0A6),a
ld (#C28F),a
ld (#E28E),a
ld a,#6A
ld (#E006),a
ld a,#6B
ld (#F0A5),a
ld a,#7A
ld (#D062),a
ld (#D0A3),a
ld (#F0B0),a
ld (#D293),a
ld (#D2DA),a
ld a,#89
ld (#F0F6),a
ld (#C2E3),a
ld a,#8A
ld (#C00D),a
ld a,#8B
ld (#D2E2),a
ld a,#8E
ld (#C2D0),a
ld (#D2E3),a
ld a,#98
ld (#E19D),a
ld a,#99
ld (#F197),a
ld a,#9A
ld (#D056),a
ld (#E23E),a
ld (#D282),a
ld (#F2D4),a
ld a,#9D
ld (#E0FC),a
ld a,#AA
ld (#F146),a
ld a,#BA
ld (#D053),a
ld (#C28A),a
ld a,#CA
ld (#C287),a
ld a,#CB
ld (#C148),a
ld a,#D8
ld (#D003),a
ld (#F0B1),a
ld (#F0F9),a
ld a,#DA
ld (#D00F),a
ld (#D05B),a
ld (#E051),a
ld (#F0AE),a
ld (#D143),a
ld (#F1E0),a
ld a,#EA
ld (#E14C),a
ld a,#FA
ld (#C00C),a
ld (#D00A),a
ld (#E0FB),a
ld (#D1A2),a
ld (#F1E7),a
ld (#C286),a
ret

p11to12
ld a,#00
ld (#C001),a
ld (#C00E),a
ld (#E00F),a
ld (#F010),a
ld (#C050),a
ld (#C055),a
ld (#D050),a
ld (#D061),a
ld (#E05D),a
ld (#E05F),a
ld (#F057),a
ld (#D0AE),a
ld (#D0AF),a
ld (#E0AE),a
ld (#E0AF),a
ld (#C0F8),a
ld (#D0F1),a
ld (#E0FD),a
ld (#F0FD),a
ld (#C150),a
ld (#C152),a
ld (#E194),a
ld (#E195),a
ld (#F193),a
ld (#F194),a
ld (#C1F1),a
ld (#E1E2),a
ld (#F1E2),a
ld (#C23B),a
ld (#D23C),a
ld (#F234),a
ld (#F23E),a
ld (#C292),a
ld (#D284),a
ld (#D286),a
ld (#D28D),a
ld (#E282),a
ld (#C2DD),a
ld (#D2D1),a
ld (#D2D4),a
ld (#D2D6),a
ld (#E2D3),a
ld (#F2DC),a
ld a,#01
ld (#D008),a
ld (#F000),a
ld (#C151),a
ld (#C19F),a
ld (#C230),a
ld (#C280),a
ld (#D291),a
ld (#F28F),a
ld (#C2D8),a
ld a,#02
ld (#E054),a
ld (#E056),a
ld (#C0B1),a
ld (#E0B3),a
ld (#D0F7),a
ld (#E103),a
ld (#D141),a
ld (#D1F1),a
ld (#F1E3),a
ld (#F1E9),a
ld (#D281),a
ld (#D2E1),a
ld a,#03
ld (#F23A),a
ld (#F28B),a
ld a,#04
ld (#C004),a
ld (#E003),a
ld (#E05C),a
ld (#E060),a
ld (#E0B0),a
ld (#C1A1),a
ld (#C1E0),a
ld (#C241),a
ld (#C289),a
ld (#F293),a
ld (#C2D1),a
ld (#C2D9),a
ld (#D2D8),a
ld a,#05
ld (#E0AD),a
ld (#C1A0),a
ld (#F1E8),a
ld (#C238),a
ld (#D285),a
ld (#D2D7),a
ld a,#06
ld (#E059),a
ld (#E19C),a
ld (#F198),a
ld a,#08
ld (#C011),a
ld (#E193),a
ld (#C28D),a
ld (#D2D5),a
ld a,#09
ld (#E144),a
ld a,#0A
ld (#C000),a
ld (#C00D),a
ld (#D005),a
ld (#D05C),a
ld (#D05D),a
ld (#E063),a
ld (#E0A9),a
ld (#D0F8),a
ld (#D102),a
ld (#E0FA),a
ld (#D152),a
ld (#D191),a
ld (#E192),a
ld (#F233),a
ld (#C284),a
ld (#F283),a
ld (#D2DE),a
ld (#E2DF),a
ld a,#0B
ld (#E058),a
ld a,#0C
ld (#E008),a
ld (#C2E3),a
ld a,#0D
ld (#F1EE),a
ld a,#10
ld (#C002),a
ld (#C005),a
ld (#E009),a
ld (#E00C),a
ld (#E012),a
ld (#C0B2),a
ld (#F0A6),a
ld (#D0F9),a
ld (#E0FE),a
ld (#C1A2),a
ld (#C239),a
ld (#F242),a
ld (#C291),a
ld (#C2D5),a
ld (#E2D7),a
ld (#F2DE),a
ld a,#11
ld (#E053),a
ld a,#12
ld (#E0F5),a
ld (#F2E0),a
ld a,#16
ld (#F23F),a
ld a,#18
ld (#F055),a
ld (#E1EB),a
ld (#F28D),a
ld (#D2D0),a
ld a,#1A
ld (#E006),a
ld (#C05E),a
ld (#D0F2),a
ld (#D142),a
ld a,#1B
ld (#E0F4),a
ld a,#22
ld (#D002),a
ld (#C0F6),a
ld (#E1ED),a
ld (#D231),a
ld a,#2A
ld (#D1EB),a
ld (#C23F),a
ld (#C2E0),a
ld a,#32
ld (#D05A),a
ld a,#36
ld (#F19E),a
ld a,#3A
ld (#D05F),a
ld (#D062),a
ld (#C147),a
ld (#D1A2),a
ld (#F196),a
ld (#E23E),a
ld (#C2DA),a
ld a,#40
ld (#E00E),a
ld (#F006),a
ld (#D058),a
ld (#F051),a
ld (#C0A1),a
ld (#D0AD),a
ld (#D0B1),a
ld (#E0A3),a
ld (#E0B2),a
ld (#C0F5),a
ld (#D101),a
ld (#E0F8),a
ld (#D140),a
ld (#D149),a
ld (#D14F),a
ld (#E152),a
ld (#F153),a
ld (#C197),a
ld (#D199),a
ld (#E199),a
ld (#F192),a
ld (#F1F3),a
ld (#C23A),a
ld (#D230),a
ld (#E23D),a
ld (#F238),a
ld (#C28B),a
ld (#F28A),a
ld (#C2D3),a
ld a,#41
ld (#C054),a
ld (#E2D2),a
ld a,#42
ld (#C010),a
ld (#D0A6),a
ld (#C237),a
ld (#C283),a
ld (#C28F),a
ld (#E28E),a
ld (#E2D5),a
ld a,#43
ld (#C013),a
ld a,#44
ld (#D009),a
ld (#F147),a
ld a,#45
ld (#F14D),a
ld a,#48
ld (#D063),a
ld (#E0F3),a
ld (#E19B),a
ld a,#49
ld (#E19A),a
ld a,#4A
ld (#E0F9),a
ld (#C1E9),a
ld (#C2D7),a
ld a,#4C
ld (#E0A4),a
ld a,#4D
ld (#E0AC),a
ld a,#50
ld (#C007),a
ld (#D004),a
ld (#D00D),a
ld (#D010),a
ld (#E00B),a
ld (#E00D),a
ld (#F005),a
ld (#D057),a
ld (#E050),a
ld (#F05D),a
ld (#F05F),a
ld (#C0B0),a
ld (#D0A4),a
ld (#D0A9),a
ld (#D0AA),a
ld (#D0AB),a
ld (#E0A2),a
ld (#C0FF),a
ld (#D0F4),a
ld (#F0F1),a
ld (#C14E),a
ld (#F141),a
ld (#F152),a
ld (#C193),a
ld (#D19F),a
ld (#F1A2),a
ld (#C1E2),a
ld (#C1EB),a
ld (#D1E3),a
ld (#D1E4),a
ld (#F1F1),a
ld (#C232),a
ld (#E234),a
ld (#E235),a
ld (#E236),a
ld (#F230),a
ld (#C282),a
ld (#C293),a
ld (#D288),a
ld (#F284),a
ld (#F287),a
ld (#F288),a
ld (#D2D3),a
ld (#E2D4),a
ld (#E2DE),a
ld a,#52
ld (#D00E),a
ld (#E005),a
ld (#D148),a
ld (#F14C),a
ld (#D1EA),a
ld (#C233),a
ld (#F236),a
ld (#C2D6),a
ld a,#58
ld (#D003),a
ld (#D00C),a
ld (#F011),a
ld (#C05F),a
ld (#D056),a
ld (#F059),a
ld (#E0A5),a
ld (#F0AA),a
ld (#E146),a
ld (#F148),a
ld (#F190),a
ld (#D1E2),a
ld (#D1F3),a
ld (#E1EE),a
ld (#F1E0),a
ld (#D232),a
ld (#E293),a
ld (#D2DB),a
ld (#E2D0),a
ld (#F2D4),a
ld a,#5A
ld (#D00F),a
ld (#E013),a
ld (#F007),a
ld (#C05D),a
ld (#E051),a
ld (#F061),a
ld (#D0A7),a
ld (#F0AE),a
ld (#F0B0),a
ld (#D143),a
ld (#D153),a
ld (#E143),a
ld (#F14F),a
ld (#C234),a
ld (#C235),a
ld (#F237),a
ld (#C285),a
ld (#C28A),a
ld (#D282),a
ld (#D2DA),a
ld a,#72
ld (#D055),a
ld (#F054),a
ld (#F0F5),a
ld (#F2D3),a
ld a,#7A
ld (#C00B),a
ld (#D00A),a
ld (#E0A8),a
ld (#D242),a
ld a,#88
ld (#E000),a
ld (#D19B),a
ld a,#89
ld (#E0FC),a
ld a,#8A
ld (#C1EF),a
ld (#D2E3),a
ld (#E2D6),a
ld a,#8B
ld (#C148),a
ld a,#8C
ld (#C290),a
ld a,#8D
ld (#F0F6),a
ld (#C2D0),a
ld a,#98
ld (#C0A6),a
ld (#C199),a
ld (#F199),a
ld (#E28F),a
ld a,#9A
ld (#D2D2),a
ld a,#AA
ld (#C287),a
ld a,#AE
ld (#D000),a
ld a,#BA
ld (#E0FB),a
ld (#C198),a
ld a,#CA
ld (#F004),a
ld (#E05B),a
ld a,#D8
ld (#D0B3),a
ld (#F19F),a
ld a,#DA
ld (#D053),a
ld (#F0B1),a
ld (#F101),a
ld (#D1A3),a
ld (#C2DB),a
ld a,#EA
ld (#F1E7),a
ld a,#EB
ld (#F0A5),a
ld (#F146),a
ld a,#FA
ld (#D012),a
ld (#E05A),a
ld (#D0A3),a
ld (#F0FE),a
ld (#F0FF),a
ld (#F100),a
ld (#D1F2),a
ret

p12to13
ld a,#00
ld (#D001),a
ld (#D008),a
ld (#F006),a
ld (#D05E),a
ld (#E056),a
ld (#E058),a
ld (#E05C),a
ld (#E060),a
ld (#D0AD),a
ld (#F0AC),a
ld (#E0FE),a
ld (#C151),a
ld (#D140),a
ld (#C1A0),a
ld (#D190),a
ld (#D199),a
ld (#E193),a
ld (#F192),a
ld (#D1E0),a
ld (#E1EB),a
ld (#F1E5),a
ld (#C238),a
ld (#D234),a
ld (#F238),a
ld (#C281),a
ld (#D285),a
ld (#D287),a
ld (#E285),a
ld (#F28A),a
ld (#F293),a
ld (#C2D8),a
ld (#C2DE),a
ld (#C2E3),a
ld a,#01
ld (#C00E),a
ld (#F010),a
ld (#E053),a
ld (#E0B0),a
ld (#C1F0),a
ld (#D2D7),a
ld (#D2DE),a
ld (#E2D2),a
ld (#F2DC),a
ld a,#02
ld (#F000),a
ld (#C0A5),a
ld (#D0B2),a
ld (#E0AA),a
ld (#D102),a
ld (#F232),a
ld (#D2D1),a
ld (#D2D4),a
ld a,#04
ld (#E059),a
ld (#C152),a
ld (#E145),a
ld (#C1A2),a
ld (#F194),a
ld (#C230),a
ld (#D28E),a
ld (#E282),a
ld (#F2DD),a
ld a,#05
ld (#D009),a
ld (#E008),a
ld (#E14B),a
ld (#C1A1),a
ld (#F193),a
ld (#D284),a
ld (#F28C),a
ld a,#06
ld (#E003),a
ld a,#08
ld (#E010),a
ld (#D05D),a
ld (#E0A9),a
ld (#C102),a
ld (#D0F8),a
ld (#E100),a
ld (#F151),a
ld (#E192),a
ld (#E19B),a
ld (#F1E3),a
ld (#D23C),a
ld (#F233),a
ld a,#09
ld (#F1EE),a
ld a,#0A
ld (#C061),a
ld (#D0A6),a
ld (#D0AF),a
ld (#E0FF),a
ld (#D141),a
ld (#E143),a
ld (#F23A),a
ld (#C283),a
ld (#C28D),a
ld (#E2D6),a
ld a,#0B
ld (#D1EB),a
ld (#F28B),a
ld (#D2E2),a
ld a,#0C
ld (#E0FA),a
ld (#D1EC),a
ld (#C240),a
ld (#E2D7),a
ld a,#0D
ld (#E0AC),a
ld a,#10
ld (#C00F),a
ld (#F00E),a
ld (#C062),a
ld (#E0B1),a
ld (#F0AD),a
ld (#C192),a
ld (#C1F2),a
ld (#D1ED),a
ld (#F1EB),a
ld (#C231),a
ld (#E233),a
ld (#E283),a
ld (#E286),a
ld (#E28C),a
ld (#F290),a
ld (#E2D8),a
ld (#E2E0),a
ld a,#11
ld (#E144),a
ld a,#12
ld (#C00A),a
ld a,#14
ld (#F0FD),a
ld a,#15
ld (#C288),a
ld a,#16
ld (#F2E0),a
ld a,#18
ld (#C055),a
ld (#C05F),a
ld (#E054),a
ld (#D0B0),a
ld (#C199),a
ld (#C1EA),a
ld (#D292),a
ld (#D2DF),a
ld a,#1A
ld (#D00F),a
ld (#F007),a
ld (#D05F),a
ld (#D062),a
ld (#F061),a
ld (#D153),a
ld (#D1E1),a
ld (#F1E6),a
ld (#F1EF),a
ld (#D231),a
ld (#C284),a
ld (#F28D),a
ld a,#1D
ld (#E0F4),a
ld (#F14D),a
ld a,#22
ld (#C000),a
ld (#D051),a
ld (#D281),a
ld (#C2E0),a
ld (#E2DF),a
ld a,#26
ld (#F198),a
ld a,#2A
ld (#D002),a
ld (#D052),a
ld a,#2E
ld (#D000),a
ld (#F1E9),a
ld a,#32
ld (#C0F6),a
ld a,#36
ld (#E1ED),a
ld a,#3A
ld (#D012),a
ld (#E05A),a
ld (#F0B1),a
ld (#E0F5),a
ld (#E0FB),a
ld (#F14E),a
ld a,#40
ld (#C003),a
ld (#C008),a
ld (#C010),a
ld (#C013),a
ld (#E002),a
ld (#E00F),a
ld (#F00D),a
ld (#C054),a
ld (#D061),a
ld (#E062),a
ld (#D0AC),a
ld (#D0F0),a
ld (#F0FA),a
ld (#F145),a
ld (#C19F),a
ld (#D19A),a
ld (#F1A3),a
ld (#E1E1),a
ld (#D23B),a
ld (#E231),a
ld (#E23A),a
ld (#E243),a
ld (#F23E),a
ld (#D280),a
ld (#D283),a
ld (#D28D),a
ld (#E284),a
ld (#E28B),a
ld (#C2DC),a
ld (#F2DB),a
ld (#F2DF),a
ld a,#41
ld (#C2D3),a
ld a,#42
ld (#E005),a
ld (#F060),a
ld (#F0A9),a
ld (#E0F9),a
ld (#E191),a
ld (#C1E9),a
ld (#C2D7),a
ld a,#44
ld (#C2D9),a
ld a,#45
ld (#F1E8),a
ld (#D2D8),a
ld a,#46
ld (#E0A4),a
ld (#F147),a
ld (#F23F),a
ld a,#48
ld (#F0FC),a
ld a,#4A
ld (#E013),a
ld (#E142),a
ld (#F150),a
ld (#D1A2),a
ld a,#4C
ld (#F0F6),a
ld a,#50
ld (#D006),a
ld (#E004),a
ld (#E00C),a
ld (#E00E),a
ld (#E012),a
ld (#F00F),a
ld (#C052),a
ld (#C060),a
ld (#D058),a
ld (#F05C),a
ld (#C0A1),a
ld (#E0B2),a
ld (#F0A0),a
ld (#C100),a
ld (#D101),a
ld (#E102),a
ld (#F103),a
ld (#D14F),a
ld (#D150),a
ld (#D151),a
ld (#E152),a
ld (#F140),a
ld (#F153),a
ld (#D192),a
ld (#D194),a
ld (#E1A2),a
ld (#F190),a
ld (#C1E7),a
ld (#D1E2),a
ld (#E1F2),a
ld (#F1ED),a
ld (#D241),a
ld (#F234),a
ld (#F235),a
ld (#F236),a
ld (#C28B),a
ld (#C28F),a
ld (#D289),a
ld (#E292),a
ld (#E293),a
ld (#F28E),a
ld (#C2D2),a
ld (#C2D5),a
ld (#C2D6),a
ld (#D2DA),a
ld (#D2DB),a
ld (#E2D0),a
ld (#F2E3),a
ld a,#52
ld (#C05C),a
ld (#D05A),a
ld (#F0FB),a
ld (#D242),a
ld (#E28E),a
ld (#E2E3),a
ld (#F2D6),a
ld a,#58
ld (#F008),a
ld (#D060),a
ld (#D0A8),a
ld (#F0B2),a
ld (#F0F0),a
ld (#F0F9),a
ld (#F102),a
ld (#F19B),a
ld (#F237),a
ld (#C28A),a
ld (#D282),a
ld (#D2D0),a
ld a,#5A
ld (#F059),a
ld (#D0A2),a
ld (#F0AA),a
ld (#D103),a
ld (#F100),a
ld (#C236),a
ld (#D243),a
ld (#C286),a
ld a,#62
ld (#D055),a
ld (#F054),a
ld (#F0F5),a
ld (#C23F),a
ld (#F2D3),a
ld a,#63
ld (#F19D),a
ld a,#66
ld (#F19E),a
ld a,#6A
ld (#E2D5),a
ld a,#72
ld (#F14C),a
ld (#D1EA),a
ld a,#7A
ld (#F058),a
ld (#F0FE),a
ld (#D1F2),a
ld (#C233),a
ld a,#88
ld (#C011),a
ld a,#8A
ld (#F004),a
ld (#C05E),a
ld a,#8B
ld (#F0A5),a
ld (#E0FC),a
ld (#C290),a
ld a,#8C
ld (#D19B),a
ld a,#8E
ld (#D2E3),a
ld a,#98
ld (#D053),a
ld a,#9A
ld (#D005),a
ld a,#9D
ld (#F197),a
ld a,#AA
ld (#C148),a
ld (#E14C),a
ld (#C1EF),a
ld a,#BA
ld (#C147),a
ld a,#C8
ld (#E05B),a
ld (#C0F7),a
ld a,#CA
ld (#F1E7),a
ld a,#D8
ld (#E000),a
ld (#D063),a
ld (#C0A6),a
ld (#E1EE),a
ld a,#DA
ld (#C00C),a
ld (#D00B),a
ld (#F0FF),a
ld (#F14F),a
ld (#E19D),a
ld (#D1F3),a
ld (#F283),a
ld (#D2D2),a
ld a,#EA
ld (#D05B),a
ld (#D0A3),a
ld (#C198),a
ld (#C287),a
ld a,#FA
ld (#C00B),a
ld (#C05D),a
ld (#F101),a
ld (#D1A3),a
ld (#C234),a
ld (#C235),a
ld a,#FB
ld (#F146),a
ret

p13to14
ld a,#00
ld (#C004),a
ld (#D009),a
ld (#D011),a
ld (#E007),a
ld (#F00D),a
ld (#F00E),a
ld (#F010),a
ld (#C054),a
ld (#C05F),a
ld (#D05D),a
ld (#D0A0),a
ld (#D0B2),a
ld (#C102),a
ld (#D0F0),a
ld (#D0FF),a
ld (#D100),a
ld (#D102),a
ld (#E0FF),a
ld (#E100),a
ld (#F142),a
ld (#F143),a
ld (#C1A1),a
ld (#E192),a
ld (#C1E0),a
ld (#C1F2),a
ld (#E1E1),a
ld (#F1E3),a
ld (#C241),a
ld (#D230),a
ld (#E23A),a
ld (#F23B),a
ld (#C283),a
ld (#C289),a
ld (#D291),a
ld (#E286),a
ld (#E28B),a
ld (#F289),a
ld (#F28C),a
ld (#C2D3),a
ld (#D2D5),a
ld (#D2D7),a
ld (#D2DE),a
ld (#D2E1),a
ld (#E2D2),a
ld (#E2D8),a
ld (#E2DC),a
ld (#F2DB),a
ld a,#01
ld (#E059),a
ld (#E0A3),a
ld (#C0F8),a
ld (#E0FD),a
ld (#C152),a
ld (#D23D),a
ld (#F238),a
ld a,#02
ld (#E005),a
ld (#D062),a
ld (#E060),a
ld (#D0AF),a
ld (#D0F1),a
ld (#D140),a
ld (#D190),a
ld (#D1E0),a
ld (#F1E2),a
ld (#F28A),a
ld a,#04
ld (#E0AD),a
ld (#D284),a
ld (#D287),a
ld (#F2E0),a
ld a,#05
ld (#D0AD),a
ld (#E0F4),a
ld (#C1A2),a
ld (#E19C),a
ld (#F194),a
ld (#C1F1),a
ld (#C280),a
ld (#C288),a
ld (#E2D7),a
ld a,#06
ld (#E009),a
ld (#E1ED),a
ld (#F239),a
ld a,#08
ld (#C00D),a
ld (#F004),a
ld (#C0B2),a
ld (#E0F3),a
ld (#E0FA),a
ld (#E191),a
ld (#F1A0),a
ld (#F28B),a
ld (#C2DE),a
ld (#C2E1),a
ld a,#09
ld (#F2DC),a
ld a,#0A
ld (#D000),a
ld (#D00F),a
ld (#C05E),a
ld (#D0B0),a
ld (#F0B1),a
ld (#C148),a
ld (#D14A),a
ld (#E142),a
ld (#D1EB),a
ld (#F1E9),a
ld (#D235),a
ld (#E285),a
ld a,#0B
ld (#D0F8),a
ld (#F1EE),a
ld (#F23A),a
ld a,#0C
ld (#F23F),a
ld a,#0D
ld (#C2D0),a
ld a,#10
ld (#D05E),a
ld (#E05D),a
ld (#E061),a
ld (#F055),a
ld (#E0A7),a
ld (#E101),a
ld (#C142),a
ld (#C153),a
ld (#F144),a
ld (#C191),a
ld (#C1A3),a
ld (#F1A1),a
ld (#C1E1),a
ld (#C242),a
ld (#C281),a
ld (#D288),a
ld (#D292),a
ld (#D2D9),a
ld (#D2DF),a
ld (#E2DD),a
ld a,#12
ld (#E063),a
ld (#D0A1),a
ld (#F0FB),a
ld (#D1F1),a
ld a,#15
ld (#D2D8),a
ld a,#16
ld (#E145),a
ld a,#18
ld (#D0A8),a
ld (#F152),a
ld (#D191),a
ld (#F1EF),a
ld (#F233),a
ld (#E2D3),a
ld (#E2E0),a
ld (#F2DE),a
ld a,#1A
ld (#F011),a
ld (#F0AA),a
ld (#D103),a
ld (#D1A3),a
ld (#E2D5),a
ld a,#1C
ld (#C199),a
ld a,#22
ld (#E003),a
ld (#C061),a
ld (#C0A5),a
ld (#F232),a
ld a,#26
ld (#E0A4),a
ld (#F147),a
ld a,#2A
ld (#F151),a
ld (#C233),a
ld a,#32
ld (#C00A),a
ld (#D051),a
ld (#E0FB),a
ld a,#3A
ld (#F007),a
ld (#D052),a
ld (#C0F6),a
ld (#E14C),a
ld (#F198),a
ld a,#40
ld (#D001),a
ld (#C050),a
ld (#D059),a
ld (#E058),a
ld (#F060),a
ld (#C0A4),a
ld (#C0B1),a
ld (#C101),a
ld (#D0FE),a
ld (#E103),a
ld (#C149),a
ld (#E14A),a
ld (#E153),a
ld (#F14B),a
ld (#E1A3),a
ld (#F191),a
ld (#F1E1),a
ld (#D233),a
ld (#E281),a
ld (#E28E),a
ld (#C2D7),a
ld (#D2D3),a
ld (#F2D5),a
ld a,#41
ld (#E231),a
ld a,#42
ld (#D055),a
ld (#D0F3),a
ld (#D152),a
ld (#E284),a
ld (#E2DF),a
ld (#E2E3),a
ld a,#43
ld (#F054),a
ld a,#44
ld (#F0F6),a
ld a,#46
ld (#F19E),a
ld a,#48
ld (#C0F7),a
ld (#E19A),a
ld a,#4A
ld (#D0A7),a
ld (#E141),a
ld (#F2D3),a
ld a,#50
ld (#C002),a
ld (#C005),a
ld (#C008),a
ld (#C009),a
ld (#C010),a
ld (#D003),a
ld (#D007),a
ld (#D00C),a
ld (#D00E),a
ld (#E05E),a
ld (#E062),a
ld (#F057),a
ld (#D0B1),a
ld (#E0A5),a
ld (#F0A2),a
ld (#F0A6),a
ld (#F0AE),a
ld (#F0AF),a
ld (#C0F5),a
ld (#F0F0),a
ld (#C146),a
ld (#C14F),a
ld (#D148),a
ld (#C192),a
ld (#C197),a
ld (#D193),a
ld (#D1A1),a
ld (#F1A3),a
ld (#C1E8),a
ld (#E1E4),a
ld (#E1E6),a
ld (#F1E0),a
ld (#F1F3),a
ld (#C237),a
ld (#C239),a
ld (#D232),a
ld (#E233),a
ld (#F237),a
ld (#C28A),a
ld (#D280),a
ld (#E283),a
ld (#C2DC),a
ld (#C2E2),a
ld (#D2E0),a
ld a,#52
ld (#D004),a
ld (#E013),a
ld (#F003),a
ld (#D05F),a
ld (#F0B0),a
ld (#E0F2),a
ld (#F0F8),a
ld (#D23B),a
ld (#F282),a
ld a,#54
ld (#F0FD),a
ld a,#58
ld (#D010),a
ld (#E00A),a
ld (#F05A),a
ld (#C0A6),a
ld (#E0A2),a
ld (#F0A8),a
ld (#C14A),a
ld (#D143),a
ld (#E14D),a
ld (#C2DB),a
ld (#F2D7),a
ld a,#5A
ld (#D00B),a
ld (#C0AE),a
ld (#C0AF),a
ld (#D0B3),a
ld (#E0A8),a
ld (#F0AB),a
ld (#F0FE),a
ld (#F0FF),a
ld (#D1A2),a
ld (#C1E3),a
ld (#C1E4),a
ld (#D1F2),a
ld (#F1E6),a
ld (#C234),a
ld (#D293),a
ld (#F2D6),a
ld a,#5D
ld (#F197),a
ld a,#62
ld (#F19D),a
ld (#C2E0),a
ld (#D2D1),a
ld a,#6A
ld (#F058),a
ld (#C287),a
ld (#D281),a
ld a,#7A
ld (#C05C),a
ld (#D05B),a
ld (#D0A2),a
ld (#F101),a
ld a,#88
ld (#D19B),a
ld (#D23C),a
ld a,#89
ld (#E0AC),a
ld a,#8A
ld (#C011),a
ld (#D002),a
ld (#E0FC),a
ld (#C290),a
ld a,#8B
ld (#D013),a
ld a,#8C
ld (#C240),a
ld a,#8D
ld (#F0A5),a
ld a,#98
ld (#C055),a
ld (#E054),a
ld (#D2D2),a
ld a,#9A
ld (#F008),a
ld (#F059),a
ld (#E0F5),a
ld (#F283),a
ld a,#9B
ld (#F146),a
ld (#F1E7),a
ld a,#9C
ld (#D2E3),a
ld a,#9D
ld (#F14D),a
ld a,#CA
ld (#F0FC),a
ld a,#D8
ld (#D005),a
ld (#F102),a
ld (#F148),a
ld (#F19B),a
ld a,#DA
ld (#E000),a
ld (#D060),a
ld (#D063),a
ld (#E05B),a
ld (#D231),a
ld (#D243),a
ld (#E28F),a
ld a,#EA
ld (#C147),a
ld (#F196),a
ld (#C1EF),a
ld a,#FA
ld (#E0AB),a
ld (#F14F),a
ld (#F150),a
ld (#D1F3),a
ld (#C236),a
ld (#C2DA),a
ret

p14to15
ld a,#00
ld (#C00E),a
ld (#E005),a
ld (#E059),a
ld (#E060),a
ld (#D0A6),a
ld (#D0AF),a
ld (#E0AA),a
ld (#E0AD),a
ld (#E0B0),a
ld (#D0FE),a
ld (#E101),a
ld (#C152),a
ld (#E191),a
ld (#F191),a
ld (#F193),a
ld (#F194),a
ld (#C1F0),a
ld (#C230),a
ld (#C242),a
ld (#D23D),a
ld (#E234),a
ld (#C288),a
ld (#C291),a
ld (#D283),a
ld (#F28F),a
ld (#F2D5),a
ld (#F2DD),a
ld a,#01
ld (#E008),a
ld (#D062),a
ld (#E144),a
ld (#C1A2),a
ld (#C241),a
ld (#D233),a
ld (#E231),a
ld (#D28E),a
ld (#D291),a
ld (#D2D8),a
ld (#D2E1),a
ld (#F2E0),a
ld a,#02
ld (#D00F),a
ld (#C054),a
ld (#F061),a
ld (#C102),a
ld (#D0F0),a
ld (#E0FB),a
ld (#F1EB),a
ld (#D235),a
ld (#F2DB),a
ld a,#03
ld (#D0F8),a
ld a,#04
ld (#E009),a
ld (#F00E),a
ld (#E053),a
ld (#E0B1),a
ld (#D0FF),a
ld (#F143),a
ld (#C1A3),a
ld (#E1E1),a
ld (#E1ED),a
ld (#C280),a
ld (#C2D3),a
ld (#C2D9),a
ld (#E2D2),a
ld (#E2D8),a
ld a,#05
ld (#C1F2),a
ld (#D287),a
ld (#E286),a
ld a,#06
ld (#D012),a
ld (#F0F6),a
ld a,#08
ld (#D05C),a
ld (#F0AC),a
ld (#D141),a
ld (#E143),a
ld (#F192),a
ld (#F1A1),a
ld (#D236),a
ld (#D284),a
ld (#E2D6),a
ld (#F2DC),a
ld a,#09
ld (#F00D),a
ld (#F23F),a
ld a,#0A
ld (#E010),a
ld (#D055),a
ld (#C0B2),a
ld (#D0A7),a
ld (#F0AA),a
ld (#D0F1),a
ld (#D140),a
ld (#D153),a
ld (#E141),a
ld (#E150),a
ld (#D190),a
ld (#D1A3),a
ld (#F1A0),a
ld (#F1E2),a
ld (#C23B),a
ld (#F232),a
ld (#C2DE),a
ld (#D2D4),a
ld (#D2E2),a
ld a,#0B
ld (#F054),a
ld a,#0E
ld (#D1EC),a
ld a,#10
ld (#C012),a
ld (#F00F),a
ld (#D05D),a
ld (#E05C),a
ld (#F05F),a
ld (#D0A8),a
ld (#C103),a
ld (#D101),a
ld (#C141),a
ld (#F1A2),a
ld (#C1F3),a
ld (#D1F1),a
ld (#E1E9),a
ld (#F1E3),a
ld (#F1EF),a
ld (#F1F1),a
ld (#D23E),a
ld (#E235),a
ld (#C284),a
ld (#C289),a
ld (#E287),a
ld (#F293),a
ld (#C2D1),a
ld (#C2D4),a
ld (#D2D5),a
ld (#E2D3),a
ld (#E2D9),a
ld a,#12
ld (#E003),a
ld (#D051),a
ld (#D103),a
ld (#F0F8),a
ld (#F14C),a
ld a,#14
ld (#F011),a
ld (#F290),a
ld (#D2DF),a
ld a,#15
ld (#F238),a
ld a,#18
ld (#E006),a
ld (#F004),a
ld (#C062),a
ld (#D053),a
ld (#E146),a
ld (#D2D2),a
ld a,#1A
ld (#D000),a
ld (#D060),a
ld (#E19D),a
ld (#C233),a
ld (#F2DE),a
ld a,#1C
ld (#D2E3),a
ld a,#22
ld (#D14A),a
ld (#D1E0),a
ld (#F28A),a
ld a,#23
ld (#F1EE),a
ld a,#2A
ld (#C011),a
ld (#C28D),a
ld (#F2D6),a
ld a,#32
ld (#C0A5),a
ld (#E0A4),a
ld (#D0F7),a
ld (#E145),a
ld (#E14C),a
ld (#F147),a
ld (#C23F),a
ld (#E23E),a
ld a,#36
ld (#F14E),a
ld a,#3A
ld (#D0B0),a
ld (#D0B3),a
ld a,#40
ld (#C00D),a
ld (#D008),a
ld (#D011),a
ld (#E007),a
ld (#E00D),a
ld (#F000),a
ld (#F00C),a
ld (#E055),a
ld (#F05E),a
ld (#C0A7),a
ld (#E0B3),a
ld (#F0A4),a
ld (#D0F6),a
ld (#D0FD),a
ld (#D102),a
ld (#E0F9),a
ld (#D152),a
ld (#E14E),a
ld (#F141),a
ld (#E190),a
ld (#C1EE),a
ld (#D1EB),a
ld (#E1F3),a
ld (#E239),a
ld (#C282),a
ld (#C28B),a
ld (#C28F),a
ld (#E28A),a
ld (#C2DD),a
ld (#D2D6),a
ld (#E2DB),a
ld (#F2DA),a
ld a,#41
ld (#E002),a
ld (#E199),a
ld (#E281),a
ld a,#42
ld (#D001),a
ld (#C061),a
ld (#E0A8),a
ld (#C232),a
ld (#E2D4),a
ld a,#43
ld (#F0F5),a
ld a,#44
ld (#E0F4),a
ld (#F0FD),a
ld a,#49
ld (#C0F7),a
ld a,#4A
ld (#E0F2),a
ld (#E14F),a
ld (#C287),a
ld a,#4C
ld (#F0A5),a
ld (#F19E),a
ld a,#50
ld (#E00F),a
ld (#E013),a
ld (#C051),a
ld (#D056),a
ld (#D059),a
ld (#D05A),a
ld (#D05E),a
ld (#E05D),a
ld (#E05F),a
ld (#F051),a
ld (#E0A7),a
ld (#F0AD),a
ld (#F0B0),a
ld (#C101),a
ld (#C142),a
ld (#C150),a
ld (#D142),a
ld (#D143),a
ld (#E14D),a
ld (#C191),a
ld (#D19A),a
ld (#D1A0),a
ld (#C1E1),a
ld (#D1F0),a
ld (#E1E3),a
ld (#E1E5),a
ld (#F1E4),a
ld (#C231),a
ld (#F233),a
ld (#F242),a
ld (#C285),a
ld (#D282),a
ld (#C2D7),a
ld (#C2DB),a
ld (#D2D0),a
ld (#D2D3),a
ld (#F2D4),a
ld a,#52
ld (#D00A),a
ld (#C05B),a
ld (#E063),a
ld (#C0AD),a
ld (#E0F1),a
ld (#E140),a
ld (#F145),a
ld (#D1A2),a
ld (#C1E2),a
ld (#E1EA),a
ld (#F1E6),a
ld (#D230),a
ld (#C286),a
ld (#D293),a
ld (#F285),a
ld (#E2E3),a
ld a,#58
ld (#D005),a
ld (#D00B),a
ld (#F009),a
ld (#F062),a
ld (#C0B0),a
ld (#D191),a
ld (#F19F),a
ld (#C1EA),a
ld (#D1E1),a
ld (#E23F),a
ld (#C28E),a
ld (#F283),a
ld (#F286),a
ld a,#5A
ld (#C00C),a
ld (#E000),a
ld (#C05D),a
ld (#D063),a
ld (#F05A),a
ld (#F0B2),a
ld (#D0F2),a
ld (#F101),a
ld (#E151),a
ld (#F150),a
ld (#F151),a
ld (#C1E5),a
ld (#C235),a
ld (#C2DA),a
ld a,#62
ld (#F003),a
ld (#E284),a
ld a,#6A
ld (#C1EF),a
ld a,#72
ld (#D004),a
ld (#D05B),a
ld (#D23B),a
ld (#F282),a
ld (#D2D1),a
ld a,#7A
ld (#F058),a
ld (#D1F3),a
ld (#D243),a
ld (#E28F),a
ld a,#88
ld (#E0AC),a
ld (#C2E1),a
ld a,#8A
ld (#C0AF),a
ld (#D0A3),a
ld (#C240),a
ld (#D23C),a
ld (#F23A),a
ld (#F2D3),a
ld a,#8E
ld (#C148),a
ld a,#98
ld (#F19B),a
ld (#E2E0),a
ld a,#99
ld (#F146),a
ld (#F14D),a
ld (#F1E7),a
ld a,#9A
ld (#F2D7),a
ld a,#9C
ld (#C199),a
ld a,#AA
ld (#F008),a
ld (#D052),a
ld (#F059),a
ld (#C0F6),a
ld (#F1E9),a
ld (#C290),a
ld a,#CA
ld (#E0FC),a
ld (#D281),a
ld a,#D8
ld (#C055),a
ld (#E054),a
ld (#E0F5),a
ld (#E196),a
ld a,#DA
ld (#E00A),a
ld (#F0A8),a
ld (#F102),a
ld (#F152),a
ld a,#EA
ld (#F0FC),a
ld a,#FA
ld (#C05C),a
ld (#C0AE),a
ld (#F0AB),a
ld (#C1E3),a
ld (#C1E4),a
ret

p15to16
ld a,#00
ld (#C003),a
ld (#D00F),a
ld (#E002),a
ld (#E008),a
ld (#E00D),a
ld (#D062),a
ld (#F05F),a
ld (#C0A7),a
ld (#E0B1),a
ld (#D0F9),a
ld (#D103),a
ld (#E0F8),a
ld (#E0FB),a
ld (#F0F2),a
ld (#F0F3),a
ld (#F0FB),a
ld (#D150),a
ld (#E143),a
ld (#C193),a
ld (#C1A2),a
ld (#C1F1),a
ld (#D1E3),a
ld (#E1E1),a
ld (#E1E8),a
ld (#F1EB),a
ld (#F1F1),a
ld (#C243),a
ld (#D235),a
ld (#E235),a
ld (#E239),a
ld (#D284),a
ld (#E282),a
ld (#E28A),a
ld (#F2DA),a
ld a,#01
ld (#C05F),a
ld (#F061),a
ld (#E101),a
ld (#F141),a
ld (#C1F2),a
ld (#C28C),a
ld (#D287),a
ld (#E2D7),a
ld a,#02
ld (#D012),a
ld (#E056),a
ld (#D0A6),a
ld (#C0F8),a
ld (#D100),a
ld (#D153),a
ld (#E14C),a
ld (#F1E1),a
ld (#D23D),a
ld (#E23E),a
ld (#D283),a
ld a,#03
ld (#C0F7),a
ld a,#04
ld (#D0AD),a
ld (#F144),a
ld (#C1F3),a
ld (#E231),a
ld (#F23B),a
ld (#E287),a
ld (#E28B),a
ld (#F290),a
ld (#C2D0),a
ld (#D2DF),a
ld (#D2E2),a
ld a,#05
ld (#D0FE),a
ld (#F142),a
ld (#F143),a
ld (#E1ED),a
ld (#C242),a
ld (#D233),a
ld (#F289),a
ld a,#06
ld (#E053),a
ld (#E2D2),a
ld a,#08
ld (#C00F),a
ld (#F00D),a
ld (#C05E),a
ld (#E061),a
ld (#F05E),a
ld (#D0F1),a
ld (#C153),a
ld (#F1A2),a
ld (#F1E2),a
ld (#F23A),a
ld (#C291),a
ld a,#09
ld (#F054),a
ld a,#0A
ld (#C0AF),a
ld (#D0F0),a
ld (#E14F),a
ld (#E151),a
ld (#E19B),a
ld (#F1A1),a
ld (#C232),a
ld (#D236),a
ld (#D23C),a
ld (#E234),a
ld (#F2D3),a
ld a,#10
ld (#D000),a
ld (#D010),a
ld (#E006),a
ld (#E00E),a
ld (#E011),a
ld (#F004),a
ld (#C060),a
ld (#D053),a
ld (#C0B3),a
ld (#E0AE),a
ld (#C0F1),a
ld (#C0F9),a
ld (#E102),a
ld (#D141),a
ld (#E146),a
ld (#C190),a
ld (#C19E),a
ld (#E195),a
ld (#E197),a
ld (#F1A3),a
ld (#C1EB),a
ld (#E1E2),a
ld (#D237),a
ld (#D241),a
ld (#E232),a
ld (#E236),a
ld (#E23C),a
ld (#F240),a
ld (#C293),a
ld (#F2E1),a
ld a,#12
ld (#C23F),a
ld a,#13
ld (#F0F5),a
ld a,#14
ld (#D0A8),a
ld (#D199),a
ld (#D288),a
ld a,#15
ld (#E14B),a
ld (#E19C),a
ld a,#16
ld (#D0B3),a
ld (#F0F8),a
ld a,#18
ld (#C004),a
ld (#F00F),a
ld (#D05C),a
ld (#C0B0),a
ld (#D101),a
ld (#F19B),a
ld (#F19F),a
ld a,#1A
ld (#E003),a
ld (#F007),a
ld (#F009),a
ld (#D063),a
ld (#F05A),a
ld (#D0A1),a
ld (#D0B0),a
ld (#F0B2),a
ld (#D190),a
ld (#D1E0),a
ld (#D1E4),a
ld (#F285),a
ld (#E2DD),a
ld a,#22
ld (#E010),a
ld (#F00C),a
ld (#C054),a
ld (#F19D),a
ld (#C28D),a
ld a,#26
ld (#F14E),a
ld (#F239),a
ld a,#2A
ld (#C0A5),a
ld (#C0B2),a
ld (#C23B),a
ld (#C290),a
ld (#F28A),a
ld (#F2DB),a
ld a,#32
ld (#E05A),a
ld (#F0F6),a
ld a,#3A
ld (#E00A),a
ld (#E0A4),a
ld (#E0AB),a
ld (#F102),a
ld (#E145),a
ld (#F147),a
ld (#E28F),a
ld a,#40
ld (#C006),a
ld (#E00C),a
ld (#F005),a
ld (#F010),a
ld (#C057),a
ld (#E052),a
ld (#E060),a
ld (#D0A5),a
ld (#D0B2),a
ld (#E0A7),a
ld (#F0A7),a
ld (#F0F9),a
ld (#D14F),a
ld (#E199),a
ld (#D1E2),a
ld (#E1E0),a
ld (#D232),a
ld (#E233),a
ld (#E23B),a
ld (#F284),a
ld (#F28F),a
ld (#C2D2),a
ld (#C2D8),a
ld (#D2DE),a
ld (#E2D1),a
ld (#E2D6),a
ld (#E2DF),a
ld a,#41
ld (#D0FD),a
ld (#E0FD),a
ld (#C282),a
ld a,#42
ld (#D004),a
ld (#F003),a
ld (#D0AC),a
ld (#F0B1),a
ld (#D0F8),a
ld (#E140),a
ld (#C287),a
ld (#F282),a
ld a,#44
ld (#F0A5),a
ld (#F1EF),a
ld a,#45
ld (#F197),a
ld (#E2D8),a
ld a,#46
ld (#E0F4),a
ld (#F1E8),a
ld a,#4A
ld (#D1A3),a
ld a,#4C
ld (#F0FD),a
ld a,#50
ld (#C013),a
ld (#D008),a
ld (#D00A),a
ld (#D00B),a
ld (#E007),a
ld (#C050),a
ld (#D05D),a
ld (#D05F),a
ld (#D061),a
ld (#E05C),a
ld (#F060),a
ld (#C0A4),a
ld (#C0A6),a
ld (#C0B1),a
ld (#E0AF),a
ld (#E0B3),a
ld (#D0F2),a
ld (#E103),a
ld (#F0FE),a
ld (#F0FF),a
ld (#F100),a
ld (#C141),a
ld (#C151),a
ld (#D149),a
ld (#D152),a
ld (#E153),a
ld (#F145),a
ld (#C19F),a
ld (#D191),a
ld (#D1A2),a
ld (#E1A3),a
ld (#D1F1),a
ld (#E1F3),a
ld (#F1E3),a
ld (#F1E5),a
ld (#F1E6),a
ld (#C238),a
ld (#D242),a
ld (#E23D),a
ld (#E243),a
ld (#F23E),a
ld (#C284),a
ld (#C286),a
ld (#C28F),a
ld (#D28D),a
ld (#D290),a
ld (#D2D5),a
ld (#D2D6),a
ld (#E2D3),a
ld (#F2DF),a
ld a,#52
ld (#D051),a
ld (#D05B),a
ld (#C0AC),a
ld (#E0A1),a
ld (#E0F0),a
ld (#F101),a
ld (#D1EA),a
ld (#D1F2),a
ld (#D280),a
ld (#C2E0),a
ld a,#55
ld (#F238),a
ld a,#58
ld (#C00C),a
ld (#C055),a
ld (#E058),a
ld (#F05B),a
ld (#C100),a
ld (#F103),a
ld (#F148),a
ld (#F153),a
ld (#F19A),a
ld (#C1E6),a
ld (#E1EC),a
ld (#F1EC),a
ld (#C237),a
ld (#D231),a
ld (#F28E),a
ld (#F2D8),a
ld a,#5A
ld (#C0FF),a
ld (#F14F),a
ld (#D1F3),a
ld (#D243),a
ld (#F286),a
ld a,#62
ld (#D0A2),a
ld (#C1EF),a
ld (#F1EE),a
ld a,#6A
ld (#E0F1),a
ld (#C198),a
ld (#D2D1),a
ld a,#72
ld (#D001),a
ld (#C05B),a
ld (#E1EA),a
ld (#D230),a
ld a,#7A
ld (#E057),a
ld (#C0AD),a
ld (#F0AB),a
ld (#F152),a
ld (#C1E2),a
ld (#C236),a
ld (#E284),a
ld a,#88
ld (#D002),a
ld (#C062),a
ld (#F199),a
ld a,#8A
ld (#D013),a
ld (#D0A7),a
ld (#E0F2),a
ld (#F1A0),a
ld (#D281),a
ld a,#8D
ld (#F19E),a
ld a,#8E
ld (#D19B),a
ld (#D1EC),a
ld a,#98
ld (#D0A3),a
ld (#D2D4),a
ld a,#9B
ld (#F14D),a
ld a,#9D
ld (#F146),a
ld a,#AA
ld (#C147),a
ld (#F2D7),a
ld a,#BA
ld (#F198),a
ld a,#C8
ld (#F0AC),a
ld (#E0FC),a
ld (#E196),a
ld a,#CA
ld (#C0F6),a
ld a,#D8
ld (#D0B1),a
ld (#C14A),a
ld (#E23F),a
ld (#E2E0),a
ld a,#DA
ld (#C00B),a
ld (#F232),a
ld a,#EA
ld (#D052),a
ld a,#FA
ld (#E05B),a
ld (#F0A8),a
ld (#C1E5),a
ret

p16to17
ld a,#00
ld (#C006),a
ld (#E00C),a
ld (#F00E),a
ld (#F011),a
ld (#E05E),a
ld (#F061),a
ld (#C0B0),a
ld (#D0A8),a
ld (#D0AD),a
ld (#E0A3),a
ld (#D0F1),a
ld (#D0FF),a
ld (#F0F1),a
ld (#C153),a
ld (#D14F),a
ld (#D151),a
ld (#D153),a
ld (#E141),a
ld (#E142),a
ld (#E14C),a
ld (#E151),a
ld (#F142),a
ld (#F14C),a
ld (#C19E),a
ld (#E190),a
ld (#F192),a
ld (#C1F2),a
ld (#D1E2),a
ld (#E1E7),a
ld (#F1F2),a
ld (#C232),a
ld (#C23A),a
ld (#C241),a
ld (#C242),a
ld (#D233),a
ld (#E236),a
ld (#C280),a
ld (#C282),a
ld (#C293),a
ld (#E281),a
ld (#C2D0),a
ld (#C2D3),a
ld (#C2D9),a
ld (#D2D8),a
ld (#D2DF),a
ld (#E2D4),a
ld (#E2D7),a
ld a,#01
ld (#D012),a
ld (#E009),a
ld (#F143),a
ld (#C1A3),a
ld (#C1F3),a
ld (#E23E),a
ld (#E286),a
ld (#E28A),a
ld (#E2DB),a
ld (#F2D5),a
ld a,#02
ld (#C000),a
ld (#E05A),a
ld (#D0B3),a
ld (#E0B1),a
ld (#C0FE),a
ld (#F191),a
ld (#C1E9),a
ld (#D236),a
ld (#C28D),a
ld (#F2DA),a
ld a,#03
ld (#D28E),a
ld a,#04
ld (#E005),a
ld (#F054),a
ld (#F05F),a
ld (#D150),a
ld (#F289),a
ld (#E2DC),a
ld a,#05
ld (#E14B),a
ld (#E235),a
ld (#E287),a
ld a,#06
ld (#D0A6),a
ld (#F1E8),a
ld a,#08
ld (#D002),a
ld (#D013),a
ld (#D055),a
ld (#D0A0),a
ld (#C103),a
ld (#D0F0),a
ld (#E0F8),a
ld (#E150),a
ld (#C1F0),a
ld (#E285),a
ld (#F290),a
ld (#F2D3),a
ld a,#09
ld (#F05E),a
ld (#E0F3),a
ld a,#0A
ld (#C00F),a
ld (#D060),a
ld (#E061),a
ld (#C0F7),a
ld (#D101),a
ld (#E0F1),a
ld (#E0F2),a
ld (#F102),a
ld (#E140),a
ld (#C194),a
ld (#D19B),a
ld (#F1A2),a
ld (#D1E4),a
ld (#F1F1),a
ld (#F239),a
ld (#D283),a
ld a,#0B
ld (#D23C),a
ld a,#0C
ld (#F1EF),a
ld a,#0D
ld (#F146),a
ld a,#0E
ld (#D1EC),a
ld a,#0F
ld (#F0AA),a
ld a,#10
ld (#C007),a
ld (#F062),a
ld (#C0A8),a
ld (#D0A1),a
ld (#D0AE),a
ld (#E0AD),a
ld (#E0B2),a
ld (#C140),a
ld (#E152),a
ld (#E192),a
ld (#E19D),a
ld (#F195),a
ld (#F19F),a
ld (#C1E0),a
ld (#E1E4),a
ld (#F242),a
ld (#D28F),a
ld (#E288),a
ld (#C2E2),a
ld a,#11
ld (#F0F5),a
ld (#E19C),a
ld (#E1ED),a
ld a,#12
ld (#D063),a
ld (#D0F7),a
ld (#C1EB),a
ld (#E23C),a
ld (#F2D6),a
ld a,#14
ld (#C0F9),a
ld (#F0F8),a
ld (#D2E3),a
ld a,#15
ld (#E2D8),a
ld a,#16
ld (#E2D9),a
ld a,#18
ld (#C001),a
ld (#C012),a
ld (#D0A3),a
ld (#E0A9),a
ld (#D140),a
ld (#C199),a
ld (#F1A3),a
ld (#D1ED),a
ld (#E1EC),a
ld (#E1EE),a
ld (#F1E2),a
ld (#D237),a
ld (#E282),a
ld (#F287),a
ld (#E2D5),a
ld (#F2D8),a
ld a,#1A
ld (#E00E),a
ld (#F00F),a
ld (#C1E2),a
ld (#D1E5),a
ld (#D281),a
ld (#E284),a
ld a,#1D
ld (#F1E7),a
ld a,#22
ld (#C011),a
ld (#E053),a
ld (#C0B2),a
ld (#C0F8),a
ld (#F1E1),a
ld (#C290),a
ld (#E2D2),a
ld a,#26
ld (#F0A5),a
ld (#E0F4),a
ld (#E19B),a
ld a,#2A
ld (#F008),a
ld (#F285),a
ld a,#2B
ld (#F23F),a
ld a,#32
ld (#F19D),a
ld (#C1EF),a
ld (#E28F),a
ld a,#3A
ld (#F0A8),a
ld (#F0AB),a
ld (#F0F6),a
ld (#F2DE),a
ld a,#40
ld (#E004),a
ld (#C053),a
ld (#C05E),a
ld (#E059),a
ld (#C0A6),a
ld (#D0AC),a
ld (#E0B0),a
ld (#F0A2),a
ld (#F0B1),a
ld (#C102),a
ld (#D0F3),a
ld (#D0F8),a
ld (#E0FD),a
ld (#C152),a
ld (#D14E),a
ld (#F140),a
ld (#F145),a
ld (#C1A1),a
ld (#F190),a
ld (#D1E9),a
ld (#E1E3),a
ld (#C23F),a
ld (#E230),a
ld (#E238),a
ld (#C287),a
ld (#D282),a
ld (#D28C),a
ld (#E289),a
ld (#C2D5),a
ld (#C2E0),a
ld (#D2D7),a
ld (#D2E1),a
ld (#F2D4),a
ld a,#41
ld (#E0A7),a
ld (#F0A4),a
ld (#E1E0),a
ld a,#42
ld (#E010),a
ld (#F05D),a
ld (#D0A2),a
ld (#D0B0),a
ld (#F0A7),a
ld (#D1A3),a
ld (#E233),a
ld a,#43
ld (#F003),a
ld a,#46
ld (#F14E),a
ld (#F197),a
ld a,#4A
ld (#D004),a
ld (#E0F0),a
ld (#F1A0),a
ld (#F282),a
ld a,#50
ld (#C00C),a
ld (#C00D),a
ld (#D005),a
ld (#F000),a
ld (#C055),a
ld (#C061),a
ld (#D053),a
ld (#D05C),a
ld (#F055),a
ld (#D0AF),a
ld (#E0AE),a
ld (#C0F1),a
ld (#D102),a
ld (#F101),a
ld (#D141),a
ld (#C1A0),a
ld (#E193),a
ld (#E194),a
ld (#E195),a
ld (#E19A),a
ld (#C1EA),a
ld (#D1E1),a
ld (#D1F2),a
ld (#E1E2),a
ld (#C234),a
ld (#C237),a
ld (#D240),a
ld (#E232),a
ld (#C281),a
ld (#C289),a
ld (#C2D4),a
ld (#C2D8),a
ld (#C2DA),a
ld (#D2D2),a
ld (#E2D6),a
ld a,#52
ld (#E0A0),a
ld (#C146),a
ld (#C1E1),a
ld (#C235),a
ld (#F231),a
ld (#F234),a
ld (#E283),a
ld (#D2D3),a
ld (#F2D2),a
ld a,#58
ld (#E011),a
ld (#F00A),a
ld (#C058),a
ld (#C05D),a
ld (#D057),a
ld (#D061),a
ld (#E054),a
ld (#C101),a
ld (#E0FC),a
ld (#C14A),a
ld (#C195),a
ld (#C19F),a
ld (#E1A2),a
ld (#F235),a
ld (#E290),a
ld (#C2DF),a
ld (#D2D4),a
ld (#F2DF),a
ld a,#5A
ld (#C00B),a
ld (#F058),a
ld (#C0AE),a
ld (#E0A1),a
ld (#F152),a
ld (#E1A0),a
ld (#E1A1),a
ld (#C1E3),a
ld (#C1E4),a
ld (#D1EA),a
ld (#C236),a
ld a,#6A
ld (#C192),a
ld (#D230),a
ld (#D23B),a
ld (#F2D7),a
ld a,#6B
ld (#C198),a
ld a,#72
ld (#C00A),a
ld (#E0AB),a
ld (#D280),a
ld a,#7A
ld (#E000),a
ld a,#88
ld (#C291),a
ld a,#8A
ld (#F00C),a
ld (#C062),a
ld (#D052),a
ld (#F059),a
ld (#C0F6),a
ld (#C193),a
ld a,#98
ld (#C004),a
ld (#E0F5),a
ld a,#99
ld (#F19E),a
ld a,#9A
ld (#C100),a
ld (#F232),a
ld a,#9E
ld (#C148),a
ld a,#AA
ld (#C0A5),a
ld (#E145),a
ld (#C240),a
ld (#C2E1),a
ld (#F2DB),a
ld a,#AB
ld (#F14D),a
ld (#F196),a
ld a,#BA
ld (#F147),a
ld a,#CA
ld (#F0AC),a
ld (#D2D1),a
ld a,#CD
ld (#F0FD),a
ld a,#D8
ld (#E003),a
ld (#E0A2),a
ld (#F153),a
ld (#C1E6),a
ld (#F1EC),a
ld a,#DA
ld (#C05C),a
ld (#F05B),a
ld (#D0B1),a
ld (#D1E0),a
ld a,#EA
ld (#E0A4),a
ld (#F286),a
ld a,#FA
ld (#C0AD),a
ld (#C0FF),a
ld (#F198),a
ld (#E2E0),a
ret

p17to18
ld a,#00
ld (#E009),a
ld (#F00D),a
ld (#C05F),a
ld (#D055),a
ld (#D060),a
ld (#D0A0),a
ld (#D0B3),a
ld (#E0B1),a
ld (#F0A2),a
ld (#F0B2),a
ld (#D0F0),a
ld (#D0FE),a
ld (#D100),a
ld (#E101),a
ld (#C142),a
ld (#C143),a
ld (#E140),a
ld (#E144),a
ld (#E14F),a
ld (#E150),a
ld (#E152),a
ld (#F140),a
ld (#F143),a
ld (#F144),a
ld (#C1A3),a
ld (#E1E4),a
ld (#F1F3),a
ld (#D232),a
ld (#E231),a
ld (#E238),a
ld (#E23C),a
ld (#F23B),a
ld (#F242),a
ld (#C28B),a
ld (#D287),a
ld (#E286),a
ld (#C2D5),a
ld (#C2DD),a
ld (#F2D5),a
ld (#F2DC),a
ld a,#01
ld (#E00C),a
ld (#F003),a
ld (#F011),a
ld (#F0F5),a
ld (#E19C),a
ld (#D1E2),a
ld (#E1E0),a
ld (#E1ED),a
ld (#E235),a
ld (#F284),a
ld (#D2DF),a
ld (#E2D8),a
ld a,#02
ld (#C003),a
ld (#E002),a
ld (#D0A6),a
ld (#E0A8),a
ld (#C0F8),a
ld (#C153),a
ld (#F19D),a
ld (#D1E4),a
ld (#E1E3),a
ld (#C23A),a
ld (#D28E),a
ld (#F285),a
ld (#C2D0),a
ld a,#04
ld (#E102),a
ld (#F0F3),a
ld (#F146),a
ld (#E190),a
ld (#E19D),a
ld (#C282),a
ld a,#05
ld (#F0F1),a
ld (#F0F2),a
ld (#F0FB),a
ld (#D14F),a
ld (#D150),a
ld (#E236),a
ld (#D2E2),a
ld a,#06
ld (#E00D),a
ld (#D063),a
ld (#F05F),a
ld (#F289),a
ld a,#08
ld (#C060),a
ld (#F05E),a
ld (#F0AF),a
ld (#F141),a
ld (#F1F2),a
ld (#D233),a
ld (#C28C),a
ld (#C2D3),a
ld a,#0A
ld (#D004),a
ld (#F009),a
ld (#F059),a
ld (#F05D),a
ld (#C100),a
ld (#C103),a
ld (#E0F0),a
ld (#C193),a
ld (#E1A0),a
ld (#E1A1),a
ld (#F191),a
ld (#D1E5),a
ld (#D23D),a
ld (#F2D8),a
ld a,#0B
ld (#F196),a
ld a,#0D
ld (#E14B),a
ld a,#0E
ld (#C0F7),a
ld a,#10
ld (#C063),a
ld (#D050),a
ld (#E05A),a
ld (#F060),a
ld (#C0A0),a
ld (#D0A3),a
ld (#F0B0),a
ld (#C0F0),a
ld (#E0FB),a
ld (#D152),a
ld (#D1A1),a
ld (#F19B),a
ld (#E1E5),a
ld (#E1EE),a
ld (#C230),a
ld (#D237),a
ld (#E237),a
ld (#C283),a
ld (#C2D6),a
ld (#C2D9),a
ld (#E2D5),a
ld (#F2D3),a
ld a,#12
ld (#E056),a
ld (#F23C),a
ld (#C290),a
ld (#E28F),a
ld (#F28D),a
ld a,#14
ld (#D010),a
ld (#F062),a
ld (#E288),a
ld (#E2D9),a
ld (#F2E1),a
ld a,#15
ld (#E287),a
ld a,#18
ld (#D002),a
ld (#D057),a
ld (#F0F8),a
ld (#D23E),a
ld (#F232),a
ld (#D281),a
ld (#D28D),a
ld a,#1A
ld (#C007),a
ld (#D0B1),a
ld (#D0F7),a
ld (#E1A2),a
ld (#F1A3),a
ld (#F1E1),a
ld (#F234),a
ld (#E2D2),a
ld a,#1C
ld (#D199),a
ld (#E1EC),a
ld a,#1E
ld (#F0A8),a
ld a,#22
ld (#F0A7),a
ld (#D19B),a
ld (#F1E8),a
ld (#F1EE),a
ld (#F2DA),a
ld a,#23
ld (#F23F),a
ld a,#26
ld (#F197),a
ld a,#2A
ld (#C062),a
ld (#F05A),a
ld (#D0A7),a
ld (#C2E1),a
ld a,#32
ld (#F0A5),a
ld (#E0F4),a
ld (#C1EB),a
ld a,#3A
ld (#C054),a
ld (#D101),a
ld (#F0FC),a
ld (#E2E0),a
ld a,#40
ld (#C00E),a
ld (#D00F),a
ld (#E008),a
ld (#D054),a
ld (#D062),a
ld (#E05D),a
ld (#F053),a
ld (#F0A1),a
ld (#F0F0),a
ld (#C141),a
ld (#C14F),a
ld (#D153),a
ld (#C1A2),a
ld (#D192),a
ld (#D1A0),a
ld (#D1A3),a
ld (#E19F),a
ld (#F194),a
ld (#E1E2),a
ld (#E1EB),a
ld (#C231),a
ld (#F237),a
ld (#D286),a
ld (#F288),a
ld (#E2DA),a
ld (#F2D9),a
ld (#F2E0),a
ld a,#41
ld (#E230),a
ld a,#42
ld (#C011),a
ld (#D056),a
ld (#C0B2),a
ld (#C0FD),a
ld (#C146),a
ld (#C1E1),a
ld (#E283),a
ld (#D2D3),a
ld (#F2D2),a
ld a,#45
ld (#F238),a
ld a,#48
ld (#E0AC),a
ld (#F0FA),a
ld (#E285),a
ld a,#4A
ld (#F008),a
ld (#C23B),a
ld (#C2DE),a
ld (#F2D7),a
ld a,#4C
ld (#F14E),a
ld a,#50
ld (#D009),a
ld (#D011),a
ld (#F010),a
ld (#C053),a
ld (#C057),a
ld (#C05D),a
ld (#D05B),a
ld (#E054),a
ld (#E060),a
ld (#E063),a
ld (#D0A1),a
ld (#D0AE),a
ld (#E0AA),a
ld (#E0AD),a
ld (#E0B0),a
ld (#D0F1),a
ld (#E0FC),a
ld (#C140),a
ld (#C152),a
ld (#D140),a
ld (#E142),a
ld (#F14F),a
ld (#F150),a
ld (#F151),a
ld (#C190),a
ld (#C1A1),a
ld (#E192),a
ld (#F192),a
ld (#F193),a
ld (#F195),a
ld (#C1E0),a
ld (#F1E2),a
ld (#C233),a
ld (#C235),a
ld (#D231),a
ld (#C287),a
ld (#C288),a
ld (#D282),a
ld (#D284),a
ld (#D285),a
ld (#D293),a
ld (#E28E),a
ld (#F283),a
ld (#F28F),a
ld (#C2D1),a
ld (#C2E2),a
ld (#D2D7),a
ld a,#51
ld (#F0A4),a
ld a,#52
ld (#C00A),a
ld (#C051),a
ld (#E050),a
ld (#F057),a
ld (#F058),a
ld (#D0B0),a
ld (#E0AB),a
ld (#C0F5),a
ld (#C191),a
ld (#D1F3),a
ld (#C236),a
ld (#D243),a
ld (#D28C),a
ld a,#58
ld (#C004),a
ld (#C00B),a
ld (#F0B3),a
ld (#D102),a
ld (#D190),a
ld (#C1E6),a
ld (#C1EA),a
ld (#D1E6),a
ld (#D1EA),a
ld (#F1EC),a
ld (#E23F),a
ld (#E282),a
ld a,#5A
ld (#F00A),a
ld (#C058),a
ld (#C05C),a
ld (#E057),a
ld (#F103),a
ld (#C150),a
ld (#D193),a
ld (#F1A0),a
ld (#C1E5),a
ld a,#62
ld (#F00B),a
ld (#D280),a
ld a,#66
ld (#E19B),a
ld a,#6A
ld (#D001),a
ld a,#72
ld (#D051),a
ld (#F231),a
ld a,#7A
ld (#C05B),a
ld (#C0AC),a
ld (#E0A0),a
ld (#E233),a
ld (#F2DE),a
ld a,#88
ld (#C012),a
ld (#E196),a
ld a,#89
ld (#F290),a
ld a,#8A
ld (#C0A5),a
ld (#E0A4),a
ld (#D283),a
ld (#F282),a
ld (#F28A),a
ld (#D2D1),a
ld (#F2DB),a
ld a,#8B
ld (#F19E),a
ld a,#8C
ld (#F1EF),a
ld a,#8D
ld (#F0FD),a
ld a,#98
ld (#C0B3),a
ld (#E0A9),a
ld a,#9A
ld (#D1E0),a
ld a,#9C
ld (#C148),a
ld a,#AA
ld (#F00C),a
ld a,#BA
ld (#C0FE),a
ld (#F0F6),a
ld a,#C8
ld (#E0F8),a
ld (#C1F0),a
ld a,#CA
ld (#F235),a
ld a,#CB
ld (#D23B),a
ld a,#D8
ld (#E011),a
ld (#C195),a
ld (#C28E),a
ld (#E290),a
ld (#C2DF),a
ld a,#DA
ld (#E00E),a
ld (#C0AD),a
ld (#F153),a
ld (#C192),a
ld a,#EA
ld (#F0AC),a
ld (#E145),a
ld (#F14D),a
ld (#F1E9),a
ld (#C240),a
ld (#D230),a
ld a,#FA
ld (#F05B),a
ld (#E0A1),a
ld (#F147),a
ret

p18to19
ld a,#00
ld (#E052),a
ld (#E05D),a
ld (#F05E),a
ld (#C0AF),a
ld (#E0A7),a
ld (#F0A1),a
ld (#F0B0),a
ld (#E102),a
ld (#D150),a
ld (#F141),a
ld (#D192),a
ld (#D1A0),a
ld (#D1A1),a
ld (#E190),a
ld (#F19D),a
ld (#C1F3),a
ld (#D1E4),a
ld (#E1E5),a
ld (#D233),a
ld (#D236),a
ld (#E235),a
ld (#F23A),a
ld (#F243),a
ld (#D291),a
ld (#E283),a
ld (#E289),a
ld (#E28F),a
ld (#F284),a
ld (#F28B),a
ld (#C2D2),a
ld (#E2D1),a
ld (#E2DA),a
ld a,#01
ld (#C0B0),a
ld (#D0B3),a
ld (#F0A4),a
ld (#F0B2),a
ld (#F0F0),a
ld (#F0F2),a
ld (#D14E),a
ld (#E152),a
ld (#F14C),a
ld (#F196),a
ld (#F23B),a
ld (#E287),a
ld a,#02
ld (#C00F),a
ld (#E05E),a
ld (#E061),a
ld (#F05F),a
ld (#E0A3),a
ld (#F0A9),a
ld (#C141),a
ld (#C14F),a
ld (#D151),a
ld (#F190),a
ld (#F1A2),a
ld (#D232),a
ld (#D23C),a
ld (#E239),a
ld (#F23C),a
ld (#C290),a
ld a,#03
ld (#D2DF),a
ld a,#04
ld (#D010),a
ld (#D013),a
ld (#F003),a
ld (#D055),a
ld (#D063),a
ld (#F062),a
ld (#D0A8),a
ld (#F0F1),a
ld (#F0F5),a
ld (#D14F),a
ld (#D1E2),a
ld (#E1E0),a
ld (#C23C),a
ld (#E237),a
ld (#E2D4),a
ld a,#05
ld (#E00C),a
ld (#E1E4),a
ld (#F1E7),a
ld (#E2DB),a
ld a,#06
ld (#F054),a
ld (#F146),a
ld (#D1EC),a
ld a,#07
ld (#E28A),a
ld a,#08
ld (#E0B2),a
ld (#E0F3),a
ld (#F191),a
ld (#C241),a
ld (#E234),a
ld (#E23A),a
ld (#E23C),a
ld (#F2D9),a
ld a,#09
ld (#F0AF),a
ld a,#0A
ld (#D056),a
ld (#E0A8),a
ld (#F0AE),a
ld (#C0FD),a
ld (#C142),a
ld (#C143),a
ld (#D193),a
ld (#E1A2),a
ld (#C1E1),a
ld (#E1E3),a
ld (#F1EA),a
ld (#F1F2),a
ld (#F1F3),a
ld (#F234),a
ld (#C28C),a
ld (#F282),a
ld (#F287),a
ld (#F28A),a
ld (#C2D0),a
ld a,#0B
ld (#F290),a
ld a,#0C
ld (#F14E),a
ld (#F2E1),a
ld a,#0D
ld (#F0AA),a
ld a,#0E
ld (#E1EC),a
ld a,#10
ld (#D002),a
ld (#F012),a
ld (#D061),a
ld (#E056),a
ld (#C0B1),a
ld (#E0AF),a
ld (#D0F0),a
ld (#D0FF),a
ld (#E0FE),a
ld (#E141),a
ld (#E153),a
ld (#C199),a
ld (#D1A2),a
ld (#E191),a
ld (#E193),a
ld (#E1E1),a
ld (#C285),a
ld (#D288),a
ld (#F28D),a
ld (#F291),a
ld (#D2E0),a
ld (#F2DC),a
ld a,#12
ld (#F0A7),a
ld (#C0F8),a
ld (#D101),a
ld (#E1E8),a
ld (#F1EE),a
ld (#C2D6),a
ld a,#14
ld (#D057),a
ld (#E1EE),a
ld a,#15
ld (#F0FB),a
ld a,#18
ld (#F060),a
ld (#C101),a
ld (#E0F5),a
ld (#D152),a
ld (#F148),a
ld (#D1E6),a
ld (#E1E9),a
ld (#F1EC),a
ld (#E231),a
ld (#E23F),a
ld (#F236),a
ld (#F240),a
ld (#C280),a
ld (#D28F),a
ld (#C2D3),a
ld a,#1A
ld (#E006),a
ld (#E0A9),a
ld (#C0FE),a
ld (#E0F1),a
ld (#F103),a
ld (#C194),a
ld (#D194),a
ld (#E233),a
ld a,#22
ld (#C003),a
ld (#E002),a
ld (#D0A6),a
ld (#C1EB),a
ld (#C1EF),a
ld (#E281),a
ld a,#26
ld (#E19B),a
ld a,#2A
ld (#F0AB),a
ld (#C103),a
ld (#E0F4),a
ld (#C240),a
ld (#F2DA),a
ld a,#2B
ld (#C147),a
ld a,#2E
ld (#F05A),a
ld a,#32
ld (#E00A),a
ld (#F197),a
ld a,#3A
ld (#C007),a
ld (#F00B),a
ld (#F00F),a
ld (#F0A5),a
ld (#F153),a
ld (#F1A3),a
ld (#F1E8),a
ld a,#3B
ld (#C198),a
ld a,#40
ld (#E001),a
ld (#E00B),a
ld (#E010),a
ld (#C056),a
ld (#F061),a
ld (#E0B1),a
ld (#F0A0),a
ld (#D0FD),a
ld (#D100),a
ld (#E0F7),a
ld (#F0F7),a
ld (#C146),a
ld (#C14D),a
ld (#C14E),a
ld (#E144),a
ld (#D191),a
ld (#D19F),a
ld (#C1F1),a
ld (#D1E1),a
ld (#E1E6),a
ld (#F1E6),a
ld (#F233),a
ld (#C281),a
ld (#C284),a
ld (#E280),a
ld (#C2DC),a
ld (#D2D8),a
ld (#D2DB),a
ld (#E2D3),a
ld (#E2D7),a
ld a,#41
ld (#C231),a
ld (#E23B),a
ld (#F288),a
ld a,#42
ld (#C000),a
ld (#C0F5),a
ld (#F102),a
ld (#F231),a
ld a,#43
ld (#D0A2),a
ld (#F2D2),a
ld a,#44
ld (#F238),a
ld a,#48
ld (#E0A2),a
ld a,#4A
ld (#E057),a
ld (#C193),a
ld (#F286),a
ld a,#50
ld (#C00B),a
ld (#C00E),a
ld (#D000),a
ld (#F004),a
ld (#F005),a
ld (#C051),a
ld (#C05E),a
ld (#C063),a
ld (#E059),a
ld (#E05A),a
ld (#C0A0),a
ld (#C0AE),a
ld (#D0AD),a
ld (#D0B0),a
ld (#E0AB),a
ld (#E0AC),a
ld (#F0B1),a
ld (#C0F0),a
ld (#C102),a
ld (#D0F8),a
ld (#E0FF),a
ld (#E100),a
ld (#C14A),a
ld (#E143),a
ld (#C19F),a
ld (#C1A2),a
ld (#D1A3),a
ld (#F194),a
ld (#F1A1),a
ld (#C1E3),a
ld (#C1E4),a
ld (#C1EE),a
ld (#D1F3),a
ld (#F1EB),a
ld (#C230),a
ld (#C236),a
ld (#D243),a
ld (#C283),a
ld (#D286),a
ld (#E282),a
ld (#E285),a
ld (#F28E),a
ld (#D2DE),a
ld (#E2E3),a
ld a,#52
ld (#C0A4),a
ld (#F152),a
ld (#E1EA),a
ld (#C23B),a
ld (#D2D0),a
ld a,#58
ld (#C001),a
ld (#C008),a
ld (#C010),a
ld (#E00F),a
ld (#F010),a
ld (#C059),a
ld (#C05C),a
ld (#D0B2),a
ld (#D0F7),a
ld (#E1A3),a
ld (#D1E0),a
ld (#D1ED),a
ld (#F232),a
ld (#C28E),a
ld (#E290),a
ld (#C2D7),a
ld (#C2E2),a
ld a,#5A
ld (#E000),a
ld (#C05B),a
ld (#E050),a
ld (#E05F),a
ld (#C0AD),a
ld (#C0FF),a
ld (#E0F2),a
ld (#C151),a
ld (#C192),a
ld (#E1F1),a
ld (#E1F2),a
ld (#C2DE),a
ld a,#62
ld (#F05C),a
ld (#D14A),a
ld (#F23F),a
ld (#D28E),a
ld a,#6A
ld (#D280),a
ld a,#7A
ld (#E05B),a
ld (#F057),a
ld (#F058),a
ld (#C191),a
ld (#D28C),a
ld a,#88
ld (#C0A5),a
ld (#C0B3),a
ld (#C0F6),a
ld (#F1EF),a
ld (#D28D),a
ld a,#89
ld (#F199),a
ld a,#8A
ld (#F00C),a
ld (#C054),a
ld (#F05D),a
ld (#E1A0),a
ld (#D230),a
ld (#F2D8),a
ld a,#8C
ld (#D052),a
ld (#E14B),a
ld a,#8E
ld (#C0F7),a
ld a,#98
ld (#E0A4),a
ld (#C148),a
ld (#D283),a
ld a,#9A
ld (#C012),a
ld (#C291),a
ld (#E2D2),a
ld a,#9B
ld (#F0FD),a
ld a,#9C
ld (#D199),a
ld a,#AA
ld (#E053),a
ld (#F14D),a
ld a,#BA
ld (#F00A),a
ld (#E0A0),a
ld a,#CA
ld (#F1E9),a
ld a,#D8
ld (#E058),a
ld (#D102),a
ld (#E0F8),a
ld (#C1F0),a
ld (#D1EA),a
ld a,#DA
ld (#E011),a
ld (#E051),a
ld (#E0A1),a
ld (#F1E1),a
ld a,#EA
ld (#F235),a
ld a,#EB
ld (#D001),a
ld (#F19E),a
ld a,#FA
ld (#C0AC),a
ld (#F0F6),a
ld (#C150),a
ret

p19to20
ld a,#00
ld (#D00C),a
ld (#E004),a
ld (#E00B),a
ld (#C056),a
ld (#D055),a
ld (#D057),a
ld (#E055),a
ld (#E056),a
ld (#F051),a
ld (#F05F),a
ld (#F062),a
ld (#C0B0),a
ld (#D0A5),a
ld (#E0AE),a
ld (#E0AF),a
ld (#F0A4),a
ld (#F0B2),a
ld (#C0F2),a
ld (#C101),a
ld (#F0F0),a
ld (#F0F1),a
ld (#F0F2),a
ld (#F0F3),a
ld (#D14F),a
ld (#D151),a
ld (#E152),a
ld (#D1A2),a
ld (#E192),a
ld (#E193),a
ld (#E1A2),a
ld (#F196),a
ld (#C1E1),a
ld (#D1E1),a
ld (#E1E0),a
ld (#E1E6),a
ld (#C231),a
ld (#E230),a
ld (#F233),a
ld (#C282),a
ld (#C284),a
ld (#C290),a
ld (#E287),a
ld (#F293),a
ld (#D2DB),a
ld (#E2D8),a
ld (#E2DC),a
ld a,#01
ld (#D010),a
ld (#F0A0),a
ld (#D0F9),a
ld (#D191),a
ld (#D19F),a
ld (#E1E4),a
ld (#E236),a
ld (#E28F),a
ld (#F288),a
ld (#D2E2),a
ld (#E2DA),a
ld (#F2D2),a
ld a,#02
ld (#E00D),a
ld (#C062),a
ld (#E057),a
ld (#F05A),a
ld (#C103),a
ld (#E0F0),a
ld (#E102),a
ld (#F0F5),a
ld (#C14E),a
ld (#F140),a
ld (#D193),a
ld (#C1EB),a
ld (#D1EC),a
ld (#E1ED),a
ld (#F1EE),a
ld (#F234),a
ld (#C28B),a
ld (#F289),a
ld (#C2D6),a
ld (#D2DF),a
ld a,#03
ld (#C0A6),a
ld a,#04
ld (#D004),a
ld (#C0A7),a
ld (#F0A9),a
ld (#F0B0),a
ld (#E1E7),a
ld (#E1EE),a
ld (#F1E7),a
ld (#F238),a
ld (#E288),a
ld (#F28C),a
ld (#E2D9),a
ld a,#05
ld (#D063),a
ld (#E05D),a
ld (#D0A8),a
ld (#F0A1),a
ld (#F0A2),a
ld (#D1A0),a
ld (#D1A1),a
ld (#E1E5),a
ld a,#06
ld (#E05E),a
ld (#E0FA),a
ld (#C1E9),a
ld (#C1EF),a
ld a,#08
ld (#C0A5),a
ld (#F100),a
ld (#D1E2),a
ld (#F1EA),a
ld (#E23B),a
ld (#F282),a
ld (#F28A),a
ld (#D2D1),a
ld (#F2DB),a
ld a,#0A
ld (#F00C),a
ld (#C060),a
ld (#C0B3),a
ld (#D0B1),a
ld (#E0B2),a
ld (#C0F6),a
ld (#C14F),a
ld (#D152),a
ld (#F153),a
ld (#E1A0),a
ld (#D230),a
ld (#D232),a
ld (#F236),a
ld (#F23C),a
ld (#D28D),a
ld (#D2D3),a
ld (#F2D8),a
ld (#F2D9),a
ld a,#0B
ld (#F287),a
ld a,#0C
ld (#D052),a
ld (#E19C),a
ld a,#0D
ld (#E2DB),a
ld a,#0E
ld (#D23D),a
ld a,#0F
ld (#E28A),a
ld a,#10
ld (#F00E),a
ld (#C057),a
ld (#D0A0),a
ld (#F0A8),a
ld (#F0B1),a
ld (#F0B3),a
ld (#E0F5),a
ld (#E103),a
ld (#F144),a
ld (#C1A1),a
ld (#D19C),a
ld (#E194),a
ld (#E1A3),a
ld (#C1E2),a
ld (#D233),a
ld (#E23F),a
ld (#D281),a
ld (#E28D),a
ld (#D2E3),a
ld (#E2DD),a
ld (#F2D6),a
ld a,#11
ld (#F14C),a
ld a,#12
ld (#E00A),a
ld (#C285),a
ld (#C2E1),a
ld (#E2E0),a
ld a,#14
ld (#F012),a
ld (#D061),a
ld (#E153),a
ld (#C23C),a
ld a,#18
ld (#F191),a
ld (#F1E5),a
ld (#E23A),a
ld (#F239),a
ld (#E284),a
ld a,#1A
ld (#C007),a
ld (#F060),a
ld (#F0A7),a
ld (#C191),a
ld (#C2DE),a
ld a,#22
ld (#E0A3),a
ld (#F190),a
ld (#C240),a
ld (#F23F),a
ld (#F290),a
ld a,#23
ld (#E19B),a
ld a,#26
ld (#E1EC),a
ld a,#2A
ld (#F00A),a
ld (#C0FD),a
ld (#E239),a
ld a,#2E
ld (#F0AB),a
ld a,#32
ld (#E002),a
ld (#F054),a
ld (#F146),a
ld (#E281),a
ld a,#36
ld (#F0FC),a
ld a,#3A
ld (#C003),a
ld (#E006),a
ld (#F14D),a
ld (#F197),a
ld (#E1E8),a
ld a,#40
ld (#C011),a
ld (#D003),a
ld (#E013),a
ld (#F002),a
ld (#C05F),a
ld (#E05C),a
ld (#F056),a
ld (#C0AF),a
ld (#C0F1),a
ld (#D0F7),a
ld (#D103),a
ld (#E0F3),a
ld (#E101),a
ld (#F0F4),a
ld (#F102),a
ld (#C153),a
ld (#C1A0),a
ld (#C1A3),a
ld (#D235),a
ld (#D287),a
ld (#D291),a
ld (#E286),a
ld (#E28C),a
ld (#F283),a
ld (#F28B),a
ld (#C2D4),a
ld a,#41
ld (#D054),a
ld (#F053),a
ld (#C19E),a
ld (#D1EB),a
ld (#F23A),a
ld a,#42
ld (#C00F),a
ld (#E061),a
ld (#D101),a
ld (#D19B),a
ld (#E195),a
ld (#E1E2),a
ld (#D23C),a
ld (#F281),a
ld a,#48
ld (#E234),a
ld a,#4A
ld (#F1E4),a
ld (#F231),a
ld (#F235),a
ld a,#50
ld (#C004),a
ld (#C00A),a
ld (#E008),a
ld (#C05C),a
ld (#C0B2),a
ld (#D0AC),a
ld (#D0F0),a
ld (#D0FF),a
ld (#D100),a
ld (#E0F2),a
ld (#E0FB),a
ld (#E0FD),a
ld (#E0FE),a
ld (#C149),a
ld (#D153),a
ld (#E141),a
ld (#E144),a
ld (#F152),a
ld (#C199),a
ld (#D190),a
ld (#E191),a
ld (#E199),a
ld (#F1A0),a
ld (#F1A2),a
ld (#C1E6),a
ld (#C1F1),a
ld (#C1F2),a
ld (#E1E1),a
ld (#E1EB),a
ld (#D234),a
ld (#C2D9),a
ld (#D2D4),a
ld (#D2D8),a
ld (#E2D5),a
ld (#E2D7),a
ld (#E2DF),a
ld (#F2DC),a
ld a,#52
ld (#C05B),a
ld (#E05B),a
ld (#C0A9),a
ld (#F0AD),a
ld (#C0F8),a
ld (#F0FF),a
ld (#D142),a
ld (#C190),a
ld (#E197),a
ld (#C1E5),a
ld (#F1E0),a
ld (#F1E3),a
ld (#E232),a
ld (#F2D7),a
ld a,#53
ld (#D0A2),a
ld a,#58
ld (#D00D),a
ld (#E003),a
ld (#E007),a
ld (#E062),a
ld (#C0AA),a
ld (#C0AD),a
ld (#D0FA),a
ld (#E0F1),a
ld (#C144),a
ld (#C152),a
ld (#D14B),a
ld (#C195),a
ld (#D1EA),a
ld (#E23D),a
ld (#F23D),a
ld (#D283),a
ld (#C2D3),a
ld (#E2E1),a
ld a,#5A
ld (#E00E),a
ld (#F058),a
ld (#E0A0),a
ld (#E0A1),a
ld (#C0FE),a
ld (#C193),a
ld (#C194),a
ld (#F1A3),a
ld (#E1F3),a
ld (#F1EC),a
ld a,#62
ld (#D051),a
ld (#D2D0),a
ld a,#6A
ld (#C141),a
ld a,#72
ld (#C000),a
ld (#D282),a
ld a,#7A
ld (#E011),a
ld (#F007),a
ld (#F00F),a
ld (#C058),a
ld (#F05C),a
ld (#C150),a
ld a,#88
ld (#E0A8),a
ld (#C241),a
ld (#F240),a
ld (#F2E1),a
ld a,#8A
ld (#E053),a
ld (#F0AE),a
ld (#F1EF),a
ld (#C28C),a
ld a,#8B
ld (#D001),a
ld (#F0FD),a
ld (#E145),a
ld a,#8C
ld (#F14E),a
ld (#E196),a
ld a,#98
ld (#D199),a
ld a,#9A
ld (#E058),a
ld (#C151),a
ld (#E1F2),a
ld (#F1E1),a
ld (#C2D0),a
ld a,#9E
ld (#C0F7),a
ld a,#AA
ld (#E0F4),a
ld (#D194),a
ld a,#BA
ld (#F05B),a
ld (#F0A5),a
ld (#C291),a
ld a,#C8
ld (#F0FA),a
ld (#F199),a
ld (#D23B),a
ld a,#CA
ld (#D280),a
ld a,#D8
ld (#C063),a
ld (#D195),a
ld (#C2E2),a
ld (#E2D2),a
ld a,#DA
ld (#C008),a
ld (#C059),a
ld (#E05F),a
ld (#C0AC),a
ld (#D102),a
ld (#D28C),a
ld (#C2D7),a
ld a,#EA
ld (#F198),a
ld (#F19E),a
ld (#E1F1),a
ld a,#FA
ld (#C012),a
ld (#F00B),a
ld (#E050),a
ret

p20to21
ld a,#00
ld (#D05D),a
ld (#F050),a
ld (#D0B1),a
ld (#D0B3),a
ld (#F0A1),a
ld (#F0A2),a
ld (#F0AF),a
ld (#C0F0),a
ld (#C0F1),a
ld (#C0F9),a
ld (#C100),a
ld (#D0F3),a
ld (#E102),a
ld (#F103),a
ld (#D14E),a
ld (#D1A1),a
ld (#E1A3),a
ld (#D1EC),a
ld (#D1F1),a
ld (#D1F2),a
ld (#E1E4),a
ld (#F1E7),a
ld (#F1F1),a
ld (#F1F2),a
ld (#E236),a
ld (#F237),a
ld (#F238),a
ld (#F23B),a
ld (#C28D),a
ld (#D28A),a
ld (#E28C),a
ld (#C2DC),a
ld (#D2D1),a
ld (#E2D4),a
ld (#E2D9),a
ld (#E2E0),a
ld a,#01
ld (#D054),a
ld (#D063),a
ld (#E05C),a
ld (#F053),a
ld (#F062),a
ld (#E0AE),a
ld (#C101),a
ld (#F19D),a
ld (#F233),a
ld (#F23A),a
ld (#C290),a
ld (#F2D5),a
ld a,#02
ld (#C056),a
ld (#C060),a
ld (#D055),a
ld (#E052),a
ld (#E05E),a
ld (#C0A6),a
ld (#E0AF),a
ld (#F0B0),a
ld (#C0F6),a
ld (#D141),a
ld (#D1A2),a
ld (#E192),a
ld (#E195),a
ld (#D1E1),a
ld (#D1E5),a
ld (#F1F3),a
ld (#E289),a
ld (#C2E1),a
ld (#E2D1),a
ld (#E2DA),a
ld a,#03
ld (#E00B),a
ld (#C23A),a
ld (#F2D8),a
ld a,#04
ld (#E00C),a
ld (#D052),a
ld (#D057),a
ld (#D061),a
ld (#E153),a
ld (#E194),a
ld (#C231),a
ld (#E238),a
ld (#E283),a
ld (#F284),a
ld (#E2DB),a
ld (#F2D2),a
ld a,#05
ld (#D013),a
ld (#F0A0),a
ld (#E193),a
ld (#C1EF),a
ld (#E1E6),a
ld (#E237),a
ld (#F288),a
ld a,#06
ld (#E005),a
ld (#F003),a
ld (#E057),a
ld (#F05A),a
ld (#F0AB),a
ld (#F0FC),a
ld (#C285),a
ld (#F2D9),a
ld a,#08
ld (#C0B1),a
ld (#E0A7),a
ld (#F0F0),a
ld (#E1A1),a
ld (#E1E3),a
ld (#F23C),a
ld (#C282),a
ld a,#09
ld (#F009),a
ld (#F0AA),a
ld (#F100),a
ld (#C2DD),a
ld a,#0A
ld (#F05D),a
ld (#E0A9),a
ld (#E0FA),a
ld (#F0FF),a
ld (#C14E),a
ld (#C151),a
ld (#D142),a
ld (#F140),a
ld (#C1A0),a
ld (#F1E3),a
ld (#F1E5),a
ld (#F231),a
ld (#F243),a
ld (#F2E1),a
ld a,#0B
ld (#F236),a
ld (#E28A),a
ld a,#0C
ld (#E19D),a
ld a,#0D
ld (#D0A8),a
ld a,#10
ld (#C0FB),a
ld (#D0FE),a
ld (#E0F0),a
ld (#F101),a
ld (#E140),a
ld (#D1A3),a
ld (#F1F0),a
ld (#C232),a
ld (#C234),a
ld (#C23C),a
ld (#E284),a
ld (#E290),a
ld (#F282),a
ld (#F285),a
ld (#E2D5),a
ld a,#12
ld (#D0A6),a
ld (#F23F),a
ld (#D28E),a
ld a,#14
ld (#F0B3),a
ld (#E23F),a
ld (#D2E3),a
ld a,#16
ld (#C240),a
ld a,#18
ld (#E00F),a
ld (#E0A4),a
ld (#E0A8),a
ld (#F0B1),a
ld (#E103),a
ld (#C148),a
ld (#F19F),a
ld (#F1E1),a
ld (#D230),a
ld (#E23D),a
ld (#D292),a
ld (#D2E0),a
ld (#F2DF),a
ld a,#1A
ld (#E058),a
ld (#F054),a
ld (#F057),a
ld (#C0AA),a
ld (#D102),a
ld (#E1F3),a
ld (#F1E8),a
ld (#E281),a
ld a,#22
ld (#F0F5),a
ld (#E1EC),a
ld (#C2D2),a
ld a,#2A
ld (#C007),a
ld (#E002),a
ld (#C0B3),a
ld (#F19E),a
ld a,#33
ld (#E19B),a
ld a,#36
ld (#F14D),a
ld a,#3A
ld (#C012),a
ld (#E011),a
ld (#F060),a
ld (#D152),a
ld (#D194),a
ld (#F2DE),a
ld a,#40
ld (#D012),a
ld (#E009),a
ld (#F011),a
ld (#D060),a
ld (#E0AD),a
ld (#C0FA),a
ld (#D0F9),a
ld (#E151),a
ld (#C19F),a
ld (#D19B),a
ld (#E191),a
ld (#F19B),a
ld (#C1E0),a
ld (#C1F3),a
ld (#D1F0),a
ld (#F1E2),a
ld (#F1EE),a
ld (#D236),a
ld (#C283),a
ld (#D2DA),a
ld a,#41
ld (#D0A2),a
ld (#F0F7),a
ld (#E23E),a
ld (#E2D3),a
ld a,#42
ld (#E00A),a
ld (#F00F),a
ld (#F056),a
ld (#C0A9),a
ld (#C103),a
ld (#C190),a
ld (#C1EB),a
ld (#E232),a
ld (#D282),a
ld a,#43
ld (#F281),a
ld a,#48
ld (#F00C),a
ld (#F0FA),a
ld (#D23B),a
ld a,#4A
ld (#D0A7),a
ld (#F153),a
ld (#F190),a
ld (#F1E9),a
ld a,#4C
ld (#E196),a
ld a,#50
ld (#C001),a
ld (#D00F),a
ld (#E003),a
ld (#F006),a
ld (#F00D),a
ld (#F00E),a
ld (#C05B),a
ld (#D062),a
ld (#E05B),a
ld (#F061),a
ld (#C0AD),a
ld (#C0AF),a
ld (#D0A0),a
ld (#E0B1),a
ld (#C0F8),a
ld (#C0FF),a
ld (#E0F1),a
ld (#E101),a
ld (#C14D),a
ld (#E146),a
ld (#E14F),a
ld (#E150),a
ld (#F141),a
ld (#F142),a
ld (#F143),a
ld (#F144),a
ld (#C193),a
ld (#C1A3),a
ld (#F191),a
ld (#F19A),a
ld (#C1E2),a
ld (#C1E5),a
ld (#C23B),a
ld (#D233),a
ld (#D235),a
ld (#D241),a
ld (#E234),a
ld (#F232),a
ld (#F239),a
ld (#C280),a
ld (#D281),a
ld (#D287),a
ld (#E286),a
ld (#F28A),a
ld (#C2E0),a
ld (#D2D9),a
ld (#D2E1),a
ld (#F2D7),a
ld (#F2E0),a
ld a,#52
ld (#D000),a
ld (#D101),a
ld (#C140),a
ld (#C14A),a
ld (#E144),a
ld (#C194),a
ld (#F1A3),a
ld (#D23A),a
ld (#F286),a
ld a,#58
ld (#C009),a
ld (#F008),a
ld (#C05A),a
ld (#E060),a
ld (#E0B0),a
ld (#E0F8),a
ld (#D144),a
ld (#D153),a
ld (#C1A2),a
ld (#E1EA),a
ld (#E231),a
ld (#F2DB),a
ld a,#5A
ld (#C058),a
ld (#D05E),a
ld (#E051),a
ld (#E05F),a
ld (#C0AC),a
ld (#C150),a
ld (#D143),a
ld (#E197),a
ld (#E242),a
ld (#C286),a
ld (#C28E),a
ld a,#62
ld (#C0A4),a
ld (#F1E0),a
ld (#D23C),a
ld (#F290),a
ld a,#63
ld (#D051),a
ld a,#72
ld (#F1EC),a
ld a,#7A
ld (#F0AD),a
ld (#E1E2),a
ld (#C291),a
ld a,#88
ld (#C0A8),a
ld (#F14E),a
ld (#D280),a
ld a,#8A
ld (#D056),a
ld (#C0FD),a
ld (#E1F2),a
ld (#D232),a
ld a,#8C
ld (#E19C),a
ld a,#8D
ld (#D001),a
ld (#E145),a
ld a,#98
ld (#C054),a
ld (#F0A7),a
ld (#C0F7),a
ld (#E1E9),a
ld (#D28F),a
ld (#C2D0),a
ld a,#9A
ld (#C003),a
ld (#C059),a
ld (#F0F6),a
ld (#C1A1),a
ld (#D23E),a
ld (#F2DA),a
ld a,#AA
ld (#F1EF),a
ld (#E239),a
ld a,#BA
ld (#F147),a
ld a,#CA
ld (#C141),a
ld (#C28C),a
ld (#D28C),a
ld a,#CB
ld (#E0F4),a
ld a,#D8
ld (#C010),a
ld (#E062),a
ld (#D14B),a
ld (#C1EA),a
ld (#C241),a
ld a,#DA
ld (#E000),a
ld (#F058),a
ld (#F0A5),a
ld (#C2DF),a
ld a,#EA
ld (#F0FD),a
ld (#F1E4),a
ld a,#FA
ld (#C008),a
ld (#F05C),a
ld (#E1E8),a
ld (#E1F1),a
ret

p21to22
ld a,#00
ld (#D004),a
ld (#E00C),a
ld (#F009),a
ld (#D061),a
ld (#E057),a
ld (#F053),a
ld (#F05A),a
ld (#C0A5),a
ld (#D0A8),a
ld (#E0AD),a
ld (#F0A0),a
ld (#F0B0),a
ld (#F0B3),a
ld (#E0FF),a
ld (#E100),a
ld (#F0F0),a
ld (#C146),a
ld (#D141),a
ld (#E142),a
ld (#E143),a
ld (#E153),a
ld (#C19F),a
ld (#D193),a
ld (#D1A0),a
ld (#D1E2),a
ld (#D1E9),a
ld (#F1E6),a
ld (#F1F3),a
ld (#C231),a
ld (#C233),a
ld (#C23C),a
ld (#E232),a
ld (#F233),a
ld (#C281),a
ld (#E280),a
ld (#E28B),a
ld (#F28C),a
ld (#E2D3),a
ld (#F2D5),a
ld a,#01
ld (#C0F5),a
ld (#F103),a
ld (#E193),a
ld (#E1A3),a
ld (#D1F0),a
ld (#E1E5),a
ld (#C284),a
ld (#E288),a
ld (#F287),a
ld (#C2D5),a
ld (#E2E0),a
ld (#F2D8),a
ld a,#02
ld (#D00C),a
ld (#D010),a
ld (#E005),a
ld (#F003),a
ld (#D05D),a
ld (#F056),a
ld (#E0B2),a
ld (#F0A4),a
ld (#C0F0),a
ld (#C143),a
ld (#F1E3),a
ld (#C234),a
ld (#E238),a
ld (#F243),a
ld (#C285),a
ld (#E28D),a
ld (#C2DC),a
ld (#C2DE),a
ld (#D2E2),a
ld a,#03
ld (#E05C),a
ld (#C0F6),a
ld (#F0F7),a
ld (#E195),a
ld a,#04
ld (#E05D),a
ld (#F050),a
ld (#F101),a
ld (#D191),a
ld (#E23F),a
ld (#F237),a
ld (#E28C),a
ld (#F288),a
ld (#F293),a
ld (#D2D3),a
ld a,#05
ld (#E0AE),a
ld (#E194),a
ld (#D1F1),a
ld (#D1F2),a
ld a,#06
ld (#F14D),a
ld (#E1E7),a
ld (#D23D),a
ld (#E289),a
ld a,#08
ld (#C057),a
ld (#C0AA),a
ld (#E103),a
ld (#C142),a
ld (#D1A3),a
ld (#E19D),a
ld (#F194),a
ld (#D1EC),a
ld (#E1E0),a
ld (#E1E9),a
ld (#F231),a
ld (#C2DD),a
ld a,#09
ld (#D057),a
ld a,#0A
ld (#E006),a
ld (#D0A6),a
ld (#C0F1),a
ld (#C0F2),a
ld (#C190),a
ld (#E1F2),a
ld (#E1F3),a
ld (#F1E9),a
ld (#F2D6),a
ld a,#0B
ld (#C23A),a
ld (#D28D),a
ld (#D2D0),a
ld a,#0C
ld (#D001),a
ld (#E1EE),a
ld (#D280),a
ld (#F284),a
ld (#E2DB),a
ld a,#0D
ld (#D013),a
ld a,#0E
ld (#C0A6),a
ld (#C1E9),a
ld a,#10
ld (#C00E),a
ld (#D011),a
ld (#D052),a
ld (#F05F),a
ld (#F063),a
ld (#D0A9),a
ld (#D0AE),a
ld (#D0B2),a
ld (#E0A4),a
ld (#C102),a
ld (#D0F3),a
ld (#C152),a
ld (#D150),a
ld (#E14C),a
ld (#E190),a
ld (#D1F3),a
ld (#F289),a
ld (#D2D1),a
ld (#D2D7),a
ld (#F2E2),a
ld a,#11
ld (#C1EF),a
ld a,#12
ld (#E011),a
ld (#D152),a
ld (#C28B),a
ld a,#15
ld (#E1E6),a
ld a,#18
ld (#D006),a
ld (#C054),a
ld (#E060),a
ld (#E0A7),a
ld (#C0F7),a
ld (#F140),a
ld (#F151),a
ld (#D1ED),a
ld (#E233),a
ld (#F23D),a
ld (#C282),a
ld (#F291),a
ld a,#1A
ld (#C14F),a
ld (#D194),a
ld (#E1E2),a
ld (#D28E),a
ld (#F28D),a
ld (#F2DA),a
ld (#F2DE),a
ld a,#1C
ld (#E23D),a
ld a,#22
ld (#F19E),a
ld (#E230),a
ld (#F290),a
ld (#E2D1),a
ld a,#23
ld (#E1EC),a
ld a,#2A
ld (#E05F),a
ld (#E0A9),a
ld (#E0FA),a
ld (#F2E1),a
ld a,#32
ld (#C0B3),a
ld (#F0F5),a
ld a,#3A
ld (#F00A),a
ld (#F05B),a
ld (#F146),a
ld (#C291),a
ld a,#40
ld (#C006),a
ld (#D00B),a
ld (#E00A),a
ld (#C055),a
ld (#D05C),a
ld (#E055),a
ld (#E05B),a
ld (#E061),a
ld (#C0A1),a
ld (#D0B3),a
ld (#F0A6),a
ld (#F0B2),a
ld (#C100),a
ld (#C103),a
ld (#E102),a
ld (#D140),a
ld (#E141),a
ld (#D190),a
ld (#D198),a
ld (#E1A1),a
ld (#F196),a
ld (#C1EB),a
ld (#C1F1),a
ld (#F1EA),a
ld (#F1F2),a
ld (#C230),a
ld (#C243),a
ld (#E235),a
ld (#F232),a
ld (#D285),a
ld (#D289),a
ld (#E282),a
ld (#E287),a
ld (#D2D2),a
ld (#D2D6),a
ld (#E2D8),a
ld (#F2DC),a
ld a,#41
ld (#D003),a
ld (#F002),a
ld (#E0F9),a
ld (#C1E0),a
ld (#C290),a
ld (#F281),a
ld a,#42
ld (#D000),a
ld (#D005),a
ld (#C0A4),a
ld (#D0F7),a
ld (#F153),a
ld (#D1E5),a
ld (#F1E0),a
ld (#E23E),a
ld (#F23F),a
ld (#D2DF),a
ld a,#43
ld (#D051),a
ld a,#44
ld (#E196),a
ld a,#46
ld (#F0FC),a
ld (#C240),a
ld a,#48
ld (#F05D),a
ld (#E23C),a
ld a,#4A
ld (#F193),a
ld (#F1E4),a
ld (#D282),a
ld a,#4D
ld (#E145),a
ld a,#50
ld (#D002),a
ld (#E009),a
ld (#E013),a
ld (#F00C),a
ld (#C05F),a
ld (#D050),a
ld (#F05E),a
ld (#D0A3),a
ld (#E0A1),a
ld (#E0A2),a
ld (#C0FE),a
ld (#D0F6),a
ld (#D0FE),a
ld (#D101),a
ld (#F0F8),a
ld (#F102),a
ld (#C148),a
ld (#C153),a
ld (#D151),a
ld (#E14E),a
ld (#E151),a
ld (#C192),a
ld (#C194),a
ld (#D19C),a
ld (#E19F),a
ld (#C1F3),a
ld (#D1E0),a
ld (#D1E3),a
ld (#D1E4),a
ld (#F1F1),a
ld (#C232),a
ld (#C242),a
ld (#D236),a
ld (#E231),a
ld (#D288),a
ld (#E284),a
ld (#F286),a
ld (#C2D3),a
ld (#F2D3),a
ld (#F2DB),a
ld a,#52
ld (#F000),a
ld (#F006),a
ld (#C058),a
ld (#F0FE),a
ld (#C14D),a
ld (#F150),a
ld (#F192),a
ld (#F1E8),a
ld (#D231),a
ld (#D28B),a
ld a,#58
ld (#C013),a
ld (#C061),a
ld (#E051),a
ld (#F061),a
ld (#C0AB),a
ld (#C0AC),a
ld (#D0AF),a
ld (#E0B3),a
ld (#C0F3),a
ld (#D103),a
ld (#E1A0),a
ld (#C1EA),a
ld (#C1F0),a
ld (#F1E1),a
ld (#C235),a
ld (#C2D8),a
ld (#D2DE),a
ld (#E2D2),a
ld a,#5A
ld (#F007),a
ld (#E050),a
ld (#C0FD),a
ld (#C141),a
ld (#E1F1),a
ld (#D23E),a
ld (#E243),a
ld (#F235),a
ld (#D2DD),a
ld a,#62
ld (#E052),a
ld (#C14A),a
ld (#F1EC),a
ld (#D23A),a
ld a,#6A
ld (#F1EF),a
ld a,#72
ld (#C053),a
ld (#E144),a
ld a,#7A
ld (#C140),a
ld (#C1A1),a
ld (#F197),a
ld a,#88
ld (#F012),a
ld (#F059),a
ld (#C28C),a
ld a,#89
ld (#C0A8),a
ld a,#8A
ld (#E002),a
ld (#C059),a
ld (#F0FF),a
ld (#F14E),a
ld (#E192),a
ld (#F240),a
ld (#D28C),a
ld (#E28A),a
ld a,#8B
ld (#E0F4),a
ld a,#8F
ld (#E14B),a
ld a,#98
ld (#E053),a
ld (#D0FA),a
ld (#F19F),a
ld (#D232),a
ld (#D2E0),a
ld a,#9A
ld (#E058),a
ld (#F054),a
ld (#F057),a
ld (#F147),a
ld (#D28F),a
ld (#E281),a
ld a,#AA
ld (#E0A3),a
ld a,#AF
ld (#C198),a
ld a,#BA
ld (#F0AC),a
ld (#D143),a
ld (#C286),a
ld a,#C8
ld (#F058),a
ld a,#D8
ld (#E007),a
ld (#F0A5),a
ld (#D144),a
ld (#D153),a
ld (#C2D0),a
ld a,#DA
ld (#F00B),a
ld (#C063),a
ld (#E062),a
ld (#E0B0),a
ld (#C1A2),a
ld (#E197),a
ld (#F190),a
ld a,#EA
ld (#C008),a
ld a,#FA
ld (#F0AD),a
ld (#E242),a
ld (#C2D7),a
ret

p22to23
ld a,#00
ld (#C00E),a
ld (#C056),a
ld (#D054),a
ld (#D05C),a
ld (#E05D),a
ld (#F050),a
ld (#F062),a
ld (#C0A0),a
ld (#C0A1),a
ld (#C0A7),a
ld (#D0A2),a
ld (#C0FB),a
ld (#C101),a
ld (#F100),a
ld (#F103),a
ld (#C143),a
ld (#C14C),a
ld (#C152),a
ld (#E141),a
ld (#C190),a
ld (#D190),a
ld (#D19F),a
ld (#D1A2),a
ld (#E193),a
ld (#E1A3),a
ld (#C1E0),a
ld (#D1F3),a
ld (#E1E5),a
ld (#D241),a
ld (#D242),a
ld (#F231),a
ld (#F234),a
ld (#F236),a
ld (#F23A),a
ld (#F243),a
ld (#D285),a
ld (#D289),a
ld (#E283),a
ld (#C2D5),a
ld (#D2DA),a
ld (#E2DD),a
ld a,#01
ld (#D003),a
ld (#D00B),a
ld (#D061),a
ld (#F0B3),a
ld (#D140),a
ld (#F14C),a
ld (#E194),a
ld (#D1F1),a
ld (#F1E2),a
ld (#F281),a
ld (#F28B),a
ld (#C2E1),a
ld (#E2D9),a
ld a,#02
ld (#E011),a
ld (#D063),a
ld (#C0B1),a
ld (#D0AE),a
ld (#E100),a
ld (#D142),a
ld (#E153),a
ld (#C19F),a
ld (#F192),a
ld (#C1F1),a
ld (#F1E9),a
ld (#D23D),a
ld (#C281),a
ld a,#03
ld (#C0A4),a
ld (#E0AD),a
ld a,#04
ld (#D00C),a
ld (#E0AE),a
ld (#F0AB),a
ld (#E143),a
ld (#F23B),a
ld (#C28D),a
ld (#E28B),a
ld (#F28C),a
ld (#D2DB),a
ld (#F2D9),a
ld (#F2DD),a
ld a,#05
ld (#E0FF),a
ld (#E142),a
ld a,#06
ld (#F101),a
ld (#C234),a
ld (#F2D2),a
ld a,#07
ld (#E195),a
ld (#C240),a
ld a,#08
ld (#F0AA),a
ld (#F151),a
ld (#D191),a
ld (#C1F0),a
ld (#E1EE),a
ld (#E1F3),a
ld (#C28C),a
ld (#D28C),a
ld (#E28A),a
ld (#F284),a
ld (#E2D4),a
ld (#E2DB),a
ld (#F2DF),a
ld a,#09
ld (#D013),a
ld (#C0A8),a
ld (#D0A6),a
ld a,#0A
ld (#F000),a
ld (#E058),a
ld (#E05C),a
ld (#E05F),a
ld (#C0AA),a
ld (#D102),a
ld (#E103),a
ld (#F147),a
ld (#F150),a
ld (#D1A3),a
ld (#E192),a
ld (#F194),a
ld (#D1E1),a
ld (#E1ED),a
ld (#D282),a
ld (#D28D),a
ld (#E2DA),a
ld a,#0B
ld (#E00B),a
ld a,#0C
ld (#D006),a
ld (#E23F),a
ld a,#0F
ld (#C1E9),a
ld a,#10
ld (#D058),a
ld (#E05E),a
ld (#F102),a
ld (#C14F),a
ld (#F152),a
ld (#F195),a
ld (#C1E1),a
ld (#C1E3),a
ld (#D1E2),a
ld (#D1E6),a
ld (#F1E7),a
ld (#D230),a
ld (#D243),a
ld (#E233),a
ld (#F238),a
ld (#D286),a
ld (#E2E1),a
ld a,#11
ld (#F0FB),a
ld (#E237),a
ld a,#12
ld (#C012),a
ld (#E00D),a
ld (#F00A),a
ld (#C0AB),a
ld (#E2D5),a
ld a,#14
ld (#F063),a
ld (#D0B2),a
ld (#F1E6),a
ld (#E290),a
ld a,#18
ld (#D011),a
ld (#F010),a
ld (#E053),a
ld (#F0A7),a
ld (#D0FA),a
ld (#C191),a
ld (#E1E0),a
ld (#E23B),a
ld a,#19
ld (#C1EF),a
ld a,#1A
ld (#F003),a
ld (#C05A),a
ld (#F0B1),a
ld (#D0F3),a
ld (#C140),a
ld (#C1F2),a
ld (#C235),a
ld (#C28B),a
ld (#C2D2),a
ld a,#1B
ld (#E1EC),a
ld a,#22
ld (#F0A4),a
ld (#E144),a
ld (#D2E2),a
ld a,#23
ld (#C0F6),a
ld (#F0F7),a
ld a,#26
ld (#E1E7),a
ld (#E238),a
ld a,#2A
ld (#D056),a
ld (#F0F5),a
ld (#F1EF),a
ld (#F240),a
ld (#E289),a
ld (#F28D),a
ld a,#32
ld (#E230),a
ld (#E23D),a
ld a,#36
ld (#F19E),a
ld (#C291),a
ld a,#3A
ld (#F006),a
ld (#E062),a
ld (#F0AC),a
ld a,#40
ld (#C00D),a
ld (#D000),a
ld (#C062),a
ld (#C0A9),a
ld (#C0B0),a
ld (#D0AD),a
ld (#E0A6),a
ld (#F0A3),a
ld (#E0F9),a
ld (#E0FE),a
ld (#F0F3),a
ld (#F0FA),a
ld (#C142),a
ld (#E152),a
ld (#F153),a
ld (#C1E8),a
ld (#D1EB),a
ld (#C239),a
ld (#F230),a
ld (#F23F),a
ld (#C28A),a
ld (#C290),a
ld (#E28F),a
ld (#F287),a
ld (#F2D1),a
ld (#F2D8),a
ld a,#41
ld (#D051),a
ld (#F0A6),a
ld (#F19B),a
ld (#F19D),a
ld (#E23C),a
ld (#E282),a
ld a,#42
ld (#C060),a
ld (#F060),a
ld (#E0B2),a
ld (#E0F3),a
ld (#C14A),a
ld (#D152),a
ld (#C19E),a
ld (#E1E1),a
ld (#F1EC),a
ld (#D23C),a
ld (#F290),a
ld a,#44
ld (#F0FC),a
ld a,#46
ld (#F14D),a
ld (#E196),a
ld a,#48
ld (#D0A7),a
ld (#F199),a
ld (#E1E9),a
ld a,#4A
ld (#F00F),a
ld (#F0AE),a
ld (#F1E0),a
ld a,#4C
ld (#E145),a
ld a,#50
ld (#E010),a
ld (#F011),a
ld (#E055),a
ld (#F05F),a
ld (#C0AC),a
ld (#E0A0),a
ld (#F0A8),a
ld (#C103),a
ld (#D0FD),a
ld (#E0F0),a
ld (#E0F5),a
ld (#E0F8),a
ld (#F0F1),a
ld (#F0F2),a
ld (#C144),a
ld (#C150),a
ld (#D14F),a
ld (#D150),a
ld (#E140),a
ld (#E14A),a
ld (#C195),a
ld (#D19B),a
ld (#E190),a
ld (#E1A0),a
ld (#E1A1),a
ld (#F1A3),a
ld (#C1EB),a
ld (#D1E5),a
ld (#F1E8),a
ld (#F1F2),a
ld (#F1F3),a
ld (#C243),a
ld (#D237),a
ld (#E235),a
ld (#F235),a
ld (#D283),a
ld (#D291),a
ld (#E2D2),a
ld (#E2D8),a
ld a,#52
ld (#C0FC),a
ld (#D0F0),a
ld (#F14F),a
ld (#D2DF),a
ld a,#53
ld (#E19B),a
ld a,#58
ld (#E012),a
ld (#F05D),a
ld (#D0A3),a
ld (#E0A8),a
ld (#E0B1),a
ld (#C0FD),a
ld (#E101),a
ld (#F148),a
ld (#C1A3),a
ld (#D195),a
ld (#E1E3),a
ld (#F1F0),a
ld (#D232),a
ld (#C282),a
ld (#C287),a
ld (#C28E),a
ld (#C292),a
ld (#E293),a
ld (#F2DA),a
ld a,#5A
ld (#E000),a
ld (#F00B),a
ld (#D0AF),a
ld (#D0F1),a
ld (#D0F2),a
ld (#C1A1),a
ld (#D194),a
ld a,#62
ld (#C053),a
ld (#D0F7),a
ld (#F2E1),a
ld a,#6A
ld (#C2D7),a
ld a,#72
ld (#E191),a
ld (#D231),a
ld (#D28B),a
ld a,#7A
ld (#C063),a
ld (#D143),a
ld (#D23E),a
ld a,#88
ld (#C057),a
ld (#F057),a
ld (#E28D),a
ld (#F291),a
ld a,#89
ld (#E0F4),a
ld a,#8A
ld (#E0A9),a
ld (#C0F0),a
ld (#C2DD),a
ld a,#98
ld (#C003),a
ld (#F0A5),a
ld (#F0F6),a
ld (#D292),a
ld (#D2DE),a
ld a,#9A
ld (#C009),a
ld (#E007),a
ld (#E0B0),a
ld (#C1A2),a
ld (#F190),a
ld (#C2D8),a
ld (#C2DF),a
ld a,#AA
ld (#C059),a
ld (#C147),a
ld (#F146),a
ld (#F14E),a
ld (#E243),a
ld a,#AF
ld (#E14B),a
ld a,#BA
ld (#D28F),a
ld a,#C8
ld (#D1EC),a
ld a,#CE
ld (#E19C),a
ld a,#D8
ld (#C013),a
ld (#F008),a
ld (#F054),a
ld (#E0B3),a
ld (#E146),a
ld (#D199),a
ld (#E1EA),a
ld (#E281),a
ld a,#DA
ld (#C010),a
ld (#E00E),a
ld (#F007),a
ld (#F058),a
ld (#F05C),a
ld (#D153),a
ld (#C2E2),a
ld a,#EA
ld (#F193),a
ld a,#EB
ld (#E0A3),a
ld a,#EE
ld (#C198),a
ld a,#FA
ld (#F0FE),a
ld (#E197),a
ld (#C286),a
ld (#D2DD),a
ret

p23to24
ld a,#00
ld (#C006),a
ld (#C00D),a
ld (#E005),a
ld (#E011),a
ld (#F002),a
ld (#F00E),a
ld (#D0AD),a
ld (#E0AE),a
ld (#F0A9),a
ld (#C0F2),a
ld (#E0F1),a
ld (#E150),a
ld (#E151),a
ld (#E153),a
ld (#F152),a
ld (#C19F),a
ld (#C1A0),a
ld (#E194),a
ld (#C1F0),a
ld (#D1F0),a
ld (#D1F1),a
ld (#D1F2),a
ld (#E1F3),a
ld (#F1E2),a
ld (#C234),a
ld (#D234),a
ld (#D243),a
ld (#C28D),a
ld (#D280),a
ld (#F288),a
ld (#F293),a
ld (#E2DB),a
ld (#F2D9),a
ld a,#01
ld (#D006),a
ld (#D051),a
ld (#D05C),a
ld (#E056),a
ld (#C0A4),a
ld (#D102),a
ld (#C152),a
ld (#C233),a
ld (#E237),a
ld (#D2DA),a
ld a,#02
ld (#C012),a
ld (#E006),a
ld (#E00D),a
ld (#F00A),a
ld (#D061),a
ld (#F053),a
ld (#C0B3),a
ld (#D0A2),a
ld (#D0F0),a
ld (#F101),a
ld (#D190),a
ld (#C1E3),a
ld (#D1F3),a
ld (#F23A),a
ld (#F2D2),a
ld a,#03
ld (#E0FE),a
ld (#D23D),a
ld a,#04
ld (#D001),a
ld (#C056),a
ld (#D0B2),a
ld (#D140),a
ld (#C1E0),a
ld (#E232),a
ld (#E290),a
ld (#F281),a
ld (#E2DC),a
ld a,#05
ld (#F0FB),a
ld (#E143),a
ld (#D242),a
ld (#D2D0),a
ld a,#08
ld (#C0A1),a
ld (#C0F1),a
ld (#C102),a
ld (#C14E),a
ld (#F143),a
ld (#E192),a
ld (#F1E5),a
ld (#C231),a
ld (#F233),a
ld (#C284),a
ld (#E28D),a
ld a,#09
ld (#F151),a
ld a,#0A
ld (#D005),a
ld (#E00B),a
ld (#F012),a
ld (#C0A0),a
ld (#E0AD),a
ld (#E0B0),a
ld (#D0F1),a
ld (#F0FF),a
ld (#E141),a
ld (#C1A2),a
ld (#E19D),a
ld (#C1F1),a
ld (#E1EE),a
ld (#F1E0),a
ld (#E243),a
ld (#C28C),a
ld (#F28D),a
ld (#C2DC),a
ld (#D2DE),a
ld a,#0B
ld (#D013),a
ld (#E1EC),a
ld a,#0C
ld (#C1E9),a
ld a,#10
ld (#D062),a
ld (#D0B0),a
ld (#E0A7),a
ld (#C0F7),a
ld (#E0F2),a
ld (#D192),a
ld (#D1ED),a
ld (#D235),a
ld (#F231),a
ld (#F234),a
ld (#F23C),a
ld (#D28A),a
ld (#D2D3),a
ld (#E2DE),a
ld a,#11
ld (#E1E6),a
ld a,#12
ld (#F05B),a
ld (#C0FC),a
ld (#D0FF),a
ld (#D2D7),a
ld (#F2DE),a
ld a,#13
ld (#E195),a
ld a,#14
ld (#D0A9),a
ld (#F23B),a
ld a,#18
ld (#C003),a
ld (#D052),a
ld (#F0F6),a
ld (#F102),a
ld (#C1A3),a
ld (#F190),a
ld (#D2E3),a
ld (#F2E2),a
ld a,#1A
ld (#C010),a
ld (#E007),a
ld (#E00E),a
ld (#F006),a
ld (#E062),a
ld (#F056),a
ld (#C0AB),a
ld (#D0FA),a
ld (#D153),a
ld (#D1A3),a
ld (#E23A),a
ld (#E2D5),a
ld a,#1B
ld (#C1EF),a
ld a,#1C
ld (#F063),a
ld a,#1D
ld (#C240),a
ld a,#22
ld (#D0AE),a
ld (#E103),a
ld (#F0F7),a
ld (#F1E9),a
ld (#C281),a
ld (#E280),a
ld (#F2E1),a
ld a,#26
ld (#E196),a
ld (#F1EF),a
ld a,#2A
ld (#D055),a
ld (#F147),a
ld (#E23D),a
ld (#D28D),a
ld a,#2B
ld (#E14B),a
ld a,#32
ld (#F0A4),a
ld (#F0AC),a
ld (#E1E7),a
ld a,#3A
ld (#C063),a
ld (#D056),a
ld (#F0B1),a
ld (#F0FD),a
ld (#C1F2),a
ld (#E238),a
ld (#F23D),a
ld (#C2E2),a
ld (#F2D6),a
ld a,#40
ld (#C005),a
ld (#D00A),a
ld (#F005),a
ld (#F009),a
ld (#D063),a
ld (#F062),a
ld (#D0A7),a
ld (#D0B1),a
ld (#E0AC),a
ld (#F0AF),a
ld (#C151),a
ld (#E140),a
ld (#E14F),a
ld (#D1A2),a
ld (#F191),a
ld (#F19B),a
ld (#C1E2),a
ld (#C232),a
ld (#C23C),a
ld (#E231),a
ld (#E236),a
ld (#F236),a
ld (#F242),a
ld (#E282),a
ld (#D2D9),a
ld (#E2D9),a
ld a,#41
ld (#D000),a
ld (#C0F9),a
ld (#F230),a
ld (#D2D2),a
ld a,#42
ld (#D010),a
ld (#C053),a
ld (#E0A6),a
ld (#F0A6),a
ld (#D14A),a
ld (#D231),a
ld (#F283),a
ld a,#43
ld (#C055),a
ld (#C14A),a
ld (#E19B),a
ld a,#44
ld (#E145),a
ld a,#45
ld (#F0FC),a
ld (#F14D),a
ld a,#46
ld (#F19E),a
ld (#C291),a
ld a,#48
ld (#F057),a
ld (#C0FA),a
ld (#D1EC),a
ld (#F1EA),a
ld a,#49
ld (#E1E9),a
ld a,#4A
ld (#C00F),a
ld (#F142),a
ld (#F193),a
ld (#E1F2),a
ld a,#50
ld (#C011),a
ld (#D012),a
ld (#D060),a
ld (#E051),a
ld (#F05D),a
ld (#C0B0),a
ld (#D0B3),a
ld (#E0A8),a
ld (#F0B2),a
ld (#C0F3),a
ld (#C0FD),a
ld (#C100),a
ld (#D103),a
ld (#E102),a
ld (#F0F0),a
ld (#F0F3),a
ld (#F0F4),a
ld (#F0F9),a
ld (#C142),a
ld (#C143),a
ld (#C14F),a
ld (#D14E),a
ld (#E152),a
ld (#F140),a
ld (#F145),a
ld (#C191),a
ld (#D193),a
ld (#D194),a
ld (#E1A2),a
ld (#F196),a
ld (#D1E2),a
ld (#D1E6),a
ld (#E1E3),a
ld (#E1E4),a
ld (#F1E1),a
ld (#F1E7),a
ld (#C23F),a
ld (#F238),a
ld (#C28E),a
ld (#C293),a
ld (#E287),a
ld (#F282),a
ld (#F289),a
ld (#D2DF),a
ld (#F2DA),a
ld a,#52
ld (#C000),a
ld (#C002),a
ld (#E001),a
ld (#C060),a
ld (#D152),a
ld (#E292),a
ld (#D2DC),a
ld a,#58
ld (#E000),a
ld (#F00B),a
ld (#C05B),a
ld (#E050),a
ld (#F0A7),a
ld (#F0AE),a
ld (#D100),a
ld (#E0F5),a
ld (#C141),a
ld (#D144),a
ld (#F199),a
ld (#F19C),a
ld (#C1F3),a
ld (#E1E0),a
ld (#E1EA),a
ld (#F1ED),a
ld (#C236),a
ld (#C23D),a
ld (#D23B),a
ld (#E281),a
ld (#E28E),a
ld (#F28E),a
ld (#C2D0),a
ld (#E2D6),a
ld (#F2D7),a
ld a,#5A
ld (#F05C),a
ld (#D143),a
ld (#C1E4),a
ld (#F1E4),a
ld (#E242),a
ld a,#62
ld (#C19E),a
ld (#D2E2),a
ld a,#6A
ld (#C008),a
ld a,#72
ld (#E0F3),a
ld (#E0F7),a
ld (#C14D),a
ld (#F197),a
ld a,#7A
ld (#F14F),a
ld (#E191),a
ld (#C286),a
ld (#C2D7),a
ld a,#88
ld (#E002),a
ld a,#8A
ld (#C057),a
ld (#F059),a
ld (#C0A6),a
ld (#F150),a
ld (#D1E1),a
ld (#E1ED),a
ld a,#8C
ld (#E23F),a
ld a,#8D
ld (#E0F4),a
ld a,#98
ld (#F003),a
ld (#D14B),a
ld (#C28B),a
ld a,#9A
ld (#E230),a
ld (#C287),a
ld (#C2D2),a
ld (#D2E0),a
ld a,#9B
ld (#E0A3),a
ld a,#AA
ld (#F0F5),a
ld (#E2D1),a
ld a,#AB
ld (#E0FA),a
ld a,#AE
ld (#C147),a
ld a,#BA
ld (#C235),a
ld a,#C8
ld (#C23A),a
ld a,#CA
ld (#F058),a
ld (#D0AF),a
ld (#C0F0),a
ld a,#D8
ld (#C061),a
ld (#F1F0),a
ld a,#DA
ld (#D05E),a
ld (#F0AD),a
ld (#E101),a
ld (#E293),a
ld (#D2DD),a
ld a,#EA
ld (#F146),a
ld (#F14E),a
ld a,#FA
ld (#D0F2),a
ld (#D0F3),a
ld (#D28F),a
ret

p24to25
ld a,#00
ld (#F000),a
ld (#F00A),a
ld (#C050),a
ld (#D051),a
ld (#E060),a
ld (#C0A9),a
ld (#F0AA),a
ld (#F0AB),a
ld (#F0B3),a
ld (#C0F1),a
ld (#D0F0),a
ld (#D0FE),a
ld (#D102),a
ld (#E0F0),a
ld (#E0FF),a
ld (#F0F6),a
ld (#F101),a
ld (#E142),a
ld (#E143),a
ld (#E14F),a
ld (#F151),a
ld (#C1E0),a
ld (#C1E2),a
ld (#C1E9),a
ld (#E1E1),a
ld (#F1E3),a
ld (#F1E5),a
ld (#C230),a
ld (#C242),a
ld (#D235),a
ld (#F237),a
ld (#C285),a
ld (#E282),a
ld (#F285),a
ld (#F28B),a
ld (#C2D6),a
ld a,#01
ld (#C012),a
ld (#E005),a
ld (#E011),a
ld (#D054),a
ld (#E057),a
ld (#C0A1),a
ld (#D0B2),a
ld (#C0FB),a
ld (#E0F1),a
ld (#D242),a
ld (#F230),a
ld (#D2D2),a
ld (#F2DC),a
ld a,#02
ld (#C005),a
ld (#C00D),a
ld (#D001),a
ld (#C055),a
ld (#D055),a
ld (#E058),a
ld (#F05B),a
ld (#C0A5),a
ld (#E103),a
ld (#E151),a
ld (#D23D),a
ld (#D286),a
ld (#E28B),a
ld (#E2D3),a
ld a,#03
ld (#C053),a
ld a,#04
ld (#E0F2),a
ld (#F152),a
ld (#C1E3),a
ld (#C1F0),a
ld (#D1E9),a
ld (#F1E6),a
ld (#D282),a
ld (#D2D0),a
ld a,#05
ld (#D00B),a
ld (#E006),a
ld (#D05C),a
ld (#E150),a
ld (#D243),a
ld (#E2DD),a
ld a,#06
ld (#F1EF),a
ld (#F28C),a
ld (#F28D),a
ld a,#08
ld (#C006),a
ld (#F010),a
ld (#E05C),a
ld (#E0A9),a
ld (#E0AD),a
ld (#E0FE),a
ld (#F1A2),a
ld (#F1E0),a
ld (#C241),a
ld (#C28C),a
ld a,#09
ld (#C00E),a
ld (#D006),a
ld (#E056),a
ld (#E1EC),a
ld (#C2DD),a
ld a,#0A
ld (#C00F),a
ld (#E007),a
ld (#F006),a
ld (#C057),a
ld (#D056),a
ld (#F059),a
ld (#C0AB),a
ld (#D0AE),a
ld (#C102),a
ld (#F143),a
ld (#F150),a
ld (#F1A1),a
ld (#C233),a
ld (#D28C),a
ld (#C2DF),a
ld (#D2DD),a
ld a,#0C
ld (#E290),a
ld a,#0E
ld (#C05A),a
ld a,#0F
ld (#C0AA),a
ld a,#10
ld (#C000),a
ld (#D007),a
ld (#F013),a
ld (#C054),a
ld (#E053),a
ld (#E0AF),a
ld (#D103),a
ld (#C14E),a
ld (#C153),a
ld (#D142),a
ld (#F144),a
ld (#C1A0),a
ld (#C1A3),a
ld (#D191),a
ld (#E1E2),a
ld (#C243),a
ld (#F23B),a
ld (#D280),a
ld (#D293),a
ld (#F2DE),a
ld a,#11
ld (#D000),a
ld (#E195),a
ld a,#12
ld (#C007),a
ld (#C058),a
ld (#E062),a
ld (#D1A3),a
ld (#C2E2),a
ld (#F2D2),a
ld (#F2D6),a
ld a,#14
ld (#D058),a
ld (#C0F7),a
ld (#F195),a
ld (#E2DE),a
ld (#E2E1),a
ld a,#18
ld (#E002),a
ld (#F061),a
ld (#E0B1),a
ld (#F0A5),a
ld (#E0FB),a
ld (#C231),a
ld (#E283),a
ld (#E28E),a
ld a,#19
ld (#D057),a
ld (#C240),a
ld a,#1A
ld (#D0FF),a
ld (#F102),a
ld (#E191),a
ld (#C1F2),a
ld a,#22
ld (#D013),a
ld (#F012),a
ld (#F053),a
ld (#F0A6),a
ld (#E0F3),a
ld (#D28D),a
ld a,#23
ld (#E14B),a
ld a,#2A
ld (#D0A2),a
ld (#F0A4),a
ld (#F1E9),a
ld (#C2DC),a
ld (#E2D5),a
ld a,#2B
ld (#E0FA),a
ld (#E23D),a
ld a,#2F
ld (#C0F6),a
ld a,#32
ld (#E0F7),a
ld (#F0FD),a
ld (#C14D),a
ld (#F240),a
ld (#C281),a
ld a,#33
ld (#E144),a
ld a,#36
ld (#E196),a
ld a,#3A
ld (#D0FA),a
ld (#C1E4),a
ld (#E1E7),a
ld (#C235),a
ld (#E23A),a
ld a,#3E
ld (#C063),a
ld (#D28E),a
ld a,#40
ld (#D010),a
ld (#C060),a
ld (#D05B),a
ld (#D0A6),a
ld (#D0A8),a
ld (#D0AC),a
ld (#E0B2),a
ld (#F0A2),a
ld (#C0F9),a
ld (#C101),a
ld (#E0FD),a
ld (#F103),a
ld (#E153),a
ld (#C197),a
ld (#C19D),a
ld (#E19B),a
ld (#F19D),a
ld (#E1E5),a
ld (#F1E1),a
ld (#D237),a
ld (#E23C),a
ld (#D281),a
ld (#D288),a
ld (#F290),a
ld (#C2DB),a
ld (#C2E3),a
ld (#E2E0),a
ld a,#41
ld (#D198),a
ld (#E288),a
ld (#C2E1),a
ld a,#42
ld (#F005),a
ld (#C0B1),a
ld (#D0F7),a
ld (#E140),a
ld (#F197),a
ld (#C283),a
ld (#D2E2),a
ld (#F2E1),a
ld a,#45
ld (#F19E),a
ld a,#48
ld (#C0A8),a
ld (#E1E9),a
ld (#C23A),a
ld a,#4A
ld (#F0FF),a
ld (#D231),a
ld (#E243),a
ld a,#4C
ld (#E0F4),a
ld a,#50
ld (#E00F),a
ld (#F00B),a
ld (#E050),a
ld (#E05E),a
ld (#E061),a
ld (#D0A3),a
ld (#E0A4),a
ld (#E0A7),a
ld (#F0A1),a
ld (#F0A3),a
ld (#F0A7),a
ld (#F0AE),a
ld (#F0AF),a
ld (#F0B0),a
ld (#C141),a
ld (#D14A),a
ld (#D152),a
ld (#F14B),a
ld (#F153),a
ld (#D192),a
ld (#D195),a
ld (#D1A0),a
ld (#D1A1),a
ld (#D1A2),a
ld (#F199),a
ld (#C1E1),a
ld (#C1EA),a
ld (#E1E0),a
ld (#E1F1),a
ld (#E1F2),a
ld (#F1E4),a
ld (#D230),a
ld (#D232),a
ld (#D23B),a
ld (#E233),a
ld (#E236),a
ld (#E23E),a
ld (#F234),a
ld (#F242),a
ld (#F243),a
ld (#C282),a
ld (#C2D0),a
ld (#D2D1),a
ld a,#51
ld (#C14A),a
ld a,#52
ld (#D008),a
ld (#D0A0),a
ld (#F141),a
ld (#C1A1),a
ld (#F1A0),a
ld (#D1E0),a
ld (#D23C),a
ld a,#58
ld (#C00A),a
ld (#E059),a
ld (#E063),a
ld (#F05C),a
ld (#C0AC),a
ld (#C0B2),a
ld (#E0AA),a
ld (#F0B2),a
ld (#C0FD),a
ld (#E192),a
ld (#F190),a
ld (#C1E5),a
ld (#F1EA),a
ld (#D287),a
ld (#C2D9),a
ld (#D2D8),a
ld a,#5A
ld (#D0A1),a
ld (#F0AD),a
ld (#C0F0),a
ld (#D100),a
ld (#F193),a
ld (#C286),a
ld (#C2D7),a
ld a,#62
ld (#C002),a
ld (#D2DC),a
ld a,#63
ld (#C1EF),a
ld a,#66
ld (#E145),a
ld a,#6B
ld (#E052),a
ld a,#6E
ld (#F0F7),a
ld a,#72
ld (#E001),a
ld (#F0B1),a
ld a,#7A
ld (#F007),a
ld (#D0F2),a
ld (#D28F),a
ld a,#88
ld (#D011),a
ld (#F063),a
ld a,#8A
ld (#D005),a
ld (#E00B),a
ld (#C059),a
ld (#D0AF),a
ld (#E1EE),a
ld (#E239),a
ld (#E23F),a
ld (#E2D1),a
ld (#E2DA),a
ld a,#8D
ld (#E0A3),a
ld a,#8E
ld (#C147),a
ld (#E1ED),a
ld a,#98
ld (#D052),a
ld (#F054),a
ld (#F19C),a
ld (#D1E1),a
ld (#E23B),a
ld (#C2D2),a
ld (#D2E3),a
ld (#F2E2),a
ld a,#9A
ld (#F056),a
ld (#C236),a
ld a,#9C
ld (#D0A9),a
ld a,#9E
ld (#C28B),a
ld a,#AA
ld (#C009),a
ld (#C0A6),a
ld (#F146),a
ld (#F198),a
ld (#F23D),a
ld (#C287),a
ld (#C2D8),a
ld a,#BA
ld (#F14E),a
ld (#E238),a
ld (#F291),a
ld (#D2E0),a
ld a,#D8
ld (#F003),a
ld (#F1ED),a
ld (#C23D),a
ld a,#DA
ld (#F008),a
ld (#C061),a
ld (#E0B3),a
ld (#F0FE),a
ld (#F19F),a
ld (#C1F3),a
ld a,#EA
ld (#F0F5),a
ld (#F142),a
ld a,#EF
ld (#E19C),a
ld a,#FA
ld (#F14F),a
ld (#E293),a
ret

p25to26
ld a,#00
ld (#C00B),a
ld (#E005),a
ld (#E00E),a
ld (#C056),a
ld (#C05C),a
ld (#C063),a
ld (#D058),a
ld (#E056),a
ld (#F061),a
ld (#C0A0),a
ld (#C0A1),a
ld (#D0A6),a
ld (#D0B0),a
ld (#E0A0),a
ld (#E0A1),a
ld (#E0B1),a
ld (#C0F5),a
ld (#E0F1),a
ld (#E0F2),a
ld (#F0FD),a
ld (#C152),a
ld (#D14F),a
ld (#D153),a
ld (#E150),a
ld (#F14C),a
ld (#E1A0),a
ld (#E1A2),a
ld (#F191),a
ld (#F192),a
ld (#F195),a
ld (#F19D),a
ld (#C1E3),a
ld (#C1F0),a
ld (#D1E3),a
ld (#D1E4),a
ld (#F1E6),a
ld (#D23D),a
ld (#D242),a
ld (#D243),a
ld (#E231),a
ld (#C284),a
ld (#C292),a
ld (#C293),a
ld (#D288),a
ld (#D293),a
ld (#E28B),a
ld (#F284),a
ld (#F28D),a
ld (#D2D2),a
ld (#D2D6),a
ld (#D2D9),a
ld (#D2DB),a
ld (#F2D1),a
ld a,#01
ld (#D000),a
ld (#D00A),a
ld (#D05B),a
ld (#E062),a
ld (#C1A3),a
ld (#D198),a
ld (#E195),a
ld (#F1A2),a
ld (#C28D),a
ld (#E28A),a
ld (#F28B),a
ld (#E2DB),a
ld (#E2DC),a
ld a,#02
ld (#D003),a
ld (#D004),a
ld (#D00C),a
ld (#E006),a
ld (#E007),a
ld (#F005),a
ld (#C0A6),a
ld (#D0B2),a
ld (#E0B0),a
ld (#C102),a
ld (#F0F6),a
ld (#F141),a
ld (#F152),a
ld (#D292),a
ld (#E282),a
ld (#E28C),a
ld (#F281),a
ld (#C2D6),a
ld (#D2D7),a
ld (#E2DD),a
ld (#F2DD),a
ld a,#03
ld (#D054),a
ld (#E0F3),a
ld a,#04
ld (#E00D),a
ld (#F00E),a
ld (#D05C),a
ld (#C0A4),a
ld (#C0A9),a
ld (#D103),a
ld (#C14D),a
ld (#F144),a
ld (#C192),a
ld (#E1A1),a
ld (#F1A3),a
ld (#E1E1),a
ld (#E1EC),a
ld (#C241),a
ld (#D235),a
ld (#F230),a
ld (#C2DE),a
ld a,#05
ld (#C050),a
ld (#C053),a
ld (#D0AD),a
ld (#D0FE),a
ld (#F0FC),a
ld (#F1EF),a
ld a,#06
ld (#F240),a
ld (#D286),a
ld (#D2D0),a
ld (#E2D4),a
ld a,#07
ld (#C05A),a
ld a,#08
ld (#C005),a
ld (#C00E),a
ld (#D055),a
ld (#E060),a
ld (#E0A2),a
ld (#C153),a
ld (#D140),a
ld (#E141),a
ld (#E14F),a
ld (#F143),a
ld (#F1E2),a
ld (#E232),a
ld (#E283),a
ld (#E2D1),a
ld (#E2DE),a
ld (#E2E1),a
ld a,#09
ld (#E052),a
ld (#C0AA),a
ld (#E28D),a
ld (#D2D5),a
ld a,#0A
ld (#C006),a
ld (#C009),a
ld (#C010),a
ld (#C059),a
ld (#F063),a
ld (#D0A0),a
ld (#D0AF),a
ld (#F0AA),a
ld (#E0F0),a
ld (#E101),a
ld (#F0F2),a
ld (#F146),a
ld (#C1E2),a
ld (#C1F3),a
ld (#C242),a
ld (#F23D),a
ld (#C287),a
ld (#D28E),a
ld (#F285),a
ld (#C2D8),a
ld (#E2D3),a
ld (#E2D5),a
ld (#F2D5),a
ld a,#0B
ld (#D234),a
ld a,#0C
ld (#D2DD),a
ld a,#0D
ld (#D2DA),a
ld a,#0E
ld (#C055),a
ld (#D231),a
ld a,#10
ld (#C003),a
ld (#C013),a
ld (#E002),a
ld (#C05F),a
ld (#F054),a
ld (#D0B3),a
ld (#E0AE),a
ld (#F0A5),a
ld (#F0AC),a
ld (#D101),a
ld (#F0F3),a
ld (#F14E),a
ld (#C190),a
ld (#D193),a
ld (#C1F1),a
ld (#F1E0),a
ld (#F1E3),a
ld (#E240),a
ld (#C28C),a
ld (#D282),a
ld a,#11
ld (#E144),a
ld a,#12
ld (#C0AD),a
ld (#D0F1),a
ld (#D28C),a
ld (#E284),a
ld a,#14
ld (#D007),a
ld (#E012),a
ld (#C058),a
ld a,#18
ld (#E00B),a
ld (#F013),a
ld (#E059),a
ld (#F056),a
ld (#F0B2),a
ld (#E102),a
ld (#F153),a
ld (#F19F),a
ld (#C1E0),a
ld (#C23D),a
ld (#C28B),a
ld (#C2D2),a
ld (#D2DF),a
ld (#E2DA),a
ld a,#1A
ld (#C007),a
ld (#C061),a
ld (#D0AE),a
ld (#E0B3),a
ld (#E19D),a
ld (#C1E4),a
ld (#D236),a
ld (#D23E),a
ld (#F28E),a
ld (#E2D6),a
ld a,#1D
ld (#F14D),a
ld (#F19E),a
ld a,#1E
ld (#F23A),a
ld a,#22
ld (#C00F),a
ld (#F002),a
ld (#E058),a
ld (#F059),a
ld (#E0A6),a
ld (#C230),a
ld a,#23
ld (#C0A5),a
ld (#C240),a
ld a,#26
ld (#F0A6),a
ld (#E0F4),a
ld a,#2A
ld (#C00D),a
ld (#F00F),a
ld (#F053),a
ld (#C236),a
ld (#D289),a
ld (#C2DD),a
ld a,#2E
ld (#D051),a
ld a,#32
ld (#C19E),a
ld (#E28E),a
ld (#F28C),a
ld a,#3A
ld (#D00E),a
ld (#F008),a
ld (#F102),a
ld (#D150),a
ld (#E145),a
ld (#C193),a
ld (#C243),a
ld (#D28F),a
ld (#F291),a
ld (#D2E0),a
ld (#F2DE),a
ld a,#40
ld (#C004),a
ld (#D002),a
ld (#E00C),a
ld (#E011),a
ld (#F00D),a
ld (#C05E),a
ld (#D061),a
ld (#F060),a
ld (#C0A3),a
ld (#C0A7),a
ld (#C0A8),a
ld (#C0B1),a
ld (#C0B3),a
ld (#F0A9),a
ld (#F0B3),a
ld (#C0F4),a
ld (#D0FD),a
ld (#D102),a
ld (#E0FA),a
ld (#F101),a
ld (#E14E),a
ld (#F140),a
ld (#C191),a
ld (#C1A2),a
ld (#E190),a
ld (#E198),a
ld (#F194),a
ld (#F197),a
ld (#C1E1),a
ld (#D1F3),a
ld (#E1E0),a
ld (#E1E6),a
ld (#D239),a
ld (#E237),a
ld (#E288),a
ld (#F280),a
ld (#F288),a
ld (#C2E1),a
ld (#F2DF),a
ld (#F2E1),a
ld a,#41
ld (#D057),a
ld (#E055),a
ld (#E057),a
ld (#D0AC),a
ld (#D281),a
ld a,#42
ld (#F012),a
ld (#F055),a
ld (#F057),a
ld (#F0B1),a
ld (#E103),a
ld (#D1E0),a
ld (#E23D),a
ld (#F232),a
ld (#D2D4),a
ld a,#43
ld (#C002),a
ld a,#44
ld (#C0FC),a
ld (#D1E9),a
ld (#C2E2),a
ld a,#47
ld (#C0AB),a
ld a,#48
ld (#E0A9),a
ld (#C0FF),a
ld (#D0F3),a
ld a,#4A
ld (#E05F),a
ld (#F058),a
ld (#F150),a
ld (#D23A),a
ld (#D2DC),a
ld a,#4C
ld (#E0A3),a
ld a,#50
ld (#D010),a
ld (#E000),a
ld (#F009),a
ld (#F00A),a
ld (#C062),a
ld (#D063),a
ld (#E05D),a
ld (#F05A),a
ld (#F05B),a
ld (#F05C),a
ld (#F062),a
ld (#D0A7),a
ld (#D0A8),a
ld (#D0B1),a
ld (#E0AF),a
ld (#F0A0),a
ld (#F0A2),a
ld (#F0AD),a
ld (#C0F1),a
ld (#C0F2),a
ld (#C101),a
ld (#D0F7),a
ld (#E100),a
ld (#F0FF),a
ld (#F100),a
ld (#C140),a
ld (#C151),a
ld (#D141),a
ld (#D142),a
ld (#D143),a
ld (#D144),a
ld (#E153),a
ld (#F148),a
ld (#C1A0),a
ld (#C1A1),a
ld (#D191),a
ld (#D199),a
ld (#D19F),a
ld (#E192),a
ld (#E193),a
ld (#E194),a
ld (#E19B),a
ld (#E1A3),a
ld (#F190),a
ld (#F193),a
ld (#D1EB),a
ld (#D1EC),a
ld (#D1F1),a
ld (#D1F2),a
ld (#E1E2),a
ld (#E1E5),a
ld (#E1EA),a
ld (#E1F3),a
ld (#F1E5),a
ld (#F1EC),a
ld (#C231),a
ld (#D23C),a
ld (#E242),a
ld (#E243),a
ld (#F231),a
ld (#F236),a
ld (#F23C),a
ld (#C286),a
ld (#C290),a
ld (#E281),a
ld (#E28F),a
ld (#E292),a
ld (#F287),a
ld (#F293),a
ld (#C2D4),a
ld (#C2D7),a
ld (#C2DB),a
ld (#C2E3),a
ld (#D2E2),a
ld (#F2D4),a
ld (#F2D8),a
ld (#F2D9),a
ld a,#51
ld (#C1E8),a
ld a,#52
ld (#D00D),a
ld (#E05E),a
ld (#D1A3),a
ld (#C1F2),a
ld (#F1F1),a
ld (#C232),a
ld (#C28A),a
ld (#D28D),a
ld (#E2D0),a
ld (#E2E3),a
ld a,#56
ld (#E0F7),a
ld a,#58
ld (#E008),a
ld (#C05D),a
ld (#D052),a
ld (#E0A4),a
ld (#C0F0),a
ld (#C103),a
ld (#F0FE),a
ld (#F103),a
ld (#C194),a
ld (#C19F),a
ld (#D1E1),a
ld (#D1E5),a
ld (#F1F3),a
ld (#C237),a
ld (#C23A),a
ld (#E230),a
ld (#F23E),a
ld (#C288),a
ld (#D290),a
ld a,#5A
ld (#C008),a
ld (#D050),a
ld (#D05E),a
ld (#C0AE),a
ld (#D0F2),a
ld (#D151),a
ld (#F142),a
ld (#F14F),a
ld (#F1F2),a
ld (#C235),a
ld (#D238),a
ld (#E293),a
ld a,#5C
ld (#D14B),a
ld a,#62
ld (#D013),a
ld (#C057),a
ld (#C1EF),a
ld (#C2D1),a
ld a,#63
ld (#E001),a
ld a,#6A
ld (#D056),a
ld (#F0F1),a
ld (#E1EE),a
ld a,#6E
ld (#E1ED),a
ld a,#72
ld (#E23A),a
ld a,#73
ld (#E14B),a
ld a,#7A
ld (#D0A1),a
ld (#D0FA),a
ld (#E140),a
ld a,#88
ld (#D0A9),a
ld a,#8A
ld (#D006),a
ld (#D100),a
ld (#F1E9),a
ld (#C233),a
ld (#E290),a
ld (#D2DE),a
ld a,#8B
ld (#F0F5),a
ld a,#8E
ld (#C0F6),a
ld a,#98
ld (#D001),a
ld (#D00F),a
ld (#D062),a
ld (#E0AA),a
ld (#E0FB),a
ld (#C147),a
ld (#E14C),a
ld (#E23E),a
ld a,#99
ld (#C291),a
ld a,#9A
ld (#D190),a
ld (#E197),a
ld (#C281),a
ld (#F2E2),a
ld a,#9C
ld (#F1ED),a
ld a,#AA
ld (#D005),a
ld (#C1E5),a
ld a,#BA
ld (#D011),a
ld (#D0A2),a
ld (#E196),a
ld (#F198),a
ld a,#C8
ld (#F006),a
ld a,#CA
ld (#E1E8),a
ld (#E280),a
ld a,#CB
ld (#F0A4),a
ld a,#D8
ld (#C05B),a
ld (#C14E),a
ld (#E23B),a
ld (#F241),a
ld (#F2D2),a
ld a,#DA
ld (#D009),a
ld (#C0B2),a
ld (#E152),a
ld (#D287),a
ld (#E289),a
ld (#F2D7),a
ld a,#DE
ld (#F0F7),a
ld a,#EA
ld (#E23F),a
ld a,#FA
ld (#F1A0),a
ld (#E1E7),a
ld (#E238),a
ld (#D28B),a
ld (#C2DC),a
ld (#D2D8),a
ld (#F2D6),a
ld a,#FE
ld (#C198),a
ld a,#FF
ld (#E19C),a
ret

p26to27
ld a,#00
ld (#D00C),a
ld (#F00E),a
ld (#C050),a
ld (#C054),a
ld (#C05E),a
ld (#C05F),a
ld (#E0B0),a
ld (#F0A1),a
ld (#D101),a
ld (#F0FC),a
ld (#C141),a
ld (#F141),a
ld (#F143),a
ld (#F144),a
ld (#F146),a
ld (#F152),a
ld (#D192),a
ld (#D193),a
ld (#E190),a
ld (#F1A2),a
ld (#E1E1),a
ld (#E1E9),a
ld (#E1F2),a
ld (#C242),a
ld (#D231),a
ld (#E235),a
ld (#D292),a
ld (#C2DE),a
ld (#D2DD),a
ld (#E2D4),a
ld a,#01
ld (#C002),a
ld (#C005),a
ld (#E005),a
ld (#F00D),a
ld (#C063),a
ld (#D054),a
ld (#D058),a
ld (#D0AC),a
ld (#D103),a
ld (#F0FB),a
ld (#F140),a
ld (#C191),a
ld (#C284),a
ld (#D281),a
ld (#D2D5),a
ld a,#02
ld (#C00F),a
ld (#C056),a
ld (#C061),a
ld (#E05E),a
ld (#C0AD),a
ld (#E0A6),a
ld (#C146),a
ld (#C153),a
ld (#C19E),a
ld (#C239),a
ld (#F230),a
ld (#C293),a
ld (#E28B),a
ld (#F2D1),a
ld a,#04
ld (#D000),a
ld (#D007),a
ld (#E00E),a
ld (#D0AD),a
ld (#E0A1),a
ld (#E0B1),a
ld (#D0FE),a
ld (#F0F3),a
ld (#D1E4),a
ld (#D23D),a
ld (#F240),a
ld a,#05
ld (#C05A),a
ld (#E0A0),a
ld (#E1A1),a
ld (#C28D),a
ld (#F28B),a
ld a,#06
ld (#E007),a
ld a,#07
ld (#E2D5),a
ld a,#08
ld (#C010),a
ld (#C1F0),a
ld (#F1F3),a
ld (#F23D),a
ld (#C2D5),a
ld a,#09
ld (#F0F5),a
ld (#E1A0),a
ld a,#0A
ld (#D006),a
ld (#F005),a
ld (#F00F),a
ld (#D055),a
ld (#E1A2),a
ld (#D1E3),a
ld (#C233),a
ld (#D288),a
ld (#D2D4),a
ld (#D2D9),a
ld (#E2D6),a
ld (#F2DE),a
ld a,#0B
ld (#C009),a
ld (#D00A),a
ld (#E001),a
ld (#F0AA),a
ld (#D100),a
ld (#F14D),a
ld (#C291),a
ld a,#0C
ld (#E052),a
ld (#E2DE),a
ld a,#0D
ld (#C00E),a
ld a,#10
ld (#E00F),a
ld (#F011),a
ld (#E05C),a
ld (#E063),a
ld (#E0AD),a
ld (#F0B2),a
ld (#C0F7),a
ld (#C100),a
ld (#D0F1),a
ld (#E102),a
ld (#F0FD),a
ld (#D140),a
ld (#E191),a
ld (#F192),a
ld (#F19F),a
ld (#C1E9),a
ld (#C1EC),a
ld (#F1EC),a
ld (#D237),a
ld (#F234),a
ld (#E291),a
ld (#D2D6),a
ld a,#12
ld (#C0A6),a
ld (#D0AE),a
ld (#E0B3),a
ld (#C0FE),a
ld (#D1A1),a
ld (#C28A),a
ld (#F28C),a
ld (#D2D0),a
ld a,#13
ld (#E0F3),a
ld a,#14
ld (#C013),a
ld (#D0A6),a
ld a,#18
ld (#D05A),a
ld (#E0AA),a
ld (#D190),a
ld (#F1F0),a
ld (#E232),a
ld (#F23B),a
ld (#F281),a
ld (#E2D1),a
ld a,#19
ld (#F1EF),a
ld a,#1A
ld (#D00E),a
ld (#D0A0),a
ld (#E140),a
ld (#E152),a
ld (#F153),a
ld (#D1E5),a
ld (#C230),a
ld (#C243),a
ld (#E284),a
ld (#D2DF),a
ld a,#1C
ld (#F056),a
ld (#E0F7),a
ld (#F1ED),a
ld a,#1E
ld (#F0A6),a
ld a,#22
ld (#E006),a
ld (#F063),a
ld (#C1EF),a
ld (#E282),a
ld (#E28E),a
ld (#C2DD),a
ld (#E2DD),a
ld (#F2DD),a
ld a,#23
ld (#F0F6),a
ld a,#26
ld (#D004),a
ld (#C0A5),a
ld (#E0A3),a
ld a,#2A
ld (#C006),a
ld (#D005),a
ld (#F008),a
ld (#D0A2),a
ld (#D150),a
ld (#F23A),a
ld (#D2DE),a
ld a,#32
ld (#E0F4),a
ld a,#36
ld (#F291),a
ld a,#3A
ld (#D236),a
ld (#F28E),a
ld (#F2D6),a
ld a,#40
ld (#E057),a
ld (#F058),a
ld (#C0A0),a
ld (#C0A1),a
ld (#E0A9),a
ld (#F0A0),a
ld (#F0B1),a
ld (#C0FA),a
ld (#E103),a
ld (#C152),a
ld (#D14E),a
ld (#D1A0),a
ld (#E195),a
ld (#E19F),a
ld (#F190),a
ld (#E1F1),a
ld (#F1E8),a
ld (#D230),a
ld (#E23D),a
ld (#F237),a
ld (#F239),a
ld (#C283),a
ld (#F28A),a
ld (#C2D4),a
ld (#D2E2),a
ld (#F2D4),a
ld a,#41
ld (#C004),a
ld (#C012),a
ld (#F0A9),a
ld (#D0FD),a
ld (#C197),a
ld (#E28D),a
ld a,#42
ld (#D056),a
ld (#D057),a
ld (#E055),a
ld (#C102),a
ld (#F0F0),a
ld (#F1E1),a
ld (#C2D8),a
ld (#C2DB),a
ld a,#45
ld (#C0AB),a
ld (#C0FC),a
ld a,#48
ld (#C00A),a
ld (#C05B),a
ld (#C0AC),a
ld (#F2DF),a
ld a,#4A
ld (#D00D),a
ld (#C0FF),a
ld (#C1E5),a
ld (#D1E0),a
ld (#C236),a
ld (#C287),a
ld (#F283),a
ld (#C2DF),a
ld a,#50
ld (#E008),a
ld (#E00B),a
ld (#D061),a
ld (#F050),a
ld (#F051),a
ld (#F054),a
ld (#E0AE),a
ld (#E0B2),a
ld (#F0AC),a
ld (#C0F0),a
ld (#D0F2),a
ld (#E0F9),a
ld (#F0FE),a
ld (#F101),a
ld (#E142),a
ld (#F150),a
ld (#C190),a
ld (#D1A3),a
ld (#F194),a
ld (#C1E1),a
ld (#C1F1),a
ld (#C1F2),a
ld (#D1E1),a
ld (#D1ED),a
ld (#D1F0),a
ld (#D1F3),a
ld (#F1E3),a
ld (#F1EE),a
ld (#E23C),a
ld (#E240),a
ld (#C28C),a
ld (#D280),a
ld (#F288),a
ld (#D2D3),a
ld (#E2DA),a
ld a,#52
ld (#D013),a
ld (#F102),a
ld (#C235),a
ld (#D28C),a
ld a,#56
ld (#D14B),a
ld a,#58
ld (#F003),a
ld (#D05E),a
ld (#E053),a
ld (#F0A7),a
ld (#D0F3),a
ld (#C143),a
ld (#C14E),a
ld (#E141),a
ld (#E1A3),a
ld (#C1E6),a
ld (#E1EF),a
ld (#E285),a
ld (#E289),a
ld (#F286),a
ld (#F292),a
ld (#D2E1),a
ld (#E2DF),a
ld a,#5A
ld (#C0B2),a
ld (#D0A1),a
ld (#C142),a
ld a,#62
ld (#E058),a
ld (#F055),a
ld (#C240),a
ld (#E2D0),a
ld a,#6A
ld (#F232),a
ld (#C2DC),a
ld a,#72
ld (#F007),a
ld (#F057),a
ld a,#7A
ld (#D011),a
ld (#F1F1),a
ld (#F2E2),a
ld a,#7F
ld (#E19C),a
ld a,#88
ld (#D062),a
ld (#E2E1),a
ld a,#8A
ld (#C059),a
ld (#D151),a
ld (#F1F2),a
ld (#D28F),a
ld (#E280),a
ld (#D2E3),a
ld a,#8B
ld (#C055),a
ld (#F0A4),a
ld (#F1E9),a
ld (#D28E),a
ld (#D2DC),a
ld a,#8C
ld (#C2E2),a
ld a,#98
ld (#F013),a
ld (#E146),a
ld (#C281),a
ld a,#99
ld (#F19E),a
ld a,#9A
ld (#D009),a
ld (#D00F),a
ld a,#9C
ld (#F0F7),a
ld (#F19C),a
ld (#E23E),a
ld a,#9E
ld (#C198),a
ld a,#AA
ld (#C00D),a
ld (#D051),a
ld (#C194),a
ld (#E239),a
ld (#D289),a
ld (#E290),a
ld a,#BA
ld (#E145),a
ld (#D287),a
ld a,#BE
ld (#F198),a
ld a,#CA
ld (#E05F),a
ld a,#CC
ld (#C0A9),a
ld a,#D8
ld (#C103),a
ld (#C19F),a
ld (#D23A),a
ld (#F23E),a
ld a,#DA
ld (#F1A0),a
ld a,#EA
ld (#F053),a
ld (#F0F1),a
ld (#E196),a
ld (#E1E8),a
ld a,#FA
ld (#D050),a
ld (#D238),a
ret

p27to28
ld a,#00
ld (#C009),a
ld (#E007),a
ld (#C061),a
ld (#D05C),a
ld (#E050),a
ld (#E062),a
ld (#D0AD),a
ld (#E0A0),a
ld (#E0A1),a
ld (#E0B3),a
ld (#F0A5),a
ld (#F0B2),a
ld (#D103),a
ld (#E144),a
ld (#C192),a
ld (#C1A3),a
ld (#D1A0),a
ld (#E1A1),a
ld (#C1F3),a
ld (#E1E4),a
ld (#C241),a
ld (#D235),a
ld (#F234),a
ld (#F23D),a
ld (#C284),a
ld (#D281),a
ld (#F280),a
ld (#C2E3),a
ld a,#01
ld (#E00D),a
ld (#E0A2),a
ld (#C0F5),a
ld (#D0FD),a
ld (#E0F3),a
ld (#F1F3),a
ld a,#02
ld (#E006),a
ld (#C054),a
ld (#D055),a
ld (#E055),a
ld (#F059),a
ld (#F05F),a
ld (#E101),a
ld (#F0F0),a
ld (#D192),a
ld (#F1A3),a
ld (#E231),a
ld (#C28D),a
ld (#E28E),a
ld (#C2D4),a
ld (#D2D2),a
ld (#E2DD),a
ld a,#03
ld (#C004),a
ld (#F0FB),a
ld (#C191),a
ld (#E28A),a
ld a,#04
ld (#C002),a
ld (#C013),a
ld (#D00B),a
ld (#D00C),a
ld (#C053),a
ld (#E052),a
ld (#D14F),a
ld (#C19E),a
ld (#E190),a
ld a,#05
ld (#C005),a
ld (#D007),a
ld (#E00E),a
ld (#D05B),a
ld (#D193),a
ld (#F240),a
ld (#C292),a
ld a,#06
ld (#D000),a
ld (#F00E),a
ld a,#08
ld (#C05B),a
ld (#D054),a
ld (#D05A),a
ld (#D0A9),a
ld (#E0F0),a
ld (#F0F2),a
ld (#E1A0),a
ld (#F191),a
ld (#E2DE),a
ld a,#09
ld (#C00E),a
ld (#E001),a
ld (#C05F),a
ld (#F28B),a
ld (#E2D5),a
ld a,#0A
ld (#D003),a
ld (#D00D),a
ld (#D00E),a
ld (#D00F),a
ld (#C05E),a
ld (#C0AD),a
ld (#F0A1),a
ld (#C0FF),a
ld (#D100),a
ld (#C150),a
ld (#D150),a
ld (#D151),a
ld (#E152),a
ld (#D1E0),a
ld (#E1F1),a
ld (#F1F2),a
ld (#E239),a
ld (#C2D5),a
ld (#D2E3),a
ld (#E2E1),a
ld (#F2DD),a
ld a,#0B
ld (#D2D5),a
ld (#D2DA),a
ld a,#0C
ld (#E012),a
ld (#E2D6),a
ld a,#0D
ld (#F0F5),a
ld a,#0E
ld (#D004),a
ld a,#10
ld (#C011),a
ld (#E008),a
ld (#C058),a
ld (#E059),a
ld (#E061),a
ld (#D0A5),a
ld (#D0AB),a
ld (#F0A2),a
ld (#F0AB),a
ld (#D0F0),a
ld (#E0FE),a
ld (#C151),a
ld (#D152),a
ld (#E151),a
ld (#E1E5),a
ld (#E1E9),a
ld (#E1F3),a
ld (#F1F0),a
ld (#C234),a
ld (#D231),a
ld (#E236),a
ld (#C28B),a
ld (#C28E),a
ld (#E287),a
ld (#F28D),a
ld (#C2D2),a
ld (#C2DA),a
ld (#C2E0),a
ld (#E2D1),a
ld a,#11
ld (#C1E8),a
ld (#E2DC),a
ld a,#12
ld (#C056),a
ld (#D0A0),a
ld (#D0FF),a
ld (#C1E4),a
ld (#C23D),a
ld (#D23E),a
ld a,#13
ld (#D058),a
ld a,#14
ld (#E00F),a
ld (#E1EC),a
ld (#D2D6),a
ld a,#16
ld (#F291),a
ld a,#18
ld (#D0B3),a
ld (#C147),a
ld (#E146),a
ld (#D194),a
ld (#D1E6),a
ld (#F1E2),a
ld (#C281),a
ld (#E2DF),a
ld a,#19
ld (#E005),a
ld a,#1A
ld (#C0B2),a
ld (#E0A6),a
ld (#C0FE),a
ld (#C193),a
ld (#E197),a
ld (#E282),a
ld (#F285),a
ld (#D2E0),a
ld a,#1C
ld (#D0A6),a
ld a,#1E
ld (#D2DF),a
ld a,#22
ld (#F055),a
ld (#C240),a
ld (#F2D1),a
ld a,#23
ld (#C291),a
ld a,#2A
ld (#F002),a
ld (#C055),a
ld (#E284),a
ld a,#2E
ld (#C0A5),a
ld a,#2F
ld (#E1ED),a
ld a,#32
ld (#F007),a
ld (#C1EF),a
ld (#C28A),a
ld a,#33
ld (#F0F6),a
ld a,#3A
ld (#D011),a
ld (#E0F4),a
ld (#C142),a
ld (#F153),a
ld (#D1A1),a
ld (#D1E5),a
ld (#F2E2),a
ld a,#3E
ld (#F1ED),a
ld a,#40
ld (#C012),a
ld (#F012),a
ld (#C052),a
ld (#D0B2),a
ld (#F0A9),a
ld (#C0FD),a
ld (#F0F4),a
ld (#C140),a
ld (#D153),a
ld (#F143),a
ld (#F145),a
ld (#C190),a
ld (#D19F),a
ld (#D1E8),a
ld (#F1E6),a
ld (#E286),a
ld (#E28D),a
ld (#C2D8),a
ld (#D2D1),a
ld (#D2D3),a
ld (#F2DB),a
ld a,#41
ld (#D14E),a
ld (#D230),a
ld (#E28C),a
ld a,#42
ld (#D013),a
ld (#F102),a
ld (#E1E6),a
ld (#C236),a
ld (#E23D),a
ld (#C287),a
ld (#F2D4),a
ld a,#43
ld (#C2D1),a
ld a,#45
ld (#C14D),a
ld a,#46
ld (#D14B),a
ld a,#48
ld (#F006),a
ld (#C060),a
ld (#E051),a
ld (#E056),a
ld (#C2D9),a
ld a,#4A
ld (#F060),a
ld (#D0A2),a
ld (#F0A0),a
ld (#F0F1),a
ld (#F1A1),a
ld (#C2DC),a
ld a,#50
ld (#C003),a
ld (#E00A),a
ld (#F003),a
ld (#C05D),a
ld (#D052),a
ld (#E053),a
ld (#E05C),a
ld (#F058),a
ld (#C0A0),a
ld (#C0A1),a
ld (#C0A6),a
ld (#C0A7),a
ld (#E0A4),a
ld (#E0AD),a
ld (#F0B3),a
ld (#C102),a
ld (#D0F1),a
ld (#D0F3),a
ld (#D102),a
ld (#E0F5),a
ld (#E0FF),a
ld (#C152),a
ld (#D140),a
ld (#E141),a
ld (#E143),a
ld (#F142),a
ld (#F151),a
ld (#C1A2),a
ld (#F19B),a
ld (#C1E9),a
ld (#C235),a
ld (#C23C),a
ld (#D242),a
ld (#E230),a
ld (#F237),a
ld (#F23F),a
ld (#D28D),a
ld (#E288),a
ld (#E289),a
ld (#E293),a
ld (#C2E1),a
ld (#E2D9),a
ld (#E2E0),a
ld a,#52
ld (#C00C),a
ld (#F057),a
ld (#D0AE),a
ld (#C0FA),a
ld (#C14F),a
ld (#C1E1),a
ld (#D1E2),a
ld (#E237),a
ld (#F242),a
ld (#F28C),a
ld a,#55
ld (#C0AB),a
ld (#C0FC),a
ld a,#58
ld (#D0AA),a
ld (#D0F7),a
ld (#E153),a
ld (#F14F),a
ld (#C195),a
ld (#C19F),a
ld (#D190),a
ld (#D1A2),a
ld (#C1E0),a
ld (#C1F0),a
ld (#D1E7),a
ld (#D23A),a
ld (#E23B),a
ld (#E240),a
ld (#F241),a
ld (#C2D7),a
ld (#E2D7),a
ld (#F2DF),a
ld a,#5A
ld (#E05F),a
ld (#F1A0),a
ld (#C232),a
ld (#C243),a
ld (#E23A),a
ld (#F243),a
ld a,#62
ld (#F063),a
ld (#C2DB),a
ld (#C2DD),a
ld a,#63
ld (#E2D0),a
ld a,#6A
ld (#C194),a
ld (#E290),a
ld a,#6E
ld (#F19C),a
ld a,#72
ld (#C057),a
ld (#C280),a
ld a,#77
ld (#E19C),a
ld a,#7A
ld (#E1E8),a
ld (#E1EE),a
ld (#F232),a
ld a,#88
ld (#C010),a
ld (#F1E9),a
ld a,#89
ld (#F0A4),a
ld (#C2E2),a
ld a,#8A
ld (#D009),a
ld (#F053),a
ld (#C1E2),a
ld (#F28E),a
ld a,#8B
ld (#F0AA),a
ld (#F19E),a
ld a,#8C
ld (#C0A9),a
ld a,#98
ld (#C0F6),a
ld (#F23E),a
ld (#D2D0),a
ld a,#9A
ld (#D005),a
ld (#F005),a
ld (#D062),a
ld (#C143),a
ld (#E19D),a
ld (#C230),a
ld (#D237),a
ld a,#9C
ld (#E0F7),a
ld a,#9E
ld (#F0A6),a
ld (#F198),a
ld (#E23E),a
ld a,#AA
ld (#F008),a
ld (#D288),a
ld (#E28B),a
ld (#D2D9),a
ld a,#AE
ld (#F147),a
ld a,#BA
ld (#D051),a
ld a,#CA
ld (#D2DC),a
ld a,#D8
ld (#D001),a
ld (#F0A7),a
ld (#E1A3),a
ld (#F23B),a
ld (#F281),a
ld (#F286),a
ld (#F292),a
ld a,#DA
ld (#C008),a
ld (#E285),a
ld a,#DC
ld (#C198),a
ld a,#EA
ld (#C00D),a
ld (#E145),a
ld (#D2D8),a
ld a,#FA
ld (#F1F1),a
ld (#D287),a
ld (#F2D7),a
ret

p28to29
ld a,#00
ld (#C00A),a
ld (#C00E),a
ld (#D00B),a
ld (#D00C),a
ld (#E00E),a
ld (#C058),a
ld (#C063),a
ld (#E060),a
ld (#F050),a
ld (#F05F),a
ld (#D0AB),a
ld (#C0FD),a
ld (#D0FE),a
ld (#D100),a
ld (#E101),a
ld (#F0F0),a
ld (#F0F3),a
ld (#C140),a
ld (#D141),a
ld (#D142),a
ld (#E14F),a
ld (#F140),a
ld (#F14E),a
ld (#D1E4),a
ld (#D1F1),a
ld (#E1E0),a
ld (#E1E5),a
ld (#E236),a
ld (#C292),a
ld (#C2D1),a
ld (#D2D3),a
ld (#D2E3),a
ld (#F2DC),a
ld a,#01
ld (#E005),a
ld (#E00C),a
ld (#C05A),a
ld (#C05B),a
ld (#F061),a
ld (#C0AA),a
ld (#C0AC),a
ld (#E0B3),a
ld (#F0A5),a
ld (#D14E),a
ld (#D230),a
ld (#D234),a
ld (#F240),a
ld (#C2DE),a
ld (#D2DD),a
ld (#E2DE),a
ld a,#02
ld (#E00F),a
ld (#C0F5),a
ld (#D103),a
ld (#E1A2),a
ld (#C1EF),a
ld (#F234),a
ld (#D286),a
ld (#F284),a
ld (#D2DE),a
ld (#E2D5),a
ld (#F2DE),a
ld a,#03
ld (#D058),a
ld (#F14C),a
ld a,#04
ld (#C005),a
ld (#E007),a
ld (#C05C),a
ld (#D0AC),a
ld (#F0A2),a
ld (#E102),a
ld (#C141),a
ld (#D1E9),a
ld (#C285),a
ld (#D281),a
ld (#F291),a
ld (#D2D6),a
ld (#E2D6),a
ld a,#05
ld (#E001),a
ld (#E00D),a
ld (#C0A4),a
ld (#D0FD),a
ld (#F0F5),a
ld (#C19E),a
ld (#E1F2),a
ld a,#06
ld (#C004),a
ld (#C053),a
ld (#D05B),a
ld (#F059),a
ld (#D1A0),a
ld (#C239),a
ld (#E28A),a
ld (#D2DF),a
ld a,#08
ld (#E012),a
ld (#E051),a
ld (#D1E0),a
ld (#E1F3),a
ld (#C241),a
ld (#D284),a
ld (#D28E),a
ld (#E280),a
ld (#F28B),a
ld a,#09
ld (#D151),a
ld (#E1F1),a
ld (#F233),a
ld a,#0A
ld (#D004),a
ld (#C055),a
ld (#C060),a
ld (#F060),a
ld (#E0B0),a
ld (#F14D),a
ld (#C191),a
ld (#D192),a
ld (#C1E2),a
ld (#E283),a
ld (#E284),a
ld (#E285),a
ld (#C2D6),a
ld (#D2E0),a
ld a,#0B
ld (#D00D),a
ld (#F0AA),a
ld (#C2E2),a
ld a,#0C
ld (#C013),a
ld a,#0D
ld (#F0A4),a
ld a,#0E
ld (#D006),a
ld (#C0A5),a
ld a,#10
ld (#C056),a
ld (#F056),a
ld (#F062),a
ld (#D0A0),a
ld (#D0B0),a
ld (#E0B2),a
ld (#C14B),a
ld (#D143),a
ld (#E146),a
ld (#E150),a
ld (#E153),a
ld (#D1F2),a
ld (#E1EC),a
ld (#D23D),a
ld (#F230),a
ld (#E2D7),a
ld (#E2E2),a
ld a,#12
ld (#D011),a
ld (#E140),a
ld (#C193),a
ld (#D28A),a
ld (#D2D7),a
ld (#D2DB),a
ld a,#13
ld (#F0FB),a
ld a,#14
ld (#E063),a
ld (#F19F),a
ld (#C28E),a
ld a,#15
ld (#C0AB),a
ld (#E2DC),a
ld a,#16
ld (#E059),a
ld (#F2D6),a
ld a,#18
ld (#E008),a
ld (#D0A6),a
ld (#E0F0),a
ld (#F103),a
ld (#E1E1),a
ld (#E1E9),a
ld (#F241),a
ld (#E28F),a
ld (#E291),a
ld (#F2DF),a
ld a,#1A
ld (#E0AA),a
ld (#C14F),a
ld (#D150),a
ld (#D194),a
ld (#E2DF),a
ld a,#1C
ld (#F23E),a
ld a,#22
ld (#F00E),a
ld (#C28A),a
ld (#F2D4),a
ld a,#23
ld (#C054),a
ld a,#26
ld (#E052),a
ld (#F055),a
ld a,#2A
ld (#D051),a
ld (#C0AD),a
ld (#D1A1),a
ld (#D1E5),a
ld (#F1ED),a
ld a,#2E
ld (#F19C),a
ld a,#32
ld (#C006),a
ld (#C23D),a
ld a,#33
ld (#E1ED),a
ld a,#36
ld (#F2E2),a
ld a,#37
ld (#E19C),a
ld a,#3A
ld (#D062),a
ld (#E0A3),a
ld (#C0FE),a
ld (#E23F),a
ld (#F23A),a
ld (#F285),a
ld a,#3B
ld (#F0F6),a
ld a,#40
ld (#C009),a
ld (#D013),a
ld (#E004),a
ld (#F004),a
ld (#E05D),a
ld (#E062),a
ld (#F058),a
ld (#F05E),a
ld (#E0A5),a
ld (#F0A3),a
ld (#C102),a
ld (#E0F6),a
ld (#E144),a
ld (#E193),a
ld (#F195),a
ld (#F1A1),a
ld (#C1F3),a
ld (#E1F0),a
ld (#C236),a
ld (#C287),a
ld (#D285),a
ld (#E28C),a
ld (#F283),a
ld (#C2D3),a
ld (#C2D9),a
ld a,#41
ld (#C14A),a
ld (#D239),a
ld a,#42
ld (#E058),a
ld (#F063),a
ld (#E195),a
ld (#F197),a
ld (#C1E5),a
ld (#F28C),a
ld (#C2DF),a
ld a,#43
ld (#E2D0),a
ld a,#48
ld (#D0A2),a
ld (#C14E),a
ld a,#4A
ld (#C194),a
ld (#F2DD),a
ld a,#50
ld (#C000),a
ld (#E002),a
ld (#F000),a
ld (#D056),a
ld (#E05B),a
ld (#C0B3),a
ld (#D0A1),a
ld (#D0A5),a
ld (#D0F0),a
ld (#D0FF),a
ld (#E0FA),a
ld (#C147),a
ld (#E151),a
ld (#F143),a
ld (#F14F),a
ld (#F152),a
ld (#C190),a
ld (#E191),a
ld (#F192),a
ld (#C1E0),a
ld (#C1E4),a
ld (#F1E0),a
ld (#F1E6),a
ld (#F1EA),a
ld (#C242),a
ld (#D241),a
ld (#D243),a
ld (#E232),a
ld (#C28B),a
ld (#D282),a
ld (#D28C),a
ld (#D290),a
ld (#F290),a
ld (#D2E2),a
ld a,#52
ld (#E006),a
ld (#C057),a
ld (#E1E6),a
ld (#C243),a
ld (#C2DD),a
ld (#E2DD),a
ld a,#53
ld (#E14B),a
ld (#C197),a
ld a,#55
ld (#C14D),a
ld a,#58
ld (#D001),a
ld (#D012),a
ld (#F006),a
ld (#F009),a
ld (#E056),a
ld (#F05A),a
ld (#C0A6),a
ld (#C0F2),a
ld (#D0FB),a
ld (#C144),a
ld (#D195),a
ld (#F1A0),a
ld (#F1E2),a
ld (#F292),a
ld (#F2D2),a
ld a,#5A
ld (#D050),a
ld (#D05E),a
ld (#D05F),a
ld (#C0F1),a
ld (#F0F1),a
ld (#F1F1),a
ld (#D28B),a
ld a,#62
ld (#F1E1),a
ld (#C280),a
ld (#C291),a
ld a,#6A
ld (#F232),a
ld a,#72
ld (#C00C),a
ld (#C0FA),a
ld a,#7A
ld (#F242),a
ld (#D287),a
ld a,#88
ld (#D0B3),a
ld a,#8A
ld (#C007),a
ld (#D005),a
ld (#C05E),a
ld (#C0FF),a
ld (#D1A2),a
ld (#C233),a
ld (#F243),a
ld (#D2D4),a
ld a,#8B
ld (#D00F),a
ld (#F1EF),a
ld a,#98
ld (#C0A9),a
ld (#E0A6),a
ld (#E0F7),a
ld (#F0F7),a
ld (#C230),a
ld (#F23B),a
ld a,#9A
ld (#F00F),a
ld (#F0A6),a
ld (#E0FB),a
ld a,#9C
ld (#E14C),a
ld (#C198),a
ld (#F198),a
ld a,#9E
ld (#E19D),a
ld a,#AA
ld (#D009),a
ld (#E0F4),a
ld (#F19E),a
ld (#D2D5),a
ld (#F2D5),a
ld a,#AE
ld (#E23E),a
ld a,#BA
ld (#D000),a
ld (#E1EE),a
ld (#D288),a
ld a,#C9
ld (#D2DC),a
ld a,#CA
ld (#C00D),a
ld (#F008),a
ld (#D0AF),a
ld (#C2DC),a
ld a,#D8
ld (#E1EF),a
ld (#E240),a
ld a,#DA
ld (#C103),a
ld (#E1A3),a
ld (#D1E6),a
ld (#E238),a
ld (#E282),a
ld (#F286),a
ld a,#EA
ld (#F002),a
ld (#F0A0),a
ld (#C143),a
ld a,#FA
ld (#F013),a
ld (#D237),a
ret

p29to30
ld a,#00
ld (#C005),a
ld (#E005),a
ld (#E00F),a
ld (#F00D),a
ld (#F010),a
ld (#C05A),a
ld (#C05C),a
ld (#D05B),a
ld (#E05E),a
ld (#C0AF),a
ld (#C0F0),a
ld (#D103),a
ld (#C141),a
ld (#C14E),a
ld (#C151),a
ld (#D14F),a
ld (#D152),a
ld (#D193),a
ld (#D198),a
ld (#E190),a
ld (#E193),a
ld (#E194),a
ld (#E1A0),a
ld (#F1A3),a
ld (#C1EF),a
ld (#D1E0),a
ld (#D1E9),a
ld (#E1F2),a
ld (#F1F3),a
ld (#D230),a
ld (#D234),a
ld (#E243),a
ld (#C293),a
ld (#D285),a
ld (#C2D9),a
ld a,#01
ld (#C00A),a
ld (#C058),a
ld (#C061),a
ld (#E051),a
ld (#F05E),a
ld (#C0A4),a
ld (#F0B2),a
ld (#D19F),a
ld (#F291),a
ld (#E2D0),a
ld a,#02
ld (#D00E),a
ld (#D011),a
ld (#C053),a
ld (#C060),a
ld (#C0AA),a
ld (#C0B2),a
ld (#D100),a
ld (#E152),a
ld (#F146),a
ld (#E1E0),a
ld (#C240),a
ld (#C285),a
ld (#D281),a
ld (#F280),a
ld (#D2D3),a
ld (#F2D4),a
ld a,#03
ld (#F0FB),a
ld (#F240),a
ld a,#04
ld (#D00C),a
ld (#E055),a
ld (#E063),a
ld (#F05F),a
ld (#D0FD),a
ld (#F0F5),a
ld (#D14E),a
ld (#D1A0),a
ld (#F19F),a
ld (#E28A),a
ld (#C2DE),a
ld (#E2DB),a
ld a,#05
ld (#C05B),a
ld (#C0AC),a
ld (#D142),a
ld (#C2E3),a
ld (#E2D6),a
ld (#E2DC),a
ld a,#06
ld (#D055),a
ld (#D14B),a
ld (#E28E),a
ld a,#07
ld (#C1E8),a
ld a,#08
ld (#D004),a
ld (#C05F),a
ld (#E05F),a
ld (#F061),a
ld (#F0A1),a
ld (#C150),a
ld (#D151),a
ld (#F14E),a
ld (#C1A1),a
ld (#D1A2),a
ld (#F19D),a
ld (#E1F1),a
ld (#F28E),a
ld (#E2D3),a
ld (#F2DC),a
ld a,#09
ld (#D00D),a
ld (#D284),a
ld (#D2DA),a
ld a,#0A
ld (#C010),a
ld (#D00A),a
ld (#E00E),a
ld (#E012),a
ld (#F00E),a
ld (#C059),a
ld (#D05A),a
ld (#D1A1),a
ld (#E1F3),a
ld (#C233),a
ld (#E242),a
ld (#F234),a
ld (#D28F),a
ld (#F284),a
ld (#C2D4),a
ld (#D2DF),a
ld a,#0B
ld (#C004),a
ld a,#0C
ld (#F0A4),a
ld a,#0D
ld (#D2D6),a
ld a,#0E
ld (#E283),a
ld a,#10
ld (#D008),a
ld (#C062),a
ld (#D059),a
ld (#F051),a
ld (#C0B0),a
ld (#D0AD),a
ld (#F103),a
ld (#C146),a
ld (#E140),a
ld (#E14F),a
ld (#F141),a
ld (#C193),a
ld (#D1A3),a
ld (#E233),a
ld (#F23D),a
ld (#F241),a
ld (#D290),a
ld (#E280),a
ld a,#12
ld (#C006),a
ld (#D006),a
ld (#F007),a
ld (#C142),a
ld (#E1A2),a
ld (#E287),a
ld a,#13
ld (#F0A5),a
ld a,#14
ld (#F1F0),a
ld a,#15
ld (#C19E),a
ld a,#16
ld (#F2E2),a
ld a,#18
ld (#D010),a
ld (#F006),a
ld (#D060),a
ld (#F05A),a
ld (#C0F6),a
ld (#F191),a
ld (#C230),a
ld a,#19
ld (#F0AA),a
ld a,#1A
ld (#D143),a
ld (#E1A3),a
ld (#D1F2),a
ld (#D236),a
ld (#F23E),a
ld (#F2DF),a
ld a,#1C
ld (#E1E9),a
ld a,#1E
ld (#F005),a
ld (#F055),a
ld a,#22
ld (#C054),a
ld (#E052),a
ld (#D194),a
ld (#C23D),a
ld (#C291),a
ld (#E290),a
ld a,#23
ld (#D058),a
ld (#F1ED),a
ld a,#26
ld (#F19C),a
ld a,#2A
ld (#C00E),a
ld (#D009),a
ld (#F060),a
ld (#C0F1),a
ld (#F14D),a
ld (#C2D5),a
ld (#C2E2),a
ld (#F2D1),a
ld a,#2B
ld (#F1EF),a
ld a,#2E
ld (#E23E),a
ld a,#32
ld (#D062),a
ld (#D1E5),a
ld (#D2DB),a
ld (#E2DF),a
ld a,#33
ld (#C197),a
ld (#E19C),a
ld a,#3A
ld (#D000),a
ld (#F00F),a
ld (#F013),a
ld (#D05F),a
ld (#C0AD),a
ld (#E0AA),a
ld (#C103),a
ld (#E197),a
ld (#E231),a
ld (#D2D2),a
ld a,#3F
ld (#F0F6),a
ld a,#40
ld (#C001),a
ld (#F00C),a
ld (#C050),a
ld (#C063),a
ld (#F063),a
ld (#D0A5),a
ld (#D0A9),a
ld (#E0F3),a
ld (#F0F2),a
ld (#F102),a
ld (#C14A),a
ld (#F144),a
ld (#C1A3),a
ld (#F1A2),a
ld (#C1E5),a
ld (#D1F0),a
ld (#D239),a
ld (#D280),a
ld (#F28C),a
ld (#C2DF),a
ld a,#41
ld (#E004),a
ld (#E0F6),a
ld (#E14B),a
ld (#F239),a
ld (#D2DD),a
ld a,#42
ld (#F004),a
ld (#C153),a
ld (#F153),a
ld (#F190),a
ld (#D283),a
ld (#D2DE),a
ld (#E2DD),a
ld a,#43
ld (#C280),a
ld a,#44
ld (#E001),a
ld (#F059),a
ld a,#46
ld (#C239),a
ld a,#48
ld (#E000),a
ld (#C19F),a
ld (#C1E2),a
ld a,#4A
ld (#D05E),a
ld (#C143),a
ld (#F1F2),a
ld (#C232),a
ld a,#50
ld (#D001),a
ld (#D002),a
ld (#E011),a
ld (#E057),a
ld (#E061),a
ld (#C0A8),a
ld (#C0B1),a
ld (#D0A0),a
ld (#D0A2),a
ld (#D0B2),a
ld (#E0AC),a
ld (#E0F1),a
ld (#E0F2),a
ld (#E0FD),a
ld (#E0FE),a
ld (#E103),a
ld (#F0FD),a
ld (#E150),a
ld (#D190),a
ld (#F195),a
ld (#F1A0),a
ld (#F1A1),a
ld (#C1E3),a
ld (#C236),a
ld (#C237),a
ld (#C243),a
ld (#E237),a
ld (#E23B),a
ld (#C283),a
ld (#C287),a
ld (#C288),a
ld (#F28D),a
ld (#C2D2),a
ld (#C2D8),a
ld (#E2E3),a
ld (#F2D2),a
ld a,#52
ld (#C05D),a
ld (#F052),a
ld (#E0AF),a
ld (#D150),a
ld (#C190),a
ld (#D191),a
ld (#E238),a
ld a,#58
ld (#C0AE),a
ld (#E0F0),a
ld (#F0F1),a
ld (#D1F3),a
ld (#E23A),a
ld (#F235),a
ld (#E286),a
ld (#F281),a
ld (#F28F),a
ld (#F2D8),a
ld (#F2E3),a
ld a,#5A
ld (#C1A0),a
ld (#C1E1),a
ld a,#62
ld (#E23D),a
ld (#E2E1),a
ld a,#6A
ld (#D051),a
ld (#D2D8),a
ld a,#72
ld (#C057),a
ld (#E195),a
ld (#E1E6),a
ld (#D28A),a
ld a,#7A
ld (#D005),a
ld (#F1E1),a
ld (#F23A),a
ld a,#88
ld (#C0A9),a
ld a,#89
ld (#C013),a
ld a,#8A
ld (#D00F),a
ld (#F002),a
ld (#D0B3),a
ld (#F0A0),a
ld (#C191),a
ld (#D192),a
ld (#E196),a
ld (#E239),a
ld (#D289),a
ld (#C2D6),a
ld a,#8B
ld (#D003),a
ld a,#8C
ld (#F053),a
ld (#E14C),a
ld a,#8E
ld (#C0A5),a
ld a,#98
ld (#F0A6),a
ld (#C198),a
ld (#C241),a
ld (#F230),a
ld (#E28F),a
ld (#E291),a
ld a,#9A
ld (#E1EE),a
ld a,#9C
ld (#E008),a
ld a,#AA
ld (#C05E),a
ld (#C14F),a
ld (#E145),a
ld (#E1E7),a
ld (#D2D4),a
ld a,#BA
ld (#E0FB),a
ld a,#C8
ld (#C2DC),a
ld a,#CA
ld (#C0F2),a
ld (#E282),a
ld (#F2D5),a
ld (#F2DD),a
ld a,#D8
ld (#D012),a
ld (#F009),a
ld (#E056),a
ld (#C0A6),a
ld (#D0AA),a
ld (#D0F7),a
ld (#D0FB),a
ld (#D1E7),a
ld (#C2D7),a
ld (#D2D0),a
ld a,#DA
ld (#D195),a
ld a,#EA
ld (#E0F4),a
ld (#F19E),a
ld a,#EE
ld (#F147),a
ld a,#FA
ld (#C008),a
ld (#D1E6),a
ld (#F242),a
ld (#D288),a
ret
finc0


;;;;;;;;;;;;;;;;;;;;;;;;;;; bank c4
bank 4
org #4000
p30to31
ld a,#00
ld (#D00E),a
ld (#D054),a
ld (#F05F),a
ld (#C0AA),a
ld (#C0B0),a
ld (#C0B2),a
ld (#D0AC),a
ld (#E0A2),a
ld (#F0A2),a
ld (#C0FB),a
ld (#D0F1),a
ld (#D0FD),a
ld (#E102),a
ld (#F103),a
ld (#D14E),a
ld (#D151),a
ld (#E152),a
ld (#C19F),a
ld (#D1A0),a
ld (#E1F1),a
ld (#C234),a
ld (#C240),a
ld (#D239),a
ld (#D23D),a
ld (#D242),a
ld (#D286),a
ld (#C2DF),a
ld (#C2E3),a
ld (#E2DC),a
ld (#F2E2),a
ld a,#01
ld (#D00B),a
ld (#E05E),a
ld (#C0AB),a
ld (#C1EF),a
ld (#D1F0),a
ld (#D284),a
ld (#C2D4),a
ld a,#02
ld (#D00C),a
ld (#D058),a
ld (#C0AF),a
ld (#E0AF),a
ld (#C14E),a
ld (#D143),a
ld (#E1F3),a
ld (#E236),a
ld (#F234),a
ld (#C280),a
ld (#D283),a
ld (#D28E),a
ld (#E28E),a
ld a,#04
ld (#E00D),a
ld (#E05F),a
ld (#F051),a
ld (#F059),a
ld (#F0A4),a
ld (#C0F0),a
ld (#C0FD),a
ld (#D152),a
ld (#E153),a
ld (#E1E5),a
ld (#D230),a
ld (#E243),a
ld (#D285),a
ld (#C2D1),a
ld a,#05
ld (#E2D0),a
ld (#E2D4),a
ld a,#06
ld (#C002),a
ld (#E059),a
ld (#D1F1),a
ld a,#07
ld (#E284),a
ld a,#08
ld (#D00A),a
ld (#D00D),a
ld (#E000),a
ld (#E005),a
ld (#F00D),a
ld (#F010),a
ld (#E063),a
ld (#C0A9),a
ld (#E0B1),a
ld (#F140),a
ld (#E190),a
ld (#F19F),a
ld (#F233),a
ld (#C292),a
ld (#E2DE),a
ld a,#09
ld (#F061),a
ld (#D1A2),a
ld (#C233),a
ld (#E242),a
ld (#D2D6),a
ld a,#0A
ld (#D004),a
ld (#D00F),a
ld (#C053),a
ld (#D05E),a
ld (#F050),a
ld (#C140),a
ld (#D141),a
ld (#C191),a
ld (#E193),a
ld (#E1A3),a
ld (#F243),a
ld (#C284),a
ld (#C285),a
ld (#F285),a
ld (#D2D4),a
ld (#D2D5),a
ld (#F2D4),a
ld a,#0B
ld (#D05A),a
ld (#C0A4),a
ld (#D100),a
ld a,#0C
ld (#E00F),a
ld (#E055),a
ld (#F053),a
ld (#F1F0),a
ld (#E283),a
ld (#E285),a
ld (#E28A),a
ld (#F2DC),a
ld a,#0D
ld (#C05F),a
ld (#D142),a
ld (#E2D6),a
ld a,#10
ld (#D006),a
ld (#F006),a
ld (#D0A6),a
ld (#F0B3),a
ld (#D0F2),a
ld (#D0FE),a
ld (#E103),a
ld (#D14F),a
ld (#E143),a
ld (#C1A2),a
ld (#E1A1),a
ld (#D1E0),a
ld (#F1E3),a
ld (#C281),a
ld (#C293),a
ld (#E286),a
ld (#F292),a
ld (#F2D6),a
ld a,#11
ld (#F0FB),a
ld (#C19E),a
ld (#F291),a
ld a,#12
ld (#D1E5),a
ld (#E1E6),a
ld (#D236),a
ld (#E233),a
ld (#C28D),a
ld (#C28E),a
ld (#C2D5),a
ld a,#13
ld (#E1ED),a
ld a,#14
ld (#D055),a
ld (#E2D7),a
ld a,#15
ld (#C058),a
ld (#C0FC),a
ld a,#18
ld (#E060),a
ld (#D0AA),a
ld (#F0A6),a
ld (#F0AB),a
ld (#E0F7),a
ld (#F14E),a
ld (#D2E1),a
ld (#E2E2),a
ld a,#1A
ld (#C006),a
ld (#D05F),a
ld (#C0AD),a
ld (#C0FE),a
ld (#C103),a
ld (#F1E1),a
ld a,#1C
ld (#F005),a
ld a,#1D
ld (#C14D),a
ld a,#22
ld (#E012),a
ld (#F004),a
ld (#C059),a
ld (#C0F5),a
ld (#F23E),a
ld (#D281),a
ld (#F280),a
ld (#E2DF),a
ld a,#23
ld (#F14C),a
ld (#E23E),a
ld (#F240),a
ld a,#26
ld (#E001),a
ld (#C054),a
ld a,#27
ld (#D14B),a
ld (#F19C),a
ld a,#2A
ld (#D000),a
ld (#F00F),a
ld (#E0AA),a
ld (#C14F),a
ld (#D1F2),a
ld (#D28F),a
ld (#E28B),a
ld a,#32
ld (#C291),a
ld (#E290),a
ld a,#33
ld (#F0A5),a
ld (#F1ED),a
ld a,#3A
ld (#E052),a
ld (#D0B3),a
ld (#F293),a
ld (#F2DF),a
ld a,#3E
ld (#F013),a
ld a,#40
ld (#C003),a
ld (#F054),a
ld (#E0B3),a
ld (#D0F0),a
ld (#D0F6),a
ld (#D0FC),a
ld (#D103),a
ld (#E101),a
ld (#F0FF),a
ld (#E142),a
ld (#F1A3),a
ld (#F1F2),a
ld (#C231),a
ld (#E232),a
ld (#E241),a
ld (#F231),a
ld (#C283),a
ld (#C289),a
ld (#D2DD),a
ld (#E2DD),a
ld a,#41
ld (#E0A5),a
ld (#E0A9),a
ld (#C2D3),a
ld a,#42
ld (#E004),a
ld (#F052),a
ld (#C194),a
ld (#D1E8),a
ld (#F239),a
ld a,#43
ld (#F1E8),a
ld a,#44
ld (#C239),a
ld a,#46
ld (#C1E8),a
ld a,#48
ld (#F1E2),a
ld (#F1E9),a
ld (#F28E),a
ld (#C2DC),a
ld a,#49
ld (#F0AA),a
ld a,#4A
ld (#F008),a
ld (#F00E),a
ld (#D051),a
ld (#D1A1),a
ld (#F232),a
ld (#E282),a
ld (#C2DB),a
ld a,#50
ld (#C012),a
ld (#E006),a
ld (#C050),a
ld (#D057),a
ld (#E058),a
ld (#C0F7),a
ld (#C102),a
ld (#E0F0),a
ld (#F0F1),a
ld (#F0F2),a
ld (#C146),a
ld (#C153),a
ld (#D150),a
ld (#D153),a
ld (#E14E),a
ld (#E14F),a
ld (#C193),a
ld (#C19D),a
ld (#C1A3),a
ld (#E1A2),a
ld (#F1A2),a
ld (#C1E5),a
ld (#C1E6),a
ld (#C1F3),a
ld (#E1E1),a
ld (#D231),a
ld (#D23A),a
ld (#D23E),a
ld (#E238),a
ld (#F23D),a
ld (#D28B),a
ld (#D292),a
ld (#D293),a
ld (#C2DD),a
ld (#E2D1),a
ld (#F2E1),a
ld a,#52
ld (#D28D),a
ld (#D2D7),a
ld (#D2DE),a
ld a,#58
ld (#E010),a
ld (#D063),a
ld (#C0F3),a
ld (#C0F6),a
ld (#F0F7),a
ld (#D144),a
ld (#F191),a
ld (#C1E2),a
ld (#E1EF),a
ld (#F1F1),a
ld (#E237),a
ld (#C286),a
ld (#E288),a
ld a,#5A
ld (#D0AF),a
ld (#F0A0),a
ld (#D0FA),a
ld (#D1F3),a
ld (#E234),a
ld (#F23A),a
ld (#F242),a
ld (#D287),a
ld a,#62
ld (#F190),a
ld (#F197),a
ld (#C2E2),a
ld a,#6A
ld (#C1E1),a
ld (#F1EF),a
ld (#C28A),a
ld a,#72
ld (#E144),a
ld a,#7A
ld (#C008),a
ld (#D2D8),a
ld a,#88
ld (#F002),a
ld (#C055),a
ld (#C0A5),a
ld (#C150),a
ld a,#8A
ld (#E00E),a
ld (#C05E),a
ld (#E0B0),a
ld (#E0F4),a
ld (#E145),a
ld (#F19D),a
ld (#E23F),a
ld a,#8B
ld (#C004),a
ld (#C013),a
ld (#D2DF),a
ld (#D2E0),a
ld a,#8C
ld (#E008),a
ld (#F28B),a
ld a,#98
ld (#D060),a
ld (#F05A),a
ld (#F198),a
ld (#F28F),a
ld a,#9A
ld (#F055),a
ld (#E231),a
ld a,#9C
ld (#E28F),a
ld a,#9E
ld (#E1EE),a
ld a,#BA
ld (#E1E8),a
ld a,#C8
ld (#F2DD),a
ld a,#CA
ld (#C2D6),a
ld (#F2D1),a
ld a,#CE
ld (#E14C),a
ld a,#D8
ld (#C241),a
ld (#E23A),a
ld (#F230),a
ld (#F235),a
ld (#F23B),a
ld (#E291),a
ld (#F2D8),a
ld a,#EA
ld (#E0A3),a
ld (#C0F2),a
ld (#C1A0),a
ld (#F2D7),a
ld a,#FA
ld (#F286),a
ld a,#FF
ld (#F0F6),a
ret

p31to32
ld a,#00
ld (#D011),a
ld (#E004),a
ld (#F000),a
ld (#C052),a
ld (#D0F0),a
ld (#E101),a
ld (#E143),a
ld (#F150),a
ld (#C1A2),a
ld (#D19F),a
ld (#D1A3),a
ld (#F1E3),a
ld (#E232),a
ld (#E243),a
ld (#F233),a
ld (#C280),a
ld (#E283),a
ld (#E2D7),a
ld (#F2DE),a
ld a,#01
ld (#D007),a
ld (#D05A),a
ld (#E05D),a
ld (#C0B2),a
ld (#E2D4),a
ld (#F2E2),a
ld a,#02
ld (#D062),a
ld (#F05F),a
ld (#C0F5),a
ld (#C103),a
ld (#D0F2),a
ld (#C19F),a
ld (#D191),a
ld (#D194),a
ld (#D1F1),a
ld (#D230),a
ld (#F239),a
ld (#C283),a
ld (#C28E),a
ld (#C291),a
ld (#D286),a
ld (#E290),a
ld (#F28A),a
ld (#C2D5),a
ld (#C2D9),a
ld (#E2DF),a
ld a,#03
ld (#C23D),a
ld (#F291),a
ld (#C2D3),a
ld a,#04
ld (#D00D),a
ld (#E194),a
ld (#C234),a
ld (#D235),a
ld a,#05
ld (#E00C),a
ld (#C058),a
ld (#E05E),a
ld (#E05F),a
ld (#C0FD),a
ld (#D0F1),a
ld (#E1E5),a
ld (#E285),a
ld (#C2D4),a
ld a,#06
ld (#C14E),a
ld (#D152),a
ld a,#08
ld (#D00E),a
ld (#D055),a
ld (#F061),a
ld (#F0FF),a
ld (#C150),a
ld (#D142),a
ld (#D1A2),a
ld (#C1F2),a
ld (#D1F3),a
ld (#F1E2),a
ld (#E242),a
ld (#E293),a
ld a,#09
ld (#C05F),a
ld (#C061),a
ld (#D05E),a
ld (#C0A9),a
ld (#C1A1),a
ld (#E2D6),a
ld a,#0A
ld (#C004),a
ld (#E00E),a
ld (#F00D),a
ld (#F00F),a
ld (#D05F),a
ld (#D060),a
ld (#F060),a
ld (#C0AA),a
ld (#C0AF),a
ld (#D100),a
ld (#C1E1),a
ld (#D1F2),a
ld (#E1E0),a
ld (#E1E7),a
ld (#D283),a
ld (#D284),a
ld (#E284),a
ld a,#0B
ld (#D003),a
ld (#D2DA),a
ld a,#0C
ld (#C0B0),a
ld (#F28B),a
ld a,#0E
ld (#C054),a
ld (#D2D3),a
ld a,#10
ld (#C005),a
ld (#C00B),a
ld (#E013),a
ld (#F05C),a
ld (#C0B3),a
ld (#C142),a
ld (#C28B),a
ld (#D2E1),a
ld (#E2D5),a
ld a,#11
ld (#C1EF),a
ld a,#12
ld (#C002),a
ld (#F013),a
ld (#F0B0),a
ld (#C0F1),a
ld (#E1F3),a
ld (#D2D7),a
ld a,#14
ld (#D008),a
ld (#D059),a
ld (#E1EC),a
ld (#F241),a
ld (#C2DF),a
ld a,#18
ld (#C006),a
ld (#E010),a
ld (#F005),a
ld (#F05A),a
ld (#E0A6),a
ld (#C191),a
ld (#C198),a
ld (#E190),a
ld (#C286),a
ld a,#19
ld (#C19E),a
ld a,#1A
ld (#C0A0),a
ld (#E1E6),a
ld (#D243),a
ld (#D281),a
ld (#E28A),a
ld (#D2D5),a
ld a,#1C
ld (#F0FC),a
ld (#F28F),a
ld (#F2DC),a
ld a,#1E
ld (#D010),a
ld (#E28F),a
ld a,#22
ld (#D004),a
ld (#E001),a
ld (#E195),a
ld (#D28E),a
ld (#E28E),a
ld (#C2E2),a
ld (#E2E1),a
ld a,#23
ld (#F0A5),a
ld (#D14B),a
ld (#F146),a
ld a,#2A
ld (#C013),a
ld (#D00F),a
ld (#C0AD),a
ld (#D0AE),a
ld (#E0FB),a
ld (#E233),a
ld (#F234),a
ld (#F284),a
ld a,#32
ld (#D0B3),a
ld a,#33
ld (#F14C),a
ld a,#40
ld (#D05C),a
ld (#E054),a
ld (#F052),a
ld (#F05D),a
ld (#E0A2),a
ld (#E0A9),a
ld (#E0AE),a
ld (#F0A1),a
ld (#F0AA),a
ld (#F0AF),a
ld (#F0F3),a
ld (#C153),a
ld (#E14B),a
ld (#E152),a
ld (#C1E0),a
ld (#C1F0),a
ld (#C238),a
ld (#D233),a
ld (#D241),a
ld (#E235),a
ld (#E289),a
ld (#C2D0),a
ld (#C2DC),a
ld (#E2DA),a
ld (#F2D3),a
ld a,#41
ld (#D0A5),a
ld (#F0A3),a
ld (#F0FB),a
ld (#E1ED),a
ld a,#42
ld (#C003),a
ld (#E0F3),a
ld (#C190),a
ld (#F283),a
ld a,#43
ld (#E0A5),a
ld (#E0F6),a
ld (#E19C),a
ld a,#44
ld (#F053),a
ld (#E2D0),a
ld a,#46
ld (#E059),a
ld a,#48
ld (#F010),a
ld (#F0B1),a
ld (#E2DE),a
ld a,#4A
ld (#C00E),a
ld (#C0F2),a
ld (#C14F),a
ld (#E142),a
ld (#C1F1),a
ld a,#50
ld (#C009),a
ld (#F007),a
ld (#D050),a
ld (#D051),a
ld (#E062),a
ld (#D0A6),a
ld (#D0AD),a
ld (#E0A0),a
ld (#E0A1),a
ld (#C0F6),a
ld (#C100),a
ld (#D0FE),a
ld (#D103),a
ld (#C14B),a
ld (#E140),a
ld (#F141),a
ld (#F144),a
ld (#C192),a
ld (#C194),a
ld (#C195),a
ld (#E1A0),a
ld (#E1A1),a
ld (#F191),a
ld (#F1A3),a
ld (#F1F1),a
ld (#F1F2),a
ld (#C281),a
ld (#C293),a
ld (#E28D),a
ld (#F281),a
ld a,#52
ld (#D002),a
ld (#D005),a
ld (#F001),a
ld (#C057),a
ld (#F0AD),a
ld (#D140),a
ld (#D1A1),a
ld (#E192),a
ld (#E281),a
ld a,#53
ld (#F1ED),a
ld a,#58
ld (#D012),a
ld (#E056),a
ld (#C0A6),a
ld (#D0B0),a
ld (#F0A6),a
ld (#F0A7),a
ld (#F0AE),a
ld (#D0F3),a
ld (#D0F7),a
ld (#D0FA),a
ld (#E0F7),a
ld (#C241),a
ld (#E23A),a
ld (#F23B),a
ld (#F287),a
ld (#D2D0),a
ld (#E2D9),a
ld a,#5A
ld (#C1E2),a
ld (#E28B),a
ld a,#62
ld (#E012),a
ld (#C0FA),a
ld (#D1E8),a
ld (#F240),a
ld (#D28A),a
ld a,#63
ld (#F1E8),a
ld a,#72
ld (#C05D),a
ld (#F057),a
ld a,#73
ld (#F197),a
ld a,#7A
ld (#F190),a
ld (#D1E6),a
ld (#D237),a
ld (#D288),a
ld (#F293),a
ld a,#88
ld (#E008),a
ld (#E055),a
ld (#F055),a
ld (#E0F4),a
ld (#F19F),a
ld a,#89
ld (#C0A5),a
ld (#E145),a
ld (#D2DF),a
ld a,#8A
ld (#D009),a
ld (#E0A3),a
ld (#D141),a
ld (#C2DB),a
ld (#F2D1),a
ld (#F2DF),a
ld a,#8B
ld (#F00E),a
ld a,#8C
ld (#F002),a
ld a,#98
ld (#F009),a
ld (#C055),a
ld (#D0FB),a
ld (#F1EE),a
ld (#E237),a
ld (#C292),a
ld (#E2E2),a
ld a,#9A
ld (#E234),a
ld (#D2D4),a
ld a,#AA
ld (#F2D4),a
ld a,#BA
ld (#E052),a
ld a,#BE
ld (#E1EE),a
ld a,#C8
ld (#C00D),a
ld (#D2DC),a
ld a,#CA
ld (#C007),a
ld (#C0A1),a
ld (#C0FF),a
ld (#D192),a
ld (#D2D2),a
ld a,#D8
ld (#D063),a
ld (#D144),a
ld (#E288),a
ld (#F2D5),a
ld a,#DA
ld (#D238),a
ld (#E231),a
ld (#F235),a
ld (#C2D7),a
ld a,#EA
ld (#C2D6),a
ld a,#EE
ld (#E14C),a
ld (#E19D),a
ld a,#EF
ld (#F0F6),a
ld a,#FA
ld (#C00C),a
ld (#D195),a
ld (#D2D8),a
ld a,#FE
ld (#F147),a
ret

p32to33
ld a,#00
ld (#C011),a
ld (#D00D),a
ld (#D058),a
ld (#E051),a
ld (#E05F),a
ld (#F051),a
ld (#F059),a
ld (#F05E),a
ld (#C0AB),a
ld (#D0A0),a
ld (#F0AF),a
ld (#C0F0),a
ld (#C103),a
ld (#E0F2),a
ld (#D142),a
ld (#E153),a
ld (#D1A2),a
ld (#E1A3),a
ld (#D1F0),a
ld (#D1F1),a
ld (#C233),a
ld (#D233),a
ld (#E242),a
ld (#C291),a
ld (#C2DE),a
ld (#F2D6),a
ld a,#01
ld (#C00F),a
ld (#D011),a
ld (#E000),a
ld (#E00F),a
ld (#F0A3),a
ld (#C0FB),a
ld (#F103),a
ld (#D241),a
ld a,#02
ld (#C010),a
ld (#D004),a
ld (#D00F),a
ld (#F00F),a
ld (#F013),a
ld (#E063),a
ld (#E102),a
ld (#D152),a
ld (#C1F0),a
ld (#F1E3),a
ld (#F233),a
ld (#E2E1),a
ld (#F2DB),a
ld a,#03
ld (#F008),a
ld (#C28E),a
ld a,#04
ld (#E004),a
ld (#F000),a
ld (#C058),a
ld (#E05E),a
ld (#F053),a
ld (#C0AC),a
ld (#C0FD),a
ld (#D1A3),a
ld (#C239),a
ld (#D239),a
ld (#C280),a
ld (#C2D4),a
ld a,#05
ld (#C00A),a
ld (#D05E),a
ld (#C0FC),a
ld (#F0F5),a
ld a,#06
ld (#D010),a
ld (#F004),a
ld (#F0B0),a
ld (#D242),a
ld (#C2D3),a
ld (#E2D0),a
ld (#E2DB),a
ld (#E2DF),a
ld a,#08
ld (#C00D),a
ld (#E008),a
ld (#F010),a
ld (#E055),a
ld (#F050),a
ld (#E101),a
ld (#E143),a
ld (#F150),a
ld (#D198),a
ld (#E1E6),a
ld (#F285),a
ld (#C2E3),a
ld (#E2D6),a
ld (#E2DC),a
ld a,#09
ld (#D007),a
ld (#F00E),a
ld (#C0B0),a
ld (#D1F3),a
ld (#E293),a
ld (#D2DA),a
ld a,#0A
ld (#D003),a
ld (#C0AD),a
ld (#D0F0),a
ld (#E233),a
ld (#E234),a
ld (#F234),a
ld (#D2D3),a
ld a,#0B
ld (#C0AA),a
ld (#C19E),a
ld a,#0C
ld (#F002),a
ld (#E196),a
ld (#C1E8),a
ld (#F241),a
ld a,#0D
ld (#D0F1),a
ld (#E145),a
ld (#E194),a
ld (#F28B),a
ld a,#0F
ld (#C0A4),a
ld a,#10
ld (#E007),a
ld (#F005),a
ld (#F00B),a
ld (#D05B),a
ld (#D0A1),a
ld (#D0AC),a
ld (#D0FD),a
ld (#F0F0),a
ld (#F151),a
ld (#D1A0),a
ld (#E190),a
ld (#C1F3),a
ld (#D1E5),a
ld (#E1F2),a
ld (#C230),a
ld (#F2DE),a
ld (#F2E3),a
ld a,#11
ld (#D05A),a
ld (#F2E2),a
ld a,#12
ld (#F0AD),a
ld (#E1E7),a
ld a,#14
ld (#C062),a
ld (#E286),a
ld (#F292),a
ld a,#16
ld (#E060),a
ld (#D2D7),a
ld a,#18
ld (#D012),a
ld (#E013),a
ld (#F062),a
ld (#C0B1),a
ld (#F140),a
ld (#F198),a
ld (#E1EF),a
ld (#F1E9),a
ld (#F2DC),a
ld a,#19
ld (#E285),a
ld a,#1A
ld (#C002),a
ld (#E010),a
ld (#D0B0),a
ld (#F14D),a
ld (#C284),a
ld a,#1B
ld (#C14D),a
ld a,#1E
ld (#F28F),a
ld a,#22
ld (#C003),a
ld (#D14B),a
ld (#E144),a
ld (#D28F),a
ld a,#23
ld (#E0F6),a
ld (#F19C),a
ld (#F1E8),a
ld (#F23E),a
ld (#F291),a
ld a,#2A
ld (#D05F),a
ld (#C0A0),a
ld (#E193),a
ld (#E28F),a
ld a,#2B
ld (#E282),a
ld a,#2E
ld (#F0A5),a
ld a,#32
ld (#C008),a
ld (#D0AA),a
ld (#E28E),a
ld a,#33
ld (#F146),a
ld (#F197),a
ld a,#3A
ld (#E001),a
ld (#F00D),a
ld (#D243),a
ld (#E28A),a
ld a,#40
ld (#E00B),a
ld (#D053),a
ld (#E0F1),a
ld (#F153),a
ld (#D190),a
ld (#E19C),a
ld (#D1E9),a
ld (#E1ED),a
ld (#F1E0),a
ld (#F1E5),a
ld (#D23D),a
ld (#E238),a
ld (#F23D),a
ld (#F243),a
ld (#D282),a
ld (#E292),a
ld a,#41
ld (#E054),a
ld (#F052),a
ld (#C1EF),a
ld (#C240),a
ld a,#42
ld (#C00E),a
ld (#F001),a
ld (#C232),a
ld (#C23D),a
ld (#E23D),a
ld (#F28E),a
ld (#D2D1),a
ld a,#43
ld (#D0A5),a
ld a,#44
ld (#E059),a
ld a,#48
ld (#C0A5),a
ld (#C0A9),a
ld (#E235),a
ld (#F2DD),a
ld a,#4A
ld (#C007),a
ld (#D000),a
ld (#E00E),a
ld (#D0AF),a
ld (#E0B0),a
ld (#F0B1),a
ld (#C190),a
ld (#C1A0),a
ld (#C1E2),a
ld (#D1F2),a
ld a,#50
ld (#D013),a
ld (#F012),a
ld (#C063),a
ld (#F056),a
ld (#C0A6),a
ld (#E0A6),a
ld (#F0A1),a
ld (#F0A6),a
ld (#F0A9),a
ld (#F0F3),a
ld (#F0F7),a
ld (#C142),a
ld (#C143),a
ld (#C144),a
ld (#C153),a
ld (#D14F),a
ld (#D1A1),a
ld (#E19F),a
ld (#D1E2),a
ld (#F1EC),a
ld (#F1F3),a
ld (#D236),a
ld (#C2DA),a
ld (#C2E0),a
ld (#D2D0),a
ld (#D2E3),a
ld a,#51
ld (#F054),a
ld a,#52
ld (#F057),a
ld (#D0FF),a
ld (#F0FE),a
ld (#C14B),a
ld (#E141),a
ld (#F14F),a
ld (#E1F3),a
ld (#E230),a
ld (#C28D),a
ld (#D2DB),a
ld a,#53
ld (#F14C),a
ld a,#54
ld (#D059),a
ld a,#58
ld (#C0A2),a
ld (#F0A0),a
ld (#D14C),a
ld (#D153),a
ld (#F14E),a
ld (#C191),a
ld (#D1E7),a
ld (#C23E),a
ld (#F230),a
ld (#F23A),a
ld (#F242),a
ld (#D287),a
ld (#E2E0),a
ld (#F2D5),a
ld a,#5A
ld (#C0AE),a
ld (#C0FE),a
ld (#D192),a
ld (#F293),a
ld a,#62
ld (#C013),a
ld (#E0FB),a
ld (#F283),a
ld a,#63
ld (#E0A5),a
ld a,#6A
ld (#E0AA),a
ld (#E142),a
ld (#D1E6),a
ld (#F286),a
ld a,#72
ld (#E0F3),a
ld a,#7A
ld (#C05D),a
ld (#D195),a
ld (#F1EF),a
ld (#C2D7),a
ld a,#88
ld (#C05E),a
ld (#C061),a
ld (#E0A3),a
ld (#F1F0),a
ld (#D2DF),a
ld a,#89
ld (#D285),a
ld a,#8A
ld (#D060),a
ld (#F060),a
ld (#C0AF),a
ld (#D100),a
ld (#C140),a
ld (#C285),a
ld (#D283),a
ld (#F280),a
ld a,#8B
ld (#C053),a
ld (#E239),a
ld a,#8C
ld (#E0F4),a
ld (#F2D1),a
ld a,#8E
ld (#C054),a
ld a,#98
ld (#E1E9),a
ld (#C2DB),a
ld (#F2D8),a
ld a,#9A
ld (#E197),a
ld (#E1E0),a
ld (#E1E8),a
ld (#E231),a
ld (#E240),a
ld (#D281),a
ld a,#9C
ld (#F0AB),a
ld (#F0FC),a
ld a,#AA
ld (#F05F),a
ld (#D284),a
ld a,#AE
ld (#E19D),a
ld (#F19D),a
ld a,#BA
ld (#C00C),a
ld (#F2D4),a
ld a,#CA
ld (#D141),a
ld (#C2D6),a
ld a,#D8
ld (#C286),a
ld (#C292),a
ld (#F287),a
ld a,#DA
ld (#E052),a
ld (#F190),a
ld (#E291),a
ld (#D2D8),a
ld (#D2D9),a
ld a,#DE
ld (#F147),a
ld a,#EA
ld (#C0A1),a
ld (#C1F1),a
ld a,#EE
ld (#F0F6),a
ld a,#FA
ld (#F19E),a
ld (#D238),a
ld (#F235),a
ret

p33to34
ld a,#00
ld (#C001),a
ld (#C00F),a
ld (#E000),a
ld (#F00C),a
ld (#E060),a
ld (#F050),a
ld (#F053),a
ld (#F05C),a
ld (#C0B2),a
ld (#E0B1),a
ld (#F0B2),a
ld (#C0FD),a
ld (#C100),a
ld (#F0F4),a
ld (#C14E),a
ld (#C150),a
ld (#C1F3),a
ld (#C239),a
ld (#C241),a
ld (#D235),a
ld (#E235),a
ld (#E236),a
ld (#F231),a
ld (#D293),a
ld (#C2D4),a
ld (#C2D5),a
ld a,#01
ld (#D007),a
ld (#F013),a
ld (#D054),a
ld (#D05C),a
ld (#D062),a
ld (#F052),a
ld (#D0A0),a
ld (#F0AF),a
ld (#C0FC),a
ld (#C103),a
ld (#C1F2),a
ld (#C28E),a
ld (#F28B),a
ld (#E2D3),a
ld a,#02
ld (#C059),a
ld (#D05F),a
ld (#C0A0),a
ld (#D0A1),a
ld (#D140),a
ld (#E153),a
ld (#D1A3),a
ld (#E195),a
ld (#F1E8),a
ld (#C234),a
ld (#D242),a
ld (#D282),a
ld (#E284),a
ld (#E28E),a
ld (#F283),a
ld (#C2E2),a
ld a,#03
ld (#D05A),a
ld (#F23E),a
ld (#E2D7),a
ld (#F2E2),a
ld a,#04
ld (#C00A),a
ld (#C05B),a
ld (#C062),a
ld (#D05E),a
ld (#F0B0),a
ld (#E1E5),a
ld (#D234),a
ld (#E286),a
ld a,#05
ld (#E05D),a
ld (#E145),a
ld a,#06
ld (#C19F),a
ld (#C284),a
ld a,#08
ld (#C004),a
ld (#F00E),a
ld (#C05E),a
ld (#F055),a
ld (#C0B0),a
ld (#D0F1),a
ld (#E0F2),a
ld (#C1A1),a
ld (#E196),a
ld (#F1A1),a
ld (#C243),a
ld (#E234),a
ld (#E290),a
ld (#E293),a
ld (#D2D5),a
ld a,#09
ld (#D011),a
ld (#E008),a
ld (#E194),a
ld (#F1E2),a
ld (#D233),a
ld (#E285),a
ld (#F285),a
ld (#C2D3),a
ld a,#0A
ld (#D00C),a
ld (#D010),a
ld (#F010),a
ld (#C05F),a
ld (#F05E),a
ld (#C0B1),a
ld (#D0AE),a
ld (#D0AF),a
ld (#E0B0),a
ld (#F0B1),a
ld (#E101),a
ld (#C190),a
ld (#E193),a
ld (#C1E2),a
ld (#C1F0),a
ld (#F1E3),a
ld (#E232),a
ld (#F233),a
ld (#C283),a
ld (#E282),a
ld (#E2DB),a
ld (#F2DF),a
ld a,#0B
ld (#C14D),a
ld a,#0C
ld (#E0F4),a
ld (#D2DA),a
ld (#F2D1),a
ld a,#0D
ld (#E143),a
ld a,#0F
ld (#D2E0),a
ld a,#10
ld (#D00A),a
ld (#D012),a
ld (#C0F1),a
ld (#C0F5),a
ld (#C101),a
ld (#D14E),a
ld (#D194),a
ld (#F195),a
ld (#F1A2),a
ld (#C1E3),a
ld (#F1E6),a
ld (#F1E9),a
ld (#C235),a
ld (#F2DC),a
ld a,#12
ld (#D0B3),a
ld (#E141),a
ld (#F28A),a
ld (#C2D1),a
ld (#C2DF),a
ld a,#13
ld (#F0F5),a
ld a,#14
ld (#E00D),a
ld (#F002),a
ld (#D059),a
ld (#C0B3),a
ld (#D2D7),a
ld (#D2E1),a
ld a,#18
ld (#C05A),a
ld (#D061),a
ld (#F0B3),a
ld (#E103),a
ld (#C140),a
ld (#D1E7),a
ld (#E240),a
ld (#F23B),a
ld (#D287),a
ld (#D290),a
ld (#E2DC),a
ld (#F2D8),a
ld a,#1A
ld (#D004),a
ld (#F009),a
ld (#F00D),a
ld (#F05A),a
ld (#F0AD),a
ld (#F0FE),a
ld (#F190),a
ld (#D230),a
ld (#E231),a
ld (#E237),a
ld (#D2D9),a
ld (#F2D4),a
ld a,#22
ld (#C013),a
ld (#F00F),a
ld (#E0A5),a
ld (#E0F3),a
ld (#E2D0),a
ld a,#23
ld (#F054),a
ld (#C197),a
ld a,#26
ld (#E144),a
ld (#F239),a
ld a,#2A
ld (#D0B0),a
ld (#C1E1),a
ld (#F286),a
ld (#D2DF),a
ld a,#2B
ld (#C19E),a
ld (#E28F),a
ld a,#2E
ld (#C0A4),a
ld a,#32
ld (#E010),a
ld (#F28F),a
ld a,#3A
ld (#C2D7),a
ld (#D2D4),a
ld a,#40
ld (#D000),a
ld (#F003),a
ld (#E051),a
ld (#C0A7),a
ld (#C0A9),a
ld (#D0AD),a
ld (#F0A2),a
ld (#F0FB),a
ld (#C14C),a
ld (#F143),a
ld (#F194),a
ld (#C1E7),a
ld (#C1E9),a
ld (#C23D),a
ld (#D232),a
ld (#E23D),a
ld (#C282),a
ld (#D292),a
ld a,#41
ld (#F001),a
ld (#F1ED),a
ld (#C238),a
ld (#C289),a
ld (#C291),a
ld (#C2D0),a
ld a,#42
ld (#C052),a
ld (#F0AA),a
ld (#D1F2),a
ld (#E238),a
ld (#E281),a
ld a,#43
ld (#F14C),a
ld (#C1EF),a
ld (#E23E),a
ld (#D28E),a
ld a,#45
ld (#E059),a
ld a,#48
ld (#C007),a
ld (#C14F),a
ld (#D2DC),a
ld a,#49
ld (#D2D6),a
ld (#E2D6),a
ld a,#4A
ld (#C010),a
ld (#C050),a
ld (#C0A1),a
ld (#C0FF),a
ld (#E0F1),a
ld (#D141),a
ld (#F14F),a
ld (#D195),a
ld (#C242),a
ld (#C28A),a
ld a,#50
ld (#D053),a
ld (#D058),a
ld (#E050),a
ld (#E0B3),a
ld (#F0A0),a
ld (#C0F3),a
ld (#C0F9),a
ld (#E0F7),a
ld (#F0F0),a
ld (#F102),a
ld (#C141),a
ld (#C14A),a
ld (#C191),a
ld (#D1A0),a
ld (#E190),a
ld (#E192),a
ld (#F198),a
ld (#D1E0),a
ld (#D1E5),a
ld (#E1F1),a
ld (#E1F2),a
ld (#E1F3),a
ld (#C230),a
ld (#C232),a
ld (#F230),a
ld (#F242),a
ld (#C28B),a
ld (#E280),a
ld (#E28B),a
ld (#F28C),a
ld (#C2DC),a
ld (#F2DE),a
ld a,#52
ld (#E0A2),a
ld (#E100),a
ld (#C288),a
ld (#F2D0),a
ld a,#54
ld (#D239),a
ld a,#58
ld (#C009),a
ld (#C055),a
ld (#D063),a
ld (#E05A),a
ld (#D0A2),a
ld (#D0B1),a
ld (#D144),a
ld (#F140),a
ld (#F1E4),a
ld (#F236),a
ld (#C292),a
ld (#F2DD),a
ld a,#5A
ld (#E00E),a
ld (#E2D9),a
ld a,#62
ld (#E063),a
ld (#D0A5),a
ld (#D14B),a
ld (#D1E6),a
ld (#F291),a
ld (#F2D3),a
ld a,#6A
ld (#D243),a
ld a,#6E
ld (#E14C),a
ld a,#72
ld (#C0AE),a
ld (#D0AA),a
ld (#F1EF),a
ld (#D237),a
ld (#D288),a
ld (#D2D1),a
ld a,#88
ld (#E239),a
ld (#F241),a
ld a,#89
ld (#D00E),a
ld (#C0AA),a
ld a,#8A
ld (#F004),a
ld (#C054),a
ld (#E05F),a
ld a,#8B
ld (#D285),a
ld a,#8C
ld (#F0AB),a
ld a,#8E
ld (#F1EE),a
ld a,#98
ld (#E005),a
ld (#E013),a
ld (#E052),a
ld (#E197),a
ld (#E1E8),a
ld (#C23E),a
ld (#C2E3),a
ld (#E2E0),a
ld (#F2E0),a
ld a,#9A
ld (#F19F),a
ld a,#9C
ld (#D0FB),a
ld (#F147),a
ld (#C1E8),a
ld (#C2DB),a
ld a,#9E
ld (#F14D),a
ld a,#AA
ld (#F060),a
ld (#D283),a
ld a,#AE
ld (#E1EE),a
ld a,#AF
ld (#F19D),a
ld a,#BA
ld (#E001),a
ld (#F284),a
ld a,#CC
ld (#F0FC),a
ld a,#D8
ld (#E0AB),a
ld (#F0A7),a
ld (#D0F3),a
ld (#D14C),a
ld (#F23F),a
ld (#E2E2),a
ld a,#DA
ld (#C286),a
ld (#D281),a
ld (#E288),a
ld (#D2DB),a
ld a,#EA
ld (#C285),a
ld a,#EE
ld (#F0A5),a
ld a,#FA
ld (#C00C),a
ld (#C05D),a
ld (#C2D6),a
ret

p34to35
ld a,#00
ld (#C00A),a
ld (#D007),a
ld (#D008),a
ld (#E00F),a
ld (#F000),a
ld (#C058),a
ld (#D05D),a
ld (#D062),a
ld (#F05D),a
ld (#F061),a
ld (#C0AC),a
ld (#E0A1),a
ld (#F0AF),a
ld (#F0B0),a
ld (#C0FC),a
ld (#D0F2),a
ld (#D143),a
ld (#C1A1),a
ld (#C1E0),a
ld (#C1E3),a
ld (#E1E5),a
ld (#F1E0),a
ld (#F1E6),a
ld (#D233),a
ld (#D241),a
ld (#D242),a
ld (#C280),a
ld (#E293),a
ld (#F28B),a
ld (#D2D5),a
ld (#D2D7),a
ld (#E2E1),a
ld a,#01
ld (#E00C),a
ld (#F008),a
ld (#D05A),a
ld (#E0AE),a
ld (#C283),a
ld (#D292),a
ld (#F285),a
ld a,#02
ld (#E010),a
ld (#F00C),a
ld (#F00F),a
ld (#D0AE),a
ld (#D0B3),a
ld (#E141),a
ld (#C190),a
ld (#C19F),a
ld (#C1A2),a
ld (#E196),a
ld (#D1E3),a
ld (#F1E3),a
ld (#C241),a
ld (#E233),a
ld (#D293),a
ld (#E281),a
ld (#C2DF),a
ld (#E2D3),a
ld (#E2DF),a
ld a,#03
ld (#E008),a
ld (#F2DB),a
ld a,#04
ld (#C00F),a
ld (#D00B),a
ld (#D059),a
ld (#E059),a
ld (#E0B0),a
ld (#E0F4),a
ld (#E235),a
ld (#E283),a
ld (#E284),a
ld (#D2E1),a
ld (#E2D4),a
ld a,#05
ld (#E0AF),a
ld (#D234),a
ld a,#06
ld (#C003),a
ld (#C008),a
ld (#C059),a
ld (#E05E),a
ld (#D152),a
ld (#F1E8),a
ld (#F239),a
ld (#D286),a
ld a,#08
ld (#C010),a
ld (#E060),a
ld (#F0B2),a
ld (#F0B3),a
ld (#C150),a
ld (#E194),a
ld (#D1F3),a
ld (#F1E2),a
ld (#C2D5),a
ld (#D2DA),a
ld a,#09
ld (#D00E),a
ld (#C0AA),a
ld (#F0A4),a
ld (#E0F2),a
ld (#E143),a
ld (#E290),a
ld a,#0A
ld (#D009),a
ld (#C061),a
ld (#D05F),a
ld (#F05F),a
ld (#C100),a
ld (#D100),a
ld (#E100),a
ld (#F1E1),a
ld (#C233),a
ld (#C234),a
ld (#E231),a
ld (#D283),a
ld (#D285),a
ld (#D289),a
ld (#F283),a
ld a,#0B
ld (#C0AF),a
ld (#C2D3),a
ld a,#0C
ld (#C05E),a
ld (#C243),a
ld (#F292),a
ld a,#0D
ld (#D0A0),a
ld (#E234),a
ld a,#0E
ld (#F0AB),a
ld (#E232),a
ld a,#0F
ld (#C0B0),a
ld a,#10
ld (#D00D),a
ld (#E00A),a
ld (#F002),a
ld (#D050),a
ld (#F062),a
ld (#C0F7),a
ld (#C14E),a
ld (#F144),a
ld (#D196),a
ld (#D19F),a
ld (#D1F1),a
ld (#F1F2),a
ld (#D236),a
ld (#F237),a
ld (#C2DE),a
ld a,#12
ld (#C00B),a
ld (#F009),a
ld (#C0A0),a
ld (#E1E2),a
ld a,#14
ld (#C005),a
ld (#D012),a
ld (#F2E3),a
ld a,#15
ld (#E05D),a
ld a,#18
ld (#C00D),a
ld (#E004),a
ld (#E005),a
ld (#E00E),a
ld (#D063),a
ld (#E146),a
ld (#E1E6),a
ld (#E1EC),a
ld (#C235),a
ld (#F287),a
ld (#C2D1),a
ld (#D2D9),a
ld (#F2E0),a
ld a,#1A
ld (#C0AD),a
ld (#D0B0),a
ld (#C1E1),a
ld (#D284),a
ld (#E291),a
ld (#E2D9),a
ld (#F2D8),a
ld a,#1C
ld (#E0A3),a
ld (#C2DB),a
ld (#F2D1),a
ld a,#1E
ld (#F05A),a
ld a,#22
ld (#C0B1),a
ld (#D0A5),a
ld (#E1E7),a
ld (#F286),a
ld (#F28F),a
ld (#C2D9),a
ld (#F2D3),a
ld a,#23
ld (#E0F3),a
ld (#E144),a
ld a,#26
ld (#E0A5),a
ld a,#2A
ld (#F010),a
ld (#F05E),a
ld (#F060),a
ld (#F0B1),a
ld (#C14D),a
ld (#E19D),a
ld (#D2D3),a
ld a,#2B
ld (#D2E0),a
ld a,#2E
ld (#E0F6),a
ld (#E1EE),a
ld a,#32
ld (#F00D),a
ld (#F28A),a
ld a,#37
ld (#F0F5),a
ld a,#3A
ld (#E2D0),a
ld a,#40
ld (#E003),a
ld (#D055),a
ld (#E055),a
ld (#E05C),a
ld (#C0A5),a
ld (#E0A0),a
ld (#C14F),a
ld (#C19D),a
ld (#E1A3),a
ld (#D1F2),a
ld (#F1ED),a
ld (#C232),a
ld (#E23E),a
ld (#C289),a
ld (#C2D0),a
ld (#C2D2),a
ld (#C2E2),a
ld (#E2E3),a
ld (#F2D6),a
ld a,#41
ld (#C007),a
ld (#D054),a
ld (#F14C),a
ld (#F23E),a
ld (#C282),a
ld (#C28E),a
ld (#E28C),a
ld (#F28E),a
ld (#E2DA),a
ld a,#42
ld (#D00F),a
ld (#E012),a
ld (#F055),a
ld (#C0A3),a
ld (#C0FA),a
ld (#F143),a
ld (#D195),a
ld (#D232),a
ld (#E230),a
ld (#D280),a
ld (#D28E),a
ld (#D28F),a
ld (#E28E),a
ld (#F2D0),a
ld (#F2E2),a
ld a,#43
ld (#E054),a
ld a,#48
ld (#F0AE),a
ld (#F232),a
ld a,#4A
ld (#E0AA),a
ld (#F1A0),a
ld (#C1F1),a
ld (#D243),a
ld (#D28A),a
ld (#F2D7),a
ld (#F2DF),a
ld a,#50
ld (#D000),a
ld (#D005),a
ld (#D006),a
ld (#F011),a
ld (#E056),a
ld (#F050),a
ld (#F063),a
ld (#F0A2),a
ld (#C0F1),a
ld (#C0F2),a
ld (#D0F7),a
ld (#E152),a
ld (#F140),a
ld (#D193),a
ld (#D194),a
ld (#E1ED),a
ld (#E1F0),a
ld (#C231),a
ld (#C23A),a
ld (#E23A),a
ld (#F243),a
ld (#C292),a
ld (#D28D),a
ld (#F2D5),a
ld (#F2DD),a
ld a,#51
ld (#C238),a
ld a,#52
ld (#E0F0),a
ld (#E287),a
ld (#F293),a
ld (#C2DA),a
ld a,#58
ld (#C051),a
ld (#E061),a
ld (#C0FF),a
ld (#D0F3),a
ld (#E0FC),a
ld (#C140),a
ld (#D141),a
ld (#C198),a
ld (#C1A3),a
ld (#D23E),a
ld (#C28F),a
ld (#C2D8),a
ld a,#5A
ld (#C00C),a
ld (#E1E3),a
ld a,#62
ld (#E0A2),a
ld (#F0AA),a
ld (#C1EF),a
ld (#D237),a
ld a,#6A
ld (#E0F1),a
ld (#F14F),a
ld (#C19E),a
ld (#F1EF),a
ld (#F235),a
ld (#D2DF),a
ld a,#72
ld (#D1E8),a
ld (#F240),a
ld a,#7A
ld (#C0AE),a
ld (#D0FF),a
ld (#D238),a
ld (#C285),a
ld (#C2D6),a
ld (#D2D4),a
ld (#E2E2),a
ld a,#88
ld (#C004),a
ld (#D004),a
ld (#F280),a
ld a,#89
ld (#D011),a
ld (#F004),a
ld (#E285),a
ld a,#8A
ld (#E101),a
ld (#F1F0),a
ld a,#8B
ld (#D010),a
ld (#E05F),a
ld (#C1E2),a
ld a,#98
ld (#D0A2),a
ld (#D0B1),a
ld (#C1E8),a
ld (#F23F),a
ld (#D287),a
ld (#D2DB),a
ld a,#9A
ld (#C054),a
ld (#D230),a
ld (#E237),a
ld a,#9C
ld (#E2E0),a
ld a,#AA
ld (#D00C),a
ld (#C05F),a
ld (#C242),a
ld a,#AE
ld (#E23F),a
ld a,#BA
ld (#F0FE),a
ld (#F19E),a
ld (#C2D7),a
ld a,#CA
ld (#C002),a
ld (#D0F0),a
ld (#E142),a
ld a,#D8
ld (#C009),a
ld (#E05A),a
ld (#E1E8),a
ld (#D281),a
ld (#C2E3),a
ld a,#DA
ld (#E001),a
ld (#F19F),a
ld (#F1E4),a
ld (#F284),a
ld a,#EA
ld (#C050),a
ld a,#EB
ld (#D2D2),a
ld a,#EE
ld (#F1EE),a
ld a,#FA
ld (#C286),a
ld (#E288),a
ld a,#FF
ld (#F19D),a
ret

p35to36
ld a,#00
ld (#E00C),a
ld (#F00E),a
ld (#C062),a
ld (#D05E),a
ld (#C0A5),a
ld (#D0A1),a
ld (#D0B3),a
ld (#F0A3),a
ld (#C103),a
ld (#D0F1),a
ld (#F103),a
ld (#E195),a
ld (#F192),a
ld (#F195),a
ld (#C1F2),a
ld (#D1E3),a
ld (#D1F3),a
ld (#F1F2),a
ld (#C284),a
ld (#C289),a
ld (#D286),a
ld (#E284),a
ld (#F285),a
ld (#C2D0),a
ld (#E2DF),a
ld a,#01
ld (#C00A),a
ld (#D008),a
ld (#F001),a
ld (#E0B0),a
ld (#C243),a
ld a,#02
ld (#C001),a
ld (#C013),a
ld (#D050),a
ld (#F05D),a
ld (#C0B1),a
ld (#E0F0),a
ld (#D152),a
ld (#E19D),a
ld (#F19C),a
ld (#C1F0),a
ld (#C232),a
ld (#C292),a
ld (#F286),a
ld a,#03
ld (#D0AE),a
ld (#E144),a
ld (#C282),a
ld (#F28F),a
ld (#C2DF),a
ld a,#04
ld (#D012),a
ld (#F008),a
ld (#E060),a
ld (#C0B3),a
ld (#D0AF),a
ld (#D140),a
ld (#E145),a
ld (#C1E3),a
ld (#D1E4),a
ld (#E1E5),a
ld a,#05
ld (#E05D),a
ld (#C283),a
ld (#E283),a
ld (#E286),a
ld (#D2D7),a
ld a,#06
ld (#F0AB),a
ld (#D282),a
ld (#F2D3),a
ld a,#08
ld (#D003),a
ld (#D00E),a
ld (#D05F),a
ld (#E05F),a
ld (#F053),a
ld (#F061),a
ld (#C0AB),a
ld (#C0B2),a
ld (#D0A0),a
ld (#E0A1),a
ld (#E0B1),a
ld (#D101),a
ld (#E143),a
ld (#D290),a
ld (#F280),a
ld (#E2D4),a
ld (#E2DB),a
ld a,#09
ld (#D010),a
ld (#D05D),a
ld (#C0B0),a
ld (#D151),a
ld (#D234),a
ld (#F234),a
ld a,#0A
ld (#D060),a
ld (#F060),a
ld (#C0AF),a
ld (#D0B1),a
ld (#F0B1),a
ld (#F0B3),a
ld (#C150),a
ld (#F1A0),a
ld (#C1E1),a
ld (#C1F3),a
ld (#C241),a
ld (#D232),a
ld (#D233),a
ld (#E233),a
ld (#D284),a
ld (#C2D3),a
ld a,#0B
ld (#E28F),a
ld (#D2D2),a
ld a,#0C
ld (#C010),a
ld (#D059),a
ld (#C101),a
ld (#E102),a
ld (#F1A1),a
ld (#E232),a
ld (#D2DA),a
ld a,#0E
ld (#C003),a
ld (#C0A4),a
ld a,#0F
ld (#E234),a
ld a,#10
ld (#C00D),a
ld (#E009),a
ld (#E00D),a
ld (#E00E),a
ld (#D063),a
ld (#E05B),a
ld (#F05C),a
ld (#C0F0),a
ld (#C0FD),a
ld (#F0F3),a
ld (#C151),a
ld (#C19F),a
ld (#F190),a
ld (#F1F3),a
ld (#F231),a
ld (#C280),a
ld (#C2D4),a
ld (#E2D8),a
ld (#E2DC),a
ld (#F2D1),a
ld a,#12
ld (#C05C),a
ld (#F062),a
ld (#F101),a
ld (#D191),a
ld (#C28D),a
ld (#E291),a
ld a,#13
ld (#F2DB),a
ld a,#14
ld (#C05E),a
ld (#D05B),a
ld (#E0A3),a
ld a,#18
ld (#E052),a
ld (#E05A),a
ld (#E061),a
ld (#F144),a
ld (#D23E),a
ld (#F2D4),a
ld a,#1A
ld (#E103),a
ld (#E237),a
ld (#F287),a
ld (#E2D0),a
ld a,#1B
ld (#F0A4),a
ld a,#1C
ld (#D061),a
ld (#D0FB),a
ld (#F2E0),a
ld a,#1E
ld (#E2E0),a
ld a,#22
ld (#C00B),a
ld (#D009),a
ld (#F009),a
ld (#E054),a
ld (#E05E),a
ld (#E0A2),a
ld (#E1EE),a
ld (#D2D3),a
ld a,#26
ld (#F054),a
ld (#C197),a
ld a,#27
ld (#E0F3),a
ld (#E14C),a
ld (#F197),a
ld a,#2A
ld (#F0B0),a
ld (#E0F1),a
ld (#E1E2),a
ld (#F1E1),a
ld (#F1E3),a
ld (#F233),a
ld (#F235),a
ld (#D2E0),a
ld a,#2B
ld (#C061),a
ld a,#2E
ld (#F05A),a
ld a,#32
ld (#C2DA),a
ld a,#3A
ld (#F00D),a
ld (#C054),a
ld (#F05E),a
ld (#D0B0),a
ld (#D0FF),a
ld (#F28A),a
ld (#E2E2),a
ld a,#40
ld (#E000),a
ld (#E012),a
ld (#D062),a
ld (#F051),a
ld (#D0A7),a
ld (#E0F5),a
ld (#E0FF),a
ld (#F100),a
ld (#D144),a
ld (#D150),a
ld (#E140),a
ld (#C1A0),a
ld (#D195),a
ld (#D1A2),a
ld (#F191),a
ld (#D1E2),a
ld (#E1E1),a
ld (#C239),a
ld (#C240),a
ld (#F23E),a
ld (#C28E),a
ld (#D28E),a
ld (#E28E),a
ld (#F282),a
ld (#D2D9),a
ld (#D2DC),a
ld (#D2E3),a
ld (#E2E1),a
ld a,#41
ld (#E00B),a
ld (#F003),a
ld (#F059),a
ld (#E2D6),a
ld a,#42
ld (#D002),a
ld (#D054),a
ld (#E063),a
ld (#F0AA),a
ld (#C14F),a
ld (#D1E6),a
ld (#F1F1),a
ld (#D243),a
ld (#F232),a
ld (#F240),a
ld (#E289),a
ld a,#43
ld (#F2D0),a
ld a,#44
ld (#C059),a
ld a,#46
ld (#F1E8),a
ld a,#48
ld (#D198),a
ld (#C28A),a
ld (#D28F),a
ld (#C2D5),a
ld (#D2D6),a
ld a,#4A
ld (#C050),a
ld (#C05F),a
ld (#E0A0),a
ld (#D0F0),a
ld (#F0F2),a
ld (#F143),a
ld (#D285),a
ld a,#4B
ld (#D28A),a
ld a,#50
ld (#C00E),a
ld (#F005),a
ld (#C055),a
ld (#F057),a
ld (#C0A2),a
ld (#D142),a
ld (#D143),a
ld (#E14B),a
ld (#F153),a
ld (#D19F),a
ld (#E19C),a
ld (#D1F1),a
ld (#D1F2),a
ld (#E241),a
ld (#E242),a
ld (#E243),a
ld (#F293),a
ld (#D2DD),a
ld (#E2D5),a
ld a,#52
ld (#D057),a
ld (#F291),a
ld a,#58
ld (#E005),a
ld (#D051),a
ld (#E0AA),a
ld (#D1E7),a
ld (#D1EC),a
ld (#C2E3),a
ld (#E2DE),a
ld a,#5A
ld (#C0A1),a
ld (#C0FF),a
ld (#D238),a
ld (#C293),a
ld (#F284),a
ld (#F2D7),a
ld a,#62
ld (#E238),a
ld (#D2D1),a
ld (#D2DF),a
ld a,#63
ld (#E008),a
ld a,#6A
ld (#F2DF),a
ld a,#6E
ld (#E0A5),a
ld a,#72
ld (#C052),a
ld (#E051),a
ld (#D280),a
ld a,#7A
ld (#C0FE),a
ld (#E28A),a
ld (#D2D8),a
ld a,#88
ld (#D011),a
ld (#C1E2),a
ld (#F292),a
ld a,#89
ld (#E290),a
ld a,#8A
ld (#F010),a
ld (#C100),a
ld (#E1E3),a
ld (#C233),a
ld (#C234),a
ld (#C242),a
ld (#F241),a
ld (#D289),a
ld (#F283),a
ld a,#8B
ld (#E285),a
ld a,#98
ld (#C004),a
ld (#E001),a
ld (#F147),a
ld (#E1E0),a
ld (#F23B),a
ld (#C28F),a
ld (#C2D1),a
ld a,#9A
ld (#D287),a
ld (#C2D7),a
ld a,#9C
ld (#C23E),a
ld a,#AB
ld (#C053),a
ld a,#AE
ld (#E0F6),a
ld a,#CA
ld (#D100),a
ld (#D192),a
ld a,#CE
ld (#F0FC),a
ld (#F14D),a
ld a,#D8
ld (#E0FC),a
ld (#E1E9),a
ld (#D230),a
ld (#F236),a
ld (#C2D8),a
ld a,#DA
ld (#E013),a
ld a,#DE
ld (#F0A5),a
ld (#F0F6),a
ld a,#EA
ld (#C0AE),a
ld (#F14F),a
ld (#F1F0),a
ld a,#FA
ld (#F19F),a
ld (#F1E4),a
ret

p36to37
ld a,#00
ld (#C008),a
ld (#C00A),a
ld (#C00F),a
ld (#D00A),a
ld (#F008),a
ld (#F00F),a
ld (#D05F),a
ld (#E050),a
ld (#E059),a
ld (#F052),a
ld (#E0F5),a
ld (#F0F1),a
ld (#F100),a
ld (#D152),a
ld (#E14F),a
ld (#E152),a
ld (#C190),a
ld (#C1A2),a
ld (#D190),a
ld (#E1A0),a
ld (#F191),a
ld (#D1E2),a
ld (#E1E1),a
ld (#E1E5),a
ld (#E232),a
ld (#F237),a
ld (#D292),a
ld (#D293),a
ld (#C2DE),a
ld a,#01
ld (#C05B),a
ld (#C060),a
ld (#D0AD),a
ld (#D0AE),a
ld (#E144),a
ld (#D1E3),a
ld (#E283),a
ld (#F28F),a
ld (#C2DF),a
ld (#D2E3),a
ld (#E2DA),a
ld a,#02
ld (#D009),a
ld (#D054),a
ld (#D060),a
ld (#E054),a
ld (#E100),a
ld (#E193),a
ld (#F192),a
ld (#F1E2),a
ld (#E230),a
ld (#F235),a
ld (#E289),a
ld (#E291),a
ld (#C2D9),a
ld (#E2D7),a
ld a,#03
ld (#E0F3),a
ld a,#04
ld (#C010),a
ld (#C059),a
ld (#D05C),a
ld (#E0B1),a
ld (#C0FC),a
ld (#D0FB),a
ld (#D235),a
ld (#C283),a
ld (#D286),a
ld (#E2D3),a
ld a,#05
ld (#E0AE),a
ld (#F1A1),a
ld a,#06
ld (#E010),a
ld (#F009),a
ld (#D0AF),a
ld (#E0AF),a
ld (#F101),a
ld (#C1E3),a
ld (#C282),a
ld a,#08
ld (#D004),a
ld (#D059),a
ld (#C0AF),a
ld (#C0B3),a
ld (#E0F2),a
ld (#C150),a
ld (#F144),a
ld (#C1E2),a
ld (#E233),a
ld (#E239),a
ld (#E240),a
ld (#D284),a
ld a,#09
ld (#D05A),a
ld (#C101),a
ld (#E234),a
ld a,#0A
ld (#D010),a
ld (#F004),a
ld (#F00C),a
ld (#E0B0),a
ld (#F0AF),a
ld (#F0B2),a
ld (#D100),a
ld (#E101),a
ld (#D192),a
ld (#E1E2),a
ld (#E1E3),a
ld (#F1E3),a
ld (#F1EF),a
ld (#F1F1),a
ld (#C233),a
ld (#C292),a
ld (#D282),a
ld (#D2D2),a
ld (#D2D3),a
ld (#F2D3),a
ld a,#0B
ld (#C061),a
ld (#E0A1),a
ld (#E231),a
ld (#F234),a
ld (#F2DB),a
ld a,#0C
ld (#E00C),a
ld (#F05F),a
ld (#C0AB),a
ld (#F1F2),a
ld (#D2E1),a
ld a,#0E
ld (#F239),a
ld a,#10
ld (#C005),a
ld (#C058),a
ld (#C05E),a
ld (#D05E),a
ld (#C0A0),a
ld (#C1E4),a
ld (#C1F0),a
ld (#D1F0),a
ld (#E1E6),a
ld (#F243),a
ld (#C2DB),a
ld (#F2D4),a
ld a,#11
ld (#D008),a
ld (#C238),a
ld a,#12
ld (#C056),a
ld (#E05E),a
ld (#F1A2),a
ld (#E281),a
ld (#E287),a
ld (#F2E0),a
ld a,#14
ld (#D063),a
ld (#D0AC),a
ld (#D239),a
ld a,#16
ld (#D061),a
ld a,#18
ld (#C004),a
ld (#F002),a
ld (#D051),a
ld (#C0A4),a
ld (#F0F3),a
ld (#F0FF),a
ld (#C14E),a
ld (#C19F),a
ld (#D193),a
ld (#E1E0),a
ld (#F1E9),a
ld (#D236),a
ld (#C280),a
ld (#C28F),a
ld (#F280),a
ld a,#1A
ld (#F0B3),a
ld (#D0FF),a
ld (#D101),a
ld (#C1E1),a
ld (#C235),a
ld (#C241),a
ld (#F236),a
ld (#C2D7),a
ld a,#22
ld (#C001),a
ld (#E051),a
ld a,#26
ld (#D0A5),a
ld (#F0AB),a
ld a,#27
ld (#E0A2),a
ld a,#2A
ld (#F05A),a
ld (#D0B0),a
ld (#C1F3),a
ld (#F283),a
ld (#E2E0),a
ld a,#2B
ld (#D2E0),a
ld a,#2E
ld (#E23F),a
ld a,#32
ld (#C05C),a
ld a,#3A
ld (#C285),a
ld a,#3F
ld (#F146),a
ld a,#40
ld (#C013),a
ld (#E00F),a
ld (#F059),a
ld (#D0B3),a
ld (#E0AD),a
ld (#F0AE),a
ld (#C0FA),a
ld (#C103),a
ld (#D0FE),a
ld (#F0F4),a
ld (#F14C),a
ld (#D1EB),a
ld (#D231),a
ld (#F238),a
ld (#F240),a
ld (#C291),a
ld (#E28C),a
ld (#F285),a
ld (#F289),a
ld (#F28E),a
ld (#D2D6),a
ld (#D2DD),a
ld (#F2DA),a
ld (#F2E2),a
ld a,#41
ld (#E003),a
ld (#E05C),a
ld (#C2E2),a
ld a,#42
ld (#F013),a
ld (#D2DF),a
ld (#F2DF),a
ld a,#43
ld (#F003),a
ld (#C0AA),a
ld a,#48
ld (#E05F),a
ld (#C1F1),a
ld (#F1E5),a
ld (#D281),a
ld a,#49
ld (#D28A),a
ld a,#4A
ld (#C242),a
ld (#E285),a
ld (#E28F),a
ld a,#50
ld (#D00F),a
ld (#E007),a
ld (#F051),a
ld (#C0A1),a
ld (#C0F0),a
ld (#C0F4),a
ld (#C0F5),a
ld (#F0FB),a
ld (#C140),a
ld (#D141),a
ld (#D14E),a
ld (#D196),a
ld (#F1ED),a
ld (#C23D),a
ld (#D242),a
ld (#F291),a
ld a,#51
ld (#F2D0),a
ld a,#52
ld (#E063),a
ld (#D14B),a
ld (#D150),a
ld (#D288),a
ld (#D28C),a
ld (#D2D4),a
ld a,#58
ld (#C000),a
ld (#F011),a
ld (#E056),a
ld (#D0A2),a
ld (#F0A7),a
ld (#C102),a
ld (#D0F7),a
ld (#F102),a
ld (#C191),a
ld (#F193),a
ld (#C1EA),a
ld (#C287),a
ld (#F284),a
ld (#F290),a
ld a,#5A
ld (#D0F0),a
ld (#D153),a
ld (#E288),a
ld a,#5C
ld (#F1E8),a
ld a,#62
ld (#C00B),a
ld (#E008),a
ld (#F232),a
ld (#D280),a
ld (#C2D2),a
ld a,#6A
ld (#E0A0),a
ld a,#6F
ld (#F197),a
ld (#F1EE),a
ld a,#72
ld (#F00D),a
ld (#C2D6),a
ld a,#7A
ld (#C054),a
ld (#C0FF),a
ld a,#88
ld (#E2DB),a
ld (#F2E3),a
ld a,#89
ld (#E282),a
ld a,#8A
ld (#C003),a
ld (#D0B1),a
ld (#F0B1),a
ld (#E0F1),a
ld (#D232),a
ld (#D234),a
ld (#C293),a
ld (#F2D8),a
ld a,#8B
ld (#F010),a
ld (#D151),a
ld (#E290),a
ld a,#8C
ld (#D011),a
ld a,#98
ld (#C009),a
ld (#E0AB),a
ld (#E146),a
ld (#E1EF),a
ld (#D28F),a
ld a,#9A
ld (#D283),a
ld (#F287),a
ld a,#9C
ld (#F0A5),a
ld (#F0F6),a
ld a,#9E
ld (#F23F),a
ld a,#AA
ld (#C053),a
ld (#F0B0),a
ld (#F1A0),a
ld (#C234),a
ld (#D233),a
ld (#F241),a
ld a,#BE
ld (#F19E),a
ld a,#CA
ld (#F14F),a
ld (#D238),a
ld a,#D8
ld (#E011),a
ld (#E197),a
ld (#D1EC),a
ld (#F23B),a
ld (#C2D1),a
ld (#E2D0),a
ld a,#DA
ld (#C05D),a
ld (#D287),a
ld a,#DE
ld (#E0A5),a
ld a,#EE
ld (#F054),a
ld (#F14D),a
ld a,#FA
ld (#E013),a
ld (#F05E),a
ld (#F0FE),a
ld (#F1F0),a
ret

p37to38
ld a,#00
ld (#D00E),a
ld (#F001),a
ld (#F00B),a
ld (#C060),a
ld (#D050),a
ld (#F05F),a
ld (#D0A0),a
ld (#C0FB),a
ld (#D0FB),a
ld (#E0F0),a
ld (#E0F2),a
ld (#E102),a
ld (#F101),a
ld (#C151),a
ld (#D140),a
ld (#D1A2),a
ld (#E193),a
ld (#E194),a
ld (#E19D),a
ld (#D1E4),a
ld (#E1F1),a
ld (#C243),a
ld (#D235),a
ld (#E230),a
ld (#F243),a
ld (#C283),a
ld (#D290),a
ld (#E2E1),a
ld a,#01
ld (#E00B),a
ld (#D05D),a
ld (#E060),a
ld (#E0FF),a
ld (#F100),a
ld (#C1A1),a
ld (#F195),a
ld (#F1A1),a
ld (#E286),a
ld (#E2DF),a
ld (#F2D0),a
ld a,#02
ld (#C010),a
ld (#D003),a
ld (#F004),a
ld (#F052),a
ld (#C0AF),a
ld (#E0AF),a
ld (#E0B1),a
ld (#F0A3),a
ld (#F0AE),a
ld (#E0F5),a
ld (#C1E3),a
ld (#E1E1),a
ld (#E1EE),a
ld (#E233),a
ld (#C2D0),a
ld (#D2D1),a
ld (#E2DA),a
ld (#F2E0),a
ld a,#04
ld (#E00C),a
ld (#D063),a
ld (#D0AF),a
ld (#E1E4),a
ld (#F1F2),a
ld (#E291),a
ld a,#05
ld (#D1E3),a
ld a,#06
ld (#D00B),a
ld (#D054),a
ld (#E054),a
ld (#E100),a
ld (#F235),a
ld (#C289),a
ld a,#08
ld (#C062),a
ld (#E050),a
ld (#D0AB),a
ld (#E14F),a
ld (#E152),a
ld (#F239),a
ld (#C282),a
ld (#D286),a
ld (#D2E1),a
ld a,#09
ld (#E0A1),a
ld (#F191),a
ld (#E1E3),a
ld (#D284),a
ld (#E282),a
ld a,#0A
ld (#F010),a
ld (#C061),a
ld (#F061),a
ld (#D0B0),a
ld (#D0FF),a
ld (#F102),a
ld (#D151),a
ld (#F192),a
ld (#F19C),a
ld (#C1E2),a
ld (#C1F3),a
ld (#F1E1),a
ld (#C232),a
ld (#D233),a
ld (#E231),a
ld (#E234),a
ld (#C293),a
ld (#F283),a
ld (#C2D7),a
ld (#C2E3),a
ld (#D2E0),a
ld a,#0B
ld (#F0B2),a
ld (#C100),a
ld (#F1E2),a
ld a,#0C
ld (#C2D3),a
ld (#E2D3),a
ld a,#0D
ld (#D1E2),a
ld a,#0E
ld (#D011),a
ld (#C233),a
ld a,#10
ld (#F008),a
ld (#F00E),a
ld (#E052),a
ld (#F062),a
ld (#C0A4),a
ld (#E0A3),a
ld (#C192),a
ld (#D193),a
ld (#E1A1),a
ld (#D1E5),a
ld (#F23D),a
ld (#E284),a
ld (#F280),a
ld a,#11
ld (#E0F3),a
ld (#E144),a
ld a,#12
ld (#D05E),a
ld (#E05A),a
ld (#E141),a
ld (#E153),a
ld (#C241),a
ld (#F286),a
ld a,#14
ld (#E009),a
ld (#C0F7),a
ld (#E2D8),a
ld a,#15
ld (#D0AE),a
ld (#E0AE),a
ld a,#16
ld (#E2E2),a
ld a,#17
ld (#E0A2),a
ld a,#18
ld (#E001),a
ld (#F011),a
ld (#F0A2),a
ld (#C102),a
ld (#C1E4),a
ld (#D28F),a
ld (#E2D4),a
ld a,#1A
ld (#C0FE),a
ld (#E0F1),a
ld (#F1F3),a
ld (#C292),a
ld (#D283),a
ld (#D2D3),a
ld (#D2DA),a
ld a,#1C
ld (#E239),a
ld (#C28F),a
ld (#D2DB),a
ld a,#1E
ld (#D0A5),a
ld (#C23E),a
ld a,#22
ld (#D009),a
ld (#F060),a
ld (#F0AB),a
ld (#E196),a
ld (#E238),a
ld (#F232),a
ld (#C2D2),a
ld a,#23
ld (#F003),a
ld (#E051),a
ld a,#2A
ld (#D010),a
ld (#E0A0),a
ld (#F0AF),a
ld (#D101),a
ld (#F1E4),a
ld (#E23F),a
ld a,#2B
ld (#E2E0),a
ld a,#2E
ld (#F23F),a
ld a,#2F
ld (#F0FC),a
ld a,#32
ld (#C001),a
ld (#C054),a
ld (#E061),a
ld (#C197),a
ld (#C285),a
ld a,#33
ld (#E14C),a
ld a,#37
ld (#F1EE),a
ld a,#3A
ld (#E013),a
ld (#F1F0),a
ld a,#3F
ld (#F0A4),a
ld a,#40
ld (#F000),a
ld (#F013),a
ld (#E063),a
ld (#E0A4),a
ld (#F0A0),a
ld (#C0FD),a
ld (#C1F1),a
ld (#D1E1),a
ld (#D1F3),a
ld (#F1E7),a
ld (#C231),a
ld (#F28B),a
ld (#F28F),a
ld (#F291),a
ld (#C2E2),a
ld (#D2D5),a
ld (#F2D2),a
ld a,#41
ld (#C2DF),a
ld a,#42
ld (#D057),a
ld (#E0FB),a
ld (#D237),a
ld (#F242),a
ld (#D288),a
ld (#F282),a
ld (#F2D7),a
ld a,#43
ld (#D008),a
ld (#E003),a
ld a,#45
ld (#E235),a
ld (#D2D7),a
ld a,#48
ld (#D004),a
ld (#C05F),a
ld (#F0FF),a
ld (#D2D9),a
ld a,#4A
ld (#F0A1),a
ld (#F14F),a
ld (#C191),a
ld (#D281),a
ld a,#50
ld (#C00C),a
ld (#E005),a
ld (#F006),a
ld (#F00F),a
ld (#C051),a
ld (#C057),a
ld (#D055),a
ld (#C0A0),a
ld (#E0B2),a
ld (#F0A7),a
ld (#C0FA),a
ld (#D0F1),a
ld (#D0F2),a
ld (#D0F3),a
ld (#E1A3),a
ld (#D1EA),a
ld (#D1F0),a
ld (#D243),a
ld (#E23E),a
ld (#F231),a
ld (#C28A),a
ld (#E292),a
ld (#E293),a
ld (#E2DE),a
ld (#F2D6),a
ld (#F2E2),a
ld a,#52
ld (#E000),a
ld (#D056),a
ld (#E05E),a
ld (#E151),a
ld (#D285),a
ld (#C2D6),a
ld a,#58
ld (#D000),a
ld (#E004),a
ld (#C0A9),a
ld (#D0A8),a
ld (#D0F0),a
ld (#D102),a
ld (#D141),a
ld (#E14D),a
ld (#C19F),a
ld (#D1EC),a
ld (#F1E9),a
ld (#C23A),a
ld (#D230),a
ld (#E23B),a
ld (#C2E0),a
ld a,#5A
ld (#D00C),a
ld (#C050),a
ld (#F0FE),a
ld (#E142),a
ld (#C1E1),a
ld (#E28A),a
ld a,#62
ld (#C0AA),a
ld (#C1E7),a
ld a,#63
ld (#C00B),a
ld a,#6E
ld (#F197),a
ld a,#72
ld (#C1EF),a
ld (#D28C),a
ld (#D2D8),a
ld a,#77
ld (#F0F5),a
ld a,#7A
ld (#C19E),a
ld (#C234),a
ld (#D287),a
ld a,#88
ld (#F053),a
ld (#C0B0),a
ld (#C0B2),a
ld a,#89
ld (#F2D3),a
ld a,#8A
ld (#F1A0),a
ld (#F1EF),a
ld (#F1F1),a
ld (#F287),a
ld (#D2D2),a
ld a,#8B
ld (#D289),a
ld a,#8E
ld (#D061),a
ld (#F054),a
ld (#E290),a
ld a,#98
ld (#E011),a
ld (#F002),a
ld (#F0A5),a
ld (#E0FC),a
ld (#F0F6),a
ld (#C280),a
ld (#E2D0),a
ld a,#9A
ld (#F19F),a
ld a,#9C
ld (#E0A5),a
ld a,#AA
ld (#F0B1),a
ld (#D234),a
ld (#F233),a
ld (#F292),a
ld a,#AE
ld (#C053),a
ld a,#BE
ld (#E0F6),a
ld a,#BF
ld (#F146),a
ld a,#C8
ld (#D238),a
ld (#E28F),a
ld (#C2D5),a
ld (#F2DB),a
ld a,#CA
ld (#C0AE),a
ld a,#CB
ld (#C002),a
ld a,#D8
ld (#E0AB),a
ld (#C14E),a
ld (#C1E8),a
ld (#C287),a
ld (#F290),a
ld a,#DA
ld (#F193),a
ld (#C286),a
ld a,#EA
ld (#F05E),a
ld (#F241),a
ld a,#FA
ld (#C0FF),a
ld (#C235),a
ld (#F28A),a
ld a,#FE
ld (#F19E),a
ret

p38to39
ld a,#00
ld (#D012),a
ld (#C059),a
ld (#E060),a
ld (#D0AF),a
ld (#F0A0),a
ld (#E0F4),a
ld (#F100),a
ld (#C192),a
ld (#C1A1),a
ld (#D1E2),a
ld (#D2E3),a
ld (#E2D7),a
ld a,#01
ld (#C008),a
ld (#E05C),a
ld (#C0AC),a
ld (#D0AE),a
ld (#F0B2),a
ld (#D0FB),a
ld (#E0F3),a
ld (#E144),a
ld (#F1F2),a
ld (#C232),a
ld (#C238),a
ld a,#02
ld (#E003),a
ld (#E00B),a
ld (#C062),a
ld (#D0B0),a
ld (#C102),a
ld (#D0FF),a
ld (#D140),a
ld (#C190),a
ld (#F190),a
ld (#F192),a
ld (#D231),a
ld a,#03
ld (#F2E0),a
ld a,#04
ld (#D05B),a
ld (#D0AD),a
ld (#C0FB),a
ld (#D193),a
ld (#E232),a
ld (#E233),a
ld (#F235),a
ld (#F243),a
ld (#E283),a
ld (#D2D7),a
ld a,#05
ld (#E00C),a
ld (#E0AE),a
ld (#E0FF),a
ld (#D1E4),a
ld (#E235),a
ld a,#06
ld (#F001),a
ld (#D05C),a
ld (#E145),a
ld (#C2D2),a
ld (#E2E2),a
ld a,#07
ld (#E051),a
ld (#E100),a
ld (#C233),a
ld a,#08
ld (#D00A),a
ld (#C061),a
ld (#D05D),a
ld (#D062),a
ld (#E0A1),a
ld (#E0B1),a
ld (#F0F3),a
ld (#D151),a
ld (#E1A0),a
ld (#D235),a
ld (#F234),a
ld (#C2D3),a
ld (#E2D3),a
ld (#E2E1),a
ld a,#09
ld (#D198),a
ld (#D1E3),a
ld (#D286),a
ld a,#0A
ld (#E061),a
ld (#F05A),a
ld (#F05D),a
ld (#C0B2),a
ld (#C0B3),a
ld (#F0A1),a
ld (#F0B0),a
ld (#D101),a
ld (#E151),a
ld (#E192),a
ld (#F1E2),a
ld (#F1E4),a
ld (#D232),a
ld (#F242),a
ld a,#0B
ld (#E050),a
ld (#E0B0),a
ld (#C282),a
ld (#E282),a
ld (#E2E0),a
ld a,#0C
ld (#D100),a
ld (#F144),a
ld a,#0E
ld (#C101),a
ld (#E1E1),a
ld a,#0F
ld (#C100),a
ld (#E101),a
ld a,#10
ld (#E007),a
ld (#C056),a
ld (#C152),a
ld (#D191),a
ld (#E1E0),a
ld (#E1F2),a
ld (#C241),a
ld (#D239),a
ld (#C28C),a
ld (#C28D),a
ld (#D290),a
ld a,#11
ld (#E0A2),a
ld a,#12
ld (#C054),a
ld (#E103),a
ld (#D1A3),a
ld (#E191),a
ld (#C285),a
ld a,#14
ld (#E239),a
ld (#E287),a
ld a,#16
ld (#E009),a
ld a,#18
ld (#D000),a
ld (#D007),a
ld (#D0A5),a
ld (#D0B2),a
ld (#E14F),a
ld (#F2D1),a
ld a,#1A
ld (#C009),a
ld (#E0A0),a
ld (#C14D),a
ld (#C1E4),a
ld (#C1F3),a
ld (#D233),a
ld (#D236),a
ld (#F283),a
ld a,#1C
ld (#E011),a
ld (#F011),a
ld (#D28F),a
ld (#E2D8),a
ld a,#1E
ld (#E054),a
ld (#C28F),a
ld a,#22
ld (#D003),a
ld (#D00B),a
ld (#D010),a
ld (#E000),a
ld (#F003),a
ld (#E1E2),a
ld (#E289),a
ld (#F282),a
ld (#C2D0),a
ld a,#23
ld (#F0AB),a
ld (#E0F5),a
ld (#F0FC),a
ld (#E23F),a
ld a,#2A
ld (#F061),a
ld (#E0AF),a
ld (#F0B1),a
ld (#F102),a
ld (#F241),a
ld (#D282),a
ld a,#2B
ld (#D011),a
ld a,#2E
ld (#C23E),a
ld a,#32
ld (#E05A),a
ld (#C0AD),a
ld (#D2D8),a
ld a,#33
ld (#F1EE),a
ld a,#3A
ld (#C197),a
ld (#D1E8),a
ld (#C234),a
ld (#C2E3),a
ld (#D2DA),a
ld a,#40
ld (#C007),a
ld (#D004),a
ld (#C05F),a
ld (#E057),a
ld (#E05F),a
ld (#F051),a
ld (#C0A3),a
ld (#D0A0),a
ld (#D0A4),a
ld (#E0F9),a
ld (#E0FB),a
ld (#C14A),a
ld (#E150),a
ld (#D190),a
ld (#D1A1),a
ld (#E19F),a
ld (#F196),a
ld (#F199),a
ld (#C1E1),a
ld (#C1EB),a
ld (#E1EE),a
ld (#E1F0),a
ld (#C242),a
ld (#F237),a
ld (#C281),a
ld (#C2DC),a
ld (#C2DF),a
ld (#E2D2),a
ld (#E2D6),a
ld (#E2DF),a
ld (#F2D7),a
ld a,#41
ld (#E0A4),a
ld (#D1EB),a
ld (#F238),a
ld (#F2D2),a
ld a,#42
ld (#D056),a
ld (#D060),a
ld (#F143),a
ld (#D1E1),a
ld (#E23D),a
ld (#E285),a
ld a,#44
ld (#F009),a
ld (#C0AB),a
ld (#C0FC),a
ld a,#48
ld (#E193),a
ld a,#4A
ld (#F010),a
ld (#F05E),a
ld (#C150),a
ld (#F1A0),a
ld (#F1E1),a
ld (#E234),a
ld (#D280),a
ld a,#4B
ld (#D281),a
ld a,#50
ld (#C004),a
ld (#E00D),a
ld (#F000),a
ld (#F00E),a
ld (#C050),a
ld (#C058),a
ld (#D0A8),a
ld (#E0A9),a
ld (#D0F0),a
ld (#D0FA),a
ld (#D153),a
ld (#E140),a
ld (#F151),a
ld (#C1A3),a
ld (#E19D),a
ld (#C1F1),a
ld (#D1E9),a
ld (#E1EC),a
ld (#C240),a
ld (#D241),a
ld (#F23E),a
ld (#C28E),a
ld (#D293),a
ld (#E28E),a
ld (#F284),a
ld a,#52
ld (#D00F),a
ld (#E004),a
ld (#F00D),a
ld (#D05E),a
ld (#D0AA),a
ld (#D237),a
ld a,#54
ld (#C289),a
ld a,#58
ld (#F00A),a
ld (#F05B),a
ld (#E0A8),a
ld (#E0B2),a
ld (#E0FA),a
ld (#C1F0),a
ld (#E1E8),a
ld (#E1E9),a
ld (#C236),a
ld (#F23B),a
ld (#E28A),a
ld (#F2D9),a
ld a,#5A
ld (#D141),a
ld (#F1E5),a
ld (#D283),a
ld (#D2D4),a
ld a,#63
ld (#D008),a
ld a,#6A
ld (#C052),a
ld (#F0F2),a
ld (#D234),a
ld a,#72
ld (#C14F),a
ld a,#7A
ld (#C001),a
ld (#D150),a
ld (#E142),a
ld (#F28A),a
ld a,#7F
ld (#F0F5),a
ld a,#88
ld (#F00C),a
ld (#E240),a
ld (#D289),a
ld (#D2D2),a
ld (#F2DB),a
ld a,#89
ld (#D05A),a
ld (#F053),a
ld a,#8A
ld (#C0AE),a
ld (#C0B0),a
ld (#C151),a
ld (#E152),a
ld (#C1E3),a
ld (#E231),a
ld (#F232),a
ld a,#8B
ld (#C002),a
ld (#D061),a
ld (#C191),a
ld (#E1E3),a
ld a,#8C
ld (#D2E1),a
ld a,#8E
ld (#C053),a
ld a,#98
ld (#E0A5),a
ld (#F0A2),a
ld (#D102),a
ld (#D14C),a
ld (#F290),a
ld (#C2D8),a
ld (#C2E0),a
ld (#D2D3),a
ld a,#9E
ld (#F054),a
ld (#E0F6),a
ld a,#AA
ld (#C003),a
ld (#F0AF),a
ld (#C1E2),a
ld a,#AE
ld (#E290),a
ld a,#BF
ld (#F19D),a
ld a,#C8
ld (#D0AB),a
ld a,#CA
ld (#C05D),a
ld (#D2E0),a
ld a,#D8
ld (#F002),a
ld (#E056),a
ld (#D0F7),a
ld (#E14D),a
ld (#C19F),a
ld (#C1EA),a
ld (#D1E7),a
ld (#E23B),a
ld (#C280),a
ld (#E2DB),a
ld a,#DA
ld (#F233),a
ld (#E288),a
ld a,#EA
ld (#C0FF),a
ld a,#EE
ld (#F197),a
ld (#F19E),a
ld a,#EF
ld (#F14D),a
ld a,#FA
ld (#E0AB),a
ld (#F193),a
ld (#C286),a
ld a,#FF
ld (#F146),a
ret

p39to40
ld a,#00
ld (#D05B),a
ld (#D063),a
ld (#D0B0),a
ld (#E0A1),a
ld (#D0FE),a
ld (#F141),a
ld (#F151),a
ld (#F1F2),a
ld (#E242),a
ld (#D286),a
ld (#D2D7),a
ld (#E2D3),a
ld a,#01
ld (#E00C),a
ld (#E010),a
ld (#E0A2),a
ld (#E101),a
ld (#E1E5),a
ld a,#02
ld (#D009),a
ld (#D012),a
ld (#E000),a
ld (#F001),a
ld (#E061),a
ld (#F060),a
ld (#D100),a
ld (#E151),a
ld (#D192),a
ld (#D1A3),a
ld (#E193),a
ld (#D1E1),a
ld (#E1E0),a
ld (#F1E4),a
ld (#E23F),a
ld (#C2D7),a
ld a,#03
ld (#C010),a
ld (#C231),a
ld a,#04
ld (#C00A),a
ld (#C060),a
ld (#C062),a
ld (#E0AE),a
ld (#E0B1),a
ld (#C192),a
ld (#E194),a
ld (#C233),a
ld (#C238),a
ld (#E236),a
ld (#E2E2),a
ld (#F2D0),a
ld a,#05
ld (#C05B),a
ld (#D0AD),a
ld (#D0AE),a
ld (#C101),a
ld (#E1E4),a
ld a,#06
ld (#E003),a
ld (#E100),a
ld (#E282),a
ld (#F282),a
ld a,#07
ld (#D0FF),a
ld (#E145),a
ld (#C232),a
ld a,#08
ld (#D00E),a
ld (#F051),a
ld (#E0B0),a
ld (#F0B2),a
ld (#C100),a
ld (#E0F4),a
ld (#E102),a
ld (#F103),a
ld (#C152),a
ld (#D152),a
ld (#C1A1),a
ld (#D1A2),a
ld (#F191),a
ld (#D1E4),a
ld (#F236),a
ld (#D284),a
ld (#D2D2),a
ld (#F2D8),a
ld a,#09
ld (#D00A),a
ld (#D05A),a
ld (#D061),a
ld (#F2D3),a
ld a,#0A
ld (#E011),a
ld (#E050),a
ld (#D0B1),a
ld (#F0B1),a
ld (#F0FF),a
ld (#F100),a
ld (#D151),a
ld (#E153),a
ld (#F192),a
ld (#D1E2),a
ld (#D1E3),a
ld (#F1F1),a
ld (#D233),a
ld (#C282),a
ld (#D280),a
ld (#F287),a
ld a,#0B
ld (#E1E3),a
ld a,#0C
ld (#C061),a
ld (#E1E1),a
ld (#E232),a
ld a,#0E
ld (#C05A),a
ld (#F0B0),a
ld (#C2D2),a
ld a,#10
ld (#C006),a
ld (#D006),a
ld (#D007),a
ld (#E001),a
ld (#F00B),a
ld (#F056),a
ld (#F0A8),a
ld (#E141),a
ld (#F152),a
ld (#C193),a
ld (#F1A2),a
ld (#E243),a
ld (#C283),a
ld (#D292),a
ld (#E2D7),a
ld a,#11
ld (#D0FB),a
ld a,#12
ld (#C0AF),a
ld (#D0AF),a
ld (#F0B3),a
ld (#C292),a
ld (#C2D9),a
ld a,#14
ld (#D28F),a
ld (#D2DB),a
ld a,#15
ld (#E051),a
ld a,#16
ld (#E013),a
ld (#C0F7),a
ld a,#18
ld (#E0B2),a
ld (#E143),a
ld (#D1E5),a
ld (#E1EF),a
ld (#F23D),a
ld (#C2D3),a
ld (#C2E0),a
ld (#D2D3),a
ld (#E2D0),a
ld a,#1A
ld (#C054),a
ld (#C05C),a
ld (#D102),a
ld (#F1E5),a
ld (#C234),a
ld (#C2D8),a
ld (#C2E3),a
ld a,#1C
ld (#D054),a
ld (#D0B2),a
ld (#F1E8),a
ld (#F290),a
ld a,#1E
ld (#C053),a
ld a,#22
ld (#D231),a
ld (#D282),a
ld a,#23
ld (#F23F),a
ld a,#26
ld (#C23E),a
ld (#E289),a
ld a,#2A
ld (#C003),a
ld (#C0B3),a
ld (#F101),a
ld (#E191),a
ld (#E1E7),a
ld (#E238),a
ld (#F292),a
ld a,#2B
ld (#C002),a
ld (#E0F5),a
ld (#D281),a
ld a,#2E
ld (#F003),a
ld (#C14D),a
ld a,#32
ld (#D00B),a
ld (#F052),a
ld (#F241),a
ld (#D287),a
ld (#C2D0),a
ld a,#36
ld (#D2D8),a
ld a,#3A
ld (#C009),a
ld (#E0AF),a
ld (#F0A1),a
ld (#C0FE),a
ld (#D150),a
ld (#C19E),a
ld a,#3E
ld (#C28F),a
ld a,#40
ld (#F000),a
ld (#D060),a
ld (#E053),a
ld (#E059),a
ld (#C0A8),a
ld (#E0A9),a
ld (#E0F2),a
ld (#E0FE),a
ld (#F140),a
ld (#C194),a
ld (#D191),a
ld (#E190),a
ld (#E195),a
ld (#E241),a
ld (#F231),a
ld (#F234),a
ld (#C284),a
ld (#D28A),a
ld (#D2DF),a
ld (#F2DF),a
ld a,#41
ld (#E0AD),a
ld (#E144),a
ld (#F1E7),a
ld (#F289),a
ld (#F28B),a
ld (#D2DD),a
ld (#E2D2),a
ld a,#42
ld (#D010),a
ld (#C1E1),a
ld (#C1EB),a
ld a,#43
ld (#F2D2),a
ld a,#48
ld (#F194),a
ld (#C2D1),a
ld (#C2D5),a
ld a,#49
ld (#F05A),a
ld a,#4A
ld (#F293),a
ld a,#50
ld (#C000),a
ld (#C011),a
ld (#D002),a
ld (#E00F),a
ld (#F013),a
ld (#E05E),a
ld (#E05F),a
ld (#D0A0),a
ld (#D0A1),a
ld (#D0A2),a
ld (#F14C),a
ld (#C1EC),a
ld (#D1EC),a
ld (#D1F3),a
ld (#E1E8),a
ld (#F1E9),a
ld (#C241),a
ld (#D230),a
ld (#D23D),a
ld (#F23A),a
ld (#C291),a
ld (#D28E),a
ld (#D290),a
ld (#F285),a
ld (#C2D6),a
ld (#D2DE),a
ld (#E2E3),a
ld (#F2D4),a
ld a,#51
ld (#C008),a
ld (#F238),a
ld a,#52
ld (#D005),a
ld (#E008),a
ld (#C1EF),a
ld (#D28C),a
ld (#E285),a
ld a,#53
ld (#E0A4),a
ld a,#54
ld (#E239),a
ld a,#58
ld (#D051),a
ld (#E062),a
ld (#F0A5),a
ld (#F0AC),a
ld (#E0F7),a
ld (#F0F6),a
ld (#D142),a
ld (#E197),a
ld (#C1EA),a
ld (#F288),a
ld (#F2D1),a
ld (#F2E1),a
ld a,#5A
ld (#F050),a
ld (#D234),a
ld (#F233),a
ld a,#62
ld (#D008),a
ld (#E234),a
ld (#D288),a
ld a,#63
ld (#F0AB),a
ld a,#6A
ld (#C001),a
ld (#F010),a
ld (#E142),a
ld a,#6F
ld (#E290),a
ld a,#72
ld (#D237),a
ld a,#7A
ld (#F0FE),a
ld (#C14F),a
ld (#C2DA),a
ld a,#7F
ld (#F0A4),a
ld a,#88
ld (#D062),a
ld (#C0AE),a
ld (#E28F),a
ld (#D2E0),a
ld (#D2E1),a
ld (#E2E1),a
ld a,#8A
ld (#F061),a
ld (#C191),a
ld (#E192),a
ld (#E1E2),a
ld (#F1E3),a
ld (#D235),a
ld (#F242),a
ld a,#8B
ld (#E2E0),a
ld a,#8C
ld (#F00C),a
ld (#E2D8),a
ld a,#98
ld (#F054),a
ld (#D0A5),a
ld (#E0A8),a
ld (#E14D),a
ld (#F283),a
ld a,#9A
ld (#F05D),a
ld (#F0A2),a
ld a,#9B
ld (#F053),a
ld a,#9C
ld (#E0FC),a
ld a,#9E
ld (#E054),a
ld a,#AA
ld (#F19C),a
ld (#C1E3),a
ld (#F2E3),a
ld a,#AE
ld (#F1EF),a
ld a,#BA
ld (#D101),a
ld a,#BB
ld (#F19D),a
ld a,#C8
ld (#E056),a
ld (#D2D9),a
ld a,#C9
ld (#D238),a
ld a,#CA
ld (#F05E),a
ld (#F0AF),a
ld (#C0FF),a
ld a,#CB
ld (#C00B),a
ld a,#CE
ld (#F197),a
ld a,#D8
ld (#F05B),a
ld (#F147),a
ld (#C236),a
ld a,#DA
ld (#D0F7),a
ld a,#EA
ld (#C150),a
ld a,#EF
ld (#F0F5),a
ld a,#FF
ld (#F14D),a
ret

p40to41
ld a,#00
ld (#C00A),a
ld (#C010),a
ld (#E00C),a
ld (#F000),a
ld (#C060),a
ld (#C062),a
ld (#E05D),a
ld (#F060),a
ld (#D0AC),a
ld (#C100),a
ld (#E0F3),a
ld (#F1A1),a
ld (#E1E1),a
ld (#F1E9),a
ld (#C232),a
ld (#C233),a
ld (#E232),a
ld (#E233),a
ld (#E23F),a
ld (#F243),a
ld (#F2D3),a
ld a,#01
ld (#E051),a
ld (#E0AD),a
ld (#C101),a
ld (#E150),a
ld (#F151),a
ld (#E235),a
ld a,#02
ld (#C061),a
ld (#D05C),a
ld (#F141),a
ld (#D191),a
ld (#C231),a
ld (#E230),a
ld (#F289),a
ld (#C2D9),a
ld a,#03
ld (#E05C),a
ld (#C0B1),a
ld a,#04
ld (#E009),a
ld (#F009),a
ld (#C05B),a
ld (#D0AD),a
ld (#D0AE),a
ld (#F0B0),a
ld (#E102),a
ld (#E193),a
ld (#E1F1),a
ld (#E287),a
ld a,#05
ld (#D05B),a
ld (#D0FF),a
ld (#D192),a
ld (#D193),a
ld (#F1E4),a
ld (#E2E2),a
ld a,#06
ld (#D003),a
ld (#D009),a
ld (#E013),a
ld (#E061),a
ld (#F152),a
ld (#D2D8),a
ld (#F2D0),a
ld a,#07
ld (#E000),a
ld a,#08
ld (#E050),a
ld (#F144),a
ld (#C191),a
ld (#E192),a
ld (#D233),a
ld (#F240),a
ld (#D280),a
ld (#E283),a
ld (#D2D3),a
ld (#D2E0),a
ld (#D2E1),a
ld a,#09
ld (#C152),a
ld a,#0A
ld (#D012),a
ld (#D061),a
ld (#F061),a
ld (#C0B0),a
ld (#F0A2),a
ld (#E100),a
ld (#D150),a
ld (#D152),a
ld (#E152),a
ld (#C190),a
ld (#C1E2),a
ld (#D1E1),a
ld (#E1E2),a
ld (#E1E3),a
ld (#F236),a
ld (#F242),a
ld (#D281),a
ld (#D282),a
ld (#E289),a
ld (#F282),a
ld (#D2D2),a
ld a,#0B
ld (#E101),a
ld (#D151),a
ld (#F191),a
ld (#D1E4),a
ld (#F293),a
ld a,#0C
ld (#F00C),a
ld (#C282),a
ld a,#0E
ld (#E153),a
ld (#D231),a
ld a,#0F
ld (#F192),a
ld a,#10
ld (#D013),a
ld (#C058),a
ld (#F05F),a
ld (#C0F7),a
ld (#D194),a
ld (#E1EF),a
ld (#F1E8),a
ld (#F23C),a
ld (#C292),a
ld (#E281),a
ld (#F28F),a
ld (#E2D0),a
ld a,#11
ld (#D198),a
ld a,#12
ld (#C009),a
ld (#F011),a
ld (#C234),a
ld (#D234),a
ld (#E2D3),a
ld (#E2D9),a
ld a,#14
ld (#F0A8),a
ld (#C2DE),a
ld a,#16
ld (#D0B2),a
ld (#D28F),a
ld (#E2DA),a
ld a,#18
ld (#C053),a
ld (#F062),a
ld (#E0A3),a
ld (#C103),a
ld (#E0F7),a
ld (#F0FD),a
ld (#D142),a
ld (#D14C),a
ld (#C193),a
ld (#F283),a
ld (#F2D9),a
ld a,#1A
ld (#F0A1),a
ld (#C19E),a
ld (#D1E8),a
ld a,#1C
ld (#C2E0),a
ld a,#22
ld (#C003),a
ld (#D00B),a
ld (#C1E1),a
ld (#C1E7),a
ld (#C28F),a
ld (#F292),a
ld (#D2D1),a
ld a,#23
ld (#C23E),a
ld a,#26
ld (#E00B),a
ld a,#27
ld (#E145),a
ld a,#2A
ld (#E011),a
ld (#C0FE),a
ld (#D101),a
ld (#F190),a
ld (#F193),a
ld (#C1E3),a
ld (#C1F3),a
ld (#F1E2),a
ld (#F1F0),a
ld (#F232),a
ld (#F287),a
ld (#C2D0),a
ld a,#2B
ld (#C0B2),a
ld a,#2F
ld (#E196),a
ld (#E290),a
ld a,#32
ld (#F001),a
ld a,#33
ld (#E0A4),a
ld (#F23F),a
ld a,#36
ld (#D287),a
ld a,#3A
ld (#F050),a
ld (#F052),a
ld (#C0AD),a
ld (#D236),a
ld (#E238),a
ld (#C2D8),a
ld a,#3B
ld (#F053),a
ld (#F19D),a
ld a,#3E
ld (#F290),a
ld a,#40
ld (#D053),a
ld (#E060),a
ld (#F055),a
ld (#F057),a
ld (#E0A1),a
ld (#C0F1),a
ld (#F0F1),a
ld (#D14F),a
ld (#E144),a
ld (#F1A0),a
ld (#D1EB),a
ld (#D230),a
ld (#D23A),a
ld (#D23D),a
ld (#F239),a
ld (#C288),a
ld (#C293),a
ld (#E280),a
ld (#F28B),a
ld (#D2D0),a
ld (#F2E2),a
ld a,#41
ld (#C008),a
ld (#E053),a
ld (#E057),a
ld (#D28A),a
ld a,#42
ld (#F0A3),a
ld (#C143),a
ld (#F14F),a
ld (#C1A0),a
ld (#D1A1),a
ld (#C1EF),a
ld a,#46
ld (#C0AB),a
ld a,#48
ld (#E056),a
ld (#F05A),a
ld (#F237),a
ld (#C284),a
ld a,#49
ld (#F2D8),a
ld (#F2E0),a
ld a,#4A
ld (#C052),a
ld (#C05D),a
ld (#E142),a
ld a,#50
ld (#D00F),a
ld (#E001),a
ld (#E008),a
ld (#F00D),a
ld (#C056),a
ld (#D051),a
ld (#E052),a
ld (#E055),a
ld (#E05B),a
ld (#C0A4),a
ld (#C0A7),a
ld (#D0AA),a
ld (#F0A5),a
ld (#D0F6),a
ld (#E0F2),a
ld (#F0F6),a
ld (#E141),a
ld (#D190),a
ld (#E1A1),a
ld (#C242),a
ld (#F23B),a
ld (#C283),a
ld (#D292),a
ld (#E284),a
ld (#E285),a
ld (#E28C),a
ld (#C2DB),a
ld (#D2D6),a
ld (#D2DF),a
ld (#E2D7),a
ld a,#51
ld (#F1E7),a
ld a,#52
ld (#F00B),a
ld (#D0AF),a
ld (#C0F2),a
ld (#C2DD),a
ld (#F2DA),a
ld a,#53
ld (#F1EE),a
ld a,#58
ld (#C011),a
ld (#D00C),a
ld (#E005),a
ld (#E0A8),a
ld (#F142),a
ld (#F147),a
ld (#F153),a
ld (#F19A),a
ld (#F233),a
ld (#C280),a
ld (#E28F),a
ld (#E2D4),a
ld (#E2DB),a
ld a,#5A
ld (#F0FE),a
ld (#C14F),a
ld (#C287),a
ld a,#5C
ld (#E0FC),a
ld a,#62
ld (#F010),a
ld (#F0AB),a
ld (#C1EB),a
ld (#D237),a
ld (#E23D),a
ld (#C281),a
ld a,#63
ld (#F0FC),a
ld (#E14C),a
ld (#F2D2),a
ld a,#6A
ld (#F1E1),a
ld (#D288),a
ld a,#6F
ld (#F0A4),a
ld a,#72
ld (#E234),a
ld (#D283),a
ld a,#7A
ld (#E0AB),a
ld (#F0F2),a
ld a,#7F
ld (#F14D),a
ld a,#88
ld (#D0AB),a
ld (#F19F),a
ld (#E2D8),a
ld (#E2E0),a
ld a,#8A
ld (#F0B1),a
ld (#C0FF),a
ld (#D102),a
ld (#F102),a
ld (#D141),a
ld (#D1E2),a
ld (#D232),a
ld (#E2E1),a
ld a,#8B
ld (#D1A2),a
ld (#E231),a
ld (#C2D2),a
ld a,#8E
ld (#F003),a
ld a,#98
ld (#F00A),a
ld (#D054),a
ld (#E054),a
ld (#F05B),a
ld (#F0AC),a
ld (#F23D),a
ld a,#9A
ld (#C054),a
ld (#C05C),a
ld (#F051),a
ld a,#9E
ld (#F197),a
ld a,#AA
ld (#F100),a
ld (#F101),a
ld (#D1E3),a
ld (#E1E7),a
ld a,#AE
ld (#C002),a
ld (#E0F6),a
ld (#F0F5),a
ld a,#AF
ld (#E0F5),a
ld a,#BA
ld (#F0AE),a
ld (#F19C),a
ld (#C1E4),a
ld a,#C8
ld (#F002),a
ld (#F05E),a
ld (#D1E7),a
ld a,#CA
ld (#C001),a
ld (#C00B),a
ld a,#CB
ld (#F0AF),a
ld (#D238),a
ld (#D2D9),a
ld a,#D8
ld (#E062),a
ld (#C0A9),a
ld a,#DA
ld (#E0AF),a
ld a,#EA
ld (#D0F7),a
ld (#F2E3),a
ld a,#EE
ld (#F1EF),a
ld a,#EF
ld (#F19E),a
ld a,#FA
ld (#C150),a
ret

p41to42
ld a,#00
ld (#E00A),a
ld (#E051),a
ld (#C0B1),a
ld (#D0AD),a
ld (#E0A2),a
ld (#E0AD),a
ld (#E0B0),a
ld (#E0B1),a
ld (#F0B0),a
ld (#C0FD),a
ld (#C141),a
ld (#D14F),a
ld (#F152),a
ld (#D1A3),a
ld (#E190),a
ld (#E194),a
ld (#E195),a
ld (#F195),a
ld (#F19B),a
ld (#C231),a
ld (#D23D),a
ld (#F235),a
ld (#D280),a
ld (#E286),a
ld (#E292),a
ld (#E293),a
ld (#D2D5),a
ld (#D2E1),a
ld a,#01
ld (#E0FE),a
ld (#D198),a
ld (#C1F2),a
ld (#E232),a
ld (#D286),a
ld (#E287),a
ld (#F28E),a
ld a,#02
ld (#D05A),a
ld (#D063),a
ld (#D0B1),a
ld (#C100),a
ld (#E0F0),a
ld (#E102),a
ld (#C1F3),a
ld (#F1E5),a
ld (#C234),a
ld a,#03
ld (#F191),a
ld a,#04
ld (#C00A),a
ld (#C0AC),a
ld (#E0FF),a
ld (#E153),a
ld (#F1A1),a
ld (#E1E5),a
ld (#F1E4),a
ld (#E242),a
ld (#D2D8),a
ld a,#05
ld (#E013),a
ld (#D0AC),a
ld (#D0FE),a
ld (#E150),a
ld (#E193),a
ld a,#06
ld (#C0AB),a
ld (#C14D),a
ld (#E151),a
ld a,#07
ld (#D192),a
ld a,#08
ld (#C0FF),a
ld (#C101),a
ld (#D142),a
ld (#C1A2),a
ld (#E1A3),a
ld (#E1E2),a
ld (#F1F1),a
ld (#F242),a
ld (#E282),a
ld (#E2E0),a
ld (#F2E0),a
ld a,#09
ld (#D00E),a
ld (#C0AE),a
ld (#F140),a
ld a,#0A
ld (#C003),a
ld (#D00B),a
ld (#F000),a
ld (#F011),a
ld (#C05A),a
ld (#D062),a
ld (#F0B1),a
ld (#F0B2),a
ld (#D100),a
ld (#D101),a
ld (#E0F4),a
ld (#F103),a
ld (#D141),a
ld (#D151),a
ld (#F153),a
ld (#C191),a
ld (#C192),a
ld (#C1A1),a
ld (#D1A2),a
ld (#E191),a
ld (#F192),a
ld (#F194),a
ld (#C1E1),a
ld (#D1E2),a
ld (#D1E5),a
ld (#F1F0),a
ld (#D231),a
ld (#F232),a
ld a,#0B
ld (#C0B2),a
ld (#E192),a
ld (#E231),a
ld a,#0C
ld (#C238),a
ld (#E291),a
ld a,#0E
ld (#D012),a
ld (#D0B2),a
ld (#F193),a
ld (#D281),a
ld a,#0F
ld (#C151),a
ld (#D191),a
ld (#C1E2),a
ld a,#10
ld (#D060),a
ld (#E0A0),a
ld (#C0F8),a
ld (#E103),a
ld (#F288),a
ld (#C2D3),a
ld (#D2E3),a
ld a,#11
ld (#E05C),a
ld (#F238),a
ld a,#12
ld (#F004),a
ld (#F00B),a
ld (#F05C),a
ld (#F292),a
ld (#C2E3),a
ld (#F2DA),a
ld a,#14
ld (#D006),a
ld (#E007),a
ld (#F056),a
ld (#C0FB),a
ld (#E239),a
ld (#C289),a
ld a,#16
ld (#F241),a
ld (#D287),a
ld a,#18
ld (#C00D),a
ld (#F00A),a
ld (#D05D),a
ld (#E054),a
ld (#F054),a
ld (#F0AD),a
ld (#C153),a
ld (#C198),a
ld (#E1E6),a
ld (#F23C),a
ld (#F23D),a
ld (#F2E1),a
ld a,#1A
ld (#D003),a
ld (#F05D),a
ld (#E0B2),a
ld (#C190),a
ld (#C193),a
ld (#C1E3),a
ld (#E243),a
ld (#D2E0),a
ld a,#22
ld (#C009),a
ld (#E00B),a
ld (#C061),a
ld (#E1E0),a
ld (#C281),a
ld (#F2D0),a
ld (#F2D2),a
ld a,#23
ld (#C28F),a
ld (#E290),a
ld a,#26
ld (#D28F),a
ld a,#27
ld (#E0A4),a
ld a,#2A
ld (#D061),a
ld (#E0F6),a
ld (#E100),a
ld (#F101),a
ld (#D152),a
ld (#D1E3),a
ld (#F1E1),a
ld (#F236),a
ld (#D2D2),a
ld (#F2E3),a
ld a,#2B
ld (#E011),a
ld a,#2E
ld (#F290),a
ld a,#32
ld (#C1EB),a
ld a,#36
ld (#C2E0),a
ld a,#37
ld (#F14D),a
ld a,#3A
ld (#F001),a
ld (#C0FE),a
ld (#C19E),a
ld (#E2DA),a
ld a,#3F
ld (#F053),a
ld a,#40
ld (#C010),a
ld (#C059),a
ld (#D057),a
ld (#E057),a
ld (#F060),a
ld (#C0A0),a
ld (#F0AA),a
ld (#E0F3),a
ld (#F143),a
ld (#D190),a
ld (#C1E0),a
ld (#C1F1),a
ld (#D1E0),a
ld (#D1F3),a
ld (#E23C),a
ld (#E23F),a
ld (#D28A),a
ld (#F281),a
ld (#D2DD),a
ld a,#41
ld (#D0A4),a
ld (#E0F9),a
ld (#C14A),a
ld (#F196),a
ld (#E241),a
ld (#C2D1),a
ld (#E2D6),a
ld (#F2D8),a
ld a,#42
ld (#F010),a
ld (#F0AB),a
ld (#F231),a
ld (#E28B),a
ld (#E2D9),a
ld a,#43
ld (#E053),a
ld (#F1EE),a
ld a,#46
ld (#D009),a
ld a,#47
ld (#C0FC),a
ld a,#48
ld (#F002),a
ld (#F058),a
ld (#C0B0),a
ld (#D0A9),a
ld (#D284),a
ld a,#4A
ld (#C140),a
ld (#F1E3),a
ld (#D235),a
ld a,#50
ld (#E00E),a
ld (#E012),a
ld (#C05E),a
ld (#C05F),a
ld (#D050),a
ld (#F05F),a
ld (#C0A8),a
ld (#D0A7),a
ld (#D0B3),a
ld (#E0FB),a
ld (#F0F1),a
ld (#C14C),a
ld (#C19D),a
ld (#E197),a
ld (#C1EA),a
ld (#E1EE),a
ld (#E1EF),a
ld (#C243),a
ld (#D239),a
ld (#F234),a
ld (#F237),a
ld (#C280),a
ld (#C285),a
ld (#C292),a
ld (#D28C),a
ld (#E280),a
ld (#F280),a
ld (#C2E2),a
ld (#E2D0),a
ld (#E2D4),a
ld (#E2DD),a
ld a,#51
ld (#D0FB),a
ld a,#52
ld (#E141),a
ld (#E1A2),a
ld (#E234),a
ld (#F28C),a
ld (#E2D3),a
ld a,#56
ld (#E0FC),a
ld a,#58
ld (#C063),a
ld (#E0A5),a
ld (#C0F3),a
ld (#D199),a
ld (#C1E5),a
ld (#C1E8),a
ld (#C23F),a
ld (#D23B),a
ld (#E23B),a
ld (#D2D3),a
ld a,#5A
ld (#C0F2),a
ld (#E28F),a
ld a,#62
ld (#E05A),a
ld (#E14C),a
ld (#C1A0),a
ld (#E2D2),a
ld a,#6A
ld (#C052),a
ld (#D1A1),a
ld (#E288),a
ld (#F287),a
ld a,#72
ld (#D005),a
ld (#C0AA),a
ld (#E0AB),a
ld (#C2DD),a
ld a,#7A
ld (#D2DA),a
ld a,#88
ld (#C103),a
ld (#F293),a
ld a,#89
ld (#F282),a
ld (#E2D8),a
ld a,#8A
ld (#C001),a
ld (#D011),a
ld (#D1E1),a
ld (#D1E4),a
ld (#F240),a
ld (#E289),a
ld (#D2D9),a
ld a,#8B
ld (#D102),a
ld a,#8C
ld (#E003),a
ld (#D289),a
ld a,#8E
ld (#E2E1),a
ld a,#98
ld (#C011),a
ld (#C054),a
ld (#E062),a
ld (#F0FD),a
ld (#F14E),a
ld (#F2DB),a
ld a,#9A
ld (#F003),a
ld (#D232),a
ld (#E237),a
ld (#D282),a
ld a,#9C
ld (#F197),a
ld a,#9E
ld (#E238),a
ld a,#AA
ld (#F102),a
ld a,#AE
ld (#E196),a
ld a,#BA
ld (#C0AD),a
ld (#C14F),a
ld (#C287),a
ld a,#BF
ld (#E0F5),a
ld a,#C8
ld (#C00B),a
ld a,#CA
ld (#F0AF),a
ld a,#D8
ld (#E005),a
ld (#E146),a
ld a,#DA
ld (#F142),a
ld (#C236),a
ld (#C286),a
ld (#C2DA),a
ld a,#EA
ld (#C150),a
ld (#D288),a
ld (#C2D0),a
ld a,#EB
ld (#D238),a
ld a,#EE
ld (#F0A4),a
ld a,#EF
ld (#F146),a
ld a,#FA
ld (#F0AE),a
ld (#C197),a
ld (#C1E4),a
ret

p42to43
ld a,#00
ld (#E000),a
ld (#F00C),a
ld (#C053),a
ld (#C0A0),a
ld (#D0FC),a
ld (#D0FD),a
ld (#D100),a
ld (#E102),a
ld (#F0F4),a
ld (#E153),a
ld (#D1F3),a
ld (#C234),a
ld a,#01
ld (#E013),a
ld (#E05C),a
ld (#C0A5),a
ld (#D0AC),a
ld (#C1E1),a
ld (#F238),a
ld (#C2D9),a
ld a,#02
ld (#C009),a
ld (#F004),a
ld (#C061),a
ld (#E061),a
ld (#D101),a
ld (#D151),a
ld (#E190),a
ld (#D1E0),a
ld (#C281),a
ld (#D28F),a
ld a,#03
ld (#C0AB),a
ld (#E0AD),a
ld (#E287),a
ld (#C2D1),a
ld a,#04
ld (#D009),a
ld (#D0AD),a
ld (#D142),a
ld (#E143),a
ld (#E1E1),a
ld (#F241),a
ld (#D280),a
ld (#F2D3),a
ld a,#05
ld (#E009),a
ld (#E194),a
ld (#E1E2),a
ld (#F1E4),a
ld (#E236),a
ld a,#06
ld (#E0FF),a
ld (#C152),a
ld (#F289),a
ld a,#07
ld (#C0FC),a
ld a,#08
ld (#E005),a
ld (#E00A),a
ld (#D05C),a
ld (#F0A2),a
ld (#D191),a
ld (#D193),a
ld (#D1A2),a
ld (#E1E6),a
ld (#F1F0),a
ld (#D23E),a
ld (#E235),a
ld (#C282),a
ld (#F293),a
ld a,#09
ld (#F002),a
ld (#E101),a
ld (#E289),a
ld a,#0A
ld (#E0B2),a
ld (#E0F6),a
ld (#C140),a
ld (#E141),a
ld (#E142),a
ld (#F151),a
ld (#F152),a
ld (#C190),a
ld (#D192),a
ld (#E1A2),a
ld (#F190),a
ld (#F191),a
ld (#E1E0),a
ld a,#0B
ld (#E011),a
ld (#F011),a
ld (#F103),a
ld (#F193),a
ld (#C231),a
ld (#F282),a
ld a,#0C
ld (#D00A),a
ld (#E0F7),a
ld a,#0D
ld (#E193),a
ld a,#0E
ld (#E151),a
ld (#C1E3),a
ld a,#0F
ld (#D150),a
ld (#E152),a
ld a,#10
ld (#D006),a
ld (#F007),a
ld (#C05E),a
ld (#F0A8),a
ld (#C1A3),a
ld (#E19C),a
ld (#D1E8),a
ld (#D234),a
ld (#F237),a
ld (#C289),a
ld (#F283),a
ld (#F286),a
ld (#F28D),a
ld (#C2D7),a
ld (#C2DE),a
ld (#D2DB),a
ld (#E2E3),a
ld (#F2D9),a
ld a,#11
ld (#F1E7),a
ld a,#12
ld (#F050),a
ld (#C0F8),a
ld (#C153),a
ld a,#14
ld (#C00A),a
ld (#C058),a
ld (#E0AE),a
ld a,#18
ld (#D013),a
ld (#D054),a
ld (#D059),a
ld (#E062),a
ld (#D103),a
ld (#D194),a
ld (#E283),a
ld a,#19
ld (#E1E4),a
ld (#E2D8),a
ld a,#1A
ld (#C003),a
ld (#F051),a
ld (#C0A1),a
ld (#F0AD),a
ld (#F101),a
ld (#D1E3),a
ld (#D232),a
ld (#F232),a
ld a,#1C
ld (#F062),a
ld (#D2D8),a
ld (#F2E1),a
ld a,#22
ld (#F00B),a
ld (#D061),a
ld (#F05C),a
ld (#F231),a
ld (#C2E0),a
ld (#D2D2),a
ld (#E2D2),a
ld (#F2E3),a
ld a,#23
ld (#F290),a
ld a,#26
ld (#C2D8),a
ld (#F2D2),a
ld a,#2A
ld (#E00B),a
ld (#D062),a
ld (#F0B1),a
ld (#F0B2),a
ld (#F153),a
ld (#C19E),a
ld (#C1A1),a
ld (#E191),a
ld (#D1E5),a
ld (#D231),a
ld (#C2D2),a
ld a,#2B
ld (#E0F4),a
ld a,#2E
ld (#E2E1),a
ld a,#32
ld (#F2D0),a
ld (#F2DA),a
ld a,#33
ld (#E053),a
ld (#C23E),a
ld a,#3A
ld (#C0B3),a
ld (#C193),a
ld (#D1A1),a
ld (#F1E2),a
ld (#D2E0),a
ld a,#40
ld (#C008),a
ld (#D010),a
ld (#E002),a
ld (#E00C),a
ld (#E010),a
ld (#D056),a
ld (#E050),a
ld (#E056),a
ld (#F05A),a
ld (#E0A2),a
ld (#E0B0),a
ld (#F0AB),a
ld (#E0F9),a
ld (#F0F9),a
ld (#E199),a
ld (#E19B),a
ld (#E1A1),a
ld (#D1F0),a
ld (#D1F2),a
ld (#F1EE),a
ld (#F1F1),a
ld (#C230),a
ld (#C240),a
ld (#D241),a
ld (#E281),a
ld a,#41
ld (#D053),a
ld (#C288),a
ld (#D286),a
ld (#D28A),a
ld (#F281),a
ld a,#42
ld (#C05D),a
ld (#D0B1),a
ld (#F0AA),a
ld (#D190),a
ld (#E288),a
ld a,#43
ld (#D0A4),a
ld (#F0A3),a
ld (#D230),a
ld a,#44
ld (#D0FF),a
ld a,#46
ld (#E0FC),a
ld (#C14D),a
ld a,#48
ld (#C00E),a
ld (#D00E),a
ld (#E05B),a
ld (#F057),a
ld (#F0FA),a
ld (#E14F),a
ld (#F143),a
ld (#D1E7),a
ld (#C23A),a
ld (#E23C),a
ld (#F28E),a
ld a,#49
ld (#C0AE),a
ld a,#4A
ld (#D0F7),a
ld (#C14E),a
ld a,#50
ld (#C013),a
ld (#D000),a
ld (#D004),a
ld (#D00D),a
ld (#E004),a
ld (#C063),a
ld (#D057),a
ld (#E063),a
ld (#F059),a
ld (#F060),a
ld (#C0A3),a
ld (#E0A1),a
ld (#E0A5),a
ld (#D0F9),a
ld (#D144),a
ld (#E198),a
ld (#C1E8),a
ld (#C293),a
ld (#F28F),a
ld (#C2D3),a
ld (#C2DF),a
ld (#C2E3),a
ld (#D2D3),a
ld (#D2E3),a
ld (#E2DB),a
ld (#E2DF),a
ld (#F2D1),a
ld (#F2E2),a
ld a,#51
ld (#C14A),a
ld a,#52
ld (#E006),a
ld (#C0AF),a
ld (#E140),a
ld a,#53
ld (#F23F),a
ld a,#58
ld (#E012),a
ld (#E052),a
ld (#F054),a
ld (#F058),a
ld (#D0B3),a
ld (#E0AF),a
ld (#D0F0),a
ld (#E0F2),a
ld (#C144),a
ld (#E146),a
ld (#C290),a
ld (#D2D6),a
ld a,#5A
ld (#C286),a
ld (#F28A),a
ld a,#5C
ld (#D289),a
ld a,#62
ld (#D05A),a
ld (#E0AB),a
ld (#F14F),a
ld (#E28B),a
ld (#F287),a
ld a,#6A
ld (#C1A0),a
ld (#D237),a
ld a,#6F
ld (#E0A4),a
ld a,#72
ld (#D008),a
ld (#E05A),a
ld (#D14B),a
ld (#E23D),a
ld a,#7A
ld (#F142),a
ld (#C197),a
ld (#D283),a
ld (#C2DA),a
ld a,#88
ld (#C00B),a
ld (#E0A3),a
ld (#F0AF),a
ld (#D233),a
ld a,#8A
ld (#F000),a
ld (#C103),a
ld (#D102),a
ld (#F0F5),a
ld (#C1A2),a
ld (#E192),a
ld (#E1A3),a
ld (#F1E1),a
ld (#C2D0),a
ld a,#8B
ld (#D0B2),a
ld (#C150),a
ld a,#8C
ld (#D281),a
ld (#E291),a
ld a,#8E
ld (#C002),a
ld (#D012),a
ld (#F240),a
ld a,#98
ld (#D003),a
ld (#E003),a
ld (#F003),a
ld (#D153),a
ld (#F197),a
ld (#C23F),a
ld a,#9A
ld (#E238),a
ld a,#9C
ld (#C238),a
ld a,#9E
ld (#E1E7),a
ld a,#AA
ld (#E100),a
ld (#F0FF),a
ld (#C14F),a
ld (#C191),a
ld (#C192),a
ld (#D2D9),a
ld a,#BA
ld (#F001),a
ld (#C0FE),a
ld a,#BB
ld (#F19D),a
ld a,#CA
ld (#D00B),a
ld (#F100),a
ld (#E237),a
ld a,#D8
ld (#D00C),a
ld (#D0A5),a
ld (#D0A9),a
ld (#D199),a
ld (#F19A),a
ld (#C1E5),a
ld (#E1E9),a
ld a,#EA
ld (#F052),a
ld (#D238),a
ld a,#EE
ld (#F146),a
ld a,#EF
ld (#F053),a
ld a,#FA
ld (#C0AD),a
ld (#C236),a
ld a,#FF
ld (#E0F5),a
ld (#F19E),a
ret
finc4

;;;;;;;;;;;;;;;;;;;;;;;;;;; bank c5
bank 5
org #4000
p43to44
ld a,#00
ld (#F009),a
ld (#E061),a
ld (#C0A5),a
ld (#C0FF),a
ld (#E0F0),a
ld (#F0F0),a
ld (#D140),a
ld (#E143),a
ld (#F144),a
ld (#E1A0),a
ld (#F1A1),a
ld (#F1A2),a
ld (#C1E2),a
ld (#E1F1),a
ld (#F1E5),a
ld (#D23E),a
ld (#F239),a
ld (#F242),a
ld (#D287),a
ld (#E282),a
ld (#E2E3),a
ld a,#01
ld (#E0AD),a
ld (#D0FD),a
ld (#E101),a
ld (#C151),a
ld (#D142),a
ld (#E1A1),a
ld (#F193),a
ld (#F195),a
ld (#F1E4),a
ld (#E292),a
ld (#E2E2),a
ld a,#02
ld (#D061),a
ld (#F0B1),a
ld (#F0B3),a
ld (#E0FF),a
ld (#C153),a
ld (#C190),a
ld (#D190),a
ld (#D191),a
ld (#E1A2),a
ld (#C1E1),a
ld (#C1EF),a
ld (#E242),a
ld (#D2D2),a
ld (#F2E3),a
ld a,#03
ld (#D0A4),a
ld (#C23E),a
ld (#D230),a
ld (#D28F),a
ld (#E290),a
ld a,#04
ld (#C00F),a
ld (#E009),a
ld (#D0FF),a
ld (#E0F7),a
ld (#C141),a
ld (#D150),a
ld (#E150),a
ld (#E1E2),a
ld (#E232),a
ld (#F238),a
ld a,#05
ld (#D0AC),a
ld (#C152),a
ld (#D14F),a
ld (#F19B),a
ld (#D23D),a
ld a,#06
ld (#C009),a
ld (#C1E3),a
ld (#E231),a
ld (#F231),a
ld (#D280),a
ld (#E293),a
ld (#C2D8),a
ld (#E2D2),a
ld a,#08
ld (#C00B),a
ld (#C00D),a
ld (#D011),a
ld (#E011),a
ld (#C062),a
ld (#F0AF),a
ld (#E153),a
ld (#F140),a
ld (#C1A3),a
ld (#D194),a
ld (#D1A3),a
ld (#C1F2),a
ld (#D233),a
ld (#D2D8),a
ld a,#09
ld (#E005),a
ld (#E05C),a
ld (#D0B2),a
ld (#E152),a
ld (#E193),a
ld (#E1E4),a
ld a,#0A
ld (#E00B),a
ld (#E062),a
ld (#C101),a
ld (#C103),a
ld (#D102),a
ld (#F101),a
ld (#E151),a
ld (#F150),a
ld (#D193),a
ld (#D1A2),a
ld (#E192),a
ld (#D1E1),a
ld (#C231),a
ld (#E240),a
ld (#C281),a
ld (#F282),a
ld a,#0B
ld (#F0B2),a
ld (#E0F6),a
ld (#F141),a
ld a,#0C
ld (#E190),a
ld (#E1E1),a
ld a,#0E
ld (#D00A),a
ld (#C0B2),a
ld (#C150),a
ld (#E142),a
ld (#F2D2),a
ld a,#10
ld (#E007),a
ld (#F005),a
ld (#E05D),a
ld (#F056),a
ld (#C0A7),a
ld (#D0AE),a
ld (#E0AE),a
ld (#D0FC),a
ld (#C142),a
ld (#D143),a
ld (#C198),a
ld (#F1A3),a
ld (#C232),a
ld (#F23C),a
ld (#E28C),a
ld a,#12
ld (#F007),a
ld (#C050),a
ld (#C1EB),a
ld (#E1E3),a
ld (#E230),a
ld (#F237),a
ld a,#13
ld (#C0FC),a
ld (#F1E7),a
ld a,#14
ld (#F062),a
ld (#F288),a
ld (#F28D),a
ld a,#16
ld (#C05B),a
ld (#F289),a
ld (#F292),a
ld (#F2D9),a
ld a,#18
ld (#F05D),a
ld (#E103),a
ld (#C282),a
ld (#F2DB),a
ld a,#1A
ld (#C00A),a
ld (#C05C),a
ld (#D153),a
ld (#D236),a
ld (#E2E0),a
ld a,#1B
ld (#F002),a
ld a,#1C
ld (#C011),a
ld a,#1E
ld (#F2E1),a
ld a,#22
ld (#F0AD),a
ld (#E140),a
ld (#D231),a
ld (#D2E0),a
ld a,#23
ld (#E053),a
ld (#E287),a
ld (#C2E0),a
ld a,#26
ld (#C14D),a
ld (#C1E7),a
ld a,#2A
ld (#C001),a
ld (#D151),a
ld (#F142),a
ld (#D192),a
ld (#D1A1),a
ld (#C2D1),a
ld a,#2B
ld (#D062),a
ld a,#2E
ld (#C0B3),a
ld a,#2F
ld (#E145),a
ld (#E2E1),a
ld a,#32
ld (#F00A),a
ld (#C19E),a
ld a,#33
ld (#F14D),a
ld (#F290),a
ld a,#3A
ld (#F19C),a
ld (#D1E5),a
ld (#F2D0),a
ld a,#3F
ld (#E0F4),a
ld a,#40
ld (#C000),a
ld (#D002),a
ld (#C051),a
ld (#C05F),a
ld (#E051),a
ld (#C0B0),a
ld (#D0B1),a
ld (#E0AC),a
ld (#F0A2),a
ld (#D101),a
ld (#D144),a
ld (#D1E7),a
ld (#C237),a
ld (#C23D),a
ld (#C243),a
ld (#D23B),a
ld (#E241),a
ld (#C280),a
ld (#C28A),a
ld (#D2D7),a
ld (#F2D6),a
ld a,#41
ld (#E002),a
ld (#C0AE),a
ld (#E144),a
ld (#F23F),a
ld (#E281),a
ld a,#42
ld (#D0F7),a
ld (#D0F8),a
ld (#E14C),a
ld (#D1A0),a
ld (#C1F1),a
ld (#D235),a
ld (#D23C),a
ld (#F287),a
ld a,#43
ld (#C1E0),a
ld (#C28F),a
ld (#F281),a
ld a,#48
ld (#C194),a
ld (#E23B),a
ld (#F291),a
ld (#C2D9),a
ld (#E2D6),a
ld a,#49
ld (#E14F),a
ld (#E2D8),a
ld a,#4A
ld (#C00E),a
ld (#F100),a
ld (#F102),a
ld (#E237),a
ld (#C286),a
ld a,#50
ld (#C005),a
ld (#E050),a
ld (#E054),a
ld (#E060),a
ld (#F054),a
ld (#C0AF),a
ld (#E0A8),a
ld (#E0B0),a
ld (#C0F7),a
ld (#D100),a
ld (#E146),a
ld (#C1E9),a
ld (#F1E8),a
ld (#C233),a
ld (#E234),a
ld (#F233),a
ld (#F23D),a
ld (#C284),a
ld (#C28D),a
ld (#F283),a
ld (#C2D4),a
ld (#C2D5),a
ld a,#51
ld (#C288),a
ld (#F2D8),a
ld a,#52
ld (#D005),a
ld (#D008),a
ld (#F00D),a
ld (#E05A),a
ld (#F05A),a
ld (#E23D),a
ld (#D28B),a
ld (#E28E),a
ld (#C2DD),a
ld a,#53
ld (#F196),a
ld a,#58
ld (#D013),a
ld (#F012),a
ld (#C0A2),a
ld (#C0A8),a
ld (#C0A9),a
ld (#E0B3),a
ld (#D0F1),a
ld (#E0F8),a
ld (#C19F),a
ld (#F19A),a
ld (#F1E3),a
ld (#F1EA),a
ld (#F28A),a
ld (#E2D4),a
ld (#F2DD),a
ld a,#5A
ld (#C0A6),a
ld (#D0F0),a
ld (#F0F2),a
ld (#D1E3),a
ld (#F1E2),a
ld (#D232),a
ld (#D283),a
ld (#D2DA),a
ld a,#62
ld (#F00B),a
ld (#D1E6),a
ld a,#63
ld (#D053),a
ld a,#6A
ld (#F061),a
ld (#C14F),a
ld (#C197),a
ld (#D238),a
ld a,#72
ld (#E006),a
ld (#E28B),a
ld (#F28C),a
ld a,#7A
ld (#C100),a
ld (#E0F1),a
ld (#F14F),a
ld (#C235),a
ld (#D2D4),a
ld a,#88
ld (#D05C),a
ld (#F057),a
ld (#F1F0),a
ld (#D281),a
ld (#E289),a
ld a,#8A
ld (#C002),a
ld (#C140),a
ld (#E141),a
ld (#F192),a
ld (#F19F),a
ld (#E1E0),a
ld a,#8B
ld (#C05A),a
ld a,#8E
ld (#F0A4),a
ld a,#98
ld (#C003),a
ld (#E012),a
ld (#D0B3),a
ld (#F0F5),a
ld (#E1E9),a
ld (#C238),a
ld (#E238),a
ld (#C290),a
ld (#D282),a
ld a,#9A
ld (#F05B),a
ld (#F0FE),a
ld (#D152),a
ld (#F232),a
ld a,#AA
ld (#C0FE),a
ld (#F151),a
ld (#F152),a
ld (#C1A1),a
ld (#E191),a
ld (#C287),a
ld (#D288),a
ld a,#AB
ld (#F19D),a
ld a,#BA
ld (#C193),a
ld (#C236),a
ld a,#C8
ld (#D00B),a
ld (#E05B),a
ld a,#CA
ld (#E100),a
ld (#C14E),a
ld (#F143),a
ld (#F28E),a
ld a,#D8
ld (#C0F3),a
ld (#F197),a
ld a,#DA
ld (#F0AE),a
ld (#C1E5),a
ld a,#EA
ld (#D1E4),a
ld a,#EE
ld (#F053),a
ld (#E0A4),a
ld (#F240),a
ld a,#EF
ld (#E0F5),a
ld (#F1EF),a
ld a,#FA
ld (#F001),a
ld (#F0FF),a
ld (#C1A0),a
ld (#D237),a
ret

p44to45
ld a,#00
ld (#C00D),a
ld (#D009),a
ld (#F004),a
ld (#E059),a
ld (#E0FE),a
ld (#E101),a
ld (#C141),a
ld (#C151),a
ld (#D198),a
ld (#D1A0),a
ld (#C1E1),a
ld (#C1E3),a
ld (#C1F3),a
ld (#C243),a
ld (#E232),a
ld (#E28D),a
ld a,#01
ld (#E061),a
ld (#C152),a
ld (#E142),a
ld (#E143),a
ld (#E144),a
ld (#F1A2),a
ld (#D287),a
ld a,#02
ld (#F062),a
ld (#F0F0),a
ld (#F101),a
ld (#E192),a
ld (#F1A0),a
ld (#F1E0),a
ld (#F1E6),a
ld (#D236),a
ld (#E240),a
ld (#E282),a
ld (#E293),a
ld (#F282),a
ld (#E2E0),a
ld a,#03
ld (#F0A3),a
ld (#C102),a
ld (#D140),a
ld (#C1E0),a
ld (#F1E7),a
ld (#E288),a
ld (#C2E0),a
ld (#E2D9),a
ld a,#04
ld (#C009),a
ld (#E011),a
ld (#D05B),a
ld (#C0B1),a
ld (#C0FD),a
ld (#E102),a
ld (#E153),a
ld (#E194),a
ld (#E1A1),a
ld (#E1F1),a
ld (#D23D),a
ld (#F292),a
ld a,#05
ld (#D142),a
ld (#E1E5),a
ld (#F241),a
ld a,#06
ld (#D0AD),a
ld (#E0B2),a
ld (#E0F7),a
ld (#E150),a
ld (#F194),a
ld (#F1A3),a
ld (#C1E7),a
ld (#C2D2),a
ld a,#08
ld (#E05C),a
ld (#F057),a
ld (#E0AD),a
ld (#F103),a
ld (#C150),a
ld (#E141),a
ld (#E1A0),a
ld (#F1A1),a
ld (#E1E1),a
ld a,#09
ld (#F100),a
ld (#E14F),a
ld (#F193),a
ld (#D284),a
ld a,#0A
ld (#D011),a
ld (#C052),a
ld (#D063),a
ld (#D0AB),a
ld (#D0B2),a
ld (#F102),a
ld (#C14F),a
ld (#D151),a
ld (#D153),a
ld (#F143),a
ld (#C191),a
ld (#C192),a
ld (#C1A2),a
ld (#D190),a
ld (#D194),a
ld (#D1A3),a
ld (#E191),a
ld (#E1A3),a
ld (#D1E0),a
ld (#E1E6),a
ld (#F231),a
ld (#F236),a
ld (#C2D9),a
ld a,#0B
ld (#C05A),a
ld (#F140),a
ld (#D1A1),a
ld (#D1A2),a
ld (#D1F3),a
ld (#D230),a
ld (#E2E2),a
ld a,#0C
ld (#C231),a
ld (#E231),a
ld a,#0E
ld (#D012),a
ld (#C0B3),a
ld (#F142),a
ld a,#0F
ld (#D141),a
ld (#F141),a
ld a,#10
ld (#D05D),a
ld (#D0A8),a
ld (#F0B0),a
ld (#C0FB),a
ld (#D101),a
ld (#E0F0),a
ld (#D242),a
ld (#E233),a
ld (#E239),a
ld (#F243),a
ld (#C282),a
ld (#F28D),a
ld (#E2D5),a
ld a,#12
ld (#E0AE),a
ld (#C14B),a
ld (#D1E3),a
ld (#D1E8),a
ld (#D2D1),a
ld (#F2D9),a
ld a,#13
ld (#F290),a
ld a,#14
ld (#C0A7),a
ld (#C198),a
ld (#F2D3),a
ld a,#15
ld (#E0F6),a
ld a,#16
ld (#D103),a
ld a,#18
ld (#C00B),a
ld (#E003),a
ld (#F003),a
ld (#F0B3),a
ld (#D0F1),a
ld (#E0F2),a
ld (#F0F5),a
ld (#C142),a
ld (#F232),a
ld (#F2E0),a
ld a,#19
ld (#C0AB),a
ld a,#1A
ld (#F000),a
ld (#E0FF),a
ld (#D1E5),a
ld (#D2D2),a
ld a,#1C
ld (#F237),a
ld a,#22
ld (#C0B2),a
ld (#D0A4),a
ld (#C190),a
ld (#F281),a
ld a,#23
ld (#F05C),a
ld (#F196),a
ld a,#26
ld (#E053),a
ld (#C0AC),a
ld (#C19E),a
ld (#F2E1),a
ld a,#27
ld (#C14D),a
ld a,#2A
ld (#E062),a
ld (#C0A1),a
ld (#E140),a
ld (#F190),a
ld (#F191),a
ld (#F19C),a
ld (#D231),a
ld (#D2D9),a
ld a,#2B
ld (#C001),a
ld (#C103),a
ld (#E2E1),a
ld a,#3A
ld (#C00A),a
ld (#C011),a
ld (#F00A),a
ld (#C05B),a
ld (#F05B),a
ld a,#3B
ld (#F002),a
ld a,#40
ld (#F010),a
ld (#C061),a
ld (#C0FA),a
ld (#D0F7),a
ld (#D0F8),a
ld (#D14E),a
ld (#C1EE),a
ld (#D1E2),a
ld (#F1E9),a
ld (#E23B),a
ld (#F23F),a
ld (#D286),a
ld (#D28A),a
ld (#D292),a
ld (#E290),a
ld (#F2D1),a
ld a,#41
ld (#E0A9),a
ld (#D0FB),a
ld (#C23A),a
ld (#D23B),a
ld (#E2D8),a
ld (#F2D8),a
ld a,#42
ld (#C053),a
ld (#D061),a
ld (#F0F2),a
ld (#D195),a
ld (#E19B),a
ld (#D1F2),a
ld (#C230),a
ld (#C28A),a
ld (#C28F),a
ld a,#43
ld (#E002),a
ld (#F0FC),a
ld (#E237),a
ld (#E281),a
ld a,#44
ld (#F238),a
ld a,#47
ld (#E0FC),a
ld a,#48
ld (#F006),a
ld (#C051),a
ld (#C05F),a
ld (#E0AC),a
ld (#E1E4),a
ld (#D233),a
ld (#E2D4),a
ld a,#4A
ld (#E0F1),a
ld (#E100),a
ld a,#50
ld (#C006),a
ld (#C010),a
ld (#D007),a
ld (#D010),a
ld (#C05D),a
ld (#D054),a
ld (#D056),a
ld (#D05E),a
ld (#D060),a
ld (#E052),a
ld (#E05A),a
ld (#F058),a
ld (#E0A2),a
ld (#F0A2),a
ld (#F0AB),a
ld (#E0FA),a
ld (#D1EB),a
ld (#F1E3),a
ld (#E23D),a
ld (#E23F),a
ld (#F242),a
ld (#C28C),a
ld (#E28A),a
ld (#D2DC),a
ld (#D2DD),a
ld a,#52
ld (#C0AF),a
ld (#C0F8),a
ld (#D100),a
ld (#E285),a
ld (#E28B),a
ld (#F28C),a
ld a,#54
ld (#D289),a
ld a,#58
ld (#D00C),a
ld (#F051),a
ld (#F05D),a
ld (#F0FA),a
ld (#E19A),a
ld (#D282),a
ld (#D290),a
ld (#E283),a
ld (#C2E1),a
ld (#D2DA),a
ld a,#59
ld (#C288),a
ld a,#5A
ld (#C0AD),a
ld (#C100),a
ld (#F0F1),a
ld (#F14F),a
ld (#C235),a
ld (#C2DA),a
ld (#D2D4),a
ld a,#62
ld (#F061),a
ld (#D23C),a
ld a,#63
ld (#F00B),a
ld a,#6A
ld (#D1E4),a
ld (#D1E6),a
ld (#F1E1),a
ld a,#72
ld (#D28B),a
ld (#E28E),a
ld a,#7A
ld (#C1E4),a
ld (#D283),a
ld (#E2DA),a
ld a,#88
ld (#C002),a
ld (#C062),a
ld (#C140),a
ld (#F291),a
ld (#C2D0),a
ld a,#89
ld (#F19B),a
ld (#D2D8),a
ld a,#8A
ld (#F0B2),a
ld (#C0FE),a
ld (#C14E),a
ld (#F153),a
ld (#C1A1),a
ld (#D193),a
ld (#F19D),a
ld (#D1E1),a
ld a,#8B
ld (#D062),a
ld (#E1E0),a
ld (#C281),a
ld a,#8C
ld (#E2D2),a
ld a,#8E
ld (#D191),a
ld (#C23F),a
ld (#F2D2),a
ld a,#98
ld (#F012),a
ld (#C0A8),a
ld (#F0A4),a
ld a,#9A
ld (#D05C),a
ld (#F0AC),a
ld (#E14D),a
ld a,#9C
ld (#E012),a
ld (#E1E7),a
ld a,#AA
ld (#D0F0),a
ld (#D152),a
ld (#F192),a
ld (#D281),a
ld a,#BA
ld (#D288),a
ld (#F2D0),a
ld a,#C8
ld (#E00A),a
ld (#F011),a
ld (#E0F8),a
ld (#C194),a
ld (#F2DD),a
ld a,#CA
ld (#E00B),a
ld (#C287),a
ld a,#CE
ld (#F053),a
ld a,#D8
ld (#F05E),a
ld (#C0A2),a
ld (#E0B3),a
ld a,#DA
ld (#D0A5),a
ld (#F0FE),a
ld (#C19F),a
ld (#E28F),a
ld a,#EA
ld (#C0A6),a
ld a,#EE
ld (#E196),a
ld a,#EF
ld (#E145),a
ld a,#FA
ld (#C1E5),a
ld a,#FF
ld (#F1EF),a
ret

p45to46
ld a,#00
ld (#C00F),a
ld (#C0F0),a
ld (#C102),a
ld (#E102),a
ld (#C150),a
ld (#C152),a
ld (#D143),a
ld (#E19C),a
ld (#F195),a
ld (#C1E0),a
ld (#E1E1),a
ld (#E1E2),a
ld (#C23E),a
ld (#E240),a
ld (#E292),a
ld (#F292),a
ld (#F293),a
ld (#E2D9),a
ld (#F2D6),a
ld a,#01
ld (#F004),a
ld (#E14F),a
ld (#E2E3),a
ld a,#02
ld (#D012),a
ld (#E013),a
ld (#C050),a
ld (#C0A5),a
ld (#D0AD),a
ld (#D102),a
ld (#C151),a
ld (#D141),a
ld (#E153),a
ld (#F141),a
ld (#C190),a
ld (#E190),a
ld (#F19C),a
ld (#F1A3),a
ld (#F281),a
ld (#F2D9),a
ld a,#03
ld (#E237),a
ld (#E2E1),a
ld a,#04
ld (#C060),a
ld (#D0AC),a
ld (#F194),a
ld (#F1F2),a
ld (#E236),a
ld (#F282),a
ld (#F289),a
ld (#C2D8),a
ld (#F2D3),a
ld a,#05
ld (#E0F6),a
ld (#E142),a
ld (#E143),a
ld (#E194),a
ld (#E1A1),a
ld a,#06
ld (#D05B),a
ld (#C0B3),a
ld (#D0A4),a
ld (#D150),a
ld (#E1A2),a
ld a,#07
ld (#E288),a
ld a,#08
ld (#C002),a
ld (#E005),a
ld (#E00A),a
ld (#D0A6),a
ld (#E0F2),a
ld (#C14E),a
ld (#E191),a
ld (#E231),a
ld (#E232),a
ld (#E289),a
ld (#C2D0),a
ld (#C2D9),a
ld (#E2D4),a
ld (#E2DC),a
ld a,#09
ld (#D142),a
ld (#C1A3),a
ld (#F1A2),a
ld (#E28D),a
ld a,#0A
ld (#D0B3),a
ld (#F0B2),a
ld (#C0FE),a
ld (#C140),a
ld (#E140),a
ld (#E150),a
ld (#E152),a
ld (#D191),a
ld (#D192),a
ld (#D1A2),a
ld (#E193),a
ld (#C1F2),a
ld (#C1F3),a
ld (#D1E5),a
ld (#F1E1),a
ld (#C2D2),a
ld a,#0B
ld (#E062),a
ld (#E0A3),a
ld (#E1E0),a
ld (#E1E6),a
ld a,#0C
ld (#E0AD),a
ld (#D0F1),a
ld (#F1E6),a
ld a,#0D
ld (#F241),a
ld a,#0E
ld (#E012),a
ld (#D103),a
ld (#F103),a
ld (#C191),a
ld (#D1A1),a
ld (#D230),a
ld (#F288),a
ld a,#0F
ld (#D140),a
ld (#F142),a
ld (#C1A2),a
ld a,#10
ld (#F00E),a
ld (#D058),a
ld (#F050),a
ld (#D0FF),a
ld (#F0F8),a
ld (#C14B),a
ld (#C1EB),a
ld (#D1E3),a
ld (#E1E3),a
ld (#F1F3),a
ld (#C23C),a
ld (#E230),a
ld (#D28C),a
ld (#E286),a
ld (#F2DB),a
ld (#F2E3),a
ld a,#12
ld (#C05C),a
ld (#E0F0),a
ld (#F2DE),a
ld a,#14
ld (#D0A8),a
ld a,#17
ld (#E0FC),a
ld a,#18
ld (#D003),a
ld (#F012),a
ld (#C054),a
ld (#C0A8),a
ld (#D0FC),a
ld (#E238),a
ld a,#19
ld (#D2D8),a
ld a,#1A
ld (#D05C),a
ld (#E0A0),a
ld a,#22
ld (#C011),a
ld (#F00A),a
ld (#D0B2),a
ld (#C19E),a
ld (#C230),a
ld (#E281),a
ld (#E287),a
ld a,#23
ld (#D053),a
ld (#F0A3),a
ld (#F2E1),a
ld a,#26
ld (#C0FD),a
ld (#D280),a
ld a,#27
ld (#F1E7),a
ld a,#2A
ld (#C001),a
ld (#C0AC),a
ld (#D0F0),a
ld (#D152),a
ld (#F152),a
ld (#D1A3),a
ld (#C1EF),a
ld (#D281),a
ld (#D288),a
ld a,#2E
ld (#E0F7),a
ld a,#2F
ld (#F002),a
ld a,#32
ld (#F05B),a
ld (#E0FF),a
ld (#D14B),a
ld (#D1E8),a
ld (#E28E),a
ld a,#33
ld (#C14D),a
ld a,#3A
ld (#D011),a
ld (#E103),a
ld (#C142),a
ld (#F2DA),a
ld a,#3F
ld (#F1EF),a
ld a,#40
ld (#D00E),a
ld (#E000),a
ld (#F00C),a
ld (#C056),a
ld (#D061),a
ld (#C0AE),a
ld (#E0B1),a
ld (#F0A9),a
ld (#F0B1),a
ld (#E0FD),a
ld (#F0F4),a
ld (#F0FC),a
ld (#C143),a
ld (#E14C),a
ld (#C234),a
ld (#C242),a
ld (#F230),a
ld (#F235),a
ld (#F239),a
ld (#F243),a
ld (#C28F),a
ld (#E284),a
ld (#D2E3),a
ld (#E2D1),a
ld (#F2D8),a
ld a,#41
ld (#F0F9),a
ld (#C280),a
ld (#F290),a
ld (#F2D1),a
ld a,#42
ld (#C00E),a
ld (#E0AB),a
ld (#F1E0),a
ld (#C23B),a
ld (#C286),a
ld (#E282),a
ld (#D2E0),a
ld (#E2D8),a
ld a,#43
ld (#D002),a
ld a,#44
ld (#C009),a
ld a,#48
ld (#E100),a
ld (#E19A),a
ld (#D1E2),a
ld (#C237),a
ld (#F28E),a
ld (#D2E1),a
ld (#F2D7),a
ld a,#4A
ld (#F0AA),a
ld (#F0F2),a
ld (#F236),a
ld (#C287),a
ld (#F2DF),a
ld a,#4B
ld (#F00B),a
ld (#C05A),a
ld (#F05C),a
ld a,#50
ld (#C008),a
ld (#D005),a
ld (#F003),a
ld (#E051),a
ld (#E056),a
ld (#E057),a
ld (#F051),a
ld (#F055),a
ld (#F05D),a
ld (#C0A9),a
ld (#D0B1),a
ld (#E0AA),a
ld (#E0AF),a
ld (#F0A8),a
ld (#F0B0),a
ld (#C0F1),a
ld (#C0F8),a
ld (#D100),a
ld (#F0F5),a
ld (#F19A),a
ld (#C1F0),a
ld (#F1EE),a
ld (#C232),a
ld (#C239),a
ld (#E233),a
ld (#F23C),a
ld (#C289),a
ld (#D285),a
ld (#F28B),a
ld (#C2DC),a
ld (#D2D1),a
ld (#D2D6),a
ld a,#52
ld (#E006),a
ld (#C057),a
ld (#C0AA),a
ld (#D0A7),a
ld (#F0F7),a
ld (#D232),a
ld (#D23C),a
ld (#F287),a
ld (#C2DA),a
ld (#D2D4),a
ld a,#58
ld (#F000),a
ld (#F057),a
ld (#C0A2),a
ld (#F0A2),a
ld (#F1E2),a
ld (#F23A),a
ld (#D293),a
ld a,#5A
ld (#E1F3),a
ld (#D283),a
ld a,#63
ld (#E002),a
ld a,#6A
ld (#E19B),a
ld (#C1F1),a
ld (#D1F2),a
ld a,#6E
ld (#E053),a
ld a,#72
ld (#C235),a
ld (#D238),a
ld a,#7A
ld (#D0A5),a
ld (#F0F1),a
ld (#F0FE),a
ld (#D1E4),a
ld a,#7F
ld (#E0F4),a
ld a,#88
ld (#F011),a
ld (#E0A9),a
ld (#E0F8),a
ld (#F19B),a
ld (#E1E9),a
ld (#E2D6),a
ld (#F2D2),a
ld a,#8A
ld (#D062),a
ld (#F102),a
ld (#C141),a
ld (#E141),a
ld (#E151),a
ld (#F151),a
ld (#D190),a
ld (#C281),a
ld a,#8B
ld (#C103),a
ld (#D153),a
ld (#C1A1),a
ld a,#8C
ld (#F291),a
ld a,#8E
ld (#F053),a
ld (#E291),a
ld (#C2D1),a
ld (#E2E2),a
ld a,#98
ld (#E0B3),a
ld (#D14C),a
ld (#E2D2),a
ld a,#9A
ld (#F001),a
ld (#D1E1),a
ld (#D231),a
ld (#D2D2),a
ld a,#9C
ld (#F14E),a
ld (#F237),a
ld a,#9E
ld (#F0FD),a
ld a,#AA
ld (#F150),a
ld (#F153),a
ld (#D193),a
ld a,#AE
ld (#F146),a
ld a,#BA
ld (#C00A),a
ld (#F0AC),a
ld (#C1E5),a
ld a,#C8
ld (#F006),a
ld (#E0AC),a
ld (#E1E4),a
ld (#F1EA),a
ld a,#CA
ld (#C0A6),a
ld (#C19F),a
ld (#C23D),a
ld a,#D8
ld (#D290),a
ld (#C2E1),a
ld (#D2DA),a
ld a,#D9
ld (#C288),a
ld a,#DA
ld (#F0FF),a
ld (#F14F),a
ld (#F192),a
ld a,#DC
ld (#C290),a
ld a,#DE
ld (#E0A4),a
ld (#E196),a
ld a,#EA
ld (#C1A0),a
ld (#D1E6),a
ld a,#EB
ld (#F052),a
ld a,#EE
ld (#E145),a
ld (#C23F),a
ld a,#EF
ld (#F240),a
ld a,#FA
ld (#C236),a
ld (#F2D0),a
ret

p46to47
ld a,#00
ld (#D012),a
ld (#E009),a
ld (#F00E),a
ld (#C056),a
ld (#C0A5),a
ld (#F0A9),a
ld (#D0F1),a
ld (#F101),a
ld (#E14F),a
ld (#E153),a
ld (#E191),a
ld (#F19C),a
ld (#E1F1),a
ld (#E1F2),a
ld (#F1F1),a
ld (#D23D),a
ld (#E230),a
ld (#E236),a
ld (#E242),a
ld (#F243),a
ld (#D28C),a
ld (#D28E),a
ld (#E284),a
ld (#F282),a
ld (#C2D0),a
ld (#C2D8),a
ld (#F2E3),a
ld a,#01
ld (#D009),a
ld (#F142),a
ld (#F194),a
ld (#E1E1),a
ld (#D28F),a
ld (#F292),a
ld a,#02
ld (#E011),a
ld (#C0B2),a
ld (#C0B3),a
ld (#D0AB),a
ld (#E0B2),a
ld (#D143),a
ld (#D150),a
ld (#C230),a
ld (#E28E),a
ld (#D2D9),a
ld a,#03
ld (#E195),a
ld (#E1E6),a
ld (#C280),a
ld (#F2D1),a
ld (#F2E1),a
ld a,#04
ld (#C009),a
ld (#E190),a
ld (#E1A1),a
ld (#C1E7),a
ld (#E1E5),a
ld (#C23C),a
ld a,#05
ld (#D0FD),a
ld (#E152),a
ld (#C1A2),a
ld (#D1A0),a
ld (#C243),a
ld (#E288),a
ld a,#06
ld (#D0AC),a
ld (#C192),a
ld (#C1A3),a
ld (#D236),a
ld (#E281),a
ld (#F281),a
ld (#E2D9),a
ld (#F2D9),a
ld a,#08
ld (#F011),a
ld (#C054),a
ld (#C0B0),a
ld (#C101),a
ld (#E0F8),a
ld (#E0FE),a
ld (#C152),a
ld (#D140),a
ld (#D191),a
ld (#E19C),a
ld (#F19B),a
ld (#D1F3),a
ld (#C231),a
ld (#C23E),a
ld (#D233),a
ld (#D284),a
ld (#E2D6),a
ld (#E2E3),a
ld a,#09
ld (#C0AB),a
ld (#D0A6),a
ld (#E142),a
ld (#C191),a
ld (#E1A0),a
ld (#C1E0),a
ld (#F241),a
ld (#E2D4),a
ld (#E2DC),a
ld a,#0A
ld (#C002),a
ld (#E00A),a
ld (#C0A1),a
ld (#C103),a
ld (#D0F0),a
ld (#E0F0),a
ld (#E0F1),a
ld (#F102),a
ld (#D141),a
ld (#D142),a
ld (#F140),a
ld (#F151),a
ld (#C190),a
ld (#E1A2),a
ld (#F19D),a
ld (#F1A1),a
ld (#F1A2),a
ld (#F1A3),a
ld (#E1F3),a
ld (#C281),a
ld a,#0B
ld (#F062),a
ld (#C14F),a
ld (#C197),a
ld (#E1A3),a
ld a,#0C
ld (#E05C),a
ld (#F100),a
ld (#F143),a
ld a,#0D
ld (#D1A1),a
ld a,#0E
ld (#D0A4),a
ld (#C14E),a
ld (#E291),a
ld a,#0F
ld (#C1A1),a
ld a,#10
ld (#C00B),a
ld (#C058),a
ld (#D051),a
ld (#C0A7),a
ld (#E0A8),a
ld (#C0F1),a
ld (#D0F2),a
ld (#D198),a
ld (#C28B),a
ld (#C2DB),a
ld (#D2D5),a
ld (#F2D4),a
ld (#F2DE),a
ld a,#11
ld (#C0FC),a
ld (#E144),a
ld a,#12
ld (#F005),a
ld (#D058),a
ld (#E192),a
ld (#F286),a
ld (#E2D5),a
ld a,#13
ld (#E0FC),a
ld a,#14
ld (#F0B3),a
ld (#C0FB),a
ld (#F0F8),a
ld (#D289),a
ld (#D2DB),a
ld a,#17
ld (#E237),a
ld a,#18
ld (#C062),a
ld (#F0A4),a
ld (#F0AF),a
ld (#D1E1),a
ld (#E235),a
ld a,#1A
ld (#D00A),a
ld (#E0B3),a
ld (#F0AD),a
ld (#F152),a
ld a,#1E
ld (#F012),a
ld a,#22
ld (#D011),a
ld (#E002),a
ld (#F05B),a
ld (#F0A3),a
ld (#F1E0),a
ld (#D280),a
ld a,#23
ld (#C011),a
ld (#C19E),a
ld a,#26
ld (#D053),a
ld (#F1E7),a
ld a,#2A
ld (#C05B),a
ld (#D0B3),a
ld (#E0F7),a
ld (#E103),a
ld (#F103),a
ld (#E140),a
ld (#F1A0),a
ld (#D1E0),a
ld (#D1F2),a
ld a,#2E
ld (#E012),a
ld (#C0FD),a
ld a,#32
ld (#C1E4),a
ld a,#33
ld (#F1EF),a
ld a,#3A
ld (#C00A),a
ld (#C0AC),a
ld (#F0A1),a
ld (#C193),a
ld (#F191),a
ld (#D237),a
ld a,#3B
ld (#E0A3),a
ld a,#40
ld (#C00D),a
ld (#F009),a
ld (#D050),a
ld (#D057),a
ld (#E052),a
ld (#E061),a
ld (#D0A1),a
ld (#D0FB),a
ld (#C149),a
ld (#D14A),a
ld (#E14E),a
ld (#D19F),a
ld (#D23B),a
ld (#D243),a
ld (#E23C),a
ld (#E240),a
ld (#F290),a
ld (#D2D1),a
ld a,#41
ld (#C007),a
ld (#D14E),a
ld (#F1E4),a
ld (#F230),a
ld (#C2E0),a
ld a,#42
ld (#F061),a
ld (#D1F1),a
ld (#E2D3),a
ld a,#43
ld (#F145),a
ld a,#45
ld (#E0F6),a
ld (#E143),a
ld a,#48
ld (#F0F9),a
ld (#C143),a
ld (#C1E6),a
ld (#E283),a
ld (#F2DD),a
ld a,#49
ld (#F1EA),a
ld (#D2D8),a
ld a,#4A
ld (#C0A6),a
ld (#C0FE),a
ld (#C151),a
ld (#D152),a
ld (#D1E2),a
ld (#E285),a
ld a,#50
ld (#D006),a
ld (#E000),a
ld (#E003),a
ld (#E010),a
ld (#F008),a
ld (#F00C),a
ld (#D05D),a
ld (#D0AF),a
ld (#F0B1),a
ld (#E0F9),a
ld (#F0F4),a
ld (#D144),a
ld (#F199),a
ld (#C1EB),a
ld (#D1F0),a
ld (#D235),a
ld (#E23B),a
ld (#C282),a
ld (#D282),a
ld (#F287),a
ld (#F293),a
ld (#C2DD),a
ld (#C2DE),a
ld a,#52
ld (#F007),a
ld (#C05C),a
ld (#D1E4),a
ld (#D283),a
ld (#E2DD),a
ld a,#54
ld (#F238),a
ld a,#58
ld (#D003),a
ld (#C052),a
ld (#C0A8),a
ld (#D0A9),a
ld (#E0A1),a
ld (#F0AE),a
ld (#C0F3),a
ld (#E100),a
ld (#C1F0),a
ld (#E238),a
ld (#F236),a
ld (#D2DA),a
ld (#D2DC),a
ld (#D2E1),a
ld a,#5A
ld (#F05A),a
ld (#D151),a
ld (#F192),a
ld (#D28D),a
ld (#D293),a
ld (#F2DA),a
ld a,#5B
ld (#C14A),a
ld a,#62
ld (#D002),a
ld (#C053),a
ld (#C057),a
ld (#E19B),a
ld a,#6A
ld (#F0AA),a
ld (#F0F1),a
ld (#F0F7),a
ld (#D193),a
ld (#D195),a
ld (#C236),a
ld a,#72
ld (#D008),a
ld (#F00D),a
ld (#D05A),a
ld (#D0A7),a
ld (#E0FF),a
ld (#D1E8),a
ld (#C23B),a
ld a,#7A
ld (#D238),a
ld a,#7F
ld (#F19E),a
ld (#F240),a
ld a,#88
ld (#E0AC),a
ld (#D199),a
ld (#F237),a
ld a,#8A
ld (#F001),a
ld (#D103),a
ld (#D153),a
ld (#C19F),a
ld (#D194),a
ld (#F190),a
ld (#C1F3),a
ld (#D1E5),a
ld (#F2D0),a
ld a,#8C
ld (#D230),a
ld (#F288),a
ld a,#8E
ld (#F1F0),a
ld (#C2D9),a
ld a,#8F
ld (#E0F5),a
ld a,#98
ld (#F053),a
ld (#E1E7),a
ld (#D290),a
ld (#C2D2),a
ld (#C2E1),a
ld a,#99
ld (#C288),a
ld a,#9C
ld (#E0A4),a
ld a,#9E
ld (#D063),a
ld a,#AA
ld (#C140),a
ld (#C141),a
ld (#C1A0),a
ld (#C1F2),a
ld a,#AE
ld (#F19F),a
ld a,#BA
ld (#C142),a
ld (#F146),a
ld a,#BE
ld (#F0FD),a
ld a,#C8
ld (#E00B),a
ld (#F05E),a
ld (#E19A),a
ld a,#C9
ld (#F00B),a
ld a,#CA
ld (#C05F),a
ld (#F05C),a
ld (#F0F2),a
ld (#C194),a
ld (#C1F1),a
ld (#C237),a
ld (#F2DF),a
ld a,#CB
ld (#F052),a
ld a,#CE
ld (#E053),a
ld (#F291),a
ld a,#D8
ld (#C003),a
ld (#E063),a
ld (#D14C),a
ld (#C238),a
ld a,#DC
ld (#E196),a
ld a,#EA
ld (#F150),a
ld (#C23D),a
ld a,#EE
ld (#F002),a
ld a,#FA
ld (#D0A5),a
ld (#F14F),a
ld (#C1E5),a
ld (#D1E6),a
ld a,#FE
ld (#C290),a
ret

p47to48
ld a,#00
ld (#E005),a
ld (#F004),a
ld (#C060),a
ld (#D050),a
ld (#D0AB),a
ld (#D0AD),a
ld (#D0FB),a
ld (#F1F2),a
ld (#F1F3),a
ld (#F235),a
ld (#D284),a
ld (#D287),a
ld (#E289),a
ld (#F289),a
ld (#F292),a
ld (#E2DC),a
ld (#E2DE),a
ld (#F2D3),a
ld (#F2D4),a
ld (#F2DE),a
ld a,#01
ld (#C0AB),a
ld (#E0B2),a
ld (#D0FE),a
ld (#E0F2),a
ld (#E0F3),a
ld (#D14E),a
ld (#E152),a
ld (#C1A2),a
ld (#F19C),a
ld (#E1E5),a
ld (#E230),a
ld (#C2D8),a
ld (#F2D9),a
ld a,#02
ld (#D0AC),a
ld (#D0B2),a
ld (#F0A3),a
ld (#D140),a
ld (#E1A1),a
ld (#D1F1),a
ld (#E1F3),a
ld (#C242),a
ld (#D288),a
ld (#E282),a
ld (#E287),a
ld (#C2D0),a
ld a,#03
ld (#C011),a
ld (#C190),a
ld (#D2D9),a
ld a,#04
ld (#C056),a
ld (#E059),a
ld (#D0A6),a
ld (#C0F0),a
ld (#E0F6),a
ld (#F100),a
ld (#E153),a
ld (#D1A1),a
ld (#F195),a
ld (#F2D6),a
ld a,#05
ld (#D0F1),a
ld (#E143),a
ld (#F143),a
ld (#C192),a
ld (#C1A3),a
ld (#E191),a
ld a,#06
ld (#F1E0),a
ld a,#08
ld (#F00E),a
ld (#C0B3),a
ld (#C14F),a
ld (#E14F),a
ld (#E151),a
ld (#F142),a
ld (#C191),a
ld (#F193),a
ld (#C1E0),a
ld (#F1E6),a
ld (#C240),a
ld (#E28D),a
ld (#E2D4),a
ld (#F2D2),a
ld a,#09
ld (#C288),a
ld a,#0A
ld (#F00A),a
ld (#D062),a
ld (#E103),a
ld (#F0F1),a
ld (#F0F2),a
ld (#D143),a
ld (#D153),a
ld (#E141),a
ld (#F152),a
ld (#D190),a
ld (#C1F3),a
ld (#D1F2),a
ld (#D1F3),a
ld (#C230),a
ld (#C23E),a
ld (#E2E0),a
ld a,#0B
ld (#D0F0),a
ld (#F0F0),a
ld (#F103),a
ld (#E142),a
ld a,#0C
ld (#E062),a
ld (#C1A1),a
ld (#E190),a
ld (#E1E0),a
ld (#E1E9),a
ld (#C243),a
ld (#F282),a
ld a,#0E
ld (#D053),a
ld (#C281),a
ld (#E281),a
ld a,#0F
ld (#E0F1),a
ld a,#10
ld (#C006),a
ld (#C00F),a
ld (#D000),a
ld (#E00D),a
ld (#D059),a
ld (#D0A8),a
ld (#C150),a
ld (#E192),a
ld (#C1E1),a
ld (#C231),a
ld (#D23E),a
ld (#E243),a
ld (#D289),a
ld (#D2DB),a
ld a,#12
ld (#D05C),a
ld (#C0AF),a
ld (#E0A8),a
ld (#D150),a
ld (#D192),a
ld (#C1E4),a
ld (#F1EB),a
ld (#E293),a
ld a,#14
ld (#E239),a
ld a,#15
ld (#E144),a
ld a,#16
ld (#F0B3),a
ld (#C198),a
ld a,#17
ld (#E1E6),a
ld a,#18
ld (#C054),a
ld (#C0F1),a
ld (#E1E7),a
ld (#E232),a
ld (#E2D2),a
ld a,#19
ld (#C197),a
ld a,#1A
ld (#C062),a
ld (#E0F7),a
ld (#E14D),a
ld (#F191),a
ld a,#1C
ld (#E05C),a
ld a,#22
ld (#D002),a
ld (#E00A),a
ld (#C053),a
ld (#C153),a
ld (#E19B),a
ld (#F231),a
ld (#C280),a
ld a,#23
ld (#F14D),a
ld (#E195),a
ld (#F2D1),a
ld a,#26
ld (#E002),a
ld a,#2A
ld (#D05B),a
ld (#E0B3),a
ld (#F0AC),a
ld (#F0B2),a
ld (#C0FD),a
ld (#F102),a
ld (#D141),a
ld (#C193),a
ld (#D1E5),a
ld (#E291),a
ld a,#2B
ld (#E012),a
ld (#D0B3),a
ld a,#2E
ld (#E140),a
ld (#F1E7),a
ld a,#36
ld (#F012),a
ld (#D14B),a
ld a,#37
ld (#F240),a
ld a,#3A
ld (#D00A),a
ld (#E0A0),a
ld (#E150),a
ld (#D281),a
ld a,#3F
ld (#F19E),a
ld a,#40
ld (#D007),a
ld (#D009),a
ld (#D05F),a
ld (#F059),a
ld (#D0A3),a
ld (#E0A2),a
ld (#E0AB),a
ld (#D102),a
ld (#E101),a
ld (#F1E4),a
ld (#C23A),a
ld (#E233),a
ld (#F285),a
ld (#C2E0),a
ld a,#41
ld (#E00C),a
ld (#E052),a
ld (#C0FC),a
ld (#E2D1),a
ld a,#42
ld (#C002),a
ld (#C0FA),a
ld (#D152),a
ld (#E14C),a
ld (#D243),a
ld (#C287),a
ld (#D2E3),a
ld (#E2E1),a
ld a,#43
ld (#F230),a
ld a,#45
ld (#E288),a
ld a,#48
ld (#C000),a
ld (#D00B),a
ld (#F006),a
ld (#D057),a
ld (#F05E),a
ld (#C0B0),a
ld (#E0A7),a
ld (#E0F8),a
ld (#E193),a
ld (#F1EA),a
ld (#F1EC),a
ld (#C28C),a
ld a,#49
ld (#C007),a
ld (#E19A),a
ld a,#4A
ld (#C055),a
ld (#C057),a
ld (#C05F),a
ld (#F062),a
ld (#F153),a
ld (#F1A0),a
ld (#C1E5),a
ld (#F2D5),a
ld a,#4B
ld (#C14A),a
ld a,#50
ld (#C00E),a
ld (#D003),a
ld (#D00E),a
ld (#E006),a
ld (#E007),a
ld (#F000),a
ld (#C052),a
ld (#C059),a
ld (#C05C),a
ld (#F056),a
ld (#F057),a
ld (#D0A1),a
ld (#D0AE),a
ld (#E0B1),a
ld (#F0A4),a
ld (#D0F7),a
ld (#E100),a
ld (#F0FA),a
ld (#C14B),a
ld (#D151),a
ld (#E19F),a
ld (#C1E2),a
ld (#F1E2),a
ld (#C234),a
ld (#D242),a
ld (#E238),a
ld (#E240),a
ld (#F232),a
ld (#F23F),a
ld (#E28B),a
ld (#E290),a
ld (#F28C),a
ld (#D2D4),a
ld (#F2DC),a
ld a,#52
ld (#F00F),a
ld (#C0F2),a
ld (#E0FF),a
ld (#C23B),a
ld (#E234),a
ld (#D28B),a
ld a,#58
ld (#C003),a
ld (#F063),a
ld (#D0A0),a
ld (#F197),a
ld (#D1E1),a
ld (#E1EA),a
ld (#E28F),a
ld (#F28E),a
ld (#F2D7),a
ld (#F2E0),a
ld a,#5A
ld (#F0A1),a
ld (#C151),a
ld (#C1F0),a
ld (#F23A),a
ld (#F28A),a
ld a,#5C
ld (#C2D9),a
ld a,#62
ld (#C05A),a
ld (#F05B),a
ld a,#6E
ld (#C290),a
ld a,#72
ld (#D28D),a
ld (#E2DD),a
ld a,#7A
ld (#D0A7),a
ld (#D193),a
ld (#F2DA),a
ld a,#7E
ld (#F0FD),a
ld a,#88
ld (#E00B),a
ld (#F05C),a
ld (#C0FE),a
ld (#D103),a
ld (#E19C),a
ld (#C2D1),a
ld a,#8A
ld (#C05B),a
ld (#E0F0),a
ld (#D142),a
ld (#D1A3),a
ld (#F1A1),a
ld (#D230),a
ld a,#8B
ld (#C1A0),a
ld a,#8D
ld (#F241),a
ld a,#8E
ld (#D063),a
ld (#D0A4),a
ld (#F281),a
ld a,#98
ld (#E063),a
ld (#E0A4),a
ld (#D2D2),a
ld (#D2E1),a
ld (#F2E2),a
ld a,#99
ld (#F288),a
ld a,#9A
ld (#C0AC),a
ld (#F0AD),a
ld (#F146),a
ld (#F1E1),a
ld a,#9C
ld (#E196),a
ld (#C2E1),a
ld a,#9E
ld (#E053),a
ld a,#AA
ld (#F141),a
ld (#D194),a
ld (#D1A2),a
ld (#F1A2),a
ld (#F1A3),a
ld (#C1EF),a
ld a,#AE
ld (#F1F0),a
ld a,#AF
ld (#C23F),a
ld a,#BA
ld (#C194),a
ld (#D1E6),a
ld a,#BB
ld (#F052),a
ld a,#C8
ld (#F0F9),a
ld (#C143),a
ld (#D2DC),a
ld a,#CA
ld (#E05B),a
ld (#F0F7),a
ld (#E285),a
ld a,#CE
ld (#F002),a
ld a,#D8
ld (#C0AD),a
ld (#D231),a
ld a,#DE
ld (#F14E),a
ld a,#EA
ld (#D0A5),a
ld (#D195),a
ld (#C1F1),a
ld (#F2DF),a
ld a,#EE
ld (#F291),a
ld a,#FA
ld (#F150),a
ld (#C237),a
ld a,#FF
ld (#E0F4),a
ret

p48to49
ld a,#00
ld (#C000),a
ld (#C00B),a
ld (#D007),a
ld (#C056),a
ld (#E05D),a
ld (#F059),a
ld (#C0AB),a
ld (#C0B1),a
ld (#D0B2),a
ld (#E0AD),a
ld (#C0F0),a
ld (#D0F2),a
ld (#D0FE),a
ld (#F100),a
ld (#C149),a
ld (#E152),a
ld (#C191),a
ld (#C1A1),a
ld (#C1A2),a
ld (#E192),a
ld (#F194),a
ld (#D1F1),a
ld (#E1E1),a
ld (#C23C),a
ld (#E231),a
ld (#E233),a
ld (#E28E),a
ld (#D2D9),a
ld (#E2D4),a
ld (#F2D6),a
ld a,#01
ld (#D0AB),a
ld (#C192),a
ld a,#02
ld (#F0B3),a
ld (#E103),a
ld (#F102),a
ld (#E141),a
ld (#F152),a
ld (#C190),a
ld (#C193),a
ld (#D1A1),a
ld (#E1A0),a
ld (#F1F1),a
ld (#F231),a
ld a,#03
ld (#E011),a
ld (#D0AC),a
ld (#E0FC),a
ld (#C153),a
ld (#F1EF),a
ld (#C2D0),a
ld a,#04
ld (#E062),a
ld (#F144),a
ld (#F1F2),a
ld (#D236),a
ld (#E239),a
ld (#D28F),a
ld (#E288),a
ld a,#05
ld (#F0A9),a
ld (#E0F1),a
ld (#E0F2),a
ld (#D14E),a
ld (#E1F2),a
ld (#F2D3),a
ld (#F2D9),a
ld a,#06
ld (#E0F6),a
ld (#F19D),a
ld (#E1F3),a
ld (#D288),a
ld a,#07
ld (#F1F3),a
ld a,#08
ld (#D012),a
ld (#D0A0),a
ld (#E0A9),a
ld (#F0AF),a
ld (#E0FD),a
ld (#F151),a
ld (#E190),a
ld (#F1E0),a
ld (#C243),a
ld (#E232),a
ld (#E2DE),a
ld (#F2D0),a
ld a,#09
ld (#F00E),a
ld (#D057),a
ld (#E0A7),a
ld (#D0F1),a
ld (#E1A3),a
ld (#F237),a
ld (#D28E),a
ld (#E283),a
ld (#C2D1),a
ld a,#0A
ld (#E013),a
ld (#E0A0),a
ld (#C0F1),a
ld (#D103),a
ld (#E0F0),a
ld (#F103),a
ld (#C140),a
ld (#C141),a
ld (#C152),a
ld (#D141),a
ld (#E142),a
ld (#E14F),a
ld (#F153),a
ld (#D1A2),a
ld (#E1A1),a
ld (#D1E5),a
ld (#D230),a
ld (#D280),a
ld a,#0B
ld (#C1A0),a
ld (#D1F3),a
ld a,#0C
ld (#E0AC),a
ld (#C1E0),a
ld (#C281),a
ld a,#0E
ld (#D063),a
ld a,#0F
ld (#D0F0),a
ld (#F0F0),a
ld (#F0F1),a
ld (#D1F2),a
ld a,#10
ld (#E009),a
ld (#F005),a
ld (#E05C),a
ld (#F05F),a
ld (#D0FC),a
ld (#D150),a
ld (#D191),a
ld (#D1E9),a
ld (#E1E7),a
ld (#E1EB),a
ld (#F1EB),a
ld (#F1ED),a
ld (#F23B),a
ld (#C28D),a
ld (#E284),a
ld (#D2DD),a
ld (#E2D5),a
ld (#E2DF),a
ld (#F2D4),a
ld a,#11
ld (#D0FD),a
ld (#E0F3),a
ld a,#12
ld (#C006),a
ld (#F00F),a
ld (#D056),a
ld (#F050),a
ld (#F0F8),a
ld a,#13
ld (#E052),a
ld a,#14
ld (#F238),a
ld (#C2DB),a
ld a,#15
ld (#E143),a
ld a,#17
ld (#E144),a
ld a,#18
ld (#D013),a
ld (#F011),a
ld (#E0F7),a
ld (#E28F),a
ld a,#1A
ld (#C054),a
ld (#E0A1),a
ld (#D237),a
ld a,#1C
ld (#E063),a
ld (#F282),a
ld a,#1D
ld (#E237),a
ld a,#22
ld (#C002),a
ld (#F012),a
ld (#C103),a
ld (#F196),a
ld (#E230),a
ld (#F230),a
ld (#E291),a
ld a,#23
ld (#E012),a
ld a,#26
ld (#D002),a
ld (#C280),a
ld a,#27
ld (#F2D1),a
ld a,#2A
ld (#D062),a
ld (#F140),a
ld (#F1A3),a
ld (#C23D),a
ld (#C242),a
ld a,#2B
ld (#F001),a
ld (#F052),a
ld a,#2F
ld (#F19E),a
ld (#C290),a
ld a,#32
ld (#E00A),a
ld (#C198),a
ld (#D28D),a
ld a,#33
ld (#C19E),a
ld (#E195),a
ld (#F240),a
ld a,#36
ld (#E19B),a
ld a,#3A
ld (#C062),a
ld a,#40
ld (#C005),a
ld (#D00B),a
ld (#E005),a
ld (#E00C),a
ld (#D052),a
ld (#D055),a
ld (#E057),a
ld (#F061),a
ld (#C0B2),a
ld (#F0A7),a
ld (#C0FF),a
ld (#E0F8),a
ld (#F101),a
ld (#E19F),a
ld (#C1E3),a
ld (#F1EA),a
ld (#F242),a
ld (#C28A),a
ld (#F280),a
ld (#D2E0),a
ld (#E2D3),a
ld (#E2E1),a
ld (#F2D2),a
ld (#F2E1),a
ld a,#41
ld (#F145),a
ld (#D19F),a
ld a,#42
ld (#C011),a
ld (#C0A6),a
ld (#D14A),a
ld (#F193),a
ld (#D292),a
ld (#D2D1),a
ld a,#43
ld (#D011),a
ld a,#48
ld (#D1E2),a
ld (#E28D),a
ld (#D2D8),a
ld a,#49
ld (#F285),a
ld a,#4A
ld (#F010),a
ld (#F0A1),a
ld (#F0AA),a
ld (#F190),a
ld (#C1F0),a
ld (#E285),a
ld (#E2E0),a
ld (#F2DF),a
ld a,#4E
ld (#E002),a
ld a,#50
ld (#F007),a
ld (#C061),a
ld (#D061),a
ld (#C0A5),a
ld (#C0A8),a
ld (#D0A9),a
ld (#D0FF),a
ld (#E101),a
ld (#F0FC),a
ld (#C144),a
ld (#D152),a
ld (#D192),a
ld (#D198),a
ld (#F197),a
ld (#F19B),a
ld (#D1E4),a
ld (#D23A),a
ld (#D23C),a
ld (#E23C),a
ld (#C28F),a
ld (#D28A),a
ld (#E286),a
ld (#F28E),a
ld (#F2DB),a
ld a,#52
ld (#F00D),a
ld (#D05A),a
ld (#D05C),a
ld (#E0A6),a
ld (#F0A8),a
ld (#C235),a
ld (#E287),a
ld (#C2D6),a
ld a,#53
ld (#C14D),a
ld a,#56
ld (#D14B),a
ld a,#58
ld (#E00E),a
ld (#C051),a
ld (#D144),a
ld (#C195),a
ld (#D19A),a
ld (#F192),a
ld (#D231),a
ld (#D2D2),a
ld (#E2D2),a
ld (#E2D6),a
ld a,#5A
ld (#C00A),a
ld (#D00C),a
ld (#F00A),a
ld (#D0A7),a
ld (#E0FF),a
ld (#F0FF),a
ld (#E1EA),a
ld (#E2DA),a
ld a,#5E
ld (#C2E1),a
ld a,#62
ld (#F0AC),a
ld (#C0FA),a
ld (#E2D1),a
ld a,#63
ld (#F14D),a
ld a,#6A
ld (#F0B2),a
ld (#C14A),a
ld (#C1E5),a
ld (#D243),a
ld a,#6E
ld (#F0FD),a
ld (#F291),a
ld a,#72
ld (#E058),a
ld (#F05B),a
ld (#E234),a
ld a,#7A
ld (#E150),a
ld (#F14F),a
ld (#C237),a
ld a,#88
ld (#C007),a
ld (#C0B3),a
ld (#F142),a
ld (#C240),a
ld (#F281),a
ld a,#8A
ld (#C001),a
ld (#C0FD),a
ld (#C14E),a
ld (#D143),a
ld (#E140),a
ld (#D190),a
ld (#F1A2),a
ld (#C1F2),a
ld (#C23E),a
ld a,#8B
ld (#D0B3),a
ld (#C230),a
ld a,#8C
ld (#F05C),a
ld (#D199),a
ld a,#8D
ld (#E0F5),a
ld a,#8E
ld (#F002),a
ld (#D053),a
ld (#F1E7),a
ld a,#8F
ld (#D140),a
ld a,#98
ld (#E053),a
ld (#F063),a
ld (#E196),a
ld (#E281),a
ld a,#9A
ld (#D281),a
ld (#D290),a
ld a,#9B
ld (#F0F7),a
ld a,#AA
ld (#D142),a
ld (#D1A3),a
ld (#F1A1),a
ld a,#AB
ld (#D0A5),a
ld a,#AE
ld (#C1EF),a
ld a,#BA
ld (#D00A),a
ld (#D05B),a
ld a,#BF
ld (#C23F),a
ld a,#C8
ld (#F062),a
ld (#C0FE),a
ld (#F1EC),a
ld (#C28C),a
ld a,#CA
ld (#C055),a
ld (#C05B),a
ld (#C0B0),a
ld (#C143),a
ld (#F2D5),a
ld a,#D8
ld (#C012),a
ld (#E00B),a
ld (#C0F3),a
ld (#E1E4),a
ld a,#DA
ld (#F0A0),a
ld (#F0A2),a
ld (#F0FE),a
ld (#F150),a
ld a,#EA
ld (#E05B),a
ld (#D194),a
ld (#F23A),a
ld a,#EE
ld (#F14E),a
ld (#F1F0),a
ld a,#FA
ld (#C194),a
ld (#D195),a
ld (#F1A0),a
ld a,#FF
ld (#E0A3),a
ret

p49to50
ld a,#00
ld (#C009),a
ld (#F009),a
ld (#D055),a
ld (#E057),a
ld (#F05F),a
ld (#D0A6),a
ld (#F0A7),a
ld (#F0AF),a
ld (#C0F9),a
ld (#E0FE),a
ld (#F0F3),a
ld (#C153),a
ld (#E153),a
ld (#C190),a
ld (#C192),a
ld (#C1A3),a
ld (#E190),a
ld (#F195),a
ld (#D1E9),a
ld (#E1E9),a
ld (#E1EB),a
ld (#F1EB),a
ld (#C28D),a
ld (#F283),a
ld (#D2D7),a
ld (#E2D9),a
ld (#E2DF),a
ld (#E2E1),a
ld a,#01
ld (#C005),a
ld (#F00E),a
ld (#D0FD),a
ld (#F0F1),a
ld (#C149),a
ld (#D14E),a
ld (#F145),a
ld (#D19F),a
ld (#E194),a
ld (#D1F1),a
ld (#E1F1),a
ld a,#02
ld (#D0AC),a
ld (#D0F0),a
ld (#D0F2),a
ld (#D153),a
ld (#F1E6),a
ld (#E243),a
ld (#E291),a
ld a,#03
ld (#E012),a
ld (#F0B3),a
ld (#F0F0),a
ld (#F19E),a
ld a,#04
ld (#F0A9),a
ld (#F151),a
ld (#E191),a
ld (#C1E0),a
ld (#E1F2),a
ld (#E242),a
ld (#F23B),a
ld (#F243),a
ld (#D2D9),a
ld (#D2DD),a
ld (#F2D9),a
ld a,#05
ld (#D288),a
ld a,#06
ld (#E062),a
ld (#E103),a
ld (#C193),a
ld (#E19B),a
ld (#F230),a
ld a,#08
ld (#D057),a
ld (#C0B3),a
ld (#E0A1),a
ld (#E0A7),a
ld (#F103),a
ld (#E140),a
ld (#E1E0),a
ld (#E283),a
ld (#E288),a
ld (#F282),a
ld (#F292),a
ld a,#09
ld (#E0F1),a
ld (#E143),a
ld (#C1A0),a
ld (#F1F3),a
ld (#E237),a
ld (#F285),a
ld (#E2DE),a
ld a,#0A
ld (#D0F1),a
ld (#E1A0),a
ld (#F1A2),a
ld (#F1A3),a
ld (#D1F3),a
ld (#E1F3),a
ld (#F1E0),a
ld (#F1F1),a
ld (#F1F2),a
ld (#C230),a
ld (#F231),a
ld (#E2E3),a
ld a,#0B
ld (#E0B3),a
ld (#F237),a
ld a,#0C
ld (#F05C),a
ld (#D199),a
ld (#C288),a
ld a,#0D
ld (#F0F2),a
ld (#C1F3),a
ld a,#0E
ld (#D0A4),a
ld (#E1A3),a
ld (#D1F2),a
ld (#C280),a
ld (#E2E2),a
ld a,#0F
ld (#C1F2),a
ld a,#10
ld (#D00D),a
ld (#D013),a
ld (#E00F),a
ld (#D05D),a
ld (#D0B0),a
ld (#F0A3),a
ld (#C102),a
ld (#C199),a
ld (#D192),a
ld (#D19B),a
ld (#C1E4),a
ld (#E235),a
ld (#F238),a
ld (#E292),a
ld (#F28B),a
ld (#C2DD),a
ld (#F2D6),a
ld (#F2DE),a
ld a,#11
ld (#F143),a
ld (#C197),a
ld a,#12
ld (#E141),a
ld (#D28D),a
ld (#F2D4),a
ld a,#14
ld (#E009),a
ld a,#18
ld (#E0A9),a
ld (#F147),a
ld (#F1E1),a
ld (#C281),a
ld (#C2D2),a
ld a,#1A
ld (#F011),a
ld (#F050),a
ld a,#1C
ld (#F063),a
ld (#D237),a
ld a,#1E
ld (#E063),a
ld a,#22
ld (#C062),a
ld (#D062),a
ld (#D063),a
ld (#D103),a
ld (#E0F6),a
ld (#E2D1),a
ld a,#23
ld (#F012),a
ld (#C2D0),a
ld a,#27
ld (#F291),a
ld a,#2A
ld (#C0A1),a
ld (#D142),a
ld (#D1A3),a
ld (#E1A1),a
ld (#F190),a
ld (#D230),a
ld (#D243),a
ld a,#2E
ld (#D002),a
ld (#F196),a
ld (#C2E1),a
ld (#F2D1),a
ld a,#32
ld (#C23D),a
ld a,#33
ld (#E052),a
ld (#E144),a
ld a,#37
ld (#E195),a
ld (#C290),a
ld a,#3A
ld (#D00A),a
ld (#C054),a
ld (#C142),a
ld (#D290),a
ld a,#3B
ld (#C23F),a
ld a,#40
ld (#E001),a
ld (#C0A0),a
ld (#D0AD),a
ld (#D0B2),a
ld (#E0A5),a
ld (#C0FC),a
ld (#E102),a
ld (#D191),a
ld (#E19A),a
ld (#D1F0),a
ld (#F1EF),a
ld (#E231),a
ld (#C293),a
ld (#E280),a
ld (#E28D),a
ld (#C2D5),a
ld (#E2DC),a
ld (#F2DD),a
ld (#F2E3),a
ld a,#41
ld (#F280),a
ld a,#42
ld (#D011),a
ld (#D0A3),a
ld (#F14D),a
ld a,#44
ld (#D14B),a
ld (#E239),a
ld (#C2DB),a
ld a,#45
ld (#D1A0),a
ld a,#48
ld (#D012),a
ld (#C05B),a
ld (#C05F),a
ld (#F0F9),a
ld a,#4A
ld (#D00C),a
ld (#F05E),a
ld (#C0B0),a
ld (#F0FF),a
ld (#F2D5),a
ld a,#50
ld (#C003),a
ld (#C00D),a
ld (#C00F),a
ld (#E005),a
ld (#C051),a
ld (#D05F),a
ld (#C0A6),a
ld (#C0A7),a
ld (#F0AE),a
ld (#D0F8),a
ld (#D101),a
ld (#D102),a
ld (#F101),a
ld (#F192),a
ld (#C1E1),a
ld (#D1E1),a
ld (#E1E7),a
ld (#F1E9),a
ld (#D23B),a
ld (#D23D),a
ld (#D23E),a
ld (#D283),a
ld (#E287),a
ld (#E28F),a
ld (#F28D),a
ld (#F290),a
ld (#D2D0),a
ld (#D2D5),a
ld (#D2DA),a
ld (#E2D2),a
ld (#E2D3),a
ld (#E2D6),a
ld (#F2D7),a
ld (#F2D8),a
ld (#F2E0),a
ld a,#51
ld (#C14D),a
ld (#C2D8),a
ld a,#52
ld (#E008),a
ld (#C057),a
ld (#D0A7),a
ld (#F0F6),a
ld (#C148),a
ld (#D193),a
ld (#D242),a
ld (#F284),a
ld (#E2DD),a
ld a,#54
ld (#C2D9),a
ld a,#58
ld (#F00A),a
ld (#F051),a
ld (#F053),a
ld (#C0F3),a
ld (#E0F7),a
ld (#E1E4),a
ld (#D293),a
ld (#D2DE),a
ld a,#5A
ld (#F0AA),a
ld (#C0F2),a
ld (#D19A),a
ld (#D1A2),a
ld (#E193),a
ld (#F191),a
ld (#D238),a
ld (#C2DC),a
ld a,#62
ld (#F0B2),a
ld (#D14A),a
ld (#C236),a
ld (#D2D1),a
ld a,#66
ld (#F0FD),a
ld a,#6A
ld (#F0A0),a
ld (#E14C),a
ld (#E150),a
ld a,#72
ld (#D056),a
ld (#E0A6),a
ld a,#7A
ld (#F0A8),a
ld (#C0FA),a
ld (#C100),a
ld (#D1E8),a
ld (#F23A),a
ld (#F28A),a
ld a,#88
ld (#F00B),a
ld a,#89
ld (#E0F5),a
ld (#F0F7),a
ld (#F288),a
ld a,#8A
ld (#C055),a
ld (#D0B3),a
ld (#F0A2),a
ld (#C0F0),a
ld (#D140),a
ld (#F142),a
ld (#F153),a
ld (#E19C),a
ld (#C1F0),a
ld (#C1F1),a
ld (#C240),a
ld (#C243),a
ld (#E2E0),a
ld a,#8B
ld (#D0A5),a
ld (#D28E),a
ld a,#8C
ld (#F241),a
ld a,#98
ld (#C012),a
ld a,#9A
ld (#E013),a
ld (#C0F1),a
ld (#C0FD),a
ld (#D1E0),a
ld (#D1E6),a
ld (#F1E7),a
ld a,#9C
ld (#F002),a
ld (#F2E2),a
ld a,#9E
ld (#E002),a
ld (#D053),a
ld a,#AA
ld (#F052),a
ld (#E0F0),a
ld (#C143),a
ld (#D143),a
ld a,#AF
ld (#C1EF),a
ld a,#C8
ld (#C007),a
ld a,#CA
ld (#E00E),a
ld (#F150),a
ld (#C242),a
ld (#C28C),a
ld a,#D8
ld (#E0A4),a
ld (#C0FE),a
ld (#D144),a
ld a,#DA
ld (#C0AC),a
ld (#F0A1),a
ld (#D194),a
ld (#D195),a
ld a,#EA
ld (#F010),a
ld (#C194),a
ld (#F1A1),a
ld (#F1EC),a
ld a,#EF
ld (#E0F4),a
ld a,#FA
ld (#F0FE),a
ld (#F141),a
ld (#F14F),a
ld (#E1EA),a
ret

p50to51
ld a,#00
ld (#D00D),a
ld (#E00F),a
ld (#F00E),a
ld (#F00F),a
ld (#C050),a
ld (#E059),a
ld (#C0A0),a
ld (#D0AC),a
ld (#E0A5),a
ld (#C102),a
ld (#D0FD),a
ld (#F0F0),a
ld (#F0F1),a
ld (#C14F),a
ld (#D141),a
ld (#D149),a
ld (#E140),a
ld (#E151),a
ld (#F145),a
ld (#D1E2),a
ld (#D233),a
ld (#D236),a
ld (#E231),a
ld (#E23B),a
ld (#E242),a
ld (#E243),a
ld (#F242),a
ld (#C293),a
ld (#E282),a
ld (#E283),a
ld (#F282),a
ld (#F285),a
ld (#F28B),a
ld (#C2D5),a
ld (#D2DD),a
ld (#E2DE),a
ld (#F2D3),a
ld a,#01
ld (#D0A0),a
ld (#E0A2),a
ld (#D0FB),a
ld (#F143),a
ld a,#02
ld (#D063),a
ld (#E062),a
ld (#E0B3),a
ld (#F0A7),a
ld (#C103),a
ld (#D103),a
ld (#E103),a
ld (#C23D),a
ld (#D242),a
ld (#E293),a
ld a,#03
ld (#F012),a
ld a,#04
ld (#C005),a
ld (#D055),a
ld (#E057),a
ld (#F059),a
ld (#F05F),a
ld (#C0F9),a
ld (#F0F3),a
ld (#C149),a
ld (#D14F),a
ld (#C1A0),a
ld (#D1A0),a
ld (#D1E9),a
ld (#D1F2),a
ld (#E233),a
ld (#E239),a
ld (#F235),a
ld (#C28D),a
ld (#C2DB),a
ld (#E2DF),a
ld a,#05
ld (#D007),a
ld (#F0F2),a
ld (#E19B),a
ld (#E1A3),a
ld (#F19E),a
ld (#C1F3),a
ld (#D1F1),a
ld (#E1F1),a
ld a,#06
ld (#E230),a
ld a,#07
ld (#C141),a
ld a,#08
ld (#F0AF),a
ld (#D140),a
ld (#E1A2),a
ld (#F1ED),a
ld (#E237),a
ld (#D280),a
ld (#F281),a
ld (#C2DD),a
ld a,#09
ld (#E0A1),a
ld (#E0FD),a
ld (#E1EB),a
ld a,#0A
ld (#C053),a
ld (#C0B3),a
ld (#F0A0),a
ld (#F0A2),a
ld (#C101),a
ld (#D0F2),a
ld (#F103),a
ld (#C142),a
ld (#F190),a
ld (#C2D1),a
ld (#E2E0),a
ld a,#0B
ld (#F0B3),a
ld (#E0F1),a
ld (#C1F1),a
ld a,#0C
ld (#D0A5),a
ld (#C1E0),a
ld a,#0D
ld (#F0F7),a
ld (#C1F2),a
ld a,#0E
ld (#D0B3),a
ld (#E0A0),a
ld (#F230),a
ld a,#10
ld (#D005),a
ld (#E007),a
ld (#E009),a
ld (#D0A1),a
ld (#E0A8),a
ld (#F0B0),a
ld (#F147),a
ld (#C193),a
ld (#E1EC),a
ld (#D239),a
ld (#D284),a
ld (#F286),a
ld (#D2DF),a
ld (#E2E1),a
ld (#F2DB),a
ld a,#12
ld (#E1E3),a
ld (#F23C),a
ld a,#13
ld (#E1E6),a
ld a,#14
ld (#D000),a
ld (#D237),a
ld (#C2D9),a
ld a,#17
ld (#E0F3),a
ld a,#18
ld (#E053),a
ld (#D190),a
ld (#D19B),a
ld (#E281),a
ld (#E288),a
ld a,#1A
ld (#F0AD),a
ld (#F0F8),a
ld (#E14F),a
ld (#D1A1),a
ld a,#1C
ld (#F05C),a
ld a,#1E
ld (#F063),a
ld a,#22
ld (#E1F2),a
ld (#F1E6),a
ld (#D2D1),a
ld a,#23
ld (#C062),a
ld (#D0A3),a
ld a,#26
ld (#E2D1),a
ld a,#2A
ld (#E063),a
ld (#D0F0),a
ld (#C194),a
ld (#C198),a
ld (#D1F3),a
ld (#D28E),a
ld (#D290),a
ld a,#2F
ld (#E2E2),a
ld a,#33
ld (#C290),a
ld (#F291),a
ld a,#3A
ld (#F050),a
ld (#E0F6),a
ld (#D142),a
ld (#E1A1),a
ld a,#3B
ld (#F001),a
ld a,#40
ld (#C011),a
ld (#D001),a
ld (#D011),a
ld (#D050),a
ld (#D054),a
ld (#E056),a
ld (#E0B2),a
ld (#C0F8),a
ld (#F102),a
ld (#C14D),a
ld (#C191),a
ld (#F19C),a
ld (#E236),a
ld (#D292),a
ld (#E291),a
ld a,#41
ld (#E001),a
ld (#D052),a
ld (#E280),a
ld (#C2D8),a
ld a,#42
ld (#C004),a
ld (#F05E),a
ld (#E0FC),a
ld (#F0FF),a
ld (#C1A2),a
ld (#C236),a
ld (#F234),a
ld a,#43
ld (#F240),a
ld (#F280),a
ld a,#45
ld (#E0AC),a
ld (#F19D),a
ld a,#48
ld (#C007),a
ld (#E142),a
ld (#D1E5),a
ld (#C286),a
ld (#E285),a
ld (#D2DC),a
ld (#F2D5),a
ld a,#49
ld (#F288),a
ld a,#4A
ld (#D006),a
ld (#C148),a
ld (#C14A),a
ld (#F142),a
ld (#F146),a
ld (#F150),a
ld (#D1A3),a
ld (#C28C),a
ld a,#50
ld (#C00A),a
ld (#D00B),a
ld (#F005),a
ld (#F006),a
ld (#F00D),a
ld (#C057),a
ld (#C058),a
ld (#C05E),a
ld (#C05F),a
ld (#D058),a
ld (#D059),a
ld (#D05A),a
ld (#E061),a
ld (#F053),a
ld (#D0A7),a
ld (#D0B0),a
ld (#E0A9),a
ld (#E0AB),a
ld (#E0F7),a
ld (#E0F8),a
ld (#D150),a
ld (#E199),a
ld (#C1E3),a
ld (#C231),a
ld (#C23A),a
ld (#C23B),a
ld (#D231),a
ld (#D232),a
ld (#D234),a
ld (#F236),a
ld (#C28A),a
ld (#D28B),a
ld (#E28C),a
ld (#F289),a
ld (#C2DA),a
ld (#C2E0),a
ld (#D2D2),a
ld (#E2D5),a
ld (#F2DD),a
ld a,#52
ld (#D008),a
ld (#F05B),a
ld (#F060),a
ld (#F0B2),a
ld (#C100),a
ld (#D1EA),a
ld (#C241),a
ld (#D28D),a
ld (#F2DA),a
ld a,#58
ld (#F013),a
ld (#C063),a
ld (#E050),a
ld (#C0AD),a
ld (#E0A4),a
ld (#F0AA),a
ld (#C0FE),a
ld (#F0F9),a
ld (#C144),a
ld (#E193),a
ld (#F191),a
ld (#C238),a
ld (#F23D),a
ld (#C2D2),a
ld (#E2DA),a
ld (#F2DF),a
ld a,#5A
ld (#D056),a
ld (#E05E),a
ld (#F058),a
ld (#F061),a
ld (#C0A1),a
ld (#E150),a
ld (#F141),a
ld (#E234),a
ld (#E23A),a
ld (#D2DE),a
ld a,#5E
ld (#F2E2),a
ld a,#62
ld (#F0F6),a
ld a,#63
ld (#F237),a
ld a,#6A
ld (#E05B),a
ld (#E0A6),a
ld (#F1EC),a
ld (#F284),a
ld a,#72
ld (#E00A),a
ld (#C05A),a
ld (#C0AA),a
ld a,#73
ld (#C19E),a
ld a,#7A
ld (#D00A),a
ld (#D00C),a
ld (#E008),a
ld (#E058),a
ld (#D14A),a
ld (#E14C),a
ld (#D19A),a
ld (#E1EA),a
ld (#C2D6),a
ld (#C2DC),a
ld a,#88
ld (#D012),a
ld (#C055),a
ld (#E0F5),a
ld (#C14E),a
ld (#F292),a
ld a,#8A
ld (#D0F1),a
ld (#E0F0),a
ld (#F19F),a
ld (#F1F2),a
ld (#F1F3),a
ld a,#8E
ld (#C280),a
ld a,#98
ld (#C001),a
ld (#F002),a
ld (#D195),a
ld (#D1E6),a
ld (#F1E7),a
ld (#C291),a
ld (#D281),a
ld a,#9A
ld (#F0A1),a
ld a,#9C
ld (#C012),a
ld (#D053),a
ld a,#9E
ld (#D002),a
ld (#E013),a
ld (#D2E1),a
ld a,#AA
ld (#C0F0),a
ld (#E19C),a
ld (#F1A1),a
ld (#C23E),a
ld (#C243),a
ld a,#AE
ld (#F196),a
ld a,#BA
ld (#C054),a
ld (#C0F1),a
ld a,#BF
ld (#C1EF),a
ld a,#CE
ld (#F241),a
ld (#F2D1),a
ld a,#D8
ld (#C0AC),a
ld a,#DA
ld (#F011),a
ld (#C0F2),a
ld a,#EA
ld (#D143),a
ld (#C242),a
ld a,#EE
ld (#C240),a
ld a,#FA
ld (#C143),a
ret

p51to52
ld a,#00
ld (#C005),a
ld (#D007),a
ld (#E006),a
ld (#E007),a
ld (#E057),a
ld (#F05F),a
ld (#D0A1),a
ld (#E0A7),a
ld (#F0A9),a
ld (#C149),a
ld (#D140),a
ld (#E141),a
ld (#C193),a
ld (#C199),a
ld (#E191),a
ld (#C1E7),a
ld (#C1F2),a
ld (#E1EB),a
ld (#E232),a
ld (#E292),a
ld (#F281),a
ld (#C2DB),a
ld (#E2DF),a
ld a,#01
ld (#C00B),a
ld (#D0A4),a
ld (#C0F8),a
ld (#C141),a
ld (#E1A3),a
ld (#F19E),a
ld (#C1F3),a
ld (#D1F0),a
ld (#F1E4),a
ld (#C28D),a
ld (#D288),a
ld a,#02
ld (#C142),a
ld (#D1F2),a
ld (#F242),a
ld (#C293),a
ld (#F283),a
ld (#F2D0),a
ld a,#03
ld (#D062),a
ld (#D103),a
ld (#E103),a
ld (#E1E6),a
ld (#D280),a
ld a,#04
ld (#D0A5),a
ld (#E0B3),a
ld (#D199),a
ld (#E1F1),a
ld (#E243),a
ld (#D2D7),a
ld a,#05
ld (#D00D),a
ld (#C197),a
ld (#F28B),a
ld a,#06
ld (#D055),a
ld a,#08
ld (#E00F),a
ld (#E012),a
ld (#F00B),a
ld (#C055),a
ld (#D05D),a
ld (#E056),a
ld (#F0A2),a
ld (#F0F1),a
ld (#C140),a
ld (#F1A2),a
ld (#E23B),a
ld (#F231),a
ld (#D2DF),a
ld a,#09
ld (#F0AF),a
ld (#C1F1),a
ld a,#0A
ld (#D063),a
ld (#C0A0),a
ld (#F0A1),a
ld (#D0F0),a
ld (#E0F0),a
ld (#E0F1),a
ld (#E0F5),a
ld (#F0F0),a
ld (#F146),a
ld (#F153),a
ld (#D243),a
ld a,#0B
ld (#E0A0),a
ld a,#0C
ld (#F0F7),a
ld (#C230),a
ld a,#0D
ld (#D0A0),a
ld (#E0A1),a
ld (#E0F2),a
ld (#D28F),a
ld a,#0E
ld (#E2D1),a
ld a,#10
ld (#E010),a
ld (#C056),a
ld (#C060),a
ld (#E059),a
ld (#C0AB),a
ld (#C0AF),a
ld (#D0A6),a
ld (#C14F),a
ld (#E151),a
ld (#C1A1),a
ld (#C1E0),a
ld (#D237),a
ld (#E23C),a
ld (#C285),a
ld (#D287),a
ld (#F28C),a
ld (#C2DE),a
ld a,#11
ld (#E0A2),a
ld a,#12
ld (#D005),a
ld (#D00E),a
ld (#F060),a
ld (#F0A7),a
ld (#C28E),a
ld a,#13
ld (#C290),a
ld a,#14
ld (#F05C),a
ld (#F235),a
ld a,#15
ld (#E19B),a
ld a,#18
ld (#D0F3),a
ld (#D281),a
ld a,#1A
ld (#F050),a
ld (#D142),a
ld (#F140),a
ld (#D230),a
ld (#E2E3),a
ld a,#1E
ld (#C012),a
ld a,#22
ld (#F063),a
ld (#F1E0),a
ld (#D290),a
ld (#C2D1),a
ld a,#23
ld (#F280),a
ld (#E2E2),a
ld a,#26
ld (#D2D1),a
ld a,#27
ld (#F0FD),a
ld a,#2A
ld (#D0F1),a
ld (#E1A0),a
ld (#F1EC),a
ld (#C23E),a
ld a,#2B
ld (#F001),a
ld (#E063),a
ld a,#2E
ld (#F1F0),a
ld (#C2D0),a
ld (#D2E1),a
ld (#F2E2),a
ld a,#32
ld (#E05E),a
ld (#D2DE),a
ld a,#33
ld (#E195),a
ld (#C2E1),a
ld a,#37
ld (#E0F3),a
ld (#E144),a
ld a,#3A
ld (#C002),a
ld (#C0B3),a
ld (#D19A),a
ld a,#3F
ld (#C1EF),a
ld a,#40
ld (#D004),a
ld (#F012),a
ld (#C052),a
ld (#C05B),a
ld (#E051),a
ld (#F056),a
ld (#F05E),a
ld (#F0A6),a
ld (#C14A),a
ld (#C153),a
ld (#D153),a
ld (#E14B),a
ld (#E152),a
ld (#F14D),a
ld (#D1E2),a
ld (#E1E5),a
ld (#F1E5),a
ld (#C23C),a
ld (#F240),a
ld (#D28C),a
ld (#E282),a
ld (#C2D4),a
ld (#D2D6),a
ld a,#41
ld (#E194),a
ld (#E241),a
ld a,#42
ld (#C062),a
ld (#F0F6),a
ld (#D1A3),a
ld (#F19C),a
ld (#E280),a
ld a,#43
ld (#E011),a
ld a,#44
ld (#D1E9),a
ld (#E239),a
ld a,#45
ld (#F059),a
ld (#D1F1),a
ld a,#48
ld (#E05F),a
ld (#F0B3),a
ld (#F150),a
ld (#F234),a
ld (#C28C),a
ld (#F288),a
ld a,#4A
ld (#F010),a
ld (#E1A1),a
ld (#C1E5),a
ld (#C241),a
ld (#D238),a
ld (#F284),a
ld (#E2D8),a
ld a,#4C
ld (#D14B),a
ld a,#50
ld (#F004),a
ld (#F00A),a
ld (#F05B),a
ld (#C0B2),a
ld (#D0A8),a
ld (#E0A4),a
ld (#E0A8),a
ld (#F0A3),a
ld (#F0AA),a
ld (#F102),a
ld (#C150),a
ld (#C191),a
ld (#D192),a
ld (#D193),a
ld (#D1A2),a
ld (#F191),a
ld (#F1E1),a
ld (#F1EA),a
ld (#D284),a
ld (#E285),a
ld (#E28D),a
ld (#E28E),a
ld (#F286),a
ld (#C2D2),a
ld (#D2DB),a
ld (#E2DD),a
ld (#F2DE),a
ld (#F2DF),a
ld (#F2E1),a
ld a,#51
ld (#E001),a
ld a,#52
ld (#C003),a
ld (#C00C),a
ld (#F057),a
ld (#C0A1),a
ld (#F0FF),a
ld (#C236),a
ld (#F23A),a
ld (#C287),a
ld (#D2E3),a
ld a,#53
ld (#D052),a
ld (#C19E),a
ld a,#58
ld (#C00A),a
ld (#E00B),a
ld (#E053),a
ld (#F05A),a
ld (#C0AC),a
ld (#E0AF),a
ld (#E142),a
ld (#D190),a
ld (#C1E8),a
ld (#D1EB),a
ld (#D2D8),a
ld a,#5A
ld (#D00C),a
ld (#E00E),a
ld (#E050),a
ld (#E058),a
ld (#F0A8),a
ld (#C1A2),a
ld (#D194),a
ld (#E1EA),a
ld a,#62
ld (#E05B),a
ld (#F237),a
ld a,#6A
ld (#C143),a
ld (#D1E8),a
ld a,#7A
ld (#C053),a
ld (#D1EA),a
ld (#E23A),a
ld a,#7F
ld (#E052),a
ld a,#88
ld (#C19F),a
ld (#F1ED),a
ld a,#89
ld (#C280),a
ld a,#8A
ld (#F052),a
ld (#C0F0),a
ld (#D0F2),a
ld (#C14E),a
ld (#F190),a
ld (#F1A1),a
ld (#E1F2),a
ld (#C243),a
ld (#E230),a
ld a,#8C
ld (#D012),a
ld a,#8E
ld (#F196),a
ld (#F2D1),a
ld a,#98
ld (#E002),a
ld (#F013),a
ld (#D053),a
ld (#F0F8),a
ld (#E288),a
ld a,#9A
ld (#D05B),a
ld (#F230),a
ld a,#9C
ld (#D002),a
ld a,#AA
ld (#C054),a
ld (#D1F3),a
ld (#F1F1),a
ld (#F1F2),a
ld (#F1F3),a
ld a,#BA
ld (#E0F6),a
ld a,#BB
ld (#C23F),a
ld a,#C8
ld (#C1E6),a
ld a,#CA
ld (#C004),a
ld (#D006),a
ld (#F058),a
ld (#E0A6),a
ld a,#CB
ld (#C148),a
ld a,#CE
ld (#E013),a
ld a,#D8
ld (#C063),a
ld (#D19B),a
ld (#E196),a
ld (#D1E0),a
ld a,#DA
ld (#F051),a
ld (#F062),a
ld (#F0FE),a
ld a,#EA
ld (#C198),a
ld a,#EE
ld (#E0A3),a
ld (#E0F4),a
ld a,#EF
ld (#F241),a
ld a,#FA
ld (#E008),a
ld (#C0F2),a
ld (#D143),a
ret

p52to53
ld a,#00
ld (#D00E),a
ld (#E010),a
ld (#E012),a
ld (#F056),a
ld (#C0A8),a
ld (#C0A9),a
ld (#D103),a
ld (#C140),a
ld (#C141),a
ld (#C153),a
ld (#D14E),a
ld (#E14B),a
ld (#F143),a
ld (#F151),a
ld (#C1A0),a
ld (#E1A2),a
ld (#E1A3),a
ld (#F1A2),a
ld (#C1F3),a
ld (#E1E0),a
ld (#E1E6),a
ld (#C23D),a
ld (#D239),a
ld (#E233),a
ld (#E23C),a
ld (#F232),a
ld (#F23B),a
ld (#F23C),a
ld (#C284),a
ld (#C28D),a
ld (#D288),a
ld (#F28C),a
ld (#D2E0),a
ld (#F2E3),a
ld a,#01
ld (#D00D),a
ld (#E006),a
ld (#D054),a
ld (#E103),a
ld (#F0F2),a
ld (#D242),a
ld (#E242),a
ld (#F282),a
ld (#C2D4),a
ld a,#02
ld (#E011),a
ld (#C050),a
ld (#D055),a
ld (#F060),a
ld (#D0A1),a
ld (#D142),a
ld (#D149),a
ld (#E143),a
ld (#F1A3),a
ld (#F1E0),a
ld (#F243),a
ld (#E2E0),a
ld a,#03
ld (#E062),a
ld (#E063),a
ld a,#04
ld (#F009),a
ld (#F059),a
ld (#F0B0),a
ld (#F100),a
ld (#C142),a
ld (#C197),a
ld (#F19E),a
ld (#C1E7),a
ld (#E1E2),a
ld (#E239),a
ld (#E293),a
ld a,#05
ld (#E0A1),a
ld (#C0F9),a
ld (#D0FB),a
ld (#C1F1),a
ld (#D1F1),a
ld (#E243),a
ld a,#06
ld (#E0B3),a
ld a,#08
ld (#F0B3),a
ld (#F234),a
ld (#D2D6),a
ld (#F2DB),a
ld a,#09
ld (#E0F2),a
ld (#F1E4),a
ld (#C280),a
ld a,#0A
ld (#E050),a
ld (#C0F0),a
ld (#C0F1),a
ld (#F0F1),a
ld (#C194),a
ld (#F1A1),a
ld (#E1F1),a
ld (#E1F2),a
ld (#F1EC),a
ld (#F1F3),a
ld (#C241),a
ld (#C243),a
ld (#F242),a
ld (#C293),a
ld (#C2DD),a
ld a,#0B
ld (#D0A0),a
ld a,#0E
ld (#F0A1),a
ld a,#0F
ld (#E0A0),a
ld (#F0A0),a
ld (#D243),a
ld a,#10
ld (#C00E),a
ld (#D000),a
ld (#E007),a
ld (#D05E),a
ld (#E060),a
ld (#C0AC),a
ld (#D0AE),a
ld (#C0FB),a
ld (#D0F9),a
ld (#C190),a
ld (#E192),a
ld (#C1E9),a
ld (#F1EB),a
ld (#F1EE),a
ld (#F235),a
ld (#E28C),a
ld (#C2D9),a
ld (#E2D7),a
ld (#F2D4),a
ld a,#11
ld (#E19B),a
ld a,#12
ld (#E0A5),a
ld (#F0AD),a
ld (#C285),a
ld (#F283),a
ld (#D2DE),a
ld a,#14
ld (#E1EC),a
ld (#D2D7),a
ld (#F2D9),a
ld a,#15
ld (#E0A2),a
ld a,#16
ld (#C28E),a
ld a,#18
ld (#E002),a
ld (#D053),a
ld (#E14F),a
ld (#D1E6),a
ld a,#1A
ld (#C002),a
ld (#E0F0),a
ld (#E1A0),a
ld a,#1C
ld (#C288),a
ld a,#1D
ld (#F19D),a
ld a,#1E
ld (#D2D1),a
ld a,#22
ld (#D0B3),a
ld (#F1F0),a
ld (#E280),a
ld (#D2E1),a
ld a,#23
ld (#D052),a
ld (#F2D0),a
ld (#F2E2),a
ld a,#26
ld (#F0F7),a
ld (#F280),a
ld (#C2D1),a
ld a,#2A
ld (#C0B3),a
ld (#F103),a
ld (#C143),a
ld (#D1F2),a
ld a,#2E
ld (#C012),a
ld (#E013),a
ld a,#32
ld (#C00C),a
ld (#F0A7),a
ld (#F1E6),a
ld a,#33
ld (#E001),a
ld (#F0FD),a
ld (#E144),a
ld a,#3A
ld (#D0F1),a
ld (#E19C),a
ld (#C23E),a
ld a,#40
ld (#C009),a
ld (#F008),a
ld (#F00E),a
ld (#D057),a
ld (#C0B0),a
ld (#E0A4),a
ld (#C0F7),a
ld (#C103),a
ld (#D0F8),a
ld (#D0FD),a
ld (#E0FE),a
ld (#D148),a
ld (#F150),a
ld (#C192),a
ld (#E194),a
ld (#F19C),a
ld (#D1E5),a
ld (#C234),a
ld (#D233),a
ld (#C28C),a
ld (#E28B),a
ld (#F281),a
ld (#F288),a
ld (#F293),a
ld (#D2DC),a
ld (#E2D0),a
ld (#E2DE),a
ld (#F2D8),a
ld a,#41
ld (#D001),a
ld a,#42
ld (#D062),a
ld (#D28E),a
ld a,#43
ld (#F0AC),a
ld (#C19E),a
ld (#F291),a
ld a,#44
ld (#D2D9),a
ld a,#48
ld (#C001),a
ld (#C1A3),a
ld a,#4A
ld (#D006),a
ld (#C152),a
ld a,#4B
ld (#F0F6),a
ld a,#4D
ld (#D14B),a
ld a,#50
ld (#C006),a
ld (#C007),a
ld (#C011),a
ld (#D008),a
ld (#D009),a
ld (#D013),a
ld (#E00C),a
ld (#C056),a
ld (#C060),a
ld (#E053),a
ld (#E05C),a
ld (#C0AE),a
ld (#C0AF),a
ld (#D0B2),a
ld (#E0AD),a
ld (#C0FC),a
ld (#C0FE),a
ld (#E102),a
ld (#F0F9),a
ld (#F0FF),a
ld (#C14A),a
ld (#E151),a
ld (#E152),a
ld (#C1A1),a
ld (#D1A3),a
ld (#D1E3),a
ld (#F1E5),a
ld (#F1EF),a
ld (#C236),a
ld (#E235),a
ld (#F239),a
ld (#C287),a
ld (#D28C),a
ld (#D28D),a
ld (#D293),a
ld (#E284),a
ld (#E2D4),a
ld (#E2DC),a
ld (#F2D5),a
ld (#F2D6),a
ld a,#52
ld (#D00C),a
ld (#C05C),a
ld (#E055),a
ld (#E058),a
ld (#D0FA),a
ld (#C151),a
ld (#E1EA),a
ld (#F1E3),a
ld (#E234),a
ld (#F233),a
ld (#D2D5),a
ld a,#58
ld (#D00F),a
ld (#F002),a
ld (#F011),a
ld (#F0F8),a
ld (#D14C),a
ld (#F141),a
ld (#D1A1),a
ld (#E19D),a
ld (#D1E0),a
ld (#E237),a
ld (#C28F),a
ld (#D281),a
ld (#E281),a
ld (#E288),a
ld (#C2E2),a
ld a,#5A
ld (#F010),a
ld (#C0A1),a
ld (#F0B1),a
ld (#F0B2),a
ld (#C0FD),a
ld (#F0FE),a
ld (#E142),a
ld (#F23D),a
ld (#E28A),a
ld (#F284),a
ld (#F28D),a
ld (#C2D6),a
ld (#C2DC),a
ld a,#62
ld (#D280),a
ld a,#6A
ld (#D238),a
ld a,#72
ld (#D00A),a
ld (#E14C),a
ld (#F28A),a
ld a,#7A
ld (#C003),a
ld (#F057),a
ld (#C0AA),a
ld a,#88
ld (#C004),a
ld (#F052),a
ld (#F230),a
ld (#F231),a
ld a,#8A
ld (#E0A6),a
ld (#C242),a
ld (#D28F),a
ld (#C2D0),a
ld (#D2DF),a
ld a,#8B
ld (#C148),a
ld (#C1F0),a
ld a,#98
ld (#D002),a
ld (#C063),a
ld (#D05B),a
ld (#E14D),a
ld (#E230),a
ld (#F2D1),a
ld a,#9A
ld (#F051),a
ld (#F190),a
ld (#D230),a
ld a,#9C
ld (#F013),a
ld a,#9E
ld (#D012),a
ld (#E145),a
ld (#C291),a
ld (#E2D1),a
ld a,#AA
ld (#D0F2),a
ld (#F0F0),a
ld a,#AE
ld (#F14E),a
ld a,#BA
ld (#F050),a
ld a,#C8
ld (#D0F3),a
ld (#C286),a
ld a,#CA
ld (#C00D),a
ld (#E05F),a
ld (#E2D8),a
ld a,#CB
ld (#C23F),a
ld a,#CE
ld (#F292),a
ld a,#D8
ld (#C0A2),a
ld (#D195),a
ld (#F1E7),a
ld a,#DA
ld (#C054),a
ld (#E0F6),a
ld (#C1E8),a
ld (#D1EB),a
ld a,#EA
ld (#F1F2),a
ld a,#EB
ld (#C198),a
ld a,#EF
ld (#E052),a
ld (#C240),a
ld a,#FA
ld (#F061),a
ld (#F1F1),a
ld (#E23A),a
ret

p53to1
ld a,#00
ld (#C00E),a
ld (#D004),a
ld (#D00D),a
ld (#E00F),a
ld (#F006),a
ld (#D050),a
ld (#E056),a
ld (#E060),a
ld (#F060),a
ld (#D0A5),a
ld (#F0A6),a
ld (#F0AF),a
ld (#F0B0),a
ld (#C0F8),a
ld (#D0F0),a
ld (#D0F8),a
ld (#D0F9),a
ld (#E103),a
ld (#D199),a
ld (#C1E9),a
ld (#C1EA),a
ld (#F1E4),a
ld (#C234),a
ld (#E28C),a
ld (#F282),a
ld (#F293),a
ld (#C2DD),a
ld (#C2DE),a
ld (#E2D6),a
ld (#E2E0),a
ld a,#01
ld (#F0A0),a
ld (#E140),a
ld (#E14B),a
ld (#E1E1),a
ld (#D286),a
ld a,#02
ld (#C0B3),a
ld (#C143),a
ld (#C197),a
ld (#F1F0),a
ld a,#03
ld (#F063),a
ld (#E195),a
ld (#E19B),a
ld a,#04
ld (#E010),a
ld (#D05E),a
ld (#C0A9),a
ld (#E0AC),a
ld (#C0F9),a
ld (#F151),a
ld (#C199),a
ld (#C1F1),a
ld (#D1F1),a
ld (#D239),a
ld (#C28E),a
ld (#D2D9),a
ld a,#05
ld (#D054),a
ld (#D0A4),a
ld (#D242),a
ld (#E242),a
ld a,#06
ld (#E243),a
ld a,#08
ld (#C004),a
ld (#D053),a
ld (#E050),a
ld (#E0FD),a
ld (#F19F),a
ld (#F1A1),a
ld (#D243),a
ld (#F230),a
ld (#F231),a
ld (#E28B),a
ld a,#09
ld (#D05D),a
ld a,#0A
ld (#D055),a
ld (#D0A0),a
ld (#D0A1),a
ld (#E0A6),a
ld (#E0F2),a
ld (#C14E),a
ld (#F1A3),a
ld (#C242),a
ld (#F243),a
ld (#C280),a
ld a,#0C
ld (#F0A2),a
ld (#E1EC),a
ld a,#0D
ld (#F0A1),a
ld (#C148),a
ld a,#0E
ld (#D012),a
ld a,#0F
ld (#C243),a
ld a,#10
ld (#F00F),a
ld (#F05C),a
ld (#C0B1),a
ld (#E0A7),a
ld (#E0AE),a
ld (#E0B0),a
ld (#F0A9),a
ld (#C102),a
ld (#E0F0),a
ld (#F101),a
ld (#C153),a
ld (#F194),a
ld (#C2D5),a
ld (#D2D4),a
ld (#F2D9),a
ld (#F2DC),a
ld a,#11
ld (#D1F0),a
ld a,#12
ld (#C05C),a
ld (#F1E6),a
ld (#E2D7),a
ld a,#13
ld (#F0F6),a
ld (#F0FD),a
ld a,#14
ld (#D14F),a
ld a,#17
ld (#E0A2),a
ld a,#18
ld (#C0AB),a
ld (#E230),a
ld (#D291),a
ld (#F2E3),a
ld a,#1A
ld (#D005),a
ld (#F0A7),a
ld (#D0F1),a
ld (#D19A),a
ld (#F190),a
ld (#F283),a
ld (#F28D),a
ld a,#1C
ld (#C230),a
ld a,#1D
ld (#D0FB),a
ld a,#1E
ld (#F013),a
ld a,#22
ld (#C012),a
ld (#C23E),a
ld (#D280),a
ld a,#23
ld (#E001),a
ld (#D2E1),a
ld a,#2A
ld (#E0F5),a
ld (#E1F1),a
ld (#D290),a
ld a,#2E
ld (#F280),a
ld a,#2F
ld (#E013),a
ld (#F241),a
ld a,#32
ld (#E0A5),a
ld (#E14C),a
ld a,#33
ld (#F2D0),a
ld (#F2E2),a
ld a,#36
ld (#E19C),a
ld a,#37
ld (#C1EF),a
ld a,#3A
ld (#D14A),a
ld (#F23D),a
ld a,#3F
ld (#E0F3),a
ld a,#40
ld (#C001),a
ld (#E005),a
ld (#C062),a
ld (#D062),a
ld (#F05B),a
ld (#C0A7),a
ld (#D0A2),a
ld (#C101),a
ld (#D103),a
ld (#E1E0),a
ld (#E241),a
ld (#C283),a
ld (#D28E),a
ld (#F291),a
ld (#C2D8),a
ld (#D2D0),a
ld (#E2D5),a
ld (#E2D9),a
ld a,#41
ld (#F0AC),a
ld (#C19E),a
ld (#D241),a
ld (#C290),a
ld a,#42
ld (#E055),a
ld (#E143),a
ld (#F142),a
ld (#F1EC),a
ld (#F281),a
ld (#C2D3),a
ld (#E2E2),a
ld a,#43
ld (#C2E1),a
ld a,#48
ld (#D006),a
ld (#C1E6),a
ld a,#4A
ld (#E05F),a
ld (#F058),a
ld (#C194),a
ld (#F193),a
ld (#E1F2),a
ld (#F1E3),a
ld (#D293),a
ld a,#50
ld (#D011),a
ld (#F002),a
ld (#F00E),a
ld (#C055),a
ld (#D056),a
ld (#D057),a
ld (#D05C),a
ld (#E058),a
ld (#F05A),a
ld (#F05E),a
ld (#C0B0),a
ld (#D0A6),a
ld (#F0AD),a
ld (#C100),a
ld (#F0F8),a
ld (#C14D),a
ld (#D140),a
ld (#D141),a
ld (#D14C),a
ld (#E142),a
ld (#F141),a
ld (#F152),a
ld (#C190),a
ld (#C192),a
ld (#D190),a
ld (#D191),a
ld (#E19A),a
ld (#F19C),a
ld (#D1E6),a
ld (#D1E7),a
ld (#E1E4),a
ld (#E1E9),a
ld (#E1EA),a
ld (#F1EB),a
ld (#C23C),a
ld (#D233),a
ld (#E234),a
ld (#F238),a
ld (#F23A),a
ld (#C281),a
ld (#C28B),a
ld (#C28C),a
ld (#D281),a
ld (#E281),a
ld (#E291),a
ld (#D2DC),a
ld (#E2DE),a
ld (#F2D4),a
ld a,#52
ld (#D05F),a
ld (#E05E),a
ld (#E0FF),a
ld (#C147),a
ld (#C1A2),a
ld (#D23A),a
ld (#C292),a
ld (#E287),a
ld (#C2DC),a
ld a,#53
ld (#D001),a
ld a,#58
ld (#E002),a
ld (#F000),a
ld (#C051),a
ld (#C05D),a
ld (#E14F),a
ld (#E150),a
ld (#C1A3),a
ld (#D195),a
ld (#E196),a
ld (#C1E5),a
ld (#D23C),a
ld a,#5A
ld (#D00F),a
ld (#F007),a
ld (#C05A),a
ld (#F057),a
ld (#F062),a
ld (#E0F1),a
ld (#F14F),a
ld (#D1F3),a
ld (#D23B),a
ld (#E2DA),a
ld a,#72
ld (#C00C),a
ld (#C235),a
ld a,#7A
ld (#F061),a
ld (#C0F2),a
ld (#C0FD),a
ld (#D0FA),a
ld (#D194),a
ld (#E23A),a
ld (#F233),a
ld (#E28A),a
ld (#D2D5),a
ld a,#88
ld (#D063),a
ld (#F0B3),a
ld a,#8A
ld (#F051),a
ld (#F1ED),a
ld (#F1F2),a
ld (#C241),a
ld a,#8B
ld (#E0A0),a
ld (#F146),a
ld a,#8C
ld (#F196),a
ld (#C1F0),a
ld a,#8D
ld (#D14B),a
ld a,#98
ld (#F052),a
ld (#D230),a
ld (#C2E2),a
ld (#E2D1),a
ld a,#99
ld (#F19D),a
ld a,#9A
ld (#E14D),a
ld (#E1A0),a
ld (#D1F2),a
ld a,#9C
ld (#C063),a
ld a,#9E
ld (#D2D1),a
ld a,#AA
ld (#F14E),a
ld (#C293),a
ld a,#AB
ld (#C198),a
ld a,#AE
ld (#F001),a
ld (#E0F4),a
ld a,#AF
ld (#D0A3),a
ld a,#BA
ld (#C0A0),a
ld (#F0F0),a
ld a,#CA
ld (#F008),a
ld (#F0F1),a
ld (#E1A1),a
ld (#C1E8),a
ld a,#CE
ld (#E0A3),a
ld a,#D8
ld (#C0F3),a
ld (#E0F6),a
ld (#C195),a
ld a,#DA
ld (#E008),a
ld (#C0A1),a
ld (#E0AF),a
ld (#F0FE),a
ld a,#EA
ld (#C003),a
ld (#D0F2),a
ld (#F1A0),a
ld (#D1EA),a
ld (#D2DF),a
ld a,#EE
ld (#E052),a
ld (#C291),a
ld a,#FA
ld (#D1EB),a
ld a,#FF
ld (#C240),a
ret
finc5

BANKSET 0
org #c000
db #00, #40, #1a, #ea, #08, #00, #50, #50
db #50, #40, #58, #01, #72, #ca, #00, #50
db #50, #50, #22, #50, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #02, #58, #40, #7a, #da, #50, #50, #50
db #50, #50, #5a, #40, #12, #58, #50, #50
db #50, #50, #40, #9c, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ba, #da, #d8, #50, #50, #50, #50, #40
db #00, #04, #7a, #18, #10, #58, #50, #50
db #50, #10, #50, #02, #f0, #f0, #f0, #f0
db #f0, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #ff, #f0, #f0, #f3, #ff, #f8, #f3, #ff
db #ff, #ff, #ff, #fc, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #ff, #ff, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #0a, #0a, #7a, #d8, #50, #50, #50, #40
db #00, #04, #7a, #10, #50, #7a, #50, #40
db #50, #40, #10, #40, #f0, #f0, #f0, #f1
db #ff, #fe, #f0, #f0, #f0, #f1, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #ff, #f8, #f0
db #f0, #f0, #f3, #ff, #fe, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f1, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #04, #02, #58, #50, #50, #52
db #0d, #00, #50, #50, #50, #50, #0a, #10
db #50, #52, #4a, #10, #f0, #f0, #f0, #f1
db #ff, #fe, #f0, #f0, #f0, #f1, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #50, #50, #50, #00, #4a, #d8, #50, #02
db #ab, #04, #50, #50, #50, #50, #41, #88
db #00, #50, #52, #58, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #fc, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f3
db #ff, #ff, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #10, #50, #50, #50, #10, #58, #48, #04
db #ca, #00, #00, #50, #50, #50, #40, #37
db #8c, #04, #00, #00, #f0, #f0, #f0, #f3
db #ff, #fc, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #ff, #f8, #f0
db #f0, #f0, #f7, #ff, #fe, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f1, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #1c, #50, #50, #50, #00, #72, #50, #7a
db #58, #50, #50, #50, #50, #00, #22, #cb
db #ff, #8a, #0a, #0f, #f0, #f0, #f0, #f1
db #ff, #ff, #f0, #f0, #f0, #f3, #ff, #ff
db #fe, #f0, #f0, #f3, #ff, #fc, #f7, #ff
db #ff, #ff, #ff, #f8, #f0, #f0, #f0, #f0
db #f7, #ff, #ff, #ff, #ff, #fc, #f7, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #0a, #50, #50, #40, #00, #12, #c8, #50
db #1c, #50, #50, #50, #50, #00, #04, #58
db #41, #ee, #52, #aa, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #8a, #26, #50, #42, #01, #10, #5a, #10
db #40, #10, #50, #00, #52, #00, #00, #50
db #50, #43, #98, #50, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f1, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #ff, #f0, #f0, #f3, #ff, #f8, #f7, #ff
db #ff, #ff, #ff, #fe, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #f8
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #ff, #f0, #f0
db #f0, #f0, #f3, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #fe, #f0, #f0, #f0, #f1, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f0, #f1, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f3
db #ff, #fe, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f3
db #ff, #ff, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #ff, #fc, #f0
db #f0, #f0, #f7, #ff, #fe, #f0, #f0, #f7
db #ff, #fc, #f0, #f0, #f0, #f3, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f3
db #ff, #fe, #f0, #f0, #f0, #f0, #f7, #ff
db #fe, #f0, #f0, #f3, #ff, #fc, #f1, #ff
db #ff, #ff, #ff, #f0, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #f0, #f7, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f0, #f0, #f0, #f1, #ff
db #fe, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #ff, #ff, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #10, #53, #98, #50, #00, #1a, #48, #00
db #50, #50, #72, #50, #52, #00, #00, #5a
db #50, #50, #0e, #50, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #10, #23, #08, #05, #0a, #50, #50
db #50, #50, #50, #98, #50, #09, #04, #52
db #50, #50, #40, #88, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #0a, #0a, #40, #af, #05, #00, #50, #50
db #50, #50, #50, #01, #00, #40, #10, #50
db #50, #50, #50, #22, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #ff, #f0, #f0, #f3, #ff, #f9, #ff, #ff
db #ff, #ff, #ff, #ff, #f0, #f0, #f0, #f1
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #f8
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #1a, #ea, #c8, #50, #50, #50, #50
db #00, #00, #7a, #1d, #10, #40, #00, #50
db #50, #50, #50, #40, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fe, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #50, #50, #02, #fa, #d8, #50, #50, #50
db #40, #02, #3a, #8d, #50, #50, #00, #14
db #50, #50, #50, #40, #f0, #f0, #f0, #f0
db #ff, #ff, #f0, #f0, #f0, #f3, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f0, #f7, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #50, #50, #50, #50, #7a, #58, #50, #50
db #50, #00, #1a, #d8, #50, #50, #50, #01
db #04, #58, #50, #50, #f0, #f0, #f0, #f1
db #ff, #fc, #ff, #ff, #ff, #fe, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f8, #f0, #f3
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #58, #50, #40, #50, #50, #40, #50, #50
db #6a, #44, #ea, #fa, #50, #50, #50, #50
db #11, #04, #9a, #5a, #f0, #f0, #f0, #f1
db #ff, #ff, #ff, #ff, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #ff, #fe, #f0
db #f0, #f0, #ff, #ff, #fc, #f0, #f0, #f7
db #ff, #fc, #f0, #f0, #f0, #f7, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #98, #50, #50, #50, #50, #50, #00, #10
db #6a, #04, #52, #5a, #58, #50, #50, #50
db #50, #41, #05, #08, #f0, #f0, #f0, #f3
db #ff, #fc, #f0, #f0, #f0, #f0, #f1, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #ff
db #ff, #ff, #fc, #f0, #f0, #f0, #f0, #f0
db #f0, #ff, #ff, #ff, #fc, #f0, #f3, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #22, #50, #50, #50, #50, #50, #01, #10
db #00, #10, #50, #50, #50, #50, #40, #8a
db #2a, #18, #40, #4a, #f0, #f0, #f0, #ff
db #ff, #f8, #f0, #f0, #f0, #f0, #f3, #ff
db #fe, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #40, #9e, #50, #50, #10, #7a, #08, #14
db #58, #04, #50, #50, #50, #00, #12, #ea
db #00, #23, #50, #52, #f0, #f0, #f0, #f0
db #f0, #ff, #ff, #ff, #ff, #ff, #fc, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #f0, #f3, #ff, #ff, #ff
db #fe, #f0, #f0, #f3, #ff, #fb, #ff, #ff
db #ff, #ff, #ff, #ff, #f8, #f0, #f0, #f1
db #ff, #ff, #fc, #f0, #f3, #ff, #ff, #fc
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #ff, #f0, #f0, #f0, #f3, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f1, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #f8, #f1, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #f0
db #f0, #f0, #f0, #f3, #ff, #ff, #ff, #f8
db #f0, #f3, #ff, #ff, #fc, #f0, #f0, #f3
db #ff, #fe, #f0, #f0, #f0, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #f1, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f1
db #ff, #fe, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f1, #ff, #ff, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #fc, #f0, #f0, #f0, #f0, #f7, #ff
db #fe, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #ff, #ff, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f1, #ff, #f8, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #50, #23, #58, #50, #50, #40, #01, #10
db #da, #10, #72, #58, #50, #10, #5a, #00
db #04, #02, #00, #2f, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #08, #40, #ee, #50, #50, #42, #00, #00
db #50, #10, #50, #62, #50, #00, #52, #4a
db #00, #50, #03, #03, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #8b, #05, #17, #ce, #40, #32, #0a, #10
db #50, #50, #50, #50, #04, #50, #10, #da
db #10, #50, #40, #06, #f0, #f0, #f0, #f0
db #f7, #ff, #fc, #f0, #f0, #ff, #ff, #f8
db #f0, #f0, #f0, #f3, #ff, #ff, #ff, #fe
db #f0, #f7, #ff, #ff, #fc, #f0, #f0, #f1
db #ff, #fe, #f0, #f0, #f0, #f7, #ff, #fe
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #10, #5a, #0a, #3f, #ae, #2a, #d8, #50
db #50, #50, #50, #50, #42, #08, #40, #52
db #50, #50, #50, #00, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #01, #00, #50, #42, #33, #9e, #50, #50
db #50, #50, #50, #01, #32, #9a, #40, #58
db #58, #50, #50, #00, #f0, #f0, #f0, #f0
db #f7, #ff, #fc, #f0, #f0, #ff, #ff, #f8
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f7, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #00, #00, #10, #58, #40, #03, #58, #50
db #50, #50, #50, #03, #36, #58, #50, #40
db #9a, #ca, #00, #00, #f0, #f0, #f0, #f3
db #ff, #f8, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #40, #01, #04, #12, #50, #40, #00, #50
db #50, #50, #50, #00, #0c, #50, #50, #50
db #40, #2a, #4a, #0a, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #ff, #ff, #fe
db #f0, #f7, #ff, #ff, #f8, #f0, #f0, #f3
db #ff, #ff, #f0, #f0, #f3, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #18, #00, #00, #00, #50, #50, #40, #58
db #50, #04, #7a, #08, #00, #50, #50, #50
db #50, #40, #05, #06, #f0, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #22, #50, #40, #00, #50, #50, #50, #52
db #58, #00, #7a, #08, #00, #50, #50, #50
db #50, #50, #00, #04, #f0, #f0, #f0, #f7
db #ff, #fe, #f0, #f0, #f0, #f0, #ff, #ff
db #fc, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #40, #98, #50, #50, #50, #40, #00, #12
db #ca, #40, #5a, #50, #50, #50, #50, #00
db #00, #10, #42, #1a, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #ff, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f3, #ff, #ff, #f8, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #ff, #f8, #f0, #f0, #f3, #ff, #f8
db #f0, #f0, #f0, #f3, #ff, #ff, #ff, #f8
db #f0, #f1, #ff, #ff, #fc, #f0, #f0, #f1
db #ff, #f8, #f0, #f0, #f0, #f3, #ff, #fe
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f8, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #f0, #f3, #ff, #ff, #f8
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f3
db #ff, #f8, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f1, #ff, #ff, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f3, #ff, #ff, #ff, #ff
db #ff, #ff, #ff, #ff, #f0, #f0, #f0, #f1
db #ff, #ff, #fc, #f0, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f7
db #ff, #ff, #fc, #f0, #f0, #f7, #ff, #ff
db #f8, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #58, #ae, #50, #50, #50, #50, #00, #5a
db #ca, #04, #50, #08, #50, #50, #50, #10
db #5a, #58, #40, #1e, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ba, #8a, #98, #50, #50, #50, #00, #5a
db #4a, #04, #50, #40, #10, #50, #50, #00
db #00, #7a, #5a, #03, #f0, #f0, #f0, #f0
db #f0, #f0, #ff, #ff, #ff, #ff, #ff, #ff
db #fe, #f0, #f0, #f3, #ff, #f8, #f0, #f7
db #ff, #ff, #fe, #f0, #f0, #f0, #f0, #f0
db #f0, #f3, #ff, #ff, #ff, #ff, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #01, #0d, #0c, #50, #50, #50, #00, #1a
db #5a, #10, #50, #50, #41, #50, #50, #00
db #00, #5a, #5a, #88, #f0, #f0, #f0, #f0
db #ff, #ff, #f0, #f0, #f0, #f3, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #ff, #fe, #f0
db #f0, #f0, #ff, #ff, #fe, #f0, #f0, #f1
db #fe, #f0, #f0, #f0, #f0, #f1, #ff, #fe
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ba, #ca, #01, #04, #50, #50, #13, #26
db #50, #50, #50, #50, #50, #13, #da, #50
db #04, #10, #50, #2a, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #1a, #50, #42, #00, #04, #00, #8b, #10
db #50, #50, #50, #50, #50, #40, #aa, #5a
db #40, #04, #50, #0a, #f0, #f0, #f0, #f0
db #f3, #ff, #ff, #ff, #ff, #ff, #ff, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #ff, #ff, #ff, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #1a, #50, #50, #4a, #10, #00, #8c, #50
db #50, #50, #50, #50, #50, #99, #04, #08
db #ea, #08, #00, #0a, #f0, #f0, #f0, #f3
db #ff, #f8, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #fe, #f0, #f0
db #f0, #f0, #f3, #ff, #ff, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #02, #50, #50, #4a, #00, #50, #12, #d8
db #50, #50, #50, #50, #42, #8a, #10, #50
db #02, #fa, #8a, #0a, #f0, #f0, #f0, #f0
db #f7, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f8, #f0, #f0, #f3, #ff, #fd, #ff, #ff
db #ff, #ff, #ff, #ff, #f0, #f0, #f0, #f1
db #ff, #ff, #ff, #ff, #ff, #ff, #f7, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #08, #08, #00, #7a, #08, #10, #50, #62
db #50, #50, #50, #00, #00, #3a, #50, #50
db #40, #2f, #0a, #0a, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #2e, #42, #00, #1a, #5a, #00, #50, #50
db #40, #50, #72, #05, #00, #1a, #50, #50
db #50, #40, #ce, #00, #f0, #f0, #f0, #f3
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #33, #98, #40, #00, #50, #50, #50, #50
db #40, #10, #52, #08, #10, #50, #50, #50
db #50, #50, #33, #18, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f3, #ff, #ff, #ff, #ff, #ff, #ff
db #ff, #f0, #f0, #f3, #ff, #f8, #f1, #ff
db #ff, #ff, #ff, #f8, #f0, #f0, #f0, #f0
db #f0, #ff, #ff, #ff, #ff, #ff, #fc, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #fe, #f0, #f0, #f0, #f1, #ff, #fc
db #f0, #f0, #f0, #f3, #ff, #ff, #fc, #f0
db #f0, #f0, #f7, #ff, #fe, #f0, #f0, #f0
db #fc, #f0, #f0, #f0, #f0, #f1, #ff, #fe
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #fc, #f0, #f0, #f0, #f0, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f7, #ff, #ff, #ff, #ff, #ff, #fe, #f0
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #ff, #ff, #f8, #f0, #f1
db #ff, #ff, #f8, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f3
db #ff, #f8, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f3, #ff, #ff, #f0, #f0
db #f0, #f0, #f3, #ff, #fe, #f0, #f0, #f7
db #ff, #f8, #f0, #f0, #f0, #f0, #ff, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #ff
db #fc, #f0, #f0, #f3, #ff, #fc, #ff, #ff
db #ff, #ff, #ff, #fe, #f0, #f0, #f0, #f0
db #ff, #ff, #ff, #ff, #ff, #fe, #f7, #ff
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f0, #f0, #f0, #f0, #ff
db #ff, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f1
db #ff, #ff, #ff, #ff, #ff, #ff, #ff, #fe
db #f0, #f0, #f0, #f3, #ff, #fc, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
db #f0, #f0, #f0, #f0, #f0, #f0, #f0, #f0
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

BANK 6
org #4000
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #ff,#ff,#ff,#ff,#ff,#ff,#ff,#ff
db #cd,#6e,#58,#cd,#75,#58,#cd,#fc
db #58,#cd,#fb,#58,#cd,#98,#59,#cd
db #25,#54,#3a,#3a,#5b,#f5,#cd,#01
db #56,#f1,#3d,#20,#f8,#c9,#cd,#01
db #56,#cd,#6b,#54,#c9,#06,#0e,#0e
db #0d,#af,#c5,#cd,#33,#54,#c1,#0d
db #10,#f8,#c9,#06,#f4,#ed,#49,#01
db #c0,#f6,#ed,#49,#ed,#71,#06,#f4
db #ed,#79,#01,#80,#f6,#ed,#49,#ed
db #71,#c9,#7e,#fe,#00,#28,#11,#32
db #00,#00,#ed,#49,#d9,#ed,#71,#44
db #ed,#79,#45,#ed,#59,#ed,#51,#d9
db #0c,#13,#7a,#e6,#03,#57,#ed,#53
db #76,#54,#c9,#11,#80,#c0,#21,#f6
db #f4,#45,#ed,#51,#d9,#11,#00,#00
db #6b,#06,#f4,#0e,#00,#00,#00,#00
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
db #00,#f3,#ed,#73,#20,#56,#3a,#3a
db #5b,#3d,#dd,#26,#00,#fd,#21,#14
db #56,#c3,#c4,#56,#2a,#12,#56,#2b
db #56,#2b,#5e,#ed,#53,#12,#56,#31
db #00,#00,#fb,#c9,#cc,#56,#21,#00
db #00,#4d,#16,#00,#3a,#3a,#5b,#5f
db #b7,#ed,#52,#22,#27,#56,#3d,#d2
db #c4,#56,#42,#11,#64,#56,#ed,#53
db #12,#56,#ed,#5b,#5d,#5b,#19,#22
db #27,#56,#79,#32,#7a,#56,#32,#65
db #56,#2a,#76,#54,#09,#3a,#3a,#5b
db #4f,#09,#7c,#e6,#03,#32,#0c,#56
db #7d,#32,#8d,#56,#3e,#00,#3d,#fa
db #71,#56,#fd,#21,#76,#56,#c3,#c4
db #56,#3a,#3a,#5b,#18,#06,#3a,#3a
db #5b,#06,#00,#90,#2a,#6f,#56,#23
db #5e,#23,#56,#13,#13,#13,#13,#21
db #a1,#00,#19,#eb,#36,#00,#23,#eb
db #ed,#a0,#ed,#a0,#ed,#a0,#ed,#a0
db #ed,#a0,#fd,#21,#a1,#56,#3d,#18
db #cd,#2a,#6f,#56,#2b,#56,#2b,#5e
db #21,#d9,#a9,#19,#38,#0a,#21,#26
db #56,#ed,#53,#12,#56,#11,#c4,#56
db #ed,#53,#6f,#56,#ed,#7b,#20,#56
db #fb,#c9,#cc,#56,#31,#fa,#59,#c3
db #d7,#57,#d4,#56,#31,#04,#5a,#c3
db #56,#57,#dc,#56,#31,#0e,#5a,#c3
db #d7,#57,#e4,#56,#31,#18,#5a,#c3
db #56,#57,#ec,#56,#31,#22,#5a,#c3
db #d7,#57,#f4,#56,#31,#2c,#5a,#c3
db #56,#57,#fc,#56,#31,#36,#5a,#c3
db #56,#57,#04,#57,#31,#40,#5a,#c3
db #56,#57,#0c,#57,#31,#4a,#5a,#c3
db #56,#57,#14,#57,#31,#54,#5a,#c3
db #56,#57,#1c,#57,#31,#5e,#5a,#c3
db #56,#57,#24,#57,#31,#68,#5a,#c3
db #56,#57,#2c,#57,#31,#72,#5a,#c3
db #56,#57,#26,#56,#31,#7c,#5a,#c3
db #56,#57,#3c,#57,#31,#86,#5a,#c3
db #56,#57,#c4,#56,#31,#90,#5a,#c3
db #56,#57,#08,#7e,#23,#d9,#12,#1c
db #08,#3d,#d9,#f2,#6f,#57,#e5,#c5
db #d9,#c5,#e5,#d5,#fd,#e9,#d1,#e1
db #c1,#04,#05,#28,#0f,#d9,#57,#d9
db #80,#30,#4c,#08,#7e,#2c,#12,#1c
db #04,#20,#f9,#08,#d9,#c1,#e1,#cb
db #21,#20,#04,#4e,#23,#cb,#31,#30
db #c9,#46,#23,#57,#80,#30,#15,#08
db #78,#d9,#47,#d9,#7e,#23,#d9,#81
db #6f,#7e,#2c,#12,#1c,#04,#20,#f9
db #08,#d9,#18,#db,#08,#7a,#d9,#47
db #04,#d9,#7e,#23,#e5,#c5,#d9,#81
db #6f,#7e,#2c,#12,#1c,#10,#fa,#08
db #47,#04,#c5,#e5,#d5,#fd,#e9,#3c
db #47,#c5,#d9,#7a,#d9,#47,#04,#7e
db #12,#2c,#1c,#10,#fa,#e5,#d5,#fd
db #e9,#08,#7e,#23,#d9,#12,#13,#cb
db #92,#08,#3d,#d9,#f2,#f4,#57,#e5
db #c5,#d9,#c5,#e5,#d5,#fd,#e9,#d1
db #e1,#c1,#04,#05,#28,#13,#d9,#57
db #d9,#80,#30,#74,#08,#7e,#23,#cb
db #94,#12,#13,#cb,#92,#04,#20,#f5
db #08,#d9,#c1,#e1,#cb,#21,#20,#04
db #4e,#23,#cb,#31,#30,#c3,#46,#23
db #57,#80,#30,#27,#08,#78,#d9,#47
db #d9,#7e,#23,#d9,#81,#6f,#7a,#cb
db #87,#cb,#8f,#d9,#8e,#dd,#84,#e6
db #fb,#23,#d9,#67,#7e,#23,#cb,#94
db #12,#13,#cb,#92,#04,#20,#f5,#08
db #d9,#18,#c9,#08,#7a,#d9,#47,#04
db #d9,#7e,#23,#d9,#81,#6f,#7a,#cb
db #87,#cb,#8f,#d9,#8e,#dd,#84,#e6
db #fb,#23,#e5,#c5,#d9,#67,#7e,#23
db #cb,#94,#12,#13,#cb,#92,#10,#f6
db #08,#47,#04,#c5,#e5,#d5,#fd,#e9
db #3c,#47,#c5,#d9,#7a,#d9,#47,#04
db #7e,#12,#23,#cb,#94,#13,#cb,#92
db #10,#f6,#e5,#d5,#fd,#e9,#2a,#5d
db #5b,#22,#27,#56,#c9,#21,#3d,#5b
db #16,#40,#d9,#2a,#3b,#5b,#23,#23
db #e5,#11,#03,#00,#3a,#3a,#5b,#47
db #0e,#00,#7e,#fe,#01,#28,#0c,#d9
db #72,#23,#36,#04,#2b,#7a,#c6,#08
db #57,#d9,#0c,#d9,#23,#23,#d9,#19
db #10,#e8,#21,#3d,#5b,#16,#40,#06
db #03,#d9,#e1,#e5,#11,#03,#00,#3a
db #3a,#5b,#47,#7e,#fe,#04,#28,#18
db #d9,#78,#3c,#e6,#03,#47,#20,#09
db #79,#b7,#28,#05,#0d,#7a,#c6,#04
db #57,#72,#23,#36,#01,#2b,#14,#d9
db #d9,#23,#23,#d9,#19,#10,#dc,#21
db #c8,#56,#01,#07,#00,#d9,#e1,#11
db #03,#00,#3a,#3a,#5b,#47,#7e,#fe
db #01,#d9,#11,#56,#57,#28,#03,#11
db #d7,#57,#73,#23,#72,#09,#d9,#19
db #10,#ec,#c9,#c9,#21,#3d,#5b,#11
db #7d,#54,#46,#23,#7e,#23,#fe,#01
db #cc,#7d,#59,#c4,#8a,#59,#06,#0d
db #c5,#cd,#5a,#59,#46,#23,#7e,#fe
db #04,#cc,#8a,#59,#28,#15,#2b,#2b
db #be,#c4,#7d,#59,#20,#0b,#2b,#7e
db #23,#90,#3c,#cc,#85,#59,#c4,#7d
db #59,#23,#23,#23,#c1,#10,#d9,#eb
db #36,#7e,#23,#36,#3c,#23,#36,#28
db #23,#36,#0f,#23,#36,#3d,#23,#eb
db #21,#52,#54,#01,#0f,#00,#ed,#b0
db #1b,#21,#61,#54,#01,#0a,#00,#ed
db #b0,#c9,#e5,#21,#4a,#54,#ed,#a0
db #ed,#a0,#42,#0e,#ff,#7b,#ed,#a0
db #ed,#a0,#ed,#a0,#ed,#a0,#12,#13
db #78,#12,#13,#21,#52,#54,#01,#0f
db #00,#ed,#b0,#e1,#c9,#eb,#36,#26
db #23,#70,#23,#eb,#c9,#3e,#24,#12
db #13,#c9,#eb,#36,#3e,#23,#70,#23
db #36,#b2,#23,#36,#67,#23,#eb,#c9
db #21,#26,#56,#22,#12,#56,#21,#c4
db #56,#22,#6f,#56,#af,#32,#0c,#56
db #21,#00,#00,#22,#76,#54,#cd,#bd
db #59,#21,#fa,#59,#11,#9a,#5a,#01
db #a0,#00,#ed,#b0,#c9,#21,#3d,#5b
db #d9,#3a,#3a,#5b,#47,#ed,#5b,#3b
db #5b,#13,#13,#21,#fa,#59,#c5,#d9
db #7e,#23,#23,#d9,#36,#00,#23,#77
db #23,#23,#77,#23,#36,#00,#23,#36
db #00,#23,#36,#40,#23,#23,#eb,#23
db #4e,#23,#46,#e5,#09,#44,#4d,#e1
db #23,#eb,#71,#23,#70,#23,#c1,#10
db #d5,#c9,#00,#00,#00,#00,#00,#00
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
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#0e,#5d,#5b,#40,#04,#c4
db #01,#c8,#04,#c5,#01,#d0,#04,#c6
db #01,#c7,#01,#cc,#01,#cd,#01,#ce
db #01,#cf,#01,#d4,#01,#d5,#01,#d6
db #01,#d7,#01,#d8,#01,#00,#0c,#01
db #2e,#00,#01,#ec,#01,#01,#04,#02
db #01,#da,#03,#01,#fd,#03,#01,#28
db #05,#01,#04,#06,#01,#1c,#06,#01
db #45,#07,#01,#ea,#07,#01,#3f,#08
db #01,#81,#09,#01,#9a,#0a,#01,#b2
db #0a,#ff,#ff,#ff,#ff,#ff,#ff,#54
db #92,#fa,#00,#53,#5f,#fa,#08,#5e
db #3f,#fa,#10,#3e,#fa,#98,#00,#00
db #00,#00,#00,#00,#00,#c8,#48,#43
db #fa,#b8,#42,#0a,#41,#42,#43,#44
db #c4,#bc,#7e,#fa,#00,#7d,#55,#71
db #fa,#08,#70,#fe,#0d,#6b,#fc,#12
db #6a,#f8,#00,#2a,#59,#59,#fa,#b2
db #a7,#fe,#7f,#55,#fc,#24,#52,#e0
db #d1,#29,#fb,#12,#fd,#15,#6e,#73
db #79,#7e,#82,#15,#86,#8b,#8e,#f8
db #08,#6f,#fe,#0f,#72,#dc,#74,#d7
db #f8,#b0,#e8,#48,#5f,#fa,#c0,#5e
db #f8,#a0,#f8,#c8,#f8,#c0,#d0,#f0
db #c0,#ee,#c0,#50,#fc,#02,#4f,#9d
db #4f,#50,#7f,#51,#fc,#04,#fb,#02
db #fd,#0d,#f0,#a0,#f8,#10,#f0,#10
db #f8,#60,#0d,#69,#6a,#6b,#6c,#fc
db #44,#f0,#e8,#5d,#fe,#df,#73,#60
db #fc,#5c,#f8,#40,#f0,#50,#59,#59
db #e2,#a2,#e8,#b0,#a0,#f8,#68,#71
db #fa,#c0,#70,#6f,#70,#71,#72,#8b
db #cc,#c4,#43,#43,#3f,#fc,#02,#3e
db #fb,#02,#fd,#05,#5f,#47,#fa,#10
db #46,#f8,#08,#f8,#70,#d8,#88,#f0
db #48,#f8,#18,#58,#3d,#fe,#07,#40
db #f4,#1c,#f8,#60,#32,#32,#2f,#82
db #fc,#82,#2e,#5d,#2e,#2f,#30,#fc
db #84,#2d,#a9,#e1,#89,#38,#fa,#b0
db #37,#f8,#78,#4b,#4b,#fa,#12,#0e
db #45,#46,#47,#48,#dc,#c4,#f8,#c0
db #f8,#00,#7c,#ea,#f9,#69,#f8,#68
db #e0,#08,#50,#fa,#30,#4f,#f8,#70
db #5f,#83,#fa,#40,#5e,#5d,#5e,#5f
db #60,#fc,#44,#f8,#30,#d4,#f8,#40
db #f0,#60,#36,#fa,#70,#35,#f8,#60
db #2d,#2d,#41,#2a,#fc,#82,#29,#52
db #29,#2a,#2b,#fc,#84,#54,#28,#e1
db #89,#2f,#fa,#b0,#2e,#f8,#70,#3c
db #3c,#41,#38,#fc,#c2,#37,#36,#37
db #38,#39,#cc,#c4,#10,#86,#86,#7e
db #fc,#02,#7d,#7c,#7d,#7e,#72,#7f
db #fc,#04,#f0,#00,#f0,#18,#59,#59
db #fa,#3a,#52,#11,#53,#54,#55,#d4
db #34,#64,#64,#5f,#fc,#6a,#04,#5e
db #5d,#5e,#5f,#60,#b4,#6c,#78,#78
db #41,#71,#fc,#c2,#70,#6f,#70,#71
db #72,#e4,#c4,#f1,#e8,#68,#98,#00
db #68,#60,#98,#00,#64,#64,#5f,#fc
db #6a,#04,#5e,#5d,#5e,#5f,#60,#f4
db #6c,#4b,#4b,#41,#47,#fc,#82,#46
db #45,#46,#47,#48,#dc,#84,#14,#78
db #78,#71,#fc,#b2,#70,#f8,#10,#96
db #96,#41,#8e,#fc,#c2,#8d,#8c,#8d
db #8e,#8f,#e4,#c4,#f4,#e8,#68,#98
db #00,#e8,#60,#fe,#ad,#43,#fc,#82
db #42,#41,#10,#42,#43,#44,#8c,#84
db #00,#ff,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#f0,#00,#00,#00,#00,#00
db #00,#01,#00,#fc,#00,#d6,#a9,#7e
db #6b,#54,#3f,#7d,#fa,#19,#d5,#a9
db #7f,#ec,#04,#e8,#00,#fc,#be,#fe
db #22,#5e,#5f,#fc,#2d,#bd,#fe,#32
db #f4,#3c,#e0,#00,#f0,#68,#be,#40
db #96,#fe,#3b,#4b,#3f,#2f,#5e,#bc
db #95,#3d,#7e,#60,#ec,#84,#e8,#80
db #d0,#a0,#e8,#c8,#9f,#fe,#53,#00
db #50,#3f,#36,#28,#4f,#9d,#7d,#6b
db #78,#51,#ec,#04,#e8,#00,#d0,#20
db #e8,#48,#a9,#7e,#71,#00,#54,#3f
db #38,#2a,#53,#a7,#7d,#71,#75,#55
db #ec,#84,#e8,#80,#e7,#a0,#86,#fe
db #ba,#43,#fc,#c5,#72,#85,#fe,#ca
db #ec,#d4,#f0,#d0,#fc,#d6,#fe,#b8
db #6b,#83,#fe,#bb,#7d,#fa,#d5,#a9
db #7f,#ec,#04,#e8,#00,#2b,#fc,#be
db #fe,#22,#5f,#fc,#2d,#bd,#fe,#32
db #f4,#3c,#c8,#e0,#00,#f0,#68,#be
db #96,#fe,#3b,#4b,#3f,#2f,#07,#5e
db #bc,#95,#7e,#60,#ec,#84,#e8,#80
db #d0,#a0,#a0,#e8,#c8,#9f,#fe,#53
db #50,#3f,#36,#28,#4f,#0f,#9d,#7d
db #6b,#51,#ec,#04,#e8,#00,#d0,#20
db #e8,#48,#00,#a9,#7e,#71,#54,#3f
db #38,#2a,#53,#0c,#a7,#7d,#71,#55
db #ec,#84,#e8,#80,#a9,#86,#ac,#fe
db #a2,#43,#fc,#ad,#85,#fe,#b2,#c4
db #bc,#fc,#d6,#a8,#fe,#a0,#6b,#fe
db #a3,#7e,#88,#00,#1c,#e1,#be,#05
db #8e,#71,#5f,#47,#8e,#88,#80,#9f
db #fe,#7b,#04,#50,#3f,#36,#28,#50
db #88,#00,#a9,#7e,#02,#71,#54,#3f
db #38,#2a,#54,#cf,#80,#86,#a5,#fe
db #b2,#43,#bd,#b5,#fc,#d6,#fe,#b0
db #6b,#fe,#b3,#56,#7e,#cf,#00,#be
db #fe,#32,#5f,#ec,#35,#d1,#09,#1c
db #01,#e1,#be,#8e,#71,#5f,#47,#8e
db #88,#80,#41,#9f,#fe,#7b,#50,#3f
db #36,#28,#50,#88,#00,#00,#a9,#7e
db #71,#54,#3f,#38,#2a,#54,#ae,#cf
db #80,#86,#fe,#b2,#43,#bd,#b5,#fe
db #79,#fe,#b3,#36,#15,#2a,#20,#3f
db #cf,#00,#5f,#fe,#32,#2f,#ec,#35
db #80,#d1,#09,#8e,#71,#5f,#47,#38
db #2f,#24,#54,#47,#88,#80,#9f,#fe
db #78,#50,#fe,#7b,#28,#50,#80,#88
db #00,#a9,#7e,#71,#54,#3f,#38,#2a
db #44,#54,#e8,#80,#be,#8e,#7e,#fe
db #fa,#3f,#2f,#4b,#5f,#f0,#a0,#a9
db #86,#fe,#9a,#43,#fc,#95,#c1,#b9
db #c2,#fe,#79,#fe,#9b,#36,#2a,#20
db #3f,#cf,#00,#5f,#b2,#fe,#32,#2f
db #ec,#35,#d1,#09,#8e,#71,#fe,#b3
db #38,#15,#2f,#24,#47,#88,#80,#9f
db #fe,#78,#50,#fe,#7b,#20,#28,#50
db #88,#00,#a9,#7e,#71,#54,#3f,#15
db #38,#2a,#54,#cf,#80,#86,#fe,#b2
db #43,#cd,#b5,#14,#51,#0b,#e1,#fc
db #e8,#a9,#f8,#f0,#00,#fb,#00,#00
db #00,#00,#00,#00,#00,#00,#81,#00
db #01,#81,#79,#00,#ff,#bf,#80,#ff
db #01,#81,#79,#00,#ff,#00,#ff,#00
db #ff,#00,#ff,#10,#ff,#20,#01,#01
db #f2,#ea,#eb,#16,#6b,#ab,#6b,#f4
db #03,#08,#f9,#10,#f8,#00,#2b,#ff
db #fe,#19,#fe,#18,#ed,#0d,#f8,#28
db #f0,#3f,#f0,#30,#f8,#20,#f0,#08
db #ff,#f8,#68,#d0,#00,#f0,#58,#f0
db #50,#e0,#50,#f0,#98,#e8,#30,#e8
db #98,#ff,#d0,#a0,#f0,#30,#e8,#c0
db #e8,#70,#f0,#e0,#e8,#40,#f0,#b8
db #e0,#18,#ff,#f0,#c8,#f0,#a8,#e8
db #d8,#f0,#88,#f0,#3f,#e8,#50,#f0
db #08,#f8,#68,#ff,#d0,#00,#e8,#b0
db #d8,#48,#f0,#98,#e8,#30,#e8,#98
db #d0,#a0,#f0,#30,#ff,#e8,#c0,#e8
db #70,#f0,#e0,#f0,#58,#c0,#b8,#f8
db #98,#f0,#a8,#e8,#18,#ff,#f0,#88
db #f0,#3f,#e8,#50,#f0,#08,#f8,#68
db #d0,#00,#f0,#58,#f0,#50,#ff,#e0
db #50,#f0,#98,#e8,#30,#e8,#98,#d0
db #a0,#f0,#30,#e8,#c0,#e8,#70,#ff
db #f0,#e0,#e8,#40,#f0,#b8,#e0,#18
db #f0,#c8,#f0,#a8,#e8,#d8,#f0,#88
db #ff,#f0,#3f,#e8,#50,#f0,#08,#f8
db #68,#d0,#00,#e8,#b0,#d8,#48,#f0
db #98,#ff,#e8,#30,#e8,#98,#d0,#a0
db #f0,#30,#e8,#c0,#e8,#70,#f0,#e0
db #e8,#40,#ff,#f0,#b8,#e0,#18,#f0
db #c8,#f0,#a8,#e8,#d8,#f0,#88,#f0
db #3f,#e8,#50,#ff,#f0,#08,#f8,#68
db #d0,#00,#e8,#b0,#d8,#48,#f0,#98
db #e8,#30,#e8,#98,#ff,#d0,#a0,#f0
db #30,#e8,#c0,#e8,#70,#f0,#e0,#e8
db #40,#f0,#b8,#e0,#18,#ff,#f0,#c8
db #f0,#a8,#e8,#d8,#f0,#88,#f0,#3f
db #e8,#50,#f0,#08,#f8,#68,#ff,#d0
db #00,#e8,#b0,#d8,#48,#f0,#98,#e8
db #30,#e8,#98,#d0,#a0,#f0,#30,#ff
db #e8,#c0,#e8,#70,#f0,#e0,#e8,#40
db #e8,#c7,#f8,#b8,#f0,#e0,#f8,#c0
db #01,#1b,#02,#03,#00,#ec,#03,#f8
db #00,#01,#fd,#20,#ec,#0c,#ff,#e8
db #37,#f0,#30,#f0,#20,#e0,#40,#e0
db #10,#f0,#58,#ef,#50,#e1,#51,#ff
db #f0,#98,#cf,#00,#d0,#a1,#e9,#e1
db #ef,#10,#e8,#71,#d9,#31,#ef,#b8
db #ff,#e1,#19,#c7,#f8,#e9,#01,#e7
db #68,#e9,#a1,#e0,#28,#d0,#98,#d8
db #48,#ff,#f0,#98,#cf,#00,#d0,#a1
db #e9,#e1,#ef,#10,#e8,#71,#e0,#31
db #c0,#b9,#ff,#d0,#01,#e9,#01,#e7
db #68,#e9,#a1,#e0,#28,#d7,#98,#f0
db #51,#e1,#51,#ff,#f0,#98,#cf,#00
db #d0,#a1,#e9,#e1,#ef,#10,#e8,#71
db #d9,#31,#ef,#b8,#ff,#e1,#19,#c7
db #f8,#e9,#01,#e7,#68,#e9,#a1,#e0
db #28,#d0,#98,#d8,#48,#ff,#f0,#98
db #cf,#00,#d0,#a1,#e9,#e1,#ef,#10
db #e8,#71,#d9,#31,#ef,#b8,#ff,#e1
db #19,#c7,#f8,#e9,#01,#e7,#68,#e9
db #a1,#e0,#28,#d0,#98,#d8,#48,#ff
db #f0,#98,#cf,#00,#d0,#a1,#e9,#e1
db #ef,#10,#e8,#71,#d9,#31,#ef,#b8
db #ff,#e1,#19,#c7,#f8,#e9,#01,#e7
db #68,#e9,#a1,#e0,#28,#d0,#98,#d8
db #48,#ff,#f0,#98,#cf,#00,#d0,#a1
db #e9,#e1,#ef,#10,#e8,#71,#d1,#31
db #e7,#a8,#c0,#f0,#e1,#f9,#c1,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#00,#00,#00,#00,#00,#00
db #01,#00,#18,#13,#38,#38,#3c,#f4
db #03,#18,#18,#f9,#0a,#f9,#01,#ff
db #fe,#10,#fa,#10,#ee,#10,#f2,#0a
db #f7,#08,#ef,#31,#f2,#40,#f0,#38
db #ff,#cf,#00,#f1,#59,#ef,#50,#e0
db #51,#f0,#99,#e9,#31,#e6,#98,#d1
db #a2,#ff,#f0,#31,#e8,#c1,#e7,#c1
db #f1,#e2,#e7,#41,#f1,#ba,#df,#19
db #f2,#ca,#ff,#ef,#a8,#e8,#d9,#ef
db #51,#f3,#03,#e7,#4f,#ee,#a8,#f2
db #4a,#d7,#08,#ff,#e7,#b1,#d9,#4a
db #f0,#99,#e9,#31,#e6,#98,#d1,#a2
db #f0,#31,#e8,#c1,#ff,#e7,#c1,#f1
db #e2,#ef,#59,#c1,#ba,#f9,#99,#ef
db #a8,#e8,#19,#ef,#51,#ff,#f3,#03
db #e7,#4f,#ee,#a8,#f2,#4a,#d7,#08
db #f0,#b1,#f0,#51,#e0,#51,#ff,#f0
db #99,#e9,#31,#e6,#98,#d1,#a2,#f0
db #31,#e8,#c1,#e7,#c1,#f1,#e2,#ff
db #e7,#41,#f1,#ba,#df,#19,#f2,#ca
db #ef,#a8,#e8,#d9,#ef,#51,#f3,#03
db #ff,#e7,#4f,#ee,#a8,#f2,#4a,#d7
db #08,#e7,#b1,#d9,#4a,#f0,#99,#e9
db #31,#ff,#e6,#98,#d1,#a2,#f0,#31
db #e8,#c1,#e7,#c1,#f1,#e2,#e7,#41
db #f1,#ba,#ff,#df,#19,#f2,#ca,#ef
db #a8,#e8,#d9,#ef,#51,#f3,#03,#e7
db #4f,#ee,#a8,#ff,#f2,#4a,#d7,#08
db #e7,#b1,#d9,#4a,#f0,#99,#e9,#31
db #e6,#98,#d1,#a2,#ff,#f0,#31,#e8
db #c1,#e7,#c1,#f1,#e2,#e7,#41,#f1
db #ba,#df,#19,#f2,#ca,#ff,#ef,#a8
db #e8,#d9,#ef,#51,#f3,#03,#e7,#4f
db #ee,#a8,#f2,#4a,#d7,#08,#ff,#e7
db #b1,#d9,#4a,#f0,#99,#e9,#31,#e6
db #98,#d1,#a2,#f0,#31,#e8,#c1,#fe
db #e7,#c1,#f1,#e2,#e9,#41,#e8,#c7
db #f6,#60,#f1,#e2,#f9,#c1,#07,#f5
db #00,#00,#00,#00,#00,#00,#41,#00
db #00,#c1,#c0,#0b,#d9,#00,#5d,#09
db #f9,#28,#08,#f1,#30,#e0,#a0,#d8
db #00,#0a,#f1,#88,#ff,#f8,#28,#f0
db #80,#f0,#28,#f8,#a0,#f0,#58,#e0
db #c8,#e8,#f7,#e8,#e8,#ff,#d8,#d8
db #c0,#10,#f0,#a8,#f0,#b0,#f8,#a0
db #f8,#90,#e8,#80,#e0,#90,#ff,#f0
db #78,#f8,#f0,#f0,#c0,#e0,#1f,#e0
db #d0,#e8,#28,#e8,#78,#e0,#38,#fb
db #a8,#20,#b8,#c8,#d8,#70,#e8,#58
db #e8,#10,#08,#f9,#a8,#c0,#f0,#ff
db #f8,#a8,#f0,#a8,#e8,#78,#f8,#08
db #d0,#78,#e0,#a0,#e8,#28,#c0,#8f
db #ff,#e8,#40,#e0,#18,#d0,#08,#d8
db #40,#f8,#5f,#f0,#48,#f8,#40,#d8
db #c0,#ff,#e8,#50,#c0,#bf,#c8,#00
db #d0,#88,#e8,#10,#f0,#68,#c0,#8f
db #e8,#40,#ff,#e0,#18,#d0,#08,#d8
db #40,#f8,#5f,#f0,#48,#f8,#40,#d8
db #c0,#e8,#50,#80,#c0,#bf,#0b,#af
db #f9,#00,#09,#f9,#08,#08,#f1,#10
db #e8,#00,#d0,#20,#e8,#67,#fe,#90
db #00,#f8,#d0,#00,#78,#88,#78,#d8
db #10,#28,#98,#a0,#f0,#05,#ad,#f9
db #d0,#04,#f9,#d8,#03,#e9,#e0,#f8
db #c8,#0c,#f9,#00,#7f,#0a,#f9,#08
db #f8,#c0,#f8,#17,#e8,#00,#d0,#20
db #f0,#48,#d0,#48,#ff,#00,#28,#00
db #28,#00,#28,#00,#28,#00,#28,#d0
db #40,#d8,#d7,#30,#00,#f0,#30,#50
db #e8,#9f,#c0,#80,#f8,#e8,#0f,#13
db #0e,#0b,#10,#f4,#03,#0e,#09,#fa
db #0a,#f8,#00,#bf,#fe,#18,#0c,#fb
db #11,#f0,#10,#f8,#28,#f8,#38,#f8
db #47,#f0,#30,#ff,#f8,#20,#f0,#08
db #f0,#28,#d8,#08,#f0,#58,#ee,#50
db #e2,#52,#f0,#98,#ff,#e8,#30,#e6
db #18,#d0,#a2,#f0,#22,#ea,#c2,#e6
db #70,#f2,#e2,#e8,#40,#ff,#ee,#b8
db #e2,#1a,#f0,#c8,#ee,#a8,#e8,#da
db #f2,#8a,#f8,#38,#f8,#47,#ff,#e8
db #50,#f0,#08,#f0,#28,#d8,#08,#e8
db #b0,#e8,#28,#f0,#60,#f0,#98,#ff
db #e8,#30,#e6,#18,#d0,#a2,#f0,#22
db #ea,#c2,#e6,#70,#f2,#e2,#ee,#40
db #ff,#c0,#ba,#fa,#9a,#ee,#a8,#e8
db #1a,#f2,#8a,#f8,#38,#f8,#47,#e8
db #50,#ff,#f0,#08,#f0,#28,#d8,#08
db #ee,#b0,#f0,#52,#e2,#52,#f0,#98
db #e8,#30,#ff,#e6,#18,#d0,#a2,#f0
db #22,#ea,#c2,#e6,#70,#f2,#e2,#e8
db #40,#ee,#b8,#ff,#e2,#1a,#f0,#c8
db #ee,#a8,#e8,#da,#f2,#8a,#f8,#38
db #f8,#47,#e8,#50,#ff,#f0,#08,#f0
db #28,#d8,#08,#e8,#b0,#e8,#28,#f0
db #60,#f0,#98,#e8,#30,#ff,#e6,#18
db #d0,#a2,#f0,#22,#ea,#c2,#e6,#70
db #f2,#e2,#e8,#40,#ee,#b8,#ff,#e2
db #1a,#f0,#c8,#ee,#a8,#e8,#da,#f2
db #8a,#f8,#38,#f8,#47,#e8,#50,#ff
db #f0,#08,#f0,#28,#d8,#08,#e8,#b0
db #e8,#28,#f0,#60,#f0,#98,#e8,#30
db #ff,#e6,#18,#d0,#a2,#f0,#22,#ea
db #c2,#e6,#70,#f2,#e2,#e8,#40,#ee
db #b8,#ff,#e2,#1a,#f0,#c8,#ee,#a8
db #e8,#da,#f2,#8a,#f8,#38,#f8,#47
db #e8,#50,#ff,#f0,#08,#f0,#28,#d8
db #08,#e8,#b0,#e8,#28,#f0,#60,#f0
db #98,#e8,#30,#ff,#e6,#18,#d0,#a2
db #f0,#22,#ea,#c2,#e6,#70,#f2,#e2
db #e8,#40,#e8,#c7,#e0,#f6,#b8,#f0
db #e2,#fa,#c2,#20,#b5,#f1,#00,#10
db #f9,#10,#98,#00,#18,#f1,#80,#0c
db #f9,#90,#ae,#98,#80,#28,#f1,#00
db #14,#f9,#10,#d8,#00,#c0,#00,#2c
db #bd,#f9,#80,#15,#f9,#88,#f8,#80
db #b8,#80,#e0,#b8,#20,#f1,#00,#6b
db #10,#f9,#10,#98,#00,#18,#f1,#80
db #0c,#f9,#90,#98,#80,#5d,#28,#f1
db #00,#14,#f9,#10,#d8,#00,#c0,#00
db #2c,#f9,#80,#7a,#15,#f9,#88,#f8
db #80,#b8,#80,#e0,#b8,#20,#f1,#00
db #10,#d7,#f9,#10,#98,#00,#24,#f9
db #80,#12,#f1,#88,#f8,#80,#e0,#80
db #eb,#e0,#90,#f0,#c8,#f0,#d0,#28
db #f1,#00,#14,#f9,#10,#d8,#00,#af
db #c0,#00,#2c,#f9,#80,#15,#f9,#88
db #f8,#80,#b8,#80,#e0,#b8,#5a,#20
db #f1,#00,#10,#f9,#10,#98,#00,#24
db #f9,#80,#12,#fd,#f1,#88,#f8,#80
db #e0,#80,#e0,#90,#f0,#c8,#f0,#d0
db #18,#f1,#00,#7a,#0c,#f9,#10,#d8
db #00,#c8,#00,#f8,#68,#2c,#f9,#80
db #15,#f5,#f9,#88,#f8,#80,#b8,#80
db #e0,#b8,#20,#f1,#00,#10,#f9,#10
db #af,#98,#00,#24,#f9,#80,#12,#f1
db #88,#f8,#80,#e0,#80,#e0,#90,#d7
db #f0,#c8,#f0,#d0,#28,#f1,#00,#14
db #f9,#10,#d8,#00,#c0,#00,#5e,#2c
db #f9,#80,#15,#f9,#88,#f8,#80,#b8
db #80,#e0,#b8,#20,#b5,#f1,#00,#10
db #f9,#10,#98,#00,#24,#f9,#80,#12
db #f1,#88,#fa,#f8,#80,#e0,#80,#e0
db #90,#f0,#c8,#f0,#d0,#18,#f1,#00
db #0c,#f5,#f9,#10,#d8,#00,#c8,#00
db #f8,#68,#2c,#f9,#80,#15,#f9,#88
db #e0,#f8,#80,#b8,#80,#e0,#b8,#00
db #ff,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#f0,#00,#00,#00,#00,#00,#00
db #01,#00,#0e,#7f,#ff,#fa,#01,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#fc,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#08,#00
db #00,#00,#00,#00,#00,#00,#00,#00
finc6

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
