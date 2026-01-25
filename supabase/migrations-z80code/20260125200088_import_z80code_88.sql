-- Migration: Import z80code projects batch 88
-- Projects 175 to 176
-- Generated: 2026-01-25T21:43:30.208604

-- Project 175: delta_làl_optimisation by tronic
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'delta_làl_optimisation',
    'Imported from z80Code. Author: tronic. Test...',
    'public',
    false,
    false,
    '2022-09-13T23:10:11.587000'::timestamptz,
    '2022-09-28T12:12:13.042000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    '; Tentative d''optimisation (en taille, sur une frame) du précédent delta/LàL...
; Une sorte de "3d crtc engine" (c) TM LTD !?! Humour... :-)

; En réaménageant les datas/deltas + une routine idoine, une frame ne pèse désormais plus que 
; env. 1.52ko contre env. 3.43ko auparavant et dans les précédents exemples...
; (voir print rasm plus bas + build logs...)

; Un mix des deux serait peut-être intéressant (?) pour profiter de la souplesse/simplicité de l''un
; (gourmand en taille) et de l''autre (moins gourmand en taille, mais plus "complexe")...

; Dans ce test, il n''y a qu''une seule frame, (sur les x60) Pour voir déjà si ça marche :)
; Il doit ceci étant forcément y avoir mieux et mieux optimisé...

; la table est composée ainsi :
; ;;;;;;;; ligne3  ;;;;;;;;;;;
; db w64/256 : db #c0               ; Poids fort routine qui attends 64nops... ligne vide, rien...
;;;;;;;;; ligne4  ;;;;;;;;;;;
; db poke2/256 : db #c0             ; on poke 2 octets, en #c0xx (#c0/#C8 pour du R9=1...)
; db 72 : db #30                    ; où xx=72 (axe x/y...#c000+72) / Octet poké=#30
; db 73 : db #80                    ; où xx=73 (axe x/y...#c000+73) / Octet poké=#80
; ;;;;;;;; ligne5  ;;;;;;;;;;;
 
; Ici, on case jusqu''à 8 octets/ligne avec R9=0... C''est peu... Faut donc bien se caler horizontalement
; et bien réaliser + placer son "objet" (et/ou les nops) à l''écran...
; Malgré tout, on risque tjs de se manger le beam vbl en horizontal en fonction d''aléas divers...
; Là, sur cette frame1 du logo, ça passe, mais ça semble limite sur certaines des x60 autres...
; Faut jongler, ruser... 

; Potentiellement d''avantage valable pour de "petits objets" en largeur ? Et/ou orienté/incliné ?
; Quid d''une "route" ? petits octets en bordures qui "coupent" un raster mobile en largeur... ?

; Option rajoutée en prévision de tests avec r9>0 (1,2,3...) 
; via du db #c0 (ou #c8, #d0, #d8 etc...) dans le delta...
; Pas encore testé... Aucune idée si ça fonctionnera tel que ni comment ça fonctionnera...
; à voir...

; Tronic/GPA


; Toolz dispo ici : https://uptobox.com/kb6ujgg9fegk

    org #40
	nolist
	run $

	macro wline num
	ld bc,{num}*8-1
	@loop nop
	dec bc
	ld a,b
	or c
	jr nz,@loop
	defs 6,0
	mend
	

	di
	ld hl,#c9fb
	ld (#38),hl

	ld bc,#7f00
	ld a,#40
	out (c),c
	out (c),a
	ld bc,#7f10
	ld a,#40
	out (c),c
	out (c),a
	ld bc,#7f01
	ld a,#4b
	out (c),c
	out (c),a
	ld bc,#7f02
	ld a,#54
	out (c),c
	out (c),a
	ld bc,#7f03
	ld a,#6c
	out (c),c
	out (c),a

	ld bc,#bc0c
	out (c),c
	ld bc,#bd00+#30
	out (c),c
   

main
	ld b,#f5
nosync
	in a,(c)
	rra
	jr c,nosync
	ld b,#f5
sync
	in a,(c)
	rra
	jr nc,sync
	

novbl               ; 19968...

	ld bc,#7f8d
 	out (c),c

	ld bc,#bc07
	out (c),c
	ld bc,#bd00+#ff
	out (c),c

	ld bc,#bc09
	out (c),c
	ld bc,#bd00
	out (c),c

	ld bc,#bc04
	out (c),c
	ld bc,#bd00
	out (c),c

	wline 70
	defs 33,0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; amorce, avant envoi des 200 lignes...

	ld sp,frame1       ; frame1,2,3,4... traitement à faire à "l''extérieur" de la bcl principale...
	ld ix,retour
	xor a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; on traite... 

retour                                  
	ld l,a 
	pop bc
	cp c
	jp z,fini
	ld h,c
	jp (hl)                            ; on balance... (10 nops)
                                       ; le restant doit donc faire 54 nops (10+54=64)

fini

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	wline 39
	defs 49,0

 	ld bc,#bc07       ; si on veut une autre rupture en bas...
 	ld a,0
 	out (c),c
 	inc b
 	out (c),a


 	ld bc,#bc04
 	out (c),c
 	ld a,0
 	inc b
 	out (c),a


 	ld bc,#bc09
 	ld a,0
 	out (c),c
 	inc b
 	out (c),a

	jp novbl


align 256           ; 54 nops
w64
	ld b,12
	djnz $
	nop:nop:nop
	jp (ix)

align 256           ; 54 nops
poke1
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	ld b,11
	djnz $
	jp (ix)

align 256           ; 54 nops
poke2
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,9
	djnz $
	nop:nop
	jp (ix)

align 256           ; 54 nops
poke3
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,8
	djnz $
	jp (ix)

align 256           ; 54 nops
poke4
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,6
	djnz $
	nop:nop	
	jp (ix)

align 256           ; 54 nops
poke5
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,5
	djnz $	
	jp (ix)


align 256           ; 54 nops
poke6
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,3
	djnz $
	nop:nop	
	jp (ix)

align 256           ; 54 nops
poke7
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	ld b,2
	djnz $	
	jp (ix)

align 256           ; 54 nops
poke8
	ld h,b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	pop bc
	ld l,c
	ld (hl),b
	nop:nop:nop	
	jp (ix)



frame1
;;;;;;;;; ligne0  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne1  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne2  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne3  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne4  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #01
db 72 : db #70
;;;;;;;;; ligne5  ;;;;;;;;;;;
db poke4/256 : db #c0
db 71 : db #18
db 72 : db #F0
db 73 : db #F0
db 74 : db #F0
;;;;;;;;; ligne6  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #F0
db 75 : db #80
;;;;;;;;; ligne7  ;;;;;;;;;;;
db poke1/256 : db #c0
db 70 : db #30
;;;;;;;;; ligne8  ;;;;;;;;;;;
db poke3/256 : db #c0
db 69 : db #10
db 70 : db #F0
db 75 : db #C0
;;;;;;;;; ligne9  ;;;;;;;;;;;
db poke1/256 : db #c0
db 69 : db #F0
;;;;;;;;; ligne10  ;;;;;;;;;;;
db poke2/256 : db #c0
db 67 : db #02
db 68 : db #70
;;;;;;;;; ligne11  ;;;;;;;;;;;
db poke4/256 : db #c0
db 66 : db #01
db 67 : db #30
db 68 : db #F0
db 75 : db #E0
;;;;;;;;; ligne12  ;;;;;;;;;;;
db poke3/256 : db #c0
db 66 : db #18
db 67 : db #F0
db 71 : db #B0
;;;;;;;;; ligne13  ;;;;;;;;;;;
db poke3/256 : db #c0
db 66 : db #F0
db 70 : db #E0
db 71 : db #38
;;;;;;;;; ligne14  ;;;;;;;;;;;
db poke3/256 : db #c0
db 65 : db #30
db 70 : db #00
db 71 : db #1C
;;;;;;;;; ligne15  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #18
db 65 : db #F0
db 69 : db #80
db 71 : db #14
db 75 : db #F0
;;;;;;;;; ligne16  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #01
db 64 : db #70
db 68 : db #E0
db 69 : db #00
db 75 : db #C0
;;;;;;;;; ligne17  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #02
db 64 : db #F0
db 68 : db #00
db 71 : db #16
db 75 : db #00
;;;;;;;;; ligne18  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #14
db 67 : db #80
db 71 : db #06
db 74 : db #80
;;;;;;;;; ligne19  ;;;;;;;;;;;
db poke6/256 : db #c0
db 63 : db #38
db 66 : db #C0
db 67 : db #00
db 71 : db #02
db 73 : db #C0
db 74 : db #00
;;;;;;;;; ligne20  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #01
db 63 : db #70
db 72 : db #E0
db 73 : db #00
;;;;;;;;; ligne21  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #02
db 63 : db #F0
db 71 : db #01
db 72 : db #00
;;;;;;;;; ligne22  ;;;;;;;;;;;
db poke2/256 : db #c0
db 62 : db #14
db 71 : db #00
;;;;;;;;; ligne23  ;;;;;;;;;;;
db poke2/256 : db #c0
db 62 : db #34
db 66 : db #E0
;;;;;;;;; ligne24  ;;;;;;;;;;;
db poke2/256 : db #c0
db 62 : db #10
db 75 : db #06
;;;;;;;;; ligne25  ;;;;;;;;;;;
db poke3/256 : db #c0
db 74 : db #03
db 75 : db #10
db 76 : db #C0
;;;;;;;;; ligne26  ;;;;;;;;;;;
db poke6/256 : db #c0
db 62 : db #12
db 66 : db #F0
db 73 : db #01
db 74 : db #08
db 75 : db #F0
db 76 : db #E0
;;;;;;;;; ligne27  ;;;;;;;;;;;
db poke3/256 : db #c0
db 62 : db #02
db 73 : db #0C
db 74 : db #70
;;;;;;;;; ligne28  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #00
db 72 : db #06
db 73 : db #30
db 74 : db #F0
;;;;;;;;; ligne29  ;;;;;;;;;;;
db poke4/256 : db #c0
db 71 : db #03
db 72 : db #10
db 73 : db #F0
db 76 : db #F0
;;;;;;;;; ligne30  ;;;;;;;;;;;
db poke6/256 : db #c0
db 62 : db #01
db 63 : db #70
db 67 : db #80
db 70 : db #01
db 71 : db #08
db 72 : db #F0
;;;;;;;;; ligne31  ;;;;;;;;;;;
db poke3/256 : db #c0
db 62 : db #00
db 70 : db #0C
db 71 : db #70
;;;;;;;;; ligne32  ;;;;;;;;;;;
db poke3/256 : db #c0
db 69 : db #06
db 70 : db #30
db 71 : db #F0
;;;;;;;;; ligne33  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #38
db 67 : db #C0
db 69 : db #12
db 70 : db #F0
db 77 : db #80
;;;;;;;;; ligne34  ;;;;;;;;;;;
db poke2/256 : db #c0
db 63 : db #30
db 69 : db #02
;;;;;;;;; ligne35  ;;;;;;;;;;;
db poke2/256 : db #c0
db 72 : db #E0
db 73 : db #70
;;;;;;;;; ligne36  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #34
db 67 : db #E0
db 69 : db #03
db 72 : db #81
db 77 : db #C0
;;;;;;;;; ligne37  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #10
db 69 : db #01
db 70 : db #70
db 71 : db #C0
db 72 : db #01
;;;;;;;;; ligne38  ;;;;;;;;;;;
db poke3/256 : db #c0
db 70 : db #60
db 71 : db #00
db 73 : db #78
;;;;;;;;; ligne39  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #12
db 69 : db #00
db 70 : db #00
db 73 : db #38
;;;;;;;;; ligne40  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #02
db 67 : db #F0
db 72 : db #00
db 77 : db #E0
;;;;;;;;; ligne41  ;;;;;;;;;;;
db poke1/256 : db #c0
db 63 : db #00
;;;;;;;;; ligne42  ;;;;;;;;;;;
db poke1/256 : db #c0
db 73 : db #1C
;;;;;;;;; ligne43  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #01
db 64 : db #70
db 68 : db #80
db 73 : db #14
;;;;;;;;; ligne44  ;;;;;;;;;;;
db poke2/256 : db #c0
db 63 : db #00
db 77 : db #F0
;;;;;;;;; ligne45  ;;;;;;;;;;;
db poke1/256 : db #c0
db 73 : db #16
;;;;;;;;; ligne46  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #38
db 68 : db #C0
db 73 : db #02
db 77 : db #E0
;;;;;;;;; ligne47  ;;;;;;;;;;;
db poke2/256 : db #c0
db 64 : db #30
db 77 : db #C0
;;;;;;;;; ligne48  ;;;;;;;;;;;
db poke2/256 : db #c0
db 73 : db #0F
db 77 : db #80
;;;;;;;;; ligne49  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #34
db 72 : db #07
db 73 : db #18
db 77 : db #00
;;;;;;;;; ligne50  ;;;;;;;;;;;
db poke6/256 : db #c0
db 64 : db #10
db 68 : db #E0
db 71 : db #03
db 72 : db #0C
db 73 : db #F0
db 76 : db #C0
;;;;;;;;; ligne51  ;;;;;;;;;;;
db poke4/256 : db #c0
db 70 : db #01
db 71 : db #0E
db 72 : db #70
db 76 : db #80
;;;;;;;;; ligne52  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #12
db 70 : db #0F
db 71 : db #30
db 72 : db #F0
db 76 : db #00
;;;;;;;;; ligne53  ;;;;;;;;;;;
db poke6/256 : db #c0
db 64 : db #02
db 68 : db #F0
db 69 : db #07
db 70 : db #18
db 71 : db #F0
db 75 : db #E0
;;;;;;;;; ligne54  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #00
db 69 : db #0C
db 70 : db #F0
db 74 : db #E0
db 75 : db #00
;;;;;;;;; ligne55  ;;;;;;;;;;;
db poke2/256 : db #c0
db 69 : db #70
db 74 : db #00
;;;;;;;;; ligne56  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #01
db 65 : db #70
db 69 : db #F0
db 73 : db #80
;;;;;;;;; ligne57  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #00
db 72 : db #C0
db 73 : db #00
;;;;;;;;; ligne58  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #E0
db 72 : db #00
;;;;;;;;; ligne59  ;;;;;;;;;;;
db poke2/256 : db #c0
db 65 : db #38
db 71 : db #00
;;;;;;;;; ligne60  ;;;;;;;;;;;
db poke2/256 : db #c0
db 65 : db #30
db 70 : db #80
;;;;;;;;; ligne61  ;;;;;;;;;;;
db poke2/256 : db #c0
db 69 : db #C0
db 70 : db #00
;;;;;;;;; ligne62  ;;;;;;;;;;;
db poke4/256 : db #c0
db 65 : db #00
db 66 : db #10
db 68 : db #E0
db 69 : db #00
;;;;;;;;; ligne63  ;;;;;;;;;;;
db poke3/256 : db #c0
db 66 : db #00
db 67 : db #00
db 68 : db #00
;;;;;;;;; ligne64  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne65  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne66  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne67  ;;;;;;;;;;;
db poke3/256 : db #c0
db 71 : db #03
db 72 : db #0F
db 73 : db #0F
;;;;;;;;; ligne68  ;;;;;;;;;;;
db poke5/256 : db #c0
db 70 : db #01
db 71 : db #0F
db 72 : db #00
db 73 : db #01
db 74 : db #0F
;;;;;;;;; ligne69  ;;;;;;;;;;;
db poke5/256 : db #c0
db 70 : db #0F
db 71 : db #08
db 72 : db #F0
db 73 : db #F0
db 74 : db #80
;;;;;;;;; ligne70  ;;;;;;;;;;;
db poke5/256 : db #c0
db 69 : db #03
db 70 : db #0E
db 71 : db #70
db 74 : db #F0
db 75 : db #80
;;;;;;;;; ligne71  ;;;;;;;;;;;
db poke4/256 : db #c0
db 68 : db #01
db 69 : db #0F
db 70 : db #30
db 71 : db #F0
;;;;;;;;; ligne72  ;;;;;;;;;;;
db poke4/256 : db #c0
db 68 : db #0F
db 69 : db #18
db 70 : db #F0
db 75 : db #C0
;;;;;;;;; ligne73  ;;;;;;;;;;;
db poke3/256 : db #c0
db 67 : db #03
db 68 : db #0E
db 69 : db #70
;;;;;;;;; ligne74  ;;;;;;;;;;;
db poke4/256 : db #c0
db 66 : db #09
db 67 : db #0F
db 68 : db #30
db 69 : db #F0
;;;;;;;;; ligne75  ;;;;;;;;;;;
db poke4/256 : db #c0
db 65 : db #07
db 66 : db #0F
db 67 : db #0C
db 68 : db #F0
;;;;;;;;; ligne76  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #03
db 65 : db #0E
db 66 : db #02
db 67 : db #70
db 75 : db #E0
;;;;;;;;; ligne77  ;;;;;;;;;;;
db poke6/256 : db #c0
db 63 : db #03
db 64 : db #0F
db 65 : db #30
db 66 : db #D0
db 67 : db #F0
db 70 : db #E0
;;;;;;;;; ligne78  ;;;;;;;;;;;
db poke7/256 : db #c0
db 62 : db #01
db 63 : db #0F
db 64 : db #18
db 65 : db #F0
db 66 : db #F0
db 70 : db #81
db 71 : db #70
;;;;;;;;; ligne79  ;;;;;;;;;;;
db poke6/256 : db #c0
db 62 : db #0F
db 63 : db #0C
db 64 : db #F0
db 69 : db #C0
db 70 : db #01
db 75 : db #F0
;;;;;;;;; ligne80  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #0C
db 63 : db #70
db 68 : db #E0
db 69 : db #00
;;;;;;;;; ligne81  ;;;;;;;;;;;
db poke5/256 : db #c0
db 62 : db #38
db 63 : db #F0
db 68 : db #00
db 70 : db #00
db 71 : db #78
;;;;;;;;; ligne82  ;;;;;;;;;;;
db poke3/256 : db #c0
db 62 : db #70
db 67 : db #80
db 71 : db #38
;;;;;;;;; ligne83  ;;;;;;;;;;;
db poke3/256 : db #c0
db 62 : db #30
db 67 : db #00
db 76 : db #80
;;;;;;;;; ligne84  ;;;;;;;;;;;
db poke1/256 : db #c0
db 71 : db #30
;;;;;;;;; ligne85  ;;;;;;;;;;;
db poke1/256 : db #c0
db 71 : db #14
;;;;;;;;; ligne86  ;;;;;;;;;;;
db poke3/256 : db #c0
db 62 : db #10
db 67 : db #80
db 76 : db #C0
;;;;;;;;; ligne87  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne88  ;;;;;;;;;;;
db poke1/256 : db #c0
db 71 : db #12
;;;;;;;;; ligne89  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #00
db 67 : db #C0
db 71 : db #02
db 76 : db #E0
;;;;;;;;; ligne90  ;;;;;;;;;;;
db poke1/256 : db #c0
db 62 : db #10
;;;;;;;;; ligne91  ;;;;;;;;;;;
db poke2/256 : db #c0
db 62 : db #00
db 71 : db #01
;;;;;;;;; ligne92  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #70
db 67 : db #E0
db 72 : db #70
;;;;;;;;; ligne93  ;;;;;;;;;;;
db poke1/256 : db #c0
db 63 : db #F0
;;;;;;;;; ligne94  ;;;;;;;;;;;
db poke1/256 : db #c0
db 63 : db #70
;;;;;;;;; ligne95  ;;;;;;;;;;;
db poke4/256 : db #c0
db 67 : db #F0
db 71 : db #03
db 72 : db #38
db 76 : db #C0
;;;;;;;;; ligne96  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #30
db 71 : db #07
db 76 : db #80
;;;;;;;;; ligne97  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #0F
db 72 : db #70
;;;;;;;;; ligne98  ;;;;;;;;;;;
db poke4/256 : db #c0
db 70 : db #01
db 71 : db #0E
db 72 : db #F0
db 76 : db #00
;;;;;;;;; ligne99  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #10
db 68 : db #80
db 70 : db #0F
db 71 : db #1C
;;;;;;;;; ligne100  ;;;;;;;;;;;
db poke3/256 : db #c0
db 69 : db #0F
db 71 : db #38
db 75 : db #E0
;;;;;;;;; ligne101  ;;;;;;;;;;;
db poke4/256 : db #c0
db 68 : db #83
db 70 : db #08
db 71 : db #F0
db 75 : db #C0
;;;;;;;;; ligne102  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #00
db 69 : db #0C
db 70 : db #70
db 75 : db #00
;;;;;;;;; ligne103  ;;;;;;;;;;;
db poke4/256 : db #c0
db 68 : db #C2
db 69 : db #70
db 70 : db #F0
db 74 : db #80
;;;;;;;;; ligne104  ;;;;;;;;;;;
db poke4/256 : db #c0
db 68 : db #F0
db 69 : db #F0
db 73 : db #E0
db 74 : db #00
;;;;;;;;; ligne105  ;;;;;;;;;;;
db poke2/256 : db #c0
db 64 : db #70
db 73 : db #00
;;;;;;;;; ligne106  ;;;;;;;;;;;
db poke1/256 : db #c0
db 72 : db #80
;;;;;;;;; ligne107  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #C0
db 72 : db #00
;;;;;;;;; ligne108  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #30
db 70 : db #E0
db 71 : db #00
;;;;;;;;; ligne109  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #70
db 69 : db #E0
db 70 : db #00
;;;;;;;;; ligne110  ;;;;;;;;;;;
db poke2/256 : db #c0
db 64 : db #30
db 69 : db #00
;;;;;;;;; ligne111  ;;;;;;;;;;;
db poke1/256 : db #c0
db 64 : db #10
;;;;;;;;; ligne112  ;;;;;;;;;;;
db poke2/256 : db #c0
db 64 : db #30
db 69 : db #80
;;;;;;;;; ligne113  ;;;;;;;;;;;
db poke1/256 : db #c0
db 64 : db #10
;;;;;;;;; ligne114  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne115  ;;;;;;;;;;;
db poke2/256 : db #c0
db 64 : db #00
db 69 : db #C0
;;;;;;;;; ligne116  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne117  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne118  ;;;;;;;;;;;
db poke2/256 : db #c0
db 65 : db #70
db 69 : db #E0
;;;;;;;;; ligne119  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne120  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne121  ;;;;;;;;;;;
db poke2/256 : db #c0
db 65 : db #30
db 69 : db #F0
;;;;;;;;; ligne122  ;;;;;;;;;;;
db poke1/256 : db #c0
db 69 : db #E0
;;;;;;;;; ligne123  ;;;;;;;;;;;
db poke1/256 : db #c0
db 69 : db #80
;;;;;;;;; ligne124  ;;;;;;;;;;;
db poke3/256 : db #c0
db 65 : db #10
db 68 : db #80
db 69 : db #00
;;;;;;;;; ligne125  ;;;;;;;;;;;
db poke2/256 : db #c0
db 67 : db #C0
db 68 : db #00
;;;;;;;;; ligne126  ;;;;;;;;;;;
db poke2/256 : db #c0
db 66 : db #C0
db 67 : db #00
;;;;;;;;; ligne127  ;;;;;;;;;;;
db poke2/256 : db #c0
db 65 : db #00
db 66 : db #00
;;;;;;;;; ligne128  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne129  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne130  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne131  ;;;;;;;;;;;
db poke2/256 : db #c0
db 71 : db #01
db 72 : db #08
;;;;;;;;; ligne132  ;;;;;;;;;;;
db poke4/256 : db #c0
db 70 : db #01
db 71 : db #0F
db 72 : db #0F
db 73 : db #08
;;;;;;;;; ligne133  ;;;;;;;;;;;
db poke3/256 : db #c0
db 70 : db #0F
db 73 : db #0F
db 74 : db #08
;;;;;;;;; ligne134  ;;;;;;;;;;;
db poke3/256 : db #c0
db 69 : db #0F
db 72 : db #03
db 74 : db #0E
;;;;;;;;; ligne135  ;;;;;;;;;;;
db poke5/256 : db #c0
db 68 : db #07
db 71 : db #08
db 72 : db #F0
db 73 : db #03
db 74 : db #0F
;;;;;;;;; ligne136  ;;;;;;;;;;;
db poke7/256 : db #c0
db 67 : db #07
db 68 : db #0F
db 70 : db #08
db 71 : db #F0
db 73 : db #F0
db 74 : db #03
db 75 : db #08
;;;;;;;;; ligne137  ;;;;;;;;;;;
db poke6/256 : db #c0
db 66 : db #03
db 67 : db #0F
db 69 : db #0C
db 70 : db #F0
db 74 : db #F0
db 75 : db #00
;;;;;;;;; ligne138  ;;;;;;;;;;;
db poke5/256 : db #c0
db 65 : db #03
db 66 : db #0F
db 68 : db #0C
db 69 : db #70
db 75 : db #C0
;;;;;;;;; ligne139  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #03
db 65 : db #0F
db 67 : db #0C
db 68 : db #70
db 69 : db #F0
;;;;;;;;; ligne140  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #07
db 66 : db #0E
db 67 : db #30
db 68 : db #F0
;;;;;;;;; ligne141  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #0F
db 65 : db #0E
db 66 : db #30
db 67 : db #F0
;;;;;;;;; ligne142  ;;;;;;;;;;;
db poke4/256 : db #c0
db 63 : db #01
db 65 : db #10
db 66 : db #F0
db 75 : db #E0
;;;;;;;;; ligne143  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #03
db 64 : db #1C
db 65 : db #F0
;;;;;;;;; ligne144  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #07
db 64 : db #38
db 71 : db #70
;;;;;;;;; ligne145  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #0F
db 64 : db #70
db 70 : db #80
db 71 : db #78
db 75 : db #F0
;;;;;;;;; ligne146  ;;;;;;;;;;;
db poke5/256 : db #c0
db 62 : db #01
db 64 : db #F0
db 69 : db #80
db 70 : db #00
db 71 : db #30
;;;;;;;;; ligne147  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #03
db 63 : db #0E
db 68 : db #80
db 69 : db #00
;;;;;;;;; ligne148  ;;;;;;;;;;;
db poke6/256 : db #c0
db 62 : db #01
db 63 : db #1C
db 67 : db #C0
db 68 : db #00
db 71 : db #34
db 76 : db #80
;;;;;;;;; ligne149  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #38
db 67 : db #00
db 71 : db #10
;;;;;;;;; ligne150  ;;;;;;;;;;;
db poke1/256 : db #c0
db 63 : db #70
;;;;;;;;; ligne151  ;;;;;;;;;;;
db poke4/256 : db #c0
db 62 : db #00
db 63 : db #F0
db 67 : db #80
db 71 : db #16
;;;;;;;;; ligne152  ;;;;;;;;;;;
db poke3/256 : db #c0
db 70 : db #07
db 71 : db #0E
db 76 : db #C0
;;;;;;;;; ligne153  ;;;;;;;;;;;
db poke2/256 : db #c0
db 69 : db #03
db 70 : db #0F
;;;;;;;;; ligne154  ;;;;;;;;;;;
db poke2/256 : db #c0
db 68 : db #03
db 69 : db #0F
;;;;;;;;; ligne155  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #70
db 67 : db #83
db 68 : db #0F
db 71 : db #10
db 76 : db #E0
;;;;;;;;; ligne156  ;;;;;;;;;;;
db poke4/256 : db #c0
db 66 : db #80
db 67 : db #0F
db 70 : db #08
db 71 : db #F0
;;;;;;;;; ligne157  ;;;;;;;;;;;
db poke4/256 : db #c0
db 65 : db #C0
db 66 : db #0F
db 69 : db #08
db 70 : db #F0
;;;;;;;;; ligne158  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #30
db 64 : db #E0
db 65 : db #03
db 68 : db #08
db 69 : db #F0
;;;;;;;;; ligne159  ;;;;;;;;;;;
db poke6/256 : db #c0
db 63 : db #20
db 64 : db #00
db 65 : db #07
db 67 : db #0C
db 68 : db #70
db 76 : db #F0
;;;;;;;;; ligne160  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #00
db 65 : db #0F
db 66 : db #0C
db 67 : db #70
db 68 : db #F0
;;;;;;;;; ligne161  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #01
db 66 : db #70
db 67 : db #F0
;;;;;;;;; ligne162  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #03
db 65 : db #0E
db 66 : db #F0
db 72 : db #10
db 77 : db #80
;;;;;;;;; ligne163  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #07
db 65 : db #1C
db 71 : db #00
;;;;;;;;; ligne164  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #0F
db 65 : db #38
db 70 : db #00
db 72 : db #12
;;;;;;;;; ligne165  ;;;;;;;;;;;
db poke5/256 : db #c0
db 63 : db #01
db 65 : db #70
db 69 : db #80
db 72 : db #02
db 77 : db #C0
;;;;;;;;; ligne166  ;;;;;;;;;;;
db poke5/256 : db #c0
db 64 : db #0E
db 65 : db #F0
db 68 : db #80
db 69 : db #00
db 72 : db #00
;;;;;;;;; ligne167  ;;;;;;;;;;;
db poke3/256 : db #c0
db 63 : db #00
db 64 : db #1C
db 68 : db #C0
;;;;;;;;; ligne168  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #38
db 72 : db #01
db 73 : db #70
;;;;;;;;; ligne169  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #70
db 72 : db #00
db 77 : db #E0
;;;;;;;;; ligne170  ;;;;;;;;;;;
db poke2/256 : db #c0
db 68 : db #E0
db 72 : db #07
;;;;;;;;; ligne171  ;;;;;;;;;;;
db poke3/256 : db #c0
db 71 : db #03
db 72 : db #0F
db 73 : db #78
;;;;;;;;; ligne172  ;;;;;;;;;;;
db poke4/256 : db #c0
db 70 : db #03
db 71 : db #0F
db 73 : db #38
db 77 : db #F0
;;;;;;;;; ligne173  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #30
db 69 : db #01
db 70 : db #0F
;;;;;;;;; ligne174  ;;;;;;;;;;;
db poke3/256 : db #c0
db 69 : db #0F
db 72 : db #0E
db 73 : db #30
;;;;;;;;; ligne175  ;;;;;;;;;;;
db poke6/256 : db #c0
db 68 : db #F0
db 69 : db #07
db 71 : db #0E
db 72 : db #30
db 73 : db #F0
db 78 : db #80
;;;;;;;;; ligne176  ;;;;;;;;;;;
db poke3/256 : db #c0
db 64 : db #10
db 71 : db #10
db 72 : db #F0
;;;;;;;;; ligne177  ;;;;;;;;;;;
db poke2/256 : db #c0
db 70 : db #10
db 71 : db #F0
;;;;;;;;; ligne178  ;;;;;;;;;;;
db poke4/256 : db #c0
db 69 : db #90
db 70 : db #F0
db 77 : db #C0
db 78 : db #00
;;;;;;;;; ligne179  ;;;;;;;;;;;
db poke4/256 : db #c0
db 64 : db #00
db 69 : db #F0
db 76 : db #C0
db 77 : db #00
;;;;;;;;; ligne180  ;;;;;;;;;;;
db poke3/256 : db #c0
db 73 : db #E0
db 75 : db #C0
db 76 : db #00
;;;;;;;;; ligne181  ;;;;;;;;;;;
db poke3/256 : db #c0
db 73 : db #80
db 74 : db #C0
db 75 : db #00
;;;;;;;;; ligne182  ;;;;;;;;;;;
db poke3/256 : db #c0
db 72 : db #C0
db 73 : db #00
db 74 : db #00
;;;;;;;;; ligne183  ;;;;;;;;;;;
db poke3/256 : db #c0
db 65 : db #70
db 71 : db #E0
db 72 : db #00
;;;;;;;;; ligne184  ;;;;;;;;;;;
db poke1/256 : db #c0
db 71 : db #80
;;;;;;;;; ligne185  ;;;;;;;;;;;
db poke3/256 : db #c0
db 65 : db #10
db 70 : db #80
db 71 : db #00
;;;;;;;;; ligne186  ;;;;;;;;;;;
db poke4/256 : db #c0
db 65 : db #00
db 66 : db #10
db 69 : db #C0
db 70 : db #00
;;;;;;;;; ligne187  ;;;;;;;;;;;
db poke4/256 : db #c0
db 66 : db #00
db 67 : db #30
db 68 : db #E0
db 69 : db #00
;;;;;;;;; ligne188  ;;;;;;;;;;;
db poke2/256 : db #c0
db 67 : db #00
db 68 : db #00
;;;;;;;;; ligne189  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne190  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne191  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne192  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne193  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne194  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne195  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne196  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne197  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne198  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;; ligne199  ;;;;;;;;;;;
db w64/256 : db #c0
;;;;;;;;;;;; fini ;;;;;;;;;;;;
db #00
;;;;;;;;;;;; fin frame ;;;;;;;;;;;;
frame1_fin




    frame0001
    ;;;;;;;;; ligne0  ;;;;;;;;;;;
    ld (stack_save),sp
    ld sp,stack_context
    call waste-55 
    ;;;;;;;;; ligne1  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne2  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne3  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne4  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+71),a
    ld a,#70
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne5  ;;;;;;;;;;;
    ld a,#18
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#F0
    ld (#C000+74),a
    call waste-40
    ;;;;;;;;; ligne6  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+71),a
    ld a,#80
    ld (#C000+75),a
    call waste-52
    ;;;;;;;;; ligne7  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+70),a
    call waste-58
    ;;;;;;;;; ligne8  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#C0
    ld (#C000+75),a
    call waste-46
    ;;;;;;;;; ligne9  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+69),a
    call waste-58
    ;;;;;;;;; ligne10  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+67),a
    ld a,#70
    ld (#C000+68),a
    call waste-52
    ;;;;;;;;; ligne11  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+66),a
    ld a,#30
    ld (#C000+67),a
    ld a,#F0
    ld (#C000+68),a
    ld a,#E0
    ld (#C000+75),a
    call waste-40
    ;;;;;;;;; ligne12  ;;;;;;;;;;;
    ld a,#18
    ld (#C000+66),a
    ld a,#F0
    ld (#C000+67),a
    ld a,#B0
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne13  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+66),a
    ld a,#E0
    ld (#C000+70),a
    ld a,#38
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne14  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+65),a
    ld a,#00
    ld (#C000+70),a
    ld a,#1C
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne15  ;;;;;;;;;;;
    ld a,#18
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+65),a
    ld a,#80
    ld (#C000+69),a
    ld a,#14
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne16  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+63),a
    ld a,#70
    ld (#C000+64),a
    ld a,#E0
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    ld a,#C0
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne17  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+63),a
    ld a,#F0
    ld (#C000+64),a
    ld a,#00
    ld (#C000+68),a
    ld a,#16
    ld (#C000+71),a
    ld a,#00
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne18  ;;;;;;;;;;;
    ld a,#14
    ld (#C000+63),a
    ld a,#80
    ld (#C000+67),a
    ld a,#06
    ld (#C000+71),a
    ld a,#80
    ld (#C000+74),a
    call waste-40
    ;;;;;;;;; ligne19  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+63),a
    ld a,#C0
    ld (#C000+66),a
    ld a,#00
    ld (#C000+67),a
    ld a,#02
    ld (#C000+71),a
    ld a,#C0
    ld (#C000+73),a
    ld a,#00
    ld (#C000+74),a
    call waste-28
    ;;;;;;;;; ligne20  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+62),a
    ld a,#70
    ld (#C000+63),a
    ld a,#E0
    ld (#C000+72),a
    ld a,#00
    ld (#C000+73),a
    call waste-40
    ;;;;;;;;; ligne21  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+62),a
    ld a,#F0
    ld (#C000+63),a
    ld a,#01
    ld (#C000+71),a
    ld a,#00
    ld (#C000+72),a
    call waste-40
    ;;;;;;;;; ligne22  ;;;;;;;;;;;
    ld a,#14
    ld (#C000+62),a
    ld a,#00
    ld (#C000+71),a
    call waste-52
    ;;;;;;;;; ligne23  ;;;;;;;;;;;
    ld a,#34
    ld (#C000+62),a
    ld a,#E0
    ld (#C000+66),a
    call waste-52
    ;;;;;;;;; ligne24  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+62),a
    ld a,#06
    ld (#C000+75),a
    call waste-52
    ;;;;;;;;; ligne25  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+74),a
    ld a,#10
    ld (#C000+75),a
    ld a,#C0
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne26  ;;;;;;;;;;;
    ld a,#12
    ld (#C000+62),a
    ld a,#F0
    ld (#C000+66),a
    ld a,#01
    ld (#C000+73),a
    ld a,#08
    ld (#C000+74),a
    ld a,#F0
    ld (#C000+75),a
    ld a,#E0
    ld (#C000+76),a
    call waste-28
    ;;;;;;;;; ligne27  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+62),a
    ld a,#0C
    ld (#C000+73),a
    ld a,#70
    ld (#C000+74),a
    call waste-46
    ;;;;;;;;; ligne28  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+62),a
    ld a,#06
    ld (#C000+72),a
    ld a,#30
    ld (#C000+73),a
    ld a,#F0
    ld (#C000+74),a
    call waste-40
    ;;;;;;;;; ligne29  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+71),a
    ld a,#10
    ld (#C000+72),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#F0
    ld (#C000+76),a
    call waste-40
    ;;;;;;;;; ligne30  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+62),a
    ld a,#70
    ld (#C000+63),a
    ld a,#80
    ld (#C000+67),a
    ld a,#01
    ld (#C000+70),a
    ld a,#08
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    call waste-28
    ;;;;;;;;; ligne31  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+62),a
    ld a,#0C
    ld (#C000+70),a
    ld a,#70
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne32  ;;;;;;;;;;;
    ld a,#06
    ld (#C000+69),a
    ld a,#30
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne33  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+63),a
    ld a,#C0
    ld (#C000+67),a
    ld a,#12
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#80
    ld (#C000+77),a
    call waste-34
    ;;;;;;;;; ligne34  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+63),a
    ld a,#02
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne35  ;;;;;;;;;;;
    ld a,#E0
    ld (#C000+72),a
    ld a,#70
    ld (#C000+73),a
    call waste-52
    ;;;;;;;;; ligne36  ;;;;;;;;;;;
    ld a,#34
    ld (#C000+63),a
    ld a,#E0
    ld (#C000+67),a
    ld a,#03
    ld (#C000+69),a
    ld a,#81
    ld (#C000+72),a
    ld a,#C0
    ld (#C000+77),a
    call waste-34
    ;;;;;;;;; ligne37  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+63),a
    ld a,#01
    ld (#C000+69),a
    ld a,#70
    ld (#C000+70),a
    ld a,#C0
    ld (#C000+71),a
    ld a,#01
    ld (#C000+72),a
    call waste-34
    ;;;;;;;;; ligne38  ;;;;;;;;;;;
    ld a,#60
    ld (#C000+70),a
    ld a,#00
    ld (#C000+71),a
    ld a,#78
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne39  ;;;;;;;;;;;
    ld a,#12
    ld (#C000+63),a
    ld a,#00
    ld (#C000+69),a
    ld a,#00
    ld (#C000+70),a
    ld a,#38
    ld (#C000+73),a
    call waste-40
    ;;;;;;;;; ligne40  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+63),a
    ld a,#F0
    ld (#C000+67),a
    ld a,#00
    ld (#C000+72),a
    ld a,#E0
    ld (#C000+77),a
    call waste-40
    ;;;;;;;;; ligne41  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+63),a
    call waste-58
    ;;;;;;;;; ligne42  ;;;;;;;;;;;
    ld a,#1C
    ld (#C000+73),a
    call waste-58
    ;;;;;;;;; ligne43  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+63),a
    ld a,#70
    ld (#C000+64),a
    ld a,#80
    ld (#C000+68),a
    ld a,#14
    ld (#C000+73),a
    call waste-40
    ;;;;;;;;; ligne44  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+63),a
    ld a,#F0
    ld (#C000+77),a
    call waste-52
    ;;;;;;;;; ligne45  ;;;;;;;;;;;
    ld a,#16
    ld (#C000+73),a
    call waste-58
    ;;;;;;;;; ligne46  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+68),a
    ld a,#02
    ld (#C000+73),a
    ld a,#E0
    ld (#C000+77),a
    call waste-40
    ;;;;;;;;; ligne47  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+77),a
    call waste-52
    ;;;;;;;;; ligne48  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+73),a
    ld a,#80
    ld (#C000+77),a
    call waste-52
    ;;;;;;;;; ligne49  ;;;;;;;;;;;
    ld a,#34
    ld (#C000+64),a
    ld a,#07
    ld (#C000+72),a
    ld a,#18
    ld (#C000+73),a
    ld a,#00
    ld (#C000+77),a
    call waste-40
    ;;;;;;;;; ligne50  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+64),a
    ld a,#E0
    ld (#C000+68),a
    ld a,#03
    ld (#C000+71),a
    ld a,#0C
    ld (#C000+72),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#C0
    ld (#C000+76),a
    call waste-28
    ;;;;;;;;; ligne51  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+70),a
    ld a,#0E
    ld (#C000+71),a
    ld a,#70
    ld (#C000+72),a
    ld a,#80
    ld (#C000+76),a
    call waste-40
    ;;;;;;;;; ligne52  ;;;;;;;;;;;
    ld a,#12
    ld (#C000+64),a
    ld a,#0F
    ld (#C000+70),a
    ld a,#30
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    ld a,#00
    ld (#C000+76),a
    call waste-34
    ;;;;;;;;; ligne53  ;;;;;;;;;;;
    ld a,#02
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+68),a
    ld a,#07
    ld (#C000+69),a
    ld a,#18
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    ld a,#E0
    ld (#C000+75),a
    call waste-28
    ;;;;;;;;; ligne54  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+64),a
    ld a,#0C
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#E0
    ld (#C000+74),a
    ld a,#00
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne55  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+69),a
    ld a,#00
    ld (#C000+74),a
    call waste-52
    ;;;;;;;;; ligne56  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+64),a
    ld a,#70
    ld (#C000+65),a
    ld a,#F0
    ld (#C000+69),a
    ld a,#80
    ld (#C000+73),a
    call waste-40
    ;;;;;;;;; ligne57  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+72),a
    ld a,#00
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne58  ;;;;;;;;;;;
    ld a,#E0
    ld (#C000+71),a
    ld a,#00
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne59  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+65),a
    ld a,#00
    ld (#C000+71),a
    call waste-52
    ;;;;;;;;; ligne60  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+65),a
    ld a,#80
    ld (#C000+70),a
    call waste-52
    ;;;;;;;;; ligne61  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+69),a
    ld a,#00
    ld (#C000+70),a
    call waste-52
    ;;;;;;;;; ligne62  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+65),a
    ld a,#10
    ld (#C000+66),a
    ld a,#E0
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    call waste-40
    ;;;;;;;;; ligne63  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+66),a
    ld a,#00
    ld (#C000+67),a
    ld a,#00
    ld (#C000+68),a
    call waste-46
    ;;;;;;;;; ligne64  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne65  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne66  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne67  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+71),a
    ld a,#0F
    ld (#C000+72),a
    ld a,#0F
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne68  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+70),a
    ld a,#0F
    ld (#C000+71),a
    ld a,#00
    ld (#C000+72),a
    ld a,#01
    ld (#C000+73),a
    ld a,#0F
    ld (#C000+74),a
    call waste-34
    ;;;;;;;;; ligne69  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+70),a
    ld a,#08
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#80
    ld (#C000+74),a
    call waste-34
    ;;;;;;;;; ligne70  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+69),a
    ld a,#0E
    ld (#C000+70),a
    ld a,#70
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+74),a
    ld a,#80
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne71  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+68),a
    ld a,#0F
    ld (#C000+69),a
    ld a,#30
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    call waste-40
    ;;;;;;;;; ligne72  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+68),a
    ld a,#18
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#C0
    ld (#C000+75),a
    call waste-40
    ;;;;;;;;; ligne73  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+67),a
    ld a,#0E
    ld (#C000+68),a
    ld a,#70
    ld (#C000+69),a
    call waste-46
    ;;;;;;;;; ligne74  ;;;;;;;;;;;
    ld a,#09
    ld (#C000+66),a
    ld a,#0F
    ld (#C000+67),a
    ld a,#30
    ld (#C000+68),a
    ld a,#F0
    ld (#C000+69),a
    call waste-40
    ;;;;;;;;; ligne75  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+65),a
    ld a,#0F
    ld (#C000+66),a
    ld a,#0C
    ld (#C000+67),a
    ld a,#F0
    ld (#C000+68),a
    call waste-40
    ;;;;;;;;; ligne76  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+64),a
    ld a,#0E
    ld (#C000+65),a
    ld a,#02
    ld (#C000+66),a
    ld a,#70
    ld (#C000+67),a
    ld a,#E0
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne77  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+63),a
    ld a,#0F
    ld (#C000+64),a
    ld a,#30
    ld (#C000+65),a
    ld a,#D0
    ld (#C000+66),a
    ld a,#F0
    ld (#C000+67),a
    ld a,#E0
    ld (#C000+70),a
    call waste-28
    ;;;;;;;;; ligne78  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+62),a
    ld a,#0F
    ld (#C000+63),a
    ld a,#18
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+65),a
    ld a,#F0
    ld (#C000+66),a
    ld a,#81
    ld (#C000+70),a
    ld a,#70
    ld (#C000+71),a
    call waste-22
    ;;;;;;;;; ligne79  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+62),a
    ld a,#0C
    ld (#C000+63),a
    ld a,#F0
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+69),a
    ld a,#01
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+75),a
    call waste-28
    ;;;;;;;;; ligne80  ;;;;;;;;;;;
    ld a,#0C
    ld (#C000+62),a
    ld a,#70
    ld (#C000+63),a
    ld a,#E0
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    call waste-40
    ;;;;;;;;; ligne81  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+62),a
    ld a,#F0
    ld (#C000+63),a
    ld a,#00
    ld (#C000+68),a
    ld a,#00
    ld (#C000+70),a
    ld a,#78
    ld (#C000+71),a
    call waste-34
    ;;;;;;;;; ligne82  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+62),a
    ld a,#80
    ld (#C000+67),a
    ld a,#38
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne83  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+62),a
    ld a,#00
    ld (#C000+67),a
    ld a,#80
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne84  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+71),a
    call waste-58
    ;;;;;;;;; ligne85  ;;;;;;;;;;;
    ld a,#14
    ld (#C000+71),a
    call waste-58
    ;;;;;;;;; ligne86  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+62),a
    ld a,#80
    ld (#C000+67),a
    ld a,#C0
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne87  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne88  ;;;;;;;;;;;
    ld a,#12
    ld (#C000+71),a
    call waste-58
    ;;;;;;;;; ligne89  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+62),a
    ld a,#C0
    ld (#C000+67),a
    ld a,#02
    ld (#C000+71),a
    ld a,#E0
    ld (#C000+76),a
    call waste-40
    ;;;;;;;;; ligne90  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+62),a
    call waste-58
    ;;;;;;;;; ligne91  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+62),a
    ld a,#01
    ld (#C000+71),a
    call waste-52
    ;;;;;;;;; ligne92  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+63),a
    ld a,#E0
    ld (#C000+67),a
    ld a,#70
    ld (#C000+72),a
    call waste-46
    ;;;;;;;;; ligne93  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+63),a
    call waste-58
    ;;;;;;;;; ligne94  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+63),a
    call waste-58
    ;;;;;;;;; ligne95  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+67),a
    ld a,#03
    ld (#C000+71),a
    ld a,#38
    ld (#C000+72),a
    ld a,#C0
    ld (#C000+76),a
    call waste-40
    ;;;;;;;;; ligne96  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+63),a
    ld a,#07
    ld (#C000+71),a
    ld a,#80
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne97  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+71),a
    ld a,#70
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne98  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+70),a
    ld a,#0E
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    ld a,#00
    ld (#C000+76),a
    call waste-40
    ;;;;;;;;; ligne99  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+63),a
    ld a,#80
    ld (#C000+68),a
    ld a,#0F
    ld (#C000+70),a
    ld a,#1C
    ld (#C000+71),a
    call waste-40
    ;;;;;;;;; ligne100  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+69),a
    ld a,#38
    ld (#C000+71),a
    ld a,#E0
    ld (#C000+75),a
    call waste-46
    ;;;;;;;;; ligne101  ;;;;;;;;;;;
    ld a,#83
    ld (#C000+68),a
    ld a,#08
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    ld a,#C0
    ld (#C000+75),a
    call waste-40
    ;;;;;;;;; ligne102  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+63),a
    ld a,#0C
    ld (#C000+69),a
    ld a,#70
    ld (#C000+70),a
    ld a,#00
    ld (#C000+75),a
    call waste-40
    ;;;;;;;;; ligne103  ;;;;;;;;;;;
    ld a,#C2
    ld (#C000+68),a
    ld a,#70
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#80
    ld (#C000+74),a
    call waste-40
    ;;;;;;;;; ligne104  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+68),a
    ld a,#F0
    ld (#C000+69),a
    ld a,#E0
    ld (#C000+73),a
    ld a,#00
    ld (#C000+74),a
    call waste-40
    ;;;;;;;;; ligne105  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+64),a
    ld a,#00
    ld (#C000+73),a
    call waste-52
    ;;;;;;;;; ligne106  ;;;;;;;;;;;
    ld a,#80
    ld (#C000+72),a
    call waste-58
    ;;;;;;;;; ligne107  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+71),a
    ld a,#00
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne108  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+64),a
    ld a,#E0
    ld (#C000+70),a
    ld a,#00
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne109  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+64),a
    ld a,#E0
    ld (#C000+69),a
    ld a,#00
    ld (#C000+70),a
    call waste-46
    ;;;;;;;;; ligne110  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+64),a
    ld a,#00
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne111  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+64),a
    call waste-58
    ;;;;;;;;; ligne112  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+64),a
    ld a,#80
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne113  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+64),a
    call waste-58
    ;;;;;;;;; ligne114  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne115  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne116  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne117  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne118  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+65),a
    ld a,#E0
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne119  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne120  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne121  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+65),a
    ld a,#F0
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne122  ;;;;;;;;;;;
    ld a,#E0
    ld (#C000+69),a
    call waste-58
    ;;;;;;;;; ligne123  ;;;;;;;;;;;
    ld a,#80
    ld (#C000+69),a
    call waste-58
    ;;;;;;;;; ligne124  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+65),a
    ld a,#80
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    call waste-46
    ;;;;;;;;; ligne125  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+67),a
    ld a,#00
    ld (#C000+68),a
    call waste-52
    ;;;;;;;;; ligne126  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+66),a
    ld a,#00
    ld (#C000+67),a
    call waste-52
    ;;;;;;;;; ligne127  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+65),a
    ld a,#00
    ld (#C000+66),a
    call waste-52
    ;;;;;;;;; ligne128  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne129  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne130  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne131  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+71),a
    ld a,#08
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne132  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+70),a
    ld a,#0F
    ld (#C000+71),a
    ld a,#0F
    ld (#C000+72),a
    ld a,#08
    ld (#C000+73),a
    call waste-40
    ;;;;;;;;; ligne133  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+70),a
    ld a,#0F
    ld (#C000+73),a
    ld a,#08
    ld (#C000+74),a
    call waste-46
    ;;;;;;;;; ligne134  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+69),a
    ld a,#03
    ld (#C000+72),a
    ld a,#0E
    ld (#C000+74),a
    call waste-46
    ;;;;;;;;; ligne135  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+68),a
    ld a,#08
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    ld a,#03
    ld (#C000+73),a
    ld a,#0F
    ld (#C000+74),a
    call waste-34
    ;;;;;;;;; ligne136  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+67),a
    ld a,#0F
    ld (#C000+68),a
    ld a,#08
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#03
    ld (#C000+74),a
    ld a,#08
    ld (#C000+75),a
    call waste-22
    ;;;;;;;;; ligne137  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+66),a
    ld a,#0F
    ld (#C000+67),a
    ld a,#0C
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+74),a
    ld a,#00
    ld (#C000+75),a
    call waste-28
    ;;;;;;;;; ligne138  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+65),a
    ld a,#0F
    ld (#C000+66),a
    ld a,#0C
    ld (#C000+68),a
    ld a,#70
    ld (#C000+69),a
    ld a,#C0
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne139  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+64),a
    ld a,#0F
    ld (#C000+65),a
    ld a,#0C
    ld (#C000+67),a
    ld a,#70
    ld (#C000+68),a
    ld a,#F0
    ld (#C000+69),a
    call waste-34
    ;;;;;;;;; ligne140  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+64),a
    ld a,#0E
    ld (#C000+66),a
    ld a,#30
    ld (#C000+67),a
    ld a,#F0
    ld (#C000+68),a
    call waste-40
    ;;;;;;;;; ligne141  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+64),a
    ld a,#0E
    ld (#C000+65),a
    ld a,#30
    ld (#C000+66),a
    ld a,#F0
    ld (#C000+67),a
    call waste-40
    ;;;;;;;;; ligne142  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+63),a
    ld a,#10
    ld (#C000+65),a
    ld a,#F0
    ld (#C000+66),a
    ld a,#E0
    ld (#C000+75),a
    call waste-40
    ;;;;;;;;; ligne143  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+63),a
    ld a,#1C
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+65),a
    call waste-46
    ;;;;;;;;; ligne144  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+63),a
    ld a,#38
    ld (#C000+64),a
    ld a,#70
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne145  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+63),a
    ld a,#70
    ld (#C000+64),a
    ld a,#80
    ld (#C000+70),a
    ld a,#78
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+75),a
    call waste-34
    ;;;;;;;;; ligne146  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+62),a
    ld a,#F0
    ld (#C000+64),a
    ld a,#80
    ld (#C000+69),a
    ld a,#00
    ld (#C000+70),a
    ld a,#30
    ld (#C000+71),a
    call waste-34
    ;;;;;;;;; ligne147  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+62),a
    ld a,#0E
    ld (#C000+63),a
    ld a,#80
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    call waste-40
    ;;;;;;;;; ligne148  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+62),a
    ld a,#1C
    ld (#C000+63),a
    ld a,#C0
    ld (#C000+67),a
    ld a,#00
    ld (#C000+68),a
    ld a,#34
    ld (#C000+71),a
    ld a,#80
    ld (#C000+76),a
    call waste-28
    ;;;;;;;;; ligne149  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+63),a
    ld a,#00
    ld (#C000+67),a
    ld a,#10
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne150  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+63),a
    call waste-58
    ;;;;;;;;; ligne151  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+62),a
    ld a,#F0
    ld (#C000+63),a
    ld a,#80
    ld (#C000+67),a
    ld a,#16
    ld (#C000+71),a
    call waste-40
    ;;;;;;;;; ligne152  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+70),a
    ld a,#0E
    ld (#C000+71),a
    ld a,#C0
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne153  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+69),a
    ld a,#0F
    ld (#C000+70),a
    call waste-52
    ;;;;;;;;; ligne154  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+68),a
    ld a,#0F
    ld (#C000+69),a
    call waste-52
    ;;;;;;;;; ligne155  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+63),a
    ld a,#83
    ld (#C000+67),a
    ld a,#0F
    ld (#C000+68),a
    ld a,#10
    ld (#C000+71),a
    ld a,#E0
    ld (#C000+76),a
    call waste-34
    ;;;;;;;;; ligne156  ;;;;;;;;;;;
    ld a,#80
    ld (#C000+66),a
    ld a,#0F
    ld (#C000+67),a
    ld a,#08
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    call waste-40
    ;;;;;;;;; ligne157  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+65),a
    ld a,#0F
    ld (#C000+66),a
    ld a,#08
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    call waste-40
    ;;;;;;;;; ligne158  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+63),a
    ld a,#E0
    ld (#C000+64),a
    ld a,#03
    ld (#C000+65),a
    ld a,#08
    ld (#C000+68),a
    ld a,#F0
    ld (#C000+69),a
    call waste-34
    ;;;;;;;;; ligne159  ;;;;;;;;;;;
    ld a,#20
    ld (#C000+63),a
    ld a,#00
    ld (#C000+64),a
    ld a,#07
    ld (#C000+65),a
    ld a,#0C
    ld (#C000+67),a
    ld a,#70
    ld (#C000+68),a
    ld a,#F0
    ld (#C000+76),a
    call waste-28
    ;;;;;;;;; ligne160  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+63),a
    ld a,#0F
    ld (#C000+65),a
    ld a,#0C
    ld (#C000+66),a
    ld a,#70
    ld (#C000+67),a
    ld a,#F0
    ld (#C000+68),a
    call waste-34
    ;;;;;;;;; ligne161  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+64),a
    ld a,#70
    ld (#C000+66),a
    ld a,#F0
    ld (#C000+67),a
    call waste-46
    ;;;;;;;;; ligne162  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+64),a
    ld a,#0E
    ld (#C000+65),a
    ld a,#F0
    ld (#C000+66),a
    ld a,#10
    ld (#C000+72),a
    ld a,#80
    ld (#C000+77),a
    call waste-34
    ;;;;;;;;; ligne163  ;;;;;;;;;;;
    ld a,#07
    ld (#C000+64),a
    ld a,#1C
    ld (#C000+65),a
    ld a,#00
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne164  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+64),a
    ld a,#38
    ld (#C000+65),a
    ld a,#00
    ld (#C000+70),a
    ld a,#12
    ld (#C000+72),a
    call waste-40
    ;;;;;;;;; ligne165  ;;;;;;;;;;;
    ld a,#01
    ld (#C000+63),a
    ld a,#70
    ld (#C000+65),a
    ld a,#80
    ld (#C000+69),a
    ld a,#02
    ld (#C000+72),a
    ld a,#C0
    ld (#C000+77),a
    call waste-34
    ;;;;;;;;; ligne166  ;;;;;;;;;;;
    ld a,#0E
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+65),a
    ld a,#80
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    ld a,#00
    ld (#C000+72),a
    call waste-34
    ;;;;;;;;; ligne167  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+63),a
    ld a,#1C
    ld (#C000+64),a
    ld a,#C0
    ld (#C000+68),a
    call waste-46
    ;;;;;;;;; ligne168  ;;;;;;;;;;;
    ld a,#38
    ld (#C000+64),a
    ld a,#01
    ld (#C000+72),a
    ld a,#70
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne169  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+64),a
    ld a,#00
    ld (#C000+72),a
    ld a,#E0
    ld (#C000+77),a
    call waste-46
    ;;;;;;;;; ligne170  ;;;;;;;;;;;
    ld a,#E0
    ld (#C000+68),a
    ld a,#07
    ld (#C000+72),a
    call waste-52
    ;;;;;;;;; ligne171  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+71),a
    ld a,#0F
    ld (#C000+72),a
    ld a,#78
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne172  ;;;;;;;;;;;
    ld a,#03
    ld (#C000+70),a
    ld a,#0F
    ld (#C000+71),a
    ld a,#38
    ld (#C000+73),a
    ld a,#F0
    ld (#C000+77),a
    call waste-40
    ;;;;;;;;; ligne173  ;;;;;;;;;;;
    ld a,#30
    ld (#C000+64),a
    ld a,#01
    ld (#C000+69),a
    ld a,#0F
    ld (#C000+70),a
    call waste-46
    ;;;;;;;;; ligne174  ;;;;;;;;;;;
    ld a,#0F
    ld (#C000+69),a
    ld a,#0E
    ld (#C000+72),a
    ld a,#30
    ld (#C000+73),a
    call waste-46
    ;;;;;;;;; ligne175  ;;;;;;;;;;;
    ld a,#F0
    ld (#C000+68),a
    ld a,#07
    ld (#C000+69),a
    ld a,#0E
    ld (#C000+71),a
    ld a,#30
    ld (#C000+72),a
    ld a,#F0
    ld (#C000+73),a
    ld a,#80
    ld (#C000+78),a
    call waste-28
    ;;;;;;;;; ligne176  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+64),a
    ld a,#10
    ld (#C000+71),a
    ld a,#F0
    ld (#C000+72),a
    call waste-46
    ;;;;;;;;; ligne177  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+70),a
    ld a,#F0
    ld (#C000+71),a
    call waste-52
    ;;;;;;;;; ligne178  ;;;;;;;;;;;
    ld a,#90
    ld (#C000+69),a
    ld a,#F0
    ld (#C000+70),a
    ld a,#C0
    ld (#C000+77),a
    ld a,#00
    ld (#C000+78),a
    call waste-40
    ;;;;;;;;; ligne179  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+64),a
    ld a,#F0
    ld (#C000+69),a
    ld a,#C0
    ld (#C000+76),a
    ld a,#00
    ld (#C000+77),a
    call waste-40
    ;;;;;;;;; ligne180  ;;;;;;;;;;;
    ld a,#E0
    ld (#C000+73),a
    ld a,#C0
    ld (#C000+75),a
    ld a,#00
    ld (#C000+76),a
    call waste-46
    ;;;;;;;;; ligne181  ;;;;;;;;;;;
    ld a,#80
    ld (#C000+73),a
    ld a,#C0
    ld (#C000+74),a
    ld a,#00
    ld (#C000+75),a
    call waste-46
    ;;;;;;;;; ligne182  ;;;;;;;;;;;
    ld a,#C0
    ld (#C000+72),a
    ld a,#00
    ld (#C000+73),a
    ld a,#00
    ld (#C000+74),a
    call waste-46
    ;;;;;;;;; ligne183  ;;;;;;;;;;;
    ld a,#70
    ld (#C000+65),a
    ld a,#E0
    ld (#C000+71),a
    ld a,#00
    ld (#C000+72),a
    call waste-46
    ;;;;;;;;; ligne184  ;;;;;;;;;;;
    ld a,#80
    ld (#C000+71),a
    call waste-58
    ;;;;;;;;; ligne185  ;;;;;;;;;;;
    ld a,#10
    ld (#C000+65),a
    ld a,#80
    ld (#C000+70),a
    ld a,#00
    ld (#C000+71),a
    call waste-46
    ;;;;;;;;; ligne186  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+65),a
    ld a,#10
    ld (#C000+66),a
    ld a,#C0
    ld (#C000+69),a
    ld a,#00
    ld (#C000+70),a
    call waste-40
    ;;;;;;;;; ligne187  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+66),a
    ld a,#30
    ld (#C000+67),a
    ld a,#E0
    ld (#C000+68),a
    ld a,#00
    ld (#C000+69),a
    call waste-40
    ;;;;;;;;; ligne188  ;;;;;;;;;;;
    ld a,#00
    ld (#C000+67),a
    ld a,#00
    ld (#C000+68),a
    call waste-52
    ;;;;;;;;; ligne189  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne190  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne191  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne192  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne193  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne194  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne195  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne196  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne197  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne198  ;;;;;;;;;;;
    call waste-64
    ;;;;;;;;; ligne199  ;;;;;;;;;;;
    call waste-55
    ld sp,(stack_save)
    ret
    frame0001_fin


    waste
    stack_save
    stack_context


print ''taille ancienne frame1 :'',{int}frame0001_fin-frame0001,''/'',{hex}frame0001_fin-frame0001, ''/'',(frame0001_fin-frame0001)/1024,'' ko'' 
print ''taille nouvelle frame1 :'',{int}frame1_fin-frame1,''/'',{hex}frame1_fin-frame1, ''/'',(frame1_fin-frame1)/1024,'' ko'' ',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: test
  SELECT id INTO tag_uuid FROM tags WHERE name = 'test';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;

-- Project 176: lsystem by siko
DO $$
DECLARE
  project_uuid uuid := gen_random_uuid();
  tag_uuid uuid;
BEGIN
  INSERT INTO projects (id, user_id, name, description, visibility, is_library, is_sticky, created_at, updated_at)
  VALUES (
    project_uuid,
    'bd6a166d-e0bf-4374-94c3-5222e517d75c'::uuid,
    'lsystem',
    'Imported from z80Code. Author: siko. Lsystem generator',
    'public',
    false,
    false,
    '2019-12-21T00:51:13.977000'::timestamptz,
    '2024-04-15T21:46:17.101000'::timestamptz
  );

  INSERT INTO project_files (project_id, name, content, is_main, "order")
  VALUES (
    project_uuid,
    'main.asm',
    ';Lsystem - Example 1 : audio + gfx

;Stephane Sikora, 2018

PSG_PERIOD_AL 	 EQU 0
PSG_PERIOD_AH 	 EQU 1
PSG_PERIOD_BL 	 EQU 2
PSG_PERIOD_BH 	 EQU 3
PSG_PERIOD_CL 	 EQU 4
PSG_PERIOD_CH 	 EQU 5
PSG_NOISE 		 EQU 6 ; 0-31
PSG_CTRL 		 EQU 7
PSG_VOLA 		 EQU 8
PSG_VOLB 		 EQU 9
PSG_VOLC 		 EQU 10
PSG_ENV_PERIODEL EQU 11
PSG_ENV_PERIODEH EQU 12
PSG_ENV_SHAPE    EQU 13


PSG_CTRL_BIT_ENA	  EQU 0 ; Si a 0, on a du son
PSG_CTRL_BIT_ENB	  EQU 1
PSG_CTRL_BIT_ENC	  EQU 2
PSG_CTRL_BIT_NOISEA	  EQU 3 ; Si a 0, on a du noise
PSG_CTRL_BIT_NOISEB	  EQU 4
PSG_CTRL_BIT_NOISEC	  EQU 5
PSG_CTRL_BIT_SELAUDIO EQU 6 ; Pour selectionner le clavier/L''audio

PSG_CTRL_MUTE_A EQU (1<<PSG_CTRL_BIT_ENA)
PSG_CTRL_MUTE_B EQU (1<<PSG_CTRL_BIT_ENB)
PSG_CTRL_MUTE_C EQU (1<<PSG_CTRL_BIT_ENC)

PSG_CTRL_MUTE_NOISE_A EQU (1<<PSG_CTRL_BIT_NOISEA)
PSG_CTRL_MUTE_NOISE_B EQU (1<<PSG_CTRL_BIT_NOISEB)
PSG_CTRL_MUTE_NOISE_C EQU (1<<PSG_CTRL_BIT_NOISEC)

PSG_CTRL_SEL_AUDIO EQU (1<<PSG_CTRL_BIT_SELAUDIO)

; Controle du pitch des notes pour A,B,C
; Codé sur 12 bits
; Periode = 62500/Freq 
MACRO PSG_Periode freq
dw 62500/{freq}
MEND

MACRO PSG_FREQTABLE freqbase
	f={freqbase}
	REPEAT 12,cnt
		f=f*1.059463
		PSG_Periode f		
		print {freqbase},cnt,f,62500/f
	REND
MEND

MACRO PSG_NOTE freqbase,noterel
	f={freqbase}
	REPEAT {noterel},cnt
		f=f*1.059463
	REND
	PSG_Periode f
	print {freqbase},f,62500/f
MEND

; Routine de lecture de registre du  psg  (par madram)
; Recuperer reg 8,9,10 pour les volumes
;
MACRO PSGREADREG_A
	 LD BC,#F782
     OUT (C),C
     LD B,#F4     ; Selectionne le
     OUT (C),A    ; Registre
     LD BC,#F6C0  ;Paf!
     OUT (C),C
     XOR A
     OUT (C),A
     LD BC,#F792
     OUT (C),C
     LD BC,#F640
     OUT (C),C
     LD B,#F4     ; Ici on vient lire
     IN A,(C)     ; sa valeur
     LD BC,#F782
     OUT (C),C
     LD BC,#F600
     OUT (C),C
MEND


; CE: E contient le numéro de registre à écrire
;     A contient la valeur
; CS: B,C,D modifiés

macro PSG_SET_REG
	ld   D,0
	ld   B,#f4
	out  (C),E
	ld   BC,#f6c0
	out  (C),C	
	out  (C),D
	ld   B,#f4
	out  (C),A
	ld   BC,#f680
	out  (C),C	
	out  (C),D
mend


; PSG_440hz = #08E


struct state
 x dw 0
 y dw 0
 col db 0
 angle db 0
 stepangle db 0
 p db 0
endstruct

; Pile des Regles
LSStack EQU #8000
; Pile des contextes
LSContext equ #8100
MAXPROF EQU 8

;
; Symboles:
; ''u,d,l,f'' : se deplacer d''un pixel vers le haux, bas, gauche droite
; ''d,n'' : dessiner/ne pas dessiner lors du deplacemen,t
; ''p'' : dessiner a l''emplacement courant
; ''+,-'': changer la couleur de dessin (-1 +1)
; ''[,]'' : Empiler/Depiler]

org #9000


;include "../lib/toolbox.asm"

	;initialisation audio
	di					;  On coupe les interruptions
	ld 	A,PSG_CTRL_SEL_AUDIO | PSG_CTRL_MUTE_NOISE_A | PSG_CTRL_MUTE_NOISE_B | PSG_CTRL_MUTE_NOISE_C
	ld e,PSG_CTRL
	call set_psg_reg

	ld a,15
	ld e,PSG_VOLA
	call set_psg_reg
	
	ld a,14
	ld e,PSG_VOLB
	call set_psg_reg

	ld a,13
	ld e,PSG_VOLC
	call set_psg_reg

	ei
llp:
	ld hl,#c000
	ld de,#c001
	ld (hl),0
	ld bc,#3fff
	ldir

	; 1er lsystem	
	ld IX,LSStack
	ld (IX+0),3*16
	ld hl,10
	ld de,320
	call lsystem
	
	;call #bb06
	; cls
	ld hl,#c000
	ld de,#c001
	ld (hl),0
	ld bc,#3fff
	ldir

	; Regle A
	ld IX,LSStack
	ld (IX+0),0
	ld hl,200
	ld de,320
	call lsystem
	jp llp

	ret
lsystem:

	ld IY,LSContext
	ld (IY+state.x),e
	ld (IY+state.x+1),d
	ld (IY+state.y),l
	ld (IY+state.y+1),h
	call #BBEA
	ld (IY+state.col),1
	ld (IY+state.p),1
	ld (IY+state.stepangle),1
	ld (IY+state.angle),0	
	di	; On coupe les interruptions
	
	; A-Z => regle
	; a-z => operateur
	; . => fin de la regle (on dépile les regles)
	; [] => on empile le contexte (IY+sizeof struct)
	
mainloop:
ei
	; Recupere l''index courant
	ld a,(IX+0)
	ld e,a
	inc a
	ld (IX+0),a
	; recupere le symbole courant
	ld d,hi(rules)
	ld a,(de)

	; ------------ Interpretation du symbole courant
	
	; Fin de la regle?
	cp ''.'' 
	jp z,end_rule
	
	; Operateur ou regle?
	; si 64-95 => regle
	; si 32-63 ou 96-127 => operateur
	bit 5,a 
	jr nz,operateur
	
	; Empile une regle (A-Z)	
	; Symbole identifiant une regle => index dans les regles
getRuleIndex:
	sub ''A'' ; -''A''
	; *16
	add a
	add a
	add a
	add a
	
	ld b,a
	ld a,ixl			; ixl == compteur sur la profondeur?
	cp MAXPROF
	jp z,endloop
	inc IX 	; Regle suivante. Faire attention a s''arreter
	ld (ix),b
	jp endloop
	
operateur: 
; TODO: 
; Note RASM LD HL,IY ca serait cooool
; car ca compile et ca donne ld HL,0

; On pourait fair un jp (hl) pour directement sauter au code des operateurs, pour ne pas faire des tests successif
; Pour ca il faut aligner le code de chaque opérateur et 
; utiliser des symboles qui sont a la suite les uns des autres (faire des EQU pour ca?)
	cp ''(''
	jr nz,no_push
	push iy
	pop hl
	ld de,hl	
	ld bc,{sizeof}state
	add hl,bc
	push hl
	pop iy	
	ex de,hl
	ldir	
	jp endloop
no_push	
	cp '')''
	jr nz,no_pop
	push iy
	pop hl
	;ld hl,iy
	ld bc,-{sizeof}state
	add hl,bc
	push hl
	pop iy
	;ld iy,hl

	ld l,(IY+state.y)
	ld h,(IY+state.y+1)
	ld e,(IY+state.x)
	ld d,(IY+state.x+1)
	call #BBEA
	
	jp endloop
no_pop:

	cp ''*''
	jr nz,no_mult	
	ld a,(IY+state.stepangle)
	inc a	
	ld (IY+state.stepangle),a	
	jp endloop
no_mult:
	cp ''/''
	jr nz,no_div
	ld a,(IY+state.stepangle)
	dec a	
	ld (IY+state.stepangle),a	
	jp endloop
no_div:
	cp ''+''
	jr nz,no_plus
	ld a,(IY+state.angle)
	ld b,(IY+state.stepangle)
	add b	
	and 63
	ld (IY+state.angle),a	
	jp endloop
no_plus:
	cp ''-''
	jr nz,no_minus
	ld a,(IY+state.angle)
	ld b,(IY+state.stepangle)
	sub b
	;dec a	
	and 63
	ld (IY+state.angle),a	
	jp endloop
no_minus
	cp ''n''
	jr nz,no_noteA
	ld e,PSG_PERIOD_AL
	ld hl,notetable
	call playnote
	jp endloop
no_noteA:
	cp ''o''
	jr nz,no_noteB
	ld e,PSG_PERIOD_BL
	ld hl,notetable+4
	call playnote
	jp endloop
no_noteB:
	cp ''p''
	jr nz,no_noteC
	ld e,PSG_PERIOD_CL
	ld hl,notetable+8
	call playnote
	jp endloop
no_noteC:
	cp ''q''
	jr nz,no_noteProf

	ld a, ixl
	and 2
	ld e,a	
	;ld e,PSG_PERIOD_CL
	ld hl,notetable
	ld a, ixl
	and 254
	;add l
	ld l,a

	call playnote
	jp endloop
no_noteProf:

	; DRAW, vu qu''on a pas rencontré d''autres symboles qui manipulent la tortue

	; DX
	ld a,(IY+state.angle)
	add a
	ld hl,sintab
	ld e,a
	ld d,0
	add hl,de
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld l,(IY+state.x)
	ld h,(IY+state.x+1)
	add hl,bc
	ld (IY+state.x),l
	ld (IY+state.x+1),h
	push HL
		
	; DY
	ld a,(IY+state.angle)
	add 16
	and 63
	add a	
	
	ld hl,sintab
	ld e,a
	ld d,0
	add hl,de
	ld c,(hl)
	inc hl
	ld b,(hl)
	ld l,(IY+state.y)
	ld h,(IY+state.y+1)
	add hl,bc
	ld (IY+state.y),l
	ld (IY+state.y+1),h
	
	; RASTERS

	ld bc,#7f10	
	out (c),c
	ld a,(IY+state.angle)
	and 15
	or #40
	out (c),a

	; DRAW
	pop DE
	call #bbf6

	;ld c,PSG_PERIOD_AL
	;call playnote
		
	ei

	;halt ; pour le son ou pour le draw???
	;call #bd19

	; RASTERS
	ld bc,#7f10	
	out (c),c
	ld a,#54
	out (c),a
	
	di
	
	jr endloop

end_rule:
	; on depile la regle
	ld a,ixl
	or a
	jr z,end_lsystem
	dec ix

endloop:	

	
	; Et on boucle
	jp mainloop

end_lsystem:
	ei
	ret

playnote:
	ld a,(IY+state.angle)
	and 14
	
	ld c,a
	ld b,0
	add hl,bc
	ld a,(hl)	
	call set_psg_reg
	inc hl
	inc e
	ld a,(hl)	
	call set_psg_reg
	halt
	ret
	
set_psg_reg:
	PSG_SET_REG
ret

print $-#9000


freqtable:
	PSG_FREQTABLE 440

align 256
notetable:
	PSG_NOTE 110,0
	PSG_NOTE 110,4
	PSG_NOTE 110,7
	PSG_NOTE 110,11
	PSG_NOTE 220,0
	PSG_NOTE 220,4
	PSG_NOTE 220,7
	PSG_NOTE 220,11
	PSG_NOTE 440,0
	PSG_NOTE 440,4
	PSG_NOTE 440,7
	PSG_NOTE 440,11
	PSG_NOTE 880,0
	PSG_NOTE 880,4
	PSG_NOTE 880,7
	PSG_NOTE 880,11

sintab:
	repeat 64,angle
		dw 12*sin(360*angle/64)
	rend
	
align 256	
rules:

RA: db ''(E)(F)..........''
RB: db ''d---B...........''
RC: db ''d+++qC..........''
RD:	db ''*qddd(+D)(-D)d..''
RE:	db ''qBBBBB+p+E*E....''
RF:	db ''CCCCC-p-F*F.....''
RG:	db ''................''
RH:	db ''................''
RI:	db ''................''

_end

print _end-#9000

print $-#9000

_end:
    
',
    true,
    0
  );

  -- Add z80code tag
  SELECT id INTO tag_uuid FROM tags WHERE name = 'z80code';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;

  -- Add category tag: generative-gfx-audio
  SELECT id INTO tag_uuid FROM tags WHERE name = 'generative-gfx-audio';
  IF tag_uuid IS NOT NULL THEN
    INSERT INTO project_tags (project_id, tag_id) VALUES (project_uuid, tag_uuid);
  END IF;
END $$;
